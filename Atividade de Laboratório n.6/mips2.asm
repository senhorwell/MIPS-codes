.data

lower: .ascii "aaaa"

upper: .ascii "xxxx"

.text
main:


loop:
        lb $t1, lower($t0)
    beq $t1, 0, exit
        sub $t1, $t1, 32
        sb $t1, lower($t0)
        add $t0, $t0, 1
        j loop


exit:
        lw $t1, lower
    sw $t1, upper
    li $v0, 10
        syscall