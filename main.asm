
#importonce

BasicStub(0, "SummerDemo for Vic20", Entry)
Entry: {
    Init()

  !:
    jsr WaitForRasterLineZero

    jmp !-
}

.macro Init() {
    ChangeScreenColor(%11111111)

// Move charset location to $1c00
    MoveCharsetLocation($0f)

    LoadMap()
    PaintMap()
}

.macro LoadMap() {
    ldx #0
  !:
    lda Map, x
    sta ScreenRam, x
    dex
    bne !-

    ldx #$fc
  !:
    lda Map + $ff, x
    sta ScreenRam + $ff, x
    dex
    bne !-
}

.macro PaintMap() {
    ldx #$00
  !PaintCols:
    ldy ScreenRam, x
    lda CharsetColorMap, y
    sta $9600, x
    dex
    bne !PaintCols-

    ldx #$fc
  !PaintCols:
    ldy ScreenRam + $ff, x
    lda CharsetColorMap, y
    sta $96ff, x
    dex
    bne !PaintCols-
}

DrawWave: {
    lda CrestOfWave
    sta UpdateCurrentChar + 1
    lda CrestOfWave + 1
    sta UpdateCurrentChar + 2

// Replace current crest with original char
    lda CharSaved
  UpdateCurrentChar:
    sta $beef    

    lda CrestCount
    cmp #5
    beq ResetWave

// Get next crest position
    sub16byte(23, CrestOfWave)

// Save next char that will be replaced by crest
    lda CrestOfWave
    sta ReadNextChar + 1
    sta UpdateNextChar + 1
    lda CrestOfWave + 1
    sta ReadNextChar + 2
    sta UpdateNextChar + 2

  ReadNextChar:
    lda $beef
    sta CharSaved

// Draw new crest
    lda #Crest
  UpdateNextChar:
    sta $beef
    inc CrestCount
    jmp Done

  ResetWave:
    lda #0
    sta CrestCount

    lda FirstCrestOfWave
    sta CrestOfWave
    lda FirstCrestOfWave + 1
    sta CrestOfWave + 1

  Done:
    rts

    .label FirstCrestOfWave = ScreenRam + (22 * 22)
    CrestOfWave: .word FirstCrestOfWave
    CharSaved: .byte 18

    .label Crest = 19;

    CrestCount: .byte $00
}

TimerTick: {
    jsr DrawWave

    rts
}

WaitForRasterLineZero: {
  !:
    lda $9004
    bne !-

    inc CurrentFrame

    lda CurrentFrame
    lsr
    lsr 
    lsr
    lsr 
    lsr 
    lsr 
    bcc Done

    jsr TimerTick

    lda #0
    sta CurrentFrame

  Done:
    rts

  CurrentFrame: .byte 0
}

.label ScreenRam = $1e00

#import "_utils.asm"
#import "_assets.asm"
