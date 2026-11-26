
kernel-base.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <k_null>:
   0:	8b c7                	mov    %edi,%eax
   2:	33 c6                	xor    %esi,%eax
   4:	c3                   	ret
   5:	cc                   	int3
   6:	cc                   	int3
   7:	cc                   	int3
   8:	cc                   	int3
   9:	cc                   	int3
   a:	cc                   	int3
   b:	cc                   	int3
   c:	cc                   	int3
   d:	cc                   	int3
   e:	cc                   	int3
   f:	cc                   	int3

0000000000000010 <k_best>:
  10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  15:	31 c9                	xor    %ecx,%ecx
  17:	eb 16                	jmp    2f <k_best+0x1f>
  19:	c5 fb 10 0c cf       	vmovsd (%rdi,%rcx,8),%xmm1
  1e:	c5 f9 2e c8          	vucomisd %xmm0,%xmm1
  22:	44 8b d8             	mov    %eax,%r11d
  25:	0f 44 c1             	cmove  %ecx,%eax
  28:	41 0f 4a c3          	cmovp  %r11d,%eax
  2c:	83 c1 01             	add    $0x1,%ecx
  2f:	3b ce                	cmp    %esi,%ecx
  31:	7c e6                	jl     19 <k_best+0x9>
  33:	c3                   	ret
  34:	cc                   	int3
  35:	cc                   	int3
  36:	cc                   	int3
  37:	cc                   	int3
  38:	cc                   	int3
  39:	cc                   	int3
  3a:	cc                   	int3
  3b:	cc                   	int3
  3c:	cc                   	int3
  3d:	cc                   	int3
  3e:	cc                   	int3
  3f:	cc                   	int3

0000000000000040 <k_equal>:
  40:	31 c0                	xor    %eax,%eax
  42:	31 c9                	xor    %ecx,%ecx
  44:	eb 22                	jmp    68 <k_equal+0x28>
  46:	c5 fb 10 0c cf       	vmovsd (%rdi,%rcx,8),%xmm1
  4b:	ba 05 00 00 00       	mov    $0x5,%edx
  50:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  56:	c5 f9 2e c8          	vucomisd %xmm0,%xmm1
  5a:	49 0f 45 d0          	cmovne %r8,%rdx
  5e:	49 0f 4a d0          	cmovp  %r8,%rdx
  62:	48 03 c2             	add    %rdx,%rax
  65:	83 c1 01             	add    $0x1,%ecx
  68:	3b ce                	cmp    %esi,%ecx
  6a:	7c da                	jl     46 <k_equal+0x6>
  6c:	c3                   	ret
  6d:	cc                   	int3
  6e:	cc                   	int3
  6f:	cc                   	int3

0000000000000070 <k_sum>:
  70:	31 c0                	xor    %eax,%eax
  72:	45 31 c0             	xor    %r8d,%r8d
  75:	eb 1c                	jmp    93 <k_sum+0x23>
  77:	c4 a1 7b 10 0c c7    	vmovsd (%rdi,%r8,8),%xmm1
  7d:	c5 f9 2e c8          	vucomisd %xmm0,%xmm1
  81:	4c 8b ca             	mov    %rdx,%r9
  84:	4c 0f 45 c9          	cmovne %rcx,%r9
  88:	4c 0f 4a c9          	cmovp  %rcx,%r9
  8c:	49 03 c1             	add    %r9,%rax
  8f:	41 83 c0 01          	add    $0x1,%r8d
  93:	44 3b c6             	cmp    %esi,%r8d
  96:	7c df                	jl     77 <k_sum+0x7>
  98:	c3                   	ret
  99:	cc                   	int3
  9a:	cc                   	int3
  9b:	cc                   	int3
  9c:	cc                   	int3
  9d:	cc                   	int3
  9e:	cc                   	int3
  9f:	cc                   	int3

00000000000000a0 <k_lt>:
  a0:	c5 f9 2e c8          	vucomisd %xmm0,%xmm1
  a4:	8b c6                	mov    %esi,%eax
  a6:	0f 47 c7             	cmova  %edi,%eax
  a9:	c3                   	ret
  aa:	cc                   	int3
  ab:	cc                   	int3
  ac:	cc                   	int3
  ad:	cc                   	int3
  ae:	cc                   	int3
  af:	cc                   	int3

00000000000000b0 <k_eq>:
  b0:	c5 f9 2e c1          	vucomisd %xmm1,%xmm0
  b4:	8b c7                	mov    %edi,%eax
  b6:	0f 45 c6             	cmovne %esi,%eax
  b9:	0f 4a c6             	cmovp  %esi,%eax
  bc:	c3                   	ret
  bd:	cc                   	int3
  be:	cc                   	int3
  bf:	cc                   	int3

00000000000000c0 <k_ne>:
  c0:	c5 f8 2e c1          	vucomiss %xmm1,%xmm0
  c4:	8b c6                	mov    %esi,%eax
  c6:	0f 45 c7             	cmovne %edi,%eax
  c9:	0f 4a c7             	cmovp  %edi,%eax
  cc:	c3                   	ret
