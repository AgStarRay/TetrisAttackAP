from Options import PerGameCommonOptions, DeathLink, Choice
from dataclasses import dataclass


class PlayerGoal(Choice):
    """This sets the goal(s).
    If multiple modes need to be cleared, each will provide a final item and auto-hint the other win conditions."""
    option_stage_clear = 0
    default = 0


class StarterPack(Choice):
    """This provides a set of stages and puzzles to start with.
    If you're doing Stage Clear only and you don't pick Round 6, the Last Stage will be placed in Round 6."""
    option_stage_clear_round_1 = 0
    option_stage_clear_round_2 = 1
    option_stage_clear_round_3 = 2
    option_stage_clear_round_4 = 3
    option_stage_clear_round_5 = 4
    option_stage_clear_round_6 = 5
    default = 0


class AutoHints(Choice):
    """If enabled, goal items are auto-hinted after completing a mode"""
    option_disabled = 0
    option_enabled = 1
    default = 1


@dataclass
class TetrisAttackOptions(PerGameCommonOptions):
    starter_pack: StarterPack
    goal: PlayerGoal
    autohints: AutoHints
