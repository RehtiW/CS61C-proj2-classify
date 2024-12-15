.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
    bge zero, a1, exception_36
    #Prologue
    addi sp, sp, -8
    sw s0, 0(sp)        
    sw s1, 4(sp)
    li s0, 0           # s0 is the counter
    lw t0, 0(a0)       # set the original value to arr[0] in t0
    li t1 0            # set the original index to 0 in t1
loop_start:
    beq s0, a1, loop_end
    slli t2, s0, 2     # t2 is the offset of the array
    add s1, a0, t2     # s1 store the address of current node
    lw s1, 0(s1)       # load word from address to "s1"

    addi s0, s0, 1     # whether continue or not,increment the counter by 1
    
loop_continue:
    bge t0, s1, loop_start # if s0 > t0,arr[i] <= arr[t1]        
    addi t1, s0, -1   # update index,note that need to sub 1 from t0
    add t0, s1, zero   # update maxValue
    j loop_start
loop_end:
    # Epilogue
    lw s0, 0(sp)        
    lw s1, 4(sp)
    addi sp, sp, 8
    add a0, x0, t1
    jr ra
exception_36:
    li a0 36
    j exit