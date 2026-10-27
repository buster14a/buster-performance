
build/compiler:     file format elf64-x86-64


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

00000000009f5b20 <x86_encode_16>:
  9f5b20:	55                   	push   %rbp
  9f5b21:	48 89 e5             	mov    %rsp,%rbp
  9f5b24:	41 57                	push   %r15
  9f5b26:	41 56                	push   %r14
  9f5b28:	41 54                	push   %r12
  9f5b2a:	53                   	push   %rbx
  9f5b2b:	48 83 e4 c0          	and    $0xffffffffffffffc0,%rsp
  9f5b2f:	48 81 ec 80 01 00 00 	sub    $0x180,%rsp
  9f5b36:	64 48 8b 04 25 28 00 00 00 	mov    %fs:0x28,%rax
  9f5b3f:	48 89 d3             	mov    %rdx,%rbx
  9f5b42:	48 89 f2             	mov    %rsi,%rdx
  9f5b45:	48 89 fe             	mov    %rdi,%rsi
  9f5b48:	48 89 84 24 48 01 00 00 	mov    %rax,0x148(%rsp)
  9f5b50:	48 85 c9             	test   %rcx,%rcx
  9f5b53:	74 10                	je     9f5b65 <x86_encode_16+0x45>
  9f5b55:	48 83 fa 10          	cmp    $0x10,%rdx
  9f5b59:	73 1e                	jae    9f5b79 <x86_encode_16+0x59>
  9f5b5b:	31 c0                	xor    %eax,%eax
  9f5b5d:	49 89 de             	mov    %rbx,%r14
  9f5b60:	e9 49 06 00 00       	jmp    9f61ae <x86_encode_16+0x68e>
  9f5b65:	48 83 fa 10          	cmp    $0x10,%rdx
  9f5b69:	0f 83 bc 0c 00 00    	jae    9f682b <x86_encode_16+0xd0b>
  9f5b6f:	31 c0                	xor    %eax,%eax
  9f5b71:	49 89 de             	mov    %rbx,%r14
  9f5b74:	e9 54 12 00 00       	jmp    9f6dcd <x86_encode_16+0x12ad>
  9f5b79:	62 f2 7d 48 5a 1d 2d 09 b7 ff 	vbroadcasti32x4 -0x48f6d3(%rip),%zmm3        # 5664b0 <check_binding_benchmark_headers+0x21d0>
  9f5b83:	62 72 7d 48 58 0d b3 76 b8 ff 	vpbroadcastd -0x47894d(%rip),%zmm9        # 57d240 <tier0_test_int128_integers+0x1b8>
  9f5b8d:	48 8d 7a f0          	lea    -0x10(%rdx),%rdi
  9f5b91:	41 b2 cc             	mov    $0xcc,%r10b
  9f5b94:	4c 8d 86 fc 00 00 00 	lea    0xfc(%rsi),%r8
  9f5b9b:	4c 8d 0d 9e 19 71 07 	lea    0x771199e(%rip),%r9        # 8107540 <x86_template_storage>
  9f5ba2:	62 53 1d 48 25 e4 ff 	vpternlogd $0xff,%zmm12,%zmm12,%zmm12
  9f5ba9:	31 c0                	xor    %eax,%eax
  9f5bab:	48 c1 ef 04          	shr    $0x4,%rdi
  9f5baf:	c4 c1 7b 92 ca       	kmovd  %r10d,%k1
  9f5bb4:	49 89 da             	mov    %rbx,%r10
  9f5bb7:	48 ff c7             	inc    %rdi
  9f5bba:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  9f5bc0:	45 0f b7 98 10 ff ff ff 	movzwl -0xf0(%r8),%r11d
  9f5bc8:	45 0f b7 b0 20 ff ff ff 	movzwl -0xe0(%r8),%r14d
  9f5bd0:	45 0f b7 b8 30 ff ff ff 	movzwl -0xd0(%r8),%r15d
  9f5bd8:	45 0f b7 a0 40 ff ff ff 	movzwl -0xc0(%r8),%r12d
  9f5be0:	62 c1 fe 48 6f a0 04 ff ff ff 	vmovdqu64 -0xfc(%r8),%zmm20
  9f5bea:	62 41 fe 48 6f 98 44 ff ff ff 	vmovdqu64 -0xbc(%r8),%zmm27
  9f5bf4:	62 41 fe 48 6f a0 84 ff ff ff 	vmovdqu64 -0x7c(%r8),%zmm28
  9f5bfe:	62 41 fe 48 6f a8 c4 ff ff ff 	vmovdqu64 -0x3c(%r8),%zmm29
  9f5c08:	62 f2 7d 48 5a 05 de 08 b7 ff 	vbroadcasti32x4 -0x48f722(%rip),%zmm0        # 5664f0 <check_binding_benchmark_headers+0x2210>
  9f5c12:	62 f2 7d 48 5a 2d e4 08 b7 ff 	vbroadcasti32x4 -0x48f71c(%rip),%zmm5        # 566500 <check_binding_benchmark_headers+0x2220>
  9f5c1c:	62 f2 7d 48 5a 35 ea 08 b7 ff 	vbroadcasti32x4 -0x48f716(%rip),%zmm6        # 566510 <check_binding_benchmark_headers+0x2230>
  9f5c26:	62 72 7d 48 58 05 f8 75 b8 ff 	vpbroadcastd -0x478a08(%rip),%zmm8        # 57d228 <tier0_test_int128_integers+0x1a0>
  9f5c30:	48 83 c0 10          	add    $0x10,%rax
  9f5c34:	41 c1 e3 06          	shl    $0x6,%r11d
  9f5c38:	41 c1 e6 06          	shl    $0x6,%r14d
  9f5c3c:	41 c1 e7 06          	shl    $0x6,%r15d
  9f5c40:	41 c1 e4 06          	shl    $0x6,%r12d
  9f5c44:	c4 81 7d 6f 4c 0b 40 	vmovdqa 0x40(%r11,%r9,1),%ymm1
  9f5c4b:	45 0f b7 98 50 ff ff ff 	movzwl -0xb0(%r8),%r11d
  9f5c53:	62 13 f5 48 3a 5c 0f 02 01 	vinserti64x4 $0x1,0x40(%r15,%r9,1),%zmm1,%zmm11
  9f5c5c:	45 0f b7 b8 70 ff ff ff 	movzwl -0x90(%r8),%r15d
  9f5c64:	c4 81 7d 6f 4c 0e 60 	vmovdqa 0x60(%r14,%r9,1),%ymm1
  9f5c6b:	45 0f b7 b0 60 ff ff ff 	movzwl -0xa0(%r8),%r14d
  9f5c73:	62 83 f5 48 3a 74 0c 03 01 	vinserti64x4 $0x1,0x60(%r12,%r9,1),%zmm1,%zmm22
  9f5c7c:	45 0f b7 60 80       	movzwl -0x80(%r8),%r12d
  9f5c81:	62 11 5d 40 62 f3    	vpunpckldq %zmm27,%zmm20,%zmm14
  9f5c87:	62 11 1d 40 62 fd    	vpunpckldq %zmm29,%zmm28,%zmm15
  9f5c8d:	62 01 5d 40 6a db    	vpunpckhdq %zmm27,%zmm20,%zmm27
  9f5c93:	62 01 1d 40 6a ed    	vpunpckhdq %zmm29,%zmm28,%zmm29
  9f5c99:	62 11 a5 40 6c d5    	vpunpcklqdq %zmm29,%zmm27,%zmm10
  9f5c9f:	62 41 8d 48 6d f7    	vpunpckhqdq %zmm15,%zmm14,%zmm30
  9f5ca5:	62 d2 d5 48 83 ea    	vpmultishiftqb %zmm10,%zmm5,%zmm5
  9f5cab:	62 d2 cd 48 83 f2    	vpmultishiftqb %zmm10,%zmm6,%zmm6
  9f5cb1:	62 92 0d 40 27 c6    	vptestmd %zmm30,%zmm30,%k0
  9f5cb7:	62 41 fd 48 6f e2    	vmovdqa64 %zmm10,%zmm28
  9f5cbd:	41 c1 e3 06          	shl    $0x6,%r11d
  9f5cc1:	c4 81 7d 6f 4c 0b 40 	vmovdqa 0x40(%r11,%r9,1),%ymm1
  9f5cc8:	45 0f b7 58 90       	movzwl -0x70(%r8),%r11d
  9f5ccd:	41 c1 e7 06          	shl    $0x6,%r15d
  9f5cd1:	41 c1 e6 06          	shl    $0x6,%r14d
  9f5cd5:	62 83 f5 48 3a 44 0f 02 01 	vinserti64x4 $0x1,0x40(%r15,%r9,1),%zmm1,%zmm16
  9f5cde:	45 0f b7 78 b0       	movzwl -0x50(%r8),%r15d
  9f5ce3:	c4 81 7d 6f 4c 0e 60 	vmovdqa 0x60(%r14,%r9,1),%ymm1
  9f5cea:	45 0f b7 70 a0       	movzwl -0x60(%r8),%r14d
  9f5cef:	41 c1 e4 06          	shl    $0x6,%r12d
  9f5cf3:	62 03 f5 48 3a 44 0c 03 01 	vinserti64x4 $0x1,0x60(%r12,%r9,1),%zmm1,%zmm24
  9f5cfc:	45 0f b7 60 c0       	movzwl -0x40(%r8),%r12d
  9f5d01:	62 32 a5 49 64 ee    	vpblendmq %zmm22,%zmm11,%zmm13{%k1}
  9f5d07:	41 c1 e3 06          	shl    $0x6,%r11d
  9f5d0b:	c4 81 7d 6f 4c 0b 40 	vmovdqa 0x40(%r11,%r9,1),%ymm1
  9f5d12:	45 0f b7 58 d0       	movzwl -0x30(%r8),%r11d
  9f5d17:	41 c1 e7 06          	shl    $0x6,%r15d
  9f5d1b:	41 c1 e6 06          	shl    $0x6,%r14d
  9f5d1f:	62 83 f5 48 3a 54 0f 02 01 	vinserti64x4 $0x1,0x40(%r15,%r9,1),%zmm1,%zmm18
  9f5d28:	45 0f b7 78 f0       	movzwl -0x10(%r8),%r15d
  9f5d2d:	c4 81 7d 6f 4c 0e 60 	vmovdqa 0x60(%r14,%r9,1),%ymm1
  9f5d34:	45 0f b7 70 e0       	movzwl -0x20(%r8),%r14d
  9f5d39:	41 c1 e4 06          	shl    $0x6,%r12d
  9f5d3d:	62 03 f5 48 3a 4c 0c 03 01 	vinserti64x4 $0x1,0x60(%r12,%r9,1),%zmm1,%zmm25
  9f5d46:	45 0f b7 20          	movzwl (%r8),%r12d
  9f5d4a:	49 81 c0 00 01 00 00 	add    $0x100,%r8
  9f5d51:	62 82 fd 41 64 c8    	vpblendmq %zmm24,%zmm16,%zmm17{%k1}
  9f5d57:	41 c1 e3 06          	shl    $0x6,%r11d
  9f5d5b:	41 c1 e6 06          	shl    $0x6,%r14d
  9f5d5f:	41 c1 e7 06          	shl    $0x6,%r15d
  9f5d63:	c4 81 7d 6f 4c 0b 40 	vmovdqa 0x40(%r11,%r9,1),%ymm1
  9f5d6a:	62 83 f5 48 3a 6c 0f 02 01 	vinserti64x4 $0x1,0x40(%r15,%r9,1),%zmm1,%zmm21
  9f5d73:	41 c1 e4 06          	shl    $0x6,%r12d
  9f5d77:	c4 81 7d 6f 4c 0e 60 	vmovdqa 0x60(%r14,%r9,1),%ymm1
  9f5d7e:	62 03 f5 48 3a 54 0c 03 01 	vinserti64x4 $0x1,0x60(%r12,%r9,1),%zmm1,%zmm26
  9f5d87:	62 b1 15 48 6a c9    	vpunpckhdq %zmm17,%zmm13,%zmm1
  9f5d8d:	62 82 ed 41 64 d9    	vpblendmq %zmm25,%zmm18,%zmm19{%k1}
  9f5d93:	62 82 d5 41 64 fa    	vpblendmq %zmm26,%zmm21,%zmm23{%k1}
  9f5d99:	62 b1 65 40 6a d7    	vpunpckhdq %zmm23,%zmm19,%zmm2
  9f5d9f:	62 e1 f5 48 6d e2    	vpunpckhqdq %zmm2,%zmm1,%zmm20
  9f5da5:	62 d1 75 48 72 d2 1a 	vpsrld $0x1a,%zmm10,%zmm1
  9f5dac:	62 f2 75 48 36 3d ca ad aa ff 	vpermd -0x555236(%rip),%zmm1,%zmm7        # 4a0b80 <check_builtin_atomic_rmw_test_clang.native_source+0x3680>
  9f5db6:	62 62 75 48 36 3d 00 ae aa ff 	vpermd -0x555200(%rip),%zmm1,%zmm31        # 4a0bc0 <check_builtin_atomic_rmw_test_clang.native_source+0x36c0>
  9f5dc0:	62 f2 75 48 36 25 36 ae aa ff 	vpermd -0x5551ca(%rip),%zmm1,%zmm4        # 4a0c00 <check_builtin_atomic_rmw_test_clang.native_source+0x3700>
  9f5dca:	62 d2 fd 48 83 ca    	vpmultishiftqb %zmm10,%zmm0,%zmm1
  9f5dd0:	62 f2 7d 48 5a 05 46 07 b7 ff 	vbroadcasti32x4 -0x48f8ba(%rip),%zmm0        # 566520 <check_binding_benchmark_headers+0x2240>
  9f5dda:	62 f3 75 58 25 2d 37 74 b8 ff d8 	vpternlogd $0xd8,-0x478bc9(%rip){1to16},%zmm1,%zmm5        # 57d21c <tier0_test_int128_integers+0x194>
  9f5de5:	62 d1 75 48 72 f2 04 	vpslld $0x4,%zmm10,%zmm1
  9f5dec:	62 f1 6d 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm2
  9f5df3:	62 f3 55 58 25 35 22 74 b8 ff e4 	vpternlogd $0xe4,-0x478bde(%rip){1to16},%zmm5,%zmm6        # 57d220 <tier0_test_int128_integers+0x198>
  9f5dfe:	62 d2 7d 48 00 ea    	vpshufb %zmm10,%zmm0,%zmm5
  9f5e04:	62 91 7d 48 72 e6 1f 	vpsrad $0x1f,%zmm30,%zmm0
  9f5e0b:	62 f1 75 48 72 f5 10 	vpslld $0x10,%zmm5,%zmm1
  9f5e12:	62 f1 6d 48 db ed    	vpandd %zmm5,%zmm2,%zmm5
  9f5e18:	62 f3 5d 58 25 2d 49 74 b8 ff ec 	vpternlogd $0xec,-0x478bb7(%rip){1to16},%zmm4,%zmm5        # 57d26c <tier0_test_int128_integers+0x1e4>
  9f5e23:	62 f3 5d 50 25 2d 42 74 b8 ff f8 	vpternlogd $0xf8,-0x478bbe(%rip){1to16},%zmm20,%zmm5        # 57d270 <tier0_test_int128_integers+0x1e8>
  9f5e2e:	62 63 4d 48 25 ff f8 	vpternlogd $0xf8,%zmm7,%zmm6,%zmm31
  9f5e35:	62 f1 45 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm7
  9f5e3c:	62 f2 7e 48 38 c8    	vpmovm2d %k0,%zmm1
  9f5e42:	62 f3 6d 48 25 cf c8 	vpternlogd $0xc8,%zmm7,%zmm2,%zmm1
  9f5e49:	62 91 7d 48 ef fe    	vpxord %zmm30,%zmm0,%zmm7
  9f5e4f:	62 f2 7d 48 58 05 cb 73 b8 ff 	vpbroadcastd -0x478c35(%rip),%zmm0        # 57d224 <tier0_test_int128_integers+0x19c>
  9f5e59:	62 f2 7d 48 44 ff    	vplzcntd %zmm7,%zmm7
  9f5e5f:	62 f2 3d 48 45 ff    	vpsrlvd %zmm7,%zmm8,%zmm7
  9f5e65:	62 51 0d 40 fe c4    	vpaddd %zmm12,%zmm30,%zmm8
  9f5e6b:	62 73 0d 40 25 c7 14 	vpternlogd $0x14,%zmm7,%zmm30,%zmm8
  9f5e72:	62 d1 45 48 72 d2 08 	vpsrld $0x8,%zmm10,%zmm7
  9f5e79:	62 63 7d 58 25 25 b0 73 b8 ff 6c 	vpternlogd $0x6c,-0x478c50(%rip){1to16},%zmm0,%zmm28        # 57d234 <tier0_test_int128_integers+0x1ac>
  9f5e84:	62 f3 7d 58 25 3d a9 73 b8 ff 6c 	vpternlogd $0x6c,-0x478c57(%rip){1to16},%zmm0,%zmm7        # 57d238 <tier0_test_int128_integers+0x1b0>
  9f5e8f:	62 91 7d 48 72 ce 01 	vprold $0x1,%zmm30,%zmm0
  9f5e96:	62 41 1d 40 fe e4    	vpaddd %zmm12,%zmm28,%zmm28
  9f5e9c:	62 63 35 58 25 25 95 73 b8 ff ec 	vpternlogd $0xec,-0x478c6b(%rip){1to16},%zmm9,%zmm28        # 57d23c <tier0_test_int128_integers+0x1b4>
  9f5ea7:	62 d1 45 48 fe fc    	vpaddd %zmm12,%zmm7,%zmm7
  9f5ead:	62 f3 1d 50 25 3d 8c 73 b8 ff ec 	vpternlogd $0xec,-0x478c74(%rip){1to16},%zmm28,%zmm7        # 57d244 <tier0_test_int128_integers+0x1bc>
  9f5eb8:	62 61 4d 58 db 25 86 73 b8 ff 	vpandd -0x478c7a(%rip){1to16},%zmm6,%zmm28        # 57d248 <tier0_test_int128_integers+0x1c0>
  9f5ec2:	62 f1 4d 48 72 d6 03 	vpsrld $0x3,%zmm6,%zmm6
  9f5ec9:	62 f3 5d 50 25 35 80 73 b8 ff a2 	vpternlogd $0xa2,-0x478c80(%rip){1to16},%zmm20,%zmm6        # 57d254 <tier0_test_int128_integers+0x1cc>
  9f5ed4:	62 f2 4d 58 3b 25 7a 73 b8 ff 	vpminud -0x478c86(%rip){1to16},%zmm6,%zmm4        # 57d258 <tier0_test_int128_integers+0x1d0>
  9f5ede:	62 63 5d 40 25 e7 f8 	vpternlogd $0xf8,%zmm7,%zmm20,%zmm28
  9f5ee5:	62 62 1d 50 3b 25 5d 73 b8 ff 	vpminud -0x478ca3(%rip){1to16},%zmm28,%zmm28        # 57d24c <tier0_test_int128_integers+0x1c4>
  9f5eef:	62 b1 45 48 72 d4 1d 	vpsrld $0x1d,%zmm20,%zmm7
  9f5ef6:	62 72 3d 48 14 c7    	vprorvd %zmm7,%zmm8,%zmm8
  9f5efc:	62 f2 7d 48 14 ff    	vprorvd %zmm7,%zmm0,%zmm7
  9f5f02:	62 f1 fd 48 6f 05 34 ac aa ff 	vmovdqa64 -0x5553cc(%rip),%zmm0        # 4a0b40 <check_builtin_atomic_rmw_test_clang.native_source+0x3640>
  9f5f0c:	62 d1 3d 48 72 e0 1f 	vpsrad $0x1f,%zmm8,%zmm8
  9f5f13:	62 93 75 48 25 fe e2 	vpternlogd $0xe2,%zmm30,%zmm1,%zmm7
  9f5f1a:	62 93 3d 48 25 fe e2 	vpternlogd $0xe2,%zmm30,%zmm8,%zmm7
  9f5f21:	62 93 5d 48 25 ec fe 	vpternlogd $0xfe,%zmm28,%zmm4,%zmm5
  9f5f28:	62 91 fd 48 6f e7    	vmovdqa64 %zmm31,%zmm4
  9f5f2e:	62 01 fd 48 6f e7    	vmovdqa64 %zmm31,%zmm28
  9f5f34:	62 f3 6d 58 25 25 f1 72 b8 ff f8 	vpternlogd $0xf8,-0x478d0f(%rip){1to16},%zmm2,%zmm4        # 57d230 <tier0_test_int128_integers+0x1a8>
  9f5f3f:	62 63 75 58 25 25 e2 72 b8 ff f8 	vpternlogd $0xf8,-0x478d1e(%rip){1to16},%zmm1,%zmm28        # 57d22c <tier0_test_int128_integers+0x1a4>
  9f5f4a:	62 f1 6d 58 db 15 24 73 b8 ff 	vpandd -0x478cdc(%rip){1to16},%zmm2,%zmm2        # 57d278 <tier0_test_int128_integers+0x1f0>
  9f5f54:	62 32 fd 48 7e de    	vpermt2q %zmm22,%zmm0,%zmm11
  9f5f5a:	62 91 4d 40 72 d7 03 	vpsrld $0x3,%zmm31,%zmm22
  9f5f61:	62 82 fd 48 7e c0    	vpermt2q %zmm24,%zmm0,%zmm16
  9f5f67:	62 82 fd 48 7e d1    	vpermt2q %zmm25,%zmm0,%zmm18
  9f5f6d:	62 82 fd 48 7e ea    	vpermt2q %zmm26,%zmm0,%zmm21
  9f5f73:	62 f2 7d 48 5a 05 b3 05 b7 ff 	vbroadcasti32x4 -0x48fa4d(%rip),%zmm0        # 566530 <check_binding_benchmark_headers+0x2250>
  9f5f7d:	62 93 3d 48 25 e4 b8 	vpternlogd $0xb8,%zmm28,%zmm8,%zmm4
  9f5f84:	62 61 75 58 db 25 e6 72 b8 ff 	vpandd -0x478d1a(%rip){1to16},%zmm1,%zmm28        # 57d274 <tier0_test_int128_integers+0x1ec>
  9f5f8e:	62 91 75 48 72 d7 10 	vpsrld $0x10,%zmm31,%zmm1
  9f5f95:	62 e3 75 58 25 35 b0 72 b8 ff ec 	vpternlogd $0xec,-0x478d50(%rip){1to16},%zmm1,%zmm22        # 57d250 <tier0_test_int128_integers+0x1c8>
  9f5fa0:	62 d1 4d 48 fe cc    	vpaddd %zmm12,%zmm6,%zmm1
  9f5fa6:	62 f1 75 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm1
  9f5fad:	62 93 3d 48 25 d4 b8 	vpternlogd $0xb8,%zmm28,%zmm8,%zmm2
  9f5fb4:	62 51 8d 48 6c c7    	vpunpcklqdq %zmm15,%zmm14,%zmm8
  9f5fba:	62 11 a5 40 6d f5    	vpunpckhqdq %zmm29,%zmm27,%zmm14
  9f5fc0:	62 b1 4d 48 72 f6 08 	vpslld $0x8,%zmm22,%zmm6
  9f5fc7:	62 f3 75 58 25 35 8a 72 b8 ff 08 	vpternlogd $0x8,-0x478d76(%rip){1to16},%zmm1,%zmm6        # 57d25c <tier0_test_int128_integers+0x1d4>
  9f5fd2:	62 51 0d 48 eb d2    	vpord  %zmm10,%zmm14,%zmm10
  9f5fd8:	62 f1 6d 48 eb d5    	vpord  %zmm5,%zmm2,%zmm2
  9f5fde:	62 f1 3d 48 62 ef    	vpunpckldq %zmm7,%zmm8,%zmm5
  9f5fe4:	62 f1 3d 48 6a ff    	vpunpckhdq %zmm7,%zmm8,%zmm7
  9f5fea:	62 d1 2d 48 72 f2 07 	vpslld $0x7,%zmm10,%zmm10
  9f5ff1:	62 73 4d 58 25 15 64 72 b8 ff e4 	vpternlogd $0xe4,-0x478d9c(%rip){1to16},%zmm6,%zmm10        # 57d260 <tier0_test_int128_integers+0x1d8>
  9f5ffc:	62 d2 fd 48 83 f6    	vpmultishiftqb %zmm14,%zmm0,%zmm6
  9f6002:	62 f3 4d 50 25 35 57 72 b8 ff d8 	vpternlogd $0xd8,-0x478da9(%rip){1to16},%zmm22,%zmm6        # 57d264 <tier0_test_int128_integers+0x1dc>
  9f600d:	62 f1 7d 48 70 c2 55 	vpshufd $0x55,%zmm2,%zmm0
  9f6014:	62 b2 7d 48 8f d0    	vpshufbitqmb %zmm16,%zmm0,%k2
  9f601a:	62 f1 7d 48 70 c2 aa 	vpshufd $0xaa,%zmm2,%zmm0
  9f6021:	c4 61 fb 93 f2       	kmovq  %k2,%r14
  9f6026:	f3 4d 0f b8 f6       	popcnt %r14,%r14
  9f602b:	62 f3 2d 58 25 35 32 72 b8 ff d8 	vpternlogd $0xd8,-0x478dce(%rip){1to16},%zmm10,%zmm6        # 57d268 <tier0_test_int128_integers+0x1e0>
  9f6036:	62 71 5d 48 62 c6    	vpunpckldq %zmm6,%zmm4,%zmm8
  9f603c:	62 f1 5d 48 6a e6    	vpunpckhdq %zmm6,%zmm4,%zmm4
  9f6042:	62 d1 d5 48 6c f0    	vpunpcklqdq %zmm8,%zmm5,%zmm6
  9f6048:	62 d1 d5 48 6d e8    	vpunpckhqdq %zmm8,%zmm5,%zmm5
  9f604e:	62 71 c5 48 6c c4    	vpunpcklqdq %zmm4,%zmm7,%zmm8
  9f6054:	62 f1 c5 48 6d e4    	vpunpckhqdq %zmm4,%zmm7,%zmm4
  9f605a:	62 f1 7d 48 70 fa 00 	vpshufd $0x0,%zmm2,%zmm7
  9f6061:	62 d2 4d 48 00 f3    	vpshufb %zmm11,%zmm6,%zmm6
  9f6067:	62 d2 45 48 8f db    	vpshufbitqmb %zmm11,%zmm7,%k3
  9f606d:	62 b2 55 48 00 e8    	vpshufb %zmm16,%zmm5,%zmm5
  9f6073:	62 b2 5d 48 00 e5    	vpshufb %zmm21,%zmm4,%zmm4
  9f6079:	62 f3 95 48 25 f3 78 	vpternlogq $0x78,%zmm3,%zmm13,%zmm6
  9f6080:	62 f3 f5 40 25 eb 78 	vpternlogq $0x78,%zmm3,%zmm17,%zmm5
  9f6087:	62 f3 c5 40 25 e3 78 	vpternlogq $0x78,%zmm3,%zmm23,%zmm4
  9f608e:	c4 61 fb 93 db       	kmovq  %k3,%r11
  9f6093:	62 f2 7d cb 63 f6    	vpcompressb %zmm6,%zmm6{%k3}{z}
  9f6099:	62 b2 7d 48 8f da    	vpshufbitqmb %zmm18,%zmm0,%k3
  9f609f:	62 f1 7d 48 70 c2 ff 	vpshufd $0xff,%zmm2,%zmm0
  9f60a6:	62 f2 7d ca 63 ed    	vpcompressb %zmm5,%zmm5{%k2}{z}
  9f60ac:	62 f3 5d 50 25 15 c5 71 b8 ff 20 	vpternlogd $0x20,-0x478e3b(%rip){1to16},%zmm20,%zmm2        # 57d27c <tier0_test_int128_integers+0x1f4>
  9f60b7:	62 b2 7d 48 8f d5    	vpshufbitqmb %zmm21,%zmm0,%k2
  9f60bd:	62 f1 5d 50 db 05 b9 71 b8 ff 	vpandd -0x478e47(%rip){1to16},%zmm20,%zmm0        # 57d280 <tier0_test_int128_integers+0x1f8>
  9f60c7:	f3 4d 0f b8 db       	popcnt %r11,%r11
  9f60cc:	62 f2 7d ca 63 e4    	vpcompressb %zmm4,%zmm4{%k2}{z}
  9f60d2:	62 d1 fe 48 7f 32    	vmovdqu64 %zmm6,(%r10)
  9f60d8:	62 b2 3d 48 00 f2    	vpshufb %zmm18,%zmm8,%zmm6
  9f60de:	62 91 fe 48 7f 2c 1a 	vmovdqu64 %zmm5,(%r10,%r11,1)
  9f60e5:	4d 01 d3             	add    %r10,%r11
  9f60e8:	41 29 da             	sub    %ebx,%r10d
  9f60eb:	62 f3 e5 40 25 f3 78 	vpternlogq $0x78,%zmm3,%zmm19,%zmm6
  9f60f2:	62 f2 7d 48 55 d2    	vpopcntd %zmm2,%zmm2
  9f60f8:	c5 d1 ef ed          	vpxor  %xmm5,%xmm5,%xmm5
  9f60fc:	62 f2 7d cb 63 f5    	vpcompressb %zmm6,%zmm5{%k3}{z}
  9f6102:	62 f1 75 48 fe c8    	vpaddd %zmm0,%zmm1,%zmm1
  9f6108:	c5 f9 6f 05 b0 03 b7 ff 	vmovdqa -0x48fc50(%rip),%xmm0        # 5664c0 <check_binding_benchmark_headers+0x21e0>
  9f6110:	62 f1 75 48 fe ca    	vpaddd %zmm2,%zmm1,%zmm1
  9f6116:	62 91 fe 48 7f 2c 1e 	vmovdqu64 %zmm5,(%r14,%r11,1)
  9f611d:	4d 01 f3             	add    %r14,%r11
  9f6120:	c4 61 fb 93 f3       	kmovq  %k3,%r14
  9f6125:	f3 4d 0f b8 fe       	popcnt %r14,%r15
  9f612a:	62 91 fe 48 7f 24 1f 	vmovdqu64 %zmm4,(%r15,%r11,1)
  9f6131:	44 89 54 24 40       	mov    %r10d,0x40(%rsp)
  9f6136:	c4 61 fb 93 d2       	kmovq  %k2,%r10
  9f613b:	f3 4d 0f b8 f2       	popcnt %r10,%r14
  9f6140:	62 f2 7d 48 8d c9    	vpermb %zmm1,%zmm0,%zmm1
  9f6146:	c5 f9 6f 05 82 03 b7 ff 	vmovdqa -0x48fc7e(%rip),%xmm0        # 5664d0 <check_binding_benchmark_headers+0x21f0>
  9f614e:	62 f2 f5 18 40 0d f0 64 b8 ff 	vpmullq -0x479b10(%rip){1to2},%xmm1,%xmm1        # 57c648 <check_mutation_families+0x510>
  9f6158:	4d 01 fe             	add    %r15,%r14
  9f615b:	4d 01 de             	add    %r11,%r14
  9f615e:	62 d2 7d 48 8d d6    	vpermb %zmm14,%zmm0,%zmm2
  9f6164:	c4 e2 71 00 05 73 03 b7 ff 	vpshufb -0x48fc8d(%rip),%xmm1,%xmm0        # 5664e0 <check_binding_benchmark_headers+0x2200>
  9f616d:	62 f2 7e 48 29 da    	vpmovb2m %zmm2,%k3
  9f6173:	c5 7b 93 d3          	kmovd  %k3,%r10d
  9f6177:	45 0f b7 d2          	movzwl %r10w,%r10d
  9f617b:	c5 f9 fc c9          	vpaddb %xmm1,%xmm0,%xmm1
  9f617f:	f3 45 0f b8 d2       	popcnt %r10d,%r10d
  9f6184:	48 ff cf             	dec    %rdi
  9f6187:	62 f2 7d 48 31 c9    	vpmovzxbd %xmm1,%zmm1
  9f618d:	62 f1 75 58 fe 4c 24 10 	vpaddd 0x40(%rsp){1to16},%zmm1,%zmm1
  9f6195:	62 f2 7d cb 8b c9    	vpcompressd %zmm1,%zmm1{%k3}{z}
  9f619b:	62 f1 fe 48 7f 09    	vmovdqu64 %zmm1,(%rcx)
  9f61a1:	4a 8d 0c 91          	lea    (%rcx,%r10,4),%rcx
  9f61a5:	4d 89 f2             	mov    %r14,%r10
  9f61a8:	0f 85 12 fa ff ff    	jne    9f5bc0 <x86_encode_16+0xa0>
  9f61ae:	48 29 c2             	sub    %rax,%rdx
  9f61b1:	0f 86 05 12 00 00    	jbe    9f73bc <x86_encode_16+0x189c>
  9f61b7:	48 c1 e0 04          	shl    $0x4,%rax
  9f61bb:	48 c1 e2 04          	shl    $0x4,%rdx
  9f61bf:	48 8d 7c 24 40       	lea    0x40(%rsp),%rdi
  9f61c4:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
  9f61c8:	62 f1 fd 48 7f 44 24 04 	vmovdqa64 %zmm0,0x100(%rsp)
  9f61d0:	62 f1 fd 48 7f 44 24 03 	vmovdqa64 %zmm0,0xc0(%rsp)
  9f61d8:	62 f1 fd 48 7f 44 24 02 	vmovdqa64 %zmm0,0x80(%rsp)
  9f61e0:	62 f1 fd 48 7f 44 24 01 	vmovdqa64 %zmm0,0x40(%rsp)
  9f61e8:	49 89 cf             	mov    %rcx,%r15
  9f61eb:	48 01 c6             	add    %rax,%rsi
  9f61ee:	c5 f8 77             	vzeroupper
  9f61f1:	e8 5a e2 d6 ff       	call   764450 <memcpy@plt>
  9f61f6:	c5 f9 6f 4c 24 40    	vmovdqa 0x40(%rsp),%xmm1
  9f61fc:	c5 f9 6f 54 24 50    	vmovdqa 0x50(%rsp),%xmm2
  9f6202:	c5 f9 6f 5c 24 60    	vmovdqa 0x60(%rsp),%xmm3
  9f6208:	c5 f9 6f 64 24 70    	vmovdqa 0x70(%rsp),%xmm4
  9f620e:	48 8d 05 2b 13 71 07 	lea    0x771132b(%rip),%rax        # 8107540 <x86_template_storage>
  9f6215:	c5 f9 6f b4 24 80 00 00 00 	vmovdqa 0x80(%rsp),%xmm6
  9f621e:	62 71 fd 48 6f 3d 18 a9 aa ff 	vmovdqa64 -0x5556e8(%rip),%zmm15        # 4a0b40 <check_builtin_atomic_rmw_test_clang.native_source+0x3640>
  9f6228:	c5 f9 6f bc 24 c0 00 00 00 	vmovdqa 0xc0(%rsp),%xmm7
  9f6231:	c5 79 6f 84 24 e0 00 00 00 	vmovdqa 0xe0(%rsp),%xmm8
  9f623a:	62 f1 fd 48 6f 6c 24 01 	vmovdqa64 0x40(%rsp),%zmm5
  9f6242:	62 71 fd 48 6f 54 24 02 	vmovdqa64 0x80(%rsp),%zmm10
  9f624a:	62 71 fd 48 6f 5c 24 03 	vmovdqa64 0xc0(%rsp),%zmm11
  9f6252:	62 71 fd 48 6f 64 24 04 	vmovdqa64 0x100(%rsp),%zmm12
  9f625a:	62 e2 7d 48 5a 0d ac 02 b7 ff 	vbroadcasti32x4 -0x48fd54(%rip),%zmm17        # 566510 <check_binding_benchmark_headers+0x2230>
  9f6264:	62 a3 4d 40 25 f6 ff 	vpternlogd $0xff,%zmm22,%zmm22,%zmm22
  9f626b:	62 e2 7d 48 58 2d af 6f b8 ff 	vpbroadcastd -0x479051(%rip),%zmm21        # 57d224 <tier0_test_int128_integers+0x19c>
  9f6275:	62 62 7d 48 58 1d b1 6f b8 ff 	vpbroadcastd -0x47904f(%rip),%zmm27        # 57d230 <tier0_test_int128_integers+0x1a8>
  9f627f:	62 62 7d 48 58 0d ab 6f b8 ff 	vpbroadcastd -0x479055(%rip),%zmm25        # 57d234 <tier0_test_int128_integers+0x1ac>
  9f6289:	c5 f9 c5 c9 06       	vpextrw $0x6,%xmm1,%ecx
  9f628e:	c5 f9 c5 d2 06       	vpextrw $0x6,%xmm2,%edx
  9f6293:	c5 f9 c5 fc 06       	vpextrw $0x6,%xmm4,%edi
  9f6298:	c5 f9 c5 f3 06       	vpextrw $0x6,%xmm3,%esi
  9f629d:	c5 f9 6f a4 24 90 00 00 00 	vmovdqa 0x90(%rsp),%xmm4
  9f62a6:	62 51 55 48 62 ea    	vpunpckldq %zmm10,%zmm5,%zmm13
  9f62ac:	62 51 25 48 62 f4    	vpunpckldq %zmm12,%zmm11,%zmm14
  9f62b2:	62 d1 55 48 6a ea    	vpunpckhdq %zmm10,%zmm5,%zmm5
  9f62b8:	62 51 25 48 6a d4    	vpunpckhdq %zmm12,%zmm11,%zmm10
  9f62be:	c1 e1 06             	shl    $0x6,%ecx
  9f62c1:	c1 e2 06             	shl    $0x6,%edx
  9f62c4:	c1 e6 06             	shl    $0x6,%esi
  9f62c7:	c1 e7 06             	shl    $0x6,%edi
  9f62ca:	62 51 95 48 6d de    	vpunpckhqdq %zmm14,%zmm13,%zmm11
  9f62d0:	62 d1 95 48 6c c6    	vpunpcklqdq %zmm14,%zmm13,%zmm0
  9f62d6:	62 51 d5 48 6c f2    	vpunpcklqdq %zmm10,%zmm5,%zmm14
  9f62dc:	62 d1 d5 48 6d ea    	vpunpckhqdq %zmm10,%zmm5,%zmm5
  9f62e2:	c5 fd 6f 4c 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm1
  9f62e8:	c5 fd 6f 54 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm2
  9f62ee:	b1 cc                	mov    $0xcc,%cl
  9f62f0:	62 d1 15 48 72 d6 1a 	vpsrld $0x1a,%zmm14,%zmm13
  9f62f7:	62 e2 15 48 36 25 bf a8 aa ff 	vpermd -0x555741(%rip),%zmm13,%zmm20        # 4a0bc0 <check_builtin_atomic_rmw_test_clang.native_source+0x36c0>
  9f6301:	62 d2 25 48 27 c3    	vptestmd %zmm11,%zmm11,%k0
  9f6307:	62 d1 65 40 72 e3 1f 	vpsrad $0x1f,%zmm11,%zmm19
  9f630e:	62 21 25 48 fe c6    	vpaddd %zmm22,%zmm11,%zmm24
  9f6314:	62 43 55 40 25 ce 6c 	vpternlogd $0x6c,%zmm14,%zmm21,%zmm25
  9f631b:	62 f3 f5 48 3a 4c 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm1,%zmm1
  9f6324:	62 f3 ed 48 3a 5c 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm2,%zmm3
  9f632d:	c5 fb 92 c9          	kmovd  %ecx,%k1
  9f6331:	c5 f9 c5 ce 06       	vpextrw $0x6,%xmm6,%ecx
  9f6336:	c5 f9 6f b4 24 a0 00 00 00 	vmovdqa 0xa0(%rsp),%xmm6
  9f633f:	c1 e1 06             	shl    $0x6,%ecx
  9f6342:	c5 f9 c5 d4 06       	vpextrw $0x6,%xmm4,%edx
  9f6347:	c5 f9 6f a4 24 b0 00 00 00 	vmovdqa 0xb0(%rsp),%xmm4
  9f6350:	c1 e2 06             	shl    $0x6,%edx
  9f6353:	62 f2 f5 49 64 d3    	vpblendmq %zmm3,%zmm1,%zmm2{%k1}
  9f6359:	62 f2 85 48 7e cb    	vpermt2q %zmm3,%zmm15,%zmm1
  9f635f:	c5 fd 6f 5c 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm3
  9f6365:	c5 f9 c5 cf 06       	vpextrw $0x6,%xmm7,%ecx
  9f636a:	c5 f9 6f bc 24 d0 00 00 00 	vmovdqa 0xd0(%rsp),%xmm7
  9f6373:	c5 f9 c5 f6 06       	vpextrw $0x6,%xmm6,%esi
  9f6378:	c1 e6 06             	shl    $0x6,%esi
  9f637b:	c1 e1 06             	shl    $0x6,%ecx
  9f637e:	62 f3 e5 48 3a 5c 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm3,%zmm3
  9f6387:	c4 c1 79 c5 f0 06    	vpextrw $0x6,%xmm8,%esi
  9f638d:	c1 e6 06             	shl    $0x6,%esi
  9f6390:	c5 f9 c5 fc 06       	vpextrw $0x6,%xmm4,%edi
  9f6395:	c5 fd 6f 64 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm4
  9f639b:	c1 e7 06             	shl    $0x6,%edi
  9f639e:	62 f3 dd 48 3a 74 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm4,%zmm6
  9f63a7:	c5 f9 c5 d7 06       	vpextrw $0x6,%xmm7,%edx
  9f63ac:	c5 f9 6f bc 24 f0 00 00 00 	vmovdqa 0xf0(%rsp),%xmm7
  9f63b5:	c1 e2 06             	shl    $0x6,%edx
  9f63b8:	62 f2 e5 49 64 e6    	vpblendmq %zmm6,%zmm3,%zmm4{%k1}
  9f63be:	62 f2 85 48 7e de    	vpermt2q %zmm6,%zmm15,%zmm3
  9f63c4:	c5 fd 6f 74 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm6
  9f63ca:	0f b7 8c 24 0c 01 00 00 	movzwl 0x10c(%rsp),%ecx
  9f63d2:	c5 f9 c5 ff 06       	vpextrw $0x6,%xmm7,%edi
  9f63d7:	c5 fd 6f 7c 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm7
  9f63dd:	62 f3 cd 48 3a 74 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm6,%zmm6
  9f63e6:	0f b7 94 24 1c 01 00 00 	movzwl 0x11c(%rsp),%edx
  9f63ee:	0f b7 b4 24 2c 01 00 00 	movzwl 0x12c(%rsp),%esi
  9f63f6:	62 71 6d 48 6a d4    	vpunpckhdq %zmm4,%zmm2,%zmm10
  9f63fc:	c1 e7 06             	shl    $0x6,%edi
  9f63ff:	62 73 c5 48 3a 44 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm7,%zmm8
  9f6408:	0f b7 bc 24 3c 01 00 00 	movzwl 0x13c(%rsp),%edi
  9f6410:	c1 e1 06             	shl    $0x6,%ecx
  9f6413:	c1 e2 06             	shl    $0x6,%edx
  9f6416:	c1 e6 06             	shl    $0x6,%esi
  9f6419:	c5 7d 6f 4c 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm9
  9f641f:	c1 e7 06             	shl    $0x6,%edi
  9f6422:	62 e3 b5 48 3a 44 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm9,%zmm16
  9f642b:	62 d2 cd 49 64 f8    	vpblendmq %zmm8,%zmm6,%zmm7{%k1}
  9f6431:	62 d2 85 48 7e f0    	vpermt2q %zmm8,%zmm15,%zmm6
  9f6437:	c5 7d 6f 44 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm8
  9f643d:	62 73 bd 48 3a 44 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm8,%zmm8
  9f6446:	62 32 bd 49 64 c8    	vpblendmq %zmm16,%zmm8,%zmm9{%k1}
  9f644c:	62 32 85 48 7e c0    	vpermt2q %zmm16,%zmm15,%zmm8
  9f6452:	62 e2 7d 48 5a 05 94 00 b7 ff 	vbroadcasti32x4 -0x48ff6c(%rip),%zmm16        # 5664f0 <check_binding_benchmark_headers+0x2210>
  9f645c:	62 72 15 48 36 3d 1a a7 aa ff 	vpermd -0x5558e6(%rip),%zmm13,%zmm15        # 4a0b80 <check_builtin_atomic_rmw_test_clang.native_source+0x3680>
  9f6466:	62 72 15 48 36 2d 90 a7 aa ff 	vpermd -0x555870(%rip),%zmm13,%zmm13        # 4a0c00 <check_builtin_atomic_rmw_test_clang.native_source+0x3700>
  9f6470:	62 51 45 48 6a e1    	vpunpckhdq %zmm9,%zmm7,%zmm12
  9f6476:	62 51 ad 48 6d d4    	vpunpckhqdq %zmm12,%zmm10,%zmm10
  9f647c:	62 d1 45 40 72 d2 1d 	vpsrld $0x1d,%zmm10,%zmm23
  9f6483:	62 52 fd 40 83 e6    	vpmultishiftqb %zmm14,%zmm16,%zmm12
  9f6489:	62 e2 7d 48 5a 05 6d 00 b7 ff 	vbroadcasti32x4 -0x48ff93(%rip),%zmm16        # 566500 <check_binding_benchmark_headers+0x2220>
  9f6493:	62 c2 fd 40 83 c6    	vpmultishiftqb %zmm14,%zmm16,%zmm16
  9f6499:	62 e3 1d 58 25 05 78 6d b8 ff d8 	vpternlogd $0xd8,-0x479288(%rip){1to16},%zmm12,%zmm16        # 57d21c <tier0_test_int128_integers+0x194>
  9f64a4:	62 52 f5 40 83 e6    	vpmultishiftqb %zmm14,%zmm17,%zmm12
  9f64aa:	62 e2 7d 48 5a 0d 6c 00 b7 ff 	vbroadcasti32x4 -0x48ff94(%rip),%zmm17        # 566520 <check_binding_benchmark_headers+0x2240>
  9f64b4:	62 73 7d 50 25 25 61 6d b8 ff e4 	vpternlogd $0xe4,-0x47929f(%rip){1to16},%zmm16,%zmm12        # 57d220 <tier0_test_int128_integers+0x198>
  9f64bf:	62 c2 75 40 00 ce    	vpshufb %zmm14,%zmm17,%zmm17
  9f64c5:	62 d1 7d 40 72 f6 04 	vpslld $0x4,%zmm14,%zmm16
  9f64cc:	62 b1 7d 40 72 e0 1f 	vpsrad $0x1f,%zmm16,%zmm16
  9f64d3:	62 c3 1d 48 25 e7 f8 	vpternlogd $0xf8,%zmm15,%zmm12,%zmm20
  9f64da:	62 b1 05 48 72 f1 10 	vpslld $0x10,%zmm17,%zmm15
  9f64e1:	62 a1 7d 40 db c9    	vpandd %zmm17,%zmm16,%zmm17
  9f64e7:	62 e3 15 58 25 0d 7a 6d b8 ff ec 	vpternlogd $0xec,-0x479286(%rip){1to16},%zmm13,%zmm17        # 57d26c <tier0_test_int128_integers+0x1e4>
  9f64f2:	62 d1 6d 40 72 e7 1f 	vpsrad $0x1f,%zmm15,%zmm18
  9f64f9:	62 72 7e 48 38 f8    	vpmovm2d %k0,%zmm15
  9f64ff:	62 23 7d 40 25 dc ea 	vpternlogd $0xea,%zmm20,%zmm16,%zmm27
  9f6506:	62 b1 2d 40 72 d4 10 	vpsrld $0x10,%zmm20,%zmm26
  9f650d:	62 e3 2d 58 25 0d 58 6d b8 ff f8 	vpternlogd $0xf8,-0x4792a8(%rip){1to16},%zmm10,%zmm17        # 57d270 <tier0_test_int128_integers+0x1e8>
  9f6518:	62 33 7d 40 25 fa c8 	vpternlogd $0xc8,%zmm18,%zmm16,%zmm15
  9f651f:	62 c1 65 40 ef d3    	vpxord %zmm11,%zmm19,%zmm18
  9f6525:	62 e2 7d 48 58 1d f9 6c b8 ff 	vpbroadcastd -0x479307(%rip),%zmm19        # 57d228 <tier0_test_int128_integers+0x1a0>
  9f652f:	62 71 05 58 db 2d 3b 6d b8 ff 	vpandd -0x4792c5(%rip){1to16},%zmm15,%zmm13        # 57d274 <tier0_test_int128_integers+0x1ec>
  9f6539:	62 e1 7d 50 db 05 35 6d b8 ff 	vpandd -0x4792cb(%rip){1to16},%zmm16,%zmm16        # 57d278 <tier0_test_int128_integers+0x1f0>
  9f6543:	62 a2 7d 48 44 d2    	vplzcntd %zmm18,%zmm18
  9f6549:	62 a2 65 40 45 d2    	vpsrlvd %zmm18,%zmm19,%zmm18
  9f654f:	62 23 25 48 25 c2 14 	vpternlogd $0x14,%zmm18,%zmm11,%zmm24
  9f6556:	62 a2 3d 40 14 d7    	vprorvd %zmm23,%zmm24,%zmm18
  9f655c:	62 62 7d 48 58 05 c6 6c b8 ff 	vpbroadcastd -0x47933a(%rip),%zmm24        # 57d22c <tier0_test_int128_integers+0x1a4>
  9f6566:	62 b1 6d 40 72 e2 1f 	vpsrad $0x1f,%zmm18,%zmm18
  9f656d:	62 c3 6d 40 25 c5 b8 	vpternlogd $0xb8,%zmm13,%zmm18,%zmm16
  9f6574:	62 23 05 48 25 c4 ea 	vpternlogd $0xea,%zmm20,%zmm15,%zmm24
  9f657b:	62 b1 5d 40 72 d4 03 	vpsrld $0x3,%zmm20,%zmm20
  9f6582:	62 e3 2d 50 25 25 c3 6c b8 ff ec 	vpternlogd $0xec,-0x47933d(%rip){1to16},%zmm26,%zmm20        # 57d250 <tier0_test_int128_integers+0x1c8>
  9f658d:	62 03 6d 40 25 d8 b8 	vpternlogd $0xb8,%zmm24,%zmm18,%zmm27
  9f6594:	62 21 35 40 fe c6    	vpaddd %zmm22,%zmm25,%zmm24
  9f659a:	62 d1 35 40 72 d6 08 	vpsrld $0x8,%zmm14,%zmm25
  9f65a1:	62 63 55 50 25 0d 8c 6c b8 ff 6c 	vpternlogd $0x6c,-0x479374(%rip){1to16},%zmm21,%zmm25        # 57d238 <tier0_test_int128_integers+0x1b0>
  9f65ac:	62 51 55 48 eb f6    	vpord  %zmm14,%zmm5,%zmm14
  9f65b2:	62 d1 0d 48 72 f6 07 	vpslld $0x7,%zmm14,%zmm14
  9f65b9:	62 a1 35 40 fe ee    	vpaddd %zmm22,%zmm25,%zmm21
  9f65bf:	62 62 7d 48 58 0d 73 6c b8 ff 	vpbroadcastd -0x47938d(%rip),%zmm25        # 57d23c <tier0_test_int128_integers+0x1b4>
  9f65c9:	62 63 3d 50 25 0d 6c 6c b8 ff ea 	vpternlogd $0xea,-0x479394(%rip){1to16},%zmm24,%zmm25        # 57d240 <tier0_test_int128_integers+0x1b8>
  9f65d4:	62 b1 3d 40 72 f4 08 	vpslld $0x8,%zmm20,%zmm24
  9f65db:	62 63 55 50 25 0d 5e 6c b8 ff f8 	vpternlogd $0xf8,-0x4793a2(%rip){1to16},%zmm21,%zmm25        # 57d244 <tier0_test_int128_integers+0x1bc>
  9f65e6:	62 e1 1d 58 db 2d 58 6c b8 ff 	vpandd -0x4793a8(%rip){1to16},%zmm12,%zmm21        # 57d248 <tier0_test_int128_integers+0x1c0>
  9f65f0:	62 83 2d 48 25 e9 f8 	vpternlogd $0xf8,%zmm25,%zmm10,%zmm21
  9f65f7:	62 d1 35 40 72 d4 03 	vpsrld $0x3,%zmm12,%zmm25
  9f65fe:	62 63 2d 58 25 0d 4b 6c b8 ff a2 	vpternlogd $0xa2,-0x4793b5(%rip){1to16},%zmm10,%zmm25        # 57d254 <tier0_test_int128_integers+0x1cc>
  9f6609:	62 e2 55 50 3b 2d 39 6c b8 ff 	vpminud -0x4793c7(%rip){1to16},%zmm21,%zmm21        # 57d24c <tier0_test_int128_integers+0x1c4>
  9f6613:	62 31 35 40 fe e6    	vpaddd %zmm22,%zmm25,%zmm12
  9f6619:	62 e2 35 50 3b 35 35 6c b8 ff 	vpminud -0x4793cb(%rip){1to16},%zmm25,%zmm22        # 57d258 <tier0_test_int128_integers+0x1d0>
  9f6623:	62 62 7d 48 5a 0d 03 ff b6 ff 	vbroadcasti32x4 -0x4900fd(%rip),%zmm25        # 566530 <check_binding_benchmark_headers+0x2250>
  9f662d:	62 d1 1d 48 72 e4 1f 	vpsrad $0x1f,%zmm12,%zmm12
  9f6634:	62 63 1d 58 25 05 1d 6c b8 ff 08 	vpternlogd $0x8,-0x4793e3(%rip){1to16},%zmm12,%zmm24        # 57d25c <tier0_test_int128_integers+0x1d4>
  9f663f:	62 62 b5 40 83 cd    	vpmultishiftqb %zmm5,%zmm25,%zmm25
  9f6645:	62 63 5d 50 25 0d 14 6c b8 ff d8 	vpternlogd $0xd8,-0x4793ec(%rip){1to16},%zmm20,%zmm25        # 57d264 <tier0_test_int128_integers+0x1dc>
  9f6650:	62 a3 4d 40 25 cd fe 	vpternlogd $0xfe,%zmm21,%zmm22,%zmm17
  9f6657:	62 31 7d 40 eb e9    	vpord  %zmm17,%zmm16,%zmm13
  9f665d:	62 d1 7d 40 72 cb 01 	vprold $0x1,%zmm11,%zmm16
  9f6664:	62 73 3d 50 25 35 f1 6b b8 ff e4 	vpternlogd $0xe4,-0x47940f(%rip){1to16},%zmm24,%zmm14        # 57d260 <tier0_test_int128_integers+0x1d8>
  9f666f:	62 63 0d 58 25 0d ee 6b b8 ff d8 	vpternlogd $0xd8,-0x479412(%rip){1to16},%zmm14,%zmm25        # 57d268 <tier0_test_int128_integers+0x1e0>
  9f667a:	62 32 7d 40 14 f7    	vprorvd %zmm23,%zmm16,%zmm14
  9f6680:	62 53 05 48 25 f3 e2 	vpternlogd $0xe2,%zmm11,%zmm15,%zmm14
  9f6687:	62 53 6d 40 25 f3 e2 	vpternlogd $0xe2,%zmm11,%zmm18,%zmm14
  9f668e:	62 c1 7d 48 70 d5 00 	vpshufd $0x0,%zmm13,%zmm18
  9f6695:	62 51 7d 48 62 de    	vpunpckldq %zmm14,%zmm0,%zmm11
  9f669b:	62 f2 6d 40 8f c9    	vpshufbitqmb %zmm1,%zmm18,%k1
  9f66a1:	62 d1 7d 48 6a c6    	vpunpckhdq %zmm14,%zmm0,%zmm0
  9f66a7:	c4 e1 fb 93 c1       	kmovq  %k1,%rax
  9f66ac:	62 81 25 40 62 c9    	vpunpckldq %zmm25,%zmm27,%zmm17
  9f66b2:	62 11 25 40 6a f9    	vpunpckhdq %zmm25,%zmm27,%zmm15
  9f66b8:	f3 48 0f b8 c0       	popcnt %rax,%rax
  9f66bd:	62 a1 a5 48 6c c1    	vpunpcklqdq %zmm17,%zmm11,%zmm16
  9f66c3:	62 31 a5 48 6d d9    	vpunpckhqdq %zmm17,%zmm11,%zmm11
  9f66c9:	62 e2 7d 48 5a 0d dd fd b6 ff 	vbroadcasti32x4 -0x490223(%rip),%zmm17        # 5664b0 <check_binding_benchmark_headers+0x21d0>
  9f66d3:	62 c1 fd 48 6c df    	vpunpcklqdq %zmm15,%zmm0,%zmm19
  9f66d9:	62 d1 fd 48 6d c7    	vpunpckhqdq %zmm15,%zmm0,%zmm0
  9f66df:	62 51 7d 48 70 fd 55 	vpshufd $0x55,%zmm13,%zmm15
  9f66e6:	49 8d 0c 06          	lea    (%r14,%rax,1),%rcx
  9f66ea:	62 e2 7d 40 00 c1    	vpshufb %zmm1,%zmm16,%zmm16
  9f66f0:	62 d2 7d 48 00 c0    	vpshufb %zmm8,%zmm0,%zmm0
  9f66f6:	62 a3 ed 48 25 c1 78 	vpternlogq $0x78,%zmm17,%zmm2,%zmm16
  9f66fd:	62 f2 25 48 00 d3    	vpshufb %zmm3,%zmm11,%zmm2
  9f6703:	62 b3 b5 48 25 c1 78 	vpternlogq $0x78,%zmm17,%zmm9,%zmm0
  9f670a:	62 e2 7d c9 63 c1    	vpcompressb %zmm16,%zmm1{%k1}{z}
  9f6710:	62 f2 05 48 8f cb    	vpshufbitqmb %zmm3,%zmm15,%k1
  9f6716:	62 d1 7d 48 70 dd aa 	vpshufd $0xaa,%zmm13,%zmm3
  9f671d:	62 b3 dd 48 25 d1 78 	vpternlogq $0x78,%zmm17,%zmm4,%zmm2
  9f6724:	62 d1 7d 48 70 e5 ff 	vpshufd $0xff,%zmm13,%zmm4
  9f672b:	62 73 2d 58 25 2d 46 6b b8 ff 20 	vpternlogd $0x20,-0x4794ba(%rip){1to16},%zmm10,%zmm13        # 57d27c <tier0_test_int128_integers+0x1f4>
  9f6736:	c4 e1 fb 93 d1       	kmovq  %k1,%rdx
  9f673b:	f3 48 0f b8 d2       	popcnt %rdx,%rdx
  9f6740:	62 d1 fe 48 7f 0e    	vmovdqu64 %zmm1,(%r14)
  9f6746:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
  9f674a:	62 f2 7d c9 63 d1    	vpcompressb %zmm2,%zmm1{%k1}{z}
  9f6750:	62 f2 65 40 00 d6    	vpshufb %zmm6,%zmm19,%zmm2
  9f6756:	62 f2 65 48 8f ce    	vpshufbitqmb %zmm6,%zmm3,%k1
  9f675c:	62 f1 2d 58 db 1d 1a 6b b8 ff 	vpandd -0x4794e6(%rip){1to16},%zmm10,%zmm3        # 57d280 <tier0_test_int128_integers+0x1f8>
  9f6766:	48 8d 34 11          	lea    (%rcx,%rdx,1),%rsi
  9f676a:	62 b3 c5 48 25 d1 78 	vpternlogq $0x78,%zmm17,%zmm7,%zmm2
  9f6771:	62 d1 fe 48 7f 0c 06 	vmovdqu64 %zmm1,(%r14,%rax,1)
  9f6778:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
  9f677c:	62 f2 7d c9 63 d1    	vpcompressb %zmm2,%zmm1{%k1}{z}
  9f6782:	c4 e1 fb 93 c1       	kmovq  %k1,%rax
  9f6787:	62 d2 5d 48 8f c8    	vpshufbitqmb %zmm8,%zmm4,%k1
  9f678d:	41 29 de             	sub    %ebx,%r14d
  9f6790:	f3 48 0f b8 f8       	popcnt %rax,%rdi
  9f6795:	62 f2 7d c9 63 c0    	vpcompressb %zmm0,%zmm0{%k1}{z}
  9f679b:	c4 e1 fb 93 c1       	kmovq  %k1,%rax
  9f67a0:	f3 48 0f b8 c0       	popcnt %rax,%rax
  9f67a5:	62 f1 fe 48 7f 0c 0a 	vmovdqu64 %zmm1,(%rdx,%rcx,1)
  9f67ac:	62 f1 1d 48 fe cb    	vpaddd %zmm3,%zmm12,%zmm1
  9f67b2:	48 01 f8             	add    %rdi,%rax
  9f67b5:	48 01 f0             	add    %rsi,%rax
  9f67b8:	62 f1 fe 48 7f 04 37 	vmovdqu64 %zmm0,(%rdi,%rsi,1)
  9f67bf:	62 d2 7d 48 55 c5    	vpopcntd %zmm13,%zmm0
  9f67c5:	44 89 74 24 3c       	mov    %r14d,0x3c(%rsp)
  9f67ca:	49 89 c6             	mov    %rax,%r14
  9f67cd:	62 f1 75 48 fe c0    	vpaddd %zmm0,%zmm1,%zmm0
  9f67d3:	c5 f9 6f 0d e5 fc b6 ff 	vmovdqa -0x49031b(%rip),%xmm1        # 5664c0 <check_binding_benchmark_headers+0x21e0>
  9f67db:	62 f2 75 48 8d c0    	vpermb %zmm0,%zmm1,%zmm0
  9f67e1:	62 f2 fd 18 40 05 5d 5e b8 ff 	vpmullq -0x47a1a3(%rip){1to2},%xmm0,%xmm0        # 57c648 <check_mutation_families+0x510>
  9f67eb:	c5 f9 6f 0d dd fc b6 ff 	vmovdqa -0x490323(%rip),%xmm1        # 5664d0 <check_binding_benchmark_headers+0x21f0>
  9f67f3:	c4 e2 79 00 15 e4 fc b6 ff 	vpshufb -0x49031c(%rip),%xmm0,%xmm2        # 5664e0 <check_binding_benchmark_headers+0x2200>
  9f67fc:	62 f2 75 48 8d cd    	vpermb %zmm5,%zmm1,%zmm1
  9f6802:	c5 e9 fc c0          	vpaddb %xmm0,%xmm2,%xmm0
  9f6806:	62 f2 7d 48 31 c0    	vpmovzxbd %xmm0,%zmm0
  9f680c:	62 f1 7d 58 fe 44 24 0f 	vpaddd 0x3c(%rsp){1to16},%zmm0,%zmm0
  9f6814:	62 f2 7e 48 29 c9    	vpmovb2m %zmm1,%k1
  9f681a:	62 f2 7d c9 8b c0    	vpcompressd %zmm0,%zmm0{%k1}{z}
  9f6820:	62 d1 fe 48 7f 07    	vmovdqu64 %zmm0,(%r15)
  9f6826:	e9 91 0b 00 00       	jmp    9f73bc <x86_encode_16+0x189c>
  9f682b:	62 f2 7d 48 5a 1d 7b fc b6 ff 	vbroadcasti32x4 -0x490385(%rip),%zmm3        # 5664b0 <check_binding_benchmark_headers+0x21d0>
  9f6835:	62 72 7d 48 58 0d 01 6a b8 ff 	vpbroadcastd -0x4795ff(%rip),%zmm9        # 57d240 <tier0_test_int128_integers+0x1b8>
  9f683f:	48 8d 4a f0          	lea    -0x10(%rdx),%rcx
  9f6843:	41 b1 cc             	mov    $0xcc,%r9b
  9f6846:	48 8d be fc 00 00 00 	lea    0xfc(%rsi),%rdi
  9f684d:	4c 8d 05 ec 0c 71 07 	lea    0x7710cec(%rip),%r8        # 8107540 <x86_template_storage>
  9f6854:	62 53 1d 48 25 e4 ff 	vpternlogd $0xff,%zmm12,%zmm12,%zmm12
  9f685b:	31 c0                	xor    %eax,%eax
  9f685d:	49 89 de             	mov    %rbx,%r14
  9f6860:	48 c1 e9 04          	shr    $0x4,%rcx
  9f6864:	c4 c1 7b 92 c9       	kmovd  %r9d,%k1
  9f6869:	48 ff c1             	inc    %rcx
  9f686c:	0f 1f 40 00          	nopl   0x0(%rax)
  9f6870:	44 0f b7 8f 10 ff ff ff 	movzwl -0xf0(%rdi),%r9d
  9f6878:	44 0f b7 97 20 ff ff ff 	movzwl -0xe0(%rdi),%r10d
  9f6880:	44 0f b7 9f 30 ff ff ff 	movzwl -0xd0(%rdi),%r11d
  9f6888:	44 0f b7 bf 40 ff ff ff 	movzwl -0xc0(%rdi),%r15d
  9f6890:	62 e1 fe 48 6f 9f 04 ff ff ff 	vmovdqu64 -0xfc(%rdi),%zmm19
  9f689a:	62 e1 fe 48 6f af 44 ff ff ff 	vmovdqu64 -0xbc(%rdi),%zmm21
  9f68a4:	62 e1 fe 48 6f b7 84 ff ff ff 	vmovdqu64 -0x7c(%rdi),%zmm22
  9f68ae:	62 e1 fe 48 6f bf c4 ff ff ff 	vmovdqu64 -0x3c(%rdi),%zmm23
  9f68b8:	62 f2 7d 48 5a 0d 2e fc b6 ff 	vbroadcasti32x4 -0x4903d2(%rip),%zmm1        # 5664f0 <check_binding_benchmark_headers+0x2210>
  9f68c2:	48 83 c0 10          	add    $0x10,%rax
  9f68c6:	41 c1 e1 06          	shl    $0x6,%r9d
  9f68ca:	41 c1 e2 06          	shl    $0x6,%r10d
  9f68ce:	41 c1 e3 06          	shl    $0x6,%r11d
  9f68d2:	41 c1 e7 06          	shl    $0x6,%r15d
  9f68d6:	c4 81 7d 6f 64 01 40 	vmovdqa 0x40(%r9,%r8,1),%ymm4
  9f68dd:	44 0f b7 8f 50 ff ff ff 	movzwl -0xb0(%rdi),%r9d
  9f68e5:	c4 81 7d 6f 6c 02 60 	vmovdqa 0x60(%r10,%r8,1),%ymm5
  9f68ec:	44 0f b7 97 60 ff ff ff 	movzwl -0xa0(%rdi),%r10d
  9f68f4:	62 93 dd 48 3a 64 03 02 01 	vinserti64x4 $0x1,0x40(%r11,%r8,1),%zmm4,%zmm4
  9f68fd:	62 13 d5 48 3a 7c 07 03 01 	vinserti64x4 $0x1,0x60(%r15,%r8,1),%zmm5,%zmm15
  9f6906:	44 0f b7 9f 70 ff ff ff 	movzwl -0x90(%rdi),%r11d
  9f690e:	44 0f b7 7f 80       	movzwl -0x80(%rdi),%r15d
  9f6913:	62 b1 65 40 62 f5    	vpunpckldq %zmm21,%zmm19,%zmm6
  9f6919:	62 b1 4d 40 62 ff    	vpunpckldq %zmm23,%zmm22,%zmm7
  9f691f:	62 a1 4d 40 6a f7    	vpunpckhdq %zmm23,%zmm22,%zmm22
  9f6925:	62 a1 65 40 6a ed    	vpunpckhdq %zmm21,%zmm19,%zmm21
  9f692b:	62 b1 d5 40 6c d6    	vpunpcklqdq %zmm22,%zmm21,%zmm2
  9f6931:	62 e1 cd 48 6d ff    	vpunpckhqdq %zmm7,%zmm6,%zmm23
  9f6937:	62 62 f5 48 83 da    	vpmultishiftqb %zmm2,%zmm1,%zmm27
  9f693d:	62 f2 7d 48 5a 0d b9 fb b6 ff 	vbroadcasti32x4 -0x490447(%rip),%zmm1        # 566500 <check_binding_benchmark_headers+0x2220>
  9f6947:	62 f1 0d 40 72 d2 1a 	vpsrld $0x1a,%zmm2,%zmm30
  9f694e:	62 62 0d 40 36 15 28 a2 aa ff 	vpermd -0x555dd8(%rip),%zmm30,%zmm26        # 4a0b80 <check_builtin_atomic_rmw_test_clang.native_source+0x3680>
  9f6958:	62 b2 45 40 27 c7    	vptestmd %zmm23,%zmm23,%k0
  9f695e:	62 e1 fd 48 6f da    	vmovdqa64 %zmm2,%zmm19
  9f6964:	41 c1 e1 06          	shl    $0x6,%r9d
  9f6968:	41 c1 e2 06          	shl    $0x6,%r10d
  9f696c:	c4 01 7d 6f 44 01 40 	vmovdqa 0x40(%r9,%r8,1),%ymm8
  9f6973:	44 0f b7 4f 90       	movzwl -0x70(%rdi),%r9d
  9f6978:	41 c1 e3 06          	shl    $0x6,%r11d
  9f697c:	c4 01 7d 6f 54 02 60 	vmovdqa 0x60(%r10,%r8,1),%ymm10
  9f6983:	44 0f b7 57 a0       	movzwl -0x60(%rdi),%r10d
  9f6988:	41 c1 e7 06          	shl    $0x6,%r15d
  9f698c:	62 13 bd 48 3a 44 03 02 01 	vinserti64x4 $0x1,0x40(%r11,%r8,1),%zmm8,%zmm8
  9f6995:	62 83 ad 48 3a 4c 07 03 01 	vinserti64x4 $0x1,0x60(%r15,%r8,1),%zmm10,%zmm17
  9f699e:	44 0f b7 5f b0       	movzwl -0x50(%rdi),%r11d
  9f69a3:	44 0f b7 7f c0       	movzwl -0x40(%rdi),%r15d
  9f69a8:	62 d2 dd 49 64 ef    	vpblendmq %zmm15,%zmm4,%zmm5{%k1}
  9f69ae:	41 c1 e1 06          	shl    $0x6,%r9d
  9f69b2:	41 c1 e2 06          	shl    $0x6,%r10d
  9f69b6:	c4 01 7d 6f 5c 01 40 	vmovdqa 0x40(%r9,%r8,1),%ymm11
  9f69bd:	44 0f b7 4f d0       	movzwl -0x30(%rdi),%r9d
  9f69c2:	41 c1 e3 06          	shl    $0x6,%r11d
  9f69c6:	c4 01 7d 6f 6c 02 60 	vmovdqa 0x60(%r10,%r8,1),%ymm13
  9f69cd:	44 0f b7 57 e0       	movzwl -0x20(%rdi),%r10d
  9f69d2:	41 c1 e7 06          	shl    $0x6,%r15d
  9f69d6:	62 62 f5 48 83 ea    	vpmultishiftqb %zmm2,%zmm1,%zmm29
  9f69dc:	62 f2 7d 48 5a 0d 2a fb b6 ff 	vbroadcasti32x4 -0x4904d6(%rip),%zmm1        # 566510 <check_binding_benchmark_headers+0x2230>
  9f69e6:	62 63 25 50 25 2d 2b 68 b8 ff d8 	vpternlogd $0xd8,-0x4797d5(%rip){1to16},%zmm27,%zmm29        # 57d21c <tier0_test_int128_integers+0x194>
  9f69f1:	62 13 a5 48 3a 5c 03 02 01 	vinserti64x4 $0x1,0x40(%r11,%r8,1),%zmm11,%zmm11
  9f69fa:	62 83 95 48 3a 54 07 03 01 	vinserti64x4 $0x1,0x60(%r15,%r8,1),%zmm13,%zmm18
  9f6a03:	44 0f b7 5f f0       	movzwl -0x10(%rdi),%r11d
  9f6a08:	44 0f b7 3f          	movzwl (%rdi),%r15d
  9f6a0c:	48 81 c7 00 01 00 00 	add    $0x100,%rdi
  9f6a13:	62 32 bd 49 64 d1    	vpblendmq %zmm17,%zmm8,%zmm10{%k1}
  9f6a19:	62 41 55 48 6a c2    	vpunpckhdq %zmm10,%zmm5,%zmm24
  9f6a1f:	41 c1 e1 06          	shl    $0x6,%r9d
  9f6a23:	41 c1 e2 06          	shl    $0x6,%r10d
  9f6a27:	41 c1 e3 06          	shl    $0x6,%r11d
  9f6a2b:	c4 01 7d 6f 74 01 40 	vmovdqa 0x40(%r9,%r8,1),%ymm14
  9f6a32:	41 c1 e7 06          	shl    $0x6,%r15d
  9f6a36:	62 81 fd 28 6f 44 02 03 	vmovdqa64 0x60(%r10,%r8,1),%ymm16
  9f6a3e:	62 13 8d 48 3a 74 03 02 01 	vinserti64x4 $0x1,0x40(%r11,%r8,1),%zmm14,%zmm14
  9f6a47:	62 83 fd 40 3a 64 07 03 01 	vinserti64x4 $0x1,0x60(%r15,%r8,1),%zmm16,%zmm20
  9f6a50:	62 62 f5 48 83 e2    	vpmultishiftqb %zmm2,%zmm1,%zmm28
  9f6a56:	62 f1 75 48 72 f2 04 	vpslld $0x4,%zmm2,%zmm1
  9f6a5d:	62 63 15 50 25 25 b8 67 b8 ff e4 	vpternlogd $0xe4,-0x479848(%rip){1to16},%zmm29,%zmm28        # 57d220 <tier0_test_int128_integers+0x198>
  9f6a68:	62 f1 25 40 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm27
  9f6a6f:	62 f2 7d 48 5a 0d a7 fa b6 ff 	vbroadcasti32x4 -0x490559(%rip),%zmm1        # 566520 <check_binding_benchmark_headers+0x2240>
  9f6a79:	62 32 a5 49 64 ea    	vpblendmq %zmm18,%zmm11,%zmm13{%k1}
  9f6a7f:	62 a2 8d 49 64 c4    	vpblendmq %zmm20,%zmm14,%zmm16{%k1}
  9f6a85:	62 21 15 48 6a c8    	vpunpckhdq %zmm16,%zmm13,%zmm25
  9f6a8b:	62 01 bd 40 6d c9    	vpunpckhqdq %zmm25,%zmm24,%zmm25
  9f6a91:	62 62 0d 40 36 05 25 a1 aa ff 	vpermd -0x555edb(%rip),%zmm30,%zmm24        # 4a0bc0 <check_builtin_atomic_rmw_test_clang.native_source+0x36c0>
  9f6a9b:	62 62 75 48 00 ea    	vpshufb %zmm2,%zmm1,%zmm29
  9f6aa1:	62 f2 7d 48 58 0d 7d 67 b8 ff 	vpbroadcastd -0x479883(%rip),%zmm1        # 57d228 <tier0_test_int128_integers+0x1a0>
  9f6aab:	62 62 0d 40 36 35 4b a1 aa ff 	vpermd -0x555eb5(%rip),%zmm30,%zmm30        # 4a0c00 <check_builtin_atomic_rmw_test_clang.native_source+0x3700>
  9f6ab5:	62 91 7d 48 72 f5 10 	vpslld $0x10,%zmm29,%zmm0
  9f6abc:	62 01 25 40 db ed    	vpandd %zmm29,%zmm27,%zmm29
  9f6ac2:	62 f1 05 40 72 e0 1f 	vpsrad $0x1f,%zmm0,%zmm31
  9f6ac9:	62 b1 7d 48 72 e7 1f 	vpsrad $0x1f,%zmm23,%zmm0
  9f6ad0:	62 03 1d 40 25 c2 f8 	vpternlogd $0xf8,%zmm26,%zmm28,%zmm24
  9f6ad7:	62 62 7e 48 38 d0    	vpmovm2d %k0,%zmm26
  9f6add:	62 03 25 40 25 d7 c8 	vpternlogd $0xc8,%zmm31,%zmm27,%zmm26
  9f6ae4:	62 21 7d 48 ef ff    	vpxord %zmm23,%zmm0,%zmm31
  9f6aea:	62 f2 7d 48 58 05 30 67 b8 ff 	vpbroadcastd -0x4798d0(%rip),%zmm0        # 57d224 <tier0_test_int128_integers+0x19c>
  9f6af4:	62 63 0d 50 25 2d 6d 67 b8 ff ec 	vpternlogd $0xec,-0x479893(%rip){1to16},%zmm30,%zmm29        # 57d26c <tier0_test_int128_integers+0x1e4>
  9f6aff:	62 91 0d 40 72 d1 1d 	vpsrld $0x1d,%zmm25,%zmm30
  9f6b06:	62 02 7d 48 44 ff    	vplzcntd %zmm31,%zmm31
  9f6b0c:	62 63 35 50 25 2d 59 67 b8 ff f8 	vpternlogd $0xf8,-0x4798a7(%rip){1to16},%zmm25,%zmm29        # 57d270 <tier0_test_int128_integers+0x1e8>
  9f6b17:	62 02 75 48 45 ff    	vpsrlvd %zmm31,%zmm1,%zmm31
  9f6b1d:	62 d1 45 40 fe cc    	vpaddd %zmm12,%zmm23,%zmm1
  9f6b23:	62 93 45 40 25 cf 14 	vpternlogd $0x14,%zmm31,%zmm23,%zmm1
  9f6b2a:	62 f1 05 40 72 d2 08 	vpsrld $0x8,%zmm2,%zmm31
  9f6b31:	62 92 75 48 14 ce    	vprorvd %zmm30,%zmm1,%zmm1
  9f6b37:	62 f1 75 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm1
  9f6b3e:	62 e3 7d 58 25 1d eb 66 b8 ff 6c 	vpternlogd $0x6c,-0x479915(%rip){1to16},%zmm0,%zmm19        # 57d234 <tier0_test_int128_integers+0x1ac>
  9f6b49:	62 63 7d 58 25 3d e4 66 b8 ff 6c 	vpternlogd $0x6c,-0x47991c(%rip){1to16},%zmm0,%zmm31        # 57d238 <tier0_test_int128_integers+0x1b0>
  9f6b54:	62 f1 1d 50 db 05 ea 66 b8 ff 	vpandd -0x479916(%rip){1to16},%zmm28,%zmm0        # 57d248 <tier0_test_int128_integers+0x1c0>
  9f6b5e:	62 91 1d 40 72 d4 03 	vpsrld $0x3,%zmm28,%zmm28
  9f6b65:	62 63 35 50 25 25 e4 66 b8 ff a2 	vpternlogd $0xa2,-0x47991c(%rip){1to16},%zmm25,%zmm28        # 57d254 <tier0_test_int128_integers+0x1cc>
  9f6b70:	62 c1 65 40 fe dc    	vpaddd %zmm12,%zmm19,%zmm19
  9f6b76:	62 e3 35 58 25 1d bb 66 b8 ff ec 	vpternlogd $0xec,-0x479945(%rip){1to16},%zmm9,%zmm19        # 57d23c <tier0_test_int128_integers+0x1b4>
  9f6b81:	62 41 05 40 fe fc    	vpaddd %zmm12,%zmm31,%zmm31
  9f6b87:	62 63 65 50 25 3d b2 66 b8 ff ec 	vpternlogd $0xec,-0x47994e(%rip){1to16},%zmm19,%zmm31        # 57d244 <tier0_test_int128_integers+0x1bc>
  9f6b92:	62 93 35 40 25 c7 f8 	vpternlogd $0xf8,%zmm31,%zmm25,%zmm0
  9f6b99:	62 e2 7d 58 3b 1d a9 66 b8 ff 	vpminud -0x479957(%rip){1to16},%zmm0,%zmm19        # 57d24c <tier0_test_int128_integers+0x1c4>
  9f6ba3:	62 f2 1d 50 3b 05 ab 66 b8 ff 	vpminud -0x479955(%rip){1to16},%zmm28,%zmm0        # 57d258 <tier0_test_int128_integers+0x1d0>
  9f6bad:	62 01 fd 48 6f c8    	vmovdqa64 %zmm24,%zmm25
  9f6bb3:	62 63 2d 50 25 0d 6e 66 b8 ff f8 	vpternlogd $0xf8,-0x479992(%rip){1to16},%zmm26,%zmm25        # 57d22c <tier0_test_int128_integers+0x1a4>
  9f6bbe:	62 61 2d 50 db 3d ac 66 b8 ff 	vpandd -0x479954(%rip){1to16},%zmm26,%zmm31        # 57d274 <tier0_test_int128_integers+0x1ec>
  9f6bc8:	62 23 7d 48 25 eb fe 	vpternlogd $0xfe,%zmm19,%zmm0,%zmm29
  9f6bcf:	62 81 fd 48 6f d8    	vmovdqa64 %zmm24,%zmm19
  9f6bd5:	62 e3 25 50 25 1d 50 66 b8 ff f8 	vpternlogd $0xf8,-0x4799b0(%rip){1to16},%zmm27,%zmm19        # 57d230 <tier0_test_int128_integers+0x1a8>
  9f6be0:	62 b1 7d 48 72 cf 01 	vprold $0x1,%zmm23,%zmm0
  9f6be7:	62 61 25 50 db 1d 87 66 b8 ff 	vpandd -0x479979(%rip){1to16},%zmm27,%zmm27        # 57d278 <tier0_test_int128_integers+0x1f0>
  9f6bf1:	62 83 75 48 25 d9 b8 	vpternlogd $0xb8,%zmm25,%zmm1,%zmm19
  9f6bf8:	62 02 7d 48 14 ce    	vprorvd %zmm30,%zmm0,%zmm25
  9f6bfe:	62 f1 fd 48 6f 05 38 9f aa ff 	vmovdqa64 -0x5560c8(%rip),%zmm0        # 4a0b40 <check_builtin_atomic_rmw_test_clang.native_source+0x3640>
  9f6c08:	62 03 75 48 25 df b8 	vpternlogd $0xb8,%zmm31,%zmm1,%zmm27
  9f6c0f:	62 23 2d 40 25 cf e2 	vpternlogd $0xe2,%zmm23,%zmm26,%zmm25
  9f6c16:	62 23 75 48 25 cf e2 	vpternlogd $0xe2,%zmm23,%zmm1,%zmm25
  9f6c1d:	62 f1 cd 48 6c cf    	vpunpcklqdq %zmm7,%zmm6,%zmm1
  9f6c23:	62 d1 1d 40 fe fc    	vpaddd %zmm12,%zmm28,%zmm7
  9f6c29:	62 b1 d5 40 6d f6    	vpunpckhqdq %zmm22,%zmm21,%zmm6
  9f6c2f:	62 f1 45 48 72 e7 1f 	vpsrad $0x1f,%zmm7,%zmm7
  9f6c36:	62 f1 4d 48 eb d2    	vpord  %zmm2,%zmm6,%zmm2
  9f6c3c:	62 f1 6d 48 72 f2 07 	vpslld $0x7,%zmm2,%zmm2
  9f6c43:	62 d2 fd 48 7e e7    	vpermt2q %zmm15,%zmm0,%zmm4
  9f6c49:	62 32 fd 48 7e c1    	vpermt2q %zmm17,%zmm0,%zmm8
  9f6c4f:	62 32 fd 48 7e da    	vpermt2q %zmm18,%zmm0,%zmm11
  9f6c55:	62 32 fd 48 7e f4    	vpermt2q %zmm20,%zmm0,%zmm14
  9f6c5b:	62 91 7d 48 72 d0 10 	vpsrld $0x10,%zmm24,%zmm0
  9f6c62:	62 91 05 48 72 d0 03 	vpsrld $0x3,%zmm24,%zmm15
  9f6c69:	62 73 7d 58 25 3d dc 65 b8 ff ec 	vpternlogd $0xec,-0x479a24(%rip){1to16},%zmm0,%zmm15        # 57d250 <tier0_test_int128_integers+0x1c8>
  9f6c74:	62 f2 7d 48 5a 05 b2 f8 b6 ff 	vbroadcasti32x4 -0x49074e(%rip),%zmm0        # 566530 <check_binding_benchmark_headers+0x2250>
  9f6c7e:	62 d1 75 40 72 f7 08 	vpslld $0x8,%zmm15,%zmm17
  9f6c85:	62 e3 45 58 25 0d cc 65 b8 ff 08 	vpternlogd $0x8,-0x479a34(%rip){1to16},%zmm7,%zmm17        # 57d25c <tier0_test_int128_integers+0x1d4>
  9f6c90:	62 f2 fd 48 83 f6    	vpmultishiftqb %zmm6,%zmm0,%zmm6
  9f6c96:	62 f3 05 58 25 35 c3 65 b8 ff d8 	vpternlogd $0xd8,-0x479a3d(%rip){1to16},%zmm15,%zmm6        # 57d264 <tier0_test_int128_integers+0x1dc>
  9f6ca1:	62 91 75 48 62 f9    	vpunpckldq %zmm25,%zmm1,%zmm7
  9f6ca7:	62 91 75 48 6a c9    	vpunpckhdq %zmm25,%zmm1,%zmm1
  9f6cad:	62 f3 75 50 25 15 a8 65 b8 ff e4 	vpternlogd $0xe4,-0x479a58(%rip){1to16},%zmm17,%zmm2        # 57d260 <tier0_test_int128_integers+0x1d8>
  9f6cb8:	62 f3 6d 58 25 35 a5 65 b8 ff d8 	vpternlogd $0xd8,-0x479a5b(%rip){1to16},%zmm2,%zmm6        # 57d268 <tier0_test_int128_integers+0x1e0>
  9f6cc3:	62 91 25 40 eb d5    	vpord  %zmm29,%zmm27,%zmm2
  9f6cc9:	62 f1 7d 48 70 c2 00 	vpshufd $0x0,%zmm2,%zmm0
  9f6cd0:	62 f2 7d 48 8f dc    	vpshufbitqmb %zmm4,%zmm0,%k3
  9f6cd6:	c4 61 fb 93 cb       	kmovq  %k3,%r9
  9f6cdb:	f3 4d 0f b8 c9       	popcnt %r9,%r9
  9f6ce0:	62 71 65 40 62 fe    	vpunpckldq %zmm6,%zmm19,%zmm15
  9f6ce6:	62 f1 65 40 6a f6    	vpunpckhdq %zmm6,%zmm19,%zmm6
  9f6cec:	62 c1 c5 48 6c cf    	vpunpcklqdq %zmm15,%zmm7,%zmm17
  9f6cf2:	62 d1 c5 48 6d ff    	vpunpckhqdq %zmm15,%zmm7,%zmm7
  9f6cf8:	62 e1 f5 48 6c d6    	vpunpcklqdq %zmm6,%zmm1,%zmm18
  9f6cfe:	62 f1 f5 48 6d ce    	vpunpckhqdq %zmm6,%zmm1,%zmm1
  9f6d04:	62 f2 75 40 00 e4    	vpshufb %zmm4,%zmm17,%zmm4
  9f6d0a:	62 d2 45 48 00 c0    	vpshufb %zmm8,%zmm7,%zmm0
  9f6d10:	62 d2 75 48 00 ce    	vpshufb %zmm14,%zmm1,%zmm1
  9f6d16:	62 f3 d5 48 25 e3 78 	vpternlogq $0x78,%zmm3,%zmm5,%zmm4
  9f6d1d:	62 f1 7d 48 70 ea 55 	vpshufd $0x55,%zmm2,%zmm5
  9f6d24:	62 f3 ad 48 25 c3 78 	vpternlogq $0x78,%zmm3,%zmm10,%zmm0
  9f6d2b:	62 f3 fd 40 25 cb 78 	vpternlogq $0x78,%zmm3,%zmm16,%zmm1
  9f6d32:	62 f2 7d cb 63 e4    	vpcompressb %zmm4,%zmm4{%k3}{z}
  9f6d38:	62 d2 55 48 8f d0    	vpshufbitqmb %zmm8,%zmm5,%k2
  9f6d3e:	62 f1 7d 48 70 ea aa 	vpshufd $0xaa,%zmm2,%zmm5
  9f6d45:	62 f1 7d 48 70 d2 ff 	vpshufd $0xff,%zmm2,%zmm2
  9f6d4c:	62 d2 55 48 8f db    	vpshufbitqmb %zmm11,%zmm5,%k3
  9f6d52:	c4 61 fb 93 d2       	kmovq  %k2,%r10
  9f6d57:	c4 61 fb 93 db       	kmovq  %k3,%r11
  9f6d5c:	f3 4d 0f b8 d2       	popcnt %r10,%r10
  9f6d61:	62 d1 fe 48 7f 26    	vmovdqu64 %zmm4,(%r14)
  9f6d67:	c5 d9 ef e4          	vpxor  %xmm4,%xmm4,%xmm4
  9f6d6b:	62 f2 7d ca 63 c4    	vpcompressb %zmm0,%zmm4{%k2}{z}
  9f6d71:	62 d2 6d 40 00 c3    	vpshufb %zmm11,%zmm18,%zmm0
  9f6d77:	62 d2 6d 48 8f d6    	vpshufbitqmb %zmm14,%zmm2,%k2
  9f6d7d:	f3 4d 0f b8 fb       	popcnt %r11,%r15
  9f6d82:	62 f3 95 48 25 c3 78 	vpternlogq $0x78,%zmm3,%zmm13,%zmm0
  9f6d89:	62 f2 7d ca 63 c9    	vpcompressb %zmm1,%zmm1{%k2}{z}
  9f6d8f:	62 91 fe 48 7f 24 0e 	vmovdqu64 %zmm4,(%r14,%r9,1)
  9f6d96:	c5 d9 ef e4          	vpxor  %xmm4,%xmm4,%xmm4
  9f6d9a:	62 f2 7d cb 63 c4    	vpcompressb %zmm0,%zmm4{%k3}{z}
  9f6da0:	4d 01 f1             	add    %r14,%r9
  9f6da3:	c4 61 fb 93 f2       	kmovq  %k2,%r14
  9f6da8:	f3 4d 0f b8 f6       	popcnt %r14,%r14
  9f6dad:	4d 01 fe             	add    %r15,%r14
  9f6db0:	62 91 fe 48 7f 24 0a 	vmovdqu64 %zmm4,(%r10,%r9,1)
  9f6db7:	4d 01 d1             	add    %r10,%r9
  9f6dba:	4d 01 ce             	add    %r9,%r14
  9f6dbd:	48 ff c9             	dec    %rcx
  9f6dc0:	62 91 fe 48 7f 0c 0f 	vmovdqu64 %zmm1,(%r15,%r9,1)
  9f6dc7:	0f 85 a3 fa ff ff    	jne    9f6870 <x86_encode_16+0xd50>
  9f6dcd:	48 29 c2             	sub    %rax,%rdx
  9f6dd0:	0f 86 e6 05 00 00    	jbe    9f73bc <x86_encode_16+0x189c>
  9f6dd6:	48 c1 e0 04          	shl    $0x4,%rax
  9f6dda:	48 c1 e2 04          	shl    $0x4,%rdx
  9f6dde:	48 8d 7c 24 40       	lea    0x40(%rsp),%rdi
  9f6de3:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
  9f6de7:	62 f1 fd 48 7f 44 24 04 	vmovdqa64 %zmm0,0x100(%rsp)
  9f6def:	62 f1 fd 48 7f 44 24 03 	vmovdqa64 %zmm0,0xc0(%rsp)
  9f6df7:	62 f1 fd 48 7f 44 24 02 	vmovdqa64 %zmm0,0x80(%rsp)
  9f6dff:	62 f1 fd 48 7f 44 24 01 	vmovdqa64 %zmm0,0x40(%rsp)
  9f6e07:	48 01 c6             	add    %rax,%rsi
  9f6e0a:	c5 f8 77             	vzeroupper
  9f6e0d:	e8 3e d6 d6 ff       	call   764450 <memcpy@plt>
  9f6e12:	c5 f9 6f 64 24 70    	vmovdqa 0x70(%rsp),%xmm4
  9f6e18:	c5 f9 6f 4c 24 40    	vmovdqa 0x40(%rsp),%xmm1
  9f6e1e:	c5 f9 6f 54 24 50    	vmovdqa 0x50(%rsp),%xmm2
  9f6e24:	c5 f9 6f 5c 24 60    	vmovdqa 0x60(%rsp),%xmm3
  9f6e2a:	c5 f9 6f ac 24 80 00 00 00 	vmovdqa 0x80(%rsp),%xmm5
  9f6e33:	48 8d 05 06 07 71 07 	lea    0x7710706(%rip),%rax        # 8107540 <x86_template_storage>
  9f6e3a:	62 71 fd 48 6f 3d fc 9c aa ff 	vmovdqa64 -0x556304(%rip),%zmm15        # 4a0b40 <check_builtin_atomic_rmw_test_clang.native_source+0x3640>
  9f6e44:	c5 f9 6f bc 24 c0 00 00 00 	vmovdqa 0xc0(%rsp),%xmm7
  9f6e4d:	c5 f9 6f b4 24 d0 00 00 00 	vmovdqa 0xd0(%rsp),%xmm6
  9f6e56:	62 71 fd 48 6f 4c 24 01 	vmovdqa64 0x40(%rsp),%zmm9
  9f6e5e:	62 71 fd 48 6f 54 24 02 	vmovdqa64 0x80(%rsp),%zmm10
  9f6e66:	62 71 fd 48 6f 5c 24 03 	vmovdqa64 0xc0(%rsp),%zmm11
  9f6e6e:	62 71 fd 48 6f 64 24 04 	vmovdqa64 0x100(%rsp),%zmm12
  9f6e76:	62 e2 7d 48 5a 0d 90 f6 b6 ff 	vbroadcasti32x4 -0x490970(%rip),%zmm17        # 566510 <check_binding_benchmark_headers+0x2230>
  9f6e80:	62 a3 4d 40 25 f6 ff 	vpternlogd $0xff,%zmm22,%zmm22,%zmm22
  9f6e87:	62 e2 7d 48 58 2d 93 63 b8 ff 	vpbroadcastd -0x479c6d(%rip),%zmm21        # 57d224 <tier0_test_int128_integers+0x19c>
  9f6e91:	62 62 7d 48 58 15 95 63 b8 ff 	vpbroadcastd -0x479c6b(%rip),%zmm26        # 57d230 <tier0_test_int128_integers+0x1a8>
  9f6e9b:	62 62 7d 48 58 0d 8f 63 b8 ff 	vpbroadcastd -0x479c71(%rip),%zmm25        # 57d234 <tier0_test_int128_integers+0x1ac>
  9f6ea5:	c5 f9 c5 fc 06       	vpextrw $0x6,%xmm4,%edi
  9f6eaa:	c5 f9 6f a4 24 90 00 00 00 	vmovdqa 0x90(%rsp),%xmm4
  9f6eb3:	c5 f9 c5 c9 06       	vpextrw $0x6,%xmm1,%ecx
  9f6eb8:	c5 f9 c5 d2 06       	vpextrw $0x6,%xmm2,%edx
  9f6ebd:	c5 f9 c5 f3 06       	vpextrw $0x6,%xmm3,%esi
  9f6ec2:	62 51 35 48 62 ea    	vpunpckldq %zmm10,%zmm9,%zmm13
  9f6ec8:	62 51 25 48 62 f4    	vpunpckldq %zmm12,%zmm11,%zmm14
  9f6ece:	62 51 35 48 6a d2    	vpunpckhdq %zmm10,%zmm9,%zmm10
  9f6ed4:	62 51 25 48 6a dc    	vpunpckhdq %zmm12,%zmm11,%zmm11
  9f6eda:	c1 e1 06             	shl    $0x6,%ecx
  9f6edd:	c1 e2 06             	shl    $0x6,%edx
  9f6ee0:	c1 e6 06             	shl    $0x6,%esi
  9f6ee3:	c1 e7 06             	shl    $0x6,%edi
  9f6ee6:	62 51 ad 48 6c e3    	vpunpcklqdq %zmm11,%zmm10,%zmm12
  9f6eec:	62 51 95 48 6d ce    	vpunpckhqdq %zmm14,%zmm13,%zmm9
  9f6ef2:	62 d1 95 48 6c c6    	vpunpcklqdq %zmm14,%zmm13,%zmm0
  9f6ef8:	62 51 ad 48 6d eb    	vpunpckhqdq %zmm11,%zmm10,%zmm13
  9f6efe:	c5 fd 6f 4c 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm1
  9f6f04:	b1 cc                	mov    $0xcc,%cl
  9f6f06:	c5 fd 6f 54 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm2
  9f6f0c:	62 c2 f5 40 83 e4    	vpmultishiftqb %zmm12,%zmm17,%zmm20
  9f6f12:	62 d2 35 48 27 c1    	vptestmd %zmm9,%zmm9,%k0
  9f6f18:	62 d1 6d 40 72 e1 1f 	vpsrad $0x1f,%zmm9,%zmm18
  9f6f1f:	62 21 35 48 fe c6    	vpaddd %zmm22,%zmm9,%zmm24
  9f6f25:	62 43 55 40 25 cc 6c 	vpternlogd $0x6c,%zmm12,%zmm21,%zmm25
  9f6f2c:	c5 fb 92 c9          	kmovd  %ecx,%k1
  9f6f30:	c5 f9 c5 cd 06       	vpextrw $0x6,%xmm5,%ecx
  9f6f35:	c5 f9 6f ac 24 a0 00 00 00 	vmovdqa 0xa0(%rsp),%xmm5
  9f6f3e:	62 f3 f5 48 3a 4c 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm1,%zmm1
  9f6f47:	62 f3 ed 48 3a 5c 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm2,%zmm3
  9f6f50:	c1 e1 06             	shl    $0x6,%ecx
  9f6f53:	c5 f9 c5 d4 06       	vpextrw $0x6,%xmm4,%edx
  9f6f58:	c5 f9 6f a4 24 b0 00 00 00 	vmovdqa 0xb0(%rsp),%xmm4
  9f6f61:	c1 e2 06             	shl    $0x6,%edx
  9f6f64:	c5 f9 c5 f5 06       	vpextrw $0x6,%xmm5,%esi
  9f6f69:	62 f2 f5 49 64 d3    	vpblendmq %zmm3,%zmm1,%zmm2{%k1}
  9f6f6f:	62 f2 85 48 7e cb    	vpermt2q %zmm3,%zmm15,%zmm1
  9f6f75:	c5 fd 6f 5c 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm3
  9f6f7b:	c5 f9 c5 cf 06       	vpextrw $0x6,%xmm7,%ecx
  9f6f80:	c5 f9 6f bc 24 e0 00 00 00 	vmovdqa 0xe0(%rsp),%xmm7
  9f6f89:	c1 e6 06             	shl    $0x6,%esi
  9f6f8c:	c1 e1 06             	shl    $0x6,%ecx
  9f6f8f:	62 f3 e5 48 3a 5c 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm3,%zmm3
  9f6f98:	c5 f9 c5 fc 06       	vpextrw $0x6,%xmm4,%edi
  9f6f9d:	c5 fd 6f 64 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm4
  9f6fa3:	c5 f9 c5 d6 06       	vpextrw $0x6,%xmm6,%edx
  9f6fa8:	c5 f9 6f b4 24 f0 00 00 00 	vmovdqa 0xf0(%rsp),%xmm6
  9f6fb1:	c1 e7 06             	shl    $0x6,%edi
  9f6fb4:	c1 e2 06             	shl    $0x6,%edx
  9f6fb7:	62 f3 dd 48 3a 6c 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm4,%zmm5
  9f6fc0:	c5 f9 c5 f7 06       	vpextrw $0x6,%xmm7,%esi
  9f6fc5:	c1 e6 06             	shl    $0x6,%esi
  9f6fc8:	c5 f9 c5 fe 06       	vpextrw $0x6,%xmm6,%edi
  9f6fcd:	c5 fd 6f 74 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm6
  9f6fd3:	0f b7 94 24 1c 01 00 00 	movzwl 0x11c(%rsp),%edx
  9f6fdb:	c1 e7 06             	shl    $0x6,%edi
  9f6fde:	62 f2 e5 49 64 e5    	vpblendmq %zmm5,%zmm3,%zmm4{%k1}
  9f6fe4:	62 f2 85 48 7e dd    	vpermt2q %zmm5,%zmm15,%zmm3
  9f6fea:	c5 fd 6f 6c 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm5
  9f6ff0:	62 f3 cd 48 3a 7c 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm6,%zmm7
  9f6ff9:	0f b7 8c 24 0c 01 00 00 	movzwl 0x10c(%rsp),%ecx
  9f7001:	0f b7 bc 24 3c 01 00 00 	movzwl 0x13c(%rsp),%edi
  9f7009:	62 f3 d5 48 3a 6c 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm5,%zmm5
  9f7012:	0f b7 b4 24 2c 01 00 00 	movzwl 0x12c(%rsp),%esi
  9f701a:	62 71 6d 48 6a d4    	vpunpckhdq %zmm4,%zmm2,%zmm10
  9f7020:	c1 e2 06             	shl    $0x6,%edx
  9f7023:	c5 7d 6f 44 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm8
  9f7029:	c1 e1 06             	shl    $0x6,%ecx
  9f702c:	c1 e7 06             	shl    $0x6,%edi
  9f702f:	c1 e6 06             	shl    $0x6,%esi
  9f7032:	62 e3 bd 48 3a 44 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm8,%zmm16
  9f703b:	62 f2 d5 49 64 f7    	vpblendmq %zmm7,%zmm5,%zmm6{%k1}
  9f7041:	62 f2 85 48 7e ef    	vpermt2q %zmm7,%zmm15,%zmm5
  9f7047:	c5 fd 6f 7c 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm7
  9f704d:	62 f3 c5 48 3a 7c 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm7,%zmm7
  9f7056:	62 32 c5 49 64 c0    	vpblendmq %zmm16,%zmm7,%zmm8{%k1}
  9f705c:	62 b2 85 48 7e f8    	vpermt2q %zmm16,%zmm15,%zmm7
  9f7062:	62 e2 7d 48 5a 05 84 f4 b6 ff 	vbroadcasti32x4 -0x490b7c(%rip),%zmm16        # 5664f0 <check_binding_benchmark_headers+0x2210>
  9f706c:	62 51 4d 48 6a d8    	vpunpckhdq %zmm8,%zmm6,%zmm11
  9f7072:	62 51 ad 48 6d d3    	vpunpckhqdq %zmm11,%zmm10,%zmm10
  9f7078:	62 d1 25 48 72 d4 1a 	vpsrld $0x1a,%zmm12,%zmm11
  9f707f:	62 72 25 48 36 35 f7 9a aa ff 	vpermd -0x556509(%rip),%zmm11,%zmm14        # 4a0b80 <check_builtin_atomic_rmw_test_clang.native_source+0x3680>
  9f7089:	62 e2 25 48 36 1d 2d 9b aa ff 	vpermd -0x5564d3(%rip),%zmm11,%zmm19        # 4a0bc0 <check_builtin_atomic_rmw_test_clang.native_source+0x36c0>
  9f7093:	62 72 25 48 36 1d 63 9b aa ff 	vpermd -0x55649d(%rip),%zmm11,%zmm11        # 4a0c00 <check_builtin_atomic_rmw_test_clang.native_source+0x3700>
  9f709d:	62 d1 45 40 72 d2 1d 	vpsrld $0x1d,%zmm10,%zmm23
  9f70a4:	62 52 fd 40 83 fc    	vpmultishiftqb %zmm12,%zmm16,%zmm15
  9f70aa:	62 e2 7d 48 5a 05 4c f4 b6 ff 	vbroadcasti32x4 -0x490bb4(%rip),%zmm16        # 566500 <check_binding_benchmark_headers+0x2220>
  9f70b4:	62 c2 fd 40 83 c4    	vpmultishiftqb %zmm12,%zmm16,%zmm16
  9f70ba:	62 e3 05 58 25 05 57 61 b8 ff d8 	vpternlogd $0xd8,-0x479ea9(%rip){1to16},%zmm15,%zmm16        # 57d21c <tier0_test_int128_integers+0x194>
  9f70c5:	62 d1 05 48 72 f4 04 	vpslld $0x4,%zmm12,%zmm15
  9f70cc:	62 d1 05 48 72 e7 1f 	vpsrad $0x1f,%zmm15,%zmm15
  9f70d3:	62 e3 7d 50 25 25 42 61 b8 ff e4 	vpternlogd $0xe4,-0x479ebe(%rip){1to16},%zmm16,%zmm20        # 57d220 <tier0_test_int128_integers+0x198>
  9f70de:	62 e2 7d 48 5a 05 38 f4 b6 ff 	vbroadcasti32x4 -0x490bc8(%rip),%zmm16        # 566520 <check_binding_benchmark_headers+0x2240>
  9f70e8:	62 c2 7d 40 00 c4    	vpshufb %zmm12,%zmm16,%zmm16
  9f70ee:	62 c3 5d 40 25 de f8 	vpternlogd $0xf8,%zmm14,%zmm20,%zmm19
  9f70f5:	62 23 05 48 25 d3 ea 	vpternlogd $0xea,%zmm19,%zmm15,%zmm26
  9f70fc:	62 b1 0d 48 72 f0 10 	vpslld $0x10,%zmm16,%zmm14
  9f7103:	62 a1 05 48 db c0    	vpandd %zmm16,%zmm15,%zmm16
  9f7109:	62 e3 25 58 25 05 58 61 b8 ff ec 	vpternlogd $0xec,-0x479ea8(%rip){1to16},%zmm11,%zmm16        # 57d26c <tier0_test_int128_integers+0x1e4>
  9f7114:	62 71 05 58 db 1d 5a 61 b8 ff 	vpandd -0x479ea6(%rip){1to16},%zmm15,%zmm11        # 57d278 <tier0_test_int128_integers+0x1f0>
  9f711e:	62 d1 75 40 72 e6 1f 	vpsrad $0x1f,%zmm14,%zmm17
  9f7125:	62 72 7e 48 38 f0    	vpmovm2d %k0,%zmm14
  9f712b:	62 e3 2d 58 25 05 3a 61 b8 ff f8 	vpternlogd $0xf8,-0x479ec6(%rip){1to16},%zmm10,%zmm16        # 57d270 <tier0_test_int128_integers+0x1e8>
  9f7136:	62 33 05 48 25 f1 c8 	vpternlogd $0xc8,%zmm17,%zmm15,%zmm14
  9f713d:	62 c1 6d 40 ef c9    	vpxord %zmm9,%zmm18,%zmm17
  9f7143:	62 e2 7d 48 58 15 db 60 b8 ff 	vpbroadcastd -0x479f25(%rip),%zmm18        # 57d228 <tier0_test_int128_integers+0x1a0>
  9f714d:	62 72 7d 48 5a 3d 59 f3 b6 ff 	vbroadcasti32x4 -0x490ca7(%rip),%zmm15        # 5664b0 <check_binding_benchmark_headers+0x21d0>
  9f7157:	62 a2 7d 48 44 c9    	vplzcntd %zmm17,%zmm17
  9f715d:	62 a2 6d 40 45 c9    	vpsrlvd %zmm17,%zmm18,%zmm17
  9f7163:	62 23 35 48 25 c1 14 	vpternlogd $0x14,%zmm17,%zmm9,%zmm24
  9f716a:	62 a2 3d 40 14 cf    	vprorvd %zmm23,%zmm24,%zmm17
  9f7170:	62 62 7d 48 58 05 b2 60 b8 ff 	vpbroadcastd -0x479f4e(%rip),%zmm24        # 57d22c <tier0_test_int128_integers+0x1a4>
  9f717a:	62 b1 75 40 72 e1 1f 	vpsrad $0x1f,%zmm17,%zmm17
  9f7181:	62 23 0d 48 25 c3 ea 	vpternlogd $0xea,%zmm19,%zmm14,%zmm24
  9f7188:	62 03 75 40 25 d0 b8 	vpternlogd $0xb8,%zmm24,%zmm17,%zmm26
  9f718f:	62 21 35 40 fe c6    	vpaddd %zmm22,%zmm25,%zmm24
  9f7195:	62 d1 35 40 72 d4 08 	vpsrld $0x8,%zmm12,%zmm25
  9f719c:	62 63 55 50 25 0d 91 60 b8 ff 6c 	vpternlogd $0x6c,-0x479f6f(%rip){1to16},%zmm21,%zmm25        # 57d238 <tier0_test_int128_integers+0x1b0>
  9f71a7:	62 51 15 48 eb e4    	vpord  %zmm12,%zmm13,%zmm12
  9f71ad:	62 d1 1d 48 72 f4 07 	vpslld $0x7,%zmm12,%zmm12
  9f71b4:	62 a1 35 40 fe ee    	vpaddd %zmm22,%zmm25,%zmm21
  9f71ba:	62 62 7d 48 58 0d 78 60 b8 ff 	vpbroadcastd -0x479f88(%rip),%zmm25        # 57d23c <tier0_test_int128_integers+0x1b4>
  9f71c4:	62 63 3d 50 25 0d 71 60 b8 ff ea 	vpternlogd $0xea,-0x479f8f(%rip){1to16},%zmm24,%zmm25        # 57d240 <tier0_test_int128_integers+0x1b8>
  9f71cf:	62 61 5d 50 db 05 6f 60 b8 ff 	vpandd -0x479f91(%rip){1to16},%zmm20,%zmm24        # 57d248 <tier0_test_int128_integers+0x1c0>
  9f71d9:	62 b1 5d 40 72 d4 03 	vpsrld $0x3,%zmm20,%zmm20
  9f71e0:	62 e3 2d 58 25 25 69 60 b8 ff a2 	vpternlogd $0xa2,-0x479f97(%rip){1to16},%zmm10,%zmm20        # 57d254 <tier0_test_int128_integers+0x1cc>
  9f71eb:	62 63 55 50 25 0d 4e 60 b8 ff f8 	vpternlogd $0xf8,-0x479fb2(%rip){1to16},%zmm21,%zmm25        # 57d244 <tier0_test_int128_integers+0x1bc>
  9f71f6:	62 a1 5d 40 fe f6    	vpaddd %zmm22,%zmm20,%zmm22
  9f71fc:	62 e2 5d 50 3b 25 52 60 b8 ff 	vpminud -0x479fae(%rip){1to16},%zmm20,%zmm20        # 57d258 <tier0_test_int128_integers+0x1d0>
  9f7206:	62 03 2d 48 25 c1 f8 	vpternlogd $0xf8,%zmm25,%zmm10,%zmm24
  9f720d:	62 e2 3d 50 3b 2d 35 60 b8 ff 	vpminud -0x479fcb(%rip){1to16},%zmm24,%zmm21        # 57d24c <tier0_test_int128_integers+0x1c4>
  9f7217:	62 b1 3d 40 72 d3 10 	vpsrld $0x10,%zmm19,%zmm24
  9f721e:	62 b1 65 40 72 d3 03 	vpsrld $0x3,%zmm19,%zmm19
  9f7225:	62 b1 4d 40 72 e6 1f 	vpsrad $0x1f,%zmm22,%zmm22
  9f722c:	62 e3 3d 50 25 1d 19 60 b8 ff ec 	vpternlogd $0xec,-0x479fe7(%rip){1to16},%zmm24,%zmm19        # 57d250 <tier0_test_int128_integers+0x1c8>
  9f7237:	62 a3 5d 40 25 c5 fe 	vpternlogd $0xfe,%zmm21,%zmm20,%zmm16
  9f723e:	62 b1 3d 40 72 f3 08 	vpslld $0x8,%zmm19,%zmm24
  9f7245:	62 63 4d 50 25 05 0c 60 b8 ff 08 	vpternlogd $0x8,-0x479ff4(%rip){1to16},%zmm22,%zmm24        # 57d25c <tier0_test_int128_integers+0x1d4>
  9f7250:	62 e2 7d 48 5a 35 d6 f2 b6 ff 	vbroadcasti32x4 -0x490d2a(%rip),%zmm22        # 566530 <check_binding_benchmark_headers+0x2250>
  9f725a:	62 73 3d 50 25 25 fb 5f b8 ff e4 	vpternlogd $0xe4,-0x47a005(%rip){1to16},%zmm24,%zmm12        # 57d260 <tier0_test_int128_integers+0x1d8>
  9f7265:	62 c2 cd 40 83 f5    	vpmultishiftqb %zmm13,%zmm22,%zmm22
  9f726b:	62 71 0d 58 db 2d ff 5f b8 ff 	vpandd -0x47a001(%rip){1to16},%zmm14,%zmm13        # 57d274 <tier0_test_int128_integers+0x1ec>
  9f7275:	62 e3 65 50 25 35 e4 5f b8 ff d8 	vpternlogd $0xd8,-0x47a01c(%rip){1to16},%zmm19,%zmm22        # 57d264 <tier0_test_int128_integers+0x1dc>
  9f7280:	62 e3 1d 58 25 35 dd 5f b8 ff d8 	vpternlogd $0xd8,-0x47a023(%rip){1to16},%zmm12,%zmm22        # 57d268 <tier0_test_int128_integers+0x1e0>
  9f728b:	62 d1 1d 48 72 c9 01 	vprold $0x1,%zmm9,%zmm12
  9f7292:	62 53 75 40 25 dd b8 	vpternlogd $0xb8,%zmm13,%zmm17,%zmm11
  9f7299:	62 31 25 48 eb d0    	vpord  %zmm16,%zmm11,%zmm10
  9f729f:	62 32 1d 48 14 df    	vprorvd %zmm23,%zmm12,%zmm11
  9f72a5:	62 53 0d 48 25 d9 e2 	vpternlogd $0xe2,%zmm9,%zmm14,%zmm11
  9f72ac:	62 53 75 40 25 d9 e2 	vpternlogd $0xe2,%zmm9,%zmm17,%zmm11
  9f72b3:	62 51 7d 48 62 cb    	vpunpckldq %zmm11,%zmm0,%zmm9
  9f72b9:	62 d1 7d 48 6a c3    	vpunpckhdq %zmm11,%zmm0,%zmm0
  9f72bf:	62 31 2d 40 62 de    	vpunpckldq %zmm22,%zmm26,%zmm11
  9f72c5:	62 31 2d 40 6a e6    	vpunpckhdq %zmm22,%zmm26,%zmm12
  9f72cb:	62 51 b5 48 6c eb    	vpunpcklqdq %zmm11,%zmm9,%zmm13
  9f72d1:	62 51 b5 48 6d cb    	vpunpckhqdq %zmm11,%zmm9,%zmm9
  9f72d7:	62 51 fd 48 6c dc    	vpunpcklqdq %zmm12,%zmm0,%zmm11
  9f72dd:	62 d1 fd 48 6d c4    	vpunpckhqdq %zmm12,%zmm0,%zmm0
  9f72e3:	62 51 7d 48 70 e2 00 	vpshufd $0x0,%zmm10,%zmm12
  9f72ea:	62 72 15 48 00 e9    	vpshufb %zmm1,%zmm13,%zmm13
  9f72f0:	62 f2 1d 48 8f c9    	vpshufbitqmb %zmm1,%zmm12,%k1
  9f72f6:	62 51 7d 48 70 e2 55 	vpshufd $0x55,%zmm10,%zmm12
  9f72fd:	62 f2 7d 48 00 c7    	vpshufb %zmm7,%zmm0,%zmm0
  9f7303:	62 53 ed 48 25 ef 78 	vpternlogq $0x78,%zmm15,%zmm2,%zmm13
  9f730a:	62 f2 35 48 00 d3    	vpshufb %zmm3,%zmm9,%zmm2
  9f7310:	62 d3 bd 48 25 c7 78 	vpternlogq $0x78,%zmm15,%zmm8,%zmm0
  9f7317:	62 72 7d c9 63 e9    	vpcompressb %zmm13,%zmm1{%k1}{z}
  9f731d:	c4 e1 fb 93 c1       	kmovq  %k1,%rax
  9f7322:	62 f2 1d 48 8f cb    	vpshufbitqmb %zmm3,%zmm12,%k1
  9f7328:	62 d1 7d 48 70 da aa 	vpshufd $0xaa,%zmm10,%zmm3
  9f732f:	62 d3 dd 48 25 d7 78 	vpternlogq $0x78,%zmm15,%zmm4,%zmm2
  9f7336:	f3 48 0f b8 c0       	popcnt %rax,%rax
  9f733b:	49 8d 0c 06          	lea    (%r14,%rax,1),%rcx
  9f733f:	c4 e1 fb 93 d1       	kmovq  %k1,%rdx
  9f7344:	f3 48 0f b8 d2       	popcnt %rdx,%rdx
  9f7349:	62 d1 fe 48 7f 0e    	vmovdqu64 %zmm1,(%r14)
  9f734f:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
  9f7353:	62 f2 7d c9 63 d1    	vpcompressb %zmm2,%zmm1{%k1}{z}
  9f7359:	62 f2 25 48 00 d5    	vpshufb %zmm5,%zmm11,%zmm2
  9f735f:	62 f2 65 48 8f cd    	vpshufbitqmb %zmm5,%zmm3,%k1
  9f7365:	62 d3 cd 48 25 d7 78 	vpternlogq $0x78,%zmm15,%zmm6,%zmm2
  9f736c:	c4 e1 fb 93 f1       	kmovq  %k1,%rsi
  9f7371:	f3 48 0f b8 f6       	popcnt %rsi,%rsi
  9f7376:	62 d1 fe 48 7f 0c 06 	vmovdqu64 %zmm1,(%r14,%rax,1)
  9f737d:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
  9f7381:	62 f2 7d c9 63 d1    	vpcompressb %zmm2,%zmm1{%k1}{z}
  9f7387:	62 d1 7d 48 70 d2 ff 	vpshufd $0xff,%zmm10,%zmm2
  9f738e:	48 8d 04 11          	lea    (%rcx,%rdx,1),%rax
  9f7392:	62 f2 6d 48 8f cf    	vpshufbitqmb %zmm7,%zmm2,%k1
  9f7398:	62 f2 7d c9 63 c0    	vpcompressb %zmm0,%zmm0{%k1}{z}
  9f739e:	62 f1 fe 48 7f 0c 0a 	vmovdqu64 %zmm1,(%rdx,%rcx,1)
  9f73a5:	c4 e1 fb 93 c9       	kmovq  %k1,%rcx
  9f73aa:	f3 4c 0f b8 f1       	popcnt %rcx,%r14
  9f73af:	49 01 f6             	add    %rsi,%r14
  9f73b2:	49 01 c6             	add    %rax,%r14
  9f73b5:	62 f1 fe 48 7f 04 06 	vmovdqu64 %zmm0,(%rsi,%rax,1)
  9f73bc:	49 29 de             	sub    %rbx,%r14
  9f73bf:	64 48 8b 04 25 28 00 00 00 	mov    %fs:0x28,%rax
  9f73c8:	48 3b 84 24 48 01 00 00 	cmp    0x148(%rsp),%rax
  9f73d0:	75 13                	jne    9f73e5 <x86_encode_16+0x18c5>
  9f73d2:	4c 89 f0             	mov    %r14,%rax
  9f73d5:	48 8d 65 e0          	lea    -0x20(%rbp),%rsp
  9f73d9:	5b                   	pop    %rbx
  9f73da:	41 5c                	pop    %r12
  9f73dc:	41 5e                	pop    %r14
  9f73de:	41 5f                	pop    %r15
  9f73e0:	5d                   	pop    %rbp
  9f73e1:	c5 f8 77             	vzeroupper
  9f73e4:	c3                   	ret
  9f73e5:	c5 f8 77             	vzeroupper
  9f73e8:	e8 f3 c6 d6 ff       	call   763ae0 <__stack_chk_fail@plt>
