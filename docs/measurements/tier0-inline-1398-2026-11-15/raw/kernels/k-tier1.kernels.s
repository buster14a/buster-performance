0000000000000000 <k_sum>:
	vpxord %ymm0,%ymm0,%ymm0
	xor    %eax,%eax
	jmp    1d <k_sum+0x1d>
	movslq %eax,%rcx
	vmovdqu32 (%rdi,%rcx,4),%ymm1
	{evex} vaddps %ymm1,%ymm0,%ymm0
	add    $0x8,%eax
	lea    0x8(%rax),%ecx
	cmp    %esi,%ecx
	jle    a <k_sum+0xa>
	vmovdqu32 %ymm0,(%rdx)
	ret
	int3
	int3
	int3
	int3
	int3

0000000000000030 <k_adds>:
	xor    %eax,%eax
	jmp    55 <k_adds+0x25>
	movslq %eax,%r8
	vmovdqu32 (%rsi,%r8,1),%ymm0
	vmovdqu32 (%rdx,%r8,1),%ymm1
	{evex} vpaddusb %ymm1,%ymm0,%ymm1
	vmovdqu32 %ymm1,(%rdi,%r8,1)
	add    $0x20,%eax
	lea    0x20(%rax),%r8d
	cmp    %ecx,%r8d
	jle    34 <k_adds+0x4>
	ret
	int3

0000000000000060 <k_count>:
	vpbroadcastd %edx,%zmm0
	xor    %eax,%eax
	xor    %ecx,%ecx
	jmp    8e <k_count+0x2e>
	movslq %ecx,%rdx
	vmovdqu32 (%rdi,%rdx,4),%zmm1
	vpcmpeqd %zmm0,%zmm1,%k1
	kmovw  %k1,%edx
	popcnt %edx,%edx
	movslq %edx,%rdx
	add    %rdx,%rax
	add    $0x10,%ecx
	lea    0x10(%rcx),%edx
	cmp    %esi,%edx
	jle    6c <k_count+0xc>
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

00000000000000a0 <k_fma>:
	vpxord %ymm0,%ymm0,%ymm0
	xor    %eax,%eax
	jmp    ca <k_fma+0x2a>
	movslq %eax,%r8
	vmovdqu32 (%rdi,%r8,4),%ymm1
	vmovdqu32 (%rsi,%r8,4),%ymm2
	{evex} vfmadd213ps %ymm0,%ymm1,%ymm2
	vmovdqu64 %ymm2,%ymm0
	add    $0x8,%eax
	lea    0x8(%rax),%r8d
	cmp    %edx,%r8d
	jle    aa <k_fma+0xa>
	vmovdqu32 %ymm0,(%rcx)
	ret
