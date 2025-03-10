.global _start
_start:
	LDR R12, =0xFF200000 //LED adress
	MOV R11, #1 //LED value
	LDR R1, =0xFFFEC600 //timer adress
	LDR R2, =50000000 // 1/4th of the 200M
	STR R2, [R1] //set load register of the timer
	MOV R3, #0b011 //control configuration
	STR R3, [R1, #8] //set config bits

LOOP:
	STR R11, [R12] //turn on
	BL DELAY
	EOR R11, R11, #1 //switch the state of led
	B LOOP

DELAY:
	LDR R4, [R1, #0xC] // read the interrupt status bit
	CMP R4, #1 // 1 when load register reaches 0
	BNE DELAY
	STR R4, [R1, #0xC] // reset interrupt status bit 
	BX LR
	
.end

