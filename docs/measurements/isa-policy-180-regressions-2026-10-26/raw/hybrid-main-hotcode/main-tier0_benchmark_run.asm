
/home/david/buster-fast-bench/codex-180-fix-20261026-main/build/compiler:     file format elf64-x86-64


Disassembly of section .text:

00000000018ed320 <tier0_benchmark_run>:
 18ed320:	55                   	push   %rbp
 18ed321:	48 89 e5             	mov    %rsp,%rbp
 18ed324:	41 57                	push   %r15
 18ed326:	41 56                	push   %r14
 18ed328:	41 55                	push   %r13
 18ed32a:	41 54                	push   %r12
 18ed32c:	53                   	push   %rbx
 18ed32d:	48 83 e4 c0          	and    $0xffffffffffffffc0,%rsp
 18ed331:	48 81 ec 00 03 00 00 	sub    $0x300,%rsp
 18ed338:	44 89 4c 24 6c       	mov    %r9d,0x6c(%rsp)
 18ed33d:	4c 89 84 24 d0 00 00 00 	mov    %r8,0xd0(%rsp)
 18ed345:	48 89 bc 24 38 01 00 00 	mov    %rdi,0x138(%rsp)
 18ed34d:	49 89 cf             	mov    %rcx,%r15
 18ed350:	49 89 d5             	mov    %rdx,%r13
 18ed353:	41 89 f4             	mov    %esi,%r12d
 18ed356:	64 48 8b 04 25 28 00 00 00 	mov    %fs:0x28,%rax
 18ed35f:	48 89 84 24 c0 02 00 00 	mov    %rax,0x2c0(%rsp)
 18ed367:	83 fe 02             	cmp    $0x2,%esi
 18ed36a:	75 41                	jne    18ed3ad <tier0_benchmark_run+0x8d>
 18ed36c:	41 83 7d 30 00       	cmpl   $0x0,0x30(%r13)
 18ed371:	74 3a                	je     18ed3ad <tier0_benchmark_run+0x8d>
 18ed373:	31 db                	xor    %ebx,%ebx
 18ed375:	45 31 f6             	xor    %r14d,%r14d
 18ed378:	0f 1f 84 00 00 00 00 00 	nopl   0x0(%rax,%rax,1)
 18ed380:	49 8b 45 08          	mov    0x8(%r13),%rax
 18ed384:	49 8b 4d 10          	mov    0x10(%r13),%rcx
 18ed388:	8b 54 18 08          	mov    0x8(%rax,%rbx,1),%edx
 18ed38c:	4a 8b 3c f1          	mov    (%rcx,%r14,8),%rdi
 18ed390:	48 8b 34 18          	mov    (%rax,%rbx,1),%rsi
 18ed394:	48 c1 e2 04          	shl    $0x4,%rdx
 18ed398:	e8 03 cc ea fe       	call   799fa0 <memcpy@plt>
 18ed39d:	41 8b 45 30          	mov    0x30(%r13),%eax
 18ed3a1:	49 ff c6             	inc    %r14
 18ed3a4:	48 83 c3 68          	add    $0x68,%rbx
 18ed3a8:	49 39 c6             	cmp    %rax,%r14
 18ed3ab:	72 d3                	jb     18ed380 <tier0_benchmark_run+0x60>
 18ed3ad:	48 8b b4 24 d0 00 00 00 	mov    0xd0(%rsp),%rsi
 18ed3b5:	8b 54 24 6c          	mov    0x6c(%rsp),%edx
 18ed3b9:	48 8d bc 24 48 01 00 00 	lea    0x148(%rsp),%rdi
 18ed3c1:	e8 7a e6 04 00       	call   193ba40 <tier0_benchmark_read>
 18ed3c6:	41 8b 45 30          	mov    0x30(%r13),%eax
 18ed3ca:	85 c0                	test   %eax,%eax
 18ed3cc:	0f 84 a0 00 00 00    	je     18ed472 <tier0_benchmark_run+0x152>
 18ed3d2:	49 8b 5f 08          	mov    0x8(%r15),%rbx
 18ed3d6:	44 89 64 24 3c       	mov    %r12d,0x3c(%rsp)
 18ed3db:	45 85 e4             	test   %r12d,%r12d
 18ed3de:	74 4f                	je     18ed42f <tier0_benchmark_run+0x10f>
 18ed3e0:	41 83 fc 01          	cmp    $0x1,%r12d
 18ed3e4:	0f 85 fc 00 00 00    	jne    18ed4e6 <tier0_benchmark_run+0x1c6>
 18ed3ea:	4c 8d a4 24 c0 01 00 00 	lea    0x1c0(%rsp),%r12
 18ed3f2:	45 31 f6             	xor    %r14d,%r14d
 18ed3f5:	66 66 2e 0f 1f 84 00 00 00 00 00 	data16 cs nopw 0x0(%rax,%rax,1)
 18ed400:	49 8b 45 00          	mov    0x0(%r13),%rax
 18ed404:	4c 89 e7             	mov    %r12,%rdi
 18ed407:	4c 89 fa             	mov    %r15,%rdx
 18ed40a:	4a 8b 34 f0          	mov    (%rax,%r14,8),%rsi
 18ed40e:	e8 3d 18 01 00       	call   18fec50 <tier0_compile_scalar>
 18ed413:	49 3b 5f 08          	cmp    0x8(%r15),%rbx
 18ed417:	0f 87 5a 1c 00 00    	ja     18ef077 <tier0_benchmark_run+0x1d57>
 18ed41d:	49 89 5f 08          	mov    %rbx,0x8(%r15)
 18ed421:	49 ff c6             	inc    %r14
 18ed424:	41 8b 45 30          	mov    0x30(%r13),%eax
 18ed428:	49 39 c6             	cmp    %rax,%r14
 18ed42b:	72 d3                	jb     18ed400 <tier0_benchmark_run+0xe0>
 18ed42d:	eb 3e                	jmp    18ed46d <tier0_benchmark_run+0x14d>
 18ed42f:	4c 8d a4 24 c0 01 00 00 	lea    0x1c0(%rsp),%r12
 18ed437:	45 31 f6             	xor    %r14d,%r14d
 18ed43a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
 18ed440:	49 8b 45 00          	mov    0x0(%r13),%rax
 18ed444:	4c 89 e7             	mov    %r12,%rdi
 18ed447:	4c 89 fa             	mov    %r15,%rdx
 18ed44a:	4a 8b 34 f0          	mov    (%rax,%r14,8),%rsi
 18ed44e:	e8 1d 27 01 00       	call   18ffb70 <tier0_compile>
 18ed453:	49 3b 5f 08          	cmp    0x8(%r15),%rbx
 18ed457:	0f 87 1a 1c 00 00    	ja     18ef077 <tier0_benchmark_run+0x1d57>
 18ed45d:	49 89 5f 08          	mov    %rbx,0x8(%r15)
 18ed461:	49 ff c6             	inc    %r14
 18ed464:	41 8b 45 30          	mov    0x30(%r13),%eax
 18ed468:	49 39 c6             	cmp    %rax,%r14
 18ed46b:	72 d3                	jb     18ed440 <tier0_benchmark_run+0x120>
 18ed46d:	44 8b 64 24 3c       	mov    0x3c(%rsp),%r12d
 18ed472:	45 31 ff             	xor    %r15d,%r15d
 18ed475:	48 8b b4 24 d0 00 00 00 	mov    0xd0(%rsp),%rsi
 18ed47d:	8b 54 24 6c          	mov    0x6c(%rsp),%edx
 18ed481:	48 8d bc 24 c0 01 00 00 	lea    0x1c0(%rsp),%rdi
 18ed489:	c5 f8 77             	vzeroupper
 18ed48c:	e8 af e5 04 00       	call   193ba40 <tier0_benchmark_read>
 18ed491:	c5 fe 6f 84 24 c0 01 00 00 	vmovdqu 0x1c0(%rsp),%ymm0
 18ed49a:	48 8b 84 24 38 01 00 00 	mov    0x138(%rsp),%rax
 18ed4a2:	c5 fd fb 84 24 48 01 00 00 	vpsubq 0x148(%rsp),%ymm0,%ymm0
 18ed4ab:	c5 fe 7f 00          	vmovdqu %ymm0,(%rax)
 18ed4af:	41 83 fc 03          	cmp    $0x3,%r12d
 18ed4b3:	74 04                	je     18ed4b9 <tier0_benchmark_run+0x199>
 18ed4b5:	4d 8b 7d 50          	mov    0x50(%r13),%r15
 18ed4b9:	4d 89 7d 50          	mov    %r15,0x50(%r13)
 18ed4bd:	64 48 8b 04 25 28 00 00 00 	mov    %fs:0x28,%rax
 18ed4c6:	48 3b 84 24 c0 02 00 00 	cmp    0x2c0(%rsp),%rax
 18ed4ce:	0f 85 c5 1b 00 00    	jne    18ef099 <tier0_benchmark_run+0x1d79>
 18ed4d4:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
 18ed4d8:	5b                   	pop    %rbx
 18ed4d9:	41 5c                	pop    %r12
 18ed4db:	41 5d                	pop    %r13
 18ed4dd:	41 5e                	pop    %r14
 18ed4df:	41 5f                	pop    %r15
 18ed4e1:	5d                   	pop    %rbp
 18ed4e2:	c5 f8 77             	vzeroupper
 18ed4e5:	c3                   	ret
 18ed4e6:	41 83 fc 02          	cmp    $0x2,%r12d
 18ed4ea:	0f 85 1e 1b 00 00    	jne    18ef00e <tier0_benchmark_run+0x1cee>
 18ed4f0:	62 f2 7d 48 58 35 e2 95 cc fe 	vpbroadcastd -0x1336a1e(%rip),%zmm6        # 5b6adc <tier0_emit_x87.operations+0x8c>
 18ed4fa:	62 f1 fd 48 6f 3d fc 91 c5 fe 	vmovdqa64 -0x13a6e04(%rip),%zmm7        # 546700 <branch_sizing_patterns+0xa70>
 18ed504:	62 e2 7d 48 5a 0d 62 ed cb fe 	vbroadcasti32x4 -0x134129e(%rip),%zmm17        # 5ac270 <x86_effects_unknown+0x2a0>
 18ed50e:	62 72 7d 48 5a 0d 68 ed cb fe 	vbroadcasti32x4 -0x1341298(%rip),%zmm9        # 5ac280 <x86_effects_unknown+0x2b0>
 18ed518:	62 72 7d 48 58 15 16 96 cc fe 	vpbroadcastd -0x13369ea(%rip),%zmm10        # 5b6b38 <tier0_emit_x87.operations+0xe8>
 18ed522:	62 72 7d 48 58 1d 10 96 cc fe 	vpbroadcastd -0x13369f0(%rip),%zmm11        # 5b6b3c <tier0_emit_x87.operations+0xec>
 18ed52c:	48 b9 00 00 20 00 10 00 00 00 	movabs $0x1000200000,%rcx
 18ed536:	45 31 ff             	xor    %r15d,%r15d
 18ed539:	c4 41 39 ef c0       	vpxor  %xmm8,%xmm8,%xmm8
 18ed53e:	45 31 f6             	xor    %r14d,%r14d
 18ed541:	4c 89 ac 24 30 01 00 00 	mov    %r13,0x130(%rsp)
 18ed549:	48 81 c1 00 00 e0 ff 	add    $0xffffffffffe00000,%rcx
 18ed550:	48 89 8c 24 f0 00 00 00 	mov    %rcx,0xf0(%rsp)
 18ed558:	eb 45                	jmp    18ed59f <tier0_benchmark_run+0x27f>
 18ed55a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
 18ed560:	48 8b 84 24 40 01 00 00 	mov    0x140(%rsp),%rax
 18ed568:	64 48 3b 04 25 18 ff ff ff 	cmp    %fs:0xffffffffffffff18,%rax
 18ed571:	0f 87 00 1b 00 00    	ja     18ef077 <tier0_benchmark_run+0x1d57>
 18ed577:	4c 8b ac 24 30 01 00 00 	mov    0x130(%rsp),%r13
 18ed57f:	64 48 89 04 25 18 ff ff ff 	mov    %rax,%fs:0xffffffffffffff18
 18ed588:	44 8b 64 24 3c       	mov    0x3c(%rsp),%r12d
 18ed58d:	41 8b 45 30          	mov    0x30(%r13),%eax
 18ed591:	49 ff c6             	inc    %r14
 18ed594:	89 c1                	mov    %eax,%ecx
 18ed596:	49 39 ce             	cmp    %rcx,%r14
 18ed599:	0f 83 d6 fe ff ff    	jae    18ed475 <tier0_benchmark_run+0x155>
 18ed59f:	49 8b 55 08          	mov    0x8(%r13),%rdx
 18ed5a3:	49 6b ce 68          	imul   $0x68,%r14,%rcx
 18ed5a7:	44 8b 4c 0a 08       	mov    0x8(%rdx,%rcx,1),%r9d
 18ed5ac:	49 81 f9 11 11 11 11 	cmp    $0x11111111,%r9
 18ed5b3:	77 dc                	ja     18ed591 <tier0_benchmark_run+0x271>
 18ed5b5:	49 8b 45 10          	mov    0x10(%r13),%rax
 18ed5b9:	4c 8b 54 0a 10       	mov    0x10(%rdx,%rcx,1),%r10
 18ed5be:	4c 8b 44 0a 18       	mov    0x18(%rdx,%rcx,1),%r8
 18ed5c3:	8b 7c 0a 20          	mov    0x20(%rdx,%rcx,1),%edi
 18ed5c7:	49 8b 4d 18          	mov    0x18(%r13),%rcx
 18ed5cb:	64 4c 8b 2c 25 10 ff ff ff 	mov    %fs:0xffffffffffffff10,%r13
 18ed5d4:	4a 8b 34 f0          	mov    (%rax,%r14,8),%rsi
 18ed5d8:	4a 8b 04 f1          	mov    (%rcx,%r14,8),%rax
 18ed5dc:	4c 89 54 24 28       	mov    %r10,0x28(%rsp)
 18ed5e1:	48 89 7c 24 30       	mov    %rdi,0x30(%rsp)
 18ed5e6:	4c 89 84 24 a8 00 00 00 	mov    %r8,0xa8(%rsp)
 18ed5ee:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
 18ed5f3:	4d 85 ed             	test   %r13,%r13
 18ed5f6:	74 0e                	je     18ed606 <tier0_benchmark_run+0x2e6>
 18ed5f8:	64 48 8b 0c 25 18 ff ff ff 	mov    %fs:0xffffffffffffff18,%rcx
 18ed601:	e9 16 01 00 00       	jmp    18ed71c <tier0_benchmark_run+0x3fc>
 18ed606:	48 bb 00 00 20 00 10 00 00 00 	movabs $0x1000200000,%rbx
 18ed610:	ba 03 00 00 00       	mov    $0x3,%edx
 18ed615:	b9 22 40 00 00       	mov    $0x4022,%ecx
 18ed61a:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
 18ed620:	4c 89 4c 24 18       	mov    %r9,0x18(%rsp)
 18ed625:	48 89 74 24 50       	mov    %rsi,0x50(%rsp)
 18ed62a:	4c 89 74 24 48       	mov    %r14,0x48(%rsp)
 18ed62f:	31 ff                	xor    %edi,%edi
 18ed631:	45 31 c9             	xor    %r9d,%r9d
 18ed634:	48 89 de             	mov    %rbx,%rsi
 18ed637:	c5 f8 77             	vzeroupper
 18ed63a:	e8 51 ca ea fe       	call   79a090 <mmap@plt>
 18ed63f:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
 18ed643:	74 50                	je     18ed695 <tier0_benchmark_run+0x375>
 18ed645:	4c 8d a8 ff ff 20 00 	lea    0x20ffff(%rax),%r13
 18ed64c:	ba 0f 00 00 00       	mov    $0xf,%edx
 18ed651:	48 89 c7             	mov    %rax,%rdi
 18ed654:	49 81 e5 00 00 e0 ff 	and    $0xffffffffffe00000,%r13
 18ed65b:	4d 89 ec             	mov    %r13,%r12
 18ed65e:	49 29 c4             	sub    %rax,%r12
 18ed661:	4c 89 e6             	mov    %r12,%rsi
 18ed664:	4d 8d b4 24 00 00 ff ff 	lea    -0x10000(%r12),%r14
 18ed66c:	e8 cf c9 ea fe       	call   79a040 <madvise@plt>
 18ed671:	4c 29 e3             	sub    %r12,%rbx
 18ed674:	ba 0e 00 00 00       	mov    $0xe,%edx
 18ed679:	4c 89 ef             	mov    %r13,%rdi
 18ed67c:	48 89 de             	mov    %rbx,%rsi
 18ed67f:	e8 bc c9 ea fe       	call   79a040 <madvise@plt>
 18ed684:	48 8b 84 24 f0 00 00 00 	mov    0xf0(%rsp),%rax
 18ed68c:	49 81 c5 00 00 ff ff 	add    $0xffffffffffff0000,%r13
 18ed693:	eb 08                	jmp    18ed69d <tier0_benchmark_run+0x37d>
 18ed695:	45 31 ed             	xor    %r13d,%r13d
 18ed698:	31 c0                	xor    %eax,%eax
 18ed69a:	45 31 f6             	xor    %r14d,%r14d
 18ed69d:	62 f2 7d 48 58 35 35 94 cc fe 	vpbroadcastd -0x1336bcb(%rip),%zmm6        # 5b6adc <tier0_emit_x87.operations+0x8c>
 18ed6a7:	62 f1 fd 48 6f 3d 4f 90 c5 fe 	vmovdqa64 -0x13a6fb1(%rip),%zmm7        # 546700 <branch_sizing_patterns+0xa70>
 18ed6b1:	62 e2 7d 48 5a 0d b5 eb cb fe 	vbroadcasti32x4 -0x134144b(%rip),%zmm17        # 5ac270 <x86_effects_unknown+0x2a0>
 18ed6bb:	62 72 7d 48 5a 0d bb eb cb fe 	vbroadcasti32x4 -0x1341445(%rip),%zmm9        # 5ac280 <x86_effects_unknown+0x2b0>
 18ed6c5:	62 72 7d 48 58 15 69 94 cc fe 	vpbroadcastd -0x1336b97(%rip),%zmm10        # 5b6b38 <tier0_emit_x87.operations+0xe8>
 18ed6cf:	62 72 7d 48 58 1d 63 94 cc fe 	vpbroadcastd -0x1336b9d(%rip),%zmm11        # 5b6b3c <tier0_emit_x87.operations+0xec>
 18ed6d9:	64 4c 89 2c 25 10 ff ff ff 	mov    %r13,%fs:0xffffffffffffff10
 18ed6e2:	64 48 c7 04 25 18 ff ff ff 00 00 00 00 	movq   $0x0,%fs:0xffffffffffffff18
 18ed6ef:	64 48 89 04 25 20 ff ff ff 	mov    %rax,%fs:0xffffffffffffff20
 18ed6f8:	64 4c 89 34 25 28 ff ff ff 	mov    %r14,%fs:0xffffffffffffff28
 18ed701:	4c 8b 74 24 48       	mov    0x48(%rsp),%r14
 18ed706:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
 18ed70b:	48 8b 7c 24 30       	mov    0x30(%rsp),%rdi
 18ed710:	4c 8b 4c 24 18       	mov    0x18(%rsp),%r9
 18ed715:	31 c9                	xor    %ecx,%ecx
 18ed717:	c4 41 39 ef c0       	vpxor  %xmm8,%xmm8,%xmm8
 18ed71c:	4e 8d 44 29 3f       	lea    0x3f(%rcx,%r13,1),%r8
 18ed721:	4a 8d 04 29          	lea    (%rcx,%r13,1),%rax
 18ed725:	48 89 8c 24 40 01 00 00 	mov    %rcx,0x140(%rsp)
 18ed72d:	49 83 e0 c0          	and    $0xffffffffffffffc0,%r8
 18ed731:	49 39 c0             	cmp    %rax,%r8
 18ed734:	0f 82 26 fe ff ff    	jb     18ed560 <tier0_benchmark_run+0x240>
 18ed73a:	64 48 8b 0c 25 20 ff ff ff 	mov    %fs:0xffffffffffffff20,%rcx
 18ed743:	4c 89 c0             	mov    %r8,%rax
 18ed746:	4c 29 e8             	sub    %r13,%rax
 18ed749:	48 29 c1             	sub    %rax,%rcx
 18ed74c:	0f 82 0e fe ff ff    	jb     18ed560 <tier0_benchmark_run+0x240>
 18ed752:	44 89 ca             	mov    %r9d,%edx
 18ed755:	c1 ea 06             	shr    $0x6,%edx
 18ed758:	4c 8d 24 bd 7c 00 00 00 	lea    0x7c(,%rdi,4),%r12
 18ed760:	4c 8d 1c bd bc 00 00 00 	lea    0xbc(,%rdi,4),%r11
 18ed768:	4c 89 4c 24 18       	mov    %r9,0x18(%rsp)
 18ed76d:	48 8d 5a 01          	lea    0x1(%rdx),%rbx
 18ed771:	48 89 54 24 20       	mov    %rdx,0x20(%rsp)
 18ed776:	48 ba c0 ff ff ff 07 00 00 00 	movabs $0x7ffffffc0,%rdx
 18ed780:	4c 8b 4c 24 18       	mov    0x18(%rsp),%r9
 18ed785:	49 21 d4             	and    %rdx,%r12
 18ed788:	49 21 d3             	and    %rdx,%r11
 18ed78b:	89 fa                	mov    %edi,%edx
 18ed78d:	c1 ea 03             	shr    $0x3,%edx
 18ed790:	49 89 dd             	mov    %rbx,%r13
 18ed793:	48 89 9c 24 c8 00 00 00 	mov    %rbx,0xc8(%rsp)
 18ed79b:	c1 e3 04             	shl    $0x4,%ebx
 18ed79e:	49 c1 e5 06          	shl    $0x6,%r13
 18ed7a2:	83 c2 48             	add    $0x48,%edx
 18ed7a5:	83 c3 30             	add    $0x30,%ebx
 18ed7a8:	4c 89 64 24 70       	mov    %r12,0x70(%rsp)
 18ed7ad:	4f 8d 24 a4          	lea    (%r12,%r12,4),%r12
 18ed7b1:	4c 89 6c 24 78       	mov    %r13,0x78(%rsp)
 18ed7b6:	4c 89 9c 24 88 00 00 00 	mov    %r11,0x88(%rsp)
 18ed7be:	83 e2 c0             	and    $0xffffffc0,%edx
 18ed7c1:	81 e3 c0 ff ff 1f    	and    $0x1fffffc0,%ebx
 18ed7c7:	4c 01 ea             	add    %r13,%rdx
 18ed7ca:	48 89 5c 24 40       	mov    %rbx,0x40(%rsp)
 18ed7cf:	4c 89 a4 24 80 00 00 00 	mov    %r12,0x80(%rsp)
 18ed7d7:	48 01 da             	add    %rbx,%rdx
 18ed7da:	4c 01 e2             	add    %r12,%rdx
 18ed7dd:	4a 8d 14 5a          	lea    (%rdx,%r11,2),%rdx
 18ed7e1:	48 39 ca             	cmp    %rcx,%rdx
 18ed7e4:	0f 87 76 fd ff ff    	ja     18ed560 <tier0_benchmark_run+0x240>
 18ed7ea:	48 01 d0             	add    %rdx,%rax
 18ed7ed:	48 c7 84 24 b8 01 00 00 00 00 00 00 	movq   $0x0,0x1b8(%rsp)
 18ed7f9:	64 48 89 04 25 18 ff ff ff 	mov    %rax,%fs:0xffffffffffffff18
 18ed802:	4d 85 c0             	test   %r8,%r8
 18ed805:	0f 95 84 24 b8 01 00 00 	setne  0x1b8(%rsp)
 18ed80d:	0f 84 4d fd ff ff    	je     18ed560 <tier0_benchmark_run+0x240>
 18ed813:	4c 8b 64 24 78       	mov    0x78(%rsp),%r12
 18ed818:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
 18ed81d:	48 8b 5c 24 70       	mov    0x70(%rsp),%rbx
 18ed822:	4c 89 84 24 68 01 00 00 	mov    %r8,0x168(%rsp)
 18ed82a:	4c 8b 9c 24 88 00 00 00 	mov    0x88(%rsp),%r11
 18ed832:	4c 89 74 24 48       	mov    %r14,0x48(%rsp)
 18ed837:	48 89 74 24 50       	mov    %rsi,0x50(%rsp)
 18ed83c:	4d 01 c4             	add    %r8,%r12
 18ed83f:	4b 8d 04 1b          	lea    (%r11,%r11,1),%rax
 18ed843:	49 8d 14 0c          	lea    (%r12,%rcx,1),%rdx
 18ed847:	4c 89 a4 24 70 01 00 00 	mov    %r12,0x170(%rsp)
 18ed84f:	4c 89 64 24 78       	mov    %r12,0x78(%rsp)
 18ed854:	48 8d 0c 1a          	lea    (%rdx,%rbx,1),%rcx
 18ed858:	48 89 94 24 78 01 00 00 	mov    %rdx,0x178(%rsp)
 18ed860:	4c 8d 14 5a          	lea    (%rdx,%rbx,2),%r10
 18ed864:	48 89 54 24 60       	mov    %rdx,0x60(%rsp)
 18ed869:	48 89 8c 24 80 01 00 00 	mov    %rcx,0x180(%rsp)
 18ed871:	48 89 8c 24 e8 00 00 00 	mov    %rcx,0xe8(%rsp)
 18ed879:	48 8d 0c 5b          	lea    (%rbx,%rbx,2),%rcx
 18ed87d:	48 8d 1c 9a          	lea    (%rdx,%rbx,4),%rbx
 18ed881:	4c 89 94 24 88 01 00 00 	mov    %r10,0x188(%rsp)
 18ed889:	4c 8d 24 0a          	lea    (%rdx,%rcx,1),%r12
 18ed88d:	48 89 8c 24 b8 00 00 00 	mov    %rcx,0xb8(%rsp)
 18ed895:	48 8b 8c 24 80 00 00 00 	mov    0x80(%rsp),%rcx
 18ed89d:	48 89 9c 24 e0 00 00 00 	mov    %rbx,0xe0(%rsp)
 18ed8a5:	4c 89 a4 24 90 01 00 00 	mov    %r12,0x190(%rsp)
 18ed8ad:	48 89 9c 24 98 01 00 00 	mov    %rbx,0x198(%rsp)
 18ed8b5:	48 01 d1             	add    %rdx,%rcx
 18ed8b8:	4a 8d 14 19          	lea    (%rcx,%r11,1),%rdx
 18ed8bc:	48 01 c8             	add    %rcx,%rax
 18ed8bf:	48 89 8c 24 a0 01 00 00 	mov    %rcx,0x1a0(%rsp)
 18ed8c7:	48 89 8c 24 a0 00 00 00 	mov    %rcx,0xa0(%rsp)
 18ed8cf:	48 89 94 24 a8 01 00 00 	mov    %rdx,0x1a8(%rsp)
 18ed8d7:	48 89 94 24 c0 00 00 00 	mov    %rdx,0xc0(%rsp)
 18ed8df:	48 89 84 24 b0 01 00 00 	mov    %rax,0x1b0(%rsp)
 18ed8e7:	41 83 f9 10          	cmp    $0x10,%r9d
 18ed8eb:	73 10                	jae    18ed8fd <tier0_benchmark_run+0x5dd>
 18ed8ed:	4c 8b 74 24 58       	mov    0x58(%rsp),%r14
 18ed8f2:	45 31 ed             	xor    %r13d,%r13d
 18ed8f5:	45 31 ff             	xor    %r15d,%r15d
 18ed8f8:	e9 11 03 00 00       	jmp    18edc0e <tier0_benchmark_run+0x8ee>
 18ed8fd:	62 e2 7d 48 58 25 e1 91 cc fe 	vpbroadcastd -0x1336e1f(%rip),%zmm20        # 5b6ae8 <tier0_emit_x87.operations+0x98>
 18ed907:	62 e2 7d 48 58 2d db 91 cc fe 	vpbroadcastd -0x1336e25(%rip),%zmm21        # 5b6aec <tier0_emit_x87.operations+0x9c>
 18ed911:	62 e2 7d 48 58 35 d5 91 cc fe 	vpbroadcastd -0x1336e2b(%rip),%zmm22        # 5b6af0 <tier0_emit_x87.operations+0xa0>
 18ed91b:	62 e2 7d 48 58 3d cf 91 cc fe 	vpbroadcastd -0x1336e31(%rip),%zmm23        # 5b6af4 <tier0_emit_x87.operations+0xa4>
 18ed925:	62 62 7d 48 58 05 c9 91 cc fe 	vpbroadcastd -0x1336e37(%rip),%zmm24        # 5b6af8 <tier0_emit_x87.operations+0xa8>
 18ed92f:	62 62 7d 48 58 0d c3 91 cc fe 	vpbroadcastd -0x1336e3d(%rip),%zmm25        # 5b6afc <tier0_emit_x87.operations+0xac>
 18ed939:	62 62 7d 48 58 15 bd 91 cc fe 	vpbroadcastd -0x1336e43(%rip),%zmm26        # 5b6b00 <tier0_emit_x87.operations+0xb0>
 18ed943:	62 62 7d 48 58 1d b7 91 cc fe 	vpbroadcastd -0x1336e49(%rip),%zmm27        # 5b6b04 <tier0_emit_x87.operations+0xb4>
 18ed94d:	62 62 7d 48 58 25 b1 91 cc fe 	vpbroadcastd -0x1336e4f(%rip),%zmm28        # 5b6b08 <tier0_emit_x87.operations+0xb8>
 18ed957:	62 62 7d 48 58 2d ab 91 cc fe 	vpbroadcastd -0x1336e55(%rip),%zmm29        # 5b6b0c <tier0_emit_x87.operations+0xbc>
 18ed961:	62 62 7d 48 58 35 a5 91 cc fe 	vpbroadcastd -0x1336e5b(%rip),%zmm30        # 5b6b10 <tier0_emit_x87.operations+0xc0>
 18ed96b:	62 62 7d 48 58 3d 9f 91 cc fe 	vpbroadcastd -0x1336e61(%rip),%zmm31        # 5b6b14 <tier0_emit_x87.operations+0xc4>
 18ed975:	62 72 7d 48 58 2d 99 91 cc fe 	vpbroadcastd -0x1336e67(%rip),%zmm13        # 5b6b18 <tier0_emit_x87.operations+0xc8>
 18ed97f:	62 72 7d 48 58 3d 57 91 cc fe 	vpbroadcastd -0x1336ea9(%rip),%zmm15        # 5b6ae0 <tier0_emit_x87.operations+0x90>
 18ed989:	62 72 7d 48 5a 25 fd e8 cb fe 	vbroadcasti32x4 -0x1341703(%rip),%zmm12        # 5ac290 <x86_effects_unknown+0x2c0>
 18ed993:	62 e2 7d 48 58 15 3b 91 cc fe 	vpbroadcastd -0x1336ec5(%rip),%zmm18        # 5b6ad8 <tier0_emit_x87.operations+0x88>
 18ed99d:	4c 8b 74 24 58       	mov    0x58(%rsp),%r14
 18ed9a2:	48 8d 86 c0 00 00 00 	lea    0xc0(%rsi),%rax
 18ed9a9:	62 a3 7d 40 25 c0 ff 	vpternlogd $0xff,%zmm16,%zmm16,%zmm16
 18ed9b0:	4c 8d 1d 89 ea 36 0d 	lea    0xd36ea89(%rip),%r11        # ec5c440 <x86_template_storage>
 18ed9b7:	31 c9                	xor    %ecx,%ecx
 18ed9b9:	45 31 ed             	xor    %r13d,%r13d
 18ed9bc:	0f 1f 40 00          	nopl   0x0(%rax)
 18ed9c0:	62 f1 fe 48 6f 40 fd 	vmovdqu64 -0xc0(%rax),%zmm0
 18ed9c7:	62 f1 fe 48 6f 50 fe 	vmovdqu64 -0x80(%rax),%zmm2
 18ed9ce:	62 f1 fe 48 6f 58 ff 	vmovdqu64 -0x40(%rax),%zmm3
 18ed9d5:	62 f1 fe 48 6f 20    	vmovdqu64 (%rax),%zmm4
 18ed9db:	62 e2 7d 48 5a 1d bb e8 cb fe 	vbroadcasti32x4 -0x1341745(%rip),%zmm19        # 5ac2a0 <x86_effects_unknown+0x2d0>
 18ed9e5:	62 71 fd 48 6f f6    	vmovdqa64 %zmm6,%zmm14
 18ed9eb:	c5 fc 46 c8          	kxnorw %k0,%k0,%k1
 18ed9ef:	44 89 ea             	mov    %r13d,%edx
 18ed9f2:	4c 8d 79 10          	lea    0x10(%rcx),%r15
 18ed9f6:	48 05 00 01 00 00    	add    $0x100,%rax
 18ed9fc:	62 f1 7d 48 62 ca    	vpunpckldq %zmm2,%zmm0,%zmm1
 18eda02:	62 f1 65 48 62 ec    	vpunpckldq %zmm4,%zmm3,%zmm5
 18eda08:	62 f1 7d 48 6a c2    	vpunpckhdq %zmm2,%zmm0,%zmm0
 18eda0e:	62 f1 65 48 6a e4    	vpunpckhdq %zmm4,%zmm3,%zmm4
 18eda14:	62 f1 fd 48 6c dc    	vpunpcklqdq %zmm4,%zmm0,%zmm3
 18eda1a:	62 f1 fd 48 6d c4    	vpunpckhqdq %zmm4,%zmm0,%zmm0
 18eda20:	62 f1 f5 48 6d cd    	vpunpckhqdq %zmm5,%zmm1,%zmm1
 18eda26:	62 f1 7d 48 72 f0 04 	vpslld $0x4,%zmm0,%zmm0
 18eda2d:	62 f2 f5 40 83 e3    	vpmultishiftqb %zmm3,%zmm17,%zmm4
 18eda33:	62 f2 9d 48 83 eb    	vpmultishiftqb %zmm3,%zmm12,%zmm5
 18eda39:	62 f2 75 48 27 c1    	vptestmd %zmm1,%zmm1,%k0
 18eda3f:	62 f1 7d 48 db d6    	vpandd %zmm6,%zmm0,%zmm2
 18eda45:	62 f2 b5 48 83 f3    	vpmultishiftqb %zmm3,%zmm9,%zmm6
 18eda4b:	62 d3 5d 48 25 ef d8 	vpternlogd $0xd8,%zmm15,%zmm4,%zmm5
 18eda52:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 18eda56:	62 f1 5d 48 72 f3 04 	vpslld $0x4,%zmm3,%zmm4
 18eda5d:	62 f3 4d 58 25 2d 7c 90 cc fe d8 	vpternlogd $0xd8,-0x1336f84(%rip){1to16},%zmm6,%zmm5        # 5b6ae4 <tier0_emit_x87.operations+0x94>
 18eda68:	62 d2 7d 49 90 44 93 13 	vpgatherdd 0x4c(%r11,%zmm2,4),%zmm0{%k1}
 18eda70:	62 f1 6d 48 72 d3 1a 	vpsrld $0x1a,%zmm3,%zmm2
 18eda77:	62 f2 65 40 00 f3    	vpshufb %zmm3,%zmm19,%zmm6
 18eda7d:	62 e1 fd 48 6f df    	vmovdqa64 %zmm7,%zmm19
 18eda83:	62 f1 5d 48 72 e4 1f 	vpsrad $0x1f,%zmm4,%zmm4
 18eda8a:	62 f2 6d 48 36 d7    	vpermd %zmm7,%zmm2,%zmm2
 18eda90:	62 f1 45 48 72 d3 08 	vpsrld $0x8,%zmm3,%zmm7
 18eda97:	62 b3 6d 40 25 dd 6c 	vpternlogd $0x6c,%zmm21,%zmm18,%zmm3
 18eda9e:	62 b1 65 48 fe d8    	vpaddd %zmm16,%zmm3,%zmm3
 18edaa4:	62 b3 6d 40 25 fe 6c 	vpternlogd $0x6c,%zmm22,%zmm18,%zmm7
 18edaab:	62 b1 45 48 fe f8    	vpaddd %zmm16,%zmm7,%zmm7
 18edab1:	62 93 45 40 25 d8 ea 	vpternlogd $0xea,%zmm24,%zmm23,%zmm3
 18edab8:	62 93 45 48 25 d9 f8 	vpternlogd $0xf8,%zmm25,%zmm7,%zmm3
 18edabf:	62 91 55 48 db fa    	vpandd %zmm26,%zmm5,%zmm7
 18edac5:	62 f1 55 48 72 d5 03 	vpsrld $0x3,%zmm5,%zmm5
 18edacc:	62 f3 7d 48 25 fb f8 	vpternlogd $0xf8,%zmm3,%zmm0,%zmm7
 18edad3:	62 93 7d 48 25 ec a2 	vpternlogd $0xa2,%zmm28,%zmm0,%zmm5
 18edada:	62 92 45 48 3b db    	vpminud %zmm27,%zmm7,%zmm3
 18edae0:	62 f1 5d 48 db fe    	vpandd %zmm6,%zmm4,%zmm7
 18edae6:	62 93 6d 48 25 fe ec 	vpternlogd $0xec,%zmm30,%zmm2,%zmm7
 18edaed:	62 92 55 48 3b d5    	vpminud %zmm29,%zmm5,%zmm2
 18edaf3:	62 93 7d 48 25 ff f8 	vpternlogd $0xf8,%zmm31,%zmm0,%zmm7
 18edafa:	62 f3 6d 48 25 fb fe 	vpternlogd $0xfe,%zmm3,%zmm2,%zmm7
 18edb01:	62 f1 65 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm3
 18edb08:	62 f1 65 48 ef d1    	vpxord %zmm1,%zmm3,%zmm2
 18edb0e:	62 b1 75 48 fe d8    	vpaddd %zmm16,%zmm1,%zmm3
 18edb14:	62 f2 7d 48 44 d2    	vplzcntd %zmm2,%zmm2
 18edb1a:	62 f2 5d 40 45 d2    	vpsrlvd %zmm2,%zmm20,%zmm2
 18edb20:	62 f3 75 48 25 da 14 	vpternlogd $0x14,%zmm2,%zmm1,%zmm3
 18edb27:	62 f1 6d 48 72 f6 10 	vpslld $0x10,%zmm6,%zmm2
 18edb2e:	62 f2 7e 48 38 c8    	vpmovm2d %k0,%zmm1
 18edb34:	62 d1 fd 48 6f f6    	vmovdqa64 %zmm14,%zmm6
 18edb3a:	62 f1 0d 48 72 d0 1d 	vpsrld $0x1d,%zmm0,%zmm14
 18edb41:	62 f1 6d 48 72 e2 1f 	vpsrad $0x1f,%zmm2,%zmm2
 18edb48:	62 f3 5d 48 25 ca c8 	vpternlogd $0xc8,%zmm2,%zmm4,%zmm1
 18edb4f:	62 f1 5d 58 db 25 c3 8f cc fe 	vpandd -0x133703d(%rip){1to16},%zmm4,%zmm4        # 5b6b1c <tier0_emit_x87.operations+0xcc>
 18edb59:	62 d2 65 48 14 d6    	vprorvd %zmm14,%zmm3,%zmm2
 18edb5f:	62 d1 75 48 db cd    	vpandd %zmm13,%zmm1,%zmm1
 18edb65:	62 f1 6d 48 72 e2 1f 	vpsrad $0x1f,%zmm2,%zmm2
 18edb6c:	62 f3 6d 48 25 e1 b8 	vpternlogd $0xb8,%zmm1,%zmm2,%zmm4
 18edb73:	62 b1 55 48 fe d0    	vpaddd %zmm16,%zmm5,%zmm2
 18edb79:	62 f1 5d 48 eb cf    	vpord  %zmm7,%zmm4,%zmm1
 18edb7f:	62 f3 7d 58 25 0d 96 8f cc fe 20 	vpternlogd $0x20,-0x133706a(%rip){1to16},%zmm0,%zmm1        # 5b6b20 <tier0_emit_x87.operations+0xd0>
 18edb8a:	62 f1 7d 58 db 05 90 8f cc fe 	vpandd -0x1337070(%rip){1to16},%zmm0,%zmm0        # 5b6b24 <tier0_emit_x87.operations+0xd4>
 18edb94:	62 f1 6d 48 72 e2 1f 	vpsrad $0x1f,%zmm2,%zmm2
 18edb9b:	62 b1 fd 48 6f fb    	vmovdqa64 %zmm19,%zmm7
 18edba1:	62 f2 7d 48 55 c9    	vpopcntd %zmm1,%zmm1
 18edba7:	62 f1 6d 48 fe c0    	vpaddd %zmm0,%zmm2,%zmm0
 18edbad:	62 f1 7d 48 fe c1    	vpaddd %zmm1,%zmm0,%zmm0
 18edbb3:	c5 f9 6f 0d 95 e6 cb fe 	vmovdqa -0x134196b(%rip),%xmm1        # 5ac250 <x86_effects_unknown+0x280>
 18edbbb:	62 f2 75 48 8d c0    	vpermb %zmm0,%zmm1,%zmm0
 18edbc1:	62 f2 fd 18 40 0d 4d 8b cc fe 	vpmullq -0x13374b3(%rip){1to2},%xmm0,%xmm1        # 5b6718 <x86_semantics_benchmark_code.registers+0x120>
 18edbcb:	c4 e2 71 00 15 8c e6 cb fe 	vpshufb -0x1341974(%rip),%xmm1,%xmm2        # 5ac260 <x86_effects_unknown+0x290>
 18edbd4:	c5 e9 fc c9          	vpaddb %xmm1,%xmm2,%xmm1
 18edbd8:	62 d2 7d 48 7c d5    	vpbroadcastd %r13d,%zmm2
 18edbde:	c5 f1 f8 c0          	vpsubb %xmm0,%xmm1,%xmm0
 18edbe2:	c4 c3 79 14 cd 0f    	vpextrb $0xf,%xmm1,%r13d
 18edbe8:	62 f2 7d 48 31 c0    	vpmovzxbd %xmm0,%zmm0
 18edbee:	41 01 d5             	add    %edx,%r13d
 18edbf1:	62 f1 6d 48 fe c0    	vpaddd %zmm0,%zmm2,%zmm0
 18edbf7:	62 d1 fe 48 7f 04 8e 	vmovdqu64 %zmm0,(%r14,%rcx,4)
 18edbfe:	48 83 c1 20          	add    $0x20,%rcx
 18edc02:	4c 39 c9             	cmp    %r9,%rcx
 18edc05:	4c 89 f9             	mov    %r15,%rcx
 18edc08:	0f 86 b2 fd ff ff    	jbe    18ed9c0 <tier0_benchmark_run+0x6a0>
 18edc0e:	4c 89 cb             	mov    %r9,%rbx
 18edc11:	4c 29 fb             	sub    %r15,%rbx
 18edc14:	4c 89 44 24 10       	mov    %r8,0x10(%rsp)
 18edc19:	0f 86 92 03 00 00    	jbe    18edfb1 <tier0_benchmark_run+0xc91>
 18edc1f:	4c 89 fe             	mov    %r15,%rsi
 18edc22:	48 c1 e6 04          	shl    $0x4,%rsi
 18edc26:	48 03 74 24 50       	add    0x50(%rsp),%rsi
 18edc2b:	48 89 da             	mov    %rbx,%rdx
 18edc2e:	48 c1 e2 04          	shl    $0x4,%rdx
 18edc32:	48 8d bc 24 c0 01 00 00 	lea    0x1c0(%rsp),%rdi
 18edc3a:	62 71 fd 48 7f 44 24 0a 	vmovdqa64 %zmm8,0x280(%rsp)
 18edc42:	62 71 fd 48 7f 44 24 09 	vmovdqa64 %zmm8,0x240(%rsp)
 18edc4a:	62 71 fd 48 7f 44 24 08 	vmovdqa64 %zmm8,0x200(%rsp)
 18edc52:	62 71 fd 48 7f 44 24 07 	vmovdqa64 %zmm8,0x1c0(%rsp)
 18edc5a:	c5 f8 77             	vzeroupper
 18edc5d:	e8 3e c3 ea fe       	call   799fa0 <memcpy@plt>
 18edc62:	62 f1 fd 48 6f 44 24 07 	vmovdqa64 0x1c0(%rsp),%zmm0
 18edc6a:	62 f1 fd 48 6f 54 24 08 	vmovdqa64 0x200(%rsp),%zmm2
 18edc72:	62 f1 fd 48 6f 5c 24 09 	vmovdqa64 0x240(%rsp),%zmm3
 18edc7a:	62 f1 fd 48 6f 64 24 0a 	vmovdqa64 0x280(%rsp),%zmm4
 18edc82:	62 72 7d 48 58 2d 50 8e cc fe 	vpbroadcastd -0x13371b0(%rip),%zmm13        # 5b6adc <tier0_emit_x87.operations+0x8c>
 18edc8c:	62 f2 7d 48 5a 35 fa e5 cb fe 	vbroadcasti32x4 -0x1341a06(%rip),%zmm6        # 5ac290 <x86_effects_unknown+0x2c0>
 18edc96:	62 e2 7d 48 5a 15 d0 e5 cb fe 	vbroadcasti32x4 -0x1341a30(%rip),%zmm18        # 5ac270 <x86_effects_unknown+0x2a0>
 18edca0:	62 72 7d 48 58 3d 36 8e cc fe 	vpbroadcastd -0x13371ca(%rip),%zmm15        # 5b6ae0 <tier0_emit_x87.operations+0x90>
 18edcaa:	62 72 7d 48 5a 0d cc e5 cb fe 	vbroadcasti32x4 -0x1341a34(%rip),%zmm9        # 5ac280 <x86_effects_unknown+0x2b0>
 18edcb4:	62 71 fd 48 6f 35 42 8a c5 fe 	vmovdqa64 -0x13a75be(%rip),%zmm14        # 546700 <branch_sizing_patterns+0xa70>
 18edcbe:	62 e2 7d 48 58 25 24 8e cc fe 	vpbroadcastd -0x13371dc(%rip),%zmm20        # 5b6aec <tier0_emit_x87.operations+0x9c>
 18edcc8:	62 e2 7d 48 5a 0d ce e5 cb fe 	vbroadcasti32x4 -0x1341a32(%rip),%zmm17        # 5ac2a0 <x86_effects_unknown+0x2d0>
 18edcd2:	62 e2 7d 48 58 05 08 8e cc fe 	vpbroadcastd -0x13371f8(%rip),%zmm16        # 5b6ae4 <tier0_emit_x87.operations+0x94>
 18edcdc:	62 f2 7d 48 58 3d f2 8d cc fe 	vpbroadcastd -0x133720e(%rip),%zmm7        # 5b6ad8 <tier0_emit_x87.operations+0x88>
 18edce6:	62 e2 7d 48 58 2d 00 8e cc fe 	vpbroadcastd -0x1337200(%rip),%zmm21        # 5b6af0 <tier0_emit_x87.operations+0xa0>
 18edcf0:	62 e2 7d 48 58 3d fe 8d cc fe 	vpbroadcastd -0x1337202(%rip),%zmm23        # 5b6af8 <tier0_emit_x87.operations+0xa8>
 18edcfa:	62 e2 7d 48 58 35 f0 8d cc fe 	vpbroadcastd -0x1337210(%rip),%zmm22        # 5b6af4 <tier0_emit_x87.operations+0xa4>
 18edd04:	62 62 7d 48 58 0d f2 8d cc fe 	vpbroadcastd -0x133720e(%rip),%zmm25        # 5b6b00 <tier0_emit_x87.operations+0xb0>
 18edd0e:	62 62 7d 48 58 05 e4 8d cc fe 	vpbroadcastd -0x133721c(%rip),%zmm24        # 5b6afc <tier0_emit_x87.operations+0xac>
 18edd18:	62 62 7d 48 58 35 ee 8d cc fe 	vpbroadcastd -0x1337212(%rip),%zmm30        # 5b6b10 <tier0_emit_x87.operations+0xc0>
 18edd22:	62 62 7d 48 58 25 dc 8d cc fe 	vpbroadcastd -0x1337224(%rip),%zmm28        # 5b6b08 <tier0_emit_x87.operations+0xb8>
 18edd2c:	62 62 7d 48 58 3d de 8d cc fe 	vpbroadcastd -0x1337222(%rip),%zmm31        # 5b6b14 <tier0_emit_x87.operations+0xc4>
 18edd36:	62 62 7d 48 58 2d cc 8d cc fe 	vpbroadcastd -0x1337234(%rip),%zmm29        # 5b6b0c <tier0_emit_x87.operations+0xbc>
 18edd40:	62 62 7d 48 58 15 ba 8d cc fe 	vpbroadcastd -0x1337246(%rip),%zmm26        # 5b6b04 <tier0_emit_x87.operations+0xb4>
 18edd4a:	c5 fc 46 c8          	kxnorw %k0,%k0,%k1
 18edd4e:	48 8d 05 eb e6 36 0d 	lea    0xd36e6eb(%rip),%rax        # ec5c440 <x86_template_storage>
 18edd55:	62 53 1d 48 25 e4 ff 	vpternlogd $0xff,%zmm12,%zmm12,%zmm12
 18edd5c:	62 62 7d 48 58 1d 82 8d cc fe 	vpbroadcastd -0x133727e(%rip),%zmm27        # 5b6ae8 <tier0_emit_x87.operations+0x98>
 18edd66:	62 e2 7d 48 58 1d a8 8d cc fe 	vpbroadcastd -0x1337258(%rip),%zmm19        # 5b6b18 <tier0_emit_x87.operations+0xc8>
 18edd70:	62 72 7d 48 58 1d c2 8d cc fe 	vpbroadcastd -0x133723e(%rip),%zmm11        # 5b6b3c <tier0_emit_x87.operations+0xec>
 18edd7a:	62 72 7d 48 58 15 b4 8d cc fe 	vpbroadcastd -0x133724c(%rip),%zmm10        # 5b6b38 <tier0_emit_x87.operations+0xe8>
 18edd84:	4c 8b 4c 24 18       	mov    0x18(%rsp),%r9
 18edd89:	4c 8b 44 24 10       	mov    0x10(%rsp),%r8
 18edd8e:	48 8b 7c 24 30       	mov    0x30(%rsp),%rdi
 18edd93:	c4 41 39 ef c0       	vpxor  %xmm8,%xmm8,%xmm8
 18edd98:	62 f1 7d 48 62 ca    	vpunpckldq %zmm2,%zmm0,%zmm1
 18edd9e:	62 f1 65 48 62 ec    	vpunpckldq %zmm4,%zmm3,%zmm5
 18edda4:	62 f1 7d 48 6a c2    	vpunpckhdq %zmm2,%zmm0,%zmm0
 18eddaa:	62 f1 65 48 6a e4    	vpunpckhdq %zmm4,%zmm3,%zmm4
 18eddb0:	62 f1 fd 48 6c dc    	vpunpcklqdq %zmm4,%zmm0,%zmm3
 18eddb6:	62 f1 fd 48 6d c4    	vpunpckhqdq %zmm4,%zmm0,%zmm0
 18eddbc:	62 f1 f5 48 6d cd    	vpunpckhqdq %zmm5,%zmm1,%zmm1
 18eddc2:	62 f1 7d 48 72 f0 04 	vpslld $0x4,%zmm0,%zmm0
 18eddc9:	62 f2 cd 48 83 eb    	vpmultishiftqb %zmm3,%zmm6,%zmm5
 18eddcf:	62 f2 ed 40 83 e3    	vpmultishiftqb %zmm3,%zmm18,%zmm4
 18eddd5:	62 f2 b5 48 83 f3    	vpmultishiftqb %zmm3,%zmm9,%zmm6
 18edddb:	62 f2 75 48 27 c1    	vptestmd %zmm1,%zmm1,%k0
 18edde1:	62 d1 7d 48 db d5    	vpandd %zmm13,%zmm0,%zmm2
 18edde7:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 18eddeb:	62 d3 5d 48 25 ef d8 	vpternlogd $0xd8,%zmm15,%zmm4,%zmm5
 18eddf2:	62 f1 5d 48 72 f3 04 	vpslld $0x4,%zmm3,%zmm4
 18eddf9:	62 f2 7d 49 90 44 90 13 	vpgatherdd 0x4c(%rax,%zmm2,4),%zmm0{%k1}
 18ede01:	62 f1 6d 48 72 d3 1a 	vpsrld $0x1a,%zmm3,%zmm2
 18ede08:	62 b3 4d 48 25 e8 d8 	vpternlogd $0xd8,%zmm16,%zmm6,%zmm5
 18ede0f:	62 e1 fd 48 6f c7    	vmovdqa64 %zmm7,%zmm16
 18ede15:	62 f1 45 48 72 d3 08 	vpsrld $0x8,%zmm3,%zmm7
 18ede1c:	62 f2 75 40 00 f3    	vpshufb %zmm3,%zmm17,%zmm6
 18ede22:	62 b3 7d 40 25 dc 6c 	vpternlogd $0x6c,%zmm20,%zmm16,%zmm3
 18ede29:	62 f1 5d 48 72 e4 1f 	vpsrad $0x1f,%zmm4,%zmm4
 18ede30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 18ede35:	62 d2 6d 48 36 d6    	vpermd %zmm14,%zmm2,%zmm2
 18ede3b:	62 d1 65 48 fe dc    	vpaddd %zmm12,%zmm3,%zmm3
 18ede41:	62 b3 7d 40 25 fd 6c 	vpternlogd $0x6c,%zmm21,%zmm16,%zmm7
 18ede48:	c4 e2 61 f7 c0       	shlx   %ebx,%eax,%eax
 18ede4d:	62 d1 45 48 fe fc    	vpaddd %zmm12,%zmm7,%zmm7
 18ede53:	62 b3 4d 40 25 df ea 	vpternlogd $0xea,%zmm23,%zmm22,%zmm3
 18ede5a:	62 e1 5d 48 db ce    	vpandd %zmm6,%zmm4,%zmm17
 18ede60:	62 f1 05 48 72 f6 10 	vpslld $0x10,%zmm6,%zmm15
 18ede67:	62 d1 fd 48 6f f5    	vmovdqa64 %zmm13,%zmm6
 18ede6d:	f7 d0                	not    %eax
 18ede6f:	62 93 45 48 25 d8 f8 	vpternlogd $0xf8,%zmm24,%zmm7,%zmm3
 18ede76:	62 91 55 48 db f9    	vpandd %zmm25,%zmm5,%zmm7
 18ede7c:	62 f1 55 48 72 d5 03 	vpsrld $0x3,%zmm5,%zmm5
 18ede83:	c5 fb 92 c8          	kmovd  %eax,%k1
 18ede87:	62 f3 7d 48 25 fb f8 	vpternlogd $0xf8,%zmm3,%zmm0,%zmm7
 18ede8e:	62 93 7d 48 25 ec a2 	vpternlogd $0xa2,%zmm28,%zmm0,%zmm5
 18ede95:	62 f1 15 48 72 d0 1d 	vpsrld $0x1d,%zmm0,%zmm13
 18ede9c:	62 83 6d 48 25 ce ec 	vpternlogd $0xec,%zmm30,%zmm2,%zmm17
 18edea3:	62 92 45 48 3b da    	vpminud %zmm26,%zmm7,%zmm3
 18edea9:	62 92 55 48 3b d5    	vpminud %zmm29,%zmm5,%zmm2
 18edeaf:	62 d1 fd 48 6f fe    	vmovdqa64 %zmm14,%zmm7
 18edeb5:	62 83 7d 48 25 cf f8 	vpternlogd $0xf8,%zmm31,%zmm0,%zmm17
 18edebc:	62 e3 6d 48 25 cb fe 	vpternlogd $0xfe,%zmm3,%zmm2,%zmm17
 18edec3:	62 f1 65 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm3
 18edeca:	62 f1 65 48 ef d1    	vpxord %zmm1,%zmm3,%zmm2
 18eded0:	62 d1 75 48 fe dc    	vpaddd %zmm12,%zmm1,%zmm3
 18eded6:	62 f2 7d 48 44 d2    	vplzcntd %zmm2,%zmm2
 18ededc:	62 f2 25 40 45 d2    	vpsrlvd %zmm2,%zmm27,%zmm2
 18edee2:	62 f3 75 48 25 da 14 	vpternlogd $0x14,%zmm2,%zmm1,%zmm3
 18edee9:	62 d1 6d 48 72 e7 1f 	vpsrad $0x1f,%zmm15,%zmm2
 18edef0:	62 f2 7e 48 38 c8    	vpmovm2d %k0,%zmm1
 18edef6:	62 f3 5d 48 25 ca c8 	vpternlogd $0xc8,%zmm2,%zmm4,%zmm1
 18edefd:	62 f1 5d 58 db 25 15 8c cc fe 	vpandd -0x13373eb(%rip){1to16},%zmm4,%zmm4        # 5b6b1c <tier0_emit_x87.operations+0xcc>
 18edf07:	62 d2 65 48 14 d5    	vprorvd %zmm13,%zmm3,%zmm2
 18edf0d:	62 b1 75 48 db cb    	vpandd %zmm19,%zmm1,%zmm1
 18edf13:	62 f1 6d 48 72 e2 1f 	vpsrad $0x1f,%zmm2,%zmm2
 18edf1a:	62 f3 6d 48 25 e1 b8 	vpternlogd $0xb8,%zmm1,%zmm2,%zmm4
 18edf21:	62 d1 55 48 fe d4    	vpaddd %zmm12,%zmm5,%zmm2
 18edf27:	62 b1 5d 48 eb c9    	vpord  %zmm17,%zmm4,%zmm1
 18edf2d:	62 f3 7d 58 25 0d e8 8b cc fe 20 	vpternlogd $0x20,-0x1337418(%rip){1to16},%zmm0,%zmm1        # 5b6b20 <tier0_emit_x87.operations+0xd0>
 18edf38:	62 f1 7d 58 db 05 e2 8b cc fe 	vpandd -0x133741e(%rip){1to16},%zmm0,%zmm0        # 5b6b24 <tier0_emit_x87.operations+0xd4>
 18edf42:	62 f1 6d 48 72 e2 1f 	vpsrad $0x1f,%zmm2,%zmm2
 18edf49:	62 a1 fd 48 6f ca    	vmovdqa64 %zmm18,%zmm17
 18edf4f:	62 f2 7d 48 55 c9    	vpopcntd %zmm1,%zmm1
 18edf55:	62 f1 6d 48 fe c0    	vpaddd %zmm0,%zmm2,%zmm0
 18edf5b:	62 f1 7d 48 fe c1    	vpaddd %zmm1,%zmm0,%zmm0
 18edf61:	c5 f9 6f 0d e7 e2 cb fe 	vmovdqa -0x1341d19(%rip),%xmm1        # 5ac250 <x86_effects_unknown+0x280>
 18edf69:	62 f2 75 48 8d c0    	vpermb %zmm0,%zmm1,%zmm0
 18edf6f:	62 f2 fd 18 40 0d 9f 87 cc fe 	vpmullq -0x1337861(%rip){1to2},%xmm0,%xmm1        # 5b6718 <x86_semantics_benchmark_code.registers+0x120>
 18edf79:	c4 e2 71 00 15 de e2 cb fe 	vpshufb -0x1341d22(%rip),%xmm1,%xmm2        # 5ac260 <x86_effects_unknown+0x290>
 18edf82:	c5 e9 fc c9          	vpaddb %xmm1,%xmm2,%xmm1
 18edf86:	62 d2 7d 48 7c d5    	vpbroadcastd %r13d,%zmm2
 18edf8c:	c5 f1 f8 c0          	vpsubb %xmm0,%xmm1,%xmm0
 18edf90:	c4 e3 79 14 c8 0f    	vpextrb $0xf,%xmm1,%eax
 18edf96:	62 f2 7d 48 31 c0    	vpmovzxbd %xmm0,%zmm0
 18edf9c:	44 01 e8             	add    %r13d,%eax
 18edf9f:	41 89 c5             	mov    %eax,%r13d
 18edfa2:	62 f1 6d 48 fe c0    	vpaddd %zmm0,%zmm2,%zmm0
 18edfa8:	62 91 7e 49 7f 04 be 	vmovdqu32 %zmm0,(%r14,%r15,4){%k1}
 18edfaf:	eb 0a                	jmp    18edfbb <tier0_benchmark_run+0xc9b>
 18edfb1:	62 e2 7d 48 58 05 1d 8b cc fe 	vpbroadcastd -0x13374e3(%rip),%zmm16        # 5b6ad8 <tier0_emit_x87.operations+0x88>
 18edfbb:	4c 8b 74 24 48       	mov    0x48(%rsp),%r14
 18edfc0:	45 31 ff             	xor    %r15d,%r15d
 18edfc3:	48 8d 04 bd 00 00 00 00 	lea    0x0(,%rdi,4),%rax
 18edfcb:	44 89 e9             	mov    %r13d,%ecx
 18edfce:	48 01 c1             	add    %rax,%rcx
 18edfd1:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
 18edfd6:	48 81 f9 ff ff ff 7f 	cmp    $0x7fffffff,%rcx
 18edfdd:	0f 87 7d f5 ff ff    	ja     18ed560 <tier0_benchmark_run+0x240>
 18edfe3:	48 8b 8c 24 a0 00 00 00 	mov    0xa0(%rsp),%rcx
 18edfeb:	48 8b 94 24 c0 00 00 00 	mov    0xc0(%rsp),%rdx
 18edff3:	c7 01 00 00 00 00    	movl   $0x0,(%rcx)
 18edff9:	c7 02 00 00 00 00    	movl   $0x0,(%rdx)
 18edfff:	48 85 ff             	test   %rdi,%rdi
 18ee002:	0f 84 58 f5 ff ff    	je     18ed560 <tier0_benchmark_run+0x240>
 18ee008:	48 8b 54 24 70       	mov    0x70(%rsp),%rdx
 18ee00d:	4c 8d 70 0c          	lea    0xc(%rax),%r14
 18ee011:	48 8d 47 ff          	lea    -0x1(%rdi),%rax
 18ee015:	62 d2 7d 48 7c c9    	vpbroadcastd %r9d,%zmm1
 18ee01b:	62 d2 7d 48 7c c5    	vpbroadcastd %r13d,%zmm0
 18ee021:	4c 89 a4 24 b0 00 00 00 	mov    %r12,0xb0(%rsp)
 18ee029:	48 89 c6             	mov    %rax,%rsi
 18ee02c:	48 c1 ee 04          	shr    $0x4,%rsi
 18ee030:	4c 8d 1c 95 00 00 00 00 	lea    0x0(,%rdx,4),%r11
 18ee038:	4c 89 9c 24 98 00 00 00 	mov    %r11,0x98(%rsp)
 18ee040:	0f 84 3c 04 00 00    	je     18ee482 <tier0_benchmark_run+0x1162>
 18ee046:	4c 8b 4c 24 28       	mov    0x28(%rsp),%r9
 18ee04b:	48 8b 8c 24 a8 00 00 00 	mov    0xa8(%rsp),%rcx
 18ee053:	48 89 84 24 d8 00 00 00 	mov    %rax,0xd8(%rsp)
 18ee05b:	62 51 fd 48 6f e2    	vmovdqa64 %zmm10,%zmm12
 18ee061:	62 51 fd 48 6f eb    	vmovdqa64 %zmm11,%zmm13
 18ee067:	62 72 7d 48 58 15 bb 8a cc fe 	vpbroadcastd -0x1337545(%rip),%zmm10        # 5b6b2c <tier0_emit_x87.operations+0xdc>
 18ee071:	62 72 7d 48 58 1d b9 8a cc fe 	vpbroadcastd -0x1337547(%rip),%zmm11        # 5b6b34 <tier0_emit_x87.operations+0xe4>
 18ee07b:	62 72 7d 48 58 35 a3 8a cc fe 	vpbroadcastd -0x133755d(%rip),%zmm14        # 5b6b28 <tier0_emit_x87.operations+0xd8>
 18ee085:	62 72 7d 48 58 3d a1 8a cc fe 	vpbroadcastd -0x133755f(%rip),%zmm15        # 5b6b30 <tier0_emit_x87.operations+0xe0>
 18ee08f:	48 ff c6             	inc    %rsi
 18ee092:	c5 e9 ef d2          	vpxor  %xmm2,%xmm2,%xmm2
 18ee096:	49 89 ff             	mov    %rdi,%r15
 18ee099:	4c 89 b4 24 90 00 00 00 	mov    %r14,0x90(%rsp)
 18ee0a1:	48 83 e6 fe          	and    $0xfffffffffffffffe,%rsi
 18ee0a5:	49 8d 41 40          	lea    0x40(%r9),%rax
 18ee0a9:	48 89 84 24 28 01 00 00 	mov    %rax,0x128(%rsp)
 18ee0b1:	48 8d 41 40          	lea    0x40(%rcx),%rax
 18ee0b5:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
 18ee0ba:	c1 e1 06             	shl    $0x6,%ecx
 18ee0bd:	48 03 4c 24 40       	add    0x40(%rsp),%rcx
 18ee0c2:	48 89 84 24 20 01 00 00 	mov    %rax,0x120(%rsp)
 18ee0ca:	48 8d 04 11          	lea    (%rcx,%rdx,1),%rax
 18ee0ce:	4d 8d 0c 08          	lea    (%r8,%rcx,1),%r9
 18ee0d2:	49 8d 84 00 80 00 00 00 	lea    0x80(%r8,%rax,1),%rax
 18ee0da:	4c 89 8c 24 00 01 00 00 	mov    %r9,0x100(%rsp)
 18ee0e2:	4c 8b 8c 24 88 00 00 00 	mov    0x88(%rsp),%r9
 18ee0ea:	48 89 84 24 18 01 00 00 	mov    %rax,0x118(%rsp)
 18ee0f2:	4a 8d 04 19          	lea    (%rcx,%r11,1),%rax
 18ee0f6:	4c 8b 9c 24 80 00 00 00 	mov    0x80(%rsp),%r11
 18ee0fe:	49 8d 84 00 80 00 00 00 	lea    0x80(%r8,%rax,1),%rax
 18ee106:	48 89 84 24 10 01 00 00 	mov    %rax,0x110(%rsp)
 18ee10e:	48 8d 04 52          	lea    (%rdx,%rdx,2),%rax
 18ee112:	48 01 c8             	add    %rcx,%rax
 18ee115:	4d 01 d9             	add    %r11,%r9
 18ee118:	49 8d 84 00 80 00 00 00 	lea    0x80(%r8,%rax,1),%rax
 18ee120:	49 01 c9             	add    %rcx,%r9
 18ee123:	4b 8d 94 08 84 00 00 00 	lea    0x84(%r8,%r9,1),%rdx
 18ee12b:	45 31 c9             	xor    %r9d,%r9d
 18ee12e:	48 89 84 24 08 01 00 00 	mov    %rax,0x108(%rsp)
 18ee136:	4a 8d 04 19          	lea    (%rcx,%r11,1),%rax
 18ee13a:	31 c9                	xor    %ecx,%ecx
 18ee13c:	49 8d 84 00 84 00 00 00 	lea    0x84(%r8,%rax,1),%rax
 18ee144:	48 89 94 24 80 00 00 00 	mov    %rdx,0x80(%rsp)
 18ee14c:	48 89 84 24 f8 00 00 00 	mov    %rax,0xf8(%rsp)
 18ee154:	66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 cs nopw 0x0(%rax,%rax,1)
 18ee160:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 18ee165:	4c 8b ac 24 20 01 00 00 	mov    0x120(%rsp),%r13
 18ee16d:	4c 8b 94 24 28 01 00 00 	mov    0x128(%rsp),%r10
 18ee175:	4c 89 fb             	mov    %r15,%rbx
 18ee178:	48 83 eb 10          	sub    $0x10,%rbx
 18ee17c:	48 89 b4 24 88 00 00 00 	mov    %rsi,0x88(%rsp)
 18ee184:	48 8b 74 24 58       	mov    0x58(%rsp),%rsi
 18ee189:	c5 d1 ef ed          	vpxor  %xmm5,%xmm5,%xmm5
 18ee18d:	62 f1 fd 48 6f f0    	vmovdqa64 %zmm0,%zmm6
 18ee193:	4c 8b 84 24 00 01 00 00 	mov    0x100(%rsp),%r8
 18ee19b:	48 8b 94 24 10 01 00 00 	mov    0x110(%rsp),%rdx
 18ee1a3:	4c 8b 9c 24 f8 00 00 00 	mov    0xf8(%rsp),%r11
 18ee1ab:	48 8b bc 24 80 00 00 00 	mov    0x80(%rsp),%rdi
 18ee1b3:	c4 62 01 f7 f0       	shlx   %r15d,%eax,%r14d
 18ee1b8:	b8 ff ff 00 00       	mov    $0xffff,%eax
 18ee1bd:	41 f7 d6             	not    %r14d
 18ee1c0:	44 0f 43 f0          	cmovae %eax,%r14d
 18ee1c4:	48 8b 84 24 90 00 00 00 	mov    0x90(%rsp),%rax
 18ee1cc:	c4 c1 7b 92 ce       	kmovd  %r14d,%k1
 18ee1d1:	45 89 ce             	mov    %r9d,%r14d
 18ee1d4:	41 b9 ff ff ff ff    	mov    $0xffffffff,%r9d
 18ee1da:	62 d1 7e c9 6f 64 8d ff 	vmovdqu32 -0x40(%r13,%rcx,4),%zmm4{%k1}{z}
 18ee1e2:	62 d1 7e c9 6f 5c 8a ff 	vmovdqu32 -0x40(%r10,%rcx,4),%zmm3{%k1}{z}
 18ee1ea:	c4 e1 f8 90 d9       	kmovq  %k1,%k3
 18ee1ef:	c4 42 61 f7 c9       	shlx   %ebx,%r9d,%r9d
 18ee1f4:	41 f7 d1             	not    %r9d
 18ee1f7:	62 f3 5d 49 1e d1 01 	vpcmpltud %zmm1,%zmm4,%k2{%k1}
 18ee1fe:	62 f2 7d 4b 90 2c 9e 	vpgatherdd (%rsi,%zmm3,4),%zmm5{%k3}
 18ee205:	62 f1 65 48 fe db    	vpaddd %zmm3,%zmm3,%zmm3
 18ee20b:	c4 e1 f8 90 d9       	kmovq  %k1,%k3
 18ee210:	62 f2 7d 4a 90 34 a6 	vpgatherdd (%rsi,%zmm4,4),%zmm6{%k2}
 18ee217:	62 f1 4d 48 fa e5    	vpsubd %zmm5,%zmm6,%zmm4
 18ee21d:	62 d1 5d c9 fe e3    	vpaddd %zmm11,%zmm4,%zmm4{%k1}{z}
 18ee223:	62 d1 5d 48 fe ec    	vpaddd %zmm12,%zmm4,%zmm5
 18ee229:	62 d3 55 48 1e d5 01 	vpcmpltud %zmm13,%zmm5,%k2
 18ee230:	c5 d1 ef ed          	vpxor  %xmm5,%xmm5,%xmm5
 18ee234:	62 f2 7d 4b 90 2c d8 	vpgatherdd (%rax,%zmm3,8),%zmm5{%k3}
 18ee23b:	48 8b 84 24 08 01 00 00 	mov    0x108(%rsp),%rax
 18ee243:	c5 ec 41 c1          	kandw  %k1,%k2,%k0
 18ee247:	c5 78 93 e0          	kmovw  %k0,%r12d
 18ee24b:	45 09 e6             	or     %r12d,%r14d
 18ee24e:	4c 8b a4 24 18 01 00 00 	mov    0x118(%rsp),%r12
 18ee256:	48 83 fb 10          	cmp    $0x10,%rbx
 18ee25a:	bb ff ff 00 00       	mov    $0xffff,%ebx
 18ee25f:	44 0f 43 cb          	cmovae %ebx,%r9d
 18ee263:	49 83 c7 e0          	add    $0xffffffffffffffe0,%r15
 18ee267:	62 d1 55 48 db de    	vpandd %zmm14,%zmm5,%zmm3
 18ee26d:	62 d1 65 48 76 da    	vpcmpeqd %zmm10,%zmm3,%k3
 18ee273:	62 d2 7d 43 64 df    	vpblendmd %zmm15,%zmm16,%zmm3{%k3}
 18ee279:	62 f1 7d c9 6f db    	vmovdqa32 %zmm3,%zmm3{%k1}{z}
 18ee27f:	62 f1 7d ca 6f eb    	vmovdqa32 %zmm3,%zmm5{%k2}{z}
 18ee285:	62 d3 55 48 03 f0 0f 	valignd $0xf,%zmm8,%zmm5,%zmm6
 18ee28c:	62 d1 fd 48 7f 5c 88 01 	vmovdqa64 %zmm3,0x40(%r8,%rcx,4)
 18ee294:	62 d1 fd 48 7f 64 8c ff 	vmovdqa64 %zmm4,-0x40(%r12,%rcx,4)
 18ee29c:	62 f1 fd 48 7f 64 8a ff 	vmovdqa64 %zmm4,-0x40(%rdx,%rcx,4)
 18ee2a4:	c4 c1 7b 92 c9       	kmovd  %r9d,%k1
 18ee2a9:	62 f1 fd 48 7f 6c 88 ff 	vmovdqa64 %zmm5,-0x40(%rax,%rcx,4)
 18ee2b1:	c4 e1 f8 90 d9       	kmovq  %k1,%k3
 18ee2b6:	62 f1 4d 48 fe f5    	vpaddd %zmm5,%zmm6,%zmm6
 18ee2bc:	c5 d1 ef ed          	vpxor  %xmm5,%xmm5,%xmm5
 18ee2c0:	62 d3 cd 48 03 f8 07 	valignq $0x7,%zmm8,%zmm6,%zmm7
 18ee2c7:	62 f1 45 48 fe f6    	vpaddd %zmm6,%zmm7,%zmm6
 18ee2cd:	62 d3 cd 48 03 f8 06 	valignq $0x6,%zmm8,%zmm6,%zmm7
 18ee2d4:	62 f1 45 48 fe f6    	vpaddd %zmm6,%zmm7,%zmm6
 18ee2da:	62 d3 cd 48 03 f8 04 	valignq $0x4,%zmm8,%zmm6,%zmm7
 18ee2e1:	62 f1 4d 48 fe d2    	vpaddd %zmm2,%zmm6,%zmm2
 18ee2e7:	62 f1 fd 48 6f f0    	vmovdqa64 %zmm0,%zmm6
 18ee2ed:	62 f1 6d 48 fe d7    	vpaddd %zmm7,%zmm2,%zmm2
 18ee2f3:	62 d1 fe 48 7f 54 8b ff 	vmovdqu64 %zmm2,-0x40(%r11,%rcx,4)
 18ee2fb:	62 71 fe 48 7f 44 8f ff 	vmovdqu64 %zmm8,-0x40(%rdi,%rcx,4)
 18ee303:	62 f1 7d 48 70 d2 ff 	vpshufd $0xff,%zmm2,%zmm2
 18ee30a:	62 d1 7e c9 6f 64 8d 00 	vmovdqu32 0x0(%r13,%rcx,4),%zmm4{%k1}{z}
 18ee312:	62 d1 7e c9 6f 1c 8a 	vmovdqu32 (%r10,%rcx,4),%zmm3{%k1}{z}
 18ee319:	62 f3 ed 48 43 d2 ff 	vshufi64x2 $0xff,%zmm2,%zmm2,%zmm2
 18ee320:	62 f3 5d 49 1e d1 01 	vpcmpltud %zmm1,%zmm4,%k2{%k1}
 18ee327:	62 f2 7d 4b 90 2c 9e 	vpgatherdd (%rsi,%zmm3,4),%zmm5{%k3}
 18ee32e:	62 f1 65 48 fe db    	vpaddd %zmm3,%zmm3,%zmm3
 18ee334:	c4 e1 f8 90 d9       	kmovq  %k1,%k3
 18ee339:	62 f2 7d 4a 90 34 a6 	vpgatherdd (%rsi,%zmm4,4),%zmm6{%k2}
 18ee340:	48 8b b4 24 88 00 00 00 	mov    0x88(%rsp),%rsi
 18ee348:	62 f1 4d 48 fa e5    	vpsubd %zmm5,%zmm6,%zmm4
 18ee34e:	62 d1 5d c9 fe e3    	vpaddd %zmm11,%zmm4,%zmm4{%k1}{z}
 18ee354:	62 d1 5d 48 fe ec    	vpaddd %zmm12,%zmm4,%zmm5
 18ee35a:	62 d3 55 48 1e d5 01 	vpcmpltud %zmm13,%zmm5,%k2
 18ee361:	c5 d1 ef ed          	vpxor  %xmm5,%xmm5,%xmm5
 18ee365:	c5 ec 41 c1          	kandw  %k1,%k2,%k0
 18ee369:	c5 78 93 c8          	kmovw  %k0,%r9d
 18ee36d:	45 09 f1             	or     %r14d,%r9d
 18ee370:	4c 8b b4 24 90 00 00 00 	mov    0x90(%rsp),%r14
 18ee378:	62 d2 7d 4b 90 2c de 	vpgatherdd (%r14,%zmm3,8),%zmm5{%k3}
 18ee37f:	62 d1 55 48 db de    	vpandd %zmm14,%zmm5,%zmm3
 18ee385:	62 d1 65 48 76 da    	vpcmpeqd %zmm10,%zmm3,%k3
 18ee38b:	62 d2 7d 43 64 df    	vpblendmd %zmm15,%zmm16,%zmm3{%k3}
 18ee391:	62 f1 7d c9 6f db    	vmovdqa32 %zmm3,%zmm3{%k1}{z}
 18ee397:	62 f1 7d ca 6f eb    	vmovdqa32 %zmm3,%zmm5{%k2}{z}
 18ee39d:	62 d3 55 48 03 f0 0f 	valignd $0xf,%zmm8,%zmm5,%zmm6
 18ee3a4:	62 d1 fd 48 7f 5c 88 02 	vmovdqa64 %zmm3,0x80(%r8,%rcx,4)
 18ee3ac:	62 d1 fd 48 7f 24 8c 	vmovdqa64 %zmm4,(%r12,%rcx,4)
 18ee3b3:	62 f1 fd 48 7f 24 8a 	vmovdqa64 %zmm4,(%rdx,%rcx,4)
 18ee3ba:	62 f1 fd 48 7f 2c 88 	vmovdqa64 %zmm5,(%rax,%rcx,4)
 18ee3c1:	62 f1 4d 48 fe f5    	vpaddd %zmm5,%zmm6,%zmm6
 18ee3c7:	62 d3 cd 48 03 f8 07 	valignq $0x7,%zmm8,%zmm6,%zmm7
 18ee3ce:	62 f1 45 48 fe f6    	vpaddd %zmm6,%zmm7,%zmm6
 18ee3d4:	62 d3 cd 48 03 f8 06 	valignq $0x6,%zmm8,%zmm6,%zmm7
 18ee3db:	62 f1 45 48 fe f6    	vpaddd %zmm6,%zmm7,%zmm6
 18ee3e1:	62 d3 cd 48 03 f8 04 	valignq $0x4,%zmm8,%zmm6,%zmm7
 18ee3e8:	62 f1 4d 48 fe f7    	vpaddd %zmm7,%zmm6,%zmm6
 18ee3ee:	62 f1 4d 48 fe d2    	vpaddd %zmm2,%zmm6,%zmm2
 18ee3f4:	62 d1 fe 48 7f 14 8b 	vmovdqu64 %zmm2,(%r11,%rcx,4)
 18ee3fb:	62 f1 7d 48 70 d2 ff 	vpshufd $0xff,%zmm2,%zmm2
 18ee402:	62 71 fe 48 7f 04 8f 	vmovdqu64 %zmm8,(%rdi,%rcx,4)
 18ee409:	48 83 c1 20          	add    $0x20,%rcx
 18ee40d:	48 83 c6 fe          	add    $0xfffffffffffffffe,%rsi
 18ee411:	62 f3 ed 48 43 d2 ff 	vshufi64x2 $0xff,%zmm2,%zmm2,%zmm2
 18ee418:	0f 85 42 fd ff ff    	jne    18ee160 <tier0_benchmark_run+0xe40>
 18ee41e:	62 f2 7d 48 58 35 b4 86 cc fe 	vpbroadcastd -0x133794c(%rip),%zmm6        # 5b6adc <tier0_emit_x87.operations+0x8c>
 18ee428:	62 f1 fd 48 6f 3d ce 82 c5 fe 	vmovdqa64 -0x13a7d32(%rip),%zmm7        # 546700 <branch_sizing_patterns+0xa70>
 18ee432:	62 e2 7d 48 5a 0d 34 de cb fe 	vbroadcasti32x4 -0x13421cc(%rip),%zmm17        # 5ac270 <x86_effects_unknown+0x2a0>
 18ee43c:	f6 84 24 d8 00 00 00 10 	testb  $0x10,0xd8(%rsp)
 18ee444:	48 8b 7c 24 30       	mov    0x30(%rsp),%rdi
 18ee449:	4c 8b 5c 24 58       	mov    0x58(%rsp),%r11
 18ee44e:	4c 8b a4 24 b0 00 00 00 	mov    0xb0(%rsp),%r12
 18ee456:	4c 8b 84 24 a0 00 00 00 	mov    0xa0(%rsp),%r8
 18ee45e:	41 bf 00 00 00 00    	mov    $0x0,%r15d
 18ee464:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
 18ee469:	41 bd ff ff 00 00    	mov    $0xffff,%r13d
 18ee46f:	62 51 fd 48 6f d4    	vmovdqa64 %zmm12,%zmm10
 18ee475:	62 51 fd 48 6f dd    	vmovdqa64 %zmm13,%zmm11
 18ee47b:	74 26                	je     18ee4a3 <tier0_benchmark_run+0x1183>
 18ee47d:	e9 67 01 00 00       	jmp    18ee5e9 <tier0_benchmark_run+0x12c9>
 18ee482:	4c 8b 5c 24 58       	mov    0x58(%rsp),%r11
 18ee487:	4c 8b 84 24 a0 00 00 00 	mov    0xa0(%rsp),%r8
 18ee48f:	45 31 c9             	xor    %r9d,%r9d
 18ee492:	c5 e9 ef d2          	vpxor  %xmm2,%xmm2,%xmm2
 18ee496:	31 c9                	xor    %ecx,%ecx
 18ee498:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
 18ee49d:	41 bd ff ff 00 00    	mov    $0xffff,%r13d
 18ee4a3:	48 89 f8             	mov    %rdi,%rax
 18ee4a6:	48 29 c8             	sub    %rcx,%rax
 18ee4a9:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
 18ee4ae:	c5 d1 ef ed          	vpxor  %xmm5,%xmm5,%xmm5
 18ee4b2:	48 83 f8 10          	cmp    $0x10,%rax
 18ee4b6:	c4 e2 79 f7 c3       	shlx   %eax,%ebx,%eax
 18ee4bb:	f7 d0                	not    %eax
 18ee4bd:	41 0f 43 c5          	cmovae %r13d,%eax
 18ee4c1:	c5 fb 92 c8          	kmovd  %eax,%k1
 18ee4c5:	48 8b 84 24 a8 00 00 00 	mov    0xa8(%rsp),%rax
 18ee4cd:	62 f1 7e c9 6f 1c 8a 	vmovdqu32 (%rdx,%rcx,4),%zmm3{%k1}{z}
 18ee4d4:	c4 e1 f8 90 d1       	kmovq  %k1,%k2
 18ee4d9:	c4 e1 f8 90 d9       	kmovq  %k1,%k3
 18ee4de:	62 71 7e c9 6f 24 88 	vmovdqu32 (%rax,%rcx,4),%zmm12{%k1}{z}
 18ee4e5:	62 f1 65 48 fe e3    	vpaddd %zmm3,%zmm3,%zmm4
 18ee4eb:	62 d2 7d 4a 90 2c e6 	vpgatherdd (%r14,%zmm4,8),%zmm5{%k2}
 18ee4f2:	62 f3 1d 49 1e d1 01 	vpcmpltud %zmm1,%zmm12,%k2{%k1}
 18ee4f9:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
 18ee4fd:	62 d2 7d 4b 90 0c 9b 	vpgatherdd (%r11,%zmm3,4),%zmm1{%k3}
 18ee504:	62 f1 55 58 db 1d 1a 86 cc fe 	vpandd -0x13379e6(%rip){1to16},%zmm5,%zmm3        # 5b6b28 <tier0_emit_x87.operations+0xd8>
 18ee50e:	62 92 7d 4a 90 04 a3 	vpgatherdd (%r11,%zmm12,4),%zmm0{%k2}
 18ee515:	62 f1 65 58 76 15 0d 86 cc fe 	vpcmpeqd -0x13379f3(%rip){1to16},%zmm3,%k2        # 5b6b2c <tier0_emit_x87.operations+0xdc>
 18ee51f:	62 f1 7d 48 fa c1    	vpsubd %zmm1,%zmm0,%zmm0
 18ee525:	62 f2 7d 52 64 0d 01 86 cc fe 	vpblendmd -0x13379ff(%rip){1to16},%zmm16,%zmm1{%k2}        # 5b6b30 <tier0_emit_x87.operations+0xe0>
 18ee52f:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
 18ee534:	48 8b b4 24 e8 00 00 00 	mov    0xe8(%rsp),%rsi
 18ee53c:	48 8b 94 24 e0 00 00 00 	mov    0xe0(%rsp),%rdx
 18ee544:	62 f1 7d d9 fe 05 e6 85 cc fe 	vpaddd -0x1337a1a(%rip){1to16},%zmm0,%zmm0{%k1}{z}        # 5b6b34 <tier0_emit_x87.operations+0xe4>
 18ee54e:	62 f1 7d c9 6f c9    	vmovdqa32 %zmm1,%zmm1{%k1}{z}
 18ee554:	62 f1 fd 48 7f 0c 88 	vmovdqa64 %zmm1,(%rax,%rcx,4)
 18ee55b:	48 8b 84 24 c0 00 00 00 	mov    0xc0(%rsp),%rax
 18ee563:	62 f1 fd 48 7f 04 8e 	vmovdqa64 %zmm0,(%rsi,%rcx,4)
 18ee56a:	62 f1 fd 48 7f 04 8a 	vmovdqa64 %zmm0,(%rdx,%rcx,4)
 18ee571:	62 d1 7d 48 fe c2    	vpaddd %zmm10,%zmm0,%zmm0
 18ee577:	62 d3 7d 48 1e d3 01 	vpcmpltud %zmm11,%zmm0,%k2
 18ee57e:	62 f1 7d ca 6f c1    	vmovdqa32 %zmm1,%zmm0{%k2}{z}
 18ee584:	62 d3 7d 48 03 c8 0f 	valignd $0xf,%zmm8,%zmm0,%zmm1
 18ee58b:	c5 ec 41 c1          	kandw  %k1,%k2,%k0
 18ee58f:	62 d1 fd 48 7f 04 8c 	vmovdqa64 %zmm0,(%r12,%rcx,4)
 18ee596:	62 f1 75 48 fe c8    	vpaddd %zmm0,%zmm1,%zmm1
 18ee59c:	62 d3 f5 48 03 d8 07 	valignq $0x7,%zmm8,%zmm1,%zmm3
 18ee5a3:	62 f1 65 48 fe c9    	vpaddd %zmm1,%zmm3,%zmm1
 18ee5a9:	62 d3 f5 48 03 d8 06 	valignq $0x6,%zmm8,%zmm1,%zmm3
 18ee5b0:	62 f1 65 48 fe c9    	vpaddd %zmm1,%zmm3,%zmm1
 18ee5b6:	62 d3 f5 48 03 d8 04 	valignq $0x4,%zmm8,%zmm1,%zmm3
 18ee5bd:	62 f1 75 48 fe ca    	vpaddd %zmm2,%zmm1,%zmm1
 18ee5c3:	62 f1 75 48 fe cb    	vpaddd %zmm3,%zmm1,%zmm1
 18ee5c9:	62 d1 fe 48 7f 8c 88 04 00 00 00 	vmovdqu64 %zmm1,0x4(%r8,%rcx,4)
 18ee5d4:	62 71 fe 48 7f 84 88 04 00 00 00 	vmovdqu64 %zmm8,0x4(%rax,%rcx,4)
 18ee5df:	44 89 c9             	mov    %r9d,%ecx
 18ee5e2:	c5 78 93 c8          	kmovw  %k0,%r9d
 18ee5e6:	41 09 c9             	or     %ecx,%r9d
 18ee5e9:	4c 8b 74 24 78       	mov    0x78(%rsp),%r14
 18ee5ee:	45 85 c9             	test   %r9d,%r9d
 18ee5f1:	0f 84 08 07 00 00    	je     18eecff <tier0_benchmark_run+0x19df>
 18ee5f7:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
 18ee5fc:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
 18ee601:	81 e2 c0 ff ff 1f    	and    $0x1fffffc0,%edx
 18ee607:	31 f6                	xor    %esi,%esi
 18ee609:	48 83 c2 40          	add    $0x40,%rdx
 18ee60d:	c5 f8 77             	vzeroupper
 18ee610:	e8 6b b8 ea fe       	call   799e80 <memset@plt>
 18ee615:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
 18ee61a:	89 d0                	mov    %edx,%eax
 18ee61c:	83 e0 07             	and    $0x7,%eax
 18ee61f:	83 fa 08             	cmp    $0x8,%edx
 18ee622:	73 61                	jae    18ee685 <tier0_benchmark_run+0x1365>
 18ee624:	62 f2 7d 48 58 05 ae 84 cc fe 	vpbroadcastd -0x1337b52(%rip),%zmm0        # 5b6adc <tier0_emit_x87.operations+0x8c>
 18ee62e:	62 f1 fd 48 6f 0d c8 80 c5 fe 	vmovdqa64 -0x13a7f38(%rip),%zmm1        # 546700 <branch_sizing_patterns+0xa70>
 18ee638:	62 e2 7d 48 5a 0d 2e dc cb fe 	vbroadcasti32x4 -0x13423d2(%rip),%zmm17        # 5ac270 <x86_effects_unknown+0x2a0>
 18ee642:	62 f2 7d 48 5a 15 44 dc cb fe 	vbroadcasti32x4 -0x13423bc(%rip),%zmm2        # 5ac290 <x86_effects_unknown+0x2c0>
 18ee64c:	62 72 7d 48 5a 3d 2a dc cb fe 	vbroadcasti32x4 -0x13423d6(%rip),%zmm15        # 5ac280 <x86_effects_unknown+0x2b0>
 18ee656:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
 18ee65b:	4c 8b 44 24 10       	mov    0x10(%rsp),%r8
 18ee660:	4c 8b 4c 24 18       	mov    0x18(%rsp),%r9
 18ee665:	4c 8b 5c 24 60       	mov    0x60(%rsp),%r11
 18ee66a:	4c 8b bc 24 c8 00 00 00 	mov    0xc8(%rsp),%r15
 18ee672:	31 c9                	xor    %ecx,%ecx
 18ee674:	c4 41 39 ef c0       	vpxor  %xmm8,%xmm8,%xmm8
 18ee679:	62 f3 45 48 25 ff ff 	vpternlogd $0xff,%zmm7,%zmm7,%zmm7
 18ee680:	e9 c3 00 00 00       	jmp    18ee748 <tier0_benchmark_run+0x1428>
 18ee685:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
 18ee68a:	4c 8b 44 24 10       	mov    0x10(%rsp),%r8
 18ee68f:	4c 8b 5c 24 60       	mov    0x60(%rsp),%r11
 18ee694:	4c 8b bc 24 c8 00 00 00 	mov    0xc8(%rsp),%r15
 18ee69c:	83 e2 f8             	and    $0xfffffff8,%edx
 18ee69f:	31 c9                	xor    %ecx,%ecx
 18ee6a1:	66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 18ee6b0:	8b 34 8f             	mov    (%rdi,%rcx,4),%esi
 18ee6b3:	41 c6 04 30 01       	movb   $0x1,(%r8,%rsi,1)
 18ee6b8:	8b 74 8f 04          	mov    0x4(%rdi,%rcx,4),%esi
 18ee6bc:	41 c6 04 30 01       	movb   $0x1,(%r8,%rsi,1)
 18ee6c1:	8b 74 8f 08          	mov    0x8(%rdi,%rcx,4),%esi
 18ee6c5:	41 c6 04 30 01       	movb   $0x1,(%r8,%rsi,1)
 18ee6ca:	8b 74 8f 0c          	mov    0xc(%rdi,%rcx,4),%esi
 18ee6ce:	41 c6 04 30 01       	movb   $0x1,(%r8,%rsi,1)
 18ee6d3:	8b 74 8f 10          	mov    0x10(%rdi,%rcx,4),%esi
 18ee6d7:	41 c6 04 30 01       	movb   $0x1,(%r8,%rsi,1)
 18ee6dc:	8b 74 8f 14          	mov    0x14(%rdi,%rcx,4),%esi
 18ee6e0:	41 c6 04 30 01       	movb   $0x1,(%r8,%rsi,1)
 18ee6e5:	8b 74 8f 18          	mov    0x18(%rdi,%rcx,4),%esi
 18ee6e9:	41 c6 04 30 01       	movb   $0x1,(%r8,%rsi,1)
 18ee6ee:	8b 74 8f 1c          	mov    0x1c(%rdi,%rcx,4),%esi
 18ee6f2:	48 83 c1 08          	add    $0x8,%rcx
 18ee6f6:	41 c6 04 30 01       	movb   $0x1,(%r8,%rsi,1)
 18ee6fb:	48 39 ca             	cmp    %rcx,%rdx
 18ee6fe:	75 b0                	jne    18ee6b0 <tier0_benchmark_run+0x1390>
 18ee700:	62 f2 7d 48 58 05 d2 83 cc fe 	vpbroadcastd -0x1337c2e(%rip),%zmm0        # 5b6adc <tier0_emit_x87.operations+0x8c>
 18ee70a:	62 f1 fd 48 6f 0d ec 7f c5 fe 	vmovdqa64 -0x13a8014(%rip),%zmm1        # 546700 <branch_sizing_patterns+0xa70>
 18ee714:	62 e2 7d 48 5a 0d 52 db cb fe 	vbroadcasti32x4 -0x13424ae(%rip),%zmm17        # 5ac270 <x86_effects_unknown+0x2a0>
 18ee71e:	62 f2 7d 48 5a 15 68 db cb fe 	vbroadcasti32x4 -0x1342498(%rip),%zmm2        # 5ac290 <x86_effects_unknown+0x2c0>
 18ee728:	62 72 7d 48 5a 3d 4e db cb fe 	vbroadcasti32x4 -0x13424b2(%rip),%zmm15        # 5ac280 <x86_effects_unknown+0x2b0>
 18ee732:	4c 8b 4c 24 18       	mov    0x18(%rsp),%r9
 18ee737:	62 f3 45 48 25 ff ff 	vpternlogd $0xff,%zmm7,%zmm7,%zmm7
 18ee73e:	c4 41 39 ef c0       	vpxor  %xmm8,%xmm8,%xmm8
 18ee743:	48 85 c0             	test   %rax,%rax
 18ee746:	74 18                	je     18ee760 <tier0_benchmark_run+0x1440>
 18ee748:	48 8d 0c 8f          	lea    (%rdi,%rcx,4),%rcx
 18ee74c:	31 d2                	xor    %edx,%edx
 18ee74e:	66 90                	xchg   %ax,%ax
 18ee750:	8b 34 91             	mov    (%rcx,%rdx,4),%esi
 18ee753:	48 ff c2             	inc    %rdx
 18ee756:	41 c6 04 30 01       	movb   $0x1,(%r8,%rsi,1)
 18ee75b:	48 39 d0             	cmp    %rdx,%rax
 18ee75e:	75 f0                	jne    18ee750 <tier0_benchmark_run+0x1430>
 18ee760:	62 72 7d 48 58 15 ce 83 cc fe 	vpbroadcastd -0x1337c32(%rip),%zmm10        # 5b6b38 <tier0_emit_x87.operations+0xe8>
 18ee76a:	62 72 7d 48 58 1d c8 83 cc fe 	vpbroadcastd -0x1337c38(%rip),%zmm11        # 5b6b3c <tier0_emit_x87.operations+0xec>
 18ee774:	62 f1 fd 48 6f 25 02 81 c5 fe 	vmovdqa64 -0x13a7efe(%rip),%zmm4        # 546880 <branch_sizing_patterns+0xbf0>
 18ee77e:	62 f1 fd 48 6f 2d 38 81 c5 fe 	vmovdqa64 -0x13a7ec8(%rip),%zmm5        # 5468c0 <branch_sizing_patterns+0xc30>
 18ee788:	62 f2 7d 48 58 35 ae 83 cc fe 	vpbroadcastd -0x1337c52(%rip),%zmm6        # 5b6b40 <tier0_emit_x87.operations+0xf0>
 18ee792:	44 89 f8             	mov    %r15d,%eax
 18ee795:	83 e0 03             	and    $0x3,%eax
 18ee798:	62 71 fd 48 6f c8    	vmovdqa64 %zmm0,%zmm9
 18ee79e:	62 71 fd 48 6f e9    	vmovdqa64 %zmm1,%zmm13
 18ee7a4:	41 81 f9 c0 00 00 00 	cmp    $0xc0,%r9d
 18ee7ab:	73 0f                	jae    18ee7bc <tier0_benchmark_run+0x149c>
 18ee7ad:	31 ff                	xor    %edi,%edi
 18ee7af:	31 c9                	xor    %ecx,%ecx
 18ee7b1:	62 71 fd 48 6f e2    	vmovdqa64 %zmm2,%zmm12
 18ee7b7:	e9 54 01 00 00       	jmp    18ee910 <tier0_benchmark_run+0x15f0>
 18ee7bc:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
 18ee7c1:	c1 e1 06             	shl    $0x6,%ecx
 18ee7c4:	41 81 e7 fc ff ff 00 	and    $0xfffffc,%r15d
 18ee7cb:	49 8d 90 c0 00 00 00 	lea    0xc0(%r8),%rdx
 18ee7d2:	31 ff                	xor    %edi,%edi
 18ee7d4:	62 71 fd 48 6f e2    	vmovdqa64 %zmm2,%zmm12
 18ee7da:	49 8d 74 08 78       	lea    0x78(%r8,%rcx,1),%rsi
 18ee7df:	31 c9                	xor    %ecx,%ecx
 18ee7e1:	66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 18ee7f0:	62 f1 fd 48 6f 42 fd 	vmovdqa64 -0xc0(%rdx),%zmm0
 18ee7f7:	48 83 c1 04          	add    $0x4,%rcx
 18ee7fb:	62 f2 7d 48 26 c0    	vptestmb %zmm0,%zmm0,%k0
 18ee801:	c4 61 fb 93 c0       	kmovq  %k0,%r8
 18ee806:	f3 45 0f b8 d0       	popcnt %r8d,%r10d
 18ee80b:	45 89 c1             	mov    %r8d,%r9d
 18ee80e:	49 01 fa             	add    %rdi,%r10
 18ee811:	48 c1 e7 20          	shl    $0x20,%rdi
 18ee815:	4d 89 d3             	mov    %r10,%r11
 18ee818:	4d 0f a4 c3 20       	shld   $0x20,%r8,%r11
 18ee81d:	4c 09 cf             	or     %r9,%rdi
 18ee820:	49 c1 e8 20          	shr    $0x20,%r8
 18ee824:	48 89 7e c8          	mov    %rdi,-0x38(%rsi)
 18ee828:	f3 41 0f b8 f8       	popcnt %r8d,%edi
 18ee82d:	4c 89 5e d0          	mov    %r11,-0x30(%rsi)
 18ee831:	4c 01 d7             	add    %r10,%rdi
 18ee834:	62 f1 fd 48 6f 42 fe 	vmovdqa64 -0x80(%rdx),%zmm0
 18ee83b:	62 f2 7d 48 26 c0    	vptestmb %zmm0,%zmm0,%k0
 18ee841:	c4 61 fb 93 c0       	kmovq  %k0,%r8
 18ee846:	f3 45 0f b8 d0       	popcnt %r8d,%r10d
 18ee84b:	45 89 c1             	mov    %r8d,%r9d
 18ee84e:	49 01 fa             	add    %rdi,%r10
 18ee851:	48 c1 e7 20          	shl    $0x20,%rdi
 18ee855:	4d 89 d3             	mov    %r10,%r11
 18ee858:	4d 0f a4 c3 20       	shld   $0x20,%r8,%r11
 18ee85d:	4c 09 cf             	or     %r9,%rdi
 18ee860:	49 c1 e8 20          	shr    $0x20,%r8
 18ee864:	48 89 7e d8          	mov    %rdi,-0x28(%rsi)
 18ee868:	f3 41 0f b8 f8       	popcnt %r8d,%edi
 18ee86d:	4c 89 5e e0          	mov    %r11,-0x20(%rsi)
 18ee871:	4c 01 d7             	add    %r10,%rdi
 18ee874:	62 f1 fd 48 6f 42 ff 	vmovdqa64 -0x40(%rdx),%zmm0
 18ee87b:	62 f2 7d 48 26 c0    	vptestmb %zmm0,%zmm0,%k0
 18ee881:	c4 61 fb 93 c0       	kmovq  %k0,%r8
 18ee886:	f3 45 0f b8 d0       	popcnt %r8d,%r10d
 18ee88b:	45 89 c1             	mov    %r8d,%r9d
 18ee88e:	49 01 fa             	add    %rdi,%r10
 18ee891:	48 c1 e7 20          	shl    $0x20,%rdi
 18ee895:	4d 89 d3             	mov    %r10,%r11
 18ee898:	4d 0f a4 c3 20       	shld   $0x20,%r8,%r11
 18ee89d:	4c 09 cf             	or     %r9,%rdi
 18ee8a0:	49 c1 e8 20          	shr    $0x20,%r8
 18ee8a4:	48 89 7e e8          	mov    %rdi,-0x18(%rsi)
 18ee8a8:	f3 41 0f b8 f8       	popcnt %r8d,%edi
 18ee8ad:	4c 89 5e f0          	mov    %r11,-0x10(%rsi)
 18ee8b1:	4c 01 d7             	add    %r10,%rdi
 18ee8b4:	62 f1 fd 48 6f 02    	vmovdqa64 (%rdx),%zmm0
 18ee8ba:	48 81 c2 00 01 00 00 	add    $0x100,%rdx
 18ee8c1:	62 f2 7d 48 26 c0    	vptestmb %zmm0,%zmm0,%k0
 18ee8c7:	c4 61 fb 93 c0       	kmovq  %k0,%r8
 18ee8cc:	f3 45 0f b8 d0       	popcnt %r8d,%r10d
 18ee8d1:	45 89 c1             	mov    %r8d,%r9d
 18ee8d4:	49 01 fa             	add    %rdi,%r10
 18ee8d7:	48 c1 e7 20          	shl    $0x20,%rdi
 18ee8db:	4c 09 cf             	or     %r9,%rdi
 18ee8de:	48 89 7e f8          	mov    %rdi,-0x8(%rsi)
 18ee8e2:	4c 89 d7             	mov    %r10,%rdi
 18ee8e5:	4c 0f a4 c7 20       	shld   $0x20,%r8,%rdi
 18ee8ea:	49 c1 e8 20          	shr    $0x20,%r8
 18ee8ee:	48 89 3e             	mov    %rdi,(%rsi)
 18ee8f1:	f3 41 0f b8 f8       	popcnt %r8d,%edi
 18ee8f6:	48 83 c6 40          	add    $0x40,%rsi
 18ee8fa:	4c 01 d7             	add    %r10,%rdi
 18ee8fd:	49 39 cf             	cmp    %rcx,%r15
 18ee900:	0f 85 ea fe ff ff    	jne    18ee7f0 <tier0_benchmark_run+0x14d0>
 18ee906:	4c 8b 5c 24 60       	mov    0x60(%rsp),%r11
 18ee90b:	48 85 c0             	test   %rax,%rax
 18ee90e:	74 7a                	je     18ee98a <tier0_benchmark_run+0x166a>
 18ee910:	4c 8b 44 24 10       	mov    0x10(%rsp),%r8
 18ee915:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
 18ee91a:	48 89 ce             	mov    %rcx,%rsi
 18ee91d:	c1 e2 06             	shl    $0x6,%edx
 18ee920:	48 c1 e6 04          	shl    $0x4,%rsi
 18ee924:	48 c1 e1 06          	shl    $0x6,%rcx
 18ee928:	c1 e0 04             	shl    $0x4,%eax
 18ee92b:	48 01 d6             	add    %rdx,%rsi
 18ee92e:	49 8d 54 30 48       	lea    0x48(%r8,%rsi,1),%rdx
 18ee933:	4c 01 c1             	add    %r8,%rcx
 18ee936:	31 f6                	xor    %esi,%esi
 18ee938:	0f 1f 84 00 00 00 00 00 	nopl   0x0(%rax,%rax,1)
 18ee940:	62 f1 fd 48 6f 04 b1 	vmovdqa64 (%rcx,%rsi,4),%zmm0
 18ee947:	62 f2 7d 48 26 c0    	vptestmb %zmm0,%zmm0,%k0
 18ee94d:	c4 61 fb 93 c0       	kmovq  %k0,%r8
 18ee952:	f3 45 0f b8 d0       	popcnt %r8d,%r10d
 18ee957:	45 89 c1             	mov    %r8d,%r9d
 18ee95a:	49 01 fa             	add    %rdi,%r10
 18ee95d:	48 c1 e7 20          	shl    $0x20,%rdi
 18ee961:	4c 09 cf             	or     %r9,%rdi
 18ee964:	48 89 7c 32 f8       	mov    %rdi,-0x8(%rdx,%rsi,1)
 18ee969:	4c 89 d7             	mov    %r10,%rdi
 18ee96c:	4c 0f a4 c7 20       	shld   $0x20,%r8,%rdi
 18ee971:	49 c1 e8 20          	shr    $0x20,%r8
 18ee975:	48 89 3c 32          	mov    %rdi,(%rdx,%rsi,1)
 18ee979:	f3 41 0f b8 f8       	popcnt %r8d,%edi
 18ee97e:	48 83 c6 10          	add    $0x10,%rsi
 18ee982:	4c 01 d7             	add    %r10,%rdi
 18ee985:	48 39 f0             	cmp    %rsi,%rax
 18ee988:	75 b6                	jne    18ee940 <tier0_benchmark_run+0x1620>
 18ee98a:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
 18ee98f:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
 18ee994:	c1 e1 06             	shl    $0x6,%ecx
 18ee997:	4c 8b 4c 24 10       	mov    0x10(%rsp),%r9
 18ee99c:	48 8b 7c 24 30       	mov    0x30(%rsp),%rdi
 18ee9a1:	4c 8b 94 24 a8 00 00 00 	mov    0xa8(%rsp),%r10
 18ee9a9:	31 f6                	xor    %esi,%esi
 18ee9ab:	48 01 c0             	add    %rax,%rax
 18ee9ae:	48 89 fa             	mov    %rdi,%rdx
 18ee9b1:	48 01 c1             	add    %rax,%rcx
 18ee9b4:	48 03 4c 24 40       	add    0x40(%rsp),%rcx
 18ee9b9:	49 8d 4c 09 40       	lea    0x40(%r9,%rcx,1),%rcx
 18ee9be:	66 90                	xchg   %ax,%ax
 18ee9c0:	41 89 d0             	mov    %edx,%r8d
 18ee9c3:	48 83 ea 10          	sub    $0x10,%rdx
 18ee9c7:	c5 e9 ef d2          	vpxor  %xmm2,%xmm2,%xmm2
 18ee9cb:	c5 e1 ef db          	vpxor  %xmm3,%xmm3,%xmm3
 18ee9cf:	c4 62 39 f7 c3       	shlx   %r8d,%ebx,%r8d
 18ee9d4:	41 f7 d0             	not    %r8d
 18ee9d7:	45 0f 43 c5          	cmovae %r13d,%r8d
 18ee9db:	c4 c1 7b 92 c8       	kmovd  %r8d,%k1
 18ee9e0:	41 c1 e8 08          	shr    $0x8,%r8d
 18ee9e4:	62 d1 7e c9 6f 04 b2 	vmovdqu32 (%r10,%rsi,4),%zmm0{%k1}{z}
 18ee9eb:	62 f1 75 48 72 d0 05 	vpsrld $0x5,%zmm0,%zmm1
 18ee9f2:	62 f1 7d 48 db c6    	vpandd %zmm6,%zmm0,%zmm0
 18ee9f8:	62 d2 fd 49 90 14 ce 	vpgatherdq (%r14,%ymm1,8),%zmm2{%k1}
 18ee9ff:	62 f3 fd 48 3b c9 01 	vextracti64x4 $0x1,%zmm1,%ymm1
 18eea06:	c4 c1 7b 92 c8       	kmovd  %r8d,%k1
 18eea0b:	62 f2 45 48 47 c0    	vpsllvd %zmm0,%zmm7,%zmm0
 18eea11:	62 d2 fd 49 90 1c ce 	vpgatherdq (%r14,%ymm1,8),%zmm3{%k1}
 18eea18:	62 f1 fd 48 6f ca    	vmovdqa64 %zmm2,%zmm1
 18eea1e:	62 f2 5d 48 7e cb    	vpermt2d %zmm3,%zmm4,%zmm1
 18eea24:	62 f2 55 48 7e d3    	vpermt2d %zmm3,%zmm5,%zmm2
 18eea2a:	62 f1 7d 48 df c1    	vpandnd %zmm1,%zmm0,%zmm0
 18eea30:	62 f2 7d 48 55 c0    	vpopcntd %zmm0,%zmm0
 18eea36:	62 f1 7d 48 fe c2    	vpaddd %zmm2,%zmm0,%zmm0
 18eea3c:	62 f1 fd 48 7f 04 b1 	vmovdqa64 %zmm0,(%rcx,%rsi,4)
 18eea43:	48 83 c6 10          	add    $0x10,%rsi
 18eea47:	48 39 fe             	cmp    %rdi,%rsi
 18eea4a:	0f 82 70 ff ff ff    	jb     18ee9c0 <tier0_benchmark_run+0x16a0>
 18eea50:	4c 8b 44 24 70       	mov    0x70(%rsp),%r8
 18eea55:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
 18eea5a:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
 18eea5f:	c1 e1 06             	shl    $0x6,%ecx
 18eea62:	62 d1 fd 48 6f f1    	vmovdqa64 %zmm9,%zmm6
 18eea68:	45 31 f6             	xor    %r14d,%r14d
 18eea6b:	62 d1 fd 48 6f fd    	vmovdqa64 %zmm13,%zmm7
 18eea71:	62 51 fd 48 6f cf    	vmovdqa64 %zmm15,%zmm9
 18eea77:	48 01 c8             	add    %rcx,%rax
 18eea7a:	4b 8d 14 40          	lea    (%r8,%r8,2),%rdx
 18eea7e:	49 01 c8             	add    %rcx,%r8
 18eea81:	48 01 f0             	add    %rsi,%rax
 18eea84:	49 01 f0             	add    %rsi,%r8
 18eea87:	49 8d 5c 01 40       	lea    0x40(%r9,%rax,1),%rbx
 18eea8c:	b8 01 00 00 00       	mov    $0x1,%eax
 18eea91:	48 01 ca             	add    %rcx,%rdx
 18eea94:	4f 8d 6c 01 40       	lea    0x40(%r9,%r8,1),%r13
 18eea99:	48 01 f2             	add    %rsi,%rdx
 18eea9c:	4d 8d 7c 11 40       	lea    0x40(%r9,%rdx,1),%r15
 18eeaa1:	48 8b 94 24 98 00 00 00 	mov    0x98(%rsp),%rdx
 18eeaa9:	48 01 ca             	add    %rcx,%rdx
 18eeaac:	31 c9                	xor    %ecx,%ecx
 18eeaae:	48 01 f2             	add    %rsi,%rdx
 18eeab1:	4d 8d 64 11 40       	lea    0x40(%r9,%rdx,1),%r12
 18eeab6:	66 2e 0f 1f 84 00 00 00 00 00 	cs nopw 0x0(%rax,%rax,1)
 18eeac0:	83 f8 04             	cmp    $0x4,%eax
 18eeac3:	89 84 24 90 00 00 00 	mov    %eax,0x90(%rsp)
 18eeaca:	0f 92 c0             	setb   %al
 18eeacd:	08 c8                	or     %cl,%al
 18eeacf:	a8 01                	test   $0x1,%al
 18eead1:	74 1d                	je     18eeaf0 <tier0_benchmark_run+0x17d0>
 18eead3:	44 89 f0             	mov    %r14d,%eax
 18eead6:	48 8b 84 c4 a0 01 00 00 	mov    0x1a0(%rsp,%rax,8),%rax
 18eeade:	41 83 f6 01          	xor    $0x1,%r14d
 18eeae2:	e9 f9 00 00 00       	jmp    18eebe0 <tier0_benchmark_run+0x18c0>
 18eeae7:	66 0f 1f 84 00 00 00 00 00 	nopw   0x0(%rax,%rax,1)
 18eeaf0:	48 8d b4 24 68 01 00 00 	lea    0x168(%rsp),%rsi
 18eeaf8:	44 89 f2             	mov    %r14d,%edx
 18eeafb:	c5 f8 77             	vzeroupper
 18eeafe:	e8 5d d0 04 00       	call   193bb60 <branch_sizing_worklist>
 18eeb03:	44 89 f0             	mov    %r14d,%eax
 18eeb06:	83 f0 01             	xor    $0x1,%eax
 18eeb09:	48 8b 7c 24 30       	mov    0x30(%rsp),%rdi
 18eeb0e:	c4 41 39 ef c0       	vpxor  %xmm8,%xmm8,%xmm8
 18eeb13:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 18eeb17:	31 c9                	xor    %ecx,%ecx
 18eeb19:	48 8b 84 c4 a0 01 00 00 	mov    0x1a0(%rsp,%rax,8),%rax
 18eeb21:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
 18eeb27:	66 0f 1f 84 00 00 00 00 00 	nopw   0x0(%rax,%rax,1)
 18eeb30:	62 d1 fd 48 6f 0c 8f 	vmovdqa64 (%r15,%rcx,4),%zmm1
 18eeb37:	62 d3 75 48 03 d0 0f 	valignd $0xf,%zmm8,%zmm1,%zmm2
 18eeb3e:	62 f1 6d 48 fe c9    	vpaddd %zmm1,%zmm2,%zmm1
 18eeb44:	62 d3 f5 48 03 d0 07 	valignq $0x7,%zmm8,%zmm1,%zmm2
 18eeb4b:	62 f1 6d 48 fe c9    	vpaddd %zmm1,%zmm2,%zmm1
 18eeb51:	62 d3 f5 48 03 d0 06 	valignq $0x6,%zmm8,%zmm1,%zmm2
 18eeb58:	62 f1 6d 48 fe c9    	vpaddd %zmm1,%zmm2,%zmm1
 18eeb5e:	62 d3 f5 48 03 d0 04 	valignq $0x4,%zmm8,%zmm1,%zmm2
 18eeb65:	62 f1 75 48 fe c0    	vpaddd %zmm0,%zmm1,%zmm0
 18eeb6b:	62 f1 7d 48 fe c2    	vpaddd %zmm2,%zmm0,%zmm0
 18eeb71:	62 f1 fe 48 7f 84 88 04 00 00 00 	vmovdqu64 %zmm0,0x4(%rax,%rcx,4)
 18eeb7c:	62 f1 7d 48 70 c0 ff 	vpshufd $0xff,%zmm0,%zmm0
 18eeb83:	48 83 c1 10          	add    $0x10,%rcx
 18eeb87:	62 f3 fd 48 43 c0 ff 	vshufi64x2 $0xff,%zmm0,%zmm0,%zmm0
 18eeb8e:	48 39 f9             	cmp    %rdi,%rcx
 18eeb91:	72 9d                	jb     18eeb30 <tier0_benchmark_run+0x1810>
 18eeb93:	62 f2 7d 48 58 35 3f 7f cc fe 	vpbroadcastd -0x13380c1(%rip),%zmm6        # 5b6adc <tier0_emit_x87.operations+0x8c>
 18eeb9d:	62 f1 fd 48 6f 3d 59 7b c5 fe 	vmovdqa64 -0x13a84a7(%rip),%zmm7        # 546700 <branch_sizing_patterns+0xa70>
 18eeba7:	62 e2 7d 48 5a 0d bf d6 cb fe 	vbroadcasti32x4 -0x1342941(%rip),%zmm17        # 5ac270 <x86_effects_unknown+0x2a0>
 18eebb1:	62 72 7d 48 5a 25 d5 d6 cb fe 	vbroadcasti32x4 -0x134292b(%rip),%zmm12        # 5ac290 <x86_effects_unknown+0x2c0>
 18eebbb:	62 72 7d 48 5a 0d bb d6 cb fe 	vbroadcasti32x4 -0x1342945(%rip),%zmm9        # 5ac280 <x86_effects_unknown+0x2b0>
 18eebc5:	62 72 7d 48 58 15 69 7f cc fe 	vpbroadcastd -0x1338097(%rip),%zmm10        # 5b6b38 <tier0_emit_x87.operations+0xe8>
 18eebcf:	62 72 7d 48 58 1d 63 7f cc fe 	vpbroadcastd -0x133809d(%rip),%zmm11        # 5b6b3c <tier0_emit_x87.operations+0xec>
 18eebd9:	4c 8b 5c 24 60       	mov    0x60(%rsp),%r11
 18eebde:	b1 01                	mov    $0x1,%cl
 18eebe0:	44 89 f2             	mov    %r14d,%edx
 18eebe3:	4c 8b 84 d4 a0 01 00 00 	mov    0x1a0(%rsp,%rdx,8),%r8
 18eebeb:	45 89 f2             	mov    %r14d,%r10d
 18eebee:	31 d2                	xor    %edx,%edx
 18eebf0:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 18eebf4:	31 f6                	xor    %esi,%esi
 18eebf6:	41 c7 00 00 00 00 00 	movl   $0x0,(%r8)
 18eebfd:	0f 1f 00             	nopl   (%rax)
 18eec00:	62 f1 fd 48 6f 0c 93 	vmovdqa64 (%rbx,%rdx,4),%zmm1
 18eec07:	c5 fc 46 c8          	kxnorw %k0,%k0,%k1
 18eec0b:	c5 e1 ef db          	vpxor  %xmm3,%xmm3,%xmm3
 18eec0f:	62 d1 fd 48 6f 14 97 	vmovdqa64 (%r15,%rdx,4),%zmm2
 18eec16:	4d 89 c1             	mov    %r8,%r9
 18eec19:	62 f2 7d 49 90 1c 88 	vpgatherdd (%rax,%zmm1,4),%zmm3{%k1}
 18eec20:	62 f1 65 48 fa 8c 90 04 00 00 00 	vpsubd 0x4(%rax,%rdx,4),%zmm3,%zmm1
 18eec2b:	62 f2 6d 48 27 c2    	vptestmd %zmm2,%zmm2,%k0
 18eec31:	62 d1 75 48 fe 4c 95 00 	vpaddd 0x0(%r13,%rdx,4),%zmm1,%zmm1
 18eec39:	62 d1 75 48 fe da    	vpaddd %zmm10,%zmm1,%zmm3
 18eec3f:	62 d3 65 48 1e cb 01 	vpcmpltud %zmm11,%zmm3,%k1
 18eec46:	c5 fc 45 c9          	korw   %k1,%k0,%k1
 18eec4a:	62 d1 7d c9 6f 1c 93 	vmovdqa32 (%r11,%rdx,4),%zmm3{%k1}{z}
 18eec51:	62 d3 65 48 03 e0 0f 	valignd $0xf,%zmm8,%zmm3,%zmm4
 18eec58:	62 f3 65 48 1f c2 04 	vpcmpneqd %zmm2,%zmm3,%k0
 18eec5f:	62 d1 fd 48 7f 1c 97 	vmovdqa64 %zmm3,(%r15,%rdx,4)
 18eec66:	62 d1 fd 48 7f 0c 94 	vmovdqa64 %zmm1,(%r12,%rdx,4)
 18eec6d:	c5 78 93 c0          	kmovw  %k0,%r8d
 18eec71:	62 f1 5d 48 fe e3    	vpaddd %zmm3,%zmm4,%zmm4
 18eec77:	44 09 c6             	or     %r8d,%esi
 18eec7a:	4d 89 c8             	mov    %r9,%r8
 18eec7d:	62 d3 dd 48 03 e8 07 	valignq $0x7,%zmm8,%zmm4,%zmm5
 18eec84:	62 f1 55 48 fe e4    	vpaddd %zmm4,%zmm5,%zmm4
 18eec8a:	62 d3 dd 48 03 e8 06 	valignq $0x6,%zmm8,%zmm4,%zmm5
 18eec91:	62 f1 55 48 fe e4    	vpaddd %zmm4,%zmm5,%zmm4
 18eec97:	62 d3 dd 48 03 e8 04 	valignq $0x4,%zmm8,%zmm4,%zmm5
 18eec9e:	62 f1 5d 48 fe c0    	vpaddd %zmm0,%zmm4,%zmm0
 18eeca4:	62 f1 7d 48 fe c5    	vpaddd %zmm5,%zmm0,%zmm0
 18eecaa:	62 d1 fe 48 7f 84 91 04 00 00 00 	vmovdqu64 %zmm0,0x4(%r9,%rdx,4)
 18eecb5:	62 f1 7d 48 70 c0 ff 	vpshufd $0xff,%zmm0,%zmm0
 18eecbc:	48 83 c2 10          	add    $0x10,%rdx
 18eecc0:	62 f3 fd 48 43 c0 ff 	vshufi64x2 $0xff,%zmm0,%zmm0,%zmm0
 18eecc7:	48 39 fa             	cmp    %rdi,%rdx
 18eecca:	0f 82 30 ff ff ff    	jb     18eec00 <tier0_benchmark_run+0x18e0>
 18eecd0:	8b 84 24 90 00 00 00 	mov    0x90(%rsp),%eax
 18eecd7:	45 89 d6             	mov    %r10d,%r14d
 18eecda:	ff c0                	inc    %eax
 18eecdc:	85 f6                	test   %esi,%esi
 18eecde:	0f 85 dc fd ff ff    	jne    18eeac0 <tier0_benchmark_run+0x17a0>
 18eece4:	4c 8b 74 24 78       	mov    0x78(%rsp),%r14
 18eece9:	4c 8b a4 24 b0 00 00 00 	mov    0xb0(%rsp),%r12
 18eecf1:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
 18eecf6:	41 bd ff ff 00 00    	mov    $0xffff,%r13d
 18eecfc:	45 31 ff             	xor    %r15d,%r15d
 18eecff:	62 f1 fd 48 6f 15 f7 7b c5 fe 	vmovdqa64 -0x13a8409(%rip),%zmm2        # 546900 <branch_sizing_patterns+0xc70>
 18eed09:	31 c0                	xor    %eax,%eax
 18eed0b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
 18eed10:	62 d1 fd 48 6f 04 84 	vmovdqa64 (%r12,%rax,4),%zmm0
 18eed17:	48 89 c1             	mov    %rax,%rcx
 18eed1a:	62 f2 7d 48 27 c0    	vptestmd %zmm0,%zmm0,%k0
 18eed20:	c5 fb 93 c0          	kmovd  %k0,%eax
 18eed24:	0d 00 00 01 00       	or     $0x10000,%eax
 18eed29:	f3 0f bc c0          	tzcnt  %eax,%eax
 18eed2d:	48 01 c8             	add    %rcx,%rax
 18eed30:	c5 f8 98 c0          	kortestw %k0,%k0
 18eed34:	75 05                	jne    18eed3b <tier0_benchmark_run+0x1a1b>
 18eed36:	48 39 f8             	cmp    %rdi,%rax
 18eed39:	72 d5                	jb     18eed10 <tier0_benchmark_run+0x19f0>
 18eed3b:	4c 8b 5c 24 18       	mov    0x18(%rsp),%r11
 18eed40:	48 39 f8             	cmp    %rdi,%rax
 18eed43:	0f 83 a6 00 00 00    	jae    18eedef <tier0_benchmark_run+0x1acf>
 18eed49:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
 18eed4e:	8b 04 81             	mov    (%rcx,%rax,4),%eax
 18eed51:	83 e0 e0             	and    $0xffffffe0,%eax
 18eed54:	41 39 c3             	cmp    %eax,%r11d
 18eed57:	0f 86 92 00 00 00    	jbe    18eedef <tier0_benchmark_run+0x1acf>
 18eed5d:	4c 89 d9             	mov    %r11,%rcx
 18eed60:	48 29 c1             	sub    %rax,%rcx
 18eed63:	4d 89 c4             	mov    %r8,%r12
 18eed66:	66 2e 0f 1f 84 00 00 00 00 00 	cs nopw 0x0(%rax,%rax,1)
 18eed70:	89 ca                	mov    %ecx,%edx
 18eed72:	48 83 e9 10          	sub    $0x10,%rcx
 18eed76:	48 89 c6             	mov    %rax,%rsi
 18eed79:	89 c7                	mov    %eax,%edi
 18eed7b:	41 89 c0             	mov    %eax,%r8d
 18eed7e:	c4 e2 69 f7 d3       	shlx   %edx,%ebx,%edx
 18eed83:	f7 d2                	not    %edx
 18eed85:	41 0f 43 d5          	cmovae %r13d,%edx
 18eed89:	48 c1 ee 05          	shr    $0x5,%rsi
 18eed8d:	40 80 e7 10          	and    $0x10,%dil
 18eed91:	41 83 e0 10          	and    $0x10,%r8d
 18eed95:	49 8b 34 f6          	mov    (%r14,%rsi,8),%rsi
 18eed99:	c5 fb 92 ca          	kmovd  %edx,%k1
 18eed9d:	c4 e2 c3 f7 fe       	shrx   %rdi,%rsi,%rdi
 18eeda2:	c4 62 38 f5 c6       	bzhi   %r8d,%esi,%r8d
 18eeda7:	48 c1 ee 20          	shr    $0x20,%rsi
 18eedab:	62 f2 7d 48 7c c7    	vpbroadcastd %edi,%zmm0
 18eedb1:	48 8b 7c 24 58       	mov    0x58(%rsp),%rdi
 18eedb6:	49 8d 34 b4          	lea    (%r12,%rsi,4),%rsi
 18eedba:	f3 45 0f b8 c0       	popcnt %r8d,%r8d
 18eedbf:	62 f1 7d 48 db c2    	vpandd %zmm2,%zmm0,%zmm0
 18eedc5:	62 f2 7d 48 55 c0    	vpopcntd %zmm0,%zmm0
 18eedcb:	62 b2 7d 48 36 04 86 	vpermd (%rsi,%r8,4),%zmm0,%zmm0
 18eedd2:	62 f1 7e c9 6f 0c 87 	vmovdqu32 (%rdi,%rax,4),%zmm1{%k1}{z}
 18eedd9:	62 f1 75 48 fe c0    	vpaddd %zmm0,%zmm1,%zmm0
 18eeddf:	62 f1 7e 49 7f 04 87 	vmovdqu32 %zmm0,(%rdi,%rax,4){%k1}
 18eede6:	48 83 c0 10          	add    $0x10,%rax
 18eedea:	4c 39 d8             	cmp    %r11,%rax
 18eeded:	72 81                	jb     18eed70 <tier0_benchmark_run+0x1a50>
 18eedef:	4c 8b 6c 24 30       	mov    0x30(%rsp),%r13
 18eedf4:	44 89 e8             	mov    %r13d,%eax
 18eedf7:	83 e0 07             	and    $0x7,%eax
 18eedfa:	41 83 fd 08          	cmp    $0x8,%r13d
 18eedfe:	73 1b                	jae    18eee1b <tier0_benchmark_run+0x1afb>
 18eee00:	4c 8b 74 24 48       	mov    0x48(%rsp),%r14
 18eee05:	48 8b 5c 24 50       	mov    0x50(%rsp),%rbx
 18eee0a:	4c 8b 4c 24 10       	mov    0x10(%rsp),%r9
 18eee0f:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
 18eee14:	31 c9                	xor    %ecx,%ecx
 18eee16:	e9 7d 01 00 00       	jmp    18eef98 <tier0_benchmark_run+0x1c78>
 18eee1b:	48 8b 94 24 b8 00 00 00 	mov    0xb8(%rsp),%rdx
 18eee23:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
 18eee28:	c1 e1 06             	shl    $0x6,%ecx
 18eee2b:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
 18eee30:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
 18eee35:	4c 8b 74 24 48       	mov    0x48(%rsp),%r14
 18eee3a:	48 8b 5c 24 50       	mov    0x50(%rsp),%rbx
 18eee3f:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
 18eee44:	41 83 e5 f8          	and    $0xfffffff8,%r13d
 18eee48:	48 01 ca             	add    %rcx,%rdx
 18eee4b:	48 03 8c 24 98 00 00 00 	add    0x98(%rsp),%rcx
 18eee53:	48 01 f2             	add    %rsi,%rdx
 18eee56:	48 8d 54 17 5c       	lea    0x5c(%rdi,%rdx,1),%rdx
 18eee5b:	48 01 f1             	add    %rsi,%rcx
 18eee5e:	48 8d 74 0f 5c       	lea    0x5c(%rdi,%rcx,1),%rsi
 18eee63:	31 c9                	xor    %ecx,%ecx
 18eee65:	66 66 2e 0f 1f 84 00 00 00 00 00 	data16 cs nopw 0x0(%rax,%rax,1)
 18eee70:	41 8b 3c 8a          	mov    (%r10,%rcx,4),%edi
 18eee74:	44 8b 44 8a e4       	mov    -0x1c(%rdx,%rcx,4),%r8d
 18eee79:	44 8b 4c 8e e4       	mov    -0x1c(%rsi,%rcx,4),%r9d
 18eee7e:	48 c1 e7 04          	shl    $0x4,%rdi
 18eee82:	41 83 f8 01          	cmp    $0x1,%r8d
 18eee86:	44 89 4c 3b 04       	mov    %r9d,0x4(%rbx,%rdi,1)
 18eee8b:	66 83 5c 3b 0c ff    	sbbw   $0xffff,0xc(%rbx,%rdi,1)
 18eee91:	41 8b 7c 8a 04       	mov    0x4(%r10,%rcx,4),%edi
 18eee96:	44 8b 44 8a e8       	mov    -0x18(%rdx,%rcx,4),%r8d
 18eee9b:	44 8b 4c 8e e8       	mov    -0x18(%rsi,%rcx,4),%r9d
 18eeea0:	48 c1 e7 04          	shl    $0x4,%rdi
 18eeea4:	41 83 f8 01          	cmp    $0x1,%r8d
 18eeea8:	44 89 4c 3b 04       	mov    %r9d,0x4(%rbx,%rdi,1)
 18eeead:	66 83 5c 3b 0c ff    	sbbw   $0xffff,0xc(%rbx,%rdi,1)
 18eeeb3:	41 8b 7c 8a 08       	mov    0x8(%r10,%rcx,4),%edi
 18eeeb8:	44 8b 44 8a ec       	mov    -0x14(%rdx,%rcx,4),%r8d
 18eeebd:	44 8b 4c 8e ec       	mov    -0x14(%rsi,%rcx,4),%r9d
 18eeec2:	48 c1 e7 04          	shl    $0x4,%rdi
 18eeec6:	41 83 f8 01          	cmp    $0x1,%r8d
 18eeeca:	44 89 4c 3b 04       	mov    %r9d,0x4(%rbx,%rdi,1)
 18eeecf:	66 83 5c 3b 0c ff    	sbbw   $0xffff,0xc(%rbx,%rdi,1)
 18eeed5:	41 8b 7c 8a 0c       	mov    0xc(%r10,%rcx,4),%edi
 18eeeda:	44 8b 44 8a f0       	mov    -0x10(%rdx,%rcx,4),%r8d
 18eeedf:	44 8b 4c 8e f0       	mov    -0x10(%rsi,%rcx,4),%r9d
 18eeee4:	48 c1 e7 04          	shl    $0x4,%rdi
 18eeee8:	41 83 f8 01          	cmp    $0x1,%r8d
 18eeeec:	44 89 4c 3b 04       	mov    %r9d,0x4(%rbx,%rdi,1)
 18eeef1:	66 83 5c 3b 0c ff    	sbbw   $0xffff,0xc(%rbx,%rdi,1)
 18eeef7:	41 8b 7c 8a 10       	mov    0x10(%r10,%rcx,4),%edi
 18eeefc:	44 8b 44 8a f4       	mov    -0xc(%rdx,%rcx,4),%r8d
 18eef01:	44 8b 4c 8e f4       	mov    -0xc(%rsi,%rcx,4),%r9d
 18eef06:	48 c1 e7 04          	shl    $0x4,%rdi
 18eef0a:	41 83 f8 01          	cmp    $0x1,%r8d
 18eef0e:	44 89 4c 3b 04       	mov    %r9d,0x4(%rbx,%rdi,1)
 18eef13:	66 83 5c 3b 0c ff    	sbbw   $0xffff,0xc(%rbx,%rdi,1)
 18eef19:	41 8b 7c 8a 14       	mov    0x14(%r10,%rcx,4),%edi
 18eef1e:	44 8b 44 8a f8       	mov    -0x8(%rdx,%rcx,4),%r8d
 18eef23:	44 8b 4c 8e f8       	mov    -0x8(%rsi,%rcx,4),%r9d
 18eef28:	48 c1 e7 04          	shl    $0x4,%rdi
 18eef2c:	41 83 f8 01          	cmp    $0x1,%r8d
 18eef30:	44 89 4c 3b 04       	mov    %r9d,0x4(%rbx,%rdi,1)
 18eef35:	66 83 5c 3b 0c ff    	sbbw   $0xffff,0xc(%rbx,%rdi,1)
 18eef3b:	41 8b 7c 8a 18       	mov    0x18(%r10,%rcx,4),%edi
 18eef40:	44 8b 44 8a fc       	mov    -0x4(%rdx,%rcx,4),%r8d
 18eef45:	44 8b 4c 8e fc       	mov    -0x4(%rsi,%rcx,4),%r9d
 18eef4a:	48 c1 e7 04          	shl    $0x4,%rdi
 18eef4e:	41 83 f8 01          	cmp    $0x1,%r8d
 18eef52:	44 89 4c 3b 04       	mov    %r9d,0x4(%rbx,%rdi,1)
 18eef57:	66 83 5c 3b 0c ff    	sbbw   $0xffff,0xc(%rbx,%rdi,1)
 18eef5d:	41 8b 7c 8a 1c       	mov    0x1c(%r10,%rcx,4),%edi
 18eef62:	44 8b 04 8a          	mov    (%rdx,%rcx,4),%r8d
 18eef66:	44 8b 0c 8e          	mov    (%rsi,%rcx,4),%r9d
 18eef6a:	48 c1 e7 04          	shl    $0x4,%rdi
 18eef6e:	41 83 f8 01          	cmp    $0x1,%r8d
 18eef72:	44 89 4c 3b 04       	mov    %r9d,0x4(%rbx,%rdi,1)
 18eef77:	66 83 5c 3b 0c ff    	sbbw   $0xffff,0xc(%rbx,%rdi,1)
 18eef7d:	48 83 c1 08          	add    $0x8,%rcx
 18eef81:	49 39 cd             	cmp    %rcx,%r13
 18eef84:	0f 85 e6 fe ff ff    	jne    18eee70 <tier0_benchmark_run+0x1b50>
 18eef8a:	4c 8b 4c 24 10       	mov    0x10(%rsp),%r9
 18eef8f:	48 85 c0             	test   %rax,%rax
 18eef92:	0f 84 c8 e5 ff ff    	je     18ed560 <tier0_benchmark_run+0x240>
 18eef98:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
 18eef9d:	4c 8b 84 24 98 00 00 00 	mov    0x98(%rsp),%r8
 18eefa5:	4c 8b 9c 24 b8 00 00 00 	mov    0xb8(%rsp),%r11
 18eefad:	48 8b 7c 24 40       	mov    0x40(%rsp),%rdi
 18eefb2:	c1 e0 02             	shl    $0x2,%eax
 18eefb5:	c1 e6 06             	shl    $0x6,%esi
 18eefb8:	49 01 f0             	add    %rsi,%r8
 18eefbb:	49 01 f3             	add    %rsi,%r11
 18eefbe:	49 01 f8             	add    %rdi,%r8
 18eefc1:	49 01 fb             	add    %rdi,%r11
 18eefc4:	31 ff                	xor    %edi,%edi
 18eefc6:	49 8d 14 88          	lea    (%r8,%rcx,4),%rdx
 18eefca:	49 8d 34 8b          	lea    (%r11,%rcx,4),%rsi
 18eefce:	49 8d 0c 8a          	lea    (%r10,%rcx,4),%rcx
 18eefd2:	49 8d 54 11 40       	lea    0x40(%r9,%rdx,1),%rdx
 18eefd7:	49 8d 74 31 40       	lea    0x40(%r9,%rsi,1),%rsi
 18eefdc:	0f 1f 40 00          	nopl   0x0(%rax)
 18eefe0:	44 8b 04 39          	mov    (%rcx,%rdi,1),%r8d
 18eefe4:	44 8b 0c 3e          	mov    (%rsi,%rdi,1),%r9d
 18eefe8:	44 8b 14 3a          	mov    (%rdx,%rdi,1),%r10d
 18eefec:	49 c1 e0 04          	shl    $0x4,%r8
 18eeff0:	41 83 f9 01          	cmp    $0x1,%r9d
 18eeff4:	46 89 54 03 04       	mov    %r10d,0x4(%rbx,%r8,1)
 18eeff9:	66 42 83 5c 03 0c ff 	sbbw   $0xffff,0xc(%rbx,%r8,1)
 18ef000:	48 83 c7 04          	add    $0x4,%rdi
 18ef004:	48 39 f8             	cmp    %rdi,%rax
 18ef007:	75 d7                	jne    18eefe0 <tier0_benchmark_run+0x1cc0>
 18ef009:	e9 52 e5 ff ff       	jmp    18ed560 <tier0_benchmark_run+0x240>
 18ef00e:	45 31 ff             	xor    %r15d,%r15d
 18ef011:	31 db                	xor    %ebx,%ebx
 18ef013:	45 31 f6             	xor    %r14d,%r14d
 18ef016:	eb 4a                	jmp    18ef062 <tier0_benchmark_run+0x1d42>
 18ef018:	0f 1f 84 00 00 00 00 00 	nopl   0x0(%rax,%rax,1)
 18ef020:	49 8b 4d 20          	mov    0x20(%r13),%rcx
 18ef024:	49 8b 55 28          	mov    0x28(%r13),%rdx
 18ef028:	49 8b 45 10          	mov    0x10(%r13),%rax
 18ef02c:	4a 8b 0c f1          	mov    (%rcx,%r14,8),%rcx
 18ef030:	4a 8b 14 f2          	mov    (%rdx,%r14,8),%rdx
 18ef034:	4a 8b 3c f0          	mov    (%rax,%r14,8),%rdi
 18ef038:	e8 03 d2 04 00       	call   193c240 <x86_encode_16>
 18ef03d:	48 89 c1             	mov    %rax,%rcx
 18ef040:	48 c1 f9 3f          	sar    $0x3f,%rcx
 18ef044:	c4 e2 f0 f2 c8       	andn   %rax,%rcx,%rcx
 18ef049:	41 8b 45 30          	mov    0x30(%r13),%eax
 18ef04d:	49 01 cf             	add    %rcx,%r15
 18ef050:	49 ff c6             	inc    %r14
 18ef053:	48 83 c3 68          	add    $0x68,%rbx
 18ef057:	89 c1                	mov    %eax,%ecx
 18ef059:	49 39 ce             	cmp    %rcx,%r14
 18ef05c:	0f 83 13 e4 ff ff    	jae    18ed475 <tier0_benchmark_run+0x155>
 18ef062:	49 8b 4d 08          	mov    0x8(%r13),%rcx
 18ef066:	8b 74 19 08          	mov    0x8(%rcx,%rbx,1),%esi
 18ef06a:	48 81 fe 11 11 11 11 	cmp    $0x11111111,%rsi
 18ef071:	76 ad                	jbe    18ef020 <tier0_benchmark_run+0x1d00>
 18ef073:	31 c9                	xor    %ecx,%ecx
 18ef075:	eb d6                	jmp    18ef04d <tier0_benchmark_run+0x1d2d>
 18ef077:	48 8d 3d 1f 73 e1 fe 	lea    -0x11e8ce1(%rip),%rdi        # 70639d <pp_string_value.meaning+0x72de5>
 18ef07e:	48 8d 35 8f ec dc fe 	lea    -0x1231371(%rip),%rsi        # 6bdd14 <pp_string_value.meaning+0x2a75c>
 18ef085:	48 8d 0d a3 ec dc fe 	lea    -0x123135d(%rip),%rcx        # 6bdd2f <pp_string_value.meaning+0x2a777>
 18ef08c:	ba bf 00 00 00       	mov    $0xbf,%edx
 18ef091:	c5 f8 77             	vzeroupper
 18ef094:	e8 07 a6 ea fe       	call   7996a0 <__assert_fail@plt>
 18ef099:	c5 f8 77             	vzeroupper
 18ef09c:	e8 8f a5 ea fe       	call   799630 <__stack_chk_fail@plt>
