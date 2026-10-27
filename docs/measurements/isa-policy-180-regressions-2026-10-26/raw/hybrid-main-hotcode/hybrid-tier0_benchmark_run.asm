
/home/david/buster-fast-bench/codex-180-fix-20261027-hybrid/build/compiler:     file format elf64-x86-64


Disassembly of section .text:

00000000018b77b0 <tier0_benchmark_run>:
 18b77b0:	55                   	push   %rbp
 18b77b1:	48 89 e5             	mov    %rsp,%rbp
 18b77b4:	41 57                	push   %r15
 18b77b6:	41 56                	push   %r14
 18b77b8:	41 55                	push   %r13
 18b77ba:	41 54                	push   %r12
 18b77bc:	53                   	push   %rbx
 18b77bd:	48 83 e4 c0          	and    $0xffffffffffffffc0,%rsp
 18b77c1:	48 81 ec 00 03 00 00 	sub    $0x300,%rsp
 18b77c8:	44 89 4c 24 6c       	mov    %r9d,0x6c(%rsp)
 18b77cd:	4c 89 84 24 d0 00 00 00 	mov    %r8,0xd0(%rsp)
 18b77d5:	48 89 bc 24 38 01 00 00 	mov    %rdi,0x138(%rsp)
 18b77dd:	49 89 cf             	mov    %rcx,%r15
 18b77e0:	49 89 d5             	mov    %rdx,%r13
 18b77e3:	41 89 f4             	mov    %esi,%r12d
 18b77e6:	64 48 8b 04 25 28 00 00 00 	mov    %fs:0x28,%rax
 18b77ef:	48 89 84 24 c0 02 00 00 	mov    %rax,0x2c0(%rsp)
 18b77f7:	83 fe 02             	cmp    $0x2,%esi
 18b77fa:	75 41                	jne    18b783d <tier0_benchmark_run+0x8d>
 18b77fc:	41 83 7d 30 00       	cmpl   $0x0,0x30(%r13)
 18b7801:	74 3a                	je     18b783d <tier0_benchmark_run+0x8d>
 18b7803:	31 db                	xor    %ebx,%ebx
 18b7805:	45 31 f6             	xor    %r14d,%r14d
 18b7808:	0f 1f 84 00 00 00 00 00 	nopl   0x0(%rax,%rax,1)
 18b7810:	49 8b 45 08          	mov    0x8(%r13),%rax
 18b7814:	49 8b 4d 10          	mov    0x10(%r13),%rcx
 18b7818:	8b 54 18 08          	mov    0x8(%rax,%rbx,1),%edx
 18b781c:	4a 8b 3c f1          	mov    (%rcx,%r14,8),%rdi
 18b7820:	48 8b 34 18          	mov    (%rax,%rbx,1),%rsi
 18b7824:	48 c1 e2 04          	shl    $0x4,%rdx
 18b7828:	e8 23 cc ea fe       	call   764450 <memcpy@plt>
 18b782d:	41 8b 45 30          	mov    0x30(%r13),%eax
 18b7831:	49 ff c6             	inc    %r14
 18b7834:	48 83 c3 68          	add    $0x68,%rbx
 18b7838:	49 39 c6             	cmp    %rax,%r14
 18b783b:	72 d3                	jb     18b7810 <tier0_benchmark_run+0x60>
 18b783d:	48 8b b4 24 d0 00 00 00 	mov    0xd0(%rsp),%rsi
 18b7845:	8b 54 24 6c          	mov    0x6c(%rsp),%edx
 18b7849:	48 8d bc 24 48 01 00 00 	lea    0x148(%rsp),%rdi
 18b7851:	e8 7a e6 04 00       	call   1905ed0 <tier0_benchmark_read>
 18b7856:	41 8b 45 30          	mov    0x30(%r13),%eax
 18b785a:	85 c0                	test   %eax,%eax
 18b785c:	0f 84 a0 00 00 00    	je     18b7902 <tier0_benchmark_run+0x152>
 18b7862:	49 8b 5f 08          	mov    0x8(%r15),%rbx
 18b7866:	44 89 64 24 3c       	mov    %r12d,0x3c(%rsp)
 18b786b:	45 85 e4             	test   %r12d,%r12d
 18b786e:	74 4f                	je     18b78bf <tier0_benchmark_run+0x10f>
 18b7870:	41 83 fc 01          	cmp    $0x1,%r12d
 18b7874:	0f 85 fc 00 00 00    	jne    18b7976 <tier0_benchmark_run+0x1c6>
 18b787a:	4c 8d a4 24 c0 01 00 00 	lea    0x1c0(%rsp),%r12
 18b7882:	45 31 f6             	xor    %r14d,%r14d
 18b7885:	66 66 2e 0f 1f 84 00 00 00 00 00 	data16 cs nopw 0x0(%rax,%rax,1)
 18b7890:	49 8b 45 00          	mov    0x0(%r13),%rax
 18b7894:	4c 89 e7             	mov    %r12,%rdi
 18b7897:	4c 89 fa             	mov    %r15,%rdx
 18b789a:	4a 8b 34 f0          	mov    (%rax,%r14,8),%rsi
 18b789e:	e8 3d 18 01 00       	call   18c90e0 <tier0_compile_scalar>
 18b78a3:	49 3b 5f 08          	cmp    0x8(%r15),%rbx
 18b78a7:	0f 87 5a 1c 00 00    	ja     18b9507 <tier0_benchmark_run+0x1d57>
 18b78ad:	49 89 5f 08          	mov    %rbx,0x8(%r15)
 18b78b1:	49 ff c6             	inc    %r14
 18b78b4:	41 8b 45 30          	mov    0x30(%r13),%eax
 18b78b8:	49 39 c6             	cmp    %rax,%r14
 18b78bb:	72 d3                	jb     18b7890 <tier0_benchmark_run+0xe0>
 18b78bd:	eb 3e                	jmp    18b78fd <tier0_benchmark_run+0x14d>
 18b78bf:	4c 8d a4 24 c0 01 00 00 	lea    0x1c0(%rsp),%r12
 18b78c7:	45 31 f6             	xor    %r14d,%r14d
 18b78ca:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
 18b78d0:	49 8b 45 00          	mov    0x0(%r13),%rax
 18b78d4:	4c 89 e7             	mov    %r12,%rdi
 18b78d7:	4c 89 fa             	mov    %r15,%rdx
 18b78da:	4a 8b 34 f0          	mov    (%rax,%r14,8),%rsi
 18b78de:	e8 1d 27 01 00       	call   18ca000 <tier0_compile>
 18b78e3:	49 3b 5f 08          	cmp    0x8(%r15),%rbx
 18b78e7:	0f 87 1a 1c 00 00    	ja     18b9507 <tier0_benchmark_run+0x1d57>
 18b78ed:	49 89 5f 08          	mov    %rbx,0x8(%r15)
 18b78f1:	49 ff c6             	inc    %r14
 18b78f4:	41 8b 45 30          	mov    0x30(%r13),%eax
 18b78f8:	49 39 c6             	cmp    %rax,%r14
 18b78fb:	72 d3                	jb     18b78d0 <tier0_benchmark_run+0x120>
 18b78fd:	44 8b 64 24 3c       	mov    0x3c(%rsp),%r12d
 18b7902:	45 31 ff             	xor    %r15d,%r15d
 18b7905:	48 8b b4 24 d0 00 00 00 	mov    0xd0(%rsp),%rsi
 18b790d:	8b 54 24 6c          	mov    0x6c(%rsp),%edx
 18b7911:	48 8d bc 24 c0 01 00 00 	lea    0x1c0(%rsp),%rdi
 18b7919:	c5 f8 77             	vzeroupper
 18b791c:	e8 af e5 04 00       	call   1905ed0 <tier0_benchmark_read>
 18b7921:	c5 fe 6f 84 24 c0 01 00 00 	vmovdqu 0x1c0(%rsp),%ymm0
 18b792a:	48 8b 84 24 38 01 00 00 	mov    0x138(%rsp),%rax
 18b7932:	c5 fd fb 84 24 48 01 00 00 	vpsubq 0x148(%rsp),%ymm0,%ymm0
 18b793b:	c5 fe 7f 00          	vmovdqu %ymm0,(%rax)
 18b793f:	41 83 fc 03          	cmp    $0x3,%r12d
 18b7943:	74 04                	je     18b7949 <tier0_benchmark_run+0x199>
 18b7945:	4d 8b 7d 50          	mov    0x50(%r13),%r15
 18b7949:	4d 89 7d 50          	mov    %r15,0x50(%r13)
 18b794d:	64 48 8b 04 25 28 00 00 00 	mov    %fs:0x28,%rax
 18b7956:	48 3b 84 24 c0 02 00 00 	cmp    0x2c0(%rsp),%rax
 18b795e:	0f 85 c5 1b 00 00    	jne    18b9529 <tier0_benchmark_run+0x1d79>
 18b7964:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
 18b7968:	5b                   	pop    %rbx
 18b7969:	41 5c                	pop    %r12
 18b796b:	41 5d                	pop    %r13
 18b796d:	41 5e                	pop    %r14
 18b796f:	41 5f                	pop    %r15
 18b7971:	5d                   	pop    %rbp
 18b7972:	c5 f8 77             	vzeroupper
 18b7975:	c3                   	ret
 18b7976:	41 83 fc 02          	cmp    $0x2,%r12d
 18b797a:	0f 85 1e 1b 00 00    	jne    18b949e <tier0_benchmark_run+0x1cee>
 18b7980:	62 f2 7d 48 58 35 4a 8b cc fe 	vpbroadcastd -0x13374b6(%rip),%zmm6        # 5804d4 <tier0_emit_x87.operations+0x8c>
 18b798a:	62 f1 fd 48 6f 3d 6c 8e c6 fe 	vmovdqa64 -0x1397194(%rip),%zmm7        # 520800 <branch_sizing_patterns+0xa70>
 18b7994:	62 e2 7d 48 5a 0d 62 e3 cb fe 	vbroadcasti32x4 -0x1341c9e(%rip),%zmm17        # 575d00 <x86_effects_unknown+0x2a0>
 18b799e:	62 72 7d 48 5a 0d 68 e3 cb fe 	vbroadcasti32x4 -0x1341c98(%rip),%zmm9        # 575d10 <x86_effects_unknown+0x2b0>
 18b79a8:	62 72 7d 48 58 15 7e 8b cc fe 	vpbroadcastd -0x1337482(%rip),%zmm10        # 580530 <tier0_emit_x87.operations+0xe8>
 18b79b2:	62 72 7d 48 58 1d 78 8b cc fe 	vpbroadcastd -0x1337488(%rip),%zmm11        # 580534 <tier0_emit_x87.operations+0xec>
 18b79bc:	48 b9 00 00 20 00 10 00 00 00 	movabs $0x1000200000,%rcx
 18b79c6:	45 31 ff             	xor    %r15d,%r15d
 18b79c9:	c4 41 39 ef c0       	vpxor  %xmm8,%xmm8,%xmm8
 18b79ce:	45 31 f6             	xor    %r14d,%r14d
 18b79d1:	4c 89 ac 24 30 01 00 00 	mov    %r13,0x130(%rsp)
 18b79d9:	48 81 c1 00 00 e0 ff 	add    $0xffffffffffe00000,%rcx
 18b79e0:	48 89 8c 24 f0 00 00 00 	mov    %rcx,0xf0(%rsp)
 18b79e8:	eb 45                	jmp    18b7a2f <tier0_benchmark_run+0x27f>
 18b79ea:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
 18b79f0:	48 8b 84 24 40 01 00 00 	mov    0x140(%rsp),%rax
 18b79f8:	64 48 3b 04 25 18 ff ff ff 	cmp    %fs:0xffffffffffffff18,%rax
 18b7a01:	0f 87 00 1b 00 00    	ja     18b9507 <tier0_benchmark_run+0x1d57>
 18b7a07:	4c 8b ac 24 30 01 00 00 	mov    0x130(%rsp),%r13
 18b7a0f:	64 48 89 04 25 18 ff ff ff 	mov    %rax,%fs:0xffffffffffffff18
 18b7a18:	44 8b 64 24 3c       	mov    0x3c(%rsp),%r12d
 18b7a1d:	41 8b 45 30          	mov    0x30(%r13),%eax
 18b7a21:	49 ff c6             	inc    %r14
 18b7a24:	89 c1                	mov    %eax,%ecx
 18b7a26:	49 39 ce             	cmp    %rcx,%r14
 18b7a29:	0f 83 d6 fe ff ff    	jae    18b7905 <tier0_benchmark_run+0x155>
 18b7a2f:	49 8b 55 08          	mov    0x8(%r13),%rdx
 18b7a33:	49 6b ce 68          	imul   $0x68,%r14,%rcx
 18b7a37:	44 8b 4c 0a 08       	mov    0x8(%rdx,%rcx,1),%r9d
 18b7a3c:	49 81 f9 11 11 11 11 	cmp    $0x11111111,%r9
 18b7a43:	77 dc                	ja     18b7a21 <tier0_benchmark_run+0x271>
 18b7a45:	49 8b 45 10          	mov    0x10(%r13),%rax
 18b7a49:	4c 8b 54 0a 10       	mov    0x10(%rdx,%rcx,1),%r10
 18b7a4e:	4c 8b 44 0a 18       	mov    0x18(%rdx,%rcx,1),%r8
 18b7a53:	8b 7c 0a 20          	mov    0x20(%rdx,%rcx,1),%edi
 18b7a57:	49 8b 4d 18          	mov    0x18(%r13),%rcx
 18b7a5b:	64 4c 8b 2c 25 10 ff ff ff 	mov    %fs:0xffffffffffffff10,%r13
 18b7a64:	4a 8b 34 f0          	mov    (%rax,%r14,8),%rsi
 18b7a68:	4a 8b 04 f1          	mov    (%rcx,%r14,8),%rax
 18b7a6c:	4c 89 54 24 28       	mov    %r10,0x28(%rsp)
 18b7a71:	48 89 7c 24 30       	mov    %rdi,0x30(%rsp)
 18b7a76:	4c 89 84 24 a8 00 00 00 	mov    %r8,0xa8(%rsp)
 18b7a7e:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
 18b7a83:	4d 85 ed             	test   %r13,%r13
 18b7a86:	74 0e                	je     18b7a96 <tier0_benchmark_run+0x2e6>
 18b7a88:	64 48 8b 0c 25 18 ff ff ff 	mov    %fs:0xffffffffffffff18,%rcx
 18b7a91:	e9 16 01 00 00       	jmp    18b7bac <tier0_benchmark_run+0x3fc>
 18b7a96:	48 bb 00 00 20 00 10 00 00 00 	movabs $0x1000200000,%rbx
 18b7aa0:	ba 03 00 00 00       	mov    $0x3,%edx
 18b7aa5:	b9 22 40 00 00       	mov    $0x4022,%ecx
 18b7aaa:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
 18b7ab0:	4c 89 4c 24 18       	mov    %r9,0x18(%rsp)
 18b7ab5:	48 89 74 24 50       	mov    %rsi,0x50(%rsp)
 18b7aba:	4c 89 74 24 48       	mov    %r14,0x48(%rsp)
 18b7abf:	31 ff                	xor    %edi,%edi
 18b7ac1:	45 31 c9             	xor    %r9d,%r9d
 18b7ac4:	48 89 de             	mov    %rbx,%rsi
 18b7ac7:	c5 f8 77             	vzeroupper
 18b7aca:	e8 71 ca ea fe       	call   764540 <mmap@plt>
 18b7acf:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
 18b7ad3:	74 50                	je     18b7b25 <tier0_benchmark_run+0x375>
 18b7ad5:	4c 8d a8 ff ff 20 00 	lea    0x20ffff(%rax),%r13
 18b7adc:	ba 0f 00 00 00       	mov    $0xf,%edx
 18b7ae1:	48 89 c7             	mov    %rax,%rdi
 18b7ae4:	49 81 e5 00 00 e0 ff 	and    $0xffffffffffe00000,%r13
 18b7aeb:	4d 89 ec             	mov    %r13,%r12
 18b7aee:	49 29 c4             	sub    %rax,%r12
 18b7af1:	4c 89 e6             	mov    %r12,%rsi
 18b7af4:	4d 8d b4 24 00 00 ff ff 	lea    -0x10000(%r12),%r14
 18b7afc:	e8 ef c9 ea fe       	call   7644f0 <madvise@plt>
 18b7b01:	4c 29 e3             	sub    %r12,%rbx
 18b7b04:	ba 0e 00 00 00       	mov    $0xe,%edx
 18b7b09:	4c 89 ef             	mov    %r13,%rdi
 18b7b0c:	48 89 de             	mov    %rbx,%rsi
 18b7b0f:	e8 dc c9 ea fe       	call   7644f0 <madvise@plt>
 18b7b14:	48 8b 84 24 f0 00 00 00 	mov    0xf0(%rsp),%rax
 18b7b1c:	49 81 c5 00 00 ff ff 	add    $0xffffffffffff0000,%r13
 18b7b23:	eb 08                	jmp    18b7b2d <tier0_benchmark_run+0x37d>
 18b7b25:	45 31 ed             	xor    %r13d,%r13d
 18b7b28:	31 c0                	xor    %eax,%eax
 18b7b2a:	45 31 f6             	xor    %r14d,%r14d
 18b7b2d:	62 f2 7d 48 58 35 9d 89 cc fe 	vpbroadcastd -0x1337663(%rip),%zmm6        # 5804d4 <tier0_emit_x87.operations+0x8c>
 18b7b37:	62 f1 fd 48 6f 3d bf 8c c6 fe 	vmovdqa64 -0x1397341(%rip),%zmm7        # 520800 <branch_sizing_patterns+0xa70>
 18b7b41:	62 e2 7d 48 5a 0d b5 e1 cb fe 	vbroadcasti32x4 -0x1341e4b(%rip),%zmm17        # 575d00 <x86_effects_unknown+0x2a0>
 18b7b4b:	62 72 7d 48 5a 0d bb e1 cb fe 	vbroadcasti32x4 -0x1341e45(%rip),%zmm9        # 575d10 <x86_effects_unknown+0x2b0>
 18b7b55:	62 72 7d 48 58 15 d1 89 cc fe 	vpbroadcastd -0x133762f(%rip),%zmm10        # 580530 <tier0_emit_x87.operations+0xe8>
 18b7b5f:	62 72 7d 48 58 1d cb 89 cc fe 	vpbroadcastd -0x1337635(%rip),%zmm11        # 580534 <tier0_emit_x87.operations+0xec>
 18b7b69:	64 4c 89 2c 25 10 ff ff ff 	mov    %r13,%fs:0xffffffffffffff10
 18b7b72:	64 48 c7 04 25 18 ff ff ff 00 00 00 00 	movq   $0x0,%fs:0xffffffffffffff18
 18b7b7f:	64 48 89 04 25 20 ff ff ff 	mov    %rax,%fs:0xffffffffffffff20
 18b7b88:	64 4c 89 34 25 28 ff ff ff 	mov    %r14,%fs:0xffffffffffffff28
 18b7b91:	4c 8b 74 24 48       	mov    0x48(%rsp),%r14
 18b7b96:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
 18b7b9b:	48 8b 7c 24 30       	mov    0x30(%rsp),%rdi
 18b7ba0:	4c 8b 4c 24 18       	mov    0x18(%rsp),%r9
 18b7ba5:	31 c9                	xor    %ecx,%ecx
 18b7ba7:	c4 41 39 ef c0       	vpxor  %xmm8,%xmm8,%xmm8
 18b7bac:	4e 8d 44 29 3f       	lea    0x3f(%rcx,%r13,1),%r8
 18b7bb1:	4a 8d 04 29          	lea    (%rcx,%r13,1),%rax
 18b7bb5:	48 89 8c 24 40 01 00 00 	mov    %rcx,0x140(%rsp)
 18b7bbd:	49 83 e0 c0          	and    $0xffffffffffffffc0,%r8
 18b7bc1:	49 39 c0             	cmp    %rax,%r8
 18b7bc4:	0f 82 26 fe ff ff    	jb     18b79f0 <tier0_benchmark_run+0x240>
 18b7bca:	64 48 8b 0c 25 20 ff ff ff 	mov    %fs:0xffffffffffffff20,%rcx
 18b7bd3:	4c 89 c0             	mov    %r8,%rax
 18b7bd6:	4c 29 e8             	sub    %r13,%rax
 18b7bd9:	48 29 c1             	sub    %rax,%rcx
 18b7bdc:	0f 82 0e fe ff ff    	jb     18b79f0 <tier0_benchmark_run+0x240>
 18b7be2:	44 89 ca             	mov    %r9d,%edx
 18b7be5:	c1 ea 06             	shr    $0x6,%edx
 18b7be8:	4c 8d 24 bd 7c 00 00 00 	lea    0x7c(,%rdi,4),%r12
 18b7bf0:	4c 8d 1c bd bc 00 00 00 	lea    0xbc(,%rdi,4),%r11
 18b7bf8:	4c 89 4c 24 18       	mov    %r9,0x18(%rsp)
 18b7bfd:	48 8d 5a 01          	lea    0x1(%rdx),%rbx
 18b7c01:	48 89 54 24 20       	mov    %rdx,0x20(%rsp)
 18b7c06:	48 ba c0 ff ff ff 07 00 00 00 	movabs $0x7ffffffc0,%rdx
 18b7c10:	4c 8b 4c 24 18       	mov    0x18(%rsp),%r9
 18b7c15:	49 21 d4             	and    %rdx,%r12
 18b7c18:	49 21 d3             	and    %rdx,%r11
 18b7c1b:	89 fa                	mov    %edi,%edx
 18b7c1d:	c1 ea 03             	shr    $0x3,%edx
 18b7c20:	49 89 dd             	mov    %rbx,%r13
 18b7c23:	48 89 9c 24 c8 00 00 00 	mov    %rbx,0xc8(%rsp)
 18b7c2b:	c1 e3 04             	shl    $0x4,%ebx
 18b7c2e:	49 c1 e5 06          	shl    $0x6,%r13
 18b7c32:	83 c2 48             	add    $0x48,%edx
 18b7c35:	83 c3 30             	add    $0x30,%ebx
 18b7c38:	4c 89 64 24 70       	mov    %r12,0x70(%rsp)
 18b7c3d:	4f 8d 24 a4          	lea    (%r12,%r12,4),%r12
 18b7c41:	4c 89 6c 24 78       	mov    %r13,0x78(%rsp)
 18b7c46:	4c 89 9c 24 88 00 00 00 	mov    %r11,0x88(%rsp)
 18b7c4e:	83 e2 c0             	and    $0xffffffc0,%edx
 18b7c51:	81 e3 c0 ff ff 1f    	and    $0x1fffffc0,%ebx
 18b7c57:	4c 01 ea             	add    %r13,%rdx
 18b7c5a:	48 89 5c 24 40       	mov    %rbx,0x40(%rsp)
 18b7c5f:	4c 89 a4 24 80 00 00 00 	mov    %r12,0x80(%rsp)
 18b7c67:	48 01 da             	add    %rbx,%rdx
 18b7c6a:	4c 01 e2             	add    %r12,%rdx
 18b7c6d:	4a 8d 14 5a          	lea    (%rdx,%r11,2),%rdx
 18b7c71:	48 39 ca             	cmp    %rcx,%rdx
 18b7c74:	0f 87 76 fd ff ff    	ja     18b79f0 <tier0_benchmark_run+0x240>
 18b7c7a:	48 01 d0             	add    %rdx,%rax
 18b7c7d:	48 c7 84 24 b8 01 00 00 00 00 00 00 	movq   $0x0,0x1b8(%rsp)
 18b7c89:	64 48 89 04 25 18 ff ff ff 	mov    %rax,%fs:0xffffffffffffff18
 18b7c92:	4d 85 c0             	test   %r8,%r8
 18b7c95:	0f 95 84 24 b8 01 00 00 	setne  0x1b8(%rsp)
 18b7c9d:	0f 84 4d fd ff ff    	je     18b79f0 <tier0_benchmark_run+0x240>
 18b7ca3:	4c 8b 64 24 78       	mov    0x78(%rsp),%r12
 18b7ca8:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
 18b7cad:	48 8b 5c 24 70       	mov    0x70(%rsp),%rbx
 18b7cb2:	4c 89 84 24 68 01 00 00 	mov    %r8,0x168(%rsp)
 18b7cba:	4c 8b 9c 24 88 00 00 00 	mov    0x88(%rsp),%r11
 18b7cc2:	4c 89 74 24 48       	mov    %r14,0x48(%rsp)
 18b7cc7:	48 89 74 24 50       	mov    %rsi,0x50(%rsp)
 18b7ccc:	4d 01 c4             	add    %r8,%r12
 18b7ccf:	4b 8d 04 1b          	lea    (%r11,%r11,1),%rax
 18b7cd3:	49 8d 14 0c          	lea    (%r12,%rcx,1),%rdx
 18b7cd7:	4c 89 a4 24 70 01 00 00 	mov    %r12,0x170(%rsp)
 18b7cdf:	4c 89 64 24 78       	mov    %r12,0x78(%rsp)
 18b7ce4:	48 8d 0c 1a          	lea    (%rdx,%rbx,1),%rcx
 18b7ce8:	48 89 94 24 78 01 00 00 	mov    %rdx,0x178(%rsp)
 18b7cf0:	4c 8d 14 5a          	lea    (%rdx,%rbx,2),%r10
 18b7cf4:	48 89 54 24 60       	mov    %rdx,0x60(%rsp)
 18b7cf9:	48 89 8c 24 80 01 00 00 	mov    %rcx,0x180(%rsp)
 18b7d01:	48 89 8c 24 e8 00 00 00 	mov    %rcx,0xe8(%rsp)
 18b7d09:	48 8d 0c 5b          	lea    (%rbx,%rbx,2),%rcx
 18b7d0d:	48 8d 1c 9a          	lea    (%rdx,%rbx,4),%rbx
 18b7d11:	4c 89 94 24 88 01 00 00 	mov    %r10,0x188(%rsp)
 18b7d19:	4c 8d 24 0a          	lea    (%rdx,%rcx,1),%r12
 18b7d1d:	48 89 8c 24 b8 00 00 00 	mov    %rcx,0xb8(%rsp)
 18b7d25:	48 8b 8c 24 80 00 00 00 	mov    0x80(%rsp),%rcx
 18b7d2d:	48 89 9c 24 e0 00 00 00 	mov    %rbx,0xe0(%rsp)
 18b7d35:	4c 89 a4 24 90 01 00 00 	mov    %r12,0x190(%rsp)
 18b7d3d:	48 89 9c 24 98 01 00 00 	mov    %rbx,0x198(%rsp)
 18b7d45:	48 01 d1             	add    %rdx,%rcx
 18b7d48:	4a 8d 14 19          	lea    (%rcx,%r11,1),%rdx
 18b7d4c:	48 01 c8             	add    %rcx,%rax
 18b7d4f:	48 89 8c 24 a0 01 00 00 	mov    %rcx,0x1a0(%rsp)
 18b7d57:	48 89 8c 24 a0 00 00 00 	mov    %rcx,0xa0(%rsp)
 18b7d5f:	48 89 94 24 a8 01 00 00 	mov    %rdx,0x1a8(%rsp)
 18b7d67:	48 89 94 24 c0 00 00 00 	mov    %rdx,0xc0(%rsp)
 18b7d6f:	48 89 84 24 b0 01 00 00 	mov    %rax,0x1b0(%rsp)
 18b7d77:	41 83 f9 10          	cmp    $0x10,%r9d
 18b7d7b:	73 10                	jae    18b7d8d <tier0_benchmark_run+0x5dd>
 18b7d7d:	4c 8b 74 24 58       	mov    0x58(%rsp),%r14
 18b7d82:	45 31 ed             	xor    %r13d,%r13d
 18b7d85:	45 31 ff             	xor    %r15d,%r15d
 18b7d88:	e9 11 03 00 00       	jmp    18b809e <tier0_benchmark_run+0x8ee>
 18b7d8d:	62 e2 7d 48 58 25 49 87 cc fe 	vpbroadcastd -0x13378b7(%rip),%zmm20        # 5804e0 <tier0_emit_x87.operations+0x98>
 18b7d97:	62 e2 7d 48 58 2d 43 87 cc fe 	vpbroadcastd -0x13378bd(%rip),%zmm21        # 5804e4 <tier0_emit_x87.operations+0x9c>
 18b7da1:	62 e2 7d 48 58 35 3d 87 cc fe 	vpbroadcastd -0x13378c3(%rip),%zmm22        # 5804e8 <tier0_emit_x87.operations+0xa0>
 18b7dab:	62 e2 7d 48 58 3d 37 87 cc fe 	vpbroadcastd -0x13378c9(%rip),%zmm23        # 5804ec <tier0_emit_x87.operations+0xa4>
 18b7db5:	62 62 7d 48 58 05 31 87 cc fe 	vpbroadcastd -0x13378cf(%rip),%zmm24        # 5804f0 <tier0_emit_x87.operations+0xa8>
 18b7dbf:	62 62 7d 48 58 0d 2b 87 cc fe 	vpbroadcastd -0x13378d5(%rip),%zmm25        # 5804f4 <tier0_emit_x87.operations+0xac>
 18b7dc9:	62 62 7d 48 58 15 25 87 cc fe 	vpbroadcastd -0x13378db(%rip),%zmm26        # 5804f8 <tier0_emit_x87.operations+0xb0>
 18b7dd3:	62 62 7d 48 58 1d 1f 87 cc fe 	vpbroadcastd -0x13378e1(%rip),%zmm27        # 5804fc <tier0_emit_x87.operations+0xb4>
 18b7ddd:	62 62 7d 48 58 25 19 87 cc fe 	vpbroadcastd -0x13378e7(%rip),%zmm28        # 580500 <tier0_emit_x87.operations+0xb8>
 18b7de7:	62 62 7d 48 58 2d 13 87 cc fe 	vpbroadcastd -0x13378ed(%rip),%zmm29        # 580504 <tier0_emit_x87.operations+0xbc>
 18b7df1:	62 62 7d 48 58 35 0d 87 cc fe 	vpbroadcastd -0x13378f3(%rip),%zmm30        # 580508 <tier0_emit_x87.operations+0xc0>
 18b7dfb:	62 62 7d 48 58 3d 07 87 cc fe 	vpbroadcastd -0x13378f9(%rip),%zmm31        # 58050c <tier0_emit_x87.operations+0xc4>
 18b7e05:	62 72 7d 48 58 2d 01 87 cc fe 	vpbroadcastd -0x13378ff(%rip),%zmm13        # 580510 <tier0_emit_x87.operations+0xc8>
 18b7e0f:	62 72 7d 48 58 3d bf 86 cc fe 	vpbroadcastd -0x1337941(%rip),%zmm15        # 5804d8 <tier0_emit_x87.operations+0x90>
 18b7e19:	62 72 7d 48 5a 25 fd de cb fe 	vbroadcasti32x4 -0x1342103(%rip),%zmm12        # 575d20 <x86_effects_unknown+0x2c0>
 18b7e23:	62 e2 7d 48 58 15 a3 86 cc fe 	vpbroadcastd -0x133795d(%rip),%zmm18        # 5804d0 <tier0_emit_x87.operations+0x88>
 18b7e2d:	4c 8b 74 24 58       	mov    0x58(%rsp),%r14
 18b7e32:	48 8d 86 c0 00 00 00 	lea    0xc0(%rsi),%rax
 18b7e39:	62 a3 7d 40 25 c0 ff 	vpternlogd $0xff,%zmm16,%zmm16,%zmm16
 18b7e40:	4c 8d 1d 39 e5 da 0c 	lea    0xcdae539(%rip),%r11        # e666380 <x86_template_storage>
 18b7e47:	31 c9                	xor    %ecx,%ecx
 18b7e49:	45 31 ed             	xor    %r13d,%r13d
 18b7e4c:	0f 1f 40 00          	nopl   0x0(%rax)
 18b7e50:	62 f1 fe 48 6f 40 fd 	vmovdqu64 -0xc0(%rax),%zmm0
 18b7e57:	62 f1 fe 48 6f 50 fe 	vmovdqu64 -0x80(%rax),%zmm2
 18b7e5e:	62 f1 fe 48 6f 58 ff 	vmovdqu64 -0x40(%rax),%zmm3
 18b7e65:	62 f1 fe 48 6f 20    	vmovdqu64 (%rax),%zmm4
 18b7e6b:	62 e2 7d 48 5a 1d bb de cb fe 	vbroadcasti32x4 -0x1342145(%rip),%zmm19        # 575d30 <x86_effects_unknown+0x2d0>
 18b7e75:	62 71 fd 48 6f f6    	vmovdqa64 %zmm6,%zmm14
 18b7e7b:	c5 fc 46 c8          	kxnorw %k0,%k0,%k1
 18b7e7f:	44 89 ea             	mov    %r13d,%edx
 18b7e82:	4c 8d 79 10          	lea    0x10(%rcx),%r15
 18b7e86:	48 05 00 01 00 00    	add    $0x100,%rax
 18b7e8c:	62 f1 7d 48 62 ca    	vpunpckldq %zmm2,%zmm0,%zmm1
 18b7e92:	62 f1 65 48 62 ec    	vpunpckldq %zmm4,%zmm3,%zmm5
 18b7e98:	62 f1 7d 48 6a c2    	vpunpckhdq %zmm2,%zmm0,%zmm0
 18b7e9e:	62 f1 65 48 6a e4    	vpunpckhdq %zmm4,%zmm3,%zmm4
 18b7ea4:	62 f1 fd 48 6c dc    	vpunpcklqdq %zmm4,%zmm0,%zmm3
 18b7eaa:	62 f1 fd 48 6d c4    	vpunpckhqdq %zmm4,%zmm0,%zmm0
 18b7eb0:	62 f1 f5 48 6d cd    	vpunpckhqdq %zmm5,%zmm1,%zmm1
 18b7eb6:	62 f1 7d 48 72 f0 04 	vpslld $0x4,%zmm0,%zmm0
 18b7ebd:	62 f2 f5 40 83 e3    	vpmultishiftqb %zmm3,%zmm17,%zmm4
 18b7ec3:	62 f2 9d 48 83 eb    	vpmultishiftqb %zmm3,%zmm12,%zmm5
 18b7ec9:	62 f2 75 48 27 c1    	vptestmd %zmm1,%zmm1,%k0
 18b7ecf:	62 f1 7d 48 db d6    	vpandd %zmm6,%zmm0,%zmm2
 18b7ed5:	62 f2 b5 48 83 f3    	vpmultishiftqb %zmm3,%zmm9,%zmm6
 18b7edb:	62 d3 5d 48 25 ef d8 	vpternlogd $0xd8,%zmm15,%zmm4,%zmm5
 18b7ee2:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 18b7ee6:	62 f1 5d 48 72 f3 04 	vpslld $0x4,%zmm3,%zmm4
 18b7eed:	62 f3 4d 58 25 2d e4 85 cc fe d8 	vpternlogd $0xd8,-0x1337a1c(%rip){1to16},%zmm6,%zmm5        # 5804dc <tier0_emit_x87.operations+0x94>
 18b7ef8:	62 d2 7d 49 90 44 93 13 	vpgatherdd 0x4c(%r11,%zmm2,4),%zmm0{%k1}
 18b7f00:	62 f1 6d 48 72 d3 1a 	vpsrld $0x1a,%zmm3,%zmm2
 18b7f07:	62 f2 65 40 00 f3    	vpshufb %zmm3,%zmm19,%zmm6
 18b7f0d:	62 e1 fd 48 6f df    	vmovdqa64 %zmm7,%zmm19
 18b7f13:	62 f1 5d 48 72 e4 1f 	vpsrad $0x1f,%zmm4,%zmm4
 18b7f1a:	62 f2 6d 48 36 d7    	vpermd %zmm7,%zmm2,%zmm2
 18b7f20:	62 f1 45 48 72 d3 08 	vpsrld $0x8,%zmm3,%zmm7
 18b7f27:	62 b3 6d 40 25 dd 6c 	vpternlogd $0x6c,%zmm21,%zmm18,%zmm3
 18b7f2e:	62 b1 65 48 fe d8    	vpaddd %zmm16,%zmm3,%zmm3
 18b7f34:	62 b3 6d 40 25 fe 6c 	vpternlogd $0x6c,%zmm22,%zmm18,%zmm7
 18b7f3b:	62 b1 45 48 fe f8    	vpaddd %zmm16,%zmm7,%zmm7
 18b7f41:	62 93 45 40 25 d8 ea 	vpternlogd $0xea,%zmm24,%zmm23,%zmm3
 18b7f48:	62 93 45 48 25 d9 f8 	vpternlogd $0xf8,%zmm25,%zmm7,%zmm3
 18b7f4f:	62 91 55 48 db fa    	vpandd %zmm26,%zmm5,%zmm7
 18b7f55:	62 f1 55 48 72 d5 03 	vpsrld $0x3,%zmm5,%zmm5
 18b7f5c:	62 f3 7d 48 25 fb f8 	vpternlogd $0xf8,%zmm3,%zmm0,%zmm7
 18b7f63:	62 93 7d 48 25 ec a2 	vpternlogd $0xa2,%zmm28,%zmm0,%zmm5
 18b7f6a:	62 92 45 48 3b db    	vpminud %zmm27,%zmm7,%zmm3
 18b7f70:	62 f1 5d 48 db fe    	vpandd %zmm6,%zmm4,%zmm7
 18b7f76:	62 93 6d 48 25 fe ec 	vpternlogd $0xec,%zmm30,%zmm2,%zmm7
 18b7f7d:	62 92 55 48 3b d5    	vpminud %zmm29,%zmm5,%zmm2
 18b7f83:	62 93 7d 48 25 ff f8 	vpternlogd $0xf8,%zmm31,%zmm0,%zmm7
 18b7f8a:	62 f3 6d 48 25 fb fe 	vpternlogd $0xfe,%zmm3,%zmm2,%zmm7
 18b7f91:	62 f1 65 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm3
 18b7f98:	62 f1 65 48 ef d1    	vpxord %zmm1,%zmm3,%zmm2
 18b7f9e:	62 b1 75 48 fe d8    	vpaddd %zmm16,%zmm1,%zmm3
 18b7fa4:	62 f2 7d 48 44 d2    	vplzcntd %zmm2,%zmm2
 18b7faa:	62 f2 5d 40 45 d2    	vpsrlvd %zmm2,%zmm20,%zmm2
 18b7fb0:	62 f3 75 48 25 da 14 	vpternlogd $0x14,%zmm2,%zmm1,%zmm3
 18b7fb7:	62 f1 6d 48 72 f6 10 	vpslld $0x10,%zmm6,%zmm2
 18b7fbe:	62 f2 7e 48 38 c8    	vpmovm2d %k0,%zmm1
 18b7fc4:	62 d1 fd 48 6f f6    	vmovdqa64 %zmm14,%zmm6
 18b7fca:	62 f1 0d 48 72 d0 1d 	vpsrld $0x1d,%zmm0,%zmm14
 18b7fd1:	62 f1 6d 48 72 e2 1f 	vpsrad $0x1f,%zmm2,%zmm2
 18b7fd8:	62 f3 5d 48 25 ca c8 	vpternlogd $0xc8,%zmm2,%zmm4,%zmm1
 18b7fdf:	62 f1 5d 58 db 25 2b 85 cc fe 	vpandd -0x1337ad5(%rip){1to16},%zmm4,%zmm4        # 580514 <tier0_emit_x87.operations+0xcc>
 18b7fe9:	62 d2 65 48 14 d6    	vprorvd %zmm14,%zmm3,%zmm2
 18b7fef:	62 d1 75 48 db cd    	vpandd %zmm13,%zmm1,%zmm1
 18b7ff5:	62 f1 6d 48 72 e2 1f 	vpsrad $0x1f,%zmm2,%zmm2
 18b7ffc:	62 f3 6d 48 25 e1 b8 	vpternlogd $0xb8,%zmm1,%zmm2,%zmm4
 18b8003:	62 b1 55 48 fe d0    	vpaddd %zmm16,%zmm5,%zmm2
 18b8009:	62 f1 5d 48 eb cf    	vpord  %zmm7,%zmm4,%zmm1
 18b800f:	62 f3 7d 58 25 0d fe 84 cc fe 20 	vpternlogd $0x20,-0x1337b02(%rip){1to16},%zmm0,%zmm1        # 580518 <tier0_emit_x87.operations+0xd0>
 18b801a:	62 f1 7d 58 db 05 f8 84 cc fe 	vpandd -0x1337b08(%rip){1to16},%zmm0,%zmm0        # 58051c <tier0_emit_x87.operations+0xd4>
 18b8024:	62 f1 6d 48 72 e2 1f 	vpsrad $0x1f,%zmm2,%zmm2
 18b802b:	62 b1 fd 48 6f fb    	vmovdqa64 %zmm19,%zmm7
 18b8031:	62 f2 7d 48 55 c9    	vpopcntd %zmm1,%zmm1
 18b8037:	62 f1 6d 48 fe c0    	vpaddd %zmm0,%zmm2,%zmm0
 18b803d:	62 f1 7d 48 fe c1    	vpaddd %zmm1,%zmm0,%zmm0
 18b8043:	c5 f9 6f 0d 95 dc cb fe 	vmovdqa -0x134236b(%rip),%xmm1        # 575ce0 <x86_effects_unknown+0x280>
 18b804b:	62 f2 75 48 8d c0    	vpermb %zmm0,%zmm1,%zmm0
 18b8051:	62 f2 fd 18 40 0d b5 80 cc fe 	vpmullq -0x1337f4b(%rip){1to2},%xmm0,%xmm1        # 580110 <x86_semantics_benchmark_code.registers+0x120>
 18b805b:	c4 e2 71 00 15 8c dc cb fe 	vpshufb -0x1342374(%rip),%xmm1,%xmm2        # 575cf0 <x86_effects_unknown+0x290>
 18b8064:	c5 e9 fc c9          	vpaddb %xmm1,%xmm2,%xmm1
 18b8068:	62 d2 7d 48 7c d5    	vpbroadcastd %r13d,%zmm2
 18b806e:	c5 f1 f8 c0          	vpsubb %xmm0,%xmm1,%xmm0
 18b8072:	c4 c3 79 14 cd 0f    	vpextrb $0xf,%xmm1,%r13d
 18b8078:	62 f2 7d 48 31 c0    	vpmovzxbd %xmm0,%zmm0
 18b807e:	41 01 d5             	add    %edx,%r13d
 18b8081:	62 f1 6d 48 fe c0    	vpaddd %zmm0,%zmm2,%zmm0
 18b8087:	62 d1 fe 48 7f 04 8e 	vmovdqu64 %zmm0,(%r14,%rcx,4)
 18b808e:	48 83 c1 20          	add    $0x20,%rcx
 18b8092:	4c 39 c9             	cmp    %r9,%rcx
 18b8095:	4c 89 f9             	mov    %r15,%rcx
 18b8098:	0f 86 b2 fd ff ff    	jbe    18b7e50 <tier0_benchmark_run+0x6a0>
 18b809e:	4c 89 cb             	mov    %r9,%rbx
 18b80a1:	4c 29 fb             	sub    %r15,%rbx
 18b80a4:	4c 89 44 24 10       	mov    %r8,0x10(%rsp)
 18b80a9:	0f 86 92 03 00 00    	jbe    18b8441 <tier0_benchmark_run+0xc91>
 18b80af:	4c 89 fe             	mov    %r15,%rsi
 18b80b2:	48 c1 e6 04          	shl    $0x4,%rsi
 18b80b6:	48 03 74 24 50       	add    0x50(%rsp),%rsi
 18b80bb:	48 89 da             	mov    %rbx,%rdx
 18b80be:	48 c1 e2 04          	shl    $0x4,%rdx
 18b80c2:	48 8d bc 24 c0 01 00 00 	lea    0x1c0(%rsp),%rdi
 18b80ca:	62 71 fd 48 7f 44 24 0a 	vmovdqa64 %zmm8,0x280(%rsp)
 18b80d2:	62 71 fd 48 7f 44 24 09 	vmovdqa64 %zmm8,0x240(%rsp)
 18b80da:	62 71 fd 48 7f 44 24 08 	vmovdqa64 %zmm8,0x200(%rsp)
 18b80e2:	62 71 fd 48 7f 44 24 07 	vmovdqa64 %zmm8,0x1c0(%rsp)
 18b80ea:	c5 f8 77             	vzeroupper
 18b80ed:	e8 5e c3 ea fe       	call   764450 <memcpy@plt>
 18b80f2:	62 f1 fd 48 6f 44 24 07 	vmovdqa64 0x1c0(%rsp),%zmm0
 18b80fa:	62 f1 fd 48 6f 54 24 08 	vmovdqa64 0x200(%rsp),%zmm2
 18b8102:	62 f1 fd 48 6f 5c 24 09 	vmovdqa64 0x240(%rsp),%zmm3
 18b810a:	62 f1 fd 48 6f 64 24 0a 	vmovdqa64 0x280(%rsp),%zmm4
 18b8112:	62 72 7d 48 58 2d b8 83 cc fe 	vpbroadcastd -0x1337c48(%rip),%zmm13        # 5804d4 <tier0_emit_x87.operations+0x8c>
 18b811c:	62 f2 7d 48 5a 35 fa db cb fe 	vbroadcasti32x4 -0x1342406(%rip),%zmm6        # 575d20 <x86_effects_unknown+0x2c0>
 18b8126:	62 e2 7d 48 5a 15 d0 db cb fe 	vbroadcasti32x4 -0x1342430(%rip),%zmm18        # 575d00 <x86_effects_unknown+0x2a0>
 18b8130:	62 72 7d 48 58 3d 9e 83 cc fe 	vpbroadcastd -0x1337c62(%rip),%zmm15        # 5804d8 <tier0_emit_x87.operations+0x90>
 18b813a:	62 72 7d 48 5a 0d cc db cb fe 	vbroadcasti32x4 -0x1342434(%rip),%zmm9        # 575d10 <x86_effects_unknown+0x2b0>
 18b8144:	62 71 fd 48 6f 35 b2 86 c6 fe 	vmovdqa64 -0x139794e(%rip),%zmm14        # 520800 <branch_sizing_patterns+0xa70>
 18b814e:	62 e2 7d 48 58 25 8c 83 cc fe 	vpbroadcastd -0x1337c74(%rip),%zmm20        # 5804e4 <tier0_emit_x87.operations+0x9c>
 18b8158:	62 e2 7d 48 5a 0d ce db cb fe 	vbroadcasti32x4 -0x1342432(%rip),%zmm17        # 575d30 <x86_effects_unknown+0x2d0>
 18b8162:	62 e2 7d 48 58 05 70 83 cc fe 	vpbroadcastd -0x1337c90(%rip),%zmm16        # 5804dc <tier0_emit_x87.operations+0x94>
 18b816c:	62 f2 7d 48 58 3d 5a 83 cc fe 	vpbroadcastd -0x1337ca6(%rip),%zmm7        # 5804d0 <tier0_emit_x87.operations+0x88>
 18b8176:	62 e2 7d 48 58 2d 68 83 cc fe 	vpbroadcastd -0x1337c98(%rip),%zmm21        # 5804e8 <tier0_emit_x87.operations+0xa0>
 18b8180:	62 e2 7d 48 58 3d 66 83 cc fe 	vpbroadcastd -0x1337c9a(%rip),%zmm23        # 5804f0 <tier0_emit_x87.operations+0xa8>
 18b818a:	62 e2 7d 48 58 35 58 83 cc fe 	vpbroadcastd -0x1337ca8(%rip),%zmm22        # 5804ec <tier0_emit_x87.operations+0xa4>
 18b8194:	62 62 7d 48 58 0d 5a 83 cc fe 	vpbroadcastd -0x1337ca6(%rip),%zmm25        # 5804f8 <tier0_emit_x87.operations+0xb0>
 18b819e:	62 62 7d 48 58 05 4c 83 cc fe 	vpbroadcastd -0x1337cb4(%rip),%zmm24        # 5804f4 <tier0_emit_x87.operations+0xac>
 18b81a8:	62 62 7d 48 58 35 56 83 cc fe 	vpbroadcastd -0x1337caa(%rip),%zmm30        # 580508 <tier0_emit_x87.operations+0xc0>
 18b81b2:	62 62 7d 48 58 25 44 83 cc fe 	vpbroadcastd -0x1337cbc(%rip),%zmm28        # 580500 <tier0_emit_x87.operations+0xb8>
 18b81bc:	62 62 7d 48 58 3d 46 83 cc fe 	vpbroadcastd -0x1337cba(%rip),%zmm31        # 58050c <tier0_emit_x87.operations+0xc4>
 18b81c6:	62 62 7d 48 58 2d 34 83 cc fe 	vpbroadcastd -0x1337ccc(%rip),%zmm29        # 580504 <tier0_emit_x87.operations+0xbc>
 18b81d0:	62 62 7d 48 58 15 22 83 cc fe 	vpbroadcastd -0x1337cde(%rip),%zmm26        # 5804fc <tier0_emit_x87.operations+0xb4>
 18b81da:	c5 fc 46 c8          	kxnorw %k0,%k0,%k1
 18b81de:	48 8d 05 9b e1 da 0c 	lea    0xcdae19b(%rip),%rax        # e666380 <x86_template_storage>
 18b81e5:	62 53 1d 48 25 e4 ff 	vpternlogd $0xff,%zmm12,%zmm12,%zmm12
 18b81ec:	62 62 7d 48 58 1d ea 82 cc fe 	vpbroadcastd -0x1337d16(%rip),%zmm27        # 5804e0 <tier0_emit_x87.operations+0x98>
 18b81f6:	62 e2 7d 48 58 1d 10 83 cc fe 	vpbroadcastd -0x1337cf0(%rip),%zmm19        # 580510 <tier0_emit_x87.operations+0xc8>
 18b8200:	62 72 7d 48 58 1d 2a 83 cc fe 	vpbroadcastd -0x1337cd6(%rip),%zmm11        # 580534 <tier0_emit_x87.operations+0xec>
 18b820a:	62 72 7d 48 58 15 1c 83 cc fe 	vpbroadcastd -0x1337ce4(%rip),%zmm10        # 580530 <tier0_emit_x87.operations+0xe8>
 18b8214:	4c 8b 4c 24 18       	mov    0x18(%rsp),%r9
 18b8219:	4c 8b 44 24 10       	mov    0x10(%rsp),%r8
 18b821e:	48 8b 7c 24 30       	mov    0x30(%rsp),%rdi
 18b8223:	c4 41 39 ef c0       	vpxor  %xmm8,%xmm8,%xmm8
 18b8228:	62 f1 7d 48 62 ca    	vpunpckldq %zmm2,%zmm0,%zmm1
 18b822e:	62 f1 65 48 62 ec    	vpunpckldq %zmm4,%zmm3,%zmm5
 18b8234:	62 f1 7d 48 6a c2    	vpunpckhdq %zmm2,%zmm0,%zmm0
 18b823a:	62 f1 65 48 6a e4    	vpunpckhdq %zmm4,%zmm3,%zmm4
 18b8240:	62 f1 fd 48 6c dc    	vpunpcklqdq %zmm4,%zmm0,%zmm3
 18b8246:	62 f1 fd 48 6d c4    	vpunpckhqdq %zmm4,%zmm0,%zmm0
 18b824c:	62 f1 f5 48 6d cd    	vpunpckhqdq %zmm5,%zmm1,%zmm1
 18b8252:	62 f1 7d 48 72 f0 04 	vpslld $0x4,%zmm0,%zmm0
 18b8259:	62 f2 cd 48 83 eb    	vpmultishiftqb %zmm3,%zmm6,%zmm5
 18b825f:	62 f2 ed 40 83 e3    	vpmultishiftqb %zmm3,%zmm18,%zmm4
 18b8265:	62 f2 b5 48 83 f3    	vpmultishiftqb %zmm3,%zmm9,%zmm6
 18b826b:	62 f2 75 48 27 c1    	vptestmd %zmm1,%zmm1,%k0
 18b8271:	62 d1 7d 48 db d5    	vpandd %zmm13,%zmm0,%zmm2
 18b8277:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 18b827b:	62 d3 5d 48 25 ef d8 	vpternlogd $0xd8,%zmm15,%zmm4,%zmm5
 18b8282:	62 f1 5d 48 72 f3 04 	vpslld $0x4,%zmm3,%zmm4
 18b8289:	62 f2 7d 49 90 44 90 13 	vpgatherdd 0x4c(%rax,%zmm2,4),%zmm0{%k1}
 18b8291:	62 f1 6d 48 72 d3 1a 	vpsrld $0x1a,%zmm3,%zmm2
 18b8298:	62 b3 4d 48 25 e8 d8 	vpternlogd $0xd8,%zmm16,%zmm6,%zmm5
 18b829f:	62 e1 fd 48 6f c7    	vmovdqa64 %zmm7,%zmm16
 18b82a5:	62 f1 45 48 72 d3 08 	vpsrld $0x8,%zmm3,%zmm7
 18b82ac:	62 f2 75 40 00 f3    	vpshufb %zmm3,%zmm17,%zmm6
 18b82b2:	62 b3 7d 40 25 dc 6c 	vpternlogd $0x6c,%zmm20,%zmm16,%zmm3
 18b82b9:	62 f1 5d 48 72 e4 1f 	vpsrad $0x1f,%zmm4,%zmm4
 18b82c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 18b82c5:	62 d2 6d 48 36 d6    	vpermd %zmm14,%zmm2,%zmm2
 18b82cb:	62 d1 65 48 fe dc    	vpaddd %zmm12,%zmm3,%zmm3
 18b82d1:	62 b3 7d 40 25 fd 6c 	vpternlogd $0x6c,%zmm21,%zmm16,%zmm7
 18b82d8:	c4 e2 61 f7 c0       	shlx   %ebx,%eax,%eax
 18b82dd:	62 d1 45 48 fe fc    	vpaddd %zmm12,%zmm7,%zmm7
 18b82e3:	62 b3 4d 40 25 df ea 	vpternlogd $0xea,%zmm23,%zmm22,%zmm3
 18b82ea:	62 e1 5d 48 db ce    	vpandd %zmm6,%zmm4,%zmm17
 18b82f0:	62 f1 05 48 72 f6 10 	vpslld $0x10,%zmm6,%zmm15
 18b82f7:	62 d1 fd 48 6f f5    	vmovdqa64 %zmm13,%zmm6
 18b82fd:	f7 d0                	not    %eax
 18b82ff:	62 93 45 48 25 d8 f8 	vpternlogd $0xf8,%zmm24,%zmm7,%zmm3
 18b8306:	62 91 55 48 db f9    	vpandd %zmm25,%zmm5,%zmm7
 18b830c:	62 f1 55 48 72 d5 03 	vpsrld $0x3,%zmm5,%zmm5
 18b8313:	c5 fb 92 c8          	kmovd  %eax,%k1
 18b8317:	62 f3 7d 48 25 fb f8 	vpternlogd $0xf8,%zmm3,%zmm0,%zmm7
 18b831e:	62 93 7d 48 25 ec a2 	vpternlogd $0xa2,%zmm28,%zmm0,%zmm5
 18b8325:	62 f1 15 48 72 d0 1d 	vpsrld $0x1d,%zmm0,%zmm13
 18b832c:	62 83 6d 48 25 ce ec 	vpternlogd $0xec,%zmm30,%zmm2,%zmm17
 18b8333:	62 92 45 48 3b da    	vpminud %zmm26,%zmm7,%zmm3
 18b8339:	62 92 55 48 3b d5    	vpminud %zmm29,%zmm5,%zmm2
 18b833f:	62 d1 fd 48 6f fe    	vmovdqa64 %zmm14,%zmm7
 18b8345:	62 83 7d 48 25 cf f8 	vpternlogd $0xf8,%zmm31,%zmm0,%zmm17
 18b834c:	62 e3 6d 48 25 cb fe 	vpternlogd $0xfe,%zmm3,%zmm2,%zmm17
 18b8353:	62 f1 65 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm3
 18b835a:	62 f1 65 48 ef d1    	vpxord %zmm1,%zmm3,%zmm2
 18b8360:	62 d1 75 48 fe dc    	vpaddd %zmm12,%zmm1,%zmm3
 18b8366:	62 f2 7d 48 44 d2    	vplzcntd %zmm2,%zmm2
 18b836c:	62 f2 25 40 45 d2    	vpsrlvd %zmm2,%zmm27,%zmm2
 18b8372:	62 f3 75 48 25 da 14 	vpternlogd $0x14,%zmm2,%zmm1,%zmm3
 18b8379:	62 d1 6d 48 72 e7 1f 	vpsrad $0x1f,%zmm15,%zmm2
 18b8380:	62 f2 7e 48 38 c8    	vpmovm2d %k0,%zmm1
 18b8386:	62 f3 5d 48 25 ca c8 	vpternlogd $0xc8,%zmm2,%zmm4,%zmm1
 18b838d:	62 f1 5d 58 db 25 7d 81 cc fe 	vpandd -0x1337e83(%rip){1to16},%zmm4,%zmm4        # 580514 <tier0_emit_x87.operations+0xcc>
 18b8397:	62 d2 65 48 14 d5    	vprorvd %zmm13,%zmm3,%zmm2
 18b839d:	62 b1 75 48 db cb    	vpandd %zmm19,%zmm1,%zmm1
 18b83a3:	62 f1 6d 48 72 e2 1f 	vpsrad $0x1f,%zmm2,%zmm2
 18b83aa:	62 f3 6d 48 25 e1 b8 	vpternlogd $0xb8,%zmm1,%zmm2,%zmm4
 18b83b1:	62 d1 55 48 fe d4    	vpaddd %zmm12,%zmm5,%zmm2
 18b83b7:	62 b1 5d 48 eb c9    	vpord  %zmm17,%zmm4,%zmm1
 18b83bd:	62 f3 7d 58 25 0d 50 81 cc fe 20 	vpternlogd $0x20,-0x1337eb0(%rip){1to16},%zmm0,%zmm1        # 580518 <tier0_emit_x87.operations+0xd0>
 18b83c8:	62 f1 7d 58 db 05 4a 81 cc fe 	vpandd -0x1337eb6(%rip){1to16},%zmm0,%zmm0        # 58051c <tier0_emit_x87.operations+0xd4>
 18b83d2:	62 f1 6d 48 72 e2 1f 	vpsrad $0x1f,%zmm2,%zmm2
 18b83d9:	62 a1 fd 48 6f ca    	vmovdqa64 %zmm18,%zmm17
 18b83df:	62 f2 7d 48 55 c9    	vpopcntd %zmm1,%zmm1
 18b83e5:	62 f1 6d 48 fe c0    	vpaddd %zmm0,%zmm2,%zmm0
 18b83eb:	62 f1 7d 48 fe c1    	vpaddd %zmm1,%zmm0,%zmm0
 18b83f1:	c5 f9 6f 0d e7 d8 cb fe 	vmovdqa -0x1342719(%rip),%xmm1        # 575ce0 <x86_effects_unknown+0x280>
 18b83f9:	62 f2 75 48 8d c0    	vpermb %zmm0,%zmm1,%zmm0
 18b83ff:	62 f2 fd 18 40 0d 07 7d cc fe 	vpmullq -0x13382f9(%rip){1to2},%xmm0,%xmm1        # 580110 <x86_semantics_benchmark_code.registers+0x120>
 18b8409:	c4 e2 71 00 15 de d8 cb fe 	vpshufb -0x1342722(%rip),%xmm1,%xmm2        # 575cf0 <x86_effects_unknown+0x290>
 18b8412:	c5 e9 fc c9          	vpaddb %xmm1,%xmm2,%xmm1
 18b8416:	62 d2 7d 48 7c d5    	vpbroadcastd %r13d,%zmm2
 18b841c:	c5 f1 f8 c0          	vpsubb %xmm0,%xmm1,%xmm0
 18b8420:	c4 e3 79 14 c8 0f    	vpextrb $0xf,%xmm1,%eax
 18b8426:	62 f2 7d 48 31 c0    	vpmovzxbd %xmm0,%zmm0
 18b842c:	44 01 e8             	add    %r13d,%eax
 18b842f:	41 89 c5             	mov    %eax,%r13d
 18b8432:	62 f1 6d 48 fe c0    	vpaddd %zmm0,%zmm2,%zmm0
 18b8438:	62 91 7e 49 7f 04 be 	vmovdqu32 %zmm0,(%r14,%r15,4){%k1}
 18b843f:	eb 0a                	jmp    18b844b <tier0_benchmark_run+0xc9b>
 18b8441:	62 e2 7d 48 58 05 85 80 cc fe 	vpbroadcastd -0x1337f7b(%rip),%zmm16        # 5804d0 <tier0_emit_x87.operations+0x88>
 18b844b:	4c 8b 74 24 48       	mov    0x48(%rsp),%r14
 18b8450:	45 31 ff             	xor    %r15d,%r15d
 18b8453:	48 8d 04 bd 00 00 00 00 	lea    0x0(,%rdi,4),%rax
 18b845b:	44 89 e9             	mov    %r13d,%ecx
 18b845e:	48 01 c1             	add    %rax,%rcx
 18b8461:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
 18b8466:	48 81 f9 ff ff ff 7f 	cmp    $0x7fffffff,%rcx
 18b846d:	0f 87 7d f5 ff ff    	ja     18b79f0 <tier0_benchmark_run+0x240>
 18b8473:	48 8b 8c 24 a0 00 00 00 	mov    0xa0(%rsp),%rcx
 18b847b:	48 8b 94 24 c0 00 00 00 	mov    0xc0(%rsp),%rdx
 18b8483:	c7 01 00 00 00 00    	movl   $0x0,(%rcx)
 18b8489:	c7 02 00 00 00 00    	movl   $0x0,(%rdx)
 18b848f:	48 85 ff             	test   %rdi,%rdi
 18b8492:	0f 84 58 f5 ff ff    	je     18b79f0 <tier0_benchmark_run+0x240>
 18b8498:	48 8b 54 24 70       	mov    0x70(%rsp),%rdx
 18b849d:	4c 8d 70 0c          	lea    0xc(%rax),%r14
 18b84a1:	48 8d 47 ff          	lea    -0x1(%rdi),%rax
 18b84a5:	62 d2 7d 48 7c c9    	vpbroadcastd %r9d,%zmm1
 18b84ab:	62 d2 7d 48 7c c5    	vpbroadcastd %r13d,%zmm0
 18b84b1:	4c 89 a4 24 b0 00 00 00 	mov    %r12,0xb0(%rsp)
 18b84b9:	48 89 c6             	mov    %rax,%rsi
 18b84bc:	48 c1 ee 04          	shr    $0x4,%rsi
 18b84c0:	4c 8d 1c 95 00 00 00 00 	lea    0x0(,%rdx,4),%r11
 18b84c8:	4c 89 9c 24 98 00 00 00 	mov    %r11,0x98(%rsp)
 18b84d0:	0f 84 3c 04 00 00    	je     18b8912 <tier0_benchmark_run+0x1162>
 18b84d6:	4c 8b 4c 24 28       	mov    0x28(%rsp),%r9
 18b84db:	48 8b 8c 24 a8 00 00 00 	mov    0xa8(%rsp),%rcx
 18b84e3:	48 89 84 24 d8 00 00 00 	mov    %rax,0xd8(%rsp)
 18b84eb:	62 51 fd 48 6f e2    	vmovdqa64 %zmm10,%zmm12
 18b84f1:	62 51 fd 48 6f eb    	vmovdqa64 %zmm11,%zmm13
 18b84f7:	62 72 7d 48 58 15 23 80 cc fe 	vpbroadcastd -0x1337fdd(%rip),%zmm10        # 580524 <tier0_emit_x87.operations+0xdc>
 18b8501:	62 72 7d 48 58 1d 21 80 cc fe 	vpbroadcastd -0x1337fdf(%rip),%zmm11        # 58052c <tier0_emit_x87.operations+0xe4>
 18b850b:	62 72 7d 48 58 35 0b 80 cc fe 	vpbroadcastd -0x1337ff5(%rip),%zmm14        # 580520 <tier0_emit_x87.operations+0xd8>
 18b8515:	62 72 7d 48 58 3d 09 80 cc fe 	vpbroadcastd -0x1337ff7(%rip),%zmm15        # 580528 <tier0_emit_x87.operations+0xe0>
 18b851f:	48 ff c6             	inc    %rsi
 18b8522:	c5 e9 ef d2          	vpxor  %xmm2,%xmm2,%xmm2
 18b8526:	49 89 ff             	mov    %rdi,%r15
 18b8529:	4c 89 b4 24 90 00 00 00 	mov    %r14,0x90(%rsp)
 18b8531:	48 83 e6 fe          	and    $0xfffffffffffffffe,%rsi
 18b8535:	49 8d 41 40          	lea    0x40(%r9),%rax
 18b8539:	48 89 84 24 28 01 00 00 	mov    %rax,0x128(%rsp)
 18b8541:	48 8d 41 40          	lea    0x40(%rcx),%rax
 18b8545:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
 18b854a:	c1 e1 06             	shl    $0x6,%ecx
 18b854d:	48 03 4c 24 40       	add    0x40(%rsp),%rcx
 18b8552:	48 89 84 24 20 01 00 00 	mov    %rax,0x120(%rsp)
 18b855a:	48 8d 04 11          	lea    (%rcx,%rdx,1),%rax
 18b855e:	4d 8d 0c 08          	lea    (%r8,%rcx,1),%r9
 18b8562:	49 8d 84 00 80 00 00 00 	lea    0x80(%r8,%rax,1),%rax
 18b856a:	4c 89 8c 24 00 01 00 00 	mov    %r9,0x100(%rsp)
 18b8572:	4c 8b 8c 24 88 00 00 00 	mov    0x88(%rsp),%r9
 18b857a:	48 89 84 24 18 01 00 00 	mov    %rax,0x118(%rsp)
 18b8582:	4a 8d 04 19          	lea    (%rcx,%r11,1),%rax
 18b8586:	4c 8b 9c 24 80 00 00 00 	mov    0x80(%rsp),%r11
 18b858e:	49 8d 84 00 80 00 00 00 	lea    0x80(%r8,%rax,1),%rax
 18b8596:	48 89 84 24 10 01 00 00 	mov    %rax,0x110(%rsp)
 18b859e:	48 8d 04 52          	lea    (%rdx,%rdx,2),%rax
 18b85a2:	48 01 c8             	add    %rcx,%rax
 18b85a5:	4d 01 d9             	add    %r11,%r9
 18b85a8:	49 8d 84 00 80 00 00 00 	lea    0x80(%r8,%rax,1),%rax
 18b85b0:	49 01 c9             	add    %rcx,%r9
 18b85b3:	4b 8d 94 08 84 00 00 00 	lea    0x84(%r8,%r9,1),%rdx
 18b85bb:	45 31 c9             	xor    %r9d,%r9d
 18b85be:	48 89 84 24 08 01 00 00 	mov    %rax,0x108(%rsp)
 18b85c6:	4a 8d 04 19          	lea    (%rcx,%r11,1),%rax
 18b85ca:	31 c9                	xor    %ecx,%ecx
 18b85cc:	49 8d 84 00 84 00 00 00 	lea    0x84(%r8,%rax,1),%rax
 18b85d4:	48 89 94 24 80 00 00 00 	mov    %rdx,0x80(%rsp)
 18b85dc:	48 89 84 24 f8 00 00 00 	mov    %rax,0xf8(%rsp)
 18b85e4:	66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 cs nopw 0x0(%rax,%rax,1)
 18b85f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 18b85f5:	4c 8b ac 24 20 01 00 00 	mov    0x120(%rsp),%r13
 18b85fd:	4c 8b 94 24 28 01 00 00 	mov    0x128(%rsp),%r10
 18b8605:	4c 89 fb             	mov    %r15,%rbx
 18b8608:	48 83 eb 10          	sub    $0x10,%rbx
 18b860c:	48 89 b4 24 88 00 00 00 	mov    %rsi,0x88(%rsp)
 18b8614:	48 8b 74 24 58       	mov    0x58(%rsp),%rsi
 18b8619:	c5 d1 ef ed          	vpxor  %xmm5,%xmm5,%xmm5
 18b861d:	62 f1 fd 48 6f f0    	vmovdqa64 %zmm0,%zmm6
 18b8623:	4c 8b 84 24 00 01 00 00 	mov    0x100(%rsp),%r8
 18b862b:	48 8b 94 24 10 01 00 00 	mov    0x110(%rsp),%rdx
 18b8633:	4c 8b 9c 24 f8 00 00 00 	mov    0xf8(%rsp),%r11
 18b863b:	48 8b bc 24 80 00 00 00 	mov    0x80(%rsp),%rdi
 18b8643:	c4 62 01 f7 f0       	shlx   %r15d,%eax,%r14d
 18b8648:	b8 ff ff 00 00       	mov    $0xffff,%eax
 18b864d:	41 f7 d6             	not    %r14d
 18b8650:	44 0f 43 f0          	cmovae %eax,%r14d
 18b8654:	48 8b 84 24 90 00 00 00 	mov    0x90(%rsp),%rax
 18b865c:	c4 c1 7b 92 ce       	kmovd  %r14d,%k1
 18b8661:	45 89 ce             	mov    %r9d,%r14d
 18b8664:	41 b9 ff ff ff ff    	mov    $0xffffffff,%r9d
 18b866a:	62 d1 7e c9 6f 64 8d ff 	vmovdqu32 -0x40(%r13,%rcx,4),%zmm4{%k1}{z}
 18b8672:	62 d1 7e c9 6f 5c 8a ff 	vmovdqu32 -0x40(%r10,%rcx,4),%zmm3{%k1}{z}
 18b867a:	c4 e1 f8 90 d9       	kmovq  %k1,%k3
 18b867f:	c4 42 61 f7 c9       	shlx   %ebx,%r9d,%r9d
 18b8684:	41 f7 d1             	not    %r9d
 18b8687:	62 f3 5d 49 1e d1 01 	vpcmpltud %zmm1,%zmm4,%k2{%k1}
 18b868e:	62 f2 7d 4b 90 2c 9e 	vpgatherdd (%rsi,%zmm3,4),%zmm5{%k3}
 18b8695:	62 f1 65 48 fe db    	vpaddd %zmm3,%zmm3,%zmm3
 18b869b:	c4 e1 f8 90 d9       	kmovq  %k1,%k3
 18b86a0:	62 f2 7d 4a 90 34 a6 	vpgatherdd (%rsi,%zmm4,4),%zmm6{%k2}
 18b86a7:	62 f1 4d 48 fa e5    	vpsubd %zmm5,%zmm6,%zmm4
 18b86ad:	62 d1 5d c9 fe e3    	vpaddd %zmm11,%zmm4,%zmm4{%k1}{z}
 18b86b3:	62 d1 5d 48 fe ec    	vpaddd %zmm12,%zmm4,%zmm5
 18b86b9:	62 d3 55 48 1e d5 01 	vpcmpltud %zmm13,%zmm5,%k2
 18b86c0:	c5 d1 ef ed          	vpxor  %xmm5,%xmm5,%xmm5
 18b86c4:	62 f2 7d 4b 90 2c d8 	vpgatherdd (%rax,%zmm3,8),%zmm5{%k3}
 18b86cb:	48 8b 84 24 08 01 00 00 	mov    0x108(%rsp),%rax
 18b86d3:	c5 ec 41 c1          	kandw  %k1,%k2,%k0
 18b86d7:	c5 78 93 e0          	kmovw  %k0,%r12d
 18b86db:	45 09 e6             	or     %r12d,%r14d
 18b86de:	4c 8b a4 24 18 01 00 00 	mov    0x118(%rsp),%r12
 18b86e6:	48 83 fb 10          	cmp    $0x10,%rbx
 18b86ea:	bb ff ff 00 00       	mov    $0xffff,%ebx
 18b86ef:	44 0f 43 cb          	cmovae %ebx,%r9d
 18b86f3:	49 83 c7 e0          	add    $0xffffffffffffffe0,%r15
 18b86f7:	62 d1 55 48 db de    	vpandd %zmm14,%zmm5,%zmm3
 18b86fd:	62 d1 65 48 76 da    	vpcmpeqd %zmm10,%zmm3,%k3
 18b8703:	62 d2 7d 43 64 df    	vpblendmd %zmm15,%zmm16,%zmm3{%k3}
 18b8709:	62 f1 7d c9 6f db    	vmovdqa32 %zmm3,%zmm3{%k1}{z}
 18b870f:	62 f1 7d ca 6f eb    	vmovdqa32 %zmm3,%zmm5{%k2}{z}
 18b8715:	62 d3 55 48 03 f0 0f 	valignd $0xf,%zmm8,%zmm5,%zmm6
 18b871c:	62 d1 fd 48 7f 5c 88 01 	vmovdqa64 %zmm3,0x40(%r8,%rcx,4)
 18b8724:	62 d1 fd 48 7f 64 8c ff 	vmovdqa64 %zmm4,-0x40(%r12,%rcx,4)
 18b872c:	62 f1 fd 48 7f 64 8a ff 	vmovdqa64 %zmm4,-0x40(%rdx,%rcx,4)
 18b8734:	c4 c1 7b 92 c9       	kmovd  %r9d,%k1
 18b8739:	62 f1 fd 48 7f 6c 88 ff 	vmovdqa64 %zmm5,-0x40(%rax,%rcx,4)
 18b8741:	c4 e1 f8 90 d9       	kmovq  %k1,%k3
 18b8746:	62 f1 4d 48 fe f5    	vpaddd %zmm5,%zmm6,%zmm6
 18b874c:	c5 d1 ef ed          	vpxor  %xmm5,%xmm5,%xmm5
 18b8750:	62 d3 cd 48 03 f8 07 	valignq $0x7,%zmm8,%zmm6,%zmm7
 18b8757:	62 f1 45 48 fe f6    	vpaddd %zmm6,%zmm7,%zmm6
 18b875d:	62 d3 cd 48 03 f8 06 	valignq $0x6,%zmm8,%zmm6,%zmm7
 18b8764:	62 f1 45 48 fe f6    	vpaddd %zmm6,%zmm7,%zmm6
 18b876a:	62 d3 cd 48 03 f8 04 	valignq $0x4,%zmm8,%zmm6,%zmm7
 18b8771:	62 f1 4d 48 fe d2    	vpaddd %zmm2,%zmm6,%zmm2
 18b8777:	62 f1 fd 48 6f f0    	vmovdqa64 %zmm0,%zmm6
 18b877d:	62 f1 6d 48 fe d7    	vpaddd %zmm7,%zmm2,%zmm2
 18b8783:	62 d1 fe 48 7f 54 8b ff 	vmovdqu64 %zmm2,-0x40(%r11,%rcx,4)
 18b878b:	62 71 fe 48 7f 44 8f ff 	vmovdqu64 %zmm8,-0x40(%rdi,%rcx,4)
 18b8793:	62 f1 7d 48 70 d2 ff 	vpshufd $0xff,%zmm2,%zmm2
 18b879a:	62 d1 7e c9 6f 64 8d 00 	vmovdqu32 0x0(%r13,%rcx,4),%zmm4{%k1}{z}
 18b87a2:	62 d1 7e c9 6f 1c 8a 	vmovdqu32 (%r10,%rcx,4),%zmm3{%k1}{z}
 18b87a9:	62 f3 ed 48 43 d2 ff 	vshufi64x2 $0xff,%zmm2,%zmm2,%zmm2
 18b87b0:	62 f3 5d 49 1e d1 01 	vpcmpltud %zmm1,%zmm4,%k2{%k1}
 18b87b7:	62 f2 7d 4b 90 2c 9e 	vpgatherdd (%rsi,%zmm3,4),%zmm5{%k3}
 18b87be:	62 f1 65 48 fe db    	vpaddd %zmm3,%zmm3,%zmm3
 18b87c4:	c4 e1 f8 90 d9       	kmovq  %k1,%k3
 18b87c9:	62 f2 7d 4a 90 34 a6 	vpgatherdd (%rsi,%zmm4,4),%zmm6{%k2}
 18b87d0:	48 8b b4 24 88 00 00 00 	mov    0x88(%rsp),%rsi
 18b87d8:	62 f1 4d 48 fa e5    	vpsubd %zmm5,%zmm6,%zmm4
 18b87de:	62 d1 5d c9 fe e3    	vpaddd %zmm11,%zmm4,%zmm4{%k1}{z}
 18b87e4:	62 d1 5d 48 fe ec    	vpaddd %zmm12,%zmm4,%zmm5
 18b87ea:	62 d3 55 48 1e d5 01 	vpcmpltud %zmm13,%zmm5,%k2
 18b87f1:	c5 d1 ef ed          	vpxor  %xmm5,%xmm5,%xmm5
 18b87f5:	c5 ec 41 c1          	kandw  %k1,%k2,%k0
 18b87f9:	c5 78 93 c8          	kmovw  %k0,%r9d
 18b87fd:	45 09 f1             	or     %r14d,%r9d
 18b8800:	4c 8b b4 24 90 00 00 00 	mov    0x90(%rsp),%r14
 18b8808:	62 d2 7d 4b 90 2c de 	vpgatherdd (%r14,%zmm3,8),%zmm5{%k3}
 18b880f:	62 d1 55 48 db de    	vpandd %zmm14,%zmm5,%zmm3
 18b8815:	62 d1 65 48 76 da    	vpcmpeqd %zmm10,%zmm3,%k3
 18b881b:	62 d2 7d 43 64 df    	vpblendmd %zmm15,%zmm16,%zmm3{%k3}
 18b8821:	62 f1 7d c9 6f db    	vmovdqa32 %zmm3,%zmm3{%k1}{z}
 18b8827:	62 f1 7d ca 6f eb    	vmovdqa32 %zmm3,%zmm5{%k2}{z}
 18b882d:	62 d3 55 48 03 f0 0f 	valignd $0xf,%zmm8,%zmm5,%zmm6
 18b8834:	62 d1 fd 48 7f 5c 88 02 	vmovdqa64 %zmm3,0x80(%r8,%rcx,4)
 18b883c:	62 d1 fd 48 7f 24 8c 	vmovdqa64 %zmm4,(%r12,%rcx,4)
 18b8843:	62 f1 fd 48 7f 24 8a 	vmovdqa64 %zmm4,(%rdx,%rcx,4)
 18b884a:	62 f1 fd 48 7f 2c 88 	vmovdqa64 %zmm5,(%rax,%rcx,4)
 18b8851:	62 f1 4d 48 fe f5    	vpaddd %zmm5,%zmm6,%zmm6
 18b8857:	62 d3 cd 48 03 f8 07 	valignq $0x7,%zmm8,%zmm6,%zmm7
 18b885e:	62 f1 45 48 fe f6    	vpaddd %zmm6,%zmm7,%zmm6
 18b8864:	62 d3 cd 48 03 f8 06 	valignq $0x6,%zmm8,%zmm6,%zmm7
 18b886b:	62 f1 45 48 fe f6    	vpaddd %zmm6,%zmm7,%zmm6
 18b8871:	62 d3 cd 48 03 f8 04 	valignq $0x4,%zmm8,%zmm6,%zmm7
 18b8878:	62 f1 4d 48 fe f7    	vpaddd %zmm7,%zmm6,%zmm6
 18b887e:	62 f1 4d 48 fe d2    	vpaddd %zmm2,%zmm6,%zmm2
 18b8884:	62 d1 fe 48 7f 14 8b 	vmovdqu64 %zmm2,(%r11,%rcx,4)
 18b888b:	62 f1 7d 48 70 d2 ff 	vpshufd $0xff,%zmm2,%zmm2
 18b8892:	62 71 fe 48 7f 04 8f 	vmovdqu64 %zmm8,(%rdi,%rcx,4)
 18b8899:	48 83 c1 20          	add    $0x20,%rcx
 18b889d:	48 83 c6 fe          	add    $0xfffffffffffffffe,%rsi
 18b88a1:	62 f3 ed 48 43 d2 ff 	vshufi64x2 $0xff,%zmm2,%zmm2,%zmm2
 18b88a8:	0f 85 42 fd ff ff    	jne    18b85f0 <tier0_benchmark_run+0xe40>
 18b88ae:	62 f2 7d 48 58 35 1c 7c cc fe 	vpbroadcastd -0x13383e4(%rip),%zmm6        # 5804d4 <tier0_emit_x87.operations+0x8c>
 18b88b8:	62 f1 fd 48 6f 3d 3e 7f c6 fe 	vmovdqa64 -0x13980c2(%rip),%zmm7        # 520800 <branch_sizing_patterns+0xa70>
 18b88c2:	62 e2 7d 48 5a 0d 34 d4 cb fe 	vbroadcasti32x4 -0x1342bcc(%rip),%zmm17        # 575d00 <x86_effects_unknown+0x2a0>
 18b88cc:	f6 84 24 d8 00 00 00 10 	testb  $0x10,0xd8(%rsp)
 18b88d4:	48 8b 7c 24 30       	mov    0x30(%rsp),%rdi
 18b88d9:	4c 8b 5c 24 58       	mov    0x58(%rsp),%r11
 18b88de:	4c 8b a4 24 b0 00 00 00 	mov    0xb0(%rsp),%r12
 18b88e6:	4c 8b 84 24 a0 00 00 00 	mov    0xa0(%rsp),%r8
 18b88ee:	41 bf 00 00 00 00    	mov    $0x0,%r15d
 18b88f4:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
 18b88f9:	41 bd ff ff 00 00    	mov    $0xffff,%r13d
 18b88ff:	62 51 fd 48 6f d4    	vmovdqa64 %zmm12,%zmm10
 18b8905:	62 51 fd 48 6f dd    	vmovdqa64 %zmm13,%zmm11
 18b890b:	74 26                	je     18b8933 <tier0_benchmark_run+0x1183>
 18b890d:	e9 67 01 00 00       	jmp    18b8a79 <tier0_benchmark_run+0x12c9>
 18b8912:	4c 8b 5c 24 58       	mov    0x58(%rsp),%r11
 18b8917:	4c 8b 84 24 a0 00 00 00 	mov    0xa0(%rsp),%r8
 18b891f:	45 31 c9             	xor    %r9d,%r9d
 18b8922:	c5 e9 ef d2          	vpxor  %xmm2,%xmm2,%xmm2
 18b8926:	31 c9                	xor    %ecx,%ecx
 18b8928:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
 18b892d:	41 bd ff ff 00 00    	mov    $0xffff,%r13d
 18b8933:	48 89 f8             	mov    %rdi,%rax
 18b8936:	48 29 c8             	sub    %rcx,%rax
 18b8939:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
 18b893e:	c5 d1 ef ed          	vpxor  %xmm5,%xmm5,%xmm5
 18b8942:	48 83 f8 10          	cmp    $0x10,%rax
 18b8946:	c4 e2 79 f7 c3       	shlx   %eax,%ebx,%eax
 18b894b:	f7 d0                	not    %eax
 18b894d:	41 0f 43 c5          	cmovae %r13d,%eax
 18b8951:	c5 fb 92 c8          	kmovd  %eax,%k1
 18b8955:	48 8b 84 24 a8 00 00 00 	mov    0xa8(%rsp),%rax
 18b895d:	62 f1 7e c9 6f 1c 8a 	vmovdqu32 (%rdx,%rcx,4),%zmm3{%k1}{z}
 18b8964:	c4 e1 f8 90 d1       	kmovq  %k1,%k2
 18b8969:	c4 e1 f8 90 d9       	kmovq  %k1,%k3
 18b896e:	62 71 7e c9 6f 24 88 	vmovdqu32 (%rax,%rcx,4),%zmm12{%k1}{z}
 18b8975:	62 f1 65 48 fe e3    	vpaddd %zmm3,%zmm3,%zmm4
 18b897b:	62 d2 7d 4a 90 2c e6 	vpgatherdd (%r14,%zmm4,8),%zmm5{%k2}
 18b8982:	62 f3 1d 49 1e d1 01 	vpcmpltud %zmm1,%zmm12,%k2{%k1}
 18b8989:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
 18b898d:	62 d2 7d 4b 90 0c 9b 	vpgatherdd (%r11,%zmm3,4),%zmm1{%k3}
 18b8994:	62 f1 55 58 db 1d 82 7b cc fe 	vpandd -0x133847e(%rip){1to16},%zmm5,%zmm3        # 580520 <tier0_emit_x87.operations+0xd8>
 18b899e:	62 92 7d 4a 90 04 a3 	vpgatherdd (%r11,%zmm12,4),%zmm0{%k2}
 18b89a5:	62 f1 65 58 76 15 75 7b cc fe 	vpcmpeqd -0x133848b(%rip){1to16},%zmm3,%k2        # 580524 <tier0_emit_x87.operations+0xdc>
 18b89af:	62 f1 7d 48 fa c1    	vpsubd %zmm1,%zmm0,%zmm0
 18b89b5:	62 f2 7d 52 64 0d 69 7b cc fe 	vpblendmd -0x1338497(%rip){1to16},%zmm16,%zmm1{%k2}        # 580528 <tier0_emit_x87.operations+0xe0>
 18b89bf:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
 18b89c4:	48 8b b4 24 e8 00 00 00 	mov    0xe8(%rsp),%rsi
 18b89cc:	48 8b 94 24 e0 00 00 00 	mov    0xe0(%rsp),%rdx
 18b89d4:	62 f1 7d d9 fe 05 4e 7b cc fe 	vpaddd -0x13384b2(%rip){1to16},%zmm0,%zmm0{%k1}{z}        # 58052c <tier0_emit_x87.operations+0xe4>
 18b89de:	62 f1 7d c9 6f c9    	vmovdqa32 %zmm1,%zmm1{%k1}{z}
 18b89e4:	62 f1 fd 48 7f 0c 88 	vmovdqa64 %zmm1,(%rax,%rcx,4)
 18b89eb:	48 8b 84 24 c0 00 00 00 	mov    0xc0(%rsp),%rax
 18b89f3:	62 f1 fd 48 7f 04 8e 	vmovdqa64 %zmm0,(%rsi,%rcx,4)
 18b89fa:	62 f1 fd 48 7f 04 8a 	vmovdqa64 %zmm0,(%rdx,%rcx,4)
 18b8a01:	62 d1 7d 48 fe c2    	vpaddd %zmm10,%zmm0,%zmm0
 18b8a07:	62 d3 7d 48 1e d3 01 	vpcmpltud %zmm11,%zmm0,%k2
 18b8a0e:	62 f1 7d ca 6f c1    	vmovdqa32 %zmm1,%zmm0{%k2}{z}
 18b8a14:	62 d3 7d 48 03 c8 0f 	valignd $0xf,%zmm8,%zmm0,%zmm1
 18b8a1b:	c5 ec 41 c1          	kandw  %k1,%k2,%k0
 18b8a1f:	62 d1 fd 48 7f 04 8c 	vmovdqa64 %zmm0,(%r12,%rcx,4)
 18b8a26:	62 f1 75 48 fe c8    	vpaddd %zmm0,%zmm1,%zmm1
 18b8a2c:	62 d3 f5 48 03 d8 07 	valignq $0x7,%zmm8,%zmm1,%zmm3
 18b8a33:	62 f1 65 48 fe c9    	vpaddd %zmm1,%zmm3,%zmm1
 18b8a39:	62 d3 f5 48 03 d8 06 	valignq $0x6,%zmm8,%zmm1,%zmm3
 18b8a40:	62 f1 65 48 fe c9    	vpaddd %zmm1,%zmm3,%zmm1
 18b8a46:	62 d3 f5 48 03 d8 04 	valignq $0x4,%zmm8,%zmm1,%zmm3
 18b8a4d:	62 f1 75 48 fe ca    	vpaddd %zmm2,%zmm1,%zmm1
 18b8a53:	62 f1 75 48 fe cb    	vpaddd %zmm3,%zmm1,%zmm1
 18b8a59:	62 d1 fe 48 7f 8c 88 04 00 00 00 	vmovdqu64 %zmm1,0x4(%r8,%rcx,4)
 18b8a64:	62 71 fe 48 7f 84 88 04 00 00 00 	vmovdqu64 %zmm8,0x4(%rax,%rcx,4)
 18b8a6f:	44 89 c9             	mov    %r9d,%ecx
 18b8a72:	c5 78 93 c8          	kmovw  %k0,%r9d
 18b8a76:	41 09 c9             	or     %ecx,%r9d
 18b8a79:	4c 8b 74 24 78       	mov    0x78(%rsp),%r14
 18b8a7e:	45 85 c9             	test   %r9d,%r9d
 18b8a81:	0f 84 08 07 00 00    	je     18b918f <tier0_benchmark_run+0x19df>
 18b8a87:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
 18b8a8c:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
 18b8a91:	81 e2 c0 ff ff 1f    	and    $0x1fffffc0,%edx
 18b8a97:	31 f6                	xor    %esi,%esi
 18b8a99:	48 83 c2 40          	add    $0x40,%rdx
 18b8a9d:	c5 f8 77             	vzeroupper
 18b8aa0:	e8 8b b8 ea fe       	call   764330 <memset@plt>
 18b8aa5:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
 18b8aaa:	89 d0                	mov    %edx,%eax
 18b8aac:	83 e0 07             	and    $0x7,%eax
 18b8aaf:	83 fa 08             	cmp    $0x8,%edx
 18b8ab2:	73 61                	jae    18b8b15 <tier0_benchmark_run+0x1365>
 18b8ab4:	62 f2 7d 48 58 05 16 7a cc fe 	vpbroadcastd -0x13385ea(%rip),%zmm0        # 5804d4 <tier0_emit_x87.operations+0x8c>
 18b8abe:	62 f1 fd 48 6f 0d 38 7d c6 fe 	vmovdqa64 -0x13982c8(%rip),%zmm1        # 520800 <branch_sizing_patterns+0xa70>
 18b8ac8:	62 e2 7d 48 5a 0d 2e d2 cb fe 	vbroadcasti32x4 -0x1342dd2(%rip),%zmm17        # 575d00 <x86_effects_unknown+0x2a0>
 18b8ad2:	62 f2 7d 48 5a 15 44 d2 cb fe 	vbroadcasti32x4 -0x1342dbc(%rip),%zmm2        # 575d20 <x86_effects_unknown+0x2c0>
 18b8adc:	62 72 7d 48 5a 3d 2a d2 cb fe 	vbroadcasti32x4 -0x1342dd6(%rip),%zmm15        # 575d10 <x86_effects_unknown+0x2b0>
 18b8ae6:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
 18b8aeb:	4c 8b 44 24 10       	mov    0x10(%rsp),%r8
 18b8af0:	4c 8b 4c 24 18       	mov    0x18(%rsp),%r9
 18b8af5:	4c 8b 5c 24 60       	mov    0x60(%rsp),%r11
 18b8afa:	4c 8b bc 24 c8 00 00 00 	mov    0xc8(%rsp),%r15
 18b8b02:	31 c9                	xor    %ecx,%ecx
 18b8b04:	c4 41 39 ef c0       	vpxor  %xmm8,%xmm8,%xmm8
 18b8b09:	62 f3 45 48 25 ff ff 	vpternlogd $0xff,%zmm7,%zmm7,%zmm7
 18b8b10:	e9 c3 00 00 00       	jmp    18b8bd8 <tier0_benchmark_run+0x1428>
 18b8b15:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
 18b8b1a:	4c 8b 44 24 10       	mov    0x10(%rsp),%r8
 18b8b1f:	4c 8b 5c 24 60       	mov    0x60(%rsp),%r11
 18b8b24:	4c 8b bc 24 c8 00 00 00 	mov    0xc8(%rsp),%r15
 18b8b2c:	83 e2 f8             	and    $0xfffffff8,%edx
 18b8b2f:	31 c9                	xor    %ecx,%ecx
 18b8b31:	66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 18b8b40:	8b 34 8f             	mov    (%rdi,%rcx,4),%esi
 18b8b43:	41 c6 04 30 01       	movb   $0x1,(%r8,%rsi,1)
 18b8b48:	8b 74 8f 04          	mov    0x4(%rdi,%rcx,4),%esi
 18b8b4c:	41 c6 04 30 01       	movb   $0x1,(%r8,%rsi,1)
 18b8b51:	8b 74 8f 08          	mov    0x8(%rdi,%rcx,4),%esi
 18b8b55:	41 c6 04 30 01       	movb   $0x1,(%r8,%rsi,1)
 18b8b5a:	8b 74 8f 0c          	mov    0xc(%rdi,%rcx,4),%esi
 18b8b5e:	41 c6 04 30 01       	movb   $0x1,(%r8,%rsi,1)
 18b8b63:	8b 74 8f 10          	mov    0x10(%rdi,%rcx,4),%esi
 18b8b67:	41 c6 04 30 01       	movb   $0x1,(%r8,%rsi,1)
 18b8b6c:	8b 74 8f 14          	mov    0x14(%rdi,%rcx,4),%esi
 18b8b70:	41 c6 04 30 01       	movb   $0x1,(%r8,%rsi,1)
 18b8b75:	8b 74 8f 18          	mov    0x18(%rdi,%rcx,4),%esi
 18b8b79:	41 c6 04 30 01       	movb   $0x1,(%r8,%rsi,1)
 18b8b7e:	8b 74 8f 1c          	mov    0x1c(%rdi,%rcx,4),%esi
 18b8b82:	48 83 c1 08          	add    $0x8,%rcx
 18b8b86:	41 c6 04 30 01       	movb   $0x1,(%r8,%rsi,1)
 18b8b8b:	48 39 ca             	cmp    %rcx,%rdx
 18b8b8e:	75 b0                	jne    18b8b40 <tier0_benchmark_run+0x1390>
 18b8b90:	62 f2 7d 48 58 05 3a 79 cc fe 	vpbroadcastd -0x13386c6(%rip),%zmm0        # 5804d4 <tier0_emit_x87.operations+0x8c>
 18b8b9a:	62 f1 fd 48 6f 0d 5c 7c c6 fe 	vmovdqa64 -0x13983a4(%rip),%zmm1        # 520800 <branch_sizing_patterns+0xa70>
 18b8ba4:	62 e2 7d 48 5a 0d 52 d1 cb fe 	vbroadcasti32x4 -0x1342eae(%rip),%zmm17        # 575d00 <x86_effects_unknown+0x2a0>
 18b8bae:	62 f2 7d 48 5a 15 68 d1 cb fe 	vbroadcasti32x4 -0x1342e98(%rip),%zmm2        # 575d20 <x86_effects_unknown+0x2c0>
 18b8bb8:	62 72 7d 48 5a 3d 4e d1 cb fe 	vbroadcasti32x4 -0x1342eb2(%rip),%zmm15        # 575d10 <x86_effects_unknown+0x2b0>
 18b8bc2:	4c 8b 4c 24 18       	mov    0x18(%rsp),%r9
 18b8bc7:	62 f3 45 48 25 ff ff 	vpternlogd $0xff,%zmm7,%zmm7,%zmm7
 18b8bce:	c4 41 39 ef c0       	vpxor  %xmm8,%xmm8,%xmm8
 18b8bd3:	48 85 c0             	test   %rax,%rax
 18b8bd6:	74 18                	je     18b8bf0 <tier0_benchmark_run+0x1440>
 18b8bd8:	48 8d 0c 8f          	lea    (%rdi,%rcx,4),%rcx
 18b8bdc:	31 d2                	xor    %edx,%edx
 18b8bde:	66 90                	xchg   %ax,%ax
 18b8be0:	8b 34 91             	mov    (%rcx,%rdx,4),%esi
 18b8be3:	48 ff c2             	inc    %rdx
 18b8be6:	41 c6 04 30 01       	movb   $0x1,(%r8,%rsi,1)
 18b8beb:	48 39 d0             	cmp    %rdx,%rax
 18b8bee:	75 f0                	jne    18b8be0 <tier0_benchmark_run+0x1430>
 18b8bf0:	62 72 7d 48 58 15 36 79 cc fe 	vpbroadcastd -0x13386ca(%rip),%zmm10        # 580530 <tier0_emit_x87.operations+0xe8>
 18b8bfa:	62 72 7d 48 58 1d 30 79 cc fe 	vpbroadcastd -0x13386d0(%rip),%zmm11        # 580534 <tier0_emit_x87.operations+0xec>
 18b8c04:	62 f1 fd 48 6f 25 72 7d c6 fe 	vmovdqa64 -0x139828e(%rip),%zmm4        # 520980 <branch_sizing_patterns+0xbf0>
 18b8c0e:	62 f1 fd 48 6f 2d a8 7d c6 fe 	vmovdqa64 -0x1398258(%rip),%zmm5        # 5209c0 <branch_sizing_patterns+0xc30>
 18b8c18:	62 f2 7d 48 58 35 16 79 cc fe 	vpbroadcastd -0x13386ea(%rip),%zmm6        # 580538 <tier0_emit_x87.operations+0xf0>
 18b8c22:	44 89 f8             	mov    %r15d,%eax
 18b8c25:	83 e0 03             	and    $0x3,%eax
 18b8c28:	62 71 fd 48 6f c8    	vmovdqa64 %zmm0,%zmm9
 18b8c2e:	62 71 fd 48 6f e9    	vmovdqa64 %zmm1,%zmm13
 18b8c34:	41 81 f9 c0 00 00 00 	cmp    $0xc0,%r9d
 18b8c3b:	73 0f                	jae    18b8c4c <tier0_benchmark_run+0x149c>
 18b8c3d:	31 ff                	xor    %edi,%edi
 18b8c3f:	31 c9                	xor    %ecx,%ecx
 18b8c41:	62 71 fd 48 6f e2    	vmovdqa64 %zmm2,%zmm12
 18b8c47:	e9 54 01 00 00       	jmp    18b8da0 <tier0_benchmark_run+0x15f0>
 18b8c4c:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
 18b8c51:	c1 e1 06             	shl    $0x6,%ecx
 18b8c54:	41 81 e7 fc ff ff 00 	and    $0xfffffc,%r15d
 18b8c5b:	49 8d 90 c0 00 00 00 	lea    0xc0(%r8),%rdx
 18b8c62:	31 ff                	xor    %edi,%edi
 18b8c64:	62 71 fd 48 6f e2    	vmovdqa64 %zmm2,%zmm12
 18b8c6a:	49 8d 74 08 78       	lea    0x78(%r8,%rcx,1),%rsi
 18b8c6f:	31 c9                	xor    %ecx,%ecx
 18b8c71:	66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 18b8c80:	62 f1 fd 48 6f 42 fd 	vmovdqa64 -0xc0(%rdx),%zmm0
 18b8c87:	48 83 c1 04          	add    $0x4,%rcx
 18b8c8b:	62 f2 7d 48 26 c0    	vptestmb %zmm0,%zmm0,%k0
 18b8c91:	c4 61 fb 93 c0       	kmovq  %k0,%r8
 18b8c96:	f3 45 0f b8 d0       	popcnt %r8d,%r10d
 18b8c9b:	45 89 c1             	mov    %r8d,%r9d
 18b8c9e:	49 01 fa             	add    %rdi,%r10
 18b8ca1:	48 c1 e7 20          	shl    $0x20,%rdi
 18b8ca5:	4d 89 d3             	mov    %r10,%r11
 18b8ca8:	4d 0f a4 c3 20       	shld   $0x20,%r8,%r11
 18b8cad:	4c 09 cf             	or     %r9,%rdi
 18b8cb0:	49 c1 e8 20          	shr    $0x20,%r8
 18b8cb4:	48 89 7e c8          	mov    %rdi,-0x38(%rsi)
 18b8cb8:	f3 41 0f b8 f8       	popcnt %r8d,%edi
 18b8cbd:	4c 89 5e d0          	mov    %r11,-0x30(%rsi)
 18b8cc1:	4c 01 d7             	add    %r10,%rdi
 18b8cc4:	62 f1 fd 48 6f 42 fe 	vmovdqa64 -0x80(%rdx),%zmm0
 18b8ccb:	62 f2 7d 48 26 c0    	vptestmb %zmm0,%zmm0,%k0
 18b8cd1:	c4 61 fb 93 c0       	kmovq  %k0,%r8
 18b8cd6:	f3 45 0f b8 d0       	popcnt %r8d,%r10d
 18b8cdb:	45 89 c1             	mov    %r8d,%r9d
 18b8cde:	49 01 fa             	add    %rdi,%r10
 18b8ce1:	48 c1 e7 20          	shl    $0x20,%rdi
 18b8ce5:	4d 89 d3             	mov    %r10,%r11
 18b8ce8:	4d 0f a4 c3 20       	shld   $0x20,%r8,%r11
 18b8ced:	4c 09 cf             	or     %r9,%rdi
 18b8cf0:	49 c1 e8 20          	shr    $0x20,%r8
 18b8cf4:	48 89 7e d8          	mov    %rdi,-0x28(%rsi)
 18b8cf8:	f3 41 0f b8 f8       	popcnt %r8d,%edi
 18b8cfd:	4c 89 5e e0          	mov    %r11,-0x20(%rsi)
 18b8d01:	4c 01 d7             	add    %r10,%rdi
 18b8d04:	62 f1 fd 48 6f 42 ff 	vmovdqa64 -0x40(%rdx),%zmm0
 18b8d0b:	62 f2 7d 48 26 c0    	vptestmb %zmm0,%zmm0,%k0
 18b8d11:	c4 61 fb 93 c0       	kmovq  %k0,%r8
 18b8d16:	f3 45 0f b8 d0       	popcnt %r8d,%r10d
 18b8d1b:	45 89 c1             	mov    %r8d,%r9d
 18b8d1e:	49 01 fa             	add    %rdi,%r10
 18b8d21:	48 c1 e7 20          	shl    $0x20,%rdi
 18b8d25:	4d 89 d3             	mov    %r10,%r11
 18b8d28:	4d 0f a4 c3 20       	shld   $0x20,%r8,%r11
 18b8d2d:	4c 09 cf             	or     %r9,%rdi
 18b8d30:	49 c1 e8 20          	shr    $0x20,%r8
 18b8d34:	48 89 7e e8          	mov    %rdi,-0x18(%rsi)
 18b8d38:	f3 41 0f b8 f8       	popcnt %r8d,%edi
 18b8d3d:	4c 89 5e f0          	mov    %r11,-0x10(%rsi)
 18b8d41:	4c 01 d7             	add    %r10,%rdi
 18b8d44:	62 f1 fd 48 6f 02    	vmovdqa64 (%rdx),%zmm0
 18b8d4a:	48 81 c2 00 01 00 00 	add    $0x100,%rdx
 18b8d51:	62 f2 7d 48 26 c0    	vptestmb %zmm0,%zmm0,%k0
 18b8d57:	c4 61 fb 93 c0       	kmovq  %k0,%r8
 18b8d5c:	f3 45 0f b8 d0       	popcnt %r8d,%r10d
 18b8d61:	45 89 c1             	mov    %r8d,%r9d
 18b8d64:	49 01 fa             	add    %rdi,%r10
 18b8d67:	48 c1 e7 20          	shl    $0x20,%rdi
 18b8d6b:	4c 09 cf             	or     %r9,%rdi
 18b8d6e:	48 89 7e f8          	mov    %rdi,-0x8(%rsi)
 18b8d72:	4c 89 d7             	mov    %r10,%rdi
 18b8d75:	4c 0f a4 c7 20       	shld   $0x20,%r8,%rdi
 18b8d7a:	49 c1 e8 20          	shr    $0x20,%r8
 18b8d7e:	48 89 3e             	mov    %rdi,(%rsi)
 18b8d81:	f3 41 0f b8 f8       	popcnt %r8d,%edi
 18b8d86:	48 83 c6 40          	add    $0x40,%rsi
 18b8d8a:	4c 01 d7             	add    %r10,%rdi
 18b8d8d:	49 39 cf             	cmp    %rcx,%r15
 18b8d90:	0f 85 ea fe ff ff    	jne    18b8c80 <tier0_benchmark_run+0x14d0>
 18b8d96:	4c 8b 5c 24 60       	mov    0x60(%rsp),%r11
 18b8d9b:	48 85 c0             	test   %rax,%rax
 18b8d9e:	74 7a                	je     18b8e1a <tier0_benchmark_run+0x166a>
 18b8da0:	4c 8b 44 24 10       	mov    0x10(%rsp),%r8
 18b8da5:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
 18b8daa:	48 89 ce             	mov    %rcx,%rsi
 18b8dad:	c1 e2 06             	shl    $0x6,%edx
 18b8db0:	48 c1 e6 04          	shl    $0x4,%rsi
 18b8db4:	48 c1 e1 06          	shl    $0x6,%rcx
 18b8db8:	c1 e0 04             	shl    $0x4,%eax
 18b8dbb:	48 01 d6             	add    %rdx,%rsi
 18b8dbe:	49 8d 54 30 48       	lea    0x48(%r8,%rsi,1),%rdx
 18b8dc3:	4c 01 c1             	add    %r8,%rcx
 18b8dc6:	31 f6                	xor    %esi,%esi
 18b8dc8:	0f 1f 84 00 00 00 00 00 	nopl   0x0(%rax,%rax,1)
 18b8dd0:	62 f1 fd 48 6f 04 b1 	vmovdqa64 (%rcx,%rsi,4),%zmm0
 18b8dd7:	62 f2 7d 48 26 c0    	vptestmb %zmm0,%zmm0,%k0
 18b8ddd:	c4 61 fb 93 c0       	kmovq  %k0,%r8
 18b8de2:	f3 45 0f b8 d0       	popcnt %r8d,%r10d
 18b8de7:	45 89 c1             	mov    %r8d,%r9d
 18b8dea:	49 01 fa             	add    %rdi,%r10
 18b8ded:	48 c1 e7 20          	shl    $0x20,%rdi
 18b8df1:	4c 09 cf             	or     %r9,%rdi
 18b8df4:	48 89 7c 32 f8       	mov    %rdi,-0x8(%rdx,%rsi,1)
 18b8df9:	4c 89 d7             	mov    %r10,%rdi
 18b8dfc:	4c 0f a4 c7 20       	shld   $0x20,%r8,%rdi
 18b8e01:	49 c1 e8 20          	shr    $0x20,%r8
 18b8e05:	48 89 3c 32          	mov    %rdi,(%rdx,%rsi,1)
 18b8e09:	f3 41 0f b8 f8       	popcnt %r8d,%edi
 18b8e0e:	48 83 c6 10          	add    $0x10,%rsi
 18b8e12:	4c 01 d7             	add    %r10,%rdi
 18b8e15:	48 39 f0             	cmp    %rsi,%rax
 18b8e18:	75 b6                	jne    18b8dd0 <tier0_benchmark_run+0x1620>
 18b8e1a:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
 18b8e1f:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
 18b8e24:	c1 e1 06             	shl    $0x6,%ecx
 18b8e27:	4c 8b 4c 24 10       	mov    0x10(%rsp),%r9
 18b8e2c:	48 8b 7c 24 30       	mov    0x30(%rsp),%rdi
 18b8e31:	4c 8b 94 24 a8 00 00 00 	mov    0xa8(%rsp),%r10
 18b8e39:	31 f6                	xor    %esi,%esi
 18b8e3b:	48 01 c0             	add    %rax,%rax
 18b8e3e:	48 89 fa             	mov    %rdi,%rdx
 18b8e41:	48 01 c1             	add    %rax,%rcx
 18b8e44:	48 03 4c 24 40       	add    0x40(%rsp),%rcx
 18b8e49:	49 8d 4c 09 40       	lea    0x40(%r9,%rcx,1),%rcx
 18b8e4e:	66 90                	xchg   %ax,%ax
 18b8e50:	41 89 d0             	mov    %edx,%r8d
 18b8e53:	48 83 ea 10          	sub    $0x10,%rdx
 18b8e57:	c5 e9 ef d2          	vpxor  %xmm2,%xmm2,%xmm2
 18b8e5b:	c5 e1 ef db          	vpxor  %xmm3,%xmm3,%xmm3
 18b8e5f:	c4 62 39 f7 c3       	shlx   %r8d,%ebx,%r8d
 18b8e64:	41 f7 d0             	not    %r8d
 18b8e67:	45 0f 43 c5          	cmovae %r13d,%r8d
 18b8e6b:	c4 c1 7b 92 c8       	kmovd  %r8d,%k1
 18b8e70:	41 c1 e8 08          	shr    $0x8,%r8d
 18b8e74:	62 d1 7e c9 6f 04 b2 	vmovdqu32 (%r10,%rsi,4),%zmm0{%k1}{z}
 18b8e7b:	62 f1 75 48 72 d0 05 	vpsrld $0x5,%zmm0,%zmm1
 18b8e82:	62 f1 7d 48 db c6    	vpandd %zmm6,%zmm0,%zmm0
 18b8e88:	62 d2 fd 49 90 14 ce 	vpgatherdq (%r14,%ymm1,8),%zmm2{%k1}
 18b8e8f:	62 f3 fd 48 3b c9 01 	vextracti64x4 $0x1,%zmm1,%ymm1
 18b8e96:	c4 c1 7b 92 c8       	kmovd  %r8d,%k1
 18b8e9b:	62 f2 45 48 47 c0    	vpsllvd %zmm0,%zmm7,%zmm0
 18b8ea1:	62 d2 fd 49 90 1c ce 	vpgatherdq (%r14,%ymm1,8),%zmm3{%k1}
 18b8ea8:	62 f1 fd 48 6f ca    	vmovdqa64 %zmm2,%zmm1
 18b8eae:	62 f2 5d 48 7e cb    	vpermt2d %zmm3,%zmm4,%zmm1
 18b8eb4:	62 f2 55 48 7e d3    	vpermt2d %zmm3,%zmm5,%zmm2
 18b8eba:	62 f1 7d 48 df c1    	vpandnd %zmm1,%zmm0,%zmm0
 18b8ec0:	62 f2 7d 48 55 c0    	vpopcntd %zmm0,%zmm0
 18b8ec6:	62 f1 7d 48 fe c2    	vpaddd %zmm2,%zmm0,%zmm0
 18b8ecc:	62 f1 fd 48 7f 04 b1 	vmovdqa64 %zmm0,(%rcx,%rsi,4)
 18b8ed3:	48 83 c6 10          	add    $0x10,%rsi
 18b8ed7:	48 39 fe             	cmp    %rdi,%rsi
 18b8eda:	0f 82 70 ff ff ff    	jb     18b8e50 <tier0_benchmark_run+0x16a0>
 18b8ee0:	4c 8b 44 24 70       	mov    0x70(%rsp),%r8
 18b8ee5:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
 18b8eea:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
 18b8eef:	c1 e1 06             	shl    $0x6,%ecx
 18b8ef2:	62 d1 fd 48 6f f1    	vmovdqa64 %zmm9,%zmm6
 18b8ef8:	45 31 f6             	xor    %r14d,%r14d
 18b8efb:	62 d1 fd 48 6f fd    	vmovdqa64 %zmm13,%zmm7
 18b8f01:	62 51 fd 48 6f cf    	vmovdqa64 %zmm15,%zmm9
 18b8f07:	48 01 c8             	add    %rcx,%rax
 18b8f0a:	4b 8d 14 40          	lea    (%r8,%r8,2),%rdx
 18b8f0e:	49 01 c8             	add    %rcx,%r8
 18b8f11:	48 01 f0             	add    %rsi,%rax
 18b8f14:	49 01 f0             	add    %rsi,%r8
 18b8f17:	49 8d 5c 01 40       	lea    0x40(%r9,%rax,1),%rbx
 18b8f1c:	b8 01 00 00 00       	mov    $0x1,%eax
 18b8f21:	48 01 ca             	add    %rcx,%rdx
 18b8f24:	4f 8d 6c 01 40       	lea    0x40(%r9,%r8,1),%r13
 18b8f29:	48 01 f2             	add    %rsi,%rdx
 18b8f2c:	4d 8d 7c 11 40       	lea    0x40(%r9,%rdx,1),%r15
 18b8f31:	48 8b 94 24 98 00 00 00 	mov    0x98(%rsp),%rdx
 18b8f39:	48 01 ca             	add    %rcx,%rdx
 18b8f3c:	31 c9                	xor    %ecx,%ecx
 18b8f3e:	48 01 f2             	add    %rsi,%rdx
 18b8f41:	4d 8d 64 11 40       	lea    0x40(%r9,%rdx,1),%r12
 18b8f46:	66 2e 0f 1f 84 00 00 00 00 00 	cs nopw 0x0(%rax,%rax,1)
 18b8f50:	83 f8 04             	cmp    $0x4,%eax
 18b8f53:	89 84 24 90 00 00 00 	mov    %eax,0x90(%rsp)
 18b8f5a:	0f 92 c0             	setb   %al
 18b8f5d:	08 c8                	or     %cl,%al
 18b8f5f:	a8 01                	test   $0x1,%al
 18b8f61:	74 1d                	je     18b8f80 <tier0_benchmark_run+0x17d0>
 18b8f63:	44 89 f0             	mov    %r14d,%eax
 18b8f66:	48 8b 84 c4 a0 01 00 00 	mov    0x1a0(%rsp,%rax,8),%rax
 18b8f6e:	41 83 f6 01          	xor    $0x1,%r14d
 18b8f72:	e9 f9 00 00 00       	jmp    18b9070 <tier0_benchmark_run+0x18c0>
 18b8f77:	66 0f 1f 84 00 00 00 00 00 	nopw   0x0(%rax,%rax,1)
 18b8f80:	48 8d b4 24 68 01 00 00 	lea    0x168(%rsp),%rsi
 18b8f88:	44 89 f2             	mov    %r14d,%edx
 18b8f8b:	c5 f8 77             	vzeroupper
 18b8f8e:	e8 5d d0 04 00       	call   1905ff0 <branch_sizing_worklist>
 18b8f93:	44 89 f0             	mov    %r14d,%eax
 18b8f96:	83 f0 01             	xor    $0x1,%eax
 18b8f99:	48 8b 7c 24 30       	mov    0x30(%rsp),%rdi
 18b8f9e:	c4 41 39 ef c0       	vpxor  %xmm8,%xmm8,%xmm8
 18b8fa3:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 18b8fa7:	31 c9                	xor    %ecx,%ecx
 18b8fa9:	48 8b 84 c4 a0 01 00 00 	mov    0x1a0(%rsp,%rax,8),%rax
 18b8fb1:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
 18b8fb7:	66 0f 1f 84 00 00 00 00 00 	nopw   0x0(%rax,%rax,1)
 18b8fc0:	62 d1 fd 48 6f 0c 8f 	vmovdqa64 (%r15,%rcx,4),%zmm1
 18b8fc7:	62 d3 75 48 03 d0 0f 	valignd $0xf,%zmm8,%zmm1,%zmm2
 18b8fce:	62 f1 6d 48 fe c9    	vpaddd %zmm1,%zmm2,%zmm1
 18b8fd4:	62 d3 f5 48 03 d0 07 	valignq $0x7,%zmm8,%zmm1,%zmm2
 18b8fdb:	62 f1 6d 48 fe c9    	vpaddd %zmm1,%zmm2,%zmm1
 18b8fe1:	62 d3 f5 48 03 d0 06 	valignq $0x6,%zmm8,%zmm1,%zmm2
 18b8fe8:	62 f1 6d 48 fe c9    	vpaddd %zmm1,%zmm2,%zmm1
 18b8fee:	62 d3 f5 48 03 d0 04 	valignq $0x4,%zmm8,%zmm1,%zmm2
 18b8ff5:	62 f1 75 48 fe c0    	vpaddd %zmm0,%zmm1,%zmm0
 18b8ffb:	62 f1 7d 48 fe c2    	vpaddd %zmm2,%zmm0,%zmm0
 18b9001:	62 f1 fe 48 7f 84 88 04 00 00 00 	vmovdqu64 %zmm0,0x4(%rax,%rcx,4)
 18b900c:	62 f1 7d 48 70 c0 ff 	vpshufd $0xff,%zmm0,%zmm0
 18b9013:	48 83 c1 10          	add    $0x10,%rcx
 18b9017:	62 f3 fd 48 43 c0 ff 	vshufi64x2 $0xff,%zmm0,%zmm0,%zmm0
 18b901e:	48 39 f9             	cmp    %rdi,%rcx
 18b9021:	72 9d                	jb     18b8fc0 <tier0_benchmark_run+0x1810>
 18b9023:	62 f2 7d 48 58 35 a7 74 cc fe 	vpbroadcastd -0x1338b59(%rip),%zmm6        # 5804d4 <tier0_emit_x87.operations+0x8c>
 18b902d:	62 f1 fd 48 6f 3d c9 77 c6 fe 	vmovdqa64 -0x1398837(%rip),%zmm7        # 520800 <branch_sizing_patterns+0xa70>
 18b9037:	62 e2 7d 48 5a 0d bf cc cb fe 	vbroadcasti32x4 -0x1343341(%rip),%zmm17        # 575d00 <x86_effects_unknown+0x2a0>
 18b9041:	62 72 7d 48 5a 25 d5 cc cb fe 	vbroadcasti32x4 -0x134332b(%rip),%zmm12        # 575d20 <x86_effects_unknown+0x2c0>
 18b904b:	62 72 7d 48 5a 0d bb cc cb fe 	vbroadcasti32x4 -0x1343345(%rip),%zmm9        # 575d10 <x86_effects_unknown+0x2b0>
 18b9055:	62 72 7d 48 58 15 d1 74 cc fe 	vpbroadcastd -0x1338b2f(%rip),%zmm10        # 580530 <tier0_emit_x87.operations+0xe8>
 18b905f:	62 72 7d 48 58 1d cb 74 cc fe 	vpbroadcastd -0x1338b35(%rip),%zmm11        # 580534 <tier0_emit_x87.operations+0xec>
 18b9069:	4c 8b 5c 24 60       	mov    0x60(%rsp),%r11
 18b906e:	b1 01                	mov    $0x1,%cl
 18b9070:	44 89 f2             	mov    %r14d,%edx
 18b9073:	4c 8b 84 d4 a0 01 00 00 	mov    0x1a0(%rsp,%rdx,8),%r8
 18b907b:	45 89 f2             	mov    %r14d,%r10d
 18b907e:	31 d2                	xor    %edx,%edx
 18b9080:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 18b9084:	31 f6                	xor    %esi,%esi
 18b9086:	41 c7 00 00 00 00 00 	movl   $0x0,(%r8)
 18b908d:	0f 1f 00             	nopl   (%rax)
 18b9090:	62 f1 fd 48 6f 0c 93 	vmovdqa64 (%rbx,%rdx,4),%zmm1
 18b9097:	c5 fc 46 c8          	kxnorw %k0,%k0,%k1
 18b909b:	c5 e1 ef db          	vpxor  %xmm3,%xmm3,%xmm3
 18b909f:	62 d1 fd 48 6f 14 97 	vmovdqa64 (%r15,%rdx,4),%zmm2
 18b90a6:	4d 89 c1             	mov    %r8,%r9
 18b90a9:	62 f2 7d 49 90 1c 88 	vpgatherdd (%rax,%zmm1,4),%zmm3{%k1}
 18b90b0:	62 f1 65 48 fa 8c 90 04 00 00 00 	vpsubd 0x4(%rax,%rdx,4),%zmm3,%zmm1
 18b90bb:	62 f2 6d 48 27 c2    	vptestmd %zmm2,%zmm2,%k0
 18b90c1:	62 d1 75 48 fe 4c 95 00 	vpaddd 0x0(%r13,%rdx,4),%zmm1,%zmm1
 18b90c9:	62 d1 75 48 fe da    	vpaddd %zmm10,%zmm1,%zmm3
 18b90cf:	62 d3 65 48 1e cb 01 	vpcmpltud %zmm11,%zmm3,%k1
 18b90d6:	c5 fc 45 c9          	korw   %k1,%k0,%k1
 18b90da:	62 d1 7d c9 6f 1c 93 	vmovdqa32 (%r11,%rdx,4),%zmm3{%k1}{z}
 18b90e1:	62 d3 65 48 03 e0 0f 	valignd $0xf,%zmm8,%zmm3,%zmm4
 18b90e8:	62 f3 65 48 1f c2 04 	vpcmpneqd %zmm2,%zmm3,%k0
 18b90ef:	62 d1 fd 48 7f 1c 97 	vmovdqa64 %zmm3,(%r15,%rdx,4)
 18b90f6:	62 d1 fd 48 7f 0c 94 	vmovdqa64 %zmm1,(%r12,%rdx,4)
 18b90fd:	c5 78 93 c0          	kmovw  %k0,%r8d
 18b9101:	62 f1 5d 48 fe e3    	vpaddd %zmm3,%zmm4,%zmm4
 18b9107:	44 09 c6             	or     %r8d,%esi
 18b910a:	4d 89 c8             	mov    %r9,%r8
 18b910d:	62 d3 dd 48 03 e8 07 	valignq $0x7,%zmm8,%zmm4,%zmm5
 18b9114:	62 f1 55 48 fe e4    	vpaddd %zmm4,%zmm5,%zmm4
 18b911a:	62 d3 dd 48 03 e8 06 	valignq $0x6,%zmm8,%zmm4,%zmm5
 18b9121:	62 f1 55 48 fe e4    	vpaddd %zmm4,%zmm5,%zmm4
 18b9127:	62 d3 dd 48 03 e8 04 	valignq $0x4,%zmm8,%zmm4,%zmm5
 18b912e:	62 f1 5d 48 fe c0    	vpaddd %zmm0,%zmm4,%zmm0
 18b9134:	62 f1 7d 48 fe c5    	vpaddd %zmm5,%zmm0,%zmm0
 18b913a:	62 d1 fe 48 7f 84 91 04 00 00 00 	vmovdqu64 %zmm0,0x4(%r9,%rdx,4)
 18b9145:	62 f1 7d 48 70 c0 ff 	vpshufd $0xff,%zmm0,%zmm0
 18b914c:	48 83 c2 10          	add    $0x10,%rdx
 18b9150:	62 f3 fd 48 43 c0 ff 	vshufi64x2 $0xff,%zmm0,%zmm0,%zmm0
 18b9157:	48 39 fa             	cmp    %rdi,%rdx
 18b915a:	0f 82 30 ff ff ff    	jb     18b9090 <tier0_benchmark_run+0x18e0>
 18b9160:	8b 84 24 90 00 00 00 	mov    0x90(%rsp),%eax
 18b9167:	45 89 d6             	mov    %r10d,%r14d
 18b916a:	ff c0                	inc    %eax
 18b916c:	85 f6                	test   %esi,%esi
 18b916e:	0f 85 dc fd ff ff    	jne    18b8f50 <tier0_benchmark_run+0x17a0>
 18b9174:	4c 8b 74 24 78       	mov    0x78(%rsp),%r14
 18b9179:	4c 8b a4 24 b0 00 00 00 	mov    0xb0(%rsp),%r12
 18b9181:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
 18b9186:	41 bd ff ff 00 00    	mov    $0xffff,%r13d
 18b918c:	45 31 ff             	xor    %r15d,%r15d
 18b918f:	62 f1 fd 48 6f 15 67 78 c6 fe 	vmovdqa64 -0x1398799(%rip),%zmm2        # 520a00 <branch_sizing_patterns+0xc70>
 18b9199:	31 c0                	xor    %eax,%eax
 18b919b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
 18b91a0:	62 d1 fd 48 6f 04 84 	vmovdqa64 (%r12,%rax,4),%zmm0
 18b91a7:	48 89 c1             	mov    %rax,%rcx
 18b91aa:	62 f2 7d 48 27 c0    	vptestmd %zmm0,%zmm0,%k0
 18b91b0:	c5 fb 93 c0          	kmovd  %k0,%eax
 18b91b4:	0d 00 00 01 00       	or     $0x10000,%eax
 18b91b9:	f3 0f bc c0          	tzcnt  %eax,%eax
 18b91bd:	48 01 c8             	add    %rcx,%rax
 18b91c0:	c5 f8 98 c0          	kortestw %k0,%k0
 18b91c4:	75 05                	jne    18b91cb <tier0_benchmark_run+0x1a1b>
 18b91c6:	48 39 f8             	cmp    %rdi,%rax
 18b91c9:	72 d5                	jb     18b91a0 <tier0_benchmark_run+0x19f0>
 18b91cb:	4c 8b 5c 24 18       	mov    0x18(%rsp),%r11
 18b91d0:	48 39 f8             	cmp    %rdi,%rax
 18b91d3:	0f 83 a6 00 00 00    	jae    18b927f <tier0_benchmark_run+0x1acf>
 18b91d9:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
 18b91de:	8b 04 81             	mov    (%rcx,%rax,4),%eax
 18b91e1:	83 e0 e0             	and    $0xffffffe0,%eax
 18b91e4:	41 39 c3             	cmp    %eax,%r11d
 18b91e7:	0f 86 92 00 00 00    	jbe    18b927f <tier0_benchmark_run+0x1acf>
 18b91ed:	4c 89 d9             	mov    %r11,%rcx
 18b91f0:	48 29 c1             	sub    %rax,%rcx
 18b91f3:	4d 89 c4             	mov    %r8,%r12
 18b91f6:	66 2e 0f 1f 84 00 00 00 00 00 	cs nopw 0x0(%rax,%rax,1)
 18b9200:	89 ca                	mov    %ecx,%edx
 18b9202:	48 83 e9 10          	sub    $0x10,%rcx
 18b9206:	48 89 c6             	mov    %rax,%rsi
 18b9209:	89 c7                	mov    %eax,%edi
 18b920b:	41 89 c0             	mov    %eax,%r8d
 18b920e:	c4 e2 69 f7 d3       	shlx   %edx,%ebx,%edx
 18b9213:	f7 d2                	not    %edx
 18b9215:	41 0f 43 d5          	cmovae %r13d,%edx
 18b9219:	48 c1 ee 05          	shr    $0x5,%rsi
 18b921d:	40 80 e7 10          	and    $0x10,%dil
 18b9221:	41 83 e0 10          	and    $0x10,%r8d
 18b9225:	49 8b 34 f6          	mov    (%r14,%rsi,8),%rsi
 18b9229:	c5 fb 92 ca          	kmovd  %edx,%k1
 18b922d:	c4 e2 c3 f7 fe       	shrx   %rdi,%rsi,%rdi
 18b9232:	c4 62 38 f5 c6       	bzhi   %r8d,%esi,%r8d
 18b9237:	48 c1 ee 20          	shr    $0x20,%rsi
 18b923b:	62 f2 7d 48 7c c7    	vpbroadcastd %edi,%zmm0
 18b9241:	48 8b 7c 24 58       	mov    0x58(%rsp),%rdi
 18b9246:	49 8d 34 b4          	lea    (%r12,%rsi,4),%rsi
 18b924a:	f3 45 0f b8 c0       	popcnt %r8d,%r8d
 18b924f:	62 f1 7d 48 db c2    	vpandd %zmm2,%zmm0,%zmm0
 18b9255:	62 f2 7d 48 55 c0    	vpopcntd %zmm0,%zmm0
 18b925b:	62 b2 7d 48 36 04 86 	vpermd (%rsi,%r8,4),%zmm0,%zmm0
 18b9262:	62 f1 7e c9 6f 0c 87 	vmovdqu32 (%rdi,%rax,4),%zmm1{%k1}{z}
 18b9269:	62 f1 75 48 fe c0    	vpaddd %zmm0,%zmm1,%zmm0
 18b926f:	62 f1 7e 49 7f 04 87 	vmovdqu32 %zmm0,(%rdi,%rax,4){%k1}
 18b9276:	48 83 c0 10          	add    $0x10,%rax
 18b927a:	4c 39 d8             	cmp    %r11,%rax
 18b927d:	72 81                	jb     18b9200 <tier0_benchmark_run+0x1a50>
 18b927f:	4c 8b 6c 24 30       	mov    0x30(%rsp),%r13
 18b9284:	44 89 e8             	mov    %r13d,%eax
 18b9287:	83 e0 07             	and    $0x7,%eax
 18b928a:	41 83 fd 08          	cmp    $0x8,%r13d
 18b928e:	73 1b                	jae    18b92ab <tier0_benchmark_run+0x1afb>
 18b9290:	4c 8b 74 24 48       	mov    0x48(%rsp),%r14
 18b9295:	48 8b 5c 24 50       	mov    0x50(%rsp),%rbx
 18b929a:	4c 8b 4c 24 10       	mov    0x10(%rsp),%r9
 18b929f:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
 18b92a4:	31 c9                	xor    %ecx,%ecx
 18b92a6:	e9 7d 01 00 00       	jmp    18b9428 <tier0_benchmark_run+0x1c78>
 18b92ab:	48 8b 94 24 b8 00 00 00 	mov    0xb8(%rsp),%rdx
 18b92b3:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
 18b92b8:	c1 e1 06             	shl    $0x6,%ecx
 18b92bb:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
 18b92c0:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
 18b92c5:	4c 8b 74 24 48       	mov    0x48(%rsp),%r14
 18b92ca:	48 8b 5c 24 50       	mov    0x50(%rsp),%rbx
 18b92cf:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
 18b92d4:	41 83 e5 f8          	and    $0xfffffff8,%r13d
 18b92d8:	48 01 ca             	add    %rcx,%rdx
 18b92db:	48 03 8c 24 98 00 00 00 	add    0x98(%rsp),%rcx
 18b92e3:	48 01 f2             	add    %rsi,%rdx
 18b92e6:	48 8d 54 17 5c       	lea    0x5c(%rdi,%rdx,1),%rdx
 18b92eb:	48 01 f1             	add    %rsi,%rcx
 18b92ee:	48 8d 74 0f 5c       	lea    0x5c(%rdi,%rcx,1),%rsi
 18b92f3:	31 c9                	xor    %ecx,%ecx
 18b92f5:	66 66 2e 0f 1f 84 00 00 00 00 00 	data16 cs nopw 0x0(%rax,%rax,1)
 18b9300:	41 8b 3c 8a          	mov    (%r10,%rcx,4),%edi
 18b9304:	44 8b 44 8a e4       	mov    -0x1c(%rdx,%rcx,4),%r8d
 18b9309:	44 8b 4c 8e e4       	mov    -0x1c(%rsi,%rcx,4),%r9d
 18b930e:	48 c1 e7 04          	shl    $0x4,%rdi
 18b9312:	41 83 f8 01          	cmp    $0x1,%r8d
 18b9316:	44 89 4c 3b 04       	mov    %r9d,0x4(%rbx,%rdi,1)
 18b931b:	66 83 5c 3b 0c ff    	sbbw   $0xffff,0xc(%rbx,%rdi,1)
 18b9321:	41 8b 7c 8a 04       	mov    0x4(%r10,%rcx,4),%edi
 18b9326:	44 8b 44 8a e8       	mov    -0x18(%rdx,%rcx,4),%r8d
 18b932b:	44 8b 4c 8e e8       	mov    -0x18(%rsi,%rcx,4),%r9d
 18b9330:	48 c1 e7 04          	shl    $0x4,%rdi
 18b9334:	41 83 f8 01          	cmp    $0x1,%r8d
 18b9338:	44 89 4c 3b 04       	mov    %r9d,0x4(%rbx,%rdi,1)
 18b933d:	66 83 5c 3b 0c ff    	sbbw   $0xffff,0xc(%rbx,%rdi,1)
 18b9343:	41 8b 7c 8a 08       	mov    0x8(%r10,%rcx,4),%edi
 18b9348:	44 8b 44 8a ec       	mov    -0x14(%rdx,%rcx,4),%r8d
 18b934d:	44 8b 4c 8e ec       	mov    -0x14(%rsi,%rcx,4),%r9d
 18b9352:	48 c1 e7 04          	shl    $0x4,%rdi
 18b9356:	41 83 f8 01          	cmp    $0x1,%r8d
 18b935a:	44 89 4c 3b 04       	mov    %r9d,0x4(%rbx,%rdi,1)
 18b935f:	66 83 5c 3b 0c ff    	sbbw   $0xffff,0xc(%rbx,%rdi,1)
 18b9365:	41 8b 7c 8a 0c       	mov    0xc(%r10,%rcx,4),%edi
 18b936a:	44 8b 44 8a f0       	mov    -0x10(%rdx,%rcx,4),%r8d
 18b936f:	44 8b 4c 8e f0       	mov    -0x10(%rsi,%rcx,4),%r9d
 18b9374:	48 c1 e7 04          	shl    $0x4,%rdi
 18b9378:	41 83 f8 01          	cmp    $0x1,%r8d
 18b937c:	44 89 4c 3b 04       	mov    %r9d,0x4(%rbx,%rdi,1)
 18b9381:	66 83 5c 3b 0c ff    	sbbw   $0xffff,0xc(%rbx,%rdi,1)
 18b9387:	41 8b 7c 8a 10       	mov    0x10(%r10,%rcx,4),%edi
 18b938c:	44 8b 44 8a f4       	mov    -0xc(%rdx,%rcx,4),%r8d
 18b9391:	44 8b 4c 8e f4       	mov    -0xc(%rsi,%rcx,4),%r9d
 18b9396:	48 c1 e7 04          	shl    $0x4,%rdi
 18b939a:	41 83 f8 01          	cmp    $0x1,%r8d
 18b939e:	44 89 4c 3b 04       	mov    %r9d,0x4(%rbx,%rdi,1)
 18b93a3:	66 83 5c 3b 0c ff    	sbbw   $0xffff,0xc(%rbx,%rdi,1)
 18b93a9:	41 8b 7c 8a 14       	mov    0x14(%r10,%rcx,4),%edi
 18b93ae:	44 8b 44 8a f8       	mov    -0x8(%rdx,%rcx,4),%r8d
 18b93b3:	44 8b 4c 8e f8       	mov    -0x8(%rsi,%rcx,4),%r9d
 18b93b8:	48 c1 e7 04          	shl    $0x4,%rdi
 18b93bc:	41 83 f8 01          	cmp    $0x1,%r8d
 18b93c0:	44 89 4c 3b 04       	mov    %r9d,0x4(%rbx,%rdi,1)
 18b93c5:	66 83 5c 3b 0c ff    	sbbw   $0xffff,0xc(%rbx,%rdi,1)
 18b93cb:	41 8b 7c 8a 18       	mov    0x18(%r10,%rcx,4),%edi
 18b93d0:	44 8b 44 8a fc       	mov    -0x4(%rdx,%rcx,4),%r8d
 18b93d5:	44 8b 4c 8e fc       	mov    -0x4(%rsi,%rcx,4),%r9d
 18b93da:	48 c1 e7 04          	shl    $0x4,%rdi
 18b93de:	41 83 f8 01          	cmp    $0x1,%r8d
 18b93e2:	44 89 4c 3b 04       	mov    %r9d,0x4(%rbx,%rdi,1)
 18b93e7:	66 83 5c 3b 0c ff    	sbbw   $0xffff,0xc(%rbx,%rdi,1)
 18b93ed:	41 8b 7c 8a 1c       	mov    0x1c(%r10,%rcx,4),%edi
 18b93f2:	44 8b 04 8a          	mov    (%rdx,%rcx,4),%r8d
 18b93f6:	44 8b 0c 8e          	mov    (%rsi,%rcx,4),%r9d
 18b93fa:	48 c1 e7 04          	shl    $0x4,%rdi
 18b93fe:	41 83 f8 01          	cmp    $0x1,%r8d
 18b9402:	44 89 4c 3b 04       	mov    %r9d,0x4(%rbx,%rdi,1)
 18b9407:	66 83 5c 3b 0c ff    	sbbw   $0xffff,0xc(%rbx,%rdi,1)
 18b940d:	48 83 c1 08          	add    $0x8,%rcx
 18b9411:	49 39 cd             	cmp    %rcx,%r13
 18b9414:	0f 85 e6 fe ff ff    	jne    18b9300 <tier0_benchmark_run+0x1b50>
 18b941a:	4c 8b 4c 24 10       	mov    0x10(%rsp),%r9
 18b941f:	48 85 c0             	test   %rax,%rax
 18b9422:	0f 84 c8 e5 ff ff    	je     18b79f0 <tier0_benchmark_run+0x240>
 18b9428:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
 18b942d:	4c 8b 84 24 98 00 00 00 	mov    0x98(%rsp),%r8
 18b9435:	4c 8b 9c 24 b8 00 00 00 	mov    0xb8(%rsp),%r11
 18b943d:	48 8b 7c 24 40       	mov    0x40(%rsp),%rdi
 18b9442:	c1 e0 02             	shl    $0x2,%eax
 18b9445:	c1 e6 06             	shl    $0x6,%esi
 18b9448:	49 01 f0             	add    %rsi,%r8
 18b944b:	49 01 f3             	add    %rsi,%r11
 18b944e:	49 01 f8             	add    %rdi,%r8
 18b9451:	49 01 fb             	add    %rdi,%r11
 18b9454:	31 ff                	xor    %edi,%edi
 18b9456:	49 8d 14 88          	lea    (%r8,%rcx,4),%rdx
 18b945a:	49 8d 34 8b          	lea    (%r11,%rcx,4),%rsi
 18b945e:	49 8d 0c 8a          	lea    (%r10,%rcx,4),%rcx
 18b9462:	49 8d 54 11 40       	lea    0x40(%r9,%rdx,1),%rdx
 18b9467:	49 8d 74 31 40       	lea    0x40(%r9,%rsi,1),%rsi
 18b946c:	0f 1f 40 00          	nopl   0x0(%rax)
 18b9470:	44 8b 04 39          	mov    (%rcx,%rdi,1),%r8d
 18b9474:	44 8b 0c 3e          	mov    (%rsi,%rdi,1),%r9d
 18b9478:	44 8b 14 3a          	mov    (%rdx,%rdi,1),%r10d
 18b947c:	49 c1 e0 04          	shl    $0x4,%r8
 18b9480:	41 83 f9 01          	cmp    $0x1,%r9d
 18b9484:	46 89 54 03 04       	mov    %r10d,0x4(%rbx,%r8,1)
 18b9489:	66 42 83 5c 03 0c ff 	sbbw   $0xffff,0xc(%rbx,%r8,1)
 18b9490:	48 83 c7 04          	add    $0x4,%rdi
 18b9494:	48 39 f8             	cmp    %rdi,%rax
 18b9497:	75 d7                	jne    18b9470 <tier0_benchmark_run+0x1cc0>
 18b9499:	e9 52 e5 ff ff       	jmp    18b79f0 <tier0_benchmark_run+0x240>
 18b949e:	45 31 ff             	xor    %r15d,%r15d
 18b94a1:	31 db                	xor    %ebx,%ebx
 18b94a3:	45 31 f6             	xor    %r14d,%r14d
 18b94a6:	eb 4a                	jmp    18b94f2 <tier0_benchmark_run+0x1d42>
 18b94a8:	0f 1f 84 00 00 00 00 00 	nopl   0x0(%rax,%rax,1)
 18b94b0:	49 8b 4d 20          	mov    0x20(%r13),%rcx
 18b94b4:	49 8b 55 28          	mov    0x28(%r13),%rdx
 18b94b8:	49 8b 45 10          	mov    0x10(%r13),%rax
 18b94bc:	4a 8b 0c f1          	mov    (%rcx,%r14,8),%rcx
 18b94c0:	4a 8b 14 f2          	mov    (%rdx,%r14,8),%rdx
 18b94c4:	4a 8b 3c f0          	mov    (%rax,%r14,8),%rdi
 18b94c8:	e8 03 d2 04 00       	call   19066d0 <x86_encode_16>
 18b94cd:	48 89 c1             	mov    %rax,%rcx
 18b94d0:	48 c1 f9 3f          	sar    $0x3f,%rcx
 18b94d4:	c4 e2 f0 f2 c8       	andn   %rax,%rcx,%rcx
 18b94d9:	41 8b 45 30          	mov    0x30(%r13),%eax
 18b94dd:	49 01 cf             	add    %rcx,%r15
 18b94e0:	49 ff c6             	inc    %r14
 18b94e3:	48 83 c3 68          	add    $0x68,%rbx
 18b94e7:	89 c1                	mov    %eax,%ecx
 18b94e9:	49 39 ce             	cmp    %rcx,%r14
 18b94ec:	0f 83 13 e4 ff ff    	jae    18b7905 <tier0_benchmark_run+0x155>
 18b94f2:	49 8b 4d 08          	mov    0x8(%r13),%rcx
 18b94f6:	8b 74 19 08          	mov    0x8(%rcx,%rbx,1),%esi
 18b94fa:	48 81 fe 11 11 11 11 	cmp    $0x11111111,%rsi
 18b9501:	76 ad                	jbe    18b94b0 <tier0_benchmark_run+0x1d00>
 18b9503:	31 c9                	xor    %ecx,%ecx
 18b9505:	eb d6                	jmp    18b94dd <tier0_benchmark_run+0x1d2d>
 18b9507:	48 8d 3d e9 6a e1 fe 	lea    -0x11e9517(%rip),%rdi        # 6cfff7 <pp_string_value.meaning+0x72dab>
 18b950e:	48 8d 35 7e e2 dc fe 	lea    -0x1231d82(%rip),%rsi        # 687793 <pp_string_value.meaning+0x2a547>
 18b9515:	48 8d 0d 92 e2 dc fe 	lea    -0x1231d6e(%rip),%rcx        # 6877ae <pp_string_value.meaning+0x2a562>
 18b951c:	ba bf 00 00 00       	mov    $0xbf,%edx
 18b9521:	c5 f8 77             	vzeroupper
 18b9524:	e8 27 a6 ea fe       	call   763b50 <__assert_fail@plt>
 18b9529:	c5 f8 77             	vzeroupper
 18b952c:	e8 af a5 ea fe       	call   763ae0 <__stack_chk_fail@plt>
