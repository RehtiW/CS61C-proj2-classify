.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
write_matrix:

    # Prologue
    addi sp,sp,-12
    sw s0,0(sp)
    sw s1,4(sp)
    sw s2,8(sp)

    addi sp,sp,-16
    sw a1,0(sp)
    sw a2,4(sp)
    sw a3,8(sp)
    sw ra,12(sp)
    li a1,1     # write only
    jal fopen
    li t0,-1
    beq a0,t0,exception_fopen
    lw a1,0(sp)
    lw a2,4(sp)
    lw a3,8(sp)
    lw ra,12(sp)
    addi sp,sp,16

    addi sp,sp,-20
    sw ra,0(sp)
    sw a0,4(sp)
    sw a1,8(sp)
    sw a2,12(sp)
    sw a3,16(sp)
    lw s0,0(a1) # temp
    sw a2,0(a1)
    li a2,1
    li a3,4
    jal ra, fwrite
    li a2,1
    bne a2,a0,exception_fwrite
    lw ra,0(sp)
    lw a0,4(sp)
    lw a1,8(sp)
    lw a2,12(sp)
    lw a3,16(sp)
    addi sp,sp,20
    sw s0,0(a1) # store back

    addi sp,sp,-20
    sw ra,0(sp)
    sw a0,4(sp)
    sw a1,8(sp)
    sw a2,12(sp)
    sw a3,16(sp)
    lw s0,0(a1) # temp
    sw a3,0(a1)
    li a2,1
    li a3,4
    jal ra, fwrite
    li a2,1
    bne a2,a0,exception_fwrite
    lw ra,0(sp)
    lw a0,4(sp)
    lw a1,8(sp)
    lw a2,12(sp)
    lw a3,16(sp)
    addi sp,sp,20
    sw s0,0(a1) # store back

    addi sp,sp,-20
    sw ra,0(sp)
    sw a0,4(sp)
    sw a1,8(sp)
    sw a2,12(sp)
    sw a3,16(sp)
    mul a2,a2,a3    # amount to write
    mv s0,a2
    li a3,4         # byte size
    jal ra, fwrite
    bne s0,a0,exception_fwrite
    lw ra,0(sp)
    lw a0,4(sp)
    lw a1,8(sp)
    lw a2,12(sp)
    lw a3,16(sp)
    addi sp,sp,20


    addi sp,sp,-4
    sw ra,0(sp)
    jal ra,fclose
    bne a0,x0,exception_fclose
    lw ra,0(sp)
    addi sp,sp,4

    # Epilogue
    lw s0,0(sp)
    lw s1,4(sp)
    lw s2,8(sp)
    addi sp,sp,12

    jr ra


exception_fopen:
    li a0,27
    j exit
exception_fwrite:
    li a0,30
    j exit
exception_fclose:
    li a0,28
    j exit
