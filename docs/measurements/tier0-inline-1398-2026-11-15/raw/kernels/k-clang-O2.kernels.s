0000000000000000 <k_sum>:
	vxorps %xmm0,%xmm0,%xmm0
	cmp    $0x8,%esi
	jl     1f <k_sum+0x1f>
	mov    $0x8,%ecx
	mov    %esi,%eax
	vaddps -0x20(%rdi,%rcx,4),%ymm0,%ymm0
	add    $0x8,%rcx
	cmp    %rax,%rcx
	jbe    10 <k_sum+0x10>
	vmovups %ymm0,(%rdx)
	vzeroupper
	ret
	nopw   0x0(%rax,%rax,1)

0000000000000030 <k_adds>:
	cmp    $0x20,%ecx
	jl     5b <k_adds+0x2b>
	mov    %ecx,%eax
	mov    $0x20,%ecx
	nopl   0x0(%rax)
	vmovdqu -0x20(%rsi,%rcx,1),%ymm0
	vpaddusb -0x20(%rdx,%rcx,1),%ymm0,%ymm0
	vmovdqu %ymm0,-0x20(%rdi,%rcx,1)
	add    $0x20,%rcx
	cmp    %rax,%rcx
	jbe    40 <k_adds+0x10>
	vzeroupper
	ret
	nop

0000000000000060 <k_count>:
	cmp    $0x10,%esi
	jge    68 <k_count+0x8>
	xor    %eax,%eax
	ret
	vpbroadcastd %edx,%zmm0
	mov    $0x10,%edx
	mov    %esi,%ecx
	xor    %eax,%eax
	nopw   0x0(%rax,%rax,1)
	vpcmpeqd -0x40(%rdi,%rdx,4),%zmm0,%k0
	add    $0x10,%rdx
	kmovw  %k0,%esi
	popcnt %esi,%esi
	add    %rsi,%rax
	cmp    %rcx,%rdx
	jbe    80 <k_count+0x20>
	vzeroupper
	ret

00000000000000a0 <k_fma>:
	vxorps %xmm0,%xmm0,%xmm0
	cmp    $0x8,%edx
	jl     c6 <k_fma+0x26>
	mov    %edx,%eax
	mov    $0x8,%edx
	vmovups -0x20(%rdi,%rdx,4),%ymm1
	vfmadd231ps -0x20(%rsi,%rdx,4),%ymm1,%ymm0
	add    $0x8,%rdx
	cmp    %rax,%rdx
	jbe    b0 <k_fma+0x10>
	vmovups %ymm0,(%rcx)
	vzeroupper
	ret
