from typing import List, Set, Dict, NamedTuple, Optional, TYPE_CHECKING

from BaseClasses import ItemClassification
from .Logic import stage_clear_progressive_unlocks_included, stage_clear_individual_unlocks_included, \
    stage_clear_round_gates_included, puzzle_progressive_unlocks_included, puzzle_individual_unlocks_included, \
    puzzle_level_gates_included, get_starting_sc_round, get_starting_puzzle_level, normal_puzzle_set_included, \
    secret_puzzle_set_included
from .Options import StarterPack, PuzzleMode

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
SECRET_PROGRESSIVE_UNLOCK = 10
SECRET_INDIVIDUAL_UNLOCK = 11
SECRET_LEVEL_GATE = 12


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
    "Secret Puzzle Progressive Level 1 Unlock": ItemData("Secret L1", 13, SECRET_PROGRESSIVE_UNLOCK,
                                                         ItemClassification.progression, 10, 0x0A3),
    "Secret Puzzle Progressive Level 2 Unlock": ItemData("Secret L2", 14, SECRET_PROGRESSIVE_UNLOCK,
                                                         ItemClassification.progression, 10, 0x0AE),
    "Secret Puzzle Progressive Level 3 Unlock": ItemData("Secret L3", 15, SECRET_PROGRESSIVE_UNLOCK,
                                                         ItemClassification.progression, 10, 0x0B9),
    "Secret Puzzle Progressive Level 4 Unlock": ItemData("Secret L4", 16, SECRET_PROGRESSIVE_UNLOCK,
                                                         ItemClassification.progression, 10, 0x0C4),
    "Secret Puzzle Progressive Level 5 Unlock": ItemData("Secret L5", 17, SECRET_PROGRESSIVE_UNLOCK,
                                                         ItemClassification.progression, 10, 0x0CF),
    "Secret Puzzle Progressive Level 6 Unlock": ItemData("Secret L6", 18, SECRET_PROGRESSIVE_UNLOCK,
                                                         ItemClassification.progression, 10, 0x0DA),
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
    "Secret Puzzle 1-01 Unlock": ItemData("Secret L1", 0x0A3, SECRET_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Secret Puzzle 1-02 Unlock": ItemData("Secret L1", 0x0A4, SECRET_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Secret Puzzle 1-03 Unlock": ItemData("Secret L1", 0x0A5, SECRET_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Secret Puzzle 1-04 Unlock": ItemData("Secret L1", 0x0A6, SECRET_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Secret Puzzle 1-05 Unlock": ItemData("Secret L1", 0x0A7, SECRET_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Secret Puzzle 1-06 Unlock": ItemData("Secret L1", 0x0A8, SECRET_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Secret Puzzle 1-07 Unlock": ItemData("Secret L1", 0x0A9, SECRET_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Secret Puzzle 1-08 Unlock": ItemData("Secret L1", 0x0AA, SECRET_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Secret Puzzle 1-09 Unlock": ItemData("Secret L1", 0x0AB, SECRET_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Secret Puzzle 1-10 Unlock": ItemData("Secret L1", 0x0AC, SECRET_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Secret Puzzle Level 1 Gate": ItemData("Puzzle", 0x0A2, SECRET_LEVEL_GATE, ItemClassification.progression),
    "Secret Puzzle 2-01 Unlock": ItemData("Secret L2", 0x0AE, SECRET_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Secret Puzzle 2-02 Unlock": ItemData("Secret L2", 0x0AF, SECRET_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Secret Puzzle 2-03 Unlock": ItemData("Secret L2", 0x0B0, SECRET_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Secret Puzzle 2-04 Unlock": ItemData("Secret L2", 0x0B1, SECRET_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Secret Puzzle 2-05 Unlock": ItemData("Secret L2", 0x0B2, SECRET_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Secret Puzzle 2-06 Unlock": ItemData("Secret L2", 0x0B3, SECRET_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Secret Puzzle 2-07 Unlock": ItemData("Secret L2", 0x0B4, SECRET_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Secret Puzzle 2-08 Unlock": ItemData("Secret L2", 0x0B5, SECRET_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Secret Puzzle 2-09 Unlock": ItemData("Secret L2", 0x0B6, SECRET_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Secret Puzzle 2-10 Unlock": ItemData("Secret L2", 0x0B7, SECRET_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Secret Puzzle Level 2 Gate": ItemData("Puzzle", 0x0AD, SECRET_LEVEL_GATE, ItemClassification.progression),
    "Secret Puzzle 3-01 Unlock": ItemData("Secret L3", 0x0B9, SECRET_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Secret Puzzle 3-02 Unlock": ItemData("Secret L3", 0x0BA, SECRET_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Secret Puzzle 3-03 Unlock": ItemData("Secret L3", 0x0BB, SECRET_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Secret Puzzle 3-04 Unlock": ItemData("Secret L3", 0x0BC, SECRET_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Secret Puzzle 3-05 Unlock": ItemData("Secret L3", 0x0BD, SECRET_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Secret Puzzle 3-06 Unlock": ItemData("Secret L3", 0x0BE, SECRET_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Secret Puzzle 3-07 Unlock": ItemData("Secret L3", 0x0BF, SECRET_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Secret Puzzle 3-08 Unlock": ItemData("Secret L3", 0x0C0, SECRET_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Secret Puzzle 3-09 Unlock": ItemData("Secret L3", 0x0C1, SECRET_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Secret Puzzle 3-10 Unlock": ItemData("Secret L3", 0x0C2, SECRET_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Secret Puzzle Level 3 Gate": ItemData("Puzzle", 0x0B8, SECRET_LEVEL_GATE, ItemClassification.progression),
    "Secret Puzzle 4-01 Unlock": ItemData("Secret L4", 0x0C4, SECRET_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Secret Puzzle 4-02 Unlock": ItemData("Secret L4", 0x0C5, SECRET_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Secret Puzzle 4-03 Unlock": ItemData("Secret L4", 0x0C6, SECRET_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Secret Puzzle 4-04 Unlock": ItemData("Secret L4", 0x0C7, SECRET_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Secret Puzzle 4-05 Unlock": ItemData("Secret L4", 0x0C8, SECRET_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Secret Puzzle 4-06 Unlock": ItemData("Secret L4", 0x0C9, SECRET_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Secret Puzzle 4-07 Unlock": ItemData("Secret L4", 0x0CA, SECRET_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Secret Puzzle 4-08 Unlock": ItemData("Secret L4", 0x0CB, SECRET_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Secret Puzzle 4-09 Unlock": ItemData("Secret L4", 0x0CC, SECRET_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Secret Puzzle 4-10 Unlock": ItemData("Secret L4", 0x0CD, SECRET_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Secret Puzzle Level 4 Gate": ItemData("Puzzle", 0x0C3, SECRET_LEVEL_GATE, ItemClassification.progression),
    "Secret Puzzle 5-01 Unlock": ItemData("Secret L5", 0x0CF, SECRET_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Secret Puzzle 5-02 Unlock": ItemData("Secret L5", 0x0D0, SECRET_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Secret Puzzle 5-03 Unlock": ItemData("Secret L5", 0x0D1, SECRET_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Secret Puzzle 5-04 Unlock": ItemData("Secret L5", 0x0D2, SECRET_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Secret Puzzle 5-05 Unlock": ItemData("Secret L5", 0x0D3, SECRET_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Secret Puzzle 5-06 Unlock": ItemData("Secret L5", 0x0D4, SECRET_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Secret Puzzle 5-07 Unlock": ItemData("Secret L5", 0x0D5, SECRET_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Secret Puzzle 5-08 Unlock": ItemData("Secret L5", 0x0D6, SECRET_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Secret Puzzle 5-09 Unlock": ItemData("Secret L5", 0x0D7, SECRET_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Secret Puzzle 5-10 Unlock": ItemData("Secret L5", 0x0D8, SECRET_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Secret Puzzle Level 5 Gate": ItemData("Puzzle", 0x0CE, SECRET_LEVEL_GATE, ItemClassification.progression),
    "Secret Puzzle 6-01 Unlock": ItemData("Secret L6", 0x0DA, SECRET_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Secret Puzzle 6-02 Unlock": ItemData("Secret L6", 0x0DB, SECRET_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Secret Puzzle 6-03 Unlock": ItemData("Secret L6", 0x0DC, SECRET_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Secret Puzzle 6-04 Unlock": ItemData("Secret L6", 0x0DD, SECRET_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Secret Puzzle 6-05 Unlock": ItemData("Secret L6", 0x0DE, SECRET_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Secret Puzzle 6-06 Unlock": ItemData("Secret L6", 0x0DF, SECRET_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Secret Puzzle 6-07 Unlock": ItemData("Secret L6", 0x0E0, SECRET_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Secret Puzzle 6-08 Unlock": ItemData("Secret L6", 0x0E1, SECRET_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Secret Puzzle 6-09 Unlock": ItemData("Secret L6", 0x0E2, SECRET_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Secret Puzzle 6-10 Unlock": ItemData("Secret L6", 0x0E3, SECRET_INDIVIDUAL_UNLOCK, ItemClassification.progression),
    "Secret Puzzle Level 6 Gate": ItemData("Puzzle", 0x0D9, SECRET_LEVEL_GATE, ItemClassification.progression),
    "Stage Clear Completion": ItemData("Stage Clear", None, SC_GOAL, ItemClassification.progression),
    "Puzzle Completion": ItemData("Puzzle", None, PZ_GOAL, ItemClassification.progression),

    "50 Points": ItemData("Stage Clear", 0x100, FILLER, ItemClassification.filler),
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
    # "50 Points": ItemData("Stage Clear", 0x10E, FILLER, ItemClassification.filler),
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
    include_secret_progressive_unlocks = True
    include_secret_individual_unlocks = True
    include_secret_level_gates = True
    special_stage_trap_count = 1
    excluded_items: Set[str] = set()
    if world:
        include_stage_clear = world.options.stage_clear_goal or world.options.stage_clear_inclusion
        include_sc_progressive_unlocks = stage_clear_progressive_unlocks_included(world)
        include_sc_individual_unlocks = stage_clear_individual_unlocks_included(world)
        include_sc_round_gates = stage_clear_round_gates_included(world)
        include_normal_puzzles = normal_puzzle_set_included(world)
        include_secret_puzzles = secret_puzzle_set_included(world)
        puzzle_progressive_unlocks = puzzle_progressive_unlocks_included(world)
        puzzle_individual_unlocks = puzzle_individual_unlocks_included(world)
        puzzle_level_gates = puzzle_level_gates_included(world)
        include_pz_progressive_unlocks = puzzle_progressive_unlocks and include_normal_puzzles
        include_pz_individual_unlocks = puzzle_individual_unlocks and include_normal_puzzles
        include_pz_level_gates = puzzle_level_gates and include_normal_puzzles
        include_secret_progressive_unlocks = puzzle_progressive_unlocks and include_secret_puzzles
        include_secret_individual_unlocks = puzzle_individual_unlocks and include_secret_puzzles
        include_secret_level_gates = puzzle_level_gates and include_secret_puzzles
        special_stage_trap_count = world.options.special_stage_trap_count.value
        if not include_stage_clear:
            special_stage_trap_count = 0
        starter_item_names = get_starter_item_names(world)
        for n in starter_item_names:
            excluded_items.add(n)
        if world.options.starter_pack != StarterPack.option_stage_clear_round_6:
            excluded_items.add("Stage Clear Last Stage")

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
    if include_secret_progressive_unlocks:
        included_classes.append(SECRET_PROGRESSIVE_UNLOCK)
    if include_secret_individual_unlocks:
        included_classes.append(SECRET_INDIVIDUAL_UNLOCK)
    if include_secret_level_gates:
        included_classes.append(SECRET_LEVEL_GATE)

    new_items = dict(filter(lambda item: item[1].item_class in included_classes and item[0] not in excluded_items,
                            item_table.items()))
    if special_stage_trap_count > 0:
        new_items["Stage Clear Special Stage Trap"] = ItemData("Stage Clear", 7, SC_TRAP,
                                                               ItemClassification.trap, special_stage_trap_count)
    return new_items


def get_starter_item_names(world: "TetrisAttackWorld") -> List[str]:
    starting_sc_round = get_starting_sc_round(world)
    starting_puzzle_level = get_starting_puzzle_level(world)
    secret_puzzles_included = secret_puzzle_set_included(world)

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
            starter_items.append(f"Secret Puzzle Level {starting_puzzle_level - 6} Gate")
        elif starting_puzzle_level > 0:
            starter_items.append(f"Puzzle Level {starting_puzzle_level} Gate")
    if puzzle_progressive_unlocks_included(world):
        if starting_puzzle_level > 6:
            for _ in range(10):
                starter_items.append(f"Secret Puzzle Progressive Level {starting_puzzle_level - 6} Unlock")
        elif starting_puzzle_level > 0:
            for _ in range(10):
                starter_items.append(f"Puzzle Progressive Level {starting_puzzle_level} Unlock")
                 # TODO: Remove after finding a better way to enforce logic
                if secret_puzzles_included and (
                        world.options.puzzle_mode == PuzzleMode.option_individual_stages
                        or world.options.puzzle_mode == PuzzleMode.option_incremental_with_level_gate
                        or world.options.puzzle_mode == PuzzleMode.option_skippable_with_level_gate):
                    starter_items.append(f"Secret Puzzle Progressive Level {starting_puzzle_level} Unlock")
    elif puzzle_individual_unlocks_included(world):
        if starting_puzzle_level > 6:
            starter_items.append(f"Secret Puzzle {starting_puzzle_level - 6}-01 Unlock")
            starter_items.append(f"Secret Puzzle {starting_puzzle_level - 6}-02 Unlock")
            starter_items.append(f"Secret Puzzle {starting_puzzle_level - 6}-03 Unlock")
            starter_items.append(f"Secret Puzzle {starting_puzzle_level - 6}-04 Unlock")
            starter_items.append(f"Secret Puzzle {starting_puzzle_level - 6}-05 Unlock")
            starter_items.append(f"Secret Puzzle {starting_puzzle_level - 6}-06 Unlock")
            starter_items.append(f"Secret Puzzle {starting_puzzle_level - 6}-07 Unlock")
            starter_items.append(f"Secret Puzzle {starting_puzzle_level - 6}-08 Unlock")
            starter_items.append(f"Secret Puzzle {starting_puzzle_level - 6}-09 Unlock")
            starter_items.append(f"Secret Puzzle {starting_puzzle_level - 6}-10 Unlock")
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
            if secret_puzzles_included: # TODO: Remove after finding a better way to enforce logic
                starter_items.append(f"Secret Puzzle {starting_puzzle_level}-01 Unlock")
                starter_items.append(f"Secret Puzzle {starting_puzzle_level}-02 Unlock")
                starter_items.append(f"Secret Puzzle {starting_puzzle_level}-03 Unlock")
                starter_items.append(f"Secret Puzzle {starting_puzzle_level}-04 Unlock")
                starter_items.append(f"Secret Puzzle {starting_puzzle_level}-05 Unlock")
                starter_items.append(f"Secret Puzzle {starting_puzzle_level}-06 Unlock")
                starter_items.append(f"Secret Puzzle {starting_puzzle_level}-07 Unlock")
                starter_items.append(f"Secret Puzzle {starting_puzzle_level}-08 Unlock")
                starter_items.append(f"Secret Puzzle {starting_puzzle_level}-09 Unlock")
                starter_items.append(f"Secret Puzzle {starting_puzzle_level}-10 Unlock")
    return starter_items
