
; TODO_AFTER: Have Stage Clear send its item slightly earlier
org $829BCE

; Change when Bowser turns red in the special stages
org $829BDD
JML.L CODE_SCBowserCustomColor

; Change when you win in the special stages
org $829D30
JSL.L CODE_SCSpecialCustomWinCondition
RTS


; Stop the CLEAR text from appearing in the Stage Clear submenu
org $83ADFD
RTS

; Change how the Stage Clear save is initialized
org $83C9B6
dw CODE_SCOptionNewGame

; Make the Stage Clear submenu allow selection after clearing a round
org $83DEAB
db $02,$02,$02
; Make the Stage Clear submenu allow selection after the Special Stage
org $83DEC2
LDA.W #$0002
org $83E044
LDA.W #$0002

; Replace Stage Clear substate 2 procedure 11 with custom code
org $83E22C
JSL.L CODE_MenuSCState2CustomCode11
RTS

; Replace Stage Clear substate 8 procedure 0 with custom code
org $83E708
JML.L CODE_ArchipelagoStageClearMenu


; Change the scale of the HP bar
org $85AF96
JML.L CODE_SCUpdateHPWithCustomIndex


; Control how Bowser's HP bar fills up at the beginning
org $87A7ED
JML.L CODE_SCBowserFillHP

; Change what Bowser's damage starts off as
org $87A8EF
JSL.L CODE_SCStartSpecialStage

; Don't toss saved score after starting Stage Clear
org $87A9BC
STZ.W $0332
STZ.W $0334
STZ.W $0336
RTS

; Disable Stage Clear tampering with the stage selection before gameplay
org $87A9F8
RTS

; Change how the Stage Clear save is initialized
org $87AA07
JML.L CODE_NewStageClearCustomSave

; Inject subroutine for Stage Clear win
org $87C83F
JSL.L CODE_OnStageClearWin
RTS

; Inject subroutine for Stage Clear top out
org $87C871
JSL.L CODE_OnStageClearTopOut
RTS

; Set a new spot for what score to load
org $87D4A3
JML.L CODE_LoadCustomScore

; Inject subroutine when results screen is going to the next stage for the password
org $87E1E8
JSL.L CODE_StageClearResultSummonNextStage
RTS


; Cap the damage inflicted to Bowser to 500
org $89AD70
JSL.L CODE_SCInflictDamageCapped
