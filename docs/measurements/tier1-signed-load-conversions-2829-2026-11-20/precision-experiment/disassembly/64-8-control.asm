
/home/david/Documents/Codex/2026-11-19/profile-and-improve-buster-compilation-speed/work/cast-evidence/loops/programs/64-8-control.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <stream>:
   0:	31 c0                	xor    eax,eax
   2:	e9 ae 00 00 00       	jmp    b5 <stream+0xb5>
   7:	48 8b c8             	mov    rcx,rax
   a:	f2 0f 10 04 ce       	movsd  xmm0,QWORD PTR [rsi+rcx*8]
   f:	f2 0f 5a c0          	cvtsd2ss xmm0,xmm0
  13:	f3 0f 11 04 8f       	movss  DWORD PTR [rdi+rcx*4],xmm0
  18:	8d 48 01             	lea    ecx,[rax+0x1]
  1b:	44 8d 40 01          	lea    r8d,[rax+0x1]
  1f:	f2 42 0f 10 04 c6    	movsd  xmm0,QWORD PTR [rsi+r8*8]
  25:	f2 0f 5a c0          	cvtsd2ss xmm0,xmm0
  29:	f3 0f 11 04 8f       	movss  DWORD PTR [rdi+rcx*4],xmm0
  2e:	8d 48 02             	lea    ecx,[rax+0x2]
  31:	44 8d 40 02          	lea    r8d,[rax+0x2]
  35:	f2 42 0f 10 04 c6    	movsd  xmm0,QWORD PTR [rsi+r8*8]
  3b:	f2 0f 5a c0          	cvtsd2ss xmm0,xmm0
  3f:	f3 0f 11 04 8f       	movss  DWORD PTR [rdi+rcx*4],xmm0
  44:	8d 48 03             	lea    ecx,[rax+0x3]
  47:	44 8d 40 03          	lea    r8d,[rax+0x3]
  4b:	f2 42 0f 10 04 c6    	movsd  xmm0,QWORD PTR [rsi+r8*8]
  51:	f2 0f 5a c0          	cvtsd2ss xmm0,xmm0
  55:	f3 0f 11 04 8f       	movss  DWORD PTR [rdi+rcx*4],xmm0
  5a:	8d 48 04             	lea    ecx,[rax+0x4]
  5d:	44 8d 40 04          	lea    r8d,[rax+0x4]
  61:	f2 42 0f 10 04 c6    	movsd  xmm0,QWORD PTR [rsi+r8*8]
  67:	f2 0f 5a c0          	cvtsd2ss xmm0,xmm0
  6b:	f3 0f 11 04 8f       	movss  DWORD PTR [rdi+rcx*4],xmm0
  70:	8d 48 05             	lea    ecx,[rax+0x5]
  73:	44 8d 40 05          	lea    r8d,[rax+0x5]
  77:	f2 42 0f 10 04 c6    	movsd  xmm0,QWORD PTR [rsi+r8*8]
  7d:	f2 0f 5a c0          	cvtsd2ss xmm0,xmm0
  81:	f3 0f 11 04 8f       	movss  DWORD PTR [rdi+rcx*4],xmm0
  86:	8d 48 06             	lea    ecx,[rax+0x6]
  89:	44 8d 40 06          	lea    r8d,[rax+0x6]
  8d:	f2 42 0f 10 04 c6    	movsd  xmm0,QWORD PTR [rsi+r8*8]
  93:	f2 0f 5a c0          	cvtsd2ss xmm0,xmm0
  97:	f3 0f 11 04 8f       	movss  DWORD PTR [rdi+rcx*4],xmm0
  9c:	8d 48 07             	lea    ecx,[rax+0x7]
  9f:	44 8d 40 07          	lea    r8d,[rax+0x7]
  a3:	f2 42 0f 10 04 c6    	movsd  xmm0,QWORD PTR [rsi+r8*8]
  a9:	f2 0f 5a c0          	cvtsd2ss xmm0,xmm0
  ad:	f3 0f 11 04 8f       	movss  DWORD PTR [rdi+rcx*4],xmm0
  b2:	83 c0 08             	add    eax,0x8
  b5:	8b ca                	mov    ecx,edx
  b7:	2b c8                	sub    ecx,eax
  b9:	83 f9 08             	cmp    ecx,0x8
  bc:	0f 83 45 ff ff ff    	jae    7 <stream+0x7>
  c2:	eb 14                	jmp    d8 <stream+0xd8>
  c4:	48 8b c8             	mov    rcx,rax
  c7:	f2 0f 10 04 ce       	movsd  xmm0,QWORD PTR [rsi+rcx*8]
  cc:	f2 0f 5a c0          	cvtsd2ss xmm0,xmm0
  d0:	f3 0f 11 04 8f       	movss  DWORD PTR [rdi+rcx*4],xmm0
  d5:	83 c0 01             	add    eax,0x1
  d8:	3b c2                	cmp    eax,edx
  da:	72 e8                	jb     c4 <stream+0xc4>
  dc:	c3                   	ret
