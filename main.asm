
#importonce
BasicStub(0, "SummerDemo for Vic20", Entry)
Entry: {
    ChangeScreenColor(%11111111)

  !:
    jmp !-
}


// Expansion:	0,3,8 (Unexpanded, 3K at $0400, 8K+ at $1200)
// ListMessage:	string to display if program is LISTed
.macro BasicStub(Expansion, ListMessage, CodeStart) {
      .if (Expansion == 0)					// Determine BASIC start address
      {
        .pc = $1000 "BASIC Stub"			// Unexpanded VIC - BASIC starts at 4096
      }
      else .if (Expansion == 3)
      {
        .pc = $0400 "BASIC Stub"			// 3K Expanded VIC - BASIC starts at 1024
      }
      else
      {
        .pc = $1200 "BASIC Stub"			// 8K+ Expanded VIC - BASIC starts at 4608
      }
      .byte 0									// Start of BASIC program
      .word nextline							// Pointer to next BASIC line (Lo/Hi)
      .word 0									// Line number
      .byte $9e								// 'SYS'
      .fill 4, toIntString(begin,4).charAt(i)	// Address of 'begin' as numeric string
      .word $8f3a								// Colon and 'REM'
      .fill 13,$14							// {DEL} control characters to hide start of BASIC line
      .text ListMessage						// Message for LIST
      .byte 0									// End of BASIC line
nextline:	.word 0									// End of BASIC program
begin:		.pc = * "Entry"						// Start of 6502 code
}

.macro ChangeScreenColor(color) {
    lda #color
    sta $900f
}
