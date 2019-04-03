#Ex.2 - Lista 4

.data
msgEntrada: .asciiz "\nInsira um valor: "
msgA: .asciiz "\nMaior valor inteiro: "
msgB: .asciiz "\nMenor valor inteiro: "
msgC: .asciiz "\nSoma dos impares: "
msgD: .asciiz "\nSoma dos pares: "
msgE: .asciiz "\nNúmero de inteiros primos: "
msgF: .asciiz "\nNúmero de inteiros amigos: "
msgG: .asciiz "\nNúmero de inteiros perfeitos: "

#s0: Valor a ser comparado
#s1: Maior valor
#s2: Menor valor
#s3: Soma dos impares
#s4: Soma dos pares
#s5: Número de inteiros primos
#s6: Número de inteiros amigos
#s7: Número de inteiros perfeitos
#t0: Valor lido
#t1: Usado para manipulação
#t2: Usado para manipulação
#t3: Usado para manipulação
#t4: Usado para manipulação
#t7: Contador (10)

.text
main:	li $s1, 0
	li $s2, 99999999
	li $s3, 0
	li $s4, 0
	li $s5, 0
	li $s6, 0
	li $s7, 0
	li $t7, 10
	laço1:	jal leitura
		move $t0, $v0
		move $s0, $v0
		jal calculoA
		jal calculoB
		jal calculoC
		jal calculoD
		jal calculoE
		jal calculoF
		jal calculoG
		addi $t7, $t7, -1
		beq $t7, $zero, saida
		j laço1
	
leitura:	la $a0, msgEntrada
		li $v0, 4
		syscall
		li $v0, 5
		syscall
		jr $ra

calculoA:	ble $t0, $s1, breakFlux
		add $s1, $zero, $t0
		jr $ra 

calculoB:	bge $s0, $s2, breakFlux
		add $s2, $zero, $s0
		jr $ra 

calculoC:	li $t2, 2
		div $t0, $t2
		mfhi $t1
		beq $t1, 0, breakFlux
		add $s3, $s3, $t0
		jr $ra

calculoD:	li $t2, 2
		div $t0, $t2
		mfhi $t1
		beq $t1, 1, breakFlux
		add $s4, $s4, $t0
		jr $ra
		
calculoE:	li $t1, 1
		li $t4, 0
		laço2:	div $t0, $t1
			mfhi $t3
			addi $t1, $t1, 1
			bgtz $t3, laço2
			addi $t4, $t4, 1
			ble $t1, $t0, laço2
		bne $t4, 2, breakFlux
		addi $s5, $s5, 1
		
calculoF:	li $t1, 0
		li $t4, 0
		laço3:	addi $t1, $t1, 1
			bge $t1, $t0, end3
			div $t0, $t1
			mfhi $t3
			bgtz $t3, laço3
			add $t4, $t4, $t1
			j laço3
		end3:
		add $t2, $zero, $t4		
		laço4:	addi $t1, $t1, 1
			bge $t1, $t2, end4
			div $t2, $t1
			mfhi $t3
			bgtz $t3, laço4
			add $t4, $t4, $t1
			j laço4
		end4:
		bne $t4, $t0, breakFlux
		addi $s6, $s6, 1

calculoG:	li $t1, 1
		li $t4, 0
		laço5:	div $t0, $t1
			mfhi $t3
			addi $t1, $t1, 1
			bgtz $t3, laço5
			add $t4, $t4, $t1
			ble $t1, $t0, laço5
		mul $t1, $t0, 2
		bne $t4, $t1, breakFlux
		addi $s7, $s7, 1

breakFlux:	jr $ra	

saida:	la $a0, msgA
	li $v0, 4
	syscall
	move $a0, $s1
	li $v0, 1
	syscall
	la $a0, msgB
	li $v0, 4
	syscall
	move $a0, $s2
	li $v0, 1
	syscall
	la $a0, msgC
	li $v0, 4
	syscall
	move $a0, $s3
	li $v0, 1
	syscall
	la $a0, msgD
	li $v0, 4
	syscall
	move $a0, $s4
	li $v0, 1
	syscall
	la $a0, msgE
	li $v0, 4
	syscall
	move $a0, $s5
	li $v0, 1
	syscall
	la $a0, msgF
	li $v0, 4
	syscall
	move $a0, $s6
	li $v0, 1
	syscall
	la $a0, msgG
	li $v0, 4
	syscall
	move $a0, $s7
	li $v0, 1
	syscall
	li $v0, 10
	syscall
