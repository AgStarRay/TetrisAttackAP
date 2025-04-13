; New crash handler
org $808000
BRK
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

; Add entry points to word subroutines
org $82F59E
CODE_82E2D6_JSR:
PHB
PEA.W UNREACH_828200
PLB
PLB
JSR.W CODE_82E2D6
PLB
RTL
CODE_82E1AF_JSR:
PHB
PEA.W UNREACH_828200
PLB
PLB
JSR.W $82E1AF
PLB
RTL

; Set a new spot for what score to load
org $87D4A3
JML.L CODE_LoadCustomScore

; Change when Bowser turns red in the special stages
org $829BDD
JML.L CODE_SCBowserCustomColor

; Change when you win in the special stages
org $829D30
JSL.L CODE_SCSpecialCustomWinCondition
RTS
CODE_82B574_JSR:
JSR.W CODE_82B574
RTL

; Load the correct puzzle number and prevent recalculation of the puzzle stage index
org $87AA88
JSL.L CODE_SetNewPuzzleIndex
JSR.W CODE_EndlessStart
RTS
org $87AAD5
JSL.L CODE_SetNewPuzzleIndex
JSR.W CODE_EndlessStart
RTS

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

; Replace Puzzle substate 2 procedure 9 with custom code
org $83ED18
JML.L CODE_MenuPZState2CustomCode9

; Replace Puzzle substate 2 procedure 10 with custom code
org $83EBA0
JML.L CODE_MenuPZState2CustomCode10

; Change how the Stage Clear save is initialized
org $83C9B6
dw CODE_SCOptionNewGame
org $87AA07
JML.L CODE_NewStageClearCustomSave

; Change how the Puzzle save is initialized
org $83C9F8
dw CODE_PZOptionNewGame
org $87AB2D
JML.L CODE_NewPuzzleCustomSave


; Replace option data in substate 9 to the lower 3 options
; This code restricts access to Stage Clear, Puzzle, and Vs
org $83C4F9
db $02 ; The last option index; the new state 9 code below subtracts the tracked value by 2 to match
org $83C519
db $16,$1B,$39,$04 ; proceed to Stage Clear, proceed to Puzzle, proceed to Vs, fade-out to title screen

; Set new 1Player default option
org $83C4C3
LDA.W #$0002
STA.L WRAM_1POptionIndex
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
; Make the Stage Clear submenu allow selection after the Special Stage
org $83DEC2
LDA.W #$0002
org $83E044
LDA.W #$0002
; Make the Vs mode go back to the 1Player Game menu
org $83C1F7
db $38

; Make the Puzzle submenu allow selection of any puzzle
org $83EE9F
BRA CODE_83EEDF

; Replace Stage Clear substate 8 procedure 0 with custom code
org $83E708
JML.L CODE_ArchipelagoStageClearMenu
CODE_838E7D_JSR:
    JSR.W CODE_838E7D
    RTL

; Replace Puzzle substate 3 procedure 0 with custom code
org $83ED2F
JSL.L CODE_ArchipelagoPuzzleMenu
RTS
CODE_839958_JSR:
    JSR.W CODE_839958
    RTL
CODE_83B0AC_JSR:
    JSR.W CODE_83B0AC
    RTL
CODE_83B0B5_JSR:
    JSR.W CODE_83B0B5
    RTL
CODE_83B59B_JSR:
    JSR.W CODE_83B59B
    RTL
CODE_83B5A8_JSR:
    JSR.W CODE_83B5A8
    RTL
CODE_83EDCC_JSR:
    JSR.W CODE_83EDCC
    RTL
CODE_83EE11_JSR:
    JSR.W CODE_83EE11
    RTL
CODE_MenuPZSetPuzzleIndex_JSR:
    JSR.W CODE_MenuPZSetPuzzleIndex
    RTL
CODE_83EE98_JSR:
    JSR.W CODE_83EE98
    RTL
CODE_83A9E3_JSR:
    JSR.W CODE_83A9E3
    RTL

; TODO: Add new submenu for Vs.

; Change the scale of the HP bar
org $85AF96
JML.L CODE_SCUpdateHPWithCustomIndex

; Control how Bowser's HP bar fills up at the beginning
org $87A7ED
JML.L CODE_SCBowserFillHP

; Don't toss saved score after starting Stage Clear
org $87A9BC
STZ.W $0332
STZ.W $0334
STZ.W $0336
RTS

; TODO_AFTER: Have Stage Clear send its item slightly earlier
org $829BCE

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

; Inject subroutine for Puzzle win, where the music fades out after clearing the last puzzle
org $82955E
JSL.L CODE_OnPuzzleWin
BRA CODE_82956A

; Inject subroutine for Puzzle fanfare
org $87C8A9
JSL.L CODE_PuzzleFanfare
RTS

; Inject subroutine for Puzzle fail
org $87C8C4
JSL.L CODE_OnPuzzleFail
RTS

; Inject subroutine when results screen is going to the next stage for the password
org $87E233
JSL.L CODE_PuzzleResultSummonNextStage
RTS

; Inject subroutine that loads new music after clearing the last puzzle
org $87C601
JSL.L CODE_PuzzleCustomRoundClearCheck
JMP.W CODE_87C613

; Inject subroutine for custom credits check
org $87E1B8
JSL.L CODE_PuzzleCustomCreditsCheck
RTS

; Change what Bowser's damage starts off as
org $87A8EF
JSL.L CODE_SCStartSpecialStage

; Disable Stage Clear tampering with the stage selection before gameplay
org $87A9F8
RTS

; Cap the damage inflicted to Bowser to 500
org $89AD70
JSL.L CODE_SCInflictDamageCapped
