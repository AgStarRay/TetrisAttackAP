DATA16_ASCIITable:
    dw $0000,$00CC,$00CC,$00CC,$00CC,$00CC,$00CC,$00CC ; ⌂???????
    dw $00CC,$00CC,$0000,$00CC,$00CC,$00CC,$00CC,$00CC ; ??⌂?????
    dw $00CC,$0000,$0000,$0000,$0000,$00CC,$00CC,$00CC ; ?⌂⌂⌂⌂???
    dw $00CC,$00CC,$00CC,$00CC,$00CC,$00CC,$00CC,$00CC ; ????????
    dw $0000,$00CB,$00EB,$00EC,$00ED,$00D5,$00C3,$00EE ;  !"#$%&'
    dw $00EF,$40EF,$00FE,$00F0,$00E5,$00E6,$00E4,$00F1 ; ()*+,-./
    dw $00EA,$00DE,$00C4,$00CE,$00C5,$00D7,$00D1,$00D0 ; 01234567
    dw $00DB,$00D4,$00F2,$00F3,$00F4,$00F5,$40F4,$00CC ; 89:;<=>?
    dw $00F6,$00E0,$00D3,$00DC,$00C8,$00E9,$00DF,$00D9 ; @ABCDEFG
    dw $00C6,$00E8,$00D8,$00CD,$00C7,$00DD,$00C0,$00E1 ; HIJKLMNO
    dw $00CF,$00DA,$00C9,$00D6,$00C2,$00E7,$00E2,$00E3 ; PQRSTUVW
    dw $00C1,$00D2,$00CA,$00F7,$40F1,$40F7,$00F8,$00F9 ; XYZ[\]^_
    dw $00FA,$00E0,$00D3,$00DC,$00C8,$00E9,$00DF,$00D9 ; `abcdefg
    dw $00C6,$00E8,$00D8,$00CD,$00C7,$00DD,$00C0,$00E1 ; hijklmno
    dw $00CF,$00DA,$00C9,$00D6,$00C2,$00E7,$00E2,$00E3 ; pqrstuvw
    dw $00C1,$00D2,$00CA,$00FB,$00FC,$40FB,$00FD,$00CC ; xyz{|}~?

    dw $00DC,$00E7,$00E9,$00E0,$00E0,$00E0,$00E0,$00DC ; Çüéâäàåç
    dw $00E9,$00E9,$00E9,$00E8,$00E8,$00E8,$00E0,$00E0 ; êëèïîìÄÅ
    dw $00E9,$00CC,$00CC,$00E1,$00E1,$00E1,$00E7,$00E7 ; ÉæÆôöòûù
    dw $00D2,$00E1,$00E7,$00CC,$00CC,$00CC,$00CC,$00CC ; ÿÖÜ¢£¥₧ƒ
    dw $00E0,$00E8,$00E1,$00E7,$00C0,$00C0,$00CC,$00CC ; áíóúñÑªº
    dw $C0CC,$00CC,$00CC,$00CC,$00CC,$80CB,$00CC,$00CC ; ¿⌐¬½¼¡«»
    dw $00CC,$00CC,$00CC,$00FC,$00CC,$00CC,$00CC,$00CC ; ░▒▓│┤╡╢╖
    dw $00CC,$00CC,$00CC,$00CC,$00CC,$00CC,$00CC,$00CC ; ╕╣║╗╝╜╛┐
    dw $00CC,$00CC,$00CC,$00CC,$00E6,$00F0,$00CC,$00CC ; └┴┬├─┼╞╟
    dw $00CC,$00CC,$00CC,$00CC,$00CC,$00F5,$00CC,$00CC ; ╚╔╩╦╠═╬╧
    dw $00CC,$00CC,$00CC,$00CC,$00CC,$00CC,$00CC,$00CC ; ╨╤╥╙╘╒╓╫
    dw $00CC,$00CC,$00CC,$00CC,$00CC,$00CC,$00CC,$00CC ; ╪┘┌█▄▌▐▀
    dw $00CC,$00CC,$80C7,$00CC,$00CC,$00CC,$00CC,$00CC ; αßΓπΣσµτ
    dw $00CC,$00CC,$00CC,$00CC,$00CC,$00CC,$00CC,$80E7 ; ΦΘΩδ∞φε∩
    dw $00CC,$00CC,$00CC,$00CC,$00CC,$00CC,$00CC,$00CC ; ≡±≥≤⌠⌡÷≈
    dw $00CC,$00CC,$00CC,$00CC,$00CC,$00CC,$00CC,$0000 ; °∙·√ⁿ²■⌂
DATA_ExistingASCIIVRAMDMA:
    dl $7F5D00
    dw $1C00
    db $80
    dw $0000
DATA_MissingASCIIVRAMDMA:
    dl GFX_MissingASCII
    dw $0400
    db $80
    dw $0E00

CODE_UploadFullASCII:
    PHB
    PHK
    PLB
    LDY.W #DATA_ExistingASCIIVRAMDMA
    JSL.L CODE_CreateVRAMDMA
    LDY.W #DATA_MissingASCIIVRAMDMA
    JSL.L CODE_CreateVRAMDMA
    PLB
    JML.L CODE_87B9B1
CODE_CustomMessage:
    TXA
    SEC
    SBC.W #$0030
    STA.B $CF
    TYA
    SEC
    SBC.W #$000A
    STA.B $D1
    LDA.W WRAM_GameState
    CMP.W #$0005
    BEQ .GameResultMessage
    .StatusMessage:
        LDA.W #WRAM_StatusMessage
        STA.B $D3
        LDA.W #bank(WRAM_StatusMessage)
        STA.B $D5
        BRA .Display
    .GameResultMessage:
        LDA.W #SNI_Message
        STA.B $D3
        LDA.W #bank(SNI_Message)
        STA.B $D5
    .Display:
    LDA.W #$3200 ; priority 3 palette 1
    STA.B $D6
    JSL.L CODE_AppendText
    RTL
TEXT_TestMessage:
    db 22,"This is a",$0A,"test message"
TEXT_TestMessageLonger:
    db 43,"This is a",$0A,"[longer] test",$0A,"message,",$0A,"AgStarRay!"


CODE_AppendText:
    ;$CF will be the X position
    ;$D1 will be the Y position
    ;$D3 will be a 24-bit address to the character data, meaning $D5 contains the bank
    ;The first character of the string is interpreted as a length, but the string can also be \0 terminated
    ;$D6 will be the base properties for all text
    LDA.B [$D3]
    AND.W #$00FF
    BNE .ProceedA
        RTL
    .ProceedA:
    STA.B $E4
    ASL A
    ASL A
    CLC
    ADC.W WRAM_OAMAppendAddr
    CMP.W #$0200
    BCC .ProceedB
        RTL
    .ProceedB:
    PHB
    PHK
    PLB
    LDA.B $CF
    STA.B $D8
    LDY.W WRAM_OAMAppendAddr
    ;$D8 is the current X position
    ;$E4 is the number of characters left
    ;Y is address offset for OAM
    .CharacterLoop:
    INC.B $D3
    LDA.B [$D3]
    AND.W #$00FF
    ASL A
    TAX
    LDA.L DATA16_ASCIITable,X
    BEQ .SpecialCharacter
    .NormalCharacter:
        PHA
        LDA.B $D8
        STA.W WRAM_OAMBuffer,Y
        CLC
        ADC.W #$0008
        STA.B $D8
        INY
        LDA.B $D1
        STA.W WRAM_OAMBuffer,Y
        INY
        PLA
        ORA.B $D6
        STA.W WRAM_OAMBuffer,Y
        INY
        INY
        BRA .DoneWithCharacter
    .SpecialCharacter:
        LDA.B [$D3]
        AND.W #$00FF
        BEQ .End
        CMP.W #$000A
        BEQ .LineFeed
        CMP.W #$0011
        BEQ .Color1
        CMP.W #$0012
        BEQ .Color2
        CMP.W #$0013
        BEQ .Color3
        .Space:
            LDA.B $D8
            CLC
            ADC.W #$0008
            STA.B $D8
            BRA .DoneWithCharacter
        .Color1:
            LDA.B $D6
            AND.W #$F1FF
            ORA.W #$0200
            STA.B $D6
            BRA .DoneWithCharacter
        .Color2:
            LDA.B $D6
            AND.W #$F1FF
            ORA.W #$0400
            STA.B $D6
            BRA .DoneWithCharacter
        .Color3:
            LDA.B $D6
            AND.W #$F1FF
            ORA.W #$0600
            STA.B $D6
            BRA .DoneWithCharacter
        .LineFeed:
            LDA.B $CF
            STA.B $D8
            LDA.B $D1
            CLC
            ADC.W #$0008
            STA.B $D1
    .DoneWithCharacter:
    DEC.B $E4
    BEQ .End
    BRL .CharacterLoop
    .End:
    STY.W WRAM_OAMAppendAddr
    PLB
    RTL

GFX_MissingASCII:
incbin "missingascii.bin"