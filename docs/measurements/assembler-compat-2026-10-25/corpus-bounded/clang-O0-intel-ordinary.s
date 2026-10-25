	.intel_syntax noprefix
	.file	"compiler-corpus.c"
	.text
	.globl	corpus_extend                   # -- Begin function corpus_extend
	.p2align	4
	.type	corpus_extend,@function
corpus_extend:                          # @corpus_extend
	.cfi_startproc
# %bb.0:
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset rbp, -16
	mov	rbp, rsp
	.cfi_def_cfa_register rbp
	mov	ax, cx
	mov	cx, dx
	mov	dl, sil
	mov	sil, dil
	mov	byte ptr [rbp - 1], sil
	mov	byte ptr [rbp - 2], dl
	mov	word ptr [rbp - 4], cx
	mov	word ptr [rbp - 6], ax
	mov	dword ptr [rbp - 12], r8d
	movsx	rax, byte ptr [rbp - 1]
	movzx	ecx, byte ptr [rbp - 2]
                                        # kill: def $rcx killed $ecx
	add	rax, rcx
	movsx	rcx, word ptr [rbp - 4]
	add	rax, rcx
	movzx	ecx, word ptr [rbp - 6]
                                        # kill: def $rcx killed $ecx
	add	rax, rcx
	movsxd	rcx, dword ptr [rbp - 12]
	add	rax, rcx
	pop	rbp
	.cfi_def_cfa rsp, 8
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
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset rbp, -16
	mov	rbp, rsp
	.cfi_def_cfa_register rbp
	mov	qword ptr [rbp - 8], rdi
	mov	qword ptr [rbp - 16], rsi
	mov	qword ptr [rbp - 24], rdx
	mov	qword ptr [rbp - 32], rcx
	mov	qword ptr [rbp - 40], r8
	mov	rax, qword ptr [rbp - 8]
	movsx	rax, byte ptr [rax]
	mov	rcx, qword ptr [rbp - 16]
	movzx	ecx, byte ptr [rcx]
                                        # kill: def $rcx killed $ecx
	add	rax, rcx
	mov	rcx, qword ptr [rbp - 24]
	movsx	rcx, word ptr [rcx]
	add	rax, rcx
	mov	rcx, qword ptr [rbp - 32]
	movzx	ecx, word ptr [rcx]
                                        # kill: def $rcx killed $ecx
	add	rax, rcx
	mov	rcx, qword ptr [rbp - 40]
	movsxd	rcx, dword ptr [rcx]
	add	rax, rcx
	pop	rbp
	.cfi_def_cfa rsp, 8
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
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset rbp, -16
	mov	rbp, rsp
	.cfi_def_cfa_register rbp
	mov	qword ptr [rbp - 8], rdi
	mov	dword ptr [rbp - 12], esi
	mov	qword ptr [rbp - 24], 3
	mov	dword ptr [rbp - 28], 0
.LBB2_1:                                # =>This Inner Loop Header: Depth=1
	mov	eax, dword ptr [rbp - 28]
	cmp	eax, dword ptr [rbp - 12]
	jae	.LBB2_4
# %bb.2:                                #   in Loop: Header=BB2_1 Depth=1
	imul	rax, qword ptr [rbp - 24], 7
	mov	rcx, qword ptr [rbp - 8]
	mov	edx, dword ptr [rbp - 28]
                                        # kill: def $rdx killed $edx
	add	rax, qword ptr [rcx + 8*rdx]
	mov	qword ptr [rbp - 24], rax
# %bb.3:                                #   in Loop: Header=BB2_1 Depth=1
	mov	eax, dword ptr [rbp - 28]
	add	eax, 1
	mov	dword ptr [rbp - 28], eax
	jmp	.LBB2_1
.LBB2_4:
	mov	rax, qword ptr [rbp - 24]
	pop	rbp
	.cfi_def_cfa rsp, 8
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
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset rbp, -16
	mov	rbp, rsp
	.cfi_def_cfa_register rbp
	mov	qword ptr [rbp - 8], rdi
	mov	qword ptr [rbp - 16], rsi
	mov	rax, qword ptr [rbp - 8]
	cqo
	idiv	qword ptr [rbp - 16]
	mov	qword ptr [rbp - 24], rax       # 8-byte Spill
	mov	rax, qword ptr [rbp - 8]
	cqo
	idiv	qword ptr [rbp - 16]
	mov	rax, qword ptr [rbp - 24]       # 8-byte Reload
	add	rax, rdx
	pop	rbp
	.cfi_def_cfa rsp, 8
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
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset rbp, -16
	mov	rbp, rsp
	.cfi_def_cfa_register rbp
	mov	qword ptr [rbp - 8], rdi
	mov	qword ptr [rbp - 16], rsi
	mov	rax, qword ptr [rbp - 8]
	cmp	rax, qword ptr [rbp - 16]
	jge	.LBB4_2
# %bb.1:
	mov	rax, qword ptr [rbp - 8]
	sub	rax, 19
	mov	qword ptr [rbp - 24], rax       # 8-byte Spill
	jmp	.LBB4_3
.LBB4_2:
	mov	rax, qword ptr [rbp - 16]
	add	rax, 23
	mov	qword ptr [rbp - 24], rax       # 8-byte Spill
.LBB4_3:
	mov	rax, qword ptr [rbp - 24]       # 8-byte Reload
	pop	rbp
	.cfi_def_cfa rsp, 8
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
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset rbp, -16
	mov	rbp, rsp
	.cfi_def_cfa_register rbp
	sub	rsp, 16
	mov	qword ptr [rbp - 8], rdi
	mov	rdi, qword ptr [rbp - 8]
	add	rdi, qword ptr [corpus_initialized]
	call	corpus_external
	mov	qword ptr [rbp - 16], rax
	mov	rax, qword ptr [rbp - 16]
	mov	qword ptr [corpus_zero], rax
	mov	rax, qword ptr [rbp - 16]
	mov	rcx, qword ptr [rbp - 8]
	and	rcx, 3
	add	rax, qword ptr [8*rcx + corpus_table]
	add	rsp, 16
	pop	rbp
	.cfi_def_cfa rsp, 8
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
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset rbp, -16
	mov	rbp, rsp
	.cfi_def_cfa_register rbp
	movabs	rax, offset .L.str
	pop	rbp
	.cfi_def_cfa rsp, 8
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
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset rbp, -16
	mov	rbp, rsp
	.cfi_def_cfa_register rbp
	movabs	rax, offset corpus_table
	pop	rbp
	.cfi_def_cfa rsp, 8
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
