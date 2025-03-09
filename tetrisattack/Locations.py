from typing import List, Set, Dict, NamedTuple, Optional, TYPE_CHECKING

from BaseClasses import Location
from worlds.generic.Rules import CollectionRule
from worlds.tetrisattack.Logic import stage_clear_round_clears_included, stage_clear_individual_clears_included
from .Options import StarterPack

if TYPE_CHECKING:
    from . import TetrisAttackWorld

SC_GOAL = 1
SC_STAGE_CLEAR = 2
SC_ROUND_CLEAR = 3


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
    "Stage Clear Round 1 Clear": LocationData("SC Round 1", SC_ROUND_CLEAR, 0x205),
    "Stage Clear Round 2 Clear": LocationData("SC Round 2", SC_ROUND_CLEAR, 0x20B),
    "Stage Clear Round 3 Clear": LocationData("SC Round 3", SC_ROUND_CLEAR, 0x211),
    "Stage Clear Round 4 Clear": LocationData("SC Round 4", SC_ROUND_CLEAR, 0x217),
    "Stage Clear Round 5 Clear": LocationData("SC Round 5", SC_ROUND_CLEAR, 0x21D),
    "Stage Clear Round 6 Clear": LocationData("SC Round 6", SC_ROUND_CLEAR, 0x223),
    "Stage Clear 1-1 Clear": LocationData("SC Round 1", SC_STAGE_CLEAR, 0x200),
    "Stage Clear 1-2 Clear": LocationData("SC Round 1", SC_STAGE_CLEAR, 0x201),
    "Stage Clear 1-3 Clear": LocationData("SC Round 1", SC_STAGE_CLEAR, 0x202),
    "Stage Clear 1-4 Clear": LocationData("SC Round 1", SC_STAGE_CLEAR, 0x203),
    "Stage Clear 1-5 Clear": LocationData("SC Round 1", SC_STAGE_CLEAR, 0x204),
    "Stage Clear 2-1 Clear": LocationData("SC Round 2", SC_STAGE_CLEAR, 0x206),
    "Stage Clear 2-2 Clear": LocationData("SC Round 2", SC_STAGE_CLEAR, 0x207),
    "Stage Clear 2-3 Clear": LocationData("SC Round 2", SC_STAGE_CLEAR, 0x208),
    "Stage Clear 2-4 Clear": LocationData("SC Round 2", SC_STAGE_CLEAR, 0x209),
    "Stage Clear 2-5 Clear": LocationData("SC Round 2", SC_STAGE_CLEAR, 0x20A),
    "Stage Clear 3-1 Clear": LocationData("SC Round 3", SC_STAGE_CLEAR, 0x20C),
    "Stage Clear 3-2 Clear": LocationData("SC Round 3", SC_STAGE_CLEAR, 0x20D),
    "Stage Clear 3-3 Clear": LocationData("SC Round 3", SC_STAGE_CLEAR, 0x20E),
    "Stage Clear 3-4 Clear": LocationData("SC Round 3", SC_STAGE_CLEAR, 0x20F),
    "Stage Clear 3-5 Clear": LocationData("SC Round 3", SC_STAGE_CLEAR, 0x210),
    "Stage Clear 4-1 Clear": LocationData("SC Round 4", SC_STAGE_CLEAR, 0x212),
    "Stage Clear 4-2 Clear": LocationData("SC Round 4", SC_STAGE_CLEAR, 0x213),
    "Stage Clear 4-3 Clear": LocationData("SC Round 4", SC_STAGE_CLEAR, 0x214),
    "Stage Clear 4-4 Clear": LocationData("SC Round 4", SC_STAGE_CLEAR, 0x215),
    "Stage Clear 4-5 Clear": LocationData("SC Round 4", SC_STAGE_CLEAR, 0x216),
    "Stage Clear 5-1 Clear": LocationData("SC Round 5", SC_STAGE_CLEAR, 0x218),
    "Stage Clear 5-2 Clear": LocationData("SC Round 5", SC_STAGE_CLEAR, 0x219),
    "Stage Clear 5-3 Clear": LocationData("SC Round 5", SC_STAGE_CLEAR, 0x21A),
    "Stage Clear 5-4 Clear": LocationData("SC Round 5", SC_STAGE_CLEAR, 0x21B),
    "Stage Clear 5-5 Clear": LocationData("SC Round 5", SC_STAGE_CLEAR, 0x21C),
    "Stage Clear 6-1 Clear": LocationData("SC Round 6", SC_STAGE_CLEAR, 0x21E),
    "Stage Clear 6-2 Clear": LocationData("SC Round 6", SC_STAGE_CLEAR, 0x21F),
    "Stage Clear 6-3 Clear": LocationData("SC Round 6", SC_STAGE_CLEAR, 0x220),
    "Stage Clear 6-4 Clear": LocationData("SC Round 6", SC_STAGE_CLEAR, 0x221),
    "Stage Clear 6-5 Clear": LocationData("SC Round 6", SC_STAGE_CLEAR, 0x222),
    "Stage Clear Last Stage Clear": LocationData("Stage Clear", SC_GOAL, None)  # With other goals this needs 0x224
}


def get_locations(world: Optional["TetrisAttackWorld"]) -> Dict[str, LocationData]:
    include_round_clears = True
    include_individual_clears = True
    exclude_round_6_last_check = False
    if world:
        include_round_clears = stage_clear_round_clears_included(world)
        include_individual_clears = stage_clear_individual_clears_included(world)
        exclude_round_6_last_check = world.options.starter_pack != StarterPack.option_stage_clear_round_6

    excluded_locations: Set[str] = set()
    excluded_locations.add("Stage Clear Last Stage Clear")
    included_classes: List[int] = [SC_GOAL]
    if include_round_clears:
        included_classes.append(SC_ROUND_CLEAR)
    if include_individual_clears:
        included_classes.append(SC_STAGE_CLEAR)
    if exclude_round_6_last_check:
        if include_round_clears:
            excluded_locations.add("Stage Clear Round 6 Clear")
        else:
            excluded_locations.add("Stage Clear 6-5 Clear")

    return dict(filter(lambda item: item[1].location_class in included_classes and item[0] not in excluded_locations,
                       location_table.items()))
