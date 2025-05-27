
DATA16_A2_PuzzleUnlockOffsets:
    dw SRAM_PuzzleLevel1Unlocks
    dw SRAM_PuzzleLevel2Unlocks
    dw SRAM_PuzzleLevel3Unlocks
    dw SRAM_PuzzleLevel4Unlocks
    dw SRAM_PuzzleLevel5Unlocks
    dw SRAM_PuzzleLevel6Unlocks
DATA16_A2_PuzzleSecretUnlockOffsets:
    dw SRAM_PuzzleSecretLevel1Unlocks
    dw SRAM_PuzzleSecretLevel2Unlocks
    dw SRAM_PuzzleSecretLevel3Unlocks
    dw SRAM_PuzzleSecretLevel4Unlocks
    dw SRAM_PuzzleSecretLevel5Unlocks
    dw SRAM_PuzzleSecretLevel6Unlocks
DATA16_A2_PuzzleLevelClearOffsets:
    dw SRAM_PuzzleLevel1Clears
    dw SRAM_PuzzleLevel2Clears
    dw SRAM_PuzzleLevel3Clears
    dw SRAM_PuzzleLevel4Clears
    dw SRAM_PuzzleLevel5Clears
    dw SRAM_PuzzleLevel6Clears
DATA16_A2_PuzzleSecretLevelClearOffsets:
    dw SRAM_PuzzleSecretLevel1Clears
    dw SRAM_PuzzleSecretLevel2Clears
    dw SRAM_PuzzleSecretLevel3Clears
    dw SRAM_PuzzleSecretLevel4Clears
    dw SRAM_PuzzleSecretLevel5Clears
    dw SRAM_PuzzleSecretLevel6Clears

CODE_OnPuzzleWin:
    PHP
    print "Puzzle clear logic at ",pc
    REP #$30
    JSL.L CODE_SRAMValidation
    LDA.W #$0000
    STA.L WRAM_PuzzleFanfareIsRoundClear
    LDA.W WRAM7E_CharacterIndex1
    ASL A
    TAX
    LDA.W WRAM7E_PuzzleSecretFlag
    BEQ .NonSecret
        LDA.L DATA16_A2_PuzzleSecretLevelClearOffsets,X
        BRA .UseIndex
    .NonSecret:
        LDA.L DATA16_A2_PuzzleLevelClearOffsets,X
    .UseIndex:
    PHA
    SEC
    ADC.W WRAM7E_PuzzleStageIndex
    TAX
    SEP #$20
    LDA.B #$7F
    STA.L $700000,X
    STA.L $700101,X
    print "Round clear check at ",pc
    PLX
    LDA.L $700000,X
    BIT.B #$40
    BNE .RoundAlreadyCleared
        LDA.L $700001,X
        BIT.B #$40
        BEQ .NotCleared
        LDA.L $700002,X
        BIT.B #$40
        BEQ .NotCleared
        LDA.L $700003,X
        BIT.B #$40
        BEQ .NotCleared
        LDA.L $700004,X
        BIT.B #$40
        BEQ .NotCleared
        LDA.L $700005,X
        BIT.B #$40
        BEQ .NotCleared
        LDA.L $700006,X
        BIT.B #$40
        BEQ .NotCleared
        LDA.L $700007,X
        BIT.B #$40
        BEQ .NotCleared
        LDA.L $700008,X
        BIT.B #$40
        BEQ .NotCleared
        LDA.L $700009,X
        BIT.B #$40
        BEQ .NotCleared
        LDA.L $70000A,X
        BIT.B #$40
        BEQ .NotCleared
        LDA.B #$7F
        STA.L $700000,X
        STA.L $700101,X
        LDA.B #$01
        BRA .EndRoundClearFlagging
    .RoundAlreadyCleared:
        LDA.W WRAM7E_PuzzleStageIndex
        CMP.B #$09
        BNE .NotCleared
            LDA.B #$01
            BRA .EndRoundClearFlagging
    .NotCleared:
        LDA.B #$00
    .EndRoundClearFlagging:
    STA.L WRAM_PuzzleFanfareIsRoundClear
    BEQ .NoFadeOut
        LDA.B #$E1
        STA.W WRAM87_NewMusicEvent
    .NoFadeOut:
    REP #$30
    JSL.L CODE_SRAMSave
    PLP
    RTL

CODE_PuzzleCustomRoundClearCheck:
    LDA.L WRAM_PuzzleFanfareIsRoundClear
    BEQ .End
        LDA.W #$0004
        STA.W $199C
        JSL.L CODE_8091B2
    .End:
    RTL

CODE_PuzzleFanfare:
    print "Puzzle fanfare at ",pc
    LDA.L WRAM_PuzzleFanfareIsRoundClear
    STA.W WRAM7E_RoundClearIndicator
    BEQ .End
        LDA.W #$00FA ; Bravo II sound
        STA.W WRAM7E_NewSoundEvent
    .End:
    LDA.W #$000A
    STA.W WRAM7E_GameSubstate
    RTL

CODE_PuzzleCustomCreditsCheck:
    LDA.L WRAM_PuzzleFanfareIsRoundClear
    BEQ .End
    LDA.W WRAM7E_CharacterIndex1
    CMP.W #$0005
    BNE .End
    LDA.L DATA8_GoalPuzzle
    BIT.W #%100
    BNE .RollCredits
    LDA.W WRAM7E_PuzzleSecretFlag
    BNE .SecretCreditsCheck
        LDA.L DATA8_GoalPuzzle
        BIT.W #%001
        BNE .RollCredits
        BRA .End
    .SecretCreditsCheck:
        LDA.L DATA8_GoalPuzzle
        BIT.W #%010
        BEQ .End
    .RollCredits:
        LDA.W #$0001
        STA.L $7E6395
        JSL.L CODE_86D7D8
        LDA.W #$0015
        STA.W WRAM7E_GameSubstate
        STZ.B WRAM7E_GameFrames
        STZ.B WRAM7E_GameSeconds
    .End:
    RTL

CODE_OnPuzzleFail:
    ; TODO_AFTER: If rising stacks are possible, add special death message check
    LDA.W #$0004
    STA.L SNI_DeathlinkTrigger
    LDA.W #$0001
    STA.L $7E943C
    INC.W WRAM7E_GameSubstate
    RTL

CODE_PuzzleResultSummonNextStage:
    LDA.W WRAM7E_RoundClearIndicator
    BNE .EndRound
    INC.W WRAM7E_PuzzleStageIndex
    JSR.W CODE_SkipIfClearedOrLockedPuzzle
    JSR.W CODE_SkipIfClearedOrLockedPuzzle
    JSR.W CODE_SkipIfClearedOrLockedPuzzle
    JSR.W CODE_SkipIfClearedOrLockedPuzzle
    JSR.W CODE_SkipIfClearedOrLockedPuzzle
    JSR.W CODE_SkipIfClearedOrLockedPuzzle
    JSR.W CODE_SkipIfClearedOrLockedPuzzle
    JSR.W CODE_SkipIfClearedOrLockedPuzzle
    JSR.W CODE_SkipIfClearedOrLockedPuzzle
    LDA.W WRAM7E_PuzzleStageIndex
    CMP.W #$000A
    BCC .AdvanceToNextStage
    .EndRound:
        LDA.W #$0001
        BRA .SetEndModeIndicator
    .AdvanceToNextStage:
        LDA.W #$0000
    .SetEndModeIndicator:
    STA.L WRAM_EndModeIndicator
    INC.W WRAM7E_GameSubstate
    RTL


CODE_SkipIfClearedOrLockedPuzzle:
    print "Cleared puzzle check code at ",pc
    LDA.W WRAM7E_CharacterIndex1
    ASL A
    TAX
    LDA.W WRAM7E_PuzzleSecretFlag
    BEQ .NonSecret
        LDA.L DATA16_A2_PuzzleSecretLevelClearOffsets,X
        BRA .UseIndex
    .NonSecret:
        LDA.L DATA16_A2_PuzzleLevelClearOffsets,X
    .UseIndex:
    TAX
    LDA.L $700000,X
    BIT.W #$0040
    BNE .RoundAlreadyCleared
        TXA
        SEC
        ADC.W WRAM7E_PuzzleStageIndex
        TAX
        LDA.L $700000,X
        BIT.W #$0040
        BEQ .StageIsNotCleared
        INC.W WRAM7E_PuzzleStageIndex
        RTS
    .RoundAlreadyCleared:
        RTS
    .StageIsNotCleared:
CODE_SkipIfLockedPuzzle:
    print "Skip puzzle code at ",pc
    LDA.W WRAM7E_CharacterIndex1
    ASL A
    TAX
    LDA.W WRAM7E_PuzzleSecretFlag
    BEQ .NonSecret
        LDA.L DATA16_A2_PuzzleSecretUnlockOffsets,X
        BRA .UseIndex
    .NonSecret:
        LDA.L DATA16_A2_PuzzleUnlockOffsets,X
    .UseIndex:
    SEC
    ADC.W WRAM7E_PuzzleStageIndex
    TAX
    LDA.L $700000,X
    AND.W #$00FF
    BNE .StageIsUnlocked
        INC.W WRAM7E_PuzzleStageIndex
    .StageIsUnlocked:
    RTS

CODE_SetNewPuzzleIndex:
    print "Set new puzzle index code at ",pc
    LDA.W WRAM7E_CharacterIndex1
    ASL A
    ASL A
    CLC
    ADC.W WRAM7E_CharacterIndex1
    ASL A
    SEC
    ADC.W WRAM7E_PuzzleStageIndex
    STA.W WRAM7E_PuzzleIndex ; levelIndex*10 + stageIndex + 1
    ; TODO_AFTER: Use a table in bank A0 to remap puzzleIndex to something else
    LDX.W WRAM7E_PuzzleSecretFlag
    CPX.W #$0000
    BEQ .AddSecretSauce
        CLC
        ADC.W #$003C
    .AddSecretSauce:
    DEC A
    TAX
    LDA.L DATA8_PuzzleMoveCounts,X
    AND.W #$00FF
    INC A
    STA.L WRAM_AssignedMoveCount
    LDA.W #$0000
    STA.L $7E638B
    STA.L $7E638F
    RTL
