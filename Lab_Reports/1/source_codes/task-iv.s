.global _start 
_start: 
        LDR R1, TEST_NUM // load the data word into R1
        LDR R8,  RESULT // r8 will hold the result
        LDR R11, OR_NUM1 //odd parity bit = 1, even parity bit = 0
        LDR R12, OR_NUM2 //odd parity bit = 0, even parity bit = 1
        MOV R0, #0 // initialized accumulator
LOOP:
        CMP R1, #0 // loop until the data contains no more 1's
        BEQ CONT
        AND R3, R1, #1 // take the last bit
        LSR R2, R1, #1 // perform SHIFT, followed by AND  
        ADD R0, R0, R3 // add the current bit to accumulator
        B LOOP
EVEN:	
        ORR R8, R8, R11 // put OR_NUM1 as the result
        B END
CONT: 
        ANDS R3, R0, #1 // last bit indicates whether sum is even or odd
        BEQ EVEN // if sum is even then branch
        ORR R8, R8, R12 // put OR_NUM2 as the result
END:
        B END
TEST_NUM: .word 0xAAAAAAAB
RESULT: .word 0x00000000
OR_NUM1: .word 0x80000000 //odd parity bit = 1
OR_NUM2: .word 0x00000001 //even parity bit = 1
.end
