.global _start 
_start: 
        LDR R1, TEST_NUM // load the data word into R1
        LDR R3, CONSECUTIVE_ALTERNATING // load the alternating word into R3
        MOV R0, #0 // R0 will hold the result
        EOR R1, R1, R3
LOOP:
        CMP R1, #0 // loop until the data contains no more 1's
        MOV R4, R0
        BEQ LOOP1
        LSR R2, R1, #1 // perform SHIFT, followed by AND
        AND R1, R1, R2
        ADD R0, #1 // count the string lengths so far
        B LOOP
        LDR R1, TEST_NUM // load the data word into R3
        LDR R3, CONSECUTIVE_ALTERNATING1 // load the alternating word into R3
        MOV R0, #0 // R0 will hold the result
LOOP1:
        CMP R1, #0 // loop until the data contains no more 1's
        BEQ END
        LSR R2, R1, #1 // perform SHIFT, followed by AND
        AND R1, R1, R2
        ADD R0, #1 // count the string lengths so far
        B LOOP1
COMPARE_RESULTS:
        CMP R0, R4
        MOVLT R0, R4
        MOV R4, #0
END:
        B END
TEST_NUM: .word 0x103fe05f
CONSECUTIVE_ALTERNATING: .word 0xAAAAAAAA
CONSECUTIVE_ALTERNATING1: .word 0x55555555
.end

