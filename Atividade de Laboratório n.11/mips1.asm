.data
	buffer: .asciiz " "
	Arquivo: .asciiz "dados.txt"
	Saida: .asciiz "saida.txt"
	Msg: .asciiz "Apostila de MIPS"
	Msg1: .asciiz "O maior valor do arquivo de entrada eh "
	Msg2: .asciiz "O menor valor do arquivo de entrada eh "
	Msg3: .asciiz "O numero de elementos pares do arquivo de entrada eh "
	Msg4: .asciiz "O numero de elementos impares do arquivo de entrada eh "
	Msg5: .asciiz "O numero de elementos primos do arquivo de entrada eh "
	Erro: .asciiz "Arquivo nao encontrado!\n"
	nl: .asciiz "\n"
.text

#s1: Maior valor
#s2: Menor valor
#s3: Soma dos impares
#s4: Soma dos pares
#s5: Número de inteiros primos

main:
	li $s1, 0
	li $s2, 99999999
	li $s3, 0
	li $s4, 0
	li $s5, 0
	la $a0, Arquivo # Nome do arquivo
	li $a1, 0 # Somente leitura
	jal abertura # Retorna file descriptor no sucesso
	move $s0, $v0 # Salva o file descriptor em $s0
	move $a0, $s0 # Parâmetro file descriptor
	la $a1, buffer # Buffer de entrada
	li $a2, 1 # 1 caractere por leitura
	jal leitura # Retorna a soma dos números do arquivo
	move $a0, $v0 # Move o resultado para impressão
	li $v0, 1 # Código de impressão de inteiro
	syscall # Imprime o resultado
	li $v0, 16 # Código para fechar o arquivo
	move $a0, $s0 # Parâmetro file descriptor
	syscall # Fecha o arquivo
	li $v0, 10 # Código para finaliza
	syscall # Finaliza o programa
leitura:
	li $v0, 14 # Código de leitura de arquivo
	syscall # Faz a leitura de 1 caractere
	beqz $v0, f # if(EOF) termina a leitura
	lb $t0, ($a1) # Carrega o caractere lido no buffer
	beq $t0, 13, leitura # if(carriage return) ignora
	beq $t0, 10, l # if(newline) goto l
	subi $t0, $t0, 48 # char para decimal
	mul $t1, $t1, 10 # Casa decimal para a esquerda
	add $t1, $t1, $t0 # Soma a unidade lida
	j leitura # Continua a leitura do número
	l:
	move $s0, $t1
		jal calculoA
		jal calculoB
		jal calculoC
		jal calculoD
		jal calculoE
	li $t1, 0 # Zera o número
	j leitura # Leitura do próximo número
	f: add $v0, $t2, $t1 # Resultado da soma em $v0
	jr $ra # Retorna para a main

escrita:
	la $a0, Saida # Nome do arquivo
	li $a1, 1 # Somente escrita
	li $v0, 13 # Código de abertura de arquivo
	syscall # Abre o arquivo (se não existir, será criado)
	move $a0, $v0 # Parâmetro file descriptor

	addi $s1, $s1, 48 # decimal para char
	addi $s2, $s2, 48 # decimal para char
	addi $s3, $s3, 48 # decimal para char
	addi $s4, $s4, 48 # decimal para char
	addi $s5, $s5, 48 # decimal para char

	li $v0, 15 # Código de escrita em arquivo
	la $a1, Msg1 # Buffer de saída
	li $a2, 39 # 16 caracteres
	syscall # Escreve a mensagem no arquivo
	li $v0, 15 # Código de escrita em arquivo
	move $a1, $s1 # Buffer de saída
	li $a2, 2 # 16 caracteres
	syscall # Escreve a mensagem no arquivo
	
	li $v0, 15 # Código de escrita em arquivo
	la $a1, Msg2 # Buffer de saída
	li $a2, 39 # 16 caracteres
	syscall # Escreve a mensagem no arquivo
	li $v0, 15 # Código de escrita em arquivo
	move $a1, $s2 # Buffer de saída
	li $a2, 2 # 16 caracteres
	syscall # Escreve a mensagem no arquivo

	
	li $v0, 15 # Código de escrita em arquivo
	la $a1, Msg3 # Buffer de saída
	li $a2, 53 # 16 caracteres
	syscall # Escreve a mensagem no arquivo
	li $v0, 15 # Código de escrita em arquivo
	move $a1, $s3 # Buffer de saída
	li $a2, 2 # 16 caracteres
	syscall # Escreve a mensagem no arquivo
	
	li $v0, 15 # Código de escrita em arquivo
	la $a1, Msg4 # Buffer de saída
	li $a2, 55 # 16 caracteres
	syscall # Escreve a mensagem no arquivo
	li $v0, 15 # Código de escrita em arquivo
	move $a1, $s4 # Buffer de saída
	li $a2, 2 # 16 caracteres
	syscall # Escreve a mensagem no arquivo
	
	li $v0, 15 # Código de escrita em arquivo
	la $a1, Msg5 # Buffer de saída
	li $a2, 54 # 16 caracteres
	syscall # Escreve a mensagem no arquivo
	li $v0, 15 # Código de escrita em arquivo
	move $a1, $s5 # Buffer de saída
	li $a2, 2 # 16 caracteres
	syscall # Escreve a mensagem no arquivo

	li $v0, 16 # Código para fechar o arquivo
	syscall # Fecha o arquivo
	li $v0, 10 # Código para finaliz
	
abertura:
	li $v0, 13 # Código de abertura de arquivo
	syscall # Tenta abrir o arquivo
	bgez $v0, a # if(file_descriptor >= 0) goto a
	la $a0, Erro # else erro: carrega o endereço da string
	li $v0, 4 # Código de impressão de string
	syscall # Imprime o erro
	li $v0, 10 # Código para finalizar o programa
	syscall # Finaliza o programa
	a: jr $ra # Retorna para a main

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
		jr $ra

breakFlux:	jr $ra	
