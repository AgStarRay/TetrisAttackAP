incsrc "Macros.asm"

;;;;;;;;;;;;
; Defines
;;;;;;;;;;;;
ErrorCode_NoSRAM = $0126
ErrorCode_SRAMChecksumFail = $0226
ErrorCode_AttemptedToStartFullyLockedRound = $0326

DeathlinkCode_StageClearNormalStage = $0001 ; {Player} topped out
DeathlinkCode_StageClearSpecialStage = $0002 ; {Player} couldn't keep things simple
DeathlinkCode_StageClearLastStage = $0003 ; {Player} couldn't do Chains and Combos
DeathlinkCode_PuzzleOutOfMoves = $0004 ; {Player} ran out of moves
DeathlinkCode_PuzzleTopOut = $0005 ; {Player} let the puzzle rise too high
DeathlinkCode_VsTopOutStage1 = $0010 ; {Player} lost to Lakitu
DeathlinkCode_VsTopOutStage2 = $0011 ; {Player} lost to Bumpty
DeathlinkCode_VsTopOutStage3 = $0012 ; {Player} lost to Poochy
DeathlinkCode_VsTopOutStage4 = $0013 ; {Player} lost to Flying Wiggler
DeathlinkCode_VsTopOutStage5 = $0014 ; {Player} lost to Froggy
DeathlinkCode_VsTopOutStage6 = $0015 ; {Player} lost to Gargantua Blargg
DeathlinkCode_VsTopOutStage7 = $0016 ; {Player} lost to Lunge Fish
DeathlinkCode_VsTopOutStage8 = $0017 ; {Player} lost to Raphael the Raven
DeathlinkCode_VsTopOutStage9 = $0018 ; {Player} lost to Hookbill the Koopa
DeathlinkCode_VsTopOutStage10 = $0019 ; {Player} lost to Naval Piranha
DeathlinkCode_VsTopOutStage11 = $001A ; {Player} lost to Kamek
DeathlinkCode_VsTopOutStage12 = $001B ; {Player} lost to Bowser
DeathlinkCode_VsDrawStage1 = $0020 ; {Player} topped out simultaneously with Lakitu
DeathlinkCode_VsDrawStage2 = $0021 ; {Player} topped out simultaneously with Bumpty
DeathlinkCode_VsDrawStage3 = $0022 ; {Player} topped out simultaneously with Poochy
DeathlinkCode_VsDrawStage4 = $0023 ; {Player} topped out simultaneously with Flying Wiggler
DeathlinkCode_VsDrawStage5 = $0024 ; {Player} topped out simultaneously with Froggy
DeathlinkCode_VsDrawStage6 = $0025 ; {Player} topped out simultaneously with Gargantua Blargg
DeathlinkCode_VsDrawStage7 = $0026 ; {Player} topped out simultaneously with Lunge Fish
DeathlinkCode_VsDrawStage8 = $0027 ; {Player} topped out simultaneously with Raphael the Raven
DeathlinkCode_VsDrawStage9 = $0028 ; {Player} topped out simultaneously with Hookbill the Koopa
DeathlinkCode_VsDrawStage10 = $0029 ; {Player} topped out simultaneously with Naval Piranha
DeathlinkCode_VsDrawStage11 = $002A ; {Player} topped out simultaneously with Kamek
DeathlinkCode_VsDrawStage12 = $002B ; {Player} topped out simultaneously with Bowser

; SRAM structure
; 0000-0001 = SRAM health check
; 0002-001B = local save data
; 001C-001F = checksum
; 0020-01FF = captured Archipelago received unlocks
; 0200-02FE = clear data to send to Archipelago
; 02FF-0300 = local save data
; 0301-03FF = redundant clear data to safeguard against crashes
; 0400-040F = SNI communication
; 0410-07FF = extra work RAM
; Care must be taken when writing to the 0002-03FF region, as the checksum should be recalculated
SRAM_ArmCrash = $700000
SRAM_StageClearScore_Lo = $700002
SRAM_StageClearScore_Hi = $700004
SRAM_BowserSavedDamage = $700006
SRAM_StageClearSpecialStageCompletions = $700008
; SRAM_??? = $700009
; SRAM_??? = $70000A
; SRAM_??? = $70000C
; SRAM_??? = $70000E
; SRAM_??? = $700010
; SRAM_??? = $700012
; SRAM_??? = $700014
; SRAM_??? = $700016
; SRAM_??? = $700018
; SRAM_??? = $70001A
SRAM_SaveChecksumComplement = $70001C
SRAM_SaveChecksum = $70001E
SRAM_UnlocksRegionStart = $700020
; 0 is the round gate, 1-5 are individual stage unlocks
SRAM_StageClearRound1Unlocks = $700020
SRAM_StageClearRound2Unlocks = $700026
SRAM_StageClearRound3Unlocks = $70002C
SRAM_StageClearRound4Unlocks = $700032
SRAM_StageClearRound5Unlocks = $700038
SRAM_StageClearRound6Unlocks = $70003E
SRAM_StageClearLastStageUnlock = $700044
SRAM_StageClearReceivedSpecialStages = $700045
SRAM_VersusStageUnlocks = $700046
SRAM_VersusCharacterUnlocks = $700052
SRAM_VersusMtWickednessGate = $70005A
; 0 is the level gate, 1-10 are individual puzzle unlocks
SRAM_PuzzleLevel1Unlocks = $700060
SRAM_PuzzleLevel2Unlocks = $70006B
SRAM_PuzzleLevel3Unlocks = $700076
SRAM_PuzzleLevel4Unlocks = $700081
SRAM_PuzzleLevel5Unlocks = $70008C
SRAM_PuzzleLevel6Unlocks = $700097
SRAM_PuzzleSecretLevel1Unlocks = $7000A2
SRAM_PuzzleSecretLevel2Unlocks = $7000AD
SRAM_PuzzleSecretLevel3Unlocks = $7000B8
SRAM_PuzzleSecretLevel4Unlocks = $7000C3
SRAM_PuzzleSecretLevel5Unlocks = $7000CE
SRAM_PuzzleSecretLevel6Unlocks = $7000D9
SRAM_PuzzlePanelUnlocks = $7000E4
SRAM_ShockPanelsReceived = $7000EA
;SRAM_??? = $7000EC
;SRAM_??? = $7000EE
SRAM_ScoreInstanceCounts = $700100
;SRAM_??? = $700126
SRAM_UnlocksRegionEnd = $700200
LOC_StageClearClearsStart = $700200
SRAM_StageClearRound1Clears = $700200
SRAM_StageClearRound2Clears = $700206
SRAM_StageClearRound3Clears = $70020C
SRAM_StageClearRound4Clears = $700212
SRAM_StageClearRound5Clears = $700218
SRAM_StageClearRound6Clears = $70021E
SRAM_StageClearLastStageClear = $700224
LOC_VersusClearsStart = $700225
SRAM_VersusStageClears = $700225
SRAM_VersusEasyNoContinueWin = $700231
SRAM_VersusNormalNoContinueWin = $700232
SRAM_VersusHardNoContinueWin = $700233
SRAM_VersusVHardNoContinueWin = $700234
SRAM_VersusAllFriendsNormal = $700235
;SRAM_??? = $700236
LOC_PuzzleClearsStart = $700259
SRAM_PuzzleLevel1Clears = $700259
SRAM_PuzzleLevel2Clears = $700264
SRAM_PuzzleLevel3Clears = $70026F
SRAM_PuzzleLevel4Clears = $70027A
SRAM_PuzzleLevel5Clears = $700285
SRAM_PuzzleLevel6Clears = $700290
SRAM_PuzzleSecretLevel1Clears = $70029B
SRAM_PuzzleSecretLevel2Clears = $7002A6
SRAM_PuzzleSecretLevel3Clears = $7002B1
SRAM_PuzzleSecretLevel4Clears = $7002BC
SRAM_PuzzleSecretLevel5Clears = $7002C7
SRAM_PuzzleSecretLevel6Clears = $7002D2
SRAM_ClearedShockPanels = $7002DD
; SRAM_??? = $7002DF
; A redundant copy of the clears at location + #$101
;   The game must write to both locations with the same value to be considered checks
;   Chose #$101 as it is a prime number and makes it less likely to falsely trigger from crashes
SRAM_StartOfWorkArea = $700400
; SNI
SNI_ReceivedItemNumber = $700400
SNI_ReceivedItemID = $700402
SNI_ReceivedItemActionCode = $700404
SNI_ReceivedItemArg = $700406
SNI_ReceiveCheck = $700408
SNI_DeathlinkTrigger = $70040C
SNI_DeathlinkPendingEvent = $70040E
; Random variables
SRAM_LastStageRevealFlag = $700710
SRAM_StageClearPendingUnlocksExist = $700712
SRAM_PuzzlePendingUnlocksExist = $700714
SRAM_SecretPuzzlePendingUnlocksExist = $700716
SRAM_GoingThroughPendingUnlocks = $700718
SRAM_PendingUnlocksCounted = $70071A
SRAM_PendingUnlocksPointer = $70071C
; Regions
SRAM_PendingUnlocks = $700500
SRAM_End = $700800

; WRAM - hopefully not affected by base game
WRAM_CheckComparisonTemp = $7EFF20
WRAM_PendingUnlockFramesLeft = $7EFF22
WRAM_LockSpriteValues = $7EFF24
WRAM_SCCurrentHealthBar = $7EFF4A
WRAM_SCPreviousHealthBar = $7EFF4C
WRAM_LoopCounter = $7EFF4E
WRAM_PuzzleFanfareIsRoundClear = $7EFF50
WRAM_PrintedSwitchMessage = $7EFF52
WRAM_TempMovA = $7EFF54
WRAM_TempMovB = $7EFF56
WRAM_CurrentlyPlaying = $7EFF58
WRAM_SNIFramesBeforePoll = $7EFF5A
WRAM_VsCompletedAStage = $7EFF5C
WRAM_ShockPanelCheckNumber = $7EFF60
WRAM_ShockPanelsToNextCheck = $7EFF62
WRAM_ShockPanelsInBoard = $7EFF64
WRAM_ErrorCode = $7EFFEC

;;;;;;;;;;;;
; Modifications
;;;;;;;;;;;;
incsrc "export/main.asm"

; Increase ROM space to 1.125 MB
padbyte $00
org $80FFD7
db $0B ; 2^11 KB
org $A08000 : pad $A18000
org $A18000 : pad $A28000
org $A28000 : pad $A38000
org $A38000 : pad $A48000

incsrc "Injections.asm"
incsrc "InjectionsStageClear.asm"
incsrc "InjectionsPuzzle.asm"
incsrc "InjectionsVersus.asm"


;;;;;;;;;;;;
; Bank A0 = locations, items, settings, text/dialogue, and sprites
;;;;;;;;;;;;
; 32 KB reserved for all location data, starting items, settings, hint strings, and graphics
; Stage Clear Goal Flags
;   -------l
;          l = Last Stage Clear
DATA8_GoalStageClear = $A08000
; Puzzle Goal Flags
;   -----esn
;        e = either clear is goal
;         s = Extra Puzzle Round 6 Clear
;          n = Puzzle Round 6 Clear
DATA8_GoalPuzzle = $A08001
; Versus Goal
;   ---crrdd
;      c = no continues clear required
;       rr = required stage for goal (0 = no goal, 1 = Naval Piranha, 2 = Kamek, 3 = Bowser)
;         dd = required difficulty level for goal
DATA8_GoalVersus = $A08002
; Stage Clear Flags
;   ---lopsi
;      l = Last Stage auto-unlock; after clearing round 6, unlock the Last Stage
;       o = oneshot mode; if you get a Game Over, you quit, or the console is reset, you are forced back to stage 1 of the round
;        p = progress is saved and lets the player start at the first uncleared stage
;            if oneshot mode is on, this takes effect only if the player cannot continue
;         s = Skippable mode, allows skipping over locked stages, but all 5 stages are still needed for a Round Clear
;          i = Incremental mode, lets the player start without all the stages
DATA8_StageClearFlags = $A08003
; Puzzle Flags
;   ----en-i
;       e = extra puzzle access
;        n = normal puzzle access
;          i = Incremental mode, lets the player start without all the puzzles
DATA8_PuzzleFlags = $A08004
; Versus Flags
;   -----fml
;        f = Friendship gate, all 8 characters have to be gathered before stages 9 to 12 are accessible
;            if not set, the Mt. Wickedness gate is required instead
;         m = multiple unlocks per stage, one for each difficulty; when unset, the stage only requires one unlock
;          l = difficulty cannot be selected, game locked to goal difficulty
DATA8_VersusFlags = $A08005
;TODO: Also add a WRAM value which the player can toggle
DATA8_DeathlinkHint = $A08006
DATA16_StageClearTotalChecks = $A08008
DATA16_PuzzleTotalChecks = $A0800A
DATA16_VersusTotalChecks = $A0800C
DATA8_ShockPanelChecks = $A0800E
DATA8_ShockPanelsPerCheck = $A08010
LOC_StageClearChecksStart = $A08020
; Checks are bitmasks, sum up all the 1's to get the total number of checks
; If the SRAM values are less than these, display the AP sprite
; Stage Clear round checks bitmask (0)
;   il----pr
;   i = indefinite checks
;    l = reserved bit for local clear save data
;         p = special stage; typically only round 3 has this
;          r = round clear check
; Stage Clear stage checks bitmask (1-5)
;   il----ps
;   i = indefinite checks
;    l = reserved bit for local clear save data
;         p = special stage; typically only 3-5 has this if round 3 doesn't
;          s = stage clear check
DATA8_StageClearRound1Checks = $A08020
DATA8_StageClearRound2Checks = $A08026
DATA8_StageClearRound3Checks = $A0802C
DATA8_StageClearRound4Checks = $A08032
DATA8_StageClearRound5Checks = $A08038
DATA8_StageClearRound6Checks = $A0803E
DATA8_StageClearLastStageChecks = $A08044
LOC_StageClearChecksEnd = $A08044
DATA8_StageClearSpecialStageCount = $A08045
LOC_VersusChecksStart = $A08046
; Versus stage checks bitmask (0-11)
;   ivhne-cs
;   i = indefinite checks
;    v = Very Hard clear, also used for local clear data
;     h = Hard clear, also used for local clear data
;      n = Normal clear, also used for local clear data
;       e = reserved bit for local clear data (Easy)
;         c = character unlock check, normally for stages 1 to 8
;          s = stage clear/Easy check, only used if multiple difficulties are not involved
DATA8_VersusStageChecks = $A08046
DATA8_VersusCharacterChecks = $A08052
LOC_VersusChecksEnd = $A08059
; Puzzle level checks bitmask (0)
;   il-----r
;   i = indefinite checks
;    l = locally cleared, used for save data
;          r = round clear check
; Puzzle stage checks bitmask (1-10)
;   il-----s
;   i = indefinite checks
;    l = locally cleared, used for save data
;          s = stage clear check
LOC_PuzzleChecksStart = $A08060
DATA8_PuzzleLevel1Checks = $A08060
DATA8_PuzzleLevel2Checks = $A0806B
DATA8_PuzzleLevel3Checks = $A08076
DATA8_PuzzleLevel4Checks = $A08081
DATA8_PuzzleLevel5Checks = $A0808C
DATA8_PuzzleLevel6Checks = $A08097
DATA8_PuzzleSecretLevel1Checks = $A080A2
DATA8_PuzzleSecretLevel2Checks = $A080AD
DATA8_PuzzleSecretLevel3Checks = $A080B8
DATA8_PuzzleSecretLevel4Checks = $A080C3
DATA8_PuzzleSecretLevel5Checks = $A080CE
DATA8_PuzzleSecretLevel6Checks = $A080D9
LOC_PuzzleChecksEnd = $A080E3
;DATA_??? = $A080E4
DATA8_InitialUnlocks = $A08120 ; The values in SRAM are bitwise OR'd with this data
DATA16_SCSpecialBowserHP = $A08300
DATA16_SCSpecialBowserHPStage1 = $A08302
DATA16_SCSpecialBowserHPStage2 = $A08304
DATA16_SCSpecialBowserHPStage3 = $A08306
DATA16_SCLastBowserHP = $A08308
DATA16_SCLastBowserHPStage1 = $A0830A
DATA16_SCLastBowserHPStage2 = $A0830C
DATA16_SCLastBowserHPStage3 = $A0830E
DATA16_SCSpecialBowserHealthBars = $A08310
DATA16_SCSpecialBowserHealthBarAmount = $A08312
DATA16_SCLastBowserHealthBars = $A08314
DATA16_SCLastBowserHealthBarAmount = $A08316
DATA16_SCLastBowserHealAmount = $A08318
DATA16_SCHPBarColors = $A0831A
DATA8_VsCustomLastStages = $A08330
DATA8_VsMinimumDifficulties = $A08334
;DATA16_??? = $A08340
org DATA16_SCSpecialBowserHP
dw 600
org DATA16_SCLastBowserHP
dw 600
org DATA16_SCSpecialBowserHealthBarAmount
dw 600
org DATA16_SCLastBowserHealthBarAmount
dw 600
org DATA16_SCLastBowserHealAmount
dw 10000
org DATA16_SCHPBarColors
dw $0434,$019F,$037B,$0380,$7FC0,$7CC0,$78EF,$781F,$7EFF,$7FFF,$4210
org DATA8_VsCustomLastStages
db $09,$0A,$0B,$0B
org DATA8_VsMinimumDifficulties
db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$02
;incsrc "testsave.asm"
org $A0F800
GFX_DebugGraphics:
incbin "debuggraphics.bin"
GFX_CustomMenuGraphics:
incbin "custommenugraphics.bin"

;;;;;;;;;;;;
; Bank A1 = AP menu and protocol code
;;;;;;;;;;;;
org $A18000

incsrc "CrashHandler.asm"

CODE_SRAMHealthCheck:
    PHP
    REP #$30
    PHA
    TDC
    STA.L SRAM_ArmCrash
    LDA.L WRAM_AntipiracyFlag
    BNE .WriteSuccessful
        LDA.W #ErrorCode_NoSRAM
        STA.L WRAM_ErrorCode
        BRK
    .WriteSuccessful:
    TDC
    STA.L WRAM_ErrorCode
    STA.L WRAM_AntipiracyFlag
    JSL.L CODE_SRAMValidation
    LDA.W #$0001
    STA.L SRAM_ArmCrash
    JSR.W SUB_InitializeSaveFile
    JSR.W SUB_ComputeSRAMChecksum
    CMP.L SRAM_SaveChecksum
    BEQ .GoodToGo
        PHA ; re-computed checksum
        LDA.L SRAM_SaveChecksum
        PHA ; saved checksum
        LDA.W #ErrorCode_SRAMChecksumFail
        STA.L WRAM_ErrorCode
        BRK
    .GoodToGo:
    TDC
    LDX.W #(SRAM_End-SRAM_StartOfWorkArea-2)
    CODE_ClearSRAMWorkArea:
        STA.L SRAM_StartOfWorkArea,X
        DEX
        DEX
    BPL CODE_ClearSRAMWorkArea
    LDA.W #$FFFF
    STA.L SNI_ReceivedItemNumber
    PLA
    PLP
    RTL

SUB_InitializeSaveFile:
    PHX
    !RunLength = SRAM_UnlocksRegionEnd-SRAM_UnlocksRegionStart
    print "SRAM region is ",dec(!RunLength)," bytes long, being copied at ",pc
    LDX.W #!RunLength-2
    .Loop:
        LDA.L DATA8_InitialUnlocks,X
        ORA.L SRAM_UnlocksRegionStart,X
        STA.L SRAM_UnlocksRegionStart,X
        DEX
        DEX
        BPL .Loop
    JSL.L CODE_SRAMSave
    PLX
    RTS

CODE_SRAMSave:
    print "SRAM save procedure at ",pc
    PHP
    REP #$30
    PHA
    TDC
    STA.L SRAM_SaveChecksum
    LDA.W #$FFFF
    STA.L SRAM_SaveChecksumComplement
    JSR.W SUB_ComputeSRAMChecksum
    STA.L SRAM_SaveChecksum
    EOR.W #$FFFF
    STA.L SRAM_SaveChecksumComplement
    PLA
    PLP
    RTL

CODE_SRAMValidation:
    print "SRAM valiation code at ",pc
    ;RTL ; Uncomment this to disable
    PHP
    REP #$30
    PHA
    PHX
    JSR.W SUB_ComputeSRAMChecksum
    PHA ; computed checksum
    CMP.L SRAM_SaveChecksum
    BNE CODE_DoSaveWipe
    SEC
    ADC.L SRAM_SaveChecksumComplement
    BEQ CODE_SkipSaveWipe
        CODE_DoSaveWipe:
        LDA.L SRAM_ArmCrash
        PHA
        TDC
        LDX.W #(SRAM_End-4)
        CODE_SaveWipeLoop:
            STA.L $700002,X
            DEX
            DEX
        BPL CODE_SaveWipeLoop
        JSL.L CODE_SRAMSave
        PLA
        BEQ CODE_DontCrash
            LDA.L SRAM_SaveChecksum
            PHA ; saved checksum
            LDA.W #ErrorCode_SRAMChecksumFail
            STA.L WRAM_ErrorCode
            BRK
        CODE_DontCrash:
    CODE_SkipSaveWipe:
    PLA
    PLX
    PLA
    PLP
    RTL

SUB_ComputeSRAMChecksum:
    TDC
    LDX.W #(SRAM_StartOfWorkArea-4)
    CODE_SRAMChecksum_KeepGoing:
        CLC
        ADC.L $700002,X
        DEX
        DEX
        BPL CODE_SRAMChecksum_KeepGoing
    RTS

CODE_StateMachineLogic:
    PHP
    PHK
    PLB
    REP #$30
    LDA.L WRAM_CurrentlyPlaying
    BEQ .GoToStateMachine
    LDA.W WRAM7E_GameState
    CMP.W #$0004
    BNE .SkipGameplayLogic
        LDA.L WRAM7E_PlayersIndicator
        BNE .EndShockPanelCheck
            LDA.W WRAM7E_ShockPanelCombo
            BEQ .EndShockPanelCheck
                JSR.W SUB_AddShockPanelClears
        .EndShockPanelCheck:
        JSL.L CODE_ScanIncomingArchipelagoItems
        LDA.L SNI_DeathlinkPendingEvent
        BEQ .GoToStateMachine
        LDA.W WRAM7E_CurrentlyPaused
        BNE .GoToStateMachine
        LDA.W WRAM7E_ShouldPause
        BNE .GoToStateMachine
            LDA.W #$0005
            STA.W WRAM7E_GameState
            LDA.W #$0001
            STA.W WRAM7E_ToppedOut
            DEC A
            STA.W WRAM7E_GameSubstate
            STA.W WRAM7E_AdvanceIngameTimer
            STA.L SNI_DeathlinkPendingEvent
        BRA .GoToStateMachine
    .SkipGameplayLogic:
    LDA.W WRAM7E_GameState
    CMP.W #$0005
    BNE .GoToStateMachine
        JSL.L CODE_ScanIncomingArchipelagoItems
    .GoToStateMachine:
    PEA.W $8000
    PLB
    PLB
    REP #$30
    PHP
    JML.L $80A703

SUB_AddShockPanelClears:
    CLC
    ADC.L SRAM_ClearedShockPanels
    BPL .PositiveTotal
        LDA.W #$7FFF
    .PositiveTotal:
    STA.L SRAM_ClearedShockPanels
    LDA.L WRAM_ShockPanelsInBoard
    SEC
    SBC.W WRAM7E_ShockPanelCombo
    STA.L WRAM_ShockPanelsInBoard
    STZ.W WRAM7E_ShockPanelCombo
    JSL.L CODE_SRAMValidation
    JSL.L CODE_SRAMSave
    RTS

CODE_TitleScreenCustomCode3:
    print "New title screen state 3 code at ",pc
    TDC
    STA.L WRAM_CurrentlyPlaying
    LDA.L $7E661A
    BEQ .End
    JSR.W SUB_TitleScreenAPWiggle
    LDA.B WRAM00_Pad1Press
    ORA.B WRAM00_Pad2Press
    BEQ .End
        ; Set next title screen action to immediately be Yoshi giving the peace sign
        TDC
        STA.L $7E6612
        LDA.W #$C905
        STA.L $7E6614
        %play_accept_sound()
        INC.W WRAM7E_GameSubstate
        LDA.W #$0002 ; Set to Stage Clear option because main menu cannot reset it anymore
        STA.L WRAM_1POptionIndex
    .End:
    RTL

CODE_TitleScreenCustomCode4:
    print "New title screen state 4 code at ",pc
    JSR.W SUB_TitleScreenAPWiggle
    LDA.L $7E662C
    BEQ .End
    INC.W $02A2
    .End:
    RTL

SUB_TitleScreenAPWiggle:
    ; TODO: Wiggle the * AP sprite up and down, 30 free sprite slots and 2 free sprite palettes
    RTS

CODE_MenuDataModification:
    STZ.W WRAM7E_BG1_HScroll
    STZ.W WRAM7E_BG1_VScroll
    STZ.W WRAM7E_BG2_HScroll
    STZ.W WRAM7E_BG2_VScroll
    STZ.W WRAM7E_BG3_HScroll
    STZ.W WRAM7E_BG3_VScroll
    LDA.W #$040E ; ' '
    STA.L $7EA87C
    STA.L $7EA87E
    STA.L $7EA880
    STA.L $7EA882
    STA.L $7EA884
    STA.L $7EA886
    STA.L $7EA888
    STA.L $7EA896
    STA.L $7EA898
    STA.L $7EA89A
    STA.L $7EA89C
    STA.L $7EA89E
    STA.L $7EA8A0
    STA.L $7EA8A2
    STA.L $7EA8A4
    STA.L $7EA8A6
    STA.L $7EA8A8
    STA.L $7EA8AA
    STA.L $7EA8AC
    STA.L $7EA8B4
    STA.L $7EA8B6
    STA.L $7EA8B8
    STA.L $7EA8BA
    STA.L $7EA8BE
    STA.L $7EA8C0
    STA.L $7EA8C2
    STA.L $7EA8C4
    STA.L $7EA8C6
    LDA.W #$047F ; '/'
    STA.L $7EA88A
    LDA.W #$440B ; Mirrored right edge
    STA.L $7EA894
    LDA.W #$040B ; Right edge
    STA.L $7EA8AE
    PHB
    PHK
    PLB
    LDY.W #DATA_CustomGraphicsVRAMDMA
    JSL.L CODE_CreateVRAMDMA
    PLB
    RTL
DATA_CustomGraphicsVRAMDMA:
    dl GFX_CustomMenuGraphics
    dw $0040
    db $80
    dw $0BB0
DATA_DebugGraphicsVRAMDMA:
    dl GFX_DebugGraphics
    dw $0400
    db $80
    dw $0000

CODE_NewMainMenuState2:
    print "New main menu state 2 routine at ",pc
    PHP
    PHA
    REP #$30
    LDA.W #$0001
    STA.L WRAM_CurrentlyPlaying
    STZ.W WRAM7E_PlayersIndicator
    LDA.W #$0008
    STA.W WRAM7E_GameSubstate
    STZ.W $1A6E
    PLA
    PLP
    RTL

CODE_NewMainMenuState8:
    INC.W WRAM7E_GameSubstate
    STZ.W WRAM7E_MenuProcedure
    STZ.W $1A70
    LDA.W #$FFFF
    STA.L SNI_ReceiveCheck
    LDA.W #1
    STA.L WRAM_SNIFramesBeforePoll
    TDC
    STA.L $7E952C
    STA.L $7E9532
    STA.L $7E9534
    STA.L $7E953A
    RTL

CODE_NewMainMenuState9:
    print "New main menu state 9 routine at ",pc
    ; TODO_AFTER: Disallow access to modes that are not included
    ; Debug button press
    LDA.L WRAM7E_Pad1Press
    BIT.W #$4040
    BEQ .SkipSpecialCheck
        ; TODO: Display control for the Hint screen after one is obtained
        ; TODO: Take control of the Hint screen
        ; TODO: Make this instance of the Hint screen go back to the main menu
        ;LDA.W #$0017
        ;STA.W WRAM7E_GameState
        ;TDC
        ;STA.W WRAM7E_GameSubstate
        ;TDC
        ;STA.W WRAM_VsMenuSubstate
    .SkipSpecialCheck:

    JSL.L CODE_ScanIncomingArchipelagoItems
    LDA.L WRAM_1POptionIndex
    STA.L WRAM_ModeIndex
    CLC
    ADC.W #$0006
    JSL.L CODE_MenuYoshiDialog_JSR
    LDA.W #$0001
    STA.L $7E96DB

    ; Modified menu selection code
    LDA.L WRAM_MenuPadRepeat
    BIT.W #$0800
    BEQ .DidNotPressUp
        LDA.L WRAM_1POptionIndex
        CMP.W #$0002
        BEQ .AtTheTop
            DEC A
            STA.L WRAM_1POptionIndex
            JMP.W .CursorMoved
        .AtTheTop:
            LDA.W #$0004
            STA.L WRAM_1POptionIndex
            JMP.W .CursorMoved
    .DidNotPressUp:
    BIT.W #$2400 ; Select is also Down
    BEQ .DidNotPressDown
        LDA.L WRAM_1POptionIndex
        CMP.W #$0004
        BEQ .AtTheBottom
            INC A
            STA.L WRAM_1POptionIndex
            JMP.W .CursorMoved
        .AtTheBottom:
            LDA.W #$0002
            STA.L WRAM_1POptionIndex
            JMP.W .CursorMoved
    .DidNotPressDown:
    LDA.L WRAM_MenuPadPress
    BIT.W #$1080 ; Start is also A
    BNE .PressedA
    JMP.W .DidNotPressA
    .PressedA:
        LDA.L WRAM_1POptionIndex
        CMP.W #$0004
        BNE .Proceed
        LDA.L DATA8_VersusFlags
        BIT.W #%001
        BEQ .Proceed
        %load_goal_difficulty()
        STA.W WRAM7E_VsDifficulty
        JSL.L CODE_VsStageIsAvailable
        BPL .Proceed
            %play_cancel_sound()
            BRA .CursorDidNotMove
        .Proceed:
            %play_accept_sound()
            JSL.L CODE_8384DB_JSR
            LDA.L WRAM_1POptionIndex
            TAY
            LDA.W DATA_1PlayerNewStates,Y
            AND.W #$00FF
            STA.W WRAM7E_GameSubstate
            BRA .CursorDidNotMove
    .DidNotPressA:
    BIT.W #$8000
    BEQ .DidNotPressB
        %play_cancel_sound()
        JSL.L CODE_8384DB_JSR
        LDA.W #$0004
        STA.W WRAM7E_GameSubstate
    .DidNotPressB:
    .CursorDidNotMove:
        TDC
        BRA .EndSelection
    .CursorMoved:
        JSL.L CODE_8384DB_JSR
        %play_cursor_sound()
        TDC
        STA.L $7E99D1
        LDA.W #$0001
    .EndSelection:
    STA.L $7E96FD

    LDA.L WRAM_1POptionIndex
    LDX.W #$0038
    LDY.W #$0053
    JSL.L CODE_8397A1_JSR
    LDA.L $7E96FD
    BEQ .End
        STZ.W $1A70
    .End:

    JSL.L CODE_VsSelection
    LDA.L WRAM_1POptionIndex
    CMP.W #$0002
    BNE .NotSC
        JSR.W SUB_DisplaySCTracker
        BRA .RenderBG1
    .NotSC:
    CMP.W #$0003
    BNE .NotPZ
        JSR.W SUB_DisplayPZTracker
        BRA .RenderBG1
    .NotPZ:
    JSR.W SUB_DisplayVSTracker
    .RenderBG1:
    JSR.W SUB_PrintSNIState
    JSR.W SUB_RenderCustomMenuBG1
    RTL

SUB_PrintSNIState:
    LDA.L SNI_ReceivedItemNumber
    CMP.L SNI_ReceiveCheck
    BEQ .Connected
    INC A
    CMP.L SNI_ReceiveCheck
    BEQ .Connecting
    LDA.B WRAM7E_GameFrames
    CMP.W #30
    BMI .Odd
        LDA.W #$001B
        LDX.W #DATA16_SNIStateOffline1
        BRA .Print
    .Odd:
        LDA.W #$001B
        LDX.W #DATA16_SNIStateOffline2
        BRA .Print
    .Connecting:
        LDA.W #$001B
        LDX.W #DATA16_SNIStateConnecting
        BRA .Print
    .Connected:
        LDA.L SNI_ReceivedItemNumber
        JSL.L CODE_16BitHexToDec
        LDA.W $0374
        ORA.W #$0450
        STA.L $7E2558
        LDA.W $0376
        ORA.W #$0450
        STA.L $7E255A
        LDA.W $0378
        ORA.W #$0450
        STA.L $7E255C
        LDA.W #$0015
        LDX.W #DATA16_SNIStateConnected
    .Print:
    LDY.W #$2542
    MVN $7E,bank(DATA16_SCTrackerLine2)
    RTS
DATA16_SNIStateConnecting:
    dw $0C5C,$0C68,$0C67,$0C67,$0C5E,$0C5C,$0C6D,$0C62,$0C67,$0C60,$0C46,$0C0E,$0C0E,$0C0E ; 'CONNECTING…   '
DATA16_SNIStateConnected:
    dw $145C,$1468,$1467,$1467,$145E,$145C,$146D,$145E,$145D,$1477,$140E ; 'CONNECTED! '
DATA16_SNIStateOffline1:
    dw $086C,$0867,$0862,$080E,$086D,$0862,$0866,$085E,$0868,$086E,$086D,$0877,$0877,$080E ; 'SNI TIMEOUT!! '
DATA16_SNIStateOffline2:
    dw $106C,$1067,$1062,$100E,$106D,$1062,$1066,$105E,$1068,$106E,$106D,$1077,$1077,$100E ; purple version

SUB_RenderCustomMenuBG1:
    PHB
    PHK
    PLB
    LDY.W #DATA_CustomMenuBG1VRAMDMA
    JSL.L CODE_CreateVRAMDMA
    PLB
    RTS
DATA_CustomMenuBG1VRAMDMA:
    dl $7E2280 ; Src
    dw $0480 ; Size
    db $80 ; Control
    dw $6940 ; Dst

CODE_NewMainMenuState21:
    ;JSL.L CODE_AddCustomGraphics
    LDA.W #$0009
    STA.W WRAM7E_GameSubstate
    STZ.W WRAM7E_MenuProcedure
    STZ.W $1A70
    RTL

GFX_LockSprite = $30BB
GFX_LockSpriteHighlighted = $3CBB
GFX_APSprite = $36BC
GFX_StageClearSprite = $3CCB

incsrc "StageClearMenu.asm"
incsrc "PuzzleMenu.asm"
incsrc "VersusMenu.asm"

CODE_CountCompletedChecks:
    .Loop:
    LDX.B $00
    LDA.L $A00000,X
    AND.W #$00FF
    STA.B $08
    LDX.B $02
    LDA.L $700000,X
    AND.B $08
    STA.B $08
    LDA.L $700101,X
    AND.B $08
    TAX
    LDA.L DATA8_BitmaskToBitCount,X
    AND.W #$00FF
    CLC
    ADC.B $06
    STA.B $06
    INC.B $00
    INC.B $02
    DEC.B $04
    BNE .Loop
    RTL

CODE_ScanIncomingArchipelagoItems:
    print "Archipelago SNI scanning is at ",pc
    PHP
    REP #$30
    LDA.L SNI_ReceivedItemNumber
    BMI .NoNewItems
    LDA.L SNI_ReceiveCheck
    BMI .NewItems
    LDA.L SNI_ReceivedItemNumber
    CMP.L SNI_ReceiveCheck
    BCC .NoNewItems
    BEQ .NoNewItems
    .NewItems:
        JSL.L CODE_SRAMValidation
        ; Respond based on the action code
        LDA.L SNI_ReceivedItemActionCode
        ASL A
        TAX
        JSR.W (PTR16_ArchipelagoActions,X)
        ; Get ready for the next item
        LDA.L SNI_ReceivedItemNumber
        STA.L SNI_ReceiveCheck
        ; We've validated SNI is operational
        LDA.L #300
        STA.L WRAM_SNIFramesBeforePoll
        ; Set action code to zero to avoid syncing problems
        TDC
        STA.L SNI_ReceivedItemActionCode
        ; Save the new checksum
        JSL.L CODE_SRAMSave
        PLP
        RTL
    .NoNewItems:
        LDA.L WRAM_SNIFramesBeforePoll
        DEC A
        BNE .WaitingOnSNI
            print "Receive check at ",pc
            LDA.L SNI_ReceivedItemNumber
            CMP.W #$8000
            BEQ .DontUpdate
                DEC A
                STA.L SNI_ReceivedItemNumber
            .DontUpdate:
            LDA.W #300
        .WaitingOnSNI:
        STA.L WRAM_SNIFramesBeforePoll
        PLP
        RTL
PTR16_ArchipelagoActions:
    dw SUB_ArchipelagoDoNothing
    dw SUB_ArchipelagoWriteValue
    dw SUB_ArchipelagoWriteReceivedItem
    dw SUB_ArchipelagoGrantedLastStage
    dw SUB_ArchipelagoORValue
    dw SUB_ArchipelagoMarkComplete
    dw SUB_ArchipelagoWriteReceivedCharacter
    dw SUB_ArchipelagoAddScore
    dw SUB_ArchipelagoMarkWon
SUB_ArchipelagoDoNothing:
    RTS
; Action Code 0003: play sound effect, set ID to arg, and prepare the reveal
SUB_ArchipelagoGrantedLastStage:
    LDA.W #$0001
    STA.L SRAM_LastStageRevealFlag ; TODO: Use this flag to do a custom reveal
    LDA.W #$00F7
    STA.L WRAM7E_NewSoundEvent
    BRA SUB_ArchipelagoWriteValue
; Action Code 0002: play sound effect and set ID to arg
SUB_ArchipelagoWriteReceivedItem:
    LDA.W WRAM7E_GameState
    CMP.W #$0003
    BCC .MenuPopSound
        LDA.W #$0005
        BRA .PlaySound
    .MenuPopSound:
        LDA.W #$0021
    .PlaySound:
    STA.L WRAM7E_NewSoundEvent
; Action Code 0001: set ID to arg
SUB_ArchipelagoWriteValue:
    LDA.L SNI_ReceivedItemID
    TAX
    SEP #$20
    LDA.L SNI_ReceivedItemArg
    STA.L $700000,X
    REP #$20
    RTS
; Action Code 0004: ORwise set ID to arg in two places
SUB_ArchipelagoORValue:
    LDA.L SNI_ReceivedItemID
    TAX
    SEP #$20
    LDA.L $700000,X
    ORA.L SNI_ReceivedItemArg
    STA.L $700000,X
    STA.L $700101,X
    REP #$20
    RTS
; Action Code 0005: ORwise set ID to arg in two places and play sound
SUB_ArchipelagoMarkComplete:
    LDA.W #$00F6
    STA.L WRAM7E_NewSoundEvent
    BRA SUB_ArchipelagoORValue
; Action Code 0006: play unique sound effect and set ID to arg
SUB_ArchipelagoWriteReceivedCharacter:
    print "Receive character code at ",pc
    LDA.W #$004C
    STA.L WRAM7E_NewSoundEvent
    LDA.W WRAM7E_GameState
    CMP.W #$0007
    BNE .NotInVs
        LDA.L SNI_ReceivedItemID
        SEC
        SBC.W #SRAM_VersusCharacterUnlocks
        STA.L $7ED39F
        TAX
        SEP #$20
        LDA.B #$02
        STA.L WRAM_VsLakituState,X
        REP #$20
        JSL.L CODE_ShowImFreeMsg
    .NotInVs:
    BRA SUB_ArchipelagoWriteValue
; Action Code 0007: add chain or combo score
SUB_ArchipelagoAddScore:
    LDA.W WRAM7E_Score_Lo
    STA.W WRAM7E_CheckpointScore_Lo
    LDA.W WRAM7E_Score_Hi
    STA.W WRAM7E_CheckpointScore_Hi
    LDA.L SRAM_StageClearScore_Lo
    STA.W WRAM7E_Score_Lo
    LDA.L SRAM_StageClearScore_Hi
    STA.W WRAM7E_Score_Hi
    LDA.L SNI_ReceivedItemID
    CMP.W #$010C
    BCS .ComboScoring
        LDA.W #$0041
        STA.L WRAM7E_NewSoundEvent
        LDA.L SNI_ReceivedItemID
        SEC
        SBC.W #$00FF
        PHA
        JSL.L CODE_82E2D6_JSR
        LDA.W WRAM7E_Score_Lo
        STA.L SRAM_StageClearScore_Lo
        LDA.W WRAM7E_Score_Hi
        STA.L SRAM_StageClearScore_Hi
        LDA.W WRAM7E_CheckpointScore_Lo
        STA.W WRAM7E_Score_Lo
        LDA.W WRAM7E_CheckpointScore_Hi
        STA.W WRAM7E_Score_Hi
        PLA
        JSL.L CODE_82E2D6_JSR
        BRA .End
    .ComboScoring:
        LDA.W #$002B
        STA.L WRAM7E_NewSoundEvent
        LDA.L SNI_ReceivedItemID
        SEC
        SBC.W #$0108
        PHA
        JSL.L CODE_82E1AF_JSR
        LDA.W WRAM7E_Score_Lo
        STA.L SRAM_StageClearScore_Lo
        LDA.W WRAM7E_Score_Hi
        STA.L SRAM_StageClearScore_Hi
        LDA.W WRAM7E_CheckpointScore_Lo
        STA.W WRAM7E_Score_Lo
        LDA.W WRAM7E_CheckpointScore_Hi
        STA.W WRAM7E_Score_Hi
        PLA
        JSL.L CODE_82E1AF_JSR
    .End:
    BRL SUB_ArchipelagoWriteValue
; Action Code 0008: ORwise set ID to arg in two places and play unique sound
SUB_ArchipelagoMarkWon:
    LDA.W #$0013
    STA.L WRAM7E_NewSoundEvent
    BRL SUB_ArchipelagoORValue

DATA8_BitmaskToBitCount:
    db $00,$01,$01,$02,$01,$02,$02,$03
    db $01,$02,$02,$03,$02,$03,$03,$04
    db $01,$02,$02,$03,$02,$03,$03,$04
    db $02,$03,$03,$04,$03,$04,$04,$05
    db $01,$02,$02,$03,$02,$03,$03,$04
    db $02,$03,$03,$04,$03,$04,$04,$05
    db $02,$03,$03,$04,$03,$04,$04,$05
    db $03,$04,$04,$05,$04,$05,$05,$06

    db $01,$02,$02,$03,$02,$03,$03,$04
    db $02,$03,$03,$04,$03,$04,$04,$05
    db $02,$03,$03,$04,$03,$04,$04,$05
    db $03,$04,$04,$05,$04,$05,$05,$06
    db $02,$03,$03,$04,$03,$04,$04,$05
    db $03,$04,$04,$05,$04,$05,$05,$06
    db $03,$04,$04,$05,$04,$05,$05,$06
    db $04,$05,$05,$06,$05,$06,$06,$07


;;;;;;;;;;;;
; Bank A2 = Gameplay injected subroutines
;;;;;;;;;;;;
org $A28000

incsrc "StageClear.asm"
incsrc "Puzzle.asm"
incsrc "Versus.asm"

CODE_OnStackCreated:
    TDC
    STA.L WRAM_ShockPanelsInBoard
    JSL.L CODE_UpdateStackTilemap
    RTL

CODE_NewShockPanelLogic:
    print "Shock panel generation code at ",pc
    LDA.L WRAM_ModeIndex
    CMP.W #$0002
    BEQ .StageClear
    CMP.W #$0003
    BEQ .Puzzle
    LDA.W WRAM7E_PlayersIndicator
    BNE .Versus
    .Endless:
        TDC ; Disable shock panels
        RTL
    .StageClear:
        LDA.L WRAM7E_StageClearSpecialIndex
        BNE .SpecialStage
        .NormalStage:
            ; TODO: Implement algorithm for incrementing pending shock panels
            ; Enable shock panel generation if the remaining number of panels is greater than the number in the board minus 2
            LDA.L SRAM_ShockPanelsReceived
            DEC A
            SEC
            SBC.L SRAM_ClearedShockPanels
            BMI .NoMorePanels
            SEC
            SBC.L WRAM_ShockPanelsInBoard
            INC A
            INC A
            BMI .NoMorePanels
                ; Shift right 4 times
                ; This means if there are 0-46 panels remaining, level 1 shock panel generation is used
                ; If there are more than 46 panels remaining, level 2 shock panel generation is used
                LSR A
                LSR A
                LSR A
                LSR A
                INC A
                STA.W WRAM7E_P1PendingShockPanels
                LDA.W #$0004 ; Enable shock panels
                RTL
        .SpecialStage:
        .NoMorePanels:
            TDC ; Disable shock panels
            RTL
    .Puzzle:
        TDC ; Disable shock panels
        RTL
    .Versus:
        ; Pending shock panels controlled by vanilla Versus
        LDA.W #$0004 ; Enable shock panels
        RTL

CODE_OnShockPanelCreated:
    print "On shock panel created at ",pc
    LDA.W WRAM7E_PlayersIndicator
    BNE .Vs
    .Solo:
        LDA.L WRAM_ShockPanelsInBoard
        INC A
        STA.L WRAM_ShockPanelsInBoard
        RTL
    .Vs:
        LDA.W $0354
        BNE .P2
        .P1:
            LDA.W WRAM82_P1PendingShockPanels
            BEQ +
                DEC.W WRAM82_P1PendingShockPanels
          + RTL
        .P2:
            LDA.W WRAM82_P2PendingShockPanels
            BEQ +
                DEC.W WRAM82_P2PendingShockPanels
          + RTL

CODE_CustomLevelDisplay:
    LDA.L DATA8_ShockPanelChecks
    BEQ .LevelDisplay
    LDA.L WRAM_ModeIndex
    BEQ .ArchipelagoDisplay
    LDA.W WRAM7E_StageClearSpecialIndex
    BEQ .ArchipelagoDisplay
    .LevelDisplay:
        ; Display Level
        TDC
        STA.L $7E22F4
        JML.L $8297E6
    .ArchipelagoDisplay:
        ; Display Archipelago values
        TDC
        STA.L $7E22F0
        STA.L $7E22F2
        STA.L $7E22F4
        STA.L $7E22F6
        STA.L $7E2330
        STA.L $7E2332
        STA.L $7E2334
        STA.L $7E2336
        STA.L $7E2370
        STA.L $7E2372
        STA.L $7E2374
        STA.L $7E2376
        STA.L $7E2378
        STA.L $7E237A
        STA.L $7E23B0
        STA.L $7E23B2
        STA.L $7E23B4
        STA.L $7E23B6
        STA.L $7E23B8
        STA.L $7E23BA
        LDA.L DATA8_ShockPanelChecks
        BNE .ShockPanelStats
        .NoShockPanelStats:
            TDC
            STA.L $7E23F0
            STA.L $7E23F2
            STA.L $7E23F4
            STA.L $7E23F6
            STA.L $7E23F8
            STA.L $7E23FA
            STA.L $7E2430
            STA.L $7E2432
            STA.L $7E2434
            STA.L $7E2436
            STA.L $7E2438
            STA.L $7E243A
            RTL
        .ShockPanelStats:
            print "Shock panel stats display at ",pc
            JSR.W SUB_UpdateShockPanelsToNextCheck
            LDA.L DATA8_ShockPanelsPerCheck
            CMP.W #$0005
            BCC .Usable
                LDA.W #$0005
            .Usable:
            ASL A
            TAX
            JSR.W (PTR16_RenderShockPanelStats,X)
            RTL
SUB_UpdateShockPanelsToNextCheck:
    LDA.L WRAM_ShockPanelCheckNumber
    CMP.L DATA8_ShockPanelChecks
    BCC .Proceed
        RTS
    .Proceed:
    ; Update if ShockPanelsToNextCheck is less than or equal to the total cleared
    LDA.L WRAM_ShockPanelsToNextCheck
    CMP.L SRAM_ClearedShockPanels
    BCC .Update
    BEQ .Update
        RTS
    .Update:
        CLC
        ADC.L DATA8_ShockPanelsPerCheck
        STA.L WRAM_ShockPanelsToNextCheck
        LDA.L WRAM_ShockPanelCheckNumber
        INC A
        STA.L WRAM_ShockPanelCheckNumber
        BRA SUB_UpdateShockPanelsToNextCheck

PTR16_RenderShockPanelStats:
    dw SUB_RenderShockPanelStats1Per
    dw SUB_RenderShockPanelStats1Per
    dw SUB_RenderShockPanelStats5AndUp
    dw SUB_RenderShockPanelStats5AndUp
    dw SUB_RenderShockPanelStats5AndUp
    dw SUB_RenderShockPanelStats5AndUp
SUB_RenderShockPanelStats1Per:
    TDC
    STA.L $7E23F4
    STA.L $7E2434
    LDA.L WRAM_ShockPanelsToNextCheck
    SEC
    SBC.L SRAM_ClearedShockPanels
    BMI .ToGoIsNonPositive
    BEQ .ToGoIsNonPositive
    .ToGoIsPositive:
        ; Blue shock panel
        LDA.W #$0D78
        STA.L $7E23F0
        LDA.W #$0D6A
        STA.L $7E23F2
        LDA.W #$0D79
        STA.L $7E2430
        LDA.W #$0D7A
        STA.L $7E2432
        JMP.W SUB_DisplayShockPanelsRemainingBig
    .ToGoIsNonPositive:
        ; Gray shock panel
        LDA.W #$0178
        STA.L $7E23F0
        LDA.W #$016A
        STA.L $7E23F2
        LDA.W #$0179
        STA.L $7E2430
        LDA.W #$017A
        STA.L $7E2432
        JMP.W SUB_DisplayShockPanelsRemainingBig
CODE_RenderShockPanelStats2Per:
    ; TODO_AFTER: When panels per check is 2, change to be one big pink number and have the shock panel become half gray
    TDC
    STA.L $7E23F4
    STA.L $7E2434
    LDA.L WRAM_ShockPanelsToNextCheck
    SEC
    SBC.L SRAM_ClearedShockPanels
    BMI .ToGoIsNonPositive
    BEQ .ToGoIsNonPositive
    .ToGoIsPositive:
        ; Blue shock panel
        LDA.W #$0D78
        STA.L $7E23F0
        LDA.W #$0D6A
        STA.L $7E23F2
        LDA.W #$0D79
        STA.L $7E2430
        LDA.W #$0D7A
        STA.L $7E2432
        JMP.W SUB_DisplayShockPanelsRemainingBig
    .ToGoIsNonPositive:
        ; Gray shock panel
        LDA.W #$0178
        STA.L $7E23F0
        LDA.W #$016A
        STA.L $7E23F2
        LDA.W #$0179
        STA.L $7E2430
        LDA.W #$017A
        STA.L $7E2432
        JMP.W SUB_DisplayShockPanelsRemainingBig
SUB_RenderShockPanelStats3Per:
    ; TODO_AFTER: When panels per check is 3, change to be a pink number and a blue bar that turns gray
    JSR.W SUB_DisplayShockPanelsRemainingSmall
    RTS
SUB_RenderShockPanelStats4Per:
    ; TODO_AFTER: When panels per check is 4, change to be one big pink number and have the shock panel chip gray
    JSR.W SUB_DisplayShockPanelsRemainingBig
    RTS
SUB_RenderShockPanelStats5AndUp:
    TDC
    STA.L $7E23F4
    STA.L $7E23F6
    LDA.L WRAM_ShockPanelsToNextCheck
    SEC
    SBC.L SRAM_ClearedShockPanels
    BMI .ToGoIsNonPositive
    BEQ .ToGoIsNonPositive
    .ToGoIsPositive:
        PHA
        ; Blue shock panel
        LDA.W #$0D78
        STA.L $7E23F0
        LDA.W #$0D6A
        STA.L $7E23F2
        LDA.W #$0D79
        STA.L $7E2430
        LDA.W #$0D7A
        STA.L $7E2432
        PLA
        JSL.L CODE_16BitHexToDec
        LDA.W $0376
        BEQ .LessThan10
            ORA.W #$0C30
            BRA .Place10
        .LessThan10:
            TDC
        .Place10:
        STA.L $7E23F8
        LDA.W $0378
        ORA.W #$0C30
        STA.L $7E23FA
        JSR.W SUB_DisplayShockPanelsRemainingSmall
        RTS
    .ToGoIsNonPositive:
        ; Gray shock panel
        LDA.W #$0178
        STA.L $7E23F0
        LDA.W #$016A
        STA.L $7E23F2
        LDA.W #$0179
        STA.L $7E2430
        LDA.W #$017A
        STA.L $7E2432
        TDC
        STA.L $7E23F8
        STA.L $7E23FA
        JSR.W SUB_DisplayShockPanelsRemainingSmall
        RTS
SUB_DisplayShockPanelsRemainingBig:
    print "Remaining shock panels big display at ",pc
    LDA.L SRAM_ShockPanelsReceived
    SEC
    SBC.L SRAM_ClearedShockPanels
    BEQ .RemainingIsZero
    BPL .RemainingIsPositive
    .RemainingIsNegative:
        EOR.W #$FFFF
        INC A
        ORA.W #$0010
        STA.L $7E23FA
        CLC
        ADC.W #$0010
        STA.L $7E243A
        LDA.W #$00BF ; '-'
        STA.L $7E23F8
        TDC
        STA.L $7E2438
        STA.L $7E23F6
        STA.L $7E2436
        RTS
    .RemainingIsZero:
        LDA.W #$0010 ; '0'
        STA.L $7E23FA
        LDA.W #$0020 ; '0'
        STA.L $7E243A
        TDC
        STA.L $7E23F8
        STA.L $7E2438
        STA.L $7E23F6
        STA.L $7E2436
        RTS
    .RemainingIsPositive:
    CMP.W #$000A
    BCC .LessThan10Remaining
        JSL.L CODE_16BitHexToDec
        CLC ; only needed once
        LDA.W $0378
        ORA.W #$1010
        STA.L $7E23FA
        ADC.W #$0010
        STA.L $7E243A
        LDA.W $0376
        ORA.W #$1010
        STA.L $7E23F8
        ADC.W #$0010
        STA.L $7E2438
        LDA.W $0374
        BEQ .No100
        ORA.W #$1010
        STA.L $7E23F6
        ADC.W #$0010
        STA.L $7E2436
        RTS
        .No100:
        TDC
        STA.L $7E23F6
        STA.L $7E2436
        RTS
    .LessThan10Remaining:
        CMP.L WRAM_ShockPanelsInBoard
        BCS .StillNeedToSpawnMore
        .AllPanelsPresent:
            STA.B $00
            LDA.W WRAM7E_GameFrames
            AND.W #$0010
            XBA
            ORA.W #$0010
            CLC
            ADC.B $00
            BRA .PutDigit
        .StillNeedToSpawnMore:
            ORA.W #$1010
        .PutDigit:
        STA.L $7E23FA
        CLC
        ADC.W #$0010
        STA.L $7E243A
        TDC
        STA.L $7E23F8
        STA.L $7E2438
        STA.L $7E23F6
        STA.L $7E2436
        RTS
SUB_DisplayShockPanelsRemainingSmall:
    print "Remaining shock panels small display at ",pc
    VAR_1sDigit = $7E243A
    VAR_10sDigit = $7E2438
    VAR_100sDigit = $7E2436
    VAR_1000sDigit = $7E2434
    LDA.L SRAM_ShockPanelsReceived
    SEC
    SBC.L SRAM_ClearedShockPanels
    BEQ .RemainingIsZero
    BPL .RemainingIsPositive
    .RemainingIsNegative:
        EOR.W #$FFFF
        INC A
        ORA.W #$0030
        STA.L VAR_1sDigit
        LDA.W #$00BF ; '-'
        STA.L VAR_10sDigit
        TDC
        STA.L VAR_100sDigit
        STA.L VAR_1000sDigit
        RTS
    .RemainingIsZero:
        LDA.W #$0030 ; '0'
        STA.L VAR_1sDigit
        TDC
        STA.L VAR_10sDigit
        STA.L VAR_100sDigit
        STA.L VAR_1000sDigit
        RTS
    .RemainingIsPositive:
    CMP.W #$000A
    BCC .LessThan10Remaining
        JSL.L CODE_16BitHexToDec
        LDA.W $0378
        ORA.W #$1030
        STA.L VAR_1sDigit
        LDA.W $0376
        ORA.W #$1030
        STA.L VAR_10sDigit
        LDA.W $0374
        BEQ .No100
        ORA.W #$1030
        STA.L VAR_100sDigit
        LDA.W $0372
        BEQ .No1000
        ORA.W #$1030
        STA.L VAR_1000sDigit
        RTS
        .No100:
        TDC
        STA.L VAR_100sDigit
        STA.L VAR_1000sDigit
        RTS
        .No1000:
        TDC
        STA.L VAR_1000sDigit
        RTS
    .LessThan10Remaining:
        CMP.L WRAM_ShockPanelsInBoard
        BCS .StillNeedToSpawnMore
        .AllPanelsPresent:
            STA.B $00
            LDA.W WRAM7E_GameFrames
            INC A
            INC A
            AND.W #$0010
            XBA
            ORA.W #$0030
            CLC
            ADC.B $00
            BRA .PutDigit
        .StillNeedToSpawnMore:
            ORA.W #$1030
        .PutDigit:
        STA.L VAR_1sDigit
        TDC
        STA.L VAR_10sDigit
        STA.L VAR_100sDigit
        STA.L VAR_1000sDigit
        RTS

;;;;;;;;;;;;
; Bank A3 = miscellaneous
;;;;;;;;;;;;
org $A38000

; TODO_AFTER: Include Panel de Pon content
