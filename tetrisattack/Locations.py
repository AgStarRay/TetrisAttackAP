from typing import List, Set, Dict, NamedTuple, Optional, TYPE_CHECKING

from BaseClasses import Location
from worlds.generic.Rules import CollectionRule
from .Logic import stage_clear_round_clears_included, stage_clear_individual_clears_included, \
    round_clear_has_special, stage_clear_has_special
from .Options import StarterPack

if TYPE_CHECKING:
    from . import TetrisAttackWorld

SC_GOAL = 1
SC_STAGE_CLEAR = 2
SC_ROUND_CLEAR = 3
SC_SPECIAL = 4


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
}


def get_locations(world: Optional["TetrisAttackWorld"]) -> Dict[str, LocationData]:
    include_round_clears = True
    include_individual_clears = True
    exclude_round_6_last_check = False
    special_stage_trap_count = 1
    if world:
        include_round_clears = stage_clear_round_clears_included(world)
        include_individual_clears = stage_clear_individual_clears_included(world)
        exclude_round_6_last_check = world.options.starter_pack != StarterPack.option_stage_clear_round_6
        special_stage_trap_count = world.options.special_stage_trap_count

    excluded_locations: Set[str] = set()
    excluded_locations.add("Stage Clear Last Stage Clear")
    included_classes: List[int] = [SC_GOAL, SC_SPECIAL]
    if include_round_clears:
        included_classes.append(SC_ROUND_CLEAR)
    if include_individual_clears:
        included_classes.append(SC_STAGE_CLEAR)
    if exclude_round_6_last_check:
        if include_round_clears:
            excluded_locations.add("Stage Clear Round 6 Clear")
        else:
            excluded_locations.add("Stage Clear 6-5 Clear")
    for r in range(1, 7):
        if not round_clear_has_special(r, special_stage_trap_count):
            excluded_locations.add(f"Stage Clear Round {r} Special")
        for s in range(1, 6):
            if not stage_clear_has_special(r, s, special_stage_trap_count):
                excluded_locations.add(f"Stage Clear {r}-{s} Special")

    new_locations = dict(filter(lambda item: item[1].location_class in included_classes and item[0] not in excluded_locations,
                       location_table.items()))

    return new_locations
