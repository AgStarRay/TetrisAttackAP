from Options import PerGameCommonOptions, DeathLink, Choice, Toggle, DefaultOnToggle, Range
from dataclasses import dataclass


class StageClearGoal(DefaultOnToggle):
    """This makes Stage Clear Last Stage Clear one of the goals.
    If multiple modes need to be cleared, each will provide a final item and auto-hint the other win conditions."""


class PuzzleGoal(Choice):
    """This makes Puzzle and/or Secret Puzzle Round 6 Clear one of the goals.
    If multiple modes need to be cleared, each will provide a final item and auto-hint the other win conditions.
    NOTE: Secret Puzzles are not integrated yet."""
    option_no_puzzle = 0
    option_puzzle = 1
    # option_secret_puzzle = 2
    # option_puzzle_and_secret_puzzle = 3
    # option_puzzle_or_secret_puzzle = 4
    default = 1


class PuzzleAllClear(Toggle):
    """This makes the Puzzle goal require all 6 or 12 round clears, and thus all puzzles, instead of just the last round clear."""
    # TODO: Use this toggle


class VersusGoal(Choice):
    """This makes Versus one of the goals.
    If multiple modes need to be cleared, each will provide a final item and auto-hint the other win conditions.
    Note that harder difficulties will be forced to end at the goal difficulty's final stage.
    Stages that come after the goal stage will be extra unlocks and checks."""
    option_easy = 0
    option_normal = 1
    option_hard = 2
    option_very_hard = 3
    option_very_hard_no_continues = 4
    default = 2


class FriendshipGate(DefaultOnToggle):
    """When enabled, Versus stages 9 to 12 require all 8 recruitable characters."""


class StageClearInclusion(Toggle):
    """This adds Stage Clear to the randomizer, even if they are not part of the goal.
    Note that if the Last Stage is a goal, this won't have any effect."""


class PuzzleInclusion(Choice):
    """This adds Puzzles to the randomizer, even if they are not part of the goal.
    Note that if (Secret) Puzzle Round 6 Clear is a goal, this won't have any effect unless the other set is not a goal.
    NOTE: Secret Puzzles are not integrated yet."""
    option_no_puzzle = 0
    option_puzzle = 1
    # option_secret_puzzle = 2
    # option_puzzle_and_secret_puzzle = 3
    default = 0


class VersusInclusion(DefaultOnToggle):
    """This adds Versus to the randomizer, even if they are not part of the goal.
    Note that if clearing Versus is a goal, this won't have any effect."""


class StarterPack(Choice):
    """This provides a set of stages and puzzles to start with.
    If you're doing Stage Clear only and you don't start in Round 6, the Last Stage will be in Round 6.
    Starting with only one Stage Clear round has all 5 stages in that round unlocked.
    Starting with only one Puzzle level has all 10 puzzles in that level unlocked.
    If there are only secret puzzles and no regular puzzles, the starter level is corrected as such."""
    option_stage_clear_round_1 = 0
    option_stage_clear_round_2 = 1
    option_stage_clear_round_3 = 2
    option_stage_clear_round_4 = 3
    option_stage_clear_round_5 = 4
    option_stage_clear_round_6 = 5
    option_puzzle_level_1 = 6
    option_puzzle_level_2 = 7
    option_puzzle_level_3 = 8
    option_puzzle_level_4 = 9
    option_puzzle_level_5 = 10
    default = 0


class AutoHints(DefaultOnToggle):
    """If enabled, goal items are auto-hinted after completing a mode"""


class StageClearFiller(DefaultOnToggle):
    """If enabled, the game will maximize the number of locations (aside from additional Special Stages) and add more filler items to the pool.
    Note that there are situations where filler is forced, otherwise the logic would be too tight and lead to unbeatable seeds."""


class PuzzleFiller(DefaultOnToggle):
    """If enabled, the game will maximize the number of locations and add more filler items to the pool.
    Note that there are situations where filler is forced, otherwise the logic would be too tight and lead to unbeatable seeds."""


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


class SpecialStageTraps(Range):
    """Adds extra locations to certain Stage Clear stages such as Round 3 Clear, but as a consequence adds the Special Stage trap.
    When tripped, you must either win or lose the Special Stage before you can continue.
    Requires Stage Clear to be included."""
    range_start = 0
    range_end = 30
    default = 1


class SpecialStageHPMultiplier(Range):
    """Changes Bowser's HP to this times 100 in the Special Stage traps. Default (vanilla) is 6 (x100)."""
    range_start = 1
    range_end = 100
    default = 6


class LastStageHPMultiplier(Range):
    """Changes Bowser's HP to this times 100 at the Last Stage. Default (vanilla) is 6 (x100).
    For reference, a x2 Chain does 50 damage while a x6 Chain does a total of 980 damage."""
    range_start = 1
    range_end = 100
    default = 6


class PuzzleMode(Choice):
    """Determines how progression works in Puzzle.
    Whole Levels puts each level as one item.
    Individual Stages puts each level as 10 progressive items. All 10 are needed to start a level.
    Incremental puts each level as 10 progressive items with optional gate.
    Skippable puts each level as 10 or 11 items. You can start a level with some puzzles locked, but all 10 puzzles are needed for the Round Clear."""
    option_whole_levels = 0
    option_individual_stages = 1
    option_incremental = 2
    option_incremental_with_level_gate = 3
    option_skippable = 4
    option_skippable_with_level_gate = 5
    default = 3


class SecretPuzzleBehindRegular(Choice):
    """Determines the relationship between regular puzzles and secret puzzles when both are included.
    Think of it as deciding on either 12 levels containing 10 puzzles or 6 levels containing 20 puzzles.
    Separate treats each regular and secret level as independent regions.
    Passive still keeps them separate but tells Archipelago that the regular puzzles are logically required first. Doing secret puzzles before their respective regular counterparts is considered out of logic.
    Strict makes each secret level require clearing their respective regular level.
    Followup halves the number of unlocks in the item pool, and clearing in the regular level automatically unlocks their secret counterpart.
    Followup can generate a lot of filler items.
    NOTE: Secret Puzzles are not integrated yet."""
    option_separate = 0
    option_passive = 1
    option_strict = 2
    option_followup = 3
    default = 1


@dataclass
class TetrisAttackOptions(PerGameCommonOptions):
    starter_pack: StarterPack
    stage_clear_goal: StageClearGoal
    puzzle_goal: PuzzleGoal
    stage_clear_inclusion: StageClearInclusion
    puzzle_inclusion: PuzzleInclusion
    # autohints: AutoHints
    death_link: DeathLink
    stage_clear_mode: StageClearMode
    stage_clear_saves: StageClearSaves
    special_stage_trap_count: SpecialStageTraps
    stage_clear_filler: StageClearFiller
    puzzle_filler: PuzzleFiller
    special_stage_hp_multiplier: SpecialStageHPMultiplier
    last_stage_hp_multiplier: LastStageHPMultiplier
    puzzle_mode: PuzzleMode
    # secret_puzzle_behind_regular: SecretPuzzleBehindRegular
