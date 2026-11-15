0000000000000000 <k_sum>:
	push   %rbp
	mov    %rsp,%rbp
	and    $0xffffffffffffffe0,%rsp
	sub    $0x120,%rsp
	mov    %rdi,0x58(%rsp)
	mov    %esi,0x54(%rsp)
	mov    %rdx,0x48(%rsp)
	vpxor  %xmm0,%xmm0,%xmm0
	vmovaps %ymm0,0x60(%rsp)
	vmovaps 0x60(%rsp),%ymm0
	vmovaps %ymm0,0x20(%rsp)
	movl   $0x0,0x1c(%rsp)
	mov    0x1c(%rsp),%eax
	add    $0x8,%eax
	cmp    0x54(%rsp),%eax
	jg     aa <k_sum+0xaa>
	vmovaps 0x20(%rsp),%ymm1
	mov    0x58(%rsp),%rax
	movslq 0x1c(%rsp),%rcx
	shl    $0x2,%rcx
	add    %rcx,%rax
	mov    %rax,0xd8(%rsp)
	mov    0xd8(%rsp),%rax
	vmovups (%rax),%ymm0
	vmovaps %ymm1,0xa0(%rsp)
	vmovaps %ymm0,0x80(%rsp)
	vmovaps 0xa0(%rsp),%ymm0
	vaddps 0x80(%rsp),%ymm0,%ymm0
	vmovaps %ymm0,0x20(%rsp)
	mov    0x1c(%rsp),%eax
	add    $0x8,%eax
	mov    %eax,0x1c(%rsp)
	jmp    3b <k_sum+0x3b>
	mov    0x48(%rsp),%rax
	vmovaps 0x20(%rsp),%ymm0
	mov    %rax,0x108(%rsp)
	vmovaps %ymm0,0xe0(%rsp)
	vmovaps 0xe0(%rsp),%ymm0
	mov    0x108(%rsp),%rax
	vmovups %ymm0,(%rax)
	mov    %rbp,%rsp
	pop    %rbp
	vzeroupper
	ret
	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)

00000000000000f0 <k_adds>:
	push   %rbp
	mov    %rsp,%rbp
	and    $0xffffffffffffffe0,%rsp
	sub    $0xc0,%rsp
	mov    %rdi,0x18(%rsp)
	mov    %rsi,0x10(%rsp)
	mov    %rdx,0x8(%rsp)
	mov    %ecx,0x4(%rsp)
	movl   $0x0,(%rsp)
	mov    (%rsp),%eax
	add    $0x20,%eax
	cmp    0x4(%rsp),%eax
	jg     1bf <k_adds+0xcf>
	mov    0x18(%rsp),%rax
	movslq (%rsp),%rcx
	add    %rcx,%rax
	mov    0x10(%rsp),%rcx
	movslq (%rsp),%rdx
	add    %rdx,%rcx
	mov    %rcx,0xa8(%rsp)
	mov    0xa8(%rsp),%rcx
	vmovdqu (%rcx),%ymm1
	mov    0x8(%rsp),%rcx
	movslq (%rsp),%rdx
	add    %rdx,%rcx
	mov    %rcx,0xa0(%rsp)
	mov    0xa0(%rsp),%rcx
	vmovdqu (%rcx),%ymm0
	vmovdqa %ymm1,0x80(%rsp)
	vmovdqa %ymm0,0x60(%rsp)
	vmovdqa 0x80(%rsp),%ymm0
	vmovdqa 0x60(%rsp),%ymm1
	vpaddusb %ymm1,%ymm0,%ymm0
	mov    %rax,0x58(%rsp)
	vmovdqa %ymm0,0x20(%rsp)
	vmovdqa 0x20(%rsp),%ymm0
	mov    0x58(%rsp),%rax
	vmovdqu %ymm0,(%rax)
	mov    (%rsp),%eax
	add    $0x20,%eax
	mov    %eax,(%rsp)
	jmp    119 <k_adds+0x29>
	mov    %rbp,%rsp
	pop    %rbp
	vzeroupper
	ret
	nopw   0x0(%rax,%rax,1)

00000000000001d0 <k_count>:
	push   %rbp
	mov    %rsp,%rbp
	and    $0xffffffffffffffc0,%rsp
	sub    $0x140,%rsp
	mov    %rdi,0xb8(%rsp)
	mov    %esi,0xb4(%rsp)
	mov    %edx,0xb0(%rsp)
	mov    0xb0(%rsp),%eax
	mov    %eax,0x124(%rsp)
	vpbroadcastd 0x124(%rsp),%zmm0
	vmovdqa64 %zmm0,0xc0(%rsp)
	vmovdqa64 0xc0(%rsp),%zmm0
	vmovdqa64 %zmm0,0x40(%rsp)
	movq   $0x0,0x38(%rsp)
	movl   $0x0,0x34(%rsp)
	mov    0x34(%rsp),%eax
	add    $0x10,%eax
	cmp    0xb4(%rsp),%eax
	jg     29d <k_count+0xcd>
	mov    0xb8(%rsp),%rax
	movslq 0x34(%rsp),%rcx
	lea    (%rax,%rcx,4),%rax
	mov    %rax,0x128(%rsp)
	mov    0x128(%rsp),%rax
	vmovdqu64 (%rax),%zmm0
	vmovdqa64 0x40(%rsp),%zmm1
	vpcmpeqd %zmm1,%zmm0,%k0
	kmovd  %k0,%eax
	movzwl %ax,%eax
	popcnt %eax,%eax
	cltq
	add    0x38(%rsp),%rax
	mov    %rax,0x38(%rsp)
	mov    0x34(%rsp),%eax
	add    $0x10,%eax
	mov    %eax,0x34(%rsp)
	jmp    234 <k_count+0x64>
	mov    0x38(%rsp),%rax
	mov    %rbp,%rsp
	pop    %rbp
	vzeroupper
	ret
	nopw   0x0(%rax,%rax,1)

00000000000002b0 <k_fma>:
	push   %rbp
	mov    %rsp,%rbp
	and    $0xffffffffffffffe0,%rsp
	sub    $0x160,%rsp
	mov    %rdi,0x58(%rsp)
	mov    %rsi,0x50(%rsp)
	mov    %edx,0x4c(%rsp)
	mov    %rcx,0x40(%rsp)
	vpxor  %xmm0,%xmm0,%xmm0
	vmovaps %ymm0,0x60(%rsp)
	vmovaps 0x60(%rsp),%ymm0
	vmovaps %ymm0,0x20(%rsp)
	movl   $0x0,0x1c(%rsp)
	mov    0x1c(%rsp),%eax
	add    $0x8,%eax
	cmp    0x4c(%rsp),%eax
	jg     3a2 <k_fma+0xf2>
	mov    0x58(%rsp),%rax
	movslq 0x1c(%rsp),%rcx
	shl    $0x2,%rcx
	add    %rcx,%rax
	mov    %rax,0x98(%rsp)
	mov    0x98(%rsp),%rax
	vmovups (%rax),%ymm2
	mov    0x50(%rsp),%rax
	movslq 0x1c(%rsp),%rcx
	shl    $0x2,%rcx
	add    %rcx,%rax
	mov    %rax,0x90(%rsp)
	mov    0x90(%rsp),%rax
	vmovups (%rax),%ymm1
	vmovaps 0x20(%rsp),%ymm0
	vmovaps %ymm2,0x120(%rsp)
	vmovaps %ymm1,0x100(%rsp)
	vmovaps %ymm0,0xe0(%rsp)
	vmovaps 0x120(%rsp),%ymm1
	vmovaps 0x100(%rsp),%ymm0
	vmovaps 0xe0(%rsp),%ymm2
	vfmadd213ps %ymm2,%ymm1,%ymm0
	vmovaps %ymm0,0x20(%rsp)
	mov    0x1c(%rsp),%eax
	add    $0x8,%eax
	mov    %eax,0x1c(%rsp)
	jmp    2f0 <k_fma+0x40>
	mov    0x40(%rsp),%rax
	vmovaps 0x20(%rsp),%ymm0
	mov    %rax,0xd8(%rsp)
	vmovaps %ymm0,0xa0(%rsp)
	vmovaps 0xa0(%rsp),%ymm0
	mov    0xd8(%rsp),%rax
	vmovups %ymm0,(%rax)
	mov    %rbp,%rsp
	pop    %rbp
	vzeroupper
	ret
