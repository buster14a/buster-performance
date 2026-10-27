
/home/david/buster-fast-bench/codex-180-fix-20261027-align64/build/compiler:     file format elf64-x86-64


Disassembly of section .text:

0000000001511900 <tier0_benchmark_run>:
 1511900:	55                   	push   %rbp
 1511901:	48 89 e5             	mov    %rsp,%rbp
 1511904:	41 57                	push   %r15
 1511906:	41 56                	push   %r14
 1511908:	41 55                	push   %r13
 151190a:	41 54                	push   %r12
 151190c:	53                   	push   %rbx
 151190d:	48 83 e4 c0          	and    $0xffffffffffffffc0,%rsp
 1511911:	48 81 ec 00 03 00 00 	sub    $0x300,%rsp
 1511918:	44 89 4c 24 6c       	mov    %r9d,0x6c(%rsp)
 151191d:	4c 89 84 24 d0 00 00 00 	mov    %r8,0xd0(%rsp)
 1511925:	48 89 bc 24 38 01 00 00 	mov    %rdi,0x138(%rsp)
 151192d:	49 89 cf             	mov    %rcx,%r15
 1511930:	49 89 d5             	mov    %rdx,%r13
 1511933:	41 89 f4             	mov    %esi,%r12d
 1511936:	64 48 8b 04 25 28 00 00 00 	mov    %fs:0x28,%rax
 151193f:	48 89 84 24 c0 02 00 00 	mov    %rax,0x2c0(%rsp)
 1511947:	83 fe 02             	cmp    $0x2,%esi
 151194a:	75 41                	jne    151198d <tier0_benchmark_run+0x8d>
 151194c:	41 83 7d 30 00       	cmpl   $0x0,0x30(%r13)
 1511951:	74 3a                	je     151198d <tier0_benchmark_run+0x8d>
 1511953:	31 db                	xor    %ebx,%ebx
 1511955:	45 31 f6             	xor    %r14d,%r14d
 1511958:	0f 1f 84 00 00 00 00 00 	nopl   0x0(%rax,%rax,1)
 1511960:	49 8b 45 08          	mov    0x8(%r13),%rax
 1511964:	49 8b 4d 10          	mov    0x10(%r13),%rcx
 1511968:	8b 54 18 08          	mov    0x8(%rax,%rbx,1),%edx
 151196c:	4a 8b 3c f1          	mov    (%rcx,%r14,8),%rdi
 1511970:	48 8b 34 18          	mov    (%rax,%rbx,1),%rsi
 1511974:	48 c1 e2 04          	shl    $0x4,%rdx
 1511978:	e8 d3 2a 25 ff       	call   764450 <memcpy@plt>
 151197d:	41 8b 45 30          	mov    0x30(%r13),%eax
 1511981:	49 ff c6             	inc    %r14
 1511984:	48 83 c3 68          	add    $0x68,%rbx
 1511988:	49 39 c6             	cmp    %rax,%r14
 151198b:	72 d3                	jb     1511960 <tier0_benchmark_run+0x60>
 151198d:	48 8b b4 24 d0 00 00 00 	mov    0xd0(%rsp),%rsi
 1511995:	8b 54 24 6c          	mov    0x6c(%rsp),%edx
 1511999:	48 8d bc 24 48 01 00 00 	lea    0x148(%rsp),%rdi
 15119a1:	e8 7a e6 04 00       	call   1560020 <tier0_benchmark_read>
 15119a6:	41 8b 45 30          	mov    0x30(%r13),%eax
 15119aa:	85 c0                	test   %eax,%eax
 15119ac:	0f 84 a0 00 00 00    	je     1511a52 <tier0_benchmark_run+0x152>
 15119b2:	49 8b 5f 08          	mov    0x8(%r15),%rbx
 15119b6:	44 89 64 24 3c       	mov    %r12d,0x3c(%rsp)
 15119bb:	45 85 e4             	test   %r12d,%r12d
 15119be:	74 4f                	je     1511a0f <tier0_benchmark_run+0x10f>
 15119c0:	41 83 fc 01          	cmp    $0x1,%r12d
 15119c4:	0f 85 fc 00 00 00    	jne    1511ac6 <tier0_benchmark_run+0x1c6>
 15119ca:	4c 8d a4 24 c0 01 00 00 	lea    0x1c0(%rsp),%r12
 15119d2:	45 31 f6             	xor    %r14d,%r14d
 15119d5:	66 66 2e 0f 1f 84 00 00 00 00 00 	data16 cs nopw 0x0(%rax,%rax,1)
 15119e0:	49 8b 45 00          	mov    0x0(%r13),%rax
 15119e4:	4c 89 e7             	mov    %r12,%rdi
 15119e7:	4c 89 fa             	mov    %r15,%rdx
 15119ea:	4a 8b 34 f0          	mov    (%rax,%r14,8),%rsi
 15119ee:	e8 3d 18 01 00       	call   1523230 <tier0_compile_scalar>
 15119f3:	49 3b 5f 08          	cmp    0x8(%r15),%rbx
 15119f7:	0f 87 5a 1c 00 00    	ja     1513657 <tier0_benchmark_run+0x1d57>
 15119fd:	49 89 5f 08          	mov    %rbx,0x8(%r15)
 1511a01:	49 ff c6             	inc    %r14
 1511a04:	41 8b 45 30          	mov    0x30(%r13),%eax
 1511a08:	49 39 c6             	cmp    %rax,%r14
 1511a0b:	72 d3                	jb     15119e0 <tier0_benchmark_run+0xe0>
 1511a0d:	eb 3e                	jmp    1511a4d <tier0_benchmark_run+0x14d>
 1511a0f:	4c 8d a4 24 c0 01 00 00 	lea    0x1c0(%rsp),%r12
 1511a17:	45 31 f6             	xor    %r14d,%r14d
 1511a1a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
 1511a20:	49 8b 45 00          	mov    0x0(%r13),%rax
 1511a24:	4c 89 e7             	mov    %r12,%rdi
 1511a27:	4c 89 fa             	mov    %r15,%rdx
 1511a2a:	4a 8b 34 f0          	mov    (%rax,%r14,8),%rsi
 1511a2e:	e8 1d 27 01 00       	call   1524150 <tier0_compile>
 1511a33:	49 3b 5f 08          	cmp    0x8(%r15),%rbx
 1511a37:	0f 87 1a 1c 00 00    	ja     1513657 <tier0_benchmark_run+0x1d57>
 1511a3d:	49 89 5f 08          	mov    %rbx,0x8(%r15)
 1511a41:	49 ff c6             	inc    %r14
 1511a44:	41 8b 45 30          	mov    0x30(%r13),%eax
 1511a48:	49 39 c6             	cmp    %rax,%r14
 1511a4b:	72 d3                	jb     1511a20 <tier0_benchmark_run+0x120>
 1511a4d:	44 8b 64 24 3c       	mov    0x3c(%rsp),%r12d
 1511a52:	45 31 ff             	xor    %r15d,%r15d
 1511a55:	48 8b b4 24 d0 00 00 00 	mov    0xd0(%rsp),%rsi
 1511a5d:	8b 54 24 6c          	mov    0x6c(%rsp),%edx
 1511a61:	48 8d bc 24 c0 01 00 00 	lea    0x1c0(%rsp),%rdi
 1511a69:	c5 f8 77             	vzeroupper
 1511a6c:	e8 af e5 04 00       	call   1560020 <tier0_benchmark_read>
 1511a71:	c5 fe 6f 84 24 c0 01 00 00 	vmovdqu 0x1c0(%rsp),%ymm0
 1511a7a:	48 8b 84 24 38 01 00 00 	mov    0x138(%rsp),%rax
 1511a82:	c5 fd fb 84 24 48 01 00 00 	vpsubq 0x148(%rsp),%ymm0,%ymm0
 1511a8b:	c5 fe 7f 00          	vmovdqu %ymm0,(%rax)
 1511a8f:	41 83 fc 03          	cmp    $0x3,%r12d
 1511a93:	74 04                	je     1511a99 <tier0_benchmark_run+0x199>
 1511a95:	4d 8b 7d 50          	mov    0x50(%r13),%r15
 1511a99:	4d 89 7d 50          	mov    %r15,0x50(%r13)
 1511a9d:	64 48 8b 04 25 28 00 00 00 	mov    %fs:0x28,%rax
 1511aa6:	48 3b 84 24 c0 02 00 00 	cmp    0x2c0(%rsp),%rax
 1511aae:	0f 85 c5 1b 00 00    	jne    1513679 <tier0_benchmark_run+0x1d79>
 1511ab4:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
 1511ab8:	5b                   	pop    %rbx
 1511ab9:	41 5c                	pop    %r12
 1511abb:	41 5d                	pop    %r13
 1511abd:	41 5e                	pop    %r14
 1511abf:	41 5f                	pop    %r15
 1511ac1:	5d                   	pop    %rbp
 1511ac2:	c5 f8 77             	vzeroupper
 1511ac5:	c3                   	ret
 1511ac6:	41 83 fc 02          	cmp    $0x2,%r12d
 1511aca:	0f 85 1e 1b 00 00    	jne    15135ee <tier0_benchmark_run+0x1cee>
 1511ad0:	62 f2 7d 48 58 35 fa e9 06 ff 	vpbroadcastd -0xf91606(%rip),%zmm6        # 5804d4 <tier0_emit_x87.operations+0x8c>
 1511ada:	62 f1 fd 48 6f 3d 1c ed 00 ff 	vmovdqa64 -0xff12e4(%rip),%zmm7        # 520800 <branch_sizing_patterns+0xa70>
 1511ae4:	62 e2 7d 48 5a 0d 12 42 06 ff 	vbroadcasti32x4 -0xf9bdee(%rip),%zmm17        # 575d00 <x86_effects_unknown+0x2a0>
 1511aee:	62 72 7d 48 5a 0d 18 42 06 ff 	vbroadcasti32x4 -0xf9bde8(%rip),%zmm9        # 575d10 <x86_effects_unknown+0x2b0>
 1511af8:	62 72 7d 48 58 15 2e ea 06 ff 	vpbroadcastd -0xf915d2(%rip),%zmm10        # 580530 <tier0_emit_x87.operations+0xe8>
 1511b02:	62 72 7d 48 58 1d 28 ea 06 ff 	vpbroadcastd -0xf915d8(%rip),%zmm11        # 580534 <tier0_emit_x87.operations+0xec>
 1511b0c:	48 b9 00 00 20 00 10 00 00 00 	movabs $0x1000200000,%rcx
 1511b16:	45 31 ff             	xor    %r15d,%r15d
 1511b19:	c4 41 39 ef c0       	vpxor  %xmm8,%xmm8,%xmm8
 1511b1e:	45 31 f6             	xor    %r14d,%r14d
 1511b21:	4c 89 ac 24 30 01 00 00 	mov    %r13,0x130(%rsp)
 1511b29:	48 81 c1 00 00 e0 ff 	add    $0xffffffffffe00000,%rcx
 1511b30:	48 89 8c 24 f0 00 00 00 	mov    %rcx,0xf0(%rsp)
 1511b38:	eb 45                	jmp    1511b7f <tier0_benchmark_run+0x27f>
 1511b3a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
 1511b40:	48 8b 84 24 40 01 00 00 	mov    0x140(%rsp),%rax
 1511b48:	64 48 3b 04 25 18 ff ff ff 	cmp    %fs:0xffffffffffffff18,%rax
 1511b51:	0f 87 00 1b 00 00    	ja     1513657 <tier0_benchmark_run+0x1d57>
 1511b57:	4c 8b ac 24 30 01 00 00 	mov    0x130(%rsp),%r13
 1511b5f:	64 48 89 04 25 18 ff ff ff 	mov    %rax,%fs:0xffffffffffffff18
 1511b68:	44 8b 64 24 3c       	mov    0x3c(%rsp),%r12d
 1511b6d:	41 8b 45 30          	mov    0x30(%r13),%eax
 1511b71:	49 ff c6             	inc    %r14
 1511b74:	89 c1                	mov    %eax,%ecx
 1511b76:	49 39 ce             	cmp    %rcx,%r14
 1511b79:	0f 83 d6 fe ff ff    	jae    1511a55 <tier0_benchmark_run+0x155>
 1511b7f:	49 8b 55 08          	mov    0x8(%r13),%rdx
 1511b83:	49 6b ce 68          	imul   $0x68,%r14,%rcx
 1511b87:	44 8b 4c 0a 08       	mov    0x8(%rdx,%rcx,1),%r9d
 1511b8c:	49 81 f9 11 11 11 11 	cmp    $0x11111111,%r9
 1511b93:	77 dc                	ja     1511b71 <tier0_benchmark_run+0x271>
 1511b95:	49 8b 45 10          	mov    0x10(%r13),%rax
 1511b99:	4c 8b 54 0a 10       	mov    0x10(%rdx,%rcx,1),%r10
 1511b9e:	4c 8b 44 0a 18       	mov    0x18(%rdx,%rcx,1),%r8
 1511ba3:	8b 7c 0a 20          	mov    0x20(%rdx,%rcx,1),%edi
 1511ba7:	49 8b 4d 18          	mov    0x18(%r13),%rcx
 1511bab:	64 4c 8b 2c 25 10 ff ff ff 	mov    %fs:0xffffffffffffff10,%r13
 1511bb4:	4a 8b 34 f0          	mov    (%rax,%r14,8),%rsi
 1511bb8:	4a 8b 04 f1          	mov    (%rcx,%r14,8),%rax
 1511bbc:	4c 89 54 24 28       	mov    %r10,0x28(%rsp)
 1511bc1:	48 89 7c 24 30       	mov    %rdi,0x30(%rsp)
 1511bc6:	4c 89 84 24 a8 00 00 00 	mov    %r8,0xa8(%rsp)
 1511bce:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
 1511bd3:	4d 85 ed             	test   %r13,%r13
 1511bd6:	74 0e                	je     1511be6 <tier0_benchmark_run+0x2e6>
 1511bd8:	64 48 8b 0c 25 18 ff ff ff 	mov    %fs:0xffffffffffffff18,%rcx
 1511be1:	e9 16 01 00 00       	jmp    1511cfc <tier0_benchmark_run+0x3fc>
 1511be6:	48 bb 00 00 20 00 10 00 00 00 	movabs $0x1000200000,%rbx
 1511bf0:	ba 03 00 00 00       	mov    $0x3,%edx
 1511bf5:	b9 22 40 00 00       	mov    $0x4022,%ecx
 1511bfa:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
 1511c00:	4c 89 4c 24 18       	mov    %r9,0x18(%rsp)
 1511c05:	48 89 74 24 50       	mov    %rsi,0x50(%rsp)
 1511c0a:	4c 89 74 24 48       	mov    %r14,0x48(%rsp)
 1511c0f:	31 ff                	xor    %edi,%edi
 1511c11:	45 31 c9             	xor    %r9d,%r9d
 1511c14:	48 89 de             	mov    %rbx,%rsi
 1511c17:	c5 f8 77             	vzeroupper
 1511c1a:	e8 21 29 25 ff       	call   764540 <mmap@plt>
 1511c1f:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
 1511c23:	74 50                	je     1511c75 <tier0_benchmark_run+0x375>
 1511c25:	4c 8d a8 ff ff 20 00 	lea    0x20ffff(%rax),%r13
 1511c2c:	ba 0f 00 00 00       	mov    $0xf,%edx
 1511c31:	48 89 c7             	mov    %rax,%rdi
 1511c34:	49 81 e5 00 00 e0 ff 	and    $0xffffffffffe00000,%r13
 1511c3b:	4d 89 ec             	mov    %r13,%r12
 1511c3e:	49 29 c4             	sub    %rax,%r12
 1511c41:	4c 89 e6             	mov    %r12,%rsi
 1511c44:	4d 8d b4 24 00 00 ff ff 	lea    -0x10000(%r12),%r14
 1511c4c:	e8 9f 28 25 ff       	call   7644f0 <madvise@plt>
 1511c51:	4c 29 e3             	sub    %r12,%rbx
 1511c54:	ba 0e 00 00 00       	mov    $0xe,%edx
 1511c59:	4c 89 ef             	mov    %r13,%rdi
 1511c5c:	48 89 de             	mov    %rbx,%rsi
 1511c5f:	e8 8c 28 25 ff       	call   7644f0 <madvise@plt>
 1511c64:	48 8b 84 24 f0 00 00 00 	mov    0xf0(%rsp),%rax
 1511c6c:	49 81 c5 00 00 ff ff 	add    $0xffffffffffff0000,%r13
 1511c73:	eb 08                	jmp    1511c7d <tier0_benchmark_run+0x37d>
 1511c75:	45 31 ed             	xor    %r13d,%r13d
 1511c78:	31 c0                	xor    %eax,%eax
 1511c7a:	45 31 f6             	xor    %r14d,%r14d
 1511c7d:	62 f2 7d 48 58 35 4d e8 06 ff 	vpbroadcastd -0xf917b3(%rip),%zmm6        # 5804d4 <tier0_emit_x87.operations+0x8c>
 1511c87:	62 f1 fd 48 6f 3d 6f eb 00 ff 	vmovdqa64 -0xff1491(%rip),%zmm7        # 520800 <branch_sizing_patterns+0xa70>
 1511c91:	62 e2 7d 48 5a 0d 65 40 06 ff 	vbroadcasti32x4 -0xf9bf9b(%rip),%zmm17        # 575d00 <x86_effects_unknown+0x2a0>
 1511c9b:	62 72 7d 48 5a 0d 6b 40 06 ff 	vbroadcasti32x4 -0xf9bf95(%rip),%zmm9        # 575d10 <x86_effects_unknown+0x2b0>
 1511ca5:	62 72 7d 48 58 15 81 e8 06 ff 	vpbroadcastd -0xf9177f(%rip),%zmm10        # 580530 <tier0_emit_x87.operations+0xe8>
 1511caf:	62 72 7d 48 58 1d 7b e8 06 ff 	vpbroadcastd -0xf91785(%rip),%zmm11        # 580534 <tier0_emit_x87.operations+0xec>
 1511cb9:	64 4c 89 2c 25 10 ff ff ff 	mov    %r13,%fs:0xffffffffffffff10
 1511cc2:	64 48 c7 04 25 18 ff ff ff 00 00 00 00 	movq   $0x0,%fs:0xffffffffffffff18
 1511ccf:	64 48 89 04 25 20 ff ff ff 	mov    %rax,%fs:0xffffffffffffff20
 1511cd8:	64 4c 89 34 25 28 ff ff ff 	mov    %r14,%fs:0xffffffffffffff28
 1511ce1:	4c 8b 74 24 48       	mov    0x48(%rsp),%r14
 1511ce6:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
 1511ceb:	48 8b 7c 24 30       	mov    0x30(%rsp),%rdi
 1511cf0:	4c 8b 4c 24 18       	mov    0x18(%rsp),%r9
 1511cf5:	31 c9                	xor    %ecx,%ecx
 1511cf7:	c4 41 39 ef c0       	vpxor  %xmm8,%xmm8,%xmm8
 1511cfc:	4e 8d 44 29 3f       	lea    0x3f(%rcx,%r13,1),%r8
 1511d01:	4a 8d 04 29          	lea    (%rcx,%r13,1),%rax
 1511d05:	48 89 8c 24 40 01 00 00 	mov    %rcx,0x140(%rsp)
 1511d0d:	49 83 e0 c0          	and    $0xffffffffffffffc0,%r8
 1511d11:	49 39 c0             	cmp    %rax,%r8
 1511d14:	0f 82 26 fe ff ff    	jb     1511b40 <tier0_benchmark_run+0x240>
 1511d1a:	64 48 8b 0c 25 20 ff ff ff 	mov    %fs:0xffffffffffffff20,%rcx
 1511d23:	4c 89 c0             	mov    %r8,%rax
 1511d26:	4c 29 e8             	sub    %r13,%rax
 1511d29:	48 29 c1             	sub    %rax,%rcx
 1511d2c:	0f 82 0e fe ff ff    	jb     1511b40 <tier0_benchmark_run+0x240>
 1511d32:	44 89 ca             	mov    %r9d,%edx
 1511d35:	c1 ea 06             	shr    $0x6,%edx
 1511d38:	4c 8d 24 bd 7c 00 00 00 	lea    0x7c(,%rdi,4),%r12
 1511d40:	4c 8d 1c bd bc 00 00 00 	lea    0xbc(,%rdi,4),%r11
 1511d48:	4c 89 4c 24 18       	mov    %r9,0x18(%rsp)
 1511d4d:	48 8d 5a 01          	lea    0x1(%rdx),%rbx
 1511d51:	48 89 54 24 20       	mov    %rdx,0x20(%rsp)
 1511d56:	48 ba c0 ff ff ff 07 00 00 00 	movabs $0x7ffffffc0,%rdx
 1511d60:	4c 8b 4c 24 18       	mov    0x18(%rsp),%r9
 1511d65:	49 21 d4             	and    %rdx,%r12
 1511d68:	49 21 d3             	and    %rdx,%r11
 1511d6b:	89 fa                	mov    %edi,%edx
 1511d6d:	c1 ea 03             	shr    $0x3,%edx
 1511d70:	49 89 dd             	mov    %rbx,%r13
 1511d73:	48 89 9c 24 c8 00 00 00 	mov    %rbx,0xc8(%rsp)
 1511d7b:	c1 e3 04             	shl    $0x4,%ebx
 1511d7e:	49 c1 e5 06          	shl    $0x6,%r13
 1511d82:	83 c2 48             	add    $0x48,%edx
 1511d85:	83 c3 30             	add    $0x30,%ebx
 1511d88:	4c 89 64 24 70       	mov    %r12,0x70(%rsp)
 1511d8d:	4f 8d 24 a4          	lea    (%r12,%r12,4),%r12
 1511d91:	4c 89 6c 24 78       	mov    %r13,0x78(%rsp)
 1511d96:	4c 89 9c 24 88 00 00 00 	mov    %r11,0x88(%rsp)
 1511d9e:	83 e2 c0             	and    $0xffffffc0,%edx
 1511da1:	81 e3 c0 ff ff 1f    	and    $0x1fffffc0,%ebx
 1511da7:	4c 01 ea             	add    %r13,%rdx
 1511daa:	48 89 5c 24 40       	mov    %rbx,0x40(%rsp)
 1511daf:	4c 89 a4 24 80 00 00 00 	mov    %r12,0x80(%rsp)
 1511db7:	48 01 da             	add    %rbx,%rdx
 1511dba:	4c 01 e2             	add    %r12,%rdx
 1511dbd:	4a 8d 14 5a          	lea    (%rdx,%r11,2),%rdx
 1511dc1:	48 39 ca             	cmp    %rcx,%rdx
 1511dc4:	0f 87 76 fd ff ff    	ja     1511b40 <tier0_benchmark_run+0x240>
 1511dca:	48 01 d0             	add    %rdx,%rax
 1511dcd:	48 c7 84 24 b8 01 00 00 00 00 00 00 	movq   $0x0,0x1b8(%rsp)
 1511dd9:	64 48 89 04 25 18 ff ff ff 	mov    %rax,%fs:0xffffffffffffff18
 1511de2:	4d 85 c0             	test   %r8,%r8
 1511de5:	0f 95 84 24 b8 01 00 00 	setne  0x1b8(%rsp)
 1511ded:	0f 84 4d fd ff ff    	je     1511b40 <tier0_benchmark_run+0x240>
 1511df3:	4c 8b 64 24 78       	mov    0x78(%rsp),%r12
 1511df8:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
 1511dfd:	48 8b 5c 24 70       	mov    0x70(%rsp),%rbx
 1511e02:	4c 89 84 24 68 01 00 00 	mov    %r8,0x168(%rsp)
 1511e0a:	4c 8b 9c 24 88 00 00 00 	mov    0x88(%rsp),%r11
 1511e12:	4c 89 74 24 48       	mov    %r14,0x48(%rsp)
 1511e17:	48 89 74 24 50       	mov    %rsi,0x50(%rsp)
 1511e1c:	4d 01 c4             	add    %r8,%r12
 1511e1f:	4b 8d 04 1b          	lea    (%r11,%r11,1),%rax
 1511e23:	49 8d 14 0c          	lea    (%r12,%rcx,1),%rdx
 1511e27:	4c 89 a4 24 70 01 00 00 	mov    %r12,0x170(%rsp)
 1511e2f:	4c 89 64 24 78       	mov    %r12,0x78(%rsp)
 1511e34:	48 8d 0c 1a          	lea    (%rdx,%rbx,1),%rcx
 1511e38:	48 89 94 24 78 01 00 00 	mov    %rdx,0x178(%rsp)
 1511e40:	4c 8d 14 5a          	lea    (%rdx,%rbx,2),%r10
 1511e44:	48 89 54 24 60       	mov    %rdx,0x60(%rsp)
 1511e49:	48 89 8c 24 80 01 00 00 	mov    %rcx,0x180(%rsp)
 1511e51:	48 89 8c 24 e8 00 00 00 	mov    %rcx,0xe8(%rsp)
 1511e59:	48 8d 0c 5b          	lea    (%rbx,%rbx,2),%rcx
 1511e5d:	48 8d 1c 9a          	lea    (%rdx,%rbx,4),%rbx
 1511e61:	4c 89 94 24 88 01 00 00 	mov    %r10,0x188(%rsp)
 1511e69:	4c 8d 24 0a          	lea    (%rdx,%rcx,1),%r12
 1511e6d:	48 89 8c 24 b8 00 00 00 	mov    %rcx,0xb8(%rsp)
 1511e75:	48 8b 8c 24 80 00 00 00 	mov    0x80(%rsp),%rcx
 1511e7d:	48 89 9c 24 e0 00 00 00 	mov    %rbx,0xe0(%rsp)
 1511e85:	4c 89 a4 24 90 01 00 00 	mov    %r12,0x190(%rsp)
 1511e8d:	48 89 9c 24 98 01 00 00 	mov    %rbx,0x198(%rsp)
 1511e95:	48 01 d1             	add    %rdx,%rcx
 1511e98:	4a 8d 14 19          	lea    (%rcx,%r11,1),%rdx
 1511e9c:	48 01 c8             	add    %rcx,%rax
 1511e9f:	48 89 8c 24 a0 01 00 00 	mov    %rcx,0x1a0(%rsp)
 1511ea7:	48 89 8c 24 a0 00 00 00 	mov    %rcx,0xa0(%rsp)
 1511eaf:	48 89 94 24 a8 01 00 00 	mov    %rdx,0x1a8(%rsp)
 1511eb7:	48 89 94 24 c0 00 00 00 	mov    %rdx,0xc0(%rsp)
 1511ebf:	48 89 84 24 b0 01 00 00 	mov    %rax,0x1b0(%rsp)
 1511ec7:	41 83 f9 10          	cmp    $0x10,%r9d
 1511ecb:	73 10                	jae    1511edd <tier0_benchmark_run+0x5dd>
 1511ecd:	4c 8b 74 24 58       	mov    0x58(%rsp),%r14
 1511ed2:	45 31 ed             	xor    %r13d,%r13d
 1511ed5:	45 31 ff             	xor    %r15d,%r15d
 1511ed8:	e9 11 03 00 00       	jmp    15121ee <tier0_benchmark_run+0x8ee>
 1511edd:	62 e2 7d 48 58 25 f9 e5 06 ff 	vpbroadcastd -0xf91a07(%rip),%zmm20        # 5804e0 <tier0_emit_x87.operations+0x98>
 1511ee7:	62 e2 7d 48 58 2d f3 e5 06 ff 	vpbroadcastd -0xf91a0d(%rip),%zmm21        # 5804e4 <tier0_emit_x87.operations+0x9c>
 1511ef1:	62 e2 7d 48 58 35 ed e5 06 ff 	vpbroadcastd -0xf91a13(%rip),%zmm22        # 5804e8 <tier0_emit_x87.operations+0xa0>
 1511efb:	62 e2 7d 48 58 3d e7 e5 06 ff 	vpbroadcastd -0xf91a19(%rip),%zmm23        # 5804ec <tier0_emit_x87.operations+0xa4>
 1511f05:	62 62 7d 48 58 05 e1 e5 06 ff 	vpbroadcastd -0xf91a1f(%rip),%zmm24        # 5804f0 <tier0_emit_x87.operations+0xa8>
 1511f0f:	62 62 7d 48 58 0d db e5 06 ff 	vpbroadcastd -0xf91a25(%rip),%zmm25        # 5804f4 <tier0_emit_x87.operations+0xac>
 1511f19:	62 62 7d 48 58 15 d5 e5 06 ff 	vpbroadcastd -0xf91a2b(%rip),%zmm26        # 5804f8 <tier0_emit_x87.operations+0xb0>
 1511f23:	62 62 7d 48 58 1d cf e5 06 ff 	vpbroadcastd -0xf91a31(%rip),%zmm27        # 5804fc <tier0_emit_x87.operations+0xb4>
 1511f2d:	62 62 7d 48 58 25 c9 e5 06 ff 	vpbroadcastd -0xf91a37(%rip),%zmm28        # 580500 <tier0_emit_x87.operations+0xb8>
 1511f37:	62 62 7d 48 58 2d c3 e5 06 ff 	vpbroadcastd -0xf91a3d(%rip),%zmm29        # 580504 <tier0_emit_x87.operations+0xbc>
 1511f41:	62 62 7d 48 58 35 bd e5 06 ff 	vpbroadcastd -0xf91a43(%rip),%zmm30        # 580508 <tier0_emit_x87.operations+0xc0>
 1511f4b:	62 62 7d 48 58 3d b7 e5 06 ff 	vpbroadcastd -0xf91a49(%rip),%zmm31        # 58050c <tier0_emit_x87.operations+0xc4>
 1511f55:	62 72 7d 48 58 2d b1 e5 06 ff 	vpbroadcastd -0xf91a4f(%rip),%zmm13        # 580510 <tier0_emit_x87.operations+0xc8>
 1511f5f:	62 72 7d 48 58 3d 6f e5 06 ff 	vpbroadcastd -0xf91a91(%rip),%zmm15        # 5804d8 <tier0_emit_x87.operations+0x90>
 1511f69:	62 72 7d 48 5a 25 ad 3d 06 ff 	vbroadcasti32x4 -0xf9c253(%rip),%zmm12        # 575d20 <x86_effects_unknown+0x2c0>
 1511f73:	62 e2 7d 48 58 15 53 e5 06 ff 	vpbroadcastd -0xf91aad(%rip),%zmm18        # 5804d0 <tier0_emit_x87.operations+0x88>
 1511f7d:	4c 8b 74 24 58       	mov    0x58(%rsp),%r14
 1511f82:	48 8d 86 c0 00 00 00 	lea    0xc0(%rsi),%rax
 1511f89:	62 a3 7d 40 25 c0 ff 	vpternlogd $0xff,%zmm16,%zmm16,%zmm16
 1511f90:	4c 8d 1d e9 48 15 0d 	lea    0xd1548e9(%rip),%r11        # e666880 <x86_template_storage>
 1511f97:	31 c9                	xor    %ecx,%ecx
 1511f99:	45 31 ed             	xor    %r13d,%r13d
 1511f9c:	0f 1f 40 00          	nopl   0x0(%rax)
 1511fa0:	62 f1 fe 48 6f 40 fd 	vmovdqu64 -0xc0(%rax),%zmm0
 1511fa7:	62 f1 fe 48 6f 50 fe 	vmovdqu64 -0x80(%rax),%zmm2
 1511fae:	62 f1 fe 48 6f 58 ff 	vmovdqu64 -0x40(%rax),%zmm3
 1511fb5:	62 f1 fe 48 6f 20    	vmovdqu64 (%rax),%zmm4
 1511fbb:	62 e2 7d 48 5a 1d 6b 3d 06 ff 	vbroadcasti32x4 -0xf9c295(%rip),%zmm19        # 575d30 <x86_effects_unknown+0x2d0>
 1511fc5:	62 71 fd 48 6f f6    	vmovdqa64 %zmm6,%zmm14
 1511fcb:	c5 fc 46 c8          	kxnorw %k0,%k0,%k1
 1511fcf:	44 89 ea             	mov    %r13d,%edx
 1511fd2:	4c 8d 79 10          	lea    0x10(%rcx),%r15
 1511fd6:	48 05 00 01 00 00    	add    $0x100,%rax
 1511fdc:	62 f1 7d 48 62 ca    	vpunpckldq %zmm2,%zmm0,%zmm1
 1511fe2:	62 f1 65 48 62 ec    	vpunpckldq %zmm4,%zmm3,%zmm5
 1511fe8:	62 f1 7d 48 6a c2    	vpunpckhdq %zmm2,%zmm0,%zmm0
 1511fee:	62 f1 65 48 6a e4    	vpunpckhdq %zmm4,%zmm3,%zmm4
 1511ff4:	62 f1 fd 48 6c dc    	vpunpcklqdq %zmm4,%zmm0,%zmm3
 1511ffa:	62 f1 fd 48 6d c4    	vpunpckhqdq %zmm4,%zmm0,%zmm0
 1512000:	62 f1 f5 48 6d cd    	vpunpckhqdq %zmm5,%zmm1,%zmm1
 1512006:	62 f1 7d 48 72 f0 04 	vpslld $0x4,%zmm0,%zmm0
 151200d:	62 f2 f5 40 83 e3    	vpmultishiftqb %zmm3,%zmm17,%zmm4
 1512013:	62 f2 9d 48 83 eb    	vpmultishiftqb %zmm3,%zmm12,%zmm5
 1512019:	62 f2 75 48 27 c1    	vptestmd %zmm1,%zmm1,%k0
 151201f:	62 f1 7d 48 db d6    	vpandd %zmm6,%zmm0,%zmm2
 1512025:	62 f2 b5 48 83 f3    	vpmultishiftqb %zmm3,%zmm9,%zmm6
 151202b:	62 d3 5d 48 25 ef d8 	vpternlogd $0xd8,%zmm15,%zmm4,%zmm5
 1512032:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 1512036:	62 f1 5d 48 72 f3 04 	vpslld $0x4,%zmm3,%zmm4
 151203d:	62 f3 4d 58 25 2d 94 e4 06 ff d8 	vpternlogd $0xd8,-0xf91b6c(%rip){1to16},%zmm6,%zmm5        # 5804dc <tier0_emit_x87.operations+0x94>
 1512048:	62 d2 7d 49 90 44 93 13 	vpgatherdd 0x4c(%r11,%zmm2,4),%zmm0{%k1}
 1512050:	62 f1 6d 48 72 d3 1a 	vpsrld $0x1a,%zmm3,%zmm2
 1512057:	62 f2 65 40 00 f3    	vpshufb %zmm3,%zmm19,%zmm6
 151205d:	62 e1 fd 48 6f df    	vmovdqa64 %zmm7,%zmm19
 1512063:	62 f1 5d 48 72 e4 1f 	vpsrad $0x1f,%zmm4,%zmm4
 151206a:	62 f2 6d 48 36 d7    	vpermd %zmm7,%zmm2,%zmm2
 1512070:	62 f1 45 48 72 d3 08 	vpsrld $0x8,%zmm3,%zmm7
 1512077:	62 b3 6d 40 25 dd 6c 	vpternlogd $0x6c,%zmm21,%zmm18,%zmm3
 151207e:	62 b1 65 48 fe d8    	vpaddd %zmm16,%zmm3,%zmm3
 1512084:	62 b3 6d 40 25 fe 6c 	vpternlogd $0x6c,%zmm22,%zmm18,%zmm7
 151208b:	62 b1 45 48 fe f8    	vpaddd %zmm16,%zmm7,%zmm7
 1512091:	62 93 45 40 25 d8 ea 	vpternlogd $0xea,%zmm24,%zmm23,%zmm3
 1512098:	62 93 45 48 25 d9 f8 	vpternlogd $0xf8,%zmm25,%zmm7,%zmm3
 151209f:	62 91 55 48 db fa    	vpandd %zmm26,%zmm5,%zmm7
 15120a5:	62 f1 55 48 72 d5 03 	vpsrld $0x3,%zmm5,%zmm5
 15120ac:	62 f3 7d 48 25 fb f8 	vpternlogd $0xf8,%zmm3,%zmm0,%zmm7
 15120b3:	62 93 7d 48 25 ec a2 	vpternlogd $0xa2,%zmm28,%zmm0,%zmm5
 15120ba:	62 92 45 48 3b db    	vpminud %zmm27,%zmm7,%zmm3
 15120c0:	62 f1 5d 48 db fe    	vpandd %zmm6,%zmm4,%zmm7
 15120c6:	62 93 6d 48 25 fe ec 	vpternlogd $0xec,%zmm30,%zmm2,%zmm7
 15120cd:	62 92 55 48 3b d5    	vpminud %zmm29,%zmm5,%zmm2
 15120d3:	62 93 7d 48 25 ff f8 	vpternlogd $0xf8,%zmm31,%zmm0,%zmm7
 15120da:	62 f3 6d 48 25 fb fe 	vpternlogd $0xfe,%zmm3,%zmm2,%zmm7
 15120e1:	62 f1 65 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm3
 15120e8:	62 f1 65 48 ef d1    	vpxord %zmm1,%zmm3,%zmm2
 15120ee:	62 b1 75 48 fe d8    	vpaddd %zmm16,%zmm1,%zmm3
 15120f4:	62 f2 7d 48 44 d2    	vplzcntd %zmm2,%zmm2
 15120fa:	62 f2 5d 40 45 d2    	vpsrlvd %zmm2,%zmm20,%zmm2
 1512100:	62 f3 75 48 25 da 14 	vpternlogd $0x14,%zmm2,%zmm1,%zmm3
 1512107:	62 f1 6d 48 72 f6 10 	vpslld $0x10,%zmm6,%zmm2
 151210e:	62 f2 7e 48 38 c8    	vpmovm2d %k0,%zmm1
 1512114:	62 d1 fd 48 6f f6    	vmovdqa64 %zmm14,%zmm6
 151211a:	62 f1 0d 48 72 d0 1d 	vpsrld $0x1d,%zmm0,%zmm14
 1512121:	62 f1 6d 48 72 e2 1f 	vpsrad $0x1f,%zmm2,%zmm2
 1512128:	62 f3 5d 48 25 ca c8 	vpternlogd $0xc8,%zmm2,%zmm4,%zmm1
 151212f:	62 f1 5d 58 db 25 db e3 06 ff 	vpandd -0xf91c25(%rip){1to16},%zmm4,%zmm4        # 580514 <tier0_emit_x87.operations+0xcc>
 1512139:	62 d2 65 48 14 d6    	vprorvd %zmm14,%zmm3,%zmm2
 151213f:	62 d1 75 48 db cd    	vpandd %zmm13,%zmm1,%zmm1
 1512145:	62 f1 6d 48 72 e2 1f 	vpsrad $0x1f,%zmm2,%zmm2
 151214c:	62 f3 6d 48 25 e1 b8 	vpternlogd $0xb8,%zmm1,%zmm2,%zmm4
 1512153:	62 b1 55 48 fe d0    	vpaddd %zmm16,%zmm5,%zmm2
 1512159:	62 f1 5d 48 eb cf    	vpord  %zmm7,%zmm4,%zmm1
 151215f:	62 f3 7d 58 25 0d ae e3 06 ff 20 	vpternlogd $0x20,-0xf91c52(%rip){1to16},%zmm0,%zmm1        # 580518 <tier0_emit_x87.operations+0xd0>
 151216a:	62 f1 7d 58 db 05 a8 e3 06 ff 	vpandd -0xf91c58(%rip){1to16},%zmm0,%zmm0        # 58051c <tier0_emit_x87.operations+0xd4>
 1512174:	62 f1 6d 48 72 e2 1f 	vpsrad $0x1f,%zmm2,%zmm2
 151217b:	62 b1 fd 48 6f fb    	vmovdqa64 %zmm19,%zmm7
 1512181:	62 f2 7d 48 55 c9    	vpopcntd %zmm1,%zmm1
 1512187:	62 f1 6d 48 fe c0    	vpaddd %zmm0,%zmm2,%zmm0
 151218d:	62 f1 7d 48 fe c1    	vpaddd %zmm1,%zmm0,%zmm0
 1512193:	c5 f9 6f 0d 45 3b 06 ff 	vmovdqa -0xf9c4bb(%rip),%xmm1        # 575ce0 <x86_effects_unknown+0x280>
 151219b:	62 f2 75 48 8d c0    	vpermb %zmm0,%zmm1,%zmm0
 15121a1:	62 f2 fd 18 40 0d 65 df 06 ff 	vpmullq -0xf9209b(%rip){1to2},%xmm0,%xmm1        # 580110 <x86_semantics_benchmark_code.registers+0x120>
 15121ab:	c4 e2 71 00 15 3c 3b 06 ff 	vpshufb -0xf9c4c4(%rip),%xmm1,%xmm2        # 575cf0 <x86_effects_unknown+0x290>
 15121b4:	c5 e9 fc c9          	vpaddb %xmm1,%xmm2,%xmm1
 15121b8:	62 d2 7d 48 7c d5    	vpbroadcastd %r13d,%zmm2
 15121be:	c5 f1 f8 c0          	vpsubb %xmm0,%xmm1,%xmm0
 15121c2:	c4 c3 79 14 cd 0f    	vpextrb $0xf,%xmm1,%r13d
 15121c8:	62 f2 7d 48 31 c0    	vpmovzxbd %xmm0,%zmm0
 15121ce:	41 01 d5             	add    %edx,%r13d
 15121d1:	62 f1 6d 48 fe c0    	vpaddd %zmm0,%zmm2,%zmm0
 15121d7:	62 d1 fe 48 7f 04 8e 	vmovdqu64 %zmm0,(%r14,%rcx,4)
 15121de:	48 83 c1 20          	add    $0x20,%rcx
 15121e2:	4c 39 c9             	cmp    %r9,%rcx
 15121e5:	4c 89 f9             	mov    %r15,%rcx
 15121e8:	0f 86 b2 fd ff ff    	jbe    1511fa0 <tier0_benchmark_run+0x6a0>
 15121ee:	4c 89 cb             	mov    %r9,%rbx
 15121f1:	4c 29 fb             	sub    %r15,%rbx
 15121f4:	4c 89 44 24 10       	mov    %r8,0x10(%rsp)
 15121f9:	0f 86 92 03 00 00    	jbe    1512591 <tier0_benchmark_run+0xc91>
 15121ff:	4c 89 fe             	mov    %r15,%rsi
 1512202:	48 c1 e6 04          	shl    $0x4,%rsi
 1512206:	48 03 74 24 50       	add    0x50(%rsp),%rsi
 151220b:	48 89 da             	mov    %rbx,%rdx
 151220e:	48 c1 e2 04          	shl    $0x4,%rdx
 1512212:	48 8d bc 24 c0 01 00 00 	lea    0x1c0(%rsp),%rdi
 151221a:	62 71 fd 48 7f 44 24 0a 	vmovdqa64 %zmm8,0x280(%rsp)
 1512222:	62 71 fd 48 7f 44 24 09 	vmovdqa64 %zmm8,0x240(%rsp)
 151222a:	62 71 fd 48 7f 44 24 08 	vmovdqa64 %zmm8,0x200(%rsp)
 1512232:	62 71 fd 48 7f 44 24 07 	vmovdqa64 %zmm8,0x1c0(%rsp)
 151223a:	c5 f8 77             	vzeroupper
 151223d:	e8 0e 22 25 ff       	call   764450 <memcpy@plt>
 1512242:	62 f1 fd 48 6f 44 24 07 	vmovdqa64 0x1c0(%rsp),%zmm0
 151224a:	62 f1 fd 48 6f 54 24 08 	vmovdqa64 0x200(%rsp),%zmm2
 1512252:	62 f1 fd 48 6f 5c 24 09 	vmovdqa64 0x240(%rsp),%zmm3
 151225a:	62 f1 fd 48 6f 64 24 0a 	vmovdqa64 0x280(%rsp),%zmm4
 1512262:	62 72 7d 48 58 2d 68 e2 06 ff 	vpbroadcastd -0xf91d98(%rip),%zmm13        # 5804d4 <tier0_emit_x87.operations+0x8c>
 151226c:	62 f2 7d 48 5a 35 aa 3a 06 ff 	vbroadcasti32x4 -0xf9c556(%rip),%zmm6        # 575d20 <x86_effects_unknown+0x2c0>
 1512276:	62 e2 7d 48 5a 15 80 3a 06 ff 	vbroadcasti32x4 -0xf9c580(%rip),%zmm18        # 575d00 <x86_effects_unknown+0x2a0>
 1512280:	62 72 7d 48 58 3d 4e e2 06 ff 	vpbroadcastd -0xf91db2(%rip),%zmm15        # 5804d8 <tier0_emit_x87.operations+0x90>
 151228a:	62 72 7d 48 5a 0d 7c 3a 06 ff 	vbroadcasti32x4 -0xf9c584(%rip),%zmm9        # 575d10 <x86_effects_unknown+0x2b0>
 1512294:	62 71 fd 48 6f 35 62 e5 00 ff 	vmovdqa64 -0xff1a9e(%rip),%zmm14        # 520800 <branch_sizing_patterns+0xa70>
 151229e:	62 e2 7d 48 58 25 3c e2 06 ff 	vpbroadcastd -0xf91dc4(%rip),%zmm20        # 5804e4 <tier0_emit_x87.operations+0x9c>
 15122a8:	62 e2 7d 48 5a 0d 7e 3a 06 ff 	vbroadcasti32x4 -0xf9c582(%rip),%zmm17        # 575d30 <x86_effects_unknown+0x2d0>
 15122b2:	62 e2 7d 48 58 05 20 e2 06 ff 	vpbroadcastd -0xf91de0(%rip),%zmm16        # 5804dc <tier0_emit_x87.operations+0x94>
 15122bc:	62 f2 7d 48 58 3d 0a e2 06 ff 	vpbroadcastd -0xf91df6(%rip),%zmm7        # 5804d0 <tier0_emit_x87.operations+0x88>
 15122c6:	62 e2 7d 48 58 2d 18 e2 06 ff 	vpbroadcastd -0xf91de8(%rip),%zmm21        # 5804e8 <tier0_emit_x87.operations+0xa0>
 15122d0:	62 e2 7d 48 58 3d 16 e2 06 ff 	vpbroadcastd -0xf91dea(%rip),%zmm23        # 5804f0 <tier0_emit_x87.operations+0xa8>
 15122da:	62 e2 7d 48 58 35 08 e2 06 ff 	vpbroadcastd -0xf91df8(%rip),%zmm22        # 5804ec <tier0_emit_x87.operations+0xa4>
 15122e4:	62 62 7d 48 58 0d 0a e2 06 ff 	vpbroadcastd -0xf91df6(%rip),%zmm25        # 5804f8 <tier0_emit_x87.operations+0xb0>
 15122ee:	62 62 7d 48 58 05 fc e1 06 ff 	vpbroadcastd -0xf91e04(%rip),%zmm24        # 5804f4 <tier0_emit_x87.operations+0xac>
 15122f8:	62 62 7d 48 58 35 06 e2 06 ff 	vpbroadcastd -0xf91dfa(%rip),%zmm30        # 580508 <tier0_emit_x87.operations+0xc0>
 1512302:	62 62 7d 48 58 25 f4 e1 06 ff 	vpbroadcastd -0xf91e0c(%rip),%zmm28        # 580500 <tier0_emit_x87.operations+0xb8>
 151230c:	62 62 7d 48 58 3d f6 e1 06 ff 	vpbroadcastd -0xf91e0a(%rip),%zmm31        # 58050c <tier0_emit_x87.operations+0xc4>
 1512316:	62 62 7d 48 58 2d e4 e1 06 ff 	vpbroadcastd -0xf91e1c(%rip),%zmm29        # 580504 <tier0_emit_x87.operations+0xbc>
 1512320:	62 62 7d 48 58 15 d2 e1 06 ff 	vpbroadcastd -0xf91e2e(%rip),%zmm26        # 5804fc <tier0_emit_x87.operations+0xb4>
 151232a:	c5 fc 46 c8          	kxnorw %k0,%k0,%k1
 151232e:	48 8d 05 4b 45 15 0d 	lea    0xd15454b(%rip),%rax        # e666880 <x86_template_storage>
 1512335:	62 53 1d 48 25 e4 ff 	vpternlogd $0xff,%zmm12,%zmm12,%zmm12
 151233c:	62 62 7d 48 58 1d 9a e1 06 ff 	vpbroadcastd -0xf91e66(%rip),%zmm27        # 5804e0 <tier0_emit_x87.operations+0x98>
 1512346:	62 e2 7d 48 58 1d c0 e1 06 ff 	vpbroadcastd -0xf91e40(%rip),%zmm19        # 580510 <tier0_emit_x87.operations+0xc8>
 1512350:	62 72 7d 48 58 1d da e1 06 ff 	vpbroadcastd -0xf91e26(%rip),%zmm11        # 580534 <tier0_emit_x87.operations+0xec>
 151235a:	62 72 7d 48 58 15 cc e1 06 ff 	vpbroadcastd -0xf91e34(%rip),%zmm10        # 580530 <tier0_emit_x87.operations+0xe8>
 1512364:	4c 8b 4c 24 18       	mov    0x18(%rsp),%r9
 1512369:	4c 8b 44 24 10       	mov    0x10(%rsp),%r8
 151236e:	48 8b 7c 24 30       	mov    0x30(%rsp),%rdi
 1512373:	c4 41 39 ef c0       	vpxor  %xmm8,%xmm8,%xmm8
 1512378:	62 f1 7d 48 62 ca    	vpunpckldq %zmm2,%zmm0,%zmm1
 151237e:	62 f1 65 48 62 ec    	vpunpckldq %zmm4,%zmm3,%zmm5
 1512384:	62 f1 7d 48 6a c2    	vpunpckhdq %zmm2,%zmm0,%zmm0
 151238a:	62 f1 65 48 6a e4    	vpunpckhdq %zmm4,%zmm3,%zmm4
 1512390:	62 f1 fd 48 6c dc    	vpunpcklqdq %zmm4,%zmm0,%zmm3
 1512396:	62 f1 fd 48 6d c4    	vpunpckhqdq %zmm4,%zmm0,%zmm0
 151239c:	62 f1 f5 48 6d cd    	vpunpckhqdq %zmm5,%zmm1,%zmm1
 15123a2:	62 f1 7d 48 72 f0 04 	vpslld $0x4,%zmm0,%zmm0
 15123a9:	62 f2 cd 48 83 eb    	vpmultishiftqb %zmm3,%zmm6,%zmm5
 15123af:	62 f2 ed 40 83 e3    	vpmultishiftqb %zmm3,%zmm18,%zmm4
 15123b5:	62 f2 b5 48 83 f3    	vpmultishiftqb %zmm3,%zmm9,%zmm6
 15123bb:	62 f2 75 48 27 c1    	vptestmd %zmm1,%zmm1,%k0
 15123c1:	62 d1 7d 48 db d5    	vpandd %zmm13,%zmm0,%zmm2
 15123c7:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 15123cb:	62 d3 5d 48 25 ef d8 	vpternlogd $0xd8,%zmm15,%zmm4,%zmm5
 15123d2:	62 f1 5d 48 72 f3 04 	vpslld $0x4,%zmm3,%zmm4
 15123d9:	62 f2 7d 49 90 44 90 13 	vpgatherdd 0x4c(%rax,%zmm2,4),%zmm0{%k1}
 15123e1:	62 f1 6d 48 72 d3 1a 	vpsrld $0x1a,%zmm3,%zmm2
 15123e8:	62 b3 4d 48 25 e8 d8 	vpternlogd $0xd8,%zmm16,%zmm6,%zmm5
 15123ef:	62 e1 fd 48 6f c7    	vmovdqa64 %zmm7,%zmm16
 15123f5:	62 f1 45 48 72 d3 08 	vpsrld $0x8,%zmm3,%zmm7
 15123fc:	62 f2 75 40 00 f3    	vpshufb %zmm3,%zmm17,%zmm6
 1512402:	62 b3 7d 40 25 dc 6c 	vpternlogd $0x6c,%zmm20,%zmm16,%zmm3
 1512409:	62 f1 5d 48 72 e4 1f 	vpsrad $0x1f,%zmm4,%zmm4
 1512410:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1512415:	62 d2 6d 48 36 d6    	vpermd %zmm14,%zmm2,%zmm2
 151241b:	62 d1 65 48 fe dc    	vpaddd %zmm12,%zmm3,%zmm3
 1512421:	62 b3 7d 40 25 fd 6c 	vpternlogd $0x6c,%zmm21,%zmm16,%zmm7
 1512428:	c4 e2 61 f7 c0       	shlx   %ebx,%eax,%eax
 151242d:	62 d1 45 48 fe fc    	vpaddd %zmm12,%zmm7,%zmm7
 1512433:	62 b3 4d 40 25 df ea 	vpternlogd $0xea,%zmm23,%zmm22,%zmm3
 151243a:	62 e1 5d 48 db ce    	vpandd %zmm6,%zmm4,%zmm17
 1512440:	62 f1 05 48 72 f6 10 	vpslld $0x10,%zmm6,%zmm15
 1512447:	62 d1 fd 48 6f f5    	vmovdqa64 %zmm13,%zmm6
 151244d:	f7 d0                	not    %eax
 151244f:	62 93 45 48 25 d8 f8 	vpternlogd $0xf8,%zmm24,%zmm7,%zmm3
 1512456:	62 91 55 48 db f9    	vpandd %zmm25,%zmm5,%zmm7
 151245c:	62 f1 55 48 72 d5 03 	vpsrld $0x3,%zmm5,%zmm5
 1512463:	c5 fb 92 c8          	kmovd  %eax,%k1
 1512467:	62 f3 7d 48 25 fb f8 	vpternlogd $0xf8,%zmm3,%zmm0,%zmm7
 151246e:	62 93 7d 48 25 ec a2 	vpternlogd $0xa2,%zmm28,%zmm0,%zmm5
 1512475:	62 f1 15 48 72 d0 1d 	vpsrld $0x1d,%zmm0,%zmm13
 151247c:	62 83 6d 48 25 ce ec 	vpternlogd $0xec,%zmm30,%zmm2,%zmm17
 1512483:	62 92 45 48 3b da    	vpminud %zmm26,%zmm7,%zmm3
 1512489:	62 92 55 48 3b d5    	vpminud %zmm29,%zmm5,%zmm2
 151248f:	62 d1 fd 48 6f fe    	vmovdqa64 %zmm14,%zmm7
 1512495:	62 83 7d 48 25 cf f8 	vpternlogd $0xf8,%zmm31,%zmm0,%zmm17
 151249c:	62 e3 6d 48 25 cb fe 	vpternlogd $0xfe,%zmm3,%zmm2,%zmm17
 15124a3:	62 f1 65 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm3
 15124aa:	62 f1 65 48 ef d1    	vpxord %zmm1,%zmm3,%zmm2
 15124b0:	62 d1 75 48 fe dc    	vpaddd %zmm12,%zmm1,%zmm3
 15124b6:	62 f2 7d 48 44 d2    	vplzcntd %zmm2,%zmm2
 15124bc:	62 f2 25 40 45 d2    	vpsrlvd %zmm2,%zmm27,%zmm2
 15124c2:	62 f3 75 48 25 da 14 	vpternlogd $0x14,%zmm2,%zmm1,%zmm3
 15124c9:	62 d1 6d 48 72 e7 1f 	vpsrad $0x1f,%zmm15,%zmm2
 15124d0:	62 f2 7e 48 38 c8    	vpmovm2d %k0,%zmm1
 15124d6:	62 f3 5d 48 25 ca c8 	vpternlogd $0xc8,%zmm2,%zmm4,%zmm1
 15124dd:	62 f1 5d 58 db 25 2d e0 06 ff 	vpandd -0xf91fd3(%rip){1to16},%zmm4,%zmm4        # 580514 <tier0_emit_x87.operations+0xcc>
 15124e7:	62 d2 65 48 14 d5    	vprorvd %zmm13,%zmm3,%zmm2
 15124ed:	62 b1 75 48 db cb    	vpandd %zmm19,%zmm1,%zmm1
 15124f3:	62 f1 6d 48 72 e2 1f 	vpsrad $0x1f,%zmm2,%zmm2
 15124fa:	62 f3 6d 48 25 e1 b8 	vpternlogd $0xb8,%zmm1,%zmm2,%zmm4
 1512501:	62 d1 55 48 fe d4    	vpaddd %zmm12,%zmm5,%zmm2
 1512507:	62 b1 5d 48 eb c9    	vpord  %zmm17,%zmm4,%zmm1
 151250d:	62 f3 7d 58 25 0d 00 e0 06 ff 20 	vpternlogd $0x20,-0xf92000(%rip){1to16},%zmm0,%zmm1        # 580518 <tier0_emit_x87.operations+0xd0>
 1512518:	62 f1 7d 58 db 05 fa df 06 ff 	vpandd -0xf92006(%rip){1to16},%zmm0,%zmm0        # 58051c <tier0_emit_x87.operations+0xd4>
 1512522:	62 f1 6d 48 72 e2 1f 	vpsrad $0x1f,%zmm2,%zmm2
 1512529:	62 a1 fd 48 6f ca    	vmovdqa64 %zmm18,%zmm17
 151252f:	62 f2 7d 48 55 c9    	vpopcntd %zmm1,%zmm1
 1512535:	62 f1 6d 48 fe c0    	vpaddd %zmm0,%zmm2,%zmm0
 151253b:	62 f1 7d 48 fe c1    	vpaddd %zmm1,%zmm0,%zmm0
 1512541:	c5 f9 6f 0d 97 37 06 ff 	vmovdqa -0xf9c869(%rip),%xmm1        # 575ce0 <x86_effects_unknown+0x280>
 1512549:	62 f2 75 48 8d c0    	vpermb %zmm0,%zmm1,%zmm0
 151254f:	62 f2 fd 18 40 0d b7 db 06 ff 	vpmullq -0xf92449(%rip){1to2},%xmm0,%xmm1        # 580110 <x86_semantics_benchmark_code.registers+0x120>
 1512559:	c4 e2 71 00 15 8e 37 06 ff 	vpshufb -0xf9c872(%rip),%xmm1,%xmm2        # 575cf0 <x86_effects_unknown+0x290>
 1512562:	c5 e9 fc c9          	vpaddb %xmm1,%xmm2,%xmm1
 1512566:	62 d2 7d 48 7c d5    	vpbroadcastd %r13d,%zmm2
 151256c:	c5 f1 f8 c0          	vpsubb %xmm0,%xmm1,%xmm0
 1512570:	c4 e3 79 14 c8 0f    	vpextrb $0xf,%xmm1,%eax
 1512576:	62 f2 7d 48 31 c0    	vpmovzxbd %xmm0,%zmm0
 151257c:	44 01 e8             	add    %r13d,%eax
 151257f:	41 89 c5             	mov    %eax,%r13d
 1512582:	62 f1 6d 48 fe c0    	vpaddd %zmm0,%zmm2,%zmm0
 1512588:	62 91 7e 49 7f 04 be 	vmovdqu32 %zmm0,(%r14,%r15,4){%k1}
 151258f:	eb 0a                	jmp    151259b <tier0_benchmark_run+0xc9b>
 1512591:	62 e2 7d 48 58 05 35 df 06 ff 	vpbroadcastd -0xf920cb(%rip),%zmm16        # 5804d0 <tier0_emit_x87.operations+0x88>
 151259b:	4c 8b 74 24 48       	mov    0x48(%rsp),%r14
 15125a0:	45 31 ff             	xor    %r15d,%r15d
 15125a3:	48 8d 04 bd 00 00 00 00 	lea    0x0(,%rdi,4),%rax
 15125ab:	44 89 e9             	mov    %r13d,%ecx
 15125ae:	48 01 c1             	add    %rax,%rcx
 15125b1:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
 15125b6:	48 81 f9 ff ff ff 7f 	cmp    $0x7fffffff,%rcx
 15125bd:	0f 87 7d f5 ff ff    	ja     1511b40 <tier0_benchmark_run+0x240>
 15125c3:	48 8b 8c 24 a0 00 00 00 	mov    0xa0(%rsp),%rcx
 15125cb:	48 8b 94 24 c0 00 00 00 	mov    0xc0(%rsp),%rdx
 15125d3:	c7 01 00 00 00 00    	movl   $0x0,(%rcx)
 15125d9:	c7 02 00 00 00 00    	movl   $0x0,(%rdx)
 15125df:	48 85 ff             	test   %rdi,%rdi
 15125e2:	0f 84 58 f5 ff ff    	je     1511b40 <tier0_benchmark_run+0x240>
 15125e8:	48 8b 54 24 70       	mov    0x70(%rsp),%rdx
 15125ed:	4c 8d 70 0c          	lea    0xc(%rax),%r14
 15125f1:	48 8d 47 ff          	lea    -0x1(%rdi),%rax
 15125f5:	62 d2 7d 48 7c c9    	vpbroadcastd %r9d,%zmm1
 15125fb:	62 d2 7d 48 7c c5    	vpbroadcastd %r13d,%zmm0
 1512601:	4c 89 a4 24 b0 00 00 00 	mov    %r12,0xb0(%rsp)
 1512609:	48 89 c6             	mov    %rax,%rsi
 151260c:	48 c1 ee 04          	shr    $0x4,%rsi
 1512610:	4c 8d 1c 95 00 00 00 00 	lea    0x0(,%rdx,4),%r11
 1512618:	4c 89 9c 24 98 00 00 00 	mov    %r11,0x98(%rsp)
 1512620:	0f 84 3c 04 00 00    	je     1512a62 <tier0_benchmark_run+0x1162>
 1512626:	4c 8b 4c 24 28       	mov    0x28(%rsp),%r9
 151262b:	48 8b 8c 24 a8 00 00 00 	mov    0xa8(%rsp),%rcx
 1512633:	48 89 84 24 d8 00 00 00 	mov    %rax,0xd8(%rsp)
 151263b:	62 51 fd 48 6f e2    	vmovdqa64 %zmm10,%zmm12
 1512641:	62 51 fd 48 6f eb    	vmovdqa64 %zmm11,%zmm13
 1512647:	62 72 7d 48 58 15 d3 de 06 ff 	vpbroadcastd -0xf9212d(%rip),%zmm10        # 580524 <tier0_emit_x87.operations+0xdc>
 1512651:	62 72 7d 48 58 1d d1 de 06 ff 	vpbroadcastd -0xf9212f(%rip),%zmm11        # 58052c <tier0_emit_x87.operations+0xe4>
 151265b:	62 72 7d 48 58 35 bb de 06 ff 	vpbroadcastd -0xf92145(%rip),%zmm14        # 580520 <tier0_emit_x87.operations+0xd8>
 1512665:	62 72 7d 48 58 3d b9 de 06 ff 	vpbroadcastd -0xf92147(%rip),%zmm15        # 580528 <tier0_emit_x87.operations+0xe0>
 151266f:	48 ff c6             	inc    %rsi
 1512672:	c5 e9 ef d2          	vpxor  %xmm2,%xmm2,%xmm2
 1512676:	49 89 ff             	mov    %rdi,%r15
 1512679:	4c 89 b4 24 90 00 00 00 	mov    %r14,0x90(%rsp)
 1512681:	48 83 e6 fe          	and    $0xfffffffffffffffe,%rsi
 1512685:	49 8d 41 40          	lea    0x40(%r9),%rax
 1512689:	48 89 84 24 28 01 00 00 	mov    %rax,0x128(%rsp)
 1512691:	48 8d 41 40          	lea    0x40(%rcx),%rax
 1512695:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
 151269a:	c1 e1 06             	shl    $0x6,%ecx
 151269d:	48 03 4c 24 40       	add    0x40(%rsp),%rcx
 15126a2:	48 89 84 24 20 01 00 00 	mov    %rax,0x120(%rsp)
 15126aa:	48 8d 04 11          	lea    (%rcx,%rdx,1),%rax
 15126ae:	4d 8d 0c 08          	lea    (%r8,%rcx,1),%r9
 15126b2:	49 8d 84 00 80 00 00 00 	lea    0x80(%r8,%rax,1),%rax
 15126ba:	4c 89 8c 24 00 01 00 00 	mov    %r9,0x100(%rsp)
 15126c2:	4c 8b 8c 24 88 00 00 00 	mov    0x88(%rsp),%r9
 15126ca:	48 89 84 24 18 01 00 00 	mov    %rax,0x118(%rsp)
 15126d2:	4a 8d 04 19          	lea    (%rcx,%r11,1),%rax
 15126d6:	4c 8b 9c 24 80 00 00 00 	mov    0x80(%rsp),%r11
 15126de:	49 8d 84 00 80 00 00 00 	lea    0x80(%r8,%rax,1),%rax
 15126e6:	48 89 84 24 10 01 00 00 	mov    %rax,0x110(%rsp)
 15126ee:	48 8d 04 52          	lea    (%rdx,%rdx,2),%rax
 15126f2:	48 01 c8             	add    %rcx,%rax
 15126f5:	4d 01 d9             	add    %r11,%r9
 15126f8:	49 8d 84 00 80 00 00 00 	lea    0x80(%r8,%rax,1),%rax
 1512700:	49 01 c9             	add    %rcx,%r9
 1512703:	4b 8d 94 08 84 00 00 00 	lea    0x84(%r8,%r9,1),%rdx
 151270b:	45 31 c9             	xor    %r9d,%r9d
 151270e:	48 89 84 24 08 01 00 00 	mov    %rax,0x108(%rsp)
 1512716:	4a 8d 04 19          	lea    (%rcx,%r11,1),%rax
 151271a:	31 c9                	xor    %ecx,%ecx
 151271c:	49 8d 84 00 84 00 00 00 	lea    0x84(%r8,%rax,1),%rax
 1512724:	48 89 94 24 80 00 00 00 	mov    %rdx,0x80(%rsp)
 151272c:	48 89 84 24 f8 00 00 00 	mov    %rax,0xf8(%rsp)
 1512734:	66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 cs nopw 0x0(%rax,%rax,1)
 1512740:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1512745:	4c 8b ac 24 20 01 00 00 	mov    0x120(%rsp),%r13
 151274d:	4c 8b 94 24 28 01 00 00 	mov    0x128(%rsp),%r10
 1512755:	4c 89 fb             	mov    %r15,%rbx
 1512758:	48 83 eb 10          	sub    $0x10,%rbx
 151275c:	48 89 b4 24 88 00 00 00 	mov    %rsi,0x88(%rsp)
 1512764:	48 8b 74 24 58       	mov    0x58(%rsp),%rsi
 1512769:	c5 d1 ef ed          	vpxor  %xmm5,%xmm5,%xmm5
 151276d:	62 f1 fd 48 6f f0    	vmovdqa64 %zmm0,%zmm6
 1512773:	4c 8b 84 24 00 01 00 00 	mov    0x100(%rsp),%r8
 151277b:	48 8b 94 24 10 01 00 00 	mov    0x110(%rsp),%rdx
 1512783:	4c 8b 9c 24 f8 00 00 00 	mov    0xf8(%rsp),%r11
 151278b:	48 8b bc 24 80 00 00 00 	mov    0x80(%rsp),%rdi
 1512793:	c4 62 01 f7 f0       	shlx   %r15d,%eax,%r14d
 1512798:	b8 ff ff 00 00       	mov    $0xffff,%eax
 151279d:	41 f7 d6             	not    %r14d
 15127a0:	44 0f 43 f0          	cmovae %eax,%r14d
 15127a4:	48 8b 84 24 90 00 00 00 	mov    0x90(%rsp),%rax
 15127ac:	c4 c1 7b 92 ce       	kmovd  %r14d,%k1
 15127b1:	45 89 ce             	mov    %r9d,%r14d
 15127b4:	41 b9 ff ff ff ff    	mov    $0xffffffff,%r9d
 15127ba:	62 d1 7e c9 6f 64 8d ff 	vmovdqu32 -0x40(%r13,%rcx,4),%zmm4{%k1}{z}
 15127c2:	62 d1 7e c9 6f 5c 8a ff 	vmovdqu32 -0x40(%r10,%rcx,4),%zmm3{%k1}{z}
 15127ca:	c4 e1 f8 90 d9       	kmovq  %k1,%k3
 15127cf:	c4 42 61 f7 c9       	shlx   %ebx,%r9d,%r9d
 15127d4:	41 f7 d1             	not    %r9d
 15127d7:	62 f3 5d 49 1e d1 01 	vpcmpltud %zmm1,%zmm4,%k2{%k1}
 15127de:	62 f2 7d 4b 90 2c 9e 	vpgatherdd (%rsi,%zmm3,4),%zmm5{%k3}
 15127e5:	62 f1 65 48 fe db    	vpaddd %zmm3,%zmm3,%zmm3
 15127eb:	c4 e1 f8 90 d9       	kmovq  %k1,%k3
 15127f0:	62 f2 7d 4a 90 34 a6 	vpgatherdd (%rsi,%zmm4,4),%zmm6{%k2}
 15127f7:	62 f1 4d 48 fa e5    	vpsubd %zmm5,%zmm6,%zmm4
 15127fd:	62 d1 5d c9 fe e3    	vpaddd %zmm11,%zmm4,%zmm4{%k1}{z}
 1512803:	62 d1 5d 48 fe ec    	vpaddd %zmm12,%zmm4,%zmm5
 1512809:	62 d3 55 48 1e d5 01 	vpcmpltud %zmm13,%zmm5,%k2
 1512810:	c5 d1 ef ed          	vpxor  %xmm5,%xmm5,%xmm5
 1512814:	62 f2 7d 4b 90 2c d8 	vpgatherdd (%rax,%zmm3,8),%zmm5{%k3}
 151281b:	48 8b 84 24 08 01 00 00 	mov    0x108(%rsp),%rax
 1512823:	c5 ec 41 c1          	kandw  %k1,%k2,%k0
 1512827:	c5 78 93 e0          	kmovw  %k0,%r12d
 151282b:	45 09 e6             	or     %r12d,%r14d
 151282e:	4c 8b a4 24 18 01 00 00 	mov    0x118(%rsp),%r12
 1512836:	48 83 fb 10          	cmp    $0x10,%rbx
 151283a:	bb ff ff 00 00       	mov    $0xffff,%ebx
 151283f:	44 0f 43 cb          	cmovae %ebx,%r9d
 1512843:	49 83 c7 e0          	add    $0xffffffffffffffe0,%r15
 1512847:	62 d1 55 48 db de    	vpandd %zmm14,%zmm5,%zmm3
 151284d:	62 d1 65 48 76 da    	vpcmpeqd %zmm10,%zmm3,%k3
 1512853:	62 d2 7d 43 64 df    	vpblendmd %zmm15,%zmm16,%zmm3{%k3}
 1512859:	62 f1 7d c9 6f db    	vmovdqa32 %zmm3,%zmm3{%k1}{z}
 151285f:	62 f1 7d ca 6f eb    	vmovdqa32 %zmm3,%zmm5{%k2}{z}
 1512865:	62 d3 55 48 03 f0 0f 	valignd $0xf,%zmm8,%zmm5,%zmm6
 151286c:	62 d1 fd 48 7f 5c 88 01 	vmovdqa64 %zmm3,0x40(%r8,%rcx,4)
 1512874:	62 d1 fd 48 7f 64 8c ff 	vmovdqa64 %zmm4,-0x40(%r12,%rcx,4)
 151287c:	62 f1 fd 48 7f 64 8a ff 	vmovdqa64 %zmm4,-0x40(%rdx,%rcx,4)
 1512884:	c4 c1 7b 92 c9       	kmovd  %r9d,%k1
 1512889:	62 f1 fd 48 7f 6c 88 ff 	vmovdqa64 %zmm5,-0x40(%rax,%rcx,4)
 1512891:	c4 e1 f8 90 d9       	kmovq  %k1,%k3
 1512896:	62 f1 4d 48 fe f5    	vpaddd %zmm5,%zmm6,%zmm6
 151289c:	c5 d1 ef ed          	vpxor  %xmm5,%xmm5,%xmm5
 15128a0:	62 d3 cd 48 03 f8 07 	valignq $0x7,%zmm8,%zmm6,%zmm7
 15128a7:	62 f1 45 48 fe f6    	vpaddd %zmm6,%zmm7,%zmm6
 15128ad:	62 d3 cd 48 03 f8 06 	valignq $0x6,%zmm8,%zmm6,%zmm7
 15128b4:	62 f1 45 48 fe f6    	vpaddd %zmm6,%zmm7,%zmm6
 15128ba:	62 d3 cd 48 03 f8 04 	valignq $0x4,%zmm8,%zmm6,%zmm7
 15128c1:	62 f1 4d 48 fe d2    	vpaddd %zmm2,%zmm6,%zmm2
 15128c7:	62 f1 fd 48 6f f0    	vmovdqa64 %zmm0,%zmm6
 15128cd:	62 f1 6d 48 fe d7    	vpaddd %zmm7,%zmm2,%zmm2
 15128d3:	62 d1 fe 48 7f 54 8b ff 	vmovdqu64 %zmm2,-0x40(%r11,%rcx,4)
 15128db:	62 71 fe 48 7f 44 8f ff 	vmovdqu64 %zmm8,-0x40(%rdi,%rcx,4)
 15128e3:	62 f1 7d 48 70 d2 ff 	vpshufd $0xff,%zmm2,%zmm2
 15128ea:	62 d1 7e c9 6f 64 8d 00 	vmovdqu32 0x0(%r13,%rcx,4),%zmm4{%k1}{z}
 15128f2:	62 d1 7e c9 6f 1c 8a 	vmovdqu32 (%r10,%rcx,4),%zmm3{%k1}{z}
 15128f9:	62 f3 ed 48 43 d2 ff 	vshufi64x2 $0xff,%zmm2,%zmm2,%zmm2
 1512900:	62 f3 5d 49 1e d1 01 	vpcmpltud %zmm1,%zmm4,%k2{%k1}
 1512907:	62 f2 7d 4b 90 2c 9e 	vpgatherdd (%rsi,%zmm3,4),%zmm5{%k3}
 151290e:	62 f1 65 48 fe db    	vpaddd %zmm3,%zmm3,%zmm3
 1512914:	c4 e1 f8 90 d9       	kmovq  %k1,%k3
 1512919:	62 f2 7d 4a 90 34 a6 	vpgatherdd (%rsi,%zmm4,4),%zmm6{%k2}
 1512920:	48 8b b4 24 88 00 00 00 	mov    0x88(%rsp),%rsi
 1512928:	62 f1 4d 48 fa e5    	vpsubd %zmm5,%zmm6,%zmm4
 151292e:	62 d1 5d c9 fe e3    	vpaddd %zmm11,%zmm4,%zmm4{%k1}{z}
 1512934:	62 d1 5d 48 fe ec    	vpaddd %zmm12,%zmm4,%zmm5
 151293a:	62 d3 55 48 1e d5 01 	vpcmpltud %zmm13,%zmm5,%k2
 1512941:	c5 d1 ef ed          	vpxor  %xmm5,%xmm5,%xmm5
 1512945:	c5 ec 41 c1          	kandw  %k1,%k2,%k0
 1512949:	c5 78 93 c8          	kmovw  %k0,%r9d
 151294d:	45 09 f1             	or     %r14d,%r9d
 1512950:	4c 8b b4 24 90 00 00 00 	mov    0x90(%rsp),%r14
 1512958:	62 d2 7d 4b 90 2c de 	vpgatherdd (%r14,%zmm3,8),%zmm5{%k3}
 151295f:	62 d1 55 48 db de    	vpandd %zmm14,%zmm5,%zmm3
 1512965:	62 d1 65 48 76 da    	vpcmpeqd %zmm10,%zmm3,%k3
 151296b:	62 d2 7d 43 64 df    	vpblendmd %zmm15,%zmm16,%zmm3{%k3}
 1512971:	62 f1 7d c9 6f db    	vmovdqa32 %zmm3,%zmm3{%k1}{z}
 1512977:	62 f1 7d ca 6f eb    	vmovdqa32 %zmm3,%zmm5{%k2}{z}
 151297d:	62 d3 55 48 03 f0 0f 	valignd $0xf,%zmm8,%zmm5,%zmm6
 1512984:	62 d1 fd 48 7f 5c 88 02 	vmovdqa64 %zmm3,0x80(%r8,%rcx,4)
 151298c:	62 d1 fd 48 7f 24 8c 	vmovdqa64 %zmm4,(%r12,%rcx,4)
 1512993:	62 f1 fd 48 7f 24 8a 	vmovdqa64 %zmm4,(%rdx,%rcx,4)
 151299a:	62 f1 fd 48 7f 2c 88 	vmovdqa64 %zmm5,(%rax,%rcx,4)
 15129a1:	62 f1 4d 48 fe f5    	vpaddd %zmm5,%zmm6,%zmm6
 15129a7:	62 d3 cd 48 03 f8 07 	valignq $0x7,%zmm8,%zmm6,%zmm7
 15129ae:	62 f1 45 48 fe f6    	vpaddd %zmm6,%zmm7,%zmm6
 15129b4:	62 d3 cd 48 03 f8 06 	valignq $0x6,%zmm8,%zmm6,%zmm7
 15129bb:	62 f1 45 48 fe f6    	vpaddd %zmm6,%zmm7,%zmm6
 15129c1:	62 d3 cd 48 03 f8 04 	valignq $0x4,%zmm8,%zmm6,%zmm7
 15129c8:	62 f1 4d 48 fe f7    	vpaddd %zmm7,%zmm6,%zmm6
 15129ce:	62 f1 4d 48 fe d2    	vpaddd %zmm2,%zmm6,%zmm2
 15129d4:	62 d1 fe 48 7f 14 8b 	vmovdqu64 %zmm2,(%r11,%rcx,4)
 15129db:	62 f1 7d 48 70 d2 ff 	vpshufd $0xff,%zmm2,%zmm2
 15129e2:	62 71 fe 48 7f 04 8f 	vmovdqu64 %zmm8,(%rdi,%rcx,4)
 15129e9:	48 83 c1 20          	add    $0x20,%rcx
 15129ed:	48 83 c6 fe          	add    $0xfffffffffffffffe,%rsi
 15129f1:	62 f3 ed 48 43 d2 ff 	vshufi64x2 $0xff,%zmm2,%zmm2,%zmm2
 15129f8:	0f 85 42 fd ff ff    	jne    1512740 <tier0_benchmark_run+0xe40>
 15129fe:	62 f2 7d 48 58 35 cc da 06 ff 	vpbroadcastd -0xf92534(%rip),%zmm6        # 5804d4 <tier0_emit_x87.operations+0x8c>
 1512a08:	62 f1 fd 48 6f 3d ee dd 00 ff 	vmovdqa64 -0xff2212(%rip),%zmm7        # 520800 <branch_sizing_patterns+0xa70>
 1512a12:	62 e2 7d 48 5a 0d e4 32 06 ff 	vbroadcasti32x4 -0xf9cd1c(%rip),%zmm17        # 575d00 <x86_effects_unknown+0x2a0>
 1512a1c:	f6 84 24 d8 00 00 00 10 	testb  $0x10,0xd8(%rsp)
 1512a24:	48 8b 7c 24 30       	mov    0x30(%rsp),%rdi
 1512a29:	4c 8b 5c 24 58       	mov    0x58(%rsp),%r11
 1512a2e:	4c 8b a4 24 b0 00 00 00 	mov    0xb0(%rsp),%r12
 1512a36:	4c 8b 84 24 a0 00 00 00 	mov    0xa0(%rsp),%r8
 1512a3e:	41 bf 00 00 00 00    	mov    $0x0,%r15d
 1512a44:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
 1512a49:	41 bd ff ff 00 00    	mov    $0xffff,%r13d
 1512a4f:	62 51 fd 48 6f d4    	vmovdqa64 %zmm12,%zmm10
 1512a55:	62 51 fd 48 6f dd    	vmovdqa64 %zmm13,%zmm11
 1512a5b:	74 26                	je     1512a83 <tier0_benchmark_run+0x1183>
 1512a5d:	e9 67 01 00 00       	jmp    1512bc9 <tier0_benchmark_run+0x12c9>
 1512a62:	4c 8b 5c 24 58       	mov    0x58(%rsp),%r11
 1512a67:	4c 8b 84 24 a0 00 00 00 	mov    0xa0(%rsp),%r8
 1512a6f:	45 31 c9             	xor    %r9d,%r9d
 1512a72:	c5 e9 ef d2          	vpxor  %xmm2,%xmm2,%xmm2
 1512a76:	31 c9                	xor    %ecx,%ecx
 1512a78:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
 1512a7d:	41 bd ff ff 00 00    	mov    $0xffff,%r13d
 1512a83:	48 89 f8             	mov    %rdi,%rax
 1512a86:	48 29 c8             	sub    %rcx,%rax
 1512a89:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
 1512a8e:	c5 d1 ef ed          	vpxor  %xmm5,%xmm5,%xmm5
 1512a92:	48 83 f8 10          	cmp    $0x10,%rax
 1512a96:	c4 e2 79 f7 c3       	shlx   %eax,%ebx,%eax
 1512a9b:	f7 d0                	not    %eax
 1512a9d:	41 0f 43 c5          	cmovae %r13d,%eax
 1512aa1:	c5 fb 92 c8          	kmovd  %eax,%k1
 1512aa5:	48 8b 84 24 a8 00 00 00 	mov    0xa8(%rsp),%rax
 1512aad:	62 f1 7e c9 6f 1c 8a 	vmovdqu32 (%rdx,%rcx,4),%zmm3{%k1}{z}
 1512ab4:	c4 e1 f8 90 d1       	kmovq  %k1,%k2
 1512ab9:	c4 e1 f8 90 d9       	kmovq  %k1,%k3
 1512abe:	62 71 7e c9 6f 24 88 	vmovdqu32 (%rax,%rcx,4),%zmm12{%k1}{z}
 1512ac5:	62 f1 65 48 fe e3    	vpaddd %zmm3,%zmm3,%zmm4
 1512acb:	62 d2 7d 4a 90 2c e6 	vpgatherdd (%r14,%zmm4,8),%zmm5{%k2}
 1512ad2:	62 f3 1d 49 1e d1 01 	vpcmpltud %zmm1,%zmm12,%k2{%k1}
 1512ad9:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
 1512add:	62 d2 7d 4b 90 0c 9b 	vpgatherdd (%r11,%zmm3,4),%zmm1{%k3}
 1512ae4:	62 f1 55 58 db 1d 32 da 06 ff 	vpandd -0xf925ce(%rip){1to16},%zmm5,%zmm3        # 580520 <tier0_emit_x87.operations+0xd8>
 1512aee:	62 92 7d 4a 90 04 a3 	vpgatherdd (%r11,%zmm12,4),%zmm0{%k2}
 1512af5:	62 f1 65 58 76 15 25 da 06 ff 	vpcmpeqd -0xf925db(%rip){1to16},%zmm3,%k2        # 580524 <tier0_emit_x87.operations+0xdc>
 1512aff:	62 f1 7d 48 fa c1    	vpsubd %zmm1,%zmm0,%zmm0
 1512b05:	62 f2 7d 52 64 0d 19 da 06 ff 	vpblendmd -0xf925e7(%rip){1to16},%zmm16,%zmm1{%k2}        # 580528 <tier0_emit_x87.operations+0xe0>
 1512b0f:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
 1512b14:	48 8b b4 24 e8 00 00 00 	mov    0xe8(%rsp),%rsi
 1512b1c:	48 8b 94 24 e0 00 00 00 	mov    0xe0(%rsp),%rdx
 1512b24:	62 f1 7d d9 fe 05 fe d9 06 ff 	vpaddd -0xf92602(%rip){1to16},%zmm0,%zmm0{%k1}{z}        # 58052c <tier0_emit_x87.operations+0xe4>
 1512b2e:	62 f1 7d c9 6f c9    	vmovdqa32 %zmm1,%zmm1{%k1}{z}
 1512b34:	62 f1 fd 48 7f 0c 88 	vmovdqa64 %zmm1,(%rax,%rcx,4)
 1512b3b:	48 8b 84 24 c0 00 00 00 	mov    0xc0(%rsp),%rax
 1512b43:	62 f1 fd 48 7f 04 8e 	vmovdqa64 %zmm0,(%rsi,%rcx,4)
 1512b4a:	62 f1 fd 48 7f 04 8a 	vmovdqa64 %zmm0,(%rdx,%rcx,4)
 1512b51:	62 d1 7d 48 fe c2    	vpaddd %zmm10,%zmm0,%zmm0
 1512b57:	62 d3 7d 48 1e d3 01 	vpcmpltud %zmm11,%zmm0,%k2
 1512b5e:	62 f1 7d ca 6f c1    	vmovdqa32 %zmm1,%zmm0{%k2}{z}
 1512b64:	62 d3 7d 48 03 c8 0f 	valignd $0xf,%zmm8,%zmm0,%zmm1
 1512b6b:	c5 ec 41 c1          	kandw  %k1,%k2,%k0
 1512b6f:	62 d1 fd 48 7f 04 8c 	vmovdqa64 %zmm0,(%r12,%rcx,4)
 1512b76:	62 f1 75 48 fe c8    	vpaddd %zmm0,%zmm1,%zmm1
 1512b7c:	62 d3 f5 48 03 d8 07 	valignq $0x7,%zmm8,%zmm1,%zmm3
 1512b83:	62 f1 65 48 fe c9    	vpaddd %zmm1,%zmm3,%zmm1
 1512b89:	62 d3 f5 48 03 d8 06 	valignq $0x6,%zmm8,%zmm1,%zmm3
 1512b90:	62 f1 65 48 fe c9    	vpaddd %zmm1,%zmm3,%zmm1
 1512b96:	62 d3 f5 48 03 d8 04 	valignq $0x4,%zmm8,%zmm1,%zmm3
 1512b9d:	62 f1 75 48 fe ca    	vpaddd %zmm2,%zmm1,%zmm1
 1512ba3:	62 f1 75 48 fe cb    	vpaddd %zmm3,%zmm1,%zmm1
 1512ba9:	62 d1 fe 48 7f 8c 88 04 00 00 00 	vmovdqu64 %zmm1,0x4(%r8,%rcx,4)
 1512bb4:	62 71 fe 48 7f 84 88 04 00 00 00 	vmovdqu64 %zmm8,0x4(%rax,%rcx,4)
 1512bbf:	44 89 c9             	mov    %r9d,%ecx
 1512bc2:	c5 78 93 c8          	kmovw  %k0,%r9d
 1512bc6:	41 09 c9             	or     %ecx,%r9d
 1512bc9:	4c 8b 74 24 78       	mov    0x78(%rsp),%r14
 1512bce:	45 85 c9             	test   %r9d,%r9d
 1512bd1:	0f 84 08 07 00 00    	je     15132df <tier0_benchmark_run+0x19df>
 1512bd7:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
 1512bdc:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
 1512be1:	81 e2 c0 ff ff 1f    	and    $0x1fffffc0,%edx
 1512be7:	31 f6                	xor    %esi,%esi
 1512be9:	48 83 c2 40          	add    $0x40,%rdx
 1512bed:	c5 f8 77             	vzeroupper
 1512bf0:	e8 3b 17 25 ff       	call   764330 <memset@plt>
 1512bf5:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
 1512bfa:	89 d0                	mov    %edx,%eax
 1512bfc:	83 e0 07             	and    $0x7,%eax
 1512bff:	83 fa 08             	cmp    $0x8,%edx
 1512c02:	73 61                	jae    1512c65 <tier0_benchmark_run+0x1365>
 1512c04:	62 f2 7d 48 58 05 c6 d8 06 ff 	vpbroadcastd -0xf9273a(%rip),%zmm0        # 5804d4 <tier0_emit_x87.operations+0x8c>
 1512c0e:	62 f1 fd 48 6f 0d e8 db 00 ff 	vmovdqa64 -0xff2418(%rip),%zmm1        # 520800 <branch_sizing_patterns+0xa70>
 1512c18:	62 e2 7d 48 5a 0d de 30 06 ff 	vbroadcasti32x4 -0xf9cf22(%rip),%zmm17        # 575d00 <x86_effects_unknown+0x2a0>
 1512c22:	62 f2 7d 48 5a 15 f4 30 06 ff 	vbroadcasti32x4 -0xf9cf0c(%rip),%zmm2        # 575d20 <x86_effects_unknown+0x2c0>
 1512c2c:	62 72 7d 48 5a 3d da 30 06 ff 	vbroadcasti32x4 -0xf9cf26(%rip),%zmm15        # 575d10 <x86_effects_unknown+0x2b0>
 1512c36:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
 1512c3b:	4c 8b 44 24 10       	mov    0x10(%rsp),%r8
 1512c40:	4c 8b 4c 24 18       	mov    0x18(%rsp),%r9
 1512c45:	4c 8b 5c 24 60       	mov    0x60(%rsp),%r11
 1512c4a:	4c 8b bc 24 c8 00 00 00 	mov    0xc8(%rsp),%r15
 1512c52:	31 c9                	xor    %ecx,%ecx
 1512c54:	c4 41 39 ef c0       	vpxor  %xmm8,%xmm8,%xmm8
 1512c59:	62 f3 45 48 25 ff ff 	vpternlogd $0xff,%zmm7,%zmm7,%zmm7
 1512c60:	e9 c3 00 00 00       	jmp    1512d28 <tier0_benchmark_run+0x1428>
 1512c65:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
 1512c6a:	4c 8b 44 24 10       	mov    0x10(%rsp),%r8
 1512c6f:	4c 8b 5c 24 60       	mov    0x60(%rsp),%r11
 1512c74:	4c 8b bc 24 c8 00 00 00 	mov    0xc8(%rsp),%r15
 1512c7c:	83 e2 f8             	and    $0xfffffff8,%edx
 1512c7f:	31 c9                	xor    %ecx,%ecx
 1512c81:	66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1512c90:	8b 34 8f             	mov    (%rdi,%rcx,4),%esi
 1512c93:	41 c6 04 30 01       	movb   $0x1,(%r8,%rsi,1)
 1512c98:	8b 74 8f 04          	mov    0x4(%rdi,%rcx,4),%esi
 1512c9c:	41 c6 04 30 01       	movb   $0x1,(%r8,%rsi,1)
 1512ca1:	8b 74 8f 08          	mov    0x8(%rdi,%rcx,4),%esi
 1512ca5:	41 c6 04 30 01       	movb   $0x1,(%r8,%rsi,1)
 1512caa:	8b 74 8f 0c          	mov    0xc(%rdi,%rcx,4),%esi
 1512cae:	41 c6 04 30 01       	movb   $0x1,(%r8,%rsi,1)
 1512cb3:	8b 74 8f 10          	mov    0x10(%rdi,%rcx,4),%esi
 1512cb7:	41 c6 04 30 01       	movb   $0x1,(%r8,%rsi,1)
 1512cbc:	8b 74 8f 14          	mov    0x14(%rdi,%rcx,4),%esi
 1512cc0:	41 c6 04 30 01       	movb   $0x1,(%r8,%rsi,1)
 1512cc5:	8b 74 8f 18          	mov    0x18(%rdi,%rcx,4),%esi
 1512cc9:	41 c6 04 30 01       	movb   $0x1,(%r8,%rsi,1)
 1512cce:	8b 74 8f 1c          	mov    0x1c(%rdi,%rcx,4),%esi
 1512cd2:	48 83 c1 08          	add    $0x8,%rcx
 1512cd6:	41 c6 04 30 01       	movb   $0x1,(%r8,%rsi,1)
 1512cdb:	48 39 ca             	cmp    %rcx,%rdx
 1512cde:	75 b0                	jne    1512c90 <tier0_benchmark_run+0x1390>
 1512ce0:	62 f2 7d 48 58 05 ea d7 06 ff 	vpbroadcastd -0xf92816(%rip),%zmm0        # 5804d4 <tier0_emit_x87.operations+0x8c>
 1512cea:	62 f1 fd 48 6f 0d 0c db 00 ff 	vmovdqa64 -0xff24f4(%rip),%zmm1        # 520800 <branch_sizing_patterns+0xa70>
 1512cf4:	62 e2 7d 48 5a 0d 02 30 06 ff 	vbroadcasti32x4 -0xf9cffe(%rip),%zmm17        # 575d00 <x86_effects_unknown+0x2a0>
 1512cfe:	62 f2 7d 48 5a 15 18 30 06 ff 	vbroadcasti32x4 -0xf9cfe8(%rip),%zmm2        # 575d20 <x86_effects_unknown+0x2c0>
 1512d08:	62 72 7d 48 5a 3d fe 2f 06 ff 	vbroadcasti32x4 -0xf9d002(%rip),%zmm15        # 575d10 <x86_effects_unknown+0x2b0>
 1512d12:	4c 8b 4c 24 18       	mov    0x18(%rsp),%r9
 1512d17:	62 f3 45 48 25 ff ff 	vpternlogd $0xff,%zmm7,%zmm7,%zmm7
 1512d1e:	c4 41 39 ef c0       	vpxor  %xmm8,%xmm8,%xmm8
 1512d23:	48 85 c0             	test   %rax,%rax
 1512d26:	74 18                	je     1512d40 <tier0_benchmark_run+0x1440>
 1512d28:	48 8d 0c 8f          	lea    (%rdi,%rcx,4),%rcx
 1512d2c:	31 d2                	xor    %edx,%edx
 1512d2e:	66 90                	xchg   %ax,%ax
 1512d30:	8b 34 91             	mov    (%rcx,%rdx,4),%esi
 1512d33:	48 ff c2             	inc    %rdx
 1512d36:	41 c6 04 30 01       	movb   $0x1,(%r8,%rsi,1)
 1512d3b:	48 39 d0             	cmp    %rdx,%rax
 1512d3e:	75 f0                	jne    1512d30 <tier0_benchmark_run+0x1430>
 1512d40:	62 72 7d 48 58 15 e6 d7 06 ff 	vpbroadcastd -0xf9281a(%rip),%zmm10        # 580530 <tier0_emit_x87.operations+0xe8>
 1512d4a:	62 72 7d 48 58 1d e0 d7 06 ff 	vpbroadcastd -0xf92820(%rip),%zmm11        # 580534 <tier0_emit_x87.operations+0xec>
 1512d54:	62 f1 fd 48 6f 25 22 dc 00 ff 	vmovdqa64 -0xff23de(%rip),%zmm4        # 520980 <branch_sizing_patterns+0xbf0>
 1512d5e:	62 f1 fd 48 6f 2d 58 dc 00 ff 	vmovdqa64 -0xff23a8(%rip),%zmm5        # 5209c0 <branch_sizing_patterns+0xc30>
 1512d68:	62 f2 7d 48 58 35 c6 d7 06 ff 	vpbroadcastd -0xf9283a(%rip),%zmm6        # 580538 <tier0_emit_x87.operations+0xf0>
 1512d72:	44 89 f8             	mov    %r15d,%eax
 1512d75:	83 e0 03             	and    $0x3,%eax
 1512d78:	62 71 fd 48 6f c8    	vmovdqa64 %zmm0,%zmm9
 1512d7e:	62 71 fd 48 6f e9    	vmovdqa64 %zmm1,%zmm13
 1512d84:	41 81 f9 c0 00 00 00 	cmp    $0xc0,%r9d
 1512d8b:	73 0f                	jae    1512d9c <tier0_benchmark_run+0x149c>
 1512d8d:	31 ff                	xor    %edi,%edi
 1512d8f:	31 c9                	xor    %ecx,%ecx
 1512d91:	62 71 fd 48 6f e2    	vmovdqa64 %zmm2,%zmm12
 1512d97:	e9 54 01 00 00       	jmp    1512ef0 <tier0_benchmark_run+0x15f0>
 1512d9c:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
 1512da1:	c1 e1 06             	shl    $0x6,%ecx
 1512da4:	41 81 e7 fc ff ff 00 	and    $0xfffffc,%r15d
 1512dab:	49 8d 90 c0 00 00 00 	lea    0xc0(%r8),%rdx
 1512db2:	31 ff                	xor    %edi,%edi
 1512db4:	62 71 fd 48 6f e2    	vmovdqa64 %zmm2,%zmm12
 1512dba:	49 8d 74 08 78       	lea    0x78(%r8,%rcx,1),%rsi
 1512dbf:	31 c9                	xor    %ecx,%ecx
 1512dc1:	66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1512dd0:	62 f1 fd 48 6f 42 fd 	vmovdqa64 -0xc0(%rdx),%zmm0
 1512dd7:	48 83 c1 04          	add    $0x4,%rcx
 1512ddb:	62 f2 7d 48 26 c0    	vptestmb %zmm0,%zmm0,%k0
 1512de1:	c4 61 fb 93 c0       	kmovq  %k0,%r8
 1512de6:	f3 45 0f b8 d0       	popcnt %r8d,%r10d
 1512deb:	45 89 c1             	mov    %r8d,%r9d
 1512dee:	49 01 fa             	add    %rdi,%r10
 1512df1:	48 c1 e7 20          	shl    $0x20,%rdi
 1512df5:	4d 89 d3             	mov    %r10,%r11
 1512df8:	4d 0f a4 c3 20       	shld   $0x20,%r8,%r11
 1512dfd:	4c 09 cf             	or     %r9,%rdi
 1512e00:	49 c1 e8 20          	shr    $0x20,%r8
 1512e04:	48 89 7e c8          	mov    %rdi,-0x38(%rsi)
 1512e08:	f3 41 0f b8 f8       	popcnt %r8d,%edi
 1512e0d:	4c 89 5e d0          	mov    %r11,-0x30(%rsi)
 1512e11:	4c 01 d7             	add    %r10,%rdi
 1512e14:	62 f1 fd 48 6f 42 fe 	vmovdqa64 -0x80(%rdx),%zmm0
 1512e1b:	62 f2 7d 48 26 c0    	vptestmb %zmm0,%zmm0,%k0
 1512e21:	c4 61 fb 93 c0       	kmovq  %k0,%r8
 1512e26:	f3 45 0f b8 d0       	popcnt %r8d,%r10d
 1512e2b:	45 89 c1             	mov    %r8d,%r9d
 1512e2e:	49 01 fa             	add    %rdi,%r10
 1512e31:	48 c1 e7 20          	shl    $0x20,%rdi
 1512e35:	4d 89 d3             	mov    %r10,%r11
 1512e38:	4d 0f a4 c3 20       	shld   $0x20,%r8,%r11
 1512e3d:	4c 09 cf             	or     %r9,%rdi
 1512e40:	49 c1 e8 20          	shr    $0x20,%r8
 1512e44:	48 89 7e d8          	mov    %rdi,-0x28(%rsi)
 1512e48:	f3 41 0f b8 f8       	popcnt %r8d,%edi
 1512e4d:	4c 89 5e e0          	mov    %r11,-0x20(%rsi)
 1512e51:	4c 01 d7             	add    %r10,%rdi
 1512e54:	62 f1 fd 48 6f 42 ff 	vmovdqa64 -0x40(%rdx),%zmm0
 1512e5b:	62 f2 7d 48 26 c0    	vptestmb %zmm0,%zmm0,%k0
 1512e61:	c4 61 fb 93 c0       	kmovq  %k0,%r8
 1512e66:	f3 45 0f b8 d0       	popcnt %r8d,%r10d
 1512e6b:	45 89 c1             	mov    %r8d,%r9d
 1512e6e:	49 01 fa             	add    %rdi,%r10
 1512e71:	48 c1 e7 20          	shl    $0x20,%rdi
 1512e75:	4d 89 d3             	mov    %r10,%r11
 1512e78:	4d 0f a4 c3 20       	shld   $0x20,%r8,%r11
 1512e7d:	4c 09 cf             	or     %r9,%rdi
 1512e80:	49 c1 e8 20          	shr    $0x20,%r8
 1512e84:	48 89 7e e8          	mov    %rdi,-0x18(%rsi)
 1512e88:	f3 41 0f b8 f8       	popcnt %r8d,%edi
 1512e8d:	4c 89 5e f0          	mov    %r11,-0x10(%rsi)
 1512e91:	4c 01 d7             	add    %r10,%rdi
 1512e94:	62 f1 fd 48 6f 02    	vmovdqa64 (%rdx),%zmm0
 1512e9a:	48 81 c2 00 01 00 00 	add    $0x100,%rdx
 1512ea1:	62 f2 7d 48 26 c0    	vptestmb %zmm0,%zmm0,%k0
 1512ea7:	c4 61 fb 93 c0       	kmovq  %k0,%r8
 1512eac:	f3 45 0f b8 d0       	popcnt %r8d,%r10d
 1512eb1:	45 89 c1             	mov    %r8d,%r9d
 1512eb4:	49 01 fa             	add    %rdi,%r10
 1512eb7:	48 c1 e7 20          	shl    $0x20,%rdi
 1512ebb:	4c 09 cf             	or     %r9,%rdi
 1512ebe:	48 89 7e f8          	mov    %rdi,-0x8(%rsi)
 1512ec2:	4c 89 d7             	mov    %r10,%rdi
 1512ec5:	4c 0f a4 c7 20       	shld   $0x20,%r8,%rdi
 1512eca:	49 c1 e8 20          	shr    $0x20,%r8
 1512ece:	48 89 3e             	mov    %rdi,(%rsi)
 1512ed1:	f3 41 0f b8 f8       	popcnt %r8d,%edi
 1512ed6:	48 83 c6 40          	add    $0x40,%rsi
 1512eda:	4c 01 d7             	add    %r10,%rdi
 1512edd:	49 39 cf             	cmp    %rcx,%r15
 1512ee0:	0f 85 ea fe ff ff    	jne    1512dd0 <tier0_benchmark_run+0x14d0>
 1512ee6:	4c 8b 5c 24 60       	mov    0x60(%rsp),%r11
 1512eeb:	48 85 c0             	test   %rax,%rax
 1512eee:	74 7a                	je     1512f6a <tier0_benchmark_run+0x166a>
 1512ef0:	4c 8b 44 24 10       	mov    0x10(%rsp),%r8
 1512ef5:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
 1512efa:	48 89 ce             	mov    %rcx,%rsi
 1512efd:	c1 e2 06             	shl    $0x6,%edx
 1512f00:	48 c1 e6 04          	shl    $0x4,%rsi
 1512f04:	48 c1 e1 06          	shl    $0x6,%rcx
 1512f08:	c1 e0 04             	shl    $0x4,%eax
 1512f0b:	48 01 d6             	add    %rdx,%rsi
 1512f0e:	49 8d 54 30 48       	lea    0x48(%r8,%rsi,1),%rdx
 1512f13:	4c 01 c1             	add    %r8,%rcx
 1512f16:	31 f6                	xor    %esi,%esi
 1512f18:	0f 1f 84 00 00 00 00 00 	nopl   0x0(%rax,%rax,1)
 1512f20:	62 f1 fd 48 6f 04 b1 	vmovdqa64 (%rcx,%rsi,4),%zmm0
 1512f27:	62 f2 7d 48 26 c0    	vptestmb %zmm0,%zmm0,%k0
 1512f2d:	c4 61 fb 93 c0       	kmovq  %k0,%r8
 1512f32:	f3 45 0f b8 d0       	popcnt %r8d,%r10d
 1512f37:	45 89 c1             	mov    %r8d,%r9d
 1512f3a:	49 01 fa             	add    %rdi,%r10
 1512f3d:	48 c1 e7 20          	shl    $0x20,%rdi
 1512f41:	4c 09 cf             	or     %r9,%rdi
 1512f44:	48 89 7c 32 f8       	mov    %rdi,-0x8(%rdx,%rsi,1)
 1512f49:	4c 89 d7             	mov    %r10,%rdi
 1512f4c:	4c 0f a4 c7 20       	shld   $0x20,%r8,%rdi
 1512f51:	49 c1 e8 20          	shr    $0x20,%r8
 1512f55:	48 89 3c 32          	mov    %rdi,(%rdx,%rsi,1)
 1512f59:	f3 41 0f b8 f8       	popcnt %r8d,%edi
 1512f5e:	48 83 c6 10          	add    $0x10,%rsi
 1512f62:	4c 01 d7             	add    %r10,%rdi
 1512f65:	48 39 f0             	cmp    %rsi,%rax
 1512f68:	75 b6                	jne    1512f20 <tier0_benchmark_run+0x1620>
 1512f6a:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
 1512f6f:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
 1512f74:	c1 e1 06             	shl    $0x6,%ecx
 1512f77:	4c 8b 4c 24 10       	mov    0x10(%rsp),%r9
 1512f7c:	48 8b 7c 24 30       	mov    0x30(%rsp),%rdi
 1512f81:	4c 8b 94 24 a8 00 00 00 	mov    0xa8(%rsp),%r10
 1512f89:	31 f6                	xor    %esi,%esi
 1512f8b:	48 01 c0             	add    %rax,%rax
 1512f8e:	48 89 fa             	mov    %rdi,%rdx
 1512f91:	48 01 c1             	add    %rax,%rcx
 1512f94:	48 03 4c 24 40       	add    0x40(%rsp),%rcx
 1512f99:	49 8d 4c 09 40       	lea    0x40(%r9,%rcx,1),%rcx
 1512f9e:	66 90                	xchg   %ax,%ax
 1512fa0:	41 89 d0             	mov    %edx,%r8d
 1512fa3:	48 83 ea 10          	sub    $0x10,%rdx
 1512fa7:	c5 e9 ef d2          	vpxor  %xmm2,%xmm2,%xmm2
 1512fab:	c5 e1 ef db          	vpxor  %xmm3,%xmm3,%xmm3
 1512faf:	c4 62 39 f7 c3       	shlx   %r8d,%ebx,%r8d
 1512fb4:	41 f7 d0             	not    %r8d
 1512fb7:	45 0f 43 c5          	cmovae %r13d,%r8d
 1512fbb:	c4 c1 7b 92 c8       	kmovd  %r8d,%k1
 1512fc0:	41 c1 e8 08          	shr    $0x8,%r8d
 1512fc4:	62 d1 7e c9 6f 04 b2 	vmovdqu32 (%r10,%rsi,4),%zmm0{%k1}{z}
 1512fcb:	62 f1 75 48 72 d0 05 	vpsrld $0x5,%zmm0,%zmm1
 1512fd2:	62 f1 7d 48 db c6    	vpandd %zmm6,%zmm0,%zmm0
 1512fd8:	62 d2 fd 49 90 14 ce 	vpgatherdq (%r14,%ymm1,8),%zmm2{%k1}
 1512fdf:	62 f3 fd 48 3b c9 01 	vextracti64x4 $0x1,%zmm1,%ymm1
 1512fe6:	c4 c1 7b 92 c8       	kmovd  %r8d,%k1
 1512feb:	62 f2 45 48 47 c0    	vpsllvd %zmm0,%zmm7,%zmm0
 1512ff1:	62 d2 fd 49 90 1c ce 	vpgatherdq (%r14,%ymm1,8),%zmm3{%k1}
 1512ff8:	62 f1 fd 48 6f ca    	vmovdqa64 %zmm2,%zmm1
 1512ffe:	62 f2 5d 48 7e cb    	vpermt2d %zmm3,%zmm4,%zmm1
 1513004:	62 f2 55 48 7e d3    	vpermt2d %zmm3,%zmm5,%zmm2
 151300a:	62 f1 7d 48 df c1    	vpandnd %zmm1,%zmm0,%zmm0
 1513010:	62 f2 7d 48 55 c0    	vpopcntd %zmm0,%zmm0
 1513016:	62 f1 7d 48 fe c2    	vpaddd %zmm2,%zmm0,%zmm0
 151301c:	62 f1 fd 48 7f 04 b1 	vmovdqa64 %zmm0,(%rcx,%rsi,4)
 1513023:	48 83 c6 10          	add    $0x10,%rsi
 1513027:	48 39 fe             	cmp    %rdi,%rsi
 151302a:	0f 82 70 ff ff ff    	jb     1512fa0 <tier0_benchmark_run+0x16a0>
 1513030:	4c 8b 44 24 70       	mov    0x70(%rsp),%r8
 1513035:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
 151303a:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
 151303f:	c1 e1 06             	shl    $0x6,%ecx
 1513042:	62 d1 fd 48 6f f1    	vmovdqa64 %zmm9,%zmm6
 1513048:	45 31 f6             	xor    %r14d,%r14d
 151304b:	62 d1 fd 48 6f fd    	vmovdqa64 %zmm13,%zmm7
 1513051:	62 51 fd 48 6f cf    	vmovdqa64 %zmm15,%zmm9
 1513057:	48 01 c8             	add    %rcx,%rax
 151305a:	4b 8d 14 40          	lea    (%r8,%r8,2),%rdx
 151305e:	49 01 c8             	add    %rcx,%r8
 1513061:	48 01 f0             	add    %rsi,%rax
 1513064:	49 01 f0             	add    %rsi,%r8
 1513067:	49 8d 5c 01 40       	lea    0x40(%r9,%rax,1),%rbx
 151306c:	b8 01 00 00 00       	mov    $0x1,%eax
 1513071:	48 01 ca             	add    %rcx,%rdx
 1513074:	4f 8d 6c 01 40       	lea    0x40(%r9,%r8,1),%r13
 1513079:	48 01 f2             	add    %rsi,%rdx
 151307c:	4d 8d 7c 11 40       	lea    0x40(%r9,%rdx,1),%r15
 1513081:	48 8b 94 24 98 00 00 00 	mov    0x98(%rsp),%rdx
 1513089:	48 01 ca             	add    %rcx,%rdx
 151308c:	31 c9                	xor    %ecx,%ecx
 151308e:	48 01 f2             	add    %rsi,%rdx
 1513091:	4d 8d 64 11 40       	lea    0x40(%r9,%rdx,1),%r12
 1513096:	66 2e 0f 1f 84 00 00 00 00 00 	cs nopw 0x0(%rax,%rax,1)
 15130a0:	83 f8 04             	cmp    $0x4,%eax
 15130a3:	89 84 24 90 00 00 00 	mov    %eax,0x90(%rsp)
 15130aa:	0f 92 c0             	setb   %al
 15130ad:	08 c8                	or     %cl,%al
 15130af:	a8 01                	test   $0x1,%al
 15130b1:	74 1d                	je     15130d0 <tier0_benchmark_run+0x17d0>
 15130b3:	44 89 f0             	mov    %r14d,%eax
 15130b6:	48 8b 84 c4 a0 01 00 00 	mov    0x1a0(%rsp,%rax,8),%rax
 15130be:	41 83 f6 01          	xor    $0x1,%r14d
 15130c2:	e9 f9 00 00 00       	jmp    15131c0 <tier0_benchmark_run+0x18c0>
 15130c7:	66 0f 1f 84 00 00 00 00 00 	nopw   0x0(%rax,%rax,1)
 15130d0:	48 8d b4 24 68 01 00 00 	lea    0x168(%rsp),%rsi
 15130d8:	44 89 f2             	mov    %r14d,%edx
 15130db:	c5 f8 77             	vzeroupper
 15130de:	e8 5d d0 04 00       	call   1560140 <branch_sizing_worklist>
 15130e3:	44 89 f0             	mov    %r14d,%eax
 15130e6:	83 f0 01             	xor    $0x1,%eax
 15130e9:	48 8b 7c 24 30       	mov    0x30(%rsp),%rdi
 15130ee:	c4 41 39 ef c0       	vpxor  %xmm8,%xmm8,%xmm8
 15130f3:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 15130f7:	31 c9                	xor    %ecx,%ecx
 15130f9:	48 8b 84 c4 a0 01 00 00 	mov    0x1a0(%rsp,%rax,8),%rax
 1513101:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
 1513107:	66 0f 1f 84 00 00 00 00 00 	nopw   0x0(%rax,%rax,1)
 1513110:	62 d1 fd 48 6f 0c 8f 	vmovdqa64 (%r15,%rcx,4),%zmm1
 1513117:	62 d3 75 48 03 d0 0f 	valignd $0xf,%zmm8,%zmm1,%zmm2
 151311e:	62 f1 6d 48 fe c9    	vpaddd %zmm1,%zmm2,%zmm1
 1513124:	62 d3 f5 48 03 d0 07 	valignq $0x7,%zmm8,%zmm1,%zmm2
 151312b:	62 f1 6d 48 fe c9    	vpaddd %zmm1,%zmm2,%zmm1
 1513131:	62 d3 f5 48 03 d0 06 	valignq $0x6,%zmm8,%zmm1,%zmm2
 1513138:	62 f1 6d 48 fe c9    	vpaddd %zmm1,%zmm2,%zmm1
 151313e:	62 d3 f5 48 03 d0 04 	valignq $0x4,%zmm8,%zmm1,%zmm2
 1513145:	62 f1 75 48 fe c0    	vpaddd %zmm0,%zmm1,%zmm0
 151314b:	62 f1 7d 48 fe c2    	vpaddd %zmm2,%zmm0,%zmm0
 1513151:	62 f1 fe 48 7f 84 88 04 00 00 00 	vmovdqu64 %zmm0,0x4(%rax,%rcx,4)
 151315c:	62 f1 7d 48 70 c0 ff 	vpshufd $0xff,%zmm0,%zmm0
 1513163:	48 83 c1 10          	add    $0x10,%rcx
 1513167:	62 f3 fd 48 43 c0 ff 	vshufi64x2 $0xff,%zmm0,%zmm0,%zmm0
 151316e:	48 39 f9             	cmp    %rdi,%rcx
 1513171:	72 9d                	jb     1513110 <tier0_benchmark_run+0x1810>
 1513173:	62 f2 7d 48 58 35 57 d3 06 ff 	vpbroadcastd -0xf92ca9(%rip),%zmm6        # 5804d4 <tier0_emit_x87.operations+0x8c>
 151317d:	62 f1 fd 48 6f 3d 79 d6 00 ff 	vmovdqa64 -0xff2987(%rip),%zmm7        # 520800 <branch_sizing_patterns+0xa70>
 1513187:	62 e2 7d 48 5a 0d 6f 2b 06 ff 	vbroadcasti32x4 -0xf9d491(%rip),%zmm17        # 575d00 <x86_effects_unknown+0x2a0>
 1513191:	62 72 7d 48 5a 25 85 2b 06 ff 	vbroadcasti32x4 -0xf9d47b(%rip),%zmm12        # 575d20 <x86_effects_unknown+0x2c0>
 151319b:	62 72 7d 48 5a 0d 6b 2b 06 ff 	vbroadcasti32x4 -0xf9d495(%rip),%zmm9        # 575d10 <x86_effects_unknown+0x2b0>
 15131a5:	62 72 7d 48 58 15 81 d3 06 ff 	vpbroadcastd -0xf92c7f(%rip),%zmm10        # 580530 <tier0_emit_x87.operations+0xe8>
 15131af:	62 72 7d 48 58 1d 7b d3 06 ff 	vpbroadcastd -0xf92c85(%rip),%zmm11        # 580534 <tier0_emit_x87.operations+0xec>
 15131b9:	4c 8b 5c 24 60       	mov    0x60(%rsp),%r11
 15131be:	b1 01                	mov    $0x1,%cl
 15131c0:	44 89 f2             	mov    %r14d,%edx
 15131c3:	4c 8b 84 d4 a0 01 00 00 	mov    0x1a0(%rsp,%rdx,8),%r8
 15131cb:	45 89 f2             	mov    %r14d,%r10d
 15131ce:	31 d2                	xor    %edx,%edx
 15131d0:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 15131d4:	31 f6                	xor    %esi,%esi
 15131d6:	41 c7 00 00 00 00 00 	movl   $0x0,(%r8)
 15131dd:	0f 1f 00             	nopl   (%rax)
 15131e0:	62 f1 fd 48 6f 0c 93 	vmovdqa64 (%rbx,%rdx,4),%zmm1
 15131e7:	c5 fc 46 c8          	kxnorw %k0,%k0,%k1
 15131eb:	c5 e1 ef db          	vpxor  %xmm3,%xmm3,%xmm3
 15131ef:	62 d1 fd 48 6f 14 97 	vmovdqa64 (%r15,%rdx,4),%zmm2
 15131f6:	4d 89 c1             	mov    %r8,%r9
 15131f9:	62 f2 7d 49 90 1c 88 	vpgatherdd (%rax,%zmm1,4),%zmm3{%k1}
 1513200:	62 f1 65 48 fa 8c 90 04 00 00 00 	vpsubd 0x4(%rax,%rdx,4),%zmm3,%zmm1
 151320b:	62 f2 6d 48 27 c2    	vptestmd %zmm2,%zmm2,%k0
 1513211:	62 d1 75 48 fe 4c 95 00 	vpaddd 0x0(%r13,%rdx,4),%zmm1,%zmm1
 1513219:	62 d1 75 48 fe da    	vpaddd %zmm10,%zmm1,%zmm3
 151321f:	62 d3 65 48 1e cb 01 	vpcmpltud %zmm11,%zmm3,%k1
 1513226:	c5 fc 45 c9          	korw   %k1,%k0,%k1
 151322a:	62 d1 7d c9 6f 1c 93 	vmovdqa32 (%r11,%rdx,4),%zmm3{%k1}{z}
 1513231:	62 d3 65 48 03 e0 0f 	valignd $0xf,%zmm8,%zmm3,%zmm4
 1513238:	62 f3 65 48 1f c2 04 	vpcmpneqd %zmm2,%zmm3,%k0
 151323f:	62 d1 fd 48 7f 1c 97 	vmovdqa64 %zmm3,(%r15,%rdx,4)
 1513246:	62 d1 fd 48 7f 0c 94 	vmovdqa64 %zmm1,(%r12,%rdx,4)
 151324d:	c5 78 93 c0          	kmovw  %k0,%r8d
 1513251:	62 f1 5d 48 fe e3    	vpaddd %zmm3,%zmm4,%zmm4
 1513257:	44 09 c6             	or     %r8d,%esi
 151325a:	4d 89 c8             	mov    %r9,%r8
 151325d:	62 d3 dd 48 03 e8 07 	valignq $0x7,%zmm8,%zmm4,%zmm5
 1513264:	62 f1 55 48 fe e4    	vpaddd %zmm4,%zmm5,%zmm4
 151326a:	62 d3 dd 48 03 e8 06 	valignq $0x6,%zmm8,%zmm4,%zmm5
 1513271:	62 f1 55 48 fe e4    	vpaddd %zmm4,%zmm5,%zmm4
 1513277:	62 d3 dd 48 03 e8 04 	valignq $0x4,%zmm8,%zmm4,%zmm5
 151327e:	62 f1 5d 48 fe c0    	vpaddd %zmm0,%zmm4,%zmm0
 1513284:	62 f1 7d 48 fe c5    	vpaddd %zmm5,%zmm0,%zmm0
 151328a:	62 d1 fe 48 7f 84 91 04 00 00 00 	vmovdqu64 %zmm0,0x4(%r9,%rdx,4)
 1513295:	62 f1 7d 48 70 c0 ff 	vpshufd $0xff,%zmm0,%zmm0
 151329c:	48 83 c2 10          	add    $0x10,%rdx
 15132a0:	62 f3 fd 48 43 c0 ff 	vshufi64x2 $0xff,%zmm0,%zmm0,%zmm0
 15132a7:	48 39 fa             	cmp    %rdi,%rdx
 15132aa:	0f 82 30 ff ff ff    	jb     15131e0 <tier0_benchmark_run+0x18e0>
 15132b0:	8b 84 24 90 00 00 00 	mov    0x90(%rsp),%eax
 15132b7:	45 89 d6             	mov    %r10d,%r14d
 15132ba:	ff c0                	inc    %eax
 15132bc:	85 f6                	test   %esi,%esi
 15132be:	0f 85 dc fd ff ff    	jne    15130a0 <tier0_benchmark_run+0x17a0>
 15132c4:	4c 8b 74 24 78       	mov    0x78(%rsp),%r14
 15132c9:	4c 8b a4 24 b0 00 00 00 	mov    0xb0(%rsp),%r12
 15132d1:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
 15132d6:	41 bd ff ff 00 00    	mov    $0xffff,%r13d
 15132dc:	45 31 ff             	xor    %r15d,%r15d
 15132df:	62 f1 fd 48 6f 15 17 d7 00 ff 	vmovdqa64 -0xff28e9(%rip),%zmm2        # 520a00 <branch_sizing_patterns+0xc70>
 15132e9:	31 c0                	xor    %eax,%eax
 15132eb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
 15132f0:	62 d1 fd 48 6f 04 84 	vmovdqa64 (%r12,%rax,4),%zmm0
 15132f7:	48 89 c1             	mov    %rax,%rcx
 15132fa:	62 f2 7d 48 27 c0    	vptestmd %zmm0,%zmm0,%k0
 1513300:	c5 fb 93 c0          	kmovd  %k0,%eax
 1513304:	0d 00 00 01 00       	or     $0x10000,%eax
 1513309:	f3 0f bc c0          	tzcnt  %eax,%eax
 151330d:	48 01 c8             	add    %rcx,%rax
 1513310:	c5 f8 98 c0          	kortestw %k0,%k0
 1513314:	75 05                	jne    151331b <tier0_benchmark_run+0x1a1b>
 1513316:	48 39 f8             	cmp    %rdi,%rax
 1513319:	72 d5                	jb     15132f0 <tier0_benchmark_run+0x19f0>
 151331b:	4c 8b 5c 24 18       	mov    0x18(%rsp),%r11
 1513320:	48 39 f8             	cmp    %rdi,%rax
 1513323:	0f 83 a6 00 00 00    	jae    15133cf <tier0_benchmark_run+0x1acf>
 1513329:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
 151332e:	8b 04 81             	mov    (%rcx,%rax,4),%eax
 1513331:	83 e0 e0             	and    $0xffffffe0,%eax
 1513334:	41 39 c3             	cmp    %eax,%r11d
 1513337:	0f 86 92 00 00 00    	jbe    15133cf <tier0_benchmark_run+0x1acf>
 151333d:	4c 89 d9             	mov    %r11,%rcx
 1513340:	48 29 c1             	sub    %rax,%rcx
 1513343:	4d 89 c4             	mov    %r8,%r12
 1513346:	66 2e 0f 1f 84 00 00 00 00 00 	cs nopw 0x0(%rax,%rax,1)
 1513350:	89 ca                	mov    %ecx,%edx
 1513352:	48 83 e9 10          	sub    $0x10,%rcx
 1513356:	48 89 c6             	mov    %rax,%rsi
 1513359:	89 c7                	mov    %eax,%edi
 151335b:	41 89 c0             	mov    %eax,%r8d
 151335e:	c4 e2 69 f7 d3       	shlx   %edx,%ebx,%edx
 1513363:	f7 d2                	not    %edx
 1513365:	41 0f 43 d5          	cmovae %r13d,%edx
 1513369:	48 c1 ee 05          	shr    $0x5,%rsi
 151336d:	40 80 e7 10          	and    $0x10,%dil
 1513371:	41 83 e0 10          	and    $0x10,%r8d
 1513375:	49 8b 34 f6          	mov    (%r14,%rsi,8),%rsi
 1513379:	c5 fb 92 ca          	kmovd  %edx,%k1
 151337d:	c4 e2 c3 f7 fe       	shrx   %rdi,%rsi,%rdi
 1513382:	c4 62 38 f5 c6       	bzhi   %r8d,%esi,%r8d
 1513387:	48 c1 ee 20          	shr    $0x20,%rsi
 151338b:	62 f2 7d 48 7c c7    	vpbroadcastd %edi,%zmm0
 1513391:	48 8b 7c 24 58       	mov    0x58(%rsp),%rdi
 1513396:	49 8d 34 b4          	lea    (%r12,%rsi,4),%rsi
 151339a:	f3 45 0f b8 c0       	popcnt %r8d,%r8d
 151339f:	62 f1 7d 48 db c2    	vpandd %zmm2,%zmm0,%zmm0
 15133a5:	62 f2 7d 48 55 c0    	vpopcntd %zmm0,%zmm0
 15133ab:	62 b2 7d 48 36 04 86 	vpermd (%rsi,%r8,4),%zmm0,%zmm0
 15133b2:	62 f1 7e c9 6f 0c 87 	vmovdqu32 (%rdi,%rax,4),%zmm1{%k1}{z}
 15133b9:	62 f1 75 48 fe c0    	vpaddd %zmm0,%zmm1,%zmm0
 15133bf:	62 f1 7e 49 7f 04 87 	vmovdqu32 %zmm0,(%rdi,%rax,4){%k1}
 15133c6:	48 83 c0 10          	add    $0x10,%rax
 15133ca:	4c 39 d8             	cmp    %r11,%rax
 15133cd:	72 81                	jb     1513350 <tier0_benchmark_run+0x1a50>
 15133cf:	4c 8b 6c 24 30       	mov    0x30(%rsp),%r13
 15133d4:	44 89 e8             	mov    %r13d,%eax
 15133d7:	83 e0 07             	and    $0x7,%eax
 15133da:	41 83 fd 08          	cmp    $0x8,%r13d
 15133de:	73 1b                	jae    15133fb <tier0_benchmark_run+0x1afb>
 15133e0:	4c 8b 74 24 48       	mov    0x48(%rsp),%r14
 15133e5:	48 8b 5c 24 50       	mov    0x50(%rsp),%rbx
 15133ea:	4c 8b 4c 24 10       	mov    0x10(%rsp),%r9
 15133ef:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
 15133f4:	31 c9                	xor    %ecx,%ecx
 15133f6:	e9 7d 01 00 00       	jmp    1513578 <tier0_benchmark_run+0x1c78>
 15133fb:	48 8b 94 24 b8 00 00 00 	mov    0xb8(%rsp),%rdx
 1513403:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
 1513408:	c1 e1 06             	shl    $0x6,%ecx
 151340b:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
 1513410:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
 1513415:	4c 8b 74 24 48       	mov    0x48(%rsp),%r14
 151341a:	48 8b 5c 24 50       	mov    0x50(%rsp),%rbx
 151341f:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
 1513424:	41 83 e5 f8          	and    $0xfffffff8,%r13d
 1513428:	48 01 ca             	add    %rcx,%rdx
 151342b:	48 03 8c 24 98 00 00 00 	add    0x98(%rsp),%rcx
 1513433:	48 01 f2             	add    %rsi,%rdx
 1513436:	48 8d 54 17 5c       	lea    0x5c(%rdi,%rdx,1),%rdx
 151343b:	48 01 f1             	add    %rsi,%rcx
 151343e:	48 8d 74 0f 5c       	lea    0x5c(%rdi,%rcx,1),%rsi
 1513443:	31 c9                	xor    %ecx,%ecx
 1513445:	66 66 2e 0f 1f 84 00 00 00 00 00 	data16 cs nopw 0x0(%rax,%rax,1)
 1513450:	41 8b 3c 8a          	mov    (%r10,%rcx,4),%edi
 1513454:	44 8b 44 8a e4       	mov    -0x1c(%rdx,%rcx,4),%r8d
 1513459:	44 8b 4c 8e e4       	mov    -0x1c(%rsi,%rcx,4),%r9d
 151345e:	48 c1 e7 04          	shl    $0x4,%rdi
 1513462:	41 83 f8 01          	cmp    $0x1,%r8d
 1513466:	44 89 4c 3b 04       	mov    %r9d,0x4(%rbx,%rdi,1)
 151346b:	66 83 5c 3b 0c ff    	sbbw   $0xffff,0xc(%rbx,%rdi,1)
 1513471:	41 8b 7c 8a 04       	mov    0x4(%r10,%rcx,4),%edi
 1513476:	44 8b 44 8a e8       	mov    -0x18(%rdx,%rcx,4),%r8d
 151347b:	44 8b 4c 8e e8       	mov    -0x18(%rsi,%rcx,4),%r9d
 1513480:	48 c1 e7 04          	shl    $0x4,%rdi
 1513484:	41 83 f8 01          	cmp    $0x1,%r8d
 1513488:	44 89 4c 3b 04       	mov    %r9d,0x4(%rbx,%rdi,1)
 151348d:	66 83 5c 3b 0c ff    	sbbw   $0xffff,0xc(%rbx,%rdi,1)
 1513493:	41 8b 7c 8a 08       	mov    0x8(%r10,%rcx,4),%edi
 1513498:	44 8b 44 8a ec       	mov    -0x14(%rdx,%rcx,4),%r8d
 151349d:	44 8b 4c 8e ec       	mov    -0x14(%rsi,%rcx,4),%r9d
 15134a2:	48 c1 e7 04          	shl    $0x4,%rdi
 15134a6:	41 83 f8 01          	cmp    $0x1,%r8d
 15134aa:	44 89 4c 3b 04       	mov    %r9d,0x4(%rbx,%rdi,1)
 15134af:	66 83 5c 3b 0c ff    	sbbw   $0xffff,0xc(%rbx,%rdi,1)
 15134b5:	41 8b 7c 8a 0c       	mov    0xc(%r10,%rcx,4),%edi
 15134ba:	44 8b 44 8a f0       	mov    -0x10(%rdx,%rcx,4),%r8d
 15134bf:	44 8b 4c 8e f0       	mov    -0x10(%rsi,%rcx,4),%r9d
 15134c4:	48 c1 e7 04          	shl    $0x4,%rdi
 15134c8:	41 83 f8 01          	cmp    $0x1,%r8d
 15134cc:	44 89 4c 3b 04       	mov    %r9d,0x4(%rbx,%rdi,1)
 15134d1:	66 83 5c 3b 0c ff    	sbbw   $0xffff,0xc(%rbx,%rdi,1)
 15134d7:	41 8b 7c 8a 10       	mov    0x10(%r10,%rcx,4),%edi
 15134dc:	44 8b 44 8a f4       	mov    -0xc(%rdx,%rcx,4),%r8d
 15134e1:	44 8b 4c 8e f4       	mov    -0xc(%rsi,%rcx,4),%r9d
 15134e6:	48 c1 e7 04          	shl    $0x4,%rdi
 15134ea:	41 83 f8 01          	cmp    $0x1,%r8d
 15134ee:	44 89 4c 3b 04       	mov    %r9d,0x4(%rbx,%rdi,1)
 15134f3:	66 83 5c 3b 0c ff    	sbbw   $0xffff,0xc(%rbx,%rdi,1)
 15134f9:	41 8b 7c 8a 14       	mov    0x14(%r10,%rcx,4),%edi
 15134fe:	44 8b 44 8a f8       	mov    -0x8(%rdx,%rcx,4),%r8d
 1513503:	44 8b 4c 8e f8       	mov    -0x8(%rsi,%rcx,4),%r9d
 1513508:	48 c1 e7 04          	shl    $0x4,%rdi
 151350c:	41 83 f8 01          	cmp    $0x1,%r8d
 1513510:	44 89 4c 3b 04       	mov    %r9d,0x4(%rbx,%rdi,1)
 1513515:	66 83 5c 3b 0c ff    	sbbw   $0xffff,0xc(%rbx,%rdi,1)
 151351b:	41 8b 7c 8a 18       	mov    0x18(%r10,%rcx,4),%edi
 1513520:	44 8b 44 8a fc       	mov    -0x4(%rdx,%rcx,4),%r8d
 1513525:	44 8b 4c 8e fc       	mov    -0x4(%rsi,%rcx,4),%r9d
 151352a:	48 c1 e7 04          	shl    $0x4,%rdi
 151352e:	41 83 f8 01          	cmp    $0x1,%r8d
 1513532:	44 89 4c 3b 04       	mov    %r9d,0x4(%rbx,%rdi,1)
 1513537:	66 83 5c 3b 0c ff    	sbbw   $0xffff,0xc(%rbx,%rdi,1)
 151353d:	41 8b 7c 8a 1c       	mov    0x1c(%r10,%rcx,4),%edi
 1513542:	44 8b 04 8a          	mov    (%rdx,%rcx,4),%r8d
 1513546:	44 8b 0c 8e          	mov    (%rsi,%rcx,4),%r9d
 151354a:	48 c1 e7 04          	shl    $0x4,%rdi
 151354e:	41 83 f8 01          	cmp    $0x1,%r8d
 1513552:	44 89 4c 3b 04       	mov    %r9d,0x4(%rbx,%rdi,1)
 1513557:	66 83 5c 3b 0c ff    	sbbw   $0xffff,0xc(%rbx,%rdi,1)
 151355d:	48 83 c1 08          	add    $0x8,%rcx
 1513561:	49 39 cd             	cmp    %rcx,%r13
 1513564:	0f 85 e6 fe ff ff    	jne    1513450 <tier0_benchmark_run+0x1b50>
 151356a:	4c 8b 4c 24 10       	mov    0x10(%rsp),%r9
 151356f:	48 85 c0             	test   %rax,%rax
 1513572:	0f 84 c8 e5 ff ff    	je     1511b40 <tier0_benchmark_run+0x240>
 1513578:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
 151357d:	4c 8b 84 24 98 00 00 00 	mov    0x98(%rsp),%r8
 1513585:	4c 8b 9c 24 b8 00 00 00 	mov    0xb8(%rsp),%r11
 151358d:	48 8b 7c 24 40       	mov    0x40(%rsp),%rdi
 1513592:	c1 e0 02             	shl    $0x2,%eax
 1513595:	c1 e6 06             	shl    $0x6,%esi
 1513598:	49 01 f0             	add    %rsi,%r8
 151359b:	49 01 f3             	add    %rsi,%r11
 151359e:	49 01 f8             	add    %rdi,%r8
 15135a1:	49 01 fb             	add    %rdi,%r11
 15135a4:	31 ff                	xor    %edi,%edi
 15135a6:	49 8d 14 88          	lea    (%r8,%rcx,4),%rdx
 15135aa:	49 8d 34 8b          	lea    (%r11,%rcx,4),%rsi
 15135ae:	49 8d 0c 8a          	lea    (%r10,%rcx,4),%rcx
 15135b2:	49 8d 54 11 40       	lea    0x40(%r9,%rdx,1),%rdx
 15135b7:	49 8d 74 31 40       	lea    0x40(%r9,%rsi,1),%rsi
 15135bc:	0f 1f 40 00          	nopl   0x0(%rax)
 15135c0:	44 8b 04 39          	mov    (%rcx,%rdi,1),%r8d
 15135c4:	44 8b 0c 3e          	mov    (%rsi,%rdi,1),%r9d
 15135c8:	44 8b 14 3a          	mov    (%rdx,%rdi,1),%r10d
 15135cc:	49 c1 e0 04          	shl    $0x4,%r8
 15135d0:	41 83 f9 01          	cmp    $0x1,%r9d
 15135d4:	46 89 54 03 04       	mov    %r10d,0x4(%rbx,%r8,1)
 15135d9:	66 42 83 5c 03 0c ff 	sbbw   $0xffff,0xc(%rbx,%r8,1)
 15135e0:	48 83 c7 04          	add    $0x4,%rdi
 15135e4:	48 39 f8             	cmp    %rdi,%rax
 15135e7:	75 d7                	jne    15135c0 <tier0_benchmark_run+0x1cc0>
 15135e9:	e9 52 e5 ff ff       	jmp    1511b40 <tier0_benchmark_run+0x240>
 15135ee:	45 31 ff             	xor    %r15d,%r15d
 15135f1:	31 db                	xor    %ebx,%ebx
 15135f3:	45 31 f6             	xor    %r14d,%r14d
 15135f6:	eb 4a                	jmp    1513642 <tier0_benchmark_run+0x1d42>
 15135f8:	0f 1f 84 00 00 00 00 00 	nopl   0x0(%rax,%rax,1)
 1513600:	49 8b 4d 20          	mov    0x20(%r13),%rcx
 1513604:	49 8b 55 28          	mov    0x28(%r13),%rdx
 1513608:	49 8b 45 10          	mov    0x10(%r13),%rax
 151360c:	4a 8b 0c f1          	mov    (%rcx,%r14,8),%rcx
 1513610:	4a 8b 14 f2          	mov    (%rdx,%r14,8),%rdx
 1513614:	4a 8b 3c f0          	mov    (%rax,%r14,8),%rdi
 1513618:	e8 23 d2 04 00       	call   1560840 <x86_encode_16>
 151361d:	48 89 c1             	mov    %rax,%rcx
 1513620:	48 c1 f9 3f          	sar    $0x3f,%rcx
 1513624:	c4 e2 f0 f2 c8       	andn   %rax,%rcx,%rcx
 1513629:	41 8b 45 30          	mov    0x30(%r13),%eax
 151362d:	49 01 cf             	add    %rcx,%r15
 1513630:	49 ff c6             	inc    %r14
 1513633:	48 83 c3 68          	add    $0x68,%rbx
 1513637:	89 c1                	mov    %eax,%ecx
 1513639:	49 39 ce             	cmp    %rcx,%r14
 151363c:	0f 83 13 e4 ff ff    	jae    1511a55 <tier0_benchmark_run+0x155>
 1513642:	49 8b 4d 08          	mov    0x8(%r13),%rcx
 1513646:	8b 74 19 08          	mov    0x8(%rcx,%rbx,1),%esi
 151364a:	48 81 fe 11 11 11 11 	cmp    $0x11111111,%rsi
 1513651:	76 ad                	jbe    1513600 <tier0_benchmark_run+0x1d00>
 1513653:	31 c9                	xor    %ecx,%ecx
 1513655:	eb d6                	jmp    151362d <tier0_benchmark_run+0x1d2d>
 1513657:	48 8d 3d 99 c9 1b ff 	lea    -0xe43667(%rip),%rdi        # 6cfff7 <pp_string_value.meaning+0x72dab>
 151365e:	48 8d 35 2e 41 17 ff 	lea    -0xe8bed2(%rip),%rsi        # 687793 <pp_string_value.meaning+0x2a547>
 1513665:	48 8d 0d 42 41 17 ff 	lea    -0xe8bebe(%rip),%rcx        # 6877ae <pp_string_value.meaning+0x2a562>
 151366c:	ba bf 00 00 00       	mov    $0xbf,%edx
 1513671:	c5 f8 77             	vzeroupper
 1513674:	e8 d7 04 25 ff       	call   763b50 <__assert_fail@plt>
 1513679:	c5 f8 77             	vzeroupper
 151367c:	e8 5f 04 25 ff       	call   763ae0 <__stack_chk_fail@plt>
