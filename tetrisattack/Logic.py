from typing import TYPE_CHECKING

from BaseClasses import CollectionState
from .Options import StarterPack, StageClearMode

if TYPE_CHECKING:
    from . import TetrisAttackWorld


def stage_clear_round_completable(world: "TetrisAttackWorld", state: CollectionState, round_number: int):
    if not stage_clear_round_accessible(world, state, round_number):
        return False

    match world.options.stage_clear_mode:
        case StageClearMode.option_whole_rounds:
            return True
        case StageClearMode.option_individual_stages \
             | StageClearMode.option_incremental \
             | StageClearMode.option_incremental_with_round_gate:
            return state.has(f"Stage Clear Progressive Round {round_number} Unlock", world.player, 5)
        case StageClearMode.option_skippable \
             | StageClearMode.option_skippable_with_round_gate:
            return (state.has(f"Stage Clear {round_number}-1 Unlock", world.player)
                    and state.has(f"Stage Clear {round_number}-2 Unlock", world.player)
                    and state.has(f"Stage Clear {round_number}-3 Unlock", world.player)
                    and state.has(f"Stage Clear {round_number}-4 Unlock", world.player)
                    and state.has(f"Stage Clear {round_number}-5 Unlock", world.player))
        case _:
            raise Exception(
                f"Cannot determine round completion from Stage Clear mode {world.options.stage_clear_mode}")


def stage_clear_stage_completable(world: "TetrisAttackWorld", state, round_number: int, stage_number: int):
    if not stage_clear_round_accessible(world, state, round_number):
        return False

    match world.options.stage_clear_mode:
        case StageClearMode.option_whole_rounds \
             | StageClearMode.option_individual_stages:
            return True
        case StageClearMode.option_incremental \
             | StageClearMode.option_incremental_with_round_gate:
            return state.has(f"Stage Clear Progressive Round {round_number} Unlock", world.player, stage_number)
        case StageClearMode.option_skippable \
             | StageClearMode.option_skippable_with_round_gate:
            return state.has(f"Stage Clear {round_number}-{stage_number} Unlock", world.player)
        case _:
            raise Exception(
                f"Cannot determine stage completion from Stage Clear mode {world.options.stage_clear_mode}")


def stage_clear_round_accessible(world: "TetrisAttackWorld", state, round_number: int):
    match world.options.stage_clear_mode:
        case StageClearMode.option_whole_rounds \
             | StageClearMode.option_skippable_with_round_gate \
             | StageClearMode.option_incremental_with_round_gate:
            return state.has(f"Stage Clear Round {round_number} Gate", world.player)
        case StageClearMode.option_individual_stages:
            return state.has(f"Stage Clear Progressive Round {round_number} Unlock", world.player, 5)
        case StageClearMode.option_incremental \
             | StageClearMode.option_skippable:
            return True
        case _:
            raise Exception(
                f"Cannot determine round accessibility from Stage Clear mode {world.options.stage_clear_mode}")


def stage_clear_round_clears_included(world: "TetrisAttackWorld"):
    if world.options.stage_clear_filler:
        return True
    match world.options.stage_clear_mode:
        case StageClearMode.option_whole_rounds \
             | StageClearMode.option_skippable_with_round_gate \
             | StageClearMode.option_incremental_with_round_gate:
            return True
        case StageClearMode.option_individual_stages:
            # Due to branching logic in the fill stage, not adding filler leads to unbeatable seeds
            # TODO: Check for other filler options before forcing round clear locations, or find a way to fill the locations smarter
            return True
        case StageClearMode.option_incremental \
             | StageClearMode.option_skippable:
            return False
        case _:
            raise Exception(
                f"Cannot determine round clear inclusions from Stage Clear mode {world.options.stage_clear_mode}")


def stage_clear_individual_clears_included(world: "TetrisAttackWorld"):
    if world.options.stage_clear_filler:
        return True
    match world.options.stage_clear_mode:
        case StageClearMode.option_whole_rounds:
            return False
        case StageClearMode.option_individual_stages \
             | StageClearMode.option_incremental \
             | StageClearMode.option_incremental_with_round_gate \
             | StageClearMode.option_skippable_with_round_gate \
             | StageClearMode.option_skippable:
            return True
        case _:
            raise Exception(
                f"Cannot determine individual clear inclusions from Stage Clear mode {world.options.stage_clear_mode}")


def stage_clear_progressive_unlocks_included(world: "TetrisAttackWorld"):
    match world.options.stage_clear_mode:
        case StageClearMode.option_whole_rounds \
             | StageClearMode.option_skippable_with_round_gate \
             | StageClearMode.option_skippable:
            return False
        case StageClearMode.option_individual_stages \
             | StageClearMode.option_incremental \
             | StageClearMode.option_incremental_with_round_gate:
            return True
        case _:
            raise Exception(
                f"Cannot determine progressive unlock inclusions from Stage Clear mode {world.options.stage_clear_mode}")


def stage_clear_individual_unlocks_included(world: "TetrisAttackWorld"):
    match world.options.stage_clear_mode:
        case StageClearMode.option_whole_rounds \
             | StageClearMode.option_individual_stages \
             | StageClearMode.option_incremental \
             | StageClearMode.option_incremental_with_round_gate:
            return False
        case StageClearMode.option_skippable_with_round_gate \
             | StageClearMode.option_skippable:
            return True
        case _:
            raise Exception(
                f"Cannot determine individual unlock inclusions from Stage Clear mode {world.options.stage_clear_mode}")


def stage_clear_round_gates_included(world: "TetrisAttackWorld"):
    match world.options.stage_clear_mode:
        case StageClearMode.option_whole_rounds \
             | StageClearMode.option_incremental_with_round_gate \
             | StageClearMode.option_skippable_with_round_gate:
            return True
        case StageClearMode.option_individual_stages \
             | StageClearMode.option_incremental \
             | StageClearMode.option_skippable:
            return False
        case _:
            raise Exception(
                f"Cannot determine round gate inclusions from Stage Clear mode {world.options.stage_clear_mode}")


def stage_clear_able_to_win(world: "TetrisAttackWorld", state):
    if world.options.starter_pack == StarterPack.option_stage_clear_round_6:
        return state.has("Stage Clear Last Stage", world.player)
    return stage_clear_round_completable(world, state, 6)
