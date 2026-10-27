
/home/david/buster-fast-bench/codex-180-fix-20261027-section64/build/compiler:     file format elf64-x86-64


Disassembly of section .text:

00000000018bd480 <tier0_benchmark_run>:
 18bd480:	55                   	push   %rbp
 18bd481:	48 89 e5             	mov    %rsp,%rbp
 18bd484:	41 57                	push   %r15
 18bd486:	41 56                	push   %r14
 18bd488:	41 55                	push   %r13
 18bd48a:	41 54                	push   %r12
 18bd48c:	53                   	push   %rbx
 18bd48d:	48 83 e4 c0          	and    $0xffffffffffffffc0,%rsp
 18bd491:	48 81 ec 00 03 00 00 	sub    $0x300,%rsp
 18bd498:	44 89 4c 24 6c       	mov    %r9d,0x6c(%rsp)
 18bd49d:	4c 89 84 24 d0 00 00 00 	mov    %r8,0xd0(%rsp)
 18bd4a5:	48 89 bc 24 38 01 00 00 	mov    %rdi,0x138(%rsp)
 18bd4ad:	49 89 cf             	mov    %rcx,%r15
 18bd4b0:	49 89 d5             	mov    %rdx,%r13
 18bd4b3:	41 89 f4             	mov    %esi,%r12d
 18bd4b6:	64 48 8b 04 25 28 00 00 00 	mov    %fs:0x28,%rax
 18bd4bf:	48 89 84 24 c0 02 00 00 	mov    %rax,0x2c0(%rsp)
 18bd4c7:	83 fe 02             	cmp    $0x2,%esi
 18bd4ca:	75 41                	jne    18bd50d <tier0_benchmark_run+0x8d>
 18bd4cc:	41 83 7d 30 00       	cmpl   $0x0,0x30(%r13)
 18bd4d1:	74 3a                	je     18bd50d <tier0_benchmark_run+0x8d>
 18bd4d3:	31 db                	xor    %ebx,%ebx
 18bd4d5:	45 31 f6             	xor    %r14d,%r14d
 18bd4d8:	0f 1f 84 00 00 00 00 00 	nopl   0x0(%rax,%rax,1)
 18bd4e0:	49 8b 45 08          	mov    0x8(%r13),%rax
 18bd4e4:	49 8b 4d 10          	mov    0x10(%r13),%rcx
 18bd4e8:	8b 54 18 08          	mov    0x8(%rax,%rbx,1),%edx
 18bd4ec:	4a 8b 3c f1          	mov    (%rcx,%r14,8),%rdi
 18bd4f0:	48 8b 34 18          	mov    (%rax,%rbx,1),%rsi
 18bd4f4:	48 c1 e2 04          	shl    $0x4,%rdx
 18bd4f8:	e8 53 6f ea fe       	call   764450 <memcpy@plt>
 18bd4fd:	41 8b 45 30          	mov    0x30(%r13),%eax
 18bd501:	49 ff c6             	inc    %r14
 18bd504:	48 83 c3 68          	add    $0x68,%rbx
 18bd508:	49 39 c6             	cmp    %rax,%r14
 18bd50b:	72 d3                	jb     18bd4e0 <tier0_benchmark_run+0x60>
 18bd50d:	48 8b b4 24 d0 00 00 00 	mov    0xd0(%rsp),%rsi
 18bd515:	8b 54 24 6c          	mov    0x6c(%rsp),%edx
 18bd519:	48 8d bc 24 48 01 00 00 	lea    0x148(%rsp),%rdi
 18bd521:	e8 7a e6 04 00       	call   190bba0 <tier0_benchmark_read>
 18bd526:	41 8b 45 30          	mov    0x30(%r13),%eax
 18bd52a:	85 c0                	test   %eax,%eax
 18bd52c:	0f 84 a0 00 00 00    	je     18bd5d2 <tier0_benchmark_run+0x152>
 18bd532:	49 8b 5f 08          	mov    0x8(%r15),%rbx
 18bd536:	44 89 64 24 3c       	mov    %r12d,0x3c(%rsp)
 18bd53b:	45 85 e4             	test   %r12d,%r12d
 18bd53e:	74 4f                	je     18bd58f <tier0_benchmark_run+0x10f>
 18bd540:	41 83 fc 01          	cmp    $0x1,%r12d
 18bd544:	0f 85 fc 00 00 00    	jne    18bd646 <tier0_benchmark_run+0x1c6>
 18bd54a:	4c 8d a4 24 c0 01 00 00 	lea    0x1c0(%rsp),%r12
 18bd552:	45 31 f6             	xor    %r14d,%r14d
 18bd555:	66 66 2e 0f 1f 84 00 00 00 00 00 	data16 cs nopw 0x0(%rax,%rax,1)
 18bd560:	49 8b 45 00          	mov    0x0(%r13),%rax
 18bd564:	4c 89 e7             	mov    %r12,%rdi
 18bd567:	4c 89 fa             	mov    %r15,%rdx
 18bd56a:	4a 8b 34 f0          	mov    (%rax,%r14,8),%rsi
 18bd56e:	e8 3d 18 01 00       	call   18cedb0 <tier0_compile_scalar>
 18bd573:	49 3b 5f 08          	cmp    0x8(%r15),%rbx
 18bd577:	0f 87 5a 1c 00 00    	ja     18bf1d7 <tier0_benchmark_run+0x1d57>
 18bd57d:	49 89 5f 08          	mov    %rbx,0x8(%r15)
 18bd581:	49 ff c6             	inc    %r14
 18bd584:	41 8b 45 30          	mov    0x30(%r13),%eax
 18bd588:	49 39 c6             	cmp    %rax,%r14
 18bd58b:	72 d3                	jb     18bd560 <tier0_benchmark_run+0xe0>
 18bd58d:	eb 3e                	jmp    18bd5cd <tier0_benchmark_run+0x14d>
 18bd58f:	4c 8d a4 24 c0 01 00 00 	lea    0x1c0(%rsp),%r12
 18bd597:	45 31 f6             	xor    %r14d,%r14d
 18bd59a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
 18bd5a0:	49 8b 45 00          	mov    0x0(%r13),%rax
 18bd5a4:	4c 89 e7             	mov    %r12,%rdi
 18bd5a7:	4c 89 fa             	mov    %r15,%rdx
 18bd5aa:	4a 8b 34 f0          	mov    (%rax,%r14,8),%rsi
 18bd5ae:	e8 1d 27 01 00       	call   18cfcd0 <tier0_compile>
 18bd5b3:	49 3b 5f 08          	cmp    0x8(%r15),%rbx
 18bd5b7:	0f 87 1a 1c 00 00    	ja     18bf1d7 <tier0_benchmark_run+0x1d57>
 18bd5bd:	49 89 5f 08          	mov    %rbx,0x8(%r15)
 18bd5c1:	49 ff c6             	inc    %r14
 18bd5c4:	41 8b 45 30          	mov    0x30(%r13),%eax
 18bd5c8:	49 39 c6             	cmp    %rax,%r14
 18bd5cb:	72 d3                	jb     18bd5a0 <tier0_benchmark_run+0x120>
 18bd5cd:	44 8b 64 24 3c       	mov    0x3c(%rsp),%r12d
 18bd5d2:	45 31 ff             	xor    %r15d,%r15d
 18bd5d5:	48 8b b4 24 d0 00 00 00 	mov    0xd0(%rsp),%rsi
 18bd5dd:	8b 54 24 6c          	mov    0x6c(%rsp),%edx
 18bd5e1:	48 8d bc 24 c0 01 00 00 	lea    0x1c0(%rsp),%rdi
 18bd5e9:	c5 f8 77             	vzeroupper
 18bd5ec:	e8 af e5 04 00       	call   190bba0 <tier0_benchmark_read>
 18bd5f1:	c5 fe 6f 84 24 c0 01 00 00 	vmovdqu 0x1c0(%rsp),%ymm0
 18bd5fa:	48 8b 84 24 38 01 00 00 	mov    0x138(%rsp),%rax
 18bd602:	c5 fd fb 84 24 48 01 00 00 	vpsubq 0x148(%rsp),%ymm0,%ymm0
 18bd60b:	c5 fe 7f 00          	vmovdqu %ymm0,(%rax)
 18bd60f:	41 83 fc 03          	cmp    $0x3,%r12d
 18bd613:	74 04                	je     18bd619 <tier0_benchmark_run+0x199>
 18bd615:	4d 8b 7d 50          	mov    0x50(%r13),%r15
 18bd619:	4d 89 7d 50          	mov    %r15,0x50(%r13)
 18bd61d:	64 48 8b 04 25 28 00 00 00 	mov    %fs:0x28,%rax
 18bd626:	48 3b 84 24 c0 02 00 00 	cmp    0x2c0(%rsp),%rax
 18bd62e:	0f 85 c5 1b 00 00    	jne    18bf1f9 <tier0_benchmark_run+0x1d79>
 18bd634:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
 18bd638:	5b                   	pop    %rbx
 18bd639:	41 5c                	pop    %r12
 18bd63b:	41 5d                	pop    %r13
 18bd63d:	41 5e                	pop    %r14
 18bd63f:	41 5f                	pop    %r15
 18bd641:	5d                   	pop    %rbp
 18bd642:	c5 f8 77             	vzeroupper
 18bd645:	c3                   	ret
 18bd646:	41 83 fc 02          	cmp    $0x2,%r12d
 18bd64a:	0f 85 1e 1b 00 00    	jne    18bf16e <tier0_benchmark_run+0x1cee>
 18bd650:	62 f2 7d 48 58 35 7a 2e cc fe 	vpbroadcastd -0x133d186(%rip),%zmm6        # 5804d4 <tier0_emit_x87.operations+0x8c>
 18bd65a:	62 f1 fd 48 6f 3d 9c 31 c6 fe 	vmovdqa64 -0x139ce64(%rip),%zmm7        # 520800 <branch_sizing_patterns+0xa70>
 18bd664:	62 e2 7d 48 5a 0d 92 86 cb fe 	vbroadcasti32x4 -0x134796e(%rip),%zmm17        # 575d00 <x86_effects_unknown+0x2a0>
 18bd66e:	62 72 7d 48 5a 0d 98 86 cb fe 	vbroadcasti32x4 -0x1347968(%rip),%zmm9        # 575d10 <x86_effects_unknown+0x2b0>
 18bd678:	62 72 7d 48 58 15 ae 2e cc fe 	vpbroadcastd -0x133d152(%rip),%zmm10        # 580530 <tier0_emit_x87.operations+0xe8>
 18bd682:	62 72 7d 48 58 1d a8 2e cc fe 	vpbroadcastd -0x133d158(%rip),%zmm11        # 580534 <tier0_emit_x87.operations+0xec>
 18bd68c:	48 b9 00 00 20 00 10 00 00 00 	movabs $0x1000200000,%rcx
 18bd696:	45 31 ff             	xor    %r15d,%r15d
 18bd699:	c4 41 39 ef c0       	vpxor  %xmm8,%xmm8,%xmm8
 18bd69e:	45 31 f6             	xor    %r14d,%r14d
 18bd6a1:	4c 89 ac 24 30 01 00 00 	mov    %r13,0x130(%rsp)
 18bd6a9:	48 81 c1 00 00 e0 ff 	add    $0xffffffffffe00000,%rcx
 18bd6b0:	48 89 8c 24 f0 00 00 00 	mov    %rcx,0xf0(%rsp)
 18bd6b8:	eb 45                	jmp    18bd6ff <tier0_benchmark_run+0x27f>
 18bd6ba:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
 18bd6c0:	48 8b 84 24 40 01 00 00 	mov    0x140(%rsp),%rax
 18bd6c8:	64 48 3b 04 25 18 ff ff ff 	cmp    %fs:0xffffffffffffff18,%rax
 18bd6d1:	0f 87 00 1b 00 00    	ja     18bf1d7 <tier0_benchmark_run+0x1d57>
 18bd6d7:	4c 8b ac 24 30 01 00 00 	mov    0x130(%rsp),%r13
 18bd6df:	64 48 89 04 25 18 ff ff ff 	mov    %rax,%fs:0xffffffffffffff18
 18bd6e8:	44 8b 64 24 3c       	mov    0x3c(%rsp),%r12d
 18bd6ed:	41 8b 45 30          	mov    0x30(%r13),%eax
 18bd6f1:	49 ff c6             	inc    %r14
 18bd6f4:	89 c1                	mov    %eax,%ecx
 18bd6f6:	49 39 ce             	cmp    %rcx,%r14
 18bd6f9:	0f 83 d6 fe ff ff    	jae    18bd5d5 <tier0_benchmark_run+0x155>
 18bd6ff:	49 8b 55 08          	mov    0x8(%r13),%rdx
 18bd703:	49 6b ce 68          	imul   $0x68,%r14,%rcx
 18bd707:	44 8b 4c 0a 08       	mov    0x8(%rdx,%rcx,1),%r9d
 18bd70c:	49 81 f9 11 11 11 11 	cmp    $0x11111111,%r9
 18bd713:	77 dc                	ja     18bd6f1 <tier0_benchmark_run+0x271>
 18bd715:	49 8b 45 10          	mov    0x10(%r13),%rax
 18bd719:	4c 8b 54 0a 10       	mov    0x10(%rdx,%rcx,1),%r10
 18bd71e:	4c 8b 44 0a 18       	mov    0x18(%rdx,%rcx,1),%r8
 18bd723:	8b 7c 0a 20          	mov    0x20(%rdx,%rcx,1),%edi
 18bd727:	49 8b 4d 18          	mov    0x18(%r13),%rcx
 18bd72b:	64 4c 8b 2c 25 10 ff ff ff 	mov    %fs:0xffffffffffffff10,%r13
 18bd734:	4a 8b 34 f0          	mov    (%rax,%r14,8),%rsi
 18bd738:	4a 8b 04 f1          	mov    (%rcx,%r14,8),%rax
 18bd73c:	4c 89 54 24 28       	mov    %r10,0x28(%rsp)
 18bd741:	48 89 7c 24 30       	mov    %rdi,0x30(%rsp)
 18bd746:	4c 89 84 24 a8 00 00 00 	mov    %r8,0xa8(%rsp)
 18bd74e:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
 18bd753:	4d 85 ed             	test   %r13,%r13
 18bd756:	74 0e                	je     18bd766 <tier0_benchmark_run+0x2e6>
 18bd758:	64 48 8b 0c 25 18 ff ff ff 	mov    %fs:0xffffffffffffff18,%rcx
 18bd761:	e9 16 01 00 00       	jmp    18bd87c <tier0_benchmark_run+0x3fc>
 18bd766:	48 bb 00 00 20 00 10 00 00 00 	movabs $0x1000200000,%rbx
 18bd770:	ba 03 00 00 00       	mov    $0x3,%edx
 18bd775:	b9 22 40 00 00       	mov    $0x4022,%ecx
 18bd77a:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
 18bd780:	4c 89 4c 24 18       	mov    %r9,0x18(%rsp)
 18bd785:	48 89 74 24 50       	mov    %rsi,0x50(%rsp)
 18bd78a:	4c 89 74 24 48       	mov    %r14,0x48(%rsp)
 18bd78f:	31 ff                	xor    %edi,%edi
 18bd791:	45 31 c9             	xor    %r9d,%r9d
 18bd794:	48 89 de             	mov    %rbx,%rsi
 18bd797:	c5 f8 77             	vzeroupper
 18bd79a:	e8 a1 6d ea fe       	call   764540 <mmap@plt>
 18bd79f:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
 18bd7a3:	74 50                	je     18bd7f5 <tier0_benchmark_run+0x375>
 18bd7a5:	4c 8d a8 ff ff 20 00 	lea    0x20ffff(%rax),%r13
 18bd7ac:	ba 0f 00 00 00       	mov    $0xf,%edx
 18bd7b1:	48 89 c7             	mov    %rax,%rdi
 18bd7b4:	49 81 e5 00 00 e0 ff 	and    $0xffffffffffe00000,%r13
 18bd7bb:	4d 89 ec             	mov    %r13,%r12
 18bd7be:	49 29 c4             	sub    %rax,%r12
 18bd7c1:	4c 89 e6             	mov    %r12,%rsi
 18bd7c4:	4d 8d b4 24 00 00 ff ff 	lea    -0x10000(%r12),%r14
 18bd7cc:	e8 1f 6d ea fe       	call   7644f0 <madvise@plt>
 18bd7d1:	4c 29 e3             	sub    %r12,%rbx
 18bd7d4:	ba 0e 00 00 00       	mov    $0xe,%edx
 18bd7d9:	4c 89 ef             	mov    %r13,%rdi
 18bd7dc:	48 89 de             	mov    %rbx,%rsi
 18bd7df:	e8 0c 6d ea fe       	call   7644f0 <madvise@plt>
 18bd7e4:	48 8b 84 24 f0 00 00 00 	mov    0xf0(%rsp),%rax
 18bd7ec:	49 81 c5 00 00 ff ff 	add    $0xffffffffffff0000,%r13
 18bd7f3:	eb 08                	jmp    18bd7fd <tier0_benchmark_run+0x37d>
 18bd7f5:	45 31 ed             	xor    %r13d,%r13d
 18bd7f8:	31 c0                	xor    %eax,%eax
 18bd7fa:	45 31 f6             	xor    %r14d,%r14d
 18bd7fd:	62 f2 7d 48 58 35 cd 2c cc fe 	vpbroadcastd -0x133d333(%rip),%zmm6        # 5804d4 <tier0_emit_x87.operations+0x8c>
 18bd807:	62 f1 fd 48 6f 3d ef 2f c6 fe 	vmovdqa64 -0x139d011(%rip),%zmm7        # 520800 <branch_sizing_patterns+0xa70>
 18bd811:	62 e2 7d 48 5a 0d e5 84 cb fe 	vbroadcasti32x4 -0x1347b1b(%rip),%zmm17        # 575d00 <x86_effects_unknown+0x2a0>
 18bd81b:	62 72 7d 48 5a 0d eb 84 cb fe 	vbroadcasti32x4 -0x1347b15(%rip),%zmm9        # 575d10 <x86_effects_unknown+0x2b0>
 18bd825:	62 72 7d 48 58 15 01 2d cc fe 	vpbroadcastd -0x133d2ff(%rip),%zmm10        # 580530 <tier0_emit_x87.operations+0xe8>
 18bd82f:	62 72 7d 48 58 1d fb 2c cc fe 	vpbroadcastd -0x133d305(%rip),%zmm11        # 580534 <tier0_emit_x87.operations+0xec>
 18bd839:	64 4c 89 2c 25 10 ff ff ff 	mov    %r13,%fs:0xffffffffffffff10
 18bd842:	64 48 c7 04 25 18 ff ff ff 00 00 00 00 	movq   $0x0,%fs:0xffffffffffffff18
 18bd84f:	64 48 89 04 25 20 ff ff ff 	mov    %rax,%fs:0xffffffffffffff20
 18bd858:	64 4c 89 34 25 28 ff ff ff 	mov    %r14,%fs:0xffffffffffffff28
 18bd861:	4c 8b 74 24 48       	mov    0x48(%rsp),%r14
 18bd866:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
 18bd86b:	48 8b 7c 24 30       	mov    0x30(%rsp),%rdi
 18bd870:	4c 8b 4c 24 18       	mov    0x18(%rsp),%r9
 18bd875:	31 c9                	xor    %ecx,%ecx
 18bd877:	c4 41 39 ef c0       	vpxor  %xmm8,%xmm8,%xmm8
 18bd87c:	4e 8d 44 29 3f       	lea    0x3f(%rcx,%r13,1),%r8
 18bd881:	4a 8d 04 29          	lea    (%rcx,%r13,1),%rax
 18bd885:	48 89 8c 24 40 01 00 00 	mov    %rcx,0x140(%rsp)
 18bd88d:	49 83 e0 c0          	and    $0xffffffffffffffc0,%r8
 18bd891:	49 39 c0             	cmp    %rax,%r8
 18bd894:	0f 82 26 fe ff ff    	jb     18bd6c0 <tier0_benchmark_run+0x240>
 18bd89a:	64 48 8b 0c 25 20 ff ff ff 	mov    %fs:0xffffffffffffff20,%rcx
 18bd8a3:	4c 89 c0             	mov    %r8,%rax
 18bd8a6:	4c 29 e8             	sub    %r13,%rax
 18bd8a9:	48 29 c1             	sub    %rax,%rcx
 18bd8ac:	0f 82 0e fe ff ff    	jb     18bd6c0 <tier0_benchmark_run+0x240>
 18bd8b2:	44 89 ca             	mov    %r9d,%edx
 18bd8b5:	c1 ea 06             	shr    $0x6,%edx
 18bd8b8:	4c 8d 24 bd 7c 00 00 00 	lea    0x7c(,%rdi,4),%r12
 18bd8c0:	4c 8d 1c bd bc 00 00 00 	lea    0xbc(,%rdi,4),%r11
 18bd8c8:	4c 89 4c 24 18       	mov    %r9,0x18(%rsp)
 18bd8cd:	48 8d 5a 01          	lea    0x1(%rdx),%rbx
 18bd8d1:	48 89 54 24 20       	mov    %rdx,0x20(%rsp)
 18bd8d6:	48 ba c0 ff ff ff 07 00 00 00 	movabs $0x7ffffffc0,%rdx
 18bd8e0:	4c 8b 4c 24 18       	mov    0x18(%rsp),%r9
 18bd8e5:	49 21 d4             	and    %rdx,%r12
 18bd8e8:	49 21 d3             	and    %rdx,%r11
 18bd8eb:	89 fa                	mov    %edi,%edx
 18bd8ed:	c1 ea 03             	shr    $0x3,%edx
 18bd8f0:	49 89 dd             	mov    %rbx,%r13
 18bd8f3:	48 89 9c 24 c8 00 00 00 	mov    %rbx,0xc8(%rsp)
 18bd8fb:	c1 e3 04             	shl    $0x4,%ebx
 18bd8fe:	49 c1 e5 06          	shl    $0x6,%r13
 18bd902:	83 c2 48             	add    $0x48,%edx
 18bd905:	83 c3 30             	add    $0x30,%ebx
 18bd908:	4c 89 64 24 70       	mov    %r12,0x70(%rsp)
 18bd90d:	4f 8d 24 a4          	lea    (%r12,%r12,4),%r12
 18bd911:	4c 89 6c 24 78       	mov    %r13,0x78(%rsp)
 18bd916:	4c 89 9c 24 88 00 00 00 	mov    %r11,0x88(%rsp)
 18bd91e:	83 e2 c0             	and    $0xffffffc0,%edx
 18bd921:	81 e3 c0 ff ff 1f    	and    $0x1fffffc0,%ebx
 18bd927:	4c 01 ea             	add    %r13,%rdx
 18bd92a:	48 89 5c 24 40       	mov    %rbx,0x40(%rsp)
 18bd92f:	4c 89 a4 24 80 00 00 00 	mov    %r12,0x80(%rsp)
 18bd937:	48 01 da             	add    %rbx,%rdx
 18bd93a:	4c 01 e2             	add    %r12,%rdx
 18bd93d:	4a 8d 14 5a          	lea    (%rdx,%r11,2),%rdx
 18bd941:	48 39 ca             	cmp    %rcx,%rdx
 18bd944:	0f 87 76 fd ff ff    	ja     18bd6c0 <tier0_benchmark_run+0x240>
 18bd94a:	48 01 d0             	add    %rdx,%rax
 18bd94d:	48 c7 84 24 b8 01 00 00 00 00 00 00 	movq   $0x0,0x1b8(%rsp)
 18bd959:	64 48 89 04 25 18 ff ff ff 	mov    %rax,%fs:0xffffffffffffff18
 18bd962:	4d 85 c0             	test   %r8,%r8
 18bd965:	0f 95 84 24 b8 01 00 00 	setne  0x1b8(%rsp)
 18bd96d:	0f 84 4d fd ff ff    	je     18bd6c0 <tier0_benchmark_run+0x240>
 18bd973:	4c 8b 64 24 78       	mov    0x78(%rsp),%r12
 18bd978:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
 18bd97d:	48 8b 5c 24 70       	mov    0x70(%rsp),%rbx
 18bd982:	4c 89 84 24 68 01 00 00 	mov    %r8,0x168(%rsp)
 18bd98a:	4c 8b 9c 24 88 00 00 00 	mov    0x88(%rsp),%r11
 18bd992:	4c 89 74 24 48       	mov    %r14,0x48(%rsp)
 18bd997:	48 89 74 24 50       	mov    %rsi,0x50(%rsp)
 18bd99c:	4d 01 c4             	add    %r8,%r12
 18bd99f:	4b 8d 04 1b          	lea    (%r11,%r11,1),%rax
 18bd9a3:	49 8d 14 0c          	lea    (%r12,%rcx,1),%rdx
 18bd9a7:	4c 89 a4 24 70 01 00 00 	mov    %r12,0x170(%rsp)
 18bd9af:	4c 89 64 24 78       	mov    %r12,0x78(%rsp)
 18bd9b4:	48 8d 0c 1a          	lea    (%rdx,%rbx,1),%rcx
 18bd9b8:	48 89 94 24 78 01 00 00 	mov    %rdx,0x178(%rsp)
 18bd9c0:	4c 8d 14 5a          	lea    (%rdx,%rbx,2),%r10
 18bd9c4:	48 89 54 24 60       	mov    %rdx,0x60(%rsp)
 18bd9c9:	48 89 8c 24 80 01 00 00 	mov    %rcx,0x180(%rsp)
 18bd9d1:	48 89 8c 24 e8 00 00 00 	mov    %rcx,0xe8(%rsp)
 18bd9d9:	48 8d 0c 5b          	lea    (%rbx,%rbx,2),%rcx
 18bd9dd:	48 8d 1c 9a          	lea    (%rdx,%rbx,4),%rbx
 18bd9e1:	4c 89 94 24 88 01 00 00 	mov    %r10,0x188(%rsp)
 18bd9e9:	4c 8d 24 0a          	lea    (%rdx,%rcx,1),%r12
 18bd9ed:	48 89 8c 24 b8 00 00 00 	mov    %rcx,0xb8(%rsp)
 18bd9f5:	48 8b 8c 24 80 00 00 00 	mov    0x80(%rsp),%rcx
 18bd9fd:	48 89 9c 24 e0 00 00 00 	mov    %rbx,0xe0(%rsp)
 18bda05:	4c 89 a4 24 90 01 00 00 	mov    %r12,0x190(%rsp)
 18bda0d:	48 89 9c 24 98 01 00 00 	mov    %rbx,0x198(%rsp)
 18bda15:	48 01 d1             	add    %rdx,%rcx
 18bda18:	4a 8d 14 19          	lea    (%rcx,%r11,1),%rdx
 18bda1c:	48 01 c8             	add    %rcx,%rax
 18bda1f:	48 89 8c 24 a0 01 00 00 	mov    %rcx,0x1a0(%rsp)
 18bda27:	48 89 8c 24 a0 00 00 00 	mov    %rcx,0xa0(%rsp)
 18bda2f:	48 89 94 24 a8 01 00 00 	mov    %rdx,0x1a8(%rsp)
 18bda37:	48 89 94 24 c0 00 00 00 	mov    %rdx,0xc0(%rsp)
 18bda3f:	48 89 84 24 b0 01 00 00 	mov    %rax,0x1b0(%rsp)
 18bda47:	41 83 f9 10          	cmp    $0x10,%r9d
 18bda4b:	73 10                	jae    18bda5d <tier0_benchmark_run+0x5dd>
 18bda4d:	4c 8b 74 24 58       	mov    0x58(%rsp),%r14
 18bda52:	45 31 ed             	xor    %r13d,%r13d
 18bda55:	45 31 ff             	xor    %r15d,%r15d
 18bda58:	e9 11 03 00 00       	jmp    18bdd6e <tier0_benchmark_run+0x8ee>
 18bda5d:	62 e2 7d 48 58 25 79 2a cc fe 	vpbroadcastd -0x133d587(%rip),%zmm20        # 5804e0 <tier0_emit_x87.operations+0x98>
 18bda67:	62 e2 7d 48 58 2d 73 2a cc fe 	vpbroadcastd -0x133d58d(%rip),%zmm21        # 5804e4 <tier0_emit_x87.operations+0x9c>
 18bda71:	62 e2 7d 48 58 35 6d 2a cc fe 	vpbroadcastd -0x133d593(%rip),%zmm22        # 5804e8 <tier0_emit_x87.operations+0xa0>
 18bda7b:	62 e2 7d 48 58 3d 67 2a cc fe 	vpbroadcastd -0x133d599(%rip),%zmm23        # 5804ec <tier0_emit_x87.operations+0xa4>
 18bda85:	62 62 7d 48 58 05 61 2a cc fe 	vpbroadcastd -0x133d59f(%rip),%zmm24        # 5804f0 <tier0_emit_x87.operations+0xa8>
 18bda8f:	62 62 7d 48 58 0d 5b 2a cc fe 	vpbroadcastd -0x133d5a5(%rip),%zmm25        # 5804f4 <tier0_emit_x87.operations+0xac>
 18bda99:	62 62 7d 48 58 15 55 2a cc fe 	vpbroadcastd -0x133d5ab(%rip),%zmm26        # 5804f8 <tier0_emit_x87.operations+0xb0>
 18bdaa3:	62 62 7d 48 58 1d 4f 2a cc fe 	vpbroadcastd -0x133d5b1(%rip),%zmm27        # 5804fc <tier0_emit_x87.operations+0xb4>
 18bdaad:	62 62 7d 48 58 25 49 2a cc fe 	vpbroadcastd -0x133d5b7(%rip),%zmm28        # 580500 <tier0_emit_x87.operations+0xb8>
 18bdab7:	62 62 7d 48 58 2d 43 2a cc fe 	vpbroadcastd -0x133d5bd(%rip),%zmm29        # 580504 <tier0_emit_x87.operations+0xbc>
 18bdac1:	62 62 7d 48 58 35 3d 2a cc fe 	vpbroadcastd -0x133d5c3(%rip),%zmm30        # 580508 <tier0_emit_x87.operations+0xc0>
 18bdacb:	62 62 7d 48 58 3d 37 2a cc fe 	vpbroadcastd -0x133d5c9(%rip),%zmm31        # 58050c <tier0_emit_x87.operations+0xc4>
 18bdad5:	62 72 7d 48 58 2d 31 2a cc fe 	vpbroadcastd -0x133d5cf(%rip),%zmm13        # 580510 <tier0_emit_x87.operations+0xc8>
 18bdadf:	62 72 7d 48 58 3d ef 29 cc fe 	vpbroadcastd -0x133d611(%rip),%zmm15        # 5804d8 <tier0_emit_x87.operations+0x90>
 18bdae9:	62 72 7d 48 5a 25 2d 82 cb fe 	vbroadcasti32x4 -0x1347dd3(%rip),%zmm12        # 575d20 <x86_effects_unknown+0x2c0>
 18bdaf3:	62 e2 7d 48 58 15 d3 29 cc fe 	vpbroadcastd -0x133d62d(%rip),%zmm18        # 5804d0 <tier0_emit_x87.operations+0x88>
 18bdafd:	4c 8b 74 24 58       	mov    0x58(%rsp),%r14
 18bdb02:	48 8d 86 c0 00 00 00 	lea    0xc0(%rsi),%rax
 18bdb09:	62 a3 7d 40 25 c0 ff 	vpternlogd $0xff,%zmm16,%zmm16,%zmm16
 18bdb10:	4c 8d 1d e9 89 da 0c 	lea    0xcda89e9(%rip),%r11        # e666500 <x86_template_storage>
 18bdb17:	31 c9                	xor    %ecx,%ecx
 18bdb19:	45 31 ed             	xor    %r13d,%r13d
 18bdb1c:	0f 1f 40 00          	nopl   0x0(%rax)
 18bdb20:	62 f1 fe 48 6f 40 fd 	vmovdqu64 -0xc0(%rax),%zmm0
 18bdb27:	62 f1 fe 48 6f 50 fe 	vmovdqu64 -0x80(%rax),%zmm2
 18bdb2e:	62 f1 fe 48 6f 58 ff 	vmovdqu64 -0x40(%rax),%zmm3
 18bdb35:	62 f1 fe 48 6f 20    	vmovdqu64 (%rax),%zmm4
 18bdb3b:	62 e2 7d 48 5a 1d eb 81 cb fe 	vbroadcasti32x4 -0x1347e15(%rip),%zmm19        # 575d30 <x86_effects_unknown+0x2d0>
 18bdb45:	62 71 fd 48 6f f6    	vmovdqa64 %zmm6,%zmm14
 18bdb4b:	c5 fc 46 c8          	kxnorw %k0,%k0,%k1
 18bdb4f:	44 89 ea             	mov    %r13d,%edx
 18bdb52:	4c 8d 79 10          	lea    0x10(%rcx),%r15
 18bdb56:	48 05 00 01 00 00    	add    $0x100,%rax
 18bdb5c:	62 f1 7d 48 62 ca    	vpunpckldq %zmm2,%zmm0,%zmm1
 18bdb62:	62 f1 65 48 62 ec    	vpunpckldq %zmm4,%zmm3,%zmm5
 18bdb68:	62 f1 7d 48 6a c2    	vpunpckhdq %zmm2,%zmm0,%zmm0
 18bdb6e:	62 f1 65 48 6a e4    	vpunpckhdq %zmm4,%zmm3,%zmm4
 18bdb74:	62 f1 fd 48 6c dc    	vpunpcklqdq %zmm4,%zmm0,%zmm3
 18bdb7a:	62 f1 fd 48 6d c4    	vpunpckhqdq %zmm4,%zmm0,%zmm0
 18bdb80:	62 f1 f5 48 6d cd    	vpunpckhqdq %zmm5,%zmm1,%zmm1
 18bdb86:	62 f1 7d 48 72 f0 04 	vpslld $0x4,%zmm0,%zmm0
 18bdb8d:	62 f2 f5 40 83 e3    	vpmultishiftqb %zmm3,%zmm17,%zmm4
 18bdb93:	62 f2 9d 48 83 eb    	vpmultishiftqb %zmm3,%zmm12,%zmm5
 18bdb99:	62 f2 75 48 27 c1    	vptestmd %zmm1,%zmm1,%k0
 18bdb9f:	62 f1 7d 48 db d6    	vpandd %zmm6,%zmm0,%zmm2
 18bdba5:	62 f2 b5 48 83 f3    	vpmultishiftqb %zmm3,%zmm9,%zmm6
 18bdbab:	62 d3 5d 48 25 ef d8 	vpternlogd $0xd8,%zmm15,%zmm4,%zmm5
 18bdbb2:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 18bdbb6:	62 f1 5d 48 72 f3 04 	vpslld $0x4,%zmm3,%zmm4
 18bdbbd:	62 f3 4d 58 25 2d 14 29 cc fe d8 	vpternlogd $0xd8,-0x133d6ec(%rip){1to16},%zmm6,%zmm5        # 5804dc <tier0_emit_x87.operations+0x94>
 18bdbc8:	62 d2 7d 49 90 44 93 13 	vpgatherdd 0x4c(%r11,%zmm2,4),%zmm0{%k1}
 18bdbd0:	62 f1 6d 48 72 d3 1a 	vpsrld $0x1a,%zmm3,%zmm2
 18bdbd7:	62 f2 65 40 00 f3    	vpshufb %zmm3,%zmm19,%zmm6
 18bdbdd:	62 e1 fd 48 6f df    	vmovdqa64 %zmm7,%zmm19
 18bdbe3:	62 f1 5d 48 72 e4 1f 	vpsrad $0x1f,%zmm4,%zmm4
 18bdbea:	62 f2 6d 48 36 d7    	vpermd %zmm7,%zmm2,%zmm2
 18bdbf0:	62 f1 45 48 72 d3 08 	vpsrld $0x8,%zmm3,%zmm7
 18bdbf7:	62 b3 6d 40 25 dd 6c 	vpternlogd $0x6c,%zmm21,%zmm18,%zmm3
 18bdbfe:	62 b1 65 48 fe d8    	vpaddd %zmm16,%zmm3,%zmm3
 18bdc04:	62 b3 6d 40 25 fe 6c 	vpternlogd $0x6c,%zmm22,%zmm18,%zmm7
 18bdc0b:	62 b1 45 48 fe f8    	vpaddd %zmm16,%zmm7,%zmm7
 18bdc11:	62 93 45 40 25 d8 ea 	vpternlogd $0xea,%zmm24,%zmm23,%zmm3
 18bdc18:	62 93 45 48 25 d9 f8 	vpternlogd $0xf8,%zmm25,%zmm7,%zmm3
 18bdc1f:	62 91 55 48 db fa    	vpandd %zmm26,%zmm5,%zmm7
 18bdc25:	62 f1 55 48 72 d5 03 	vpsrld $0x3,%zmm5,%zmm5
 18bdc2c:	62 f3 7d 48 25 fb f8 	vpternlogd $0xf8,%zmm3,%zmm0,%zmm7
 18bdc33:	62 93 7d 48 25 ec a2 	vpternlogd $0xa2,%zmm28,%zmm0,%zmm5
 18bdc3a:	62 92 45 48 3b db    	vpminud %zmm27,%zmm7,%zmm3
 18bdc40:	62 f1 5d 48 db fe    	vpandd %zmm6,%zmm4,%zmm7
 18bdc46:	62 93 6d 48 25 fe ec 	vpternlogd $0xec,%zmm30,%zmm2,%zmm7
 18bdc4d:	62 92 55 48 3b d5    	vpminud %zmm29,%zmm5,%zmm2
 18bdc53:	62 93 7d 48 25 ff f8 	vpternlogd $0xf8,%zmm31,%zmm0,%zmm7
 18bdc5a:	62 f3 6d 48 25 fb fe 	vpternlogd $0xfe,%zmm3,%zmm2,%zmm7
 18bdc61:	62 f1 65 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm3
 18bdc68:	62 f1 65 48 ef d1    	vpxord %zmm1,%zmm3,%zmm2
 18bdc6e:	62 b1 75 48 fe d8    	vpaddd %zmm16,%zmm1,%zmm3
 18bdc74:	62 f2 7d 48 44 d2    	vplzcntd %zmm2,%zmm2
 18bdc7a:	62 f2 5d 40 45 d2    	vpsrlvd %zmm2,%zmm20,%zmm2
 18bdc80:	62 f3 75 48 25 da 14 	vpternlogd $0x14,%zmm2,%zmm1,%zmm3
 18bdc87:	62 f1 6d 48 72 f6 10 	vpslld $0x10,%zmm6,%zmm2
 18bdc8e:	62 f2 7e 48 38 c8    	vpmovm2d %k0,%zmm1
 18bdc94:	62 d1 fd 48 6f f6    	vmovdqa64 %zmm14,%zmm6
 18bdc9a:	62 f1 0d 48 72 d0 1d 	vpsrld $0x1d,%zmm0,%zmm14
 18bdca1:	62 f1 6d 48 72 e2 1f 	vpsrad $0x1f,%zmm2,%zmm2
 18bdca8:	62 f3 5d 48 25 ca c8 	vpternlogd $0xc8,%zmm2,%zmm4,%zmm1
 18bdcaf:	62 f1 5d 58 db 25 5b 28 cc fe 	vpandd -0x133d7a5(%rip){1to16},%zmm4,%zmm4        # 580514 <tier0_emit_x87.operations+0xcc>
 18bdcb9:	62 d2 65 48 14 d6    	vprorvd %zmm14,%zmm3,%zmm2
 18bdcbf:	62 d1 75 48 db cd    	vpandd %zmm13,%zmm1,%zmm1
 18bdcc5:	62 f1 6d 48 72 e2 1f 	vpsrad $0x1f,%zmm2,%zmm2
 18bdccc:	62 f3 6d 48 25 e1 b8 	vpternlogd $0xb8,%zmm1,%zmm2,%zmm4
 18bdcd3:	62 b1 55 48 fe d0    	vpaddd %zmm16,%zmm5,%zmm2
 18bdcd9:	62 f1 5d 48 eb cf    	vpord  %zmm7,%zmm4,%zmm1
 18bdcdf:	62 f3 7d 58 25 0d 2e 28 cc fe 20 	vpternlogd $0x20,-0x133d7d2(%rip){1to16},%zmm0,%zmm1        # 580518 <tier0_emit_x87.operations+0xd0>
 18bdcea:	62 f1 7d 58 db 05 28 28 cc fe 	vpandd -0x133d7d8(%rip){1to16},%zmm0,%zmm0        # 58051c <tier0_emit_x87.operations+0xd4>
 18bdcf4:	62 f1 6d 48 72 e2 1f 	vpsrad $0x1f,%zmm2,%zmm2
 18bdcfb:	62 b1 fd 48 6f fb    	vmovdqa64 %zmm19,%zmm7
 18bdd01:	62 f2 7d 48 55 c9    	vpopcntd %zmm1,%zmm1
 18bdd07:	62 f1 6d 48 fe c0    	vpaddd %zmm0,%zmm2,%zmm0
 18bdd0d:	62 f1 7d 48 fe c1    	vpaddd %zmm1,%zmm0,%zmm0
 18bdd13:	c5 f9 6f 0d c5 7f cb fe 	vmovdqa -0x134803b(%rip),%xmm1        # 575ce0 <x86_effects_unknown+0x280>
 18bdd1b:	62 f2 75 48 8d c0    	vpermb %zmm0,%zmm1,%zmm0
 18bdd21:	62 f2 fd 18 40 0d e5 23 cc fe 	vpmullq -0x133dc1b(%rip){1to2},%xmm0,%xmm1        # 580110 <x86_semantics_benchmark_code.registers+0x120>
 18bdd2b:	c4 e2 71 00 15 bc 7f cb fe 	vpshufb -0x1348044(%rip),%xmm1,%xmm2        # 575cf0 <x86_effects_unknown+0x290>
 18bdd34:	c5 e9 fc c9          	vpaddb %xmm1,%xmm2,%xmm1
 18bdd38:	62 d2 7d 48 7c d5    	vpbroadcastd %r13d,%zmm2
 18bdd3e:	c5 f1 f8 c0          	vpsubb %xmm0,%xmm1,%xmm0
 18bdd42:	c4 c3 79 14 cd 0f    	vpextrb $0xf,%xmm1,%r13d
 18bdd48:	62 f2 7d 48 31 c0    	vpmovzxbd %xmm0,%zmm0
 18bdd4e:	41 01 d5             	add    %edx,%r13d
 18bdd51:	62 f1 6d 48 fe c0    	vpaddd %zmm0,%zmm2,%zmm0
 18bdd57:	62 d1 fe 48 7f 04 8e 	vmovdqu64 %zmm0,(%r14,%rcx,4)
 18bdd5e:	48 83 c1 20          	add    $0x20,%rcx
 18bdd62:	4c 39 c9             	cmp    %r9,%rcx
 18bdd65:	4c 89 f9             	mov    %r15,%rcx
 18bdd68:	0f 86 b2 fd ff ff    	jbe    18bdb20 <tier0_benchmark_run+0x6a0>
 18bdd6e:	4c 89 cb             	mov    %r9,%rbx
 18bdd71:	4c 29 fb             	sub    %r15,%rbx
 18bdd74:	4c 89 44 24 10       	mov    %r8,0x10(%rsp)
 18bdd79:	0f 86 92 03 00 00    	jbe    18be111 <tier0_benchmark_run+0xc91>
 18bdd7f:	4c 89 fe             	mov    %r15,%rsi
 18bdd82:	48 c1 e6 04          	shl    $0x4,%rsi
 18bdd86:	48 03 74 24 50       	add    0x50(%rsp),%rsi
 18bdd8b:	48 89 da             	mov    %rbx,%rdx
 18bdd8e:	48 c1 e2 04          	shl    $0x4,%rdx
 18bdd92:	48 8d bc 24 c0 01 00 00 	lea    0x1c0(%rsp),%rdi
 18bdd9a:	62 71 fd 48 7f 44 24 0a 	vmovdqa64 %zmm8,0x280(%rsp)
 18bdda2:	62 71 fd 48 7f 44 24 09 	vmovdqa64 %zmm8,0x240(%rsp)
 18bddaa:	62 71 fd 48 7f 44 24 08 	vmovdqa64 %zmm8,0x200(%rsp)
 18bddb2:	62 71 fd 48 7f 44 24 07 	vmovdqa64 %zmm8,0x1c0(%rsp)
 18bddba:	c5 f8 77             	vzeroupper
 18bddbd:	e8 8e 66 ea fe       	call   764450 <memcpy@plt>
 18bddc2:	62 f1 fd 48 6f 44 24 07 	vmovdqa64 0x1c0(%rsp),%zmm0
 18bddca:	62 f1 fd 48 6f 54 24 08 	vmovdqa64 0x200(%rsp),%zmm2
 18bddd2:	62 f1 fd 48 6f 5c 24 09 	vmovdqa64 0x240(%rsp),%zmm3
 18bddda:	62 f1 fd 48 6f 64 24 0a 	vmovdqa64 0x280(%rsp),%zmm4
 18bdde2:	62 72 7d 48 58 2d e8 26 cc fe 	vpbroadcastd -0x133d918(%rip),%zmm13        # 5804d4 <tier0_emit_x87.operations+0x8c>
 18bddec:	62 f2 7d 48 5a 35 2a 7f cb fe 	vbroadcasti32x4 -0x13480d6(%rip),%zmm6        # 575d20 <x86_effects_unknown+0x2c0>
 18bddf6:	62 e2 7d 48 5a 15 00 7f cb fe 	vbroadcasti32x4 -0x1348100(%rip),%zmm18        # 575d00 <x86_effects_unknown+0x2a0>
 18bde00:	62 72 7d 48 58 3d ce 26 cc fe 	vpbroadcastd -0x133d932(%rip),%zmm15        # 5804d8 <tier0_emit_x87.operations+0x90>
 18bde0a:	62 72 7d 48 5a 0d fc 7e cb fe 	vbroadcasti32x4 -0x1348104(%rip),%zmm9        # 575d10 <x86_effects_unknown+0x2b0>
 18bde14:	62 71 fd 48 6f 35 e2 29 c6 fe 	vmovdqa64 -0x139d61e(%rip),%zmm14        # 520800 <branch_sizing_patterns+0xa70>
 18bde1e:	62 e2 7d 48 58 25 bc 26 cc fe 	vpbroadcastd -0x133d944(%rip),%zmm20        # 5804e4 <tier0_emit_x87.operations+0x9c>
 18bde28:	62 e2 7d 48 5a 0d fe 7e cb fe 	vbroadcasti32x4 -0x1348102(%rip),%zmm17        # 575d30 <x86_effects_unknown+0x2d0>
 18bde32:	62 e2 7d 48 58 05 a0 26 cc fe 	vpbroadcastd -0x133d960(%rip),%zmm16        # 5804dc <tier0_emit_x87.operations+0x94>
 18bde3c:	62 f2 7d 48 58 3d 8a 26 cc fe 	vpbroadcastd -0x133d976(%rip),%zmm7        # 5804d0 <tier0_emit_x87.operations+0x88>
 18bde46:	62 e2 7d 48 58 2d 98 26 cc fe 	vpbroadcastd -0x133d968(%rip),%zmm21        # 5804e8 <tier0_emit_x87.operations+0xa0>
 18bde50:	62 e2 7d 48 58 3d 96 26 cc fe 	vpbroadcastd -0x133d96a(%rip),%zmm23        # 5804f0 <tier0_emit_x87.operations+0xa8>
 18bde5a:	62 e2 7d 48 58 35 88 26 cc fe 	vpbroadcastd -0x133d978(%rip),%zmm22        # 5804ec <tier0_emit_x87.operations+0xa4>
 18bde64:	62 62 7d 48 58 0d 8a 26 cc fe 	vpbroadcastd -0x133d976(%rip),%zmm25        # 5804f8 <tier0_emit_x87.operations+0xb0>
 18bde6e:	62 62 7d 48 58 05 7c 26 cc fe 	vpbroadcastd -0x133d984(%rip),%zmm24        # 5804f4 <tier0_emit_x87.operations+0xac>
 18bde78:	62 62 7d 48 58 35 86 26 cc fe 	vpbroadcastd -0x133d97a(%rip),%zmm30        # 580508 <tier0_emit_x87.operations+0xc0>
 18bde82:	62 62 7d 48 58 25 74 26 cc fe 	vpbroadcastd -0x133d98c(%rip),%zmm28        # 580500 <tier0_emit_x87.operations+0xb8>
 18bde8c:	62 62 7d 48 58 3d 76 26 cc fe 	vpbroadcastd -0x133d98a(%rip),%zmm31        # 58050c <tier0_emit_x87.operations+0xc4>
 18bde96:	62 62 7d 48 58 2d 64 26 cc fe 	vpbroadcastd -0x133d99c(%rip),%zmm29        # 580504 <tier0_emit_x87.operations+0xbc>
 18bdea0:	62 62 7d 48 58 15 52 26 cc fe 	vpbroadcastd -0x133d9ae(%rip),%zmm26        # 5804fc <tier0_emit_x87.operations+0xb4>
 18bdeaa:	c5 fc 46 c8          	kxnorw %k0,%k0,%k1
 18bdeae:	48 8d 05 4b 86 da 0c 	lea    0xcda864b(%rip),%rax        # e666500 <x86_template_storage>
 18bdeb5:	62 53 1d 48 25 e4 ff 	vpternlogd $0xff,%zmm12,%zmm12,%zmm12
 18bdebc:	62 62 7d 48 58 1d 1a 26 cc fe 	vpbroadcastd -0x133d9e6(%rip),%zmm27        # 5804e0 <tier0_emit_x87.operations+0x98>
 18bdec6:	62 e2 7d 48 58 1d 40 26 cc fe 	vpbroadcastd -0x133d9c0(%rip),%zmm19        # 580510 <tier0_emit_x87.operations+0xc8>
 18bded0:	62 72 7d 48 58 1d 5a 26 cc fe 	vpbroadcastd -0x133d9a6(%rip),%zmm11        # 580534 <tier0_emit_x87.operations+0xec>
 18bdeda:	62 72 7d 48 58 15 4c 26 cc fe 	vpbroadcastd -0x133d9b4(%rip),%zmm10        # 580530 <tier0_emit_x87.operations+0xe8>
 18bdee4:	4c 8b 4c 24 18       	mov    0x18(%rsp),%r9
 18bdee9:	4c 8b 44 24 10       	mov    0x10(%rsp),%r8
 18bdeee:	48 8b 7c 24 30       	mov    0x30(%rsp),%rdi
 18bdef3:	c4 41 39 ef c0       	vpxor  %xmm8,%xmm8,%xmm8
 18bdef8:	62 f1 7d 48 62 ca    	vpunpckldq %zmm2,%zmm0,%zmm1
 18bdefe:	62 f1 65 48 62 ec    	vpunpckldq %zmm4,%zmm3,%zmm5
 18bdf04:	62 f1 7d 48 6a c2    	vpunpckhdq %zmm2,%zmm0,%zmm0
 18bdf0a:	62 f1 65 48 6a e4    	vpunpckhdq %zmm4,%zmm3,%zmm4
 18bdf10:	62 f1 fd 48 6c dc    	vpunpcklqdq %zmm4,%zmm0,%zmm3
 18bdf16:	62 f1 fd 48 6d c4    	vpunpckhqdq %zmm4,%zmm0,%zmm0
 18bdf1c:	62 f1 f5 48 6d cd    	vpunpckhqdq %zmm5,%zmm1,%zmm1
 18bdf22:	62 f1 7d 48 72 f0 04 	vpslld $0x4,%zmm0,%zmm0
 18bdf29:	62 f2 cd 48 83 eb    	vpmultishiftqb %zmm3,%zmm6,%zmm5
 18bdf2f:	62 f2 ed 40 83 e3    	vpmultishiftqb %zmm3,%zmm18,%zmm4
 18bdf35:	62 f2 b5 48 83 f3    	vpmultishiftqb %zmm3,%zmm9,%zmm6
 18bdf3b:	62 f2 75 48 27 c1    	vptestmd %zmm1,%zmm1,%k0
 18bdf41:	62 d1 7d 48 db d5    	vpandd %zmm13,%zmm0,%zmm2
 18bdf47:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 18bdf4b:	62 d3 5d 48 25 ef d8 	vpternlogd $0xd8,%zmm15,%zmm4,%zmm5
 18bdf52:	62 f1 5d 48 72 f3 04 	vpslld $0x4,%zmm3,%zmm4
 18bdf59:	62 f2 7d 49 90 44 90 13 	vpgatherdd 0x4c(%rax,%zmm2,4),%zmm0{%k1}
 18bdf61:	62 f1 6d 48 72 d3 1a 	vpsrld $0x1a,%zmm3,%zmm2
 18bdf68:	62 b3 4d 48 25 e8 d8 	vpternlogd $0xd8,%zmm16,%zmm6,%zmm5
 18bdf6f:	62 e1 fd 48 6f c7    	vmovdqa64 %zmm7,%zmm16
 18bdf75:	62 f1 45 48 72 d3 08 	vpsrld $0x8,%zmm3,%zmm7
 18bdf7c:	62 f2 75 40 00 f3    	vpshufb %zmm3,%zmm17,%zmm6
 18bdf82:	62 b3 7d 40 25 dc 6c 	vpternlogd $0x6c,%zmm20,%zmm16,%zmm3
 18bdf89:	62 f1 5d 48 72 e4 1f 	vpsrad $0x1f,%zmm4,%zmm4
 18bdf90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 18bdf95:	62 d2 6d 48 36 d6    	vpermd %zmm14,%zmm2,%zmm2
 18bdf9b:	62 d1 65 48 fe dc    	vpaddd %zmm12,%zmm3,%zmm3
 18bdfa1:	62 b3 7d 40 25 fd 6c 	vpternlogd $0x6c,%zmm21,%zmm16,%zmm7
 18bdfa8:	c4 e2 61 f7 c0       	shlx   %ebx,%eax,%eax
 18bdfad:	62 d1 45 48 fe fc    	vpaddd %zmm12,%zmm7,%zmm7
 18bdfb3:	62 b3 4d 40 25 df ea 	vpternlogd $0xea,%zmm23,%zmm22,%zmm3
 18bdfba:	62 e1 5d 48 db ce    	vpandd %zmm6,%zmm4,%zmm17
 18bdfc0:	62 f1 05 48 72 f6 10 	vpslld $0x10,%zmm6,%zmm15
 18bdfc7:	62 d1 fd 48 6f f5    	vmovdqa64 %zmm13,%zmm6
 18bdfcd:	f7 d0                	not    %eax
 18bdfcf:	62 93 45 48 25 d8 f8 	vpternlogd $0xf8,%zmm24,%zmm7,%zmm3
 18bdfd6:	62 91 55 48 db f9    	vpandd %zmm25,%zmm5,%zmm7
 18bdfdc:	62 f1 55 48 72 d5 03 	vpsrld $0x3,%zmm5,%zmm5
 18bdfe3:	c5 fb 92 c8          	kmovd  %eax,%k1
 18bdfe7:	62 f3 7d 48 25 fb f8 	vpternlogd $0xf8,%zmm3,%zmm0,%zmm7
 18bdfee:	62 93 7d 48 25 ec a2 	vpternlogd $0xa2,%zmm28,%zmm0,%zmm5
 18bdff5:	62 f1 15 48 72 d0 1d 	vpsrld $0x1d,%zmm0,%zmm13
 18bdffc:	62 83 6d 48 25 ce ec 	vpternlogd $0xec,%zmm30,%zmm2,%zmm17
 18be003:	62 92 45 48 3b da    	vpminud %zmm26,%zmm7,%zmm3
 18be009:	62 92 55 48 3b d5    	vpminud %zmm29,%zmm5,%zmm2
 18be00f:	62 d1 fd 48 6f fe    	vmovdqa64 %zmm14,%zmm7
 18be015:	62 83 7d 48 25 cf f8 	vpternlogd $0xf8,%zmm31,%zmm0,%zmm17
 18be01c:	62 e3 6d 48 25 cb fe 	vpternlogd $0xfe,%zmm3,%zmm2,%zmm17
 18be023:	62 f1 65 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm3
 18be02a:	62 f1 65 48 ef d1    	vpxord %zmm1,%zmm3,%zmm2
 18be030:	62 d1 75 48 fe dc    	vpaddd %zmm12,%zmm1,%zmm3
 18be036:	62 f2 7d 48 44 d2    	vplzcntd %zmm2,%zmm2
 18be03c:	62 f2 25 40 45 d2    	vpsrlvd %zmm2,%zmm27,%zmm2
 18be042:	62 f3 75 48 25 da 14 	vpternlogd $0x14,%zmm2,%zmm1,%zmm3
 18be049:	62 d1 6d 48 72 e7 1f 	vpsrad $0x1f,%zmm15,%zmm2
 18be050:	62 f2 7e 48 38 c8    	vpmovm2d %k0,%zmm1
 18be056:	62 f3 5d 48 25 ca c8 	vpternlogd $0xc8,%zmm2,%zmm4,%zmm1
 18be05d:	62 f1 5d 58 db 25 ad 24 cc fe 	vpandd -0x133db53(%rip){1to16},%zmm4,%zmm4        # 580514 <tier0_emit_x87.operations+0xcc>
 18be067:	62 d2 65 48 14 d5    	vprorvd %zmm13,%zmm3,%zmm2
 18be06d:	62 b1 75 48 db cb    	vpandd %zmm19,%zmm1,%zmm1
 18be073:	62 f1 6d 48 72 e2 1f 	vpsrad $0x1f,%zmm2,%zmm2
 18be07a:	62 f3 6d 48 25 e1 b8 	vpternlogd $0xb8,%zmm1,%zmm2,%zmm4
 18be081:	62 d1 55 48 fe d4    	vpaddd %zmm12,%zmm5,%zmm2
 18be087:	62 b1 5d 48 eb c9    	vpord  %zmm17,%zmm4,%zmm1
 18be08d:	62 f3 7d 58 25 0d 80 24 cc fe 20 	vpternlogd $0x20,-0x133db80(%rip){1to16},%zmm0,%zmm1        # 580518 <tier0_emit_x87.operations+0xd0>
 18be098:	62 f1 7d 58 db 05 7a 24 cc fe 	vpandd -0x133db86(%rip){1to16},%zmm0,%zmm0        # 58051c <tier0_emit_x87.operations+0xd4>
 18be0a2:	62 f1 6d 48 72 e2 1f 	vpsrad $0x1f,%zmm2,%zmm2
 18be0a9:	62 a1 fd 48 6f ca    	vmovdqa64 %zmm18,%zmm17
 18be0af:	62 f2 7d 48 55 c9    	vpopcntd %zmm1,%zmm1
 18be0b5:	62 f1 6d 48 fe c0    	vpaddd %zmm0,%zmm2,%zmm0
 18be0bb:	62 f1 7d 48 fe c1    	vpaddd %zmm1,%zmm0,%zmm0
 18be0c1:	c5 f9 6f 0d 17 7c cb fe 	vmovdqa -0x13483e9(%rip),%xmm1        # 575ce0 <x86_effects_unknown+0x280>
 18be0c9:	62 f2 75 48 8d c0    	vpermb %zmm0,%zmm1,%zmm0
 18be0cf:	62 f2 fd 18 40 0d 37 20 cc fe 	vpmullq -0x133dfc9(%rip){1to2},%xmm0,%xmm1        # 580110 <x86_semantics_benchmark_code.registers+0x120>
 18be0d9:	c4 e2 71 00 15 0e 7c cb fe 	vpshufb -0x13483f2(%rip),%xmm1,%xmm2        # 575cf0 <x86_effects_unknown+0x290>
 18be0e2:	c5 e9 fc c9          	vpaddb %xmm1,%xmm2,%xmm1
 18be0e6:	62 d2 7d 48 7c d5    	vpbroadcastd %r13d,%zmm2
 18be0ec:	c5 f1 f8 c0          	vpsubb %xmm0,%xmm1,%xmm0
 18be0f0:	c4 e3 79 14 c8 0f    	vpextrb $0xf,%xmm1,%eax
 18be0f6:	62 f2 7d 48 31 c0    	vpmovzxbd %xmm0,%zmm0
 18be0fc:	44 01 e8             	add    %r13d,%eax
 18be0ff:	41 89 c5             	mov    %eax,%r13d
 18be102:	62 f1 6d 48 fe c0    	vpaddd %zmm0,%zmm2,%zmm0
 18be108:	62 91 7e 49 7f 04 be 	vmovdqu32 %zmm0,(%r14,%r15,4){%k1}
 18be10f:	eb 0a                	jmp    18be11b <tier0_benchmark_run+0xc9b>
 18be111:	62 e2 7d 48 58 05 b5 23 cc fe 	vpbroadcastd -0x133dc4b(%rip),%zmm16        # 5804d0 <tier0_emit_x87.operations+0x88>
 18be11b:	4c 8b 74 24 48       	mov    0x48(%rsp),%r14
 18be120:	45 31 ff             	xor    %r15d,%r15d
 18be123:	48 8d 04 bd 00 00 00 00 	lea    0x0(,%rdi,4),%rax
 18be12b:	44 89 e9             	mov    %r13d,%ecx
 18be12e:	48 01 c1             	add    %rax,%rcx
 18be131:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
 18be136:	48 81 f9 ff ff ff 7f 	cmp    $0x7fffffff,%rcx
 18be13d:	0f 87 7d f5 ff ff    	ja     18bd6c0 <tier0_benchmark_run+0x240>
 18be143:	48 8b 8c 24 a0 00 00 00 	mov    0xa0(%rsp),%rcx
 18be14b:	48 8b 94 24 c0 00 00 00 	mov    0xc0(%rsp),%rdx
 18be153:	c7 01 00 00 00 00    	movl   $0x0,(%rcx)
 18be159:	c7 02 00 00 00 00    	movl   $0x0,(%rdx)
 18be15f:	48 85 ff             	test   %rdi,%rdi
 18be162:	0f 84 58 f5 ff ff    	je     18bd6c0 <tier0_benchmark_run+0x240>
 18be168:	48 8b 54 24 70       	mov    0x70(%rsp),%rdx
 18be16d:	4c 8d 70 0c          	lea    0xc(%rax),%r14
 18be171:	48 8d 47 ff          	lea    -0x1(%rdi),%rax
 18be175:	62 d2 7d 48 7c c9    	vpbroadcastd %r9d,%zmm1
 18be17b:	62 d2 7d 48 7c c5    	vpbroadcastd %r13d,%zmm0
 18be181:	4c 89 a4 24 b0 00 00 00 	mov    %r12,0xb0(%rsp)
 18be189:	48 89 c6             	mov    %rax,%rsi
 18be18c:	48 c1 ee 04          	shr    $0x4,%rsi
 18be190:	4c 8d 1c 95 00 00 00 00 	lea    0x0(,%rdx,4),%r11
 18be198:	4c 89 9c 24 98 00 00 00 	mov    %r11,0x98(%rsp)
 18be1a0:	0f 84 3c 04 00 00    	je     18be5e2 <tier0_benchmark_run+0x1162>
 18be1a6:	4c 8b 4c 24 28       	mov    0x28(%rsp),%r9
 18be1ab:	48 8b 8c 24 a8 00 00 00 	mov    0xa8(%rsp),%rcx
 18be1b3:	48 89 84 24 d8 00 00 00 	mov    %rax,0xd8(%rsp)
 18be1bb:	62 51 fd 48 6f e2    	vmovdqa64 %zmm10,%zmm12
 18be1c1:	62 51 fd 48 6f eb    	vmovdqa64 %zmm11,%zmm13
 18be1c7:	62 72 7d 48 58 15 53 23 cc fe 	vpbroadcastd -0x133dcad(%rip),%zmm10        # 580524 <tier0_emit_x87.operations+0xdc>
 18be1d1:	62 72 7d 48 58 1d 51 23 cc fe 	vpbroadcastd -0x133dcaf(%rip),%zmm11        # 58052c <tier0_emit_x87.operations+0xe4>
 18be1db:	62 72 7d 48 58 35 3b 23 cc fe 	vpbroadcastd -0x133dcc5(%rip),%zmm14        # 580520 <tier0_emit_x87.operations+0xd8>
 18be1e5:	62 72 7d 48 58 3d 39 23 cc fe 	vpbroadcastd -0x133dcc7(%rip),%zmm15        # 580528 <tier0_emit_x87.operations+0xe0>
 18be1ef:	48 ff c6             	inc    %rsi
 18be1f2:	c5 e9 ef d2          	vpxor  %xmm2,%xmm2,%xmm2
 18be1f6:	49 89 ff             	mov    %rdi,%r15
 18be1f9:	4c 89 b4 24 90 00 00 00 	mov    %r14,0x90(%rsp)
 18be201:	48 83 e6 fe          	and    $0xfffffffffffffffe,%rsi
 18be205:	49 8d 41 40          	lea    0x40(%r9),%rax
 18be209:	48 89 84 24 28 01 00 00 	mov    %rax,0x128(%rsp)
 18be211:	48 8d 41 40          	lea    0x40(%rcx),%rax
 18be215:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
 18be21a:	c1 e1 06             	shl    $0x6,%ecx
 18be21d:	48 03 4c 24 40       	add    0x40(%rsp),%rcx
 18be222:	48 89 84 24 20 01 00 00 	mov    %rax,0x120(%rsp)
 18be22a:	48 8d 04 11          	lea    (%rcx,%rdx,1),%rax
 18be22e:	4d 8d 0c 08          	lea    (%r8,%rcx,1),%r9
 18be232:	49 8d 84 00 80 00 00 00 	lea    0x80(%r8,%rax,1),%rax
 18be23a:	4c 89 8c 24 00 01 00 00 	mov    %r9,0x100(%rsp)
 18be242:	4c 8b 8c 24 88 00 00 00 	mov    0x88(%rsp),%r9
 18be24a:	48 89 84 24 18 01 00 00 	mov    %rax,0x118(%rsp)
 18be252:	4a 8d 04 19          	lea    (%rcx,%r11,1),%rax
 18be256:	4c 8b 9c 24 80 00 00 00 	mov    0x80(%rsp),%r11
 18be25e:	49 8d 84 00 80 00 00 00 	lea    0x80(%r8,%rax,1),%rax
 18be266:	48 89 84 24 10 01 00 00 	mov    %rax,0x110(%rsp)
 18be26e:	48 8d 04 52          	lea    (%rdx,%rdx,2),%rax
 18be272:	48 01 c8             	add    %rcx,%rax
 18be275:	4d 01 d9             	add    %r11,%r9
 18be278:	49 8d 84 00 80 00 00 00 	lea    0x80(%r8,%rax,1),%rax
 18be280:	49 01 c9             	add    %rcx,%r9
 18be283:	4b 8d 94 08 84 00 00 00 	lea    0x84(%r8,%r9,1),%rdx
 18be28b:	45 31 c9             	xor    %r9d,%r9d
 18be28e:	48 89 84 24 08 01 00 00 	mov    %rax,0x108(%rsp)
 18be296:	4a 8d 04 19          	lea    (%rcx,%r11,1),%rax
 18be29a:	31 c9                	xor    %ecx,%ecx
 18be29c:	49 8d 84 00 84 00 00 00 	lea    0x84(%r8,%rax,1),%rax
 18be2a4:	48 89 94 24 80 00 00 00 	mov    %rdx,0x80(%rsp)
 18be2ac:	48 89 84 24 f8 00 00 00 	mov    %rax,0xf8(%rsp)
 18be2b4:	66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 cs nopw 0x0(%rax,%rax,1)
 18be2c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 18be2c5:	4c 8b ac 24 20 01 00 00 	mov    0x120(%rsp),%r13
 18be2cd:	4c 8b 94 24 28 01 00 00 	mov    0x128(%rsp),%r10
 18be2d5:	4c 89 fb             	mov    %r15,%rbx
 18be2d8:	48 83 eb 10          	sub    $0x10,%rbx
 18be2dc:	48 89 b4 24 88 00 00 00 	mov    %rsi,0x88(%rsp)
 18be2e4:	48 8b 74 24 58       	mov    0x58(%rsp),%rsi
 18be2e9:	c5 d1 ef ed          	vpxor  %xmm5,%xmm5,%xmm5
 18be2ed:	62 f1 fd 48 6f f0    	vmovdqa64 %zmm0,%zmm6
 18be2f3:	4c 8b 84 24 00 01 00 00 	mov    0x100(%rsp),%r8
 18be2fb:	48 8b 94 24 10 01 00 00 	mov    0x110(%rsp),%rdx
 18be303:	4c 8b 9c 24 f8 00 00 00 	mov    0xf8(%rsp),%r11
 18be30b:	48 8b bc 24 80 00 00 00 	mov    0x80(%rsp),%rdi
 18be313:	c4 62 01 f7 f0       	shlx   %r15d,%eax,%r14d
 18be318:	b8 ff ff 00 00       	mov    $0xffff,%eax
 18be31d:	41 f7 d6             	not    %r14d
 18be320:	44 0f 43 f0          	cmovae %eax,%r14d
 18be324:	48 8b 84 24 90 00 00 00 	mov    0x90(%rsp),%rax
 18be32c:	c4 c1 7b 92 ce       	kmovd  %r14d,%k1
 18be331:	45 89 ce             	mov    %r9d,%r14d
 18be334:	41 b9 ff ff ff ff    	mov    $0xffffffff,%r9d
 18be33a:	62 d1 7e c9 6f 64 8d ff 	vmovdqu32 -0x40(%r13,%rcx,4),%zmm4{%k1}{z}
 18be342:	62 d1 7e c9 6f 5c 8a ff 	vmovdqu32 -0x40(%r10,%rcx,4),%zmm3{%k1}{z}
 18be34a:	c4 e1 f8 90 d9       	kmovq  %k1,%k3
 18be34f:	c4 42 61 f7 c9       	shlx   %ebx,%r9d,%r9d
 18be354:	41 f7 d1             	not    %r9d
 18be357:	62 f3 5d 49 1e d1 01 	vpcmpltud %zmm1,%zmm4,%k2{%k1}
 18be35e:	62 f2 7d 4b 90 2c 9e 	vpgatherdd (%rsi,%zmm3,4),%zmm5{%k3}
 18be365:	62 f1 65 48 fe db    	vpaddd %zmm3,%zmm3,%zmm3
 18be36b:	c4 e1 f8 90 d9       	kmovq  %k1,%k3
 18be370:	62 f2 7d 4a 90 34 a6 	vpgatherdd (%rsi,%zmm4,4),%zmm6{%k2}
 18be377:	62 f1 4d 48 fa e5    	vpsubd %zmm5,%zmm6,%zmm4
 18be37d:	62 d1 5d c9 fe e3    	vpaddd %zmm11,%zmm4,%zmm4{%k1}{z}
 18be383:	62 d1 5d 48 fe ec    	vpaddd %zmm12,%zmm4,%zmm5
 18be389:	62 d3 55 48 1e d5 01 	vpcmpltud %zmm13,%zmm5,%k2
 18be390:	c5 d1 ef ed          	vpxor  %xmm5,%xmm5,%xmm5
 18be394:	62 f2 7d 4b 90 2c d8 	vpgatherdd (%rax,%zmm3,8),%zmm5{%k3}
 18be39b:	48 8b 84 24 08 01 00 00 	mov    0x108(%rsp),%rax
 18be3a3:	c5 ec 41 c1          	kandw  %k1,%k2,%k0
 18be3a7:	c5 78 93 e0          	kmovw  %k0,%r12d
 18be3ab:	45 09 e6             	or     %r12d,%r14d
 18be3ae:	4c 8b a4 24 18 01 00 00 	mov    0x118(%rsp),%r12
 18be3b6:	48 83 fb 10          	cmp    $0x10,%rbx
 18be3ba:	bb ff ff 00 00       	mov    $0xffff,%ebx
 18be3bf:	44 0f 43 cb          	cmovae %ebx,%r9d
 18be3c3:	49 83 c7 e0          	add    $0xffffffffffffffe0,%r15
 18be3c7:	62 d1 55 48 db de    	vpandd %zmm14,%zmm5,%zmm3
 18be3cd:	62 d1 65 48 76 da    	vpcmpeqd %zmm10,%zmm3,%k3
 18be3d3:	62 d2 7d 43 64 df    	vpblendmd %zmm15,%zmm16,%zmm3{%k3}
 18be3d9:	62 f1 7d c9 6f db    	vmovdqa32 %zmm3,%zmm3{%k1}{z}
 18be3df:	62 f1 7d ca 6f eb    	vmovdqa32 %zmm3,%zmm5{%k2}{z}
 18be3e5:	62 d3 55 48 03 f0 0f 	valignd $0xf,%zmm8,%zmm5,%zmm6
 18be3ec:	62 d1 fd 48 7f 5c 88 01 	vmovdqa64 %zmm3,0x40(%r8,%rcx,4)
 18be3f4:	62 d1 fd 48 7f 64 8c ff 	vmovdqa64 %zmm4,-0x40(%r12,%rcx,4)
 18be3fc:	62 f1 fd 48 7f 64 8a ff 	vmovdqa64 %zmm4,-0x40(%rdx,%rcx,4)
 18be404:	c4 c1 7b 92 c9       	kmovd  %r9d,%k1
 18be409:	62 f1 fd 48 7f 6c 88 ff 	vmovdqa64 %zmm5,-0x40(%rax,%rcx,4)
 18be411:	c4 e1 f8 90 d9       	kmovq  %k1,%k3
 18be416:	62 f1 4d 48 fe f5    	vpaddd %zmm5,%zmm6,%zmm6
 18be41c:	c5 d1 ef ed          	vpxor  %xmm5,%xmm5,%xmm5
 18be420:	62 d3 cd 48 03 f8 07 	valignq $0x7,%zmm8,%zmm6,%zmm7
 18be427:	62 f1 45 48 fe f6    	vpaddd %zmm6,%zmm7,%zmm6
 18be42d:	62 d3 cd 48 03 f8 06 	valignq $0x6,%zmm8,%zmm6,%zmm7
 18be434:	62 f1 45 48 fe f6    	vpaddd %zmm6,%zmm7,%zmm6
 18be43a:	62 d3 cd 48 03 f8 04 	valignq $0x4,%zmm8,%zmm6,%zmm7
 18be441:	62 f1 4d 48 fe d2    	vpaddd %zmm2,%zmm6,%zmm2
 18be447:	62 f1 fd 48 6f f0    	vmovdqa64 %zmm0,%zmm6
 18be44d:	62 f1 6d 48 fe d7    	vpaddd %zmm7,%zmm2,%zmm2
 18be453:	62 d1 fe 48 7f 54 8b ff 	vmovdqu64 %zmm2,-0x40(%r11,%rcx,4)
 18be45b:	62 71 fe 48 7f 44 8f ff 	vmovdqu64 %zmm8,-0x40(%rdi,%rcx,4)
 18be463:	62 f1 7d 48 70 d2 ff 	vpshufd $0xff,%zmm2,%zmm2
 18be46a:	62 d1 7e c9 6f 64 8d 00 	vmovdqu32 0x0(%r13,%rcx,4),%zmm4{%k1}{z}
 18be472:	62 d1 7e c9 6f 1c 8a 	vmovdqu32 (%r10,%rcx,4),%zmm3{%k1}{z}
 18be479:	62 f3 ed 48 43 d2 ff 	vshufi64x2 $0xff,%zmm2,%zmm2,%zmm2
 18be480:	62 f3 5d 49 1e d1 01 	vpcmpltud %zmm1,%zmm4,%k2{%k1}
 18be487:	62 f2 7d 4b 90 2c 9e 	vpgatherdd (%rsi,%zmm3,4),%zmm5{%k3}
 18be48e:	62 f1 65 48 fe db    	vpaddd %zmm3,%zmm3,%zmm3
 18be494:	c4 e1 f8 90 d9       	kmovq  %k1,%k3
 18be499:	62 f2 7d 4a 90 34 a6 	vpgatherdd (%rsi,%zmm4,4),%zmm6{%k2}
 18be4a0:	48 8b b4 24 88 00 00 00 	mov    0x88(%rsp),%rsi
 18be4a8:	62 f1 4d 48 fa e5    	vpsubd %zmm5,%zmm6,%zmm4
 18be4ae:	62 d1 5d c9 fe e3    	vpaddd %zmm11,%zmm4,%zmm4{%k1}{z}
 18be4b4:	62 d1 5d 48 fe ec    	vpaddd %zmm12,%zmm4,%zmm5
 18be4ba:	62 d3 55 48 1e d5 01 	vpcmpltud %zmm13,%zmm5,%k2
 18be4c1:	c5 d1 ef ed          	vpxor  %xmm5,%xmm5,%xmm5
 18be4c5:	c5 ec 41 c1          	kandw  %k1,%k2,%k0
 18be4c9:	c5 78 93 c8          	kmovw  %k0,%r9d
 18be4cd:	45 09 f1             	or     %r14d,%r9d
 18be4d0:	4c 8b b4 24 90 00 00 00 	mov    0x90(%rsp),%r14
 18be4d8:	62 d2 7d 4b 90 2c de 	vpgatherdd (%r14,%zmm3,8),%zmm5{%k3}
 18be4df:	62 d1 55 48 db de    	vpandd %zmm14,%zmm5,%zmm3
 18be4e5:	62 d1 65 48 76 da    	vpcmpeqd %zmm10,%zmm3,%k3
 18be4eb:	62 d2 7d 43 64 df    	vpblendmd %zmm15,%zmm16,%zmm3{%k3}
 18be4f1:	62 f1 7d c9 6f db    	vmovdqa32 %zmm3,%zmm3{%k1}{z}
 18be4f7:	62 f1 7d ca 6f eb    	vmovdqa32 %zmm3,%zmm5{%k2}{z}
 18be4fd:	62 d3 55 48 03 f0 0f 	valignd $0xf,%zmm8,%zmm5,%zmm6
 18be504:	62 d1 fd 48 7f 5c 88 02 	vmovdqa64 %zmm3,0x80(%r8,%rcx,4)
 18be50c:	62 d1 fd 48 7f 24 8c 	vmovdqa64 %zmm4,(%r12,%rcx,4)
 18be513:	62 f1 fd 48 7f 24 8a 	vmovdqa64 %zmm4,(%rdx,%rcx,4)
 18be51a:	62 f1 fd 48 7f 2c 88 	vmovdqa64 %zmm5,(%rax,%rcx,4)
 18be521:	62 f1 4d 48 fe f5    	vpaddd %zmm5,%zmm6,%zmm6
 18be527:	62 d3 cd 48 03 f8 07 	valignq $0x7,%zmm8,%zmm6,%zmm7
 18be52e:	62 f1 45 48 fe f6    	vpaddd %zmm6,%zmm7,%zmm6
 18be534:	62 d3 cd 48 03 f8 06 	valignq $0x6,%zmm8,%zmm6,%zmm7
 18be53b:	62 f1 45 48 fe f6    	vpaddd %zmm6,%zmm7,%zmm6
 18be541:	62 d3 cd 48 03 f8 04 	valignq $0x4,%zmm8,%zmm6,%zmm7
 18be548:	62 f1 4d 48 fe f7    	vpaddd %zmm7,%zmm6,%zmm6
 18be54e:	62 f1 4d 48 fe d2    	vpaddd %zmm2,%zmm6,%zmm2
 18be554:	62 d1 fe 48 7f 14 8b 	vmovdqu64 %zmm2,(%r11,%rcx,4)
 18be55b:	62 f1 7d 48 70 d2 ff 	vpshufd $0xff,%zmm2,%zmm2
 18be562:	62 71 fe 48 7f 04 8f 	vmovdqu64 %zmm8,(%rdi,%rcx,4)
 18be569:	48 83 c1 20          	add    $0x20,%rcx
 18be56d:	48 83 c6 fe          	add    $0xfffffffffffffffe,%rsi
 18be571:	62 f3 ed 48 43 d2 ff 	vshufi64x2 $0xff,%zmm2,%zmm2,%zmm2
 18be578:	0f 85 42 fd ff ff    	jne    18be2c0 <tier0_benchmark_run+0xe40>
 18be57e:	62 f2 7d 48 58 35 4c 1f cc fe 	vpbroadcastd -0x133e0b4(%rip),%zmm6        # 5804d4 <tier0_emit_x87.operations+0x8c>
 18be588:	62 f1 fd 48 6f 3d 6e 22 c6 fe 	vmovdqa64 -0x139dd92(%rip),%zmm7        # 520800 <branch_sizing_patterns+0xa70>
 18be592:	62 e2 7d 48 5a 0d 64 77 cb fe 	vbroadcasti32x4 -0x134889c(%rip),%zmm17        # 575d00 <x86_effects_unknown+0x2a0>
 18be59c:	f6 84 24 d8 00 00 00 10 	testb  $0x10,0xd8(%rsp)
 18be5a4:	48 8b 7c 24 30       	mov    0x30(%rsp),%rdi
 18be5a9:	4c 8b 5c 24 58       	mov    0x58(%rsp),%r11
 18be5ae:	4c 8b a4 24 b0 00 00 00 	mov    0xb0(%rsp),%r12
 18be5b6:	4c 8b 84 24 a0 00 00 00 	mov    0xa0(%rsp),%r8
 18be5be:	41 bf 00 00 00 00    	mov    $0x0,%r15d
 18be5c4:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
 18be5c9:	41 bd ff ff 00 00    	mov    $0xffff,%r13d
 18be5cf:	62 51 fd 48 6f d4    	vmovdqa64 %zmm12,%zmm10
 18be5d5:	62 51 fd 48 6f dd    	vmovdqa64 %zmm13,%zmm11
 18be5db:	74 26                	je     18be603 <tier0_benchmark_run+0x1183>
 18be5dd:	e9 67 01 00 00       	jmp    18be749 <tier0_benchmark_run+0x12c9>
 18be5e2:	4c 8b 5c 24 58       	mov    0x58(%rsp),%r11
 18be5e7:	4c 8b 84 24 a0 00 00 00 	mov    0xa0(%rsp),%r8
 18be5ef:	45 31 c9             	xor    %r9d,%r9d
 18be5f2:	c5 e9 ef d2          	vpxor  %xmm2,%xmm2,%xmm2
 18be5f6:	31 c9                	xor    %ecx,%ecx
 18be5f8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
 18be5fd:	41 bd ff ff 00 00    	mov    $0xffff,%r13d
 18be603:	48 89 f8             	mov    %rdi,%rax
 18be606:	48 29 c8             	sub    %rcx,%rax
 18be609:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
 18be60e:	c5 d1 ef ed          	vpxor  %xmm5,%xmm5,%xmm5
 18be612:	48 83 f8 10          	cmp    $0x10,%rax
 18be616:	c4 e2 79 f7 c3       	shlx   %eax,%ebx,%eax
 18be61b:	f7 d0                	not    %eax
 18be61d:	41 0f 43 c5          	cmovae %r13d,%eax
 18be621:	c5 fb 92 c8          	kmovd  %eax,%k1
 18be625:	48 8b 84 24 a8 00 00 00 	mov    0xa8(%rsp),%rax
 18be62d:	62 f1 7e c9 6f 1c 8a 	vmovdqu32 (%rdx,%rcx,4),%zmm3{%k1}{z}
 18be634:	c4 e1 f8 90 d1       	kmovq  %k1,%k2
 18be639:	c4 e1 f8 90 d9       	kmovq  %k1,%k3
 18be63e:	62 71 7e c9 6f 24 88 	vmovdqu32 (%rax,%rcx,4),%zmm12{%k1}{z}
 18be645:	62 f1 65 48 fe e3    	vpaddd %zmm3,%zmm3,%zmm4
 18be64b:	62 d2 7d 4a 90 2c e6 	vpgatherdd (%r14,%zmm4,8),%zmm5{%k2}
 18be652:	62 f3 1d 49 1e d1 01 	vpcmpltud %zmm1,%zmm12,%k2{%k1}
 18be659:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
 18be65d:	62 d2 7d 4b 90 0c 9b 	vpgatherdd (%r11,%zmm3,4),%zmm1{%k3}
 18be664:	62 f1 55 58 db 1d b2 1e cc fe 	vpandd -0x133e14e(%rip){1to16},%zmm5,%zmm3        # 580520 <tier0_emit_x87.operations+0xd8>
 18be66e:	62 92 7d 4a 90 04 a3 	vpgatherdd (%r11,%zmm12,4),%zmm0{%k2}
 18be675:	62 f1 65 58 76 15 a5 1e cc fe 	vpcmpeqd -0x133e15b(%rip){1to16},%zmm3,%k2        # 580524 <tier0_emit_x87.operations+0xdc>
 18be67f:	62 f1 7d 48 fa c1    	vpsubd %zmm1,%zmm0,%zmm0
 18be685:	62 f2 7d 52 64 0d 99 1e cc fe 	vpblendmd -0x133e167(%rip){1to16},%zmm16,%zmm1{%k2}        # 580528 <tier0_emit_x87.operations+0xe0>
 18be68f:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
 18be694:	48 8b b4 24 e8 00 00 00 	mov    0xe8(%rsp),%rsi
 18be69c:	48 8b 94 24 e0 00 00 00 	mov    0xe0(%rsp),%rdx
 18be6a4:	62 f1 7d d9 fe 05 7e 1e cc fe 	vpaddd -0x133e182(%rip){1to16},%zmm0,%zmm0{%k1}{z}        # 58052c <tier0_emit_x87.operations+0xe4>
 18be6ae:	62 f1 7d c9 6f c9    	vmovdqa32 %zmm1,%zmm1{%k1}{z}
 18be6b4:	62 f1 fd 48 7f 0c 88 	vmovdqa64 %zmm1,(%rax,%rcx,4)
 18be6bb:	48 8b 84 24 c0 00 00 00 	mov    0xc0(%rsp),%rax
 18be6c3:	62 f1 fd 48 7f 04 8e 	vmovdqa64 %zmm0,(%rsi,%rcx,4)
 18be6ca:	62 f1 fd 48 7f 04 8a 	vmovdqa64 %zmm0,(%rdx,%rcx,4)
 18be6d1:	62 d1 7d 48 fe c2    	vpaddd %zmm10,%zmm0,%zmm0
 18be6d7:	62 d3 7d 48 1e d3 01 	vpcmpltud %zmm11,%zmm0,%k2
 18be6de:	62 f1 7d ca 6f c1    	vmovdqa32 %zmm1,%zmm0{%k2}{z}
 18be6e4:	62 d3 7d 48 03 c8 0f 	valignd $0xf,%zmm8,%zmm0,%zmm1
 18be6eb:	c5 ec 41 c1          	kandw  %k1,%k2,%k0
 18be6ef:	62 d1 fd 48 7f 04 8c 	vmovdqa64 %zmm0,(%r12,%rcx,4)
 18be6f6:	62 f1 75 48 fe c8    	vpaddd %zmm0,%zmm1,%zmm1
 18be6fc:	62 d3 f5 48 03 d8 07 	valignq $0x7,%zmm8,%zmm1,%zmm3
 18be703:	62 f1 65 48 fe c9    	vpaddd %zmm1,%zmm3,%zmm1
 18be709:	62 d3 f5 48 03 d8 06 	valignq $0x6,%zmm8,%zmm1,%zmm3
 18be710:	62 f1 65 48 fe c9    	vpaddd %zmm1,%zmm3,%zmm1
 18be716:	62 d3 f5 48 03 d8 04 	valignq $0x4,%zmm8,%zmm1,%zmm3
 18be71d:	62 f1 75 48 fe ca    	vpaddd %zmm2,%zmm1,%zmm1
 18be723:	62 f1 75 48 fe cb    	vpaddd %zmm3,%zmm1,%zmm1
 18be729:	62 d1 fe 48 7f 8c 88 04 00 00 00 	vmovdqu64 %zmm1,0x4(%r8,%rcx,4)
 18be734:	62 71 fe 48 7f 84 88 04 00 00 00 	vmovdqu64 %zmm8,0x4(%rax,%rcx,4)
 18be73f:	44 89 c9             	mov    %r9d,%ecx
 18be742:	c5 78 93 c8          	kmovw  %k0,%r9d
 18be746:	41 09 c9             	or     %ecx,%r9d
 18be749:	4c 8b 74 24 78       	mov    0x78(%rsp),%r14
 18be74e:	45 85 c9             	test   %r9d,%r9d
 18be751:	0f 84 08 07 00 00    	je     18bee5f <tier0_benchmark_run+0x19df>
 18be757:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
 18be75c:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
 18be761:	81 e2 c0 ff ff 1f    	and    $0x1fffffc0,%edx
 18be767:	31 f6                	xor    %esi,%esi
 18be769:	48 83 c2 40          	add    $0x40,%rdx
 18be76d:	c5 f8 77             	vzeroupper
 18be770:	e8 bb 5b ea fe       	call   764330 <memset@plt>
 18be775:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
 18be77a:	89 d0                	mov    %edx,%eax
 18be77c:	83 e0 07             	and    $0x7,%eax
 18be77f:	83 fa 08             	cmp    $0x8,%edx
 18be782:	73 61                	jae    18be7e5 <tier0_benchmark_run+0x1365>
 18be784:	62 f2 7d 48 58 05 46 1d cc fe 	vpbroadcastd -0x133e2ba(%rip),%zmm0        # 5804d4 <tier0_emit_x87.operations+0x8c>
 18be78e:	62 f1 fd 48 6f 0d 68 20 c6 fe 	vmovdqa64 -0x139df98(%rip),%zmm1        # 520800 <branch_sizing_patterns+0xa70>
 18be798:	62 e2 7d 48 5a 0d 5e 75 cb fe 	vbroadcasti32x4 -0x1348aa2(%rip),%zmm17        # 575d00 <x86_effects_unknown+0x2a0>
 18be7a2:	62 f2 7d 48 5a 15 74 75 cb fe 	vbroadcasti32x4 -0x1348a8c(%rip),%zmm2        # 575d20 <x86_effects_unknown+0x2c0>
 18be7ac:	62 72 7d 48 5a 3d 5a 75 cb fe 	vbroadcasti32x4 -0x1348aa6(%rip),%zmm15        # 575d10 <x86_effects_unknown+0x2b0>
 18be7b6:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
 18be7bb:	4c 8b 44 24 10       	mov    0x10(%rsp),%r8
 18be7c0:	4c 8b 4c 24 18       	mov    0x18(%rsp),%r9
 18be7c5:	4c 8b 5c 24 60       	mov    0x60(%rsp),%r11
 18be7ca:	4c 8b bc 24 c8 00 00 00 	mov    0xc8(%rsp),%r15
 18be7d2:	31 c9                	xor    %ecx,%ecx
 18be7d4:	c4 41 39 ef c0       	vpxor  %xmm8,%xmm8,%xmm8
 18be7d9:	62 f3 45 48 25 ff ff 	vpternlogd $0xff,%zmm7,%zmm7,%zmm7
 18be7e0:	e9 c3 00 00 00       	jmp    18be8a8 <tier0_benchmark_run+0x1428>
 18be7e5:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
 18be7ea:	4c 8b 44 24 10       	mov    0x10(%rsp),%r8
 18be7ef:	4c 8b 5c 24 60       	mov    0x60(%rsp),%r11
 18be7f4:	4c 8b bc 24 c8 00 00 00 	mov    0xc8(%rsp),%r15
 18be7fc:	83 e2 f8             	and    $0xfffffff8,%edx
 18be7ff:	31 c9                	xor    %ecx,%ecx
 18be801:	66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 18be810:	8b 34 8f             	mov    (%rdi,%rcx,4),%esi
 18be813:	41 c6 04 30 01       	movb   $0x1,(%r8,%rsi,1)
 18be818:	8b 74 8f 04          	mov    0x4(%rdi,%rcx,4),%esi
 18be81c:	41 c6 04 30 01       	movb   $0x1,(%r8,%rsi,1)
 18be821:	8b 74 8f 08          	mov    0x8(%rdi,%rcx,4),%esi
 18be825:	41 c6 04 30 01       	movb   $0x1,(%r8,%rsi,1)
 18be82a:	8b 74 8f 0c          	mov    0xc(%rdi,%rcx,4),%esi
 18be82e:	41 c6 04 30 01       	movb   $0x1,(%r8,%rsi,1)
 18be833:	8b 74 8f 10          	mov    0x10(%rdi,%rcx,4),%esi
 18be837:	41 c6 04 30 01       	movb   $0x1,(%r8,%rsi,1)
 18be83c:	8b 74 8f 14          	mov    0x14(%rdi,%rcx,4),%esi
 18be840:	41 c6 04 30 01       	movb   $0x1,(%r8,%rsi,1)
 18be845:	8b 74 8f 18          	mov    0x18(%rdi,%rcx,4),%esi
 18be849:	41 c6 04 30 01       	movb   $0x1,(%r8,%rsi,1)
 18be84e:	8b 74 8f 1c          	mov    0x1c(%rdi,%rcx,4),%esi
 18be852:	48 83 c1 08          	add    $0x8,%rcx
 18be856:	41 c6 04 30 01       	movb   $0x1,(%r8,%rsi,1)
 18be85b:	48 39 ca             	cmp    %rcx,%rdx
 18be85e:	75 b0                	jne    18be810 <tier0_benchmark_run+0x1390>
 18be860:	62 f2 7d 48 58 05 6a 1c cc fe 	vpbroadcastd -0x133e396(%rip),%zmm0        # 5804d4 <tier0_emit_x87.operations+0x8c>
 18be86a:	62 f1 fd 48 6f 0d 8c 1f c6 fe 	vmovdqa64 -0x139e074(%rip),%zmm1        # 520800 <branch_sizing_patterns+0xa70>
 18be874:	62 e2 7d 48 5a 0d 82 74 cb fe 	vbroadcasti32x4 -0x1348b7e(%rip),%zmm17        # 575d00 <x86_effects_unknown+0x2a0>
 18be87e:	62 f2 7d 48 5a 15 98 74 cb fe 	vbroadcasti32x4 -0x1348b68(%rip),%zmm2        # 575d20 <x86_effects_unknown+0x2c0>
 18be888:	62 72 7d 48 5a 3d 7e 74 cb fe 	vbroadcasti32x4 -0x1348b82(%rip),%zmm15        # 575d10 <x86_effects_unknown+0x2b0>
 18be892:	4c 8b 4c 24 18       	mov    0x18(%rsp),%r9
 18be897:	62 f3 45 48 25 ff ff 	vpternlogd $0xff,%zmm7,%zmm7,%zmm7
 18be89e:	c4 41 39 ef c0       	vpxor  %xmm8,%xmm8,%xmm8
 18be8a3:	48 85 c0             	test   %rax,%rax
 18be8a6:	74 18                	je     18be8c0 <tier0_benchmark_run+0x1440>
 18be8a8:	48 8d 0c 8f          	lea    (%rdi,%rcx,4),%rcx
 18be8ac:	31 d2                	xor    %edx,%edx
 18be8ae:	66 90                	xchg   %ax,%ax
 18be8b0:	8b 34 91             	mov    (%rcx,%rdx,4),%esi
 18be8b3:	48 ff c2             	inc    %rdx
 18be8b6:	41 c6 04 30 01       	movb   $0x1,(%r8,%rsi,1)
 18be8bb:	48 39 d0             	cmp    %rdx,%rax
 18be8be:	75 f0                	jne    18be8b0 <tier0_benchmark_run+0x1430>
 18be8c0:	62 72 7d 48 58 15 66 1c cc fe 	vpbroadcastd -0x133e39a(%rip),%zmm10        # 580530 <tier0_emit_x87.operations+0xe8>
 18be8ca:	62 72 7d 48 58 1d 60 1c cc fe 	vpbroadcastd -0x133e3a0(%rip),%zmm11        # 580534 <tier0_emit_x87.operations+0xec>
 18be8d4:	62 f1 fd 48 6f 25 a2 20 c6 fe 	vmovdqa64 -0x139df5e(%rip),%zmm4        # 520980 <branch_sizing_patterns+0xbf0>
 18be8de:	62 f1 fd 48 6f 2d d8 20 c6 fe 	vmovdqa64 -0x139df28(%rip),%zmm5        # 5209c0 <branch_sizing_patterns+0xc30>
 18be8e8:	62 f2 7d 48 58 35 46 1c cc fe 	vpbroadcastd -0x133e3ba(%rip),%zmm6        # 580538 <tier0_emit_x87.operations+0xf0>
 18be8f2:	44 89 f8             	mov    %r15d,%eax
 18be8f5:	83 e0 03             	and    $0x3,%eax
 18be8f8:	62 71 fd 48 6f c8    	vmovdqa64 %zmm0,%zmm9
 18be8fe:	62 71 fd 48 6f e9    	vmovdqa64 %zmm1,%zmm13
 18be904:	41 81 f9 c0 00 00 00 	cmp    $0xc0,%r9d
 18be90b:	73 0f                	jae    18be91c <tier0_benchmark_run+0x149c>
 18be90d:	31 ff                	xor    %edi,%edi
 18be90f:	31 c9                	xor    %ecx,%ecx
 18be911:	62 71 fd 48 6f e2    	vmovdqa64 %zmm2,%zmm12
 18be917:	e9 54 01 00 00       	jmp    18bea70 <tier0_benchmark_run+0x15f0>
 18be91c:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
 18be921:	c1 e1 06             	shl    $0x6,%ecx
 18be924:	41 81 e7 fc ff ff 00 	and    $0xfffffc,%r15d
 18be92b:	49 8d 90 c0 00 00 00 	lea    0xc0(%r8),%rdx
 18be932:	31 ff                	xor    %edi,%edi
 18be934:	62 71 fd 48 6f e2    	vmovdqa64 %zmm2,%zmm12
 18be93a:	49 8d 74 08 78       	lea    0x78(%r8,%rcx,1),%rsi
 18be93f:	31 c9                	xor    %ecx,%ecx
 18be941:	66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 18be950:	62 f1 fd 48 6f 42 fd 	vmovdqa64 -0xc0(%rdx),%zmm0
 18be957:	48 83 c1 04          	add    $0x4,%rcx
 18be95b:	62 f2 7d 48 26 c0    	vptestmb %zmm0,%zmm0,%k0
 18be961:	c4 61 fb 93 c0       	kmovq  %k0,%r8
 18be966:	f3 45 0f b8 d0       	popcnt %r8d,%r10d
 18be96b:	45 89 c1             	mov    %r8d,%r9d
 18be96e:	49 01 fa             	add    %rdi,%r10
 18be971:	48 c1 e7 20          	shl    $0x20,%rdi
 18be975:	4d 89 d3             	mov    %r10,%r11
 18be978:	4d 0f a4 c3 20       	shld   $0x20,%r8,%r11
 18be97d:	4c 09 cf             	or     %r9,%rdi
 18be980:	49 c1 e8 20          	shr    $0x20,%r8
 18be984:	48 89 7e c8          	mov    %rdi,-0x38(%rsi)
 18be988:	f3 41 0f b8 f8       	popcnt %r8d,%edi
 18be98d:	4c 89 5e d0          	mov    %r11,-0x30(%rsi)
 18be991:	4c 01 d7             	add    %r10,%rdi
 18be994:	62 f1 fd 48 6f 42 fe 	vmovdqa64 -0x80(%rdx),%zmm0
 18be99b:	62 f2 7d 48 26 c0    	vptestmb %zmm0,%zmm0,%k0
 18be9a1:	c4 61 fb 93 c0       	kmovq  %k0,%r8
 18be9a6:	f3 45 0f b8 d0       	popcnt %r8d,%r10d
 18be9ab:	45 89 c1             	mov    %r8d,%r9d
 18be9ae:	49 01 fa             	add    %rdi,%r10
 18be9b1:	48 c1 e7 20          	shl    $0x20,%rdi
 18be9b5:	4d 89 d3             	mov    %r10,%r11
 18be9b8:	4d 0f a4 c3 20       	shld   $0x20,%r8,%r11
 18be9bd:	4c 09 cf             	or     %r9,%rdi
 18be9c0:	49 c1 e8 20          	shr    $0x20,%r8
 18be9c4:	48 89 7e d8          	mov    %rdi,-0x28(%rsi)
 18be9c8:	f3 41 0f b8 f8       	popcnt %r8d,%edi
 18be9cd:	4c 89 5e e0          	mov    %r11,-0x20(%rsi)
 18be9d1:	4c 01 d7             	add    %r10,%rdi
 18be9d4:	62 f1 fd 48 6f 42 ff 	vmovdqa64 -0x40(%rdx),%zmm0
 18be9db:	62 f2 7d 48 26 c0    	vptestmb %zmm0,%zmm0,%k0
 18be9e1:	c4 61 fb 93 c0       	kmovq  %k0,%r8
 18be9e6:	f3 45 0f b8 d0       	popcnt %r8d,%r10d
 18be9eb:	45 89 c1             	mov    %r8d,%r9d
 18be9ee:	49 01 fa             	add    %rdi,%r10
 18be9f1:	48 c1 e7 20          	shl    $0x20,%rdi
 18be9f5:	4d 89 d3             	mov    %r10,%r11
 18be9f8:	4d 0f a4 c3 20       	shld   $0x20,%r8,%r11
 18be9fd:	4c 09 cf             	or     %r9,%rdi
 18bea00:	49 c1 e8 20          	shr    $0x20,%r8
 18bea04:	48 89 7e e8          	mov    %rdi,-0x18(%rsi)
 18bea08:	f3 41 0f b8 f8       	popcnt %r8d,%edi
 18bea0d:	4c 89 5e f0          	mov    %r11,-0x10(%rsi)
 18bea11:	4c 01 d7             	add    %r10,%rdi
 18bea14:	62 f1 fd 48 6f 02    	vmovdqa64 (%rdx),%zmm0
 18bea1a:	48 81 c2 00 01 00 00 	add    $0x100,%rdx
 18bea21:	62 f2 7d 48 26 c0    	vptestmb %zmm0,%zmm0,%k0
 18bea27:	c4 61 fb 93 c0       	kmovq  %k0,%r8
 18bea2c:	f3 45 0f b8 d0       	popcnt %r8d,%r10d
 18bea31:	45 89 c1             	mov    %r8d,%r9d
 18bea34:	49 01 fa             	add    %rdi,%r10
 18bea37:	48 c1 e7 20          	shl    $0x20,%rdi
 18bea3b:	4c 09 cf             	or     %r9,%rdi
 18bea3e:	48 89 7e f8          	mov    %rdi,-0x8(%rsi)
 18bea42:	4c 89 d7             	mov    %r10,%rdi
 18bea45:	4c 0f a4 c7 20       	shld   $0x20,%r8,%rdi
 18bea4a:	49 c1 e8 20          	shr    $0x20,%r8
 18bea4e:	48 89 3e             	mov    %rdi,(%rsi)
 18bea51:	f3 41 0f b8 f8       	popcnt %r8d,%edi
 18bea56:	48 83 c6 40          	add    $0x40,%rsi
 18bea5a:	4c 01 d7             	add    %r10,%rdi
 18bea5d:	49 39 cf             	cmp    %rcx,%r15
 18bea60:	0f 85 ea fe ff ff    	jne    18be950 <tier0_benchmark_run+0x14d0>
 18bea66:	4c 8b 5c 24 60       	mov    0x60(%rsp),%r11
 18bea6b:	48 85 c0             	test   %rax,%rax
 18bea6e:	74 7a                	je     18beaea <tier0_benchmark_run+0x166a>
 18bea70:	4c 8b 44 24 10       	mov    0x10(%rsp),%r8
 18bea75:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
 18bea7a:	48 89 ce             	mov    %rcx,%rsi
 18bea7d:	c1 e2 06             	shl    $0x6,%edx
 18bea80:	48 c1 e6 04          	shl    $0x4,%rsi
 18bea84:	48 c1 e1 06          	shl    $0x6,%rcx
 18bea88:	c1 e0 04             	shl    $0x4,%eax
 18bea8b:	48 01 d6             	add    %rdx,%rsi
 18bea8e:	49 8d 54 30 48       	lea    0x48(%r8,%rsi,1),%rdx
 18bea93:	4c 01 c1             	add    %r8,%rcx
 18bea96:	31 f6                	xor    %esi,%esi
 18bea98:	0f 1f 84 00 00 00 00 00 	nopl   0x0(%rax,%rax,1)
 18beaa0:	62 f1 fd 48 6f 04 b1 	vmovdqa64 (%rcx,%rsi,4),%zmm0
 18beaa7:	62 f2 7d 48 26 c0    	vptestmb %zmm0,%zmm0,%k0
 18beaad:	c4 61 fb 93 c0       	kmovq  %k0,%r8
 18beab2:	f3 45 0f b8 d0       	popcnt %r8d,%r10d
 18beab7:	45 89 c1             	mov    %r8d,%r9d
 18beaba:	49 01 fa             	add    %rdi,%r10
 18beabd:	48 c1 e7 20          	shl    $0x20,%rdi
 18beac1:	4c 09 cf             	or     %r9,%rdi
 18beac4:	48 89 7c 32 f8       	mov    %rdi,-0x8(%rdx,%rsi,1)
 18beac9:	4c 89 d7             	mov    %r10,%rdi
 18beacc:	4c 0f a4 c7 20       	shld   $0x20,%r8,%rdi
 18bead1:	49 c1 e8 20          	shr    $0x20,%r8
 18bead5:	48 89 3c 32          	mov    %rdi,(%rdx,%rsi,1)
 18bead9:	f3 41 0f b8 f8       	popcnt %r8d,%edi
 18beade:	48 83 c6 10          	add    $0x10,%rsi
 18beae2:	4c 01 d7             	add    %r10,%rdi
 18beae5:	48 39 f0             	cmp    %rsi,%rax
 18beae8:	75 b6                	jne    18beaa0 <tier0_benchmark_run+0x1620>
 18beaea:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
 18beaef:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
 18beaf4:	c1 e1 06             	shl    $0x6,%ecx
 18beaf7:	4c 8b 4c 24 10       	mov    0x10(%rsp),%r9
 18beafc:	48 8b 7c 24 30       	mov    0x30(%rsp),%rdi
 18beb01:	4c 8b 94 24 a8 00 00 00 	mov    0xa8(%rsp),%r10
 18beb09:	31 f6                	xor    %esi,%esi
 18beb0b:	48 01 c0             	add    %rax,%rax
 18beb0e:	48 89 fa             	mov    %rdi,%rdx
 18beb11:	48 01 c1             	add    %rax,%rcx
 18beb14:	48 03 4c 24 40       	add    0x40(%rsp),%rcx
 18beb19:	49 8d 4c 09 40       	lea    0x40(%r9,%rcx,1),%rcx
 18beb1e:	66 90                	xchg   %ax,%ax
 18beb20:	41 89 d0             	mov    %edx,%r8d
 18beb23:	48 83 ea 10          	sub    $0x10,%rdx
 18beb27:	c5 e9 ef d2          	vpxor  %xmm2,%xmm2,%xmm2
 18beb2b:	c5 e1 ef db          	vpxor  %xmm3,%xmm3,%xmm3
 18beb2f:	c4 62 39 f7 c3       	shlx   %r8d,%ebx,%r8d
 18beb34:	41 f7 d0             	not    %r8d
 18beb37:	45 0f 43 c5          	cmovae %r13d,%r8d
 18beb3b:	c4 c1 7b 92 c8       	kmovd  %r8d,%k1
 18beb40:	41 c1 e8 08          	shr    $0x8,%r8d
 18beb44:	62 d1 7e c9 6f 04 b2 	vmovdqu32 (%r10,%rsi,4),%zmm0{%k1}{z}
 18beb4b:	62 f1 75 48 72 d0 05 	vpsrld $0x5,%zmm0,%zmm1
 18beb52:	62 f1 7d 48 db c6    	vpandd %zmm6,%zmm0,%zmm0
 18beb58:	62 d2 fd 49 90 14 ce 	vpgatherdq (%r14,%ymm1,8),%zmm2{%k1}
 18beb5f:	62 f3 fd 48 3b c9 01 	vextracti64x4 $0x1,%zmm1,%ymm1
 18beb66:	c4 c1 7b 92 c8       	kmovd  %r8d,%k1
 18beb6b:	62 f2 45 48 47 c0    	vpsllvd %zmm0,%zmm7,%zmm0
 18beb71:	62 d2 fd 49 90 1c ce 	vpgatherdq (%r14,%ymm1,8),%zmm3{%k1}
 18beb78:	62 f1 fd 48 6f ca    	vmovdqa64 %zmm2,%zmm1
 18beb7e:	62 f2 5d 48 7e cb    	vpermt2d %zmm3,%zmm4,%zmm1
 18beb84:	62 f2 55 48 7e d3    	vpermt2d %zmm3,%zmm5,%zmm2
 18beb8a:	62 f1 7d 48 df c1    	vpandnd %zmm1,%zmm0,%zmm0
 18beb90:	62 f2 7d 48 55 c0    	vpopcntd %zmm0,%zmm0
 18beb96:	62 f1 7d 48 fe c2    	vpaddd %zmm2,%zmm0,%zmm0
 18beb9c:	62 f1 fd 48 7f 04 b1 	vmovdqa64 %zmm0,(%rcx,%rsi,4)
 18beba3:	48 83 c6 10          	add    $0x10,%rsi
 18beba7:	48 39 fe             	cmp    %rdi,%rsi
 18bebaa:	0f 82 70 ff ff ff    	jb     18beb20 <tier0_benchmark_run+0x16a0>
 18bebb0:	4c 8b 44 24 70       	mov    0x70(%rsp),%r8
 18bebb5:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
 18bebba:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
 18bebbf:	c1 e1 06             	shl    $0x6,%ecx
 18bebc2:	62 d1 fd 48 6f f1    	vmovdqa64 %zmm9,%zmm6
 18bebc8:	45 31 f6             	xor    %r14d,%r14d
 18bebcb:	62 d1 fd 48 6f fd    	vmovdqa64 %zmm13,%zmm7
 18bebd1:	62 51 fd 48 6f cf    	vmovdqa64 %zmm15,%zmm9
 18bebd7:	48 01 c8             	add    %rcx,%rax
 18bebda:	4b 8d 14 40          	lea    (%r8,%r8,2),%rdx
 18bebde:	49 01 c8             	add    %rcx,%r8
 18bebe1:	48 01 f0             	add    %rsi,%rax
 18bebe4:	49 01 f0             	add    %rsi,%r8
 18bebe7:	49 8d 5c 01 40       	lea    0x40(%r9,%rax,1),%rbx
 18bebec:	b8 01 00 00 00       	mov    $0x1,%eax
 18bebf1:	48 01 ca             	add    %rcx,%rdx
 18bebf4:	4f 8d 6c 01 40       	lea    0x40(%r9,%r8,1),%r13
 18bebf9:	48 01 f2             	add    %rsi,%rdx
 18bebfc:	4d 8d 7c 11 40       	lea    0x40(%r9,%rdx,1),%r15
 18bec01:	48 8b 94 24 98 00 00 00 	mov    0x98(%rsp),%rdx
 18bec09:	48 01 ca             	add    %rcx,%rdx
 18bec0c:	31 c9                	xor    %ecx,%ecx
 18bec0e:	48 01 f2             	add    %rsi,%rdx
 18bec11:	4d 8d 64 11 40       	lea    0x40(%r9,%rdx,1),%r12
 18bec16:	66 2e 0f 1f 84 00 00 00 00 00 	cs nopw 0x0(%rax,%rax,1)
 18bec20:	83 f8 04             	cmp    $0x4,%eax
 18bec23:	89 84 24 90 00 00 00 	mov    %eax,0x90(%rsp)
 18bec2a:	0f 92 c0             	setb   %al
 18bec2d:	08 c8                	or     %cl,%al
 18bec2f:	a8 01                	test   $0x1,%al
 18bec31:	74 1d                	je     18bec50 <tier0_benchmark_run+0x17d0>
 18bec33:	44 89 f0             	mov    %r14d,%eax
 18bec36:	48 8b 84 c4 a0 01 00 00 	mov    0x1a0(%rsp,%rax,8),%rax
 18bec3e:	41 83 f6 01          	xor    $0x1,%r14d
 18bec42:	e9 f9 00 00 00       	jmp    18bed40 <tier0_benchmark_run+0x18c0>
 18bec47:	66 0f 1f 84 00 00 00 00 00 	nopw   0x0(%rax,%rax,1)
 18bec50:	48 8d b4 24 68 01 00 00 	lea    0x168(%rsp),%rsi
 18bec58:	44 89 f2             	mov    %r14d,%edx
 18bec5b:	c5 f8 77             	vzeroupper
 18bec5e:	e8 5d d0 04 00       	call   190bcc0 <branch_sizing_worklist>
 18bec63:	44 89 f0             	mov    %r14d,%eax
 18bec66:	83 f0 01             	xor    $0x1,%eax
 18bec69:	48 8b 7c 24 30       	mov    0x30(%rsp),%rdi
 18bec6e:	c4 41 39 ef c0       	vpxor  %xmm8,%xmm8,%xmm8
 18bec73:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 18bec77:	31 c9                	xor    %ecx,%ecx
 18bec79:	48 8b 84 c4 a0 01 00 00 	mov    0x1a0(%rsp,%rax,8),%rax
 18bec81:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
 18bec87:	66 0f 1f 84 00 00 00 00 00 	nopw   0x0(%rax,%rax,1)
 18bec90:	62 d1 fd 48 6f 0c 8f 	vmovdqa64 (%r15,%rcx,4),%zmm1
 18bec97:	62 d3 75 48 03 d0 0f 	valignd $0xf,%zmm8,%zmm1,%zmm2
 18bec9e:	62 f1 6d 48 fe c9    	vpaddd %zmm1,%zmm2,%zmm1
 18beca4:	62 d3 f5 48 03 d0 07 	valignq $0x7,%zmm8,%zmm1,%zmm2
 18becab:	62 f1 6d 48 fe c9    	vpaddd %zmm1,%zmm2,%zmm1
 18becb1:	62 d3 f5 48 03 d0 06 	valignq $0x6,%zmm8,%zmm1,%zmm2
 18becb8:	62 f1 6d 48 fe c9    	vpaddd %zmm1,%zmm2,%zmm1
 18becbe:	62 d3 f5 48 03 d0 04 	valignq $0x4,%zmm8,%zmm1,%zmm2
 18becc5:	62 f1 75 48 fe c0    	vpaddd %zmm0,%zmm1,%zmm0
 18beccb:	62 f1 7d 48 fe c2    	vpaddd %zmm2,%zmm0,%zmm0
 18becd1:	62 f1 fe 48 7f 84 88 04 00 00 00 	vmovdqu64 %zmm0,0x4(%rax,%rcx,4)
 18becdc:	62 f1 7d 48 70 c0 ff 	vpshufd $0xff,%zmm0,%zmm0
 18bece3:	48 83 c1 10          	add    $0x10,%rcx
 18bece7:	62 f3 fd 48 43 c0 ff 	vshufi64x2 $0xff,%zmm0,%zmm0,%zmm0
 18becee:	48 39 f9             	cmp    %rdi,%rcx
 18becf1:	72 9d                	jb     18bec90 <tier0_benchmark_run+0x1810>
 18becf3:	62 f2 7d 48 58 35 d7 17 cc fe 	vpbroadcastd -0x133e829(%rip),%zmm6        # 5804d4 <tier0_emit_x87.operations+0x8c>
 18becfd:	62 f1 fd 48 6f 3d f9 1a c6 fe 	vmovdqa64 -0x139e507(%rip),%zmm7        # 520800 <branch_sizing_patterns+0xa70>
 18bed07:	62 e2 7d 48 5a 0d ef 6f cb fe 	vbroadcasti32x4 -0x1349011(%rip),%zmm17        # 575d00 <x86_effects_unknown+0x2a0>
 18bed11:	62 72 7d 48 5a 25 05 70 cb fe 	vbroadcasti32x4 -0x1348ffb(%rip),%zmm12        # 575d20 <x86_effects_unknown+0x2c0>
 18bed1b:	62 72 7d 48 5a 0d eb 6f cb fe 	vbroadcasti32x4 -0x1349015(%rip),%zmm9        # 575d10 <x86_effects_unknown+0x2b0>
 18bed25:	62 72 7d 48 58 15 01 18 cc fe 	vpbroadcastd -0x133e7ff(%rip),%zmm10        # 580530 <tier0_emit_x87.operations+0xe8>
 18bed2f:	62 72 7d 48 58 1d fb 17 cc fe 	vpbroadcastd -0x133e805(%rip),%zmm11        # 580534 <tier0_emit_x87.operations+0xec>
 18bed39:	4c 8b 5c 24 60       	mov    0x60(%rsp),%r11
 18bed3e:	b1 01                	mov    $0x1,%cl
 18bed40:	44 89 f2             	mov    %r14d,%edx
 18bed43:	4c 8b 84 d4 a0 01 00 00 	mov    0x1a0(%rsp,%rdx,8),%r8
 18bed4b:	45 89 f2             	mov    %r14d,%r10d
 18bed4e:	31 d2                	xor    %edx,%edx
 18bed50:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 18bed54:	31 f6                	xor    %esi,%esi
 18bed56:	41 c7 00 00 00 00 00 	movl   $0x0,(%r8)
 18bed5d:	0f 1f 00             	nopl   (%rax)
 18bed60:	62 f1 fd 48 6f 0c 93 	vmovdqa64 (%rbx,%rdx,4),%zmm1
 18bed67:	c5 fc 46 c8          	kxnorw %k0,%k0,%k1
 18bed6b:	c5 e1 ef db          	vpxor  %xmm3,%xmm3,%xmm3
 18bed6f:	62 d1 fd 48 6f 14 97 	vmovdqa64 (%r15,%rdx,4),%zmm2
 18bed76:	4d 89 c1             	mov    %r8,%r9
 18bed79:	62 f2 7d 49 90 1c 88 	vpgatherdd (%rax,%zmm1,4),%zmm3{%k1}
 18bed80:	62 f1 65 48 fa 8c 90 04 00 00 00 	vpsubd 0x4(%rax,%rdx,4),%zmm3,%zmm1
 18bed8b:	62 f2 6d 48 27 c2    	vptestmd %zmm2,%zmm2,%k0
 18bed91:	62 d1 75 48 fe 4c 95 00 	vpaddd 0x0(%r13,%rdx,4),%zmm1,%zmm1
 18bed99:	62 d1 75 48 fe da    	vpaddd %zmm10,%zmm1,%zmm3
 18bed9f:	62 d3 65 48 1e cb 01 	vpcmpltud %zmm11,%zmm3,%k1
 18beda6:	c5 fc 45 c9          	korw   %k1,%k0,%k1
 18bedaa:	62 d1 7d c9 6f 1c 93 	vmovdqa32 (%r11,%rdx,4),%zmm3{%k1}{z}
 18bedb1:	62 d3 65 48 03 e0 0f 	valignd $0xf,%zmm8,%zmm3,%zmm4
 18bedb8:	62 f3 65 48 1f c2 04 	vpcmpneqd %zmm2,%zmm3,%k0
 18bedbf:	62 d1 fd 48 7f 1c 97 	vmovdqa64 %zmm3,(%r15,%rdx,4)
 18bedc6:	62 d1 fd 48 7f 0c 94 	vmovdqa64 %zmm1,(%r12,%rdx,4)
 18bedcd:	c5 78 93 c0          	kmovw  %k0,%r8d
 18bedd1:	62 f1 5d 48 fe e3    	vpaddd %zmm3,%zmm4,%zmm4
 18bedd7:	44 09 c6             	or     %r8d,%esi
 18bedda:	4d 89 c8             	mov    %r9,%r8
 18beddd:	62 d3 dd 48 03 e8 07 	valignq $0x7,%zmm8,%zmm4,%zmm5
 18bede4:	62 f1 55 48 fe e4    	vpaddd %zmm4,%zmm5,%zmm4
 18bedea:	62 d3 dd 48 03 e8 06 	valignq $0x6,%zmm8,%zmm4,%zmm5
 18bedf1:	62 f1 55 48 fe e4    	vpaddd %zmm4,%zmm5,%zmm4
 18bedf7:	62 d3 dd 48 03 e8 04 	valignq $0x4,%zmm8,%zmm4,%zmm5
 18bedfe:	62 f1 5d 48 fe c0    	vpaddd %zmm0,%zmm4,%zmm0
 18bee04:	62 f1 7d 48 fe c5    	vpaddd %zmm5,%zmm0,%zmm0
 18bee0a:	62 d1 fe 48 7f 84 91 04 00 00 00 	vmovdqu64 %zmm0,0x4(%r9,%rdx,4)
 18bee15:	62 f1 7d 48 70 c0 ff 	vpshufd $0xff,%zmm0,%zmm0
 18bee1c:	48 83 c2 10          	add    $0x10,%rdx
 18bee20:	62 f3 fd 48 43 c0 ff 	vshufi64x2 $0xff,%zmm0,%zmm0,%zmm0
 18bee27:	48 39 fa             	cmp    %rdi,%rdx
 18bee2a:	0f 82 30 ff ff ff    	jb     18bed60 <tier0_benchmark_run+0x18e0>
 18bee30:	8b 84 24 90 00 00 00 	mov    0x90(%rsp),%eax
 18bee37:	45 89 d6             	mov    %r10d,%r14d
 18bee3a:	ff c0                	inc    %eax
 18bee3c:	85 f6                	test   %esi,%esi
 18bee3e:	0f 85 dc fd ff ff    	jne    18bec20 <tier0_benchmark_run+0x17a0>
 18bee44:	4c 8b 74 24 78       	mov    0x78(%rsp),%r14
 18bee49:	4c 8b a4 24 b0 00 00 00 	mov    0xb0(%rsp),%r12
 18bee51:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
 18bee56:	41 bd ff ff 00 00    	mov    $0xffff,%r13d
 18bee5c:	45 31 ff             	xor    %r15d,%r15d
 18bee5f:	62 f1 fd 48 6f 15 97 1b c6 fe 	vmovdqa64 -0x139e469(%rip),%zmm2        # 520a00 <branch_sizing_patterns+0xc70>
 18bee69:	31 c0                	xor    %eax,%eax
 18bee6b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
 18bee70:	62 d1 fd 48 6f 04 84 	vmovdqa64 (%r12,%rax,4),%zmm0
 18bee77:	48 89 c1             	mov    %rax,%rcx
 18bee7a:	62 f2 7d 48 27 c0    	vptestmd %zmm0,%zmm0,%k0
 18bee80:	c5 fb 93 c0          	kmovd  %k0,%eax
 18bee84:	0d 00 00 01 00       	or     $0x10000,%eax
 18bee89:	f3 0f bc c0          	tzcnt  %eax,%eax
 18bee8d:	48 01 c8             	add    %rcx,%rax
 18bee90:	c5 f8 98 c0          	kortestw %k0,%k0
 18bee94:	75 05                	jne    18bee9b <tier0_benchmark_run+0x1a1b>
 18bee96:	48 39 f8             	cmp    %rdi,%rax
 18bee99:	72 d5                	jb     18bee70 <tier0_benchmark_run+0x19f0>
 18bee9b:	4c 8b 5c 24 18       	mov    0x18(%rsp),%r11
 18beea0:	48 39 f8             	cmp    %rdi,%rax
 18beea3:	0f 83 a6 00 00 00    	jae    18bef4f <tier0_benchmark_run+0x1acf>
 18beea9:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
 18beeae:	8b 04 81             	mov    (%rcx,%rax,4),%eax
 18beeb1:	83 e0 e0             	and    $0xffffffe0,%eax
 18beeb4:	41 39 c3             	cmp    %eax,%r11d
 18beeb7:	0f 86 92 00 00 00    	jbe    18bef4f <tier0_benchmark_run+0x1acf>
 18beebd:	4c 89 d9             	mov    %r11,%rcx
 18beec0:	48 29 c1             	sub    %rax,%rcx
 18beec3:	4d 89 c4             	mov    %r8,%r12
 18beec6:	66 2e 0f 1f 84 00 00 00 00 00 	cs nopw 0x0(%rax,%rax,1)
 18beed0:	89 ca                	mov    %ecx,%edx
 18beed2:	48 83 e9 10          	sub    $0x10,%rcx
 18beed6:	48 89 c6             	mov    %rax,%rsi
 18beed9:	89 c7                	mov    %eax,%edi
 18beedb:	41 89 c0             	mov    %eax,%r8d
 18beede:	c4 e2 69 f7 d3       	shlx   %edx,%ebx,%edx
 18beee3:	f7 d2                	not    %edx
 18beee5:	41 0f 43 d5          	cmovae %r13d,%edx
 18beee9:	48 c1 ee 05          	shr    $0x5,%rsi
 18beeed:	40 80 e7 10          	and    $0x10,%dil
 18beef1:	41 83 e0 10          	and    $0x10,%r8d
 18beef5:	49 8b 34 f6          	mov    (%r14,%rsi,8),%rsi
 18beef9:	c5 fb 92 ca          	kmovd  %edx,%k1
 18beefd:	c4 e2 c3 f7 fe       	shrx   %rdi,%rsi,%rdi
 18bef02:	c4 62 38 f5 c6       	bzhi   %r8d,%esi,%r8d
 18bef07:	48 c1 ee 20          	shr    $0x20,%rsi
 18bef0b:	62 f2 7d 48 7c c7    	vpbroadcastd %edi,%zmm0
 18bef11:	48 8b 7c 24 58       	mov    0x58(%rsp),%rdi
 18bef16:	49 8d 34 b4          	lea    (%r12,%rsi,4),%rsi
 18bef1a:	f3 45 0f b8 c0       	popcnt %r8d,%r8d
 18bef1f:	62 f1 7d 48 db c2    	vpandd %zmm2,%zmm0,%zmm0
 18bef25:	62 f2 7d 48 55 c0    	vpopcntd %zmm0,%zmm0
 18bef2b:	62 b2 7d 48 36 04 86 	vpermd (%rsi,%r8,4),%zmm0,%zmm0
 18bef32:	62 f1 7e c9 6f 0c 87 	vmovdqu32 (%rdi,%rax,4),%zmm1{%k1}{z}
 18bef39:	62 f1 75 48 fe c0    	vpaddd %zmm0,%zmm1,%zmm0
 18bef3f:	62 f1 7e 49 7f 04 87 	vmovdqu32 %zmm0,(%rdi,%rax,4){%k1}
 18bef46:	48 83 c0 10          	add    $0x10,%rax
 18bef4a:	4c 39 d8             	cmp    %r11,%rax
 18bef4d:	72 81                	jb     18beed0 <tier0_benchmark_run+0x1a50>
 18bef4f:	4c 8b 6c 24 30       	mov    0x30(%rsp),%r13
 18bef54:	44 89 e8             	mov    %r13d,%eax
 18bef57:	83 e0 07             	and    $0x7,%eax
 18bef5a:	41 83 fd 08          	cmp    $0x8,%r13d
 18bef5e:	73 1b                	jae    18bef7b <tier0_benchmark_run+0x1afb>
 18bef60:	4c 8b 74 24 48       	mov    0x48(%rsp),%r14
 18bef65:	48 8b 5c 24 50       	mov    0x50(%rsp),%rbx
 18bef6a:	4c 8b 4c 24 10       	mov    0x10(%rsp),%r9
 18bef6f:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
 18bef74:	31 c9                	xor    %ecx,%ecx
 18bef76:	e9 7d 01 00 00       	jmp    18bf0f8 <tier0_benchmark_run+0x1c78>
 18bef7b:	48 8b 94 24 b8 00 00 00 	mov    0xb8(%rsp),%rdx
 18bef83:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
 18bef88:	c1 e1 06             	shl    $0x6,%ecx
 18bef8b:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
 18bef90:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
 18bef95:	4c 8b 74 24 48       	mov    0x48(%rsp),%r14
 18bef9a:	48 8b 5c 24 50       	mov    0x50(%rsp),%rbx
 18bef9f:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
 18befa4:	41 83 e5 f8          	and    $0xfffffff8,%r13d
 18befa8:	48 01 ca             	add    %rcx,%rdx
 18befab:	48 03 8c 24 98 00 00 00 	add    0x98(%rsp),%rcx
 18befb3:	48 01 f2             	add    %rsi,%rdx
 18befb6:	48 8d 54 17 5c       	lea    0x5c(%rdi,%rdx,1),%rdx
 18befbb:	48 01 f1             	add    %rsi,%rcx
 18befbe:	48 8d 74 0f 5c       	lea    0x5c(%rdi,%rcx,1),%rsi
 18befc3:	31 c9                	xor    %ecx,%ecx
 18befc5:	66 66 2e 0f 1f 84 00 00 00 00 00 	data16 cs nopw 0x0(%rax,%rax,1)
 18befd0:	41 8b 3c 8a          	mov    (%r10,%rcx,4),%edi
 18befd4:	44 8b 44 8a e4       	mov    -0x1c(%rdx,%rcx,4),%r8d
 18befd9:	44 8b 4c 8e e4       	mov    -0x1c(%rsi,%rcx,4),%r9d
 18befde:	48 c1 e7 04          	shl    $0x4,%rdi
 18befe2:	41 83 f8 01          	cmp    $0x1,%r8d
 18befe6:	44 89 4c 3b 04       	mov    %r9d,0x4(%rbx,%rdi,1)
 18befeb:	66 83 5c 3b 0c ff    	sbbw   $0xffff,0xc(%rbx,%rdi,1)
 18beff1:	41 8b 7c 8a 04       	mov    0x4(%r10,%rcx,4),%edi
 18beff6:	44 8b 44 8a e8       	mov    -0x18(%rdx,%rcx,4),%r8d
 18beffb:	44 8b 4c 8e e8       	mov    -0x18(%rsi,%rcx,4),%r9d
 18bf000:	48 c1 e7 04          	shl    $0x4,%rdi
 18bf004:	41 83 f8 01          	cmp    $0x1,%r8d
 18bf008:	44 89 4c 3b 04       	mov    %r9d,0x4(%rbx,%rdi,1)
 18bf00d:	66 83 5c 3b 0c ff    	sbbw   $0xffff,0xc(%rbx,%rdi,1)
 18bf013:	41 8b 7c 8a 08       	mov    0x8(%r10,%rcx,4),%edi
 18bf018:	44 8b 44 8a ec       	mov    -0x14(%rdx,%rcx,4),%r8d
 18bf01d:	44 8b 4c 8e ec       	mov    -0x14(%rsi,%rcx,4),%r9d
 18bf022:	48 c1 e7 04          	shl    $0x4,%rdi
 18bf026:	41 83 f8 01          	cmp    $0x1,%r8d
 18bf02a:	44 89 4c 3b 04       	mov    %r9d,0x4(%rbx,%rdi,1)
 18bf02f:	66 83 5c 3b 0c ff    	sbbw   $0xffff,0xc(%rbx,%rdi,1)
 18bf035:	41 8b 7c 8a 0c       	mov    0xc(%r10,%rcx,4),%edi
 18bf03a:	44 8b 44 8a f0       	mov    -0x10(%rdx,%rcx,4),%r8d
 18bf03f:	44 8b 4c 8e f0       	mov    -0x10(%rsi,%rcx,4),%r9d
 18bf044:	48 c1 e7 04          	shl    $0x4,%rdi
 18bf048:	41 83 f8 01          	cmp    $0x1,%r8d
 18bf04c:	44 89 4c 3b 04       	mov    %r9d,0x4(%rbx,%rdi,1)
 18bf051:	66 83 5c 3b 0c ff    	sbbw   $0xffff,0xc(%rbx,%rdi,1)
 18bf057:	41 8b 7c 8a 10       	mov    0x10(%r10,%rcx,4),%edi
 18bf05c:	44 8b 44 8a f4       	mov    -0xc(%rdx,%rcx,4),%r8d
 18bf061:	44 8b 4c 8e f4       	mov    -0xc(%rsi,%rcx,4),%r9d
 18bf066:	48 c1 e7 04          	shl    $0x4,%rdi
 18bf06a:	41 83 f8 01          	cmp    $0x1,%r8d
 18bf06e:	44 89 4c 3b 04       	mov    %r9d,0x4(%rbx,%rdi,1)
 18bf073:	66 83 5c 3b 0c ff    	sbbw   $0xffff,0xc(%rbx,%rdi,1)
 18bf079:	41 8b 7c 8a 14       	mov    0x14(%r10,%rcx,4),%edi
 18bf07e:	44 8b 44 8a f8       	mov    -0x8(%rdx,%rcx,4),%r8d
 18bf083:	44 8b 4c 8e f8       	mov    -0x8(%rsi,%rcx,4),%r9d
 18bf088:	48 c1 e7 04          	shl    $0x4,%rdi
 18bf08c:	41 83 f8 01          	cmp    $0x1,%r8d
 18bf090:	44 89 4c 3b 04       	mov    %r9d,0x4(%rbx,%rdi,1)
 18bf095:	66 83 5c 3b 0c ff    	sbbw   $0xffff,0xc(%rbx,%rdi,1)
 18bf09b:	41 8b 7c 8a 18       	mov    0x18(%r10,%rcx,4),%edi
 18bf0a0:	44 8b 44 8a fc       	mov    -0x4(%rdx,%rcx,4),%r8d
 18bf0a5:	44 8b 4c 8e fc       	mov    -0x4(%rsi,%rcx,4),%r9d
 18bf0aa:	48 c1 e7 04          	shl    $0x4,%rdi
 18bf0ae:	41 83 f8 01          	cmp    $0x1,%r8d
 18bf0b2:	44 89 4c 3b 04       	mov    %r9d,0x4(%rbx,%rdi,1)
 18bf0b7:	66 83 5c 3b 0c ff    	sbbw   $0xffff,0xc(%rbx,%rdi,1)
 18bf0bd:	41 8b 7c 8a 1c       	mov    0x1c(%r10,%rcx,4),%edi
 18bf0c2:	44 8b 04 8a          	mov    (%rdx,%rcx,4),%r8d
 18bf0c6:	44 8b 0c 8e          	mov    (%rsi,%rcx,4),%r9d
 18bf0ca:	48 c1 e7 04          	shl    $0x4,%rdi
 18bf0ce:	41 83 f8 01          	cmp    $0x1,%r8d
 18bf0d2:	44 89 4c 3b 04       	mov    %r9d,0x4(%rbx,%rdi,1)
 18bf0d7:	66 83 5c 3b 0c ff    	sbbw   $0xffff,0xc(%rbx,%rdi,1)
 18bf0dd:	48 83 c1 08          	add    $0x8,%rcx
 18bf0e1:	49 39 cd             	cmp    %rcx,%r13
 18bf0e4:	0f 85 e6 fe ff ff    	jne    18befd0 <tier0_benchmark_run+0x1b50>
 18bf0ea:	4c 8b 4c 24 10       	mov    0x10(%rsp),%r9
 18bf0ef:	48 85 c0             	test   %rax,%rax
 18bf0f2:	0f 84 c8 e5 ff ff    	je     18bd6c0 <tier0_benchmark_run+0x240>
 18bf0f8:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
 18bf0fd:	4c 8b 84 24 98 00 00 00 	mov    0x98(%rsp),%r8
 18bf105:	4c 8b 9c 24 b8 00 00 00 	mov    0xb8(%rsp),%r11
 18bf10d:	48 8b 7c 24 40       	mov    0x40(%rsp),%rdi
 18bf112:	c1 e0 02             	shl    $0x2,%eax
 18bf115:	c1 e6 06             	shl    $0x6,%esi
 18bf118:	49 01 f0             	add    %rsi,%r8
 18bf11b:	49 01 f3             	add    %rsi,%r11
 18bf11e:	49 01 f8             	add    %rdi,%r8
 18bf121:	49 01 fb             	add    %rdi,%r11
 18bf124:	31 ff                	xor    %edi,%edi
 18bf126:	49 8d 14 88          	lea    (%r8,%rcx,4),%rdx
 18bf12a:	49 8d 34 8b          	lea    (%r11,%rcx,4),%rsi
 18bf12e:	49 8d 0c 8a          	lea    (%r10,%rcx,4),%rcx
 18bf132:	49 8d 54 11 40       	lea    0x40(%r9,%rdx,1),%rdx
 18bf137:	49 8d 74 31 40       	lea    0x40(%r9,%rsi,1),%rsi
 18bf13c:	0f 1f 40 00          	nopl   0x0(%rax)
 18bf140:	44 8b 04 39          	mov    (%rcx,%rdi,1),%r8d
 18bf144:	44 8b 0c 3e          	mov    (%rsi,%rdi,1),%r9d
 18bf148:	44 8b 14 3a          	mov    (%rdx,%rdi,1),%r10d
 18bf14c:	49 c1 e0 04          	shl    $0x4,%r8
 18bf150:	41 83 f9 01          	cmp    $0x1,%r9d
 18bf154:	46 89 54 03 04       	mov    %r10d,0x4(%rbx,%r8,1)
 18bf159:	66 42 83 5c 03 0c ff 	sbbw   $0xffff,0xc(%rbx,%r8,1)
 18bf160:	48 83 c7 04          	add    $0x4,%rdi
 18bf164:	48 39 f8             	cmp    %rdi,%rax
 18bf167:	75 d7                	jne    18bf140 <tier0_benchmark_run+0x1cc0>
 18bf169:	e9 52 e5 ff ff       	jmp    18bd6c0 <tier0_benchmark_run+0x240>
 18bf16e:	45 31 ff             	xor    %r15d,%r15d
 18bf171:	31 db                	xor    %ebx,%ebx
 18bf173:	45 31 f6             	xor    %r14d,%r14d
 18bf176:	eb 4a                	jmp    18bf1c2 <tier0_benchmark_run+0x1d42>
 18bf178:	0f 1f 84 00 00 00 00 00 	nopl   0x0(%rax,%rax,1)
 18bf180:	49 8b 4d 20          	mov    0x20(%r13),%rcx
 18bf184:	49 8b 55 28          	mov    0x28(%r13),%rdx
 18bf188:	49 8b 45 10          	mov    0x10(%r13),%rax
 18bf18c:	4a 8b 0c f1          	mov    (%rcx,%r14,8),%rcx
 18bf190:	4a 8b 14 f2          	mov    (%rdx,%r14,8),%rdx
 18bf194:	4a 8b 3c f0          	mov    (%rax,%r14,8),%rdi
 18bf198:	e8 a3 07 36 ff       	call   c1f940 <x86_encode_16>
 18bf19d:	48 89 c1             	mov    %rax,%rcx
 18bf1a0:	48 c1 f9 3f          	sar    $0x3f,%rcx
 18bf1a4:	c4 e2 f0 f2 c8       	andn   %rax,%rcx,%rcx
 18bf1a9:	41 8b 45 30          	mov    0x30(%r13),%eax
 18bf1ad:	49 01 cf             	add    %rcx,%r15
 18bf1b0:	49 ff c6             	inc    %r14
 18bf1b3:	48 83 c3 68          	add    $0x68,%rbx
 18bf1b7:	89 c1                	mov    %eax,%ecx
 18bf1b9:	49 39 ce             	cmp    %rcx,%r14
 18bf1bc:	0f 83 13 e4 ff ff    	jae    18bd5d5 <tier0_benchmark_run+0x155>
 18bf1c2:	49 8b 4d 08          	mov    0x8(%r13),%rcx
 18bf1c6:	8b 74 19 08          	mov    0x8(%rcx,%rbx,1),%esi
 18bf1ca:	48 81 fe 11 11 11 11 	cmp    $0x11111111,%rsi
 18bf1d1:	76 ad                	jbe    18bf180 <tier0_benchmark_run+0x1d00>
 18bf1d3:	31 c9                	xor    %ecx,%ecx
 18bf1d5:	eb d6                	jmp    18bf1ad <tier0_benchmark_run+0x1d2d>
 18bf1d7:	48 8d 3d 19 0e e1 fe 	lea    -0x11ef1e7(%rip),%rdi        # 6cfff7 <pp_string_value.meaning+0x72dab>
 18bf1de:	48 8d 35 ae 85 dc fe 	lea    -0x1237a52(%rip),%rsi        # 687793 <pp_string_value.meaning+0x2a547>
 18bf1e5:	48 8d 0d c2 85 dc fe 	lea    -0x1237a3e(%rip),%rcx        # 6877ae <pp_string_value.meaning+0x2a562>
 18bf1ec:	ba bf 00 00 00       	mov    $0xbf,%edx
 18bf1f1:	c5 f8 77             	vzeroupper
 18bf1f4:	e8 57 49 ea fe       	call   763b50 <__assert_fail@plt>
 18bf1f9:	c5 f8 77             	vzeroupper
 18bf1fc:	e8 df 48 ea fe       	call   763ae0 <__stack_chk_fail@plt>
