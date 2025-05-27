from worlds.tetrisattack import PuzzleGoal, VersusGoal, StarterPack
from worlds.tetrisattack.test import TetrisAttackTestBase


class TestAllModes(TetrisAttackTestBase):
    options = {
        "stage_clear_goal": True,
        "puzzle_goal": PuzzleGoal.option_puzzle_and_extra_puzzle,
        "versus_goal": VersusGoal.option_very_hard,
        "starter_pack": StarterPack.option_puzzle_level_1
    }
