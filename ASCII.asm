DATA16_ASCIITable:
    dw $FFFF,$000C,$000C,$000C,$000C,$000C,$000C,$000C ; ⌂???????
    dw $000C,$000C,$FFFF,$000C,$000C,$000C,$000C,$000C ; ??⌂?????
    dw $000C,$FFFF,$FFFF,$FFFF,$FFFF,$000C,$000C,$000C ; ?⌂⌂⌂⌂???
    dw $000C,$000C,$000C,$000C,$000C,$000C,$000C,$000C ; ????????
    dw $FFFF,$000B,$002B,$002C,$002D,$0015,$0003,$002E ;  !"#$%&'
    dw $002F,$402F,$003E,$0030,$0025,$0026,$0024,$0031 ; ()*+,-./
    dw $002A,$001E,$0004,$000E,$0005,$0017,$0011,$0010 ; 01234567
    dw $001B,$0014,$0032,$0033,$0034,$0035,$4034,$000C ; 89:;<=>?
    dw $0036,$0020,$0013,$001C,$0008,$0029,$001F,$0019 ; @ABCDEFG
    dw $0006,$0028,$0018,$000D,$0007,$001D,$0000,$0021 ; HIJKLMNO
    dw $000F,$001A,$0009,$0016,$0002,$0027,$0022,$0023 ; PQRSTUVW
    dw $0001,$0012,$000A,$0037,$4031,$4037,$0038,$0039 ; XYZ[\]^_
    dw $003A,$0020,$0013,$001C,$0008,$0029,$001F,$0019 ; `abcdefg
    dw $0006,$0028,$0018,$000D,$0007,$001D,$0000,$0021 ; hijklmno
    dw $000F,$001A,$0009,$0016,$0002,$0027,$0022,$0023 ; pqrstuvw
    dw $0001,$0012,$000A,$003B,$003C,$403B,$003D,$000C ; xyz{|}~?

    dw $001C,$0027,$0029,$0020,$0020,$0020,$0020,$001C ; Çüéâäàåç
    dw $0029,$0029,$0029,$0028,$0028,$0028,$0020,$0020 ; êëèïîìÄÅ
    dw $0029,$000C,$000C,$0021,$0021,$0021,$0027,$0027 ; ÉæÆôöòûù
    dw $0012,$0021,$0027,$000C,$000C,$000C,$000C,$000C ; ÿÖÜ¢£¥₧ƒ
    dw $0020,$0028,$0021,$0027,$0000,$0000,$000C,$000C ; áíóúñÑªº
    dw $C00C,$000C,$000C,$000C,$000C,$800B,$000C,$000C ; ¿⌐¬½¼¡«»
    dw $000C,$000C,$000C,$003C,$000C,$000C,$000C,$000C ; ░▒▓│┤╡╢╖
    dw $000C,$000C,$000C,$000C,$000C,$000C,$000C,$000C ; ╕╣║╗╝╜╛┐
    dw $000C,$000C,$000C,$000C,$0026,$0030,$000C,$000C ; └┴┬├─┼╞╟
    dw $000C,$000C,$000C,$000C,$000C,$0035,$000C,$000C ; ╚╔╩╦╠═╬╧
    dw $000C,$000C,$000C,$000C,$000C,$000C,$000C,$000C ; ╨╤╥╙╘╒╓╫
    dw $000C,$000C,$000C,$000C,$000C,$000C,$000C,$000C ; ╪┘┌█▄▌▐▀
    dw $000C,$000C,$8007,$000C,$000C,$000C,$000C,$000C ; αßΓπΣσµτ
    dw $000C,$000C,$000C,$000C,$000C,$000C,$000C,$8027 ; ΦΘΩδ∞φε∩
    dw $000C,$000C,$000C,$000C,$000C,$000C,$000C,$000C ; ≡±≥≤⌠⌡÷≈
    dw $000C,$000C,$000C,$000C,$000C,$000C,$000C,$FFFF ; °∙·√ⁿ²■⌂
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
    LDA.W #$32C0 ; priority 3 palette 1, offset $0C0
    STA.B $D6
    LDA.B [$D3]
    INC.B $D3
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
    ;$D6 will be the base properties for all text
    ;A represents the number of characters
    ;Use LDA.B [$D3];INC.B $D3 if the first character is the length or 255 if \0 terminated
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
    LDA.B [$D3]
    AND.W #$00FF
    ASL A
    TAX
    LDA.L DATA16_ASCIITable,X
    CMP.W #$FFFF
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
    INC.B $D3
    BRL .CharacterLoop
    .End:
    STY.W WRAM_OAMAppendAddr
    PLB
    RTL

GFX_MissingASCII:
incbin "missingascii.bin"