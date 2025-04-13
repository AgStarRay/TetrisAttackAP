from worlds.generic.Rules import set_rule
from typing import TYPE_CHECKING

from .Locations import TetrisAttackLocation
from .Logic import stage_clear_round_clears_included, stage_clear_round_completable, stage_clear_stage_completable, \
    able_to_win, puzzle_level_completable, puzzle_stage_completable, puzzle_able_to_win, stage_clear_able_to_win
from .Options import StarterPack, PuzzleGoal

if TYPE_CHECKING:
    from . import TetrisAttackWorld


def set_stage_clear_rules(world: "TetrisAttackWorld") -> None:
    for round_number in range(1, 7):
        try_set_rule(world, f"Stage Clear Round {round_number} Clear",
                     lambda state, r=round_number: stage_clear_round_completable(world, state, r))
        try_set_rule(world, f"Stage Clear Round {round_number} Special",
                     lambda state, r=round_number: stage_clear_round_completable(world, state, r))
        for stage_number in range(1, 6):
            try_set_rule(world, f"Stage Clear {round_number}-{stage_number} Clear",
                         lambda state, r=round_number, s=stage_number: stage_clear_stage_completable(world, state, r,
                                                                                                     s))
            try_set_rule(world, f"Stage Clear {round_number}-{stage_number} Special",
                         lambda state, r=round_number, s=stage_number: stage_clear_stage_completable(world, state, r,
                                                                                                     s))
    try_set_rule(world, "Stage Clear Last Stage Clear",
                 lambda state: stage_clear_able_to_win(world, state))


def set_puzzle_rules(world: "TetrisAttackWorld") -> None:
    for level_number in range(1, 7):
        try_set_rule(world, f"Puzzle Round {level_number} Clear",
                     lambda state, l=level_number: puzzle_level_completable(world, state, l))
        try_set_rule(world, f"Secret Puzzle Round {level_number} Clear",
                     lambda state, l=level_number + 6: puzzle_level_completable(world, state, l))
        for stage_number in range(1, 10):
            try_set_rule(world, f"Puzzle {level_number}-0{stage_number} Clear",
                         lambda state, l=level_number, s=stage_number: puzzle_stage_completable(world, state, l, s))
            try_set_rule(world, f"Secret Puzzle {level_number}-0{stage_number} Clear",
                         lambda state, l=level_number + 6, s=stage_number: puzzle_stage_completable(world, state, l, s))
        try_set_rule(world, f"Puzzle {level_number}-10 Clear",
                     lambda state, l=level_number: puzzle_stage_completable(world, state, l, 10))
        try_set_rule(world, f"Secret Puzzle {level_number}-10 Clear",
                     lambda state, l=level_number + 6: puzzle_stage_completable(world, state, l, 10))


def set_goal_rules(world: "TetrisAttackWorld") -> None:
    player = world.player

    if world.options.stage_clear_goal:
        sc_completion_loc = TetrisAttackLocation(player, "Stage Clear Completion")
        sc_completion_loc.place_locked_item(world.create_event("Stage Clear Completion"))
        set_rule(sc_completion_loc, lambda state: stage_clear_able_to_win(world, state))
    if world.options.starter_pack == StarterPack.option_stage_clear_round_6:
        final_round_index = world.multiworld.random.randint(1, 5)
        if stage_clear_round_clears_included(world):
            final_loc = world.multiworld.get_location(f"Stage Clear Round {final_round_index} Clear", world.player)
        else:
            final_loc = world.multiworld.get_location(f"Stage Clear {final_round_index}-5 Clear", world.player)
        final_loc.place_locked_item(world.create_item("Stage Clear Last Stage"))

    if world.options.puzzle_goal != PuzzleGoal.option_no_puzzle:
        pz_completion_loc = TetrisAttackLocation(player, "Puzzle Completion")
        pz_completion_loc.place_locked_item(world.create_event("Puzzle Completion"))
        set_rule(pz_completion_loc, lambda state: puzzle_able_to_win(world, state))

    world.multiworld.completion_condition[world.player] = lambda state: able_to_win(world, state)


def try_set_rule(world: "TetrisAttackWorld", location_name: str, rule):
    try:
        set_rule(world.multiworld.get_location(location_name, world.player), rule)
    except KeyError:
        pass
