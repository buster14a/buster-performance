	.file	"compiler-corpus.c"
	.intel_syntax noprefix
	.text
	.globl	"corpus_initialized"
	.section	.data.corpus_initialized,"aw"
	.align 8
	.type	"corpus_initialized", @object
	.size	"corpus_initialized", 8
"corpus_initialized":
	.quad	37
	.globl	"corpus_zero"
	.section	.bss.corpus_zero,"aw",@nobits
	.align 8
	.type	"corpus_zero", @object
	.size	"corpus_zero", 8
"corpus_zero":
	.zero	8
	.globl	"corpus_message"
	.section	.rodata
.LC0:
	.string	"compiler assembly"
	.section	.data.corpus_message,"aw"
	.align 8
	.type	"corpus_message", @object
	.size	"corpus_message", 8
"corpus_message":
	.quad	.LC0
	.section	.rodata.corpus_table,"a"
	.align 32
	.type	"corpus_table", @object
	.size	"corpus_table", 32
"corpus_table":
	.quad	11
	.quad	-17
	.quad	23
	.quad	41
	.section	.text.corpus_extend,"ax",@progbits
	.globl	"corpus_extend"
	.type	"corpus_extend", @function
"corpus_extend":
.LFB0:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	BYTE PTR [rbp-1], dil
	mov	BYTE PTR [rbp-2], sil
	mov	WORD PTR [rbp-4], dx
	mov	WORD PTR [rbp-6], cx
	mov	DWORD PTR [rbp-12], r8d
	movsx	rdx, BYTE PTR [rbp-1]
	movzx	eax, BYTE PTR [rbp-2]
	add	rdx, rax
	movsx	rax, WORD PTR [rbp-4]
	add	rdx, rax
	movzx	eax, WORD PTR [rbp-6]
	add	rdx, rax
	mov	eax, DWORD PTR [rbp-12]
	cdqe
	add	rax, rdx
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	"corpus_extend", .-"corpus_extend"
	.section	.text.corpus_load,"ax",@progbits
	.globl	"corpus_load"
	.type	"corpus_load", @function
"corpus_load":
.LFB1:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	QWORD PTR [rbp-8], rdi
	mov	QWORD PTR [rbp-16], rsi
	mov	QWORD PTR [rbp-24], rdx
	mov	QWORD PTR [rbp-32], rcx
	mov	QWORD PTR [rbp-40], r8
	mov	rax, QWORD PTR [rbp-8]
	movzx	eax, BYTE PTR [rax]
	movsx	rdx, al
	mov	rax, QWORD PTR [rbp-16]
	movzx	eax, BYTE PTR [rax]
	movzx	eax, al
	add	rdx, rax
	mov	rax, QWORD PTR [rbp-24]
	movzx	eax, WORD PTR [rax]
	movsx	rax, ax
	add	rdx, rax
	mov	rax, QWORD PTR [rbp-32]
	movzx	eax, WORD PTR [rax]
	movzx	eax, ax
	add	rdx, rax
	mov	rax, QWORD PTR [rbp-40]
	mov	eax, DWORD PTR [rax]
	cdqe
	add	rax, rdx
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	"corpus_load", .-"corpus_load"
	.section	.text.corpus_loop,"ax",@progbits
	.globl	"corpus_loop"
	.type	"corpus_loop", @function
"corpus_loop":
.LFB2:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	QWORD PTR [rbp-24], rdi
	mov	DWORD PTR [rbp-28], esi
	mov	QWORD PTR [rbp-8], 3
	mov	DWORD PTR [rbp-12], 0
	jmp	.L6
.L7:
	mov	rdx, QWORD PTR [rbp-8]
	mov	rax, rdx
	sal	rax, 3
	sub	rax, rdx
	mov	rcx, rax
	mov	eax, DWORD PTR [rbp-12]
	lea	rdx, [0+rax*8]
	mov	rax, QWORD PTR [rbp-24]
	add	rax, rdx
	mov	rax, QWORD PTR [rax]
	add	rax, rcx
	mov	QWORD PTR [rbp-8], rax
	add	DWORD PTR [rbp-12], 1
.L6:
	mov	eax, DWORD PTR [rbp-12]
	cmp	eax, DWORD PTR [rbp-28]
	jb	.L7
	mov	rax, QWORD PTR [rbp-8]
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	"corpus_loop", .-"corpus_loop"
	.section	.text.corpus_divide,"ax",@progbits
	.globl	"corpus_divide"
	.type	"corpus_divide", @function
"corpus_divide":
.LFB3:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	QWORD PTR [rbp-8], rdi
	mov	QWORD PTR [rbp-16], rsi
	mov	rax, QWORD PTR [rbp-8]
	cqo
	idiv	QWORD PTR [rbp-16]
	mov	rcx, rax
	mov	rax, QWORD PTR [rbp-8]
	cqo
	idiv	QWORD PTR [rbp-16]
	mov	rax, rdx
	add	rax, rcx
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3:
	.size	"corpus_divide", .-"corpus_divide"
	.section	.text.corpus_choose,"ax",@progbits
	.globl	"corpus_choose"
	.type	"corpus_choose", @function
"corpus_choose":
.LFB4:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	QWORD PTR [rbp-8], rdi
	mov	QWORD PTR [rbp-16], rsi
	mov	rax, QWORD PTR [rbp-8]
	cmp	rax, QWORD PTR [rbp-16]
	jge	.L12
	mov	rax, QWORD PTR [rbp-8]
	sub	rax, 19
	jmp	.L14
.L12:
	mov	rax, QWORD PTR [rbp-16]
	add	rax, 23
.L14:
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE4:
	.size	"corpus_choose", .-"corpus_choose"
	.section	.text.corpus_call,"ax",@progbits
	.globl	"corpus_call"
	.type	"corpus_call", @function
"corpus_call":
.LFB5:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 32
	mov	QWORD PTR [rbp-24], rdi
	mov	rdx, QWORD PTR "corpus_initialized"[rip]
	mov	rax, QWORD PTR [rbp-24]
	add	rax, rdx
	mov	rdi, rax
	call	"corpus_external"
	mov	QWORD PTR [rbp-8], rax
	mov	rax, QWORD PTR [rbp-8]
	mov	QWORD PTR "corpus_zero"[rip], rax
	mov	rax, QWORD PTR [rbp-24]
	and	eax, 3
	mov	rdx, QWORD PTR "corpus_table"[0+rax*8]
	mov	rax, QWORD PTR [rbp-8]
	add	rax, rdx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE5:
	.size	"corpus_call", .-"corpus_call"
	.section	.text.corpus_string,"ax",@progbits
	.globl	"corpus_string"
	.type	"corpus_string", @function
"corpus_string":
.LFB6:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	eax, OFFSET FLAT:.LC0
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	"corpus_string", .-"corpus_string"
	.section	.text.corpus_address,"ax",@progbits
	.globl	"corpus_address"
	.type	"corpus_address", @function
"corpus_address":
.LFB7:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	eax, OFFSET FLAT:"corpus_table"
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	"corpus_address", .-"corpus_address"
	.ident	"GCC: (GNU) 16.2.1 20260810"
	.section	.note.GNU-stack,"",@progbits
