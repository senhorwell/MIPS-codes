.data
	buffer: .asciiz " "
	Arquivo: .asciiz "dados.txt"
	Msg: .asciiz "O total de caracteres é: "
	Erro: .asciiz "Arquivo n�o encontrado!\n"
	nl: .asciiz "\n"
.text

main:
	li $a3, 0
	la $a0, Arquivo # Nome do arquivo
	li $a1, 0 # Somente leitura
	jal abertura # Retorna file descriptor no sucesso
	move $s0, $v0 # Salva o file descriptor em $s0
	move $a0, $s0 # Par�metro file descriptor
	la $a1, buffer # Buffer de entrada
	li $a2, 1 # 1 caractere por leitura
	jal leitura # Retorna a soma dos n�meros do arquivo	
	move $a0, $v0 # Move o resultado para impress�o
	li $v0, 1 # C�digo de impress�o de inteiro
	syscall # Imprime o resultado
	
	la $a0, Msg
	li $v0, 4
	syscall
	move $a0, $a3
	li $v0, 1
	syscall
	
	li $v0, 16 # C�digo para fechar o arquivo
	move $a0, $s0 # Par�metro file descriptor
	syscall # Fecha o arquivo
	li $v0, 10 # C�digo para finalizar o programa
	syscall # Finaliza o programa

leitura:
	li $v0, 14 # C�digo de leitura de arquivo
	syscall # Faz a leitura de 1 caractere
	beqz $v0, f # if(EOF) termina a leitura
	lb $t0, ($a1) # Carrega o caractere lido no buffer
	beq $t0, 13, leitura # if(carriage return) ignora
	
	move $a0, $t0
	li $v0, 11 # C�digo de leitura de arquivo
	syscall # Faz a leitura de 1 caractere
	
	beq $t0, 32, space
	addi $a3, $a3, 1
	j leitura # Continua a leitura do n�mero
	space:
	j leitura # Continua a leitura do n�mero
	
	f:
	jr $ra # Retorna para a main
	
abertura:
	li $v0, 13 # C�digo de abertura de arquivo
	syscall # Tenta abrir o arquivo
	bgez $v0, a # if(file_descriptor >= 0) goto a
	la $a0, Erro # else erro: carrega o endere�o da string
	li $v0, 4 # C�digo de impress�o de string
	syscall # Imprime o erro
	li $v0, 10 # C�digo para finalizar o programa
	syscall # Finaliza o programa
	a: jr $ra # Retorna para a main
