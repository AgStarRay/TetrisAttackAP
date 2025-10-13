
DATA16_A2_StageClearUnlockOffsets:
    dw SRAM_StageClearRound1Unlocks
    dw SRAM_StageClearRound2Unlocks
    dw SRAM_StageClearRound3Unlocks
    dw SRAM_StageClearRound4Unlocks
    dw SRAM_StageClearRound5Unlocks
    dw SRAM_StageClearRound6Unlocks
DATA16_A2_StageClearRoundClearOffsets:
    dw SRAM_StageClearRound1Clears
    dw SRAM_StageClearRound2Clears
    dw SRAM_StageClearRound3Clears
    dw SRAM_StageClearRound4Clears
    dw SRAM_StageClearRound5Clears
    dw SRAM_StageClearRound6Clears

CODE_LoadCustomScore:
    LDA.L SRAM_StageClearScore_Lo
    STA.W WRAM87_Score_Lo
    LDA.L SRAM_StageClearScore_Hi
    STA.W WRAM87_Score_Hi
    JML.L CODE_87D4AF

CODE_OnStageClearWin:
    PHP
    JSL.L CODE_SRAMValidation
    SEP #$20
    LDA.W WRAM7E_StageClearSpecialIndex
    BEQ .RegularStageClear
        CMP.B #$02
        BNE .SpecialStageClear
        .LastStageClear:
            LDA.B #$7F
            STA.L SRAM_StageClearLastStageClear
            STA.L SRAM_StageClearLastStageClear+$101
            BRL .SaveProgress
        .SpecialStageClear:
            LDA.L SRAM_StageClearSpecialStageCompletions
            INC A
            STA.L SRAM_StageClearSpecialStageCompletions
            LDA.B #MsgCode_SpecialStageSurvived
            STA.L SNI_MessageRequest
            BRL .SaveProgress
    .RegularStageClear:
        print "Regular stage clear logic at ",pc
        REP #$30
        LDA.W WRAM7E_StageClearRoundIndex
        DEC A
        ASL A
        TAX
        LDA.L DATA16_A2_StageClearRoundClearOffsets,X
        PHA
        CLC
        ADC.W WRAM7E_StageClearStageIndex
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
            LDA.B #$7F
            STA.L $700000,X
            STA.L $700101,X
            JSR.W SUB_LastStageUnlock
            LDA.B #$01
            BRA .EndRoundClearFlagging
        .RoundAlreadyCleared:
            LDA.W WRAM7E_StageClearStageIndex
            CMP.B #$05
            BNE .NotCleared
                LDA.B #$01
                BRA .EndRoundClearFlagging
        .NotCleared:
            LDA.B #$00
        .EndRoundClearFlagging:
        STA.W WRAM7E_RoundClearIndicator
        PHA
        CLC
        ADC.B #MsgCode_SCStageClear
        STA.L SNI_MessageRequest
        PLA
        BEQ .NoBravoSound
            REP #$30
            LDA.W #$00FA ; Bravo II sound
            STA.W WRAM7E_NewSoundEvent
        .NoBravoSound:
    .SaveProgress:
    REP #$30
    LDA.W WRAM7E_Score_Lo
    STA.L SRAM_StageClearScore_Lo
    LDA.W WRAM7E_Score_Hi
    STA.L SRAM_StageClearScore_Hi
    JSL.L CODE_SRAMSave
    LDA.W #$000A
    STA.W WRAM7E_GameSubstate
    PLP
    RTL
SUB_LastStageUnlock:
    LDA.L DATA8_StageClearFlags
    BIT.B #$10
    BEQ .NoAutoUnlock
    LDA.W WRAM7E_StageClearRoundIndex
    CMP.B #$06
    BNE .NotStage6
        LDA.B #$01
        STA.L SRAM_StageClearLastStageUnlock
    .NotStage6:
    .NoAutoUnlock:
    RTS

CODE_OnStageClearTopOut:
    LDA.W #MsgCode_Deathlink
    STA.L SNI_MessageRequest
    LDA.W WRAM7E_StageClearSpecialIndex
    INC A
    STA.L SNI_DeathlinkTrigger
    LDA.W WRAM7E_StageClearSpecialIndex
    CMP.W #$0001
    BNE .NotSpecialStage
        LDA.L SRAM_StageClearSpecialStageCompletions
        INC A
        STA.L SRAM_StageClearSpecialStageCompletions
        JSL.L CODE_SRAMSave
    .NotSpecialStage:
    LDA.W #$0001
    STA.L $7E943A
    INC.W WRAM7E_GameSubstate
    RTL

CODE_StageClearResultSummonNextStage:
    LDA.W WRAM7E_RoundClearIndicator
    BNE .EndRound
    INC.W WRAM7E_StageClearStageIndex
    JSR.W SUB_SkipIfClearedOrLockedStage
    JSR.W SUB_SkipIfClearedOrLockedStage
    JSR.W SUB_SkipIfClearedOrLockedStage
    JSR.W SUB_SkipIfClearedOrLockedStage
    LDA.W WRAM7E_StageClearStageIndex
    CMP.W #$0006
    BCC .AdvanceToNextStage
    .EndRound:
        LDA.W #$0001
        BRA .SetEndModeIndicator
    .AdvanceToNextStage:
        SEP #$20
        LDA.L SRAM_StageClearSpecialStageCompletions
        CMP.L SRAM_StageClearReceivedSpecialStages
        REP #$20
        BCS .SkipSpecialStage
            LDA.W #$0001
            BRA .SetEndModeIndicator
        .SkipSpecialStage:
            TDC
    .SetEndModeIndicator:
    STA.L WRAM_EndModeIndicator
    INC.W WRAM7E_GameSubstate
    RTL

CODE_MenuSCPickFirstStage:
    print "Pick first stage code at ",pc
    LDA.W #$0001
    STA.W WRAM7E_StageClearStageIndex
    LDA.W WRAM7E_StageClearRoundIndex
    DEC A
    ASL A
    TAX
    LDA.L DATA16_A2_StageClearRoundClearOffsets,X
    TAX
    LDA.L $700000,X
    BIT.W #$0040
    BNE .ReplayingClearedRound
        JSR.W SUB_SkipIfClearedOrLockedStage
        JSR.W SUB_SkipIfClearedOrLockedStage
        JSR.W SUB_SkipIfClearedOrLockedStage
        JSR.W SUB_SkipIfClearedOrLockedStage
        JSR.W SUB_SkipIfLockedStage
        LDA.W WRAM7E_StageClearStageIndex
        CMP.W #$0006
        BCC .Done
            LDA.W #$0001
            STA.W WRAM7E_StageClearStageIndex
            JSR.W SUB_SkipIfLockedStage
            JSR.W SUB_SkipIfLockedStage
            JSR.W SUB_SkipIfLockedStage
            JSR.W SUB_SkipIfLockedStage
            JSR.W SUB_SkipIfLockedStage
            LDA.W WRAM7E_StageClearStageIndex
            CMP.W #$0006
            BCC .Done
                LDA.W #ErrorCode_AttemptedToStartFullyLockedRound
                STA.L WRAM_ErrorCode
                BRK
    .ReplayingClearedRound:
    .Done:
    RTL
SUB_SkipIfClearedOrLockedStage:
    print "Cleared stage check code at ",pc
    LDA.L DATA8_StageClearFlags
    BIT.W #%0100
    BEQ .StageIsNotCleared
    LDA.W WRAM7E_StageClearRoundIndex
    DEC A
    ASL A
    TAX
    LDA.L DATA16_A2_StageClearRoundClearOffsets,X
    TAX
    LDA.L $700000,X
    BIT.W #$0040
    BNE .RoundAlreadyCleared
        TXA
        CLC
        ADC.W WRAM7E_StageClearStageIndex
        TAX
        LDA.L $700000,X
        BIT.W #$0040
        BEQ .StageIsNotCleared
        INC.W WRAM7E_StageClearStageIndex
        RTS
    .RoundAlreadyCleared:
        RTS
    .StageIsNotCleared:
SUB_SkipIfLockedStage:
    print "Skip stage code at ",pc
    LDA.W WRAM7E_StageClearRoundIndex
    DEC A
    ASL A
    TAX
    LDA.L DATA16_A2_StageClearUnlockOffsets,X
    CLC
    ADC.W WRAM7E_StageClearStageIndex
    TAX
    LDA.L $700000,X
    AND.W #$00FF
    BNE .StageIsUnlocked
        LDA.L DATA8_StageClearFlags
        BIT.W #$0002
        BEQ .SkipToEnd
            INC.W WRAM7E_StageClearStageIndex
            RTS
        .SkipToEnd
            LDA.W #$0006
            STA.W WRAM7E_StageClearStageIndex
    .StageIsUnlocked:
    RTS

CODE_SCSpecialCustomWinCondition:
    LDA.W WRAM7E_StageClearSpecialIndex
    CMP.W #$0002
    BEQ .LastStage
        LDA.L WRAM_BowserDamage
        CMP.L DATA16_SCSpecialBowserHP
        BCC .End
        BRA .Victory
    .LastStage:
        LDA.L WRAM_BowserDamage
        CMP.L DATA16_SCLastBowserHP
        BCC .End
    .Victory:
        JSL.L CODE_82B574_JSR
        STZ.W WRAM82_AdvanceIngameTimer
        LDA.W #$0005
        STA.W WRAM82_GameState
        STZ.W WRAM82_GameSubstate
        STZ.B WRAM00_GameFrames
        STZ.B WRAM00_GameSeconds
        JSL.L CODE_FL_86D7D8
    .End:
    RTL

CODE_SCUpdateHPWithCustomIndex:
    REP #$30
    LDA.W WRAM7E_StageClearSpecialIndex
    CMP.W #$0002
    BEQ .LastStage
        LDA.L DATA16_SCSpecialBowserHealthBars
        STA.L WRAM_SCCurrentHealthBar
        LDA.L WRAM_BowserDamage
        STA.B $14
        CMP.L DATA16_SCSpecialBowserHP
        BCS .EmptyBar
        LDA.L DATA16_SCSpecialBowserHealthBarAmount
        STA.B $1C
        BRA .DisplayHealthBarAmount
    .LastStage:
        LDA.L DATA16_SCLastBowserHealthBars
        STA.L WRAM_SCCurrentHealthBar
        LDA.L WRAM_BowserDamage
        STA.B $14
        CMP.L DATA16_SCLastBowserHP
        BCS .EmptyBar
        LDA.L DATA16_SCLastBowserHealthBarAmount
        STA.B $1C
    .DisplayHealthBarAmount:
        LDA.B $14
        CMP.B $1C
        BCC .CalculateBowserHPIndex
            SEC
            SBC.B $1C
            STA.B $14
            LDA.L WRAM_SCCurrentHealthBar
            DEC A
            STA.L WRAM_SCCurrentHealthBar
            BPL .DisplayHealthBarAmount
    .EmptyBar:
        TDC
        STA.L WRAM_SCCurrentHealthBar
        LDA.W #$1A00
        STA.L $7E2244
        STA.L $7E2246
        STA.L $7E2248
        STA.L $7E224A
        STA.L $7E224C
        STA.L $7E224E
        STA.L $7E2250
        RTL
    .CalculateBowserHPIndex:
    LDA.L WRAM_SCCurrentHealthBar
    CMP.L WRAM_SCPreviousHealthBar
    BEQ .SkipHPColorUpdate
        ASL A
        TAX
        LDA.L DATA16_SCHPBarColors,X
        STA.L $7E86F6+$DE
        LDA.L DATA16_SCHPBarColors+2,X
        STA.L $7E86F6+$D2
        PHB
        PHK
        PLB
        LDY.W #DATA_HPBarColorsCGRAMDMA
        JSL.L CODE_CreateCGRAMDMA
        PLB
        LDA.L WRAM_SCCurrentHealthBar
    .SkipHPColorUpdate:
    STA.L WRAM_SCPreviousHealthBar
    LDA.W #$0038
    STA.B $16
    JSL.L CODE_WordMultiplication
    LDA.B $18
    STA.B $1A
    JSL.L CODE_WordDivision
    LDA.B $1A
    STA.L WRAM_BowserHPIndex
    JML.L CODE_FL_85AFE6

CODE_SCBowserCustomColor:
    LDA.W WRAM7E_StageClearSpecialIndex
    CMP.W #$0002
    BEQ .LastStage
        LDA.L DATA16_SCSpecialBowserHP
        CMP.L WRAM_BowserDamage
        BCC .FullRed
        SEC
        SBC.L WRAM_BowserDamage
        CMP.L DATA16_SCSpecialBowserHPStage1
        BCS .NotRed
        CMP.L DATA16_SCSpecialBowserHPStage2
        BCS .SomewhatRed
        CMP.L DATA16_SCSpecialBowserHPStage3
        BCS .MostlyRed
        BRA .BlinkingRed
    .LastStage:
        LDA.L DATA16_SCLastBowserHP
        CMP.L WRAM_BowserDamage
        BCC .FullRed
        SEC
        SBC.L WRAM_BowserDamage
        CMP.L DATA16_SCLastBowserHPStage1
        BCS .NotRed
        CMP.L DATA16_SCLastBowserHPStage2
        BCS .SomewhatRed
        CMP.L DATA16_SCLastBowserHPStage3
        BCS .MostlyRed
    .BlinkingRed:
        LDA.L $7E5311
        DEC A
        BNE .SkipBlinkTimerReset
            LDA.L $7E5313
            EOR.W #$0001
            STA.L $7E5313
            LDA.W #$0008
        .SkipBlinkTimerReset:
        STA.L $7E5311
        LDA.L $7E5313
        BNE .MostlyRed
    .FullRed:
        LDA.W #$0003
        JML.L CODE_829C29
    .NotRed:
        TDC
        JML.L CODE_829C29
    .SomewhatRed:
        LDA.W #$0001
        JML.L CODE_829C29
    .MostlyRed:
        LDA.W #$0002
        JML.L CODE_829C29

CODE_SCStartSpecialStage:
    ;TODO: Add an option for the maximum amount Bowser can heal and save the current value to SRAM
    TDC
    STA.L WRAM_BowserDamage
    RTL

CODE_SCBowserFillHP:
    PHB
    PHK
    PLB
    LDY.W #DATA_HPBarColorsCGRAMDMA
    JSL.L CODE_CreateCGRAMDMA
    PLB
    LDA.L WRAM_SCCurrentHealthBar
    ASL A
    TAX
    LDA.L DATA16_SCHPBarColors,X
    STA.L $7E86F6+$DE
    LDA.L DATA16_SCHPBarColors+2,X
    STA.L $7E86F6+$D2
    LDA.W WRAM7E_StageClearSpecialIndex
    CMP.W #$0002
    BEQ .LastStage
        LDA.L DATA16_SCSpecialBowserHealthBars
        TAX
        LDA.L WRAM_BowserHPIndex
        BEQ .NextSubstate
            CLC
            SBC.L DATA16_SCSpecialBowserHealthBars
            BPL .HPNotMaxed
            BRA .BarIsMaxed
    .LastStage:
        LDA.L DATA16_SCLastBowserHealthBars
        TAX
        LDA.L WRAM_BowserHPIndex
        BEQ .NextSubstate
            CLC
            SBC.L DATA16_SCLastBowserHealthBars
            BPL .HPNotMaxed
    .BarIsMaxed:
        CLC
        ADC #$0038
        STA.L WRAM_BowserHPIndex
        LDA.L WRAM_SCCurrentHealthBar
        INC A
        STA.L WRAM_SCCurrentHealthBar
        TXA
        CMP.L WRAM_SCCurrentHealthBar
        BCC .HPIsMaxed
        JML.L CODE_87A7FF
    .HPIsMaxed:
        STA.L WRAM_SCCurrentHealthBar
        TDC
    .HPNotMaxed:
        STA.L WRAM_BowserHPIndex
        JML.L CODE_87A7FF
    .NextSubstate:
        STZ.B WRAM00_GameFrames
        INC.W WRAM87_GameSubstate
        JML.L CODE_87A7FF

DATA_HPBarColorsCGRAMDMA:
    dl $7E87C8
    dw $000E
    db $69

CODE_SCInflictDamageCapped:
    LDA.L $7E5307
    CMP.W #$01F4
    BCC .AddDamage
        LDA.W #$01F4
    .AddDamage:
    CLC
    ADC.L WRAM_BowserDamage
    STA.L WRAM_BowserDamage
    LDA.W #$0001
    STA.L $7E904E
    RTL
