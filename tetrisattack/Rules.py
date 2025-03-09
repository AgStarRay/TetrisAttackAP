import logging

from worlds.generic.Rules import set_rule
from typing import TYPE_CHECKING

from .Locations import TetrisAttackLocation
from .Logic import stage_clear_round_clears_included, stage_clear_round_completable, \
    stage_clear_individual_clears_included, stage_clear_stage_completable, stage_clear_able_to_win
from .Options import StarterPack

if TYPE_CHECKING:
    from . import TetrisAttackWorld, item_table


def set_stage_clear_round_clear_rules(world: "TetrisAttackWorld") -> None:
    player = world.player
    if stage_clear_round_clears_included(world):
        set_rule(world.multiworld.get_location("Stage Clear Round 1 Clear", player),
                 lambda state: stage_clear_round_completable(world, state, 1))
        set_rule(world.multiworld.get_location("Stage Clear Round 2 Clear", player),
                 lambda state: stage_clear_round_completable(world, state, 2))
        set_rule(world.multiworld.get_location("Stage Clear Round 3 Clear", player),
                 lambda state: stage_clear_round_completable(world, state, 3))
        set_rule(world.multiworld.get_location("Stage Clear Round 4 Clear", player),
                 lambda state: stage_clear_round_completable(world, state, 4))
        set_rule(world.multiworld.get_location("Stage Clear Round 5 Clear", player),
                 lambda state: stage_clear_round_completable(world, state, 5))
        if world.options.starter_pack == StarterPack.option_stage_clear_round_6:
            set_rule(world.multiworld.get_location("Stage Clear Round 6 Clear", player),
                     lambda state: stage_clear_round_completable(world, state, 6))


def set_stage_clear_individual_clear_rules(world: "TetrisAttackWorld") -> None:
    player = world.player

    include_round_6_5 = "Stage Clear 6-5 Clear" in world.multiworld.get_locations(player)
    if stage_clear_individual_clears_included(world):
        for round_number in range(1, 7):
            for stage_number in range(1, 6):
                if include_round_6_5 or round_number != 6 or stage_number != 5:
                    set_rule(world.multiworld.get_location(f"Stage Clear {round_number}-{stage_number} Clear", player),
                             lambda state, r=round_number, s=stage_number: stage_clear_stage_completable(world, state,
                                                                                                         r, s))


def set_goal_rules(world: "TetrisAttackWorld") -> None:
    player = world.player

    completion_loc = TetrisAttackLocation(player, "Stage Clear Completion")
    completion_loc.place_locked_item(
        world.create_event("Stage Clear Completion")
    )
    if world.options.starter_pack != StarterPack.option_stage_clear_round_6:
        set_rule(completion_loc, lambda state: stage_clear_round_completable(world, state, 6))
    else:
        final_round_index = world.multiworld.random.randint(1, 5)
        set_rule(completion_loc, lambda state: state.has("Stage Clear Last Stage"))
        if stage_clear_round_clears_included(world):
            final_loc = world.multiworld.get_location(f"Stage Clear Round {final_round_index} Clear", world.player)
        else:
            final_loc = world.multiworld.get_location(f"Stage Clear {final_round_index}-5 Clear", world.player)
        final_loc.place_locked_item(world.create_item("Stage Clear Last Stage"))
    world.multiworld.completion_condition[world.player] = lambda state: stage_clear_able_to_win(world, state)
