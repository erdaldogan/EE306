.global _start 
_start: 
        LDR R1, TEST_NUM // load the data word into R1
        LDR R3, CONSECUTIVE_ALTERNATING // load the alternating word into R3
        MOV R0, #0 // R0 will hold the result and first loop's result
        MOV R4, #0 // R0 will hold the second loop's result
        EOR R1, R1, R3 // XORed data word with alternating word
LOOP:
        CMP R1, #0 // loop until the data contains no more 1's
        MOV R4, R0
        BEQ INIT_LOOP1 // branch to initialize the second loop's words
        LSR R2, R1, #1 // perform SHIFT, followed by AND
        AND R1, R1, R2
        ADD R0, #1 // count the string lengths so far
        B LOOP
INIT_LOOP1:
	LDR R1, TEST_NUM // load the data word into R1
        LDR R3, CONSECUTIVE_ALTERNATING1 // load the second alternating word
	EOR R1, R1, R3 // XORed the data word with second alternating word
	B LOOP1
LOOP1:
        CMP R1, #0 // loop until the data contains no more 1's
        BEQ END
        LSR R2, R1, #1 // perform SHIFT, followed by AND
        AND R1, R1, R2
        ADD R4, #1 // count the string lengths so far
        B LOOP1
COMPARE_RESULTS:
        CMP R0, R4 // compare first loop's result with second loop's result
        MOVLT R0, R4 // if second is greater than first, then select second as result
        MOV R4, #0 // clear register after use
END:
        B END
TEST_NUM: .word 0x103fe05f
CONSECUTIVE_ALTERNATING: .word 0xAAAAAAAA
CONSECUTIVE_ALTERNATING1: .word 0x55555555
.end
