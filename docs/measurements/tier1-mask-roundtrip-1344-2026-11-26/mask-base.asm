
build/issue-1344/mask-base.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <mask_blend>:
   0:	62 f1 7e 48 6f 06    	vmovdqu32 zmm0,ZMMWORD PTR [rsi]
   6:	62 f1 7e 48 6f 0a    	vmovdqu32 zmm1,ZMMWORD PTR [rdx]
   c:	62 f1 7e 48 6f 11    	vmovdqu32 zmm2,ZMMWORD PTR [rcx]
  12:	62 f3 7d 48 3f c9 00 	vpcmpeqb k1,zmm0,zmm1
  19:	c4 e1 fb 93 c1       	kmovq  rax,k1
  1e:	c4 e1 fb 92 c8       	kmovq  k1,rax
  23:	62 f2 7d 49 66 d2    	vpblendmb zmm2{k1},zmm0,zmm2
  29:	62 f1 7e 48 7f 17    	vmovdqu32 ZMMWORD PTR [rdi],zmm2
  2f:	c5 f8 77             	vzeroupper
  32:	c3                   	ret
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

0000000000000040 <mask_compress>:
  40:	62 f1 7e 48 6f 06    	vmovdqu32 zmm0,ZMMWORD PTR [rsi]
  46:	62 f1 7e 48 6f 0a    	vmovdqu32 zmm1,ZMMWORD PTR [rdx]
  4c:	62 f3 7d 48 3f c9 00 	vpcmpeqb k1,zmm0,zmm1
  53:	c4 e1 fb 93 c1       	kmovq  rax,k1
  58:	62 f1 75 48 ef c9    	vpxord zmm1,zmm1,zmm1
  5e:	c4 e1 fb 92 c8       	kmovq  k1,rax
  63:	62 f2 7d 49 63 c1    	vpcompressb zmm1{k1},zmm0
  69:	62 f1 7e 48 7f 0f    	vmovdqu32 ZMMWORD PTR [rdi],zmm1
  6f:	c5 f8 77             	vzeroupper
  72:	c3                   	ret
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

0000000000000080 <lane0>:
  80:	55                   	push   rbp
  81:	48 89 e5             	mov    rbp,rsp
  84:	48 83 ec 40          	sub    rsp,0x40
  88:	48 83 e4 c0          	and    rsp,0xffffffffffffffc0
  8c:	48 c7 04 24 00 00 00 	mov    QWORD PTR [rsp],0x0
  93:	00 
  94:	48 c7 44 24 08 00 00 	mov    QWORD PTR [rsp+0x8],0x0
  9b:	00 00 
  9d:	48 c7 44 24 10 00 00 	mov    QWORD PTR [rsp+0x10],0x0
  a4:	00 00 
  a6:	48 c7 44 24 18 00 00 	mov    QWORD PTR [rsp+0x18],0x0
  ad:	00 00 
  af:	48 c7 44 24 20 00 00 	mov    QWORD PTR [rsp+0x20],0x0
  b6:	00 00 
  b8:	48 c7 44 24 28 00 00 	mov    QWORD PTR [rsp+0x28],0x0
  bf:	00 00 
  c1:	48 c7 44 24 30 00 00 	mov    QWORD PTR [rsp+0x30],0x0
  c8:	00 00 
  ca:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
  d1:	00 00 
  d3:	48 89 34 24          	mov    QWORD PTR [rsp],rsi
  d7:	62 f1 7e 48 6f 04 24 	vmovdqu32 zmm0,ZMMWORD PTR [rsp]
  de:	62 f1 7e 48 7f 07    	vmovdqu32 ZMMWORD PTR [rdi],zmm0
  e4:	c5 f8 77             	vzeroupper
  e7:	48 89 ec             	mov    rsp,rbp
  ea:	5d                   	pop    rbp
  eb:	c3                   	ret
  ec:	cc                   	int3
  ed:	cc                   	int3
  ee:	cc                   	int3
  ef:	cc                   	int3

00000000000000f0 <distinct>:
  f0:	55                   	push   rbp
  f1:	48 89 e5             	mov    rbp,rsp
  f4:	48 83 ec 40          	sub    rsp,0x40
  f8:	48 83 e4 c0          	and    rsp,0xffffffffffffffc0
  fc:	48 c7 04 24 00 00 00 	mov    QWORD PTR [rsp],0x0
 103:	00 
 104:	48 c7 44 24 08 00 00 	mov    QWORD PTR [rsp+0x8],0x0
 10b:	00 00 
 10d:	48 c7 44 24 10 00 00 	mov    QWORD PTR [rsp+0x10],0x0
 114:	00 00 
 116:	48 c7 44 24 18 00 00 	mov    QWORD PTR [rsp+0x18],0x0
 11d:	00 00 
 11f:	48 c7 44 24 20 00 00 	mov    QWORD PTR [rsp+0x20],0x0
 126:	00 00 
 128:	48 c7 44 24 28 00 00 	mov    QWORD PTR [rsp+0x28],0x0
 12f:	00 00 
 131:	48 c7 44 24 30 00 00 	mov    QWORD PTR [rsp+0x30],0x0
 138:	00 00 
 13a:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
 141:	00 00 
 143:	48 89 34 24          	mov    QWORD PTR [rsp],rsi
 147:	48 89 54 24 08       	mov    QWORD PTR [rsp+0x8],rdx
 14c:	48 89 74 24 10       	mov    QWORD PTR [rsp+0x10],rsi
 151:	48 89 54 24 18       	mov    QWORD PTR [rsp+0x18],rdx
 156:	48 89 74 24 20       	mov    QWORD PTR [rsp+0x20],rsi
 15b:	48 89 54 24 28       	mov    QWORD PTR [rsp+0x28],rdx
 160:	48 89 74 24 30       	mov    QWORD PTR [rsp+0x30],rsi
 165:	48 89 54 24 38       	mov    QWORD PTR [rsp+0x38],rdx
 16a:	62 f1 7e 48 6f 04 24 	vmovdqu32 zmm0,ZMMWORD PTR [rsp]
 171:	62 f1 7e 48 7f 07    	vmovdqu32 ZMMWORD PTR [rdi],zmm0
 177:	c5 f8 77             	vzeroupper
 17a:	48 89 ec             	mov    rsp,rbp
 17d:	5d                   	pop    rbp
 17e:	c3                   	ret
