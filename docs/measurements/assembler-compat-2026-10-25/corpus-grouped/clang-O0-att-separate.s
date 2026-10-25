	.att_syntax
	.file	"compiler-corpus.c"
	.section	.text.corpus_extend,"ax",@progbits
	.globl	corpus_extend                   # -- Begin function corpus_extend
	.p2align	4
	.type	corpus_extend,@function
corpus_extend:                          # @corpus_extend
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movw	%cx, %ax
	movw	%dx, %cx
	movb	%sil, %dl
	movb	%dil, %sil
	movb	%sil, -1(%rbp)
	movb	%dl, -2(%rbp)
	movw	%cx, -4(%rbp)
	movw	%ax, -6(%rbp)
	movl	%r8d, -12(%rbp)
	movsbq	-1(%rbp), %rax
	movzbl	-2(%rbp), %ecx
                                        # kill: def $rcx killed $ecx
	addq	%rcx, %rax
	movswq	-4(%rbp), %rcx
	addq	%rcx, %rax
	movzwl	-6(%rbp), %ecx
                                        # kill: def $rcx killed $ecx
	addq	%rcx, %rax
	movslq	-12(%rbp), %rcx
	addq	%rcx, %rax
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end0:
	.size	corpus_extend, .Lfunc_end0-corpus_extend
	.cfi_endproc
                                        # -- End function
	.section	.text.corpus_load,"ax",@progbits
	.globl	corpus_load                     # -- Begin function corpus_load
	.p2align	4
	.type	corpus_load,@function
corpus_load:                            # @corpus_load
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)
	movq	%rcx, -32(%rbp)
	movq	%r8, -40(%rbp)
	movq	-8(%rbp), %rax
	movsbq	(%rax), %rax
	movq	-16(%rbp), %rcx
	movzbl	(%rcx), %ecx
                                        # kill: def $rcx killed $ecx
	addq	%rcx, %rax
	movq	-24(%rbp), %rcx
	movswq	(%rcx), %rcx
	addq	%rcx, %rax
	movq	-32(%rbp), %rcx
	movzwl	(%rcx), %ecx
                                        # kill: def $rcx killed $ecx
	addq	%rcx, %rax
	movq	-40(%rbp), %rcx
	movslq	(%rcx), %rcx
	addq	%rcx, %rax
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end1:
	.size	corpus_load, .Lfunc_end1-corpus_load
	.cfi_endproc
                                        # -- End function
	.section	.text.corpus_loop,"ax",@progbits
	.globl	corpus_loop                     # -- Begin function corpus_loop
	.p2align	4
	.type	corpus_loop,@function
corpus_loop:                            # @corpus_loop
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	%rdi, -8(%rbp)
	movl	%esi, -12(%rbp)
	movq	$3, -24(%rbp)
	movl	$0, -28(%rbp)
.LBB2_1:                                # =>This Inner Loop Header: Depth=1
	movl	-28(%rbp), %eax
	cmpl	-12(%rbp), %eax
	jae	.LBB2_4
# %bb.2:                                #   in Loop: Header=BB2_1 Depth=1
	imulq	$7, -24(%rbp), %rax
	movq	-8(%rbp), %rcx
	movl	-28(%rbp), %edx
                                        # kill: def $rdx killed $edx
	addq	(%rcx,%rdx,8), %rax
	movq	%rax, -24(%rbp)
# %bb.3:                                #   in Loop: Header=BB2_1 Depth=1
	movl	-28(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -28(%rbp)
	jmp	.LBB2_1
.LBB2_4:
	movq	-24(%rbp), %rax
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end2:
	.size	corpus_loop, .Lfunc_end2-corpus_loop
	.cfi_endproc
                                        # -- End function
	.section	.text.corpus_divide,"ax",@progbits
	.globl	corpus_divide                   # -- Begin function corpus_divide
	.p2align	4
	.type	corpus_divide,@function
corpus_divide:                          # @corpus_divide
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	-8(%rbp), %rax
	cqto
	idivq	-16(%rbp)
	movq	%rax, -24(%rbp)                 # 8-byte Spill
	movq	-8(%rbp), %rax
	cqto
	idivq	-16(%rbp)
	movq	-24(%rbp), %rax                 # 8-byte Reload
	addq	%rdx, %rax
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end3:
	.size	corpus_divide, .Lfunc_end3-corpus_divide
	.cfi_endproc
                                        # -- End function
	.section	.text.corpus_choose,"ax",@progbits
	.globl	corpus_choose                   # -- Begin function corpus_choose
	.p2align	4
	.type	corpus_choose,@function
corpus_choose:                          # @corpus_choose
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	-8(%rbp), %rax
	cmpq	-16(%rbp), %rax
	jge	.LBB4_2
# %bb.1:
	movq	-8(%rbp), %rax
	subq	$19, %rax
	movq	%rax, -24(%rbp)                 # 8-byte Spill
	jmp	.LBB4_3
.LBB4_2:
	movq	-16(%rbp), %rax
	addq	$23, %rax
	movq	%rax, -24(%rbp)                 # 8-byte Spill
.LBB4_3:
	movq	-24(%rbp), %rax                 # 8-byte Reload
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end4:
	.size	corpus_choose, .Lfunc_end4-corpus_choose
	.cfi_endproc
                                        # -- End function
	.section	.text.corpus_call,"ax",@progbits
	.globl	corpus_call                     # -- Begin function corpus_call
	.p2align	4
	.type	corpus_call,@function
corpus_call:                            # @corpus_call
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rdi
	addq	corpus_initialized, %rdi
	callq	corpus_external
	movq	%rax, -16(%rbp)
	movq	-16(%rbp), %rax
	movq	%rax, corpus_zero
	movq	-16(%rbp), %rax
	movq	-8(%rbp), %rcx
	andq	$3, %rcx
	addq	corpus_table(,%rcx,8), %rax
	addq	$16, %rsp
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end5:
	.size	corpus_call, .Lfunc_end5-corpus_call
	.cfi_endproc
                                        # -- End function
	.section	.text.corpus_string,"ax",@progbits
	.globl	corpus_string                   # -- Begin function corpus_string
	.p2align	4
	.type	corpus_string,@function
corpus_string:                          # @corpus_string
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movabsq	$.L.str, %rax
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end6:
	.size	corpus_string, .Lfunc_end6-corpus_string
	.cfi_endproc
                                        # -- End function
	.section	.text.corpus_address,"ax",@progbits
	.globl	corpus_address                  # -- Begin function corpus_address
	.p2align	4
	.type	corpus_address,@function
corpus_address:                         # @corpus_address
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movabsq	$corpus_table, %rax
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end7:
	.size	corpus_address, .Lfunc_end7-corpus_address
	.cfi_endproc
                                        # -- End function
	.type	corpus_initialized,@object      # @corpus_initialized
	.section	.data.corpus_initialized,"aw",@progbits
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
	.section	.data.corpus_message,"aw",@progbits
	.globl	corpus_message
	.p2align	3, 0x0
corpus_message:
	.quad	.L.str
	.size	corpus_message, 8

	.type	corpus_zero,@object             # @corpus_zero
	.section	.bss.corpus_zero,"aw",@nobits
	.globl	corpus_zero
	.p2align	3, 0x0
corpus_zero:
	.quad	0                               # 0x0
	.size	corpus_zero, 8

	.type	corpus_table,@object            # @corpus_table
	.section	.rodata.corpus_table,"a",@progbits
	.p2align	4, 0x0
corpus_table:
	.quad	11                              # 0xb
	.quad	-17                             # 0xffffffffffffffef
	.quad	23                              # 0x17
	.quad	41                              # 0x29
	.size	corpus_table, 32

	.ident	"clang version 23.1.1"
	.section	".note.GNU-stack","",@progbits
