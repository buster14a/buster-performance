
/home/david/Documents/Codex/2026-11-19/profile-and-improve-buster-compilation-speed/work/cast-evidence/loops/programs/32-8-nozero.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <stream>:
   0:	31 c0                	xor    eax,eax
   2:	e9 8e 00 00 00       	jmp    95 <stream+0x95>
   7:	48 8b c8             	mov    rcx,rax
   a:	f3 0f 5a 04 8e       	cvtss2sd xmm0,DWORD PTR [rsi+rcx*4]
   f:	f2 0f 11 04 cf       	movsd  QWORD PTR [rdi+rcx*8],xmm0
  14:	8d 48 01             	lea    ecx,[rax+0x1]
  17:	44 8d 40 01          	lea    r8d,[rax+0x1]
  1b:	f3 42 0f 5a 04 86    	cvtss2sd xmm0,DWORD PTR [rsi+r8*4]
  21:	f2 0f 11 04 cf       	movsd  QWORD PTR [rdi+rcx*8],xmm0
  26:	8d 48 02             	lea    ecx,[rax+0x2]
  29:	44 8d 40 02          	lea    r8d,[rax+0x2]
  2d:	f3 42 0f 5a 04 86    	cvtss2sd xmm0,DWORD PTR [rsi+r8*4]
  33:	f2 0f 11 04 cf       	movsd  QWORD PTR [rdi+rcx*8],xmm0
  38:	8d 48 03             	lea    ecx,[rax+0x3]
  3b:	44 8d 40 03          	lea    r8d,[rax+0x3]
  3f:	f3 42 0f 5a 04 86    	cvtss2sd xmm0,DWORD PTR [rsi+r8*4]
  45:	f2 0f 11 04 cf       	movsd  QWORD PTR [rdi+rcx*8],xmm0
  4a:	8d 48 04             	lea    ecx,[rax+0x4]
  4d:	44 8d 40 04          	lea    r8d,[rax+0x4]
  51:	f3 42 0f 5a 04 86    	cvtss2sd xmm0,DWORD PTR [rsi+r8*4]
  57:	f2 0f 11 04 cf       	movsd  QWORD PTR [rdi+rcx*8],xmm0
  5c:	8d 48 05             	lea    ecx,[rax+0x5]
  5f:	44 8d 40 05          	lea    r8d,[rax+0x5]
  63:	f3 42 0f 5a 04 86    	cvtss2sd xmm0,DWORD PTR [rsi+r8*4]
  69:	f2 0f 11 04 cf       	movsd  QWORD PTR [rdi+rcx*8],xmm0
  6e:	8d 48 06             	lea    ecx,[rax+0x6]
  71:	44 8d 40 06          	lea    r8d,[rax+0x6]
  75:	f3 42 0f 5a 04 86    	cvtss2sd xmm0,DWORD PTR [rsi+r8*4]
  7b:	f2 0f 11 04 cf       	movsd  QWORD PTR [rdi+rcx*8],xmm0
  80:	8d 48 07             	lea    ecx,[rax+0x7]
  83:	44 8d 40 07          	lea    r8d,[rax+0x7]
  87:	f3 42 0f 5a 04 86    	cvtss2sd xmm0,DWORD PTR [rsi+r8*4]
  8d:	f2 0f 11 04 cf       	movsd  QWORD PTR [rdi+rcx*8],xmm0
  92:	83 c0 08             	add    eax,0x8
  95:	8b ca                	mov    ecx,edx
  97:	2b c8                	sub    ecx,eax
  99:	83 f9 08             	cmp    ecx,0x8
  9c:	0f 83 65 ff ff ff    	jae    7 <stream+0x7>
  a2:	eb 10                	jmp    b4 <stream+0xb4>
  a4:	48 8b c8             	mov    rcx,rax
  a7:	f3 0f 5a 04 8e       	cvtss2sd xmm0,DWORD PTR [rsi+rcx*4]
  ac:	f2 0f 11 04 cf       	movsd  QWORD PTR [rdi+rcx*8],xmm0
  b1:	83 c0 01             	add    eax,0x1
  b4:	3b c2                	cmp    eax,edx
  b6:	72 ec                	jb     a4 <stream+0xa4>
  b8:	c3                   	ret
