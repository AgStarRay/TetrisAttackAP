
DATA16_A1_StageClearUnlockOffsets:
    dw SRAM_StageClearRound1Unlocks
    dw SRAM_StageClearRound2Unlocks
    dw SRAM_StageClearRound3Unlocks
    dw SRAM_StageClearRound4Unlocks
    dw SRAM_StageClearRound5Unlocks
    dw SRAM_StageClearRound6Unlocks

CODE_ArchipelagoStageClearMenu:
    print "New stage clear submenu state 8 procedure 0 at ",pc
    JSL.L CODE_SRAMValidation
    JSL.L CODE_ScanIncomingArchipelagoItems
    JSR.W CODE_SetLocalRoundClears
    LDA.L SRAM_StageClearSpecialStageCompletions
    CMP.L SRAM_StageClearReceivedSpecialStages
    BCS .SkipSpecialStage
        JSR.W CODE_TriggerSpecialStage
        JML.L CODE_83E754
    .SkipSpecialStage:
    STZ.W WRAM7E_StageClearStageIndex
    LDY.W WRAM7E_OAMAppendAddr
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
            JSR.W CODE_MenuSCCalculateSpritePos
            STA.W WRAM7E_OAMBuffer,Y
            INY
            INY
            LDA.L SRAM_LockSpriteValues,X
            AND.W #$00FF
            BEQ .UseNormalLockSprite
                LDA.W #GFX_LockSpriteHighlighted
                BRA .StoreLockSprite
            .UseNormalLockSprite:
                LDA.W #GFX_LockSprite
            .StoreLockSprite:
            STA.W WRAM7E_OAMBuffer,Y
            INY
            INY
            BRA .NextSlot
        .SkipLockSprite:
        LDA.L DATA8_StageClearRound1Checks,X
        AND.W #$00FF
        STA.L SRAM_CheckComparisonTemp
        LDA.L SRAM_StageClearRound1Clears,X
        AND.W #$00FF
        CMP.L SRAM_CheckComparisonTemp
        BCS .SkipAPSprite
            JSR.W CODE_MenuSCCalculateSpritePos
            STA.W WRAM7E_OAMBuffer,Y
            INY
            INY
            LDA.W #GFX_APSprite
            STA.W WRAM7E_OAMBuffer,Y
            INY
            INY
            BRA .NextSlot
        .SkipAPSprite:
        LDA.L SRAM_StageClearRound1Clears,X
        BIT.W #$0040
        BEQ .SkipClearSprite
            JSR.W CODE_MenuSCCalculateSpritePos
            STA.W WRAM7E_OAMBuffer,Y
            INY
            INY
            LDA.W #GFX_StageClearSprite
            STA.W WRAM7E_OAMBuffer,Y
            INY
            INY
            BRA .NextSlot
        .SkipClearSprite:
        .NextSlot:
        INX
        BRA .MenuSCCustomGraphicsLoop
    .MenuSCCustomGraphics_End:
    STY.W WRAM7E_OAMAppendAddr

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
        INC.W WRAM83_MenuProcedure
    .Jump2:
    LDA.B WRAM00_Pad1State
    BEQ .UnhighlightLocks
    LDA.B WRAM00_Pad1Press
    BEQ .SkipUnhighlightLocks
    .UnhighlightLocks:
        LDA.W #$0000
        STA.L SRAM_LockSpriteValues
        STA.L SRAM_LockSpriteValues+2
        STA.L SRAM_LockSpriteValues+4
        STA.L SRAM_LockSpriteValues+6
        STA.L SRAM_LockSpriteValues+8
        STA.L SRAM_LockSpriteValues+10
        STA.L SRAM_LockSpriteValues+12
        STA.L SRAM_LockSpriteValues+14
        STA.L SRAM_LockSpriteValues+16
        STA.L SRAM_LockSpriteValues+18
        STA.L SRAM_LockSpriteValues+20
        STA.L SRAM_LockSpriteValues+22
        STA.L SRAM_LockSpriteValues+24
        STA.L SRAM_LockSpriteValues+26
        STA.L SRAM_LockSpriteValues+28
        STA.L SRAM_LockSpriteValues+30
        STA.L SRAM_LockSpriteValues+32
        STA.L SRAM_LockSpriteValues+34
    .SkipUnhighlightLocks:
    LDA.B WRAM00_Pad1Press
    BIT.W #$1080
    BEQ .Jump3
        LDA.W WRAM7E_StageClearSpecialIndex
        BNE .CanPlay
        JSR.W CODE_CheckIfRoundIsOpen
        BCS .CanPlay
            LDA.W #$0004
            STA.W WRAM83_NewSoundEvent
            JSR.W CODE_HighlightRoundLockSprites
            JML.L CODE_83E754
        .CanPlay:
        LDA.W #$0005
        STA.W WRAM83_NewSoundEvent
        LDA.W #$0000
        STA.L $7E9969
        STA.L $7E997D
        JSL.L CODE_MenuSCPickFirstStage
        ;TODO: Fix menu graphics
        ;LDA.W WRAM7E_StageClearRoundIndex
        ;DEC A
        ;STA.W WRAM7E_StageClearRoundClears
        LDA.W #$0005
        STA.W WRAM83_GameSubstate
        STZ.W WRAM83_MenuProcedure
        JML.L CODE_83E754
    .Jump3:
    BIT.W #$8000
    BEQ .Jump4
        LDA.W #$0004
        STA.W WRAM83_NewSoundEvent
        LDA.W #$0000
        STA.L $7E9969
        STA.L $7E997D
        LDA.W #$0009
        STA.W WRAM83_GameSubstate
        STZ.W WRAM83_MenuProcedure
    .Jump4:
    JML.L CODE_83E754
CODE_MenuSCCalculateSpritePos:
    PHX
    TXA
    ASL A
    TAX
    LDA.L DATA16_MenuSCSpritePositions,X
    PLX
    RTS
CODE_CheckIfRoundIsOpen:
    print "Round is open check at ",pc
    PHB
    PHK
    PLB
    LDA.W WRAM7E_StageClearRoundIndex
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
CODE_HighlightRoundLockSprites:
    LDA.W WRAM7E_StageClearRoundIndex ; (roundIndex-1)*6
    DEC A
    ASL A
    CLC
    ADC.W WRAM7E_StageClearRoundIndex
    DEC A
    ASL A
    TAX
    LDA.W #$0001
    STA.L SRAM_LockSpriteValues,X
    LDA.L DATA8_StageClearFlags
    BIT.W #$0002
    BNE .CanSkipFirstStage
        LDA.W #$0001
        STA.L SRAM_LockSpriteValues+1,X
    .CanSkipFirstStage:
    LDA.L DATA8_StageClearFlags
    BIT.W #$0001
    BNE .SkipIndividualStageLocks
        LDA.W #$0101
        STA.L SRAM_LockSpriteValues+2,X
        STA.L SRAM_LockSpriteValues+4,X
    .SkipIndividualStageLocks:
    RTS
DATA16_MenuSCSpritePositions:
    dw $306F,$4047,$404F,$4057,$405F,$4067
    dw $30E7,$40BF,$40C7,$40CF,$40D7,$40DF
    dw $706F,$8047,$804F,$8057,$805F,$8067
    dw $70E7,$80BF,$80C7,$80CF,$80D7,$80DF
    dw $B06F,$C047,$C04F,$C057,$C05F,$C067
    dw $B0E7,$C0BF,$C0C7,$C0CF,$C0D7,$C0DF
CODE_TriggerSpecialStage:
    LDA.W #$0006
    STA.W WRAM7E_GameSubstate
    LDA.W #$0001
    STA.W WRAM7E_StageClearSpecialIndex
    LDA.L SRAM_StageClearSpecialStageCompletions
    INC A
    STA.W WRAM7E_StageClearStageIndex
    RTS

CODE_NewStageClearCustomSave:
    PHP
    REP #$30
    JSL.L CODE_SRAMValidation
    LDA.W #$0001
    STA.W $033C
    LDA.W #$0001
    STA.W $0344
    LDA.W #$0001
    STA.W WRAM7E_StageClearStageIndex
    STZ.W $0340
    JSR.W CODE_SetLocalRoundClears
    STZ.W $0346
    STZ.W $02C2
    STZ.W $02C4
    LDA.W #$0001
    STA.L $7E9446
    STZ.W WRAM83_IngameHours
    STZ.W WRAM83_IngameMinutes
    STZ.W WRAM83_IngameSeconds
    PLP
    RTL

CODE_SetLocalRoundClears:
    LDA.L SRAM_StageClearLastStageUnlock
    AND.W #$00FF
    BEQ .NoLastStage
        LDA.W #$0006
        BRA .RoundClears
    .NoLastStage:
        LDA.W #$0005 ; Allow access to all 6 rounds then restrict the player's entry
    .RoundClears:
    STA.W WRAM7E_StageClearRoundClears
    RTS
    
CODE_MenuSCState1CustomCode:
    LDA.W #$0008
    STA.W WRAM83_GameSubstate
    PHB
    PHK
    PLB
    LDY.W #DATA_CustomGraphicsVRAMDMA
    JSL.L CODE_CreateVRAMDMA
    PLB
    JML.L CODE_83DDDC

CODE_MenuSCState2CustomCode0:
    RTL

CODE_MenuSCState2CustomCode11:
    PHB
    LDA.W #$0000
    STA.L $7E96E3
    STA.L $7E96E5
    STA.L $7E9973
    JSL.L CODE_83E666_JSR
    LDA.W #$0001
    STA.L $7E9616
    STZ.W WRAM83_MenuProcedure
    LDA.W #$0001
    STA.L $7E9610
    LDA.W #$0008
    STA.W WRAM83_GameSubstate
    LDA.W #$0000
    STA.L WRAM_MenuCursorX
    STA.L $7E96EB
    STA.L WRAM_MenuCursorY
    JSL.L CODE_83E6C0_JSR
    JSL.L CODE_839565_JSR
    JSL.L CODE_83AEB0_JSR
    JSL.L CODE_83A058_JSR
    PHK
    PLB
    LDY.W #DATA_CustomGraphicsVRAMDMA
    JSL.L CODE_CreateVRAMDMA
    PLB
    RTL