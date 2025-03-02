
from worlds.generic.Rules import set_rule
from typing import TYPE_CHECKING

from .Logic import TetrisAttackLogic

if TYPE_CHECKING:
    from . import TetrisAttackWorld


def set_stage_clear_whole_round_rules(world: "TetrisAttackWorld") -> None:
    logic = TetrisAttackLogic(world)
    player = world.player

    set_rule(world.multiworld.get_location("Stage Clear Round 1 Clear", player), lambda state: state.has("Stage Clear Round 1", player))
    set_rule(world.multiworld.get_location("Stage Clear Round 2 Clear", player), lambda state: state.has("Stage Clear Round 2", player))
    set_rule(world.multiworld.get_location("Stage Clear Round 3 Clear", player), lambda state: state.has("Stage Clear Round 3", player))
    set_rule(world.multiworld.get_location("Stage Clear Round 4 Clear", player), lambda state: state.has("Stage Clear Round 4", player))
    set_rule(world.multiworld.get_location("Stage Clear Round 5 Clear", player), lambda state: state.has("Stage Clear Round 5", player))
    set_rule(world.multiworld.get_location("Stage Clear Round 6 Clear", player), lambda state: state.has("Stage Clear Round 6", player))
    set_rule(world.multiworld.get_location("Stage Clear Last Stage Clear", player), lambda state: state.has("Stage Clear Last Stage", player))