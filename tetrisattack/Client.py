import logging
import struct
import typing
import time
from struct import pack

from NetUtils import ClientStatus, color
from worlds.AutoSNIClient import SNIClient
from worlds.tetrisattack import item_table, location_table
from worlds.tetrisattack.Items import progressive_items
from worlds.tetrisattack.Rom import GOALS_POSITION, DEATHLINKHINT

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
DEATHLINK_EVENT = SRAM_START + 0x0448
DEATHLINK_TRIGGER = SRAM_START + 0x040C
STAGECLEARLASTSTAGE_COMPLETED = SRAM_START + location_table["Stage Clear Last Stage Clear"].code
PUZZLE6D10_COMPLETED = SRAM_START + 0x02BB
SECRETPUZZLE6D10_COMPLETED = SRAM_START + 0x02F7
VSEASYSTAGE10_COMPLETED = SRAM_START + 0x0249
VSNORMALSTAGE10_COMPLETED = SRAM_START + 0x0255
VSNORMALSTAGE11_COMPLETED = SRAM_START + 0x0256
VSHARDSTAGE10_COMPLETED = SRAM_START + 0x0261
VSHARDSTAGE11_COMPLETED = SRAM_START + 0x0262
VSHARDSTAGE12_COMPLETED = SRAM_START + 0x0263
VSVHARDSTAGE10_COMPLETED = SRAM_START + 0x026D
VSVHARDSTAGE11_COMPLETED = SRAM_START + 0x026E
VSVHARDSTAGE12_COMPLETED = SRAM_START + 0x026F
VSVHARDNOCONT_COMPLETED = SRAM_START + 0x0273
SRAM_ARCHIPELAGO_REGION_OFFSET = 0x020
SRAM_ARCHIPELAGO_REGION_END = 0x400
SRAM_ARCHIPELAGO_REGION_LENGTH = SRAM_ARCHIPELAGO_REGION_END - SRAM_ARCHIPELAGO_REGION_OFFSET

VALID_GAME_STATES = [0x01, 0x02, 0x03, 0x04, 0x05]

ACTION_CODE_NOOP = 0
ACTION_CODE_RECEIVED_ITEM = 2
ACTION_CODE_LAST_STAGE = 3
ACTION_CODE_MARK_COMPLETE = 5

STAGE_CLEAR_ROUND_6_CLEAR = SRAM_START + location_table["Stage Clear Round 6 Clear"].code
STAGE_CLEAR_LAST_STAGE_UNLOCK = SRAM_START + item_table["Stage Clear Last Stage"].code
STAGE_CLEAR_SPECIAL_STAGE_TRAP = SRAM_START + item_table["Stage Clear Special Stage Trap"].code


class TetrisAttackSNIClient(SNIClient):
    game = "Tetris Attack"
    patch_suffix = ".aptatk"
    awaiting_deathlink_event = False
    currently_dead = False

    async def validate_rom(self, ctx: "SNIContext") -> bool:
        from SNIClient import snes_read

        rom_name = await snes_read(ctx, TETRISATTACK_ROMHASH_START, ROMHASH_SIZE)
        if rom_name is None or rom_name[:6] != b"APTATK":
            return False

        ctx.game = self.game
        ctx.items_handling = 0b111  # remote items
        ctx.rom = rom_name

        return True

    async def deathlink_kill_player(self, ctx):
        from SNIClient import snes_buffered_write, snes_flush_writes, DeathState
        self.awaiting_deathlink_event = True
        snes_buffered_write(ctx, DEATHLINK_EVENT, pack("H", 1))
        await snes_flush_writes(ctx)
        ctx.death_state = DeathState.dead
        ctx.last_death_link = time.time()

    async def game_watcher(self, ctx: "SNIContext") -> None:
        from SNIClient import snes_buffered_write, snes_flush_writes, snes_read

        sram_ready = await snes_read(ctx, SRAM_CHECK_FLAG, 0x1)
        if sram_ready is None or sram_ready[0] != 1:
            return
        game_state = await snes_read(ctx, GAME_STATE, 0x1)
        if game_state is None or game_state[0] not in VALID_GAME_STATES:
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
                    sc_last_stage_clear = await snes_read(ctx, STAGECLEARLASTSTAGE_COMPLETED, 0x1)
                    if sc_last_stage_clear is None or sc_last_stage_clear[0] == 0:
                        goals_met = False
                    else:
                        sc_last_stage_clear = await snes_read(ctx, STAGECLEARLASTSTAGE_COMPLETED + 0x101, 0x1)
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

        if "Deathlink" not in ctx.tags:
            deathlink_hint = await snes_read(ctx, DEATHLINKHINT, 0x1)
            if deathlink_hint is not None and deathlink_hint[0] != 0:
                await ctx.update_death_link(True)

        # Check if topped out or ran out of moves
        if "DeathLink" in ctx.tags and ctx.last_death_link + 1 < time.time():
            message = ""
            deathlink_trigger = await snes_read(ctx, DEATHLINK_TRIGGER, 0x1)
            if deathlink_trigger is not None and deathlink_trigger[0] > 0:
                if self.awaiting_deathlink_event:
                    self.awaiting_deathlink_event = False
                else:
                    if ctx.slot:
                        message = get_deathlink_message(ctx.player_names[ctx.slot], deathlink_trigger[0])
                self.currently_dead = True
                ctx.last_death_link = time.time()
                snes_buffered_write(ctx, DEATHLINK_TRIGGER, pack("H", 0))
            elif game_state[0] != 5:
                self.currently_dead = False
            if not self.awaiting_deathlink_event:
                await ctx.handle_deathlink_state(self.currently_dead, message)

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

        # Grab the entire Archipelago SRAM region
        sram_bytes = await snes_read(ctx, SRAM_START + SRAM_ARCHIPELAGO_REGION_OFFSET, SRAM_ARCHIPELAGO_REGION_LENGTH)

        # Look through location checks
        new_checks = []
        for loc_id in ctx.missing_locations:
            if not loc_id in ctx.locations_checked:
                # Locations that are separated by a multiple of 1 KiB are the same, meaning they give multiple items
                # The game fills up to bit 6 with the value 0x7F
                loc_obtained = sram_bytes[loc_id % SRAM_ARCHIPELAGO_REGION_END - SRAM_ARCHIPELAGO_REGION_OFFSET]
                if (loc_obtained & 0x40) != 0:
                    location = ctx.location_names.lookup_in_game(loc_id)
                    total_locations = len(ctx.missing_locations) + len(ctx.checked_locations)
                    new_checks.append(loc_id)
                    ctx.locations_checked.add(loc_id)
                    snes_logger.info(
                        f"New check: {location} ({len(ctx.checked_locations) + len(new_checks)}/{total_locations})")
        if len(new_checks) > 0:
            await ctx.send_msgs([{"cmd": "LocationChecks", "locations": new_checks}])

        # Check for new items
        old_item_count = received_item_count
        action_code = ACTION_CODE_NOOP
        while received_item_count < len(ctx.items_received):
            item = ctx.items_received[received_item_count]
            received_item_count += 1
            progressive_count = 0
            for i in range(received_item_count):
                if ctx.items_received[i].item == item.item:
                    progressive_count += 1
            if item.item < SRAM_ARCHIPELAGO_REGION_OFFSET:  # Progressive item
                current_count = get_current_progressive_count(item.item, sram_bytes)
                if current_count < progressive_count:
                    logging.info("Received %s #%d from %s (%s) (%d/%d in list)" % (
                        color(ctx.item_names.lookup_in_game(item.item), "red", "bold"),
                        current_count + 1,
                        color(ctx.player_names[item.player], "yellow"),
                        ctx.location_names.lookup_in_slot(item.location, item.player), received_item_count,
                        len(ctx.items_received)))
                    item_id_range = get_progressive_item_addr_range(item.item)
                    new_item_id = item_id_range[0] + current_count
                    if new_item_id >= item_id_range[1]:
                        raise Exception(
                            f"Too many copies of {ctx.item_names.lookup_in_game(item.item)} to fit into SRAM, maximum of {item_id_range[1] - item_id_range[0]}")
                    snes_buffered_write(ctx, RECEIVED_ITEM_ID, pack("H", new_item_id))
                    snes_buffered_write(ctx, RECEIVED_ITEM_ARG, pack("H", 1))
                    action_code = ACTION_CODE_RECEIVED_ITEM
                    break
                else:
                    logging.info("Already have %d copies of %s (%d/%d in list)" % (
                        current_count,
                        color(ctx.item_names.lookup_in_game(item.item), "red", "bold"),
                        received_item_count,
                        len(ctx.items_received)))
            else:  # Unique item
                already_obtained = sram_bytes[item.item % SRAM_ARCHIPELAGO_REGION_END - SRAM_ARCHIPELAGO_REGION_OFFSET]
                if already_obtained < progressive_count:
                    logging.info("Received %s from %s (%s) (%d/%d in list)" % (
                        color(ctx.item_names.lookup_in_game(item.item), "red", "bold"),
                        color(ctx.player_names[item.player], "yellow"),
                        ctx.location_names.lookup_in_slot(item.location, item.player), received_item_count,
                        len(ctx.items_received)))
                    snes_buffered_write(ctx, RECEIVED_ITEM_ID, pack("H", item.item))
                    snes_buffered_write(ctx, RECEIVED_ITEM_ARG, pack("H", progressive_count))
                    action_code = ACTION_CODE_RECEIVED_ITEM
                    break
                else:
                    logging.info("Already have %s (%d/%d in list)" % (
                        color(ctx.item_names.lookup_in_game(item.item), "red", "bold"), received_item_count,
                        len(ctx.items_received)))
        if received_item_count > old_item_count:
            snes_buffered_write(ctx, RECEIVED_ITEM_ACTION, pack("H", action_code))
            snes_buffered_write(ctx, RECEIVED_ITEM_NUMBER, pack("H", received_item_count))
        else:  # Check for collected locations
            collected_loc = 0
            collection_bitmask = 0
            for loc_id in ctx.checked_locations:
                # The multiple of 0x400 determines the bit to look at; if enough bits are set this way,
                #   the game will stop displaying the AP sprite even if not completed locally
                loc_obtained = sram_bytes[loc_id % SRAM_ARCHIPELAGO_REGION_END - SRAM_ARCHIPELAGO_REGION_OFFSET]
                bitmask = 1 << (loc_id // SRAM_ARCHIPELAGO_REGION_END)
                if (loc_obtained & bitmask) == 0:
                    location = ctx.location_names.lookup_in_game(loc_id)
                    snes_logger.info(f"Marking as collected ingame: {location}")
                    collected_loc = loc_id % SRAM_ARCHIPELAGO_REGION_END
                    collection_bitmask = bitmask
                    break
            if collected_loc != 0:
                snes_buffered_write(ctx, RECEIVED_ITEM_ID, pack("H", collected_loc))
                snes_buffered_write(ctx, RECEIVED_ITEM_ARG, pack("H", collection_bitmask))
                snes_buffered_write(ctx, RECEIVED_ITEM_ACTION, pack("H", ACTION_CODE_MARK_COMPLETE))
                snes_buffered_write(ctx, RECEIVE_CHECK, pack("H", 0xFFFF))

        await snes_flush_writes(ctx)


def get_current_progressive_count(item_id: int, sram_bytes: bytes) -> int:
    item_id_range = get_progressive_item_addr_range(item_id)
    if item_id_range[1] <= item_id_range[0] + 1:
        return sram_bytes[item_id_range[0] - SRAM_ARCHIPELAGO_REGION_OFFSET]
    current_count = 0
    for i in range(item_id_range[0], item_id_range[1]):
        if sram_bytes[i - SRAM_ARCHIPELAGO_REGION_OFFSET] > 0:
            current_count += 1
    return current_count


def get_progressive_item_addr_range(item_id) -> (int, int):
    """Returns the address range of the provided item ID, exclusive end"""
    item = progressive_items[item_id]
    return item.starting_id, item.starting_id + item.amount


def get_deathlink_message(player_name, deathlink_code) -> str:
    match deathlink_code:
        case 1:
            return f"{player_name} topped out"
        case 2:
            return f"{player_name} couldn't keep things simple"
        case 3:
            return f"{player_name} couldn't do Chains and Combos"
        case 4:
            return f"{player_name} ran out of moves"
        case 5:
            return f"{player_name} let the puzzle rise too high"
        case 16:
            return f"{player_name} lost to Lakitu"
        case 17:
            return f"{player_name} lost to Bumpty"
        case 18:
            return f"{player_name} lost to Poochy"
        case 19:
            return f"{player_name} lost to Flying Wiggler"
        case 20:
            return f"{player_name} lost to Froggy"
        case 21:
            return f"{player_name} lost to Gargantua Blargg"
        case 22:
            return f"{player_name} lost to Lunge Fish"
        case 23:
            return f"{player_name} lost to Raphael the Raven"
        case 24:
            return f"{player_name} lost to Hookbill the Koopa"
        case 25:
            return f"{player_name} lost to Naval Piranha"
        case 26:
            return f"{player_name} lost to Kamek"
        case 27:
            return f"{player_name} lost to Bowser"
        case _:
            return f"{player_name} died somehow ({deathlink_code})"
