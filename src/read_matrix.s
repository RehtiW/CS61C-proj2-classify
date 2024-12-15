.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:

    # Prologue
    addi sp,sp,-12
    sw s0,0(sp)
    sw s1,4(sp)
    sw s2,8(sp)

    addi sp,sp,-12
    sw ra,0(sp)
    sw a1,4(sp)
    sw a2,8(sp)
    li a1,0
    jal ra,fopen
    li t0,-1
    beq a0,t0,exception_fopen
    lw ra,0(sp)
    lw a1,4(sp)    # a0 stores file descriptor
    lw a2,8(sp)
    addi sp,sp,12

    # read information
    addi sp,sp,-16
    sw a0,0(sp)     # a0 stores file descriptor
    sw a1,4(sp)
    sw a2,8(sp)
    sw ra,12(sp)
    li a2, 4
    jal ra,fread
    li a2, 4
    bne a2,a0,exception_fread
    lw a0,0(sp)     
    lw a1,4(sp)
    lw a2,8(sp)
    lw ra,12(sp)
    addi sp,sp,16  
    lw s1,0(a1)     # s1 stores the number of row

    # read information
    addi sp,sp,-16
    sw a0,0(sp)     # a0 stores file descriptor
    sw a1,4(sp)
    sw a2,8(sp)
    sw ra,12(sp)
    mv a1,a2        
    li a2, 4
    jal ra,fread
    li a2, 4
    bne a2,a0,exception_fread
    lw a0,0(sp)     
    lw a1,4(sp)
    lw a2,8(sp)
    lw ra,12(sp)
    addi sp,sp,16  
    lw s2,0(a2)     # s2 stores the number of column

    # malloc
    mul t0,s1,s2
    slli t0,t0,2    # calculate the bytes to allocate
    addi sp,sp,-16
    sw ra,0(sp)
    sw a0,4(sp)
    sw a1,8(sp)
    sw a2,12(sp)
    mv a0,t0
    jal ra,malloc
    beq a0,x0,exception_malloc
    mv s0,a0        # s0 stores the address of the matrix
    lw ra,0(sp)
    lw a0,4(sp)     # a0 still stores the file descriptor
    lw a1,8(sp)
    lw a2,12(sp)
    addi sp,sp,16
    li t1,0         # loop counter
read_loop:
    addi sp,sp,-20
    sw t1,16(sp)
    sw ra,0(sp)
    sw a0,4(sp)
    sw a1,8(sp)
    sw a2,12(sp)
    mul t0,t1,s2    # counter * columns
    slli t0,t0,2
    add a1,s0,t0    # manage a1    
    li t0,4
    mul t0,t0,s2   # 4 * columns 
    mv a2,t0
    jal ra,fread
    li t0,4
    mul a2,t0,s2
    bne a2,a0,exception_fread
    
    lw t1,16(sp)
    lw ra,0(sp)
    lw a0,4(sp)
    lw a1,8(sp)
    lw a2,12(sp)
    addi sp,sp,20
    addi t1,t1,1

    blt t1,s1,read_loop
loop_end:
    addi sp,sp,-4
    sw ra,0(sp)
    jal ra,fclose
    bne a0,x0,exception_fclose
    lw ra,0(sp)
    addi sp,sp,4
    mv a0,s0
    # Epilogue
    lw s0,0(sp)
    lw s1,4(sp)
    lw s2,8(sp)
    addi sp,sp,12
    jr ra

exception_malloc:
    li a0,26
    j exit
exception_fopen:
    li a0,27
    j exit
exception_fclose:
    li a0,28
    j exit
exception_fread:
    li a0,29
    j exit