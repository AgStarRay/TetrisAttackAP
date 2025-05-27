from typing import List, Set, Dict, NamedTuple, Optional, TYPE_CHECKING

from BaseClasses import Location
from worlds.generic.Rules import CollectionRule
from .Logic import stage_clear_round_clears_included, stage_clear_individual_clears_included, \
    round_clear_has_special, stage_clear_has_special, puzzle_individual_clears_included, puzzle_round_clears_included, \
    goal_locations_included, normal_puzzle_set_included, extra_puzzle_set_included, versus_stage_clears_included
from .Options import StarterPack, VersusGoal
from .Rom import SRAM_FACTOR
from .data.Constants import versus_stage_names, versus_free_names, versus_clear_prefixes

if TYPE_CHECKING:
    from . import TetrisAttackWorld

SC_GOAL = 1
SC_STAGE_CLEAR = 2
SC_ROUND_CLEAR = 3
SC_SPECIAL = 4
PZ_STAGE_CLEAR = 5
PZ_ROUND_CLEAR = 6
EXTRA_CLEAR = 7
EXTRA_ROUND_CLEAR = 8
VS_CLEAR = 9
VS_FREE = 10
VS_NORMAL = 11
VS_HARD = 12
VS_VHARD = 13


class TetrisAttackLocation(Location):
    game = "Tetris Attack"

    def __init__(self, player: int, name: str = " ", address: int = None, parent=None):
        super().__init__(player, name, address, parent)


class LocationData(NamedTuple):
    region: str
    location_class: int
    code: Optional[int]
    rule: CollectionRule = lambda state: True


location_table: Dict[str, LocationData] = {
    "Stage Clear 1-1 Clear": LocationData("SC Round 1", SC_STAGE_CLEAR, 0x201),
    "Stage Clear 1-2 Clear": LocationData("SC Round 1", SC_STAGE_CLEAR, 0x202),
    "Stage Clear 1-3 Clear": LocationData("SC Round 1", SC_STAGE_CLEAR, 0x203),
    "Stage Clear 1-4 Clear": LocationData("SC Round 1", SC_STAGE_CLEAR, 0x204),
    "Stage Clear 1-5 Clear": LocationData("SC Round 1", SC_STAGE_CLEAR, 0x205),
    "Stage Clear Round 1 Clear": LocationData("SC Round 1", SC_ROUND_CLEAR, 0x200),
    "Stage Clear 2-1 Clear": LocationData("SC Round 2", SC_STAGE_CLEAR, 0x207),
    "Stage Clear 2-2 Clear": LocationData("SC Round 2", SC_STAGE_CLEAR, 0x208),
    "Stage Clear 2-3 Clear": LocationData("SC Round 2", SC_STAGE_CLEAR, 0x209),
    "Stage Clear 2-4 Clear": LocationData("SC Round 2", SC_STAGE_CLEAR, 0x20A),
    "Stage Clear 2-5 Clear": LocationData("SC Round 2", SC_STAGE_CLEAR, 0x20B),
    "Stage Clear Round 2 Clear": LocationData("SC Round 2", SC_ROUND_CLEAR, 0x206),
    "Stage Clear 3-1 Clear": LocationData("SC Round 3", SC_STAGE_CLEAR, 0x20D),
    "Stage Clear 3-2 Clear": LocationData("SC Round 3", SC_STAGE_CLEAR, 0x20E),
    "Stage Clear 3-3 Clear": LocationData("SC Round 3", SC_STAGE_CLEAR, 0x20F),
    "Stage Clear 3-4 Clear": LocationData("SC Round 3", SC_STAGE_CLEAR, 0x210),
    "Stage Clear 3-5 Clear": LocationData("SC Round 3", SC_STAGE_CLEAR, 0x211),
    "Stage Clear Round 3 Clear": LocationData("SC Round 3", SC_ROUND_CLEAR, 0x20C),
    "Stage Clear 4-1 Clear": LocationData("SC Round 4", SC_STAGE_CLEAR, 0x213),
    "Stage Clear 4-2 Clear": LocationData("SC Round 4", SC_STAGE_CLEAR, 0x214),
    "Stage Clear 4-3 Clear": LocationData("SC Round 4", SC_STAGE_CLEAR, 0x215),
    "Stage Clear 4-4 Clear": LocationData("SC Round 4", SC_STAGE_CLEAR, 0x216),
    "Stage Clear 4-5 Clear": LocationData("SC Round 4", SC_STAGE_CLEAR, 0x217),
    "Stage Clear Round 4 Clear": LocationData("SC Round 4", SC_ROUND_CLEAR, 0x212),
    "Stage Clear 5-1 Clear": LocationData("SC Round 5", SC_STAGE_CLEAR, 0x219),
    "Stage Clear 5-2 Clear": LocationData("SC Round 5", SC_STAGE_CLEAR, 0x21A),
    "Stage Clear 5-3 Clear": LocationData("SC Round 5", SC_STAGE_CLEAR, 0x21B),
    "Stage Clear 5-4 Clear": LocationData("SC Round 5", SC_STAGE_CLEAR, 0x21C),
    "Stage Clear 5-5 Clear": LocationData("SC Round 5", SC_STAGE_CLEAR, 0x21D),
    "Stage Clear Round 5 Clear": LocationData("SC Round 5", SC_ROUND_CLEAR, 0x218),
    "Stage Clear 6-1 Clear": LocationData("SC Round 6", SC_STAGE_CLEAR, 0x21F),
    "Stage Clear 6-2 Clear": LocationData("SC Round 6", SC_STAGE_CLEAR, 0x220),
    "Stage Clear 6-3 Clear": LocationData("SC Round 6", SC_STAGE_CLEAR, 0x221),
    "Stage Clear 6-4 Clear": LocationData("SC Round 6", SC_STAGE_CLEAR, 0x222),
    "Stage Clear 6-5 Clear": LocationData("SC Round 6", SC_STAGE_CLEAR, 0x223),
    "Stage Clear Round 6 Clear": LocationData("SC Round 6", SC_ROUND_CLEAR, 0x21E),
    "Stage Clear Last Stage Clear": LocationData("Stage Clear", SC_GOAL, 0x224),
    "Stage Clear 1-1 Special": LocationData("SC Round 1", SC_SPECIAL, 0x201 + (1 << SRAM_FACTOR)),
    "Stage Clear 1-2 Special": LocationData("SC Round 1", SC_SPECIAL, 0x202 + (1 << SRAM_FACTOR)),
    "Stage Clear 1-3 Special": LocationData("SC Round 1", SC_SPECIAL, 0x203 + (1 << SRAM_FACTOR)),
    "Stage Clear 1-4 Special": LocationData("SC Round 1", SC_SPECIAL, 0x204 + (1 << SRAM_FACTOR)),
    "Stage Clear 1-5 Special": LocationData("SC Round 1", SC_SPECIAL, 0x205 + (1 << SRAM_FACTOR)),
    "Stage Clear Round 1 Special": LocationData("SC Round 1", SC_SPECIAL, 0x200 + (1 << SRAM_FACTOR)),
    "Stage Clear 2-1 Special": LocationData("SC Round 2", SC_SPECIAL, 0x207 + (1 << SRAM_FACTOR)),
    "Stage Clear 2-2 Special": LocationData("SC Round 2", SC_SPECIAL, 0x208 + (1 << SRAM_FACTOR)),
    "Stage Clear 2-3 Special": LocationData("SC Round 2", SC_SPECIAL, 0x209 + (1 << SRAM_FACTOR)),
    "Stage Clear 2-4 Special": LocationData("SC Round 2", SC_SPECIAL, 0x20A + (1 << SRAM_FACTOR)),
    "Stage Clear 2-5 Special": LocationData("SC Round 2", SC_SPECIAL, 0x20B + (1 << SRAM_FACTOR)),
    "Stage Clear Round 2 Special": LocationData("SC Round 2", SC_SPECIAL, 0x206 + (1 << SRAM_FACTOR)),
    "Stage Clear 3-1 Special": LocationData("SC Round 3", SC_SPECIAL, 0x20D + (1 << SRAM_FACTOR)),
    "Stage Clear 3-2 Special": LocationData("SC Round 3", SC_SPECIAL, 0x20E + (1 << SRAM_FACTOR)),
    "Stage Clear 3-3 Special": LocationData("SC Round 3", SC_SPECIAL, 0x20F + (1 << SRAM_FACTOR)),
    "Stage Clear 3-4 Special": LocationData("SC Round 3", SC_SPECIAL, 0x210 + (1 << SRAM_FACTOR)),
    "Stage Clear 3-5 Special": LocationData("SC Round 3", SC_SPECIAL, 0x211 + (1 << SRAM_FACTOR)),
    "Stage Clear Round 3 Special": LocationData("SC Round 3", SC_SPECIAL, 0x20C + (1 << SRAM_FACTOR)),
    "Stage Clear 4-1 Special": LocationData("SC Round 4", SC_SPECIAL, 0x213 + (1 << SRAM_FACTOR)),
    "Stage Clear 4-2 Special": LocationData("SC Round 4", SC_SPECIAL, 0x214 + (1 << SRAM_FACTOR)),
    "Stage Clear 4-3 Special": LocationData("SC Round 4", SC_SPECIAL, 0x215 + (1 << SRAM_FACTOR)),
    "Stage Clear 4-4 Special": LocationData("SC Round 4", SC_SPECIAL, 0x216 + (1 << SRAM_FACTOR)),
    "Stage Clear 4-5 Special": LocationData("SC Round 4", SC_SPECIAL, 0x217 + (1 << SRAM_FACTOR)),
    "Stage Clear Round 4 Special": LocationData("SC Round 4", SC_SPECIAL, 0x212 + (1 << SRAM_FACTOR)),
    "Stage Clear 5-1 Special": LocationData("SC Round 5", SC_SPECIAL, 0x219 + (1 << SRAM_FACTOR)),
    "Stage Clear 5-2 Special": LocationData("SC Round 5", SC_SPECIAL, 0x21A + (1 << SRAM_FACTOR)),
    "Stage Clear 5-3 Special": LocationData("SC Round 5", SC_SPECIAL, 0x21B + (1 << SRAM_FACTOR)),
    "Stage Clear 5-4 Special": LocationData("SC Round 5", SC_SPECIAL, 0x21C + (1 << SRAM_FACTOR)),
    "Stage Clear 5-5 Special": LocationData("SC Round 5", SC_SPECIAL, 0x21D + (1 << SRAM_FACTOR)),
    "Stage Clear Round 5 Special": LocationData("SC Round 5", SC_SPECIAL, 0x218 + (1 << SRAM_FACTOR)),
    "Stage Clear 6-1 Special": LocationData("SC Round 6", SC_SPECIAL, 0x21F + (1 << SRAM_FACTOR)),
    "Stage Clear 6-2 Special": LocationData("SC Round 6", SC_SPECIAL, 0x220 + (1 << SRAM_FACTOR)),
    "Stage Clear 6-3 Special": LocationData("SC Round 6", SC_SPECIAL, 0x221 + (1 << SRAM_FACTOR)),
    "Stage Clear 6-4 Special": LocationData("SC Round 6", SC_SPECIAL, 0x222 + (1 << SRAM_FACTOR)),
    "Stage Clear 6-5 Special": LocationData("SC Round 6", SC_SPECIAL, 0x223 + (1 << SRAM_FACTOR)),
    "Stage Clear Round 6 Special": LocationData("SC Round 6", SC_SPECIAL, 0x21E + (1 << SRAM_FACTOR)),

    "Puzzle 1-01 Clear": LocationData("Puzzle L1", PZ_STAGE_CLEAR, 0x25A),
    "Puzzle 1-02 Clear": LocationData("Puzzle L1", PZ_STAGE_CLEAR, 0x25B),
    "Puzzle 1-03 Clear": LocationData("Puzzle L1", PZ_STAGE_CLEAR, 0x25C),
    "Puzzle 1-04 Clear": LocationData("Puzzle L1", PZ_STAGE_CLEAR, 0x25D),
    "Puzzle 1-05 Clear": LocationData("Puzzle L1", PZ_STAGE_CLEAR, 0x25E),
    "Puzzle 1-06 Clear": LocationData("Puzzle L1", PZ_STAGE_CLEAR, 0x25F),
    "Puzzle 1-07 Clear": LocationData("Puzzle L1", PZ_STAGE_CLEAR, 0x260),
    "Puzzle 1-08 Clear": LocationData("Puzzle L1", PZ_STAGE_CLEAR, 0x261),
    "Puzzle 1-09 Clear": LocationData("Puzzle L1", PZ_STAGE_CLEAR, 0x262),
    "Puzzle 1-10 Clear": LocationData("Puzzle L1", PZ_STAGE_CLEAR, 0x263),
    "Puzzle Round 1 Clear": LocationData("Puzzle L1", PZ_ROUND_CLEAR, 0x259),
    "Puzzle 2-01 Clear": LocationData("Puzzle L2", PZ_STAGE_CLEAR, 0x265),
    "Puzzle 2-02 Clear": LocationData("Puzzle L2", PZ_STAGE_CLEAR, 0x266),
    "Puzzle 2-03 Clear": LocationData("Puzzle L2", PZ_STAGE_CLEAR, 0x267),
    "Puzzle 2-04 Clear": LocationData("Puzzle L2", PZ_STAGE_CLEAR, 0x268),
    "Puzzle 2-05 Clear": LocationData("Puzzle L2", PZ_STAGE_CLEAR, 0x269),
    "Puzzle 2-06 Clear": LocationData("Puzzle L2", PZ_STAGE_CLEAR, 0x26A),
    "Puzzle 2-07 Clear": LocationData("Puzzle L2", PZ_STAGE_CLEAR, 0x26B),
    "Puzzle 2-08 Clear": LocationData("Puzzle L2", PZ_STAGE_CLEAR, 0x26C),
    "Puzzle 2-09 Clear": LocationData("Puzzle L2", PZ_STAGE_CLEAR, 0x26D),
    "Puzzle 2-10 Clear": LocationData("Puzzle L2", PZ_STAGE_CLEAR, 0x26E),
    "Puzzle Round 2 Clear": LocationData("Puzzle L2", PZ_ROUND_CLEAR, 0x264),
    "Puzzle 3-01 Clear": LocationData("Puzzle L3", PZ_STAGE_CLEAR, 0x270),
    "Puzzle 3-02 Clear": LocationData("Puzzle L3", PZ_STAGE_CLEAR, 0x271),
    "Puzzle 3-03 Clear": LocationData("Puzzle L3", PZ_STAGE_CLEAR, 0x272),
    "Puzzle 3-04 Clear": LocationData("Puzzle L3", PZ_STAGE_CLEAR, 0x273),
    "Puzzle 3-05 Clear": LocationData("Puzzle L3", PZ_STAGE_CLEAR, 0x274),
    "Puzzle 3-06 Clear": LocationData("Puzzle L3", PZ_STAGE_CLEAR, 0x275),
    "Puzzle 3-07 Clear": LocationData("Puzzle L3", PZ_STAGE_CLEAR, 0x276),
    "Puzzle 3-08 Clear": LocationData("Puzzle L3", PZ_STAGE_CLEAR, 0x277),
    "Puzzle 3-09 Clear": LocationData("Puzzle L3", PZ_STAGE_CLEAR, 0x278),
    "Puzzle 3-10 Clear": LocationData("Puzzle L3", PZ_STAGE_CLEAR, 0x279),
    "Puzzle Round 3 Clear": LocationData("Puzzle L3", PZ_ROUND_CLEAR, 0x26F),
    "Puzzle 4-01 Clear": LocationData("Puzzle L4", PZ_STAGE_CLEAR, 0x27B),
    "Puzzle 4-02 Clear": LocationData("Puzzle L4", PZ_STAGE_CLEAR, 0x27C),
    "Puzzle 4-03 Clear": LocationData("Puzzle L4", PZ_STAGE_CLEAR, 0x27D),
    "Puzzle 4-04 Clear": LocationData("Puzzle L4", PZ_STAGE_CLEAR, 0x27E),
    "Puzzle 4-05 Clear": LocationData("Puzzle L4", PZ_STAGE_CLEAR, 0x27F),
    "Puzzle 4-06 Clear": LocationData("Puzzle L4", PZ_STAGE_CLEAR, 0x280),
    "Puzzle 4-07 Clear": LocationData("Puzzle L4", PZ_STAGE_CLEAR, 0x281),
    "Puzzle 4-08 Clear": LocationData("Puzzle L4", PZ_STAGE_CLEAR, 0x282),
    "Puzzle 4-09 Clear": LocationData("Puzzle L4", PZ_STAGE_CLEAR, 0x283),
    "Puzzle 4-10 Clear": LocationData("Puzzle L4", PZ_STAGE_CLEAR, 0x284),
    "Puzzle Round 4 Clear": LocationData("Puzzle L4", PZ_ROUND_CLEAR, 0x27A),
    "Puzzle 5-01 Clear": LocationData("Puzzle L5", PZ_STAGE_CLEAR, 0x286),
    "Puzzle 5-02 Clear": LocationData("Puzzle L5", PZ_STAGE_CLEAR, 0x287),
    "Puzzle 5-03 Clear": LocationData("Puzzle L5", PZ_STAGE_CLEAR, 0x288),
    "Puzzle 5-04 Clear": LocationData("Puzzle L5", PZ_STAGE_CLEAR, 0x289),
    "Puzzle 5-05 Clear": LocationData("Puzzle L5", PZ_STAGE_CLEAR, 0x28A),
    "Puzzle 5-06 Clear": LocationData("Puzzle L5", PZ_STAGE_CLEAR, 0x28B),
    "Puzzle 5-07 Clear": LocationData("Puzzle L5", PZ_STAGE_CLEAR, 0x28C),
    "Puzzle 5-08 Clear": LocationData("Puzzle L5", PZ_STAGE_CLEAR, 0x28D),
    "Puzzle 5-09 Clear": LocationData("Puzzle L5", PZ_STAGE_CLEAR, 0x28E),
    "Puzzle 5-10 Clear": LocationData("Puzzle L5", PZ_STAGE_CLEAR, 0x28F),
    "Puzzle Round 5 Clear": LocationData("Puzzle L5", PZ_ROUND_CLEAR, 0x285),
    "Puzzle 6-01 Clear": LocationData("Puzzle L6", PZ_STAGE_CLEAR, 0x291),
    "Puzzle 6-02 Clear": LocationData("Puzzle L6", PZ_STAGE_CLEAR, 0x292),
    "Puzzle 6-03 Clear": LocationData("Puzzle L6", PZ_STAGE_CLEAR, 0x293),
    "Puzzle 6-04 Clear": LocationData("Puzzle L6", PZ_STAGE_CLEAR, 0x294),
    "Puzzle 6-05 Clear": LocationData("Puzzle L6", PZ_STAGE_CLEAR, 0x295),
    "Puzzle 6-06 Clear": LocationData("Puzzle L6", PZ_STAGE_CLEAR, 0x296),
    "Puzzle 6-07 Clear": LocationData("Puzzle L6", PZ_STAGE_CLEAR, 0x297),
    "Puzzle 6-08 Clear": LocationData("Puzzle L6", PZ_STAGE_CLEAR, 0x298),
    "Puzzle 6-09 Clear": LocationData("Puzzle L6", PZ_STAGE_CLEAR, 0x299),
    "Puzzle 6-10 Clear": LocationData("Puzzle L6", PZ_STAGE_CLEAR, 0x29A),
    "Puzzle Round 6 Clear": LocationData("Puzzle L6", PZ_ROUND_CLEAR, 0x290),
    "Extra Puzzle 1-01 Clear": LocationData("Extra L1", EXTRA_CLEAR, 0x29C),
    "Extra Puzzle 1-02 Clear": LocationData("Extra L1", EXTRA_CLEAR, 0x29D),
    "Extra Puzzle 1-03 Clear": LocationData("Extra L1", EXTRA_CLEAR, 0x29E),
    "Extra Puzzle 1-04 Clear": LocationData("Extra L1", EXTRA_CLEAR, 0x29F),
    "Extra Puzzle 1-05 Clear": LocationData("Extra L1", EXTRA_CLEAR, 0x2A0),
    "Extra Puzzle 1-06 Clear": LocationData("Extra L1", EXTRA_CLEAR, 0x2A1),
    "Extra Puzzle 1-07 Clear": LocationData("Extra L1", EXTRA_CLEAR, 0x2A2),
    "Extra Puzzle 1-08 Clear": LocationData("Extra L1", EXTRA_CLEAR, 0x2A3),
    "Extra Puzzle 1-09 Clear": LocationData("Extra L1", EXTRA_CLEAR, 0x2A4),
    "Extra Puzzle 1-10 Clear": LocationData("Extra L1", EXTRA_CLEAR, 0x2A5),
    "Extra Puzzle Round 1 Clear": LocationData("Extra L1", EXTRA_ROUND_CLEAR, 0x29B),
    "Extra Puzzle 2-01 Clear": LocationData("Extra L2", EXTRA_CLEAR, 0x2A7),
    "Extra Puzzle 2-02 Clear": LocationData("Extra L2", EXTRA_CLEAR, 0x2A8),
    "Extra Puzzle 2-03 Clear": LocationData("Extra L2", EXTRA_CLEAR, 0x2A9),
    "Extra Puzzle 2-04 Clear": LocationData("Extra L2", EXTRA_CLEAR, 0x2AA),
    "Extra Puzzle 2-05 Clear": LocationData("Extra L2", EXTRA_CLEAR, 0x2AB),
    "Extra Puzzle 2-06 Clear": LocationData("Extra L2", EXTRA_CLEAR, 0x2AC),
    "Extra Puzzle 2-07 Clear": LocationData("Extra L2", EXTRA_CLEAR, 0x2AD),
    "Extra Puzzle 2-08 Clear": LocationData("Extra L2", EXTRA_CLEAR, 0x2AE),
    "Extra Puzzle 2-09 Clear": LocationData("Extra L2", EXTRA_CLEAR, 0x2AF),
    "Extra Puzzle 2-10 Clear": LocationData("Extra L2", EXTRA_CLEAR, 0x2B0),
    "Extra Puzzle Round 2 Clear": LocationData("Extra L2", EXTRA_ROUND_CLEAR, 0x2A6),
    "Extra Puzzle 3-01 Clear": LocationData("Extra L3", EXTRA_CLEAR, 0x2B2),
    "Extra Puzzle 3-02 Clear": LocationData("Extra L3", EXTRA_CLEAR, 0x2B3),
    "Extra Puzzle 3-03 Clear": LocationData("Extra L3", EXTRA_CLEAR, 0x2B4),
    "Extra Puzzle 3-04 Clear": LocationData("Extra L3", EXTRA_CLEAR, 0x2B5),
    "Extra Puzzle 3-05 Clear": LocationData("Extra L3", EXTRA_CLEAR, 0x2B6),
    "Extra Puzzle 3-06 Clear": LocationData("Extra L3", EXTRA_CLEAR, 0x2B7),
    "Extra Puzzle 3-07 Clear": LocationData("Extra L3", EXTRA_CLEAR, 0x2B8),
    "Extra Puzzle 3-08 Clear": LocationData("Extra L3", EXTRA_CLEAR, 0x2B9),
    "Extra Puzzle 3-09 Clear": LocationData("Extra L3", EXTRA_CLEAR, 0x2BA),
    "Extra Puzzle 3-10 Clear": LocationData("Extra L3", EXTRA_CLEAR, 0x2BB),
    "Extra Puzzle Round 3 Clear": LocationData("Extra L3", EXTRA_ROUND_CLEAR, 0x2B1),
    "Extra Puzzle 4-01 Clear": LocationData("Extra L4", EXTRA_CLEAR, 0x2BD),
    "Extra Puzzle 4-02 Clear": LocationData("Extra L4", EXTRA_CLEAR, 0x2BE),
    "Extra Puzzle 4-03 Clear": LocationData("Extra L4", EXTRA_CLEAR, 0x2BF),
    "Extra Puzzle 4-04 Clear": LocationData("Extra L4", EXTRA_CLEAR, 0x2C0),
    "Extra Puzzle 4-05 Clear": LocationData("Extra L4", EXTRA_CLEAR, 0x2C1),
    "Extra Puzzle 4-06 Clear": LocationData("Extra L4", EXTRA_CLEAR, 0x2C2),
    "Extra Puzzle 4-07 Clear": LocationData("Extra L4", EXTRA_CLEAR, 0x2C3),
    "Extra Puzzle 4-08 Clear": LocationData("Extra L4", EXTRA_CLEAR, 0x2C4),
    "Extra Puzzle 4-09 Clear": LocationData("Extra L4", EXTRA_CLEAR, 0x2C5),
    "Extra Puzzle 4-10 Clear": LocationData("Extra L4", EXTRA_CLEAR, 0x2C6),
    "Extra Puzzle Round 4 Clear": LocationData("Extra L4", EXTRA_ROUND_CLEAR, 0x2BC),
    "Extra Puzzle 5-01 Clear": LocationData("Extra L5", EXTRA_CLEAR, 0x2C8),
    "Extra Puzzle 5-02 Clear": LocationData("Extra L5", EXTRA_CLEAR, 0x2C9),
    "Extra Puzzle 5-03 Clear": LocationData("Extra L5", EXTRA_CLEAR, 0x2CA),
    "Extra Puzzle 5-04 Clear": LocationData("Extra L5", EXTRA_CLEAR, 0x2CB),
    "Extra Puzzle 5-05 Clear": LocationData("Extra L5", EXTRA_CLEAR, 0x2CC),
    "Extra Puzzle 5-06 Clear": LocationData("Extra L5", EXTRA_CLEAR, 0x2CD),
    "Extra Puzzle 5-07 Clear": LocationData("Extra L5", EXTRA_CLEAR, 0x2CE),
    "Extra Puzzle 5-08 Clear": LocationData("Extra L5", EXTRA_CLEAR, 0x2CF),
    "Extra Puzzle 5-09 Clear": LocationData("Extra L5", EXTRA_CLEAR, 0x2D0),
    "Extra Puzzle 5-10 Clear": LocationData("Extra L5", EXTRA_CLEAR, 0x2D1),
    "Extra Puzzle Round 5 Clear": LocationData("Extra L5", EXTRA_ROUND_CLEAR, 0x2C7),
    "Extra Puzzle 6-01 Clear": LocationData("Extra L6", EXTRA_CLEAR, 0x2D3),
    "Extra Puzzle 6-02 Clear": LocationData("Extra L6", EXTRA_CLEAR, 0x2D4),
    "Extra Puzzle 6-03 Clear": LocationData("Extra L6", EXTRA_CLEAR, 0x2D5),
    "Extra Puzzle 6-04 Clear": LocationData("Extra L6", EXTRA_CLEAR, 0x2D6),
    "Extra Puzzle 6-05 Clear": LocationData("Extra L6", EXTRA_CLEAR, 0x2D7),
    "Extra Puzzle 6-06 Clear": LocationData("Extra L6", EXTRA_CLEAR, 0x2D8),
    "Extra Puzzle 6-07 Clear": LocationData("Extra L6", EXTRA_CLEAR, 0x2D9),
    "Extra Puzzle 6-08 Clear": LocationData("Extra L6", EXTRA_CLEAR, 0x2DA),
    "Extra Puzzle 6-09 Clear": LocationData("Extra L6", EXTRA_CLEAR, 0x2DB),
    "Extra Puzzle 6-10 Clear": LocationData("Extra L6", EXTRA_CLEAR, 0x2DC),
    "Extra Puzzle Round 6 Clear": LocationData("Extra L6", EXTRA_ROUND_CLEAR, 0x2D2),

    versus_stage_names[0]: LocationData("Overworld", VS_CLEAR, 0x225),
    versus_free_names[0]: LocationData("Overworld", VS_FREE, 0x225 + (1 << SRAM_FACTOR)),
    versus_stage_names[1]: LocationData("Overworld", VS_CLEAR, 0x226),
    versus_free_names[1]: LocationData("Overworld", VS_FREE, 0x226 + (1 << SRAM_FACTOR)),
    versus_stage_names[2]: LocationData("Overworld", VS_CLEAR, 0x227),
    versus_free_names[2]: LocationData("Overworld", VS_FREE, 0x227 + (1 << SRAM_FACTOR)),
    versus_stage_names[3]: LocationData("Overworld", VS_CLEAR, 0x228),
    versus_free_names[3]: LocationData("Overworld", VS_FREE, 0x228 + (1 << SRAM_FACTOR)),
    versus_stage_names[4]: LocationData("Overworld", VS_CLEAR, 0x229),
    versus_free_names[4]: LocationData("Overworld", VS_FREE, 0x229 + (1 << SRAM_FACTOR)),
    versus_stage_names[5]: LocationData("Overworld", VS_CLEAR, 0x22A),
    versus_free_names[5]: LocationData("Overworld", VS_FREE, 0x22A + (1 << SRAM_FACTOR)),
    versus_stage_names[6]: LocationData("Overworld", VS_CLEAR, 0x22B),
    versus_free_names[6]: LocationData("Overworld", VS_FREE, 0x22B + (1 << SRAM_FACTOR)),
    versus_stage_names[7]: LocationData("Overworld", VS_CLEAR, 0x22C),
    versus_free_names[7]: LocationData("Overworld", VS_FREE, 0x22C + (1 << SRAM_FACTOR)),
    versus_stage_names[8]: LocationData("Mt Wickedness", VS_CLEAR, 0x22D),
    versus_stage_names[9]: LocationData("Mt Wickedness", VS_CLEAR, 0x22E),
    versus_stage_names[10]: LocationData("Mt Wickedness", VS_CLEAR, 0x22F),
    versus_stage_names[11]: LocationData("Mt Wickedness", VS_CLEAR, 0x230),
    "All Friends Normal Again": LocationData("Overworld", VS_FREE, 0x235),

    f"{versus_clear_prefixes[0]} Normal Clear": LocationData("Overworld", VS_NORMAL, 0x225 + (4 << SRAM_FACTOR)),
    f"{versus_clear_prefixes[1]} Normal Clear": LocationData("Overworld", VS_NORMAL, 0x226 + (4 << SRAM_FACTOR)),
    f"{versus_clear_prefixes[2]} Normal Clear": LocationData("Overworld", VS_NORMAL, 0x227 + (4 << SRAM_FACTOR)),
    f"{versus_clear_prefixes[3]} Normal Clear": LocationData("Overworld", VS_NORMAL, 0x228 + (4 << SRAM_FACTOR)),
    f"{versus_clear_prefixes[4]} Normal Clear": LocationData("Overworld", VS_NORMAL, 0x229 + (4 << SRAM_FACTOR)),
    f"{versus_clear_prefixes[5]} Normal Clear": LocationData("Overworld", VS_NORMAL, 0x22A + (4 << SRAM_FACTOR)),
    f"{versus_clear_prefixes[6]} Normal Clear": LocationData("Overworld", VS_NORMAL, 0x22B + (4 << SRAM_FACTOR)),
    f"{versus_clear_prefixes[7]} Normal Clear": LocationData("Overworld", VS_NORMAL, 0x22C + (4 << SRAM_FACTOR)),
    f"{versus_clear_prefixes[8]} Normal Clear": LocationData("Mt Wickedness", VS_NORMAL, 0x22D + (4 << SRAM_FACTOR)),
    f"{versus_clear_prefixes[9]} Normal Clear": LocationData("Mt Wickedness", VS_NORMAL, 0x22E + (4 << SRAM_FACTOR)),
    f"{versus_clear_prefixes[10]} Normal Clear": LocationData("Mt Wickedness", VS_NORMAL, 0x22F + (4 << SRAM_FACTOR)),
    f"{versus_clear_prefixes[11]} Normal Clear": LocationData("Mt Wickedness", VS_NORMAL, 0x230 + (4 << SRAM_FACTOR)),
    f"{versus_clear_prefixes[0]} Hard Clear": LocationData("Overworld", VS_HARD, 0x225 + (5 << SRAM_FACTOR)),
    f"{versus_clear_prefixes[1]} Hard Clear": LocationData("Overworld", VS_HARD, 0x226 + (5 << SRAM_FACTOR)),
    f"{versus_clear_prefixes[2]} Hard Clear": LocationData("Overworld", VS_HARD, 0x227 + (5 << SRAM_FACTOR)),
    f"{versus_clear_prefixes[3]} Hard Clear": LocationData("Overworld", VS_HARD, 0x228 + (5 << SRAM_FACTOR)),
    f"{versus_clear_prefixes[4]} Hard Clear": LocationData("Overworld", VS_HARD, 0x229 + (5 << SRAM_FACTOR)),
    f"{versus_clear_prefixes[5]} Hard Clear": LocationData("Overworld", VS_HARD, 0x22A + (5 << SRAM_FACTOR)),
    f"{versus_clear_prefixes[6]} Hard Clear": LocationData("Overworld", VS_HARD, 0x22B + (5 << SRAM_FACTOR)),
    f"{versus_clear_prefixes[7]} Hard Clear": LocationData("Overworld", VS_HARD, 0x22C + (5 << SRAM_FACTOR)),
    f"{versus_clear_prefixes[8]} Hard Clear": LocationData("Mt Wickedness", VS_HARD, 0x22D + (5 << SRAM_FACTOR)),
    f"{versus_clear_prefixes[9]} Hard Clear": LocationData("Mt Wickedness", VS_HARD, 0x22E + (5 << SRAM_FACTOR)),
    f"{versus_clear_prefixes[10]} Hard Clear": LocationData("Mt Wickedness", VS_HARD, 0x22F + (5 << SRAM_FACTOR)),
    f"{versus_clear_prefixes[11]} Hard Clear": LocationData("Mt Wickedness", VS_HARD, 0x230 + (5 << SRAM_FACTOR)),
    f"{versus_clear_prefixes[0]} V.Hard Clear": LocationData("Overworld", VS_VHARD, 0x225 + (6 << SRAM_FACTOR)),
    f"{versus_clear_prefixes[1]} V.Hard Clear": LocationData("Overworld", VS_VHARD, 0x226 + (6 << SRAM_FACTOR)),
    f"{versus_clear_prefixes[2]} V.Hard Clear": LocationData("Overworld", VS_VHARD, 0x227 + (6 << SRAM_FACTOR)),
    f"{versus_clear_prefixes[3]} V.Hard Clear": LocationData("Overworld", VS_VHARD, 0x228 + (6 << SRAM_FACTOR)),
    f"{versus_clear_prefixes[4]} V.Hard Clear": LocationData("Overworld", VS_VHARD, 0x229 + (6 << SRAM_FACTOR)),
    f"{versus_clear_prefixes[5]} V.Hard Clear": LocationData("Overworld", VS_VHARD, 0x22A + (6 << SRAM_FACTOR)),
    f"{versus_clear_prefixes[6]} V.Hard Clear": LocationData("Overworld", VS_VHARD, 0x22B + (6 << SRAM_FACTOR)),
    f"{versus_clear_prefixes[7]} V.Hard Clear": LocationData("Overworld", VS_VHARD, 0x22C + (6 << SRAM_FACTOR)),
    f"{versus_clear_prefixes[8]} V.Hard Clear": LocationData("Mt Wickedness", VS_VHARD, 0x22D + (6 << SRAM_FACTOR)),
    f"{versus_clear_prefixes[9]} V.Hard Clear": LocationData("Mt Wickedness", VS_VHARD, 0x22E + (6 << SRAM_FACTOR)),
    f"{versus_clear_prefixes[10]} V.Hard Clear": LocationData("Mt Wickedness", VS_VHARD, 0x22F + (6 << SRAM_FACTOR)),
    f"{versus_clear_prefixes[11]} V.Hard Clear": LocationData("Mt Wickedness", VS_VHARD, 0x230 + (6 << SRAM_FACTOR)),
}


def get_locations(world: Optional["TetrisAttackWorld"]) -> Dict[str, LocationData]:
    include_stage_clear = True
    include_sc_round_clears = True
    include_sc_individual_clears = True
    exclude_sc_round_6_last_check = True
    include_pz_round_clears = True
    include_pz_individual_clears = True
    include_extra_round_clears = True
    include_extra_individual_clears = True
    include_vs_stage_clears = True
    multiple_goals = True
    special_stage_trap_count = 1
    if world:
        include_stage_clear = world.options.stage_clear_goal or world.options.stage_clear_inclusion
        include_sc_round_clears = stage_clear_round_clears_included(world)
        include_sc_individual_clears = stage_clear_individual_clears_included(world)
        exclude_sc_round_6_last_check = world.options.starter_pack != StarterPack.option_stage_clear_round_6
        include_normal_puzzles = normal_puzzle_set_included(world)
        include_extra_puzzles = extra_puzzle_set_included(world)
        puzzle_round_clears = puzzle_round_clears_included(world)
        puzzle_individual_clears = puzzle_individual_clears_included(world)
        include_pz_round_clears = puzzle_round_clears and include_normal_puzzles
        include_pz_individual_clears = puzzle_individual_clears and include_normal_puzzles
        include_extra_round_clears = puzzle_round_clears and include_extra_puzzles
        include_extra_individual_clears = puzzle_individual_clears and include_extra_puzzles
        include_vs_stage_clears = versus_stage_clears_included(world)
        special_stage_trap_count = world.options.special_stage_trap_count
        multiple_goals = goal_locations_included(world)

    excluded_locations: Set[str] = set()
    if not multiple_goals:
        excluded_locations.add("Stage Clear Last Stage Clear")
        excluded_locations.add("Puzzle Round 6 Clear")

    included_classes: List[int] = []
    if include_stage_clear:
        included_classes.append(SC_GOAL)
        included_classes.append(SC_SPECIAL)
    if include_sc_round_clears:
        included_classes.append(SC_ROUND_CLEAR)
    if include_sc_individual_clears:
        included_classes.append(SC_STAGE_CLEAR)
    if include_pz_round_clears:
        included_classes.append(PZ_ROUND_CLEAR)
    if include_pz_individual_clears:
        included_classes.append(PZ_STAGE_CLEAR)
    if include_extra_round_clears:
        included_classes.append(EXTRA_ROUND_CLEAR)
    if include_extra_individual_clears:
        included_classes.append(EXTRA_CLEAR)
    if include_vs_stage_clears:
        included_classes.append(VS_CLEAR)
        included_classes.append(VS_FREE)
    if exclude_sc_round_6_last_check:
        if include_sc_round_clears:
            excluded_locations.add("Stage Clear Round 6 Clear")
        else:
            excluded_locations.add("Stage Clear 6-5 Clear")
    for r in range(1, 7):
        if not round_clear_has_special(r, special_stage_trap_count):
            excluded_locations.add(f"Stage Clear Round {r} Special")
        for s in range(1, 6):
            if not stage_clear_has_special(r, s, special_stage_trap_count):
                excluded_locations.add(f"Stage Clear {r}-{s} Special")
    if world.options.versus_goal == VersusGoal.option_easy:
        excluded_locations.add(versus_stage_names[10])
        excluded_locations.add(f"{versus_clear_prefixes[10]} Normal Clear")
        excluded_locations.add(f"{versus_clear_prefixes[10]} Hard Clear")
        excluded_locations.add(f"{versus_clear_prefixes[10]} V.Hard Clear")
    if world.options.versus_goal == VersusGoal.option_easy or world.options.versus_goal == VersusGoal.option_normal:
        excluded_locations.add(versus_stage_names[11])
        excluded_locations.add(f"{versus_clear_prefixes[11]} Normal Clear")
        excluded_locations.add(f"{versus_clear_prefixes[11]} Hard Clear")
        excluded_locations.add(f"{versus_clear_prefixes[11]} V.Hard Clear")
    excluded_locations.add(f"{versus_clear_prefixes[11]} Normal Clear")

    new_locations = dict(
        filter(lambda item: item[1].location_class in included_classes and item[0] not in excluded_locations,
               location_table.items()))

    return new_locations
