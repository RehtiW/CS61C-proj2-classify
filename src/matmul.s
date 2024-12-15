.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
matmul:

    # Error checks
    bge x0, a1, exception_38
    bge x0, a2, exception_38
    bge x0, a4, exception_38
    bge x0, a5, exception_38
    bne a2, a4, exception_38
    # Prologue
    addi sp, sp, -12
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    
    add s0, x0, x0 # set the outer counter
outer_loop_start:
    add s1, x0, x0 # set the inner counter

inner_loop_start:
    mul t0, s0, a5 
    add t0, t0, s1
    slli t0, t0, 2 # 4*(s1+s0*a5)
    add s2, t0, a6 # calculate the location to put the result
    
    mul t0, s0, a2 
    slli t0, t0, 2
    add t0, t0, a0 # t0 stores the temp address of current arr1
    slli t1, s1, 2 
    add t1, a3, t1 # t1 stores the temp address of current arr2
    addi t2, x0, 1 # t2 stores the stride of arr1
    add t3, x0, a5 # t3 stores the stride of arr2
    # Prologue
    addi sp, sp, -32
    sw ra, 0(sp)
    sw a0, 4(sp)
    sw a1, 8(sp)
    sw a2, 12(sp)
    sw a3, 16(sp)
    sw a4, 20(sp)
    sw a5, 24(sp)
    sw a6, 28(sp)
    mv a0, t0
    mv a1, t1
    mv a3, t2
    mv a4, t3
    
    jal ra, dot   
    sw a0, 0(s2)

    # Epilogue
    lw ra, 0(sp)
    lw a0, 4(sp)
    lw a1, 8(sp)
    lw a2, 12(sp)
    lw a3, 16(sp)
    lw a4, 20(sp)
    lw a5, 24(sp)
    lw a6, 28(sp)
    addi sp, sp, 32
inner_loop_end:
    addi s1, s1, 1
    blt s1, a5, inner_loop_start

outer_loop_end:
    addi s0, s0, 1
    blt s0, a1, outer_loop_start
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    addi sp, sp, 12
    jr ra

exception_38:
    li a0, 38
    j exit
    