	.file	"compiler-corpus.c"
	.intel_syntax noprefix
	.text
	.p2align 4
	.globl	"corpus_extend"
	.type	"corpus_extend", @function
"corpus_extend":
.LFB0:
	.cfi_startproc
	movzx	esi, sil
	movsx	rdi, dil
	movsx	rdx, dx
	movzx	ecx, cx
	add	rdi, rsi
	movsxd	r8, r8d
	add	rdi, rdx
	add	rdi, rcx
	lea	rax, [rdi+r8]
	ret
	.cfi_endproc
.LFE0:
	.size	"corpus_extend", .-"corpus_extend"
	.p2align 4
	.globl	"corpus_load"
	.type	"corpus_load", @function
"corpus_load":
.LFB1:
	.cfi_startproc
	movsx	rax, BYTE PTR [rdi]
	movzx	esi, BYTE PTR [rsi]
	movsx	rdx, WORD PTR [rdx]
	add	rax, rsi
	add	rax, rdx
	movzx	edx, WORD PTR [rcx]
	add	rax, rdx
	movsxd	rdx, DWORD PTR [r8]
	add	rax, rdx
	ret
	.cfi_endproc
.LFE1:
	.size	"corpus_load", .-"corpus_load"
	.p2align 4
	.globl	"corpus_loop"
	.type	"corpus_loop", @function
"corpus_loop":
.LFB2:
	.cfi_startproc
	test	esi, esi
	je	.L7
	mov	esi, esi
	mov	edx, 3
	lea	rcx, [rdi+rsi*8]
	.p2align 5
	.p2align 4
	.p2align 3
.L6:
	lea	rax, [0+rdx*8]
	add	rdi, 8
	sub	rax, rdx
	add	rax, QWORD PTR [rdi-8]
	mov	rdx, rax
	cmp	rdi, rcx
	jne	.L6
	mov	rax, rdx
	ret
	.p2align 4,,10
	.p2align 3
.L7:
	mov	edx, 3
	mov	rax, rdx
	ret
	.cfi_endproc
.LFE2:
	.size	"corpus_loop", .-"corpus_loop"
	.p2align 4
	.globl	"corpus_divide"
	.type	"corpus_divide", @function
"corpus_divide":
.LFB3:
	.cfi_startproc
	mov	rax, rdi
	cqo
	idiv	rsi
	add	rax, rdx
	ret
	.cfi_endproc
.LFE3:
	.size	"corpus_divide", .-"corpus_divide"
	.p2align 4
	.globl	"corpus_choose"
	.type	"corpus_choose", @function
"corpus_choose":
.LFB4:
	.cfi_startproc
	lea	rdx, [rdi-19]
	lea	rax, [rsi+23]
	cmp	rdi, rsi
	cmovl	rax, rdx
	ret
	.cfi_endproc
.LFE4:
	.size	"corpus_choose", .-"corpus_choose"
	.p2align 4
	.globl	"corpus_call"
	.type	"corpus_call", @function
"corpus_call":
.LFB5:
	.cfi_startproc
	push	rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	mov	rbx, rdi
	mov	rdi, QWORD PTR "corpus_initialized"[rip]
	add	rdi, rbx
	and	ebx, 3
	call	"corpus_external"
	mov	QWORD PTR "corpus_zero"[rip], rax
	add	rax, QWORD PTR "corpus_table"[0+rbx*8]
	pop	rbx
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE5:
	.size	"corpus_call", .-"corpus_call"
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"compiler assembly"
	.text
	.p2align 4
	.globl	"corpus_string"
	.type	"corpus_string", @function
"corpus_string":
.LFB6:
	.cfi_startproc
	mov	eax, OFFSET FLAT:.LC0
	ret
	.cfi_endproc
.LFE6:
	.size	"corpus_string", .-"corpus_string"
	.p2align 4
	.globl	"corpus_address"
	.type	"corpus_address", @function
"corpus_address":
.LFB7:
	.cfi_startproc
	mov	eax, OFFSET FLAT:"corpus_table"
	ret
	.cfi_endproc
.LFE7:
	.size	"corpus_address", .-"corpus_address"
	.section	.rodata
	.align 32
	.type	"corpus_table", @object
	.size	"corpus_table", 32
"corpus_table":
	.quad	11
	.quad	-17
	.quad	23
	.quad	41
	.globl	"corpus_message"
	.data
	.align 8
	.type	"corpus_message", @object
	.size	"corpus_message", 8
"corpus_message":
	.quad	.LC0
	.globl	"corpus_zero"
	.bss
	.align 8
	.type	"corpus_zero", @object
	.size	"corpus_zero", 8
"corpus_zero":
	.zero	8
	.globl	"corpus_initialized"
	.data
	.align 8
	.type	"corpus_initialized", @object
	.size	"corpus_initialized", 8
"corpus_initialized":
	.quad	37
	.ident	"GCC: (GNU) 16.2.1 20260810"
	.section	.note.GNU-stack,"",@progbits
