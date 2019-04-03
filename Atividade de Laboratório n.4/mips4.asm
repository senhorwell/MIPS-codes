	.file	1 ""
	.section .mdebug.abi32
	.previous
	.nan	legacy
	.module	fp=32
	.module	nooddspreg
	.abicalls
	.section	.rodata.str1.4,"aMS",@progbits,1
	.align	2
$LC0:
	.ascii	"%d\000"
	.align	2
$LC1:
	.ascii	"Insira o Valor de vet[%d]:\000"
	.align	2
$LC2:
	.ascii	"%d \000"
	.align	2
$LC3:
	.ascii	"insira K: \000"
	.align	2
$LC4:
	.ascii	"v[%d]:%d e maior que k e menor que 2*k\012\000"
	.align	2
$LC5:
	.ascii	"v[%d]:%d e igual a K\012\000"
	.section	.text.startup,"ax",@progbits
	.align	2
	.globl	main
	.set	nomips16
	.set	nomicromips
	.ent	main
	.type	main, @function
main:
	.frame	$fp,72,$31		# vars= 8, regs= 9/0, args= 16, gp= 8
	.mask	0xc07f0000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	.set	nomacro
	addiu	$sp,$sp,-72
	sw	$17,40($sp)
	lw	$17,%got($LC0)($28)
	sw	$fp,64($sp)
	lw	$25,%call16(__isoc99_scanf)($28)
	movz	$31,$31,$0
	move	$fp,$sp
	sw	$22,60($sp)
	sw	$21,56($sp)
	sw	$20,52($sp)
	sw	$19,48($sp)
	sw	$18,44($sp)
	sw	$16,36($sp)
	.cprestore	16
	sw	$31,68($sp)
	addiu	$5,$fp,28
	.reloc	1f,R_MIPS_JALR,__isoc99_scanf
1:	jalr	$25
	addiu	$4,$17,%lo($LC0)

	lw	$2,28($fp)
	lw	$28,16($fp)
	sll	$2,$2,2
	addiu	$2,$2,10
	srl	$2,$2,3
	sll	$2,$2,3
	subu	$sp,$sp,$2
	lw	$21,%got($LC1)($28)
	addiu	$16,$sp,16
	move	$18,$16
	move	$20,$16
	move	$19,$0
	addiu	$21,$21,%lo($LC1)
	addiu	$22,$17,%lo($LC0)
$L2:
	lw	$6,28($fp)
	nop
	slt	$2,$19,$6
	beq	$2,$0,$L19
	move	$5,$21

	lw	$25,%call16(__printf_chk)($28)
	move	$6,$19
	.reloc	1f,R_MIPS_JALR,__printf_chk
1:	jalr	$25
	li	$4,1			# 0x1

	lw	$28,16($fp)
	lw	$5,0($20)
	lw	$25,%call16(__isoc99_scanf)($28)
	nop
	.reloc	1f,R_MIPS_JALR,__isoc99_scanf
1:	jalr	$25
	move	$4,$22

	addiu	$19,$19,1
	lw	$28,16($fp)
	b	$L2
	addiu	$20,$20,4

$L19:
	move	$4,$16
	move	$3,$0
	move	$5,$0
$L4:
	slt	$2,$5,$6
	beq	$2,$0,$L7
	sll	$2,$3,2

	addu	$2,$16,$2
$L8:
	slt	$7,$3,$6
	beq	$7,$0,$L20
	nop

	lw	$7,0($4)
	lw	$8,0($2)
	nop
	slt	$9,$8,$7
	beq	$9,$0,$L5
	nop

	sw	$8,0($4)
	sw	$7,0($2)
$L5:
	addiu	$3,$3,1
	b	$L8
	addiu	$2,$2,4

$L20:
	addiu	$5,$5,1
	b	$L4
	addiu	$4,$4,4

$L7:
	lw	$19,%got($LC2)($28)
	nop
	addiu	$19,$19,%lo($LC2)
$L16:
	lw	$2,28($fp)
	nop
	blez	$2,$L21
	move	$5,$19

	lw	$25,%call16(__printf_chk)($28)
	lw	$6,0($16)
	.reloc	1f,R_MIPS_JALR,__printf_chk
1:	jalr	$25
	li	$4,1			# 0x1

	lw	$28,16($fp)
	b	$L16
	nop

$L21:
	lw	$25,%call16(putchar)($28)
	nop
	.reloc	1f,R_MIPS_JALR,putchar
1:	jalr	$25
	li	$4,10			# 0xa

	lw	$28,16($fp)
	li	$4,1			# 0x1
	lw	$20,%got($LC3)($28)
	lw	$25,%call16(__printf_chk)($28)
	nop
	.reloc	1f,R_MIPS_JALR,__printf_chk
1:	jalr	$25
	addiu	$5,$20,%lo($LC3)

	lw	$28,16($fp)
	addiu	$19,$fp,24
	lw	$25,%call16(__isoc99_scanf)($28)
	move	$5,$19
	.reloc	1f,R_MIPS_JALR,__isoc99_scanf
1:	jalr	$25
	addiu	$4,$17,%lo($LC0)

	lw	$28,16($fp)
	move	$21,$0
	lw	$22,%got($LC4)($28)
	nop
	addiu	$22,$22,%lo($LC4)
$L10:
	lw	$2,24($fp)
	nop
	slt	$3,$21,$2
	beq	$3,$0,$L22
	addiu	$5,$20,%lo($LC3)

	lw	$7,0($16)
	nop
	slt	$3,$2,$7
	beq	$3,$0,$L11
	sll	$2,$2,1

	slt	$2,$7,$2
	beq	$2,$0,$L11
	move	$6,$21

	lw	$25,%call16(__printf_chk)($28)
	move	$5,$22
	.reloc	1f,R_MIPS_JALR,__printf_chk
1:	jalr	$25
	li	$4,1			# 0x1

	lw	$28,16($fp)
$L11:
	addiu	$21,$21,1
	b	$L10
	addiu	$16,$16,4

$L22:
	lw	$25,%call16(__printf_chk)($28)
	nop
	.reloc	1f,R_MIPS_JALR,__printf_chk
1:	jalr	$25
	li	$4,1			# 0x1

	lw	$28,16($fp)
	addiu	$4,$17,%lo($LC0)
	lw	$25,%call16(__isoc99_scanf)($28)
	nop
	.reloc	1f,R_MIPS_JALR,__isoc99_scanf
1:	jalr	$25
	move	$5,$19

	lw	$28,16($fp)
	move	$16,$0
	lw	$17,%got($LC5)($28)
	nop
	addiu	$17,$17,%lo($LC5)
$L13:
	lw	$7,24($fp)
	nop
	slt	$2,$16,$7
	beq	$2,$0,$L23
	nop

	lw	$2,0($18)
	nop
	bne	$7,$2,$L14
	move	$6,$16

	lw	$25,%call16(__printf_chk)($28)
	move	$5,$17
	.reloc	1f,R_MIPS_JALR,__printf_chk
1:	jalr	$25
	li	$4,1			# 0x1

	lw	$28,16($fp)
$L14:
	addiu	$16,$16,1
	b	$L13
	addiu	$18,$18,4

$L23:
	move	$sp,$fp
	lw	$31,68($fp)
	lw	$fp,64($sp)
	lw	$22,60($sp)
	lw	$21,56($sp)
	lw	$20,52($sp)
	lw	$19,48($sp)
	lw	$18,44($sp)
	lw	$17,40($sp)
	lw	$16,36($sp)
	j	$31
	addiu	$sp,$sp,72

	.set	macro
	.set	reorder
	.end	main
	.size	main, .-main
	.ident	"GCC: (Ubuntu 5.4.0-6ubuntu1~16.04.9) 5.4.0 20160609"