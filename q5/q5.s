.section .rodata
filename: .asciz "input.txt"
mode:     .asciz "r"
yes:      .asciz "Yes\n"
no:       .asciz "No\n"

.section .text
.globl main

.extern fopen
.extern fgetc
.extern fseek
.extern fclose
.extern printf

main:
    addi sp, sp, -32
    sd   ra, 24(sp)
    sd   s0, 16(sp)
    sd   s1, 8(sp)

 
    la   a0, filename
    la   a1, mode
    call fopen
    mv   s0, a0          # s0 = FILE* fp1

    la   a0, filename
    la   a1, mode
    call fopen
    mv   s1, a0          # s1 = FILE* fp2


    # fseek(fp2, -1, SEEK_END) — position fp2 at last char
    mv   a0, s1
    li   a1, -1
    li   a2, 2           # SEEK_END
    call fseek

loop:
    # read front char
    mv   a0, s0
    call fgetc
    li   t0, -1
    beq  a0, t0, is_palindrome   # EOF
    mv   s2, a0          # save front char

    # read back char
    mv   a0, s1
    call fgetc
    mv   s3, a0          # save back char

    # compare
    bne  s2, s3, not_palindrome

    # move fp2 back by 2
    mv   a0, s1
    li   a1, -2
    li   a2, 1           # SEEK_CUR
    call fseek

    j    loop

is_palindrome:
    la   a0, yes
    call printf
    j    end

not_palindrome:
    la   a0, no
    call printf

end:
    mv   a0, s0
    call fclose
    mv   a0, s1
    call fclose

    ld   ra, 24(sp)
    ld   s0, 16(sp)
    ld   s1, 8(sp)
    addi sp, sp, 32
    ret
