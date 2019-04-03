
######################################################### [ VARIÁVEIS GLOBAIS ] ##############################################################
.data

msgInicial: .asciiz "| ATIVIDADE LAB 10 - EXE 1|\n"

# Prompts
promptLin: .asciiz "Número de elementos: "
promptInt: .asciiz "Insira o valor de ["

# Exibição de resultados
printMatriz: .asciiz "\n\t[VETOR]\n"
print1: .asciiz " ocorreu "
print2: .asciiz " vezes \n"

# Caracteres e organização
bop: .asciiz "]"
bcl: .asciiz "]"
dp: .asciiz ":"
nl: .asciiz "\n"
tab: .asciiz "\t\t"
sp: .asciiz " "


########################################################### [ MAIN ] #########################################################################

				
.globl main
.text

main:   li $v0, 4
	la $a0, msgInicial
	syscall # Imprime mensagem inicial
	jal nova_matriz # Aloca espaço para nova matriz
	jal leitura # Lẽ inteiros da matriz
	#jal sort_crescente
	jal compara_matriz
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
	
	li $v0, 4
	la $a0, nl
	syscall
	
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
		li $v0, 4
		la $a0, sp
		syscall # Imprime espaço
		
		addi $t0, $t0, 1 # Incrementa i
		j print_ext
fim_print:
	move $ra, $t8
	jr $ra # Retorna para main
	



##############################################################################################################################################

compara_matriz:
	# Variáveis temporárias:
		# $t0 = i
		# $t1 = j
		# $t2 = recebe elemento M[i][j]
	
	li $t0, 0
	move $t8, $ra
	
	li $v0, 4
	la $a0, nl
	syscall
	
	compara_ext:
		beq $t0, $s3, fim_compara # Se t0 = número de linhas, fim da impressão
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
		li $v0, 4
		la $a0, print1
		syscall # Imprime espaço
		li $v0, 1
		lw $a0, ($t3)
		syscall # Imprime elemento
		li $v0, 4
		la $a0, print2
		syscall # Imprime espaço
		
		addi $t0, $t0, 1 # Incrementa i
		j compara_ext
fim_compara:
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

sort_crescente:
	# Variáveis salvas:
		# $s4 = Endereço base da matriz manipulável
		
	# Variáveis temporárias:
		# $t0 = Contador do loop externo
		# $t1 = Contador do loop interno
		# $t3 = Endereço final da matriz
		# $t4 = Recebe n (eixo)
		# $t5 = Recebe n+1 (comparado)
		# $t6 = Percorredor 1 (Endereço inicial da matriz)
		# $t7 = Percorredor 2 (Endereço inicial da matriz+4)
	
	temp_matriz:
		li $v0, 9
		la $a0, ($s0)
		syscall # Aloca $s0 bits na memória heap para a matriz
		move $s4, $v0 # Passa endereço da memória alocada para $s4
		move $t3, $s4 # Passa endereço da memória alocada para $t3
		
		
		add $t3, $t3, $s0
		li $t0, 0
		move $t9, $ra # Guarda retorno para main

	loopc_ext:
		beq $t0, $s0, fim_sort_crescente  # Se contador chegou no número de bytes total da matriz, terminou de ordenar
		move $t6, $s1 # Copia endereço base da matriz para $t6
		addi $t7, $t6, 4 # Copia endereço base da matriz + 4 para $t7
		li $t1, 4 # Inicializa contador interno em 4
		
	
		loopc_int:
			beq $t1, $s0, fimc_int # Se contador interno chegou no número total de bytes da matriz, terminou de percorrê-la
			lw $t4, ($t6)
			lw $t5, ($t7)
			bgt $t4, $t5, c_switch # Se n é maior que n+1, troca
			j fimc_switch
			c_switch:
				sw $t5, ($t6) # Carrega em n o valor de n+1
				sw $t4, ($t7) # Carrega em n+1 o valor de n
			fimc_switch:
				add $t6, $t6, $s5 # Incrementa percorredor 1
				add $t7, $t7, $s5 # Incrementa percorredor 2
				add $t1, $t1, 4 # Incrementa contador interno
				j loopc_int
		fimc_int:
			addi $t0, $t0, 4 # Incrementa contador externo
			j loopc_ext

fim_sort_crescente:
	move $ra, $t9
	jr $ra
		
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
			sw $a0, ($t3)
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
