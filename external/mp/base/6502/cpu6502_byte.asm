
/*
	fmulu_8
	imulCL
	imulBYTE
	idivBYTE
	idiv_AL_CL
*/

; Description: Unsigned 8-bit multiplication with unsigned 16-bit result.
;
; Input: 8-bit unsigned value in T1
;	 8-bit unsigned value in T2
;	 Carry=0: Re-use T1 from previous multiplication (faster)
;	 Carry=1: Set T1 (slower)
;
; Output: 16-bit unsigned value in PRODUCT
;
; Clobbered: PRODUCT, X, A, C
;
; Allocation setup: T1,T2 and PRODUCT preferably on Zero-page.
;		    square1_lo, square1_hi, square2_lo, square2_hi must be
;		    page aligned. Each table are 512 bytes. Total 2kb.
;
; Table generation: I:0..511
;		    square1_lo = <((I*I)/4)
;		    square1_hi = >((I*I)/4)
;		    square2_lo = <(((I-255)*(I-255))/4)
;		    square2_hi = >(((I-255)*(I-255))/4)
.proc fmulu_8

t1	= eax
t2	= ecx

product	= eax

	txa:tay
;		bcc :+
		    lda T1
		    sta sm1+1
		    sta sm3+1
		    eor #$ff
		    sta sm2+1
		    sta sm4+1

		ldx T2
		sec
sm1:		lda square1_lo,x
sm2:		sbc square2_lo,x
		sta PRODUCT+0
sm3:		lda square1_hi,x
sm4:		sbc square2_hi,x

		sta PRODUCT+1

	tya:tax
		rts
.endp


/*

 8 bit multiply and divide routines.
 Three 8 bit locations
 ACC, AUX and EXT must be set up,
 preferably on zero page.

 MULTIPLY ROUTINE

 EAX*ECX -> EAX (low,hi) 16 bit result

*/

.proc	imulCL

	lda #$00

	LDY #$09
	CLC
LOOP	ROR @
	ROR eax
	BCC MUL2
	CLC		;DEC AUX above to remove CLC
	ADC ecx
MUL2	DEY
	BNE LOOP

	STA eax+1

	RTS
.endp


.proc	imulBYTE

	mva :STACKORIGIN,x ecx
	mva :STACKORIGIN-1,x eax

	lda #$00

	sta eax+2
	sta eax+3

	.ifdef fmulinit
	jmp fmulu_8
	els
	jmp imulCL
	eif

.endp


.define	jsr_imodBYTE jsr idivBYTE

.proc	idivBYTE

	mva :STACKORIGIN,x ecx
	mva :STACKORIGIN-1,x eax

	jmp idivAL_CL
.endp


; DIVIDE ROUTINE (8 BIT)
; AL/CL -> ACC, remainder in ZTMP

.proc idivAL_CL

;	mva :STACKORIGIN,x cl
;	mva :STACKORIGIN-1,x al

	lda #$00

	sta eax+1
	sta eax+2
	sta eax+3

	STA ztmp+1
	STA ztmp+2
	STA ztmp+3

	LDY #$08
LOOP	ASL AL
	ROL @
	CMP CL
	BCC DIV2
	SBC CL
	INC AL
DIV2
	DEY
	BNE LOOP

	STA ZTMP

	rts
.endp

