
/home/david/buster-fast-bench/issue624/placements-layout/compiler-1024:     file format elf64-x86-64


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

00000000008cfd40 <check_lower_batch_classify>:
  8cfd40:	48 8b 0f             	mov    (%rdi),%rcx
  8cfd43:	48 8b 01             	mov    (%rcx),%rax
  8cfd46:	48 8b 49 08          	mov    0x8(%rcx),%rcx
  8cfd4a:	83 fa 04             	cmp    $0x4,%edx
  8cfd4d:	0f 87 f0 00 00 00    	ja     8cfe43 <check_lower_batch_classify+0x103>
  8cfd53:	85 d2                	test   %edx,%edx
  8cfd55:	0f 84 8c 01 00 00    	je     8cfee7 <check_lower_batch_classify+0x1a7>
  8cfd5b:	48 8b 49 08          	mov    0x8(%rcx),%rcx
  8cfd5f:	41 89 f0             	mov    %esi,%r8d
  8cfd62:	4f 8d 0c 40          	lea    (%r8,%r8,2),%r9
  8cfd66:	44 8b 87 b0 01 00 00 	mov    0x1b0(%rdi),%r8d
  8cfd6d:	41 ba ff 00 00 00    	mov    $0xff,%r10d
  8cfd73:	49 c1 e1 05          	shl    $0x5,%r9
  8cfd77:	46 8b 0c 09          	mov    (%rcx,%r9,1),%r9d
  8cfd7b:	41 c1 e9 03          	shr    $0x3,%r9d
  8cfd7f:	45 39 c1             	cmp    %r8d,%r9d
  8cfd82:	73 0b                	jae    8cfd8f <check_lower_batch_classify+0x4f>
  8cfd84:	4c 8b 97 a8 01 00 00 	mov    0x1a8(%rdi),%r10
  8cfd8b:	47 8b 14 8a          	mov    (%r10,%r9,4),%r10d
  8cfd8f:	c4 c1 79 6e c2       	vmovd  %r10d,%xmm0
  8cfd94:	83 fa 01             	cmp    $0x1,%edx
  8cfd97:	0f 84 4e 01 00 00    	je     8cfeeb <check_lower_batch_classify+0x1ab>
  8cfd9d:	44 8d 4e 01          	lea    0x1(%rsi),%r9d
  8cfda1:	41 ba ff 00 00 00    	mov    $0xff,%r10d
  8cfda7:	4f 8d 0c 49          	lea    (%r9,%r9,2),%r9
  8cfdab:	49 c1 e1 05          	shl    $0x5,%r9
  8cfdaf:	46 8b 0c 09          	mov    (%rcx,%r9,1),%r9d
  8cfdb3:	41 c1 e9 03          	shr    $0x3,%r9d
  8cfdb7:	45 39 c1             	cmp    %r8d,%r9d
  8cfdba:	73 0b                	jae    8cfdc7 <check_lower_batch_classify+0x87>
  8cfdbc:	4c 8b 97 a8 01 00 00 	mov    0x1a8(%rdi),%r10
  8cfdc3:	47 8b 14 8a          	mov    (%r10,%r9,4),%r10d
  8cfdc7:	c4 c3 79 22 c2 01    	vpinsrd $0x1,%r10d,%xmm0,%xmm0
  8cfdcd:	83 fa 02             	cmp    $0x2,%edx
  8cfdd0:	0f 84 15 01 00 00    	je     8cfeeb <check_lower_batch_classify+0x1ab>
  8cfdd6:	44 8d 4e 02          	lea    0x2(%rsi),%r9d
  8cfdda:	41 ba ff 00 00 00    	mov    $0xff,%r10d
  8cfde0:	4f 8d 0c 49          	lea    (%r9,%r9,2),%r9
  8cfde4:	49 c1 e1 05          	shl    $0x5,%r9
  8cfde8:	46 8b 0c 09          	mov    (%rcx,%r9,1),%r9d
  8cfdec:	41 c1 e9 03          	shr    $0x3,%r9d
  8cfdf0:	45 39 c1             	cmp    %r8d,%r9d
  8cfdf3:	73 0b                	jae    8cfe00 <check_lower_batch_classify+0xc0>
  8cfdf5:	4c 8b 97 a8 01 00 00 	mov    0x1a8(%rdi),%r10
  8cfdfc:	47 8b 14 8a          	mov    (%r10,%r9,4),%r10d
  8cfe00:	c4 c3 79 22 c2 02    	vpinsrd $0x2,%r10d,%xmm0,%xmm0
  8cfe06:	83 fa 03             	cmp    $0x3,%edx
  8cfe09:	0f 84 dc 00 00 00    	je     8cfeeb <check_lower_batch_classify+0x1ab>
  8cfe0f:	44 8d 4e 03          	lea    0x3(%rsi),%r9d
  8cfe13:	4f 8d 0c 49          	lea    (%r9,%r9,2),%r9
  8cfe17:	49 c1 e1 05          	shl    $0x5,%r9
  8cfe1b:	42 8b 0c 09          	mov    (%rcx,%r9,1),%ecx
  8cfe1f:	41 b9 ff 00 00 00    	mov    $0xff,%r9d
  8cfe25:	c1 e9 03             	shr    $0x3,%ecx
  8cfe28:	44 39 c1             	cmp    %r8d,%ecx
  8cfe2b:	73 0b                	jae    8cfe38 <check_lower_batch_classify+0xf8>
  8cfe2d:	4c 8b 87 a8 01 00 00 	mov    0x1a8(%rdi),%r8
  8cfe34:	45 8b 0c 88          	mov    (%r8,%rcx,4),%r9d
  8cfe38:	c4 c3 79 22 c1 03    	vpinsrd $0x3,%r9d,%xmm0,%xmm0
  8cfe3e:	e9 a8 00 00 00       	jmp    8cfeeb <check_lower_batch_classify+0x1ab>
  8cfe43:	62 f1 fd 48 6f 05 f3 	vmovdqa64 -0x42880d(%rip),%zmm0        # 4a7640 <cbuiltin_test_generated.edges+0xafb0>
  8cfe4a:	77 bd ff 
  8cfe4d:	89 f6                	mov    %esi,%esi
  8cfe4f:	4c 8d 0c 76          	lea    (%rsi,%rsi,2),%r9
  8cfe53:	48 8b 00             	mov    (%rax),%rax
  8cfe56:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
  8cfe5c:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
  8cfe60:	c4 42 69 f7 c0       	shlx   %edx,%r8d,%r8d
  8cfe65:	49 c1 e1 05          	shl    $0x5,%r9
  8cfe69:	4c 03 49 08          	add    0x8(%rcx),%r9
  8cfe6d:	41 f7 d0             	not    %r8d
  8cfe70:	48 8b 8f a8 01 00 00 	mov    0x1a8(%rdi),%rcx
  8cfe77:	c4 c1 7b 92 c8       	kmovd  %r8d,%k1
  8cfe7c:	c4 e1 f8 90 d1       	kmovq  %k1,%k2
  8cfe81:	62 f1 7e c9 6f 1c b0 	vmovdqu32 (%rax,%rsi,4),%zmm3{%k1}{z}
  8cfe88:	62 d2 7d 4a 90 0c 01 	vpgatherdd (%r9,%zmm0,1),%zmm1{%k2}
  8cfe8f:	62 f2 7d 48 58 05 c3 	vpbroadcastd -0x31363d(%rip),%zmm0        # 5bc85c <check_test_initializer_nesting.timed+0x504>
  8cfe96:	c9 ce ff 
  8cfe99:	62 f1 75 48 72 d1 03 	vpsrld $0x3,%zmm1,%zmm1
  8cfea0:	62 f2 7e 48 31 da    	vpmovdb %zmm3,%xmm2
  8cfea6:	62 f2 6d 48 8d 15 d0 	vpermb -0x428830(%rip),%zmm2,%zmm2        # 4a7680 <cbuiltin_test_generated.edges+0xaff0>
  8cfead:	77 bd ff 
  8cfeb0:	62 f3 75 59 1e 57 6c 	vpcmpltud 0x1b0(%rdi){1to16},%zmm1,%k2{%k1}
  8cfeb7:	01 
  8cfeb8:	62 f3 65 59 1e 0d 9d 	vpcmpltud -0x313663(%rip){1to16},%zmm3,%k1{%k1}        # 5bc860 <check_test_initializer_nesting.timed+0x508>
  8cfebf:	c9 ce ff 01 
  8cfec3:	62 f2 7d 48 31 d2    	vpmovzxbd %xmm2,%zmm2
  8cfec9:	62 f2 7d 4a 90 04 89 	vpgatherdd (%rcx,%zmm1,4),%zmm0{%k2}
  8cfed0:	62 f1 75 48 72 f2 10 	vpslld $0x10,%zmm2,%zmm1
  8cfed7:	62 f1 7d 49 eb c1    	vpord  %zmm1,%zmm0,%zmm0{%k1}
  8cfedd:	89 d0                	mov    %edx,%eax
  8cfedf:	48 01 87 10 02 00 00 	add    %rax,0x210(%rdi)
  8cfee6:	c3                   	ret
  8cfee7:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
  8cfeeb:	48 8b 00             	mov    (%rax),%rax
  8cfeee:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  8cfef3:	89 f6                	mov    %esi,%esi
  8cfef5:	c4 e2 69 f7 c9       	shlx   %edx,%ecx,%ecx
  8cfefa:	f6 d1                	not    %cl
  8cfefc:	c5 fb 92 c9          	kmovd  %ecx,%k1
  8cff00:	62 f1 7e 89 6f 0c b0 	vmovdqu32 (%rax,%rsi,4),%xmm1{%k1}{z}
  8cff07:	62 f2 7e 08 31 ca    	vpmovdb %xmm1,%xmm2
  8cff0d:	62 f2 6d 48 8d 15 69 	vpermb -0x428897(%rip),%zmm2,%zmm2        # 4a7680 <cbuiltin_test_generated.edges+0xaff0>
  8cff14:	77 bd ff 
  8cff17:	62 f3 75 19 1e 0d 3e 	vpcmpltud -0x3136c2(%rip){1to4},%xmm1,%k1{%k1}        # 5bc860 <check_test_initializer_nesting.timed+0x508>
  8cff1e:	c9 ce ff 01 
  8cff22:	c4 e2 69 00 0d d5 30 	vpshufb -0x32cf2b(%rip),%xmm2,%xmm1        # 5a3000 <abi_test_hex.digits+0x15f0>
  8cff29:	cd ff 
  8cff2b:	62 f1 7d 89 6f c9    	vmovdqa32 %xmm1,%xmm1{%k1}{z}
  8cff31:	c5 f9 eb c1          	vpor   %xmm1,%xmm0,%xmm0
  8cff35:	89 d0                	mov    %edx,%eax
  8cff37:	48 01 87 10 02 00 00 	add    %rax,0x210(%rdi)
  8cff3e:	c3                   	ret
