.global _start
_start:
	LDR R9, BUTTON_BASE
    LDR R11, TIMER_BASE //timer adress
    LDR R12, =200000000 // 200M
    STR R12, [R11] //set load register of the timer
    MOV R2, #0b011 //control configuration
    STR R2, [R11, #8] //set config bits
	MOV R7, #0 //current input

    /* AT THIS POINT WE CAN USE R1 & R2 REGISTERS AS WE WISH */
    /* DON'T FORGET R11 & R12 ARE RESERVED FOR TIMER OPERATION */
    
    LDR R0, DISPLAY_BASE // 7-segment adress
    LDR R1, =ALPHABET // address of the character set
    LDR R2, =INPUT0 // user input
	MOV R3, #0 // string character iterator index
	MOV R5, #0 // length 
	B MAIN

MAIN:
	BL SET_WORD
	BL CHECK_PAUSE
	BL SET_SPEED
	BL PRINT_STRING
	B MAIN

CHECK_PAUSE:
	PUSH {R6, R7, R8}
	PAUSE:
		LDR R7, [R6]
		ANDS R7, R7, #0b001 // if push button 0 is pressed
		BNE PAUSE
		POP {R6, R7, R8}
		BX LR
		
SET_SPEED:
	PUSH {R6, R7, R8}
	LDR R6, [R9]
	CMP R6, #0b010
	BEQ INCREASE_SPEED
	CMP R6, #0b100
	BEQ DECREASE_SPEED
	
	NORMALIZE_SPEED:
		LDR R12, =200000000
		STR R12, [R11]
		POP {R6, R7, R8}
		BX LR
	
	INCREASE_SPEED:
		LDR R12, =800000000
		STR R12, [R11]
		POP {R6, R7, R8}
		BX LR
	DECREASE_SPEED:
		LDR R12, =50000000
		STR R12, [R11]
		POP {R6, R7, R8}
		BX LR

SET_WORD:
	PUSH {R0}
	set_word_loop:
		LDR R0, SWITCH_BASE
		LDR R0, [R0]
		CMP R0, #0
		BEQ set_word_loop
		CMP R0, R7 // if not changed
		POP {R0} // restore r0
		BXEQ LR // return to main loop
		PUSH {R0}
		LDR R0, SWITCH_BASE
		LDR R0, [R0]
		CMP R0, #1
		LDREQ R2, =INPUT0
		MOVEQ R7, #1
		CMP R0, #2
		LDREQ R2, =INPUT1
		MOVEQ R7, #2
		CMP R0, #4
		LDREQ R2, =INPUT2
		MOVEQ R7, #4
		CMP R0, #8
		LDREQ R2, =INPUT3
		MOVEQ R7, #8
		MOV R3, #0 // string character iterator index
		MOV R5, #0 // length
		POP {R0}
		BX LR


PRINT_STRING:
	PUSH {LR} // save state of link register 
	PRINT_STR:
		LDRB R4, [R2, R3] // load ascii code of the character
		CMP R4, #0x00 // reached to the end of the string
		MOVEQ R5, R3 // length
		MOVEQ R3, #0 // start from the beginning of the string
		BEQ PRINT_STR
		CMP R4, #32 // 32 is ascii code of the space char
		SUBEQ R4, R4, #32 // 0th location of array contains space char
		PUSH {LR}
		BLNE FIND_LOC
		/* ascii(A) = 65 and goes sequentially, when we subtract
		64 from the ascii code, we get the index of the char
		representation in the array */
		LDRB R4, [R1, R4] // retrieve the character representation 
		STRB R4, [R0] // write on to the 7-segment
		BL UPDATE_LOCATION
		POP {LR} // restore link register
		BX LR // return to main
FIND_LOC:
	CMP R4, #65
	SUBLT R4, R4, #47
	BXLT LR
	CMP R4, #97
	SUBLT R4, R4, #54
	BXLT LR
	SUB R4, R4, #86
	BX LR
	
UPDATE_LOCATION:
	SUB R0, R0, #1 /* R0 is the leftmost 7-segment.
	at each iteration, print the character to the left of the
	previous char */
	LDR R10, =0xFF20002F // non-entry zone for display addresses.
	CMP R0, R10
	LDREQ R0, =0xFF200023
	LDR R10, =0xFF20001F // non-entry zone for display addresses.
	CMP R0, R10 // out of the available 7-segment adress. (too right)
	ADDNE R3, R3, #1 /* increase the string char index to read the next char */
	BXNE LR
	LDR R0, =0xFF200033 // address of the leftmost of the 7-segments
	SUB R3, R3, #6
	CMP R3, #0
	ADDLT R3, R3, R5
	PUSH {LR}
	BL DELAY
	POP {LR}
	BX LR
	
DELAY:
    LDR R8, [R11, #0xC]
    CMP R8, #1
    BNE DELAY
    STR R8, [R11, #0xC] // reset status flag.
    BX LR
	

END: B END

DISPLAY_BASE: .word 0xff200033 //display base address
TIMER_BASE: .word 0xfffec600 //timer base address
BUTTON_BASE: .word 0xff200050 //buttons base address
SWITCH_BASE: .word 0xff200040 //switches base address
INPUT0: .asciz "abcdefghijklmnopqrstuvwxyz" //.asciz appends a zero at the end of the string as an finish indicator
INPUT1: .asciz "1234567890" //.asciz appends a zero at the end of the string as an finish indicator
INPUT2: .asciz "ABCDEFGHIJKLMNOPQRSTUVXYZ" //.asciz appends a zero at the end of the string as an finish indicator
INPUT3: .asciz "abcdefghijklmnopqrstuvwxyz1234567890ABCDEFGHIJKLMNOPQRSTUVXYZ" //.asciz appends a zero at the end of the string as an finish indicator

ALPHABET: .byte 0x00, 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F, 0x77, 0x7C, 0x39, 0x5E, 0x79, 0x71, 0x7D, 0x74, 0x06, 0x0E, 0x75, 0x38, 0x15, 0x54, 0x5C, 0x73, 0x67, 0x50, 0x6D, 0x78, 0x3E, 0x1C, 0x2A, 0x76, 0x6E, 0x5B
// 1 A = 0x77
// 2 B = 0x7C
// 3 C = 0x39
// 4 D = 0x5E
// 5 E = 0x79
// 6 F = 0x71
// 7 G = 0x7D
// 8 H = 0x76
// 9 I = 0x06
// 10 J = 0x0E
// 11 K = 0x75
// 12 L = 0x38
// 13 M = 0x15
// 14 N = 0x54
// 15 O = 0x5C
// 16 P = 0x73
// 17 Q = 0x67
// 18 R = 0x50
// 19 S = 0x6D
// 20 T = 0x78
// 21 U = 0x3E
// 22 W = 0x62
// 23 V = 0x6A
// 24 X = 0x64
// 25 Y = 0x6E
// 26 Z = 0x5B
.end

/* TODO
+ Fix the space character printing 8
* Use all of the 7-segments
*/