	.att_syntax
	.file	"probe-expect.c"
	.text
	.globl	a                               # -- Begin function a
	.prefalign	4, .Lfunc_end0, nop
	.type	a,@function
a:                                      # @a
	.cfi_startproc
# %bb.0:
	testl	%ecx, %ecx
	je	.LBB0_12
# %bb.1:
	pushq	%r15
	.cfi_def_cfa_offset 16
	pushq	%r14
	.cfi_def_cfa_offset 24
	pushq	%r12
	.cfi_def_cfa_offset 32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	pushq	%rax
	.cfi_def_cfa_offset 48
	.cfi_offset %rbx, -40
	.cfi_offset %r12, -32
	.cfi_offset %r14, -24
	.cfi_offset %r15, -16
	movq	%rsi, %rbx
	movl	%ecx, %r12d
	testb	%dl, %dl
	je	.LBB0_2
# %bb.7:
	xorl	%r14d, %r14d
	.p2align	4
.LBB0_8:                                # =>This Inner Loop Header: Depth=1
	cmpl	$0, (%rbx,%r14,4)
	jne	.LBB0_9
.LBB0_10:                               #   in Loop: Header=BB0_8 Depth=1
	movl	%r14d, %edi
	callq	other@PLT
	incq	%r14
	cmpq	%r14, %r12
	jne	.LBB0_8
	jmp	.LBB0_11
.LBB0_9:                                #   in Loop: Header=BB0_8 Depth=1
	movl	%r14d, %edi
	callq	rare@PLT
	jmp	.LBB0_10
.LBB0_2:
	movq	%rdi, %r14
	xorl	%r15d, %r15d
	jmp	.LBB0_3
	.p2align	4
.LBB0_6:                                #   in Loop: Header=BB0_3 Depth=1
	movl	%r15d, %edi
	callq	other@PLT
	incq	%r15
	cmpq	%r15, %r12
	je	.LBB0_11
.LBB0_3:                                # =>This Inner Loop Header: Depth=1
	testb	$32, (%r14,%r15)
	je	.LBB0_6
# %bb.4:                                #   in Loop: Header=BB0_3 Depth=1
	cmpl	$0, (%rbx,%r15,4)
	je	.LBB0_6
# %bb.5:                                #   in Loop: Header=BB0_3 Depth=1
	movl	%r15d, %edi
	callq	rare@PLT
	jmp	.LBB0_6
.LBB0_11:
	addq	$8, %rsp
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%r12
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	.cfi_restore %rbx
	.cfi_restore %r12
	.cfi_restore %r14
	.cfi_restore %r15
.LBB0_12:
	retq
.Lfunc_end0:
	.size	a, .Lfunc_end0-a
	.cfi_endproc
                                        # -- End function
	.globl	b                               # -- Begin function b
	.prefalign	4, .Lfunc_end1, nop
	.type	b,@function
b:                                      # @b
	.cfi_startproc
# %bb.0:
	testl	%ecx, %ecx
	je	.LBB1_12
# %bb.1:
	pushq	%r15
	.cfi_def_cfa_offset 16
	pushq	%r14
	.cfi_def_cfa_offset 24
	pushq	%r12
	.cfi_def_cfa_offset 32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	pushq	%rax
	.cfi_def_cfa_offset 48
	.cfi_offset %rbx, -40
	.cfi_offset %r12, -32
	.cfi_offset %r14, -24
	.cfi_offset %r15, -16
	movq	%rsi, %rbx
	movl	%ecx, %r12d
	testb	%dl, %dl
	jne	.LBB1_7
# %bb.2:
	movq	%rdi, %r14
	xorl	%r15d, %r15d
	.p2align	4
.LBB1_3:                                # =>This Inner Loop Header: Depth=1
	testb	$32, (%r14,%r15)
	jne	.LBB1_4
.LBB1_6:                                #   in Loop: Header=BB1_3 Depth=1
	movl	%r15d, %edi
	callq	other@PLT
	incq	%r15
	cmpq	%r15, %r12
	jne	.LBB1_3
	jmp	.LBB1_11
.LBB1_4:                                #   in Loop: Header=BB1_3 Depth=1
	cmpl	$0, (%rbx,%r15,4)
	je	.LBB1_6
# %bb.5:                                #   in Loop: Header=BB1_3 Depth=1
	movl	%r15d, %edi
	callq	rare@PLT
	jmp	.LBB1_6
.LBB1_7:
	xorl	%r14d, %r14d
	jmp	.LBB1_8
.LBB1_10:                               #   in Loop: Header=BB1_8 Depth=1
	movl	%r14d, %edi
	callq	other@PLT
	incq	%r14
	cmpq	%r14, %r12
	je	.LBB1_11
.LBB1_8:                                # =>This Inner Loop Header: Depth=1
	cmpl	$0, (%rbx,%r14,4)
	je	.LBB1_10
# %bb.9:                                #   in Loop: Header=BB1_8 Depth=1
	movl	%r14d, %edi
	callq	rare@PLT
	jmp	.LBB1_10
.LBB1_11:
	addq	$8, %rsp
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%r12
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	.cfi_restore %rbx
	.cfi_restore %r12
	.cfi_restore %r14
	.cfi_restore %r15
.LBB1_12:
	retq
.Lfunc_end1:
	.size	b, .Lfunc_end1-b
	.cfi_endproc
                                        # -- End function
	.globl	c                               # -- Begin function c
	.prefalign	4, .Lfunc_end2, nop
	.type	c,@function
c:                                      # @c
	.cfi_startproc
# %bb.0:
	testl	%ecx, %ecx
	je	.LBB2_7
# %bb.1:
	pushq	%r15
	.cfi_def_cfa_offset 16
	pushq	%r14
	.cfi_def_cfa_offset 24
	pushq	%r13
	.cfi_def_cfa_offset 32
	pushq	%r12
	.cfi_def_cfa_offset 40
	pushq	%rbx
	.cfi_def_cfa_offset 48
	.cfi_offset %rbx, -48
	.cfi_offset %r12, -40
	.cfi_offset %r13, -32
	.cfi_offset %r14, -24
	.cfi_offset %r15, -16
	movl	%edx, %ebx
	movq	%rsi, %r14
	movq	%rdi, %r15
	movl	%ecx, %r13d
	xorl	%r12d, %r12d
	.p2align	4
.LBB2_2:                                # =>This Inner Loop Header: Depth=1
	movzbl	(%r15,%r12), %eax
	shrb	$5, %al
	andb	$1, %al
	orb	%bl, %al
	jne	.LBB2_3
.LBB2_5:                                #   in Loop: Header=BB2_2 Depth=1
	movl	%r12d, %edi
	callq	other@PLT
	incq	%r12
	cmpq	%r12, %r13
	jne	.LBB2_2
	jmp	.LBB2_6
.LBB2_3:                                #   in Loop: Header=BB2_2 Depth=1
	cmpl	$0, (%r14,%r12,4)
	je	.LBB2_5
# %bb.4:                                #   in Loop: Header=BB2_2 Depth=1
	movl	%r12d, %edi
	callq	rare@PLT
	jmp	.LBB2_5
.LBB2_6:
	popq	%rbx
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	.cfi_restore %rbx
	.cfi_restore %r12
	.cfi_restore %r13
	.cfi_restore %r14
	.cfi_restore %r15
.LBB2_7:
	retq
.Lfunc_end2:
	.size	c, .Lfunc_end2-c
	.cfi_endproc
                                        # -- End function
	.ident	"Ubuntu clang version 23.1.5 (++20261028083854+a738f2737189-1~exp1~20261028203912.92)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
