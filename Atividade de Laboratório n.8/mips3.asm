######################################################### [ VARI�?VEIS GLOBAIS ] ##############################################################
.data

msgInicial: .asciiz "| ATIVIDADE LAB 8 - EXE 2\n"

# Prompts
promptM: .asciiz "\nInsira o inteiro M: "
promptN: .asciiz "\nInsira o inteiro N: "
promptP: .asciiz "\nInsira o inteiro P: "
promptInt: .asciiz "\nInsira o valor de ["

# Exibição de resultados
printMatriz: .asciiz "\n\t[MATRIZ 1]"
printMatriz2: .asciiz "\n\t[MATRIZ 2]"
printMatriz3: .asciiz "\n\t[MATRIZ RESULTANTE]"

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
	syscall # Requisita entrada de n
	li $v0, 5
	syscall # Recebe inteiro
	move $s5, $v0 # Salva em $s5
	
	li $v0, 4
	la $a0, promptN
	syscall # Requisita entrada de n
	li $v0, 5
	syscall # Recebe inteiro
	move $s6, $v0 # Salva em $s6
	
	li $v0, 4
	la $a0, promptP
	syscall # Requisita entrada de n
	li $v0, 5
	syscall # Recebe inteiro
	move $s7, $v0 # Salva em $s7
	# Fim ordem matrizes
	
	# Inicialização
	jal nova_matriz
	li $v0, 4
	la $a0, printMatriz
	syscall
	jal leitura
	jal nova_matriz2
	li $v0, 4
	la $a0, printMatriz2
	syscall
	jal leitura2
	#Fim inicialização
	
	# Impressao das matrizes
	li $v0, 4
	la $a0, printMatriz
	syscall
	jal print_matriz
	li $v0, 4
	la $a0, printMatriz2
	syscall
	jal print_matriz2
	# Fim Impressao
	
	# Manipulacao
		#$s4 = soma dos valores iguais
		#$s5 = soma das posições
	jal percorreMatrizes
	li $v0, 4
	la $a0, printMatriz3
	syscall
	jal print_matriz3
	# Fim Manipulacao
	
	# Resultados
	
	# Fim resultados
	
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

print_matriz2:
	# Variáveis temporárias:
		# $t0 = i
		# $t1 = j
		# $t2 = recebe elemento M[i][j]
	
	li $t0, 0
	li $t1, 0
	move $t8, $ra
	la $a0, nl
	syscall
	print_ext2:
		beq $t0, $s6, fim_print2 # Se t0 = número de linhas, fim da impressão
		li $v0, 4
		la $a0, tab
		syscall
		print_int2:
			beq $t1, $s7, fim_printint2 # Se t1 = número de colunas, reseta as colunas e incrementa i
			
			# Define argumentos de índice
			move $a0, $t0 # i
			move $a1, $t1 # j
			move $a2, $s7 # número de colunas
			move $a3, $s2 # endereço base
			
			jal indice
			move $t2, $v0
			
			li $v0, 1
			lw $a0, ($t2)
			syscall # Imprime elemento
			li $v0, 4
			la $a0, sp
			syscall # Imprime espaço
			
			addi $t1, $t1, 1 # Incrementa j
			j print_int2
			
		fim_printint2:
			li $v0, 4
			la $a0, nl
			syscall # Imprime newline
			
			li $t1, 0
			addi $t0, $t0, 1 # Incrementa i
			j print_ext2


fim_print2:
	move $ra, $t8
	jr $ra # Retorna para main
	
##############################################################################################################################################

print_matriz3:
	# Variáveis temporárias:
		# $t0 = i
		# $t1 = j
		# $t2 = recebe elemento M[i][j]
	
	li $t0, 0
	li $t1, 0
	move $t8, $ra
	la $a0, nl
	syscall
	print_ext3:
		beq $t0, $s6, fim_print3 # Se t0 = número de linhas, fim da impressão
		li $v0, 4
		la $a0, tab
		syscall
		print_int3:
			beq $t1, $s6, fim_printint3 # Se t1 = número de colunas, reseta as colunas e incrementa i
			
			# Define argumentos de índice
			move $a0, $t0 # i
			move $a1, $t1 # j
			move $a2, $s6 # número de colunas
			move $a3, $s3 # endereço base
			
			jal indice
			move $t2, $v0
			
			li $v0, 1
			lw $a0, ($t2)
			syscall # Imprime elemento
			li $v0, 4
			la $a0, sp
			syscall # Imprime espaço
			
			addi $t1, $t1, 1 # Incrementa j
			j print_int3
			
		fim_printint3:
			li $v0, 4
			la $a0, nl
			syscall # Imprime newline
			
			li $t1, 0
			addi $t0, $t0, 1 # Incrementa i
			j print_ext3
fim_print3:
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
		
	move $t0, $s5
	move $t1, $s6
		
	alocacao:
		li $s0, 0 # Limpa $s0
		mul $s0, $t0, $t0 # Multiplica linhas por colunas e guarda em $s0
		mul $s0, $t1, $t1 # Multiplica linhas por colunas e guarda em $s0
		mul $s0, $s0, 4 # Multiplica (linhasxcolunas) * 4, que é o número de bits por inteiro
		
		li $v0, 9
		la $a0, ($s0)
		syscall # Aloca $s0 bits na memória heap para a matriz
		move $s1, $v0 # Passa endereço da memória alocada para $s1
		
	fim_matriz:
		jr $ra # Retorna para caller
		
##############################################################################################################################################

nova_matriz2:
	getSize2:
		# Argumentos:
			# $a0 = n
	
		# Variáveis salvas:
			# $s0 = Número de bits da matriz
			# $s1 = Endereço base da matriz

		# Variáveis temporárias:
			#$t0 = Número de linhas e colunas da matriz
		
	move $t0, $s6
	move $t1, $s7
		
	alocacao2:
		li $s0, 0 # Limpa $s0
		mul $s0, $t0, $t0 # Multiplica linhas por colunas e guarda em $s0
		mul $s0, $t1, $t1 # Multiplica linhas por colunas e guarda em $s0
		mul $s0, $s0, 4 # Multiplica (linhasxcolunas) * 4, que é o número de bits por inteiro
		
		li $v0, 9
		la $a0, ($s0)
		syscall # Aloca $s0 bits na memória heap para a matriz
		move $s2, $v0 # Passa endereço da memória alocada para $s1
		
	fim_matriz2:
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

leitura2:
	# Variáveis temporárias:
		# $t0 = i (linha)
		# $t1 = j (coluna)
		# $t3 = recebe índice($t0, $t1, $s1) e diz onde guardar o inteiro
		# $t9 = guarda retorno para main
	
	move $t8, $ra
	li $t0, -1
	loop_i2:
		li $t1, 0
		addi $t0, $t0, 1 # Incrementa i
		beq $t0, $s6, fim_leitura2
		loop_j2:
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
				move $a2, $s7 # Número de colunas
				move $a3, $s2 # Endereço base da matriz
			
				jal indice
				
				move $t3, $v0 # Recebe endereço da posição M[i][j]
			
				li $v0, 5
				syscall # Lê inteiro
				sw $v0, ($t3)
			
				addi $t1, $t1, 1 # Incrementa j
				beq $t1, $s7, loop_i2 # Se $t1 = número de colunas, incrementa i
				nop
				j loop_j2

	fim_leitura2:
		move $ra, $t8
		jr $ra
		
######################################################################################################################################

percorreMatrizes:
	# Variáveis temporárias:
		# $t0 = i
		# $t1 = j
		# $t2 = recebe elemento M[i][j]

	# Aloca matriz resultante
	li $s0, 0 # Limpa $s0
	mul $s0, $s6, $s6 # Multiplica linhas por colunas e guarda em $s0
	mul $s0, $s0, 4 # Multiplica (linhasxcolunas) * 4, que é o número de bits por inteiro	
	li $v0, 9
	la $a0, ($s0)
	syscall # Aloca $s0 bits na memória heap para a matriz
	move $s3, $v0 # Passa endereço da memória alocada para $s1
	# Fim da alocacao
	
	# Inicializando variaveis
	li $t0, 0
	li $t1, 0
	li $t2, 0
	li $s4, 0
	li $s5, 0
	move $t8, $ra
	# Fim inicializacao
	percorre_ext:	# for (i=0;i<m;i++)
		beq $t0, $s5, fim_percorre # Se t0 = número de linhas, fim da impressão
		percorre_int: # for (j=0;j<p;j++)
			beq $t1, $s7, fim_percorreint # Se t1 = número de colunas, reseta as colunas e incrementa i
			li $t5, 0
			percorre_intK:	# for (k=0;k<n;k++)
				beq $t2, $s6, fim_percorreintK # Se t1 = número de colunas, reseta as colunas e incrementa i
				
				# Salva o valor m1[i][j] em $t5
				move $a0, $t0 # i
				move $a1, $t2 # j
				move $a2, $s6 # número de colunas
				move $a3, $s1 # endereço base
				jal indice
				move $t3, $v0
				lw $a0, ($t3)
				move $t3,$a0
				
				# Salva o valor m2[i][j] em $t7
				move $a0, $t2 # i
				move $a1, $t1 # j
				move $a2, $s7 # número de colunas
				move $a3, $s2 # endereço base
				jal indice
				move $t4, $v0
				lw $a0, ($t4)
				move $t4,$a0
				
				mul $t3,$t3,$t4
				add $t5,$t5,$t3
				
				addi $t2, $t2, 1
			
				j percorre_intK
			fim_percorreintK:

			move $a0, $t1 # i
			move $a1, $t2 # j
			move $a2, $s6 # Número de colunas
			move $a3, $s3 # Endereço base da matriz
			
			jal indice
			
			move $t6, $v0 # Recebe endereço da posição M[i][j]
			move $a0,$t5
			sw $a0, ($t5)
			addi $t1, $t1, 1
			j percorre_int
		fim_percorreint:
			li $t1, 0
			
			addi $t0, $t0, 1 # Incrementa i
			j percorre_ext
fim_percorre:
	move $ra, $t8
	jr $ra # Retorna para main
	
#################################################################################################################################################

fechar:
	li $v0, 10
	syscall # Encerra o programa