.global _start
_start:
	LDR R0, DISPLAY_BASE // 7-segment display base address
	LDR R1, =HEX_TO_7_SEG //points base address to hex of 7 segment display
	LDR R4, BUTTON_BASE //base address of buttons
	MOV R8, #0 //zero register
	LDR R2, [R1, #4] //current displayed element's value
	MOV R3, R1 // current displayed element's address
	ADD R3,R3, #4 // update address to show 0
MAIN:
	LDRB R5, [R4] //load state of button base
	CMP R5, #1 //check if KEY0 pressed
	BLEQ ZERO //if yes, branch
	CMP R5, #2 //check if KEY1 pressed
	BLEQ INCR //if yes, branch
	CMP R5, #4 //check if KEY2 pressed
	BLEQ DECR //if yes, branch
	CMP R5, #8 //check if KEY3 pressed
	BLEQ BLANK //if yes, branch
	B MAIN //continue on loop
ZERO:
	MOV R2, #63 //move 0 in hex to r2
	MOV R3, R1 //update pointer to show the first item in list which is blank
	ADD R3, R3, #4 //update pointer to show second item in list which is 0 in hex
	STR R2, [R0] //update display
	BX LR //return to main loop
INCR:
	CMP R2, #113 //check if displayed value is max
	BXEQ LR //if yes, return without updating
	LDRH R2, [R3, #4]! //update pointer
	STR R2, [R0] //update display
	BX LR //return to main loop
DECR:
	CMP R2, #63 //check if currently displayed item is 0
	BXEQ LR // if yes, return without updating
	CMP R2, #0 //check if currently blank
	BEQ ZERO //set to 0 if blank
	LDRH R2, [R3, #-4]! //update pointer
	STR R2, [R0] //update display
	BX LR
BLANK:
	MOV R2, #0 //blank value
	MOV R3, R1 //set pointer to begining of the list
	STR R2, [R0] //update display
	BX LR //return to main loop
END: B END
DISPLAY_BASE: .word 0xff200020 //display base address
BUTTON_BASE: .word 0xff200050 //buttons base address
//converted versions of hexadecimal numbers to display on 7-segment display
HEX_TO_7_SEG: .word 0,63,6,91,79,102,109,125,7,127,111,119,124,57,94,121,113

.end