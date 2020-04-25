.global _start
_start:
    LDR R0, =0xFFFEC600 //timer adress
    LDR R1, =2000000 // 1/100th of the 200M
    STR R1, [R0] //set load register of the timer
    MOV R2, #0b011 //control configuration
    STR R2, [R0, #8] //set config bits
    
    LDR R1, =0xFF200020 // 7-segment address
    LDR R2, =0xFF200030
    LDR R4, =SEQUENCE // sequential digits
    MOV R5, #0 // array index
    MOV R10, #0
    MOV R11, #0
    MOV R12, #0
    B LOOP

LOOP:
    BL INCREMENT_MS

    B LOOP

INCREMENT_MS:
    LDRB R6, [R4, R5]
    STRB R6, [R1] //rightmost digit
    LDRB R7, [R4, R10]
    STRB R7, [R1, #1] //second to right
    ADD R5, R5, #1
    CMP R5, #10
    ADDEQ R10, R10, #1
    MOVEQ R5, #0
    CMP R10, #10
    MOVEQ R10, #0
    BEQ INCREMENT_SEC
    BL DELAY
    B INCREMENT_MS

INCREMENT_SEC:
    LDRB R8, [R4, R11]
    STRB R8, [R1, #3] //third to left
    LDRB R9, [R4, R12]
    STRB R9, [R2] //second to left
    ADD R11, R11, #1
    CMP R11, #10
    MOVEQ R11, #0
    ADDEQ R12, R12, #1
    CMP R12, #6
    BLEQ SET_TO_ZERO
    BX LR

DELAY:
    LDR R3, [R0, #0xC]
    CMP R3, #1
    STREQ R3, [R0, #0xC] // reset status flag.
    BXEQ LR
    B DELAY
    
SET_TO_ZERO:
    MOV R5, #0 // array index
    MOV R10, #0
    MOV R11, #0
    MOV R12, #0
    BX LR
    

SEQUENCE: .byte 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0xFF, 0xEF
// 0 = 0x3F, Array Index: 0
// 1 = 0x06, Array Index: 4
// 2 = 0x5B, Array Index: 8
// 3 = 0x4F, Array Index: C
// 4 = 0x66, Array Index: 10
// 5 = 0x6D, Array Index: 14
// 6 = 0x7D, Array Index: 18
// 7 = 0x07, Array Index: 1C
// 8 = 0xFF, Array Index: 20
// 9 = 0xEF, Array Index: 24
.end



