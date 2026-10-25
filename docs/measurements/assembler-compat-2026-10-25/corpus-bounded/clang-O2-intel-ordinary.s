	.intel_syntax noprefix
	.file	"compiler-corpus.c"
	.text
	.globl	corpus_extend                   # -- Begin function corpus_extend
	.p2align	4
	.type	corpus_extend,@function
corpus_extend:                          # @corpus_extend
	.cfi_startproc
# %bb.0:
	movsxd	rax, edi
	mov	esi, esi
	add	rsi, rax
	movsxd	rax, edx
	mov	ecx, ecx
	add	rcx, rax
	add	rcx, rsi
	movsxd	rax, r8d
	add	rax, rcx
	ret
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
	movsx	rax, byte ptr [rdi]
	movzx	esi, byte ptr [rsi]
	add	rsi, rax
	movsx	rax, word ptr [rdx]
	movzx	ecx, word ptr [rcx]
	add	rcx, rax
	add	rcx, rsi
	movsxd	rax, dword ptr [r8]
	add	rax, rcx
	ret
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
	test	esi, esi
	je	.LBB2_1
# %bb.2:
	mov	r8d, esi
	mov	ecx, r8d
	and	ecx, 3
	cmp	esi, 4
	jae	.LBB2_8
# %bb.3:
	mov	eax, 3
	xor	edx, edx
	jmp	.LBB2_5
.LBB2_1:
	mov	eax, 3
	ret
.LBB2_8:
	and	r8d, -4
	mov	eax, 3
	xor	edx, edx
	.p2align	4
.LBB2_9:                                # =>This Inner Loop Header: Depth=1
	lea	rsi, [8*rax]
	add	rsi, qword ptr [rdi + 8*rdx]
	sub	rsi, rax
	lea	rax, [8*rsi]
	add	rax, qword ptr [rdi + 8*rdx + 8]
	sub	rax, rsi
	lea	rsi, [8*rax]
	add	rsi, qword ptr [rdi + 8*rdx + 16]
	sub	rsi, rax
	lea	rax, [8*rsi]
	add	rax, qword ptr [rdi + 8*rdx + 24]
	sub	rax, rsi
	add	rdx, 4
	cmp	r8, rdx
	jne	.LBB2_9
# %bb.4:
	test	rcx, rcx
	je	.LBB2_7
.LBB2_5:
	lea	rdx, [rdi + 8*rdx]
	xor	esi, esi
	.p2align	4
.LBB2_6:                                # =>This Inner Loop Header: Depth=1
	mov	rdi, rax
	lea	rax, [8*rax]
	add	rax, qword ptr [rdx + 8*rsi]
	sub	rax, rdi
	inc	rsi
	cmp	rcx, rsi
	jne	.LBB2_6
.LBB2_7:
	ret
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
	mov	rax, rdi
	mov	rcx, rdi
	or	rcx, rsi
	shr	rcx, 32
	je	.LBB3_1
# %bb.2:
	cqo
	idiv	rsi
	add	rax, rdx
	ret
.LBB3_1:
                                        # kill: def $eax killed $eax killed $rax
	xor	edx, edx
	div	esi
                                        # kill: def $edx killed $edx def $rdx
                                        # kill: def $eax killed $eax def $rax
	add	rax, rdx
	ret
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
	lea	rcx, [rdi - 19]
	lea	rax, [rsi + 23]
	cmp	rdi, rsi
	cmovl	rax, rcx
	ret
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
	push	rbx
	.cfi_def_cfa_offset 16
	.cfi_offset rbx, -16
	mov	rbx, rdi
	mov	rdi, qword ptr [rip + corpus_initialized]
	add	rdi, rbx
	call	corpus_external
	mov	qword ptr [rip + corpus_zero], rax
	and	ebx, 3
	add	rax, qword ptr [8*rbx + corpus_table]
	pop	rbx
	.cfi_def_cfa_offset 8
	ret
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
	mov	eax, offset .L.str
	ret
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
	mov	eax, offset corpus_table
	ret
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
