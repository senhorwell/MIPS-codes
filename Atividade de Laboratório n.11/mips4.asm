.data
	buffer: .asciiz " "
	Arquivo: .asciiz "dados.txt"
	Erro: .asciiz "Arquivo n�o encontrado!\n"
	Msg1: .asciiz "(DE)CIFRADOR DE ARQUIVO\n"
	Msg2: .asciiz "1 - Decifrar\n"
	Msg3: .asciiz "2 - Cifrar\n"
	Msg4: .asciiz "Opção: "
	Msg5: .asciiz "Chave K: "
	nl: .asciiz "\n"
.text

main:
	li $a3, 0
	la $a0, Arquivo # Nome do arquivo
	li $a1, 0 # Somente leitura
	jal abertura # Retorna file descriptor no sucesso
	move $s0, $v0 # Salva o file descriptor em $s0
	move $a0, $s0 # Par�metro file descriptor
	
	li $v0, 4 # C�digo de impress�o de string
	la $a0, Msg1 # else erro: carrega o endere�o da string
	syscall # Imprime a msg
	la $a0, Msg2 # else erro: carrega o endere�o da string
	syscall # Imprimea msg
	la $a0, Msg3 # else erro: carrega o endere�o da string
	syscall # Imprime a msg
	la $a0, Msg4 # else erro: carrega o endere�o da string
	syscall # Imprime a msg
	li $v0, 5 # C�digo de impress�o de string
	syscall
	move $t7, $v0 #opção escolhida
	li $v0, 4 # C�digo de impress�o de string
	la $a0, Msg5 # else erro: carrega o endere�o da string
	syscall # Imprimea msg
	li $v0, 5 # C�digo de impress�o de string
	syscall
	move $s7, $v0 #chave
	
	move $a0, $s0 # Par�metro file descriptor
	la $a1, buffer # Buffer de entrada
	li $a2, 2 # 1 caractere por leitura
	jal leitura # Retorna a soma dos n�meros do arquivo	
	
	li $v0, 16 # C�digo para fechar o arquivo
	move $a0, $s0 # Par�metro file descriptor
	syscall # Fecha o arquivo
	li $v0, 10 # C�digo para finalizar o programa
	syscall # Finaliza o programa

leitura:
	li $v0, 14 # Código de leitura de arquivo
	syscall # Faz a leitura de 1 caractere
	move $t5, $v0
	move $t6, $a0
	lb $t0, ($a1) # Carrega o caractere lido no buffer
	move $a0, $t0
	li $v0, 11
	syscall
	
	move $a0, $t6
	bnez $t5, leitura # if(ch != EOF) goto contagem
	
	move $t5, $v0
	move $t6, $a0
	lb $t0, ($a1) # Carrega o caractere lido no buffer
	move $a0, $t0
	li $v0, 11
	syscall
	move $v0, $t0 # Move o resultado para retorno
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
