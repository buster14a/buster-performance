	.file "src/mix.c"
	.section .text,"ax",@progbits
	.p2align 4, 0xcc
	.globl dot16
	.type dot16, @function
dot16:
	vmovdqu32 (%rdi), %zmm0
	vmovdqu32 (%rsi), %zmm1
	vmulps %zmm1, %zmm0, %zmm1
	vmovdqu32 64(%rdi), %zmm0
	vmovdqu32 64(%rsi), %zmm2
	{load} vmovdqa64 %zmm2, %zmm17
	vfmadd213ps %zmm1, %zmm0, %zmm17
	{load} vmovdqu64 %zmm17, %zmm2
	vmovdqu32 128(%rdi), %zmm0
	vmovdqu32 128(%rsi), %zmm1
	{load} vmovdqa64 %zmm1, %zmm17
	vfmadd213ps %zmm2, %zmm0, %zmm17
	{load} vmovdqu64 %zmm17, %zmm1
	vmovdqu32 192(%rdi), %zmm0
	vmovdqu32 192(%rsi), %zmm2
	{load} vmovdqa64 %zmm2, %zmm17
	vfmadd213ps %zmm1, %zmm0, %zmm17
	{load} vmovdqu64 %zmm17, %zmm2
	mov $-2147483648, %r11d
	{load} movd %r11d, %xmm0
	vextractf64x4 $1, %zmm2, %ymm17
	vaddps %ymm17, %ymm2, %ymm2
	vextractf32x4 $1, %ymm2, %xmm17
	vaddps %xmm17, %xmm2, %xmm2
	{load} {evex} vmovdqa64 %xmm2, %xmm2
	{load} vmovdqa64 %xmm0, %xmm19
	vpermilpd $1, %xmm2, %xmm18
	vaddps %xmm18, %xmm2, %xmm2
	{load} vmovshdup %xmm2, %xmm18
	vaddss %xmm18, %xmm2, %xmm2
	vaddss %xmm2, %xmm19, %xmm19
	{load} vmovdqa64 %xmm19, %xmm2
	{load} movaps %xmm2, %xmm0
	ret
	.size dot16, 204
	.p2align 4, 0xcc
	.globl saxpy
	.type saxpy, @function
saxpy:
	xor %eax, %eax
	jmp .Lbuster.2.6
.Lbuster.2.2:
	movss (%rsi,%rax,4), %xmm1
	vfmadd213ss (%rdi,%rax,4), %xmm0, %xmm1
	movss %xmm1, (%rdi,%rax,4)
	add $1, %eax
.Lbuster.2.6:
	{load} cmp %edx, %eax
	jl .Lbuster.2.2
	ret
	.size saxpy, 28
	.p2align 4, 0xcc
	.globl scale_sum
	.type scale_sum, @function
scale_sum:
	xorps %xmm0, %xmm0
	xor %eax, %eax
	jmp .Lbuster.3.9
.Lbuster.3.3:
	movss (%rdi,%rax,4), %xmm1
	cvtss2sd %xmm1, %xmm1
	movabs $0x3fe0000000000000, %r11
	{load} movq %r11, %xmm2
	vfmadd231sd %xmm2, %xmm1, %xmm0
	add $1, %eax
.Lbuster.3.9:
	{load} cmp %esi, %eax
	jl .Lbuster.3.3
	ret
	.size scale_sum, 44
	.p2align 4, 0xcc
	.globl main
	.type main, @function
main:
	push %rbx
	push %rbp
	push %r12
	push %r13
	sub $24, %rsp
	cmp $1, %edi
	jle .Lbuster.4.11
	mov 8(%rsi), %rdi
	call atol@PLT
	{load} mov %rax, %rbx
	jmp .Lbuster.4.12
.Lbuster.4.11:
	mov $100000, %ebx
.Lbuster.4.12:
	mov $64, %edi
	mov $8192, %esi
	call aligned_alloc@PLT
	{load} mov %rax, %rbp
	mov $64, %edi
	mov $8192, %esi
	call aligned_alloc@PLT
	{load} mov %rax, %r12
	mov $1, %r13d
	test %rbp, %rbp
	{disp32} je .Lbuster.4.80
	test %r12, %r12
	{disp32} je .Lbuster.4.80
	xor %eax, %eax
	jmp .Lbuster.4.41
.Lbuster.4.27:
	{load} mov %eax, %ecx
	and $7, %ecx
	xorps %xmm0, %xmm0
	cvtsi2ss %ecx, %xmm0
	movss %xmm0, (%rbp,%rax,4)
	{load} mov %eax, %ecx
	and $3, %ecx
	xorps %xmm0, %xmm0
	cvtsi2ss %ecx, %xmm0
	mov $1048576000, %r11d
	{load} movd %r11d, %xmm1
	mulss %xmm1, %xmm0
	movss %xmm0, (%r12,%rax,4)
	add $1, %eax
.Lbuster.4.41:
	cmp $2048, %eax
	jl .Lbuster.4.27
	xorps %xmm0, %xmm0
	xor %r13d, %r13d
	jmp .Lbuster.4.72
.Lbuster.4.46:
	{load} mov %r13, %rax
	and $63, %rax
	lea (%rbp,%rax,4), %rsi
	movsd %xmm0, (%rsp)
	{load} mov %r12, %rdi
	call dot16@PLT
	{load} movaps %xmm0, %xmm1
	movsd (%rsp), %xmm0
	mov $813694976, %r11d
	{load} movd %r11d, %xmm2
	mulss %xmm2, %xmm1
	mov $2048, %edx
	movsd %xmm0, (%rsp)
	{load} mov %rbp, %rdi
	{load} mov %r12, %rsi
	{load} movaps %xmm1, %xmm0
	call saxpy@PLT
	movsd (%rsp), %xmm0
	mov $2048, %esi
	movsd %xmm0, (%rsp)
	{load} mov %rbp, %rdi
	call scale_sum@PLT
	{load} movaps %xmm0, %xmm1
	movsd (%rsp), %xmm0
	addsd %xmm1, %xmm0
	add $1, %r13
.Lbuster.4.72:
	{load} cmp %rbx, %r13
	jl .Lbuster.4.46
	lea .Lbuster_string_306744(%rip), %rdi
	{load} mov %rbx, %rsi
	mov $1, %eax
	call printf@PLT
	xor %ebx, %ebx
	{load} mov %rbx, %r13
.Lbuster.4.80:
	{load} mov %rbp, %rdi
	call free@PLT
	{load} mov %r12, %rdi
	call free@PLT
	{load} mov %r13d, %eax
	add $24, %rsp
	pop %r13
	pop %r12
	pop %rbp
	pop %rbx
	ret
	.size main, 338
	.section .eh_frame,"a",@unwind
	.p2align 3
	.byte 0x24,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x01,0x7a,0x52,0x00,0x01,0x78,0x10,0x01
	.byte 0x1b,0x0c,0x07,0x08,0x90,0x01,0x08,0x03,0x08,0x06,0x08,0x0c,0x08,0x0d,0x08,0x0e
	.byte 0x08,0x0f,0x00,0x00,0x00,0x00,0x00,0x00,0x14,0x00,0x00,0x00,0x2c,0x00,0x00,0x00
	.long dot16-.
	.byte 0xcc,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x14,0x00,0x00,0x00
	.byte 0x44,0x00,0x00,0x00
	.long saxpy-.
	.byte 0x1c,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x14,0x00,0x00,0x00
	.byte 0x5c,0x00,0x00,0x00
	.long scale_sum-.
	.byte 0x2c,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x3c,0x00,0x00,0x00
	.byte 0x74,0x00,0x00,0x00
	.long main-.
	.byte 0x52,0x01,0x00,0x00,0x00,0x41,0x0e,0x10,0x83,0x02,0x41,0x0e,0x18,0x86,0x03,0x42
	.byte 0x0e,0x20,0x8c,0x04,0x42,0x0e,0x28,0x8d,0x05,0x44,0x0e,0x40,0x03,0x41,0x01,0x0e
	.byte 0x28,0x42,0x0e,0x20,0xcd,0x42,0x0e,0x18,0xcc,0x41,0x0e,0x10,0xc6,0x41,0x0e,0x08
	.byte 0xc3,0x00,0x00,0x00
	.section .rodata.str1.1,"aMS",@progbits,1
	.type .Lbuster_string_306744, @object
.Lbuster_string_306744:
	.string "mix: %ld rounds, checksum %.6e\012"
	.size .Lbuster_string_306744, 32
	.section .note.GNU-stack,"",@progbits
