import pkgutil
from typing import Optional, TYPE_CHECKING, Iterable, Dict, Sequence
import hashlib
import Utils
import os

import settings
from worlds.Files import APProcedurePatch, APTokenMixin, APTokenTypes
from .Logic import stage_clear_individual_clears_included, stage_clear_round_clears_included, \
    stage_clear_individual_unlocks_included, stage_clear_round_gates_included, stage_clear_progressive_unlocks_included
from .Options import StarterPack, StageClearMode

if TYPE_CHECKING:
    from . import TetrisAttackWorld

USAHASH = "44bb94606356f1c0965e12bbc50866b3"

ARCHIPELAGO_DATA = 0x100000
GOALS_POSITION = ARCHIPELAGO_DATA + 0x000
SCMODE = ARCHIPELAGO_DATA + 0x003
DEATHLINKHINT = ARCHIPELAGO_DATA + 0x006
SCROUND1CHECKS = ARCHIPELAGO_DATA + 0x020
SCROUND2CHECKS = ARCHIPELAGO_DATA + 0x026
SCROUND3CHECKS = ARCHIPELAGO_DATA + 0x02C
SCROUND4CHECKS = ARCHIPELAGO_DATA + 0x032
SCROUND5CHECKS = ARCHIPELAGO_DATA + 0x038
SCROUND6CHECKS = ARCHIPELAGO_DATA + 0x03E
SCLASTSTAGECHECKS = ARCHIPELAGO_DATA + 0x044
SCSPECIALSTAGECOUNT = ARCHIPELAGO_DATA + 0x045
VSSTAGECHECKS = ARCHIPELAGO_DATA + 0x046
VSCHARACTERCHECKS = ARCHIPELAGO_DATA + 0x052
PUZZLEW1CHECKS = ARCHIPELAGO_DATA + 0x060
PUZZLEW2CHECKS = ARCHIPELAGO_DATA + 0x06B
PUZZLEW3CHECKS = ARCHIPELAGO_DATA + 0x076
PUZZLEW4CHECKS = ARCHIPELAGO_DATA + 0x081
PUZZLEW5CHECKS = ARCHIPELAGO_DATA + 0x08C
PUZZLEW6CHECKS = ARCHIPELAGO_DATA + 0x097
PUZZLESW1CHECKS = ARCHIPELAGO_DATA + 0x0A2
PUZZLESW2CHECKS = ARCHIPELAGO_DATA + 0x0AD
PUZZLESW3CHECKS = ARCHIPELAGO_DATA + 0x0B8
PUZZLESW4CHECKS = ARCHIPELAGO_DATA + 0x0C3
PUZZLESW5CHECKS = ARCHIPELAGO_DATA + 0x0CE
PUZZLESW6CHECKS = ARCHIPELAGO_DATA + 0x0D9
INITIAL_UNLOCKS = ARCHIPELAGO_DATA + 0x100


class RomData:
    def __init__(self, file: bytes, name: str = "") -> None:
        self.file = bytearray(file)
        self.name = name

    def read_byte(self, offset: int) -> int:
        return self.file[offset]

    def read_bytes(self, offset: int, length: int) -> bytearray:
        return self.file[offset:offset + length]

    def write_byte(self, offset: int, value: int) -> None:
        self.file[offset] = value

    def write_bytes(self, offset: int, values: Sequence[int]) -> None:
        self.file[offset:offset + len(values)] = values

    def write_to_file(self, file: str) -> None:
        with open(file, 'wb') as outfile:
            outfile.write(self.file)


class TATKProcedurePatch(APProcedurePatch, APTokenMixin):
    hash = [USAHASH]
    game = "Tetris Attack"
    patch_file_ending = ".aptatk"
    result_file_ending = ".sfc"
    name: bytearray
    procedure = [
        ("apply_bsdiff4", ["tatk_basepatch.bsdiff4"]),
        ("apply_tokens", ["token_patch.bin"]),
    ]

    @classmethod
    def get_source_data(cls) -> bytes:
        return get_base_rom_bytes()

    def write_byte(self, offset: int, value: int) -> None:
        self.write_token(APTokenTypes.WRITE, offset, value.to_bytes(1, "little"))

    def write_bytes(self, offset: int, value: Iterable[int]) -> None:
        self.write_token(APTokenTypes.WRITE, offset, bytes(value))


def patch_rom(world: "TetrisAttackWorld", patch: TATKProcedurePatch) -> None:
    patch.write_file("tatk_basepatch.bsdiff4", pkgutil.get_data(__name__, "data/tatk_basepatch.bsdiff4"))
    patch.write_bytes(GOALS_POSITION, [0x1, 0x0, 0x0])
    sc_mode = 0b00000
    match world.options.stage_clear_mode:
        case StageClearMode.option_incremental \
             | StageClearMode.option_incremental_with_round_gate:
            sc_mode = 0b00001
        case StageClearMode.option_skippable \
             | StageClearMode.option_skippable_with_round_gate:
            sc_mode = 0b00011
    if world.options.stage_clear_saves:
        sc_mode |= 0b00100
    if world.options.starter_pack != StarterPack.option_stage_clear_round_6:
        sc_mode |= 0b10000
    patch.write_byte(SCMODE, sc_mode)
    patch.write_byte(DEATHLINKHINT, 1 if world.options.death_link else 0)
    ic_inc = stage_clear_individual_clears_included(world)
    rc_inc = stage_clear_round_clears_included(world)
    for x in range(0, 6):
        patch.write_bytes(SCROUND1CHECKS + x * 6, [ic_inc, ic_inc, ic_inc, ic_inc, ic_inc, rc_inc])
    patch.write_byte(SCLASTSTAGECHECKS, 0b00)
    patch.write_byte(SCSPECIALSTAGECOUNT, 0b00)
    patch.write_bytes(VSSTAGECHECKS, [0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00])
    patch.write_bytes(VSCHARACTERCHECKS, [0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00])
    patch.write_bytes(PUZZLEW1CHECKS, [0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00])
    patch.write_bytes(PUZZLEW2CHECKS, [0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00])
    patch.write_bytes(PUZZLEW3CHECKS, [0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00])
    patch.write_bytes(PUZZLEW4CHECKS, [0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00])
    patch.write_bytes(PUZZLEW5CHECKS, [0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00])
    patch.write_bytes(PUZZLEW6CHECKS, [0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00])
    patch.write_bytes(PUZZLESW1CHECKS, [0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00])
    patch.write_bytes(PUZZLESW2CHECKS, [0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00])
    patch.write_bytes(PUZZLESW3CHECKS, [0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00])
    patch.write_bytes(PUZZLESW4CHECKS, [0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00])
    patch.write_bytes(PUZZLESW5CHECKS, [0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00])
    patch.write_bytes(PUZZLESW6CHECKS, [0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00, 0b00])
    other_stages_already_unlocked = not (stage_clear_individual_unlocks_included(world)
                                         or stage_clear_progressive_unlocks_included(world))
    first_stage_already_unlocked = other_stages_already_unlocked
    gate_already_unlocked = not stage_clear_round_gates_included(world)
    for x in range(0, 6):
        is_initial_round = (world.options.starter_pack == StarterPack.option_stage_clear_round_1 + x)
        s1_unlock = first_stage_already_unlocked or is_initial_round
        sx_unlock = other_stages_already_unlocked or is_initial_round
        gate_unlocked = gate_already_unlocked or is_initial_round
        patch.write_bytes(INITIAL_UNLOCKS + 6 * x, [
            s1_unlock, sx_unlock, sx_unlock, sx_unlock, sx_unlock, gate_unlocked
        ])

    from Utils import __version__
    patch.name = bytearray(f'APTATK{__version__.replace(".", "")[0:3]}{world.player}{world.multiworld.seed:11}\0',
                           'utf8')[:21]
    patch.name.extend([0] * (21 - len(patch.name)))
    patch.write_bytes(0x007FC0, patch.name)
    patch.write_byte(0x007FDB, world.world_version)

    patch.write_file("token_patch.bin", patch.get_token_binary())


def get_base_rom_bytes(file_name: str = "") -> bytes:
    base_rom_bytes = getattr(get_base_rom_bytes, "base_rom_bytes", None)
    if not base_rom_bytes:
        file_name = get_base_rom_path(file_name)
        base_rom_bytes = bytes(Utils.read_snes_rom(open(file_name, "rb")))

        basemd5 = hashlib.md5()
        basemd5.update(base_rom_bytes)
        if USAHASH != basemd5.hexdigest():
            raise Exception("Supplied Base Rom does not match known MD5 for US(1.0) release. "
                            "Get the correct game and version, then dump it")
        get_base_rom_bytes.base_rom_bytes = base_rom_bytes
    return base_rom_bytes


def get_base_rom_path(file_name: str = "") -> str:
    options: settings.Settings = settings.get_settings()
    if not file_name:
        file_name = options["tetrisattack_options"]["rom_file"]
    if not os.path.exists(file_name):
        file_name = Utils.user_path(file_name)
    return file_name
