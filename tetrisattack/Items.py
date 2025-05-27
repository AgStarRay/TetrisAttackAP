from typing import List, Set, Dict, NamedTuple, Optional, TYPE_CHECKING

from BaseClasses import ItemClassification
from .Logic import stage_clear_progressive_unlocks_included, stage_clear_individual_unlocks_included, \
    stage_clear_round_gates_included, puzzle_progressive_unlocks_included, puzzle_individual_unlocks_included, \
    puzzle_level_gates_included, get_starting_sc_round, get_starting_puzzle_level, normal_puzzle_set_included, \
    extra_puzzle_set_included, versus_progressive_unlocks_included, versus_individual_unlocks_included, \
    get_starting_vs_flag
from .Options import StarterPack, VersusGoal, PuzzleMode
from .data.Constants import versus_unlock_names

if TYPE_CHECKING:
    from . import TetrisAttackWorld

FILLER = 0
SC_GOAL = 1
SC_PROGRESSIVE_UNLOCK = 2
SC_INDIVIDUAL_UNLOCK = 3
SC_ROUND_GATE = 4
SC_TRAP = 5
PZ_GOAL = 6
PZ_PROGRESSIVE_UNLOCK = 7
PZ_INDIVIDUAL_UNLOCK = 8
PZ_LEVEL_GATE = 9
EXTRA_PROGRESSIVE_UNLOCK = 10
EXTRA_INDIVIDUAL_UNLOCK = 11
EXTRA_LEVEL_GATE = 12
VS_PROGRESSIVE_UNLOCK = 13
VS_STAGE_UNLOCK = 14
VS_CHARACTER = 15
VS_GATE = 16
VS_GOAL = 17


class ItemData(NamedTuple):
    category: str
    code: Optional[int]
    item_class: int
    classification: ItemClassification
    amount: Optional[int] = 1
    starting_id: Optional[int] = None
    amount2: Optional[int] = None
    starting_id2: Optional[int] = None


item_table: Dict[str, ItemData] = {
    "Stage Clear Progressive Round 1 Unlock": ItemData("SC Round 1", 1, SC_PROGRESSIVE_UNLOCK,
                                                       ItemClassification.progression, 5, 0x021),
    "Stage Clear Progressive Round 2 Unlock": ItemData("SC Round 2", 2, SC_PROGRESSIVE_UNLOCK,
                                                       ItemClassification.progression, 5, 0x027),
    "Stage Clear Progressive Round 3 Unlock": ItemData("SC Round 3", 3, SC_PROGRESSIVE_UNLOCK,
                                                       ItemClassification.progression, 5, 0x02D),
    "Stage Clear Progressive Round 4 Unlock": ItemData("SC Round 4", 4, SC_PROGRESSIVE_UNLOCK,
                                                       ItemClassification.progression, 5, 0x033),
    "Stage Clear Progressive Round 5 Unlock": ItemData("SC Round 5", 5, SC_PROGRESSIVE_UNLOCK,
                                                       ItemClassification.progression, 5, 0x039),
    "Stage Clear Progressive Round 6 Unlock": ItemData("SC Round 6", 6, SC_PROGRESSIVE_UNLOCK,
                                                       ItemClassification.progression, 5, 0x03F),
    "Puzzle Progressive Level 1 Unlock": ItemData("Puzzle L1", 7, PZ_PROGRESSIVE_UNLOCK,
                                                  ItemClassification.progression, 10, 0x061, 0, 0x0A3),
    "Puzzle Progressive Level 2 Unlock": ItemData("Puzzle L2", 8, PZ_PROGRESSIVE_UNLOCK,
                                                  ItemClassification.progression, 10, 0x06C, 0, 0x0AE),
    "Puzzle Progressive Level 3 Unlock": ItemData("Puzzle L3", 9, PZ_PROGRESSIVE_UNLOCK,
                                                  ItemClassification.progression, 10, 0x077, 0, 0x0B9),
    "Puzzle Progressive Level 4 Unlock": ItemData("Puzzle L4", 10, PZ_PROGRESSIVE_UNLOCK,
                                                  ItemClassification.progression, 10, 0x082, 0, 0x0C4),
    "Puzzle Progressive Level 5 Unlock": ItemData("Puzzle L5", 11, PZ_PROGRESSIVE_UNLOCK,
                                                  ItemClassification.progression, 10, 0x08D, 0, 0x0CF),
    "Puzzle Progressive Level 6 Unlock": ItemData("Puzzle L6", 12, PZ_PROGRESSIVE_UNLOCK,
                                                  ItemClassification.progression, 10, 0x098, 0, 0x0DA),
    "Extra Puzzle Progressive Level 1 Unlock": ItemData("Extra L1", 13, EXTRA_PROGRESSIVE_UNLOCK,
                                                        ItemClassification.progression, 10, 0x0A3),
    "Extra Puzzle Progressive Level 2 Unlock": ItemData("Extra L2", 14, EXTRA_PROGRESSIVE_UNLOCK,
                                                        ItemClassification.progression, 10, 0x0AE),
    "Extra Puzzle Progressive Level 3 Unlock": ItemData("Extra L3", 15, EXTRA_PROGRESSIVE_UNLOCK,
                                                        ItemClassification.progression, 10, 0x0B9),
    "Extra Puzzle Progressive Level 4 Unlock": ItemData("Extra L4", 16, EXTRA_PROGRESSIVE_UNLOCK,
                                                        ItemClassification.progression, 10, 0x0C4),
    "Extra Puzzle Progressive Level 5 Unlock": ItemData("Extra L5", 17, EXTRA_PROGRESSIVE_UNLOCK,
                                                        ItemClassification.progression, 10, 0x0CF),
    "Extra Puzzle Progressive Level 6 Unlock": ItemData("Extra L6", 18, EXTRA_PROGRESSIVE_UNLOCK,
                                                        ItemClassification.progression, 10, 0x0DA),
    "Vs. Progressive Stage Unlock": ItemData("Versus", 19, VS_PROGRESSIVE_UNLOCK,
                                             ItemClassification.progression, 12, 0x046),
    # Items with IDs of at least 0x020 correspond to SRAM locations
    "Stage Clear 1-1 Unlock": ItemData("SC Round 1", 0x021, SC_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Stage Clear 1-2 Unlock": ItemData("SC Round 1", 0x022, SC_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Stage Clear 1-3 Unlock": ItemData("SC Round 1", 0x023, SC_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Stage Clear 1-4 Unlock": ItemData("SC Round 1", 0x024, SC_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Stage Clear 1-5 Unlock": ItemData("SC Round 1", 0x025, SC_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Stage Clear Round 1 Gate": ItemData("Stage Clear", 0x020, SC_ROUND_GATE, ItemClassification.progression),
    "Stage Clear 2-1 Unlock": ItemData("SC Round 2", 0x027, SC_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Stage Clear 2-2 Unlock": ItemData("SC Round 2", 0x028, SC_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Stage Clear 2-3 Unlock": ItemData("SC Round 2", 0x029, SC_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Stage Clear 2-4 Unlock": ItemData("SC Round 2", 0x02A, SC_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Stage Clear 2-5 Unlock": ItemData("SC Round 2", 0x02B, SC_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Stage Clear Round 2 Gate": ItemData("Stage Clear", 0x026, SC_ROUND_GATE, ItemClassification.progression),
    "Stage Clear 3-1 Unlock": ItemData("SC Round 3", 0x02D, SC_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Stage Clear 3-2 Unlock": ItemData("SC Round 3", 0x02E, SC_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Stage Clear 3-3 Unlock": ItemData("SC Round 3", 0x02F, SC_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Stage Clear 3-4 Unlock": ItemData("SC Round 3", 0x030, SC_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Stage Clear 3-5 Unlock": ItemData("SC Round 3", 0x031, SC_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Stage Clear Round 3 Gate": ItemData("Stage Clear", 0x02C, SC_ROUND_GATE, ItemClassification.progression),
    "Stage Clear 4-1 Unlock": ItemData("SC Round 4", 0x033, SC_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Stage Clear 4-2 Unlock": ItemData("SC Round 4", 0x034, SC_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Stage Clear 4-3 Unlock": ItemData("SC Round 4", 0x035, SC_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Stage Clear 4-4 Unlock": ItemData("SC Round 4", 0x036, SC_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Stage Clear 4-5 Unlock": ItemData("SC Round 4", 0x037, SC_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Stage Clear Round 4 Gate": ItemData("Stage Clear", 0x032, SC_ROUND_GATE, ItemClassification.progression),
    "Stage Clear 5-1 Unlock": ItemData("SC Round 5", 0x039, SC_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Stage Clear 5-2 Unlock": ItemData("SC Round 5", 0x03A, SC_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Stage Clear 5-3 Unlock": ItemData("SC Round 5", 0x03B, SC_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Stage Clear 5-4 Unlock": ItemData("SC Round 5", 0x03C, SC_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Stage Clear 5-5 Unlock": ItemData("SC Round 5", 0x03D, SC_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Stage Clear Round 5 Gate": ItemData("Stage Clear", 0x038, SC_ROUND_GATE, ItemClassification.progression),
    "Stage Clear 6-1 Unlock": ItemData("SC Round 6", 0x03F, SC_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Stage Clear 6-2 Unlock": ItemData("SC Round 6", 0x040, SC_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Stage Clear 6-3 Unlock": ItemData("SC Round 6", 0x041, SC_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Stage Clear 6-4 Unlock": ItemData("SC Round 6", 0x042, SC_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Stage Clear 6-5 Unlock": ItemData("SC Round 6", 0x043, SC_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Stage Clear Round 6 Gate": ItemData("Stage Clear", 0x03E, SC_ROUND_GATE, ItemClassification.progression),
    "Stage Clear Last Stage": ItemData("Stage Clear", 0x044, SC_GOAL, ItemClassification.progression),
    "Stage Clear Special Stage Trap": ItemData("Stage Clear", 0x045, SC_TRAP, ItemClassification.trap),
    "Puzzle 1-01 Unlock": ItemData("Puzzle L1", 0x061, PZ_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Puzzle 1-02 Unlock": ItemData("Puzzle L1", 0x062, PZ_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Puzzle 1-03 Unlock": ItemData("Puzzle L1", 0x063, PZ_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Puzzle 1-04 Unlock": ItemData("Puzzle L1", 0x064, PZ_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Puzzle 1-05 Unlock": ItemData("Puzzle L1", 0x065, PZ_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Puzzle 1-06 Unlock": ItemData("Puzzle L1", 0x066, PZ_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Puzzle 1-07 Unlock": ItemData("Puzzle L1", 0x067, PZ_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Puzzle 1-08 Unlock": ItemData("Puzzle L1", 0x068, PZ_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Puzzle 1-09 Unlock": ItemData("Puzzle L1", 0x069, PZ_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Puzzle 1-10 Unlock": ItemData("Puzzle L1", 0x06A, PZ_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Puzzle Level 1 Gate": ItemData("Puzzle", 0x060, PZ_LEVEL_GATE, ItemClassification.progression),
    "Puzzle 2-01 Unlock": ItemData("Puzzle L2", 0x06C, PZ_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Puzzle 2-02 Unlock": ItemData("Puzzle L2", 0x06D, PZ_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Puzzle 2-03 Unlock": ItemData("Puzzle L2", 0x06E, PZ_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Puzzle 2-04 Unlock": ItemData("Puzzle L2", 0x06F, PZ_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Puzzle 2-05 Unlock": ItemData("Puzzle L2", 0x070, PZ_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Puzzle 2-06 Unlock": ItemData("Puzzle L2", 0x071, PZ_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Puzzle 2-07 Unlock": ItemData("Puzzle L2", 0x072, PZ_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Puzzle 2-08 Unlock": ItemData("Puzzle L2", 0x073, PZ_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Puzzle 2-09 Unlock": ItemData("Puzzle L2", 0x074, PZ_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Puzzle 2-10 Unlock": ItemData("Puzzle L2", 0x075, PZ_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Puzzle Level 2 Gate": ItemData("Puzzle", 0x06B, PZ_LEVEL_GATE, ItemClassification.progression),
    "Puzzle 3-01 Unlock": ItemData("Puzzle L3", 0x077, PZ_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Puzzle 3-02 Unlock": ItemData("Puzzle L3", 0x078, PZ_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Puzzle 3-03 Unlock": ItemData("Puzzle L3", 0x079, PZ_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Puzzle 3-04 Unlock": ItemData("Puzzle L3", 0x07A, PZ_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Puzzle 3-05 Unlock": ItemData("Puzzle L3", 0x07B, PZ_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Puzzle 3-06 Unlock": ItemData("Puzzle L3", 0x07C, PZ_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Puzzle 3-07 Unlock": ItemData("Puzzle L3", 0x07D, PZ_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Puzzle 3-08 Unlock": ItemData("Puzzle L3", 0x07E, PZ_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Puzzle 3-09 Unlock": ItemData("Puzzle L3", 0x07F, PZ_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Puzzle 3-10 Unlock": ItemData("Puzzle L3", 0x080, PZ_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Puzzle Level 3 Gate": ItemData("Puzzle", 0x076, PZ_LEVEL_GATE, ItemClassification.progression),
    "Puzzle 4-01 Unlock": ItemData("Puzzle L4", 0x082, PZ_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Puzzle 4-02 Unlock": ItemData("Puzzle L4", 0x083, PZ_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Puzzle 4-03 Unlock": ItemData("Puzzle L4", 0x084, PZ_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Puzzle 4-04 Unlock": ItemData("Puzzle L4", 0x085, PZ_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Puzzle 4-05 Unlock": ItemData("Puzzle L4", 0x086, PZ_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Puzzle 4-06 Unlock": ItemData("Puzzle L4", 0x087, PZ_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Puzzle 4-07 Unlock": ItemData("Puzzle L4", 0x088, PZ_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Puzzle 4-08 Unlock": ItemData("Puzzle L4", 0x089, PZ_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Puzzle 4-09 Unlock": ItemData("Puzzle L4", 0x08A, PZ_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Puzzle 4-10 Unlock": ItemData("Puzzle L4", 0x08B, PZ_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Puzzle Level 4 Gate": ItemData("Puzzle", 0x081, PZ_LEVEL_GATE, ItemClassification.progression),
    "Puzzle 5-01 Unlock": ItemData("Puzzle L5", 0x08D, PZ_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Puzzle 5-02 Unlock": ItemData("Puzzle L5", 0x08E, PZ_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Puzzle 5-03 Unlock": ItemData("Puzzle L5", 0x08F, PZ_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Puzzle 5-04 Unlock": ItemData("Puzzle L5", 0x090, PZ_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Puzzle 5-05 Unlock": ItemData("Puzzle L5", 0x091, PZ_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Puzzle 5-06 Unlock": ItemData("Puzzle L5", 0x092, PZ_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Puzzle 5-07 Unlock": ItemData("Puzzle L5", 0x093, PZ_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Puzzle 5-08 Unlock": ItemData("Puzzle L5", 0x094, PZ_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Puzzle 5-09 Unlock": ItemData("Puzzle L5", 0x095, PZ_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Puzzle 5-10 Unlock": ItemData("Puzzle L5", 0x096, PZ_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Puzzle Level 5 Gate": ItemData("Puzzle", 0x08C, PZ_LEVEL_GATE, ItemClassification.progression),
    "Puzzle 6-01 Unlock": ItemData("Puzzle L6", 0x098, PZ_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Puzzle 6-02 Unlock": ItemData("Puzzle L6", 0x099, PZ_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Puzzle 6-03 Unlock": ItemData("Puzzle L6", 0x09A, PZ_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Puzzle 6-04 Unlock": ItemData("Puzzle L6", 0x09B, PZ_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Puzzle 6-05 Unlock": ItemData("Puzzle L6", 0x09C, PZ_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Puzzle 6-06 Unlock": ItemData("Puzzle L6", 0x09D, PZ_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Puzzle 6-07 Unlock": ItemData("Puzzle L6", 0x09E, PZ_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Puzzle 6-08 Unlock": ItemData("Puzzle L6", 0x09F, PZ_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Puzzle 6-09 Unlock": ItemData("Puzzle L6", 0x0A0, PZ_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Puzzle 6-10 Unlock": ItemData("Puzzle L6", 0x0A1, PZ_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Puzzle Level 6 Gate": ItemData("Puzzle", 0x097, PZ_LEVEL_GATE, ItemClassification.progression),
    "Extra Puzzle 1-01 Unlock": ItemData("Extra L1", 0x0A3, EXTRA_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Extra Puzzle 1-02 Unlock": ItemData("Extra L1", 0x0A4, EXTRA_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Extra Puzzle 1-03 Unlock": ItemData("Extra L1", 0x0A5, EXTRA_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Extra Puzzle 1-04 Unlock": ItemData("Extra L1", 0x0A6, EXTRA_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Extra Puzzle 1-05 Unlock": ItemData("Extra L1", 0x0A7, EXTRA_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Extra Puzzle 1-06 Unlock": ItemData("Extra L1", 0x0A8, EXTRA_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Extra Puzzle 1-07 Unlock": ItemData("Extra L1", 0x0A9, EXTRA_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Extra Puzzle 1-08 Unlock": ItemData("Extra L1", 0x0AA, EXTRA_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Extra Puzzle 1-09 Unlock": ItemData("Extra L1", 0x0AB, EXTRA_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Extra Puzzle 1-10 Unlock": ItemData("Extra L1", 0x0AC, EXTRA_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Extra Puzzle Level 1 Gate": ItemData("Puzzle", 0x0A2, EXTRA_LEVEL_GATE, ItemClassification.progression),
    "Extra Puzzle 2-01 Unlock": ItemData("Extra L2", 0x0AE, EXTRA_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Extra Puzzle 2-02 Unlock": ItemData("Extra L2", 0x0AF, EXTRA_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Extra Puzzle 2-03 Unlock": ItemData("Extra L2", 0x0B0, EXTRA_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Extra Puzzle 2-04 Unlock": ItemData("Extra L2", 0x0B1, EXTRA_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Extra Puzzle 2-05 Unlock": ItemData("Extra L2", 0x0B2, EXTRA_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Extra Puzzle 2-06 Unlock": ItemData("Extra L2", 0x0B3, EXTRA_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Extra Puzzle 2-07 Unlock": ItemData("Extra L2", 0x0B4, EXTRA_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Extra Puzzle 2-08 Unlock": ItemData("Extra L2", 0x0B5, EXTRA_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Extra Puzzle 2-09 Unlock": ItemData("Extra L2", 0x0B6, EXTRA_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Extra Puzzle 2-10 Unlock": ItemData("Extra L2", 0x0B7, EXTRA_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Extra Puzzle Level 2 Gate": ItemData("Puzzle", 0x0AD, EXTRA_LEVEL_GATE, ItemClassification.progression),
    "Extra Puzzle 3-01 Unlock": ItemData("Extra L3", 0x0B9, EXTRA_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Extra Puzzle 3-02 Unlock": ItemData("Extra L3", 0x0BA, EXTRA_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Extra Puzzle 3-03 Unlock": ItemData("Extra L3", 0x0BB, EXTRA_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Extra Puzzle 3-04 Unlock": ItemData("Extra L3", 0x0BC, EXTRA_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Extra Puzzle 3-05 Unlock": ItemData("Extra L3", 0x0BD, EXTRA_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Extra Puzzle 3-06 Unlock": ItemData("Extra L3", 0x0BE, EXTRA_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Extra Puzzle 3-07 Unlock": ItemData("Extra L3", 0x0BF, EXTRA_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Extra Puzzle 3-08 Unlock": ItemData("Extra L3", 0x0C0, EXTRA_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Extra Puzzle 3-09 Unlock": ItemData("Extra L3", 0x0C1, EXTRA_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Extra Puzzle 3-10 Unlock": ItemData("Extra L3", 0x0C2, EXTRA_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Extra Puzzle Level 3 Gate": ItemData("Puzzle", 0x0B8, EXTRA_LEVEL_GATE, ItemClassification.progression),
    "Extra Puzzle 4-01 Unlock": ItemData("Extra L4", 0x0C4, EXTRA_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Extra Puzzle 4-02 Unlock": ItemData("Extra L4", 0x0C5, EXTRA_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Extra Puzzle 4-03 Unlock": ItemData("Extra L4", 0x0C6, EXTRA_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Extra Puzzle 4-04 Unlock": ItemData("Extra L4", 0x0C7, EXTRA_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Extra Puzzle 4-05 Unlock": ItemData("Extra L4", 0x0C8, EXTRA_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Extra Puzzle 4-06 Unlock": ItemData("Extra L4", 0x0C9, EXTRA_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Extra Puzzle 4-07 Unlock": ItemData("Extra L4", 0x0CA, EXTRA_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Extra Puzzle 4-08 Unlock": ItemData("Extra L4", 0x0CB, EXTRA_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Extra Puzzle 4-09 Unlock": ItemData("Extra L4", 0x0CC, EXTRA_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Extra Puzzle 4-10 Unlock": ItemData("Extra L4", 0x0CD, EXTRA_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Extra Puzzle Level 4 Gate": ItemData("Puzzle", 0x0C3, EXTRA_LEVEL_GATE, ItemClassification.progression),
    "Extra Puzzle 5-01 Unlock": ItemData("Extra L5", 0x0CF, EXTRA_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Extra Puzzle 5-02 Unlock": ItemData("Extra L5", 0x0D0, EXTRA_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Extra Puzzle 5-03 Unlock": ItemData("Extra L5", 0x0D1, EXTRA_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Extra Puzzle 5-04 Unlock": ItemData("Extra L5", 0x0D2, EXTRA_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Extra Puzzle 5-05 Unlock": ItemData("Extra L5", 0x0D3, EXTRA_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Extra Puzzle 5-06 Unlock": ItemData("Extra L5", 0x0D4, EXTRA_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Extra Puzzle 5-07 Unlock": ItemData("Extra L5", 0x0D5, EXTRA_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Extra Puzzle 5-08 Unlock": ItemData("Extra L5", 0x0D6, EXTRA_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Extra Puzzle 5-09 Unlock": ItemData("Extra L5", 0x0D7, EXTRA_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Extra Puzzle 5-10 Unlock": ItemData("Extra L5", 0x0D8, EXTRA_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Extra Puzzle Level 5 Gate": ItemData("Puzzle", 0x0CE, EXTRA_LEVEL_GATE, ItemClassification.progression),
    "Extra Puzzle 6-01 Unlock": ItemData("Extra L6", 0x0DA, EXTRA_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Extra Puzzle 6-02 Unlock": ItemData("Extra L6", 0x0DB, EXTRA_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Extra Puzzle 6-03 Unlock": ItemData("Extra L6", 0x0DC, EXTRA_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Extra Puzzle 6-04 Unlock": ItemData("Extra L6", 0x0DD, EXTRA_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Extra Puzzle 6-05 Unlock": ItemData("Extra L6", 0x0DE, EXTRA_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Extra Puzzle 6-06 Unlock": ItemData("Extra L6", 0x0DF, EXTRA_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Extra Puzzle 6-07 Unlock": ItemData("Extra L6", 0x0E0, EXTRA_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Extra Puzzle 6-08 Unlock": ItemData("Extra L6", 0x0E1, EXTRA_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Extra Puzzle 6-09 Unlock": ItemData("Extra L6", 0x0E2, EXTRA_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Extra Puzzle 6-10 Unlock": ItemData("Extra L6", 0x0E3, EXTRA_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Extra Puzzle Level 6 Gate": ItemData("Puzzle", 0x0D9, EXTRA_LEVEL_GATE, ItemClassification.progression),
    versus_unlock_names[0]: ItemData("Overworld", 0x046, VS_STAGE_UNLOCK, ItemClassification.progression),
    versus_unlock_names[1]: ItemData("Overworld", 0x047, VS_STAGE_UNLOCK, ItemClassification.progression),
    versus_unlock_names[2]: ItemData("Overworld", 0x048, VS_STAGE_UNLOCK, ItemClassification.progression),
    versus_unlock_names[3]: ItemData("Overworld", 0x049, VS_STAGE_UNLOCK, ItemClassification.progression),
    versus_unlock_names[4]: ItemData("Overworld", 0x04A, VS_STAGE_UNLOCK, ItemClassification.progression),
    versus_unlock_names[5]: ItemData("Overworld", 0x04B, VS_STAGE_UNLOCK, ItemClassification.progression),
    versus_unlock_names[6]: ItemData("Overworld", 0x04C, VS_STAGE_UNLOCK, ItemClassification.progression),
    versus_unlock_names[7]: ItemData("Overworld", 0x04D, VS_STAGE_UNLOCK, ItemClassification.progression),
    versus_unlock_names[8]: ItemData("Mt Wickedness", 0x04E, VS_STAGE_UNLOCK, ItemClassification.progression),
    versus_unlock_names[9]: ItemData("Mt Wickedness", 0x04F, VS_STAGE_UNLOCK, ItemClassification.progression),
    versus_unlock_names[10]: ItemData("Mt Wickedness", 0x050, VS_STAGE_UNLOCK, ItemClassification.progression),
    versus_unlock_names[11]: ItemData("Mt Wickedness", 0x051, VS_STAGE_UNLOCK, ItemClassification.progression),
    "Lakitu": ItemData("Overworld", 0x052, VS_CHARACTER, ItemClassification.filler),
    "Bumpty": ItemData("Overworld", 0x053, VS_CHARACTER, ItemClassification.filler),
    "Poochy": ItemData("Overworld", 0x054, VS_CHARACTER, ItemClassification.filler),
    "Flying Wiggler": ItemData("Overworld", 0x055, VS_CHARACTER, ItemClassification.filler),
    "Froggy": ItemData("Overworld", 0x056, VS_CHARACTER, ItemClassification.filler),
    "Gargantua Blargg": ItemData("Overworld", 0x057, VS_CHARACTER, ItemClassification.filler),
    "Lunge Fish": ItemData("Overworld", 0x058, VS_CHARACTER, ItemClassification.filler),
    "Raphael the Raven": ItemData("Overworld", 0x059, VS_CHARACTER, ItemClassification.filler),
    "Stage Clear Completion": ItemData("Stage Clear", None, SC_GOAL, ItemClassification.progression),
    "Puzzle Completion": ItemData("Puzzle", None, PZ_GOAL, ItemClassification.progression),
    "Versus Completion": ItemData("Versus", None, VS_GOAL, ItemClassification.progression),
    "Mt. Wickedness Gate": ItemData("Overworld", 0x05A, VS_GATE, ItemClassification.progression),

    # "50 Points": ItemData("Stage Clear", 0x100, FILLER, ItemClassification.filler),
    "80 Points": ItemData("Stage Clear", 0x101, FILLER, ItemClassification.filler),
    "150 Points": ItemData("Stage Clear", 0x102, FILLER, ItemClassification.filler),
    "300 Points": ItemData("Stage Clear", 0x103, FILLER, ItemClassification.filler),
    "400 Points": ItemData("Stage Clear", 0x104, FILLER, ItemClassification.filler),
    "500 Points": ItemData("Stage Clear", 0x105, FILLER, ItemClassification.filler),
    "700 Points": ItemData("Stage Clear", 0x106, FILLER, ItemClassification.filler),
    "900 Points": ItemData("Stage Clear", 0x107, FILLER, ItemClassification.filler),
    "1100 Points": ItemData("Stage Clear", 0x108, FILLER, ItemClassification.filler),
    "1300 Points": ItemData("Stage Clear", 0x109, FILLER, ItemClassification.filler),
    "1500 Points": ItemData("Stage Clear", 0x10A, FILLER, ItemClassification.filler),
    "1800 Points": ItemData("Stage Clear", 0x10B, FILLER, ItemClassification.filler),
    "20 Points": ItemData("Stage Clear", 0x10C, FILLER, ItemClassification.filler),
    "30 Points": ItemData("Stage Clear", 0x10D, FILLER, ItemClassification.filler),
    "50 Points": ItemData("Stage Clear", 0x10E, FILLER, ItemClassification.filler),
    "60 Points": ItemData("Stage Clear", 0x10F, FILLER, ItemClassification.filler),
    "70 Points": ItemData("Stage Clear", 0x110, FILLER, ItemClassification.filler),
    # "80 Points": ItemData("Stage Clear", 0x111, FILLER, ItemClassification.filler),
    "100 Points": ItemData("Stage Clear", 0x112, FILLER, ItemClassification.filler),
    "140 Points": ItemData("Stage Clear", 0x113, FILLER, ItemClassification.filler),
    "170 Points": ItemData("Stage Clear", 0x114, FILLER, ItemClassification.filler),
    "210 Points": ItemData("Stage Clear", 0x115, FILLER, ItemClassification.filler),
    "250 Points": ItemData("Stage Clear", 0x116, FILLER, ItemClassification.filler),
    "290 Points": ItemData("Stage Clear", 0x117, FILLER, ItemClassification.filler),
    "340 Points": ItemData("Stage Clear", 0x118, FILLER, ItemClassification.filler),
    "390 Points": ItemData("Stage Clear", 0x119, FILLER, ItemClassification.filler),
    "440 Points": ItemData("Stage Clear", 0x11A, FILLER, ItemClassification.filler),
    "490 Points": ItemData("Stage Clear", 0x11B, FILLER, ItemClassification.filler),
    "550 Points": ItemData("Stage Clear", 0x11C, FILLER, ItemClassification.filler),
    "610 Points": ItemData("Stage Clear", 0x11D, FILLER, ItemClassification.filler),
    "680 Points": ItemData("Stage Clear", 0x11E, FILLER, ItemClassification.filler),
    "750 Points": ItemData("Stage Clear", 0x11F, FILLER, ItemClassification.filler),
    "820 Points": ItemData("Stage Clear", 0x120, FILLER, ItemClassification.filler),
    "980 Points": ItemData("Stage Clear", 0x121, FILLER, ItemClassification.filler),
    "1060 Points": ItemData("Stage Clear", 0x122, FILLER, ItemClassification.filler),
    "1150 Points": ItemData("Stage Clear", 0x123, FILLER, ItemClassification.filler),
    "1240 Points": ItemData("Stage Clear", 0x124, FILLER, ItemClassification.filler),
    "1330 Points": ItemData("Stage Clear", 0x125, FILLER, ItemClassification.filler),
}

filler_items = filter((lambda item_tuple: item_tuple[1].item_class == FILLER), item_table.items())
filler_item_names = list(map(lambda item_tuple: item_tuple[0], filler_items))
progressive_items = dict()
for name, data in item_table.items():
    if data.code is not None and data.code < 0x020:
        progressive_items[data.code] = data


def get_items(world: Optional["TetrisAttackWorld"]) -> Dict[str, ItemData]:
    include_sc_progressive_unlocks = True
    include_sc_individual_unlocks = True
    include_sc_round_gates = True
    include_pz_progressive_unlocks = True
    include_pz_individual_unlocks = True
    include_pz_level_gates = True
    include_extra_progressive_unlocks = True
    include_extra_individual_unlocks = True
    include_extra_level_gates = True
    include_vs_progressive_unlocks = True
    include_vs_individual_unlocks = True
    special_stage_trap_count = 1
    excluded_items: List[str] = []
    if world:
        include_stage_clear = world.options.stage_clear_goal or world.options.stage_clear_inclusion
        include_sc_progressive_unlocks = stage_clear_progressive_unlocks_included(world)
        include_sc_individual_unlocks = stage_clear_individual_unlocks_included(world)
        include_sc_round_gates = stage_clear_round_gates_included(world)
        include_normal_puzzles = normal_puzzle_set_included(world)
        include_extra_puzzles = extra_puzzle_set_included(world)
        puzzle_progressive_unlocks = puzzle_progressive_unlocks_included(world)
        puzzle_individual_unlocks = puzzle_individual_unlocks_included(world)
        puzzle_level_gates = puzzle_level_gates_included(world)
        include_pz_progressive_unlocks = puzzle_progressive_unlocks and include_normal_puzzles
        include_pz_individual_unlocks = puzzle_individual_unlocks and include_normal_puzzles
        include_pz_level_gates = puzzle_level_gates and include_normal_puzzles
        include_extra_progressive_unlocks = puzzle_progressive_unlocks and include_extra_puzzles
        include_extra_individual_unlocks = puzzle_individual_unlocks and include_extra_puzzles
        include_extra_level_gates = puzzle_level_gates and include_extra_puzzles
        include_vs_progressive_unlocks = versus_progressive_unlocks_included(world)
        include_vs_individual_unlocks = versus_individual_unlocks_included(world)
        special_stage_trap_count = world.options.special_stage_trap_count.value
        if not include_stage_clear:
            special_stage_trap_count = 0
        starter_item_names = get_starter_item_names(world)
        for n in starter_item_names:
            excluded_items.append(n)
        if world.options.starter_pack != StarterPack.option_stage_clear_round_6:
            excluded_items.append("Stage Clear Last Stage")

    included_classes: List[int] = []
    if include_sc_progressive_unlocks:
        included_classes.append(SC_PROGRESSIVE_UNLOCK)
    if include_sc_individual_unlocks:
        included_classes.append(SC_INDIVIDUAL_UNLOCK)
    if include_sc_round_gates:
        included_classes.append(SC_ROUND_GATE)
    if include_pz_progressive_unlocks:
        included_classes.append(PZ_PROGRESSIVE_UNLOCK)
    if include_pz_individual_unlocks:
        included_classes.append(PZ_INDIVIDUAL_UNLOCK)
    if include_pz_level_gates:
        included_classes.append(PZ_LEVEL_GATE)
    if include_extra_progressive_unlocks:
        included_classes.append(EXTRA_PROGRESSIVE_UNLOCK)
    if include_extra_individual_unlocks:
        included_classes.append(EXTRA_INDIVIDUAL_UNLOCK)
    if include_extra_level_gates:
        included_classes.append(EXTRA_LEVEL_GATE)
    if include_vs_progressive_unlocks:
        included_classes.append(VS_PROGRESSIVE_UNLOCK)
        included_classes.append(VS_CHARACTER)
        included_classes.append(VS_GATE)
    if include_vs_individual_unlocks:
        included_classes.append(VS_STAGE_UNLOCK)
        included_classes.append(VS_CHARACTER)
        included_classes.append(VS_GATE)

    new_items = dict(filter(lambda item: item[1].item_class in included_classes, item_table.items()))
    for n in excluded_items:
        data = new_items.get(n)
        if data:
            if data.amount == 1:
                del new_items[n]
            else:
                new_items[n] = ItemData(data.category, data.code, data.item_class, data.classification, data.amount - 1)
    if special_stage_trap_count > 0:
        new_items["Stage Clear Special Stage Trap"] = ItemData("Stage Clear", 0x045, SC_TRAP,
                                                               ItemClassification.trap, special_stage_trap_count)
    if "Vs. Progressive Stage Unlock" in new_items:
        unlock_count = new_items["Vs. Progressive Stage Unlock"].amount
        if world.options.versus_goal == VersusGoal.option_easy:
            unlock_count -= 2
        elif world.options.versus_goal == VersusGoal.option_normal:
            unlock_count -= 1
        new_items["Vs. Progressive Stage Unlock"] = ItemData("Versus", 19, VS_PROGRESSIVE_UNLOCK,
                                                             ItemClassification.progression, unlock_count, 0x046)
    return new_items


def get_starter_item_names(world: "TetrisAttackWorld") -> List[str]:
    starting_sc_round = get_starting_sc_round(world)
    starting_puzzle_level = get_starting_puzzle_level(world)
    extra_puzzles_included = extra_puzzle_set_included(world)
    starting_in_vs = get_starting_vs_flag(world)

    starter_items: List[str] = []
    if stage_clear_round_gates_included(world):
        if starting_sc_round <= 6:
            starter_items.append(f"Stage Clear Round {starting_sc_round} Gate")
    if stage_clear_progressive_unlocks_included(world):
        if starting_sc_round <= 6:
            for _ in range(5):
                starter_items.append(f"Stage Clear Progressive Round {starting_sc_round} Unlock")
    elif stage_clear_individual_unlocks_included(world):
        if starting_sc_round <= 6:
            starter_items.append(f"Stage Clear {starting_sc_round}-1 Unlock")
            starter_items.append(f"Stage Clear {starting_sc_round}-2 Unlock")
            starter_items.append(f"Stage Clear {starting_sc_round}-3 Unlock")
            starter_items.append(f"Stage Clear {starting_sc_round}-4 Unlock")
            starter_items.append(f"Stage Clear {starting_sc_round}-5 Unlock")
    if puzzle_level_gates_included(world):
        if starting_puzzle_level > 6:
            starter_items.append(f"Extra Puzzle Level {starting_puzzle_level - 6} Gate")
        elif starting_puzzle_level > 0:
            starter_items.append(f"Puzzle Level {starting_puzzle_level} Gate")
    if puzzle_progressive_unlocks_included(world):
        if starting_puzzle_level > 6:
            for _ in range(10):
                starter_items.append(f"Extra Puzzle Progressive Level {starting_puzzle_level - 6} Unlock")
        elif starting_puzzle_level > 0:
            for _ in range(10):
                starter_items.append(f"Puzzle Progressive Level {starting_puzzle_level} Unlock")
                # TODO: Remove after finding a better way to enforce logic
                if extra_puzzles_included and (
                        world.options.puzzle_mode == PuzzleMode.option_individual_stages
                        or world.options.puzzle_mode == PuzzleMode.option_incremental_with_level_gate):
                    starter_items.append(f"Extra Puzzle Progressive Level {starting_puzzle_level} Unlock")
    elif puzzle_individual_unlocks_included(world):
        if starting_puzzle_level > 6:
            starter_items.append(f"Extra Puzzle {starting_puzzle_level - 6}-01 Unlock")
            starter_items.append(f"Extra Puzzle {starting_puzzle_level - 6}-02 Unlock")
            starter_items.append(f"Extra Puzzle {starting_puzzle_level - 6}-03 Unlock")
            starter_items.append(f"Extra Puzzle {starting_puzzle_level - 6}-04 Unlock")
            starter_items.append(f"Extra Puzzle {starting_puzzle_level - 6}-05 Unlock")
            starter_items.append(f"Extra Puzzle {starting_puzzle_level - 6}-06 Unlock")
            starter_items.append(f"Extra Puzzle {starting_puzzle_level - 6}-07 Unlock")
            starter_items.append(f"Extra Puzzle {starting_puzzle_level - 6}-08 Unlock")
            starter_items.append(f"Extra Puzzle {starting_puzzle_level - 6}-09 Unlock")
            starter_items.append(f"Extra Puzzle {starting_puzzle_level - 6}-10 Unlock")
        elif starting_puzzle_level > 0:
            starter_items.append(f"Puzzle {starting_puzzle_level}-01 Unlock")
            starter_items.append(f"Puzzle {starting_puzzle_level}-02 Unlock")
            starter_items.append(f"Puzzle {starting_puzzle_level}-03 Unlock")
            starter_items.append(f"Puzzle {starting_puzzle_level}-04 Unlock")
            starter_items.append(f"Puzzle {starting_puzzle_level}-05 Unlock")
            starter_items.append(f"Puzzle {starting_puzzle_level}-06 Unlock")
            starter_items.append(f"Puzzle {starting_puzzle_level}-07 Unlock")
            starter_items.append(f"Puzzle {starting_puzzle_level}-08 Unlock")
            starter_items.append(f"Puzzle {starting_puzzle_level}-09 Unlock")
            starter_items.append(f"Puzzle {starting_puzzle_level}-10 Unlock")
            if extra_puzzles_included:  # TODO: Remove after finding a better way to enforce logic
                starter_items.append(f"Extra Puzzle {starting_puzzle_level}-01 Unlock")
                starter_items.append(f"Extra Puzzle {starting_puzzle_level}-02 Unlock")
                starter_items.append(f"Extra Puzzle {starting_puzzle_level}-03 Unlock")
                starter_items.append(f"Extra Puzzle {starting_puzzle_level}-04 Unlock")
                starter_items.append(f"Extra Puzzle {starting_puzzle_level}-05 Unlock")
                starter_items.append(f"Extra Puzzle {starting_puzzle_level}-06 Unlock")
                starter_items.append(f"Extra Puzzle {starting_puzzle_level}-07 Unlock")
                starter_items.append(f"Extra Puzzle {starting_puzzle_level}-08 Unlock")
                starter_items.append(f"Extra Puzzle {starting_puzzle_level}-09 Unlock")
                starter_items.append(f"Extra Puzzle {starting_puzzle_level}-10 Unlock")
    if versus_progressive_unlocks_included(world):
        if starting_in_vs:
            starter_items.append("Vs. Progressive Stage Unlock")
            starter_items.append("Vs. Progressive Stage Unlock")
    if versus_individual_unlocks_included(world):
        if starting_in_vs:
            starter_items.append(versus_unlock_names[0])
            starter_items.append(versus_unlock_names[1])
    return starter_items
