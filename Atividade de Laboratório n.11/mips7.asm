######################################################### [ VARIÁVEIS GLOBAIS ] ##############################################################
.data
Buffer: .space 20
buffer: .asciiz " "
Arquivo: .asciiz "matriz.txt"
ArquivoSaida: .asciiz "matriz saida.txt"
Erro: .asciiz "Arquivo não encontrado!\n"
msgInicial: .asciiz "| ATIVIDADE LAB 11 - EXE 7\n"

# Prompts
promptM: .asciiz "\nInsira o inteiro M: "
promptN: .asciiz "\nInsira o inteiro N: "
promptInt: .asciiz "\nInsira o valor de ["

# Exibição de resultados
printMatriz: .asciiz "\n\t[MATRIZ]"
sortCrescente: .asciiz "\n\t[ORDENADA CRESCENTE]\n"
printPrimos: .asciiz "\n\t[Soma dos primos]: "

# Caracteres e organização
bop: .asciiz "]["
bcl: .asciiz "]"
dp: .asciiz ":"
nl: .asciiz "\n"
tab: .asciiz "\t\t"
sp: .asciiz " "

########################################################### [ MAIN ] ##########################################################################
			
.globl main
.text

main:
	 
	li $v0, 4
	la $a0, msgInicial
	syscall # Imprime mensagem inicial
	
	
	# Ordem matrizes
	
	la $a0, Arquivo # Nome do arquivo
	li $a1, 0 # Somente leitura
	jal abertura # Retorna file descriptor no sucesso
	move $s7, $v0 # Salva  o file descriptor em $s0  
	
	jal nova_matriz
	
	li $v0, 4
	la $a0, promptM
	syscall # Requisita entrada de m
	li $v0, 1
	move $a0, $s5
	syscall # Recebe inteiro

	li $v0, 4
	la $a0, promptN
	syscall # Requisita entrada de n
	li $v0, 1
	move $a0, $s6
	syscall # Recebe inteiro
	li $v0, 4
	la $a0, nl
	syscall

	# Fim ordem matrizes
	
	# Inicialização
	#jal inicia
	jal print_matriz
	#Fim inicialização
	
	# Impressao das matrizes
	# Fim Impressao
	
	# Manipulacao
		
	# Fim Manipulacao
	
	jal fechar # Encerra o programa
	
########################################################### [ AUXILIARES ] ###################################################################

indice:
	# Função que recebe índice i, j, e número de colunas e retorna o endereço na matriz
	mul $v0, $a2, $a0 # Multiplica índice i pelo número de colunas
	add $v0, $v0, $a1 # Adiciona índice j
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
	li $t1, 0
	move $t8, $ra
	la $a0, nl
	syscall
	print_ext:
		beq $t0, $s5, fim_print # Se t0 = número de linhas, fim da impressão
		li $v0, 4
		la $a0, tab
		syscall
		print_int:
			beq $t1, $s6, fim_printint # Se t1 = número de colunas, reseta as colunas e incrementa i
			
			# Define argumentos de índice
			move $a0, $t0 # i
			move $a1, $t1 # j
			move $a2, $s6 # número de colunas
			move $a3, $s1 # endereço base
			
			jal indice
			move $t2, $v0
			
			li $v0, 1
			lw $a0, ($t2)
			syscall # Imprime elemento
			li $v0, 4
			la $a0, sp
			syscall # Imprime espaço
			
			addi $t1, $t1, 1 # Incrementa j
			j print_int
			
		fim_printint:
			li $v0, 4
			la $a0, nl
			syscall # Imprime newline
			
			li $t1, 0
			addi $t0, $t0, 1 # Incrementa i
			j print_ext


fim_print:
	move $ra, $t8
	jr $ra # Retorna para main

	
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
	la $a1, nl # Endereço da string "\r\n"
	li $a2, 2 # 2 caracteres
	li $v0, 15 # Código de escrita em arquivo
	syscall # Pula linha no arquivo
	j e # goto e
	s: jr $t2 # Retorna para a main	
##############################################################################################################################################

nova_matriz:
	getSize:
		# Argumentos:
			# $a0 = n
	
		# Variáveis salvas:
			# $s0 = Número de bits da matriz
			# $s1 = Endereço base da matriz

		# Variáveis temporárias:
			#$t0 = Número de linhas e colunas da matriz
		
		larq:
		move $a0, $s7 # Parâmetro file descriptor
		la $a1, buffer # Buffer de entrada
		li $a2, 1 # 1 caractere por leitura
		li $v0, 14 # Código de leitura de arquivo
		syscall # Faz a leitura de 1 caractere
		
		lb $t5, ($a1) # Carrega o caractere lido no buffer
		beq $t5, 13, larq # if(carriage return) ignora
		beq $t5,32, l # if(newline) goto l
		subi $t5, $t5, 48 # char para decimal
		mul $t6, $t6, 10 # Casa decimal para a esquerda
		add $t6, $t6, $t5 # Soma a unidade lida
		j larq # Continua a leitura do número
		l: 
		move $s5, $t6
		
		li $t6,0
		larq2:
		move $a0, $s7 # Parâmetro file descriptor
		la $a1, buffer # Buffer de entrada
		li $a2, 1 # 1 caractere por leitura
		li $v0, 14 # Código de leitura de arquivo
		syscall # Faz a leitura de 1 caractere
		
		lb $t5, ($a1) # Carrega o caractere lido no buffer
		beq $t5, 13, larq2 # if(carriage return) ignora
		beq $t5,32, l2 # if(newline) goto l
		subi $t5, $t5, 48 # char para decimal
		mul $t6, $t6, 10 # Casa decimal para a esquerda
		add $t6, $t6, $t5 # Soma a unidade lida
		j larq2 # Continua a leitura do número
		l2: 
		
		move $s6, $t6
		
		li $t6,0
		larq3:
		move $a0, $s7 # Parâmetro file descriptor
		la $a1, buffer # Buffer de entrada
		li $a2, 1 # 1 caractere por leitura
		li $v0, 14 # Código de leitura de arquivo
		syscall # Faz a leitura de 1 caractere
		
		lb $t5, ($a1) # Carrega o caractere lido no buffer
		beq $t5, 13, larq3 # if(carriage return) ignora
		beq $t5,32, l3 # if(newline) goto l
		subi $t5, $t5, 48 # char para decimal
		mul $t6, $t6, 10 # Casa decimal para a esquerda
		add $t6, $t6, $t5 # Soma a unidade lida
		j larq3 # Continua a leitura do número
		l3: 
		
		move $s4, $t6
	alocação:
		li $s0, 0 # Limpa $s0
		mul $s0, $s5, $s6 # Multiplica linhas por colunas e guarda em $s0
		mul $s0, $s0, 4 # Multiplica (linhasxcolunas) * 4, que é o número de bits por inteiro
		
		li $v0, 9
		la $a0, ($s0)
		syscall # Aloca $s0 bits na memória heap para a matriz
		move $s1, $v0 # Passa endereço da memória alocada para $s1
		
		
	fim_matriz:
		jr $ra # Retorna para caller
		
##############################################################################################################################################
leitura:
	# Variáveis temporárias:
		# $t0 = i (linha)
		# $t1 = j (coluna)
		# $t3 = recebe índice($t0, $t1, $s1) e diz onde guardar o inteiro
		# $t9 = guarda retorno para main
	
	move $t8, $ra
	li $t0, -1
	loop_i:
		li $t1, 0
		addi $t0, $t0, 1 # Incrementa i
		beq $t0, $s5, fim_leitura
		loop_j:
			prompt_indice:
				li $v0, 4
				la $a0, promptInt
				syscall # Imprime prompt para inteiro
				li $v0, 1
				la $a0, ($t0)
				syscall # Imprime i
				li $v0, 4
				la $a0, bop
				syscall # Fecha primeiro parenteses
				li $v0, 1
				la $a0, ($t1)
				syscall # Imprime j
				li $v0, 4
				la $a0, bcl
				syscall # Fecha segundo parenteses
				la $a0, dp
				syscall # Imprime dois pontos
			
				# Argumentos para índice
				move $a0, $t0 # i
				move $a1, $t1 # j
				move $a2, $s6 # Número de colunas
				move $a3, $s1 # Endereço base da matriz
			
				jal indice
				
				move $t3, $v0 # Recebe endereço da posição M[i][j]
			
				li $v0, 5
				syscall # Lê inteiro
				sw $v0, ($t3)
			
				addi $t1, $t1, 1 # Incrementa j
				beq $t1, $s6, loop_i # Se $t1 = número de colunas, incrementa i
				nop
				j loop_j

	fim_leitura:
		move $ra, $t8
		jr $ra	
	
#################################################################################################################################################

corre:
	move $t8, $ra
	li $t0, -1
	for_i:
		li $t1, 0
		addi $t0, $t0, 1 # Incrementa i
		beq $t0, $s4, fim_corre

		# Argumentos para índice
		move $a0, $t0 # i
		move $a1, $t1 # j			
		move $a2, $s6 # Número de colunas
		move $a3, $s1 # Endereço base da matriz
	
		jal indice		
		move $t3, $v0 # Recebe endereço da posição M[i][j]
		li $v0, 0
		sw $v0, ($t3)		
				
		j for_i
	fim_corre:
		move $ra, $t8
		jr $ra	
		
#################################################################################################################################################

inicia:
	move $t8, $ra
	li $t0, -1
	for_inicia:
		li $t1, 0
		addi $t0, $t0, 1 # Incrementa i
		beq $t0, $s4, fim_inicia

		# Argumentos para índice
		move $a0, $t0 # i
		move $a1, $t1 # j			
		move $a2, $s6 # Número de colunas
		move $a3, $s1 # Endereço base da matriz
	
		jal indice		
		move $t3, $v0 # Recebe endereço da posição M[i][j]
		li $v0, 1
		sw $v0, ($t3)		
				
		j for_inicia
	fim_inicia:
		move $ra, $t8
		jr $ra	
	
#################################################################################################################################################

fechar:
	li $v0, 10
	syscall # Encerra o programa
