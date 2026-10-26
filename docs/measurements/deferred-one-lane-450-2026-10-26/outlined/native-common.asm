
work/campaign/native-images/head450-phase/build/compiler:     file format elf64-x86-64


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

0000000001080310 <check_input_run>:
 1080310:	55                   	push   %rbp
 1080311:	41 57                	push   %r15
 1080313:	41 56                	push   %r14
 1080315:	41 55                	push   %r13
 1080317:	41 54                	push   %r12
 1080319:	53                   	push   %rbx
 108031a:	48 81 ec c8 06 00 00 	sub    $0x6c8,%rsp
 1080321:	62 f1 fd 48 6f 0d 15 	vmovdqa64 -0xbe22eb(%rip),%zmm1        # 49e040 <cbuiltin_test_generated.edges+0x38c0>
 1080328:	dd 41 ff 
 108032b:	4c 89 4c 24 28       	mov    %r9,0x28(%rsp)
 1080330:	4c 89 04 24          	mov    %r8,(%rsp)
 1080334:	48 89 8c 24 18 01 00 	mov    %rcx,0x118(%rsp)
 108033b:	00 
 108033c:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 1080340:	c4 e2 79 22 15 77 df 	vpmovsxbq -0xbe2089(%rip),%xmm2        # 49e2c0 <cbuiltin_test_generated.edges+0x3b40>
 1080347:	41 ff 
 1080349:	49 89 f5             	mov    %rsi,%r13
 108034c:	64 48 8b 04 25 28 00 	mov    %fs:0x28,%rax
 1080353:	00 00 
 1080355:	48 89 84 24 c0 06 00 	mov    %rax,0x6c0(%rsp)
 108035c:	00 
 108035d:	62 f1 fe 48 7f 47 0e 	vmovdqu64 %zmm0,0x380(%rdi)
 1080364:	62 f1 fe 48 7f 47 0d 	vmovdqu64 %zmm0,0x340(%rdi)
 108036b:	62 f1 fe 48 7f 47 0c 	vmovdqu64 %zmm0,0x300(%rdi)
 1080372:	62 f1 fe 48 7f 47 0b 	vmovdqu64 %zmm0,0x2c0(%rdi)
 1080379:	62 f1 fe 48 7f 47 0a 	vmovdqu64 %zmm0,0x280(%rdi)
 1080380:	62 f1 fe 48 7f 47 09 	vmovdqu64 %zmm0,0x240(%rdi)
 1080387:	62 f1 fe 48 7f 47 08 	vmovdqu64 %zmm0,0x200(%rdi)
 108038e:	62 f1 fe 48 7f 47 07 	vmovdqu64 %zmm0,0x1c0(%rdi)
 1080395:	62 f1 fe 48 7f 47 06 	vmovdqu64 %zmm0,0x180(%rdi)
 108039c:	62 f1 fe 48 7f 47 05 	vmovdqu64 %zmm0,0x140(%rdi)
 10803a3:	62 f1 fe 48 7f 47 04 	vmovdqu64 %zmm0,0x100(%rdi)
 10803aa:	62 f1 fe 48 7f 47 03 	vmovdqu64 %zmm0,0xc0(%rdi)
 10803b1:	62 f1 fe 48 7f 47 02 	vmovdqu64 %zmm0,0x80(%rdi)
 10803b8:	62 f1 fe 48 7f 47 01 	vmovdqu64 %zmm0,0x40(%rdi)
 10803bf:	62 f1 fe 48 7f 07    	vmovdqu64 %zmm0,(%rdi)
 10803c5:	48 89 54 24 48       	mov    %rdx,0x48(%rsp)
 10803ca:	48 89 7c 24 08       	mov    %rdi,0x8(%rsp)
 10803cf:	44 8b 46 30          	mov    0x30(%rsi),%r8d
 10803d3:	62 f2 75 48 dc c8    	vaesenc %zmm0,%zmm1,%zmm1
 10803d9:	62 f2 75 48 dc c0    	vaesenc %zmm0,%zmm1,%zmm0
 10803df:	44 89 87 5c 03 00 00 	mov    %r8d,0x35c(%rdi)
 10803e6:	44 89 c0             	mov    %r8d,%eax
 10803e9:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
 10803ee:	4c 89 44 24 18       	mov    %r8,0x18(%rsp)
 10803f3:	31 c0                	xor    %eax,%eax
 10803f5:	48 8b 92 70 02 00 00 	mov    0x270(%rdx),%rdx
 10803fc:	62 f3 fd 48 3b c1 01 	vextracti64x4 $0x1,%zmm0,%ymm1
 1080403:	62 f1 f5 48 ef c0    	vpxorq %zmm0,%zmm1,%zmm0
 1080409:	c4 e3 7d 39 c1 01    	vextracti128 $0x1,%ymm0,%xmm1
 108040f:	4c 8b 62 08          	mov    0x8(%rdx),%r12
 1080413:	48 8b 3a             	mov    (%rdx),%rdi
 1080416:	c5 f1 ef c0          	vpxor  %xmm0,%xmm1,%xmm0
 108041a:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
 108041e:	c4 e2 79 dc c1       	vaesenc %xmm1,%xmm0,%xmm0
 1080423:	c5 f9 6f 0d 45 15 51 	vmovdqa -0xaeeabb(%rip),%xmm1        # 591970 <abi_test_hex.digits+0xae0>
 108042a:	ff 
 108042b:	c4 e1 f9 7e c1       	vmovq  %xmm0,%rcx
 1080430:	62 f2 7d 48 5a 05 36 	vbroadcasti32x4 -0xaeeaca(%rip),%zmm0        # 591970 <abi_test_hex.digits+0xae0>
 1080437:	15 51 ff 
 108043a:	4c 21 e1             	and    %r12,%rcx
 108043d:	0f 1f 00             	nopl   (%rax)
 1080440:	49 89 c8             	mov    %rcx,%r8
 1080443:	49 c1 e0 06          	shl    $0x6,%r8
 1080447:	62 b1 fd 48 6f 1c 07 	vmovdqa64 (%rdi,%r8,1),%zmm3
 108044e:	62 f1 65 48 76 c0    	vpcmpeqd %zmm0,%zmm3,%k0
 1080454:	c5 7b 93 c8          	kmovd  %k0,%r9d
 1080458:	41 81 e1 77 77 00 00 	and    $0x7777,%r9d
 108045f:	41 81 c1 11 11 00 00 	add    $0x1111,%r9d
 1080466:	66 41 81 e1 88 88    	and    $0x8888,%r9w
 108046c:	74 72                	je     10804e0 <check_input_run+0x1d0>
 108046e:	4c 8b 52 10          	mov    0x10(%rdx),%r10
 1080472:	49 01 f8             	add    %rdi,%r8
 1080475:	45 0f b7 c9          	movzwl %r9w,%r9d
 1080479:	eb 14                	jmp    108048f <check_input_run+0x17f>
 108047b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
 1080480:	45 31 db             	xor    %r11d,%r11d
 1080483:	45 84 db             	test   %r11b,%r11b
 1080486:	75 5b                	jne    10804e3 <check_input_run+0x1d3>
 1080488:	c4 c2 30 f3 c9       	blsr   %r9d,%r9d
 108048d:	74 54                	je     10804e3 <check_input_run+0x1d3>
 108048f:	45 31 db             	xor    %r11d,%r11d
 1080492:	f3 45 0f bc d9       	tzcnt  %r9d,%r11d
 1080497:	43 8b 1c 98          	mov    (%r8,%r11,4),%ebx
 108049b:	41 83 7c da 04 11    	cmpl   $0x11,0x4(%r10,%rbx,8)
 10804a1:	75 dd                	jne    1080480 <check_input_run+0x170>
 10804a3:	4c 8b 5a 40          	mov    0x40(%rdx),%r11
 10804a7:	45 8b 34 da          	mov    (%r10,%rbx,8),%r14d
 10804ab:	c4 81 71 ef 2c 33    	vpxor  (%r11,%r14,1),%xmm1,%xmm5
 10804b1:	43 0f b6 6c 33 10    	movzbl 0x10(%r11,%r14,1),%ebp
 10804b7:	c5 f9 6e e5          	vmovd  %ebp,%xmm4
 10804bb:	62 f3 dd 08 25 ea f6 	vpternlogq $0xf6,%xmm2,%xmm4,%xmm5
 10804c2:	c4 e2 79 17 ed       	vptest %xmm5,%xmm5
 10804c7:	41 0f 94 c3          	sete   %r11b
 10804cb:	0f 44 c3             	cmove  %ebx,%eax
 10804ce:	45 84 db             	test   %r11b,%r11b
 10804d1:	74 b5                	je     1080488 <check_input_run+0x178>
 10804d3:	eb 0e                	jmp    10804e3 <check_input_run+0x1d3>
 10804d5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 10804dc:	00 00 00 00 
 10804e0:	45 31 db             	xor    %r11d,%r11d
 10804e3:	62 f2 66 48 27 c3    	vptestnmd %zmm3,%zmm3,%k0
 10804e9:	c5 7b 93 c0          	kmovd  %k0,%r8d
 10804ed:	41 f7 c0 88 88 00 00 	test   $0x8888,%r8d
 10804f4:	75 0f                	jne    1080505 <check_input_run+0x1f5>
 10804f6:	48 ff c1             	inc    %rcx
 10804f9:	4c 21 e1             	and    %r12,%rcx
 10804fc:	45 84 db             	test   %r11b,%r11b
 10804ff:	0f 84 3b ff ff ff    	je     1080440 <check_input_run+0x130>
 1080505:	62 f1 fd 48 6f 0d b1 	vmovdqa64 -0xbe244f(%rip),%zmm1        # 49e0c0 <cbuiltin_test_generated.edges+0x3940>
 108050c:	db 41 ff 
 108050f:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 1080513:	c5 f9 6f 15 85 14 51 	vmovdqa -0xaeeb7b(%rip),%xmm2        # 5919a0 <abi_test_hex.digits+0xb10>
 108051a:	ff 
 108051b:	31 c9                	xor    %ecx,%ecx
 108051d:	62 f2 75 48 dc c8    	vaesenc %zmm0,%zmm1,%zmm1
 1080523:	62 f2 75 48 dc c0    	vaesenc %zmm0,%zmm1,%zmm0
 1080529:	62 f3 fd 48 3b c1 01 	vextracti64x4 $0x1,%zmm0,%ymm1
 1080530:	62 f1 f5 48 ef c0    	vpxorq %zmm0,%zmm1,%zmm0
 1080536:	c4 e3 7d 39 c1 01    	vextracti128 $0x1,%ymm0,%xmm1
 108053c:	c5 f1 ef c0          	vpxor  %xmm0,%xmm1,%xmm0
 1080540:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
 1080544:	c4 e2 79 dc c1       	vaesenc %xmm1,%xmm0,%xmm0
 1080549:	c5 f9 6f 0d 3f 14 51 	vmovdqa -0xaeebc1(%rip),%xmm1        # 591990 <abi_test_hex.digits+0xb00>
 1080550:	ff 
 1080551:	c4 c1 f9 7e c0       	vmovq  %xmm0,%r8
 1080556:	62 f2 7d 48 5a 05 30 	vbroadcasti32x4 -0xaeebd0(%rip),%zmm0        # 591990 <abi_test_hex.digits+0xb00>
 108055d:	14 51 ff 
 1080560:	4d 21 e0             	and    %r12,%r8
 1080563:	4d 89 c1             	mov    %r8,%r9
 1080566:	49 c1 e1 06          	shl    $0x6,%r9
 108056a:	62 b1 fd 48 6f 1c 0f 	vmovdqa64 (%rdi,%r9,1),%zmm3
 1080571:	62 f1 65 48 76 c0    	vpcmpeqd %zmm0,%zmm3,%k0
 1080577:	c5 7b 93 d0          	kmovd  %k0,%r10d
 108057b:	41 81 e2 77 77 00 00 	and    $0x7777,%r10d
 1080582:	41 81 c2 11 11 00 00 	add    $0x1111,%r10d
 1080589:	66 41 81 e2 88 88    	and    $0x8888,%r10w
 108058f:	74 5f                	je     10805f0 <check_input_run+0x2e0>
 1080591:	4c 8b 5a 10          	mov    0x10(%rdx),%r11
 1080595:	49 01 f9             	add    %rdi,%r9
 1080598:	45 0f b7 d2          	movzwl %r10w,%r10d
 108059c:	eb 0f                	jmp    10805ad <check_input_run+0x29d>
 108059e:	66 90                	xchg   %ax,%ax
 10805a0:	31 db                	xor    %ebx,%ebx
 10805a2:	84 db                	test   %bl,%bl
 10805a4:	75 4c                	jne    10805f2 <check_input_run+0x2e2>
 10805a6:	c4 c2 28 f3 ca       	blsr   %r10d,%r10d
 10805ab:	74 45                	je     10805f2 <check_input_run+0x2e2>
 10805ad:	31 db                	xor    %ebx,%ebx
 10805af:	f3 41 0f bc da       	tzcnt  %r10d,%ebx
 10805b4:	45 8b 34 99          	mov    (%r9,%rbx,4),%r14d
 10805b8:	43 83 7c f3 04 15    	cmpl   $0x15,0x4(%r11,%r14,8)
 10805be:	75 e0                	jne    10805a0 <check_input_run+0x290>
 10805c0:	48 8b 5a 40          	mov    0x40(%rdx),%rbx
 10805c4:	47 8b 3c f3          	mov    (%r11,%r14,8),%r15d
 10805c8:	c4 a1 71 ef 24 3b    	vpxor  (%rbx,%r15,1),%xmm1,%xmm4
 10805ce:	62 b3 ed 08 25 a4 3b 	vpternlogq $0xf6,0x5(%rbx,%r15,1),%xmm2,%xmm4
 10805d5:	05 00 00 00 f6 
 10805da:	c4 e2 79 17 e4       	vptest %xmm4,%xmm4
 10805df:	0f 94 c3             	sete   %bl
 10805e2:	41 0f 44 ce          	cmove  %r14d,%ecx
 10805e6:	84 db                	test   %bl,%bl
 10805e8:	74 bc                	je     10805a6 <check_input_run+0x296>
 10805ea:	eb 06                	jmp    10805f2 <check_input_run+0x2e2>
 10805ec:	0f 1f 40 00          	nopl   0x0(%rax)
 10805f0:	31 db                	xor    %ebx,%ebx
 10805f2:	62 f2 66 48 27 c3    	vptestnmd %zmm3,%zmm3,%k0
 10805f8:	c5 7b 93 c8          	kmovd  %k0,%r9d
 10805fc:	41 f7 c1 88 88 00 00 	test   $0x8888,%r9d
 1080603:	75 0b                	jne    1080610 <check_input_run+0x300>
 1080605:	49 ff c0             	inc    %r8
 1080608:	84 db                	test   %bl,%bl
 108060a:	0f 84 50 ff ff ff    	je     1080560 <check_input_run+0x250>
 1080610:	48 8b 7c 24 18       	mov    0x18(%rsp),%rdi
 1080615:	4c 89 6c 24 10       	mov    %r13,0x10(%rsp)
 108061a:	85 ff                	test   %edi,%edi
 108061c:	74 42                	je     1080660 <check_input_run+0x350>
 108061e:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
 1080623:	4d 89 ec             	mov    %r13,%r12
 1080626:	49 8b 75 10          	mov    0x10(%r13),%rsi
 108062a:	44 8b ac 24 08 07 00 	mov    0x708(%rsp),%r13d
 1080631:	00 
 1080632:	45 31 f6             	xor    %r14d,%r14d
 1080635:	44 8b 82 34 03 00 00 	mov    0x334(%rdx),%r8d
 108063c:	44 89 44 24 38       	mov    %r8d,0x38(%rsp)
 1080641:	44 8b 82 44 03 00 00 	mov    0x344(%rdx),%r8d
 1080648:	83 ff 01             	cmp    $0x1,%edi
 108064b:	75 4a                	jne    1080697 <check_input_run+0x387>
 108064d:	4c 8b 5c 24 58       	mov    0x58(%rsp),%r11
 1080652:	45 31 ff             	xor    %r15d,%r15d
 1080655:	31 d2                	xor    %edx,%edx
 1080657:	31 ed                	xor    %ebp,%ebp
 1080659:	31 db                	xor    %ebx,%ebx
 108065b:	e9 fd 01 00 00       	jmp    108085d <check_input_run+0x54d>
 1080660:	4c 8b 64 24 08       	mov    0x8(%rsp),%r12
 1080665:	44 8b ac 24 08 07 00 	mov    0x708(%rsp),%r13d
 108066c:	00 
 108066d:	45 31 f6             	xor    %r14d,%r14d
 1080670:	45 31 ff             	xor    %r15d,%r15d
 1080673:	48 c7 84 24 d0 00 00 	movq   $0x0,0xd0(%rsp)
 108067a:	00 00 00 00 00 
 108067f:	c7 84 24 98 00 00 00 	movl   $0x0,0x98(%rsp)
 1080686:	00 00 00 00 
 108068a:	41 8b ac 24 34 03 00 	mov    0x334(%r12),%ebp
 1080691:	00 
 1080692:	e9 7f 02 00 00       	jmp    1080916 <check_input_run+0x606>
 1080697:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
 108069c:	83 e2 fe             	and    $0xfffffffe,%edx
 108069f:	45 31 ff             	xor    %r15d,%r15d
 10806a2:	31 ed                	xor    %ebp,%ebp
 10806a4:	31 db                	xor    %ebx,%ebx
 10806a6:	48 89 54 24 60       	mov    %rdx,0x60(%rsp)
 10806ab:	31 d2                	xor    %edx,%edx
 10806ad:	eb 70                	jmp    108071f <check_input_run+0x40f>
 10806af:	90                   	nop
 10806b0:	0f b6 5c 24 40       	movzbl 0x40(%rsp),%ebx
 10806b5:	8b ac 24 98 00 00 00 	mov    0x98(%rsp),%ebp
 10806bc:	44 0a 6c 24 68       	or     0x68(%rsp),%r13b
 10806c1:	44 88 cf             	mov    %r9b,%dil
 10806c4:	41 88 db             	mov    %bl,%r11b
 10806c7:	89 d3                	mov    %edx,%ebx
 10806c9:	48 8b 94 24 d0 00 00 	mov    0xd0(%rsp),%rdx
 10806d0:	00 
 10806d1:	44 01 f5             	add    %r14d,%ebp
 10806d4:	45 20 ec             	and    %r13b,%r12b
 10806d7:	44 01 d5             	add    %r10d,%ebp
 10806da:	44 01 db             	add    %r11d,%ebx
 10806dd:	41 89 d2             	mov    %edx,%r10d
 10806e0:	89 fa                	mov    %edi,%edx
 10806e2:	01 da                	add    %ebx,%edx
 10806e4:	45 08 e2             	or     %r12b,%r10b
 10806e7:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
 10806ec:	49 8b 7c 24 18       	mov    0x18(%r12),%rdi
 10806f1:	42 8b 7c bf 04       	mov    0x4(%rdi,%r15,4),%edi
 10806f6:	85 ff                	test   %edi,%edi
 10806f8:	41 0f 95 c1          	setne  %r9b
 10806fc:	39 c7                	cmp    %eax,%edi
 10806fe:	41 0f 94 c3          	sete   %r11b
 1080702:	39 cf                	cmp    %ecx,%edi
 1080704:	0f 94 c3             	sete   %bl
 1080707:	49 83 c7 02          	add    $0x2,%r15
 108070b:	44 08 db             	or     %r11b,%bl
 108070e:	44 20 cb             	and    %r9b,%bl
 1080711:	44 08 d3             	or     %r10b,%bl
 1080714:	4c 39 7c 24 60       	cmp    %r15,0x60(%rsp)
 1080719:	0f 84 21 01 00 00    	je     1080840 <check_input_run+0x530>
 108071f:	48 89 9c 24 d0 00 00 	mov    %rbx,0xd0(%rsp)
 1080726:	00 
 1080727:	31 db                	xor    %ebx,%ebx
 1080729:	42 80 3c 3e 06       	cmpb   $0x6,(%rsi,%r15,1)
 108072e:	8b 7c 24 38          	mov    0x38(%rsp),%edi
 1080732:	4c 8b 54 24 08       	mov    0x8(%rsp),%r10
 1080737:	45 89 c1             	mov    %r8d,%r9d
 108073a:	41 be 00 00 00 00    	mov    $0x0,%r14d
 1080740:	89 ac 24 98 00 00 00 	mov    %ebp,0x98(%rsp)
 1080747:	0f 94 c3             	sete   %bl
 108074a:	45 31 c0             	xor    %r8d,%r8d
 108074d:	01 fb                	add    %edi,%ebx
 108074f:	41 89 9a 34 03 00 00 	mov    %ebx,0x334(%r10)
 1080756:	49 8b 7c 24 10       	mov    0x10(%r12),%rdi
 108075b:	42 80 3c 3f 3d       	cmpb   $0x3d,(%rdi,%r15,1)
 1080760:	41 0f 94 c0          	sete   %r8b
 1080764:	45 31 db             	xor    %r11d,%r11d
 1080767:	45 01 c8             	add    %r9d,%r8d
 108076a:	45 89 82 44 03 00 00 	mov    %r8d,0x344(%r10)
 1080771:	49 8b 7c 24 10       	mov    0x10(%r12),%rdi
 1080776:	4d 8b 54 24 50       	mov    0x50(%r12),%r10
 108077b:	46 0f b6 0c 3f       	movzbl (%rdi,%r15,1),%r9d
 1080780:	41 80 f9 40          	cmp    $0x40,%r9b
 1080784:	0f 94 44 24 40       	sete   0x40(%rsp)
 1080789:	4d 85 d2             	test   %r10,%r10
 108078c:	74 12                	je     10807a0 <check_input_run+0x490>
 108078e:	43 80 3c 3a 0b       	cmpb   $0xb,(%r10,%r15,1)
 1080793:	75 0b                	jne    10807a0 <check_input_run+0x490>
 1080795:	45 31 f6             	xor    %r14d,%r14d
 1080798:	41 80 f9 0c          	cmp    $0xc,%r9b
 108079c:	41 0f 94 c6          	sete   %r14b
 10807a0:	4d 8b 4c 24 18       	mov    0x18(%r12),%r9
 10807a5:	4c 89 e6             	mov    %r12,%rsi
 10807a8:	4c 8b 54 24 08       	mov    0x8(%rsp),%r10
 10807ad:	47 8b 0c b9          	mov    (%r9,%r15,4),%r9d
 10807b1:	45 85 c9             	test   %r9d,%r9d
 10807b4:	41 0f 95 c4          	setne  %r12b
 10807b8:	41 39 c1             	cmp    %eax,%r9d
 10807bb:	41 0f 94 c5          	sete   %r13b
 10807bf:	41 39 c9             	cmp    %ecx,%r9d
 10807c2:	0f 94 44 24 68       	sete   0x68(%rsp)
 10807c7:	45 31 c9             	xor    %r9d,%r9d
 10807ca:	42 80 7c 3f 01 06    	cmpb   $0x6,0x1(%rdi,%r15,1)
 10807d0:	41 0f 94 c1          	sete   %r9b
 10807d4:	44 01 cb             	add    %r9d,%ebx
 10807d7:	45 31 c9             	xor    %r9d,%r9d
 10807da:	41 89 9a 34 03 00 00 	mov    %ebx,0x334(%r10)
 10807e1:	89 5c 24 38          	mov    %ebx,0x38(%rsp)
 10807e5:	48 8b 7e 10          	mov    0x10(%rsi),%rdi
 10807e9:	42 80 7c 3f 01 3d    	cmpb   $0x3d,0x1(%rdi,%r15,1)
 10807ef:	41 0f 94 c1          	sete   %r9b
 10807f3:	45 01 c8             	add    %r9d,%r8d
 10807f6:	45 89 82 44 03 00 00 	mov    %r8d,0x344(%r10)
 10807fd:	48 8b 7e 10          	mov    0x10(%rsi),%rdi
 1080801:	48 8b 5e 50          	mov    0x50(%rsi),%rbx
 1080805:	42 0f b6 6c 3f 01    	movzbl 0x1(%rdi,%r15,1),%ebp
 108080b:	48 89 fe             	mov    %rdi,%rsi
 108080e:	31 ff                	xor    %edi,%edi
 1080810:	40 80 fd 40          	cmp    $0x40,%bpl
 1080814:	41 0f 94 c1          	sete   %r9b
 1080818:	45 31 d2             	xor    %r10d,%r10d
 108081b:	48 85 db             	test   %rbx,%rbx
 108081e:	0f 84 8c fe ff ff    	je     10806b0 <check_input_run+0x3a0>
 1080824:	42 80 7c 3b 01 0b    	cmpb   $0xb,0x1(%rbx,%r15,1)
 108082a:	0f 85 80 fe ff ff    	jne    10806b0 <check_input_run+0x3a0>
 1080830:	45 31 d2             	xor    %r10d,%r10d
 1080833:	40 80 fd 0c          	cmp    $0xc,%bpl
 1080837:	41 0f 94 c2          	sete   %r10b
 108083b:	e9 70 fe ff ff       	jmp    10806b0 <check_input_run+0x3a0>
 1080840:	4c 8b 5c 24 58       	mov    0x58(%rsp),%r11
 1080845:	44 8b ac 24 08 07 00 	mov    0x708(%rsp),%r13d
 108084c:	00 
 108084d:	41 be 00 00 00 00    	mov    $0x0,%r14d
 1080853:	41 f6 c3 01          	test   $0x1,%r11b
 1080857:	0f 84 97 00 00 00    	je     10808f4 <check_input_run+0x5e4>
 108085d:	45 31 c9             	xor    %r9d,%r9d
 1080860:	42 80 3c 3e 06       	cmpb   $0x6,(%rsi,%r15,1)
 1080865:	8b 7c 24 38          	mov    0x38(%rsp),%edi
 1080869:	4c 8b 54 24 08       	mov    0x8(%rsp),%r10
 108086e:	41 0f 94 c1          	sete   %r9b
 1080872:	41 01 f9             	add    %edi,%r9d
 1080875:	45 89 8a 34 03 00 00 	mov    %r9d,0x334(%r10)
 108087c:	44 89 4c 24 38       	mov    %r9d,0x38(%rsp)
 1080881:	45 31 c9             	xor    %r9d,%r9d
 1080884:	49 8b 7c 24 10       	mov    0x10(%r12),%rdi
 1080889:	42 80 3c 3f 3d       	cmpb   $0x3d,(%rdi,%r15,1)
 108088e:	41 0f 94 c1          	sete   %r9b
 1080892:	45 01 c1             	add    %r8d,%r9d
 1080895:	45 89 8a 44 03 00 00 	mov    %r9d,0x344(%r10)
 108089c:	49 8b 7c 24 10       	mov    0x10(%r12),%rdi
 10808a1:	4d 8b 4c 24 50       	mov    0x50(%r12),%r9
 10808a6:	46 0f b6 04 3f       	movzbl (%rdi,%r15,1),%r8d
 10808ab:	31 ff                	xor    %edi,%edi
 10808ad:	41 80 f8 40          	cmp    $0x40,%r8b
 10808b1:	40 0f 94 c7          	sete   %dil
 10808b5:	4d 85 c9             	test   %r9,%r9
 10808b8:	74 12                	je     10808cc <check_input_run+0x5bc>
 10808ba:	43 80 3c 39 0b       	cmpb   $0xb,(%r9,%r15,1)
 10808bf:	75 0b                	jne    10808cc <check_input_run+0x5bc>
 10808c1:	45 31 f6             	xor    %r14d,%r14d
 10808c4:	41 80 f8 0c          	cmp    $0xc,%r8b
 10808c8:	41 0f 94 c6          	sete   %r14b
 10808cc:	01 fa                	add    %edi,%edx
 10808ce:	49 8b 7c 24 18       	mov    0x18(%r12),%rdi
 10808d3:	41 01 ee             	add    %ebp,%r14d
 10808d6:	44 89 f5             	mov    %r14d,%ebp
 10808d9:	42 8b 34 bf          	mov    (%rdi,%r15,4),%esi
 10808dd:	85 f6                	test   %esi,%esi
 10808df:	40 0f 95 c7          	setne  %dil
 10808e3:	39 c6                	cmp    %eax,%esi
 10808e5:	0f 94 c0             	sete   %al
 10808e8:	39 ce                	cmp    %ecx,%esi
 10808ea:	0f 94 c1             	sete   %cl
 10808ed:	08 c1                	or     %al,%cl
 10808ef:	40 20 f9             	and    %dil,%cl
 10808f2:	08 cb                	or     %cl,%bl
 10808f4:	89 ac 24 98 00 00 00 	mov    %ebp,0x98(%rsp)
 10808fb:	4c 8b 64 24 08       	mov    0x8(%rsp),%r12
 1080900:	8b 6c 24 38          	mov    0x38(%rsp),%ebp
 1080904:	41 89 d6             	mov    %edx,%r14d
 1080907:	49 c1 e6 02          	shl    $0x2,%r14
 108090b:	4d 89 df             	mov    %r11,%r15
 108090e:	48 89 9c 24 d0 00 00 	mov    %rbx,0xd0(%rsp)
 1080915:	00 
 1080916:	48 8b 5c 24 28       	mov    0x28(%rsp),%rbx
 108091b:	48 8d bc 24 90 02 00 	lea    0x290(%rsp),%rdi
 1080922:	00 
 1080923:	ba 30 04 00 00       	mov    $0x430,%edx
 1080928:	31 f6                	xor    %esi,%esi
 108092a:	48 8b 43 08          	mov    0x8(%rbx),%rax
 108092e:	48 89 84 24 d0 01 00 	mov    %rax,0x1d0(%rsp)
 1080935:	00 
 1080936:	c5 f8 77             	vzeroupper
 1080939:	e8 42 e6 70 ff       	call   78ef80 <memset@plt>
 108093e:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
 1080943:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
 1080948:	48 8b 8c 24 18 01 00 	mov    0x118(%rsp),%rcx
 108094f:	00 
 1080950:	c4 e2 79 78 0d 69 d9 	vpbroadcastb -0xbe2697(%rip),%xmm1        # 49e2c2 <cbuiltin_test_generated.edges+0x3b42>
 1080957:	41 ff 
 1080959:	4c 89 a4 24 60 02 00 	mov    %r12,0x260(%rsp)
 1080960:	00 
 1080961:	48 8b 94 24 20 07 00 	mov    0x720(%rsp),%rdx
 1080968:	00 
 1080969:	c5 f9 76 c0          	vpcmpeqd %xmm0,%xmm0,%xmm0
 108096d:	4d 01 fe             	add    %r15,%r14
 1080970:	4c 89 7c 24 58       	mov    %r15,0x58(%rsp)
 1080975:	48 89 b4 24 68 02 00 	mov    %rsi,0x268(%rsp)
 108097c:	00 
 108097d:	48 89 84 24 70 02 00 	mov    %rax,0x270(%rsp)
 1080984:	00 
 1080985:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
 108098a:	48 89 8c 24 78 02 00 	mov    %rcx,0x278(%rsp)
 1080991:	00 
 1080992:	48 8b 0c 24          	mov    (%rsp),%rcx
 1080996:	8d 78 01             	lea    0x1(%rax),%edi
 1080999:	48 89 8c 24 80 02 00 	mov    %rcx,0x280(%rsp)
 10809a0:	00 
 10809a1:	48 89 9c 24 88 02 00 	mov    %rbx,0x288(%rsp)
 10809a8:	00 
 10809a9:	c7 84 24 20 03 00 00 	movl   $0xffffffff,0x320(%rsp)
 10809b0:	ff ff ff ff 
 10809b4:	c5 fa 7f 84 24 38 03 	vmovdqu %xmm0,0x338(%rsp)
 10809bb:	00 00 
 10809bd:	c5 fa 7f 84 24 44 03 	vmovdqu %xmm0,0x344(%rsp)
 10809c4:	00 00 
 10809c6:	c4 e3 71 22 cf 01    	vpinsrd $0x1,%edi,%xmm1,%xmm1
 10809cc:	48 89 bc 24 08 01 00 	mov    %rdi,0x108(%rsp)
 10809d3:	00 
 10809d4:	c5 fa 7f 8c 24 1c 06 	vmovdqu %xmm1,0x61c(%rsp)
 10809db:	00 00 
 10809dd:	89 84 24 30 06 00 00 	mov    %eax,0x630(%rsp)
 10809e4:	44 89 ac 24 34 06 00 	mov    %r13d,0x634(%rsp)
 10809eb:	00 
 10809ec:	48 89 94 24 a8 06 00 	mov    %rdx,0x6a8(%rsp)
 10809f3:	00 
 10809f4:	89 e8                	mov    %ebp,%eax
 10809f6:	49 8d 14 c6          	lea    (%r14,%rax,8),%rdx
 10809fa:	49 8d 44 c6 01       	lea    0x1(%r14,%rax,8),%rax
 10809ff:	c5 fa 7f 84 24 90 06 	vmovdqu %xmm0,0x690(%rsp)
 1080a06:	00 00 
 1080a08:	c7 84 24 a0 06 00 00 	movl   $0xffffffff,0x6a0(%rsp)
 1080a0f:	ff ff ff ff 
 1080a13:	48 89 94 24 88 00 00 	mov    %rdx,0x88(%rsp)
 1080a1a:	00 
 1080a1b:	48 89 84 24 d8 00 00 	mov    %rax,0xd8(%rsp)
 1080a22:	00 
 1080a23:	48 39 d9             	cmp    %rbx,%rcx
 1080a26:	0f 84 e1 00 00 00    	je     1080b0d <check_input_run+0x7fd>
 1080a2c:	83 be a0 00 00 00 00 	cmpl   $0x0,0xa0(%rsi)
 1080a33:	0f 85 d4 00 00 00    	jne    1080b0d <check_input_run+0x7fd>
 1080a39:	83 be a4 00 00 00 00 	cmpl   $0x0,0xa4(%rsi)
 1080a40:	0f 85 c7 00 00 00    	jne    1080b0d <check_input_run+0x7fd>
 1080a46:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
 1080a4b:	4c 8b 64 24 08       	mov    0x8(%rsp),%r12
 1080a50:	85 d2                	test   %edx,%edx
 1080a52:	0f 94 c0             	sete   %al
 1080a55:	48 83 7e 68 00       	cmpq   $0x0,0x68(%rsi)
 1080a5a:	0f 95 c1             	setne  %cl
 1080a5d:	08 c1                	or     %al,%cl
 1080a5f:	81 fa ff ff ff 3f    	cmp    $0x3fffffff,%edx
 1080a65:	0f 92 c0             	setb   %al
 1080a68:	20 c8                	and    %cl,%al
 1080a6a:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
 1080a6f:	48 39 8c 24 88 00 00 	cmp    %rcx,0x88(%rsp)
 1080a76:	00 
 1080a77:	0f 92 c1             	setb   %cl
 1080a7a:	41 39 d5             	cmp    %edx,%r13d
 1080a7d:	0f 96 c2             	setbe  %dl
 1080a80:	20 c2                	and    %al,%dl
 1080a82:	20 ca                	and    %cl,%dl
 1080a84:	80 fa 01             	cmp    $0x1,%dl
 1080a87:	0f 85 80 00 00 00    	jne    1080b0d <check_input_run+0x7fd>
 1080a8d:	4c 8d 35 6c a0 bf 00 	lea    0xbfa06c(%rip),%r14        # 1c7ab00 <type_builtins+0x200>
 1080a94:	45 31 e4             	xor    %r12d,%r12d
 1080a97:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
 1080a9e:	00 00 
 1080aa0:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
 1080aa5:	4d 8b 3e             	mov    (%r14),%r15
 1080aa8:	48 8b 98 70 02 00 00 	mov    0x270(%rax),%rbx
 1080aaf:	4c 89 ff             	mov    %r15,%rdi
 1080ab2:	e8 99 df 70 ff       	call   78ea50 <strlen@plt>
 1080ab7:	48 89 df             	mov    %rbx,%rdi
 1080aba:	4c 89 fe             	mov    %r15,%rsi
 1080abd:	89 c2                	mov    %eax,%edx
 1080abf:	e8 fc b5 fa ff       	call   102c0c0 <intern_find_or_add>
 1080ac4:	42 89 84 a4 64 06 00 	mov    %eax,0x664(%rsp,%r12,4)
 1080acb:	00 
 1080acc:	85 c0                	test   %eax,%eax
 1080ace:	74 0f                	je     1080adf <check_input_run+0x7cf>
 1080ad0:	49 83 c6 08          	add    $0x8,%r14
 1080ad4:	49 83 fc 09          	cmp    $0x9,%r12
 1080ad8:	4d 8d 64 24 01       	lea    0x1(%r12),%r12
 1080add:	72 c1                	jb     1080aa0 <check_input_run+0x790>
 1080adf:	4c 8b 64 24 08       	mov    0x8(%rsp),%r12
 1080ae4:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
 1080ae9:	48 8b bc 24 08 01 00 	mov    0x108(%rsp),%rdi
 1080af0:	00 
 1080af1:	85 c0                	test   %eax,%eax
 1080af3:	74 18                	je     1080b0d <check_input_run+0x7fd>
 1080af5:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
 1080afa:	48 8b 80 70 02 00 00 	mov    0x270(%rax),%rax
 1080b01:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
 1080b06:	31 c0                	xor    %eax,%eax
 1080b08:	e9 00 04 00 00       	jmp    1080f0d <check_input_run+0xbfd>
 1080b0d:	41 89 bc 24 34 02 00 	mov    %edi,0x234(%r12)
 1080b14:	00 
 1080b15:	4c 89 e7             	mov    %r12,%rdi
 1080b18:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
 1080b1d:	49 89 f6             	mov    %rsi,%r14
 1080b20:	4c 8d 8f 28 02 00 00 	lea    0x228(%rdi),%r9
 1080b27:	48 c7 87 28 02 00 00 	movq   $0x0,0x228(%rdi)
 1080b2e:	00 00 00 00 
 1080b32:	48 8b 34 24          	mov    (%rsp),%rsi
 1080b36:	48 8d 87 38 02 00 00 	lea    0x238(%rdi),%rax
 1080b3d:	48 c7 87 38 02 00 00 	movq   $0x0,0x238(%rdi)
 1080b44:	00 00 00 00 
 1080b48:	48 c7 87 40 02 00 00 	movq   $0x0,0x240(%rdi)
 1080b4f:	00 00 00 00 
 1080b53:	48 c7 87 48 02 00 00 	movq   $0x0,0x248(%rdi)
 1080b5a:	00 00 00 00 
 1080b5e:	48 c7 87 60 02 00 00 	movq   $0x0,0x260(%rdi)
 1080b65:	00 00 00 00 
 1080b69:	48 89 84 24 c0 00 00 	mov    %rax,0xc0(%rsp)
 1080b70:	00 
 1080b71:	48 8d 87 68 02 00 00 	lea    0x268(%rdi),%rax
 1080b78:	48 c7 87 68 02 00 00 	movq   $0x0,0x268(%rdi)
 1080b7f:	00 00 00 00 
 1080b83:	48 8d 8f 50 02 00 00 	lea    0x250(%rdi),%rcx
 1080b8a:	48 c7 87 50 02 00 00 	movq   $0x0,0x250(%rdi)
 1080b91:	00 00 00 00 
 1080b95:	48 89 8c 24 80 00 00 	mov    %rcx,0x80(%rsp)
 1080b9c:	00 
 1080b9d:	48 8d 8f 58 02 00 00 	lea    0x258(%rdi),%rcx
 1080ba4:	48 c7 87 58 02 00 00 	movq   $0x0,0x258(%rdi)
 1080bab:	00 00 00 00 
 1080baf:	48 c7 87 70 02 00 00 	movq   $0x0,0x270(%rdi)
 1080bb6:	00 00 00 00 
 1080bba:	48 89 8c 24 e8 00 00 	mov    %rcx,0xe8(%rsp)
 1080bc1:	00 
 1080bc2:	48 8d 8f 78 02 00 00 	lea    0x278(%rdi),%rcx
 1080bc9:	48 c7 87 78 02 00 00 	movq   $0x0,0x278(%rdi)
 1080bd0:	00 00 00 00 
 1080bd4:	48 89 8c 24 c8 00 00 	mov    %rcx,0xc8(%rsp)
 1080bdb:	00 
 1080bdc:	48 8d 8f 80 02 00 00 	lea    0x280(%rdi),%rcx
 1080be3:	48 c7 87 80 02 00 00 	movq   $0x0,0x280(%rdi)
 1080bea:	00 00 00 00 
 1080bee:	48 89 8c 24 00 01 00 	mov    %rcx,0x100(%rsp)
 1080bf5:	00 
 1080bf6:	48 8d 8f 88 02 00 00 	lea    0x288(%rdi),%rcx
 1080bfd:	48 c7 87 88 02 00 00 	movq   $0x0,0x288(%rdi)
 1080c04:	00 00 00 00 
 1080c08:	48 c7 87 90 02 00 00 	movq   $0x0,0x290(%rdi)
 1080c0f:	00 00 00 00 
 1080c13:	48 c7 87 98 02 00 00 	movq   $0x0,0x298(%rdi)
 1080c1a:	00 00 00 00 
 1080c1e:	48 89 8c 24 a8 00 00 	mov    %rcx,0xa8(%rsp)
 1080c25:	00 
 1080c26:	48 8d 8f a0 02 00 00 	lea    0x2a0(%rdi),%rcx
 1080c2d:	48 c7 87 a0 02 00 00 	movq   $0x0,0x2a0(%rdi)
 1080c34:	00 00 00 00 
 1080c38:	48 89 8c 24 f8 00 00 	mov    %rcx,0xf8(%rsp)
 1080c3f:	00 
 1080c40:	48 8d 8f a8 02 00 00 	lea    0x2a8(%rdi),%rcx
 1080c47:	48 c7 87 a8 02 00 00 	movq   $0x0,0x2a8(%rdi)
 1080c4e:	00 00 00 00 
 1080c52:	48 89 8c 24 20 01 00 	mov    %rcx,0x120(%rsp)
 1080c59:	00 
 1080c5a:	48 8d 8f b0 02 00 00 	lea    0x2b0(%rdi),%rcx
 1080c61:	48 c7 87 b0 02 00 00 	movq   $0x0,0x2b0(%rdi)
 1080c68:	00 00 00 00 
 1080c6c:	48 8d 97 b8 02 00 00 	lea    0x2b8(%rdi),%rdx
 1080c73:	48 c7 87 b8 02 00 00 	movq   $0x0,0x2b8(%rdi)
 1080c7a:	00 00 00 00 
 1080c7e:	48 89 94 24 28 01 00 	mov    %rdx,0x128(%rsp)
 1080c85:	00 
 1080c86:	48 8d 97 c0 02 00 00 	lea    0x2c0(%rdi),%rdx
 1080c8d:	48 c7 87 c0 02 00 00 	movq   $0x0,0x2c0(%rdi)
 1080c94:	00 00 00 00 
 1080c98:	48 c7 87 c8 02 00 00 	movq   $0x0,0x2c8(%rdi)
 1080c9f:	00 00 00 00 
 1080ca3:	48 c7 87 d0 02 00 00 	movq   $0x0,0x2d0(%rdi)
 1080caa:	00 00 00 00 
 1080cae:	48 89 94 24 c8 01 00 	mov    %rdx,0x1c8(%rsp)
 1080cb5:	00 
 1080cb6:	48 8d 97 d8 02 00 00 	lea    0x2d8(%rdi),%rdx
 1080cbd:	48 c7 87 d8 02 00 00 	movq   $0x0,0x2d8(%rdi)
 1080cc4:	00 00 00 00 
 1080cc8:	48 c7 87 e0 02 00 00 	movq   $0x0,0x2e0(%rdi)
 1080ccf:	00 00 00 00 
 1080cd3:	4c 8d 87 e0 02 00 00 	lea    0x2e0(%rdi),%r8
 1080cda:	48 c7 87 e8 02 00 00 	movq   $0x0,0x2e8(%rdi)
 1080ce1:	00 00 00 00 
 1080ce5:	4c 8d 97 f0 02 00 00 	lea    0x2f0(%rdi),%r10
 1080cec:	48 c7 87 f0 02 00 00 	movq   $0x0,0x2f0(%rdi)
 1080cf3:	00 00 00 00 
 1080cf7:	4c 8d 9f f8 02 00 00 	lea    0x2f8(%rdi),%r11
 1080cfe:	48 c7 87 f8 02 00 00 	movq   $0x0,0x2f8(%rdi)
 1080d05:	00 00 00 00 
 1080d09:	48 8d 9f 00 03 00 00 	lea    0x300(%rdi),%rbx
 1080d10:	48 c7 87 00 03 00 00 	movq   $0x0,0x300(%rdi)
 1080d17:	00 00 00 00 
 1080d1b:	48 c7 87 08 03 00 00 	movq   $0x0,0x308(%rdi)
 1080d22:	00 00 00 00 
 1080d26:	4c 8d bf 08 03 00 00 	lea    0x308(%rdi),%r15
 1080d2d:	48 c7 87 10 03 00 00 	movq   $0x0,0x310(%rdi)
 1080d34:	00 00 00 00 
 1080d38:	48 89 4c 24 50       	mov    %rcx,0x50(%rsp)
 1080d3d:	48 8d 8f 18 03 00 00 	lea    0x318(%rdi),%rcx
 1080d44:	4c 89 bc 24 10 01 00 	mov    %r15,0x110(%rsp)
 1080d4b:	00 
 1080d4c:	48 89 9c 24 e0 00 00 	mov    %rbx,0xe0(%rsp)
 1080d53:	00 
 1080d54:	4c 89 9c 24 b8 00 00 	mov    %r11,0xb8(%rsp)
 1080d5b:	00 
 1080d5c:	4c 89 94 24 90 00 00 	mov    %r10,0x90(%rsp)
 1080d63:	00 
 1080d64:	4c 89 44 24 78       	mov    %r8,0x78(%rsp)
 1080d69:	48 89 54 24 70       	mov    %rdx,0x70(%rsp)
 1080d6e:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
 1080d73:	48 c7 87 18 03 00 00 	movq   $0x0,0x318(%rdi)
 1080d7a:	00 00 00 00 
 1080d7e:	48 89 8c 24 c0 01 00 	mov    %rcx,0x1c0(%rsp)
 1080d85:	00 
 1080d86:	48 8d 87 48 03 00 00 	lea    0x348(%rdi),%rax
 1080d8d:	48 c7 87 48 03 00 00 	movq   $0x0,0x348(%rdi)
 1080d94:	00 00 00 00 
 1080d98:	31 db                	xor    %ebx,%ebx
 1080d9a:	45 31 ff             	xor    %r15d,%r15d
 1080d9d:	48 89 84 24 b8 01 00 	mov    %rax,0x1b8(%rsp)
 1080da4:	00 
 1080da5:	b8 50 03 00 00       	mov    $0x350,%eax
 1080daa:	4c 89 4c 24 20       	mov    %r9,0x20(%rsp)
 1080daf:	48 89 1c 07          	mov    %rbx,(%rdi,%rax,1)
 1080db3:	48 8b 87 40 02 00 00 	mov    0x240(%rdi),%rax
 1080dba:	48 8b 94 24 d8 00 00 	mov    0xd8(%rsp),%rdx
 1080dc1:	00 
 1080dc2:	48 8b 8c 24 08 01 00 	mov    0x108(%rsp),%rcx
 1080dc9:	00 
 1080dca:	48 89 fb             	mov    %rdi,%rbx
 1080dcd:	48 89 84 24 00 03 00 	mov    %rax,0x300(%rsp)
 1080dd4:	00 
 1080dd5:	48 8b 87 48 02 00 00 	mov    0x248(%rdi),%rax
 1080ddc:	48 89 84 24 60 03 00 	mov    %rax,0x360(%rsp)
 1080de3:	00 
 1080de4:	48 8b 87 60 02 00 00 	mov    0x260(%rdi),%rax
 1080deb:	48 89 84 24 90 03 00 	mov    %rax,0x390(%rsp)
 1080df2:	00 
 1080df3:	48 8b 87 68 02 00 00 	mov    0x268(%rdi),%rax
 1080dfa:	48 89 84 24 78 03 00 	mov    %rax,0x378(%rsp)
 1080e01:	00 
 1080e02:	48 8b 87 70 02 00 00 	mov    0x270(%rdi),%rax
 1080e09:	48 89 84 24 80 03 00 	mov    %rax,0x380(%rsp)
 1080e10:	00 
 1080e11:	48 8b 87 90 02 00 00 	mov    0x290(%rdi),%rax
 1080e18:	48 89 84 24 88 03 00 	mov    %rax,0x388(%rsp)
 1080e1f:	00 
 1080e20:	48 8b 87 98 02 00 00 	mov    0x298(%rdi),%rax
 1080e27:	48 89 84 24 68 03 00 	mov    %rax,0x368(%rsp)
 1080e2e:	00 
 1080e2f:	48 8b 87 e8 02 00 00 	mov    0x2e8(%rdi),%rax
 1080e36:	48 89 84 24 40 05 00 	mov    %rax,0x540(%rsp)
 1080e3d:	00 
 1080e3e:	48 8b 87 f0 02 00 00 	mov    0x2f0(%rdi),%rax
 1080e45:	48 89 84 24 48 05 00 	mov    %rax,0x548(%rsp)
 1080e4c:	00 
 1080e4d:	c5 f8 77             	vzeroupper
 1080e50:	e8 9b b7 00 00       	call   108c5f0 <check_graph_initialize>
 1080e55:	41 0f b6 4e 08       	movzbl 0x8(%r14),%ecx
 1080e5a:	83 c9 02             	or     $0x2,%ecx
 1080e5d:	89 8b 88 00 00 00    	mov    %ecx,0x88(%rbx)
 1080e63:	45 84 ff             	test   %r15b,%r15b
 1080e66:	0f 84 0a 03 00 00    	je     1081176 <check_input_run+0xe66>
 1080e6c:	84 c0                	test   %al,%al
 1080e6e:	0f 84 02 03 00 00    	je     1081176 <check_input_run+0xe66>
 1080e74:	48 8b 0c 24          	mov    (%rsp),%rcx
 1080e78:	48 8b 41 08          	mov    0x8(%rcx),%rax
 1080e7c:	48 8b 49 10          	mov    0x10(%rcx),%rcx
 1080e80:	48 29 c1             	sub    %rax,%rcx
 1080e83:	0f 82 ed 02 00 00    	jb     1081176 <check_input_run+0xe66>
 1080e89:	48 39 8c 24 88 00 00 	cmp    %rcx,0x88(%rsp)
 1080e90:	00 
 1080e91:	0f 83 df 02 00 00    	jae    1081176 <check_input_run+0xe66>
 1080e97:	48 8b 8c 24 d8 00 00 	mov    0xd8(%rsp),%rcx
 1080e9e:	00 
 1080e9f:	48 8b 3c 24          	mov    (%rsp),%rdi
 1080ea3:	48 01 c1             	add    %rax,%rcx
 1080ea6:	48 89 4f 08          	mov    %rcx,0x8(%rdi)
 1080eaa:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
 1080eaf:	48 03 07             	add    (%rdi),%rax
 1080eb2:	48 89 41 50          	mov    %rax,0x50(%rcx)
 1080eb6:	b9 b0 00 00 00       	mov    $0xb0,%ecx
 1080ebb:	74 1c                	je     1080ed9 <check_input_run+0xbc9>
 1080ebd:	48 8b 07             	mov    (%rdi),%rax
 1080ec0:	48 8b 77 08          	mov    0x8(%rdi),%rsi
 1080ec4:	48 8d 54 06 3f       	lea    0x3f(%rsi,%rax,1),%rdx
 1080ec9:	48 01 c6             	add    %rax,%rsi
 1080ecc:	48 83 e2 c0          	and    $0xffffffffffffffc0,%rdx
 1080ed0:	48 39 f2             	cmp    %rsi,%rdx
 1080ed3:	0f 83 e4 08 00 00    	jae    10817bd <check_input_run+0x14ad>
 1080ed9:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
 1080ede:	e9 a5 02 00 00       	jmp    1081188 <check_input_run+0xe78>
 1080ee3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1080eea:	84 00 00 00 00 00 
 1080ef0:	48 8b 84 24 f0 00 00 	mov    0xf0(%rsp),%rax
 1080ef7:	00 
 1080ef8:	44 89 b4 84 3c 06 00 	mov    %r14d,0x63c(%rsp,%rax,4)
 1080eff:	00 
 1080f00:	48 ff c0             	inc    %rax
 1080f03:	48 83 f8 05          	cmp    $0x5,%rax
 1080f07:	0f 84 be 34 00 00    	je     10843cb <check_input_run+0x40bb>
 1080f0d:	48 8d 0d 3c 9c bf 00 	lea    0xbf9c3c(%rip),%rcx        # 1c7ab50 <parse_predeclared_typedefs>
 1080f14:	48 89 84 24 f0 00 00 	mov    %rax,0xf0(%rsp)
 1080f1b:	00 
 1080f1c:	48 8b 1c c1          	mov    (%rcx,%rax,8),%rbx
 1080f20:	48 89 df             	mov    %rbx,%rdi
 1080f23:	c5 f8 77             	vzeroupper
 1080f26:	e8 25 db 70 ff       	call   78ea50 <strlen@plt>
 1080f2b:	c4 e1 fc 46 c8       	kxnorq %k0,%k0,%k1
 1080f30:	48 89 c2             	mov    %rax,%rdx
 1080f33:	41 89 d6             	mov    %edx,%r14d
 1080f36:	83 fa 3f             	cmp    $0x3f,%edx
 1080f39:	77 11                	ja     1080f4c <check_input_run+0xc3c>
 1080f3b:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
 1080f42:	c4 e2 88 f5 c0       	bzhi   %r14,%rax,%rax
 1080f47:	c4 e1 fb 92 c8       	kmovq  %rax,%k1
 1080f4c:	62 f1 7f c9 6f 03    	vmovdqu8 (%rbx),%zmm0{%k1}{z}
 1080f52:	c4 c1 79 6e ce       	vmovd  %r14d,%xmm1
 1080f57:	c5 e9 ef d2          	vpxor  %xmm2,%xmm2,%xmm2
 1080f5b:	48 89 54 24 40       	mov    %rdx,0x40(%rsp)
 1080f60:	62 f3 fd 48 25 0d d5 	vpternlogq $0x96,-0xbe2e2b(%rip),%zmm0,%zmm1        # 49e140 <cbuiltin_test_generated.edges+0x39c0>
 1080f67:	d1 41 ff 96 
 1080f6b:	62 f2 75 48 dc c2    	vaesenc %zmm2,%zmm1,%zmm0
 1080f71:	62 f2 7d 48 dc c2    	vaesenc %zmm2,%zmm0,%zmm0
 1080f77:	62 f3 fd 48 3b c1 01 	vextracti64x4 $0x1,%zmm0,%ymm1
 1080f7e:	62 f1 f5 48 ef c0    	vpxorq %zmm0,%zmm1,%zmm0
 1080f84:	c4 e3 7d 39 c1 01    	vextracti128 $0x1,%ymm0,%xmm1
 1080f8a:	c5 f1 ef c0          	vpxor  %xmm0,%xmm1,%xmm0
 1080f8e:	83 fa 41             	cmp    $0x41,%edx
 1080f91:	72 13                	jb     1080fa6 <check_input_run+0xc96>
 1080f93:	48 89 df             	mov    %rbx,%rdi
 1080f96:	4c 89 f6             	mov    %r14,%rsi
 1080f99:	c5 f8 77             	vzeroupper
 1080f9c:	e8 1f b9 fa ff       	call   102c8c0 <intern_chain_chunks>
 1080fa1:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
 1080fa6:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
 1080faa:	c4 e2 79 dc c1       	vaesenc %xmm1,%xmm0,%xmm0
 1080faf:	83 fa 10             	cmp    $0x10,%edx
 1080fb2:	b8 10 00 00 00       	mov    $0x10,%eax
 1080fb7:	b9 ff ff 00 00       	mov    $0xffff,%ecx
 1080fbc:	0f 42 c2             	cmovb  %edx,%eax
 1080fbf:	c4 e2 78 f5 c1       	bzhi   %eax,%ecx,%eax
 1080fc4:	c5 fb 92 c8          	kmovd  %eax,%k1
 1080fc8:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
 1080fcd:	c4 c1 f9 7e c4       	vmovq  %xmm0,%r12
 1080fd2:	62 f1 7f 89 6f 03    	vmovdqu8 (%rbx),%xmm0{%k1}{z}
 1080fd8:	48 8b 78 08          	mov    0x8(%rax),%rdi
 1080fdc:	48 8b 30             	mov    (%rax),%rsi
 1080fdf:	62 f3 fd 48 43 c0 00 	vshufi64x2 $0x0,%zmm0,%zmm0,%zmm0
 1080fe6:	49 21 fc             	and    %rdi,%r12
 1080fe9:	62 f1 fe 48 7f 84 24 	vmovdqu64 %zmm0,0x170(%rsp)
 1080ff0:	70 01 00 00 
 1080ff4:	83 fa 0c             	cmp    $0xc,%edx
 1080ff7:	73 67                	jae    1081060 <check_input_run+0xd50>
 1080ff9:	45 31 f6             	xor    %r14d,%r14d
 1080ffc:	eb 21                	jmp    108101f <check_input_run+0xd0f>
 1080ffe:	66 90                	xchg   %ax,%ax
 1081000:	62 f2 7e 48 27 c0    	vptestnmd %zmm0,%zmm0,%k0
 1081006:	49 ff c4             	inc    %r12
 1081009:	c5 fb 93 c8          	kmovd  %k0,%ecx
 108100d:	49 21 fc             	and    %rdi,%r12
 1081010:	81 e1 88 88 00 00    	and    $0x8888,%ecx
 1081016:	66 09 c8             	or     %cx,%ax
 1081019:	0f 85 d1 fe ff ff    	jne    1080ef0 <check_input_run+0xbe0>
 108101f:	4c 89 e1             	mov    %r12,%rcx
 1081022:	48 c1 e1 06          	shl    $0x6,%rcx
 1081026:	62 f1 fd 48 6f 04 0e 	vmovdqa64 (%rsi,%rcx,1),%zmm0
 108102d:	62 f1 7d 48 76 84 24 	vpcmpeqd 0x170(%rsp),%zmm0,%k0
 1081034:	70 01 00 00 
 1081038:	c5 fb 93 c0          	kmovd  %k0,%eax
 108103c:	25 77 77 00 00       	and    $0x7777,%eax
 1081041:	05 11 11 00 00       	add    $0x1111,%eax
 1081046:	66 25 88 88          	and    $0x8888,%ax
 108104a:	74 b4                	je     1081000 <check_input_run+0xcf0>
 108104c:	48 01 f1             	add    %rsi,%rcx
 108104f:	31 d2                	xor    %edx,%edx
 1081051:	f3 0f bc d0          	tzcnt  %eax,%edx
 1081055:	44 8b 34 91          	mov    (%rcx,%rdx,4),%r14d
 1081059:	eb a5                	jmp    1081000 <check_input_run+0xcf0>
 108105b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
 1081060:	4c 89 74 24 60       	mov    %r14,0x60(%rsp)
 1081065:	45 31 f6             	xor    %r14d,%r14d
 1081068:	48 89 5c 24 68       	mov    %rbx,0x68(%rsp)
 108106d:	48 89 b4 24 a0 00 00 	mov    %rsi,0xa0(%rsp)
 1081074:	00 
 1081075:	48 89 bc 24 b0 00 00 	mov    %rdi,0xb0(%rsp)
 108107c:	00 
 108107d:	0f 1f 00             	nopl   (%rax)
 1081080:	4c 89 e5             	mov    %r12,%rbp
 1081083:	48 c1 e5 06          	shl    $0x6,%rbp
 1081087:	62 f1 fd 48 6f 04 2e 	vmovdqa64 (%rsi,%rbp,1),%zmm0
 108108e:	62 f1 7d 48 76 84 24 	vpcmpeqd 0x170(%rsp),%zmm0,%k0
 1081095:	70 01 00 00 
 1081099:	62 f1 fe 48 7f 84 24 	vmovdqu64 %zmm0,0x130(%rsp)
 10810a0:	30 01 00 00 
 10810a4:	c5 fb 93 c0          	kmovd  %k0,%eax
 10810a8:	25 77 77 00 00       	and    $0x7777,%eax
 10810ad:	05 11 11 00 00       	add    $0x1111,%eax
 10810b2:	66 25 88 88          	and    $0x8888,%ax
 10810b6:	74 78                	je     1081130 <check_input_run+0xe20>
 10810b8:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
 10810bd:	48 01 f5             	add    %rsi,%rbp
 10810c0:	0f b7 d8             	movzwl %ax,%ebx
 10810c3:	4c 8b 69 10          	mov    0x10(%rcx),%r13
 10810c7:	eb 14                	jmp    10810dd <check_input_run+0xdcd>
 10810c9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
 10810d0:	31 c0                	xor    %eax,%eax
 10810d2:	84 c0                	test   %al,%al
 10810d4:	75 5c                	jne    1081132 <check_input_run+0xe22>
 10810d6:	c4 e2 60 f3 cb       	blsr   %ebx,%ebx
 10810db:	74 55                	je     1081132 <check_input_run+0xe22>
 10810dd:	31 c0                	xor    %eax,%eax
 10810df:	f3 0f bc c3          	tzcnt  %ebx,%eax
 10810e3:	44 8b 7c 85 00       	mov    0x0(%rbp,%rax,4),%r15d
 10810e8:	43 39 54 fd 04       	cmp    %edx,0x4(%r13,%r15,8)
 10810ed:	75 e1                	jne    10810d0 <check_input_run+0xdc0>
 10810ef:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
 10810f4:	43 8b 7c fd 00       	mov    0x0(%r13,%r15,8),%edi
 10810f9:	48 8b 74 24 68       	mov    0x68(%rsp),%rsi
 10810fe:	48 8b 54 24 60       	mov    0x60(%rsp),%rdx
 1081103:	48 03 78 40          	add    0x40(%rax),%rdi
 1081107:	c5 f8 77             	vzeroupper
 108110a:	e8 01 de 70 ff       	call   78ef10 <bcmp@plt>
 108110f:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
 1081114:	85 c0                	test   %eax,%eax
 1081116:	0f 94 c0             	sete   %al
 1081119:	45 0f 44 f7          	cmove  %r15d,%r14d
 108111d:	84 c0                	test   %al,%al
 108111f:	74 b5                	je     10810d6 <check_input_run+0xdc6>
 1081121:	eb 0f                	jmp    1081132 <check_input_run+0xe22>
 1081123:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 108112a:	84 00 00 00 00 00 
 1081130:	31 c0                	xor    %eax,%eax
 1081132:	62 f1 fe 48 6f 84 24 	vmovdqu64 0x130(%rsp),%zmm0
 1081139:	30 01 00 00 
 108113d:	62 f2 7e 48 27 c0    	vptestnmd %zmm0,%zmm0,%k0
 1081143:	c5 fb 93 c8          	kmovd  %k0,%ecx
 1081147:	f7 c1 88 88 00 00    	test   $0x8888,%ecx
 108114d:	0f 85 9d fd ff ff    	jne    1080ef0 <check_input_run+0xbe0>
 1081153:	48 8b bc 24 b0 00 00 	mov    0xb0(%rsp),%rdi
 108115a:	00 
 108115b:	48 8b b4 24 a0 00 00 	mov    0xa0(%rsp),%rsi
 1081162:	00 
 1081163:	49 ff c4             	inc    %r12
 1081166:	49 21 fc             	and    %rdi,%r12
 1081169:	84 c0                	test   %al,%al
 108116b:	0f 84 0f ff ff ff    	je     1081080 <check_input_run+0xd70>
 1081171:	e9 7a fd ff ff       	jmp    1080ef0 <check_input_run+0xbe0>
 1081176:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
 108117b:	b9 b0 00 00 00       	mov    $0xb0,%ecx
 1081180:	48 c7 47 50 00 00 00 	movq   $0x0,0x50(%rdi)
 1081187:	00 
 1081188:	48 c7 04 0f 00 00 00 	movq   $0x0,(%rdi,%rcx,1)
 108118f:	00 
 1081190:	48 c7 84 24 08 03 00 	movq   $0x0,0x308(%rsp)
 1081197:	00 00 00 00 00 
 108119c:	48 c7 84 24 10 03 00 	movq   $0x0,0x310(%rsp)
 10811a3:	00 00 00 00 00 
 10811a8:	48 c7 84 24 18 03 00 	movq   $0x0,0x318(%rsp)
 10811af:	00 00 00 00 00 
 10811b4:	48 c7 84 24 30 03 00 	movq   $0x0,0x330(%rsp)
 10811bb:	00 00 00 00 00 
 10811c0:	48 c7 84 24 58 03 00 	movq   $0x0,0x358(%rsp)
 10811c7:	00 00 00 00 00 
 10811cc:	48 c7 84 24 70 03 00 	movq   $0x0,0x370(%rsp)
 10811d3:	00 00 00 00 00 
 10811d8:	48 c7 84 24 98 03 00 	movq   $0x0,0x398(%rsp)
 10811df:	00 00 00 00 00 
 10811e4:	48 c7 84 24 a0 03 00 	movq   $0x0,0x3a0(%rsp)
 10811eb:	00 00 00 00 00 
 10811f0:	48 c7 84 24 a8 03 00 	movq   $0x0,0x3a8(%rsp)
 10811f7:	00 00 00 00 00 
 10811fc:	48 c7 84 24 b0 03 00 	movq   $0x0,0x3b0(%rsp)
 1081203:	00 00 00 00 00 
 1081208:	48 c7 84 24 b8 03 00 	movq   $0x0,0x3b8(%rsp)
 108120f:	00 00 00 00 00 
 1081214:	48 c7 84 24 c0 03 00 	movq   $0x0,0x3c0(%rsp)
 108121b:	00 00 00 00 00 
 1081220:	48 c7 84 24 c8 03 00 	movq   $0x0,0x3c8(%rsp)
 1081227:	00 00 00 00 00 
 108122c:	48 c7 84 24 d8 03 00 	movq   $0x0,0x3d8(%rsp)
 1081233:	00 00 00 00 00 
 1081238:	48 c7 84 24 e0 03 00 	movq   $0x0,0x3e0(%rsp)
 108123f:	00 00 00 00 00 
 1081244:	48 c7 84 24 e8 03 00 	movq   $0x0,0x3e8(%rsp)
 108124b:	00 00 00 00 00 
 1081250:	48 c7 84 24 f0 03 00 	movq   $0x0,0x3f0(%rsp)
 1081257:	00 00 00 00 00 
 108125c:	48 c7 84 24 f8 03 00 	movq   $0x0,0x3f8(%rsp)
 1081263:	00 00 00 00 00 
 1081268:	48 c7 84 24 00 04 00 	movq   $0x0,0x400(%rsp)
 108126f:	00 00 00 00 00 
 1081274:	48 c7 84 24 08 04 00 	movq   $0x0,0x408(%rsp)
 108127b:	00 00 00 00 00 
 1081280:	48 c7 84 24 10 04 00 	movq   $0x0,0x410(%rsp)
 1081287:	00 00 00 00 00 
 108128c:	48 c7 84 24 20 04 00 	movq   $0x0,0x420(%rsp)
 1081293:	00 00 00 00 00 
 1081298:	48 c7 84 24 68 04 00 	movq   $0x0,0x468(%rsp)
 108129f:	00 00 00 00 00 
 10812a4:	48 c7 84 24 70 04 00 	movq   $0x0,0x470(%rsp)
 10812ab:	00 00 00 00 00 
 10812b0:	48 c7 84 24 90 04 00 	movq   $0x0,0x490(%rsp)
 10812b7:	00 00 00 00 00 
 10812bc:	48 c7 84 24 98 04 00 	movq   $0x0,0x498(%rsp)
 10812c3:	00 00 00 00 00 
 10812c8:	48 c7 84 24 a8 04 00 	movq   $0x0,0x4a8(%rsp)
 10812cf:	00 00 00 00 00 
 10812d4:	48 c7 84 24 b0 04 00 	movq   $0x0,0x4b0(%rsp)
 10812db:	00 00 00 00 00 
 10812e0:	48 c7 84 24 b8 04 00 	movq   $0x0,0x4b8(%rsp)
 10812e7:	00 00 00 00 00 
 10812ec:	48 c7 84 24 c8 04 00 	movq   $0x0,0x4c8(%rsp)
 10812f3:	00 00 00 00 00 
 10812f8:	48 c7 84 24 d0 04 00 	movq   $0x0,0x4d0(%rsp)
 10812ff:	00 00 00 00 00 
 1081304:	48 c7 84 24 e0 04 00 	movq   $0x0,0x4e0(%rsp)
 108130b:	00 00 00 00 00 
 1081310:	48 c7 84 24 e8 04 00 	movq   $0x0,0x4e8(%rsp)
 1081317:	00 00 00 00 00 
 108131c:	48 c7 84 24 f0 04 00 	movq   $0x0,0x4f0(%rsp)
 1081323:	00 00 00 00 00 
 1081328:	48 c7 84 24 f8 04 00 	movq   $0x0,0x4f8(%rsp)
 108132f:	00 00 00 00 00 
 1081334:	48 c7 84 24 00 05 00 	movq   $0x0,0x500(%rsp)
 108133b:	00 00 00 00 00 
 1081340:	48 c7 84 24 08 05 00 	movq   $0x0,0x508(%rsp)
 1081347:	00 00 00 00 00 
 108134c:	48 c7 84 24 10 05 00 	movq   $0x0,0x510(%rsp)
 1081353:	00 00 00 00 00 
 1081358:	48 c7 84 24 30 05 00 	movq   $0x0,0x530(%rsp)
 108135f:	00 00 00 00 00 
 1081364:	48 c7 84 24 38 05 00 	movq   $0x0,0x538(%rsp)
 108136b:	00 00 00 00 00 
 1081370:	48 c7 84 24 58 05 00 	movq   $0x0,0x558(%rsp)
 1081377:	00 00 00 00 00 
 108137c:	48 c7 84 24 60 05 00 	movq   $0x0,0x560(%rsp)
 1081383:	00 00 00 00 00 
 1081388:	48 c7 84 24 68 05 00 	movq   $0x0,0x568(%rsp)
 108138f:	00 00 00 00 00 
 1081394:	48 c7 84 24 70 05 00 	movq   $0x0,0x570(%rsp)
 108139b:	00 00 00 00 00 
 10813a0:	48 c7 84 24 90 05 00 	movq   $0x0,0x590(%rsp)
 10813a7:	00 00 00 00 00 
 10813ac:	48 c7 84 24 98 05 00 	movq   $0x0,0x598(%rsp)
 10813b3:	00 00 00 00 00 
 10813b8:	48 c7 84 24 a0 05 00 	movq   $0x0,0x5a0(%rsp)
 10813bf:	00 00 00 00 00 
 10813c4:	48 c7 84 24 a8 05 00 	movq   $0x0,0x5a8(%rsp)
 10813cb:	00 00 00 00 00 
 10813d0:	48 c7 84 24 c8 05 00 	movq   $0x0,0x5c8(%rsp)
 10813d7:	00 00 00 00 00 
 10813dc:	48 c7 84 24 d0 05 00 	movq   $0x0,0x5d0(%rsp)
 10813e3:	00 00 00 00 00 
 10813e8:	48 c7 84 24 d8 05 00 	movq   $0x0,0x5d8(%rsp)
 10813ef:	00 00 00 00 00 
 10813f4:	48 c7 84 24 e0 05 00 	movq   $0x0,0x5e0(%rsp)
 10813fb:	00 00 00 00 00 
 1081400:	48 c7 84 24 e8 05 00 	movq   $0x0,0x5e8(%rsp)
 1081407:	00 00 00 00 00 
 108140c:	48 c7 84 24 f8 05 00 	movq   $0x0,0x5f8(%rsp)
 1081413:	00 00 00 00 00 
 1081418:	48 c7 84 24 00 06 00 	movq   $0x0,0x600(%rsp)
 108141f:	00 00 00 00 00 
 1081424:	48 c7 84 24 08 06 00 	movq   $0x0,0x608(%rsp)
 108142b:	00 00 00 00 00 
 1081430:	31 f6                	xor    %esi,%esi
 1081432:	31 c9                	xor    %ecx,%ecx
 1081434:	48 85 c9             	test   %rcx,%rcx
 1081437:	48 89 8c 24 f0 05 00 	mov    %rcx,0x5f0(%rsp)
 108143e:	00 
 108143f:	0f 95 c0             	setne  %al
 1081442:	40 20 f0             	and    %sil,%al
 1081445:	45 85 e4             	test   %r12d,%r12d
 1081448:	74 1d                	je     1081467 <check_input_run+0x1157>
 108144a:	49 8b 4e 18          	mov    0x18(%r14),%rcx
 108144e:	4c 8b 44 24 58       	mov    0x58(%rsp),%r8
 1081453:	41 83 f8 08          	cmp    $0x8,%r8d
 1081457:	73 25                	jae    108147e <check_input_run+0x116e>
 1081459:	4c 8b 7c 24 48       	mov    0x48(%rsp),%r15
 108145e:	31 d2                	xor    %edx,%edx
 1081460:	31 f6                	xor    %esi,%esi
 1081462:	e9 a9 01 00 00       	jmp    1081610 <check_input_run+0x1300>
 1081467:	4c 8b 7c 24 48       	mov    0x48(%rsp),%r15
 108146c:	bb 60 00 00 00       	mov    $0x60,%ebx
 1081471:	84 c0                	test   %al,%al
 1081473:	0f 85 c1 01 00 00    	jne    108163a <check_input_run+0x132a>
 1081479:	e9 11 16 00 00       	jmp    1082a8f <check_input_run+0x277f>
 108147e:	41 83 f8 40          	cmp    $0x40,%r8d
 1081482:	73 0e                	jae    1081492 <check_input_run+0x1182>
 1081484:	4c 8b 7c 24 48       	mov    0x48(%rsp),%r15
 1081489:	31 d2                	xor    %edx,%edx
 108148b:	31 f6                	xor    %esi,%esi
 108148d:	e9 08 01 00 00       	jmp    108159a <check_input_run+0x128a>
 1081492:	62 f2 7d 48 58 0d 48 	vpbroadcastd -0xad2fb8(%rip),%zmm1        # 5ae4e4 <link_program_emit_worker.forms+0x3f4>
 1081499:	d0 52 ff 
 108149c:	62 f2 7d 48 58 15 42 	vpbroadcastd -0xad2fbe(%rip),%zmm2        # 5ae4e8 <link_program_emit_worker.forms+0x3f8>
 10814a3:	d0 52 ff 
 10814a6:	44 89 c6             	mov    %r8d,%esi
 10814a9:	c1 ee 06             	shr    $0x6,%esi
 10814ac:	44 89 c2             	mov    %r8d,%edx
 10814af:	83 e2 c0             	and    $0xffffffc0,%edx
 10814b2:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 10814b6:	31 ff                	xor    %edi,%edi
 10814b8:	c5 e1 ef db          	vpxor  %xmm3,%xmm3,%xmm3
 10814bc:	c5 d9 ef e4          	vpxor  %xmm4,%xmm4,%xmm4
 10814c0:	c5 d1 ef ed          	vpxor  %xmm5,%xmm5,%xmm5
 10814c4:	48 c1 e6 08          	shl    $0x8,%rsi
 10814c8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
 10814cf:	00 
 10814d0:	62 f1 75 48 fe 34 39 	vpaddd (%rcx,%rdi,1),%zmm1,%zmm6
 10814d7:	62 f1 75 48 fe 7c 39 	vpaddd 0x40(%rcx,%rdi,1),%zmm1,%zmm7
 10814de:	01 
 10814df:	62 71 75 48 fe 44 39 	vpaddd 0x80(%rcx,%rdi,1),%zmm1,%zmm8
 10814e6:	02 
 10814e7:	62 71 75 48 fe 4c 39 	vpaddd 0xc0(%rcx,%rdi,1),%zmm1,%zmm9
 10814ee:	03 
 10814ef:	48 81 c7 00 01 00 00 	add    $0x100,%rdi
 10814f6:	62 f3 4d 48 1e c2 01 	vpcmpltud %zmm2,%zmm6,%k0
 10814fd:	62 f3 45 48 1e ca 01 	vpcmpltud %zmm2,%zmm7,%k1
 1081504:	62 f3 3d 48 1e d2 01 	vpcmpltud %zmm2,%zmm8,%k2
 108150b:	62 f3 35 48 1e da 01 	vpcmpltud %zmm2,%zmm9,%k3
 1081512:	62 f2 7e 48 38 f0    	vpmovm2d %k0,%zmm6
 1081518:	62 f1 7d 48 fa c6    	vpsubd %zmm6,%zmm0,%zmm0
 108151e:	62 f2 7e 48 38 f1    	vpmovm2d %k1,%zmm6
 1081524:	62 f1 65 48 fa de    	vpsubd %zmm6,%zmm3,%zmm3
 108152a:	62 f2 7e 48 38 f2    	vpmovm2d %k2,%zmm6
 1081530:	62 f1 5d 48 fa e6    	vpsubd %zmm6,%zmm4,%zmm4
 1081536:	62 f2 7e 48 38 f3    	vpmovm2d %k3,%zmm6
 108153c:	62 f1 55 48 fa ee    	vpsubd %zmm6,%zmm5,%zmm5
 1081542:	48 39 fe             	cmp    %rdi,%rsi
 1081545:	75 89                	jne    10814d0 <check_input_run+0x11c0>
 1081547:	62 f1 65 48 fe c0    	vpaddd %zmm0,%zmm3,%zmm0
 108154d:	62 f1 55 48 fe cc    	vpaddd %zmm4,%zmm5,%zmm1
 1081553:	4c 8b 7c 24 48       	mov    0x48(%rsp),%r15
 1081558:	62 f1 75 48 fe c0    	vpaddd %zmm0,%zmm1,%zmm0
 108155e:	62 f3 fd 48 3b c1 01 	vextracti64x4 $0x1,%zmm0,%ymm1
 1081565:	62 f1 7d 48 fe c1    	vpaddd %zmm1,%zmm0,%zmm0
 108156b:	c4 e3 7d 39 c1 01    	vextracti128 $0x1,%ymm0,%xmm1
 1081571:	c5 f9 fe c1          	vpaddd %xmm1,%xmm0,%xmm0
 1081575:	c5 f9 70 c8 ee       	vpshufd $0xee,%xmm0,%xmm1
 108157a:	c5 f9 fe c1          	vpaddd %xmm1,%xmm0,%xmm0
 108157e:	c5 f9 70 c8 55       	vpshufd $0x55,%xmm0,%xmm1
 1081583:	c5 f9 fe c1          	vpaddd %xmm1,%xmm0,%xmm0
 1081587:	c5 f9 7e c6          	vmovd  %xmm0,%esi
 108158b:	41 39 d0             	cmp    %edx,%r8d
 108158e:	0f 84 90 00 00 00    	je     1081624 <check_input_run+0x1314>
 1081594:	41 f6 c0 38          	test   $0x38,%r8b
 1081598:	74 76                	je     1081610 <check_input_run+0x1300>
 108159a:	c4 e2 7d 58 0d 41 cf 	vpbroadcastd -0xad30bf(%rip),%ymm1        # 5ae4e4 <link_program_emit_worker.forms+0x3f4>
 10815a1:	52 ff 
 10815a3:	c4 e2 7d 58 15 3c cf 	vpbroadcastd -0xad30c4(%rip),%ymm2        # 5ae4e8 <link_program_emit_worker.forms+0x3f8>
 10815aa:	52 ff 
 10815ac:	48 89 d7             	mov    %rdx,%rdi
 10815af:	44 89 c2             	mov    %r8d,%edx
 10815b2:	83 e2 f8             	and    $0xfffffff8,%edx
 10815b5:	c5 f9 6e c6          	vmovd  %esi,%xmm0
 10815b9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
 10815c0:	c5 f5 fe 1c b9       	vpaddd (%rcx,%rdi,4),%ymm1,%ymm3
 10815c5:	48 83 c7 08          	add    $0x8,%rdi
 10815c9:	62 f3 65 28 1e c2 01 	vpcmpltud %ymm2,%ymm3,%k0
 10815d0:	62 f2 7e 28 38 d8    	vpmovm2d %k0,%ymm3
 10815d6:	c5 fd fa c3          	vpsubd %ymm3,%ymm0,%ymm0
 10815da:	48 39 fa             	cmp    %rdi,%rdx
 10815dd:	75 e1                	jne    10815c0 <check_input_run+0x12b0>
 10815df:	c4 e3 7d 39 c1 01    	vextracti128 $0x1,%ymm0,%xmm1
 10815e5:	c5 f9 fe c1          	vpaddd %xmm1,%xmm0,%xmm0
 10815e9:	c5 f9 70 c8 ee       	vpshufd $0xee,%xmm0,%xmm1
 10815ee:	c5 f9 fe c1          	vpaddd %xmm1,%xmm0,%xmm0
 10815f2:	c5 f9 70 c8 55       	vpshufd $0x55,%xmm0,%xmm1
 10815f7:	c5 f9 fe c1          	vpaddd %xmm1,%xmm0,%xmm0
 10815fb:	c5 f9 7e c6          	vmovd  %xmm0,%esi
 10815ff:	41 39 d0             	cmp    %edx,%r8d
 1081602:	74 20                	je     1081624 <check_input_run+0x1314>
 1081604:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
 108160b:	00 00 00 00 00 
 1081610:	8b 3c 91             	mov    (%rcx,%rdx,4),%edi
 1081613:	83 c7 b3             	add    $0xffffffb3,%edi
 1081616:	83 ff 02             	cmp    $0x2,%edi
 1081619:	83 d6 00             	adc    $0x0,%esi
 108161c:	48 ff c2             	inc    %rdx
 108161f:	49 39 d0             	cmp    %rdx,%r8
 1081622:	75 ec                	jne    1081610 <check_input_run+0x1300>
 1081624:	89 f1                	mov    %esi,%ecx
 1081626:	48 8d 1c 49          	lea    (%rcx,%rcx,2),%rbx
 108162a:	48 c1 e3 05          	shl    $0x5,%rbx
 108162e:	48 83 c3 60          	add    $0x60,%rbx
 1081632:	84 c0                	test   %al,%al
 1081634:	0f 84 55 14 00 00    	je     1082a8f <check_input_run+0x277f>
 108163a:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
 108163f:	8b 81 34 03 00 00    	mov    0x334(%rcx),%eax
 1081645:	48 85 c0             	test   %rax,%rax
 1081648:	0f 84 02 01 00 00    	je     1081750 <check_input_run+0x1440>
 108164e:	4c 8b 0c 24          	mov    (%rsp),%r9
 1081652:	49 8b 39             	mov    (%r9),%rdi
 1081655:	49 8b 51 08          	mov    0x8(%r9),%rdx
 1081659:	48 8d 4c 3a 03       	lea    0x3(%rdx,%rdi,1),%rcx
 108165e:	48 01 fa             	add    %rdi,%rdx
 1081661:	48 83 e1 fc          	and    $0xfffffffffffffffc,%rcx
 1081665:	48 39 d1             	cmp    %rdx,%rcx
 1081668:	72 29                	jb     1081693 <check_input_run+0x1383>
 108166a:	48 89 ce             	mov    %rcx,%rsi
 108166d:	48 29 fe             	sub    %rdi,%rsi
 1081670:	49 8b 79 10          	mov    0x10(%r9),%rdi
 1081674:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
 108167b:	00 
 108167c:	48 8d 14 d2          	lea    (%rdx,%rdx,8),%rdx
 1081680:	48 29 f7             	sub    %rsi,%rdi
 1081683:	41 0f 92 c0          	setb   %r8b
 1081687:	48 39 fa             	cmp    %rdi,%rdx
 108168a:	40 0f 97 c7          	seta   %dil
 108168e:	44 08 c7             	or     %r8b,%dil
 1081691:	74 04                	je     1081697 <check_input_run+0x1387>
 1081693:	31 c9                	xor    %ecx,%ecx
 1081695:	eb 12                	jmp    10816a9 <check_input_run+0x1399>
 1081697:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 108169c:	48 01 d6             	add    %rdx,%rsi
 108169f:	49 89 71 08          	mov    %rsi,0x8(%r9)
 10816a3:	8b 80 34 03 00 00    	mov    0x334(%rax),%eax
 10816a9:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
 10816ae:	48 8b 74 24 28       	mov    0x28(%rsp),%rsi
 10816b3:	48 89 8a 28 03 00 00 	mov    %rcx,0x328(%rdx)
 10816ba:	48 8b 16             	mov    (%rsi),%rdx
 10816bd:	48 8b 4e 08          	mov    0x8(%rsi),%rcx
 10816c1:	48 8d 7c 11 03       	lea    0x3(%rcx,%rdx,1),%rdi
 10816c6:	48 01 d1             	add    %rdx,%rcx
 10816c9:	48 83 e7 fc          	and    $0xfffffffffffffffc,%rdi
 10816cd:	48 39 cf             	cmp    %rcx,%rdi
 10816d0:	73 11                	jae    10816e3 <check_input_run+0x13d3>
 10816d2:	48 c7 84 24 c0 04 00 	movq   $0x0,0x4c0(%rsp)
 10816d9:	00 00 00 00 00 
 10816de:	e9 ac 13 00 00       	jmp    1082a8f <check_input_run+0x277f>
 10816e3:	48 89 f9             	mov    %rdi,%rcx
 10816e6:	48 29 d1             	sub    %rdx,%rcx
 10816e9:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
 10816ee:	48 8b 52 10          	mov    0x10(%rdx),%rdx
 10816f2:	48 29 ca             	sub    %rcx,%rdx
 10816f5:	72 db                	jb     10816d2 <check_input_run+0x13c2>
 10816f7:	48 c1 e0 02          	shl    $0x2,%rax
 10816fb:	48 39 d0             	cmp    %rdx,%rax
 10816fe:	77 d2                	ja     10816d2 <check_input_run+0x13c2>
 1081700:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
 1081705:	48 01 c1             	add    %rax,%rcx
 1081708:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
 108170c:	48 89 bc 24 c0 04 00 	mov    %rdi,0x4c0(%rsp)
 1081713:	00 
 1081714:	48 85 ff             	test   %rdi,%rdi
 1081717:	0f 84 72 13 00 00    	je     1082a8f <check_input_run+0x277f>
 108171d:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 1081722:	48 83 b8 28 03 00 00 	cmpq   $0x0,0x328(%rax)
 1081729:	00 
 108172a:	0f 84 5f 13 00 00    	je     1082a8f <check_input_run+0x277f>
 1081730:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
 1081735:	be ff 00 00 00       	mov    $0xff,%esi
 108173a:	41 8b 96 34 03 00 00 	mov    0x334(%r14),%edx
 1081741:	48 c1 e2 02          	shl    $0x2,%rdx
 1081745:	c5 f8 77             	vzeroupper
 1081748:	e8 33 d8 70 ff       	call   78ef80 <memset@plt>
 108174d:	4c 89 f1             	mov    %r14,%rcx
 1081750:	8b 89 44 03 00 00    	mov    0x344(%rcx),%ecx
 1081756:	48 85 c9             	test   %rcx,%rcx
 1081759:	0f 84 0f 13 00 00    	je     1082a6e <check_input_run+0x275e>
 108175f:	4c 8b 04 24          	mov    (%rsp),%r8
 1081763:	49 8b 30             	mov    (%r8),%rsi
 1081766:	49 8b 50 08          	mov    0x8(%r8),%rdx
 108176a:	48 8d 44 32 07       	lea    0x7(%rdx,%rsi,1),%rax
 108176f:	48 01 f2             	add    %rsi,%rdx
 1081772:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
 1081776:	48 39 d0             	cmp    %rdx,%rax
 1081779:	72 2d                	jb     10817a8 <check_input_run+0x1498>
 108177b:	48 89 c2             	mov    %rax,%rdx
 108177e:	48 29 f2             	sub    %rsi,%rdx
 1081781:	49 8b 70 10          	mov    0x10(%r8),%rsi
 1081785:	48 c1 e1 04          	shl    $0x4,%rcx
 1081789:	48 8d 0c 89          	lea    (%rcx,%rcx,4),%rcx
 108178d:	48 29 d6             	sub    %rdx,%rsi
 1081790:	40 0f 92 c7          	setb   %dil
 1081794:	48 39 f1             	cmp    %rsi,%rcx
 1081797:	40 0f 97 c6          	seta   %sil
 108179b:	40 08 fe             	or     %dil,%sil
 108179e:	40 80 fe 01          	cmp    $0x1,%sil
 10817a2:	0f 85 ae 12 00 00    	jne    1082a56 <check_input_run+0x2746>
 10817a8:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 10817ad:	48 c7 80 38 03 00 00 	movq   $0x0,0x338(%rax)
 10817b4:	00 00 00 00 
 10817b8:	e9 d2 12 00 00       	jmp    1082a8f <check_input_run+0x277f>
 10817bd:	48 8b 7f 10          	mov    0x10(%rdi),%rdi
 10817c1:	48 89 d6             	mov    %rdx,%rsi
 10817c4:	48 29 c6             	sub    %rax,%rsi
 10817c7:	48 29 f7             	sub    %rsi,%rdi
 10817ca:	0f 82 09 f7 ff ff    	jb     1080ed9 <check_input_run+0xbc9>
 10817d0:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
 10817d5:	48 8d 04 85 04 00 00 	lea    0x4(,%rax,4),%rax
 10817dc:	00 
 10817dd:	48 39 f8             	cmp    %rdi,%rax
 10817e0:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
 10817e5:	0f 87 9d f9 ff ff    	ja     1081188 <check_input_run+0xe78>
 10817eb:	48 8b 0c 24          	mov    (%rsp),%rcx
 10817ef:	48 01 c6             	add    %rax,%rsi
 10817f2:	48 89 71 08          	mov    %rsi,0x8(%rcx)
 10817f6:	48 89 97 b0 00 00 00 	mov    %rdx,0xb0(%rdi)
 10817fd:	48 85 d2             	test   %rdx,%rdx
 1081800:	74 7f                	je     1081881 <check_input_run+0x1571>
 1081802:	83 bc 24 98 00 00 00 	cmpl   $0x0,0x98(%rsp)
 1081809:	00 
 108180a:	74 75                	je     1081881 <check_input_run+0x1571>
 108180c:	8b 8c 24 98 00 00 00 	mov    0x98(%rsp),%ecx
 1081813:	4c 8b 04 24          	mov    (%rsp),%r8
 1081817:	89 8f ec 00 00 00    	mov    %ecx,0xec(%rdi)
 108181d:	b9 e0 00 00 00       	mov    $0xe0,%ecx
 1081822:	49 8b 38             	mov    (%r8),%rdi
 1081825:	49 8b 70 08          	mov    0x8(%r8),%rsi
 1081829:	48 8d 54 3e 07       	lea    0x7(%rsi,%rdi,1),%rdx
 108182e:	48 01 fe             	add    %rdi,%rsi
 1081831:	48 83 e2 f8          	and    $0xfffffffffffffff8,%rdx
 1081835:	48 39 f2             	cmp    %rsi,%rdx
 1081838:	0f 82 9b f6 ff ff    	jb     1080ed9 <check_input_run+0xbc9>
 108183e:	48 89 d6             	mov    %rdx,%rsi
 1081841:	48 29 fe             	sub    %rdi,%rsi
 1081844:	49 8b 78 10          	mov    0x10(%r8),%rdi
 1081848:	48 29 f7             	sub    %rsi,%rdi
 108184b:	0f 82 88 f6 ff ff    	jb     1080ed9 <check_input_run+0xbc9>
 1081851:	44 8b 84 24 98 00 00 	mov    0x98(%rsp),%r8d
 1081858:	00 
 1081859:	49 c1 e0 03          	shl    $0x3,%r8
 108185d:	4f 8d 04 40          	lea    (%r8,%r8,2),%r8
 1081861:	49 39 f8             	cmp    %rdi,%r8
 1081864:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
 1081869:	0f 87 19 f9 ff ff    	ja     1081188 <check_input_run+0xe78>
 108186f:	48 8b 0c 24          	mov    (%rsp),%rcx
 1081873:	4c 01 c6             	add    %r8,%rsi
 1081876:	48 89 71 08          	mov    %rsi,0x8(%rcx)
 108187a:	48 89 97 e0 00 00 00 	mov    %rdx,0xe0(%rdi)
 1081881:	48 85 d2             	test   %rdx,%rdx
 1081884:	0f 84 06 f9 ff ff    	je     1081190 <check_input_run+0xe80>
 108188a:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
 108188f:	48 8b 0a             	mov    (%rdx),%rcx
 1081892:	48 8b 52 08          	mov    0x8(%rdx),%rdx
 1081896:	48 8d 74 0a 3f       	lea    0x3f(%rdx,%rcx,1),%rsi
 108189b:	48 01 ca             	add    %rcx,%rdx
 108189e:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 10818a2:	48 39 d6             	cmp    %rdx,%rsi
 10818a5:	0f 82 e5 f8 ff ff    	jb     1081190 <check_input_run+0xe80>
 10818ab:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
 10818b0:	48 89 f7             	mov    %rsi,%rdi
 10818b3:	48 29 cf             	sub    %rcx,%rdi
 10818b6:	48 8b 52 10          	mov    0x10(%rdx),%rdx
 10818ba:	49 89 d0             	mov    %rdx,%r8
 10818bd:	49 29 f8             	sub    %rdi,%r8
 10818c0:	0f 82 ca f8 ff ff    	jb     1081190 <check_input_run+0xe80>
 10818c6:	4c 39 c0             	cmp    %r8,%rax
 10818c9:	0f 87 c1 f8 ff ff    	ja     1081190 <check_input_run+0xe80>
 10818cf:	4c 8b 44 24 28       	mov    0x28(%rsp),%r8
 10818d4:	48 01 c7             	add    %rax,%rdi
 10818d7:	49 89 78 08          	mov    %rdi,0x8(%r8)
 10818db:	48 89 b4 24 08 03 00 	mov    %rsi,0x308(%rsp)
 10818e2:	00 
 10818e3:	48 85 f6             	test   %rsi,%rsi
 10818e6:	0f 84 b0 f8 ff ff    	je     108119c <check_input_run+0xe8c>
 10818ec:	48 8d 7c 06 3c       	lea    0x3c(%rsi,%rax,1),%rdi
 10818f1:	48 01 c6             	add    %rax,%rsi
 10818f4:	48 83 e7 c0          	and    $0xffffffffffffffc0,%rdi
 10818f8:	48 39 f7             	cmp    %rsi,%rdi
 10818fb:	0f 82 9b f8 ff ff    	jb     108119c <check_input_run+0xe8c>
 1081901:	49 89 f8             	mov    %rdi,%r8
 1081904:	49 29 c8             	sub    %rcx,%r8
 1081907:	49 89 d1             	mov    %rdx,%r9
 108190a:	4d 29 c1             	sub    %r8,%r9
 108190d:	0f 82 89 f8 ff ff    	jb     108119c <check_input_run+0xe8c>
 1081913:	48 8b 74 24 58       	mov    0x58(%rsp),%rsi
 1081918:	48 8d 34 f5 08 00 00 	lea    0x8(,%rsi,8),%rsi
 108191f:	00 
 1081920:	4c 39 ce             	cmp    %r9,%rsi
 1081923:	0f 87 73 f8 ff ff    	ja     108119c <check_input_run+0xe8c>
 1081929:	4c 8b 4c 24 28       	mov    0x28(%rsp),%r9
 108192e:	49 01 f0             	add    %rsi,%r8
 1081931:	4d 89 41 08          	mov    %r8,0x8(%r9)
 1081935:	48 89 bc 24 10 03 00 	mov    %rdi,0x310(%rsp)
 108193c:	00 
 108193d:	48 85 ff             	test   %rdi,%rdi
 1081940:	0f 84 62 f8 ff ff    	je     10811a8 <check_input_run+0xe98>
 1081946:	4c 8d 44 37 38       	lea    0x38(%rdi,%rsi,1),%r8
 108194b:	48 01 f7             	add    %rsi,%rdi
 108194e:	49 83 e0 c0          	and    $0xffffffffffffffc0,%r8
 1081952:	49 39 f8             	cmp    %rdi,%r8
 1081955:	0f 82 4d f8 ff ff    	jb     10811a8 <check_input_run+0xe98>
 108195b:	4c 89 c7             	mov    %r8,%rdi
 108195e:	48 29 cf             	sub    %rcx,%rdi
 1081961:	49 89 d1             	mov    %rdx,%r9
 1081964:	49 29 f9             	sub    %rdi,%r9
 1081967:	0f 82 3b f8 ff ff    	jb     10811a8 <check_input_run+0xe98>
 108196d:	4c 39 ce             	cmp    %r9,%rsi
 1081970:	0f 87 32 f8 ff ff    	ja     10811a8 <check_input_run+0xe98>
 1081976:	4c 8b 4c 24 28       	mov    0x28(%rsp),%r9
 108197b:	48 01 f7             	add    %rsi,%rdi
 108197e:	49 89 79 08          	mov    %rdi,0x8(%r9)
 1081982:	4c 89 84 24 18 03 00 	mov    %r8,0x318(%rsp)
 1081989:	00 
 108198a:	4d 85 c0             	test   %r8,%r8
 108198d:	0f 84 21 f8 ff ff    	je     10811b4 <check_input_run+0xea4>
 1081993:	49 8d 7c 30 38       	lea    0x38(%r8,%rsi,1),%rdi
 1081998:	49 01 f0             	add    %rsi,%r8
 108199b:	48 83 e7 c0          	and    $0xffffffffffffffc0,%rdi
 108199f:	4c 39 c7             	cmp    %r8,%rdi
 10819a2:	0f 82 0c f8 ff ff    	jb     10811b4 <check_input_run+0xea4>
 10819a8:	49 89 f8             	mov    %rdi,%r8
 10819ab:	49 29 c8             	sub    %rcx,%r8
 10819ae:	49 89 d1             	mov    %rdx,%r9
 10819b1:	4d 29 c1             	sub    %r8,%r9
 10819b4:	0f 82 fa f7 ff ff    	jb     10811b4 <check_input_run+0xea4>
 10819ba:	4c 39 c8             	cmp    %r9,%rax
 10819bd:	0f 87 f1 f7 ff ff    	ja     10811b4 <check_input_run+0xea4>
 10819c3:	4c 8b 4c 24 28       	mov    0x28(%rsp),%r9
 10819c8:	49 01 c0             	add    %rax,%r8
 10819cb:	4d 89 41 08          	mov    %r8,0x8(%r9)
 10819cf:	48 89 bc 24 30 03 00 	mov    %rdi,0x330(%rsp)
 10819d6:	00 
 10819d7:	48 85 ff             	test   %rdi,%rdi
 10819da:	0f 84 e0 f7 ff ff    	je     10811c0 <check_input_run+0xeb0>
 10819e0:	4c 8d 44 07 3c       	lea    0x3c(%rdi,%rax,1),%r8
 10819e5:	48 01 c7             	add    %rax,%rdi
 10819e8:	49 83 e0 c0          	and    $0xffffffffffffffc0,%r8
 10819ec:	49 39 f8             	cmp    %rdi,%r8
 10819ef:	0f 82 cb f7 ff ff    	jb     10811c0 <check_input_run+0xeb0>
 10819f5:	4c 89 c7             	mov    %r8,%rdi
 10819f8:	48 29 cf             	sub    %rcx,%rdi
 10819fb:	49 89 d1             	mov    %rdx,%r9
 10819fe:	49 29 f9             	sub    %rdi,%r9
 1081a01:	0f 82 b9 f7 ff ff    	jb     10811c0 <check_input_run+0xeb0>
 1081a07:	4c 39 c8             	cmp    %r9,%rax
 1081a0a:	0f 87 b0 f7 ff ff    	ja     10811c0 <check_input_run+0xeb0>
 1081a10:	4c 8b 4c 24 28       	mov    0x28(%rsp),%r9
 1081a15:	48 01 c7             	add    %rax,%rdi
 1081a18:	49 89 79 08          	mov    %rdi,0x8(%r9)
 1081a1c:	4c 89 84 24 58 03 00 	mov    %r8,0x358(%rsp)
 1081a23:	00 
 1081a24:	4d 85 c0             	test   %r8,%r8
 1081a27:	0f 84 9f f7 ff ff    	je     10811cc <check_input_run+0xebc>
 1081a2d:	4d 8d 4c 00 3c       	lea    0x3c(%r8,%rax,1),%r9
 1081a32:	49 01 c0             	add    %rax,%r8
 1081a35:	49 83 e1 c0          	and    $0xffffffffffffffc0,%r9
 1081a39:	4d 39 c1             	cmp    %r8,%r9
 1081a3c:	0f 82 8a f7 ff ff    	jb     10811cc <check_input_run+0xebc>
 1081a42:	4d 89 c8             	mov    %r9,%r8
 1081a45:	49 29 c8             	sub    %rcx,%r8
 1081a48:	48 89 d7             	mov    %rdx,%rdi
 1081a4b:	4c 29 c7             	sub    %r8,%rdi
 1081a4e:	41 0f 92 c2          	setb   %r10b
 1081a52:	48 3b 7c 24 58       	cmp    0x58(%rsp),%rdi
 1081a57:	40 0f 96 c7          	setbe  %dil
 1081a5b:	44 08 d7             	or     %r10b,%dil
 1081a5e:	40 80 ff 01          	cmp    $0x1,%dil
 1081a62:	0f 84 64 f7 ff ff    	je     10811cc <check_input_run+0xebc>
 1081a68:	48 8b 7c 24 58       	mov    0x58(%rsp),%rdi
 1081a6d:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
 1081a72:	48 ff c7             	inc    %rdi
 1081a75:	49 01 f8             	add    %rdi,%r8
 1081a78:	4d 89 42 08          	mov    %r8,0x8(%r10)
 1081a7c:	4c 89 8c 24 70 03 00 	mov    %r9,0x370(%rsp)
 1081a83:	00 
 1081a84:	4d 85 c9             	test   %r9,%r9
 1081a87:	0f 84 4b f7 ff ff    	je     10811d8 <check_input_run+0xec8>
 1081a8d:	4e 8d 44 0f 3f       	lea    0x3f(%rdi,%r9,1),%r8
 1081a92:	4e 8d 14 0f          	lea    (%rdi,%r9,1),%r10
 1081a96:	49 83 e0 c0          	and    $0xffffffffffffffc0,%r8
 1081a9a:	4d 39 d0             	cmp    %r10,%r8
 1081a9d:	0f 82 35 f7 ff ff    	jb     10811d8 <check_input_run+0xec8>
 1081aa3:	4d 89 c1             	mov    %r8,%r9
 1081aa6:	49 29 c9             	sub    %rcx,%r9
 1081aa9:	49 89 d2             	mov    %rdx,%r10
 1081aac:	4d 29 ca             	sub    %r9,%r10
 1081aaf:	41 0f 92 c3          	setb   %r11b
 1081ab3:	4c 3b 54 24 58       	cmp    0x58(%rsp),%r10
 1081ab8:	41 0f 96 c2          	setbe  %r10b
 1081abc:	45 08 da             	or     %r11b,%r10b
 1081abf:	41 80 fa 01          	cmp    $0x1,%r10b
 1081ac3:	0f 84 0f f7 ff ff    	je     10811d8 <check_input_run+0xec8>
 1081ac9:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
 1081ace:	49 01 f9             	add    %rdi,%r9
 1081ad1:	4d 89 4a 08          	mov    %r9,0x8(%r10)
 1081ad5:	4c 89 84 24 98 03 00 	mov    %r8,0x398(%rsp)
 1081adc:	00 
 1081add:	4d 85 c0             	test   %r8,%r8
 1081ae0:	0f 84 fe f6 ff ff    	je     10811e4 <check_input_run+0xed4>
 1081ae6:	4e 8d 0c 07          	lea    (%rdi,%r8,1),%r9
 1081aea:	4e 8d 44 07 3f       	lea    0x3f(%rdi,%r8,1),%r8
 1081aef:	49 83 e0 c0          	and    $0xffffffffffffffc0,%r8
 1081af3:	4d 39 c8             	cmp    %r9,%r8
 1081af6:	0f 82 e8 f6 ff ff    	jb     10811e4 <check_input_run+0xed4>
 1081afc:	4d 89 c1             	mov    %r8,%r9
 1081aff:	49 29 c9             	sub    %rcx,%r9
 1081b02:	49 89 d2             	mov    %rdx,%r10
 1081b05:	4d 29 ca             	sub    %r9,%r10
 1081b08:	41 0f 92 c3          	setb   %r11b
 1081b0c:	4c 3b 54 24 58       	cmp    0x58(%rsp),%r10
 1081b11:	41 0f 96 c2          	setbe  %r10b
 1081b15:	45 08 da             	or     %r11b,%r10b
 1081b18:	41 80 fa 01          	cmp    $0x1,%r10b
 1081b1c:	0f 84 c2 f6 ff ff    	je     10811e4 <check_input_run+0xed4>
 1081b22:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
 1081b27:	49 01 f9             	add    %rdi,%r9
 1081b2a:	4d 89 4a 08          	mov    %r9,0x8(%r10)
 1081b2e:	4c 89 84 24 a0 03 00 	mov    %r8,0x3a0(%rsp)
 1081b35:	00 
 1081b36:	4d 85 c0             	test   %r8,%r8
 1081b39:	0f 84 b1 f6 ff ff    	je     10811f0 <check_input_run+0xee0>
 1081b3f:	4e 8d 0c 07          	lea    (%rdi,%r8,1),%r9
 1081b43:	4e 8d 44 07 3f       	lea    0x3f(%rdi,%r8,1),%r8
 1081b48:	49 83 e0 c0          	and    $0xffffffffffffffc0,%r8
 1081b4c:	4d 39 c8             	cmp    %r9,%r8
 1081b4f:	0f 82 9b f6 ff ff    	jb     10811f0 <check_input_run+0xee0>
 1081b55:	4d 89 c1             	mov    %r8,%r9
 1081b58:	49 29 c9             	sub    %rcx,%r9
 1081b5b:	49 89 d2             	mov    %rdx,%r10
 1081b5e:	4d 29 ca             	sub    %r9,%r10
 1081b61:	41 0f 92 c3          	setb   %r11b
 1081b65:	4c 3b 54 24 58       	cmp    0x58(%rsp),%r10
 1081b6a:	41 0f 96 c2          	setbe  %r10b
 1081b6e:	45 08 da             	or     %r11b,%r10b
 1081b71:	41 80 fa 01          	cmp    $0x1,%r10b
 1081b75:	0f 84 75 f6 ff ff    	je     10811f0 <check_input_run+0xee0>
 1081b7b:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
 1081b80:	49 01 f9             	add    %rdi,%r9
 1081b83:	4d 89 4a 08          	mov    %r9,0x8(%r10)
 1081b87:	4c 89 84 24 a8 03 00 	mov    %r8,0x3a8(%rsp)
 1081b8e:	00 
 1081b8f:	4d 85 c0             	test   %r8,%r8
 1081b92:	0f 84 64 f6 ff ff    	je     10811fc <check_input_run+0xeec>
 1081b98:	4e 8d 4c 07 3f       	lea    0x3f(%rdi,%r8,1),%r9
 1081b9d:	4e 8d 14 07          	lea    (%rdi,%r8,1),%r10
 1081ba1:	49 83 e1 c0          	and    $0xffffffffffffffc0,%r9
 1081ba5:	4d 39 d1             	cmp    %r10,%r9
 1081ba8:	0f 82 4e f6 ff ff    	jb     10811fc <check_input_run+0xeec>
 1081bae:	4d 89 c8             	mov    %r9,%r8
 1081bb1:	49 29 c8             	sub    %rcx,%r8
 1081bb4:	49 89 d2             	mov    %rdx,%r10
 1081bb7:	4d 29 c2             	sub    %r8,%r10
 1081bba:	0f 82 3c f6 ff ff    	jb     10811fc <check_input_run+0xeec>
 1081bc0:	4c 39 d0             	cmp    %r10,%rax
 1081bc3:	0f 87 33 f6 ff ff    	ja     10811fc <check_input_run+0xeec>
 1081bc9:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
 1081bce:	49 01 c0             	add    %rax,%r8
 1081bd1:	4d 89 42 08          	mov    %r8,0x8(%r10)
 1081bd5:	4c 89 8c 24 b0 03 00 	mov    %r9,0x3b0(%rsp)
 1081bdc:	00 
 1081bdd:	4d 85 c9             	test   %r9,%r9
 1081be0:	0f 84 22 f6 ff ff    	je     1081208 <check_input_run+0xef8>
 1081be6:	4d 8d 44 01 3c       	lea    0x3c(%r9,%rax,1),%r8
 1081beb:	49 01 c1             	add    %rax,%r9
 1081bee:	49 83 e0 c0          	and    $0xffffffffffffffc0,%r8
 1081bf2:	4d 39 c8             	cmp    %r9,%r8
 1081bf5:	0f 82 0d f6 ff ff    	jb     1081208 <check_input_run+0xef8>
 1081bfb:	4d 89 c1             	mov    %r8,%r9
 1081bfe:	49 29 c9             	sub    %rcx,%r9
 1081c01:	49 89 d2             	mov    %rdx,%r10
 1081c04:	4d 29 ca             	sub    %r9,%r10
 1081c07:	0f 82 fb f5 ff ff    	jb     1081208 <check_input_run+0xef8>
 1081c0d:	4c 39 d0             	cmp    %r10,%rax
 1081c10:	0f 87 f2 f5 ff ff    	ja     1081208 <check_input_run+0xef8>
 1081c16:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
 1081c1b:	49 01 c1             	add    %rax,%r9
 1081c1e:	4d 89 4a 08          	mov    %r9,0x8(%r10)
 1081c22:	4c 89 84 24 b8 03 00 	mov    %r8,0x3b8(%rsp)
 1081c29:	00 
 1081c2a:	4d 85 c0             	test   %r8,%r8
 1081c2d:	0f 84 e1 f5 ff ff    	je     1081214 <check_input_run+0xf04>
 1081c33:	4d 8d 4c 00 3c       	lea    0x3c(%r8,%rax,1),%r9
 1081c38:	49 01 c0             	add    %rax,%r8
 1081c3b:	49 83 e1 c0          	and    $0xffffffffffffffc0,%r9
 1081c3f:	4d 39 c1             	cmp    %r8,%r9
 1081c42:	0f 82 cc f5 ff ff    	jb     1081214 <check_input_run+0xf04>
 1081c48:	4d 89 c8             	mov    %r9,%r8
 1081c4b:	49 29 c8             	sub    %rcx,%r8
 1081c4e:	49 89 d2             	mov    %rdx,%r10
 1081c51:	4d 29 c2             	sub    %r8,%r10
 1081c54:	0f 82 ba f5 ff ff    	jb     1081214 <check_input_run+0xf04>
 1081c5a:	4c 39 d0             	cmp    %r10,%rax
 1081c5d:	0f 87 b1 f5 ff ff    	ja     1081214 <check_input_run+0xf04>
 1081c63:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
 1081c68:	49 01 c0             	add    %rax,%r8
 1081c6b:	4d 89 42 08          	mov    %r8,0x8(%r10)
 1081c6f:	4c 89 8c 24 c0 03 00 	mov    %r9,0x3c0(%rsp)
 1081c76:	00 
 1081c77:	4d 85 c9             	test   %r9,%r9
 1081c7a:	0f 84 a0 f5 ff ff    	je     1081220 <check_input_run+0xf10>
 1081c80:	4d 8d 44 01 3c       	lea    0x3c(%r9,%rax,1),%r8
 1081c85:	49 01 c1             	add    %rax,%r9
 1081c88:	49 83 e0 c0          	and    $0xffffffffffffffc0,%r8
 1081c8c:	4d 39 c8             	cmp    %r9,%r8
 1081c8f:	0f 82 8b f5 ff ff    	jb     1081220 <check_input_run+0xf10>
 1081c95:	4d 89 c1             	mov    %r8,%r9
 1081c98:	49 29 c9             	sub    %rcx,%r9
 1081c9b:	49 89 d2             	mov    %rdx,%r10
 1081c9e:	4d 29 ca             	sub    %r9,%r10
 1081ca1:	0f 82 79 f5 ff ff    	jb     1081220 <check_input_run+0xf10>
 1081ca7:	4c 39 d0             	cmp    %r10,%rax
 1081caa:	0f 87 70 f5 ff ff    	ja     1081220 <check_input_run+0xf10>
 1081cb0:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
 1081cb5:	49 01 c1             	add    %rax,%r9
 1081cb8:	4d 89 4a 08          	mov    %r9,0x8(%r10)
 1081cbc:	4c 89 84 24 c8 03 00 	mov    %r8,0x3c8(%rsp)
 1081cc3:	00 
 1081cc4:	4d 85 c0             	test   %r8,%r8
 1081cc7:	0f 84 5f f5 ff ff    	je     108122c <check_input_run+0xf1c>
 1081ccd:	4d 8d 4c 00 3c       	lea    0x3c(%r8,%rax,1),%r9
 1081cd2:	49 01 c0             	add    %rax,%r8
 1081cd5:	49 83 e1 c0          	and    $0xffffffffffffffc0,%r9
 1081cd9:	4d 39 c1             	cmp    %r8,%r9
 1081cdc:	0f 82 4a f5 ff ff    	jb     108122c <check_input_run+0xf1c>
 1081ce2:	4d 89 c8             	mov    %r9,%r8
 1081ce5:	49 29 c8             	sub    %rcx,%r8
 1081ce8:	49 89 d2             	mov    %rdx,%r10
 1081ceb:	4d 29 c2             	sub    %r8,%r10
 1081cee:	0f 82 38 f5 ff ff    	jb     108122c <check_input_run+0xf1c>
 1081cf4:	4c 39 d0             	cmp    %r10,%rax
 1081cf7:	0f 87 2f f5 ff ff    	ja     108122c <check_input_run+0xf1c>
 1081cfd:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
 1081d02:	49 01 c0             	add    %rax,%r8
 1081d05:	4d 89 42 08          	mov    %r8,0x8(%r10)
 1081d09:	4c 89 8c 24 d8 03 00 	mov    %r9,0x3d8(%rsp)
 1081d10:	00 
 1081d11:	4d 85 c9             	test   %r9,%r9
 1081d14:	0f 84 1e f5 ff ff    	je     1081238 <check_input_run+0xf28>
 1081d1a:	4d 8d 44 01 3c       	lea    0x3c(%r9,%rax,1),%r8
 1081d1f:	49 01 c1             	add    %rax,%r9
 1081d22:	49 83 e0 c0          	and    $0xffffffffffffffc0,%r8
 1081d26:	4d 39 c8             	cmp    %r9,%r8
 1081d29:	0f 82 09 f5 ff ff    	jb     1081238 <check_input_run+0xf28>
 1081d2f:	4d 89 c1             	mov    %r8,%r9
 1081d32:	49 29 c9             	sub    %rcx,%r9
 1081d35:	49 89 d2             	mov    %rdx,%r10
 1081d38:	4d 29 ca             	sub    %r9,%r10
 1081d3b:	0f 82 f7 f4 ff ff    	jb     1081238 <check_input_run+0xf28>
 1081d41:	4c 39 d6             	cmp    %r10,%rsi
 1081d44:	0f 87 ee f4 ff ff    	ja     1081238 <check_input_run+0xf28>
 1081d4a:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
 1081d4f:	49 01 f1             	add    %rsi,%r9
 1081d52:	4d 89 4a 08          	mov    %r9,0x8(%r10)
 1081d56:	4c 89 84 24 e0 03 00 	mov    %r8,0x3e0(%rsp)
 1081d5d:	00 
 1081d5e:	4d 85 c0             	test   %r8,%r8
 1081d61:	0f 84 dd f4 ff ff    	je     1081244 <check_input_run+0xf34>
 1081d67:	4d 8d 4c 30 38       	lea    0x38(%r8,%rsi,1),%r9
 1081d6c:	49 01 f0             	add    %rsi,%r8
 1081d6f:	49 83 e1 c0          	and    $0xffffffffffffffc0,%r9
 1081d73:	4d 39 c1             	cmp    %r8,%r9
 1081d76:	0f 82 c8 f4 ff ff    	jb     1081244 <check_input_run+0xf34>
 1081d7c:	4d 89 c8             	mov    %r9,%r8
 1081d7f:	49 29 c8             	sub    %rcx,%r8
 1081d82:	49 89 d2             	mov    %rdx,%r10
 1081d85:	4d 29 c2             	sub    %r8,%r10
 1081d88:	41 0f 92 c3          	setb   %r11b
 1081d8c:	4c 3b 54 24 58       	cmp    0x58(%rsp),%r10
 1081d91:	41 0f 96 c2          	setbe  %r10b
 1081d95:	45 08 da             	or     %r11b,%r10b
 1081d98:	41 80 fa 01          	cmp    $0x1,%r10b
 1081d9c:	0f 84 a2 f4 ff ff    	je     1081244 <check_input_run+0xf34>
 1081da2:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
 1081da7:	49 01 f8             	add    %rdi,%r8
 1081daa:	4d 89 42 08          	mov    %r8,0x8(%r10)
 1081dae:	4c 89 8c 24 e8 03 00 	mov    %r9,0x3e8(%rsp)
 1081db5:	00 
 1081db6:	4d 85 c9             	test   %r9,%r9
 1081db9:	0f 84 91 f4 ff ff    	je     1081250 <check_input_run+0xf40>
 1081dbf:	4e 8d 04 0f          	lea    (%rdi,%r9,1),%r8
 1081dc3:	4e 8d 4c 0f 3f       	lea    0x3f(%rdi,%r9,1),%r9
 1081dc8:	49 83 e1 c0          	and    $0xffffffffffffffc0,%r9
 1081dcc:	4d 39 c1             	cmp    %r8,%r9
 1081dcf:	0f 82 7b f4 ff ff    	jb     1081250 <check_input_run+0xf40>
 1081dd5:	4d 89 c8             	mov    %r9,%r8
 1081dd8:	49 29 c8             	sub    %rcx,%r8
 1081ddb:	49 89 d2             	mov    %rdx,%r10
 1081dde:	4d 29 c2             	sub    %r8,%r10
 1081de1:	0f 82 69 f4 ff ff    	jb     1081250 <check_input_run+0xf40>
 1081de7:	4c 39 d0             	cmp    %r10,%rax
 1081dea:	0f 87 60 f4 ff ff    	ja     1081250 <check_input_run+0xf40>
 1081df0:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
 1081df5:	49 01 c0             	add    %rax,%r8
 1081df8:	4d 89 42 08          	mov    %r8,0x8(%r10)
 1081dfc:	4c 89 8c 24 f0 03 00 	mov    %r9,0x3f0(%rsp)
 1081e03:	00 
 1081e04:	4d 85 c9             	test   %r9,%r9
 1081e07:	0f 84 4f f4 ff ff    	je     108125c <check_input_run+0xf4c>
 1081e0d:	4d 8d 44 01 3c       	lea    0x3c(%r9,%rax,1),%r8
 1081e12:	49 01 c1             	add    %rax,%r9
 1081e15:	49 83 e0 c0          	and    $0xffffffffffffffc0,%r8
 1081e19:	4d 39 c8             	cmp    %r9,%r8
 1081e1c:	0f 82 3a f4 ff ff    	jb     108125c <check_input_run+0xf4c>
 1081e22:	4d 89 c1             	mov    %r8,%r9
 1081e25:	49 29 c9             	sub    %rcx,%r9
 1081e28:	49 89 d2             	mov    %rdx,%r10
 1081e2b:	4d 29 ca             	sub    %r9,%r10
 1081e2e:	0f 82 28 f4 ff ff    	jb     108125c <check_input_run+0xf4c>
 1081e34:	4c 39 d0             	cmp    %r10,%rax
 1081e37:	0f 87 1f f4 ff ff    	ja     108125c <check_input_run+0xf4c>
 1081e3d:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
 1081e42:	49 01 c1             	add    %rax,%r9
 1081e45:	4d 89 4a 08          	mov    %r9,0x8(%r10)
 1081e49:	4c 89 84 24 f8 03 00 	mov    %r8,0x3f8(%rsp)
 1081e50:	00 
 1081e51:	4d 85 c0             	test   %r8,%r8
 1081e54:	0f 84 0e f4 ff ff    	je     1081268 <check_input_run+0xf58>
 1081e5a:	4d 8d 4c 00 3c       	lea    0x3c(%r8,%rax,1),%r9
 1081e5f:	49 01 c0             	add    %rax,%r8
 1081e62:	49 83 e1 c0          	and    $0xffffffffffffffc0,%r9
 1081e66:	4d 39 c1             	cmp    %r8,%r9
 1081e69:	0f 82 f9 f3 ff ff    	jb     1081268 <check_input_run+0xf58>
 1081e6f:	4d 89 c8             	mov    %r9,%r8
 1081e72:	49 29 c8             	sub    %rcx,%r8
 1081e75:	49 89 d2             	mov    %rdx,%r10
 1081e78:	4d 29 c2             	sub    %r8,%r10
 1081e7b:	0f 82 e7 f3 ff ff    	jb     1081268 <check_input_run+0xf58>
 1081e81:	4c 39 d0             	cmp    %r10,%rax
 1081e84:	0f 87 de f3 ff ff    	ja     1081268 <check_input_run+0xf58>
 1081e8a:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
 1081e8f:	49 01 c0             	add    %rax,%r8
 1081e92:	4d 89 42 08          	mov    %r8,0x8(%r10)
 1081e96:	4c 89 8c 24 00 04 00 	mov    %r9,0x400(%rsp)
 1081e9d:	00 
 1081e9e:	4d 85 c9             	test   %r9,%r9
 1081ea1:	0f 84 cd f3 ff ff    	je     1081274 <check_input_run+0xf64>
 1081ea7:	4d 8d 44 01 3c       	lea    0x3c(%r9,%rax,1),%r8
 1081eac:	49 01 c1             	add    %rax,%r9
 1081eaf:	49 83 e0 c0          	and    $0xffffffffffffffc0,%r8
 1081eb3:	4d 39 c8             	cmp    %r9,%r8
 1081eb6:	0f 82 b8 f3 ff ff    	jb     1081274 <check_input_run+0xf64>
 1081ebc:	4d 89 c1             	mov    %r8,%r9
 1081ebf:	49 29 c9             	sub    %rcx,%r9
 1081ec2:	49 89 d2             	mov    %rdx,%r10
 1081ec5:	4d 29 ca             	sub    %r9,%r10
 1081ec8:	0f 82 a6 f3 ff ff    	jb     1081274 <check_input_run+0xf64>
 1081ece:	4c 39 d0             	cmp    %r10,%rax
 1081ed1:	0f 87 9d f3 ff ff    	ja     1081274 <check_input_run+0xf64>
 1081ed7:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
 1081edc:	49 01 c1             	add    %rax,%r9
 1081edf:	4d 89 4a 08          	mov    %r9,0x8(%r10)
 1081ee3:	4c 89 84 24 08 04 00 	mov    %r8,0x408(%rsp)
 1081eea:	00 
 1081eeb:	4d 85 c0             	test   %r8,%r8
 1081eee:	0f 84 8c f3 ff ff    	je     1081280 <check_input_run+0xf70>
 1081ef4:	4d 8d 4c 00 3c       	lea    0x3c(%r8,%rax,1),%r9
 1081ef9:	49 01 c0             	add    %rax,%r8
 1081efc:	49 83 e1 c0          	and    $0xffffffffffffffc0,%r9
 1081f00:	4d 39 c1             	cmp    %r8,%r9
 1081f03:	0f 82 77 f3 ff ff    	jb     1081280 <check_input_run+0xf70>
 1081f09:	4d 89 c8             	mov    %r9,%r8
 1081f0c:	49 29 c8             	sub    %rcx,%r8
 1081f0f:	49 89 d2             	mov    %rdx,%r10
 1081f12:	4d 29 c2             	sub    %r8,%r10
 1081f15:	0f 82 65 f3 ff ff    	jb     1081280 <check_input_run+0xf70>
 1081f1b:	4c 39 d0             	cmp    %r10,%rax
 1081f1e:	0f 87 5c f3 ff ff    	ja     1081280 <check_input_run+0xf70>
 1081f24:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
 1081f29:	49 01 c0             	add    %rax,%r8
 1081f2c:	4d 89 42 08          	mov    %r8,0x8(%r10)
 1081f30:	4c 89 8c 24 10 04 00 	mov    %r9,0x410(%rsp)
 1081f37:	00 
 1081f38:	4d 85 c9             	test   %r9,%r9
 1081f3b:	0f 84 4b f3 ff ff    	je     108128c <check_input_run+0xf7c>
 1081f41:	4d 8d 44 01 3c       	lea    0x3c(%r9,%rax,1),%r8
 1081f46:	49 01 c1             	add    %rax,%r9
 1081f49:	49 83 e0 c0          	and    $0xffffffffffffffc0,%r8
 1081f4d:	4d 39 c8             	cmp    %r9,%r8
 1081f50:	0f 82 36 f3 ff ff    	jb     108128c <check_input_run+0xf7c>
 1081f56:	4d 89 c1             	mov    %r8,%r9
 1081f59:	49 29 c9             	sub    %rcx,%r9
 1081f5c:	49 89 d2             	mov    %rdx,%r10
 1081f5f:	4d 29 ca             	sub    %r9,%r10
 1081f62:	0f 82 24 f3 ff ff    	jb     108128c <check_input_run+0xf7c>
 1081f68:	4c 39 d0             	cmp    %r10,%rax
 1081f6b:	0f 87 1b f3 ff ff    	ja     108128c <check_input_run+0xf7c>
 1081f71:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
 1081f76:	49 01 c1             	add    %rax,%r9
 1081f79:	4d 89 4a 08          	mov    %r9,0x8(%r10)
 1081f7d:	4c 89 84 24 20 04 00 	mov    %r8,0x420(%rsp)
 1081f84:	00 
 1081f85:	4d 85 c0             	test   %r8,%r8
 1081f88:	0f 84 0a f3 ff ff    	je     1081298 <check_input_run+0xf88>
 1081f8e:	4d 8d 4c 00 3c       	lea    0x3c(%r8,%rax,1),%r9
 1081f93:	49 01 c0             	add    %rax,%r8
 1081f96:	49 83 e1 c0          	and    $0xffffffffffffffc0,%r9
 1081f9a:	4d 39 c1             	cmp    %r8,%r9
 1081f9d:	0f 82 f5 f2 ff ff    	jb     1081298 <check_input_run+0xf88>
 1081fa3:	4d 89 ca             	mov    %r9,%r10
 1081fa6:	49 29 ca             	sub    %rcx,%r10
 1081fa9:	49 89 d3             	mov    %rdx,%r11
 1081fac:	4d 29 d3             	sub    %r10,%r11
 1081faf:	0f 82 e3 f2 ff ff    	jb     1081298 <check_input_run+0xf88>
 1081fb5:	4c 8b 44 24 58       	mov    0x58(%rsp),%r8
 1081fba:	4f 8d 44 00 02       	lea    0x2(%r8,%r8,1),%r8
 1081fbf:	4d 39 d8             	cmp    %r11,%r8
 1081fc2:	0f 87 d0 f2 ff ff    	ja     1081298 <check_input_run+0xf88>
 1081fc8:	4c 8b 5c 24 28       	mov    0x28(%rsp),%r11
 1081fcd:	4d 01 c2             	add    %r8,%r10
 1081fd0:	4d 89 53 08          	mov    %r10,0x8(%r11)
 1081fd4:	4c 89 8c 24 68 04 00 	mov    %r9,0x468(%rsp)
 1081fdb:	00 
 1081fdc:	4d 85 c9             	test   %r9,%r9
 1081fdf:	0f 84 bf f2 ff ff    	je     10812a4 <check_input_run+0xf94>
 1081fe5:	4f 8d 14 01          	lea    (%r9,%r8,1),%r10
 1081fe9:	4f 8d 4c 01 3e       	lea    0x3e(%r9,%r8,1),%r9
 1081fee:	49 83 e1 c0          	and    $0xffffffffffffffc0,%r9
 1081ff2:	4d 39 d1             	cmp    %r10,%r9
 1081ff5:	0f 82 a9 f2 ff ff    	jb     10812a4 <check_input_run+0xf94>
 1081ffb:	4d 89 c8             	mov    %r9,%r8
 1081ffe:	49 29 c8             	sub    %rcx,%r8
 1082001:	49 89 d2             	mov    %rdx,%r10
 1082004:	4d 29 c2             	sub    %r8,%r10
 1082007:	0f 82 97 f2 ff ff    	jb     10812a4 <check_input_run+0xf94>
 108200d:	4c 39 d0             	cmp    %r10,%rax
 1082010:	0f 87 8e f2 ff ff    	ja     10812a4 <check_input_run+0xf94>
 1082016:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
 108201b:	49 01 c0             	add    %rax,%r8
 108201e:	4d 89 42 08          	mov    %r8,0x8(%r10)
 1082022:	4c 89 8c 24 70 04 00 	mov    %r9,0x470(%rsp)
 1082029:	00 
 108202a:	4d 85 c9             	test   %r9,%r9
 108202d:	0f 84 7d f2 ff ff    	je     10812b0 <check_input_run+0xfa0>
 1082033:	4d 8d 44 01 3c       	lea    0x3c(%r9,%rax,1),%r8
 1082038:	49 01 c1             	add    %rax,%r9
 108203b:	49 83 e0 c0          	and    $0xffffffffffffffc0,%r8
 108203f:	4d 39 c8             	cmp    %r9,%r8
 1082042:	0f 82 68 f2 ff ff    	jb     10812b0 <check_input_run+0xfa0>
 1082048:	4d 89 c1             	mov    %r8,%r9
 108204b:	49 29 c9             	sub    %rcx,%r9
 108204e:	49 89 d2             	mov    %rdx,%r10
 1082051:	4d 29 ca             	sub    %r9,%r10
 1082054:	0f 82 56 f2 ff ff    	jb     10812b0 <check_input_run+0xfa0>
 108205a:	4c 39 d0             	cmp    %r10,%rax
 108205d:	0f 87 4d f2 ff ff    	ja     10812b0 <check_input_run+0xfa0>
 1082063:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
 1082068:	49 01 c1             	add    %rax,%r9
 108206b:	4d 89 4a 08          	mov    %r9,0x8(%r10)
 108206f:	4c 89 84 24 90 04 00 	mov    %r8,0x490(%rsp)
 1082076:	00 
 1082077:	4d 85 c0             	test   %r8,%r8
 108207a:	0f 84 3c f2 ff ff    	je     10812bc <check_input_run+0xfac>
 1082080:	4d 8d 4c 00 3c       	lea    0x3c(%r8,%rax,1),%r9
 1082085:	49 01 c0             	add    %rax,%r8
 1082088:	49 83 e1 c0          	and    $0xffffffffffffffc0,%r9
 108208c:	4d 39 c1             	cmp    %r8,%r9
 108208f:	0f 82 27 f2 ff ff    	jb     10812bc <check_input_run+0xfac>
 1082095:	4d 89 c8             	mov    %r9,%r8
 1082098:	49 29 c8             	sub    %rcx,%r8
 108209b:	49 89 d2             	mov    %rdx,%r10
 108209e:	4d 29 c2             	sub    %r8,%r10
 10820a1:	0f 82 15 f2 ff ff    	jb     10812bc <check_input_run+0xfac>
 10820a7:	4c 39 d0             	cmp    %r10,%rax
 10820aa:	0f 87 0c f2 ff ff    	ja     10812bc <check_input_run+0xfac>
 10820b0:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
 10820b5:	49 01 c0             	add    %rax,%r8
 10820b8:	4d 89 42 08          	mov    %r8,0x8(%r10)
 10820bc:	4c 89 8c 24 98 04 00 	mov    %r9,0x498(%rsp)
 10820c3:	00 
 10820c4:	4d 85 c9             	test   %r9,%r9
 10820c7:	0f 84 fb f1 ff ff    	je     10812c8 <check_input_run+0xfb8>
 10820cd:	4d 8d 44 01 3c       	lea    0x3c(%r9,%rax,1),%r8
 10820d2:	49 01 c1             	add    %rax,%r9
 10820d5:	49 83 e0 c0          	and    $0xffffffffffffffc0,%r8
 10820d9:	4d 39 c8             	cmp    %r9,%r8
 10820dc:	0f 82 e6 f1 ff ff    	jb     10812c8 <check_input_run+0xfb8>
 10820e2:	4d 89 c1             	mov    %r8,%r9
 10820e5:	49 29 c9             	sub    %rcx,%r9
 10820e8:	49 89 d2             	mov    %rdx,%r10
 10820eb:	4d 29 ca             	sub    %r9,%r10
 10820ee:	0f 82 d4 f1 ff ff    	jb     10812c8 <check_input_run+0xfb8>
 10820f4:	4c 39 d0             	cmp    %r10,%rax
 10820f7:	0f 87 cb f1 ff ff    	ja     10812c8 <check_input_run+0xfb8>
 10820fd:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
 1082102:	49 01 c1             	add    %rax,%r9
 1082105:	4d 89 4a 08          	mov    %r9,0x8(%r10)
 1082109:	4c 89 84 24 a8 04 00 	mov    %r8,0x4a8(%rsp)
 1082110:	00 
 1082111:	4d 85 c0             	test   %r8,%r8
 1082114:	0f 84 ba f1 ff ff    	je     10812d4 <check_input_run+0xfc4>
 108211a:	4d 8d 4c 00 3c       	lea    0x3c(%r8,%rax,1),%r9
 108211f:	49 01 c0             	add    %rax,%r8
 1082122:	49 83 e1 c0          	and    $0xffffffffffffffc0,%r9
 1082126:	4d 39 c1             	cmp    %r8,%r9
 1082129:	0f 82 a5 f1 ff ff    	jb     10812d4 <check_input_run+0xfc4>
 108212f:	4d 89 c8             	mov    %r9,%r8
 1082132:	49 29 c8             	sub    %rcx,%r8
 1082135:	49 89 d2             	mov    %rdx,%r10
 1082138:	4d 29 c2             	sub    %r8,%r10
 108213b:	0f 82 93 f1 ff ff    	jb     10812d4 <check_input_run+0xfc4>
 1082141:	4c 39 d0             	cmp    %r10,%rax
 1082144:	0f 87 8a f1 ff ff    	ja     10812d4 <check_input_run+0xfc4>
 108214a:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
 108214f:	49 01 c0             	add    %rax,%r8
 1082152:	4d 89 42 08          	mov    %r8,0x8(%r10)
 1082156:	4c 89 8c 24 b0 04 00 	mov    %r9,0x4b0(%rsp)
 108215d:	00 
 108215e:	4d 85 c9             	test   %r9,%r9
 1082161:	0f 84 79 f1 ff ff    	je     10812e0 <check_input_run+0xfd0>
 1082167:	4d 8d 44 01 3c       	lea    0x3c(%r9,%rax,1),%r8
 108216c:	49 01 c1             	add    %rax,%r9
 108216f:	49 83 e0 c0          	and    $0xffffffffffffffc0,%r8
 1082173:	4d 39 c8             	cmp    %r9,%r8
 1082176:	0f 82 64 f1 ff ff    	jb     10812e0 <check_input_run+0xfd0>
 108217c:	4d 89 c1             	mov    %r8,%r9
 108217f:	49 29 c9             	sub    %rcx,%r9
 1082182:	49 89 d2             	mov    %rdx,%r10
 1082185:	4d 29 ca             	sub    %r9,%r10
 1082188:	0f 82 52 f1 ff ff    	jb     10812e0 <check_input_run+0xfd0>
 108218e:	4c 39 d0             	cmp    %r10,%rax
 1082191:	0f 87 49 f1 ff ff    	ja     10812e0 <check_input_run+0xfd0>
 1082197:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
 108219c:	49 01 c1             	add    %rax,%r9
 108219f:	4d 89 4a 08          	mov    %r9,0x8(%r10)
 10821a3:	4c 89 84 24 b8 04 00 	mov    %r8,0x4b8(%rsp)
 10821aa:	00 
 10821ab:	4d 85 c0             	test   %r8,%r8
 10821ae:	0f 84 38 f1 ff ff    	je     10812ec <check_input_run+0xfdc>
 10821b4:	4d 8d 4c 00 3c       	lea    0x3c(%r8,%rax,1),%r9
 10821b9:	49 01 c0             	add    %rax,%r8
 10821bc:	49 83 e1 c0          	and    $0xffffffffffffffc0,%r9
 10821c0:	4d 39 c1             	cmp    %r8,%r9
 10821c3:	0f 82 23 f1 ff ff    	jb     10812ec <check_input_run+0xfdc>
 10821c9:	4d 89 c8             	mov    %r9,%r8
 10821cc:	49 29 c8             	sub    %rcx,%r8
 10821cf:	49 89 d2             	mov    %rdx,%r10
 10821d2:	4d 29 c2             	sub    %r8,%r10
 10821d5:	41 0f 92 c3          	setb   %r11b
 10821d9:	4c 3b 54 24 58       	cmp    0x58(%rsp),%r10
 10821de:	41 0f 96 c2          	setbe  %r10b
 10821e2:	45 08 da             	or     %r11b,%r10b
 10821e5:	41 80 fa 01          	cmp    $0x1,%r10b
 10821e9:	0f 84 fd f0 ff ff    	je     10812ec <check_input_run+0xfdc>
 10821ef:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
 10821f4:	49 01 f8             	add    %rdi,%r8
 10821f7:	4d 89 42 08          	mov    %r8,0x8(%r10)
 10821fb:	4c 89 8c 24 c8 04 00 	mov    %r9,0x4c8(%rsp)
 1082202:	00 
 1082203:	4d 85 c9             	test   %r9,%r9
 1082206:	0f 84 ec f0 ff ff    	je     10812f8 <check_input_run+0xfe8>
 108220c:	4e 8d 44 0f 3f       	lea    0x3f(%rdi,%r9,1),%r8
 1082211:	4e 8d 14 0f          	lea    (%rdi,%r9,1),%r10
 1082215:	49 83 e0 c0          	and    $0xffffffffffffffc0,%r8
 1082219:	4d 39 d0             	cmp    %r10,%r8
 108221c:	0f 82 d6 f0 ff ff    	jb     10812f8 <check_input_run+0xfe8>
 1082222:	4d 89 c1             	mov    %r8,%r9
 1082225:	49 29 c9             	sub    %rcx,%r9
 1082228:	49 89 d2             	mov    %rdx,%r10
 108222b:	4d 29 ca             	sub    %r9,%r10
 108222e:	41 0f 92 c3          	setb   %r11b
 1082232:	4c 3b 54 24 58       	cmp    0x58(%rsp),%r10
 1082237:	41 0f 96 c2          	setbe  %r10b
 108223b:	45 08 da             	or     %r11b,%r10b
 108223e:	41 80 fa 01          	cmp    $0x1,%r10b
 1082242:	0f 84 b0 f0 ff ff    	je     10812f8 <check_input_run+0xfe8>
 1082248:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
 108224d:	49 01 f9             	add    %rdi,%r9
 1082250:	4d 89 4a 08          	mov    %r9,0x8(%r10)
 1082254:	4c 89 84 24 d0 04 00 	mov    %r8,0x4d0(%rsp)
 108225b:	00 
 108225c:	4d 85 c0             	test   %r8,%r8
 108225f:	0f 84 9f f0 ff ff    	je     1081304 <check_input_run+0xff4>
 1082265:	4e 8d 0c 07          	lea    (%rdi,%r8,1),%r9
 1082269:	4e 8d 44 07 3f       	lea    0x3f(%rdi,%r8,1),%r8
 108226e:	49 83 e0 c0          	and    $0xffffffffffffffc0,%r8
 1082272:	4d 39 c8             	cmp    %r9,%r8
 1082275:	0f 82 89 f0 ff ff    	jb     1081304 <check_input_run+0xff4>
 108227b:	4d 89 c1             	mov    %r8,%r9
 108227e:	49 29 c9             	sub    %rcx,%r9
 1082281:	49 89 d2             	mov    %rdx,%r10
 1082284:	4d 29 ca             	sub    %r9,%r10
 1082287:	41 0f 92 c3          	setb   %r11b
 108228b:	4c 3b 54 24 58       	cmp    0x58(%rsp),%r10
 1082290:	41 0f 96 c2          	setbe  %r10b
 1082294:	45 08 da             	or     %r11b,%r10b
 1082297:	41 80 fa 01          	cmp    $0x1,%r10b
 108229b:	0f 84 63 f0 ff ff    	je     1081304 <check_input_run+0xff4>
 10822a1:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
 10822a6:	49 01 f9             	add    %rdi,%r9
 10822a9:	4d 89 4a 08          	mov    %r9,0x8(%r10)
 10822ad:	4c 89 84 24 e0 04 00 	mov    %r8,0x4e0(%rsp)
 10822b4:	00 
 10822b5:	4d 85 c0             	test   %r8,%r8
 10822b8:	0f 84 52 f0 ff ff    	je     1081310 <check_input_run+0x1000>
 10822be:	4e 8d 0c 07          	lea    (%rdi,%r8,1),%r9
 10822c2:	4e 8d 44 07 3f       	lea    0x3f(%rdi,%r8,1),%r8
 10822c7:	49 83 e0 c0          	and    $0xffffffffffffffc0,%r8
 10822cb:	4d 39 c8             	cmp    %r9,%r8
 10822ce:	0f 82 3c f0 ff ff    	jb     1081310 <check_input_run+0x1000>
 10822d4:	4d 89 c1             	mov    %r8,%r9
 10822d7:	49 29 c9             	sub    %rcx,%r9
 10822da:	49 89 d2             	mov    %rdx,%r10
 10822dd:	4d 29 ca             	sub    %r9,%r10
 10822e0:	41 0f 92 c3          	setb   %r11b
 10822e4:	4c 3b 54 24 58       	cmp    0x58(%rsp),%r10
 10822e9:	41 0f 96 c2          	setbe  %r10b
 10822ed:	45 08 da             	or     %r11b,%r10b
 10822f0:	41 80 fa 01          	cmp    $0x1,%r10b
 10822f4:	0f 84 16 f0 ff ff    	je     1081310 <check_input_run+0x1000>
 10822fa:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
 10822ff:	49 01 f9             	add    %rdi,%r9
 1082302:	4d 89 4a 08          	mov    %r9,0x8(%r10)
 1082306:	4c 89 84 24 e8 04 00 	mov    %r8,0x4e8(%rsp)
 108230d:	00 
 108230e:	4d 85 c0             	test   %r8,%r8
 1082311:	0f 84 05 f0 ff ff    	je     108131c <check_input_run+0x100c>
 1082317:	4e 8d 4c 07 3f       	lea    0x3f(%rdi,%r8,1),%r9
 108231c:	4e 8d 14 07          	lea    (%rdi,%r8,1),%r10
 1082320:	49 83 e1 c0          	and    $0xffffffffffffffc0,%r9
 1082324:	4d 39 d1             	cmp    %r10,%r9
 1082327:	0f 82 ef ef ff ff    	jb     108131c <check_input_run+0x100c>
 108232d:	4d 89 c8             	mov    %r9,%r8
 1082330:	49 29 c8             	sub    %rcx,%r8
 1082333:	49 89 d2             	mov    %rdx,%r10
 1082336:	4d 29 c2             	sub    %r8,%r10
 1082339:	0f 82 dd ef ff ff    	jb     108131c <check_input_run+0x100c>
 108233f:	4c 39 d0             	cmp    %r10,%rax
 1082342:	0f 87 d4 ef ff ff    	ja     108131c <check_input_run+0x100c>
 1082348:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
 108234d:	49 01 c0             	add    %rax,%r8
 1082350:	4d 89 42 08          	mov    %r8,0x8(%r10)
 1082354:	4c 89 8c 24 f0 04 00 	mov    %r9,0x4f0(%rsp)
 108235b:	00 
 108235c:	4d 85 c9             	test   %r9,%r9
 108235f:	0f 84 c3 ef ff ff    	je     1081328 <check_input_run+0x1018>
 1082365:	4d 8d 44 01 3c       	lea    0x3c(%r9,%rax,1),%r8
 108236a:	49 01 c1             	add    %rax,%r9
 108236d:	49 83 e0 c0          	and    $0xffffffffffffffc0,%r8
 1082371:	4d 39 c8             	cmp    %r9,%r8
 1082374:	0f 82 ae ef ff ff    	jb     1081328 <check_input_run+0x1018>
 108237a:	4d 89 c1             	mov    %r8,%r9
 108237d:	49 29 c9             	sub    %rcx,%r9
 1082380:	49 89 d2             	mov    %rdx,%r10
 1082383:	4d 29 ca             	sub    %r9,%r10
 1082386:	0f 82 9c ef ff ff    	jb     1081328 <check_input_run+0x1018>
 108238c:	4c 39 d0             	cmp    %r10,%rax
 108238f:	0f 87 93 ef ff ff    	ja     1081328 <check_input_run+0x1018>
 1082395:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
 108239a:	49 01 c1             	add    %rax,%r9
 108239d:	4d 89 4a 08          	mov    %r9,0x8(%r10)
 10823a1:	4c 89 84 24 f8 04 00 	mov    %r8,0x4f8(%rsp)
 10823a8:	00 
 10823a9:	4d 85 c0             	test   %r8,%r8
 10823ac:	0f 84 82 ef ff ff    	je     1081334 <check_input_run+0x1024>
 10823b2:	4d 8d 4c 00 3c       	lea    0x3c(%r8,%rax,1),%r9
 10823b7:	49 01 c0             	add    %rax,%r8
 10823ba:	49 83 e1 c0          	and    $0xffffffffffffffc0,%r9
 10823be:	4d 39 c1             	cmp    %r8,%r9
 10823c1:	0f 82 6d ef ff ff    	jb     1081334 <check_input_run+0x1024>
 10823c7:	4d 89 c8             	mov    %r9,%r8
 10823ca:	49 29 c8             	sub    %rcx,%r8
 10823cd:	49 89 d2             	mov    %rdx,%r10
 10823d0:	4d 29 c2             	sub    %r8,%r10
 10823d3:	41 0f 92 c3          	setb   %r11b
 10823d7:	4c 3b 54 24 58       	cmp    0x58(%rsp),%r10
 10823dc:	41 0f 96 c2          	setbe  %r10b
 10823e0:	45 08 da             	or     %r11b,%r10b
 10823e3:	41 80 fa 01          	cmp    $0x1,%r10b
 10823e7:	0f 84 47 ef ff ff    	je     1081334 <check_input_run+0x1024>
 10823ed:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
 10823f2:	49 01 f8             	add    %rdi,%r8
 10823f5:	4d 89 42 08          	mov    %r8,0x8(%r10)
 10823f9:	4c 89 8c 24 00 05 00 	mov    %r9,0x500(%rsp)
 1082400:	00 
 1082401:	4d 85 c9             	test   %r9,%r9
 1082404:	0f 84 36 ef ff ff    	je     1081340 <check_input_run+0x1030>
 108240a:	4e 8d 44 0f 3f       	lea    0x3f(%rdi,%r9,1),%r8
 108240f:	4e 8d 14 0f          	lea    (%rdi,%r9,1),%r10
 1082413:	49 83 e0 c0          	and    $0xffffffffffffffc0,%r8
 1082417:	4d 39 d0             	cmp    %r10,%r8
 108241a:	0f 82 20 ef ff ff    	jb     1081340 <check_input_run+0x1030>
 1082420:	4d 89 c1             	mov    %r8,%r9
 1082423:	49 29 c9             	sub    %rcx,%r9
 1082426:	49 89 d2             	mov    %rdx,%r10
 1082429:	4d 29 ca             	sub    %r9,%r10
 108242c:	41 0f 92 c3          	setb   %r11b
 1082430:	4c 3b 54 24 58       	cmp    0x58(%rsp),%r10
 1082435:	41 0f 96 c2          	setbe  %r10b
 1082439:	45 08 da             	or     %r11b,%r10b
 108243c:	41 80 fa 01          	cmp    $0x1,%r10b
 1082440:	0f 84 fa ee ff ff    	je     1081340 <check_input_run+0x1030>
 1082446:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
 108244b:	49 01 f9             	add    %rdi,%r9
 108244e:	4d 89 4a 08          	mov    %r9,0x8(%r10)
 1082452:	4c 89 84 24 08 05 00 	mov    %r8,0x508(%rsp)
 1082459:	00 
 108245a:	4d 85 c0             	test   %r8,%r8
 108245d:	0f 84 e9 ee ff ff    	je     108134c <check_input_run+0x103c>
 1082463:	4e 8d 0c 07          	lea    (%rdi,%r8,1),%r9
 1082467:	4e 8d 44 07 3f       	lea    0x3f(%rdi,%r8,1),%r8
 108246c:	49 83 e0 c0          	and    $0xffffffffffffffc0,%r8
 1082470:	4d 39 c8             	cmp    %r9,%r8
 1082473:	0f 82 d3 ee ff ff    	jb     108134c <check_input_run+0x103c>
 1082479:	4d 89 c1             	mov    %r8,%r9
 108247c:	49 29 c9             	sub    %rcx,%r9
 108247f:	49 89 d2             	mov    %rdx,%r10
 1082482:	4d 29 ca             	sub    %r9,%r10
 1082485:	0f 82 c1 ee ff ff    	jb     108134c <check_input_run+0x103c>
 108248b:	4c 39 d6             	cmp    %r10,%rsi
 108248e:	0f 87 b8 ee ff ff    	ja     108134c <check_input_run+0x103c>
 1082494:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
 1082499:	49 01 f1             	add    %rsi,%r9
 108249c:	4d 89 4a 08          	mov    %r9,0x8(%r10)
 10824a0:	4c 89 84 24 10 05 00 	mov    %r8,0x510(%rsp)
 10824a7:	00 
 10824a8:	4d 85 c0             	test   %r8,%r8
 10824ab:	0f 84 a7 ee ff ff    	je     1081358 <check_input_run+0x1048>
 10824b1:	4d 8d 0c 30          	lea    (%r8,%rsi,1),%r9
 10824b5:	4d 8d 44 30 38       	lea    0x38(%r8,%rsi,1),%r8
 10824ba:	49 83 e0 c0          	and    $0xffffffffffffffc0,%r8
 10824be:	4d 39 c8             	cmp    %r9,%r8
 10824c1:	0f 82 91 ee ff ff    	jb     1081358 <check_input_run+0x1048>
 10824c7:	4c 89 c6             	mov    %r8,%rsi
 10824ca:	48 29 ce             	sub    %rcx,%rsi
 10824cd:	49 89 d1             	mov    %rdx,%r9
 10824d0:	49 29 f1             	sub    %rsi,%r9
 10824d3:	0f 82 7f ee ff ff    	jb     1081358 <check_input_run+0x1048>
 10824d9:	4c 39 c8             	cmp    %r9,%rax
 10824dc:	0f 87 76 ee ff ff    	ja     1081358 <check_input_run+0x1048>
 10824e2:	4c 8b 4c 24 28       	mov    0x28(%rsp),%r9
 10824e7:	48 01 c6             	add    %rax,%rsi
 10824ea:	49 89 71 08          	mov    %rsi,0x8(%r9)
 10824ee:	4c 89 84 24 30 05 00 	mov    %r8,0x530(%rsp)
 10824f5:	00 
 10824f6:	4d 85 c0             	test   %r8,%r8
 10824f9:	0f 84 65 ee ff ff    	je     1081364 <check_input_run+0x1054>
 10824ff:	49 8d 74 00 3c       	lea    0x3c(%r8,%rax,1),%rsi
 1082504:	49 01 c0             	add    %rax,%r8
 1082507:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 108250b:	4c 39 c6             	cmp    %r8,%rsi
 108250e:	0f 82 50 ee ff ff    	jb     1081364 <check_input_run+0x1054>
 1082514:	49 89 f0             	mov    %rsi,%r8
 1082517:	49 29 c8             	sub    %rcx,%r8
 108251a:	49 89 d1             	mov    %rdx,%r9
 108251d:	4d 29 c1             	sub    %r8,%r9
 1082520:	0f 82 3e ee ff ff    	jb     1081364 <check_input_run+0x1054>
 1082526:	4c 39 c8             	cmp    %r9,%rax
 1082529:	0f 87 35 ee ff ff    	ja     1081364 <check_input_run+0x1054>
 108252f:	4c 8b 4c 24 28       	mov    0x28(%rsp),%r9
 1082534:	49 01 c0             	add    %rax,%r8
 1082537:	4d 89 41 08          	mov    %r8,0x8(%r9)
 108253b:	48 89 b4 24 38 05 00 	mov    %rsi,0x538(%rsp)
 1082542:	00 
 1082543:	48 85 f6             	test   %rsi,%rsi
 1082546:	0f 84 24 ee ff ff    	je     1081370 <check_input_run+0x1060>
 108254c:	4c 8d 44 06 3c       	lea    0x3c(%rsi,%rax,1),%r8
 1082551:	48 01 c6             	add    %rax,%rsi
 1082554:	49 83 e0 c0          	and    $0xffffffffffffffc0,%r8
 1082558:	49 39 f0             	cmp    %rsi,%r8
 108255b:	0f 82 0f ee ff ff    	jb     1081370 <check_input_run+0x1060>
 1082561:	4c 89 c6             	mov    %r8,%rsi
 1082564:	48 29 ce             	sub    %rcx,%rsi
 1082567:	49 89 d1             	mov    %rdx,%r9
 108256a:	49 29 f1             	sub    %rsi,%r9
 108256d:	0f 82 fd ed ff ff    	jb     1081370 <check_input_run+0x1060>
 1082573:	4c 39 c8             	cmp    %r9,%rax
 1082576:	0f 87 f4 ed ff ff    	ja     1081370 <check_input_run+0x1060>
 108257c:	4c 8b 4c 24 28       	mov    0x28(%rsp),%r9
 1082581:	48 01 c6             	add    %rax,%rsi
 1082584:	49 89 71 08          	mov    %rsi,0x8(%r9)
 1082588:	4c 89 84 24 58 05 00 	mov    %r8,0x558(%rsp)
 108258f:	00 
 1082590:	4d 85 c0             	test   %r8,%r8
 1082593:	0f 84 e3 ed ff ff    	je     108137c <check_input_run+0x106c>
 1082599:	49 8d 74 00 3c       	lea    0x3c(%r8,%rax,1),%rsi
 108259e:	49 01 c0             	add    %rax,%r8
 10825a1:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 10825a5:	4c 39 c6             	cmp    %r8,%rsi
 10825a8:	0f 82 ce ed ff ff    	jb     108137c <check_input_run+0x106c>
 10825ae:	49 89 f0             	mov    %rsi,%r8
 10825b1:	49 29 c8             	sub    %rcx,%r8
 10825b4:	49 89 d1             	mov    %rdx,%r9
 10825b7:	4d 29 c1             	sub    %r8,%r9
 10825ba:	41 0f 92 c2          	setb   %r10b
 10825be:	4c 3b 4c 24 58       	cmp    0x58(%rsp),%r9
 10825c3:	41 0f 96 c1          	setbe  %r9b
 10825c7:	45 08 d1             	or     %r10b,%r9b
 10825ca:	41 80 f9 01          	cmp    $0x1,%r9b
 10825ce:	0f 84 a8 ed ff ff    	je     108137c <check_input_run+0x106c>
 10825d4:	4c 8b 4c 24 28       	mov    0x28(%rsp),%r9
 10825d9:	49 01 f8             	add    %rdi,%r8
 10825dc:	4d 89 41 08          	mov    %r8,0x8(%r9)
 10825e0:	48 89 b4 24 60 05 00 	mov    %rsi,0x560(%rsp)
 10825e7:	00 
 10825e8:	48 85 f6             	test   %rsi,%rsi
 10825eb:	0f 84 97 ed ff ff    	je     1081388 <check_input_run+0x1078>
 10825f1:	4c 8d 04 37          	lea    (%rdi,%rsi,1),%r8
 10825f5:	48 8d 7c 37 3f       	lea    0x3f(%rdi,%rsi,1),%rdi
 10825fa:	48 83 e7 c0          	and    $0xffffffffffffffc0,%rdi
 10825fe:	4c 39 c7             	cmp    %r8,%rdi
 1082601:	0f 82 81 ed ff ff    	jb     1081388 <check_input_run+0x1078>
 1082607:	48 89 fe             	mov    %rdi,%rsi
 108260a:	48 29 ce             	sub    %rcx,%rsi
 108260d:	49 89 d0             	mov    %rdx,%r8
 1082610:	49 29 f0             	sub    %rsi,%r8
 1082613:	0f 82 6f ed ff ff    	jb     1081388 <check_input_run+0x1078>
 1082619:	4c 39 c0             	cmp    %r8,%rax
 108261c:	0f 87 66 ed ff ff    	ja     1081388 <check_input_run+0x1078>
 1082622:	4c 8b 44 24 28       	mov    0x28(%rsp),%r8
 1082627:	48 01 c6             	add    %rax,%rsi
 108262a:	49 89 70 08          	mov    %rsi,0x8(%r8)
 108262e:	48 89 bc 24 68 05 00 	mov    %rdi,0x568(%rsp)
 1082635:	00 
 1082636:	48 85 ff             	test   %rdi,%rdi
 1082639:	0f 84 55 ed ff ff    	je     1081394 <check_input_run+0x1084>
 108263f:	48 8d 74 07 3c       	lea    0x3c(%rdi,%rax,1),%rsi
 1082644:	48 01 c7             	add    %rax,%rdi
 1082647:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 108264b:	48 39 fe             	cmp    %rdi,%rsi
 108264e:	0f 82 40 ed ff ff    	jb     1081394 <check_input_run+0x1084>
 1082654:	48 89 f7             	mov    %rsi,%rdi
 1082657:	48 29 cf             	sub    %rcx,%rdi
 108265a:	49 89 d0             	mov    %rdx,%r8
 108265d:	49 29 f8             	sub    %rdi,%r8
 1082660:	0f 82 2e ed ff ff    	jb     1081394 <check_input_run+0x1084>
 1082666:	4c 39 c0             	cmp    %r8,%rax
 1082669:	0f 87 25 ed ff ff    	ja     1081394 <check_input_run+0x1084>
 108266f:	4c 8b 44 24 28       	mov    0x28(%rsp),%r8
 1082674:	48 01 c7             	add    %rax,%rdi
 1082677:	49 89 78 08          	mov    %rdi,0x8(%r8)
 108267b:	48 89 b4 24 70 05 00 	mov    %rsi,0x570(%rsp)
 1082682:	00 
 1082683:	48 85 f6             	test   %rsi,%rsi
 1082686:	0f 84 14 ed ff ff    	je     10813a0 <check_input_run+0x1090>
 108268c:	48 8d 7c 06 3c       	lea    0x3c(%rsi,%rax,1),%rdi
 1082691:	48 01 c6             	add    %rax,%rsi
 1082694:	48 83 e7 c0          	and    $0xffffffffffffffc0,%rdi
 1082698:	48 39 f7             	cmp    %rsi,%rdi
 108269b:	0f 82 ff ec ff ff    	jb     10813a0 <check_input_run+0x1090>
 10826a1:	48 89 fe             	mov    %rdi,%rsi
 10826a4:	48 29 ce             	sub    %rcx,%rsi
 10826a7:	49 89 d0             	mov    %rdx,%r8
 10826aa:	49 29 f0             	sub    %rsi,%r8
 10826ad:	0f 82 ed ec ff ff    	jb     10813a0 <check_input_run+0x1090>
 10826b3:	4c 39 c0             	cmp    %r8,%rax
 10826b6:	0f 87 e4 ec ff ff    	ja     10813a0 <check_input_run+0x1090>
 10826bc:	4c 8b 44 24 28       	mov    0x28(%rsp),%r8
 10826c1:	48 01 c6             	add    %rax,%rsi
 10826c4:	49 89 70 08          	mov    %rsi,0x8(%r8)
 10826c8:	48 89 bc 24 90 05 00 	mov    %rdi,0x590(%rsp)
 10826cf:	00 
 10826d0:	48 85 ff             	test   %rdi,%rdi
 10826d3:	0f 84 d3 ec ff ff    	je     10813ac <check_input_run+0x109c>
 10826d9:	48 8d 74 07 3c       	lea    0x3c(%rdi,%rax,1),%rsi
 10826de:	48 01 c7             	add    %rax,%rdi
 10826e1:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 10826e5:	48 39 fe             	cmp    %rdi,%rsi
 10826e8:	0f 82 be ec ff ff    	jb     10813ac <check_input_run+0x109c>
 10826ee:	48 89 f7             	mov    %rsi,%rdi
 10826f1:	48 29 cf             	sub    %rcx,%rdi
 10826f4:	49 89 d0             	mov    %rdx,%r8
 10826f7:	49 29 f8             	sub    %rdi,%r8
 10826fa:	0f 82 ac ec ff ff    	jb     10813ac <check_input_run+0x109c>
 1082700:	4c 39 c0             	cmp    %r8,%rax
 1082703:	0f 87 a3 ec ff ff    	ja     10813ac <check_input_run+0x109c>
 1082709:	4c 8b 44 24 28       	mov    0x28(%rsp),%r8
 108270e:	48 01 c7             	add    %rax,%rdi
 1082711:	49 89 78 08          	mov    %rdi,0x8(%r8)
 1082715:	48 89 b4 24 98 05 00 	mov    %rsi,0x598(%rsp)
 108271c:	00 
 108271d:	48 85 f6             	test   %rsi,%rsi
 1082720:	0f 84 92 ec ff ff    	je     10813b8 <check_input_run+0x10a8>
 1082726:	48 8d 7c 06 3c       	lea    0x3c(%rsi,%rax,1),%rdi
 108272b:	48 01 c6             	add    %rax,%rsi
 108272e:	48 83 e7 c0          	and    $0xffffffffffffffc0,%rdi
 1082732:	48 39 f7             	cmp    %rsi,%rdi
 1082735:	0f 82 7d ec ff ff    	jb     10813b8 <check_input_run+0x10a8>
 108273b:	49 89 f8             	mov    %rdi,%r8
 108273e:	49 29 c8             	sub    %rcx,%r8
 1082741:	49 89 d1             	mov    %rdx,%r9
 1082744:	4d 29 c1             	sub    %r8,%r9
 1082747:	0f 82 6b ec ff ff    	jb     10813b8 <check_input_run+0x10a8>
 108274d:	48 8b 74 24 58       	mov    0x58(%rsp),%rsi
 1082752:	48 c1 e6 04          	shl    $0x4,%rsi
 1082756:	48 83 c6 10          	add    $0x10,%rsi
 108275a:	4c 39 ce             	cmp    %r9,%rsi
 108275d:	0f 87 55 ec ff ff    	ja     10813b8 <check_input_run+0x10a8>
 1082763:	4c 8b 4c 24 28       	mov    0x28(%rsp),%r9
 1082768:	49 01 f0             	add    %rsi,%r8
 108276b:	4d 89 41 08          	mov    %r8,0x8(%r9)
 108276f:	48 89 bc 24 a0 05 00 	mov    %rdi,0x5a0(%rsp)
 1082776:	00 
 1082777:	48 85 ff             	test   %rdi,%rdi
 108277a:	0f 84 44 ec ff ff    	je     10813c4 <check_input_run+0x10b4>
 1082780:	4c 8d 04 37          	lea    (%rdi,%rsi,1),%r8
 1082784:	48 8d 7c 37 30       	lea    0x30(%rdi,%rsi,1),%rdi
 1082789:	48 83 e7 c0          	and    $0xffffffffffffffc0,%rdi
 108278d:	4c 39 c7             	cmp    %r8,%rdi
 1082790:	0f 82 2e ec ff ff    	jb     10813c4 <check_input_run+0x10b4>
 1082796:	48 89 fe             	mov    %rdi,%rsi
 1082799:	48 29 ce             	sub    %rcx,%rsi
 108279c:	49 89 d0             	mov    %rdx,%r8
 108279f:	49 29 f0             	sub    %rsi,%r8
 10827a2:	0f 82 1c ec ff ff    	jb     10813c4 <check_input_run+0x10b4>
 10827a8:	4c 39 c0             	cmp    %r8,%rax
 10827ab:	0f 87 13 ec ff ff    	ja     10813c4 <check_input_run+0x10b4>
 10827b1:	4c 8b 44 24 28       	mov    0x28(%rsp),%r8
 10827b6:	48 01 c6             	add    %rax,%rsi
 10827b9:	49 89 70 08          	mov    %rsi,0x8(%r8)
 10827bd:	48 89 bc 24 a8 05 00 	mov    %rdi,0x5a8(%rsp)
 10827c4:	00 
 10827c5:	48 85 ff             	test   %rdi,%rdi
 10827c8:	0f 84 02 ec ff ff    	je     10813d0 <check_input_run+0x10c0>
 10827ce:	48 8d 74 07 3c       	lea    0x3c(%rdi,%rax,1),%rsi
 10827d3:	48 01 c7             	add    %rax,%rdi
 10827d6:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 10827da:	48 39 fe             	cmp    %rdi,%rsi
 10827dd:	0f 82 ed eb ff ff    	jb     10813d0 <check_input_run+0x10c0>
 10827e3:	48 89 f7             	mov    %rsi,%rdi
 10827e6:	48 29 cf             	sub    %rcx,%rdi
 10827e9:	49 89 d0             	mov    %rdx,%r8
 10827ec:	49 29 f8             	sub    %rdi,%r8
 10827ef:	0f 82 db eb ff ff    	jb     10813d0 <check_input_run+0x10c0>
 10827f5:	4c 39 c0             	cmp    %r8,%rax
 10827f8:	0f 87 d2 eb ff ff    	ja     10813d0 <check_input_run+0x10c0>
 10827fe:	4c 8b 44 24 28       	mov    0x28(%rsp),%r8
 1082803:	48 01 c7             	add    %rax,%rdi
 1082806:	49 89 78 08          	mov    %rdi,0x8(%r8)
 108280a:	48 89 b4 24 c8 05 00 	mov    %rsi,0x5c8(%rsp)
 1082811:	00 
 1082812:	48 85 f6             	test   %rsi,%rsi
 1082815:	0f 84 c1 eb ff ff    	je     10813dc <check_input_run+0x10cc>
 108281b:	48 8d 7c 06 3c       	lea    0x3c(%rsi,%rax,1),%rdi
 1082820:	48 01 c6             	add    %rax,%rsi
 1082823:	48 83 e7 c0          	and    $0xffffffffffffffc0,%rdi
 1082827:	48 39 f7             	cmp    %rsi,%rdi
 108282a:	0f 82 ac eb ff ff    	jb     10813dc <check_input_run+0x10cc>
 1082830:	48 89 fe             	mov    %rdi,%rsi
 1082833:	48 29 ce             	sub    %rcx,%rsi
 1082836:	49 89 d0             	mov    %rdx,%r8
 1082839:	49 29 f0             	sub    %rsi,%r8
 108283c:	0f 82 9a eb ff ff    	jb     10813dc <check_input_run+0x10cc>
 1082842:	4c 39 c0             	cmp    %r8,%rax
 1082845:	0f 87 91 eb ff ff    	ja     10813dc <check_input_run+0x10cc>
 108284b:	4c 8b 44 24 28       	mov    0x28(%rsp),%r8
 1082850:	48 01 c6             	add    %rax,%rsi
 1082853:	49 89 70 08          	mov    %rsi,0x8(%r8)
 1082857:	48 89 bc 24 d0 05 00 	mov    %rdi,0x5d0(%rsp)
 108285e:	00 
 108285f:	48 85 ff             	test   %rdi,%rdi
 1082862:	0f 84 80 eb ff ff    	je     10813e8 <check_input_run+0x10d8>
 1082868:	48 8d 74 07 3c       	lea    0x3c(%rdi,%rax,1),%rsi
 108286d:	48 01 c7             	add    %rax,%rdi
 1082870:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 1082874:	48 39 fe             	cmp    %rdi,%rsi
 1082877:	0f 82 6b eb ff ff    	jb     10813e8 <check_input_run+0x10d8>
 108287d:	48 89 f7             	mov    %rsi,%rdi
 1082880:	48 29 cf             	sub    %rcx,%rdi
 1082883:	49 89 d0             	mov    %rdx,%r8
 1082886:	49 29 f8             	sub    %rdi,%r8
 1082889:	0f 82 59 eb ff ff    	jb     10813e8 <check_input_run+0x10d8>
 108288f:	4c 39 c0             	cmp    %r8,%rax
 1082892:	0f 87 50 eb ff ff    	ja     10813e8 <check_input_run+0x10d8>
 1082898:	4c 8b 44 24 28       	mov    0x28(%rsp),%r8
 108289d:	48 01 c7             	add    %rax,%rdi
 10828a0:	49 89 78 08          	mov    %rdi,0x8(%r8)
 10828a4:	48 89 b4 24 d8 05 00 	mov    %rsi,0x5d8(%rsp)
 10828ab:	00 
 10828ac:	48 85 f6             	test   %rsi,%rsi
 10828af:	0f 84 3f eb ff ff    	je     10813f4 <check_input_run+0x10e4>
 10828b5:	48 8d 7c 06 3c       	lea    0x3c(%rsi,%rax,1),%rdi
 10828ba:	48 01 c6             	add    %rax,%rsi
 10828bd:	48 83 e7 c0          	and    $0xffffffffffffffc0,%rdi
 10828c1:	48 39 f7             	cmp    %rsi,%rdi
 10828c4:	0f 82 2a eb ff ff    	jb     10813f4 <check_input_run+0x10e4>
 10828ca:	48 89 fe             	mov    %rdi,%rsi
 10828cd:	48 29 ce             	sub    %rcx,%rsi
 10828d0:	49 89 d0             	mov    %rdx,%r8
 10828d3:	49 29 f0             	sub    %rsi,%r8
 10828d6:	0f 82 18 eb ff ff    	jb     10813f4 <check_input_run+0x10e4>
 10828dc:	4c 39 c0             	cmp    %r8,%rax
 10828df:	0f 87 0f eb ff ff    	ja     10813f4 <check_input_run+0x10e4>
 10828e5:	4c 8b 44 24 28       	mov    0x28(%rsp),%r8
 10828ea:	48 01 c6             	add    %rax,%rsi
 10828ed:	49 89 70 08          	mov    %rsi,0x8(%r8)
 10828f1:	48 89 bc 24 e0 05 00 	mov    %rdi,0x5e0(%rsp)
 10828f8:	00 
 10828f9:	48 85 ff             	test   %rdi,%rdi
 10828fc:	0f 84 fe ea ff ff    	je     1081400 <check_input_run+0x10f0>
 1082902:	48 8d 74 07 3c       	lea    0x3c(%rdi,%rax,1),%rsi
 1082907:	48 01 c7             	add    %rax,%rdi
 108290a:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 108290e:	48 39 fe             	cmp    %rdi,%rsi
 1082911:	0f 82 e9 ea ff ff    	jb     1081400 <check_input_run+0x10f0>
 1082917:	48 89 f7             	mov    %rsi,%rdi
 108291a:	48 29 cf             	sub    %rcx,%rdi
 108291d:	49 89 d0             	mov    %rdx,%r8
 1082920:	49 29 f8             	sub    %rdi,%r8
 1082923:	0f 82 d7 ea ff ff    	jb     1081400 <check_input_run+0x10f0>
 1082929:	4c 39 c0             	cmp    %r8,%rax
 108292c:	0f 87 ce ea ff ff    	ja     1081400 <check_input_run+0x10f0>
 1082932:	4c 8b 44 24 28       	mov    0x28(%rsp),%r8
 1082937:	48 01 c7             	add    %rax,%rdi
 108293a:	49 89 78 08          	mov    %rdi,0x8(%r8)
 108293e:	48 89 b4 24 e8 05 00 	mov    %rsi,0x5e8(%rsp)
 1082945:	00 
 1082946:	48 85 f6             	test   %rsi,%rsi
 1082949:	0f 84 bd ea ff ff    	je     108140c <check_input_run+0x10fc>
 108294f:	48 8d 7c 06 3c       	lea    0x3c(%rsi,%rax,1),%rdi
 1082954:	48 01 c6             	add    %rax,%rsi
 1082957:	48 83 e7 c0          	and    $0xffffffffffffffc0,%rdi
 108295b:	48 39 f7             	cmp    %rsi,%rdi
 108295e:	0f 82 a8 ea ff ff    	jb     108140c <check_input_run+0x10fc>
 1082964:	48 89 fe             	mov    %rdi,%rsi
 1082967:	48 29 ce             	sub    %rcx,%rsi
 108296a:	49 89 d0             	mov    %rdx,%r8
 108296d:	49 29 f0             	sub    %rsi,%r8
 1082970:	0f 82 96 ea ff ff    	jb     108140c <check_input_run+0x10fc>
 1082976:	4c 39 c0             	cmp    %r8,%rax
 1082979:	0f 87 8d ea ff ff    	ja     108140c <check_input_run+0x10fc>
 108297f:	4c 8b 44 24 28       	mov    0x28(%rsp),%r8
 1082984:	48 01 c6             	add    %rax,%rsi
 1082987:	49 89 70 08          	mov    %rsi,0x8(%r8)
 108298b:	48 89 bc 24 f8 05 00 	mov    %rdi,0x5f8(%rsp)
 1082992:	00 
 1082993:	48 85 ff             	test   %rdi,%rdi
 1082996:	0f 84 7c ea ff ff    	je     1081418 <check_input_run+0x1108>
 108299c:	48 8d 74 07 3c       	lea    0x3c(%rdi,%rax,1),%rsi
 10829a1:	48 01 c7             	add    %rax,%rdi
 10829a4:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 10829a8:	48 39 fe             	cmp    %rdi,%rsi
 10829ab:	0f 82 67 ea ff ff    	jb     1081418 <check_input_run+0x1108>
 10829b1:	48 89 f7             	mov    %rsi,%rdi
 10829b4:	48 29 cf             	sub    %rcx,%rdi
 10829b7:	49 89 d0             	mov    %rdx,%r8
 10829ba:	49 29 f8             	sub    %rdi,%r8
 10829bd:	0f 82 55 ea ff ff    	jb     1081418 <check_input_run+0x1108>
 10829c3:	4c 39 c0             	cmp    %r8,%rax
 10829c6:	0f 87 4c ea ff ff    	ja     1081418 <check_input_run+0x1108>
 10829cc:	4c 8b 44 24 28       	mov    0x28(%rsp),%r8
 10829d1:	48 01 c7             	add    %rax,%rdi
 10829d4:	49 89 78 08          	mov    %rdi,0x8(%r8)
 10829d8:	48 89 b4 24 00 06 00 	mov    %rsi,0x600(%rsp)
 10829df:	00 
 10829e0:	48 85 f6             	test   %rsi,%rsi
 10829e3:	0f 84 3b ea ff ff    	je     1081424 <check_input_run+0x1114>
 10829e9:	48 8d 7c 06 3c       	lea    0x3c(%rsi,%rax,1),%rdi
 10829ee:	48 01 c6             	add    %rax,%rsi
 10829f1:	48 83 e7 c0          	and    $0xffffffffffffffc0,%rdi
 10829f5:	48 39 f7             	cmp    %rsi,%rdi
 10829f8:	0f 82 26 ea ff ff    	jb     1081424 <check_input_run+0x1114>
 10829fe:	48 89 fe             	mov    %rdi,%rsi
 1082a01:	48 29 ce             	sub    %rcx,%rsi
 1082a04:	49 89 d0             	mov    %rdx,%r8
 1082a07:	49 29 f0             	sub    %rsi,%r8
 1082a0a:	0f 82 14 ea ff ff    	jb     1081424 <check_input_run+0x1114>
 1082a10:	4c 39 c0             	cmp    %r8,%rax
 1082a13:	0f 87 0b ea ff ff    	ja     1081424 <check_input_run+0x1114>
 1082a19:	4c 8b 44 24 28       	mov    0x28(%rsp),%r8
 1082a1e:	48 01 c6             	add    %rax,%rsi
 1082a21:	49 89 70 08          	mov    %rsi,0x8(%r8)
 1082a25:	48 89 bc 24 08 06 00 	mov    %rdi,0x608(%rsp)
 1082a2c:	00 
 1082a2d:	48 85 ff             	test   %rdi,%rdi
 1082a30:	0f 84 ba 8f 00 00    	je     108b9f0 <check_input_run+0xb6e0>
 1082a36:	4c 8d 04 07          	lea    (%rdi,%rax,1),%r8
 1082a3a:	48 8d 44 07 3c       	lea    0x3c(%rdi,%rax,1),%rax
 1082a3f:	40 b6 01             	mov    $0x1,%sil
 1082a42:	48 83 e0 c0          	and    $0xffffffffffffffc0,%rax
 1082a46:	4c 39 c0             	cmp    %r8,%rax
 1082a49:	0f 83 a7 8f 00 00    	jae    108b9f6 <check_input_run+0xb6e6>
 1082a4f:	31 c9                	xor    %ecx,%ecx
 1082a51:	e9 d1 8f 00 00       	jmp    108ba27 <check_input_run+0xb717>
 1082a56:	48 01 ca             	add    %rcx,%rdx
 1082a59:	49 89 50 08          	mov    %rdx,0x8(%r8)
 1082a5d:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
 1082a62:	48 89 82 38 03 00 00 	mov    %rax,0x338(%rdx)
 1082a69:	48 85 c0             	test   %rax,%rax
 1082a6c:	74 21                	je     1082a8f <check_input_run+0x277f>
 1082a6e:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
 1082a73:	48 8b 01             	mov    (%rcx),%rax
 1082a76:	48 8b 49 08          	mov    0x8(%rcx),%rcx
 1082a7a:	48 8d 54 01 0f       	lea    0xf(%rcx,%rax,1),%rdx
 1082a7f:	48 01 c1             	add    %rax,%rcx
 1082a82:	48 83 e2 f0          	and    $0xfffffffffffffff0,%rdx
 1082a86:	48 39 ca             	cmp    %rcx,%rdx
 1082a89:	0f 83 43 18 00 00    	jae    10842d2 <check_input_run+0x3fc2>
 1082a8f:	48 c7 84 24 18 04 00 	movq   $0x0,0x418(%rsp)
 1082a96:	00 00 00 00 00 
 1082a9b:	48 c7 84 24 50 05 00 	movq   $0x0,0x550(%rsp)
 1082aa2:	00 00 00 00 00 
 1082aa7:	48 c7 84 24 f0 00 00 	movq   $0x0,0xf0(%rsp)
 1082aae:	00 00 00 00 00 
 1082ab3:	31 ff                	xor    %edi,%edi
 1082ab5:	48 89 bc 24 30 04 00 	mov    %rdi,0x430(%rsp)
 1082abc:	00 
 1082abd:	48 89 bc 24 88 00 00 	mov    %rdi,0x88(%rsp)
 1082ac4:	00 
 1082ac5:	49 8b 87 70 02 00 00 	mov    0x270(%r15),%rax
 1082acc:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
 1082ad1:	31 c0                	xor    %eax,%eax
 1082ad3:	eb 2d                	jmp    1082b02 <check_input_run+0x27f2>
 1082ad5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 1082adc:	00 00 00 00 
 1082ae0:	48 8b 84 24 b0 00 00 	mov    0xb0(%rsp),%rax
 1082ae7:	00 
 1082ae8:	44 89 a4 84 40 02 00 	mov    %r12d,0x240(%rsp,%rax,4)
 1082aef:	00 
 1082af0:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
 1082af5:	48 ff c0             	inc    %rax
 1082af8:	48 83 f8 05          	cmp    $0x5,%rax
 1082afc:	0f 84 74 02 00 00    	je     1082d76 <check_input_run+0x2a66>
 1082b02:	48 8d 0d 77 80 bf 00 	lea    0xbf8077(%rip),%rcx        # 1c7ab80 <parse_predeclared_typedefs+0x30>
 1082b09:	48 89 84 24 b0 00 00 	mov    %rax,0xb0(%rsp)
 1082b10:	00 
 1082b11:	48 8b 1c c1          	mov    (%rcx,%rax,8),%rbx
 1082b15:	48 89 df             	mov    %rbx,%rdi
 1082b18:	c5 f8 77             	vzeroupper
 1082b1b:	e8 30 bf 70 ff       	call   78ea50 <strlen@plt>
 1082b20:	c4 e1 fc 46 c8       	kxnorq %k0,%k0,%k1
 1082b25:	48 89 c2             	mov    %rax,%rdx
 1082b28:	41 89 d7             	mov    %edx,%r15d
 1082b2b:	83 fa 3f             	cmp    $0x3f,%edx
 1082b2e:	77 11                	ja     1082b41 <check_input_run+0x2831>
 1082b30:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
 1082b37:	c4 e2 80 f5 c0       	bzhi   %r15,%rax,%rax
 1082b3c:	c4 e1 fb 92 c8       	kmovq  %rax,%k1
 1082b41:	62 f1 7f c9 6f 03    	vmovdqu8 (%rbx),%zmm0{%k1}{z}
 1082b47:	c4 c1 79 6e cf       	vmovd  %r15d,%xmm1
 1082b4c:	c5 e9 ef d2          	vpxor  %xmm2,%xmm2,%xmm2
 1082b50:	48 89 54 24 40       	mov    %rdx,0x40(%rsp)
 1082b55:	62 f3 fd 48 25 0d e0 	vpternlogq $0x96,-0xbe4a20(%rip),%zmm0,%zmm1        # 49e140 <cbuiltin_test_generated.edges+0x39c0>
 1082b5c:	b5 41 ff 96 
 1082b60:	62 f2 75 48 dc c2    	vaesenc %zmm2,%zmm1,%zmm0
 1082b66:	62 f2 7d 48 dc c2    	vaesenc %zmm2,%zmm0,%zmm0
 1082b6c:	62 f3 fd 48 3b c1 01 	vextracti64x4 $0x1,%zmm0,%ymm1
 1082b73:	62 f1 f5 48 ef c0    	vpxorq %zmm0,%zmm1,%zmm0
 1082b79:	c4 e3 7d 39 c1 01    	vextracti128 $0x1,%ymm0,%xmm1
 1082b7f:	c5 f1 ef c0          	vpxor  %xmm0,%xmm1,%xmm0
 1082b83:	83 fa 41             	cmp    $0x41,%edx
 1082b86:	72 13                	jb     1082b9b <check_input_run+0x288b>
 1082b88:	48 89 df             	mov    %rbx,%rdi
 1082b8b:	4c 89 fe             	mov    %r15,%rsi
 1082b8e:	c5 f8 77             	vzeroupper
 1082b91:	e8 2a 9d fa ff       	call   102c8c0 <intern_chain_chunks>
 1082b96:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
 1082b9b:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
 1082b9f:	c4 e2 79 dc c1       	vaesenc %xmm1,%xmm0,%xmm0
 1082ba4:	83 fa 10             	cmp    $0x10,%edx
 1082ba7:	b8 10 00 00 00       	mov    $0x10,%eax
 1082bac:	b9 ff ff 00 00       	mov    $0xffff,%ecx
 1082bb1:	0f 42 c2             	cmovb  %edx,%eax
 1082bb4:	c4 e2 78 f5 c1       	bzhi   %eax,%ecx,%eax
 1082bb9:	c5 fb 92 c8          	kmovd  %eax,%k1
 1082bbd:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
 1082bc2:	c4 c1 f9 7e c6       	vmovq  %xmm0,%r14
 1082bc7:	62 f1 7f 89 6f 03    	vmovdqu8 (%rbx),%xmm0{%k1}{z}
 1082bcd:	48 8b 78 08          	mov    0x8(%rax),%rdi
 1082bd1:	48 8b 30             	mov    (%rax),%rsi
 1082bd4:	62 f3 fd 48 43 c0 00 	vshufi64x2 $0x0,%zmm0,%zmm0,%zmm0
 1082bdb:	49 21 fe             	and    %rdi,%r14
 1082bde:	62 f1 fe 48 7f 84 24 	vmovdqu64 %zmm0,0x170(%rsp)
 1082be5:	70 01 00 00 
 1082be9:	83 fa 0c             	cmp    $0xc,%edx
 1082bec:	73 72                	jae    1082c60 <check_input_run+0x2950>
 1082bee:	45 31 e4             	xor    %r12d,%r12d
 1082bf1:	eb 2c                	jmp    1082c1f <check_input_run+0x290f>
 1082bf3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1082bfa:	84 00 00 00 00 00 
 1082c00:	62 f2 7e 48 27 c0    	vptestnmd %zmm0,%zmm0,%k0
 1082c06:	49 ff c6             	inc    %r14
 1082c09:	c5 fb 93 c8          	kmovd  %k0,%ecx
 1082c0d:	49 21 fe             	and    %rdi,%r14
 1082c10:	81 e1 88 88 00 00    	and    $0x8888,%ecx
 1082c16:	66 09 c8             	or     %cx,%ax
 1082c19:	0f 85 c1 fe ff ff    	jne    1082ae0 <check_input_run+0x27d0>
 1082c1f:	4c 89 f1             	mov    %r14,%rcx
 1082c22:	48 c1 e1 06          	shl    $0x6,%rcx
 1082c26:	62 f1 fd 48 6f 04 0e 	vmovdqa64 (%rsi,%rcx,1),%zmm0
 1082c2d:	62 f1 7d 48 76 84 24 	vpcmpeqd 0x170(%rsp),%zmm0,%k0
 1082c34:	70 01 00 00 
 1082c38:	c5 fb 93 c0          	kmovd  %k0,%eax
 1082c3c:	25 77 77 00 00       	and    $0x7777,%eax
 1082c41:	05 11 11 00 00       	add    $0x1111,%eax
 1082c46:	66 25 88 88          	and    $0x8888,%ax
 1082c4a:	74 b4                	je     1082c00 <check_input_run+0x28f0>
 1082c4c:	48 01 f1             	add    %rsi,%rcx
 1082c4f:	31 d2                	xor    %edx,%edx
 1082c51:	f3 0f bc d0          	tzcnt  %eax,%edx
 1082c55:	44 8b 24 91          	mov    (%rcx,%rdx,4),%r12d
 1082c59:	eb a5                	jmp    1082c00 <check_input_run+0x28f0>
 1082c5b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
 1082c60:	45 31 e4             	xor    %r12d,%r12d
 1082c63:	4c 89 7c 24 60       	mov    %r15,0x60(%rsp)
 1082c68:	48 89 5c 24 68       	mov    %rbx,0x68(%rsp)
 1082c6d:	48 89 b4 24 98 00 00 	mov    %rsi,0x98(%rsp)
 1082c74:	00 
 1082c75:	48 89 bc 24 a0 00 00 	mov    %rdi,0xa0(%rsp)
 1082c7c:	00 
 1082c7d:	0f 1f 00             	nopl   (%rax)
 1082c80:	4c 89 f5             	mov    %r14,%rbp
 1082c83:	48 c1 e5 06          	shl    $0x6,%rbp
 1082c87:	62 f1 fd 48 6f 04 2e 	vmovdqa64 (%rsi,%rbp,1),%zmm0
 1082c8e:	62 f1 7d 48 76 84 24 	vpcmpeqd 0x170(%rsp),%zmm0,%k0
 1082c95:	70 01 00 00 
 1082c99:	62 f1 fe 48 7f 84 24 	vmovdqu64 %zmm0,0x130(%rsp)
 1082ca0:	30 01 00 00 
 1082ca4:	c5 fb 93 c0          	kmovd  %k0,%eax
 1082ca8:	25 77 77 00 00       	and    $0x7777,%eax
 1082cad:	05 11 11 00 00       	add    $0x1111,%eax
 1082cb2:	66 25 88 88          	and    $0x8888,%ax
 1082cb6:	74 78                	je     1082d30 <check_input_run+0x2a20>
 1082cb8:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
 1082cbd:	48 01 f5             	add    %rsi,%rbp
 1082cc0:	0f b7 d8             	movzwl %ax,%ebx
 1082cc3:	4c 8b 69 10          	mov    0x10(%rcx),%r13
 1082cc7:	eb 14                	jmp    1082cdd <check_input_run+0x29cd>
 1082cc9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
 1082cd0:	31 c0                	xor    %eax,%eax
 1082cd2:	84 c0                	test   %al,%al
 1082cd4:	75 5c                	jne    1082d32 <check_input_run+0x2a22>
 1082cd6:	c4 e2 60 f3 cb       	blsr   %ebx,%ebx
 1082cdb:	74 55                	je     1082d32 <check_input_run+0x2a22>
 1082cdd:	31 c0                	xor    %eax,%eax
 1082cdf:	f3 0f bc c3          	tzcnt  %ebx,%eax
 1082ce3:	44 8b 7c 85 00       	mov    0x0(%rbp,%rax,4),%r15d
 1082ce8:	43 39 54 fd 04       	cmp    %edx,0x4(%r13,%r15,8)
 1082ced:	75 e1                	jne    1082cd0 <check_input_run+0x29c0>
 1082cef:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
 1082cf4:	43 8b 7c fd 00       	mov    0x0(%r13,%r15,8),%edi
 1082cf9:	48 8b 74 24 68       	mov    0x68(%rsp),%rsi
 1082cfe:	48 8b 54 24 60       	mov    0x60(%rsp),%rdx
 1082d03:	48 03 78 40          	add    0x40(%rax),%rdi
 1082d07:	c5 f8 77             	vzeroupper
 1082d0a:	e8 01 c2 70 ff       	call   78ef10 <bcmp@plt>
 1082d0f:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
 1082d14:	85 c0                	test   %eax,%eax
 1082d16:	0f 94 c0             	sete   %al
 1082d19:	45 0f 44 e7          	cmove  %r15d,%r12d
 1082d1d:	84 c0                	test   %al,%al
 1082d1f:	74 b5                	je     1082cd6 <check_input_run+0x29c6>
 1082d21:	eb 0f                	jmp    1082d32 <check_input_run+0x2a22>
 1082d23:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1082d2a:	84 00 00 00 00 00 
 1082d30:	31 c0                	xor    %eax,%eax
 1082d32:	62 f1 fe 48 6f 84 24 	vmovdqu64 0x130(%rsp),%zmm0
 1082d39:	30 01 00 00 
 1082d3d:	62 f2 7e 48 27 c0    	vptestnmd %zmm0,%zmm0,%k0
 1082d43:	c5 fb 93 c8          	kmovd  %k0,%ecx
 1082d47:	f7 c1 88 88 00 00    	test   $0x8888,%ecx
 1082d4d:	0f 85 8d fd ff ff    	jne    1082ae0 <check_input_run+0x27d0>
 1082d53:	48 8b bc 24 a0 00 00 	mov    0xa0(%rsp),%rdi
 1082d5a:	00 
 1082d5b:	48 8b b4 24 98 00 00 	mov    0x98(%rsp),%rsi
 1082d62:	00 
 1082d63:	49 ff c6             	inc    %r14
 1082d66:	49 21 fe             	and    %rdi,%r14
 1082d69:	84 c0                	test   %al,%al
 1082d6b:	0f 84 0f ff ff ff    	je     1082c80 <check_input_run+0x2970>
 1082d71:	e9 6a fd ff ff       	jmp    1082ae0 <check_input_run+0x27d0>
 1082d76:	48 83 bc 24 88 00 00 	cmpq   $0x0,0x88(%rsp)
 1082d7d:	00 00 
 1082d7f:	48 8b 8c 24 f0 00 00 	mov    0xf0(%rsp),%rcx
 1082d86:	00 
 1082d87:	0f 95 c0             	setne  %al
 1082d8a:	20 c1                	and    %al,%cl
 1082d8c:	83 7c 24 18 00       	cmpl   $0x0,0x18(%rsp)
 1082d91:	48 89 8c 24 f0 00 00 	mov    %rcx,0xf0(%rsp)
 1082d98:	00 
 1082d99:	74 38                	je     1082dd3 <check_input_run+0x2ac3>
 1082d9b:	c5 f9 6f 84 24 40 02 	vmovdqa 0x240(%rsp),%xmm0
 1082da2:	00 00 
 1082da4:	4c 8b 44 24 58       	mov    0x58(%rsp),%r8
 1082da9:	49 8b 74 24 18       	mov    0x18(%r12),%rsi
 1082dae:	8b 84 24 a4 04 00 00 	mov    0x4a4(%rsp),%eax
 1082db5:	8b 8c 24 50 02 00 00 	mov    0x250(%rsp),%ecx
 1082dbc:	44 89 c2             	mov    %r8d,%edx
 1082dbf:	49 8d 78 ff          	lea    -0x1(%r8),%rdi
 1082dc3:	83 e2 03             	and    $0x3,%edx
 1082dc6:	48 83 ff 03          	cmp    $0x3,%rdi
 1082dca:	73 13                	jae    1082ddf <check_input_run+0x2acf>
 1082dcc:	31 ff                	xor    %edi,%edi
 1082dce:	e9 1f 01 00 00       	jmp    1082ef2 <check_input_run+0x2be2>
 1082dd3:	8b 84 24 a4 04 00 00 	mov    0x4a4(%rsp),%eax
 1082dda:	e9 64 01 00 00       	jmp    1082f43 <check_input_run+0x2c33>
 1082ddf:	41 83 e0 fc          	and    $0xfffffffc,%r8d
 1082de3:	31 ff                	xor    %edi,%edi
 1082de5:	eb 16                	jmp    1082dfd <check_input_run+0x2aed>
 1082de7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
 1082dee:	00 00 
 1082df0:	48 83 c7 04          	add    $0x4,%rdi
 1082df4:	49 39 f8             	cmp    %rdi,%r8
 1082df7:	0f 84 f0 00 00 00    	je     1082eed <check_input_run+0x2bdd>
 1082dfd:	44 8b 0c be          	mov    (%rsi,%rdi,4),%r9d
 1082e01:	45 85 c9             	test   %r9d,%r9d
 1082e04:	74 30                	je     1082e36 <check_input_run+0x2b26>
 1082e06:	62 d2 7d 08 7c c9    	vpbroadcastd %r9d,%xmm1
 1082e0c:	45 31 d2             	xor    %r10d,%r10d
 1082e0f:	41 39 c9             	cmp    %ecx,%r9d
 1082e12:	62 f1 75 08 76 c0    	vpcmpeqd %xmm0,%xmm1,%k0
 1082e18:	41 0f 94 c2          	sete   %r10b
 1082e1c:	c5 79 93 c8          	kmovb  %k0,%r9d
 1082e20:	41 01 c2             	add    %eax,%r10d
 1082e23:	f3 45 0f b8 c9       	popcnt %r9d,%r9d
 1082e28:	45 01 ca             	add    %r9d,%r10d
 1082e2b:	44 89 d0             	mov    %r10d,%eax
 1082e2e:	44 89 94 24 a4 04 00 	mov    %r10d,0x4a4(%rsp)
 1082e35:	00 
 1082e36:	44 8b 4c be 04       	mov    0x4(%rsi,%rdi,4),%r9d
 1082e3b:	45 85 c9             	test   %r9d,%r9d
 1082e3e:	74 30                	je     1082e70 <check_input_run+0x2b60>
 1082e40:	62 d2 7d 08 7c c9    	vpbroadcastd %r9d,%xmm1
 1082e46:	45 31 d2             	xor    %r10d,%r10d
 1082e49:	41 39 c9             	cmp    %ecx,%r9d
 1082e4c:	62 f1 75 08 76 c0    	vpcmpeqd %xmm0,%xmm1,%k0
 1082e52:	41 0f 94 c2          	sete   %r10b
 1082e56:	c5 79 93 c8          	kmovb  %k0,%r9d
 1082e5a:	41 01 c2             	add    %eax,%r10d
 1082e5d:	f3 45 0f b8 c9       	popcnt %r9d,%r9d
 1082e62:	45 01 ca             	add    %r9d,%r10d
 1082e65:	44 89 d0             	mov    %r10d,%eax
 1082e68:	44 89 94 24 a4 04 00 	mov    %r10d,0x4a4(%rsp)
 1082e6f:	00 
 1082e70:	44 8b 4c be 08       	mov    0x8(%rsi,%rdi,4),%r9d
 1082e75:	45 85 c9             	test   %r9d,%r9d
 1082e78:	74 30                	je     1082eaa <check_input_run+0x2b9a>
 1082e7a:	62 d2 7d 08 7c c9    	vpbroadcastd %r9d,%xmm1
 1082e80:	45 31 d2             	xor    %r10d,%r10d
 1082e83:	41 39 c9             	cmp    %ecx,%r9d
 1082e86:	62 f1 75 08 76 c0    	vpcmpeqd %xmm0,%xmm1,%k0
 1082e8c:	41 0f 94 c2          	sete   %r10b
 1082e90:	c5 79 93 c8          	kmovb  %k0,%r9d
 1082e94:	41 01 c2             	add    %eax,%r10d
 1082e97:	f3 45 0f b8 c9       	popcnt %r9d,%r9d
 1082e9c:	45 01 ca             	add    %r9d,%r10d
 1082e9f:	44 89 d0             	mov    %r10d,%eax
 1082ea2:	44 89 94 24 a4 04 00 	mov    %r10d,0x4a4(%rsp)
 1082ea9:	00 
 1082eaa:	44 8b 4c be 0c       	mov    0xc(%rsi,%rdi,4),%r9d
 1082eaf:	45 85 c9             	test   %r9d,%r9d
 1082eb2:	0f 84 38 ff ff ff    	je     1082df0 <check_input_run+0x2ae0>
 1082eb8:	62 d2 7d 08 7c c9    	vpbroadcastd %r9d,%xmm1
 1082ebe:	45 31 d2             	xor    %r10d,%r10d
 1082ec1:	41 39 c9             	cmp    %ecx,%r9d
 1082ec4:	62 f1 75 08 76 c0    	vpcmpeqd %xmm0,%xmm1,%k0
 1082eca:	41 0f 94 c2          	sete   %r10b
 1082ece:	c5 79 93 c8          	kmovb  %k0,%r9d
 1082ed2:	41 01 c2             	add    %eax,%r10d
 1082ed5:	f3 45 0f b8 c9       	popcnt %r9d,%r9d
 1082eda:	45 01 ca             	add    %r9d,%r10d
 1082edd:	44 89 d0             	mov    %r10d,%eax
 1082ee0:	44 89 94 24 a4 04 00 	mov    %r10d,0x4a4(%rsp)
 1082ee7:	00 
 1082ee8:	e9 03 ff ff ff       	jmp    1082df0 <check_input_run+0x2ae0>
 1082eed:	48 85 d2             	test   %rdx,%rdx
 1082ef0:	74 51                	je     1082f43 <check_input_run+0x2c33>
 1082ef2:	48 8d 34 be          	lea    (%rsi,%rdi,4),%rsi
 1082ef6:	31 ff                	xor    %edi,%edi
 1082ef8:	eb 0e                	jmp    1082f08 <check_input_run+0x2bf8>
 1082efa:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
 1082f00:	48 ff c7             	inc    %rdi
 1082f03:	48 39 fa             	cmp    %rdi,%rdx
 1082f06:	74 3b                	je     1082f43 <check_input_run+0x2c33>
 1082f08:	44 8b 04 be          	mov    (%rsi,%rdi,4),%r8d
 1082f0c:	45 85 c0             	test   %r8d,%r8d
 1082f0f:	74 ef                	je     1082f00 <check_input_run+0x2bf0>
 1082f11:	62 d2 7d 08 7c c8    	vpbroadcastd %r8d,%xmm1
 1082f17:	45 31 c9             	xor    %r9d,%r9d
 1082f1a:	41 39 c8             	cmp    %ecx,%r8d
 1082f1d:	62 f1 75 08 76 c0    	vpcmpeqd %xmm0,%xmm1,%k0
 1082f23:	41 0f 94 c1          	sete   %r9b
 1082f27:	c5 79 93 c0          	kmovb  %k0,%r8d
 1082f2b:	41 01 c1             	add    %eax,%r9d
 1082f2e:	f3 45 0f b8 c0       	popcnt %r8d,%r8d
 1082f33:	45 01 c1             	add    %r8d,%r9d
 1082f36:	44 89 c8             	mov    %r9d,%eax
 1082f39:	44 89 8c 24 a4 04 00 	mov    %r9d,0x4a4(%rsp)
 1082f40:	00 
 1082f41:	eb bd                	jmp    1082f00 <check_input_run+0x2bf0>
 1082f43:	48 8b 94 24 f0 00 00 	mov    0xf0(%rsp),%rdx
 1082f4a:	00 
 1082f4b:	85 c0                	test   %eax,%eax
 1082f4d:	0f 95 c1             	setne  %cl
 1082f50:	84 ca                	test   %cl,%dl
 1082f52:	74 2a                	je     1082f7e <check_input_run+0x2c6e>
 1082f54:	4c 8b 44 24 28       	mov    0x28(%rsp),%r8
 1082f59:	89 c1                	mov    %eax,%ecx
 1082f5b:	49 8b 10             	mov    (%r8),%rdx
 1082f5e:	49 8b 78 08          	mov    0x8(%r8),%rdi
 1082f62:	48 8d 74 17 03       	lea    0x3(%rdi,%rdx,1),%rsi
 1082f67:	48 01 d7             	add    %rdx,%rdi
 1082f6a:	48 83 e6 fc          	and    $0xfffffffffffffffc,%rsi
 1082f6e:	48 39 fe             	cmp    %rdi,%rsi
 1082f71:	0f 83 4e 02 00 00    	jae    10831c5 <check_input_run+0x2eb5>
 1082f77:	31 d2                	xor    %edx,%edx
 1082f79:	e9 70 02 00 00       	jmp    10831ee <check_input_run+0x2ede>
 1082f7e:	48 89 d1             	mov    %rdx,%rcx
 1082f81:	84 c9                	test   %cl,%cl
 1082f83:	0f 84 a3 02 00 00    	je     108322c <check_input_run+0x2f1c>
 1082f89:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
 1082f8e:	48 8b 01             	mov    (%rcx),%rax
 1082f91:	48 8b 49 08          	mov    0x8(%rcx),%rcx
 1082f95:	48 8d 54 01 3f       	lea    0x3f(%rcx,%rax,1),%rdx
 1082f9a:	48 01 c1             	add    %rax,%rcx
 1082f9d:	48 83 e2 c0          	and    $0xffffffffffffffc0,%rdx
 1082fa1:	48 39 ca             	cmp    %rcx,%rdx
 1082fa4:	0f 82 82 02 00 00    	jb     108322c <check_input_run+0x2f1c>
 1082faa:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
 1082faf:	48 89 d6             	mov    %rdx,%rsi
 1082fb2:	48 29 c6             	sub    %rax,%rsi
 1082fb5:	48 8b 49 10          	mov    0x10(%rcx),%rcx
 1082fb9:	49 89 c8             	mov    %rcx,%r8
 1082fbc:	49 29 f0             	sub    %rsi,%r8
 1082fbf:	0f 82 67 02 00 00    	jb     108322c <check_input_run+0x2f1c>
 1082fc5:	48 8b 7c 24 38       	mov    0x38(%rsp),%rdi
 1082fca:	8b 7f 68             	mov    0x68(%rdi),%edi
 1082fcd:	48 c1 e7 02          	shl    $0x2,%rdi
 1082fd1:	4c 39 c7             	cmp    %r8,%rdi
 1082fd4:	0f 87 52 02 00 00    	ja     108322c <check_input_run+0x2f1c>
 1082fda:	4c 8b 44 24 28       	mov    0x28(%rsp),%r8
 1082fdf:	48 01 fe             	add    %rdi,%rsi
 1082fe2:	49 89 70 08          	mov    %rsi,0x8(%r8)
 1082fe6:	48 89 94 24 78 05 00 	mov    %rdx,0x578(%rsp)
 1082fed:	00 
 1082fee:	48 85 d2             	test   %rdx,%rdx
 1082ff1:	0f 84 41 02 00 00    	je     1083238 <check_input_run+0x2f28>
 1082ff7:	48 8d 34 3a          	lea    (%rdx,%rdi,1),%rsi
 1082ffb:	48 8d 54 3a 3c       	lea    0x3c(%rdx,%rdi,1),%rdx
 1083000:	48 83 e2 c0          	and    $0xffffffffffffffc0,%rdx
 1083004:	48 39 f2             	cmp    %rsi,%rdx
 1083007:	0f 82 2b 02 00 00    	jb     1083238 <check_input_run+0x2f28>
 108300d:	48 89 d6             	mov    %rdx,%rsi
 1083010:	48 29 c6             	sub    %rax,%rsi
 1083013:	49 89 c8             	mov    %rcx,%r8
 1083016:	49 29 f0             	sub    %rsi,%r8
 1083019:	0f 82 19 02 00 00    	jb     1083238 <check_input_run+0x2f28>
 108301f:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
 1083024:	48 8b bf 70 02 00 00 	mov    0x270(%rdi),%rdi
 108302b:	8b 7f 68             	mov    0x68(%rdi),%edi
 108302e:	48 c1 e7 02          	shl    $0x2,%rdi
 1083032:	4c 39 c7             	cmp    %r8,%rdi
 1083035:	0f 87 fd 01 00 00    	ja     1083238 <check_input_run+0x2f28>
 108303b:	4c 8b 44 24 28       	mov    0x28(%rsp),%r8
 1083040:	48 01 fe             	add    %rdi,%rsi
 1083043:	49 89 70 08          	mov    %rsi,0x8(%r8)
 1083047:	48 89 94 24 80 05 00 	mov    %rdx,0x580(%rsp)
 108304e:	00 
 108304f:	48 85 d2             	test   %rdx,%rdx
 1083052:	0f 84 ec 01 00 00    	je     1083244 <check_input_run+0x2f34>
 1083058:	48 8d 34 3a          	lea    (%rdx,%rdi,1),%rsi
 108305c:	48 8d 54 3a 3c       	lea    0x3c(%rdx,%rdi,1),%rdx
 1083061:	48 83 e2 c0          	and    $0xffffffffffffffc0,%rdx
 1083065:	48 39 f2             	cmp    %rsi,%rdx
 1083068:	0f 82 d6 01 00 00    	jb     1083244 <check_input_run+0x2f34>
 108306e:	48 89 d7             	mov    %rdx,%rdi
 1083071:	48 29 c7             	sub    %rax,%rdi
 1083074:	49 89 c8             	mov    %rcx,%r8
 1083077:	49 29 f8             	sub    %rdi,%r8
 108307a:	0f 82 c4 01 00 00    	jb     1083244 <check_input_run+0x2f34>
 1083080:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
 1083085:	48 8b b6 70 02 00 00 	mov    0x270(%rsi),%rsi
 108308c:	8b 76 68             	mov    0x68(%rsi),%esi
 108308f:	48 c1 e6 02          	shl    $0x2,%rsi
 1083093:	4c 39 c6             	cmp    %r8,%rsi
 1083096:	0f 87 a8 01 00 00    	ja     1083244 <check_input_run+0x2f34>
 108309c:	4c 8b 44 24 28       	mov    0x28(%rsp),%r8
 10830a1:	48 01 f7             	add    %rsi,%rdi
 10830a4:	49 89 78 08          	mov    %rdi,0x8(%r8)
 10830a8:	48 89 94 24 88 05 00 	mov    %rdx,0x588(%rsp)
 10830af:	00 
 10830b0:	48 85 d2             	test   %rdx,%rdx
 10830b3:	0f 84 97 01 00 00    	je     1083250 <check_input_run+0x2f40>
 10830b9:	48 8b bc 24 18 01 00 	mov    0x118(%rsp),%rdi
 10830c0:	00 
 10830c1:	48 01 f2             	add    %rsi,%rdx
 10830c4:	49 89 c8             	mov    %rcx,%r8
 10830c7:	48 89 d6             	mov    %rdx,%rsi
 10830ca:	48 29 c6             	sub    %rax,%rsi
 10830cd:	8b bf a4 00 00 00    	mov    0xa4(%rdi),%edi
 10830d3:	48 c1 e7 02          	shl    $0x2,%rdi
 10830d7:	49 29 f0             	sub    %rsi,%r8
 10830da:	41 0f 92 c1          	setb   %r9b
 10830de:	4c 39 c7             	cmp    %r8,%rdi
 10830e1:	41 0f 97 c0          	seta   %r8b
 10830e5:	45 08 c8             	or     %r9b,%r8b
 10830e8:	41 80 f8 01          	cmp    $0x1,%r8b
 10830ec:	0f 84 5e 01 00 00    	je     1083250 <check_input_run+0x2f40>
 10830f2:	4c 8b 44 24 28       	mov    0x28(%rsp),%r8
 10830f7:	48 01 fe             	add    %rdi,%rsi
 10830fa:	49 89 70 08          	mov    %rsi,0x8(%r8)
 10830fe:	48 89 94 24 b0 05 00 	mov    %rdx,0x5b0(%rsp)
 1083105:	00 
 1083106:	48 85 d2             	test   %rdx,%rdx
 1083109:	0f 84 4d 01 00 00    	je     108325c <check_input_run+0x2f4c>
 108310f:	48 8b b4 24 18 01 00 	mov    0x118(%rsp),%rsi
 1083116:	00 
 1083117:	48 01 fa             	add    %rdi,%rdx
 108311a:	49 89 c8             	mov    %rcx,%r8
 108311d:	48 89 d7             	mov    %rdx,%rdi
 1083120:	48 29 c7             	sub    %rax,%rdi
 1083123:	49 29 f8             	sub    %rdi,%r8
 1083126:	41 0f 92 c1          	setb   %r9b
 108312a:	8b b6 a4 00 00 00    	mov    0xa4(%rsi),%esi
 1083130:	49 39 f0             	cmp    %rsi,%r8
 1083133:	41 0f 92 c0          	setb   %r8b
 1083137:	45 08 c8             	or     %r9b,%r8b
 108313a:	41 80 f8 01          	cmp    $0x1,%r8b
 108313e:	0f 84 18 01 00 00    	je     108325c <check_input_run+0x2f4c>
 1083144:	4c 8b 44 24 28       	mov    0x28(%rsp),%r8
 1083149:	48 01 f7             	add    %rsi,%rdi
 108314c:	48 85 d2             	test   %rdx,%rdx
 108314f:	0f 95 c3             	setne  %bl
 1083152:	49 89 78 08          	mov    %rdi,0x8(%r8)
 1083156:	48 8b bc 24 d0 00 00 	mov    0xd0(%rsp),%rdi
 108315d:	00 
 108315e:	48 89 94 24 b8 05 00 	mov    %rdx,0x5b8(%rsp)
 1083165:	00 
 1083166:	40 20 df             	and    %bl,%dil
 1083169:	40 80 ff 01          	cmp    $0x1,%dil
 108316d:	0f 85 f7 00 00 00    	jne    108326a <check_input_run+0x2f5a>
 1083173:	48 8d 7c 32 03       	lea    0x3(%rdx,%rsi,1),%rdi
 1083178:	4c 8d 04 32          	lea    (%rdx,%rsi,1),%r8
 108317c:	48 83 e7 fc          	and    $0xfffffffffffffffc,%rdi
 1083180:	4c 39 c7             	cmp    %r8,%rdi
 1083183:	72 2f                	jb     10831b4 <check_input_run+0x2ea4>
 1083185:	48 8b 94 24 18 01 00 	mov    0x118(%rsp),%rdx
 108318c:	00 
 108318d:	48 89 fe             	mov    %rdi,%rsi
 1083190:	48 29 c6             	sub    %rax,%rsi
 1083193:	8b 92 a4 00 00 00    	mov    0xa4(%rdx),%edx
 1083199:	48 c1 e2 02          	shl    $0x2,%rdx
 108319d:	48 29 f1             	sub    %rsi,%rcx
 10831a0:	0f 92 c0             	setb   %al
 10831a3:	48 39 ca             	cmp    %rcx,%rdx
 10831a6:	0f 97 c1             	seta   %cl
 10831a9:	08 c1                	or     %al,%cl
 10831ab:	80 f9 01             	cmp    $0x1,%cl
 10831ae:	0f 85 ed 82 00 00    	jne    108b4a1 <check_input_run+0xb191>
 10831b4:	48 c7 84 24 c0 05 00 	movq   $0x0,0x5c0(%rsp)
 10831bb:	00 00 00 00 00 
 10831c0:	e9 a3 00 00 00       	jmp    1083268 <check_input_run+0x2f58>
 10831c5:	4d 8b 48 10          	mov    0x10(%r8),%r9
 10831c9:	48 89 f7             	mov    %rsi,%rdi
 10831cc:	48 29 d7             	sub    %rdx,%rdi
 10831cf:	31 d2                	xor    %edx,%edx
 10831d1:	49 29 f9             	sub    %rdi,%r9
 10831d4:	72 18                	jb     10831ee <check_input_run+0x2ede>
 10831d6:	4c 6b c1 2c          	imul   $0x2c,%rcx,%r8
 10831da:	4d 39 c8             	cmp    %r9,%r8
 10831dd:	77 0f                	ja     10831ee <check_input_run+0x2ede>
 10831df:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
 10831e4:	4c 01 c7             	add    %r8,%rdi
 10831e7:	48 89 7a 08          	mov    %rdi,0x8(%rdx)
 10831eb:	48 89 f2             	mov    %rsi,%rdx
 10831ee:	48 8b 34 24          	mov    (%rsp),%rsi
 10831f2:	48 89 94 24 88 04 00 	mov    %rdx,0x488(%rsp)
 10831f9:	00 
 10831fa:	4c 8b 06             	mov    (%rsi),%r8
 10831fd:	48 8b 7e 08          	mov    0x8(%rsi),%rdi
 1083201:	4a 8d 74 07 03       	lea    0x3(%rdi,%r8,1),%rsi
 1083206:	4c 01 c7             	add    %r8,%rdi
 1083209:	48 83 e6 fc          	and    $0xfffffffffffffffc,%rsi
 108320d:	48 39 fe             	cmp    %rdi,%rsi
 1083210:	0f 83 34 02 00 00    	jae    108344a <check_input_run+0x313a>
 1083216:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
 108321b:	48 c7 81 c0 00 00 00 	movq   $0x0,0xc0(%rcx)
 1083222:	00 00 00 00 
 1083226:	89 81 cc 00 00 00    	mov    %eax,0xcc(%rcx)
 108322c:	48 c7 84 24 78 05 00 	movq   $0x0,0x578(%rsp)
 1083233:	00 00 00 00 00 
 1083238:	48 c7 84 24 80 05 00 	movq   $0x0,0x580(%rsp)
 108323f:	00 00 00 00 00 
 1083244:	48 c7 84 24 88 05 00 	movq   $0x0,0x588(%rsp)
 108324b:	00 00 00 00 00 
 1083250:	48 c7 84 24 b0 05 00 	movq   $0x0,0x5b0(%rsp)
 1083257:	00 00 00 00 00 
 108325c:	48 c7 84 24 b8 05 00 	movq   $0x0,0x5b8(%rsp)
 1083263:	00 00 00 00 00 
 1083268:	31 db                	xor    %ebx,%ebx
 108326a:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
 108326f:	48 8b 74 24 28       	mov    0x28(%rsp),%rsi
 1083274:	48 8d bc 24 90 02 00 	lea    0x290(%rsp),%rdi
 108327b:	00 
 108327c:	48 8b 80 70 02 00 00 	mov    0x270(%rax),%rax
 1083283:	8b 50 68             	mov    0x68(%rax),%edx
 1083286:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
 108328b:	8d 0c 85 01 00 00 00 	lea    0x1(,%rax,4),%ecx
 1083292:	c5 f8 77             	vzeroupper
 1083295:	e8 b6 b4 ff ff       	call   107e750 <c_bindings_initialize>
 108329a:	84 db                	test   %bl,%bl
 108329c:	0f 84 90 01 00 00    	je     1083432 <check_input_run+0x3122>
 10832a2:	84 c0                	test   %al,%al
 10832a4:	0f 84 88 01 00 00    	je     1083432 <check_input_run+0x3122>
 10832aa:	4c 8b 74 24 58       	mov    0x58(%rsp),%r14
 10832af:	48 8b bc 24 00 03 00 	mov    0x300(%rsp),%rdi
 10832b6:	00 
 10832b7:	31 f6                	xor    %esi,%esi
 10832b9:	4a 8d 1c b5 04 00 00 	lea    0x4(,%r14,4),%rbx
 10832c0:	00 
 10832c1:	4d 8d 6e 01          	lea    0x1(%r14),%r13
 10832c5:	48 89 da             	mov    %rbx,%rdx
 10832c8:	e8 b3 bc 70 ff       	call   78ef80 <memset@plt>
 10832cd:	48 8b bc 24 08 03 00 	mov    0x308(%rsp),%rdi
 10832d4:	00 
 10832d5:	31 f6                	xor    %esi,%esi
 10832d7:	48 89 da             	mov    %rbx,%rdx
 10832da:	e8 a1 bc 70 ff       	call   78ef80 <memset@plt>
 10832df:	48 8b bc 24 10 03 00 	mov    0x310(%rsp),%rdi
 10832e6:	00 
 10832e7:	4e 8d 3c f5 08 00 00 	lea    0x8(,%r14,8),%r15
 10832ee:	00 
 10832ef:	31 f6                	xor    %esi,%esi
 10832f1:	4c 89 fa             	mov    %r15,%rdx
 10832f4:	e8 87 bc 70 ff       	call   78ef80 <memset@plt>
 10832f9:	48 8b bc 24 18 03 00 	mov    0x318(%rsp),%rdi
 1083300:	00 
 1083301:	31 f6                	xor    %esi,%esi
 1083303:	4c 89 fa             	mov    %r15,%rdx
 1083306:	e8 75 bc 70 ff       	call   78ef80 <memset@plt>
 108330b:	48 8b bc 24 30 03 00 	mov    0x330(%rsp),%rdi
 1083312:	00 
 1083313:	be ff 00 00 00       	mov    $0xff,%esi
 1083318:	48 89 da             	mov    %rbx,%rdx
 108331b:	e8 60 bc 70 ff       	call   78ef80 <memset@plt>
 1083320:	48 8b bc 24 58 03 00 	mov    0x358(%rsp),%rdi
 1083327:	00 
 1083328:	31 f6                	xor    %esi,%esi
 108332a:	48 89 da             	mov    %rbx,%rdx
 108332d:	e8 4e bc 70 ff       	call   78ef80 <memset@plt>
 1083332:	48 8b bc 24 60 03 00 	mov    0x360(%rsp),%rdi
 1083339:	00 
 108333a:	31 f6                	xor    %esi,%esi
 108333c:	4c 89 ea             	mov    %r13,%rdx
 108333f:	e8 3c bc 70 ff       	call   78ef80 <memset@plt>
 1083344:	48 8b bc 24 f0 04 00 	mov    0x4f0(%rsp),%rdi
 108334b:	00 
 108334c:	31 f6                	xor    %esi,%esi
 108334e:	48 89 da             	mov    %rbx,%rdx
 1083351:	e8 2a bc 70 ff       	call   78ef80 <memset@plt>
 1083356:	48 8b bc 24 f8 04 00 	mov    0x4f8(%rsp),%rdi
 108335d:	00 
 108335e:	31 f6                	xor    %esi,%esi
 1083360:	48 89 da             	mov    %rbx,%rdx
 1083363:	e8 18 bc 70 ff       	call   78ef80 <memset@plt>
 1083368:	48 8b bc 24 00 05 00 	mov    0x500(%rsp),%rdi
 108336f:	00 
 1083370:	31 f6                	xor    %esi,%esi
 1083372:	4c 89 ea             	mov    %r13,%rdx
 1083375:	e8 06 bc 70 ff       	call   78ef80 <memset@plt>
 108337a:	48 8b bc 24 08 05 00 	mov    0x508(%rsp),%rdi
 1083381:	00 
 1083382:	31 f6                	xor    %esi,%esi
 1083384:	4c 89 ea             	mov    %r13,%rdx
 1083387:	e8 f4 bb 70 ff       	call   78ef80 <memset@plt>
 108338c:	48 8b bc 24 d0 04 00 	mov    0x4d0(%rsp),%rdi
 1083393:	00 
 1083394:	31 f6                	xor    %esi,%esi
 1083396:	4c 89 ea             	mov    %r13,%rdx
 1083399:	e8 e2 bb 70 ff       	call   78ef80 <memset@plt>
 108339e:	48 8b bc 24 e0 04 00 	mov    0x4e0(%rsp),%rdi
 10833a5:	00 
 10833a6:	31 f6                	xor    %esi,%esi
 10833a8:	4c 89 ea             	mov    %r13,%rdx
 10833ab:	e8 d0 bb 70 ff       	call   78ef80 <memset@plt>
 10833b0:	48 8b bc 24 e8 04 00 	mov    0x4e8(%rsp),%rdi
 10833b7:	00 
 10833b8:	31 f6                	xor    %esi,%esi
 10833ba:	4c 89 ea             	mov    %r13,%rdx
 10833bd:	e8 be bb 70 ff       	call   78ef80 <memset@plt>
 10833c2:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
 10833c7:	48 8b 94 24 d8 00 00 	mov    0xd8(%rsp),%rdx
 10833ce:	00 
 10833cf:	31 f6                	xor    %esi,%esi
 10833d1:	49 8b 7e 50          	mov    0x50(%r14),%rdi
 10833d5:	e8 a6 bb 70 ff       	call   78ef80 <memset@plt>
 10833da:	49 8b be c8 02 00 00 	mov    0x2c8(%r14),%rdi
 10833e1:	31 f6                	xor    %esi,%esi
 10833e3:	4c 89 ea             	mov    %r13,%rdx
 10833e6:	e8 95 bb 70 ff       	call   78ef80 <memset@plt>
 10833eb:	49 8b be d0 02 00 00 	mov    0x2d0(%r14),%rdi
 10833f2:	31 f6                	xor    %esi,%esi
 10833f4:	4c 89 ea             	mov    %r13,%rdx
 10833f7:	e8 84 bb 70 ff       	call   78ef80 <memset@plt>
 10833fc:	49 8b b6 f0 01 00 00 	mov    0x1f0(%r14),%rsi
 1083403:	48 8b bc 24 98 03 00 	mov    0x398(%rsp),%rdi
 108340a:	00 
 108340b:	48 85 f6             	test   %rsi,%rsi
 108340e:	0f 94 c0             	sete   %al
 1083411:	48 83 bc 24 20 07 00 	cmpq   $0x0,0x720(%rsp)
 1083418:	00 00 
 108341a:	0f 95 c1             	setne  %cl
 108341d:	08 c1                	or     %al,%cl
 108341f:	0f 85 92 00 00 00    	jne    10834b7 <check_input_run+0x31a7>
 1083425:	4c 89 ea             	mov    %r13,%rdx
 1083428:	e8 73 bc 70 ff       	call   78f0a0 <memcpy@plt>
 108342d:	e9 8f 00 00 00       	jmp    10834c1 <check_input_run+0x31b1>
 1083432:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 1083437:	c6 80 bd 03 00 00 01 	movb   $0x1,0x3bd(%rax)
 108343e:	31 c0                	xor    %eax,%eax
 1083440:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
 1083445:	e9 4c 5e 00 00       	jmp    1089296 <check_input_run+0x8f86>
 108344a:	48 89 f7             	mov    %rsi,%rdi
 108344d:	4c 29 c7             	sub    %r8,%rdi
 1083450:	4c 8b 04 24          	mov    (%rsp),%r8
 1083454:	4d 8b 40 10          	mov    0x10(%r8),%r8
 1083458:	49 29 f8             	sub    %rdi,%r8
 108345b:	0f 82 b5 fd ff ff    	jb     1083216 <check_input_run+0x2f06>
 1083461:	48 c1 e1 02          	shl    $0x2,%rcx
 1083465:	48 8d 0c c9          	lea    (%rcx,%rcx,8),%rcx
 1083469:	4c 39 c1             	cmp    %r8,%rcx
 108346c:	0f 87 a4 fd ff ff    	ja     1083216 <check_input_run+0x2f06>
 1083472:	4c 8b 04 24          	mov    (%rsp),%r8
 1083476:	48 01 cf             	add    %rcx,%rdi
 1083479:	49 89 78 08          	mov    %rdi,0x8(%r8)
 108347d:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
 1083482:	48 89 b7 c0 00 00 00 	mov    %rsi,0xc0(%rdi)
 1083489:	89 87 cc 00 00 00    	mov    %eax,0xcc(%rdi)
 108348f:	48 85 d2             	test   %rdx,%rdx
 1083492:	0f 84 94 fd ff ff    	je     108322c <check_input_run+0x2f1c>
 1083498:	48 85 f6             	test   %rsi,%rsi
 108349b:	0f 84 8b fd ff ff    	je     108322c <check_input_run+0x2f1c>
 10834a1:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
 10834a6:	48 8b 80 70 02 00 00 	mov    0x270(%rax),%rax
 10834ad:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
 10834b2:	e9 d2 fa ff ff       	jmp    1082f89 <check_input_run+0x2c79>
 10834b7:	31 f6                	xor    %esi,%esi
 10834b9:	4c 89 ea             	mov    %r13,%rdx
 10834bc:	e8 bf ba 70 ff       	call   78ef80 <memset@plt>
 10834c1:	48 8b bc 24 68 03 00 	mov    0x368(%rsp),%rdi
 10834c8:	00 
 10834c9:	45 31 f6             	xor    %r14d,%r14d
 10834cc:	31 f6                	xor    %esi,%esi
 10834ce:	4c 89 ea             	mov    %r13,%rdx
 10834d1:	e8 aa ba 70 ff       	call   78ef80 <memset@plt>
 10834d6:	48 8b bc 24 70 03 00 	mov    0x370(%rsp),%rdi
 10834dd:	00 
 10834de:	31 f6                	xor    %esi,%esi
 10834e0:	4c 89 ea             	mov    %r13,%rdx
 10834e3:	e8 98 ba 70 ff       	call   78ef80 <memset@plt>
 10834e8:	48 8b 84 24 f8 00 00 	mov    0xf8(%rsp),%rax
 10834ef:	00 
 10834f0:	31 f6                	xor    %esi,%esi
 10834f2:	4c 89 ea             	mov    %r13,%rdx
 10834f5:	48 8b 38             	mov    (%rax),%rdi
 10834f8:	e8 83 ba 70 ff       	call   78ef80 <memset@plt>
 10834fd:	48 8b bc 24 78 03 00 	mov    0x378(%rsp),%rdi
 1083504:	00 
 1083505:	31 f6                	xor    %esi,%esi
 1083507:	4c 89 ea             	mov    %r13,%rdx
 108350a:	e8 71 ba 70 ff       	call   78ef80 <memset@plt>
 108350f:	48 8b bc 24 80 03 00 	mov    0x380(%rsp),%rdi
 1083516:	00 
 1083517:	31 f6                	xor    %esi,%esi
 1083519:	4c 89 ea             	mov    %r13,%rdx
 108351c:	e8 5f ba 70 ff       	call   78ef80 <memset@plt>
 1083521:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
 1083528:	00 
 1083529:	31 f6                	xor    %esi,%esi
 108352b:	4c 89 ea             	mov    %r13,%rdx
 108352e:	48 8b 38             	mov    (%rax),%rdi
 1083531:	e8 4a ba 70 ff       	call   78ef80 <memset@plt>
 1083536:	48 8b 84 24 00 01 00 	mov    0x100(%rsp),%rax
 108353d:	00 
 108353e:	31 f6                	xor    %esi,%esi
 1083540:	4c 89 ea             	mov    %r13,%rdx
 1083543:	48 8b 38             	mov    (%rax),%rdi
 1083546:	e8 35 ba 70 ff       	call   78ef80 <memset@plt>
 108354b:	48 8b 84 24 80 00 00 	mov    0x80(%rsp),%rax
 1083552:	00 
 1083553:	31 f6                	xor    %esi,%esi
 1083555:	4c 89 ea             	mov    %r13,%rdx
 1083558:	48 8b 38             	mov    (%rax),%rdi
 108355b:	e8 20 ba 70 ff       	call   78ef80 <memset@plt>
 1083560:	48 8b 84 24 e8 00 00 	mov    0xe8(%rsp),%rax
 1083567:	00 
 1083568:	31 f6                	xor    %esi,%esi
 108356a:	4c 89 ea             	mov    %r13,%rdx
 108356d:	48 8b 38             	mov    (%rax),%rdi
 1083570:	e8 0b ba 70 ff       	call   78ef80 <memset@plt>
 1083575:	48 8b 84 24 c0 01 00 	mov    0x1c0(%rsp),%rax
 108357c:	00 
 108357d:	31 f6                	xor    %esi,%esi
 108357f:	48 89 da             	mov    %rbx,%rdx
 1083582:	48 8b 38             	mov    (%rax),%rdi
 1083585:	e8 f6 b9 70 ff       	call   78ef80 <memset@plt>
 108358a:	48 8b 84 24 b8 01 00 	mov    0x1b8(%rsp),%rax
 1083591:	00 
 1083592:	31 f6                	xor    %esi,%esi
 1083594:	48 89 da             	mov    %rbx,%rdx
 1083597:	48 8b 38             	mov    (%rax),%rdi
 108359a:	e8 e1 b9 70 ff       	call   78ef80 <memset@plt>
 108359f:	48 8b 84 24 a8 00 00 	mov    0xa8(%rsp),%rax
 10835a6:	00 
 10835a7:	31 f6                	xor    %esi,%esi
 10835a9:	4c 89 fa             	mov    %r15,%rdx
 10835ac:	48 8b 38             	mov    (%rax),%rdi
 10835af:	e8 cc b9 70 ff       	call   78ef80 <memset@plt>
 10835b4:	48 8b bc 24 10 05 00 	mov    0x510(%rsp),%rdi
 10835bb:	00 
 10835bc:	31 f6                	xor    %esi,%esi
 10835be:	4c 89 fa             	mov    %r15,%rdx
 10835c1:	e8 ba b9 70 ff       	call   78ef80 <memset@plt>
 10835c6:	48 8b bc 24 88 03 00 	mov    0x388(%rsp),%rdi
 10835cd:	00 
 10835ce:	31 f6                	xor    %esi,%esi
 10835d0:	4c 89 ea             	mov    %r13,%rdx
 10835d3:	e8 a8 b9 70 ff       	call   78ef80 <memset@plt>
 10835d8:	48 8b bc 24 90 03 00 	mov    0x390(%rsp),%rdi
 10835df:	00 
 10835e0:	31 f6                	xor    %esi,%esi
 10835e2:	48 89 da             	mov    %rbx,%rdx
 10835e5:	e8 96 b9 70 ff       	call   78ef80 <memset@plt>
 10835ea:	48 8b 6c 24 48       	mov    0x48(%rsp),%rbp
 10835ef:	48 8b bc 24 50 05 00 	mov    0x550(%rsp),%rdi
 10835f6:	00 
 10835f7:	31 f6                	xor    %esi,%esi
 10835f9:	48 8b 85 70 02 00 00 	mov    0x270(%rbp),%rax
 1083600:	8b 50 68             	mov    0x68(%rax),%edx
 1083603:	48 c1 e2 02          	shl    $0x2,%rdx
 1083607:	e8 74 b9 70 ff       	call   78ef80 <memset@plt>
 108360c:	48 8b bc 24 60 05 00 	mov    0x560(%rsp),%rdi
 1083613:	00 
 1083614:	31 f6                	xor    %esi,%esi
 1083616:	4c 89 ea             	mov    %r13,%rdx
 1083619:	e8 62 b9 70 ff       	call   78ef80 <memset@plt>
 108361e:	48 8b 85 70 02 00 00 	mov    0x270(%rbp),%rax
 1083625:	48 8b bc 24 78 05 00 	mov    0x578(%rsp),%rdi
 108362c:	00 
 108362d:	31 f6                	xor    %esi,%esi
 108362f:	8b 50 68             	mov    0x68(%rax),%edx
 1083632:	48 c1 e2 02          	shl    $0x2,%rdx
 1083636:	e8 45 b9 70 ff       	call   78ef80 <memset@plt>
 108363b:	48 8b 85 70 02 00 00 	mov    0x270(%rbp),%rax
 1083642:	48 8b bc 24 80 05 00 	mov    0x580(%rsp),%rdi
 1083649:	00 
 108364a:	31 f6                	xor    %esi,%esi
 108364c:	8b 50 68             	mov    0x68(%rax),%edx
 108364f:	48 c1 e2 02          	shl    $0x2,%rdx
 1083653:	e8 28 b9 70 ff       	call   78ef80 <memset@plt>
 1083658:	48 8b 85 70 02 00 00 	mov    0x270(%rbp),%rax
 108365f:	48 8b bc 24 88 05 00 	mov    0x588(%rsp),%rdi
 1083666:	00 
 1083667:	31 f6                	xor    %esi,%esi
 1083669:	8b 50 68             	mov    0x68(%rax),%edx
 108366c:	48 c1 e2 02          	shl    $0x2,%rdx
 1083670:	e8 0b b9 70 ff       	call   78ef80 <memset@plt>
 1083675:	48 8b bc 24 90 05 00 	mov    0x590(%rsp),%rdi
 108367c:	00 
 108367d:	31 f6                	xor    %esi,%esi
 108367f:	48 89 da             	mov    %rbx,%rdx
 1083682:	e8 f9 b8 70 ff       	call   78ef80 <memset@plt>
 1083687:	4c 8b bc 24 18 01 00 	mov    0x118(%rsp),%r15
 108368e:	00 
 108368f:	48 8b bc 24 b0 05 00 	mov    0x5b0(%rsp),%rdi
 1083696:	00 
 1083697:	be ff 00 00 00       	mov    $0xff,%esi
 108369c:	41 8b 97 a4 00 00 00 	mov    0xa4(%r15),%edx
 10836a3:	48 c1 e2 02          	shl    $0x2,%rdx
 10836a7:	e8 d4 b8 70 ff       	call   78ef80 <memset@plt>
 10836ac:	48 8b bc 24 b8 05 00 	mov    0x5b8(%rsp),%rdi
 10836b3:	00 
 10836b4:	41 8b 97 a4 00 00 00 	mov    0xa4(%r15),%edx
 10836bb:	31 f6                	xor    %esi,%esi
 10836bd:	e8 be b8 70 ff       	call   78ef80 <memset@plt>
 10836c2:	48 8b bc 24 a0 03 00 	mov    0x3a0(%rsp),%rdi
 10836c9:	00 
 10836ca:	31 f6                	xor    %esi,%esi
 10836cc:	4c 89 ea             	mov    %r13,%rdx
 10836cf:	e8 ac b8 70 ff       	call   78ef80 <memset@plt>
 10836d4:	48 8b bc 24 a8 03 00 	mov    0x3a8(%rsp),%rdi
 10836db:	00 
 10836dc:	31 f6                	xor    %esi,%esi
 10836de:	4c 89 ea             	mov    %r13,%rdx
 10836e1:	e8 9a b8 70 ff       	call   78ef80 <memset@plt>
 10836e6:	48 8b bc 24 e8 03 00 	mov    0x3e8(%rsp),%rdi
 10836ed:	00 
 10836ee:	31 f6                	xor    %esi,%esi
 10836f0:	4c 89 ea             	mov    %r13,%rdx
 10836f3:	e8 88 b8 70 ff       	call   78ef80 <memset@plt>
 10836f8:	48 8b bc 24 f0 03 00 	mov    0x3f0(%rsp),%rdi
 10836ff:	00 
 1083700:	31 f6                	xor    %esi,%esi
 1083702:	48 89 da             	mov    %rbx,%rdx
 1083705:	e8 76 b8 70 ff       	call   78ef80 <memset@plt>
 108370a:	48 8b bc 24 f8 03 00 	mov    0x3f8(%rsp),%rdi
 1083711:	00 
 1083712:	31 f6                	xor    %esi,%esi
 1083714:	48 89 da             	mov    %rbx,%rdx
 1083717:	e8 64 b8 70 ff       	call   78ef80 <memset@plt>
 108371c:	48 8b bc 24 c8 03 00 	mov    0x3c8(%rsp),%rdi
 1083723:	00 
 1083724:	31 f6                	xor    %esi,%esi
 1083726:	48 89 da             	mov    %rbx,%rdx
 1083729:	e8 52 b8 70 ff       	call   78ef80 <memset@plt>
 108372e:	48 8b bc 24 08 04 00 	mov    0x408(%rsp),%rdi
 1083735:	00 
 1083736:	31 f6                	xor    %esi,%esi
 1083738:	48 89 da             	mov    %rbx,%rdx
 108373b:	e8 40 b8 70 ff       	call   78ef80 <memset@plt>
 1083740:	48 8b bc 24 10 04 00 	mov    0x410(%rsp),%rdi
 1083747:	00 
 1083748:	31 f6                	xor    %esi,%esi
 108374a:	48 89 da             	mov    %rbx,%rdx
 108374d:	e8 2e b8 70 ff       	call   78ef80 <memset@plt>
 1083752:	48 8b bc 24 20 04 00 	mov    0x420(%rsp),%rdi
 1083759:	00 
 108375a:	31 f6                	xor    %esi,%esi
 108375c:	48 89 da             	mov    %rbx,%rdx
 108375f:	e8 1c b8 70 ff       	call   78ef80 <memset@plt>
 1083764:	48 8b bc 24 68 04 00 	mov    0x468(%rsp),%rdi
 108376b:	00 
 108376c:	4d 01 ed             	add    %r13,%r13
 108376f:	31 f6                	xor    %esi,%esi
 1083771:	4c 89 ea             	mov    %r13,%rdx
 1083774:	e8 07 b8 70 ff       	call   78ef80 <memset@plt>
 1083779:	48 8b bc 24 70 04 00 	mov    0x470(%rsp),%rdi
 1083780:	00 
 1083781:	31 f6                	xor    %esi,%esi
 1083783:	48 89 da             	mov    %rbx,%rdx
 1083786:	e8 f5 b7 70 ff       	call   78ef80 <memset@plt>
 108378b:	48 8b bc 24 90 04 00 	mov    0x490(%rsp),%rdi
 1083792:	00 
 1083793:	31 f6                	xor    %esi,%esi
 1083795:	48 89 da             	mov    %rbx,%rdx
 1083798:	e8 e3 b7 70 ff       	call   78ef80 <memset@plt>
 108379d:	48 8b bc 24 98 04 00 	mov    0x498(%rsp),%rdi
 10837a4:	00 
 10837a5:	31 f6                	xor    %esi,%esi
 10837a7:	48 89 da             	mov    %rbx,%rdx
 10837aa:	e8 d1 b7 70 ff       	call   78ef80 <memset@plt>
 10837af:	48 8b bc 24 a8 04 00 	mov    0x4a8(%rsp),%rdi
 10837b6:	00 
 10837b7:	31 f6                	xor    %esi,%esi
 10837b9:	48 89 da             	mov    %rbx,%rdx
 10837bc:	e8 bf b7 70 ff       	call   78ef80 <memset@plt>
 10837c1:	48 8b bc 24 b0 04 00 	mov    0x4b0(%rsp),%rdi
 10837c8:	00 
 10837c9:	31 f6                	xor    %esi,%esi
 10837cb:	48 89 da             	mov    %rbx,%rdx
 10837ce:	e8 ad b7 70 ff       	call   78ef80 <memset@plt>
 10837d3:	48 8b bc 24 b8 04 00 	mov    0x4b8(%rsp),%rdi
 10837da:	00 
 10837db:	31 f6                	xor    %esi,%esi
 10837dd:	48 89 da             	mov    %rbx,%rdx
 10837e0:	e8 9b b7 70 ff       	call   78ef80 <memset@plt>
 10837e5:	48 8b 85 70 02 00 00 	mov    0x270(%rbp),%rax
 10837ec:	48 8b bc 24 30 04 00 	mov    0x430(%rsp),%rdi
 10837f3:	00 
 10837f4:	be ff 00 00 00       	mov    $0xff,%esi
 10837f9:	8b 50 68             	mov    0x68(%rax),%edx
 10837fc:	48 01 d2             	add    %rdx,%rdx
 10837ff:	e8 7c b7 70 ff       	call   78ef80 <memset@plt>
 1083804:	48 8b b4 24 08 01 00 	mov    0x108(%rsp),%rsi
 108380b:	00 
 108380c:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
 1083811:	48 8b 94 24 28 01 00 	mov    0x128(%rsp),%rdx
 1083818:	00 
 1083819:	48 8b bc 24 c0 00 00 	mov    0xc0(%rsp),%rdi
 1083820:	00 
 1083821:	4c 8b 84 24 20 01 00 	mov    0x120(%rsp),%r8
 1083828:	00 
 1083829:	4c 8b 8c 24 c8 01 00 	mov    0x1c8(%rsp),%r9
 1083830:	00 
 1083831:	4c 8b 54 24 70       	mov    0x70(%rsp),%r10
 1083836:	4c 8b 5c 24 78       	mov    0x78(%rsp),%r11
 108383b:	48 8b 9c 24 90 00 00 	mov    0x90(%rsp),%rbx
 1083842:	00 
 1083843:	4c 8b bc 24 b8 00 00 	mov    0xb8(%rsp),%r15
 108384a:	00 
 108384b:	4c 8b ac 24 e0 00 00 	mov    0xe0(%rsp),%r13
 1083852:	00 
 1083853:	48 8b ac 24 10 01 00 	mov    0x110(%rsp),%rbp
 108385a:	00 
 108385b:	83 fe 01             	cmp    $0x1,%esi
 108385e:	83 d6 00             	adc    $0x0,%esi
 1083861:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1083868:	0f 1f 84 00 00 00 00 
 108386f:	00 
 1083870:	48 8b 07             	mov    (%rdi),%rax
 1083873:	42 c7 04 b0 ff ff ff 	movl   $0xffffffff,(%rax,%r14,4)
 108387a:	ff 
 108387b:	49 8b 00             	mov    (%r8),%rax
 108387e:	42 c7 04 b0 ff ff ff 	movl   $0xffffffff,(%rax,%r14,4)
 1083885:	ff 
 1083886:	48 8b 01             	mov    (%rcx),%rax
 1083889:	42 c7 04 b0 ff ff ff 	movl   $0xffffffff,(%rax,%r14,4)
 1083890:	ff 
 1083891:	48 8b 02             	mov    (%rdx),%rax
 1083894:	42 c7 04 b0 ff ff ff 	movl   $0xffffffff,(%rax,%r14,4)
 108389b:	ff 
 108389c:	49 8b 01             	mov    (%r9),%rax
 108389f:	42 c7 04 b0 ff ff ff 	movl   $0xffffffff,(%rax,%r14,4)
 10838a6:	ff 
 10838a7:	49 8b 02             	mov    (%r10),%rax
 10838aa:	42 c7 04 b0 ff ff ff 	movl   $0xffffffff,(%rax,%r14,4)
 10838b1:	ff 
 10838b2:	49 8b 03             	mov    (%r11),%rax
 10838b5:	42 c7 04 b0 ff ff ff 	movl   $0xffffffff,(%rax,%r14,4)
 10838bc:	ff 
 10838bd:	48 8b 03             	mov    (%rbx),%rax
 10838c0:	42 c7 04 b0 ff ff ff 	movl   $0xffffffff,(%rax,%r14,4)
 10838c7:	ff 
 10838c8:	49 8b 07             	mov    (%r15),%rax
 10838cb:	42 c7 04 b0 ff ff ff 	movl   $0xffffffff,(%rax,%r14,4)
 10838d2:	ff 
 10838d3:	49 8b 45 00          	mov    0x0(%r13),%rax
 10838d7:	42 c7 04 b0 ff ff ff 	movl   $0xffffffff,(%rax,%r14,4)
 10838de:	ff 
 10838df:	48 8b 45 00          	mov    0x0(%rbp),%rax
 10838e3:	42 c7 04 b0 ff ff ff 	movl   $0xffffffff,(%rax,%r14,4)
 10838ea:	ff 
 10838eb:	48 8b 84 24 d8 03 00 	mov    0x3d8(%rsp),%rax
 10838f2:	00 
 10838f3:	42 c7 04 b0 ff ff ff 	movl   $0xffffffff,(%rax,%r14,4)
 10838fa:	ff 
 10838fb:	48 8b 84 24 b0 03 00 	mov    0x3b0(%rsp),%rax
 1083902:	00 
 1083903:	42 c7 04 b0 ff ff ff 	movl   $0xffffffff,(%rax,%r14,4)
 108390a:	ff 
 108390b:	48 8b 84 24 b8 03 00 	mov    0x3b8(%rsp),%rax
 1083912:	00 
 1083913:	42 c7 04 b0 ff ff ff 	movl   $0xffffffff,(%rax,%r14,4)
 108391a:	ff 
 108391b:	48 8b 84 24 c0 03 00 	mov    0x3c0(%rsp),%rax
 1083922:	00 
 1083923:	42 c7 04 b0 ff ff ff 	movl   $0xffffffff,(%rax,%r14,4)
 108392a:	ff 
 108392b:	48 8b 84 24 00 04 00 	mov    0x400(%rsp),%rax
 1083932:	00 
 1083933:	42 c7 04 b0 ff ff ff 	movl   $0xffffffff,(%rax,%r14,4)
 108393a:	ff 
 108393b:	48 8b 84 24 30 05 00 	mov    0x530(%rsp),%rax
 1083942:	00 
 1083943:	42 c7 04 b0 ff ff ff 	movl   $0xffffffff,(%rax,%r14,4)
 108394a:	ff 
 108394b:	48 8b 84 24 40 05 00 	mov    0x540(%rsp),%rax
 1083952:	00 
 1083953:	42 c7 04 b0 ff ff ff 	movl   $0xffffffff,(%rax,%r14,4)
 108395a:	ff 
 108395b:	48 8b 84 24 d0 05 00 	mov    0x5d0(%rsp),%rax
 1083962:	00 
 1083963:	42 c7 04 b0 ff ff ff 	movl   $0xffffffff,(%rax,%r14,4)
 108396a:	ff 
 108396b:	48 8b 84 24 d8 05 00 	mov    0x5d8(%rsp),%rax
 1083972:	00 
 1083973:	42 c7 04 b0 ff ff ff 	movl   $0xffffffff,(%rax,%r14,4)
 108397a:	ff 
 108397b:	48 8b 84 24 e0 05 00 	mov    0x5e0(%rsp),%rax
 1083982:	00 
 1083983:	42 c7 04 b0 ff ff ff 	movl   $0xffffffff,(%rax,%r14,4)
 108398a:	ff 
 108398b:	48 8b 84 24 e8 05 00 	mov    0x5e8(%rsp),%rax
 1083992:	00 
 1083993:	42 c7 04 b0 ff ff ff 	movl   $0xffffffff,(%rax,%r14,4)
 108399a:	ff 
 108399b:	48 8b 84 24 c8 05 00 	mov    0x5c8(%rsp),%rax
 10839a2:	00 
 10839a3:	46 89 34 b0          	mov    %r14d,(%rax,%r14,4)
 10839a7:	49 ff c6             	inc    %r14
 10839aa:	4c 39 f6             	cmp    %r14,%rsi
 10839ad:	0f 85 bd fe ff ff    	jne    1083870 <check_input_run+0x3560>
 10839b3:	83 7c 24 18 00       	cmpl   $0x0,0x18(%rsp)
 10839b8:	0f 84 2d 04 00 00    	je     1083deb <check_input_run+0x3adb>
 10839be:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
 10839c3:	89 c2                	mov    %eax,%edx
 10839c5:	8d 48 ff             	lea    -0x1(%rax),%ecx
 10839c8:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
 10839cd:	83 e2 03             	and    $0x3,%edx
 10839d0:	74 50                	je     1083a22 <check_input_run+0x3712>
 10839d2:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
 10839d7:	eb 0e                	jmp    10839e7 <check_input_run+0x36d7>
 10839d9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
 10839e0:	48 ff c8             	dec    %rax
 10839e3:	ff ca                	dec    %edx
 10839e5:	74 3b                	je     1083a22 <check_input_run+0x3712>
 10839e7:	49 8b 7c 24 60       	mov    0x60(%r12),%rdi
 10839ec:	8d 70 ff             	lea    -0x1(%rax),%esi
 10839ef:	8b 3c b7             	mov    (%rdi,%rsi,4),%edi
 10839f2:	3b 7c 24 18          	cmp    0x18(%rsp),%edi
 10839f6:	73 e8                	jae    10839e0 <check_input_run+0x36d0>
 10839f8:	4c 8b 8c 24 d0 05 00 	mov    0x5d0(%rsp),%r9
 10839ff:	00 
 1083a00:	4c 8b 94 24 d8 05 00 	mov    0x5d8(%rsp),%r10
 1083a07:	00 
 1083a08:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
 1083a0c:	45 8b 0c b9          	mov    (%r9,%rdi,4),%r9d
 1083a10:	45 89 0c b2          	mov    %r9d,(%r10,%rsi,4)
 1083a14:	48 8b b4 24 d0 05 00 	mov    0x5d0(%rsp),%rsi
 1083a1b:	00 
 1083a1c:	44 89 04 be          	mov    %r8d,(%rsi,%rdi,4)
 1083a20:	eb be                	jmp    10839e0 <check_input_run+0x36d0>
 1083a22:	83 f9 03             	cmp    $0x3,%ecx
 1083a25:	73 1f                	jae    1083a46 <check_input_run+0x3736>
 1083a27:	48 8b 74 24 58       	mov    0x58(%rsp),%rsi
 1083a2c:	89 f0                	mov    %esi,%eax
 1083a2e:	48 8d 4e ff          	lea    -0x1(%rsi),%rcx
 1083a32:	83 e0 03             	and    $0x3,%eax
 1083a35:	48 83 f9 03          	cmp    $0x3,%rcx
 1083a39:	0f 83 7c 01 00 00    	jae    1083bbb <check_input_run+0x38ab>
 1083a3f:	31 d2                	xor    %edx,%edx
 1083a41:	e9 b2 02 00 00       	jmp    1083cf8 <check_input_run+0x39e8>
 1083a46:	b9 fc ff ff ff       	mov    $0xfffffffc,%ecx
 1083a4b:	49 c7 c0 fc ff ff ff 	mov    $0xfffffffffffffffc,%r8
 1083a52:	49 c7 c1 fd ff ff ff 	mov    $0xfffffffffffffffd,%r9
 1083a59:	49 c7 c2 fe ff ff ff 	mov    $0xfffffffffffffffe,%r10
 1083a60:	49 c7 c3 ff ff ff ff 	mov    $0xffffffffffffffff,%r11
 1083a67:	31 db                	xor    %ebx,%ebx
 1083a69:	48 8d 51 01          	lea    0x1(%rcx),%rdx
 1083a6d:	48 8d 71 02          	lea    0x2(%rcx),%rsi
 1083a71:	48 8d 79 03          	lea    0x3(%rcx),%rdi
 1083a75:	eb 35                	jmp    1083aac <check_input_run+0x379c>
 1083a77:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
 1083a7e:	00 00 
 1083a80:	49 83 c0 fc          	add    $0xfffffffffffffffc,%r8
 1083a84:	48 83 c3 04          	add    $0x4,%rbx
 1083a88:	48 83 c1 fc          	add    $0xfffffffffffffffc,%rcx
 1083a8c:	49 83 c1 fc          	add    $0xfffffffffffffffc,%r9
 1083a90:	48 83 c2 fc          	add    $0xfffffffffffffffc,%rdx
 1083a94:	49 83 c2 fc          	add    $0xfffffffffffffffc,%r10
 1083a98:	48 83 c6 fc          	add    $0xfffffffffffffffc,%rsi
 1083a9c:	49 83 c3 fc          	add    $0xfffffffffffffffc,%r11
 1083aa0:	48 83 c7 fc          	add    $0xfffffffffffffffc,%rdi
 1083aa4:	39 d8                	cmp    %ebx,%eax
 1083aa6:	0f 84 7b ff ff ff    	je     1083a27 <check_input_run+0x3717>
 1083aac:	4d 8b 7c 24 60       	mov    0x60(%r12),%r15
 1083ab1:	46 8d 34 18          	lea    (%rax,%r11,1),%r14d
 1083ab5:	47 8b 3c b7          	mov    (%r15,%r14,4),%r15d
 1083ab9:	44 3b 7c 24 18       	cmp    0x18(%rsp),%r15d
 1083abe:	73 2d                	jae    1083aed <check_input_run+0x37dd>
 1083ac0:	4c 8b a4 24 d0 05 00 	mov    0x5d0(%rsp),%r12
 1083ac7:	00 
 1083ac8:	4c 8b ac 24 d8 05 00 	mov    0x5d8(%rsp),%r13
 1083acf:	00 
 1083ad0:	8d 2c 38             	lea    (%rax,%rdi,1),%ebp
 1083ad3:	47 8b 24 bc          	mov    (%r12,%r15,4),%r12d
 1083ad7:	47 89 64 b5 00       	mov    %r12d,0x0(%r13,%r14,4)
 1083adc:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
 1083ae1:	4c 8b b4 24 d0 05 00 	mov    0x5d0(%rsp),%r14
 1083ae8:	00 
 1083ae9:	43 89 2c be          	mov    %ebp,(%r14,%r15,4)
 1083aed:	4d 8b 7c 24 60       	mov    0x60(%r12),%r15
 1083af2:	46 8d 34 10          	lea    (%rax,%r10,1),%r14d
 1083af6:	47 8b 3c b7          	mov    (%r15,%r14,4),%r15d
 1083afa:	44 3b 7c 24 18       	cmp    0x18(%rsp),%r15d
 1083aff:	73 2d                	jae    1083b2e <check_input_run+0x381e>
 1083b01:	4c 8b a4 24 d0 05 00 	mov    0x5d0(%rsp),%r12
 1083b08:	00 
 1083b09:	4c 8b ac 24 d8 05 00 	mov    0x5d8(%rsp),%r13
 1083b10:	00 
 1083b11:	8d 2c 30             	lea    (%rax,%rsi,1),%ebp
 1083b14:	47 8b 24 bc          	mov    (%r12,%r15,4),%r12d
 1083b18:	47 89 64 b5 00       	mov    %r12d,0x0(%r13,%r14,4)
 1083b1d:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
 1083b22:	4c 8b b4 24 d0 05 00 	mov    0x5d0(%rsp),%r14
 1083b29:	00 
 1083b2a:	43 89 2c be          	mov    %ebp,(%r14,%r15,4)
 1083b2e:	4d 8b 7c 24 60       	mov    0x60(%r12),%r15
 1083b33:	46 8d 34 08          	lea    (%rax,%r9,1),%r14d
 1083b37:	47 8b 3c b7          	mov    (%r15,%r14,4),%r15d
 1083b3b:	44 3b 7c 24 18       	cmp    0x18(%rsp),%r15d
 1083b40:	73 2d                	jae    1083b6f <check_input_run+0x385f>
 1083b42:	4c 8b a4 24 d0 05 00 	mov    0x5d0(%rsp),%r12
 1083b49:	00 
 1083b4a:	4c 8b ac 24 d8 05 00 	mov    0x5d8(%rsp),%r13
 1083b51:	00 
 1083b52:	8d 2c 10             	lea    (%rax,%rdx,1),%ebp
 1083b55:	47 8b 24 bc          	mov    (%r12,%r15,4),%r12d
 1083b59:	47 89 64 b5 00       	mov    %r12d,0x0(%r13,%r14,4)
 1083b5e:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
 1083b63:	4c 8b b4 24 d0 05 00 	mov    0x5d0(%rsp),%r14
 1083b6a:	00 
 1083b6b:	43 89 2c be          	mov    %ebp,(%r14,%r15,4)
 1083b6f:	4d 8b 7c 24 60       	mov    0x60(%r12),%r15
 1083b74:	46 8d 34 00          	lea    (%rax,%r8,1),%r14d
 1083b78:	47 8b 3c b7          	mov    (%r15,%r14,4),%r15d
 1083b7c:	44 3b 7c 24 18       	cmp    0x18(%rsp),%r15d
 1083b81:	0f 83 f9 fe ff ff    	jae    1083a80 <check_input_run+0x3770>
 1083b87:	4c 8b ac 24 d0 05 00 	mov    0x5d0(%rsp),%r13
 1083b8e:	00 
 1083b8f:	48 8b ac 24 d8 05 00 	mov    0x5d8(%rsp),%rbp
 1083b96:	00 
 1083b97:	4c 8d 24 08          	lea    (%rax,%rcx,1),%r12
 1083b9b:	47 8b 6c bd 00       	mov    0x0(%r13,%r15,4),%r13d
 1083ba0:	46 89 6c b5 00       	mov    %r13d,0x0(%rbp,%r14,4)
 1083ba5:	4c 8b b4 24 d0 05 00 	mov    0x5d0(%rsp),%r14
 1083bac:	00 
 1083bad:	47 89 24 be          	mov    %r12d,(%r14,%r15,4)
 1083bb1:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
 1083bb6:	e9 c5 fe ff ff       	jmp    1083a80 <check_input_run+0x3770>
 1083bbb:	83 e6 fc             	and    $0xfffffffc,%esi
 1083bbe:	31 ff                	xor    %edi,%edi
 1083bc0:	eb 1a                	jmp    1083bdc <check_input_run+0x38cc>
 1083bc2:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1083bc9:	1f 84 00 00 00 00 00 
 1083bd0:	48 ff c7             	inc    %rdi
 1083bd3:	48 39 f7             	cmp    %rsi,%rdi
 1083bd6:	0f 84 09 01 00 00    	je     1083ce5 <check_input_run+0x39d5>
 1083bdc:	4d 8b 44 24 68       	mov    0x68(%r12),%r8
 1083be1:	48 89 fa             	mov    %rdi,%rdx
 1083be4:	41 8b 3c 90          	mov    (%r8,%rdx,4),%edi
 1083be8:	4c 8b 84 24 a8 05 00 	mov    0x5a8(%rsp),%r8
 1083bef:	00 
 1083bf0:	41 89 14 b8          	mov    %edx,(%r8,%rdi,4)
 1083bf4:	4d 8b 44 24 60       	mov    0x60(%r12),%r8
 1083bf9:	45 8b 04 b8          	mov    (%r8,%rdi,4),%r8d
 1083bfd:	44 3b 44 24 18       	cmp    0x18(%rsp),%r8d
 1083c02:	73 16                	jae    1083c1a <check_input_run+0x390a>
 1083c04:	4c 8b 8c 24 c8 05 00 	mov    0x5c8(%rsp),%r9
 1083c0b:	00 
 1083c0c:	41 8b 3c b9          	mov    (%r9,%rdi,4),%edi
 1083c10:	43 39 3c 81          	cmp    %edi,(%r9,%r8,4)
 1083c14:	73 04                	jae    1083c1a <check_input_run+0x390a>
 1083c16:	43 89 3c 81          	mov    %edi,(%r9,%r8,4)
 1083c1a:	49 8b 7c 24 68       	mov    0x68(%r12),%rdi
 1083c1f:	4c 8b 8c 24 a8 05 00 	mov    0x5a8(%rsp),%r9
 1083c26:	00 
 1083c27:	44 8b 44 97 04       	mov    0x4(%rdi,%rdx,4),%r8d
 1083c2c:	48 8d 7a 01          	lea    0x1(%rdx),%rdi
 1083c30:	43 89 3c 81          	mov    %edi,(%r9,%r8,4)
 1083c34:	4d 8b 4c 24 60       	mov    0x60(%r12),%r9
 1083c39:	47 8b 0c 81          	mov    (%r9,%r8,4),%r9d
 1083c3d:	44 3b 4c 24 18       	cmp    0x18(%rsp),%r9d
 1083c42:	73 16                	jae    1083c5a <check_input_run+0x394a>
 1083c44:	4c 8b 94 24 c8 05 00 	mov    0x5c8(%rsp),%r10
 1083c4b:	00 
 1083c4c:	47 8b 04 82          	mov    (%r10,%r8,4),%r8d
 1083c50:	47 39 04 8a          	cmp    %r8d,(%r10,%r9,4)
 1083c54:	73 04                	jae    1083c5a <check_input_run+0x394a>
 1083c56:	47 89 04 8a          	mov    %r8d,(%r10,%r9,4)
 1083c5a:	4d 8b 44 24 68       	mov    0x68(%r12),%r8
 1083c5f:	4c 8b 8c 24 a8 05 00 	mov    0x5a8(%rsp),%r9
 1083c66:	00 
 1083c67:	48 ff c7             	inc    %rdi
 1083c6a:	45 8b 44 90 08       	mov    0x8(%r8,%rdx,4),%r8d
 1083c6f:	43 89 3c 81          	mov    %edi,(%r9,%r8,4)
 1083c73:	4d 8b 4c 24 60       	mov    0x60(%r12),%r9
 1083c78:	47 8b 0c 81          	mov    (%r9,%r8,4),%r9d
 1083c7c:	44 3b 4c 24 18       	cmp    0x18(%rsp),%r9d
 1083c81:	73 16                	jae    1083c99 <check_input_run+0x3989>
 1083c83:	4c 8b 94 24 c8 05 00 	mov    0x5c8(%rsp),%r10
 1083c8a:	00 
 1083c8b:	47 8b 04 82          	mov    (%r10,%r8,4),%r8d
 1083c8f:	47 39 04 8a          	cmp    %r8d,(%r10,%r9,4)
 1083c93:	73 04                	jae    1083c99 <check_input_run+0x3989>
 1083c95:	47 89 04 8a          	mov    %r8d,(%r10,%r9,4)
 1083c99:	4d 8b 44 24 68       	mov    0x68(%r12),%r8
 1083c9e:	4c 8b 8c 24 a8 05 00 	mov    0x5a8(%rsp),%r9
 1083ca5:	00 
 1083ca6:	48 ff c7             	inc    %rdi
 1083ca9:	45 8b 44 90 0c       	mov    0xc(%r8,%rdx,4),%r8d
 1083cae:	43 89 3c 81          	mov    %edi,(%r9,%r8,4)
 1083cb2:	4d 8b 4c 24 60       	mov    0x60(%r12),%r9
 1083cb7:	47 8b 0c 81          	mov    (%r9,%r8,4),%r9d
 1083cbb:	44 3b 4c 24 18       	cmp    0x18(%rsp),%r9d
 1083cc0:	0f 83 0a ff ff ff    	jae    1083bd0 <check_input_run+0x38c0>
 1083cc6:	4c 8b 94 24 c8 05 00 	mov    0x5c8(%rsp),%r10
 1083ccd:	00 
 1083cce:	47 8b 04 82          	mov    (%r10,%r8,4),%r8d
 1083cd2:	47 39 04 8a          	cmp    %r8d,(%r10,%r9,4)
 1083cd6:	0f 83 f4 fe ff ff    	jae    1083bd0 <check_input_run+0x38c0>
 1083cdc:	47 89 04 8a          	mov    %r8d,(%r10,%r9,4)
 1083ce0:	e9 eb fe ff ff       	jmp    1083bd0 <check_input_run+0x38c0>
 1083ce5:	48 85 c0             	test   %rax,%rax
 1083ce8:	74 47                	je     1083d31 <check_input_run+0x3a21>
 1083cea:	48 83 c2 04          	add    $0x4,%rdx
 1083cee:	eb 08                	jmp    1083cf8 <check_input_run+0x39e8>
 1083cf0:	48 ff c2             	inc    %rdx
 1083cf3:	48 ff c8             	dec    %rax
 1083cf6:	74 39                	je     1083d31 <check_input_run+0x3a21>
 1083cf8:	49 8b 74 24 68       	mov    0x68(%r12),%rsi
 1083cfd:	48 8b bc 24 a8 05 00 	mov    0x5a8(%rsp),%rdi
 1083d04:	00 
 1083d05:	8b 34 96             	mov    (%rsi,%rdx,4),%esi
 1083d08:	89 14 b7             	mov    %edx,(%rdi,%rsi,4)
 1083d0b:	49 8b 7c 24 60       	mov    0x60(%r12),%rdi
 1083d10:	8b 3c b7             	mov    (%rdi,%rsi,4),%edi
 1083d13:	3b 7c 24 18          	cmp    0x18(%rsp),%edi
 1083d17:	73 d7                	jae    1083cf0 <check_input_run+0x39e0>
 1083d19:	4c 8b 84 24 c8 05 00 	mov    0x5c8(%rsp),%r8
 1083d20:	00 
 1083d21:	41 8b 34 b0          	mov    (%r8,%rsi,4),%esi
 1083d25:	41 39 34 b8          	cmp    %esi,(%r8,%rdi,4)
 1083d29:	73 c5                	jae    1083cf0 <check_input_run+0x39e0>
 1083d2b:	41 89 34 b8          	mov    %esi,(%r8,%rdi,4)
 1083d2f:	eb bf                	jmp    1083cf0 <check_input_run+0x39e0>
 1083d31:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
 1083d36:	48 89 c2             	mov    %rax,%rdx
 1083d39:	48 83 e2 03          	and    $0x3,%rdx
 1083d3d:	0f 84 9e 00 00 00    	je     1083de1 <check_input_run+0x3ad1>
 1083d43:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
 1083d48:	48 be 00 00 00 20 04 	movabs $0x10380420000000,%rsi
 1083d4f:	38 10 00 
 1083d52:	eb 2d                	jmp    1083d81 <check_input_run+0x3a71>
 1083d54:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
 1083d5b:	00 00 00 00 00 
 1083d60:	4c 8b 8c 24 c8 04 00 	mov    0x4c8(%rsp),%r9
 1083d67:	00 
 1083d68:	47 0f b6 14 01       	movzbl (%r9,%r8,1),%r10d
 1083d6d:	4c 8b 84 24 c8 04 00 	mov    0x4c8(%rsp),%r8
 1083d74:	00 
 1083d75:	48 ff c8             	dec    %rax
 1083d78:	48 ff ca             	dec    %rdx
 1083d7b:	45 88 14 38          	mov    %r10b,(%r8,%rdi,1)
 1083d7f:	74 60                	je     1083de1 <check_input_run+0x3ad1>
 1083d81:	49 8b 7c 24 68       	mov    0x68(%r12),%rdi
 1083d86:	4d 8b 4c 24 50       	mov    0x50(%r12),%r9
 1083d8b:	4d 8b 44 24 60       	mov    0x60(%r12),%r8
 1083d90:	8b 7c 87 fc          	mov    -0x4(%rdi,%rax,4),%edi
 1083d94:	45 0f b6 1c 39       	movzbl (%r9,%rdi,1),%r11d
 1083d99:	45 8b 04 b8          	mov    (%r8,%rdi,4),%r8d
 1083d9d:	41 83 fb 1c          	cmp    $0x1c,%r11d
 1083da1:	41 0f 94 c2          	sete   %r10b
 1083da5:	44 3b 44 24 18       	cmp    0x18(%rsp),%r8d
 1083daa:	0f 92 c3             	setb   %bl
 1083dad:	41 84 da             	test   %bl,%r10b
 1083db0:	75 ae                	jne    1083d60 <check_input_run+0x3a50>
 1083db2:	41 83 c3 e2          	add    $0xffffffe2,%r11d
 1083db6:	41 83 fb 34          	cmp    $0x34,%r11d
 1083dba:	77 20                	ja     1083ddc <check_input_run+0x3acc>
 1083dbc:	41 b2 01             	mov    $0x1,%r10b
 1083dbf:	4c 0f a3 de          	bt     %r11,%rsi
 1083dc3:	72 a8                	jb     1083d6d <check_input_run+0x3a5d>
 1083dc5:	4d 85 db             	test   %r11,%r11
 1083dc8:	75 12                	jne    1083ddc <check_input_run+0x3acc>
 1083dca:	44 3b 44 24 18       	cmp    0x18(%rsp),%r8d
 1083dcf:	73 0b                	jae    1083ddc <check_input_run+0x3acc>
 1083dd1:	43 80 3c 01 4a       	cmpb   $0x4a,(%r9,%r8,1)
 1083dd6:	41 0f 94 c2          	sete   %r10b
 1083dda:	eb 91                	jmp    1083d6d <check_input_run+0x3a5d>
 1083ddc:	45 31 d2             	xor    %r10d,%r10d
 1083ddf:	eb 8c                	jmp    1083d6d <check_input_run+0x3a5d>
 1083de1:	48 83 f9 03          	cmp    $0x3,%rcx
 1083de5:	0f 83 95 02 00 00    	jae    1084080 <check_input_run+0x3d70>
 1083deb:	41 8b 44 24 48       	mov    0x48(%r12),%eax
 1083df0:	48 85 c0             	test   %rax,%rax
 1083df3:	0f 84 64 16 00 00    	je     108545d <check_input_run+0x514d>
 1083df9:	48 8b 74 24 28       	mov    0x28(%rsp),%rsi
 1083dfe:	4c 8b 7e 08          	mov    0x8(%rsi),%r15
 1083e02:	48 8b 4e 10          	mov    0x10(%rsi),%rcx
 1083e06:	4c 29 f9             	sub    %r15,%rcx
 1083e09:	0f 92 c2             	setb   %dl
 1083e0c:	48 39 c1             	cmp    %rax,%rcx
 1083e0f:	0f 92 c1             	setb   %cl
 1083e12:	08 d1                	or     %dl,%cl
 1083e14:	80 f9 01             	cmp    $0x1,%cl
 1083e17:	0f 84 34 16 00 00    	je     1085451 <check_input_run+0x5141>
 1083e1d:	4c 01 f8             	add    %r15,%rax
 1083e20:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
 1083e25:	4c 89 f9             	mov    %r15,%rcx
 1083e28:	48 89 46 08          	mov    %rax,0x8(%rsi)
 1083e2c:	48 8b 06             	mov    (%rsi),%rax
 1083e2f:	48 01 c1             	add    %rax,%rcx
 1083e32:	0f 94 c1             	sete   %cl
 1083e35:	08 8a bd 03 00 00    	or     %cl,0x3bd(%rdx)
 1083e3b:	49 01 c7             	add    %rax,%r15
 1083e3e:	0f 84 19 16 00 00    	je     108545d <check_input_run+0x514d>
 1083e44:	41 8b 54 24 48       	mov    0x48(%r12),%edx
 1083e49:	4c 89 ff             	mov    %r15,%rdi
 1083e4c:	31 f6                	xor    %esi,%esi
 1083e4e:	e8 2d b1 70 ff       	call   78ef80 <memset@plt>
 1083e53:	48 8d bc 24 60 02 00 	lea    0x260(%rsp),%rdi
 1083e5a:	00 
 1083e5b:	4c 89 fe             	mov    %r15,%rsi
 1083e5e:	e8 9d 5f ff ff       	call   1079e00 <check_input_diagnostic_pragmas>
 1083e63:	84 c0                	test   %al,%al
 1083e65:	0f 84 e6 15 00 00    	je     1085451 <check_input_run+0x5141>
 1083e6b:	48 8d bc 24 60 02 00 	lea    0x260(%rsp),%rdi
 1083e72:	00 
 1083e73:	4c 89 fe             	mov    %r15,%rsi
 1083e76:	e8 75 8c 00 00       	call   108caf0 <check_input_nonnull_pragmas>
 1083e7b:	84 c0                	test   %al,%al
 1083e7d:	0f 84 ce 15 00 00    	je     1085451 <check_input_run+0x5141>
 1083e83:	48 8b 8c 24 88 02 00 	mov    0x288(%rsp),%rcx
 1083e8a:	00 
 1083e8b:	48 8b 84 24 68 02 00 	mov    0x268(%rsp),%rax
 1083e92:	00 
 1083e93:	4c 8b 49 08          	mov    0x8(%rcx),%r9
 1083e97:	8b 48 48             	mov    0x48(%rax),%ecx
 1083e9a:	48 89 4c 24 38       	mov    %rcx,0x38(%rsp)
 1083e9f:	48 85 c9             	test   %rcx,%rcx
 1083ea2:	0f 84 49 74 00 00    	je     108b2f1 <check_input_run+0xafe1>
 1083ea8:	48 8b 8c 24 80 02 00 	mov    0x280(%rsp),%rcx
 1083eaf:	00 
 1083eb0:	44 8b 40 30          	mov    0x30(%rax),%r8d
 1083eb4:	48 8b 50 38          	mov    0x38(%rax),%rdx
 1083eb8:	48 8b 78 40          	mov    0x40(%rax),%rdi
 1083ebc:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
 1083ec1:	4c 89 4c 24 40       	mov    %r9,0x40(%rsp)
 1083ec6:	45 31 f6             	xor    %r14d,%r14d
 1083ec9:	45 31 c9             	xor    %r9d,%r9d
 1083ecc:	31 f6                	xor    %esi,%esi
 1083ece:	45 31 d2             	xor    %r10d,%r10d
 1083ed1:	48 89 4c 24 60       	mov    %rcx,0x60(%rsp)
 1083ed6:	48 8b 49 08          	mov    0x8(%rcx),%rcx
 1083eda:	4c 89 44 24 68       	mov    %r8,0x68(%rsp)
 1083edf:	48 89 8c 24 70 01 00 	mov    %rcx,0x170(%rsp)
 1083ee6:	00 
 1083ee7:	48 8b 8c 24 70 02 00 	mov    0x270(%rsp),%rcx
 1083eee:	00 
 1083eef:	90                   	nop
 1083ef0:	42 8b 1c 8a          	mov    (%rdx,%r9,4),%ebx
 1083ef4:	44 39 d3             	cmp    %r10d,%ebx
 1083ef7:	72 43                	jb     1083f3c <check_input_run+0x3c2c>
 1083ef9:	44 8b a9 30 08 00 00 	mov    0x830(%rcx),%r13d
 1083f00:	44 39 eb             	cmp    %r13d,%ebx
 1083f03:	73 37                	jae    1083f3c <check_input_run+0x3c2c>
 1083f05:	46 8b 1c 8f          	mov    (%rdi,%r9,4),%r11d
 1083f09:	45 39 f3             	cmp    %r14d,%r11d
 1083f0c:	72 2e                	jb     1083f3c <check_input_run+0x3c2c>
 1083f0e:	45 39 c3             	cmp    %r8d,%r11d
 1083f11:	77 29                	ja     1083f3c <check_input_run+0x3c2c>
 1083f13:	4c 8b a1 10 08 00 00 	mov    0x810(%rcx),%r12
 1083f1a:	41 80 3c 1c 3c       	cmpb   $0x3c,(%r12,%rbx,1)
 1083f1f:	75 16                	jne    1083f37 <check_input_run+0x3c27>
 1083f21:	48 8b a9 18 08 00 00 	mov    0x818(%rcx),%rbp
 1083f28:	f6 44 1d 00 02       	testb  $0x2,0x0(%rbp,%rbx,1)
 1083f2d:	74 08                	je     1083f37 <check_input_run+0x3c27>
 1083f2f:	49 ff cd             	dec    %r13
 1083f32:	49 39 dd             	cmp    %rbx,%r13
 1083f35:	75 1c                	jne    1083f53 <check_input_run+0x3c43>
 1083f37:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
 1083f3c:	45 89 f3             	mov    %r14d,%r11d
 1083f3f:	31 db                	xor    %ebx,%ebx
 1083f41:	01 de                	add    %ebx,%esi
 1083f43:	49 ff c1             	inc    %r9
 1083f46:	45 89 de             	mov    %r11d,%r14d
 1083f49:	49 39 c1             	cmp    %rax,%r9
 1083f4c:	75 a2                	jne    1083ef0 <check_input_run+0x3be0>
 1083f4e:	e9 2c 05 00 00       	jmp    108447f <check_input_run+0x416f>
 1083f53:	48 ff c5             	inc    %rbp
 1083f56:	4d 8d 44 24 01       	lea    0x1(%r12),%r8
 1083f5b:	31 c0                	xor    %eax,%eax
 1083f5d:	41 80 3c 18 fc       	cmpb   $0xfc,(%r8,%rbx,1)
 1083f62:	74 2c                	je     1083f90 <check_input_run+0x3c80>
 1083f64:	f6 44 1d 00 02       	testb  $0x2,0x0(%rbp,%rbx,1)
 1083f69:	75 11                	jne    1083f7c <check_input_run+0x3c6c>
 1083f6b:	48 ff c8             	dec    %rax
 1083f6e:	49 ff cd             	dec    %r13
 1083f71:	48 ff c5             	inc    %rbp
 1083f74:	49 ff c0             	inc    %r8
 1083f77:	4c 39 eb             	cmp    %r13,%rbx
 1083f7a:	75 e1                	jne    1083f5d <check_input_run+0x3c4d>
 1083f7c:	45 89 f3             	mov    %r14d,%r11d
 1083f7f:	31 db                	xor    %ebx,%ebx
 1083f81:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
 1083f86:	4c 8b 44 24 68       	mov    0x68(%rsp),%r8
 1083f8b:	e9 d7 00 00 00       	jmp    1084067 <check_input_run+0x3d57>
 1083f90:	4c 8b 44 24 68       	mov    0x68(%rsp),%r8
 1083f95:	49 89 de             	mov    %rbx,%r14
 1083f98:	49 29 c6             	sub    %rax,%r14
 1083f9b:	4d 8d 56 02          	lea    0x2(%r14),%r10
 1083f9f:	44 39 f3             	cmp    %r14d,%ebx
 1083fa2:	0f 83 b8 00 00 00    	jae    1084060 <check_input_run+0x3d50>
 1083fa8:	41 80 7c 1c 01 01    	cmpb   $0x1,0x1(%r12,%rbx,1)
 1083fae:	0f 85 ac 00 00 00    	jne    1084060 <check_input_run+0x3d50>
 1083fb4:	48 8b 81 70 02 00 00 	mov    0x270(%rcx),%rax
 1083fbb:	4c 8b a9 20 08 00 00 	mov    0x820(%rcx),%r13
 1083fc2:	41 8b 6c 9d 04       	mov    0x4(%r13,%rbx,4),%ebp
 1083fc7:	4c 8b 40 10          	mov    0x10(%rax),%r8
 1083fcb:	41 83 7c e8 04 06    	cmpl   $0x6,0x4(%r8,%rbp,8)
 1083fd1:	75 ac                	jne    1083f7f <check_input_run+0x3c6f>
 1083fd3:	4c 89 ac 24 98 00 00 	mov    %r13,0x98(%rsp)
 1083fda:	00 
 1083fdb:	4c 8b 68 40          	mov    0x40(%rax),%r13
 1083fdf:	41 8b 2c e8          	mov    (%r8,%rbp,8),%ebp
 1083fe3:	4c 89 84 24 30 01 00 	mov    %r8,0x130(%rsp)
 1083fea:	00 
 1083feb:	41 b8 70 72 61 67    	mov    $0x67617270,%r8d
 1083ff1:	41 8b 44 2d 00       	mov    0x0(%r13,%rbp,1),%eax
 1083ff6:	41 0f b7 6c 2d 04    	movzwl 0x4(%r13,%rbp,1),%ebp
 1083ffc:	44 31 c0             	xor    %r8d,%eax
 1083fff:	81 f5 6d 61 00 00    	xor    $0x616d,%ebp
 1084005:	09 c5                	or     %eax,%ebp
 1084007:	0f 85 72 ff ff ff    	jne    1083f7f <check_input_run+0x3c6f>
 108400d:	4d 89 e8             	mov    %r13,%r8
 1084010:	4c 8b ac 24 30 01 00 	mov    0x130(%rsp),%r13
 1084017:	00 
 1084018:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
 108401d:	83 c3 02             	add    $0x2,%ebx
 1084020:	44 39 f3             	cmp    %r14d,%ebx
 1084023:	77 4c                	ja     1084071 <check_input_run+0x3d61>
 1084025:	89 db                	mov    %ebx,%ebx
 1084027:	41 80 3c 1c 01       	cmpb   $0x1,(%r12,%rbx,1)
 108402c:	75 43                	jne    1084071 <check_input_run+0x3d61>
 108402e:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
 1084035:	00 
 1084036:	4d 89 c6             	mov    %r8,%r14
 1084039:	44 8b 04 98          	mov    (%rax,%rbx,4),%r8d
 108403d:	43 83 7c c5 04 04    	cmpl   $0x4,0x4(%r13,%r8,8)
 1084043:	0f 85 36 ff ff ff    	jne    1083f7f <check_input_run+0x3c6f>
 1084049:	43 8b 44 c5 00       	mov    0x0(%r13,%r8,8),%eax
 108404e:	31 db                	xor    %ebx,%ebx
 1084050:	41 81 3c 06 70 61 63 	cmpl   $0x6b636170,(%r14,%rax,1)
 1084057:	6b 
 1084058:	0f 94 c3             	sete   %bl
 108405b:	e9 21 ff ff ff       	jmp    1083f81 <check_input_run+0x3c71>
 1084060:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
 1084065:	31 db                	xor    %ebx,%ebx
 1084067:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
 108406c:	e9 d0 fe ff ff       	jmp    1083f41 <check_input_run+0x3c31>
 1084071:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
 1084076:	4c 8b 44 24 68       	mov    0x68(%rsp),%r8
 108407b:	e9 bf fe ff ff       	jmp    1083f3f <check_input_run+0x3c2f>
 1084080:	48 b9 00 00 00 20 04 	movabs $0x10380420000000,%rcx
 1084087:	38 10 00 
 108408a:	eb 27                	jmp    10840b3 <check_input_run+0x3da3>
 108408c:	0f 1f 40 00          	nopl   0x0(%rax)
 1084090:	48 8b bc 24 c8 04 00 	mov    0x4c8(%rsp),%rdi
 1084097:	00 
 1084098:	44 0f b6 04 37       	movzbl (%rdi,%rsi,1),%r8d
 108409d:	48 8b b4 24 c8 04 00 	mov    0x4c8(%rsp),%rsi
 10840a4:	00 
 10840a5:	48 83 c0 fc          	add    $0xfffffffffffffffc,%rax
 10840a9:	44 88 04 16          	mov    %r8b,(%rsi,%rdx,1)
 10840ad:	0f 84 38 fd ff ff    	je     1083deb <check_input_run+0x3adb>
 10840b3:	49 8b 54 24 68       	mov    0x68(%r12),%rdx
 10840b8:	49 8b 7c 24 50       	mov    0x50(%r12),%rdi
 10840bd:	49 8b 74 24 60       	mov    0x60(%r12),%rsi
 10840c2:	8b 54 82 fc          	mov    -0x4(%rdx,%rax,4),%edx
 10840c6:	44 0f b6 04 17       	movzbl (%rdi,%rdx,1),%r8d
 10840cb:	8b 34 96             	mov    (%rsi,%rdx,4),%esi
 10840ce:	41 83 f8 1c          	cmp    $0x1c,%r8d
 10840d2:	41 0f 94 c1          	sete   %r9b
 10840d6:	3b 74 24 18          	cmp    0x18(%rsp),%esi
 10840da:	41 0f 92 c2          	setb   %r10b
 10840de:	45 20 ca             	and    %r9b,%r10b
 10840e1:	41 80 fa 01          	cmp    $0x1,%r10b
 10840e5:	75 19                	jne    1084100 <check_input_run+0x3df0>
 10840e7:	48 8b bc 24 c8 04 00 	mov    0x4c8(%rsp),%rdi
 10840ee:	00 
 10840ef:	44 0f b6 0c 37       	movzbl (%rdi,%rsi,1),%r9d
 10840f4:	eb 25                	jmp    108411b <check_input_run+0x3e0b>
 10840f6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 10840fd:	00 00 00 
 1084100:	41 83 c0 e2          	add    $0xffffffe2,%r8d
 1084104:	41 83 f8 34          	cmp    $0x34,%r8d
 1084108:	0f 87 ac 01 00 00    	ja     10842ba <check_input_run+0x3faa>
 108410e:	41 b1 01             	mov    $0x1,%r9b
 1084111:	4c 0f a3 c1          	bt     %r8,%rcx
 1084115:	0f 83 4f 01 00 00    	jae    108426a <check_input_run+0x3f5a>
 108411b:	48 8b b4 24 c8 04 00 	mov    0x4c8(%rsp),%rsi
 1084122:	00 
 1084123:	44 88 0c 16          	mov    %r9b,(%rsi,%rdx,1)
 1084127:	49 8b 54 24 68       	mov    0x68(%r12),%rdx
 108412c:	49 8b 7c 24 50       	mov    0x50(%r12),%rdi
 1084131:	49 8b 74 24 60       	mov    0x60(%r12),%rsi
 1084136:	8b 54 82 f8          	mov    -0x8(%rdx,%rax,4),%edx
 108413a:	44 0f b6 0c 17       	movzbl (%rdi,%rdx,1),%r9d
 108413f:	8b 34 96             	mov    (%rsi,%rdx,4),%esi
 1084142:	41 83 f9 1c          	cmp    $0x1c,%r9d
 1084146:	41 0f 94 c0          	sete   %r8b
 108414a:	3b 74 24 18          	cmp    0x18(%rsp),%esi
 108414e:	41 0f 92 c2          	setb   %r10b
 1084152:	45 84 d0             	test   %r10b,%r8b
 1084155:	74 19                	je     1084170 <check_input_run+0x3e60>
 1084157:	48 8b bc 24 c8 04 00 	mov    0x4c8(%rsp),%rdi
 108415e:	00 
 108415f:	44 0f b6 04 37       	movzbl (%rdi,%rsi,1),%r8d
 1084164:	eb 25                	jmp    108418b <check_input_run+0x3e7b>
 1084166:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 108416d:	00 00 00 
 1084170:	41 83 c1 e2          	add    $0xffffffe2,%r9d
 1084174:	41 83 f9 34          	cmp    $0x34,%r9d
 1084178:	0f 87 44 01 00 00    	ja     10842c2 <check_input_run+0x3fb2>
 108417e:	41 b0 01             	mov    $0x1,%r8b
 1084181:	4c 0f a3 c9          	bt     %r9,%rcx
 1084185:	0f 83 f7 00 00 00    	jae    1084282 <check_input_run+0x3f72>
 108418b:	48 8b b4 24 c8 04 00 	mov    0x4c8(%rsp),%rsi
 1084192:	00 
 1084193:	44 88 04 16          	mov    %r8b,(%rsi,%rdx,1)
 1084197:	49 8b 54 24 68       	mov    0x68(%r12),%rdx
 108419c:	49 8b 7c 24 50       	mov    0x50(%r12),%rdi
 10841a1:	49 8b 74 24 60       	mov    0x60(%r12),%rsi
 10841a6:	8b 54 82 f4          	mov    -0xc(%rdx,%rax,4),%edx
 10841aa:	44 0f b6 0c 17       	movzbl (%rdi,%rdx,1),%r9d
 10841af:	8b 34 96             	mov    (%rsi,%rdx,4),%esi
 10841b2:	41 83 f9 1c          	cmp    $0x1c,%r9d
 10841b6:	41 0f 94 c0          	sete   %r8b
 10841ba:	3b 74 24 18          	cmp    0x18(%rsp),%esi
 10841be:	41 0f 92 c2          	setb   %r10b
 10841c2:	45 84 d0             	test   %r10b,%r8b
 10841c5:	74 19                	je     10841e0 <check_input_run+0x3ed0>
 10841c7:	48 8b bc 24 c8 04 00 	mov    0x4c8(%rsp),%rdi
 10841ce:	00 
 10841cf:	44 0f b6 04 37       	movzbl (%rdi,%rsi,1),%r8d
 10841d4:	eb 25                	jmp    10841fb <check_input_run+0x3eeb>
 10841d6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 10841dd:	00 00 00 
 10841e0:	41 83 c1 e2          	add    $0xffffffe2,%r9d
 10841e4:	41 83 f9 34          	cmp    $0x34,%r9d
 10841e8:	0f 87 dc 00 00 00    	ja     10842ca <check_input_run+0x3fba>
 10841ee:	41 b0 01             	mov    $0x1,%r8b
 10841f1:	4c 0f a3 c9          	bt     %r9,%rcx
 10841f5:	0f 83 9f 00 00 00    	jae    108429a <check_input_run+0x3f8a>
 10841fb:	48 8b b4 24 c8 04 00 	mov    0x4c8(%rsp),%rsi
 1084202:	00 
 1084203:	44 88 04 16          	mov    %r8b,(%rsi,%rdx,1)
 1084207:	49 8b 54 24 68       	mov    0x68(%r12),%rdx
 108420c:	49 8b 7c 24 50       	mov    0x50(%r12),%rdi
 1084211:	49 8b 74 24 60       	mov    0x60(%r12),%rsi
 1084216:	8b 54 82 f0          	mov    -0x10(%rdx,%rax,4),%edx
 108421a:	44 0f b6 0c 17       	movzbl (%rdi,%rdx,1),%r9d
 108421f:	8b 34 96             	mov    (%rsi,%rdx,4),%esi
 1084222:	41 83 f9 1c          	cmp    $0x1c,%r9d
 1084226:	41 0f 94 c0          	sete   %r8b
 108422a:	3b 74 24 18          	cmp    0x18(%rsp),%esi
 108422e:	41 0f 92 c2          	setb   %r10b
 1084232:	45 84 d0             	test   %r10b,%r8b
 1084235:	0f 85 55 fe ff ff    	jne    1084090 <check_input_run+0x3d80>
 108423b:	41 83 c1 e2          	add    $0xffffffe2,%r9d
 108423f:	41 83 f9 34          	cmp    $0x34,%r9d
 1084243:	77 6d                	ja     10842b2 <check_input_run+0x3fa2>
 1084245:	41 b0 01             	mov    $0x1,%r8b
 1084248:	4c 0f a3 c9          	bt     %r9,%rcx
 108424c:	0f 82 4b fe ff ff    	jb     108409d <check_input_run+0x3d8d>
 1084252:	4d 85 c9             	test   %r9,%r9
 1084255:	75 5b                	jne    10842b2 <check_input_run+0x3fa2>
 1084257:	3b 74 24 18          	cmp    0x18(%rsp),%esi
 108425b:	73 55                	jae    10842b2 <check_input_run+0x3fa2>
 108425d:	80 3c 37 4a          	cmpb   $0x4a,(%rdi,%rsi,1)
 1084261:	41 0f 94 c0          	sete   %r8b
 1084265:	e9 33 fe ff ff       	jmp    108409d <check_input_run+0x3d8d>
 108426a:	4d 85 c0             	test   %r8,%r8
 108426d:	75 4b                	jne    10842ba <check_input_run+0x3faa>
 108426f:	3b 74 24 18          	cmp    0x18(%rsp),%esi
 1084273:	73 45                	jae    10842ba <check_input_run+0x3faa>
 1084275:	80 3c 37 4a          	cmpb   $0x4a,(%rdi,%rsi,1)
 1084279:	41 0f 94 c1          	sete   %r9b
 108427d:	e9 99 fe ff ff       	jmp    108411b <check_input_run+0x3e0b>
 1084282:	4d 85 c9             	test   %r9,%r9
 1084285:	75 3b                	jne    10842c2 <check_input_run+0x3fb2>
 1084287:	3b 74 24 18          	cmp    0x18(%rsp),%esi
 108428b:	73 35                	jae    10842c2 <check_input_run+0x3fb2>
 108428d:	80 3c 37 4a          	cmpb   $0x4a,(%rdi,%rsi,1)
 1084291:	41 0f 94 c0          	sete   %r8b
 1084295:	e9 f1 fe ff ff       	jmp    108418b <check_input_run+0x3e7b>
 108429a:	4d 85 c9             	test   %r9,%r9
 108429d:	75 2b                	jne    10842ca <check_input_run+0x3fba>
 108429f:	3b 74 24 18          	cmp    0x18(%rsp),%esi
 10842a3:	73 25                	jae    10842ca <check_input_run+0x3fba>
 10842a5:	80 3c 37 4a          	cmpb   $0x4a,(%rdi,%rsi,1)
 10842a9:	41 0f 94 c0          	sete   %r8b
 10842ad:	e9 49 ff ff ff       	jmp    10841fb <check_input_run+0x3eeb>
 10842b2:	45 31 c0             	xor    %r8d,%r8d
 10842b5:	e9 e3 fd ff ff       	jmp    108409d <check_input_run+0x3d8d>
 10842ba:	45 31 c9             	xor    %r9d,%r9d
 10842bd:	e9 59 fe ff ff       	jmp    108411b <check_input_run+0x3e0b>
 10842c2:	45 31 c0             	xor    %r8d,%r8d
 10842c5:	e9 c1 fe ff ff       	jmp    108418b <check_input_run+0x3e7b>
 10842ca:	45 31 c0             	xor    %r8d,%r8d
 10842cd:	e9 29 ff ff ff       	jmp    10841fb <check_input_run+0x3eeb>
 10842d2:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
 10842d7:	48 89 d6             	mov    %rdx,%rsi
 10842da:	48 29 c6             	sub    %rax,%rsi
 10842dd:	48 8b 49 10          	mov    0x10(%rcx),%rcx
 10842e1:	48 89 cf             	mov    %rcx,%rdi
 10842e4:	48 29 f7             	sub    %rsi,%rdi
 10842e7:	0f 82 a2 e7 ff ff    	jb     1082a8f <check_input_run+0x277f>
 10842ed:	48 39 fb             	cmp    %rdi,%rbx
 10842f0:	0f 87 99 e7 ff ff    	ja     1082a8f <check_input_run+0x277f>
 10842f6:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
 10842fb:	48 01 de             	add    %rbx,%rsi
 10842fe:	48 89 77 08          	mov    %rsi,0x8(%rdi)
 1084302:	48 89 94 24 18 04 00 	mov    %rdx,0x418(%rsp)
 1084309:	00 
 108430a:	48 85 d2             	test   %rdx,%rdx
 108430d:	0f 84 88 e7 ff ff    	je     1082a9b <check_input_run+0x278b>
 1084313:	48 8d 34 1a          	lea    (%rdx,%rbx,1),%rsi
 1084317:	48 8d 54 1a 3f       	lea    0x3f(%rdx,%rbx,1),%rdx
 108431c:	48 83 e2 c0          	and    $0xffffffffffffffc0,%rdx
 1084320:	48 39 f2             	cmp    %rsi,%rdx
 1084323:	0f 82 72 e7 ff ff    	jb     1082a9b <check_input_run+0x278b>
 1084329:	48 89 d6             	mov    %rdx,%rsi
 108432c:	48 29 c6             	sub    %rax,%rsi
 108432f:	49 89 c8             	mov    %rcx,%r8
 1084332:	49 29 f0             	sub    %rsi,%r8
 1084335:	0f 82 60 e7 ff ff    	jb     1082a9b <check_input_run+0x278b>
 108433b:	49 8b bf 70 02 00 00 	mov    0x270(%r15),%rdi
 1084342:	8b 7f 68             	mov    0x68(%rdi),%edi
 1084345:	48 c1 e7 02          	shl    $0x2,%rdi
 1084349:	4c 39 c7             	cmp    %r8,%rdi
 108434c:	0f 87 49 e7 ff ff    	ja     1082a9b <check_input_run+0x278b>
 1084352:	4c 8b 44 24 28       	mov    0x28(%rsp),%r8
 1084357:	48 01 fe             	add    %rdi,%rsi
 108435a:	49 89 70 08          	mov    %rsi,0x8(%r8)
 108435e:	48 89 94 24 50 05 00 	mov    %rdx,0x550(%rsp)
 1084365:	00 
 1084366:	48 85 d2             	test   %rdx,%rdx
 1084369:	0f 84 38 e7 ff ff    	je     1082aa7 <check_input_run+0x2797>
 108436f:	48 8d 34 3a          	lea    (%rdx,%rdi,1),%rsi
 1084373:	48 8d 54 3a 3c       	lea    0x3c(%rdx,%rdi,1),%rdx
 1084378:	40 b7 01             	mov    $0x1,%dil
 108437b:	48 89 bc 24 f0 00 00 	mov    %rdi,0xf0(%rsp)
 1084382:	00 
 1084383:	48 83 e2 c0          	and    $0xffffffffffffffc0,%rdx
 1084387:	48 39 f2             	cmp    %rsi,%rdx
 108438a:	0f 82 23 e7 ff ff    	jb     1082ab3 <check_input_run+0x27a3>
 1084390:	48 89 d6             	mov    %rdx,%rsi
 1084393:	48 29 c6             	sub    %rax,%rsi
 1084396:	31 ff                	xor    %edi,%edi
 1084398:	48 29 f1             	sub    %rsi,%rcx
 108439b:	0f 82 14 e7 ff ff    	jb     1082ab5 <check_input_run+0x27a5>
 10843a1:	49 8b 87 70 02 00 00 	mov    0x270(%r15),%rax
 10843a8:	8b 40 68             	mov    0x68(%rax),%eax
 10843ab:	48 01 c0             	add    %rax,%rax
 10843ae:	48 39 c8             	cmp    %rcx,%rax
 10843b1:	0f 87 fe e6 ff ff    	ja     1082ab5 <check_input_run+0x27a5>
 10843b7:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
 10843bc:	48 01 c6             	add    %rax,%rsi
 10843bf:	48 89 d7             	mov    %rdx,%rdi
 10843c2:	48 89 71 08          	mov    %rsi,0x8(%rcx)
 10843c6:	e9 ea e6 ff ff       	jmp    1082ab5 <check_input_run+0x27a5>
 10843cb:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
 10843d0:	48 8b 84 24 08 01 00 	mov    0x108(%rsp),%rax
 10843d7:	00 
 10843d8:	4c 8b 74 24 10       	mov    0x10(%rsp),%r14
 10843dd:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
 10843e2:	89 87 34 02 00 00    	mov    %eax,0x234(%rdi)
 10843e8:	48 8b 04 24          	mov    (%rsp),%rax
 10843ec:	48 8b 10             	mov    (%rax),%rdx
 10843ef:	48 8b 48 08          	mov    0x8(%rax),%rcx
 10843f3:	48 8d 44 11 03       	lea    0x3(%rcx,%rdx,1),%rax
 10843f8:	48 01 d1             	add    %rdx,%rcx
 10843fb:	48 83 e0 fc          	and    $0xfffffffffffffffc,%rax
 10843ff:	48 39 c8             	cmp    %rcx,%rax
 1084402:	0f 82 18 c7 ff ff    	jb     1080b20 <check_input_run+0x810>
 1084408:	48 89 c1             	mov    %rax,%rcx
 108440b:	48 29 d1             	sub    %rdx,%rcx
 108440e:	48 8b 14 24          	mov    (%rsp),%rdx
 1084412:	48 8b 52 10          	mov    0x10(%rdx),%rdx
 1084416:	48 29 ca             	sub    %rcx,%rdx
 1084419:	0f 82 01 c7 ff ff    	jb     1080b20 <check_input_run+0x810>
 108441f:	8b b4 24 08 01 00 00 	mov    0x108(%rsp),%esi
 1084426:	48 c1 e6 02          	shl    $0x2,%rsi
 108442a:	48 8d 34 76          	lea    (%rsi,%rsi,2),%rsi
 108442e:	48 39 d6             	cmp    %rdx,%rsi
 1084431:	0f 87 e9 c6 ff ff    	ja     1080b20 <check_input_run+0x810>
 1084437:	48 01 f1             	add    %rsi,%rcx
 108443a:	48 8b 34 24          	mov    (%rsp),%rsi
 108443e:	4c 8d 8f 28 02 00 00 	lea    0x228(%rdi),%r9
 1084445:	48 89 4e 08          	mov    %rcx,0x8(%rsi)
 1084449:	48 89 87 28 02 00 00 	mov    %rax,0x228(%rdi)
 1084450:	48 85 c0             	test   %rax,%rax
 1084453:	0f 84 dd c6 ff ff    	je     1080b36 <check_input_run+0x826>
 1084459:	48 8b 06             	mov    (%rsi),%rax
 108445c:	48 8b 56 08          	mov    0x8(%rsi),%rdx
 1084460:	48 8d 4c 02 03       	lea    0x3(%rdx,%rax,1),%rcx
 1084465:	48 01 c2             	add    %rax,%rdx
 1084468:	48 83 e1 fc          	and    $0xfffffffffffffffc,%rcx
 108446c:	48 39 d1             	cmp    %rdx,%rcx
 108446f:	0f 83 dd 0d 00 00    	jae    1085252 <check_input_run+0x4f42>
 1084475:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
 108447a:	e9 b7 c6 ff ff       	jmp    1080b36 <check_input_run+0x826>
 108447f:	4c 8b 4c 24 40       	mov    0x40(%rsp),%r9
 1084484:	85 f6                	test   %esi,%esi
 1084486:	0f 84 65 6e 00 00    	je     108b2f1 <check_input_run+0xafe1>
 108448c:	89 f2                	mov    %esi,%edx
 108448e:	48 8d 04 12          	lea    (%rdx,%rdx,1),%rax
 1084492:	b9 01 00 00 00       	mov    $0x1,%ecx
 1084497:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
 108449e:	00 00 
 10844a0:	49 89 ce             	mov    %rcx,%r14
 10844a3:	48 01 c9             	add    %rcx,%rcx
 10844a6:	49 39 c6             	cmp    %rax,%r14
 10844a9:	76 f5                	jbe    10844a0 <check_input_run+0x4190>
 10844ab:	4c 8b 44 24 60       	mov    0x60(%rsp),%r8
 10844b0:	48 8b 8c 24 70 01 00 	mov    0x170(%rsp),%rcx
 10844b7:	00 
 10844b8:	49 8b 30             	mov    (%r8),%rsi
 10844bb:	4c 8d 54 31 07       	lea    0x7(%rcx,%rsi,1),%r10
 10844c0:	48 8d 04 31          	lea    (%rcx,%rsi,1),%rax
 10844c4:	b1 01                	mov    $0x1,%cl
 10844c6:	49 83 e2 f8          	and    $0xfffffffffffffff8,%r10
 10844ca:	49 39 c2             	cmp    %rax,%r10
 10844cd:	72 56                	jb     1084525 <check_input_run+0x4215>
 10844cf:	4c 89 d0             	mov    %r10,%rax
 10844d2:	48 29 f0             	sub    %rsi,%rax
 10844d5:	49 8b 70 10          	mov    0x10(%r8),%rsi
 10844d9:	48 29 c6             	sub    %rax,%rsi
 10844dc:	40 0f 92 c7          	setb   %dil
 10844e0:	48 83 fe 18          	cmp    $0x18,%rsi
 10844e4:	40 0f 92 c6          	setb   %sil
 10844e8:	40 08 fe             	or     %dil,%sil
 10844eb:	75 38                	jne    1084525 <check_input_run+0x4215>
 10844ed:	48 83 c0 18          	add    $0x18,%rax
 10844f1:	49 89 40 08          	mov    %rax,0x8(%r8)
 10844f5:	4d 85 d2             	test   %r10,%r10
 10844f8:	74 2b                	je     1084525 <check_input_run+0x4215>
 10844fa:	48 8b 84 24 80 02 00 	mov    0x280(%rsp),%rax
 1084501:	00 
 1084502:	48 8b 38             	mov    (%rax),%rdi
 1084505:	48 8b 70 08          	mov    0x8(%rax),%rsi
 1084509:	48 8d 5c 3e 03       	lea    0x3(%rsi,%rdi,1),%rbx
 108450e:	48 01 fe             	add    %rdi,%rsi
 1084511:	48 83 e3 fc          	and    $0xfffffffffffffffc,%rbx
 1084515:	48 39 f3             	cmp    %rsi,%rbx
 1084518:	0f 83 4e 0e 00 00    	jae    108536c <check_input_run+0x505c>
 108451e:	45 31 ed             	xor    %r13d,%r13d
 1084521:	31 db                	xor    %ebx,%ebx
 1084523:	eb 08                	jmp    108452d <check_input_run+0x421d>
 1084525:	45 31 ed             	xor    %r13d,%r13d
 1084528:	31 db                	xor    %ebx,%ebx
 108452a:	45 31 d2             	xor    %r10d,%r10d
 108452d:	45 31 db             	xor    %r11d,%r11d
 1084530:	31 ff                	xor    %edi,%edi
 1084532:	48 8b 94 24 60 02 00 	mov    0x260(%rsp),%rdx
 1084539:	00 
 108453a:	48 85 ff             	test   %rdi,%rdi
 108453d:	0f 94 c0             	sete   %al
 1084540:	08 c8                	or     %cl,%al
 1084542:	08 82 bd 03 00 00    	or     %al,0x3bd(%rdx)
 1084548:	84 c0                	test   %al,%al
 108454a:	0f 85 e1 0e 00 00    	jne    1085431 <check_input_run+0x5121>
 1084550:	4a 8d 14 f5 00 00 00 	lea    0x0(,%r14,8),%rdx
 1084557:	00 
 1084558:	49 8d 42 08          	lea    0x8(%r10),%rax
 108455c:	31 f6                	xor    %esi,%esi
 108455e:	4c 89 ac 24 f0 00 00 	mov    %r13,0xf0(%rsp)
 1084565:	00 
 1084566:	4c 89 9c 24 98 00 00 	mov    %r11,0x98(%rsp)
 108456d:	00 
 108456e:	48 89 9c 24 d0 00 00 	mov    %rbx,0xd0(%rsp)
 1084575:	00 
 1084576:	49 89 1a             	mov    %rbx,(%r10)
 1084579:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 108457d:	4c 89 54 24 60       	mov    %r10,0x60(%rsp)
 1084582:	c4 c1 7a 7f 42 08    	vmovdqu %xmm0,0x8(%r10)
 1084588:	48 c7 84 24 a0 00 00 	movq   $0x0,0xa0(%rsp)
 108458f:	00 00 00 00 00 
 1084594:	48 89 bc 24 b0 00 00 	mov    %rdi,0xb0(%rsp)
 108459b:	00 
 108459c:	48 89 84 24 30 01 00 	mov    %rax,0x130(%rsp)
 10845a3:	00 
 10845a4:	e8 d7 a9 70 ff       	call   78ef80 <memset@plt>
 10845a9:	49 ff ce             	dec    %r14
 10845ac:	31 ed                	xor    %ebp,%ebp
 10845ae:	45 31 db             	xor    %r11d,%r11d
 10845b1:	31 f6                	xor    %esi,%esi
 10845b3:	48 8b 8c 24 68 02 00 	mov    0x268(%rsp),%rcx
 10845ba:	00 
 10845bb:	41 b0 01             	mov    $0x1,%r8b
 10845be:	48 8b 41 38          	mov    0x38(%rcx),%rax
 10845c2:	8b 1c a8             	mov    (%rax,%rbp,4),%ebx
 10845c5:	44 39 db             	cmp    %r11d,%ebx
 10845c8:	73 1e                	jae    10845e8 <check_input_run+0x42d8>
 10845ca:	41 89 f5             	mov    %esi,%r13d
 10845cd:	48 ff c5             	inc    %rbp
 10845d0:	48 3b 6c 24 38       	cmp    0x38(%rsp),%rbp
 10845d5:	0f 83 f1 0b 00 00    	jae    10851cc <check_input_run+0x4ebc>
 10845db:	44 89 ee             	mov    %r13d,%esi
 10845de:	45 84 c0             	test   %r8b,%r8b
 10845e1:	75 d0                	jne    10845b3 <check_input_run+0x42a3>
 10845e3:	e9 e4 0b 00 00       	jmp    10851cc <check_input_run+0x4ebc>
 10845e8:	48 8b 84 24 70 02 00 	mov    0x270(%rsp),%rax
 10845ef:	00 
 10845f0:	8b b8 30 08 00 00    	mov    0x830(%rax),%edi
 10845f6:	39 fb                	cmp    %edi,%ebx
 10845f8:	73 d0                	jae    10845ca <check_input_run+0x42ba>
 10845fa:	48 8b 51 40          	mov    0x40(%rcx),%rdx
 10845fe:	44 8b 2c aa          	mov    (%rdx,%rbp,4),%r13d
 1084602:	41 39 f5             	cmp    %esi,%r13d
 1084605:	72 c3                	jb     10845ca <check_input_run+0x42ba>
 1084607:	44 3b 69 30          	cmp    0x30(%rcx),%r13d
 108460b:	77 bd                	ja     10845ca <check_input_run+0x42ba>
 108460d:	48 8b 88 10 08 00 00 	mov    0x810(%rax),%rcx
 1084614:	80 3c 19 3c          	cmpb   $0x3c,(%rcx,%rbx,1)
 1084618:	75 b0                	jne    10845ca <check_input_run+0x42ba>
 108461a:	4c 8b 88 18 08 00 00 	mov    0x818(%rax),%r9
 1084621:	41 f6 04 19 02       	testb  $0x2,(%r9,%rbx,1)
 1084626:	74 a2                	je     10845ca <check_input_run+0x42ba>
 1084628:	48 ff cf             	dec    %rdi
 108462b:	48 39 df             	cmp    %rbx,%rdi
 108462e:	74 9a                	je     10845ca <check_input_run+0x42ba>
 1084630:	49 ff c1             	inc    %r9
 1084633:	4c 8d 51 01          	lea    0x1(%rcx),%r10
 1084637:	31 d2                	xor    %edx,%edx
 1084639:	41 80 3c 1a fc       	cmpb   $0xfc,(%r10,%rbx,1)
 108463e:	74 1d                	je     108465d <check_input_run+0x434d>
 1084640:	41 f6 04 19 02       	testb  $0x2,(%r9,%rbx,1)
 1084645:	75 83                	jne    10845ca <check_input_run+0x42ba>
 1084647:	48 ff ca             	dec    %rdx
 108464a:	48 ff cf             	dec    %rdi
 108464d:	49 ff c1             	inc    %r9
 1084650:	49 ff c2             	inc    %r10
 1084653:	48 39 fb             	cmp    %rdi,%rbx
 1084656:	75 e1                	jne    1084639 <check_input_run+0x4329>
 1084658:	e9 6d ff ff ff       	jmp    10845ca <check_input_run+0x42ba>
 108465d:	48 89 df             	mov    %rbx,%rdi
 1084660:	48 29 d7             	sub    %rdx,%rdi
 1084663:	4c 8d 5f 02          	lea    0x2(%rdi),%r11
 1084667:	39 fb                	cmp    %edi,%ebx
 1084669:	0f 83 5e ff ff ff    	jae    10845cd <check_input_run+0x42bd>
 108466f:	80 7c 19 01 01       	cmpb   $0x1,0x1(%rcx,%rbx,1)
 1084674:	0f 85 53 ff ff ff    	jne    10845cd <check_input_run+0x42bd>
 108467a:	4c 8b 90 20 08 00 00 	mov    0x820(%rax),%r10
 1084681:	4c 8b 88 70 02 00 00 	mov    0x270(%rax),%r9
 1084688:	4c 89 9c 24 d8 00 00 	mov    %r11,0xd8(%rsp)
 108468f:	00 
 1084690:	be 70 72 61 67       	mov    $0x67617270,%esi
 1084695:	4c 89 94 24 08 01 00 	mov    %r10,0x108(%rsp)
 108469c:	00 
 108469d:	45 8b 5c 9a 04       	mov    0x4(%r10,%rbx,4),%r11d
 10846a2:	4d 8b 51 10          	mov    0x10(%r9),%r10
 10846a6:	43 83 7c da 04 06    	cmpl   $0x6,0x4(%r10,%r11,8)
 10846ac:	75 5b                	jne    1084709 <check_input_run+0x43f9>
 10846ae:	4d 8b 49 40          	mov    0x40(%r9),%r9
 10846b2:	47 8b 1c da          	mov    (%r10,%r11,8),%r11d
 10846b6:	47 8b 24 19          	mov    (%r9,%r11,1),%r12d
 10846ba:	47 0f b7 5c 19 04    	movzwl 0x4(%r9,%r11,1),%r11d
 10846c0:	41 31 f4             	xor    %esi,%r12d
 10846c3:	41 81 f3 6d 61 00 00 	xor    $0x616d,%r11d
 10846ca:	45 09 e3             	or     %r12d,%r11d
 10846cd:	75 35                	jne    1084704 <check_input_run+0x43f4>
 10846cf:	44 8d 5b 02          	lea    0x2(%rbx),%r11d
 10846d3:	41 39 fb             	cmp    %edi,%r11d
 10846d6:	77 2c                	ja     1084704 <check_input_run+0x43f4>
 10846d8:	45 89 db             	mov    %r11d,%r11d
 10846db:	42 80 3c 19 01       	cmpb   $0x1,(%rcx,%r11,1)
 10846e0:	75 22                	jne    1084704 <check_input_run+0x43f4>
 10846e2:	48 8b b4 24 08 01 00 	mov    0x108(%rsp),%rsi
 10846e9:	00 
 10846ea:	46 8b 1c 9e          	mov    (%rsi,%r11,4),%r11d
 10846ee:	43 83 7c da 04 04    	cmpl   $0x4,0x4(%r10,%r11,8)
 10846f4:	75 0e                	jne    1084704 <check_input_run+0x43f4>
 10846f6:	47 8b 1c da          	mov    (%r10,%r11,8),%r11d
 10846fa:	43 81 3c 19 70 61 63 	cmpl   $0x6b636170,(%r9,%r11,1)
 1084701:	6b 
 1084702:	74 12                	je     1084716 <check_input_run+0x4406>
 1084704:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
 1084709:	4c 8b 9c 24 d8 00 00 	mov    0xd8(%rsp),%r11
 1084710:	00 
 1084711:	e9 b7 fe ff ff       	jmp    10845cd <check_input_run+0x42bd>
 1084716:	8b b4 24 a0 00 00 00 	mov    0xa0(%rsp),%esi
 108471d:	44 8d 43 03          	lea    0x3(%rbx),%r8d
 1084721:	48 89 b4 24 20 01 00 	mov    %rsi,0x120(%rsp)
 1084728:	00 
 1084729:	41 39 f8             	cmp    %edi,%r8d
 108472c:	0f 86 75 01 00 00    	jbe    10848a7 <check_input_run+0x4597>
 1084732:	4c 8b 64 24 60       	mov    0x60(%rsp),%r12
 1084737:	48 8b bc 24 20 01 00 	mov    0x120(%rsp),%rdi
 108473e:	00 
 108473f:	44 89 ea             	mov    %r13d,%edx
 1084742:	2b 94 24 a0 00 00 00 	sub    0xa0(%rsp),%edx
 1084749:	48 03 bc 24 98 00 00 	add    0x98(%rsp),%rdi
 1084750:	00 
 1084751:	41 8b 74 24 14       	mov    0x14(%r12),%esi
 1084756:	e8 25 a8 70 ff       	call   78ef80 <memset@plt>
 108475b:	41 0f b6 44 24 14    	movzbl 0x14(%r12),%eax
 1084761:	41 8b 4c 24 10       	mov    0x10(%r12),%ecx
 1084766:	b2 01                	mov    $0x1,%dl
 1084768:	c7 84 24 88 00 00 00 	movl   $0x0,0x88(%rsp)
 108476f:	00 00 00 00 
 1084773:	c7 84 24 c8 00 00 00 	movl   $0x0,0xc8(%rsp)
 108477a:	00 00 00 00 
 108477e:	c7 84 24 c0 00 00 00 	movl   $0x0,0xc0(%rsp)
 1084785:	00 00 00 00 
 1084789:	48 c7 84 24 00 01 00 	movq   $0x0,0x100(%rsp)
 1084790:	00 00 00 00 00 
 1084795:	be ff ff ff ff       	mov    $0xffffffff,%esi
 108479a:	89 94 24 e8 00 00 00 	mov    %edx,0xe8(%rsp)
 10847a1:	ba ff ff ff ff       	mov    $0xffffffff,%edx
 10847a6:	48 89 94 24 a8 00 00 	mov    %rdx,0xa8(%rsp)
 10847ad:	00 
 10847ae:	b2 01                	mov    $0x1,%dl
 10847b0:	89 94 24 80 00 00 00 	mov    %edx,0x80(%rsp)
 10847b7:	ba ff ff ff ff       	mov    $0xffffffff,%edx
 10847bc:	89 c7                	mov    %eax,%edi
 10847be:	4c 8b 5c 24 60       	mov    0x60(%rsp),%r11
 10847c3:	44 8b a4 24 88 00 00 	mov    0x88(%rsp),%r12d
 10847ca:	00 
 10847cb:	45 8b 43 08          	mov    0x8(%r11),%r8d
 10847cf:	45 8b 4b 10          	mov    0x10(%r11),%r9d
 10847d3:	45 8d 50 01          	lea    0x1(%r8),%r10d
 10847d7:	4d 6b c0 34          	imul   $0x34,%r8,%r8
 10847db:	45 89 53 08          	mov    %r10d,0x8(%r11)
 10847df:	4c 8b 94 24 d0 00 00 	mov    0xd0(%rsp),%r10
 10847e6:	00 
 10847e7:	4c 8b 9c 24 d8 00 00 	mov    0xd8(%rsp),%r11
 10847ee:	00 
 10847ef:	43 89 2c 02          	mov    %ebp,(%r10,%r8,1)
 10847f3:	43 89 5c 02 04       	mov    %ebx,0x4(%r10,%r8,1)
 10847f8:	48 8b 9c 24 a8 00 00 	mov    0xa8(%rsp),%rbx
 10847ff:	00 
 1084800:	47 89 5c 02 08       	mov    %r11d,0x8(%r10,%r8,1)
 1084805:	47 89 6c 02 0c       	mov    %r13d,0xc(%r10,%r8,1)
 108480a:	43 c7 44 02 10 ff ff 	movl   $0xffffffff,0x10(%r10,%r8,1)
 1084811:	ff ff 
 1084813:	43 89 5c 02 14       	mov    %ebx,0x14(%r10,%r8,1)
 1084818:	47 89 64 02 18       	mov    %r12d,0x18(%r10,%r8,1)
 108481d:	43 89 74 02 1c       	mov    %esi,0x1c(%r10,%r8,1)
 1084822:	43 89 54 02 20       	mov    %edx,0x20(%r10,%r8,1)
 1084827:	43 89 4c 02 24       	mov    %ecx,0x24(%r10,%r8,1)
 108482c:	48 8b 8c 24 00 01 00 	mov    0x100(%rsp),%rcx
 1084833:	00 
 1084834:	47 89 4c 02 28       	mov    %r9d,0x28(%r10,%r8,1)
 1084839:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
 108483e:	43 88 4c 02 2c       	mov    %cl,0x2c(%r10,%r8,1)
 1084843:	8b 8c 24 c0 00 00 00 	mov    0xc0(%rsp),%ecx
 108484a:	43 88 4c 02 2d       	mov    %cl,0x2d(%r10,%r8,1)
 108484f:	43 88 44 02 2e       	mov    %al,0x2e(%r10,%r8,1)
 1084854:	8b 84 24 80 00 00 00 	mov    0x80(%rsp),%eax
 108485b:	43 88 7c 02 2f       	mov    %dil,0x2f(%r10,%r8,1)
 1084860:	43 88 44 02 30       	mov    %al,0x30(%r10,%r8,1)
 1084865:	8b 84 24 e8 00 00 00 	mov    0xe8(%rsp),%eax
 108486c:	43 88 44 02 31       	mov    %al,0x31(%r10,%r8,1)
 1084871:	8b 84 24 c8 00 00 00 	mov    0xc8(%rsp),%eax
 1084878:	43 88 44 02 32       	mov    %al,0x32(%r10,%r8,1)
 108487d:	43 c6 44 02 33 00    	movb   $0x0,0x33(%r10,%r8,1)
 1084883:	48 8b 84 24 60 02 00 	mov    0x260(%rsp),%rax
 108488a:	00 
 108488b:	44 0f b6 80 bd 03 00 	movzbl 0x3bd(%rax),%r8d
 1084892:	00 
 1084893:	44 89 e8             	mov    %r13d,%eax
 1084896:	48 89 84 24 a0 00 00 	mov    %rax,0xa0(%rsp)
 108489d:	00 
 108489e:	41 80 f0 01          	xor    $0x1,%r8b
 10848a2:	e9 26 fd ff ff       	jmp    10845cd <check_input_run+0x42bd>
 10848a7:	45 89 c0             	mov    %r8d,%r8d
 10848aa:	45 31 db             	xor    %r11d,%r11d
 10848ad:	42 80 3c 01 0f       	cmpb   $0xf,(%rcx,%r8,1)
 10848b2:	41 0f 94 c4          	sete   %r12b
 10848b6:	0f 85 76 fe ff ff    	jne    1084732 <check_input_run+0x4422>
 10848bc:	45 88 e3             	mov    %r12b,%r11b
 10848bf:	4d 01 d8             	add    %r11,%r8
 10848c2:	41 39 f8             	cmp    %edi,%r8d
 10848c5:	0f 87 67 fe ff ff    	ja     1084732 <check_input_run+0x4422>
 10848cb:	46 0f b6 1c 01       	movzbl (%rcx,%r8,1),%r11d
 10848d0:	c7 84 24 88 00 00 00 	movl   $0x0,0x88(%rsp)
 10848d7:	00 00 00 00 
 10848db:	41 83 fb 0f          	cmp    $0xf,%r11d
 10848df:	7f 11                	jg     10848f2 <check_input_run+0x45e2>
 10848e1:	41 83 fb 01          	cmp    $0x1,%r11d
 10848e5:	74 57                	je     108493e <check_input_run+0x462e>
 10848e7:	41 83 fb 02          	cmp    $0x2,%r11d
 10848eb:	74 1c                	je     1084909 <check_input_run+0x45f9>
 10848ed:	e9 40 fe ff ff       	jmp    1084732 <check_input_run+0x4422>
 10848f2:	41 83 fb 10          	cmp    $0x10,%r11d
 10848f6:	0f 84 82 00 00 00    	je     108497e <check_input_run+0x466e>
 10848fc:	41 81 fb fd 00 00 00 	cmp    $0xfd,%r11d
 1084903:	0f 85 29 fe ff ff    	jne    1084732 <check_input_run+0x4422>
 1084909:	44 89 c6             	mov    %r8d,%esi
 108490c:	48 89 b4 24 a8 00 00 	mov    %rsi,0xa8(%rsp)
 1084913:	00 
 1084914:	40 b6 01             	mov    $0x1,%sil
 1084917:	41 ff c0             	inc    %r8d
 108491a:	41 b1 01             	mov    $0x1,%r9b
 108491d:	89 b4 24 c8 00 00 00 	mov    %esi,0xc8(%rsp)
 1084924:	40 b6 02             	mov    $0x2,%sil
 1084927:	48 89 b4 24 00 01 00 	mov    %rsi,0x100(%rsp)
 108492e:	00 
 108492f:	40 b6 01             	mov    $0x1,%sil
 1084932:	89 b4 24 e8 00 00 00 	mov    %esi,0xe8(%rsp)
 1084939:	e9 05 02 00 00       	jmp    1084b43 <check_input_run+0x4833>
 108493e:	48 8b b4 24 08 01 00 	mov    0x108(%rsp),%rsi
 1084945:	00 
 1084946:	46 8b 1c 86          	mov    (%rsi,%r8,4),%r11d
 108494a:	47 8b 64 da 04       	mov    0x4(%r10,%r11,8),%r12d
 108494f:	41 83 fc 03          	cmp    $0x3,%r12d
 1084953:	74 56                	je     10849ab <check_input_run+0x469b>
 1084955:	41 83 fc 04          	cmp    $0x4,%r12d
 1084959:	75 70                	jne    10849cb <check_input_run+0x46bb>
 108495b:	47 8b 14 da          	mov    (%r10,%r11,8),%r10d
 108495f:	43 81 3c 11 70 75 73 	cmpl   $0x68737570,(%r9,%r10,1)
 1084966:	68 
 1084967:	74 70                	je     10849d9 <check_input_run+0x46c9>
 1084969:	45 31 db             	xor    %r11d,%r11d
 108496c:	43 81 3c 11 73 68 6f 	cmpl   $0x776f6873,(%r9,%r10,1)
 1084973:	77 
 1084974:	41 0f 94 c3          	sete   %r11b
 1084978:	43 8d 34 9b          	lea    (%r11,%r11,4),%esi
 108497c:	eb 63                	jmp    10849e1 <check_input_run+0x46d1>
 108497e:	40 b6 01             	mov    $0x1,%sil
 1084981:	c7 84 24 c8 00 00 00 	movl   $0x0,0xc8(%rsp)
 1084988:	00 00 00 00 
 108498c:	45 31 c9             	xor    %r9d,%r9d
 108498f:	48 89 b4 24 00 01 00 	mov    %rsi,0x100(%rsp)
 1084996:	00 
 1084997:	40 b6 01             	mov    $0x1,%sil
 108499a:	89 b4 24 e8 00 00 00 	mov    %esi,0xe8(%rsp)
 10849a1:	be ff ff ff ff       	mov    $0xffffffff,%esi
 10849a6:	e9 90 01 00 00       	jmp    1084b3b <check_input_run+0x482b>
 10849ab:	47 8b 14 da          	mov    (%r10,%r11,8),%r10d
 10849af:	47 0f b7 1c 11       	movzwl (%r9,%r10,1),%r11d
 10849b4:	47 0f b6 4c 11 02    	movzbl 0x2(%r9,%r10,1),%r9d
 10849ba:	41 81 f3 70 6f 00 00 	xor    $0x6f70,%r11d
 10849c1:	41 83 f1 70          	xor    $0x70,%r9d
 10849c5:	66 45 09 d9          	or     %r11w,%r9w
 10849c9:	74 13                	je     10849de <check_input_run+0x46ce>
 10849cb:	48 c7 84 24 00 01 00 	movq   $0x0,0x100(%rsp)
 10849d2:	00 00 00 00 00 
 10849d7:	eb 10                	jmp    10849e9 <check_input_run+0x46d9>
 10849d9:	40 b6 03             	mov    $0x3,%sil
 10849dc:	eb 03                	jmp    10849e1 <check_input_run+0x46d1>
 10849de:	40 b6 04             	mov    $0x4,%sil
 10849e1:	48 89 b4 24 00 01 00 	mov    %rsi,0x100(%rsp)
 10849e8:	00 
 10849e9:	80 bc 24 00 01 00 00 	cmpb   $0x0,0x100(%rsp)
 10849f0:	00 
 10849f1:	45 89 c1             	mov    %r8d,%r9d
 10849f4:	4d 8d 51 01          	lea    0x1(%r9),%r10
 10849f8:	c7 84 24 c8 00 00 00 	movl   $0x0,0xc8(%rsp)
 10849ff:	00 00 00 00 
 1084a03:	40 0f 95 c6          	setne  %sil
 1084a07:	89 b4 24 e8 00 00 00 	mov    %esi,0xe8(%rsp)
 1084a0e:	41 39 f8             	cmp    %edi,%r8d
 1084a11:	0f 83 0e 01 00 00    	jae    1084b25 <check_input_run+0x4815>
 1084a17:	48 8b b4 24 00 01 00 	mov    0x100(%rsp),%rsi
 1084a1e:	00 
 1084a1f:	44 8d 5e fd          	lea    -0x3(%rsi),%r11d
 1084a23:	41 80 fb 01          	cmp    $0x1,%r11b
 1084a27:	0f 87 f8 00 00 00    	ja     1084b25 <check_input_run+0x4815>
 1084a2d:	42 80 3c 11 3b       	cmpb   $0x3b,(%rcx,%r10,1)
 1084a32:	c7 84 24 c8 00 00 00 	movl   $0x0,0xc8(%rsp)
 1084a39:	00 00 00 00 
 1084a3d:	0f 85 e2 00 00 00    	jne    1084b25 <check_input_run+0x4815>
 1084a43:	4d 8d 51 02          	lea    0x2(%r9),%r10
 1084a47:	c7 84 24 88 00 00 00 	movl   $0x0,0x88(%rsp)
 1084a4e:	00 00 00 00 
 1084a52:	4c 89 94 24 a8 00 00 	mov    %r10,0xa8(%rsp)
 1084a59:	00 
 1084a5a:	41 39 fa             	cmp    %edi,%r10d
 1084a5d:	77 61                	ja     1084ac0 <check_input_run+0x47b0>
 1084a5f:	49 8d 71 02          	lea    0x2(%r9),%rsi
 1084a63:	80 3c 31 01          	cmpb   $0x1,(%rcx,%rsi,1)
 1084a67:	75 57                	jne    1084ac0 <check_input_run+0x47b0>
 1084a69:	48 8b b4 24 08 01 00 	mov    0x108(%rsp),%rsi
 1084a70:	00 
 1084a71:	4d 89 ca             	mov    %r9,%r10
 1084a74:	49 83 c2 03          	add    $0x3,%r10
 1084a78:	c7 84 24 c8 00 00 00 	movl   $0x0,0xc8(%rsp)
 1084a7f:	00 00 00 00 
 1084a83:	42 8b 74 8e 08       	mov    0x8(%rsi,%r9,4),%esi
 1084a88:	45 31 c9             	xor    %r9d,%r9d
 1084a8b:	89 b4 24 88 00 00 00 	mov    %esi,0x88(%rsp)
 1084a92:	41 39 fa             	cmp    %edi,%r10d
 1084a95:	0f 87 e6 06 00 00    	ja     1085181 <check_input_run+0x4e71>
 1084a9b:	45 31 c9             	xor    %r9d,%r9d
 1084a9e:	42 80 3c 11 3b       	cmpb   $0x3b,(%rcx,%r10,1)
 1084aa3:	c7 84 24 c8 00 00 00 	movl   $0x0,0xc8(%rsp)
 1084aaa:	00 00 00 00 
 1084aae:	0f 85 cd 06 00 00    	jne    1085181 <check_input_run+0x4e71>
 1084ab4:	41 8d 70 04          	lea    0x4(%r8),%esi
 1084ab8:	48 89 b4 24 a8 00 00 	mov    %rsi,0xa8(%rsp)
 1084abf:	00 
 1084ac0:	39 bc 24 a8 00 00 00 	cmp    %edi,0xa8(%rsp)
 1084ac7:	0f 87 78 02 00 00    	ja     1084d45 <check_input_run+0x4a35>
 1084acd:	44 8b 84 24 a8 00 00 	mov    0xa8(%rsp),%r8d
 1084ad4:	00 
 1084ad5:	42 0f b6 34 01       	movzbl (%rcx,%r8,1),%esi
 1084ada:	89 b4 24 80 00 00 00 	mov    %esi,0x80(%rsp)
 1084ae1:	83 fe 01             	cmp    $0x1,%esi
 1084ae4:	0f 84 a1 06 00 00    	je     108518b <check_input_run+0x4e7b>
 1084aea:	81 bc 24 80 00 00 00 	cmpl   $0xfd,0x80(%rsp)
 1084af1:	fd 00 00 00 
 1084af5:	74 0e                	je     1084b05 <check_input_run+0x47f5>
 1084af7:	83 bc 24 80 00 00 00 	cmpl   $0x2,0x80(%rsp)
 1084afe:	02 
 1084aff:	0f 85 40 02 00 00    	jne    1084d45 <check_input_run+0x4a35>
 1084b05:	48 8b b4 24 a8 00 00 	mov    0xa8(%rsp),%rsi
 1084b0c:	00 
 1084b0d:	44 8b 8c 24 e8 00 00 	mov    0xe8(%rsp),%r9d
 1084b14:	00 
 1084b15:	44 8d 46 01          	lea    0x1(%rsi),%r8d
 1084b19:	40 b6 01             	mov    $0x1,%sil
 1084b1c:	89 b4 24 c8 00 00 00 	mov    %esi,0xc8(%rsp)
 1084b23:	eb 1e                	jmp    1084b43 <check_input_run+0x4833>
 1084b25:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1084b2a:	c7 84 24 88 00 00 00 	movl   $0x0,0x88(%rsp)
 1084b31:	00 00 00 00 
 1084b35:	45 31 c9             	xor    %r9d,%r9d
 1084b38:	45 89 d0             	mov    %r10d,%r8d
 1084b3b:	48 89 b4 24 a8 00 00 	mov    %rsi,0xa8(%rsp)
 1084b42:	00 
 1084b43:	40 b6 01             	mov    $0x1,%sil
 1084b46:	c7 84 24 f8 00 00 00 	movl   $0x0,0xf8(%rsp)
 1084b4d:	00 00 00 00 
 1084b51:	c7 84 24 c0 00 00 00 	movl   $0x0,0xc0(%rsp)
 1084b58:	00 00 00 00 
 1084b5c:	89 b4 24 80 00 00 00 	mov    %esi,0x80(%rsp)
 1084b63:	41 39 f8             	cmp    %edi,%r8d
 1084b66:	0f 87 3b 02 00 00    	ja     1084da7 <check_input_run+0x4a97>
 1084b6c:	44 89 c7             	mov    %r8d,%edi
 1084b6f:	f7 df                	neg    %edi
 1084b71:	c7 84 24 f8 00 00 00 	movl   $0x0,0xf8(%rsp)
 1084b78:	00 00 00 00 
 1084b7c:	c7 84 24 c0 00 00 00 	movl   $0x0,0xc0(%rsp)
 1084b83:	00 00 00 00 
 1084b87:	48 01 df             	add    %rbx,%rdi
 1084b8a:	39 d7                	cmp    %edx,%edi
 1084b8c:	0f 85 15 02 00 00    	jne    1084da7 <check_input_run+0x4a97>
 1084b92:	44 89 c2             	mov    %r8d,%edx
 1084b95:	80 3c 11 10          	cmpb   $0x10,(%rcx,%rdx,1)
 1084b99:	0f 85 08 02 00 00    	jne    1084da7 <check_input_run+0x4a97>
 1084b9f:	b2 01                	mov    $0x1,%dl
 1084ba1:	89 94 24 f8 00 00 00 	mov    %edx,0xf8(%rsp)
 1084ba8:	45 84 c9             	test   %r9b,%r9b
 1084bab:	0f 84 e0 01 00 00    	je     1084d91 <check_input_run+0x4a81>
 1084bb1:	8b 94 24 a8 00 00 00 	mov    0xa8(%rsp),%edx
 1084bb8:	44 0f b6 0c 11       	movzbl (%rcx,%rdx,1),%r9d
 1084bbd:	41 80 f9 fd          	cmp    $0xfd,%r9b
 1084bc1:	75 12                	jne    1084bd5 <check_input_run+0x48c5>
 1084bc3:	48 8b 84 24 08 01 00 	mov    0x108(%rsp),%rax
 1084bca:	00 
 1084bcb:	31 c9                	xor    %ecx,%ecx
 1084bcd:	8b 04 90             	mov    (%rax,%rdx,4),%eax
 1084bd0:	e9 08 01 00 00       	jmp    1084cdd <check_input_run+0x49cd>
 1084bd5:	48 8b 80 28 08 00 00 	mov    0x828(%rax),%rax
 1084bdc:	48 8b bc 24 88 02 00 	mov    0x288(%rsp),%rdi
 1084be3:	00 
 1084be4:	8b 0c 90             	mov    (%rax,%rdx,4),%ecx
 1084be7:	48 8b 84 24 08 01 00 	mov    0x108(%rsp),%rax
 1084bee:	00 
 1084bef:	4c 8b 67 08          	mov    0x8(%rdi),%r12
 1084bf3:	8b 14 90             	mov    (%rax,%rdx,4),%edx
 1084bf6:	89 d0                	mov    %edx,%eax
 1084bf8:	29 c8                	sub    %ecx,%eax
 1084bfa:	72 25                	jb     1084c21 <check_input_run+0x4911>
 1084bfc:	48 8b 77 10          	mov    0x10(%rdi),%rsi
 1084c00:	4c 29 e6             	sub    %r12,%rsi
 1084c03:	72 1c                	jb     1084c21 <check_input_run+0x4911>
 1084c05:	41 b8 00 00 00 00    	mov    $0x0,%r8d
 1084c0b:	48 39 c6             	cmp    %rax,%rsi
 1084c0e:	76 14                	jbe    1084c24 <check_input_run+0x4914>
 1084c10:	4c 8b 07             	mov    (%rdi),%r8
 1084c13:	49 8d 44 04 01       	lea    0x1(%r12,%rax,1),%rax
 1084c18:	48 89 47 08          	mov    %rax,0x8(%rdi)
 1084c1c:	4d 01 e0             	add    %r12,%r8
 1084c1f:	eb 03                	jmp    1084c24 <check_input_run+0x4914>
 1084c21:	45 31 c0             	xor    %r8d,%r8d
 1084c24:	48 8b bc 24 60 02 00 	mov    0x260(%rsp),%rdi
 1084c2b:	00 
 1084c2c:	39 ca                	cmp    %ecx,%edx
 1084c2e:	0f 93 c0             	setae  %al
 1084c31:	4d 85 c0             	test   %r8,%r8
 1084c34:	40 0f 94 c6          	sete   %sil
 1084c38:	40 20 c6             	and    %al,%sil
 1084c3b:	40 08 b7 bd 03 00 00 	or     %sil,0x3bd(%rdi)
 1084c42:	4d 85 c0             	test   %r8,%r8
 1084c45:	0f 84 31 01 00 00    	je     1084d7c <check_input_run+0x4a6c>
 1084c4b:	48 8b bc 24 70 02 00 	mov    0x270(%rsp),%rdi
 1084c52:	00 
 1084c53:	41 0f b6 f1          	movzbl %r9b,%esi
 1084c57:	4c 8d 8c 24 d8 01 00 	lea    0x1d8(%rsp),%r9
 1084c5e:	00 
 1084c5f:	48 c7 84 24 d8 01 00 	movq   $0x0,0x1d8(%rsp)
 1084c66:	00 00 00 00 00 
 1084c6b:	e8 50 6d fd ff       	call   105b9c0 <pp_spelling>
 1084c70:	48 8b b4 24 d8 01 00 	mov    0x1d8(%rsp),%rsi
 1084c77:	00 
 1084c78:	48 8b 8c 24 88 02 00 	mov    0x288(%rsp),%rcx
 1084c7f:	00 
 1084c80:	48 8d bc 24 e0 01 00 	lea    0x1e0(%rsp),%rdi
 1084c87:	00 
 1084c88:	89 c2                	mov    %eax,%edx
 1084c8a:	e8 91 df 01 00       	call   10a2c20 <check_literal_number>
 1084c8f:	0f b6 94 24 03 02 00 	movzbl 0x203(%rsp),%edx
 1084c96:	00 
 1084c97:	48 8b bc 24 60 02 00 	mov    0x260(%rsp),%rdi
 1084c9e:	00 
 1084c9f:	0f b6 8c 24 01 02 00 	movzbl 0x201(%rsp),%ecx
 1084ca6:	00 
 1084ca7:	48 8b 84 24 e8 01 00 	mov    0x1e8(%rsp),%rax
 1084cae:	00 
 1084caf:	0f b6 b4 24 02 02 00 	movzbl 0x202(%rsp),%esi
 1084cb6:	00 
 1084cb7:	0a 8c 24 00 02 00 00 	or     0x200(%rsp),%cl
 1084cbe:	80 e2 01             	and    $0x1,%dl
 1084cc1:	08 97 bd 03 00 00    	or     %dl,0x3bd(%rdi)
 1084cc7:	48 8b 94 24 88 02 00 	mov    0x288(%rsp),%rdx
 1084cce:	00 
 1084ccf:	4c 89 62 08          	mov    %r12,0x8(%rdx)
 1084cd3:	40 f6 c6 01          	test   $0x1,%sil
 1084cd7:	0f 84 3f 04 00 00    	je     108511c <check_input_run+0x4e0c>
 1084cdd:	b2 02                	mov    $0x2,%dl
 1084cdf:	c7 84 24 c0 00 00 00 	movl   $0x0,0xc0(%rsp)
 1084ce6:	00 00 00 00 
 1084cea:	89 94 24 80 00 00 00 	mov    %edx,0x80(%rsp)
 1084cf1:	f6 c1 01             	test   $0x1,%cl
 1084cf4:	75 42                	jne    1084d38 <check_input_run+0x4a28>
 1084cf6:	48 83 f8 10          	cmp    $0x10,%rax
 1084cfa:	77 3c                	ja     1084d38 <check_input_run+0x4a28>
 1084cfc:	f3 48 0f b8 c8       	popcnt %rax,%rcx
 1084d01:	83 f9 01             	cmp    $0x1,%ecx
 1084d04:	77 32                	ja     1084d38 <check_input_run+0x4a28>
 1084d06:	48 85 c0             	test   %rax,%rax
 1084d09:	0f 84 82 00 00 00    	je     1084d91 <check_input_run+0x4a81>
 1084d0f:	48 83 f8 01          	cmp    $0x1,%rax
 1084d13:	0f 85 27 04 00 00    	jne    1085140 <check_input_run+0x4e30>
 1084d19:	b0 01                	mov    $0x1,%al
 1084d1b:	c7 84 24 80 00 00 00 	movl   $0x0,0x80(%rsp)
 1084d22:	00 00 00 00 
 1084d26:	89 84 24 c0 00 00 00 	mov    %eax,0xc0(%rsp)
 1084d2d:	b0 01                	mov    $0x1,%al
 1084d2f:	89 84 24 f8 00 00 00 	mov    %eax,0xf8(%rsp)
 1084d36:	eb 6f                	jmp    1084da7 <check_input_run+0x4a97>
 1084d38:	c7 84 24 f8 00 00 00 	movl   $0x0,0xf8(%rsp)
 1084d3f:	00 00 00 00 
 1084d43:	eb 62                	jmp    1084da7 <check_input_run+0x4a97>
 1084d45:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1084d4a:	c7 84 24 c0 00 00 00 	movl   $0x0,0xc0(%rsp)
 1084d51:	00 00 00 00 
 1084d55:	c7 84 24 f8 00 00 00 	movl   $0x0,0xf8(%rsp)
 1084d5c:	00 00 00 00 
 1084d60:	48 89 84 24 a8 00 00 	mov    %rax,0xa8(%rsp)
 1084d67:	00 
 1084d68:	b0 01                	mov    $0x1,%al
 1084d6a:	89 84 24 80 00 00 00 	mov    %eax,0x80(%rsp)
 1084d71:	b0 01                	mov    $0x1,%al
 1084d73:	89 84 24 c8 00 00 00 	mov    %eax,0xc8(%rsp)
 1084d7a:	eb 2b                	jmp    1084da7 <check_input_run+0x4a97>
 1084d7c:	48 8b 84 24 88 02 00 	mov    0x288(%rsp),%rax
 1084d83:	00 
 1084d84:	4c 89 60 08          	mov    %r12,0x8(%rax)
 1084d88:	b0 03                	mov    $0x3,%al
 1084d8a:	89 84 24 e8 00 00 00 	mov    %eax,0xe8(%rsp)
 1084d91:	c7 84 24 c0 00 00 00 	movl   $0x0,0xc0(%rsp)
 1084d98:	00 00 00 00 
 1084d9c:	c7 84 24 80 00 00 00 	movl   $0x0,0x80(%rsp)
 1084da3:	00 00 00 00 
 1084da7:	4c 8b 64 24 60       	mov    0x60(%rsp),%r12
 1084dac:	48 8b bc 24 20 01 00 	mov    0x120(%rsp),%rdi
 1084db3:	00 
 1084db4:	44 89 ea             	mov    %r13d,%edx
 1084db7:	2b 94 24 a0 00 00 00 	sub    0xa0(%rsp),%edx
 1084dbe:	48 03 bc 24 98 00 00 	add    0x98(%rsp),%rdi
 1084dc5:	00 
 1084dc6:	41 8b 74 24 14       	mov    0x14(%r12),%esi
 1084dcb:	e8 b0 a1 70 ff       	call   78ef80 <memset@plt>
 1084dd0:	41 8b 4c 24 10       	mov    0x10(%r12),%ecx
 1084dd5:	41 0f b6 44 24 14    	movzbl 0x14(%r12),%eax
 1084ddb:	80 bc 24 f8 00 00 00 	cmpb   $0x0,0xf8(%rsp)
 1084de2:	00 
 1084de3:	ba ff ff ff ff       	mov    $0xffffffff,%edx
 1084de8:	74 51                	je     1084e3b <check_input_run+0x4b2b>
 1084dea:	80 bc 24 e8 00 00 00 	cmpb   $0x1,0xe8(%rsp)
 1084df1:	01 
 1084df2:	75 47                	jne    1084e3b <check_input_run+0x4b2b>
 1084df4:	0f b6 b4 24 00 01 00 	movzbl 0x100(%rsp),%esi
 1084dfb:	00 
 1084dfc:	c7 84 24 80 00 00 00 	movl   $0x0,0x80(%rsp)
 1084e03:	00 00 00 00 
 1084e07:	ff ce                	dec    %esi
 1084e09:	83 fe 04             	cmp    $0x4,%esi
 1084e0c:	0f 87 64 01 00 00    	ja     1084f76 <check_input_run+0x4c66>
 1084e12:	48 8d 3d af 94 41 ff 	lea    -0xbe6b51(%rip),%rdi        # 49e2c8 <cbuiltin_test_generated.edges+0x3b48>
 1084e19:	48 63 34 b7          	movslq (%rdi,%rsi,4),%rsi
 1084e1d:	48 01 fe             	add    %rdi,%rsi
 1084e20:	ff e6                	jmp    *%rsi
 1084e22:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
 1084e27:	c7 84 24 80 00 00 00 	movl   $0x0,0x80(%rsp)
 1084e2e:	00 00 00 00 
 1084e32:	c6 46 14 00          	movb   $0x0,0x14(%rsi)
 1084e36:	e9 3b 01 00 00       	jmp    1084f76 <check_input_run+0x4c66>
 1084e3b:	89 c7                	mov    %eax,%edi
 1084e3d:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1084e42:	e9 77 f9 ff ff       	jmp    10847be <check_input_run+0x44ae>
 1084e47:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
 1084e4c:	8d 51 01             	lea    0x1(%rcx),%edx
 1084e4f:	83 bc 24 88 00 00 00 	cmpl   $0x0,0x88(%rsp)
 1084e56:	00 
 1084e57:	8b 7e 08             	mov    0x8(%rsi),%edi
 1084e5a:	89 56 10             	mov    %edx,0x10(%rsi)
 1084e5d:	48 8b 94 24 f0 00 00 	mov    0xf0(%rsp),%rdx
 1084e64:	00 
 1084e65:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1084e6a:	89 3c 8a             	mov    %edi,(%rdx,%rcx,4)
 1084e6d:	ba ff ff ff ff       	mov    $0xffffffff,%edx
 1084e72:	0f 84 3d 01 00 00    	je     1084fb5 <check_input_run+0x4ca5>
 1084e78:	8b 94 24 88 00 00 00 	mov    0x88(%rsp),%edx
 1084e7f:	49 b8 15 7c 4a 7f b9 	movabs $0x9e3779b97f4a7c15,%r8
 1084e86:	79 37 9e 
 1084e89:	49 0f af d0          	imul   %r8,%rdx
 1084e8d:	4c 8b 94 24 b0 00 00 	mov    0xb0(%rsp),%r10
 1084e94:	00 
 1084e95:	49 89 d0             	mov    %rdx,%r8
 1084e98:	4d 21 f0             	and    %r14,%r8
 1084e9b:	47 8b 0c c2          	mov    (%r10,%r8,8),%r9d
 1084e9f:	45 85 c9             	test   %r9d,%r9d
 1084ea2:	74 0e                	je     1084eb2 <check_input_run+0x4ba2>
 1084ea4:	49 8d 50 01          	lea    0x1(%r8),%rdx
 1084ea8:	44 3b 8c 24 88 00 00 	cmp    0x88(%rsp),%r9d
 1084eaf:	00 
 1084eb0:	75 db                	jne    1084e8d <check_input_run+0x4b7d>
 1084eb2:	45 85 c9             	test   %r9d,%r9d
 1084eb5:	0f 84 c2 00 00 00    	je     1084f7d <check_input_run+0x4c6d>
 1084ebb:	48 8b 94 24 b0 00 00 	mov    0xb0(%rsp),%rdx
 1084ec2:	00 
 1084ec3:	42 8b 54 c2 04       	mov    0x4(%rdx,%r8,8),%edx
 1084ec8:	e9 db 00 00 00       	jmp    1084fa8 <check_input_run+0x4c98>
 1084ecd:	83 bc 24 88 00 00 00 	cmpl   $0x0,0x88(%rsp)
 1084ed4:	00 
 1084ed5:	40 0f 95 c6          	setne  %sil
 1084ed9:	40 22 b4 24 c8 00 00 	and    0xc8(%rsp),%sil
 1084ee0:	00 
 1084ee1:	40 c0 e6 03          	shl    $0x3,%sil
 1084ee5:	89 b4 24 80 00 00 00 	mov    %esi,0x80(%rsp)
 1084eec:	85 c9                	test   %ecx,%ecx
 1084eee:	74 74                	je     1084f64 <check_input_run+0x4c54>
 1084ef0:	83 bc 24 88 00 00 00 	cmpl   $0x0,0x88(%rsp)
 1084ef7:	00 
 1084ef8:	0f 84 35 01 00 00    	je     1085033 <check_input_run+0x4d23>
 1084efe:	44 8b 84 24 88 00 00 	mov    0x88(%rsp),%r8d
 1084f05:	00 
 1084f06:	48 be 15 7c 4a 7f b9 	movabs $0x9e3779b97f4a7c15,%rsi
 1084f0d:	79 37 9e 
 1084f10:	4c 0f af c6          	imul   %rsi,%r8
 1084f14:	48 8b bc 24 b0 00 00 	mov    0xb0(%rsp),%rdi
 1084f1b:	00 
 1084f1c:	4c 89 c6             	mov    %r8,%rsi
 1084f1f:	4c 21 f6             	and    %r14,%rsi
 1084f22:	8b 3c f7             	mov    (%rdi,%rsi,8),%edi
 1084f25:	85 ff                	test   %edi,%edi
 1084f27:	74 0d                	je     1084f36 <check_input_run+0x4c26>
 1084f29:	4c 8d 46 01          	lea    0x1(%rsi),%r8
 1084f2d:	3b bc 24 88 00 00 00 	cmp    0x88(%rsp),%edi
 1084f34:	75 de                	jne    1084f14 <check_input_run+0x4c04>
 1084f36:	4c 8b 84 24 b0 00 00 	mov    0xb0(%rsp),%r8
 1084f3d:	00 
 1084f3e:	49 8d 34 f0          	lea    (%r8,%rsi,8),%rsi
 1084f42:	85 ff                	test   %edi,%edi
 1084f44:	75 10                	jne    1084f56 <check_input_run+0x4c46>
 1084f46:	8b bc 24 88 00 00 00 	mov    0x88(%rsp),%edi
 1084f4d:	89 3e                	mov    %edi,(%rsi)
 1084f4f:	c7 46 04 ff ff ff ff 	movl   $0xffffffff,0x4(%rsi)
 1084f56:	48 83 c6 04          	add    $0x4,%rsi
 1084f5a:	e9 e3 00 00 00       	jmp    1085042 <check_input_run+0x4d32>
 1084f5f:	40 b6 10             	mov    $0x10,%sil
 1084f62:	eb 0b                	jmp    1084f6f <check_input_run+0x4c5f>
 1084f64:	8b b4 24 80 00 00 00 	mov    0x80(%rsp),%esi
 1084f6b:	40 80 ce 04          	or     $0x4,%sil
 1084f6f:	89 b4 24 80 00 00 00 	mov    %esi,0x80(%rsp)
 1084f76:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1084f7b:	eb 5b                	jmp    1084fd8 <check_input_run+0x4cc8>
 1084f7d:	48 8b 94 24 b0 00 00 	mov    0xb0(%rsp),%rdx
 1084f84:	00 
 1084f85:	8b bc 24 88 00 00 00 	mov    0x88(%rsp),%edi
 1084f8c:	42 89 3c c2          	mov    %edi,(%rdx,%r8,8)
 1084f90:	42 c7 44 c2 04 ff ff 	movl   $0xffffffff,0x4(%rdx,%r8,8)
 1084f97:	ff ff 
 1084f99:	48 8b 94 24 30 01 00 	mov    0x130(%rsp),%rdx
 1084fa0:	00 
 1084fa1:	8b 3a                	mov    (%rdx),%edi
 1084fa3:	ba ff ff ff ff       	mov    $0xffffffff,%edx
 1084fa8:	4c 8b 8c 24 b0 00 00 	mov    0xb0(%rsp),%r9
 1084faf:	00 
 1084fb0:	43 89 7c c1 04       	mov    %edi,0x4(%r9,%r8,8)
 1084fb5:	4c 8b 4c 24 60       	mov    0x60(%rsp),%r9
 1084fba:	c7 84 24 80 00 00 00 	movl   $0x0,0x80(%rsp)
 1084fc1:	00 00 00 00 
 1084fc5:	41 8b 79 0c          	mov    0xc(%r9),%edi
 1084fc9:	45 8b 41 10          	mov    0x10(%r9),%r8d
 1084fcd:	41 39 f8             	cmp    %edi,%r8d
 1084fd0:	41 0f 47 f8          	cmova  %r8d,%edi
 1084fd4:	41 89 79 0c          	mov    %edi,0xc(%r9)
 1084fd8:	f6 84 24 c8 00 00 00 	testb  $0x1,0xc8(%rsp)
 1084fdf:	01 
 1084fe0:	74 2d                	je     108500f <check_input_run+0x4cff>
 1084fe2:	48 8b 7c 24 60       	mov    0x60(%rsp),%rdi
 1084fe7:	44 8b 84 24 c0 00 00 	mov    0xc0(%rsp),%r8d
 1084fee:	00 
 1084fef:	44 88 47 14          	mov    %r8b,0x14(%rdi)
 1084ff3:	40 b7 01             	mov    $0x1,%dil
 1084ff6:	89 bc 24 e8 00 00 00 	mov    %edi,0xe8(%rsp)
 1084ffd:	40 b7 01             	mov    $0x1,%dil
 1085000:	89 bc 24 c8 00 00 00 	mov    %edi,0xc8(%rsp)
 1085007:	44 89 c7             	mov    %r8d,%edi
 108500a:	e9 af f7 ff ff       	jmp    10847be <check_input_run+0x44ae>
 108500f:	48 8b 7c 24 60       	mov    0x60(%rsp),%rdi
 1085014:	41 b0 01             	mov    $0x1,%r8b
 1085017:	c7 84 24 c8 00 00 00 	movl   $0x0,0xc8(%rsp)
 108501e:	00 00 00 00 
 1085022:	44 89 84 24 e8 00 00 	mov    %r8d,0xe8(%rsp)
 1085029:	00 
 108502a:	0f b6 7f 14          	movzbl 0x14(%rdi),%edi
 108502e:	e9 8b f7 ff ff       	jmp    10847be <check_input_run+0x44ae>
 1085033:	48 8b bc 24 f0 00 00 	mov    0xf0(%rsp),%rdi
 108503a:	00 
 108503b:	8d 71 ff             	lea    -0x1(%rcx),%esi
 108503e:	48 8d 34 b7          	lea    (%rdi,%rsi,4),%rsi
 1085042:	8b 36                	mov    (%rsi),%esi
 1085044:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 1085049:	48 39 fe             	cmp    %rdi,%rsi
 108504c:	0f 84 24 ff ff ff    	je     1084f76 <check_input_run+0x4c66>
 1085052:	4c 8b 8c 24 d0 00 00 	mov    0xd0(%rsp),%r9
 1085059:	00 
 108505a:	4c 6b c6 34          	imul   $0x34,%rsi,%r8
 108505e:	4c 8b 54 24 60       	mov    0x60(%rsp),%r10
 1085063:	43 8b 7c 01 24       	mov    0x24(%r9,%r8,1),%edi
 1085068:	47 0f b6 44 01 2e    	movzbl 0x2e(%r9,%r8,1),%r8d
 108506e:	45 88 42 14          	mov    %r8b,0x14(%r10)
 1085072:	45 8b 4a 10          	mov    0x10(%r10),%r9d
 1085076:	eb 16                	jmp    108508e <check_input_run+0x4d7e>
 1085078:	4c 8b 84 24 b0 00 00 	mov    0xb0(%rsp),%r8
 108507f:	00 
 1085080:	47 89 4c d0 04       	mov    %r9d,0x4(%r8,%r10,8)
 1085085:	4c 8b 4c 24 60       	mov    0x60(%rsp),%r9
 108508a:	45 8b 49 10          	mov    0x10(%r9),%r9d
 108508e:	41 39 f9             	cmp    %edi,%r9d
 1085091:	0f 86 41 ff ff ff    	jbe    1084fd8 <check_input_run+0x4cc8>
 1085097:	4c 8b 44 24 60       	mov    0x60(%rsp),%r8
 108509c:	4c 8b 94 24 f0 00 00 	mov    0xf0(%rsp),%r10
 10850a3:	00 
 10850a4:	41 ff c9             	dec    %r9d
 10850a7:	4c 8b 9c 24 d0 00 00 	mov    0xd0(%rsp),%r11
 10850ae:	00 
 10850af:	45 89 48 10          	mov    %r9d,0x10(%r8)
 10850b3:	47 8b 04 8a          	mov    (%r10,%r9,4),%r8d
 10850b7:	4d 6b d0 34          	imul   $0x34,%r8,%r10
 10850bb:	47 8b 44 13 18       	mov    0x18(%r11,%r10,1),%r8d
 10850c0:	4d 85 c0             	test   %r8,%r8
 10850c3:	74 c9                	je     108508e <check_input_run+0x4d7e>
 10850c5:	4c 03 94 24 d0 00 00 	add    0xd0(%rsp),%r10
 10850cc:	00 
 10850cd:	4d 89 c4             	mov    %r8,%r12
 10850d0:	45 8b 4a 20          	mov    0x20(%r10),%r9d
 10850d4:	49 ba 15 7c 4a 7f b9 	movabs $0x9e3779b97f4a7c15,%r10
 10850db:	79 37 9e 
 10850de:	4d 0f af e2          	imul   %r10,%r12
 10850e2:	4c 8b 9c 24 b0 00 00 	mov    0xb0(%rsp),%r11
 10850e9:	00 
 10850ea:	4d 89 e2             	mov    %r12,%r10
 10850ed:	4d 21 f2             	and    %r14,%r10
 10850f0:	47 8b 1c d3          	mov    (%r11,%r10,8),%r11d
 10850f4:	45 85 db             	test   %r11d,%r11d
 10850f7:	74 09                	je     1085102 <check_input_run+0x4df2>
 10850f9:	4d 8d 62 01          	lea    0x1(%r10),%r12
 10850fd:	45 39 c3             	cmp    %r8d,%r11d
 1085100:	75 e0                	jne    10850e2 <check_input_run+0x4dd2>
 1085102:	45 85 db             	test   %r11d,%r11d
 1085105:	0f 85 6d ff ff ff    	jne    1085078 <check_input_run+0x4d68>
 108510b:	4c 8b 9c 24 b0 00 00 	mov    0xb0(%rsp),%r11
 1085112:	00 
 1085113:	47 89 04 d3          	mov    %r8d,(%r11,%r10,8)
 1085117:	e9 5c ff ff ff       	jmp    1085078 <check_input_run+0x4d68>
 108511c:	b0 03                	mov    $0x3,%al
 108511e:	c7 84 24 c0 00 00 00 	movl   $0x0,0xc0(%rsp)
 1085125:	00 00 00 00 
 1085129:	c7 84 24 80 00 00 00 	movl   $0x0,0x80(%rsp)
 1085130:	00 00 00 00 
 1085134:	89 84 24 e8 00 00 00 	mov    %eax,0xe8(%rsp)
 108513b:	e9 67 fc ff ff       	jmp    1084da7 <check_input_run+0x4a97>
 1085140:	b1 01                	mov    $0x1,%cl
 1085142:	89 8c 24 f8 00 00 00 	mov    %ecx,0xf8(%rsp)
 1085149:	b1 01                	mov    $0x1,%cl
 108514b:	89 8c 24 c0 00 00 00 	mov    %ecx,0xc0(%rsp)
 1085152:	48 89 c1             	mov    %rax,%rcx
 1085155:	8b 94 24 c0 00 00 00 	mov    0xc0(%rsp),%edx
 108515c:	48 d1 e9             	shr    $1,%rcx
 108515f:	c7 84 24 80 00 00 00 	movl   $0x0,0x80(%rsp)
 1085166:	00 00 00 00 
 108516a:	fe c2                	inc    %dl
 108516c:	89 94 24 c0 00 00 00 	mov    %edx,0xc0(%rsp)
 1085173:	48 83 f8 03          	cmp    $0x3,%rax
 1085177:	48 89 c8             	mov    %rcx,%rax
 108517a:	77 d9                	ja     1085155 <check_input_run+0x4e45>
 108517c:	e9 26 fc ff ff       	jmp    1084da7 <check_input_run+0x4a97>
 1085181:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1085186:	e9 ad f9 ff ff       	jmp    1084b38 <check_input_run+0x4828>
 108518b:	8b 8c 24 80 00 00 00 	mov    0x80(%rsp),%ecx
 1085192:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1085197:	c7 84 24 c0 00 00 00 	movl   $0x0,0xc0(%rsp)
 108519e:	00 00 00 00 
 10851a2:	c7 84 24 f8 00 00 00 	movl   $0x0,0xf8(%rsp)
 10851a9:	00 00 00 00 
 10851ad:	c7 84 24 e8 00 00 00 	movl   $0x0,0xe8(%rsp)
 10851b4:	00 00 00 00 
 10851b8:	48 89 84 24 a8 00 00 	mov    %rax,0xa8(%rsp)
 10851bf:	00 
 10851c0:	89 8c 24 c8 00 00 00 	mov    %ecx,0xc8(%rsp)
 10851c7:	e9 db fb ff ff       	jmp    1084da7 <check_input_run+0x4a97>
 10851cc:	4c 8b 4c 24 40       	mov    0x40(%rsp),%r9
 10851d1:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
 10851d6:	48 8b b4 24 98 00 00 	mov    0x98(%rsp),%rsi
 10851dd:	00 
 10851de:	48 8b 54 24 68       	mov    0x68(%rsp),%rdx
 10851e3:	45 84 c0             	test   %r8b,%r8b
 10851e6:	0f 84 45 02 00 00    	je     1085431 <check_input_run+0x5121>
 10851ec:	8b 84 24 a0 00 00 00 	mov    0xa0(%rsp),%eax
 10851f3:	48 8d 3c 06          	lea    (%rsi,%rax,1),%rdi
 10851f7:	8b 71 14             	mov    0x14(%rcx),%esi
 10851fa:	48 29 c2             	sub    %rax,%rdx
 10851fd:	48 ff c2             	inc    %rdx
 1085200:	e8 7b 9d 70 ff       	call   78ef80 <memset@plt>
 1085205:	48 8b 8c 24 88 02 00 	mov    0x288(%rsp),%rcx
 108520c:	00 
 108520d:	4c 8b b4 24 68 02 00 	mov    0x268(%rsp),%r14
 1085214:	00 
 1085215:	b0 01                	mov    $0x1,%al
 1085217:	4c 8b 01             	mov    (%rcx),%r8
 108521a:	48 8b 71 08          	mov    0x8(%rcx),%rsi
 108521e:	41 8b 5e 30          	mov    0x30(%r14),%ebx
 1085222:	4a 8d 7c 06 03       	lea    0x3(%rsi,%r8,1),%rdi
 1085227:	48 8d 14 9d 04 00 00 	lea    0x4(,%rbx,4),%rdx
 108522e:	00 
 108522f:	48 8d 6b 01          	lea    0x1(%rbx),%rbp
 1085233:	4c 01 c6             	add    %r8,%rsi
 1085236:	48 83 e7 fc          	and    $0xfffffffffffffffc,%rdi
 108523a:	48 39 f7             	cmp    %rsi,%rdi
 108523d:	0f 83 ad 00 00 00    	jae    10852f0 <check_input_run+0x4fe0>
 1085243:	4c 8b 4c 24 40       	mov    0x40(%rsp),%r9
 1085248:	31 ff                	xor    %edi,%edi
 108524a:	45 31 ed             	xor    %r13d,%r13d
 108524d:	e9 c1 01 00 00       	jmp    1085413 <check_input_run+0x5103>
 1085252:	48 8b 76 10          	mov    0x10(%rsi),%rsi
 1085256:	48 89 ca             	mov    %rcx,%rdx
 1085259:	48 29 c2             	sub    %rax,%rdx
 108525c:	48 29 d6             	sub    %rdx,%rsi
 108525f:	0f 82 fd 00 00 00    	jb     1085362 <check_input_run+0x5052>
 1085265:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
 108526a:	48 8d 04 85 04 00 00 	lea    0x4(,%rax,4),%rax
 1085271:	00 
 1085272:	48 39 f0             	cmp    %rsi,%rax
 1085275:	0f 87 e7 00 00 00    	ja     1085362 <check_input_run+0x5052>
 108527b:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
 1085280:	4c 8b 04 24          	mov    (%rsp),%r8
 1085284:	48 01 c2             	add    %rax,%rdx
 1085287:	48 8d be 38 02 00 00 	lea    0x238(%rsi),%rdi
 108528e:	49 89 50 08          	mov    %rdx,0x8(%r8)
 1085292:	48 89 8e 38 02 00 00 	mov    %rcx,0x238(%rsi)
 1085299:	48 89 bc 24 c0 00 00 	mov    %rdi,0xc0(%rsp)
 10852a0:	00 
 10852a1:	48 85 c9             	test   %rcx,%rcx
 10852a4:	74 1c                	je     10852c2 <check_input_run+0x4fb2>
 10852a6:	49 8b 30             	mov    (%r8),%rsi
 10852a9:	49 8b 50 08          	mov    0x8(%r8),%rdx
 10852ad:	48 8d 4c 32 03       	lea    0x3(%rdx,%rsi,1),%rcx
 10852b2:	48 01 f2             	add    %rsi,%rdx
 10852b5:	48 83 e1 fc          	and    $0xfffffffffffffffc,%rcx
 10852b9:	48 39 d1             	cmp    %rdx,%rcx
 10852bc:	0f 83 a3 4e 00 00    	jae    108a165 <check_input_run+0x9e55>
 10852c2:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
 10852c7:	4c 89 c6             	mov    %r8,%rsi
 10852ca:	48 c7 87 40 02 00 00 	movq   $0x0,0x240(%rdi)
 10852d1:	00 00 00 00 
 10852d5:	48 c7 87 48 02 00 00 	movq   $0x0,0x248(%rdi)
 10852dc:	00 00 00 00 
 10852e0:	48 c7 87 60 02 00 00 	movq   $0x0,0x260(%rdi)
 10852e7:	00 00 00 00 
 10852eb:	e9 81 b8 ff ff       	jmp    1080b71 <check_input_run+0x861>
 10852f0:	48 89 fe             	mov    %rdi,%rsi
 10852f3:	4c 29 c6             	sub    %r8,%rsi
 10852f6:	4c 8b 41 10          	mov    0x10(%rcx),%r8
 10852fa:	4c 8b 4c 24 40       	mov    0x40(%rsp),%r9
 10852ff:	45 31 ed             	xor    %r13d,%r13d
 1085302:	49 29 f0             	sub    %rsi,%r8
 1085305:	0f 82 06 01 00 00    	jb     1085411 <check_input_run+0x5101>
 108530b:	4c 39 c2             	cmp    %r8,%rdx
 108530e:	0f 87 fd 00 00 00    	ja     1085411 <check_input_run+0x5101>
 1085314:	48 01 d6             	add    %rdx,%rsi
 1085317:	48 89 71 08          	mov    %rsi,0x8(%rcx)
 108531b:	48 85 ff             	test   %rdi,%rdi
 108531e:	0f 84 24 ff ff ff    	je     1085248 <check_input_run+0x4f38>
 1085324:	48 8b 8c 24 88 02 00 	mov    0x288(%rsp),%rcx
 108532b:	00 
 108532c:	45 31 ed             	xor    %r13d,%r13d
 108532f:	b8 00 00 00 00       	mov    $0x0,%eax
 1085334:	48 8b 71 08          	mov    0x8(%rcx),%rsi
 1085338:	4c 8b 41 10          	mov    0x10(%rcx),%r8
 108533c:	49 29 f0             	sub    %rsi,%r8
 108533f:	0f 82 ce 00 00 00    	jb     1085413 <check_input_run+0x5103>
 1085345:	49 39 d8             	cmp    %rbx,%r8
 1085348:	0f 86 c5 00 00 00    	jbe    1085413 <check_input_run+0x5103>
 108534e:	4c 8b 29             	mov    (%rcx),%r13
 1085351:	31 c0                	xor    %eax,%eax
 1085353:	49 01 f5             	add    %rsi,%r13
 1085356:	48 01 ee             	add    %rbp,%rsi
 1085359:	48 89 71 08          	mov    %rsi,0x8(%rcx)
 108535d:	e9 b1 00 00 00       	jmp    1085413 <check_input_run+0x5103>
 1085362:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
 1085367:	e9 c6 b7 ff ff       	jmp    1080b32 <check_input_run+0x822>
 108536c:	48 89 de             	mov    %rbx,%rsi
 108536f:	48 29 fe             	sub    %rdi,%rsi
 1085372:	48 8b 78 10          	mov    0x10(%rax),%rdi
 1085376:	45 31 ed             	xor    %r13d,%r13d
 1085379:	48 29 f7             	sub    %rsi,%rdi
 108537c:	0f 82 f1 47 00 00    	jb     1089b73 <check_input_run+0x9863>
 1085382:	4c 6b c2 34          	imul   $0x34,%rdx,%r8
 1085386:	49 39 f8             	cmp    %rdi,%r8
 1085389:	0f 87 e4 47 00 00    	ja     1089b73 <check_input_run+0x9863>
 108538f:	4c 01 c6             	add    %r8,%rsi
 1085392:	48 89 70 08          	mov    %rsi,0x8(%rax)
 1085396:	48 85 db             	test   %rbx,%rbx
 1085399:	0f 84 7f f1 ff ff    	je     108451e <check_input_run+0x420e>
 108539f:	48 8b 84 24 80 02 00 	mov    0x280(%rsp),%rax
 10853a6:	00 
 10853a7:	48 8b 7c 24 68       	mov    0x68(%rsp),%rdi
 10853ac:	45 31 ed             	xor    %r13d,%r13d
 10853af:	4c 8b 58 08          	mov    0x8(%rax),%r11
 10853b3:	48 8b 70 10          	mov    0x10(%rax),%rsi
 10853b7:	4c 29 de             	sub    %r11,%rsi
 10853ba:	0f 82 6d f1 ff ff    	jb     108452d <check_input_run+0x421d>
 10853c0:	48 39 fe             	cmp    %rdi,%rsi
 10853c3:	0f 86 64 f1 ff ff    	jbe    108452d <check_input_run+0x421d>
 10853c9:	4a 8d 74 1f 01       	lea    0x1(%rdi,%r11,1),%rsi
 10853ce:	4c 03 18             	add    (%rax),%r11
 10853d1:	48 89 70 08          	mov    %rsi,0x8(%rax)
 10853d5:	0f 84 09 58 00 00    	je     108abe4 <check_input_run+0xa8d4>
 10853db:	48 8b b4 24 88 02 00 	mov    0x288(%rsp),%rsi
 10853e2:	00 
 10853e3:	4c 8b 06             	mov    (%rsi),%r8
 10853e6:	48 8b 7e 08          	mov    0x8(%rsi),%rdi
 10853ea:	4a 8d 44 07 03       	lea    0x3(%rdi,%r8,1),%rax
 10853ef:	4c 01 c7             	add    %r8,%rdi
 10853f2:	48 83 e0 fc          	and    $0xfffffffffffffffc,%rax
 10853f6:	48 39 f8             	cmp    %rdi,%rax
 10853f9:	0f 83 16 60 00 00    	jae    108b415 <check_input_run+0xb105>
 10853ff:	45 31 ed             	xor    %r13d,%r13d
 1085402:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
 1085407:	4c 8b 4c 24 40       	mov    0x40(%rsp),%r9
 108540c:	e9 1f f1 ff ff       	jmp    1084530 <check_input_run+0x4220>
 1085411:	31 ff                	xor    %edi,%edi
 1085413:	48 8b b4 24 60 02 00 	mov    0x260(%rsp),%rsi
 108541a:	00 
 108541b:	4d 85 ed             	test   %r13,%r13
 108541e:	0f 94 c1             	sete   %cl
 1085421:	08 c1                	or     %al,%cl
 1085423:	08 8e bd 03 00 00    	or     %cl,0x3bd(%rsi)
 1085429:	84 c9                	test   %cl,%cl
 108542b:	0f 84 81 3f 00 00    	je     10893b2 <check_input_run+0x90a2>
 1085431:	48 8b 84 24 80 02 00 	mov    0x280(%rsp),%rax
 1085438:	00 
 1085439:	48 8b 8c 24 70 01 00 	mov    0x170(%rsp),%rcx
 1085440:	00 
 1085441:	48 89 48 08          	mov    %rcx,0x8(%rax)
 1085445:	48 8b 84 24 88 02 00 	mov    0x288(%rsp),%rax
 108544c:	00 
 108544d:	4c 89 48 08          	mov    %r9,0x8(%rax)
 1085451:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 1085456:	c6 80 bd 03 00 00 01 	movb   $0x1,0x3bd(%rax)
 108545d:	48 8d bc 24 60 02 00 	lea    0x260(%rsp),%rdi
 1085464:	00 
 1085465:	e8 96 85 00 00       	call   108da00 <check_input_intrinsic_initialize>
 108546a:	62 f1 fd 48 6f 0d 0c 	vmovdqa64 -0xbe72f4(%rip),%zmm1        # 49e180 <cbuiltin_test_generated.edges+0x3a00>
 1085471:	8d 41 ff 
 1085474:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 1085478:	48 8b 8c 24 70 02 00 	mov    0x270(%rsp),%rcx
 108547f:	00 
 1085480:	48 8b 84 24 68 02 00 	mov    0x268(%rsp),%rax
 1085487:	00 
 1085488:	49 b9 6f 76 65 72 6c 	movabs $0x64616f6c7265766f,%r9
 108548f:	6f 61 64 
 1085492:	48 8b b1 70 02 00 00 	mov    0x270(%rcx),%rsi
 1085499:	31 c9                	xor    %ecx,%ecx
 108549b:	62 f2 75 48 dc c8    	vaesenc %zmm0,%zmm1,%zmm1
 10854a1:	4c 8b 46 08          	mov    0x8(%rsi),%r8
 10854a5:	48 8b 3e             	mov    (%rsi),%rdi
 10854a8:	62 f2 75 48 dc c0    	vaesenc %zmm0,%zmm1,%zmm0
 10854ae:	62 f3 fd 48 3b c1 01 	vextracti64x4 $0x1,%zmm0,%ymm1
 10854b5:	62 f1 f5 48 ef c0    	vpxorq %zmm0,%zmm1,%zmm0
 10854bb:	c4 e3 7d 39 c1 01    	vextracti128 $0x1,%ymm0,%xmm1
 10854c1:	c5 f1 ef c0          	vpxor  %xmm0,%xmm1,%xmm0
 10854c5:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
 10854c9:	c4 e2 79 dc c1       	vaesenc %xmm1,%xmm0,%xmm0
 10854ce:	c4 e1 f9 7e c2       	vmovq  %xmm0,%rdx
 10854d3:	62 f2 7d 48 5a 05 53 	vbroadcasti32x4 -0xaf3aad(%rip),%zmm0        # 591a30 <abi_test_hex.digits+0xba0>
 10854da:	c5 50 ff 
 10854dd:	4c 21 c2             	and    %r8,%rdx
 10854e0:	49 89 d2             	mov    %rdx,%r10
 10854e3:	49 c1 e2 06          	shl    $0x6,%r10
 10854e7:	62 b1 fd 48 6f 0c 17 	vmovdqa64 (%rdi,%r10,1),%zmm1
 10854ee:	62 f1 75 48 76 c0    	vpcmpeqd %zmm0,%zmm1,%k0
 10854f4:	c5 7b 93 d8          	kmovd  %k0,%r11d
 10854f8:	41 81 e3 77 77 00 00 	and    $0x7777,%r11d
 10854ff:	41 81 c3 11 11 00 00 	add    $0x1111,%r11d
 1085506:	66 41 81 e3 88 88    	and    $0x8888,%r11w
 108550c:	74 72                	je     1085580 <check_input_run+0x5270>
 108550e:	48 8b 5e 10          	mov    0x10(%rsi),%rbx
 1085512:	49 01 fa             	add    %rdi,%r10
 1085515:	45 0f b7 db          	movzwl %r11w,%r11d
 1085519:	eb 13                	jmp    108552e <check_input_run+0x521e>
 108551b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
 1085520:	31 ed                	xor    %ebp,%ebp
 1085522:	40 84 ed             	test   %bpl,%bpl
 1085525:	75 5b                	jne    1085582 <check_input_run+0x5272>
 1085527:	c4 c2 20 f3 cb       	blsr   %r11d,%r11d
 108552c:	74 54                	je     1085582 <check_input_run+0x5272>
 108552e:	45 31 f6             	xor    %r14d,%r14d
 1085531:	f3 45 0f bc f3       	tzcnt  %r11d,%r14d
 1085536:	47 8b 34 b2          	mov    (%r10,%r14,4),%r14d
 108553a:	42 83 7c f3 04 0c    	cmpl   $0xc,0x4(%rbx,%r14,8)
 1085540:	75 de                	jne    1085520 <check_input_run+0x5210>
 1085542:	4c 8b 7e 40          	mov    0x40(%rsi),%r15
 1085546:	46 8b 24 f3          	mov    (%rbx,%r14,8),%r12d
 108554a:	4f 8b 2c 27          	mov    (%r15,%r12,1),%r13
 108554e:	47 8b 7c 27 08       	mov    0x8(%r15,%r12,1),%r15d
 1085553:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
 1085558:	4d 31 cd             	xor    %r9,%r13
 108555b:	49 81 f7 61 62 6c 65 	xor    $0x656c6261,%r15
 1085562:	4d 09 ef             	or     %r13,%r15
 1085565:	40 0f 94 c5          	sete   %bpl
 1085569:	41 0f 44 ce          	cmove  %r14d,%ecx
 108556d:	40 84 ed             	test   %bpl,%bpl
 1085570:	74 b5                	je     1085527 <check_input_run+0x5217>
 1085572:	eb 0e                	jmp    1085582 <check_input_run+0x5272>
 1085574:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
 108557b:	00 00 00 00 00 
 1085580:	31 ed                	xor    %ebp,%ebp
 1085582:	62 f2 76 48 27 c1    	vptestnmd %zmm1,%zmm1,%k0
 1085588:	c5 7b 93 d0          	kmovd  %k0,%r10d
 108558c:	41 f7 c2 88 88 00 00 	test   $0x8888,%r10d
 1085593:	75 0f                	jne    10855a4 <check_input_run+0x5294>
 1085595:	48 ff c2             	inc    %rdx
 1085598:	4c 21 c2             	and    %r8,%rdx
 108559b:	40 84 ed             	test   %bpl,%bpl
 108559e:	0f 84 3c ff ff ff    	je     10854e0 <check_input_run+0x51d0>
 10855a4:	62 f1 fd 48 6f 0d 52 	vmovdqa64 -0xbe73ae(%rip),%zmm1        # 49e200 <cbuiltin_test_generated.edges+0x3a80>
 10855ab:	8c 41 ff 
 10855ae:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 10855b2:	31 d2                	xor    %edx,%edx
 10855b4:	62 f2 75 48 dc c8    	vaesenc %zmm0,%zmm1,%zmm1
 10855ba:	62 f2 75 48 dc c0    	vaesenc %zmm0,%zmm1,%zmm0
 10855c0:	62 f3 fd 48 3b c1 01 	vextracti64x4 $0x1,%zmm0,%ymm1
 10855c7:	62 f1 f5 48 ef c0    	vpxorq %zmm0,%zmm1,%zmm0
 10855cd:	c4 e3 7d 39 c1 01    	vextracti128 $0x1,%ymm0,%xmm1
 10855d3:	c5 f1 ef c0          	vpxor  %xmm0,%xmm1,%xmm0
 10855d7:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
 10855db:	c4 e2 79 dc c1       	vaesenc %xmm1,%xmm0,%xmm0
 10855e0:	c5 f9 6f 0d d8 c3 50 	vmovdqa -0xaf3c28(%rip),%xmm1        # 5919c0 <abi_test_hex.digits+0xb30>
 10855e7:	ff 
 10855e8:	c4 c1 f9 7e c1       	vmovq  %xmm0,%r9
 10855ed:	62 f2 7d 48 5a 05 c9 	vbroadcasti32x4 -0xaf3c37(%rip),%zmm0        # 5919c0 <abi_test_hex.digits+0xb30>
 10855f4:	c3 50 ff 
 10855f7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
 10855fe:	00 00 
 1085600:	4d 21 c1             	and    %r8,%r9
 1085603:	4d 89 ca             	mov    %r9,%r10
 1085606:	49 c1 e2 06          	shl    $0x6,%r10
 108560a:	62 b1 fd 48 6f 14 17 	vmovdqa64 (%rdi,%r10,1),%zmm2
 1085611:	62 f1 6d 48 76 c0    	vpcmpeqd %zmm0,%zmm2,%k0
 1085617:	c5 7b 93 d8          	kmovd  %k0,%r11d
 108561b:	41 81 e3 77 77 00 00 	and    $0x7777,%r11d
 1085622:	41 81 c3 11 11 00 00 	add    $0x1111,%r11d
 1085629:	66 41 81 e3 88 88    	and    $0x8888,%r11w
 108562f:	74 5f                	je     1085690 <check_input_run+0x5380>
 1085631:	48 8b 5e 10          	mov    0x10(%rsi),%rbx
 1085635:	49 01 fa             	add    %rdi,%r10
 1085638:	45 0f b7 db          	movzwl %r11w,%r11d
 108563c:	eb 10                	jmp    108564e <check_input_run+0x533e>
 108563e:	66 90                	xchg   %ax,%ax
 1085640:	31 ed                	xor    %ebp,%ebp
 1085642:	40 84 ed             	test   %bpl,%bpl
 1085645:	75 4b                	jne    1085692 <check_input_run+0x5382>
 1085647:	c4 c2 20 f3 cb       	blsr   %r11d,%r11d
 108564c:	74 44                	je     1085692 <check_input_run+0x5382>
 108564e:	45 31 f6             	xor    %r14d,%r14d
 1085651:	f3 45 0f bc f3       	tzcnt  %r11d,%r14d
 1085656:	47 8b 34 b2          	mov    (%r10,%r14,4),%r14d
 108565a:	42 83 7c f3 04 10    	cmpl   $0x10,0x4(%rbx,%r14,8)
 1085660:	75 de                	jne    1085640 <check_input_run+0x5330>
 1085662:	4c 8b 7e 40          	mov    0x40(%rsi),%r15
 1085666:	46 8b 24 f3          	mov    (%rbx,%r14,8),%r12d
 108566a:	c4 81 71 ef 1c 27    	vpxor  (%r15,%r12,1),%xmm1,%xmm3
 1085670:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
 1085675:	c4 e2 79 17 db       	vptest %xmm3,%xmm3
 108567a:	40 0f 94 c5          	sete   %bpl
 108567e:	41 0f 44 d6          	cmove  %r14d,%edx
 1085682:	40 84 ed             	test   %bpl,%bpl
 1085685:	74 c0                	je     1085647 <check_input_run+0x5337>
 1085687:	eb 09                	jmp    1085692 <check_input_run+0x5382>
 1085689:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
 1085690:	31 ed                	xor    %ebp,%ebp
 1085692:	62 f2 6e 48 27 c2    	vptestnmd %zmm2,%zmm2,%k0
 1085698:	c5 7b 93 d0          	kmovd  %k0,%r10d
 108569c:	41 f7 c2 88 88 00 00 	test   $0x8888,%r10d
 10856a3:	75 0c                	jne    10856b1 <check_input_run+0x53a1>
 10856a5:	49 ff c1             	inc    %r9
 10856a8:	40 84 ed             	test   %bpl,%bpl
 10856ab:	0f 84 4f ff ff ff    	je     1085600 <check_input_run+0x52f0>
 10856b1:	8b 70 30             	mov    0x30(%rax),%esi
 10856b4:	48 85 f6             	test   %rsi,%rsi
 10856b7:	74 1c                	je     10856d5 <check_input_run+0x53c5>
 10856b9:	4c 8b 40 18          	mov    0x18(%rax),%r8
 10856bd:	4c 8b 48 50          	mov    0x50(%rax),%r9
 10856c1:	83 fe 08             	cmp    $0x8,%esi
 10856c4:	73 1e                	jae    10856e4 <check_input_run+0x53d4>
 10856c6:	45 31 d2             	xor    %r10d,%r10d
 10856c9:	45 31 db             	xor    %r11d,%r11d
 10856cc:	31 db                	xor    %ebx,%ebx
 10856ce:	31 ff                	xor    %edi,%edi
 10856d0:	e9 ab 03 00 00       	jmp    1085a80 <check_input_run+0x5770>
 10856d5:	4c 8b b4 24 60 02 00 	mov    0x260(%rsp),%r14
 10856dc:	00 
 10856dd:	31 ed                	xor    %ebp,%ebp
 10856df:	e9 42 06 00 00       	jmp    1085d26 <check_input_run+0x5a16>
 10856e4:	83 fe 40             	cmp    $0x40,%esi
 10856e7:	73 0f                	jae    10856f8 <check_input_run+0x53e8>
 10856e9:	45 31 d2             	xor    %r10d,%r10d
 10856ec:	45 31 db             	xor    %r11d,%r11d
 10856ef:	31 db                	xor    %ebx,%ebx
 10856f1:	31 ff                	xor    %edi,%edi
 10856f3:	e9 88 02 00 00       	jmp    1085980 <check_input_run+0x5670>
 10856f8:	c4 e2 79 78 3d c2 8b 	vpbroadcastb -0xbe743e(%rip),%xmm7        # 49e2c3 <cbuiltin_test_generated.edges+0x3b43>
 10856ff:	41 ff 
 1085701:	c4 62 79 78 05 ba 8b 	vpbroadcastb -0xbe7446(%rip),%xmm8        # 49e2c4 <cbuiltin_test_generated.edges+0x3b44>
 1085708:	41 ff 
 108570a:	c4 62 79 78 0d b2 8b 	vpbroadcastb -0xbe744e(%rip),%xmm9        # 49e2c5 <cbuiltin_test_generated.edges+0x3b45>
 1085711:	41 ff 
 1085713:	41 89 f2             	mov    %esi,%r10d
 1085716:	41 83 e2 c0          	and    $0xffffffc0,%r10d
 108571a:	62 f2 7d 48 7c e9    	vpbroadcastd %ecx,%zmm5
 1085720:	62 f2 7d 48 7c f2    	vpbroadcastd %edx,%zmm6
 1085726:	c5 fc 47 e0          	kxorw  %k0,%k0,%k4
 108572a:	c5 fc 47 c8          	kxorw  %k0,%k0,%k1
 108572e:	c5 fc 47 d0          	kxorw  %k0,%k0,%k2
 1085732:	c5 fc 47 d8          	kxorw  %k0,%k0,%k3
 1085736:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 108573a:	31 ff                	xor    %edi,%edi
 108573c:	c4 41 29 ef d2       	vpxor  %xmm10,%xmm10,%xmm10
 1085741:	c4 41 21 ef db       	vpxor  %xmm11,%xmm11,%xmm11
 1085746:	c4 41 19 ef e4       	vpxor  %xmm12,%xmm12,%xmm12
 108574b:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
 108574f:	c5 e9 ef d2          	vpxor  %xmm2,%xmm2,%xmm2
 1085753:	c5 e1 ef db          	vpxor  %xmm3,%xmm3,%xmm3
 1085757:	c5 d9 ef e4          	vpxor  %xmm4,%xmm4,%xmm4
 108575b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
 1085760:	62 51 fe 48 6f 2c b8 	vmovdqu64 (%r8,%rdi,4),%zmm13
 1085767:	62 51 fe 48 6f 74 b8 	vmovdqu64 0x40(%r8,%rdi,4),%zmm14
 108576e:	01 
 108576f:	62 51 fe 48 6f 7c b8 	vmovdqu64 0x80(%r8,%rdi,4),%zmm15
 1085776:	02 
 1085777:	62 c1 fe 48 6f 44 b8 	vmovdqu64 0xc0(%r8,%rdi,4),%zmm16
 108577e:	03 
 108577f:	c5 f8 91 5c 24 38    	kmovw  %k3,0x38(%rsp)
 1085785:	c4 e1 f8 90 da       	kmovq  %k2,%k3
 108578a:	c4 e1 f8 90 d1       	kmovq  %k1,%k2
 108578f:	c4 e1 f8 90 cc       	kmovq  %k4,%k1
 1085794:	62 f1 15 48 76 e5    	vpcmpeqd %zmm5,%zmm13,%k4
 108579a:	62 f1 15 48 76 c6    	vpcmpeqd %zmm6,%zmm13,%k0
 10857a0:	62 f1 0d 48 76 ed    	vpcmpeqd %zmm5,%zmm14,%k5
 10857a6:	62 f1 05 48 76 f5    	vpcmpeqd %zmm5,%zmm15,%k6
 10857ac:	62 f1 7d 40 76 fd    	vpcmpeqd %zmm5,%zmm16,%k7
 10857b2:	c5 dc 45 e0          	korw   %k0,%k4,%k4
 10857b6:	62 f1 0d 48 76 c6    	vpcmpeqd %zmm6,%zmm14,%k0
 10857bc:	c5 d4 45 e8          	korw   %k0,%k5,%k5
 10857c0:	62 f1 05 48 76 c6    	vpcmpeqd %zmm6,%zmm15,%k0
 10857c6:	c5 cc 45 f0          	korw   %k0,%k6,%k6
 10857ca:	62 f1 7d 40 76 c6    	vpcmpeqd %zmm6,%zmm16,%k0
 10857d0:	c5 c4 45 f8          	korw   %k0,%k7,%k7
 10857d4:	62 d2 15 4c 27 c5    	vptestmd %zmm13,%zmm13,%k0{%k4}
 10857da:	c4 e1 f8 90 e1       	kmovq  %k1,%k4
 10857df:	c4 e1 f8 90 ca       	kmovq  %k2,%k1
 10857e4:	c4 41 7a 6f 2c 39    	vmovdqu (%r9,%rdi,1),%xmm13
 10857ea:	c4 e1 f8 90 d3       	kmovq  %k3,%k2
 10857ef:	c5 f8 90 5c 24 38    	kmovw  0x38(%rsp),%k3
 10857f5:	c5 dc 45 e0          	korw   %k0,%k4,%k4
 10857f9:	62 d2 0d 4d 27 c6    	vptestmd %zmm14,%zmm14,%k0{%k5}
 10857ff:	c4 41 7a 6f 74 39 10 	vmovdqu 0x10(%r9,%rdi,1),%xmm14
 1085806:	c5 f4 45 c8          	korw   %k0,%k1,%k1
 108580a:	62 d2 05 4e 27 c7    	vptestmd %zmm15,%zmm15,%k0{%k6}
 1085810:	c4 41 7a 6f 7c 39 20 	vmovdqu 0x20(%r9,%rdi,1),%xmm15
 1085817:	c5 ec 45 d0          	korw   %k0,%k2,%k2
 108581b:	62 b2 7d 47 27 c0    	vptestmd %zmm16,%zmm16,%k0{%k7}
 1085821:	62 c1 fe 08 6f 44 39 	vmovdqu64 0x30(%r9,%rdi,1),%xmm16
 1085828:	03 
 1085829:	48 83 c7 40          	add    $0x40,%rdi
 108582d:	c5 e4 45 d8          	korw   %k0,%k3,%k3
 1085831:	62 f1 15 08 74 c7    	vpcmpeqb %xmm7,%xmm13,%k0
 1085837:	c4 41 11 db e8       	vpand  %xmm8,%xmm13,%xmm13
 108583c:	62 e2 7e 48 38 c8    	vpmovm2d %k0,%zmm17
 1085842:	62 f1 0d 08 74 c7    	vpcmpeqb %xmm7,%xmm14,%k0
 1085848:	c4 41 09 db f0       	vpand  %xmm8,%xmm14,%xmm14
 108584d:	62 b1 7d 48 fa c1    	vpsubd %zmm17,%zmm0,%zmm0
 1085853:	62 e2 7e 48 38 d0    	vpmovm2d %k0,%zmm18
 1085859:	62 f1 05 08 74 c7    	vpcmpeqb %xmm7,%xmm15,%k0
 108585f:	c4 41 01 db f8       	vpand  %xmm8,%xmm15,%xmm15
 1085864:	62 31 2d 48 fa d2    	vpsubd %zmm18,%zmm10,%zmm10
 108586a:	62 e2 7e 48 38 d8    	vpmovm2d %k0,%zmm19
 1085870:	62 f1 7d 00 74 c7    	vpcmpeqb %xmm7,%xmm16,%k0
 1085876:	62 c1 fd 00 db c0    	vpandq %xmm8,%xmm16,%xmm16
 108587c:	62 31 25 48 fa db    	vpsubd %zmm19,%zmm11,%zmm11
 1085882:	62 e2 7e 48 38 e0    	vpmovm2d %k0,%zmm20
 1085888:	62 d1 15 08 74 c1    	vpcmpeqb %xmm9,%xmm13,%k0
 108588e:	62 31 1d 48 fa e4    	vpsubd %zmm20,%zmm12,%zmm12
 1085894:	62 72 7e 48 38 e8    	vpmovm2d %k0,%zmm13
 108589a:	62 d1 0d 08 74 c1    	vpcmpeqb %xmm9,%xmm14,%k0
 10858a0:	62 d1 75 48 fa cd    	vpsubd %zmm13,%zmm1,%zmm1
 10858a6:	62 72 7e 48 38 f0    	vpmovm2d %k0,%zmm14
 10858ac:	62 d1 05 08 74 c1    	vpcmpeqb %xmm9,%xmm15,%k0
 10858b2:	62 d1 6d 48 fa d6    	vpsubd %zmm14,%zmm2,%zmm2
 10858b8:	62 72 7e 48 38 f8    	vpmovm2d %k0,%zmm15
 10858be:	62 d1 7d 00 74 c1    	vpcmpeqb %xmm9,%xmm16,%k0
 10858c4:	62 d1 65 48 fa df    	vpsubd %zmm15,%zmm3,%zmm3
 10858ca:	62 e2 7e 48 38 c0    	vpmovm2d %k0,%zmm16
 10858d0:	62 b1 5d 48 fa e0    	vpsubd %zmm16,%zmm4,%zmm4
 10858d6:	49 39 fa             	cmp    %rdi,%r10
 10858d9:	0f 85 81 fe ff ff    	jne    1085760 <check_input_run+0x5450>
 10858df:	62 f1 2d 48 fe c0    	vpaddd %zmm0,%zmm10,%zmm0
 10858e5:	62 d1 1d 48 fe eb    	vpaddd %zmm11,%zmm12,%zmm5
 10858eb:	62 f1 6d 48 fe c9    	vpaddd %zmm1,%zmm2,%zmm1
 10858f1:	62 f1 5d 48 fe d3    	vpaddd %zmm3,%zmm4,%zmm2
 10858f7:	c5 f4 45 c4          	korw   %k4,%k1,%k0
 10858fb:	62 f1 55 48 fe c0    	vpaddd %zmm0,%zmm5,%zmm0
 1085901:	c5 ec 45 c0          	korw   %k0,%k2,%k0
 1085905:	62 f3 fd 48 3b c5 01 	vextracti64x4 $0x1,%zmm0,%ymm5
 108590c:	c5 f8 98 d8          	kortestw %k0,%k3
 1085910:	62 f1 7d 48 fe c5    	vpaddd %zmm5,%zmm0,%zmm0
 1085916:	41 0f 95 c3          	setne  %r11b
 108591a:	c4 e3 7d 39 c5 01    	vextracti128 $0x1,%ymm0,%xmm5
 1085920:	c5 f9 fe c5          	vpaddd %xmm5,%xmm0,%xmm0
 1085924:	c5 f9 70 e8 ee       	vpshufd $0xee,%xmm0,%xmm5
 1085929:	c5 f9 fe c5          	vpaddd %xmm5,%xmm0,%xmm0
 108592d:	c5 f9 70 e8 55       	vpshufd $0x55,%xmm0,%xmm5
 1085932:	c5 f9 fe c5          	vpaddd %xmm5,%xmm0,%xmm0
 1085936:	c5 f9 7e c3          	vmovd  %xmm0,%ebx
 108593a:	62 f1 6d 48 fe c1    	vpaddd %zmm1,%zmm2,%zmm0
 1085940:	62 f3 fd 48 3b c1 01 	vextracti64x4 $0x1,%zmm0,%ymm1
 1085947:	62 f1 7d 48 fe c1    	vpaddd %zmm1,%zmm0,%zmm0
 108594d:	c4 e3 7d 39 c1 01    	vextracti128 $0x1,%ymm0,%xmm1
 1085953:	c5 f9 fe c1          	vpaddd %xmm1,%xmm0,%xmm0
 1085957:	c5 f9 70 c8 ee       	vpshufd $0xee,%xmm0,%xmm1
 108595c:	c5 f9 fe c1          	vpaddd %xmm1,%xmm0,%xmm0
 1085960:	c5 f9 70 c8 55       	vpshufd $0x55,%xmm0,%xmm1
 1085965:	c5 f9 fe c1          	vpaddd %xmm1,%xmm0,%xmm0
 1085969:	c5 f9 7e c7          	vmovd  %xmm0,%edi
 108596d:	41 39 f2             	cmp    %esi,%r10d
 1085970:	0f 84 56 01 00 00    	je     1085acc <check_input_run+0x57bc>
 1085976:	40 f6 c6 38          	test   $0x38,%sil
 108597a:	0f 84 00 01 00 00    	je     1085a80 <check_input_run+0x5770>
 1085980:	c4 e2 79 78 25 3a 89 	vpbroadcastb -0xbe76c6(%rip),%xmm4        # 49e2c3 <cbuiltin_test_generated.edges+0x3b43>
 1085987:	41 ff 
 1085989:	c4 e2 79 78 2d 32 89 	vpbroadcastb -0xbe76ce(%rip),%xmm5        # 49e2c4 <cbuiltin_test_generated.edges+0x3b44>
 1085990:	41 ff 
 1085992:	c4 e2 79 78 35 2a 89 	vpbroadcastb -0xbe76d6(%rip),%xmm6        # 49e2c5 <cbuiltin_test_generated.edges+0x3b45>
 1085999:	41 ff 
 108599b:	4d 89 d6             	mov    %r10,%r14
 108599e:	41 89 f2             	mov    %esi,%r10d
 10859a1:	41 83 e2 f8          	and    $0xfffffff8,%r10d
 10859a5:	45 84 db             	test   %r11b,%r11b
 10859a8:	c5 f9 6e cb          	vmovd  %ebx,%xmm1
 10859ac:	c5 f9 6e c7          	vmovd  %edi,%xmm0
 10859b0:	62 f2 7d 28 7c d1    	vpbroadcastd %ecx,%ymm2
 10859b6:	62 f2 7d 28 7c da    	vpbroadcastd %edx,%ymm3
 10859bc:	41 0f 95 c3          	setne  %r11b
 10859c0:	c4 c1 7b 92 c3       	kmovd  %r11d,%k0
 10859c5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
 10859cc:	00 00 00 00 
 10859d0:	c4 81 7e 6f 3c b0    	vmovdqu (%r8,%r14,4),%ymm7
 10859d6:	62 f1 45 28 76 ca    	vpcmpeqd %ymm2,%ymm7,%k1
 10859dc:	62 f1 45 28 76 d3    	vpcmpeqd %ymm3,%ymm7,%k2
 10859e2:	c5 f5 45 ca          	korb   %k2,%k1,%k1
 10859e6:	62 f2 45 29 27 cf    	vptestmd %ymm7,%ymm7,%k1{%k1}
 10859ec:	c4 81 7a 7e 3c 31    	vmovq  (%r9,%r14,1),%xmm7
 10859f2:	49 83 c6 08          	add    $0x8,%r14
 10859f6:	c5 fd 45 c1          	korb   %k1,%k0,%k0
 10859fa:	62 f1 45 08 74 cc    	vpcmpeqb %xmm4,%xmm7,%k1
 1085a00:	c5 c1 db fd          	vpand  %xmm5,%xmm7,%xmm7
 1085a04:	62 72 7e 28 38 c1    	vpmovm2d %k1,%ymm8
 1085a0a:	62 f1 45 08 74 ce    	vpcmpeqb %xmm6,%xmm7,%k1
 1085a10:	c4 c1 75 fa c8       	vpsubd %ymm8,%ymm1,%ymm1
 1085a15:	62 f2 7e 28 38 f9    	vpmovm2d %k1,%ymm7
 1085a1b:	c5 fd fa c7          	vpsubd %ymm7,%ymm0,%ymm0
 1085a1f:	4d 39 f2             	cmp    %r14,%r10
 1085a22:	75 ac                	jne    10859d0 <check_input_run+0x56c0>
 1085a24:	c4 e3 7d 39 ca 01    	vextracti128 $0x1,%ymm1,%xmm2
 1085a2a:	c5 f9 98 c0          	kortestb %k0,%k0
 1085a2e:	c5 f1 fe ca          	vpaddd %xmm2,%xmm1,%xmm1
 1085a32:	41 0f 95 c3          	setne  %r11b
 1085a36:	c5 f9 70 d1 ee       	vpshufd $0xee,%xmm1,%xmm2
 1085a3b:	c5 f1 fe ca          	vpaddd %xmm2,%xmm1,%xmm1
 1085a3f:	c5 f9 70 d1 55       	vpshufd $0x55,%xmm1,%xmm2
 1085a44:	c5 f1 fe ca          	vpaddd %xmm2,%xmm1,%xmm1
 1085a48:	c5 f9 7e cb          	vmovd  %xmm1,%ebx
 1085a4c:	c4 e3 7d 39 c1 01    	vextracti128 $0x1,%ymm0,%xmm1
 1085a52:	c5 f9 fe c1          	vpaddd %xmm1,%xmm0,%xmm0
 1085a56:	c5 f9 70 c8 ee       	vpshufd $0xee,%xmm0,%xmm1
 1085a5b:	c5 f9 fe c1          	vpaddd %xmm1,%xmm0,%xmm0
 1085a5f:	c5 f9 70 c8 55       	vpshufd $0x55,%xmm0,%xmm1
 1085a64:	c5 f9 fe c1          	vpaddd %xmm1,%xmm0,%xmm0
 1085a68:	c5 f9 7e c7          	vmovd  %xmm0,%edi
 1085a6c:	41 39 f2             	cmp    %esi,%r10d
 1085a6f:	74 5b                	je     1085acc <check_input_run+0x57bc>
 1085a71:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1085a78:	0f 1f 84 00 00 00 00 
 1085a7f:	00 
 1085a80:	43 8b 2c 90          	mov    (%r8,%r10,4),%ebp
 1085a84:	85 ed                	test   %ebp,%ebp
 1085a86:	41 0f 95 c6          	setne  %r14b
 1085a8a:	39 cd                	cmp    %ecx,%ebp
 1085a8c:	41 0f 94 c7          	sete   %r15b
 1085a90:	39 d5                	cmp    %edx,%ebp
 1085a92:	40 0f 94 c5          	sete   %bpl
 1085a96:	44 08 fd             	or     %r15b,%bpl
 1085a99:	47 0f b6 3c 11       	movzbl (%r9,%r10,1),%r15d
 1085a9e:	44 20 f5             	and    %r14b,%bpl
 1085aa1:	45 31 f6             	xor    %r14d,%r14d
 1085aa4:	41 08 eb             	or     %bpl,%r11b
 1085aa7:	41 80 ff 02          	cmp    $0x2,%r15b
 1085aab:	41 0f 94 c6          	sete   %r14b
 1085aaf:	41 80 e7 fe          	and    $0xfe,%r15b
 1085ab3:	44 01 f3             	add    %r14d,%ebx
 1085ab6:	45 31 f6             	xor    %r14d,%r14d
 1085ab9:	41 80 ff 3c          	cmp    $0x3c,%r15b
 1085abd:	41 0f 94 c6          	sete   %r14b
 1085ac1:	49 ff c2             	inc    %r10
 1085ac4:	44 01 f7             	add    %r14d,%edi
 1085ac7:	4c 39 d6             	cmp    %r10,%rsi
 1085aca:	75 b4                	jne    1085a80 <check_input_run+0x5770>
 1085acc:	4c 8b b4 24 60 02 00 	mov    0x260(%rsp),%r14
 1085ad3:	00 
 1085ad4:	41 f6 c3 01          	test   $0x1,%r11b
 1085ad8:	74 31                	je     1085b0b <check_input_run+0x57fb>
 1085ada:	89 9c 24 48 04 00 00 	mov    %ebx,0x448(%rsp)
 1085ae1:	89 d9                	mov    %ebx,%ecx
 1085ae3:	48 ff c1             	inc    %rcx
 1085ae6:	48 8b 94 24 80 02 00 	mov    0x280(%rsp),%rdx
 1085aed:	00 
 1085aee:	4c 8b 02             	mov    (%rdx),%r8
 1085af1:	4c 8b 4a 08          	mov    0x8(%rdx),%r9
 1085af5:	4b 8d 74 01 03       	lea    0x3(%r9,%r8,1),%rsi
 1085afa:	4d 01 c1             	add    %r8,%r9
 1085afd:	48 83 e6 fc          	and    $0xfffffffffffffffc,%rsi
 1085b01:	4c 39 ce             	cmp    %r9,%rsi
 1085b04:	73 0c                	jae    1085b12 <check_input_run+0x5802>
 1085b06:	45 31 c0             	xor    %r8d,%r8d
 1085b09:	eb 37                	jmp    1085b42 <check_input_run+0x5832>
 1085b0b:	31 ed                	xor    %ebp,%ebp
 1085b0d:	e9 14 02 00 00       	jmp    1085d26 <check_input_run+0x5a16>
 1085b12:	4c 8b 52 10          	mov    0x10(%rdx),%r10
 1085b16:	49 89 f1             	mov    %rsi,%r9
 1085b19:	4d 29 c1             	sub    %r8,%r9
 1085b1c:	45 31 c0             	xor    %r8d,%r8d
 1085b1f:	4d 29 ca             	sub    %r9,%r10
 1085b22:	72 1e                	jb     1085b42 <check_input_run+0x5832>
 1085b24:	49 89 cb             	mov    %rcx,%r11
 1085b27:	49 c1 e3 05          	shl    $0x5,%r11
 1085b2b:	4d 39 d3             	cmp    %r10,%r11
 1085b2e:	77 12                	ja     1085b42 <check_input_run+0x5832>
 1085b30:	4d 01 d9             	add    %r11,%r9
 1085b33:	49 89 f0             	mov    %rsi,%r8
 1085b36:	4c 89 4a 08          	mov    %r9,0x8(%rdx)
 1085b3a:	48 8b 94 24 80 02 00 	mov    0x280(%rsp),%rdx
 1085b41:	00 
 1085b42:	4c 89 84 24 40 04 00 	mov    %r8,0x440(%rsp)
 1085b49:	00 
 1085b4a:	4c 8b 02             	mov    (%rdx),%r8
 1085b4d:	4c 8b 4a 08          	mov    0x8(%rdx),%r9
 1085b51:	4b 8d 74 01 03       	lea    0x3(%r9,%r8,1),%rsi
 1085b56:	4d 01 c1             	add    %r8,%r9
 1085b59:	48 83 e6 fc          	and    $0xfffffffffffffffc,%rsi
 1085b5d:	4c 39 ce             	cmp    %r9,%rsi
 1085b60:	73 05                	jae    1085b67 <check_input_run+0x5857>
 1085b62:	45 31 c0             	xor    %r8d,%r8d
 1085b65:	eb 2d                	jmp    1085b94 <check_input_run+0x5884>
 1085b67:	4c 8b 52 10          	mov    0x10(%rdx),%r10
 1085b6b:	49 89 f1             	mov    %rsi,%r9
 1085b6e:	4d 29 c1             	sub    %r8,%r9
 1085b71:	45 31 c0             	xor    %r8d,%r8d
 1085b74:	4d 29 ca             	sub    %r9,%r10
 1085b77:	72 1b                	jb     1085b94 <check_input_run+0x5884>
 1085b79:	44 8b 58 30          	mov    0x30(%rax),%r11d
 1085b7d:	4e 8d 1c 9d 04 00 00 	lea    0x4(,%r11,4),%r11
 1085b84:	00 
 1085b85:	4d 39 d3             	cmp    %r10,%r11
 1085b88:	77 0a                	ja     1085b94 <check_input_run+0x5884>
 1085b8a:	4d 01 d9             	add    %r11,%r9
 1085b8d:	49 89 f0             	mov    %rsi,%r8
 1085b90:	4c 89 4a 08          	mov    %r9,0x8(%rdx)
 1085b94:	4d 89 86 20 02 00 00 	mov    %r8,0x220(%r14)
 1085b9b:	48 8b 94 24 88 02 00 	mov    0x288(%rsp),%rdx
 1085ba2:	00 
 1085ba3:	4c 8b 02             	mov    (%rdx),%r8
 1085ba6:	4c 8b 4a 08          	mov    0x8(%rdx),%r9
 1085baa:	4b 8d 74 01 03       	lea    0x3(%r9,%r8,1),%rsi
 1085baf:	4d 01 c1             	add    %r8,%r9
 1085bb2:	48 83 e6 fc          	and    $0xfffffffffffffffc,%rsi
 1085bb6:	4c 39 ce             	cmp    %r9,%rsi
 1085bb9:	73 05                	jae    1085bc0 <check_input_run+0x58b0>
 1085bbb:	45 31 c0             	xor    %r8d,%r8d
 1085bbe:	eb 40                	jmp    1085c00 <check_input_run+0x58f0>
 1085bc0:	4c 8b 52 10          	mov    0x10(%rdx),%r10
 1085bc4:	49 89 f1             	mov    %rsi,%r9
 1085bc7:	4d 29 c1             	sub    %r8,%r9
 1085bca:	45 31 c0             	xor    %r8d,%r8d
 1085bcd:	4d 29 ca             	sub    %r9,%r10
 1085bd0:	72 2e                	jb     1085c00 <check_input_run+0x58f0>
 1085bd2:	4c 8b 9c 24 70 02 00 	mov    0x270(%rsp),%r11
 1085bd9:	00 
 1085bda:	4d 8b 9b 70 02 00 00 	mov    0x270(%r11),%r11
 1085be1:	45 8b 5b 68          	mov    0x68(%r11),%r11d
 1085be5:	49 c1 e3 02          	shl    $0x2,%r11
 1085be9:	4d 39 d3             	cmp    %r10,%r11
 1085bec:	77 12                	ja     1085c00 <check_input_run+0x58f0>
 1085bee:	4d 01 d9             	add    %r11,%r9
 1085bf1:	49 89 f0             	mov    %rsi,%r8
 1085bf4:	4c 89 4a 08          	mov    %r9,0x8(%rdx)
 1085bf8:	48 8b 94 24 88 02 00 	mov    0x288(%rsp),%rdx
 1085bff:	00 
 1085c00:	4c 89 84 24 50 04 00 	mov    %r8,0x450(%rsp)
 1085c07:	00 
 1085c08:	4c 8b 02             	mov    (%rdx),%r8
 1085c0b:	4c 8b 4a 08          	mov    0x8(%rdx),%r9
 1085c0f:	4b 8d 74 01 03       	lea    0x3(%r9,%r8,1),%rsi
 1085c14:	4d 01 c1             	add    %r8,%r9
 1085c17:	48 83 e6 fc          	and    $0xfffffffffffffffc,%rsi
 1085c1b:	4c 39 ce             	cmp    %r9,%rsi
 1085c1e:	73 05                	jae    1085c25 <check_input_run+0x5915>
 1085c20:	45 31 c0             	xor    %r8d,%r8d
 1085c23:	eb 25                	jmp    1085c4a <check_input_run+0x593a>
 1085c25:	4c 8b 52 10          	mov    0x10(%rdx),%r10
 1085c29:	49 89 f1             	mov    %rsi,%r9
 1085c2c:	4d 29 c1             	sub    %r8,%r9
 1085c2f:	45 31 c0             	xor    %r8d,%r8d
 1085c32:	4d 29 ca             	sub    %r9,%r10
 1085c35:	72 13                	jb     1085c4a <check_input_run+0x593a>
 1085c37:	48 c1 e1 02          	shl    $0x2,%rcx
 1085c3b:	4c 39 d1             	cmp    %r10,%rcx
 1085c3e:	77 0a                	ja     1085c4a <check_input_run+0x593a>
 1085c40:	49 01 c9             	add    %rcx,%r9
 1085c43:	49 89 f0             	mov    %rsi,%r8
 1085c46:	4c 89 4a 08          	mov    %r9,0x8(%rdx)
 1085c4a:	4c 89 84 24 58 04 00 	mov    %r8,0x458(%rsp)
 1085c51:	00 
 1085c52:	48 8b 94 24 80 02 00 	mov    0x280(%rsp),%rdx
 1085c59:	00 
 1085c5a:	48 8b 0a             	mov    (%rdx),%rcx
 1085c5d:	4c 8b 42 08          	mov    0x8(%rdx),%r8
 1085c61:	49 8d 74 08 03       	lea    0x3(%r8,%rcx,1),%rsi
 1085c66:	49 01 c8             	add    %rcx,%r8
 1085c69:	48 83 e6 fc          	and    $0xfffffffffffffffc,%rsi
 1085c6d:	4c 39 c6             	cmp    %r8,%rsi
 1085c70:	73 04                	jae    1085c76 <check_input_run+0x5966>
 1085c72:	31 c9                	xor    %ecx,%ecx
 1085c74:	eb 2b                	jmp    1085ca1 <check_input_run+0x5991>
 1085c76:	4c 8b 4a 10          	mov    0x10(%rdx),%r9
 1085c7a:	49 89 f0             	mov    %rsi,%r8
 1085c7d:	49 29 c8             	sub    %rcx,%r8
 1085c80:	31 c9                	xor    %ecx,%ecx
 1085c82:	4d 29 c1             	sub    %r8,%r9
 1085c85:	72 1a                	jb     1085ca1 <check_input_run+0x5991>
 1085c87:	41 89 fa             	mov    %edi,%r10d
 1085c8a:	4e 8d 14 d5 08 00 00 	lea    0x8(,%r10,8),%r10
 1085c91:	00 
 1085c92:	4d 39 ca             	cmp    %r9,%r10
 1085c95:	77 0a                	ja     1085ca1 <check_input_run+0x5991>
 1085c97:	4d 01 d0             	add    %r10,%r8
 1085c9a:	48 89 f1             	mov    %rsi,%rcx
 1085c9d:	4c 89 42 08          	mov    %r8,0x8(%rdx)
 1085ca1:	49 89 8e 10 01 00 00 	mov    %rcx,0x110(%r14)
 1085ca8:	41 89 be 1c 01 00 00 	mov    %edi,0x11c(%r14)
 1085caf:	40 b5 01             	mov    $0x1,%bpl
 1085cb2:	48 8b 94 24 40 04 00 	mov    0x440(%rsp),%rdx
 1085cb9:	00 
 1085cba:	49 89 96 00 01 00 00 	mov    %rdx,0x100(%r14)
 1085cc1:	48 85 d2             	test   %rdx,%rdx
 1085cc4:	74 60                	je     1085d26 <check_input_run+0x5a16>
 1085cc6:	49 8b be 20 02 00 00 	mov    0x220(%r14),%rdi
 1085ccd:	48 85 ff             	test   %rdi,%rdi
 1085cd0:	74 54                	je     1085d26 <check_input_run+0x5a16>
 1085cd2:	48 8b 9c 24 50 04 00 	mov    0x450(%rsp),%rbx
 1085cd9:	00 
 1085cda:	48 85 db             	test   %rbx,%rbx
 1085cdd:	74 47                	je     1085d26 <check_input_run+0x5a16>
 1085cdf:	48 85 c9             	test   %rcx,%rcx
 1085ce2:	74 42                	je     1085d26 <check_input_run+0x5a16>
 1085ce4:	48 83 bc 24 58 04 00 	cmpq   $0x0,0x458(%rsp)
 1085ceb:	00 00 
 1085ced:	74 37                	je     1085d26 <check_input_run+0x5a16>
 1085cef:	8b 40 30             	mov    0x30(%rax),%eax
 1085cf2:	31 ed                	xor    %ebp,%ebp
 1085cf4:	31 f6                	xor    %esi,%esi
 1085cf6:	48 8d 14 85 04 00 00 	lea    0x4(,%rax,4),%rdx
 1085cfd:	00 
 1085cfe:	c5 f8 77             	vzeroupper
 1085d01:	e8 7a 92 70 ff       	call   78ef80 <memset@plt>
 1085d06:	48 8b 84 24 70 02 00 	mov    0x270(%rsp),%rax
 1085d0d:	00 
 1085d0e:	48 89 df             	mov    %rbx,%rdi
 1085d11:	31 f6                	xor    %esi,%esi
 1085d13:	48 8b 80 70 02 00 00 	mov    0x270(%rax),%rax
 1085d1a:	8b 50 68             	mov    0x68(%rax),%edx
 1085d1d:	48 c1 e2 02          	shl    $0x2,%rdx
 1085d21:	e8 5a 92 70 ff       	call   78ef80 <memset@plt>
 1085d26:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
 1085d2b:	41 08 ae bd 03 00 00 	or     %bpl,0x3bd(%r14)
 1085d32:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
 1085d37:	0f b6 40 60          	movzbl 0x60(%rax),%eax
 1085d3b:	83 f8 01             	cmp    $0x1,%eax
 1085d3e:	74 32                	je     1085d72 <check_input_run+0x5a62>
 1085d40:	85 c0                	test   %eax,%eax
 1085d42:	75 43                	jne    1085d87 <check_input_run+0x5a77>
 1085d44:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
 1085d49:	48 8d 78 28          	lea    0x28(%rax),%rdi
 1085d4d:	c5 f8 77             	vzeroupper
 1085d50:	e8 8b e9 f9 ff       	call   10246e0 <predefines_eval_method>
 1085d55:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
 1085d5a:	85 c0                	test   %eax,%eax
 1085d5c:	0f 94 c0             	sete   %al
 1085d5f:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
 1085d64:	80 ba d4 01 00 00 00 	cmpb   $0x0,0x1d4(%rdx)
 1085d6b:	74 2a                	je     1085d97 <check_input_run+0x5a87>
 1085d6d:	e9 a2 00 00 00       	jmp    1085e14 <check_input_run+0x5b04>
 1085d72:	b0 01                	mov    $0x1,%al
 1085d74:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
 1085d79:	80 ba d4 01 00 00 00 	cmpb   $0x0,0x1d4(%rdx)
 1085d80:	74 15                	je     1085d97 <check_input_run+0x5a87>
 1085d82:	e9 8d 00 00 00       	jmp    1085e14 <check_input_run+0x5b04>
 1085d87:	31 c0                	xor    %eax,%eax
 1085d89:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
 1085d8e:	80 ba d4 01 00 00 00 	cmpb   $0x0,0x1d4(%rdx)
 1085d95:	75 7d                	jne    1085e14 <check_input_run+0x5b04>
 1085d97:	80 7a 61 00          	cmpb   $0x0,0x61(%rdx)
 1085d9b:	75 77                	jne    1085e14 <check_input_run+0x5b04>
 1085d9d:	80 7a 62 00          	cmpb   $0x0,0x62(%rdx)
 1085da1:	75 71                	jne    1085e14 <check_input_run+0x5b04>
 1085da3:	80 ba cc 01 00 00 00 	cmpb   $0x0,0x1cc(%rdx)
 1085daa:	0f 94 c1             	sete   %cl
 1085dad:	84 c1                	test   %al,%cl
 1085daf:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
 1085db4:	74 5e                	je     1085e14 <check_input_run+0x5b04>
 1085db6:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 1085dbb:	80 b8 bd 03 00 00 00 	cmpb   $0x0,0x3bd(%rax)
 1085dc2:	0f 85 b5 00 00 00    	jne    1085e7d <check_input_run+0x5b6d>
 1085dc8:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
 1085dcd:	4c 8b 94 24 68 02 00 	mov    0x268(%rsp),%r10
 1085dd4:	00 
 1085dd5:	45 8b 4a 30          	mov    0x30(%r10),%r9d
 1085dd9:	8b 80 18 0c 00 00    	mov    0xc18(%rax),%eax
 1085ddf:	48 85 c0             	test   %rax,%rax
 1085de2:	0f 84 67 26 00 00    	je     108844f <check_input_run+0x813f>
 1085de8:	48 8b 4c 24 48       	mov    0x48(%rsp),%rcx
 1085ded:	31 d2                	xor    %edx,%edx
 1085def:	48 8b 89 10 0c 00 00 	mov    0xc10(%rcx),%rcx
 1085df6:	48 83 c1 28          	add    $0x28,%rcx
 1085dfa:	80 39 00             	cmpb   $0x0,(%rcx)
 1085dfd:	0f 85 d7 21 00 00    	jne    1087fda <check_input_run+0x7cca>
 1085e03:	48 ff c2             	inc    %rdx
 1085e06:	48 83 c1 38          	add    $0x38,%rcx
 1085e0a:	48 39 d0             	cmp    %rdx,%rax
 1085e0d:	75 eb                	jne    1085dfa <check_input_run+0x5aea>
 1085e0f:	e9 3b 26 00 00       	jmp    108844f <check_input_run+0x813f>
 1085e14:	41 8b 86 30 02 00 00 	mov    0x230(%r14),%eax
 1085e1b:	41 3b 86 34 02 00 00 	cmp    0x234(%r14),%eax
 1085e22:	73 51                	jae    1085e75 <check_input_run+0x5b65>
 1085e24:	41 0f b6 8e bd 03 00 	movzbl 0x3bd(%r14),%ecx
 1085e2b:	00 
 1085e2c:	49 8b 96 28 02 00 00 	mov    0x228(%r14),%rdx
 1085e33:	8d 70 01             	lea    0x1(%rax),%esi
 1085e36:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
 1085e3a:	41 89 b6 30 02 00 00 	mov    %esi,0x230(%r14)
 1085e41:	83 f1 01             	xor    $0x1,%ecx
 1085e44:	c7 04 82 00 00 00 00 	movl   $0x0,(%rdx,%rax,4)
 1085e4b:	8d 4c 49 04          	lea    0x4(%rcx,%rcx,2),%ecx
 1085e4f:	89 4c 82 04          	mov    %ecx,0x4(%rdx,%rax,4)
 1085e53:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
 1085e58:	c7 44 82 08 00 00 00 	movl   $0x0,0x8(%rdx,%rax,4)
 1085e5f:	00 
 1085e60:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 1085e65:	0f b6 80 bd 03 00 00 	movzbl 0x3bd(%rax),%eax
 1085e6c:	84 c0                	test   %al,%al
 1085e6e:	74 21                	je     1085e91 <check_input_run+0x5b81>
 1085e70:	e9 1b 34 00 00       	jmp    1089290 <check_input_run+0x8f80>
 1085e75:	41 c6 86 bd 03 00 00 	movb   $0x1,0x3bd(%r14)
 1085e7c:	01 
 1085e7d:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 1085e82:	0f b6 80 bd 03 00 00 	movzbl 0x3bd(%rax),%eax
 1085e89:	84 c0                	test   %al,%al
 1085e8b:	0f 85 ff 33 00 00    	jne    1089290 <check_input_run+0x8f80>
 1085e91:	80 bc 24 f8 02 00 00 	cmpb   $0x0,0x2f8(%rsp)
 1085e98:	00 
 1085e99:	0f 84 f1 33 00 00    	je     1089290 <check_input_run+0x8f80>
 1085e9f:	8b 8c 24 18 07 00 00 	mov    0x718(%rsp),%ecx
 1085ea6:	85 c9                	test   %ecx,%ecx
 1085ea8:	74 25                	je     1085ecf <check_input_run+0x5bbf>
 1085eaa:	89 c8                	mov    %ecx,%eax
 1085eac:	83 e0 fe             	and    $0xfffffffe,%eax
 1085eaf:	83 f8 04             	cmp    $0x4,%eax
 1085eb2:	75 32                	jne    1085ee6 <check_input_run+0x5bd6>
 1085eb4:	31 f6                	xor    %esi,%esi
 1085eb6:	83 f9 04             	cmp    $0x4,%ecx
 1085eb9:	48 8d bc 24 60 02 00 	lea    0x260(%rsp),%rdi
 1085ec0:	00 
 1085ec1:	40 0f 94 c6          	sete   %sil
 1085ec5:	c5 f8 77             	vzeroupper
 1085ec8:	e8 a3 7d 08 00       	call   110dc70 <check_input_binding_parser>
 1085ecd:	eb 29                	jmp    1085ef8 <check_input_run+0x5be8>
 1085ecf:	48 8b 84 24 68 02 00 	mov    0x268(%rsp),%rax
 1085ed6:	00 
 1085ed7:	0f b6 08             	movzbl (%rax),%ecx
 1085eda:	ff c1                	inc    %ecx
 1085edc:	89 c8                	mov    %ecx,%eax
 1085ede:	83 e0 fe             	and    $0xfffffffe,%eax
 1085ee1:	83 f8 04             	cmp    $0x4,%eax
 1085ee4:	74 ce                	je     1085eb4 <check_input_run+0x5ba4>
 1085ee6:	48 8d bc 24 60 02 00 	lea    0x260(%rsp),%rdi
 1085eed:	00 
 1085eee:	89 ce                	mov    %ecx,%esi
 1085ef0:	c5 f8 77             	vzeroupper
 1085ef3:	e8 68 80 08 00       	call   110df60 <check_input_binding_events>
 1085ef8:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 1085efd:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
 1085f02:	8b 80 30 02 00 00    	mov    0x230(%rax),%eax
 1085f08:	48 85 c0             	test   %rax,%rax
 1085f0b:	0f 84 3d 01 00 00    	je     108604e <check_input_run+0x5d3e>
 1085f11:	44 8b 84 24 30 06 00 	mov    0x630(%rsp),%r8d
 1085f18:	00 
 1085f19:	89 c1                	mov    %eax,%ecx
 1085f1b:	83 e1 07             	and    $0x7,%ecx
 1085f1e:	83 f8 08             	cmp    $0x8,%eax
 1085f21:	73 07                	jae    1085f2a <check_input_run+0x5c1a>
 1085f23:	31 d2                	xor    %edx,%edx
 1085f25:	e9 f4 00 00 00       	jmp    108601e <check_input_run+0x5d0e>
 1085f2a:	89 c2                	mov    %eax,%edx
 1085f2c:	c1 ea 03             	shr    $0x3,%edx
 1085f2f:	31 ff                	xor    %edi,%edi
 1085f31:	48 c1 e2 05          	shl    $0x5,%rdx
 1085f35:	48 8d 34 52          	lea    (%rdx,%rdx,2),%rsi
 1085f39:	31 d2                	xor    %edx,%edx
 1085f3b:	eb 1c                	jmp    1085f59 <check_input_run+0x5c49>
 1085f3d:	0f 1f 00             	nopl   (%rax)
 1085f40:	48 83 c2 08          	add    $0x8,%rdx
 1085f44:	48 83 c7 60          	add    $0x60,%rdi
 1085f48:	44 89 84 24 30 06 00 	mov    %r8d,0x630(%rsp)
 1085f4f:	00 
 1085f50:	48 39 fe             	cmp    %rdi,%rsi
 1085f53:	0f 84 c0 00 00 00    	je     1086019 <check_input_run+0x5d09>
 1085f59:	4d 8b 0b             	mov    (%r11),%r9
 1085f5c:	45 8b 0c 39          	mov    (%r9,%rdi,1),%r9d
 1085f60:	45 39 c1             	cmp    %r8d,%r9d
 1085f63:	72 03                	jb     1085f68 <check_input_run+0x5c58>
 1085f65:	45 89 c1             	mov    %r8d,%r9d
 1085f68:	44 89 8c 24 30 06 00 	mov    %r9d,0x630(%rsp)
 1085f6f:	00 
 1085f70:	4d 8b 03             	mov    (%r11),%r8
 1085f73:	45 8b 44 38 0c       	mov    0xc(%r8,%rdi,1),%r8d
 1085f78:	45 39 c8             	cmp    %r9d,%r8d
 1085f7b:	72 03                	jb     1085f80 <check_input_run+0x5c70>
 1085f7d:	45 89 c8             	mov    %r9d,%r8d
 1085f80:	44 89 84 24 30 06 00 	mov    %r8d,0x630(%rsp)
 1085f87:	00 
 1085f88:	4d 8b 0b             	mov    (%r11),%r9
 1085f8b:	45 8b 4c 39 18       	mov    0x18(%r9,%rdi,1),%r9d
 1085f90:	45 39 c1             	cmp    %r8d,%r9d
 1085f93:	72 03                	jb     1085f98 <check_input_run+0x5c88>
 1085f95:	45 89 c1             	mov    %r8d,%r9d
 1085f98:	44 89 8c 24 30 06 00 	mov    %r9d,0x630(%rsp)
 1085f9f:	00 
 1085fa0:	4d 8b 03             	mov    (%r11),%r8
 1085fa3:	45 8b 44 38 24       	mov    0x24(%r8,%rdi,1),%r8d
 1085fa8:	45 39 c8             	cmp    %r9d,%r8d
 1085fab:	72 03                	jb     1085fb0 <check_input_run+0x5ca0>
 1085fad:	45 89 c8             	mov    %r9d,%r8d
 1085fb0:	44 89 84 24 30 06 00 	mov    %r8d,0x630(%rsp)
 1085fb7:	00 
 1085fb8:	4d 8b 0b             	mov    (%r11),%r9
 1085fbb:	45 8b 4c 39 30       	mov    0x30(%r9,%rdi,1),%r9d
 1085fc0:	45 39 c1             	cmp    %r8d,%r9d
 1085fc3:	72 03                	jb     1085fc8 <check_input_run+0x5cb8>
 1085fc5:	45 89 c1             	mov    %r8d,%r9d
 1085fc8:	44 89 8c 24 30 06 00 	mov    %r9d,0x630(%rsp)
 1085fcf:	00 
 1085fd0:	4d 8b 03             	mov    (%r11),%r8
 1085fd3:	45 8b 44 38 3c       	mov    0x3c(%r8,%rdi,1),%r8d
 1085fd8:	45 39 c8             	cmp    %r9d,%r8d
 1085fdb:	72 03                	jb     1085fe0 <check_input_run+0x5cd0>
 1085fdd:	45 89 c8             	mov    %r9d,%r8d
 1085fe0:	44 89 84 24 30 06 00 	mov    %r8d,0x630(%rsp)
 1085fe7:	00 
 1085fe8:	4d 8b 0b             	mov    (%r11),%r9
 1085feb:	45 8b 4c 39 48       	mov    0x48(%r9,%rdi,1),%r9d
 1085ff0:	45 39 c1             	cmp    %r8d,%r9d
 1085ff3:	72 03                	jb     1085ff8 <check_input_run+0x5ce8>
 1085ff5:	45 89 c1             	mov    %r8d,%r9d
 1085ff8:	44 89 8c 24 30 06 00 	mov    %r9d,0x630(%rsp)
 1085fff:	00 
 1086000:	4d 8b 03             	mov    (%r11),%r8
 1086003:	45 8b 44 38 54       	mov    0x54(%r8,%rdi,1),%r8d
 1086008:	45 39 c8             	cmp    %r9d,%r8d
 108600b:	0f 82 2f ff ff ff    	jb     1085f40 <check_input_run+0x5c30>
 1086011:	45 89 c8             	mov    %r9d,%r8d
 1086014:	e9 27 ff ff ff       	jmp    1085f40 <check_input_run+0x5c30>
 1086019:	48 85 c9             	test   %rcx,%rcx
 108601c:	74 30                	je     108604e <check_input_run+0x5d3e>
 108601e:	48 c1 e2 02          	shl    $0x2,%rdx
 1086022:	48 8d 14 52          	lea    (%rdx,%rdx,2),%rdx
 1086026:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 108602d:	00 00 00 
 1086030:	49 8b 33             	mov    (%r11),%rsi
 1086033:	8b 34 16             	mov    (%rsi,%rdx,1),%esi
 1086036:	44 39 c6             	cmp    %r8d,%esi
 1086039:	44 0f 42 c6          	cmovb  %esi,%r8d
 108603d:	48 83 c2 0c          	add    $0xc,%rdx
 1086041:	48 ff c9             	dec    %rcx
 1086044:	44 89 84 24 30 06 00 	mov    %r8d,0x630(%rsp)
 108604b:	00 
 108604c:	75 e2                	jne    1086030 <check_input_run+0x5d20>
 108604e:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
 1086053:	80 b9 bd 03 00 00 00 	cmpb   $0x0,0x3bd(%rcx)
 108605a:	0f 85 de d3 ff ff    	jne    108343e <check_input_run+0x312e>
 1086060:	4c 8b 8c 24 68 02 00 	mov    0x268(%rsp),%r9
 1086067:	00 
 1086068:	41 8b 49 30          	mov    0x30(%r9),%ecx
 108606c:	85 c9                	test   %ecx,%ecx
 108606e:	0f 84 52 15 00 00    	je     10875c6 <check_input_run+0x72b6>
 1086074:	4c 8d bc 24 d8 01 00 	lea    0x1d8(%rsp),%r15
 108607b:	00 
 108607c:	31 ed                	xor    %ebp,%ebp
 108607e:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 1086082:	eb 1a                	jmp    108609e <check_input_run+0x5d8e>
 1086084:	c6 80 bd 03 00 00 01 	movb   $0x1,0x3bd(%rax)
 108608b:	41 8b 49 30          	mov    0x30(%r9),%ecx
 108608f:	90                   	nop
 1086090:	48 ff c5             	inc    %rbp
 1086093:	89 c8                	mov    %ecx,%eax
 1086095:	48 39 c5             	cmp    %rax,%rbp
 1086098:	0f 83 1d 15 00 00    	jae    10875bb <check_input_run+0x72ab>
 108609e:	49 8b 41 68          	mov    0x68(%r9),%rax
 10860a2:	48 8b 94 24 d0 05 00 	mov    0x5d0(%rsp),%rdx
 10860a9:	00 
 10860aa:	bb 00 00 00 00       	mov    $0x0,%ebx
 10860af:	44 8b 34 a8          	mov    (%rax,%rbp,4),%r14d
 10860b3:	42 8b 14 b2          	mov    (%rdx,%r14,4),%edx
 10860b7:	39 ca                	cmp    %ecx,%edx
 10860b9:	73 07                	jae    10860c2 <check_input_run+0x5db2>
 10860bb:	49 8b 41 18          	mov    0x18(%r9),%rax
 10860bf:	8b 1c 90             	mov    (%rax,%rdx,4),%ebx
 10860c2:	48 8b 84 24 c8 05 00 	mov    0x5c8(%rsp),%rax
 10860c9:	00 
 10860ca:	42 8b 04 b0          	mov    (%rax,%r14,4),%eax
 10860ce:	3b 84 24 30 06 00 00 	cmp    0x630(%rsp),%eax
 10860d5:	73 b9                	jae    1086090 <check_input_run+0x5d80>
 10860d7:	48 8b 84 24 98 03 00 	mov    0x398(%rsp),%rax
 10860de:	00 
 10860df:	42 80 3c 30 00       	cmpb   $0x0,(%rax,%r14,1)
 10860e4:	75 aa                	jne    1086090 <check_input_run+0x5d80>
 10860e6:	49 8b 41 50          	mov    0x50(%r9),%rax
 10860ea:	42 80 3c 30 48       	cmpb   $0x48,(%rax,%r14,1)
 10860ef:	75 9f                	jne    1086090 <check_input_run+0x5d80>
 10860f1:	83 fb 4c             	cmp    $0x4c,%ebx
 10860f4:	74 05                	je     10860fb <check_input_run+0x5deb>
 10860f6:	83 fb 28             	cmp    $0x28,%ebx
 10860f9:	75 95                	jne    1086090 <check_input_run+0x5d80>
 10860fb:	8d 7a 02             	lea    0x2(%rdx),%edi
 10860fe:	48 89 94 24 70 01 00 	mov    %rdx,0x170(%rsp)
 1086105:	00 
 1086106:	44 39 f7             	cmp    %r14d,%edi
 1086109:	73 69                	jae    1086174 <check_input_run+0x5e64>
 108610b:	49 8b 41 10          	mov    0x10(%r9),%rax
 108610f:	89 f9                	mov    %edi,%ecx
 1086111:	eb 36                	jmp    1086149 <check_input_run+0x5e39>
 1086113:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 108611a:	84 00 00 00 00 00 
 1086120:	83 fe 0a             	cmp    $0xa,%esi
 1086123:	75 3b                	jne    1086160 <check_input_run+0x5e50>
 1086125:	49 8b 71 60          	mov    0x60(%r9),%rsi
 1086129:	8b 14 96             	mov    (%rsi,%rdx,4),%edx
 108612c:	44 8d 6a 01          	lea    0x1(%rdx),%r13d
 1086130:	44 39 f2             	cmp    %r14d,%edx
 1086133:	45 0f 43 ee          	cmovae %r14d,%r13d
 1086137:	39 ca                	cmp    %ecx,%edx
 1086139:	45 0f 46 ee          	cmovbe %r14d,%r13d
 108613d:	44 89 e9             	mov    %r13d,%ecx
 1086140:	45 39 f5             	cmp    %r14d,%r13d
 1086143:	0f 83 96 00 00 00    	jae    10861df <check_input_run+0x5ecf>
 1086149:	89 ca                	mov    %ecx,%edx
 108614b:	0f b6 34 10          	movzbl (%rax,%rdx,1),%esi
 108614f:	83 fe 09             	cmp    $0x9,%esi
 1086152:	7f cc                	jg     1086120 <check_input_run+0x5e10>
 1086154:	83 fe 06             	cmp    $0x6,%esi
 1086157:	74 cc                	je     1086125 <check_input_run+0x5e15>
 1086159:	83 fe 08             	cmp    $0x8,%esi
 108615c:	74 c7                	je     1086125 <check_input_run+0x5e15>
 108615e:	eb 05                	jmp    1086165 <check_input_run+0x5e55>
 1086160:	83 fe 33             	cmp    $0x33,%esi
 1086163:	74 77                	je     10861dc <check_input_run+0x5ecc>
 1086165:	ff c1                	inc    %ecx
 1086167:	41 89 cd             	mov    %ecx,%r13d
 108616a:	44 89 e9             	mov    %r13d,%ecx
 108616d:	45 39 f5             	cmp    %r14d,%r13d
 1086170:	72 d7                	jb     1086149 <check_input_run+0x5e39>
 1086172:	eb 6b                	jmp    10861df <check_input_run+0x5ecf>
 1086174:	62 f1 fe 48 7f 44 24 	vmovdqu64 %zmm0,0x200(%rsp)
 108617b:	08 
 108617c:	62 f1 fe 48 7f 84 24 	vmovdqu64 %zmm0,0x1e0(%rsp)
 1086183:	e0 01 00 00 
 1086187:	48 8b 84 24 60 02 00 	mov    0x260(%rsp),%rax
 108618e:	00 
 108618f:	8b 88 30 02 00 00    	mov    0x230(%rax),%ecx
 1086195:	3b 88 34 02 00 00    	cmp    0x234(%rax),%ecx
 108619b:	0f 83 e3 fe ff ff    	jae    1086084 <check_input_run+0x5d74>
 10861a1:	0f b6 90 bd 03 00 00 	movzbl 0x3bd(%rax),%edx
 10861a8:	8d 79 01             	lea    0x1(%rcx),%edi
 10861ab:	48 8b b0 28 02 00 00 	mov    0x228(%rax),%rsi
 10861b2:	89 b8 30 02 00 00    	mov    %edi,0x230(%rax)
 10861b8:	48 8d 04 49          	lea    (%rcx,%rcx,2),%rax
 10861bc:	48 8b 8c 24 70 01 00 	mov    0x170(%rsp),%rcx
 10861c3:	00 
 10861c4:	8d 54 52 01          	lea    0x1(%rdx,%rdx,2),%edx
 10861c8:	89 0c 86             	mov    %ecx,(%rsi,%rax,4)
 10861cb:	89 54 86 04          	mov    %edx,0x4(%rsi,%rax,4)
 10861cf:	c7 44 86 08 00 00 00 	movl   $0x0,0x8(%rsi,%rax,4)
 10861d6:	00 
 10861d7:	e9 af fe ff ff       	jmp    108608b <check_input_run+0x5d7b>
 10861dc:	41 89 cd             	mov    %ecx,%r13d
 10861df:	62 f1 fe 48 7f 44 24 	vmovdqu64 %zmm0,0x200(%rsp)
 10861e6:	08 
 10861e7:	62 f1 fe 48 7f 84 24 	vmovdqu64 %zmm0,0x1e0(%rsp)
 10861ee:	e0 01 00 00 
 10861f2:	44 39 ef             	cmp    %r13d,%edi
 10861f5:	73 90                	jae    1086187 <check_input_run+0x5e77>
 10861f7:	45 39 ee             	cmp    %r13d,%r14d
 10861fa:	76 8b                	jbe    1086187 <check_input_run+0x5e77>
 10861fc:	89 fe                	mov    %edi,%esi
 10861fe:	4c 89 8c 24 30 01 00 	mov    %r9,0x130(%rsp)
 1086205:	00 
 1086206:	48 8d bc 24 60 02 00 	lea    0x260(%rsp),%rdi
 108620d:	00 
 108620e:	89 b4 24 b0 00 00 00 	mov    %esi,0xb0(%rsp)
 1086215:	44 89 ea             	mov    %r13d,%edx
 1086218:	31 c9                	xor    %ecx,%ecx
 108621a:	41 b8 01 00 00 00    	mov    $0x1,%r8d
 1086220:	4c 8d 8c 24 e0 01 00 	lea    0x1e0(%rsp),%r9
 1086227:	00 
 1086228:	6a 00                	push   $0x0
 108622a:	41 57                	push   %r15
 108622c:	c5 f8 77             	vzeroupper
 108622f:	e8 2c f5 04 00       	call   10d5760 <check_input_constant_read>
 1086234:	48 83 c4 10          	add    $0x10,%rsp
 1086238:	83 fb 28             	cmp    $0x28,%ebx
 108623b:	75 78                	jne    10862b5 <check_input_run+0x5fa5>
 108623d:	84 c0                	test   %al,%al
 108623f:	74 74                	je     10862b5 <check_input_run+0x5fa5>
 1086241:	48 8b 84 24 88 02 00 	mov    0x288(%rsp),%rax
 1086248:	00 
 1086249:	8b b4 24 e0 01 00 00 	mov    0x1e0(%rsp),%esi
 1086250:	48 8b 9c 24 68 02 00 	mov    0x268(%rsp),%rbx
 1086257:	00 
 1086258:	48 8d bc 24 60 02 00 	lea    0x260(%rsp),%rdi
 108625f:	00 
 1086260:	48 8b 40 08          	mov    0x8(%rax),%rax
 1086264:	48 89 84 24 08 01 00 	mov    %rax,0x108(%rsp)
 108626b:	00 
 108626c:	e8 af 49 07 00       	call   10fac20 <check_constant_control_type>
 1086271:	89 84 24 d8 00 00 00 	mov    %eax,0xd8(%rsp)
 1086278:	48 8b 84 24 88 02 00 	mov    0x288(%rsp),%rax
 108627f:	00 
 1086280:	48 8b 30             	mov    (%rax),%rsi
 1086283:	48 8b 50 08          	mov    0x8(%rax),%rdx
 1086287:	48 8d 4c 32 03       	lea    0x3(%rdx,%rsi,1),%rcx
 108628c:	48 01 f2             	add    %rsi,%rdx
 108628f:	48 83 e1 fc          	and    $0xfffffffffffffffc,%rcx
 1086293:	48 39 d1             	cmp    %rdx,%rcx
 1086296:	0f 83 a5 00 00 00    	jae    1086341 <check_input_run+0x6031>
 108629c:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
 10862a1:	4c 8b 8c 24 30 01 00 	mov    0x130(%rsp),%r9
 10862a8:	00 
 10862a9:	45 31 c0             	xor    %r8d,%r8d
 10862ac:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 10862b0:	e9 d0 00 00 00       	jmp    1086385 <check_input_run+0x6075>
 10862b5:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
 10862ba:	4c 8b 8c 24 30 01 00 	mov    0x130(%rsp),%r9
 10862c1:	00 
 10862c2:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 10862c6:	84 c0                	test   %al,%al
 10862c8:	0f 84 b9 fe ff ff    	je     1086187 <check_input_run+0x5e77>
 10862ce:	41 8d 5d 01          	lea    0x1(%r13),%ebx
 10862d2:	41 89 df             	mov    %ebx,%r15d
 10862d5:	44 39 f3             	cmp    %r14d,%ebx
 10862d8:	0f 83 56 0c 00 00    	jae    1086f34 <check_input_run+0x6c24>
 10862de:	49 8b 41 10          	mov    0x10(%r9),%rax
 10862e2:	89 d9                	mov    %ebx,%ecx
 10862e4:	eb 29                	jmp    108630f <check_input_run+0x5fff>
 10862e6:	83 fe 0a             	cmp    $0xa,%esi
 10862e9:	75 3b                	jne    1086326 <check_input_run+0x6016>
 10862eb:	49 8b 71 60          	mov    0x60(%r9),%rsi
 10862ef:	8b 14 96             	mov    (%rsi,%rdx,4),%edx
 10862f2:	44 8d 7a 01          	lea    0x1(%rdx),%r15d
 10862f6:	44 39 f2             	cmp    %r14d,%edx
 10862f9:	45 0f 43 fe          	cmovae %r14d,%r15d
 10862fd:	39 ca                	cmp    %ecx,%edx
 10862ff:	45 0f 46 fe          	cmovbe %r14d,%r15d
 1086303:	44 89 f9             	mov    %r15d,%ecx
 1086306:	45 39 f7             	cmp    %r14d,%r15d
 1086309:	0f 83 25 0c 00 00    	jae    1086f34 <check_input_run+0x6c24>
 108630f:	89 ca                	mov    %ecx,%edx
 1086311:	0f b6 34 10          	movzbl (%rax,%rdx,1),%esi
 1086315:	83 fe 09             	cmp    $0x9,%esi
 1086318:	7f cc                	jg     10862e6 <check_input_run+0x5fd6>
 108631a:	83 fe 06             	cmp    $0x6,%esi
 108631d:	74 cc                	je     10862eb <check_input_run+0x5fdb>
 108631f:	83 fe 08             	cmp    $0x8,%esi
 1086322:	74 c7                	je     10862eb <check_input_run+0x5fdb>
 1086324:	eb 09                	jmp    108632f <check_input_run+0x601f>
 1086326:	83 fe 33             	cmp    $0x33,%esi
 1086329:	0f 84 02 0c 00 00    	je     1086f31 <check_input_run+0x6c21>
 108632f:	ff c1                	inc    %ecx
 1086331:	41 89 cf             	mov    %ecx,%r15d
 1086334:	44 89 f9             	mov    %r15d,%ecx
 1086337:	45 39 f7             	cmp    %r14d,%r15d
 108633a:	72 d3                	jb     108630f <check_input_run+0x5fff>
 108633c:	e9 f3 0b 00 00       	jmp    1086f34 <check_input_run+0x6c24>
 1086341:	48 89 ca             	mov    %rcx,%rdx
 1086344:	48 29 f2             	sub    %rsi,%rdx
 1086347:	48 8b 70 10          	mov    0x10(%rax),%rsi
 108634b:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
 1086350:	4c 8b 8c 24 30 01 00 	mov    0x130(%rsp),%r9
 1086357:	00 
 1086358:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 108635c:	48 29 d6             	sub    %rdx,%rsi
 108635f:	72 21                	jb     1086382 <check_input_run+0x6072>
 1086361:	44 89 f7             	mov    %r14d,%edi
 1086364:	44 29 ef             	sub    %r13d,%edi
 1086367:	41 b8 00 00 00 00    	mov    $0x0,%r8d
 108636d:	48 c1 e7 02          	shl    $0x2,%rdi
 1086371:	48 39 f7             	cmp    %rsi,%rdi
 1086374:	77 0f                	ja     1086385 <check_input_run+0x6075>
 1086376:	48 01 fa             	add    %rdi,%rdx
 1086379:	49 89 c8             	mov    %rcx,%r8
 108637c:	48 89 50 08          	mov    %rdx,0x8(%rax)
 1086380:	eb 03                	jmp    1086385 <check_input_run+0x6075>
 1086382:	45 31 c0             	xor    %r8d,%r8d
 1086385:	48 8b 8c 24 60 02 00 	mov    0x260(%rsp),%rcx
 108638c:	00 
 108638d:	4d 85 c0             	test   %r8,%r8
 1086390:	0f 94 c0             	sete   %al
 1086393:	31 d2                	xor    %edx,%edx
 1086395:	08 81 bd 03 00 00    	or     %al,0x3bd(%rcx)
 108639b:	41 8d 45 01          	lea    0x1(%r13),%eax
 108639f:	44 39 f0             	cmp    %r14d,%eax
 10863a2:	0f 83 9b 08 00 00    	jae    1086c43 <check_input_run+0x6933>
 10863a8:	4d 85 c0             	test   %r8,%r8
 10863ab:	0f 84 92 08 00 00    	je     1086c43 <check_input_run+0x6933>
 10863b1:	83 bc 24 d8 00 00 00 	cmpl   $0x0,0xd8(%rsp)
 10863b8:	00 
 10863b9:	4c 89 44 24 68       	mov    %r8,0x68(%rsp)
 10863be:	89 84 24 88 00 00 00 	mov    %eax,0x88(%rsp)
 10863c5:	0f 84 78 08 00 00    	je     1086c43 <check_input_run+0x6933>
 10863cb:	44 8b 94 24 88 00 00 	mov    0x88(%rsp),%r10d
 10863d2:	00 
 10863d3:	41 8d 46 01          	lea    0x1(%r14),%eax
 10863d7:	c7 84 24 a0 00 00 00 	movl   $0xffffffff,0xa0(%rsp)
 10863de:	ff ff ff ff 
 10863e2:	c7 84 24 f0 00 00 00 	movl   $0x0,0xf0(%rsp)
 10863e9:	00 00 00 00 
 10863ed:	c7 84 24 d0 00 00 00 	movl   $0xffffffff,0xd0(%rsp)
 10863f4:	ff ff ff ff 
 10863f8:	48 89 5c 24 48       	mov    %rbx,0x48(%rsp)
 10863fd:	89 44 24 60          	mov    %eax,0x60(%rsp)
 1086401:	48 8b 4b 10          	mov    0x10(%rbx),%rcx
 1086405:	44 89 d0             	mov    %r10d,%eax
 1086408:	eb 29                	jmp    1086433 <check_input_run+0x6123>
 108640a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
 1086410:	83 fe 0a             	cmp    $0xa,%esi
 1086413:	75 35                	jne    108644a <check_input_run+0x613a>
 1086415:	48 8b 73 60          	mov    0x60(%rbx),%rsi
 1086419:	8b 34 96             	mov    (%rsi,%rdx,4),%esi
 108641c:	8d 56 01             	lea    0x1(%rsi),%edx
 108641f:	44 39 f6             	cmp    %r14d,%esi
 1086422:	41 0f 43 d6          	cmovae %r14d,%edx
 1086426:	39 c6                	cmp    %eax,%esi
 1086428:	41 0f 46 d6          	cmovbe %r14d,%edx
 108642c:	89 d0                	mov    %edx,%eax
 108642e:	44 39 f2             	cmp    %r14d,%edx
 1086431:	73 29                	jae    108645c <check_input_run+0x614c>
 1086433:	89 c2                	mov    %eax,%edx
 1086435:	0f b6 34 11          	movzbl (%rcx,%rdx,1),%esi
 1086439:	83 fe 09             	cmp    $0x9,%esi
 108643c:	7f d2                	jg     1086410 <check_input_run+0x6100>
 108643e:	83 fe 06             	cmp    $0x6,%esi
 1086441:	74 d2                	je     1086415 <check_input_run+0x6105>
 1086443:	83 fe 08             	cmp    $0x8,%esi
 1086446:	74 cd                	je     1086415 <check_input_run+0x6105>
 1086448:	eb 05                	jmp    108644f <check_input_run+0x613f>
 108644a:	83 fe 2f             	cmp    $0x2f,%esi
 108644d:	74 0b                	je     108645a <check_input_run+0x614a>
 108644f:	ff c0                	inc    %eax
 1086451:	89 c2                	mov    %eax,%edx
 1086453:	44 39 f2             	cmp    %r14d,%edx
 1086456:	72 db                	jb     1086433 <check_input_run+0x6123>
 1086458:	eb 02                	jmp    108645c <check_input_run+0x614c>
 108645a:	89 c2                	mov    %eax,%edx
 108645c:	44 39 f2             	cmp    %r14d,%edx
 108645f:	0f 83 dc 07 00 00    	jae    1086c41 <check_input_run+0x6931>
 1086465:	89 d6                	mov    %edx,%esi
 1086467:	8d 7e 01             	lea    0x1(%rsi),%edi
 108646a:	44 39 f7             	cmp    %r14d,%edi
 108646d:	0f 83 ce 07 00 00    	jae    1086c41 <check_input_run+0x6931>
 1086473:	89 f8                	mov    %edi,%eax
 1086475:	eb 30                	jmp    10864a7 <check_input_run+0x6197>
 1086477:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
 108647e:	00 00 
 1086480:	41 83 f8 0a          	cmp    $0xa,%r8d
 1086484:	75 3c                	jne    10864c2 <check_input_run+0x61b2>
 1086486:	4c 8b 43 60          	mov    0x60(%rbx),%r8
 108648a:	41 8b 14 90          	mov    (%r8,%rdx,4),%edx
 108648e:	44 8d 7a 01          	lea    0x1(%rdx),%r15d
 1086492:	44 39 f2             	cmp    %r14d,%edx
 1086495:	45 0f 43 fe          	cmovae %r14d,%r15d
 1086499:	39 c2                	cmp    %eax,%edx
 108649b:	45 0f 46 fe          	cmovbe %r14d,%r15d
 108649f:	44 89 f8             	mov    %r15d,%eax
 10864a2:	45 39 f7             	cmp    %r14d,%r15d
 10864a5:	73 30                	jae    10864d7 <check_input_run+0x61c7>
 10864a7:	89 c2                	mov    %eax,%edx
 10864a9:	44 0f b6 04 11       	movzbl (%rcx,%rdx,1),%r8d
 10864ae:	41 83 f8 09          	cmp    $0x9,%r8d
 10864b2:	7f cc                	jg     1086480 <check_input_run+0x6170>
 10864b4:	41 83 f8 06          	cmp    $0x6,%r8d
 10864b8:	74 cc                	je     1086486 <check_input_run+0x6176>
 10864ba:	41 83 f8 08          	cmp    $0x8,%r8d
 10864be:	74 c6                	je     1086486 <check_input_run+0x6176>
 10864c0:	eb 06                	jmp    10864c8 <check_input_run+0x61b8>
 10864c2:	41 83 f8 33          	cmp    $0x33,%r8d
 10864c6:	74 0c                	je     10864d4 <check_input_run+0x61c4>
 10864c8:	ff c0                	inc    %eax
 10864ca:	41 89 c7             	mov    %eax,%r15d
 10864cd:	45 39 f7             	cmp    %r14d,%r15d
 10864d0:	72 d5                	jb     10864a7 <check_input_run+0x6197>
 10864d2:	eb 03                	jmp    10864d7 <check_input_run+0x61c7>
 10864d4:	41 89 c7             	mov    %eax,%r15d
 10864d7:	31 d2                	xor    %edx,%edx
 10864d9:	41 39 f2             	cmp    %esi,%r10d
 10864dc:	0f 83 61 07 00 00    	jae    1086c43 <check_input_run+0x6933>
 10864e2:	44 39 ff             	cmp    %r15d,%edi
 10864e5:	0f 83 58 07 00 00    	jae    1086c43 <check_input_run+0x6933>
 10864eb:	48 8b 53 60          	mov    0x60(%rbx),%rdx
 10864ef:	89 ff                	mov    %edi,%edi
 10864f1:	45 89 f8             	mov    %r15d,%r8d
 10864f4:	48 89 f8             	mov    %rdi,%rax
 10864f7:	4c 29 c0             	sub    %r8,%rax
 10864fa:	49 29 f8             	sub    %rdi,%r8
 10864fd:	44 89 94 24 98 00 00 	mov    %r10d,0x98(%rsp)
 1086504:	00 
 1086505:	4c 89 44 24 40       	mov    %r8,0x40(%rsp)
 108650a:	41 83 e0 07          	and    $0x7,%r8d
 108650e:	48 89 54 24 38       	mov    %rdx,0x38(%rsp)
 1086513:	48 83 f8 f8          	cmp    $0xfffffffffffffff8,%rax
 1086517:	76 0e                	jbe    1086527 <check_input_run+0x6217>
 1086519:	45 31 d2             	xor    %r10d,%r10d
 108651c:	41 bc ff ff ff ff    	mov    $0xffffffff,%r12d
 1086522:	e9 79 01 00 00       	jmp    10866a0 <check_input_run+0x6390>
 1086527:	48 83 64 24 40 f8    	andq   $0xfffffffffffffff8,0x40(%rsp)
 108652d:	4c 8d 5c ba 1c       	lea    0x1c(%rdx,%rdi,4),%r11
 1086532:	41 bc ff ff ff ff    	mov    $0xffffffff,%r12d
 1086538:	45 31 d2             	xor    %r10d,%r10d
 108653b:	31 db                	xor    %ebx,%ebx
 108653d:	0f 1f 00             	nopl   (%rax)
 1086540:	41 8b 44 9b e4       	mov    -0x1c(%r11,%rbx,4),%eax
 1086545:	41 8b 54 9b e8       	mov    -0x18(%r11,%rbx,4),%edx
 108654a:	39 f0                	cmp    %esi,%eax
 108654c:	41 0f 96 c1          	setbe  %r9b
 1086550:	44 39 f8             	cmp    %r15d,%eax
 1086553:	0f 93 c0             	setae  %al
 1086556:	44 08 c8             	or     %r9b,%al
 1086559:	44 8d 4c 1e 01       	lea    0x1(%rsi,%rbx,1),%r9d
 108655e:	0f b6 c0             	movzbl %al,%eax
 1086561:	41 01 c2             	add    %eax,%r10d
 1086564:	84 c0                	test   %al,%al
 1086566:	45 0f 45 e1          	cmovne %r9d,%r12d
 108656a:	39 f2                	cmp    %esi,%edx
 108656c:	44 8d 4c 1e 02       	lea    0x2(%rsi,%rbx,1),%r9d
 1086571:	0f 96 c0             	setbe  %al
 1086574:	44 39 fa             	cmp    %r15d,%edx
 1086577:	0f 93 c2             	setae  %dl
 108657a:	08 c2                	or     %al,%dl
 108657c:	0f b6 c2             	movzbl %dl,%eax
 108657f:	41 8b 54 9b ec       	mov    -0x14(%r11,%rbx,4),%edx
 1086584:	84 c0                	test   %al,%al
 1086586:	45 0f 44 cc          	cmove  %r12d,%r9d
 108658a:	39 f2                	cmp    %esi,%edx
 108658c:	41 0f 96 c4          	setbe  %r12b
 1086590:	44 39 fa             	cmp    %r15d,%edx
 1086593:	0f 93 c2             	setae  %dl
 1086596:	44 08 e2             	or     %r12b,%dl
 1086599:	0f b6 d2             	movzbl %dl,%edx
 108659c:	01 d0                	add    %edx,%eax
 108659e:	44 01 d0             	add    %r10d,%eax
 10865a1:	84 d2                	test   %dl,%dl
 10865a3:	41 8b 54 9b f0       	mov    -0x10(%r11,%rbx,4),%edx
 10865a8:	44 8d 54 1e 03       	lea    0x3(%rsi,%rbx,1),%r10d
 10865ad:	45 0f 44 d1          	cmove  %r9d,%r10d
 10865b1:	39 f2                	cmp    %esi,%edx
 10865b3:	41 0f 96 c1          	setbe  %r9b
 10865b7:	44 39 fa             	cmp    %r15d,%edx
 10865ba:	0f 93 c2             	setae  %dl
 10865bd:	44 08 ca             	or     %r9b,%dl
 10865c0:	44 8d 4c 1e 04       	lea    0x4(%rsi,%rbx,1),%r9d
 10865c5:	44 0f b6 e2          	movzbl %dl,%r12d
 10865c9:	41 8b 54 9b f4       	mov    -0xc(%r11,%rbx,4),%edx
 10865ce:	45 84 e4             	test   %r12b,%r12b
 10865d1:	45 0f 44 ca          	cmove  %r10d,%r9d
 10865d5:	39 f2                	cmp    %esi,%edx
 10865d7:	41 0f 96 c2          	setbe  %r10b
 10865db:	44 39 fa             	cmp    %r15d,%edx
 10865de:	0f 93 c2             	setae  %dl
 10865e1:	44 08 d2             	or     %r10b,%dl
 10865e4:	44 8d 54 1e 05       	lea    0x5(%rsi,%rbx,1),%r10d
 10865e9:	0f b6 d2             	movzbl %dl,%edx
 10865ec:	41 01 d4             	add    %edx,%r12d
 10865ef:	84 d2                	test   %dl,%dl
 10865f1:	41 8b 54 9b f8       	mov    -0x8(%r11,%rbx,4),%edx
 10865f6:	45 0f 44 d1          	cmove  %r9d,%r10d
 10865fa:	39 f2                	cmp    %esi,%edx
 10865fc:	41 0f 96 c1          	setbe  %r9b
 1086600:	44 39 fa             	cmp    %r15d,%edx
 1086603:	0f 93 c2             	setae  %dl
 1086606:	44 08 ca             	or     %r9b,%dl
 1086609:	0f b6 d2             	movzbl %dl,%edx
 108660c:	41 01 d4             	add    %edx,%r12d
 108660f:	41 01 c4             	add    %eax,%r12d
 1086612:	84 d2                	test   %dl,%dl
 1086614:	41 8b 54 9b fc       	mov    -0x4(%r11,%rbx,4),%edx
 1086619:	8d 44 1e 06          	lea    0x6(%rsi,%rbx,1),%eax
 108661d:	41 0f 44 c2          	cmove  %r10d,%eax
 1086621:	39 f2                	cmp    %esi,%edx
 1086623:	41 0f 96 c1          	setbe  %r9b
 1086627:	44 39 fa             	cmp    %r15d,%edx
 108662a:	0f 93 c2             	setae  %dl
 108662d:	44 08 ca             	or     %r9b,%dl
 1086630:	44 8d 4c 1e 07       	lea    0x7(%rsi,%rbx,1),%r9d
 1086635:	44 0f b6 d2          	movzbl %dl,%r10d
 1086639:	45 84 d2             	test   %r10b,%r10b
 108663c:	44 0f 44 c8          	cmove  %eax,%r9d
 1086640:	41 8b 04 9b          	mov    (%r11,%rbx,4),%eax
 1086644:	39 f0                	cmp    %esi,%eax
 1086646:	0f 96 c2             	setbe  %dl
 1086649:	44 39 f8             	cmp    %r15d,%eax
 108664c:	0f 93 c0             	setae  %al
 108664f:	08 d0                	or     %dl,%al
 1086651:	0f b6 c0             	movzbl %al,%eax
 1086654:	41 01 c2             	add    %eax,%r10d
 1086657:	45 01 e2             	add    %r12d,%r10d
 108665a:	44 8d 64 1e 08       	lea    0x8(%rsi,%rbx,1),%r12d
 108665f:	84 c0                	test   %al,%al
 1086661:	45 0f 44 e1          	cmove  %r9d,%r12d
 1086665:	48 83 c3 08          	add    $0x8,%rbx
 1086669:	48 39 5c 24 40       	cmp    %rbx,0x40(%rsp)
 108666e:	0f 85 cc fe ff ff    	jne    1086540 <check_input_run+0x6230>
 1086674:	4d 85 c0             	test   %r8,%r8
 1086677:	0f 84 c9 01 00 00    	je     1086846 <check_input_run+0x6536>
 108667d:	48 01 df             	add    %rbx,%rdi
 1086680:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
 1086685:	4c 8b 8c 24 30 01 00 	mov    0x130(%rsp),%r9
 108668c:	00 
 108668d:	48 8b 5c 24 48       	mov    0x48(%rsp),%rbx
 1086692:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
 1086697:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
 108669e:	00 00 
 10866a0:	8b 04 ba             	mov    (%rdx,%rdi,4),%eax
 10866a3:	39 f0                	cmp    %esi,%eax
 10866a5:	0f 96 c2             	setbe  %dl
 10866a8:	44 39 f8             	cmp    %r15d,%eax
 10866ab:	0f 93 c0             	setae  %al
 10866ae:	08 d0                	or     %dl,%al
 10866b0:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
 10866b5:	0f b6 c0             	movzbl %al,%eax
 10866b8:	41 01 c2             	add    %eax,%r10d
 10866bb:	84 c0                	test   %al,%al
 10866bd:	44 0f 45 e7          	cmovne %edi,%r12d
 10866c1:	48 ff c7             	inc    %rdi
 10866c4:	49 ff c8             	dec    %r8
 10866c7:	75 d7                	jne    10866a0 <check_input_run+0x6390>
 10866c9:	31 d2                	xor    %edx,%edx
 10866cb:	41 83 fa 01          	cmp    $0x1,%r10d
 10866cf:	0f 85 6e 05 00 00    	jne    1086c43 <check_input_run+0x6933>
 10866d5:	8b bc 24 98 00 00 00 	mov    0x98(%rsp),%edi
 10866dc:	41 83 fc ff          	cmp    $0xffffffff,%r12d
 10866e0:	0f 84 5d 05 00 00    	je     1086c43 <check_input_run+0x6933>
 10866e6:	89 f8                	mov    %edi,%eax
 10866e8:	80 3c 01 4b          	cmpb   $0x4b,(%rcx,%rax,1)
 10866ec:	75 1f                	jne    108670d <check_input_run+0x63fd>
 10866ee:	8b 84 24 a0 00 00 00 	mov    0xa0(%rsp),%eax
 10866f5:	ff c7                	inc    %edi
 10866f7:	44 89 a4 24 a0 00 00 	mov    %r12d,0xa0(%rsp)
 10866fe:	00 
 10866ff:	31 f7                	xor    %esi,%edi
 1086701:	f7 d0                	not    %eax
 1086703:	09 f8                	or     %edi,%eax
 1086705:	0f 94 c1             	sete   %cl
 1086708:	e9 24 01 00 00       	jmp    1086831 <check_input_run+0x6521>
 108670d:	48 8b 84 24 10 04 00 	mov    0x410(%rsp),%rax
 1086714:	00 
 1086715:	8b 94 24 f0 00 00 00 	mov    0xf0(%rsp),%edx
 108671c:	8b 04 b0             	mov    (%rax,%rsi,4),%eax
 108671f:	85 c0                	test   %eax,%eax
 1086721:	89 44 24 38          	mov    %eax,0x38(%rsp)
 1086725:	0f 95 c0             	setne  %al
 1086728:	85 d2                	test   %edx,%edx
 108672a:	89 d2                	mov    %edx,%edx
 108672c:	48 89 54 24 40       	mov    %rdx,0x40(%rsp)
 1086731:	0f 95 c1             	setne  %cl
 1086734:	20 c1                	and    %al,%cl
 1086736:	80 f9 01             	cmp    $0x1,%cl
 1086739:	75 5c                	jne    1086797 <check_input_run+0x6487>
 108673b:	bb 01 00 00 00       	mov    $0x1,%ebx
 1086740:	48 8b bc 24 78 02 00 	mov    0x278(%rsp),%rdi
 1086747:	00 
 1086748:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
 108674d:	48 8b 8c 24 c0 05 00 	mov    0x5c0(%rsp),%rcx
 1086754:	00 
 1086755:	8b 74 24 38          	mov    0x38(%rsp),%esi
 1086759:	44 8b 4c 24 60       	mov    0x60(%rsp),%r9d
 108675e:	8b 54 98 fc          	mov    -0x4(%rax,%rbx,4),%edx
 1086762:	44 8b 87 a0 00 00 00 	mov    0xa0(%rdi),%r8d
 1086769:	c5 f8 77             	vzeroupper
 108676c:	e8 6f 9a 03 00       	call   10c01e0 <type_compatible_at>
 1086771:	48 8b 94 24 60 02 00 	mov    0x260(%rsp),%rdx
 1086778:	00 
 1086779:	83 f8 02             	cmp    $0x2,%eax
 108677c:	0f 94 c1             	sete   %cl
 108677f:	08 8a bd 03 00 00    	or     %cl,0x3bd(%rdx)
 1086785:	85 c0                	test   %eax,%eax
 1086787:	0f 94 c0             	sete   %al
 108678a:	75 0b                	jne    1086797 <check_input_run+0x6487>
 108678c:	48 3b 5c 24 40       	cmp    0x40(%rsp),%rbx
 1086791:	48 8d 5b 01          	lea    0x1(%rbx),%rbx
 1086795:	72 a9                	jb     1086740 <check_input_run+0x6430>
 1086797:	84 c0                	test   %al,%al
 1086799:	0f 84 73 08 00 00    	je     1087012 <check_input_run+0x6d02>
 108679f:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
 10867a4:	8b 74 24 38          	mov    0x38(%rsp),%esi
 10867a8:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
 10867ad:	ff 84 24 f0 00 00 00 	incl   0xf0(%rsp)
 10867b4:	8b 94 24 d8 00 00 00 	mov    0xd8(%rsp),%edx
 10867bb:	44 8b 4c 24 60       	mov    0x60(%rsp),%r9d
 10867c0:	89 34 88             	mov    %esi,(%rax,%rcx,4)
 10867c3:	48 8b bc 24 78 02 00 	mov    0x278(%rsp),%rdi
 10867ca:	00 
 10867cb:	48 8b 8c 24 c0 05 00 	mov    0x5c0(%rsp),%rcx
 10867d2:	00 
 10867d3:	44 8b 87 a0 00 00 00 	mov    0xa0(%rdi),%r8d
 10867da:	c5 f8 77             	vzeroupper
 10867dd:	e8 fe 99 03 00       	call   10c01e0 <type_compatible_at>
 10867e2:	48 8b b4 24 60 02 00 	mov    0x260(%rsp),%rsi
 10867e9:	00 
 10867ea:	8b bc 24 d0 00 00 00 	mov    0xd0(%rsp),%edi
 10867f1:	31 d2                	xor    %edx,%edx
 10867f3:	83 f8 02             	cmp    $0x2,%eax
 10867f6:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
 10867fb:	4c 8b 8c 24 30 01 00 	mov    0x130(%rsp),%r9
 1086802:	00 
 1086803:	48 8b 5c 24 48       	mov    0x48(%rsp),%rbx
 1086808:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 108680c:	0f 94 c1             	sete   %cl
 108680f:	0f 95 c2             	setne  %dl
 1086812:	08 8e bd 03 00 00    	or     %cl,0x3bd(%rsi)
 1086818:	31 c9                	xor    %ecx,%ecx
 108681a:	83 ff ff             	cmp    $0xffffffff,%edi
 108681d:	0f 94 c1             	sete   %cl
 1086820:	83 f8 01             	cmp    $0x1,%eax
 1086823:	41 0f 44 fc          	cmove  %r12d,%edi
 1086827:	0f 45 ca             	cmovne %edx,%ecx
 108682a:	89 bc 24 d0 00 00 00 	mov    %edi,0xd0(%rsp)
 1086831:	41 ff c7             	inc    %r15d
 1086834:	45 39 f7             	cmp    %r14d,%r15d
 1086837:	73 30                	jae    1086869 <check_input_run+0x6559>
 1086839:	45 89 fa             	mov    %r15d,%r10d
 108683c:	84 c9                	test   %cl,%cl
 108683e:	0f 85 bd fb ff ff    	jne    1086401 <check_input_run+0x60f1>
 1086844:	eb 23                	jmp    1086869 <check_input_run+0x6559>
 1086846:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
 108684b:	4c 8b 8c 24 30 01 00 	mov    0x130(%rsp),%r9
 1086852:	00 
 1086853:	48 8b 5c 24 48       	mov    0x48(%rsp),%rbx
 1086858:	31 d2                	xor    %edx,%edx
 108685a:	41 83 fa 01          	cmp    $0x1,%r10d
 108685e:	0f 84 71 fe ff ff    	je     10866d5 <check_input_run+0x63c5>
 1086864:	e9 da 03 00 00       	jmp    1086c43 <check_input_run+0x6933>
 1086869:	8b 84 24 d0 00 00 00 	mov    0xd0(%rsp),%eax
 1086870:	44 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%r8d
 1086877:	00 
 1086878:	83 f8 ff             	cmp    $0xffffffff,%eax
 108687b:	44 0f 45 c0          	cmovne %eax,%r8d
 108687f:	41 83 f8 ff          	cmp    $0xffffffff,%r8d
 1086883:	0f 94 c0             	sete   %al
 1086886:	80 f1 01             	xor    $0x1,%cl
 1086889:	08 c1                	or     %al,%cl
 108688b:	0f 85 b0 03 00 00    	jne    1086c41 <check_input_run+0x6931>
 1086891:	48 8b 84 24 00 04 00 	mov    0x400(%rsp),%rax
 1086898:	00 
 1086899:	44 8b 94 24 88 00 00 	mov    0x88(%rsp),%r10d
 10868a0:	00 
 10868a1:	46 89 04 b0          	mov    %r8d,(%rax,%r14,4)
 10868a5:	eb 0c                	jmp    10868b3 <check_input_run+0x65a3>
 10868a7:	41 ff c2             	inc    %r10d
 10868aa:	45 39 f2             	cmp    %r14d,%r10d
 10868ad:	0f 83 77 07 00 00    	jae    108702a <check_input_run+0x6d1a>
 10868b3:	48 8b 4b 10          	mov    0x10(%rbx),%rcx
 10868b7:	eb 2c                	jmp    10868e5 <check_input_run+0x65d5>
 10868b9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
 10868c0:	83 fa 0a             	cmp    $0xa,%edx
 10868c3:	75 38                	jne    10868fd <check_input_run+0x65ed>
 10868c5:	48 8b 53 60          	mov    0x60(%rbx),%rdx
 10868c9:	8b 14 82             	mov    (%rdx,%rax,4),%edx
 10868cc:	8d 42 01             	lea    0x1(%rdx),%eax
 10868cf:	44 39 f2             	cmp    %r14d,%edx
 10868d2:	41 0f 43 c6          	cmovae %r14d,%eax
 10868d6:	44 39 d2             	cmp    %r10d,%edx
 10868d9:	41 0f 46 c6          	cmovbe %r14d,%eax
 10868dd:	41 89 c2             	mov    %eax,%r10d
 10868e0:	44 39 f0             	cmp    %r14d,%eax
 10868e3:	73 2d                	jae    1086912 <check_input_run+0x6602>
 10868e5:	44 89 d0             	mov    %r10d,%eax
 10868e8:	0f b6 14 01          	movzbl (%rcx,%rax,1),%edx
 10868ec:	83 fa 09             	cmp    $0x9,%edx
 10868ef:	7f cf                	jg     10868c0 <check_input_run+0x65b0>
 10868f1:	83 fa 06             	cmp    $0x6,%edx
 10868f4:	74 cf                	je     10868c5 <check_input_run+0x65b5>
 10868f6:	83 fa 08             	cmp    $0x8,%edx
 10868f9:	74 ca                	je     10868c5 <check_input_run+0x65b5>
 10868fb:	eb 05                	jmp    1086902 <check_input_run+0x65f2>
 10868fd:	83 fa 2f             	cmp    $0x2f,%edx
 1086900:	74 0d                	je     108690f <check_input_run+0x65ff>
 1086902:	41 ff c2             	inc    %r10d
 1086905:	44 89 d0             	mov    %r10d,%eax
 1086908:	44 39 f0             	cmp    %r14d,%eax
 108690b:	72 d8                	jb     10868e5 <check_input_run+0x65d5>
 108690d:	eb 03                	jmp    1086912 <check_input_run+0x6602>
 108690f:	44 89 d0             	mov    %r10d,%eax
 1086912:	ff c0                	inc    %eax
 1086914:	41 89 c2             	mov    %eax,%r10d
 1086917:	44 39 f0             	cmp    %r14d,%eax
 108691a:	73 54                	jae    1086970 <check_input_run+0x6660>
 108691c:	89 c2                	mov    %eax,%edx
 108691e:	eb 25                	jmp    1086945 <check_input_run+0x6635>
 1086920:	83 ff 0a             	cmp    $0xa,%edi
 1086923:	75 37                	jne    108695c <check_input_run+0x664c>
 1086925:	48 8b 7b 60          	mov    0x60(%rbx),%rdi
 1086929:	8b 34 b7             	mov    (%rdi,%rsi,4),%esi
 108692c:	44 8d 56 01          	lea    0x1(%rsi),%r10d
 1086930:	44 39 f6             	cmp    %r14d,%esi
 1086933:	45 0f 43 d6          	cmovae %r14d,%r10d
 1086937:	39 d6                	cmp    %edx,%esi
 1086939:	45 0f 46 d6          	cmovbe %r14d,%r10d
 108693d:	44 89 d2             	mov    %r10d,%edx
 1086940:	45 39 f2             	cmp    %r14d,%r10d
 1086943:	73 2b                	jae    1086970 <check_input_run+0x6660>
 1086945:	89 d6                	mov    %edx,%esi
 1086947:	0f b6 3c 31          	movzbl (%rcx,%rsi,1),%edi
 108694b:	83 ff 09             	cmp    $0x9,%edi
 108694e:	7f d0                	jg     1086920 <check_input_run+0x6610>
 1086950:	83 ff 06             	cmp    $0x6,%edi
 1086953:	74 d0                	je     1086925 <check_input_run+0x6615>
 1086955:	83 ff 08             	cmp    $0x8,%edi
 1086958:	74 cb                	je     1086925 <check_input_run+0x6615>
 108695a:	eb 05                	jmp    1086961 <check_input_run+0x6651>
 108695c:	83 ff 33             	cmp    $0x33,%edi
 108695f:	74 0c                	je     108696d <check_input_run+0x665d>
 1086961:	ff c2                	inc    %edx
 1086963:	41 89 d2             	mov    %edx,%r10d
 1086966:	45 39 f2             	cmp    %r14d,%r10d
 1086969:	72 da                	jb     1086945 <check_input_run+0x6635>
 108696b:	eb 03                	jmp    1086970 <check_input_run+0x6660>
 108696d:	41 89 d2             	mov    %edx,%r10d
 1086970:	41 39 c0             	cmp    %eax,%r8d
 1086973:	72 09                	jb     108697e <check_input_run+0x666e>
 1086975:	45 39 d0             	cmp    %r10d,%r8d
 1086978:	0f 82 29 ff ff ff    	jb     10868a7 <check_input_run+0x6597>
 108697e:	44 39 d0             	cmp    %r10d,%eax
 1086981:	0f 83 88 00 00 00    	jae    1086a0f <check_input_run+0x66ff>
 1086987:	48 8b 8c 24 60 02 00 	mov    0x260(%rsp),%rcx
 108698e:	00 
 108698f:	48 83 b9 c8 02 00 00 	cmpq   $0x0,0x2c8(%rcx)
 1086996:	00 
 1086997:	74 76                	je     1086a0f <check_input_run+0x66ff>
 1086999:	48 8b 8c 24 68 02 00 	mov    0x268(%rsp),%rcx
 10869a0:	00 
 10869a1:	44 3b 51 30          	cmp    0x30(%rcx),%r10d
 10869a5:	77 68                	ja     1086a0f <check_input_run+0x66ff>
 10869a7:	44 89 d2             	mov    %r10d,%edx
 10869aa:	29 c2                	sub    %eax,%edx
 10869ac:	89 c6                	mov    %eax,%esi
 10869ae:	48 89 f1             	mov    %rsi,%rcx
 10869b1:	83 e2 03             	and    $0x3,%edx
 10869b4:	74 4d                	je     1086a03 <check_input_run+0x66f3>
 10869b6:	48 89 f1             	mov    %rsi,%rcx
 10869b9:	eb 08                	jmp    10869c3 <check_input_run+0x66b3>
 10869bb:	48 ff c1             	inc    %rcx
 10869be:	48 ff ca             	dec    %rdx
 10869c1:	74 40                	je     1086a03 <check_input_run+0x66f3>
 10869c3:	48 8b bc 24 e0 04 00 	mov    0x4e0(%rsp),%rdi
 10869ca:	00 
 10869cb:	48 85 ff             	test   %rdi,%rdi
 10869ce:	74 06                	je     10869d6 <check_input_run+0x66c6>
 10869d0:	f6 04 0f 02          	testb  $0x2,(%rdi,%rcx,1)
 10869d4:	75 e5                	jne    10869bb <check_input_run+0x66ab>
 10869d6:	48 8b bc 24 60 02 00 	mov    0x260(%rsp),%rdi
 10869dd:	00 
 10869de:	48 8b bf c8 02 00 00 	mov    0x2c8(%rdi),%rdi
 10869e5:	80 24 0f f7          	andb   $0xf7,(%rdi,%rcx,1)
 10869e9:	48 8b bc 24 60 02 00 	mov    0x260(%rsp),%rdi
 10869f0:	00 
 10869f1:	48 8b bf d0 02 00 00 	mov    0x2d0(%rdi),%rdi
 10869f8:	48 85 ff             	test   %rdi,%rdi
 10869fb:	74 be                	je     10869bb <check_input_run+0x66ab>
 10869fd:	80 24 0f f7          	andb   $0xf7,(%rdi,%rcx,1)
 1086a01:	eb b8                	jmp    10869bb <check_input_run+0x66ab>
 1086a03:	44 89 d2             	mov    %r10d,%edx
 1086a06:	48 29 d6             	sub    %rdx,%rsi
 1086a09:	48 83 fe fc          	cmp    $0xfffffffffffffffc,%rsi
 1086a0d:	76 4e                	jbe    1086a5d <check_input_run+0x674d>
 1086a0f:	44 39 d0             	cmp    %r10d,%eax
 1086a12:	0f 83 8f fe ff ff    	jae    10868a7 <check_input_run+0x6597>
 1086a18:	48 83 bc 24 e8 04 00 	cmpq   $0x0,0x4e8(%rsp)
 1086a1f:	00 00 
 1086a21:	0f 84 80 fe ff ff    	je     10868a7 <check_input_run+0x6597>
 1086a27:	48 8b 8c 24 68 02 00 	mov    0x268(%rsp),%rcx
 1086a2e:	00 
 1086a2f:	44 3b 51 30          	cmp    0x30(%rcx),%r10d
 1086a33:	0f 87 6e fe ff ff    	ja     10868a7 <check_input_run+0x6597>
 1086a39:	44 89 d1             	mov    %r10d,%ecx
 1086a3c:	29 c1                	sub    %eax,%ecx
 1086a3e:	89 c2                	mov    %eax,%edx
 1086a40:	48 89 d0             	mov    %rdx,%rax
 1086a43:	83 e1 03             	and    $0x3,%ecx
 1086a46:	0f 84 48 01 00 00    	je     1086b94 <check_input_run+0x6884>
 1086a4c:	48 89 d0             	mov    %rdx,%rax
 1086a4f:	e9 2b 01 00 00       	jmp    1086b7f <check_input_run+0x686f>
 1086a54:	48 83 c1 04          	add    $0x4,%rcx
 1086a58:	48 39 ca             	cmp    %rcx,%rdx
 1086a5b:	74 b2                	je     1086a0f <check_input_run+0x66ff>
 1086a5d:	48 8b b4 24 e0 04 00 	mov    0x4e0(%rsp),%rsi
 1086a64:	00 
 1086a65:	48 85 f6             	test   %rsi,%rsi
 1086a68:	74 06                	je     1086a70 <check_input_run+0x6760>
 1086a6a:	f6 04 0e 02          	testb  $0x2,(%rsi,%rcx,1)
 1086a6e:	75 2b                	jne    1086a9b <check_input_run+0x678b>
 1086a70:	48 8b b4 24 60 02 00 	mov    0x260(%rsp),%rsi
 1086a77:	00 
 1086a78:	48 8b b6 c8 02 00 00 	mov    0x2c8(%rsi),%rsi
 1086a7f:	80 24 0e f7          	andb   $0xf7,(%rsi,%rcx,1)
 1086a83:	48 8b b4 24 60 02 00 	mov    0x260(%rsp),%rsi
 1086a8a:	00 
 1086a8b:	48 8b b6 d0 02 00 00 	mov    0x2d0(%rsi),%rsi
 1086a92:	48 85 f6             	test   %rsi,%rsi
 1086a95:	74 04                	je     1086a9b <check_input_run+0x678b>
 1086a97:	80 24 0e f7          	andb   $0xf7,(%rsi,%rcx,1)
 1086a9b:	48 8b b4 24 e0 04 00 	mov    0x4e0(%rsp),%rsi
 1086aa2:	00 
 1086aa3:	48 85 f6             	test   %rsi,%rsi
 1086aa6:	74 07                	je     1086aaf <check_input_run+0x679f>
 1086aa8:	f6 44 0e 01 02       	testb  $0x2,0x1(%rsi,%rcx,1)
 1086aad:	75 2d                	jne    1086adc <check_input_run+0x67cc>
 1086aaf:	48 8b b4 24 60 02 00 	mov    0x260(%rsp),%rsi
 1086ab6:	00 
 1086ab7:	48 8b b6 c8 02 00 00 	mov    0x2c8(%rsi),%rsi
 1086abe:	80 64 0e 01 f7       	andb   $0xf7,0x1(%rsi,%rcx,1)
 1086ac3:	48 8b b4 24 60 02 00 	mov    0x260(%rsp),%rsi
 1086aca:	00 
 1086acb:	48 8b b6 d0 02 00 00 	mov    0x2d0(%rsi),%rsi
 1086ad2:	48 85 f6             	test   %rsi,%rsi
 1086ad5:	74 05                	je     1086adc <check_input_run+0x67cc>
 1086ad7:	80 64 0e 01 f7       	andb   $0xf7,0x1(%rsi,%rcx,1)
 1086adc:	48 8b b4 24 e0 04 00 	mov    0x4e0(%rsp),%rsi
 1086ae3:	00 
 1086ae4:	48 85 f6             	test   %rsi,%rsi
 1086ae7:	74 07                	je     1086af0 <check_input_run+0x67e0>
 1086ae9:	f6 44 0e 02 02       	testb  $0x2,0x2(%rsi,%rcx,1)
 1086aee:	75 2d                	jne    1086b1d <check_input_run+0x680d>
 1086af0:	48 8b b4 24 60 02 00 	mov    0x260(%rsp),%rsi
 1086af7:	00 
 1086af8:	48 8b b6 c8 02 00 00 	mov    0x2c8(%rsi),%rsi
 1086aff:	80 64 0e 02 f7       	andb   $0xf7,0x2(%rsi,%rcx,1)
 1086b04:	48 8b b4 24 60 02 00 	mov    0x260(%rsp),%rsi
 1086b0b:	00 
 1086b0c:	48 8b b6 d0 02 00 00 	mov    0x2d0(%rsi),%rsi
 1086b13:	48 85 f6             	test   %rsi,%rsi
 1086b16:	74 05                	je     1086b1d <check_input_run+0x680d>
 1086b18:	80 64 0e 02 f7       	andb   $0xf7,0x2(%rsi,%rcx,1)
 1086b1d:	48 8b b4 24 e0 04 00 	mov    0x4e0(%rsp),%rsi
 1086b24:	00 
 1086b25:	48 85 f6             	test   %rsi,%rsi
 1086b28:	74 0b                	je     1086b35 <check_input_run+0x6825>
 1086b2a:	f6 44 0e 03 02       	testb  $0x2,0x3(%rsi,%rcx,1)
 1086b2f:	0f 85 1f ff ff ff    	jne    1086a54 <check_input_run+0x6744>
 1086b35:	48 8b b4 24 60 02 00 	mov    0x260(%rsp),%rsi
 1086b3c:	00 
 1086b3d:	48 8b b6 c8 02 00 00 	mov    0x2c8(%rsi),%rsi
 1086b44:	80 64 0e 03 f7       	andb   $0xf7,0x3(%rsi,%rcx,1)
 1086b49:	48 8b b4 24 60 02 00 	mov    0x260(%rsp),%rsi
 1086b50:	00 
 1086b51:	48 8b b6 d0 02 00 00 	mov    0x2d0(%rsi),%rsi
 1086b58:	48 85 f6             	test   %rsi,%rsi
 1086b5b:	0f 84 f3 fe ff ff    	je     1086a54 <check_input_run+0x6744>
 1086b61:	80 64 0e 03 f7       	andb   $0xf7,0x3(%rsi,%rcx,1)
 1086b66:	e9 e9 fe ff ff       	jmp    1086a54 <check_input_run+0x6744>
 1086b6b:	48 8b b4 24 e8 04 00 	mov    0x4e8(%rsp),%rsi
 1086b72:	00 
 1086b73:	80 0c 06 08          	orb    $0x8,(%rsi,%rax,1)
 1086b77:	48 ff c0             	inc    %rax
 1086b7a:	48 ff c9             	dec    %rcx
 1086b7d:	74 15                	je     1086b94 <check_input_run+0x6884>
 1086b7f:	48 8b b4 24 e0 04 00 	mov    0x4e0(%rsp),%rsi
 1086b86:	00 
 1086b87:	48 85 f6             	test   %rsi,%rsi
 1086b8a:	74 df                	je     1086b6b <check_input_run+0x685b>
 1086b8c:	f6 04 06 02          	testb  $0x2,(%rsi,%rax,1)
 1086b90:	74 d9                	je     1086b6b <check_input_run+0x685b>
 1086b92:	eb e3                	jmp    1086b77 <check_input_run+0x6867>
 1086b94:	44 89 d1             	mov    %r10d,%ecx
 1086b97:	48 29 ca             	sub    %rcx,%rdx
 1086b9a:	48 83 fa fc          	cmp    $0xfffffffffffffffc,%rdx
 1086b9e:	76 1f                	jbe    1086bbf <check_input_run+0x68af>
 1086ba0:	e9 02 fd ff ff       	jmp    10868a7 <check_input_run+0x6597>
 1086ba5:	48 8b 94 24 e8 04 00 	mov    0x4e8(%rsp),%rdx
 1086bac:	00 
 1086bad:	80 4c 02 03 08       	orb    $0x8,0x3(%rdx,%rax,1)
 1086bb2:	48 83 c0 04          	add    $0x4,%rax
 1086bb6:	48 39 c1             	cmp    %rax,%rcx
 1086bb9:	0f 84 e8 fc ff ff    	je     10868a7 <check_input_run+0x6597>
 1086bbf:	48 8b 94 24 e0 04 00 	mov    0x4e0(%rsp),%rdx
 1086bc6:	00 
 1086bc7:	48 85 d2             	test   %rdx,%rdx
 1086bca:	74 06                	je     1086bd2 <check_input_run+0x68c2>
 1086bcc:	f6 04 02 02          	testb  $0x2,(%rdx,%rax,1)
 1086bd0:	75 0c                	jne    1086bde <check_input_run+0x68ce>
 1086bd2:	48 8b 94 24 e8 04 00 	mov    0x4e8(%rsp),%rdx
 1086bd9:	00 
 1086bda:	80 0c 02 08          	orb    $0x8,(%rdx,%rax,1)
 1086bde:	48 8b 94 24 e0 04 00 	mov    0x4e0(%rsp),%rdx
 1086be5:	00 
 1086be6:	48 85 d2             	test   %rdx,%rdx
 1086be9:	74 07                	je     1086bf2 <check_input_run+0x68e2>
 1086beb:	f6 44 02 01 02       	testb  $0x2,0x1(%rdx,%rax,1)
 1086bf0:	75 0d                	jne    1086bff <check_input_run+0x68ef>
 1086bf2:	48 8b 94 24 e8 04 00 	mov    0x4e8(%rsp),%rdx
 1086bf9:	00 
 1086bfa:	80 4c 02 01 08       	orb    $0x8,0x1(%rdx,%rax,1)
 1086bff:	48 8b 94 24 e0 04 00 	mov    0x4e0(%rsp),%rdx
 1086c06:	00 
 1086c07:	48 85 d2             	test   %rdx,%rdx
 1086c0a:	74 07                	je     1086c13 <check_input_run+0x6903>
 1086c0c:	f6 44 02 02 02       	testb  $0x2,0x2(%rdx,%rax,1)
 1086c11:	75 0d                	jne    1086c20 <check_input_run+0x6910>
 1086c13:	48 8b 94 24 e8 04 00 	mov    0x4e8(%rsp),%rdx
 1086c1a:	00 
 1086c1b:	80 4c 02 02 08       	orb    $0x8,0x2(%rdx,%rax,1)
 1086c20:	48 8b 94 24 e0 04 00 	mov    0x4e0(%rsp),%rdx
 1086c27:	00 
 1086c28:	48 85 d2             	test   %rdx,%rdx
 1086c2b:	0f 84 74 ff ff ff    	je     1086ba5 <check_input_run+0x6895>
 1086c31:	f6 44 02 03 02       	testb  $0x2,0x3(%rdx,%rax,1)
 1086c36:	0f 84 69 ff ff ff    	je     1086ba5 <check_input_run+0x6895>
 1086c3c:	e9 71 ff ff ff       	jmp    1086bb2 <check_input_run+0x68a2>
 1086c41:	31 d2                	xor    %edx,%edx
 1086c43:	48 8b 84 24 88 02 00 	mov    0x288(%rsp),%rax
 1086c4a:	00 
 1086c4b:	48 8b 8c 24 08 01 00 	mov    0x108(%rsp),%rcx
 1086c52:	00 
 1086c53:	48 3b 48 08          	cmp    0x8(%rax),%rcx
 1086c57:	0f 87 6d 49 00 00    	ja     108b5ca <check_input_run+0xb2ba>
 1086c5d:	48 89 48 08          	mov    %rcx,0x8(%rax)
 1086c61:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
 1086c66:	8b bc 24 b0 00 00 00 	mov    0xb0(%rsp),%edi
 1086c6d:	4c 8d bc 24 d8 01 00 	lea    0x1d8(%rsp),%r15
 1086c74:	00 
 1086c75:	48 8b 84 24 60 02 00 	mov    0x260(%rsp),%rax
 1086c7c:	00 
 1086c7d:	48 83 b8 c8 02 00 00 	cmpq   $0x0,0x2c8(%rax)
 1086c84:	00 
 1086c85:	74 7d                	je     1086d04 <check_input_run+0x69f4>
 1086c87:	48 8b 84 24 68 02 00 	mov    0x268(%rsp),%rax
 1086c8e:	00 
 1086c8f:	44 3b 68 30          	cmp    0x30(%rax),%r13d
 1086c93:	77 6f                	ja     1086d04 <check_input_run+0x69f4>
 1086c95:	44 89 e9             	mov    %r13d,%ecx
 1086c98:	29 f9                	sub    %edi,%ecx
 1086c9a:	89 fe                	mov    %edi,%esi
 1086c9c:	48 89 f0             	mov    %rsi,%rax
 1086c9f:	83 e1 03             	and    $0x3,%ecx
 1086ca2:	74 4d                	je     1086cf1 <check_input_run+0x69e1>
 1086ca4:	48 89 f0             	mov    %rsi,%rax
 1086ca7:	eb 08                	jmp    1086cb1 <check_input_run+0x69a1>
 1086ca9:	48 ff c0             	inc    %rax
 1086cac:	48 ff c9             	dec    %rcx
 1086caf:	74 40                	je     1086cf1 <check_input_run+0x69e1>
 1086cb1:	48 8b bc 24 e0 04 00 	mov    0x4e0(%rsp),%rdi
 1086cb8:	00 
 1086cb9:	48 85 ff             	test   %rdi,%rdi
 1086cbc:	74 06                	je     1086cc4 <check_input_run+0x69b4>
 1086cbe:	f6 04 07 02          	testb  $0x2,(%rdi,%rax,1)
 1086cc2:	75 e5                	jne    1086ca9 <check_input_run+0x6999>
 1086cc4:	48 8b bc 24 60 02 00 	mov    0x260(%rsp),%rdi
 1086ccb:	00 
 1086ccc:	48 8b bf c8 02 00 00 	mov    0x2c8(%rdi),%rdi
 1086cd3:	80 24 07 87          	andb   $0x87,(%rdi,%rax,1)
 1086cd7:	48 8b bc 24 60 02 00 	mov    0x260(%rsp),%rdi
 1086cde:	00 
 1086cdf:	48 8b bf d0 02 00 00 	mov    0x2d0(%rdi),%rdi
 1086ce6:	48 85 ff             	test   %rdi,%rdi
 1086ce9:	74 be                	je     1086ca9 <check_input_run+0x6999>
 1086ceb:	80 24 07 87          	andb   $0x87,(%rdi,%rax,1)
 1086cef:	eb b8                	jmp    1086ca9 <check_input_run+0x6999>
 1086cf1:	8b bc 24 b0 00 00 00 	mov    0xb0(%rsp),%edi
 1086cf8:	44 89 e9             	mov    %r13d,%ecx
 1086cfb:	48 29 ce             	sub    %rcx,%rsi
 1086cfe:	48 83 fe fc          	cmp    $0xfffffffffffffffc,%rsi
 1086d02:	76 45                	jbe    1086d49 <check_input_run+0x6a39>
 1086d04:	48 83 bc 24 e8 04 00 	cmpq   $0x0,0x4e8(%rsp)
 1086d0b:	00 00 
 1086d0d:	0f 84 79 01 00 00    	je     1086e8c <check_input_run+0x6b7c>
 1086d13:	48 8b 84 24 68 02 00 	mov    0x268(%rsp),%rax
 1086d1a:	00 
 1086d1b:	44 3b 68 30          	cmp    0x30(%rax),%r13d
 1086d1f:	0f 87 67 01 00 00    	ja     1086e8c <check_input_run+0x6b7c>
 1086d25:	44 89 e9             	mov    %r13d,%ecx
 1086d28:	29 f9                	sub    %edi,%ecx
 1086d2a:	89 fe                	mov    %edi,%esi
 1086d2c:	48 89 f0             	mov    %rsi,%rax
 1086d2f:	83 e1 03             	and    $0x3,%ecx
 1086d32:	0f 84 48 01 00 00    	je     1086e80 <check_input_run+0x6b70>
 1086d38:	48 89 f0             	mov    %rsi,%rax
 1086d3b:	e9 2b 01 00 00       	jmp    1086e6b <check_input_run+0x6b5b>
 1086d40:	48 83 c0 04          	add    $0x4,%rax
 1086d44:	48 39 c1             	cmp    %rax,%rcx
 1086d47:	74 bb                	je     1086d04 <check_input_run+0x69f4>
 1086d49:	48 8b b4 24 e0 04 00 	mov    0x4e0(%rsp),%rsi
 1086d50:	00 
 1086d51:	48 85 f6             	test   %rsi,%rsi
 1086d54:	74 06                	je     1086d5c <check_input_run+0x6a4c>
 1086d56:	f6 04 06 02          	testb  $0x2,(%rsi,%rax,1)
 1086d5a:	75 2b                	jne    1086d87 <check_input_run+0x6a77>
 1086d5c:	48 8b b4 24 60 02 00 	mov    0x260(%rsp),%rsi
 1086d63:	00 
 1086d64:	48 8b b6 c8 02 00 00 	mov    0x2c8(%rsi),%rsi
 1086d6b:	80 24 06 87          	andb   $0x87,(%rsi,%rax,1)
 1086d6f:	48 8b b4 24 60 02 00 	mov    0x260(%rsp),%rsi
 1086d76:	00 
 1086d77:	48 8b b6 d0 02 00 00 	mov    0x2d0(%rsi),%rsi
 1086d7e:	48 85 f6             	test   %rsi,%rsi
 1086d81:	74 04                	je     1086d87 <check_input_run+0x6a77>
 1086d83:	80 24 06 87          	andb   $0x87,(%rsi,%rax,1)
 1086d87:	48 8b b4 24 e0 04 00 	mov    0x4e0(%rsp),%rsi
 1086d8e:	00 
 1086d8f:	48 85 f6             	test   %rsi,%rsi
 1086d92:	74 07                	je     1086d9b <check_input_run+0x6a8b>
 1086d94:	f6 44 06 01 02       	testb  $0x2,0x1(%rsi,%rax,1)
 1086d99:	75 2d                	jne    1086dc8 <check_input_run+0x6ab8>
 1086d9b:	48 8b b4 24 60 02 00 	mov    0x260(%rsp),%rsi
 1086da2:	00 
 1086da3:	48 8b b6 c8 02 00 00 	mov    0x2c8(%rsi),%rsi
 1086daa:	80 64 06 01 87       	andb   $0x87,0x1(%rsi,%rax,1)
 1086daf:	48 8b b4 24 60 02 00 	mov    0x260(%rsp),%rsi
 1086db6:	00 
 1086db7:	48 8b b6 d0 02 00 00 	mov    0x2d0(%rsi),%rsi
 1086dbe:	48 85 f6             	test   %rsi,%rsi
 1086dc1:	74 05                	je     1086dc8 <check_input_run+0x6ab8>
 1086dc3:	80 64 06 01 87       	andb   $0x87,0x1(%rsi,%rax,1)
 1086dc8:	48 8b b4 24 e0 04 00 	mov    0x4e0(%rsp),%rsi
 1086dcf:	00 
 1086dd0:	48 85 f6             	test   %rsi,%rsi
 1086dd3:	74 07                	je     1086ddc <check_input_run+0x6acc>
 1086dd5:	f6 44 06 02 02       	testb  $0x2,0x2(%rsi,%rax,1)
 1086dda:	75 2d                	jne    1086e09 <check_input_run+0x6af9>
 1086ddc:	48 8b b4 24 60 02 00 	mov    0x260(%rsp),%rsi
 1086de3:	00 
 1086de4:	48 8b b6 c8 02 00 00 	mov    0x2c8(%rsi),%rsi
 1086deb:	80 64 06 02 87       	andb   $0x87,0x2(%rsi,%rax,1)
 1086df0:	48 8b b4 24 60 02 00 	mov    0x260(%rsp),%rsi
 1086df7:	00 
 1086df8:	48 8b b6 d0 02 00 00 	mov    0x2d0(%rsi),%rsi
 1086dff:	48 85 f6             	test   %rsi,%rsi
 1086e02:	74 05                	je     1086e09 <check_input_run+0x6af9>
 1086e04:	80 64 06 02 87       	andb   $0x87,0x2(%rsi,%rax,1)
 1086e09:	48 8b b4 24 e0 04 00 	mov    0x4e0(%rsp),%rsi
 1086e10:	00 
 1086e11:	48 85 f6             	test   %rsi,%rsi
 1086e14:	74 0b                	je     1086e21 <check_input_run+0x6b11>
 1086e16:	f6 44 06 03 02       	testb  $0x2,0x3(%rsi,%rax,1)
 1086e1b:	0f 85 1f ff ff ff    	jne    1086d40 <check_input_run+0x6a30>
 1086e21:	48 8b b4 24 60 02 00 	mov    0x260(%rsp),%rsi
 1086e28:	00 
 1086e29:	48 8b b6 c8 02 00 00 	mov    0x2c8(%rsi),%rsi
 1086e30:	80 64 06 03 87       	andb   $0x87,0x3(%rsi,%rax,1)
 1086e35:	48 8b b4 24 60 02 00 	mov    0x260(%rsp),%rsi
 1086e3c:	00 
 1086e3d:	48 8b b6 d0 02 00 00 	mov    0x2d0(%rsi),%rsi
 1086e44:	48 85 f6             	test   %rsi,%rsi
 1086e47:	0f 84 f3 fe ff ff    	je     1086d40 <check_input_run+0x6a30>
 1086e4d:	80 64 06 03 87       	andb   $0x87,0x3(%rsi,%rax,1)
 1086e52:	e9 e9 fe ff ff       	jmp    1086d40 <check_input_run+0x6a30>
 1086e57:	48 8b bc 24 e8 04 00 	mov    0x4e8(%rsp),%rdi
 1086e5e:	00 
 1086e5f:	80 0c 07 78          	orb    $0x78,(%rdi,%rax,1)
 1086e63:	48 ff c0             	inc    %rax
 1086e66:	48 ff c9             	dec    %rcx
 1086e69:	74 15                	je     1086e80 <check_input_run+0x6b70>
 1086e6b:	48 8b bc 24 e0 04 00 	mov    0x4e0(%rsp),%rdi
 1086e72:	00 
 1086e73:	48 85 ff             	test   %rdi,%rdi
 1086e76:	74 df                	je     1086e57 <check_input_run+0x6b47>
 1086e78:	f6 04 07 02          	testb  $0x2,(%rdi,%rax,1)
 1086e7c:	74 d9                	je     1086e57 <check_input_run+0x6b47>
 1086e7e:	eb e3                	jmp    1086e63 <check_input_run+0x6b53>
 1086e80:	44 89 e9             	mov    %r13d,%ecx
 1086e83:	48 29 ce             	sub    %rcx,%rsi
 1086e86:	48 83 fe fc          	cmp    $0xfffffffffffffffc,%rsi
 1086e8a:	76 23                	jbe    1086eaf <check_input_run+0x6b9f>
 1086e8c:	84 d2                	test   %dl,%dl
 1086e8e:	0f 85 f7 f1 ff ff    	jne    108608b <check_input_run+0x5d7b>
 1086e94:	e9 ee f2 ff ff       	jmp    1086187 <check_input_run+0x5e77>
 1086e99:	48 8b b4 24 e8 04 00 	mov    0x4e8(%rsp),%rsi
 1086ea0:	00 
 1086ea1:	80 4c 06 03 78       	orb    $0x78,0x3(%rsi,%rax,1)
 1086ea6:	48 83 c0 04          	add    $0x4,%rax
 1086eaa:	48 39 c1             	cmp    %rax,%rcx
 1086ead:	74 dd                	je     1086e8c <check_input_run+0x6b7c>
 1086eaf:	48 8b b4 24 e0 04 00 	mov    0x4e0(%rsp),%rsi
 1086eb6:	00 
 1086eb7:	48 85 f6             	test   %rsi,%rsi
 1086eba:	74 06                	je     1086ec2 <check_input_run+0x6bb2>
 1086ebc:	f6 04 06 02          	testb  $0x2,(%rsi,%rax,1)
 1086ec0:	75 0c                	jne    1086ece <check_input_run+0x6bbe>
 1086ec2:	48 8b b4 24 e8 04 00 	mov    0x4e8(%rsp),%rsi
 1086ec9:	00 
 1086eca:	80 0c 06 78          	orb    $0x78,(%rsi,%rax,1)
 1086ece:	48 8b b4 24 e0 04 00 	mov    0x4e0(%rsp),%rsi
 1086ed5:	00 
 1086ed6:	48 85 f6             	test   %rsi,%rsi
 1086ed9:	74 07                	je     1086ee2 <check_input_run+0x6bd2>
 1086edb:	f6 44 06 01 02       	testb  $0x2,0x1(%rsi,%rax,1)
 1086ee0:	75 0d                	jne    1086eef <check_input_run+0x6bdf>
 1086ee2:	48 8b b4 24 e8 04 00 	mov    0x4e8(%rsp),%rsi
 1086ee9:	00 
 1086eea:	80 4c 06 01 78       	orb    $0x78,0x1(%rsi,%rax,1)
 1086eef:	48 8b b4 24 e0 04 00 	mov    0x4e0(%rsp),%rsi
 1086ef6:	00 
 1086ef7:	48 85 f6             	test   %rsi,%rsi
 1086efa:	74 07                	je     1086f03 <check_input_run+0x6bf3>
 1086efc:	f6 44 06 02 02       	testb  $0x2,0x2(%rsi,%rax,1)
 1086f01:	75 0d                	jne    1086f10 <check_input_run+0x6c00>
 1086f03:	48 8b b4 24 e8 04 00 	mov    0x4e8(%rsp),%rsi
 1086f0a:	00 
 1086f0b:	80 4c 06 02 78       	orb    $0x78,0x2(%rsi,%rax,1)
 1086f10:	48 8b b4 24 e0 04 00 	mov    0x4e0(%rsp),%rsi
 1086f17:	00 
 1086f18:	48 85 f6             	test   %rsi,%rsi
 1086f1b:	0f 84 78 ff ff ff    	je     1086e99 <check_input_run+0x6b89>
 1086f21:	f6 44 06 03 02       	testb  $0x2,0x3(%rsi,%rax,1)
 1086f26:	0f 84 6d ff ff ff    	je     1086e99 <check_input_run+0x6b89>
 1086f2c:	e9 75 ff ff ff       	jmp    1086ea6 <check_input_run+0x6b96>
 1086f31:	41 89 cf             	mov    %ecx,%r15d
 1086f34:	45 39 f7             	cmp    %r14d,%r15d
 1086f37:	0f 83 4b 03 00 00    	jae    1087288 <check_input_run+0x6f78>
 1086f3d:	83 bc 24 34 02 00 00 	cmpl   $0x0,0x234(%rsp)
 1086f44:	00 
 1086f45:	0f 85 3d 03 00 00    	jne    1087288 <check_input_run+0x6f78>
 1086f4b:	83 bc 24 ec 01 00 00 	cmpl   $0x1,0x1ec(%rsp)
 1086f52:	01 
 1086f53:	0f 85 2f 03 00 00    	jne    1087288 <check_input_run+0x6f78>
 1086f59:	8b 8c 24 e8 01 00 00 	mov    0x1e8(%rsp),%ecx
 1086f60:	89 c8                	mov    %ecx,%eax
 1086f62:	83 e0 10             	and    $0x10,%eax
 1086f65:	89 4c 24 68          	mov    %ecx,0x68(%rsp)
 1086f69:	c1 e8 04             	shr    $0x4,%eax
 1086f6c:	f7 c1 01 04 00 00    	test   $0x401,%ecx
 1086f72:	0f 94 c1             	sete   %cl
 1086f75:	08 c1                	or     %al,%cl
 1086f77:	0f 85 0b 03 00 00    	jne    1087288 <check_input_run+0x6f78>
 1086f7d:	48 8b bc 24 78 02 00 	mov    0x278(%rsp),%rdi
 1086f84:	00 
 1086f85:	48 8d b4 24 e0 01 00 	lea    0x1e0(%rsp),%rsi
 1086f8c:	00 
 1086f8d:	48 8d 94 24 d8 01 00 	lea    0x1d8(%rsp),%rdx
 1086f94:	00 
 1086f95:	c5 f8 77             	vzeroupper
 1086f98:	e8 03 81 03 00       	call   10bf0a0 <check_action_truth>
 1086f9d:	4c 8b 8c 24 30 01 00 	mov    0x130(%rsp),%r9
 1086fa4:	00 
 1086fa5:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
 1086faa:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 1086fae:	84 c0                	test   %al,%al
 1086fb0:	0f 84 d2 02 00 00    	je     1087288 <check_input_run+0x6f78>
 1086fb6:	44 0f b6 94 24 d8 01 	movzbl 0x1d8(%rsp),%r10d
 1086fbd:	00 00 
 1086fbf:	41 8d 4f 01          	lea    0x1(%r15),%ecx
 1086fc3:	44 89 f6             	mov    %r14d,%esi
 1086fc6:	89 ca                	mov    %ecx,%edx
 1086fc8:	45 84 d2             	test   %r10b,%r10b
 1086fcb:	0f 45 d3             	cmovne %ebx,%edx
 1086fce:	41 0f 45 f7          	cmovne %r15d,%esi
 1086fd2:	39 f2                	cmp    %esi,%edx
 1086fd4:	0f 83 ae 02 00 00    	jae    1087288 <check_input_run+0x6f78>
 1086fda:	49 8b 79 60          	mov    0x60(%r9),%rdi
 1086fde:	41 89 f0             	mov    %esi,%r8d
 1086fe1:	48 89 d0             	mov    %rdx,%rax
 1086fe4:	4c 29 c0             	sub    %r8,%rax
 1086fe7:	49 29 d0             	sub    %rdx,%r8
 1086fea:	89 4c 24 60          	mov    %ecx,0x60(%rsp)
 1086fee:	4c 89 44 24 40       	mov    %r8,0x40(%rsp)
 1086ff3:	41 83 e0 07          	and    $0x7,%r8d
 1086ff7:	48 89 7c 24 38       	mov    %rdi,0x38(%rsp)
 1086ffc:	48 83 f8 f8          	cmp    $0xfffffffffffffff8,%rax
 1087000:	76 2f                	jbe    1087031 <check_input_run+0x6d21>
 1087002:	45 31 e4             	xor    %r12d,%r12d
 1087005:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
 108700a:	49 89 d1             	mov    %rdx,%r9
 108700d:	e9 8f 01 00 00       	jmp    10871a1 <check_input_run+0x6e91>
 1087012:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
 1087017:	4c 8b 8c 24 30 01 00 	mov    0x130(%rsp),%r9
 108701e:	00 
 108701f:	31 d2                	xor    %edx,%edx
 1087021:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 1087025:	e9 19 fc ff ff       	jmp    1086c43 <check_input_run+0x6933>
 108702a:	b2 01                	mov    $0x1,%dl
 108702c:	e9 12 fc ff ff       	jmp    1086c43 <check_input_run+0x6933>
 1087031:	48 83 64 24 40 f8    	andq   $0xfffffffffffffff8,0x40(%rsp)
 1087037:	4c 8d 5c 97 1c       	lea    0x1c(%rdi,%rdx,4),%r11
 108703c:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
 1087041:	44 88 94 24 98 00 00 	mov    %r10b,0x98(%rsp)
 1087048:	00 
 1087049:	45 31 e4             	xor    %r12d,%r12d
 108704c:	45 31 c9             	xor    %r9d,%r9d
 108704f:	43 8b 44 8b e4       	mov    -0x1c(%r11,%r9,4),%eax
 1087054:	43 8b 7c 8b e8       	mov    -0x18(%r11,%r9,4),%edi
 1087059:	39 d0                	cmp    %edx,%eax
 108705b:	41 0f 92 c2          	setb   %r10b
 108705f:	39 f0                	cmp    %esi,%eax
 1087061:	0f 93 c0             	setae  %al
 1087064:	44 08 d0             	or     %r10b,%al
 1087067:	46 8d 14 0a          	lea    (%rdx,%r9,1),%r10d
 108706b:	0f b6 c0             	movzbl %al,%eax
 108706e:	41 01 c4             	add    %eax,%r12d
 1087071:	84 c0                	test   %al,%al
 1087073:	41 0f 45 ca          	cmovne %r10d,%ecx
 1087077:	39 d7                	cmp    %edx,%edi
 1087079:	46 8d 54 0a 01       	lea    0x1(%rdx,%r9,1),%r10d
 108707e:	0f 92 c0             	setb   %al
 1087081:	39 f7                	cmp    %esi,%edi
 1087083:	40 0f 93 c7          	setae  %dil
 1087087:	40 08 c7             	or     %al,%dil
 108708a:	40 0f b6 c7          	movzbl %dil,%eax
 108708e:	84 c0                	test   %al,%al
 1087090:	44 0f 44 d1          	cmove  %ecx,%r10d
 1087094:	43 8b 4c 8b ec       	mov    -0x14(%r11,%r9,4),%ecx
 1087099:	39 d1                	cmp    %edx,%ecx
 108709b:	40 0f 92 c7          	setb   %dil
 108709f:	39 f1                	cmp    %esi,%ecx
 10870a1:	0f 93 c1             	setae  %cl
 10870a4:	40 08 f9             	or     %dil,%cl
 10870a7:	42 8d 7c 0a 02       	lea    0x2(%rdx,%r9,1),%edi
 10870ac:	0f b6 c9             	movzbl %cl,%ecx
 10870af:	01 c8                	add    %ecx,%eax
 10870b1:	44 01 e0             	add    %r12d,%eax
 10870b4:	84 c9                	test   %cl,%cl
 10870b6:	43 8b 4c 8b f0       	mov    -0x10(%r11,%r9,4),%ecx
 10870bb:	41 0f 44 fa          	cmove  %r10d,%edi
 10870bf:	39 d1                	cmp    %edx,%ecx
 10870c1:	41 0f 92 c2          	setb   %r10b
 10870c5:	39 f1                	cmp    %esi,%ecx
 10870c7:	0f 93 c1             	setae  %cl
 10870ca:	44 08 d1             	or     %r10b,%cl
 10870cd:	46 8d 54 0a 03       	lea    0x3(%rdx,%r9,1),%r10d
 10870d2:	0f b6 c9             	movzbl %cl,%ecx
 10870d5:	84 c9                	test   %cl,%cl
 10870d7:	44 0f 44 d7          	cmove  %edi,%r10d
 10870db:	43 8b 7c 8b f4       	mov    -0xc(%r11,%r9,4),%edi
 10870e0:	39 d7                	cmp    %edx,%edi
 10870e2:	41 0f 92 c4          	setb   %r12b
 10870e6:	39 f7                	cmp    %esi,%edi
 10870e8:	40 0f 93 c7          	setae  %dil
 10870ec:	44 08 e7             	or     %r12b,%dil
 10870ef:	46 8d 64 0a 04       	lea    0x4(%rdx,%r9,1),%r12d
 10870f4:	40 0f b6 ff          	movzbl %dil,%edi
 10870f8:	01 f9                	add    %edi,%ecx
 10870fa:	40 84 ff             	test   %dil,%dil
 10870fd:	43 8b 7c 8b f8       	mov    -0x8(%r11,%r9,4),%edi
 1087102:	45 0f 44 e2          	cmove  %r10d,%r12d
 1087106:	39 d7                	cmp    %edx,%edi
 1087108:	41 0f 92 c2          	setb   %r10b
 108710c:	39 f7                	cmp    %esi,%edi
 108710e:	40 0f 93 c7          	setae  %dil
 1087112:	44 08 d7             	or     %r10b,%dil
 1087115:	40 0f b6 ff          	movzbl %dil,%edi
 1087119:	01 f9                	add    %edi,%ecx
 108711b:	01 c1                	add    %eax,%ecx
 108711d:	40 84 ff             	test   %dil,%dil
 1087120:	43 8b 7c 8b fc       	mov    -0x4(%r11,%r9,4),%edi
 1087125:	42 8d 44 0a 05       	lea    0x5(%rdx,%r9,1),%eax
 108712a:	41 0f 44 c4          	cmove  %r12d,%eax
 108712e:	39 d7                	cmp    %edx,%edi
 1087130:	41 0f 92 c2          	setb   %r10b
 1087134:	39 f7                	cmp    %esi,%edi
 1087136:	40 0f 93 c7          	setae  %dil
 108713a:	44 08 d7             	or     %r10b,%dil
 108713d:	46 8d 54 0a 06       	lea    0x6(%rdx,%r9,1),%r10d
 1087142:	44 0f b6 e7          	movzbl %dil,%r12d
 1087146:	45 84 e4             	test   %r12b,%r12b
 1087149:	44 0f 44 d0          	cmove  %eax,%r10d
 108714d:	43 8b 04 8b          	mov    (%r11,%r9,4),%eax
 1087151:	39 d0                	cmp    %edx,%eax
 1087153:	40 0f 92 c7          	setb   %dil
 1087157:	39 f0                	cmp    %esi,%eax
 1087159:	0f 93 c0             	setae  %al
 108715c:	40 08 f8             	or     %dil,%al
 108715f:	0f b6 c0             	movzbl %al,%eax
 1087162:	41 01 c4             	add    %eax,%r12d
 1087165:	41 01 cc             	add    %ecx,%r12d
 1087168:	42 8d 4c 0a 07       	lea    0x7(%rdx,%r9,1),%ecx
 108716d:	84 c0                	test   %al,%al
 108716f:	41 0f 44 ca          	cmove  %r10d,%ecx
 1087173:	49 83 c1 08          	add    $0x8,%r9
 1087177:	4c 39 4c 24 40       	cmp    %r9,0x40(%rsp)
 108717c:	0f 85 cd fe ff ff    	jne    108704f <check_input_run+0x6d3f>
 1087182:	4d 85 c0             	test   %r8,%r8
 1087185:	0f 84 0a 01 00 00    	je     1087295 <check_input_run+0x6f85>
 108718b:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
 1087190:	44 0f b6 94 24 98 00 	movzbl 0x98(%rsp),%r10d
 1087197:	00 00 
 1087199:	48 8b 7c 24 38       	mov    0x38(%rsp),%rdi
 108719e:	49 01 d1             	add    %rdx,%r9
 10871a1:	42 8b 04 8f          	mov    (%rdi,%r9,4),%eax
 10871a5:	39 d0                	cmp    %edx,%eax
 10871a7:	40 0f 92 c7          	setb   %dil
 10871ab:	39 f0                	cmp    %esi,%eax
 10871ad:	0f 93 c0             	setae  %al
 10871b0:	40 08 f8             	or     %dil,%al
 10871b3:	48 8b 7c 24 38       	mov    0x38(%rsp),%rdi
 10871b8:	0f b6 c0             	movzbl %al,%eax
 10871bb:	41 01 c4             	add    %eax,%r12d
 10871be:	84 c0                	test   %al,%al
 10871c0:	41 0f 45 c9          	cmovne %r9d,%ecx
 10871c4:	49 ff c1             	inc    %r9
 10871c7:	49 ff c8             	dec    %r8
 10871ca:	75 d5                	jne    10871a1 <check_input_run+0x6e91>
 10871cc:	4c 8b 8c 24 30 01 00 	mov    0x130(%rsp),%r9
 10871d3:	00 
 10871d4:	8b 74 24 60          	mov    0x60(%rsp),%esi
 10871d8:	41 83 fc 01          	cmp    $0x1,%r12d
 10871dc:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
 10871e1:	0f 85 a1 00 00 00    	jne    1087288 <check_input_run+0x6f78>
 10871e7:	83 f9 ff             	cmp    $0xffffffff,%ecx
 10871ea:	0f 84 98 00 00 00    	je     1087288 <check_input_run+0x6f78>
 10871f0:	48 8b 84 24 00 04 00 	mov    0x400(%rsp),%rax
 10871f7:	00 
 10871f8:	42 89 0c b0          	mov    %ecx,(%rax,%r14,4)
 10871fc:	48 8b 84 24 60 02 00 	mov    0x260(%rsp),%rax
 1087203:	00 
 1087204:	48 8b 8c 24 68 02 00 	mov    0x268(%rsp),%rcx
 108720b:	00 
 108720c:	44 3b 69 30          	cmp    0x30(%rcx),%r13d
 1087210:	0f 87 ac 00 00 00    	ja     10872c2 <check_input_run+0x6fb2>
 1087216:	48 8b 90 c8 02 00 00 	mov    0x2c8(%rax),%rdx
 108721d:	8b 7c 24 68          	mov    0x68(%rsp),%edi
 1087221:	48 85 d2             	test   %rdx,%rdx
 1087224:	0f 94 c1             	sete   %cl
 1087227:	40 08 cf             	or     %cl,%dil
 108722a:	40 f6 c7 01          	test   $0x1,%dil
 108722e:	0f 85 8e 00 00 00    	jne    10872c2 <check_input_run+0x6fb2>
 1087234:	8b 8c 24 b0 00 00 00 	mov    0xb0(%rsp),%ecx
 108723b:	0f b6 34 0a          	movzbl (%rdx,%rcx,1),%esi
 108723f:	89 f0                	mov    %esi,%eax
 1087241:	0c 02                	or     $0x2,%al
 1087243:	88 04 0a             	mov    %al,(%rdx,%rcx,1)
 1087246:	48 8b 84 24 60 02 00 	mov    0x260(%rsp),%rax
 108724d:	00 
 108724e:	48 8b 90 d0 02 00 00 	mov    0x2d0(%rax),%rdx
 1087255:	48 85 d2             	test   %rdx,%rdx
 1087258:	74 4e                	je     10872a8 <check_input_run+0x6f98>
 108725a:	40 80 e6 02          	and    $0x2,%sil
 108725e:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
 1087263:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
 1087268:	4c 8b 8c 24 30 01 00 	mov    0x130(%rsp),%r9
 108726f:	00 
 1087270:	8b 74 24 60          	mov    0x60(%rsp),%esi
 1087274:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 1087278:	75 48                	jne    10872c2 <check_input_run+0x6fb2>
 108727a:	80 0c 0a 02          	orb    $0x2,(%rdx,%rcx,1)
 108727e:	48 8b 84 24 60 02 00 	mov    0x260(%rsp),%rax
 1087285:	00 
 1087286:	eb 3a                	jmp    10872c2 <check_input_run+0x6fb2>
 1087288:	4c 8d bc 24 d8 01 00 	lea    0x1d8(%rsp),%r15
 108728f:	00 
 1087290:	e9 f2 ee ff ff       	jmp    1086187 <check_input_run+0x5e77>
 1087295:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
 108729a:	44 0f b6 94 24 98 00 	movzbl 0x98(%rsp),%r10d
 10872a1:	00 00 
 10872a3:	e9 24 ff ff ff       	jmp    10871cc <check_input_run+0x6ebc>
 10872a8:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
 10872ad:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
 10872b2:	4c 8b 8c 24 30 01 00 	mov    0x130(%rsp),%r9
 10872b9:	00 
 10872ba:	8b 74 24 60          	mov    0x60(%rsp),%esi
 10872be:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 10872c2:	45 84 d2             	test   %r10b,%r10b
 10872c5:	0f 45 de             	cmovne %esi,%ebx
 10872c8:	45 0f 45 fe          	cmovne %r14d,%r15d
 10872cc:	44 39 fb             	cmp    %r15d,%ebx
 10872cf:	0f 83 9a 00 00 00    	jae    108736f <check_input_run+0x705f>
 10872d5:	48 83 b8 c8 02 00 00 	cmpq   $0x0,0x2c8(%rax)
 10872dc:	00 
 10872dd:	0f 84 8c 00 00 00    	je     108736f <check_input_run+0x705f>
 10872e3:	48 8b 84 24 68 02 00 	mov    0x268(%rsp),%rax
 10872ea:	00 
 10872eb:	44 3b 78 30          	cmp    0x30(%rax),%r15d
 10872ef:	77 7e                	ja     108736f <check_input_run+0x705f>
 10872f1:	44 89 f9             	mov    %r15d,%ecx
 10872f4:	29 d9                	sub    %ebx,%ecx
 10872f6:	89 da                	mov    %ebx,%edx
 10872f8:	48 89 d0             	mov    %rdx,%rax
 10872fb:	83 e1 03             	and    $0x3,%ecx
 10872fe:	74 4d                	je     108734d <check_input_run+0x703d>
 1087300:	48 89 d0             	mov    %rdx,%rax
 1087303:	eb 08                	jmp    108730d <check_input_run+0x6ffd>
 1087305:	48 ff c0             	inc    %rax
 1087308:	48 ff c9             	dec    %rcx
 108730b:	74 40                	je     108734d <check_input_run+0x703d>
 108730d:	48 8b b4 24 e0 04 00 	mov    0x4e0(%rsp),%rsi
 1087314:	00 
 1087315:	48 85 f6             	test   %rsi,%rsi
 1087318:	74 06                	je     1087320 <check_input_run+0x7010>
 108731a:	f6 04 06 02          	testb  $0x2,(%rsi,%rax,1)
 108731e:	75 e5                	jne    1087305 <check_input_run+0x6ff5>
 1087320:	48 8b b4 24 60 02 00 	mov    0x260(%rsp),%rsi
 1087327:	00 
 1087328:	48 8b b6 c8 02 00 00 	mov    0x2c8(%rsi),%rsi
 108732f:	80 24 06 f7          	andb   $0xf7,(%rsi,%rax,1)
 1087333:	48 8b b4 24 60 02 00 	mov    0x260(%rsp),%rsi
 108733a:	00 
 108733b:	48 8b b6 d0 02 00 00 	mov    0x2d0(%rsi),%rsi
 1087342:	48 85 f6             	test   %rsi,%rsi
 1087345:	74 be                	je     1087305 <check_input_run+0x6ff5>
 1087347:	80 24 06 f7          	andb   $0xf7,(%rsi,%rax,1)
 108734b:	eb b8                	jmp    1087305 <check_input_run+0x6ff5>
 108734d:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
 1087352:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
 1087357:	4c 8b 8c 24 30 01 00 	mov    0x130(%rsp),%r9
 108735e:	00 
 108735f:	44 89 f9             	mov    %r15d,%ecx
 1087362:	48 29 ca             	sub    %rcx,%rdx
 1087365:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 1087369:	48 83 fa fc          	cmp    $0xfffffffffffffffc,%rdx
 108736d:	76 4e                	jbe    10873bd <check_input_run+0x70ad>
 108736f:	44 39 fb             	cmp    %r15d,%ebx
 1087372:	0f 83 9e 01 00 00    	jae    1087516 <check_input_run+0x7206>
 1087378:	48 83 bc 24 e8 04 00 	cmpq   $0x0,0x4e8(%rsp)
 108737f:	00 00 
 1087381:	0f 84 8f 01 00 00    	je     1087516 <check_input_run+0x7206>
 1087387:	48 8b 84 24 68 02 00 	mov    0x268(%rsp),%rax
 108738e:	00 
 108738f:	44 3b 78 30          	cmp    0x30(%rax),%r15d
 1087393:	0f 87 7d 01 00 00    	ja     1087516 <check_input_run+0x7206>
 1087399:	44 89 f9             	mov    %r15d,%ecx
 108739c:	29 d9                	sub    %ebx,%ecx
 108739e:	89 da                	mov    %ebx,%edx
 10873a0:	48 89 d0             	mov    %rdx,%rax
 10873a3:	83 e1 03             	and    $0x3,%ecx
 10873a6:	0f 84 48 01 00 00    	je     10874f4 <check_input_run+0x71e4>
 10873ac:	48 89 d0             	mov    %rdx,%rax
 10873af:	e9 2b 01 00 00       	jmp    10874df <check_input_run+0x71cf>
 10873b4:	48 83 c0 04          	add    $0x4,%rax
 10873b8:	48 39 c1             	cmp    %rax,%rcx
 10873bb:	74 b2                	je     108736f <check_input_run+0x705f>
 10873bd:	48 8b 94 24 e0 04 00 	mov    0x4e0(%rsp),%rdx
 10873c4:	00 
 10873c5:	48 85 d2             	test   %rdx,%rdx
 10873c8:	74 06                	je     10873d0 <check_input_run+0x70c0>
 10873ca:	f6 04 02 02          	testb  $0x2,(%rdx,%rax,1)
 10873ce:	75 2b                	jne    10873fb <check_input_run+0x70eb>
 10873d0:	48 8b 94 24 60 02 00 	mov    0x260(%rsp),%rdx
 10873d7:	00 
 10873d8:	48 8b 92 c8 02 00 00 	mov    0x2c8(%rdx),%rdx
 10873df:	80 24 02 f7          	andb   $0xf7,(%rdx,%rax,1)
 10873e3:	48 8b 94 24 60 02 00 	mov    0x260(%rsp),%rdx
 10873ea:	00 
 10873eb:	48 8b 92 d0 02 00 00 	mov    0x2d0(%rdx),%rdx
 10873f2:	48 85 d2             	test   %rdx,%rdx
 10873f5:	74 04                	je     10873fb <check_input_run+0x70eb>
 10873f7:	80 24 02 f7          	andb   $0xf7,(%rdx,%rax,1)
 10873fb:	48 8b 94 24 e0 04 00 	mov    0x4e0(%rsp),%rdx
 1087402:	00 
 1087403:	48 85 d2             	test   %rdx,%rdx
 1087406:	74 07                	je     108740f <check_input_run+0x70ff>
 1087408:	f6 44 02 01 02       	testb  $0x2,0x1(%rdx,%rax,1)
 108740d:	75 2d                	jne    108743c <check_input_run+0x712c>
 108740f:	48 8b 94 24 60 02 00 	mov    0x260(%rsp),%rdx
 1087416:	00 
 1087417:	48 8b 92 c8 02 00 00 	mov    0x2c8(%rdx),%rdx
 108741e:	80 64 02 01 f7       	andb   $0xf7,0x1(%rdx,%rax,1)
 1087423:	48 8b 94 24 60 02 00 	mov    0x260(%rsp),%rdx
 108742a:	00 
 108742b:	48 8b 92 d0 02 00 00 	mov    0x2d0(%rdx),%rdx
 1087432:	48 85 d2             	test   %rdx,%rdx
 1087435:	74 05                	je     108743c <check_input_run+0x712c>
 1087437:	80 64 02 01 f7       	andb   $0xf7,0x1(%rdx,%rax,1)
 108743c:	48 8b 94 24 e0 04 00 	mov    0x4e0(%rsp),%rdx
 1087443:	00 
 1087444:	48 85 d2             	test   %rdx,%rdx
 1087447:	74 07                	je     1087450 <check_input_run+0x7140>
 1087449:	f6 44 02 02 02       	testb  $0x2,0x2(%rdx,%rax,1)
 108744e:	75 2d                	jne    108747d <check_input_run+0x716d>
 1087450:	48 8b 94 24 60 02 00 	mov    0x260(%rsp),%rdx
 1087457:	00 
 1087458:	48 8b 92 c8 02 00 00 	mov    0x2c8(%rdx),%rdx
 108745f:	80 64 02 02 f7       	andb   $0xf7,0x2(%rdx,%rax,1)
 1087464:	48 8b 94 24 60 02 00 	mov    0x260(%rsp),%rdx
 108746b:	00 
 108746c:	48 8b 92 d0 02 00 00 	mov    0x2d0(%rdx),%rdx
 1087473:	48 85 d2             	test   %rdx,%rdx
 1087476:	74 05                	je     108747d <check_input_run+0x716d>
 1087478:	80 64 02 02 f7       	andb   $0xf7,0x2(%rdx,%rax,1)
 108747d:	48 8b 94 24 e0 04 00 	mov    0x4e0(%rsp),%rdx
 1087484:	00 
 1087485:	48 85 d2             	test   %rdx,%rdx
 1087488:	74 0b                	je     1087495 <check_input_run+0x7185>
 108748a:	f6 44 02 03 02       	testb  $0x2,0x3(%rdx,%rax,1)
 108748f:	0f 85 1f ff ff ff    	jne    10873b4 <check_input_run+0x70a4>
 1087495:	48 8b 94 24 60 02 00 	mov    0x260(%rsp),%rdx
 108749c:	00 
 108749d:	48 8b 92 c8 02 00 00 	mov    0x2c8(%rdx),%rdx
 10874a4:	80 64 02 03 f7       	andb   $0xf7,0x3(%rdx,%rax,1)
 10874a9:	48 8b 94 24 60 02 00 	mov    0x260(%rsp),%rdx
 10874b0:	00 
 10874b1:	48 8b 92 d0 02 00 00 	mov    0x2d0(%rdx),%rdx
 10874b8:	48 85 d2             	test   %rdx,%rdx
 10874bb:	0f 84 f3 fe ff ff    	je     10873b4 <check_input_run+0x70a4>
 10874c1:	80 64 02 03 f7       	andb   $0xf7,0x3(%rdx,%rax,1)
 10874c6:	e9 e9 fe ff ff       	jmp    10873b4 <check_input_run+0x70a4>
 10874cb:	48 8b b4 24 e8 04 00 	mov    0x4e8(%rsp),%rsi
 10874d2:	00 
 10874d3:	80 0c 06 08          	orb    $0x8,(%rsi,%rax,1)
 10874d7:	48 ff c0             	inc    %rax
 10874da:	48 ff c9             	dec    %rcx
 10874dd:	74 15                	je     10874f4 <check_input_run+0x71e4>
 10874df:	48 8b b4 24 e0 04 00 	mov    0x4e0(%rsp),%rsi
 10874e6:	00 
 10874e7:	48 85 f6             	test   %rsi,%rsi
 10874ea:	74 df                	je     10874cb <check_input_run+0x71bb>
 10874ec:	f6 04 06 02          	testb  $0x2,(%rsi,%rax,1)
 10874f0:	74 d9                	je     10874cb <check_input_run+0x71bb>
 10874f2:	eb e3                	jmp    10874d7 <check_input_run+0x71c7>
 10874f4:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
 10874f9:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
 10874fe:	4c 8b 8c 24 30 01 00 	mov    0x130(%rsp),%r9
 1087505:	00 
 1087506:	44 89 f9             	mov    %r15d,%ecx
 1087509:	48 29 ca             	sub    %rcx,%rdx
 108750c:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 1087510:	48 83 fa fc          	cmp    $0xfffffffffffffffc,%rdx
 1087514:	76 23                	jbe    1087539 <check_input_run+0x7229>
 1087516:	4c 8d bc 24 d8 01 00 	lea    0x1d8(%rsp),%r15
 108751d:	00 
 108751e:	e9 68 eb ff ff       	jmp    108608b <check_input_run+0x5d7b>
 1087523:	48 8b 94 24 e8 04 00 	mov    0x4e8(%rsp),%rdx
 108752a:	00 
 108752b:	80 4c 02 03 08       	orb    $0x8,0x3(%rdx,%rax,1)
 1087530:	48 83 c0 04          	add    $0x4,%rax
 1087534:	48 39 c1             	cmp    %rax,%rcx
 1087537:	74 dd                	je     1087516 <check_input_run+0x7206>
 1087539:	48 8b 94 24 e0 04 00 	mov    0x4e0(%rsp),%rdx
 1087540:	00 
 1087541:	48 85 d2             	test   %rdx,%rdx
 1087544:	74 06                	je     108754c <check_input_run+0x723c>
 1087546:	f6 04 02 02          	testb  $0x2,(%rdx,%rax,1)
 108754a:	75 0c                	jne    1087558 <check_input_run+0x7248>
 108754c:	48 8b 94 24 e8 04 00 	mov    0x4e8(%rsp),%rdx
 1087553:	00 
 1087554:	80 0c 02 08          	orb    $0x8,(%rdx,%rax,1)
 1087558:	48 8b 94 24 e0 04 00 	mov    0x4e0(%rsp),%rdx
 108755f:	00 
 1087560:	48 85 d2             	test   %rdx,%rdx
 1087563:	74 07                	je     108756c <check_input_run+0x725c>
 1087565:	f6 44 02 01 02       	testb  $0x2,0x1(%rdx,%rax,1)
 108756a:	75 0d                	jne    1087579 <check_input_run+0x7269>
 108756c:	48 8b 94 24 e8 04 00 	mov    0x4e8(%rsp),%rdx
 1087573:	00 
 1087574:	80 4c 02 01 08       	orb    $0x8,0x1(%rdx,%rax,1)
 1087579:	48 8b 94 24 e0 04 00 	mov    0x4e0(%rsp),%rdx
 1087580:	00 
 1087581:	48 85 d2             	test   %rdx,%rdx
 1087584:	74 07                	je     108758d <check_input_run+0x727d>
 1087586:	f6 44 02 02 02       	testb  $0x2,0x2(%rdx,%rax,1)
 108758b:	75 0d                	jne    108759a <check_input_run+0x728a>
 108758d:	48 8b 94 24 e8 04 00 	mov    0x4e8(%rsp),%rdx
 1087594:	00 
 1087595:	80 4c 02 02 08       	orb    $0x8,0x2(%rdx,%rax,1)
 108759a:	48 8b 94 24 e0 04 00 	mov    0x4e0(%rsp),%rdx
 10875a1:	00 
 10875a2:	48 85 d2             	test   %rdx,%rdx
 10875a5:	0f 84 78 ff ff ff    	je     1087523 <check_input_run+0x7213>
 10875ab:	f6 44 02 03 02       	testb  $0x2,0x3(%rdx,%rax,1)
 10875b0:	0f 84 6d ff ff ff    	je     1087523 <check_input_run+0x7213>
 10875b6:	e9 75 ff ff ff       	jmp    1087530 <check_input_run+0x7220>
 10875bb:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 10875c0:	8b 80 30 02 00 00    	mov    0x230(%rax),%eax
 10875c6:	80 bc 24 00 07 00 00 	cmpb   $0x0,0x700(%rsp)
 10875cd:	00 
 10875ce:	0f 84 00 01 00 00    	je     10876d4 <check_input_run+0x73c4>
 10875d4:	85 c0                	test   %eax,%eax
 10875d6:	0f 85 00 01 00 00    	jne    10876dc <check_input_run+0x73cc>
 10875dc:	48 8b 84 24 68 02 00 	mov    0x268(%rsp),%rax
 10875e3:	00 
 10875e4:	83 78 30 00          	cmpl   $0x0,0x30(%rax)
 10875e8:	0f 84 1d 02 00 00    	je     108780b <check_input_run+0x74fb>
 10875ee:	48 8b 94 24 60 02 00 	mov    0x260(%rsp),%rdx
 10875f5:	00 
 10875f6:	31 c9                	xor    %ecx,%ecx
 10875f8:	eb 25                	jmp    108761f <check_input_run+0x730f>
 10875fa:	c6 82 bd 03 00 00 01 	movb   $0x1,0x3bd(%rdx)
 1087601:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1087608:	0f 1f 84 00 00 00 00 
 108760f:	00 
 1087610:	8b 70 30             	mov    0x30(%rax),%esi
 1087613:	48 ff c1             	inc    %rcx
 1087616:	48 39 f1             	cmp    %rsi,%rcx
 1087619:	0f 83 aa 00 00 00    	jae    10876c9 <check_input_run+0x73b9>
 108761f:	48 8b b2 a0 02 00 00 	mov    0x2a0(%rdx),%rsi
 1087626:	80 3c 0e 00          	cmpb   $0x0,(%rsi,%rcx,1)
 108762a:	74 e4                	je     1087610 <check_input_run+0x7300>
 108762c:	48 8b b4 24 00 03 00 	mov    0x300(%rsp),%rsi
 1087633:	00 
 1087634:	4c 8b 84 24 78 02 00 	mov    0x278(%rsp),%r8
 108763b:	00 
 108763c:	8b 3c 8e             	mov    (%rsi,%rcx,4),%edi
 108763f:	4d 8b 08             	mov    (%r8),%r9
 1087642:	49 8b 70 10          	mov    0x10(%r8),%rsi
 1087646:	c1 ef 03             	shr    $0x3,%edi
 1087649:	45 0f b6 0c 39       	movzbl (%r9,%rdi,1),%r9d
 108764e:	41 80 f9 0f          	cmp    $0xf,%r9b
 1087652:	75 13                	jne    1087667 <check_input_run+0x7357>
 1087654:	4d 8b 40 20          	mov    0x20(%r8),%r8
 1087658:	41 8b 3c b8          	mov    (%r8,%rdi,4),%edi
 108765c:	c1 ef 03             	shr    $0x3,%edi
 108765f:	f6 04 3e 04          	testb  $0x4,(%rsi,%rdi,1)
 1087663:	75 ab                	jne    1087610 <check_input_run+0x7300>
 1087665:	eb 10                	jmp    1087677 <check_input_run+0x7367>
 1087667:	41 80 f9 09          	cmp    $0x9,%r9b
 108766b:	74 a3                	je     1087610 <check_input_run+0x7300>
 108766d:	0f b6 34 3e          	movzbl (%rsi,%rdi,1),%esi
 1087671:	40 80 e6 04          	and    $0x4,%sil
 1087675:	75 99                	jne    1087610 <check_input_run+0x7300>
 1087677:	8b b2 30 02 00 00    	mov    0x230(%rdx),%esi
 108767d:	3b b2 34 02 00 00    	cmp    0x234(%rdx),%esi
 1087683:	0f 83 71 ff ff ff    	jae    10875fa <check_input_run+0x72ea>
 1087689:	0f b6 ba bd 03 00 00 	movzbl 0x3bd(%rdx),%edi
 1087690:	4c 8b 82 28 02 00 00 	mov    0x228(%rdx),%r8
 1087697:	44 8d 4e 01          	lea    0x1(%rsi),%r9d
 108769b:	44 89 8a 30 02 00 00 	mov    %r9d,0x230(%rdx)
 10876a2:	48 8d 14 76          	lea    (%rsi,%rsi,2),%rdx
 10876a6:	8d 7c 7f 01          	lea    0x1(%rdi,%rdi,2),%edi
 10876aa:	41 89 0c 90          	mov    %ecx,(%r8,%rdx,4)
 10876ae:	41 89 7c 90 04       	mov    %edi,0x4(%r8,%rdx,4)
 10876b3:	41 c7 44 90 08 00 00 	movl   $0x0,0x8(%r8,%rdx,4)
 10876ba:	00 00 
 10876bc:	48 8b 94 24 60 02 00 	mov    0x260(%rsp),%rdx
 10876c3:	00 
 10876c4:	e9 47 ff ff ff       	jmp    1087610 <check_input_run+0x7300>
 10876c9:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 10876ce:	8b 80 30 02 00 00    	mov    0x230(%rax),%eax
 10876d4:	85 c0                	test   %eax,%eax
 10876d6:	0f 84 2f 01 00 00    	je     108780b <check_input_run+0x74fb>
 10876dc:	8b bc 24 30 06 00 00 	mov    0x630(%rsp),%edi
 10876e3:	89 c2                	mov    %eax,%edx
 10876e5:	89 d1                	mov    %edx,%ecx
 10876e7:	83 e1 07             	and    $0x7,%ecx
 10876ea:	83 f8 08             	cmp    $0x8,%eax
 10876ed:	73 07                	jae    10876f6 <check_input_run+0x73e6>
 10876ef:	31 c0                	xor    %eax,%eax
 10876f1:	e9 f0 00 00 00       	jmp    10877e6 <check_input_run+0x74d6>
 10876f6:	c1 ea 03             	shr    $0x3,%edx
 10876f9:	31 c0                	xor    %eax,%eax
 10876fb:	31 f6                	xor    %esi,%esi
 10876fd:	48 c1 e2 05          	shl    $0x5,%rdx
 1087701:	48 8d 14 52          	lea    (%rdx,%rdx,2),%rdx
 1087705:	eb 21                	jmp    1087728 <check_input_run+0x7418>
 1087707:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
 108770e:	00 00 
 1087710:	48 83 c0 08          	add    $0x8,%rax
 1087714:	48 83 c6 60          	add    $0x60,%rsi
 1087718:	89 bc 24 30 06 00 00 	mov    %edi,0x630(%rsp)
 108771f:	48 39 f2             	cmp    %rsi,%rdx
 1087722:	0f 84 b9 00 00 00    	je     10877e1 <check_input_run+0x74d1>
 1087728:	4d 8b 03             	mov    (%r11),%r8
 108772b:	45 8b 04 30          	mov    (%r8,%rsi,1),%r8d
 108772f:	41 39 f8             	cmp    %edi,%r8d
 1087732:	72 03                	jb     1087737 <check_input_run+0x7427>
 1087734:	41 89 f8             	mov    %edi,%r8d
 1087737:	44 89 84 24 30 06 00 	mov    %r8d,0x630(%rsp)
 108773e:	00 
 108773f:	49 8b 3b             	mov    (%r11),%rdi
 1087742:	8b 7c 37 0c          	mov    0xc(%rdi,%rsi,1),%edi
 1087746:	44 39 c7             	cmp    %r8d,%edi
 1087749:	72 03                	jb     108774e <check_input_run+0x743e>
 108774b:	44 89 c7             	mov    %r8d,%edi
 108774e:	89 bc 24 30 06 00 00 	mov    %edi,0x630(%rsp)
 1087755:	4d 8b 03             	mov    (%r11),%r8
 1087758:	45 8b 44 30 18       	mov    0x18(%r8,%rsi,1),%r8d
 108775d:	41 39 f8             	cmp    %edi,%r8d
 1087760:	72 03                	jb     1087765 <check_input_run+0x7455>
 1087762:	41 89 f8             	mov    %edi,%r8d
 1087765:	44 89 84 24 30 06 00 	mov    %r8d,0x630(%rsp)
 108776c:	00 
 108776d:	49 8b 3b             	mov    (%r11),%rdi
 1087770:	8b 7c 37 24          	mov    0x24(%rdi,%rsi,1),%edi
 1087774:	44 39 c7             	cmp    %r8d,%edi
 1087777:	72 03                	jb     108777c <check_input_run+0x746c>
 1087779:	44 89 c7             	mov    %r8d,%edi
 108777c:	89 bc 24 30 06 00 00 	mov    %edi,0x630(%rsp)
 1087783:	4d 8b 03             	mov    (%r11),%r8
 1087786:	45 8b 44 30 30       	mov    0x30(%r8,%rsi,1),%r8d
 108778b:	41 39 f8             	cmp    %edi,%r8d
 108778e:	72 03                	jb     1087793 <check_input_run+0x7483>
 1087790:	41 89 f8             	mov    %edi,%r8d
 1087793:	44 89 84 24 30 06 00 	mov    %r8d,0x630(%rsp)
 108779a:	00 
 108779b:	49 8b 3b             	mov    (%r11),%rdi
 108779e:	8b 7c 37 3c          	mov    0x3c(%rdi,%rsi,1),%edi
 10877a2:	44 39 c7             	cmp    %r8d,%edi
 10877a5:	72 03                	jb     10877aa <check_input_run+0x749a>
 10877a7:	44 89 c7             	mov    %r8d,%edi
 10877aa:	89 bc 24 30 06 00 00 	mov    %edi,0x630(%rsp)
 10877b1:	4d 8b 03             	mov    (%r11),%r8
 10877b4:	45 8b 44 30 48       	mov    0x48(%r8,%rsi,1),%r8d
 10877b9:	41 39 f8             	cmp    %edi,%r8d
 10877bc:	72 03                	jb     10877c1 <check_input_run+0x74b1>
 10877be:	41 89 f8             	mov    %edi,%r8d
 10877c1:	44 89 84 24 30 06 00 	mov    %r8d,0x630(%rsp)
 10877c8:	00 
 10877c9:	49 8b 3b             	mov    (%r11),%rdi
 10877cc:	8b 7c 37 54          	mov    0x54(%rdi,%rsi,1),%edi
 10877d0:	44 39 c7             	cmp    %r8d,%edi
 10877d3:	0f 82 37 ff ff ff    	jb     1087710 <check_input_run+0x7400>
 10877d9:	44 89 c7             	mov    %r8d,%edi
 10877dc:	e9 2f ff ff ff       	jmp    1087710 <check_input_run+0x7400>
 10877e1:	48 85 c9             	test   %rcx,%rcx
 10877e4:	74 25                	je     108780b <check_input_run+0x74fb>
 10877e6:	48 c1 e0 02          	shl    $0x2,%rax
 10877ea:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
 10877ee:	66 90                	xchg   %ax,%ax
 10877f0:	49 8b 13             	mov    (%r11),%rdx
 10877f3:	8b 14 02             	mov    (%rdx,%rax,1),%edx
 10877f6:	39 fa                	cmp    %edi,%edx
 10877f8:	0f 42 fa             	cmovb  %edx,%edi
 10877fb:	48 83 c0 0c          	add    $0xc,%rax
 10877ff:	48 ff c9             	dec    %rcx
 1087802:	89 bc 24 30 06 00 00 	mov    %edi,0x630(%rsp)
 1087809:	75 e5                	jne    10877f0 <check_input_run+0x74e0>
 108780b:	48 8b 84 24 18 01 00 	mov    0x118(%rsp),%rax
 1087812:	00 
 1087813:	8b 98 a0 00 00 00    	mov    0xa0(%rax),%ebx
 1087819:	48 85 db             	test   %rbx,%rbx
 108781c:	74 20                	je     108783e <check_input_run+0x752e>
 108781e:	48 8b 04 24          	mov    (%rsp),%rax
 1087822:	48 8b 08             	mov    (%rax),%rcx
 1087825:	48 8b 40 08          	mov    0x8(%rax),%rax
 1087829:	4c 8d 7c 08 03       	lea    0x3(%rax,%rcx,1),%r15
 108782e:	48 01 c8             	add    %rcx,%rax
 1087831:	49 83 e7 fc          	and    $0xfffffffffffffffc,%r15
 1087835:	49 39 c7             	cmp    %rax,%r15
 1087838:	0f 83 98 00 00 00    	jae    10878d6 <check_input_run+0x75c6>
 108783e:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
 1087843:	85 db                	test   %ebx,%ebx
 1087845:	0f 95 c0             	setne  %al
 1087848:	08 81 bd 03 00 00    	or     %al,0x3bd(%rcx)
 108784e:	48 8b b4 24 c0 05 00 	mov    0x5c0(%rsp),%rsi
 1087855:	00 
 1087856:	48 8b 14 24          	mov    (%rsp),%rdx
 108785a:	85 db                	test   %ebx,%ebx
 108785c:	0f 95 c0             	setne  %al
 108785f:	48 85 f6             	test   %rsi,%rsi
 1087862:	0f 95 c1             	setne  %cl
 1087865:	20 c1                	and    %al,%cl
 1087867:	80 f9 01             	cmp    $0x1,%cl
 108786a:	75 28                	jne    1087894 <check_input_run+0x7584>
 108786c:	48 8b 0a             	mov    (%rdx),%rcx
 108786f:	48 8b 42 08          	mov    0x8(%rdx),%rax
 1087873:	4c 8d 7c 08 03       	lea    0x3(%rax,%rcx,1),%r15
 1087878:	48 01 c8             	add    %rcx,%rax
 108787b:	49 83 e7 fc          	and    $0xfffffffffffffffc,%r15
 108787f:	49 39 c7             	cmp    %rax,%r15
 1087882:	0f 83 d3 00 00 00    	jae    108795b <check_input_run+0x764b>
 1087888:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 108788d:	c6 80 bd 03 00 00 01 	movb   $0x1,0x3bd(%rax)
 1087894:	83 7c 24 18 00       	cmpl   $0x0,0x18(%rsp)
 1087899:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 108789e:	74 21                	je     10878c1 <check_input_run+0x75b1>
 10878a0:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
 10878a5:	4c 8b 74 24 30       	mov    0x30(%rsp),%r14
 10878aa:	4c 8b 7c 24 50       	mov    0x50(%rsp),%r15
 10878af:	31 c0                	xor    %eax,%eax
 10878b1:	83 fa 01             	cmp    $0x1,%edx
 10878b4:	0f 85 8d 00 00 00    	jne    1087947 <check_input_run+0x7637>
 10878ba:	31 c9                	xor    %ecx,%ecx
 10878bc:	e9 32 03 00 00       	jmp    1087bf3 <check_input_run+0x78e3>
 10878c1:	8b b8 dc 00 00 00    	mov    0xdc(%rax),%edi
 10878c7:	4c 8b 74 24 30       	mov    0x30(%rsp),%r14
 10878cc:	4c 8b 7c 24 50       	mov    0x50(%rsp),%r15
 10878d1:	e9 4f 03 00 00       	jmp    1087c25 <check_input_run+0x7915>
 10878d6:	4c 89 f8             	mov    %r15,%rax
 10878d9:	48 29 c8             	sub    %rcx,%rax
 10878dc:	48 8b 0c 24          	mov    (%rsp),%rcx
 10878e0:	48 8b 49 10          	mov    0x10(%rcx),%rcx
 10878e4:	48 29 c1             	sub    %rax,%rcx
 10878e7:	0f 82 51 ff ff ff    	jb     108783e <check_input_run+0x752e>
 10878ed:	48 8d 14 9d 00 00 00 	lea    0x0(,%rbx,4),%rdx
 10878f4:	00 
 10878f5:	48 39 ca             	cmp    %rcx,%rdx
 10878f8:	0f 87 40 ff ff ff    	ja     108783e <check_input_run+0x752e>
 10878fe:	48 8b 0c 24          	mov    (%rsp),%rcx
 1087902:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
 1087907:	48 01 d0             	add    %rdx,%rax
 108790a:	4d 85 ff             	test   %r15,%r15
 108790d:	48 89 41 08          	mov    %rax,0x8(%rcx)
 1087911:	0f 94 c0             	sete   %al
 1087914:	08 86 bd 03 00 00    	or     %al,0x3bd(%rsi)
 108791a:	4d 85 ff             	test   %r15,%r15
 108791d:	0f 84 2b ff ff ff    	je     108784e <check_input_run+0x753e>
 1087923:	48 8b b4 24 b0 05 00 	mov    0x5b0(%rsp),%rsi
 108792a:	00 
 108792b:	4c 89 ff             	mov    %r15,%rdi
 108792e:	c5 f8 77             	vzeroupper
 1087931:	e8 6a 77 70 ff       	call   78f0a0 <memcpy@plt>
 1087936:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 108793b:	4c 89 78 68          	mov    %r15,0x68(%rax)
 108793f:	89 58 78             	mov    %ebx,0x78(%rax)
 1087942:	e9 07 ff ff ff       	jmp    108784e <check_input_run+0x753e>
 1087947:	83 e2 fe             	and    $0xfffffffe,%edx
 108794a:	48 be 00 00 0a 00 c0 	movabs $0xc0000a0000,%rsi
 1087951:	00 00 00 
 1087954:	31 c9                	xor    %ecx,%ecx
 1087956:	e9 95 00 00 00       	jmp    10879f0 <check_input_run+0x76e0>
 108795b:	4c 89 f8             	mov    %r15,%rax
 108795e:	48 29 c8             	sub    %rcx,%rax
 1087961:	48 8b 4a 10          	mov    0x10(%rdx),%rcx
 1087965:	48 29 c1             	sub    %rax,%rcx
 1087968:	0f 82 1a ff ff ff    	jb     1087888 <check_input_run+0x7578>
 108796e:	48 c1 e3 02          	shl    $0x2,%rbx
 1087972:	48 39 cb             	cmp    %rcx,%rbx
 1087975:	0f 87 0d ff ff ff    	ja     1087888 <check_input_run+0x7578>
 108797b:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
 1087980:	48 01 d8             	add    %rbx,%rax
 1087983:	4d 85 ff             	test   %r15,%r15
 1087986:	48 89 42 08          	mov    %rax,0x8(%rdx)
 108798a:	0f 94 c0             	sete   %al
 108798d:	08 81 bd 03 00 00    	or     %al,0x3bd(%rcx)
 1087993:	4d 85 ff             	test   %r15,%r15
 1087996:	0f 84 f8 fe ff ff    	je     1087894 <check_input_run+0x7584>
 108799c:	4c 89 ff             	mov    %r15,%rdi
 108799f:	48 89 da             	mov    %rbx,%rdx
 10879a2:	c5 f8 77             	vzeroupper
 10879a5:	e8 f6 76 70 ff       	call   78f0a0 <memcpy@plt>
 10879aa:	48 8b 14 24          	mov    (%rsp),%rdx
 10879ae:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 10879b3:	4c 89 78 70          	mov    %r15,0x70(%rax)
 10879b7:	e9 d8 fe ff ff       	jmp    1087894 <check_input_run+0x7584>
 10879bc:	41 81 f8 ce 01 00 00 	cmp    $0x1ce,%r8d
 10879c3:	0f 85 a8 01 00 00    	jne    1087b71 <check_input_run+0x7861>
 10879c9:	bf 01 00 00 00       	mov    $0x1,%edi
 10879ce:	66 90                	xchg   %ax,%ax
 10879d0:	4c 8b 44 24 08       	mov    0x8(%rsp),%r8
 10879d5:	48 83 c1 02          	add    $0x2,%rcx
 10879d9:	41 03 b8 dc 00 00 00 	add    0xdc(%r8),%edi
 10879e0:	41 89 b8 dc 00 00 00 	mov    %edi,0xdc(%r8)
 10879e7:	48 39 ca             	cmp    %rcx,%rdx
 10879ea:	0f 84 f8 01 00 00    	je     1087be8 <check_input_run+0x78d8>
 10879f0:	48 8b bc 24 68 04 00 	mov    0x468(%rsp),%rdi
 10879f7:	00 
 10879f8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
 10879fe:	0f b7 3c 4f          	movzwl (%rdi,%rcx,2),%edi
 1087a02:	44 8d 8f e0 fe ff ff 	lea    -0x120(%rdi),%r9d
 1087a09:	41 83 f9 05          	cmp    $0x5,%r9d
 1087a0d:	0f 83 bd 00 00 00    	jae    1087ad0 <check_input_run+0x77c0>
 1087a13:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
 1087a18:	44 01 87 dc 00 00 00 	add    %r8d,0xdc(%rdi)
 1087a1f:	48 8b bc 24 68 04 00 	mov    0x468(%rsp),%rdi
 1087a26:	00 
 1087a27:	44 0f b7 44 4f 02    	movzwl 0x2(%rdi,%rcx,2),%r8d
 1087a2d:	31 ff                	xor    %edi,%edi
 1087a2f:	45 8d 88 e0 fe ff ff 	lea    -0x120(%r8),%r9d
 1087a36:	41 83 f9 05          	cmp    $0x5,%r9d
 1087a3a:	72 94                	jb     10879d0 <check_input_run+0x76c0>
 1087a3c:	41 81 f8 17 03 00 00 	cmp    $0x317,%r8d
 1087a43:	74 8b                	je     10879d0 <check_input_run+0x76c0>
 1087a45:	45 8d 88 a0 fe ff ff 	lea    -0x160(%r8),%r9d
 1087a4c:	45 89 c2             	mov    %r8d,%r10d
 1087a4f:	66 41 83 f9 06       	cmp    $0x6,%r9w
 1087a54:	41 0f 92 c1          	setb   %r9b
 1087a58:	41 83 e2 fc          	and    $0xfffffffc,%r10d
 1087a5c:	66 41 81 fa f0 01    	cmp    $0x1f0,%r10w
 1087a62:	41 0f 94 c2          	sete   %r10b
 1087a66:	45 08 ca             	or     %r9b,%r10b
 1087a69:	0f 85 61 ff ff ff    	jne    10879d0 <check_input_run+0x76c0>
 1087a6f:	45 8d 88 c0 fe ff ff 	lea    -0x140(%r8),%r9d
 1087a76:	45 8d 90 00 fe ff ff 	lea    -0x200(%r8),%r10d
 1087a7d:	66 41 83 f9 13       	cmp    $0x13,%r9w
 1087a82:	41 0f 92 c1          	setb   %r9b
 1087a86:	66 41 83 fa 0e       	cmp    $0xe,%r10w
 1087a8b:	41 0f 92 c2          	setb   %r10b
 1087a8f:	45 08 ca             	or     %r9b,%r10b
 1087a92:	0f 85 31 ff ff ff    	jne    10879c9 <check_input_run+0x76b9>
 1087a98:	41 81 f8 6f 01 00 00 	cmp    $0x16f,%r8d
 1087a9f:	0f 8e b2 00 00 00    	jle    1087b57 <check_input_run+0x7847>
 1087aa5:	45 8d 88 90 fe ff ff 	lea    -0x170(%r8),%r9d
 1087aac:	41 83 f9 27          	cmp    $0x27,%r9d
 1087ab0:	0f 87 06 ff ff ff    	ja     10879bc <check_input_run+0x76ac>
 1087ab6:	4c 0f a3 ce          	bt     %r9,%rsi
 1087aba:	0f 82 09 ff ff ff    	jb     10879c9 <check_input_run+0x76b9>
 1087ac0:	4d 85 c9             	test   %r9,%r9
 1087ac3:	0f 84 07 ff ff ff    	je     10879d0 <check_input_run+0x76c0>
 1087ac9:	e9 ee fe ff ff       	jmp    10879bc <check_input_run+0x76ac>
 1087ace:	66 90                	xchg   %ax,%ax
 1087ad0:	81 ff 17 03 00 00    	cmp    $0x317,%edi
 1087ad6:	0f 84 37 ff ff ff    	je     1087a13 <check_input_run+0x7703>
 1087adc:	44 8d 87 a0 fe ff ff 	lea    -0x160(%rdi),%r8d
 1087ae3:	41 89 f9             	mov    %edi,%r9d
 1087ae6:	66 41 83 f8 06       	cmp    $0x6,%r8w
 1087aeb:	41 0f 92 c0          	setb   %r8b
 1087aef:	41 83 e1 fc          	and    $0xfffffffc,%r9d
 1087af3:	66 41 81 f9 f0 01    	cmp    $0x1f0,%r9w
 1087af9:	41 0f 94 c1          	sete   %r9b
 1087afd:	45 08 c1             	or     %r8b,%r9b
 1087b00:	41 b8 00 00 00 00    	mov    $0x0,%r8d
 1087b06:	0f 85 07 ff ff ff    	jne    1087a13 <check_input_run+0x7703>
 1087b0c:	44 8d 87 c0 fe ff ff 	lea    -0x140(%rdi),%r8d
 1087b13:	44 8d 8f 00 fe ff ff 	lea    -0x200(%rdi),%r9d
 1087b1a:	66 41 83 f8 13       	cmp    $0x13,%r8w
 1087b1f:	41 0f 92 c0          	setb   %r8b
 1087b23:	66 41 83 f9 0e       	cmp    $0xe,%r9w
 1087b28:	41 0f 92 c1          	setb   %r9b
 1087b2c:	45 08 c1             	or     %r8b,%r9b
 1087b2f:	75 1b                	jne    1087b4c <check_input_run+0x783c>
 1087b31:	81 ff 6f 01 00 00    	cmp    $0x16f,%edi
 1087b37:	7e 5c                	jle    1087b95 <check_input_run+0x7885>
 1087b39:	44 8d 8f 90 fe ff ff 	lea    -0x170(%rdi),%r9d
 1087b40:	41 83 f9 27          	cmp    $0x27,%r9d
 1087b44:	77 70                	ja     1087bb6 <check_input_run+0x78a6>
 1087b46:	4c 0f a3 ce          	bt     %r9,%rsi
 1087b4a:	73 5b                	jae    1087ba7 <check_input_run+0x7897>
 1087b4c:	41 b8 01 00 00 00    	mov    $0x1,%r8d
 1087b52:	e9 bc fe ff ff       	jmp    1087a13 <check_input_run+0x7703>
 1087b57:	41 81 f8 30 01 00 00 	cmp    $0x130,%r8d
 1087b5e:	0f 84 65 fe ff ff    	je     10879c9 <check_input_run+0x76b9>
 1087b64:	41 81 f8 33 01 00 00 	cmp    $0x133,%r8d
 1087b6b:	0f 84 58 fe ff ff    	je     10879c9 <check_input_run+0x76b9>
 1087b71:	45 8d 88 00 fd ff ff 	lea    -0x300(%r8),%r9d
 1087b78:	66 41 83 f9 16       	cmp    $0x16,%r9w
 1087b7d:	0f 87 4d fe ff ff    	ja     10879d0 <check_input_run+0x76c0>
 1087b83:	31 ff                	xor    %edi,%edi
 1087b85:	41 81 f8 12 03 00 00 	cmp    $0x312,%r8d
 1087b8c:	40 0f 94 c7          	sete   %dil
 1087b90:	e9 3b fe ff ff       	jmp    10879d0 <check_input_run+0x76c0>
 1087b95:	81 ff 30 01 00 00    	cmp    $0x130,%edi
 1087b9b:	74 af                	je     1087b4c <check_input_run+0x783c>
 1087b9d:	81 ff 33 01 00 00    	cmp    $0x133,%edi
 1087ba3:	74 a7                	je     1087b4c <check_input_run+0x783c>
 1087ba5:	eb 17                	jmp    1087bbe <check_input_run+0x78ae>
 1087ba7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
 1087bad:	4d 85 c9             	test   %r9,%r9
 1087bb0:	0f 84 5d fe ff ff    	je     1087a13 <check_input_run+0x7703>
 1087bb6:	81 ff ce 01 00 00    	cmp    $0x1ce,%edi
 1087bbc:	74 8e                	je     1087b4c <check_input_run+0x783c>
 1087bbe:	44 8d 8f 00 fd ff ff 	lea    -0x300(%rdi),%r9d
 1087bc5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
 1087bcb:	66 41 83 f9 16       	cmp    $0x16,%r9w
 1087bd0:	0f 87 3d fe ff ff    	ja     1087a13 <check_input_run+0x7703>
 1087bd6:	45 31 c0             	xor    %r8d,%r8d
 1087bd9:	81 ff 12 03 00 00    	cmp    $0x312,%edi
 1087bdf:	41 0f 94 c0          	sete   %r8b
 1087be3:	e9 2b fe ff ff       	jmp    1087a13 <check_input_run+0x7703>
 1087be8:	f6 44 24 58 01       	testb  $0x1,0x58(%rsp)
 1087bed:	48 8b 14 24          	mov    (%rsp),%rdx
 1087bf1:	74 32                	je     1087c25 <check_input_run+0x7915>
 1087bf3:	48 8b 94 24 68 04 00 	mov    0x468(%rsp),%rdx
 1087bfa:	00 
 1087bfb:	0f b7 0c 4a          	movzwl (%rdx,%rcx,2),%ecx
 1087bff:	8d 91 e0 fe ff ff    	lea    -0x120(%rcx),%edx
 1087c05:	83 fa 05             	cmp    $0x5,%edx
 1087c08:	0f 83 33 03 00 00    	jae    1087f41 <check_input_run+0x7c31>
 1087c0e:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
 1087c13:	48 8b 14 24          	mov    (%rsp),%rdx
 1087c17:	03 81 dc 00 00 00    	add    0xdc(%rcx),%eax
 1087c1d:	89 c7                	mov    %eax,%edi
 1087c1f:	89 81 dc 00 00 00    	mov    %eax,0xdc(%rcx)
 1087c25:	85 ff                	test   %edi,%edi
 1087c27:	74 65                	je     1087c8e <check_input_run+0x797e>
 1087c29:	48 8b 0a             	mov    (%rdx),%rcx
 1087c2c:	48 89 d6             	mov    %rdx,%rsi
 1087c2f:	48 8b 52 08          	mov    0x8(%rdx),%rdx
 1087c33:	48 8d 44 0a 07       	lea    0x7(%rdx,%rcx,1),%rax
 1087c38:	48 01 ca             	add    %rcx,%rdx
 1087c3b:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
 1087c3f:	48 39 d0             	cmp    %rdx,%rax
 1087c42:	73 04                	jae    1087c48 <check_input_run+0x7938>
 1087c44:	31 c9                	xor    %ecx,%ecx
 1087c46:	eb 2a                	jmp    1087c72 <check_input_run+0x7962>
 1087c48:	48 8b 76 10          	mov    0x10(%rsi),%rsi
 1087c4c:	48 89 c2             	mov    %rax,%rdx
 1087c4f:	48 29 ca             	sub    %rcx,%rdx
 1087c52:	31 c9                	xor    %ecx,%ecx
 1087c54:	48 29 d6             	sub    %rdx,%rsi
 1087c57:	72 19                	jb     1087c72 <check_input_run+0x7962>
 1087c59:	89 ff                	mov    %edi,%edi
 1087c5b:	48 6b ff 78          	imul   $0x78,%rdi,%rdi
 1087c5f:	48 39 f7             	cmp    %rsi,%rdi
 1087c62:	77 0e                	ja     1087c72 <check_input_run+0x7962>
 1087c64:	48 8b 0c 24          	mov    (%rsp),%rcx
 1087c68:	48 01 fa             	add    %rdi,%rdx
 1087c6b:	48 89 51 08          	mov    %rdx,0x8(%rcx)
 1087c6f:	48 89 c1             	mov    %rax,%rcx
 1087c72:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
 1087c77:	48 85 c9             	test   %rcx,%rcx
 1087c7a:	0f 94 c0             	sete   %al
 1087c7d:	48 89 8a d0 00 00 00 	mov    %rcx,0xd0(%rdx)
 1087c84:	08 82 bd 03 00 00    	or     %al,0x3bd(%rdx)
 1087c8a:	48 8b 14 24          	mov    (%rsp),%rdx
 1087c8e:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 1087c93:	8b 88 10 02 00 00    	mov    0x210(%rax),%ecx
 1087c99:	48 85 c9             	test   %rcx,%rcx
 1087c9c:	74 69                	je     1087d07 <check_input_run+0x79f7>
 1087c9e:	89 88 fc 00 00 00    	mov    %ecx,0xfc(%rax)
 1087ca4:	49 89 d0             	mov    %rdx,%r8
 1087ca7:	48 8b 32             	mov    (%rdx),%rsi
 1087caa:	48 8b 52 08          	mov    0x8(%rdx),%rdx
 1087cae:	48 8d 44 32 07       	lea    0x7(%rdx,%rsi,1),%rax
 1087cb3:	48 01 f2             	add    %rsi,%rdx
 1087cb6:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
 1087cba:	48 39 d0             	cmp    %rdx,%rax
 1087cbd:	72 25                	jb     1087ce4 <check_input_run+0x79d4>
 1087cbf:	48 89 c2             	mov    %rax,%rdx
 1087cc2:	48 29 f2             	sub    %rsi,%rdx
 1087cc5:	49 8b 70 10          	mov    0x10(%r8),%rsi
 1087cc9:	48 c1 e1 03          	shl    $0x3,%rcx
 1087ccd:	48 8d 0c 89          	lea    (%rcx,%rcx,4),%rcx
 1087cd1:	48 29 d6             	sub    %rdx,%rsi
 1087cd4:	40 0f 92 c7          	setb   %dil
 1087cd8:	48 39 f1             	cmp    %rsi,%rcx
 1087cdb:	40 0f 97 c6          	seta   %sil
 1087cdf:	40 08 fe             	or     %dil,%sil
 1087ce2:	74 04                	je     1087ce8 <check_input_run+0x79d8>
 1087ce4:	31 c0                	xor    %eax,%eax
 1087ce6:	eb 07                	jmp    1087cef <check_input_run+0x79df>
 1087ce8:	48 01 ca             	add    %rcx,%rdx
 1087ceb:	49 89 50 08          	mov    %rdx,0x8(%r8)
 1087cef:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
 1087cf4:	48 85 c0             	test   %rax,%rax
 1087cf7:	0f 94 c2             	sete   %dl
 1087cfa:	48 89 81 f0 00 00 00 	mov    %rax,0xf0(%rcx)
 1087d01:	08 91 bd 03 00 00    	or     %dl,0x3bd(%rcx)
 1087d07:	83 7c 24 18 00       	cmpl   $0x0,0x18(%rsp)
 1087d0c:	0f 84 86 01 00 00    	je     1087e98 <check_input_run+0x7b88>
 1087d12:	31 db                	xor    %ebx,%ebx
 1087d14:	eb 18                	jmp    1087d2e <check_input_run+0x7a1e>
 1087d16:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 1087d1d:	00 00 00 
 1087d20:	48 ff c3             	inc    %rbx
 1087d23:	48 3b 5c 24 58       	cmp    0x58(%rsp),%rbx
 1087d28:	0f 84 6a 01 00 00    	je     1087e98 <check_input_run+0x7b88>
 1087d2e:	49 8b 06             	mov    (%r14),%rax
 1087d31:	80 3c 18 00          	cmpb   $0x0,(%rax,%rbx,1)
 1087d35:	74 37                	je     1087d6e <check_input_run+0x7a5e>
 1087d37:	49 8b 07             	mov    (%r15),%rax
 1087d3a:	48 8b 8c 24 28 01 00 	mov    0x128(%rsp),%rcx
 1087d41:	00 
 1087d42:	8b 3c 98             	mov    (%rax,%rbx,4),%edi
 1087d45:	48 8b 01             	mov    (%rcx),%rax
 1087d48:	8b 14 98             	mov    (%rax,%rbx,4),%edx
 1087d4b:	39 fa                	cmp    %edi,%edx
 1087d4d:	76 1f                	jbe    1087d6e <check_input_run+0x7a5e>
 1087d4f:	3b 54 24 18          	cmp    0x18(%rsp),%edx
 1087d53:	77 19                	ja     1087d6e <check_input_run+0x7a5e>
 1087d55:	89 f8                	mov    %edi,%eax
 1087d57:	48 03 bc 24 e0 04 00 	add    0x4e0(%rsp),%rdi
 1087d5e:	00 
 1087d5f:	29 c2                	sub    %eax,%edx
 1087d61:	be 01 00 00 00       	mov    $0x1,%esi
 1087d66:	c5 f8 77             	vzeroupper
 1087d69:	e8 12 72 70 ff       	call   78ef80 <memset@plt>
 1087d6e:	49 8b 44 24 10       	mov    0x10(%r12),%rax
 1087d73:	0f b6 0c 18          	movzbl (%rax,%rbx,1),%ecx
 1087d77:	80 f9 43             	cmp    $0x43,%cl
 1087d7a:	75 74                	jne    1087df0 <check_input_run+0x7ae0>
 1087d7c:	48 8d 53 01          	lea    0x1(%rbx),%rdx
 1087d80:	48 3b 54 24 58       	cmp    0x58(%rsp),%rdx
 1087d85:	73 99                	jae    1087d20 <check_input_run+0x7a10>
 1087d87:	49 8b 4c 24 60       	mov    0x60(%r12),%rcx
 1087d8c:	8b 74 99 04          	mov    0x4(%rcx,%rbx,4),%esi
 1087d90:	48 39 f2             	cmp    %rsi,%rdx
 1087d93:	0f 92 c2             	setb   %dl
 1087d96:	3b 74 24 18          	cmp    0x18(%rsp),%esi
 1087d9a:	40 0f 92 c7          	setb   %dil
 1087d9e:	40 20 d7             	and    %dl,%dil
 1087da1:	40 80 ff 01          	cmp    $0x1,%dil
 1087da5:	0f 85 75 ff ff ff    	jne    1087d20 <check_input_run+0x7a10>
 1087dab:	48 8d 7b 02          	lea    0x2(%rbx),%rdi
 1087daf:	48 39 f7             	cmp    %rsi,%rdi
 1087db2:	0f 82 ac 00 00 00    	jb     1087e64 <check_input_run+0x7b54>
 1087db8:	89 fa                	mov    %edi,%edx
 1087dba:	48 8b 84 24 e0 04 00 	mov    0x4e0(%rsp),%rax
 1087dc1:	00 
 1087dc2:	29 da                	sub    %ebx,%edx
 1087dc4:	be 01 00 00 00       	mov    $0x1,%esi
 1087dc9:	83 c2 fe             	add    $0xfffffffe,%edx
 1087dcc:	48 8d 7c 18 02       	lea    0x2(%rax,%rbx,1),%rdi
 1087dd1:	c5 f8 77             	vzeroupper
 1087dd4:	e8 a7 71 70 ff       	call   78ef80 <memset@plt>
 1087dd9:	49 8b 44 24 10       	mov    0x10(%r12),%rax
 1087dde:	0f b6 0c 18          	movzbl (%rax,%rbx,1),%ecx
 1087de2:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1087de9:	1f 84 00 00 00 00 00 
 1087df0:	80 f9 4a             	cmp    $0x4a,%cl
 1087df3:	0f 85 27 ff ff ff    	jne    1087d20 <check_input_run+0x7a10>
 1087df9:	49 8b 44 24 60       	mov    0x60(%r12),%rax
 1087dfe:	8b 04 98             	mov    (%rax,%rbx,4),%eax
 1087e01:	48 39 c3             	cmp    %rax,%rbx
 1087e04:	0f 92 c1             	setb   %cl
 1087e07:	3b 44 24 18          	cmp    0x18(%rsp),%eax
 1087e0b:	0f 92 c2             	setb   %dl
 1087e0e:	20 ca                	and    %cl,%dl
 1087e10:	80 fa 01             	cmp    $0x1,%dl
 1087e13:	0f 85 07 ff ff ff    	jne    1087d20 <check_input_run+0x7a10>
 1087e19:	48 8b 8c 24 e0 04 00 	mov    0x4e0(%rsp),%rcx
 1087e20:	00 
 1087e21:	89 da                	mov    %ebx,%edx
 1087e23:	f7 d2                	not    %edx
 1087e25:	be 01 00 00 00       	mov    $0x1,%esi
 1087e2a:	01 c2                	add    %eax,%edx
 1087e2c:	48 8d 7c 19 01       	lea    0x1(%rcx,%rbx,1),%rdi
 1087e31:	c5 f8 77             	vzeroupper
 1087e34:	e8 47 71 70 ff       	call   78ef80 <memset@plt>
 1087e39:	e9 e2 fe ff ff       	jmp    1087d20 <check_input_run+0x7a10>
 1087e3e:	66 90                	xchg   %ax,%ax
 1087e40:	41 83 f8 0a          	cmp    $0xa,%r8d
 1087e44:	75 39                	jne    1087e7f <check_input_run+0x7b6f>
 1087e46:	44 8b 04 91          	mov    (%rcx,%rdx,4),%r8d
 1087e4a:	41 8d 50 01          	lea    0x1(%r8),%edx
 1087e4e:	41 39 f0             	cmp    %esi,%r8d
 1087e51:	0f 43 d6             	cmovae %esi,%edx
 1087e54:	41 39 f8             	cmp    %edi,%r8d
 1087e57:	0f 46 d6             	cmovbe %esi,%edx
 1087e5a:	89 d7                	mov    %edx,%edi
 1087e5c:	39 f2                	cmp    %esi,%edx
 1087e5e:	0f 83 56 ff ff ff    	jae    1087dba <check_input_run+0x7aaa>
 1087e64:	89 fa                	mov    %edi,%edx
 1087e66:	44 0f b6 04 10       	movzbl (%rax,%rdx,1),%r8d
 1087e6b:	41 83 f8 09          	cmp    $0x9,%r8d
 1087e6f:	7f cf                	jg     1087e40 <check_input_run+0x7b30>
 1087e71:	41 83 f8 06          	cmp    $0x6,%r8d
 1087e75:	74 cf                	je     1087e46 <check_input_run+0x7b36>
 1087e77:	41 83 f8 08          	cmp    $0x8,%r8d
 1087e7b:	74 c9                	je     1087e46 <check_input_run+0x7b36>
 1087e7d:	eb 0a                	jmp    1087e89 <check_input_run+0x7b79>
 1087e7f:	41 83 f8 33          	cmp    $0x33,%r8d
 1087e83:	0f 84 2f ff ff ff    	je     1087db8 <check_input_run+0x7aa8>
 1087e89:	ff c7                	inc    %edi
 1087e8b:	89 fa                	mov    %edi,%edx
 1087e8d:	89 d7                	mov    %edx,%edi
 1087e8f:	39 f2                	cmp    %esi,%edx
 1087e91:	72 d1                	jb     1087e64 <check_input_run+0x7b54>
 1087e93:	e9 22 ff ff ff       	jmp    1087dba <check_input_run+0x7aaa>
 1087e98:	48 8b 84 24 60 02 00 	mov    0x260(%rsp),%rax
 1087e9f:	00 
 1087ea0:	8b 88 20 03 00 00    	mov    0x320(%rax),%ecx
 1087ea6:	48 85 c9             	test   %rcx,%rcx
 1087ea9:	0f 84 49 07 00 00    	je     10885f8 <check_input_run+0x82e8>
 1087eaf:	48 8b b0 10 03 00 00 	mov    0x310(%rax),%rsi
 1087eb6:	8b 3e                	mov    (%rsi),%edi
 1087eb8:	44 8b 46 04          	mov    0x4(%rsi),%r8d
 1087ebc:	44 39 c7             	cmp    %r8d,%edi
 1087ebf:	0f 83 56 07 00 00    	jae    108861b <check_input_run+0x830b>
 1087ec5:	44 8b 88 5c 03 00 00 	mov    0x35c(%rax),%r9d
 1087ecc:	45 39 c8             	cmp    %r9d,%r8d
 1087ecf:	0f 83 46 07 00 00    	jae    108861b <check_input_run+0x830b>
 1087ed5:	49 ff c0             	inc    %r8
 1087ed8:	4c 89 c2             	mov    %r8,%rdx
 1087edb:	48 29 fa             	sub    %rdi,%rdx
 1087ede:	bf 01 00 00 00       	mov    $0x1,%edi
 1087ee3:	83 f9 01             	cmp    $0x1,%ecx
 1087ee6:	0f 84 b1 05 00 00    	je     108849d <check_input_run+0x818d>
 1087eec:	48 83 c6 1c          	add    $0x1c,%rsi
 1087ef0:	eb 10                	jmp    1087f02 <check_input_run+0x7bf2>
 1087ef2:	48 ff c7             	inc    %rdi
 1087ef5:	48 83 c6 18          	add    $0x18,%rsi
 1087ef9:	48 39 f9             	cmp    %rdi,%rcx
 1087efc:	0f 84 98 05 00 00    	je     108849a <check_input_run+0x818a>
 1087f02:	44 8b 5e fc          	mov    -0x4(%rsi),%r11d
 1087f06:	44 8b 16             	mov    (%rsi),%r10d
 1087f09:	45 39 d3             	cmp    %r10d,%r11d
 1087f0c:	0f 83 8b 05 00 00    	jae    108849d <check_input_run+0x818d>
 1087f12:	45 39 ca             	cmp    %r9d,%r10d
 1087f15:	0f 83 82 05 00 00    	jae    108849d <check_input_run+0x818d>
 1087f1b:	44 39 5e e4          	cmp    %r11d,-0x1c(%rsi)
 1087f1f:	0f 83 78 05 00 00    	jae    108849d <check_input_run+0x818d>
 1087f25:	4d 39 d0             	cmp    %r10,%r8
 1087f28:	77 c8                	ja     1087ef2 <check_input_run+0x7be2>
 1087f2a:	4d 39 d8             	cmp    %r11,%r8
 1087f2d:	4d 0f 47 d8          	cmova  %r8,%r11
 1087f31:	4c 29 da             	sub    %r11,%rdx
 1087f34:	4a 8d 54 12 01       	lea    0x1(%rdx,%r10,1),%rdx
 1087f39:	49 ff c2             	inc    %r10
 1087f3c:	4d 89 d0             	mov    %r10,%r8
 1087f3f:	eb b1                	jmp    1087ef2 <check_input_run+0x7be2>
 1087f41:	81 f9 17 03 00 00    	cmp    $0x317,%ecx
 1087f47:	0f 84 c1 fc ff ff    	je     1087c0e <check_input_run+0x78fe>
 1087f4d:	8d 91 a0 fe ff ff    	lea    -0x160(%rcx),%edx
 1087f53:	89 ce                	mov    %ecx,%esi
 1087f55:	66 83 fa 06          	cmp    $0x6,%dx
 1087f59:	0f 92 c2             	setb   %dl
 1087f5c:	83 e6 fc             	and    $0xfffffffc,%esi
 1087f5f:	66 81 fe f0 01       	cmp    $0x1f0,%si
 1087f64:	40 0f 94 c6          	sete   %sil
 1087f68:	40 08 d6             	or     %dl,%sil
 1087f6b:	0f 85 9d fc ff ff    	jne    1087c0e <check_input_run+0x78fe>
 1087f71:	8d 91 c0 fe ff ff    	lea    -0x140(%rcx),%edx
 1087f77:	8d b1 00 fe ff ff    	lea    -0x200(%rcx),%esi
 1087f7d:	66 83 fa 13          	cmp    $0x13,%dx
 1087f81:	0f 92 c2             	setb   %dl
 1087f84:	66 83 fe 0e          	cmp    $0xe,%si
 1087f88:	40 0f 92 c6          	setb   %sil
 1087f8c:	40 08 d6             	or     %dl,%sil
 1087f8f:	0f 85 d4 1b 00 00    	jne    1089b69 <check_input_run+0x9859>
 1087f95:	81 f9 6f 01 00 00    	cmp    $0x16f,%ecx
 1087f9b:	0f 8e b4 1b 00 00    	jle    1089b55 <check_input_run+0x9845>
 1087fa1:	8d 91 90 fe ff ff    	lea    -0x170(%rcx),%edx
 1087fa7:	83 fa 27             	cmp    $0x27,%edx
 1087faa:	77 1d                	ja     1087fc9 <check_input_run+0x7cb9>
 1087fac:	48 be 00 00 0a 00 c0 	movabs $0xc0000a0000,%rsi
 1087fb3:	00 00 00 
 1087fb6:	48 0f a3 d6          	bt     %rdx,%rsi
 1087fba:	0f 82 a9 1b 00 00    	jb     1089b69 <check_input_run+0x9859>
 1087fc0:	48 85 d2             	test   %rdx,%rdx
 1087fc3:	0f 84 45 fc ff ff    	je     1087c0e <check_input_run+0x78fe>
 1087fc9:	81 f9 ce 01 00 00    	cmp    $0x1ce,%ecx
 1087fcf:	0f 84 94 1b 00 00    	je     1089b69 <check_input_run+0x9859>
 1087fd5:	e9 3d 22 00 00       	jmp    108a217 <check_input_run+0x9f07>
 1087fda:	48 39 c2             	cmp    %rax,%rdx
 1087fdd:	0f 83 6c 04 00 00    	jae    108844f <check_input_run+0x813f>
 1087fe3:	48 8b 8c 24 88 02 00 	mov    0x288(%rsp),%rcx
 1087fea:	00 
 1087feb:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
 1087ff0:	4c 8b 41 08          	mov    0x8(%rcx),%r8
 1087ff4:	48 83 b8 28 08 00 00 	cmpq   $0x0,0x828(%rax)
 1087ffb:	00 
 1087ffc:	74 20                	je     108801e <check_input_run+0x7d0e>
 1087ffe:	48 8b 3c 24          	mov    (%rsp),%rdi
 1088002:	48 8b 37             	mov    (%rdi),%rsi
 1088005:	48 8b 57 08          	mov    0x8(%rdi),%rdx
 1088009:	48 8d 44 32 3f       	lea    0x3f(%rdx,%rsi,1),%rax
 108800e:	48 01 f2             	add    %rsi,%rdx
 1088011:	48 83 e0 c0          	and    $0xffffffffffffffc0,%rax
 1088015:	48 39 d0             	cmp    %rdx,%rax
 1088018:	0f 83 26 13 00 00    	jae    1089344 <check_input_run+0x9034>
 108801e:	31 ed                	xor    %ebp,%ebp
 1088020:	48 c7 84 24 70 01 00 	movq   $0x0,0x170(%rsp)
 1088027:	00 00 00 00 00 
 108802c:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
 1088031:	48 83 b8 28 08 00 00 	cmpq   $0x0,0x828(%rax)
 1088038:	00 
 1088039:	0f 95 c0             	setne  %al
 108803c:	48 85 ed             	test   %rbp,%rbp
 108803f:	0f 94 c1             	sete   %cl
 1088042:	20 c1                	and    %al,%cl
 1088044:	41 08 8e bd 03 00 00 	or     %cl,0x3bd(%r14)
 108804b:	48 85 ed             	test   %rbp,%rbp
 108804e:	0f 84 4a 19 00 00    	je     108999e <check_input_run+0x968e>
 1088054:	41 80 3a 00          	cmpb   $0x0,(%r10)
 1088058:	4c 89 84 24 98 00 00 	mov    %r8,0x98(%rsp)
 108805f:	00 
 1088060:	4c 89 8c 24 30 01 00 	mov    %r9,0x130(%rsp)
 1088067:	00 
 1088068:	4c 89 94 24 a0 00 00 	mov    %r10,0xa0(%rsp)
 108806f:	00 
 1088070:	75 12                	jne    1088084 <check_input_run+0x7d74>
 1088072:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
 1088077:	80 b8 40 0c 00 00 01 	cmpb   $0x1,0xc40(%rax)
 108807e:	0f 85 77 13 00 00    	jne    10893fb <check_input_run+0x90eb>
 1088084:	48 8b 5c 24 48       	mov    0x48(%rsp),%rbx
 1088089:	48 89 df             	mov    %rbx,%rdi
 108808c:	c5 f8 77             	vzeroupper
 108808f:	e8 3c 4f fa ff       	call   102cfd0 <pp_history_ensure>
 1088094:	83 bb 30 08 00 00 00 	cmpl   $0x0,0x830(%rbx)
 108809b:	0f 84 c3 16 00 00    	je     1089764 <check_input_run+0x9454>
 10880a1:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
 10880a7:	be ff ff ff ff       	mov    $0xffffffff,%esi
 10880ac:	45 31 d2             	xor    %r10d,%r10d
 10880af:	c7 44 24 38 00 00 00 	movl   $0x0,0x38(%rsp)
 10880b6:	00 
 10880b7:	31 c9                	xor    %ecx,%ecx
 10880b9:	31 d2                	xor    %edx,%edx
 10880bb:	45 31 ed             	xor    %r13d,%r13d
 10880be:	31 c0                	xor    %eax,%eax
 10880c0:	eb 3c                	jmp    10880fe <check_input_run+0x7dee>
 10880c2:	c7 44 24 38 00 00 00 	movl   $0x0,0x38(%rsp)
 10880c9:	00 
 10880ca:	45 31 d2             	xor    %r10d,%r10d
 10880cd:	41 b9 ff ff ff ff    	mov    $0xffffffff,%r9d
 10880d3:	45 31 db             	xor    %r11d,%r11d
 10880d6:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
 10880db:	44 88 5c 0d 00       	mov    %r11b,0x0(%rbp,%rcx,1)
 10880e0:	48 ff c1             	inc    %rcx
 10880e3:	45 89 c8             	mov    %r9d,%r8d
 10880e6:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
 10880eb:	8b 80 30 08 00 00    	mov    0x830(%rax),%eax
 10880f1:	48 39 c1             	cmp    %rax,%rcx
 10880f4:	8b 44 24 40          	mov    0x40(%rsp),%eax
 10880f8:	0f 83 66 16 00 00    	jae    1089764 <check_input_run+0x9454>
 10880fe:	44 89 54 24 68       	mov    %r10d,0x68(%rsp)
 1088103:	4c 8b 54 24 48       	mov    0x48(%rsp),%r10
 1088108:	41 8b ba e0 0c 00 00 	mov    0xce0(%r10),%edi
 108810f:	39 fa                	cmp    %edi,%edx
 1088111:	73 1d                	jae    1088130 <check_input_run+0x7e20>
 1088113:	4d 8b 8a d8 0c 00 00 	mov    0xcd8(%r10),%r9
 108811a:	89 d2                	mov    %edx,%edx
 108811c:	0f 1f 40 00          	nopl   0x0(%rax)
 1088120:	41 39 0c d1          	cmp    %ecx,(%r9,%rdx,8)
 1088124:	77 0a                	ja     1088130 <check_input_run+0x7e20>
 1088126:	48 ff c2             	inc    %rdx
 1088129:	48 39 d7             	cmp    %rdx,%rdi
 108812c:	75 f2                	jne    1088120 <check_input_run+0x7e10>
 108812e:	89 fa                	mov    %edi,%edx
 1088130:	85 d2                	test   %edx,%edx
 1088132:	0f 84 36 01 00 00    	je     108826e <check_input_run+0x7f5e>
 1088138:	49 8b ba d8 0c 00 00 	mov    0xcd8(%r10),%rdi
 108813f:	44 8d 4a ff          	lea    -0x1(%rdx),%r9d
 1088143:	46 8b 4c cf 04       	mov    0x4(%rdi,%r9,8),%r9d
 1088148:	45 85 c9             	test   %r9d,%r9d
 108814b:	0f 84 0e 01 00 00    	je     108825f <check_input_run+0x7f4f>
 1088151:	41 39 c1             	cmp    %eax,%r9d
 1088154:	0f 84 05 01 00 00    	je     108825f <check_input_run+0x7f4f>
 108815a:	49 8b 82 28 08 00 00 	mov    0x828(%r10),%rax
 1088161:	44 89 4c 24 40       	mov    %r9d,0x40(%rsp)
 1088166:	48 85 c0             	test   %rax,%rax
 1088169:	0f 84 13 01 00 00    	je     1088282 <check_input_run+0x7f72>
 108816f:	45 8b 9a a0 0c 00 00 	mov    0xca0(%r10),%r11d
 1088176:	45 8b a2 b0 0c 00 00 	mov    0xcb0(%r10),%r12d
 108817d:	8b 3c 88             	mov    (%rax,%rcx,4),%edi
 1088180:	45 31 ff             	xor    %r15d,%r15d
 1088183:	44 89 e0             	mov    %r12d,%eax
 1088186:	4c 89 5c 24 60       	mov    %r11,0x60(%rsp)
 108818b:	4d 01 dc             	add    %r11,%r12
 108818e:	45 8b 9a c0 0c 00 00 	mov    0xcc0(%r10),%r11d
 1088195:	45 89 ca             	mov    %r9d,%r10d
 1088198:	4d 01 dc             	add    %r11,%r12
 108819b:	45 89 d1             	mov    %r10d,%r9d
 108819e:	41 81 e1 ff ff ff 3f 	and    $0x3fffffff,%r9d
 10881a5:	45 89 d5             	mov    %r10d,%r13d
 10881a8:	41 81 e5 00 00 00 c0 	and    $0xc0000000,%r13d
 10881af:	41 ff c9             	dec    %r9d
 10881b2:	41 81 fd 00 00 00 40 	cmp    $0x40000000,%r13d
 10881b9:	75 23                	jne    10881de <check_input_run+0x7ece>
 10881bb:	41 39 c1             	cmp    %eax,%r9d
 10881be:	0f 83 c5 00 00 00    	jae    1088289 <check_input_run+0x7f79>
 10881c4:	4c 8b 54 24 48       	mov    0x48(%rsp),%r10
 10881c9:	45 89 c9             	mov    %r9d,%r9d
 10881cc:	4f 8d 0c 49          	lea    (%r9,%r9,2),%r9
 10881d0:	4d 8b 92 a8 0c 00 00 	mov    0xca8(%r10),%r10
 10881d7:	4f 8d 4c 8a 04       	lea    0x4(%r10,%r9,4),%r9
 10881dc:	eb 68                	jmp    1088246 <check_input_run+0x7f36>
 10881de:	41 81 fa ff ff ff bf 	cmp    $0xbfffffff,%r10d
 10881e5:	7f 27                	jg     108820e <check_input_run+0x7efe>
 10881e7:	45 39 d9             	cmp    %r11d,%r9d
 10881ea:	0f 83 99 00 00 00    	jae    1088289 <check_input_run+0x7f79>
 10881f0:	4c 8b 54 24 48       	mov    0x48(%rsp),%r10
 10881f5:	45 89 c9             	mov    %r9d,%r9d
 10881f8:	4b 8d 1c 49          	lea    (%r9,%r9,2),%rbx
 10881fc:	4d 8b 92 b8 0c 00 00 	mov    0xcb8(%r10),%r10
 1088203:	41 8b 7c da 08       	mov    0x8(%r10,%rbx,8),%edi
 1088208:	4d 8d 0c da          	lea    (%r10,%rbx,8),%r9
 108820c:	eb 38                	jmp    1088246 <check_input_run+0x7f36>
 108820e:	31 db                	xor    %ebx,%ebx
 1088210:	45 85 ed             	test   %r13d,%r13d
 1088213:	75 76                	jne    108828b <check_input_run+0x7f7b>
 1088215:	41 ba 00 00 00 00    	mov    $0x0,%r10d
 108821b:	44 3b 4c 24 60       	cmp    0x60(%rsp),%r9d
 1088220:	73 6c                	jae    108828e <check_input_run+0x7f7e>
 1088222:	4c 8b 54 24 48       	mov    0x48(%rsp),%r10
 1088227:	45 89 c9             	mov    %r9d,%r9d
 108822a:	4b 8d 1c c9          	lea    (%r9,%r9,8),%rbx
 108822e:	48 8d 1c 5b          	lea    (%rbx,%rbx,2),%rbx
 1088232:	4c 01 cb             	add    %r9,%rbx
 1088235:	4d 8b 92 98 0c 00 00 	mov    0xc98(%r10),%r10
 108823c:	41 8b 7c 1a 08       	mov    0x8(%r10,%rbx,1),%edi
 1088241:	4d 8d 4c 1a 10       	lea    0x10(%r10,%rbx,1),%r9
 1088246:	45 8b 11             	mov    (%r9),%r10d
 1088249:	b3 01                	mov    $0x1,%bl
 108824b:	45 85 d2             	test   %r10d,%r10d
 108824e:	74 3e                	je     108828e <check_input_run+0x7f7e>
 1088250:	4d 39 e7             	cmp    %r12,%r15
 1088253:	4d 8d 7f 01          	lea    0x1(%r15),%r15
 1088257:	0f 82 3e ff ff ff    	jb     108819b <check_input_run+0x7e8b>
 108825d:	eb 2f                	jmp    108828e <check_input_run+0x7f7e>
 108825f:	45 85 c9             	test   %r9d,%r9d
 1088262:	74 0a                	je     108826e <check_input_run+0x7f5e>
 1088264:	44 89 4c 24 40       	mov    %r9d,0x40(%rsp)
 1088269:	44 89 ef             	mov    %r13d,%edi
 108826c:	eb 38                	jmp    10882a6 <check_input_run+0x7f96>
 108826e:	49 8b 82 28 08 00 00 	mov    0x828(%r10),%rax
 1088275:	c7 44 24 40 00 00 00 	movl   $0x0,0x40(%rsp)
 108827c:	00 
 108827d:	8b 3c 88             	mov    (%rax,%rcx,4),%edi
 1088280:	eb 24                	jmp    10882a6 <check_input_run+0x7f96>
 1088282:	45 31 ed             	xor    %r13d,%r13d
 1088285:	31 ff                	xor    %edi,%edi
 1088287:	eb 1d                	jmp    10882a6 <check_input_run+0x7f96>
 1088289:	31 db                	xor    %ebx,%ebx
 108828b:	45 31 d2             	xor    %r10d,%r10d
 108828e:	45 85 d2             	test   %r10d,%r10d
 1088291:	4c 8b 54 24 48       	mov    0x48(%rsp),%r10
 1088296:	b8 00 00 00 00       	mov    $0x0,%eax
 108829b:	0f 45 f8             	cmovne %eax,%edi
 108829e:	84 db                	test   %bl,%bl
 10882a0:	0f 44 f8             	cmove  %eax,%edi
 10882a3:	41 89 fd             	mov    %edi,%r13d
 10882a6:	45 8b a2 18 0c 00 00 	mov    0xc18(%r10),%r12d
 10882ad:	45 39 e0             	cmp    %r12d,%r8d
 10882b0:	73 27                	jae    10882d9 <check_input_run+0x7fc9>
 10882b2:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
 10882b7:	48 8b 80 10 0c 00 00 	mov    0xc10(%rax),%rax
 10882be:	48 85 c0             	test   %rax,%rax
 10882c1:	74 16                	je     10882d9 <check_input_run+0x7fc9>
 10882c3:	45 89 c1             	mov    %r8d,%r9d
 10882c6:	4d 6b c9 38          	imul   $0x38,%r9,%r9
 10882ca:	4c 01 c8             	add    %r9,%rax
 10882cd:	41 89 f9             	mov    %edi,%r9d
 10882d0:	44 2b 08             	sub    (%rax),%r9d
 10882d3:	0f 83 e6 00 00 00    	jae    10883bf <check_input_run+0x80af>
 10882d9:	be ff ff ff ff       	mov    $0xffffffff,%esi
 10882de:	85 ff                	test   %edi,%edi
 10882e0:	0f 84 dc fd ff ff    	je     10880c2 <check_input_run+0x7db2>
 10882e6:	41 83 fc 02          	cmp    $0x2,%r12d
 10882ea:	72 54                	jb     1088340 <check_input_run+0x8030>
 10882ec:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
 10882f1:	45 31 c0             	xor    %r8d,%r8d
 10882f4:	45 89 e2             	mov    %r12d,%r10d
 10882f7:	45 89 e1             	mov    %r12d,%r9d
 10882fa:	48 8b 80 10 0c 00 00 	mov    0xc10(%rax),%rax
 1088301:	eb 1c                	jmp    108831f <check_input_run+0x800f>
 1088303:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 108830a:	84 00 00 00 00 00 
 1088310:	45 89 d0             	mov    %r10d,%r8d
 1088313:	45 89 ca             	mov    %r9d,%r10d
 1088316:	45 29 c2             	sub    %r8d,%r10d
 1088319:	41 83 fa 01          	cmp    $0x1,%r10d
 108831d:	76 39                	jbe    1088358 <check_input_run+0x8048>
 108831f:	41 d1 ea             	shr    $1,%r10d
 1088322:	45 01 c2             	add    %r8d,%r10d
 1088325:	4d 6b da 38          	imul   $0x38,%r10,%r11
 1088329:	42 39 3c 18          	cmp    %edi,(%rax,%r11,1)
 108832d:	76 e1                	jbe    1088310 <check_input_run+0x8000>
 108832f:	45 89 d1             	mov    %r10d,%r9d
 1088332:	45 89 ca             	mov    %r9d,%r10d
 1088335:	45 29 c2             	sub    %r8d,%r10d
 1088338:	41 83 fa 01          	cmp    $0x1,%r10d
 108833c:	77 e1                	ja     108831f <check_input_run+0x800f>
 108833e:	eb 18                	jmp    1088358 <check_input_run+0x8048>
 1088340:	45 85 e4             	test   %r12d,%r12d
 1088343:	0f 84 79 fd ff ff    	je     10880c2 <check_input_run+0x7db2>
 1088349:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
 108834e:	45 31 c0             	xor    %r8d,%r8d
 1088351:	48 8b 80 10 0c 00 00 	mov    0xc10(%rax),%rax
 1088358:	45 89 c1             	mov    %r8d,%r9d
 108835b:	49 6b d9 38          	imul   $0x38,%r9,%rbx
 108835f:	41 89 ff             	mov    %edi,%r15d
 1088362:	41 ba 00 00 00 00    	mov    $0x0,%r10d
 1088368:	41 b9 ff ff ff ff    	mov    $0xffffffff,%r9d
 108836e:	41 bb 00 00 00 00    	mov    $0x0,%r11d
 1088374:	c7 44 24 38 00 00 00 	movl   $0x0,0x38(%rsp)
 108837b:	00 
 108837c:	44 2b 3c 18          	sub    (%rax,%rbx,1),%r15d
 1088380:	0f 82 50 fd ff ff    	jb     10880d6 <check_input_run+0x7dc6>
 1088386:	48 01 c3             	add    %rax,%rbx
 1088389:	be ff ff ff ff       	mov    $0xffffffff,%esi
 108838e:	44 3b 7b 04          	cmp    0x4(%rbx),%r15d
 1088392:	45 0f 42 c8          	cmovb  %r8d,%r9d
 1088396:	45 31 d2             	xor    %r10d,%r10d
 1088399:	45 39 e1             	cmp    %r12d,%r9d
 108839c:	73 63                	jae    1088401 <check_input_run+0x80f1>
 108839e:	44 89 ce             	mov    %r9d,%esi
 10883a1:	48 6b f6 38          	imul   $0x38,%rsi,%rsi
 10883a5:	44 0f b6 4c 30 28    	movzbl 0x28(%rax,%rsi,1),%r9d
 10883ab:	44 8b 14 30          	mov    (%rax,%rsi,1),%r10d
 10883af:	8b 74 30 20          	mov    0x20(%rax,%rsi,1),%esi
 10883b3:	44 89 4c 24 68       	mov    %r9d,0x68(%rsp)
 10883b8:	44 89 54 24 38       	mov    %r10d,0x38(%rsp)
 10883bd:	eb 14                	jmp    10883d3 <check_input_run+0x80c3>
 10883bf:	44 3b 48 04          	cmp    0x4(%rax),%r9d
 10883c3:	0f 83 10 ff ff ff    	jae    10882d9 <check_input_run+0x7fc9>
 10883c9:	3b 7c 24 38          	cmp    0x38(%rsp),%edi
 10883cd:	0f 82 06 ff ff ff    	jb     10882d9 <check_input_run+0x7fc9>
 10883d3:	4c 8b 4c 24 48       	mov    0x48(%rsp),%r9
 10883d8:	41 8b 81 28 0c 00 00 	mov    0xc28(%r9),%eax
 10883df:	39 c6                	cmp    %eax,%esi
 10883e1:	73 17                	jae    10883fa <check_input_run+0x80ea>
 10883e3:	4d 8b 89 20 0c 00 00 	mov    0xc20(%r9),%r9
 10883ea:	41 89 f2             	mov    %esi,%r10d
 10883ed:	4f 8d 14 92          	lea    (%r10,%r10,4),%r10
 10883f1:	43 8b 5c d1 04       	mov    0x4(%r9,%r10,8),%ebx
 10883f6:	39 fb                	cmp    %edi,%ebx
 10883f8:	76 14                	jbe    108840e <check_input_run+0x80fe>
 10883fa:	44 8b 54 24 68       	mov    0x68(%rsp),%r10d
 10883ff:	eb 36                	jmp    1088437 <check_input_run+0x8127>
 1088401:	45 89 c8             	mov    %r9d,%r8d
 1088404:	c7 44 24 38 00 00 00 	movl   $0x0,0x38(%rsp)
 108840b:	00 
 108840c:	eb 29                	jmp    1088437 <check_input_run+0x8127>
 108840e:	4f 8d 3c d1          	lea    (%r9,%r10,8),%r15
 1088412:	41 8b 77 1c          	mov    0x1c(%r15),%esi
 1088416:	4d 89 fb             	mov    %r15,%r11
 1088419:	89 5c 24 38          	mov    %ebx,0x38(%rsp)
 108841d:	39 c6                	cmp    %eax,%esi
 108841f:	73 11                	jae    1088432 <check_input_run+0x8122>
 1088421:	4c 8d 14 b6          	lea    (%rsi,%rsi,4),%r10
 1088425:	43 8b 5c d1 04       	mov    0x4(%r9,%r10,8),%ebx
 108842a:	4f 8d 3c d1          	lea    (%r9,%r10,8),%r15
 108842e:	39 fb                	cmp    %edi,%ebx
 1088430:	76 e0                	jbe    1088412 <check_input_run+0x8102>
 1088432:	45 0f b6 53 20       	movzbl 0x20(%r11),%r10d
 1088437:	45 39 e0             	cmp    %r12d,%r8d
 108843a:	45 0f b6 da          	movzbl %r10b,%r11d
 108843e:	b8 00 00 00 00       	mov    $0x0,%eax
 1088443:	45 89 c1             	mov    %r8d,%r9d
 1088446:	44 0f 43 d8          	cmovae %eax,%r11d
 108844a:	e9 87 fc ff ff       	jmp    10880d6 <check_input_run+0x7dc6>
 108844f:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
 1088454:	8b 88 28 0c 00 00    	mov    0xc28(%rax),%ecx
 108845a:	48 85 c9             	test   %rcx,%rcx
 108845d:	74 2a                	je     1088489 <check_input_run+0x8179>
 108845f:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
 1088464:	48 c1 e1 03          	shl    $0x3,%rcx
 1088468:	31 d2                	xor    %edx,%edx
 108846a:	48 8d 0c 89          	lea    (%rcx,%rcx,4),%rcx
 108846e:	48 8b 80 20 0c 00 00 	mov    0xc20(%rax),%rax
 1088475:	80 7c 10 20 00       	cmpb   $0x0,0x20(%rax,%rdx,1)
 108847a:	0f 85 63 fb ff ff    	jne    1087fe3 <check_input_run+0x7cd3>
 1088480:	48 83 c2 28          	add    $0x28,%rdx
 1088484:	48 39 d1             	cmp    %rdx,%rcx
 1088487:	75 ec                	jne    1088475 <check_input_run+0x8165>
 1088489:	48 8b 84 24 88 02 00 	mov    0x288(%rsp),%rax
 1088490:	00 
 1088491:	4c 8b 40 08          	mov    0x8(%rax),%r8
 1088495:	e9 04 15 00 00       	jmp    108999e <check_input_run+0x968e>
 108849a:	48 89 cf             	mov    %rcx,%rdi
 108849d:	48 39 cf             	cmp    %rcx,%rdi
 10884a0:	0f 82 75 01 00 00    	jb     108861b <check_input_run+0x830b>
 10884a6:	48 8d 14 d1          	lea    (%rcx,%rdx,8),%rdx
 10884aa:	48 89 d6             	mov    %rdx,%rsi
 10884ad:	48 c1 ee 20          	shr    $0x20,%rsi
 10884b1:	0f 85 64 01 00 00    	jne    108861b <check_input_run+0x830b>
 10884b7:	89 88 2c 01 00 00    	mov    %ecx,0x12c(%rax)
 10884bd:	89 90 3c 01 00 00    	mov    %edx,0x13c(%rax)
 10884c3:	48 8b b4 24 80 02 00 	mov    0x280(%rsp),%rsi
 10884ca:	00 
 10884cb:	4c 8b 06             	mov    (%rsi),%r8
 10884ce:	4c 8b 4e 08          	mov    0x8(%rsi),%r9
 10884d2:	4b 8d 7c 01 03       	lea    0x3(%r9,%r8,1),%rdi
 10884d7:	4d 01 c1             	add    %r8,%r9
 10884da:	48 83 e7 fc          	and    $0xfffffffffffffffc,%rdi
 10884de:	4c 39 cf             	cmp    %r9,%rdi
 10884e1:	73 05                	jae    10884e8 <check_input_run+0x81d8>
 10884e3:	45 31 c0             	xor    %r8d,%r8d
 10884e6:	eb 33                	jmp    108851b <check_input_run+0x820b>
 10884e8:	4c 8b 56 10          	mov    0x10(%rsi),%r10
 10884ec:	49 89 f9             	mov    %rdi,%r9
 10884ef:	4d 29 c1             	sub    %r8,%r9
 10884f2:	45 31 c0             	xor    %r8d,%r8d
 10884f5:	4d 29 ca             	sub    %r9,%r10
 10884f8:	72 21                	jb     108851b <check_input_run+0x820b>
 10884fa:	48 c1 e1 04          	shl    $0x4,%rcx
 10884fe:	4c 39 d1             	cmp    %r10,%rcx
 1088501:	77 18                	ja     108851b <check_input_run+0x820b>
 1088503:	49 01 c9             	add    %rcx,%r9
 1088506:	49 89 f8             	mov    %rdi,%r8
 1088509:	4c 89 4e 08          	mov    %r9,0x8(%rsi)
 108850d:	8b 90 3c 01 00 00    	mov    0x13c(%rax),%edx
 1088513:	48 8b b4 24 80 02 00 	mov    0x280(%rsp),%rsi
 108851a:	00 
 108851b:	4c 89 80 20 01 00 00 	mov    %r8,0x120(%rax)
 1088522:	48 8b 3e             	mov    (%rsi),%rdi
 1088525:	4c 8b 46 08          	mov    0x8(%rsi),%r8
 1088529:	49 8d 4c 38 03       	lea    0x3(%r8,%rdi,1),%rcx
 108852e:	49 01 f8             	add    %rdi,%r8
 1088531:	48 83 e1 fc          	and    $0xfffffffffffffffc,%rcx
 1088535:	4c 39 c1             	cmp    %r8,%rcx
 1088538:	73 04                	jae    108853e <check_input_run+0x822e>
 108853a:	31 ff                	xor    %edi,%edi
 108853c:	eb 24                	jmp    1088562 <check_input_run+0x8252>
 108853e:	4c 8b 4e 10          	mov    0x10(%rsi),%r9
 1088542:	49 89 c8             	mov    %rcx,%r8
 1088545:	49 29 f8             	sub    %rdi,%r8
 1088548:	31 ff                	xor    %edi,%edi
 108854a:	4d 29 c1             	sub    %r8,%r9
 108854d:	72 13                	jb     1088562 <check_input_run+0x8252>
 108854f:	48 c1 e2 04          	shl    $0x4,%rdx
 1088553:	4c 39 ca             	cmp    %r9,%rdx
 1088556:	77 0a                	ja     1088562 <check_input_run+0x8252>
 1088558:	49 01 d0             	add    %rdx,%r8
 108855b:	48 89 cf             	mov    %rcx,%rdi
 108855e:	4c 89 46 08          	mov    %r8,0x8(%rsi)
 1088562:	48 89 b8 30 01 00 00 	mov    %rdi,0x130(%rax)
 1088569:	48 8b 8c 24 88 02 00 	mov    0x288(%rsp),%rcx
 1088570:	00 
 1088571:	48 8b 39             	mov    (%rcx),%rdi
 1088574:	48 8b 71 08          	mov    0x8(%rcx),%rsi
 1088578:	48 8d 54 3e 03       	lea    0x3(%rsi,%rdi,1),%rdx
 108857d:	48 01 fe             	add    %rdi,%rsi
 1088580:	48 83 e2 fc          	and    $0xfffffffffffffffc,%rdx
 1088584:	48 39 f2             	cmp    %rsi,%rdx
 1088587:	73 04                	jae    108858d <check_input_run+0x827d>
 1088589:	31 ff                	xor    %edi,%edi
 108858b:	eb 2f                	jmp    10885bc <check_input_run+0x82ac>
 108858d:	4c 8b 41 10          	mov    0x10(%rcx),%r8
 1088591:	48 89 d6             	mov    %rdx,%rsi
 1088594:	48 29 fe             	sub    %rdi,%rsi
 1088597:	31 ff                	xor    %edi,%edi
 1088599:	49 29 f0             	sub    %rsi,%r8
 108859c:	72 1e                	jb     10885bc <check_input_run+0x82ac>
 108859e:	44 8b 88 5c 03 00 00 	mov    0x35c(%rax),%r9d
 10885a5:	4e 8d 0c 8d 04 00 00 	lea    0x4(,%r9,4),%r9
 10885ac:	00 
 10885ad:	4d 39 c1             	cmp    %r8,%r9
 10885b0:	77 0a                	ja     10885bc <check_input_run+0x82ac>
 10885b2:	4c 01 ce             	add    %r9,%rsi
 10885b5:	48 89 d7             	mov    %rdx,%rdi
 10885b8:	48 89 71 08          	mov    %rsi,0x8(%rcx)
 10885bc:	48 89 bc 24 d8 04 00 	mov    %rdi,0x4d8(%rsp)
 10885c3:	00 
 10885c4:	48 83 b8 20 01 00 00 	cmpq   $0x0,0x120(%rax)
 10885cb:	00 
 10885cc:	74 4d                	je     108861b <check_input_run+0x830b>
 10885ce:	48 85 ff             	test   %rdi,%rdi
 10885d1:	74 48                	je     108861b <check_input_run+0x830b>
 10885d3:	48 83 b8 30 01 00 00 	cmpq   $0x0,0x130(%rax)
 10885da:	00 
 10885db:	74 3e                	je     108861b <check_input_run+0x830b>
 10885dd:	8b 80 5c 03 00 00    	mov    0x35c(%rax),%eax
 10885e3:	be ff 00 00 00       	mov    $0xff,%esi
 10885e8:	48 8d 14 85 04 00 00 	lea    0x4(,%rax,4),%rdx
 10885ef:	00 
 10885f0:	c5 f8 77             	vzeroupper
 10885f3:	e8 88 69 70 ff       	call   78ef80 <memset@plt>
 10885f8:	48 8d bc 24 60 02 00 	lea    0x260(%rsp),%rdi
 10885ff:	00 
 1088600:	c5 f8 77             	vzeroupper
 1088603:	e8 b8 3d 01 00       	call   109c3c0 <check_input_expressions>
 1088608:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 108860d:	80 b8 bd 03 00 00 00 	cmpb   $0x0,0x3bd(%rax)
 1088614:	74 1e                	je     1088634 <check_input_run+0x8324>
 1088616:	e9 f1 03 00 00       	jmp    1088a0c <check_input_run+0x86fc>
 108861b:	c6 80 bd 03 00 00 01 	movb   $0x1,0x3bd(%rax)
 1088622:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 1088627:	80 b8 bd 03 00 00 00 	cmpb   $0x0,0x3bd(%rax)
 108862e:	0f 85 d8 03 00 00    	jne    1088a0c <check_input_run+0x86fc>
 1088634:	48 8b 9c 24 60 02 00 	mov    0x260(%rsp),%rbx
 108863b:	00 
 108863c:	4c 8b b4 24 68 02 00 	mov    0x268(%rsp),%r14
 1088643:	00 
 1088644:	48 8d bc 24 60 02 00 	lea    0x260(%rsp),%rdi
 108864b:	00 
 108864c:	c5 f8 77             	vzeroupper
 108864f:	e8 cc 70 08 00       	call   110f720 <check_input_asm_labels>
 1088654:	8b 83 44 03 00 00    	mov    0x344(%rbx),%eax
 108865a:	85 c0                	test   %eax,%eax
 108865c:	0f 84 10 01 00 00    	je     1088772 <check_input_run+0x8462>
 1088662:	31 d2                	xor    %edx,%edx
 1088664:	eb 16                	jmp    108867c <check_input_run+0x836c>
 1088666:	8b 83 44 03 00 00    	mov    0x344(%rbx),%eax
 108866c:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
 1088671:	48 ff c2             	inc    %rdx
 1088674:	85 c0                	test   %eax,%eax
 1088676:	0f 84 f6 00 00 00    	je     1088772 <check_input_run+0x8462>
 108867c:	8b 8c 24 30 06 00 00 	mov    0x630(%rsp),%ecx
 1088683:	48 39 ca             	cmp    %rcx,%rdx
 1088686:	0f 83 e6 00 00 00    	jae    1088772 <check_input_run+0x8462>
 108868c:	80 bb bd 03 00 00 01 	cmpb   $0x1,0x3bd(%rbx)
 1088693:	0f 84 d9 00 00 00    	je     1088772 <check_input_run+0x8462>
 1088699:	48 8b 8b 70 02 00 00 	mov    0x270(%rbx),%rcx
 10886a0:	80 3c 11 00          	cmpb   $0x0,(%rcx,%rdx,1)
 10886a4:	74 cb                	je     1088671 <check_input_run+0x8361>
 10886a6:	48 8b 8b 88 02 00 00 	mov    0x288(%rbx),%rcx
 10886ad:	4c 8b 24 d1          	mov    (%rcx,%rdx,8),%r12
 10886b1:	4d 85 e4             	test   %r12,%r12
 10886b4:	74 bb                	je     1088671 <check_input_run+0x8361>
 10886b6:	41 83 7c 24 08 00    	cmpl   $0x0,0x8(%r12)
 10886bc:	74 b3                	je     1088671 <check_input_run+0x8361>
 10886be:	48 89 54 24 38       	mov    %rdx,0x38(%rsp)
 10886c3:	45 31 ed             	xor    %r13d,%r13d
 10886c6:	31 ed                	xor    %ebp,%ebp
 10886c8:	eb 2b                	jmp    10886f5 <check_input_run+0x83e5>
 10886ca:	c6 80 bd 03 00 00 01 	movb   $0x1,0x3bd(%rax)
 10886d1:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 10886d8:	0f 1f 84 00 00 00 00 
 10886df:	00 
 10886e0:	41 8b 44 24 08       	mov    0x8(%r12),%eax
 10886e5:	48 ff c5             	inc    %rbp
 10886e8:	49 83 c5 50          	add    $0x50,%r13
 10886ec:	48 39 c5             	cmp    %rax,%rbp
 10886ef:	0f 83 71 ff ff ff    	jae    1088666 <check_input_run+0x8356>
 10886f5:	4d 8b 3c 24          	mov    (%r12),%r15
 10886f9:	43 83 7c 2f 1c 12    	cmpl   $0x12,0x1c(%r15,%r13,1)
 10886ff:	75 df                	jne    10886e0 <check_input_run+0x83d0>
 1088701:	43 8b 44 2f 04       	mov    0x4(%r15,%r13,1),%eax
 1088706:	3b 84 24 30 06 00 00 	cmp    0x630(%rsp),%eax
 108870d:	77 d1                	ja     10886e0 <check_input_run+0x83d0>
 108870f:	4b 8b 7c 2f 38       	mov    0x38(%r15,%r13,1),%rdi
 1088714:	43 8b 74 2f 40       	mov    0x40(%r15,%r13,1),%esi
 1088719:	e8 22 55 07 00       	call   10fdc40 <check_asm_register>
 108871e:	84 c0                	test   %al,%al
 1088720:	75 be                	jne    10886e0 <check_input_run+0x83d0>
 1088722:	48 8b 84 24 60 02 00 	mov    0x260(%rsp),%rax
 1088729:	00 
 108872a:	8b 88 30 02 00 00    	mov    0x230(%rax),%ecx
 1088730:	3b 88 34 02 00 00    	cmp    0x234(%rax),%ecx
 1088736:	73 92                	jae    10886ca <check_input_run+0x83ba>
 1088738:	0f b6 b0 bd 03 00 00 	movzbl 0x3bd(%rax),%esi
 108873f:	43 8b 54 2f 10       	mov    0x10(%r15,%r13,1),%edx
 1088744:	48 8b b8 28 02 00 00 	mov    0x228(%rax),%rdi
 108874b:	44 8d 41 01          	lea    0x1(%rcx),%r8d
 108874f:	44 89 80 30 02 00 00 	mov    %r8d,0x230(%rax)
 1088756:	48 8d 04 49          	lea    (%rcx,%rcx,2),%rax
 108875a:	8d 74 76 01          	lea    0x1(%rsi,%rsi,2),%esi
 108875e:	89 14 87             	mov    %edx,(%rdi,%rax,4)
 1088761:	89 74 87 04          	mov    %esi,0x4(%rdi,%rax,4)
 1088765:	c7 44 87 08 00 00 00 	movl   $0x0,0x8(%rdi,%rax,4)
 108876c:	00 
 108876d:	e9 6e ff ff ff       	jmp    10886e0 <check_input_run+0x83d0>
 1088772:	83 bb 40 03 00 00 00 	cmpl   $0x0,0x340(%rbx)
 1088779:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
 108877e:	0f 84 88 02 00 00    	je     1088a0c <check_input_run+0x86fc>
 1088784:	31 c0                	xor    %eax,%eax
 1088786:	eb 1a                	jmp    10887a2 <check_input_run+0x8492>
 1088788:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
 108878f:	00 
 1088790:	8b 8b 40 03 00 00    	mov    0x340(%rbx),%ecx
 1088796:	48 ff c0             	inc    %rax
 1088799:	48 39 c8             	cmp    %rcx,%rax
 108879c:	0f 83 6a 02 00 00    	jae    1088a0c <check_input_run+0x86fc>
 10887a2:	80 bb bd 03 00 00 00 	cmpb   $0x0,0x3bd(%rbx)
 10887a9:	0f 85 5d 02 00 00    	jne    1088a0c <check_input_run+0x86fc>
 10887af:	48 8b 93 38 03 00 00 	mov    0x338(%rbx),%rdx
 10887b6:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
 10887ba:	48 c1 e6 04          	shl    $0x4,%rsi
 10887be:	8b 7c 32 2c          	mov    0x2c(%rdx,%rsi,1),%edi
 10887c2:	48 8d 0c 32          	lea    (%rdx,%rsi,1),%rcx
 10887c6:	03 7c 32 28          	add    0x28(%rdx,%rsi,1),%edi
 10887ca:	0f 85 90 01 00 00    	jne    1088960 <check_input_run+0x8650>
 10887d0:	83 79 34 00          	cmpl   $0x0,0x34(%rcx)
 10887d4:	74 ba                	je     1088790 <check_input_run+0x8480>
 10887d6:	31 d2                	xor    %edx,%edx
 10887d8:	eb 1e                	jmp    10887f8 <check_input_run+0x84e8>
 10887da:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
 10887e0:	41 c6 80 bd 03 00 00 	movb   $0x1,0x3bd(%r8)
 10887e7:	01 
 10887e8:	8b 71 34             	mov    0x34(%rcx),%esi
 10887eb:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
 10887f0:	48 ff c2             	inc    %rdx
 10887f3:	48 39 f2             	cmp    %rsi,%rdx
 10887f6:	73 98                	jae    1088790 <check_input_run+0x8480>
 10887f8:	48 8d 34 52          	lea    (%rdx,%rdx,2),%rsi
 10887fc:	44 8b 41 44          	mov    0x44(%rcx),%r8d
 1088800:	48 c1 e6 02          	shl    $0x2,%rsi
 1088804:	48 03 71 20          	add    0x20(%rcx),%rsi
 1088808:	44 3b 83 5c 03 00 00 	cmp    0x35c(%rbx),%r8d
 108880f:	73 6f                	jae    1088880 <check_input_run+0x8570>
 1088811:	49 8b 7e 60          	mov    0x60(%r14),%rdi
 1088815:	4d 8d 48 01          	lea    0x1(%r8),%r9
 1088819:	46 8b 14 87          	mov    (%rdi,%r8,4),%r10d
 108881d:	8b 7e 08             	mov    0x8(%rsi),%edi
 1088820:	45 39 d1             	cmp    %r10d,%r9d
 1088823:	73 5e                	jae    1088883 <check_input_run+0x8573>
 1088825:	41 f7 d0             	not    %r8d
 1088828:	45 01 d0             	add    %r10d,%r8d
 108882b:	41 89 fa             	mov    %edi,%r10d
 108882e:	eb 08                	jmp    1088838 <check_input_run+0x8528>
 1088830:	49 ff c1             	inc    %r9
 1088833:	41 ff c8             	dec    %r8d
 1088836:	74 4b                	je     1088883 <check_input_run+0x8573>
 1088838:	41 83 fa ff          	cmp    $0xffffffff,%r10d
 108883c:	75 45                	jne    1088883 <check_input_run+0x8573>
 108883e:	4d 8b 5e 50          	mov    0x50(%r14),%r11
 1088842:	41 ba ff ff ff ff    	mov    $0xffffffff,%r10d
 1088848:	43 80 3c 0b 21       	cmpb   $0x21,(%r11,%r9,1)
 108884d:	75 e1                	jne    1088830 <check_input_run+0x8520>
 108884f:	4c 8b 9c 24 d0 05 00 	mov    0x5d0(%rsp),%r11
 1088856:	00 
 1088857:	47 8b 1c 8b          	mov    (%r11,%r9,4),%r11d
 108885b:	44 3b 9b 5c 03 00 00 	cmp    0x35c(%rbx),%r11d
 1088862:	73 cc                	jae    1088830 <check_input_run+0x8520>
 1088864:	4d 8b 7e 18          	mov    0x18(%r14),%r15
 1088868:	47 8b 1c 9f          	mov    (%r15,%r11,4),%r11d
 108886c:	44 3b 1e             	cmp    (%rsi),%r11d
 108886f:	75 bf                	jne    1088830 <check_input_run+0x8520>
 1088871:	44 89 4e 08          	mov    %r9d,0x8(%rsi)
 1088875:	44 89 cf             	mov    %r9d,%edi
 1088878:	45 89 ca             	mov    %r9d,%r10d
 108887b:	eb b3                	jmp    1088830 <check_input_run+0x8520>
 108887d:	0f 1f 00             	nopl   (%rax)
 1088880:	8b 7e 08             	mov    0x8(%rsi),%edi
 1088883:	83 ff ff             	cmp    $0xffffffff,%edi
 1088886:	74 78                	je     1088900 <check_input_run+0x85f0>
 1088888:	4c 8b 8c 24 68 02 00 	mov    0x268(%rsp),%r9
 108888f:	00 
 1088890:	45 8b 51 30          	mov    0x30(%r9),%r10d
 1088894:	44 39 d7             	cmp    %r10d,%edi
 1088897:	0f 83 4b ff ff ff    	jae    10887e8 <check_input_run+0x84d8>
 108889d:	4c 8b 84 24 60 02 00 	mov    0x260(%rsp),%r8
 10888a4:	00 
 10888a5:	44 8b 59 38          	mov    0x38(%rcx),%r11d
 10888a9:	4d 8b b8 18 03 00 00 	mov    0x318(%r8),%r15
 10888b0:	eb 1f                	jmp    10888d1 <check_input_run+0x85c1>
 10888b2:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 10888b9:	1f 84 00 00 00 00 00 
 10888c0:	4d 8b 61 60          	mov    0x60(%r9),%r12
 10888c4:	41 8b 3c bc          	mov    (%r12,%rdi,4),%edi
 10888c8:	44 39 d7             	cmp    %r10d,%edi
 10888cb:	0f 83 17 ff ff ff    	jae    10887e8 <check_input_run+0x84d8>
 10888d1:	89 ff                	mov    %edi,%edi
 10888d3:	45 8b 24 bf          	mov    (%r15,%rdi,4),%r12d
 10888d7:	45 85 e4             	test   %r12d,%r12d
 10888da:	74 e4                	je     10888c0 <check_input_run+0x85b0>
 10888dc:	4d 8b a8 10 03 00 00 	mov    0x310(%r8),%r13
 10888e3:	41 ff cc             	dec    %r12d
 10888e6:	4f 8d 24 64          	lea    (%r12,%r12,2),%r12
 10888ea:	47 3b 5c e5 00       	cmp    0x0(%r13,%r12,8),%r11d
 10888ef:	76 17                	jbe    1088908 <check_input_run+0x85f8>
 10888f1:	4f 8d 64 e5 00       	lea    0x0(%r13,%r12,8),%r12
 10888f6:	45 3b 5c 24 04       	cmp    0x4(%r12),%r11d
 10888fb:	72 c3                	jb     10888c0 <check_input_run+0x85b0>
 10888fd:	eb 09                	jmp    1088908 <check_input_run+0x85f8>
 10888ff:	90                   	nop
 1088900:	4c 8b 84 24 60 02 00 	mov    0x260(%rsp),%r8
 1088907:	00 
 1088908:	41 8b b8 30 02 00 00 	mov    0x230(%r8),%edi
 108890f:	41 3b b8 34 02 00 00 	cmp    0x234(%r8),%edi
 1088916:	0f 83 c4 fe ff ff    	jae    10887e0 <check_input_run+0x84d0>
 108891c:	45 0f b6 88 bd 03 00 	movzbl 0x3bd(%r8),%r9d
 1088923:	00 
 1088924:	8b 76 04             	mov    0x4(%rsi),%esi
 1088927:	4d 8b 90 28 02 00 00 	mov    0x228(%r8),%r10
 108892e:	44 8d 5f 01          	lea    0x1(%rdi),%r11d
 1088932:	48 8d 3c 7f          	lea    (%rdi,%rdi,2),%rdi
 1088936:	45 89 98 30 02 00 00 	mov    %r11d,0x230(%r8)
 108893d:	47 8d 4c 09 02       	lea    0x2(%r9,%r9,1),%r9d
 1088942:	41 89 34 ba          	mov    %esi,(%r10,%rdi,4)
 1088946:	45 89 4c ba 04       	mov    %r9d,0x4(%r10,%rdi,4)
 108894b:	41 c7 44 ba 08 00 00 	movl   $0x0,0x8(%r10,%rdi,4)
 1088952:	00 00 
 1088954:	e9 8f fe ff ff       	jmp    10887e8 <check_input_run+0x84d8>
 1088959:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
 1088960:	ba 20 00 00 00       	mov    $0x20,%edx
 1088965:	31 f6                	xor    %esi,%esi
 1088967:	eb 25                	jmp    108898e <check_input_run+0x867e>
 1088969:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
 1088970:	41 c6 80 bd 03 00 00 	movb   $0x1,0x3bd(%r8)
 1088977:	01 
 1088978:	8b 79 2c             	mov    0x2c(%rcx),%edi
 108897b:	48 ff c6             	inc    %rsi
 108897e:	48 83 c2 30          	add    $0x30,%rdx
 1088982:	03 79 28             	add    0x28(%rcx),%edi
 1088985:	48 39 fe             	cmp    %rdi,%rsi
 1088988:	0f 83 42 fe ff ff    	jae    10887d0 <check_input_run+0x84c0>
 108898e:	48 8b 79 10          	mov    0x10(%rcx),%rdi
 1088992:	4c 8b 8b c0 02 00 00 	mov    0x2c0(%rbx),%r9
 1088999:	44 8b 44 17 fc       	mov    -0x4(%rdi,%rdx,1),%r8d
 108899e:	47 8b 0c 81          	mov    (%r9,%r8,4),%r9d
 10889a2:	44 89 0c 17          	mov    %r9d,(%rdi,%rdx,1)
 10889a6:	41 83 f9 ff          	cmp    $0xffffffff,%r9d
 10889aa:	75 cc                	jne    1088978 <check_input_run+0x8668>
 10889ac:	44 3b 84 24 30 06 00 	cmp    0x630(%rsp),%r8d
 10889b3:	00 
 10889b4:	73 c2                	jae    1088978 <check_input_run+0x8668>
 10889b6:	4c 8b 84 24 60 02 00 	mov    0x260(%rsp),%r8
 10889bd:	00 
 10889be:	45 8b 88 30 02 00 00 	mov    0x230(%r8),%r9d
 10889c5:	45 3b 88 34 02 00 00 	cmp    0x234(%r8),%r9d
 10889cc:	73 a2                	jae    1088970 <check_input_run+0x8660>
 10889ce:	45 0f b6 90 bd 03 00 	movzbl 0x3bd(%r8),%r10d
 10889d5:	00 
 10889d6:	8b 7c 17 f4          	mov    -0xc(%rdi,%rdx,1),%edi
 10889da:	4d 8b 98 28 02 00 00 	mov    0x228(%r8),%r11
 10889e1:	41 8d 69 01          	lea    0x1(%r9),%ebp
 10889e5:	41 89 a8 30 02 00 00 	mov    %ebp,0x230(%r8)
 10889ec:	4f 8d 04 49          	lea    (%r9,%r9,2),%r8
 10889f0:	47 8d 54 52 01       	lea    0x1(%r10,%r10,2),%r10d
 10889f5:	43 89 3c 83          	mov    %edi,(%r11,%r8,4)
 10889f9:	47 89 54 83 04       	mov    %r10d,0x4(%r11,%r8,4)
 10889fe:	43 c7 44 83 08 00 00 	movl   $0x0,0x8(%r11,%r8,4)
 1088a05:	00 00 
 1088a07:	e9 6c ff ff ff       	jmp    1088978 <check_input_run+0x8668>
 1088a0c:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 1088a11:	83 b8 30 02 00 00 00 	cmpl   $0x0,0x230(%rax)
 1088a18:	0f b6 80 bd 03 00 00 	movzbl 0x3bd(%rax),%eax
 1088a1f:	74 0a                	je     1088a2b <check_input_run+0x871b>
 1088a21:	89 c1                	mov    %eax,%ecx
 1088a23:	80 f1 01             	xor    $0x1,%cl
 1088a26:	e9 55 08 00 00       	jmp    1089280 <check_input_run+0x8f70>
 1088a2b:	84 c0                	test   %al,%al
 1088a2d:	74 07                	je     1088a36 <check_input_run+0x8726>
 1088a2f:	b0 01                	mov    $0x1,%al
 1088a31:	e9 48 08 00 00       	jmp    108927e <check_input_run+0x8f6e>
 1088a36:	48 8b 8c 24 60 02 00 	mov    0x260(%rsp),%rcx
 1088a3d:	00 
 1088a3e:	48 8b 84 24 68 02 00 	mov    0x268(%rsp),%rax
 1088a45:	00 
 1088a46:	83 b9 30 03 00 00 00 	cmpl   $0x0,0x330(%rcx)
 1088a4d:	0f 84 88 00 00 00    	je     1088adb <check_input_run+0x87cb>
 1088a53:	31 d2                	xor    %edx,%edx
 1088a55:	31 f6                	xor    %esi,%esi
 1088a57:	eb 19                	jmp    1088a72 <check_input_run+0x8762>
 1088a59:	c6 81 bd 03 00 00 01 	movb   $0x1,0x3bd(%rcx)
 1088a60:	8b b9 30 03 00 00    	mov    0x330(%rcx),%edi
 1088a66:	48 ff c6             	inc    %rsi
 1088a69:	48 83 c2 24          	add    $0x24,%rdx
 1088a6d:	48 39 fe             	cmp    %rdi,%rsi
 1088a70:	73 69                	jae    1088adb <check_input_run+0x87cb>
 1088a72:	4c 8b 81 28 03 00 00 	mov    0x328(%rcx),%r8
 1088a79:	41 80 7c 10 20 01    	cmpb   $0x1,0x20(%r8,%rdx,1)
 1088a7f:	75 df                	jne    1088a60 <check_input_run+0x8750>
 1088a81:	41 83 7c 10 10 ff    	cmpl   $0xffffffff,0x10(%r8,%rdx,1)
 1088a87:	75 d7                	jne    1088a60 <check_input_run+0x8750>
 1088a89:	8b b9 30 02 00 00    	mov    0x230(%rcx),%edi
 1088a8f:	3b b9 34 02 00 00    	cmp    0x234(%rcx),%edi
 1088a95:	73 c2                	jae    1088a59 <check_input_run+0x8749>
 1088a97:	44 0f b6 89 bd 03 00 	movzbl 0x3bd(%rcx),%r9d
 1088a9e:	00 
 1088a9f:	45 8b 44 10 08       	mov    0x8(%r8,%rdx,1),%r8d
 1088aa4:	4c 8b 91 28 02 00 00 	mov    0x228(%rcx),%r10
 1088aab:	44 8d 5f 01          	lea    0x1(%rdi),%r11d
 1088aaf:	44 89 99 30 02 00 00 	mov    %r11d,0x230(%rcx)
 1088ab6:	48 8d 0c 7f          	lea    (%rdi,%rdi,2),%rcx
 1088aba:	47 8d 4c 49 01       	lea    0x1(%r9,%r9,2),%r9d
 1088abf:	45 89 04 8a          	mov    %r8d,(%r10,%rcx,4)
 1088ac3:	45 89 4c 8a 04       	mov    %r9d,0x4(%r10,%rcx,4)
 1088ac8:	41 c7 44 8a 08 00 00 	movl   $0x0,0x8(%r10,%rcx,4)
 1088acf:	00 00 
 1088ad1:	48 8b 8c 24 60 02 00 	mov    0x260(%rsp),%rcx
 1088ad8:	00 
 1088ad9:	eb 85                	jmp    1088a60 <check_input_run+0x8750>
 1088adb:	83 78 30 00          	cmpl   $0x0,0x30(%rax)
 1088adf:	0f 84 9c 01 00 00    	je     1088c81 <check_input_run+0x8971>
 1088ae5:	31 d2                	xor    %edx,%edx
 1088ae7:	31 c9                	xor    %ecx,%ecx
 1088ae9:	eb 2b                	jmp    1088b16 <check_input_run+0x8806>
 1088aeb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
 1088af0:	48 8b b4 24 00 06 00 	mov    0x600(%rsp),%rsi
 1088af7:	00 
 1088af8:	8d 7a ff             	lea    -0x1(%rdx),%edi
 1088afb:	8b 34 be             	mov    (%rsi,%rdi,4),%esi
 1088afe:	ff c6                	inc    %esi
 1088b00:	48 8b bc 24 f8 05 00 	mov    0x5f8(%rsp),%rdi
 1088b07:	00 
 1088b08:	89 34 8f             	mov    %esi,(%rdi,%rcx,4)
 1088b0b:	48 ff c1             	inc    %rcx
 1088b0e:	8b 78 30             	mov    0x30(%rax),%edi
 1088b11:	48 39 f9             	cmp    %rdi,%rcx
 1088b14:	73 5b                	jae    1088b71 <check_input_run+0x8861>
 1088b16:	48 8b bc 24 b8 04 00 	mov    0x4b8(%rsp),%rdi
 1088b1d:	00 
 1088b1e:	be 00 00 00 00       	mov    $0x0,%esi
 1088b23:	85 d2                	test   %edx,%edx
 1088b25:	74 2b                	je     1088b52 <check_input_run+0x8842>
 1088b27:	89 d6                	mov    %edx,%esi
 1088b29:	48 8b 94 24 00 06 00 	mov    0x600(%rsp),%rdx
 1088b30:	00 
 1088b31:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1088b38:	0f 1f 84 00 00 00 00 
 1088b3f:	00 
 1088b40:	44 8b 44 b2 fc       	mov    -0x4(%rdx,%rsi,4),%r8d
 1088b45:	42 39 0c 87          	cmp    %ecx,(%rdi,%r8,4)
 1088b49:	77 07                	ja     1088b52 <check_input_run+0x8842>
 1088b4b:	48 ff ce             	dec    %rsi
 1088b4e:	75 f0                	jne    1088b40 <check_input_run+0x8830>
 1088b50:	31 f6                	xor    %esi,%esi
 1088b52:	83 3c 8f 00          	cmpl   $0x0,(%rdi,%rcx,4)
 1088b56:	74 0f                	je     1088b67 <check_input_run+0x8857>
 1088b58:	48 8b 94 24 00 06 00 	mov    0x600(%rsp),%rdx
 1088b5f:	00 
 1088b60:	89 f7                	mov    %esi,%edi
 1088b62:	ff c6                	inc    %esi
 1088b64:	89 0c ba             	mov    %ecx,(%rdx,%rdi,4)
 1088b67:	89 f2                	mov    %esi,%edx
 1088b69:	85 f6                	test   %esi,%esi
 1088b6b:	75 83                	jne    1088af0 <check_input_run+0x87e0>
 1088b6d:	31 f6                	xor    %esi,%esi
 1088b6f:	eb 8f                	jmp    1088b00 <check_input_run+0x87f0>
 1088b71:	48 8d 48 10          	lea    0x10(%rax),%rcx
 1088b75:	85 ff                	test   %edi,%edi
 1088b77:	0f 84 08 01 00 00    	je     1088c85 <check_input_run+0x8975>
 1088b7d:	31 d2                	xor    %edx,%edx
 1088b7f:	eb 1e                	jmp    1088b9f <check_input_run+0x888f>
 1088b81:	c6 86 bd 03 00 00 01 	movb   $0x1,0x3bd(%rsi)
 1088b88:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
 1088b8f:	00 
 1088b90:	8b 78 30             	mov    0x30(%rax),%edi
 1088b93:	48 ff c2             	inc    %rdx
 1088b96:	48 39 fa             	cmp    %rdi,%rdx
 1088b99:	0f 83 e6 00 00 00    	jae    1088c85 <check_input_run+0x8975>
 1088b9f:	48 8b 31             	mov    (%rcx),%rsi
 1088ba2:	80 3c 16 4f          	cmpb   $0x4f,(%rsi,%rdx,1)
 1088ba6:	75 1d                	jne    1088bc5 <check_input_run+0x88b5>
 1088ba8:	48 8b b4 24 60 02 00 	mov    0x260(%rsp),%rsi
 1088baf:	00 
 1088bb0:	4c 8b 86 00 03 00 00 	mov    0x300(%rsi),%r8
 1088bb7:	45 8b 0c 90          	mov    (%r8,%rdx,4),%r9d
 1088bbb:	41 89 d0             	mov    %edx,%r8d
 1088bbe:	41 39 f9             	cmp    %edi,%r9d
 1088bc1:	73 cd                	jae    1088b90 <check_input_run+0x8880>
 1088bc3:	eb 3e                	jmp    1088c03 <check_input_run+0x88f3>
 1088bc5:	48 8b 70 50          	mov    0x50(%rax),%rsi
 1088bc9:	80 3c 16 3a          	cmpb   $0x3a,(%rsi,%rdx,1)
 1088bcd:	75 c1                	jne    1088b90 <check_input_run+0x8880>
 1088bcf:	48 8b b4 24 60 02 00 	mov    0x260(%rsp),%rsi
 1088bd6:	00 
 1088bd7:	4c 8b 86 f8 02 00 00 	mov    0x2f8(%rsi),%r8
 1088bde:	45 8b 04 90          	mov    (%r8,%rdx,4),%r8d
 1088be2:	41 39 f8             	cmp    %edi,%r8d
 1088be5:	73 0e                	jae    1088bf5 <check_input_run+0x88e5>
 1088be7:	4c 8b 8c 24 d0 05 00 	mov    0x5d0(%rsp),%r9
 1088bee:	00 
 1088bef:	47 8b 04 81          	mov    (%r9,%r8,4),%r8d
 1088bf3:	eb 06                	jmp    1088bfb <check_input_run+0x88eb>
 1088bf5:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
 1088bfb:	41 89 d1             	mov    %edx,%r9d
 1088bfe:	41 39 f9             	cmp    %edi,%r9d
 1088c01:	73 8d                	jae    1088b90 <check_input_run+0x8880>
 1088c03:	48 8b bc 24 f8 05 00 	mov    0x5f8(%rsp),%rdi
 1088c0a:	00 
 1088c0b:	45 89 c9             	mov    %r9d,%r9d
 1088c0e:	42 8b 3c 8f          	mov    (%rdi,%r9,4),%edi
 1088c12:	85 ff                	test   %edi,%edi
 1088c14:	0f 84 76 ff ff ff    	je     1088b90 <check_input_run+0x8880>
 1088c1a:	ff cf                	dec    %edi
 1088c1c:	41 39 f8             	cmp    %edi,%r8d
 1088c1f:	72 14                	jb     1088c35 <check_input_run+0x8925>
 1088c21:	4c 8b 8c 24 b8 04 00 	mov    0x4b8(%rsp),%r9
 1088c28:	00 
 1088c29:	89 ff                	mov    %edi,%edi
 1088c2b:	45 3b 04 b9          	cmp    (%r9,%rdi,4),%r8d
 1088c2f:	0f 82 5b ff ff ff    	jb     1088b90 <check_input_run+0x8880>
 1088c35:	8b be 30 02 00 00    	mov    0x230(%rsi),%edi
 1088c3b:	3b be 34 02 00 00    	cmp    0x234(%rsi),%edi
 1088c41:	0f 83 3a ff ff ff    	jae    1088b81 <check_input_run+0x8871>
 1088c47:	44 0f b6 86 bd 03 00 	movzbl 0x3bd(%rsi),%r8d
 1088c4e:	00 
 1088c4f:	4c 8b 8e 28 02 00 00 	mov    0x228(%rsi),%r9
 1088c56:	44 8d 57 01          	lea    0x1(%rdi),%r10d
 1088c5a:	44 89 96 30 02 00 00 	mov    %r10d,0x230(%rsi)
 1088c61:	48 8d 34 7f          	lea    (%rdi,%rdi,2),%rsi
 1088c65:	47 8d 44 40 01       	lea    0x1(%r8,%r8,2),%r8d
 1088c6a:	41 89 14 b1          	mov    %edx,(%r9,%rsi,4)
 1088c6e:	45 89 44 b1 04       	mov    %r8d,0x4(%r9,%rsi,4)
 1088c73:	41 c7 44 b1 08 00 00 	movl   $0x0,0x8(%r9,%rsi,4)
 1088c7a:	00 00 
 1088c7c:	e9 0f ff ff ff       	jmp    1088b90 <check_input_run+0x8880>
 1088c81:	48 8d 48 10          	lea    0x10(%rax),%rcx
 1088c85:	8b bc 24 38 06 00 00 	mov    0x638(%rsp),%edi
 1088c8c:	85 ff                	test   %edi,%edi
 1088c8e:	0f 84 d1 05 00 00    	je     1089265 <check_input_run+0x8f55>
 1088c94:	31 f6                	xor    %esi,%esi
 1088c96:	eb 0e                	jmp    1088ca6 <check_input_run+0x8996>
 1088c98:	89 f5                	mov    %esi,%ebp
 1088c9a:	ff c5                	inc    %ebp
 1088c9c:	89 ee                	mov    %ebp,%esi
 1088c9e:	85 ff                	test   %edi,%edi
 1088ca0:	0f 84 bf 05 00 00    	je     1089265 <check_input_run+0x8f55>
 1088ca6:	44 8b 50 30          	mov    0x30(%rax),%r10d
 1088caa:	44 39 d6             	cmp    %r10d,%esi
 1088cad:	0f 83 b2 05 00 00    	jae    1089265 <check_input_run+0x8f55>
 1088cb3:	4c 8b 9c 24 60 02 00 	mov    0x260(%rsp),%r11
 1088cba:	00 
 1088cbb:	41 89 f0             	mov    %esi,%r8d
 1088cbe:	49 8b 93 f0 01 00 00 	mov    0x1f0(%r11),%rdx
 1088cc5:	48 85 d2             	test   %rdx,%rdx
 1088cc8:	74 07                	je     1088cd1 <check_input_run+0x89c1>
 1088cca:	42 80 3c 02 00       	cmpb   $0x0,(%rdx,%r8,1)
 1088ccf:	75 c7                	jne    1088c98 <check_input_run+0x8988>
 1088cd1:	48 8b 58 50          	mov    0x50(%rax),%rbx
 1088cd5:	4a 8d 14 85 00 00 00 	lea    0x0(,%r8,4),%rdx
 1088cdc:	00 
 1088cdd:	48 03 50 60          	add    0x60(%rax),%rdx
 1088ce1:	42 80 3c 03 34       	cmpb   $0x34,(%rbx,%r8,1)
 1088ce6:	75 b0                	jne    1088c98 <check_input_run+0x8988>
 1088ce8:	8b 2a                	mov    (%rdx),%ebp
 1088cea:	44 39 d5             	cmp    %r10d,%ebp
 1088ced:	73 a9                	jae    1088c98 <check_input_run+0x8988>
 1088cef:	4d 8d 48 01          	lea    0x1(%r8),%r9
 1088cf3:	41 39 e9             	cmp    %ebp,%r9d
 1088cf6:	73 a2                	jae    1088c9a <check_input_run+0x898a>
 1088cf8:	41 89 f6             	mov    %esi,%r14d
 1088cfb:	41 29 ee             	sub    %ebp,%r14d
 1088cfe:	89 f7                	mov    %esi,%edi
 1088d00:	f7 d7                	not    %edi
 1088d02:	8d 55 fe             	lea    -0x2(%rbp),%edx
 1088d05:	4c 89 44 24 68       	mov    %r8,0x68(%rsp)
 1088d0a:	41 f7 d6             	not    %r14d
 1088d0d:	01 ef                	add    %ebp,%edi
 1088d0f:	89 54 24 38          	mov    %edx,0x38(%rsp)
 1088d13:	29 f2                	sub    %esi,%edx
 1088d15:	41 83 e6 03          	and    $0x3,%r14d
 1088d19:	89 7c 24 40          	mov    %edi,0x40(%rsp)
 1088d1d:	83 fa 03             	cmp    $0x3,%edx
 1088d20:	73 10                	jae    1088d32 <check_input_run+0x8a22>
 1088d22:	31 ff                	xor    %edi,%edi
 1088d24:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
 1088d2a:	4d 89 cf             	mov    %r9,%r15
 1088d2d:	e9 16 02 00 00       	jmp    1088f48 <check_input_run+0x8c38>
 1088d32:	48 89 6c 24 60       	mov    %rbp,0x60(%rsp)
 1088d37:	4a 8d 6c 0b 03       	lea    0x3(%rbx,%r9,1),%rbp
 1088d3c:	41 89 f8             	mov    %edi,%r8d
 1088d3f:	41 83 e0 fc          	and    $0xfffffffc,%r8d
 1088d43:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
 1088d49:	45 31 ff             	xor    %r15d,%r15d
 1088d4c:	31 ff                	xor    %edi,%edi
 1088d4e:	66 90                	xchg   %ax,%ax
 1088d50:	42 80 7c 3d fd 09    	cmpb   $0x9,-0x3(%rbp,%r15,1)
 1088d56:	75 58                	jne    1088db0 <check_input_run+0x8aa0>
 1088d58:	48 8b 11             	mov    (%rcx),%rdx
 1088d5b:	4c 01 ca             	add    %r9,%rdx
 1088d5e:	41 80 3c 17 0f       	cmpb   $0xf,(%r15,%rdx,1)
 1088d63:	75 4b                	jne    1088db0 <check_input_run+0x8aa0>
 1088d65:	49 8b 93 00 03 00 00 	mov    0x300(%r11),%rdx
 1088d6c:	4e 8d 24 8d 00 00 00 	lea    0x0(,%r9,4),%r12
 1088d73:	00 
 1088d74:	4c 01 e2             	add    %r12,%rdx
 1088d77:	42 8b 14 ba          	mov    (%rdx,%r15,4),%edx
 1088d7b:	44 39 d2             	cmp    %r10d,%edx
 1088d7e:	73 30                	jae    1088db0 <check_input_run+0x8aa0>
 1088d80:	4c 8b a4 24 f8 05 00 	mov    0x5f8(%rsp),%r12
 1088d87:	00 
 1088d88:	41 8b 14 94          	mov    (%r12,%rdx,4),%edx
 1088d8c:	85 d2                	test   %edx,%edx
 1088d8e:	74 20                	je     1088db0 <check_input_run+0x8aa0>
 1088d90:	4c 8b a4 24 b8 04 00 	mov    0x4b8(%rsp),%r12
 1088d97:	00 
 1088d98:	ff ca                	dec    %edx
 1088d9a:	39 fa                	cmp    %edi,%edx
 1088d9c:	0f 47 fa             	cmova  %edx,%edi
 1088d9f:	41 8b 14 94          	mov    (%r12,%rdx,4),%edx
 1088da3:	44 39 ea             	cmp    %r13d,%edx
 1088da6:	44 0f 42 ea          	cmovb  %edx,%r13d
 1088daa:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
 1088db0:	42 80 7c 3d fe 09    	cmpb   $0x9,-0x2(%rbp,%r15,1)
 1088db6:	75 58                	jne    1088e10 <check_input_run+0x8b00>
 1088db8:	48 8b 11             	mov    (%rcx),%rdx
 1088dbb:	4c 01 ca             	add    %r9,%rdx
 1088dbe:	41 80 7c 17 01 0f    	cmpb   $0xf,0x1(%r15,%rdx,1)
 1088dc4:	75 4a                	jne    1088e10 <check_input_run+0x8b00>
 1088dc6:	49 8b 93 00 03 00 00 	mov    0x300(%r11),%rdx
 1088dcd:	4e 8d 24 8d 00 00 00 	lea    0x0(,%r9,4),%r12
 1088dd4:	00 
 1088dd5:	4c 01 e2             	add    %r12,%rdx
 1088dd8:	42 8b 54 ba 04       	mov    0x4(%rdx,%r15,4),%edx
 1088ddd:	44 39 d2             	cmp    %r10d,%edx
 1088de0:	73 2e                	jae    1088e10 <check_input_run+0x8b00>
 1088de2:	4c 8b a4 24 f8 05 00 	mov    0x5f8(%rsp),%r12
 1088de9:	00 
 1088dea:	41 8b 14 94          	mov    (%r12,%rdx,4),%edx
 1088dee:	85 d2                	test   %edx,%edx
 1088df0:	74 1e                	je     1088e10 <check_input_run+0x8b00>
 1088df2:	4c 8b a4 24 b8 04 00 	mov    0x4b8(%rsp),%r12
 1088df9:	00 
 1088dfa:	ff ca                	dec    %edx
 1088dfc:	39 fa                	cmp    %edi,%edx
 1088dfe:	0f 47 fa             	cmova  %edx,%edi
 1088e01:	41 8b 14 94          	mov    (%r12,%rdx,4),%edx
 1088e05:	44 39 ea             	cmp    %r13d,%edx
 1088e08:	44 0f 42 ea          	cmovb  %edx,%r13d
 1088e0c:	0f 1f 40 00          	nopl   0x0(%rax)
 1088e10:	42 80 7c 3d ff 09    	cmpb   $0x9,-0x1(%rbp,%r15,1)
 1088e16:	75 78                	jne    1088e90 <check_input_run+0x8b80>
 1088e18:	48 8b 11             	mov    (%rcx),%rdx
 1088e1b:	4c 01 ca             	add    %r9,%rdx
 1088e1e:	41 80 7c 17 02 0f    	cmpb   $0xf,0x2(%r15,%rdx,1)
 1088e24:	75 6a                	jne    1088e90 <check_input_run+0x8b80>
 1088e26:	49 8b 93 00 03 00 00 	mov    0x300(%r11),%rdx
 1088e2d:	4e 8d 24 8d 00 00 00 	lea    0x0(,%r9,4),%r12
 1088e34:	00 
 1088e35:	4c 01 e2             	add    %r12,%rdx
 1088e38:	42 8b 54 ba 08       	mov    0x8(%rdx,%r15,4),%edx
 1088e3d:	44 39 d2             	cmp    %r10d,%edx
 1088e40:	73 4e                	jae    1088e90 <check_input_run+0x8b80>
 1088e42:	4c 8b a4 24 f8 05 00 	mov    0x5f8(%rsp),%r12
 1088e49:	00 
 1088e4a:	41 8b 14 94          	mov    (%r12,%rdx,4),%edx
 1088e4e:	85 d2                	test   %edx,%edx
 1088e50:	74 3e                	je     1088e90 <check_input_run+0x8b80>
 1088e52:	ff ca                	dec    %edx
 1088e54:	41 89 d4             	mov    %edx,%r12d
 1088e57:	39 fa                	cmp    %edi,%edx
 1088e59:	77 03                	ja     1088e5e <check_input_run+0x8b4e>
 1088e5b:	41 89 fc             	mov    %edi,%r12d
 1088e5e:	48 8b bc 24 b8 04 00 	mov    0x4b8(%rsp),%rdi
 1088e65:	00 
 1088e66:	8b 14 97             	mov    (%rdi,%rdx,4),%edx
 1088e69:	44 39 ea             	cmp    %r13d,%edx
 1088e6c:	72 03                	jb     1088e71 <check_input_run+0x8b61>
 1088e6e:	44 89 ea             	mov    %r13d,%edx
 1088e71:	41 89 d5             	mov    %edx,%r13d
 1088e74:	42 80 7c 3d 00 09    	cmpb   $0x9,0x0(%rbp,%r15,1)
 1088e7a:	74 1f                	je     1088e9b <check_input_run+0x8b8b>
 1088e7c:	e9 8f 00 00 00       	jmp    1088f10 <check_input_run+0x8c00>
 1088e81:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1088e88:	0f 1f 84 00 00 00 00 
 1088e8f:	00 
 1088e90:	41 89 fc             	mov    %edi,%r12d
 1088e93:	42 80 7c 3d 00 09    	cmpb   $0x9,0x0(%rbp,%r15,1)
 1088e99:	75 75                	jne    1088f10 <check_input_run+0x8c00>
 1088e9b:	48 8b 11             	mov    (%rcx),%rdx
 1088e9e:	4c 01 ca             	add    %r9,%rdx
 1088ea1:	41 80 7c 17 03 0f    	cmpb   $0xf,0x3(%r15,%rdx,1)
 1088ea7:	75 67                	jne    1088f10 <check_input_run+0x8c00>
 1088ea9:	49 8b 93 00 03 00 00 	mov    0x300(%r11),%rdx
 1088eb0:	4a 8d 3c 8d 00 00 00 	lea    0x0(,%r9,4),%rdi
 1088eb7:	00 
 1088eb8:	48 01 fa             	add    %rdi,%rdx
 1088ebb:	42 8b 54 ba 0c       	mov    0xc(%rdx,%r15,4),%edx
 1088ec0:	44 39 d2             	cmp    %r10d,%edx
 1088ec3:	73 4b                	jae    1088f10 <check_input_run+0x8c00>
 1088ec5:	48 8b bc 24 f8 05 00 	mov    0x5f8(%rsp),%rdi
 1088ecc:	00 
 1088ecd:	8b 14 97             	mov    (%rdi,%rdx,4),%edx
 1088ed0:	85 d2                	test   %edx,%edx
 1088ed2:	74 3c                	je     1088f10 <check_input_run+0x8c00>
 1088ed4:	ff ca                	dec    %edx
 1088ed6:	89 d7                	mov    %edx,%edi
 1088ed8:	44 39 e2             	cmp    %r12d,%edx
 1088edb:	77 03                	ja     1088ee0 <check_input_run+0x8bd0>
 1088edd:	44 89 e7             	mov    %r12d,%edi
 1088ee0:	4c 8b a4 24 b8 04 00 	mov    0x4b8(%rsp),%r12
 1088ee7:	00 
 1088ee8:	41 8b 14 94          	mov    (%r12,%rdx,4),%edx
 1088eec:	44 39 ea             	cmp    %r13d,%edx
 1088eef:	72 03                	jb     1088ef4 <check_input_run+0x8be4>
 1088ef1:	44 89 ea             	mov    %r13d,%edx
 1088ef4:	41 89 d5             	mov    %edx,%r13d
 1088ef7:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
 1088efc:	49 83 c7 04          	add    $0x4,%r15
 1088f00:	45 39 f8             	cmp    %r15d,%r8d
 1088f03:	0f 85 47 fe ff ff    	jne    1088d50 <check_input_run+0x8a40>
 1088f09:	eb 1a                	jmp    1088f25 <check_input_run+0x8c15>
 1088f0b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
 1088f10:	44 89 e7             	mov    %r12d,%edi
 1088f13:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
 1088f18:	49 83 c7 04          	add    $0x4,%r15
 1088f1c:	45 39 f8             	cmp    %r15d,%r8d
 1088f1f:	0f 85 2b fe ff ff    	jne    1088d50 <check_input_run+0x8a40>
 1088f25:	45 85 f6             	test   %r14d,%r14d
 1088f28:	74 6b                	je     1088f95 <check_input_run+0x8c85>
 1088f2a:	48 8b 6c 24 60       	mov    0x60(%rsp),%rbp
 1088f2f:	4d 01 cf             	add    %r9,%r15
 1088f32:	eb 14                	jmp    1088f48 <check_input_run+0x8c38>
 1088f34:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
 1088f3b:	00 00 00 00 00 
 1088f40:	49 ff c7             	inc    %r15
 1088f43:	41 ff ce             	dec    %r14d
 1088f46:	74 52                	je     1088f9a <check_input_run+0x8c8a>
 1088f48:	42 80 3c 3b 09       	cmpb   $0x9,(%rbx,%r15,1)
 1088f4d:	75 f1                	jne    1088f40 <check_input_run+0x8c30>
 1088f4f:	48 8b 11             	mov    (%rcx),%rdx
 1088f52:	42 80 3c 3a 0f       	cmpb   $0xf,(%rdx,%r15,1)
 1088f57:	75 e7                	jne    1088f40 <check_input_run+0x8c30>
 1088f59:	49 8b 93 00 03 00 00 	mov    0x300(%r11),%rdx
 1088f60:	42 8b 14 ba          	mov    (%rdx,%r15,4),%edx
 1088f64:	44 39 d2             	cmp    %r10d,%edx
 1088f67:	73 d7                	jae    1088f40 <check_input_run+0x8c30>
 1088f69:	4c 8b 84 24 f8 05 00 	mov    0x5f8(%rsp),%r8
 1088f70:	00 
 1088f71:	41 8b 14 90          	mov    (%r8,%rdx,4),%edx
 1088f75:	85 d2                	test   %edx,%edx
 1088f77:	74 c7                	je     1088f40 <check_input_run+0x8c30>
 1088f79:	4c 8b 84 24 b8 04 00 	mov    0x4b8(%rsp),%r8
 1088f80:	00 
 1088f81:	ff ca                	dec    %edx
 1088f83:	39 fa                	cmp    %edi,%edx
 1088f85:	0f 47 fa             	cmova  %edx,%edi
 1088f88:	41 8b 14 90          	mov    (%r8,%rdx,4),%edx
 1088f8c:	44 39 ea             	cmp    %r13d,%edx
 1088f8f:	44 0f 42 ea          	cmovb  %edx,%r13d
 1088f93:	eb ab                	jmp    1088f40 <check_input_run+0x8c30>
 1088f95:	48 8b 6c 24 60       	mov    0x60(%rsp),%rbp
 1088f9a:	f6 44 24 40 01       	testb  $0x1,0x40(%rsp)
 1088f9f:	45 89 ea             	mov    %r13d,%r10d
 1088fa2:	89 ff                	mov    %edi,%edi
 1088fa4:	75 08                	jne    1088fae <check_input_run+0x8c9e>
 1088fa6:	4d 89 c8             	mov    %r9,%r8
 1088fa9:	e9 b7 00 00 00       	jmp    1089065 <check_input_run+0x8d55>
 1088fae:	4c 8b 19             	mov    (%rcx),%r11
 1088fb1:	4d 8d 41 01          	lea    0x1(%r9),%r8
 1088fb5:	43 80 3c 0b 4f       	cmpb   $0x4f,(%r11,%r9,1)
 1088fba:	0f 85 a5 00 00 00    	jne    1089065 <check_input_run+0x8d55>
 1088fc0:	8b 50 30             	mov    0x30(%rax),%edx
 1088fc3:	49 39 d0             	cmp    %rdx,%r8
 1088fc6:	0f 83 99 00 00 00    	jae    1089065 <check_input_run+0x8d55>
 1088fcc:	48 8b 50 60          	mov    0x60(%rax),%rdx
 1088fd0:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
 1088fd5:	44 3b 4c 9a 08       	cmp    0x8(%rdx,%rbx,4),%r9d
 1088fda:	0f 85 85 00 00 00    	jne    1089065 <check_input_run+0x8d55>
 1088fe0:	48 8b 50 50          	mov    0x50(%rax),%rdx
 1088fe4:	42 80 3c 02 1a       	cmpb   $0x1a,(%rdx,%r8,1)
 1088fe9:	75 7a                	jne    1089065 <check_input_run+0x8d55>
 1088feb:	43 80 3c 03 11       	cmpb   $0x11,(%r11,%r8,1)
 1088ff0:	75 73                	jne    1089065 <check_input_run+0x8d55>
 1088ff2:	4c 8b 9c 24 60 02 00 	mov    0x260(%rsp),%r11
 1088ff9:	00 
 1088ffa:	49 8b 93 48 03 00 00 	mov    0x348(%r11),%rdx
 1089001:	83 7c 9a 04 00       	cmpl   $0x0,0x4(%rdx,%rbx,4)
 1089006:	75 5d                	jne    1089065 <check_input_run+0x8d55>
 1089008:	41 39 f9             	cmp    %edi,%r9d
 108900b:	72 05                	jb     1089012 <check_input_run+0x8d02>
 108900d:	45 39 d1             	cmp    %r10d,%r9d
 1089010:	72 53                	jb     1089065 <check_input_run+0x8d55>
 1089012:	41 8b 93 30 02 00 00 	mov    0x230(%r11),%edx
 1089019:	49 89 ef             	mov    %rbp,%r15
 108901c:	41 3b 93 34 02 00 00 	cmp    0x234(%r11),%edx
 1089023:	73 35                	jae    108905a <check_input_run+0x8d4a>
 1089025:	41 0f b6 9b bd 03 00 	movzbl 0x3bd(%r11),%ebx
 108902c:	00 
 108902d:	4d 8b b3 28 02 00 00 	mov    0x228(%r11),%r14
 1089034:	8d 6a 01             	lea    0x1(%rdx),%ebp
 1089037:	48 8d 14 52          	lea    (%rdx,%rdx,2),%rdx
 108903b:	41 89 ab 30 02 00 00 	mov    %ebp,0x230(%r11)
 1089042:	8d 5c 5b 01          	lea    0x1(%rbx,%rbx,2),%ebx
 1089046:	45 89 0c 96          	mov    %r9d,(%r14,%rdx,4)
 108904a:	41 89 5c 96 04       	mov    %ebx,0x4(%r14,%rdx,4)
 108904f:	41 c7 44 96 08 00 00 	movl   $0x0,0x8(%r14,%rdx,4)
 1089056:	00 00 
 1089058:	eb 08                	jmp    1089062 <check_input_run+0x8d52>
 108905a:	41 c6 83 bd 03 00 00 	movb   $0x1,0x3bd(%r11)
 1089061:	01 
 1089062:	4c 89 fd             	mov    %r15,%rbp
 1089065:	39 74 24 38          	cmp    %esi,0x38(%rsp)
 1089069:	75 0c                	jne    1089077 <check_input_run+0x8d67>
 108906b:	8b bc 24 38 06 00 00 	mov    0x638(%rsp),%edi
 1089072:	e9 23 fc ff ff       	jmp    1088c9a <check_input_run+0x898a>
 1089077:	4e 8d 0c 85 00 00 00 	lea    0x0(,%r8,4),%r9
 108907e:	00 
 108907f:	89 ee                	mov    %ebp,%esi
 1089081:	44 29 c6             	sub    %r8d,%esi
 1089084:	45 31 db             	xor    %r11d,%r11d
 1089087:	eb 50                	jmp    10890d9 <check_input_run+0x8dc9>
 1089089:	41 0f b6 9e bd 03 00 	movzbl 0x3bd(%r14),%ebx
 1089090:	00 
 1089091:	4d 8b be 28 02 00 00 	mov    0x228(%r14),%r15
 1089098:	49 89 ed             	mov    %rbp,%r13
 108909b:	8d 6a 01             	lea    0x1(%rdx),%ebp
 108909e:	48 8d 14 52          	lea    (%rdx,%rdx,2),%rdx
 10890a2:	41 89 ae 30 02 00 00 	mov    %ebp,0x230(%r14)
 10890a9:	43 8d 6c 18 01       	lea    0x1(%r8,%r11,1),%ebp
 10890ae:	8d 5c 5b 01          	lea    0x1(%rbx,%rbx,2),%ebx
 10890b2:	41 89 2c 97          	mov    %ebp,(%r15,%rdx,4)
 10890b6:	4c 89 ed             	mov    %r13,%rbp
 10890b9:	41 89 5c 97 04       	mov    %ebx,0x4(%r15,%rdx,4)
 10890be:	41 c7 44 97 08 00 00 	movl   $0x0,0x8(%r15,%rdx,4)
 10890c5:	00 00 
 10890c7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
 10890ce:	00 00 
 10890d0:	49 83 c3 02          	add    $0x2,%r11
 10890d4:	44 39 de             	cmp    %r11d,%esi
 10890d7:	74 92                	je     108906b <check_input_run+0x8d5b>
 10890d9:	4c 8b 39             	mov    (%rcx),%r15
 10890dc:	4f 8d 34 18          	lea    (%r8,%r11,1),%r14
 10890e0:	4b 8d 5c 18 01       	lea    0x1(%r8,%r11,1),%rbx
 10890e5:	43 80 3c 37 4f       	cmpb   $0x4f,(%r15,%r14,1)
 10890ea:	0f 85 d0 00 00 00    	jne    10891c0 <check_input_run+0x8eb0>
 10890f0:	8b 50 30             	mov    0x30(%rax),%edx
 10890f3:	48 39 d3             	cmp    %rdx,%rbx
 10890f6:	0f 83 c4 00 00 00    	jae    10891c0 <check_input_run+0x8eb0>
 10890fc:	48 8b 50 60          	mov    0x60(%rax),%rdx
 1089100:	4c 01 ca             	add    %r9,%rdx
 1089103:	42 8b 54 9a 04       	mov    0x4(%rdx,%r11,4),%edx
 1089108:	49 39 d6             	cmp    %rdx,%r14
 108910b:	0f 85 af 00 00 00    	jne    10891c0 <check_input_run+0x8eb0>
 1089111:	48 8b 50 50          	mov    0x50(%rax),%rdx
 1089115:	4c 01 c2             	add    %r8,%rdx
 1089118:	41 80 7c 13 01 1a    	cmpb   $0x1a,0x1(%r11,%rdx,1)
 108911e:	0f 85 9c 00 00 00    	jne    10891c0 <check_input_run+0x8eb0>
 1089124:	4d 01 c7             	add    %r8,%r15
 1089127:	43 80 7c 3b 01 11    	cmpb   $0x11,0x1(%r11,%r15,1)
 108912d:	0f 85 8d 00 00 00    	jne    10891c0 <check_input_run+0x8eb0>
 1089133:	4c 8b bc 24 60 02 00 	mov    0x260(%rsp),%r15
 108913a:	00 
 108913b:	49 8b 97 48 03 00 00 	mov    0x348(%r15),%rdx
 1089142:	4c 01 ca             	add    %r9,%rdx
 1089145:	42 83 3c 9a 00       	cmpl   $0x0,(%rdx,%r11,4)
 108914a:	75 74                	jne    10891c0 <check_input_run+0x8eb0>
 108914c:	49 39 fe             	cmp    %rdi,%r14
 108914f:	72 05                	jb     1089156 <check_input_run+0x8e46>
 1089151:	4d 39 d6             	cmp    %r10,%r14
 1089154:	72 6a                	jb     10891c0 <check_input_run+0x8eb0>
 1089156:	41 8b 97 30 02 00 00 	mov    0x230(%r15),%edx
 108915d:	41 3b 97 34 02 00 00 	cmp    0x234(%r15),%edx
 1089164:	73 4a                	jae    10891b0 <check_input_run+0x8ea0>
 1089166:	45 0f b6 a7 bd 03 00 	movzbl 0x3bd(%r15),%r12d
 108916d:	00 
 108916e:	48 89 6c 24 60       	mov    %rbp,0x60(%rsp)
 1089173:	44 8d 6a 01          	lea    0x1(%rdx),%r13d
 1089177:	48 8d 14 52          	lea    (%rdx,%rdx,2),%rdx
 108917b:	43 8d 6c 64 01       	lea    0x1(%r12,%r12,2),%ebp
 1089180:	4d 8b a7 28 02 00 00 	mov    0x228(%r15),%r12
 1089187:	45 89 af 30 02 00 00 	mov    %r13d,0x230(%r15)
 108918e:	47 8d 3c 18          	lea    (%r8,%r11,1),%r15d
 1089192:	45 89 3c 94          	mov    %r15d,(%r12,%rdx,4)
 1089196:	41 89 6c 94 04       	mov    %ebp,0x4(%r12,%rdx,4)
 108919b:	41 c7 44 94 08 00 00 	movl   $0x0,0x8(%r12,%rdx,4)
 10891a2:	00 00 
 10891a4:	48 8b 6c 24 60       	mov    0x60(%rsp),%rbp
 10891a9:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
 10891ae:	eb 10                	jmp    10891c0 <check_input_run+0x8eb0>
 10891b0:	41 c6 87 bd 03 00 00 	movb   $0x1,0x3bd(%r15)
 10891b7:	01 
 10891b8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
 10891bf:	00 
 10891c0:	4c 8b 39             	mov    (%rcx),%r15
 10891c3:	43 80 7c 37 01 4f    	cmpb   $0x4f,0x1(%r15,%r14,1)
 10891c9:	0f 85 01 ff ff ff    	jne    10890d0 <check_input_run+0x8dc0>
 10891cf:	44 8b 70 30          	mov    0x30(%rax),%r14d
 10891d3:	4b 8d 54 18 02       	lea    0x2(%r8,%r11,1),%rdx
 10891d8:	4c 39 f2             	cmp    %r14,%rdx
 10891db:	0f 83 ef fe ff ff    	jae    10890d0 <check_input_run+0x8dc0>
 10891e1:	48 8b 50 60          	mov    0x60(%rax),%rdx
 10891e5:	4c 01 ca             	add    %r9,%rdx
 10891e8:	42 8b 54 9a 08       	mov    0x8(%rdx,%r11,4),%edx
 10891ed:	48 39 d3             	cmp    %rdx,%rbx
 10891f0:	0f 85 da fe ff ff    	jne    10890d0 <check_input_run+0x8dc0>
 10891f6:	48 8b 50 50          	mov    0x50(%rax),%rdx
 10891fa:	4c 01 c2             	add    %r8,%rdx
 10891fd:	41 80 7c 13 02 1a    	cmpb   $0x1a,0x2(%r11,%rdx,1)
 1089203:	0f 85 c7 fe ff ff    	jne    10890d0 <check_input_run+0x8dc0>
 1089209:	4d 01 c7             	add    %r8,%r15
 108920c:	43 80 7c 3b 02 11    	cmpb   $0x11,0x2(%r11,%r15,1)
 1089212:	0f 85 b8 fe ff ff    	jne    10890d0 <check_input_run+0x8dc0>
 1089218:	4c 8b b4 24 60 02 00 	mov    0x260(%rsp),%r14
 108921f:	00 
 1089220:	49 8b 96 48 03 00 00 	mov    0x348(%r14),%rdx
 1089227:	4c 01 ca             	add    %r9,%rdx
 108922a:	42 83 7c 9a 04 00    	cmpl   $0x0,0x4(%rdx,%r11,4)
 1089230:	0f 85 9a fe ff ff    	jne    10890d0 <check_input_run+0x8dc0>
 1089236:	48 39 fb             	cmp    %rdi,%rbx
 1089239:	72 09                	jb     1089244 <check_input_run+0x8f34>
 108923b:	4c 39 d3             	cmp    %r10,%rbx
 108923e:	0f 82 8c fe ff ff    	jb     10890d0 <check_input_run+0x8dc0>
 1089244:	41 8b 96 30 02 00 00 	mov    0x230(%r14),%edx
 108924b:	41 3b 96 34 02 00 00 	cmp    0x234(%r14),%edx
 1089252:	0f 82 31 fe ff ff    	jb     1089089 <check_input_run+0x8d79>
 1089258:	41 c6 86 bd 03 00 00 	movb   $0x1,0x3bd(%r14)
 108925f:	01 
 1089260:	e9 6b fe ff ff       	jmp    10890d0 <check_input_run+0x8dc0>
 1089265:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 108926a:	83 b8 30 02 00 00 00 	cmpl   $0x0,0x230(%rax)
 1089271:	0f b6 80 bd 03 00 00 	movzbl 0x3bd(%rax),%eax
 1089278:	0f 85 a3 f7 ff ff    	jne    1088a21 <check_input_run+0x8711>
 108927e:	31 c9                	xor    %ecx,%ecx
 1089280:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
 1089285:	88 8a bc 03 00 00    	mov    %cl,0x3bc(%rdx)
 108928b:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
 1089290:	84 c0                	test   %al,%al
 1089292:	74 44                	je     10892d8 <check_input_run+0x8fc8>
 1089294:	31 c0                	xor    %eax,%eax
 1089296:	48 8b 94 24 d0 01 00 	mov    0x1d0(%rsp),%rdx
 108929d:	00 
 108929e:	48 3b 51 08          	cmp    0x8(%rcx),%rdx
 10892a2:	0f 87 22 23 00 00    	ja     108b5ca <check_input_run+0xb2ba>
 10892a8:	48 89 51 08          	mov    %rdx,0x8(%rcx)
 10892ac:	64 48 8b 0c 25 28 00 	mov    %fs:0x28,%rcx
 10892b3:	00 00 
 10892b5:	48 3b 8c 24 c0 06 00 	cmp    0x6c0(%rsp),%rcx
 10892bc:	00 
 10892bd:	0f 85 29 23 00 00    	jne    108b5ec <check_input_run+0xb2dc>
 10892c3:	48 81 c4 c8 06 00 00 	add    $0x6c8,%rsp
 10892ca:	5b                   	pop    %rbx
 10892cb:	41 5c                	pop    %r12
 10892cd:	41 5d                	pop    %r13
 10892cf:	41 5e                	pop    %r14
 10892d1:	41 5f                	pop    %r15
 10892d3:	5d                   	pop    %rbp
 10892d4:	c5 f8 77             	vzeroupper
 10892d7:	c3                   	ret
 10892d8:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
 10892dd:	31 c0                	xor    %eax,%eax
 10892df:	83 ba 30 02 00 00 00 	cmpl   $0x0,0x230(%rdx)
 10892e6:	75 ae                	jne    1089296 <check_input_run+0x8f86>
 10892e8:	80 bc 24 f8 02 00 00 	cmpb   $0x0,0x2f8(%rsp)
 10892ef:	00 
 10892f0:	74 a4                	je     1089296 <check_input_run+0x8f86>
 10892f2:	48 8b 5c 24 08       	mov    0x8(%rsp),%rbx
 10892f7:	4c 8b 8c 24 b0 05 00 	mov    0x5b0(%rsp),%r9
 10892fe:	00 
 10892ff:	4c 8b 84 24 18 01 00 	mov    0x118(%rsp),%r8
 1089306:	00 
 1089307:	4c 89 e6             	mov    %r12,%rsi
 108930a:	48 8d 94 24 90 02 00 	lea    0x290(%rsp),%rdx
 1089311:	00 
 1089312:	48 8b 8b 40 02 00 00 	mov    0x240(%rbx),%rcx
 1089319:	48 8d bb 40 01 00 00 	lea    0x140(%rbx),%rdi
 1089320:	ff 74 24 28          	push   0x28(%rsp)
 1089324:	ff 74 24 08          	push   0x8(%rsp)
 1089328:	c5 f8 77             	vzeroupper
 108932b:	e8 e0 8a 01 00       	call   10a1e10 <check_environment_publish>
 1089330:	48 83 c4 10          	add    $0x10,%rsp
 1089334:	89 c1                	mov    %eax,%ecx
 1089336:	80 f1 01             	xor    $0x1,%cl
 1089339:	08 8b bd 03 00 00    	or     %cl,0x3bd(%rbx)
 108933f:	e9 fc a0 ff ff       	jmp    1083440 <check_input_run+0x3130>
 1089344:	48 89 c2             	mov    %rax,%rdx
 1089347:	48 29 f2             	sub    %rsi,%rdx
 108934a:	48 8b 77 10          	mov    0x10(%rdi),%rsi
 108934e:	31 ed                	xor    %ebp,%ebp
 1089350:	48 29 d6             	sub    %rdx,%rsi
 1089353:	0f 82 c7 ec ff ff    	jb     1088020 <check_input_run+0x7d10>
 1089359:	bf 00 00 00 00       	mov    $0x0,%edi
 108935e:	48 89 bc 24 70 01 00 	mov    %rdi,0x170(%rsp)
 1089365:	00 
 1089366:	4c 39 ce             	cmp    %r9,%rsi
 1089369:	0f 86 bd ec ff ff    	jbe    108802c <check_input_run+0x7d1c>
 108936f:	48 8b 3c 24          	mov    (%rsp),%rdi
 1089373:	49 8d 71 01          	lea    0x1(%r9),%rsi
 1089377:	48 01 d6             	add    %rdx,%rsi
 108937a:	48 89 77 08          	mov    %rsi,0x8(%rdi)
 108937e:	48 85 c0             	test   %rax,%rax
 1089381:	0f 84 97 ec ff ff    	je     108801e <check_input_run+0x7d0e>
 1089387:	48 8b 39             	mov    (%rcx),%rdi
 108938a:	48 8b 51 08          	mov    0x8(%rcx),%rdx
 108938e:	48 8d 6c 3a 3f       	lea    0x3f(%rdx,%rdi,1),%rbp
 1089393:	48 01 fa             	add    %rdi,%rdx
 1089396:	48 83 e5 c0          	and    $0xffffffffffffffc0,%rbp
 108939a:	48 39 d5             	cmp    %rdx,%rbp
 108939d:	0f 83 45 0e 00 00    	jae    108a1e8 <check_input_run+0x9ed8>
 10893a3:	31 ed                	xor    %ebp,%ebp
 10893a5:	48 89 84 24 70 01 00 	mov    %rax,0x170(%rsp)
 10893ac:	00 
 10893ad:	e9 7a ec ff ff       	jmp    108802c <check_input_run+0x7d1c>
 10893b2:	be ff 00 00 00       	mov    $0xff,%esi
 10893b7:	48 89 7c 24 38       	mov    %rdi,0x38(%rsp)
 10893bc:	e8 bf 5b 70 ff       	call   78ef80 <memset@plt>
 10893c1:	4c 89 ef             	mov    %r13,%rdi
 10893c4:	31 f6                	xor    %esi,%esi
 10893c6:	48 89 ea             	mov    %rbp,%rdx
 10893c9:	e8 b2 5b 70 ff       	call   78ef80 <memset@plt>
 10893ce:	48 85 db             	test   %rbx,%rbx
 10893d1:	0f 84 74 19 00 00    	je     108ad4b <check_input_run+0xaa3b>
 10893d7:	89 d9                	mov    %ebx,%ecx
 10893d9:	48 8d 43 ff          	lea    -0x1(%rbx),%rax
 10893dd:	83 e1 03             	and    $0x3,%ecx
 10893e0:	48 83 f8 03          	cmp    $0x3,%rax
 10893e4:	0f 83 90 07 00 00    	jae    1089b7a <check_input_run+0x986a>
 10893ea:	4c 8b 5c 24 38       	mov    0x38(%rsp),%r11
 10893ef:	be ff ff ff ff       	mov    $0xffffffff,%esi
 10893f4:	31 d2                	xor    %edx,%edx
 10893f6:	e9 7d 09 00 00       	jmp    1089d78 <check_input_run+0x9a68>
 10893fb:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
 1089400:	62 f2 7d 48 5a 05 36 	vbroadcasti32x4 -0xaf79ca(%rip),%zmm0        # 591a40 <abi_test_hex.digits+0xbb0>
 1089407:	86 50 ff 
 108940a:	31 c9                	xor    %ecx,%ecx
 108940c:	31 db                	xor    %ebx,%ebx
 108940e:	44 8b 90 38 0c 00 00 	mov    0xc38(%rax),%r10d
 1089415:	48 05 30 08 00 00    	add    $0x830,%rax
 108941b:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
 1089420:	eb 1c                	jmp    108943e <check_input_run+0x912e>
 1089422:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
 1089427:	48 8b 5c 24 40       	mov    0x40(%rsp),%rbx
 108942c:	44 8b 90 38 0c 00 00 	mov    0xc38(%rax),%r10d
 1089433:	ff c3                	inc    %ebx
 1089435:	44 39 d3             	cmp    %r10d,%ebx
 1089438:	0f 87 26 03 00 00    	ja     1089764 <check_input_run+0x9454>
 108943e:	41 b3 01             	mov    $0x1,%r11b
 1089441:	85 db                	test   %ebx,%ebx
 1089443:	74 25                	je     108946a <check_input_run+0x915a>
 1089445:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
 108944a:	48 8b 90 30 0c 00 00 	mov    0xc30(%rax),%rdx
 1089451:	48 85 d2             	test   %rdx,%rdx
 1089454:	74 14                	je     108946a <check_input_run+0x915a>
 1089456:	8d 73 ff             	lea    -0x1(%rbx),%esi
 1089459:	45 31 db             	xor    %r11d,%r11d
 108945c:	48 c1 e6 04          	shl    $0x4,%rsi
 1089460:	44 8b 04 32          	mov    (%rdx,%rsi,1),%r8d
 1089464:	48 8d 04 32          	lea    (%rdx,%rsi,1),%rax
 1089468:	eb 05                	jmp    108946f <check_input_run+0x915f>
 108946a:	31 c0                	xor    %eax,%eax
 108946c:	45 31 c0             	xor    %r8d,%r8d
 108946f:	4c 8b 4c 24 38       	mov    0x38(%rsp),%r9
 1089474:	44 39 d3             	cmp    %r10d,%ebx
 1089477:	73 13                	jae    108948c <check_input_run+0x917c>
 1089479:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
 108947e:	41 89 d9             	mov    %ebx,%r9d
 1089481:	49 c1 e1 04          	shl    $0x4,%r9
 1089485:	4c 03 8a 30 0c 00 00 	add    0xc30(%rdx),%r9
 108948c:	45 84 db             	test   %r11b,%r11b
 108948f:	74 0c                	je     108949d <check_input_run+0x918d>
 1089491:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
 1089495:	31 c0                	xor    %eax,%eax
 1089497:	c5 e9 ef d2          	vpxor  %xmm2,%xmm2,%xmm2
 108949b:	eb 4c                	jmp    10894e9 <check_input_run+0x91d9>
 108949d:	8b 50 04             	mov    0x4(%rax),%edx
 10894a0:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
 10894a5:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
 10894a9:	c5 e9 ef d2          	vpxor  %xmm2,%xmm2,%xmm2
 10894ad:	3b 96 18 0c 00 00    	cmp    0xc18(%rsi),%edx
 10894b3:	73 30                	jae    10894e5 <check_input_run+0x91d5>
 10894b5:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
 10894ba:	48 6b d2 38          	imul   $0x38,%rdx,%rdx
 10894be:	8b 70 08             	mov    0x8(%rax),%esi
 10894c1:	4c 8b 9f 10 0c 00 00 	mov    0xc10(%rdi),%r11
 10894c8:	48 89 df             	mov    %rbx,%rdi
 10894cb:	62 f2 7d 48 7c d6    	vpbroadcastd %esi,%zmm2
 10894d1:	41 8b 1c 13          	mov    (%r11,%rdx,1),%ebx
 10894d5:	29 f3                	sub    %esi,%ebx
 10894d7:	41 03 5c 13 04       	add    0x4(%r11,%rdx,1),%ebx
 10894dc:	62 f2 7d 48 7c cb    	vpbroadcastd %ebx,%zmm1
 10894e2:	48 89 fb             	mov    %rdi,%rbx
 10894e5:	0f b6 40 0c          	movzbl 0xc(%rax),%eax
 10894e9:	45 8b 09             	mov    (%r9),%r9d
 10894ec:	45 39 c8             	cmp    %r9d,%r8d
 10894ef:	0f 83 3e ff ff ff    	jae    1089433 <check_input_run+0x9123>
 10894f5:	62 f2 7d 48 7a d8    	vpbroadcastb %eax,%zmm3
 10894fb:	48 89 5c 24 40       	mov    %rbx,0x40(%rsp)
 1089500:	eb 1b                	jmp    108951d <check_input_run+0x920d>
 1089502:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1089509:	1f 84 00 00 00 00 00 
 1089510:	41 83 c0 40          	add    $0x40,%r8d
 1089514:	45 39 c8             	cmp    %r9d,%r8d
 1089517:	0f 83 05 ff ff ff    	jae    1089422 <check_input_run+0x9112>
 108951d:	44 89 c8             	mov    %r9d,%eax
 1089520:	44 29 c0             	sub    %r8d,%eax
 1089523:	ba 40 00 00 00       	mov    $0x40,%edx
 1089528:	45 89 c2             	mov    %r8d,%r10d
 108952b:	83 f8 40             	cmp    $0x40,%eax
 108952e:	0f 43 c2             	cmovae %edx,%eax
 1089531:	48 c7 c2 ff ff ff ff 	mov    $0xffffffffffffffff,%rdx
 1089538:	c4 e2 f8 f5 c2       	bzhi   %rax,%rdx,%rax
 108953d:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
 1089542:	c4 e1 fb 92 c8       	kmovq  %rax,%k1
 1089547:	48 89 c6             	mov    %rax,%rsi
 108954a:	48 c1 ee 20          	shr    $0x20,%rsi
 108954e:	48 8b 9a 28 08 00 00 	mov    0x828(%rdx),%rbx
 1089555:	4c 8b 9a 18 08 00 00 	mov    0x818(%rdx),%r11
 108955c:	89 c2                	mov    %eax,%edx
 108955e:	c1 ea 10             	shr    $0x10,%edx
 1089561:	c5 fb 92 d2          	kmovd  %edx,%k2
 1089565:	62 b1 7e ca 6f 6c 93 	vmovdqu32 0x40(%rbx,%r10,4),%zmm5{%k2}{z}
 108956c:	01 
 108956d:	62 b1 7e c9 6f 24 93 	vmovdqu32 (%rbx,%r10,4),%zmm4{%k1}{z}
 1089574:	c5 ec 4b d1          	kunpckwd %k1,%k2,%k2
 1089578:	62 f1 55 48 fa ea    	vpsubd %zmm2,%zmm5,%zmm5
 108957e:	62 f1 5d 48 fa e2    	vpsubd %zmm2,%zmm4,%zmm4
 1089584:	62 f3 5d 48 1e c1 01 	vpcmpltud %zmm1,%zmm4,%k0
 108958b:	62 f3 55 48 1e d9 01 	vpcmpltud %zmm1,%zmm5,%k3
 1089592:	c5 e4 4b c0          	kunpckwd %k0,%k3,%k0
 1089596:	c4 e1 fd 41 c2       	kandd  %k2,%k0,%k0
 108959b:	c5 fb 92 d6          	kmovd  %esi,%k2
 108959f:	62 b1 7e ca 6f 64 93 	vmovdqu32 0x80(%rbx,%r10,4),%zmm4{%k2}{z}
 10895a6:	02 
 10895a7:	c5 fb 93 d0          	kmovd  %k0,%edx
 10895ab:	62 f1 5d 48 fa e2    	vpsubd %zmm2,%zmm4,%zmm4
 10895b1:	62 f3 5d 4a 1e c1 01 	vpcmpltud %zmm1,%zmm4,%k0{%k2}
 10895b8:	c5 f8 93 f0          	kmovw  %k0,%esi
 10895bc:	48 c1 e6 20          	shl    $0x20,%rsi
 10895c0:	48 09 d6             	or     %rdx,%rsi
 10895c3:	48 89 c2             	mov    %rax,%rdx
 10895c6:	48 c1 ea 30          	shr    $0x30,%rdx
 10895ca:	c5 fb 92 d2          	kmovd  %edx,%k2
 10895ce:	62 b1 7e ca 6f 64 93 	vmovdqu32 0xc0(%rbx,%r10,4),%zmm4{%k2}{z}
 10895d5:	03 
 10895d6:	62 f1 5d 48 fa e2    	vpsubd %zmm2,%zmm4,%zmm4
 10895dc:	62 f3 5d 4a 1e c1 01 	vpcmpltud %zmm1,%zmm4,%k0{%k2}
 10895e3:	62 92 7d 49 26 14 13 	vptestmb (%r11,%r10,1),%zmm0,%k2{%k1}
 10895ea:	62 b1 7f 49 7f 5c 15 	vmovdqu8 %zmm3,0x0(%rbp,%r10,1){%k1}
 10895f1:	00 
 10895f2:	c5 fb 93 d0          	kmovd  %k0,%edx
 10895f6:	0f b7 d2             	movzwl %dx,%edx
 10895f9:	48 c1 e2 30          	shl    $0x30,%rdx
 10895fd:	48 09 f2             	or     %rsi,%rdx
 1089600:	c4 e1 fb 93 f2       	kmovq  %k2,%rsi
 1089605:	48 09 d6             	or     %rdx,%rsi
 1089608:	c4 62 c8 f2 d0       	andn   %rax,%rsi,%r10
 108960d:	75 29                	jne    1089638 <check_input_run+0x9328>
 108960f:	e9 fc fe ff ff       	jmp    1089510 <check_input_run+0x9200>
 1089614:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
 108961b:	00 00 00 00 00 
 1089620:	45 31 e4             	xor    %r12d,%r12d
 1089623:	46 88 64 1d 00       	mov    %r12b,0x0(%rbp,%r11,1)
 1089628:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
 108962d:	c4 c2 a8 f3 ca       	blsr   %r10,%r10
 1089632:	0f 84 d8 fe ff ff    	je     1089510 <check_input_run+0x9200>
 1089638:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
 108963d:	45 31 db             	xor    %r11d,%r11d
 1089640:	f3 4d 0f bc da       	tzcnt  %r10,%r11
 1089645:	45 01 c3             	add    %r8d,%r11d
 1089648:	48 8b 82 28 08 00 00 	mov    0x828(%rdx),%rax
 108964f:	42 8b 04 98          	mov    (%rax,%r11,4),%eax
 1089653:	85 c0                	test   %eax,%eax
 1089655:	74 c9                	je     1089620 <check_input_run+0x9310>
 1089657:	44 8b aa 18 0c 00 00 	mov    0xc18(%rdx),%r13d
 108965e:	41 83 fd 02          	cmp    $0x2,%r13d
 1089662:	72 4c                	jb     10896b0 <check_input_run+0x93a0>
 1089664:	4c 8b ba 10 0c 00 00 	mov    0xc10(%rdx),%r15
 108966b:	45 31 e4             	xor    %r12d,%r12d
 108966e:	44 89 ea             	mov    %r13d,%edx
 1089671:	44 89 eb             	mov    %r13d,%ebx
 1089674:	eb 17                	jmp    108968d <check_input_run+0x937d>
 1089676:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 108967d:	00 00 00 
 1089680:	41 89 d4             	mov    %edx,%r12d
 1089683:	89 da                	mov    %ebx,%edx
 1089685:	44 29 e2             	sub    %r12d,%edx
 1089688:	83 fa 01             	cmp    $0x1,%edx
 108968b:	76 3b                	jbe    10896c8 <check_input_run+0x93b8>
 108968d:	d1 ea                	shr    $1,%edx
 108968f:	44 01 e2             	add    %r12d,%edx
 1089692:	48 6b f2 38          	imul   $0x38,%rdx,%rsi
 1089696:	41 39 04 37          	cmp    %eax,(%r15,%rsi,1)
 108969a:	76 e4                	jbe    1089680 <check_input_run+0x9370>
 108969c:	89 d3                	mov    %edx,%ebx
 108969e:	89 da                	mov    %ebx,%edx
 10896a0:	44 29 e2             	sub    %r12d,%edx
 10896a3:	83 fa 01             	cmp    $0x1,%edx
 10896a6:	77 e5                	ja     108968d <check_input_run+0x937d>
 10896a8:	eb 1e                	jmp    10896c8 <check_input_run+0x93b8>
 10896aa:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
 10896b0:	45 31 e4             	xor    %r12d,%r12d
 10896b3:	45 85 ed             	test   %r13d,%r13d
 10896b6:	0f 84 67 ff ff ff    	je     1089623 <check_input_run+0x9313>
 10896bc:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
 10896c1:	4c 8b ba 10 0c 00 00 	mov    0xc10(%rdx),%r15
 10896c8:	44 89 e2             	mov    %r12d,%edx
 10896cb:	48 6b d2 38          	imul   $0x38,%rdx,%rdx
 10896cf:	89 c6                	mov    %eax,%esi
 10896d1:	41 2b 34 17          	sub    (%r15,%rdx,1),%esi
 10896d5:	0f 82 45 ff ff ff    	jb     1089620 <check_input_run+0x9310>
 10896db:	4c 01 fa             	add    %r15,%rdx
 10896de:	3b 72 04             	cmp    0x4(%rdx),%esi
 10896e1:	ba ff ff ff ff       	mov    $0xffffffff,%edx
 10896e6:	41 0f 42 d4          	cmovb  %r12d,%edx
 10896ea:	44 39 ea             	cmp    %r13d,%edx
 10896ed:	73 60                	jae    108974f <check_input_run+0x943f>
 10896ef:	89 d2                	mov    %edx,%edx
 10896f1:	48 6b d2 38          	imul   $0x38,%rdx,%rdx
 10896f5:	41 0f b6 5c 17 28    	movzbl 0x28(%r15,%rdx,1),%ebx
 10896fb:	41 8b 74 17 20       	mov    0x20(%r15,%rdx,1),%esi
 1089700:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
 1089705:	44 8b ba 28 0c 00 00 	mov    0xc28(%rdx),%r15d
 108970c:	44 39 fe             	cmp    %r15d,%esi
 108970f:	73 43                	jae    1089754 <check_input_run+0x9444>
 1089711:	48 8b 92 20 0c 00 00 	mov    0xc20(%rdx),%rdx
 1089718:	48 8d 34 b6          	lea    (%rsi,%rsi,4),%rsi
 108971c:	39 44 f2 04          	cmp    %eax,0x4(%rdx,%rsi,8)
 1089720:	77 32                	ja     1089754 <check_input_run+0x9444>
 1089722:	48 8d 1c f2          	lea    (%rdx,%rsi,8),%rbx
 1089726:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 108972d:	00 00 00 
 1089730:	48 89 de             	mov    %rbx,%rsi
 1089733:	8b 5b 1c             	mov    0x1c(%rbx),%ebx
 1089736:	44 39 fb             	cmp    %r15d,%ebx
 1089739:	73 0e                	jae    1089749 <check_input_run+0x9439>
 108973b:	48 8d 3c 9b          	lea    (%rbx,%rbx,4),%rdi
 108973f:	48 8d 1c fa          	lea    (%rdx,%rdi,8),%rbx
 1089743:	39 44 fa 04          	cmp    %eax,0x4(%rdx,%rdi,8)
 1089747:	76 e7                	jbe    1089730 <check_input_run+0x9420>
 1089749:	0f b6 5e 20          	movzbl 0x20(%rsi),%ebx
 108974d:	eb 05                	jmp    1089754 <check_input_run+0x9444>
 108974f:	31 db                	xor    %ebx,%ebx
 1089751:	41 89 d4             	mov    %edx,%r12d
 1089754:	45 39 ec             	cmp    %r13d,%r12d
 1089757:	44 0f b6 e3          	movzbl %bl,%r12d
 108975b:	44 0f 43 e1          	cmovae %ecx,%r12d
 108975f:	e9 bf fe ff ff       	jmp    1089623 <check_input_run+0x9313>
 1089764:	4c 8b 84 24 30 01 00 	mov    0x130(%rsp),%r8
 108976b:	00 
 108976c:	45 85 c0             	test   %r8d,%r8d
 108976f:	74 23                	je     1089794 <check_input_run+0x9484>
 1089771:	4c 8b 94 24 70 01 00 	mov    0x170(%rsp),%r10
 1089778:	00 
 1089779:	44 89 c0             	mov    %r8d,%eax
 108977c:	83 e0 07             	and    $0x7,%eax
 108977f:	41 83 f8 08          	cmp    $0x8,%r8d
 1089783:	73 1e                	jae    10897a3 <check_input_run+0x9493>
 1089785:	4c 8b 8c 24 a0 00 00 	mov    0xa0(%rsp),%r9
 108978c:	00 
 108978d:	31 c9                	xor    %ecx,%ecx
 108978f:	e9 b5 01 00 00       	jmp    1089949 <check_input_run+0x9639>
 1089794:	4c 8b 94 24 70 01 00 	mov    0x170(%rsp),%r10
 108979b:	00 
 108979c:	31 c0                	xor    %eax,%eax
 108979e:	e9 e6 01 00 00       	jmp    1089989 <check_input_run+0x9679>
 10897a3:	4c 8b 8c 24 a0 00 00 	mov    0xa0(%rsp),%r9
 10897aa:	00 
 10897ab:	44 89 c2             	mov    %r8d,%edx
 10897ae:	83 e2 f8             	and    $0xfffffff8,%edx
 10897b1:	31 c9                	xor    %ecx,%ecx
 10897b3:	eb 22                	jmp    10897d7 <check_input_run+0x94c7>
 10897b5:	0f b6 74 35 00       	movzbl 0x0(%rbp,%rsi,1),%esi
 10897ba:	40 fe ce             	dec    %sil
 10897bd:	40 80 fe 02          	cmp    $0x2,%sil
 10897c1:	40 0f 92 c6          	setb   %sil
 10897c5:	41 88 74 0a 07       	mov    %sil,0x7(%r10,%rcx,1)
 10897ca:	48 83 c1 08          	add    $0x8,%rcx
 10897ce:	48 39 ca             	cmp    %rcx,%rdx
 10897d1:	0f 84 6d 01 00 00    	je     1089944 <check_input_run+0x9634>
 10897d7:	49 8b 71 20          	mov    0x20(%r9),%rsi
 10897db:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
 10897e0:	8b 34 8e             	mov    (%rsi,%rcx,4),%esi
 10897e3:	3b b7 30 08 00 00    	cmp    0x830(%rdi),%esi
 10897e9:	73 12                	jae    10897fd <check_input_run+0x94ed>
 10897eb:	0f b6 74 35 00       	movzbl 0x0(%rbp,%rsi,1),%esi
 10897f0:	40 fe ce             	dec    %sil
 10897f3:	40 80 fe 02          	cmp    $0x2,%sil
 10897f7:	40 0f 92 c6          	setb   %sil
 10897fb:	eb 02                	jmp    10897ff <check_input_run+0x94ef>
 10897fd:	31 f6                	xor    %esi,%esi
 10897ff:	41 88 34 0a          	mov    %sil,(%r10,%rcx,1)
 1089803:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
 1089808:	49 8b 71 20          	mov    0x20(%r9),%rsi
 108980c:	8b 74 8e 04          	mov    0x4(%rsi,%rcx,4),%esi
 1089810:	3b b7 30 08 00 00    	cmp    0x830(%rdi),%esi
 1089816:	73 12                	jae    108982a <check_input_run+0x951a>
 1089818:	0f b6 74 35 00       	movzbl 0x0(%rbp,%rsi,1),%esi
 108981d:	40 fe ce             	dec    %sil
 1089820:	40 80 fe 02          	cmp    $0x2,%sil
 1089824:	40 0f 92 c6          	setb   %sil
 1089828:	eb 02                	jmp    108982c <check_input_run+0x951c>
 108982a:	31 f6                	xor    %esi,%esi
 108982c:	41 88 74 0a 01       	mov    %sil,0x1(%r10,%rcx,1)
 1089831:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
 1089836:	49 8b 71 20          	mov    0x20(%r9),%rsi
 108983a:	8b 74 8e 08          	mov    0x8(%rsi,%rcx,4),%esi
 108983e:	3b b7 30 08 00 00    	cmp    0x830(%rdi),%esi
 1089844:	73 12                	jae    1089858 <check_input_run+0x9548>
 1089846:	0f b6 74 35 00       	movzbl 0x0(%rbp,%rsi,1),%esi
 108984b:	40 fe ce             	dec    %sil
 108984e:	40 80 fe 02          	cmp    $0x2,%sil
 1089852:	40 0f 92 c6          	setb   %sil
 1089856:	eb 02                	jmp    108985a <check_input_run+0x954a>
 1089858:	31 f6                	xor    %esi,%esi
 108985a:	41 88 74 0a 02       	mov    %sil,0x2(%r10,%rcx,1)
 108985f:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
 1089864:	49 8b 71 20          	mov    0x20(%r9),%rsi
 1089868:	8b 74 8e 0c          	mov    0xc(%rsi,%rcx,4),%esi
 108986c:	3b b7 30 08 00 00    	cmp    0x830(%rdi),%esi
 1089872:	73 12                	jae    1089886 <check_input_run+0x9576>
 1089874:	0f b6 74 35 00       	movzbl 0x0(%rbp,%rsi,1),%esi
 1089879:	40 fe ce             	dec    %sil
 108987c:	40 80 fe 02          	cmp    $0x2,%sil
 1089880:	40 0f 92 c6          	setb   %sil
 1089884:	eb 02                	jmp    1089888 <check_input_run+0x9578>
 1089886:	31 f6                	xor    %esi,%esi
 1089888:	41 88 74 0a 03       	mov    %sil,0x3(%r10,%rcx,1)
 108988d:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
 1089892:	49 8b 71 20          	mov    0x20(%r9),%rsi
 1089896:	8b 74 8e 10          	mov    0x10(%rsi,%rcx,4),%esi
 108989a:	3b b7 30 08 00 00    	cmp    0x830(%rdi),%esi
 10898a0:	73 12                	jae    10898b4 <check_input_run+0x95a4>
 10898a2:	0f b6 74 35 00       	movzbl 0x0(%rbp,%rsi,1),%esi
 10898a7:	40 fe ce             	dec    %sil
 10898aa:	40 80 fe 02          	cmp    $0x2,%sil
 10898ae:	40 0f 92 c6          	setb   %sil
 10898b2:	eb 02                	jmp    10898b6 <check_input_run+0x95a6>
 10898b4:	31 f6                	xor    %esi,%esi
 10898b6:	41 88 74 0a 04       	mov    %sil,0x4(%r10,%rcx,1)
 10898bb:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
 10898c0:	49 8b 71 20          	mov    0x20(%r9),%rsi
 10898c4:	8b 74 8e 14          	mov    0x14(%rsi,%rcx,4),%esi
 10898c8:	3b b7 30 08 00 00    	cmp    0x830(%rdi),%esi
 10898ce:	73 12                	jae    10898e2 <check_input_run+0x95d2>
 10898d0:	0f b6 74 35 00       	movzbl 0x0(%rbp,%rsi,1),%esi
 10898d5:	40 fe ce             	dec    %sil
 10898d8:	40 80 fe 02          	cmp    $0x2,%sil
 10898dc:	40 0f 92 c6          	setb   %sil
 10898e0:	eb 02                	jmp    10898e4 <check_input_run+0x95d4>
 10898e2:	31 f6                	xor    %esi,%esi
 10898e4:	41 88 74 0a 05       	mov    %sil,0x5(%r10,%rcx,1)
 10898e9:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
 10898ee:	49 8b 71 20          	mov    0x20(%r9),%rsi
 10898f2:	8b 74 8e 18          	mov    0x18(%rsi,%rcx,4),%esi
 10898f6:	3b b7 30 08 00 00    	cmp    0x830(%rdi),%esi
 10898fc:	73 12                	jae    1089910 <check_input_run+0x9600>
 10898fe:	0f b6 74 35 00       	movzbl 0x0(%rbp,%rsi,1),%esi
 1089903:	40 fe ce             	dec    %sil
 1089906:	40 80 fe 02          	cmp    $0x2,%sil
 108990a:	40 0f 92 c6          	setb   %sil
 108990e:	eb 02                	jmp    1089912 <check_input_run+0x9602>
 1089910:	31 f6                	xor    %esi,%esi
 1089912:	41 88 74 0a 06       	mov    %sil,0x6(%r10,%rcx,1)
 1089917:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
 108991c:	49 8b 71 20          	mov    0x20(%r9),%rsi
 1089920:	8b 74 8e 1c          	mov    0x1c(%rsi,%rcx,4),%esi
 1089924:	3b b7 30 08 00 00    	cmp    0x830(%rdi),%esi
 108992a:	0f 82 85 fe ff ff    	jb     10897b5 <check_input_run+0x94a5>
 1089930:	31 f6                	xor    %esi,%esi
 1089932:	41 88 74 0a 07       	mov    %sil,0x7(%r10,%rcx,1)
 1089937:	48 83 c1 08          	add    $0x8,%rcx
 108993b:	48 39 ca             	cmp    %rcx,%rdx
 108993e:	0f 85 93 fe ff ff    	jne    10897d7 <check_input_run+0x94c7>
 1089944:	48 85 c0             	test   %rax,%rax
 1089947:	74 3d                	je     1089986 <check_input_run+0x9676>
 1089949:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
 108994e:	eb 19                	jmp    1089969 <check_input_run+0x9659>
 1089950:	0f b6 54 15 00       	movzbl 0x0(%rbp,%rdx,1),%edx
 1089955:	fe ca                	dec    %dl
 1089957:	80 fa 02             	cmp    $0x2,%dl
 108995a:	0f 92 c2             	setb   %dl
 108995d:	41 88 14 0a          	mov    %dl,(%r10,%rcx,1)
 1089961:	48 ff c1             	inc    %rcx
 1089964:	48 ff c8             	dec    %rax
 1089967:	74 1d                	je     1089986 <check_input_run+0x9676>
 1089969:	49 8b 51 20          	mov    0x20(%r9),%rdx
 108996d:	8b 14 8a             	mov    (%rdx,%rcx,4),%edx
 1089970:	3b 96 30 08 00 00    	cmp    0x830(%rsi),%edx
 1089976:	72 d8                	jb     1089950 <check_input_run+0x9640>
 1089978:	31 d2                	xor    %edx,%edx
 108997a:	41 88 14 0a          	mov    %dl,(%r10,%rcx,1)
 108997e:	48 ff c1             	inc    %rcx
 1089981:	48 ff c8             	dec    %rax
 1089984:	75 e3                	jne    1089969 <check_input_run+0x9659>
 1089986:	4c 89 c0             	mov    %r8,%rax
 1089989:	41 c6 04 02 00       	movb   $0x0,(%r10,%rax,1)
 108998e:	4d 89 56 58          	mov    %r10,0x58(%r14)
 1089992:	45 89 46 60          	mov    %r8d,0x60(%r14)
 1089996:	4c 8b 84 24 98 00 00 	mov    0x98(%rsp),%r8
 108999d:	00 
 108999e:	48 8b 84 24 88 02 00 	mov    0x288(%rsp),%rax
 10899a5:	00 
 10899a6:	4c 3b 40 08          	cmp    0x8(%rax),%r8
 10899aa:	0f 87 1a 1c 00 00    	ja     108b5ca <check_input_run+0xb2ba>
 10899b0:	4c 89 40 08          	mov    %r8,0x8(%rax)
 10899b4:	48 8b 9c 24 68 02 00 	mov    0x268(%rsp),%rbx
 10899bb:	00 
 10899bc:	8b 43 30             	mov    0x30(%rbx),%eax
 10899bf:	83 f8 03             	cmp    $0x3,%eax
 10899c2:	72 76                	jb     1089a3a <check_input_run+0x972a>
 10899c4:	bd fd ff ff ff       	mov    $0xfffffffd,%ebp
 10899c9:	45 31 f6             	xor    %r14d,%r14d
 10899cc:	eb 16                	jmp    10899e4 <check_input_run+0x96d4>
 10899ce:	66 90                	xchg   %ax,%ax
 10899d0:	49 8d 56 01          	lea    0x1(%r14),%rdx
 10899d4:	ff cd                	dec    %ebp
 10899d6:	49 83 c6 03          	add    $0x3,%r14
 10899da:	89 c1                	mov    %eax,%ecx
 10899dc:	49 39 ce             	cmp    %rcx,%r14
 10899df:	49 89 d6             	mov    %rdx,%r14
 10899e2:	73 56                	jae    1089a3a <check_input_run+0x972a>
 10899e4:	48 8b 4b 10          	mov    0x10(%rbx),%rcx
 10899e8:	42 80 3c 31 3c       	cmpb   $0x3c,(%rcx,%r14,1)
 10899ed:	75 e1                	jne    10899d0 <check_input_run+0x96c0>
 10899ef:	48 8b 4b 50          	mov    0x50(%rbx),%rcx
 10899f3:	42 80 7c 31 01 2a    	cmpb   $0x2a,0x1(%rcx,%r14,1)
 10899f9:	75 d5                	jne    10899d0 <check_input_run+0x96c0>
 10899fb:	42 80 7c 31 02 2d    	cmpb   $0x2d,0x2(%rcx,%r14,1)
 1089a01:	75 cd                	jne    10899d0 <check_input_run+0x96c0>
 1089a03:	48 8b 4b 60          	mov    0x60(%rbx),%rcx
 1089a07:	42 8b 54 b1 08       	mov    0x8(%rcx,%r14,4),%edx
 1089a0c:	39 c2                	cmp    %eax,%edx
 1089a0e:	73 c0                	jae    10899d0 <check_input_run+0x96c0>
 1089a10:	49 8d 4e 02          	lea    0x2(%r14),%rcx
 1089a14:	48 39 d1             	cmp    %rdx,%rcx
 1089a17:	73 b7                	jae    10899d0 <check_input_run+0x96c0>
 1089a19:	48 8b 84 24 98 03 00 	mov    0x398(%rsp),%rax
 1089a20:	00 
 1089a21:	01 ea                	add    %ebp,%edx
 1089a23:	be 01 00 00 00       	mov    $0x1,%esi
 1089a28:	4a 8d 7c 30 03       	lea    0x3(%rax,%r14,1),%rdi
 1089a2d:	c5 f8 77             	vzeroupper
 1089a30:	e8 4b 55 70 ff       	call   78ef80 <memset@plt>
 1089a35:	8b 43 30             	mov    0x30(%rbx),%eax
 1089a38:	eb 96                	jmp    10899d0 <check_input_run+0x96c0>
 1089a3a:	48 8d bc 24 60 02 00 	lea    0x260(%rsp),%rdi
 1089a41:	00 
 1089a42:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
 1089a47:	31 f6                	xor    %esi,%esi
 1089a49:	c5 f8 77             	vzeroupper
 1089a4c:	e8 3f 4a 00 00       	call   108e490 <check_input_resolve_range>
 1089a51:	48 8b bc 24 20 07 00 	mov    0x720(%rsp),%rdi
 1089a58:	00 
 1089a59:	48 85 ff             	test   %rdi,%rdi
 1089a5c:	74 1d                	je     1089a7b <check_input_run+0x976b>
 1089a5e:	48 8d b4 24 60 02 00 	lea    0x260(%rsp),%rsi
 1089a65:	00 
 1089a66:	e8 65 ae 00 00       	call   10948d0 <check_deferred_bodies>
 1089a6b:	48 8b 84 24 78 02 00 	mov    0x278(%rsp),%rax
 1089a72:	00 
 1089a73:	48 89 84 24 18 01 00 	mov    %rax,0x118(%rsp)
 1089a7a:	00 
 1089a7b:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 1089a80:	83 b8 30 02 00 00 00 	cmpl   $0x0,0x230(%rax)
 1089a87:	0f 85 aa 00 00 00    	jne    1089b37 <check_input_run+0x9827>
 1089a8d:	80 b8 bd 03 00 00 00 	cmpb   $0x0,0x3bd(%rax)
 1089a94:	0f 85 9d 00 00 00    	jne    1089b37 <check_input_run+0x9827>
 1089a9a:	4c 8b b4 24 68 02 00 	mov    0x268(%rsp),%r14
 1089aa1:	00 
 1089aa2:	48 8b 84 24 88 02 00 	mov    0x288(%rsp),%rax
 1089aa9:	00 
 1089aaa:	ba 01 00 00 00       	mov    $0x1,%edx
 1089aaf:	45 8b 6e 30          	mov    0x30(%r14),%r13d
 1089ab3:	4c 8b 40 08          	mov    0x8(%rax),%r8
 1089ab7:	4b 8d 4c 2d 00       	lea    0x0(%r13,%r13,1),%rcx
 1089abc:	48 89 d5             	mov    %rdx,%rbp
 1089abf:	48 01 d2             	add    %rdx,%rdx
 1089ac2:	48 39 cd             	cmp    %rcx,%rbp
 1089ac5:	76 f5                	jbe    1089abc <check_input_run+0x97ac>
 1089ac7:	48 89 e9             	mov    %rbp,%rcx
 1089aca:	48 c1 e9 3e          	shr    $0x3e,%rcx
 1089ace:	75 42                	jne    1089b12 <check_input_run+0x9802>
 1089ad0:	48 8b 30             	mov    (%rax),%rsi
 1089ad3:	4d 8d 7c 30 03       	lea    0x3(%r8,%rsi,1),%r15
 1089ad8:	49 8d 0c 30          	lea    (%r8,%rsi,1),%rcx
 1089adc:	49 83 e7 fc          	and    $0xfffffffffffffffc,%r15
 1089ae0:	49 39 cf             	cmp    %rcx,%r15
 1089ae3:	72 2d                	jb     1089b12 <check_input_run+0x9802>
 1089ae5:	4c 89 f9             	mov    %r15,%rcx
 1089ae8:	48 29 f1             	sub    %rsi,%rcx
 1089aeb:	48 8b 70 10          	mov    0x10(%rax),%rsi
 1089aef:	48 8d 14 ad 00 00 00 	lea    0x0(,%rbp,4),%rdx
 1089af6:	00 
 1089af7:	48 29 ce             	sub    %rcx,%rsi
 1089afa:	40 0f 92 c7          	setb   %dil
 1089afe:	48 39 f2             	cmp    %rsi,%rdx
 1089b01:	40 0f 97 c6          	seta   %sil
 1089b05:	40 08 fe             	or     %dil,%sil
 1089b08:	40 80 fe 01          	cmp    $0x1,%sil
 1089b0c:	0f 85 9c 02 00 00    	jne    1089dae <check_input_run+0x9a9e>
 1089b12:	48 8b 84 24 60 02 00 	mov    0x260(%rsp),%rax
 1089b19:	00 
 1089b1a:	c6 80 bd 03 00 00 01 	movb   $0x1,0x3bd(%rax)
 1089b21:	48 8b 84 24 88 02 00 	mov    0x288(%rsp),%rax
 1089b28:	00 
 1089b29:	4c 3b 40 08          	cmp    0x8(%rax),%r8
 1089b2d:	0f 87 97 1a 00 00    	ja     108b5ca <check_input_run+0xb2ba>
 1089b33:	4c 89 40 08          	mov    %r8,0x8(%rax)
 1089b37:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
 1089b3c:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 1089b41:	0f b6 80 bd 03 00 00 	movzbl 0x3bd(%rax),%eax
 1089b48:	84 c0                	test   %al,%al
 1089b4a:	0f 84 41 c3 ff ff    	je     1085e91 <check_input_run+0x5b81>
 1089b50:	e9 3b f7 ff ff       	jmp    1089290 <check_input_run+0x8f80>
 1089b55:	81 f9 30 01 00 00    	cmp    $0x130,%ecx
 1089b5b:	74 0c                	je     1089b69 <check_input_run+0x9859>
 1089b5d:	81 f9 33 01 00 00    	cmp    $0x133,%ecx
 1089b63:	0f 85 ae 06 00 00    	jne    108a217 <check_input_run+0x9f07>
 1089b69:	b8 01 00 00 00       	mov    $0x1,%eax
 1089b6e:	e9 9b e0 ff ff       	jmp    1087c0e <check_input_run+0x78fe>
 1089b73:	31 db                	xor    %ebx,%ebx
 1089b75:	e9 b3 a9 ff ff       	jmp    108452d <check_input_run+0x421d>
 1089b7a:	4c 8b 5c 24 38       	mov    0x38(%rsp),%r11
 1089b7f:	89 df                	mov    %ebx,%edi
 1089b81:	83 e7 fc             	and    $0xfffffffc,%edi
 1089b84:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1089b89:	31 d2                	xor    %edx,%edx
 1089b8b:	eb 19                	jmp    1089ba6 <check_input_run+0x9896>
 1089b8d:	41 89 74 93 0c       	mov    %esi,0xc(%r11,%rdx,4)
 1089b92:	8d 72 03             	lea    0x3(%rdx),%esi
 1089b95:	43 89 34 8b          	mov    %esi,(%r11,%r9,4)
 1089b99:	48 83 c2 04          	add    $0x4,%rdx
 1089b9d:	48 39 d7             	cmp    %rdx,%rdi
 1089ba0:	0f 84 1b 01 00 00    	je     1089cc1 <check_input_run+0x99b1>
 1089ba6:	4d 8b 4e 50          	mov    0x50(%r14),%r9
 1089baa:	4d 8b 46 60          	mov    0x60(%r14),%r8
 1089bae:	45 0f b6 0c 11       	movzbl (%r9,%rdx,1),%r9d
 1089bb3:	41 80 c1 de          	add    $0xde,%r9b
 1089bb7:	41 80 f9 18          	cmp    $0x18,%r9b
 1089bbb:	77 15                	ja     1089bd2 <check_input_run+0x98c2>
 1089bbd:	45 8b 0c 90          	mov    (%r8,%rdx,4),%r9d
 1089bc1:	41 39 d9             	cmp    %ebx,%r9d
 1089bc4:	73 0c                	jae    1089bd2 <check_input_run+0x98c2>
 1089bc6:	41 89 34 93          	mov    %esi,(%r11,%rdx,4)
 1089bca:	43 89 14 8b          	mov    %edx,(%r11,%r9,4)
 1089bce:	89 d6                	mov    %edx,%esi
 1089bd0:	eb 14                	jmp    1089be6 <check_input_run+0x98d6>
 1089bd2:	39 de                	cmp    %ebx,%esi
 1089bd4:	73 10                	jae    1089be6 <check_input_run+0x98d6>
 1089bd6:	41 89 f1             	mov    %esi,%r9d
 1089bd9:	47 8b 04 88          	mov    (%r8,%r9,4),%r8d
 1089bdd:	4c 39 c2             	cmp    %r8,%rdx
 1089be0:	75 04                	jne    1089be6 <check_input_run+0x98d6>
 1089be2:	43 8b 34 8b          	mov    (%r11,%r9,4),%esi
 1089be6:	4d 8b 4e 50          	mov    0x50(%r14),%r9
 1089bea:	4d 8b 46 60          	mov    0x60(%r14),%r8
 1089bee:	45 0f b6 4c 11 01    	movzbl 0x1(%r9,%rdx,1),%r9d
 1089bf4:	41 80 c1 de          	add    $0xde,%r9b
 1089bf8:	41 80 f9 18          	cmp    $0x18,%r9b
 1089bfc:	77 18                	ja     1089c16 <check_input_run+0x9906>
 1089bfe:	45 8b 4c 90 04       	mov    0x4(%r8,%rdx,4),%r9d
 1089c03:	41 39 d9             	cmp    %ebx,%r9d
 1089c06:	73 0e                	jae    1089c16 <check_input_run+0x9906>
 1089c08:	41 89 74 93 04       	mov    %esi,0x4(%r11,%rdx,4)
 1089c0d:	8d 72 01             	lea    0x1(%rdx),%esi
 1089c10:	43 89 34 8b          	mov    %esi,(%r11,%r9,4)
 1089c14:	eb 18                	jmp    1089c2e <check_input_run+0x991e>
 1089c16:	39 de                	cmp    %ebx,%esi
 1089c18:	73 14                	jae    1089c2e <check_input_run+0x991e>
 1089c1a:	41 89 f1             	mov    %esi,%r9d
 1089c1d:	47 8b 04 88          	mov    (%r8,%r9,4),%r8d
 1089c21:	4c 8d 52 01          	lea    0x1(%rdx),%r10
 1089c25:	4d 39 c2             	cmp    %r8,%r10
 1089c28:	75 04                	jne    1089c2e <check_input_run+0x991e>
 1089c2a:	43 8b 34 8b          	mov    (%r11,%r9,4),%esi
 1089c2e:	4d 8b 4e 50          	mov    0x50(%r14),%r9
 1089c32:	4d 8b 46 60          	mov    0x60(%r14),%r8
 1089c36:	45 0f b6 4c 11 02    	movzbl 0x2(%r9,%rdx,1),%r9d
 1089c3c:	41 80 c1 de          	add    $0xde,%r9b
 1089c40:	41 80 f9 18          	cmp    $0x18,%r9b
 1089c44:	77 18                	ja     1089c5e <check_input_run+0x994e>
 1089c46:	45 8b 4c 90 08       	mov    0x8(%r8,%rdx,4),%r9d
 1089c4b:	41 39 d9             	cmp    %ebx,%r9d
 1089c4e:	73 0e                	jae    1089c5e <check_input_run+0x994e>
 1089c50:	41 89 74 93 08       	mov    %esi,0x8(%r11,%rdx,4)
 1089c55:	8d 72 02             	lea    0x2(%rdx),%esi
 1089c58:	43 89 34 8b          	mov    %esi,(%r11,%r9,4)
 1089c5c:	eb 18                	jmp    1089c76 <check_input_run+0x9966>
 1089c5e:	39 de                	cmp    %ebx,%esi
 1089c60:	73 14                	jae    1089c76 <check_input_run+0x9966>
 1089c62:	41 89 f1             	mov    %esi,%r9d
 1089c65:	47 8b 04 88          	mov    (%r8,%r9,4),%r8d
 1089c69:	4c 8d 52 02          	lea    0x2(%rdx),%r10
 1089c6d:	4d 39 c2             	cmp    %r8,%r10
 1089c70:	75 04                	jne    1089c76 <check_input_run+0x9966>
 1089c72:	43 8b 34 8b          	mov    (%r11,%r9,4),%esi
 1089c76:	4d 8b 4e 50          	mov    0x50(%r14),%r9
 1089c7a:	4d 8b 46 60          	mov    0x60(%r14),%r8
 1089c7e:	45 0f b6 4c 11 03    	movzbl 0x3(%r9,%rdx,1),%r9d
 1089c84:	41 80 c1 de          	add    $0xde,%r9b
 1089c88:	41 80 f9 18          	cmp    $0x18,%r9b
 1089c8c:	77 0e                	ja     1089c9c <check_input_run+0x998c>
 1089c8e:	45 8b 4c 90 0c       	mov    0xc(%r8,%rdx,4),%r9d
 1089c93:	41 39 d9             	cmp    %ebx,%r9d
 1089c96:	0f 82 f1 fe ff ff    	jb     1089b8d <check_input_run+0x987d>
 1089c9c:	39 de                	cmp    %ebx,%esi
 1089c9e:	0f 83 f5 fe ff ff    	jae    1089b99 <check_input_run+0x9889>
 1089ca4:	41 89 f1             	mov    %esi,%r9d
 1089ca7:	47 8b 04 88          	mov    (%r8,%r9,4),%r8d
 1089cab:	4c 8d 52 03          	lea    0x3(%rdx),%r10
 1089caf:	4d 39 c2             	cmp    %r8,%r10
 1089cb2:	0f 85 e1 fe ff ff    	jne    1089b99 <check_input_run+0x9889>
 1089cb8:	43 8b 34 8b          	mov    (%r11,%r9,4),%esi
 1089cbc:	e9 d8 fe ff ff       	jmp    1089b99 <check_input_run+0x9889>
 1089cc1:	48 85 c9             	test   %rcx,%rcx
 1089cc4:	0f 85 ae 00 00 00    	jne    1089d78 <check_input_run+0x9a68>
 1089cca:	48 89 d9             	mov    %rbx,%rcx
 1089ccd:	f6 c3 01             	test   $0x1,%bl
 1089cd0:	0f 84 25 0f 00 00    	je     108abfb <check_input_run+0xa8eb>
 1089cd6:	49 8b 4e 68          	mov    0x68(%r14),%rcx
 1089cda:	49 8b 7e 50          	mov    0x50(%r14),%rdi
 1089cde:	49 8b 56 60          	mov    0x60(%r14),%rdx
 1089ce2:	8b 4c 99 fc          	mov    -0x4(%rcx,%rbx,4),%ecx
 1089ce6:	44 0f b6 04 0f       	movzbl (%rdi,%rcx,1),%r8d
 1089ceb:	8b 34 8a             	mov    (%rdx,%rcx,4),%esi
 1089cee:	b2 01                	mov    $0x1,%dl
 1089cf0:	45 8d 48 bf          	lea    -0x41(%r8),%r9d
 1089cf4:	41 83 f9 0e          	cmp    $0xe,%r9d
 1089cf8:	77 10                	ja     1089d0a <check_input_run+0x99fa>
 1089cfa:	41 ba 05 60 00 00    	mov    $0x6005,%r10d
 1089d00:	45 0f a3 ca          	bt     %r9d,%r10d
 1089d04:	0f 82 e9 0e 00 00    	jb     108abf3 <check_input_run+0xa8e3>
 1089d0a:	41 83 c0 f9          	add    $0xfffffff9,%r8d
 1089d0e:	41 83 f8 02          	cmp    $0x2,%r8d
 1089d12:	0f 82 db 0e 00 00    	jb     108abf3 <check_input_run+0xa8e3>
 1089d18:	39 de                	cmp    %ebx,%esi
 1089d1a:	0f 83 cc 0e 00 00    	jae    108abec <check_input_run+0xa8dc>
 1089d20:	41 80 7c 35 00 00    	cmpb   $0x0,0x0(%r13,%rsi,1)
 1089d26:	0f 84 c0 0e 00 00    	je     108abec <check_input_run+0xa8dc>
 1089d2c:	0f b6 3c 37          	movzbl (%rdi,%rsi,1),%edi
 1089d30:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
 1089d35:	4c 8b 4c 24 38       	mov    0x38(%rsp),%r9
 1089d3a:	83 c7 f9             	add    $0xfffffff9,%edi
 1089d3d:	83 ff 44             	cmp    $0x44,%edi
 1089d40:	0f 87 ab 0e 00 00    	ja     108abf1 <check_input_run+0xa8e1>
 1089d46:	4c 8d 05 8f 45 41 ff 	lea    -0xbeba71(%rip),%r8        # 49e2dc <cbuiltin_test_generated.edges+0x3b5c>
 1089d4d:	49 63 3c b8          	movslq (%r8,%rdi,4),%rdi
 1089d51:	4c 01 c7             	add    %r8,%rdi
 1089d54:	ff e7                	jmp    *%rdi
 1089d56:	41 3b 0c b1          	cmp    (%r9,%rsi,4),%ecx
 1089d5a:	0f 92 c2             	setb   %dl
 1089d5d:	e9 91 0e 00 00       	jmp    108abf3 <check_input_run+0xa8e3>
 1089d62:	41 89 34 93          	mov    %esi,(%r11,%rdx,4)
 1089d66:	89 d6                	mov    %edx,%esi
 1089d68:	43 89 14 83          	mov    %edx,(%r11,%r8,4)
 1089d6c:	48 ff c2             	inc    %rdx
 1089d6f:	48 ff c9             	dec    %rcx
 1089d72:	0f 84 52 ff ff ff    	je     1089cca <check_input_run+0x99ba>
 1089d78:	4d 8b 46 50          	mov    0x50(%r14),%r8
 1089d7c:	49 8b 7e 60          	mov    0x60(%r14),%rdi
 1089d80:	45 0f b6 04 10       	movzbl (%r8,%rdx,1),%r8d
 1089d85:	41 80 c0 de          	add    $0xde,%r8b
 1089d89:	41 80 f8 18          	cmp    $0x18,%r8b
 1089d8d:	77 09                	ja     1089d98 <check_input_run+0x9a88>
 1089d8f:	44 8b 04 97          	mov    (%rdi,%rdx,4),%r8d
 1089d93:	41 39 d8             	cmp    %ebx,%r8d
 1089d96:	72 ca                	jb     1089d62 <check_input_run+0x9a52>
 1089d98:	39 de                	cmp    %ebx,%esi
 1089d9a:	73 d0                	jae    1089d6c <check_input_run+0x9a5c>
 1089d9c:	41 89 f0             	mov    %esi,%r8d
 1089d9f:	42 8b 3c 87          	mov    (%rdi,%r8,4),%edi
 1089da3:	48 39 fa             	cmp    %rdi,%rdx
 1089da6:	75 c4                	jne    1089d6c <check_input_run+0x9a5c>
 1089da8:	43 8b 34 83          	mov    (%r11,%r8,4),%esi
 1089dac:	eb be                	jmp    1089d6c <check_input_run+0x9a5c>
 1089dae:	48 01 d1             	add    %rdx,%rcx
 1089db1:	4d 85 ff             	test   %r15,%r15
 1089db4:	48 89 48 08          	mov    %rcx,0x8(%rax)
 1089db8:	0f 94 c0             	sete   %al
 1089dbb:	48 8b 8c 24 60 02 00 	mov    0x260(%rsp),%rcx
 1089dc2:	00 
 1089dc3:	08 81 bd 03 00 00    	or     %al,0x3bd(%rcx)
 1089dc9:	4d 85 ff             	test   %r15,%r15
 1089dcc:	0f 84 4f fd ff ff    	je     1089b21 <check_input_run+0x9811>
 1089dd2:	4c 89 44 24 68       	mov    %r8,0x68(%rsp)
 1089dd7:	31 db                	xor    %ebx,%ebx
 1089dd9:	4c 89 ff             	mov    %r15,%rdi
 1089ddc:	31 f6                	xor    %esi,%esi
 1089dde:	e8 9d 51 70 ff       	call   78ef80 <memset@plt>
 1089de3:	4d 85 ed             	test   %r13,%r13
 1089de6:	0f 84 26 08 00 00    	je     108a612 <check_input_run+0xa302>
 1089dec:	48 ff cd             	dec    %rbp
 1089def:	41 ba ff ff ff ff    	mov    $0xffffffff,%r10d
 1089df5:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1089dfa:	31 d2                	xor    %edx,%edx
 1089dfc:	4c 89 74 24 38       	mov    %r14,0x38(%rsp)
 1089e01:	4c 89 7c 24 40       	mov    %r15,0x40(%rsp)
 1089e06:	eb 0e                	jmp    1089e16 <check_input_run+0x9b06>
 1089e08:	89 d6                	mov    %edx,%esi
 1089e0a:	48 ff c2             	inc    %rdx
 1089e0d:	4c 39 ea             	cmp    %r13,%rdx
 1089e10:	0f 84 6a 04 00 00    	je     108a280 <check_input_run+0x9f70>
 1089e16:	48 8b bc 24 60 02 00 	mov    0x260(%rsp),%rdi
 1089e1d:	00 
 1089e1e:	48 8b 87 f0 01 00 00 	mov    0x1f0(%rdi),%rax
 1089e25:	48 85 c0             	test   %rax,%rax
 1089e28:	74 06                	je     1089e30 <check_input_run+0x9b20>
 1089e2a:	80 3c 10 00          	cmpb   $0x0,(%rax,%rdx,1)
 1089e2e:	75 da                	jne    1089e0a <check_input_run+0x9afa>
 1089e30:	4d 8b 4e 10          	mov    0x10(%r14),%r9
 1089e34:	4d 8b 5e 50          	mov    0x50(%r14),%r11
 1089e38:	89 d9                	mov    %ebx,%ecx
 1089e3a:	48 39 ca             	cmp    %rcx,%rdx
 1089e3d:	41 0f 47 f2          	cmova  %r10d,%esi
 1089e41:	41 0f b6 04 13       	movzbl (%r11,%rdx,1),%eax
 1089e46:	45 0f b6 04 11       	movzbl (%r9,%rdx,1),%r8d
 1089e4b:	83 f8 34             	cmp    $0x34,%eax
 1089e4e:	0f 84 f3 00 00 00    	je     1089f47 <check_input_run+0x9c37>
 1089e54:	83 f8 21             	cmp    $0x21,%eax
 1089e57:	0f 85 15 01 00 00    	jne    1089f72 <check_input_run+0x9c62>
 1089e5d:	83 fe ff             	cmp    $0xffffffff,%esi
 1089e60:	0f 84 26 01 00 00    	je     1089f8c <check_input_run+0x9c7c>
 1089e66:	48 8b 84 24 d0 05 00 	mov    0x5d0(%rsp),%rax
 1089e6d:	00 
 1089e6e:	8b 04 90             	mov    (%rax,%rdx,4),%eax
 1089e71:	44 39 e8             	cmp    %r13d,%eax
 1089e74:	0f 83 12 01 00 00    	jae    1089f8c <check_input_run+0x9c7c>
 1089e7a:	41 80 3c 01 02       	cmpb   $0x2,(%r9,%rax,1)
 1089e7f:	0f 85 07 01 00 00    	jne    1089f8c <check_input_run+0x9c7c>
 1089e85:	48 8b 8f e0 02 00 00 	mov    0x2e0(%rdi),%rcx
 1089e8c:	89 f7                	mov    %esi,%edi
 1089e8e:	89 34 91             	mov    %esi,(%rcx,%rdx,4)
 1089e91:	48 b9 15 7c 4a 7f b9 	movabs $0x9e3779b97f4a7c15,%rcx
 1089e98:	79 37 9e 
 1089e9b:	4d 8b 46 18          	mov    0x18(%r14),%r8
 1089e9f:	45 8b 0c 80          	mov    (%r8,%rax,4),%r9d
 1089ea3:	4c 89 c8             	mov    %r9,%rax
 1089ea6:	48 0f af c1          	imul   %rcx,%rax
 1089eaa:	48 01 c7             	add    %rax,%rdi
 1089ead:	48 21 ef             	and    %rbp,%rdi
 1089eb0:	45 8b 1c bf          	mov    (%r15,%rdi,4),%r11d
 1089eb4:	45 85 db             	test   %r11d,%r11d
 1089eb7:	0f 84 96 02 00 00    	je     108a153 <check_input_run+0x9e43>
 1089ebd:	48 8b 84 24 60 02 00 	mov    0x260(%rsp),%rax
 1089ec4:	00 
 1089ec5:	4c 8b 90 e0 02 00 00 	mov    0x2e0(%rax),%r10
 1089ecc:	eb 13                	jmp    1089ee1 <check_input_run+0x9bd1>
 1089ece:	48 ff c7             	inc    %rdi
 1089ed1:	48 21 ef             	and    %rbp,%rdi
 1089ed4:	45 8b 1c bf          	mov    (%r15,%rdi,4),%r11d
 1089ed8:	45 85 db             	test   %r11d,%r11d
 1089edb:	0f 84 72 02 00 00    	je     108a153 <check_input_run+0x9e43>
 1089ee1:	41 ff cb             	dec    %r11d
 1089ee4:	43 39 34 9a          	cmp    %esi,(%r10,%r11,4)
 1089ee8:	75 e4                	jne    1089ece <check_input_run+0x9bbe>
 1089eea:	48 8b 8c 24 d0 05 00 	mov    0x5d0(%rsp),%rcx
 1089ef1:	00 
 1089ef2:	42 8b 0c 99          	mov    (%rcx,%r11,4),%ecx
 1089ef6:	45 39 0c 88          	cmp    %r9d,(%r8,%rcx,4)
 1089efa:	75 d2                	jne    1089ece <check_input_run+0x9bbe>
 1089efc:	8b 88 30 02 00 00    	mov    0x230(%rax),%ecx
 1089f02:	3b 88 34 02 00 00    	cmp    0x234(%rax),%ecx
 1089f08:	0f 83 2f 02 00 00    	jae    108a13d <check_input_run+0x9e2d>
 1089f0e:	44 0f b6 80 bd 03 00 	movzbl 0x3bd(%rax),%r8d
 1089f15:	00 
 1089f16:	4c 8b 88 28 02 00 00 	mov    0x228(%rax),%r9
 1089f1d:	44 8d 51 01          	lea    0x1(%rcx),%r10d
 1089f21:	44 89 90 30 02 00 00 	mov    %r10d,0x230(%rax)
 1089f28:	48 8d 04 49          	lea    (%rcx,%rcx,2),%rax
 1089f2c:	41 83 f0 05          	xor    $0x5,%r8d
 1089f30:	41 89 14 81          	mov    %edx,(%r9,%rax,4)
 1089f34:	45 89 44 81 04       	mov    %r8d,0x4(%r9,%rax,4)
 1089f39:	41 c7 44 81 08 00 00 	movl   $0x0,0x8(%r9,%rax,4)
 1089f40:	00 00 
 1089f42:	e9 fd 01 00 00       	jmp    108a144 <check_input_run+0x9e34>
 1089f47:	49 8b 46 60          	mov    0x60(%r14),%rax
 1089f4b:	8b 1c 90             	mov    (%rax,%rdx,4),%ebx
 1089f4e:	41 80 f8 4f          	cmp    $0x4f,%r8b
 1089f52:	0f 85 b0 fe ff ff    	jne    1089e08 <check_input_run+0x9af8>
 1089f58:	48 8b 87 48 03 00 00 	mov    0x348(%rdi),%rax
 1089f5f:	89 d6                	mov    %edx,%esi
 1089f61:	83 3c 90 00          	cmpl   $0x0,(%rax,%rdx,4)
 1089f65:	89 d0                	mov    %edx,%eax
 1089f67:	0f 85 9d fe ff ff    	jne    1089e0a <check_input_run+0x9afa>
 1089f6d:	e9 87 01 00 00       	jmp    108a0f9 <check_input_run+0x9de9>
 1089f72:	41 80 f8 4f          	cmp    $0x4f,%r8b
 1089f76:	75 5e                	jne    1089fd6 <check_input_run+0x9cc6>
 1089f78:	48 8b 8f 48 03 00 00 	mov    0x348(%rdi),%rcx
 1089f7f:	83 3c 91 00          	cmpl   $0x0,(%rcx,%rdx,4)
 1089f83:	75 5a                	jne    1089fdf <check_input_run+0x9ccf>
 1089f85:	89 f0                	mov    %esi,%eax
 1089f87:	e9 6d 01 00 00       	jmp    108a0f9 <check_input_run+0x9de9>
 1089f8c:	8b 87 30 02 00 00    	mov    0x230(%rdi),%eax
 1089f92:	3b 87 34 02 00 00    	cmp    0x234(%rdi),%eax
 1089f98:	0f 83 43 01 00 00    	jae    108a0e1 <check_input_run+0x9dd1>
 1089f9e:	0f b6 8f bd 03 00 00 	movzbl 0x3bd(%rdi),%ecx
 1089fa5:	4c 8b 87 28 02 00 00 	mov    0x228(%rdi),%r8
 1089fac:	44 8d 48 01          	lea    0x1(%rax),%r9d
 1089fb0:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
 1089fb4:	44 89 8f 30 02 00 00 	mov    %r9d,0x230(%rdi)
 1089fbb:	8d 4c 49 01          	lea    0x1(%rcx,%rcx,2),%ecx
 1089fbf:	41 89 14 80          	mov    %edx,(%r8,%rax,4)
 1089fc3:	41 89 4c 80 04       	mov    %ecx,0x4(%r8,%rax,4)
 1089fc8:	41 c7 44 80 08 00 00 	movl   $0x0,0x8(%r8,%rax,4)
 1089fcf:	00 00 
 1089fd1:	e9 34 fe ff ff       	jmp    1089e0a <check_input_run+0x9afa>
 1089fd6:	83 f8 09             	cmp    $0x9,%eax
 1089fd9:	0f 84 0e 01 00 00    	je     108a0ed <check_input_run+0x9ddd>
 1089fdf:	83 f8 3a             	cmp    $0x3a,%eax
 1089fe2:	0f 85 22 fe ff ff    	jne    1089e0a <check_input_run+0x9afa>
 1089fe8:	49 8b 46 60          	mov    0x60(%r14),%rax
 1089fec:	44 8b 04 90          	mov    (%rax,%rdx,4),%r8d
 1089ff0:	4c 89 44 24 60       	mov    %r8,0x60(%rsp)
 1089ff5:	45 39 e8             	cmp    %r13d,%r8d
 1089ff8:	0f 83 a0 00 00 00    	jae    108a09e <check_input_run+0x9d8e>
 1089ffe:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
 108a003:	44 8b 14 88          	mov    (%rax,%rcx,4),%r10d
 108a007:	45 39 ea             	cmp    %r13d,%r10d
 108a00a:	73 2d                	jae    108a039 <check_input_run+0x9d29>
 108a00c:	4c 8b a4 24 d0 05 00 	mov    0x5d0(%rsp),%r12
 108a013:	00 
 108a014:	eb 09                	jmp    108a01f <check_input_run+0x9d0f>
 108a016:	44 8b 14 88          	mov    (%rax,%rcx,4),%r10d
 108a01a:	45 39 ea             	cmp    %r13d,%r10d
 108a01d:	73 1a                	jae    108a039 <check_input_run+0x9d29>
 108a01f:	44 89 d1             	mov    %r10d,%ecx
 108a022:	41 80 3c 0b 49       	cmpb   $0x49,(%r11,%rcx,1)
 108a027:	75 ed                	jne    108a016 <check_input_run+0x9d06>
 108a029:	45 8b 04 8c          	mov    (%r12,%rcx,4),%r8d
 108a02d:	45 39 e8             	cmp    %r13d,%r8d
 108a030:	73 e4                	jae    108a016 <check_input_run+0x9d06>
 108a032:	43 80 3c 01 49       	cmpb   $0x49,(%r9,%r8,1)
 108a037:	75 dd                	jne    108a016 <check_input_run+0x9d06>
 108a039:	45 39 ea             	cmp    %r13d,%r10d
 108a03c:	73 60                	jae    108a09e <check_input_run+0x9d8e>
 108a03e:	48 8b 84 24 68 02 00 	mov    0x268(%rsp),%rax
 108a045:	00 
 108a046:	44 8b 48 30          	mov    0x30(%rax),%r9d
 108a04a:	44 39 4c 24 60       	cmp    %r9d,0x60(%rsp)
 108a04f:	0f 83 be 00 00 00    	jae    108a113 <check_input_run+0x9e03>
 108a055:	4c 8b 9f 18 03 00 00 	mov    0x318(%rdi),%r11
 108a05c:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
 108a061:	eb 11                	jmp    108a074 <check_input_run+0x9d64>
 108a063:	48 8b 48 60          	mov    0x60(%rax),%rcx
 108a067:	42 8b 0c a1          	mov    (%rcx,%r12,4),%ecx
 108a06b:	44 39 c9             	cmp    %r9d,%ecx
 108a06e:	0f 83 9f 00 00 00    	jae    108a113 <check_input_run+0x9e03>
 108a074:	41 89 cc             	mov    %ecx,%r12d
 108a077:	47 8b 04 a3          	mov    (%r11,%r12,4),%r8d
 108a07b:	45 85 c0             	test   %r8d,%r8d
 108a07e:	74 e3                	je     108a063 <check_input_run+0x9d53>
 108a080:	48 8b 8f 10 03 00 00 	mov    0x310(%rdi),%rcx
 108a087:	41 ff c8             	dec    %r8d
 108a08a:	4f 8d 04 40          	lea    (%r8,%r8,2),%r8
 108a08e:	46 3b 14 c1          	cmp    (%rcx,%r8,8),%r10d
 108a092:	76 0a                	jbe    108a09e <check_input_run+0x9d8e>
 108a094:	4a 8d 0c c1          	lea    (%rcx,%r8,8),%rcx
 108a098:	44 3b 51 04          	cmp    0x4(%rcx),%r10d
 108a09c:	72 c5                	jb     108a063 <check_input_run+0x9d53>
 108a09e:	8b 87 30 02 00 00    	mov    0x230(%rdi),%eax
 108a0a4:	3b 87 34 02 00 00    	cmp    0x234(%rdi),%eax
 108a0aa:	73 5e                	jae    108a10a <check_input_run+0x9dfa>
 108a0ac:	0f b6 8f bd 03 00 00 	movzbl 0x3bd(%rdi),%ecx
 108a0b3:	4c 8b 87 28 02 00 00 	mov    0x228(%rdi),%r8
 108a0ba:	44 8d 48 01          	lea    0x1(%rax),%r9d
 108a0be:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
 108a0c2:	44 89 8f 30 02 00 00 	mov    %r9d,0x230(%rdi)
 108a0c9:	8d 4c 49 01          	lea    0x1(%rcx,%rcx,2),%ecx
 108a0cd:	41 89 14 80          	mov    %edx,(%r8,%rax,4)
 108a0d1:	41 89 4c 80 04       	mov    %ecx,0x4(%r8,%rax,4)
 108a0d6:	41 c7 44 80 08 00 00 	movl   $0x0,0x8(%r8,%rax,4)
 108a0dd:	00 00 
 108a0df:	eb 55                	jmp    108a136 <check_input_run+0x9e26>
 108a0e1:	c6 87 bd 03 00 00 01 	movb   $0x1,0x3bd(%rdi)
 108a0e8:	e9 1d fd ff ff       	jmp    1089e0a <check_input_run+0x9afa>
 108a0ed:	89 f0                	mov    %esi,%eax
 108a0ef:	41 80 f8 0f          	cmp    $0xf,%r8b
 108a0f3:	0f 85 11 fd ff ff    	jne    1089e0a <check_input_run+0x9afa>
 108a0f9:	48 8b 8f e0 02 00 00 	mov    0x2e0(%rdi),%rcx
 108a100:	89 c6                	mov    %eax,%esi
 108a102:	89 04 91             	mov    %eax,(%rcx,%rdx,4)
 108a105:	e9 00 fd ff ff       	jmp    1089e0a <check_input_run+0x9afa>
 108a10a:	c6 87 bd 03 00 00 01 	movb   $0x1,0x3bd(%rdi)
 108a111:	eb 23                	jmp    108a136 <check_input_run+0x9e26>
 108a113:	48 8b 87 f8 02 00 00 	mov    0x2f8(%rdi),%rax
 108a11a:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
 108a11f:	44 89 14 90          	mov    %r10d,(%rax,%rdx,4)
 108a123:	48 8b 84 24 60 02 00 	mov    0x260(%rsp),%rax
 108a12a:	00 
 108a12b:	48 8b 80 f8 02 00 00 	mov    0x2f8(%rax),%rax
 108a132:	44 89 14 88          	mov    %r10d,(%rax,%rcx,4)
 108a136:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
 108a13b:	eb 1d                	jmp    108a15a <check_input_run+0x9e4a>
 108a13d:	c6 80 bd 03 00 00 01 	movb   $0x1,0x3bd(%rax)
 108a144:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
 108a149:	4c 8b 74 24 38       	mov    0x38(%rsp),%r14
 108a14e:	4c 8b 7c 24 40       	mov    0x40(%rsp),%r15
 108a153:	8d 42 01             	lea    0x1(%rdx),%eax
 108a156:	41 89 04 bf          	mov    %eax,(%r15,%rdi,4)
 108a15a:	41 ba ff ff ff ff    	mov    $0xffffffff,%r10d
 108a160:	e9 a5 fc ff ff       	jmp    1089e0a <check_input_run+0x9afa>
 108a165:	48 89 ca             	mov    %rcx,%rdx
 108a168:	48 29 f2             	sub    %rsi,%rdx
 108a16b:	49 8b 70 10          	mov    0x10(%r8),%rsi
 108a16f:	48 29 d6             	sub    %rdx,%rsi
 108a172:	0f 82 bf 00 00 00    	jb     108a237 <check_input_run+0x9f27>
 108a178:	48 39 f0             	cmp    %rsi,%rax
 108a17b:	0f 87 b6 00 00 00    	ja     108a237 <check_input_run+0x9f27>
 108a181:	48 8b 34 24          	mov    (%rsp),%rsi
 108a185:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
 108a18a:	48 01 c2             	add    %rax,%rdx
 108a18d:	48 89 56 08          	mov    %rdx,0x8(%rsi)
 108a191:	48 89 8f 40 02 00 00 	mov    %rcx,0x240(%rdi)
 108a198:	48 85 c9             	test   %rcx,%rcx
 108a19b:	0f 84 15 09 00 00    	je     108aab6 <check_input_run+0xa7a6>
 108a1a1:	48 8b 4e 08          	mov    0x8(%rsi),%rcx
 108a1a5:	48 8b 56 10          	mov    0x10(%rsi),%rdx
 108a1a9:	48 29 ca             	sub    %rcx,%rdx
 108a1ac:	40 0f 92 c6          	setb   %sil
 108a1b0:	48 3b 54 24 58       	cmp    0x58(%rsp),%rdx
 108a1b5:	0f 96 c2             	setbe  %dl
 108a1b8:	40 08 f2             	or     %sil,%dl
 108a1bb:	80 fa 01             	cmp    $0x1,%dl
 108a1be:	0f 85 12 09 00 00    	jne    108aad6 <check_input_run+0xa7c6>
 108a1c4:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
 108a1c9:	48 8b 34 24          	mov    (%rsp),%rsi
 108a1cd:	48 c7 87 48 02 00 00 	movq   $0x0,0x248(%rdi)
 108a1d4:	00 00 00 00 
 108a1d8:	48 c7 87 60 02 00 00 	movq   $0x0,0x260(%rdi)
 108a1df:	00 00 00 00 
 108a1e3:	e9 89 69 ff ff       	jmp    1080b71 <check_input_run+0x861>
 108a1e8:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
 108a1ed:	48 89 ee             	mov    %rbp,%rsi
 108a1f0:	48 29 fe             	sub    %rdi,%rsi
 108a1f3:	48 8b 79 10          	mov    0x10(%rcx),%rdi
 108a1f7:	4d 89 c3             	mov    %r8,%r11
 108a1fa:	8b 92 30 08 00 00    	mov    0x830(%rdx),%edx
 108a200:	48 29 f7             	sub    %rsi,%rdi
 108a203:	41 0f 92 c0          	setb   %r8b
 108a207:	48 39 d7             	cmp    %rdx,%rdi
 108a20a:	40 0f 96 c7          	setbe  %dil
 108a20e:	44 08 c7             	or     %r8b,%dil
 108a211:	74 53                	je     108a266 <check_input_run+0x9f56>
 108a213:	31 ed                	xor    %ebp,%ebp
 108a215:	eb 59                	jmp    108a270 <check_input_run+0x9f60>
 108a217:	8d 91 00 fd ff ff    	lea    -0x300(%rcx),%edx
 108a21d:	66 83 fa 16          	cmp    $0x16,%dx
 108a221:	0f 87 e7 d9 ff ff    	ja     1087c0e <check_input_run+0x78fe>
 108a227:	31 c0                	xor    %eax,%eax
 108a229:	81 f9 12 03 00 00    	cmp    $0x312,%ecx
 108a22f:	0f 94 c0             	sete   %al
 108a232:	e9 d7 d9 ff ff       	jmp    1087c0e <check_input_run+0x78fe>
 108a237:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
 108a23c:	48 8b 34 24          	mov    (%rsp),%rsi
 108a240:	48 c7 87 40 02 00 00 	movq   $0x0,0x240(%rdi)
 108a247:	00 00 00 00 
 108a24b:	48 c7 87 48 02 00 00 	movq   $0x0,0x248(%rdi)
 108a252:	00 00 00 00 
 108a256:	48 c7 87 60 02 00 00 	movq   $0x0,0x260(%rdi)
 108a25d:	00 00 00 00 
 108a261:	e9 0b 69 ff ff       	jmp    1080b71 <check_input_run+0x861>
 108a266:	48 ff c2             	inc    %rdx
 108a269:	48 01 f2             	add    %rsi,%rdx
 108a26c:	48 89 51 08          	mov    %rdx,0x8(%rcx)
 108a270:	48 89 84 24 70 01 00 	mov    %rax,0x170(%rsp)
 108a277:	00 
 108a278:	4d 89 d8             	mov    %r11,%r8
 108a27b:	e9 ac dd ff ff       	jmp    108802c <check_input_run+0x7d1c>
 108a280:	31 f6                	xor    %esi,%esi
 108a282:	eb 12                	jmp    108a296 <check_input_run+0x9f86>
 108a284:	48 ff c6             	inc    %rsi
 108a287:	48 89 f2             	mov    %rsi,%rdx
 108a28a:	48 89 d6             	mov    %rdx,%rsi
 108a28d:	4c 39 ea             	cmp    %r13,%rdx
 108a290:	0f 84 7c 03 00 00    	je     108a612 <check_input_run+0xa302>
 108a296:	4c 8b 8c 24 60 02 00 	mov    0x260(%rsp),%r9
 108a29d:	00 
 108a29e:	49 8b 81 f0 01 00 00 	mov    0x1f0(%r9),%rax
 108a2a5:	48 85 c0             	test   %rax,%rax
 108a2a8:	74 06                	je     108a2b0 <check_input_run+0x9fa0>
 108a2aa:	80 3c 30 00          	cmpb   $0x0,(%rax,%rsi,1)
 108a2ae:	75 d4                	jne    108a284 <check_input_run+0x9f74>
 108a2b0:	49 8b 5e 10          	mov    0x10(%r14),%rbx
 108a2b4:	48 8d 56 01          	lea    0x1(%rsi),%rdx
 108a2b8:	0f b6 3c 33          	movzbl (%rbx,%rsi,1),%edi
 108a2bc:	40 80 ff 4f          	cmp    $0x4f,%dil
 108a2c0:	0f 84 c3 00 00 00    	je     108a389 <check_input_run+0xa079>
 108a2c6:	49 8b 46 50          	mov    0x50(%r14),%rax
 108a2ca:	40 80 ff 0f          	cmp    $0xf,%dil
 108a2ce:	75 0a                	jne    108a2da <check_input_run+0x9fca>
 108a2d0:	80 3c 30 09          	cmpb   $0x9,(%rax,%rsi,1)
 108a2d4:	0f 84 00 01 00 00    	je     108a3da <check_input_run+0xa0ca>
 108a2da:	40 80 ff 30          	cmp    $0x30,%dil
 108a2de:	75 aa                	jne    108a28a <check_input_run+0x9f7a>
 108a2e0:	49 8b 89 88 02 00 00 	mov    0x288(%r9),%rcx
 108a2e7:	48 83 3c f1 00       	cmpq   $0x0,(%rcx,%rsi,8)
 108a2ec:	74 9c                	je     108a28a <check_input_run+0x9f7a>
 108a2ee:	49 8b 7e 60          	mov    0x60(%r14),%rdi
 108a2f2:	44 8b 04 b7          	mov    (%rdi,%rsi,4),%r8d
 108a2f6:	45 39 e8             	cmp    %r13d,%r8d
 108a2f9:	73 44                	jae    108a33f <check_input_run+0xa02f>
 108a2fb:	48 8b 8c 24 d0 05 00 	mov    0x5d0(%rsp),%rcx
 108a302:	00 
 108a303:	eb 09                	jmp    108a30e <check_input_run+0x9ffe>
 108a305:	46 8b 04 87          	mov    (%rdi,%r8,4),%r8d
 108a309:	45 39 e8             	cmp    %r13d,%r8d
 108a30c:	73 31                	jae    108a33f <check_input_run+0xa02f>
 108a30e:	45 89 c0             	mov    %r8d,%r8d
 108a311:	42 80 3c 00 49       	cmpb   $0x49,(%rax,%r8,1)
 108a316:	75 ed                	jne    108a305 <check_input_run+0x9ff5>
 108a318:	46 8b 14 81          	mov    (%rcx,%r8,4),%r10d
 108a31c:	45 39 ea             	cmp    %r13d,%r10d
 108a31f:	73 e4                	jae    108a305 <check_input_run+0x9ff5>
 108a321:	46 0f b6 14 13       	movzbl (%rbx,%r10,1),%r10d
 108a326:	46 8b 04 87          	mov    (%rdi,%r8,4),%r8d
 108a32a:	45 39 e8             	cmp    %r13d,%r8d
 108a32d:	73 06                	jae    108a335 <check_input_run+0xa025>
 108a32f:	41 80 fa 49          	cmp    $0x49,%r10b
 108a333:	75 d9                	jne    108a30e <check_input_run+0x9ffe>
 108a335:	41 80 fa 49          	cmp    $0x49,%r10b
 108a339:	0f 84 4b ff ff ff    	je     108a28a <check_input_run+0x9f7a>
 108a33f:	41 8b 81 30 02 00 00 	mov    0x230(%r9),%eax
 108a346:	41 3b 81 34 02 00 00 	cmp    0x234(%r9),%eax
 108a34d:	0f 83 f1 01 00 00    	jae    108a544 <check_input_run+0xa234>
 108a353:	41 0f b6 89 bd 03 00 	movzbl 0x3bd(%r9),%ecx
 108a35a:	00 
 108a35b:	49 8b b9 28 02 00 00 	mov    0x228(%r9),%rdi
 108a362:	44 8d 40 01          	lea    0x1(%rax),%r8d
 108a366:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
 108a36a:	45 89 81 30 02 00 00 	mov    %r8d,0x230(%r9)
 108a371:	8d 4c 49 01          	lea    0x1(%rcx,%rcx,2),%ecx
 108a375:	89 34 87             	mov    %esi,(%rdi,%rax,4)
 108a378:	89 4c 87 04          	mov    %ecx,0x4(%rdi,%rax,4)
 108a37c:	c7 44 87 08 00 00 00 	movl   $0x0,0x8(%rdi,%rax,4)
 108a383:	00 
 108a384:	e9 01 ff ff ff       	jmp    108a28a <check_input_run+0x9f7a>
 108a389:	41 8b 46 30          	mov    0x30(%r14),%eax
 108a38d:	48 39 c2             	cmp    %rax,%rdx
 108a390:	73 37                	jae    108a3c9 <check_input_run+0xa0b9>
 108a392:	49 8b 46 60          	mov    0x60(%r14),%rax
 108a396:	8b 44 b0 04          	mov    0x4(%rax,%rsi,4),%eax
 108a39a:	48 39 c6             	cmp    %rax,%rsi
 108a39d:	75 2a                	jne    108a3c9 <check_input_run+0xa0b9>
 108a39f:	49 8b 46 50          	mov    0x50(%r14),%rax
 108a3a3:	80 3c 10 1a          	cmpb   $0x1a,(%rax,%rdx,1)
 108a3a7:	75 20                	jne    108a3c9 <check_input_run+0xa0b9>
 108a3a9:	49 8b 81 48 03 00 00 	mov    0x348(%r9),%rax
 108a3b0:	83 3c b0 00          	cmpl   $0x0,(%rax,%rsi,4)
 108a3b4:	75 13                	jne    108a3c9 <check_input_run+0xa0b9>
 108a3b6:	80 7c 33 01 11       	cmpb   $0x11,0x1(%rbx,%rsi,1)
 108a3bb:	75 0c                	jne    108a3c9 <check_input_run+0xa0b9>
 108a3bd:	ff 84 24 38 06 00 00 	incl   0x638(%rsp)
 108a3c4:	e9 c1 fe ff ff       	jmp    108a28a <check_input_run+0x9f7a>
 108a3c9:	49 8b 81 48 03 00 00 	mov    0x348(%r9),%rax
 108a3d0:	83 3c b0 00          	cmpl   $0x0,(%rax,%rsi,4)
 108a3d4:	0f 85 b0 fe ff ff    	jne    108a28a <check_input_run+0x9f7a>
 108a3da:	4d 8b a1 e0 02 00 00 	mov    0x2e0(%r9),%r12
 108a3e1:	48 8b 84 24 d0 05 00 	mov    0x5d0(%rsp),%rax
 108a3e8:	00 
 108a3e9:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
 108a3ee:	45 31 db             	xor    %r11d,%r11d
 108a3f1:	45 8b 14 b4          	mov    (%r12,%rsi,4),%r10d
 108a3f5:	44 8b 04 b0          	mov    (%rax,%rsi,4),%r8d
 108a3f9:	49 39 ca             	cmp    %rcx,%r10
 108a3fc:	0f 84 66 01 00 00    	je     108a568 <check_input_run+0xa258>
 108a402:	45 39 e8             	cmp    %r13d,%r8d
 108a405:	0f 83 5d 01 00 00    	jae    108a568 <check_input_run+0xa258>
 108a40b:	42 80 3c 03 02       	cmpb   $0x2,(%rbx,%r8,1)
 108a410:	0f 85 a1 00 00 00    	jne    108a4b7 <check_input_run+0xa1a7>
 108a416:	49 8b 4e 18          	mov    0x18(%r14),%rcx
 108a41a:	4c 89 44 24 60       	mov    %r8,0x60(%rsp)
 108a41f:	42 8b 0c 81          	mov    (%rcx,%r8,4),%ecx
 108a423:	49 b8 15 7c 4a 7f b9 	movabs $0x9e3779b97f4a7c15,%r8
 108a42a:	79 37 9e 
 108a42d:	49 89 cb             	mov    %rcx,%r11
 108a430:	4d 0f af d8          	imul   %r8,%r11
 108a434:	4d 01 d3             	add    %r10,%r11
 108a437:	49 21 eb             	and    %rbp,%r11
 108a43a:	43 8b 1c 9f          	mov    (%r15,%r11,4),%ebx
 108a43e:	85 db                	test   %ebx,%ebx
 108a440:	74 7d                	je     108a4bf <check_input_run+0xa1af>
 108a442:	4c 8b 84 24 68 02 00 	mov    0x268(%rsp),%r8
 108a449:	00 
 108a44a:	eb 0e                	jmp    108a45a <check_input_run+0xa14a>
 108a44c:	49 ff c3             	inc    %r11
 108a44f:	49 21 eb             	and    %rbp,%r11
 108a452:	43 8b 1c 9f          	mov    (%r15,%r11,4),%ebx
 108a456:	85 db                	test   %ebx,%ebx
 108a458:	74 65                	je     108a4bf <check_input_run+0xa1af>
 108a45a:	ff cb                	dec    %ebx
 108a45c:	45 39 14 9c          	cmp    %r10d,(%r12,%rbx,4)
 108a460:	75 ea                	jne    108a44c <check_input_run+0xa13c>
 108a462:	44 8b 3c 98          	mov    (%rax,%rbx,4),%r15d
 108a466:	4d 8b 70 18          	mov    0x18(%r8),%r14
 108a46a:	43 39 0c be          	cmp    %ecx,(%r14,%r15,4)
 108a46e:	4c 8b 7c 24 40       	mov    0x40(%rsp),%r15
 108a473:	4c 8b 74 24 38       	mov    0x38(%rsp),%r14
 108a478:	75 d2                	jne    108a44c <check_input_run+0xa13c>
 108a47a:	49 8b 81 00 03 00 00 	mov    0x300(%r9),%rax
 108a481:	41 b3 01             	mov    $0x1,%r11b
 108a484:	89 1c b0             	mov    %ebx,(%rax,%rsi,4)
 108a487:	40 80 ff 4f          	cmp    $0x4f,%dil
 108a48b:	0f 85 c8 00 00 00    	jne    108a559 <check_input_run+0xa249>
 108a491:	48 8b 8c 24 68 02 00 	mov    0x268(%rsp),%rcx
 108a498:	00 
 108a499:	44 8b 49 30          	mov    0x30(%rcx),%r9d
 108a49d:	44 39 cb             	cmp    %r9d,%ebx
 108a4a0:	0f 83 b3 00 00 00    	jae    108a559 <check_input_run+0xa249>
 108a4a6:	4c 8b b4 24 60 02 00 	mov    0x260(%rsp),%r14
 108a4ad:	00 
 108a4ae:	4d 8b a6 18 03 00 00 	mov    0x318(%r14),%r12
 108a4b5:	eb 21                	jmp    108a4d8 <check_input_run+0xa1c8>
 108a4b7:	45 31 db             	xor    %r11d,%r11d
 108a4ba:	e9 a9 00 00 00       	jmp    108a568 <check_input_run+0xa258>
 108a4bf:	45 31 db             	xor    %r11d,%r11d
 108a4c2:	e9 9c 00 00 00       	jmp    108a563 <check_input_run+0xa253>
 108a4c7:	48 8b 41 60          	mov    0x60(%rcx),%rax
 108a4cb:	42 8b 1c 80          	mov    (%rax,%r8,4),%ebx
 108a4cf:	44 39 cb             	cmp    %r9d,%ebx
 108a4d2:	0f 83 81 00 00 00    	jae    108a559 <check_input_run+0xa249>
 108a4d8:	41 89 d8             	mov    %ebx,%r8d
 108a4db:	43 8b 04 84          	mov    (%r12,%r8,4),%eax
 108a4df:	85 c0                	test   %eax,%eax
 108a4e1:	74 e4                	je     108a4c7 <check_input_run+0xa1b7>
 108a4e3:	49 8b 9e 10 03 00 00 	mov    0x310(%r14),%rbx
 108a4ea:	ff c8                	dec    %eax
 108a4ec:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
 108a4f0:	39 34 c3             	cmp    %esi,(%rbx,%rax,8)
 108a4f3:	73 09                	jae    108a4fe <check_input_run+0xa1ee>
 108a4f5:	48 8d 04 c3          	lea    (%rbx,%rax,8),%rax
 108a4f9:	39 70 04             	cmp    %esi,0x4(%rax)
 108a4fc:	77 c9                	ja     108a4c7 <check_input_run+0xa1b7>
 108a4fe:	41 8b 8e 30 02 00 00 	mov    0x230(%r14),%ecx
 108a505:	41 3b 8e 34 02 00 00 	cmp    0x234(%r14),%ecx
 108a50c:	73 43                	jae    108a551 <check_input_run+0xa241>
 108a50e:	41 0f b6 86 bd 03 00 	movzbl 0x3bd(%r14),%eax
 108a515:	00 
 108a516:	4d 8b 86 28 02 00 00 	mov    0x228(%r14),%r8
 108a51d:	44 8d 49 01          	lea    0x1(%rcx),%r9d
 108a521:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
 108a525:	45 89 8e 30 02 00 00 	mov    %r9d,0x230(%r14)
 108a52c:	8d 44 40 01          	lea    0x1(%rax,%rax,2),%eax
 108a530:	41 89 34 88          	mov    %esi,(%r8,%rcx,4)
 108a534:	41 89 44 88 04       	mov    %eax,0x4(%r8,%rcx,4)
 108a539:	41 c7 44 88 08 00 00 	movl   $0x0,0x8(%r8,%rcx,4)
 108a540:	00 00 
 108a542:	eb 15                	jmp    108a559 <check_input_run+0xa249>
 108a544:	41 c6 81 bd 03 00 00 	movb   $0x1,0x3bd(%r9)
 108a54b:	01 
 108a54c:	e9 39 fd ff ff       	jmp    108a28a <check_input_run+0x9f7a>
 108a551:	41 c6 86 bd 03 00 00 	movb   $0x1,0x3bd(%r14)
 108a558:	01 
 108a559:	4c 8b 74 24 38       	mov    0x38(%rsp),%r14
 108a55e:	4c 8b 7c 24 40       	mov    0x40(%rsp),%r15
 108a563:	4c 8b 44 24 60       	mov    0x60(%rsp),%r8
 108a568:	45 39 ea             	cmp    %r13d,%r10d
 108a56b:	73 24                	jae    108a591 <check_input_run+0xa281>
 108a56d:	49 8b 46 50          	mov    0x50(%r14),%rax
 108a571:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
 108a576:	42 80 3c 10 34       	cmpb   $0x34,(%rax,%r10,1)
 108a57b:	75 19                	jne    108a596 <check_input_run+0xa286>
 108a57d:	49 8b 46 60          	mov    0x60(%r14),%rax
 108a581:	42 8b 04 90          	mov    (%rax,%r10,4),%eax
 108a585:	3b 84 24 34 06 00 00 	cmp    0x634(%rsp),%eax
 108a58c:	0f 93 c0             	setae  %al
 108a58f:	eb 07                	jmp    108a598 <check_input_run+0xa288>
 108a591:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
 108a596:	31 c0                	xor    %eax,%eax
 108a598:	41 08 c3             	or     %al,%r11b
 108a59b:	41 f6 c3 01          	test   $0x1,%r11b
 108a59f:	0f 85 e5 fc ff ff    	jne    108a28a <check_input_run+0x9f7a>
 108a5a5:	48 8b 84 24 60 02 00 	mov    0x260(%rsp),%rax
 108a5ac:	00 
 108a5ad:	8b 88 30 02 00 00    	mov    0x230(%rax),%ecx
 108a5b3:	3b 88 34 02 00 00    	cmp    0x234(%rax),%ecx
 108a5b9:	73 4b                	jae    108a606 <check_input_run+0xa2f6>
 108a5bb:	45 39 e8             	cmp    %r13d,%r8d
 108a5be:	4d 89 c1             	mov    %r8,%r9
 108a5c1:	41 89 f0             	mov    %esi,%r8d
 108a5c4:	45 0f 42 c1          	cmovb  %r9d,%r8d
 108a5c8:	40 80 ff 4f          	cmp    $0x4f,%dil
 108a5cc:	48 8b b8 28 02 00 00 	mov    0x228(%rax),%rdi
 108a5d3:	44 8d 49 01          	lea    0x1(%rcx),%r9d
 108a5d7:	44 0f 44 c6          	cmove  %esi,%r8d
 108a5db:	0f b6 b0 bd 03 00 00 	movzbl 0x3bd(%rax),%esi
 108a5e2:	44 89 88 30 02 00 00 	mov    %r9d,0x230(%rax)
 108a5e9:	48 8d 04 49          	lea    (%rcx,%rcx,2),%rax
 108a5ed:	44 89 04 87          	mov    %r8d,(%rdi,%rax,4)
 108a5f1:	8d 74 36 02          	lea    0x2(%rsi,%rsi,1),%esi
 108a5f5:	89 74 87 04          	mov    %esi,0x4(%rdi,%rax,4)
 108a5f9:	c7 44 87 08 00 00 00 	movl   $0x0,0x8(%rdi,%rax,4)
 108a600:	00 
 108a601:	e9 84 fc ff ff       	jmp    108a28a <check_input_run+0x9f7a>
 108a606:	c6 80 bd 03 00 00 01 	movb   $0x1,0x3bd(%rax)
 108a60d:	e9 78 fc ff ff       	jmp    108a28a <check_input_run+0x9f7a>
 108a612:	83 bc 24 38 06 00 00 	cmpl   $0x0,0x638(%rsp)
 108a619:	00 
 108a61a:	4c 8b 44 24 68       	mov    0x68(%rsp),%r8
 108a61f:	0f 84 fc f4 ff ff    	je     1089b21 <check_input_run+0x9811>
 108a625:	48 8b 84 24 68 02 00 	mov    0x268(%rsp),%rax
 108a62c:	00 
 108a62d:	8b 48 30             	mov    0x30(%rax),%ecx
 108a630:	85 c9                	test   %ecx,%ecx
 108a632:	0f 84 e9 f4 ff ff    	je     1089b21 <check_input_run+0x9811>
 108a638:	45 31 d2             	xor    %r10d,%r10d
 108a63b:	eb 14                	jmp    108a651 <check_input_run+0xa341>
 108a63d:	4c 8b 44 24 68       	mov    0x68(%rsp),%r8
 108a642:	45 89 ea             	mov    %r13d,%r10d
 108a645:	41 ff c2             	inc    %r10d
 108a648:	41 39 ca             	cmp    %ecx,%r10d
 108a64b:	0f 83 d0 f4 ff ff    	jae    1089b21 <check_input_run+0x9811>
 108a651:	4c 8b 8c 24 60 02 00 	mov    0x260(%rsp),%r9
 108a658:	00 
 108a659:	49 8b b1 f0 01 00 00 	mov    0x1f0(%r9),%rsi
 108a660:	48 85 f6             	test   %rsi,%rsi
 108a663:	74 0f                	je     108a674 <check_input_run+0xa364>
 108a665:	44 89 d2             	mov    %r10d,%edx
 108a668:	80 3c 16 00          	cmpb   $0x0,(%rsi,%rdx,1)
 108a66c:	75 d7                	jne    108a645 <check_input_run+0xa335>
 108a66e:	4c 8b 58 60          	mov    0x60(%rax),%r11
 108a672:	eb 07                	jmp    108a67b <check_input_run+0xa36b>
 108a674:	4c 8b 58 60          	mov    0x60(%rax),%r11
 108a678:	44 89 d2             	mov    %r10d,%edx
 108a67b:	4c 8b 70 50          	mov    0x50(%rax),%r14
 108a67f:	49 8d 34 93          	lea    (%r11,%rdx,4),%rsi
 108a683:	41 80 3c 16 34       	cmpb   $0x34,(%r14,%rdx,1)
 108a688:	75 bb                	jne    108a645 <check_input_run+0xa335>
 108a68a:	44 8b 2e             	mov    (%rsi),%r13d
 108a68d:	41 39 cd             	cmp    %ecx,%r13d
 108a690:	73 b3                	jae    108a645 <check_input_run+0xa335>
 108a692:	44 3b ac 24 34 06 00 	cmp    0x634(%rsp),%r13d
 108a699:	00 
 108a69a:	73 a9                	jae    108a645 <check_input_run+0xa335>
 108a69c:	41 8d 72 01          	lea    0x1(%r10),%esi
 108a6a0:	44 39 ee             	cmp    %r13d,%esi
 108a6a3:	73 9d                	jae    108a642 <check_input_run+0xa332>
 108a6a5:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
 108a6ab:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 108a6b0:	41 89 f7             	mov    %esi,%r15d
 108a6b3:	31 f6                	xor    %esi,%esi
 108a6b5:	c7 44 24 38 00 00 00 	movl   $0x0,0x38(%rsp)
 108a6bc:	00 
 108a6bd:	4c 89 6c 24 40       	mov    %r13,0x40(%rsp)
 108a6c2:	eb 23                	jmp    108a6e7 <check_input_run+0xa3d7>
 108a6c4:	4c 8b 6c 24 40       	mov    0x40(%rsp),%r13
 108a6c9:	41 83 f8 ff          	cmp    $0xffffffff,%r8d
 108a6cd:	0f 84 84 00 00 00    	je     108a757 <check_input_run+0xa447>
 108a6d3:	45 89 fa             	mov    %r15d,%r10d
 108a6d6:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
 108a6db:	49 ff c7             	inc    %r15
 108a6de:	45 39 fd             	cmp    %r15d,%r13d
 108a6e1:	0f 84 dc 00 00 00    	je     108a7c3 <check_input_run+0xa4b3>
 108a6e7:	43 80 3c 3e 09       	cmpb   $0x9,(%r14,%r15,1)
 108a6ec:	75 db                	jne    108a6c9 <check_input_run+0xa3b9>
 108a6ee:	4c 8b 60 10          	mov    0x10(%rax),%r12
 108a6f2:	43 80 3c 3c 0f       	cmpb   $0xf,(%r12,%r15,1)
 108a6f7:	75 d0                	jne    108a6c9 <check_input_run+0xa3b9>
 108a6f9:	4d 8b a1 00 03 00 00 	mov    0x300(%r9),%r12
 108a700:	8b 54 24 38          	mov    0x38(%rsp),%edx
 108a704:	43 8b 2c bc          	mov    (%r12,%r15,4),%ebp
 108a708:	83 fd ff             	cmp    $0xffffffff,%ebp
 108a70b:	41 0f 95 c4          	setne  %r12b
 108a70f:	44 08 e2             	or     %r12b,%dl
 108a712:	89 54 24 38          	mov    %edx,0x38(%rsp)
 108a716:	39 cd                	cmp    %ecx,%ebp
 108a718:	73 af                	jae    108a6c9 <check_input_run+0xa3b9>
 108a71a:	4d 8b a1 18 03 00 00 	mov    0x318(%r9),%r12
 108a721:	eb 08                	jmp    108a72b <check_input_run+0xa41b>
 108a723:	43 8b 2c ab          	mov    (%r11,%r13,4),%ebp
 108a727:	39 cd                	cmp    %ecx,%ebp
 108a729:	73 99                	jae    108a6c4 <check_input_run+0xa3b4>
 108a72b:	41 89 ed             	mov    %ebp,%r13d
 108a72e:	43 8b 2c ac          	mov    (%r12,%r13,4),%ebp
 108a732:	85 ed                	test   %ebp,%ebp
 108a734:	74 ed                	je     108a723 <check_input_run+0xa413>
 108a736:	49 8b 99 10 03 00 00 	mov    0x310(%r9),%rbx
 108a73d:	ff cd                	dec    %ebp
 108a73f:	48 8d 6c 6d 00       	lea    0x0(%rbp,%rbp,2),%rbp
 108a744:	8b 14 eb             	mov    (%rbx,%rbp,8),%edx
 108a747:	8b 5c eb 04          	mov    0x4(%rbx,%rbp,8),%ebx
 108a74b:	39 f2                	cmp    %esi,%edx
 108a74d:	0f 47 f2             	cmova  %edx,%esi
 108a750:	39 fb                	cmp    %edi,%ebx
 108a752:	0f 42 fb             	cmovb  %ebx,%edi
 108a755:	eb cc                	jmp    108a723 <check_input_run+0xa413>
 108a757:	4c 8b 60 10          	mov    0x10(%rax),%r12
 108a75b:	43 80 3c 3c 4f       	cmpb   $0x4f,(%r12,%r15,1)
 108a760:	0f 85 6d ff ff ff    	jne    108a6d3 <check_input_run+0xa3c3>
 108a766:	41 83 c2 02          	add    $0x2,%r10d
 108a76a:	44 3b 50 30          	cmp    0x30(%rax),%r10d
 108a76e:	0f 83 5f ff ff ff    	jae    108a6d3 <check_input_run+0xa3c3>
 108a774:	45 89 d2             	mov    %r10d,%r10d
 108a777:	43 8b 14 93          	mov    (%r11,%r10,4),%edx
 108a77b:	49 39 d7             	cmp    %rdx,%r15
 108a77e:	0f 85 4f ff ff ff    	jne    108a6d3 <check_input_run+0xa3c3>
 108a784:	43 80 3c 16 1a       	cmpb   $0x1a,(%r14,%r10,1)
 108a789:	0f 85 44 ff ff ff    	jne    108a6d3 <check_input_run+0xa3c3>
 108a78f:	43 80 3c 14 11       	cmpb   $0x11,(%r12,%r10,1)
 108a794:	0f 85 39 ff ff ff    	jne    108a6d3 <check_input_run+0xa3c3>
 108a79a:	49 8b 91 48 03 00 00 	mov    0x348(%r9),%rdx
 108a7a1:	42 83 3c ba 00       	cmpl   $0x0,(%rdx,%r15,4)
 108a7a6:	0f 85 27 ff ff ff    	jne    108a6d3 <check_input_run+0xa3c3>
 108a7ac:	45 89 fa             	mov    %r15d,%r10d
 108a7af:	45 89 f8             	mov    %r15d,%r8d
 108a7b2:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
 108a7b7:	49 ff c7             	inc    %r15
 108a7ba:	45 39 fd             	cmp    %r15d,%r13d
 108a7bd:	0f 85 24 ff ff ff    	jne    108a6e7 <check_input_run+0xa3d7>
 108a7c3:	8b 6c 24 38          	mov    0x38(%rsp),%ebp
 108a7c7:	41 83 f8 ff          	cmp    $0xffffffff,%r8d
 108a7cb:	41 0f 94 c2          	sete   %r10b
 108a7cf:	41 08 ea             	or     %bpl,%r10b
 108a7d2:	41 f6 c2 01          	test   $0x1,%r10b
 108a7d6:	75 4e                	jne    108a826 <check_input_run+0xa516>
 108a7d8:	45 8b 91 30 02 00 00 	mov    0x230(%r9),%r10d
 108a7df:	45 3b 91 34 02 00 00 	cmp    0x234(%r9),%r10d
 108a7e6:	73 36                	jae    108a81e <check_input_run+0xa50e>
 108a7e8:	41 0f b6 91 bd 03 00 	movzbl 0x3bd(%r9),%edx
 108a7ef:	00 
 108a7f0:	4d 8b 99 28 02 00 00 	mov    0x228(%r9),%r11
 108a7f7:	41 8d 5a 01          	lea    0x1(%r10),%ebx
 108a7fb:	41 89 99 30 02 00 00 	mov    %ebx,0x230(%r9)
 108a802:	4f 8d 0c 52          	lea    (%r10,%r10,2),%r9
 108a806:	8d 54 52 01          	lea    0x1(%rdx,%rdx,2),%edx
 108a80a:	47 89 04 8b          	mov    %r8d,(%r11,%r9,4)
 108a80e:	43 89 54 8b 04       	mov    %edx,0x4(%r11,%r9,4)
 108a813:	43 c7 44 8b 08 00 00 	movl   $0x0,0x8(%r11,%r9,4)
 108a81a:	00 00 
 108a81c:	eb 08                	jmp    108a826 <check_input_run+0xa516>
 108a81e:	41 c6 81 bd 03 00 00 	movb   $0x1,0x3bd(%r9)
 108a825:	01 
 108a826:	45 39 e8             	cmp    %r13d,%r8d
 108a829:	0f 92 c2             	setb   %dl
 108a82c:	40 84 d5             	test   %dl,%bpl
 108a82f:	0f 84 08 fe ff ff    	je     108a63d <check_input_run+0xa32d>
 108a835:	44 89 ea             	mov    %r13d,%edx
 108a838:	44 29 c2             	sub    %r8d,%edx
 108a83b:	45 89 c2             	mov    %r8d,%r10d
 108a83e:	4d 89 d1             	mov    %r10,%r9
 108a841:	f6 c2 01             	test   $0x1,%dl
 108a844:	0f 84 b3 00 00 00    	je     108a8fd <check_input_run+0xa5ed>
 108a84a:	4c 8b 58 10          	mov    0x10(%rax),%r11
 108a84e:	4d 8d 4a 01          	lea    0x1(%r10),%r9
 108a852:	43 80 3c 13 4f       	cmpb   $0x4f,(%r11,%r10,1)
 108a857:	0f 85 a0 00 00 00    	jne    108a8fd <check_input_run+0xa5ed>
 108a85d:	8b 50 30             	mov    0x30(%rax),%edx
 108a860:	49 39 d1             	cmp    %rdx,%r9
 108a863:	0f 83 8a 00 00 00    	jae    108a8f3 <check_input_run+0xa5e3>
 108a869:	48 8b 50 60          	mov    0x60(%rax),%rdx
 108a86d:	46 3b 44 92 04       	cmp    0x4(%rdx,%r10,4),%r8d
 108a872:	75 7f                	jne    108a8f3 <check_input_run+0xa5e3>
 108a874:	48 8b 50 50          	mov    0x50(%rax),%rdx
 108a878:	42 80 3c 0a 1a       	cmpb   $0x1a,(%rdx,%r9,1)
 108a87d:	75 74                	jne    108a8f3 <check_input_run+0xa5e3>
 108a87f:	43 80 3c 0b 11       	cmpb   $0x11,(%r11,%r9,1)
 108a884:	75 6d                	jne    108a8f3 <check_input_run+0xa5e3>
 108a886:	4c 8b 9c 24 60 02 00 	mov    0x260(%rsp),%r11
 108a88d:	00 
 108a88e:	49 8b 93 48 03 00 00 	mov    0x348(%r11),%rdx
 108a895:	42 83 3c 92 00       	cmpl   $0x0,(%rdx,%r10,4)
 108a89a:	75 57                	jne    108a8f3 <check_input_run+0xa5e3>
 108a89c:	41 39 f0             	cmp    %esi,%r8d
 108a89f:	76 05                	jbe    108a8a6 <check_input_run+0xa596>
 108a8a1:	41 39 f8             	cmp    %edi,%r8d
 108a8a4:	72 4d                	jb     108a8f3 <check_input_run+0xa5e3>
 108a8a6:	41 8b 9b 30 02 00 00 	mov    0x230(%r11),%ebx
 108a8ad:	41 3b 9b 34 02 00 00 	cmp    0x234(%r11),%ebx
 108a8b4:	73 35                	jae    108a8eb <check_input_run+0xa5db>
 108a8b6:	41 0f b6 93 bd 03 00 	movzbl 0x3bd(%r11),%edx
 108a8bd:	00 
 108a8be:	4d 8b b3 28 02 00 00 	mov    0x228(%r11),%r14
 108a8c5:	8d 6b 01             	lea    0x1(%rbx),%ebp
 108a8c8:	41 89 ab 30 02 00 00 	mov    %ebp,0x230(%r11)
 108a8cf:	4c 8d 1c 5b          	lea    (%rbx,%rbx,2),%r11
 108a8d3:	8d 54 52 01          	lea    0x1(%rdx,%rdx,2),%edx
 108a8d7:	47 89 04 9e          	mov    %r8d,(%r14,%r11,4)
 108a8db:	43 89 54 9e 04       	mov    %edx,0x4(%r14,%r11,4)
 108a8e0:	43 c7 44 9e 08 00 00 	movl   $0x0,0x8(%r14,%r11,4)
 108a8e7:	00 00 
 108a8e9:	eb 08                	jmp    108a8f3 <check_input_run+0xa5e3>
 108a8eb:	41 c6 83 bd 03 00 00 	movb   $0x1,0x3bd(%r11)
 108a8f2:	01 
 108a8f3:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
 108a8f8:	4c 8b 6c 24 40       	mov    0x40(%rsp),%r13
 108a8fd:	49 8d 55 ff          	lea    -0x1(%r13),%rdx
 108a901:	4c 39 d2             	cmp    %r10,%rdx
 108a904:	0f 84 33 fd ff ff    	je     108a63d <check_input_run+0xa32d>
 108a90a:	89 ff                	mov    %edi,%edi
 108a90c:	89 f6                	mov    %esi,%esi
 108a90e:	eb 4d                	jmp    108a95d <check_input_run+0xa64d>
 108a910:	41 0f b6 93 bd 03 00 	movzbl 0x3bd(%r11),%edx
 108a917:	00 
 108a918:	49 8b 9b 28 02 00 00 	mov    0x228(%r11),%rbx
 108a91f:	41 8d 68 01          	lea    0x1(%r8),%ebp
 108a923:	4f 8d 04 40          	lea    (%r8,%r8,2),%r8
 108a927:	41 ff c1             	inc    %r9d
 108a92a:	41 89 ab 30 02 00 00 	mov    %ebp,0x230(%r11)
 108a931:	8d 54 52 01          	lea    0x1(%rdx,%rdx,2),%edx
 108a935:	46 89 0c 83          	mov    %r9d,(%rbx,%r8,4)
 108a939:	42 89 54 83 04       	mov    %edx,0x4(%rbx,%r8,4)
 108a93e:	42 c7 44 83 08 00 00 	movl   $0x0,0x8(%rbx,%r8,4)
 108a945:	00 00 
 108a947:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
 108a94c:	4c 8b 6c 24 40       	mov    0x40(%rsp),%r13
 108a951:	4d 89 d1             	mov    %r10,%r9
 108a954:	4d 39 d5             	cmp    %r10,%r13
 108a957:	0f 84 e0 fc ff ff    	je     108a63d <check_input_run+0xa32d>
 108a95d:	4c 8b 50 10          	mov    0x10(%rax),%r10
 108a961:	4d 8d 41 01          	lea    0x1(%r9),%r8
 108a965:	43 80 3c 11 4f       	cmpb   $0x4f,(%r9,%r10,1)
 108a96a:	0f 85 ae 00 00 00    	jne    108aa1e <check_input_run+0xa70e>
 108a970:	8b 50 30             	mov    0x30(%rax),%edx
 108a973:	49 39 d0             	cmp    %rdx,%r8
 108a976:	0f 83 a2 00 00 00    	jae    108aa1e <check_input_run+0xa70e>
 108a97c:	48 8b 50 60          	mov    0x60(%rax),%rdx
 108a980:	42 8b 54 8a 04       	mov    0x4(%rdx,%r9,4),%edx
 108a985:	49 39 d1             	cmp    %rdx,%r9
 108a988:	0f 85 90 00 00 00    	jne    108aa1e <check_input_run+0xa70e>
 108a98e:	48 8b 50 50          	mov    0x50(%rax),%rdx
 108a992:	42 80 7c 0a 01 1a    	cmpb   $0x1a,0x1(%rdx,%r9,1)
 108a998:	0f 85 80 00 00 00    	jne    108aa1e <check_input_run+0xa70e>
 108a99e:	43 80 7c 0a 01 11    	cmpb   $0x11,0x1(%r10,%r9,1)
 108a9a4:	75 78                	jne    108aa1e <check_input_run+0xa70e>
 108a9a6:	4c 8b 94 24 60 02 00 	mov    0x260(%rsp),%r10
 108a9ad:	00 
 108a9ae:	49 8b 92 48 03 00 00 	mov    0x348(%r10),%rdx
 108a9b5:	42 83 3c 8a 00       	cmpl   $0x0,(%rdx,%r9,4)
 108a9ba:	75 62                	jne    108aa1e <check_input_run+0xa70e>
 108a9bc:	49 39 f1             	cmp    %rsi,%r9
 108a9bf:	76 05                	jbe    108a9c6 <check_input_run+0xa6b6>
 108a9c1:	49 39 f9             	cmp    %rdi,%r9
 108a9c4:	72 58                	jb     108aa1e <check_input_run+0xa70e>
 108a9c6:	45 8b 9a 30 02 00 00 	mov    0x230(%r10),%r11d
 108a9cd:	45 3b 9a 34 02 00 00 	cmp    0x234(%r10),%r11d
 108a9d4:	73 36                	jae    108aa0c <check_input_run+0xa6fc>
 108a9d6:	41 0f b6 92 bd 03 00 	movzbl 0x3bd(%r10),%edx
 108a9dd:	00 
 108a9de:	49 8b 9a 28 02 00 00 	mov    0x228(%r10),%rbx
 108a9e5:	41 8d 6b 01          	lea    0x1(%r11),%ebp
 108a9e9:	41 89 aa 30 02 00 00 	mov    %ebp,0x230(%r10)
 108a9f0:	4f 8d 14 5b          	lea    (%r11,%r11,2),%r10
 108a9f4:	8d 54 52 01          	lea    0x1(%rdx,%rdx,2),%edx
 108a9f8:	46 89 0c 93          	mov    %r9d,(%rbx,%r10,4)
 108a9fc:	42 89 54 93 04       	mov    %edx,0x4(%rbx,%r10,4)
 108aa01:	42 c7 44 93 08 00 00 	movl   $0x0,0x8(%rbx,%r10,4)
 108aa08:	00 00 
 108aa0a:	eb 08                	jmp    108aa14 <check_input_run+0xa704>
 108aa0c:	41 c6 82 bd 03 00 00 	movb   $0x1,0x3bd(%r10)
 108aa13:	01 
 108aa14:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
 108aa19:	4c 8b 6c 24 40       	mov    0x40(%rsp),%r13
 108aa1e:	4c 8b 58 10          	mov    0x10(%rax),%r11
 108aa22:	4d 8d 51 02          	lea    0x2(%r9),%r10
 108aa26:	43 80 7c 19 01 4f    	cmpb   $0x4f,0x1(%r9,%r11,1)
 108aa2c:	0f 85 1f ff ff ff    	jne    108a951 <check_input_run+0xa641>
 108aa32:	8b 50 30             	mov    0x30(%rax),%edx
 108aa35:	49 39 d2             	cmp    %rdx,%r10
 108aa38:	0f 83 13 ff ff ff    	jae    108a951 <check_input_run+0xa641>
 108aa3e:	48 8b 50 60          	mov    0x60(%rax),%rdx
 108aa42:	42 8b 54 8a 08       	mov    0x8(%rdx,%r9,4),%edx
 108aa47:	49 39 d0             	cmp    %rdx,%r8
 108aa4a:	0f 85 01 ff ff ff    	jne    108a951 <check_input_run+0xa641>
 108aa50:	48 8b 50 50          	mov    0x50(%rax),%rdx
 108aa54:	42 80 7c 0a 02 1a    	cmpb   $0x1a,0x2(%rdx,%r9,1)
 108aa5a:	0f 85 f1 fe ff ff    	jne    108a951 <check_input_run+0xa641>
 108aa60:	43 80 7c 0b 02 11    	cmpb   $0x11,0x2(%r11,%r9,1)
 108aa66:	0f 85 e5 fe ff ff    	jne    108a951 <check_input_run+0xa641>
 108aa6c:	4c 8b 9c 24 60 02 00 	mov    0x260(%rsp),%r11
 108aa73:	00 
 108aa74:	49 8b 93 48 03 00 00 	mov    0x348(%r11),%rdx
 108aa7b:	42 83 7c 8a 04 00    	cmpl   $0x0,0x4(%rdx,%r9,4)
 108aa81:	0f 85 ca fe ff ff    	jne    108a951 <check_input_run+0xa641>
 108aa87:	49 39 f1             	cmp    %rsi,%r9
 108aa8a:	72 09                	jb     108aa95 <check_input_run+0xa785>
 108aa8c:	49 39 f8             	cmp    %rdi,%r8
 108aa8f:	0f 82 bc fe ff ff    	jb     108a951 <check_input_run+0xa641>
 108aa95:	45 8b 83 30 02 00 00 	mov    0x230(%r11),%r8d
 108aa9c:	45 3b 83 34 02 00 00 	cmp    0x234(%r11),%r8d
 108aaa3:	0f 82 67 fe ff ff    	jb     108a910 <check_input_run+0xa600>
 108aaa9:	41 c6 83 bd 03 00 00 	movb   $0x1,0x3bd(%r11)
 108aab0:	01 
 108aab1:	e9 91 fe ff ff       	jmp    108a947 <check_input_run+0xa637>
 108aab6:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
 108aabb:	48 c7 87 48 02 00 00 	movq   $0x0,0x248(%rdi)
 108aac2:	00 00 00 00 
 108aac6:	48 c7 87 60 02 00 00 	movq   $0x0,0x260(%rdi)
 108aacd:	00 00 00 00 
 108aad1:	e9 9b 60 ff ff       	jmp    1080b71 <check_input_run+0x861>
 108aad6:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
 108aadb:	48 8b 34 24          	mov    (%rsp),%rsi
 108aadf:	4c 89 4c 24 20       	mov    %r9,0x20(%rsp)
 108aae4:	48 8d 54 0a 01       	lea    0x1(%rdx,%rcx,1),%rdx
 108aae9:	48 89 56 08          	mov    %rdx,0x8(%rsi)
 108aaed:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
 108aaf2:	48 03 0e             	add    (%rsi),%rcx
 108aaf5:	48 89 8a 48 02 00 00 	mov    %rcx,0x248(%rdx)
 108aafc:	0f 84 ba 00 00 00    	je     108abbc <check_input_run+0xa8ac>
 108ab02:	48 8b 0c 24          	mov    (%rsp),%rcx
 108ab06:	48 8b 31             	mov    (%rcx),%rsi
 108ab09:	48 8b 51 08          	mov    0x8(%rcx),%rdx
 108ab0d:	48 8d 4c 32 03       	lea    0x3(%rdx,%rsi,1),%rcx
 108ab12:	48 01 f2             	add    %rsi,%rdx
 108ab15:	48 83 e1 fc          	and    $0xfffffffffffffffc,%rcx
 108ab19:	48 39 d1             	cmp    %rdx,%rcx
 108ab1c:	0f 82 9a 00 00 00    	jb     108abbc <check_input_run+0xa8ac>
 108ab22:	48 89 ca             	mov    %rcx,%rdx
 108ab25:	48 29 f2             	sub    %rsi,%rdx
 108ab28:	48 8b 34 24          	mov    (%rsp),%rsi
 108ab2c:	48 8b 76 10          	mov    0x10(%rsi),%rsi
 108ab30:	48 29 d6             	sub    %rdx,%rsi
 108ab33:	0f 82 83 00 00 00    	jb     108abbc <check_input_run+0xa8ac>
 108ab39:	48 39 f0             	cmp    %rsi,%rax
 108ab3c:	77 7e                	ja     108abbc <check_input_run+0xa8ac>
 108ab3e:	48 8b 34 24          	mov    (%rsp),%rsi
 108ab42:	48 01 c2             	add    %rax,%rdx
 108ab45:	48 89 56 08          	mov    %rdx,0x8(%rsi)
 108ab49:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
 108ab4e:	48 89 8e 60 02 00 00 	mov    %rcx,0x260(%rsi)
 108ab55:	48 85 c9             	test   %rcx,%rcx
 108ab58:	74 45                	je     108ab9f <check_input_run+0xa88f>
 108ab5a:	48 8b 0c 24          	mov    (%rsp),%rcx
 108ab5e:	48 8b 11             	mov    (%rcx),%rdx
 108ab61:	48 8b 71 08          	mov    0x8(%rcx),%rsi
 108ab65:	48 8d 4c 16 07       	lea    0x7(%rsi,%rdx,1),%rcx
 108ab6a:	48 01 d6             	add    %rdx,%rsi
 108ab6d:	48 83 e1 f8          	and    $0xfffffffffffffff8,%rcx
 108ab71:	48 39 f1             	cmp    %rsi,%rcx
 108ab74:	72 29                	jb     108ab9f <check_input_run+0xa88f>
 108ab76:	48 89 ce             	mov    %rcx,%rsi
 108ab79:	48 29 d6             	sub    %rdx,%rsi
 108ab7c:	48 8b 14 24          	mov    (%rsp),%rdx
 108ab80:	48 8b 52 10          	mov    0x10(%rdx),%rdx
 108ab84:	48 29 f2             	sub    %rsi,%rdx
 108ab87:	40 0f 92 c7          	setb   %dil
 108ab8b:	48 3b 54 24 58       	cmp    0x58(%rsp),%rdx
 108ab90:	0f 96 c2             	setbe  %dl
 108ab93:	40 08 fa             	or     %dil,%dl
 108ab96:	80 fa 01             	cmp    $0x1,%dl
 108ab99:	0f 85 96 09 00 00    	jne    108b535 <check_input_run+0xb225>
 108ab9f:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
 108aba4:	48 8b 34 24          	mov    (%rsp),%rsi
 108aba8:	4c 8b 74 24 10       	mov    0x10(%rsp),%r14
 108abad:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
 108abb2:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
 108abb7:	e9 b5 5f ff ff       	jmp    1080b71 <check_input_run+0x861>
 108abbc:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
 108abc1:	48 8b 34 24          	mov    (%rsp),%rsi
 108abc5:	4c 8b 74 24 10       	mov    0x10(%rsp),%r14
 108abca:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
 108abcf:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
 108abd4:	48 c7 87 60 02 00 00 	movq   $0x0,0x260(%rdi)
 108abdb:	00 00 00 00 
 108abdf:	e9 8d 5f ff ff       	jmp    1080b71 <check_input_run+0x861>
 108abe4:	45 31 ed             	xor    %r13d,%r13d
 108abe7:	e9 41 99 ff ff       	jmp    108452d <check_input_run+0x421d>
 108abec:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
 108abf1:	31 d2                	xor    %edx,%edx
 108abf3:	41 88 54 0d 00       	mov    %dl,0x0(%r13,%rcx,1)
 108abf8:	48 89 c1             	mov    %rax,%rcx
 108abfb:	48 85 c0             	test   %rax,%rax
 108abfe:	0f 84 47 01 00 00    	je     108ad4b <check_input_run+0xaa3b>
 108ac04:	48 8d 05 e5 37 41 ff 	lea    -0xbec81b(%rip),%rax        # 49e3f0 <cbuiltin_test_generated.edges+0x3c70>
 108ac0b:	48 8d 15 f2 38 41 ff 	lea    -0xbec70e(%rip),%rdx        # 49e504 <cbuiltin_test_generated.edges+0x3d84>
 108ac12:	be 05 60 00 00       	mov    $0x6005,%esi
 108ac17:	eb 18                	jmp    108ac31 <check_input_run+0xa921>
 108ac19:	0f a3 ee             	bt     %ebp,%esi
 108ac1c:	0f 83 ae 00 00 00    	jae    108acd0 <check_input_run+0xa9c0>
 108ac22:	48 83 c1 fe          	add    $0xfffffffffffffffe,%rcx
 108ac26:	45 88 44 3d 00       	mov    %r8b,0x0(%r13,%rdi,1)
 108ac2b:	0f 84 1a 01 00 00    	je     108ad4b <check_input_run+0xaa3b>
 108ac31:	49 8b 7e 68          	mov    0x68(%r14),%rdi
 108ac35:	4d 8b 56 50          	mov    0x50(%r14),%r10
 108ac39:	4d 8b 46 60          	mov    0x60(%r14),%r8
 108ac3d:	8b 7c 8f fc          	mov    -0x4(%rdi,%rcx,4),%edi
 108ac41:	45 0f b6 1c 3a       	movzbl (%r10,%rdi,1),%r11d
 108ac46:	45 8b 0c b8          	mov    (%r8,%rdi,4),%r9d
 108ac4a:	41 b0 01             	mov    $0x1,%r8b
 108ac4d:	41 8d 6b bf          	lea    -0x41(%r11),%ebp
 108ac51:	83 fd 0e             	cmp    $0xe,%ebp
 108ac54:	77 05                	ja     108ac5b <check_input_run+0xa94b>
 108ac56:	0f a3 ee             	bt     %ebp,%esi
 108ac59:	72 47                	jb     108aca2 <check_input_run+0xa992>
 108ac5b:	41 83 c3 f9          	add    $0xfffffff9,%r11d
 108ac5f:	41 83 fb 02          	cmp    $0x2,%r11d
 108ac63:	72 3d                	jb     108aca2 <check_input_run+0xa992>
 108ac65:	41 39 d9             	cmp    %ebx,%r9d
 108ac68:	73 35                	jae    108ac9f <check_input_run+0xa98f>
 108ac6a:	43 80 7c 0d 00 00    	cmpb   $0x0,0x0(%r13,%r9,1)
 108ac70:	74 2d                	je     108ac9f <check_input_run+0xa98f>
 108ac72:	47 0f b6 14 0a       	movzbl (%r10,%r9,1),%r10d
 108ac77:	41 83 c2 f9          	add    $0xfffffff9,%r10d
 108ac7b:	41 83 fa 44          	cmp    $0x44,%r10d
 108ac7f:	77 1e                	ja     108ac9f <check_input_run+0xa98f>
 108ac81:	4e 63 14 90          	movslq (%rax,%r10,4),%r10
 108ac85:	49 01 c2             	add    %rax,%r10
 108ac88:	41 ff e2             	jmp    *%r10
 108ac8b:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
 108ac90:	43 3b 3c 88          	cmp    (%r8,%r9,4),%edi
 108ac94:	41 0f 92 c0          	setb   %r8b
 108ac98:	eb 08                	jmp    108aca2 <check_input_run+0xa992>
 108ac9a:	44 39 cf             	cmp    %r9d,%edi
 108ac9d:	72 03                	jb     108aca2 <check_input_run+0xa992>
 108ac9f:	45 31 c0             	xor    %r8d,%r8d
 108aca2:	45 88 44 3d 00       	mov    %r8b,0x0(%r13,%rdi,1)
 108aca7:	49 8b 7e 68          	mov    0x68(%r14),%rdi
 108acab:	4d 8b 56 50          	mov    0x50(%r14),%r10
 108acaf:	4d 8b 46 60          	mov    0x60(%r14),%r8
 108acb3:	8b 7c 8f f8          	mov    -0x8(%rdi,%rcx,4),%edi
 108acb7:	45 0f b6 1c 3a       	movzbl (%r10,%rdi,1),%r11d
 108acbc:	45 8b 0c b8          	mov    (%r8,%rdi,4),%r9d
 108acc0:	41 b0 01             	mov    $0x1,%r8b
 108acc3:	41 8d 6b bf          	lea    -0x41(%r11),%ebp
 108acc7:	83 fd 0e             	cmp    $0xe,%ebp
 108acca:	0f 86 49 ff ff ff    	jbe    108ac19 <check_input_run+0xa909>
 108acd0:	41 83 c3 f9          	add    $0xfffffff9,%r11d
 108acd4:	41 83 fb 02          	cmp    $0x2,%r11d
 108acd8:	0f 82 44 ff ff ff    	jb     108ac22 <check_input_run+0xa912>
 108acde:	41 39 d9             	cmp    %ebx,%r9d
 108ace1:	73 3c                	jae    108ad1f <check_input_run+0xaa0f>
 108ace3:	43 80 7c 0d 00 00    	cmpb   $0x0,0x0(%r13,%r9,1)
 108ace9:	74 34                	je     108ad1f <check_input_run+0xaa0f>
 108aceb:	47 0f b6 14 0a       	movzbl (%r10,%r9,1),%r10d
 108acf0:	41 83 c2 f9          	add    $0xfffffff9,%r10d
 108acf4:	41 83 fa 44          	cmp    $0x44,%r10d
 108acf8:	77 25                	ja     108ad1f <check_input_run+0xaa0f>
 108acfa:	4e 63 14 92          	movslq (%rdx,%r10,4),%r10
 108acfe:	49 01 d2             	add    %rdx,%r10
 108ad01:	41 ff e2             	jmp    *%r10
 108ad04:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
 108ad09:	43 3b 3c 88          	cmp    (%r8,%r9,4),%edi
 108ad0d:	41 0f 92 c0          	setb   %r8b
 108ad11:	e9 0c ff ff ff       	jmp    108ac22 <check_input_run+0xa912>
 108ad16:	44 39 cf             	cmp    %r9d,%edi
 108ad19:	0f 82 03 ff ff ff    	jb     108ac22 <check_input_run+0xa912>
 108ad1f:	45 31 c0             	xor    %r8d,%r8d
 108ad22:	e9 fb fe ff ff       	jmp    108ac22 <check_input_run+0xa912>
 108ad27:	4d 8b 46 10          	mov    0x10(%r14),%r8
 108ad2b:	43 80 3c 08 11       	cmpb   $0x11,(%r8,%r9,1)
 108ad30:	41 0f 94 c0          	sete   %r8b
 108ad34:	e9 69 ff ff ff       	jmp    108aca2 <check_input_run+0xa992>
 108ad39:	4d 8b 46 10          	mov    0x10(%r14),%r8
 108ad3d:	43 80 3c 08 11       	cmpb   $0x11,(%r8,%r9,1)
 108ad42:	41 0f 94 c0          	sete   %r8b
 108ad46:	e9 d7 fe ff ff       	jmp    108ac22 <check_input_run+0xa912>
 108ad4b:	48 8b 84 24 30 01 00 	mov    0x130(%rsp),%rax
 108ad52:	00 
 108ad53:	4c 89 ac 24 d0 00 00 	mov    %r13,0xd0(%rsp)
 108ad5a:	00 
 108ad5b:	44 8b 18             	mov    (%rax),%r11d
 108ad5e:	45 85 db             	test   %r11d,%r11d
 108ad61:	0f 84 3a 05 00 00    	je     108b2a1 <check_input_run+0xaf91>
 108ad67:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
 108ad6d:	45 31 ed             	xor    %r13d,%r13d
 108ad70:	31 ff                	xor    %edi,%edi
 108ad72:	eb 32                	jmp    108ada6 <check_input_run+0xaa96>
 108ad74:	48 8b 84 24 70 01 00 	mov    0x170(%rsp),%rax
 108ad7b:	00 
 108ad7c:	41 b2 03             	mov    $0x3,%r10b
 108ad7f:	41 89 41 10          	mov    %eax,0x10(%r9)
 108ad83:	48 8b 84 24 30 01 00 	mov    0x130(%rsp),%rax
 108ad8a:	00 
 108ad8b:	45 88 51 31          	mov    %r10b,0x31(%r9)
 108ad8f:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
 108ad94:	44 8b 18             	mov    (%rax),%r11d
 108ad97:	48 ff c7             	inc    %rdi
 108ad9a:	44 89 d8             	mov    %r11d,%eax
 108ad9d:	48 39 c7             	cmp    %rax,%rdi
 108ada0:	0f 83 fb 04 00 00    	jae    108b2a1 <check_input_run+0xaf91>
 108ada6:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
 108adab:	48 6b ef 34          	imul   $0x34,%rdi,%rbp
 108adaf:	4c 8b 08             	mov    (%rax),%r9
 108adb2:	45 8b 54 29 0c       	mov    0xc(%r9,%rbp,1),%r10d
 108adb7:	45 39 d5             	cmp    %r10d,%r13d
 108adba:	0f 83 61 02 00 00    	jae    108b021 <check_input_run+0xad11>
 108adc0:	49 8b 4e 50          	mov    0x50(%r14),%rcx
 108adc4:	44 89 d6             	mov    %r10d,%esi
 108adc7:	44 29 ee             	sub    %r13d,%esi
 108adca:	44 89 ea             	mov    %r13d,%edx
 108adcd:	48 89 d0             	mov    %rdx,%rax
 108add0:	83 e6 07             	and    $0x7,%esi
 108add3:	75 2c                	jne    108ae01 <check_input_run+0xaaf1>
 108add5:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
 108adda:	4c 29 d2             	sub    %r10,%rdx
 108addd:	45 89 d5             	mov    %r10d,%r13d
 108ade0:	48 83 fa f8          	cmp    $0xfffffffffffffff8,%rdx
 108ade4:	0f 87 37 02 00 00    	ja     108b021 <check_input_run+0xad11>
 108adea:	4d 89 d5             	mov    %r10,%r13
 108aded:	49 f7 dd             	neg    %r13
 108adf0:	48 83 c0 07          	add    $0x7,%rax
 108adf4:	eb 51                	jmp    108ae47 <check_input_run+0xab37>
 108adf6:	41 89 c0             	mov    %eax,%r8d
 108adf9:	48 ff c0             	inc    %rax
 108adfc:	48 ff ce             	dec    %rsi
 108adff:	74 d4                	je     108add5 <check_input_run+0xaac5>
 108ae01:	44 0f b6 24 01       	movzbl (%rcx,%rax,1),%r12d
 108ae06:	41 80 c4 c5          	add    $0xc5,%r12b
 108ae0a:	41 80 fc e7          	cmp    $0xe7,%r12b
 108ae0e:	73 e6                	jae    108adf6 <check_input_run+0xaae6>
 108ae10:	41 39 d8             	cmp    %ebx,%r8d
 108ae13:	73 e4                	jae    108adf9 <check_input_run+0xaae9>
 108ae15:	4d 8b 6e 60          	mov    0x60(%r14),%r13
 108ae19:	45 89 c4             	mov    %r8d,%r12d
 108ae1c:	47 8b 6c a5 00       	mov    0x0(%r13,%r12,4),%r13d
 108ae21:	4c 39 e8             	cmp    %r13,%rax
 108ae24:	75 d3                	jne    108adf9 <check_input_run+0xaae9>
 108ae26:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
 108ae2b:	47 8b 04 a0          	mov    (%r8,%r12,4),%r8d
 108ae2f:	eb c8                	jmp    108adf9 <check_input_run+0xaae9>
 108ae31:	41 89 c0             	mov    %eax,%r8d
 108ae34:	49 8d 54 05 08       	lea    0x8(%r13,%rax,1),%rdx
 108ae39:	48 83 c0 08          	add    $0x8,%rax
 108ae3d:	48 83 fa 07          	cmp    $0x7,%rdx
 108ae41:	0f 84 d7 01 00 00    	je     108b01e <check_input_run+0xad0e>
 108ae47:	0f b6 74 01 f9       	movzbl -0x7(%rcx,%rax,1),%esi
 108ae4c:	48 8d 50 f9          	lea    -0x7(%rax),%rdx
 108ae50:	40 80 c6 c5          	add    $0xc5,%sil
 108ae54:	40 80 fe e7          	cmp    $0xe7,%sil
 108ae58:	73 25                	jae    108ae7f <check_input_run+0xab6f>
 108ae5a:	41 39 d8             	cmp    %ebx,%r8d
 108ae5d:	73 23                	jae    108ae82 <check_input_run+0xab72>
 108ae5f:	4d 8b 66 60          	mov    0x60(%r14),%r12
 108ae63:	44 89 c6             	mov    %r8d,%esi
 108ae66:	45 8b 24 b4          	mov    (%r12,%rsi,4),%r12d
 108ae6a:	4c 39 e2             	cmp    %r12,%rdx
 108ae6d:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
 108ae72:	75 0e                	jne    108ae82 <check_input_run+0xab72>
 108ae74:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
 108ae79:	44 8b 04 b2          	mov    (%rdx,%rsi,4),%r8d
 108ae7d:	eb 03                	jmp    108ae82 <check_input_run+0xab72>
 108ae7f:	41 89 d0             	mov    %edx,%r8d
 108ae82:	0f b6 74 01 fa       	movzbl -0x6(%rcx,%rax,1),%esi
 108ae87:	48 8d 50 fa          	lea    -0x6(%rax),%rdx
 108ae8b:	40 80 c6 c5          	add    $0xc5,%sil
 108ae8f:	40 80 fe e7          	cmp    $0xe7,%sil
 108ae93:	73 25                	jae    108aeba <check_input_run+0xabaa>
 108ae95:	41 39 d8             	cmp    %ebx,%r8d
 108ae98:	73 23                	jae    108aebd <check_input_run+0xabad>
 108ae9a:	4d 8b 66 60          	mov    0x60(%r14),%r12
 108ae9e:	44 89 c6             	mov    %r8d,%esi
 108aea1:	45 8b 24 b4          	mov    (%r12,%rsi,4),%r12d
 108aea5:	4c 39 e2             	cmp    %r12,%rdx
 108aea8:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
 108aead:	75 0e                	jne    108aebd <check_input_run+0xabad>
 108aeaf:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
 108aeb4:	44 8b 04 b2          	mov    (%rdx,%rsi,4),%r8d
 108aeb8:	eb 03                	jmp    108aebd <check_input_run+0xabad>
 108aeba:	41 89 d0             	mov    %edx,%r8d
 108aebd:	0f b6 74 01 fb       	movzbl -0x5(%rcx,%rax,1),%esi
 108aec2:	48 8d 50 fb          	lea    -0x5(%rax),%rdx
 108aec6:	40 80 c6 c5          	add    $0xc5,%sil
 108aeca:	40 80 fe e7          	cmp    $0xe7,%sil
 108aece:	73 25                	jae    108aef5 <check_input_run+0xabe5>
 108aed0:	41 39 d8             	cmp    %ebx,%r8d
 108aed3:	73 23                	jae    108aef8 <check_input_run+0xabe8>
 108aed5:	4d 8b 66 60          	mov    0x60(%r14),%r12
 108aed9:	44 89 c6             	mov    %r8d,%esi
 108aedc:	45 8b 24 b4          	mov    (%r12,%rsi,4),%r12d
 108aee0:	4c 39 e2             	cmp    %r12,%rdx
 108aee3:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
 108aee8:	75 0e                	jne    108aef8 <check_input_run+0xabe8>
 108aeea:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
 108aeef:	44 8b 04 b2          	mov    (%rdx,%rsi,4),%r8d
 108aef3:	eb 03                	jmp    108aef8 <check_input_run+0xabe8>
 108aef5:	41 89 d0             	mov    %edx,%r8d
 108aef8:	0f b6 74 01 fc       	movzbl -0x4(%rcx,%rax,1),%esi
 108aefd:	48 8d 50 fc          	lea    -0x4(%rax),%rdx
 108af01:	40 80 c6 c5          	add    $0xc5,%sil
 108af05:	40 80 fe e7          	cmp    $0xe7,%sil
 108af09:	73 25                	jae    108af30 <check_input_run+0xac20>
 108af0b:	41 39 d8             	cmp    %ebx,%r8d
 108af0e:	73 23                	jae    108af33 <check_input_run+0xac23>
 108af10:	4d 8b 66 60          	mov    0x60(%r14),%r12
 108af14:	44 89 c6             	mov    %r8d,%esi
 108af17:	45 8b 24 b4          	mov    (%r12,%rsi,4),%r12d
 108af1b:	4c 39 e2             	cmp    %r12,%rdx
 108af1e:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
 108af23:	75 0e                	jne    108af33 <check_input_run+0xac23>
 108af25:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
 108af2a:	44 8b 04 b2          	mov    (%rdx,%rsi,4),%r8d
 108af2e:	eb 03                	jmp    108af33 <check_input_run+0xac23>
 108af30:	41 89 d0             	mov    %edx,%r8d
 108af33:	0f b6 74 01 fd       	movzbl -0x3(%rcx,%rax,1),%esi
 108af38:	48 8d 50 fd          	lea    -0x3(%rax),%rdx
 108af3c:	40 80 c6 c5          	add    $0xc5,%sil
 108af40:	40 80 fe e7          	cmp    $0xe7,%sil
 108af44:	73 25                	jae    108af6b <check_input_run+0xac5b>
 108af46:	41 39 d8             	cmp    %ebx,%r8d
 108af49:	73 23                	jae    108af6e <check_input_run+0xac5e>
 108af4b:	4d 8b 66 60          	mov    0x60(%r14),%r12
 108af4f:	44 89 c6             	mov    %r8d,%esi
 108af52:	45 8b 24 b4          	mov    (%r12,%rsi,4),%r12d
 108af56:	4c 39 e2             	cmp    %r12,%rdx
 108af59:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
 108af5e:	75 0e                	jne    108af6e <check_input_run+0xac5e>
 108af60:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
 108af65:	44 8b 04 b2          	mov    (%rdx,%rsi,4),%r8d
 108af69:	eb 03                	jmp    108af6e <check_input_run+0xac5e>
 108af6b:	41 89 d0             	mov    %edx,%r8d
 108af6e:	0f b6 74 01 fe       	movzbl -0x2(%rcx,%rax,1),%esi
 108af73:	48 8d 50 fe          	lea    -0x2(%rax),%rdx
 108af77:	40 80 c6 c5          	add    $0xc5,%sil
 108af7b:	40 80 fe e7          	cmp    $0xe7,%sil
 108af7f:	73 25                	jae    108afa6 <check_input_run+0xac96>
 108af81:	41 39 d8             	cmp    %ebx,%r8d
 108af84:	73 23                	jae    108afa9 <check_input_run+0xac99>
 108af86:	4d 8b 66 60          	mov    0x60(%r14),%r12
 108af8a:	44 89 c6             	mov    %r8d,%esi
 108af8d:	45 8b 24 b4          	mov    (%r12,%rsi,4),%r12d
 108af91:	4c 39 e2             	cmp    %r12,%rdx
 108af94:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
 108af99:	75 0e                	jne    108afa9 <check_input_run+0xac99>
 108af9b:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
 108afa0:	44 8b 04 b2          	mov    (%rdx,%rsi,4),%r8d
 108afa4:	eb 03                	jmp    108afa9 <check_input_run+0xac99>
 108afa6:	41 89 d0             	mov    %edx,%r8d
 108afa9:	0f b6 74 01 ff       	movzbl -0x1(%rcx,%rax,1),%esi
 108afae:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
 108afb2:	40 80 c6 c5          	add    $0xc5,%sil
 108afb6:	40 80 fe e7          	cmp    $0xe7,%sil
 108afba:	73 25                	jae    108afe1 <check_input_run+0xacd1>
 108afbc:	41 39 d8             	cmp    %ebx,%r8d
 108afbf:	73 23                	jae    108afe4 <check_input_run+0xacd4>
 108afc1:	4d 8b 66 60          	mov    0x60(%r14),%r12
 108afc5:	44 89 c6             	mov    %r8d,%esi
 108afc8:	45 8b 24 b4          	mov    (%r12,%rsi,4),%r12d
 108afcc:	4c 39 e2             	cmp    %r12,%rdx
 108afcf:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
 108afd4:	75 0e                	jne    108afe4 <check_input_run+0xacd4>
 108afd6:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
 108afdb:	44 8b 04 b2          	mov    (%rdx,%rsi,4),%r8d
 108afdf:	eb 03                	jmp    108afe4 <check_input_run+0xacd4>
 108afe1:	41 89 d0             	mov    %edx,%r8d
 108afe4:	0f b6 14 01          	movzbl (%rcx,%rax,1),%edx
 108afe8:	80 c2 c5             	add    $0xc5,%dl
 108afeb:	80 fa e7             	cmp    $0xe7,%dl
 108afee:	0f 83 3d fe ff ff    	jae    108ae31 <check_input_run+0xab21>
 108aff4:	41 39 d8             	cmp    %ebx,%r8d
 108aff7:	0f 83 37 fe ff ff    	jae    108ae34 <check_input_run+0xab24>
 108affd:	49 8b 76 60          	mov    0x60(%r14),%rsi
 108b001:	44 89 c2             	mov    %r8d,%edx
 108b004:	8b 34 96             	mov    (%rsi,%rdx,4),%esi
 108b007:	48 39 f0             	cmp    %rsi,%rax
 108b00a:	0f 85 24 fe ff ff    	jne    108ae34 <check_input_run+0xab24>
 108b010:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
 108b015:	44 8b 04 96          	mov    (%rsi,%rdx,4),%r8d
 108b019:	e9 16 fe ff ff       	jmp    108ae34 <check_input_run+0xab24>
 108b01e:	45 89 d5             	mov    %r10d,%r13d
 108b021:	49 01 e9             	add    %rbp,%r9
 108b024:	41 80 79 31 01       	cmpb   $0x1,0x31(%r9)
 108b029:	0f 85 68 fd ff ff    	jne    108ad97 <check_input_run+0xaa87>
 108b02f:	45 85 d2             	test   %r10d,%r10d
 108b032:	0f 84 5f fd ff ff    	je     108ad97 <check_input_run+0xaa87>
 108b038:	41 0f b6 41 30       	movzbl 0x30(%r9),%eax
 108b03d:	24 01                	and    $0x1,%al
 108b03f:	0f 85 52 fd ff ff    	jne    108ad97 <check_input_run+0xaa87>
 108b045:	49 8b 56 60          	mov    0x60(%r14),%rdx
 108b049:	41 8d 42 ff          	lea    -0x1(%r10),%eax
 108b04d:	49 8b 4e 50          	mov    0x50(%r14),%rcx
 108b051:	45 31 e4             	xor    %r12d,%r12d
 108b054:	8b 34 82             	mov    (%rdx,%rax,4),%esi
 108b057:	39 de                	cmp    %ebx,%esi
 108b059:	73 05                	jae    108b060 <check_input_run+0xad50>
 108b05b:	44 0f b6 24 31       	movzbl (%rcx,%rsi,1),%r12d
 108b060:	48 89 b4 24 b0 00 00 	mov    %rsi,0xb0(%rsp)
 108b067:	00 
 108b068:	41 39 d8             	cmp    %ebx,%r8d
 108b06b:	73 2e                	jae    108b09b <check_input_run+0xad8b>
 108b06d:	45 89 c3             	mov    %r8d,%r11d
 108b070:	42 0f b6 34 19       	movzbl (%rcx,%r11,1),%esi
 108b075:	83 fe 24             	cmp    $0x24,%esi
 108b078:	74 25                	je     108b09f <check_input_run+0xad8f>
 108b07a:	83 fe 23             	cmp    $0x23,%esi
 108b07d:	75 27                	jne    108b0a6 <check_input_run+0xad96>
 108b07f:	42 8b 14 9a          	mov    (%rdx,%r11,4),%edx
 108b083:	39 da                	cmp    %ebx,%edx
 108b085:	73 14                	jae    108b09b <check_input_run+0xad8b>
 108b087:	48 8b b4 24 d0 00 00 	mov    0xd0(%rsp),%rsi
 108b08e:	00 
 108b08f:	80 3c 16 00          	cmpb   $0x0,(%rsi,%rdx,1)
 108b093:	41 0f 95 c3          	setne  %r11b
 108b097:	31 f6                	xor    %esi,%esi
 108b099:	eb 1a                	jmp    108b0b5 <check_input_run+0xada5>
 108b09b:	31 f6                	xor    %esi,%esi
 108b09d:	eb 13                	jmp    108b0b2 <check_input_run+0xada2>
 108b09f:	31 f6                	xor    %esi,%esi
 108b0a1:	41 b3 01             	mov    $0x1,%r11b
 108b0a4:	eb 0f                	jmp    108b0b5 <check_input_run+0xada5>
 108b0a6:	40 80 c6 cd          	add    $0xcd,%sil
 108b0aa:	40 80 fe 03          	cmp    $0x3,%sil
 108b0ae:	40 0f 92 c6          	setb   %sil
 108b0b2:	45 31 db             	xor    %r11d,%r11d
 108b0b5:	49 8b 6e 10          	mov    0x10(%r14),%rbp
 108b0b9:	0f b6 14 01          	movzbl (%rcx,%rax,1),%edx
 108b0bd:	41 83 f8 ff          	cmp    $0xffffffff,%r8d
 108b0c1:	48 89 84 24 70 01 00 	mov    %rax,0x170(%rsp)
 108b0c8:	00 
 108b0c9:	0f b6 4c 05 00       	movzbl 0x0(%rbp,%rax,1),%ecx
 108b0ce:	48 89 ac 24 a0 00 00 	mov    %rbp,0xa0(%rsp)
 108b0d5:	00 
 108b0d6:	40 0f 94 c5          	sete   %bpl
 108b0da:	48 89 54 24 68       	mov    %rdx,0x68(%rsp)
 108b0df:	b8 01 00 00 00       	mov    $0x1,%eax
 108b0e4:	83 c2 bf             	add    $0xffffffbf,%edx
 108b0e7:	40 08 f5             	or     %sil,%bpl
 108b0ea:	83 fa 0e             	cmp    $0xe,%edx
 108b0ed:	77 12                	ja     108b101 <check_input_run+0xadf1>
 108b0ef:	44 89 e6             	mov    %r12d,%esi
 108b0f2:	41 bc 05 60 00 00    	mov    $0x6005,%r12d
 108b0f8:	41 0f a3 d4          	bt     %edx,%r12d
 108b0fc:	41 89 f4             	mov    %esi,%r12d
 108b0ff:	72 0d                	jb     108b10e <check_input_run+0xadfe>
 108b101:	48 8b 54 24 68       	mov    0x68(%rsp),%rdx
 108b106:	83 c2 f9             	add    $0xfffffff9,%edx
 108b109:	83 fa 02             	cmp    $0x2,%edx
 108b10c:	73 3f                	jae    108b14d <check_input_run+0xae3d>
 108b10e:	80 c1 cb             	add    $0xcb,%cl
 108b111:	80 f9 02             	cmp    $0x2,%cl
 108b114:	0f 82 5a fc ff ff    	jb     108ad74 <check_input_run+0xaa64>
 108b11a:	85 c0                	test   %eax,%eax
 108b11c:	41 89 c3             	mov    %eax,%r11d
 108b11f:	0f 94 c1             	sete   %cl
 108b122:	41 39 da             	cmp    %ebx,%r10d
 108b125:	0f 83 d9 00 00 00    	jae    108b204 <check_input_run+0xaef4>
 108b12b:	48 8b 94 24 a0 00 00 	mov    0xa0(%rsp),%rdx
 108b132:	00 
 108b133:	41 89 c3             	mov    %eax,%r11d
 108b136:	42 80 3c 12 48       	cmpb   $0x48,(%rdx,%r10,1)
 108b13b:	0f 85 c3 00 00 00    	jne    108b204 <check_input_run+0xaef4>
 108b141:	45 89 51 10          	mov    %r10d,0x10(%r9)
 108b145:	41 b2 03             	mov    $0x3,%r10b
 108b148:	e9 36 fc ff ff       	jmp    108ad83 <check_input_run+0xaa73>
 108b14d:	45 84 db             	test   %r11b,%r11b
 108b150:	74 1b                	je     108b16d <check_input_run+0xae5d>
 108b152:	83 7c 24 68 24       	cmpl   $0x24,0x68(%rsp)
 108b157:	77 14                	ja     108b16d <check_input_run+0xae5d>
 108b159:	8b 54 24 68          	mov    0x68(%rsp),%edx
 108b15d:	49 bb 00 00 00 10 18 	movabs $0x1810000000,%r11
 108b164:	00 00 00 
 108b167:	49 0f a3 d3          	bt     %rdx,%r11
 108b16b:	72 a1                	jb     108b10e <check_input_run+0xadfe>
 108b16d:	31 d2                	xor    %edx,%edx
 108b16f:	40 84 ed             	test   %bpl,%bpl
 108b172:	74 3e                	je     108b1b2 <check_input_run+0xaea2>
 108b174:	48 8b 54 24 68       	mov    0x68(%rsp),%rdx
 108b179:	44 8d 5a e2          	lea    -0x1e(%rdx),%r11d
 108b17d:	41 80 fb 36          	cmp    $0x36,%r11b
 108b181:	73 18                	jae    108b19b <check_input_run+0xae8b>
 108b183:	41 0f b6 d3          	movzbl %r11b,%edx
 108b187:	48 be 0f 00 e0 00 00 	movabs $0x20d00000e0000f,%rsi
 108b18e:	d0 20 00 
 108b191:	48 0f a3 d6          	bt     %rdx,%rsi
 108b195:	0f 82 73 ff ff ff    	jb     108b10e <check_input_run+0xadfe>
 108b19b:	83 7c 24 68 49       	cmpl   $0x49,0x68(%rsp)
 108b1a0:	0f 94 c2             	sete   %dl
 108b1a3:	41 83 fc 1e          	cmp    $0x1e,%r12d
 108b1a7:	40 0f 95 c6          	setne  %sil
 108b1ab:	40 20 d6             	and    %dl,%sil
 108b1ae:	40 0f b6 d6          	movzbl %sil,%edx
 108b1b2:	80 f9 02             	cmp    $0x2,%cl
 108b1b5:	0f 85 c2 00 00 00    	jne    108b27d <check_input_run+0xaf6d>
 108b1bb:	80 7c 24 68 06       	cmpb   $0x6,0x68(%rsp)
 108b1c0:	0f 85 b7 00 00 00    	jne    108b27d <check_input_run+0xaf6d>
 108b1c6:	44 89 e6             	mov    %r12d,%esi
 108b1c9:	83 e6 fe             	and    $0xfffffffe,%esi
 108b1cc:	31 c9                	xor    %ecx,%ecx
 108b1ce:	89 d0                	mov    %edx,%eax
 108b1d0:	83 fe 4e             	cmp    $0x4e,%esi
 108b1d3:	0f 94 c1             	sete   %cl
 108b1d6:	09 c8                	or     %ecx,%eax
 108b1d8:	0f 94 c1             	sete   %cl
 108b1db:	41 39 da             	cmp    %ebx,%r10d
 108b1de:	73 18                	jae    108b1f8 <check_input_run+0xaee8>
 108b1e0:	83 fe 4e             	cmp    $0x4e,%esi
 108b1e3:	75 13                	jne    108b1f8 <check_input_run+0xaee8>
 108b1e5:	48 8b 94 24 a0 00 00 	mov    0xa0(%rsp),%rdx
 108b1ec:	00 
 108b1ed:	42 80 3c 12 0a       	cmpb   $0xa,(%rdx,%r10,1)
 108b1f2:	0f 84 49 ff ff ff    	je     108b141 <check_input_run+0xae31>
 108b1f8:	41 89 c3             	mov    %eax,%r11d
 108b1fb:	41 39 da             	cmp    %ebx,%r10d
 108b1fe:	0f 82 27 ff ff ff    	jb     108b12b <check_input_run+0xae1b>
 108b204:	48 8b 94 24 b0 00 00 	mov    0xb0(%rsp),%rdx
 108b20b:	00 
 108b20c:	39 da                	cmp    %ebx,%edx
 108b20e:	73 15                	jae    108b225 <check_input_run+0xaf15>
 108b210:	48 8b b4 24 a0 00 00 	mov    0xa0(%rsp),%rsi
 108b217:	00 
 108b218:	41 b2 03             	mov    $0x3,%r10b
 108b21b:	80 3c 16 4d          	cmpb   $0x4d,(%rsi,%rdx,1)
 108b21f:	0f 84 5e fb ff ff    	je     108ad83 <check_input_run+0xaa73>
 108b225:	83 7c 24 68 49       	cmpl   $0x49,0x68(%rsp)
 108b22a:	75 0a                	jne    108b236 <check_input_run+0xaf26>
 108b22c:	41 83 fc 1e          	cmp    $0x1e,%r12d
 108b230:	0f 84 3e fb ff ff    	je     108ad74 <check_input_run+0xaa64>
 108b236:	48 8b 84 24 70 01 00 	mov    0x170(%rsp),%rax
 108b23d:	00 
 108b23e:	40 20 cd             	and    %cl,%bpl
 108b241:	40 80 fd 01          	cmp    $0x1,%bpl
 108b245:	75 21                	jne    108b268 <check_input_run+0xaf58>
 108b247:	48 8b 4c 24 68       	mov    0x68(%rsp),%rcx
 108b24c:	83 c1 fe             	add    $0xfffffffe,%ecx
 108b24f:	83 f9 4f             	cmp    $0x4f,%ecx
 108b252:	77 30                	ja     108b284 <check_input_run+0xaf74>
 108b254:	48 8d 15 bd 33 41 ff 	lea    -0xbecc43(%rip),%rdx        # 49e618 <cbuiltin_test_generated.edges+0x3e98>
 108b25b:	48 63 0c 8a          	movslq (%rdx,%rcx,4),%rcx
 108b25f:	48 01 d1             	add    %rdx,%rcx
 108b262:	ff e1                	jmp    *%rcx
 108b264:	41 89 41 10          	mov    %eax,0x10(%r9)
 108b268:	41 b2 03             	mov    $0x3,%r10b
 108b26b:	41 f6 c3 01          	test   $0x1,%r11b
 108b26f:	0f 84 0e fb ff ff    	je     108ad83 <check_input_run+0xaa73>
 108b275:	41 b2 01             	mov    $0x1,%r10b
 108b278:	e9 06 fb ff ff       	jmp    108ad83 <check_input_run+0xaa73>
 108b27d:	89 d0                	mov    %edx,%eax
 108b27f:	e9 8a fe ff ff       	jmp    108b10e <check_input_run+0xadfe>
 108b284:	48 8b 4c 24 68       	mov    0x68(%rsp),%rcx
 108b289:	80 e1 fe             	and    $0xfe,%cl
 108b28c:	80 f9 3c             	cmp    $0x3c,%cl
 108b28f:	75 d7                	jne    108b268 <check_input_run+0xaf58>
 108b291:	48 8b 8c 24 d0 00 00 	mov    0xd0(%rsp),%rcx
 108b298:	00 
 108b299:	80 3c 01 00          	cmpb   $0x0,(%rcx,%rax,1)
 108b29d:	75 c9                	jne    108b268 <check_input_run+0xaf58>
 108b29f:	eb c3                	jmp    108b264 <check_input_run+0xaf54>
 108b2a1:	48 8b 84 24 60 02 00 	mov    0x260(%rsp),%rax
 108b2a8:	00 
 108b2a9:	48 8b 7c 24 60       	mov    0x60(%rsp),%rdi
 108b2ae:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
 108b2b5:	00 
 108b2b6:	4c 8b 4c 24 40       	mov    0x40(%rsp),%r9
 108b2bb:	48 89 b8 c0 01 00 00 	mov    %rdi,0x1c0(%rax)
 108b2c2:	48 89 88 c8 01 00 00 	mov    %rcx,0x1c8(%rax)
 108b2c9:	83 7f 08 00          	cmpl   $0x0,0x8(%rdi)
 108b2cd:	74 22                	je     108b2f1 <check_input_run+0xafe1>
 108b2cf:	31 c0                	xor    %eax,%eax
 108b2d1:	31 c9                	xor    %ecx,%ecx
 108b2d3:	48 8b 17             	mov    (%rdi),%rdx
 108b2d6:	48 ff c1             	inc    %rcx
 108b2d9:	0f b6 74 02 31       	movzbl 0x31(%rdx,%rax,1),%esi
 108b2de:	8b 14 02             	mov    (%rdx,%rax,1),%edx
 108b2e1:	48 83 c0 34          	add    $0x34,%rax
 108b2e5:	41 88 34 17          	mov    %sil,(%r15,%rdx,1)
 108b2e9:	8b 57 08             	mov    0x8(%rdi),%edx
 108b2ec:	48 39 d1             	cmp    %rdx,%rcx
 108b2ef:	72 e2                	jb     108b2d3 <check_input_run+0xafc3>
 108b2f1:	48 8b 84 24 88 02 00 	mov    0x288(%rsp),%rax
 108b2f8:	00 
 108b2f9:	48 8d bc 24 60 02 00 	lea    0x260(%rsp),%rdi
 108b300:	00 
 108b301:	4c 89 fe             	mov    %r15,%rsi
 108b304:	4c 89 48 08          	mov    %r9,0x8(%rax)
 108b308:	e8 a3 1a 00 00       	call   108cdb0 <check_input_fp_pragmas>
 108b30d:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
 108b312:	34 01                	xor    $0x1,%al
 108b314:	08 81 bd 03 00 00    	or     %al,0x3bd(%rcx)
 108b31a:	84 c0                	test   %al,%al
 108b31c:	0f 85 3b a1 ff ff    	jne    108545d <check_input_run+0x514d>
 108b322:	41 8b 74 24 48       	mov    0x48(%r12),%esi
 108b327:	48 85 f6             	test   %rsi,%rsi
 108b32a:	0f 84 2d a1 ff ff    	je     108545d <check_input_run+0x514d>
 108b330:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 108b335:	49 8b 7c 24 40       	mov    0x40(%r12),%rdi
 108b33a:	31 d2                	xor    %edx,%edx
 108b33c:	31 c9                	xor    %ecx,%ecx
 108b33e:	48 8b 80 c0 01 00 00 	mov    0x1c0(%rax),%rax
 108b345:	eb 0c                	jmp    108b353 <check_input_run+0xb043>
 108b347:	48 ff c1             	inc    %rcx
 108b34a:	48 39 f1             	cmp    %rsi,%rcx
 108b34d:	0f 84 0a a1 ff ff    	je     108545d <check_input_run+0x514d>
 108b353:	48 85 c0             	test   %rax,%rax
 108b356:	74 2f                	je     108b387 <check_input_run+0xb077>
 108b358:	44 8b 40 08          	mov    0x8(%rax),%r8d
 108b35c:	44 39 c2             	cmp    %r8d,%edx
 108b35f:	73 26                	jae    108b387 <check_input_run+0xb077>
 108b361:	89 d2                	mov    %edx,%edx
 108b363:	4c 6b ca 34          	imul   $0x34,%rdx,%r9
 108b367:	4c 03 08             	add    (%rax),%r9
 108b36a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
 108b370:	45 8b 11             	mov    (%r9),%r10d
 108b373:	4c 39 d1             	cmp    %r10,%rcx
 108b376:	76 0f                	jbe    108b387 <check_input_run+0xb077>
 108b378:	48 ff c2             	inc    %rdx
 108b37b:	49 83 c1 34          	add    $0x34,%r9
 108b37f:	49 39 d0             	cmp    %rdx,%r8
 108b382:	75 ec                	jne    108b370 <check_input_run+0xb060>
 108b384:	44 89 c2             	mov    %r8d,%edx
 108b387:	44 8b 04 8f          	mov    (%rdi,%rcx,4),%r8d
 108b38b:	45 0f b6 0c 0f       	movzbl (%r15,%rcx,1),%r9d
 108b390:	41 83 f9 03          	cmp    $0x3,%r9d
 108b394:	74 05                	je     108b39b <check_input_run+0xb08b>
 108b396:	45 85 c9             	test   %r9d,%r9d
 108b399:	75 ac                	jne    108b347 <check_input_run+0xb037>
 108b39b:	48 83 bc 24 20 07 00 	cmpq   $0x0,0x720(%rsp)
 108b3a2:	00 00 
 108b3a4:	75 18                	jne    108b3be <check_input_run+0xb0ae>
 108b3a6:	4c 8b 4c 24 08       	mov    0x8(%rsp),%r9
 108b3ab:	4d 8b 89 f0 01 00 00 	mov    0x1f0(%r9),%r9
 108b3b2:	4d 85 c9             	test   %r9,%r9
 108b3b5:	74 07                	je     108b3be <check_input_run+0xb0ae>
 108b3b7:	43 80 3c 01 00       	cmpb   $0x0,(%r9,%r8,1)
 108b3bc:	75 89                	jne    108b347 <check_input_run+0xb037>
 108b3be:	44 89 84 24 20 06 00 	mov    %r8d,0x620(%rsp)
 108b3c5:	00 
 108b3c6:	89 8c 24 24 06 00 00 	mov    %ecx,0x624(%rsp)
 108b3cd:	31 f6                	xor    %esi,%esi
 108b3cf:	41 80 3c 0f 03       	cmpb   $0x3,(%r15,%rcx,1)
 108b3d4:	40 0f 94 c6          	sete   %sil
 108b3d8:	89 b4 24 2c 06 00 00 	mov    %esi,0x62c(%rsp)
 108b3df:	48 85 c0             	test   %rax,%rax
 108b3e2:	0f 84 75 a0 ff ff    	je     108545d <check_input_run+0x514d>
 108b3e8:	3b 50 08             	cmp    0x8(%rax),%edx
 108b3eb:	0f 83 6c a0 ff ff    	jae    108545d <check_input_run+0x514d>
 108b3f1:	48 8b 00             	mov    (%rax),%rax
 108b3f4:	89 d2                	mov    %edx,%edx
 108b3f6:	48 6b d2 34          	imul   $0x34,%rdx,%rdx
 108b3fa:	39 0c 10             	cmp    %ecx,(%rax,%rdx,1)
 108b3fd:	0f 85 5a a0 ff ff    	jne    108545d <check_input_run+0x514d>
 108b403:	48 01 d0             	add    %rdx,%rax
 108b406:	8b 40 10             	mov    0x10(%rax),%eax
 108b409:	89 84 24 28 06 00 00 	mov    %eax,0x628(%rsp)
 108b410:	e9 48 a0 ff ff       	jmp    108545d <check_input_run+0x514d>
 108b415:	48 89 c7             	mov    %rax,%rdi
 108b418:	4c 29 c7             	sub    %r8,%rdi
 108b41b:	4c 8b 46 10          	mov    0x10(%rsi),%r8
 108b41f:	49 29 f8             	sub    %rdi,%r8
 108b422:	0f 82 b2 00 00 00    	jb     108b4da <check_input_run+0xb1ca>
 108b428:	48 c1 e2 02          	shl    $0x2,%rdx
 108b42c:	4c 39 c2             	cmp    %r8,%rdx
 108b42f:	0f 87 a5 00 00 00    	ja     108b4da <check_input_run+0xb1ca>
 108b435:	48 01 d7             	add    %rdx,%rdi
 108b438:	48 89 7e 08          	mov    %rdi,0x8(%rsi)
 108b43c:	48 85 c0             	test   %rax,%rax
 108b43f:	0f 84 ba 9f ff ff    	je     10853ff <check_input_run+0x50ef>
 108b445:	4c 89 f1             	mov    %r14,%rcx
 108b448:	48 c1 e9 3d          	shr    $0x3d,%rcx
 108b44c:	75 49                	jne    108b497 <check_input_run+0xb187>
 108b44e:	48 8b 8c 24 88 02 00 	mov    0x288(%rsp),%rcx
 108b455:	00 
 108b456:	48 8b 39             	mov    (%rcx),%rdi
 108b459:	48 8b 51 08          	mov    0x8(%rcx),%rdx
 108b45d:	48 8d 74 3a 03       	lea    0x3(%rdx,%rdi,1),%rsi
 108b462:	48 01 fa             	add    %rdi,%rdx
 108b465:	48 83 e6 fc          	and    $0xfffffffffffffffc,%rsi
 108b469:	48 39 d6             	cmp    %rdx,%rsi
 108b46c:	72 29                	jb     108b497 <check_input_run+0xb187>
 108b46e:	48 89 f5             	mov    %rsi,%rbp
 108b471:	48 29 fe             	sub    %rdi,%rsi
 108b474:	48 8b 79 10          	mov    0x10(%rcx),%rdi
 108b478:	4a 8d 14 f5 00 00 00 	lea    0x0(,%r14,8),%rdx
 108b47f:	00 
 108b480:	48 29 f7             	sub    %rsi,%rdi
 108b483:	41 0f 92 c0          	setb   %r8b
 108b487:	48 39 fa             	cmp    %rdi,%rdx
 108b48a:	40 0f 97 c7          	seta   %dil
 108b48e:	44 08 c7             	or     %r8b,%dil
 108b491:	0f 84 80 00 00 00    	je     108b517 <check_input_run+0xb207>
 108b497:	31 c9                	xor    %ecx,%ecx
 108b499:	49 89 c5             	mov    %rax,%r13
 108b49c:	e9 61 9f ff ff       	jmp    1085402 <check_input_run+0x50f2>
 108b4a1:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
 108b4a6:	48 01 d6             	add    %rdx,%rsi
 108b4a9:	48 89 70 08          	mov    %rsi,0x8(%rax)
 108b4ad:	48 89 bc 24 c0 05 00 	mov    %rdi,0x5c0(%rsp)
 108b4b4:	00 
 108b4b5:	48 85 ff             	test   %rdi,%rdi
 108b4b8:	74 34                	je     108b4ee <check_input_run+0xb1de>
 108b4ba:	48 8b 84 24 18 01 00 	mov    0x118(%rsp),%rax
 108b4c1:	00 
 108b4c2:	31 f6                	xor    %esi,%esi
 108b4c4:	8b 90 a4 00 00 00    	mov    0xa4(%rax),%edx
 108b4ca:	48 c1 e2 02          	shl    $0x2,%rdx
 108b4ce:	c5 f8 77             	vzeroupper
 108b4d1:	e8 aa 3a 70 ff       	call   78ef80 <memset@plt>
 108b4d6:	b3 01                	mov    $0x1,%bl
 108b4d8:	eb 16                	jmp    108b4f0 <check_input_run+0xb1e0>
 108b4da:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
 108b4df:	4c 8b 4c 24 40       	mov    0x40(%rsp),%r9
 108b4e4:	31 ff                	xor    %edi,%edi
 108b4e6:	45 31 ed             	xor    %r13d,%r13d
 108b4e9:	e9 44 90 ff ff       	jmp    1084532 <check_input_run+0x4222>
 108b4ee:	31 db                	xor    %ebx,%ebx
 108b4f0:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
 108b4f5:	e9 70 7d ff ff       	jmp    108326a <check_input_run+0x2f5a>
 108b4fa:	39 f1                	cmp    %esi,%ecx
 108b4fc:	0f 83 ef f6 ff ff    	jae    108abf1 <check_input_run+0xa8e1>
 108b502:	e9 ec f6 ff ff       	jmp    108abf3 <check_input_run+0xa8e3>
 108b507:	49 8b 56 10          	mov    0x10(%r14),%rdx
 108b50b:	80 3c 32 11          	cmpb   $0x11,(%rdx,%rsi,1)
 108b50f:	0f 94 c2             	sete   %dl
 108b512:	e9 dc f6 ff ff       	jmp    108abf3 <check_input_run+0xa8e3>
 108b517:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
 108b51c:	4c 8b 4c 24 40       	mov    0x40(%rsp),%r9
 108b521:	48 01 d6             	add    %rdx,%rsi
 108b524:	49 89 c5             	mov    %rax,%r13
 108b527:	48 89 ef             	mov    %rbp,%rdi
 108b52a:	48 89 71 08          	mov    %rsi,0x8(%rcx)
 108b52e:	31 c9                	xor    %ecx,%ecx
 108b530:	e9 fd 8f ff ff       	jmp    1084532 <check_input_run+0x4222>
 108b535:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
 108b53a:	48 8b 3c 24          	mov    (%rsp),%rdi
 108b53e:	4c 8b 44 24 08       	mov    0x8(%rsp),%r8
 108b543:	48 ff c2             	inc    %rdx
 108b546:	48 01 d6             	add    %rdx,%rsi
 108b549:	48 89 77 08          	mov    %rsi,0x8(%rdi)
 108b54d:	49 8d b8 68 02 00 00 	lea    0x268(%r8),%rdi
 108b554:	49 89 88 68 02 00 00 	mov    %rcx,0x268(%r8)
 108b55b:	48 89 7c 24 30       	mov    %rdi,0x30(%rsp)
 108b560:	48 85 c9             	test   %rcx,%rcx
 108b563:	74 43                	je     108b5a8 <check_input_run+0xb298>
 108b565:	48 8b 0c 24          	mov    (%rsp),%rcx
 108b569:	48 8b 39             	mov    (%rcx),%rdi
 108b56c:	48 8b 71 08          	mov    0x8(%rcx),%rsi
 108b570:	48 8d 4c 3e 07       	lea    0x7(%rsi,%rdi,1),%rcx
 108b575:	48 01 fe             	add    %rdi,%rsi
 108b578:	48 83 e1 f8          	and    $0xfffffffffffffff8,%rcx
 108b57c:	48 39 f1             	cmp    %rsi,%rcx
 108b57f:	72 27                	jb     108b5a8 <check_input_run+0xb298>
 108b581:	48 89 ce             	mov    %rcx,%rsi
 108b584:	48 29 fe             	sub    %rdi,%rsi
 108b587:	48 8b 3c 24          	mov    (%rsp),%rdi
 108b58b:	48 8b 7f 10          	mov    0x10(%rdi),%rdi
 108b58f:	48 29 f7             	sub    %rsi,%rdi
 108b592:	41 0f 92 c0          	setb   %r8b
 108b596:	48 3b 7c 24 58       	cmp    0x58(%rsp),%rdi
 108b59b:	40 0f 96 c7          	setbe  %dil
 108b59f:	44 08 c7             	or     %r8b,%dil
 108b5a2:	40 80 ff 01          	cmp    $0x1,%dil
 108b5a6:	75 4c                	jne    108b5f4 <check_input_run+0xb2e4>
 108b5a8:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
 108b5ad:	48 8b 34 24          	mov    (%rsp),%rsi
 108b5b1:	4c 8b 74 24 10       	mov    0x10(%rsp),%r14
 108b5b6:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
 108b5bb:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
 108b5c0:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
 108b5c5:	e9 b9 55 ff ff       	jmp    1080b83 <check_input_run+0x873>
 108b5ca:	48 8d 3d 83 20 67 ff 	lea    -0x98df7d(%rip),%rdi        # 6fd654 <pp_string_value.meaning+0x705cf>
 108b5d1:	48 8d 35 86 ac 62 ff 	lea    -0x9d537a(%rip),%rsi        # 6b625e <pp_string_value.meaning+0x291d9>
 108b5d8:	48 8d 0d 9a ac 62 ff 	lea    -0x9d5366(%rip),%rcx        # 6b6279 <pp_string_value.meaning+0x291f4>
 108b5df:	ba bf 00 00 00       	mov    $0xbf,%edx
 108b5e4:	c5 f8 77             	vzeroupper
 108b5e7:	e8 b4 31 70 ff       	call   78e7a0 <__assert_fail@plt>
 108b5ec:	c5 f8 77             	vzeroupper
 108b5ef:	e8 3c 31 70 ff       	call   78e730 <__stack_chk_fail@plt>
 108b5f4:	48 8b 3c 24          	mov    (%rsp),%rdi
 108b5f8:	4c 8b 44 24 08       	mov    0x8(%rsp),%r8
 108b5fd:	48 01 d6             	add    %rdx,%rsi
 108b600:	48 89 77 08          	mov    %rsi,0x8(%rdi)
 108b604:	49 8d b8 50 02 00 00 	lea    0x250(%r8),%rdi
 108b60b:	49 89 88 50 02 00 00 	mov    %rcx,0x250(%r8)
 108b612:	48 89 bc 24 80 00 00 	mov    %rdi,0x80(%rsp)
 108b619:	00 
 108b61a:	48 85 c9             	test   %rcx,%rcx
 108b61d:	74 43                	je     108b662 <check_input_run+0xb352>
 108b61f:	48 8b 0c 24          	mov    (%rsp),%rcx
 108b623:	48 8b 39             	mov    (%rcx),%rdi
 108b626:	48 8b 71 08          	mov    0x8(%rcx),%rsi
 108b62a:	48 8d 4c 3e 07       	lea    0x7(%rsi,%rdi,1),%rcx
 108b62f:	48 01 fe             	add    %rdi,%rsi
 108b632:	48 83 e1 f8          	and    $0xfffffffffffffff8,%rcx
 108b636:	48 39 f1             	cmp    %rsi,%rcx
 108b639:	72 27                	jb     108b662 <check_input_run+0xb352>
 108b63b:	48 89 ce             	mov    %rcx,%rsi
 108b63e:	48 29 fe             	sub    %rdi,%rsi
 108b641:	48 8b 3c 24          	mov    (%rsp),%rdi
 108b645:	48 8b 7f 10          	mov    0x10(%rdi),%rdi
 108b649:	48 29 f7             	sub    %rsi,%rdi
 108b64c:	41 0f 92 c0          	setb   %r8b
 108b650:	48 3b 7c 24 58       	cmp    0x58(%rsp),%rdi
 108b655:	40 0f 96 c7          	setbe  %dil
 108b659:	44 08 c7             	or     %r8b,%dil
 108b65c:	40 80 ff 01          	cmp    $0x1,%dil
 108b660:	75 22                	jne    108b684 <check_input_run+0xb374>
 108b662:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
 108b667:	48 8b 34 24          	mov    (%rsp),%rsi
 108b66b:	4c 8b 74 24 10       	mov    0x10(%rsp),%r14
 108b670:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
 108b675:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
 108b67a:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
 108b67f:	e9 19 55 ff ff       	jmp    1080b9d <check_input_run+0x88d>
 108b684:	48 8b 3c 24          	mov    (%rsp),%rdi
 108b688:	4c 8b 44 24 08       	mov    0x8(%rsp),%r8
 108b68d:	48 01 d6             	add    %rdx,%rsi
 108b690:	48 89 77 08          	mov    %rsi,0x8(%rdi)
 108b694:	49 8d b8 58 02 00 00 	lea    0x258(%r8),%rdi
 108b69b:	49 89 88 58 02 00 00 	mov    %rcx,0x258(%r8)
 108b6a2:	48 89 bc 24 e8 00 00 	mov    %rdi,0xe8(%rsp)
 108b6a9:	00 
 108b6aa:	48 85 c9             	test   %rcx,%rcx
 108b6ad:	74 43                	je     108b6f2 <check_input_run+0xb3e2>
 108b6af:	48 8b 0c 24          	mov    (%rsp),%rcx
 108b6b3:	48 8b 39             	mov    (%rcx),%rdi
 108b6b6:	48 8b 71 08          	mov    0x8(%rcx),%rsi
 108b6ba:	48 8d 4c 3e 07       	lea    0x7(%rsi,%rdi,1),%rcx
 108b6bf:	48 01 fe             	add    %rdi,%rsi
 108b6c2:	48 83 e1 f8          	and    $0xfffffffffffffff8,%rcx
 108b6c6:	48 39 f1             	cmp    %rsi,%rcx
 108b6c9:	72 27                	jb     108b6f2 <check_input_run+0xb3e2>
 108b6cb:	48 89 ce             	mov    %rcx,%rsi
 108b6ce:	48 29 fe             	sub    %rdi,%rsi
 108b6d1:	48 8b 3c 24          	mov    (%rsp),%rdi
 108b6d5:	48 8b 7f 10          	mov    0x10(%rdi),%rdi
 108b6d9:	48 29 f7             	sub    %rsi,%rdi
 108b6dc:	41 0f 92 c0          	setb   %r8b
 108b6e0:	48 3b 7c 24 58       	cmp    0x58(%rsp),%rdi
 108b6e5:	40 0f 96 c7          	setbe  %dil
 108b6e9:	44 08 c7             	or     %r8b,%dil
 108b6ec:	40 80 ff 01          	cmp    $0x1,%dil
 108b6f0:	75 2d                	jne    108b71f <check_input_run+0xb40f>
 108b6f2:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
 108b6f7:	48 8b 34 24          	mov    (%rsp),%rsi
 108b6fb:	4c 8b 74 24 10       	mov    0x10(%rsp),%r14
 108b700:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
 108b705:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
 108b70a:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
 108b70f:	48 c7 87 70 02 00 00 	movq   $0x0,0x270(%rdi)
 108b716:	00 00 00 00 
 108b71a:	e9 a3 54 ff ff       	jmp    1080bc2 <check_input_run+0x8b2>
 108b71f:	48 8b 3c 24          	mov    (%rsp),%rdi
 108b723:	48 01 d6             	add    %rdx,%rsi
 108b726:	48 89 77 08          	mov    %rsi,0x8(%rdi)
 108b72a:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
 108b72f:	48 89 8f 70 02 00 00 	mov    %rcx,0x270(%rdi)
 108b736:	48 85 c9             	test   %rcx,%rcx
 108b739:	74 43                	je     108b77e <check_input_run+0xb46e>
 108b73b:	48 8b 0c 24          	mov    (%rsp),%rcx
 108b73f:	48 8b 39             	mov    (%rcx),%rdi
 108b742:	48 8b 71 08          	mov    0x8(%rcx),%rsi
 108b746:	48 8d 4c 3e 07       	lea    0x7(%rsi,%rdi,1),%rcx
 108b74b:	48 01 fe             	add    %rdi,%rsi
 108b74e:	48 83 e1 f8          	and    $0xfffffffffffffff8,%rcx
 108b752:	48 39 f1             	cmp    %rsi,%rcx
 108b755:	72 27                	jb     108b77e <check_input_run+0xb46e>
 108b757:	48 89 ce             	mov    %rcx,%rsi
 108b75a:	48 29 fe             	sub    %rdi,%rsi
 108b75d:	48 8b 3c 24          	mov    (%rsp),%rdi
 108b761:	48 8b 7f 10          	mov    0x10(%rdi),%rdi
 108b765:	48 29 f7             	sub    %rsi,%rdi
 108b768:	41 0f 92 c0          	setb   %r8b
 108b76c:	48 3b 7c 24 58       	cmp    0x58(%rsp),%rdi
 108b771:	40 0f 96 c7          	setbe  %dil
 108b775:	44 08 c7             	or     %r8b,%dil
 108b778:	40 80 ff 01          	cmp    $0x1,%dil
 108b77c:	75 22                	jne    108b7a0 <check_input_run+0xb490>
 108b77e:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
 108b783:	48 8b 34 24          	mov    (%rsp),%rsi
 108b787:	4c 8b 74 24 10       	mov    0x10(%rsp),%r14
 108b78c:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
 108b791:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
 108b796:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
 108b79b:	e9 22 54 ff ff       	jmp    1080bc2 <check_input_run+0x8b2>
 108b7a0:	48 8b 3c 24          	mov    (%rsp),%rdi
 108b7a4:	4c 8b 44 24 08       	mov    0x8(%rsp),%r8
 108b7a9:	48 01 d6             	add    %rdx,%rsi
 108b7ac:	48 89 77 08          	mov    %rsi,0x8(%rdi)
 108b7b0:	49 8d b8 78 02 00 00 	lea    0x278(%r8),%rdi
 108b7b7:	49 89 88 78 02 00 00 	mov    %rcx,0x278(%r8)
 108b7be:	48 89 bc 24 c8 00 00 	mov    %rdi,0xc8(%rsp)
 108b7c5:	00 
 108b7c6:	48 85 c9             	test   %rcx,%rcx
 108b7c9:	74 43                	je     108b80e <check_input_run+0xb4fe>
 108b7cb:	48 8b 0c 24          	mov    (%rsp),%rcx
 108b7cf:	48 8b 39             	mov    (%rcx),%rdi
 108b7d2:	48 8b 71 08          	mov    0x8(%rcx),%rsi
 108b7d6:	48 8d 4c 3e 07       	lea    0x7(%rsi,%rdi,1),%rcx
 108b7db:	48 01 fe             	add    %rdi,%rsi
 108b7de:	48 83 e1 f8          	and    $0xfffffffffffffff8,%rcx
 108b7e2:	48 39 f1             	cmp    %rsi,%rcx
 108b7e5:	72 27                	jb     108b80e <check_input_run+0xb4fe>
 108b7e7:	48 89 ce             	mov    %rcx,%rsi
 108b7ea:	48 29 fe             	sub    %rdi,%rsi
 108b7ed:	48 8b 3c 24          	mov    (%rsp),%rdi
 108b7f1:	48 8b 7f 10          	mov    0x10(%rdi),%rdi
 108b7f5:	48 29 f7             	sub    %rsi,%rdi
 108b7f8:	41 0f 92 c0          	setb   %r8b
 108b7fc:	48 3b 7c 24 58       	cmp    0x58(%rsp),%rdi
 108b801:	40 0f 96 c7          	setbe  %dil
 108b805:	44 08 c7             	or     %r8b,%dil
 108b808:	40 80 ff 01          	cmp    $0x1,%dil
 108b80c:	75 22                	jne    108b830 <check_input_run+0xb520>
 108b80e:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
 108b813:	48 8b 34 24          	mov    (%rsp),%rsi
 108b817:	4c 8b 74 24 10       	mov    0x10(%rsp),%r14
 108b81c:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
 108b821:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
 108b826:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
 108b82b:	e9 ac 53 ff ff       	jmp    1080bdc <check_input_run+0x8cc>
 108b830:	48 8b 3c 24          	mov    (%rsp),%rdi
 108b834:	4c 8b 44 24 08       	mov    0x8(%rsp),%r8
 108b839:	48 01 d6             	add    %rdx,%rsi
 108b83c:	48 89 77 08          	mov    %rsi,0x8(%rdi)
 108b840:	49 8d b8 80 02 00 00 	lea    0x280(%r8),%rdi
 108b847:	49 89 88 80 02 00 00 	mov    %rcx,0x280(%r8)
 108b84e:	48 89 bc 24 00 01 00 	mov    %rdi,0x100(%rsp)
 108b855:	00 
 108b856:	48 85 c9             	test   %rcx,%rcx
 108b859:	74 1c                	je     108b877 <check_input_run+0xb567>
 108b85b:	48 8b 0c 24          	mov    (%rsp),%rcx
 108b85f:	48 8b 39             	mov    (%rcx),%rdi
 108b862:	48 8b 71 08          	mov    0x8(%rcx),%rsi
 108b866:	48 8d 4c 3e 07       	lea    0x7(%rsi,%rdi,1),%rcx
 108b86b:	48 01 fe             	add    %rdi,%rsi
 108b86e:	48 83 e1 f8          	and    $0xfffffffffffffff8,%rcx
 108b872:	48 39 f1             	cmp    %rsi,%rcx
 108b875:	73 22                	jae    108b899 <check_input_run+0xb589>
 108b877:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
 108b87c:	48 8b 34 24          	mov    (%rsp),%rsi
 108b880:	4c 8b 74 24 10       	mov    0x10(%rsp),%r14
 108b885:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
 108b88a:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
 108b88f:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
 108b894:	e9 5d 53 ff ff       	jmp    1080bf6 <check_input_run+0x8e6>
 108b899:	48 89 ce             	mov    %rcx,%rsi
 108b89c:	48 29 fe             	sub    %rdi,%rsi
 108b89f:	48 8b 3c 24          	mov    (%rsp),%rdi
 108b8a3:	48 8b 7f 10          	mov    0x10(%rdi),%rdi
 108b8a7:	48 29 f7             	sub    %rsi,%rdi
 108b8aa:	72 cb                	jb     108b877 <check_input_run+0xb567>
 108b8ac:	4c 8b 44 24 58       	mov    0x58(%rsp),%r8
 108b8b1:	4e 8d 04 c5 08 00 00 	lea    0x8(,%r8,8),%r8
 108b8b8:	00 
 108b8b9:	49 39 f8             	cmp    %rdi,%r8
 108b8bc:	77 b9                	ja     108b877 <check_input_run+0xb567>
 108b8be:	4c 01 c6             	add    %r8,%rsi
 108b8c1:	48 8b 3c 24          	mov    (%rsp),%rdi
 108b8c5:	4c 8b 44 24 08       	mov    0x8(%rsp),%r8
 108b8ca:	48 89 77 08          	mov    %rsi,0x8(%rdi)
 108b8ce:	49 8d b8 88 02 00 00 	lea    0x288(%r8),%rdi
 108b8d5:	49 89 88 88 02 00 00 	mov    %rcx,0x288(%r8)
 108b8dc:	48 89 bc 24 a8 00 00 	mov    %rdi,0xa8(%rsp)
 108b8e3:	00 
 108b8e4:	48 85 c9             	test   %rcx,%rcx
 108b8e7:	74 43                	je     108b92c <check_input_run+0xb61c>
 108b8e9:	48 8b 0c 24          	mov    (%rsp),%rcx
 108b8ed:	48 8b 39             	mov    (%rcx),%rdi
 108b8f0:	48 8b 71 08          	mov    0x8(%rcx),%rsi
 108b8f4:	48 8d 4c 3e 07       	lea    0x7(%rsi,%rdi,1),%rcx
 108b8f9:	48 01 fe             	add    %rdi,%rsi
 108b8fc:	48 83 e1 f8          	and    $0xfffffffffffffff8,%rcx
 108b900:	48 39 f1             	cmp    %rsi,%rcx
 108b903:	72 27                	jb     108b92c <check_input_run+0xb61c>
 108b905:	48 89 ce             	mov    %rcx,%rsi
 108b908:	48 29 fe             	sub    %rdi,%rsi
 108b90b:	48 8b 3c 24          	mov    (%rsp),%rdi
 108b90f:	48 8b 7f 10          	mov    0x10(%rdi),%rdi
 108b913:	48 29 f7             	sub    %rsi,%rdi
 108b916:	41 0f 92 c0          	setb   %r8b
 108b91a:	48 3b 7c 24 58       	cmp    0x58(%rsp),%rdi
 108b91f:	40 0f 96 c7          	setbe  %dil
 108b923:	44 08 c7             	or     %r8b,%dil
 108b926:	40 80 ff 01          	cmp    $0x1,%dil
 108b92a:	75 38                	jne    108b964 <check_input_run+0xb654>
 108b92c:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
 108b931:	48 8b 34 24          	mov    (%rsp),%rsi
 108b935:	4c 8b 74 24 10       	mov    0x10(%rsp),%r14
 108b93a:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
 108b93f:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
 108b944:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
 108b949:	48 c7 87 90 02 00 00 	movq   $0x0,0x290(%rdi)
 108b950:	00 00 00 00 
 108b954:	48 c7 87 98 02 00 00 	movq   $0x0,0x298(%rdi)
 108b95b:	00 00 00 00 
 108b95f:	e9 c2 52 ff ff       	jmp    1080c26 <check_input_run+0x916>
 108b964:	48 8b 3c 24          	mov    (%rsp),%rdi
 108b968:	48 01 d6             	add    %rdx,%rsi
 108b96b:	48 89 77 08          	mov    %rsi,0x8(%rdi)
 108b96f:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
 108b974:	48 89 8f 90 02 00 00 	mov    %rcx,0x290(%rdi)
 108b97b:	48 85 c9             	test   %rcx,%rcx
 108b97e:	74 43                	je     108b9c3 <check_input_run+0xb6b3>
 108b980:	48 8b 0c 24          	mov    (%rsp),%rcx
 108b984:	48 8b 39             	mov    (%rcx),%rdi
 108b987:	48 8b 71 08          	mov    0x8(%rcx),%rsi
 108b98b:	48 8d 4c 3e 07       	lea    0x7(%rsi,%rdi,1),%rcx
 108b990:	48 01 fe             	add    %rdi,%rsi
 108b993:	48 83 e1 f8          	and    $0xfffffffffffffff8,%rcx
 108b997:	48 39 f1             	cmp    %rsi,%rcx
 108b99a:	72 27                	jb     108b9c3 <check_input_run+0xb6b3>
 108b99c:	48 89 ce             	mov    %rcx,%rsi
 108b99f:	48 29 fe             	sub    %rdi,%rsi
 108b9a2:	48 8b 3c 24          	mov    (%rsp),%rdi
 108b9a6:	48 8b 7f 10          	mov    0x10(%rdi),%rdi
 108b9aa:	48 29 f7             	sub    %rsi,%rdi
 108b9ad:	41 0f 92 c0          	setb   %r8b
 108b9b1:	48 3b 7c 24 58       	cmp    0x58(%rsp),%rdi
 108b9b6:	40 0f 96 c7          	setbe  %dil
 108b9ba:	44 08 c7             	or     %r8b,%dil
 108b9bd:	40 80 ff 01          	cmp    $0x1,%dil
 108b9c1:	75 73                	jne    108ba36 <check_input_run+0xb726>
 108b9c3:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
 108b9c8:	48 8b 34 24          	mov    (%rsp),%rsi
 108b9cc:	4c 8b 74 24 10       	mov    0x10(%rsp),%r14
 108b9d1:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
 108b9d6:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
 108b9db:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
 108b9e0:	48 c7 87 98 02 00 00 	movq   $0x0,0x298(%rdi)
 108b9e7:	00 00 00 00 
 108b9eb:	e9 36 52 ff ff       	jmp    1080c26 <check_input_run+0x916>
 108b9f0:	31 f6                	xor    %esi,%esi
 108b9f2:	31 c9                	xor    %ecx,%ecx
 108b9f4:	eb 31                	jmp    108ba27 <check_input_run+0xb717>
 108b9f6:	48 89 c7             	mov    %rax,%rdi
 108b9f9:	48 29 cf             	sub    %rcx,%rdi
 108b9fc:	31 c9                	xor    %ecx,%ecx
 108b9fe:	48 29 fa             	sub    %rdi,%rdx
 108ba01:	72 24                	jb     108ba27 <check_input_run+0xb717>
 108ba03:	4c 8b 84 24 d8 00 00 	mov    0xd8(%rsp),%r8
 108ba0a:	00 
 108ba0b:	4e 8d 04 85 00 00 00 	lea    0x0(,%r8,4),%r8
 108ba12:	00 
 108ba13:	49 39 d0             	cmp    %rdx,%r8
 108ba16:	77 0f                	ja     108ba27 <check_input_run+0xb717>
 108ba18:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
 108ba1d:	4c 01 c7             	add    %r8,%rdi
 108ba20:	48 89 79 08          	mov    %rdi,0x8(%rcx)
 108ba24:	48 89 c1             	mov    %rax,%rcx
 108ba27:	4c 8b 74 24 10       	mov    0x10(%rsp),%r14
 108ba2c:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
 108ba31:	e9 fe 59 ff ff       	jmp    1081434 <check_input_run+0x1124>
 108ba36:	48 8b 3c 24          	mov    (%rsp),%rdi
 108ba3a:	48 01 d6             	add    %rdx,%rsi
 108ba3d:	48 89 77 08          	mov    %rsi,0x8(%rdi)
 108ba41:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
 108ba46:	48 89 8f 98 02 00 00 	mov    %rcx,0x298(%rdi)
 108ba4d:	48 85 c9             	test   %rcx,%rcx
 108ba50:	74 43                	je     108ba95 <check_input_run+0xb785>
 108ba52:	48 8b 0c 24          	mov    (%rsp),%rcx
 108ba56:	48 8b 39             	mov    (%rcx),%rdi
 108ba59:	48 8b 71 08          	mov    0x8(%rcx),%rsi
 108ba5d:	48 8d 4c 3e 07       	lea    0x7(%rsi,%rdi,1),%rcx
 108ba62:	48 01 fe             	add    %rdi,%rsi
 108ba65:	48 83 e1 f8          	and    $0xfffffffffffffff8,%rcx
 108ba69:	48 39 f1             	cmp    %rsi,%rcx
 108ba6c:	72 27                	jb     108ba95 <check_input_run+0xb785>
 108ba6e:	48 89 ce             	mov    %rcx,%rsi
 108ba71:	48 29 fe             	sub    %rdi,%rsi
 108ba74:	48 8b 3c 24          	mov    (%rsp),%rdi
 108ba78:	48 8b 7f 10          	mov    0x10(%rdi),%rdi
 108ba7c:	48 29 f7             	sub    %rsi,%rdi
 108ba7f:	41 0f 92 c0          	setb   %r8b
 108ba83:	48 3b 7c 24 58       	cmp    0x58(%rsp),%rdi
 108ba88:	40 0f 96 c7          	setbe  %dil
 108ba8c:	44 08 c7             	or     %r8b,%dil
 108ba8f:	40 80 ff 01          	cmp    $0x1,%dil
 108ba93:	75 22                	jne    108bab7 <check_input_run+0xb7a7>
 108ba95:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
 108ba9a:	48 8b 34 24          	mov    (%rsp),%rsi
 108ba9e:	4c 8b 74 24 10       	mov    0x10(%rsp),%r14
 108baa3:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
 108baa8:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
 108baad:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
 108bab2:	e9 6f 51 ff ff       	jmp    1080c26 <check_input_run+0x916>
 108bab7:	48 8b 3c 24          	mov    (%rsp),%rdi
 108babb:	4c 8b 44 24 08       	mov    0x8(%rsp),%r8
 108bac0:	48 01 d6             	add    %rdx,%rsi
 108bac3:	48 89 77 08          	mov    %rsi,0x8(%rdi)
 108bac7:	49 8d b8 a0 02 00 00 	lea    0x2a0(%r8),%rdi
 108bace:	49 89 88 a0 02 00 00 	mov    %rcx,0x2a0(%r8)
 108bad5:	48 89 bc 24 f8 00 00 	mov    %rdi,0xf8(%rsp)
 108badc:	00 
 108badd:	48 85 c9             	test   %rcx,%rcx
 108bae0:	0f 84 39 02 00 00    	je     108bd1f <check_input_run+0xba0f>
 108bae6:	48 8b 0c 24          	mov    (%rsp),%rcx
 108baea:	48 8b 39             	mov    (%rcx),%rdi
 108baed:	48 8b 71 08          	mov    0x8(%rcx),%rsi
 108baf1:	48 8d 4c 3e 07       	lea    0x7(%rsi,%rdi,1),%rcx
 108baf6:	48 01 fe             	add    %rdi,%rsi
 108baf9:	48 83 e1 f8          	and    $0xfffffffffffffff8,%rcx
 108bafd:	48 39 f1             	cmp    %rsi,%rcx
 108bb00:	0f 82 19 02 00 00    	jb     108bd1f <check_input_run+0xba0f>
 108bb06:	48 89 ce             	mov    %rcx,%rsi
 108bb09:	48 29 fe             	sub    %rdi,%rsi
 108bb0c:	48 8b 3c 24          	mov    (%rsp),%rdi
 108bb10:	48 8b 7f 10          	mov    0x10(%rdi),%rdi
 108bb14:	48 29 f7             	sub    %rsi,%rdi
 108bb17:	0f 82 02 02 00 00    	jb     108bd1f <check_input_run+0xba0f>
 108bb1d:	48 39 f8             	cmp    %rdi,%rax
 108bb20:	0f 87 f9 01 00 00    	ja     108bd1f <check_input_run+0xba0f>
 108bb26:	48 8b 3c 24          	mov    (%rsp),%rdi
 108bb2a:	4c 8b 44 24 08       	mov    0x8(%rsp),%r8
 108bb2f:	48 01 c6             	add    %rax,%rsi
 108bb32:	48 89 77 08          	mov    %rsi,0x8(%rdi)
 108bb36:	49 8d b8 a8 02 00 00 	lea    0x2a8(%r8),%rdi
 108bb3d:	49 89 88 a8 02 00 00 	mov    %rcx,0x2a8(%r8)
 108bb44:	48 89 bc 24 20 01 00 	mov    %rdi,0x120(%rsp)
 108bb4b:	00 
 108bb4c:	48 85 c9             	test   %rcx,%rcx
 108bb4f:	0f 84 ec 01 00 00    	je     108bd41 <check_input_run+0xba31>
 108bb55:	48 8b 0c 24          	mov    (%rsp),%rcx
 108bb59:	48 8b 39             	mov    (%rcx),%rdi
 108bb5c:	48 8b 71 08          	mov    0x8(%rcx),%rsi
 108bb60:	48 8d 4c 3e 07       	lea    0x7(%rsi,%rdi,1),%rcx
 108bb65:	48 01 fe             	add    %rdi,%rsi
 108bb68:	48 83 e1 f8          	and    $0xfffffffffffffff8,%rcx
 108bb6c:	48 39 f1             	cmp    %rsi,%rcx
 108bb6f:	0f 82 cc 01 00 00    	jb     108bd41 <check_input_run+0xba31>
 108bb75:	48 89 ce             	mov    %rcx,%rsi
 108bb78:	48 29 fe             	sub    %rdi,%rsi
 108bb7b:	48 8b 3c 24          	mov    (%rsp),%rdi
 108bb7f:	48 8b 7f 10          	mov    0x10(%rdi),%rdi
 108bb83:	48 29 f7             	sub    %rsi,%rdi
 108bb86:	0f 82 b5 01 00 00    	jb     108bd41 <check_input_run+0xba31>
 108bb8c:	48 39 f8             	cmp    %rdi,%rax
 108bb8f:	0f 87 ac 01 00 00    	ja     108bd41 <check_input_run+0xba31>
 108bb95:	48 8b 3c 24          	mov    (%rsp),%rdi
 108bb99:	4c 8b 44 24 08       	mov    0x8(%rsp),%r8
 108bb9e:	48 01 c6             	add    %rax,%rsi
 108bba1:	48 89 77 08          	mov    %rsi,0x8(%rdi)
 108bba5:	49 8d b8 b0 02 00 00 	lea    0x2b0(%r8),%rdi
 108bbac:	49 89 88 b0 02 00 00 	mov    %rcx,0x2b0(%r8)
 108bbb3:	48 89 7c 24 50       	mov    %rdi,0x50(%rsp)
 108bbb8:	48 85 c9             	test   %rcx,%rcx
 108bbbb:	0f 84 a2 01 00 00    	je     108bd63 <check_input_run+0xba53>
 108bbc1:	48 8b 0c 24          	mov    (%rsp),%rcx
 108bbc5:	48 8b 39             	mov    (%rcx),%rdi
 108bbc8:	48 8b 71 08          	mov    0x8(%rcx),%rsi
 108bbcc:	48 8d 4c 3e 07       	lea    0x7(%rsi,%rdi,1),%rcx
 108bbd1:	48 01 fe             	add    %rdi,%rsi
 108bbd4:	48 83 e1 f8          	and    $0xfffffffffffffff8,%rcx
 108bbd8:	48 39 f1             	cmp    %rsi,%rcx
 108bbdb:	0f 82 82 01 00 00    	jb     108bd63 <check_input_run+0xba53>
 108bbe1:	48 89 ce             	mov    %rcx,%rsi
 108bbe4:	48 29 fe             	sub    %rdi,%rsi
 108bbe7:	48 8b 3c 24          	mov    (%rsp),%rdi
 108bbeb:	48 8b 7f 10          	mov    0x10(%rdi),%rdi
 108bbef:	48 29 f7             	sub    %rsi,%rdi
 108bbf2:	0f 82 6b 01 00 00    	jb     108bd63 <check_input_run+0xba53>
 108bbf8:	48 39 f8             	cmp    %rdi,%rax
 108bbfb:	0f 87 62 01 00 00    	ja     108bd63 <check_input_run+0xba53>
 108bc01:	48 8b 3c 24          	mov    (%rsp),%rdi
 108bc05:	4c 8b 44 24 08       	mov    0x8(%rsp),%r8
 108bc0a:	48 01 c6             	add    %rax,%rsi
 108bc0d:	48 89 77 08          	mov    %rsi,0x8(%rdi)
 108bc11:	49 8d b8 b8 02 00 00 	lea    0x2b8(%r8),%rdi
 108bc18:	49 89 88 b8 02 00 00 	mov    %rcx,0x2b8(%r8)
 108bc1f:	48 89 bc 24 28 01 00 	mov    %rdi,0x128(%rsp)
 108bc26:	00 
 108bc27:	48 85 c9             	test   %rcx,%rcx
 108bc2a:	0f 84 5a 01 00 00    	je     108bd8a <check_input_run+0xba7a>
 108bc30:	48 8b 0c 24          	mov    (%rsp),%rcx
 108bc34:	48 8b 39             	mov    (%rcx),%rdi
 108bc37:	48 8b 71 08          	mov    0x8(%rcx),%rsi
 108bc3b:	48 8d 4c 3e 07       	lea    0x7(%rsi,%rdi,1),%rcx
 108bc40:	48 01 fe             	add    %rdi,%rsi
 108bc43:	48 83 e1 f8          	and    $0xfffffffffffffff8,%rcx
 108bc47:	48 39 f1             	cmp    %rsi,%rcx
 108bc4a:	0f 82 3a 01 00 00    	jb     108bd8a <check_input_run+0xba7a>
 108bc50:	48 89 ce             	mov    %rcx,%rsi
 108bc53:	48 29 fe             	sub    %rdi,%rsi
 108bc56:	48 8b 3c 24          	mov    (%rsp),%rdi
 108bc5a:	48 8b 7f 10          	mov    0x10(%rdi),%rdi
 108bc5e:	48 29 f7             	sub    %rsi,%rdi
 108bc61:	0f 82 23 01 00 00    	jb     108bd8a <check_input_run+0xba7a>
 108bc67:	48 39 f8             	cmp    %rdi,%rax
 108bc6a:	0f 87 1a 01 00 00    	ja     108bd8a <check_input_run+0xba7a>
 108bc70:	48 8b 3c 24          	mov    (%rsp),%rdi
 108bc74:	4c 8b 44 24 08       	mov    0x8(%rsp),%r8
 108bc79:	48 01 c6             	add    %rax,%rsi
 108bc7c:	48 89 77 08          	mov    %rsi,0x8(%rdi)
 108bc80:	49 8d b8 c0 02 00 00 	lea    0x2c0(%r8),%rdi
 108bc87:	49 89 88 c0 02 00 00 	mov    %rcx,0x2c0(%r8)
 108bc8e:	48 89 bc 24 c8 01 00 	mov    %rdi,0x1c8(%rsp)
 108bc95:	00 
 108bc96:	48 85 c9             	test   %rcx,%rcx
 108bc99:	74 47                	je     108bce2 <check_input_run+0xb9d2>
 108bc9b:	48 8b 0c 24          	mov    (%rsp),%rcx
 108bc9f:	48 8b 39             	mov    (%rcx),%rdi
 108bca2:	48 8b 71 08          	mov    0x8(%rcx),%rsi
 108bca6:	48 8d 4c 3e 07       	lea    0x7(%rsi,%rdi,1),%rcx
 108bcab:	48 01 fe             	add    %rdi,%rsi
 108bcae:	48 83 e1 f8          	and    $0xfffffffffffffff8,%rcx
 108bcb2:	48 39 f1             	cmp    %rsi,%rcx
 108bcb5:	72 2b                	jb     108bce2 <check_input_run+0xb9d2>
 108bcb7:	48 89 ce             	mov    %rcx,%rsi
 108bcba:	48 29 fe             	sub    %rdi,%rsi
 108bcbd:	48 8b 3c 24          	mov    (%rsp),%rdi
 108bcc1:	48 8b 7f 10          	mov    0x10(%rdi),%rdi
 108bcc5:	48 29 f7             	sub    %rsi,%rdi
 108bcc8:	41 0f 92 c0          	setb   %r8b
 108bccc:	48 3b 7c 24 58       	cmp    0x58(%rsp),%rdi
 108bcd1:	40 0f 96 c7          	setbe  %dil
 108bcd5:	44 08 c7             	or     %r8b,%dil
 108bcd8:	40 80 ff 01          	cmp    $0x1,%dil
 108bcdc:	0f 85 cf 00 00 00    	jne    108bdb1 <check_input_run+0xbaa1>
 108bce2:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
 108bce7:	48 8b 34 24          	mov    (%rsp),%rsi
 108bceb:	4c 8b 74 24 10       	mov    0x10(%rsp),%r14
 108bcf0:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
 108bcf5:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
 108bcfa:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
 108bcff:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
 108bd04:	48 c7 87 c8 02 00 00 	movq   $0x0,0x2c8(%rdi)
 108bd0b:	00 00 00 00 
 108bd0f:	48 c7 87 d0 02 00 00 	movq   $0x0,0x2d0(%rdi)
 108bd16:	00 00 00 00 
 108bd1a:	e9 97 4f ff ff       	jmp    1080cb6 <check_input_run+0x9a6>
 108bd1f:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
 108bd24:	48 8b 34 24          	mov    (%rsp),%rsi
 108bd28:	4c 8b 74 24 10       	mov    0x10(%rsp),%r14
 108bd2d:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
 108bd32:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
 108bd37:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
 108bd3c:	e9 ff 4e ff ff       	jmp    1080c40 <check_input_run+0x930>
 108bd41:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
 108bd46:	48 8b 34 24          	mov    (%rsp),%rsi
 108bd4a:	4c 8b 74 24 10       	mov    0x10(%rsp),%r14
 108bd4f:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
 108bd54:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
 108bd59:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
 108bd5e:	e9 f7 4e ff ff       	jmp    1080c5a <check_input_run+0x94a>
 108bd63:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
 108bd68:	48 8b 34 24          	mov    (%rsp),%rsi
 108bd6c:	4c 8b 74 24 10       	mov    0x10(%rsp),%r14
 108bd71:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
 108bd76:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
 108bd7b:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
 108bd80:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
 108bd85:	e9 e2 4e ff ff       	jmp    1080c6c <check_input_run+0x95c>
 108bd8a:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
 108bd8f:	48 8b 34 24          	mov    (%rsp),%rsi
 108bd93:	4c 8b 74 24 10       	mov    0x10(%rsp),%r14
 108bd98:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
 108bd9d:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
 108bda2:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
 108bda7:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
 108bdac:	e9 d5 4e ff ff       	jmp    1080c86 <check_input_run+0x976>
 108bdb1:	48 8b 3c 24          	mov    (%rsp),%rdi
 108bdb5:	48 01 d6             	add    %rdx,%rsi
 108bdb8:	48 89 77 08          	mov    %rsi,0x8(%rdi)
 108bdbc:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
 108bdc1:	48 89 8f c8 02 00 00 	mov    %rcx,0x2c8(%rdi)
 108bdc8:	48 85 c9             	test   %rcx,%rcx
 108bdcb:	74 43                	je     108be10 <check_input_run+0xbb00>
 108bdcd:	48 8b 0c 24          	mov    (%rsp),%rcx
 108bdd1:	48 8b 39             	mov    (%rcx),%rdi
 108bdd4:	48 8b 71 08          	mov    0x8(%rcx),%rsi
 108bdd8:	48 8d 4c 3e 07       	lea    0x7(%rsi,%rdi,1),%rcx
 108bddd:	48 01 fe             	add    %rdi,%rsi
 108bde0:	48 83 e1 f8          	and    $0xfffffffffffffff8,%rcx
 108bde4:	48 39 f1             	cmp    %rsi,%rcx
 108bde7:	72 27                	jb     108be10 <check_input_run+0xbb00>
 108bde9:	48 89 ce             	mov    %rcx,%rsi
 108bdec:	48 29 fe             	sub    %rdi,%rsi
 108bdef:	48 8b 3c 24          	mov    (%rsp),%rdi
 108bdf3:	48 8b 7f 10          	mov    0x10(%rdi),%rdi
 108bdf7:	48 29 f7             	sub    %rsi,%rdi
 108bdfa:	41 0f 92 c0          	setb   %r8b
 108bdfe:	48 3b 7c 24 58       	cmp    0x58(%rsp),%rdi
 108be03:	40 0f 96 c7          	setbe  %dil
 108be07:	44 08 c7             	or     %r8b,%dil
 108be0a:	40 80 ff 01          	cmp    $0x1,%dil
 108be0e:	75 32                	jne    108be42 <check_input_run+0xbb32>
 108be10:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
 108be15:	48 8b 34 24          	mov    (%rsp),%rsi
 108be19:	4c 8b 74 24 10       	mov    0x10(%rsp),%r14
 108be1e:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
 108be23:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
 108be28:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
 108be2d:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
 108be32:	48 c7 87 d0 02 00 00 	movq   $0x0,0x2d0(%rdi)
 108be39:	00 00 00 00 
 108be3d:	e9 74 4e ff ff       	jmp    1080cb6 <check_input_run+0x9a6>
 108be42:	48 8b 3c 24          	mov    (%rsp),%rdi
 108be46:	48 01 d6             	add    %rdx,%rsi
 108be49:	48 89 77 08          	mov    %rsi,0x8(%rdi)
 108be4d:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
 108be52:	48 89 8f d0 02 00 00 	mov    %rcx,0x2d0(%rdi)
 108be59:	48 85 c9             	test   %rcx,%rcx
 108be5c:	0f 84 6e 04 00 00    	je     108c2d0 <check_input_run+0xbfc0>
 108be62:	48 8b 0c 24          	mov    (%rsp),%rcx
 108be66:	48 8b 39             	mov    (%rcx),%rdi
 108be69:	48 8b 71 08          	mov    0x8(%rcx),%rsi
 108be6d:	48 8d 4c 3e 07       	lea    0x7(%rsi,%rdi,1),%rcx
 108be72:	48 01 fe             	add    %rdi,%rsi
 108be75:	48 83 e1 f8          	and    $0xfffffffffffffff8,%rcx
 108be79:	48 39 f1             	cmp    %rsi,%rcx
 108be7c:	0f 82 4e 04 00 00    	jb     108c2d0 <check_input_run+0xbfc0>
 108be82:	48 89 ce             	mov    %rcx,%rsi
 108be85:	48 29 fe             	sub    %rdi,%rsi
 108be88:	48 8b 3c 24          	mov    (%rsp),%rdi
 108be8c:	48 8b 7f 10          	mov    0x10(%rdi),%rdi
 108be90:	48 29 f7             	sub    %rsi,%rdi
 108be93:	0f 82 37 04 00 00    	jb     108c2d0 <check_input_run+0xbfc0>
 108be99:	48 39 f8             	cmp    %rdi,%rax
 108be9c:	0f 87 2e 04 00 00    	ja     108c2d0 <check_input_run+0xbfc0>
 108bea2:	48 8b 3c 24          	mov    (%rsp),%rdi
 108bea6:	4c 8b 44 24 08       	mov    0x8(%rsp),%r8
 108beab:	48 01 c6             	add    %rax,%rsi
 108beae:	48 89 77 08          	mov    %rsi,0x8(%rdi)
 108beb2:	49 8d b8 d8 02 00 00 	lea    0x2d8(%r8),%rdi
 108beb9:	49 89 88 d8 02 00 00 	mov    %rcx,0x2d8(%r8)
 108bec0:	48 89 7c 24 70       	mov    %rdi,0x70(%rsp)
 108bec5:	48 85 c9             	test   %rcx,%rcx
 108bec8:	0f 84 29 04 00 00    	je     108c2f7 <check_input_run+0xbfe7>
 108bece:	48 8b 0c 24          	mov    (%rsp),%rcx
 108bed2:	48 8b 39             	mov    (%rcx),%rdi
 108bed5:	48 8b 71 08          	mov    0x8(%rcx),%rsi
 108bed9:	48 8d 4c 3e 07       	lea    0x7(%rsi,%rdi,1),%rcx
 108bede:	48 01 fe             	add    %rdi,%rsi
 108bee1:	48 83 e1 f8          	and    $0xfffffffffffffff8,%rcx
 108bee5:	48 39 f1             	cmp    %rsi,%rcx
 108bee8:	0f 82 09 04 00 00    	jb     108c2f7 <check_input_run+0xbfe7>
 108beee:	48 89 ce             	mov    %rcx,%rsi
 108bef1:	48 29 fe             	sub    %rdi,%rsi
 108bef4:	48 8b 3c 24          	mov    (%rsp),%rdi
 108bef8:	48 8b 7f 10          	mov    0x10(%rdi),%rdi
 108befc:	48 29 f7             	sub    %rsi,%rdi
 108beff:	0f 82 f2 03 00 00    	jb     108c2f7 <check_input_run+0xbfe7>
 108bf05:	48 39 f8             	cmp    %rdi,%rax
 108bf08:	0f 87 e9 03 00 00    	ja     108c2f7 <check_input_run+0xbfe7>
 108bf0e:	48 8b 3c 24          	mov    (%rsp),%rdi
 108bf12:	4c 8b 44 24 08       	mov    0x8(%rsp),%r8
 108bf17:	48 01 c6             	add    %rax,%rsi
 108bf1a:	48 89 77 08          	mov    %rsi,0x8(%rdi)
 108bf1e:	49 8d b8 e0 02 00 00 	lea    0x2e0(%r8),%rdi
 108bf25:	49 89 88 e0 02 00 00 	mov    %rcx,0x2e0(%r8)
 108bf2c:	48 89 7c 24 78       	mov    %rdi,0x78(%rsp)
 108bf31:	48 85 c9             	test   %rcx,%rcx
 108bf34:	0f 84 e9 03 00 00    	je     108c323 <check_input_run+0xc013>
 108bf3a:	48 8b 0c 24          	mov    (%rsp),%rcx
 108bf3e:	48 8b 39             	mov    (%rcx),%rdi
 108bf41:	48 8b 71 08          	mov    0x8(%rcx),%rsi
 108bf45:	48 8d 4c 3e 07       	lea    0x7(%rsi,%rdi,1),%rcx
 108bf4a:	48 01 fe             	add    %rdi,%rsi
 108bf4d:	48 83 e1 f8          	and    $0xfffffffffffffff8,%rcx
 108bf51:	48 39 f1             	cmp    %rsi,%rcx
 108bf54:	0f 82 c9 03 00 00    	jb     108c323 <check_input_run+0xc013>
 108bf5a:	48 89 ce             	mov    %rcx,%rsi
 108bf5d:	48 29 fe             	sub    %rdi,%rsi
 108bf60:	48 8b 3c 24          	mov    (%rsp),%rdi
 108bf64:	48 8b 7f 10          	mov    0x10(%rdi),%rdi
 108bf68:	48 29 f7             	sub    %rsi,%rdi
 108bf6b:	0f 82 b2 03 00 00    	jb     108c323 <check_input_run+0xc013>
 108bf71:	48 39 f8             	cmp    %rdi,%rax
 108bf74:	0f 87 a9 03 00 00    	ja     108c323 <check_input_run+0xc013>
 108bf7a:	48 8b 3c 24          	mov    (%rsp),%rdi
 108bf7e:	48 01 c6             	add    %rax,%rsi
 108bf81:	48 89 77 08          	mov    %rsi,0x8(%rdi)
 108bf85:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
 108bf8a:	48 89 8f e8 02 00 00 	mov    %rcx,0x2e8(%rdi)
 108bf91:	48 85 c9             	test   %rcx,%rcx
 108bf94:	0f 84 ba 03 00 00    	je     108c354 <check_input_run+0xc044>
 108bf9a:	48 8b 0c 24          	mov    (%rsp),%rcx
 108bf9e:	48 8b 39             	mov    (%rcx),%rdi
 108bfa1:	48 8b 71 08          	mov    0x8(%rcx),%rsi
 108bfa5:	48 8d 4c 3e 07       	lea    0x7(%rsi,%rdi,1),%rcx
 108bfaa:	48 01 fe             	add    %rdi,%rsi
 108bfad:	48 83 e1 f8          	and    $0xfffffffffffffff8,%rcx
 108bfb1:	48 39 f1             	cmp    %rsi,%rcx
 108bfb4:	0f 82 9a 03 00 00    	jb     108c354 <check_input_run+0xc044>
 108bfba:	48 89 ce             	mov    %rcx,%rsi
 108bfbd:	48 29 fe             	sub    %rdi,%rsi
 108bfc0:	48 8b 3c 24          	mov    (%rsp),%rdi
 108bfc4:	48 8b 7f 10          	mov    0x10(%rdi),%rdi
 108bfc8:	48 29 f7             	sub    %rsi,%rdi
 108bfcb:	0f 82 83 03 00 00    	jb     108c354 <check_input_run+0xc044>
 108bfd1:	48 39 f8             	cmp    %rdi,%rax
 108bfd4:	0f 87 7a 03 00 00    	ja     108c354 <check_input_run+0xc044>
 108bfda:	48 8b 3c 24          	mov    (%rsp),%rdi
 108bfde:	4c 8b 44 24 08       	mov    0x8(%rsp),%r8
 108bfe3:	48 01 c6             	add    %rax,%rsi
 108bfe6:	48 89 77 08          	mov    %rsi,0x8(%rdi)
 108bfea:	49 8d b8 f0 02 00 00 	lea    0x2f0(%r8),%rdi
 108bff1:	49 89 88 f0 02 00 00 	mov    %rcx,0x2f0(%r8)
 108bff8:	48 89 bc 24 90 00 00 	mov    %rdi,0x90(%rsp)
 108bfff:	00 
 108c000:	48 85 c9             	test   %rcx,%rcx
 108c003:	0f 84 7c 03 00 00    	je     108c385 <check_input_run+0xc075>
 108c009:	48 8b 0c 24          	mov    (%rsp),%rcx
 108c00d:	48 8b 39             	mov    (%rcx),%rdi
 108c010:	48 8b 71 08          	mov    0x8(%rcx),%rsi
 108c014:	48 8d 4c 3e 07       	lea    0x7(%rsi,%rdi,1),%rcx
 108c019:	48 01 fe             	add    %rdi,%rsi
 108c01c:	48 83 e1 f8          	and    $0xfffffffffffffff8,%rcx
 108c020:	48 39 f1             	cmp    %rsi,%rcx
 108c023:	0f 82 5c 03 00 00    	jb     108c385 <check_input_run+0xc075>
 108c029:	48 89 ce             	mov    %rcx,%rsi
 108c02c:	48 29 fe             	sub    %rdi,%rsi
 108c02f:	48 8b 3c 24          	mov    (%rsp),%rdi
 108c033:	48 8b 7f 10          	mov    0x10(%rdi),%rdi
 108c037:	48 29 f7             	sub    %rsi,%rdi
 108c03a:	0f 82 45 03 00 00    	jb     108c385 <check_input_run+0xc075>
 108c040:	48 39 f8             	cmp    %rdi,%rax
 108c043:	0f 87 3c 03 00 00    	ja     108c385 <check_input_run+0xc075>
 108c049:	48 8b 3c 24          	mov    (%rsp),%rdi
 108c04d:	4c 8b 44 24 08       	mov    0x8(%rsp),%r8
 108c052:	48 01 c6             	add    %rax,%rsi
 108c055:	48 89 77 08          	mov    %rsi,0x8(%rdi)
 108c059:	49 8d b8 f8 02 00 00 	lea    0x2f8(%r8),%rdi
 108c060:	49 89 88 f8 02 00 00 	mov    %rcx,0x2f8(%r8)
 108c067:	48 89 bc 24 b8 00 00 	mov    %rdi,0xb8(%rsp)
 108c06e:	00 
 108c06f:	48 85 c9             	test   %rcx,%rcx
 108c072:	0f 84 46 03 00 00    	je     108c3be <check_input_run+0xc0ae>
 108c078:	48 8b 0c 24          	mov    (%rsp),%rcx
 108c07c:	48 8b 39             	mov    (%rcx),%rdi
 108c07f:	48 8b 71 08          	mov    0x8(%rcx),%rsi
 108c083:	48 8d 4c 3e 07       	lea    0x7(%rsi,%rdi,1),%rcx
 108c088:	48 01 fe             	add    %rdi,%rsi
 108c08b:	48 83 e1 f8          	and    $0xfffffffffffffff8,%rcx
 108c08f:	48 39 f1             	cmp    %rsi,%rcx
 108c092:	0f 82 26 03 00 00    	jb     108c3be <check_input_run+0xc0ae>
 108c098:	48 89 ce             	mov    %rcx,%rsi
 108c09b:	48 29 fe             	sub    %rdi,%rsi
 108c09e:	48 8b 3c 24          	mov    (%rsp),%rdi
 108c0a2:	48 8b 7f 10          	mov    0x10(%rdi),%rdi
 108c0a6:	48 29 f7             	sub    %rsi,%rdi
 108c0a9:	0f 82 0f 03 00 00    	jb     108c3be <check_input_run+0xc0ae>
 108c0af:	48 39 f8             	cmp    %rdi,%rax
 108c0b2:	0f 87 06 03 00 00    	ja     108c3be <check_input_run+0xc0ae>
 108c0b8:	48 8b 3c 24          	mov    (%rsp),%rdi
 108c0bc:	4c 8b 44 24 08       	mov    0x8(%rsp),%r8
 108c0c1:	48 01 c6             	add    %rax,%rsi
 108c0c4:	48 89 77 08          	mov    %rsi,0x8(%rdi)
 108c0c8:	49 8d b8 00 03 00 00 	lea    0x300(%r8),%rdi
 108c0cf:	49 89 88 00 03 00 00 	mov    %rcx,0x300(%r8)
 108c0d6:	48 89 bc 24 e0 00 00 	mov    %rdi,0xe0(%rsp)
 108c0dd:	00 
 108c0de:	48 85 c9             	test   %rcx,%rcx
 108c0e1:	0f 84 18 03 00 00    	je     108c3ff <check_input_run+0xc0ef>
 108c0e7:	48 8b 0c 24          	mov    (%rsp),%rcx
 108c0eb:	48 8b 39             	mov    (%rcx),%rdi
 108c0ee:	48 8b 71 08          	mov    0x8(%rcx),%rsi
 108c0f2:	48 8d 4c 3e 07       	lea    0x7(%rsi,%rdi,1),%rcx
 108c0f7:	48 01 fe             	add    %rdi,%rsi
 108c0fa:	48 83 e1 f8          	and    $0xfffffffffffffff8,%rcx
 108c0fe:	48 39 f1             	cmp    %rsi,%rcx
 108c101:	0f 82 f8 02 00 00    	jb     108c3ff <check_input_run+0xc0ef>
 108c107:	48 89 ce             	mov    %rcx,%rsi
 108c10a:	48 29 fe             	sub    %rdi,%rsi
 108c10d:	48 8b 3c 24          	mov    (%rsp),%rdi
 108c111:	48 8b 7f 10          	mov    0x10(%rdi),%rdi
 108c115:	48 29 f7             	sub    %rsi,%rdi
 108c118:	0f 82 e1 02 00 00    	jb     108c3ff <check_input_run+0xc0ef>
 108c11e:	48 39 f8             	cmp    %rdi,%rax
 108c121:	0f 87 d8 02 00 00    	ja     108c3ff <check_input_run+0xc0ef>
 108c127:	48 8b 3c 24          	mov    (%rsp),%rdi
 108c12b:	4c 8b 44 24 08       	mov    0x8(%rsp),%r8
 108c130:	48 01 c6             	add    %rax,%rsi
 108c133:	48 89 77 08          	mov    %rsi,0x8(%rdi)
 108c137:	49 8d b8 08 03 00 00 	lea    0x308(%r8),%rdi
 108c13e:	49 89 88 08 03 00 00 	mov    %rcx,0x308(%r8)
 108c145:	48 89 bc 24 10 01 00 	mov    %rdi,0x110(%rsp)
 108c14c:	00 
 108c14d:	48 85 c9             	test   %rcx,%rcx
 108c150:	0f 84 f2 02 00 00    	je     108c448 <check_input_run+0xc138>
 108c156:	48 8b 0c 24          	mov    (%rsp),%rcx
 108c15a:	48 8b 39             	mov    (%rcx),%rdi
 108c15d:	48 8b 71 08          	mov    0x8(%rcx),%rsi
 108c161:	48 8d 4c 3e 07       	lea    0x7(%rsi,%rdi,1),%rcx
 108c166:	48 01 fe             	add    %rdi,%rsi
 108c169:	48 83 e1 f8          	and    $0xfffffffffffffff8,%rcx
 108c16d:	48 39 f1             	cmp    %rsi,%rcx
 108c170:	0f 82 d2 02 00 00    	jb     108c448 <check_input_run+0xc138>
 108c176:	48 89 ce             	mov    %rcx,%rsi
 108c179:	48 29 fe             	sub    %rdi,%rsi
 108c17c:	48 8b 3c 24          	mov    (%rsp),%rdi
 108c180:	48 8b 7f 10          	mov    0x10(%rdi),%rdi
 108c184:	48 29 f7             	sub    %rsi,%rdi
 108c187:	0f 82 bb 02 00 00    	jb     108c448 <check_input_run+0xc138>
 108c18d:	4c 8b 44 24 58       	mov    0x58(%rsp),%r8
 108c192:	4f 8d 04 40          	lea    (%r8,%r8,2),%r8
 108c196:	4e 8d 04 c5 18 00 00 	lea    0x18(,%r8,8),%r8
 108c19d:	00 
 108c19e:	49 39 f8             	cmp    %rdi,%r8
 108c1a1:	0f 87 a1 02 00 00    	ja     108c448 <check_input_run+0xc138>
 108c1a7:	48 8b 3c 24          	mov    (%rsp),%rdi
 108c1ab:	4c 01 c6             	add    %r8,%rsi
 108c1ae:	48 89 77 08          	mov    %rsi,0x8(%rdi)
 108c1b2:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
 108c1b7:	48 89 8f 10 03 00 00 	mov    %rcx,0x310(%rdi)
 108c1be:	48 85 c9             	test   %rcx,%rcx
 108c1c1:	0f 84 d2 02 00 00    	je     108c499 <check_input_run+0xc189>
 108c1c7:	48 8b 0c 24          	mov    (%rsp),%rcx
 108c1cb:	48 8b 39             	mov    (%rcx),%rdi
 108c1ce:	48 8b 71 08          	mov    0x8(%rcx),%rsi
 108c1d2:	48 8d 4c 3e 07       	lea    0x7(%rsi,%rdi,1),%rcx
 108c1d7:	48 01 fe             	add    %rdi,%rsi
 108c1da:	48 83 e1 f8          	and    $0xfffffffffffffff8,%rcx
 108c1de:	48 39 f1             	cmp    %rsi,%rcx
 108c1e1:	0f 82 b2 02 00 00    	jb     108c499 <check_input_run+0xc189>
 108c1e7:	48 89 ce             	mov    %rcx,%rsi
 108c1ea:	48 29 fe             	sub    %rdi,%rsi
 108c1ed:	48 8b 3c 24          	mov    (%rsp),%rdi
 108c1f1:	48 8b 7f 10          	mov    0x10(%rdi),%rdi
 108c1f5:	48 29 f7             	sub    %rsi,%rdi
 108c1f8:	0f 82 9b 02 00 00    	jb     108c499 <check_input_run+0xc189>
 108c1fe:	48 39 f8             	cmp    %rdi,%rax
 108c201:	0f 87 92 02 00 00    	ja     108c499 <check_input_run+0xc189>
 108c207:	48 8b 3c 24          	mov    (%rsp),%rdi
 108c20b:	4c 8b 44 24 08       	mov    0x8(%rsp),%r8
 108c210:	48 01 c6             	add    %rax,%rsi
 108c213:	48 89 77 08          	mov    %rsi,0x8(%rdi)
 108c217:	49 8d b8 18 03 00 00 	lea    0x318(%r8),%rdi
 108c21e:	49 89 88 18 03 00 00 	mov    %rcx,0x318(%r8)
 108c225:	48 89 bc 24 c0 01 00 	mov    %rdi,0x1c0(%rsp)
 108c22c:	00 
 108c22d:	48 85 c9             	test   %rcx,%rcx
 108c230:	0f 84 b4 02 00 00    	je     108c4ea <check_input_run+0xc1da>
 108c236:	48 8b 0c 24          	mov    (%rsp),%rcx
 108c23a:	48 8b 39             	mov    (%rcx),%rdi
 108c23d:	48 8b 71 08          	mov    0x8(%rcx),%rsi
 108c241:	48 8d 4c 3e 07       	lea    0x7(%rsi,%rdi,1),%rcx
 108c246:	48 01 fe             	add    %rdi,%rsi
 108c249:	48 83 e1 f8          	and    $0xfffffffffffffff8,%rcx
 108c24d:	48 39 f1             	cmp    %rsi,%rcx
 108c250:	0f 82 94 02 00 00    	jb     108c4ea <check_input_run+0xc1da>
 108c256:	48 89 ce             	mov    %rcx,%rsi
 108c259:	48 29 fe             	sub    %rdi,%rsi
 108c25c:	48 8b 3c 24          	mov    (%rsp),%rdi
 108c260:	48 8b 7f 10          	mov    0x10(%rdi),%rdi
 108c264:	48 29 f7             	sub    %rsi,%rdi
 108c267:	0f 82 7d 02 00 00    	jb     108c4ea <check_input_run+0xc1da>
 108c26d:	48 39 f8             	cmp    %rdi,%rax
 108c270:	0f 87 74 02 00 00    	ja     108c4ea <check_input_run+0xc1da>
 108c276:	4c 8b 04 24          	mov    (%rsp),%r8
 108c27a:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
 108c27f:	48 01 c6             	add    %rax,%rsi
 108c282:	b8 50 03 00 00       	mov    $0x350,%eax
 108c287:	49 89 70 08          	mov    %rsi,0x8(%r8)
 108c28b:	48 8d b7 48 03 00 00 	lea    0x348(%rdi),%rsi
 108c292:	48 89 8f 48 03 00 00 	mov    %rcx,0x348(%rdi)
 108c299:	48 89 b4 24 b8 01 00 	mov    %rsi,0x1b8(%rsp)
 108c2a0:	00 
 108c2a1:	48 85 c9             	test   %rcx,%rcx
 108c2a4:	74 20                	je     108c2c6 <check_input_run+0xbfb6>
 108c2a6:	48 8b 0c 24          	mov    (%rsp),%rcx
 108c2aa:	48 8b 39             	mov    (%rcx),%rdi
 108c2ad:	48 8b 71 08          	mov    0x8(%rcx),%rsi
 108c2b1:	48 8d 4c 3e 07       	lea    0x7(%rsi,%rdi,1),%rcx
 108c2b6:	48 01 fe             	add    %rdi,%rsi
 108c2b9:	48 83 e1 f8          	and    $0xfffffffffffffff8,%rcx
 108c2bd:	48 39 f1             	cmp    %rsi,%rcx
 108c2c0:	0f 83 41 02 00 00    	jae    108c507 <check_input_run+0xc1f7>
 108c2c6:	31 db                	xor    %ebx,%ebx
 108c2c8:	45 31 ff             	xor    %r15d,%r15d
 108c2cb:	e9 e4 02 00 00       	jmp    108c5b4 <check_input_run+0xc2a4>
 108c2d0:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
 108c2d5:	48 8b 34 24          	mov    (%rsp),%rsi
 108c2d9:	4c 8b 74 24 10       	mov    0x10(%rsp),%r14
 108c2de:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
 108c2e3:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
 108c2e8:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
 108c2ed:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
 108c2f2:	e9 bf 49 ff ff       	jmp    1080cb6 <check_input_run+0x9a6>
 108c2f7:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
 108c2fc:	48 8b 34 24          	mov    (%rsp),%rsi
 108c300:	4c 8b 74 24 10       	mov    0x10(%rsp),%r14
 108c305:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
 108c30a:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
 108c30f:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
 108c314:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
 108c319:	48 8b 54 24 70       	mov    0x70(%rsp),%rdx
 108c31e:	e9 a5 49 ff ff       	jmp    1080cc8 <check_input_run+0x9b8>
 108c323:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
 108c328:	48 8b 34 24          	mov    (%rsp),%rsi
 108c32c:	4c 8b 74 24 10       	mov    0x10(%rsp),%r14
 108c331:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
 108c336:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
 108c33b:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
 108c340:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
 108c345:	48 8b 54 24 70       	mov    0x70(%rsp),%rdx
 108c34a:	4c 8b 44 24 78       	mov    0x78(%rsp),%r8
 108c34f:	e9 86 49 ff ff       	jmp    1080cda <check_input_run+0x9ca>
 108c354:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
 108c359:	48 8b 34 24          	mov    (%rsp),%rsi
 108c35d:	4c 8b 74 24 10       	mov    0x10(%rsp),%r14
 108c362:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
 108c367:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
 108c36c:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
 108c371:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
 108c376:	48 8b 54 24 70       	mov    0x70(%rsp),%rdx
 108c37b:	4c 8b 44 24 78       	mov    0x78(%rsp),%r8
 108c380:	e9 60 49 ff ff       	jmp    1080ce5 <check_input_run+0x9d5>
 108c385:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
 108c38a:	48 8b 34 24          	mov    (%rsp),%rsi
 108c38e:	4c 8b 74 24 10       	mov    0x10(%rsp),%r14
 108c393:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
 108c398:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
 108c39d:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
 108c3a2:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
 108c3a7:	48 8b 54 24 70       	mov    0x70(%rsp),%rdx
 108c3ac:	4c 8b 44 24 78       	mov    0x78(%rsp),%r8
 108c3b1:	4c 8b 94 24 90 00 00 	mov    0x90(%rsp),%r10
 108c3b8:	00 
 108c3b9:	e9 39 49 ff ff       	jmp    1080cf7 <check_input_run+0x9e7>
 108c3be:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
 108c3c3:	48 8b 34 24          	mov    (%rsp),%rsi
 108c3c7:	4c 8b 74 24 10       	mov    0x10(%rsp),%r14
 108c3cc:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
 108c3d1:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
 108c3d6:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
 108c3db:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
 108c3e0:	48 8b 54 24 70       	mov    0x70(%rsp),%rdx
 108c3e5:	4c 8b 44 24 78       	mov    0x78(%rsp),%r8
 108c3ea:	4c 8b 94 24 90 00 00 	mov    0x90(%rsp),%r10
 108c3f1:	00 
 108c3f2:	4c 8b 9c 24 b8 00 00 	mov    0xb8(%rsp),%r11
 108c3f9:	00 
 108c3fa:	e9 0a 49 ff ff       	jmp    1080d09 <check_input_run+0x9f9>
 108c3ff:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
 108c404:	48 8b 34 24          	mov    (%rsp),%rsi
 108c408:	4c 8b 74 24 10       	mov    0x10(%rsp),%r14
 108c40d:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
 108c412:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
 108c417:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
 108c41c:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
 108c421:	48 8b 54 24 70       	mov    0x70(%rsp),%rdx
 108c426:	4c 8b 44 24 78       	mov    0x78(%rsp),%r8
 108c42b:	4c 8b 94 24 90 00 00 	mov    0x90(%rsp),%r10
 108c432:	00 
 108c433:	4c 8b 9c 24 b8 00 00 	mov    0xb8(%rsp),%r11
 108c43a:	00 
 108c43b:	48 8b 9c 24 e0 00 00 	mov    0xe0(%rsp),%rbx
 108c442:	00 
 108c443:	e9 d3 48 ff ff       	jmp    1080d1b <check_input_run+0xa0b>
 108c448:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
 108c44d:	48 8b 34 24          	mov    (%rsp),%rsi
 108c451:	4c 8b 74 24 10       	mov    0x10(%rsp),%r14
 108c456:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
 108c45b:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
 108c460:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
 108c465:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
 108c46a:	48 8b 54 24 70       	mov    0x70(%rsp),%rdx
 108c46f:	4c 8b 44 24 78       	mov    0x78(%rsp),%r8
 108c474:	4c 8b 94 24 90 00 00 	mov    0x90(%rsp),%r10
 108c47b:	00 
 108c47c:	4c 8b 9c 24 b8 00 00 	mov    0xb8(%rsp),%r11
 108c483:	00 
 108c484:	48 8b 9c 24 e0 00 00 	mov    0xe0(%rsp),%rbx
 108c48b:	00 
 108c48c:	4c 8b bc 24 10 01 00 	mov    0x110(%rsp),%r15
 108c493:	00 
 108c494:	e9 94 48 ff ff       	jmp    1080d2d <check_input_run+0xa1d>
 108c499:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
 108c49e:	48 8b 34 24          	mov    (%rsp),%rsi
 108c4a2:	4c 8b 74 24 10       	mov    0x10(%rsp),%r14
 108c4a7:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
 108c4ac:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
 108c4b1:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
 108c4b6:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
 108c4bb:	48 8b 54 24 70       	mov    0x70(%rsp),%rdx
 108c4c0:	4c 8b 44 24 78       	mov    0x78(%rsp),%r8
 108c4c5:	4c 8b 94 24 90 00 00 	mov    0x90(%rsp),%r10
 108c4cc:	00 
 108c4cd:	4c 8b 9c 24 b8 00 00 	mov    0xb8(%rsp),%r11
 108c4d4:	00 
 108c4d5:	48 8b 9c 24 e0 00 00 	mov    0xe0(%rsp),%rbx
 108c4dc:	00 
 108c4dd:	4c 8b bc 24 10 01 00 	mov    0x110(%rsp),%r15
 108c4e4:	00 
 108c4e5:	e9 4e 48 ff ff       	jmp    1080d38 <check_input_run+0xa28>
 108c4ea:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
 108c4ef:	48 8b 34 24          	mov    (%rsp),%rsi
 108c4f3:	4c 8b 74 24 10       	mov    0x10(%rsp),%r14
 108c4f8:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
 108c4fd:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
 108c502:	e9 7f 48 ff ff       	jmp    1080d86 <check_input_run+0xa76>
 108c507:	48 89 ce             	mov    %rcx,%rsi
 108c50a:	48 29 fe             	sub    %rdi,%rsi
 108c50d:	48 8b 3c 24          	mov    (%rsp),%rdi
 108c511:	31 db                	xor    %ebx,%ebx
 108c513:	41 bf 00 00 00 00    	mov    $0x0,%r15d
 108c519:	48 8b 7f 10          	mov    0x10(%rdi),%rdi
 108c51d:	48 29 f7             	sub    %rsi,%rdi
 108c520:	0f 82 8e 00 00 00    	jb     108c5b4 <check_input_run+0xc2a4>
 108c526:	4c 8b 44 24 58       	mov    0x58(%rsp),%r8
 108c52b:	4f 8d 04 80          	lea    (%r8,%r8,4),%r8
 108c52f:	4e 8d 04 c5 28 00 00 	lea    0x28(,%r8,8),%r8
 108c536:	00 
 108c537:	49 39 f8             	cmp    %rdi,%r8
 108c53a:	77 78                	ja     108c5b4 <check_input_run+0xc2a4>
 108c53c:	48 8b 04 24          	mov    (%rsp),%rax
 108c540:	4c 01 c6             	add    %r8,%rsi
 108c543:	48 85 c9             	test   %rcx,%rcx
 108c546:	41 0f 95 c7          	setne  %r15b
 108c54a:	48 83 bc 24 10 07 00 	cmpq   $0x0,0x710(%rsp)
 108c551:	00 00 
 108c553:	48 89 70 08          	mov    %rsi,0x8(%rax)
 108c557:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
 108c55c:	48 89 8e 50 03 00 00 	mov    %rcx,0x350(%rsi)
 108c563:	74 6f                	je     108c5d4 <check_input_run+0xc2c4>
 108c565:	48 85 c9             	test   %rcx,%rcx
 108c568:	74 6a                	je     108c5d4 <check_input_run+0xc2c4>
 108c56a:	48 8b 04 24          	mov    (%rsp),%rax
 108c56e:	48 8b 58 08          	mov    0x8(%rax),%rbx
 108c572:	48 8b 40 10          	mov    0x10(%rax),%rax
 108c576:	48 29 d8             	sub    %rbx,%rax
 108c579:	0f 92 c1             	setb   %cl
 108c57c:	48 3b 44 24 58       	cmp    0x58(%rsp),%rax
 108c581:	0f 96 c0             	setbe  %al
 108c584:	08 c8                	or     %cl,%al
 108c586:	75 49                	jne    108c5d1 <check_input_run+0xc2c1>
 108c588:	48 8b 0c 24          	mov    (%rsp),%rcx
 108c58c:	48 8d 04 13          	lea    (%rbx,%rdx,1),%rax
 108c590:	48 03 19             	add    (%rcx),%rbx
 108c593:	48 89 41 08          	mov    %rax,0x8(%rcx)
 108c597:	74 38                	je     108c5d1 <check_input_run+0xc2c1>
 108c599:	48 8b b4 24 10 07 00 	mov    0x710(%rsp),%rsi
 108c5a0:	00 
 108c5a1:	48 89 df             	mov    %rbx,%rdi
 108c5a4:	c5 f8 77             	vzeroupper
 108c5a7:	e8 f4 2a 70 ff       	call   78f0a0 <memcpy@plt>
 108c5ac:	41 b7 01             	mov    $0x1,%r15b
 108c5af:	b8 f0 01 00 00       	mov    $0x1f0,%eax
 108c5b4:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
 108c5b9:	48 8b 34 24          	mov    (%rsp),%rsi
 108c5bd:	4c 8b 74 24 10       	mov    0x10(%rsp),%r14
 108c5c2:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
 108c5c7:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
 108c5cc:	e9 d9 47 ff ff       	jmp    1080daa <check_input_run+0xa9a>
 108c5d1:	45 31 ff             	xor    %r15d,%r15d
 108c5d4:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
 108c5d9:	48 8b 34 24          	mov    (%rsp),%rsi
 108c5dd:	4c 8b 74 24 10       	mov    0x10(%rsp),%r14
 108c5e2:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
 108c5e7:	e9 c7 47 ff ff       	jmp    1080db3 <check_input_run+0xaa3>
