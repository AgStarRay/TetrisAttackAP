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

; Filter certain music events
org $8091D4
JML.L CODE_FilterMusicEvent

; Inject logic into the overarching state machine
org $80A6FB
JML.L CODE_StateMachineLogic


; Have the Archipelago display be rendered every frame while Stop time is inactive
org $829439
BEQ CODE_829449
org $829453
BEQ CODE_829449

; Replace the level display for Endless and Stage Clear
org $8297E1
JML.L CODE_CustomLevelDisplay
NOP

; Display the password text on the pause screen in Stage Clear 1-1
org $82A3AC
BRA CODE_82A3BC
; Display the password text on the pause screen in Puzzle 1-01
org $82A3CD
BRA $82A3D5
; Display the password text on the pause screen in Versus stage 1
org $82A720
BRA CODE_82A72C

; Control when shock panels generate
org $82E8E1
JSL.L CODE_NewShockPanelLogic

; Create event call when a shock panel is generated
org $82EB05
JSL.L CODE_OnShockPanelCreated
RTS

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
STZ.W WRAM_GameSubstate
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


; Intercept after random stack creation
org $87948F
JSL.L CODE_OnStackCreated

; Add more ASCII characters
org $87B99C
JML.L CODE_UploadFullASCII

; Display the password text on the game over screen in Stage Clear 1-1
org $87D355
BRA CODE_87D365
; Display the password text on the game over screen in Puzzle 1-1
org $87D38E
BCC CODE_87D398


; Change the password text literal to a custom message provided by SNI
org $89D5F7
JML.L CODE_CustomMessage

; Remove password code printing
org $89D69F
RTL

; Hide password text during Stage Clear cutscenes
org $89ED6A
NOP : NOP : NOP : NOP

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
    JSR.W CODE_FN_82B574
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
    JSR.W CODE_FN_838E7D
    RTL
CODE_839565_JSR:
    JSR.W CODE_FN_839565
    RTL
CODE_8397A1_JSR:
    JSR.W CODE_FN_8397A1
    RTL
CODE_839958_JSR:
    JSR.W CODE_FN_839958
    RTL
CODE_MenuYoshiDialog_JSR:
    JSR.W CODE_MenuYoshiDialog
    RTL
CODE_83A058_JSR:
    JSR.W CODE_FN_83A058
    RTL
CODE_83A9E3_JSR:
    JSR.W CODE_FN_83A9E3
    RTL
CODE_83AEB0_JSR:
    JSR.W CODE_FN_83AEB0
    RTL
CODE_83B0AC_JSR:
    JSR.W CODE_FN_83B0AC
    RTL
CODE_83B0B5_JSR:
    JSR.W CODE_FN_83B0B5
    RTL
CODE_83B59B_JSR:
    JSR.W CODE_FN_83B59B
    RTL
CODE_83B5A8_JSR:
    JSR.W CODE_FN_83B5A8
    RTL
CODE_83E666_JSR:
    JSR.W CODE_FN_83E666
    RTL
CODE_83E6C0_JSR:
    JSR.W CODE_FN_83E6C0
    RTL
CODE_MenuPZSetPuzzleIndex_JSR:
    JSR.W CODE_MenuPZSetPuzzleIndex
    RTL
CODE_83EDCC_JSR:
    JSR.W CODE_FN_83EDCC
    RTL
CODE_83EE11_JSR:
    JSR.W CODE_FN_83EE11
    RTL
CODE_83EE98_JSR:
    JSR.W CODE_FN_83EE98
    RTL
