######################################################### [ VARIÁVEIS GLOBAIS ] ##############################################################
.data

msgInicial: .asciiz "| ATIVIDADE LAB 9 - EXE 1\n"

# Prompts
promptM: .asciiz "\nInsira o inteiro M: "
promptN: .asciiz "\nInsira o inteiro N: "
promptInt: .asciiz "\nInsira o valor de ["

# Exibição de resultados
printMatriz: .asciiz "\n\t[MATRIZ 1]"
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
	li $v0, 4
	la $a0, promptM
	syscall # Requisita entrada de m
	li $v0, 5
	syscall # Recebe inteiro
	move $s5, $v0 # Salva em $s5
	
	li $v0, 4
	la $a0, promptN
	syscall # Requisita entrada de n
	li $v0, 5
	syscall # Recebe inteiro
	move $s6, $v0 # Salva em $s6

	# Fim ordem matrizes
	
	# Inicialização
	jal nova_matriz
	li $v0, 4
	la $a0, printMatriz
	syscall
	jal leitura
	#Fim inicialização
	
	# Impressao das matrizes
	li $v0, 4
	la $a0, printMatriz
	syscall
	jal print_matriz
	# Fim Impressao
	
	# Manipulacao
	jal sort_crescente # Ordena matriz em ordem crescente
	jal print_matriz
	jal primos # Conta elementos primos da matriz
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

nova_matriz:
	getSize:
		# Argumentos:
			# $a0 = n
	
		# Variáveis salvas:
			# $s0 = Número de bits da matriz
			# $s1 = Endereço base da matriz

		# Variáveis temporárias:
			#$t0 = Número de linhas e colunas da matriz
		
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
				addi $t6, $t6, 4 # Incrementa percorredor 1
				addi $t7, $t7, 4 # Incrementa percorredor 2
				addi $t1, $t1, 4 # Incrementa contador interno
				j loopc_int
		fimc_int:
			addi $t0, $t0, 4 # Incrementa contador externo
			j loopc_ext

fim_sort_crescente:
	li $v0, 4
	la $a0, sortCrescente
	syscall
	la $a0, nl
	syscall
	move $ra, $t9
	jr $ra

##############################################################################################################################################

primos:

	# Variáveis temporárias:
		# $t0 = i
		# $t1 = j
		# $t2 = Recebe elemento M[i][j]
		# $t3 = Contador de primos
		# $t4 = Recebe resto da divisão
		# $t5 = Divisor
	li $t0, 0
	li $t3, 0
	li $t5, 2
	move $t9, $ra
	
	li $v0, 4
	la $a0, nl
	syscall
	la $a0, tab
	syscall
	
	loopp_linha:
		beq $t0, $s3, fim_primos
		
		li $t5, 2 # Reseta divisor
		
		# Define argumentos de índice
		move $a0, $t0 # i
		move $a3, $s1 # endereço base
		
		jal indice
		lw $t2, ($v0)
			
		loop_divisor:
			bleu $t2, 1, fim_loopdivisor # Se for 1 não é primo
			beq $t5, $t2, primo_sim # Se chegou em $t5 = M[i][j], é primo
			
			div $t4, $t2, $t5
			mfhi $t4
			beq $t4, 0, fim_loopdivisor # Não é primo, volta para o loop de coluna		
			addi $t5, $t5, 1 # Incrementa divisor e continua testando
			j loop_divisor	
				
			primo_sim:
				li $v0, 1
				la $a0, ($t2)
				syscall # Imprime número
				li $v0, 4
				la $a0, sp
				syscall # Imprime espaço
				add $t3, $t3, $t2 # Incrementa contador de primos
				
		fim_loopdivisor:
		addi $t0, $t0, 1 # Incrementa i
		j loopp_linha
fim_primos:
	li $v0, 4
	la $a0, printPrimos
	syscall
	li $v0, 1
	la $a0, ($t3)
	syscall
	move $ra, $t9
	jr $ra # Retorna para main	
	
#################################################################################################################################################

fechar:
	li $v0, 10
	syscall # Encerra o programa
