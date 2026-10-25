	.att_syntax
	.file	"compiler-corpus.c"
	.text
	.globl	corpus_extend                   # -- Begin function corpus_extend
	.p2align	4
	.type	corpus_extend,@function
corpus_extend:                          # @corpus_extend
	.cfi_startproc
# %bb.0:
	movslq	%edi, %rax
	movl	%esi, %esi
	addq	%rax, %rsi
	movslq	%edx, %rax
	movl	%ecx, %ecx
	addq	%rax, %rcx
	addq	%rsi, %rcx
	movslq	%r8d, %rax
	addq	%rcx, %rax
	retq
.Lfunc_end0:
	.size	corpus_extend, .Lfunc_end0-corpus_extend
	.cfi_endproc
                                        # -- End function
	.globl	corpus_load                     # -- Begin function corpus_load
	.p2align	4
	.type	corpus_load,@function
corpus_load:                            # @corpus_load
	.cfi_startproc
# %bb.0:
	movsbq	(%rdi), %rax
	movzbl	(%rsi), %esi
	addq	%rax, %rsi
	movswq	(%rdx), %rax
	movzwl	(%rcx), %ecx
	addq	%rax, %rcx
	addq	%rsi, %rcx
	movslq	(%r8), %rax
	addq	%rcx, %rax
	retq
.Lfunc_end1:
	.size	corpus_load, .Lfunc_end1-corpus_load
	.cfi_endproc
                                        # -- End function
	.globl	corpus_loop                     # -- Begin function corpus_loop
	.p2align	4
	.type	corpus_loop,@function
corpus_loop:                            # @corpus_loop
	.cfi_startproc
# %bb.0:
	testl	%esi, %esi
	je	.LBB2_1
# %bb.2:
	movl	%esi, %r8d
	movl	%r8d, %ecx
	andl	$3, %ecx
	cmpl	$4, %esi
	jae	.LBB2_8
# %bb.3:
	movl	$3, %eax
	xorl	%edx, %edx
	jmp	.LBB2_5
.LBB2_1:
	movl	$3, %eax
	retq
.LBB2_8:
	andl	$-4, %r8d
	movl	$3, %eax
	xorl	%edx, %edx
	.p2align	4
.LBB2_9:                                # =>This Inner Loop Header: Depth=1
	leaq	(,%rax,8), %rsi
	addq	(%rdi,%rdx,8), %rsi
	subq	%rax, %rsi
	leaq	(,%rsi,8), %rax
	addq	8(%rdi,%rdx,8), %rax
	subq	%rsi, %rax
	leaq	(,%rax,8), %rsi
	addq	16(%rdi,%rdx,8), %rsi
	subq	%rax, %rsi
	leaq	(,%rsi,8), %rax
	addq	24(%rdi,%rdx,8), %rax
	subq	%rsi, %rax
	addq	$4, %rdx
	cmpq	%rdx, %r8
	jne	.LBB2_9
# %bb.4:
	testq	%rcx, %rcx
	je	.LBB2_7
.LBB2_5:
	leaq	(%rdi,%rdx,8), %rdx
	xorl	%esi, %esi
	.p2align	4
.LBB2_6:                                # =>This Inner Loop Header: Depth=1
	movq	%rax, %rdi
	leaq	(,%rax,8), %rax
	addq	(%rdx,%rsi,8), %rax
	subq	%rdi, %rax
	incq	%rsi
	cmpq	%rsi, %rcx
	jne	.LBB2_6
.LBB2_7:
	retq
.Lfunc_end2:
	.size	corpus_loop, .Lfunc_end2-corpus_loop
	.cfi_endproc
                                        # -- End function
	.globl	corpus_divide                   # -- Begin function corpus_divide
	.p2align	4
	.type	corpus_divide,@function
corpus_divide:                          # @corpus_divide
	.cfi_startproc
# %bb.0:
	movq	%rdi, %rax
	movq	%rdi, %rcx
	orq	%rsi, %rcx
	shrq	$32, %rcx
	je	.LBB3_1
# %bb.2:
	cqto
	idivq	%rsi
	addq	%rdx, %rax
	retq
.LBB3_1:
                                        # kill: def $eax killed $eax killed $rax
	xorl	%edx, %edx
	divl	%esi
                                        # kill: def $edx killed $edx def $rdx
                                        # kill: def $eax killed $eax def $rax
	addq	%rdx, %rax
	retq
.Lfunc_end3:
	.size	corpus_divide, .Lfunc_end3-corpus_divide
	.cfi_endproc
                                        # -- End function
	.globl	corpus_choose                   # -- Begin function corpus_choose
	.p2align	4
	.type	corpus_choose,@function
corpus_choose:                          # @corpus_choose
	.cfi_startproc
# %bb.0:
	leaq	-19(%rdi), %rcx
	leaq	23(%rsi), %rax
	cmpq	%rsi, %rdi
	cmovlq	%rcx, %rax
	retq
.Lfunc_end4:
	.size	corpus_choose, .Lfunc_end4-corpus_choose
	.cfi_endproc
                                        # -- End function
	.globl	corpus_call                     # -- Begin function corpus_call
	.p2align	4
	.type	corpus_call,@function
corpus_call:                            # @corpus_call
	.cfi_startproc
# %bb.0:
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset %rbx, -16
	movq	%rdi, %rbx
	movq	corpus_initialized(%rip), %rdi
	addq	%rbx, %rdi
	callq	corpus_external
	movq	%rax, corpus_zero(%rip)
	andl	$3, %ebx
	addq	corpus_table(,%rbx,8), %rax
	popq	%rbx
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end5:
	.size	corpus_call, .Lfunc_end5-corpus_call
	.cfi_endproc
                                        # -- End function
	.globl	corpus_string                   # -- Begin function corpus_string
	.p2align	4
	.type	corpus_string,@function
corpus_string:                          # @corpus_string
	.cfi_startproc
# %bb.0:
	movl	$.L.str, %eax
	retq
.Lfunc_end6:
	.size	corpus_string, .Lfunc_end6-corpus_string
	.cfi_endproc
                                        # -- End function
	.globl	corpus_address                  # -- Begin function corpus_address
	.p2align	4
	.type	corpus_address,@function
corpus_address:                         # @corpus_address
	.cfi_startproc
# %bb.0:
	movl	$corpus_table, %eax
	retq
.Lfunc_end7:
	.size	corpus_address, .Lfunc_end7-corpus_address
	.cfi_endproc
                                        # -- End function
	.type	corpus_initialized,@object      # @corpus_initialized
	.data
	.globl	corpus_initialized
	.p2align	3, 0x0
corpus_initialized:
	.quad	37                              # 0x25
	.size	corpus_initialized, 8

	.type	.L.str,@object                  # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"compiler assembly"
	.size	.L.str, 18

	.type	corpus_message,@object          # @corpus_message
	.data
	.globl	corpus_message
	.p2align	3, 0x0
corpus_message:
	.quad	.L.str
	.size	corpus_message, 8

	.type	corpus_zero,@object             # @corpus_zero
	.bss
	.globl	corpus_zero
	.p2align	3, 0x0
corpus_zero:
	.quad	0                               # 0x0
	.size	corpus_zero, 8

	.type	corpus_table,@object            # @corpus_table
	.section	.rodata,"a",@progbits
	.p2align	4, 0x0
corpus_table:
	.quad	11                              # 0xb
	.quad	-17                             # 0xffffffffffffffef
	.quad	23                              # 0x17
	.quad	41                              # 0x29
	.size	corpus_table, 32

	.ident	"clang version 23.1.1"
	.section	".note.GNU-stack","",@progbits
