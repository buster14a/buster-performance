	.file	"compiler-corpus.c"
	.text
	.p2align 4
	.globl	corpus_extend
	.type	corpus_extend, @function
corpus_extend:
.LFB0:
	.cfi_startproc
	movzbl	%sil, %esi
	movsbq	%dil, %rdi
	movswq	%dx, %rdx
	movzwl	%cx, %ecx
	addq	%rsi, %rdi
	movslq	%r8d, %r8
	addq	%rdx, %rdi
	addq	%rcx, %rdi
	leaq	(%rdi,%r8), %rax
	ret
	.cfi_endproc
.LFE0:
	.size	corpus_extend, .-corpus_extend
	.p2align 4
	.globl	corpus_load
	.type	corpus_load, @function
corpus_load:
.LFB1:
	.cfi_startproc
	movsbq	(%rdi), %rax
	movzbl	(%rsi), %esi
	movswq	(%rdx), %rdx
	addq	%rsi, %rax
	addq	%rdx, %rax
	movzwl	(%rcx), %edx
	addq	%rdx, %rax
	movslq	(%r8), %rdx
	addq	%rdx, %rax
	ret
	.cfi_endproc
.LFE1:
	.size	corpus_load, .-corpus_load
	.p2align 4
	.globl	corpus_loop
	.type	corpus_loop, @function
corpus_loop:
.LFB2:
	.cfi_startproc
	testl	%esi, %esi
	je	.L7
	movl	%esi, %esi
	movl	$3, %edx
	leaq	(%rdi,%rsi,8), %rcx
	.p2align 5
	.p2align 4
	.p2align 3
.L6:
	leaq	0(,%rdx,8), %rax
	addq	$8, %rdi
	subq	%rdx, %rax
	addq	-8(%rdi), %rax
	movq	%rax, %rdx
	cmpq	%rcx, %rdi
	jne	.L6
	movq	%rdx, %rax
	ret
	.p2align 4,,10
	.p2align 3
.L7:
	movl	$3, %edx
	movq	%rdx, %rax
	ret
	.cfi_endproc
.LFE2:
	.size	corpus_loop, .-corpus_loop
	.p2align 4
	.globl	corpus_divide
	.type	corpus_divide, @function
corpus_divide:
.LFB3:
	.cfi_startproc
	movq	%rdi, %rax
	cqto
	idivq	%rsi
	addq	%rdx, %rax
	ret
	.cfi_endproc
.LFE3:
	.size	corpus_divide, .-corpus_divide
	.p2align 4
	.globl	corpus_choose
	.type	corpus_choose, @function
corpus_choose:
.LFB4:
	.cfi_startproc
	leaq	-19(%rdi), %rdx
	leaq	23(%rsi), %rax
	cmpq	%rsi, %rdi
	cmovl	%rdx, %rax
	ret
	.cfi_endproc
.LFE4:
	.size	corpus_choose, .-corpus_choose
	.p2align 4
	.globl	corpus_call
	.type	corpus_call, @function
corpus_call:
.LFB5:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdi, %rbx
	movq	corpus_initialized(%rip), %rdi
	addq	%rbx, %rdi
	andl	$3, %ebx
	call	corpus_external
	movq	%rax, corpus_zero(%rip)
	addq	corpus_table(,%rbx,8), %rax
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE5:
	.size	corpus_call, .-corpus_call
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"compiler assembly"
	.text
	.p2align 4
	.globl	corpus_string
	.type	corpus_string, @function
corpus_string:
.LFB6:
	.cfi_startproc
	movl	$.LC0, %eax
	ret
	.cfi_endproc
.LFE6:
	.size	corpus_string, .-corpus_string
	.p2align 4
	.globl	corpus_address
	.type	corpus_address, @function
corpus_address:
.LFB7:
	.cfi_startproc
	movl	$corpus_table, %eax
	ret
	.cfi_endproc
.LFE7:
	.size	corpus_address, .-corpus_address
	.section	.rodata
	.align 32
	.type	corpus_table, @object
	.size	corpus_table, 32
corpus_table:
	.quad	11
	.quad	-17
	.quad	23
	.quad	41
	.globl	corpus_message
	.data
	.align 8
	.type	corpus_message, @object
	.size	corpus_message, 8
corpus_message:
	.quad	.LC0
	.globl	corpus_zero
	.bss
	.align 8
	.type	corpus_zero, @object
	.size	corpus_zero, 8
corpus_zero:
	.zero	8
	.globl	corpus_initialized
	.data
	.align 8
	.type	corpus_initialized, @object
	.size	corpus_initialized, 8
corpus_initialized:
	.quad	37
	.ident	"GCC: (GNU) 16.2.1 20260810"
	.section	.note.GNU-stack,"",@progbits
