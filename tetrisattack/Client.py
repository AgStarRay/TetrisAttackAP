import logging
import struct
import typing
from struct import pack

from NetUtils import ClientStatus, color
from worlds.AutoSNIClient import SNIClient
from worlds.tetrisattack.Rom import GOALS_POSITION

if typing.TYPE_CHECKING:
    from SNIClient import SNIContext

snes_logger = logging.getLogger("SNES")

# FXPAK Pro protocol memory mapping used by SNI
ROM_START = 0x000000
WRAM_START = 0xF50000
WRAM_SIZE = 0x20000
SRAM_START = 0xE00000

TETRISATTACK_ROMHASH_START = ROM_START + 0x007FC0
ROMHASH_SIZE = 0x15

GAME_STATE = WRAM_START + 0x02A0
SRAM_CHECK_FLAG = SRAM_START + 0x0000
RECEIVED_ITEM_NUMBER = SRAM_START + 0x0400
RECEIVED_ITEM_ID = SRAM_START + 0x0402
RECEIVED_ITEM_ACTION = SRAM_START + 0x0404
RECEIVED_ITEM_ARG = SRAM_START + 0x0406
RECEIVE_CHECK = SRAM_START + 0x0408
DEATHLINK_TRIGGER = SRAM_START + 0x040C
LOCATION_STAGECLEARLASTSTAGE = SRAM_START + 0x0224
LOCATION_PUZZLE6d10 = SRAM_START + 0x02BB
LOCATION_SECRETPUZZLE6d10 = SRAM_START + 0x02F7
LOCATION_VSEASYSTAGE10 = SRAM_START + 0x0249
LOCATION_VSNORMALSTAGE10 = SRAM_START + 0x0255
LOCATION_VSNORMALSTAGE11 = SRAM_START + 0x0256
LOCATION_VSHARDSTAGE10 = SRAM_START + 0x0261
LOCATION_VSHARDSTAGE11 = SRAM_START + 0x0262
LOCATION_VSHARDSTAGE12 = SRAM_START + 0x0263
LOCATION_VSVHARDSTAGE10 = SRAM_START + 0x026D
LOCATION_VSVHARDSTAGE11 = SRAM_START + 0x026E
LOCATION_VSVHARDSTAGE12 = SRAM_START + 0x026F
LOCATION_VSVHARDNOCONT = SRAM_START + 0x0273

VALID_GAME_STATES = [0x01, 0x02, 0x03, 0x04, 0x05]


class TetrisAttackSNIClient(SNIClient):
    game = "Tetris Attack"
    patch_suffix = ".aptatk"

    async def validate_rom(self, ctx: "SNIContext") -> bool:
        from SNIClient import snes_read

        rom_name = await snes_read(ctx, TETRISATTACK_ROMHASH_START, ROMHASH_SIZE)
        if rom_name is None or rom_name[:6] != b"APTATK":
            return False

        ctx.game = self.game
        ctx.items_handling = 0b111  # remote items
        ctx.rom = rom_name

        return True

    async def game_watcher(self, ctx: "SNIContext") -> None:
        from SNIClient import snes_buffered_write, snes_flush_writes, snes_read

        sram_ready = await snes_read(ctx, SRAM_CHECK_FLAG, 0x1)
        if sram_ready is None:
            return
        if sram_ready[0] != 1:
            return
        game_state = await snes_read(ctx, GAME_STATE, 0x1)
        if game_state is None:
            return
        if game_state[0] not in VALID_GAME_STATES:
            return
        rom = await snes_read(ctx, TETRISATTACK_ROMHASH_START, ROMHASH_SIZE)
        if rom != ctx.rom:
            ctx.rom = None
            return

        # Initial conditions are good, let's interact
        if not ctx.finished_game:
            all_goals = await snes_read(ctx, GOALS_POSITION, 0x3)
            goals_met = False
            if all_goals is not None:
                goals_met = True
                if all_goals[0] != 0:
                    sc_last_stage_clear = await snes_read(ctx, LOCATION_STAGECLEARLASTSTAGE, 0x1)
                    if sc_last_stage_clear is None or sc_last_stage_clear[0] == 0:
                        goals_met = False
                    else:
                        sc_last_stage_clear = await snes_read(ctx, LOCATION_STAGECLEARLASTSTAGE + 0x101, 0x1)
                        if sc_last_stage_clear is None or sc_last_stage_clear[0] == 0:
                            goals_met = False
                if all_goals[1] != 0:
                    # TODO: Implement Puzzle goal
                    goals_met = False
                if all_goals[2] != 0:
                    # TODO: Implement Vs goal
                    goals_met = False
            if goals_met:
                await ctx.send_msgs([{"cmd": "StatusUpdate", "status": ClientStatus.CLIENT_GOAL}])
                ctx.finished_game = True

        # Check if game is ready to receive
        received_item_action = await snes_read(ctx, RECEIVED_ITEM_ACTION, 0x2)
        if received_item_action is None or received_item_action[0] > 0x00:
            return
        received_item_count_bytes = await snes_read(ctx, RECEIVED_ITEM_NUMBER, 0x2)
        if received_item_count_bytes is None:
            return
        receive_check_bytes = await snes_read(ctx, RECEIVE_CHECK, 0x2)
        if receive_check_bytes is None:
            return
        received_item_count = struct.unpack("H", received_item_count_bytes)[0]
        receive_check = struct.unpack("H", receive_check_bytes)[0]
        if received_item_count != receive_check:
            return

        # Look through location checks
        new_checks = []
        for loc_id in ctx.missing_locations:
            # Locations that are separated by a multiple of 1 KiB are the same, meaning they give multiple items
            loc_obtained = await snes_read(ctx, SRAM_START + loc_id % 0x400, 0x1)
            if loc_obtained is not None and loc_obtained[0] != 0:
                location = ctx.location_names.lookup_in_game(loc_id)
                total_locations = len(ctx.missing_locations) + len(ctx.checked_locations)
                new_checks.append(loc_id)
                snes_logger.info(
                    f"New Check: {location} ({len(ctx.checked_locations) + len(new_checks)}/{total_locations})")
        if len(new_checks) > 0:
            for loc_id in new_checks:
                ctx.locations_checked.add(loc_id)
            await ctx.send_msgs([{"cmd": "LocationChecks", "locations": new_checks}])

        # Check for new items
        old_item_count = received_item_count
        action_code = 0
        while received_item_count < len(ctx.items_received):
            item = ctx.items_received[received_item_count]
            received_item_count += 1
            already_obtained = await snes_read(ctx, SRAM_START + item.item % 0x400, 0x1)
            if already_obtained[0] == 0:
                logging.info("Received %s from %s (%s) (%d/%d in list)" % (
                    color(ctx.item_names.lookup_in_game(item.item), "red", "bold"),
                    color(ctx.player_names[item.player], "yellow"),
                    ctx.location_names.lookup_in_slot(item.location, item.player), received_item_count,
                    len(ctx.items_received)))
                snes_buffered_write(ctx, RECEIVED_ITEM_ID, pack("H", item.item))
                snes_buffered_write(ctx, RECEIVED_ITEM_ARG, pack("H", 1))
                action_code = 1
                break
            else:
                logging.info("Already have %s (%d/%d in list)" % (
                    color(ctx.item_names.lookup_in_game(item.item), "red", "bold"), received_item_count,
                    len(ctx.items_received)))
        if received_item_count > old_item_count:
            snes_buffered_write(ctx, RECEIVED_ITEM_ACTION, pack("H", action_code))
            snes_buffered_write(ctx, RECEIVED_ITEM_NUMBER, pack("H", received_item_count))

        await snes_flush_writes(ctx)
