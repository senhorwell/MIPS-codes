# Faltando:
	# SemiPrimos
	# Perfeitos
	# Remover teste


######################################################### [ VARIÁVEIS GLOBAIS ] ##############################################################
.data

msgInicial: .asciiz "| ATIVIDADE LAB 5\n"

# Prompts
promptLin: .asciiz "Número de linhas (max. 6): "
promptCol: .asciiz "Número de colunas (max. 6): "
promptInt: .asciiz "Insira o valor de ["

# Exibição de resultados
sortCrescente: .asciiz "\n\t[ORDENADA CRESCENTE]\n"
sortDecrescente: .asciiz "\n\t[ORDENADA DECRESCENTE]\n"
printMatriz: .asciiz "\n\t[MATRIZ]\n"
printPares: .asciiz "\n\t[Número de pares]: "
printPrimos: .asciiz "\n\t[Número de primos]: "
printSemiPrimos: .asciiz "\n\t[Número de semiprimos]: "
printPerfeitos: .asciiz "\n\t[Número de perfeitos]: "
printInvertida: .asciiz "\n\n\t[Matriz com linhas e colunas trocadas]:\n"
printDiagonalImpar: .asciiz "\n\t[Número de ímpares abaixo da diagonal]: "
printDiagonalPar: .asciiz "\n\n\t[Número de pares acima da diagonal]: "

# Caracteres e organização
bop: .asciiz "]["
bcl: .asciiz "]"
dp: .asciiz ":"
nl: .asciiz "\n"
tab: .asciiz "\t\t"
sp: .asciiz " "

q: .asciiz "\n Quociente: "
d: .asciiz "\n Divisor: "

########################################################### [ MAIN ] #########################################################################

				
.globl main
.text

main:   li $v0, 4
	la $a0, msgInicial
	syscall # Imprime mensagem inicial
	jal nova_matriz # Aloca espaço para nova matriz
	jal leitura # Lẽ inteiros da matriz
	jal primos # Conta elementos primos da matriz
	jal fechar


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
	
	print_ext:
		beq $t0, $s3, fim_print # Se t0 = número de linhas, fim da impressão
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
		li $v0, 4
		la $a0, promptCol
		syscall # Imprime mensagem pedindo número de colunas
		li $v0, 5
		syscall # Lê entrada do número de colunas
		move $t1, $v0 # Copia valor da entrada para $t1
		move $s2, $t1 # Copia para variável salva $s2
		
	alocação:
		li $s0, 0 # Limpa $s0
		mul $s0, $t0, $t1 # Multiplica linhas por colunas e guarda em $s0
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
		move $ra, $t9
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


sort_decrescente:
	# Variáveis temporárias:
		# $t0 = Contador do loop externo
		# $t1 = Contador do loop interno
		# $t3 = Endereço final da matriz
		# $t4 = Recebe n (eixo)
		# $t5 = Recebe n+1 (comparado)
		# $t6 = Percorredor 1 (Endereço inicial da matriz)
		# $t7 = Percorredor 2 (Endereço inicial da matriz+4)
	
	add $t3, $s0, $s4
	li $t0, 0
	move $t9, $ra # Guarda retorno para main
	
	loopd_ext:
		beq $t0, $s0, fim_sort_decrescente  # Se contador chegou no número de bytes total da matriz, terminou de ordenar
		move $t6, $s1 # Copia endereço base da matriz para $t6
		addi $t7, $t6, 4 # Copia endereço base da matriz + 4 para $t7
		li $t1, 4 # Inicializa contador interno em 4
		
	
		loopd_int:
			beq $t1, $s0, fimd_int # Se contador interno chegou no número total de bytes da matriz, terminou de percorrê-la
			lw $t4, ($t6)
			lw $t5, ($t7)
			blt $t4, $t5, d_switch # Se n é menor que n+1, troca
			j fimd_switch
			d_switch:
				sw $t5, ($t6) # Carrega em n o valor de n+1
				sw $t4, ($t7) # Carrega em n+1 o valor de n
			fimd_switch:
				addi $t6, $t6, 4 # Incrementa percorredor 1
				addi $t7, $t7, 4 # Incrementa percorredor 2
				addi $t1, $t1, 4 # Incrementa contador interno
				j loopd_int
		fimd_int:
			addi $t0, $t0, 4 # Incrementa contador externo
			j loopd_ext

fim_sort_decrescente:
	li $v0, 4
	la $a0, sortDecrescente
	syscall
	move $ra, $t9
	jr $ra
	
	
##############################################################################################################################################

pares:
	# Variáveis temporárias:
		# $t0 = i
		# $t1 = j
		# $t2 = Recebe elemento M[i][j]
		# $t3 = Contador de pares
		# $t4 = Recebe resto da divisão
		
	li $t0, 0
	li $t1, 0
	li $t3, 0
	li $t4, 2
	move $t9, $ra
	
	li $v0, 4
	la $a0, nl
	syscall
	la $a0, tab
	syscall
	
	pares_ext:
		beq $t0, $s3, fim_pares # Se t0 = número de linhas, fim da contagem
		pares_int:
			beq $t1, $s2, fim_paresint # Se t1 = número de colunas, reseta as colunas e incrementa i
			
			# Define argumentos de índice
			move $a0, $t0 # i
			move $a1, $t1 # j
			move $a2, $s2 # número de colunas
			move $a3, $s1 # endereço base
			
			jal indice
			lw $t2, ($v0)
			
			div $t4, $t2, 2
			mfhi $t4
			beq $t4, 0, sim_par
			nop
			j prox_par
			
			sim_par:
				li $v0, 1
				la $a0, ($t2)
				syscall # Imprime elemento
				li $v0, 4
				la $a0, sp
				syscall # Imprime espaço
			
				addi $t3, $t3, 1 # Incrementa contador de pares
			
			prox_par:
				addi $t1, $t1, 1 # Incrementa j
				j pares_int
			
		fim_paresint:
			li $t1, 0 # Zera j
			addi $t0, $t0, 1 # Incrementa i
			j pares_ext


fim_pares:
	li $v0, 4
	la $a0, printPares
	syscall
	li $v0, 1
	la $a0, ($t3)
	syscall
	li $v0, 4
	la $a0, nl
	syscall
	move $ra, $t9
	jr $ra # Retorna para main
	

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
		li $t1, 0 # Reseta j
		
		loopp_coluna:
			beq $t1, $s2, fim_looppcoluna # Se j = número de colunas, termina o loop de colunas
			li $t5, 2 # Reseta divisor
			
			# Define argumentos de índice
			move $a0, $t0 # i
			move $a1, $t1 # j
			move $a2, $s2 # número de colunas
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
				addi $t3, $t3, 1 # Incrementa contador de primos
				
			fim_loopdivisor:
				addi $t1, $t1, 1 # Incrementa j
				j loopp_coluna
		fim_looppcoluna:
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
	


##############################################################################################################################################

semiprimos:
	# Variáveis temporárias:
		# $t0 = i
		# $t1 = j
		# $t2 = Recebe elemento M[i][j]
		# $t3 = Contador de semiprimos
		# $t4 = Divisor
		# $t5 = Divisor de quociente
		# $t6 = Quociente da divisão original
		# $t7 = Quociente da divisão do quociente
		
	move $t9, $ra
	li $t0, 0
	li $t3, 0
	
	li $v0, 4
	la $a0, nl
	syscall
	la $a0, tab
	syscall
	
	loops_ext:
		beq $t0, $s3, fim_semiprimos
		li $t1, 0 # Reseta j 
		
		loops_int:
			beq $t1, $s2, fim_loopsint
			li $t4, 2 # Reseta divisor
			
			# Define argumentos de índice
			move $a0, $t0 # i
			move $a1, $t1 # j
			move $a2, $s2 # número de colunas
			move $a3, $s1 # endereço base
			
			jal indice
			lw $t2, ($v0)
			
			bleu $t2, 2, prox_elemento # Se for igual ou menor a 2, não é semiprimo
			li $t4, 2 # Reseta divisor para mínimo 2
			li $t5, 2 # Reseta divisor para mínimo 2
			
			loops_divisor:
				beq $t4, $t2, prox_elemento # Se chegar em divisor = n, é primo e não semiprimo
				
				div $t6, $t2, $t4 # Guarda resultado da divisão em $t6
				mfhi $t7 # Guarda temporariamente resto em $t7
				beq $t7, 0, loops_divisor2
				
				prox_divisor:
					addi $t4, $t4, 1 # Incrementa divisor
					li $t5, 2 # Reseta divisor de quociente
					j loops_divisor
				
				loops_divisor2:
				

					
					bleu $t6, 2, prox_divisor
					beq $t5, $t6, semiprimo_sim
					
					div $t7, $t6, $t5 # Guarda resultado da divisão do quociente original pelo divisor 2
					mfhi $t7
					beq $t7, 0, prox_divisor # Se quociente não é primo, vai pro próximo divisor
					
					addi $t5, $t5, 1 # Incrementa divisor 2
					j loops_divisor2
					
				semiprimo_sim:
					li $v0, 1
					la $a0, ($t2)
					syscall
					li $v0, 4
					la $a0, sp
					syscall
					
					addi $t3, $t3, 1 # Incrementa contador de semiprimos
					j prox_elemento
			
			prox_elemento:
				addi $t1, $t1, 1 # Incrementa j
				j loops_int
			
		fim_loopsint:
			addi $t0, $t0, 1 # Incrementa i
			j loops_ext

fim_semiprimos:
	li $v0, 4
	la $a0, printSemiPrimos
	syscall
	li $v0, 1
	la $a0, ($t3)
	syscall
	
	move $ra, $t9
	jr $ra # Retorna para main

##############################################################################################################################################

diagonal:
	# Variáveis temporárias:
		# $t0 = i
		# $t1 = j
		# $t2 = Recebe M[i][j]
		# $t3 = Contador pares acima da diagonal principal
		# $t4 = Contador ímpares abaixo da diagonal principal
		# $t5 = Recebe resto da divisão
	
	li $t0, 0
	li $t3, 0
	li $t4, 0
	move $t9, $ra
	
	loop_dext:
		beq $t0, $s3, fim_diagonal # Se i = número de linhas, terminou de contar
		li $t1, 0 # Reseta j
		loop_dint:
			beq $t1, $s2, fim_dint # Se j = número de colunas, reseta e incrementa linha
			
			# Define argumentos de índice
			move $a0, $t0 # i
			move $a1, $t1 # j
			move $a2, $s2 # número de colunas
			move $a3, $s1 # endereço base
			
			jal indice
			lw $t2, ($v0)
			
			blt $t0, $t1, acima_par # Se i < j está acima da diagonal, testa par
			bgt $t0, $t1, abaixo_impar # Se i > j está abaixo da diagonal, testa ímpar
			j prox_d # Se estiver na diagonal principal
			
			acima_par:
				div $t5, $t2, 2
				mfhi $t5
				bnez $t5, prox_d # Se não é par (resto != 0)
				addi $t3, $t3, 1 # Incrementa contador de pares
				j prox_d
				
			abaixo_impar:
				div $t5, $t2, 2
				mfhi $t5
				beq $t5, 0, prox_d # Se não é ímpar (resto = 0)
				addi $t4, $t4, 1 # Incrementa contador de ímpares
			
			prox_d:
				addi $t1, $t1, 1 # Incrementa j
				j loop_dint
			
		fim_dint:
			addi $t0, $t0, 1 # Incrementa i
			j loop_dext
			
fim_diagonal:
	li $v0, 4
	la $a0, printDiagonalPar
	syscall
	li $v0, 1
	la $a0, ($t3)
	syscall
	li $v0, 4
	la $a0, nl
	syscall
	la $a0, printDiagonalImpar
	syscall
	li $v0, 1
	la $a0, ($t4)
	syscall
	
	move $ra, $t9
	jr $ra # Retorna para main



##############################################################################################################################################


linhaxcoluna:
	# Variáveis temporárias:
		# $t0 = i
		# $t1 = j
		# $t2 = recebe elemento M[i][j]
	
	li $t0, 0
	li $t1, 0
	move $t8, $ra
	
	li $v0, 4
	la $a0, printInvertida
	syscall
	
	transpose_ext:
		beq $t0, $s3, fim_linhaxcoluna # Se t0 = número de linhas, fim da impressão
		li $v0, 4
		la $a0, tab
		syscall
		transpose_int:
			beq $t1, $s2, fim_transposeint # Se t1 = número de colunas, reseta as colunas e incrementa i
			
			# Define argumentos de índice
			move $a0, $t1 # i
			move $a1, $t0 # j
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
			j transpose_int
			
		fim_transposeint:
			li $v0, 4
			la $a0, nl
			syscall # Imprime newline
			
			li $t1, 0
			addi $t0, $t0, 1 # Incrementa i
			j transpose_ext

fim_linhaxcoluna:
	move $ra, $t8
	jr $ra # Retorna para main
			
########################################################## [ FIM DO PROGRAMA ] ###############################################################


fechar:
	li $v0, 10
	syscall # Encerra o programa
