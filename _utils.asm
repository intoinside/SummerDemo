
#importonce

.macro add16byte(value, dest) {
    clc
    lda dest
    adc value
    sta dest
    bcc !+
    inc dest + 1
  !:
}

.macro add16immediate(value, dest) {
    clc
    lda dest
    adc #value
    sta dest
    bcc !+
    inc dest + 1
  !:
}
.assert "add16immediate($cc, $0123) ", { add16immediate($cc, $0123) }, {
  clc; lda $0123; adc #$cc; sta $0123; bcc !+; inc $0124; !:
}

.macro sub16byte(value, dest) {
    sec
    lda dest
    sbc value
    sta dest
    lda dest + 1
    sbc #$00
    sta dest + 1
}
.assert "sub16byte($cc, $0123) ", { sub16byte($cc, $0123) }, {
  sec; lda $0123; sbc $cc; sta $0123; lda $0124; sbc #$00; sta $0124
}

// Generates a random number up to maxNumber (excluded)
.macro GetRandomUpTo(maxNumber) {
    lda #maxNumber
    sta GetRandom.GeneratorMax
    jsr GetRandom
}

GetRandom: {
    lda #$01
    asl               
    bcc Skip         
    eor #$4d  

  Skip:            
    sta GetRandom + 1
    eor $9124

    cmp GeneratorMax
    bmi GetRandom

    rts

    GeneratorMax: .byte 0
}

.macro ChangeScreenColor(color) {
    lda #color
    sta $900f
}

// Expansion:	0,3,8 (Unexpanded, 3K at $0400, 8K+ at $1200)
// ListMessage:	string to display if program is LISTed
.macro BasicStub(Expansion, ListMessage, CodeStart) {
      .if (Expansion == 0)          // Determine BASIC start address
      {
        .pc = $1000 "BASIC Stub"    // Unexpanded VIC - BASIC starts at 4096
      }
      else .if (Expansion == 3)
      {
        .pc = $0400 "BASIC Stub"    // 3K Expanded VIC - BASIC starts at 1024
      }
      else
      {
        .pc = $1200 "BASIC Stub"    // 8K+ Expanded VIC - BASIC starts at 4608
      }
      .byte 0	            // Start of BASIC program
      .word nextline      // Pointer to next BASIC line (Lo/Hi)
      .word 0             // Line number
      .byte $9e           // 'SYS'
      .fill 4, toIntString(begin,4).charAt(i)	// Address of 'begin' as numeric string
      .word $8f3a         // Colon and 'REM'
      .fill 13,$14        // {DEL} control characters to hide start of BASIC line
      .text ListMessage   // Message for LIST
      .byte 0             // End of BASIC line
nextline:	.word 0         // End of BASIC program
begin:		.pc = * "Entry" // Start of 6502 code
}

.macro MoveCharsetLocation(location) {
    lda $9005
    ora #location
    sta $9005
}