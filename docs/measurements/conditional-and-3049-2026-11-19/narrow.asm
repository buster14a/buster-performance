Disassembly of section .text:

0000000000000000 <narrow8>:
   0:	0f b6 c2             	movzx  eax,dl
   3:	31 c9                	xor    ecx,ecx
   5:	eb 1f                	jmp    26 <narrow8+0x26>
   7:	48 8b d1             	mov    rdx,rcx
   a:	0f b6 14 17          	movzx  edx,BYTE PTR [rdi+rdx*1]
   e:	44 8b c2             	mov    r8d,edx
  11:	41 83 e0 02          	and    r8d,0x2
  15:	44 0f b6 c8          	movzx  r9d,al
  19:	44 23 ca             	and    r9d,edx
  1c:	45 85 c0             	test   r8d,r8d
  1f:	41 0f 45 c1          	cmovne eax,r9d
  23:	83 c1 01             	add    ecx,0x1
  26:	3b ce                	cmp    ecx,esi
  28:	72 dd                	jb     7 <narrow8+0x7>
  2a:	c3                   	ret
  2b:	cc                   	int3
  2c:	cc                   	int3
  2d:	cc                   	int3
  2e:	cc                   	int3
  2f:	cc                   	int3

0000000000000030 <narrow16>:
  30:	0f b7 c2             	movzx  eax,dx
  33:	31 c9                	xor    ecx,ecx
  35:	eb 1e                	jmp    55 <narrow16+0x25>
  37:	48 8b d1             	mov    rdx,rcx
  3a:	0f b7 14 57          	movzx  edx,WORD PTR [rdi+rdx*2]
  3e:	44 8b c2             	mov    r8d,edx
  41:	41 83 e0 02          	and    r8d,0x2
  45:	44 0f b7 c8          	movzx  r9d,ax
  49:	41 23 d1             	and    edx,r9d
  4c:	45 85 c0             	test   r8d,r8d
  4f:	0f 44 c2             	cmove  eax,edx
  52:	83 c1 01             	add    ecx,0x1
  55:	3b ce                	cmp    ecx,esi
  57:	72 de                	jb     37 <narrow16+0x7>
  59:	c3                   	ret
