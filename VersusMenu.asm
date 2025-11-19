CODE_VsSelection:
    print "Main menu Vs selection at ", pc
    JSR.W SUB_KeepVsStageInRange
    LDA.L WRAM_1POptionIndex
    CMP.W #$0004
    BNE .SkipVsSelect
        LDA.W WRAM_Pad1Repeat
        BIT.W #$0200
        BEQ .NoLeftSignal
            LDA.W #$0001
            STA.W WRAM_NewSoundEvent
            LDA.L WRAM_VsStageNumber
            DEC A
            BPL .StageNumberNotNegative
                LDA.W #$000B
            .StageNumberNotNegative:
            STA.L WRAM_VsStageNumber
            BRA .DisplayStageState
        .NoLeftSignal:
        BIT.W #$0100
        BEQ .NoRightSignal
            LDA.W #$0001
            STA.W WRAM_NewSoundEvent
            LDA.L WRAM_VsStageNumber
            INC A
            STA.L WRAM_VsStageNumber
            JSR.W SUB_KeepVsStageInRange
        .NoRightSignal:
        .DisplayStageState:
        JSR.W SUB_VsDisplayStageSelector
        JSR.W SUB_VsDisplayStageState
    .SkipVsSelect:
    ; Set the two characters on the Vs option
    LDA.L WRAM_VsStageNumber
    INC A
    JSL.L CODE_16BitHexToDec
    LDA.W $0376
    CLC
    ADC.W #$1450
    STA.L $7E24A0
    LDA.W $0378
    CLC
    ADC.W #$1450
    STA.L $7E24A2
    RTL

SUB_KeepVsStageInRange:
    LDA.L WRAM_VsStageNumber
    CMP.W #$000C
    BCC .StageNumberInRange
        TDC
    .StageNumberInRange:
    STA.L WRAM_VsStageNumber
    RTS

SUB_VsDisplayStageSelector:
    LDY.W WRAM_OAMAppendAddr
    %append_sprite($98, $5B, $30BF)
    %append_sprite($98, $63, $30BE)
    %append_sprite($30, $5B, $70BF)
    %append_sprite($30, $63, $70BE)
    STY.W WRAM_OAMAppendAddr
    RTS

SUB_VsDisplayStageState:
    LDY.W WRAM_OAMAppendAddr
    LDA.L WRAM_VsStageNumber
    TAX
    CPX.W #$0008
    BCC .NotInCave
        LDA.L SRAM_VersusMtWickednessGate
        AND.W #$00FF
        BNE .HasGate
        .MtWickednessLocked:
            %append_sprite($92, $90, GFX_LockSprite)
        .HasGate:
    .NotInCave:
    LDA.L DATA8_VersusFlags
    BIT.W #%001
    BEQ .SelectableDifficulty
    .FixedDifficulty:
        LDA.L SRAM_VersusStageUnlocks,X
        AND.W #$00FF
        BNE .Unlocked
        .Locked:
            %append_sprite($90, $90, GFX_LockSprite)
            BRL .End
        .Unlocked:
            PHY
            %load_goal_difficulty()
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
            PLY
            LDA.L SRAM_VersusStageClears,X
            AND.W #$00FF
            CMP.B $00
            BCC .NotCleared
                %append_sprite($90, $90, GFX_StageClearSprite)
                BRA .End
            .NotCleared:
                %append_sprite($90, $90, GFX_APSprite)
            BRA .End
    .SelectableDifficulty:
        BIT.W #%01000
        BNE .MultipleUnlocks
        .OneUnlock:
            LDA.L SRAM_VersusStageUnlocks,X
            AND.W #$00FF
            ASL A
            ASL A
            BRA .DisplayDifficulties
        .MultipleUnlocks:
            LDA.L SRAM_VersusStageUnlocks,X
            AND.W #$00FF
        .DisplayDifficulties:
        STA.B $00
        LDA.W #$9877
        STA.B $02
        LDA.W #$0004
        STA.B $06
        LDA.L DATA8_VsMinimumDifficulties,X
        AND.W #$00FF
        STA.B $08
        CLC
        ADC.B $00
        STA.B $00
        TDC
        .DifficultyLoop:
            STA.B $04
            JSR.W SUB_VsDisplayDifficultyState
            LDA.B $06
            ASL A
            STA.B $06
            LDA.B $04
            INC A
            CMP.W #$0004
        BNE .DifficultyLoop
    .End:
    STY.W WRAM_OAMAppendAddr
    RTS
SUB_VsDisplayDifficultyState:
    ; $00 is the number of difficulty levels for the selected stage
    ; $02 is the sprite position
    ; $04 is the difficulty level
    ; $06 is the bitmask for the cleared difficulties
    ; $08 is the minimum difficulty level for the selected stage
    LDA.B $02
    STA.W WRAM_OAMBuffer,Y
    CLC
    ADC.W #$0008
    STA.B $02
    INY
    INY
    LDA.B $04
    CMP.B $08
    BCC .Locked ; Current difficulty is less than the minimum difficulty
    LDA.B $04
    CMP.B $00
    BCC .Unlocked ; Current difficulty is less than unlocked difficulty count
    .Locked:
        LDA.W #GFX_LockSprite
        STA.W WRAM_OAMBuffer,Y
        INY
        INY
        RTS
    .Unlocked:
    LDA.L SRAM_VersusStageClears,X
    AND.B $06
    BEQ .NotCleared
    .Cleared:
        LDA.W #GFX_StageClearSprite
        STA.W WRAM_OAMBuffer,Y
        INY
        INY
        RTS
    .NotCleared:
    LDA.B $04
    CMP.B $08
    BEQ .FirstDifficulty
    LDA.L DATA8_VersusStageChecks,X
    AND.B $06
    BEQ .NoItem
    BRA .HasItem
    .FirstDifficulty:
    LDA.L DATA8_VersusStageChecks,X
    AND.W #%00000011
    BEQ .NoItem
    .HasItem:
        LDA.W #GFX_APSprite
        STA.W WRAM_OAMBuffer,Y
        INY
        INY
        RTS
    .NoItem:
    LDA.L DATA8_GoalVersus
    AND.W #%01100
    LSR A
    LSR A
    CLC
    ADC.W #$0008
    CMP.L WRAM_VsStageNumber
    BNE .Pointless
    LDA.L DATA8_GoalVersus
    print "Check here ",pc
    AND.W #%00011
    CMP.B $04
    BNE .Pointless
    .Goal: ; If this is the goal stage at the goal difficulty
        LDA.W #GFX_Interrobang
        STA.W WRAM_OAMBuffer,Y
        INY
        INY
        RTS
    .Pointless:
        LDA.W #$B0DD ; "_"
        STA.W WRAM_OAMBuffer,Y
        INY
        INY
        RTS

CODE_ArchipelagoVsMenu:
    JSL.L CODE_ScanIncomingArchipelagoItems
    LDA.L #$000A
    JSL.L CODE_MenuYoshiDialog_JSR

    LDA.L DATA8_VersusFlags
    BIT.W #%001
    BEQ .SelectableDifficulty
        ; Go straight to Vs
        %load_goal_difficulty()
        STA.W WRAM_VsDifficulty
        LDA.W #$0039
        STA.W WRAM_GameSubstate
        STZ.W WRAM_MenuProcedure
        RTL
    .SelectableDifficulty:
    PHB
    PHK
    PLB
    JSR.W SUB_VsDisplayStageState
    LDA.W WRAM_Pad1Repeat
    BIT.W #$0200
    BEQ .NoLeftSignal
        LDA.W #$0001
        STA.W WRAM_NewSoundEvent
        LDA.W WRAM_VsDifficulty
        DEC A
        BPL .DifficultyNotNegative
            LDA.W #$0003
        .DifficultyNotNegative:
        STA.W WRAM_VsDifficulty
        BRA .HandleAOrB
    .NoLeftSignal:
    BIT.W #$0100
    BEQ .NoRightSignal
        LDA.W #$0001
        STA.W WRAM_NewSoundEvent
        LDA.W WRAM_VsDifficulty
        INC A
        AND.W #$0003
        STA.W WRAM_VsDifficulty
    .NoRightSignal:
    .HandleAOrB:
    LDA.W WRAM_Pad1Press
    BIT.W #$8000
    BEQ .DidNotPressB
        LDX.W #DATA16_VsText
        JSR.W SUB_PrintVsOptionText
        LDA.W #$0004
        STA.W WRAM_NewSoundEvent
        LDA.W #$0009
        STA.W WRAM_GameSubstate
        STZ.W WRAM_MenuProcedure
        BRA .UpdateBG1
    .DidNotPressB:
    BIT.W #$0080
    BEQ .DidNotPressA
        print "Menu difficulty available check at ",pc
        JSL.L CODE_VsStageIsAvailable
        BPL .GoToVs
            LDA.W #$0004
            STA.W WRAM_NewSoundEvent
            BRA .DidNotPressA
        .GoToVs:
            LDA.W #$0005
            STA.W WRAM_NewSoundEvent
            LDA.W #$0039
            STA.W WRAM_GameSubstate
            STZ.W WRAM_MenuProcedure
            LDA.W WRAM_VsDifficulty
            STA.L $7E66CA
            BRA .UpdateBG1
    .DidNotPressA:
        LDA.W WRAM_VsDifficulty
        ASL A
        TAX
        LDA.W PTR16_DifficultyText,X
        TAX
        JSR.W SUB_PrintVsOptionText
        LDY.W WRAM_OAMAppendAddr
        LDA.W WRAM_VsDifficulty
        ASL A
        ASL A
        ASL A
        CLC
        ADC.W #$9F77
        STA.W WRAM_OAMBuffer,Y
        INY
        INY
        LDA.W #$300D
        STA.W WRAM_OAMBuffer,Y
        INY
        INY
        STY.W WRAM_OAMAppendAddr
    .UpdateBG1:
    JSR.W SUB_DisplayVSTracker
    JSR.W SUB_RenderCustomMenuBG1
    PLB
    RTL

SUB_PrintVsOptionText:
    print "Vs Option text print at ",pc
    LDA.W #$000B
    LDY.W #$2490
    MVN $7E,bank(PTR16_DifficultyText)
    RTS

PTR16_DifficultyText:
    dw DATA16_EasyText
    dw DATA16_NormalText
    dw DATA16_HardText
    dw DATA16_VHardText
DATA16_VsText:
    dw $146F,$146C,$147A,$040E,$040E,$040E
DATA16_EasyText:
    dw $045E,$045A,$046C,$0472,$040E,$040E
DATA16_NormalText:
    dw $0C67,$0C68,$0C6B,$0C66,$0C5A,$0C65
DATA16_HardText:
    dw $0861,$085A,$086B,$085D,$040E,$040E
DATA16_VHardText:
    dw $106F,$107A,$1061,$105A,$106B,$105D

SUB_DisplayVSTracker:
    LDA.W #$146F
    STA.L $7E228E
    LDA.W #$146C
    STA.L $7E2290
    LDA.W #$0015
    LDX.W #DATA16_VSTrackerLine2
    LDY.W #$22CE
    MVN $7E,bank(DATA16_VSTrackerLine2)

    ; Count total checks completed
    LDA.W #LOC_VersusChecksStart
    STA.B $00
    LDA.W #LOC_VersusClearsStart
    STA.B $02
    LDA.W #(LOC_VersusChecksEnd-LOC_VersusChecksStart)
    STA.B $04
    STZ.B $06
    JSL.L CODE_CountCompletedChecks
    LDA.B $06
    JSL.L CODE_16BitHexToDec
    LDA.W #$040E
    STA.L $7E2298
    LDA.W $0376
    ORA.W #$0450
    STA.L $7E229A
    LDA.W $0378
    ORA.W #$0450
    STA.L $7E229C
    LDA.L DATA16_VersusTotalChecks
    JSL.L CODE_16BitHexToDec
    LDA.W #$040E
    STA.L $7E22A0
    LDA.W $0376
    ORA.W #$0450
    STA.L $7E22A2
    LDA.W $0378
    ORA.W #$0450
    STA.L $7E22A4

    ; TODO: Implement tracker

    ; Display selected stage name and character name
    PHB
    PHK
    PLB
    LDA.L WRAM_VsStageNumber
    ASL A
    TAY
    LDA.W WRAM_GameSeconds
    BIT.W #$0001
    BEQ .Even
        LDX.W PTR16_StageNameText,Y
        BRA .Print
    .Even:
        LDX.W PTR16_CharacterNameText,Y
    .Print:
    LDA.W #$0017
    LDY.W #$230E
    PLB
    MVN $7E,bank(PTR16_StageNameText)
    RTS
DATA16_VSTrackerLine2:
    dw $040E,$040E,$040E,$040E,$040E,$040E,$040E,$040E,$040E,$040E,$040E
PTR16_StageNameText:
    dw TEXT_Stage1Name
    dw TEXT_Stage2Name
    dw TEXT_Stage3Name
    dw TEXT_Stage4Name
    dw TEXT_Stage5Name
    dw TEXT_Stage6Name
    dw TEXT_Stage7Name
    dw TEXT_Stage8Name
    dw TEXT_MtWickedness
    dw TEXT_MtWickedness
    dw TEXT_MtWickedness
    dw TEXT_LastStage
TEXT_Stage1Name: ; Breeze
    dw $145B,$146B,$145E,$145E,$1473,$145E,$140E,$140E,$140E,$140E,$140E,$140E
TEXT_Stage2Name: ; Glacial
    dw $1460,$1465,$145A,$145C,$1462,$145A,$1465,$140E,$140E,$140E,$140E,$140E
TEXT_Stage3Name: ; Forest
    dw $145F,$1468,$146B,$145E,$146C,$146D,$140E,$140E,$140E,$140E,$140E,$140E
TEXT_Stage4Name: ; Flower
    dw $145F,$1465,$1468,$1470,$145E,$146B,$140E,$140E,$140E,$140E,$140E,$140E
TEXT_Stage5Name: ; Water
    dw $1470,$145A,$146D,$145E,$146B,$140E,$140E,$140E,$140E,$140E,$140E,$140E
TEXT_Stage6Name: ; Blaze
    dw $145B,$1465,$145A,$1473,$145E,$140E,$140E,$140E,$140E,$140E,$140E,$140E
TEXT_Stage7Name: ; Sea
    dw $146C,$145E,$145A,$140E,$140E,$140E,$140E,$140E,$140E,$140E,$140E,$140E
TEXT_Stage8Name: ; Lunar
    dw $1465,$146E,$1467,$145A,$146B,$140E,$140E,$140E,$140E,$140E,$140E,$140E
TEXT_MtWickedness: ; MtWickedness
    dw $1466,$146D,$1470,$1462,$145C,$1464,$145E,$145D,$1467,$145E,$146C,$146C
TEXT_LastStage: ; Last Stage
    dw $1465,$145A,$146C,$146D,$140E,$146C,$146D,$145A,$1460,$145E,$140E,$140E
TEXT_Unknown: ; ???
    dw $1476,$1476,$1476,$140E,$140E,$140E,$140E,$140E,$140E,$140E,$140E,$140E
PTR16_CharacterNameText:
    dw TEXT_Character1Name
    dw TEXT_Character2Name
    dw TEXT_Character3Name
    dw TEXT_Character4Name
    dw TEXT_Character5Name
    dw TEXT_Character6Name
    dw TEXT_Character7Name
    dw TEXT_Character8Name
    dw TEXT_Character9Name
    dw TEXT_Character10Name
    dw TEXT_Character11Name
    dw TEXT_Character12Name
TEXT_Character1Name: ; Lakitu
    dw $0865,$085A,$0864,$0862,$086D,$086E,$080E,$080E,$080E,$080E,$080E,$080E
TEXT_Character2Name: ; Bumpty
    dw $085B,$086E,$0866,$0869,$086D,$0872,$080E,$080E,$080E,$080E,$080E,$080E
TEXT_Character3Name: ; Poochy
    dw $0869,$0868,$0868,$085C,$0861,$0872,$080E,$080E,$080E,$080E,$080E,$080E
TEXT_Character4Name: ; FlyingWigglr
    dw $085F,$0865,$0872,$0862,$0867,$0860,$0870,$0862,$0860,$0860,$0865,$086B
TEXT_Character5Name: ; Froggy
    dw $085F,$086B,$0868,$0860,$0860,$0872,$080E,$080E,$080E,$080E,$080E,$080E
TEXT_Character6Name: ; Blargg
    dw $085B,$0865,$085A,$086B,$0860,$0860,$080E,$080E,$080E,$080E,$080E,$080E
TEXT_Character7Name: ; Lunge Fish
    dw $0865,$086E,$0867,$0860,$085E,$080E,$085F,$0862,$086C,$0861,$080E,$080E
TEXT_Character8Name: ; Raphael
    dw $086B,$085A,$0869,$0861,$085A,$085E,$0865,$080E,$080E,$080E,$080E,$080E
TEXT_Character9Name: ; Hookbill
    dw $0861,$0868,$0868,$0864,$085B,$0862,$0865,$0865,$080E,$080E,$080E,$080E
TEXT_Character10Name: ; NavalPiranha
    dw $0867,$085A,$086F,$085A,$0865,$0869,$0862,$086B,$085A,$0867,$0861,$085A
TEXT_Character11Name: ; Kamek
    dw $0864,$085A,$0866,$085E,$0864,$080E,$080E,$080E,$080E,$080E,$080E,$080E
TEXT_Character12Name: ; Bowser
    dw $085B,$0868,$0870,$086C,$085E,$086B,$080E,$080E,$080E,$080E,$080E,$080E

CODE_NewVsCustomSave:
    REP #$30
    TDC
    STA.L WRAM_VsCompletedAStage
    STA.L WRAM_VsContinueCount
    ; TODO: Find out what this value does, comes from $7E943E
    SEP #$20
    LDA.B #$00
    STA.L $7ED202
    ;
    REP #$20
    JSL.L CODE_UpdateVsCharacterStates
    RTL