
/home/david/Documents/Codex/2026-11-19/profile-and-improve-buster-compilation-speed/work/cast-evidence/loops/programs/64-8-zero.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <stream>:
   0:	31 c0                	xor    eax,eax
   2:	e9 a6 00 00 00       	jmp    ad <stream+0xad>
   7:	48 8b c8             	mov    rcx,rax
   a:	0f 57 c0             	xorps  xmm0,xmm0
   d:	f2 0f 5a 04 ce       	cvtsd2ss xmm0,QWORD PTR [rsi+rcx*8]
  12:	f3 0f 11 04 8f       	movss  DWORD PTR [rdi+rcx*4],xmm0
  17:	8d 48 01             	lea    ecx,[rax+0x1]
  1a:	44 8d 40 01          	lea    r8d,[rax+0x1]
  1e:	0f 57 c0             	xorps  xmm0,xmm0
  21:	f2 42 0f 5a 04 c6    	cvtsd2ss xmm0,QWORD PTR [rsi+r8*8]
  27:	f3 0f 11 04 8f       	movss  DWORD PTR [rdi+rcx*4],xmm0
  2c:	8d 48 02             	lea    ecx,[rax+0x2]
  2f:	44 8d 40 02          	lea    r8d,[rax+0x2]
  33:	0f 57 c0             	xorps  xmm0,xmm0
  36:	f2 42 0f 5a 04 c6    	cvtsd2ss xmm0,QWORD PTR [rsi+r8*8]
  3c:	f3 0f 11 04 8f       	movss  DWORD PTR [rdi+rcx*4],xmm0
  41:	8d 48 03             	lea    ecx,[rax+0x3]
  44:	44 8d 40 03          	lea    r8d,[rax+0x3]
  48:	0f 57 c0             	xorps  xmm0,xmm0
  4b:	f2 42 0f 5a 04 c6    	cvtsd2ss xmm0,QWORD PTR [rsi+r8*8]
  51:	f3 0f 11 04 8f       	movss  DWORD PTR [rdi+rcx*4],xmm0
  56:	8d 48 04             	lea    ecx,[rax+0x4]
  59:	44 8d 40 04          	lea    r8d,[rax+0x4]
  5d:	0f 57 c0             	xorps  xmm0,xmm0
  60:	f2 42 0f 5a 04 c6    	cvtsd2ss xmm0,QWORD PTR [rsi+r8*8]
  66:	f3 0f 11 04 8f       	movss  DWORD PTR [rdi+rcx*4],xmm0
  6b:	8d 48 05             	lea    ecx,[rax+0x5]
  6e:	44 8d 40 05          	lea    r8d,[rax+0x5]
  72:	0f 57 c0             	xorps  xmm0,xmm0
  75:	f2 42 0f 5a 04 c6    	cvtsd2ss xmm0,QWORD PTR [rsi+r8*8]
  7b:	f3 0f 11 04 8f       	movss  DWORD PTR [rdi+rcx*4],xmm0
  80:	8d 48 06             	lea    ecx,[rax+0x6]
  83:	44 8d 40 06          	lea    r8d,[rax+0x6]
  87:	0f 57 c0             	xorps  xmm0,xmm0
  8a:	f2 42 0f 5a 04 c6    	cvtsd2ss xmm0,QWORD PTR [rsi+r8*8]
  90:	f3 0f 11 04 8f       	movss  DWORD PTR [rdi+rcx*4],xmm0
  95:	8d 48 07             	lea    ecx,[rax+0x7]
  98:	44 8d 40 07          	lea    r8d,[rax+0x7]
  9c:	0f 57 c0             	xorps  xmm0,xmm0
  9f:	f2 42 0f 5a 04 c6    	cvtsd2ss xmm0,QWORD PTR [rsi+r8*8]
  a5:	f3 0f 11 04 8f       	movss  DWORD PTR [rdi+rcx*4],xmm0
  aa:	83 c0 08             	add    eax,0x8
  ad:	8b ca                	mov    ecx,edx
  af:	2b c8                	sub    ecx,eax
  b1:	83 f9 08             	cmp    ecx,0x8
  b4:	0f 83 4d ff ff ff    	jae    7 <stream+0x7>
  ba:	eb 13                	jmp    cf <stream+0xcf>
  bc:	48 8b c8             	mov    rcx,rax
  bf:	0f 57 c0             	xorps  xmm0,xmm0
  c2:	f2 0f 5a 04 ce       	cvtsd2ss xmm0,QWORD PTR [rsi+rcx*8]
  c7:	f3 0f 11 04 8f       	movss  DWORD PTR [rdi+rcx*4],xmm0
  cc:	83 c0 01             	add    eax,0x1
  cf:	3b c2                	cmp    eax,edx
  d1:	72 e9                	jb     bc <stream+0xbc>
  d3:	c3                   	ret
