.global _start
_start:
    LDR R0, =0xFF200020 // 7-segment address
    LDR R1, =0xFF200030 // 7-segment address
    LDR R4, =0xFF200050 // pushbutton address
    
LOOP:
    LDR R2, =SET // set text to "set"
    BL DISPLAY_WORD // call subroutine for updating the display
    LDR R2, =ALARM // set text to "alarm"
    BL DISPLAY_WORD
    LDR R2, =SET // set text to "set"
    BL DISPLAY_WORD
    LDR R2, =TIME // set text to "time"
    BL DISPLAY_WORD
    B LOOP // loop

DISPLAY_WORD:
    LDR R10, [R4]
    CMP R10, #0 // check if any keys are pressed
    BEQ DISPLAY_WORD // if no keys are pressed, check again.
    LDR R3, [R2] // load the values from mem to reg
    STR R3, [R0] // store to mem location where the 7-segment reads
    LDR R3, [R2, #4] /* our memory is word-addressable, increment the adress by 4
    to get the remaining parts of the text */
    STR R3, [R1] // store the remaining parts of the text
    PUSH {LR} /* save the content of the link register before branchin to 'delay'
    subroutine */
    B DELAY // perform delay

DELAY: // perform delay
    LDR R12, =1200000 // delay counter
       SUB_LOOP:
        SUBS R12, R12, #1
        BNE SUB_LOOP
    POP {PC} // go back where the 'display_word' subroutine was first called


END: B END
SET: .byte 0x78, 0x79, 0x6D, 0x00, 0x00, 0x00, 0x00, 0x00
//extra zeros are for misalignment issues, notice they complement 8 bytes.
ALARM: .byte 0x37, 0x37, 0x50, 0x77, 0x38, 0x77, 0x00, 0x00
TIME: .byte 0x79, 0x37, 0x37, 0x06, 0x78, 0x00
.end
