	.file	"small.c"
	.text
	.section	.text.stage_0,"ax",@progbits
	.p2align 4
	.globl	stage_0
	.type	stage_0, @function
stage_0:
.LFB0:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdi, %rbx
	leaq	17(%rdi), %rdi
	call	stage_external
	xorl	%edx, %edx
	cmpq	$10, %rax
	cmovg	%rdx, %rbx
	subq	%rbx, %rax
	popq	%rbx
	.cfi_def_cfa_offset 8
	xorq	$3, %rax
	ret
	.cfi_endproc
.LFE0:
	.size	stage_0, .-stage_0
	.section	.text.stage_1,"ax",@progbits
	.p2align 4
	.globl	stage_1
	.type	stage_1, @function
stage_1:
.LFB1:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdi, %rbx
	leaq	18(%rdi), %rdi
	call	stage_external
	xorl	%edx, %edx
	cmpq	$11, %rax
	cmovg	%rdx, %rbx
	subq	%rbx, %rax
	popq	%rbx
	.cfi_def_cfa_offset 8
	xorq	$40, %rax
	addq	$1, %rax
	ret
	.cfi_endproc
.LFE1:
	.size	stage_1, .-stage_1
	.section	.text.stage_2,"ax",@progbits
	.p2align 4
	.globl	stage_2
	.type	stage_2, @function
stage_2:
.LFB2:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdi, %rbx
	leaq	19(%rdi), %rdi
	call	stage_external
	xorl	%edx, %edx
	cmpq	$12, %rax
	cmovg	%rdx, %rbx
	subq	%rbx, %rax
	popq	%rbx
	.cfi_def_cfa_offset 8
	xorq	$77, %rax
	addq	$2, %rax
	ret
	.cfi_endproc
.LFE2:
	.size	stage_2, .-stage_2
	.section	.text.stage_3,"ax",@progbits
	.p2align 4
	.globl	stage_3
	.type	stage_3, @function
stage_3:
.LFB3:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdi, %rbx
	leaq	20(%rdi), %rdi
	call	stage_external
	xorl	%edx, %edx
	cmpq	$13, %rax
	cmovg	%rdx, %rbx
	subq	%rbx, %rax
	popq	%rbx
	.cfi_def_cfa_offset 8
	xorq	$114, %rax
	addq	$3, %rax
	ret
	.cfi_endproc
.LFE3:
	.size	stage_3, .-stage_3
	.section	.text.stage_4,"ax",@progbits
	.p2align 4
	.globl	stage_4
	.type	stage_4, @function
stage_4:
.LFB4:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdi, %rbx
	leaq	21(%rdi), %rdi
	call	stage_external
	xorl	%edx, %edx
	cmpq	$14, %rax
	cmovg	%rdx, %rbx
	subq	%rbx, %rax
	popq	%rbx
	.cfi_def_cfa_offset 8
	xorb	$-105, %al
	addq	$4, %rax
	ret
	.cfi_endproc
.LFE4:
	.size	stage_4, .-stage_4
	.section	.text.stage_5,"ax",@progbits
	.p2align 4
	.globl	stage_5
	.type	stage_5, @function
stage_5:
.LFB5:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdi, %rbx
	leaq	22(%rdi), %rdi
	call	stage_external
	xorl	%edx, %edx
	cmpq	$15, %rax
	cmovg	%rdx, %rbx
	subq	%rbx, %rax
	popq	%rbx
	.cfi_def_cfa_offset 8
	xorb	$-68, %al
	addq	$5, %rax
	ret
	.cfi_endproc
.LFE5:
	.size	stage_5, .-stage_5
	.section	.text.stage_6,"ax",@progbits
	.p2align 4
	.globl	stage_6
	.type	stage_6, @function
stage_6:
.LFB6:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdi, %rbx
	leaq	23(%rdi), %rdi
	call	stage_external
	xorl	%edx, %edx
	cmpq	$16, %rax
	cmovg	%rdx, %rbx
	subq	%rbx, %rax
	popq	%rbx
	.cfi_def_cfa_offset 8
	xorb	$-31, %al
	addq	$6, %rax
	ret
	.cfi_endproc
.LFE6:
	.size	stage_6, .-stage_6
	.section	.text.stage_7,"ax",@progbits
	.p2align 4
	.globl	stage_7
	.type	stage_7, @function
stage_7:
.LFB7:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdi, %rbx
	leaq	24(%rdi), %rdi
	call	stage_external
	xorl	%edx, %edx
	cmpq	$17, %rax
	cmovg	%rdx, %rbx
	subq	%rbx, %rax
	popq	%rbx
	.cfi_def_cfa_offset 8
	xorq	$262, %rax
	addq	$7, %rax
	ret
	.cfi_endproc
.LFE7:
	.size	stage_7, .-stage_7
	.section	.text.stage_8,"ax",@progbits
	.p2align 4
	.globl	stage_8
	.type	stage_8, @function
stage_8:
.LFB8:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdi, %rbx
	leaq	25(%rdi), %rdi
	call	stage_external
	xorl	%edx, %edx
	cmpq	$18, %rax
	cmovg	%rdx, %rbx
	subq	%rbx, %rax
	popq	%rbx
	.cfi_def_cfa_offset 8
	xorq	$299, %rax
	addq	$8, %rax
	ret
	.cfi_endproc
.LFE8:
	.size	stage_8, .-stage_8
	.section	.text.stage_9,"ax",@progbits
	.p2align 4
	.globl	stage_9
	.type	stage_9, @function
stage_9:
.LFB9:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdi, %rbx
	leaq	26(%rdi), %rdi
	call	stage_external
	xorl	%edx, %edx
	cmpq	$19, %rax
	cmovg	%rdx, %rbx
	subq	%rbx, %rax
	popq	%rbx
	.cfi_def_cfa_offset 8
	xorq	$336, %rax
	addq	$9, %rax
	ret
	.cfi_endproc
.LFE9:
	.size	stage_9, .-stage_9
	.section	.text.stage_10,"ax",@progbits
	.p2align 4
	.globl	stage_10
	.type	stage_10, @function
stage_10:
.LFB10:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdi, %rbx
	leaq	27(%rdi), %rdi
	call	stage_external
	xorl	%edx, %edx
	cmpq	$20, %rax
	cmovg	%rdx, %rbx
	subq	%rbx, %rax
	popq	%rbx
	.cfi_def_cfa_offset 8
	xorq	$373, %rax
	addq	$10, %rax
	ret
	.cfi_endproc
.LFE10:
	.size	stage_10, .-stage_10
	.section	.text.stage_11,"ax",@progbits
	.p2align 4
	.globl	stage_11
	.type	stage_11, @function
stage_11:
.LFB11:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdi, %rbx
	leaq	28(%rdi), %rdi
	call	stage_external
	xorl	%edx, %edx
	cmpq	$21, %rax
	cmovg	%rdx, %rbx
	subq	%rbx, %rax
	popq	%rbx
	.cfi_def_cfa_offset 8
	xorq	$410, %rax
	addq	$11, %rax
	ret
	.cfi_endproc
.LFE11:
	.size	stage_11, .-stage_11
	.section	.text.stage_12,"ax",@progbits
	.p2align 4
	.globl	stage_12
	.type	stage_12, @function
stage_12:
.LFB12:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdi, %rbx
	leaq	29(%rdi), %rdi
	call	stage_external
	xorl	%edx, %edx
	cmpq	$22, %rax
	cmovg	%rdx, %rbx
	subq	%rbx, %rax
	popq	%rbx
	.cfi_def_cfa_offset 8
	xorq	$447, %rax
	addq	$12, %rax
	ret
	.cfi_endproc
.LFE12:
	.size	stage_12, .-stage_12
	.section	.text.stage_13,"ax",@progbits
	.p2align 4
	.globl	stage_13
	.type	stage_13, @function
stage_13:
.LFB13:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdi, %rbx
	leaq	30(%rdi), %rdi
	call	stage_external
	xorl	%edx, %edx
	cmpq	$23, %rax
	cmovg	%rdx, %rbx
	subq	%rbx, %rax
	popq	%rbx
	.cfi_def_cfa_offset 8
	xorq	$484, %rax
	addq	$13, %rax
	ret
	.cfi_endproc
.LFE13:
	.size	stage_13, .-stage_13
	.section	.text.stage_14,"ax",@progbits
	.p2align 4
	.globl	stage_14
	.type	stage_14, @function
stage_14:
.LFB14:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdi, %rbx
	leaq	31(%rdi), %rdi
	call	stage_external
	xorl	%edx, %edx
	cmpq	$24, %rax
	cmovg	%rdx, %rbx
	subq	%rbx, %rax
	popq	%rbx
	.cfi_def_cfa_offset 8
	xorq	$521, %rax
	addq	$14, %rax
	ret
	.cfi_endproc
.LFE14:
	.size	stage_14, .-stage_14
	.section	.text.stage_15,"ax",@progbits
	.p2align 4
	.globl	stage_15
	.type	stage_15, @function
stage_15:
.LFB15:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdi, %rbx
	leaq	32(%rdi), %rdi
	call	stage_external
	xorl	%edx, %edx
	cmpq	$25, %rax
	cmovg	%rdx, %rbx
	subq	%rbx, %rax
	popq	%rbx
	.cfi_def_cfa_offset 8
	xorq	$558, %rax
	addq	$15, %rax
	ret
	.cfi_endproc
.LFE15:
	.size	stage_15, .-stage_15
	.section	.text.stage_16,"ax",@progbits
	.p2align 4
	.globl	stage_16
	.type	stage_16, @function
stage_16:
.LFB16:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdi, %rbx
	leaq	33(%rdi), %rdi
	call	stage_external
	xorl	%edx, %edx
	cmpq	$26, %rax
	cmovg	%rdx, %rbx
	subq	%rbx, %rax
	popq	%rbx
	.cfi_def_cfa_offset 8
	xorq	$595, %rax
	addq	$16, %rax
	ret
	.cfi_endproc
.LFE16:
	.size	stage_16, .-stage_16
	.section	.text.stage_17,"ax",@progbits
	.p2align 4
	.globl	stage_17
	.type	stage_17, @function
stage_17:
.LFB17:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdi, %rbx
	leaq	34(%rdi), %rdi
	call	stage_external
	xorl	%edx, %edx
	cmpq	$27, %rax
	cmovg	%rdx, %rbx
	subq	%rbx, %rax
	popq	%rbx
	.cfi_def_cfa_offset 8
	xorq	$632, %rax
	addq	$17, %rax
	ret
	.cfi_endproc
.LFE17:
	.size	stage_17, .-stage_17
	.section	.text.stage_18,"ax",@progbits
	.p2align 4
	.globl	stage_18
	.type	stage_18, @function
stage_18:
.LFB18:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdi, %rbx
	leaq	35(%rdi), %rdi
	call	stage_external
	xorl	%edx, %edx
	cmpq	$28, %rax
	cmovg	%rdx, %rbx
	subq	%rbx, %rax
	popq	%rbx
	.cfi_def_cfa_offset 8
	xorq	$669, %rax
	addq	$18, %rax
	ret
	.cfi_endproc
.LFE18:
	.size	stage_18, .-stage_18
	.section	.text.stage_19,"ax",@progbits
	.p2align 4
	.globl	stage_19
	.type	stage_19, @function
stage_19:
.LFB19:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdi, %rbx
	leaq	36(%rdi), %rdi
	call	stage_external
	xorl	%edx, %edx
	cmpq	$29, %rax
	cmovg	%rdx, %rbx
	subq	%rbx, %rax
	popq	%rbx
	.cfi_def_cfa_offset 8
	xorq	$706, %rax
	addq	$19, %rax
	ret
	.cfi_endproc
.LFE19:
	.size	stage_19, .-stage_19
	.section	.text.stage_20,"ax",@progbits
	.p2align 4
	.globl	stage_20
	.type	stage_20, @function
stage_20:
.LFB20:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdi, %rbx
	leaq	37(%rdi), %rdi
	call	stage_external
	xorl	%edx, %edx
	cmpq	$30, %rax
	cmovg	%rdx, %rbx
	subq	%rbx, %rax
	popq	%rbx
	.cfi_def_cfa_offset 8
	xorq	$743, %rax
	addq	$20, %rax
	ret
	.cfi_endproc
.LFE20:
	.size	stage_20, .-stage_20
	.section	.text.stage_21,"ax",@progbits
	.p2align 4
	.globl	stage_21
	.type	stage_21, @function
stage_21:
.LFB21:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdi, %rbx
	leaq	38(%rdi), %rdi
	call	stage_external
	xorl	%edx, %edx
	cmpq	$31, %rax
	cmovg	%rdx, %rbx
	subq	%rbx, %rax
	popq	%rbx
	.cfi_def_cfa_offset 8
	xorq	$780, %rax
	addq	$21, %rax
	ret
	.cfi_endproc
.LFE21:
	.size	stage_21, .-stage_21
	.section	.text.stage_22,"ax",@progbits
	.p2align 4
	.globl	stage_22
	.type	stage_22, @function
stage_22:
.LFB22:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdi, %rbx
	leaq	39(%rdi), %rdi
	call	stage_external
	xorl	%edx, %edx
	cmpq	$32, %rax
	cmovg	%rdx, %rbx
	subq	%rbx, %rax
	popq	%rbx
	.cfi_def_cfa_offset 8
	xorq	$817, %rax
	addq	$22, %rax
	ret
	.cfi_endproc
.LFE22:
	.size	stage_22, .-stage_22
	.section	.text.stage_23,"ax",@progbits
	.p2align 4
	.globl	stage_23
	.type	stage_23, @function
stage_23:
.LFB23:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdi, %rbx
	leaq	40(%rdi), %rdi
	call	stage_external
	xorl	%edx, %edx
	cmpq	$33, %rax
	cmovg	%rdx, %rbx
	subq	%rbx, %rax
	popq	%rbx
	.cfi_def_cfa_offset 8
	xorq	$854, %rax
	addq	$23, %rax
	ret
	.cfi_endproc
.LFE23:
	.size	stage_23, .-stage_23
	.section	.text.stage_24,"ax",@progbits
	.p2align 4
	.globl	stage_24
	.type	stage_24, @function
stage_24:
.LFB24:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdi, %rbx
	leaq	41(%rdi), %rdi
	call	stage_external
	xorl	%edx, %edx
	cmpq	$34, %rax
	cmovg	%rdx, %rbx
	subq	%rbx, %rax
	popq	%rbx
	.cfi_def_cfa_offset 8
	xorq	$891, %rax
	addq	$24, %rax
	ret
	.cfi_endproc
.LFE24:
	.size	stage_24, .-stage_24
	.section	.text.stage_25,"ax",@progbits
	.p2align 4
	.globl	stage_25
	.type	stage_25, @function
stage_25:
.LFB25:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdi, %rbx
	leaq	42(%rdi), %rdi
	call	stage_external
	xorl	%edx, %edx
	cmpq	$35, %rax
	cmovg	%rdx, %rbx
	subq	%rbx, %rax
	popq	%rbx
	.cfi_def_cfa_offset 8
	xorq	$928, %rax
	addq	$25, %rax
	ret
	.cfi_endproc
.LFE25:
	.size	stage_25, .-stage_25
	.section	.text.stage_26,"ax",@progbits
	.p2align 4
	.globl	stage_26
	.type	stage_26, @function
stage_26:
.LFB26:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdi, %rbx
	leaq	43(%rdi), %rdi
	call	stage_external
	xorl	%edx, %edx
	cmpq	$36, %rax
	cmovg	%rdx, %rbx
	subq	%rbx, %rax
	popq	%rbx
	.cfi_def_cfa_offset 8
	xorq	$965, %rax
	addq	$26, %rax
	ret
	.cfi_endproc
.LFE26:
	.size	stage_26, .-stage_26
	.section	.text.stage_27,"ax",@progbits
	.p2align 4
	.globl	stage_27
	.type	stage_27, @function
stage_27:
.LFB27:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdi, %rbx
	leaq	44(%rdi), %rdi
	call	stage_external
	xorl	%edx, %edx
	cmpq	$37, %rax
	cmovg	%rdx, %rbx
	subq	%rbx, %rax
	popq	%rbx
	.cfi_def_cfa_offset 8
	xorq	$1002, %rax
	addq	$27, %rax
	ret
	.cfi_endproc
.LFE27:
	.size	stage_27, .-stage_27
	.section	.text.stage_28,"ax",@progbits
	.p2align 4
	.globl	stage_28
	.type	stage_28, @function
stage_28:
.LFB28:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdi, %rbx
	leaq	45(%rdi), %rdi
	call	stage_external
	xorl	%edx, %edx
	cmpq	$38, %rax
	cmovg	%rdx, %rbx
	subq	%rbx, %rax
	popq	%rbx
	.cfi_def_cfa_offset 8
	xorq	$1039, %rax
	addq	$28, %rax
	ret
	.cfi_endproc
.LFE28:
	.size	stage_28, .-stage_28
	.section	.text.stage_29,"ax",@progbits
	.p2align 4
	.globl	stage_29
	.type	stage_29, @function
stage_29:
.LFB29:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdi, %rbx
	leaq	46(%rdi), %rdi
	call	stage_external
	xorl	%edx, %edx
	cmpq	$39, %rax
	cmovg	%rdx, %rbx
	subq	%rbx, %rax
	popq	%rbx
	.cfi_def_cfa_offset 8
	xorq	$1076, %rax
	addq	$29, %rax
	ret
	.cfi_endproc
.LFE29:
	.size	stage_29, .-stage_29
	.section	.text.stage_30,"ax",@progbits
	.p2align 4
	.globl	stage_30
	.type	stage_30, @function
stage_30:
.LFB30:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdi, %rbx
	leaq	47(%rdi), %rdi
	call	stage_external
	xorl	%edx, %edx
	cmpq	$40, %rax
	cmovg	%rdx, %rbx
	subq	%rbx, %rax
	popq	%rbx
	.cfi_def_cfa_offset 8
	xorq	$1113, %rax
	addq	$30, %rax
	ret
	.cfi_endproc
.LFE30:
	.size	stage_30, .-stage_30
	.section	.text.stage_31,"ax",@progbits
	.p2align 4
	.globl	stage_31
	.type	stage_31, @function
stage_31:
.LFB31:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdi, %rbx
	leaq	48(%rdi), %rdi
	call	stage_external
	xorl	%edx, %edx
	cmpq	$41, %rax
	cmovg	%rdx, %rbx
	subq	%rbx, %rax
	popq	%rbx
	.cfi_def_cfa_offset 8
	xorq	$1150, %rax
	addq	$31, %rax
	ret
	.cfi_endproc
.LFE31:
	.size	stage_31, .-stage_31
	.ident	"GCC: (GNU) 16.2.1 20260810"
	.section	.note.GNU-stack,"",@progbits
