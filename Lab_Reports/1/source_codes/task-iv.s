.global _start 
_start: 
        LDR R1, TEST_NUM // load the data word into R1
        LDR R8, AND_NUM1
        LDR R11, OR_NUM1
        LDR R12, OR_NUM2
        MOV R0, #0 // R0 will hold the result
        MOV R2, R1
LOOP:
        CMP R2, #0 // loop until the data contains no more 1's
        BEQ CONT
        AND R3, R2, #1
        LSR R2, R2, #1 // perform SHIFT, followed by AND  
        ADD R0, R0, R3 // count the string lengths so far
        B LOOP
EVEN:	
        ORR R8, R8, R11
        B END
CONT: 
        ANDS R3, R0, #1
        BEQ EVEN
        ORR R8, R8, R12
END:
        B END
TEST_NUM: .word 0xAAAAAAAB
AND_NUM1: .word 0x00000000
OR_NUM1: .word 0x80000000 //even parity bit
OR_NUM2: .word 0x00000001 //odd parity bit
.end
