
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
    ;TODO: AP and lock sprites are not loaded when returning from a puzzle
    JSL.L CODE_SRAMValidation
    JSL.L CODE_ScanIncomingArchipelagoItems
    LDA.L DATA8_PuzzleFlags
    BIT.W #%0100
    BEQ .SkipSwitchLogic
    BIT.W #%1000
    BEQ .SkipSwitchLogic ; Both puzzle sets have to be available
        LDA.L WRAM_PrintedSwitchMessage
        BNE .SkipPrint ; Only need to print once
            LDA.W #$0001
            STA.L WRAM_PrintedSwitchMessage
            PHB
            PHK
            PLB
            LDA.W WRAM7E_PuzzleSecretFlag
            BEQ .SecretMessage
                LDY.W #DATA_NormalMessageVRAMDMA
                BRA .EndMessageSelection
            .SecretMessage:
                LDY.W #DATA_SecretMessageVRAMDMA
            .EndMessageSelection:
            JSL.L CODE_CreateVRAMDMA
            PLB
        .SkipPrint:
        LDA.W WRAM7E_Pad1Press
        BIT.W #$4040 ; X or Y
        BEQ .SkipSwitchLogic
            LDA.W #$0001
            STA.W WRAM7E_NewSoundEvent
            TDC
            STA.L WRAM_PrintedSwitchMessage
            LDA.W WRAM7E_PuzzleSecretFlag
            EOR.W #$0001
            STA.W WRAM7E_PuzzleSecretFlag
            LDA.W #$0028
            JSL.L CODE_83A9E3_JSR
    .SkipSwitchLogic:
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
            TDC
            STA.L $7E9973
            LDA.W WRAM7E_CharacterIndex1
            JSL.L CODE_83B0AC_JSR
            BRL .Jump8
    .NotScrolling:

    LDA.W WRAM7E_CharacterIndex1
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
    TDC
    .MenuPZCustomGraphicsLoop:
        STA.L WRAM_LoopCounter
        LDA.L SRAM_PuzzleLevel1Unlocks,X
        AND.W #$00FF
        BNE .SkipLockSprite
            JSR.W SUB_MenuPZCalculateSpritePos
            STA.W WRAM7E_OAMBuffer,Y
            INY
            INY
            PHX
            LDA.L WRAM_LoopCounter
            TAX
            LDA.L WRAM_LockSpriteValues,X
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
        STA.L WRAM_CheckComparisonTemp
        LDA.L SRAM_PuzzleLevel1Clears,X
        AND.W #$00FF
        CMP.L WRAM_CheckComparisonTemp
        BCS .SkipAPSprite
            %append_sprite_sub(SUB_MenuPZCalculateSpritePos, GFX_APSprite)
            BRA .NextSlot
        .SkipAPSprite:
        LDA.L SRAM_PuzzleLevel1Clears,X
        BIT.W #$0040
        BEQ .SkipClearSprite
            %append_sprite_sub(SUB_MenuPZCalculateSpritePos, GFX_StageClearSprite)
            BRA .NextSlot
        .SkipClearSprite:
        .NextSlot:
        INX
        LDA.L WRAM_LoopCounter
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
        TDC
        STA.L $7E9965
        STA.L $7E9979
    .Jump6:
    LDA.B WRAM00_Pad1State
    BEQ .UnhighlightLocks
    LDA.B WRAM00_Pad1Press
    BEQ .SkipUnhighlightLocks
    .UnhighlightLocks:
        TDC
        STA.L WRAM_LockSpriteValues
        STA.L WRAM_LockSpriteValues+2
        STA.L WRAM_LockSpriteValues+4
        STA.L WRAM_LockSpriteValues+6
        STA.L WRAM_LockSpriteValues+8
        STA.L WRAM_LockSpriteValues+10
    .SkipUnhighlightLocks:
    LDA.B WRAM00_Pad1Press
    BIT.W #$1080
    BEQ .Jump7
        JSR.W SUB_CheckIfPuzzleLevelIsOpen
        BCS .CanPlay
            LDA.W #$0004
            STA.W WRAM7E_NewSoundEvent
            JSR.W SUB_HighlightPuzzleLockSprites
            BRA .Jump8
        .CanPlay:
        LDA.W #$0005
        STA.W WRAM7E_GameSubstate
        STA.W WRAM7E_NewSoundEvent
        LDA.L WRAM_MenuCursorY
        BNE .LowerRow
            TDC
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
        LDA.W WRAM7E_CharacterIndex1
        JSL.L CODE_83B0B5_JSR
    .Jump8:
    LDA.L $7E9973
    BNE .Jump9
        JSL.L CODE_839958_JSR
    .Jump9:
    JSL.L CODE_83B59B_JSR
    RTL

SUB_MenuPZCalculateSpritePos:
    PHX
    LDA.L WRAM_LoopCounter
    ASL A
    TAX
    LDA.L DATA16_MenuPZSpritePositions,X
    PLX
    RTS
SUB_CheckIfPuzzleLevelIsOpen:
    print "Puzzle level is open check at ",pc
    PHB
    PHK
    PLB
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
SUB_HighlightPuzzleLockSprites:
    LDA.W #$0001
    STA.L WRAM_LockSpriteValues
    LDA.L DATA8_PuzzleFlags
    BIT.W #$0001
    BNE .JustTheCurrentLock
        LDA.W #$0101
        STA.L WRAM_LockSpriteValues+1
        STA.L WRAM_LockSpriteValues+3
        STA.L WRAM_LockSpriteValues+5
        STA.L WRAM_LockSpriteValues+7
        STA.L WRAM_LockSpriteValues+9
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
    STA.L WRAM_LockSpriteValues+1,X
    RTS
DATA16_MenuPZSpritePositions:
    dw $63A6
    dw $7580,$7588,$7590,$7598,$75A0
    dw $8580,$8588,$8590,$8598,$85A0

SUB_DisplayPZTracker:
    LDA.W #$1069
    STA.L $7E228E
    LDA.W #$1073
    STA.L $7E2290
    LDA.W #$0015
    LDX.W #DATA16_PZTrackerLine2
    LDY.W #$22CE
    ;MVN $7E,bank(DATA16_PZTrackerLine2)
    LDA.L DATA8_PuzzleFlags
    AND.W #%1100
    CMP.W #%1000
    BEQ .MiddleIsExtra
    .MiddleIsNormal:
        BRA .EndMiddleRow
    .MiddleIsExtra:
    .EndMiddleRow:

    LDA.L DATA8_PuzzleFlags
    BIT.W #%0100
    BEQ .SkipExtraRow
    BIT.W #%1000
    BEQ .SkipExtraRow
    .DoExtraRow:
        ;LDA.W #$0017
        ;LDX.W #DATA16_PZTrackerLine3Extra
        ;LDY.W #$230E
        ;MVN $7E,bank(DATA16_PZTrackerLine3Extra)
        ;BRA .EndExtraRow
    .SkipExtraRow:
        LDA.W #$0017
        LDX.W #DATA16_PZTrackerLine3NonExtra
        LDY.W #$230E
        MVN $7E,bank(DATA16_PZTrackerLine3NonExtra)
    .EndExtraRow:

    ; Count total checks completed
    LDA.W #LOC_PuzzleChecksStart
    STA.B $00
    LDA.W #LOC_PuzzleClearsStart
    STA.B $02
    LDA.W #(LOC_PuzzleChecksEnd-LOC_PuzzleChecksStart)
    STA.B $04
    STZ.B $06
    JSL.L CODE_CountCompletedChecks
    LDA.B $06
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
    LDA.L DATA16_PuzzleTotalChecks
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
    RTS
DATA16_PZTrackerLine2:
    dw $0451,$040E,$0452,$040E,$0453,$040E,$0454,$040E,$0455,$040E,$0456
DATA16_PZTrackerLine3NonExtra:
    dw $040E,$040E,$040E,$040E,$040E,$040E,$040E,$040E,$040E,$040E,$040E,$040E
DATA16_PZTrackerLine3Extra:
    dw $045E,$040E,$045E,$040E,$045E,$040E,$045E,$040E,$045E,$040E,$045E,$040E

CODE_NewPuzzleCustomSave:
    PHP
    REP #$20
    LDA.L DATA8_PuzzleFlags
    BIT.W #%0100
    BNE .NormalAccessible
    BIT.W #%1000
    BEQ .NormalAccessible
        LDA.W #$0001
        STA.W WRAM7E_PuzzleSecretFlag
        BRA .EndSecretFlag
    .NormalAccessible:
        STZ.W WRAM7E_PuzzleSecretFlag
    .EndSecretFlag:
    STZ.W WRAM7E_PuzzleClearIndex
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
    LDA.W #$0003
    STA.W WRAM7E_GameSubstate
    TDC
    STA.L WRAM_PrintedSwitchMessage
    STA.W WRAM7E_MenuProcedure
    STA.L $7E961C
    JML.L CODE_83ED28
CODE_MenuPZState2CustomCode10:
    LDA.L $7E9618
    BNE .Jump1
    INC.W WRAM7E_GameSubstate
    TDC
    STA.L WRAM_PrintedSwitchMessage
    STA.W WRAM7E_MenuProcedure
    STA.L $7E9973
    BRA .Jump2
    .Jump1:
    INC.W WRAM7E_MenuProcedure
    LDA.W #$0018
    STA.L $7E9987
    .Jump2:
    JML.L CODE_83EBBF

DATA_SecretControlVRAMData:
    dw $038D,$038E,$0391,$038C,$0380,$038B,$0000,$0000
    dw $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
    dw $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
    dw $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
    dw $0397,$039D,$038E,$0391,$039D,$0398,$039D,$0385
    dw $038E,$0391,$039D,$0384,$0397,$0393,$0391,$0380,$0000

DATA_SecretMessageVRAMDMA:
    dl DATA_SecretControlVRAMData
    dw $0062
    db $80
    dw $6A87

DATA_NormalControlVRAMData:
    dw $0384,$0397,$0393,$0391,$0380,$0000,$0000,$0000
    dw $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
    dw $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
    dw $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
    dw $0397,$039D,$038E,$0391,$039D,$0398,$039D,$0385
    dw $038E,$0391,$039D,$038D,$038E,$0391,$038C,$0380,$038B

DATA_NormalMessageVRAMDMA:
    dl DATA_NormalControlVRAMData
    dw $0062
    db $80
    dw $6A87
