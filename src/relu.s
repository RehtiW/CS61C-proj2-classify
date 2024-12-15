.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
relu:
    blt zero, a1, 12
    li a0 36
    j exit
    # Prologue
    addi t0, x0, 0     # counter of the loop
loop_start:
    beq t0, a1, loop_end
    slli t1, t0, 2     # t1 is the offset of the array
    add t2, a0, t1
    lw t1, 0(t2)       # load word from address to "t1"
    
loop_continue:
    addi  t0, t0, 1            # Increment the counter by 1          
    bge t1, zero, loop_start  # t1 >= 0
    
    addi t1, x0, 0    # set the value to 0
    sw t1, 0(t2)       # store the value back to array
    j loop_start
loop_end:
    # Epilogue
    jr ra
