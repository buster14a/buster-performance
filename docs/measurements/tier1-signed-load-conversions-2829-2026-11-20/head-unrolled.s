
head-znver5-unroll.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000cc0 <k_i32_to_f32>:
     cc0:	31 c0                	xor    %eax,%eax
     cc2:	48 3b c2             	cmp    %rdx,%rax
     cc5:	0f 83 cb 00 00 00    	jae    d96 <k_i32_to_f32+0xd6>
     ccb:	48 8b ca             	mov    %rdx,%rcx
     cce:	48 83 e9 07          	sub    $0x7,%rcx
     cd2:	48 83 fa 07          	cmp    $0x7,%rdx
     cd6:	0f 86 a3 00 00 00    	jbe    d7f <k_i32_to_f32+0xbf>
     cdc:	0f 57 c9             	xorps  %xmm1,%xmm1
     cdf:	f3 0f 2a 0c 86       	cvtsi2ssl (%rsi,%rax,4),%xmm1
     ce4:	f3 0f 59 c8          	mulss  %xmm0,%xmm1
     ce8:	f3 0f 11 0c 87       	movss  %xmm1,(%rdi,%rax,4)
     ced:	0f 57 c9             	xorps  %xmm1,%xmm1
     cf0:	f3 0f 2a 4c 86 04    	cvtsi2ssl 0x4(%rsi,%rax,4),%xmm1
     cf6:	f3 0f 59 c8          	mulss  %xmm0,%xmm1
     cfa:	f3 0f 11 4c 87 04    	movss  %xmm1,0x4(%rdi,%rax,4)
     d00:	0f 57 c9             	xorps  %xmm1,%xmm1
     d03:	f3 0f 2a 4c 86 08    	cvtsi2ssl 0x8(%rsi,%rax,4),%xmm1
     d09:	f3 0f 59 c8          	mulss  %xmm0,%xmm1
     d0d:	f3 0f 11 4c 87 08    	movss  %xmm1,0x8(%rdi,%rax,4)
     d13:	0f 57 c9             	xorps  %xmm1,%xmm1
     d16:	f3 0f 2a 4c 86 0c    	cvtsi2ssl 0xc(%rsi,%rax,4),%xmm1
     d1c:	f3 0f 59 c8          	mulss  %xmm0,%xmm1
     d20:	f3 0f 11 4c 87 0c    	movss  %xmm1,0xc(%rdi,%rax,4)
     d26:	0f 57 c9             	xorps  %xmm1,%xmm1
     d29:	f3 0f 2a 4c 86 10    	cvtsi2ssl 0x10(%rsi,%rax,4),%xmm1
     d2f:	f3 0f 59 c8          	mulss  %xmm0,%xmm1
     d33:	f3 0f 11 4c 87 10    	movss  %xmm1,0x10(%rdi,%rax,4)
     d39:	0f 57 c9             	xorps  %xmm1,%xmm1
     d3c:	f3 0f 2a 4c 86 14    	cvtsi2ssl 0x14(%rsi,%rax,4),%xmm1
     d42:	f3 0f 59 c8          	mulss  %xmm0,%xmm1
     d46:	f3 0f 11 4c 87 14    	movss  %xmm1,0x14(%rdi,%rax,4)
     d4c:	0f 57 c9             	xorps  %xmm1,%xmm1
     d4f:	f3 0f 2a 4c 86 18    	cvtsi2ssl 0x18(%rsi,%rax,4),%xmm1
     d55:	f3 0f 59 c8          	mulss  %xmm0,%xmm1
     d59:	f3 0f 11 4c 87 18    	movss  %xmm1,0x18(%rdi,%rax,4)
     d5f:	0f 57 c9             	xorps  %xmm1,%xmm1
     d62:	f3 0f 2a 4c 86 1c    	cvtsi2ssl 0x1c(%rsi,%rax,4),%xmm1
     d68:	f3 0f 59 c8          	mulss  %xmm0,%xmm1
     d6c:	f3 0f 11 4c 87 1c    	movss  %xmm1,0x1c(%rdi,%rax,4)
     d72:	48 83 c0 08          	add    $0x8,%rax
     d76:	48 3b c1             	cmp    %rcx,%rax
     d79:	0f 82 5d ff ff ff    	jb     cdc <k_i32_to_f32+0x1c>
     d7f:	eb 15                	jmp    d96 <k_i32_to_f32+0xd6>
     d81:	0f 57 c9             	xorps  %xmm1,%xmm1
     d84:	f3 0f 2a 0c 86       	cvtsi2ssl (%rsi,%rax,4),%xmm1
     d89:	f3 0f 59 c8          	mulss  %xmm0,%xmm1
     d8d:	f3 0f 11 0c 87       	movss  %xmm1,(%rdi,%rax,4)
     d92:	48 83 c0 01          	add    $0x1,%rax
     d96:	48 3b c2             	cmp    %rdx,%rax
     d99:	72 e6                	jb     d81 <k_i32_to_f32+0xc1>
     d9b:	c3                   	ret
