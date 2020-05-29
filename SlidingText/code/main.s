.global _start
_start:
    LDR R11, =0xFFFEC600 //timer adress
    LDR R1, =200000000 // 200M
    STR R1, [R11] //set load register of the timer
    MOV R2, #0b011 //control configuration
    STR R2, [R11, #8] //set config bits
    
    /* AT THIS POINT WE CAN USE R1 & R2 REGISTERS AS WE WISH */
    /* DON'T FORGET R11 & R12 ARE RESERVED FOR TIMER OPERATION */
    
    LDR R0, =0xFF200023 // 7-segment adress
    LDR R1, =ALPHABET // address of the character set
    LDR R2, =INPUT // user input
	MOV R3, #0 // string character iterator index
	MOV R5, #0 // length 
	LDR R10, =0xFF20001F // non-entry zone for display addresses.
	B PRINT_STRING
    	
PRINT_STRING:
	LDRB R4, [R2, R3] // load ascii code of the character
	CMP R4, #0x00 // reached to the end of the string
	MOVEQ R5, R3 // length
	MOVEQ R3, #0 // start from the beginning of the string
	BEQ PRINT_STRING
	CMP R4, #32 // 32 is ascii code of the space char
	SUBEQ R4, R4, #32 // 0th location of array contains space char
	SUBNE R4, R4, #64 // location of that character in the representation array
	/* ascii(A) = 65 and goes sequentially, when we subtract
	64 from the ascii code, we get the index of the char
	representation in the array */
	LDRB R4, [R1, R4] // retrieve the character representation 
  	STRB R4, [R0] // write on to the 7-segment
	BL UPDATE_LOCATION
	B PRINT_STRING

	
UPDATE_LOCATION:
	SUB R0, R0, #1 /* R0 is the leftmost 7-segment.
	at each iteration, print the character to the left of the
	previous char */
	CMP R0, R10 // out of the available 7-segment adress. (too right)
	ADDNE R3, R3, #1 /* increase the string char index to read the next char */
	BXNE LR
	LDR R0, =0xFF200023 // address of the leftmost of the 7-segments
	SUB R3, R3, #2
	CMP R3, #0
	ADDLT R3, R3, R5
	PUSH {LR}
	BL DELAY
	POP {PC}
	
DELAY:
    LDR R12, [R11, #0xC]
    CMP R12, #1
    BNE DELAY
    STR R12, [R11, #0xC] // reset status flag.
    BX LR
	

END: B END
INPUT: .asciz "ABCDEFGHI" //.asciz appends a zero at the end of the string as an finish indicator
ALPHABET: .byte 0x00, 0x77, 0x7C, 0x39, 0x5E, 0x79, 0x71, 0x7D, 0x76, 0x06, 0x0E, 0x75, 0x38, 0x15, 0x54, 0x5C, 0x73, 0x67, 0x50, 0x6D, 0x78, 0x3E, 0x62, 0x6A, 0x64, 0x6E, 0x5B
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
* Fix the circular loop problem
*/