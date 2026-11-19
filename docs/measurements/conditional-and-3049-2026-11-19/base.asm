Disassembly of section .text:

0000000000000000 <common_alloc_flags>:
   0:	31 c0                	xor    eax,eax
   2:	48 8b c8             	mov    rcx,rax
   5:	48 8b c2             	mov    rax,rdx
   8:	eb 1b                	jmp    25 <common_alloc_flags+0x25>
   a:	48 8b d1             	mov    rdx,rcx
   d:	48 8b 14 d7          	mov    rdx,QWORD PTR [rdi+rdx*8]
  11:	4c 8b c2             	mov    r8,rdx
  14:	49 83 e0 02          	and    r8,0x2
  18:	48 23 d0             	and    rdx,rax
  1b:	4d 85 c0             	test   r8,r8
  1e:	48 0f 45 c2          	cmovne rax,rdx
  22:	83 c1 01             	add    ecx,0x1
  25:	3b ce                	cmp    ecx,esi
  27:	72 e1                	jb     a <common_alloc_flags+0xa>
  29:	c3                   	ret
  2a:	cc                   	int3
  2b:	cc                   	int3
  2c:	cc                   	int3
  2d:	cc                   	int3
  2e:	cc                   	int3
  2f:	cc                   	int3

0000000000000030 <common_nonalloc_flags>:
  30:	31 c0                	xor    eax,eax
  32:	48 8b c8             	mov    rcx,rax
  35:	48 8b c2             	mov    rax,rdx
  38:	eb 1b                	jmp    55 <common_nonalloc_flags+0x25>
  3a:	48 8b d1             	mov    rdx,rcx
  3d:	48 8b 14 d7          	mov    rdx,QWORD PTR [rdi+rdx*8]
  41:	4c 8b c2             	mov    r8,rdx
  44:	49 83 e0 02          	and    r8,0x2
  48:	48 23 d0             	and    rdx,rax
  4b:	4d 85 c0             	test   r8,r8
  4e:	48 0f 44 c2          	cmove  rax,rdx
  52:	83 c1 01             	add    ecx,0x1
  55:	3b ce                	cmp    ecx,esi
  57:	72 e1                	jb     3a <common_nonalloc_flags+0xa>
  59:	c3                   	ret
  5a:	cc                   	int3
  5b:	cc                   	int3
  5c:	cc                   	int3
  5d:	cc                   	int3
  5e:	cc                   	int3
  5f:	cc                   	int3

0000000000000060 <common32>:
  60:	31 c0                	xor    eax,eax
  62:	48 8b c8             	mov    rcx,rax
  65:	48 8b c2             	mov    rax,rdx
  68:	eb 18                	jmp    82 <common32+0x22>
  6a:	48 8b d1             	mov    rdx,rcx
  6d:	8b 14 97             	mov    edx,DWORD PTR [rdi+rdx*4]
  70:	44 8b c2             	mov    r8d,edx
  73:	41 83 e0 02          	and    r8d,0x2
  77:	23 d0                	and    edx,eax
  79:	45 85 c0             	test   r8d,r8d
  7c:	0f 45 c2             	cmovne eax,edx
  7f:	83 c1 01             	add    ecx,0x1
  82:	3b ce                	cmp    ecx,esi
  84:	72 e4                	jb     6a <common32+0xa>
  86:	c3                   	ret
  87:	cc                   	int3
  88:	cc                   	int3
  89:	cc                   	int3
  8a:	cc                   	int3
  8b:	cc                   	int3
  8c:	cc                   	int3
  8d:	cc                   	int3
  8e:	cc                   	int3
  8f:	cc                   	int3

0000000000000090 <shared32>:
  90:	31 c0                	xor    eax,eax
  92:	4c 8b d8             	mov    r11,rax
  95:	48 8b c2             	mov    rax,rdx
  98:	49 8b d3             	mov    rdx,r11
  9b:	eb 35                	jmp    d2 <shared32+0x42>
  9d:	4c 8b c2             	mov    r8,rdx
  a0:	46 8b 04 87          	mov    r8d,DWORD PTR [rdi+r8*4]
  a4:	45 8b c8             	mov    r9d,r8d
  a7:	41 83 e1 02          	and    r9d,0x2
  ab:	45 85 c9             	test   r9d,r9d
  ae:	41 b9 00 00 00 00    	mov    r9d,0x0
  b4:	41 0f 95 c1          	setne  r9b
  b8:	45 31 d2             	xor    r10d,r10d
  bb:	44 23 c0             	and    r8d,eax
  be:	45 85 c9             	test   r9d,r9d
  c1:	45 0f 45 d0          	cmovne r10d,r8d
  c5:	45 85 c9             	test   r9d,r9d
  c8:	41 0f 45 c0          	cmovne eax,r8d
  cc:	41 33 ca             	xor    ecx,r10d
  cf:	83 c2 01             	add    edx,0x1
  d2:	3b d6                	cmp    edx,esi
  d4:	72 c7                	jb     9d <shared32+0xd>
  d6:	33 c1                	xor    eax,ecx
  d8:	c3                   	ret
  d9:	cc                   	int3
  da:	cc                   	int3
  db:	cc                   	int3
  dc:	cc                   	int3
  dd:	cc                   	int3
  de:	cc                   	int3
  df:	cc                   	int3

00000000000000e0 <volatile32>:
  e0:	31 c0                	xor    eax,eax
  e2:	48 8b c8             	mov    rcx,rax
  e5:	48 8b c2             	mov    rax,rdx
  e8:	eb 18                	jmp    102 <volatile32+0x22>
  ea:	48 8b d1             	mov    rdx,rcx
  ed:	8b 14 97             	mov    edx,DWORD PTR [rdi+rdx*4]
  f0:	44 8b c2             	mov    r8d,edx
  f3:	41 83 e0 02          	and    r8d,0x2
  f7:	23 d0                	and    edx,eax
  f9:	45 85 c0             	test   r8d,r8d
  fc:	0f 45 c2             	cmovne eax,edx
  ff:	83 c1 01             	add    ecx,0x1
 102:	3b ce                	cmp    ecx,esi
 104:	72 e4                	jb     ea <volatile32+0xa>
 106:	c3                   	ret
 107:	cc                   	int3
 108:	cc                   	int3
 109:	cc                   	int3
 10a:	cc                   	int3
 10b:	cc                   	int3
 10c:	cc                   	int3
 10d:	cc                   	int3
 10e:	cc                   	int3
 10f:	cc                   	int3

0000000000000110 <common8>:
 110:	0f b6 c2             	movzx  eax,dl
 113:	31 c9                	xor    ecx,ecx
 115:	eb 1f                	jmp    136 <common8+0x26>
 117:	48 8b d1             	mov    rdx,rcx
 11a:	0f b6 14 17          	movzx  edx,BYTE PTR [rdi+rdx*1]
 11e:	44 8b c2             	mov    r8d,edx
 121:	41 83 e0 02          	and    r8d,0x2
 125:	44 0f b6 c8          	movzx  r9d,al
 129:	44 23 ca             	and    r9d,edx
 12c:	45 85 c0             	test   r8d,r8d
 12f:	41 0f 45 c1          	cmovne eax,r9d
 133:	83 c1 01             	add    ecx,0x1
 136:	3b ce                	cmp    ecx,esi
 138:	72 dd                	jb     117 <common8+0x7>
 13a:	c3                   	ret
 13b:	cc                   	int3
 13c:	cc                   	int3
 13d:	cc                   	int3
 13e:	cc                   	int3
 13f:	cc                   	int3

0000000000000140 <common16>:
 140:	0f b7 c2             	movzx  eax,dx
 143:	31 c9                	xor    ecx,ecx
 145:	eb 1f                	jmp    166 <common16+0x26>
 147:	48 8b d1             	mov    rdx,rcx
 14a:	0f b7 14 57          	movzx  edx,WORD PTR [rdi+rdx*2]
 14e:	44 8b c2             	mov    r8d,edx
 151:	41 83 e0 02          	and    r8d,0x2
 155:	44 0f b7 c8          	movzx  r9d,ax
 159:	44 23 ca             	and    r9d,edx
 15c:	45 85 c0             	test   r8d,r8d
 15f:	41 0f 45 c1          	cmovne eax,r9d
 163:	83 c1 01             	add    ecx,0x1
 166:	3b ce                	cmp    ecx,esi
 168:	72 dd                	jb     147 <common16+0x7>
 16a:	c3                   	ret
 16b:	cc                   	int3
 16c:	cc                   	int3
 16d:	cc                   	int3
 16e:	cc                   	int3
 16f:	cc                   	int3

0000000000000170 <guarded>:
 170:	31 c0                	xor    eax,eax
 172:	4c 8b d8             	mov    r11,rax
 175:	48 8b c1             	mov    rax,rcx
 178:	49 8b cb             	mov    rcx,r11
 17b:	eb 14                	jmp    191 <guarded+0x21>
 17d:	4c 8b c1             	mov    r8,rcx
 180:	42 83 3c 87 00       	cmp    DWORD PTR [rdi+r8*4],0x0
 185:	74 07                	je     18e <guarded+0x1e>
 187:	4c 8b c1             	mov    r8,rcx
 18a:	42 23 04 86          	and    eax,DWORD PTR [rsi+r8*4]
 18e:	83 c1 01             	add    ecx,0x1
 191:	3b ca                	cmp    ecx,edx
 193:	72 e8                	jb     17d <guarded+0xd>
 195:	c3                   	ret
 196:	cc                   	int3
 197:	cc                   	int3
 198:	cc                   	int3
 199:	cc                   	int3
 19a:	cc                   	int3
 19b:	cc                   	int3
 19c:	cc                   	int3
 19d:	cc                   	int3
 19e:	cc                   	int3
 19f:	cc                   	int3

00000000000001a0 <quotient>:
 1a0:	31 c9                	xor    ecx,ecx
 1a2:	4c 8b c1             	mov    r8,rcx
 1a5:	48 8b ca             	mov    rcx,rdx
 1a8:	eb 1c                	jmp    1c6 <quotient+0x26>
 1aa:	49 8b c0             	mov    rax,r8
 1ad:	44 8b 0c 87          	mov    r9d,DWORD PTR [rdi+rax*4]
 1b1:	45 85 c9             	test   r9d,r9d
 1b4:	74 0c                	je     1c2 <quotient+0x22>
 1b6:	b8 ff ff ff 7f       	mov    eax,0x7fffffff
 1bb:	33 d2                	xor    edx,edx
 1bd:	41 f7 f1             	div    r9d
 1c0:	23 c8                	and    ecx,eax
 1c2:	41 83 c0 01          	add    r8d,0x1
 1c6:	44 3b c6             	cmp    r8d,esi
 1c9:	72 df                	jb     1aa <quotient+0xa>
 1cb:	8b c1                	mov    eax,ecx
 1cd:	c3                   	ret
 1ce:	cc                   	int3
 1cf:	cc                   	int3

00000000000001d0 <float_condition>:
 1d0:	31 c0                	xor    eax,eax
 1d2:	4c 8b d8             	mov    r11,rax
 1d5:	48 8b c2             	mov    rax,rdx
 1d8:	49 8b d3             	mov    rdx,r11
 1db:	eb 3a                	jmp    217 <float_condition+0x47>
 1dd:	4c 8b c2             	mov    r8,rdx
 1e0:	f2 42 0f 10 04 c7    	movsd  xmm0,QWORD PTR [rdi+r8*8]
 1e6:	49 bb 00 00 00 00 00 00 00 40 	movabs r11,0x4000000000000000
 1f0:	66 49 0f 6e cb       	movq   xmm1,r11
 1f5:	45 33 c0             	xor    r8d,r8d
 1f8:	66 0f 2e c1          	ucomisd xmm0,xmm1
 1fc:	41 0f 94 c0          	sete   r8b
 200:	41 0f 9b c3          	setnp  r11b
 204:	45 20 d8             	and    r8b,r11b
 207:	44 8b c8             	mov    r9d,eax
 20a:	44 23 c9             	and    r9d,ecx
 20d:	45 85 c0             	test   r8d,r8d
 210:	41 0f 45 c1          	cmovne eax,r9d
 214:	83 c2 01             	add    edx,0x1
 217:	3b d6                	cmp    edx,esi
 219:	72 c2                	jb     1dd <float_condition+0xd>
 21b:	c3                   	ret
 21c:	cc                   	int3
 21d:	cc                   	int3
 21e:	cc                   	int3
 21f:	cc                   	int3

0000000000000220 <plain_reload>:
 220:	31 c0                	xor    eax,eax
 222:	48 8b c8             	mov    rcx,rax
 225:	48 8b c2             	mov    rax,rdx
 228:	eb 18                	jmp    242 <plain_reload+0x22>
 22a:	48 8b d1             	mov    rdx,rcx
 22d:	8b 14 97             	mov    edx,DWORD PTR [rdi+rdx*4]
 230:	44 8b c2             	mov    r8d,edx
 233:	41 83 e0 02          	and    r8d,0x2
 237:	23 d0                	and    edx,eax
 239:	45 85 c0             	test   r8d,r8d
 23c:	0f 45 c2             	cmovne eax,edx
 23f:	83 c1 01             	add    ecx,0x1
 242:	3b ce                	cmp    ecx,esi
 244:	72 e4                	jb     22a <plain_reload+0xa>
 246:	c3                   	ret
