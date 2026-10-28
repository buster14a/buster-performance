
/home/david/buster-fast-bench/issue624/placements-hot/compiler-2048:     file format elf64-x86-64


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

00000000008cff50 <check_lower_batch_classify>:
  8cff50:	48 8b 07             	mov    (%rdi),%rax
  8cff53:	89 f6                	mov    %esi,%esi
  8cff55:	4c 8d 14 76          	lea    (%rsi,%rsi,2),%r10
  8cff59:	62 f1 fd 48 6f 05 dd 	vmovdqa64 -0x428823(%rip),%zmm0        # 4a7740 <cbuiltin_test_generated.edges+0xb0b0>
  8cff60:	77 bd ff 
  8cff63:	41 b9 ff ff ff ff    	mov    $0xffffffff,%r9d
  8cff69:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
  8cff6d:	48 8b 8f a8 01 00 00 	mov    0x1a8(%rdi),%rcx
  8cff74:	c4 42 69 f7 c9       	shlx   %edx,%r9d,%r9d
  8cff79:	49 c1 e2 05          	shl    $0x5,%r10
  8cff7d:	41 f7 d1             	not    %r9d
  8cff80:	c4 c1 7b 92 c9       	kmovd  %r9d,%k1
  8cff85:	c4 e1 f8 90 d1       	kmovq  %k1,%k2
  8cff8a:	4c 8b 00             	mov    (%rax),%r8
  8cff8d:	48 8b 40 08          	mov    0x8(%rax),%rax
  8cff91:	4c 03 50 08          	add    0x8(%rax),%r10
  8cff95:	49 8b 00             	mov    (%r8),%rax
  8cff98:	62 f1 7e c9 6f 1c b0 	vmovdqu32 (%rax,%rsi,4),%zmm3{%k1}{z}
  8cff9f:	62 d2 7d 4a 90 0c 02 	vpgatherdd (%r10,%zmm0,1),%zmm1{%k2}
  8cffa6:	62 f2 7d 48 58 05 5c 	vpbroadcastd -0x3135a4(%rip),%zmm0        # 5bca0c <check_test_initializer_nesting.timed+0x504>
  8cffad:	ca ce ff 
  8cffb0:	89 d0                	mov    %edx,%eax
  8cffb2:	62 f1 75 48 72 d1 03 	vpsrld $0x3,%zmm1,%zmm1
  8cffb9:	62 f3 75 59 1e 57 6c 	vpcmpltud 0x1b0(%rdi){1to16},%zmm1,%k2{%k1}
  8cffc0:	01 
  8cffc1:	62 f2 7e 48 31 da    	vpmovdb %zmm3,%xmm2
  8cffc7:	62 f2 6d 48 8d 15 af 	vpermb -0x428851(%rip),%zmm2,%zmm2        # 4a7780 <cbuiltin_test_generated.edges+0xb0f0>
  8cffce:	77 bd ff 
  8cffd1:	62 f3 65 59 1e 0d 34 	vpcmpltud -0x3135cc(%rip){1to16},%zmm3,%k1{%k1}        # 5bca10 <check_test_initializer_nesting.timed+0x508>
  8cffd8:	ca ce ff 01 
  8cffdc:	62 f2 7d 4a 90 04 89 	vpgatherdd (%rcx,%zmm1,4),%zmm0{%k2}
  8cffe3:	48 01 87 10 02 00 00 	add    %rax,0x210(%rdi)
  8cffea:	62 f2 7d 48 31 d2    	vpmovzxbd %xmm2,%zmm2
  8cfff0:	62 f1 75 48 72 f2 10 	vpslld $0x10,%zmm2,%zmm1
  8cfff7:	62 f1 7d 49 eb c1    	vpord  %zmm1,%zmm0,%zmm0{%k1}
  8cfffd:	c3                   	ret
