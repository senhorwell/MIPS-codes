######################################################### [ VARIÃ?VEIS GLOBAIS ] ##############################################################
.data

msgInicial: .asciiz "| ATIVIDADE LAB 8 - EXE 2\n"

# Prompts
promptM: .asciiz "\nInsira o inteiro M: "
promptN: .asciiz "\nInsira o inteiro N: "
promptInt: .asciiz "\nInsira o valor de ["

# ExibiÃ§Ã£o de resultados
sim: .asciiz "Sim\n"
nao: .asciiz "Nao\n"

# Caracteres e organizaÃ§Ã£o
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
	# Fim ordem matrizes
	
	# InicializaÃ§Ã£o
	jal nova_matriz
	jal leitura
	#Fim inicializaÃ§Ã£o
	
	# Manipulacao
	jal percorreMatrizes
	bgtz $s5, simm
	li $v0, 4
	la $a0, nao
	syscall
	jal fechar
	simm:
	li $v0, 4
	la $a0, sim
	syscall
	jal fechar # Encerra o programa
	
########################################################### [ AUXILIARES ] ###################################################################

indice:
	# FunÃ§Ã£o que recebe Ã­ndice i, j, e nÃºmero de colunas e retorna o endereÃ§o na matriz
	mul $v0, $a2, $a0 # Multiplica Ã­ndice i pelo nÃºmero de colunas
	add $v0, $v0, $a1 # Adiciona Ã­ndice j
	sll $v0, $v0, 2 # Multiplica por 4 (tamanho de inteiro)
	add $v0, $v0, $a3 # Adiciona ao endereÃ§o base da matriz
	jr $ra # Retorna para o caller
	
	
############################################################ [ FUNÃ‡Ã•ES ] ##############################################################################
nova_matriz:
	getSize:
		# Argumentos:
			# $a0 = n
	
		# VariÃ¡veis salvas:
			# $s0 = NÃºmero de bits da matriz
			# $s1 = EndereÃ§o base da matriz

		# VariÃ¡veis temporÃ¡rias:
			#$t0 = NÃºmero de linhas e colunas da matriz
		
	move $t0, $s5
	move $t1, $s6
		
	alocacao:
		li $s0, 0 # Limpa $s0
		mul $s0, $t0, $t0 # Multiplica linhas por colunas e guarda em $s0
		mul $s0, $t1, $t1 # Multiplica linhas por colunas e guarda em $s0
		mul $s0, $s0, 4 # Multiplica (linhasxcolunas) * 4, que Ã© o nÃºmero de bits por inteiro
		
		li $v0, 9
		la $a0, ($s0)
		syscall # Aloca $s0 bits na memÃ³ria heap para a matriz
		move $s1, $v0 # Passa endereÃ§o da memÃ³ria alocada para $s1
		
	fim_matriz:
		jr $ra # Retorna para caller
		
##############################################################################################################################################

leitura:
	# VariÃ¡veis temporÃ¡rias:
		# $t0 = i (linha)
		# $t1 = j (coluna)
		# $t3 = recebe Ã­ndice($t0, $t1, $s1) e diz onde guardar o inteiro
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
			
				# Argumentos para Ã­ndice
				move $a0, $t0 # i
				move $a1, $t1 # j
				move $a2, $s6 # NÃºmero de colunas
				move $a3, $s1 # EndereÃ§o base da matriz
			
				jal indice
				
				move $t3, $v0 # Recebe endereÃ§o da posiÃ§Ã£o M[i][j]
			
				li $v0, 5
				syscall # LÃª inteiro
				sw $v0, ($t3)
			
				addi $t1, $t1, 1 # Incrementa j
				beq $t1, $s6, loop_i # Se $t1 = nÃºmero de colunas, incrementa i
				nop
				j loop_j

	fim_leitura:
		move $ra, $t8
		jr $ra
		

######################################################################################################################################

percorreMatrizes:
	# VariÃ¡veis temporÃ¡rias:
		# $t0 = i
		# $t1 = j
		# $t2 = recebe elemento M[i][j]

	# Aloca matriz resultante
	li $s0, 0 # Limpa $s0
	mul $s0, $s6, $s6 # Multiplica linhas por colunas e guarda em $s0
	mul $s0, $s0, 4 # Multiplica (linhasxcolunas) * 4, que Ã© o nÃºmero de bits por inteiro	
	li $v0, 9
	la $a0, ($s0)
	syscall # Aloca $s0 bits na memÃ³ria heap para a matriz
	move $s3, $v0 # Passa endereÃ§o da memÃ³ria alocada para $s1
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
		beq $t0, $s5, fim_percorre # Se t0 = nÃºmero de linhas, fim da impressÃ£o
		# Salva o valor m1[i][j] em $t3
		move $a0, $t0 # i
		move $a1, $t2 # j
		move $a2, $s6 # nÃºmero de colunas
		move $a3, $s1 # endereÃ§o base
		jal indice
		move $t3, $v0
		lw $a0, ($t3)
		move $t3,$a0
		percorre_int: # for (j=0;j<p;j++)
			beq $t1, $s7, fim_percorreint # Se t1 = nÃºmero de colunas, reseta as colunas e incrementa i
			li $t5, 0
			percorre_intK:	# for (k=0;k<n;k++)
				beq $t2, $s6, fim_percorreintK # Se t1 = nÃºmero de colunas, reseta as colunas e incrementa i
				
				# Salva o valor m1[i][j] em $t3
				move $a0, $t0 # i
				move $a1, $t2 # j
				move $a2, $s6 # nÃºmero de colunas
				move $a3, $s1 # endereÃ§o base
				jal indice
				move $t3, $v0
				lw $a0, ($t3)
				move $t4,$a0
			
				addi $s5, $s5, 1
				
				addi $t2, $t2, 1
			
				j percorre_intK
			fim_percorreintK:

			move $a0, $t1 # i
			move $a1, $t2 # j
			move $a2, $s6 # NÃºmero de colunas
			move $a3, $s3 # EndereÃ§o base da matriz
			
			jal indice
			
			move $t6, $v0 # Recebe endereÃ§o da posiÃ§Ã£o M[i][j]
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