
######################################################### [ VARIÁVEIS GLOBAIS ] ##############################################################
.data

msgInicial: .asciiz "| ATIVIDADE LAB 10 - EXE 2|\n"

# Prompts
promptLin: .asciiz "Insira X: "
promptLin2: .asciiz "Insira N: "

# Exibição de resultados
printMatriz: .asciiz "[VETOR]\n"
printResult: .asciiz "Resultado do produto escalar: "

# Caracteres e organização
bop: .asciiz "]"
bcl: .asciiz "]"
dp: .asciiz ":"
nl: .asciiz "\n"
tab: .asciiz "\t"
sp: .asciiz " "
const: .float 1.0e-6

########################################################### [ MAIN ] #########################################################################

				
.globl main
.text

	# f7 = X
	# s7 = N
	# f10 = cos
main:   li $v0, 4
	la $a0, msgInicial
	syscall # Imprime mensagem inicial
	jal percorre
	jal fechar


########################################################### [ AUXILIARES ] ###################################################################

percorre:
	li $t0,3 # Initilize N
	l.s $f4,const # Set Accuracey
	li $v0,4 # syscall for Print String
	la $a0, promptLin # load address of prompt
	
	syscall # print the prompt
	li $v0,6 # Reads user number
	syscall
	
	mul.s $f2,$f0,$f0 # x^2
	mov.s $f12,$f0 # Answer
	
	for:
		abs.s $f1,$f0 # compares to the non-negative value of the series
		c.lt.s $f1,$f4 # is number < 1.0e-6?
		bc1t endfor
	
		subu $t1,$t0,1 # (n-1)
		mul $t1,$t1,$t0 # n(n-1)
		mtc1 $t1, $f3 # move n(n-1) to a floating register
		cvt.s.w $f3, $f3 # converts n(n-1) to a float
		div.s $f3,$f2,$f3 # (x^2)/(n(n-1))
		neg.s $f3,$f3 # -(x^2)/(n(n-1))
		mul.s $f0,$f0,$f3 # (Series*x^2)/(n(n-1))
		
		add.s $f12,$f12,$f0 # Puts answer into $f12
		
		addu $t0,$t0,2 # Increment n
		b for # Goes to the beggining of the loop
	endfor:
	
	li $v0,2 # Prints answer in $f12
	syscall

	move $ra, $t9
	jr $ra
		
########################################################## [ FIM DO PROGRAMA ] ###############################################################


fechar:
	li $v0, 10
	syscall # Encerra o programa
