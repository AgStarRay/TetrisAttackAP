from typing import Dict, NamedTuple, Optional

from BaseClasses import ItemClassification


class ItemData(NamedTuple):
    category: str
    code: Optional[int]
    classification: ItemClassification
    amount: Optional[int] = 1


item_table: Dict[str, ItemData] = {
    "Stage Clear Round 1": ItemData("Stage Clear", 0x0025, ItemClassification.progression),
    "Stage Clear Round 2": ItemData("Stage Clear", 0x002B, ItemClassification.progression),
    "Stage Clear Round 3": ItemData("Stage Clear", 0x0031, ItemClassification.progression),
    "Stage Clear Round 4": ItemData("Stage Clear", 0x0037, ItemClassification.progression),
    "Stage Clear Round 5": ItemData("Stage Clear", 0x003D, ItemClassification.progression),
    "Stage Clear Round 6": ItemData("Stage Clear", 0x0043, ItemClassification.progression),
    "Stage Clear Last Stage": ItemData("Stage Clear", 0x0044, ItemClassification.progression),
    "Stage Clear Completion": ItemData("Stage Clear", None, ItemClassification.progression),
}

stage_clear_filler = [
    "Stage Clear Round 1",
    "Stage Clear Round 2",
    "Stage Clear Round 3",
    "Stage Clear Round 4",
    "Stage Clear Round 5"
]
