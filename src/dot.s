.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the number of elements to use is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:
    li t0, 1
    bge x0, a2, exception_36
    bge x0, a3, exception_37
    bge x0, a4, exception_37
    #prologue
    addi sp, sp, -12
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    
    add t0, x0, x0   # set the counter to 0 
    add s0, x0, x0   # set the sum to 0
    
loop_start:
    mul s1, t0, a3  
    slli s1, s1, 2

    mul s2, t0, a4
    slli s2, s2, 2

    add s1, s1, a0  # s1 stores the address of a0 current value
    add s2, s2, a1  # s2 stores the address of a1 current value
    lw t1, 0(s1)
    lw t2, 0(s2)
    mul t1, t1, t2
    add s0, s0, t1
    addi t0, t0, 1
    beq t0, a2, loop_end
    j loop_start
loop_end:
    mv a0, s0
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    addi sp, sp, 12
    jr ra

exception_36:
    li a0 36
    j exit

exception_37:
    li a0 37
    j exit