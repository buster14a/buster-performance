	.file "tests/ir-source/register-aggregates.c"
	.section .text,"ax",@progbits
	.p2align 4, 0xcc
	.type add_i4, @function
add_i4:
	sub $24, %rsp
	{load} mov %edi, %eax
	{load} mov %edx, %r8d
	{load} add %r8d, %eax
	shr $32, %rdi
	shr $32, %rdx
	{load} add %edi, %edx
	shl $32, %rdx
	{load} or %rdx, %rax
	{load} mov %esi, %edx
	{load} mov %ecx, %edi
	{load} xor %edi, %edx
	shr $32, %rsi
	shr $32, %rcx
	{load} sub %ecx, %esi
	shl $32, %rsi
	{load} or %rsi, %rdx
	lea (%rsp), %rcx
	mov %rax, (%rsp)
	mov %rdx, 8(%rsp)
	mov (%rcx), %rax
	mov 8(%rcx), %rdx
	add $24, %rsp
	ret
	.size add_i4, 77
	.p2align 4, 0xcc
	.type add_i2, @function
add_i2:
	{load} mov %edi, %eax
	{load} mov %esi, %ecx
	{load} add %ecx, %eax
	shr $32, %rdi
	shr $32, %rsi
	{load} xor %esi, %edi
	shl $32, %rdi
	{load} or %rdi, %rax
	ret
	.size add_i2, 24
	.p2align 4, 0xcc
	.type add_l2, @function
add_l2:
	sub $24, %rsp
	lea (%rdi,%rdx,1), %rax
	{load} xor %rcx, %rsi
	lea (%rsp), %rcx
	mov %rax, (%rsp)
	mov %rsi, 8(%rsp)
	mov (%rcx), %rax
	mov 8(%rcx), %rdx
	add $24, %rsp
	ret
	.size add_l2, 36
	.p2align 4, 0xcc
	.type bump_packed, @function
bump_packed:
	movsbl %dil, %eax
	{load} add %esi, %eax
	movzbl %al, %eax
	and $-256, %rdi
	{load} or %rax, %rdi
	{load} mov %rdi, %rax
	shr $16, %rax
	movswl %ax, %eax
	imul %esi, %eax
	movzwl %ax, %eax
	movabs $0xffffffff0000ffff, %rcx
	{load} and %rcx, %rdi
	shl $16, %rax
	{load} or %rax, %rdi
	{load} mov %rdi, %rax
	shr $32, %rax
	{load} sub %esi, %eax
	mov $-1, %ecx
	{load} and %rcx, %rdi
	shl $32, %rax
	{load} or %rax, %rdi
	{load} mov %rdi, %rax
	ret
	.size bump_packed, 83
	.p2align 4, 0xcc
	.type rotate_i3, @function
rotate_i3:
	sub $24, %rsp
	{load} mov %rdi, %rax
	shr $32, %rax
	{load} mov %esi, %ecx
	shl $32, %rcx
	{load} or %rcx, %rax
	{load} mov %edi, %ecx
	lea (%rsp), %rdx
	mov %rax, (%rsp)
	mov %rcx, 8(%rsp)
	mov 8(%rdx), %r11d
	mov %r11d, -8(%rsp)
	mov (%rdx), %rax
	mov -8(%rsp), %rdx
	add $24, %rsp
	ret
	.size rotate_i3, 57
	.p2align 4, 0xcc
	.type mix_long_char, @function
mix_long_char:
	sub $24, %rsp
	movzbl %dl, %eax
	movsbq %sil, %rcx
	{load} add %rdi, %rcx
	and $-256, %rsi
	{load} or %rax, %rsi
	lea (%rsp), %rax
	mov %rcx, (%rsp)
	mov %rsi, 8(%rsp)
	mov 8(%rax), %rdx
	mov (%rax), %rax
	add $24, %rsp
	ret
	.size mix_long_char, 49
	.p2align 4, 0xcc
	.type scale_f2, @function
scale_f2:
	{store} movq %xmm0, %rax
	{load} mov %eax, %ecx
	{load} movd %ecx, %xmm0
	mulss %xmm1, %xmm0
	{store} movd %xmm0, %ecx
	shr $32, %rax
	{load} movd %eax, %xmm0
	addss %xmm1, %xmm0
	{store} movd %xmm0, %eax
	shl $32, %rax
	{load} or %rax, %rcx
	{load} movq %rcx, %xmm0
	ret
	.size scale_f2, 48
	.p2align 4, 0xcc
	.type add_f4, @function
add_f4:
	sub $24, %rsp
	{store} movq %xmm0, %rax
	{store} movq %xmm1, %rcx
	{store} movq %xmm2, %rdx
	{store} movq %xmm3, %rsi
	{load} mov %eax, %edi
	{load} movd %edi, %xmm0
	{load} mov %edx, %edi
	{load} movd %edi, %xmm1
	addss %xmm1, %xmm0
	{store} movd %xmm0, %edi
	shr $32, %rax
	{load} movd %eax, %xmm0
	shr $32, %rdx
	{load} movd %edx, %xmm1
	subss %xmm1, %xmm0
	{store} movd %xmm0, %edx
	shl $32, %rdx
	{load} or %rdx, %rdi
	{load} mov %ecx, %edx
	{load} movd %edx, %xmm0
	{load} movd %esi, %xmm1
	mulss %xmm1, %xmm0
	{store} movd %xmm0, %esi
	shr $32, %rcx
	shl $32, %rcx
	{load} or %rcx, %rsi
	lea (%rsp), %rcx
	mov %rdi, (%rsp)
	mov %rsi, 8(%rsp)
	movsd (%rcx), %xmm0
	movsd 8(%rcx), %xmm1
	add $24, %rsp
	ret
	.size add_f4, 131
	.p2align 4, 0xcc
	.type swap_d2, @function
swap_d2:
	sub $24, %rsp
	{store} movq %xmm1, %rax
	{store} movq %xmm0, %rcx
	lea (%rsp), %rdx
	mov %rax, (%rsp)
	mov %rcx, 8(%rsp)
	movsd (%rdx), %xmm0
	movsd 8(%rdx), %xmm1
	add $24, %rsp
	ret
	.size swap_d2, 41
	.p2align 4, 0xcc
	.type int_float, @function
int_float:
	{load} mov %edi, %eax
	lea (%rax,%rax,2), %eax
	shr $32, %rdi
	{load} movd %edi, %xmm0
	mov $1056964608, %r11d
	{load} movd %r11d, %xmm1
	mulss %xmm1, %xmm0
	{store} movd %xmm0, %ecx
	shl $32, %rcx
	{load} or %rcx, %rax
	ret
	.size int_float, 40
	.p2align 4, 0xcc
	.type double_int, @function
double_int:
	sub $24, %rsp
	{load} mov %edi, %eax
	xorps %xmm1, %xmm1
	cvtsi2sd %eax, %xmm1
	addsd %xmm1, %xmm0
	{store} movq %xmm0, %rax
	lea 1(%rdi), %ecx
	lea (%rsp), %rdx
	mov %rax, (%rsp)
	mov %rcx, 8(%rsp)
	movsd (%rdx), %xmm0
	mov 8(%rdx), %rax
	add $24, %rsp
	ret
	.size double_int, 51
	.p2align 4, 0xcc
	.type int_double, @function
int_double:
	sub $24, %rsp
	sub $1, %edi
	movabs $0x4000000000000000, %r11
	{load} movq %r11, %xmm1
	mulsd %xmm1, %xmm0
	{store} movq %xmm0, %rax
	lea (%rsp), %rcx
	mov %rdi, (%rsp)
	mov %rax, 8(%rsp)
	mov (%rcx), %rax
	movsd 8(%rcx), %xmm0
	add $24, %rsp
	ret
	.size int_double, 57
	.p2align 4, 0xcc
	.type nest, @function
nest:
	sub $24, %rsp
	{load} mov %esi, %eax
	{load} mov %edi, %ecx
	{load} add %esi, %ecx
	movabs $0xffffffff00000000, %rdx
	{load} and %rdx, %rdi
	{load} or %rcx, %rdi
	{load} mov %rdi, %rcx
	shr $32, %rcx
	movabs $0xffffffff00000000, %rdx
	{load} and %rdx, %rax
	{load} or %rcx, %rax
	lea (%rsp), %rcx
	mov %rdi, (%rsp)
	mov %rax, 8(%rsp)
	mov 8(%rcx), %r11d
	mov %r11d, -8(%rsp)
	mov (%rcx), %rax
	mov -8(%rsp), %rdx
	add $24, %rsp
	ret
	.size nest, 84
	.p2align 4, 0xcc
	.type reverse_bytes, @function
reverse_bytes:
	sub $40, %rsp
	lea 15(%rsp), %rax
	mov %rdi, 3(%rsp)
	mov %esi, 11(%rsp)
	xor %ecx, %ecx
	jmp .Lbuster.14.11
.Lbuster.14.6:
	mov $11, %edx
	{load} sub %rcx, %rdx
	movzbl 3(%rsp,%rdx,1), %edx
	mov %dl, 15(%rsp,%rcx,1)
	add $1, %ecx
.Lbuster.14.11:
	cmp $12, %ecx
	jl .Lbuster.14.6
	mov 8(%rax), %r11d
	mov %r11d, -8(%rsp)
	mov -8(%rsp), %rdx
	mov (%rax), %rax
	add $40, %rsp
	ret
	.size reverse_bytes, 69
	.p2align 4, 0xcc
	.type shorts, @function
shorts:
	sub $24, %rsp
	movzwl %si, %eax
	movswl %ax, %ecx
	{load} mov %rdi, %rdx
	shr $16, %rdx
	movswl %dx, %edx
	{load} add %edx, %ecx
	movzwl %cx, %ecx
	and $-65536, %rdi
	{load} or %rcx, %rdi
	{load} mov %rdi, %rcx
	shr $48, %rcx
	movswl %cx, %ecx
	neg %ecx
	movzwl %cx, %ecx
	movabs $0xffffffffffff, %rdx
	{load} and %rdx, %rdi
	shl $48, %rcx
	{load} or %rcx, %rdi
	lea (%rsp), %rcx
	mov %rdi, (%rsp)
	mov %rax, 8(%rsp)
	movzwl 8(%rcx), %r11d
	mov %r11w, -8(%rsp)
	mov (%rcx), %rax
	mov -8(%rsp), %rdx
	add $24, %rsp
	ret
	.size shorts, 107
	.p2align 4, 0xcc
	.type one, @function
one:
	movzbl %dil, %eax
	movsbl %al, %ecx
	shl %ecx
	add $1, %ecx
	movzbl %cl, %ecx
	and $-256, %rax
	{load} or %rcx, %rax
	ret
	.size one, 25
	.p2align 4, 0xcc
	.type advance, @function
advance:
	sub $24, %rsp
	{load} add %rdx, %rdi
	{load} sub %rdx, %rsi
	lea (%rsp), %rax
	mov %rdi, (%rsp)
	mov %rsi, 8(%rsp)
	mov 8(%rax), %rdx
	mov (%rax), %rax
	add $24, %rsp
	ret
	.size advance, 35
	.p2align 4, 0xcc
	.type punned, @function
punned:
	{load} mov %rdi, %rax
	shr $32, %rax
	lea 1(%rdi), %ecx
	shl $32, %rcx
	{load} or %rcx, %rax
	ret
	.size punned, 18
	.p2align 4, 0xcc
	.type union_float, @function
union_float:
	{load} mov %edi, %eax
	{load} movd %eax, %xmm0
	shr $32, %rdi
	{load} movd %edi, %xmm1
	addss %xmm1, %xmm0
	ret
	.size union_float, 19
	.p2align 4, 0xcc
	.type first_only, @function
first_only:
	{load} mov %esi, %eax
	ret
	.size first_only, 3
	.p2align 4, 0xcc
	.type touch, @function
touch:
	mov (%rdi), %eax
	add $100, %eax
	mov %eax, (%rdi)
	ret
	.size touch, 8
	.p2align 4, 0xcc
	.type escaped, @function
escaped:
	push %rbx
	sub $16, %rsp
	lea (%rsp), %rbx
	mov %rdi, (%rsp)
	lea 4(%rbx), %rdi
	call touch@PLT
	{load} mov %rbx, %rax
	mov (%rax), %rax
	add $16, %rsp
	pop %rbx
	ret
	.size escaped, 34
	.p2align 4, 0xcc
	.type choose, @function
choose:
	sub $40, %rsp
	lea 8(%rsp), %rax
	lea 16(%rsp), %rcx
	mov %rsi, 8(%rsp)
	cmp $1, %edx
	jle .Lbuster.23.11
	lea (%rsp), %rax
	mov %rdi, (%rsp)
	mov (%rax), %rax
	add $40, %rsp
	ret
.Lbuster.23.11:
	movq $0, 16(%rsp)
	{load} mov %edi, %esi
	imul 8(%rsp), %esi
	mov %esi, 16(%rsp)
	shr $32, %rdi
	imul 12(%rsp), %edi
	mov %edi, 20(%rsp)
	test %edx, %edx
	cmovne %rax, %rcx
	{load} mov %rcx, %rax
	mov (%rax), %rax
	add $40, %rsp
	ret
	.size choose, 90
	.p2align 4, 0xcc
	.type loop_sum, @function
loop_sum:
	sub $24, %rsp
	xor %eax, %eax
	xor %ecx, %ecx
	xor %r8d, %r8d
	jmp .Lbuster.24.11
.Lbuster.24.5:
	{load} mov %rdi, %r9
	imul %r8, %r9
	{load} add %r9, %rax
	lea (%rsi,%r8,1), %r9
	{load} xor %r9, %rcx
	add $1, %r8d
.Lbuster.24.11:
	{load} cmp %edx, %r8d
	jl .Lbuster.24.5
	lea (%rsp), %rdx
	mov %rax, (%rsp)
	mov %rcx, 8(%rsp)
	mov (%rdx), %rax
	mov 8(%rdx), %rdx
	add $24, %rsp
	ret
	.size loop_sum, 64
	.p2align 4, 0xcc
	.type from_pointer, @function
from_pointer:
	sub $24, %rsp
	mov (%rdi), %rax
	mov 8(%rdi), %ecx
	{load} mov %rax, %rdx
	shr $32, %rdx
	add $1, %edx
	mov $-1, %esi
	{load} and %rsi, %rax
	shl $32, %rdx
	{load} or %rdx, %rax
	lea (%rsp), %rdx
	mov %rax, (%rsp)
	mov %rcx, 8(%rsp)
	mov 8(%rdx), %r11d
	mov %r11d, -8(%rsp)
	mov (%rdx), %rax
	mov -8(%rsp), %rdx
	add $24, %rsp
	ret
	.size from_pointer, 70
	.p2align 4, 0xcc
	.type sum_args, @function
sum_args:
	{store} movq %xmm0, %rax
	{load} mov %edi, %r10d
	shr $32, %rdi
	{load} add %r10d, %edi
	movslq %edi, %rdi
	{load} add %rdi, %rsi
	{load} add %rsi, %rdx
	{load} add %rdx, %rcx
	{load} mov %eax, %edx
	{load} movd %edx, %xmm0
	mov $1092616192, %r11d
	{load} movd %r11d, %xmm1
	mulss %xmm1, %xmm0
	cvttss2si %xmm0, %rdx
	{load} add %rdx, %rcx
	shr $32, %rax
	{load} movd %eax, %xmm0
	mov $1092616192, %r11d
	{load} movd %r11d, %xmm1
	mulss %xmm1, %xmm0
	cvttss2si %xmm0, %rax
	{load} add %rcx, %rax
	movslq %r8d, %rcx
	{load} add %rcx, %rax
	shr $32, %r8
	movslq %r8d, %rcx
	{load} add %rcx, %rax
	movslq %r9d, %rcx
	{load} add %rcx, %rax
	ret
	.size sum_args, 110
	.p2align 4, 0xcc
	.type swap_s2, @function
swap_s2:
	{load} mov %edi, %eax
	{load} mov %rax, %rcx
	shr $16, %rcx
	movswl %ax, %eax
	add $1, %eax
	movzwl %ax, %eax
	shl $16, %rax
	{load} or %rax, %rcx
	{load} mov %rcx, %rax
	ret
	.size swap_s2, 29
	.p2align 4, 0xcc
	.type callers, @function
callers:
	push %rbx
	push %rbp
	push %r12
	push %r13
	push %r14
	push %r15
	sub $104, %rsp
	mov $3, %r12d
	mov $4, %r13d
	movabs $0x400000003f800000, %r14
	movb $0, 96(%rsp)
	movb $1, 96(%rsp)
	mov $-393211, %r15d
	xor %ebp, %ebp
	mov %r15, 16(%rsp)
	movabs $0x200000001, %rbx
	movabs $0x3fe0000000000000, %r11
	mov %r11, 24(%rsp)
	movabs $0x3ff8000000000000, %r11
	mov %r11, 32(%rsp)
	movabs $0x3f80000000000001, %r11
	mov %r11, 40(%rsp)
	xor %r15d, %r15d
	{disp32} jmp .Lbuster.28.140
.Lbuster.28.24:
	mov %r15, 48(%rsp)
	mov 16(%rsp), %r15
	movabs $0x100000000, %rsi
	{load} or %rbp, %rsi
	mov %rdi, (%rsp)
	{load} mov %rbx, %rdi
	call add_i2@PLT
	{load} mov %rax, %rbx
	{load} mov %rbp, %rdx
	mov $2, %ecx
	{load} mov %r12, %rdi
	{load} mov %r13, %rsi
	call add_l2@PLT
	mov %rax, 64(%rsp)
	mov %rdx, 72(%rsp)
	mov 64(%rsp), %r12
	mov 72(%rsp), %r13
	mov $1056964608, %r11d
	{load} movd %r11d, %xmm1
	{load} movq %r14, %xmm0
	call scale_f2@PLT
	{store} movq %xmm0, %r14
	lea 96(%rsp), %r8
	{load} mov %r8, %rax
	movzbl (%rax), %r11d
	mov %r11b, -8(%rsp)
	mov -8(%rsp), %rdi
	call one@PLT
	movzbl %al, %eax
	mov %al, 96(%rsp)
	{load} mov %r15d, %eax
	{load} mov %rax, %rdi
	call swap_s2@PLT
	movabs $0xffffffff00000000, %rcx
	{load} and %r15, %rcx
	{load} mov %eax, %eax
	{load} mov %rcx, %r15
	{load} or %rax, %r15
	mov %r12, 56(%rsp)
	mov 24(%rsp), %r12
	{load} movq %r12, %xmm0
	mov 32(%rsp), %r12
	{load} movq %r12, %xmm1
	call swap_d2@PLT
	movsd %xmm0, 80(%rsp)
	movsd %xmm1, 88(%rsp)
	mov 80(%rsp), %r12
	mov %r12, 24(%rsp)
	mov 88(%rsp), %r12
	mov %r12, 32(%rsp)
	mov 40(%rsp), %r12
	{load} mov %r12d, %eax
	mov (%rsp), %rdi
	{load} mov %eax, %r11d
	mov $274877907, %eax
	imul %r11d
	sar $6, %edx
	{load} mov %edx, %eax
	shr $31, %eax
	{load} add %eax, %edx
	imul $1000, %edx, %edx
	neg %edx
	{load} add %r11d, %edx
	{load} mov %edx, %eax
	{load} mov %r12, %rcx
	shr $32, %rcx
	shl $32, %rcx
	{load} or %rcx, %rax
	{load} mov %rax, %rdi
	call int_float@PLT
	{load} mov %rax, %r12
	{load} mov %ebp, %eax
	and $1, %eax
	mov (%rsp), %rdi
	test %eax, %eax
	jne .Lbuster.28.103
	mov %r12, 40(%rsp)
	mov 48(%rsp), %r12
	jmp .Lbuster.28.125
.Lbuster.28.103:
	{load} mov %ebp, %esi
	neg %esi
	shl $32, %rsi
	{load} or %rbp, %rsi
	mov $1431655766, %eax
	imul %ebp
	{load} mov %edx, %eax
	shr $31, %eax
	{load} add %eax, %edx
	imul $3, %edx, %edx
	neg %edx
	{load} add %ebp, %edx
	{load} mov %rbx, %rdi
	call choose@PLT
	{load} mov %eax, %ecx
	shr $32, %rax
	{load} sub %eax, %ecx
	movslq %ecx, %rax
	mov %r12, 40(%rsp)
	mov 48(%rsp), %r12
	{load} add %rax, %r12
	mov (%rsp), %rdi
.Lbuster.28.125:
	movabs $0x200000000, %rax
	{load} or %rbp, %rax
	lea (%rbp,%rbp,2), %esi
	movabs $0x400000000, %rcx
	{load} or %rcx, %rsi
	mov %rdi, (%rsp)
	{load} mov %rax, %rdi
	call first_only@PLT
	movslq %eax, %rax
	{load} add %rax, %r12
	add $1, %ebp
	mov (%rsp), %rdi
	mov %r15, 16(%rsp)
	{load} mov %r12, %r15
	mov 56(%rsp), %r12
.Lbuster.28.140:
	{load} cmp %edi, %ebp
	{disp32} jl .Lbuster.28.24
	movslq %ebx, %rax
	{load} add %r15, %rax
	{load} mov %rbx, %rcx
	shr $32, %rcx
	movslq %ecx, %rcx
	{load} add %rcx, %rax
	{load} add %r12, %rax
	{load} add %r13, %rax
	{load} mov %r14d, %ecx
	{load} movd %ecx, %xmm1
	mov $1148846080, %r11d
	{load} movd %r11d, %xmm0
	mulss %xmm0, %xmm1
	cvttss2si %xmm1, %rcx
	{load} add %rcx, %rax
	{load} mov %r14, %rcx
	shr $32, %rcx
	{load} movd %ecx, %xmm1
	mov $1148846080, %r11d
	{load} movd %r11d, %xmm0
	mulss %xmm0, %xmm1
	cvttss2si %xmm1, %rcx
	{load} add %rcx, %rax
	movsbq 96(%rsp), %rcx
	{load} add %rcx, %rax
	mov 16(%rsp), %r15
	movswq %r15w, %rcx
	{load} add %rcx, %rax
	{load} mov %r15, %rcx
	shr $16, %rcx
	movswq %cx, %rcx
	{load} add %rcx, %rax
	mov 24(%rsp), %r12
	{load} movq %r12, %xmm1
	cvttsd2si %xmm1, %rcx
	{load} add %rcx, %rax
	mov 32(%rsp), %r12
	{load} movq %r12, %xmm1
	cvttsd2si %xmm1, %rcx
	{load} add %rcx, %rax
	mov 40(%rsp), %r12
	movslq %r12d, %rcx
	{load} add %rcx, %rax
	{load} mov %r12, %rcx
	shr $32, %rcx
	{load} movd %ecx, %xmm1
	cvttss2si %xmm1, %rcx
	{load} add %rcx, %rax
	add $104, %rsp
	pop %r15
	pop %r14
	pop %r13
	pop %r12
	pop %rbp
	pop %rbx
	ret
	.size callers, 798
	.p2align 4, 0xcc
	.type small_args, @function
small_args:
	push %rbx
	push %rbp
	push %r12
	push %r13
	sub $8, %rsp
	mov $-393211, %ebx
	xor %ebp, %ebp
	xor %r12d, %r12d
	{disp32} jmp .Lbuster.29.40
.Lbuster.29.9:
	{load} mov %ebx, %eax
	mov %rdi, (%rsp)
	{load} mov %rax, %rdi
	call swap_s2@PLT
	movabs $0xffffffff00000000, %rcx
	{load} and %rbx, %rcx
	{load} mov %eax, %eax
	{load} mov %rcx, %rbx
	{load} or %rax, %rbx
	movabs $0xffffffff00000000, %rax
	{load} and %r13, %rax
	movabs $0x200000000, %r8
	{load} or %r12, %r8
	movabs $0xffffffff00000000, %rcx
	{load} and %rcx, %rax
	{load} mov %rax, %r13
	or $3, %r13
	{load} mov %r12, %rax
	shl $32, %rax
	or $1, %rax
	mov $3, %esi
	mov $4, %edx
	mov $5, %ecx
	movabs $0x3f3333333f000000, %r11
	{load} movq %r11, %xmm0
	{load} mov %r13d, %r9d
	{load} mov %rax, %rdi
	call sum_args@PLT
	{load} add %rax, %rbp
	add $1, %r12d
	mov (%rsp), %rdi
.Lbuster.29.40:
	{load} cmp %edi, %r12d
	{disp32} jl .Lbuster.29.9
	movswq %bx, %rax
	{load} add %rbp, %rax
	{load} mov %rbx, %rcx
	shr $16, %rcx
	movswq %cx, %rcx
	{load} add %rcx, %rax
	add $8, %rsp
	pop %r13
	pop %r12
	pop %rbp
	pop %rbx
	ret
	.size small_args, 210
	.p2align 4, 0xcc
	.type set_on_one_path, @function
set_on_one_path:
	sub $24, %rsp
	xor %eax, %eax
	movabs $0x200000001, %rcx
	test %rdi, %rdi
	je .Lbuster.30.12
	mov (%rdi), %eax
	movabs $0x200000000, %rcx
	{load} or %rcx, %rax
	{load} mov %esi, %ecx
	{load} mov %rcx, %r11
	{load} mov %rax, %rcx
	{load} mov %r11, %rax
.Lbuster.30.12:
	lea (%rsp), %rdx
	mov %rcx, (%rsp)
	mov %rax, 8(%rsp)
	mov 8(%rdx), %r11d
	mov %r11d, -8(%rsp)
	mov (%rdx), %rax
	mov -8(%rsp), %rdx
	add $24, %rsp
	ret
	.size set_on_one_path, 82
	.p2align 4, 0xcc
	.type set_on_one_path_dirty, @function
set_on_one_path_dirty:
	push %rbx
	sub $32, %rsp
	lea (%rsp), %rbx
	call set_on_one_path@PLT
	mov %rax, (%rsp)
	mov %edx, 8(%rsp)
	{load} mov %rbx, %rax
	mov 8(%rax), %r11d
	mov %r11d, -8(%rsp)
	mov -8(%rsp), %rdx
	mov (%rax), %rax
	add $32, %rsp
	pop %rbx
	ret
	.size set_on_one_path_dirty, 48
	.p2align 4, 0xcc
	.globl main
	.type main, @function
main:
	push %rbx
	push %rbp
	push %r12
	push %r13
	push %r14
	push %r15
	sub $328, %rsp
	lea 288(%rsp), %rbp
	lea 16(%rsp), %r12
	lea 164(%rsp), %r13
	xor %eax, %eax
	xor %ecx, %ecx
	movabs $0x200000001, %r8
	mov vz(%rip), %edx
	add $4, %edx
	shl $32, %rdx
	{load} mov %rdx, %r15
	or $3, %r15
	xor %ebx, %ebx
	{load} mov %r13, %r14
	{load} mov %r12, %r13
	{load} mov %rbp, %r12
	lea 268(%rsp), %rbp
	jmp .Lbuster.32.35
.Lbuster.32.24:
	{load} mov %rcx, %rdi
	{load} mov %rax, %rsi
	{load} mov %r8, %rdx
	{load} mov %r15, %rcx
	call add_i4@PLT
	mov %rax, 236(%rsp)
	mov %rdx, 244(%rsp)
	mov 236(%rsp), %rcx
	mov 244(%rsp), %rax
	add $1, %ebx
	movabs $0x200000001, %r8
.Lbuster.32.35:
	cmp $1000, %ebx
	jl .Lbuster.32.24
	lea .Lbuster_string_7039(%rip), %rdi
	{load} mov %ecx, %esi
	shr $32, %rcx
	{load} mov %eax, %r9d
	shr $32, %rax
	{load} mov %rcx, %rdx
	{load} mov %r9, %rcx
	{load} mov %rax, %r8
	{load} xor %eax, %eax
	call printf@PLT
	xor %eax, %eax
	xor %ebx, %ebx
	lea 160(%rsp), %r15
	jmp .Lbuster.32.58
.Lbuster.32.51:
	mov vz(%rip), %ecx
	lea (%rcx,%rbx,2), %esi
	shl $32, %rsi
	{load} or %rbx, %rsi
	{load} mov %rax, %rdi
	call add_i2@PLT
	add $1, %ebx
.Lbuster.32.58:
	cmp $1000, %ebx
	jl .Lbuster.32.51
	lea .Lbuster_string_7105(%rip), %rdi
	{load} mov %eax, %esi
	shr $32, %rax
	{load} mov %rax, %rdx
	{load} xor %eax, %eax
	call printf@PLT
	movabs $0x10000000000, %rdi
	mov $-5, %rsi
	mov $7, %edx
	movabs $0x200000000, %rcx
	call add_l2@PLT
	mov %rax, 48(%rsp)
	mov %rdx, 56(%rsp)
	mov 48(%rsp), %rsi
	mov 56(%rsp), %rdx
	lea .Lbuster_string_7147(%rip), %rdi
	{load} xor %eax, %eax
	call printf@PLT
	movabs $0x11170fed4000a, %rdi
	mov vz(%rip), %eax
	lea 3(%rax), %esi
	call bump_packed@PLT
	{load} mov %rax, %rcx
	lea .Lbuster_string_7182(%rip), %rdi
	movsbl %cl, %esi
	{load} mov %rcx, %rax
	shr $16, %rax
	movswl %ax, %edx
	shr $32, %rcx
	{load} xor %eax, %eax
	call printf@PLT
	movabs $0x200000001, %rdi
	mov $3, %esi
	call rotate_i3@PLT
	mov %rax, 176(%rsp)
	mov %edx, 184(%rsp)
	mov 176(%rsp), %rdx
	mov 184(%rsp), %ecx
	lea .Lbuster_string_7216(%rip), %rdi
	{load} mov %edx, %esi
	shr $32, %rdx
	{load} xor %eax, %eax
	call printf@PLT
	movabs $0x4000000000000, %rdi
	mov $9, %esi
	mov $122, %edx
	call mix_long_char@PLT
	mov %rax, 64(%rsp)
	mov %rdx, 72(%rsp)
	mov 64(%rsp), %rsi
	mov 72(%rsp), %rax
	lea .Lbuster_string_7252(%rip), %rdi
	movsbl %al, %edx
	{load} xor %eax, %eax
	call printf@PLT
	mov $1082130432, %r11d
	{load} movd %r11d, %xmm1
	movabs $0xc01000003fc00000, %r11
	{load} movq %r11, %xmm0
	call scale_f2@PLT
	{store} movq %xmm0, %rax
	lea .Lbuster_string_7283(%rip), %rdi
	{load} mov %eax, %ecx
	{load} movd %ecx, %xmm0
	cvtss2sd %xmm0, %xmm0
	shr $32, %rax
	{load} movd %eax, %xmm1
	cvtss2sd %xmm1, %xmm1
	mov $2, %eax
	call printf@PLT
	movabs $0x400000003f800000, %r11
	{load} movq %r11, %xmm0
	movabs $0x4080000040400000, %r11
	{load} movq %r11, %xmm1
	movabs $0x3e8000003f000000, %r11
	{load} movq %r11, %xmm2
	movabs $0x4100000040000000, %r11
	{load} movq %r11, %xmm3
	call add_f4@PLT
	movsd %xmm0, 252(%rsp)
	movsd %xmm1, 260(%rsp)
	mov 252(%rsp), %rax
	mov 260(%rsp), %rcx
	lea .Lbuster_string_7334(%rip), %rdi
	{load} mov %eax, %edx
	{load} movd %edx, %xmm3
	xorps %xmm0, %xmm0
	cvtss2sd %xmm3, %xmm0
	shr $32, %rax
	{load} movd %eax, %xmm2
	xorps %xmm1, %xmm1
	cvtss2sd %xmm2, %xmm1
	{load} mov %ecx, %eax
	{load} movd %eax, %xmm2
	cvtss2sd %xmm2, %xmm2
	shr $32, %rcx
	{load} movd %ecx, %xmm3
	cvtss2sd %xmm3, %xmm3
	mov $4, %eax
	call printf@PLT
	movabs $0x400c000000000000, %r11
	{load} movq %r11, %xmm0
	movabs $0xfe37e43c8800759c, %r11
	{load} movq %r11, %xmm1
	call swap_d2@PLT
	movsd %xmm0, 80(%rsp)
	movsd %xmm1, 88(%rsp)
	mov 80(%rsp), %rax
	mov 88(%rsp), %rcx
	lea .Lbuster_string_7383(%rip), %rdi
	{load} movq %rax, %xmm0
	{load} movq %rcx, %xmm1
	mov $2, %eax
	call printf@PLT
	movabs $0x40400000fffffff9, %rdi
	call int_float@PLT
	lea .Lbuster_string_7412(%rip), %rdi
	{load} mov %eax, %esi
	shr $32, %rax
	{load} movd %eax, %xmm1
	xorps %xmm0, %xmm0
	cvtss2sd %xmm1, %xmm0
	mov $1, %eax
	call printf@PLT
	mov $41, %edi
	movabs $0x3fd0000000000000, %r11
	{load} movq %r11, %xmm0
	call double_int@PLT
	movsd %xmm0, 96(%rsp)
	mov %rax, 104(%rsp)
	mov 96(%rsp), %rax
	mov 104(%rsp), %rsi
	lea .Lbuster_string_7443(%rip), %rdi
	{load} movq %rax, %xmm0
	mov $1, %eax
	call printf@PLT
	mov $5, %edi
	movabs $0xbfe0000000000000, %r11
	{load} movq %r11, %xmm0
	call int_double@PLT
	mov %rax, 112(%rsp)
	movsd %xmm0, 120(%rsp)
	mov 112(%rsp), %rsi
	mov 120(%rsp), %rax
	lea .Lbuster_string_7472(%rip), %rdi
	{load} movq %rax, %xmm0
	mov $1, %eax
	call printf@PLT
	movabs $0x200000001, %rdi
	mov $3, %esi
	call nest@PLT
	mov %rax, 188(%rsp)
	mov %edx, 196(%rsp)
	mov 188(%rsp), %rdx
	mov 196(%rsp), %ecx
	lea .Lbuster_string_7504(%rip), %rdi
	{load} mov %edx, %esi
	shr $32, %rdx
	{load} xor %eax, %eax
	call printf@PLT
	xor %eax, %eax
	jmp .Lbuster.32.227
.Lbuster.32.222:
	imul $17, %eax, %ecx
	mov vz(%rip), %edx
	{load} add %edx, %ecx
	mov %cl, 289(%rsp,%rax,1)
	add $1, %eax
.Lbuster.32.227:
	cmp $12, %eax
	jl .Lbuster.32.222
	mov 289(%rsp), %rdi
	mov 297(%rsp), %esi
	call reverse_bytes@PLT
	mov %rax, 313(%rsp)
	mov %edx, 321(%rsp)
	mov 313(%rsp), %rax
	mov %rax, 301(%rsp)
	mov 321(%rsp), %eax
	mov %eax, 309(%rsp)
	xor %ebx, %ebx
	jmp .Lbuster.32.249
.Lbuster.32.240:
	lea .Lbuster_string_7586(%rip), %rdi
	movzbl 301(%rsp,%rbx,1), %esi
	mov $10, %eax
	mov $32, %edx
	cmp $11, %ebx
	cmove %eax, %edx
	{load} xor %eax, %eax
	call printf@PLT
	add $1, %ebx
.Lbuster.32.249:
	cmp $12, %ebx
	jl .Lbuster.32.240
	movq $0, 268(%rsp)
	movw $0, 276(%rsp)
	movw $1, 268(%rsp)
	movw $2, 270(%rsp)
	movw $3, 272(%rsp)
	movw $4, 274(%rsp)
	movw $5, 276(%rsp)
	{load} mov %rbp, %rax
	mov (%rax), %r11
	mov %r11, -8(%rsp)
	movzwl 8(%rax), %r11d
	mov %r11w, -16(%rsp)
	mov -8(%rsp), %rdi
	mov -16(%rsp), %rsi
	call shorts@PLT
	mov %rax, 278(%rsp)
	mov %dx, 286(%rsp)
	mov 278(%rsp), %rax
	lea .Lbuster_string_7630(%rip), %rdi
	movswl %ax, %esi
	{load} mov %rax, %rcx
	shr $16, %rcx
	movswl %cx, %edx
	{load} mov %rax, %rcx
	shr $32, %rcx
	movswl %cx, %ecx
	shr $48, %rax
	movswl %ax, %r8d
	movswl 286(%rsp), %r9d
	{load} xor %eax, %eax
	call printf@PLT
	movb $0, 288(%rsp)
	movb $21, 288(%rsp)
	{load} mov %r12, %rax
	movzbl (%rax), %r11d
	mov %r11b, -8(%rsp)
	mov -8(%rsp), %rdi
	call one@PLT
	movzbl %al, %eax
	lea .Lbuster_string_7683(%rip), %rdi
	movsbl %al, %esi
	{load} xor %eax, %eax
	call printf@PLT
	mov .Lbuster_string_7700(%rip), %rax
	mov %rax, 16(%rsp)
	mov .Lbuster_string_7700+8(%rip), %rax
	mov %rax, 24(%rsp)
	{load} mov %r13, %rax
	mov $15, %esi
	mov $4, %edx
	{load} mov %rax, %rdi
	call advance@PLT
	mov %rax, 128(%rsp)
	mov %rdx, 136(%rsp)
	mov 128(%rsp), %rsi
	mov 136(%rsp), %rdx
	lea .Lbuster_string_7724(%rip), %rdi
	{load} xor %eax, %eax
	call printf@PLT
	movabs $0xfffffffc00000003, %rdi
	call punned@PLT
	{load} mov %rax, %rsi
	lea .Lbuster_string_7764(%rip), %rdi
	{load} mov %esi, %edx
	{load} mov %rsi, %rcx
	shr $32, %rcx
	{load} xor %eax, %eax
	call printf@PLT
	movabs $0x402000003fa00000, %rdi
	lea .Lbuster_string_7801(%rip), %rbx
	call union_float@PLT
	cvtss2sd %xmm0, %xmm0
	{load} mov %rbx, %rdi
	mov $1, %eax
	call printf@PLT
	lea .Lbuster_string_7814(%rip), %rbx
	movabs $0x200000001, %rdi
	movabs $0x400000021, %rsi
	call first_only@PLT
	{load} mov %eax, %esi
	{load} mov %rbx, %rdi
	{load} xor %eax, %eax
	call printf@PLT
	movabs $0x600000005, %rdi
	call escaped@PLT
	{load} mov %rax, %rdx
	lea .Lbuster_string_7850(%rip), %rdi
	{load} mov %edx, %esi
	shr $32, %rdx
	{load} xor %eax, %eax
	call printf@PLT
	xor %ebx, %ebx
	jmp .Lbuster.32.356
.Lbuster.32.344:
	movabs $0x300000002, %rdi
	movabs $0x500000004, %rsi
	{load} mov %rbx, %rdx
	call choose@PLT
	{load} mov %rax, %rcx
	lea .Lbuster_string_7904(%rip), %rdi
	{load} mov %ecx, %edx
	shr $32, %rcx
	{load} mov %rbx, %rsi
	{load} xor %eax, %eax
	call printf@PLT
	add $1, %ebx
.Lbuster.32.356:
	cmp $3, %ebx
	jl .Lbuster.32.344
	mov $3, %edi
	mov $85, %esi
	mov $20, %edx
	call loop_sum@PLT
	mov %rax, 144(%rsp)
	mov %rdx, 152(%rsp)
	mov 144(%rsp), %rsi
	mov 152(%rsp), %rdx
	lea .Lbuster_string_7937(%rip), %rdi
	{load} xor %eax, %eax
	call printf@PLT
	movq $0, 164(%rsp)
	movl $0, 172(%rsp)
	movl $7, 164(%rsp)
	movl $8, 168(%rsp)
	movl $9, 172(%rsp)
	{load} mov %r14, %rax
	{load} mov %rax, %rdi
	call from_pointer@PLT
	mov %rax, 200(%rsp)
	mov %edx, 208(%rsp)
	mov 200(%rsp), %rdx
	mov 208(%rsp), %ecx
	lea .Lbuster_string_7971(%rip), %rdi
	{load} mov %edx, %esi
	shr $32, %rdx
	{load} xor %eax, %eax
	call printf@PLT
	lea .Lbuster_string_7988(%rip), %rbx
	movabs $0x200000001, %rdi
	mov $3, %esi
	mov $4, %edx
	mov $5, %ecx
	movabs $0x700000006, %r8
	movabs $0x3f3333333f000000, %r11
	{load} movq %r11, %xmm0
	mov $8, %r9d
	call sum_args@PLT
	{load} mov %rax, %rsi
	{load} mov %rbx, %rdi
	{load} xor %eax, %eax
	call printf@PLT
	lea .Lbuster_string_8036(%rip), %rbx
	mov $10, %edi
	call callers@PLT
	{load} mov %rax, %rsi
	mov vz(%rip), %eax
	lea 37(%rax), %edi
	mov %rsi, 32(%rsp)
	call callers@PLT
	{load} mov %rax, %rdx
	mov 32(%rsp), %rsi
	{load} mov %rbx, %rdi
	{load} xor %eax, %eax
	call printf@PLT
	lea .Lbuster_string_8053(%rip), %rbx
	mov vz(%rip), %eax
	lea 9(%rax), %edi
	call small_args@PLT
	{load} mov %rax, %rsi
	{load} mov %rbx, %rdi
	{load} xor %eax, %eax
	call printf@PLT
	mov vz(%rip), %eax
	add $5, %eax
	mov %eax, 160(%rsp)
	xor %edi, %edi
	mov vz(%rip), %eax
	lea 7(%rax), %esi
	mov vz(%rip), %eax
	add $23130, %eax
	movslq %eax, %rdx
	mov vz(%rip), %eax
	add $15420, %eax
	movslq %eax, %rcx
	call set_on_one_path_dirty@PLT
	mov %rax, 212(%rsp)
	mov %edx, 220(%rsp)
	mov 212(%rsp), %rbx
	mov 220(%rsp), %ebp
	{load} mov %r15, %rax
	mov vz(%rip), %ecx
	lea 7(%rcx), %esi
	mov vz(%rip), %ecx
	add $23130, %ecx
	movslq %ecx, %rdx
	mov vz(%rip), %ecx
	add $15420, %ecx
	movslq %ecx, %rcx
	{load} mov %rax, %rdi
	call set_on_one_path_dirty@PLT
	mov %rax, 224(%rsp)
	mov %edx, 232(%rsp)
	mov 224(%rsp), %r9
	mov 232(%rsp), %eax
	lea .Lbuster_string_8116(%rip), %rdi
	{load} mov %ebx, %esi
	{load} mov %rbx, %rdx
	shr $32, %rdx
	{load} mov %r9d, %r8d
	shr $32, %r9
	mov %rax, (%rsp)
	{load} mov %rbp, %rcx
	{load} xor %eax, %eax
	call printf@PLT
	xor %eax, %eax
	add $328, %rsp
	pop %r15
	pop %r14
	pop %r13
	pop %r12
	pop %rbp
	pop %rbx
	ret
	.size main, 2403
	.section .eh_frame,"a",@unwind
	.p2align 3
	.byte 0x24,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x01,0x7a,0x52,0x00,0x01,0x78,0x10,0x01
	.byte 0x1b,0x0c,0x07,0x08,0x90,0x01,0x08,0x03,0x08,0x06,0x08,0x0c,0x08,0x0d,0x08,0x0e
	.byte 0x08,0x0f,0x00,0x00,0x00,0x00,0x00,0x00,0x14,0x00,0x00,0x00,0x2c,0x00,0x00,0x00
	.long add_i4-.
	.byte 0x4d,0x00,0x00,0x00,0x00,0x44,0x0e,0x20,0x02,0x48,0x0e,0x08,0x14,0x00,0x00,0x00
	.byte 0x44,0x00,0x00,0x00
	.long add_i2-.
	.byte 0x18,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x14,0x00,0x00,0x00
	.byte 0x5c,0x00,0x00,0x00
	.long add_l2-.
	.byte 0x24,0x00,0x00,0x00,0x00,0x44,0x0e,0x20,0x5f,0x0e,0x08,0x00,0x14,0x00,0x00,0x00
	.byte 0x74,0x00,0x00,0x00
	.long bump_packed-.
	.byte 0x53,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x14,0x00,0x00,0x00
	.byte 0x8c,0x00,0x00,0x00
	.long rotate_i3-.
	.byte 0x39,0x00,0x00,0x00,0x00,0x44,0x0e,0x20,0x74,0x0e,0x08,0x00,0x14,0x00,0x00,0x00
	.byte 0xa4,0x00,0x00,0x00
	.long mix_long_char-.
	.byte 0x31,0x00,0x00,0x00,0x00,0x44,0x0e,0x20,0x6c,0x0e,0x08,0x00,0x14,0x00,0x00,0x00
	.byte 0xbc,0x00,0x00,0x00
	.long scale_f2-.
	.byte 0x30,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x14,0x00,0x00,0x00
	.byte 0xd4,0x00,0x00,0x00
	.long add_f4-.
	.byte 0x83,0x00,0x00,0x00,0x00,0x44,0x0e,0x20,0x02,0x7e,0x0e,0x08,0x14,0x00,0x00,0x00
	.byte 0xec,0x00,0x00,0x00
	.long swap_d2-.
	.byte 0x29,0x00,0x00,0x00,0x00,0x44,0x0e,0x20,0x64,0x0e,0x08,0x00,0x14,0x00,0x00,0x00
	.byte 0x04,0x01,0x00,0x00
	.long int_float-.
	.byte 0x28,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x14,0x00,0x00,0x00
	.byte 0x1c,0x01,0x00,0x00
	.long double_int-.
	.byte 0x33,0x00,0x00,0x00,0x00,0x44,0x0e,0x20,0x6e,0x0e,0x08,0x00,0x14,0x00,0x00,0x00
	.byte 0x34,0x01,0x00,0x00
	.long int_double-.
	.byte 0x39,0x00,0x00,0x00,0x00,0x44,0x0e,0x20,0x74,0x0e,0x08,0x00,0x14,0x00,0x00,0x00
	.byte 0x4c,0x01,0x00,0x00
	.long nest-.
	.byte 0x54,0x00,0x00,0x00,0x00,0x44,0x0e,0x20,0x02,0x4f,0x0e,0x08,0x14,0x00,0x00,0x00
	.byte 0x64,0x01,0x00,0x00
	.long reverse_bytes-.
	.byte 0x45,0x00,0x00,0x00,0x00,0x44,0x0e,0x30,0x02,0x40,0x0e,0x08,0x14,0x00,0x00,0x00
	.byte 0x7c,0x01,0x00,0x00
	.long shorts-.
	.byte 0x6b,0x00,0x00,0x00,0x00,0x44,0x0e,0x20,0x02,0x66,0x0e,0x08,0x14,0x00,0x00,0x00
	.byte 0x94,0x01,0x00,0x00
	.long one-.
	.byte 0x19,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x14,0x00,0x00,0x00
	.byte 0xac,0x01,0x00,0x00
	.long advance-.
	.byte 0x23,0x00,0x00,0x00,0x00,0x44,0x0e,0x20,0x5e,0x0e,0x08,0x00,0x14,0x00,0x00,0x00
	.byte 0xc4,0x01,0x00,0x00
	.long punned-.
	.byte 0x12,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x14,0x00,0x00,0x00
	.byte 0xdc,0x01,0x00,0x00
	.long union_float-.
	.byte 0x13,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x14,0x00,0x00,0x00
	.byte 0xf4,0x01,0x00,0x00
	.long first_only-.
	.byte 0x03,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x14,0x00,0x00,0x00
	.byte 0x0c,0x02,0x00,0x00
	.long touch-.
	.byte 0x08,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x1c,0x00,0x00,0x00
	.byte 0x24,0x02,0x00,0x00
	.long escaped-.
	.byte 0x22,0x00,0x00,0x00,0x00,0x41,0x0e,0x10,0x83,0x02,0x44,0x0e,0x20,0x5b,0x0e,0x10
	.byte 0x41,0x0e,0x08,0xc3,0x1c,0x00,0x00,0x00,0x44,0x02,0x00,0x00
	.long choose-.
	.byte 0x5a,0x00,0x00,0x00,0x00,0x44,0x0e,0x30,0x0a,0x63,0x0e,0x08,0x41,0x0b,0x71,0x0e
	.byte 0x08,0x00,0x00,0x00,0x14,0x00,0x00,0x00,0x64,0x02,0x00,0x00
	.long loop_sum-.
	.byte 0x40,0x00,0x00,0x00,0x00,0x44,0x0e,0x20,0x7b,0x0e,0x08,0x00,0x14,0x00,0x00,0x00
	.byte 0x7c,0x02,0x00,0x00
	.long from_pointer-.
	.byte 0x46,0x00,0x00,0x00,0x00,0x44,0x0e,0x20,0x02,0x41,0x0e,0x08,0x14,0x00,0x00,0x00
	.byte 0x94,0x02,0x00,0x00
	.long sum_args-.
	.byte 0x6e,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x14,0x00,0x00,0x00
	.byte 0xac,0x02,0x00,0x00
	.long swap_s2-.
	.byte 0x1d,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x4c,0x00,0x00,0x00
	.byte 0xc4,0x02,0x00,0x00
	.long callers-.
	.byte 0x1e,0x03,0x00,0x00,0x00,0x41,0x0e,0x10,0x83,0x02,0x41,0x0e,0x18,0x86,0x03,0x42
	.byte 0x0e,0x20,0x8c,0x04,0x42,0x0e,0x28,0x8d,0x05,0x42,0x0e,0x30,0x8e,0x06,0x42,0x0e
	.byte 0x38,0x8f,0x07,0x44,0x0e,0xa0,0x01,0x03,0x05,0x03,0x0e,0x38,0x42,0x0e,0x30,0xcf
	.byte 0x42,0x0e,0x28,0xce,0x42,0x0e,0x20,0xcd,0x42,0x0e,0x18,0xcc,0x41,0x0e,0x10,0xc6
	.byte 0x41,0x0e,0x08,0xc3,0x3c,0x00,0x00,0x00,0x14,0x03,0x00,0x00
	.long small_args-.
	.byte 0xd2,0x00,0x00,0x00,0x00,0x41,0x0e,0x10,0x83,0x02,0x41,0x0e,0x18,0x86,0x03,0x42
	.byte 0x0e,0x20,0x8c,0x04,0x42,0x0e,0x28,0x8d,0x05,0x44,0x0e,0x30,0x02,0xc1,0x0e,0x28
	.byte 0x42,0x0e,0x20,0xcd,0x42,0x0e,0x18,0xcc,0x41,0x0e,0x10,0xc6,0x41,0x0e,0x08,0xc3
	.byte 0x00,0x00,0x00,0x00,0x14,0x00,0x00,0x00,0x54,0x03,0x00,0x00
	.long set_on_one_path-.
	.byte 0x52,0x00,0x00,0x00,0x00,0x44,0x0e,0x20,0x02,0x4d,0x0e,0x08,0x1c,0x00,0x00,0x00
	.byte 0x6c,0x03,0x00,0x00
	.long set_on_one_path_dirty-.
	.byte 0x30,0x00,0x00,0x00,0x00,0x41,0x0e,0x10,0x83,0x02,0x44,0x0e,0x30,0x69,0x0e,0x10
	.byte 0x41,0x0e,0x08,0xc3,0x4c,0x00,0x00,0x00,0x8c,0x03,0x00,0x00
	.long main-.
	.byte 0x63,0x09,0x00,0x00,0x00,0x41,0x0e,0x10,0x83,0x02,0x41,0x0e,0x18,0x86,0x03,0x42
	.byte 0x0e,0x20,0x8c,0x04,0x42,0x0e,0x28,0x8d,0x05,0x42,0x0e,0x30,0x8e,0x06,0x42,0x0e
	.byte 0x38,0x8f,0x07,0x47,0x0e,0x80,0x03,0x03,0x47,0x09,0x0e,0x38,0x42,0x0e,0x30,0xcf
	.byte 0x42,0x0e,0x28,0xce,0x42,0x0e,0x20,0xcd,0x42,0x0e,0x18,0xcc,0x41,0x0e,0x10,0xc6
	.byte 0x41,0x0e,0x08,0xc3
	.section .bss,"aw",@nobits
	.p2align 2
	.globl vz
	.type vz, @object
vz:
	.zero 4
	.size vz, 4
	.section .rodata.str1.1,"aMS",@progbits,1
	.type .Lbuster_string_7039, @object
.Lbuster_string_7039:
	.string "i4 %d %d %d %d\012"
	.size .Lbuster_string_7039, 16
	.type .Lbuster_string_7105, @object
.Lbuster_string_7105:
	.string "i2 %d %d\012"
	.size .Lbuster_string_7105, 10
	.type .Lbuster_string_7147, @object
.Lbuster_string_7147:
	.string "l2 %ld %ld\012"
	.size .Lbuster_string_7147, 12
	.type .Lbuster_string_7182, @object
.Lbuster_string_7182:
	.string "packed %d %d %d\012"
	.size .Lbuster_string_7182, 17
	.type .Lbuster_string_7216, @object
.Lbuster_string_7216:
	.string "i3 %d %d %d\012"
	.size .Lbuster_string_7216, 13
	.type .Lbuster_string_7252, @object
.Lbuster_string_7252:
	.string "lc %ld %d\012"
	.size .Lbuster_string_7252, 11
	.type .Lbuster_string_7283, @object
.Lbuster_string_7283:
	.string "f2 %g %g\012"
	.size .Lbuster_string_7283, 10
	.type .Lbuster_string_7334, @object
.Lbuster_string_7334:
	.string "f4 %g %g %g %g\012"
	.size .Lbuster_string_7334, 16
	.type .Lbuster_string_7383, @object
.Lbuster_string_7383:
	.string "d2 %g %g\012"
	.size .Lbuster_string_7383, 10
	.type .Lbuster_string_7412, @object
.Lbuster_string_7412:
	.string "if %d %g\012"
	.size .Lbuster_string_7412, 10
	.type .Lbuster_string_7443, @object
.Lbuster_string_7443:
	.string "di %g %d\012"
	.size .Lbuster_string_7443, 10
	.type .Lbuster_string_7472, @object
.Lbuster_string_7472:
	.string "id %d %g\012"
	.size .Lbuster_string_7472, 10
	.type .Lbuster_string_7504, @object
.Lbuster_string_7504:
	.string "nested %d %d %d\012"
	.size .Lbuster_string_7504, 17
	.type .Lbuster_string_7586, @object
.Lbuster_string_7586:
	.string "%d%c"
	.size .Lbuster_string_7586, 5
	.type .Lbuster_string_7630, @object
.Lbuster_string_7630:
	.string "shorts %d %d %d %d %d\012"
	.size .Lbuster_string_7630, 23
	.type .Lbuster_string_7683, @object
.Lbuster_string_7683:
	.string "one %d\012"
	.size .Lbuster_string_7683, 8
	.type .Lbuster_string_7700, @object
.Lbuster_string_7700:
	.string "abcdefghijklmno"
	.size .Lbuster_string_7700, 16
	.type .Lbuster_string_7724, @object
.Lbuster_string_7724:
	.string "slice %s %ld\012"
	.size .Lbuster_string_7724, 14
	.type .Lbuster_string_7764, @object
.Lbuster_string_7764:
	.string "union %ld %d %d\012"
	.size .Lbuster_string_7764, 17
	.type .Lbuster_string_7801, @object
.Lbuster_string_7801:
	.string "union float %g\012"
	.size .Lbuster_string_7801, 16
	.type .Lbuster_string_7814, @object
.Lbuster_string_7814:
	.string "first %d\012"
	.size .Lbuster_string_7814, 10
	.type .Lbuster_string_7850, @object
.Lbuster_string_7850:
	.string "escaped %d %d\012"
	.size .Lbuster_string_7850, 15
	.type .Lbuster_string_7904, @object
.Lbuster_string_7904:
	.string "choose %d %d %d\012"
	.size .Lbuster_string_7904, 17
	.type .Lbuster_string_7937, @object
.Lbuster_string_7937:
	.string "loop %ld %ld\012"
	.size .Lbuster_string_7937, 14
	.type .Lbuster_string_7971, @object
.Lbuster_string_7971:
	.string "pointer %d %d %d\012"
	.size .Lbuster_string_7971, 18
	.type .Lbuster_string_7988, @object
.Lbuster_string_7988:
	.string "sum %ld\012"
	.size .Lbuster_string_7988, 9
	.type .Lbuster_string_8036, @object
.Lbuster_string_8036:
	.string "callers %ld %ld\012"
	.size .Lbuster_string_8036, 17
	.type .Lbuster_string_8053, @object
.Lbuster_string_8053:
	.string "small %ld\012"
	.size .Lbuster_string_8053, 11
	.type .Lbuster_string_8116, @object
.Lbuster_string_8116:
	.string "one path %d %d %d %d %d %d\012"
	.size .Lbuster_string_8116, 28
	.section .note.GNU-stack,"",@progbits
