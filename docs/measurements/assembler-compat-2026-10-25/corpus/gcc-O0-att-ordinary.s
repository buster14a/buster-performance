	.file	"compiler-corpus.c"
	.text
	.globl	corpus_initialized
	.data
	.align 8
	.type	corpus_initialized, @object
	.size	corpus_initialized, 8
corpus_initialized:
	.quad	37
	.globl	corpus_zero
	.bss
	.align 8
	.type	corpus_zero, @object
	.size	corpus_zero, 8
corpus_zero:
	.zero	8
	.globl	corpus_message
	.section	.rodata
.LC0:
	.string	"compiler assembly"
	.data
	.align 8
	.type	corpus_message, @object
	.size	corpus_message, 8
corpus_message:
	.quad	.LC0
	.section	.rodata
	.align 32
	.type	corpus_table, @object
	.size	corpus_table, 32
corpus_table:
	.quad	11
	.quad	-17
	.quad	23
	.quad	41
	.text
	.globl	corpus_extend
	.type	corpus_extend, @function
corpus_extend:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movb	%dil, -1(%rbp)
	movb	%sil, -2(%rbp)
	movw	%dx, -4(%rbp)
	movw	%cx, -6(%rbp)
	movl	%r8d, -12(%rbp)
	movsbq	-1(%rbp), %rdx
	movzbl	-2(%rbp), %eax
	addq	%rax, %rdx
	movswq	-4(%rbp), %rax
	addq	%rax, %rdx
	movzwl	-6(%rbp), %eax
	addq	%rax, %rdx
	movl	-12(%rbp), %eax
	cltq
	addq	%rdx, %rax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	corpus_extend, .-corpus_extend
	.globl	corpus_load
	.type	corpus_load, @function
corpus_load:
.LFB1:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)
	movq	%rcx, -32(%rbp)
	movq	%r8, -40(%rbp)
	movq	-8(%rbp), %rax
	movzbl	(%rax), %eax
	movsbq	%al, %rdx
	movq	-16(%rbp), %rax
	movzbl	(%rax), %eax
	movzbl	%al, %eax
	addq	%rax, %rdx
	movq	-24(%rbp), %rax
	movzwl	(%rax), %eax
	movswq	%ax, %rax
	addq	%rax, %rdx
	movq	-32(%rbp), %rax
	movzwl	(%rax), %eax
	movzwl	%ax, %eax
	addq	%rax, %rdx
	movq	-40(%rbp), %rax
	movl	(%rax), %eax
	cltq
	addq	%rdx, %rax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	corpus_load, .-corpus_load
	.globl	corpus_loop
	.type	corpus_loop, @function
corpus_loop:
.LFB2:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)
	movl	%esi, -28(%rbp)
	movq	$3, -8(%rbp)
	movl	$0, -12(%rbp)
	jmp	.L6
.L7:
	movq	-8(%rbp), %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	movq	%rax, %rcx
	movl	-12(%rbp), %eax
	leaq	0(,%rax,8), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	addq	%rcx, %rax
	movq	%rax, -8(%rbp)
	addl	$1, -12(%rbp)
.L6:
	movl	-12(%rbp), %eax
	cmpl	-28(%rbp), %eax
	jb	.L7
	movq	-8(%rbp), %rax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	corpus_loop, .-corpus_loop
	.globl	corpus_divide
	.type	corpus_divide, @function
corpus_divide:
.LFB3:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	-8(%rbp), %rax
	cqto
	idivq	-16(%rbp)
	movq	%rax, %rcx
	movq	-8(%rbp), %rax
	cqto
	idivq	-16(%rbp)
	movq	%rdx, %rax
	addq	%rcx, %rax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3:
	.size	corpus_divide, .-corpus_divide
	.globl	corpus_choose
	.type	corpus_choose, @function
corpus_choose:
.LFB4:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	-8(%rbp), %rax
	cmpq	-16(%rbp), %rax
	jge	.L12
	movq	-8(%rbp), %rax
	subq	$19, %rax
	jmp	.L14
.L12:
	movq	-16(%rbp), %rax
	addq	$23, %rax
.L14:
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE4:
	.size	corpus_choose, .-corpus_choose
	.globl	corpus_call
	.type	corpus_call, @function
corpus_call:
.LFB5:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	corpus_initialized(%rip), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movq	%rax, %rdi
	call	corpus_external
	movq	%rax, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	%rax, corpus_zero(%rip)
	movq	-24(%rbp), %rax
	andl	$3, %eax
	movq	corpus_table(,%rax,8), %rdx
	movq	-8(%rbp), %rax
	addq	%rdx, %rax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE5:
	.size	corpus_call, .-corpus_call
	.globl	corpus_string
	.type	corpus_string, @function
corpus_string:
.LFB6:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	$.LC0, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	corpus_string, .-corpus_string
	.globl	corpus_address
	.type	corpus_address, @function
corpus_address:
.LFB7:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	$corpus_table, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	corpus_address, .-corpus_address
	.ident	"GCC: (GNU) 16.2.1 20260810"
	.section	.note.GNU-stack,"",@progbits
