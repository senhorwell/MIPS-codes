#Ex3 - Lista 4
.data
msgEntrada: .asciiz "\nEntre com o valor: "
msgSemiprimo: .asciiz "\nO valor é semiprimo."
msgNSemiprimo: .asciiz "\nO valor não é semiprimo."

#s0: Valor armazenado
#s1: "boolean" 1 para semiprimo, 0 para não semiprimo

.text
main:	li $s1, 0
	jal leitura
	move $s0, $v0
	jal calcula
	beq $s1, 0, saidaNSP
	beq $s1, 1, saidaSP




leitura:	la $a0, msgEntrada
		li $v0, 4
		syscall
		li $v0, 5
		syscall
		jr $ra

calcula:	
		add $t0, $zero, $s0
		li $t1, 1
		li $t4, 0
		laço2:	
			addi $t1, $t1, 1
			div $t0, $t1
			mfhi $t3
			bgtz $t3, laço2	
			
			li $t6, 0
			li $t5, 1						
			laço2p2:	div $t1, $t5
					mfhi $t3
					addi $t5, $t5, 1
					bgtz $t3, laço2p2
					addi $t6, $t6, 1
					ble $t5, $t1, laço2p2
					bne $t6, 2, laço2
									
			li $t2, 1
			laço3:	
				addi $t2, $t2, 1
				div $t0, $t2
				mfhi $t3
				bgtz $t3, laço3
			
				li $t6, 0	
				li $t5, 1						
				laço3p2:	div $t2, $t5
						mfhi $t3
						addi $t5, $t5, 1
						bgtz $t3, laço3p2
						addi $t6, $t6, 1
						ble $t5, $t2, laço3p2
						bne $t6, 2, laço3
				
				mul $t4, $t1, $t2
				beq $t4, $t0, semiprimo
				bne $t4, $t0, nsemiprimo
				blt $t2, $t0, laço3
			blt $t1, $t0, laço2
		jr $ra
		
semiprimo:	li $s1, 1
		jr $ra
		
nsemiprimo:	li $s1, 0
		jr $ra

saidaSP:	la $a0, msgSemiprimo
		li $v0, 4
		syscall
		li $v0, 10
		syscall
		

saidaNSP:	la $a0, msgNSemiprimo
		li $v0, 4
		syscall
		li $v0, 10
		syscall