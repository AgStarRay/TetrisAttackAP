
DATA16_A1_PuzzleUnlockOffsets:
    dw SRAM_PuzzleLevel1Unlocks
    dw SRAM_PuzzleLevel2Unlocks
    dw SRAM_PuzzleLevel3Unlocks
    dw SRAM_PuzzleLevel4Unlocks
    dw SRAM_PuzzleLevel5Unlocks
    dw SRAM_PuzzleLevel6Unlocks
DATA16_A1_PuzzleSecretUnlockOffsets:
    dw SRAM_PuzzleSecretLevel1Unlocks
    dw SRAM_PuzzleSecretLevel2Unlocks
    dw SRAM_PuzzleSecretLevel3Unlocks
    dw SRAM_PuzzleSecretLevel4Unlocks
    dw SRAM_PuzzleSecretLevel5Unlocks
    dw SRAM_PuzzleSecretLevel6Unlocks

CODE_ArchipelagoPuzzleMenu:
    print "New puzzle submenu state 3 procedure 0 at ",pc
    JSL.L CODE_SRAMValidation
    JSL.L CODE_ScanIncomingArchipelagoItems
    LDA.W #$0005
    STA.L WRAM_PuzzleClearedLevels
    STZ.W WRAM7E_PuzzleClearIndex
    LDA.L $7E9973
    BEQ .NotScrolling
        JSL.L CODE_83B5A8_JSR
        LDA.L $7E9973
        BEQ .Jump1
            JMP.W .Jump8
        .Jump1:
            LDA.W #$0000
            STA.L $7E9973
            LDA.W $02BA
            JSL.L CODE_83B0AC_JSR
            BRL .Jump8
    .NotScrolling:

    LDA.W WRAM7E_PuzzleLevelIndex
    ASL A
    TAX
    LDA.W WRAM7E_PuzzleSecretFlag
    BEQ .NonSecret
        LDA.L DATA16_A1_PuzzleSecretUnlockOffsets,X
        BRA .UseIndex
    .NonSecret:
        LDA.L DATA16_A1_PuzzleUnlockOffsets,X
    .UseIndex:
    SEC
    SBC.L DATA16_A1_PuzzleUnlockOffsets
    TAX
    LDY.W WRAM7E_OAMAppendAddr
    LDA.W #$0000
    .MenuPZCustomGraphicsLoop:
        STA.L SRAM_LoopCounter
        LDA.L SRAM_PuzzleLevel1Unlocks,X
        AND.W #$00FF
        BNE .SkipLockSprite
            JSR.W CODE_MenuPZCalculateSpritePos
            STA.W WRAM7E_OAMBuffer,Y
            INY
            INY
            PHX
            LDA.L SRAM_LoopCounter
            TAX
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
            PLX
            BRA .NextSlot
        .SkipLockSprite:
        LDA.L DATA8_PuzzleLevel1Checks,X
        AND.W #$00FF
        STA.L SRAM_CheckComparisonTemp
        LDA.L SRAM_PuzzleLevel1Clears,X
        AND.W #$00FF
        CMP.L SRAM_CheckComparisonTemp
        BCS .SkipAPSprite
            JSR.W CODE_MenuPZCalculateSpritePos
            STA.W WRAM7E_OAMBuffer,Y
            INY
            INY
            LDA.W #GFX_APSprite
            STA.W WRAM7E_OAMBuffer,Y
            INY
            INY
            BRA .NextSlot
        .SkipAPSprite:
        LDA.L SRAM_PuzzleLevel1Clears,X
        BIT.W #$0040
        BEQ .SkipClearSprite
            JSR.W CODE_MenuPZCalculateSpritePos
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
        LDA.L SRAM_LoopCounter
        INC A
        CMP.W #$000B
        BCS .MenuPZCustomGraphics_End
        BRL .MenuPZCustomGraphicsLoop
    .MenuPZCustomGraphics_End:
    STY.W WRAM7E_OAMAppendAddr

    LDA.L WRAM_MenuCursorX
    BNE .Jump3
    LDA.B WRAM00_Pad1Repeat
    BIT.W #$0200
    BEQ .Jump3
        JSL.L CODE_83EDCC_JSR
        BRL .Jump8
    .Jump3:
    LDA.L WRAM_MenuCursorX
    CMP.W #$0004
    BNE .Jump4
    LDA.B WRAM00_Pad1Repeat
    BIT.W #$0100
    BEQ .Jump4
        JSL.L CODE_83EE11_JSR
        BRL .Jump8
    .Jump4:
    JSL.L CODE_MenuPZSetPuzzleIndex_JSR
    JSL.L CODE_83EE98_JSR
    LDA.L $7E95EC
    BEQ .Jump5
        LDA.W #$0002
        STA.L $7E95EE
    .Jump5:
    LDX.W #$0000
    JSL.L CODE_838E7D_JSR
    LDA.L $7E95EA
    BEQ .Jump6
        LDA.W #$0000
        STA.L $7E9965
        STA.L $7E9979
    .Jump6:
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
    .SkipUnhighlightLocks:
    LDA.B WRAM00_Pad1Press
    BIT.W #$1080
    BEQ .Jump7
        JSR.W CODE_CheckIfPuzzleLevelIsOpen
        BCS .CanPlay
            LDA.W #$0004
            STA.W WRAM7E_NewSoundEvent
            JSR.W CODE_HighlightPuzzleLockSprites
            BRA .Jump8
        .CanPlay:
        LDA.W #$0005
        STA.W WRAM7E_GameSubstate
        STA.W WRAM7E_NewSoundEvent
        LDA.L WRAM_MenuCursorY
        BNE .LowerRow
            LDA.W #$0000
            BRA .UseRowIndex
        .LowerRow:
            LDA.W #$0005
        .UseRowIndex:
        CLC
        ADC.L WRAM_MenuCursorX
        STA.W WRAM7E_PuzzleStageIndex
        LDA.W #$0004 ; Set to 4 so the game doesn't set the puzzle index to 1
        STA.L $7E943C
        BRA .Jump8
    .Jump7:
    BIT.W #$8000
    BEQ .Jump8
        LDA.W #$0004
        STA.W WRAM7E_GameSubstate
        STA.W WRAM7E_NewSoundEvent
        LDA.W $02BA
        JSL.L CODE_83B0B5_JSR
    .Jump8:
    LDA.L $7E9973
    BNE .Jump9
        JSL.L CODE_839958_JSR
    .Jump9:
    JSL.L CODE_83B59B_JSR
    RTL

CODE_MenuPZCalculateSpritePos:
    PHX
    LDA.L SRAM_LoopCounter
    ASL A
    TAX
    LDA.L DATA16_MenuPZSpritePositions,X
    PLX
    RTS
CODE_CheckIfPuzzleLevelIsOpen:
    print "Puzzle level is open check at ",pc
    PHB
    PHK
    PLB
    LDA.W WRAM7E_PuzzleLevelIndex
    ASL A
    TAX
    LDA.W WRAM7E_PuzzleSecretFlag
    BEQ .NonSecret
        LDA.L DATA16_A2_PuzzleSecretUnlockOffsets,X
        BRA .UseIndex
    .NonSecret:
        LDA.L DATA16_A2_PuzzleUnlockOffsets,X
    .UseIndex:
    TAX
    LDA.L $700000,X
    AND #$00FF
    BEQ .Failed
    LDA.L DATA8_PuzzleFlags
    BIT.W #$0001
    BEQ .CheckIndividualStageUnlocks
        LDA.L WRAM_MenuCursorY
        BNE .LowerRow
            TXA
            BRA .UseRowIndex
        .LowerRow:
            TXA
            ADC.W #$0005
        .UseRowIndex:
        CLC
        ADC.L WRAM_MenuCursorX
        TAX
        LDA.L $700001,X
        AND #$00FF
        BNE .Passed
        BRA .Failed
    .CheckIndividualStageUnlocks:
        LDY.W #$000A
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
CODE_HighlightPuzzleLockSprites:
    LDA.W #$0001
    STA.L SRAM_LockSpriteValues
    LDA.L DATA8_PuzzleFlags
    BIT.W #$0001
    BNE .JustTheCurrentLock
        LDA.W #$0101
        STA.L SRAM_LockSpriteValues+1
        STA.L SRAM_LockSpriteValues+3
        STA.L SRAM_LockSpriteValues+5
        STA.L SRAM_LockSpriteValues+7
        STA.L SRAM_LockSpriteValues+9
        RTS
    .JustTheCurrentLock:
    LDA.L WRAM_MenuCursorY
    BNE .LowerRow
        LDA.L WRAM_MenuCursorX
        BRA .UseRowIndex
    .LowerRow:
        LDA.L WRAM_MenuCursorX
        CLC
        ADC.W #$0005
    .UseRowIndex:
    TAX
    LDA.W #$0001
    STA.L SRAM_LockSpriteValues+1,X
    RTS
DATA16_MenuPZSpritePositions:
    dw $63A6
    dw $7580,$7588,$7590,$7598,$75A0
    dw $8580,$8588,$8590,$8598,$85A0

CODE_NewPuzzleCustomSave:
    PHP
    REP #$20
    STZ.W WRAM7E_PuzzleClearIndex
    STZ.W WRAM7E_PuzzleSecretFlag
    STZ.W WRAM7E_PuzzleStageIndex
    LDA.W #$0001
    STA.W WRAM7E_PuzzleIndex
    STA.L WRAM_EndModeIndicator
    STZ.W WRAM7E_IngameHours
    STZ.W WRAM7E_IngameMinutes
    STZ.W WRAM7E_IngameSeconds
    PLP
    RTL
    
CODE_MenuPZState2CustomCode9:
    PHB
    LDA.W #$0003
    STA.W WRAM7E_GameSubstate
    LDA.W #$0000
    STA.W WRAM7E_MenuProcedure
    STA.L $7E961C
    PHK
    PLB
    LDY.W #DATA_CustomGraphicsVRAMDMA
    JSL.L CODE_CreateVRAMDMA
    PLB
    JML.L CODE_83ED28
CODE_MenuPZState2CustomCode10:
    PHB
    LDA.L $7E9618
    BNE .Jump1
    INC.W WRAM7E_GameSubstate
    LDA.W #$0000
    STA.W WRAM7E_MenuProcedure
    STA.L $7E9973
    BRA .Jump2
    .Jump1:
    INC.W WRAM7E_MenuProcedure
    LDA.W #$0018
    STA.L $7E9987
    .Jump2:
    PHK
    PLB
    LDY.W #DATA_CustomGraphicsVRAMDMA
    JSL.L CODE_CreateVRAMDMA
    PLB
    JML.L CODE_83EBBF
