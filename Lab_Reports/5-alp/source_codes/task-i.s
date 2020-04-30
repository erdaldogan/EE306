.global _start
 _start:
	 LDR R0, =0xFF200000 // base address of LEDs
	 LDR R1, =0xFFFEC600 // R1 points to timer.
	 LDR R2, =50000000		// R2 is control word.
	 STR R2, [R1] // update timer load register
	 MOV R2, #0b011  // set control bits to I->0, A->1, E->1
	 STR R2, [R1, #8] //update timer control register
	 MOV R2, #1 // blinking flag
	 
 loop: STR R2, [R0] // led is on. 
	 waitloop: LDR R4, [R1, #0xC] // status reg. 
	 CMP R4, #1 // if 1, 0.25 second is completed. 
	 BNE waitloop 
	 STR R4, [R1, #0xC] // reset status flag. 
	 EOR R2, R2, #1 // update blinking flag
 B loop 
 
 END: B END
 .end