Disassembly of section .text:

0000000000000000 <common_alloc_flags>:
   0:	31 c0                	xor    eax,eax
   2:	48 8b c8             	mov    rcx,rax
   5:	48 8b c2             	mov    rax,rdx
   8:	eb 22                	jmp    2c <common_alloc_flags+0x2c>
   a:	48 8b d1             	mov    rdx,rcx
   d:	48 8b 14 d7          	mov    rdx,QWORD PTR [rdi+rdx*8]
  11:	4c 8b c2             	mov    r8,rdx
  14:	49 83 e0 02          	and    r8,0x2
  18:	49 c7 c1 ff ff ff ff 	mov    r9,0xffffffffffffffff
  1f:	4d 85 c0             	test   r8,r8
  22:	4c 0f 45 ca          	cmovne r9,rdx
  26:	49 23 c1             	and    rax,r9
  29:	83 c1 01             	add    ecx,0x1
  2c:	3b ce                	cmp    ecx,esi
  2e:	72 da                	jb     a <common_alloc_flags+0xa>
  30:	c3                   	ret
  31:	cc                   	int3
  32:	cc                   	int3
  33:	cc                   	int3
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

0000000000000040 <common_nonalloc_flags>:
  40:	31 c0                	xor    eax,eax
  42:	48 8b c8             	mov    rcx,rax
  45:	48 8b c2             	mov    rax,rdx
  48:	eb 22                	jmp    6c <common_nonalloc_flags+0x2c>
  4a:	48 8b d1             	mov    rdx,rcx
  4d:	48 8b 14 d7          	mov    rdx,QWORD PTR [rdi+rdx*8]
  51:	4c 8b c2             	mov    r8,rdx
  54:	49 83 e0 02          	and    r8,0x2
  58:	49 c7 c1 ff ff ff ff 	mov    r9,0xffffffffffffffff
  5f:	4d 85 c0             	test   r8,r8
  62:	49 0f 45 d1          	cmovne rdx,r9
  66:	48 23 c2             	and    rax,rdx
  69:	83 c1 01             	add    ecx,0x1
  6c:	3b ce                	cmp    ecx,esi
  6e:	72 da                	jb     4a <common_nonalloc_flags+0xa>
  70:	c3                   	ret
  71:	cc                   	int3
  72:	cc                   	int3
  73:	cc                   	int3
  74:	cc                   	int3
  75:	cc                   	int3
  76:	cc                   	int3
  77:	cc                   	int3
  78:	cc                   	int3
  79:	cc                   	int3
  7a:	cc                   	int3
  7b:	cc                   	int3
  7c:	cc                   	int3
  7d:	cc                   	int3
  7e:	cc                   	int3
  7f:	cc                   	int3

0000000000000080 <common32>:
  80:	31 c0                	xor    eax,eax
  82:	48 8b c8             	mov    rcx,rax
  85:	48 8b c2             	mov    rax,rdx
  88:	eb 20                	jmp    aa <common32+0x2a>
  8a:	48 8b d1             	mov    rdx,rcx
  8d:	8b 14 97             	mov    edx,DWORD PTR [rdi+rdx*4]
  90:	44 8b c2             	mov    r8d,edx
  93:	41 83 e0 02          	and    r8d,0x2
  97:	41 b9 ff ff ff ff    	mov    r9d,0xffffffff
  9d:	45 85 c0             	test   r8d,r8d
  a0:	44 0f 45 ca          	cmovne r9d,edx
  a4:	41 23 c1             	and    eax,r9d
  a7:	83 c1 01             	add    ecx,0x1
  aa:	3b ce                	cmp    ecx,esi
  ac:	72 dc                	jb     8a <common32+0xa>
  ae:	c3                   	ret
  af:	cc                   	int3

00000000000000b0 <shared32>:
  b0:	31 c0                	xor    eax,eax
  b2:	4c 8b d8             	mov    r11,rax
  b5:	48 8b c2             	mov    rax,rdx
  b8:	49 8b d3             	mov    rdx,r11
  bb:	eb 35                	jmp    f2 <shared32+0x42>
  bd:	4c 8b c2             	mov    r8,rdx
  c0:	46 8b 04 87          	mov    r8d,DWORD PTR [rdi+r8*4]
  c4:	45 8b c8             	mov    r9d,r8d
  c7:	41 83 e1 02          	and    r9d,0x2
  cb:	45 85 c9             	test   r9d,r9d
  ce:	41 b9 00 00 00 00    	mov    r9d,0x0
  d4:	41 0f 95 c1          	setne  r9b
  d8:	45 31 d2             	xor    r10d,r10d
  db:	44 23 c0             	and    r8d,eax
  de:	45 85 c9             	test   r9d,r9d
  e1:	45 0f 45 d0          	cmovne r10d,r8d
  e5:	45 85 c9             	test   r9d,r9d
  e8:	41 0f 45 c0          	cmovne eax,r8d
  ec:	41 33 ca             	xor    ecx,r10d
  ef:	83 c2 01             	add    edx,0x1
  f2:	3b d6                	cmp    edx,esi
  f4:	72 c7                	jb     bd <shared32+0xd>
  f6:	33 c1                	xor    eax,ecx
  f8:	c3                   	ret
  f9:	cc                   	int3
  fa:	cc                   	int3
  fb:	cc                   	int3
  fc:	cc                   	int3
  fd:	cc                   	int3
  fe:	cc                   	int3
  ff:	cc                   	int3

0000000000000100 <volatile32>:
 100:	31 c0                	xor    eax,eax
 102:	48 8b c8             	mov    rcx,rax
 105:	48 8b c2             	mov    rax,rdx
 108:	eb 18                	jmp    122 <volatile32+0x22>
 10a:	48 8b d1             	mov    rdx,rcx
 10d:	8b 14 97             	mov    edx,DWORD PTR [rdi+rdx*4]
 110:	44 8b c2             	mov    r8d,edx
 113:	41 83 e0 02          	and    r8d,0x2
 117:	23 d0                	and    edx,eax
 119:	45 85 c0             	test   r8d,r8d
 11c:	0f 45 c2             	cmovne eax,edx
 11f:	83 c1 01             	add    ecx,0x1
 122:	3b ce                	cmp    ecx,esi
 124:	72 e4                	jb     10a <volatile32+0xa>
 126:	c3                   	ret
 127:	cc                   	int3
 128:	cc                   	int3
 129:	cc                   	int3
 12a:	cc                   	int3
 12b:	cc                   	int3
 12c:	cc                   	int3
 12d:	cc                   	int3
 12e:	cc                   	int3
 12f:	cc                   	int3

0000000000000130 <common8>:
 130:	0f b6 c2             	movzx  eax,dl
 133:	31 c9                	xor    ecx,ecx
 135:	eb 1f                	jmp    156 <common8+0x26>
 137:	48 8b d1             	mov    rdx,rcx
 13a:	0f b6 14 17          	movzx  edx,BYTE PTR [rdi+rdx*1]
 13e:	44 8b c2             	mov    r8d,edx
 141:	41 83 e0 02          	and    r8d,0x2
 145:	44 0f b6 c8          	movzx  r9d,al
 149:	44 23 ca             	and    r9d,edx
 14c:	45 85 c0             	test   r8d,r8d
 14f:	41 0f 45 c1          	cmovne eax,r9d
 153:	83 c1 01             	add    ecx,0x1
 156:	3b ce                	cmp    ecx,esi
 158:	72 dd                	jb     137 <common8+0x7>
 15a:	c3                   	ret
 15b:	cc                   	int3
 15c:	cc                   	int3
 15d:	cc                   	int3
 15e:	cc                   	int3
 15f:	cc                   	int3

0000000000000160 <common16>:
 160:	0f b7 c2             	movzx  eax,dx
 163:	31 c9                	xor    ecx,ecx
 165:	eb 1f                	jmp    186 <common16+0x26>
 167:	48 8b d1             	mov    rdx,rcx
 16a:	0f b7 14 57          	movzx  edx,WORD PTR [rdi+rdx*2]
 16e:	44 8b c2             	mov    r8d,edx
 171:	41 83 e0 02          	and    r8d,0x2
 175:	44 0f b7 c8          	movzx  r9d,ax
 179:	44 23 ca             	and    r9d,edx
 17c:	45 85 c0             	test   r8d,r8d
 17f:	41 0f 45 c1          	cmovne eax,r9d
 183:	83 c1 01             	add    ecx,0x1
 186:	3b ce                	cmp    ecx,esi
 188:	72 dd                	jb     167 <common16+0x7>
 18a:	c3                   	ret
 18b:	cc                   	int3
 18c:	cc                   	int3
 18d:	cc                   	int3
 18e:	cc                   	int3
 18f:	cc                   	int3

0000000000000190 <guarded>:
 190:	31 c0                	xor    eax,eax
 192:	4c 8b d8             	mov    r11,rax
 195:	48 8b c1             	mov    rax,rcx
 198:	49 8b cb             	mov    rcx,r11
 19b:	eb 14                	jmp    1b1 <guarded+0x21>
 19d:	4c 8b c1             	mov    r8,rcx
 1a0:	42 83 3c 87 00       	cmp    DWORD PTR [rdi+r8*4],0x0
 1a5:	74 07                	je     1ae <guarded+0x1e>
 1a7:	4c 8b c1             	mov    r8,rcx
 1aa:	42 23 04 86          	and    eax,DWORD PTR [rsi+r8*4]
 1ae:	83 c1 01             	add    ecx,0x1
 1b1:	3b ca                	cmp    ecx,edx
 1b3:	72 e8                	jb     19d <guarded+0xd>
 1b5:	c3                   	ret
 1b6:	cc                   	int3
 1b7:	cc                   	int3
 1b8:	cc                   	int3
 1b9:	cc                   	int3
 1ba:	cc                   	int3
 1bb:	cc                   	int3
 1bc:	cc                   	int3
 1bd:	cc                   	int3
 1be:	cc                   	int3
 1bf:	cc                   	int3

00000000000001c0 <quotient>:
 1c0:	31 c9                	xor    ecx,ecx
 1c2:	4c 8b c1             	mov    r8,rcx
 1c5:	48 8b ca             	mov    rcx,rdx
 1c8:	eb 1c                	jmp    1e6 <quotient+0x26>
 1ca:	49 8b c0             	mov    rax,r8
 1cd:	44 8b 0c 87          	mov    r9d,DWORD PTR [rdi+rax*4]
 1d1:	45 85 c9             	test   r9d,r9d
 1d4:	74 0c                	je     1e2 <quotient+0x22>
 1d6:	b8 ff ff ff 7f       	mov    eax,0x7fffffff
 1db:	33 d2                	xor    edx,edx
 1dd:	41 f7 f1             	div    r9d
 1e0:	23 c8                	and    ecx,eax
 1e2:	41 83 c0 01          	add    r8d,0x1
 1e6:	44 3b c6             	cmp    r8d,esi
 1e9:	72 df                	jb     1ca <quotient+0xa>
 1eb:	8b c1                	mov    eax,ecx
 1ed:	c3                   	ret
 1ee:	cc                   	int3
 1ef:	cc                   	int3

00000000000001f0 <float_condition>:
 1f0:	31 c0                	xor    eax,eax
 1f2:	4c 8b d8             	mov    r11,rax
 1f5:	48 8b c2             	mov    rax,rdx
 1f8:	49 8b d3             	mov    rdx,r11
 1fb:	eb 3a                	jmp    237 <float_condition+0x47>
 1fd:	4c 8b c2             	mov    r8,rdx
 200:	f2 42 0f 10 04 c7    	movsd  xmm0,QWORD PTR [rdi+r8*8]
 206:	49 bb 00 00 00 00 00 00 00 40 	movabs r11,0x4000000000000000
 210:	66 49 0f 6e cb       	movq   xmm1,r11
 215:	45 33 c0             	xor    r8d,r8d
 218:	66 0f 2e c1          	ucomisd xmm0,xmm1
 21c:	41 0f 94 c0          	sete   r8b
 220:	41 0f 9b c3          	setnp  r11b
 224:	45 20 d8             	and    r8b,r11b
 227:	44 8b c8             	mov    r9d,eax
 22a:	44 23 c9             	and    r9d,ecx
 22d:	45 85 c0             	test   r8d,r8d
 230:	41 0f 45 c1          	cmovne eax,r9d
 234:	83 c2 01             	add    edx,0x1
 237:	3b d6                	cmp    edx,esi
 239:	72 c2                	jb     1fd <float_condition+0xd>
 23b:	c3                   	ret
 23c:	cc                   	int3
 23d:	cc                   	int3
 23e:	cc                   	int3
 23f:	cc                   	int3

0000000000000240 <plain_reload>:
 240:	31 c0                	xor    eax,eax
 242:	48 8b c8             	mov    rcx,rax
 245:	48 8b c2             	mov    rax,rdx
 248:	eb 18                	jmp    262 <plain_reload+0x22>
 24a:	48 8b d1             	mov    rdx,rcx
 24d:	8b 14 97             	mov    edx,DWORD PTR [rdi+rdx*4]
 250:	44 8b c2             	mov    r8d,edx
 253:	41 83 e0 02          	and    r8d,0x2
 257:	23 d0                	and    edx,eax
 259:	45 85 c0             	test   r8d,r8d
 25c:	0f 45 c2             	cmovne eax,edx
 25f:	83 c1 01             	add    ecx,0x1
 262:	3b ce                	cmp    ecx,esi
 264:	72 e4                	jb     24a <plain_reload+0xa>
 266:	c3                   	ret
