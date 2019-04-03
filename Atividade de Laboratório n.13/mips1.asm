
.data	
options:	.asciiz	"MENU : \n 1 - Sair \n 2 - Proximo No \n 3 - Ultimo No \n 4 - Inserir depois do No atual \n 5 - Deletar No corrente \n 6 - Reset \n 7 - Debug \n"
insertMessage:	.asciiz	"Por favor, insira uma string de no maximo 10 caracteres\n"
character:	.asciiz	""
empty:		.asciiz	"Ainda não há No\n"
doneAdding:	.asciiz	"\nNo adicionado\n"
currentIs:	.asciiz	"O No atual eh: "
emptyLine:	.asciiz	"\n"
array:		.asciiz "Todos os elementos da lista: \n"
	
.text	
main:
	
start:	
	beqz	$s7, noEle	
	la	$a0, currentIs # 1)
	jal	consolePrint
	move	$a0, $a3	# 2)
	jal	consolePrint
	la	$a0, emptyLine #3)
	jal	consolePrint

optionMenu:

	la	$a0, options
	jal	consolePrint
	
	li	$v0, 5
	syscall
	
	move	$t0, $v0

#----------------------------------------------------
# Escolhas
#----------------------------------------------------
	beq		$t0, 1, exit
	beq		$t0, 2, next
	beq		$t0, 3, previous
	beq  		$t0, 4, insert  
	beq		$t0, 5, del
	beq		$t0, 6, reset
	beq		$t0, 7, debug
	
	
#----------------------------------------------------
# Syscall exit
#----------------------------------------------------	
exit:
	li	$v0, 17
	syscall
	
#----------------------------------------------------
# Inserir novo
#----------------------------------------------------		
insert:	
	j	addnode
#----------------------------------------------------
# Delete No
#----------------------------------------------------	
del: 	
	jal	delnode
	j	start
#----------------------------------------------------
# Atravessar a lista
#----------------------------------------------------
next:
	beqz	$s7, start
	lw	$t5, 12($a3)	
	bnez	$t5, nextNode
	j	start

#----------------------------------------------------
# Ultimo No
#----------------------------------------------------
previous:
	beqz	$s7, start
	beq	$s7, $a3, start
	jal	goBack
	j 	start
#----------------------------------------------------
# Redefinir a corrente para ser o primeiro nó
#----------------------------------------------------
reset:
	move	$a3, $s7
	j	start
#----------------------------------------------------
# Imprima toda a lista vinculada
#----------------------------------------------------
debug:
	jal	printEverything
	j	start
#----------------------------------------------------
# PROCEDIMENTOS
#----------------------------------------------------
noEle:
	la	$a0, empty
	jal	consolePrint
	j 	optionMenu
	
addnode:
	la	$a0, insertMessage
	jal	consolePrint
	
	jal alloSpace
	move	$t1, $v0
	
	sw	$zero, ($t1)
	sw	$zero, 16($t1)
	
	li	$v0, 8
	la	$a0, 4($t1)
	li	$a1, 10
	syscall	

	beqz	$s7, declareFirstNode
	
	# Assumptions:
	#   $a3: ptr to current node (a global variable)
	#   $t1: ptr to new node (a parameter to the procedure)
	
	lw	$t2, 16($a3)
	beqz	$t2, noNextNode
	
	move	$t0, $t2
	la	$t2, 16($t1)
	la	$t0, -4($t0)
	sw	$t2, ($t0)
	
noNextNode:
	lw	$t2, 12($a3)
	sw	$t2, 16($t1)
	
	la	$t0, 4($t1)
	sw	$t0, 12($a3)
	
	la	$t2, ($a3)
	sw	$t2, ($t1)
	
	la	$a3, 4($t1)

	la	$a0, doneAdding
	jal	consolePrint	
	j	start
	
delnode:
	beqz	$s7, start
	
	lw	$t2, -4($a3)
	beqz	$t2, delHead
	
	lw	$t3, 12($a3)
	beqz	$t3, delTail
	
	lw	$t3, 12($a3)
	sw	$t2, -4($t3)
	
	lw	$t2, 12($a3)
	lw	$t3, -4($a3)
	sw	$t2, 12($t3)
	
	la	$a3, ($t2)
	
doneDel:			
	jr	$ra

delHead:
	lw	$t2, 12($a3)
	sw	$zero, -4($t2)
	la	$s7, ($t2)
	la	$a3, ($t2)
	j	doneDel
	
delTail:
	lw	$t2, -4($a3)
	sw	$zero, 12($t2)
	la	$a3, ($t2)
	j	doneDel
	
nextNode:
	la	$t5, 12($a3)
	lw	$a3, ($t5)
	j	start
	
goBack:
	la	$t5, -4($a3)
	lw	$a3, ($t5)
	jr	$ra

printEverything:
	la	$a0, array
	jal	consolePrint
	la	$t1, ($s7)
	beqz	$t1, start
	
printEle:
	move 	$a0, $t1
	jal 	consolePrint
	
	lw	$t2, 12($t1)
	beqz	$t2, start
	la	$t1, ($t2)
	j	printEle
	

alloSpace:
	li	$v0, 9
	li	$a0, 20
	syscall
	jr	$ra

declareFirstNode:
	la	$s7, 4($t1)
	la	$a3, 4($t1)
	la	$a0, doneAdding
	jal	consolePrint
	j	start
			
consolePrint:
	li	$v0, 4
	syscall
	jr	$ra
