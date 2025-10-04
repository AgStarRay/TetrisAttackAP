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
    JSR.W SUB_DebugAddSprite
    LDY.B #$10
    JSR.W SUB_DebugAddSprite
    LDY.B #$0A
    JSR.W SUB_DebugAddSprite
    LDY.B #$11
    JSR.W SUB_DebugAddSprite
    LDY.B #$12
    JSR.W SUB_DebugAddSprite
    LDA.W #$001C
    STA.B $04
    LDY.B #$0D
    JSR.W SUB_DebugAddSprite
    LDY.B #$16
    JSR.W SUB_DebugAddSprite
    PLY
    JSR.W SUB_DebugPrintByte ; DB
    DEC.B $04
    LDY.B #$17
    JSR.W SUB_DebugAddSprite
    LDA.W $06
    BIT.W #$0020 ; Check if P had M set
    BEQ .MWasNotSet
        PLY
        JSR.W SUB_DebugPrintByte ; A (8-bit)
        BRA .DoneWithA
    .MWasNotSet:
        PLA
        JSR.W SUB_DebugPrintWord ; A (16-bit)
    .DoneWithA:
    LDY.B #$18
    JSR.W SUB_DebugAddSprite
    LDA.W $06
    BIT.W #$0010 ; Check if P had X set
    BEQ .XWasNotSet
        PLY
        JSR.W SUB_DebugPrintByte ; X (8-bit)
        LDY.B #$19
        JSR.W SUB_DebugAddSprite
        PLY
        JSR.W SUB_DebugPrintByte ; Y (8-bit)
        BRA .DoneWithXY
    .XWasNotSet:
        PLA
        JSR.W SUB_DebugPrintWord ; X (16-bit)
        LDY.B #$19
        JSR.W SUB_DebugAddSprite
        PLA
        JSR.W SUB_DebugPrintWord ; Y (16-bit)
    .DoneWithXY:
    LDA.W #$0012
    STA.B $04
    LDY.B #$14
    JSR.W SUB_DebugAddSprite
    TSC
    INC A
    INC A
    INC A
    INC A
    JSR.W SUB_DebugPrintWord ; S
    LDA.W #$0018
    STA.B $04
    LDY.B #$15
    JSR.W SUB_DebugAddSprite
    LDA.B $01,S
    TAY
    JSR.W SUB_DebugPrintByte ; P
    LDA.W #$0006
    STA.B $04
    LDA.L WRAM_ErrorCode
    JSR.W SUB_DebugPrintWord ; Error code
    DEC.B $04
    LDY.B #$13
    JSR.W SUB_DebugAddSprite
    LDA.B $04,S
    TAY
    JSR.W SUB_DebugPrintByte ; PB
    DEC.B $04
    LDA.B $02,S
    DEC A ; BRK stores S after execution, meaning PC is 2 higher than the cause
    DEC A
    JSR.W SUB_DebugPrintWord ; PC
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
        JSR.W SUB_DebugPrintByte
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

SUB_DebugPrintWord:
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
    JSR.W SUB_DebugAddSprite
    LDA.B $0A
    AND.W #$0F00
    XBA
    TAY
    JSR.W SUB_DebugAddSprite
    LDY.B $09
    JSR.W SUB_DebugPrintByte
    RTS
SUB_DebugPrintByte:
    STY.B $08
    TYA
    AND.W #$00F0
    LSR A
    LSR A
    LSR A
    LSR A
    TAY
    JSR.W SUB_DebugAddSprite
    LDY.B $08
    TYA
    AND.W #$000F
    TAY
    JSR.W SUB_DebugAddSprite
    INC.B $04
    RTS
SUB_DebugAddSprite:
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
