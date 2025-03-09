from Options import PerGameCommonOptions, DeathLink, Choice, Toggle, DefaultOnToggle
from dataclasses import dataclass


class PlayerGoal(Choice):
    """This sets the goal(s).
    If multiple modes need to be cleared, each will provide a final item and auto-hint the other win conditions."""
    option_stage_clear = 0
    default = 0


class StarterPack(Choice):
    """This provides a set of stages and puzzles to start with.
    If you're doing Stage Clear only and you don't start in Round 6, the Last Stage will be in Round 6.
    Starting with only one Stage Clear round has all 5 stages in that round unlocked.
    Starting with only one Puzzle world has all 10 puzzles in that world unlocked."""
    option_stage_clear_round_1 = 0
    option_stage_clear_round_2 = 1
    option_stage_clear_round_3 = 2
    option_stage_clear_round_4 = 3
    option_stage_clear_round_5 = 4
    option_stage_clear_round_6 = 5
    default = 0


class AutoHints(DefaultOnToggle):
    """If enabled, goal items are auto-hinted after completing a mode"""


class AddFiller(DefaultOnToggle):
    """If enabled, the game will maximize the number of locations (aside from additional Special Stages) and add more filler items to the pool
    Note that there are situations where filler is forced, otherwise the logic would be too tight and lead to unbeatable seeds"""


class StageClearMode(Choice):
    """Determines how progression works in Stage Clear.
    Whole Rounds puts each round as one item.
    Individual Stages puts each round as 5 progressive items. All 5 are needed to start a round.
    Incremental puts each round as 5 progressive items with optional gate.
    Skippable puts each round as 5 or 6 items. You can start a round with some stages locked, but all 5 stages are needed for the Round Clear."""
    option_whole_rounds = 0
    option_individual_stages = 1
    option_incremental = 2
    option_incremental_with_round_gate = 3
    option_skippable = 4
    option_skippable_with_round_gate = 5
    default = 3


class StageClearSaves(DefaultOnToggle):
    """If enabled, Stage Clear will let you resume rounds at the first unchecked stage or the stage after the last cleared one, whichever is earlier"""


@dataclass
class TetrisAttackOptions(PerGameCommonOptions):
    starter_pack: StarterPack
    goal: PlayerGoal
    autohints: AutoHints
    death_link: DeathLink
    stage_clear_mode: StageClearMode
    stage_clear_saves: StageClearSaves
    stage_clear_filler: AddFiller
