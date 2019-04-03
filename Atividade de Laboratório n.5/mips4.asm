
######################################################### [ VARIÁVEIS GLOBAIS ] ##############################################################
.data

msgInicial: .asciiz "| ATIVIDADE LAB 5\n"

# Prompts
promptLin: .asciiz "Número de linhas (max. 6): "
promptInt: .asciiz "Insira o valor de ["

# Exibição de resultados

printMatriz: .asciiz "[VETOR]\n"
printPrimos: .asciiz "\n[Número de primos]: "

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
				addi $t3, $t3, 1 # Incrementa contador de primos
				
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
	
########################################################## [ FIM DO PROGRAMA ] ###############################################################


fechar:
	li $v0, 10
	syscall # Encerra o programa
