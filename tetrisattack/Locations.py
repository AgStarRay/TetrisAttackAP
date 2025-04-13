from typing import List, Set, Dict, NamedTuple, Optional, TYPE_CHECKING

from BaseClasses import Location
from worlds.generic.Rules import CollectionRule
from .Logic import stage_clear_round_clears_included, stage_clear_individual_clears_included, \
    round_clear_has_special, stage_clear_has_special, puzzle_individual_clears_included, puzzle_round_clears_included, \
    goal_locations_included, normal_puzzle_set_included, secret_puzzle_set_included
from .Options import StarterPack, PuzzleGoal, PuzzleInclusion

if TYPE_CHECKING:
    from . import TetrisAttackWorld

SC_GOAL = 1
SC_STAGE_CLEAR = 2
SC_ROUND_CLEAR = 3
SC_SPECIAL = 4
PZ_STAGE_CLEAR = 5
PZ_ROUND_CLEAR = 6
SECRET_CLEAR = 7
SECRET_ROUND_CLEAR = 8


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
    "Stage Clear 1-1 Special": LocationData("SC Round 1", SC_SPECIAL, 0x601),
    "Stage Clear 1-2 Special": LocationData("SC Round 1", SC_SPECIAL, 0x602),
    "Stage Clear 1-3 Special": LocationData("SC Round 1", SC_SPECIAL, 0x603),
    "Stage Clear 1-4 Special": LocationData("SC Round 1", SC_SPECIAL, 0x604),
    "Stage Clear 1-5 Special": LocationData("SC Round 1", SC_SPECIAL, 0x605),
    "Stage Clear Round 1 Special": LocationData("SC Round 1", SC_SPECIAL, 0x600),
    "Stage Clear 2-1 Special": LocationData("SC Round 2", SC_SPECIAL, 0x607),
    "Stage Clear 2-2 Special": LocationData("SC Round 2", SC_SPECIAL, 0x608),
    "Stage Clear 2-3 Special": LocationData("SC Round 2", SC_SPECIAL, 0x609),
    "Stage Clear 2-4 Special": LocationData("SC Round 2", SC_SPECIAL, 0x60A),
    "Stage Clear 2-5 Special": LocationData("SC Round 2", SC_SPECIAL, 0x60B),
    "Stage Clear Round 2 Special": LocationData("SC Round 2", SC_SPECIAL, 0x606),
    "Stage Clear 3-1 Special": LocationData("SC Round 3", SC_SPECIAL, 0x60D),
    "Stage Clear 3-2 Special": LocationData("SC Round 3", SC_SPECIAL, 0x60E),
    "Stage Clear 3-3 Special": LocationData("SC Round 3", SC_SPECIAL, 0x60F),
    "Stage Clear 3-4 Special": LocationData("SC Round 3", SC_SPECIAL, 0x610),
    "Stage Clear 3-5 Special": LocationData("SC Round 3", SC_SPECIAL, 0x611),
    "Stage Clear Round 3 Special": LocationData("SC Round 3", SC_SPECIAL, 0x60C),
    "Stage Clear 4-1 Special": LocationData("SC Round 4", SC_SPECIAL, 0x613),
    "Stage Clear 4-2 Special": LocationData("SC Round 4", SC_SPECIAL, 0x614),
    "Stage Clear 4-3 Special": LocationData("SC Round 4", SC_SPECIAL, 0x615),
    "Stage Clear 4-4 Special": LocationData("SC Round 4", SC_SPECIAL, 0x616),
    "Stage Clear 4-5 Special": LocationData("SC Round 4", SC_SPECIAL, 0x617),
    "Stage Clear Round 4 Special": LocationData("SC Round 4", SC_SPECIAL, 0x612),
    "Stage Clear 5-1 Special": LocationData("SC Round 5", SC_SPECIAL, 0x619),
    "Stage Clear 5-2 Special": LocationData("SC Round 5", SC_SPECIAL, 0x61A),
    "Stage Clear 5-3 Special": LocationData("SC Round 5", SC_SPECIAL, 0x61B),
    "Stage Clear 5-4 Special": LocationData("SC Round 5", SC_SPECIAL, 0x61C),
    "Stage Clear 5-5 Special": LocationData("SC Round 5", SC_SPECIAL, 0x61D),
    "Stage Clear Round 5 Special": LocationData("SC Round 5", SC_SPECIAL, 0x618),
    "Stage Clear 6-1 Special": LocationData("SC Round 6", SC_SPECIAL, 0x61F),
    "Stage Clear 6-2 Special": LocationData("SC Round 6", SC_SPECIAL, 0x620),
    "Stage Clear 6-3 Special": LocationData("SC Round 6", SC_SPECIAL, 0x621),
    "Stage Clear 6-4 Special": LocationData("SC Round 6", SC_SPECIAL, 0x622),
    "Stage Clear 6-5 Special": LocationData("SC Round 6", SC_SPECIAL, 0x623),
    "Stage Clear Round 6 Special": LocationData("SC Round 6", SC_SPECIAL, 0x61E),

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
    "Secret Puzzle 1-01 Clear": LocationData("Secret L1", SECRET_CLEAR, 0x29C),
    "Secret Puzzle 1-02 Clear": LocationData("Secret L1", SECRET_CLEAR, 0x29D),
    "Secret Puzzle 1-03 Clear": LocationData("Secret L1", SECRET_CLEAR, 0x29E),
    "Secret Puzzle 1-04 Clear": LocationData("Secret L1", SECRET_CLEAR, 0x29F),
    "Secret Puzzle 1-05 Clear": LocationData("Secret L1", SECRET_CLEAR, 0x2A0),
    "Secret Puzzle 1-06 Clear": LocationData("Secret L1", SECRET_CLEAR, 0x2A1),
    "Secret Puzzle 1-07 Clear": LocationData("Secret L1", SECRET_CLEAR, 0x2A2),
    "Secret Puzzle 1-08 Clear": LocationData("Secret L1", SECRET_CLEAR, 0x2A3),
    "Secret Puzzle 1-09 Clear": LocationData("Secret L1", SECRET_CLEAR, 0x2A4),
    "Secret Puzzle 1-10 Clear": LocationData("Secret L1", SECRET_CLEAR, 0x2A5),
    "Secret Puzzle Round 1 Clear": LocationData("Secret L1", SECRET_ROUND_CLEAR, 0x29B),
    "Secret Puzzle 2-01 Clear": LocationData("Secret L2", SECRET_CLEAR, 0x2A7),
    "Secret Puzzle 2-02 Clear": LocationData("Secret L2", SECRET_CLEAR, 0x2A8),
    "Secret Puzzle 2-03 Clear": LocationData("Secret L2", SECRET_CLEAR, 0x2A9),
    "Secret Puzzle 2-04 Clear": LocationData("Secret L2", SECRET_CLEAR, 0x2AA),
    "Secret Puzzle 2-05 Clear": LocationData("Secret L2", SECRET_CLEAR, 0x2AB),
    "Secret Puzzle 2-06 Clear": LocationData("Secret L2", SECRET_CLEAR, 0x2AC),
    "Secret Puzzle 2-07 Clear": LocationData("Secret L2", SECRET_CLEAR, 0x2AD),
    "Secret Puzzle 2-08 Clear": LocationData("Secret L2", SECRET_CLEAR, 0x2AE),
    "Secret Puzzle 2-09 Clear": LocationData("Secret L2", SECRET_CLEAR, 0x2AF),
    "Secret Puzzle 2-10 Clear": LocationData("Secret L2", SECRET_CLEAR, 0x2B0),
    "Secret Puzzle Round 2 Clear": LocationData("Secret L2", SECRET_ROUND_CLEAR, 0x2A6),
    "Secret Puzzle 3-01 Clear": LocationData("Secret L3", SECRET_CLEAR, 0x2B2),
    "Secret Puzzle 3-02 Clear": LocationData("Secret L3", SECRET_CLEAR, 0x2B3),
    "Secret Puzzle 3-03 Clear": LocationData("Secret L3", SECRET_CLEAR, 0x2B4),
    "Secret Puzzle 3-04 Clear": LocationData("Secret L3", SECRET_CLEAR, 0x2B5),
    "Secret Puzzle 3-05 Clear": LocationData("Secret L3", SECRET_CLEAR, 0x2B6),
    "Secret Puzzle 3-06 Clear": LocationData("Secret L3", SECRET_CLEAR, 0x2B7),
    "Secret Puzzle 3-07 Clear": LocationData("Secret L3", SECRET_CLEAR, 0x2B8),
    "Secret Puzzle 3-08 Clear": LocationData("Secret L3", SECRET_CLEAR, 0x2B9),
    "Secret Puzzle 3-09 Clear": LocationData("Secret L3", SECRET_CLEAR, 0x2BA),
    "Secret Puzzle 3-10 Clear": LocationData("Secret L3", SECRET_CLEAR, 0x2BB),
    "Secret Puzzle Round 3 Clear": LocationData("Secret L3", SECRET_ROUND_CLEAR, 0x2B1),
    "Secret Puzzle 4-01 Clear": LocationData("Secret L4", SECRET_CLEAR, 0x2BD),
    "Secret Puzzle 4-02 Clear": LocationData("Secret L4", SECRET_CLEAR, 0x2BE),
    "Secret Puzzle 4-03 Clear": LocationData("Secret L4", SECRET_CLEAR, 0x2BF),
    "Secret Puzzle 4-04 Clear": LocationData("Secret L4", SECRET_CLEAR, 0x2C0),
    "Secret Puzzle 4-05 Clear": LocationData("Secret L4", SECRET_CLEAR, 0x2C1),
    "Secret Puzzle 4-06 Clear": LocationData("Secret L4", SECRET_CLEAR, 0x2C2),
    "Secret Puzzle 4-07 Clear": LocationData("Secret L4", SECRET_CLEAR, 0x2C3),
    "Secret Puzzle 4-08 Clear": LocationData("Secret L4", SECRET_CLEAR, 0x2C4),
    "Secret Puzzle 4-09 Clear": LocationData("Secret L4", SECRET_CLEAR, 0x2C5),
    "Secret Puzzle 4-10 Clear": LocationData("Secret L4", SECRET_CLEAR, 0x2C6),
    "Secret Puzzle Round 4 Clear": LocationData("Secret L4", SECRET_ROUND_CLEAR, 0x2BC),
    "Secret Puzzle 5-01 Clear": LocationData("Secret L5", SECRET_CLEAR, 0x2C8),
    "Secret Puzzle 5-02 Clear": LocationData("Secret L5", SECRET_CLEAR, 0x2C9),
    "Secret Puzzle 5-03 Clear": LocationData("Secret L5", SECRET_CLEAR, 0x2CA),
    "Secret Puzzle 5-04 Clear": LocationData("Secret L5", SECRET_CLEAR, 0x2CB),
    "Secret Puzzle 5-05 Clear": LocationData("Secret L5", SECRET_CLEAR, 0x2CC),
    "Secret Puzzle 5-06 Clear": LocationData("Secret L5", SECRET_CLEAR, 0x2CD),
    "Secret Puzzle 5-07 Clear": LocationData("Secret L5", SECRET_CLEAR, 0x2CE),
    "Secret Puzzle 5-08 Clear": LocationData("Secret L5", SECRET_CLEAR, 0x2CF),
    "Secret Puzzle 5-09 Clear": LocationData("Secret L5", SECRET_CLEAR, 0x2D0),
    "Secret Puzzle 5-10 Clear": LocationData("Secret L5", SECRET_CLEAR, 0x2D1),
    "Secret Puzzle Round 5 Clear": LocationData("Secret L5", SECRET_ROUND_CLEAR, 0x2C7),
    "Secret Puzzle 6-01 Clear": LocationData("Secret L6", SECRET_CLEAR, 0x2D3),
    "Secret Puzzle 6-02 Clear": LocationData("Secret L6", SECRET_CLEAR, 0x2D4),
    "Secret Puzzle 6-03 Clear": LocationData("Secret L6", SECRET_CLEAR, 0x2D5),
    "Secret Puzzle 6-04 Clear": LocationData("Secret L6", SECRET_CLEAR, 0x2D6),
    "Secret Puzzle 6-05 Clear": LocationData("Secret L6", SECRET_CLEAR, 0x2D7),
    "Secret Puzzle 6-06 Clear": LocationData("Secret L6", SECRET_CLEAR, 0x2D8),
    "Secret Puzzle 6-07 Clear": LocationData("Secret L6", SECRET_CLEAR, 0x2D9),
    "Secret Puzzle 6-08 Clear": LocationData("Secret L6", SECRET_CLEAR, 0x2DA),
    "Secret Puzzle 6-09 Clear": LocationData("Secret L6", SECRET_CLEAR, 0x2DB),
    "Secret Puzzle 6-10 Clear": LocationData("Secret L6", SECRET_CLEAR, 0x2DC),
    "Secret Puzzle Round 6 Clear": LocationData("Secret L6", SECRET_ROUND_CLEAR, 0x2D2),
}


def get_locations(world: Optional["TetrisAttackWorld"]) -> Dict[str, LocationData]:
    include_stage_clear = True
    include_sc_round_clears = True
    include_sc_individual_clears = True
    exclude_sc_round_6_last_check = True
    include_pz_round_clears = True
    include_pz_individual_clears = True
    include_secret_round_clears = True
    include_secret_individual_clears = True
    multiple_goals = True
    special_stage_trap_count = 1
    if world:
        include_stage_clear = world.options.stage_clear_goal or world.options.stage_clear_inclusion
        include_sc_round_clears = stage_clear_round_clears_included(world)
        include_sc_individual_clears = stage_clear_individual_clears_included(world)
        exclude_sc_round_6_last_check = world.options.starter_pack != StarterPack.option_stage_clear_round_6
        include_normal_puzzles = normal_puzzle_set_included(world)
        include_secret_puzzles = secret_puzzle_set_included(world)
        puzzle_round_clears = puzzle_round_clears_included(world)
        puzzle_individual_clears = puzzle_individual_clears_included(world)
        include_pz_round_clears = puzzle_round_clears and include_normal_puzzles
        include_pz_individual_clears = puzzle_individual_clears and include_normal_puzzles
        include_secret_round_clears = puzzle_round_clears and include_secret_puzzles
        include_secret_individual_clears = puzzle_individual_clears and include_secret_puzzles
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
    if include_secret_round_clears:
        included_classes.append(SECRET_ROUND_CLEAR)
    if include_secret_individual_clears:
        included_classes.append(SECRET_CLEAR)
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

    new_locations = dict(
        filter(lambda item: item[1].location_class in included_classes and item[0] not in excluded_locations,
               location_table.items()))

    return new_locations
