
#importonce

BasicStub(0, "SummerDemo for Vic20", Entry)
Entry: {
    Init()

  !:
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

.macro ChangeScreenColor(color) {
    lda #color
    sta $900f
}

.label ScreenRam = $1e00

#import "_utils.asm"
#import "_assets.asm"
