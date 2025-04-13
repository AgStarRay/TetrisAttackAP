from worlds.tetrisattack.Options import StarterPack, PuzzleMode, PuzzleGoal
from worlds.tetrisattack.test import TetrisAttackTestBase


class TestPuzzleFalseStageClearStart(TetrisAttackTestBase):
    options = {
        "stage_clear_goal": False,
        "puzzle_goal": PuzzleGoal.option_puzzle,
        "starter_pack": StarterPack.option_stage_clear_round_1,
        "puzzle_filler": 0
    }

    def test_incremental_unlocks(self) -> None:
        locations = ["Puzzle 3-10 Clear"]
        items = [["Puzzle Level 3 Gate",
                  "Puzzle Progressive Level 3 Unlock",
                  "Puzzle Progressive Level 3 Unlock",
                  "Puzzle Progressive Level 3 Unlock",
                  "Puzzle Progressive Level 3 Unlock",
                  "Puzzle Progressive Level 3 Unlock",
                  "Puzzle Progressive Level 3 Unlock",
                  "Puzzle Progressive Level 3 Unlock",
                  "Puzzle Progressive Level 3 Unlock",
                  "Puzzle Progressive Level 3 Unlock"]]
        self.assertAccessDependency(locations, items, only_check_listed=True)


class TestPuzzleWholeLevels(TetrisAttackTestBase):
    options = {
        "stage_clear_goal": False,
        "puzzle_goal": PuzzleGoal.option_puzzle,
        "puzzle_mode": PuzzleMode.option_whole_levels,
        "starter_pack": StarterPack.option_puzzle_level_1,
        "puzzle_filler": 0
    }


class TestPuzzleAndSecretPuzzleIndividualStages(TetrisAttackTestBase):
    options = {
        "stage_clear_goal": False,
        "puzzle_goal": PuzzleGoal.option_puzzle_and_secret_puzzle,
        "puzzle_mode": PuzzleMode.option_individual_stages,
        "starter_pack": StarterPack.option_puzzle_level_2,
        "puzzle_filler": 0
    }


class TestPuzzleSkippableStages(TetrisAttackTestBase):
    options = {
        "stage_clear_goal": False,
        "puzzle_goal": PuzzleGoal.option_puzzle,
        "puzzle_mode": PuzzleMode.option_skippable,
        "starter_pack": StarterPack.option_puzzle_level_3,
        "puzzle_filler": 0
    }


class TestPuzzleSkippableStagesWithLevelGates(TetrisAttackTestBase):
    options = {
        "stage_clear_goal": False,
        "puzzle_goal": PuzzleGoal.option_puzzle,
        "puzzle_mode": PuzzleMode.option_skippable_with_level_gate,
        "starter_pack": StarterPack.option_puzzle_level_4,
        "puzzle_filler": 0
    }


class TestSecretPuzzle(TetrisAttackTestBase):
    options = {
        "stage_clear_goal": False,
        "puzzle_goal": PuzzleGoal.option_secret_puzzle,
        "starter_pack": StarterPack.option_stage_clear_round_1,
        "puzzle_filler": 0
    }

    def test_secret_start(self) -> None:
        self.assertTrue(self.count("Secret Puzzle Level 1 Gate") > 0,
                        "Starter Pack did not give access to Secret Puzzle level")


class TestPuzzleAndSecretPuzzle(TetrisAttackTestBase):
    options = {
        "stage_clear_goal": False,
        "puzzle_goal": PuzzleGoal.option_puzzle_and_secret_puzzle,
        "starter_pack": StarterPack.option_puzzle_level_1,
        "puzzle_filler": 0
    }


class TestPuzzleOrSecretPuzzle(TetrisAttackTestBase):
    options = {
        "stage_clear_goal": False,
        "puzzle_goal": PuzzleGoal.option_puzzle_or_secret_puzzle,
        "starter_pack": StarterPack.option_puzzle_level_1,
        "puzzle_filler": 0
    }


class TestPuzzleMaxFiller(TetrisAttackTestBase):
    options = {
        "stage_clear_goal": False,
        "puzzle_goal": PuzzleGoal.option_puzzle,
        "starter_pack": StarterPack.option_puzzle_level_5,
        "puzzle_mode": PuzzleMode.option_whole_levels,
        "puzzle_filler": 1
    }
