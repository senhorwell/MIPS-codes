
######################################################### [ VARIÁVEIS GLOBAIS ] ##############################################################
.data

# Prompts
promptInt: .asciiz "Insira o valor de ["
n: .asciiz "Valor de N: "
a: .asciiz "Valor de A: "
b: .asciiz "Valor de B: "
# Exibição de resultados

resultado: .asciiz "Resultado: "
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
	jal leitura # Lẽ inteiros da matriz
	jal fechar


########################################################### [ AUXILIARES ] ###################################################################


indice:
	# Função que recebe índice i, j, e número de colunas e retorna o endereço na matriz
	
	move $v0, $a0 # Multiplica índice i pelo número de colunas
	sll $v0, $v0, 2 # Multiplica por 4 (tamanho de inteiro)
	add $v0, $v0, $a3 # Adiciona ao endereço base da matriz
	jr $ra # Retorna para o caller
	

############################################################ [ FUNÇÕES ] ##################################################################################################################################################################################################################

leitura:
	# Variáveis temporárias:
		# $t0 = i (linha)
		# $t1 = j (coluna)
		# $t3 = recebe índice($t0, $t1, $s1) e diz onde guardar o inteiro
		# $t9 = guarda retorno para main

	move $t9, $ra

	li $v0, 4
	la $a0, n
	syscall # Imprime prompt para inteiro
	li $v0, 5
	syscall # Lẽ entrada do número de linhas
	move $t0, $v0 # Copia valor da entrada para $t0
	move $s3, $t0 # Copiar para variável salva $s3
	
	li $v0, 4
	la $a0, a
	syscall # Imprime prompt para inteiro
	li $v0, 5
	syscall # Lẽ entrada do número de linhas
	move $t0, $v0 # Copia valor da entrada para $t0
	move $s4, $t0 # Copiar para variável salva $s4
	
	li $v0, 4
	la $a0, b
	syscall # Imprime prompt para inteiro
	li $v0, 5
	syscall # Lẽ entrada do número de linhas
	move $t0, $v0 # Copia valor da entrada para $t0
	move $s5, $t0 # Copiar para variável salva $s4
			
	li $t0, 0
	li $t1, 0
	li $t2, 0
	loop_i:
		addi $t0, $t0, 1 # Incrementa i
		beq $t0, $s3, fim_leitura
		
		li $t1, 0
		li $t2, 0
		div $t1, $t0, $s4
		div $t2, $t0, $s5

		j loop_i # Se $t1 = número de colunas, incrementa i
		nop
	fim_leitura:
	
	li $v0, 4
	la $a0, resultado
	syscall # Imprime prompt para inteiro
	li $v0, 1
	move $a0, $s5
	syscall # Lẽ entrada do número de linhas
	li $v0, 4
	la $a0, nl
	syscall # Imprime prompt para inteiro

	move $ra, $t9
	jr $ra
	
########################################################## [ FIM DO PROGRAMA ] ###############################################################


fechar:
	li $v0, 10
	syscall # Encerra o programa
