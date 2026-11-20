/home/david/Documents/Codex/2026-11-19/profile-and-improve-buster-compilation-speed/work/unsigned64-evidence/checks/znver5-default-parent.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <uf>:
   0:	4c 8d 1c 3f          	lea    r11,[rdi+rdi*1]
   4:	41 83 e3 02          	and    r11d,0x2
   8:	4c 0b df             	or     r11,rdi
   b:	49 c1 eb 01          	shr    r11,0x1
   f:	48 85 ff             	test   rdi,rdi
  12:	4c 0f 49 df          	cmovns r11,rdi
  16:	0f 57 c0             	xorps  xmm0,xmm0
  19:	f3 49 0f 2a c3       	cvtsi2ss xmm0,r11
  1e:	4c 8b df             	mov    r11,rdi
  21:	49 c1 eb 3f          	shr    r11,0x3f
  25:	49 c1 e3 17          	shl    r11,0x17
  29:	66 45 0f 6e fb       	movd   xmm15,r11d
  2e:	66 41 0f fe c7       	paddd  xmm0,xmm15
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

0000000000000040 <ud>:
  40:	4c 8d 1c 3f          	lea    r11,[rdi+rdi*1]
  44:	41 83 e3 02          	and    r11d,0x2
  48:	4c 0b df             	or     r11,rdi
  4b:	49 c1 eb 01          	shr    r11,0x1
  4f:	48 85 ff             	test   rdi,rdi
  52:	4c 0f 49 df          	cmovns r11,rdi
  56:	0f 57 c0             	xorps  xmm0,xmm0
  59:	f2 49 0f 2a c3       	cvtsi2sd xmm0,r11
  5e:	4c 8b df             	mov    r11,rdi
  61:	49 c1 eb 3f          	shr    r11,0x3f
  65:	49 c1 e3 34          	shl    r11,0x34
  69:	66 4d 0f 6e fb       	movq   xmm15,r11
  6e:	66 41 0f d4 c7       	paddq  xmm0,xmm15
  73:	c3                   	ret
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

0000000000000080 <fl>:
  80:	8b c6                	mov    eax,esi
  82:	48 8b 04 c7          	mov    rax,QWORD PTR [rdi+rax*8]
  86:	4c 8d 1c 00          	lea    r11,[rax+rax*1]
  8a:	41 83 e3 02          	and    r11d,0x2
  8e:	4c 0b d8             	or     r11,rax
  91:	49 c1 eb 01          	shr    r11,0x1
  95:	48 85 c0             	test   rax,rax
  98:	4c 0f 49 d8          	cmovns r11,rax
  9c:	0f 57 c0             	xorps  xmm0,xmm0
  9f:	f3 49 0f 2a c3       	cvtsi2ss xmm0,r11
  a4:	4c 8b d8             	mov    r11,rax
  a7:	49 c1 eb 3f          	shr    r11,0x3f
  ab:	49 c1 e3 17          	shl    r11,0x17
  af:	66 45 0f 6e fb       	movd   xmm15,r11d
  b4:	66 41 0f fe c7       	paddd  xmm0,xmm15
  b9:	c3                   	ret
  ba:	cc                   	int3
  bb:	cc                   	int3
  bc:	cc                   	int3
  bd:	cc                   	int3
  be:	cc                   	int3
  bf:	cc                   	int3

00000000000000c0 <dl>:
  c0:	8b c6                	mov    eax,esi
  c2:	48 8b 04 c7          	mov    rax,QWORD PTR [rdi+rax*8]
  c6:	4c 8d 1c 00          	lea    r11,[rax+rax*1]
  ca:	41 83 e3 02          	and    r11d,0x2
  ce:	4c 0b d8             	or     r11,rax
  d1:	49 c1 eb 01          	shr    r11,0x1
  d5:	48 85 c0             	test   rax,rax
  d8:	4c 0f 49 d8          	cmovns r11,rax
  dc:	0f 57 c0             	xorps  xmm0,xmm0
  df:	f2 49 0f 2a c3       	cvtsi2sd xmm0,r11
  e4:	4c 8b d8             	mov    r11,rax
  e7:	49 c1 eb 3f          	shr    r11,0x3f
  eb:	49 c1 e3 34          	shl    r11,0x34
  ef:	66 4d 0f 6e fb       	movq   xmm15,r11
  f4:	66 41 0f d4 c7       	paddq  xmm0,xmm15
  f9:	c3                   	ret
  fa:	cc                   	int3
  fb:	cc                   	int3
  fc:	cc                   	int3
  fd:	cc                   	int3
  fe:	cc                   	int3
  ff:	cc                   	int3

0000000000000100 <fsel>:
 100:	85 d2                	test   edx,edx
 102:	74 34                	je     138 <fsel+0x38>
 104:	4c 8d 1c 3f          	lea    r11,[rdi+rdi*1]
 108:	41 83 e3 02          	and    r11d,0x2
 10c:	4c 0b df             	or     r11,rdi
 10f:	49 c1 eb 01          	shr    r11,0x1
 113:	48 85 ff             	test   rdi,rdi
 116:	4c 0f 49 df          	cmovns r11,rdi
 11a:	0f 57 c0             	xorps  xmm0,xmm0
 11d:	f3 49 0f 2a c3       	cvtsi2ss xmm0,r11
 122:	4c 8b df             	mov    r11,rdi
 125:	49 c1 eb 3f          	shr    r11,0x3f
 129:	49 c1 e3 17          	shl    r11,0x17
 12d:	66 45 0f 6e fb       	movd   xmm15,r11d
 132:	66 41 0f fe c7       	paddd  xmm0,xmm15
 137:	c3                   	ret
 138:	4c 8d 1c 36          	lea    r11,[rsi+rsi*1]
 13c:	41 83 e3 02          	and    r11d,0x2
 140:	4c 0b de             	or     r11,rsi
 143:	49 c1 eb 01          	shr    r11,0x1
 147:	48 85 f6             	test   rsi,rsi
 14a:	4c 0f 49 de          	cmovns r11,rsi
 14e:	0f 57 c0             	xorps  xmm0,xmm0
 151:	f3 49 0f 2a c3       	cvtsi2ss xmm0,r11
 156:	4c 8b de             	mov    r11,rsi
 159:	49 c1 eb 3f          	shr    r11,0x3f
 15d:	49 c1 e3 17          	shl    r11,0x17
 161:	66 45 0f 6e fb       	movd   xmm15,r11d
 166:	66 41 0f fe c7       	paddd  xmm0,xmm15
 16b:	c3                   	ret
 16c:	cc                   	int3
 16d:	cc                   	int3
 16e:	cc                   	int3
 16f:	cc                   	int3

0000000000000170 <dsel>:
 170:	85 d2                	test   edx,edx
 172:	74 34                	je     1a8 <dsel+0x38>
 174:	4c 8d 1c 3f          	lea    r11,[rdi+rdi*1]
 178:	41 83 e3 02          	and    r11d,0x2
 17c:	4c 0b df             	or     r11,rdi
 17f:	49 c1 eb 01          	shr    r11,0x1
 183:	48 85 ff             	test   rdi,rdi
 186:	4c 0f 49 df          	cmovns r11,rdi
 18a:	0f 57 c0             	xorps  xmm0,xmm0
 18d:	f2 49 0f 2a c3       	cvtsi2sd xmm0,r11
 192:	4c 8b df             	mov    r11,rdi
 195:	49 c1 eb 3f          	shr    r11,0x3f
 199:	49 c1 e3 34          	shl    r11,0x34
 19d:	66 4d 0f 6e fb       	movq   xmm15,r11
 1a2:	66 41 0f d4 c7       	paddq  xmm0,xmm15
 1a7:	c3                   	ret
 1a8:	4c 8d 1c 36          	lea    r11,[rsi+rsi*1]
 1ac:	41 83 e3 02          	and    r11d,0x2
 1b0:	4c 0b de             	or     r11,rsi
 1b3:	49 c1 eb 01          	shr    r11,0x1
 1b7:	48 85 f6             	test   rsi,rsi
 1ba:	4c 0f 49 de          	cmovns r11,rsi
 1be:	0f 57 c0             	xorps  xmm0,xmm0
 1c1:	f2 49 0f 2a c3       	cvtsi2sd xmm0,r11
 1c6:	4c 8b de             	mov    r11,rsi
 1c9:	49 c1 eb 3f          	shr    r11,0x3f
 1cd:	49 c1 e3 34          	shl    r11,0x34
 1d1:	66 4d 0f 6e fb       	movq   xmm15,r11
 1d6:	66 41 0f d4 c7       	paddq  xmm0,xmm15
 1db:	c3                   	ret
 1dc:	cc                   	int3
 1dd:	cc                   	int3
 1de:	cc                   	int3
 1df:	cc                   	int3

00000000000001e0 <both>:
 1e0:	48 8b 44 24 08       	mov    rax,QWORD PTR [rsp+0x8]
 1e5:	4c 8b 54 24 10       	mov    r10,QWORD PTR [rsp+0x10]
 1ea:	4c 8b 5c 24 18       	mov    r11,QWORD PTR [rsp+0x18]
 1ef:	4c 89 5c 24 f0       	mov    QWORD PTR [rsp-0x10],r11
 1f4:	4c 8b 5c 24 20       	mov    r11,QWORD PTR [rsp+0x20]
 1f9:	4c 89 5c 24 f8       	mov    QWORD PTR [rsp-0x8],r11
 1fe:	48 33 fe             	xor    rdi,rsi
 201:	48 33 fa             	xor    rdi,rdx
 204:	48 33 f9             	xor    rdi,rcx
 207:	49 33 f8             	xor    rdi,r8
 20a:	49 33 f9             	xor    rdi,r9
 20d:	48 33 f8             	xor    rdi,rax
 210:	49 33 fa             	xor    rdi,r10
 213:	4c 8d 1c 3f          	lea    r11,[rdi+rdi*1]
 217:	41 83 e3 02          	and    r11d,0x2
 21b:	4c 0b df             	or     r11,rdi
 21e:	49 c1 eb 01          	shr    r11,0x1
 222:	48 85 ff             	test   rdi,rdi
 225:	4c 0f 49 df          	cmovns r11,rdi
 229:	0f 57 c0             	xorps  xmm0,xmm0
 22c:	f3 49 0f 2a c3       	cvtsi2ss xmm0,r11
 231:	4c 8b df             	mov    r11,rdi
 234:	49 c1 eb 3f          	shr    r11,0x3f
 238:	49 c1 e3 17          	shl    r11,0x17
 23c:	66 45 0f 6e fb       	movd   xmm15,r11d
 241:	66 41 0f fe c7       	paddd  xmm0,xmm15
 246:	48 8b 44 24 f0       	mov    rax,QWORD PTR [rsp-0x10]
 24b:	f3 0f 11 00          	movss  DWORD PTR [rax],xmm0
 24f:	4c 8d 1c 3f          	lea    r11,[rdi+rdi*1]
 253:	41 83 e3 02          	and    r11d,0x2
 257:	4c 0b df             	or     r11,rdi
 25a:	49 c1 eb 01          	shr    r11,0x1
 25e:	48 85 ff             	test   rdi,rdi
 261:	4c 0f 49 df          	cmovns r11,rdi
 265:	0f 57 c0             	xorps  xmm0,xmm0
 268:	f2 49 0f 2a c3       	cvtsi2sd xmm0,r11
 26d:	4c 8b df             	mov    r11,rdi
 270:	49 c1 eb 3f          	shr    r11,0x3f
 274:	49 c1 e3 34          	shl    r11,0x34
 278:	66 4d 0f 6e fb       	movq   xmm15,r11
 27d:	66 41 0f d4 c7       	paddq  xmm0,xmm15
 282:	48 8b 44 24 f8       	mov    rax,QWORD PTR [rsp-0x8]
 287:	f2 0f 11 00          	movsd  QWORD PTR [rax],xmm0
 28b:	c3                   	ret
