
######################################################### [ VARIÁVEIS GLOBAIS ] ##############################################################
.data

# Prompts
L: .asciiz "Valor de L: "
raiztres: .asciiz "Insira o valor de raiz de tres: "
dois: .asciiz "Insira o valor 2: "
tres: .asciiz "Insira o valor 3: "
# Exibição de resultados

area: .asciiz "\n\n[AREA]\n"
perimetro: .asciiz "\n\n[PERÍMETRO]\n"

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
	jal leitura
	jal calcula_hexagono
	jal escreva
	jal fechar


############################################################ [ FUNÇÕES ] #####################################################################

leitura:
	li $v0, 4
	la $a0, L
	syscall
	li $v0, 7
	syscall
	
	mov.d $f2, $f0
	mov.d $f4,$f0
	
	li $v0, 4
	la $a0, raiztres
	syscall
	li $v0, 7
	syscall
	mov.d $f8, $f0
	li $v0, 4
	la $a0, dois
	syscall
	li $v0, 7
	syscall
	mov.d $f6, $f0
	li $v0, 4
	la $a0, tres
	syscall
	li $v0, 7
	syscall
	mov.d $f10, $f0
	jr $ra
##############################################################################################################################################

calcula_hexagono:
	
	mul.d $f2, $f2, $f2
	mul.d $f2, $f2, $f10
	mul.d $f2, $f2, $f8
	div.d $f2, $f2, $f6	
	
	mul.d $f4, $f4, $f6
	mul.d $f4, $f4, $f10
##############################################################################################################################################

escreva:
	li $v0, 4
	la $a0, area
	syscall
	li $v0, 3
	mov.d $f12, $f2
	syscall
	
	li $v0, 4
	la $a0, perimetro
	syscall
	li $v0, 3
	mov.d $f12, $f4
	syscall
	jr $ra
########################################################## [ FIM DO PROGRAMA ] ###############################################################


fechar:
	li $v0, 10
	syscall # Encerra o programa
