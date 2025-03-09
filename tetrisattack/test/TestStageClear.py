from worlds.tetrisattack.Options import StarterPack, StageClearMode
from worlds.tetrisattack.test import TetrisAttackTestBase


class TestStageClearRound2Start(TetrisAttackTestBase):
    options = {
        "starter_pack": StarterPack.option_stage_clear_round_2,
        "stage_clear_filler": 0
    }


class TestStageClearRound6Start(TetrisAttackTestBase):
    options = {
        "starter_pack": StarterPack.option_stage_clear_round_6,
        "stage_clear_filler": 0
    }


class TestStageClearWholeRounds(TetrisAttackTestBase):
    options = {
        "stage_clear_mode": StageClearMode.option_whole_rounds,
        "stage_clear_filler": 0
    }


class TestStageClearIndividualStages(TetrisAttackTestBase):
    options = {
        "stage_clear_mode": StageClearMode.option_individual_stages,
        "stage_clear_filler": 0
    }


class TestStageClearSkippableStages(TetrisAttackTestBase):
    options = {
        "stage_clear_mode": StageClearMode.option_skippable,
        "stage_clear_filler": 0
    }

class TestStageClearSkippableStagesWithRoundGates(TetrisAttackTestBase):
    options = {
        "stage_clear_mode": StageClearMode.option_skippable_with_round_gate,
        "stage_clear_filler": 0
    }
