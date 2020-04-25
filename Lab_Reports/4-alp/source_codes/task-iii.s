.global _start
_start:
	LDR R0, DISPLAY_BASE // 7-segment display base address
	LDR R1, BUTTON_BASE //base address of buttons
	LDR R2, FIRST_WORD_1 //first word first row
	LDR R3, FIRST_WORD_2 //first word second row
	LDR R4, SECOND_WORD_1 //second word first row
	LDR R5, SECOND_WORD_2 //second word second row
	MOV R8, #0 //flag for current word showing
	MOV R9, #1 //value for XOR operation
MAIN:
	LDRB R6, [R1] //load state of button base
	CMP R6, #0 //check if any key is pressed
	BNE STOP_DELAY //if yes, stop delay
	BL UPDATE_DISPLAY //update display subroutine
	B DO_DELAY //else do delay

DO_DELAY: LDR R7, =2000000 // delay counter
SUB_LOOP: 
	SUBS R7, R7, #1 //decrement r7
	BNE SUB_LOOP //branchif  if delay is not completed
	B MAIN //branch after delay is completed
	
STOP_DELAY:
	LDRB R6, [R1] //load state of button base
	CMP R6, #0 // check if button is still clicked
	BNE STOP_DELAY //if still clicked continue loop
	B MAIN //else continue on main loop

UPDATE_DISPLAY:
	CMP R8, #0 //check if the displayed word is the first word
	STRNE R2, [R0] //if not load first row of first word
	STRNE R3, [R0, #16] //if not load second row of first word
	STREQ R4, [R0] //if yes, load first row of second word
	STREQ R5, [R0, #16] //if yes, load second row of second word
	EOR R8, R8, R9 //update flag
	BX LR //end subroutine
END: B END
DISPLAY_BASE: .word 0xff200020 //display base address
BUTTON_BASE: .word 0xff200050 //buttons base address
FIRST_WORD_1: .word 0x78000000
FIRST_WORD_2: .word 0x6D79
SECOND_WORD_1: .word 0x37377B00
SECOND_WORD_2: .word 0x7804
.end