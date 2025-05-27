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

; Enable 2 KB SRAM for offline mode progress and safe WRAM
org $80FFD8
db $01

; Set version number
org $80FFDB
db $01


; Replace anti-piracy flag check with SRAM health check
org $808200
JSL CODE_SRAMHealthCheck
BRA CODE_80820C

; Inject logic into the overarching state machine
org $80A6FB
JML.L CODE_StateMachineLogic


; Mess with the 1Player Game tilemap
org $83A3E7
dw $024C,$A85C
db $24,$0E,$0B

; Modify the menu tilemaps
org $83C072
JSL.L CODE_MenuDataModification
RTS

; Replace main menu substate 2 with custom code
org $83C0AE
JSL.L CODE_NewMainMenuState2
RTS

; Replace main menu substate 5 to go to substate 0
org $83C15E
STZ.W WRAM7E_GameSubstate
JMP.W CODE_MainMenuState0

; Replace main menu substate 8 procedure 4 with custom code
org $83C4BA
JSL.L CODE_NewMainMenuState8
RTS

; Do not reset option index when coming from Vs
org $83C4C6
NOP : NOP : NOP : NOP

; Replace main menu substate 9 with custom code
org $83C4DB
JSL.L CODE_NewMainMenuState9
RTS

; Replace option data in substate 9
org $83C51B
db $16,$1B,$36 ; proceed to Stage Clear, proceed to Puzzle, proceed to custom Vs menu

; Don't display the password options box
org $83C769
JMP.W $83C76F

; Skip main menu substate 18 procedure 5
org $83C79F
JMP.W $83C7AD

; Make the Stage Clear and Puzzle submenus go back to the 1Player Game menu
org $83C7B6
LDA.W #$0015
org $83C7BB
LDA.W #$001A

; Skip main menu substate 21 procedure 1
org $83C8F9
JMP.W CODE_83C909

; Replace main menu substate 21 procedure 2 with custom code
org $83C928
JSL CODE_NewMainMenuState21
RTS


; Change what the hint screen prints
org $86DF29
;LDA.W #$0029
org $8493FF ;TODO: Figure out the text graphics
;RTL


; Remove password text literal
org $89D5F7
RTL

; Remove password code printing
org $89D69F
RTL


; Redirect the title screen button check code in states 3 and 4
org $8ABC4E
JSL CODE_TitleScreenCustomCode3
RTS
org $8ABDF9
JSL CODE_TitleScreenCustomCode4
RTS


; Add entry points to word subroutines
org $82F59E
CODE_82B574_JSR:
    JSR.W CODE_82B574
    RTL
CODE_82E1AF_JSR:
    PHB
    PEA.W $8200
    PLB
    PLB
    JSR.W $82E1AF
    PLB
    RTL
CODE_82E2D6_JSR:
    PHB
    PEA.W $8200
    PLB
    PLB
    JSR.W CODE_82E2D6
    PLB
    RTL

org $83FB2D
CODE_8384DB_JSR:
    LDA.W #$0000
    STA.L $7E9965
    STA.L $7E9979
    RTL
CODE_838E7D_JSR:
    JSR.W CODE_838E7D
    RTL
CODE_839565_JSR:
    JSR.W CODE_839565
    RTL
CODE_8397A1_JSR:
    JSR.W CODE_8397A1
    RTL
CODE_839958_JSR:
    JSR.W CODE_839958
    RTL
CODE_MenuYoshiDialog_JSR:
    JSR.W CODE_MenuYoshiDialog
    RTL
CODE_83A058_JSR:
    JSR.W CODE_83A058
    RTL
CODE_83A9E3_JSR:
    JSR.W CODE_83A9E3
    RTL
CODE_83AEB0_JSR:
    JSR.W CODE_83AEB0
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
CODE_83E666_JSR:
    JSR.W CODE_83E666
    RTL
CODE_83E6C0_JSR:
    JSR.W CODE_83E6C0
    RTL
CODE_MenuPZSetPuzzleIndex_JSR:
    JSR.W CODE_MenuPZSetPuzzleIndex
    RTL
CODE_83EDCC_JSR:
    JSR.W CODE_83EDCC
    RTL
CODE_83EE11_JSR:
    JSR.W CODE_83EE11
    RTL
CODE_83EE98_JSR:
    JSR.W CODE_83EE98
    RTL
