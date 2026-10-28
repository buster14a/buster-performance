
compact/build/compiler:     file format elf64-x86-64


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

00000000008d8c60 <check_lower_batch_prepare>:
  8d8c60:	48 8b 07             	mov    (%rdi),%rax
  8d8c63:	83 e2 f0             	and    $0xfffffff0,%edx
  8d8c66:	62 f1 fd 48 6f 05 10 	vmovdqa64 -0x4314f0(%rip),%zmm0        # 4a7780 <cbuiltin_test_generated.edges+0xb0f0>
  8d8c6d:	eb bc ff 
  8d8c70:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
  8d8c74:	62 f2 7d 48 58 15 62 	vpbroadcastd -0x31c49e(%rip),%zmm2        # 5bc7e0 <check_test_initializer_nesting.timed+0x508>
  8d8c7b:	3b ce ff 
  8d8c7e:	62 f3 5d 48 25 e4 ff 	vpternlogd $0xff,%zmm4,%zmm4,%zmm4
  8d8c85:	4c 8d 14 52          	lea    (%rdx,%rdx,2),%r10
  8d8c89:	4c 8b 40 08          	mov    0x8(%rax),%r8
  8d8c8d:	48 8b 08             	mov    (%rax),%rcx
  8d8c90:	89 96 c8 00 00 00    	mov    %edx,0xc8(%rsi)
  8d8c96:	b8 10 00 00 00       	mov    $0x10,%eax
  8d8c9b:	45 8b 88 a0 00 00 00 	mov    0xa0(%r8),%r9d
  8d8ca2:	48 8b 09             	mov    (%rcx),%rcx
  8d8ca5:	41 29 d1             	sub    %edx,%r9d
  8d8ca8:	41 83 f9 10          	cmp    $0x10,%r9d
  8d8cac:	41 0f 42 c1          	cmovb  %r9d,%eax
  8d8cb0:	41 b9 ff ff ff ff    	mov    $0xffffffff,%r9d
  8d8cb6:	49 c1 e2 05          	shl    $0x5,%r10
  8d8cba:	4d 03 50 08          	add    0x8(%r8),%r10
  8d8cbe:	4c 8b 87 a8 01 00 00 	mov    0x1a8(%rdi),%r8
  8d8cc5:	c4 42 79 f7 c9       	shlx   %eax,%r9d,%r9d
  8d8cca:	41 f7 d1             	not    %r9d
  8d8ccd:	c4 c1 7b 92 c9       	kmovd  %r9d,%k1
  8d8cd2:	c4 e1 f8 90 d1       	kmovq  %k1,%k2
  8d8cd7:	62 f1 7e c9 6f 34 91 	vmovdqu32 (%rcx,%rdx,4),%zmm6{%k1}{z}
  8d8cde:	62 d2 7d 4a 90 0c 02 	vpgatherdd (%r10,%zmm0,1),%zmm1{%k2}
  8d8ce5:	62 f1 7d 48 72 d1 03 	vpsrld $0x3,%zmm1,%zmm0
  8d8cec:	62 f3 7d 59 1e 57 6c 	vpcmpltud 0x1b0(%rdi){1to16},%zmm0,%k2{%k1}
  8d8cf3:	01 
  8d8cf4:	62 f2 7e 48 31 f3    	vpmovdb %zmm6,%xmm3
  8d8cfa:	62 f2 65 48 8d 1d bc 	vpermb -0x431544(%rip),%zmm3,%zmm3        # 4a77c0 <cbuiltin_test_generated.edges+0xb130>
  8d8d01:	ea bc ff 
  8d8d04:	62 d2 7d 4a 90 14 80 	vpgatherdd (%r8,%zmm0,4),%zmm2{%k2}
  8d8d0b:	62 f1 6d 58 db 2d cb 	vpandd -0x31c535(%rip){1to16},%zmm2,%zmm5        # 5bc7e0 <check_test_initializer_nesting.timed+0x508>
  8d8d12:	3a ce ff 
  8d8d15:	62 f3 4d 59 1e 15 c4 	vpcmpltud -0x31c53c(%rip){1to16},%zmm6,%k2{%k1}        # 5bc7e4 <check_test_initializer_nesting.timed+0x50c>
  8d8d1c:	3a ce ff 01 
  8d8d20:	62 f1 55 48 fe e4    	vpaddd %zmm4,%zmm5,%zmm4
  8d8d26:	62 f3 5d 58 1e 1d b7 	vpcmpltud -0x31c549(%rip){1to16},%zmm4,%k3        # 5bc7e8 <check_test_initializer_nesting.timed+0x510>
  8d8d2d:	3a ce ff 01 
  8d8d31:	62 f2 7d aa 30 db    	vpmovzxbw %xmm3,%ymm3{%k2}{z}
  8d8d37:	62 f2 6e 5b 27 05 ab 	vptestnmd -0x31c555(%rip){1to16},%zmm2,%k0{%k3}        # 5bc7ec <check_test_initializer_nesting.timed+0x514>
  8d8d3e:	3a ce ff 
  8d8d41:	c5 fb 93 c8          	kmovd  %k0,%ecx
  8d8d45:	c4 e2 78 f5 c9       	bzhi   %eax,%ecx,%ecx
  8d8d4a:	0f b7 c9             	movzwl %cx,%ecx
  8d8d4d:	48 89 8e c0 00 00 00 	mov    %rcx,0xc0(%rsi)
  8d8d54:	62 f1 ff 29 7f 1e    	vmovdqu16 %ymm3,(%rsi){%k1}
  8d8d5a:	62 f2 7e 49 33 6e 01 	vpmovdw %zmm5,0x20(%rsi){%k1}
  8d8d61:	62 f1 7e 49 7f 4e 01 	vmovdqu32 %zmm1,0x40(%rsi){%k1}
  8d8d68:	62 f1 7e 49 7f 56 02 	vmovdqu32 %zmm2,0x80(%rsi){%k1}
  8d8d6f:	48 01 87 50 05 00 00 	add    %rax,0x550(%rdi)
  8d8d76:	c5 f8 77             	vzeroupper
  8d8d79:	c3                   	ret
