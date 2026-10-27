
build/compiler:     file format elf64-x86-64


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

0000000001882c20 <tier0_benchmark_run>:
 1882c20:	55                   	push   %rbp
 1882c21:	48 89 e5             	mov    %rsp,%rbp
 1882c24:	41 57                	push   %r15
 1882c26:	41 56                	push   %r14
 1882c28:	41 55                	push   %r13
 1882c2a:	41 54                	push   %r12
 1882c2c:	53                   	push   %rbx
 1882c2d:	48 83 e4 c0          	and    $0xffffffffffffffc0,%rsp
 1882c31:	48 81 ec 00 03 00 00 	sub    $0x300,%rsp
 1882c38:	44 89 4c 24 6c       	mov    %r9d,0x6c(%rsp)
 1882c3d:	4c 89 84 24 d0 00 00 00 	mov    %r8,0xd0(%rsp)
 1882c45:	48 89 bc 24 38 01 00 00 	mov    %rdi,0x138(%rsp)
 1882c4d:	49 89 cf             	mov    %rcx,%r15
 1882c50:	49 89 d5             	mov    %rdx,%r13
 1882c53:	41 89 f4             	mov    %esi,%r12d
 1882c56:	64 48 8b 04 25 28 00 00 00 	mov    %fs:0x28,%rax
 1882c5f:	48 89 84 24 c0 02 00 00 	mov    %rax,0x2c0(%rsp)
 1882c67:	83 fe 02             	cmp    $0x2,%esi
 1882c6a:	75 41                	jne    1882cad <tier0_benchmark_run+0x8d>
 1882c6c:	41 83 7d 30 00       	cmpl   $0x0,0x30(%r13)
 1882c71:	74 3a                	je     1882cad <tier0_benchmark_run+0x8d>
 1882c73:	31 db                	xor    %ebx,%ebx
 1882c75:	45 31 f6             	xor    %r14d,%r14d
 1882c78:	0f 1f 84 00 00 00 00 00 	nopl   0x0(%rax,%rax,1)
 1882c80:	49 8b 45 08          	mov    0x8(%r13),%rax
 1882c84:	49 8b 4d 10          	mov    0x10(%r13),%rcx
 1882c88:	8b 54 18 08          	mov    0x8(%rax,%rbx,1),%edx
 1882c8c:	4a 8b 3c f1          	mov    (%rcx,%r14,8),%rdi
 1882c90:	48 8b 34 18          	mov    (%rax,%rbx,1),%rsi
 1882c94:	48 c1 e2 04          	shl    $0x4,%rdx
 1882c98:	e8 b3 17 ee fe       	call   764450 <memcpy@plt>
 1882c9d:	41 8b 45 30          	mov    0x30(%r13),%eax
 1882ca1:	49 ff c6             	inc    %r14
 1882ca4:	48 83 c3 68          	add    $0x68,%rbx
 1882ca8:	49 39 c6             	cmp    %rax,%r14
 1882cab:	72 d3                	jb     1882c80 <tier0_benchmark_run+0x60>
 1882cad:	48 8b b4 24 d0 00 00 00 	mov    0xd0(%rsp),%rsi
 1882cb5:	8b 54 24 6c          	mov    0x6c(%rsp),%edx
 1882cb9:	48 8d bc 24 48 01 00 00 	lea    0x148(%rsp),%rdi
 1882cc1:	e8 7a e6 04 00       	call   18d1340 <tier0_benchmark_read>
 1882cc6:	41 8b 45 30          	mov    0x30(%r13),%eax
 1882cca:	85 c0                	test   %eax,%eax
 1882ccc:	0f 84 a0 00 00 00    	je     1882d72 <tier0_benchmark_run+0x152>
 1882cd2:	49 8b 5f 08          	mov    0x8(%r15),%rbx
 1882cd6:	44 89 64 24 3c       	mov    %r12d,0x3c(%rsp)
 1882cdb:	45 85 e4             	test   %r12d,%r12d
 1882cde:	74 4f                	je     1882d2f <tier0_benchmark_run+0x10f>
 1882ce0:	41 83 fc 01          	cmp    $0x1,%r12d
 1882ce4:	0f 85 fc 00 00 00    	jne    1882de6 <tier0_benchmark_run+0x1c6>
 1882cea:	4c 8d a4 24 c0 01 00 00 	lea    0x1c0(%rsp),%r12
 1882cf2:	45 31 f6             	xor    %r14d,%r14d
 1882cf5:	66 66 2e 0f 1f 84 00 00 00 00 00 	data16 cs nopw 0x0(%rax,%rax,1)
 1882d00:	49 8b 45 00          	mov    0x0(%r13),%rax
 1882d04:	4c 89 e7             	mov    %r12,%rdi
 1882d07:	4c 89 fa             	mov    %r15,%rdx
 1882d0a:	4a 8b 34 f0          	mov    (%rax,%r14,8),%rsi
 1882d0e:	e8 3d 18 01 00       	call   1894550 <tier0_compile_scalar>
 1882d13:	49 3b 5f 08          	cmp    0x8(%r15),%rbx
 1882d17:	0f 87 5a 1c 00 00    	ja     1884977 <tier0_benchmark_run+0x1d57>
 1882d1d:	49 89 5f 08          	mov    %rbx,0x8(%r15)
 1882d21:	49 ff c6             	inc    %r14
 1882d24:	41 8b 45 30          	mov    0x30(%r13),%eax
 1882d28:	49 39 c6             	cmp    %rax,%r14
 1882d2b:	72 d3                	jb     1882d00 <tier0_benchmark_run+0xe0>
 1882d2d:	eb 3e                	jmp    1882d6d <tier0_benchmark_run+0x14d>
 1882d2f:	4c 8d a4 24 c0 01 00 00 	lea    0x1c0(%rsp),%r12
 1882d37:	45 31 f6             	xor    %r14d,%r14d
 1882d3a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
 1882d40:	49 8b 45 00          	mov    0x0(%r13),%rax
 1882d44:	4c 89 e7             	mov    %r12,%rdi
 1882d47:	4c 89 fa             	mov    %r15,%rdx
 1882d4a:	4a 8b 34 f0          	mov    (%rax,%r14,8),%rsi
 1882d4e:	e8 1d 27 01 00       	call   1895470 <tier0_compile>
 1882d53:	49 3b 5f 08          	cmp    0x8(%r15),%rbx
 1882d57:	0f 87 1a 1c 00 00    	ja     1884977 <tier0_benchmark_run+0x1d57>
 1882d5d:	49 89 5f 08          	mov    %rbx,0x8(%r15)
 1882d61:	49 ff c6             	inc    %r14
 1882d64:	41 8b 45 30          	mov    0x30(%r13),%eax
 1882d68:	49 39 c6             	cmp    %rax,%r14
 1882d6b:	72 d3                	jb     1882d40 <tier0_benchmark_run+0x120>
 1882d6d:	44 8b 64 24 3c       	mov    0x3c(%rsp),%r12d
 1882d72:	45 31 ff             	xor    %r15d,%r15d
 1882d75:	48 8b b4 24 d0 00 00 00 	mov    0xd0(%rsp),%rsi
 1882d7d:	8b 54 24 6c          	mov    0x6c(%rsp),%edx
 1882d81:	48 8d bc 24 c0 01 00 00 	lea    0x1c0(%rsp),%rdi
 1882d89:	c5 f8 77             	vzeroupper
 1882d8c:	e8 af e5 04 00       	call   18d1340 <tier0_benchmark_read>
 1882d91:	c5 fe 6f 84 24 c0 01 00 00 	vmovdqu 0x1c0(%rsp),%ymm0
 1882d9a:	48 8b 84 24 38 01 00 00 	mov    0x138(%rsp),%rax
 1882da2:	c5 fd fb 84 24 48 01 00 00 	vpsubq 0x148(%rsp),%ymm0,%ymm0
 1882dab:	c5 fe 7f 00          	vmovdqu %ymm0,(%rax)
 1882daf:	41 83 fc 03          	cmp    $0x3,%r12d
 1882db3:	74 04                	je     1882db9 <tier0_benchmark_run+0x199>
 1882db5:	4d 8b 7d 50          	mov    0x50(%r13),%r15
 1882db9:	4d 89 7d 50          	mov    %r15,0x50(%r13)
 1882dbd:	64 48 8b 04 25 28 00 00 00 	mov    %fs:0x28,%rax
 1882dc6:	48 3b 84 24 c0 02 00 00 	cmp    0x2c0(%rsp),%rax
 1882dce:	0f 85 c5 1b 00 00    	jne    1884999 <tier0_benchmark_run+0x1d79>
 1882dd4:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
 1882dd8:	5b                   	pop    %rbx
 1882dd9:	41 5c                	pop    %r12
 1882ddb:	41 5d                	pop    %r13
 1882ddd:	41 5e                	pop    %r14
 1882ddf:	41 5f                	pop    %r15
 1882de1:	5d                   	pop    %rbp
 1882de2:	c5 f8 77             	vzeroupper
 1882de5:	c3                   	ret
 1882de6:	41 83 fc 02          	cmp    $0x2,%r12d
 1882dea:	0f 85 1e 1b 00 00    	jne    188490e <tier0_benchmark_run+0x1cee>
 1882df0:	62 f2 7d 48 58 35 da d6 cf fe 	vpbroadcastd -0x1302926(%rip),%zmm6        # 5804d4 <tier0_emit_x87.operations+0x8c>
 1882dfa:	62 f1 fd 48 6f 3d fc d9 c9 fe 	vmovdqa64 -0x1362604(%rip),%zmm7        # 520800 <branch_sizing_patterns+0xa70>
 1882e04:	62 e2 7d 48 5a 0d f2 2e cf fe 	vbroadcasti32x4 -0x130d10e(%rip),%zmm17        # 575d00 <x86_effects_unknown+0x2a0>
 1882e0e:	62 72 7d 48 5a 0d f8 2e cf fe 	vbroadcasti32x4 -0x130d108(%rip),%zmm9        # 575d10 <x86_effects_unknown+0x2b0>
 1882e18:	62 72 7d 48 58 15 0e d7 cf fe 	vpbroadcastd -0x13028f2(%rip),%zmm10        # 580530 <tier0_emit_x87.operations+0xe8>
 1882e22:	62 72 7d 48 58 1d 08 d7 cf fe 	vpbroadcastd -0x13028f8(%rip),%zmm11        # 580534 <tier0_emit_x87.operations+0xec>
 1882e2c:	48 b9 00 00 20 00 10 00 00 00 	movabs $0x1000200000,%rcx
 1882e36:	45 31 ff             	xor    %r15d,%r15d
 1882e39:	c4 41 39 ef c0       	vpxor  %xmm8,%xmm8,%xmm8
 1882e3e:	45 31 f6             	xor    %r14d,%r14d
 1882e41:	4c 89 ac 24 30 01 00 00 	mov    %r13,0x130(%rsp)
 1882e49:	48 81 c1 00 00 e0 ff 	add    $0xffffffffffe00000,%rcx
 1882e50:	48 89 8c 24 f0 00 00 00 	mov    %rcx,0xf0(%rsp)
 1882e58:	eb 45                	jmp    1882e9f <tier0_benchmark_run+0x27f>
 1882e5a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
 1882e60:	48 8b 84 24 40 01 00 00 	mov    0x140(%rsp),%rax
 1882e68:	64 48 3b 04 25 18 ff ff ff 	cmp    %fs:0xffffffffffffff18,%rax
 1882e71:	0f 87 00 1b 00 00    	ja     1884977 <tier0_benchmark_run+0x1d57>
 1882e77:	4c 8b ac 24 30 01 00 00 	mov    0x130(%rsp),%r13
 1882e7f:	64 48 89 04 25 18 ff ff ff 	mov    %rax,%fs:0xffffffffffffff18
 1882e88:	44 8b 64 24 3c       	mov    0x3c(%rsp),%r12d
 1882e8d:	41 8b 45 30          	mov    0x30(%r13),%eax
 1882e91:	49 ff c6             	inc    %r14
 1882e94:	89 c1                	mov    %eax,%ecx
 1882e96:	49 39 ce             	cmp    %rcx,%r14
 1882e99:	0f 83 d6 fe ff ff    	jae    1882d75 <tier0_benchmark_run+0x155>
 1882e9f:	49 8b 55 08          	mov    0x8(%r13),%rdx
 1882ea3:	49 6b ce 68          	imul   $0x68,%r14,%rcx
 1882ea7:	44 8b 4c 0a 08       	mov    0x8(%rdx,%rcx,1),%r9d
 1882eac:	49 81 f9 11 11 11 11 	cmp    $0x11111111,%r9
 1882eb3:	77 dc                	ja     1882e91 <tier0_benchmark_run+0x271>
 1882eb5:	49 8b 45 10          	mov    0x10(%r13),%rax
 1882eb9:	4c 8b 54 0a 10       	mov    0x10(%rdx,%rcx,1),%r10
 1882ebe:	4c 8b 44 0a 18       	mov    0x18(%rdx,%rcx,1),%r8
 1882ec3:	8b 7c 0a 20          	mov    0x20(%rdx,%rcx,1),%edi
 1882ec7:	49 8b 4d 18          	mov    0x18(%r13),%rcx
 1882ecb:	64 4c 8b 2c 25 10 ff ff ff 	mov    %fs:0xffffffffffffff10,%r13
 1882ed4:	4a 8b 34 f0          	mov    (%rax,%r14,8),%rsi
 1882ed8:	4a 8b 04 f1          	mov    (%rcx,%r14,8),%rax
 1882edc:	4c 89 54 24 28       	mov    %r10,0x28(%rsp)
 1882ee1:	48 89 7c 24 30       	mov    %rdi,0x30(%rsp)
 1882ee6:	4c 89 84 24 a8 00 00 00 	mov    %r8,0xa8(%rsp)
 1882eee:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
 1882ef3:	4d 85 ed             	test   %r13,%r13
 1882ef6:	74 0e                	je     1882f06 <tier0_benchmark_run+0x2e6>
 1882ef8:	64 48 8b 0c 25 18 ff ff ff 	mov    %fs:0xffffffffffffff18,%rcx
 1882f01:	e9 16 01 00 00       	jmp    188301c <tier0_benchmark_run+0x3fc>
 1882f06:	48 bb 00 00 20 00 10 00 00 00 	movabs $0x1000200000,%rbx
 1882f10:	ba 03 00 00 00       	mov    $0x3,%edx
 1882f15:	b9 22 40 00 00       	mov    $0x4022,%ecx
 1882f1a:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
 1882f20:	4c 89 4c 24 18       	mov    %r9,0x18(%rsp)
 1882f25:	48 89 74 24 50       	mov    %rsi,0x50(%rsp)
 1882f2a:	4c 89 74 24 48       	mov    %r14,0x48(%rsp)
 1882f2f:	31 ff                	xor    %edi,%edi
 1882f31:	45 31 c9             	xor    %r9d,%r9d
 1882f34:	48 89 de             	mov    %rbx,%rsi
 1882f37:	c5 f8 77             	vzeroupper
 1882f3a:	e8 01 16 ee fe       	call   764540 <mmap@plt>
 1882f3f:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
 1882f43:	74 50                	je     1882f95 <tier0_benchmark_run+0x375>
 1882f45:	4c 8d a8 ff ff 20 00 	lea    0x20ffff(%rax),%r13
 1882f4c:	ba 0f 00 00 00       	mov    $0xf,%edx
 1882f51:	48 89 c7             	mov    %rax,%rdi
 1882f54:	49 81 e5 00 00 e0 ff 	and    $0xffffffffffe00000,%r13
 1882f5b:	4d 89 ec             	mov    %r13,%r12
 1882f5e:	49 29 c4             	sub    %rax,%r12
 1882f61:	4c 89 e6             	mov    %r12,%rsi
 1882f64:	4d 8d b4 24 00 00 ff ff 	lea    -0x10000(%r12),%r14
 1882f6c:	e8 7f 15 ee fe       	call   7644f0 <madvise@plt>
 1882f71:	4c 29 e3             	sub    %r12,%rbx
 1882f74:	ba 0e 00 00 00       	mov    $0xe,%edx
 1882f79:	4c 89 ef             	mov    %r13,%rdi
 1882f7c:	48 89 de             	mov    %rbx,%rsi
 1882f7f:	e8 6c 15 ee fe       	call   7644f0 <madvise@plt>
 1882f84:	48 8b 84 24 f0 00 00 00 	mov    0xf0(%rsp),%rax
 1882f8c:	49 81 c5 00 00 ff ff 	add    $0xffffffffffff0000,%r13
 1882f93:	eb 08                	jmp    1882f9d <tier0_benchmark_run+0x37d>
 1882f95:	45 31 ed             	xor    %r13d,%r13d
 1882f98:	31 c0                	xor    %eax,%eax
 1882f9a:	45 31 f6             	xor    %r14d,%r14d
 1882f9d:	62 f2 7d 48 58 35 2d d5 cf fe 	vpbroadcastd -0x1302ad3(%rip),%zmm6        # 5804d4 <tier0_emit_x87.operations+0x8c>
 1882fa7:	62 f1 fd 48 6f 3d 4f d8 c9 fe 	vmovdqa64 -0x13627b1(%rip),%zmm7        # 520800 <branch_sizing_patterns+0xa70>
 1882fb1:	62 e2 7d 48 5a 0d 45 2d cf fe 	vbroadcasti32x4 -0x130d2bb(%rip),%zmm17        # 575d00 <x86_effects_unknown+0x2a0>
 1882fbb:	62 72 7d 48 5a 0d 4b 2d cf fe 	vbroadcasti32x4 -0x130d2b5(%rip),%zmm9        # 575d10 <x86_effects_unknown+0x2b0>
 1882fc5:	62 72 7d 48 58 15 61 d5 cf fe 	vpbroadcastd -0x1302a9f(%rip),%zmm10        # 580530 <tier0_emit_x87.operations+0xe8>
 1882fcf:	62 72 7d 48 58 1d 5b d5 cf fe 	vpbroadcastd -0x1302aa5(%rip),%zmm11        # 580534 <tier0_emit_x87.operations+0xec>
 1882fd9:	64 4c 89 2c 25 10 ff ff ff 	mov    %r13,%fs:0xffffffffffffff10
 1882fe2:	64 48 c7 04 25 18 ff ff ff 00 00 00 00 	movq   $0x0,%fs:0xffffffffffffff18
 1882fef:	64 48 89 04 25 20 ff ff ff 	mov    %rax,%fs:0xffffffffffffff20
 1882ff8:	64 4c 89 34 25 28 ff ff ff 	mov    %r14,%fs:0xffffffffffffff28
 1883001:	4c 8b 74 24 48       	mov    0x48(%rsp),%r14
 1883006:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
 188300b:	48 8b 7c 24 30       	mov    0x30(%rsp),%rdi
 1883010:	4c 8b 4c 24 18       	mov    0x18(%rsp),%r9
 1883015:	31 c9                	xor    %ecx,%ecx
 1883017:	c4 41 39 ef c0       	vpxor  %xmm8,%xmm8,%xmm8
 188301c:	4e 8d 44 29 3f       	lea    0x3f(%rcx,%r13,1),%r8
 1883021:	4a 8d 04 29          	lea    (%rcx,%r13,1),%rax
 1883025:	48 89 8c 24 40 01 00 00 	mov    %rcx,0x140(%rsp)
 188302d:	49 83 e0 c0          	and    $0xffffffffffffffc0,%r8
 1883031:	49 39 c0             	cmp    %rax,%r8
 1883034:	0f 82 26 fe ff ff    	jb     1882e60 <tier0_benchmark_run+0x240>
 188303a:	64 48 8b 0c 25 20 ff ff ff 	mov    %fs:0xffffffffffffff20,%rcx
 1883043:	4c 89 c0             	mov    %r8,%rax
 1883046:	4c 29 e8             	sub    %r13,%rax
 1883049:	48 29 c1             	sub    %rax,%rcx
 188304c:	0f 82 0e fe ff ff    	jb     1882e60 <tier0_benchmark_run+0x240>
 1883052:	44 89 ca             	mov    %r9d,%edx
 1883055:	c1 ea 06             	shr    $0x6,%edx
 1883058:	4c 8d 24 bd 7c 00 00 00 	lea    0x7c(,%rdi,4),%r12
 1883060:	4c 8d 1c bd bc 00 00 00 	lea    0xbc(,%rdi,4),%r11
 1883068:	4c 89 4c 24 18       	mov    %r9,0x18(%rsp)
 188306d:	48 8d 5a 01          	lea    0x1(%rdx),%rbx
 1883071:	48 89 54 24 20       	mov    %rdx,0x20(%rsp)
 1883076:	48 ba c0 ff ff ff 07 00 00 00 	movabs $0x7ffffffc0,%rdx
 1883080:	4c 8b 4c 24 18       	mov    0x18(%rsp),%r9
 1883085:	49 21 d4             	and    %rdx,%r12
 1883088:	49 21 d3             	and    %rdx,%r11
 188308b:	89 fa                	mov    %edi,%edx
 188308d:	c1 ea 03             	shr    $0x3,%edx
 1883090:	49 89 dd             	mov    %rbx,%r13
 1883093:	48 89 9c 24 c8 00 00 00 	mov    %rbx,0xc8(%rsp)
 188309b:	c1 e3 04             	shl    $0x4,%ebx
 188309e:	49 c1 e5 06          	shl    $0x6,%r13
 18830a2:	83 c2 48             	add    $0x48,%edx
 18830a5:	83 c3 30             	add    $0x30,%ebx
 18830a8:	4c 89 64 24 70       	mov    %r12,0x70(%rsp)
 18830ad:	4f 8d 24 a4          	lea    (%r12,%r12,4),%r12
 18830b1:	4c 89 6c 24 78       	mov    %r13,0x78(%rsp)
 18830b6:	4c 89 9c 24 88 00 00 00 	mov    %r11,0x88(%rsp)
 18830be:	83 e2 c0             	and    $0xffffffc0,%edx
 18830c1:	81 e3 c0 ff ff 1f    	and    $0x1fffffc0,%ebx
 18830c7:	4c 01 ea             	add    %r13,%rdx
 18830ca:	48 89 5c 24 40       	mov    %rbx,0x40(%rsp)
 18830cf:	4c 89 a4 24 80 00 00 00 	mov    %r12,0x80(%rsp)
 18830d7:	48 01 da             	add    %rbx,%rdx
 18830da:	4c 01 e2             	add    %r12,%rdx
 18830dd:	4a 8d 14 5a          	lea    (%rdx,%r11,2),%rdx
 18830e1:	48 39 ca             	cmp    %rcx,%rdx
 18830e4:	0f 87 76 fd ff ff    	ja     1882e60 <tier0_benchmark_run+0x240>
 18830ea:	48 01 d0             	add    %rdx,%rax
 18830ed:	48 c7 84 24 b8 01 00 00 00 00 00 00 	movq   $0x0,0x1b8(%rsp)
 18830f9:	64 48 89 04 25 18 ff ff ff 	mov    %rax,%fs:0xffffffffffffff18
 1883102:	4d 85 c0             	test   %r8,%r8
 1883105:	0f 95 84 24 b8 01 00 00 	setne  0x1b8(%rsp)
 188310d:	0f 84 4d fd ff ff    	je     1882e60 <tier0_benchmark_run+0x240>
 1883113:	4c 8b 64 24 78       	mov    0x78(%rsp),%r12
 1883118:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
 188311d:	48 8b 5c 24 70       	mov    0x70(%rsp),%rbx
 1883122:	4c 89 84 24 68 01 00 00 	mov    %r8,0x168(%rsp)
 188312a:	4c 8b 9c 24 88 00 00 00 	mov    0x88(%rsp),%r11
 1883132:	4c 89 74 24 48       	mov    %r14,0x48(%rsp)
 1883137:	48 89 74 24 50       	mov    %rsi,0x50(%rsp)
 188313c:	4d 01 c4             	add    %r8,%r12
 188313f:	4b 8d 04 1b          	lea    (%r11,%r11,1),%rax
 1883143:	49 8d 14 0c          	lea    (%r12,%rcx,1),%rdx
 1883147:	4c 89 a4 24 70 01 00 00 	mov    %r12,0x170(%rsp)
 188314f:	4c 89 64 24 78       	mov    %r12,0x78(%rsp)
 1883154:	48 8d 0c 1a          	lea    (%rdx,%rbx,1),%rcx
 1883158:	48 89 94 24 78 01 00 00 	mov    %rdx,0x178(%rsp)
 1883160:	4c 8d 14 5a          	lea    (%rdx,%rbx,2),%r10
 1883164:	48 89 54 24 60       	mov    %rdx,0x60(%rsp)
 1883169:	48 89 8c 24 80 01 00 00 	mov    %rcx,0x180(%rsp)
 1883171:	48 89 8c 24 e8 00 00 00 	mov    %rcx,0xe8(%rsp)
 1883179:	48 8d 0c 5b          	lea    (%rbx,%rbx,2),%rcx
 188317d:	48 8d 1c 9a          	lea    (%rdx,%rbx,4),%rbx
 1883181:	4c 89 94 24 88 01 00 00 	mov    %r10,0x188(%rsp)
 1883189:	4c 8d 24 0a          	lea    (%rdx,%rcx,1),%r12
 188318d:	48 89 8c 24 b8 00 00 00 	mov    %rcx,0xb8(%rsp)
 1883195:	48 8b 8c 24 80 00 00 00 	mov    0x80(%rsp),%rcx
 188319d:	48 89 9c 24 e0 00 00 00 	mov    %rbx,0xe0(%rsp)
 18831a5:	4c 89 a4 24 90 01 00 00 	mov    %r12,0x190(%rsp)
 18831ad:	48 89 9c 24 98 01 00 00 	mov    %rbx,0x198(%rsp)
 18831b5:	48 01 d1             	add    %rdx,%rcx
 18831b8:	4a 8d 14 19          	lea    (%rcx,%r11,1),%rdx
 18831bc:	48 01 c8             	add    %rcx,%rax
 18831bf:	48 89 8c 24 a0 01 00 00 	mov    %rcx,0x1a0(%rsp)
 18831c7:	48 89 8c 24 a0 00 00 00 	mov    %rcx,0xa0(%rsp)
 18831cf:	48 89 94 24 a8 01 00 00 	mov    %rdx,0x1a8(%rsp)
 18831d7:	48 89 94 24 c0 00 00 00 	mov    %rdx,0xc0(%rsp)
 18831df:	48 89 84 24 b0 01 00 00 	mov    %rax,0x1b0(%rsp)
 18831e7:	41 83 f9 10          	cmp    $0x10,%r9d
 18831eb:	73 10                	jae    18831fd <tier0_benchmark_run+0x5dd>
 18831ed:	4c 8b 74 24 58       	mov    0x58(%rsp),%r14
 18831f2:	45 31 ed             	xor    %r13d,%r13d
 18831f5:	45 31 ff             	xor    %r15d,%r15d
 18831f8:	e9 11 03 00 00       	jmp    188350e <tier0_benchmark_run+0x8ee>
 18831fd:	62 e2 7d 48 58 25 d9 d2 cf fe 	vpbroadcastd -0x1302d27(%rip),%zmm20        # 5804e0 <tier0_emit_x87.operations+0x98>
 1883207:	62 e2 7d 48 58 2d d3 d2 cf fe 	vpbroadcastd -0x1302d2d(%rip),%zmm21        # 5804e4 <tier0_emit_x87.operations+0x9c>
 1883211:	62 e2 7d 48 58 35 cd d2 cf fe 	vpbroadcastd -0x1302d33(%rip),%zmm22        # 5804e8 <tier0_emit_x87.operations+0xa0>
 188321b:	62 e2 7d 48 58 3d c7 d2 cf fe 	vpbroadcastd -0x1302d39(%rip),%zmm23        # 5804ec <tier0_emit_x87.operations+0xa4>
 1883225:	62 62 7d 48 58 05 c1 d2 cf fe 	vpbroadcastd -0x1302d3f(%rip),%zmm24        # 5804f0 <tier0_emit_x87.operations+0xa8>
 188322f:	62 62 7d 48 58 0d bb d2 cf fe 	vpbroadcastd -0x1302d45(%rip),%zmm25        # 5804f4 <tier0_emit_x87.operations+0xac>
 1883239:	62 62 7d 48 58 15 b5 d2 cf fe 	vpbroadcastd -0x1302d4b(%rip),%zmm26        # 5804f8 <tier0_emit_x87.operations+0xb0>
 1883243:	62 62 7d 48 58 1d af d2 cf fe 	vpbroadcastd -0x1302d51(%rip),%zmm27        # 5804fc <tier0_emit_x87.operations+0xb4>
 188324d:	62 62 7d 48 58 25 a9 d2 cf fe 	vpbroadcastd -0x1302d57(%rip),%zmm28        # 580500 <tier0_emit_x87.operations+0xb8>
 1883257:	62 62 7d 48 58 2d a3 d2 cf fe 	vpbroadcastd -0x1302d5d(%rip),%zmm29        # 580504 <tier0_emit_x87.operations+0xbc>
 1883261:	62 62 7d 48 58 35 9d d2 cf fe 	vpbroadcastd -0x1302d63(%rip),%zmm30        # 580508 <tier0_emit_x87.operations+0xc0>
 188326b:	62 62 7d 48 58 3d 97 d2 cf fe 	vpbroadcastd -0x1302d69(%rip),%zmm31        # 58050c <tier0_emit_x87.operations+0xc4>
 1883275:	62 72 7d 48 58 2d 91 d2 cf fe 	vpbroadcastd -0x1302d6f(%rip),%zmm13        # 580510 <tier0_emit_x87.operations+0xc8>
 188327f:	62 72 7d 48 58 3d 4f d2 cf fe 	vpbroadcastd -0x1302db1(%rip),%zmm15        # 5804d8 <tier0_emit_x87.operations+0x90>
 1883289:	62 72 7d 48 5a 25 8d 2a cf fe 	vbroadcasti32x4 -0x130d573(%rip),%zmm12        # 575d20 <x86_effects_unknown+0x2c0>
 1883293:	62 e2 7d 48 58 15 33 d2 cf fe 	vpbroadcastd -0x1302dcd(%rip),%zmm18        # 5804d0 <tier0_emit_x87.operations+0x88>
 188329d:	4c 8b 74 24 58       	mov    0x58(%rsp),%r14
 18832a2:	48 8d 86 c0 00 00 00 	lea    0xc0(%rsi),%rax
 18832a9:	62 a3 7d 40 25 c0 ff 	vpternlogd $0xff,%zmm16,%zmm16,%zmm16
 18832b0:	4c 8d 1d c9 c7 da 0c 	lea    0xcdac7c9(%rip),%r11        # e62fa80 <x86_template_storage>
 18832b7:	31 c9                	xor    %ecx,%ecx
 18832b9:	45 31 ed             	xor    %r13d,%r13d
 18832bc:	0f 1f 40 00          	nopl   0x0(%rax)
 18832c0:	62 f1 fe 48 6f 40 fd 	vmovdqu64 -0xc0(%rax),%zmm0
 18832c7:	62 f1 fe 48 6f 50 fe 	vmovdqu64 -0x80(%rax),%zmm2
 18832ce:	62 f1 fe 48 6f 58 ff 	vmovdqu64 -0x40(%rax),%zmm3
 18832d5:	62 f1 fe 48 6f 20    	vmovdqu64 (%rax),%zmm4
 18832db:	62 e2 7d 48 5a 1d 4b 2a cf fe 	vbroadcasti32x4 -0x130d5b5(%rip),%zmm19        # 575d30 <x86_effects_unknown+0x2d0>
 18832e5:	62 71 fd 48 6f f6    	vmovdqa64 %zmm6,%zmm14
 18832eb:	c5 fc 46 c8          	kxnorw %k0,%k0,%k1
 18832ef:	44 89 ea             	mov    %r13d,%edx
 18832f2:	4c 8d 79 10          	lea    0x10(%rcx),%r15
 18832f6:	48 05 00 01 00 00    	add    $0x100,%rax
 18832fc:	62 f1 7d 48 62 ca    	vpunpckldq %zmm2,%zmm0,%zmm1
 1883302:	62 f1 65 48 62 ec    	vpunpckldq %zmm4,%zmm3,%zmm5
 1883308:	62 f1 7d 48 6a c2    	vpunpckhdq %zmm2,%zmm0,%zmm0
 188330e:	62 f1 65 48 6a e4    	vpunpckhdq %zmm4,%zmm3,%zmm4
 1883314:	62 f1 fd 48 6c dc    	vpunpcklqdq %zmm4,%zmm0,%zmm3
 188331a:	62 f1 fd 48 6d c4    	vpunpckhqdq %zmm4,%zmm0,%zmm0
 1883320:	62 f1 f5 48 6d cd    	vpunpckhqdq %zmm5,%zmm1,%zmm1
 1883326:	62 f1 7d 48 72 f0 04 	vpslld $0x4,%zmm0,%zmm0
 188332d:	62 f2 f5 40 83 e3    	vpmultishiftqb %zmm3,%zmm17,%zmm4
 1883333:	62 f2 9d 48 83 eb    	vpmultishiftqb %zmm3,%zmm12,%zmm5
 1883339:	62 f2 75 48 27 c1    	vptestmd %zmm1,%zmm1,%k0
 188333f:	62 f1 7d 48 db d6    	vpandd %zmm6,%zmm0,%zmm2
 1883345:	62 f2 b5 48 83 f3    	vpmultishiftqb %zmm3,%zmm9,%zmm6
 188334b:	62 d3 5d 48 25 ef d8 	vpternlogd $0xd8,%zmm15,%zmm4,%zmm5
 1883352:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 1883356:	62 f1 5d 48 72 f3 04 	vpslld $0x4,%zmm3,%zmm4
 188335d:	62 f3 4d 58 25 2d 74 d1 cf fe d8 	vpternlogd $0xd8,-0x1302e8c(%rip){1to16},%zmm6,%zmm5        # 5804dc <tier0_emit_x87.operations+0x94>
 1883368:	62 d2 7d 49 90 44 93 13 	vpgatherdd 0x4c(%r11,%zmm2,4),%zmm0{%k1}
 1883370:	62 f1 6d 48 72 d3 1a 	vpsrld $0x1a,%zmm3,%zmm2
 1883377:	62 f2 65 40 00 f3    	vpshufb %zmm3,%zmm19,%zmm6
 188337d:	62 e1 fd 48 6f df    	vmovdqa64 %zmm7,%zmm19
 1883383:	62 f1 5d 48 72 e4 1f 	vpsrad $0x1f,%zmm4,%zmm4
 188338a:	62 f2 6d 48 36 d7    	vpermd %zmm7,%zmm2,%zmm2
 1883390:	62 f1 45 48 72 d3 08 	vpsrld $0x8,%zmm3,%zmm7
 1883397:	62 b3 6d 40 25 dd 6c 	vpternlogd $0x6c,%zmm21,%zmm18,%zmm3
 188339e:	62 b1 65 48 fe d8    	vpaddd %zmm16,%zmm3,%zmm3
 18833a4:	62 b3 6d 40 25 fe 6c 	vpternlogd $0x6c,%zmm22,%zmm18,%zmm7
 18833ab:	62 b1 45 48 fe f8    	vpaddd %zmm16,%zmm7,%zmm7
 18833b1:	62 93 45 40 25 d8 ea 	vpternlogd $0xea,%zmm24,%zmm23,%zmm3
 18833b8:	62 93 45 48 25 d9 f8 	vpternlogd $0xf8,%zmm25,%zmm7,%zmm3
 18833bf:	62 91 55 48 db fa    	vpandd %zmm26,%zmm5,%zmm7
 18833c5:	62 f1 55 48 72 d5 03 	vpsrld $0x3,%zmm5,%zmm5
 18833cc:	62 f3 7d 48 25 fb f8 	vpternlogd $0xf8,%zmm3,%zmm0,%zmm7
 18833d3:	62 93 7d 48 25 ec a2 	vpternlogd $0xa2,%zmm28,%zmm0,%zmm5
 18833da:	62 92 45 48 3b db    	vpminud %zmm27,%zmm7,%zmm3
 18833e0:	62 f1 5d 48 db fe    	vpandd %zmm6,%zmm4,%zmm7
 18833e6:	62 93 6d 48 25 fe ec 	vpternlogd $0xec,%zmm30,%zmm2,%zmm7
 18833ed:	62 92 55 48 3b d5    	vpminud %zmm29,%zmm5,%zmm2
 18833f3:	62 93 7d 48 25 ff f8 	vpternlogd $0xf8,%zmm31,%zmm0,%zmm7
 18833fa:	62 f3 6d 48 25 fb fe 	vpternlogd $0xfe,%zmm3,%zmm2,%zmm7
 1883401:	62 f1 65 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm3
 1883408:	62 f1 65 48 ef d1    	vpxord %zmm1,%zmm3,%zmm2
 188340e:	62 b1 75 48 fe d8    	vpaddd %zmm16,%zmm1,%zmm3
 1883414:	62 f2 7d 48 44 d2    	vplzcntd %zmm2,%zmm2
 188341a:	62 f2 5d 40 45 d2    	vpsrlvd %zmm2,%zmm20,%zmm2
 1883420:	62 f3 75 48 25 da 14 	vpternlogd $0x14,%zmm2,%zmm1,%zmm3
 1883427:	62 f1 6d 48 72 f6 10 	vpslld $0x10,%zmm6,%zmm2
 188342e:	62 f2 7e 48 38 c8    	vpmovm2d %k0,%zmm1
 1883434:	62 d1 fd 48 6f f6    	vmovdqa64 %zmm14,%zmm6
 188343a:	62 f1 0d 48 72 d0 1d 	vpsrld $0x1d,%zmm0,%zmm14
 1883441:	62 f1 6d 48 72 e2 1f 	vpsrad $0x1f,%zmm2,%zmm2
 1883448:	62 f3 5d 48 25 ca c8 	vpternlogd $0xc8,%zmm2,%zmm4,%zmm1
 188344f:	62 f1 5d 58 db 25 bb d0 cf fe 	vpandd -0x1302f45(%rip){1to16},%zmm4,%zmm4        # 580514 <tier0_emit_x87.operations+0xcc>
 1883459:	62 d2 65 48 14 d6    	vprorvd %zmm14,%zmm3,%zmm2
 188345f:	62 d1 75 48 db cd    	vpandd %zmm13,%zmm1,%zmm1
 1883465:	62 f1 6d 48 72 e2 1f 	vpsrad $0x1f,%zmm2,%zmm2
 188346c:	62 f3 6d 48 25 e1 b8 	vpternlogd $0xb8,%zmm1,%zmm2,%zmm4
 1883473:	62 b1 55 48 fe d0    	vpaddd %zmm16,%zmm5,%zmm2
 1883479:	62 f1 5d 48 eb cf    	vpord  %zmm7,%zmm4,%zmm1
 188347f:	62 f3 7d 58 25 0d 8e d0 cf fe 20 	vpternlogd $0x20,-0x1302f72(%rip){1to16},%zmm0,%zmm1        # 580518 <tier0_emit_x87.operations+0xd0>
 188348a:	62 f1 7d 58 db 05 88 d0 cf fe 	vpandd -0x1302f78(%rip){1to16},%zmm0,%zmm0        # 58051c <tier0_emit_x87.operations+0xd4>
 1883494:	62 f1 6d 48 72 e2 1f 	vpsrad $0x1f,%zmm2,%zmm2
 188349b:	62 b1 fd 48 6f fb    	vmovdqa64 %zmm19,%zmm7
 18834a1:	62 f2 7d 48 55 c9    	vpopcntd %zmm1,%zmm1
 18834a7:	62 f1 6d 48 fe c0    	vpaddd %zmm0,%zmm2,%zmm0
 18834ad:	62 f1 7d 48 fe c1    	vpaddd %zmm1,%zmm0,%zmm0
 18834b3:	c5 f9 6f 0d 25 28 cf fe 	vmovdqa -0x130d7db(%rip),%xmm1        # 575ce0 <x86_effects_unknown+0x280>
 18834bb:	62 f2 75 48 8d c0    	vpermb %zmm0,%zmm1,%zmm0
 18834c1:	62 f2 fd 18 40 0d 45 cc cf fe 	vpmullq -0x13033bb(%rip){1to2},%xmm0,%xmm1        # 580110 <x86_semantics_benchmark_code.registers+0x120>
 18834cb:	c4 e2 71 00 15 1c 28 cf fe 	vpshufb -0x130d7e4(%rip),%xmm1,%xmm2        # 575cf0 <x86_effects_unknown+0x290>
 18834d4:	c5 e9 fc c9          	vpaddb %xmm1,%xmm2,%xmm1
 18834d8:	62 d2 7d 48 7c d5    	vpbroadcastd %r13d,%zmm2
 18834de:	c5 f1 f8 c0          	vpsubb %xmm0,%xmm1,%xmm0
 18834e2:	c4 c3 79 14 cd 0f    	vpextrb $0xf,%xmm1,%r13d
 18834e8:	62 f2 7d 48 31 c0    	vpmovzxbd %xmm0,%zmm0
 18834ee:	41 01 d5             	add    %edx,%r13d
 18834f1:	62 f1 6d 48 fe c0    	vpaddd %zmm0,%zmm2,%zmm0
 18834f7:	62 d1 fe 48 7f 04 8e 	vmovdqu64 %zmm0,(%r14,%rcx,4)
 18834fe:	48 83 c1 20          	add    $0x20,%rcx
 1883502:	4c 39 c9             	cmp    %r9,%rcx
 1883505:	4c 89 f9             	mov    %r15,%rcx
 1883508:	0f 86 b2 fd ff ff    	jbe    18832c0 <tier0_benchmark_run+0x6a0>
 188350e:	4c 89 cb             	mov    %r9,%rbx
 1883511:	4c 29 fb             	sub    %r15,%rbx
 1883514:	4c 89 44 24 10       	mov    %r8,0x10(%rsp)
 1883519:	0f 86 92 03 00 00    	jbe    18838b1 <tier0_benchmark_run+0xc91>
 188351f:	4c 89 fe             	mov    %r15,%rsi
 1883522:	48 c1 e6 04          	shl    $0x4,%rsi
 1883526:	48 03 74 24 50       	add    0x50(%rsp),%rsi
 188352b:	48 89 da             	mov    %rbx,%rdx
 188352e:	48 c1 e2 04          	shl    $0x4,%rdx
 1883532:	48 8d bc 24 c0 01 00 00 	lea    0x1c0(%rsp),%rdi
 188353a:	62 71 fd 48 7f 44 24 0a 	vmovdqa64 %zmm8,0x280(%rsp)
 1883542:	62 71 fd 48 7f 44 24 09 	vmovdqa64 %zmm8,0x240(%rsp)
 188354a:	62 71 fd 48 7f 44 24 08 	vmovdqa64 %zmm8,0x200(%rsp)
 1883552:	62 71 fd 48 7f 44 24 07 	vmovdqa64 %zmm8,0x1c0(%rsp)
 188355a:	c5 f8 77             	vzeroupper
 188355d:	e8 ee 0e ee fe       	call   764450 <memcpy@plt>
 1883562:	62 f1 fd 48 6f 44 24 07 	vmovdqa64 0x1c0(%rsp),%zmm0
 188356a:	62 f1 fd 48 6f 54 24 08 	vmovdqa64 0x200(%rsp),%zmm2
 1883572:	62 f1 fd 48 6f 5c 24 09 	vmovdqa64 0x240(%rsp),%zmm3
 188357a:	62 f1 fd 48 6f 64 24 0a 	vmovdqa64 0x280(%rsp),%zmm4
 1883582:	62 72 7d 48 58 2d 48 cf cf fe 	vpbroadcastd -0x13030b8(%rip),%zmm13        # 5804d4 <tier0_emit_x87.operations+0x8c>
 188358c:	62 f2 7d 48 5a 35 8a 27 cf fe 	vbroadcasti32x4 -0x130d876(%rip),%zmm6        # 575d20 <x86_effects_unknown+0x2c0>
 1883596:	62 e2 7d 48 5a 15 60 27 cf fe 	vbroadcasti32x4 -0x130d8a0(%rip),%zmm18        # 575d00 <x86_effects_unknown+0x2a0>
 18835a0:	62 72 7d 48 58 3d 2e cf cf fe 	vpbroadcastd -0x13030d2(%rip),%zmm15        # 5804d8 <tier0_emit_x87.operations+0x90>
 18835aa:	62 72 7d 48 5a 0d 5c 27 cf fe 	vbroadcasti32x4 -0x130d8a4(%rip),%zmm9        # 575d10 <x86_effects_unknown+0x2b0>
 18835b4:	62 71 fd 48 6f 35 42 d2 c9 fe 	vmovdqa64 -0x1362dbe(%rip),%zmm14        # 520800 <branch_sizing_patterns+0xa70>
 18835be:	62 e2 7d 48 58 25 1c cf cf fe 	vpbroadcastd -0x13030e4(%rip),%zmm20        # 5804e4 <tier0_emit_x87.operations+0x9c>
 18835c8:	62 e2 7d 48 5a 0d 5e 27 cf fe 	vbroadcasti32x4 -0x130d8a2(%rip),%zmm17        # 575d30 <x86_effects_unknown+0x2d0>
 18835d2:	62 e2 7d 48 58 05 00 cf cf fe 	vpbroadcastd -0x1303100(%rip),%zmm16        # 5804dc <tier0_emit_x87.operations+0x94>
 18835dc:	62 f2 7d 48 58 3d ea ce cf fe 	vpbroadcastd -0x1303116(%rip),%zmm7        # 5804d0 <tier0_emit_x87.operations+0x88>
 18835e6:	62 e2 7d 48 58 2d f8 ce cf fe 	vpbroadcastd -0x1303108(%rip),%zmm21        # 5804e8 <tier0_emit_x87.operations+0xa0>
 18835f0:	62 e2 7d 48 58 3d f6 ce cf fe 	vpbroadcastd -0x130310a(%rip),%zmm23        # 5804f0 <tier0_emit_x87.operations+0xa8>
 18835fa:	62 e2 7d 48 58 35 e8 ce cf fe 	vpbroadcastd -0x1303118(%rip),%zmm22        # 5804ec <tier0_emit_x87.operations+0xa4>
 1883604:	62 62 7d 48 58 0d ea ce cf fe 	vpbroadcastd -0x1303116(%rip),%zmm25        # 5804f8 <tier0_emit_x87.operations+0xb0>
 188360e:	62 62 7d 48 58 05 dc ce cf fe 	vpbroadcastd -0x1303124(%rip),%zmm24        # 5804f4 <tier0_emit_x87.operations+0xac>
 1883618:	62 62 7d 48 58 35 e6 ce cf fe 	vpbroadcastd -0x130311a(%rip),%zmm30        # 580508 <tier0_emit_x87.operations+0xc0>
 1883622:	62 62 7d 48 58 25 d4 ce cf fe 	vpbroadcastd -0x130312c(%rip),%zmm28        # 580500 <tier0_emit_x87.operations+0xb8>
 188362c:	62 62 7d 48 58 3d d6 ce cf fe 	vpbroadcastd -0x130312a(%rip),%zmm31        # 58050c <tier0_emit_x87.operations+0xc4>
 1883636:	62 62 7d 48 58 2d c4 ce cf fe 	vpbroadcastd -0x130313c(%rip),%zmm29        # 580504 <tier0_emit_x87.operations+0xbc>
 1883640:	62 62 7d 48 58 15 b2 ce cf fe 	vpbroadcastd -0x130314e(%rip),%zmm26        # 5804fc <tier0_emit_x87.operations+0xb4>
 188364a:	c5 fc 46 c8          	kxnorw %k0,%k0,%k1
 188364e:	48 8d 05 2b c4 da 0c 	lea    0xcdac42b(%rip),%rax        # e62fa80 <x86_template_storage>
 1883655:	62 53 1d 48 25 e4 ff 	vpternlogd $0xff,%zmm12,%zmm12,%zmm12
 188365c:	62 62 7d 48 58 1d 7a ce cf fe 	vpbroadcastd -0x1303186(%rip),%zmm27        # 5804e0 <tier0_emit_x87.operations+0x98>
 1883666:	62 e2 7d 48 58 1d a0 ce cf fe 	vpbroadcastd -0x1303160(%rip),%zmm19        # 580510 <tier0_emit_x87.operations+0xc8>
 1883670:	62 72 7d 48 58 1d ba ce cf fe 	vpbroadcastd -0x1303146(%rip),%zmm11        # 580534 <tier0_emit_x87.operations+0xec>
 188367a:	62 72 7d 48 58 15 ac ce cf fe 	vpbroadcastd -0x1303154(%rip),%zmm10        # 580530 <tier0_emit_x87.operations+0xe8>
 1883684:	4c 8b 4c 24 18       	mov    0x18(%rsp),%r9
 1883689:	4c 8b 44 24 10       	mov    0x10(%rsp),%r8
 188368e:	48 8b 7c 24 30       	mov    0x30(%rsp),%rdi
 1883693:	c4 41 39 ef c0       	vpxor  %xmm8,%xmm8,%xmm8
 1883698:	62 f1 7d 48 62 ca    	vpunpckldq %zmm2,%zmm0,%zmm1
 188369e:	62 f1 65 48 62 ec    	vpunpckldq %zmm4,%zmm3,%zmm5
 18836a4:	62 f1 7d 48 6a c2    	vpunpckhdq %zmm2,%zmm0,%zmm0
 18836aa:	62 f1 65 48 6a e4    	vpunpckhdq %zmm4,%zmm3,%zmm4
 18836b0:	62 f1 fd 48 6c dc    	vpunpcklqdq %zmm4,%zmm0,%zmm3
 18836b6:	62 f1 fd 48 6d c4    	vpunpckhqdq %zmm4,%zmm0,%zmm0
 18836bc:	62 f1 f5 48 6d cd    	vpunpckhqdq %zmm5,%zmm1,%zmm1
 18836c2:	62 f1 7d 48 72 f0 04 	vpslld $0x4,%zmm0,%zmm0
 18836c9:	62 f2 cd 48 83 eb    	vpmultishiftqb %zmm3,%zmm6,%zmm5
 18836cf:	62 f2 ed 40 83 e3    	vpmultishiftqb %zmm3,%zmm18,%zmm4
 18836d5:	62 f2 b5 48 83 f3    	vpmultishiftqb %zmm3,%zmm9,%zmm6
 18836db:	62 f2 75 48 27 c1    	vptestmd %zmm1,%zmm1,%k0
 18836e1:	62 d1 7d 48 db d5    	vpandd %zmm13,%zmm0,%zmm2
 18836e7:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 18836eb:	62 d3 5d 48 25 ef d8 	vpternlogd $0xd8,%zmm15,%zmm4,%zmm5
 18836f2:	62 f1 5d 48 72 f3 04 	vpslld $0x4,%zmm3,%zmm4
 18836f9:	62 f2 7d 49 90 44 90 13 	vpgatherdd 0x4c(%rax,%zmm2,4),%zmm0{%k1}
 1883701:	62 f1 6d 48 72 d3 1a 	vpsrld $0x1a,%zmm3,%zmm2
 1883708:	62 b3 4d 48 25 e8 d8 	vpternlogd $0xd8,%zmm16,%zmm6,%zmm5
 188370f:	62 e1 fd 48 6f c7    	vmovdqa64 %zmm7,%zmm16
 1883715:	62 f1 45 48 72 d3 08 	vpsrld $0x8,%zmm3,%zmm7
 188371c:	62 f2 75 40 00 f3    	vpshufb %zmm3,%zmm17,%zmm6
 1883722:	62 b3 7d 40 25 dc 6c 	vpternlogd $0x6c,%zmm20,%zmm16,%zmm3
 1883729:	62 f1 5d 48 72 e4 1f 	vpsrad $0x1f,%zmm4,%zmm4
 1883730:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1883735:	62 d2 6d 48 36 d6    	vpermd %zmm14,%zmm2,%zmm2
 188373b:	62 d1 65 48 fe dc    	vpaddd %zmm12,%zmm3,%zmm3
 1883741:	62 b3 7d 40 25 fd 6c 	vpternlogd $0x6c,%zmm21,%zmm16,%zmm7
 1883748:	c4 e2 61 f7 c0       	shlx   %ebx,%eax,%eax
 188374d:	62 d1 45 48 fe fc    	vpaddd %zmm12,%zmm7,%zmm7
 1883753:	62 b3 4d 40 25 df ea 	vpternlogd $0xea,%zmm23,%zmm22,%zmm3
 188375a:	62 e1 5d 48 db ce    	vpandd %zmm6,%zmm4,%zmm17
 1883760:	62 f1 05 48 72 f6 10 	vpslld $0x10,%zmm6,%zmm15
 1883767:	62 d1 fd 48 6f f5    	vmovdqa64 %zmm13,%zmm6
 188376d:	f7 d0                	not    %eax
 188376f:	62 93 45 48 25 d8 f8 	vpternlogd $0xf8,%zmm24,%zmm7,%zmm3
 1883776:	62 91 55 48 db f9    	vpandd %zmm25,%zmm5,%zmm7
 188377c:	62 f1 55 48 72 d5 03 	vpsrld $0x3,%zmm5,%zmm5
 1883783:	c5 fb 92 c8          	kmovd  %eax,%k1
 1883787:	62 f3 7d 48 25 fb f8 	vpternlogd $0xf8,%zmm3,%zmm0,%zmm7
 188378e:	62 93 7d 48 25 ec a2 	vpternlogd $0xa2,%zmm28,%zmm0,%zmm5
 1883795:	62 f1 15 48 72 d0 1d 	vpsrld $0x1d,%zmm0,%zmm13
 188379c:	62 83 6d 48 25 ce ec 	vpternlogd $0xec,%zmm30,%zmm2,%zmm17
 18837a3:	62 92 45 48 3b da    	vpminud %zmm26,%zmm7,%zmm3
 18837a9:	62 92 55 48 3b d5    	vpminud %zmm29,%zmm5,%zmm2
 18837af:	62 d1 fd 48 6f fe    	vmovdqa64 %zmm14,%zmm7
 18837b5:	62 83 7d 48 25 cf f8 	vpternlogd $0xf8,%zmm31,%zmm0,%zmm17
 18837bc:	62 e3 6d 48 25 cb fe 	vpternlogd $0xfe,%zmm3,%zmm2,%zmm17
 18837c3:	62 f1 65 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm3
 18837ca:	62 f1 65 48 ef d1    	vpxord %zmm1,%zmm3,%zmm2
 18837d0:	62 d1 75 48 fe dc    	vpaddd %zmm12,%zmm1,%zmm3
 18837d6:	62 f2 7d 48 44 d2    	vplzcntd %zmm2,%zmm2
 18837dc:	62 f2 25 40 45 d2    	vpsrlvd %zmm2,%zmm27,%zmm2
 18837e2:	62 f3 75 48 25 da 14 	vpternlogd $0x14,%zmm2,%zmm1,%zmm3
 18837e9:	62 d1 6d 48 72 e7 1f 	vpsrad $0x1f,%zmm15,%zmm2
 18837f0:	62 f2 7e 48 38 c8    	vpmovm2d %k0,%zmm1
 18837f6:	62 f3 5d 48 25 ca c8 	vpternlogd $0xc8,%zmm2,%zmm4,%zmm1
 18837fd:	62 f1 5d 58 db 25 0d cd cf fe 	vpandd -0x13032f3(%rip){1to16},%zmm4,%zmm4        # 580514 <tier0_emit_x87.operations+0xcc>
 1883807:	62 d2 65 48 14 d5    	vprorvd %zmm13,%zmm3,%zmm2
 188380d:	62 b1 75 48 db cb    	vpandd %zmm19,%zmm1,%zmm1
 1883813:	62 f1 6d 48 72 e2 1f 	vpsrad $0x1f,%zmm2,%zmm2
 188381a:	62 f3 6d 48 25 e1 b8 	vpternlogd $0xb8,%zmm1,%zmm2,%zmm4
 1883821:	62 d1 55 48 fe d4    	vpaddd %zmm12,%zmm5,%zmm2
 1883827:	62 b1 5d 48 eb c9    	vpord  %zmm17,%zmm4,%zmm1
 188382d:	62 f3 7d 58 25 0d e0 cc cf fe 20 	vpternlogd $0x20,-0x1303320(%rip){1to16},%zmm0,%zmm1        # 580518 <tier0_emit_x87.operations+0xd0>
 1883838:	62 f1 7d 58 db 05 da cc cf fe 	vpandd -0x1303326(%rip){1to16},%zmm0,%zmm0        # 58051c <tier0_emit_x87.operations+0xd4>
 1883842:	62 f1 6d 48 72 e2 1f 	vpsrad $0x1f,%zmm2,%zmm2
 1883849:	62 a1 fd 48 6f ca    	vmovdqa64 %zmm18,%zmm17
 188384f:	62 f2 7d 48 55 c9    	vpopcntd %zmm1,%zmm1
 1883855:	62 f1 6d 48 fe c0    	vpaddd %zmm0,%zmm2,%zmm0
 188385b:	62 f1 7d 48 fe c1    	vpaddd %zmm1,%zmm0,%zmm0
 1883861:	c5 f9 6f 0d 77 24 cf fe 	vmovdqa -0x130db89(%rip),%xmm1        # 575ce0 <x86_effects_unknown+0x280>
 1883869:	62 f2 75 48 8d c0    	vpermb %zmm0,%zmm1,%zmm0
 188386f:	62 f2 fd 18 40 0d 97 c8 cf fe 	vpmullq -0x1303769(%rip){1to2},%xmm0,%xmm1        # 580110 <x86_semantics_benchmark_code.registers+0x120>
 1883879:	c4 e2 71 00 15 6e 24 cf fe 	vpshufb -0x130db92(%rip),%xmm1,%xmm2        # 575cf0 <x86_effects_unknown+0x290>
 1883882:	c5 e9 fc c9          	vpaddb %xmm1,%xmm2,%xmm1
 1883886:	62 d2 7d 48 7c d5    	vpbroadcastd %r13d,%zmm2
 188388c:	c5 f1 f8 c0          	vpsubb %xmm0,%xmm1,%xmm0
 1883890:	c4 e3 79 14 c8 0f    	vpextrb $0xf,%xmm1,%eax
 1883896:	62 f2 7d 48 31 c0    	vpmovzxbd %xmm0,%zmm0
 188389c:	44 01 e8             	add    %r13d,%eax
 188389f:	41 89 c5             	mov    %eax,%r13d
 18838a2:	62 f1 6d 48 fe c0    	vpaddd %zmm0,%zmm2,%zmm0
 18838a8:	62 91 7e 49 7f 04 be 	vmovdqu32 %zmm0,(%r14,%r15,4){%k1}
 18838af:	eb 0a                	jmp    18838bb <tier0_benchmark_run+0xc9b>
 18838b1:	62 e2 7d 48 58 05 15 cc cf fe 	vpbroadcastd -0x13033eb(%rip),%zmm16        # 5804d0 <tier0_emit_x87.operations+0x88>
 18838bb:	4c 8b 74 24 48       	mov    0x48(%rsp),%r14
 18838c0:	45 31 ff             	xor    %r15d,%r15d
 18838c3:	48 8d 04 bd 00 00 00 00 	lea    0x0(,%rdi,4),%rax
 18838cb:	44 89 e9             	mov    %r13d,%ecx
 18838ce:	48 01 c1             	add    %rax,%rcx
 18838d1:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
 18838d6:	48 81 f9 ff ff ff 7f 	cmp    $0x7fffffff,%rcx
 18838dd:	0f 87 7d f5 ff ff    	ja     1882e60 <tier0_benchmark_run+0x240>
 18838e3:	48 8b 8c 24 a0 00 00 00 	mov    0xa0(%rsp),%rcx
 18838eb:	48 8b 94 24 c0 00 00 00 	mov    0xc0(%rsp),%rdx
 18838f3:	c7 01 00 00 00 00    	movl   $0x0,(%rcx)
 18838f9:	c7 02 00 00 00 00    	movl   $0x0,(%rdx)
 18838ff:	48 85 ff             	test   %rdi,%rdi
 1883902:	0f 84 58 f5 ff ff    	je     1882e60 <tier0_benchmark_run+0x240>
 1883908:	48 8b 54 24 70       	mov    0x70(%rsp),%rdx
 188390d:	4c 8d 70 0c          	lea    0xc(%rax),%r14
 1883911:	48 8d 47 ff          	lea    -0x1(%rdi),%rax
 1883915:	62 d2 7d 48 7c c9    	vpbroadcastd %r9d,%zmm1
 188391b:	62 d2 7d 48 7c c5    	vpbroadcastd %r13d,%zmm0
 1883921:	4c 89 a4 24 b0 00 00 00 	mov    %r12,0xb0(%rsp)
 1883929:	48 89 c6             	mov    %rax,%rsi
 188392c:	48 c1 ee 04          	shr    $0x4,%rsi
 1883930:	4c 8d 1c 95 00 00 00 00 	lea    0x0(,%rdx,4),%r11
 1883938:	4c 89 9c 24 98 00 00 00 	mov    %r11,0x98(%rsp)
 1883940:	0f 84 3c 04 00 00    	je     1883d82 <tier0_benchmark_run+0x1162>
 1883946:	4c 8b 4c 24 28       	mov    0x28(%rsp),%r9
 188394b:	48 8b 8c 24 a8 00 00 00 	mov    0xa8(%rsp),%rcx
 1883953:	48 89 84 24 d8 00 00 00 	mov    %rax,0xd8(%rsp)
 188395b:	62 51 fd 48 6f e2    	vmovdqa64 %zmm10,%zmm12
 1883961:	62 51 fd 48 6f eb    	vmovdqa64 %zmm11,%zmm13
 1883967:	62 72 7d 48 58 15 b3 cb cf fe 	vpbroadcastd -0x130344d(%rip),%zmm10        # 580524 <tier0_emit_x87.operations+0xdc>
 1883971:	62 72 7d 48 58 1d b1 cb cf fe 	vpbroadcastd -0x130344f(%rip),%zmm11        # 58052c <tier0_emit_x87.operations+0xe4>
 188397b:	62 72 7d 48 58 35 9b cb cf fe 	vpbroadcastd -0x1303465(%rip),%zmm14        # 580520 <tier0_emit_x87.operations+0xd8>
 1883985:	62 72 7d 48 58 3d 99 cb cf fe 	vpbroadcastd -0x1303467(%rip),%zmm15        # 580528 <tier0_emit_x87.operations+0xe0>
 188398f:	48 ff c6             	inc    %rsi
 1883992:	c5 e9 ef d2          	vpxor  %xmm2,%xmm2,%xmm2
 1883996:	49 89 ff             	mov    %rdi,%r15
 1883999:	4c 89 b4 24 90 00 00 00 	mov    %r14,0x90(%rsp)
 18839a1:	48 83 e6 fe          	and    $0xfffffffffffffffe,%rsi
 18839a5:	49 8d 41 40          	lea    0x40(%r9),%rax
 18839a9:	48 89 84 24 28 01 00 00 	mov    %rax,0x128(%rsp)
 18839b1:	48 8d 41 40          	lea    0x40(%rcx),%rax
 18839b5:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
 18839ba:	c1 e1 06             	shl    $0x6,%ecx
 18839bd:	48 03 4c 24 40       	add    0x40(%rsp),%rcx
 18839c2:	48 89 84 24 20 01 00 00 	mov    %rax,0x120(%rsp)
 18839ca:	48 8d 04 11          	lea    (%rcx,%rdx,1),%rax
 18839ce:	4d 8d 0c 08          	lea    (%r8,%rcx,1),%r9
 18839d2:	49 8d 84 00 80 00 00 00 	lea    0x80(%r8,%rax,1),%rax
 18839da:	4c 89 8c 24 00 01 00 00 	mov    %r9,0x100(%rsp)
 18839e2:	4c 8b 8c 24 88 00 00 00 	mov    0x88(%rsp),%r9
 18839ea:	48 89 84 24 18 01 00 00 	mov    %rax,0x118(%rsp)
 18839f2:	4a 8d 04 19          	lea    (%rcx,%r11,1),%rax
 18839f6:	4c 8b 9c 24 80 00 00 00 	mov    0x80(%rsp),%r11
 18839fe:	49 8d 84 00 80 00 00 00 	lea    0x80(%r8,%rax,1),%rax
 1883a06:	48 89 84 24 10 01 00 00 	mov    %rax,0x110(%rsp)
 1883a0e:	48 8d 04 52          	lea    (%rdx,%rdx,2),%rax
 1883a12:	48 01 c8             	add    %rcx,%rax
 1883a15:	4d 01 d9             	add    %r11,%r9
 1883a18:	49 8d 84 00 80 00 00 00 	lea    0x80(%r8,%rax,1),%rax
 1883a20:	49 01 c9             	add    %rcx,%r9
 1883a23:	4b 8d 94 08 84 00 00 00 	lea    0x84(%r8,%r9,1),%rdx
 1883a2b:	45 31 c9             	xor    %r9d,%r9d
 1883a2e:	48 89 84 24 08 01 00 00 	mov    %rax,0x108(%rsp)
 1883a36:	4a 8d 04 19          	lea    (%rcx,%r11,1),%rax
 1883a3a:	31 c9                	xor    %ecx,%ecx
 1883a3c:	49 8d 84 00 84 00 00 00 	lea    0x84(%r8,%rax,1),%rax
 1883a44:	48 89 94 24 80 00 00 00 	mov    %rdx,0x80(%rsp)
 1883a4c:	48 89 84 24 f8 00 00 00 	mov    %rax,0xf8(%rsp)
 1883a54:	66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 cs nopw 0x0(%rax,%rax,1)
 1883a60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1883a65:	4c 8b ac 24 20 01 00 00 	mov    0x120(%rsp),%r13
 1883a6d:	4c 8b 94 24 28 01 00 00 	mov    0x128(%rsp),%r10
 1883a75:	4c 89 fb             	mov    %r15,%rbx
 1883a78:	48 83 eb 10          	sub    $0x10,%rbx
 1883a7c:	48 89 b4 24 88 00 00 00 	mov    %rsi,0x88(%rsp)
 1883a84:	48 8b 74 24 58       	mov    0x58(%rsp),%rsi
 1883a89:	c5 d1 ef ed          	vpxor  %xmm5,%xmm5,%xmm5
 1883a8d:	62 f1 fd 48 6f f0    	vmovdqa64 %zmm0,%zmm6
 1883a93:	4c 8b 84 24 00 01 00 00 	mov    0x100(%rsp),%r8
 1883a9b:	48 8b 94 24 10 01 00 00 	mov    0x110(%rsp),%rdx
 1883aa3:	4c 8b 9c 24 f8 00 00 00 	mov    0xf8(%rsp),%r11
 1883aab:	48 8b bc 24 80 00 00 00 	mov    0x80(%rsp),%rdi
 1883ab3:	c4 62 01 f7 f0       	shlx   %r15d,%eax,%r14d
 1883ab8:	b8 ff ff 00 00       	mov    $0xffff,%eax
 1883abd:	41 f7 d6             	not    %r14d
 1883ac0:	44 0f 43 f0          	cmovae %eax,%r14d
 1883ac4:	48 8b 84 24 90 00 00 00 	mov    0x90(%rsp),%rax
 1883acc:	c4 c1 7b 92 ce       	kmovd  %r14d,%k1
 1883ad1:	45 89 ce             	mov    %r9d,%r14d
 1883ad4:	41 b9 ff ff ff ff    	mov    $0xffffffff,%r9d
 1883ada:	62 d1 7e c9 6f 64 8d ff 	vmovdqu32 -0x40(%r13,%rcx,4),%zmm4{%k1}{z}
 1883ae2:	62 d1 7e c9 6f 5c 8a ff 	vmovdqu32 -0x40(%r10,%rcx,4),%zmm3{%k1}{z}
 1883aea:	c4 e1 f8 90 d9       	kmovq  %k1,%k3
 1883aef:	c4 42 61 f7 c9       	shlx   %ebx,%r9d,%r9d
 1883af4:	41 f7 d1             	not    %r9d
 1883af7:	62 f3 5d 49 1e d1 01 	vpcmpltud %zmm1,%zmm4,%k2{%k1}
 1883afe:	62 f2 7d 4b 90 2c 9e 	vpgatherdd (%rsi,%zmm3,4),%zmm5{%k3}
 1883b05:	62 f1 65 48 fe db    	vpaddd %zmm3,%zmm3,%zmm3
 1883b0b:	c4 e1 f8 90 d9       	kmovq  %k1,%k3
 1883b10:	62 f2 7d 4a 90 34 a6 	vpgatherdd (%rsi,%zmm4,4),%zmm6{%k2}
 1883b17:	62 f1 4d 48 fa e5    	vpsubd %zmm5,%zmm6,%zmm4
 1883b1d:	62 d1 5d c9 fe e3    	vpaddd %zmm11,%zmm4,%zmm4{%k1}{z}
 1883b23:	62 d1 5d 48 fe ec    	vpaddd %zmm12,%zmm4,%zmm5
 1883b29:	62 d3 55 48 1e d5 01 	vpcmpltud %zmm13,%zmm5,%k2
 1883b30:	c5 d1 ef ed          	vpxor  %xmm5,%xmm5,%xmm5
 1883b34:	62 f2 7d 4b 90 2c d8 	vpgatherdd (%rax,%zmm3,8),%zmm5{%k3}
 1883b3b:	48 8b 84 24 08 01 00 00 	mov    0x108(%rsp),%rax
 1883b43:	c5 ec 41 c1          	kandw  %k1,%k2,%k0
 1883b47:	c5 78 93 e0          	kmovw  %k0,%r12d
 1883b4b:	45 09 e6             	or     %r12d,%r14d
 1883b4e:	4c 8b a4 24 18 01 00 00 	mov    0x118(%rsp),%r12
 1883b56:	48 83 fb 10          	cmp    $0x10,%rbx
 1883b5a:	bb ff ff 00 00       	mov    $0xffff,%ebx
 1883b5f:	44 0f 43 cb          	cmovae %ebx,%r9d
 1883b63:	49 83 c7 e0          	add    $0xffffffffffffffe0,%r15
 1883b67:	62 d1 55 48 db de    	vpandd %zmm14,%zmm5,%zmm3
 1883b6d:	62 d1 65 48 76 da    	vpcmpeqd %zmm10,%zmm3,%k3
 1883b73:	62 d2 7d 43 64 df    	vpblendmd %zmm15,%zmm16,%zmm3{%k3}
 1883b79:	62 f1 7d c9 6f db    	vmovdqa32 %zmm3,%zmm3{%k1}{z}
 1883b7f:	62 f1 7d ca 6f eb    	vmovdqa32 %zmm3,%zmm5{%k2}{z}
 1883b85:	62 d3 55 48 03 f0 0f 	valignd $0xf,%zmm8,%zmm5,%zmm6
 1883b8c:	62 d1 fd 48 7f 5c 88 01 	vmovdqa64 %zmm3,0x40(%r8,%rcx,4)
 1883b94:	62 d1 fd 48 7f 64 8c ff 	vmovdqa64 %zmm4,-0x40(%r12,%rcx,4)
 1883b9c:	62 f1 fd 48 7f 64 8a ff 	vmovdqa64 %zmm4,-0x40(%rdx,%rcx,4)
 1883ba4:	c4 c1 7b 92 c9       	kmovd  %r9d,%k1
 1883ba9:	62 f1 fd 48 7f 6c 88 ff 	vmovdqa64 %zmm5,-0x40(%rax,%rcx,4)
 1883bb1:	c4 e1 f8 90 d9       	kmovq  %k1,%k3
 1883bb6:	62 f1 4d 48 fe f5    	vpaddd %zmm5,%zmm6,%zmm6
 1883bbc:	c5 d1 ef ed          	vpxor  %xmm5,%xmm5,%xmm5
 1883bc0:	62 d3 cd 48 03 f8 07 	valignq $0x7,%zmm8,%zmm6,%zmm7
 1883bc7:	62 f1 45 48 fe f6    	vpaddd %zmm6,%zmm7,%zmm6
 1883bcd:	62 d3 cd 48 03 f8 06 	valignq $0x6,%zmm8,%zmm6,%zmm7
 1883bd4:	62 f1 45 48 fe f6    	vpaddd %zmm6,%zmm7,%zmm6
 1883bda:	62 d3 cd 48 03 f8 04 	valignq $0x4,%zmm8,%zmm6,%zmm7
 1883be1:	62 f1 4d 48 fe d2    	vpaddd %zmm2,%zmm6,%zmm2
 1883be7:	62 f1 fd 48 6f f0    	vmovdqa64 %zmm0,%zmm6
 1883bed:	62 f1 6d 48 fe d7    	vpaddd %zmm7,%zmm2,%zmm2
 1883bf3:	62 d1 fe 48 7f 54 8b ff 	vmovdqu64 %zmm2,-0x40(%r11,%rcx,4)
 1883bfb:	62 71 fe 48 7f 44 8f ff 	vmovdqu64 %zmm8,-0x40(%rdi,%rcx,4)
 1883c03:	62 f1 7d 48 70 d2 ff 	vpshufd $0xff,%zmm2,%zmm2
 1883c0a:	62 d1 7e c9 6f 64 8d 00 	vmovdqu32 0x0(%r13,%rcx,4),%zmm4{%k1}{z}
 1883c12:	62 d1 7e c9 6f 1c 8a 	vmovdqu32 (%r10,%rcx,4),%zmm3{%k1}{z}
 1883c19:	62 f3 ed 48 43 d2 ff 	vshufi64x2 $0xff,%zmm2,%zmm2,%zmm2
 1883c20:	62 f3 5d 49 1e d1 01 	vpcmpltud %zmm1,%zmm4,%k2{%k1}
 1883c27:	62 f2 7d 4b 90 2c 9e 	vpgatherdd (%rsi,%zmm3,4),%zmm5{%k3}
 1883c2e:	62 f1 65 48 fe db    	vpaddd %zmm3,%zmm3,%zmm3
 1883c34:	c4 e1 f8 90 d9       	kmovq  %k1,%k3
 1883c39:	62 f2 7d 4a 90 34 a6 	vpgatherdd (%rsi,%zmm4,4),%zmm6{%k2}
 1883c40:	48 8b b4 24 88 00 00 00 	mov    0x88(%rsp),%rsi
 1883c48:	62 f1 4d 48 fa e5    	vpsubd %zmm5,%zmm6,%zmm4
 1883c4e:	62 d1 5d c9 fe e3    	vpaddd %zmm11,%zmm4,%zmm4{%k1}{z}
 1883c54:	62 d1 5d 48 fe ec    	vpaddd %zmm12,%zmm4,%zmm5
 1883c5a:	62 d3 55 48 1e d5 01 	vpcmpltud %zmm13,%zmm5,%k2
 1883c61:	c5 d1 ef ed          	vpxor  %xmm5,%xmm5,%xmm5
 1883c65:	c5 ec 41 c1          	kandw  %k1,%k2,%k0
 1883c69:	c5 78 93 c8          	kmovw  %k0,%r9d
 1883c6d:	45 09 f1             	or     %r14d,%r9d
 1883c70:	4c 8b b4 24 90 00 00 00 	mov    0x90(%rsp),%r14
 1883c78:	62 d2 7d 4b 90 2c de 	vpgatherdd (%r14,%zmm3,8),%zmm5{%k3}
 1883c7f:	62 d1 55 48 db de    	vpandd %zmm14,%zmm5,%zmm3
 1883c85:	62 d1 65 48 76 da    	vpcmpeqd %zmm10,%zmm3,%k3
 1883c8b:	62 d2 7d 43 64 df    	vpblendmd %zmm15,%zmm16,%zmm3{%k3}
 1883c91:	62 f1 7d c9 6f db    	vmovdqa32 %zmm3,%zmm3{%k1}{z}
 1883c97:	62 f1 7d ca 6f eb    	vmovdqa32 %zmm3,%zmm5{%k2}{z}
 1883c9d:	62 d3 55 48 03 f0 0f 	valignd $0xf,%zmm8,%zmm5,%zmm6
 1883ca4:	62 d1 fd 48 7f 5c 88 02 	vmovdqa64 %zmm3,0x80(%r8,%rcx,4)
 1883cac:	62 d1 fd 48 7f 24 8c 	vmovdqa64 %zmm4,(%r12,%rcx,4)
 1883cb3:	62 f1 fd 48 7f 24 8a 	vmovdqa64 %zmm4,(%rdx,%rcx,4)
 1883cba:	62 f1 fd 48 7f 2c 88 	vmovdqa64 %zmm5,(%rax,%rcx,4)
 1883cc1:	62 f1 4d 48 fe f5    	vpaddd %zmm5,%zmm6,%zmm6
 1883cc7:	62 d3 cd 48 03 f8 07 	valignq $0x7,%zmm8,%zmm6,%zmm7
 1883cce:	62 f1 45 48 fe f6    	vpaddd %zmm6,%zmm7,%zmm6
 1883cd4:	62 d3 cd 48 03 f8 06 	valignq $0x6,%zmm8,%zmm6,%zmm7
 1883cdb:	62 f1 45 48 fe f6    	vpaddd %zmm6,%zmm7,%zmm6
 1883ce1:	62 d3 cd 48 03 f8 04 	valignq $0x4,%zmm8,%zmm6,%zmm7
 1883ce8:	62 f1 4d 48 fe f7    	vpaddd %zmm7,%zmm6,%zmm6
 1883cee:	62 f1 4d 48 fe d2    	vpaddd %zmm2,%zmm6,%zmm2
 1883cf4:	62 d1 fe 48 7f 14 8b 	vmovdqu64 %zmm2,(%r11,%rcx,4)
 1883cfb:	62 f1 7d 48 70 d2 ff 	vpshufd $0xff,%zmm2,%zmm2
 1883d02:	62 71 fe 48 7f 04 8f 	vmovdqu64 %zmm8,(%rdi,%rcx,4)
 1883d09:	48 83 c1 20          	add    $0x20,%rcx
 1883d0d:	48 83 c6 fe          	add    $0xfffffffffffffffe,%rsi
 1883d11:	62 f3 ed 48 43 d2 ff 	vshufi64x2 $0xff,%zmm2,%zmm2,%zmm2
 1883d18:	0f 85 42 fd ff ff    	jne    1883a60 <tier0_benchmark_run+0xe40>
 1883d1e:	62 f2 7d 48 58 35 ac c7 cf fe 	vpbroadcastd -0x1303854(%rip),%zmm6        # 5804d4 <tier0_emit_x87.operations+0x8c>
 1883d28:	62 f1 fd 48 6f 3d ce ca c9 fe 	vmovdqa64 -0x1363532(%rip),%zmm7        # 520800 <branch_sizing_patterns+0xa70>
 1883d32:	62 e2 7d 48 5a 0d c4 1f cf fe 	vbroadcasti32x4 -0x130e03c(%rip),%zmm17        # 575d00 <x86_effects_unknown+0x2a0>
 1883d3c:	f6 84 24 d8 00 00 00 10 	testb  $0x10,0xd8(%rsp)
 1883d44:	48 8b 7c 24 30       	mov    0x30(%rsp),%rdi
 1883d49:	4c 8b 5c 24 58       	mov    0x58(%rsp),%r11
 1883d4e:	4c 8b a4 24 b0 00 00 00 	mov    0xb0(%rsp),%r12
 1883d56:	4c 8b 84 24 a0 00 00 00 	mov    0xa0(%rsp),%r8
 1883d5e:	41 bf 00 00 00 00    	mov    $0x0,%r15d
 1883d64:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
 1883d69:	41 bd ff ff 00 00    	mov    $0xffff,%r13d
 1883d6f:	62 51 fd 48 6f d4    	vmovdqa64 %zmm12,%zmm10
 1883d75:	62 51 fd 48 6f dd    	vmovdqa64 %zmm13,%zmm11
 1883d7b:	74 26                	je     1883da3 <tier0_benchmark_run+0x1183>
 1883d7d:	e9 67 01 00 00       	jmp    1883ee9 <tier0_benchmark_run+0x12c9>
 1883d82:	4c 8b 5c 24 58       	mov    0x58(%rsp),%r11
 1883d87:	4c 8b 84 24 a0 00 00 00 	mov    0xa0(%rsp),%r8
 1883d8f:	45 31 c9             	xor    %r9d,%r9d
 1883d92:	c5 e9 ef d2          	vpxor  %xmm2,%xmm2,%xmm2
 1883d96:	31 c9                	xor    %ecx,%ecx
 1883d98:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
 1883d9d:	41 bd ff ff 00 00    	mov    $0xffff,%r13d
 1883da3:	48 89 f8             	mov    %rdi,%rax
 1883da6:	48 29 c8             	sub    %rcx,%rax
 1883da9:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
 1883dae:	c5 d1 ef ed          	vpxor  %xmm5,%xmm5,%xmm5
 1883db2:	48 83 f8 10          	cmp    $0x10,%rax
 1883db6:	c4 e2 79 f7 c3       	shlx   %eax,%ebx,%eax
 1883dbb:	f7 d0                	not    %eax
 1883dbd:	41 0f 43 c5          	cmovae %r13d,%eax
 1883dc1:	c5 fb 92 c8          	kmovd  %eax,%k1
 1883dc5:	48 8b 84 24 a8 00 00 00 	mov    0xa8(%rsp),%rax
 1883dcd:	62 f1 7e c9 6f 1c 8a 	vmovdqu32 (%rdx,%rcx,4),%zmm3{%k1}{z}
 1883dd4:	c4 e1 f8 90 d1       	kmovq  %k1,%k2
 1883dd9:	c4 e1 f8 90 d9       	kmovq  %k1,%k3
 1883dde:	62 71 7e c9 6f 24 88 	vmovdqu32 (%rax,%rcx,4),%zmm12{%k1}{z}
 1883de5:	62 f1 65 48 fe e3    	vpaddd %zmm3,%zmm3,%zmm4
 1883deb:	62 d2 7d 4a 90 2c e6 	vpgatherdd (%r14,%zmm4,8),%zmm5{%k2}
 1883df2:	62 f3 1d 49 1e d1 01 	vpcmpltud %zmm1,%zmm12,%k2{%k1}
 1883df9:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
 1883dfd:	62 d2 7d 4b 90 0c 9b 	vpgatherdd (%r11,%zmm3,4),%zmm1{%k3}
 1883e04:	62 f1 55 58 db 1d 12 c7 cf fe 	vpandd -0x13038ee(%rip){1to16},%zmm5,%zmm3        # 580520 <tier0_emit_x87.operations+0xd8>
 1883e0e:	62 92 7d 4a 90 04 a3 	vpgatherdd (%r11,%zmm12,4),%zmm0{%k2}
 1883e15:	62 f1 65 58 76 15 05 c7 cf fe 	vpcmpeqd -0x13038fb(%rip){1to16},%zmm3,%k2        # 580524 <tier0_emit_x87.operations+0xdc>
 1883e1f:	62 f1 7d 48 fa c1    	vpsubd %zmm1,%zmm0,%zmm0
 1883e25:	62 f2 7d 52 64 0d f9 c6 cf fe 	vpblendmd -0x1303907(%rip){1to16},%zmm16,%zmm1{%k2}        # 580528 <tier0_emit_x87.operations+0xe0>
 1883e2f:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
 1883e34:	48 8b b4 24 e8 00 00 00 	mov    0xe8(%rsp),%rsi
 1883e3c:	48 8b 94 24 e0 00 00 00 	mov    0xe0(%rsp),%rdx
 1883e44:	62 f1 7d d9 fe 05 de c6 cf fe 	vpaddd -0x1303922(%rip){1to16},%zmm0,%zmm0{%k1}{z}        # 58052c <tier0_emit_x87.operations+0xe4>
 1883e4e:	62 f1 7d c9 6f c9    	vmovdqa32 %zmm1,%zmm1{%k1}{z}
 1883e54:	62 f1 fd 48 7f 0c 88 	vmovdqa64 %zmm1,(%rax,%rcx,4)
 1883e5b:	48 8b 84 24 c0 00 00 00 	mov    0xc0(%rsp),%rax
 1883e63:	62 f1 fd 48 7f 04 8e 	vmovdqa64 %zmm0,(%rsi,%rcx,4)
 1883e6a:	62 f1 fd 48 7f 04 8a 	vmovdqa64 %zmm0,(%rdx,%rcx,4)
 1883e71:	62 d1 7d 48 fe c2    	vpaddd %zmm10,%zmm0,%zmm0
 1883e77:	62 d3 7d 48 1e d3 01 	vpcmpltud %zmm11,%zmm0,%k2
 1883e7e:	62 f1 7d ca 6f c1    	vmovdqa32 %zmm1,%zmm0{%k2}{z}
 1883e84:	62 d3 7d 48 03 c8 0f 	valignd $0xf,%zmm8,%zmm0,%zmm1
 1883e8b:	c5 ec 41 c1          	kandw  %k1,%k2,%k0
 1883e8f:	62 d1 fd 48 7f 04 8c 	vmovdqa64 %zmm0,(%r12,%rcx,4)
 1883e96:	62 f1 75 48 fe c8    	vpaddd %zmm0,%zmm1,%zmm1
 1883e9c:	62 d3 f5 48 03 d8 07 	valignq $0x7,%zmm8,%zmm1,%zmm3
 1883ea3:	62 f1 65 48 fe c9    	vpaddd %zmm1,%zmm3,%zmm1
 1883ea9:	62 d3 f5 48 03 d8 06 	valignq $0x6,%zmm8,%zmm1,%zmm3
 1883eb0:	62 f1 65 48 fe c9    	vpaddd %zmm1,%zmm3,%zmm1
 1883eb6:	62 d3 f5 48 03 d8 04 	valignq $0x4,%zmm8,%zmm1,%zmm3
 1883ebd:	62 f1 75 48 fe ca    	vpaddd %zmm2,%zmm1,%zmm1
 1883ec3:	62 f1 75 48 fe cb    	vpaddd %zmm3,%zmm1,%zmm1
 1883ec9:	62 d1 fe 48 7f 8c 88 04 00 00 00 	vmovdqu64 %zmm1,0x4(%r8,%rcx,4)
 1883ed4:	62 71 fe 48 7f 84 88 04 00 00 00 	vmovdqu64 %zmm8,0x4(%rax,%rcx,4)
 1883edf:	44 89 c9             	mov    %r9d,%ecx
 1883ee2:	c5 78 93 c8          	kmovw  %k0,%r9d
 1883ee6:	41 09 c9             	or     %ecx,%r9d
 1883ee9:	4c 8b 74 24 78       	mov    0x78(%rsp),%r14
 1883eee:	45 85 c9             	test   %r9d,%r9d
 1883ef1:	0f 84 08 07 00 00    	je     18845ff <tier0_benchmark_run+0x19df>
 1883ef7:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
 1883efc:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
 1883f01:	81 e2 c0 ff ff 1f    	and    $0x1fffffc0,%edx
 1883f07:	31 f6                	xor    %esi,%esi
 1883f09:	48 83 c2 40          	add    $0x40,%rdx
 1883f0d:	c5 f8 77             	vzeroupper
 1883f10:	e8 1b 04 ee fe       	call   764330 <memset@plt>
 1883f15:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
 1883f1a:	89 d0                	mov    %edx,%eax
 1883f1c:	83 e0 07             	and    $0x7,%eax
 1883f1f:	83 fa 08             	cmp    $0x8,%edx
 1883f22:	73 61                	jae    1883f85 <tier0_benchmark_run+0x1365>
 1883f24:	62 f2 7d 48 58 05 a6 c5 cf fe 	vpbroadcastd -0x1303a5a(%rip),%zmm0        # 5804d4 <tier0_emit_x87.operations+0x8c>
 1883f2e:	62 f1 fd 48 6f 0d c8 c8 c9 fe 	vmovdqa64 -0x1363738(%rip),%zmm1        # 520800 <branch_sizing_patterns+0xa70>
 1883f38:	62 e2 7d 48 5a 0d be 1d cf fe 	vbroadcasti32x4 -0x130e242(%rip),%zmm17        # 575d00 <x86_effects_unknown+0x2a0>
 1883f42:	62 f2 7d 48 5a 15 d4 1d cf fe 	vbroadcasti32x4 -0x130e22c(%rip),%zmm2        # 575d20 <x86_effects_unknown+0x2c0>
 1883f4c:	62 72 7d 48 5a 3d ba 1d cf fe 	vbroadcasti32x4 -0x130e246(%rip),%zmm15        # 575d10 <x86_effects_unknown+0x2b0>
 1883f56:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
 1883f5b:	4c 8b 44 24 10       	mov    0x10(%rsp),%r8
 1883f60:	4c 8b 4c 24 18       	mov    0x18(%rsp),%r9
 1883f65:	4c 8b 5c 24 60       	mov    0x60(%rsp),%r11
 1883f6a:	4c 8b bc 24 c8 00 00 00 	mov    0xc8(%rsp),%r15
 1883f72:	31 c9                	xor    %ecx,%ecx
 1883f74:	c4 41 39 ef c0       	vpxor  %xmm8,%xmm8,%xmm8
 1883f79:	62 f3 45 48 25 ff ff 	vpternlogd $0xff,%zmm7,%zmm7,%zmm7
 1883f80:	e9 c3 00 00 00       	jmp    1884048 <tier0_benchmark_run+0x1428>
 1883f85:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
 1883f8a:	4c 8b 44 24 10       	mov    0x10(%rsp),%r8
 1883f8f:	4c 8b 5c 24 60       	mov    0x60(%rsp),%r11
 1883f94:	4c 8b bc 24 c8 00 00 00 	mov    0xc8(%rsp),%r15
 1883f9c:	83 e2 f8             	and    $0xfffffff8,%edx
 1883f9f:	31 c9                	xor    %ecx,%ecx
 1883fa1:	66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1883fb0:	8b 34 8f             	mov    (%rdi,%rcx,4),%esi
 1883fb3:	41 c6 04 30 01       	movb   $0x1,(%r8,%rsi,1)
 1883fb8:	8b 74 8f 04          	mov    0x4(%rdi,%rcx,4),%esi
 1883fbc:	41 c6 04 30 01       	movb   $0x1,(%r8,%rsi,1)
 1883fc1:	8b 74 8f 08          	mov    0x8(%rdi,%rcx,4),%esi
 1883fc5:	41 c6 04 30 01       	movb   $0x1,(%r8,%rsi,1)
 1883fca:	8b 74 8f 0c          	mov    0xc(%rdi,%rcx,4),%esi
 1883fce:	41 c6 04 30 01       	movb   $0x1,(%r8,%rsi,1)
 1883fd3:	8b 74 8f 10          	mov    0x10(%rdi,%rcx,4),%esi
 1883fd7:	41 c6 04 30 01       	movb   $0x1,(%r8,%rsi,1)
 1883fdc:	8b 74 8f 14          	mov    0x14(%rdi,%rcx,4),%esi
 1883fe0:	41 c6 04 30 01       	movb   $0x1,(%r8,%rsi,1)
 1883fe5:	8b 74 8f 18          	mov    0x18(%rdi,%rcx,4),%esi
 1883fe9:	41 c6 04 30 01       	movb   $0x1,(%r8,%rsi,1)
 1883fee:	8b 74 8f 1c          	mov    0x1c(%rdi,%rcx,4),%esi
 1883ff2:	48 83 c1 08          	add    $0x8,%rcx
 1883ff6:	41 c6 04 30 01       	movb   $0x1,(%r8,%rsi,1)
 1883ffb:	48 39 ca             	cmp    %rcx,%rdx
 1883ffe:	75 b0                	jne    1883fb0 <tier0_benchmark_run+0x1390>
 1884000:	62 f2 7d 48 58 05 ca c4 cf fe 	vpbroadcastd -0x1303b36(%rip),%zmm0        # 5804d4 <tier0_emit_x87.operations+0x8c>
 188400a:	62 f1 fd 48 6f 0d ec c7 c9 fe 	vmovdqa64 -0x1363814(%rip),%zmm1        # 520800 <branch_sizing_patterns+0xa70>
 1884014:	62 e2 7d 48 5a 0d e2 1c cf fe 	vbroadcasti32x4 -0x130e31e(%rip),%zmm17        # 575d00 <x86_effects_unknown+0x2a0>
 188401e:	62 f2 7d 48 5a 15 f8 1c cf fe 	vbroadcasti32x4 -0x130e308(%rip),%zmm2        # 575d20 <x86_effects_unknown+0x2c0>
 1884028:	62 72 7d 48 5a 3d de 1c cf fe 	vbroadcasti32x4 -0x130e322(%rip),%zmm15        # 575d10 <x86_effects_unknown+0x2b0>
 1884032:	4c 8b 4c 24 18       	mov    0x18(%rsp),%r9
 1884037:	62 f3 45 48 25 ff ff 	vpternlogd $0xff,%zmm7,%zmm7,%zmm7
 188403e:	c4 41 39 ef c0       	vpxor  %xmm8,%xmm8,%xmm8
 1884043:	48 85 c0             	test   %rax,%rax
 1884046:	74 18                	je     1884060 <tier0_benchmark_run+0x1440>
 1884048:	48 8d 0c 8f          	lea    (%rdi,%rcx,4),%rcx
 188404c:	31 d2                	xor    %edx,%edx
 188404e:	66 90                	xchg   %ax,%ax
 1884050:	8b 34 91             	mov    (%rcx,%rdx,4),%esi
 1884053:	48 ff c2             	inc    %rdx
 1884056:	41 c6 04 30 01       	movb   $0x1,(%r8,%rsi,1)
 188405b:	48 39 d0             	cmp    %rdx,%rax
 188405e:	75 f0                	jne    1884050 <tier0_benchmark_run+0x1430>
 1884060:	62 72 7d 48 58 15 c6 c4 cf fe 	vpbroadcastd -0x1303b3a(%rip),%zmm10        # 580530 <tier0_emit_x87.operations+0xe8>
 188406a:	62 72 7d 48 58 1d c0 c4 cf fe 	vpbroadcastd -0x1303b40(%rip),%zmm11        # 580534 <tier0_emit_x87.operations+0xec>
 1884074:	62 f1 fd 48 6f 25 02 c9 c9 fe 	vmovdqa64 -0x13636fe(%rip),%zmm4        # 520980 <branch_sizing_patterns+0xbf0>
 188407e:	62 f1 fd 48 6f 2d 38 c9 c9 fe 	vmovdqa64 -0x13636c8(%rip),%zmm5        # 5209c0 <branch_sizing_patterns+0xc30>
 1884088:	62 f2 7d 48 58 35 a6 c4 cf fe 	vpbroadcastd -0x1303b5a(%rip),%zmm6        # 580538 <tier0_emit_x87.operations+0xf0>
 1884092:	44 89 f8             	mov    %r15d,%eax
 1884095:	83 e0 03             	and    $0x3,%eax
 1884098:	62 71 fd 48 6f c8    	vmovdqa64 %zmm0,%zmm9
 188409e:	62 71 fd 48 6f e9    	vmovdqa64 %zmm1,%zmm13
 18840a4:	41 81 f9 c0 00 00 00 	cmp    $0xc0,%r9d
 18840ab:	73 0f                	jae    18840bc <tier0_benchmark_run+0x149c>
 18840ad:	31 ff                	xor    %edi,%edi
 18840af:	31 c9                	xor    %ecx,%ecx
 18840b1:	62 71 fd 48 6f e2    	vmovdqa64 %zmm2,%zmm12
 18840b7:	e9 54 01 00 00       	jmp    1884210 <tier0_benchmark_run+0x15f0>
 18840bc:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
 18840c1:	c1 e1 06             	shl    $0x6,%ecx
 18840c4:	41 81 e7 fc ff ff 00 	and    $0xfffffc,%r15d
 18840cb:	49 8d 90 c0 00 00 00 	lea    0xc0(%r8),%rdx
 18840d2:	31 ff                	xor    %edi,%edi
 18840d4:	62 71 fd 48 6f e2    	vmovdqa64 %zmm2,%zmm12
 18840da:	49 8d 74 08 78       	lea    0x78(%r8,%rcx,1),%rsi
 18840df:	31 c9                	xor    %ecx,%ecx
 18840e1:	66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 18840f0:	62 f1 fd 48 6f 42 fd 	vmovdqa64 -0xc0(%rdx),%zmm0
 18840f7:	48 83 c1 04          	add    $0x4,%rcx
 18840fb:	62 f2 7d 48 26 c0    	vptestmb %zmm0,%zmm0,%k0
 1884101:	c4 61 fb 93 c0       	kmovq  %k0,%r8
 1884106:	f3 45 0f b8 d0       	popcnt %r8d,%r10d
 188410b:	45 89 c1             	mov    %r8d,%r9d
 188410e:	49 01 fa             	add    %rdi,%r10
 1884111:	48 c1 e7 20          	shl    $0x20,%rdi
 1884115:	4d 89 d3             	mov    %r10,%r11
 1884118:	4d 0f a4 c3 20       	shld   $0x20,%r8,%r11
 188411d:	4c 09 cf             	or     %r9,%rdi
 1884120:	49 c1 e8 20          	shr    $0x20,%r8
 1884124:	48 89 7e c8          	mov    %rdi,-0x38(%rsi)
 1884128:	f3 41 0f b8 f8       	popcnt %r8d,%edi
 188412d:	4c 89 5e d0          	mov    %r11,-0x30(%rsi)
 1884131:	4c 01 d7             	add    %r10,%rdi
 1884134:	62 f1 fd 48 6f 42 fe 	vmovdqa64 -0x80(%rdx),%zmm0
 188413b:	62 f2 7d 48 26 c0    	vptestmb %zmm0,%zmm0,%k0
 1884141:	c4 61 fb 93 c0       	kmovq  %k0,%r8
 1884146:	f3 45 0f b8 d0       	popcnt %r8d,%r10d
 188414b:	45 89 c1             	mov    %r8d,%r9d
 188414e:	49 01 fa             	add    %rdi,%r10
 1884151:	48 c1 e7 20          	shl    $0x20,%rdi
 1884155:	4d 89 d3             	mov    %r10,%r11
 1884158:	4d 0f a4 c3 20       	shld   $0x20,%r8,%r11
 188415d:	4c 09 cf             	or     %r9,%rdi
 1884160:	49 c1 e8 20          	shr    $0x20,%r8
 1884164:	48 89 7e d8          	mov    %rdi,-0x28(%rsi)
 1884168:	f3 41 0f b8 f8       	popcnt %r8d,%edi
 188416d:	4c 89 5e e0          	mov    %r11,-0x20(%rsi)
 1884171:	4c 01 d7             	add    %r10,%rdi
 1884174:	62 f1 fd 48 6f 42 ff 	vmovdqa64 -0x40(%rdx),%zmm0
 188417b:	62 f2 7d 48 26 c0    	vptestmb %zmm0,%zmm0,%k0
 1884181:	c4 61 fb 93 c0       	kmovq  %k0,%r8
 1884186:	f3 45 0f b8 d0       	popcnt %r8d,%r10d
 188418b:	45 89 c1             	mov    %r8d,%r9d
 188418e:	49 01 fa             	add    %rdi,%r10
 1884191:	48 c1 e7 20          	shl    $0x20,%rdi
 1884195:	4d 89 d3             	mov    %r10,%r11
 1884198:	4d 0f a4 c3 20       	shld   $0x20,%r8,%r11
 188419d:	4c 09 cf             	or     %r9,%rdi
 18841a0:	49 c1 e8 20          	shr    $0x20,%r8
 18841a4:	48 89 7e e8          	mov    %rdi,-0x18(%rsi)
 18841a8:	f3 41 0f b8 f8       	popcnt %r8d,%edi
 18841ad:	4c 89 5e f0          	mov    %r11,-0x10(%rsi)
 18841b1:	4c 01 d7             	add    %r10,%rdi
 18841b4:	62 f1 fd 48 6f 02    	vmovdqa64 (%rdx),%zmm0
 18841ba:	48 81 c2 00 01 00 00 	add    $0x100,%rdx
 18841c1:	62 f2 7d 48 26 c0    	vptestmb %zmm0,%zmm0,%k0
 18841c7:	c4 61 fb 93 c0       	kmovq  %k0,%r8
 18841cc:	f3 45 0f b8 d0       	popcnt %r8d,%r10d
 18841d1:	45 89 c1             	mov    %r8d,%r9d
 18841d4:	49 01 fa             	add    %rdi,%r10
 18841d7:	48 c1 e7 20          	shl    $0x20,%rdi
 18841db:	4c 09 cf             	or     %r9,%rdi
 18841de:	48 89 7e f8          	mov    %rdi,-0x8(%rsi)
 18841e2:	4c 89 d7             	mov    %r10,%rdi
 18841e5:	4c 0f a4 c7 20       	shld   $0x20,%r8,%rdi
 18841ea:	49 c1 e8 20          	shr    $0x20,%r8
 18841ee:	48 89 3e             	mov    %rdi,(%rsi)
 18841f1:	f3 41 0f b8 f8       	popcnt %r8d,%edi
 18841f6:	48 83 c6 40          	add    $0x40,%rsi
 18841fa:	4c 01 d7             	add    %r10,%rdi
 18841fd:	49 39 cf             	cmp    %rcx,%r15
 1884200:	0f 85 ea fe ff ff    	jne    18840f0 <tier0_benchmark_run+0x14d0>
 1884206:	4c 8b 5c 24 60       	mov    0x60(%rsp),%r11
 188420b:	48 85 c0             	test   %rax,%rax
 188420e:	74 7a                	je     188428a <tier0_benchmark_run+0x166a>
 1884210:	4c 8b 44 24 10       	mov    0x10(%rsp),%r8
 1884215:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
 188421a:	48 89 ce             	mov    %rcx,%rsi
 188421d:	c1 e2 06             	shl    $0x6,%edx
 1884220:	48 c1 e6 04          	shl    $0x4,%rsi
 1884224:	48 c1 e1 06          	shl    $0x6,%rcx
 1884228:	c1 e0 04             	shl    $0x4,%eax
 188422b:	48 01 d6             	add    %rdx,%rsi
 188422e:	49 8d 54 30 48       	lea    0x48(%r8,%rsi,1),%rdx
 1884233:	4c 01 c1             	add    %r8,%rcx
 1884236:	31 f6                	xor    %esi,%esi
 1884238:	0f 1f 84 00 00 00 00 00 	nopl   0x0(%rax,%rax,1)
 1884240:	62 f1 fd 48 6f 04 b1 	vmovdqa64 (%rcx,%rsi,4),%zmm0
 1884247:	62 f2 7d 48 26 c0    	vptestmb %zmm0,%zmm0,%k0
 188424d:	c4 61 fb 93 c0       	kmovq  %k0,%r8
 1884252:	f3 45 0f b8 d0       	popcnt %r8d,%r10d
 1884257:	45 89 c1             	mov    %r8d,%r9d
 188425a:	49 01 fa             	add    %rdi,%r10
 188425d:	48 c1 e7 20          	shl    $0x20,%rdi
 1884261:	4c 09 cf             	or     %r9,%rdi
 1884264:	48 89 7c 32 f8       	mov    %rdi,-0x8(%rdx,%rsi,1)
 1884269:	4c 89 d7             	mov    %r10,%rdi
 188426c:	4c 0f a4 c7 20       	shld   $0x20,%r8,%rdi
 1884271:	49 c1 e8 20          	shr    $0x20,%r8
 1884275:	48 89 3c 32          	mov    %rdi,(%rdx,%rsi,1)
 1884279:	f3 41 0f b8 f8       	popcnt %r8d,%edi
 188427e:	48 83 c6 10          	add    $0x10,%rsi
 1884282:	4c 01 d7             	add    %r10,%rdi
 1884285:	48 39 f0             	cmp    %rsi,%rax
 1884288:	75 b6                	jne    1884240 <tier0_benchmark_run+0x1620>
 188428a:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
 188428f:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
 1884294:	c1 e1 06             	shl    $0x6,%ecx
 1884297:	4c 8b 4c 24 10       	mov    0x10(%rsp),%r9
 188429c:	48 8b 7c 24 30       	mov    0x30(%rsp),%rdi
 18842a1:	4c 8b 94 24 a8 00 00 00 	mov    0xa8(%rsp),%r10
 18842a9:	31 f6                	xor    %esi,%esi
 18842ab:	48 01 c0             	add    %rax,%rax
 18842ae:	48 89 fa             	mov    %rdi,%rdx
 18842b1:	48 01 c1             	add    %rax,%rcx
 18842b4:	48 03 4c 24 40       	add    0x40(%rsp),%rcx
 18842b9:	49 8d 4c 09 40       	lea    0x40(%r9,%rcx,1),%rcx
 18842be:	66 90                	xchg   %ax,%ax
 18842c0:	41 89 d0             	mov    %edx,%r8d
 18842c3:	48 83 ea 10          	sub    $0x10,%rdx
 18842c7:	c5 e9 ef d2          	vpxor  %xmm2,%xmm2,%xmm2
 18842cb:	c5 e1 ef db          	vpxor  %xmm3,%xmm3,%xmm3
 18842cf:	c4 62 39 f7 c3       	shlx   %r8d,%ebx,%r8d
 18842d4:	41 f7 d0             	not    %r8d
 18842d7:	45 0f 43 c5          	cmovae %r13d,%r8d
 18842db:	c4 c1 7b 92 c8       	kmovd  %r8d,%k1
 18842e0:	41 c1 e8 08          	shr    $0x8,%r8d
 18842e4:	62 d1 7e c9 6f 04 b2 	vmovdqu32 (%r10,%rsi,4),%zmm0{%k1}{z}
 18842eb:	62 f1 75 48 72 d0 05 	vpsrld $0x5,%zmm0,%zmm1
 18842f2:	62 f1 7d 48 db c6    	vpandd %zmm6,%zmm0,%zmm0
 18842f8:	62 d2 fd 49 90 14 ce 	vpgatherdq (%r14,%ymm1,8),%zmm2{%k1}
 18842ff:	62 f3 fd 48 3b c9 01 	vextracti64x4 $0x1,%zmm1,%ymm1
 1884306:	c4 c1 7b 92 c8       	kmovd  %r8d,%k1
 188430b:	62 f2 45 48 47 c0    	vpsllvd %zmm0,%zmm7,%zmm0
 1884311:	62 d2 fd 49 90 1c ce 	vpgatherdq (%r14,%ymm1,8),%zmm3{%k1}
 1884318:	62 f1 fd 48 6f ca    	vmovdqa64 %zmm2,%zmm1
 188431e:	62 f2 5d 48 7e cb    	vpermt2d %zmm3,%zmm4,%zmm1
 1884324:	62 f2 55 48 7e d3    	vpermt2d %zmm3,%zmm5,%zmm2
 188432a:	62 f1 7d 48 df c1    	vpandnd %zmm1,%zmm0,%zmm0
 1884330:	62 f2 7d 48 55 c0    	vpopcntd %zmm0,%zmm0
 1884336:	62 f1 7d 48 fe c2    	vpaddd %zmm2,%zmm0,%zmm0
 188433c:	62 f1 fd 48 7f 04 b1 	vmovdqa64 %zmm0,(%rcx,%rsi,4)
 1884343:	48 83 c6 10          	add    $0x10,%rsi
 1884347:	48 39 fe             	cmp    %rdi,%rsi
 188434a:	0f 82 70 ff ff ff    	jb     18842c0 <tier0_benchmark_run+0x16a0>
 1884350:	4c 8b 44 24 70       	mov    0x70(%rsp),%r8
 1884355:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
 188435a:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
 188435f:	c1 e1 06             	shl    $0x6,%ecx
 1884362:	62 d1 fd 48 6f f1    	vmovdqa64 %zmm9,%zmm6
 1884368:	45 31 f6             	xor    %r14d,%r14d
 188436b:	62 d1 fd 48 6f fd    	vmovdqa64 %zmm13,%zmm7
 1884371:	62 51 fd 48 6f cf    	vmovdqa64 %zmm15,%zmm9
 1884377:	48 01 c8             	add    %rcx,%rax
 188437a:	4b 8d 14 40          	lea    (%r8,%r8,2),%rdx
 188437e:	49 01 c8             	add    %rcx,%r8
 1884381:	48 01 f0             	add    %rsi,%rax
 1884384:	49 01 f0             	add    %rsi,%r8
 1884387:	49 8d 5c 01 40       	lea    0x40(%r9,%rax,1),%rbx
 188438c:	b8 01 00 00 00       	mov    $0x1,%eax
 1884391:	48 01 ca             	add    %rcx,%rdx
 1884394:	4f 8d 6c 01 40       	lea    0x40(%r9,%r8,1),%r13
 1884399:	48 01 f2             	add    %rsi,%rdx
 188439c:	4d 8d 7c 11 40       	lea    0x40(%r9,%rdx,1),%r15
 18843a1:	48 8b 94 24 98 00 00 00 	mov    0x98(%rsp),%rdx
 18843a9:	48 01 ca             	add    %rcx,%rdx
 18843ac:	31 c9                	xor    %ecx,%ecx
 18843ae:	48 01 f2             	add    %rsi,%rdx
 18843b1:	4d 8d 64 11 40       	lea    0x40(%r9,%rdx,1),%r12
 18843b6:	66 2e 0f 1f 84 00 00 00 00 00 	cs nopw 0x0(%rax,%rax,1)
 18843c0:	83 f8 04             	cmp    $0x4,%eax
 18843c3:	89 84 24 90 00 00 00 	mov    %eax,0x90(%rsp)
 18843ca:	0f 92 c0             	setb   %al
 18843cd:	08 c8                	or     %cl,%al
 18843cf:	a8 01                	test   $0x1,%al
 18843d1:	74 1d                	je     18843f0 <tier0_benchmark_run+0x17d0>
 18843d3:	44 89 f0             	mov    %r14d,%eax
 18843d6:	48 8b 84 c4 a0 01 00 00 	mov    0x1a0(%rsp,%rax,8),%rax
 18843de:	41 83 f6 01          	xor    $0x1,%r14d
 18843e2:	e9 f9 00 00 00       	jmp    18844e0 <tier0_benchmark_run+0x18c0>
 18843e7:	66 0f 1f 84 00 00 00 00 00 	nopw   0x0(%rax,%rax,1)
 18843f0:	48 8d b4 24 68 01 00 00 	lea    0x168(%rsp),%rsi
 18843f8:	44 89 f2             	mov    %r14d,%edx
 18843fb:	c5 f8 77             	vzeroupper
 18843fe:	e8 5d d0 04 00       	call   18d1460 <branch_sizing_worklist>
 1884403:	44 89 f0             	mov    %r14d,%eax
 1884406:	83 f0 01             	xor    $0x1,%eax
 1884409:	48 8b 7c 24 30       	mov    0x30(%rsp),%rdi
 188440e:	c4 41 39 ef c0       	vpxor  %xmm8,%xmm8,%xmm8
 1884413:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 1884417:	31 c9                	xor    %ecx,%ecx
 1884419:	48 8b 84 c4 a0 01 00 00 	mov    0x1a0(%rsp,%rax,8),%rax
 1884421:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
 1884427:	66 0f 1f 84 00 00 00 00 00 	nopw   0x0(%rax,%rax,1)
 1884430:	62 d1 fd 48 6f 0c 8f 	vmovdqa64 (%r15,%rcx,4),%zmm1
 1884437:	62 d3 75 48 03 d0 0f 	valignd $0xf,%zmm8,%zmm1,%zmm2
 188443e:	62 f1 6d 48 fe c9    	vpaddd %zmm1,%zmm2,%zmm1
 1884444:	62 d3 f5 48 03 d0 07 	valignq $0x7,%zmm8,%zmm1,%zmm2
 188444b:	62 f1 6d 48 fe c9    	vpaddd %zmm1,%zmm2,%zmm1
 1884451:	62 d3 f5 48 03 d0 06 	valignq $0x6,%zmm8,%zmm1,%zmm2
 1884458:	62 f1 6d 48 fe c9    	vpaddd %zmm1,%zmm2,%zmm1
 188445e:	62 d3 f5 48 03 d0 04 	valignq $0x4,%zmm8,%zmm1,%zmm2
 1884465:	62 f1 75 48 fe c0    	vpaddd %zmm0,%zmm1,%zmm0
 188446b:	62 f1 7d 48 fe c2    	vpaddd %zmm2,%zmm0,%zmm0
 1884471:	62 f1 fe 48 7f 84 88 04 00 00 00 	vmovdqu64 %zmm0,0x4(%rax,%rcx,4)
 188447c:	62 f1 7d 48 70 c0 ff 	vpshufd $0xff,%zmm0,%zmm0
 1884483:	48 83 c1 10          	add    $0x10,%rcx
 1884487:	62 f3 fd 48 43 c0 ff 	vshufi64x2 $0xff,%zmm0,%zmm0,%zmm0
 188448e:	48 39 f9             	cmp    %rdi,%rcx
 1884491:	72 9d                	jb     1884430 <tier0_benchmark_run+0x1810>
 1884493:	62 f2 7d 48 58 35 37 c0 cf fe 	vpbroadcastd -0x1303fc9(%rip),%zmm6        # 5804d4 <tier0_emit_x87.operations+0x8c>
 188449d:	62 f1 fd 48 6f 3d 59 c3 c9 fe 	vmovdqa64 -0x1363ca7(%rip),%zmm7        # 520800 <branch_sizing_patterns+0xa70>
 18844a7:	62 e2 7d 48 5a 0d 4f 18 cf fe 	vbroadcasti32x4 -0x130e7b1(%rip),%zmm17        # 575d00 <x86_effects_unknown+0x2a0>
 18844b1:	62 72 7d 48 5a 25 65 18 cf fe 	vbroadcasti32x4 -0x130e79b(%rip),%zmm12        # 575d20 <x86_effects_unknown+0x2c0>
 18844bb:	62 72 7d 48 5a 0d 4b 18 cf fe 	vbroadcasti32x4 -0x130e7b5(%rip),%zmm9        # 575d10 <x86_effects_unknown+0x2b0>
 18844c5:	62 72 7d 48 58 15 61 c0 cf fe 	vpbroadcastd -0x1303f9f(%rip),%zmm10        # 580530 <tier0_emit_x87.operations+0xe8>
 18844cf:	62 72 7d 48 58 1d 5b c0 cf fe 	vpbroadcastd -0x1303fa5(%rip),%zmm11        # 580534 <tier0_emit_x87.operations+0xec>
 18844d9:	4c 8b 5c 24 60       	mov    0x60(%rsp),%r11
 18844de:	b1 01                	mov    $0x1,%cl
 18844e0:	44 89 f2             	mov    %r14d,%edx
 18844e3:	4c 8b 84 d4 a0 01 00 00 	mov    0x1a0(%rsp,%rdx,8),%r8
 18844eb:	45 89 f2             	mov    %r14d,%r10d
 18844ee:	31 d2                	xor    %edx,%edx
 18844f0:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 18844f4:	31 f6                	xor    %esi,%esi
 18844f6:	41 c7 00 00 00 00 00 	movl   $0x0,(%r8)
 18844fd:	0f 1f 00             	nopl   (%rax)
 1884500:	62 f1 fd 48 6f 0c 93 	vmovdqa64 (%rbx,%rdx,4),%zmm1
 1884507:	c5 fc 46 c8          	kxnorw %k0,%k0,%k1
 188450b:	c5 e1 ef db          	vpxor  %xmm3,%xmm3,%xmm3
 188450f:	62 d1 fd 48 6f 14 97 	vmovdqa64 (%r15,%rdx,4),%zmm2
 1884516:	4d 89 c1             	mov    %r8,%r9
 1884519:	62 f2 7d 49 90 1c 88 	vpgatherdd (%rax,%zmm1,4),%zmm3{%k1}
 1884520:	62 f1 65 48 fa 8c 90 04 00 00 00 	vpsubd 0x4(%rax,%rdx,4),%zmm3,%zmm1
 188452b:	62 f2 6d 48 27 c2    	vptestmd %zmm2,%zmm2,%k0
 1884531:	62 d1 75 48 fe 4c 95 00 	vpaddd 0x0(%r13,%rdx,4),%zmm1,%zmm1
 1884539:	62 d1 75 48 fe da    	vpaddd %zmm10,%zmm1,%zmm3
 188453f:	62 d3 65 48 1e cb 01 	vpcmpltud %zmm11,%zmm3,%k1
 1884546:	c5 fc 45 c9          	korw   %k1,%k0,%k1
 188454a:	62 d1 7d c9 6f 1c 93 	vmovdqa32 (%r11,%rdx,4),%zmm3{%k1}{z}
 1884551:	62 d3 65 48 03 e0 0f 	valignd $0xf,%zmm8,%zmm3,%zmm4
 1884558:	62 f3 65 48 1f c2 04 	vpcmpneqd %zmm2,%zmm3,%k0
 188455f:	62 d1 fd 48 7f 1c 97 	vmovdqa64 %zmm3,(%r15,%rdx,4)
 1884566:	62 d1 fd 48 7f 0c 94 	vmovdqa64 %zmm1,(%r12,%rdx,4)
 188456d:	c5 78 93 c0          	kmovw  %k0,%r8d
 1884571:	62 f1 5d 48 fe e3    	vpaddd %zmm3,%zmm4,%zmm4
 1884577:	44 09 c6             	or     %r8d,%esi
 188457a:	4d 89 c8             	mov    %r9,%r8
 188457d:	62 d3 dd 48 03 e8 07 	valignq $0x7,%zmm8,%zmm4,%zmm5
 1884584:	62 f1 55 48 fe e4    	vpaddd %zmm4,%zmm5,%zmm4
 188458a:	62 d3 dd 48 03 e8 06 	valignq $0x6,%zmm8,%zmm4,%zmm5
 1884591:	62 f1 55 48 fe e4    	vpaddd %zmm4,%zmm5,%zmm4
 1884597:	62 d3 dd 48 03 e8 04 	valignq $0x4,%zmm8,%zmm4,%zmm5
 188459e:	62 f1 5d 48 fe c0    	vpaddd %zmm0,%zmm4,%zmm0
 18845a4:	62 f1 7d 48 fe c5    	vpaddd %zmm5,%zmm0,%zmm0
 18845aa:	62 d1 fe 48 7f 84 91 04 00 00 00 	vmovdqu64 %zmm0,0x4(%r9,%rdx,4)
 18845b5:	62 f1 7d 48 70 c0 ff 	vpshufd $0xff,%zmm0,%zmm0
 18845bc:	48 83 c2 10          	add    $0x10,%rdx
 18845c0:	62 f3 fd 48 43 c0 ff 	vshufi64x2 $0xff,%zmm0,%zmm0,%zmm0
 18845c7:	48 39 fa             	cmp    %rdi,%rdx
 18845ca:	0f 82 30 ff ff ff    	jb     1884500 <tier0_benchmark_run+0x18e0>
 18845d0:	8b 84 24 90 00 00 00 	mov    0x90(%rsp),%eax
 18845d7:	45 89 d6             	mov    %r10d,%r14d
 18845da:	ff c0                	inc    %eax
 18845dc:	85 f6                	test   %esi,%esi
 18845de:	0f 85 dc fd ff ff    	jne    18843c0 <tier0_benchmark_run+0x17a0>
 18845e4:	4c 8b 74 24 78       	mov    0x78(%rsp),%r14
 18845e9:	4c 8b a4 24 b0 00 00 00 	mov    0xb0(%rsp),%r12
 18845f1:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
 18845f6:	41 bd ff ff 00 00    	mov    $0xffff,%r13d
 18845fc:	45 31 ff             	xor    %r15d,%r15d
 18845ff:	62 f1 fd 48 6f 15 f7 c3 c9 fe 	vmovdqa64 -0x1363c09(%rip),%zmm2        # 520a00 <branch_sizing_patterns+0xc70>
 1884609:	31 c0                	xor    %eax,%eax
 188460b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
 1884610:	62 d1 fd 48 6f 04 84 	vmovdqa64 (%r12,%rax,4),%zmm0
 1884617:	48 89 c1             	mov    %rax,%rcx
 188461a:	62 f2 7d 48 27 c0    	vptestmd %zmm0,%zmm0,%k0
 1884620:	c5 fb 93 c0          	kmovd  %k0,%eax
 1884624:	0d 00 00 01 00       	or     $0x10000,%eax
 1884629:	f3 0f bc c0          	tzcnt  %eax,%eax
 188462d:	48 01 c8             	add    %rcx,%rax
 1884630:	c5 f8 98 c0          	kortestw %k0,%k0
 1884634:	75 05                	jne    188463b <tier0_benchmark_run+0x1a1b>
 1884636:	48 39 f8             	cmp    %rdi,%rax
 1884639:	72 d5                	jb     1884610 <tier0_benchmark_run+0x19f0>
 188463b:	4c 8b 5c 24 18       	mov    0x18(%rsp),%r11
 1884640:	48 39 f8             	cmp    %rdi,%rax
 1884643:	0f 83 a6 00 00 00    	jae    18846ef <tier0_benchmark_run+0x1acf>
 1884649:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
 188464e:	8b 04 81             	mov    (%rcx,%rax,4),%eax
 1884651:	83 e0 e0             	and    $0xffffffe0,%eax
 1884654:	41 39 c3             	cmp    %eax,%r11d
 1884657:	0f 86 92 00 00 00    	jbe    18846ef <tier0_benchmark_run+0x1acf>
 188465d:	4c 89 d9             	mov    %r11,%rcx
 1884660:	48 29 c1             	sub    %rax,%rcx
 1884663:	4d 89 c4             	mov    %r8,%r12
 1884666:	66 2e 0f 1f 84 00 00 00 00 00 	cs nopw 0x0(%rax,%rax,1)
 1884670:	89 ca                	mov    %ecx,%edx
 1884672:	48 83 e9 10          	sub    $0x10,%rcx
 1884676:	48 89 c6             	mov    %rax,%rsi
 1884679:	89 c7                	mov    %eax,%edi
 188467b:	41 89 c0             	mov    %eax,%r8d
 188467e:	c4 e2 69 f7 d3       	shlx   %edx,%ebx,%edx
 1884683:	f7 d2                	not    %edx
 1884685:	41 0f 43 d5          	cmovae %r13d,%edx
 1884689:	48 c1 ee 05          	shr    $0x5,%rsi
 188468d:	40 80 e7 10          	and    $0x10,%dil
 1884691:	41 83 e0 10          	and    $0x10,%r8d
 1884695:	49 8b 34 f6          	mov    (%r14,%rsi,8),%rsi
 1884699:	c5 fb 92 ca          	kmovd  %edx,%k1
 188469d:	c4 e2 c3 f7 fe       	shrx   %rdi,%rsi,%rdi
 18846a2:	c4 62 38 f5 c6       	bzhi   %r8d,%esi,%r8d
 18846a7:	48 c1 ee 20          	shr    $0x20,%rsi
 18846ab:	62 f2 7d 48 7c c7    	vpbroadcastd %edi,%zmm0
 18846b1:	48 8b 7c 24 58       	mov    0x58(%rsp),%rdi
 18846b6:	49 8d 34 b4          	lea    (%r12,%rsi,4),%rsi
 18846ba:	f3 45 0f b8 c0       	popcnt %r8d,%r8d
 18846bf:	62 f1 7d 48 db c2    	vpandd %zmm2,%zmm0,%zmm0
 18846c5:	62 f2 7d 48 55 c0    	vpopcntd %zmm0,%zmm0
 18846cb:	62 b2 7d 48 36 04 86 	vpermd (%rsi,%r8,4),%zmm0,%zmm0
 18846d2:	62 f1 7e c9 6f 0c 87 	vmovdqu32 (%rdi,%rax,4),%zmm1{%k1}{z}
 18846d9:	62 f1 75 48 fe c0    	vpaddd %zmm0,%zmm1,%zmm0
 18846df:	62 f1 7e 49 7f 04 87 	vmovdqu32 %zmm0,(%rdi,%rax,4){%k1}
 18846e6:	48 83 c0 10          	add    $0x10,%rax
 18846ea:	4c 39 d8             	cmp    %r11,%rax
 18846ed:	72 81                	jb     1884670 <tier0_benchmark_run+0x1a50>
 18846ef:	4c 8b 6c 24 30       	mov    0x30(%rsp),%r13
 18846f4:	44 89 e8             	mov    %r13d,%eax
 18846f7:	83 e0 07             	and    $0x7,%eax
 18846fa:	41 83 fd 08          	cmp    $0x8,%r13d
 18846fe:	73 1b                	jae    188471b <tier0_benchmark_run+0x1afb>
 1884700:	4c 8b 74 24 48       	mov    0x48(%rsp),%r14
 1884705:	48 8b 5c 24 50       	mov    0x50(%rsp),%rbx
 188470a:	4c 8b 4c 24 10       	mov    0x10(%rsp),%r9
 188470f:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
 1884714:	31 c9                	xor    %ecx,%ecx
 1884716:	e9 7d 01 00 00       	jmp    1884898 <tier0_benchmark_run+0x1c78>
 188471b:	48 8b 94 24 b8 00 00 00 	mov    0xb8(%rsp),%rdx
 1884723:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
 1884728:	c1 e1 06             	shl    $0x6,%ecx
 188472b:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
 1884730:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
 1884735:	4c 8b 74 24 48       	mov    0x48(%rsp),%r14
 188473a:	48 8b 5c 24 50       	mov    0x50(%rsp),%rbx
 188473f:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
 1884744:	41 83 e5 f8          	and    $0xfffffff8,%r13d
 1884748:	48 01 ca             	add    %rcx,%rdx
 188474b:	48 03 8c 24 98 00 00 00 	add    0x98(%rsp),%rcx
 1884753:	48 01 f2             	add    %rsi,%rdx
 1884756:	48 8d 54 17 5c       	lea    0x5c(%rdi,%rdx,1),%rdx
 188475b:	48 01 f1             	add    %rsi,%rcx
 188475e:	48 8d 74 0f 5c       	lea    0x5c(%rdi,%rcx,1),%rsi
 1884763:	31 c9                	xor    %ecx,%ecx
 1884765:	66 66 2e 0f 1f 84 00 00 00 00 00 	data16 cs nopw 0x0(%rax,%rax,1)
 1884770:	41 8b 3c 8a          	mov    (%r10,%rcx,4),%edi
 1884774:	44 8b 44 8a e4       	mov    -0x1c(%rdx,%rcx,4),%r8d
 1884779:	44 8b 4c 8e e4       	mov    -0x1c(%rsi,%rcx,4),%r9d
 188477e:	48 c1 e7 04          	shl    $0x4,%rdi
 1884782:	41 83 f8 01          	cmp    $0x1,%r8d
 1884786:	44 89 4c 3b 04       	mov    %r9d,0x4(%rbx,%rdi,1)
 188478b:	66 83 5c 3b 0c ff    	sbbw   $0xffff,0xc(%rbx,%rdi,1)
 1884791:	41 8b 7c 8a 04       	mov    0x4(%r10,%rcx,4),%edi
 1884796:	44 8b 44 8a e8       	mov    -0x18(%rdx,%rcx,4),%r8d
 188479b:	44 8b 4c 8e e8       	mov    -0x18(%rsi,%rcx,4),%r9d
 18847a0:	48 c1 e7 04          	shl    $0x4,%rdi
 18847a4:	41 83 f8 01          	cmp    $0x1,%r8d
 18847a8:	44 89 4c 3b 04       	mov    %r9d,0x4(%rbx,%rdi,1)
 18847ad:	66 83 5c 3b 0c ff    	sbbw   $0xffff,0xc(%rbx,%rdi,1)
 18847b3:	41 8b 7c 8a 08       	mov    0x8(%r10,%rcx,4),%edi
 18847b8:	44 8b 44 8a ec       	mov    -0x14(%rdx,%rcx,4),%r8d
 18847bd:	44 8b 4c 8e ec       	mov    -0x14(%rsi,%rcx,4),%r9d
 18847c2:	48 c1 e7 04          	shl    $0x4,%rdi
 18847c6:	41 83 f8 01          	cmp    $0x1,%r8d
 18847ca:	44 89 4c 3b 04       	mov    %r9d,0x4(%rbx,%rdi,1)
 18847cf:	66 83 5c 3b 0c ff    	sbbw   $0xffff,0xc(%rbx,%rdi,1)
 18847d5:	41 8b 7c 8a 0c       	mov    0xc(%r10,%rcx,4),%edi
 18847da:	44 8b 44 8a f0       	mov    -0x10(%rdx,%rcx,4),%r8d
 18847df:	44 8b 4c 8e f0       	mov    -0x10(%rsi,%rcx,4),%r9d
 18847e4:	48 c1 e7 04          	shl    $0x4,%rdi
 18847e8:	41 83 f8 01          	cmp    $0x1,%r8d
 18847ec:	44 89 4c 3b 04       	mov    %r9d,0x4(%rbx,%rdi,1)
 18847f1:	66 83 5c 3b 0c ff    	sbbw   $0xffff,0xc(%rbx,%rdi,1)
 18847f7:	41 8b 7c 8a 10       	mov    0x10(%r10,%rcx,4),%edi
 18847fc:	44 8b 44 8a f4       	mov    -0xc(%rdx,%rcx,4),%r8d
 1884801:	44 8b 4c 8e f4       	mov    -0xc(%rsi,%rcx,4),%r9d
 1884806:	48 c1 e7 04          	shl    $0x4,%rdi
 188480a:	41 83 f8 01          	cmp    $0x1,%r8d
 188480e:	44 89 4c 3b 04       	mov    %r9d,0x4(%rbx,%rdi,1)
 1884813:	66 83 5c 3b 0c ff    	sbbw   $0xffff,0xc(%rbx,%rdi,1)
 1884819:	41 8b 7c 8a 14       	mov    0x14(%r10,%rcx,4),%edi
 188481e:	44 8b 44 8a f8       	mov    -0x8(%rdx,%rcx,4),%r8d
 1884823:	44 8b 4c 8e f8       	mov    -0x8(%rsi,%rcx,4),%r9d
 1884828:	48 c1 e7 04          	shl    $0x4,%rdi
 188482c:	41 83 f8 01          	cmp    $0x1,%r8d
 1884830:	44 89 4c 3b 04       	mov    %r9d,0x4(%rbx,%rdi,1)
 1884835:	66 83 5c 3b 0c ff    	sbbw   $0xffff,0xc(%rbx,%rdi,1)
 188483b:	41 8b 7c 8a 18       	mov    0x18(%r10,%rcx,4),%edi
 1884840:	44 8b 44 8a fc       	mov    -0x4(%rdx,%rcx,4),%r8d
 1884845:	44 8b 4c 8e fc       	mov    -0x4(%rsi,%rcx,4),%r9d
 188484a:	48 c1 e7 04          	shl    $0x4,%rdi
 188484e:	41 83 f8 01          	cmp    $0x1,%r8d
 1884852:	44 89 4c 3b 04       	mov    %r9d,0x4(%rbx,%rdi,1)
 1884857:	66 83 5c 3b 0c ff    	sbbw   $0xffff,0xc(%rbx,%rdi,1)
 188485d:	41 8b 7c 8a 1c       	mov    0x1c(%r10,%rcx,4),%edi
 1884862:	44 8b 04 8a          	mov    (%rdx,%rcx,4),%r8d
 1884866:	44 8b 0c 8e          	mov    (%rsi,%rcx,4),%r9d
 188486a:	48 c1 e7 04          	shl    $0x4,%rdi
 188486e:	41 83 f8 01          	cmp    $0x1,%r8d
 1884872:	44 89 4c 3b 04       	mov    %r9d,0x4(%rbx,%rdi,1)
 1884877:	66 83 5c 3b 0c ff    	sbbw   $0xffff,0xc(%rbx,%rdi,1)
 188487d:	48 83 c1 08          	add    $0x8,%rcx
 1884881:	49 39 cd             	cmp    %rcx,%r13
 1884884:	0f 85 e6 fe ff ff    	jne    1884770 <tier0_benchmark_run+0x1b50>
 188488a:	4c 8b 4c 24 10       	mov    0x10(%rsp),%r9
 188488f:	48 85 c0             	test   %rax,%rax
 1884892:	0f 84 c8 e5 ff ff    	je     1882e60 <tier0_benchmark_run+0x240>
 1884898:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
 188489d:	4c 8b 84 24 98 00 00 00 	mov    0x98(%rsp),%r8
 18848a5:	4c 8b 9c 24 b8 00 00 00 	mov    0xb8(%rsp),%r11
 18848ad:	48 8b 7c 24 40       	mov    0x40(%rsp),%rdi
 18848b2:	c1 e0 02             	shl    $0x2,%eax
 18848b5:	c1 e6 06             	shl    $0x6,%esi
 18848b8:	49 01 f0             	add    %rsi,%r8
 18848bb:	49 01 f3             	add    %rsi,%r11
 18848be:	49 01 f8             	add    %rdi,%r8
 18848c1:	49 01 fb             	add    %rdi,%r11
 18848c4:	31 ff                	xor    %edi,%edi
 18848c6:	49 8d 14 88          	lea    (%r8,%rcx,4),%rdx
 18848ca:	49 8d 34 8b          	lea    (%r11,%rcx,4),%rsi
 18848ce:	49 8d 0c 8a          	lea    (%r10,%rcx,4),%rcx
 18848d2:	49 8d 54 11 40       	lea    0x40(%r9,%rdx,1),%rdx
 18848d7:	49 8d 74 31 40       	lea    0x40(%r9,%rsi,1),%rsi
 18848dc:	0f 1f 40 00          	nopl   0x0(%rax)
 18848e0:	44 8b 04 39          	mov    (%rcx,%rdi,1),%r8d
 18848e4:	44 8b 0c 3e          	mov    (%rsi,%rdi,1),%r9d
 18848e8:	44 8b 14 3a          	mov    (%rdx,%rdi,1),%r10d
 18848ec:	49 c1 e0 04          	shl    $0x4,%r8
 18848f0:	41 83 f9 01          	cmp    $0x1,%r9d
 18848f4:	46 89 54 03 04       	mov    %r10d,0x4(%rbx,%r8,1)
 18848f9:	66 42 83 5c 03 0c ff 	sbbw   $0xffff,0xc(%rbx,%r8,1)
 1884900:	48 83 c7 04          	add    $0x4,%rdi
 1884904:	48 39 f8             	cmp    %rdi,%rax
 1884907:	75 d7                	jne    18848e0 <tier0_benchmark_run+0x1cc0>
 1884909:	e9 52 e5 ff ff       	jmp    1882e60 <tier0_benchmark_run+0x240>
 188490e:	45 31 ff             	xor    %r15d,%r15d
 1884911:	31 db                	xor    %ebx,%ebx
 1884913:	45 31 f6             	xor    %r14d,%r14d
 1884916:	eb 4a                	jmp    1884962 <tier0_benchmark_run+0x1d42>
 1884918:	0f 1f 84 00 00 00 00 00 	nopl   0x0(%rax,%rax,1)
 1884920:	49 8b 4d 20          	mov    0x20(%r13),%rcx
 1884924:	49 8b 55 28          	mov    0x28(%r13),%rdx
 1884928:	49 8b 45 10          	mov    0x10(%r13),%rax
 188492c:	4a 8b 0c f1          	mov    (%rcx,%r14,8),%rcx
 1884930:	4a 8b 14 f2          	mov    (%rdx,%r14,8),%rdx
 1884934:	4a 8b 3c f0          	mov    (%rax,%r14,8),%rdi
 1884938:	e8 03 d2 04 00       	call   18d1b40 <x86_encode_16>
 188493d:	48 89 c1             	mov    %rax,%rcx
 1884940:	48 c1 f9 3f          	sar    $0x3f,%rcx
 1884944:	c4 e2 f0 f2 c8       	andn   %rax,%rcx,%rcx
 1884949:	41 8b 45 30          	mov    0x30(%r13),%eax
 188494d:	49 01 cf             	add    %rcx,%r15
 1884950:	49 ff c6             	inc    %r14
 1884953:	48 83 c3 68          	add    $0x68,%rbx
 1884957:	89 c1                	mov    %eax,%ecx
 1884959:	49 39 ce             	cmp    %rcx,%r14
 188495c:	0f 83 13 e4 ff ff    	jae    1882d75 <tier0_benchmark_run+0x155>
 1884962:	49 8b 4d 08          	mov    0x8(%r13),%rcx
 1884966:	8b 74 19 08          	mov    0x8(%rcx,%rbx,1),%esi
 188496a:	48 81 fe 11 11 11 11 	cmp    $0x11111111,%rsi
 1884971:	76 ad                	jbe    1884920 <tier0_benchmark_run+0x1d00>
 1884973:	31 c9                	xor    %ecx,%ecx
 1884975:	eb d6                	jmp    188494d <tier0_benchmark_run+0x1d2d>
 1884977:	48 8d 3d 79 b6 e4 fe 	lea    -0x11b4987(%rip),%rdi        # 6cfff7 <pp_string_value.meaning+0x72dab>
 188497e:	48 8d 35 0e 2e e0 fe 	lea    -0x11fd1f2(%rip),%rsi        # 687793 <pp_string_value.meaning+0x2a547>
 1884985:	48 8d 0d 22 2e e0 fe 	lea    -0x11fd1de(%rip),%rcx        # 6877ae <pp_string_value.meaning+0x2a562>
 188498c:	ba bf 00 00 00       	mov    $0xbf,%edx
 1884991:	c5 f8 77             	vzeroupper
 1884994:	e8 b7 f1 ed fe       	call   763b50 <__assert_fail@plt>
 1884999:	c5 f8 77             	vzeroupper
 188499c:	e8 3f f1 ed fe       	call   763ae0 <__stack_chk_fail@plt>
