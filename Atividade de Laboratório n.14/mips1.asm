
######################################################### [ VARIÁVEIS GLOBAIS ] ##############################################################
.data

# Prompts
promptLin: .asciiz "Número de elementos: "
promptInt: .asciiz "Insira o valor de ["

# Exibição de resultados

printVetor: .asciiz "\n\n[VETOR]\n"
printVetor2: .asciiz "\n\n[VETOR INVERTIDO]\n"

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

main:
	jal novo_vetor # Aloca espaço para nova matriz
	jal leitura # Lẽ inteiros da matriz
	jal print_vetor
	jal novo_vetor2
	jal inverter_vetor
	jal print_vetor2
	jal fechar


########################################################### [ AUXILIARES ] ###################################################################


indice:
	# Função que recebe índice i, j, e número de colunas e retorna o endereço na matriz
	
	move $v0, $a0 # Multiplica índice i pelo número de colunas
	sll $v0, $v0, 2 # Multiplica por 4 (tamanho de inteiro)
	add $v0, $v0, $a3 # Adiciona ao endereço base da matriz
	jr $ra # Retorna para o caller
	

############################################################ [ FUNÇÕES ] #####################################################################
	
	
print_vetor:
	# Variáveis temporárias:
		# $t0 = i
		# $t1 = j
		# $t2 = recebe elemento M[i][j]
	
	li $t0, 0
	move $t8, $ra
	li $v0, 4
	la $a0, printVetor
	syscall
	
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
	syscall
	move $ra, $t8
	jr $ra # Retorna para main

##############################################################################################################################################

print_vetor2:
	# Variáveis temporárias:
		# $t0 = i
		# $t1 = j
		# $t2 = recebe elemento M[i][j]
	
	li $t0, 0
	move $t8, $ra
	li $v0, 4
	la $a0, printVetor2
	syscall
	
	print_ext2:
		beq $t0, $s3, fim_print2 # Se t0 = número de linhas, fim da impressão
		
		# Define argumentos de índice
		move $a0, $t0 # i
		move $a3, $s2 # endereço base
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
	move $ra, $t8
	jr $ra # Retorna para main

##############################################################################################################################################

	
inverter_vetor:
	# Variáveis temporárias:
		# $t0 = i
		# $t1 = j
		# $t2 = recebe elemento M[i][j]
	
	li $t0, 0
	move $t8, $ra
	move $t1, $s3
	subi $t1, $t1, 1
	inverter_ext:
		beq $t0, $s3, fim_inverter # Se t0 = número de linhas, fim da impressão
		
		# Define argumentos de índice
		move $a0, $t1 # i
		move $a3, $s1 # endereço base
		jal indice
		move $t2, $v0
		
		lw $a1, ($t2)
		
		move $a0, $t0 # i
		move $a3, $s2 # endereço base
		jal indice
		move $t3, $v0
		
		sw $a1, ($t3)
		
		addi $t0, $t0, 1 # Incrementa i
		subi $t1, $t1, 1
		j inverter_ext
fim_inverter:
	move $ra, $t8
	jr $ra # Retorna para main
	



##############################################################################################################################################

novo_vetor:
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
		syscall # Imprime prompt para inteiro
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
		
	fim_vetor:
		li $v0, 4
		la $a0, nl
		syscall
		jr $ra # Retorna para matriz
		
##############################################################################################################################################

novo_vetor2:
	getSize2:
		# Variáveis salvas:
			# $s0 = Número de bits da matriz
			# $s1 = Endereço base da matriz
			# $s2 = Número de colunas da matriz
			# $s3 = Número de linhas da matriz

		# Variáveis temporárias:
			#$t0 = Número de linhas da matriz
			#$t1 = Número de colunas da matriz
		move $t0, $s3 # Copia valor da entrada para $t0
		
	alocação2:
		li $s0, 0 # Limpa $s0
		move $s0, $t0 # Multiplica linhas por colunas e guarda em $s0
		mul $s0, $s0, 4 # Multiplica (linhasxcolunas) * 4, que é o número de bits por inteiro
		
		li $v0, 9
		la $a0, ($s0)
		syscall # Aloca $s0 bits na memória heap para a matriz
		move $s2, $v0 # Passa endereço da memória alocada para $s1
		
	fim_vetor2:
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
		move $ra, $t9
		jr $ra
	
########################################################## [ FIM DO PROGRAMA ] ###############################################################


fechar:
	li $v0, 10
	syscall # Encerra o programa
