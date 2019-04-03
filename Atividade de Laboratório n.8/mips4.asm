######################################################### [ VARI�?VEIS GLOBAIS ] ##############################################################
.data

msgInicial: .asciiz "| ATIVIDADE LAB 8 - EXE 4 |\n"

# Prompts
promptN: .asciiz "\nInsira o inteiro n (MAX: 8): "
promptInt: .asciiz "\nInsira o valor de ["

# Exibição de resultados
printMatriz: .asciiz "\n\t[MATRIZ]"
printSub: .asciiz "\nSuperior - Inferior: "
printMaior: .asciiz "\nMaior elemento superior a diagonal: "
printMenor: .asciiz "\nMaior elemento menor a diagonal: "

# Caracteres e organização
bop: .asciiz "]["
bcl: .asciiz "]"
dp: .asciiz ":"
nl: .asciiz "\n"
tab: .asciiz "\t\t"
sp: .asciiz " "


########################################################### [ MAIN ] #########################################################################

				
.globl main
.text

main:   
	# Inicialização
	li $v0, 4
	la $a0, msgInicial
	syscall # Imprime mensagem inicial
	
	la $a0, promptN
	syscall # Requisita entrada de n
	li $v0, 5
	syscall # Recebe inteiro
	move $s2, $v0 # Salva em $s2
	move $a0, $v0 # Passa como argumento de nova_matriz
	jal nova_matriz
	jal leitura
	#Fim inicialização
	
	# Impressao da matriz
	li $v0, 4
	la $a0, printMatriz
	syscall
	jal print_matriz
	#Fim Impressao
	
	# Manipulacao com criptografia
	li $v0, 4
	la $a0, printSub
	syscall
	li $v0, 1
	la $a0, ($t7)
	syscall
	li $v0, 4
	la $a0, printMaior
	syscall
	li $v0, 1
	la $a0, ($t5)
	syscall
	li $v0, 4
	la $a0, printMenor
	syscall
	li $v0, 1
	la $a0, ($t6)
	syscall
	li $v0, 4
	la $a0, printMatriz
	syscall
	jal print_matriz
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
		beq $t0, $s2, fim_print # Se t0 = número de linhas, fim da impressão
		li $v0, 4
		la $a0, tab
		syscall
		print_int:
			beq $t1, $s2, fim_printint # Se t1 = número de colunas, reseta as colunas e incrementa i
			
			# Define argumentos de índice
			move $a0, $t0 # i
			move $a1, $t1 # j
			move $a2, $s2 # número de colunas
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
		
	move $t0, $a0
		
	alocacao:
		li $s0, 0 # Limpa $s0
		mul $s0, $t0, $t0 # Multiplica linhas por colunas e guarda em $s0
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
		beq $t0, $s2, fim_leitura
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
				move $a2, $s2 # Número de colunas
				move $a3, $s1 # Endereço base da matriz
			
				jal indice
				
				move $t3, $v0 # Recebe endereço da posição M[i][j]
			
				li $v0, 5	
				syscall # Lê inteiro
				sw $v0, ($t3)
			
				addi $t1, $t1, 1 # Incrementa j
				beq $t1, $s2, loop_i # Se $t1 = número de colunas, incrementa i
				nop
				j loop_j

	fim_leitura:
		move $ra, $t8
		jr $ra
		

##############################################################################################################################################
percorreMatrizes:
	# Variáveis temporárias:
		# $t0 = i
		# $t1 = j
		# $t2 = recebe elemento M[i][j]
	
	li $t0, 0
	li $t1, 0
	li $s4, 0
	li $s5, 0
	li $t6, 0xffffffff
	move $t8, $ra

	percorre_ext:
		beq $t0, $s2, fim_percorre # Se t0 = número de linhas, fim da impressão
		percorre_int:
			beq $t1, $s2, fim_percorreint # Se t1 = número de colunas, reseta as colunas e incrementa i
			
			# Salva o valor m1[i][j] em $t5
			# $t3 superior ao diagonal
			# $t4 inferior ao diagonal
			# $t5 maior acima diagonal
			# $t6 menor abaixo diagonal
			# $t7 resultado subtracao
			move $a0, $t0 # i
			move $a1, $t1 # j
			move $a2, $s2 # número de colunas
			move $a3, $s1 # endereço base
			jal indice
			move $t2, $v0
			lw $a0, ($t2)
			move $t2,$a0
			
			beq $a0,$a1, fimCompara
			blt $a0,$a1, superior
				add $t4,$t4,$t2
				blt $t2,$t6, menor
				j fimCompara
				menor:
					move $t6,$t2
					j fimCompara
			superior:
				add $t3,$t3,$t2
				blt $t5,$t2, maior
				j fimCompara
				maior:
					move $t5,$t2
					j fimCompara
			fimCompara:
			addi $t1, $t1, 1
			j percorre_int
			
		fim_percorreint:
			li $t1, 0
			addi $t0, $t0, 1 # Incrementa i
			j percorre_ext


fim_percorre:
	beq $t3,$t4, quatro
		sub $t7,$t3,$t4
		j fimSub
	quatro:
		sub $t7,$t4,$t3
		
	fimSub:
	move $ra, $t8
	jr $ra # Retorna para main
	
	
########################################################## [ FIM DO PROGRAMA ] ###############################################################


fechar:
	li $v0, 10
	syscall # Encerra o programa
