.include    "address_map_arm.s"
.text                       
.global     _start
_start: 
        LDR R0, N // load the data word into R0
        MOV R1, #0 // temp register
        BL FINDSUM
	LSL R1, R1, #5 // average of 32 numbers
        MOV R0, R1 // move result from R1 to R0
        B END
FINDSUM:
        ADD R1, R1, R0
        SUBS R0, R0, #1 // count down
        BXEQ LR // branch if 0
        B FINDSUM    
END:    B END  
N:      .word 0x9
.end
