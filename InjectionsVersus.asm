
; Completely replace menu substate 54
org $83C7C5
JSL.L CODE_ArchipelagoVsMenu
RTS

; Change how the Vs save is initialized
org $83CA21
dw CODE_VSOptionNewGame

; Always let Vs load the custom save
org $83CA41
LDA.W #$0001

; Change how the Vs save is loaded
org $86F1CE
JML.L CODE_NewVsCustomSave

; Inject subroutine for Vs top out
org $87E7D6
JSL.L CODE_OnVsTopOut

; Control when the Vs stage number advances
org $87F1F4
JML.L CODE_VsCustomAdvance

; Replace overworld substate 2 with custom code
org $8B814D
JSL.L CODE_CustomVsSubstate2
RTS

; Inject subroutine into overworld substate 5
org $8B8CC3
JSL.L CODE_CustomVsSubstate5

; Change what variables get wiped
org $8B94E2
LDX.W #$003B
STZ.W WRAM_VsProcedureFlags,X
org $8B8079
LDA.W #$0000
STA.L WRAM_VsMenuSubstate

; Control what happens after fading out in substate 5
org $8BA85A
JSL.L CODE_CustomVsSubstate5End
RTL

; Replace overworld substate 6 with custom code
org $8BA8A8
JSL.L CODE_CustomVsSubstate6
RTS

; Remove password from overworld
org $8BA391
RTL
; Remove password from Cave of Wickedness
org $8BA3B9
RTL

; Disallow going to the next stage in the overworld if they don't have access (triggers when the "I'm free" message disappears)
org $8BA7AD
JML.L CODE_VsAllowNextStageOverworld

; Point Vs to the new written last stages table
org $8BA9C8
LDA.L DATA8_VsCustomLastStages,X

; Disallow going to the next stage in Mt. Wickedness if they don't have access (triggers when Yoshi starts moving)
org $8BF19E
JML.L CODE_VsAllowNextStageRunning

; Update the characters the player has
org $8B8EDD
JSL.L CODE_UpdateVsCharacterStates
JMP.W CODE_8B8EFB

; Make the "I'm free" message conditional
org $8BA79B
JML.L CODE_ConditionalImFreeMsg
