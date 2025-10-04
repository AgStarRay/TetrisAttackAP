CODE_OnVsTopOut:
    STA.L $7E6517
    LDA.W WRAM7E_ToppedOut
    BNE .PlayerToppedOut
        LDA.W WRAM7E_OpponentToppedOut
        BEQ .SkipClear
            JSL.L CODE_SRAMValidation
            LDA.L WRAM_VsStageNumber
            TAX
            SEP #$20
            LDA.L WRAM7E_VsDifficulty
            TAY
            LDA.B #$7F
          - CPY.W #$0003
            BEQ +
                LSR A
                INY
                BRA -
          + STA.L SRAM_VersusStageClears,X
            STA.L SRAM_VersusStageClears+$101,X
            STA.L WRAM_VsCompletedAStage
            LDX.W #$07
            .AllSavedLoop:
                LDA.L SRAM_VersusStageClears,X
                AND.B #%01111000
                BEQ .StillSomeoneToSave
                DEX
                BPL .AllSavedLoop
                    LDA.B #$01
                    STA.L SRAM_VersusAllFriendsNormal 
            .StillSomeoneToSave:
            REP #$20
            JSL.L CODE_SRAMSave
        .SkipClear:
        RTL
    .PlayerToppedOut:
        LDA.W WRAM7E_OpponentToppedOut
        BNE .OpponentAlsoToppedOut
            LDA.L WRAM_VsStageNumber
            CLC
            ADC.W #$0010
            STA.L SNI_DeathlinkTrigger
            RTL
        .OpponentAlsoToppedOut:
            LDA.L WRAM_VsStageNumber
            CLC
            ADC.W #$0020
            STA.L SNI_DeathlinkTrigger
            RTL

CODE_CustomVsSubstate2:
    JSL.L CODE_FL_8B93B4
    LDA.W #$0003
    STA.L $0000B1
    LDA.L WRAM_VsProcedureFlags
    AND.W #$FBFF
    STA.L WRAM_VsProcedureFlags
    BIT.W #$4000
    BEQ .DecideNextState
    LDA.L $001A82
    BNE .DecideNextState
        ; This code is required to have the victory cutscene play properly
        LDA.L WRAM_VsStageNumber
        CMP.W #$0000
        BMI .LessThan0
        CMP.W #$000C
        BMI .LessThan12
        .LessThan0:
            TDC
            BRA .SetStageNumber
        .LessThan12:
            INC A
        .SetStageNumber:
        STA.L WRAM_VsStageNumber
        BRA .GoToOverworld
    .DecideNextState:
    LDA.L WRAM80_Pad1State
    AND.W #$FFF0
    CMP.W #$4040
    BEQ .GoToOverworld
    LDA.L $001A82
    BNE .GoToOverworld
    LDA.L WRAM_VsStageNumber
    TAX
    LDA.L DATA8_GoToCharacterSelect,X
    AND.W #$00FF
    BNE .GoToOverworld
        LDA.W #$0006
        STA.W WRAM_VsMenuSubstate
        RTL
    .GoToOverworld:
        JSL.L CODE_FL_8B81DD
        JSL.L CODE_FL_8B8531
        JSL.L CODE_FL_8B87B8
        JSL.L CODE_FL_8B8901
        JSL.L CODE_FL_8B8B7C
        LDA.W #$FFFA
        STA.L $7ED272
        JSL.L CODE_FL_8B92C2
        TDC
        STA.L $001A82
        INC.W WRAM_VsMenuSubstate
        RTL

CODE_CustomVsSubstate5:
    JSL.L CODE_ScanIncomingArchipelagoItems
    JSL.L CODE_FL_8B92C2
    RTL

CODE_CustomVsSubstate5End:
    LDA.W WRAM_VsCompletedAStage
    BEQ .JustStarted
    JSL.L CODE_VsStageIsCleared
    BCS .QuitOut
    .JustStarted:
    JSL.L CODE_VsStageIsAvailable
    BPL .StageIsAvailable
    .QuitOut:
        LDA.W #$0001
        STA.L WRAM7E_GameState
        LDA.W #$0005
        STA.L WRAM7E_GameSubstate
        RTL
    .StageIsAvailable:
    LDA.L $7ED32D
    BNE .AltExit
        LDA.L WRAM_VsProcedureFlags
        AND.W #$9FFF
        STA.L WRAM_VsProcedureFlags
        LDA.W #$0007
        STA.L WRAM7E_GameState
        RTL
    .AltExit:
        JSL.L CODE_FL_83BDCD
        RTL

CODE_VsAllowNextStageOverworld:
    LDA.L $7ED39F
    TAX
    SEP #$20
    LDA.L WRAM_VsLakituState,X
    BEQ .SkipUnlockingCharacter
        LDA.B #$02
        STA.L WRAM_VsLakituState,X
    .SkipUnlockingCharacter:
    REP #$20
    JSL.L CODE_VsStageIsAvailable
    BPL .StageIsAvailable
        LDA.W #$0001
        STA.L $7ED329
    .StageIsAvailable:
    JML.L CODE_JP_8BA78F

CODE_VsAllowNextStageRunning:
    REP #$20
    JSL.L CODE_VsStageIsAvailable
    BMI .GoToMainMenu
    JSL.L CODE_VsStageIsCleared
    BCC .Proceed
    .GoToMainMenu:
        LDA.W #$0001
        STA.L $7ED329
        RTL
    .Proceed:
        LDA.W #$0006
        STA.W $198C
        RTL

CODE_VsCustomAdvance:
    LDA.L DATA8_VsCustomLastStages,X
    AND.W #$00FF
    CMP.L WRAM_VsStageNumber
    BEQ .End
        LDA.W $0394
        INC A
        STA.L WRAM_VsStageNumber
    .End:
    JML.L CODE_87F208

CODE_CustomVsSubstate6:
    LDA.L WRAM_VsProcedureFlags
    BIT.W #$0800
    BEQ .NoCredits
        PHP
        REP #$30
        JSL.L CODE_VsTriggerCredits
        PLP
        RTL
    .NoCredits:
    LDA.W WRAM_VsCompletedAStage
    BEQ .JustStarted
    JSL.L CODE_VsStageIsCleared
    BCS .QuitOut
    .JustStarted:
    JSL.L CODE_VsStageIsAvailable
    BPL .StageIsAvailable
    .QuitOut:
        LDA.W #$0001
        STA.L WRAM7E_GameState
        LDA.W #$0005
        STA.L WRAM7E_GameSubstate
        RTL
    .StageIsAvailable:
    LDA.B WRAM7E_Pad1State
    AND.W #$FFF0
    CMP.W #$4040
    BNE .Proceed
        LDA.L WRAM_VsProcedureFlags
        AND.W #$9FFF
        STA.L WRAM_VsProcedureFlags
        LDA.W #$0007
        STA.L WRAM7E_GameState
        RTL
    .Proceed:
        LDA.L WRAM_VsCharacterIndex
        TAX
        LDA.L DATA8_PlayerCharacters,X
        AND.W #$00FF
        STA.L WRAM7E_CharacterIndex1
        LDA.L WRAM_VsStageNumber
        TAX
        LDA.L DATA8_OpponentCharacters,X
        AND.W #$00FF
        STA.L WRAM7E_CharacterIndex2
        LDA.W #$0003
        STA.L WRAM7E_GameState
        LDA.W #$0001
        STA.L WRAM7E_PlayersIndicator
        TDC
        STA.L WRAM_ModeIndex
        STA.L WRAM7E_GameSubstate
        LDA.W #$0005
        STA.L $0002AC
        STA.L $0002AE
        RTL

CODE_VsStageIsAvailable:
    LDA.L WRAM_VsStageNumber
    TAX
    CPX.W #$0008
    BCC .NotInCave
        LDA.L SRAM_VersusMtWickednessGate
        AND.W #$00FF
        BNE .HasGate
        .MtWickednessLocked:
            LDA.W #$FFFF
            RTL
        .HasGate:
    .NotInCave:
    LDA.L DATA8_VsMinimumDifficulties,X
    AND.W #$00FF
    CMP.W WRAM7E_VsDifficulty
    BCC .MeetsMinimumDifficulty
    BEQ .MeetsMinimumDifficulty
        LDA.W #$FFFF
        RTL
    .MeetsMinimumDifficulty:
    LDA.L DATA8_VersusFlags
    BIT.W #%010
    BNE .MultipleUnlocks
        LDA.L SRAM_VersusStageUnlocks,X
        AND.W #$00FF
        DEC A
        RTL
    .MultipleUnlocks:
        LDA.L SRAM_VersusStageUnlocks,X
        AND.W #$00FF
        DEC A
        CMP.L WRAM7E_VsDifficulty
        RTL

CODE_VsStageIsCleared:
    LDA.L WRAM_VsStageNumber
    TAX
    LDA.L WRAM7E_VsDifficulty
    TAY
    LDA.W #$007F
    CPY #$0003
    BEQ .DoneShifting
    .KeepShifting:
        LSR A
        INY
        CPY #$0003
        BNE .KeepShifting
    .DoneShifting:
    STA.B $00
    LDA.L SRAM_VersusStageClears,X
    AND.W #$00FF
    CMP.B $00
    RTL

CODE_UpdateVsCharacterStates:
    PHP
    SEP #$20
    LDA.L SRAM_VersusCharacterUnlocks
    ASL A
    STA.L WRAM_VsLakituState
    LDA.L SRAM_VersusCharacterUnlocks+1
    ASL A
    STA.L WRAM_VsBumptyState
    LDA.L SRAM_VersusCharacterUnlocks+2
    ASL A
    STA.L WRAM_VsPoochyState
    LDA.L SRAM_VersusCharacterUnlocks+3
    ASL A
    STA.L WRAM_VsWigglerState
    LDA.L SRAM_VersusCharacterUnlocks+4
    ASL A
    STA.L WRAM_VsFroggyState
    LDA.L SRAM_VersusCharacterUnlocks+5
    ASL A
    STA.L WRAM_VsBlarggState
    LDA.L SRAM_VersusCharacterUnlocks+6
    ASL A
    STA.L WRAM_VsLungeFishState
    LDA.L SRAM_VersusCharacterUnlocks+7
    ASL A
    STA.L WRAM_VsRaphaelState
    PLP
    RTL

CODE_ConditionalImFreeMsg:
    LDA.L $7ED39F
    TAX
    SEP #$20
    LDA.L WRAM_VsLakituState,X
    BEQ .SkipUnlockingCharacter
        LDA.B #$03
        STA.L WRAM_VsLakituState,X
        REP #$20
        JML.L CODE_JP_8BA77F
    .SkipUnlockingCharacter:
    REP #$20
    RTL