inicializa:
	addi $sp,$sp,-40
	
	sw $t9,36($sp)
	sw $t8,32($sp)
	sw $s7,28($sp)
	sw $s6,24($sp)
	sw $s5,20($sp)
	sw $s4,16($sp)
	sw $s3,12($sp)
	sw $s2,8($sp)
	sw $s1,4($sp)
	sw $s0,0($sp)
	
	#t7 vetor i
	#t6 indice i = -4
	
	#t3 valor = 40

	#t0 indice de impares = 0
	#a0 maior = FFFFFFFF
	#a1 menor = 0
loop:	
	addi $t6,$t6,4;
	beq $t6,$t3,exit
	lw $t7,$t6($sp)
	
	slt $t1,$t7,$a0
	beq $t1,$zero,maior
	
	slt $t1,$t7,$a1
	beq $t1,$zero,menor
	
	j loop

maior:
	and $a0,$a0,$zero
	add $a0,$a0,$t7
	j loop
menor:
	and $a1,$a1,$zero
	add $a0,$a0,$t7
	j loop
	
exit: