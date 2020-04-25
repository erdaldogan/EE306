.global _start
_start:
	LDR R0, DISPLAY_BASE // 7-segment display base address
	LDR R1, FIRST_ROW // holds first 4 7-segment displays
	LDR R2, SECOND_ROW // holds last 2 7-segment displays
	LDR R3, CLASSID //R3 holds CLASSID
	ADD R1, R1, R3 //add class id to be shown on the 7-segment display
	STR R1, [R0], #16 //update first 4 7-segment displays
	STR R2, [R0] // update last 2 7-segment displays
END: B END
DISPLAY_BASE: .word 0xff200020 //display base address
CLASSID: .word 125 //class id is 6
FIRST_ROW: .word 0x5C1C7300 // "ouP0" on 7-segment display
SECOND_ROW: .word 0x3D50 // "Gr" on 7-segment display
.end