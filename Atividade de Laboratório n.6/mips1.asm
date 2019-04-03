.data
input: .asciiz		"casac"
input_len: .word	7	

.text
main:
	la	$a0, input_len	# Load data
	lw	$a0, 0($a0)
	la	$a1, input
	jal 	isPalindrome	# Do the Palindrome check
	add	$a0, $v0, $zero
	jal	printRes	# Print
	addi	$v0, $zero, 10
	syscall			# Exit


isPalindrome:
	# Check base case
	slti	$t0, $a0, 2
	bne	$t0, $zero, returnTrue

	# Make sure first and last are equal
	lb	$t0, 0($a1)
	addi	$t1, $a0, -1
	add	$t1, $t1, $a1
	lb	$t1, 0($t1)
	bne	$t0, $t1, returnFalse
	
	# Shift pointer, length, recurse
	addi	$a0, $a0, -2
	addi	$a1, $a1, 1
	j	isPalindrome
	
returnFalse:
	addi	$v0, $zero, 0
	jr	$ra


returnTrue:
	addi	$v0, $zero, 1

.data
IS_STRING: .asciiz	" is"
NOT_STRING: .asciiz	" NOT"
A_PAL_STRING: .asciiz	" a palindrome!"

.text		
printRes:
	add	$t4, $a0, $zero	# Stash result
	addi	$v0, $zero, 4
	la	$a0, input
	syscall			# print "<WORD>"
	la	$a0, IS_STRING
	syscall			# print "is"
	bne	$t4, $zero, printResCont
		la $a0, NOT_STRING  
		syscall		# print "not"
printResCont:
	la	$a0, A_PAL_STRING
	syscall			# print "a palindrome."
	jr	$ra