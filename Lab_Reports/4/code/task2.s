.global _start
_start:
	LDR R0, =0xFF200020 // firt chunk of 7-segment address
	LDR R1, =0xFF200030 // second chunk of 7-segment address
	LDR R2, =GROUPID // characters beginning address
	LDR R3, [R2] // load characters from mem to reg
	STR R3, [R0] // store to mem location where the 7-segment reads
	LDR R3, [R2, #4] /* our memory is word-addressable, increment the adress by
	4 to get the remaining parts of the GROUPID */
	STR R3, [R1] // store the remaining parts of the GROUPID text
	B END

END: B END
GROUPID: .byte 0x66, 0x73, 0x1C, 0x5C, 0x50, 0x7D
.end
// G = 0x7D
// r = 0x50
// o = 0x5C
// u = 0x1C
// p = 0x73
// 4 = 0x66
