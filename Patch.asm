;TODO_AFTER: Use more macros to lower duplicate sequences of instructions

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

; SRAM structure
; 0000-0001 = SRAM health check
; 0002-003F = local save data
; 0040-0043 = checksum
; 0044-01FF = captured Archipelago received unlocks
; 0200-02FE = clear data to send to Archipelago
; 02FF-0300 = local save data
; 0301-03FF = redundant clear data to safeguard against crashes
; 0400-040F = SNI communication
; 0410-07FF = extra work RAM
; Care must be taken when writing to the 0002-03FF region, as the checksum should be recalculated


SRAM_ArmCrash = $700000
SRAM_StageClearScore_Lo = $700002
SRAM_StageClearScore_Hi = $700004
; SRAM_??? = $700006
SRAM_StageClearSpecialStageCompletions = $700008
SRAM_StageClearBowserDamage = $700009
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
SRAM_VersusCharacterUnlocks = $700052 ; bitmask
SRAM_VersusMtWickednessGate = $700053
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
SRAM_ScoreInstanceCounts = $700100
;SRAM_??? = $700120
SRAM_UnlocksRegionEnd = $700200
SRAM_StageClearRound1Clears = $700200
SRAM_StageClearRound2Clears = $700206
SRAM_StageClearRound3Clears = $70020C
SRAM_StageClearRound4Clears = $700212
SRAM_StageClearRound5Clears = $700218
SRAM_StageClearRound6Clears = $70021E
SRAM_StageClearLastStageClear = $700224
SRAM_VersusStageEasyClears = $700225
SRAM_VersusStageNormalClears = $700231
SRAM_VersusStageHardClears = $70023D
SRAM_VersusStageVHardClears = $700249
SRAM_VersusEasyNoContinueWin = $700255
SRAM_VersusNormalNoContinueWin = $700256
SRAM_VersusHardNoContinueWin = $700257
SRAM_VersusVHardNoContinueWin = $700258
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
; SRAM_??? = $7002DD
; A redundant copy of the clears at location + #$101
;   The game must write to both locations with the same value to be considered checks
;   Chose #$101 as it is a prime number and makes it less likely to falsely trigger from crashes
SRAM_StartOfWorkArea = $700400
; Inbound
SNI_ReceivedItemNumber = $700400
SNI_ReceivedItemID = $700402
SNI_ReceivedItemActionCode = $700404
SNI_ReceivedItemArg = $700406
; Outbound
SNI_ReceiveCheck = $700408
SNI_DeathlinkTrigger = $70040C
; Random variables
SRAM_APLogoTime = $700410
SRAM_CheckComparisonTemp = $700412
SRAM_LastStageRevealFlag = $700414
SRAM_StageClearPendingUnlocksExist = $700416
SRAM_PuzzlePendingUnlocksExist = $700418
SRAM_SecretPuzzlePendingUnlocksExist = $70041A
SRAM_GoingThroughPendingUnlocks = $70041C
SRAM_PendingUnlocksCounted = $70041E
SRAM_PendingUnlocksPointer = $700420
SRAM_PendingUnlockFramesLeft = $700422
SRAM_LockSpriteValues = $700424
SRAM_DeathlinkPendingEvent = $700448
SRAM_SCCurrentHealthBar = $70044A
SRAM_SCPreviousHealthBar = $70044C
SRAM_LoopCounter = $70044E
SRAM_PuzzleFanfareIsRoundClear = $700450
SRAM_PrintedSwitchMessage = $700452
SRAM_TempMovA = $700454
SRAM_TempMovB = $700456
; Regions
SRAM_PendingUnlocks = $700500
SRAM_End = $700800

;;;;;;;;;;;;
; Modifications
;;;;;;;;;;;;
incsrc "export/main.asm"
padbyte $00

; Increase ROM space to 1.125 MB
org $80FFD7
db $0B
org $A08000 : pad $A18000
org $A18000 : pad $A28000
org $A28000 : pad $A38000
org $A38000 : pad $A48000

incsrc "Injections.asm"


;;;;;;;;;;;;
; Bank A0 = injected locations, items, settings, dialogue, and sprites
;;;;;;;;;;;;
; 32 KB reserved for all location data, starting items, settings, and hint strings
DATA8_GoalStageClear = $A08000
; Puzzle Goal Flags
;   -----esn
;        e = either clear is goal
;         s = Secret Puzzle Round 6 Clear
;          n = Puzzle Round 6 Clear
DATA8_GoalPuzzle = $A08001
DATA8_GoalVersus = $A08002 ; 1 = stage 10, 2 = stage 11, 3 = stage 12, 4 = stage 12 S. Hard, 5 = stage 12 S. Hard no continues
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
;   ---fen-i
;      f = fast menu animations and countdowns
;       e = secret puzzle access
;        n = normal puzzle access
;          i = Incremental mode, lets the player start without all the puzzles
DATA8_PuzzleFlags = $A08004
DATA8_VersusFlags = $A08005
;TODO: Also add an SRAM value which the player can toggle
DATA8_DeathlinkHint = $A08006
; Checks are bitmasks, sum up all the 1's to get the total number of checks
; If the SRAM values are less than these, display the AP sprite
; Stage Clear round checks bitmask (0)
;   il----pr
;   i = indefinite checks
;    l = locally cleared, used for save data
;         p = special stage; typically only round 3 has this
;          r = round clear check
; Stage Clear stage checks bitmask (1-5)
;   il----ps
;   i = indefinite checks
;    l = locally cleared, used for save data
;         p = special stage; typically only 3-5 has this if round 3 doesn't
;          s = stage clear check
DATA8_StageClearRound1Checks = $A08020
DATA8_StageClearRound2Checks = $A08026
DATA8_StageClearRound3Checks = $A0802C
DATA8_StageClearRound4Checks = $A08032
DATA8_StageClearRound5Checks = $A08038
DATA8_StageClearRound6Checks = $A0803E
DATA8_StageClearLastStageChecks = $A08044
DATA8_StageClearSpecialStageCount = $A08045
DATA8_VersusStageChecks = $A08046
DATA8_VersusCharacterChecks = $A08052
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
;DATA16_??? = $A08330
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
dw $0434, $019F, $037B, $0380, $7FC0, $7CC0, $78EF, $781F, $7EFF, $7FFF, $4210
;incsrc "testsave.asm"

org $A0F800
GFX_CustomMenuGraphics:
incbin "customgraphics.bin"

;;;;;;;;;;;;
; Bank A1 = AP menu and protocol code
;;;;;;;;;;;;
org $A18000

CODE_NewCrashHandler:
    REP #$30
    LDA #$5243
    STA.L $7E0000
    LDA #$5341
    STA.L $7E0002
    LDA #$4548
    STA.L $7E0004
    LDA #$2144
    STA.L $7E0006
    STP
    ; TODO: Try to print data onto the screen

CODE_SRAMHealthCheck:
    PHP
    REP #$30
    PHA
    LDA.W #$0000
    STA.L SRAM_ArmCrash
    LDA.L WRAM_AntipiracyFlag
    BNE .WriteSuccessful
        LDA.W #ErrorCode_NoSRAM
        STA.L $7E0008
        BRK
    .WriteSuccessful:
    LDA.W #$0000
    STA.L WRAM_AntipiracyFlag
    JSL.L CODE_SRAMValidation
    LDA.W #$0001
    STA.L SRAM_ArmCrash
    JSR.W CODE_InitializeSaveFile
    JSR.W CODE_ComputeSRAMChecksum
    CMP.L SRAM_SaveChecksum
    BEQ .GoodToGo
        STA.L $7E000C ; re-computed checksum
        LDA.L SRAM_SaveChecksum
        STA.L $7E000A ; saved checksum
        LDA.W #ErrorCode_SRAMChecksumFail
        STA.L $7E0008
        BRK
    .GoodToGo:
    LDA.W #$0000
    LDX.W #(SRAM_End-SRAM_StartOfWorkArea-2)
    CODE_ClearSRAMWorkArea:
        STA.L SRAM_StartOfWorkArea,X
        DEX
        DEX
    BPL CODE_ClearSRAMWorkArea
    PLA
    PLP
    RTL

CODE_InitializeSaveFile:
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
    LDA.W #$0000
    STA.L SRAM_SaveChecksum
    LDA.W #$FFFF
    STA.L SRAM_SaveChecksumComplement
    JSR.W CODE_ComputeSRAMChecksum
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
    JSR.W CODE_ComputeSRAMChecksum
    CMP.L SRAM_SaveChecksum
    BNE CODE_DoSaveWipe
    SEC
    ADC.L SRAM_SaveChecksumComplement
    BEQ CODE_SkipSaveWipe
        CODE_DoSaveWipe:
        LDA.L SRAM_ArmCrash
        PHA
        LDA.W #$0000
        LDX.W #(SRAM_End-4)
        CODE_SaveWipeLoop:
            STA.L $700002,X
            DEX
            DEX
        BPL CODE_SaveWipeLoop
        JSL.L CODE_SRAMSave
        PLA
        BEQ CODE_DontCrash
        BRK
    CODE_DontCrash:
    CODE_SkipSaveWipe:
    PLX
    PLA
    PLP
    RTL

CODE_ComputeSRAMChecksum:
    LDA.W #$0000
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
    LDA.W WRAM7E_GameState
    CMP.W #$0004
    BNE .SkipGameplayLogic
        JSL.L CODE_ScanIncomingArchipelagoItems
        LDA.L SRAM_DeathlinkPendingEvent
        BEQ .GoToStateMachine
        LDA.W WRAM7E_CurrentlyPaused
        BNE .GoToStateMachine
        LDA.W WRAM7E_ShouldPause
        BNE .GoToStateMachine
            LDA.W #$0005
            STA.W WRAM7E_GameState
            LDA.W #$0001
            STA.W WRAM7E_ToppedOut
            STZ.W WRAM7E_AdvanceIngameTimer
            LDA.W #$0000
            STA.L SRAM_DeathlinkPendingEvent
            STA.W WRAM7E_GameSubstate
        BRA .GoToStateMachine
    .SkipGameplayLogic:
    LDA.W WRAM7E_GameState
    CMP.W #$0005
    BNE .GoToStateMachine
        JSL.L CODE_ScanIncomingArchipelagoItems
    .GoToStateMachine:
    PEA $8000
    PLB
    PLB
    REP #$30
    PHP
    JML.L $80A703

CODE_TitleScreenCustomCode3:
    print "New title screen state 3 code at ",pc
    LDA.L $7E661A
    BEQ .End
    JSR.W CODE_TitleScreenAPWiggle
    LDA.B WRAM00_Pad1Press
    ORA.B WRAM00_Pad2Press
    BEQ .End
    LDA.W #$0000 ; Set next title screen action to immediately be Yoshi giving the peace sign
    STA.L $7E6612
    LDA.W #$C905
    STA.L $7E6614
    LDA.W #$0005 ; Play the Menu Accept sound
    STA.W $1988
    INC.W $02A2 ; Increment title screen state
    .End:
    RTL

CODE_TitleScreenCustomCode4:
    print "New title screen state 4 code at ",pc
    JSR.W CODE_TitleScreenAPWiggle
    LDA.L $7E662C
    BEQ .End
    INC.W $02A2
    .End:
    RTL

CODE_TitleScreenAPWiggle:
    LDA.L SRAM_APLogoTime
    INC A
    STA.L SRAM_APLogoTime
    ; TODO: Wiggle the * AP sprite up and down
    RTS

CODE_NewMainMenuRoutine:
    PHP
    PEA $8300
    PLB
    PLB
    REP #$30
    CODE_ToMainMenuStateMachine:
    REP #$30
    SEP #$20
    JML.L $83BD1E

CODE_NewMainMenuState2:
    print "New main menu state 2 routine at ",pc
    PHP
    PHA
    REP #$30
    ; Start at option 2
    LDA.W #$0002
    STA.L WRAM_1POptionIndex
    STZ.W WRAM7E_PlayersIndicator
    JSR.W CODE_1PlayerGameSummon
    PLA
    PLP
    RTL

CODE_1PlayerGameSummon:
    LDA.W #$0008
    STA.W WRAM83_GameSubstate
    STZ.W $1A6E
    RTS

CODE_NewMainMenuState9:
    print "New main menu state 9 routine at ",pc
    ; TODO_AFTER: Disallow access to modes that are not included
    ;LDA.L WRAM7E_MenuPadPress
    ;BIT.W #$0060
    ;BEQ SkipSpecialCheck
    ;LDA.W #$00D1
    ;STA.W WRAM7E_NewMusicEvent
    ;SkipSpecialCheck:
    JSL.L CODE_ScanIncomingArchipelagoItems
    LDA.L WRAM_1POptionIndex
    STA.L WRAM_ModeIndex
    CLC
    ADC.W #$0006
    JSL.L CODE_839DD7_JSR
    LDA.W #$0001
    STA.L $7E96DB
    LDY.W #$C4F9
    LDA.L WRAM_1POptionIndex
    DEC A
    DEC A
    JSL.L CODE_MenuSelection_JSR
    LDA.B $00
    INC A
    INC A
    STA.L WRAM_1POptionIndex
    LDX.W #$0038
    LDY.W #$0053
    LDA.L WRAM_1POptionIndex
    JSL.L CODE_8397A1_JSR
    LDA.L $7E96FD
    BEQ .End
        STZ.W $1A70
    .End:
    RTL

DATA_CustomGraphicsVRAMDMA:
    dl GFX_CustomMenuGraphics
    dw $0040
    db $80
    dw $0BB0

GFX_LockSprite = $3ABB
GFX_LockSpriteHighlighted = $3CBB
GFX_APSprite = $36BC
GFX_StageClearSprite = $3CCB

incsrc "StageClearMenu.asm"
incsrc "PuzzleMenu.asm"

CODE_ScanIncomingArchipelagoItems:
    print "Archipelago SNI scanning is at ",pc
    PHP
    REP #$30
    LDA.L SNI_ReceivedItemNumber
    CMP.L SNI_ReceiveCheck
    BEQ .NoNewItems
        JSL.L CODE_SRAMValidation
        ; Respond based on the action code
        LDA.L SNI_ReceivedItemActionCode
        ASL A
        TAX
        JSR.W (PTR16_ArchipelagoActions,X)
        ; Get ready for the next item
        LDA.L SNI_ReceivedItemNumber
        STA.L SNI_ReceiveCheck
        ; Set action code to zero to avoid syncing problems
        LDA.W #$0000
        STA.L SNI_ReceivedItemActionCode
        ; Save the new checksum
        JSL.L CODE_SRAMSave
        PLP
        RTL
    .NoNewItems:
        PLP
        RTL
PTR16_ArchipelagoActions:
    dw CODE_ArchipelagoDoNothing
    dw CODE_ArchipelagoWriteValue
    dw CODE_ArchipelagoWriteReceivedItem
    dw CODE_ArchipelagoGrantedLastStage
    dw CODE_ArchipelagoORValue
    dw CODE_ArchipelagoMarkComplete
    dw CODE_ArchipelagoWriteReceivedCharacter
    dw CODE_ArchipelagoAddScore
CODE_ArchipelagoDoNothing:
    RTS
; Action Code 0003: play sound effect, set ID to arg, and prepare the reveal
CODE_ArchipelagoGrantedLastStage:
    LDA.W #$0001
    STA.L SRAM_LastStageRevealFlag ; TODO: Use this flag to do a custom reveal
    LDA.W #$00F7
    STA.L WRAM7E_NewSoundEvent
    BRA CODE_ArchipelagoWriteValue
; Action Code 0002: play sound effect and set ID to arg
CODE_ArchipelagoWriteReceivedItem:
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
CODE_ArchipelagoWriteValue:
    LDA.L SNI_ReceivedItemID
    TAX
    SEP #$20
    LDA.L SNI_ReceivedItemArg
    STA.L $700000,X
    REP #$20
    RTS
; Action Code 0005: ORwise set ID to arg and play sound
CODE_ArchipelagoMarkComplete:
    LDA.W #$00F6
    STA.L WRAM7E_NewSoundEvent
; Action Code 0004: ORwise set ID to arg
CODE_ArchipelagoORValue:
    LDA.L SNI_ReceivedItemID
    TAX
    SEP #$20
    LDA.L $700000,X
    ORA.L SNI_ReceivedItemArg
    STA.L $700000,X
    REP #$20
    RTS
; Action Code 0006: play unique sound effect and set ID to arg
CODE_ArchipelagoWriteReceivedCharacter:
    LDA.W #$004C
    STA.L WRAM7E_NewSoundEvent
    BRA CODE_ArchipelagoWriteReceivedItem
; Action Code 0007: add chain or combo score
CODE_ArchipelagoAddScore:
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
    BRL CODE_ArchipelagoWriteValue


;;;;;;;;;;;;
; Bank A2 = Stage Clear, Puzzle, and Vs injected subroutines
;;;;;;;;;;;;
org $A28000

incsrc "StageClear.asm"
incsrc "Puzzle.asm"

;;;;;;;;;;;;
; Bank A3 = miscellaneous
;;;;;;;;;;;;
org $A38000

; TODO_AFTER: Include Panel de Pon content
