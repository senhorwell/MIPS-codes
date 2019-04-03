.data
ent1: .asciiz "insira a string 1: "
ent2: .asciiz "Insira a string 2: "
str1: .space 100
str2: .space 100
str3: .space 100
.text

main:
	la $a0, ent1
	la $a1, str1
	jal leitura
	la $a0, ent2
	la $a1, str2
	jal leitura
	la $a0, str1
	la $a1, str2
	la $a2, str3
	jal intercala
	move $a0, $v0
	li $v0, 4
	syscall
	li $v0, 10
	syscall
	
leitura:
	li $v0, 4
	syscall
	move $v0, $a1
	li $a1, 100
	li $v0, 8
	syscall
	jr $ra
	
intercala:
	move $v0, $a2
	
c1: 
	lb $t1, ($a1)
	beqz $t1, c
	addi $a1, $a1, 1
	beq $t0, 10, c2
	sb $t0, ($a2)
	addi $a2, $a2, 1
	
c2:
	lb $t1, ($a1)
	beqz $t1, c
	addi $a1, $a1, 1
	beq $t1, 10, c
	sb $t1, ($a2)
	addi $a2, $a2, 1
	
c: 
	add $t0, $t0, $t1
	bnez $t0, c1
	sb $zero, ($a2)
	jr $ra