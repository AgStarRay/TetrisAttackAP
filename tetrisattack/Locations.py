from typing import List, Dict, NamedTuple, Optional, TYPE_CHECKING
from worlds.generic.Rules import CollectionRule
from worlds.tetrisattack.Logic import TetrisAttackLogic

if TYPE_CHECKING:
    from . import TetrisAttackWorld


class LocationData(NamedTuple):
    region: str
    name: str
    code: Optional[int]
    rule: CollectionRule = lambda state: True

def get_locations(world: Optional["TetrisAttackWorld"]) -> List[LocationData]:
    if world:
        logic = TetrisAttackLogic(world)

    location_table: List[LocationData] = [
        LocationData("Stage Clear", "Stage Clear Round 1 Clear", 0x0605),
        LocationData("Stage Clear", "Stage Clear Round 2 Clear", 0x060B),
        LocationData("Stage Clear", "Stage Clear Round 3 Clear", 0x0611),
        LocationData("Stage Clear", "Stage Clear Round 4 Clear", 0x0617),
        LocationData("Stage Clear", "Stage Clear Round 5 Clear", 0x061D),
        LocationData("Stage Clear", "Stage Clear Round 6 Clear", 0x0623),
        LocationData("Stage Clear", "Stage Clear Last Stage Clear", None) # With other goals this needs 0x0624
    ]
    return location_table
