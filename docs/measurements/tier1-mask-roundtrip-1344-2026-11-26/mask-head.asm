
build/issue-1344/mask-head.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <mask_blend>:
   0:	62 f1 7e 48 6f 06    	vmovdqu32 zmm0,ZMMWORD PTR [rsi]
   6:	62 f1 7e 48 6f 0a    	vmovdqu32 zmm1,ZMMWORD PTR [rdx]
   c:	62 f1 7e 48 6f 11    	vmovdqu32 zmm2,ZMMWORD PTR [rcx]
  12:	62 f3 7d 48 3f c9 00 	vpcmpeqb k1,zmm0,zmm1
  19:	62 f2 7d 49 66 d2    	vpblendmb zmm2{k1},zmm0,zmm2
  1f:	62 f1 7e 48 7f 17    	vmovdqu32 ZMMWORD PTR [rdi],zmm2
  25:	c5 f8 77             	vzeroupper
  28:	c3                   	ret
  29:	cc                   	int3
  2a:	cc                   	int3
  2b:	cc                   	int3
  2c:	cc                   	int3
  2d:	cc                   	int3
  2e:	cc                   	int3
  2f:	cc                   	int3

0000000000000030 <mask_compress>:
  30:	62 f1 7e 48 6f 06    	vmovdqu32 zmm0,ZMMWORD PTR [rsi]
  36:	62 f1 7e 48 6f 0a    	vmovdqu32 zmm1,ZMMWORD PTR [rdx]
  3c:	62 f3 7d 48 3f c9 00 	vpcmpeqb k1,zmm0,zmm1
  43:	62 f1 75 48 ef c9    	vpxord zmm1,zmm1,zmm1
  49:	62 f2 7d 49 63 c1    	vpcompressb zmm1{k1},zmm0
  4f:	62 f1 7e 48 7f 0f    	vmovdqu32 ZMMWORD PTR [rdi],zmm1
  55:	c5 f8 77             	vzeroupper
  58:	c3                   	ret
  59:	cc                   	int3
  5a:	cc                   	int3
  5b:	cc                   	int3
  5c:	cc                   	int3
  5d:	cc                   	int3
  5e:	cc                   	int3
  5f:	cc                   	int3

0000000000000060 <lane0>:
  60:	55                   	push   rbp
  61:	48 89 e5             	mov    rbp,rsp
  64:	48 83 ec 40          	sub    rsp,0x40
  68:	48 83 e4 c0          	and    rsp,0xffffffffffffffc0
  6c:	48 c7 04 24 00 00 00 	mov    QWORD PTR [rsp],0x0
  73:	00 
  74:	48 c7 44 24 08 00 00 	mov    QWORD PTR [rsp+0x8],0x0
  7b:	00 00 
  7d:	48 c7 44 24 10 00 00 	mov    QWORD PTR [rsp+0x10],0x0
  84:	00 00 
  86:	48 c7 44 24 18 00 00 	mov    QWORD PTR [rsp+0x18],0x0
  8d:	00 00 
  8f:	48 c7 44 24 20 00 00 	mov    QWORD PTR [rsp+0x20],0x0
  96:	00 00 
  98:	48 c7 44 24 28 00 00 	mov    QWORD PTR [rsp+0x28],0x0
  9f:	00 00 
  a1:	48 c7 44 24 30 00 00 	mov    QWORD PTR [rsp+0x30],0x0
  a8:	00 00 
  aa:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
  b1:	00 00 
  b3:	48 89 34 24          	mov    QWORD PTR [rsp],rsi
  b7:	62 f1 7e 48 6f 04 24 	vmovdqu32 zmm0,ZMMWORD PTR [rsp]
  be:	62 f1 7e 48 7f 07    	vmovdqu32 ZMMWORD PTR [rdi],zmm0
  c4:	c5 f8 77             	vzeroupper
  c7:	48 89 ec             	mov    rsp,rbp
  ca:	5d                   	pop    rbp
  cb:	c3                   	ret
  cc:	cc                   	int3
  cd:	cc                   	int3
  ce:	cc                   	int3
  cf:	cc                   	int3

00000000000000d0 <distinct>:
  d0:	55                   	push   rbp
  d1:	48 89 e5             	mov    rbp,rsp
  d4:	48 83 ec 40          	sub    rsp,0x40
  d8:	48 83 e4 c0          	and    rsp,0xffffffffffffffc0
  dc:	48 c7 04 24 00 00 00 	mov    QWORD PTR [rsp],0x0
  e3:	00 
  e4:	48 c7 44 24 08 00 00 	mov    QWORD PTR [rsp+0x8],0x0
  eb:	00 00 
  ed:	48 c7 44 24 10 00 00 	mov    QWORD PTR [rsp+0x10],0x0
  f4:	00 00 
  f6:	48 c7 44 24 18 00 00 	mov    QWORD PTR [rsp+0x18],0x0
  fd:	00 00 
  ff:	48 c7 44 24 20 00 00 	mov    QWORD PTR [rsp+0x20],0x0
 106:	00 00 
 108:	48 c7 44 24 28 00 00 	mov    QWORD PTR [rsp+0x28],0x0
 10f:	00 00 
 111:	48 c7 44 24 30 00 00 	mov    QWORD PTR [rsp+0x30],0x0
 118:	00 00 
 11a:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
 121:	00 00 
 123:	48 89 34 24          	mov    QWORD PTR [rsp],rsi
 127:	48 89 54 24 08       	mov    QWORD PTR [rsp+0x8],rdx
 12c:	48 89 74 24 10       	mov    QWORD PTR [rsp+0x10],rsi
 131:	48 89 54 24 18       	mov    QWORD PTR [rsp+0x18],rdx
 136:	48 89 74 24 20       	mov    QWORD PTR [rsp+0x20],rsi
 13b:	48 89 54 24 28       	mov    QWORD PTR [rsp+0x28],rdx
 140:	48 89 74 24 30       	mov    QWORD PTR [rsp+0x30],rsi
 145:	48 89 54 24 38       	mov    QWORD PTR [rsp+0x38],rdx
 14a:	62 f1 7e 48 6f 04 24 	vmovdqu32 zmm0,ZMMWORD PTR [rsp]
 151:	62 f1 7e 48 7f 07    	vmovdqu32 ZMMWORD PTR [rdi],zmm0
 157:	c5 f8 77             	vzeroupper
 15a:	48 89 ec             	mov    rsp,rbp
 15d:	5d                   	pop    rbp
 15e:	c3                   	ret
