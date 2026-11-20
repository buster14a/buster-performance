/home/david/Documents/Codex/2026-11-19/profile-and-improve-buster-compilation-speed/work/unsigned64-evidence/checks/znver5-default-clang.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <uf>:
   0:	62 f1 86 08 7b c7    	vcvtusi2ss xmm0,xmm15,rdi
   6:	c3                   	ret
   7:	90                   	nop

0000000000000008 <ud>:
   8:	62 f1 87 08 7b c7    	vcvtusi2sd xmm0,xmm15,rdi
   e:	c3                   	ret
   f:	90                   	nop

0000000000000010 <fl>:
  10:	89 f0                	mov    eax,esi
  12:	62 f1 86 08 7b 04 c7 	vcvtusi2ss xmm0,xmm15,QWORD PTR [rdi+rax*8]
  19:	c3                   	ret
  1a:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]

0000000000000020 <dl>:
  20:	89 f0                	mov    eax,esi
  22:	62 f1 87 08 7b 04 c7 	vcvtusi2sd xmm0,xmm15,QWORD PTR [rdi+rax*8]
  29:	c3                   	ret
  2a:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]

0000000000000030 <fsel>:
  30:	85 d2                	test   edx,edx
  32:	48 0f 44 fe          	cmove  rdi,rsi
  36:	62 f1 86 08 7b c7    	vcvtusi2ss xmm0,xmm15,rdi
  3c:	c3                   	ret
  3d:	0f 1f 00             	nop    DWORD PTR [rax]

0000000000000040 <dsel>:
  40:	85 d2                	test   edx,edx
  42:	48 0f 44 fe          	cmove  rdi,rsi
  46:	62 f1 87 08 7b c7    	vcvtusi2sd xmm0,xmm15,rdi
  4c:	c3                   	ret
  4d:	0f 1f 00             	nop    DWORD PTR [rax]

0000000000000050 <both>:
  50:	48 31 f7             	xor    rdi,rsi
  53:	48 31 ca             	xor    rdx,rcx
  56:	4d 31 c8             	xor    r8,r9
  59:	4c 8b 54 24 18       	mov    r10,QWORD PTR [rsp+0x18]
  5e:	48 8b 44 24 20       	mov    rax,QWORD PTR [rsp+0x20]
  63:	48 31 fa             	xor    rdx,rdi
  66:	49 31 d0             	xor    r8,rdx
  69:	4c 33 44 24 08       	xor    r8,QWORD PTR [rsp+0x8]
  6e:	4c 33 44 24 10       	xor    r8,QWORD PTR [rsp+0x10]
  73:	62 d1 86 08 7b c0    	vcvtusi2ss xmm0,xmm15,r8
  79:	c4 c1 7a 11 02       	vmovss DWORD PTR [r10],xmm0
  7e:	62 d1 87 08 7b c0    	vcvtusi2sd xmm0,xmm15,r8
  84:	c5 fb 11 00          	vmovsd QWORD PTR [rax],xmm0
  88:	c3                   	ret
