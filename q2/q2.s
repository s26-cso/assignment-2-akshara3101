.section .rodata
fmt: .string "%d "
fmt2: .string "\n"

.section .text
.globl main

main:
    addi sp, sp, -72
    sd ra, 64(sp)
    sd s0, 56(sp)    # n
    sd s1, 48(sp)    # argv base
    sd s2, 40(sp)    # arr ptr
    sd s3, 32(sp)    # res ptr
    sd s4, 24(sp)    # stack ptr
    sd s5, 16(sp)    # argc

    mv s5, a0        # argc
    mv s1, a1        # argv = array of pointers to strings
    addi s0, s5, -1  # n = argc - 1

    
    mv t0, s0        # t0 = n
    slli t0, t0, 2   # t0 = n * 4 bytes
    mv a0, t0
    call malloc
    mv s2, a0        # s2 = arr pointer


    
    li s3, 1    # i = 1
    mv s4, s2

read_input:
    bge s3, s5, done_read

    slli t0, s3, 3   # offset = i*8 (pointer=8 bytes)
    add t0, t0, s1
    ld a0, 0(t0)    # argv[i]

    call atoi

    sw a0, 0(s4)    # store in arr[index]

    addi s4, s4, 4
    addi s3, s3, 1
    j read_input

done_read:
   
    j next_greater

next_greater:
    mv t0, s0        # t0 = n
    slli t0, t0, 2   # t0 = n * 4 bytes
    mv a0, t0
    call malloc
    mv s3, a0        # s3 = res pointer

    mv t0, s0        # t0 = n
    slli t0, t0, 2   # t0 = n * 4 bytes
    mv a0, t0
    call malloc
    mv s4, a0        # s4 = stack pointer

    mv a0, s2
    addi a1, s0, -1  #a1= n-1
    li t1, -1       # t1 = top = -1
    mv a2, s3
    mv a3, s4
   # a0=arr, a1=n-1 (start index), a2=res, a3=stack, t1=top=-1

loop:
    blt a1, x0, done  # if i<0 stop
    slli t2, a1, 2  #t2= i*4
    add t3, a0, t2  
    lw t4, 0(t3)       # t4 = arr[i]
while_loop:
    li t5, -1
    beq t1, t5, after_while  #if t1==-1 i.e top==-1

    # stack[top]
    slli t2, t1, 2
    add t3, a3, t2
    lw t6, 0(t3)       # index

    # arr[stack[top]]
    slli t2, t6, 2
    add t3, a0, t2
    lw t3, 0(t3)

    bgt  t3, t4, after_while  # stop if stack top is greater
    addi t1, t1, -1           # pop
    j    while_loop
 

after_while:
    slli t2, a1, 2
    add t3, a2, t2     # res[i]

    li   t5, -1
    beq t1, t5, no_greater

    # result[i] = stack[top]
    slli t2, t1, 2
    add  t2, a3, t2
    lw   t6, 0(t2)            # index of next greater
    sw   t6, 0(t3)
    j    push

no_greater:
    li t6, -1
    sw t6, 0(t3)

push:
    addi t1, t1, 1
    slli t2, t1, 2 #t2=t1*4
    add t2, t2, a3
    sw a1, 0(t2)

    addi a1, a1, -1
    bge a1, x0, loop
    

done:
    li s4, 0        # i = 0 
    j print_loop


print_loop:
    bge s4, s0, done_print
    lw a1, 0(s3)
    la a0, fmt
    call printf

    addi s3, s3, 4
    addi s4, s4, 1
    j print_loop

done_print:
    la a0, fmt2
    call printf

    ld  ra, 64(sp)    
    ld  s0, 56(sp)
    ld  s1, 48(sp)
    ld  s2, 40(sp)
    ld  s3, 32(sp)
    ld  s4, 24(sp)
    ld  s5, 16(sp)
    addi sp, sp, 72
    ret


