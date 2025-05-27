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
; SRAM_??? = $7002DD
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
; Bank A0 = injected locations, items, settings, dialogue, and sprites
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

CODE_NewCrashHandler:
    PHY
    PHX
    PHA
    PHB
    PHP
    PHK
    PLB
    PEA $0000
    PLD
    ; After all this, the stack pointer has decreased by 7-10 bytes
    REP #$FF
    SEP #$10
    ; Stop anything from interrupting or blocking this code
    LDX.B #$00
    STX.W SNES80_Interrupt_Enable
    LDX.B #$80
    STX.W SNES80_Screen_Display
    STX.W WRAM80_CurrentBrightness
    LDA.L $7EFFFE
    CMP.W #$5243
    BNE .Part1
    BRL .Part2
    .Part1:
    LDA.W #$5243 ; "CR"
    STA.L $7EFFFE
    STA.B $00
    LDA.W #$5341 ; "AS"
    STA.B $02
    ; Upload debug graphics
    STZ.W $01B0
    REP #$10
    LDY.W #DATA_DebugGraphicsVRAMDMA
    JSL.L CODE_CreateVRAMDMA
    SEP #$10
    ; Capture P for later
    PLY
    STY.B $06
    ; Set up PPU to display the numbers
    LDX.B #$81
    STX.W SNES80_CGRAM_Addr
    LDX.B #$00
    STX.W SNES80_CGRAM_Write
    STX.W SNES80_CGRAM_Write
    LDX.B #$FF
    STX.W SNES80_CGRAM_Write
    STX.W SNES80_CGRAM_Write
    LDX.B #$00
    STX.W SNES80_Object_Character_Sizes
    STX.W SNES80_WindowObj_Mask_Settings
    STZ.W SNES80_OAM_Addr_Lo
    
    ; Write to OAM
    LDA.W #$0000
    STA.B $04
    LDY.B #$0C
    JSR.W CODE_DebugAddSprite
    LDY.B #$10
    JSR.W CODE_DebugAddSprite
    LDY.B #$0A
    JSR.W CODE_DebugAddSprite
    LDY.B #$11
    JSR.W CODE_DebugAddSprite
    LDY.B #$12
    JSR.W CODE_DebugAddSprite
    LDA.W #$001C
    STA.B $04
    LDY.B #$0D
    JSR.W CODE_DebugAddSprite
    LDY.B #$16
    JSR.W CODE_DebugAddSprite
    PLY
    JSR.W CODE_DebugPrintByte ; DB
    DEC.B $04
    LDY.B #$17
    JSR.W CODE_DebugAddSprite
    LDA.W $06
    BIT.W #$0020 ; Check if P had M set
    BEQ .MWasNotSet
        PLY
        JSR.W CODE_DebugPrintByte ; A (8-bit)
        BRA .DoneWithA
    .MWasNotSet:
        PLA
        JSR.W CODE_DebugPrintWord ; A (16-bit)
    .DoneWithA:
    LDY.B #$18
    JSR.W CODE_DebugAddSprite
    LDA.W $06
    BIT.W #$0010 ; Check if P had X set
    BEQ .XWasNotSet
        PLY
        JSR.W CODE_DebugPrintByte ; X (8-bit)
        LDY.B #$19
        JSR.W CODE_DebugAddSprite
        PLY
        JSR.W CODE_DebugPrintByte ; Y (8-bit)
        BRA .DoneWithXY
    .XWasNotSet:
        PLA
        JSR.W CODE_DebugPrintWord ; X (16-bit)
        LDY.B #$19
        JSR.W CODE_DebugAddSprite
        PLA
        JSR.W CODE_DebugPrintWord ; Y (16-bit)
    .DoneWithXY:
    LDA.W #$0012
    STA.B $04
    LDY.B #$14
    JSR.W CODE_DebugAddSprite
    TSC
    INC A
    INC A
    INC A
    INC A
    JSR.W CODE_DebugPrintWord ; S
    LDA.W #$0018
    STA.B $04
    LDY.B #$15
    JSR.W CODE_DebugAddSprite
    LDA.B $01,S
    TAY
    JSR.W CODE_DebugPrintByte ; P
    LDA.W #$0006
    STA.B $04
    LDA.L WRAM_ErrorCode
    JSR.W CODE_DebugPrintWord ; Error code
    DEC.B $04
    LDY.B #$13
    JSR.W CODE_DebugAddSprite
    LDA.B $04,S
    TAY
    JSR.W CODE_DebugPrintByte ; PB
    DEC.B $04
    LDA.B $02,S
    DEC A ; BRK stores S after execution, meaning PC is 2 higher than the cause
    DEC A
    JSR.W CODE_DebugPrintWord ; PC
    LDA.W #$0058
    STA.B $04
    TSC
    SEC
    SBC.W #$00FF
    TCS
    LDX.B #$28
    ; When reading the stack data, subtract 2 for suspected JSR or 3 for suspected JSL
    .StackData:
        STX.B $06
        TXA
        AND.W #$0007
        BNE .SameRow
            LDA.B $04
            CLC
            ADC.W #$0008
            STA.B $04
        .SameRow:
        PLY
        LDA.B $FF,S ; Open bus prints $FF
        TAY
        JSR.W CODE_DebugPrintByte
        LDX.B $06
        DEX
    BNE .StackData
    ; Hide the rest of the sprites under the word "CRASH!" and set all size types and bit 8 of X positions to 0
    LDX.B #$13
    LDY.B #$00
    .SizeClears:
        STY.W SNES80_OAM_Write
        STY.W SNES80_OAM_Write
        STY.W SNES80_OAM_Write
        STY.W SNES80_OAM_Write
        DEX
    BNE .SizeClears

    ; Present new screen
    LDA.W #$4548 ; "HE"
    STA.B $04
    .Part2:
    LDX.B #$0F
    STX.W SNES80_Screen_Display
    LDA.W #$2144 ; "D!"
    STA.B $06
    WAI
    STP

CODE_DebugPrintWord:
    TAY
    STY.B $09
    STA.B $0A
    AND.W #$F000
    XBA
    LSR A
    LSR A
    LSR A
    LSR A
    TAY
    JSR.W CODE_DebugAddSprite
    LDA.B $0A
    AND.W #$0F00
    XBA
    TAY
    JSR.W CODE_DebugAddSprite
    LDY.B $09
    JSR.W CODE_DebugPrintByte
    RTS
CODE_DebugPrintByte:
    STY.B $08
    TYA
    AND.W #$00F0
    LSR A
    LSR A
    LSR A
    LSR A
    TAY
    JSR.W CODE_DebugAddSprite
    LDY.B $08
    TYA
    AND.W #$000F
    TAY
    JSR.W CODE_DebugAddSprite
    INC.B $04
    RTS
CODE_DebugAddSprite:
    LDA.B $04
    ASL A
    ASL A
    ASL A
    TAX
    STX.W SNES80_OAM_Write
    LDA.B $04
    LSR A
    LSR A
    AND.W #$01F8
    STA.B $0C
    LSR A
    LSR A
    CLC
    ADC.B $0C
    TAX
    STX.W SNES80_OAM_Write
    STY.W SNES80_OAM_Write
    LDX.B #$30
    STX.W SNES80_OAM_Write
    INC.B $04
    RTS

CODE_SRAMHealthCheck:
    PHP
    REP #$30
    PHA
    LDA.W #$0000
    STA.L SRAM_ArmCrash
    LDA.L WRAM_AntipiracyFlag
    BNE .WriteSuccessful
        LDA.W #ErrorCode_NoSRAM
        STA.L WRAM_ErrorCode
        BRK
    .WriteSuccessful:
    LDA.W #$0000
    STA.L WRAM_ErrorCode
    STA.L WRAM_AntipiracyFlag
    JSL.L CODE_SRAMValidation
    LDA.W #$0001
    STA.L SRAM_ArmCrash
    JSR.W CODE_InitializeSaveFile
    JSR.W CODE_ComputeSRAMChecksum
    CMP.L SRAM_SaveChecksum
    BEQ .GoodToGo
        PHA ; re-computed checksum
        LDA.L SRAM_SaveChecksum
        PHA ; saved checksum
        LDA.W #ErrorCode_SRAMChecksumFail
        STA.L WRAM_ErrorCode
        BRK
    .GoodToGo:
    LDA.W #$0000
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
    PHA ; computed checksum
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
    LDA.L WRAM_CurrentlyPlaying
    BEQ .GoToStateMachine
    LDA.W WRAM7E_GameState
    CMP.W #$0004
    BNE .SkipGameplayLogic
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

CODE_TitleScreenCustomCode3:
    print "New title screen state 3 code at ",pc
    LDA.W #$0000
    STA.L WRAM_CurrentlyPlaying
    LDA.L $7E661A
    BEQ .End
    JSR.W CODE_TitleScreenAPWiggle
    LDA.B WRAM00_Pad1Press
    ORA.B WRAM00_Pad2Press
    BEQ .End
        ; Set next title screen action to immediately be Yoshi giving the peace sign
        LDA.W #$0000
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
    JSR.W CODE_TitleScreenAPWiggle
    LDA.L $7E662C
    BEQ .End
    INC.W $02A2
    .End:
    RTL

CODE_TitleScreenAPWiggle:
    ; TODO: Wiggle the * AP sprite up and down
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
    LDA.W #$0000
    STA.L $7E952C
    STA.L $7E9532
    STA.L $7E9534
    STA.L $7E953A
    RTL

CODE_NewMainMenuState9:
    print "New main menu state 9 routine at ",pc
    ; TODO_AFTER: Disallow access to modes that are not included
    ;Debug button press
    ; TODO: Allow the player to trigger the Hint screen after clearing a mode
    LDA.L WRAM7E_Pad1Press
    BIT.W #$0060
    BEQ .SkipSpecialCheck
        ;LDA.W #$0017
        ;STA.W WRAM7E_GameState
        ;LDA.W #$0000
        ;STA.W WRAM7E_GameSubstate
        ;LDA.W #$0000
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
        LDA.W #$0000
        BRA .EndSelection
    .CursorMoved:
        JSL.L CODE_8384DB_JSR
        %play_cursor_sound()
        LDA.W #$0000
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
        JSR.W CODE_DisplaySCTracker
        BRA .RenderBG1
    .NotSC:
    CMP.W #$0003
    BNE .NotPZ
        JSR.W CODE_DisplayPZTracker
        BRA .RenderBG1
    .NotPZ:
    JSR.W CODE_DisplayVSTracker
    .RenderBG1:
    JSR.W CODE_PrintSNIState
    JSR.W CODE_RenderCustomMenuBG1
    RTL

CODE_PrintSNIState:
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

CODE_RenderCustomMenuBG1:
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
        LDA.W #$0000
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
    dw CODE_ArchipelagoDoNothing
    dw CODE_ArchipelagoWriteValue
    dw CODE_ArchipelagoWriteReceivedItem
    dw CODE_ArchipelagoGrantedLastStage
    dw CODE_ArchipelagoORValue
    dw CODE_ArchipelagoMarkComplete
    dw CODE_ArchipelagoWriteReceivedCharacter
    dw CODE_ArchipelagoAddScore
    dw CODE_ArchipelagoMarkWon
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
; Action Code 0004: ORwise set ID to arg in two places
CODE_ArchipelagoORValue:
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
CODE_ArchipelagoMarkComplete:
    LDA.W #$00F6
    STA.L WRAM7E_NewSoundEvent
    BRA CODE_ArchipelagoORValue
; Action Code 0006: play unique sound effect and set ID to arg
CODE_ArchipelagoWriteReceivedCharacter:
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
    BRA CODE_ArchipelagoWriteValue
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
; Action Code 0008: ORwise set ID to arg in two places and play unique sound
CODE_ArchipelagoMarkWon:
    LDA.W #$0013
    STA.L WRAM7E_NewSoundEvent
    BRL CODE_ArchipelagoORValue

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
; Bank A2 = Stage Clear, Puzzle, and Vs injected subroutines
;;;;;;;;;;;;
org $A28000

incsrc "StageClear.asm"
incsrc "Puzzle.asm"
incsrc "Versus.asm"

;;;;;;;;;;;;
; Bank A3 = miscellaneous
;;;;;;;;;;;;
org $A38000

; TODO_AFTER: Include Panel de Pon content
