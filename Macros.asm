macro append_sprite(pos_x, pos_y, sprite)
    LDA.W #(<pos_y>*256+<pos_x>)
    STA.W WRAM7E_OAMBuffer,Y
    INY
    INY
    LDA.W #<sprite>
    STA.W WRAM7E_OAMBuffer,Y
    INY
    INY
endmacro

macro append_sprite_sub(subroutine, sprite)
    JSR.W <subroutine>
    STA.W WRAM7E_OAMBuffer,Y
    INY
    INY
    LDA.W #<sprite>
    STA.W WRAM7E_OAMBuffer,Y
    INY
    INY
endmacro

macro append_text(pos_x, pos_y, src_ptr, base_sprite)
    LDA.W #<pos_x>
    STA.B $CF
    LDA.W #<pos_y>
    STA.B $D1
    LDA.W #<src_ptr[1]>
    STA.B $D4
    LDA.W #<src_ptr[0]>
    STA.B $D3
    LDA.W #<base_sprite>
    STA.B $D6
    JSL.L CODE_AppendText
endmacro

macro load_goal_difficulty()
    LDA.L DATA8_GoalVersus
    AND.W #%00011
endmacro

macro play_cursor_sound()
    LDA.W #$0001
    STA.W WRAM7E_NewSoundEvent
endmacro

macro play_cancel_sound()
    LDA.W #$0004
    STA.W WRAM7E_NewSoundEvent
endmacro

macro play_accept_sound()
    LDA.W #$0005
    STA.W WRAM7E_NewSoundEvent
endmacro

;TODO_AFTER: Use more macros to lower duplicate sequences of instructions
