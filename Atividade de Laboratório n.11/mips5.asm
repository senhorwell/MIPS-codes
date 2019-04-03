
######################################################### [ VARIÁVEIS GLOBAIS ] ##############################################################
.data
Buffer: .space 20
buffer: .asciiz " "
Arquivo: .asciiz "dados.txt"
Erro: .asciiz "Arquivo não encontrado!\n"
newline: .asciiz "\r\n"
# Prompts
promptLin: .asciiz "Número de elementos ( Entre com n-1): "
promptLin2: .asciiz "Número do indice que quer alterar: "

# Exibição de resultados"
printMatriz: .asciiz "\n\t[VETOR]\n"

# Caracteres e organização
nl: .asciiz "\n"
tab: .asciiz "  "
sp: .asciiz " "


########################################################### [ MAIN ] #########################################################################

				
.globl main
.text

main:
	la $a0, Arquivo # Nome do arquivo
	li $a1, 0 # Somente leitura
	jal abertura # Retorna file descriptor no sucesso
	move $s7, $v0 # Salva o file descriptor em $s0
	jal nova_matriz # Aloca espaço para nova matriz
	jal leitura # Lẽ inteiros da matriz
	jal print_matriz # Imprime matriz
	bne $s2, $s3, fechar # Se não for matriz quadrada, não troca linhas e colunas nem faz a análise dos pares e ímpares relativos à diagonal
	jal fechar


########################################################### [ AUXILIARES ] ###################################################################


indice:
	# Função que recebe índice i, j, e número de colunas e retorna o endereço na matriz
	
	move $v0, $a0 # Multiplica índice i pelo número de colunas
	sll $v0, $v0, 2 # Multiplica por 4 (tamanho de inteiro)
	add $v0, $v0, $a3 # Adiciona ao endereço base da matriz
	jr $ra # Retorna para o caller
	

############################################################ [ FUNÇÕES ] #####################################################################
	
	
print_matriz:
	# Variáveis temporárias:
		# $t0 = i
		# $t1 = j
		# $t2 = recebe elemento M[i][j]
	
	li $t0, 0
	move $t8, $ra
	
	print_ext:
		beq $t0, $s3, fim_print # Se t0 = número de linhas, fim da impressão
		li $v0, 4
		la $a0, tab
		syscall
		
		# Define argumentos de índice
		move $a0, $t0 # i

		move $a3, $s1 # endereço base
		jal indice
		move $t2, $v0
		
		
		li $v0, 1
		lw $a0, ($t2)
		syscall # Imprime elemento
		
		beq $t0,$s4, chegou
		addi $t0, $t0, 1 # Incrementa i
		j print_ext
		
		chegou:
			move $v0, $t0
			addi $t2, $t2, 1
			sw $v0, ($t2)
			addi $t0, $t0, 1 # Incrementa i
			j print_ext
		
		
fim_print:
	move $ra, $t8
	jr $ra # Retorna para main
	



##############################################################################################################################################

nova_matriz:
	getSize:
		# Variáveis salvas:
			# $s0 = Número de bits da matriz
			# $s1 = Endereço base da matriz
			# $s2 = Número de colunas da matriz
			# $s3 = Número de linhas da matriz

		# Variáveis temporárias:
			#$t0 = Número de linhas da matriz
			#$t1 = Número de colunas da matriz
		li $v0, 4
		la $a0, promptLin
		syscall # Imprime mensagem pedindo número de linhas
		li $v0, 5
		syscall # Lẽ entrada do número de linhas
		move $t0, $v0 # Copia valor da entrada para $t0
		move $s3, $t0 # Copiar para variável salva $s3
		li $v0, 4
		la $a0, promptLin2
		syscall # Imprime mensagem pedindo número de linhas
		li $v0, 5
		syscall # Lẽ entrada do número de linhas
		move $t0, $v0 # Copia valor da entrada para $t0
		move $s4, $t0 # Copiar para variável salva $s3
	
	alocação:
		li $s0, 0 # Limpa $s0
		move $s0, $t0 # Multiplica linhas por colunas e guarda em $s0
		mul $s0, $s0, 4 # Multiplica (linhasxcolunas) * 4, que é o número de bits por inteiro
		
		li $v0, 9
		la $a0, ($s0)
		syscall # Aloca $s0 bits na memória heap para a matriz
		move $s1, $v0 # Passa endereço da memória alocada para $s1
		
	fim_matriz:
		jr $ra # Retorna para matriz
		
		
##############################################################################################################################################

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
	
intstring:
	div $a0, $a0, 10 # n = n / 10
	mfhi $t0 # aux = resto
	subi $sp, $sp, 4 # Espaço para 1 item na pilha
	sw $t0, ($sp) # Empilha o resto da divisão
	addi $v0, $v0, 1 # Número de caracteres++
	bnez $a0, intstring # if(n != 0) goto intstring
	i: lw $t0, ($sp) # Desempilha um resto de divisão
	addi $sp, $sp, 4 # Libera espaço de 1 item na pilha
	add $t0, $t0, 48 # Converte a unidade (0-9) para caractere
	sb $t0, ($a1) # Armazena no buffer de saída
	addi $a1, $a1, 1 # Incrementa o endereço do buffer
	addi $t1, $t1, 1 # i++
	bne $t1, $v0, i # if(iterações != num. carac.) goto i
	sb $zero, ($a1) # Armazena NULL no buffer de saída
	jr $ra # Retorna para o caller

escreveImpar:
	move $t2, $ra # aux = retorno para a main
	e: li $v0, 5 # Código de leitura de inteiro
	syscall # Faz a leitura de um inteiro N
	blez $v0, s # if(N == 0) goto s
	andi $t0, $v0, 1 # Armazena 0 se N for par, 1 se ímpar
	beqz $t0, e # if(N par) goto e
	move $a0, $v0 # Parâmetro N para intstring
	la $a1, Buffer # Buffer de saída
	li $v0, 0 # Zera o contador
	li $t1, 0 # Zera o contador
	jal intstring # Converte N para string em $a1
	move $a0, $s0 # Parâmetro file descriptor
	la $a1, Buffer # Buffer de saída
	move $a2, $v0 # Número de caracteres para escrita
	li $v0, 15 # Código de escrita em arquivo
	syscall # Escreve o número no arquivo
	la $a1, newline # Endereço da string "\r\n"
	li $a2, 2 # 2 caracteres
	li $v0, 15 # Código de escrita em arquivo
	syscall # Pula linha no arquivo
	j e # goto e
	s: jr $t2 # Retorna para a main

##############################################################################################################################################

leitura:
	# Variáveis temporárias:
		# $t0 = i (linha)
		# $t1 = j (coluna)
		# $t3 = recebe índice($t0, $t1, $s1) e diz onde guardar o inteiro
		# $t9 = guarda retorno para main
	
	move $t9, $ra
	li $t0, -1
	loop_i:
		li $t1, 0
		addi $t0, $t0, 1 # Incrementa i
		beq $t0, $s3, fim_leitura
		
		# Argumentos para índice
		move $a0, $t0 # i
		move $a3, $s1 # Endereço base da matriz
	
		jal indice
		
		move $t3, $v0 # Recebe endereço da posição M[i][j]
	
		larq:
		move $a0, $s7 # Parâmetro file descriptor
		la $a1, buffer # Buffer de entrada
		li $a2, 1 # 1 caractere por leitura
		li $v0, 14 # Código de leitura de arquivo
		syscall # Faz a leitura de 1 caractere
		
		lb $t5, ($a1) # Carrega o caractere lido no buffer
		beq $t5, 13, larq # if(carriage return) ignora
		beq $t5, 10, l # if(newline) goto l
		subi $t5, $t5, 48 # char para decimal
		mul $t6, $t6, 10 # Casa decimal para a esquerda
		add $t6, $t6, $t5 # Soma a unidade lida
		j larq # Continua a leitura do número
		l: 
		move $v0, $t6
		sw $v0, ($t3)
		li $t6, 0 # Zera o número
		
		
		j loop_i # Se $t1 = número de colunas, incrementa i
		nop
	fim_leitura:
		li $v0, 4
		la $a0, printMatriz
		syscall
		la $a0, nl
		syscall
		move $ra, $t9
		jr $ra
	
########################################################## [ FIM DO PROGRAMA ] ###############################################################


fechar:
	li $v0, 10
	syscall # Encerra o programa
