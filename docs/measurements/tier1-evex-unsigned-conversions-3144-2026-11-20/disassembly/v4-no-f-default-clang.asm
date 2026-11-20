/home/david/Documents/Codex/2026-11-19/profile-and-improve-buster-compilation-speed/work/unsigned64-evidence/checks/v4-no-f-default-clang.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <uf>:
   0:	48 89 f8             	mov    rax,rdi
   3:	48 d1 e8             	shr    rax,1
   6:	89 f9                	mov    ecx,edi
   8:	83 e1 01             	and    ecx,0x1
   b:	48 09 c1             	or     rcx,rax
   e:	48 85 ff             	test   rdi,rdi
  11:	48 0f 49 cf          	cmovns rcx,rdi
  15:	c4 e1 82 2a c1       	vcvtsi2ss xmm0,xmm15,rcx
  1a:	79 04                	jns    20 <uf+0x20>
  1c:	c5 fa 58 c0          	vaddss xmm0,xmm0,xmm0
  20:	c3                   	ret
  21:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
  28:	0f 1f 84 00 00 00 00
  2f:	00

0000000000000030 <ud>:
  30:	48 89 f8             	mov    rax,rdi
  33:	48 d1 e8             	shr    rax,1
  36:	89 f9                	mov    ecx,edi
  38:	83 e1 01             	and    ecx,0x1
  3b:	48 09 c1             	or     rcx,rax
  3e:	48 85 ff             	test   rdi,rdi
  41:	48 0f 49 cf          	cmovns rcx,rdi
  45:	c4 e1 83 2a c1       	vcvtsi2sd xmm0,xmm15,rcx
  4a:	79 04                	jns    50 <ud+0x20>
  4c:	c5 fb 58 c0          	vaddsd xmm0,xmm0,xmm0
  50:	c3                   	ret
  51:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
  58:	0f 1f 84 00 00 00 00
  5f:	00

0000000000000060 <fl>:
  60:	89 f0                	mov    eax,esi
  62:	48 8b 04 c7          	mov    rax,QWORD PTR [rdi+rax*8]
  66:	48 89 c1             	mov    rcx,rax
  69:	48 d1 e9             	shr    rcx,1
  6c:	89 c2                	mov    edx,eax
  6e:	83 e2 01             	and    edx,0x1
  71:	48 09 ca             	or     rdx,rcx
  74:	48 85 c0             	test   rax,rax
  77:	48 0f 49 d0          	cmovns rdx,rax
  7b:	c4 e1 82 2a c2       	vcvtsi2ss xmm0,xmm15,rdx
  80:	79 04                	jns    86 <fl+0x26>
  82:	c5 fa 58 c0          	vaddss xmm0,xmm0,xmm0
  86:	c3                   	ret
  87:	66 0f 1f 84 00 00 00 	nop    WORD PTR [rax+rax*1+0x0]
  8e:	00 00

0000000000000090 <dl>:
  90:	89 f0                	mov    eax,esi
  92:	48 8b 04 c7          	mov    rax,QWORD PTR [rdi+rax*8]
  96:	48 89 c1             	mov    rcx,rax
  99:	48 d1 e9             	shr    rcx,1
  9c:	89 c2                	mov    edx,eax
  9e:	83 e2 01             	and    edx,0x1
  a1:	48 09 ca             	or     rdx,rcx
  a4:	48 85 c0             	test   rax,rax
  a7:	48 0f 49 d0          	cmovns rdx,rax
  ab:	c4 e1 83 2a c2       	vcvtsi2sd xmm0,xmm15,rdx
  b0:	79 04                	jns    b6 <dl+0x26>
  b2:	c5 fb 58 c0          	vaddsd xmm0,xmm0,xmm0
  b6:	c3                   	ret
  b7:	66 0f 1f 84 00 00 00 	nop    WORD PTR [rax+rax*1+0x0]
  be:	00 00

00000000000000c0 <fsel>:
  c0:	85 d2                	test   edx,edx
  c2:	48 0f 44 fe          	cmove  rdi,rsi
  c6:	48 89 f8             	mov    rax,rdi
  c9:	48 d1 e8             	shr    rax,1
  cc:	89 f9                	mov    ecx,edi
  ce:	83 e1 01             	and    ecx,0x1
  d1:	48 09 c1             	or     rcx,rax
  d4:	48 85 ff             	test   rdi,rdi
  d7:	48 0f 49 cf          	cmovns rcx,rdi
  db:	c4 e1 82 2a c1       	vcvtsi2ss xmm0,xmm15,rcx
  e0:	79 04                	jns    e6 <fsel+0x26>
  e2:	c5 fa 58 c0          	vaddss xmm0,xmm0,xmm0
  e6:	c3                   	ret
  e7:	66 0f 1f 84 00 00 00 	nop    WORD PTR [rax+rax*1+0x0]
  ee:	00 00

00000000000000f0 <dsel>:
  f0:	85 d2                	test   edx,edx
  f2:	48 0f 44 fe          	cmove  rdi,rsi
  f6:	48 89 f8             	mov    rax,rdi
  f9:	48 d1 e8             	shr    rax,1
  fc:	89 f9                	mov    ecx,edi
  fe:	83 e1 01             	and    ecx,0x1
 101:	48 09 c1             	or     rcx,rax
 104:	48 85 ff             	test   rdi,rdi
 107:	48 0f 49 cf          	cmovns rcx,rdi
 10b:	c4 e1 83 2a c1       	vcvtsi2sd xmm0,xmm15,rcx
 110:	79 04                	jns    116 <dsel+0x26>
 112:	c5 fb 58 c0          	vaddsd xmm0,xmm0,xmm0
 116:	c3                   	ret
 117:	66 0f 1f 84 00 00 00 	nop    WORD PTR [rax+rax*1+0x0]
 11e:	00 00

0000000000000120 <both>:
 120:	48 8b 44 24 18       	mov    rax,QWORD PTR [rsp+0x18]
 125:	48 31 f7             	xor    rdi,rsi
 128:	48 31 ca             	xor    rdx,rcx
 12b:	48 31 fa             	xor    rdx,rdi
 12e:	4d 31 c8             	xor    r8,r9
 131:	49 31 d0             	xor    r8,rdx
 134:	4c 33 44 24 08       	xor    r8,QWORD PTR [rsp+0x8]
 139:	4c 33 44 24 10       	xor    r8,QWORD PTR [rsp+0x10]
 13e:	4c 89 c2             	mov    rdx,r8
 141:	48 d1 ea             	shr    rdx,1
 144:	44 89 c1             	mov    ecx,r8d
 147:	83 e1 01             	and    ecx,0x1
 14a:	48 09 d1             	or     rcx,rdx
 14d:	4d 85 c0             	test   r8,r8
 150:	49 0f 49 c8          	cmovns rcx,r8
 154:	c4 e1 82 2a c1       	vcvtsi2ss xmm0,xmm15,rcx
 159:	79 04                	jns    15f <both+0x3f>
 15b:	c5 fa 58 c0          	vaddss xmm0,xmm0,xmm0
 15f:	48 8b 54 24 20       	mov    rdx,QWORD PTR [rsp+0x20]
 164:	c5 fa 11 00          	vmovss DWORD PTR [rax],xmm0
 168:	c4 e1 83 2a c1       	vcvtsi2sd xmm0,xmm15,rcx
 16d:	79 04                	jns    173 <both+0x53>
 16f:	c5 fb 58 c0          	vaddsd xmm0,xmm0,xmm0
 173:	c5 fb 11 02          	vmovsd QWORD PTR [rdx],xmm0
 177:	c3                   	ret
