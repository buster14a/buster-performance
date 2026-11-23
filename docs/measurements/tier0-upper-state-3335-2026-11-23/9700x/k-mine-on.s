	.file "kernel.c"
	.section .text,"ax",@progbits
	.p2align 4, 0xcc
	.globl sum16
	.type sum16, @function
sum16:
	push %rbp
	mov %rsp, %rbp
	sub $1664, %rsp
	and $-64, %rsp
	lea 960(%rsp), %rax
	{load} mov %rdi, %rcx
	vmovdqu64 (%rcx), %zmm16
	vmovdqu64 %zmm16, 64(%rsp)
	vmovdqu64 64(%rsp), %zmm16
	vmovdqu64 %zmm16, (%rax)
	vmovdqu64 960(%rsp), %zmm16
	vmovdqu64 %zmm16, (%rsp)
	vmovdqu64 960(%rsp), %zmm16
	vmovdqu64 %zmm16, 64(%rsp)
	vmovdqu64 (%rsp), %zmm0
	vmovdqu64 64(%rsp), %zmm1
	vaddps %zmm1, %zmm0, %zmm0
	vmovdqu64 %zmm0, (%rsp)
	vmovdqu64 (%rsp), %zmm16
	vmovdqu64 %zmm16, 1600(%rsp)
	mov $-2147483648, %eax
	{load} vmovd %eax, %xmm0
	vmovdqu64 1600(%rsp), %zmm16
	vmovdqu64 %zmm16, (%rsp)
	vmovdqu64 (%rsp), %zmm1
	vextractf64x4 $1, %zmm1, %ymm2
	{evex} vaddps %ymm2, %ymm1, %ymm1
	{evex} vextractf32x4 $1, %ymm1, %xmm2
	{evex} vaddps %xmm2, %xmm1, %xmm1
	vmovdqu64 %zmm1, (%rsp)
	{evex} vmovdqu64 (%rsp), %xmm2
	{evex} vpermilpd $1, %xmm2, %xmm3
	{evex} vaddps %xmm3, %xmm2, %xmm2
	{load} {evex} vmovshdup %xmm2, %xmm3
	{evex} vaddss %xmm3, %xmm2, %xmm2
	{evex} vaddss %xmm2, %xmm0, %xmm0
	vzeroupper
	mov %rbp, %rsp
	pop %rbp
	ret
	.size sum16, 238
	.p2align 4, 0xcc
	.globl saxpy
	.type saxpy, @function
saxpy:
	{load} vmovaps %xmm0, %xmm3
	{load} mov %rdx, %r9
	xor %r8d, %r8d
.Lbuster.2.3:
	{load} cmp %r9d, %r8d
	jge .Lbuster.2.23
	{load} mov %rdi, %rax
	movslq %r8d, %rcx
	lea (%rax,%rcx,4), %rax
	{load} vmovaps %xmm3, %xmm0
	{load} mov %rsi, %rcx
	movslq %r8d, %rdx
	vmovss (%rcx,%rdx,4), %xmm1
	{load} mov %rdi, %rcx
	movslq %r8d, %rdx
	vmovss (%rcx,%rdx,4), %xmm2
	{evex} vfmadd213ss %xmm2, %xmm0, %xmm1
	{load} {evex} vmovaps %xmm1, %xmm0
	vmovss %xmm0, (%rax)
	{load} mov %r8d, %eax
	{load} mov %rax, %rcx
	inc %ecx
	mov %ecx, %r8d
	jmp .Lbuster.2.3
.Lbuster.2.23:
	ret
	.size saxpy, 81
	.p2align 4, 0xcc
	.globl add16
	.type add16, @function
add16:
	push %rbp
	mov %rsp, %rbp
	sub $1664, %rsp
	and $-64, %rsp
	{load} mov %rdi, %rax
	{load} mov %rsi, %rcx
	vmovdqu64 (%rcx), %zmm16
	vmovdqu64 %zmm16, 64(%rsp)
	{load} mov %rsi, %rdx
	add $64, %rdx
	vmovdqu64 (%rdx), %zmm16
	vmovdqu64 %zmm16, 128(%rsp)
	vmovdqu64 64(%rsp), %zmm0
	vmovdqu64 128(%rsp), %zmm1
	vaddps %zmm1, %zmm0, %zmm0
	vmovdqu64 %zmm0, 64(%rsp)
	vmovdqu64 64(%rsp), %zmm16
	vmovdqu64 %zmm16, (%rax)
	vmovdqu64 %zmm16, (%rsp)
	vzeroupper
	mov %rbp, %rsp
	pop %rbp
	ret
	.size add16, 115
	.section .eh_frame,"a",@unwind
	.p2align 3
	.byte 0x24,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x01,0x7a,0x52,0x00,0x01,0x78,0x10,0x01
	.byte 0x1b,0x0c,0x07,0x08,0x90,0x01,0x08,0x03,0x08,0x06,0x08,0x0c,0x08,0x0d,0x08,0x0e
	.byte 0x08,0x0f,0x00,0x00,0x00,0x00,0x00,0x00,0x1c,0x00,0x00,0x00,0x2c,0x00,0x00,0x00
	.long sum16-.
	.byte 0xee,0x00,0x00,0x00,0x00,0x41,0x0e,0x10,0x86,0x02,0x43,0x0d,0x06,0x02,0xe9,0x0c
	.byte 0x07,0x08,0xc6,0x00,0x14,0x00,0x00,0x00,0x4c,0x00,0x00,0x00
	.long saxpy-.
	.byte 0x51,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x1c,0x00,0x00,0x00
	.byte 0x64,0x00,0x00,0x00
	.long add16-.
	.byte 0x73,0x00,0x00,0x00,0x00,0x41,0x0e,0x10,0x86,0x02,0x43,0x0d,0x06,0x02,0x6e,0x0c
	.byte 0x07,0x08,0xc6,0x00
	.section .note.GNU-stack,"",@progbits
