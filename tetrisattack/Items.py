from typing import List, Set, Dict, NamedTuple, Optional, TYPE_CHECKING

from BaseClasses import ItemClassification
from .Logic import stage_clear_progressive_unlocks_included, stage_clear_individual_unlocks_included, \
    stage_clear_round_gates_included
from .Options import StarterPack

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


class ItemData(NamedTuple):
    category: str
    code: Optional[int]
    item_class: int
    classification: ItemClassification
    amount: Optional[int] = 1
    starting_id: Optional[int] = None


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
    # Items with IDs of at least 0x020 correspond to SRAM locations
    "Stage Clear 1-1 Unlock": ItemData("SC Round 1", 0x021, SC_INDIVIDUAL_UNLOCK,
                                       ItemClassification.progression),
    "Stage Clear 1-2 Unlock": ItemData("SC Round 1", 0x022, SC_INDIVIDUAL_UNLOCK,
                                       ItemClassification.progression),
    "Stage Clear 1-3 Unlock": ItemData("SC Round 1", 0x023, SC_INDIVIDUAL_UNLOCK,
                                       ItemClassification.progression),
    "Stage Clear 1-4 Unlock": ItemData("SC Round 1", 0x024, SC_INDIVIDUAL_UNLOCK,
                                       ItemClassification.progression),
    "Stage Clear 1-5 Unlock": ItemData("SC Round 1", 0x025, SC_INDIVIDUAL_UNLOCK,
                                       ItemClassification.progression),
    "Stage Clear Round 1 Gate": ItemData("Stage Clear", 0x020, SC_ROUND_GATE,
                                         ItemClassification.progression),
    "Stage Clear 2-1 Unlock": ItemData("SC Round 2", 0x027, SC_INDIVIDUAL_UNLOCK,
                                       ItemClassification.progression),
    "Stage Clear 2-2 Unlock": ItemData("SC Round 2", 0x028, SC_INDIVIDUAL_UNLOCK,
                                       ItemClassification.progression),
    "Stage Clear 2-3 Unlock": ItemData("SC Round 2", 0x029, SC_INDIVIDUAL_UNLOCK,
                                       ItemClassification.progression),
    "Stage Clear 2-4 Unlock": ItemData("SC Round 2", 0x02A, SC_INDIVIDUAL_UNLOCK,
                                       ItemClassification.progression),
    "Stage Clear 2-5 Unlock": ItemData("SC Round 2", 0x02B, SC_INDIVIDUAL_UNLOCK,
                                       ItemClassification.progression),
    "Stage Clear Round 2 Gate": ItemData("Stage Clear", 0x026, SC_ROUND_GATE,
                                         ItemClassification.progression),
    "Stage Clear 3-1 Unlock": ItemData("SC Round 3", 0x02D, SC_INDIVIDUAL_UNLOCK,
                                       ItemClassification.progression),
    "Stage Clear 3-2 Unlock": ItemData("SC Round 3", 0x02E, SC_INDIVIDUAL_UNLOCK,
                                       ItemClassification.progression),
    "Stage Clear 3-3 Unlock": ItemData("SC Round 3", 0x02F, SC_INDIVIDUAL_UNLOCK,
                                       ItemClassification.progression),
    "Stage Clear 3-4 Unlock": ItemData("SC Round 3", 0x030, SC_INDIVIDUAL_UNLOCK,
                                       ItemClassification.progression),
    "Stage Clear 3-5 Unlock": ItemData("SC Round 3", 0x031, SC_INDIVIDUAL_UNLOCK,
                                       ItemClassification.progression),
    "Stage Clear Round 3 Gate": ItemData("Stage Clear", 0x02C, SC_ROUND_GATE,
                                         ItemClassification.progression),
    "Stage Clear 4-1 Unlock": ItemData("SC Round 4", 0x033, SC_INDIVIDUAL_UNLOCK,
                                       ItemClassification.progression),
    "Stage Clear 4-2 Unlock": ItemData("SC Round 4", 0x034, SC_INDIVIDUAL_UNLOCK,
                                       ItemClassification.progression),
    "Stage Clear 4-3 Unlock": ItemData("SC Round 4", 0x035, SC_INDIVIDUAL_UNLOCK,
                                       ItemClassification.progression),
    "Stage Clear 4-4 Unlock": ItemData("SC Round 4", 0x036, SC_INDIVIDUAL_UNLOCK,
                                       ItemClassification.progression),
    "Stage Clear 4-5 Unlock": ItemData("SC Round 4", 0x037, SC_INDIVIDUAL_UNLOCK,
                                       ItemClassification.progression),
    "Stage Clear Round 4 Gate": ItemData("Stage Clear", 0x032, SC_ROUND_GATE,
                                         ItemClassification.progression),
    "Stage Clear 5-1 Unlock": ItemData("SC Round 5", 0x039, SC_INDIVIDUAL_UNLOCK,
                                       ItemClassification.progression),
    "Stage Clear 5-2 Unlock": ItemData("SC Round 5", 0x03A, SC_INDIVIDUAL_UNLOCK,
                                       ItemClassification.progression),
    "Stage Clear 5-3 Unlock": ItemData("SC Round 5", 0x03B, SC_INDIVIDUAL_UNLOCK,
                                       ItemClassification.progression),
    "Stage Clear 5-4 Unlock": ItemData("SC Round 5", 0x03C, SC_INDIVIDUAL_UNLOCK,
                                       ItemClassification.progression),
    "Stage Clear 5-5 Unlock": ItemData("SC Round 5", 0x03D, SC_INDIVIDUAL_UNLOCK,
                                       ItemClassification.progression),
    "Stage Clear Round 5 Gate": ItemData("Stage Clear", 0x038, SC_ROUND_GATE,
                                         ItemClassification.progression),
    "Stage Clear 6-1 Unlock": ItemData("SC Round 6", 0x03F, SC_INDIVIDUAL_UNLOCK,
                                       ItemClassification.progression),
    "Stage Clear 6-2 Unlock": ItemData("SC Round 6", 0x040, SC_INDIVIDUAL_UNLOCK,
                                       ItemClassification.progression),
    "Stage Clear 6-3 Unlock": ItemData("SC Round 6", 0x041, SC_INDIVIDUAL_UNLOCK,
                                       ItemClassification.progression),
    "Stage Clear 6-4 Unlock": ItemData("SC Round 6", 0x042, SC_INDIVIDUAL_UNLOCK,
                                       ItemClassification.progression),
    "Stage Clear 6-5 Unlock": ItemData("SC Round 6", 0x043, SC_INDIVIDUAL_UNLOCK,
                                       ItemClassification.progression),
    "Stage Clear Round 6 Gate": ItemData("Stage Clear", 0x03E, SC_ROUND_GATE,
                                         ItemClassification.progression),
    "Stage Clear Last Stage": ItemData("Stage Clear", 0x044, SC_GOAL,
                                       ItemClassification.progression),
    "Stage Clear Special Stage Trap": ItemData("Stage Clear", 0x045, SC_TRAP,
                                               ItemClassification.trap),
    "Stage Clear Completion": ItemData("Stage Clear", None, SC_GOAL,
                                       ItemClassification.progression),
    "Placeholder Filler": ItemData("Menu", 0x01FF, FILLER, ItemClassification.filler),
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
    special_stage_trap_count = 1
    excluded_items: Set[str] = set()
    if world:
        include_sc_progressive_unlocks = stage_clear_progressive_unlocks_included(world)
        include_sc_individual_unlocks = stage_clear_individual_unlocks_included(world)
        include_sc_round_gates = stage_clear_round_gates_included(world)
        special_stage_trap_count = world.options.special_stage_trap_count
        excluded_items.add(f"Stage Clear Progressive Round {world.options.starter_pack + 1} Unlock")
        excluded_items.add(f"Stage Clear Round {world.options.starter_pack + 1} Gate")
        excluded_items.add(f"Stage Clear {world.options.starter_pack + 1}-1 Unlock")
        excluded_items.add(f"Stage Clear {world.options.starter_pack + 1}-2 Unlock")
        excluded_items.add(f"Stage Clear {world.options.starter_pack + 1}-3 Unlock")
        excluded_items.add(f"Stage Clear {world.options.starter_pack + 1}-4 Unlock")
        excluded_items.add(f"Stage Clear {world.options.starter_pack + 1}-5 Unlock")
        if world.options.starter_pack != StarterPack.option_stage_clear_round_6:
            excluded_items.add("Stage Clear Last Stage")

    included_classes: List[int] = []
    if include_sc_progressive_unlocks:
        included_classes.append(SC_PROGRESSIVE_UNLOCK)
    if include_sc_individual_unlocks:
        included_classes.append(SC_INDIVIDUAL_UNLOCK)
    if include_sc_round_gates:
        included_classes.append(SC_ROUND_GATE)

    new_items = dict(filter(lambda item: item[1].item_class in included_classes and item[0] not in excluded_items,
                            item_table.items()))
    if special_stage_trap_count > 0:
        new_items["Stage Clear Special Stage Trap"] = ItemData("Stage Clear", 7, SC_TRAP,
                                                               ItemClassification.trap, special_stage_trap_count)
    return new_items
