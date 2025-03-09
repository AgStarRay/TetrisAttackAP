;;;;;;;;;;;;
; Defines
;;;;;;;;;;;;
ErrorCode_NoSRAM = $0126
ErrorCode_SRAMChecksumFail = $0226
ErrorCode_AttemptedToStartFullyLockedStage = $0326

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
; When stage_clear_saves is enabled, these are used to determine where to resume
; Oneshot mode will set these to 0 after starting but will save values when kicking out the player
SRAM_StageClearRound1Furthest = $700002
SRAM_StageClearRound2Furthest = $700003
SRAM_StageClearRound3Furthest = $700004
SRAM_StageClearRound4Furthest = $700005
SRAM_StageClearRound5Furthest = $700006
SRAM_StageClearRound6Furthest = $700007
SRAM_StageClearSpecialStageCompletions = $700008
SRAM_SaveChecksumComplement = $70001C
SRAM_SaveChecksum = $70001E
SRAM_UnlocksRegionStart = $700020
; 0-4 are individual stage unlocks, 5 is the round unlock
; TODO: Rearrange to have 0 be the round gate and 1-5 be the stage unlocks
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
SRAM_PuzzleWorld1Unlocks = $700060
SRAM_PuzzleWorld2Unlocks = $70006B
SRAM_PuzzleWorld3Unlocks = $700076
SRAM_PuzzleWorld4Unlocks = $700081
SRAM_PuzzleWorld5Unlocks = $70008C
SRAM_PuzzleWorld6Unlocks = $700097
SRAM_PuzzleSecretWorld1Unlocks = $7000A2
SRAM_PuzzleSecretWorld2Unlocks = $7000AD
SRAM_PuzzleSecretWorld3Unlocks = $7000B8
SRAM_PuzzleSecretWorld4Unlocks = $7000C3
SRAM_PuzzleSecretWorld5Unlocks = $7000CE
SRAM_PuzzleSecretWorld6Unlocks = $7000D9
SRAM_PuzzlePanelUnlocks = $7000E4
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
SRAM_PuzzleWorld1Clears = $700259
SRAM_PuzzleWorld2Clears = $700263
SRAM_PuzzleWorld3Clears = $70026D
SRAM_PuzzleWorld4Clears = $700277
SRAM_PuzzleWorld5Clears = $700281
SRAM_PuzzleWorld6Clears = $70028B
SRAM_PuzzleSecretWorld1Clears = $700295
SRAM_PuzzleSecretWorld2Clears = $70029F
SRAM_PuzzleSecretWorld3Clears = $7002A9
SRAM_PuzzleSecretWorld4Clears = $7002B3
SRAM_PuzzleSecretWorld5Clears = $7002BD
SRAM_PuzzleSecretWorld6Clears = $7002C7
; SRAM_??? = $7002D1
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

; New crash handler
org $80FFAC
JML.L CODE_NewCrashHandler
org $80FFE6
dw $FFAC

; Append game title
org $80FFCE
db 'A','P'

; Set version number
org $80FFDB
db $01

; Enable 2 KB SRAM for offline mode progress and safe WRAM
org $80FFD8
db $01

; Inject logic into the overarching state machine
org $80A6FB
JML.L CODE_StateMachineLogic

; Replace anti-piracy flag check with SRAM health check
org $808200
JSL CODE_SRAMHealthCheck
BRA CODE_80820C

; Redirect the title screen button check code in states 3 and 4
org $8ABC4E
JSL CODE_TitleScreenCustomCode3
RTS
org $8ABDF9
JSL CODE_TitleScreenCustomCode4
RTS

; Redirect the main menu state machine to injected code
org $83C096
JML CODE_NewMainMenuRoutine
RTS

; Replace main menu substate 2 with custom code
org $83C096
JSL CODE_NewMainMenuState2
RTS

; Replace main menu substate 2 with custom code
org $83C4DB
JSL CODE_NewMainMenuState9
RTS
CODE_839DD7_JSR:
JSR.W CODE_839DD7
RTL
CODE_8397A1_JSR:
JSR.W CODE_8397A1
RTL
CODE_MenuSelection_JSR:
JSR.W CODE_MenuSelection
RTL

; Stop the CLEAR text from appearing in the Stage Clear submenu
org $83ADFD
RTS

; Inject Stage Clear substate 1 with custom code
org $83DDD6
JML.L CODE_MenuSCState1CustomCode

; Replace Stage Clear substate 2 procedure 0 with custom code
;org $83E08D
;JSL.L CODE_MenuSCState2CustomCode0
;RTS

; Replace Stage Clear substate 2 procedure 11 with custom code
org $83E22C
JSL.L CODE_MenuSCState2CustomCode11
RTS
CODE_83E666_JSR:
    JSR.W CODE_83E666
    RTL
CODE_83E6C0_JSR:
    JSR.W CODE_83E6C0
    RTL
CODE_839565_JSR:
    JSR.W CODE_839565
    RTL
CODE_83AEB0_JSR:
    JSR.W CODE_83AEB0
    RTL
CODE_83A058_JSR:
    JSR.W CODE_83A058
    RTL

; Change how the Stage Clear save is initialized
org $83C9B6
dw CODE_SCOptionNewGame
org $87AA07
JML.L CODE_NewStageClearCustomSave


; Replace option data in substate 9 to the lower 3 options
; This code restricts access to Stage Clear, Puzzle, and Vs
org $83C4F9
db $02 ; The last option index; the new state 9 code below subtracts the tracked value by 2 to match
org $83C519
db $16,$1B,$39,$04 ; proceed to Stage Clear, proceed to Puzzle, proceed to Vs, fade-out to title screen
; This code restricts access to only Stage Clear
org $83C4F9
db $00 ; The last option index
org $83C519
db $16,$04 ; proceed to Stage Clear, fade-out to title screen

; Set new 1Player default option
org $83C4C3
LDA.W #$0002
STA.L WRAM7E_1POptionIndex
NOP
LDA.W #$0000
STA.L $7E9532
STA.L $7E9534
STA.L $7E953A

; Make all game modes go back directly to the 1Player Game menu
org $83C1F9
db $08,$08,$08

; Make the Stage Clear and Puzzle submenus go back to the 1Player Game menu
org $83C7B6
LDA.W #$0015
org $83C7BB
LDA.W #$001A
; Make the Stage Clear submenu allow selection after clearing a round
org $83DEAB
db $02,$02,$02
; Make the Vs mode go back to the 1Player Game menu
org $83C1F7
db $38

; Replace Stage Clear substate 8 procedure 0 with custom code
org $83E708
JML.L CODE_ArchipelagoStageClearMenu
CODE_838E7D_JSR:
    JSR.W CODE_838E7D
    RTL

; Get rid of Yoshi in the main menu
;org $839E71
;RTS

; TODO: Add new submenu for Vs.

; Inject subroutine for Stage Clear win
org $87C83F
JSL.L CODE_OnStageClearWin
RTS

; Inject subroutine for Stage Clear top out
org $87C871
JSL.L CODE_OnStageClearTopOut
RTS

; Inject subroutine when results screen is going to the next stage for the password
org $87E1E8
JSL.L CODE_StageClearResultSummonNextStage
RTS

; Disable Stage Clear tampering with the stage selection before gameplay
org $87A9F8
RTS


;;;;;;;;;;;;
; Bank A0 = injected locations, items, settings, dialogue, and sprites
;;;;;;;;;;;;
; 32 KB reserved for all location data, starting items, settings, and hint strings
DATA8_GoalStageClear = $A08000
DATA8_GoalPuzzle = $A08001 ; If secret puzzle 6-10 must also be cleared, this will be 2
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
; Checks are bitmasks, sum up all the 1's to get the total number of checks
; If the SRAM values are less than these, display the AP sprite
; Stage Clear stage checks bitmask (0-4)
;   i-----ps
;   i = indefinite checks
;         p = special stage; typically only 3-5 has this if round 3 doesn't
;          s = stage clear check
; Stage Clear round checks bitmask (5)
;   il----pr
;   i = indefinite checks
;    l = locally cleared, used for save data
;         p = special stage; typically only round 3 has this
;          r = round clear check
; TODO: Also add an SRAM value which the player can toggle
DATA8_DeathlinkHint = $A08006
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
DATA8_PuzzleWorld1Checks = $A08060
DATA8_PuzzleWorld2Checks = $A0806B
DATA8_PuzzleWorld3Checks = $A08076
DATA8_PuzzleWorld4Checks = $A08081
DATA8_PuzzleWorld5Checks = $A0808C
DATA8_PuzzleWorld6Checks = $A08097
DATA8_PuzzleSecretWorld1Checks = $A080A2
DATA8_PuzzleSecretWorld2Checks = $A080AD
DATA8_PuzzleSecretWorld3Checks = $A080B8
DATA8_PuzzleSecretWorld4Checks = $A080C3
DATA8_PuzzleSecretWorld5Checks = $A080CE
DATA8_PuzzleSecretWorld6Checks = $A080D9
DATA8_InitialUnlocks = $A08100 ; The values in SRAM are bitwise OR'd with this data
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
    LDA.L WRAM7E_AntipiracyFlag
    BNE .WriteSuccessful
        LDA.W #ErrorCode_NoSRAM
        STA.L $7E0008
        BRK
    .WriteSuccessful:
    LDA.W #$0000
    STA.L WRAM7E_AntipiracyFlag
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
        BEQ .SkipDeathlinkEvent
        LDA.W WRAM7E_CurrentlyPaused
        BNE .SkipDeathlinkEvent
        LDA.W WRAM7E_ShouldPause
        BNE .SkipDeathlinkEvent
            LDA.W #$0005
            STA.W WRAM7E_GameState
            LDA.W #$0001
            STA.W WRAM7E_ToppedOut
            STZ.W WRAM7E_AdvanceIngameTimer
            LDA.W #$0000
            STA.L SRAM_DeathlinkPendingEvent
            STA.W WRAM7E_GameSubstate
        .SkipDeathlinkEvent:
    .SkipGameplayLogic:
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
    STA.L WRAM7E_1POptionIndex
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

CODE_StageClearSummon:
    LDA.W #$0013
    STA.W WRAM83_GameSubstate
    LDA.W #$0002
    STA.L $7E952A
    STZ.W $1A6E
    RTS

CODE_PuzzleSummon:
    LDA.W #$0018
    STA.W WRAM83_GameSubstate
    LDA.W #$0003
    STA.L $7E952A
    STZ.W $1A6E
    RTS

CODE_VsSummon:
    LDA.W #$0036
    STA.W WRAM83_GameSubstate
    LDA.W #$0004
    STA.L $7E952A
    STZ.W $1A6E
    RTS

CODE_PasswordSummon:
    LDA.W #$001C
    STA.W WRAM83_GameSubstate
    LDA.W #$0002
    STA.L $7E952A
    STZ.W $1A6E
    RTS

CODE_NewMainMenuState9:
    print "New main menu state 9 routine at ",pc
    ;LDA.L WRAM7E_MenuPadPress
    ;BIT.W #$0060
    ;BEQ SkipSpecialCheck
    ;LDA.W #$00D1
    ;STA.W WRAM7E_NewMusicEvent
    ;SkipSpecialCheck:
    LDA.L WRAM7E_1POptionIndex
    STA.L WRAM7E_ModeIndex
    CLC
    ADC.W #$0006
    JSL.L CODE_839DD7_JSR
    LDA.W #$0001
    STA.L $7E96DB
    LDY.W #$C4F9
    LDA.L WRAM7E_1POptionIndex
    DEC A
    DEC A
    JSL.L CODE_MenuSelection_JSR
    LDA.B $00
    INC A
    INC A
    STA.L WRAM7E_1POptionIndex
    LDX.W #$0038
    LDY.W #$0053
    LDA.L WRAM7E_1POptionIndex
    JSL.L CODE_8397A1_JSR
    LDA.L $7E96FD
    BEQ .End
    STZ.W $1A70
    .End:
    RTL

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
    STA.L $7E96E7
    STA.L $7E96EB
    STA.L $7E96F5
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
DATA_CustomGraphicsVRAMDMA:
    dl GFX_CustomMenuGraphics
    dw $0040
    db $80
    dw $0BB0

CODE_ArchipelagoStageClearMenu:
    print "New stage clear submenu state 8 procedure 0 at ",pc
    GFX_LockSprite = $3ABB
    GFX_LockSpriteHighlighted = $3CBB
    GFX_APSprite = $36BC
    JSL.L CODE_SRAMValidation
    JSL.L CODE_ScanIncomingArchipelagoItems
    JSR.W CODE_SetLocalRoundClears
    STZ.W WRAM7E_StageClearStageIndex
    LDY.W WRAM7E_OAMAppendAddr
    LDX.W #$0000
    CODE_MenuSCCustomGraphicsLoop:
        CPX.W #$0024
        BCS CODE_MenuSCCustomGraphics_End
        LDA.L SRAM_StageClearRound1Unlocks,X
        AND.W #$00FF
        BNE CODE_MenuSCSkipLockSprite
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
            BRA CODE_MenuSCNextSlot
        CODE_MenuSCSkipLockSprite:
        LDA.L DATA8_StageClearRound1Checks,X
        AND.W #$00FF
        STA.L SRAM_CheckComparisonTemp
        LDA.L SRAM_StageClearRound1Clears,X
        AND.W #$00FF
        CMP.L SRAM_CheckComparisonTemp
        BCS CODE_MenuSCNextSlot
            JSR.W CODE_MenuSCCalculateSpritePos
            STA.W WRAM7E_OAMBuffer,Y
            INY
            INY
            LDA.W #GFX_APSprite
            STA.W WRAM7E_OAMBuffer,Y
            INY
            INY
        CODE_MenuSCNextSlot:
        INX
        BRA CODE_MenuSCCustomGraphicsLoop
    CODE_MenuSCCustomGraphics_End:
    STY.W WRAM7E_OAMAppendAddr

    LDA.L $7E95EC
    BEQ .Jump1
        LDA.W #$0003
        STA.L $7E95EE
    .Jump1:
    LDX.W #$0000
    JSL.L CODE_838E7D_JSR
    LDA.L $7E96F5
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
        BNE .Jump5
        JSR.W CODE_CheckIfRoundIsOpen
        BCS .Jump5
            LDA.W #$0004
            STA.W WRAM83_NewSoundEvent
            JSR.W CODE_HighlightRoundLockSprites
            JML.L CODE_83E754
        .Jump5:
        LDA.W #$0005
        STA.W WRAM83_NewSoundEvent
        LDA.W #$0000
        STA.L $7E9969
        STA.L $7E997D
        JSL.L CODE_MenuSCPickFirstStage
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
    LDA.W DATA16_StageClearUnlockOffsets,X
    TAX
    LDA.L DATA8_StageClearFlags
    BIT.W #$0001
    BEQ .CheckIndividualStageUnlocks
        BIT.W #$0002
        BEQ .CheckIncrementalStageUnlocks
        .CheckSkippableStageUnlocks:
            LDA.L $700005,X
            AND #$00FF
            BEQ .Failed
            LDA.L $700000,X
            BNE .Passed
            LDA.L $700002,X
            BNE .Passed
            LDA.L $700004,X
            AND #$00FF
            BNE .Passed
            BRA .Failed
        .CheckIncrementalStageUnlocks:
            LDA.L $700000,X
            AND #$00FF
            BEQ .Failed
            LDA.L $700005,X
            AND #$00FF
            BEQ .Failed
            BRA .Passed
    .CheckIndividualStageUnlocks:
        LDY.W #$0006
        .Loop:
            LDA.L $700000,X
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
    LDA.L DATA8_StageClearFlags
    BIT.W #$0002
    BNE .CanSkipFirstStage
        LDA.W #$0001
        STA.L SRAM_LockSpriteValues,X
    .CanSkipFirstStage:
    LDA.W #$0100
    STA.L SRAM_LockSpriteValues+4,X
    LDA.L DATA8_StageClearFlags
    BIT.W #$0001
    BNE .SkipIndividualStageLocks
        LDA.W #$0101
        STA.L SRAM_LockSpriteValues+1,X
        STA.L SRAM_LockSpriteValues+3,X
    .SkipIndividualStageLocks:
    RTS
DATA16_MenuSCSpritePositions:
    dw $4047,$404F,$4057,$405F,$4067,$306F
    dw $40BF,$40C7,$40CF,$40D7,$40DF,$30E7
    dw $8047,$804F,$8057,$805F,$8067,$706F
    dw $80BF,$80C7,$80CF,$80D7,$80DF,$70E7
    dw $C047,$C04F,$C057,$C05F,$C067,$B06F
    dw $C0BF,$C0C7,$C0CF,$C0D7,$C0DF,$B0E7
DATA16_StageClearUnlockOffsets:
    dw SRAM_StageClearRound1Unlocks
    dw SRAM_StageClearRound2Unlocks
    dw SRAM_StageClearRound3Unlocks
    dw SRAM_StageClearRound4Unlocks
    dw SRAM_StageClearRound5Unlocks
    dw SRAM_StageClearRound6Unlocks

CODE_NewStageClearCustomSave:
    PHP
    REP #$30
    JSL.L CODE_SRAMValidation
    ; LDA.W #$0101
    ; STA.L SRAM_StageClearRound1Unlocks
    ; STA.L SRAM_StageClearRound1Unlocks+2
    ; STA.L SRAM_StageClearRound1Unlocks+4
    ; STA.L SRAM_StageClearRound2Unlocks
    ; STA.L SRAM_StageClearRound2Unlocks+2
    ; STA.L SRAM_StageClearRound2Unlocks+4
    ; STA.L SRAM_StageClearRound3Unlocks
    ; STA.L SRAM_StageClearRound3Unlocks+2
    ; STA.L SRAM_StageClearRound3Unlocks+4
    ; STA.L SRAM_StageClearRound4Unlocks
    ; STA.L SRAM_StageClearRound4Unlocks+2
    ; STA.L SRAM_StageClearRound4Unlocks+4
    ; STA.L SRAM_StageClearRound5Unlocks
    ; STA.L SRAM_StageClearRound5Unlocks+2
    ; STA.L SRAM_StageClearRound5Unlocks+4
    ; STA.L SRAM_StageClearRound6Unlocks
    ; STA.L SRAM_StageClearRound6Unlocks+2
    ; STA.L SRAM_StageClearRound6Unlocks+4
    ; JSL.L CODE_SRAMSave
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
    BEQ .NoLastStage
        LDA.W #$0006
        BRA .RoundClears
    .NoLastStage:
        LDA.W #$0005 ; Allow access to all 6 rounds then restrict the player's entry
    .RoundClears:
    STA.W WRAM7E_StageClearRoundClears
    RTS

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
CODE_ArchipelagoDoNothing:
    RTS
; Action Code 0003: play sound effect, set ID to arg, and prepare the reveal
CODE_ArchipelagoGrantedLastStage:
    LDA.W #$0001
    STA.L SRAM_LastStageRevealFlag ; TODO: Use this flag to do a custom reveal
    LDA.W #$00FB
    STA.L WRAM7E_NewSoundEvent
    BRA CODE_ArchipelagoWriteValue
; Action Code 0002: play sound effect and set ID to arg
CODE_ArchipelagoWriteReceivedItem:
    LDA.W #$0021
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

;;;;;;;;;;;;
; Bank A2 = Stage Clear, Puzzle, and Vs injected subroutines
;;;;;;;;;;;;
org $A28000
CODE_OnStageClearWin:
    PHP
    REP #$30
    SEP #$20
    LDA.W WRAM7E_StageClearSpecialIndex
    BEQ .RegularStageClear
        CMP.B #$02
        BNE .SpecialStageClear
            LDA.B #$7F
            STA.L SRAM_StageClearLastStageClear
            STA.L SRAM_StageClearLastStageClear+$101
            BRL .SaveProgress
        .SpecialStageClear:
            LDA.L SRAM_StageClearSpecialStageCompletions
            INC A
            STA.L SRAM_StageClearSpecialStageCompletions
            BRL .SaveProgress
    .RegularStageClear
        print "Regular stage clear logic at ",pc
        LDX.W WRAM7E_StageClearRoundIndex
        DEX
        LDA.W WRAM7E_StageClearStageIndex
        CMP.L SRAM_StageClearRound1Furthest,X
        BCC .SkipUpdatingFurthest
            STA.L SRAM_StageClearRound1Furthest,X
        .SkipUpdatingFurthest
        REP #$30
        LDA.W WRAM7E_StageClearRoundIndex
        DEC A
        ASL A
        TAX
        LDA.L DATA16_StageClearRoundClearOffsets,X
        PHA
        CLC
        ADC.W WRAM7E_StageClearStageIndex
        DEC A
        TAX
        SEP #$20
        LDA.B #$7F
        STA.L $700000,X
        STA.L $700101,X
        print "Round clear check at ",pc
        PLX
        LDA.L $700005,X
        BIT.B #$40 ; TODO: Change more checks to look at bit 6
        BNE .RoundAlreadyCleared
            LDA.L $700000,X
            BIT.B #$40
            BEQ .NotCleared
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
            LDA.B #$7F
            STA.L $700005,X
            STA.L $700106,X
            JSR.W CODE_LastStageUnlock
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
        BEQ .NoBravoSound
            REP #$30
            LDA.W #$00FA ; Bravo II sound
            STA.W WRAM7E_NewSoundEvent
        .NoBravoSound:
    .SaveProgress
    REP #$30
    JSL.L CODE_SRAMSave
    LDA.W #$000A
    STA.W WRAM7E_GameSubstate
    PLP
    RTL
CODE_LastStageUnlock:
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
DATA16_StageClearRoundClearOffsets:
    dw SRAM_StageClearRound1Clears
    dw SRAM_StageClearRound2Clears
    dw SRAM_StageClearRound3Clears
    dw SRAM_StageClearRound4Clears
    dw SRAM_StageClearRound5Clears
    dw SRAM_StageClearRound6Clears

CODE_OnStageClearTopOut:
    LDA.W WRAM7E_StageClearSpecialIndex
    BEQ .NormalStage
        ; TODO: Add Special Stage message
        LDA.W #DeathlinkCode_StageClearLastStage
        BRA .ApplyTrigger
    .NormalStage:
        LDA.W #DeathlinkCode_StageClearNormalStage
    .ApplyTrigger:
    STA.L SNI_DeathlinkTrigger
    LDA.W #$0001
    STA.L $7E943A
    INC.W WRAM7E_GameSubstate
    RTL

CODE_StageClearResultSummonNextStage:
    LDA.W WRAM7E_RoundClearIndicator
    BNE .EndRound
    INC.W WRAM7E_StageClearStageIndex
    JSR.W CODE_SkipIfClearedOrLockedStage
    JSR.W CODE_SkipIfClearedOrLockedStage
    JSR.W CODE_SkipIfClearedOrLockedStage
    JSR.W CODE_SkipIfLockedStage
    LDA.W WRAM7E_StageClearStageIndex
    CMP.W #$0006
    BCC .AdvanceToNextStage
    .EndRound:
        LDA.W #$0001
        BRA .SetEndModeIndicator
    .AdvanceToNextStage:
        LDA.W #$0000
    .SetEndModeIndicator:
    STA.L WRAM7E_EndModeIndicator
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
    LDA.L DATA16_StageClearRoundClearOffsets,X
    TAX
    LDA.L $700005,X
    AND.W #$00FF
    BNE .ReplayingClearedRound
        JSR.W CODE_SkipIfClearedOrLockedStage
        JSR.W CODE_SkipIfClearedOrLockedStage
        JSR.W CODE_SkipIfClearedOrLockedStage
        JSR.W CODE_SkipIfClearedOrLockedStage
        JSR.W CODE_SkipIfLockedStage
        LDA.W WRAM7E_StageClearStageIndex
        CMP.W #$0006
        BCC .Done
            LDA.W #$0001
            STA.W WRAM7E_StageClearStageIndex
            JSR.W CODE_SkipIfLockedStage
            JSR.W CODE_SkipIfLockedStage
            JSR.W CODE_SkipIfLockedStage
            JSR.W CODE_SkipIfLockedStage
            JSR.W CODE_SkipIfLockedStage
            LDA.W WRAM7E_StageClearStageIndex
            CMP.W #$0006
            BCC .Done
                LDA.W #ErrorCode_AttemptedToStartFullyLockedStage
                STA.B $0008
                BRK
    .ReplayingClearedRound:
    .Done:
    RTL
CODE_SkipIfClearedOrLockedStage:
    print "Cleared stage check code at ",pc
    LDA.L DATA8_StageClearFlags
    BIT.W #%0100
    BEQ .StageIsNotCleared
    LDX.W WRAM7E_StageClearRoundIndex
    DEX
    LDA.W WRAM7E_StageClearStageIndex
    DEC A
    CMP.L SRAM_StageClearRound1Furthest,X
    BCS .StageIsNotCleared
    TXA
    ASL A
    TAX
    LDA.L DATA16_StageClearRoundClearOffsets,X
    TAX
    LDA.L $700005,X
    BIT.W #$0040
    BNE .RoundAlreadyCleared
        TXA
        CLC
        ADC.W WRAM7E_StageClearStageIndex
        DEC A
        TAX
        LDA.L $700000,X
        BIT.W #$0040
        BEQ .StageIsNotCleared
        INC.W WRAM7E_StageClearStageIndex
        RTS
    .RoundAlreadyCleared:
        RTS
    .StageIsNotCleared:
CODE_SkipIfLockedStage:
    print "Skip stage code at ",pc
    LDA.W WRAM7E_StageClearRoundIndex
    DEC A
    ASL A
    TAX
    LDA.L DATA16_StageClearUnlockOffsets,X
    CLC
    ADC.W WRAM7E_StageClearStageIndex
    DEC A
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

;;;;;;;;;;;;
; Bank A3 = miscellaneous
;;;;;;;;;;;;
org $A38000

; TODO_AFTER: Include Panel de Pon content
