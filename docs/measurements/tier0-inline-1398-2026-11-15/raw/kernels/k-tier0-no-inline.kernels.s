00000000000005c0 <k_sum>:
	push   %rbp
	mov    %rsp,%rbp
	push   %rbx
	sub    $0x4c0,%rsp
	and    $0xffffffffffffffe0,%rsp
	mov    %rdi,0x3c8(%rsp)
	mov    %esi,0x3d0(%rsp)
	mov    %rdx,0x3d8(%rsp)
	lea    0x3e0(%rsp),%rax
	movq   $0x0,(%rax)
	lea    0x3e0(%rsp),%rax
	add    $0x8,%rax
	movq   $0x0,(%rax)
	lea    0x3e0(%rsp),%rax
	add    $0x10,%rax
	movq   $0x0,(%rax)
	lea    0x3e0(%rsp),%rax
	add    $0x18,%rax
	movq   $0x0,(%rax)
	lea    0x3e0(%rsp),%rax
	mov    %rax,(%rsp)
	call   640 <k_sum+0x80>
	vmovdqu %ymm0,0x400(%rsp)
	mov    (%rsp),%rax
	vmovdqu64 0x400(%rsp),%ymm16
	vmovdqu64 %zmm16,0x48(%rsp)
	vmovdqu64 0x48(%rsp),%zmm16
	vmovdqu64 %ymm16,(%rax)
	xor    %ebx,%ebx
	mov    %ebx,%eax
	add    $0x8,%eax
	cmp    0x3d0(%rsp),%eax
	setle  %al
	movzbl %al,%eax
	test   %eax,%eax
	je     759 <k_sum+0x199>
	vmovdqu64 0x3e0(%rsp),%ymm16
	vmovdqu64 %zmm16,0x8(%rsp)
	vmovdqu64 0x8(%rsp),%zmm16
	vmovdqu64 %ymm16,0x460(%rsp)
	lea    0x460(%rsp),%rax
	mov    0x3c8(%rsp),%rcx
	movslq %ebx,%rdx
	lea    (%rcx,%rdx,4),%rcx
	mov    %rax,(%rsp)
	mov    %rcx,%rdi
	call   6d6 <k_sum+0x116>
	vmovdqu %ymm0,0x480(%rsp)
	mov    (%rsp),%rax
	vmovdqu64 0x480(%rsp),%ymm16
	vmovdqu64 %zmm16,0x48(%rsp)
	vmovdqu64 0x48(%rsp),%zmm16
	vmovdqu64 %ymm16,0x440(%rsp)
	lea    0x440(%rsp),%rcx
	vmovdqu (%rax),%ymm0
	vmovdqu (%rcx),%ymm1
	call   71e <k_sum+0x15e>
	vmovdqu %ymm0,0x420(%rsp)
	vmovdqu64 0x420(%rsp),%ymm16
	vmovdqu64 %zmm16,0x8(%rsp)
	vmovdqu64 0x8(%rsp),%zmm16
	vmovdqu64 %ymm16,0x3e0(%rsp)
	mov    %ebx,%eax
	add    $0x8,%eax
	mov    %eax,%ebx
	jmp    673 <k_sum+0xb3>
	mov    0x3d8(%rsp),%rax
	vmovdqu64 0x3e0(%rsp),%ymm16
	vmovdqu64 %zmm16,0x48(%rsp)
	vmovdqu64 0x48(%rsp),%zmm16
	vmovdqu64 %ymm16,0x4a0(%rsp)
	lea    0x4a0(%rsp),%rcx
	vmovdqu (%rcx),%ymm0
	mov    %rax,%rdi
	call   79b <k_sum+0x1db>
	lea    -0x8(%rbp),%rsp
	pop    %rbx
	pop    %rbp
	ret
	int3
	int3
	int3
	int3
	int3
	int3
	int3
	int3
	int3
	int3
	int3
	int3
	int3
	int3

00000000000007b0 <k_adds>:
	push   %rbx
	sub    $0x4b0,%rsp
	mov    %rdi,0x3d0(%rsp)
	mov    %rsi,0x3d8(%rsp)
	mov    %rdx,0x3e0(%rsp)
	mov    %ecx,0x3e8(%rsp)
	xor    %ebx,%ebx
	mov    %ebx,%eax
	add    $0x20,%eax
	cmp    0x3e8(%rsp),%eax
	setle  %al
	movzbl %al,%eax
	test   %eax,%eax
	je     92e <k_adds+0x17e>
	mov    0x3d0(%rsp),%rax
	movslq %ebx,%rcx
	lea    (%rax,%rcx,1),%rax
	mov    0x3d8(%rsp),%rcx
	movslq %ebx,%rdx
	lea    (%rcx,%rdx,1),%rcx
	mov    %rax,(%rsp)
	mov    %rcx,%rdi
	call   81d <k_adds+0x6d>
	vmovdqu %ymm0,0x470(%rsp)
	mov    (%rsp),%rax
	vmovdqu64 0x470(%rsp),%ymm16
	vmovdqu64 %zmm16,0x50(%rsp)
	vmovdqu64 0x50(%rsp),%zmm16
	vmovdqu64 %ymm16,0x450(%rsp)
	lea    0x450(%rsp),%rcx
	mov    0x3e0(%rsp),%rdx
	movslq %ebx,%rsi
	lea    (%rdx,%rsi,1),%rdx
	mov    %rax,(%rsp)
	mov    %rcx,0x8(%rsp)
	mov    %rdx,%rdi
	call   87e <k_adds+0xce>
	vmovdqu %ymm0,0x490(%rsp)
	mov    (%rsp),%rax
	mov    0x8(%rsp),%rcx
	vmovdqu64 0x490(%rsp),%ymm16
	vmovdqu64 %zmm16,0x90(%rsp)
	vmovdqu64 0x90(%rsp),%zmm16
	vmovdqu64 %ymm16,0x430(%rsp)
	lea    0x430(%rsp),%rdx
	mov    %rax,(%rsp)
	vmovdqu (%rcx),%ymm0
	vmovdqu (%rdx),%ymm1
	call   8d5 <k_adds+0x125>
	vmovdqu %ymm0,0x410(%rsp)
	mov    (%rsp),%rax
	vmovdqu64 0x410(%rsp),%ymm16
	vmovdqu64 %zmm16,0x50(%rsp)
	vmovdqu64 0x50(%rsp),%zmm16
	vmovdqu64 %ymm16,0x3f0(%rsp)
	lea    0x3f0(%rsp),%rcx
	vmovdqu (%rcx),%ymm0
	mov    %rax,%rdi
	call   922 <k_adds+0x172>
	mov    %ebx,%eax
	add    $0x20,%eax
	mov    %eax,%ebx
	jmp    7d9 <k_adds+0x29>
	add    $0x4b0,%rsp
	pop    %rbx
	ret
	int3
	int3
	int3
	int3
	int3
	int3
	int3
	int3
	int3

0000000000000940 <k_count>:
	push   %rbp
	mov    %rsp,%rbp
	push   %rbx
	push   %r12
	sub    $0x500,%rsp
	and    $0xffffffffffffffc0,%rsp
	mov    %rdi,0x400(%rsp)
	mov    %esi,0x408(%rsp)
	mov    %edx,0x410(%rsp)
	lea    0x440(%rsp),%rax
	movq   $0x0,(%rax)
	lea    0x440(%rsp),%rax
	add    $0x8,%rax
	movq   $0x0,(%rax)
	lea    0x440(%rsp),%rax
	add    $0x10,%rax
	movq   $0x0,(%rax)
	lea    0x440(%rsp),%rax
	add    $0x18,%rax
	movq   $0x0,(%rax)
	lea    0x440(%rsp),%rax
	add    $0x20,%rax
	movq   $0x0,(%rax)
	lea    0x440(%rsp),%rax
	add    $0x28,%rax
	movq   $0x0,(%rax)
	lea    0x440(%rsp),%rax
	add    $0x30,%rax
	movq   $0x0,(%rax)
	lea    0x440(%rsp),%rax
	add    $0x38,%rax
	movq   $0x0,(%rax)
	lea    0x440(%rsp),%rax
	mov    0x410(%rsp),%ecx
	mov    %rax,(%rsp)
	mov    %rcx,%rdi
	call   a17 <k_count+0xd7>
	vmovdqu64 %zmm0,0x480(%rsp)
	mov    (%rsp),%rax
	vmovdqu64 0x480(%rsp),%zmm16
	vmovdqu64 %zmm16,0x48(%rsp)
	vmovdqu64 0x48(%rsp),%zmm16
	vmovdqu64 %zmm16,(%rax)
	xor    %eax,%eax
	movslq %eax,%rax
	mov    %rax,%r12
	xor    %ebx,%ebx
	mov    %ebx,%eax
	add    $0x10,%eax
	cmp    0x408(%rsp),%eax
	setle  %al
	movzbl %al,%eax
	test   %eax,%eax
	je     b01 <k_count+0x1c1>
	mov    %r12,%rax
	mov    0x400(%rsp),%rcx
	movslq %ebx,%rdx
	lea    (%rcx,%rdx,4),%rcx
	mov    %rax,(%rsp)
	mov    %rcx,%rdi
	call   a89 <k_count+0x149>
	vmovdqu64 %zmm0,0x4c0(%rsp)
	mov    (%rsp),%rax
	vmovdqu64 0x4c0(%rsp),%zmm16
	vmovdqu64 %zmm16,0x48(%rsp)
	vmovdqu64 0x440(%rsp),%zmm16
	vmovdqu64 %zmm16,0x88(%rsp)
	mov    $0xffff,%esi
	kmovw  %esi,%k1
	vmovdqu64 0x48(%rsp),%zmm0
	vmovdqu64 0x88(%rsp),%zmm1
	vpcmpeqd %zmm1,%zmm0,%k1{%k1}
	kmovw  %k1,%ecx
	movzwl %cx,%ecx
	popcnt %ecx,%ecx
	movslq %ecx,%rcx
	add    %rcx,%rax
	mov    %rax,%r12
	mov    %ebx,%eax
	add    $0x10,%eax
	mov    %eax,%ebx
	jmp    a51 <k_count+0x111>
	mov    %r12,%rax
	lea    -0x10(%rbp),%rsp
	pop    %r12
	pop    %rbx
	pop    %rbp
	ret
	int3
	int3
	int3

0000000000000b10 <k_fma>:
	push   %rbp
	mov    %rsp,%rbp
	push   %rbx
	sub    $0x520,%rsp
	and    $0xffffffffffffffe0,%rsp
	mov    %rdi,0x3c8(%rsp)
	mov    %rsi,0x3d0(%rsp)
	mov    %edx,0x3d8(%rsp)
	mov    %rcx,0x3e0(%rsp)
	lea    0x400(%rsp),%rax
	movq   $0x0,(%rax)
	lea    0x400(%rsp),%rax
	add    $0x8,%rax
	movq   $0x0,(%rax)
	lea    0x400(%rsp),%rax
	add    $0x10,%rax
	movq   $0x0,(%rax)
	lea    0x400(%rsp),%rax
	add    $0x18,%rax
	movq   $0x0,(%rax)
	lea    0x400(%rsp),%rax
	mov    %rax,(%rsp)
	call   b98 <k_fma+0x88>
	vmovdqu %ymm0,0x420(%rsp)
	mov    (%rsp),%rax
	vmovdqu64 0x420(%rsp),%ymm16
	vmovdqu64 %zmm16,0x48(%rsp)
	vmovdqu64 0x48(%rsp),%zmm16
	vmovdqu64 %ymm16,(%rax)
	xor    %ebx,%ebx
	mov    %ebx,%eax
	add    $0x8,%eax
	cmp    0x3d8(%rsp),%eax
	setle  %al
	movzbl %al,%eax
	test   %eax,%eax
	je     d03 <k_fma+0x1f3>
	mov    0x3c8(%rsp),%rax
	movslq %ebx,%rcx
	lea    (%rax,%rcx,4),%rax
	mov    %rax,%rdi
	call   bfc <k_fma+0xec>
	vmovdqu %ymm0,0x4c0(%rsp)
	vmovdqu64 0x4c0(%rsp),%ymm16
	vmovdqu64 %zmm16,0x8(%rsp)
	vmovdqu64 0x8(%rsp),%zmm16
	vmovdqu64 %ymm16,0x4a0(%rsp)
	lea    0x4a0(%rsp),%rax
	mov    0x3d0(%rsp),%rcx
	movslq %ebx,%rdx
	lea    (%rcx,%rdx,4),%rcx
	mov    %rax,(%rsp)
	mov    %rcx,%rdi
	call   c4e <k_fma+0x13e>
	vmovdqu %ymm0,0x4e0(%rsp)
	mov    (%rsp),%rax
	vmovdqu64 0x4e0(%rsp),%ymm16
	vmovdqu64 %zmm16,0x48(%rsp)
	vmovdqu64 0x48(%rsp),%zmm16
	vmovdqu64 %ymm16,0x480(%rsp)
	lea    0x480(%rsp),%rcx
	vmovdqu64 0x400(%rsp),%ymm16
	vmovdqu64 %zmm16,0x88(%rsp)
	vmovdqu64 0x88(%rsp),%zmm16
	vmovdqu64 %ymm16,0x460(%rsp)
	lea    0x460(%rsp),%rdx
	vmovdqu (%rax),%ymm0
	vmovdqu (%rcx),%ymm1
	vmovdqu (%rdx),%ymm2
	call   cc8 <k_fma+0x1b8>
	vmovdqu %ymm0,0x440(%rsp)
	vmovdqu64 0x440(%rsp),%ymm16
	vmovdqu64 %zmm16,0x8(%rsp)
	vmovdqu64 0x8(%rsp),%zmm16
	vmovdqu64 %ymm16,0x400(%rsp)
	mov    %ebx,%eax
	add    $0x8,%eax
	mov    %eax,%ebx
	jmp    bcb <k_fma+0xbb>
	mov    0x3e0(%rsp),%rax
	vmovdqu64 0x400(%rsp),%ymm16
	vmovdqu64 %zmm16,0x48(%rsp)
	vmovdqu64 0x48(%rsp),%zmm16
	vmovdqu64 %ymm16,0x500(%rsp)
	lea    0x500(%rsp),%rcx
	vmovdqu (%rcx),%ymm0
	mov    %rax,%rdi
	call   d45 <k_fma+0x235>
	lea    -0x8(%rbp),%rsp
	pop    %rbx
	pop    %rbp
	ret
