.text
.global start
start:  LDR R8, =LIST //holds the address of the list
        ADD R0, R8,#4 // points to first element 
        LDR R1, [R8] // number of elements
        MUL R4, R1, #4 // for calculating the latest address
        BL INIT_SORT
        SUB R0, R0, R4 //returing to the first element
        B END
INIT_SORT:PUSH {LR}
SORT:   PUSH {R0, R1} // save number of elements and pointer
        MOV R12, #0 // flag
BUBBLE_SORT:SUBS R1, R1,#1 // decrement number of elements
        BEQ CHECK //branch if number of elements is 0
        LDR R2, [R0] //element 1
        LDR R3, [R0, #4]! //element 2
        CMP R2, R3 //compare two elements and swap them if needed
        BGE BUBBLE_SORT // if r2 is greater than or equal to r3, continue to traverse
        BL SWAP // if element 1 is less than element 2 then swap
        B BUBBLE_SORT //continue to traverse after sorting 
SWAP:   STR R2, [R0]
        STR R3, [R0, #-4]
        MOV R12, #1 // update flag
        BX LR
CHECK:  POP {R0, R1} // restore number of elements and pointer
        SUB R1, R1,#1 // decrement number of elements
        CMP R12, #1 // checking if anything sorted
        POPNE {LR} // restore link register if list is sorted
        BXNE LR // return to link register if sorted
        B SORT //continue to sort if not sorted
END:    B END 
LIST: .word 10,0,1,2,3,4,5,6,7,8,9
.end