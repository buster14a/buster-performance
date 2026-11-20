/home/david/Documents/Codex/2026-11-19/profile-and-improve-buster-compilation-speed/work/unsigned64-evidence/checks/v4-default-head.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <uf>:
   0:	0f 57 c0             	xorps  xmm0,xmm0
   3:	62 f1 fe 08 7b c7    	vcvtusi2ss xmm0,xmm0,rdi
   9:	c3                   	ret
   a:	cc                   	int3
   b:	cc                   	int3
   c:	cc                   	int3
   d:	cc                   	int3
   e:	cc                   	int3
   f:	cc                   	int3

0000000000000010 <ud>:
  10:	0f 57 c0             	xorps  xmm0,xmm0
  13:	62 f1 ff 08 7b c7    	vcvtusi2sd xmm0,xmm0,rdi
  19:	c3                   	ret
  1a:	cc                   	int3
  1b:	cc                   	int3
  1c:	cc                   	int3
  1d:	cc                   	int3
  1e:	cc                   	int3
  1f:	cc                   	int3

0000000000000020 <fl>:
  20:	8b c6                	mov    eax,esi
  22:	48 8b 04 c7          	mov    rax,QWORD PTR [rdi+rax*8]
  26:	0f 57 c0             	xorps  xmm0,xmm0
  29:	62 f1 fe 08 7b c0    	vcvtusi2ss xmm0,xmm0,rax
  2f:	c3                   	ret

0000000000000030 <dl>:
  30:	8b c6                	mov    eax,esi
  32:	48 8b 04 c7          	mov    rax,QWORD PTR [rdi+rax*8]
  36:	0f 57 c0             	xorps  xmm0,xmm0
  39:	62 f1 ff 08 7b c0    	vcvtusi2sd xmm0,xmm0,rax
  3f:	c3                   	ret

0000000000000040 <fsel>:
  40:	85 d2                	test   edx,edx
  42:	74 0a                	je     4e <fsel+0xe>
  44:	0f 57 c0             	xorps  xmm0,xmm0
  47:	62 f1 fe 08 7b c7    	vcvtusi2ss xmm0,xmm0,rdi
  4d:	c3                   	ret
  4e:	0f 57 c0             	xorps  xmm0,xmm0
  51:	62 f1 fe 08 7b c6    	vcvtusi2ss xmm0,xmm0,rsi
  57:	c3                   	ret
  58:	cc                   	int3
  59:	cc                   	int3
  5a:	cc                   	int3
  5b:	cc                   	int3
  5c:	cc                   	int3
  5d:	cc                   	int3
  5e:	cc                   	int3
  5f:	cc                   	int3

0000000000000060 <dsel>:
  60:	85 d2                	test   edx,edx
  62:	74 0a                	je     6e <dsel+0xe>
  64:	0f 57 c0             	xorps  xmm0,xmm0
  67:	62 f1 ff 08 7b c7    	vcvtusi2sd xmm0,xmm0,rdi
  6d:	c3                   	ret
  6e:	0f 57 c0             	xorps  xmm0,xmm0
  71:	62 f1 ff 08 7b c6    	vcvtusi2sd xmm0,xmm0,rsi
  77:	c3                   	ret
  78:	cc                   	int3
  79:	cc                   	int3
  7a:	cc                   	int3
  7b:	cc                   	int3
  7c:	cc                   	int3
  7d:	cc                   	int3
  7e:	cc                   	int3
  7f:	cc                   	int3

0000000000000080 <both>:
  80:	48 8b 44 24 08       	mov    rax,QWORD PTR [rsp+0x8]
  85:	4c 8b 54 24 10       	mov    r10,QWORD PTR [rsp+0x10]
  8a:	4c 8b 5c 24 18       	mov    r11,QWORD PTR [rsp+0x18]
  8f:	4c 89 5c 24 f0       	mov    QWORD PTR [rsp-0x10],r11
  94:	4c 8b 5c 24 20       	mov    r11,QWORD PTR [rsp+0x20]
  99:	4c 89 5c 24 f8       	mov    QWORD PTR [rsp-0x8],r11
  9e:	48 33 fe             	xor    rdi,rsi
  a1:	48 33 fa             	xor    rdi,rdx
  a4:	48 33 f9             	xor    rdi,rcx
  a7:	49 33 f8             	xor    rdi,r8
  aa:	49 33 f9             	xor    rdi,r9
  ad:	48 33 f8             	xor    rdi,rax
  b0:	49 33 fa             	xor    rdi,r10
  b3:	0f 57 c0             	xorps  xmm0,xmm0
  b6:	62 f1 fe 08 7b c7    	vcvtusi2ss xmm0,xmm0,rdi
  bc:	48 8b 44 24 f0       	mov    rax,QWORD PTR [rsp-0x10]
  c1:	f3 0f 11 00          	movss  DWORD PTR [rax],xmm0
  c5:	0f 57 c0             	xorps  xmm0,xmm0
  c8:	62 f1 ff 08 7b c7    	vcvtusi2sd xmm0,xmm0,rdi
  ce:	48 8b 44 24 f8       	mov    rax,QWORD PTR [rsp-0x8]
  d3:	f2 0f 11 00          	movsd  QWORD PTR [rax],xmm0
  d7:	c3                   	ret
