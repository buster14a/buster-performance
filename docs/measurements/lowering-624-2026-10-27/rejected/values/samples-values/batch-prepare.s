
values/build/compiler:     file format elf64-x86-64


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

00000000008d9430 <check_lower_batch_prepare>:
  8d9430:	48 8b 07             	mov    (%rdi),%rax
  8d9433:	83 e2 f0             	and    $0xfffffff0,%edx
  8d9436:	62 f1 fd 48 6f 05 40 	vmovdqa64 -0x431cc0(%rip),%zmm0        # 4a7780 <cbuiltin_test_generated.edges+0xb0f0>
  8d943d:	e3 bc ff 
  8d9440:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
  8d9444:	62 f2 7d 48 58 15 12 	vpbroadcastd -0x31cbee(%rip),%zmm2        # 5bc860 <check_test_initializer_nesting.timed+0x508>
  8d944b:	34 ce ff 
  8d944e:	62 f3 5d 48 25 e4 ff 	vpternlogd $0xff,%zmm4,%zmm4,%zmm4
  8d9455:	4c 8d 14 52          	lea    (%rdx,%rdx,2),%r10
  8d9459:	4c 8b 40 08          	mov    0x8(%rax),%r8
  8d945d:	48 8b 08             	mov    (%rax),%rcx
  8d9460:	89 96 c8 00 00 00    	mov    %edx,0xc8(%rsi)
  8d9466:	b8 10 00 00 00       	mov    $0x10,%eax
  8d946b:	45 8b 88 a0 00 00 00 	mov    0xa0(%r8),%r9d
  8d9472:	48 8b 09             	mov    (%rcx),%rcx
  8d9475:	41 29 d1             	sub    %edx,%r9d
  8d9478:	41 83 f9 10          	cmp    $0x10,%r9d
  8d947c:	41 0f 42 c1          	cmovb  %r9d,%eax
  8d9480:	41 b9 ff ff ff ff    	mov    $0xffffffff,%r9d
  8d9486:	49 c1 e2 05          	shl    $0x5,%r10
  8d948a:	4d 03 50 08          	add    0x8(%r8),%r10
  8d948e:	4c 8b 87 a8 01 00 00 	mov    0x1a8(%rdi),%r8
  8d9495:	c4 42 79 f7 c9       	shlx   %eax,%r9d,%r9d
  8d949a:	41 f7 d1             	not    %r9d
  8d949d:	c4 c1 7b 92 c9       	kmovd  %r9d,%k1
  8d94a2:	c4 e1 f8 90 d1       	kmovq  %k1,%k2
  8d94a7:	62 f1 7e c9 6f 34 91 	vmovdqu32 (%rcx,%rdx,4),%zmm6{%k1}{z}
  8d94ae:	62 d2 7d 4a 90 0c 02 	vpgatherdd (%r10,%zmm0,1),%zmm1{%k2}
  8d94b5:	62 f1 7d 48 72 d1 03 	vpsrld $0x3,%zmm1,%zmm0
  8d94bc:	62 f3 7d 59 1e 57 6c 	vpcmpltud 0x1b0(%rdi){1to16},%zmm0,%k2{%k1}
  8d94c3:	01 
  8d94c4:	62 f2 7e 48 31 f3    	vpmovdb %zmm6,%xmm3
  8d94ca:	62 f2 65 48 8d 1d ec 	vpermb -0x431d14(%rip),%zmm3,%zmm3        # 4a77c0 <cbuiltin_test_generated.edges+0xb130>
  8d94d1:	e2 bc ff 
  8d94d4:	62 d2 7d 4a 90 14 80 	vpgatherdd (%r8,%zmm0,4),%zmm2{%k2}
  8d94db:	62 f1 6d 58 db 2d 7b 	vpandd -0x31cc85(%rip){1to16},%zmm2,%zmm5        # 5bc860 <check_test_initializer_nesting.timed+0x508>
  8d94e2:	33 ce ff 
  8d94e5:	62 f3 4d 59 1e 15 74 	vpcmpltud -0x31cc8c(%rip){1to16},%zmm6,%k2{%k1}        # 5bc864 <check_test_initializer_nesting.timed+0x50c>
  8d94ec:	33 ce ff 01 
  8d94f0:	62 f1 55 48 fe e4    	vpaddd %zmm4,%zmm5,%zmm4
  8d94f6:	62 f3 5d 58 1e 1d 67 	vpcmpltud -0x31cc99(%rip){1to16},%zmm4,%k3        # 5bc868 <check_test_initializer_nesting.timed+0x510>
  8d94fd:	33 ce ff 01 
  8d9501:	62 f2 7d aa 30 db    	vpmovzxbw %xmm3,%ymm3{%k2}{z}
  8d9507:	62 f2 6e 5b 27 05 5b 	vptestnmd -0x31cca5(%rip){1to16},%zmm2,%k0{%k3}        # 5bc86c <check_test_initializer_nesting.timed+0x514>
  8d950e:	33 ce ff 
  8d9511:	c5 fb 93 c8          	kmovd  %k0,%ecx
  8d9515:	c4 e2 78 f5 c9       	bzhi   %eax,%ecx,%ecx
  8d951a:	0f b7 c9             	movzwl %cx,%ecx
  8d951d:	48 89 8e c0 00 00 00 	mov    %rcx,0xc0(%rsi)
  8d9524:	62 f1 ff 29 7f 1e    	vmovdqu16 %ymm3,(%rsi){%k1}
  8d952a:	62 f2 7e 49 33 6e 01 	vpmovdw %zmm5,0x20(%rsi){%k1}
  8d9531:	62 f1 7e 49 7f 4e 01 	vmovdqu32 %zmm1,0x40(%rsi){%k1}
  8d9538:	62 f1 7e 49 7f 56 02 	vmovdqu32 %zmm2,0x80(%rsi){%k1}
  8d953f:	48 01 87 50 05 00 00 	add    %rax,0x550(%rdi)
  8d9546:	c5 f8 77             	vzeroupper
  8d9549:	c3                   	ret
