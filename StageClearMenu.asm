
DATA16_A1_StageClearUnlockOffsets:
    dw SRAM_StageClearRound1Unlocks
    dw SRAM_StageClearRound2Unlocks
    dw SRAM_StageClearRound3Unlocks
    dw SRAM_StageClearRound4Unlocks
    dw SRAM_StageClearRound5Unlocks
    dw SRAM_StageClearRound6Unlocks

CODE_ArchipelagoStageClearMenu:
    print "New stage clear submenu state 8 procedure 0 at ",pc
    ;TODO: AP and lock sprites are not loaded when returning from a stage
    JSL.L CODE_SRAMValidation
    JSL.L CODE_ScanIncomingArchipelagoItems
    JSR.W SUB_SetLocalRoundClears
    SEP #$20
    LDA.L SRAM_StageClearSpecialStageCompletions
    CMP.L SRAM_StageClearReceivedSpecialStages
    REP #$20
    BCS .SkipSpecialStage
        JSR.W SUB_TriggerSpecialStage
        JML.L CODE_JP_83E754
    .SkipSpecialStage:
    STZ.W WRAM_StageClearStageIndex
    LDY.W WRAM_OAMAppendAddr
    ;DEY
    ;DEY
    ;DEY
    ;DEY
    LDX.W #$0000
    .MenuSCCustomGraphicsLoop:
        CPX.W #$0024
        BCS .MenuSCCustomGraphics_End
        LDA.L SRAM_StageClearRound1Unlocks,X
        AND.W #$00FF
        BNE .SkipLockSprite
            JSR.W SUB_MenuSCCalculateSpritePos
            STA.W WRAM_OAMBuffer,Y
            INY
            INY
            LDA.L WRAM_LockSpriteValues,X
            AND.W #$00FF
            BEQ .UseNormalLockSprite
                LDA.W #GFX_LockSpriteHighlighted
                BRA .StoreLockSprite
            .UseNormalLockSprite:
                LDA.W #GFX_LockSprite
            .StoreLockSprite:
            STA.W WRAM_OAMBuffer,Y
            INY
            INY
            BRA .NextSlot
        .SkipLockSprite:
        LDA.L DATA8_StageClearRound1Checks,X
        AND.W #$00FF
        STA.L WRAM_CheckComparisonTemp
        LDA.L SRAM_StageClearRound1Clears,X
        AND.W #$00FF
        CMP.L WRAM_CheckComparisonTemp
        BCS .SkipAPSprite
            %append_sprite_sub(SUB_MenuSCCalculateSpritePos, GFX_APSprite)
            BRA .NextSlot
        .SkipAPSprite:
        LDA.L SRAM_StageClearRound1Clears,X
        BIT.W #$0040
        BEQ .SkipClearSprite
            %append_sprite_sub(SUB_MenuSCCalculateSpritePos, GFX_StageClearSprite)
            BRA .NextSlot
        .SkipClearSprite:
        .NextSlot:
        INX
        BRA .MenuSCCustomGraphicsLoop
    .MenuSCCustomGraphics_End:
    STY.W WRAM_OAMAppendAddr

    LDA.L $7E95EC
    BEQ .Jump1
        LDA.W #$0003
        STA.L $7E95EE
    .Jump1:
    LDX.W #$0000
    JSL.L CODE_838E7D_JSR
    LDA.L WRAM_MenuCursorY
    CMP.W #$0003
    BNE .Jump2
        INC.W WRAM_MenuProcedure
    .Jump2:
    LDA.B WRAM_Pad1State
    BEQ .UnhighlightLocks
    LDA.B WRAM_Pad1Press
    BEQ .SkipUnhighlightLocks
    .UnhighlightLocks:
        TDC
        STA.L WRAM_LockSpriteValues
        STA.L WRAM_LockSpriteValues+2
        STA.L WRAM_LockSpriteValues+4
        STA.L WRAM_LockSpriteValues+6
        STA.L WRAM_LockSpriteValues+8
        STA.L WRAM_LockSpriteValues+10
        STA.L WRAM_LockSpriteValues+12
        STA.L WRAM_LockSpriteValues+14
        STA.L WRAM_LockSpriteValues+16
        STA.L WRAM_LockSpriteValues+18
        STA.L WRAM_LockSpriteValues+20
        STA.L WRAM_LockSpriteValues+22
        STA.L WRAM_LockSpriteValues+24
        STA.L WRAM_LockSpriteValues+26
        STA.L WRAM_LockSpriteValues+28
        STA.L WRAM_LockSpriteValues+30
        STA.L WRAM_LockSpriteValues+32
        STA.L WRAM_LockSpriteValues+34
    .SkipUnhighlightLocks:
    LDA.B WRAM_Pad1Press
    BIT.W #$1080
    BEQ .Jump3
        LDA.W WRAM_StageClearSpecialIndex
        BNE .CanPlay
        JSR.W SUB_CheckIfRoundIsOpen
        BCS .CanPlay
            LDA.W #$0004
            STA.W WRAM_NewSoundEvent
            JSR.W SUB_HighlightRoundLockSprites
            JML.L CODE_JP_83E754
        .CanPlay:
        LDA.W #$0005
        STA.W WRAM_NewSoundEvent
        TDC
        STA.L $7E9969
        STA.L $7E997D
        JSL.L CODE_MenuSCPickFirstStage
        ;TODO: Fix menu graphics
        ;LDA.W WRAM_StageClearRoundIndex
        ;DEC A
        ;STA.W WRAM_StageClearRoundClears
        LDA.W #$0005
        STA.W WRAM_GameSubstate
        STZ.W WRAM_MenuProcedure
        JML.L CODE_JP_83E754
    .Jump3:
    BIT.W #$8000
    BEQ .Jump4
        LDA.W #$0004
        STA.W WRAM_NewSoundEvent
        TDC
        STA.L $7E9969
        STA.L $7E997D
        LDA.W #$0009
        STA.W WRAM_GameSubstate
        STZ.W WRAM_MenuProcedure
    .Jump4:
    JML.L CODE_JP_83E754
SUB_MenuSCCalculateSpritePos:
    PHX
    TXA
    ASL A
    TAX
    LDA.L DATA16_MenuSCSpritePositions,X
    PLX
    RTS
SUB_CheckIfRoundIsOpen:
    print "Round is open check at ",pc
    PHB
    PHK
    PLB
    LDA.W WRAM_StageClearRoundIndex
    DEC A
    ASL A
    TAX
    LDA.W DATA16_A1_StageClearUnlockOffsets,X
    TAX
    LDA.L $700000,X
    AND #$00FF
    BEQ .Failed
    LDA.L DATA8_StageClearFlags
    BIT.W #$0001
    BEQ .CheckIndividualStageUnlocks
        BIT.W #$0002
        BEQ .CheckIncrementalStageUnlocks
        .CheckSkippableStageUnlocks:
            LDA.L $700001,X
            BNE .Passed
            LDA.L $700003,X
            BNE .Passed
            LDA.L $700004,X
            BNE .Passed
            BRA .Failed
        .CheckIncrementalStageUnlocks:
            LDA.L $700001,X
            AND #$00FF
            BEQ .Failed
            BRA .Passed
    .CheckIndividualStageUnlocks:
        LDY.W #$0005
        .Loop:
            LDA.L $700001,X
            AND #$00FF
            BEQ .Failed
            INX
            DEY
            BNE .Loop
    .Passed:
        SEC
        PLB
        RTS
    .Failed:
        CLC
        PLB
        RTS
SUB_HighlightRoundLockSprites:
    LDA.W WRAM_StageClearRoundIndex ; (roundIndex-1)*6
    DEC A
    ASL A
    CLC
    ADC.W WRAM_StageClearRoundIndex
    DEC A
    ASL A
    TAX
    LDA.W #$0001
    STA.L WRAM_LockSpriteValues,X
    LDA.L DATA8_StageClearFlags
    BIT.W #$0002
    BNE .CanSkipFirstStage
        LDA.W #$0001
        STA.L WRAM_LockSpriteValues+1,X
    .CanSkipFirstStage:
    LDA.L DATA8_StageClearFlags
    BIT.W #$0001
    BNE .SkipIndividualStageLocks
        LDA.W #$0101
        STA.L WRAM_LockSpriteValues+2,X
        STA.L WRAM_LockSpriteValues+4,X
    .SkipIndividualStageLocks:
    RTS
DATA16_MenuSCSpritePositions:
    dw $306F,$4047,$404F,$4057,$405F,$4067
    dw $30E7,$40BF,$40C7,$40CF,$40D7,$40DF
    dw $706F,$8047,$804F,$8057,$805F,$8067
    dw $70E7,$80BF,$80C7,$80CF,$80D7,$80DF
    dw $B06F,$C047,$C04F,$C057,$C05F,$C067
    dw $B0E7,$C0BF,$C0C7,$C0CF,$C0D7,$C0DF
SUB_TriggerSpecialStage:
    LDA.W #$0006
    STA.W WRAM_GameSubstate
    LDA.W #$0001
    STA.W WRAM_StageClearSpecialIndex
    LDA.L SRAM_StageClearSpecialStageCompletions
    INC A
    STA.W WRAM_StageClearStageIndex
    RTS

SUB_DisplaySCTracker:
    LDA.W #$0C6C ; 'S'
    STA.L $7E228E
    LDA.W #$0C5C ; 'C'
    STA.L $7E2290
    LDA.W #$0015
    LDX.W #DATA16_SCTrackerLine2
    LDY.W #$22CE
    ;MVN $7E,bank(DATA16_SCTrackerLine2)
    LDA.W #$0017
    LDX.W #DATA16_SCTrackerLine3
    LDY.W #$230E
    MVN $7E,bank(DATA16_SCTrackerLine3)

    ; Count total checks completed
    LDA.W #LOC_StageClearChecksStart
    STA.B $00
    LDA.W #LOC_StageClearClearsStart
    STA.B $02
    LDA.W #(LOC_StageClearChecksEnd-LOC_StageClearChecksStart)
    STA.B $04
    STZ.B $06
    JSL.L CODE_CountCompletedChecks
    LDA.L SRAM_ClearedShockPanels
    STA.B $1A
    LDA.L DATA8_ShockPanelsPerCheck
    AND.W #$00FF
    STA.B $1C
    JSL.L CODE_WordDivision
    LDA.B $1A
    CLC
    ADC.B $06
    JSL.L CODE_16BitHexToDec
    LDA.W $0374
    ORA.W #$0450
    STA.L $7E2298
    LDA.W $0376
    ORA.W #$0450
    STA.L $7E229A
    LDA.W $0378
    ORA.W #$0450
    STA.L $7E229C
    LDA.L DATA16_StageClearTotalChecks
    JSL.L CODE_16BitHexToDec
    LDA.W $0374
    ORA.W #$0450
    STA.L $7E22A0
    LDA.W $0376
    ORA.W #$0450
    STA.L $7E22A2
    LDA.W $0378
    ORA.W #$0450
    STA.L $7E22A4

    ; TODO: Implement tracker
    TDC
    SEP #$20
    LDA.L SRAM_StageClearReceivedSpecialStages
    SEC
    SBC.L SRAM_StageClearSpecialStageCompletions
    BEQ .CaughtUpOnSpecialStages
    BMI .CaughtUpOnSpecialStages
    .PendingSpecialStages:
        REP #$20
        JSL.L CODE_16BitHexToDec ; Try finding an 8-bit version?
        LDA.W $0376
        ORA.W #$0850
        STA.L $7E231A
        LDA.W $0378
        ORA.W #$0850
        STA.L $7E231C
        BRA .DoneWithSpecialStage
    .CaughtUpOnSpecialStages:
        REP #$20
        LDA.W #$1450 ; '0'
        STA.L $7E231A
        STA.L $7E231C
    .DoneWithSpecialStage:
    LDY.W WRAM_OAMAppendAddr
    LDA.L SRAM_StageClearLastStageClear
    BIT.W #$0040
    BEQ .LastStageNotCleared
        %append_sprite($90, $60, GFX_StageClearSprite)
        BRA .End
    .LastStageNotCleared:
    LDA.L SRAM_StageClearLastStageUnlock
    AND.W #$00FF
    BEQ .NotUnlocked
    .Unlocked:
        LDA.L SRAM_StageClearLastStageClear
        BIT.W #$0001
        BNE .LastStageAlreadyCollected
        .LastStageNotCollected:
            %append_sprite($90, $60, GFX_APSprite)
            BRA .End
        .LastStageAlreadyCollected:
            %append_sprite($90, $60, GFX_Interrobang)
            BRA .End
    .NotUnlocked:
        %append_sprite($90, $60, GFX_LockSprite)
    .End:
    STY.W WRAM_OAMAppendAddr
    RTS
DATA16_SCTrackerLine2:
    dw $0451,$040E,$0452,$040E,$0453,$040E,$0454,$040E,$0455,$040E,$0456
DATA16_SCTrackerLine3:
    dw $046D,$046B,$045A,$0469,$046C,$047D,$040E,$040E,$040E,$0465,$046C,$040E

CODE_NewStageClearCustomSave:
    PHP
    REP #$30
    JSL.L CODE_SRAMValidation
    LDA.W #$0001
    STA.W $033C
    LDA.W #$0001
    STA.W $0344
    LDA.W #$0001
    STA.W WRAM_StageClearStageIndex
    STZ.W $0340
    JSR.W SUB_SetLocalRoundClears
    STZ.W $0346
    LDA.L SRAM_StageClearScore_Lo
    STA.W WRAM_Score_Lo
    STA.W WRAM_CheckpointScore_Lo
    LDA.L SRAM_StageClearScore_Hi
    STA.W WRAM_Score_Hi
    STA.W WRAM_CheckpointScore_Hi
    LDA.W #$0001
    STA.L $7E9446
    STZ.W WRAM_IngameHours
    STZ.W WRAM_IngameMinutes
    STZ.W WRAM_IngameSeconds
    PLP
    RTL

SUB_SetLocalRoundClears:
    LDA.L SRAM_StageClearLastStageUnlock
    AND.W #$00FF
    BEQ .NoLastStage
        LDA.W #$0006
        BRA .RoundClears
    .NoLastStage:
        LDA.W #$0005 ; Allow access to all 6 rounds then restrict the player's entry
    .RoundClears:
    STA.W WRAM_StageClearRoundClears
    RTS

CODE_MenuSCState2CustomCode11:
    TDC
    STA.L $7E96E3
    STA.L $7E96E5
    STA.L $7E9973
    JSL.L CODE_83E666_JSR
    LDA.W #$0001
    STA.L $7E9616
    STZ.W WRAM_MenuProcedure
    LDA.W #$0001
    STA.L $7E9610
    LDA.W #$0008
    STA.W WRAM_GameSubstate
    TDC
    STA.L WRAM_MenuCursorX
    STA.L $7E96EB
    STA.L WRAM_MenuCursorY
    JSL.L CODE_83E6C0_JSR
    JSL.L CODE_839565_JSR
    JSL.L CODE_83AEB0_JSR
    JSL.L CODE_83A058_JSR
    RTL