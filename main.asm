
#importonce

BasicStub(0, "SummerDemo for Vic20", Entry)
Entry: {
    ChangeScreenColor(%11111111)

    lda $9005
    ora #$0f
    sta $9005

    LoadMap();

    ldx #$00
  !PaintCols:
    ldy ScreenRam, x
    lda $1ba0, y
    sta $9600, x
    dex
    bne !PaintCols-

    ldx #$00
  !PaintCols:
    ldy ScreenRam + $ff, x
    lda $1ba0, y
    sta $96ff, x
    dex
    bne !PaintCols-

  !:
    jmp !-
}

.macro LoadMap() {
    ldx #0
  !:
    lda Map, x
    sta ScreenRam, x
    dex
    bne !-

    ldx #0
  !:
    lda Map + $ff, x
    sta ScreenRam + $ff, x
    dex
    bne !-
}

.macro ChangeScreenColor(color) {
    lda #color
    sta $900f
}

.label ScreenRam = $1e00

#import "_utils.asm"
#import "_assets.asm"
