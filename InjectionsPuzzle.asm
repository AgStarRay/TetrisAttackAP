
; Inject subroutine for Puzzle win, where the music fades out after clearing the last puzzle
org $82955E
JSL.L CODE_OnPuzzleWin
BRA CODE_82956A


; Double the scroll speed of the submenu
org $83ECA1
LDA.W #$0010
org $83EDE9
LDA.W #$0008
org $83EE32
LDA.W #$0008
org $83EF14
LDA.W #$0010

; Change how the Puzzle save is initialized
org $83C9F8
dw CODE_PZOptionNewGame

; Replace Puzzle substate 2 procedure 10 with custom code
org $83EBA0
JML.L CODE_MenuPZState2CustomCode10

; Replace Puzzle substate 2 procedure 9 with custom code
org $83ED18
JML.L CODE_MenuPZState2CustomCode9

; Replace Puzzle substate 3 procedure 0 with custom code
org $83ED2F
JSL.L CODE_ArchipelagoPuzzleMenu
RTS

; Make the Puzzle submenu allow selection of any puzzle
org $83EE9F
BRA CODE_83EEDF


; Load the correct puzzle number and prevent recalculation of the puzzle stage index
org $87AA88
JSL.L CODE_SetNewPuzzleIndex
JSR.W CODE_EndlessStart
RTS
org $87AAD5
JSL.L CODE_SetNewPuzzleIndex
JSR.W CODE_EndlessStart
RTS

; Change how the Puzzle save is initialized
org $87AB2D
JML.L CODE_NewPuzzleCustomSave

; Inject subroutine that loads new music after clearing the last puzzle
org $87C601
JSL.L CODE_PuzzleCustomRoundClearCheck
JMP.W CODE_87C613

; Inject subroutine for Puzzle fanfare
org $87C8A9
JSL.L CODE_PuzzleFanfare
RTS

; Inject subroutine for Puzzle fail
org $87C8C4
JSL.L CODE_OnPuzzleFail
RTS

; Inject subroutine for custom credits check
org $87E1B8
JSL.L CODE_PuzzleCustomCreditsCheck
RTS

; Inject subroutine when results screen is going to the next stage for the password
org $87E233
JSL.L CODE_PuzzleResultSummonNextStage
RTS
