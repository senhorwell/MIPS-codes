
######################################################### [ VARIÁVEIS GLOBAIS ] ##############################################################
.data

msgInicial: .asciiz "| ATIVIDADE LAB 9 - EXE 2|\n"

# Prompts
promptLin: .asciiz "Número de linhas de X: "
promptInt: .asciiz "Insira o valor de ["
promptLin2: .asciiz "Número de linhas de Y: "

# Exibição de resultados
printMatriz: .asciiz "[VETOR]\n"
printResult: .asciiz "Resultado do produto escalar: "

# Caracteres e organização
bop: .asciiz "]"
bcl: .asciiz "]"
dp: .asciiz ":"
nl: .asciiz "\n"
tab: .asciiz "\t"
sp: .asciiz " "


########################################################### [ MAIN ] #########################################################################

				
.globl main
.text

main:   li $v0, 4
	la $a0, msgInicial
	syscall # Imprime mensagem inicial
	jal nova_matriz # Aloca espaço para nova matriz
	jal leitura # Lẽ inteiros da matriz
	jal print_matriz # Imprime matriz
	jal nova_matriz2 # Aloca espaço para nova matriz
	jal leitura2 # Lẽ inteiros da matriz
	jal print_matriz2 # Imprime matriz
	jal percorre
	li $v0, 4
	la $a0, printResult
	syscall # Imprime mensagem inicial
	li $v0, 1
	la $a0, ($t7)
	syscall # Imprime mensagem inicial
	
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
		
		# Define argumentos de índice
		move $a0, $t0 # i

		move $a3, $s1 # endereço base
		jal indice
		move $t2, $v0
		
		li $v0, 1
		lw $a0, ($t2)
		syscall # Imprime elemento
		li $v0, 4
		la $a0, sp
		syscall # Imprime espaço
		
		addi $t0, $t0, 1 # Incrementa i
		j print_ext
fim_print:
li $v0, 4
la $a0, nl
syscall # Imprime mensagem inicial
	move $ra, $t8
	jr $ra # Retorna para main

##############################################################################################################################################

print_matriz2:
	# Variáveis temporárias:
		# $t0 = i
		# $t1 = j
		# $t2 = recebe elemento M[i][j]
	
	li $t0, 0
	move $t8, $ra
	
	print_ext2:
		beq $t0, $s3, fim_print2 # Se t0 = número de linhas, fim da impressão
		
		# Define argumentos de índice
		move $a0, $t0 # i

		move $a3, $s7 # endereço base
		jal indice
		move $t2, $v0
		
		li $v0, 1
		lw $a0, ($t2)
		syscall # Imprime elemento
		li $v0, 4
		la $a0, sp
		syscall # Imprime espaço
		
		addi $t0, $t0, 1 # Incrementa i
		j print_ext2
fim_print2:
	li $v0, 4
	la $a0, nl
	syscall # Imprime mensagem inicial
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
		
		la $a0, promptLin
		syscall # Imprime mensagem pedindo número de linhas
		li $v0, 5
		syscall # Lẽ entrada do número de linhas
		move $t0, $v0 # Copia valor da entrada para $t0
		move $s3, $t0 # Copiar para variável salva $s3
		
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

nova_matriz2:
	getSize2:
		# Variáveis salvas:
			# $s0 = Número de bits da matriz
			# $s1 = Endereço base da matriz
			# $s2 = Número de colunas da matriz
			# $s3 = Número de linhas da matriz

		# Variáveis temporárias:
			#$t0 = Número de linhas da matriz
			#$t1 = Número de colunas da matriz
		
		la $a0, promptLin2
		syscall # Imprime mensagem pedindo número de linhas
		li $v0, 5
		syscall # Lẽ entrada do número de linhas
		move $t0, $v0 # Copia valor da entrada para $t0
		move $s3, $t0 # Copiar para variável salva $s3
		
	alocação2:
		li $s0, 0 # Limpa $s0
		move $s0, $t0 # Multiplica linhas por colunas e guarda em $s0
		mul $s0, $s0, 4 # Multiplica (linhasxcolunas) * 4, que é o número de bits por inteiro
		
		li $v0, 9
		la $a0, ($s0)
		syscall # Aloca $s0 bits na memória heap para a matriz
		move $s7, $v0 # Passa endereço da memória alocada para $s1
		
	fim_matriz2:
		jr $ra # Retorna para matriz
		
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
			la $a0, dp
			syscall # Imprime dois pontos
		
			# Argumentos para índice
			move $a0, $t0 # i
			move $a3, $s1 # Endereço base da matriz
		
			jal indice
			
			move $t3, $v0 # Recebe endereço da posição M[i][j]
		
			li $v0, 5
			syscall # Lê inteiro
			sw $v0, ($t3)
		
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
		
##############################################################################################################################################

percorre:
	# Variáveis temporárias:
		# $t0 = i (linha)
		# $t1 = j (coluna)
		# $t3 = recebe índice($t0, $t1, $s1) e diz onde guardar o inteiro
		# $t9 = guarda retorno para main
	
	move $t9, $ra
	li $t0, -1
	percorre_i:
		addi $t0, $t0, 1 # Incrementa i
		beq $t0, $s3, fim_percorre
		
		# Argumentos para índice
		move $a0, $t0 # i
		move $a3, $s1 # Endereço base da matriz
		jal indice
		move $t3, $v0 # Recebe endereço da posição M[i][j]
		lw $a0, ($t3)
		move $t5, $a0
		
		# Argumentos para índice
		move $a0, $t0 # i
		move $a3, $s7 # Endereço base da matriz
		jal indice
		move $t3, $v0 # Recebe endereço da posição M[i][j]
		lw $a0, ($t3)
		move $t6, $a0
		
		# T5 é x e T6 é y, multiplico e salvo em T7
		mul $t5, $t5, $t6
		add $t7, $t7, $t5
		
		j percorre_i # Se $t1 = número de colunas, incrementa i
		nop
	
	fim_percorre:
		li $v0, 4
		la $a0, printMatriz
		syscall
		la $a0, nl
		syscall
		move $ra, $t9
		jr $ra
		
##############################################################################################################################################


leitura2:
	# Variáveis temporárias:
		# $t0 = i (linha)
		# $t1 = j (coluna)
		# $t3 = recebe índice($t0, $t1, $s1) e diz onde guardar o inteiro
		# $t9 = guarda retorno para main
	
	move $t9, $ra
	li $t0, -1
	loop_i2:
		li $t1, 0
		addi $t0, $t0, 1 # Incrementa i
		beq $t0, $s3, fim_leitura2
			
		prompt_indice2:
			li $v0, 4
			la $a0, promptInt
			syscall # Imprime prompt para inteiro
			li $v0, 1
			la $a0, ($t0)
			syscall # Imprime i
			li $v0, 4
			la $a0, bop
			syscall # Fecha primeiro parenteses
			la $a0, dp
			syscall # Imprime dois pontos
		
			# Argumentos para índice
			move $a0, $t0 # i
			move $a3, $s7 # Endereço base da matriz
		
			jal indice
			
			move $t3, $v0 # Recebe endereço da posição M[i][j]
		
			li $v0, 5
			syscall # Lê inteiro
			sw $v0, ($t3)
		
			j loop_i2 # Se $t1 = número de colunas, incrementa i
			nop
	fim_leitura2:
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
