.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:
    li t0,5
    bne t0,a0,exception_argument
    # Prologue
    addi sp,sp,-48
    sw s0,0(sp)
    sw s1,4(sp)
    sw s2,8(sp)
    sw s3,12(sp)
    sw s4,16(sp)
    sw s5,20(sp)
    sw s6,24(sp)
    sw s7,28(sp)
    sw s8,32(sp)
    sw s9,36(sp)
    sw s10,40(sp)
    sw s11,44(sp)
    # Read pretrained m0

    addi sp,sp,-16
    sw ra,0(sp)
    sw a0,4(sp)
    sw a1,8(sp)
    sw a2,12(sp)

    lw a0,4(a1) # pointer to the filepath string of m0
    addi sp,sp,-8
    addi a1,sp,0    # an address to store row cnt
    addi a2,sp,4
    jal ra,read_matrix
    mv s0,a0    # stores the address of m0 to s0
    lw s1,0(sp) # stores the row cnt of m0
    lw s2,4(sp)
    addi sp,sp,8
    lw ra,0(sp)
    lw a0,4(sp)
    lw a1,8(sp)
    lw a2,12(sp)
    addi sp,sp,16
    
    # Read pretrained m1
    addi sp,sp,-16
    sw ra,0(sp)
    sw a0,4(sp)
    sw a1,8(sp)
    sw a2,12(sp)
    lw a0,8(a1)
    addi sp,sp,-8
    addi a1,sp,0
    addi a2,sp,4
    jal ra,read_matrix
    mv s3,a0
    lw s4,0(sp)
    lw s5,4(sp)
    addi sp,sp,8

    lw ra,0(sp)
    lw a0,4(sp)
    lw a1,8(sp)
    lw a2,12(sp)
    addi sp,sp,16

    # Read input matrix
    addi sp,sp,-16
    sw ra,0(sp)
    sw a0,4(sp)
    sw a1,8(sp)
    sw a2,12(sp)

    lw a0,12(a1)    # pointer to filenamestring of input matrix
    addi sp,sp,-8
    addi a1,sp,0
    addi a2,sp,4
    jal ra,read_matrix
    mv s6,a0
    lw s7,0(sp)
    lw s8,4(sp)
    addi sp,sp,8

    lw ra,0(sp)
    lw a0,4(sp)
    lw a1,8(sp)
    lw a2,12(sp)
    addi sp,sp,16

    # Compute h = matmul(m0, input)
    addi sp,sp,-16
    sw ra,0(sp)
    sw a0,4(sp)
    sw a1,8(sp)
    sw a2,12(sp)
    mul a0,s1,s8
    slli a0,a0,2
    jal ra,malloc
    beq a0,x0,exception_malloc
    mv s9,a0    # stores allocated address
    lw ra, 0(sp)
    lw a0, 4(sp)
    lw a1, 8(sp)
    lw a2, 12(sp)
    addi sp, sp, 16

    addi sp, sp, -16
    sw ra, 0(sp)
    sw a0, 4(sp)
    sw a1, 8(sp)
    sw a2, 12(sp)
    mv a0,s0
    mv a1,s1
    mv a2,s2
    mv a3,s6
    mv a4,s7
    mv a5,s8
    mv a6,s9
    jal ra,matmul
    lw ra, 0(sp)
    lw a0, 4(sp)
    lw a1, 8(sp)
    lw a2, 12(sp)
    addi sp, sp, 16

    # Compute h = relu(h)
    addi sp,sp,-16
    sw ra,0(sp)
    sw a0,4(sp)
    sw a1,8(sp)
    sw a2,12(sp)
    mv a0,s9
    mul a1,s1,s8
    jal ra,relu
    lw ra,0(sp)
    lw a0,4(sp)
    lw a1,8(sp)
    lw a2,12(sp)
    addi sp,sp,16

    # Compute o = matmul(m1, h)
    addi sp,sp,-16
    sw ra,0(sp)
    sw a0,4(sp)
    sw a1,8(sp)
    sw a2,12(sp)

    mul a0,s4,s8
    slli a0,a0,2
    jal ra,malloc
    beq a0,x0,exception_malloc
    mv s10,a0
    lw ra, 0(sp)
    lw a0, 4(sp)
    lw a1, 8(sp)
    lw a2, 12(sp)
    addi sp, sp, 16
    addi sp, sp, -16
    sw ra, 0(sp)
    sw a0, 4(sp)
    sw a1, 8(sp)
    sw a2, 12(sp)
    mv a0, s3
    mv a1, s4
    mv a2, s5
    mv a3, s9
    mv a4, s1
    mv a5, s8
    mv a6, s10  # stores address of o
    jal ra,matmul
    lw ra, 0(sp)
    lw a0, 4(sp)
    lw a1, 8(sp)
    lw a2, 12(sp)
    addi sp, sp, 16

    # Write output matrix o
    addi sp,sp,-16
    sw ra,0(sp)
    sw a0,4(sp)
    sw a1,8(sp)
    sw a2,12(sp)

    lw a0, 16(a1)   # pointer to the filepath string of the output file
    mv a1, s10
    mv a2, s4
    mv a3, s8
    jal ra,write_matrix
    lw ra,0(sp)
    lw a0,4(sp)
    lw a1,8(sp)
    lw a2,12(sp)
    addi sp,sp,16

    # Compute and return argmax(o)
    addi sp,sp,-16
    sw ra,0(sp)
    sw a0,4(sp)
    sw a1,8(sp)
    sw a2,12(sp)
    mv a0,s10
    mul a1,s4,s8
    jal ra,argmax
    mv s11, a0  # index of the smallest
    lw ra, 0(sp)
    lw a0, 4(sp)
    lw a1, 8(sp)
    lw a2, 12(sp)
    addi sp, sp, 16

    # If enabled, print argmax(o) and newline
    bne a2,x0,end_classify
    addi sp, sp, -16
    sw ra, 0(sp)
    sw a0, 4(sp)
    sw a1, 8(sp)
    sw a2, 12(sp)
    mv a0, s11
    jal ra, print_int
    lw ra, 0(sp)
    lw a0, 4(sp)
    lw a1, 8(sp)
    lw a2, 12(sp)
    addi sp, sp, 16
    addi sp, sp, -16
    sw ra, 0(sp)
    sw a0, 4(sp)
    sw a1, 8(sp)
    sw a2, 12(sp)
    li a0, '\n'
    jal ra print_char
    lw ra, 0(sp)
    lw a0, 4(sp)
    lw a1, 8(sp)
    lw a2, 12(sp)
    addi sp, sp, 16

end_classify:
    addi sp, sp, -16
    sw ra, 0(sp)
    sw a0, 4(sp)
    sw a1, 8(sp)
    sw a2, 12(sp)
    mv a0, s9
    jal ra, free
    lw ra, 0(sp)
    lw a0, 4(sp)
    lw a1, 8(sp)
    lw a2, 12(sp)
    addi sp, sp, 16
    
    addi sp, sp, -16
    sw ra, 0(sp)
    sw a0, 4(sp)
    sw a1, 8(sp)
    sw a2, 12(sp)
    mv a0, s10
    jal ra, free
    lw ra, 0(sp)
    lw a0, 4(sp)
    lw a1, 8(sp)
    lw a2, 12(sp)
    addi sp, sp, 16  

    mv a0, s11
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
    lw s9, 36(sp)
    lw s10, 40(sp)
    lw s11, 44(sp)
    addi sp, sp, 48
    jr ra

exception_argument:
    li a0,31
    j exit
exception_malloc:
    li a0,26
    j exit