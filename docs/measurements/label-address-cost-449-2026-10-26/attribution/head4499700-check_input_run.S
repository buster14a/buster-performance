
../campaign/native-images/head449/build/compiler:     file format elf64-x86-64


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

000000000106d390 <check_input_run>:
 106d390:	push   %rbp
 106d391:	push   %r15
 106d393:	push   %r14
 106d395:	push   %r13
 106d397:	push   %r12
 106d399:	push   %rbx
 106d39a:	sub    $0x808,%rsp
 106d3a1:	vmovdqa64 -0xbd002b(%rip),%zmm1        # 49d380 <cbuiltin_test_generated.edges+0x3540>
 106d3ab:	mov    %r9,0x38(%rsp)
 106d3b0:	mov    %r8,0x10(%rsp)
 106d3b5:	mov    %rcx,0xa0(%rsp)
 106d3bd:	vpxor  %xmm0,%xmm0,%xmm0
 106d3c1:	vpmovsxbq -0xbcfd8a(%rip),%xmm2        # 49d640 <cbuiltin_test_generated.edges+0x3800>
 106d3ca:	mov    %rsi,%r12
 106d3cd:	mov    %fs:0x28,%rax
 106d3d6:	mov    %rax,0x800(%rsp)
 106d3de:	vmovdqu64 %zmm0,0x380(%rdi)
 106d3e5:	vmovdqu64 %zmm0,0x340(%rdi)
 106d3ec:	vmovdqu64 %zmm0,0x300(%rdi)
 106d3f3:	vmovdqu64 %zmm0,0x2c0(%rdi)
 106d3fa:	vmovdqu64 %zmm0,0x280(%rdi)
 106d401:	vmovdqu64 %zmm0,0x240(%rdi)
 106d408:	vmovdqu64 %zmm0,0x200(%rdi)
 106d40f:	vmovdqu64 %zmm0,0x1c0(%rdi)
 106d416:	vmovdqu64 %zmm0,0x180(%rdi)
 106d41d:	vmovdqu64 %zmm0,0x140(%rdi)
 106d424:	vmovdqu64 %zmm0,0x100(%rdi)
 106d42b:	vmovdqu64 %zmm0,0xc0(%rdi)
 106d432:	vmovdqu64 %zmm0,0x80(%rdi)
 106d439:	vmovdqu64 %zmm0,0x40(%rdi)
 106d440:	vmovdqu64 %zmm0,(%rdi)
 106d446:	movq   $0x0,0x3c0(%rdi)
 106d451:	mov    %rdx,0x58(%rsp)
 106d456:	mov    %rdi,0x18(%rsp)
 106d45b:	mov    0x30(%rsi),%r8d
 106d45f:	vaesenc %zmm0,%zmm1,%zmm1
 106d465:	vaesenc %zmm0,%zmm1,%zmm0
 106d46b:	mov    %r8d,0x364(%rdi)
 106d472:	mov    %r8d,%eax
 106d475:	mov    %rax,0x78(%rsp)
 106d47a:	mov    %r8,0xf0(%rsp)
 106d482:	xor    %eax,%eax
 106d484:	mov    0x270(%rdx),%rdx
 106d48b:	vextracti64x4 $0x1,%zmm0,%ymm1
 106d492:	vpxorq %zmm0,%zmm1,%zmm0
 106d498:	vextracti128 $0x1,%ymm0,%xmm1
 106d49e:	mov    0x8(%rdx),%rsi
 106d4a2:	mov    (%rdx),%rdi
 106d4a5:	vpxor  %xmm0,%xmm1,%xmm0
 106d4a9:	vpxor  %xmm1,%xmm1,%xmm1
 106d4ad:	vaesenc %xmm1,%xmm0,%xmm0
 106d4b2:	vmovdqa -0xade0da(%rip),%xmm1        # 58f3e0 <abi_test_hex.digits+0xa50>
 106d4ba:	vmovq  %xmm0,%rcx
 106d4bf:	vbroadcasti32x4 -0xade0e9(%rip),%zmm0        # 58f3e0 <abi_test_hex.digits+0xa50>
 106d4c9:	and    %rsi,%rcx
 106d4cc:	nopl   0x0(%rax)
 106d4d0:	mov    %rcx,%r8
 106d4d3:	shl    $0x6,%r8
 106d4d7:	vmovdqa64 (%rdi,%r8,1),%zmm3
 106d4de:	vpcmpeqd %zmm0,%zmm3,%k0
 106d4e4:	kmovd  %k0,%r9d
 106d4e8:	and    $0x7777,%r9d
 106d4ef:	add    $0x1111,%r9d
 106d4f6:	and    $0x8888,%r9w
 106d4fc:	je     106d570 <check_input_run+0x1e0>
 106d4fe:	mov    0x10(%rdx),%r10
 106d502:	add    %rdi,%r8
 106d505:	movzwl %r9w,%r9d
 106d509:	jmp    106d51f <check_input_run+0x18f>
 106d50b:	nopl   0x0(%rax,%rax,1)
 106d510:	xor    %r11d,%r11d
 106d513:	test   %r11b,%r11b
 106d516:	jne    106d573 <check_input_run+0x1e3>
 106d518:	blsr   %r9d,%r9d
 106d51d:	je     106d573 <check_input_run+0x1e3>
 106d51f:	xor    %r11d,%r11d
 106d522:	tzcnt  %r9d,%r11d
 106d527:	mov    (%r8,%r11,4),%ebx
 106d52b:	cmpl   $0x11,0x4(%r10,%rbx,8)
 106d531:	jne    106d510 <check_input_run+0x180>
 106d533:	mov    0x40(%rdx),%r11
 106d537:	mov    (%r10,%rbx,8),%r14d
 106d53b:	vpxor  (%r11,%r14,1),%xmm1,%xmm5
 106d541:	movzbl 0x10(%r11,%r14,1),%ebp
 106d547:	vmovd  %ebp,%xmm4
 106d54b:	vpternlogq $0xf6,%xmm2,%xmm4,%xmm5
 106d552:	vptest %xmm5,%xmm5
 106d557:	sete   %r11b
 106d55b:	cmove  %ebx,%eax
 106d55e:	test   %r11b,%r11b
 106d561:	je     106d518 <check_input_run+0x188>
 106d563:	jmp    106d573 <check_input_run+0x1e3>
 106d565:	data16 cs nopw 0x0(%rax,%rax,1)
 106d570:	xor    %r11d,%r11d
 106d573:	vptestnmd %zmm3,%zmm3,%k0
 106d579:	kmovd  %k0,%r8d
 106d57d:	test   $0x8888,%r8d
 106d584:	jne    106d595 <check_input_run+0x205>
 106d586:	inc    %rcx
 106d589:	and    %rsi,%rcx
 106d58c:	test   %r11b,%r11b
 106d58f:	je     106d4d0 <check_input_run+0x140>
 106d595:	vmovdqa64 -0xbd019f(%rip),%zmm1        # 49d400 <cbuiltin_test_generated.edges+0x35c0>
 106d59f:	vpxor  %xmm0,%xmm0,%xmm0
 106d5a3:	vmovdqa -0xade19b(%rip),%xmm2        # 58f410 <abi_test_hex.digits+0xa80>
 106d5ab:	xor    %ecx,%ecx
 106d5ad:	vaesenc %zmm0,%zmm1,%zmm1
 106d5b3:	vaesenc %zmm0,%zmm1,%zmm0
 106d5b9:	vextracti64x4 $0x1,%zmm0,%ymm1
 106d5c0:	vpxorq %zmm0,%zmm1,%zmm0
 106d5c6:	vextracti128 $0x1,%ymm0,%xmm1
 106d5cc:	vpxor  %xmm0,%xmm1,%xmm0
 106d5d0:	vpxor  %xmm1,%xmm1,%xmm1
 106d5d4:	vaesenc %xmm1,%xmm0,%xmm0
 106d5d9:	vmovdqa -0xade1e1(%rip),%xmm1        # 58f400 <abi_test_hex.digits+0xa70>
 106d5e1:	vmovq  %xmm0,%r8
 106d5e6:	vbroadcasti32x4 -0xade1f0(%rip),%zmm0        # 58f400 <abi_test_hex.digits+0xa70>
 106d5f0:	and    %rsi,%r8
 106d5f3:	mov    %r8,%r9
 106d5f6:	shl    $0x6,%r9
 106d5fa:	vmovdqa64 (%rdi,%r9,1),%zmm3
 106d601:	vpcmpeqd %zmm0,%zmm3,%k0
 106d607:	kmovd  %k0,%r10d
 106d60b:	and    $0x7777,%r10d
 106d612:	add    $0x1111,%r10d
 106d619:	and    $0x8888,%r10w
 106d61f:	je     106d680 <check_input_run+0x2f0>
 106d621:	mov    0x10(%rdx),%r11
 106d625:	add    %rdi,%r9
 106d628:	movzwl %r10w,%r10d
 106d62c:	jmp    106d63d <check_input_run+0x2ad>
 106d62e:	xchg   %ax,%ax
 106d630:	xor    %ebx,%ebx
 106d632:	test   %bl,%bl
 106d634:	jne    106d682 <check_input_run+0x2f2>
 106d636:	blsr   %r10d,%r10d
 106d63b:	je     106d682 <check_input_run+0x2f2>
 106d63d:	xor    %ebx,%ebx
 106d63f:	tzcnt  %r10d,%ebx
 106d644:	mov    (%r9,%rbx,4),%r14d
 106d648:	cmpl   $0x15,0x4(%r11,%r14,8)
 106d64e:	jne    106d630 <check_input_run+0x2a0>
 106d650:	mov    0x40(%rdx),%rbx
 106d654:	mov    (%r11,%r14,8),%r15d
 106d658:	vpxor  (%rbx,%r15,1),%xmm1,%xmm4
 106d65e:	vpternlogq $0xf6,0x5(%rbx,%r15,1),%xmm2,%xmm4
 106d66a:	vptest %xmm4,%xmm4
 106d66f:	sete   %bl
 106d672:	cmove  %r14d,%ecx
 106d676:	test   %bl,%bl
 106d678:	je     106d636 <check_input_run+0x2a6>
 106d67a:	jmp    106d682 <check_input_run+0x2f2>
 106d67c:	nopl   0x0(%rax)
 106d680:	xor    %ebx,%ebx
 106d682:	vptestnmd %zmm3,%zmm3,%k0
 106d688:	kmovd  %k0,%r9d
 106d68c:	test   $0x8888,%r9d
 106d693:	jne    106d6a0 <check_input_run+0x310>
 106d695:	inc    %r8
 106d698:	test   %bl,%bl
 106d69a:	je     106d5f0 <check_input_run+0x260>
 106d6a0:	mov    0xf0(%rsp),%rsi
 106d6a8:	mov    %r12,0x20(%rsp)
 106d6ad:	test   %esi,%esi
 106d6af:	je     106d6de <check_input_run+0x34e>
 106d6b1:	mov    0x18(%rsp),%rdx
 106d6b6:	mov    0x10(%r12),%r10
 106d6bb:	xor    %r11d,%r11d
 106d6be:	mov    0x33c(%rdx),%ebp
 106d6c4:	mov    0x34c(%rdx),%r8d
 106d6cb:	cmp    $0x1,%esi
 106d6ce:	jne    106d70c <check_input_run+0x37c>
 106d6d0:	xor    %esi,%esi
 106d6d2:	xor    %edx,%edx
 106d6d4:	xor    %r14d,%r14d
 106d6d7:	xor    %ebx,%ebx
 106d6d9:	jmp    106d8d9 <check_input_run+0x549>
 106d6de:	mov    0x18(%rsp),%r15
 106d6e3:	xor    %r14d,%r14d
 106d6e6:	xor    %r13d,%r13d
 106d6e9:	movq   $0x0,0xe8(%rsp)
 106d6f5:	movl   $0x0,0x130(%rsp)
 106d700:	mov    0x33c(%r15),%ebp
 106d707:	jmp    106d986 <check_input_run+0x5f6>
 106d70c:	mov    0x78(%rsp),%rdx
 106d711:	and    $0xfffffffe,%edx
 106d714:	xor    %esi,%esi
 106d716:	xor    %r14d,%r14d
 106d719:	xor    %ebx,%ebx
 106d71b:	mov    %rdx,0xd0(%rsp)
 106d723:	xor    %edx,%edx
 106d725:	jmp    106d7aa <check_input_run+0x41a>
 106d72a:	nopw   0x0(%rax,%rax,1)
 106d730:	movzbl 0x28(%rsp),%ebx
 106d735:	mov    0x130(%rsp),%r14d
 106d73d:	or     0x90(%rsp),%r13b
 106d745:	mov    %r9b,%dil
 106d748:	mov    %bl,%r11b
 106d74b:	mov    %edx,%ebx
 106d74d:	mov    0xe8(%rsp),%rdx
 106d755:	add    %r15d,%r14d
 106d758:	and    %r13b,%r12b
 106d75b:	add    %r10d,%r14d
 106d75e:	add    %r11d,%ebx
 106d761:	mov    %edx,%r10d
 106d764:	mov    %edi,%edx
 106d766:	add    %ebx,%edx
 106d768:	or     %r12b,%r10b
 106d76b:	mov    0x20(%rsp),%r12
 106d770:	mov    0x18(%r12),%rdi
 106d775:	mov    0x4(%rdi,%rsi,4),%edi
 106d779:	test   %edi,%edi
 106d77b:	setne  %r9b
 106d77f:	cmp    %eax,%edi
 106d781:	sete   %r11b
 106d785:	cmp    %ecx,%edi
 106d787:	sete   %bl
 106d78a:	add    $0x2,%rsi
 106d78e:	or     %r11b,%bl
 106d791:	and    %r9b,%bl
 106d794:	or     %r10b,%bl
 106d797:	mov    0x48(%rsp),%r10
 106d79c:	cmp    %rsi,0xd0(%rsp)
 106d7a4:	je     106d8c8 <check_input_run+0x538>
 106d7aa:	mov    %ebp,%edi
 106d7ac:	xor    %ebp,%ebp
 106d7ae:	cmpb   $0x6,(%r10,%rsi,1)
 106d7b3:	mov    0x18(%rsp),%r10
 106d7b8:	mov    %r8d,%r9d
 106d7bb:	mov    $0x0,%r15d
 106d7c1:	mov    %r14d,0x130(%rsp)
 106d7c9:	mov    %rbx,0xe8(%rsp)
 106d7d1:	sete   %bpl
 106d7d5:	xor    %r8d,%r8d
 106d7d8:	add    %edi,%ebp
 106d7da:	mov    %ebp,0x33c(%r10)
 106d7e1:	mov    0x10(%r12),%rdi
 106d7e6:	cmpb   $0x3d,(%rdi,%rsi,1)
 106d7ea:	sete   %r8b
 106d7ee:	xor    %r11d,%r11d
 106d7f1:	add    %r9d,%r8d
 106d7f4:	mov    %r8d,0x34c(%r10)
 106d7fb:	mov    0x10(%r12),%rdi
 106d800:	mov    0x50(%r12),%r10
 106d805:	movzbl (%rdi,%rsi,1),%r9d
 106d80a:	cmp    $0x40,%r9b
 106d80e:	sete   0x28(%rsp)
 106d813:	test   %r10,%r10
 106d816:	je     106d82a <check_input_run+0x49a>
 106d818:	cmpb   $0xb,(%r10,%rsi,1)
 106d81d:	jne    106d82a <check_input_run+0x49a>
 106d81f:	xor    %r15d,%r15d
 106d822:	cmp    $0xc,%r9b
 106d826:	sete   %r15b
 106d82a:	mov    0x18(%r12),%r9
 106d82f:	mov    %r12,%rbx
 106d832:	mov    0x18(%rsp),%r10
 106d837:	mov    (%r9,%rsi,4),%r9d
 106d83b:	test   %r9d,%r9d
 106d83e:	setne  %r12b
 106d842:	cmp    %eax,%r9d
 106d845:	sete   %r13b
 106d849:	cmp    %ecx,%r9d
 106d84c:	sete   0x90(%rsp)
 106d854:	xor    %r9d,%r9d
 106d857:	cmpb   $0x6,0x1(%rdi,%rsi,1)
 106d85c:	sete   %r9b
 106d860:	add    %r9d,%ebp
 106d863:	xor    %r9d,%r9d
 106d866:	mov    %ebp,0x33c(%r10)
 106d86d:	mov    0x10(%rbx),%rdi
 106d871:	cmpb   $0x3d,0x1(%rdi,%rsi,1)
 106d876:	sete   %r9b
 106d87a:	add    %r9d,%r8d
 106d87d:	mov    %r8d,0x34c(%r10)
 106d884:	mov    0x10(%rbx),%rdi
 106d888:	mov    0x50(%rbx),%rbx
 106d88c:	movzbl 0x1(%rdi,%rsi,1),%r14d
 106d892:	mov    %rdi,0x48(%rsp)
 106d897:	xor    %edi,%edi
 106d899:	cmp    $0x40,%r14b
 106d89d:	sete   %r9b
 106d8a1:	xor    %r10d,%r10d
 106d8a4:	test   %rbx,%rbx
 106d8a7:	je     106d730 <check_input_run+0x3a0>
 106d8ad:	cmpb   $0xb,0x1(%rbx,%rsi,1)
 106d8b2:	jne    106d730 <check_input_run+0x3a0>
 106d8b8:	xor    %r10d,%r10d
 106d8bb:	cmp    $0xc,%r14b
 106d8bf:	sete   %r10b
 106d8c3:	jmp    106d730 <check_input_run+0x3a0>
 106d8c8:	testb  $0x1,0x78(%rsp)
 106d8cd:	mov    $0x0,%r11d
 106d8d3:	je     106d965 <check_input_run+0x5d5>
 106d8d9:	mov    %ebp,%edi
 106d8db:	xor    %ebp,%ebp
 106d8dd:	cmpb   $0x6,(%r10,%rsi,1)
 106d8e2:	mov    0x18(%rsp),%r10
 106d8e7:	sete   %bpl
 106d8eb:	xor    %r9d,%r9d
 106d8ee:	add    %edi,%ebp
 106d8f0:	mov    %ebp,0x33c(%r10)
 106d8f7:	mov    0x10(%r12),%rdi
 106d8fc:	cmpb   $0x3d,(%rdi,%rsi,1)
 106d900:	sete   %r9b
 106d904:	add    %r8d,%r9d
 106d907:	mov    %r9d,0x34c(%r10)
 106d90e:	mov    0x10(%r12),%rdi
 106d913:	mov    0x50(%r12),%r9
 106d918:	movzbl (%rdi,%rsi,1),%r8d
 106d91d:	xor    %edi,%edi
 106d91f:	cmp    $0x40,%r8b
 106d923:	sete   %dil
 106d927:	test   %r9,%r9
 106d92a:	je     106d93e <check_input_run+0x5ae>
 106d92c:	cmpb   $0xb,(%r9,%rsi,1)
 106d931:	jne    106d93e <check_input_run+0x5ae>
 106d933:	xor    %r11d,%r11d
 106d936:	cmp    $0xc,%r8b
 106d93a:	sete   %r11b
 106d93e:	add    %edi,%edx
 106d940:	mov    0x18(%r12),%rdi
 106d945:	add    %r14d,%r11d
 106d948:	mov    %r11d,%r14d
 106d94b:	mov    (%rdi,%rsi,4),%esi
 106d94e:	test   %esi,%esi
 106d950:	setne  %dil
 106d954:	cmp    %eax,%esi
 106d956:	sete   %al
 106d959:	cmp    %ecx,%esi
 106d95b:	sete   %cl
 106d95e:	or     %al,%cl
 106d960:	and    %dil,%cl
 106d963:	or     %cl,%bl
 106d965:	mov    0x18(%rsp),%r15
 106d96a:	mov    0x78(%rsp),%r13
 106d96f:	mov    %r14d,0x130(%rsp)
 106d977:	mov    %edx,%r14d
 106d97a:	shl    $0x2,%r14
 106d97e:	mov    %rbx,0xe8(%rsp)
 106d986:	mov    0x38(%rsp),%rbx
 106d98b:	lea    0x2d0(%rsp),%rdi
 106d993:	mov    $0x430,%edx
 106d998:	xor    %esi,%esi
 106d99a:	mov    0x8(%rbx),%rax
 106d99e:	mov    %rax,0x270(%rsp)
 106d9a6:	vzeroupper
 106d9a9:	call   788430 <memset@plt>
 106d9ae:	mov    0x58(%rsp),%rax
 106d9b3:	mov    0xa0(%rsp),%rcx
 106d9bb:	vpbroadcastb -0xbd0382(%rip),%xmm1        # 49d642 <cbuiltin_test_generated.edges+0x3802>
 106d9c4:	mov    %r15,0x2a0(%rsp)
 106d9cc:	mov    %r12,0x2a8(%rsp)
 106d9d4:	mov    0x848(%rsp),%edi
 106d9db:	mov    0x860(%rsp),%rdx
 106d9e3:	vpcmpeqd %xmm0,%xmm0,%xmm0
 106d9e7:	add    %r13,%r14
 106d9ea:	mov    %r13,0x78(%rsp)
 106d9ef:	mov    %rax,0x2b0(%rsp)
 106d9f7:	mov    0xf0(%rsp),%rax
 106d9ff:	mov    %rcx,0x2b8(%rsp)
 106da07:	mov    0x10(%rsp),%rcx
 106da0c:	lea    0x1(%rax),%esi
 106da0f:	mov    %rcx,0x2c0(%rsp)
 106da17:	mov    %rbx,0x2c8(%rsp)
 106da1f:	movl   $0xffffffff,0x360(%rsp)
 106da2a:	vmovdqu %xmm0,0x378(%rsp)
 106da33:	vmovdqu %xmm0,0x384(%rsp)
 106da3c:	vpinsrd $0x1,%esi,%xmm1,%xmm1
 106da42:	mov    %rsi,0xd8(%rsp)
 106da4a:	vmovdqu %xmm1,0x65c(%rsp)
 106da53:	mov    %eax,0x670(%rsp)
 106da5a:	mov    %edi,0x674(%rsp)
 106da61:	mov    %rdx,0x6e8(%rsp)
 106da69:	mov    %ebp,%eax
 106da6b:	lea    (%r14,%rax,8),%rdx
 106da6f:	lea    0x1(%r14,%rax,8),%rax
 106da74:	vmovdqu %xmm0,0x6d0(%rsp)
 106da7d:	movl   $0xffffffff,0x6e0(%rsp)
 106da88:	mov    %rdx,0x88(%rsp)
 106da90:	mov    %rax,0x100(%rsp)
 106da98:	cmp    %rbx,%rcx
 106da9b:	je     106db7d <check_input_run+0x7ed>
 106daa1:	cmpl   $0x0,0xa0(%r12)
 106daaa:	jne    106db7d <check_input_run+0x7ed>
 106dab0:	cmpl   $0x0,0xa4(%r12)
 106dab9:	jne    106db7d <check_input_run+0x7ed>
 106dabf:	mov    0xf0(%rsp),%rdx
 106dac7:	mov    0x18(%rsp),%r15
 106dacc:	test   %edx,%edx
 106dace:	sete   %al
 106dad1:	cmpq   $0x0,0x68(%r12)
 106dad7:	setne  %cl
 106dada:	or     %al,%cl
 106dadc:	cmp    $0x3fffffff,%edx
 106dae2:	setb   %al
 106dae5:	and    %cl,%al
 106dae7:	mov    $0xffffffff,%ecx
 106daec:	cmp    %rcx,0x88(%rsp)
 106daf4:	setb   %cl
 106daf7:	cmp    %edx,%edi
 106daf9:	setbe  %dl
 106dafc:	and    %al,%dl
 106dafe:	and    %cl,%dl
 106db00:	cmp    $0x1,%dl
 106db03:	jne    106db7d <check_input_run+0x7ed>
 106db05:	lea    0xbd4bf4(%rip),%r14        # 1c42700 <type_builtins+0x200>
 106db0c:	xor    %r12d,%r12d
 106db0f:	nop
 106db10:	mov    0x58(%rsp),%rax
 106db15:	mov    (%r14),%r15
 106db18:	mov    0x270(%rax),%rbx
 106db1f:	mov    %r15,%rdi
 106db22:	call   787f00 <strlen@plt>
 106db27:	mov    %rbx,%rdi
 106db2a:	mov    %r15,%rsi
 106db2d:	mov    %eax,%edx
 106db2f:	call   101ba80 <intern_find_or_add>
 106db34:	mov    %eax,0x6a4(%rsp,%r12,4)
 106db3c:	test   %eax,%eax
 106db3e:	je     106db4f <check_input_run+0x7bf>
 106db40:	add    $0x8,%r14
 106db44:	cmp    $0x9,%r12
 106db48:	lea    0x1(%r12),%r12
 106db4d:	jb     106db10 <check_input_run+0x780>
 106db4f:	mov    0x18(%rsp),%r15
 106db54:	mov    0x20(%rsp),%r12
 106db59:	mov    0xd8(%rsp),%rsi
 106db61:	test   %eax,%eax
 106db63:	je     106db7d <check_input_run+0x7ed>
 106db65:	mov    0x58(%rsp),%rax
 106db6a:	mov    0x270(%rax),%rax
 106db71:	mov    %rax,0x48(%rsp)
 106db76:	xor    %eax,%eax
 106db78:	jmp    106df72 <check_input_run+0xbe2>
 106db7d:	mov    %r15,%rdi
 106db80:	mov    %esi,0x234(%r15)
 106db87:	lea    0x228(%rdi),%r9
 106db8e:	movq   $0x0,0x228(%rdi)
 106db99:	mov    0x10(%rsp),%rsi
 106db9e:	lea    0x238(%rdi),%rax
 106dba5:	movq   $0x0,0x238(%rdi)
 106dbb0:	movq   $0x0,0x240(%rdi)
 106dbbb:	movq   $0x0,0x248(%rdi)
 106dbc6:	movq   $0x0,0x260(%rdi)
 106dbd1:	mov    %rax,0x68(%rsp)
 106dbd6:	lea    0x268(%rdi),%rax
 106dbdd:	movq   $0x0,0x268(%rdi)
 106dbe8:	lea    0x250(%rdi),%rcx
 106dbef:	movq   $0x0,0x250(%rdi)
 106dbfa:	mov    %rcx,0x98(%rsp)
 106dc02:	lea    0x258(%rdi),%rcx
 106dc09:	movq   $0x0,0x258(%rdi)
 106dc14:	movq   $0x0,0x270(%rdi)
 106dc1f:	mov    %rcx,0x110(%rsp)
 106dc27:	lea    0x278(%rdi),%rcx
 106dc2e:	movq   $0x0,0x278(%rdi)
 106dc39:	mov    %rcx,0x60(%rsp)
 106dc3e:	lea    0x280(%rdi),%rcx
 106dc45:	movq   $0x0,0x280(%rdi)
 106dc50:	mov    %rcx,0xb8(%rsp)
 106dc58:	lea    0x288(%rdi),%rcx
 106dc5f:	movq   $0x0,0x288(%rdi)
 106dc6a:	movq   $0x0,0x290(%rdi)
 106dc75:	movq   $0x0,0x298(%rdi)
 106dc80:	mov    %rcx,0x50(%rsp)
 106dc85:	lea    0x2a0(%rdi),%rcx
 106dc8c:	movq   $0x0,0x2a0(%rdi)
 106dc97:	mov    %rcx,0x118(%rsp)
 106dc9f:	lea    0x2a8(%rdi),%rcx
 106dca6:	movq   $0x0,0x2a8(%rdi)
 106dcb1:	mov    %rcx,0x150(%rsp)
 106dcb9:	lea    0x2b0(%rdi),%rcx
 106dcc0:	movq   $0x0,0x2b0(%rdi)
 106dccb:	mov    %rcx,0x260(%rsp)
 106dcd3:	lea    0x2b8(%rdi),%rcx
 106dcda:	movq   $0x0,0x2b8(%rdi)
 106dce5:	mov    %rcx,0x258(%rsp)
 106dced:	lea    0x2c0(%rdi),%rcx
 106dcf4:	movq   $0x0,0x2c0(%rdi)
 106dcff:	movq   $0x0,0x2c8(%rdi)
 106dd0a:	movq   $0x0,0x2d0(%rdi)
 106dd15:	mov    %rcx,0x148(%rsp)
 106dd1d:	lea    0x2d8(%rdi),%rcx
 106dd24:	movq   $0x0,0x2d8(%rdi)
 106dd2f:	movq   $0x0,0x2e0(%rdi)
 106dd3a:	lea    0x2e0(%rdi),%rdx
 106dd41:	movq   $0x0,0x2e8(%rdi)
 106dd4c:	lea    0x2f0(%rdi),%r8
 106dd53:	movq   $0x0,0x2f0(%rdi)
 106dd5e:	lea    0x2f8(%rdi),%r10
 106dd65:	movq   $0x0,0x2f8(%rdi)
 106dd70:	lea    0x300(%rdi),%r11
 106dd77:	movq   $0x0,0x300(%rdi)
 106dd82:	movq   $0x0,0x310(%rdi)
 106dd8d:	lea    0x310(%rdi),%rbx
 106dd94:	movq   $0x0,0x318(%rdi)
 106dd9f:	mov    %rcx,0x80(%rsp)
 106dda7:	lea    0x320(%rdi),%rcx
 106ddae:	mov    %rbx,0x108(%rsp)
 106ddb6:	mov    %r11,0xe0(%rsp)
 106ddbe:	mov    %r10,0xb0(%rsp)
 106ddc6:	mov    %r8,0xf8(%rsp)
 106ddce:	mov    %rdx,0xa8(%rsp)
 106ddd6:	mov    %rax,0x40(%rsp)
 106dddb:	movq   $0x0,0x320(%rdi)
 106dde6:	mov    %rcx,0x128(%rsp)
 106ddee:	lea    0x350(%rdi),%rax
 106ddf5:	movq   $0x0,0x350(%rdi)
 106de00:	xor    %ebx,%ebx
 106de02:	xor    %r15d,%r15d
 106de05:	mov    %rax,0x120(%rsp)
 106de0d:	mov    $0x358,%eax
 106de12:	mov    %r9,0x30(%rsp)
 106de17:	mov    %rbx,(%rdi,%rax,1)
 106de1b:	mov    0x240(%rdi),%rax
 106de22:	mov    0x100(%rsp),%rdx
 106de2a:	mov    0xd8(%rsp),%rcx
 106de32:	mov    %rdi,%rbx
 106de35:	mov    %rax,0x340(%rsp)
 106de3d:	mov    0x248(%rdi),%rax
 106de44:	mov    %rax,0x3a0(%rsp)
 106de4c:	mov    0x260(%rdi),%rax
 106de53:	mov    %rax,0x3d0(%rsp)
 106de5b:	mov    0x268(%rdi),%rax
 106de62:	mov    %rax,0x3b8(%rsp)
 106de6a:	mov    0x270(%rdi),%rax
 106de71:	mov    %rax,0x3c0(%rsp)
 106de79:	mov    0x290(%rdi),%rax
 106de80:	mov    %rax,0x3c8(%rsp)
 106de88:	mov    0x298(%rdi),%rax
 106de8f:	mov    %rax,0x3a8(%rsp)
 106de97:	mov    0x2e8(%rdi),%rax
 106de9e:	mov    %rax,0x580(%rsp)
 106dea6:	mov    0x2f0(%rdi),%rax
 106dead:	mov    %rax,0x588(%rsp)
 106deb5:	vzeroupper
 106deb8:	call   1080e50 <check_graph_initialize>
 106debd:	movzbl 0x8(%r12),%ecx
 106dec3:	or     $0x2,%ecx
 106dec6:	mov    %ecx,0x88(%rbx)
 106decc:	test   %r15b,%r15b
 106decf:	je     106e1e3 <check_input_run+0xe53>
 106ded5:	test   %al,%al
 106ded7:	je     106e1e3 <check_input_run+0xe53>
 106dedd:	mov    0x10(%rsp),%rcx
 106dee2:	mov    0x8(%rcx),%rax
 106dee6:	mov    0x10(%rcx),%rcx
 106deea:	sub    %rax,%rcx
 106deed:	jb     106e1e3 <check_input_run+0xe53>
 106def3:	cmp    %rcx,0x88(%rsp)
 106defb:	jae    106e1e3 <check_input_run+0xe53>
 106df01:	mov    0x100(%rsp),%rcx
 106df09:	mov    0x10(%rsp),%rdi
 106df0e:	add    %rax,%rcx
 106df11:	mov    %rcx,0x8(%rdi)
 106df15:	mov    0x18(%rsp),%rcx
 106df1a:	add    (%rdi),%rax
 106df1d:	mov    %rax,0x50(%rcx)
 106df21:	mov    $0xb0,%ecx
 106df26:	je     106df44 <check_input_run+0xbb4>
 106df28:	mov    (%rdi),%rax
 106df2b:	mov    0x8(%rdi),%rsi
 106df2f:	lea    0x3f(%rsi,%rax,1),%rdx
 106df34:	add    %rax,%rsi
 106df37:	and    $0xffffffffffffffc0,%rdx
 106df3b:	cmp    %rsi,%rdx
 106df3e:	jae    106e82f <check_input_run+0x149f>
 106df44:	mov    0x18(%rsp),%rdi
 106df49:	jmp    106e1f5 <check_input_run+0xe65>
 106df4e:	xchg   %ax,%ax
 106df50:	mov    0xc0(%rsp),%rax
 106df58:	mov    0x20(%rsp),%r12
 106df5d:	mov    %r14d,0x67c(%rsp,%rax,4)
 106df65:	inc    %rax
 106df68:	cmp    $0x5,%rax
 106df6c:	je     107147a <check_input_run+0x40ea>
 106df72:	lea    0xbd47d7(%rip),%rcx        # 1c42750 <parse_predeclared_typedefs>
 106df79:	mov    %rax,0xc0(%rsp)
 106df81:	mov    (%rcx,%rax,8),%rbx
 106df85:	mov    %rbx,%rdi
 106df88:	vzeroupper
 106df8b:	call   787f00 <strlen@plt>
 106df90:	kxnorq %k0,%k0,%k1
 106df95:	mov    %rax,%rdx
 106df98:	mov    %edx,%r14d
 106df9b:	cmp    $0x3f,%edx
 106df9e:	ja     106dfb1 <check_input_run+0xc21>
 106dfa0:	mov    $0xffffffffffffffff,%rax
 106dfa7:	bzhi   %r14,%rax,%rax
 106dfac:	kmovq  %rax,%k1
 106dfb1:	vmovdqu8 (%rbx),%zmm0{%k1}{z}
 106dfb7:	vmovd  %r14d,%xmm1
 106dfbc:	vpxor  %xmm2,%xmm2,%xmm2
 106dfc0:	mov    %rdx,0x28(%rsp)
 106dfc5:	vpternlogq $0x96,-0xbd0b50(%rip),%zmm0,%zmm1        # 49d480 <cbuiltin_test_generated.edges+0x3640>
 106dfd0:	vaesenc %zmm2,%zmm1,%zmm0
 106dfd6:	vaesenc %zmm2,%zmm0,%zmm0
 106dfdc:	vextracti64x4 $0x1,%zmm0,%ymm1
 106dfe3:	vpxorq %zmm0,%zmm1,%zmm0
 106dfe9:	vextracti128 $0x1,%ymm0,%xmm1
 106dfef:	vpxor  %xmm0,%xmm1,%xmm0
 106dff3:	cmp    $0x41,%edx
 106dff6:	jb     106e00b <check_input_run+0xc7b>
 106dff8:	mov    %rbx,%rdi
 106dffb:	mov    %r14,%rsi
 106dffe:	vzeroupper
 106e001:	call   101c280 <intern_chain_chunks>
 106e006:	mov    0x28(%rsp),%rdx
 106e00b:	vpxor  %xmm1,%xmm1,%xmm1
 106e00f:	vaesenc %xmm1,%xmm0,%xmm0
 106e014:	cmp    $0x10,%edx
 106e017:	mov    $0x10,%eax
 106e01c:	mov    $0xffff,%ecx
 106e021:	cmovb  %edx,%eax
 106e024:	bzhi   %eax,%ecx,%eax
 106e029:	kmovd  %eax,%k1
 106e02d:	mov    0x48(%rsp),%rax
 106e032:	vmovq  %xmm0,%r12
 106e037:	vmovdqu8 (%rbx),%xmm0{%k1}{z}
 106e03d:	mov    0x8(%rax),%rdi
 106e041:	mov    (%rax),%rsi
 106e044:	vshufi64x2 $0x0,%zmm0,%zmm0,%zmm0
 106e04b:	and    %rdi,%r12
 106e04e:	vmovdqu64 %zmm0,0x210(%rsp)
 106e059:	cmp    $0xc,%edx
 106e05c:	jae    106e0d0 <check_input_run+0xd40>
 106e05e:	xor    %r14d,%r14d
 106e061:	jmp    106e08f <check_input_run+0xcff>
 106e063:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 106e070:	vptestnmd %zmm0,%zmm0,%k0
 106e076:	inc    %r12
 106e079:	kmovd  %k0,%ecx
 106e07d:	and    %rdi,%r12
 106e080:	and    $0x8888,%ecx
 106e086:	or     %cx,%ax
 106e089:	jne    106df50 <check_input_run+0xbc0>
 106e08f:	mov    %r12,%rcx
 106e092:	shl    $0x6,%rcx
 106e096:	vmovdqa64 (%rsi,%rcx,1),%zmm0
 106e09d:	vpcmpeqd 0x210(%rsp),%zmm0,%k0
 106e0a8:	kmovd  %k0,%eax
 106e0ac:	and    $0x7777,%eax
 106e0b1:	add    $0x1111,%eax
 106e0b6:	and    $0x8888,%ax
 106e0ba:	je     106e070 <check_input_run+0xce0>
 106e0bc:	add    %rsi,%rcx
 106e0bf:	xor    %edx,%edx
 106e0c1:	tzcnt  %eax,%edx
 106e0c5:	mov    (%rcx,%rdx,4),%r14d
 106e0c9:	jmp    106e070 <check_input_run+0xce0>
 106e0cb:	nopl   0x0(%rax,%rax,1)
 106e0d0:	mov    %r14,0xd0(%rsp)
 106e0d8:	xor    %r14d,%r14d
 106e0db:	mov    %rbx,0x90(%rsp)
 106e0e3:	mov    %rsi,0xc8(%rsp)
 106e0eb:	mov    %rdi,0x70(%rsp)
 106e0f0:	mov    %r12,%r13
 106e0f3:	shl    $0x6,%r13
 106e0f7:	vmovdqa64 (%rsi,%r13,1),%zmm0
 106e0fe:	vpcmpeqd 0x210(%rsp),%zmm0,%k0
 106e109:	vmovdqu64 %zmm0,0x1b0(%rsp)
 106e114:	kmovd  %k0,%eax
 106e118:	and    $0x7777,%eax
 106e11d:	add    $0x1111,%eax
 106e122:	and    $0x8888,%ax
 106e126:	je     106e1a0 <check_input_run+0xe10>
 106e128:	mov    0x48(%rsp),%rcx
 106e12d:	add    %rsi,%r13
 106e130:	movzwl %ax,%ebx
 106e133:	mov    0x10(%rcx),%rbp
 106e137:	jmp    106e14d <check_input_run+0xdbd>
 106e139:	nopl   0x0(%rax)
 106e140:	xor    %eax,%eax
 106e142:	test   %al,%al
 106e144:	jne    106e1a2 <check_input_run+0xe12>
 106e146:	blsr   %ebx,%ebx
 106e14b:	je     106e1a2 <check_input_run+0xe12>
 106e14d:	xor    %eax,%eax
 106e14f:	tzcnt  %ebx,%eax
 106e153:	mov    0x0(%r13,%rax,4),%r15d
 106e158:	cmp    %edx,0x4(%rbp,%r15,8)
 106e15d:	jne    106e140 <check_input_run+0xdb0>
 106e15f:	mov    0x48(%rsp),%rax
 106e164:	mov    0x0(%rbp,%r15,8),%edi
 106e169:	mov    0x90(%rsp),%rsi
 106e171:	mov    0xd0(%rsp),%rdx
 106e179:	add    0x40(%rax),%rdi
 106e17d:	vzeroupper
 106e180:	call   7883c0 <bcmp@plt>
 106e185:	mov    0x28(%rsp),%rdx
 106e18a:	test   %eax,%eax
 106e18c:	sete   %al
 106e18f:	cmove  %r15d,%r14d
 106e193:	test   %al,%al
 106e195:	je     106e146 <check_input_run+0xdb6>
 106e197:	jmp    106e1a2 <check_input_run+0xe12>
 106e199:	nopl   0x0(%rax)
 106e1a0:	xor    %eax,%eax
 106e1a2:	vmovdqu64 0x1b0(%rsp),%zmm0
 106e1ad:	vptestnmd %zmm0,%zmm0,%k0
 106e1b3:	kmovd  %k0,%ecx
 106e1b7:	test   $0x8888,%ecx
 106e1bd:	jne    106df50 <check_input_run+0xbc0>
 106e1c3:	mov    0x70(%rsp),%rdi
 106e1c8:	mov    0xc8(%rsp),%rsi
 106e1d0:	inc    %r12
 106e1d3:	and    %rdi,%r12
 106e1d6:	test   %al,%al
 106e1d8:	je     106e0f0 <check_input_run+0xd60>
 106e1de:	jmp    106df50 <check_input_run+0xbc0>
 106e1e3:	mov    0x18(%rsp),%rdi
 106e1e8:	mov    $0xb0,%ecx
 106e1ed:	movq   $0x0,0x50(%rdi)
 106e1f5:	movq   $0x0,(%rdi,%rcx,1)
 106e1fd:	movq   $0x0,0x348(%rsp)
 106e209:	movq   $0x0,0x350(%rsp)
 106e215:	movq   $0x0,0x358(%rsp)
 106e221:	movq   $0x0,0x370(%rsp)
 106e22d:	movq   $0x0,0x398(%rsp)
 106e239:	movq   $0x0,0x3b0(%rsp)
 106e245:	movq   $0x0,0x3d8(%rsp)
 106e251:	movq   $0x0,0x3e0(%rsp)
 106e25d:	movq   $0x0,0x3e8(%rsp)
 106e269:	movq   $0x0,0x3f0(%rsp)
 106e275:	movq   $0x0,0x3f8(%rsp)
 106e281:	movq   $0x0,0x400(%rsp)
 106e28d:	movq   $0x0,0x408(%rsp)
 106e299:	movq   $0x0,0x418(%rsp)
 106e2a5:	movq   $0x0,0x420(%rsp)
 106e2b1:	movq   $0x0,0x428(%rsp)
 106e2bd:	movq   $0x0,0x430(%rsp)
 106e2c9:	movq   $0x0,0x438(%rsp)
 106e2d5:	movq   $0x0,0x440(%rsp)
 106e2e1:	movq   $0x0,0x448(%rsp)
 106e2ed:	movq   $0x0,0x450(%rsp)
 106e2f9:	movq   $0x0,0x460(%rsp)
 106e305:	movq   $0x0,0x4a8(%rsp)
 106e311:	movq   $0x0,0x4b0(%rsp)
 106e31d:	movq   $0x0,0x4d0(%rsp)
 106e329:	movq   $0x0,0x4d8(%rsp)
 106e335:	movq   $0x0,0x4e8(%rsp)
 106e341:	movq   $0x0,0x4f0(%rsp)
 106e34d:	movq   $0x0,0x4f8(%rsp)
 106e359:	movq   $0x0,0x508(%rsp)
 106e365:	movq   $0x0,0x510(%rsp)
 106e371:	movq   $0x0,0x520(%rsp)
 106e37d:	movq   $0x0,0x528(%rsp)
 106e389:	movq   $0x0,0x530(%rsp)
 106e395:	movq   $0x0,0x538(%rsp)
 106e3a1:	movq   $0x0,0x540(%rsp)
 106e3ad:	movq   $0x0,0x548(%rsp)
 106e3b9:	movq   $0x0,0x550(%rsp)
 106e3c5:	movq   $0x0,0x570(%rsp)
 106e3d1:	movq   $0x0,0x578(%rsp)
 106e3dd:	movq   $0x0,0x598(%rsp)
 106e3e9:	movq   $0x0,0x5a0(%rsp)
 106e3f5:	movq   $0x0,0x5a8(%rsp)
 106e401:	movq   $0x0,0x5b0(%rsp)
 106e40d:	movq   $0x0,0x5d0(%rsp)
 106e419:	movq   $0x0,0x5d8(%rsp)
 106e425:	movq   $0x0,0x5e0(%rsp)
 106e431:	movq   $0x0,0x5e8(%rsp)
 106e43d:	movq   $0x0,0x608(%rsp)
 106e449:	movq   $0x0,0x610(%rsp)
 106e455:	movq   $0x0,0x618(%rsp)
 106e461:	movq   $0x0,0x620(%rsp)
 106e46d:	movq   $0x0,0x628(%rsp)
 106e479:	movq   $0x0,0x638(%rsp)
 106e485:	movq   $0x0,0x640(%rsp)
 106e491:	movq   $0x0,0x648(%rsp)
 106e49d:	xor    %esi,%esi
 106e49f:	xor    %ecx,%ecx
 106e4a1:	test   %rcx,%rcx
 106e4a4:	mov    %rcx,0x630(%rsp)
 106e4ac:	setne  %al
 106e4af:	and    %sil,%al
 106e4b2:	cmpl   $0x0,0xf0(%rsp)
 106e4ba:	je     106e4da <check_input_run+0x114a>
 106e4bc:	mov    0x18(%r12),%rcx
 106e4c1:	mov    0x78(%rsp),%r8
 106e4c6:	cmp    $0x8,%r8d
 106e4ca:	jae    106e4f1 <check_input_run+0x1161>
 106e4cc:	mov    0x58(%rsp),%r15
 106e4d1:	xor    %edx,%edx
 106e4d3:	xor    %esi,%esi
 106e4d5:	jmp    106e680 <check_input_run+0x12f0>
 106e4da:	mov    0x58(%rsp),%r15
 106e4df:	mov    $0x60,%ebx
 106e4e4:	test   %al,%al
 106e4e6:	jne    106e6aa <check_input_run+0x131a>
 106e4ec:	jmp    106fafc <check_input_run+0x276c>
 106e4f1:	cmp    $0x40,%r8d
 106e4f5:	jae    106e505 <check_input_run+0x1175>
 106e4f7:	mov    0x58(%rsp),%r15
 106e4fc:	xor    %edx,%edx
 106e4fe:	xor    %esi,%esi
 106e500:	jmp    106e60a <check_input_run+0x127a>
 106e505:	vpbroadcastd -0xac26db(%rip),%zmm1        # 5abe34 <link_program_emit_worker.forms+0x3c4>
 106e50f:	vpbroadcastd -0xac26e1(%rip),%zmm2        # 5abe38 <link_program_emit_worker.forms+0x3c8>
 106e519:	mov    %r8d,%esi
 106e51c:	shr    $0x6,%esi
 106e51f:	mov    %r8d,%edx
 106e522:	and    $0xffffffc0,%edx
 106e525:	vpxor  %xmm0,%xmm0,%xmm0
 106e529:	xor    %edi,%edi
 106e52b:	vpxor  %xmm3,%xmm3,%xmm3
 106e52f:	vpxor  %xmm4,%xmm4,%xmm4
 106e533:	vpxor  %xmm5,%xmm5,%xmm5
 106e537:	shl    $0x8,%rsi
 106e53b:	nopl   0x0(%rax,%rax,1)
 106e540:	vpaddd (%rcx,%rdi,1),%zmm1,%zmm6
 106e547:	vpaddd 0x40(%rcx,%rdi,1),%zmm1,%zmm7
 106e54f:	vpaddd 0x80(%rcx,%rdi,1),%zmm1,%zmm8
 106e557:	vpaddd 0xc0(%rcx,%rdi,1),%zmm1,%zmm9
 106e55f:	add    $0x100,%rdi
 106e566:	vpcmpltud %zmm2,%zmm6,%k0
 106e56d:	vpcmpltud %zmm2,%zmm7,%k1
 106e574:	vpcmpltud %zmm2,%zmm8,%k2
 106e57b:	vpcmpltud %zmm2,%zmm9,%k3
 106e582:	vpmovm2d %k0,%zmm6
 106e588:	vpsubd %zmm6,%zmm0,%zmm0
 106e58e:	vpmovm2d %k1,%zmm6
 106e594:	vpsubd %zmm6,%zmm3,%zmm3
 106e59a:	vpmovm2d %k2,%zmm6
 106e5a0:	vpsubd %zmm6,%zmm4,%zmm4
 106e5a6:	vpmovm2d %k3,%zmm6
 106e5ac:	vpsubd %zmm6,%zmm5,%zmm5
 106e5b2:	cmp    %rdi,%rsi
 106e5b5:	jne    106e540 <check_input_run+0x11b0>
 106e5b7:	vpaddd %zmm0,%zmm3,%zmm0
 106e5bd:	vpaddd %zmm4,%zmm5,%zmm1
 106e5c3:	mov    0x58(%rsp),%r15
 106e5c8:	vpaddd %zmm0,%zmm1,%zmm0
 106e5ce:	vextracti64x4 $0x1,%zmm0,%ymm1
 106e5d5:	vpaddd %zmm1,%zmm0,%zmm0
 106e5db:	vextracti128 $0x1,%ymm0,%xmm1
 106e5e1:	vpaddd %xmm1,%xmm0,%xmm0
 106e5e5:	vpshufd $0xee,%xmm0,%xmm1
 106e5ea:	vpaddd %xmm1,%xmm0,%xmm0
 106e5ee:	vpshufd $0x55,%xmm0,%xmm1
 106e5f3:	vpaddd %xmm1,%xmm0,%xmm0
 106e5f7:	vmovd  %xmm0,%esi
 106e5fb:	cmp    %edx,%r8d
 106e5fe:	je     106e694 <check_input_run+0x1304>
 106e604:	test   $0x38,%r8b
 106e608:	je     106e680 <check_input_run+0x12f0>
 106e60a:	vpbroadcastd -0xac27df(%rip),%ymm1        # 5abe34 <link_program_emit_worker.forms+0x3c4>
 106e613:	vpbroadcastd -0xac27e4(%rip),%ymm2        # 5abe38 <link_program_emit_worker.forms+0x3c8>
 106e61c:	mov    %rdx,%rdi
 106e61f:	mov    %r8d,%edx
 106e622:	and    $0xfffffff8,%edx
 106e625:	vmovd  %esi,%xmm0
 106e629:	nopl   0x0(%rax)
 106e630:	vpaddd (%rcx,%rdi,4),%ymm1,%ymm3
 106e635:	add    $0x8,%rdi
 106e639:	vpcmpltud %ymm2,%ymm3,%k0
 106e640:	vpmovm2d %k0,%ymm3
 106e646:	vpsubd %ymm3,%ymm0,%ymm0
 106e64a:	cmp    %rdi,%rdx
 106e64d:	jne    106e630 <check_input_run+0x12a0>
 106e64f:	vextracti128 $0x1,%ymm0,%xmm1
 106e655:	vpaddd %xmm1,%xmm0,%xmm0
 106e659:	vpshufd $0xee,%xmm0,%xmm1
 106e65e:	vpaddd %xmm1,%xmm0,%xmm0
 106e662:	vpshufd $0x55,%xmm0,%xmm1
 106e667:	vpaddd %xmm1,%xmm0,%xmm0
 106e66b:	vmovd  %xmm0,%esi
 106e66f:	cmp    %edx,%r8d
 106e672:	je     106e694 <check_input_run+0x1304>
 106e674:	data16 data16 cs nopw 0x0(%rax,%rax,1)
 106e680:	mov    (%rcx,%rdx,4),%edi
 106e683:	add    $0xffffffb3,%edi
 106e686:	cmp    $0x2,%edi
 106e689:	adc    $0x0,%esi
 106e68c:	inc    %rdx
 106e68f:	cmp    %rdx,%r8
 106e692:	jne    106e680 <check_input_run+0x12f0>
 106e694:	mov    %esi,%ecx
 106e696:	lea    (%rcx,%rcx,2),%rbx
 106e69a:	shl    $0x5,%rbx
 106e69e:	add    $0x60,%rbx
 106e6a2:	test   %al,%al
 106e6a4:	je     106fafc <check_input_run+0x276c>
 106e6aa:	mov    0x18(%rsp),%rcx
 106e6af:	mov    0x33c(%rcx),%eax
 106e6b5:	test   %rax,%rax
 106e6b8:	je     106e7c1 <check_input_run+0x1431>
 106e6be:	mov    0x10(%rsp),%r9
 106e6c3:	mov    (%r9),%rdi
 106e6c6:	mov    0x8(%r9),%rdx
 106e6ca:	lea    0x3(%rdx,%rdi,1),%rcx
 106e6cf:	add    %rdi,%rdx
 106e6d2:	and    $0xfffffffffffffffc,%rcx
 106e6d6:	cmp    %rdx,%rcx
 106e6d9:	jb     106e704 <check_input_run+0x1374>
 106e6db:	mov    %rcx,%rsi
 106e6de:	sub    %rdi,%rsi
 106e6e1:	mov    0x10(%r9),%rdi
 106e6e5:	lea    0x0(,%rax,4),%rdx
 106e6ed:	lea    (%rdx,%rdx,8),%rdx
 106e6f1:	sub    %rsi,%rdi
 106e6f4:	setb   %r8b
 106e6f8:	cmp    %rdi,%rdx
 106e6fb:	seta   %dil
 106e6ff:	or     %r8b,%dil
 106e702:	je     106e708 <check_input_run+0x1378>
 106e704:	xor    %ecx,%ecx
 106e706:	jmp    106e71a <check_input_run+0x138a>
 106e708:	mov    0x18(%rsp),%rax
 106e70d:	add    %rdx,%rsi
 106e710:	mov    %rsi,0x8(%r9)
 106e714:	mov    0x33c(%rax),%eax
 106e71a:	mov    0x18(%rsp),%rdx
 106e71f:	mov    0x38(%rsp),%rsi
 106e724:	mov    %rcx,0x330(%rdx)
 106e72b:	mov    (%rsi),%rdx
 106e72e:	mov    0x8(%rsi),%rcx
 106e732:	lea    0x3(%rcx,%rdx,1),%rdi
 106e737:	add    %rdx,%rcx
 106e73a:	and    $0xfffffffffffffffc,%rdi
 106e73e:	cmp    %rcx,%rdi
 106e741:	jae    106e754 <check_input_run+0x13c4>
 106e743:	movq   $0x0,0x500(%rsp)
 106e74f:	jmp    106fafc <check_input_run+0x276c>
 106e754:	mov    %rdi,%rcx
 106e757:	sub    %rdx,%rcx
 106e75a:	mov    0x38(%rsp),%rdx
 106e75f:	mov    0x10(%rdx),%rdx
 106e763:	sub    %rcx,%rdx
 106e766:	jb     106e743 <check_input_run+0x13b3>
 106e768:	shl    $0x2,%rax
 106e76c:	cmp    %rdx,%rax
 106e76f:	ja     106e743 <check_input_run+0x13b3>
 106e771:	mov    0x38(%rsp),%rdx
 106e776:	add    %rax,%rcx
 106e779:	mov    %rcx,0x8(%rdx)
 106e77d:	mov    %rdi,0x500(%rsp)
 106e785:	test   %rdi,%rdi
 106e788:	je     106fafc <check_input_run+0x276c>
 106e78e:	mov    0x18(%rsp),%rax
 106e793:	cmpq   $0x0,0x330(%rax)
 106e79b:	je     106fafc <check_input_run+0x276c>
 106e7a1:	mov    0x18(%rsp),%r14
 106e7a6:	mov    $0xff,%esi
 106e7ab:	mov    0x33c(%r14),%edx
 106e7b2:	shl    $0x2,%rdx
 106e7b6:	vzeroupper
 106e7b9:	call   788430 <memset@plt>
 106e7be:	mov    %r14,%rcx
 106e7c1:	mov    0x34c(%rcx),%ecx
 106e7c7:	test   %rcx,%rcx
 106e7ca:	je     106fadb <check_input_run+0x274b>
 106e7d0:	mov    0x10(%rsp),%r8
 106e7d5:	mov    (%r8),%rsi
 106e7d8:	mov    0x8(%r8),%rdx
 106e7dc:	lea    0x7(%rdx,%rsi,1),%rax
 106e7e1:	add    %rsi,%rdx
 106e7e4:	and    $0xfffffffffffffff8,%rax
 106e7e8:	cmp    %rdx,%rax
 106e7eb:	jb     106e81a <check_input_run+0x148a>
 106e7ed:	mov    %rax,%rdx
 106e7f0:	sub    %rsi,%rdx
 106e7f3:	mov    0x10(%r8),%rsi
 106e7f7:	shl    $0x4,%rcx
 106e7fb:	lea    (%rcx,%rcx,4),%rcx
 106e7ff:	sub    %rdx,%rsi
 106e802:	setb   %dil
 106e806:	cmp    %rsi,%rcx
 106e809:	seta   %sil
 106e80d:	or     %dil,%sil
 106e810:	cmp    $0x1,%sil
 106e814:	jne    106fac3 <check_input_run+0x2733>
 106e81a:	mov    0x18(%rsp),%rax
 106e81f:	movq   $0x0,0x340(%rax)
 106e82a:	jmp    106fafc <check_input_run+0x276c>
 106e82f:	mov    0x10(%rdi),%rdi
 106e833:	mov    %rdx,%rsi
 106e836:	sub    %rax,%rsi
 106e839:	sub    %rsi,%rdi
 106e83c:	jb     106df44 <check_input_run+0xbb4>
 106e842:	mov    0x78(%rsp),%rax
 106e847:	lea    0x4(,%rax,4),%rax
 106e84f:	cmp    %rdi,%rax
 106e852:	mov    0x18(%rsp),%rdi
 106e857:	ja     106e1f5 <check_input_run+0xe65>
 106e85d:	mov    0x10(%rsp),%rcx
 106e862:	mov    0x130(%rsp),%r9d
 106e86a:	add    %rax,%rsi
 106e86d:	mov    %rsi,0x8(%rcx)
 106e871:	mov    %rdx,0xb0(%rdi)
 106e878:	test   %rdx,%rdx
 106e87b:	je     106e8ee <check_input_run+0x155e>
 106e87d:	test   %r9d,%r9d
 106e880:	je     106e8ee <check_input_run+0x155e>
 106e882:	mov    0x10(%rsp),%r8
 106e887:	mov    %r9d,0xec(%rdi)
 106e88e:	mov    $0xe0,%ecx
 106e893:	mov    (%r8),%rdi
 106e896:	mov    0x8(%r8),%rsi
 106e89a:	lea    0x7(%rsi,%rdi,1),%rdx
 106e89f:	add    %rdi,%rsi
 106e8a2:	and    $0xfffffffffffffff8,%rdx
 106e8a6:	cmp    %rsi,%rdx
 106e8a9:	jb     106df44 <check_input_run+0xbb4>
 106e8af:	mov    %rdx,%rsi
 106e8b2:	sub    %rdi,%rsi
 106e8b5:	mov    0x10(%r8),%rdi
 106e8b9:	sub    %rsi,%rdi
 106e8bc:	jb     106df44 <check_input_run+0xbb4>
 106e8c2:	mov    %r9d,%r8d
 106e8c5:	shl    $0x3,%r8
 106e8c9:	lea    (%r8,%r8,2),%r8
 106e8cd:	cmp    %rdi,%r8
 106e8d0:	mov    0x18(%rsp),%rdi
 106e8d5:	ja     106e1f5 <check_input_run+0xe65>
 106e8db:	mov    0x10(%rsp),%rcx
 106e8e0:	add    %r8,%rsi
 106e8e3:	mov    %rsi,0x8(%rcx)
 106e8e7:	mov    %rdx,0xe0(%rdi)
 106e8ee:	test   %rdx,%rdx
 106e8f1:	je     106e1fd <check_input_run+0xe6d>
 106e8f7:	mov    0x38(%rsp),%rdx
 106e8fc:	mov    (%rdx),%rcx
 106e8ff:	mov    0x8(%rdx),%rdx
 106e903:	lea    0x3f(%rdx,%rcx,1),%rsi
 106e908:	add    %rcx,%rdx
 106e90b:	and    $0xffffffffffffffc0,%rsi
 106e90f:	cmp    %rdx,%rsi
 106e912:	jb     106e1fd <check_input_run+0xe6d>
 106e918:	mov    0x38(%rsp),%rdx
 106e91d:	mov    %rsi,%rdi
 106e920:	sub    %rcx,%rdi
 106e923:	mov    0x10(%rdx),%rdx
 106e927:	mov    %rdx,%r8
 106e92a:	sub    %rdi,%r8
 106e92d:	jb     106e1fd <check_input_run+0xe6d>
 106e933:	cmp    %r8,%rax
 106e936:	ja     106e1fd <check_input_run+0xe6d>
 106e93c:	mov    0x38(%rsp),%r8
 106e941:	add    %rax,%rdi
 106e944:	mov    %rdi,0x8(%r8)
 106e948:	mov    %rsi,0x348(%rsp)
 106e950:	test   %rsi,%rsi
 106e953:	je     106e209 <check_input_run+0xe79>
 106e959:	lea    0x3c(%rsi,%rax,1),%rdi
 106e95e:	add    %rax,%rsi
 106e961:	and    $0xffffffffffffffc0,%rdi
 106e965:	cmp    %rsi,%rdi
 106e968:	jb     106e209 <check_input_run+0xe79>
 106e96e:	mov    %rdi,%r8
 106e971:	sub    %rcx,%r8
 106e974:	mov    %rdx,%r9
 106e977:	sub    %r8,%r9
 106e97a:	jb     106e209 <check_input_run+0xe79>
 106e980:	mov    0x78(%rsp),%rsi
 106e985:	lea    0x8(,%rsi,8),%rsi
 106e98d:	cmp    %r9,%rsi
 106e990:	ja     106e209 <check_input_run+0xe79>
 106e996:	mov    0x38(%rsp),%r9
 106e99b:	add    %rsi,%r8
 106e99e:	mov    %r8,0x8(%r9)
 106e9a2:	mov    %rdi,0x350(%rsp)
 106e9aa:	test   %rdi,%rdi
 106e9ad:	je     106e215 <check_input_run+0xe85>
 106e9b3:	lea    0x38(%rdi,%rsi,1),%r8
 106e9b8:	add    %rsi,%rdi
 106e9bb:	and    $0xffffffffffffffc0,%r8
 106e9bf:	cmp    %rdi,%r8
 106e9c2:	jb     106e215 <check_input_run+0xe85>
 106e9c8:	mov    %r8,%rdi
 106e9cb:	sub    %rcx,%rdi
 106e9ce:	mov    %rdx,%r9
 106e9d1:	sub    %rdi,%r9
 106e9d4:	jb     106e215 <check_input_run+0xe85>
 106e9da:	cmp    %r9,%rsi
 106e9dd:	ja     106e215 <check_input_run+0xe85>
 106e9e3:	mov    0x38(%rsp),%r9
 106e9e8:	add    %rsi,%rdi
 106e9eb:	mov    %rdi,0x8(%r9)
 106e9ef:	mov    %r8,0x358(%rsp)
 106e9f7:	test   %r8,%r8
 106e9fa:	je     106e221 <check_input_run+0xe91>
 106ea00:	lea    0x38(%r8,%rsi,1),%rdi
 106ea05:	add    %rsi,%r8
 106ea08:	and    $0xffffffffffffffc0,%rdi
 106ea0c:	cmp    %r8,%rdi
 106ea0f:	jb     106e221 <check_input_run+0xe91>
 106ea15:	mov    %rdi,%r8
 106ea18:	sub    %rcx,%r8
 106ea1b:	mov    %rdx,%r9
 106ea1e:	sub    %r8,%r9
 106ea21:	jb     106e221 <check_input_run+0xe91>
 106ea27:	cmp    %r9,%rax
 106ea2a:	ja     106e221 <check_input_run+0xe91>
 106ea30:	mov    0x38(%rsp),%r9
 106ea35:	add    %rax,%r8
 106ea38:	mov    %r8,0x8(%r9)
 106ea3c:	mov    %rdi,0x370(%rsp)
 106ea44:	test   %rdi,%rdi
 106ea47:	je     106e22d <check_input_run+0xe9d>
 106ea4d:	lea    0x3c(%rdi,%rax,1),%r8
 106ea52:	add    %rax,%rdi
 106ea55:	and    $0xffffffffffffffc0,%r8
 106ea59:	cmp    %rdi,%r8
 106ea5c:	jb     106e22d <check_input_run+0xe9d>
 106ea62:	mov    %r8,%rdi
 106ea65:	sub    %rcx,%rdi
 106ea68:	mov    %rdx,%r9
 106ea6b:	sub    %rdi,%r9
 106ea6e:	jb     106e22d <check_input_run+0xe9d>
 106ea74:	cmp    %r9,%rax
 106ea77:	ja     106e22d <check_input_run+0xe9d>
 106ea7d:	mov    0x38(%rsp),%r9
 106ea82:	add    %rax,%rdi
 106ea85:	mov    %rdi,0x8(%r9)
 106ea89:	mov    %r8,0x398(%rsp)
 106ea91:	test   %r8,%r8
 106ea94:	je     106e239 <check_input_run+0xea9>
 106ea9a:	lea    0x3c(%r8,%rax,1),%r9
 106ea9f:	add    %rax,%r8
 106eaa2:	and    $0xffffffffffffffc0,%r9
 106eaa6:	cmp    %r8,%r9
 106eaa9:	jb     106e239 <check_input_run+0xea9>
 106eaaf:	mov    %r9,%r8
 106eab2:	sub    %rcx,%r8
 106eab5:	mov    %rdx,%rdi
 106eab8:	sub    %r8,%rdi
 106eabb:	setb   %r10b
 106eabf:	cmp    0x78(%rsp),%rdi
 106eac4:	setbe  %dil
 106eac8:	or     %r10b,%dil
 106eacb:	cmp    $0x1,%dil
 106eacf:	je     106e239 <check_input_run+0xea9>
 106ead5:	mov    0x78(%rsp),%rdi
 106eada:	mov    0x38(%rsp),%r10
 106eadf:	inc    %rdi
 106eae2:	add    %rdi,%r8
 106eae5:	mov    %r8,0x8(%r10)
 106eae9:	mov    %r9,0x3b0(%rsp)
 106eaf1:	test   %r9,%r9
 106eaf4:	je     106e245 <check_input_run+0xeb5>
 106eafa:	lea    0x3f(%rdi,%r9,1),%r8
 106eaff:	lea    (%rdi,%r9,1),%r10
 106eb03:	and    $0xffffffffffffffc0,%r8
 106eb07:	cmp    %r10,%r8
 106eb0a:	jb     106e245 <check_input_run+0xeb5>
 106eb10:	mov    %r8,%r9
 106eb13:	sub    %rcx,%r9
 106eb16:	mov    %rdx,%r10
 106eb19:	sub    %r9,%r10
 106eb1c:	setb   %r11b
 106eb20:	cmp    0x78(%rsp),%r10
 106eb25:	setbe  %r10b
 106eb29:	or     %r11b,%r10b
 106eb2c:	cmp    $0x1,%r10b
 106eb30:	je     106e245 <check_input_run+0xeb5>
 106eb36:	mov    0x38(%rsp),%r10
 106eb3b:	add    %rdi,%r9
 106eb3e:	mov    %r9,0x8(%r10)
 106eb42:	mov    %r8,0x3d8(%rsp)
 106eb4a:	test   %r8,%r8
 106eb4d:	je     106e251 <check_input_run+0xec1>
 106eb53:	lea    (%rdi,%r8,1),%r9
 106eb57:	lea    0x3f(%rdi,%r8,1),%r8
 106eb5c:	and    $0xffffffffffffffc0,%r8
 106eb60:	cmp    %r9,%r8
 106eb63:	jb     106e251 <check_input_run+0xec1>
 106eb69:	mov    %r8,%r9
 106eb6c:	sub    %rcx,%r9
 106eb6f:	mov    %rdx,%r10
 106eb72:	sub    %r9,%r10
 106eb75:	setb   %r11b
 106eb79:	cmp    0x78(%rsp),%r10
 106eb7e:	setbe  %r10b
 106eb82:	or     %r11b,%r10b
 106eb85:	cmp    $0x1,%r10b
 106eb89:	je     106e251 <check_input_run+0xec1>
 106eb8f:	mov    0x38(%rsp),%r10
 106eb94:	add    %rdi,%r9
 106eb97:	mov    %r9,0x8(%r10)
 106eb9b:	mov    %r8,0x3e0(%rsp)
 106eba3:	test   %r8,%r8
 106eba6:	je     106e25d <check_input_run+0xecd>
 106ebac:	lea    (%rdi,%r8,1),%r9
 106ebb0:	lea    0x3f(%rdi,%r8,1),%r8
 106ebb5:	and    $0xffffffffffffffc0,%r8
 106ebb9:	cmp    %r9,%r8
 106ebbc:	jb     106e25d <check_input_run+0xecd>
 106ebc2:	mov    %r8,%r9
 106ebc5:	sub    %rcx,%r9
 106ebc8:	mov    %rdx,%r10
 106ebcb:	sub    %r9,%r10
 106ebce:	setb   %r11b
 106ebd2:	cmp    0x78(%rsp),%r10
 106ebd7:	setbe  %r10b
 106ebdb:	or     %r11b,%r10b
 106ebde:	cmp    $0x1,%r10b
 106ebe2:	je     106e25d <check_input_run+0xecd>
 106ebe8:	mov    0x38(%rsp),%r10
 106ebed:	add    %rdi,%r9
 106ebf0:	mov    %r9,0x8(%r10)
 106ebf4:	mov    %r8,0x3e8(%rsp)
 106ebfc:	test   %r8,%r8
 106ebff:	je     106e269 <check_input_run+0xed9>
 106ec05:	lea    0x3f(%rdi,%r8,1),%r9
 106ec0a:	lea    (%rdi,%r8,1),%r10
 106ec0e:	and    $0xffffffffffffffc0,%r9
 106ec12:	cmp    %r10,%r9
 106ec15:	jb     106e269 <check_input_run+0xed9>
 106ec1b:	mov    %r9,%r8
 106ec1e:	sub    %rcx,%r8
 106ec21:	mov    %rdx,%r10
 106ec24:	sub    %r8,%r10
 106ec27:	jb     106e269 <check_input_run+0xed9>
 106ec2d:	cmp    %r10,%rax
 106ec30:	ja     106e269 <check_input_run+0xed9>
 106ec36:	mov    0x38(%rsp),%r10
 106ec3b:	add    %rax,%r8
 106ec3e:	mov    %r8,0x8(%r10)
 106ec42:	mov    %r9,0x3f0(%rsp)
 106ec4a:	test   %r9,%r9
 106ec4d:	je     106e275 <check_input_run+0xee5>
 106ec53:	lea    0x3c(%r9,%rax,1),%r8
 106ec58:	add    %rax,%r9
 106ec5b:	and    $0xffffffffffffffc0,%r8
 106ec5f:	cmp    %r9,%r8
 106ec62:	jb     106e275 <check_input_run+0xee5>
 106ec68:	mov    %r8,%r9
 106ec6b:	sub    %rcx,%r9
 106ec6e:	mov    %rdx,%r10
 106ec71:	sub    %r9,%r10
 106ec74:	jb     106e275 <check_input_run+0xee5>
 106ec7a:	cmp    %r10,%rax
 106ec7d:	ja     106e275 <check_input_run+0xee5>
 106ec83:	mov    0x38(%rsp),%r10
 106ec88:	add    %rax,%r9
 106ec8b:	mov    %r9,0x8(%r10)
 106ec8f:	mov    %r8,0x3f8(%rsp)
 106ec97:	test   %r8,%r8
 106ec9a:	je     106e281 <check_input_run+0xef1>
 106eca0:	lea    0x3c(%r8,%rax,1),%r9
 106eca5:	add    %rax,%r8
 106eca8:	and    $0xffffffffffffffc0,%r9
 106ecac:	cmp    %r8,%r9
 106ecaf:	jb     106e281 <check_input_run+0xef1>
 106ecb5:	mov    %r9,%r8
 106ecb8:	sub    %rcx,%r8
 106ecbb:	mov    %rdx,%r10
 106ecbe:	sub    %r8,%r10
 106ecc1:	jb     106e281 <check_input_run+0xef1>
 106ecc7:	cmp    %r10,%rax
 106ecca:	ja     106e281 <check_input_run+0xef1>
 106ecd0:	mov    0x38(%rsp),%r10
 106ecd5:	add    %rax,%r8
 106ecd8:	mov    %r8,0x8(%r10)
 106ecdc:	mov    %r9,0x400(%rsp)
 106ece4:	test   %r9,%r9
 106ece7:	je     106e28d <check_input_run+0xefd>
 106eced:	lea    0x3c(%r9,%rax,1),%r8
 106ecf2:	add    %rax,%r9
 106ecf5:	and    $0xffffffffffffffc0,%r8
 106ecf9:	cmp    %r9,%r8
 106ecfc:	jb     106e28d <check_input_run+0xefd>
 106ed02:	mov    %r8,%r9
 106ed05:	sub    %rcx,%r9
 106ed08:	mov    %rdx,%r10
 106ed0b:	sub    %r9,%r10
 106ed0e:	jb     106e28d <check_input_run+0xefd>
 106ed14:	cmp    %r10,%rax
 106ed17:	ja     106e28d <check_input_run+0xefd>
 106ed1d:	mov    0x38(%rsp),%r10
 106ed22:	add    %rax,%r9
 106ed25:	mov    %r9,0x8(%r10)
 106ed29:	mov    %r8,0x408(%rsp)
 106ed31:	test   %r8,%r8
 106ed34:	je     106e299 <check_input_run+0xf09>
 106ed3a:	lea    0x3c(%r8,%rax,1),%r9
 106ed3f:	add    %rax,%r8
 106ed42:	and    $0xffffffffffffffc0,%r9
 106ed46:	cmp    %r8,%r9
 106ed49:	jb     106e299 <check_input_run+0xf09>
 106ed4f:	mov    %r9,%r8
 106ed52:	sub    %rcx,%r8
 106ed55:	mov    %rdx,%r10
 106ed58:	sub    %r8,%r10
 106ed5b:	jb     106e299 <check_input_run+0xf09>
 106ed61:	cmp    %r10,%rax
 106ed64:	ja     106e299 <check_input_run+0xf09>
 106ed6a:	mov    0x38(%rsp),%r10
 106ed6f:	add    %rax,%r8
 106ed72:	mov    %r8,0x8(%r10)
 106ed76:	mov    %r9,0x418(%rsp)
 106ed7e:	test   %r9,%r9
 106ed81:	je     106e2a5 <check_input_run+0xf15>
 106ed87:	lea    0x3c(%r9,%rax,1),%r8
 106ed8c:	add    %rax,%r9
 106ed8f:	and    $0xffffffffffffffc0,%r8
 106ed93:	cmp    %r9,%r8
 106ed96:	jb     106e2a5 <check_input_run+0xf15>
 106ed9c:	mov    %r8,%r9
 106ed9f:	sub    %rcx,%r9
 106eda2:	mov    %rdx,%r10
 106eda5:	sub    %r9,%r10
 106eda8:	jb     106e2a5 <check_input_run+0xf15>
 106edae:	cmp    %r10,%rsi
 106edb1:	ja     106e2a5 <check_input_run+0xf15>
 106edb7:	mov    0x38(%rsp),%r10
 106edbc:	add    %rsi,%r9
 106edbf:	mov    %r9,0x8(%r10)
 106edc3:	mov    %r8,0x420(%rsp)
 106edcb:	test   %r8,%r8
 106edce:	je     106e2b1 <check_input_run+0xf21>
 106edd4:	lea    0x38(%r8,%rsi,1),%r9
 106edd9:	add    %rsi,%r8
 106eddc:	and    $0xffffffffffffffc0,%r9
 106ede0:	cmp    %r8,%r9
 106ede3:	jb     106e2b1 <check_input_run+0xf21>
 106ede9:	mov    %r9,%r8
 106edec:	sub    %rcx,%r8
 106edef:	mov    %rdx,%r10
 106edf2:	sub    %r8,%r10
 106edf5:	setb   %r11b
 106edf9:	cmp    0x78(%rsp),%r10
 106edfe:	setbe  %r10b
 106ee02:	or     %r11b,%r10b
 106ee05:	cmp    $0x1,%r10b
 106ee09:	je     106e2b1 <check_input_run+0xf21>
 106ee0f:	mov    0x38(%rsp),%r10
 106ee14:	add    %rdi,%r8
 106ee17:	mov    %r8,0x8(%r10)
 106ee1b:	mov    %r9,0x428(%rsp)
 106ee23:	test   %r9,%r9
 106ee26:	je     106e2bd <check_input_run+0xf2d>
 106ee2c:	lea    (%rdi,%r9,1),%r8
 106ee30:	lea    0x3f(%rdi,%r9,1),%r9
 106ee35:	and    $0xffffffffffffffc0,%r9
 106ee39:	cmp    %r8,%r9
 106ee3c:	jb     106e2bd <check_input_run+0xf2d>
 106ee42:	mov    %r9,%r8
 106ee45:	sub    %rcx,%r8
 106ee48:	mov    %rdx,%r10
 106ee4b:	sub    %r8,%r10
 106ee4e:	jb     106e2bd <check_input_run+0xf2d>
 106ee54:	cmp    %r10,%rax
 106ee57:	ja     106e2bd <check_input_run+0xf2d>
 106ee5d:	mov    0x38(%rsp),%r10
 106ee62:	add    %rax,%r8
 106ee65:	mov    %r8,0x8(%r10)
 106ee69:	mov    %r9,0x430(%rsp)
 106ee71:	test   %r9,%r9
 106ee74:	je     106e2c9 <check_input_run+0xf39>
 106ee7a:	lea    0x3c(%r9,%rax,1),%r8
 106ee7f:	add    %rax,%r9
 106ee82:	and    $0xffffffffffffffc0,%r8
 106ee86:	cmp    %r9,%r8
 106ee89:	jb     106e2c9 <check_input_run+0xf39>
 106ee8f:	mov    %r8,%r9
 106ee92:	sub    %rcx,%r9
 106ee95:	mov    %rdx,%r10
 106ee98:	sub    %r9,%r10
 106ee9b:	jb     106e2c9 <check_input_run+0xf39>
 106eea1:	cmp    %r10,%rax
 106eea4:	ja     106e2c9 <check_input_run+0xf39>
 106eeaa:	mov    0x38(%rsp),%r10
 106eeaf:	add    %rax,%r9
 106eeb2:	mov    %r9,0x8(%r10)
 106eeb6:	mov    %r8,0x438(%rsp)
 106eebe:	test   %r8,%r8
 106eec1:	je     106e2d5 <check_input_run+0xf45>
 106eec7:	lea    0x3c(%r8,%rax,1),%r9
 106eecc:	add    %rax,%r8
 106eecf:	and    $0xffffffffffffffc0,%r9
 106eed3:	cmp    %r8,%r9
 106eed6:	jb     106e2d5 <check_input_run+0xf45>
 106eedc:	mov    %r9,%r8
 106eedf:	sub    %rcx,%r8
 106eee2:	mov    %rdx,%r10
 106eee5:	sub    %r8,%r10
 106eee8:	jb     106e2d5 <check_input_run+0xf45>
 106eeee:	cmp    %r10,%rax
 106eef1:	ja     106e2d5 <check_input_run+0xf45>
 106eef7:	mov    0x38(%rsp),%r10
 106eefc:	add    %rax,%r8
 106eeff:	mov    %r8,0x8(%r10)
 106ef03:	mov    %r9,0x440(%rsp)
 106ef0b:	test   %r9,%r9
 106ef0e:	je     106e2e1 <check_input_run+0xf51>
 106ef14:	lea    0x3c(%r9,%rax,1),%r8
 106ef19:	add    %rax,%r9
 106ef1c:	and    $0xffffffffffffffc0,%r8
 106ef20:	cmp    %r9,%r8
 106ef23:	jb     106e2e1 <check_input_run+0xf51>
 106ef29:	mov    %r8,%r9
 106ef2c:	sub    %rcx,%r9
 106ef2f:	mov    %rdx,%r10
 106ef32:	sub    %r9,%r10
 106ef35:	jb     106e2e1 <check_input_run+0xf51>
 106ef3b:	cmp    %r10,%rax
 106ef3e:	ja     106e2e1 <check_input_run+0xf51>
 106ef44:	mov    0x38(%rsp),%r10
 106ef49:	add    %rax,%r9
 106ef4c:	mov    %r9,0x8(%r10)
 106ef50:	mov    %r8,0x448(%rsp)
 106ef58:	test   %r8,%r8
 106ef5b:	je     106e2ed <check_input_run+0xf5d>
 106ef61:	lea    0x3c(%r8,%rax,1),%r9
 106ef66:	add    %rax,%r8
 106ef69:	and    $0xffffffffffffffc0,%r9
 106ef6d:	cmp    %r8,%r9
 106ef70:	jb     106e2ed <check_input_run+0xf5d>
 106ef76:	mov    %r9,%r8
 106ef79:	sub    %rcx,%r8
 106ef7c:	mov    %rdx,%r10
 106ef7f:	sub    %r8,%r10
 106ef82:	jb     106e2ed <check_input_run+0xf5d>
 106ef88:	cmp    %r10,%rax
 106ef8b:	ja     106e2ed <check_input_run+0xf5d>
 106ef91:	mov    0x38(%rsp),%r10
 106ef96:	add    %rax,%r8
 106ef99:	mov    %r8,0x8(%r10)
 106ef9d:	mov    %r9,0x450(%rsp)
 106efa5:	test   %r9,%r9
 106efa8:	je     106e2f9 <check_input_run+0xf69>
 106efae:	lea    0x3c(%r9,%rax,1),%r8
 106efb3:	add    %rax,%r9
 106efb6:	and    $0xffffffffffffffc0,%r8
 106efba:	cmp    %r9,%r8
 106efbd:	jb     106e2f9 <check_input_run+0xf69>
 106efc3:	mov    %r8,%r9
 106efc6:	sub    %rcx,%r9
 106efc9:	mov    %rdx,%r10
 106efcc:	sub    %r9,%r10
 106efcf:	jb     106e2f9 <check_input_run+0xf69>
 106efd5:	cmp    %r10,%rax
 106efd8:	ja     106e2f9 <check_input_run+0xf69>
 106efde:	mov    0x38(%rsp),%r10
 106efe3:	add    %rax,%r9
 106efe6:	mov    %r9,0x8(%r10)
 106efea:	mov    %r8,0x460(%rsp)
 106eff2:	test   %r8,%r8
 106eff5:	je     106e305 <check_input_run+0xf75>
 106effb:	lea    0x3c(%r8,%rax,1),%r9
 106f000:	add    %rax,%r8
 106f003:	and    $0xffffffffffffffc0,%r9
 106f007:	cmp    %r8,%r9
 106f00a:	jb     106e305 <check_input_run+0xf75>
 106f010:	mov    %r9,%r10
 106f013:	sub    %rcx,%r10
 106f016:	mov    %rdx,%r11
 106f019:	sub    %r10,%r11
 106f01c:	jb     106e305 <check_input_run+0xf75>
 106f022:	mov    0x78(%rsp),%r8
 106f027:	lea    0x2(%r8,%r8,1),%r8
 106f02c:	cmp    %r11,%r8
 106f02f:	ja     106e305 <check_input_run+0xf75>
 106f035:	mov    0x38(%rsp),%r11
 106f03a:	add    %r8,%r10
 106f03d:	mov    %r10,0x8(%r11)
 106f041:	mov    %r9,0x4a8(%rsp)
 106f049:	test   %r9,%r9
 106f04c:	je     106e311 <check_input_run+0xf81>
 106f052:	lea    (%r9,%r8,1),%r10
 106f056:	lea    0x3e(%r9,%r8,1),%r9
 106f05b:	and    $0xffffffffffffffc0,%r9
 106f05f:	cmp    %r10,%r9
 106f062:	jb     106e311 <check_input_run+0xf81>
 106f068:	mov    %r9,%r8
 106f06b:	sub    %rcx,%r8
 106f06e:	mov    %rdx,%r10
 106f071:	sub    %r8,%r10
 106f074:	jb     106e311 <check_input_run+0xf81>
 106f07a:	cmp    %r10,%rax
 106f07d:	ja     106e311 <check_input_run+0xf81>
 106f083:	mov    0x38(%rsp),%r10
 106f088:	add    %rax,%r8
 106f08b:	mov    %r8,0x8(%r10)
 106f08f:	mov    %r9,0x4b0(%rsp)
 106f097:	test   %r9,%r9
 106f09a:	je     106e31d <check_input_run+0xf8d>
 106f0a0:	lea    0x3c(%r9,%rax,1),%r8
 106f0a5:	add    %rax,%r9
 106f0a8:	and    $0xffffffffffffffc0,%r8
 106f0ac:	cmp    %r9,%r8
 106f0af:	jb     106e31d <check_input_run+0xf8d>
 106f0b5:	mov    %r8,%r9
 106f0b8:	sub    %rcx,%r9
 106f0bb:	mov    %rdx,%r10
 106f0be:	sub    %r9,%r10
 106f0c1:	jb     106e31d <check_input_run+0xf8d>
 106f0c7:	cmp    %r10,%rax
 106f0ca:	ja     106e31d <check_input_run+0xf8d>
 106f0d0:	mov    0x38(%rsp),%r10
 106f0d5:	add    %rax,%r9
 106f0d8:	mov    %r9,0x8(%r10)
 106f0dc:	mov    %r8,0x4d0(%rsp)
 106f0e4:	test   %r8,%r8
 106f0e7:	je     106e329 <check_input_run+0xf99>
 106f0ed:	lea    0x3c(%r8,%rax,1),%r9
 106f0f2:	add    %rax,%r8
 106f0f5:	and    $0xffffffffffffffc0,%r9
 106f0f9:	cmp    %r8,%r9
 106f0fc:	jb     106e329 <check_input_run+0xf99>
 106f102:	mov    %r9,%r8
 106f105:	sub    %rcx,%r8
 106f108:	mov    %rdx,%r10
 106f10b:	sub    %r8,%r10
 106f10e:	jb     106e329 <check_input_run+0xf99>
 106f114:	cmp    %r10,%rax
 106f117:	ja     106e329 <check_input_run+0xf99>
 106f11d:	mov    0x38(%rsp),%r10
 106f122:	add    %rax,%r8
 106f125:	mov    %r8,0x8(%r10)
 106f129:	mov    %r9,0x4d8(%rsp)
 106f131:	test   %r9,%r9
 106f134:	je     106e335 <check_input_run+0xfa5>
 106f13a:	lea    0x3c(%r9,%rax,1),%r8
 106f13f:	add    %rax,%r9
 106f142:	and    $0xffffffffffffffc0,%r8
 106f146:	cmp    %r9,%r8
 106f149:	jb     106e335 <check_input_run+0xfa5>
 106f14f:	mov    %r8,%r9
 106f152:	sub    %rcx,%r9
 106f155:	mov    %rdx,%r10
 106f158:	sub    %r9,%r10
 106f15b:	jb     106e335 <check_input_run+0xfa5>
 106f161:	cmp    %r10,%rax
 106f164:	ja     106e335 <check_input_run+0xfa5>
 106f16a:	mov    0x38(%rsp),%r10
 106f16f:	add    %rax,%r9
 106f172:	mov    %r9,0x8(%r10)
 106f176:	mov    %r8,0x4e8(%rsp)
 106f17e:	test   %r8,%r8
 106f181:	je     106e341 <check_input_run+0xfb1>
 106f187:	lea    0x3c(%r8,%rax,1),%r9
 106f18c:	add    %rax,%r8
 106f18f:	and    $0xffffffffffffffc0,%r9
 106f193:	cmp    %r8,%r9
 106f196:	jb     106e341 <check_input_run+0xfb1>
 106f19c:	mov    %r9,%r8
 106f19f:	sub    %rcx,%r8
 106f1a2:	mov    %rdx,%r10
 106f1a5:	sub    %r8,%r10
 106f1a8:	jb     106e341 <check_input_run+0xfb1>
 106f1ae:	cmp    %r10,%rax
 106f1b1:	ja     106e341 <check_input_run+0xfb1>
 106f1b7:	mov    0x38(%rsp),%r10
 106f1bc:	add    %rax,%r8
 106f1bf:	mov    %r8,0x8(%r10)
 106f1c3:	mov    %r9,0x4f0(%rsp)
 106f1cb:	test   %r9,%r9
 106f1ce:	je     106e34d <check_input_run+0xfbd>
 106f1d4:	lea    0x3c(%r9,%rax,1),%r8
 106f1d9:	add    %rax,%r9
 106f1dc:	and    $0xffffffffffffffc0,%r8
 106f1e0:	cmp    %r9,%r8
 106f1e3:	jb     106e34d <check_input_run+0xfbd>
 106f1e9:	mov    %r8,%r9
 106f1ec:	sub    %rcx,%r9
 106f1ef:	mov    %rdx,%r10
 106f1f2:	sub    %r9,%r10
 106f1f5:	jb     106e34d <check_input_run+0xfbd>
 106f1fb:	cmp    %r10,%rax
 106f1fe:	ja     106e34d <check_input_run+0xfbd>
 106f204:	mov    0x38(%rsp),%r10
 106f209:	add    %rax,%r9
 106f20c:	mov    %r9,0x8(%r10)
 106f210:	mov    %r8,0x4f8(%rsp)
 106f218:	test   %r8,%r8
 106f21b:	je     106e359 <check_input_run+0xfc9>
 106f221:	lea    0x3c(%r8,%rax,1),%r9
 106f226:	add    %rax,%r8
 106f229:	and    $0xffffffffffffffc0,%r9
 106f22d:	cmp    %r8,%r9
 106f230:	jb     106e359 <check_input_run+0xfc9>
 106f236:	mov    %r9,%r8
 106f239:	sub    %rcx,%r8
 106f23c:	mov    %rdx,%r10
 106f23f:	sub    %r8,%r10
 106f242:	setb   %r11b
 106f246:	cmp    0x78(%rsp),%r10
 106f24b:	setbe  %r10b
 106f24f:	or     %r11b,%r10b
 106f252:	cmp    $0x1,%r10b
 106f256:	je     106e359 <check_input_run+0xfc9>
 106f25c:	mov    0x38(%rsp),%r10
 106f261:	add    %rdi,%r8
 106f264:	mov    %r8,0x8(%r10)
 106f268:	mov    %r9,0x508(%rsp)
 106f270:	test   %r9,%r9
 106f273:	je     106e365 <check_input_run+0xfd5>
 106f279:	lea    0x3f(%rdi,%r9,1),%r8
 106f27e:	lea    (%rdi,%r9,1),%r10
 106f282:	and    $0xffffffffffffffc0,%r8
 106f286:	cmp    %r10,%r8
 106f289:	jb     106e365 <check_input_run+0xfd5>
 106f28f:	mov    %r8,%r9
 106f292:	sub    %rcx,%r9
 106f295:	mov    %rdx,%r10
 106f298:	sub    %r9,%r10
 106f29b:	setb   %r11b
 106f29f:	cmp    0x78(%rsp),%r10
 106f2a4:	setbe  %r10b
 106f2a8:	or     %r11b,%r10b
 106f2ab:	cmp    $0x1,%r10b
 106f2af:	je     106e365 <check_input_run+0xfd5>
 106f2b5:	mov    0x38(%rsp),%r10
 106f2ba:	add    %rdi,%r9
 106f2bd:	mov    %r9,0x8(%r10)
 106f2c1:	mov    %r8,0x510(%rsp)
 106f2c9:	test   %r8,%r8
 106f2cc:	je     106e371 <check_input_run+0xfe1>
 106f2d2:	lea    (%rdi,%r8,1),%r9
 106f2d6:	lea    0x3f(%rdi,%r8,1),%r8
 106f2db:	and    $0xffffffffffffffc0,%r8
 106f2df:	cmp    %r9,%r8
 106f2e2:	jb     106e371 <check_input_run+0xfe1>
 106f2e8:	mov    %r8,%r9
 106f2eb:	sub    %rcx,%r9
 106f2ee:	mov    %rdx,%r10
 106f2f1:	sub    %r9,%r10
 106f2f4:	setb   %r11b
 106f2f8:	cmp    0x78(%rsp),%r10
 106f2fd:	setbe  %r10b
 106f301:	or     %r11b,%r10b
 106f304:	cmp    $0x1,%r10b
 106f308:	je     106e371 <check_input_run+0xfe1>
 106f30e:	mov    0x38(%rsp),%r10
 106f313:	add    %rdi,%r9
 106f316:	mov    %r9,0x8(%r10)
 106f31a:	mov    %r8,0x520(%rsp)
 106f322:	test   %r8,%r8
 106f325:	je     106e37d <check_input_run+0xfed>
 106f32b:	lea    (%rdi,%r8,1),%r9
 106f32f:	lea    0x3f(%rdi,%r8,1),%r8
 106f334:	and    $0xffffffffffffffc0,%r8
 106f338:	cmp    %r9,%r8
 106f33b:	jb     106e37d <check_input_run+0xfed>
 106f341:	mov    %r8,%r9
 106f344:	sub    %rcx,%r9
 106f347:	mov    %rdx,%r10
 106f34a:	sub    %r9,%r10
 106f34d:	setb   %r11b
 106f351:	cmp    0x78(%rsp),%r10
 106f356:	setbe  %r10b
 106f35a:	or     %r11b,%r10b
 106f35d:	cmp    $0x1,%r10b
 106f361:	je     106e37d <check_input_run+0xfed>
 106f367:	mov    0x38(%rsp),%r10
 106f36c:	add    %rdi,%r9
 106f36f:	mov    %r9,0x8(%r10)
 106f373:	mov    %r8,0x528(%rsp)
 106f37b:	test   %r8,%r8
 106f37e:	je     106e389 <check_input_run+0xff9>
 106f384:	lea    0x3f(%rdi,%r8,1),%r9
 106f389:	lea    (%rdi,%r8,1),%r10
 106f38d:	and    $0xffffffffffffffc0,%r9
 106f391:	cmp    %r10,%r9
 106f394:	jb     106e389 <check_input_run+0xff9>
 106f39a:	mov    %r9,%r8
 106f39d:	sub    %rcx,%r8
 106f3a0:	mov    %rdx,%r10
 106f3a3:	sub    %r8,%r10
 106f3a6:	jb     106e389 <check_input_run+0xff9>
 106f3ac:	cmp    %r10,%rax
 106f3af:	ja     106e389 <check_input_run+0xff9>
 106f3b5:	mov    0x38(%rsp),%r10
 106f3ba:	add    %rax,%r8
 106f3bd:	mov    %r8,0x8(%r10)
 106f3c1:	mov    %r9,0x530(%rsp)
 106f3c9:	test   %r9,%r9
 106f3cc:	je     106e395 <check_input_run+0x1005>
 106f3d2:	lea    0x3c(%r9,%rax,1),%r8
 106f3d7:	add    %rax,%r9
 106f3da:	and    $0xffffffffffffffc0,%r8
 106f3de:	cmp    %r9,%r8
 106f3e1:	jb     106e395 <check_input_run+0x1005>
 106f3e7:	mov    %r8,%r9
 106f3ea:	sub    %rcx,%r9
 106f3ed:	mov    %rdx,%r10
 106f3f0:	sub    %r9,%r10
 106f3f3:	jb     106e395 <check_input_run+0x1005>
 106f3f9:	cmp    %r10,%rax
 106f3fc:	ja     106e395 <check_input_run+0x1005>
 106f402:	mov    0x38(%rsp),%r10
 106f407:	add    %rax,%r9
 106f40a:	mov    %r9,0x8(%r10)
 106f40e:	mov    %r8,0x538(%rsp)
 106f416:	test   %r8,%r8
 106f419:	je     106e3a1 <check_input_run+0x1011>
 106f41f:	lea    0x3c(%r8,%rax,1),%r9
 106f424:	add    %rax,%r8
 106f427:	and    $0xffffffffffffffc0,%r9
 106f42b:	cmp    %r8,%r9
 106f42e:	jb     106e3a1 <check_input_run+0x1011>
 106f434:	mov    %r9,%r8
 106f437:	sub    %rcx,%r8
 106f43a:	mov    %rdx,%r10
 106f43d:	sub    %r8,%r10
 106f440:	setb   %r11b
 106f444:	cmp    0x78(%rsp),%r10
 106f449:	setbe  %r10b
 106f44d:	or     %r11b,%r10b
 106f450:	cmp    $0x1,%r10b
 106f454:	je     106e3a1 <check_input_run+0x1011>
 106f45a:	mov    0x38(%rsp),%r10
 106f45f:	add    %rdi,%r8
 106f462:	mov    %r8,0x8(%r10)
 106f466:	mov    %r9,0x540(%rsp)
 106f46e:	test   %r9,%r9
 106f471:	je     106e3ad <check_input_run+0x101d>
 106f477:	lea    0x3f(%rdi,%r9,1),%r8
 106f47c:	lea    (%rdi,%r9,1),%r10
 106f480:	and    $0xffffffffffffffc0,%r8
 106f484:	cmp    %r10,%r8
 106f487:	jb     106e3ad <check_input_run+0x101d>
 106f48d:	mov    %r8,%r9
 106f490:	sub    %rcx,%r9
 106f493:	mov    %rdx,%r10
 106f496:	sub    %r9,%r10
 106f499:	setb   %r11b
 106f49d:	cmp    0x78(%rsp),%r10
 106f4a2:	setbe  %r10b
 106f4a6:	or     %r11b,%r10b
 106f4a9:	cmp    $0x1,%r10b
 106f4ad:	je     106e3ad <check_input_run+0x101d>
 106f4b3:	mov    0x38(%rsp),%r10
 106f4b8:	add    %rdi,%r9
 106f4bb:	mov    %r9,0x8(%r10)
 106f4bf:	mov    %r8,0x548(%rsp)
 106f4c7:	test   %r8,%r8
 106f4ca:	je     106e3b9 <check_input_run+0x1029>
 106f4d0:	lea    (%rdi,%r8,1),%r9
 106f4d4:	lea    0x3f(%rdi,%r8,1),%r8
 106f4d9:	and    $0xffffffffffffffc0,%r8
 106f4dd:	cmp    %r9,%r8
 106f4e0:	jb     106e3b9 <check_input_run+0x1029>
 106f4e6:	mov    %r8,%r9
 106f4e9:	sub    %rcx,%r9
 106f4ec:	mov    %rdx,%r10
 106f4ef:	sub    %r9,%r10
 106f4f2:	jb     106e3b9 <check_input_run+0x1029>
 106f4f8:	cmp    %r10,%rsi
 106f4fb:	ja     106e3b9 <check_input_run+0x1029>
 106f501:	mov    0x38(%rsp),%r10
 106f506:	add    %rsi,%r9
 106f509:	mov    %r9,0x8(%r10)
 106f50d:	mov    %r8,0x550(%rsp)
 106f515:	test   %r8,%r8
 106f518:	je     106e3c5 <check_input_run+0x1035>
 106f51e:	lea    (%r8,%rsi,1),%r9
 106f522:	lea    0x38(%r8,%rsi,1),%r8
 106f527:	and    $0xffffffffffffffc0,%r8
 106f52b:	cmp    %r9,%r8
 106f52e:	jb     106e3c5 <check_input_run+0x1035>
 106f534:	mov    %r8,%rsi
 106f537:	sub    %rcx,%rsi
 106f53a:	mov    %rdx,%r9
 106f53d:	sub    %rsi,%r9
 106f540:	jb     106e3c5 <check_input_run+0x1035>
 106f546:	cmp    %r9,%rax
 106f549:	ja     106e3c5 <check_input_run+0x1035>
 106f54f:	mov    0x38(%rsp),%r9
 106f554:	add    %rax,%rsi
 106f557:	mov    %rsi,0x8(%r9)
 106f55b:	mov    %r8,0x570(%rsp)
 106f563:	test   %r8,%r8
 106f566:	je     106e3d1 <check_input_run+0x1041>
 106f56c:	lea    0x3c(%r8,%rax,1),%rsi
 106f571:	add    %rax,%r8
 106f574:	and    $0xffffffffffffffc0,%rsi
 106f578:	cmp    %r8,%rsi
 106f57b:	jb     106e3d1 <check_input_run+0x1041>
 106f581:	mov    %rsi,%r8
 106f584:	sub    %rcx,%r8
 106f587:	mov    %rdx,%r9
 106f58a:	sub    %r8,%r9
 106f58d:	jb     106e3d1 <check_input_run+0x1041>
 106f593:	cmp    %r9,%rax
 106f596:	ja     106e3d1 <check_input_run+0x1041>
 106f59c:	mov    0x38(%rsp),%r9
 106f5a1:	add    %rax,%r8
 106f5a4:	mov    %r8,0x8(%r9)
 106f5a8:	mov    %rsi,0x578(%rsp)
 106f5b0:	test   %rsi,%rsi
 106f5b3:	je     106e3dd <check_input_run+0x104d>
 106f5b9:	lea    0x3c(%rsi,%rax,1),%r8
 106f5be:	add    %rax,%rsi
 106f5c1:	and    $0xffffffffffffffc0,%r8
 106f5c5:	cmp    %rsi,%r8
 106f5c8:	jb     106e3dd <check_input_run+0x104d>
 106f5ce:	mov    %r8,%rsi
 106f5d1:	sub    %rcx,%rsi
 106f5d4:	mov    %rdx,%r9
 106f5d7:	sub    %rsi,%r9
 106f5da:	jb     106e3dd <check_input_run+0x104d>
 106f5e0:	cmp    %r9,%rax
 106f5e3:	ja     106e3dd <check_input_run+0x104d>
 106f5e9:	mov    0x38(%rsp),%r9
 106f5ee:	add    %rax,%rsi
 106f5f1:	mov    %rsi,0x8(%r9)
 106f5f5:	mov    %r8,0x598(%rsp)
 106f5fd:	test   %r8,%r8
 106f600:	je     106e3e9 <check_input_run+0x1059>
 106f606:	lea    0x3c(%r8,%rax,1),%rsi
 106f60b:	add    %rax,%r8
 106f60e:	and    $0xffffffffffffffc0,%rsi
 106f612:	cmp    %r8,%rsi
 106f615:	jb     106e3e9 <check_input_run+0x1059>
 106f61b:	mov    %rsi,%r8
 106f61e:	sub    %rcx,%r8
 106f621:	mov    %rdx,%r9
 106f624:	sub    %r8,%r9
 106f627:	setb   %r10b
 106f62b:	cmp    0x78(%rsp),%r9
 106f630:	setbe  %r9b
 106f634:	or     %r10b,%r9b
 106f637:	cmp    $0x1,%r9b
 106f63b:	je     106e3e9 <check_input_run+0x1059>
 106f641:	mov    0x38(%rsp),%r9
 106f646:	add    %rdi,%r8
 106f649:	mov    %r8,0x8(%r9)
 106f64d:	mov    %rsi,0x5a0(%rsp)
 106f655:	test   %rsi,%rsi
 106f658:	je     106e3f5 <check_input_run+0x1065>
 106f65e:	lea    (%rdi,%rsi,1),%r8
 106f662:	lea    0x3f(%rdi,%rsi,1),%rdi
 106f667:	and    $0xffffffffffffffc0,%rdi
 106f66b:	cmp    %r8,%rdi
 106f66e:	jb     106e3f5 <check_input_run+0x1065>
 106f674:	mov    %rdi,%rsi
 106f677:	sub    %rcx,%rsi
 106f67a:	mov    %rdx,%r8
 106f67d:	sub    %rsi,%r8
 106f680:	jb     106e3f5 <check_input_run+0x1065>
 106f686:	cmp    %r8,%rax
 106f689:	ja     106e3f5 <check_input_run+0x1065>
 106f68f:	mov    0x38(%rsp),%r8
 106f694:	add    %rax,%rsi
 106f697:	mov    %rsi,0x8(%r8)
 106f69b:	mov    %rdi,0x5a8(%rsp)
 106f6a3:	test   %rdi,%rdi
 106f6a6:	je     106e401 <check_input_run+0x1071>
 106f6ac:	lea    0x3c(%rdi,%rax,1),%rsi
 106f6b1:	add    %rax,%rdi
 106f6b4:	and    $0xffffffffffffffc0,%rsi
 106f6b8:	cmp    %rdi,%rsi
 106f6bb:	jb     106e401 <check_input_run+0x1071>
 106f6c1:	mov    %rsi,%rdi
 106f6c4:	sub    %rcx,%rdi
 106f6c7:	mov    %rdx,%r8
 106f6ca:	sub    %rdi,%r8
 106f6cd:	jb     106e401 <check_input_run+0x1071>
 106f6d3:	cmp    %r8,%rax
 106f6d6:	ja     106e401 <check_input_run+0x1071>
 106f6dc:	mov    0x38(%rsp),%r8
 106f6e1:	add    %rax,%rdi
 106f6e4:	mov    %rdi,0x8(%r8)
 106f6e8:	mov    %rsi,0x5b0(%rsp)
 106f6f0:	test   %rsi,%rsi
 106f6f3:	je     106e40d <check_input_run+0x107d>
 106f6f9:	lea    0x3c(%rsi,%rax,1),%rdi
 106f6fe:	add    %rax,%rsi
 106f701:	and    $0xffffffffffffffc0,%rdi
 106f705:	cmp    %rsi,%rdi
 106f708:	jb     106e40d <check_input_run+0x107d>
 106f70e:	mov    %rdi,%rsi
 106f711:	sub    %rcx,%rsi
 106f714:	mov    %rdx,%r8
 106f717:	sub    %rsi,%r8
 106f71a:	jb     106e40d <check_input_run+0x107d>
 106f720:	cmp    %r8,%rax
 106f723:	ja     106e40d <check_input_run+0x107d>
 106f729:	mov    0x38(%rsp),%r8
 106f72e:	add    %rax,%rsi
 106f731:	mov    %rsi,0x8(%r8)
 106f735:	mov    %rdi,0x5d0(%rsp)
 106f73d:	test   %rdi,%rdi
 106f740:	je     106e419 <check_input_run+0x1089>
 106f746:	lea    0x3c(%rdi,%rax,1),%rsi
 106f74b:	add    %rax,%rdi
 106f74e:	and    $0xffffffffffffffc0,%rsi
 106f752:	cmp    %rdi,%rsi
 106f755:	jb     106e419 <check_input_run+0x1089>
 106f75b:	mov    %rsi,%rdi
 106f75e:	sub    %rcx,%rdi
 106f761:	mov    %rdx,%r8
 106f764:	sub    %rdi,%r8
 106f767:	jb     106e419 <check_input_run+0x1089>
 106f76d:	cmp    %r8,%rax
 106f770:	ja     106e419 <check_input_run+0x1089>
 106f776:	mov    0x38(%rsp),%r8
 106f77b:	add    %rax,%rdi
 106f77e:	mov    %rdi,0x8(%r8)
 106f782:	mov    %rsi,0x5d8(%rsp)
 106f78a:	test   %rsi,%rsi
 106f78d:	je     106e425 <check_input_run+0x1095>
 106f793:	lea    0x3c(%rsi,%rax,1),%rdi
 106f798:	add    %rax,%rsi
 106f79b:	and    $0xffffffffffffffc0,%rdi
 106f79f:	cmp    %rsi,%rdi
 106f7a2:	jb     106e425 <check_input_run+0x1095>
 106f7a8:	mov    %rdi,%r8
 106f7ab:	sub    %rcx,%r8
 106f7ae:	mov    %rdx,%r9
 106f7b1:	sub    %r8,%r9
 106f7b4:	jb     106e425 <check_input_run+0x1095>
 106f7ba:	mov    0x78(%rsp),%rsi
 106f7bf:	shl    $0x4,%rsi
 106f7c3:	add    $0x10,%rsi
 106f7c7:	cmp    %r9,%rsi
 106f7ca:	ja     106e425 <check_input_run+0x1095>
 106f7d0:	mov    0x38(%rsp),%r9
 106f7d5:	add    %rsi,%r8
 106f7d8:	mov    %r8,0x8(%r9)
 106f7dc:	mov    %rdi,0x5e0(%rsp)
 106f7e4:	test   %rdi,%rdi
 106f7e7:	je     106e431 <check_input_run+0x10a1>
 106f7ed:	lea    (%rdi,%rsi,1),%r8
 106f7f1:	lea    0x30(%rdi,%rsi,1),%rdi
 106f7f6:	and    $0xffffffffffffffc0,%rdi
 106f7fa:	cmp    %r8,%rdi
 106f7fd:	jb     106e431 <check_input_run+0x10a1>
 106f803:	mov    %rdi,%rsi
 106f806:	sub    %rcx,%rsi
 106f809:	mov    %rdx,%r8
 106f80c:	sub    %rsi,%r8
 106f80f:	jb     106e431 <check_input_run+0x10a1>
 106f815:	cmp    %r8,%rax
 106f818:	ja     106e431 <check_input_run+0x10a1>
 106f81e:	mov    0x38(%rsp),%r8
 106f823:	add    %rax,%rsi
 106f826:	mov    %rsi,0x8(%r8)
 106f82a:	mov    %rdi,0x5e8(%rsp)
 106f832:	test   %rdi,%rdi
 106f835:	je     106e43d <check_input_run+0x10ad>
 106f83b:	lea    0x3c(%rdi,%rax,1),%rsi
 106f840:	add    %rax,%rdi
 106f843:	and    $0xffffffffffffffc0,%rsi
 106f847:	cmp    %rdi,%rsi
 106f84a:	jb     106e43d <check_input_run+0x10ad>
 106f850:	mov    %rsi,%rdi
 106f853:	sub    %rcx,%rdi
 106f856:	mov    %rdx,%r8
 106f859:	sub    %rdi,%r8
 106f85c:	jb     106e43d <check_input_run+0x10ad>
 106f862:	cmp    %r8,%rax
 106f865:	ja     106e43d <check_input_run+0x10ad>
 106f86b:	mov    0x38(%rsp),%r8
 106f870:	add    %rax,%rdi
 106f873:	mov    %rdi,0x8(%r8)
 106f877:	mov    %rsi,0x608(%rsp)
 106f87f:	test   %rsi,%rsi
 106f882:	je     106e449 <check_input_run+0x10b9>
 106f888:	lea    0x3c(%rsi,%rax,1),%rdi
 106f88d:	add    %rax,%rsi
 106f890:	and    $0xffffffffffffffc0,%rdi
 106f894:	cmp    %rsi,%rdi
 106f897:	jb     106e449 <check_input_run+0x10b9>
 106f89d:	mov    %rdi,%rsi
 106f8a0:	sub    %rcx,%rsi
 106f8a3:	mov    %rdx,%r8
 106f8a6:	sub    %rsi,%r8
 106f8a9:	jb     106e449 <check_input_run+0x10b9>
 106f8af:	cmp    %r8,%rax
 106f8b2:	ja     106e449 <check_input_run+0x10b9>
 106f8b8:	mov    0x38(%rsp),%r8
 106f8bd:	add    %rax,%rsi
 106f8c0:	mov    %rsi,0x8(%r8)
 106f8c4:	mov    %rdi,0x610(%rsp)
 106f8cc:	test   %rdi,%rdi
 106f8cf:	je     106e455 <check_input_run+0x10c5>
 106f8d5:	lea    0x3c(%rdi,%rax,1),%rsi
 106f8da:	add    %rax,%rdi
 106f8dd:	and    $0xffffffffffffffc0,%rsi
 106f8e1:	cmp    %rdi,%rsi
 106f8e4:	jb     106e455 <check_input_run+0x10c5>
 106f8ea:	mov    %rsi,%rdi
 106f8ed:	sub    %rcx,%rdi
 106f8f0:	mov    %rdx,%r8
 106f8f3:	sub    %rdi,%r8
 106f8f6:	jb     106e455 <check_input_run+0x10c5>
 106f8fc:	cmp    %r8,%rax
 106f8ff:	ja     106e455 <check_input_run+0x10c5>
 106f905:	mov    0x38(%rsp),%r8
 106f90a:	add    %rax,%rdi
 106f90d:	mov    %rdi,0x8(%r8)
 106f911:	mov    %rsi,0x618(%rsp)
 106f919:	test   %rsi,%rsi
 106f91c:	je     106e461 <check_input_run+0x10d1>
 106f922:	lea    0x3c(%rsi,%rax,1),%rdi
 106f927:	add    %rax,%rsi
 106f92a:	and    $0xffffffffffffffc0,%rdi
 106f92e:	cmp    %rsi,%rdi
 106f931:	jb     106e461 <check_input_run+0x10d1>
 106f937:	mov    %rdi,%rsi
 106f93a:	sub    %rcx,%rsi
 106f93d:	mov    %rdx,%r8
 106f940:	sub    %rsi,%r8
 106f943:	jb     106e461 <check_input_run+0x10d1>
 106f949:	cmp    %r8,%rax
 106f94c:	ja     106e461 <check_input_run+0x10d1>
 106f952:	mov    0x38(%rsp),%r8
 106f957:	add    %rax,%rsi
 106f95a:	mov    %rsi,0x8(%r8)
 106f95e:	mov    %rdi,0x620(%rsp)
 106f966:	test   %rdi,%rdi
 106f969:	je     106e46d <check_input_run+0x10dd>
 106f96f:	lea    0x3c(%rdi,%rax,1),%rsi
 106f974:	add    %rax,%rdi
 106f977:	and    $0xffffffffffffffc0,%rsi
 106f97b:	cmp    %rdi,%rsi
 106f97e:	jb     106e46d <check_input_run+0x10dd>
 106f984:	mov    %rsi,%rdi
 106f987:	sub    %rcx,%rdi
 106f98a:	mov    %rdx,%r8
 106f98d:	sub    %rdi,%r8
 106f990:	jb     106e46d <check_input_run+0x10dd>
 106f996:	cmp    %r8,%rax
 106f999:	ja     106e46d <check_input_run+0x10dd>
 106f99f:	mov    0x38(%rsp),%r8
 106f9a4:	add    %rax,%rdi
 106f9a7:	mov    %rdi,0x8(%r8)
 106f9ab:	mov    %rsi,0x628(%rsp)
 106f9b3:	test   %rsi,%rsi
 106f9b6:	je     106e479 <check_input_run+0x10e9>
 106f9bc:	lea    0x3c(%rsi,%rax,1),%rdi
 106f9c1:	add    %rax,%rsi
 106f9c4:	and    $0xffffffffffffffc0,%rdi
 106f9c8:	cmp    %rsi,%rdi
 106f9cb:	jb     106e479 <check_input_run+0x10e9>
 106f9d1:	mov    %rdi,%rsi
 106f9d4:	sub    %rcx,%rsi
 106f9d7:	mov    %rdx,%r8
 106f9da:	sub    %rsi,%r8
 106f9dd:	jb     106e479 <check_input_run+0x10e9>
 106f9e3:	cmp    %r8,%rax
 106f9e6:	ja     106e479 <check_input_run+0x10e9>
 106f9ec:	mov    0x38(%rsp),%r8
 106f9f1:	add    %rax,%rsi
 106f9f4:	mov    %rsi,0x8(%r8)
 106f9f8:	mov    %rdi,0x638(%rsp)
 106fa00:	test   %rdi,%rdi
 106fa03:	je     106e485 <check_input_run+0x10f5>
 106fa09:	lea    0x3c(%rdi,%rax,1),%rsi
 106fa0e:	add    %rax,%rdi
 106fa11:	and    $0xffffffffffffffc0,%rsi
 106fa15:	cmp    %rdi,%rsi
 106fa18:	jb     106e485 <check_input_run+0x10f5>
 106fa1e:	mov    %rsi,%rdi
 106fa21:	sub    %rcx,%rdi
 106fa24:	mov    %rdx,%r8
 106fa27:	sub    %rdi,%r8
 106fa2a:	jb     106e485 <check_input_run+0x10f5>
 106fa30:	cmp    %r8,%rax
 106fa33:	ja     106e485 <check_input_run+0x10f5>
 106fa39:	mov    0x38(%rsp),%r8
 106fa3e:	add    %rax,%rdi
 106fa41:	mov    %rdi,0x8(%r8)
 106fa45:	mov    %rsi,0x640(%rsp)
 106fa4d:	test   %rsi,%rsi
 106fa50:	je     106e491 <check_input_run+0x1101>
 106fa56:	lea    0x3c(%rsi,%rax,1),%rdi
 106fa5b:	add    %rax,%rsi
 106fa5e:	and    $0xffffffffffffffc0,%rdi
 106fa62:	cmp    %rsi,%rdi
 106fa65:	jb     106e491 <check_input_run+0x1101>
 106fa6b:	mov    %rdi,%rsi
 106fa6e:	sub    %rcx,%rsi
 106fa71:	mov    %rdx,%r8
 106fa74:	sub    %rsi,%r8
 106fa77:	jb     106e491 <check_input_run+0x1101>
 106fa7d:	cmp    %r8,%rax
 106fa80:	ja     106e491 <check_input_run+0x1101>
 106fa86:	mov    0x38(%rsp),%r8
 106fa8b:	add    %rax,%rsi
 106fa8e:	mov    %rsi,0x8(%r8)
 106fa92:	mov    %rdi,0x648(%rsp)
 106fa9a:	test   %rdi,%rdi
 106fa9d:	je     107cfa6 <check_input_run+0xfc16>
 106faa3:	lea    (%rdi,%rax,1),%r8
 106faa7:	lea    0x3c(%rdi,%rax,1),%rax
 106faac:	mov    $0x1,%sil
 106faaf:	and    $0xffffffffffffffc0,%rax
 106fab3:	cmp    %r8,%rax
 106fab6:	jae    107cfac <check_input_run+0xfc1c>
 106fabc:	xor    %ecx,%ecx
 106fabe:	jmp    107cfdd <check_input_run+0xfc4d>
 106fac3:	add    %rcx,%rdx
 106fac6:	mov    %rdx,0x8(%r8)
 106faca:	mov    0x18(%rsp),%rdx
 106facf:	mov    %rax,0x340(%rdx)
 106fad6:	test   %rax,%rax
 106fad9:	je     106fafc <check_input_run+0x276c>
 106fadb:	mov    0x38(%rsp),%rcx
 106fae0:	mov    (%rcx),%rax
 106fae3:	mov    0x8(%rcx),%rcx
 106fae7:	lea    0xf(%rcx,%rax,1),%rdx
 106faec:	add    %rax,%rcx
 106faef:	and    $0xfffffffffffffff0,%rdx
 106faf3:	cmp    %rcx,%rdx
 106faf6:	jae    1071381 <check_input_run+0x3ff1>
 106fafc:	movq   $0x0,0x458(%rsp)
 106fb08:	movq   $0x0,0x590(%rsp)
 106fb14:	movq   $0x0,0xc0(%rsp)
 106fb20:	xor    %edi,%edi
 106fb22:	mov    %rdi,0x470(%rsp)
 106fb2a:	mov    %rdi,0x88(%rsp)
 106fb32:	mov    0x270(%r15),%rax
 106fb39:	mov    %rax,0x48(%rsp)
 106fb3e:	xor    %eax,%eax
 106fb40:	jmp    106fb6f <check_input_run+0x27df>
 106fb42:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 106fb50:	mov    0x70(%rsp),%rax
 106fb55:	mov    0x20(%rsp),%r12
 106fb5a:	mov    %r14d,0x280(%rsp,%rax,4)
 106fb62:	inc    %rax
 106fb65:	cmp    $0x5,%rax
 106fb69:	je     106fde6 <check_input_run+0x2a56>
 106fb6f:	lea    0xbd2c0a(%rip),%rcx        # 1c42780 <parse_predeclared_typedefs+0x30>
 106fb76:	mov    %rax,0x70(%rsp)
 106fb7b:	mov    (%rcx,%rax,8),%rbx
 106fb7f:	mov    %rbx,%rdi
 106fb82:	vzeroupper
 106fb85:	call   787f00 <strlen@plt>
 106fb8a:	kxnorq %k0,%k0,%k1
 106fb8f:	mov    %rax,%rdx
 106fb92:	mov    %edx,%r14d
 106fb95:	cmp    $0x3f,%edx
 106fb98:	ja     106fbab <check_input_run+0x281b>
 106fb9a:	mov    $0xffffffffffffffff,%rax
 106fba1:	bzhi   %r14,%rax,%rax
 106fba6:	kmovq  %rax,%k1
 106fbab:	vmovdqu8 (%rbx),%zmm0{%k1}{z}
 106fbb1:	vmovd  %r14d,%xmm1
 106fbb6:	vpxor  %xmm2,%xmm2,%xmm2
 106fbba:	mov    %rdx,0x28(%rsp)
 106fbbf:	vpternlogq $0x96,-0xbd274a(%rip),%zmm0,%zmm1        # 49d480 <cbuiltin_test_generated.edges+0x3640>
 106fbca:	vaesenc %zmm2,%zmm1,%zmm0
 106fbd0:	vaesenc %zmm2,%zmm0,%zmm0
 106fbd6:	vextracti64x4 $0x1,%zmm0,%ymm1
 106fbdd:	vpxorq %zmm0,%zmm1,%zmm0
 106fbe3:	vextracti128 $0x1,%ymm0,%xmm1
 106fbe9:	vpxor  %xmm0,%xmm1,%xmm0
 106fbed:	cmp    $0x41,%edx
 106fbf0:	jb     106fc05 <check_input_run+0x2875>
 106fbf2:	mov    %rbx,%rdi
 106fbf5:	mov    %r14,%rsi
 106fbf8:	vzeroupper
 106fbfb:	call   101c280 <intern_chain_chunks>
 106fc00:	mov    0x28(%rsp),%rdx
 106fc05:	vpxor  %xmm1,%xmm1,%xmm1
 106fc09:	vaesenc %xmm1,%xmm0,%xmm0
 106fc0e:	cmp    $0x10,%edx
 106fc11:	mov    $0x10,%eax
 106fc16:	mov    $0xffff,%ecx
 106fc1b:	cmovb  %edx,%eax
 106fc1e:	bzhi   %eax,%ecx,%eax
 106fc23:	kmovd  %eax,%k1
 106fc27:	mov    0x48(%rsp),%rax
 106fc2c:	vmovq  %xmm0,%r12
 106fc31:	vmovdqu8 (%rbx),%xmm0{%k1}{z}
 106fc37:	mov    0x8(%rax),%rdi
 106fc3b:	mov    (%rax),%rsi
 106fc3e:	vshufi64x2 $0x0,%zmm0,%zmm0,%zmm0
 106fc45:	and    %rdi,%r12
 106fc48:	vmovdqu64 %zmm0,0x210(%rsp)
 106fc53:	cmp    $0xc,%edx
 106fc56:	jae    106fcc0 <check_input_run+0x2930>
 106fc58:	xor    %r14d,%r14d
 106fc5b:	jmp    106fc7f <check_input_run+0x28ef>
 106fc5d:	nopl   (%rax)
 106fc60:	vptestnmd %zmm0,%zmm0,%k0
 106fc66:	inc    %r12
 106fc69:	kmovd  %k0,%ecx
 106fc6d:	and    %rdi,%r12
 106fc70:	and    $0x8888,%ecx
 106fc76:	or     %cx,%ax
 106fc79:	jne    106fb50 <check_input_run+0x27c0>
 106fc7f:	mov    %r12,%rcx
 106fc82:	shl    $0x6,%rcx
 106fc86:	vmovdqa64 (%rsi,%rcx,1),%zmm0
 106fc8d:	vpcmpeqd 0x210(%rsp),%zmm0,%k0
 106fc98:	kmovd  %k0,%eax
 106fc9c:	and    $0x7777,%eax
 106fca1:	add    $0x1111,%eax
 106fca6:	and    $0x8888,%ax
 106fcaa:	je     106fc60 <check_input_run+0x28d0>
 106fcac:	add    %rsi,%rcx
 106fcaf:	xor    %edx,%edx
 106fcb1:	tzcnt  %eax,%edx
 106fcb5:	mov    (%rcx,%rdx,4),%r14d
 106fcb9:	jmp    106fc60 <check_input_run+0x28d0>
 106fcbb:	nopl   0x0(%rax,%rax,1)
 106fcc0:	mov    %r14,0xd0(%rsp)
 106fcc8:	xor    %r14d,%r14d
 106fccb:	mov    %rbx,0x90(%rsp)
 106fcd3:	mov    %rsi,0x130(%rsp)
 106fcdb:	mov    %rdi,0xc8(%rsp)
 106fce3:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 106fcf0:	mov    %r12,%r13
 106fcf3:	shl    $0x6,%r13
 106fcf7:	vmovdqa64 (%rsi,%r13,1),%zmm0
 106fcfe:	vpcmpeqd 0x210(%rsp),%zmm0,%k0
 106fd09:	vmovdqu64 %zmm0,0x1b0(%rsp)
 106fd14:	kmovd  %k0,%eax
 106fd18:	and    $0x7777,%eax
 106fd1d:	add    $0x1111,%eax
 106fd22:	and    $0x8888,%ax
 106fd26:	je     106fda0 <check_input_run+0x2a10>
 106fd28:	mov    0x48(%rsp),%rcx
 106fd2d:	add    %rsi,%r13
 106fd30:	movzwl %ax,%ebx
 106fd33:	mov    0x10(%rcx),%rbp
 106fd37:	jmp    106fd4d <check_input_run+0x29bd>
 106fd39:	nopl   0x0(%rax)
 106fd40:	xor    %eax,%eax
 106fd42:	test   %al,%al
 106fd44:	jne    106fda2 <check_input_run+0x2a12>
 106fd46:	blsr   %ebx,%ebx
 106fd4b:	je     106fda2 <check_input_run+0x2a12>
 106fd4d:	xor    %eax,%eax
 106fd4f:	tzcnt  %ebx,%eax
 106fd53:	mov    0x0(%r13,%rax,4),%r15d
 106fd58:	cmp    %edx,0x4(%rbp,%r15,8)
 106fd5d:	jne    106fd40 <check_input_run+0x29b0>
 106fd5f:	mov    0x48(%rsp),%rax
 106fd64:	mov    0x0(%rbp,%r15,8),%edi
 106fd69:	mov    0x90(%rsp),%rsi
 106fd71:	mov    0xd0(%rsp),%rdx
 106fd79:	add    0x40(%rax),%rdi
 106fd7d:	vzeroupper
 106fd80:	call   7883c0 <bcmp@plt>
 106fd85:	mov    0x28(%rsp),%rdx
 106fd8a:	test   %eax,%eax
 106fd8c:	sete   %al
 106fd8f:	cmove  %r15d,%r14d
 106fd93:	test   %al,%al
 106fd95:	je     106fd46 <check_input_run+0x29b6>
 106fd97:	jmp    106fda2 <check_input_run+0x2a12>
 106fd99:	nopl   0x0(%rax)
 106fda0:	xor    %eax,%eax
 106fda2:	vmovdqu64 0x1b0(%rsp),%zmm0
 106fdad:	vptestnmd %zmm0,%zmm0,%k0
 106fdb3:	kmovd  %k0,%ecx
 106fdb7:	test   $0x8888,%ecx
 106fdbd:	jne    106fb50 <check_input_run+0x27c0>
 106fdc3:	mov    0xc8(%rsp),%rdi
 106fdcb:	mov    0x130(%rsp),%rsi
 106fdd3:	inc    %r12
 106fdd6:	and    %rdi,%r12
 106fdd9:	test   %al,%al
 106fddb:	je     106fcf0 <check_input_run+0x2960>
 106fde1:	jmp    106fb50 <check_input_run+0x27c0>
 106fde6:	cmpq   $0x0,0x88(%rsp)
 106fdef:	mov    0xc0(%rsp),%rcx
 106fdf7:	setne  %al
 106fdfa:	and    %al,%cl
 106fdfc:	cmpl   $0x0,0xf0(%rsp)
 106fe04:	mov    %rcx,0xc0(%rsp)
 106fe0c:	je     106fe46 <check_input_run+0x2ab6>
 106fe0e:	vmovdqa 0x280(%rsp),%xmm0
 106fe17:	mov    0x78(%rsp),%r8
 106fe1c:	mov    0x18(%r12),%rsi
 106fe21:	mov    0x4e4(%rsp),%eax
 106fe28:	mov    0x290(%rsp),%ecx
 106fe2f:	mov    %r8d,%edx
 106fe32:	lea    -0x1(%r8),%rdi
 106fe36:	and    $0x3,%edx
 106fe39:	cmp    $0x3,%rdi
 106fe3d:	jae    106fe52 <check_input_run+0x2ac2>
 106fe3f:	xor    %edi,%edi
 106fe41:	jmp    106ff62 <check_input_run+0x2bd2>
 106fe46:	mov    0x4e4(%rsp),%eax
 106fe4d:	jmp    106ffb3 <check_input_run+0x2c23>
 106fe52:	and    $0xfffffffc,%r8d
 106fe56:	xor    %edi,%edi
 106fe58:	jmp    106fe6d <check_input_run+0x2add>
 106fe5a:	nopw   0x0(%rax,%rax,1)
 106fe60:	add    $0x4,%rdi
 106fe64:	cmp    %rdi,%r8
 106fe67:	je     106ff5d <check_input_run+0x2bcd>
 106fe6d:	mov    (%rsi,%rdi,4),%r9d
 106fe71:	test   %r9d,%r9d
 106fe74:	je     106fea6 <check_input_run+0x2b16>
 106fe76:	vpbroadcastd %r9d,%xmm1
 106fe7c:	xor    %r10d,%r10d
 106fe7f:	cmp    %ecx,%r9d
 106fe82:	vpcmpeqd %xmm0,%xmm1,%k0
 106fe88:	sete   %r10b
 106fe8c:	kmovb  %k0,%r9d
 106fe90:	add    %eax,%r10d
 106fe93:	popcnt %r9d,%r9d
 106fe98:	add    %r9d,%r10d
 106fe9b:	mov    %r10d,%eax
 106fe9e:	mov    %r10d,0x4e4(%rsp)
 106fea6:	mov    0x4(%rsi,%rdi,4),%r9d
 106feab:	test   %r9d,%r9d
 106feae:	je     106fee0 <check_input_run+0x2b50>
 106feb0:	vpbroadcastd %r9d,%xmm1
 106feb6:	xor    %r10d,%r10d
 106feb9:	cmp    %ecx,%r9d
 106febc:	vpcmpeqd %xmm0,%xmm1,%k0
 106fec2:	sete   %r10b
 106fec6:	kmovb  %k0,%r9d
 106feca:	add    %eax,%r10d
 106fecd:	popcnt %r9d,%r9d
 106fed2:	add    %r9d,%r10d
 106fed5:	mov    %r10d,%eax
 106fed8:	mov    %r10d,0x4e4(%rsp)
 106fee0:	mov    0x8(%rsi,%rdi,4),%r9d
 106fee5:	test   %r9d,%r9d
 106fee8:	je     106ff1a <check_input_run+0x2b8a>
 106feea:	vpbroadcastd %r9d,%xmm1
 106fef0:	xor    %r10d,%r10d
 106fef3:	cmp    %ecx,%r9d
 106fef6:	vpcmpeqd %xmm0,%xmm1,%k0
 106fefc:	sete   %r10b
 106ff00:	kmovb  %k0,%r9d
 106ff04:	add    %eax,%r10d
 106ff07:	popcnt %r9d,%r9d
 106ff0c:	add    %r9d,%r10d
 106ff0f:	mov    %r10d,%eax
 106ff12:	mov    %r10d,0x4e4(%rsp)
 106ff1a:	mov    0xc(%rsi,%rdi,4),%r9d
 106ff1f:	test   %r9d,%r9d
 106ff22:	je     106fe60 <check_input_run+0x2ad0>
 106ff28:	vpbroadcastd %r9d,%xmm1
 106ff2e:	xor    %r10d,%r10d
 106ff31:	cmp    %ecx,%r9d
 106ff34:	vpcmpeqd %xmm0,%xmm1,%k0
 106ff3a:	sete   %r10b
 106ff3e:	kmovb  %k0,%r9d
 106ff42:	add    %eax,%r10d
 106ff45:	popcnt %r9d,%r9d
 106ff4a:	add    %r9d,%r10d
 106ff4d:	mov    %r10d,%eax
 106ff50:	mov    %r10d,0x4e4(%rsp)
 106ff58:	jmp    106fe60 <check_input_run+0x2ad0>
 106ff5d:	test   %rdx,%rdx
 106ff60:	je     106ffb3 <check_input_run+0x2c23>
 106ff62:	lea    (%rsi,%rdi,4),%rsi
 106ff66:	xor    %edi,%edi
 106ff68:	jmp    106ff78 <check_input_run+0x2be8>
 106ff6a:	nopw   0x0(%rax,%rax,1)
 106ff70:	inc    %rdi
 106ff73:	cmp    %rdi,%rdx
 106ff76:	je     106ffb3 <check_input_run+0x2c23>
 106ff78:	mov    (%rsi,%rdi,4),%r8d
 106ff7c:	test   %r8d,%r8d
 106ff7f:	je     106ff70 <check_input_run+0x2be0>
 106ff81:	vpbroadcastd %r8d,%xmm1
 106ff87:	xor    %r9d,%r9d
 106ff8a:	cmp    %ecx,%r8d
 106ff8d:	vpcmpeqd %xmm0,%xmm1,%k0
 106ff93:	sete   %r9b
 106ff97:	kmovb  %k0,%r8d
 106ff9b:	add    %eax,%r9d
 106ff9e:	popcnt %r8d,%r8d
 106ffa3:	add    %r8d,%r9d
 106ffa6:	mov    %r9d,%eax
 106ffa9:	mov    %r9d,0x4e4(%rsp)
 106ffb1:	jmp    106ff70 <check_input_run+0x2be0>
 106ffb3:	mov    0xc0(%rsp),%rdx
 106ffbb:	test   %eax,%eax
 106ffbd:	setne  %cl
 106ffc0:	test   %cl,%dl
 106ffc2:	je     106ffee <check_input_run+0x2c5e>
 106ffc4:	mov    0x38(%rsp),%r8
 106ffc9:	mov    %eax,%ecx
 106ffcb:	mov    (%r8),%rdx
 106ffce:	mov    0x8(%r8),%rdi
 106ffd2:	lea    0x3(%rdi,%rdx,1),%rsi
 106ffd7:	add    %rdx,%rdi
 106ffda:	and    $0xfffffffffffffffc,%rsi
 106ffde:	cmp    %rdi,%rsi
 106ffe1:	jae    1070235 <check_input_run+0x2ea5>
 106ffe7:	xor    %edx,%edx
 106ffe9:	jmp    107025e <check_input_run+0x2ece>
 106ffee:	mov    %rdx,%rcx
 106fff1:	test   %cl,%cl
 106fff3:	je     107029d <check_input_run+0x2f0d>
 106fff9:	mov    0x38(%rsp),%rcx
 106fffe:	mov    (%rcx),%rax
 1070001:	mov    0x8(%rcx),%rcx
 1070005:	lea    0x3f(%rcx,%rax,1),%rdx
 107000a:	add    %rax,%rcx
 107000d:	and    $0xffffffffffffffc0,%rdx
 1070011:	cmp    %rcx,%rdx
 1070014:	jb     107029d <check_input_run+0x2f0d>
 107001a:	mov    0x38(%rsp),%rcx
 107001f:	mov    %rdx,%rsi
 1070022:	sub    %rax,%rsi
 1070025:	mov    0x10(%rcx),%rcx
 1070029:	mov    %rcx,%r8
 107002c:	sub    %rsi,%r8
 107002f:	jb     107029d <check_input_run+0x2f0d>
 1070035:	mov    0x48(%rsp),%rdi
 107003a:	mov    0x68(%rdi),%edi
 107003d:	shl    $0x2,%rdi
 1070041:	cmp    %r8,%rdi
 1070044:	ja     107029d <check_input_run+0x2f0d>
 107004a:	mov    0x38(%rsp),%r8
 107004f:	add    %rdi,%rsi
 1070052:	mov    %rsi,0x8(%r8)
 1070056:	mov    %rdx,0x5b8(%rsp)
 107005e:	test   %rdx,%rdx
 1070061:	je     10702a9 <check_input_run+0x2f19>
 1070067:	lea    (%rdx,%rdi,1),%rsi
 107006b:	lea    0x3c(%rdx,%rdi,1),%rdx
 1070070:	and    $0xffffffffffffffc0,%rdx
 1070074:	cmp    %rsi,%rdx
 1070077:	jb     10702a9 <check_input_run+0x2f19>
 107007d:	mov    %rdx,%rsi
 1070080:	sub    %rax,%rsi
 1070083:	mov    %rcx,%r8
 1070086:	sub    %rsi,%r8
 1070089:	jb     10702a9 <check_input_run+0x2f19>
 107008f:	mov    0x58(%rsp),%rdi
 1070094:	mov    0x270(%rdi),%rdi
 107009b:	mov    0x68(%rdi),%edi
 107009e:	shl    $0x2,%rdi
 10700a2:	cmp    %r8,%rdi
 10700a5:	ja     10702a9 <check_input_run+0x2f19>
 10700ab:	mov    0x38(%rsp),%r8
 10700b0:	add    %rdi,%rsi
 10700b3:	mov    %rsi,0x8(%r8)
 10700b7:	mov    %rdx,0x5c0(%rsp)
 10700bf:	test   %rdx,%rdx
 10700c2:	je     10702b5 <check_input_run+0x2f25>
 10700c8:	lea    (%rdx,%rdi,1),%rsi
 10700cc:	lea    0x3c(%rdx,%rdi,1),%rdx
 10700d1:	and    $0xffffffffffffffc0,%rdx
 10700d5:	cmp    %rsi,%rdx
 10700d8:	jb     10702b5 <check_input_run+0x2f25>
 10700de:	mov    %rdx,%rdi
 10700e1:	sub    %rax,%rdi
 10700e4:	mov    %rcx,%r8
 10700e7:	sub    %rdi,%r8
 10700ea:	jb     10702b5 <check_input_run+0x2f25>
 10700f0:	mov    0x58(%rsp),%rsi
 10700f5:	mov    0x270(%rsi),%rsi
 10700fc:	mov    0x68(%rsi),%esi
 10700ff:	shl    $0x2,%rsi
 1070103:	cmp    %r8,%rsi
 1070106:	ja     10702b5 <check_input_run+0x2f25>
 107010c:	mov    0x38(%rsp),%r8
 1070111:	add    %rsi,%rdi
 1070114:	mov    %rdi,0x8(%r8)
 1070118:	mov    %rdx,0x5c8(%rsp)
 1070120:	test   %rdx,%rdx
 1070123:	je     10702c1 <check_input_run+0x2f31>
 1070129:	mov    0xa0(%rsp),%rdi
 1070131:	add    %rsi,%rdx
 1070134:	mov    %rcx,%r8
 1070137:	mov    %rdx,%rsi
 107013a:	sub    %rax,%rsi
 107013d:	mov    0xa4(%rdi),%edi
 1070143:	shl    $0x2,%rdi
 1070147:	sub    %rsi,%r8
 107014a:	setb   %r9b
 107014e:	cmp    %r8,%rdi
 1070151:	seta   %r8b
 1070155:	or     %r9b,%r8b
 1070158:	cmp    $0x1,%r8b
 107015c:	je     10702c1 <check_input_run+0x2f31>
 1070162:	mov    0x38(%rsp),%r8
 1070167:	add    %rdi,%rsi
 107016a:	mov    %rsi,0x8(%r8)
 107016e:	mov    %rdx,0x5f0(%rsp)
 1070176:	test   %rdx,%rdx
 1070179:	je     10702cd <check_input_run+0x2f3d>
 107017f:	mov    0xa0(%rsp),%rsi
 1070187:	add    %rdi,%rdx
 107018a:	mov    %rcx,%r8
 107018d:	mov    %rdx,%rdi
 1070190:	sub    %rax,%rdi
 1070193:	sub    %rdi,%r8
 1070196:	setb   %r9b
 107019a:	mov    0xa4(%rsi),%esi
 10701a0:	cmp    %rsi,%r8
 10701a3:	setb   %r8b
 10701a7:	or     %r9b,%r8b
 10701aa:	cmp    $0x1,%r8b
 10701ae:	je     10702cd <check_input_run+0x2f3d>
 10701b4:	mov    0x38(%rsp),%r8
 10701b9:	add    %rsi,%rdi
 10701bc:	test   %rdx,%rdx
 10701bf:	setne  %bl
 10701c2:	mov    %rdi,0x8(%r8)
 10701c6:	mov    0xe8(%rsp),%rdi
 10701ce:	mov    %rdx,0x5f8(%rsp)
 10701d6:	and    %bl,%dil
 10701d9:	cmp    $0x1,%dil
 10701dd:	jne    10702db <check_input_run+0x2f4b>
 10701e3:	lea    0x3(%rdx,%rsi,1),%rdi
 10701e8:	lea    (%rdx,%rsi,1),%r8
 10701ec:	and    $0xfffffffffffffffc,%rdi
 10701f0:	cmp    %r8,%rdi
 10701f3:	jb     1070224 <check_input_run+0x2e94>
 10701f5:	mov    0xa0(%rsp),%rdx
 10701fd:	mov    %rdi,%rsi
 1070200:	sub    %rax,%rsi
 1070203:	mov    0xa4(%rdx),%edx
 1070209:	shl    $0x2,%rdx
 107020d:	sub    %rsi,%rcx
 1070210:	setb   %al
 1070213:	cmp    %rcx,%rdx
 1070216:	seta   %cl
 1070219:	or     %al,%cl
 107021b:	cmp    $0x1,%cl
 107021e:	jne    1079fc0 <check_input_run+0xcc30>
 1070224:	movq   $0x0,0x600(%rsp)
 1070230:	jmp    10702d9 <check_input_run+0x2f49>
 1070235:	mov    0x10(%r8),%r9
 1070239:	mov    %rsi,%rdi
 107023c:	sub    %rdx,%rdi
 107023f:	xor    %edx,%edx
 1070241:	sub    %rdi,%r9
 1070244:	jb     107025e <check_input_run+0x2ece>
 1070246:	imul   $0x2c,%rcx,%r8
 107024a:	cmp    %r9,%r8
 107024d:	ja     107025e <check_input_run+0x2ece>
 107024f:	mov    0x38(%rsp),%rdx
 1070254:	add    %r8,%rdi
 1070257:	mov    %rdi,0x8(%rdx)
 107025b:	mov    %rsi,%rdx
 107025e:	mov    0x10(%rsp),%rsi
 1070263:	mov    %rdx,0x4c8(%rsp)
 107026b:	mov    (%rsi),%r8
 107026e:	mov    0x8(%rsi),%rdi
 1070272:	lea    0x3(%rdi,%r8,1),%rsi
 1070277:	add    %r8,%rdi
 107027a:	and    $0xfffffffffffffffc,%rsi
 107027e:	cmp    %rdi,%rsi
 1070281:	jae    10704be <check_input_run+0x312e>
 1070287:	mov    0x18(%rsp),%rcx
 107028c:	movq   $0x0,0xc0(%rcx)
 1070297:	mov    %eax,0xcc(%rcx)
 107029d:	movq   $0x0,0x5b8(%rsp)
 10702a9:	movq   $0x0,0x5c0(%rsp)
 10702b5:	movq   $0x0,0x5c8(%rsp)
 10702c1:	movq   $0x0,0x5f0(%rsp)
 10702cd:	movq   $0x0,0x5f8(%rsp)
 10702d9:	xor    %ebx,%ebx
 10702db:	mov    0x58(%rsp),%rax
 10702e0:	mov    0x38(%rsp),%rsi
 10702e5:	lea    0x2d0(%rsp),%rdi
 10702ed:	mov    0x270(%rax),%rax
 10702f4:	mov    0x68(%rax),%edx
 10702f7:	mov    0xf0(%rsp),%rax
 10702ff:	lea    0x1(,%rax,4),%ecx
 1070306:	vzeroupper
 1070309:	call   106b7d0 <c_bindings_initialize>
 107030e:	test   %bl,%bl
 1070310:	je     10704a6 <check_input_run+0x3116>
 1070316:	test   %al,%al
 1070318:	je     10704a6 <check_input_run+0x3116>
 107031e:	mov    0x78(%rsp),%r14
 1070323:	mov    0x340(%rsp),%rdi
 107032b:	xor    %esi,%esi
 107032d:	lea    0x4(,%r14,4),%rbx
 1070335:	lea    0x1(%r14),%rbp
 1070339:	mov    %rbx,%rdx
 107033c:	call   788430 <memset@plt>
 1070341:	mov    0x348(%rsp),%rdi
 1070349:	xor    %esi,%esi
 107034b:	mov    %rbx,%rdx
 107034e:	call   788430 <memset@plt>
 1070353:	mov    0x350(%rsp),%rdi
 107035b:	lea    0x8(,%r14,8),%r15
 1070363:	xor    %esi,%esi
 1070365:	mov    %r15,%rdx
 1070368:	call   788430 <memset@plt>
 107036d:	mov    0x358(%rsp),%rdi
 1070375:	xor    %esi,%esi
 1070377:	mov    %r15,%rdx
 107037a:	call   788430 <memset@plt>
 107037f:	mov    0x370(%rsp),%rdi
 1070387:	mov    $0xff,%esi
 107038c:	mov    %rbx,%rdx
 107038f:	call   788430 <memset@plt>
 1070394:	mov    0x398(%rsp),%rdi
 107039c:	xor    %esi,%esi
 107039e:	mov    %rbx,%rdx
 10703a1:	call   788430 <memset@plt>
 10703a6:	mov    0x3a0(%rsp),%rdi
 10703ae:	xor    %esi,%esi
 10703b0:	mov    %rbp,%rdx
 10703b3:	call   788430 <memset@plt>
 10703b8:	mov    0x530(%rsp),%rdi
 10703c0:	xor    %esi,%esi
 10703c2:	mov    %rbx,%rdx
 10703c5:	call   788430 <memset@plt>
 10703ca:	mov    0x538(%rsp),%rdi
 10703d2:	xor    %esi,%esi
 10703d4:	mov    %rbx,%rdx
 10703d7:	call   788430 <memset@plt>
 10703dc:	mov    0x540(%rsp),%rdi
 10703e4:	xor    %esi,%esi
 10703e6:	mov    %rbp,%rdx
 10703e9:	call   788430 <memset@plt>
 10703ee:	mov    0x548(%rsp),%rdi
 10703f6:	xor    %esi,%esi
 10703f8:	mov    %rbp,%rdx
 10703fb:	call   788430 <memset@plt>
 1070400:	mov    0x510(%rsp),%rdi
 1070408:	xor    %esi,%esi
 107040a:	mov    %rbp,%rdx
 107040d:	call   788430 <memset@plt>
 1070412:	mov    0x520(%rsp),%rdi
 107041a:	xor    %esi,%esi
 107041c:	mov    %rbp,%rdx
 107041f:	call   788430 <memset@plt>
 1070424:	mov    0x528(%rsp),%rdi
 107042c:	xor    %esi,%esi
 107042e:	mov    %rbp,%rdx
 1070431:	call   788430 <memset@plt>
 1070436:	mov    0x18(%rsp),%r14
 107043b:	mov    0x100(%rsp),%rdx
 1070443:	xor    %esi,%esi
 1070445:	mov    0x50(%r14),%rdi
 1070449:	call   788430 <memset@plt>
 107044e:	mov    0x2c8(%r14),%rdi
 1070455:	xor    %esi,%esi
 1070457:	mov    %rbp,%rdx
 107045a:	call   788430 <memset@plt>
 107045f:	mov    0x2d0(%r14),%rdi
 1070466:	xor    %esi,%esi
 1070468:	mov    %rbp,%rdx
 107046b:	call   788430 <memset@plt>
 1070470:	mov    0x1f0(%r14),%rsi
 1070477:	mov    0x3d8(%rsp),%rdi
 107047f:	test   %rsi,%rsi
 1070482:	sete   %al
 1070485:	cmpq   $0x0,0x860(%rsp)
 107048e:	setne  %cl
 1070491:	or     %al,%cl
 1070493:	jne    107052d <check_input_run+0x319d>
 1070499:	mov    %rbp,%rdx
 107049c:	call   788550 <memcpy@plt>
 10704a1:	jmp    1070537 <check_input_run+0x31a7>
 10704a6:	mov    0x18(%rsp),%rax
 10704ab:	movb   $0x1,0x3c5(%rax)
 10704b2:	xor    %eax,%eax
 10704b4:	mov    0x38(%rsp),%rcx
 10704b9:	jmp    1076326 <check_input_run+0x8f96>
 10704be:	mov    %rsi,%rdi
 10704c1:	sub    %r8,%rdi
 10704c4:	mov    0x10(%rsp),%r8
 10704c9:	mov    0x10(%r8),%r8
 10704cd:	sub    %rdi,%r8
 10704d0:	jb     1070287 <check_input_run+0x2ef7>
 10704d6:	shl    $0x2,%rcx
 10704da:	lea    (%rcx,%rcx,8),%rcx
 10704de:	cmp    %r8,%rcx
 10704e1:	ja     1070287 <check_input_run+0x2ef7>
 10704e7:	mov    0x10(%rsp),%r8
 10704ec:	add    %rcx,%rdi
 10704ef:	mov    %rdi,0x8(%r8)
 10704f3:	mov    0x18(%rsp),%rdi
 10704f8:	mov    %rsi,0xc0(%rdi)
 10704ff:	mov    %eax,0xcc(%rdi)
 1070505:	test   %rdx,%rdx
 1070508:	je     107029d <check_input_run+0x2f0d>
 107050e:	test   %rsi,%rsi
 1070511:	je     107029d <check_input_run+0x2f0d>
 1070517:	mov    0x58(%rsp),%rax
 107051c:	mov    0x270(%rax),%rax
 1070523:	mov    %rax,0x48(%rsp)
 1070528:	jmp    106fff9 <check_input_run+0x2c69>
 107052d:	xor    %esi,%esi
 107052f:	mov    %rbp,%rdx
 1070532:	call   788430 <memset@plt>
 1070537:	mov    0x3a8(%rsp),%rdi
 107053f:	xor    %r14d,%r14d
 1070542:	xor    %esi,%esi
 1070544:	mov    %rbp,%rdx
 1070547:	call   788430 <memset@plt>
 107054c:	mov    0x3b0(%rsp),%rdi
 1070554:	xor    %esi,%esi
 1070556:	mov    %rbp,%rdx
 1070559:	call   788430 <memset@plt>
 107055e:	mov    0x118(%rsp),%rax
 1070566:	xor    %esi,%esi
 1070568:	mov    %rbp,%rdx
 107056b:	mov    (%rax),%rdi
 107056e:	call   788430 <memset@plt>
 1070573:	mov    0x3b8(%rsp),%rdi
 107057b:	xor    %esi,%esi
 107057d:	mov    %rbp,%rdx
 1070580:	call   788430 <memset@plt>
 1070585:	mov    0x3c0(%rsp),%rdi
 107058d:	xor    %esi,%esi
 107058f:	mov    %rbp,%rdx
 1070592:	call   788430 <memset@plt>
 1070597:	mov    0x60(%rsp),%rax
 107059c:	xor    %esi,%esi
 107059e:	mov    %rbp,%rdx
 10705a1:	mov    (%rax),%rdi
 10705a4:	call   788430 <memset@plt>
 10705a9:	mov    0xb8(%rsp),%rax
 10705b1:	xor    %esi,%esi
 10705b3:	mov    %rbp,%rdx
 10705b6:	mov    (%rax),%rdi
 10705b9:	call   788430 <memset@plt>
 10705be:	mov    0x98(%rsp),%rax
 10705c6:	xor    %esi,%esi
 10705c8:	mov    %rbp,%rdx
 10705cb:	mov    (%rax),%rdi
 10705ce:	call   788430 <memset@plt>
 10705d3:	mov    0x110(%rsp),%rax
 10705db:	xor    %esi,%esi
 10705dd:	mov    %rbp,%rdx
 10705e0:	mov    (%rax),%rdi
 10705e3:	call   788430 <memset@plt>
 10705e8:	mov    0x128(%rsp),%rax
 10705f0:	xor    %esi,%esi
 10705f2:	mov    %rbx,%rdx
 10705f5:	mov    (%rax),%rdi
 10705f8:	call   788430 <memset@plt>
 10705fd:	mov    0x120(%rsp),%rax
 1070605:	xor    %esi,%esi
 1070607:	mov    %rbx,%rdx
 107060a:	mov    (%rax),%rdi
 107060d:	call   788430 <memset@plt>
 1070612:	mov    0x50(%rsp),%rax
 1070617:	xor    %esi,%esi
 1070619:	mov    %r15,%rdx
 107061c:	mov    (%rax),%rdi
 107061f:	call   788430 <memset@plt>
 1070624:	mov    0x550(%rsp),%rdi
 107062c:	xor    %esi,%esi
 107062e:	mov    %r15,%rdx
 1070631:	call   788430 <memset@plt>
 1070636:	mov    0x3c8(%rsp),%rdi
 107063e:	xor    %esi,%esi
 1070640:	mov    %rbp,%rdx
 1070643:	call   788430 <memset@plt>
 1070648:	mov    0x3d0(%rsp),%rdi
 1070650:	xor    %esi,%esi
 1070652:	mov    %rbx,%rdx
 1070655:	call   788430 <memset@plt>
 107065a:	mov    0x58(%rsp),%r13
 107065f:	mov    0x590(%rsp),%rdi
 1070667:	xor    %esi,%esi
 1070669:	mov    0x270(%r13),%rax
 1070670:	mov    0x68(%rax),%edx
 1070673:	shl    $0x2,%rdx
 1070677:	call   788430 <memset@plt>
 107067c:	mov    0x5a0(%rsp),%rdi
 1070684:	xor    %esi,%esi
 1070686:	mov    %rbp,%rdx
 1070689:	call   788430 <memset@plt>
 107068e:	mov    0x270(%r13),%rax
 1070695:	mov    0x5b8(%rsp),%rdi
 107069d:	xor    %esi,%esi
 107069f:	mov    0x68(%rax),%edx
 10706a2:	shl    $0x2,%rdx
 10706a6:	call   788430 <memset@plt>
 10706ab:	mov    0x270(%r13),%rax
 10706b2:	mov    0x5c0(%rsp),%rdi
 10706ba:	xor    %esi,%esi
 10706bc:	mov    0x68(%rax),%edx
 10706bf:	shl    $0x2,%rdx
 10706c3:	call   788430 <memset@plt>
 10706c8:	mov    0x270(%r13),%rax
 10706cf:	mov    0x5c8(%rsp),%rdi
 10706d7:	xor    %esi,%esi
 10706d9:	mov    0x68(%rax),%edx
 10706dc:	shl    $0x2,%rdx
 10706e0:	call   788430 <memset@plt>
 10706e5:	mov    0x5d0(%rsp),%rdi
 10706ed:	xor    %esi,%esi
 10706ef:	mov    %rbx,%rdx
 10706f2:	call   788430 <memset@plt>
 10706f7:	mov    0xa0(%rsp),%r15
 10706ff:	mov    0x5f0(%rsp),%rdi
 1070707:	mov    $0xff,%esi
 107070c:	mov    0xa4(%r15),%edx
 1070713:	shl    $0x2,%rdx
 1070717:	call   788430 <memset@plt>
 107071c:	mov    0x5f8(%rsp),%rdi
 1070724:	mov    0xa4(%r15),%edx
 107072b:	xor    %esi,%esi
 107072d:	call   788430 <memset@plt>
 1070732:	mov    0x3e0(%rsp),%rdi
 107073a:	xor    %esi,%esi
 107073c:	mov    %rbp,%rdx
 107073f:	call   788430 <memset@plt>
 1070744:	mov    0x3e8(%rsp),%rdi
 107074c:	xor    %esi,%esi
 107074e:	mov    %rbp,%rdx
 1070751:	call   788430 <memset@plt>
 1070756:	mov    0x428(%rsp),%rdi
 107075e:	xor    %esi,%esi
 1070760:	mov    %rbp,%rdx
 1070763:	call   788430 <memset@plt>
 1070768:	mov    0x430(%rsp),%rdi
 1070770:	xor    %esi,%esi
 1070772:	mov    %rbx,%rdx
 1070775:	call   788430 <memset@plt>
 107077a:	mov    0x438(%rsp),%rdi
 1070782:	xor    %esi,%esi
 1070784:	mov    %rbx,%rdx
 1070787:	call   788430 <memset@plt>
 107078c:	mov    0x408(%rsp),%rdi
 1070794:	xor    %esi,%esi
 1070796:	mov    %rbx,%rdx
 1070799:	call   788430 <memset@plt>
 107079e:	mov    0x448(%rsp),%rdi
 10707a6:	xor    %esi,%esi
 10707a8:	mov    %rbx,%rdx
 10707ab:	call   788430 <memset@plt>
 10707b0:	mov    0x450(%rsp),%rdi
 10707b8:	xor    %esi,%esi
 10707ba:	mov    %rbx,%rdx
 10707bd:	call   788430 <memset@plt>
 10707c2:	mov    0x460(%rsp),%rdi
 10707ca:	xor    %esi,%esi
 10707cc:	mov    %rbx,%rdx
 10707cf:	call   788430 <memset@plt>
 10707d4:	mov    0x4a8(%rsp),%rdi
 10707dc:	add    %rbp,%rbp
 10707df:	xor    %esi,%esi
 10707e1:	mov    %rbp,%rdx
 10707e4:	call   788430 <memset@plt>
 10707e9:	mov    0x4b0(%rsp),%rdi
 10707f1:	xor    %esi,%esi
 10707f3:	mov    %rbx,%rdx
 10707f6:	call   788430 <memset@plt>
 10707fb:	mov    0x4d0(%rsp),%rdi
 1070803:	xor    %esi,%esi
 1070805:	mov    %rbx,%rdx
 1070808:	call   788430 <memset@plt>
 107080d:	mov    0x4d8(%rsp),%rdi
 1070815:	xor    %esi,%esi
 1070817:	mov    %rbx,%rdx
 107081a:	call   788430 <memset@plt>
 107081f:	mov    0x4e8(%rsp),%rdi
 1070827:	xor    %esi,%esi
 1070829:	mov    %rbx,%rdx
 107082c:	call   788430 <memset@plt>
 1070831:	mov    0x4f0(%rsp),%rdi
 1070839:	xor    %esi,%esi
 107083b:	mov    %rbx,%rdx
 107083e:	call   788430 <memset@plt>
 1070843:	mov    0x4f8(%rsp),%rdi
 107084b:	xor    %esi,%esi
 107084d:	mov    %rbx,%rdx
 1070850:	call   788430 <memset@plt>
 1070855:	mov    0x270(%r13),%rax
 107085c:	mov    0x470(%rsp),%rdi
 1070864:	mov    $0xff,%esi
 1070869:	mov    0x68(%rax),%edx
 107086c:	add    %rdx,%rdx
 107086f:	call   788430 <memset@plt>
 1070874:	mov    0xd8(%rsp),%rsi
 107087c:	mov    0x260(%rsp),%rcx
 1070884:	mov    0x258(%rsp),%rdx
 107088c:	mov    0x68(%rsp),%rdi
 1070891:	mov    0x150(%rsp),%r8
 1070899:	mov    0x148(%rsp),%r9
 10708a1:	mov    0x80(%rsp),%r10
 10708a9:	mov    0xa8(%rsp),%r11
 10708b1:	mov    0xf8(%rsp),%rbx
 10708b9:	mov    0xb0(%rsp),%r15
 10708c1:	mov    0xe0(%rsp),%r13
 10708c9:	mov    0x108(%rsp),%rbp
 10708d1:	cmp    $0x1,%esi
 10708d4:	adc    $0x0,%esi
 10708d7:	nopw   0x0(%rax,%rax,1)
 10708e0:	mov    (%rdi),%rax
 10708e3:	movl   $0xffffffff,(%rax,%r14,4)
 10708eb:	mov    (%r8),%rax
 10708ee:	movl   $0xffffffff,(%rax,%r14,4)
 10708f6:	mov    (%rcx),%rax
 10708f9:	movl   $0xffffffff,(%rax,%r14,4)
 1070901:	mov    (%rdx),%rax
 1070904:	movl   $0xffffffff,(%rax,%r14,4)
 107090c:	mov    (%r9),%rax
 107090f:	movl   $0xffffffff,(%rax,%r14,4)
 1070917:	mov    (%r10),%rax
 107091a:	movl   $0xffffffff,(%rax,%r14,4)
 1070922:	mov    (%r11),%rax
 1070925:	movl   $0xffffffff,(%rax,%r14,4)
 107092d:	mov    (%rbx),%rax
 1070930:	movl   $0xffffffff,(%rax,%r14,4)
 1070938:	mov    (%r15),%rax
 107093b:	movl   $0xffffffff,(%rax,%r14,4)
 1070943:	mov    0x0(%r13),%rax
 1070947:	movl   $0xffffffff,(%rax,%r14,4)
 107094f:	mov    0x0(%rbp),%rax
 1070953:	movl   $0xffffffff,(%rax,%r14,4)
 107095b:	mov    0x418(%rsp),%rax
 1070963:	movl   $0xffffffff,(%rax,%r14,4)
 107096b:	mov    0x3f0(%rsp),%rax
 1070973:	movl   $0xffffffff,(%rax,%r14,4)
 107097b:	mov    0x3f8(%rsp),%rax
 1070983:	movl   $0xffffffff,(%rax,%r14,4)
 107098b:	mov    0x400(%rsp),%rax
 1070993:	movl   $0xffffffff,(%rax,%r14,4)
 107099b:	mov    0x440(%rsp),%rax
 10709a3:	movl   $0xffffffff,(%rax,%r14,4)
 10709ab:	mov    0x570(%rsp),%rax
 10709b3:	movl   $0xffffffff,(%rax,%r14,4)
 10709bb:	mov    0x580(%rsp),%rax
 10709c3:	movl   $0xffffffff,(%rax,%r14,4)
 10709cb:	mov    0x610(%rsp),%rax
 10709d3:	movl   $0xffffffff,(%rax,%r14,4)
 10709db:	mov    0x618(%rsp),%rax
 10709e3:	movl   $0xffffffff,(%rax,%r14,4)
 10709eb:	mov    0x620(%rsp),%rax
 10709f3:	movl   $0xffffffff,(%rax,%r14,4)
 10709fb:	mov    0x628(%rsp),%rax
 1070a03:	movl   $0xffffffff,(%rax,%r14,4)
 1070a0b:	mov    0x608(%rsp),%rax
 1070a13:	mov    %r14d,(%rax,%r14,4)
 1070a17:	inc    %r14
 1070a1a:	cmp    %r14,%rsi
 1070a1d:	jne    10708e0 <check_input_run+0x3550>
 1070a23:	cmpl   $0x0,0xf0(%rsp)
 1070a2b:	je     1070e71 <check_input_run+0x3ae1>
 1070a31:	mov    0xf0(%rsp),%rax
 1070a39:	mov    %eax,%edx
 1070a3b:	lea    -0x1(%rax),%ecx
 1070a3e:	mov    0x78(%rsp),%rax
 1070a43:	and    $0x3,%edx
 1070a46:	je     1070a95 <check_input_run+0x3705>
 1070a48:	mov    0x78(%rsp),%rax
 1070a4d:	jmp    1070a57 <check_input_run+0x36c7>
 1070a4f:	nop
 1070a50:	dec    %rax
 1070a53:	dec    %edx
 1070a55:	je     1070a95 <check_input_run+0x3705>
 1070a57:	mov    0x60(%r12),%rdi
 1070a5c:	lea    -0x1(%rax),%esi
 1070a5f:	mov    (%rdi,%rsi,4),%edi
 1070a62:	cmp    0xf0(%rsp),%edi
 1070a69:	jae    1070a50 <check_input_run+0x36c0>
 1070a6b:	mov    0x610(%rsp),%r9
 1070a73:	mov    0x618(%rsp),%r10
 1070a7b:	lea    -0x1(%rax),%r8d
 1070a7f:	mov    (%r9,%rdi,4),%r9d
 1070a83:	mov    %r9d,(%r10,%rsi,4)
 1070a87:	mov    0x610(%rsp),%rsi
 1070a8f:	mov    %r8d,(%rsi,%rdi,4)
 1070a93:	jmp    1070a50 <check_input_run+0x36c0>
 1070a95:	cmp    $0x3,%ecx
 1070a98:	jae    1070ab9 <check_input_run+0x3729>
 1070a9a:	mov    0x78(%rsp),%rsi
 1070a9f:	mov    %esi,%eax
 1070aa1:	lea    -0x1(%rsi),%rcx
 1070aa5:	and    $0x3,%eax
 1070aa8:	cmp    $0x3,%rcx
 1070aac:	jae    1070c33 <check_input_run+0x38a3>
 1070ab2:	xor    %edx,%edx
 1070ab4:	jmp    1070d78 <check_input_run+0x39e8>
 1070ab9:	mov    $0xfffffffc,%ecx
 1070abe:	mov    $0xfffffffffffffffc,%r8
 1070ac5:	mov    $0xfffffffffffffffd,%r9
 1070acc:	mov    $0xfffffffffffffffe,%r10
 1070ad3:	mov    $0xffffffffffffffff,%r11
 1070ada:	xor    %ebx,%ebx
 1070adc:	lea    0x1(%rcx),%rdx
 1070ae0:	lea    0x2(%rcx),%rsi
 1070ae4:	lea    0x3(%rcx),%rdi
 1070ae8:	jmp    1070b18 <check_input_run+0x3788>
 1070aea:	nopw   0x0(%rax,%rax,1)
 1070af0:	add    $0xfffffffffffffffc,%r8
 1070af4:	add    $0x4,%rbx
 1070af8:	add    $0xfffffffffffffffc,%rcx
 1070afc:	add    $0xfffffffffffffffc,%r9
 1070b00:	add    $0xfffffffffffffffc,%rdx
 1070b04:	add    $0xfffffffffffffffc,%r10
 1070b08:	add    $0xfffffffffffffffc,%rsi
 1070b0c:	add    $0xfffffffffffffffc,%r11
 1070b10:	add    $0xfffffffffffffffc,%rdi
 1070b14:	cmp    %ebx,%eax
 1070b16:	je     1070a9a <check_input_run+0x370a>
 1070b18:	mov    0x60(%r12),%r15
 1070b1d:	lea    (%rax,%r11,1),%r14d
 1070b21:	mov    (%r15,%r14,4),%r15d
 1070b25:	cmp    0xf0(%rsp),%r15d
 1070b2d:	jae    1070b5c <check_input_run+0x37cc>
 1070b2f:	mov    0x610(%rsp),%r12
 1070b37:	mov    0x618(%rsp),%r13
 1070b3f:	lea    (%rax,%rdi,1),%ebp
 1070b42:	mov    (%r12,%r15,4),%r12d
 1070b46:	mov    %r12d,0x0(%r13,%r14,4)
 1070b4b:	mov    0x20(%rsp),%r12
 1070b50:	mov    0x610(%rsp),%r14
 1070b58:	mov    %ebp,(%r14,%r15,4)
 1070b5c:	mov    0x60(%r12),%r15
 1070b61:	lea    (%rax,%r10,1),%r14d
 1070b65:	mov    (%r15,%r14,4),%r15d
 1070b69:	cmp    0xf0(%rsp),%r15d
 1070b71:	jae    1070ba0 <check_input_run+0x3810>
 1070b73:	mov    0x610(%rsp),%r12
 1070b7b:	mov    0x618(%rsp),%r13
 1070b83:	lea    (%rax,%rsi,1),%ebp
 1070b86:	mov    (%r12,%r15,4),%r12d
 1070b8a:	mov    %r12d,0x0(%r13,%r14,4)
 1070b8f:	mov    0x20(%rsp),%r12
 1070b94:	mov    0x610(%rsp),%r14
 1070b9c:	mov    %ebp,(%r14,%r15,4)
 1070ba0:	mov    0x60(%r12),%r15
 1070ba5:	lea    (%rax,%r9,1),%r14d
 1070ba9:	mov    (%r15,%r14,4),%r15d
 1070bad:	cmp    0xf0(%rsp),%r15d
 1070bb5:	jae    1070be4 <check_input_run+0x3854>
 1070bb7:	mov    0x610(%rsp),%r12
 1070bbf:	mov    0x618(%rsp),%r13
 1070bc7:	lea    (%rax,%rdx,1),%ebp
 1070bca:	mov    (%r12,%r15,4),%r12d
 1070bce:	mov    %r12d,0x0(%r13,%r14,4)
 1070bd3:	mov    0x20(%rsp),%r12
 1070bd8:	mov    0x610(%rsp),%r14
 1070be0:	mov    %ebp,(%r14,%r15,4)
 1070be4:	mov    0x60(%r12),%r15
 1070be9:	lea    (%rax,%r8,1),%r14d
 1070bed:	mov    (%r15,%r14,4),%r15d
 1070bf1:	cmp    0xf0(%rsp),%r15d
 1070bf9:	jae    1070af0 <check_input_run+0x3760>
 1070bff:	mov    0x610(%rsp),%r13
 1070c07:	mov    0x618(%rsp),%rbp
 1070c0f:	lea    (%rax,%rcx,1),%r12
 1070c13:	mov    0x0(%r13,%r15,4),%r13d
 1070c18:	mov    %r13d,0x0(%rbp,%r14,4)
 1070c1d:	mov    0x610(%rsp),%r14
 1070c25:	mov    %r12d,(%r14,%r15,4)
 1070c29:	mov    0x20(%rsp),%r12
 1070c2e:	jmp    1070af0 <check_input_run+0x3760>
 1070c33:	and    $0xfffffffc,%esi
 1070c36:	xor    %edi,%edi
 1070c38:	jmp    1070c4c <check_input_run+0x38bc>
 1070c3a:	nopw   0x0(%rax,%rax,1)
 1070c40:	inc    %rdi
 1070c43:	cmp    %rsi,%rdi
 1070c46:	je     1070d61 <check_input_run+0x39d1>
 1070c4c:	mov    0x68(%r12),%r8
 1070c51:	mov    %rdi,%rdx
 1070c54:	mov    (%r8,%rdx,4),%edi
 1070c58:	mov    0x5e8(%rsp),%r8
 1070c60:	mov    %edx,(%r8,%rdi,4)
 1070c64:	mov    0x60(%r12),%r8
 1070c69:	mov    (%r8,%rdi,4),%r8d
 1070c6d:	cmp    0xf0(%rsp),%r8d
 1070c75:	jae    1070c8d <check_input_run+0x38fd>
 1070c77:	mov    0x608(%rsp),%r9
 1070c7f:	mov    (%r9,%rdi,4),%edi
 1070c83:	cmp    %edi,(%r9,%r8,4)
 1070c87:	jae    1070c8d <check_input_run+0x38fd>
 1070c89:	mov    %edi,(%r9,%r8,4)
 1070c8d:	mov    0x68(%r12),%rdi
 1070c92:	mov    0x5e8(%rsp),%r9
 1070c9a:	mov    0x4(%rdi,%rdx,4),%r8d
 1070c9f:	lea    0x1(%rdx),%rdi
 1070ca3:	mov    %edi,(%r9,%r8,4)
 1070ca7:	mov    0x60(%r12),%r9
 1070cac:	mov    (%r9,%r8,4),%r9d
 1070cb0:	cmp    0xf0(%rsp),%r9d
 1070cb8:	jae    1070cd0 <check_input_run+0x3940>
 1070cba:	mov    0x608(%rsp),%r10
 1070cc2:	mov    (%r10,%r8,4),%r8d
 1070cc6:	cmp    %r8d,(%r10,%r9,4)
 1070cca:	jae    1070cd0 <check_input_run+0x3940>
 1070ccc:	mov    %r8d,(%r10,%r9,4)
 1070cd0:	mov    0x68(%r12),%r8
 1070cd5:	mov    0x5e8(%rsp),%r9
 1070cdd:	inc    %rdi
 1070ce0:	mov    0x8(%r8,%rdx,4),%r8d
 1070ce5:	mov    %edi,(%r9,%r8,4)
 1070ce9:	mov    0x60(%r12),%r9
 1070cee:	mov    (%r9,%r8,4),%r9d
 1070cf2:	cmp    0xf0(%rsp),%r9d
 1070cfa:	jae    1070d12 <check_input_run+0x3982>
 1070cfc:	mov    0x608(%rsp),%r10
 1070d04:	mov    (%r10,%r8,4),%r8d
 1070d08:	cmp    %r8d,(%r10,%r9,4)
 1070d0c:	jae    1070d12 <check_input_run+0x3982>
 1070d0e:	mov    %r8d,(%r10,%r9,4)
 1070d12:	mov    0x68(%r12),%r8
 1070d17:	mov    0x5e8(%rsp),%r9
 1070d1f:	inc    %rdi
 1070d22:	mov    0xc(%r8,%rdx,4),%r8d
 1070d27:	mov    %edi,(%r9,%r8,4)
 1070d2b:	mov    0x60(%r12),%r9
 1070d30:	mov    (%r9,%r8,4),%r9d
 1070d34:	cmp    0xf0(%rsp),%r9d
 1070d3c:	jae    1070c40 <check_input_run+0x38b0>
 1070d42:	mov    0x608(%rsp),%r10
 1070d4a:	mov    (%r10,%r8,4),%r8d
 1070d4e:	cmp    %r8d,(%r10,%r9,4)
 1070d52:	jae    1070c40 <check_input_run+0x38b0>
 1070d58:	mov    %r8d,(%r10,%r9,4)
 1070d5c:	jmp    1070c40 <check_input_run+0x38b0>
 1070d61:	test   %rax,%rax
 1070d64:	je     1070db4 <check_input_run+0x3a24>
 1070d66:	add    $0x4,%rdx
 1070d6a:	jmp    1070d78 <check_input_run+0x39e8>
 1070d6c:	nopl   0x0(%rax)
 1070d70:	inc    %rdx
 1070d73:	dec    %rax
 1070d76:	je     1070db4 <check_input_run+0x3a24>
 1070d78:	mov    0x68(%r12),%rsi
 1070d7d:	mov    0x5e8(%rsp),%rdi
 1070d85:	mov    (%rsi,%rdx,4),%esi
 1070d88:	mov    %edx,(%rdi,%rsi,4)
 1070d8b:	mov    0x60(%r12),%rdi
 1070d90:	mov    (%rdi,%rsi,4),%edi
 1070d93:	cmp    0xf0(%rsp),%edi
 1070d9a:	jae    1070d70 <check_input_run+0x39e0>
 1070d9c:	mov    0x608(%rsp),%r8
 1070da4:	mov    (%r8,%rsi,4),%esi
 1070da8:	cmp    %esi,(%r8,%rdi,4)
 1070dac:	jae    1070d70 <check_input_run+0x39e0>
 1070dae:	mov    %esi,(%r8,%rdi,4)
 1070db2:	jmp    1070d70 <check_input_run+0x39e0>
 1070db4:	mov    0x78(%rsp),%rax
 1070db9:	mov    %rax,%rdx
 1070dbc:	and    $0x3,%rdx
 1070dc0:	je     1070e67 <check_input_run+0x3ad7>
 1070dc6:	mov    0x78(%rsp),%rax
 1070dcb:	movabs $0x10380420000000,%rsi
 1070dd5:	jmp    1070e01 <check_input_run+0x3a71>
 1070dd7:	nopw   0x0(%rax,%rax,1)
 1070de0:	mov    0x508(%rsp),%r9
 1070de8:	movzbl (%r9,%r8,1),%r10d
 1070ded:	mov    0x508(%rsp),%r8
 1070df5:	dec    %rax
 1070df8:	dec    %rdx
 1070dfb:	mov    %r10b,(%r8,%rdi,1)
 1070dff:	je     1070e67 <check_input_run+0x3ad7>
 1070e01:	mov    0x68(%r12),%rdi
 1070e06:	mov    0x50(%r12),%r9
 1070e0b:	mov    0x60(%r12),%r8
 1070e10:	mov    -0x4(%rdi,%rax,4),%edi
 1070e14:	movzbl (%r9,%rdi,1),%r11d
 1070e19:	mov    (%r8,%rdi,4),%r8d
 1070e1d:	cmp    $0x1c,%r11d
 1070e21:	sete   %r10b
 1070e25:	cmp    0xf0(%rsp),%r8d
 1070e2d:	setb   %bl
 1070e30:	test   %bl,%r10b
 1070e33:	jne    1070de0 <check_input_run+0x3a50>
 1070e35:	add    $0xffffffe2,%r11d
 1070e39:	cmp    $0x34,%r11d
 1070e3d:	ja     1070e62 <check_input_run+0x3ad2>
 1070e3f:	mov    $0x1,%r10b
 1070e42:	bt     %r11,%rsi
 1070e46:	jb     1070ded <check_input_run+0x3a5d>
 1070e48:	test   %r11,%r11
 1070e4b:	jne    1070e62 <check_input_run+0x3ad2>
 1070e4d:	cmp    0xf0(%rsp),%r8d
 1070e55:	jae    1070e62 <check_input_run+0x3ad2>
 1070e57:	cmpb   $0x4a,(%r9,%r8,1)
 1070e5c:	sete   %r10b
 1070e60:	jmp    1070ded <check_input_run+0x3a5d>
 1070e62:	xor    %r10d,%r10d
 1070e65:	jmp    1070ded <check_input_run+0x3a5d>
 1070e67:	cmp    $0x3,%rcx
 1070e6b:	jae    107111f <check_input_run+0x3d8f>
 1070e71:	mov    0x48(%r12),%eax
 1070e76:	test   %rax,%rax
 1070e79:	je     10724a3 <check_input_run+0x5113>
 1070e7f:	mov    0x38(%rsp),%rsi
 1070e84:	mov    0x8(%rsi),%rbx
 1070e88:	mov    0x10(%rsi),%rcx
 1070e8c:	sub    %rbx,%rcx
 1070e8f:	setb   %dl
 1070e92:	cmp    %rax,%rcx
 1070e95:	setb   %cl
 1070e98:	or     %dl,%cl
 1070e9a:	cmp    $0x1,%cl
 1070e9d:	je     1072497 <check_input_run+0x5107>
 1070ea3:	add    %rbx,%rax
 1070ea6:	mov    0x18(%rsp),%rdx
 1070eab:	mov    %rbx,%rcx
 1070eae:	mov    %rax,0x8(%rsi)
 1070eb2:	mov    (%rsi),%rax
 1070eb5:	add    %rax,%rcx
 1070eb8:	sete   %cl
 1070ebb:	or     %cl,0x3c5(%rdx)
 1070ec1:	add    %rax,%rbx
 1070ec4:	je     10724a3 <check_input_run+0x5113>
 1070eca:	mov    0x48(%r12),%edx
 1070ecf:	mov    %rbx,%rdi
 1070ed2:	xor    %esi,%esi
 1070ed4:	call   788430 <memset@plt>
 1070ed9:	lea    0x2a0(%rsp),%rdi
 1070ee1:	mov    %rbx,%rsi
 1070ee4:	call   1066e80 <check_input_diagnostic_pragmas>
 1070ee9:	test   %al,%al
 1070eeb:	je     1072497 <check_input_run+0x5107>
 1070ef1:	lea    0x2a0(%rsp),%rdi
 1070ef9:	mov    %rbx,%rsi
 1070efc:	call   1081350 <check_input_nonnull_pragmas>
 1070f01:	test   %al,%al
 1070f03:	je     1072497 <check_input_run+0x5107>
 1070f09:	mov    0x2c8(%rsp),%rcx
 1070f11:	mov    0x2a8(%rsp),%rax
 1070f19:	mov    0x8(%rcx),%r9
 1070f1d:	mov    0x48(%rax),%ecx
 1070f20:	mov    %rcx,0x48(%rsp)
 1070f25:	test   %rcx,%rcx
 1070f28:	je     1079e0e <check_input_run+0xca7e>
 1070f2e:	mov    0x2c0(%rsp),%rcx
 1070f36:	mov    0x30(%rax),%r8d
 1070f3a:	mov    0x38(%rax),%rdx
 1070f3e:	mov    0x40(%rax),%rdi
 1070f42:	mov    0x48(%rsp),%rax
 1070f47:	mov    %r9,0x28(%rsp)
 1070f4c:	xor    %r15d,%r15d
 1070f4f:	xor    %r9d,%r9d
 1070f52:	xor    %esi,%esi
 1070f54:	xor    %r10d,%r10d
 1070f57:	mov    %rcx,0xd0(%rsp)
 1070f5f:	mov    0x8(%rcx),%rcx
 1070f63:	mov    %r8,0x90(%rsp)
 1070f6b:	mov    %rcx,0x210(%rsp)
 1070f73:	mov    0x2b0(%rsp),%rcx
 1070f7b:	nopl   0x0(%rax,%rax,1)
 1070f80:	mov    (%rdx,%r9,4),%r14d
 1070f84:	cmp    %r10d,%r14d
 1070f87:	jb     1070fcd <check_input_run+0x3c3d>
 1070f89:	mov    0x830(%rcx),%r13d
 1070f90:	cmp    %r13d,%r14d
 1070f93:	jae    1070fcd <check_input_run+0x3c3d>
 1070f95:	mov    (%rdi,%r9,4),%r11d
 1070f99:	cmp    %r15d,%r11d
 1070f9c:	jb     1070fcd <check_input_run+0x3c3d>
 1070f9e:	cmp    %r8d,%r11d
 1070fa1:	ja     1070fcd <check_input_run+0x3c3d>
 1070fa3:	mov    0x810(%rcx),%r12
 1070faa:	cmpb   $0x3c,(%r12,%r14,1)
 1070faf:	jne    1070fc8 <check_input_run+0x3c38>
 1070fb1:	mov    0x818(%rcx),%rbp
 1070fb8:	testb  $0x2,0x0(%rbp,%r14,1)
 1070fbe:	je     1070fc8 <check_input_run+0x3c38>
 1070fc0:	dec    %r13
 1070fc3:	cmp    %r14,%r13
 1070fc6:	jne    1070fe4 <check_input_run+0x3c54>
 1070fc8:	mov    0x20(%rsp),%r12
 1070fcd:	mov    %r15d,%r11d
 1070fd0:	xor    %ebp,%ebp
 1070fd2:	add    %ebp,%esi
 1070fd4:	inc    %r9
 1070fd7:	mov    %r11d,%r15d
 1070fda:	cmp    %rax,%r9
 1070fdd:	jne    1070f80 <check_input_run+0x3bf0>
 1070fdf:	jmp    1071527 <check_input_run+0x4197>
 1070fe4:	inc    %rbp
 1070fe7:	lea    0x1(%r12),%r8
 1070fec:	xor    %eax,%eax
 1070fee:	cmpb   $0xfc,(%r8,%r14,1)
 1070ff3:	je     1071025 <check_input_run+0x3c95>
 1070ff5:	testb  $0x2,0x0(%rbp,%r14,1)
 1070ffb:	jne    107100e <check_input_run+0x3c7e>
 1070ffd:	dec    %rax
 1071000:	dec    %r13
 1071003:	inc    %rbp
 1071006:	inc    %r8
 1071009:	cmp    %r13,%r14
 107100c:	jne    1070fee <check_input_run+0x3c5e>
 107100e:	mov    %r15d,%r11d
 1071011:	xor    %ebp,%ebp
 1071013:	mov    0x20(%rsp),%r12
 1071018:	mov    0x90(%rsp),%r8
 1071020:	jmp    1071103 <check_input_run+0x3d73>
 1071025:	mov    0x90(%rsp),%r8
 107102d:	mov    %r14,%r15
 1071030:	sub    %rax,%r15
 1071033:	lea    0x2(%r15),%r10
 1071037:	cmp    %r15d,%r14d
 107103a:	jae    10710fc <check_input_run+0x3d6c>
 1071040:	cmpb   $0x1,0x1(%r12,%r14,1)
 1071046:	jne    10710fc <check_input_run+0x3d6c>
 107104c:	mov    0x270(%rcx),%rax
 1071053:	mov    0x820(%rcx),%r13
 107105a:	mov    0x4(%r13,%r14,4),%r8d
 107105f:	mov    0x10(%rax),%rbp
 1071063:	cmpl   $0x6,0x4(%rbp,%r8,8)
 1071069:	jne    1071011 <check_input_run+0x3c81>
 107106b:	mov    %r13,0x130(%rsp)
 1071073:	mov    0x40(%rax),%r13
 1071077:	mov    0x0(%rbp,%r8,8),%r8d
 107107c:	mov    %rbp,0x1b0(%rsp)
 1071084:	mov    $0x67617270,%ebp
 1071089:	mov    0x0(%r13,%r8,1),%eax
 107108e:	movzwl 0x4(%r13,%r8,1),%r8d
 1071094:	xor    %ebp,%eax
 1071096:	xor    $0x616d,%r8d
 107109d:	or     %eax,%r8d
 10710a0:	jne    1071011 <check_input_run+0x3c81>
 10710a6:	mov    %r13,%rbp
 10710a9:	mov    0x1b0(%rsp),%r13
 10710b1:	mov    0x48(%rsp),%rax
 10710b6:	add    $0x2,%r14d
 10710ba:	cmp    %r15d,%r14d
 10710bd:	ja     107110d <check_input_run+0x3d7d>
 10710bf:	mov    %r14d,%r8d
 10710c2:	cmpb   $0x1,(%r12,%r8,1)
 10710c7:	jne    107110d <check_input_run+0x3d7d>
 10710c9:	mov    0x130(%rsp),%rax
 10710d1:	mov    (%rax,%r8,4),%r8d
 10710d5:	cmpl   $0x4,0x4(%r13,%r8,8)
 10710db:	jne    1071011 <check_input_run+0x3c81>
 10710e1:	mov    0x0(%r13,%r8,8),%eax
 10710e6:	mov    %rbp,%r14
 10710e9:	xor    %ebp,%ebp
 10710eb:	cmpl   $0x6b636170,(%r14,%rax,1)
 10710f3:	sete   %bpl
 10710f7:	jmp    1071013 <check_input_run+0x3c83>
 10710fc:	mov    0x20(%rsp),%r12
 1071101:	xor    %ebp,%ebp
 1071103:	mov    0x48(%rsp),%rax
 1071108:	jmp    1070fd2 <check_input_run+0x3c42>
 107110d:	mov    0x20(%rsp),%r12
 1071112:	mov    0x90(%rsp),%r8
 107111a:	jmp    1070fd0 <check_input_run+0x3c40>
 107111f:	movabs $0x10380420000000,%rcx
 1071129:	jmp    1071153 <check_input_run+0x3dc3>
 107112b:	nopl   0x0(%rax,%rax,1)
 1071130:	mov    0x508(%rsp),%rdi
 1071138:	movzbl (%rdi,%rsi,1),%r8d
 107113d:	mov    0x508(%rsp),%rsi
 1071145:	add    $0xfffffffffffffffc,%rax
 1071149:	mov    %r8b,(%rsi,%rdx,1)
 107114d:	je     1070e71 <check_input_run+0x3ae1>
 1071153:	mov    0x68(%r12),%rdx
 1071158:	mov    0x50(%r12),%rdi
 107115d:	mov    0x60(%r12),%rsi
 1071162:	mov    -0x4(%rdx,%rax,4),%edx
 1071166:	movzbl (%rdi,%rdx,1),%r8d
 107116b:	mov    (%rsi,%rdx,4),%esi
 107116e:	cmp    $0x1c,%r8d
 1071172:	sete   %r9b
 1071176:	cmp    0xf0(%rsp),%esi
 107117d:	setb   %r10b
 1071181:	and    %r9b,%r10b
 1071184:	cmp    $0x1,%r10b
 1071188:	jne    10711a0 <check_input_run+0x3e10>
 107118a:	mov    0x508(%rsp),%rdi
 1071192:	movzbl (%rdi,%rsi,1),%r9d
 1071197:	jmp    10711bb <check_input_run+0x3e2b>
 1071199:	nopl   0x0(%rax)
 10711a0:	add    $0xffffffe2,%r8d
 10711a4:	cmp    $0x34,%r8d
 10711a8:	ja     1071369 <check_input_run+0x3fd9>
 10711ae:	mov    $0x1,%r9b
 10711b1:	bt     %r8,%rcx
 10711b5:	jae    1071310 <check_input_run+0x3f80>
 10711bb:	mov    0x508(%rsp),%rsi
 10711c3:	mov    %r9b,(%rsi,%rdx,1)
 10711c7:	mov    0x68(%r12),%rdx
 10711cc:	mov    0x50(%r12),%rdi
 10711d1:	mov    0x60(%r12),%rsi
 10711d6:	mov    -0x8(%rdx,%rax,4),%edx
 10711da:	movzbl (%rdi,%rdx,1),%r9d
 10711df:	mov    (%rsi,%rdx,4),%esi
 10711e2:	cmp    $0x1c,%r9d
 10711e6:	sete   %r8b
 10711ea:	cmp    0xf0(%rsp),%esi
 10711f1:	setb   %r10b
 10711f5:	test   %r10b,%r8b
 10711f8:	je     1071210 <check_input_run+0x3e80>
 10711fa:	mov    0x508(%rsp),%rdi
 1071202:	movzbl (%rdi,%rsi,1),%r8d
 1071207:	jmp    107122b <check_input_run+0x3e9b>
 1071209:	nopl   0x0(%rax)
 1071210:	add    $0xffffffe2,%r9d
 1071214:	cmp    $0x34,%r9d
 1071218:	ja     1071371 <check_input_run+0x3fe1>
 107121e:	mov    $0x1,%r8b
 1071221:	bt     %r9,%rcx
 1071225:	jae    107132b <check_input_run+0x3f9b>
 107122b:	mov    0x508(%rsp),%rsi
 1071233:	mov    %r8b,(%rsi,%rdx,1)
 1071237:	mov    0x68(%r12),%rdx
 107123c:	mov    0x50(%r12),%rdi
 1071241:	mov    0x60(%r12),%rsi
 1071246:	mov    -0xc(%rdx,%rax,4),%edx
 107124a:	movzbl (%rdi,%rdx,1),%r9d
 107124f:	mov    (%rsi,%rdx,4),%esi
 1071252:	cmp    $0x1c,%r9d
 1071256:	sete   %r8b
 107125a:	cmp    0xf0(%rsp),%esi
 1071261:	setb   %r10b
 1071265:	test   %r10b,%r8b
 1071268:	je     1071280 <check_input_run+0x3ef0>
 107126a:	mov    0x508(%rsp),%rdi
 1071272:	movzbl (%rdi,%rsi,1),%r8d
 1071277:	jmp    107129b <check_input_run+0x3f0b>
 1071279:	nopl   0x0(%rax)
 1071280:	add    $0xffffffe2,%r9d
 1071284:	cmp    $0x34,%r9d
 1071288:	ja     1071379 <check_input_run+0x3fe9>
 107128e:	mov    $0x1,%r8b
 1071291:	bt     %r9,%rcx
 1071295:	jae    1071346 <check_input_run+0x3fb6>
 107129b:	mov    0x508(%rsp),%rsi
 10712a3:	mov    %r8b,(%rsi,%rdx,1)
 10712a7:	mov    0x68(%r12),%rdx
 10712ac:	mov    0x50(%r12),%rdi
 10712b1:	mov    0x60(%r12),%rsi
 10712b6:	mov    -0x10(%rdx,%rax,4),%edx
 10712ba:	movzbl (%rdi,%rdx,1),%r9d
 10712bf:	mov    (%rsi,%rdx,4),%esi
 10712c2:	cmp    $0x1c,%r9d
 10712c6:	sete   %r8b
 10712ca:	cmp    0xf0(%rsp),%esi
 10712d1:	setb   %r10b
 10712d5:	test   %r10b,%r8b
 10712d8:	jne    1071130 <check_input_run+0x3da0>
 10712de:	add    $0xffffffe2,%r9d
 10712e2:	cmp    $0x34,%r9d
 10712e6:	ja     1071361 <check_input_run+0x3fd1>
 10712e8:	mov    $0x1,%r8b
 10712eb:	bt     %r9,%rcx
 10712ef:	jb     107113d <check_input_run+0x3dad>
 10712f5:	test   %r9,%r9
 10712f8:	jne    1071361 <check_input_run+0x3fd1>
 10712fa:	cmp    0xf0(%rsp),%esi
 1071301:	jae    1071361 <check_input_run+0x3fd1>
 1071303:	cmpb   $0x4a,(%rdi,%rsi,1)
 1071307:	sete   %r8b
 107130b:	jmp    107113d <check_input_run+0x3dad>
 1071310:	test   %r8,%r8
 1071313:	jne    1071369 <check_input_run+0x3fd9>
 1071315:	cmp    0xf0(%rsp),%esi
 107131c:	jae    1071369 <check_input_run+0x3fd9>
 107131e:	cmpb   $0x4a,(%rdi,%rsi,1)
 1071322:	sete   %r9b
 1071326:	jmp    10711bb <check_input_run+0x3e2b>
 107132b:	test   %r9,%r9
 107132e:	jne    1071371 <check_input_run+0x3fe1>
 1071330:	cmp    0xf0(%rsp),%esi
 1071337:	jae    1071371 <check_input_run+0x3fe1>
 1071339:	cmpb   $0x4a,(%rdi,%rsi,1)
 107133d:	sete   %r8b
 1071341:	jmp    107122b <check_input_run+0x3e9b>
 1071346:	test   %r9,%r9
 1071349:	jne    1071379 <check_input_run+0x3fe9>
 107134b:	cmp    0xf0(%rsp),%esi
 1071352:	jae    1071379 <check_input_run+0x3fe9>
 1071354:	cmpb   $0x4a,(%rdi,%rsi,1)
 1071358:	sete   %r8b
 107135c:	jmp    107129b <check_input_run+0x3f0b>
 1071361:	xor    %r8d,%r8d
 1071364:	jmp    107113d <check_input_run+0x3dad>
 1071369:	xor    %r9d,%r9d
 107136c:	jmp    10711bb <check_input_run+0x3e2b>
 1071371:	xor    %r8d,%r8d
 1071374:	jmp    107122b <check_input_run+0x3e9b>
 1071379:	xor    %r8d,%r8d
 107137c:	jmp    107129b <check_input_run+0x3f0b>
 1071381:	mov    0x38(%rsp),%rcx
 1071386:	mov    %rdx,%rsi
 1071389:	sub    %rax,%rsi
 107138c:	mov    0x10(%rcx),%rcx
 1071390:	mov    %rcx,%rdi
 1071393:	sub    %rsi,%rdi
 1071396:	jb     106fafc <check_input_run+0x276c>
 107139c:	cmp    %rdi,%rbx
 107139f:	ja     106fafc <check_input_run+0x276c>
 10713a5:	mov    0x38(%rsp),%rdi
 10713aa:	add    %rbx,%rsi
 10713ad:	mov    %rsi,0x8(%rdi)
 10713b1:	mov    %rdx,0x458(%rsp)
 10713b9:	test   %rdx,%rdx
 10713bc:	je     106fb08 <check_input_run+0x2778>
 10713c2:	lea    (%rdx,%rbx,1),%rsi
 10713c6:	lea    0x3f(%rdx,%rbx,1),%rdx
 10713cb:	and    $0xffffffffffffffc0,%rdx
 10713cf:	cmp    %rsi,%rdx
 10713d2:	jb     106fb08 <check_input_run+0x2778>
 10713d8:	mov    %rdx,%rsi
 10713db:	sub    %rax,%rsi
 10713de:	mov    %rcx,%r8
 10713e1:	sub    %rsi,%r8
 10713e4:	jb     106fb08 <check_input_run+0x2778>
 10713ea:	mov    0x270(%r15),%rdi
 10713f1:	mov    0x68(%rdi),%edi
 10713f4:	shl    $0x2,%rdi
 10713f8:	cmp    %r8,%rdi
 10713fb:	ja     106fb08 <check_input_run+0x2778>
 1071401:	mov    0x38(%rsp),%r8
 1071406:	add    %rdi,%rsi
 1071409:	mov    %rsi,0x8(%r8)
 107140d:	mov    %rdx,0x590(%rsp)
 1071415:	test   %rdx,%rdx
 1071418:	je     106fb14 <check_input_run+0x2784>
 107141e:	lea    (%rdx,%rdi,1),%rsi
 1071422:	lea    0x3c(%rdx,%rdi,1),%rdx
 1071427:	mov    $0x1,%dil
 107142a:	mov    %rdi,0xc0(%rsp)
 1071432:	and    $0xffffffffffffffc0,%rdx
 1071436:	cmp    %rsi,%rdx
 1071439:	jb     106fb20 <check_input_run+0x2790>
 107143f:	mov    %rdx,%rsi
 1071442:	sub    %rax,%rsi
 1071445:	xor    %edi,%edi
 1071447:	sub    %rsi,%rcx
 107144a:	jb     106fb22 <check_input_run+0x2792>
 1071450:	mov    0x270(%r15),%rax
 1071457:	mov    0x68(%rax),%eax
 107145a:	add    %rax,%rax
 107145d:	cmp    %rcx,%rax
 1071460:	ja     106fb22 <check_input_run+0x2792>
 1071466:	mov    0x38(%rsp),%rcx
 107146b:	add    %rax,%rsi
 107146e:	mov    %rdx,%rdi
 1071471:	mov    %rsi,0x8(%rcx)
 1071475:	jmp    106fb22 <check_input_run+0x2792>
 107147a:	mov    0x18(%rsp),%rdi
 107147f:	mov    0xd8(%rsp),%rax
 1071487:	mov    %eax,0x234(%rdi)
 107148d:	mov    0x10(%rsp),%rax
 1071492:	mov    (%rax),%rdx
 1071495:	mov    0x8(%rax),%rcx
 1071499:	lea    0x3(%rcx,%rdx,1),%rax
 107149e:	add    %rdx,%rcx
 10714a1:	and    $0xfffffffffffffffc,%rax
 10714a5:	cmp    %rcx,%rax
 10714a8:	jb     106db87 <check_input_run+0x7f7>
 10714ae:	mov    %rax,%rcx
 10714b1:	sub    %rdx,%rcx
 10714b4:	mov    0x10(%rsp),%rdx
 10714b9:	mov    0x10(%rdx),%rdx
 10714bd:	sub    %rcx,%rdx
 10714c0:	jb     106db87 <check_input_run+0x7f7>
 10714c6:	mov    0xd8(%rsp),%esi
 10714cd:	shl    $0x2,%rsi
 10714d1:	lea    (%rsi,%rsi,2),%rsi
 10714d5:	cmp    %rdx,%rsi
 10714d8:	ja     106db87 <check_input_run+0x7f7>
 10714de:	add    %rsi,%rcx
 10714e1:	mov    0x10(%rsp),%rsi
 10714e6:	lea    0x228(%rdi),%r9
 10714ed:	mov    %rcx,0x8(%rsi)
 10714f1:	mov    %rax,0x228(%rdi)
 10714f8:	test   %rax,%rax
 10714fb:	je     106db9e <check_input_run+0x80e>
 1071501:	mov    (%rsi),%rax
 1071504:	mov    0x8(%rsi),%rdx
 1071508:	lea    0x3(%rdx,%rax,1),%rcx
 107150d:	add    %rax,%rdx
 1071510:	and    $0xfffffffffffffffc,%rcx
 1071514:	cmp    %rdx,%rcx
 1071517:	jae    107228b <check_input_run+0x4efb>
 107151d:	mov    0x18(%rsp),%rdi
 1071522:	jmp    106db9e <check_input_run+0x80e>
 1071527:	mov    0x28(%rsp),%r9
 107152c:	test   %esi,%esi
 107152e:	je     1079e0e <check_input_run+0xca7e>
 1071534:	mov    %esi,%edx
 1071536:	lea    (%rdx,%rdx,1),%rax
 107153a:	mov    $0x1,%ecx
 107153f:	nop
 1071540:	mov    %rcx,%rbp
 1071543:	add    %rcx,%rcx
 1071546:	cmp    %rax,%rbp
 1071549:	jbe    1071540 <check_input_run+0x41b0>
 107154b:	mov    0xd0(%rsp),%r8
 1071553:	mov    0x210(%rsp),%rcx
 107155b:	mov    (%r8),%rsi
 107155e:	lea    0x7(%rcx,%rsi,1),%r10
 1071563:	lea    (%rcx,%rsi,1),%rax
 1071567:	mov    $0x1,%cl
 1071569:	and    $0xfffffffffffffff8,%r10
 107156d:	cmp    %rax,%r10
 1071570:	jb     10715c9 <check_input_run+0x4239>
 1071572:	mov    %r10,%rax
 1071575:	sub    %rsi,%rax
 1071578:	mov    0x10(%r8),%rsi
 107157c:	sub    %rax,%rsi
 107157f:	setb   %dil
 1071583:	cmp    $0x18,%rsi
 1071587:	setb   %sil
 107158b:	or     %dil,%sil
 107158e:	jne    10715c9 <check_input_run+0x4239>
 1071590:	add    $0x18,%rax
 1071594:	mov    %rax,0x8(%r8)
 1071598:	test   %r10,%r10
 107159b:	je     10715c9 <check_input_run+0x4239>
 107159d:	mov    0x2c0(%rsp),%rax
 10715a5:	mov    (%rax),%rdi
 10715a8:	mov    0x8(%rax),%rsi
 10715ac:	lea    0x3(%rsi,%rdi,1),%r11
 10715b1:	add    %rdi,%rsi
 10715b4:	and    $0xfffffffffffffffc,%r11
 10715b8:	cmp    %rsi,%r11
 10715bb:	jae    10723a3 <check_input_run+0x5013>
 10715c1:	xor    %r14d,%r14d
 10715c4:	xor    %r11d,%r11d
 10715c7:	jmp    10715d2 <check_input_run+0x4242>
 10715c9:	xor    %r14d,%r14d
 10715cc:	xor    %r11d,%r11d
 10715cf:	xor    %r10d,%r10d
 10715d2:	movq   $0x0,0x1b0(%rsp)
 10715de:	xor    %edi,%edi
 10715e0:	mov    0x2a0(%rsp),%rdx
 10715e8:	test   %rdi,%rdi
 10715eb:	sete   %al
 10715ee:	or     %cl,%al
 10715f0:	or     %al,0x3c5(%rdx)
 10715f6:	test   %al,%al
 10715f8:	jne    1072477 <check_input_run+0x50e7>
 10715fe:	lea    0x0(,%rbp,8),%rdx
 1071606:	lea    0x8(%r10),%rax
 107160a:	xor    %esi,%esi
 107160c:	mov    %r14,0xc0(%rsp)
 1071614:	mov    %r11,0xe8(%rsp)
 107161c:	mov    %r11,(%r10)
 107161f:	vpxor  %xmm0,%xmm0,%xmm0
 1071623:	mov    %r10,0xd0(%rsp)
 107162b:	vmovdqu %xmm0,0x8(%r10)
 1071631:	movq   $0x0,0xc8(%rsp)
 107163d:	mov    %rdi,0x70(%rsp)
 1071642:	mov    %rax,0x130(%rsp)
 107164a:	call   788430 <memset@plt>
 107164f:	dec    %rbp
 1071652:	xor    %r13d,%r13d
 1071655:	xor    %r11d,%r11d
 1071658:	xor    %esi,%esi
 107165a:	mov    0x2a8(%rsp),%rcx
 1071662:	mov    $0x1,%r8b
 1071665:	mov    0x38(%rcx),%rax
 1071669:	mov    (%rax,%r13,4),%r14d
 107166d:	cmp    %r11d,%r14d
 1071670:	jae    1071690 <check_input_run+0x4300>
 1071672:	mov    %esi,%r15d
 1071675:	inc    %r13
 1071678:	cmp    0x48(%rsp),%r13
 107167d:	jae    10721fb <check_input_run+0x4e6b>
 1071683:	mov    %r15d,%esi
 1071686:	test   %r8b,%r8b
 1071689:	jne    107165a <check_input_run+0x42ca>
 107168b:	jmp    10721fb <check_input_run+0x4e6b>
 1071690:	mov    0x2b0(%rsp),%rax
 1071698:	mov    0x830(%rax),%edi
 107169e:	cmp    %edi,%r14d
 10716a1:	jae    1071672 <check_input_run+0x42e2>
 10716a3:	mov    0x40(%rcx),%rdx
 10716a7:	mov    (%rdx,%r13,4),%r15d
 10716ab:	cmp    %esi,%r15d
 10716ae:	jb     1071672 <check_input_run+0x42e2>
 10716b0:	cmp    0x30(%rcx),%r15d
 10716b4:	ja     1071672 <check_input_run+0x42e2>
 10716b6:	mov    0x810(%rax),%rcx
 10716bd:	cmpb   $0x3c,(%rcx,%r14,1)
 10716c2:	jne    1071672 <check_input_run+0x42e2>
 10716c4:	mov    0x818(%rax),%r9
 10716cb:	testb  $0x2,(%r9,%r14,1)
 10716d0:	je     1071672 <check_input_run+0x42e2>
 10716d2:	dec    %rdi
 10716d5:	cmp    %r14,%rdi
 10716d8:	je     1071672 <check_input_run+0x42e2>
 10716da:	inc    %r9
 10716dd:	lea    0x1(%rcx),%r10
 10716e1:	xor    %edx,%edx
 10716e3:	cmpb   $0xfc,(%r10,%r14,1)
 10716e8:	je     1071707 <check_input_run+0x4377>
 10716ea:	testb  $0x2,(%r9,%r14,1)
 10716ef:	jne    1071672 <check_input_run+0x42e2>
 10716f1:	dec    %rdx
 10716f4:	dec    %rdi
 10716f7:	inc    %r9
 10716fa:	inc    %r10
 10716fd:	cmp    %rdi,%r14
 1071700:	jne    10716e3 <check_input_run+0x4353>
 1071702:	jmp    1071672 <check_input_run+0x42e2>
 1071707:	mov    %r14,%rdi
 107170a:	sub    %rdx,%rdi
 107170d:	lea    0x2(%rdi),%r11
 1071711:	cmp    %edi,%r14d
 1071714:	jae    1071675 <check_input_run+0x42e5>
 107171a:	cmpb   $0x1,0x1(%rcx,%r14,1)
 1071720:	jne    1071675 <check_input_run+0x42e5>
 1071726:	mov    0x820(%rax),%r10
 107172d:	mov    0x270(%rax),%r9
 1071734:	mov    %r11,0x100(%rsp)
 107173c:	mov    $0x67617270,%esi
 1071741:	mov    %r10,0xd8(%rsp)
 1071749:	mov    0x4(%r10,%r14,4),%r11d
 107174e:	mov    0x10(%r9),%r10
 1071752:	cmpl   $0x6,0x4(%r10,%r11,8)
 1071758:	jne    10717b5 <check_input_run+0x4425>
 107175a:	mov    0x40(%r9),%r9
 107175e:	mov    (%r10,%r11,8),%r11d
 1071762:	mov    (%r9,%r11,1),%r12d
 1071766:	movzwl 0x4(%r9,%r11,1),%r11d
 107176c:	xor    %esi,%r12d
 107176f:	xor    $0x616d,%r11d
 1071776:	or     %r12d,%r11d
 1071779:	jne    10717b0 <check_input_run+0x4420>
 107177b:	lea    0x2(%r14),%r11d
 107177f:	cmp    %edi,%r11d
 1071782:	ja     10717b0 <check_input_run+0x4420>
 1071784:	mov    %r11d,%r11d
 1071787:	cmpb   $0x1,(%rcx,%r11,1)
 107178c:	jne    10717b0 <check_input_run+0x4420>
 107178e:	mov    0xd8(%rsp),%rsi
 1071796:	mov    (%rsi,%r11,4),%r11d
 107179a:	cmpl   $0x4,0x4(%r10,%r11,8)
 10717a0:	jne    10717b0 <check_input_run+0x4420>
 10717a2:	mov    (%r10,%r11,8),%r11d
 10717a6:	cmpl   $0x6b636170,(%r9,%r11,1)
 10717ae:	je     10717c2 <check_input_run+0x4432>
 10717b0:	mov    0x20(%rsp),%r12
 10717b5:	mov    0x100(%rsp),%r11
 10717bd:	jmp    1071675 <check_input_run+0x42e5>
 10717c2:	mov    0xc8(%rsp),%esi
 10717c9:	lea    0x3(%r14),%r8d
 10717cd:	mov    %rsi,0x150(%rsp)
 10717d5:	cmp    %edi,%r8d
 10717d8:	jbe    1071947 <check_input_run+0x45b7>
 10717de:	mov    0xd0(%rsp),%r12
 10717e6:	mov    0x150(%rsp),%rdi
 10717ee:	mov    %r15d,%edx
 10717f1:	sub    0xc8(%rsp),%edx
 10717f8:	add    0x1b0(%rsp),%rdi
 1071800:	mov    0x14(%r12),%esi
 1071805:	call   788430 <memset@plt>
 107180a:	movzbl 0x14(%r12),%eax
 1071810:	mov    0x10(%r12),%ecx
 1071815:	mov    $0x1,%dl
 1071817:	movl   $0x0,0x88(%rsp)
 1071822:	movl   $0x0,0x60(%rsp)
 107182a:	movl   $0x0,0x68(%rsp)
 1071832:	movq   $0x0,0xb8(%rsp)
 107183e:	mov    $0xffffffff,%esi
 1071843:	mov    %edx,0x110(%rsp)
 107184a:	mov    $0xffffffff,%edx
 107184f:	mov    %rdx,0x50(%rsp)
 1071854:	mov    $0x1,%dl
 1071856:	mov    %edx,0x98(%rsp)
 107185d:	mov    $0xffffffff,%edx
 1071862:	mov    %eax,%edi
 1071864:	mov    0xd0(%rsp),%r11
 107186c:	mov    0x88(%rsp),%r12d
 1071874:	mov    0x8(%r11),%r8d
 1071878:	mov    0x10(%r11),%r9d
 107187c:	lea    0x1(%r8),%r10d
 1071880:	imul   $0x34,%r8,%r8
 1071884:	mov    %r10d,0x8(%r11)
 1071888:	mov    0xe8(%rsp),%r10
 1071890:	mov    0x100(%rsp),%r11
 1071898:	mov    %r13d,(%r10,%r8,1)
 107189c:	mov    %r14d,0x4(%r10,%r8,1)
 10718a1:	mov    0x50(%rsp),%r14
 10718a6:	mov    %r11d,0x8(%r10,%r8,1)
 10718ab:	mov    %r15d,0xc(%r10,%r8,1)
 10718b0:	movl   $0xffffffff,0x10(%r10,%r8,1)
 10718b9:	mov    %r14d,0x14(%r10,%r8,1)
 10718be:	mov    %r12d,0x18(%r10,%r8,1)
 10718c3:	mov    %esi,0x1c(%r10,%r8,1)
 10718c8:	mov    %edx,0x20(%r10,%r8,1)
 10718cd:	mov    %ecx,0x24(%r10,%r8,1)
 10718d2:	mov    0xb8(%rsp),%rcx
 10718da:	mov    %r9d,0x28(%r10,%r8,1)
 10718df:	mov    0x20(%rsp),%r12
 10718e4:	mov    %cl,0x2c(%r10,%r8,1)
 10718e9:	mov    0x68(%rsp),%ecx
 10718ed:	mov    %cl,0x2d(%r10,%r8,1)
 10718f2:	mov    %al,0x2e(%r10,%r8,1)
 10718f7:	mov    0x98(%rsp),%eax
 10718fe:	mov    %dil,0x2f(%r10,%r8,1)
 1071903:	mov    %al,0x30(%r10,%r8,1)
 1071908:	mov    0x110(%rsp),%eax
 107190f:	mov    %al,0x31(%r10,%r8,1)
 1071914:	mov    0x60(%rsp),%eax
 1071918:	mov    %al,0x32(%r10,%r8,1)
 107191d:	movb   $0x0,0x33(%r10,%r8,1)
 1071923:	mov    0x2a0(%rsp),%rax
 107192b:	movzbl 0x3c5(%rax),%r8d
 1071933:	mov    %r15d,%eax
 1071936:	mov    %rax,0xc8(%rsp)
 107193e:	xor    $0x1,%r8b
 1071942:	jmp    1071675 <check_input_run+0x42e5>
 1071947:	mov    %r8d,%r8d
 107194a:	xor    %r11d,%r11d
 107194d:	cmpb   $0xf,(%rcx,%r8,1)
 1071952:	sete   %r12b
 1071956:	jne    10717de <check_input_run+0x444e>
 107195c:	mov    %r12b,%r11b
 107195f:	add    %r11,%r8
 1071962:	cmp    %edi,%r8d
 1071965:	ja     10717de <check_input_run+0x444e>
 107196b:	movzbl (%rcx,%r8,1),%r11d
 1071970:	movl   $0x0,0x88(%rsp)
 107197b:	cmp    $0xf,%r11d
 107197f:	jg     1071992 <check_input_run+0x4602>
 1071981:	cmp    $0x1,%r11d
 1071985:	je     10719d4 <check_input_run+0x4644>
 1071987:	cmp    $0x2,%r11d
 107198b:	je     10719a5 <check_input_run+0x4615>
 107198d:	jmp    10717de <check_input_run+0x444e>
 1071992:	cmp    $0x10,%r11d
 1071996:	je     1071a14 <check_input_run+0x4684>
 1071998:	cmp    $0xfd,%r11d
 107199f:	jne    10717de <check_input_run+0x444e>
 10719a5:	mov    %r8d,%esi
 10719a8:	mov    %rsi,0x50(%rsp)
 10719ad:	mov    $0x1,%sil
 10719b0:	inc    %r8d
 10719b3:	mov    $0x1,%r9b
 10719b6:	mov    %esi,0x60(%rsp)
 10719ba:	mov    $0x2,%sil
 10719bd:	mov    %rsi,0xb8(%rsp)
 10719c5:	mov    $0x1,%sil
 10719c8:	mov    %esi,0x110(%rsp)
 10719cf:	jmp    1071bb5 <check_input_run+0x4825>
 10719d4:	mov    0xd8(%rsp),%rsi
 10719dc:	mov    (%rsi,%r8,4),%r11d
 10719e0:	mov    0x4(%r10,%r11,8),%r12d
 10719e5:	cmp    $0x3,%r12d
 10719e9:	je     1071a3e <check_input_run+0x46ae>
 10719eb:	cmp    $0x4,%r12d
 10719ef:	jne    1071a5e <check_input_run+0x46ce>
 10719f1:	mov    (%r10,%r11,8),%r10d
 10719f5:	cmpl   $0x68737570,(%r9,%r10,1)
 10719fd:	je     1071a6c <check_input_run+0x46dc>
 10719ff:	xor    %r11d,%r11d
 1071a02:	cmpl   $0x776f6873,(%r9,%r10,1)
 1071a0a:	sete   %r11b
 1071a0e:	lea    (%r11,%r11,4),%esi
 1071a12:	jmp    1071a74 <check_input_run+0x46e4>
 1071a14:	mov    $0x1,%sil
 1071a17:	movl   $0x0,0x60(%rsp)
 1071a1f:	xor    %r9d,%r9d
 1071a22:	mov    %rsi,0xb8(%rsp)
 1071a2a:	mov    $0x1,%sil
 1071a2d:	mov    %esi,0x110(%rsp)
 1071a34:	mov    $0xffffffff,%esi
 1071a39:	jmp    1071bb0 <check_input_run+0x4820>
 1071a3e:	mov    (%r10,%r11,8),%r10d
 1071a42:	movzwl (%r9,%r10,1),%r11d
 1071a47:	movzbl 0x2(%r9,%r10,1),%r9d
 1071a4d:	xor    $0x6f70,%r11d
 1071a54:	xor    $0x70,%r9d
 1071a58:	or     %r11w,%r9w
 1071a5c:	je     1071a71 <check_input_run+0x46e1>
 1071a5e:	movq   $0x0,0xb8(%rsp)
 1071a6a:	jmp    1071a7c <check_input_run+0x46ec>
 1071a6c:	mov    $0x3,%sil
 1071a6f:	jmp    1071a74 <check_input_run+0x46e4>
 1071a71:	mov    $0x4,%sil
 1071a74:	mov    %rsi,0xb8(%rsp)
 1071a7c:	cmpb   $0x0,0xb8(%rsp)
 1071a84:	mov    %r8d,%r9d
 1071a87:	lea    0x1(%r9),%r10
 1071a8b:	movl   $0x0,0x60(%rsp)
 1071a93:	setne  %sil
 1071a97:	mov    %esi,0x110(%rsp)
 1071a9e:	cmp    %edi,%r8d
 1071aa1:	jae    1071b9a <check_input_run+0x480a>
 1071aa7:	mov    0xb8(%rsp),%rsi
 1071aaf:	lea    -0x3(%rsi),%r11d
 1071ab3:	cmp    $0x1,%r11b
 1071ab7:	ja     1071b9a <check_input_run+0x480a>
 1071abd:	cmpb   $0x3b,(%rcx,%r10,1)
 1071ac2:	movl   $0x0,0x60(%rsp)
 1071aca:	jne    1071b9a <check_input_run+0x480a>
 1071ad0:	lea    0x2(%r9),%r10
 1071ad4:	movl   $0x0,0x88(%rsp)
 1071adf:	mov    %r10,0x50(%rsp)
 1071ae4:	cmp    %edi,%r10d
 1071ae7:	ja     1071b41 <check_input_run+0x47b1>
 1071ae9:	lea    0x2(%r9),%rsi
 1071aed:	cmpb   $0x1,(%rcx,%rsi,1)
 1071af1:	jne    1071b41 <check_input_run+0x47b1>
 1071af3:	mov    0xd8(%rsp),%rsi
 1071afb:	mov    %r9,%r10
 1071afe:	add    $0x3,%r10
 1071b02:	movl   $0x0,0x60(%rsp)
 1071b0a:	mov    0x8(%rsi,%r9,4),%esi
 1071b0f:	xor    %r9d,%r9d
 1071b12:	mov    %esi,0x88(%rsp)
 1071b19:	cmp    %edi,%r10d
 1071b1c:	ja     10721b9 <check_input_run+0x4e29>
 1071b22:	xor    %r9d,%r9d
 1071b25:	cmpb   $0x3b,(%rcx,%r10,1)
 1071b2a:	movl   $0x0,0x60(%rsp)
 1071b32:	jne    10721b9 <check_input_run+0x4e29>
 1071b38:	lea    0x4(%r8),%esi
 1071b3c:	mov    %rsi,0x50(%rsp)
 1071b41:	cmp    %edi,0x50(%rsp)
 1071b45:	ja     1071da4 <check_input_run+0x4a14>
 1071b4b:	mov    0x50(%rsp),%r8d
 1071b50:	movzbl (%rcx,%r8,1),%esi
 1071b55:	mov    %esi,0x98(%rsp)
 1071b5c:	cmp    $0x1,%esi
 1071b5f:	je     10721c3 <check_input_run+0x4e33>
 1071b65:	cmpl   $0xfd,0x98(%rsp)
 1071b70:	je     1071b80 <check_input_run+0x47f0>
 1071b72:	cmpl   $0x2,0x98(%rsp)
 1071b7a:	jne    1071da4 <check_input_run+0x4a14>
 1071b80:	mov    0x50(%rsp),%rsi
 1071b85:	mov    0x110(%rsp),%r9d
 1071b8d:	lea    0x1(%rsi),%r8d
 1071b91:	mov    $0x1,%sil
 1071b94:	mov    %esi,0x60(%rsp)
 1071b98:	jmp    1071bb5 <check_input_run+0x4825>
 1071b9a:	mov    $0xffffffff,%esi
 1071b9f:	movl   $0x0,0x88(%rsp)
 1071baa:	xor    %r9d,%r9d
 1071bad:	mov    %r10d,%r8d
 1071bb0:	mov    %rsi,0x50(%rsp)
 1071bb5:	mov    $0x1,%sil
 1071bb8:	movl   $0x0,0x118(%rsp)
 1071bc3:	movl   $0x0,0x68(%rsp)
 1071bcb:	mov    %esi,0x98(%rsp)
 1071bd2:	cmp    %edi,%r8d
 1071bd5:	ja     1071dfa <check_input_run+0x4a6a>
 1071bdb:	mov    %r8d,%edi
 1071bde:	neg    %edi
 1071be0:	movl   $0x0,0x118(%rsp)
 1071beb:	movl   $0x0,0x68(%rsp)
 1071bf3:	add    %r14,%rdi
 1071bf6:	cmp    %edx,%edi
 1071bf8:	jne    1071dfa <check_input_run+0x4a6a>
 1071bfe:	mov    %r8d,%edx
 1071c01:	cmpb   $0x10,(%rcx,%rdx,1)
 1071c05:	jne    1071dfa <check_input_run+0x4a6a>
 1071c0b:	mov    $0x1,%dl
 1071c0d:	mov    %edx,0x118(%rsp)
 1071c14:	test   %r9b,%r9b
 1071c17:	je     1071de7 <check_input_run+0x4a57>
 1071c1d:	mov    0x50(%rsp),%edx
 1071c21:	movzbl (%rcx,%rdx,1),%r9d
 1071c26:	cmp    $0xfd,%r9b
 1071c2a:	jne    1071c3e <check_input_run+0x48ae>
 1071c2c:	mov    0xd8(%rsp),%rax
 1071c34:	xor    %ecx,%ecx
 1071c36:	mov    (%rax,%rdx,4),%eax
 1071c39:	jmp    1071d46 <check_input_run+0x49b6>
 1071c3e:	mov    0x828(%rax),%rax
 1071c45:	mov    0x2c8(%rsp),%rdi
 1071c4d:	mov    (%rax,%rdx,4),%ecx
 1071c50:	mov    0xd8(%rsp),%rax
 1071c58:	mov    0x8(%rdi),%r12
 1071c5c:	mov    (%rax,%rdx,4),%edx
 1071c5f:	mov    %edx,%eax
 1071c61:	sub    %ecx,%eax
 1071c63:	jb     1071c8a <check_input_run+0x48fa>
 1071c65:	mov    0x10(%rdi),%rsi
 1071c69:	sub    %r12,%rsi
 1071c6c:	jb     1071c8a <check_input_run+0x48fa>
 1071c6e:	mov    $0x0,%r8d
 1071c74:	cmp    %rax,%rsi
 1071c77:	jbe    1071c8d <check_input_run+0x48fd>
 1071c79:	mov    (%rdi),%r8
 1071c7c:	lea    0x1(%r12,%rax,1),%rax
 1071c81:	mov    %rax,0x8(%rdi)
 1071c85:	add    %r12,%r8
 1071c88:	jmp    1071c8d <check_input_run+0x48fd>
 1071c8a:	xor    %r8d,%r8d
 1071c8d:	mov    0x2a0(%rsp),%rdi
 1071c95:	cmp    %ecx,%edx
 1071c97:	setae  %al
 1071c9a:	test   %r8,%r8
 1071c9d:	sete   %sil
 1071ca1:	and    %al,%sil
 1071ca4:	or     %sil,0x3c5(%rdi)
 1071cab:	test   %r8,%r8
 1071cae:	je     1071dd2 <check_input_run+0x4a42>
 1071cb4:	mov    0x2b0(%rsp),%rdi
 1071cbc:	movzbl %r9b,%esi
 1071cc0:	lea    0x700(%rsp),%r9
 1071cc8:	movq   $0x0,0x700(%rsp)
 1071cd4:	call   1048af0 <pp_spelling>
 1071cd9:	mov    0x700(%rsp),%rsi
 1071ce1:	mov    0x2c8(%rsp),%rcx
 1071ce9:	lea    0x780(%rsp),%rdi
 1071cf1:	mov    %eax,%edx
 1071cf3:	call   108f9b0 <check_literal_number>
 1071cf8:	movzbl 0x7a3(%rsp),%edx
 1071d00:	mov    0x2a0(%rsp),%rdi
 1071d08:	movzbl 0x7a1(%rsp),%ecx
 1071d10:	mov    0x788(%rsp),%rax
 1071d18:	movzbl 0x7a2(%rsp),%esi
 1071d20:	or     0x7a0(%rsp),%cl
 1071d27:	and    $0x1,%dl
 1071d2a:	or     %dl,0x3c5(%rdi)
 1071d30:	mov    0x2c8(%rsp),%rdx
 1071d38:	mov    %r12,0x8(%rdx)
 1071d3c:	test   $0x1,%sil
 1071d40:	je     1072160 <check_input_run+0x4dd0>
 1071d46:	mov    $0x2,%dl
 1071d48:	movl   $0x0,0x68(%rsp)
 1071d50:	mov    %edx,0x98(%rsp)
 1071d57:	test   $0x1,%cl
 1071d5a:	jne    1071d97 <check_input_run+0x4a07>
 1071d5c:	cmp    $0x10,%rax
 1071d60:	ja     1071d97 <check_input_run+0x4a07>
 1071d62:	popcnt %rax,%rcx
 1071d67:	cmp    $0x1,%ecx
 1071d6a:	ja     1071d97 <check_input_run+0x4a07>
 1071d6c:	test   %rax,%rax
 1071d6f:	je     1071de7 <check_input_run+0x4a57>
 1071d71:	cmp    $0x1,%rax
 1071d75:	jne    1072181 <check_input_run+0x4df1>
 1071d7b:	mov    $0x1,%al
 1071d7d:	movl   $0x0,0x98(%rsp)
 1071d88:	mov    %eax,0x68(%rsp)
 1071d8c:	mov    $0x1,%al
 1071d8e:	mov    %eax,0x118(%rsp)
 1071d95:	jmp    1071dfa <check_input_run+0x4a6a>
 1071d97:	movl   $0x0,0x118(%rsp)
 1071da2:	jmp    1071dfa <check_input_run+0x4a6a>
 1071da4:	mov    $0xffffffff,%eax
 1071da9:	movl   $0x0,0x68(%rsp)
 1071db1:	movl   $0x0,0x118(%rsp)
 1071dbc:	mov    %rax,0x50(%rsp)
 1071dc1:	mov    $0x1,%al
 1071dc3:	mov    %eax,0x98(%rsp)
 1071dca:	mov    $0x1,%al
 1071dcc:	mov    %eax,0x60(%rsp)
 1071dd0:	jmp    1071dfa <check_input_run+0x4a6a>
 1071dd2:	mov    0x2c8(%rsp),%rax
 1071dda:	mov    %r12,0x8(%rax)
 1071dde:	mov    $0x3,%al
 1071de0:	mov    %eax,0x110(%rsp)
 1071de7:	movl   $0x0,0x68(%rsp)
 1071def:	movl   $0x0,0x98(%rsp)
 1071dfa:	mov    0xd0(%rsp),%r12
 1071e02:	mov    0x150(%rsp),%rdi
 1071e0a:	mov    %r15d,%edx
 1071e0d:	sub    0xc8(%rsp),%edx
 1071e14:	add    0x1b0(%rsp),%rdi
 1071e1c:	mov    0x14(%r12),%esi
 1071e21:	call   788430 <memset@plt>
 1071e26:	mov    0x10(%r12),%ecx
 1071e2b:	movzbl 0x14(%r12),%eax
 1071e31:	cmpb   $0x0,0x118(%rsp)
 1071e39:	mov    $0xffffffff,%edx
 1071e3e:	je     1071e94 <check_input_run+0x4b04>
 1071e40:	cmpb   $0x1,0x110(%rsp)
 1071e48:	jne    1071e94 <check_input_run+0x4b04>
 1071e4a:	movzbl 0xb8(%rsp),%esi
 1071e52:	movl   $0x0,0x98(%rsp)
 1071e5d:	dec    %esi
 1071e5f:	cmp    $0x4,%esi
 1071e62:	ja     1071fc3 <check_input_run+0x4c33>
 1071e68:	lea    -0xbd4827(%rip),%rdi        # 49d648 <cbuiltin_test_generated.edges+0x3808>
 1071e6f:	movslq (%rdi,%rsi,4),%rsi
 1071e73:	add    %rdi,%rsi
 1071e76:	jmp    *%rsi
 1071e78:	mov    0xd0(%rsp),%rsi
 1071e80:	movl   $0x0,0x98(%rsp)
 1071e8b:	movb   $0x0,0x14(%rsi)
 1071e8f:	jmp    1071fc3 <check_input_run+0x4c33>
 1071e94:	mov    %eax,%edi
 1071e96:	mov    $0xffffffff,%esi
 1071e9b:	jmp    1071864 <check_input_run+0x44d4>
 1071ea0:	mov    0xd0(%rsp),%rsi
 1071ea8:	lea    0x1(%rcx),%edx
 1071eab:	cmpl   $0x0,0x88(%rsp)
 1071eb3:	mov    0x8(%rsi),%edi
 1071eb6:	mov    %edx,0x10(%rsi)
 1071eb9:	mov    0xc0(%rsp),%rdx
 1071ec1:	mov    $0xffffffff,%esi
 1071ec6:	mov    %edi,(%rdx,%rcx,4)
 1071ec9:	mov    $0xffffffff,%edx
 1071ece:	je     1071ffc <check_input_run+0x4c6c>
 1071ed4:	mov    0x88(%rsp),%edx
 1071edb:	movabs $0x9e3779b97f4a7c15,%r8
 1071ee5:	imul   %r8,%rdx
 1071ee9:	mov    0x70(%rsp),%r10
 1071eee:	mov    %rdx,%r8
 1071ef1:	and    %rbp,%r8
 1071ef4:	mov    (%r10,%r8,8),%r9d
 1071ef8:	test   %r9d,%r9d
 1071efb:	je     1071f0b <check_input_run+0x4b7b>
 1071efd:	lea    0x1(%r8),%rdx
 1071f01:	cmp    0x88(%rsp),%r9d
 1071f09:	jne    1071ee9 <check_input_run+0x4b59>
 1071f0b:	test   %r9d,%r9d
 1071f0e:	je     1071fca <check_input_run+0x4c3a>
 1071f14:	mov    0x70(%rsp),%rdx
 1071f19:	mov    0x4(%rdx,%r8,8),%edx
 1071f1e:	jmp    1071ff2 <check_input_run+0x4c62>
 1071f23:	cmpl   $0x0,0x88(%rsp)
 1071f2b:	setne  %sil
 1071f2f:	and    0x60(%rsp),%sil
 1071f34:	shl    $0x3,%sil
 1071f38:	mov    %esi,0x98(%rsp)
 1071f3f:	test   %ecx,%ecx
 1071f41:	je     1071fb1 <check_input_run+0x4c21>
 1071f43:	cmpl   $0x0,0x88(%rsp)
 1071f4b:	je     1072077 <check_input_run+0x4ce7>
 1071f51:	mov    0x88(%rsp),%r8d
 1071f59:	movabs $0x9e3779b97f4a7c15,%rsi
 1071f63:	imul   %rsi,%r8
 1071f67:	mov    0x70(%rsp),%rdi
 1071f6c:	mov    %r8,%rsi
 1071f6f:	and    %rbp,%rsi
 1071f72:	mov    (%rdi,%rsi,8),%edi
 1071f75:	test   %edi,%edi
 1071f77:	je     1071f86 <check_input_run+0x4bf6>
 1071f79:	lea    0x1(%rsi),%r8
 1071f7d:	cmp    0x88(%rsp),%edi
 1071f84:	jne    1071f67 <check_input_run+0x4bd7>
 1071f86:	mov    0x70(%rsp),%r8
 1071f8b:	lea    (%r8,%rsi,8),%rsi
 1071f8f:	test   %edi,%edi
 1071f91:	jne    1071fa3 <check_input_run+0x4c13>
 1071f93:	mov    0x88(%rsp),%edi
 1071f9a:	mov    %edi,(%rsi)
 1071f9c:	movl   $0xffffffff,0x4(%rsi)
 1071fa3:	add    $0x4,%rsi
 1071fa7:	jmp    1072086 <check_input_run+0x4cf6>
 1071fac:	mov    $0x10,%sil
 1071faf:	jmp    1071fbc <check_input_run+0x4c2c>
 1071fb1:	mov    0x98(%rsp),%esi
 1071fb8:	or     $0x4,%sil
 1071fbc:	mov    %esi,0x98(%rsp)
 1071fc3:	mov    $0xffffffff,%esi
 1071fc8:	jmp    1072022 <check_input_run+0x4c92>
 1071fca:	mov    0x70(%rsp),%rdx
 1071fcf:	mov    0x88(%rsp),%edi
 1071fd6:	mov    %edi,(%rdx,%r8,8)
 1071fda:	movl   $0xffffffff,0x4(%rdx,%r8,8)
 1071fe3:	mov    0x130(%rsp),%rdx
 1071feb:	mov    (%rdx),%edi
 1071fed:	mov    $0xffffffff,%edx
 1071ff2:	mov    0x70(%rsp),%r9
 1071ff7:	mov    %edi,0x4(%r9,%r8,8)
 1071ffc:	mov    0xd0(%rsp),%r9
 1072004:	movl   $0x0,0x98(%rsp)
 107200f:	mov    0xc(%r9),%edi
 1072013:	mov    0x10(%r9),%r8d
 1072017:	cmp    %edi,%r8d
 107201a:	cmova  %r8d,%edi
 107201e:	mov    %edi,0xc(%r9)
 1072022:	testb  $0x1,0x60(%rsp)
 1072027:	je     1072053 <check_input_run+0x4cc3>
 1072029:	mov    0xd0(%rsp),%rdi
 1072031:	mov    0x68(%rsp),%r8d
 1072036:	mov    %r8b,0x14(%rdi)
 107203a:	mov    $0x1,%dil
 107203d:	mov    %edi,0x110(%rsp)
 1072044:	mov    $0x1,%dil
 1072047:	mov    %edi,0x60(%rsp)
 107204b:	mov    %r8d,%edi
 107204e:	jmp    1071864 <check_input_run+0x44d4>
 1072053:	mov    0xd0(%rsp),%rdi
 107205b:	mov    $0x1,%r8b
 107205e:	movl   $0x0,0x60(%rsp)
 1072066:	mov    %r8d,0x110(%rsp)
 107206e:	movzbl 0x14(%rdi),%edi
 1072072:	jmp    1071864 <check_input_run+0x44d4>
 1072077:	mov    0xc0(%rsp),%rdi
 107207f:	lea    -0x1(%rcx),%esi
 1072082:	lea    (%rdi,%rsi,4),%rsi
 1072086:	mov    (%rsi),%esi
 1072088:	mov    $0xffffffff,%edi
 107208d:	cmp    %rdi,%rsi
 1072090:	je     1071fc3 <check_input_run+0x4c33>
 1072096:	mov    0xe8(%rsp),%r9
 107209e:	imul   $0x34,%rsi,%r8
 10720a2:	mov    0xd0(%rsp),%r10
 10720aa:	mov    0x24(%r9,%r8,1),%edi
 10720af:	movzbl 0x2e(%r9,%r8,1),%r8d
 10720b5:	mov    %r8b,0x14(%r10)
 10720b9:	mov    0x10(%r10),%r9d
 10720bd:	jmp    10720d5 <check_input_run+0x4d45>
 10720bf:	mov    0x70(%rsp),%r8
 10720c4:	mov    %r9d,0x4(%r8,%r10,8)
 10720c9:	mov    0xd0(%rsp),%r9
 10720d1:	mov    0x10(%r9),%r9d
 10720d5:	cmp    %edi,%r9d
 10720d8:	jbe    1072022 <check_input_run+0x4c92>
 10720de:	mov    0xd0(%rsp),%r8
 10720e6:	mov    0xc0(%rsp),%r10
 10720ee:	dec    %r9d
 10720f1:	mov    0xe8(%rsp),%r11
 10720f9:	mov    %r9d,0x10(%r8)
 10720fd:	mov    (%r10,%r9,4),%r8d
 1072101:	imul   $0x34,%r8,%r10
 1072105:	mov    0x18(%r11,%r10,1),%r8d
 107210a:	test   %r8,%r8
 107210d:	je     10720d5 <check_input_run+0x4d45>
 107210f:	add    0xe8(%rsp),%r10
 1072117:	mov    %r8,%r12
 107211a:	mov    0x20(%r10),%r9d
 107211e:	movabs $0x9e3779b97f4a7c15,%r10
 1072128:	imul   %r10,%r12
 107212c:	mov    0x70(%rsp),%r11
 1072131:	mov    %r12,%r10
 1072134:	and    %rbp,%r10
 1072137:	mov    (%r11,%r10,8),%r11d
 107213b:	test   %r11d,%r11d
 107213e:	je     1072149 <check_input_run+0x4db9>
 1072140:	lea    0x1(%r10),%r12
 1072144:	cmp    %r8d,%r11d
 1072147:	jne    107212c <check_input_run+0x4d9c>
 1072149:	test   %r11d,%r11d
 107214c:	jne    10720bf <check_input_run+0x4d2f>
 1072152:	mov    0x70(%rsp),%r11
 1072157:	mov    %r8d,(%r11,%r10,8)
 107215b:	jmp    10720bf <check_input_run+0x4d2f>
 1072160:	mov    $0x3,%al
 1072162:	movl   $0x0,0x68(%rsp)
 107216a:	movl   $0x0,0x98(%rsp)
 1072175:	mov    %eax,0x110(%rsp)
 107217c:	jmp    1071dfa <check_input_run+0x4a6a>
 1072181:	mov    $0x1,%cl
 1072183:	mov    %ecx,0x118(%rsp)
 107218a:	mov    $0x1,%cl
 107218c:	mov    %ecx,0x68(%rsp)
 1072190:	mov    %rax,%rcx
 1072193:	mov    0x68(%rsp),%edx
 1072197:	shr    $1,%rcx
 107219a:	movl   $0x0,0x98(%rsp)
 10721a5:	inc    %dl
 10721a7:	mov    %edx,0x68(%rsp)
 10721ab:	cmp    $0x3,%rax
 10721af:	mov    %rcx,%rax
 10721b2:	ja     1072193 <check_input_run+0x4e03>
 10721b4:	jmp    1071dfa <check_input_run+0x4a6a>
 10721b9:	mov    $0xffffffff,%esi
 10721be:	jmp    1071bad <check_input_run+0x481d>
 10721c3:	mov    0x98(%rsp),%ecx
 10721ca:	mov    $0xffffffff,%eax
 10721cf:	movl   $0x0,0x68(%rsp)
 10721d7:	movl   $0x0,0x118(%rsp)
 10721e2:	movl   $0x0,0x110(%rsp)
 10721ed:	mov    %rax,0x50(%rsp)
 10721f2:	mov    %ecx,0x60(%rsp)
 10721f6:	jmp    1071dfa <check_input_run+0x4a6a>
 10721fb:	mov    0x28(%rsp),%r9
 1072200:	mov    0xd0(%rsp),%rcx
 1072208:	test   %r8b,%r8b
 107220b:	mov    0x90(%rsp),%r8
 1072213:	je     1072477 <check_input_run+0x50e7>
 1072219:	mov    0xc8(%rsp),%eax
 1072220:	mov    0x1b0(%rsp),%rdx
 1072228:	mov    0x14(%rcx),%esi
 107222b:	sub    %rax,%r8
 107222e:	lea    (%rdx,%rax,1),%rdi
 1072232:	inc    %r8
 1072235:	mov    %r8,%rdx
 1072238:	call   788430 <memset@plt>
 107223d:	mov    0x2c8(%rsp),%rcx
 1072245:	mov    0x2a8(%rsp),%r14
 107224d:	mov    $0x1,%al
 107224f:	mov    (%rcx),%rdi
 1072252:	mov    0x8(%rcx),%rsi
 1072256:	mov    0x30(%r14),%ebp
 107225a:	lea    0x3(%rsi,%rdi,1),%r15
 107225f:	lea    0x4(,%rbp,4),%rdx
 1072267:	lea    0x1(%rbp),%r8
 107226b:	add    %rdi,%rsi
 107226e:	and    $0xfffffffffffffffc,%r15
 1072272:	cmp    %rsi,%r15
 1072275:	jae    1072327 <check_input_run+0x4f97>
 107227b:	mov    0x28(%rsp),%r9
 1072280:	xor    %r15d,%r15d
 1072283:	xor    %r13d,%r13d
 1072286:	jmp    1072459 <check_input_run+0x50c9>
 107228b:	mov    0x10(%rsi),%rsi
 107228f:	mov    %rcx,%rdx
 1072292:	sub    %rax,%rdx
 1072295:	sub    %rdx,%rsi
 1072298:	jb     1072399 <check_input_run+0x5009>
 107229e:	mov    0x78(%rsp),%rax
 10722a3:	lea    0x4(,%rax,4),%rax
 10722ab:	cmp    %rsi,%rax
 10722ae:	ja     1072399 <check_input_run+0x5009>
 10722b4:	mov    0x18(%rsp),%rsi
 10722b9:	mov    0x10(%rsp),%r8
 10722be:	add    %rax,%rdx
 10722c1:	lea    0x238(%rsi),%rdi
 10722c8:	mov    %rdx,0x8(%r8)
 10722cc:	mov    %rcx,0x238(%rsi)
 10722d3:	mov    %rdi,0x68(%rsp)
 10722d8:	test   %rcx,%rcx
 10722db:	je     10722f9 <check_input_run+0x4f69>
 10722dd:	mov    (%r8),%rsi
 10722e0:	mov    0x8(%r8),%rdx
 10722e4:	lea    0x3(%rdx,%rsi,1),%rcx
 10722e9:	add    %rsi,%rdx
 10722ec:	and    $0xfffffffffffffffc,%rcx
 10722f0:	cmp    %rdx,%rcx
 10722f3:	jae    1077e3e <check_input_run+0xaaae>
 10722f9:	mov    0x18(%rsp),%rdi
 10722fe:	mov    %r8,%rsi
 1072301:	movq   $0x0,0x240(%rdi)
 107230c:	movq   $0x0,0x248(%rdi)
 1072317:	movq   $0x0,0x260(%rdi)
 1072322:	jmp    106dbd6 <check_input_run+0x846>
 1072327:	mov    %r15,%rsi
 107232a:	sub    %rdi,%rsi
 107232d:	mov    0x10(%rcx),%rdi
 1072331:	mov    0x28(%rsp),%r9
 1072336:	xor    %r13d,%r13d
 1072339:	sub    %rsi,%rdi
 107233c:	jb     1072456 <check_input_run+0x50c6>
 1072342:	cmp    %rdi,%rdx
 1072345:	ja     1072456 <check_input_run+0x50c6>
 107234b:	add    %rdx,%rsi
 107234e:	mov    %rsi,0x8(%rcx)
 1072352:	test   %r15,%r15
 1072355:	je     1072280 <check_input_run+0x4ef0>
 107235b:	mov    0x2c8(%rsp),%rcx
 1072363:	xor    %r13d,%r13d
 1072366:	mov    $0x0,%eax
 107236b:	mov    0x8(%rcx),%rsi
 107236f:	mov    0x10(%rcx),%rdi
 1072373:	sub    %rsi,%rdi
 1072376:	jb     1072459 <check_input_run+0x50c9>
 107237c:	cmp    %rbp,%rdi
 107237f:	jbe    1072459 <check_input_run+0x50c9>
 1072385:	mov    (%rcx),%r13
 1072388:	xor    %eax,%eax
 107238a:	add    %rsi,%r13
 107238d:	add    %r8,%rsi
 1072390:	mov    %rsi,0x8(%rcx)
 1072394:	jmp    1072459 <check_input_run+0x50c9>
 1072399:	mov    0x18(%rsp),%rdi
 107239e:	jmp    106db99 <check_input_run+0x809>
 10723a3:	mov    %r11,%rsi
 10723a6:	sub    %rdi,%rsi
 10723a9:	mov    0x10(%rax),%rdi
 10723ad:	xor    %r14d,%r14d
 10723b0:	sub    %rsi,%rdi
 10723b3:	jb     1077c01 <check_input_run+0xa871>
 10723b9:	imul   $0x34,%rdx,%r8
 10723bd:	cmp    %rdi,%r8
 10723c0:	ja     1077c01 <check_input_run+0xa871>
 10723c6:	add    %r8,%rsi
 10723c9:	mov    %rsi,0x8(%rax)
 10723cd:	test   %r11,%r11
 10723d0:	je     10715c1 <check_input_run+0x4231>
 10723d6:	mov    0x2c0(%rsp),%rax
 10723de:	xor    %r14d,%r14d
 10723e1:	mov    0x8(%rax),%r8
 10723e5:	mov    0x10(%rax),%rsi
 10723e9:	sub    %r8,%rsi
 10723ec:	jb     10715d2 <check_input_run+0x4242>
 10723f2:	mov    %r8,%rdi
 10723f5:	mov    0x90(%rsp),%r8
 10723fd:	cmp    %r8,%rsi
 1072400:	jbe    10715d2 <check_input_run+0x4242>
 1072406:	lea    0x1(%r8,%rdi,1),%rsi
 107240b:	add    (%rax),%rdi
 107240e:	mov    %rsi,0x8(%rax)
 1072412:	mov    %rdi,0x1b0(%rsp)
 107241a:	je     1079721 <check_input_run+0xc391>
 1072420:	mov    0x2c8(%rsp),%rsi
 1072428:	mov    (%rsi),%r8
 107242b:	mov    0x8(%rsi),%rdi
 107242f:	lea    0x3(%rdi,%r8,1),%rax
 1072434:	add    %r8,%rdi
 1072437:	and    $0xfffffffffffffffc,%rax
 107243b:	cmp    %rdi,%rax
 107243e:	jae    1079f34 <check_input_run+0xcba4>
 1072444:	xor    %r14d,%r14d
 1072447:	mov    0x20(%rsp),%r12
 107244c:	mov    0x28(%rsp),%r9
 1072451:	jmp    10715de <check_input_run+0x424e>
 1072456:	xor    %r15d,%r15d
 1072459:	mov    0x2a0(%rsp),%rsi
 1072461:	test   %r13,%r13
 1072464:	sete   %cl
 1072467:	or     %al,%cl
 1072469:	or     %cl,0x3c5(%rsi)
 107246f:	test   %cl,%cl
 1072471:	je     107644a <check_input_run+0x90ba>
 1072477:	mov    0x2c0(%rsp),%rax
 107247f:	mov    0x210(%rsp),%rcx
 1072487:	mov    %rcx,0x8(%rax)
 107248b:	mov    0x2c8(%rsp),%rax
 1072493:	mov    %r9,0x8(%rax)
 1072497:	mov    0x18(%rsp),%rax
 107249c:	movb   $0x1,0x3c5(%rax)
 10724a3:	lea    0x2a0(%rsp),%rdi
 10724ab:	call   1082260 <check_input_intrinsic_initialize>
 10724b0:	vmovdqa64 -0xbd4ffa(%rip),%zmm1        # 49d4c0 <cbuiltin_test_generated.edges+0x3680>
 10724ba:	vpxor  %xmm0,%xmm0,%xmm0
 10724be:	mov    0x2b0(%rsp),%rcx
 10724c6:	mov    0x2a8(%rsp),%rax
 10724ce:	movabs $0x64616f6c7265766f,%r9
 10724d8:	mov    0x270(%rcx),%rsi
 10724df:	xor    %ecx,%ecx
 10724e1:	vaesenc %zmm0,%zmm1,%zmm1
 10724e7:	mov    0x8(%rsi),%r8
 10724eb:	mov    (%rsi),%rdi
 10724ee:	vaesenc %zmm0,%zmm1,%zmm0
 10724f4:	vextracti64x4 $0x1,%zmm0,%ymm1
 10724fb:	vpxorq %zmm0,%zmm1,%zmm0
 1072501:	vextracti128 $0x1,%ymm0,%xmm1
 1072507:	vpxor  %xmm0,%xmm1,%xmm0
 107250b:	vpxor  %xmm1,%xmm1,%xmm1
 107250f:	vaesenc %xmm1,%xmm0,%xmm0
 1072514:	vmovq  %xmm0,%rdx
 1072519:	vbroadcasti32x4 -0xae3083(%rip),%zmm0        # 58f4a0 <abi_test_hex.digits+0xb10>
 1072523:	and    %r8,%rdx
 1072526:	cs nopw 0x0(%rax,%rax,1)
 1072530:	mov    %rdx,%r10
 1072533:	shl    $0x6,%r10
 1072537:	vmovdqa64 (%rdi,%r10,1),%zmm1
 107253e:	vpcmpeqd %zmm0,%zmm1,%k0
 1072544:	kmovd  %k0,%r11d
 1072548:	and    $0x7777,%r11d
 107254f:	add    $0x1111,%r11d
 1072556:	and    $0x8888,%r11w
 107255c:	je     10725d0 <check_input_run+0x5240>
 107255e:	mov    0x10(%rsi),%rbx
 1072562:	add    %rdi,%r10
 1072565:	movzwl %r11w,%r11d
 1072569:	jmp    107257e <check_input_run+0x51ee>
 107256b:	nopl   0x0(%rax,%rax,1)
 1072570:	xor    %ebp,%ebp
 1072572:	test   %bpl,%bpl
 1072575:	jne    10725d2 <check_input_run+0x5242>
 1072577:	blsr   %r11d,%r11d
 107257c:	je     10725d2 <check_input_run+0x5242>
 107257e:	xor    %r14d,%r14d
 1072581:	tzcnt  %r11d,%r14d
 1072586:	mov    (%r10,%r14,4),%r14d
 107258a:	cmpl   $0xc,0x4(%rbx,%r14,8)
 1072590:	jne    1072570 <check_input_run+0x51e0>
 1072592:	mov    0x40(%rsi),%r15
 1072596:	mov    (%rbx,%r14,8),%r12d
 107259a:	mov    (%r15,%r12,1),%r13
 107259e:	mov    0x8(%r15,%r12,1),%r15d
 10725a3:	mov    0x20(%rsp),%r12
 10725a8:	xor    %r9,%r13
 10725ab:	xor    $0x656c6261,%r15
 10725b2:	or     %r13,%r15
 10725b5:	sete   %bpl
 10725b9:	cmove  %r14d,%ecx
 10725bd:	test   %bpl,%bpl
 10725c0:	je     1072577 <check_input_run+0x51e7>
 10725c2:	jmp    10725d2 <check_input_run+0x5242>
 10725c4:	data16 data16 cs nopw 0x0(%rax,%rax,1)
 10725d0:	xor    %ebp,%ebp
 10725d2:	vptestnmd %zmm1,%zmm1,%k0
 10725d8:	kmovd  %k0,%r10d
 10725dc:	test   $0x8888,%r10d
 10725e3:	jne    10725f4 <check_input_run+0x5264>
 10725e5:	inc    %rdx
 10725e8:	and    %r8,%rdx
 10725eb:	test   %bpl,%bpl
 10725ee:	je     1072530 <check_input_run+0x51a0>
 10725f4:	vmovdqa64 -0xbd50be(%rip),%zmm1        # 49d540 <cbuiltin_test_generated.edges+0x3700>
 10725fe:	vpxor  %xmm0,%xmm0,%xmm0
 1072602:	xor    %edx,%edx
 1072604:	vaesenc %zmm0,%zmm1,%zmm1
 107260a:	vaesenc %zmm0,%zmm1,%zmm0
 1072610:	vextracti64x4 $0x1,%zmm0,%ymm1
 1072617:	vpxorq %zmm0,%zmm1,%zmm0
 107261d:	vextracti128 $0x1,%ymm0,%xmm1
 1072623:	vpxor  %xmm0,%xmm1,%xmm0
 1072627:	vpxor  %xmm1,%xmm1,%xmm1
 107262b:	vaesenc %xmm1,%xmm0,%xmm0
 1072630:	vmovdqa -0xae3208(%rip),%xmm1        # 58f430 <abi_test_hex.digits+0xaa0>
 1072638:	vmovq  %xmm0,%r9
 107263d:	vbroadcasti32x4 -0xae3217(%rip),%zmm0        # 58f430 <abi_test_hex.digits+0xaa0>
 1072647:	nopw   0x0(%rax,%rax,1)
 1072650:	and    %r8,%r9
 1072653:	mov    %r9,%r10
 1072656:	shl    $0x6,%r10
 107265a:	vmovdqa64 (%rdi,%r10,1),%zmm2
 1072661:	vpcmpeqd %zmm0,%zmm2,%k0
 1072667:	kmovd  %k0,%r11d
 107266b:	and    $0x7777,%r11d
 1072672:	add    $0x1111,%r11d
 1072679:	and    $0x8888,%r11w
 107267f:	je     10726e0 <check_input_run+0x5350>
 1072681:	mov    0x10(%rsi),%rbx
 1072685:	add    %rdi,%r10
 1072688:	movzwl %r11w,%r11d
 107268c:	jmp    107269e <check_input_run+0x530e>
 107268e:	xchg   %ax,%ax
 1072690:	xor    %ebp,%ebp
 1072692:	test   %bpl,%bpl
 1072695:	jne    10726e2 <check_input_run+0x5352>
 1072697:	blsr   %r11d,%r11d
 107269c:	je     10726e2 <check_input_run+0x5352>
 107269e:	xor    %r14d,%r14d
 10726a1:	tzcnt  %r11d,%r14d
 10726a6:	mov    (%r10,%r14,4),%r14d
 10726aa:	cmpl   $0x10,0x4(%rbx,%r14,8)
 10726b0:	jne    1072690 <check_input_run+0x5300>
 10726b2:	mov    0x40(%rsi),%r15
 10726b6:	mov    (%rbx,%r14,8),%r12d
 10726ba:	vpxor  (%r15,%r12,1),%xmm1,%xmm3
 10726c0:	mov    0x20(%rsp),%r12
 10726c5:	vptest %xmm3,%xmm3
 10726ca:	sete   %bpl
 10726ce:	cmove  %r14d,%edx
 10726d2:	test   %bpl,%bpl
 10726d5:	je     1072697 <check_input_run+0x5307>
 10726d7:	jmp    10726e2 <check_input_run+0x5352>
 10726d9:	nopl   0x0(%rax)
 10726e0:	xor    %ebp,%ebp
 10726e2:	vptestnmd %zmm2,%zmm2,%k0
 10726e8:	kmovd  %k0,%r10d
 10726ec:	test   $0x8888,%r10d
 10726f3:	jne    1072701 <check_input_run+0x5371>
 10726f5:	inc    %r9
 10726f8:	test   %bpl,%bpl
 10726fb:	je     1072650 <check_input_run+0x52c0>
 1072701:	mov    0x30(%rax),%esi
 1072704:	test   %rsi,%rsi
 1072707:	je     1072725 <check_input_run+0x5395>
 1072709:	mov    0x18(%rax),%r8
 107270d:	mov    0x50(%rax),%r9
 1072711:	cmp    $0x8,%esi
 1072714:	jae    1072734 <check_input_run+0x53a4>
 1072716:	xor    %r10d,%r10d
 1072719:	xor    %r11d,%r11d
 107271c:	xor    %ebx,%ebx
 107271e:	xor    %edi,%edi
 1072720:	jmp    1072ad0 <check_input_run+0x5740>
 1072725:	mov    0x2a0(%rsp),%r14
 107272d:	xor    %ebp,%ebp
 107272f:	jmp    1072d76 <check_input_run+0x59e6>
 1072734:	cmp    $0x40,%esi
 1072737:	jae    1072748 <check_input_run+0x53b8>
 1072739:	xor    %r10d,%r10d
 107273c:	xor    %r11d,%r11d
 107273f:	xor    %ebx,%ebx
 1072741:	xor    %edi,%edi
 1072743:	jmp    10729d0 <check_input_run+0x5640>
 1072748:	vpbroadcastb -0xbd510e(%rip),%xmm7        # 49d643 <cbuiltin_test_generated.edges+0x3803>
 1072751:	vpbroadcastb -0xbd5116(%rip),%xmm8        # 49d644 <cbuiltin_test_generated.edges+0x3804>
 107275a:	vpbroadcastb -0xbd511e(%rip),%xmm9        # 49d645 <cbuiltin_test_generated.edges+0x3805>
 1072763:	mov    %esi,%r10d
 1072766:	and    $0xffffffc0,%r10d
 107276a:	vpbroadcastd %ecx,%zmm5
 1072770:	vpbroadcastd %edx,%zmm6
 1072776:	kxorw  %k0,%k0,%k4
 107277a:	kxorw  %k0,%k0,%k1
 107277e:	kxorw  %k0,%k0,%k2
 1072782:	kxorw  %k0,%k0,%k3
 1072786:	vpxor  %xmm0,%xmm0,%xmm0
 107278a:	xor    %edi,%edi
 107278c:	vpxor  %xmm10,%xmm10,%xmm10
 1072791:	vpxor  %xmm11,%xmm11,%xmm11
 1072796:	vpxor  %xmm12,%xmm12,%xmm12
 107279b:	vpxor  %xmm1,%xmm1,%xmm1
 107279f:	vpxor  %xmm2,%xmm2,%xmm2
 10727a3:	vpxor  %xmm3,%xmm3,%xmm3
 10727a7:	vpxor  %xmm4,%xmm4,%xmm4
 10727ab:	nopl   0x0(%rax,%rax,1)
 10727b0:	vmovdqu64 (%r8,%rdi,4),%zmm13
 10727b7:	vmovdqu64 0x40(%r8,%rdi,4),%zmm14
 10727bf:	vmovdqu64 0x80(%r8,%rdi,4),%zmm15
 10727c7:	vmovdqu64 0xc0(%r8,%rdi,4),%zmm16
 10727cf:	kmovw  %k3,0x48(%rsp)
 10727d5:	kmovq  %k2,%k3
 10727da:	kmovq  %k1,%k2
 10727df:	kmovq  %k4,%k1
 10727e4:	vpcmpeqd %zmm5,%zmm13,%k4
 10727ea:	vpcmpeqd %zmm6,%zmm13,%k0
 10727f0:	vpcmpeqd %zmm5,%zmm14,%k5
 10727f6:	vpcmpeqd %zmm5,%zmm15,%k6
 10727fc:	vpcmpeqd %zmm5,%zmm16,%k7
 1072802:	korw   %k0,%k4,%k4
 1072806:	vpcmpeqd %zmm6,%zmm14,%k0
 107280c:	korw   %k0,%k5,%k5
 1072810:	vpcmpeqd %zmm6,%zmm15,%k0
 1072816:	korw   %k0,%k6,%k6
 107281a:	vpcmpeqd %zmm6,%zmm16,%k0
 1072820:	korw   %k0,%k7,%k7
 1072824:	vptestmd %zmm13,%zmm13,%k0{%k4}
 107282a:	kmovq  %k1,%k4
 107282f:	kmovq  %k2,%k1
 1072834:	vmovdqu (%r9,%rdi,1),%xmm13
 107283a:	kmovq  %k3,%k2
 107283f:	kmovw  0x48(%rsp),%k3
 1072845:	korw   %k0,%k4,%k4
 1072849:	vptestmd %zmm14,%zmm14,%k0{%k5}
 107284f:	vmovdqu 0x10(%r9,%rdi,1),%xmm14
 1072856:	korw   %k0,%k1,%k1
 107285a:	vptestmd %zmm15,%zmm15,%k0{%k6}
 1072860:	vmovdqu 0x20(%r9,%rdi,1),%xmm15
 1072867:	korw   %k0,%k2,%k2
 107286b:	vptestmd %zmm16,%zmm16,%k0{%k7}
 1072871:	vmovdqu64 0x30(%r9,%rdi,1),%xmm16
 1072879:	add    $0x40,%rdi
 107287d:	korw   %k0,%k3,%k3
 1072881:	vpcmpeqb %xmm7,%xmm13,%k0
 1072887:	vpand  %xmm8,%xmm13,%xmm13
 107288c:	vpmovm2d %k0,%zmm17
 1072892:	vpcmpeqb %xmm7,%xmm14,%k0
 1072898:	vpand  %xmm8,%xmm14,%xmm14
 107289d:	vpsubd %zmm17,%zmm0,%zmm0
 10728a3:	vpmovm2d %k0,%zmm18
 10728a9:	vpcmpeqb %xmm7,%xmm15,%k0
 10728af:	vpand  %xmm8,%xmm15,%xmm15
 10728b4:	vpsubd %zmm18,%zmm10,%zmm10
 10728ba:	vpmovm2d %k0,%zmm19
 10728c0:	vpcmpeqb %xmm7,%xmm16,%k0
 10728c6:	vpandq %xmm8,%xmm16,%xmm16
 10728cc:	vpsubd %zmm19,%zmm11,%zmm11
 10728d2:	vpmovm2d %k0,%zmm20
 10728d8:	vpcmpeqb %xmm9,%xmm13,%k0
 10728de:	vpsubd %zmm20,%zmm12,%zmm12
 10728e4:	vpmovm2d %k0,%zmm13
 10728ea:	vpcmpeqb %xmm9,%xmm14,%k0
 10728f0:	vpsubd %zmm13,%zmm1,%zmm1
 10728f6:	vpmovm2d %k0,%zmm14
 10728fc:	vpcmpeqb %xmm9,%xmm15,%k0
 1072902:	vpsubd %zmm14,%zmm2,%zmm2
 1072908:	vpmovm2d %k0,%zmm15
 107290e:	vpcmpeqb %xmm9,%xmm16,%k0
 1072914:	vpsubd %zmm15,%zmm3,%zmm3
 107291a:	vpmovm2d %k0,%zmm16
 1072920:	vpsubd %zmm16,%zmm4,%zmm4
 1072926:	cmp    %rdi,%r10
 1072929:	jne    10727b0 <check_input_run+0x5420>
 107292f:	vpaddd %zmm0,%zmm10,%zmm0
 1072935:	vpaddd %zmm11,%zmm12,%zmm5
 107293b:	vpaddd %zmm1,%zmm2,%zmm1
 1072941:	vpaddd %zmm3,%zmm4,%zmm2
 1072947:	korw   %k4,%k1,%k0
 107294b:	vpaddd %zmm0,%zmm5,%zmm0
 1072951:	korw   %k0,%k2,%k0
 1072955:	vextracti64x4 $0x1,%zmm0,%ymm5
 107295c:	kortestw %k0,%k3
 1072960:	vpaddd %zmm5,%zmm0,%zmm0
 1072966:	setne  %r11b
 107296a:	vextracti128 $0x1,%ymm0,%xmm5
 1072970:	vpaddd %xmm5,%xmm0,%xmm0
 1072974:	vpshufd $0xee,%xmm0,%xmm5
 1072979:	vpaddd %xmm5,%xmm0,%xmm0
 107297d:	vpshufd $0x55,%xmm0,%xmm5
 1072982:	vpaddd %xmm5,%xmm0,%xmm0
 1072986:	vmovd  %xmm0,%ebx
 107298a:	vpaddd %zmm1,%zmm2,%zmm0
 1072990:	vextracti64x4 $0x1,%zmm0,%ymm1
 1072997:	vpaddd %zmm1,%zmm0,%zmm0
 107299d:	vextracti128 $0x1,%ymm0,%xmm1
 10729a3:	vpaddd %xmm1,%xmm0,%xmm0
 10729a7:	vpshufd $0xee,%xmm0,%xmm1
 10729ac:	vpaddd %xmm1,%xmm0,%xmm0
 10729b0:	vpshufd $0x55,%xmm0,%xmm1
 10729b5:	vpaddd %xmm1,%xmm0,%xmm0
 10729b9:	vmovd  %xmm0,%edi
 10729bd:	cmp    %esi,%r10d
 10729c0:	je     1072b1c <check_input_run+0x578c>
 10729c6:	test   $0x38,%sil
 10729ca:	je     1072ad0 <check_input_run+0x5740>
 10729d0:	vpbroadcastb -0xbd5396(%rip),%xmm4        # 49d643 <cbuiltin_test_generated.edges+0x3803>
 10729d9:	vpbroadcastb -0xbd539e(%rip),%xmm5        # 49d644 <cbuiltin_test_generated.edges+0x3804>
 10729e2:	vpbroadcastb -0xbd53a6(%rip),%xmm6        # 49d645 <cbuiltin_test_generated.edges+0x3805>
 10729eb:	mov    %r10,%r14
 10729ee:	mov    %esi,%r10d
 10729f1:	and    $0xfffffff8,%r10d
 10729f5:	test   %r11b,%r11b
 10729f8:	vmovd  %ebx,%xmm1
 10729fc:	vmovd  %edi,%xmm0
 1072a00:	vpbroadcastd %ecx,%ymm2
 1072a06:	vpbroadcastd %edx,%ymm3
 1072a0c:	setne  %r11b
 1072a10:	kmovd  %r11d,%k0
 1072a15:	data16 cs nopw 0x0(%rax,%rax,1)
 1072a20:	vmovdqu (%r8,%r14,4),%ymm7
 1072a26:	vpcmpeqd %ymm2,%ymm7,%k1
 1072a2c:	vpcmpeqd %ymm3,%ymm7,%k2
 1072a32:	korb   %k2,%k1,%k1
 1072a36:	vptestmd %ymm7,%ymm7,%k1{%k1}
 1072a3c:	vmovq  (%r9,%r14,1),%xmm7
 1072a42:	add    $0x8,%r14
 1072a46:	korb   %k1,%k0,%k0
 1072a4a:	vpcmpeqb %xmm4,%xmm7,%k1
 1072a50:	vpand  %xmm5,%xmm7,%xmm7
 1072a54:	vpmovm2d %k1,%ymm8
 1072a5a:	vpcmpeqb %xmm6,%xmm7,%k1
 1072a60:	vpsubd %ymm8,%ymm1,%ymm1
 1072a65:	vpmovm2d %k1,%ymm7
 1072a6b:	vpsubd %ymm7,%ymm0,%ymm0
 1072a6f:	cmp    %r14,%r10
 1072a72:	jne    1072a20 <check_input_run+0x5690>
 1072a74:	vextracti128 $0x1,%ymm1,%xmm2
 1072a7a:	kortestb %k0,%k0
 1072a7e:	vpaddd %xmm2,%xmm1,%xmm1
 1072a82:	setne  %r11b
 1072a86:	vpshufd $0xee,%xmm1,%xmm2
 1072a8b:	vpaddd %xmm2,%xmm1,%xmm1
 1072a8f:	vpshufd $0x55,%xmm1,%xmm2
 1072a94:	vpaddd %xmm2,%xmm1,%xmm1
 1072a98:	vmovd  %xmm1,%ebx
 1072a9c:	vextracti128 $0x1,%ymm0,%xmm1
 1072aa2:	vpaddd %xmm1,%xmm0,%xmm0
 1072aa6:	vpshufd $0xee,%xmm0,%xmm1
 1072aab:	vpaddd %xmm1,%xmm0,%xmm0
 1072aaf:	vpshufd $0x55,%xmm0,%xmm1
 1072ab4:	vpaddd %xmm1,%xmm0,%xmm0
 1072ab8:	vmovd  %xmm0,%edi
 1072abc:	cmp    %esi,%r10d
 1072abf:	je     1072b1c <check_input_run+0x578c>
 1072ac1:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1072ad0:	mov    (%r8,%r10,4),%ebp
 1072ad4:	test   %ebp,%ebp
 1072ad6:	setne  %r14b
 1072ada:	cmp    %ecx,%ebp
 1072adc:	sete   %r15b
 1072ae0:	cmp    %edx,%ebp
 1072ae2:	sete   %bpl
 1072ae6:	or     %r15b,%bpl
 1072ae9:	movzbl (%r9,%r10,1),%r15d
 1072aee:	and    %r14b,%bpl
 1072af1:	xor    %r14d,%r14d
 1072af4:	or     %bpl,%r11b
 1072af7:	cmp    $0x2,%r15b
 1072afb:	sete   %r14b
 1072aff:	and    $0xfe,%r15b
 1072b03:	add    %r14d,%ebx
 1072b06:	xor    %r14d,%r14d
 1072b09:	cmp    $0x3c,%r15b
 1072b0d:	sete   %r14b
 1072b11:	inc    %r10
 1072b14:	add    %r14d,%edi
 1072b17:	cmp    %r10,%rsi
 1072b1a:	jne    1072ad0 <check_input_run+0x5740>
 1072b1c:	mov    0x2a0(%rsp),%r14
 1072b24:	test   $0x1,%r11b
 1072b28:	je     1072b5b <check_input_run+0x57cb>
 1072b2a:	mov    %ebx,0x488(%rsp)
 1072b31:	mov    %ebx,%ecx
 1072b33:	inc    %rcx
 1072b36:	mov    0x2c0(%rsp),%rdx
 1072b3e:	mov    (%rdx),%r8
 1072b41:	mov    0x8(%rdx),%r9
 1072b45:	lea    0x3(%r9,%r8,1),%rsi
 1072b4a:	add    %r8,%r9
 1072b4d:	and    $0xfffffffffffffffc,%rsi
 1072b51:	cmp    %r9,%rsi
 1072b54:	jae    1072b62 <check_input_run+0x57d2>
 1072b56:	xor    %r8d,%r8d
 1072b59:	jmp    1072b92 <check_input_run+0x5802>
 1072b5b:	xor    %ebp,%ebp
 1072b5d:	jmp    1072d76 <check_input_run+0x59e6>
 1072b62:	mov    0x10(%rdx),%r10
 1072b66:	mov    %rsi,%r9
 1072b69:	sub    %r8,%r9
 1072b6c:	xor    %r8d,%r8d
 1072b6f:	sub    %r9,%r10
 1072b72:	jb     1072b92 <check_input_run+0x5802>
 1072b74:	mov    %rcx,%r11
 1072b77:	shl    $0x5,%r11
 1072b7b:	cmp    %r10,%r11
 1072b7e:	ja     1072b92 <check_input_run+0x5802>
 1072b80:	add    %r11,%r9
 1072b83:	mov    %rsi,%r8
 1072b86:	mov    %r9,0x8(%rdx)
 1072b8a:	mov    0x2c0(%rsp),%rdx
 1072b92:	mov    %r8,0x480(%rsp)
 1072b9a:	mov    (%rdx),%r8
 1072b9d:	mov    0x8(%rdx),%r9
 1072ba1:	lea    0x3(%r9,%r8,1),%rsi
 1072ba6:	add    %r8,%r9
 1072ba9:	and    $0xfffffffffffffffc,%rsi
 1072bad:	cmp    %r9,%rsi
 1072bb0:	jae    1072bb7 <check_input_run+0x5827>
 1072bb2:	xor    %r8d,%r8d
 1072bb5:	jmp    1072be4 <check_input_run+0x5854>
 1072bb7:	mov    0x10(%rdx),%r10
 1072bbb:	mov    %rsi,%r9
 1072bbe:	sub    %r8,%r9
 1072bc1:	xor    %r8d,%r8d
 1072bc4:	sub    %r9,%r10
 1072bc7:	jb     1072be4 <check_input_run+0x5854>
 1072bc9:	mov    0x30(%rax),%r11d
 1072bcd:	lea    0x4(,%r11,4),%r11
 1072bd5:	cmp    %r10,%r11
 1072bd8:	ja     1072be4 <check_input_run+0x5854>
 1072bda:	add    %r11,%r9
 1072bdd:	mov    %rsi,%r8
 1072be0:	mov    %r9,0x8(%rdx)
 1072be4:	mov    %r8,0x220(%r14)
 1072beb:	mov    0x2c8(%rsp),%rdx
 1072bf3:	mov    (%rdx),%r8
 1072bf6:	mov    0x8(%rdx),%r9
 1072bfa:	lea    0x3(%r9,%r8,1),%rsi
 1072bff:	add    %r8,%r9
 1072c02:	and    $0xfffffffffffffffc,%rsi
 1072c06:	cmp    %r9,%rsi
 1072c09:	jae    1072c10 <check_input_run+0x5880>
 1072c0b:	xor    %r8d,%r8d
 1072c0e:	jmp    1072c50 <check_input_run+0x58c0>
 1072c10:	mov    0x10(%rdx),%r10
 1072c14:	mov    %rsi,%r9
 1072c17:	sub    %r8,%r9
 1072c1a:	xor    %r8d,%r8d
 1072c1d:	sub    %r9,%r10
 1072c20:	jb     1072c50 <check_input_run+0x58c0>
 1072c22:	mov    0x2b0(%rsp),%r11
 1072c2a:	mov    0x270(%r11),%r11
 1072c31:	mov    0x68(%r11),%r11d
 1072c35:	shl    $0x2,%r11
 1072c39:	cmp    %r10,%r11
 1072c3c:	ja     1072c50 <check_input_run+0x58c0>
 1072c3e:	add    %r11,%r9
 1072c41:	mov    %rsi,%r8
 1072c44:	mov    %r9,0x8(%rdx)
 1072c48:	mov    0x2c8(%rsp),%rdx
 1072c50:	mov    %r8,0x490(%rsp)
 1072c58:	mov    (%rdx),%r8
 1072c5b:	mov    0x8(%rdx),%r9
 1072c5f:	lea    0x3(%r9,%r8,1),%rsi
 1072c64:	add    %r8,%r9
 1072c67:	and    $0xfffffffffffffffc,%rsi
 1072c6b:	cmp    %r9,%rsi
 1072c6e:	jae    1072c75 <check_input_run+0x58e5>
 1072c70:	xor    %r8d,%r8d
 1072c73:	jmp    1072c9a <check_input_run+0x590a>
 1072c75:	mov    0x10(%rdx),%r10
 1072c79:	mov    %rsi,%r9
 1072c7c:	sub    %r8,%r9
 1072c7f:	xor    %r8d,%r8d
 1072c82:	sub    %r9,%r10
 1072c85:	jb     1072c9a <check_input_run+0x590a>
 1072c87:	shl    $0x2,%rcx
 1072c8b:	cmp    %r10,%rcx
 1072c8e:	ja     1072c9a <check_input_run+0x590a>
 1072c90:	add    %rcx,%r9
 1072c93:	mov    %rsi,%r8
 1072c96:	mov    %r9,0x8(%rdx)
 1072c9a:	mov    %r8,0x498(%rsp)
 1072ca2:	mov    0x2c0(%rsp),%rdx
 1072caa:	mov    (%rdx),%rcx
 1072cad:	mov    0x8(%rdx),%r8
 1072cb1:	lea    0x3(%r8,%rcx,1),%rsi
 1072cb6:	add    %rcx,%r8
 1072cb9:	and    $0xfffffffffffffffc,%rsi
 1072cbd:	cmp    %r8,%rsi
 1072cc0:	jae    1072cc6 <check_input_run+0x5936>
 1072cc2:	xor    %ecx,%ecx
 1072cc4:	jmp    1072cf1 <check_input_run+0x5961>
 1072cc6:	mov    0x10(%rdx),%r9
 1072cca:	mov    %rsi,%r8
 1072ccd:	sub    %rcx,%r8
 1072cd0:	xor    %ecx,%ecx
 1072cd2:	sub    %r8,%r9
 1072cd5:	jb     1072cf1 <check_input_run+0x5961>
 1072cd7:	mov    %edi,%r10d
 1072cda:	lea    0x8(,%r10,8),%r10
 1072ce2:	cmp    %r9,%r10
 1072ce5:	ja     1072cf1 <check_input_run+0x5961>
 1072ce7:	add    %r10,%r8
 1072cea:	mov    %rsi,%rcx
 1072ced:	mov    %r8,0x8(%rdx)
 1072cf1:	mov    %rcx,0x110(%r14)
 1072cf8:	mov    %edi,0x11c(%r14)
 1072cff:	mov    $0x1,%bpl
 1072d02:	mov    0x480(%rsp),%rdx
 1072d0a:	mov    %rdx,0x100(%r14)
 1072d11:	test   %rdx,%rdx
 1072d14:	je     1072d76 <check_input_run+0x59e6>
 1072d16:	mov    0x220(%r14),%rdi
 1072d1d:	test   %rdi,%rdi
 1072d20:	je     1072d76 <check_input_run+0x59e6>
 1072d22:	mov    0x490(%rsp),%rbx
 1072d2a:	test   %rbx,%rbx
 1072d2d:	je     1072d76 <check_input_run+0x59e6>
 1072d2f:	test   %rcx,%rcx
 1072d32:	je     1072d76 <check_input_run+0x59e6>
 1072d34:	cmpq   $0x0,0x498(%rsp)
 1072d3d:	je     1072d76 <check_input_run+0x59e6>
 1072d3f:	mov    0x30(%rax),%eax
 1072d42:	xor    %ebp,%ebp
 1072d44:	xor    %esi,%esi
 1072d46:	lea    0x4(,%rax,4),%rdx
 1072d4e:	vzeroupper
 1072d51:	call   788430 <memset@plt>
 1072d56:	mov    0x2b0(%rsp),%rax
 1072d5e:	mov    %rbx,%rdi
 1072d61:	xor    %esi,%esi
 1072d63:	mov    0x270(%rax),%rax
 1072d6a:	mov    0x68(%rax),%edx
 1072d6d:	shl    $0x2,%rdx
 1072d71:	call   788430 <memset@plt>
 1072d76:	mov    0x58(%rsp),%rax
 1072d7b:	or     %bpl,0x3c5(%r14)
 1072d82:	mov    0x38(%rsp),%rcx
 1072d87:	movzbl 0x60(%rax),%eax
 1072d8b:	cmp    $0x1,%eax
 1072d8e:	je     1072dc2 <check_input_run+0x5a32>
 1072d90:	test   %eax,%eax
 1072d92:	jne    1072dd7 <check_input_run+0x5a47>
 1072d94:	mov    0x58(%rsp),%rax
 1072d99:	lea    0x28(%rax),%rdi
 1072d9d:	vzeroupper
 1072da0:	call   10140a0 <predefines_eval_method>
 1072da5:	mov    0x38(%rsp),%rcx
 1072daa:	test   %eax,%eax
 1072dac:	sete   %al
 1072daf:	mov    0x58(%rsp),%rdx
 1072db4:	cmpb   $0x0,0x1d4(%rdx)
 1072dbb:	je     1072de7 <check_input_run+0x5a57>
 1072dbd:	jmp    1072e64 <check_input_run+0x5ad4>
 1072dc2:	mov    $0x1,%al
 1072dc4:	mov    0x58(%rsp),%rdx
 1072dc9:	cmpb   $0x0,0x1d4(%rdx)
 1072dd0:	je     1072de7 <check_input_run+0x5a57>
 1072dd2:	jmp    1072e64 <check_input_run+0x5ad4>
 1072dd7:	xor    %eax,%eax
 1072dd9:	mov    0x58(%rsp),%rdx
 1072dde:	cmpb   $0x0,0x1d4(%rdx)
 1072de5:	jne    1072e64 <check_input_run+0x5ad4>
 1072de7:	cmpb   $0x0,0x61(%rdx)
 1072deb:	jne    1072e64 <check_input_run+0x5ad4>
 1072ded:	cmpb   $0x0,0x62(%rdx)
 1072df1:	jne    1072e64 <check_input_run+0x5ad4>
 1072df3:	cmpb   $0x0,0x1cc(%rdx)
 1072dfa:	sete   %cl
 1072dfd:	test   %al,%cl
 1072dff:	mov    0x38(%rsp),%rcx
 1072e04:	je     1072e64 <check_input_run+0x5ad4>
 1072e06:	mov    0x18(%rsp),%rax
 1072e0b:	cmpb   $0x0,0x3c5(%rax)
 1072e12:	jne    1072eba <check_input_run+0x5b2a>
 1072e18:	mov    0x58(%rsp),%rax
 1072e1d:	mov    0x2a8(%rsp),%r10
 1072e25:	mov    0x30(%r10),%r9d
 1072e29:	mov    0xc18(%rax),%eax
 1072e2f:	test   %rax,%rax
 1072e32:	je     10754c5 <check_input_run+0x8135>
 1072e38:	mov    0x58(%rsp),%rcx
 1072e3d:	xor    %edx,%edx
 1072e3f:	mov    0xc10(%rcx),%rcx
 1072e46:	add    $0x28,%rcx
 1072e4a:	cmpb   $0x0,(%rcx)
 1072e4d:	jne    107504a <check_input_run+0x7cba>
 1072e53:	inc    %rdx
 1072e56:	add    $0x38,%rcx
 1072e5a:	cmp    %rdx,%rax
 1072e5d:	jne    1072e4a <check_input_run+0x5aba>
 1072e5f:	jmp    10754c5 <check_input_run+0x8135>
 1072e64:	mov    0x230(%r14),%eax
 1072e6b:	cmp    0x234(%r14),%eax
 1072e72:	jae    1072eb2 <check_input_run+0x5b22>
 1072e74:	movzbl 0x3c5(%r14),%ecx
 1072e7c:	mov    0x228(%r14),%rdx
 1072e83:	lea    0x1(%rax),%esi
 1072e86:	lea    (%rax,%rax,2),%rax
 1072e8a:	mov    %esi,0x230(%r14)
 1072e91:	xor    $0x1,%ecx
 1072e94:	movl   $0x0,(%rdx,%rax,4)
 1072e9b:	lea    0x4(%rcx,%rcx,2),%ecx
 1072e9f:	mov    %ecx,0x4(%rdx,%rax,4)
 1072ea3:	mov    0x38(%rsp),%rcx
 1072ea8:	movl   $0x0,0x8(%rdx,%rax,4)
 1072eb0:	jmp    1072eba <check_input_run+0x5b2a>
 1072eb2:	movb   $0x1,0x3c5(%r14)
 1072eba:	mov    0x18(%rsp),%rax
 1072ebf:	movzbl 0x3c5(%rax),%eax
 1072ec6:	test   %al,%al
 1072ec8:	jne    1076320 <check_input_run+0x8f90>
 1072ece:	cmpb   $0x0,0x338(%rsp)
 1072ed6:	je     1076320 <check_input_run+0x8f90>
 1072edc:	mov    0x858(%rsp),%ecx
 1072ee3:	test   %ecx,%ecx
 1072ee5:	je     1072f0c <check_input_run+0x5b7c>
 1072ee7:	mov    %ecx,%eax
 1072ee9:	and    $0xfffffffe,%eax
 1072eec:	cmp    $0x4,%eax
 1072eef:	jne    1072f23 <check_input_run+0x5b93>
 1072ef1:	xor    %esi,%esi
 1072ef3:	cmp    $0x4,%ecx
 1072ef6:	lea    0x2a0(%rsp),%rdi
 1072efe:	sete   %sil
 1072f02:	vzeroupper
 1072f05:	call   10fa3f0 <check_input_binding_parser>
 1072f0a:	jmp    1072f35 <check_input_run+0x5ba5>
 1072f0c:	mov    0x2a8(%rsp),%rax
 1072f14:	movzbl (%rax),%ecx
 1072f17:	inc    %ecx
 1072f19:	mov    %ecx,%eax
 1072f1b:	and    $0xfffffffe,%eax
 1072f1e:	cmp    $0x4,%eax
 1072f21:	je     1072ef1 <check_input_run+0x5b61>
 1072f23:	lea    0x2a0(%rsp),%rdi
 1072f2b:	mov    %ecx,%esi
 1072f2d:	vzeroupper
 1072f30:	call   10fa6e0 <check_input_binding_events>
 1072f35:	mov    0x18(%rsp),%rax
 1072f3a:	mov    0x30(%rsp),%r11
 1072f3f:	mov    0x230(%rax),%eax
 1072f45:	test   %rax,%rax
 1072f48:	je     107308e <check_input_run+0x5cfe>
 1072f4e:	mov    0x670(%rsp),%r8d
 1072f56:	mov    %eax,%ecx
 1072f58:	and    $0x7,%ecx
 1072f5b:	cmp    $0x8,%eax
 1072f5e:	jae    1072f67 <check_input_run+0x5bd7>
 1072f60:	xor    %edx,%edx
 1072f62:	jmp    107305e <check_input_run+0x5cce>
 1072f67:	mov    %eax,%edx
 1072f69:	shr    $0x3,%edx
 1072f6c:	xor    %edi,%edi
 1072f6e:	shl    $0x5,%rdx
 1072f72:	lea    (%rdx,%rdx,2),%rsi
 1072f76:	xor    %edx,%edx
 1072f78:	jmp    1072f99 <check_input_run+0x5c09>
 1072f7a:	nopw   0x0(%rax,%rax,1)
 1072f80:	add    $0x8,%rdx
 1072f84:	add    $0x60,%rdi
 1072f88:	mov    %r8d,0x670(%rsp)
 1072f90:	cmp    %rdi,%rsi
 1072f93:	je     1073059 <check_input_run+0x5cc9>
 1072f99:	mov    (%r11),%r9
 1072f9c:	mov    (%r9,%rdi,1),%r9d
 1072fa0:	cmp    %r8d,%r9d
 1072fa3:	jb     1072fa8 <check_input_run+0x5c18>
 1072fa5:	mov    %r8d,%r9d
 1072fa8:	mov    %r9d,0x670(%rsp)
 1072fb0:	mov    (%r11),%r8
 1072fb3:	mov    0xc(%r8,%rdi,1),%r8d
 1072fb8:	cmp    %r9d,%r8d
 1072fbb:	jb     1072fc0 <check_input_run+0x5c30>
 1072fbd:	mov    %r9d,%r8d
 1072fc0:	mov    %r8d,0x670(%rsp)
 1072fc8:	mov    (%r11),%r9
 1072fcb:	mov    0x18(%r9,%rdi,1),%r9d
 1072fd0:	cmp    %r8d,%r9d
 1072fd3:	jb     1072fd8 <check_input_run+0x5c48>
 1072fd5:	mov    %r8d,%r9d
 1072fd8:	mov    %r9d,0x670(%rsp)
 1072fe0:	mov    (%r11),%r8
 1072fe3:	mov    0x24(%r8,%rdi,1),%r8d
 1072fe8:	cmp    %r9d,%r8d
 1072feb:	jb     1072ff0 <check_input_run+0x5c60>
 1072fed:	mov    %r9d,%r8d
 1072ff0:	mov    %r8d,0x670(%rsp)
 1072ff8:	mov    (%r11),%r9
 1072ffb:	mov    0x30(%r9,%rdi,1),%r9d
 1073000:	cmp    %r8d,%r9d
 1073003:	jb     1073008 <check_input_run+0x5c78>
 1073005:	mov    %r8d,%r9d
 1073008:	mov    %r9d,0x670(%rsp)
 1073010:	mov    (%r11),%r8
 1073013:	mov    0x3c(%r8,%rdi,1),%r8d
 1073018:	cmp    %r9d,%r8d
 107301b:	jb     1073020 <check_input_run+0x5c90>
 107301d:	mov    %r9d,%r8d
 1073020:	mov    %r8d,0x670(%rsp)
 1073028:	mov    (%r11),%r9
 107302b:	mov    0x48(%r9,%rdi,1),%r9d
 1073030:	cmp    %r8d,%r9d
 1073033:	jb     1073038 <check_input_run+0x5ca8>
 1073035:	mov    %r8d,%r9d
 1073038:	mov    %r9d,0x670(%rsp)
 1073040:	mov    (%r11),%r8
 1073043:	mov    0x54(%r8,%rdi,1),%r8d
 1073048:	cmp    %r9d,%r8d
 107304b:	jb     1072f80 <check_input_run+0x5bf0>
 1073051:	mov    %r9d,%r8d
 1073054:	jmp    1072f80 <check_input_run+0x5bf0>
 1073059:	test   %rcx,%rcx
 107305c:	je     107308e <check_input_run+0x5cfe>
 107305e:	shl    $0x2,%rdx
 1073062:	lea    (%rdx,%rdx,2),%rdx
 1073066:	cs nopw 0x0(%rax,%rax,1)
 1073070:	mov    (%r11),%rsi
 1073073:	mov    (%rsi,%rdx,1),%esi
 1073076:	cmp    %r8d,%esi
 1073079:	cmovb  %esi,%r8d
 107307d:	add    $0xc,%rdx
 1073081:	dec    %rcx
 1073084:	mov    %r8d,0x670(%rsp)
 107308c:	jne    1073070 <check_input_run+0x5ce0>
 107308e:	mov    0x18(%rsp),%rcx
 1073093:	cmpb   $0x0,0x3c5(%rcx)
 107309a:	jne    10704b2 <check_input_run+0x3122>
 10730a0:	mov    0x2a8(%rsp),%r9
 10730a8:	mov    0x30(%r9),%ecx
 10730ac:	test   %ecx,%ecx
 10730ae:	je     1074620 <check_input_run+0x7290>
 10730b4:	lea    0x700(%rsp),%r15
 10730bc:	xor    %r13d,%r13d
 10730bf:	vpxor  %xmm0,%xmm0,%xmm0
 10730c3:	jmp    10730de <check_input_run+0x5d4e>
 10730c5:	movb   $0x1,0x3c5(%rax)
 10730cc:	mov    0x30(%r9),%ecx
 10730d0:	inc    %r13
 10730d3:	mov    %ecx,%eax
 10730d5:	cmp    %rax,%r13
 10730d8:	jae    1074615 <check_input_run+0x7285>
 10730de:	mov    0x68(%r9),%rax
 10730e2:	mov    0x610(%rsp),%rdx
 10730ea:	mov    $0x0,%ebx
 10730ef:	mov    (%rax,%r13,4),%r14d
 10730f3:	mov    (%rdx,%r14,4),%edx
 10730f7:	cmp    %ecx,%edx
 10730f9:	jae    1073102 <check_input_run+0x5d72>
 10730fb:	mov    0x18(%r9),%rax
 10730ff:	mov    (%rax,%rdx,4),%ebx
 1073102:	mov    0x608(%rsp),%rax
 107310a:	mov    (%rax,%r14,4),%eax
 107310e:	cmp    0x670(%rsp),%eax
 1073115:	jae    10730d0 <check_input_run+0x5d40>
 1073117:	mov    0x3d8(%rsp),%rax
 107311f:	cmpb   $0x0,(%rax,%r14,1)
 1073124:	jne    10730d0 <check_input_run+0x5d40>
 1073126:	mov    0x50(%r9),%rax
 107312a:	cmpb   $0x48,(%rax,%r14,1)
 107312f:	jne    10730d0 <check_input_run+0x5d40>
 1073131:	cmp    $0x4c,%ebx
 1073134:	je     107313b <check_input_run+0x5dab>
 1073136:	cmp    $0x28,%ebx
 1073139:	jne    10730d0 <check_input_run+0x5d40>
 107313b:	lea    0x2(%rdx),%edi
 107313e:	mov    %rdx,0x210(%rsp)
 1073146:	cmp    %r14d,%edi
 1073149:	jae    10731b0 <check_input_run+0x5e20>
 107314b:	mov    0x10(%r9),%rax
 107314f:	mov    %edi,%ecx
 1073151:	jmp    1073187 <check_input_run+0x5df7>
 1073153:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1073160:	cmp    $0xa,%esi
 1073163:	jne    107319e <check_input_run+0x5e0e>
 1073165:	mov    0x60(%r9),%rsi
 1073169:	mov    (%rsi,%rdx,4),%edx
 107316c:	lea    0x1(%rdx),%ebp
 107316f:	cmp    %r14d,%edx
 1073172:	cmovae %r14d,%ebp
 1073176:	cmp    %ecx,%edx
 1073178:	cmovbe %r14d,%ebp
 107317c:	mov    %ebp,%ecx
 107317e:	cmp    %r14d,%ebp
 1073181:	jae    107321a <check_input_run+0x5e8a>
 1073187:	mov    %ecx,%edx
 1073189:	movzbl (%rax,%rdx,1),%esi
 107318d:	cmp    $0x9,%esi
 1073190:	jg     1073160 <check_input_run+0x5dd0>
 1073192:	cmp    $0x6,%esi
 1073195:	je     1073165 <check_input_run+0x5dd5>
 1073197:	cmp    $0x8,%esi
 107319a:	je     1073165 <check_input_run+0x5dd5>
 107319c:	jmp    10731a3 <check_input_run+0x5e13>
 107319e:	cmp    $0x33,%esi
 10731a1:	je     1073218 <check_input_run+0x5e88>
 10731a3:	inc    %ecx
 10731a5:	mov    %ecx,%ebp
 10731a7:	mov    %ebp,%ecx
 10731a9:	cmp    %r14d,%ebp
 10731ac:	jb     1073187 <check_input_run+0x5df7>
 10731ae:	jmp    107321a <check_input_run+0x5e8a>
 10731b0:	vmovdqu64 %zmm0,0x7a0(%rsp)
 10731bb:	vmovdqu64 %zmm0,0x780(%rsp)
 10731c3:	mov    0x2a0(%rsp),%rax
 10731cb:	mov    0x230(%rax),%ecx
 10731d1:	cmp    0x234(%rax),%ecx
 10731d7:	jae    10730c5 <check_input_run+0x5d35>
 10731dd:	movzbl 0x3c5(%rax),%edx
 10731e4:	lea    0x1(%rcx),%edi
 10731e7:	mov    0x228(%rax),%rsi
 10731ee:	mov    %edi,0x230(%rax)
 10731f4:	lea    (%rcx,%rcx,2),%rax
 10731f8:	mov    0x210(%rsp),%rcx
 1073200:	lea    0x1(%rdx,%rdx,2),%edx
 1073204:	mov    %ecx,(%rsi,%rax,4)
 1073207:	mov    %edx,0x4(%rsi,%rax,4)
 107320b:	movl   $0x0,0x8(%rsi,%rax,4)
 1073213:	jmp    10730cc <check_input_run+0x5d3c>
 1073218:	mov    %ecx,%ebp
 107321a:	vmovdqu64 %zmm0,0x7a0(%rsp)
 1073225:	vmovdqu64 %zmm0,0x780(%rsp)
 107322d:	cmp    %ebp,%edi
 107322f:	jae    10731c3 <check_input_run+0x5e33>
 1073231:	cmp    %ebp,%r14d
 1073234:	jbe    10731c3 <check_input_run+0x5e33>
 1073236:	mov    %edi,%esi
 1073238:	mov    %r9,0x1b0(%rsp)
 1073240:	lea    0x2a0(%rsp),%rdi
 1073248:	mov    $0x1,%r8d
 107324e:	lea    0x780(%rsp),%r9
 1073256:	mov    %r15,(%rsp)
 107325a:	movq   $0x0,0x8(%rsp)
 1073263:	mov    %esi,0x70(%rsp)
 1073267:	mov    %ebp,%edx
 1073269:	xor    %ecx,%ecx
 107326b:	vzeroupper
 107326e:	call   10c24f0 <check_input_constant_read>
 1073273:	cmp    $0x28,%ebx
 1073276:	jne    10732f0 <check_input_run+0x5f60>
 1073278:	test   %al,%al
 107327a:	je     10732f0 <check_input_run+0x5f60>
 107327c:	mov    0x2c8(%rsp),%rax
 1073284:	mov    0x780(%rsp),%esi
 107328b:	mov    0x2a8(%rsp),%rbx
 1073293:	lea    0x2a0(%rsp),%rdi
 107329b:	mov    0x8(%rax),%rax
 107329f:	mov    %rax,0xd8(%rsp)
 10732a7:	call   10e75a0 <check_constant_control_type>
 10732ac:	mov    %eax,0x100(%rsp)
 10732b3:	mov    0x2c8(%rsp),%rax
 10732bb:	mov    (%rax),%rsi
 10732be:	mov    0x8(%rax),%rdx
 10732c2:	lea    0x3(%rdx,%rsi,1),%rcx
 10732c7:	add    %rsi,%rdx
 10732ca:	and    $0xfffffffffffffffc,%rcx
 10732ce:	cmp    %rdx,%rcx
 10732d1:	jae    107337b <check_input_run+0x5feb>
 10732d7:	mov    0x30(%rsp),%r11
 10732dc:	mov    0x1b0(%rsp),%r9
 10732e4:	xor    %r8d,%r8d
 10732e7:	vpxor  %xmm0,%xmm0,%xmm0
 10732eb:	jmp    10733be <check_input_run+0x602e>
 10732f0:	mov    0x30(%rsp),%r11
 10732f5:	mov    0x1b0(%rsp),%r9
 10732fd:	vpxor  %xmm0,%xmm0,%xmm0
 1073301:	test   %al,%al
 1073303:	je     10731c3 <check_input_run+0x5e33>
 1073309:	lea    0x1(%rbp),%ebx
 107330c:	mov    %ebx,%r15d
 107330f:	cmp    %r14d,%ebx
 1073312:	jae    1073f78 <check_input_run+0x6be8>
 1073318:	mov    0x10(%r9),%rax
 107331c:	mov    %ebx,%ecx
 107331e:	jmp    1073349 <check_input_run+0x5fb9>
 1073320:	cmp    $0xa,%esi
 1073323:	jne    1073360 <check_input_run+0x5fd0>
 1073325:	mov    0x60(%r9),%rsi
 1073329:	mov    (%rsi,%rdx,4),%edx
 107332c:	lea    0x1(%rdx),%r15d
 1073330:	cmp    %r14d,%edx
 1073333:	cmovae %r14d,%r15d
 1073337:	cmp    %ecx,%edx
 1073339:	cmovbe %r14d,%r15d
 107333d:	mov    %r15d,%ecx
 1073340:	cmp    %r14d,%r15d
 1073343:	jae    1073f78 <check_input_run+0x6be8>
 1073349:	mov    %ecx,%edx
 107334b:	movzbl (%rax,%rdx,1),%esi
 107334f:	cmp    $0x9,%esi
 1073352:	jg     1073320 <check_input_run+0x5f90>
 1073354:	cmp    $0x6,%esi
 1073357:	je     1073325 <check_input_run+0x5f95>
 1073359:	cmp    $0x8,%esi
 107335c:	je     1073325 <check_input_run+0x5f95>
 107335e:	jmp    1073369 <check_input_run+0x5fd9>
 1073360:	cmp    $0x33,%esi
 1073363:	je     1073f75 <check_input_run+0x6be5>
 1073369:	inc    %ecx
 107336b:	mov    %ecx,%r15d
 107336e:	mov    %r15d,%ecx
 1073371:	cmp    %r14d,%r15d
 1073374:	jb     1073349 <check_input_run+0x5fb9>
 1073376:	jmp    1073f78 <check_input_run+0x6be8>
 107337b:	mov    %rcx,%rdx
 107337e:	sub    %rsi,%rdx
 1073381:	mov    0x10(%rax),%rsi
 1073385:	mov    0x30(%rsp),%r11
 107338a:	mov    0x1b0(%rsp),%r9
 1073392:	vpxor  %xmm0,%xmm0,%xmm0
 1073396:	sub    %rdx,%rsi
 1073399:	jb     10733bb <check_input_run+0x602b>
 107339b:	mov    %r14d,%edi
 107339e:	sub    %ebp,%edi
 10733a0:	mov    $0x0,%r8d
 10733a6:	shl    $0x2,%rdi
 10733aa:	cmp    %rsi,%rdi
 10733ad:	ja     10733be <check_input_run+0x602e>
 10733af:	add    %rdi,%rdx
 10733b2:	mov    %rcx,%r8
 10733b5:	mov    %rdx,0x8(%rax)
 10733b9:	jmp    10733be <check_input_run+0x602e>
 10733bb:	xor    %r8d,%r8d
 10733be:	mov    0x2a0(%rsp),%rcx
 10733c6:	test   %r8,%r8
 10733c9:	sete   %al
 10733cc:	xor    %edx,%edx
 10733ce:	or     %al,0x3c5(%rcx)
 10733d4:	lea    0x1(%rbp),%eax
 10733d7:	cmp    %r14d,%eax
 10733da:	jae    1073c93 <check_input_run+0x6903>
 10733e0:	test   %r8,%r8
 10733e3:	je     1073c93 <check_input_run+0x6903>
 10733e9:	cmpl   $0x0,0x100(%rsp)
 10733f1:	mov    %r8,0x90(%rsp)
 10733f9:	mov    %eax,0x88(%rsp)
 1073400:	je     1073c93 <check_input_run+0x6903>
 1073406:	mov    0x88(%rsp),%r10d
 107340e:	lea    0x1(%r14),%eax
 1073412:	movl   $0xffffffff,0xc8(%rsp)
 107341d:	movl   $0x0,0xc0(%rsp)
 1073428:	movl   $0xffffffff,0xe8(%rsp)
 1073433:	mov    %rbx,0x58(%rsp)
 1073438:	mov    %eax,0xd0(%rsp)
 107343f:	mov    0x10(%rbx),%rcx
 1073443:	mov    %r10d,%eax
 1073446:	jmp    1073473 <check_input_run+0x60e3>
 1073448:	nopl   0x0(%rax,%rax,1)
 1073450:	cmp    $0xa,%esi
 1073453:	jne    107348a <check_input_run+0x60fa>
 1073455:	mov    0x60(%rbx),%rsi
 1073459:	mov    (%rsi,%rdx,4),%esi
 107345c:	lea    0x1(%rsi),%edx
 107345f:	cmp    %r14d,%esi
 1073462:	cmovae %r14d,%edx
 1073466:	cmp    %eax,%esi
 1073468:	cmovbe %r14d,%edx
 107346c:	mov    %edx,%eax
 107346e:	cmp    %r14d,%edx
 1073471:	jae    107349c <check_input_run+0x610c>
 1073473:	mov    %eax,%edx
 1073475:	movzbl (%rcx,%rdx,1),%esi
 1073479:	cmp    $0x9,%esi
 107347c:	jg     1073450 <check_input_run+0x60c0>
 107347e:	cmp    $0x6,%esi
 1073481:	je     1073455 <check_input_run+0x60c5>
 1073483:	cmp    $0x8,%esi
 1073486:	je     1073455 <check_input_run+0x60c5>
 1073488:	jmp    107348f <check_input_run+0x60ff>
 107348a:	cmp    $0x2f,%esi
 107348d:	je     107349a <check_input_run+0x610a>
 107348f:	inc    %eax
 1073491:	mov    %eax,%edx
 1073493:	cmp    %r14d,%edx
 1073496:	jb     1073473 <check_input_run+0x60e3>
 1073498:	jmp    107349c <check_input_run+0x610c>
 107349a:	mov    %eax,%edx
 107349c:	cmp    %r14d,%edx
 107349f:	jae    1073c91 <check_input_run+0x6901>
 10734a5:	mov    %edx,%esi
 10734a7:	lea    0x1(%rsi),%edi
 10734aa:	cmp    %r14d,%edi
 10734ad:	jae    1073c91 <check_input_run+0x6901>
 10734b3:	mov    %edi,%eax
 10734b5:	jmp    10734e7 <check_input_run+0x6157>
 10734b7:	nopw   0x0(%rax,%rax,1)
 10734c0:	cmp    $0xa,%r8d
 10734c4:	jne    1073502 <check_input_run+0x6172>
 10734c6:	mov    0x60(%rbx),%r8
 10734ca:	mov    (%r8,%rdx,4),%edx
 10734ce:	lea    0x1(%rdx),%r12d
 10734d2:	cmp    %r14d,%edx
 10734d5:	cmovae %r14d,%r12d
 10734d9:	cmp    %eax,%edx
 10734db:	cmovbe %r14d,%r12d
 10734df:	mov    %r12d,%eax
 10734e2:	cmp    %r14d,%r12d
 10734e5:	jae    1073517 <check_input_run+0x6187>
 10734e7:	mov    %eax,%edx
 10734e9:	movzbl (%rcx,%rdx,1),%r8d
 10734ee:	cmp    $0x9,%r8d
 10734f2:	jg     10734c0 <check_input_run+0x6130>
 10734f4:	cmp    $0x6,%r8d
 10734f8:	je     10734c6 <check_input_run+0x6136>
 10734fa:	cmp    $0x8,%r8d
 10734fe:	je     10734c6 <check_input_run+0x6136>
 1073500:	jmp    1073508 <check_input_run+0x6178>
 1073502:	cmp    $0x33,%r8d
 1073506:	je     1073514 <check_input_run+0x6184>
 1073508:	inc    %eax
 107350a:	mov    %eax,%r12d
 107350d:	cmp    %r14d,%r12d
 1073510:	jb     10734e7 <check_input_run+0x6157>
 1073512:	jmp    1073517 <check_input_run+0x6187>
 1073514:	mov    %eax,%r12d
 1073517:	xor    %edx,%edx
 1073519:	cmp    %esi,%r10d
 107351c:	jae    1073c93 <check_input_run+0x6903>
 1073522:	cmp    %r12d,%edi
 1073525:	jae    1073c93 <check_input_run+0x6903>
 107352b:	mov    0x60(%rbx),%rdx
 107352f:	mov    %edi,%edi
 1073531:	mov    %r12d,%r8d
 1073534:	mov    %rdi,%rax
 1073537:	sub    %r8,%rax
 107353a:	sub    %rdi,%r8
 107353d:	mov    %r10d,0x130(%rsp)
 1073545:	mov    %r8,0x28(%rsp)
 107354a:	and    $0x7,%r8d
 107354e:	mov    %rdx,0x48(%rsp)
 1073553:	cmp    $0xfffffffffffffff8,%rax
 1073557:	jbe    1073567 <check_input_run+0x61d7>
 1073559:	xor    %r10d,%r10d
 107355c:	mov    $0xffffffff,%r15d
 1073562:	jmp    10736e0 <check_input_run+0x6350>
 1073567:	andq   $0xfffffffffffffff8,0x28(%rsp)
 107356d:	lea    0x1c(%rdx,%rdi,4),%r11
 1073572:	mov    $0xffffffff,%r15d
 1073578:	xor    %r10d,%r10d
 107357b:	xor    %ebx,%ebx
 107357d:	nopl   (%rax)
 1073580:	mov    -0x1c(%r11,%rbx,4),%eax
 1073585:	mov    -0x18(%r11,%rbx,4),%edx
 107358a:	cmp    %esi,%eax
 107358c:	setbe  %r9b
 1073590:	cmp    %r12d,%eax
 1073593:	setae  %al
 1073596:	or     %r9b,%al
 1073599:	lea    0x1(%rsi,%rbx,1),%r9d
 107359e:	movzbl %al,%eax
 10735a1:	add    %eax,%r10d
 10735a4:	test   %al,%al
 10735a6:	cmovne %r9d,%r15d
 10735aa:	cmp    %esi,%edx
 10735ac:	lea    0x2(%rsi,%rbx,1),%r9d
 10735b1:	setbe  %al
 10735b4:	cmp    %r12d,%edx
 10735b7:	setae  %dl
 10735ba:	or     %al,%dl
 10735bc:	movzbl %dl,%eax
 10735bf:	mov    -0x14(%r11,%rbx,4),%edx
 10735c4:	test   %al,%al
 10735c6:	cmove  %r15d,%r9d
 10735ca:	cmp    %esi,%edx
 10735cc:	setbe  %r15b
 10735d0:	cmp    %r12d,%edx
 10735d3:	setae  %dl
 10735d6:	or     %r15b,%dl
 10735d9:	movzbl %dl,%edx
 10735dc:	add    %edx,%eax
 10735de:	add    %r10d,%eax
 10735e1:	test   %dl,%dl
 10735e3:	mov    -0x10(%r11,%rbx,4),%edx
 10735e8:	lea    0x3(%rsi,%rbx,1),%r10d
 10735ed:	cmove  %r9d,%r10d
 10735f1:	cmp    %esi,%edx
 10735f3:	setbe  %r9b
 10735f7:	cmp    %r12d,%edx
 10735fa:	setae  %dl
 10735fd:	or     %r9b,%dl
 1073600:	lea    0x4(%rsi,%rbx,1),%r9d
 1073605:	movzbl %dl,%r15d
 1073609:	mov    -0xc(%r11,%rbx,4),%edx
 107360e:	test   %r15b,%r15b
 1073611:	cmove  %r10d,%r9d
 1073615:	cmp    %esi,%edx
 1073617:	setbe  %r10b
 107361b:	cmp    %r12d,%edx
 107361e:	setae  %dl
 1073621:	or     %r10b,%dl
 1073624:	lea    0x5(%rsi,%rbx,1),%r10d
 1073629:	movzbl %dl,%edx
 107362c:	add    %edx,%r15d
 107362f:	test   %dl,%dl
 1073631:	mov    -0x8(%r11,%rbx,4),%edx
 1073636:	cmove  %r9d,%r10d
 107363a:	cmp    %esi,%edx
 107363c:	setbe  %r9b
 1073640:	cmp    %r12d,%edx
 1073643:	setae  %dl
 1073646:	or     %r9b,%dl
 1073649:	movzbl %dl,%edx
 107364c:	add    %edx,%r15d
 107364f:	add    %eax,%r15d
 1073652:	test   %dl,%dl
 1073654:	mov    -0x4(%r11,%rbx,4),%edx
 1073659:	lea    0x6(%rsi,%rbx,1),%eax
 107365d:	cmove  %r10d,%eax
 1073661:	cmp    %esi,%edx
 1073663:	setbe  %r9b
 1073667:	cmp    %r12d,%edx
 107366a:	setae  %dl
 107366d:	or     %r9b,%dl
 1073670:	lea    0x7(%rsi,%rbx,1),%r9d
 1073675:	movzbl %dl,%r10d
 1073679:	test   %r10b,%r10b
 107367c:	cmove  %eax,%r9d
 1073680:	mov    (%r11,%rbx,4),%eax
 1073684:	cmp    %esi,%eax
 1073686:	setbe  %dl
 1073689:	cmp    %r12d,%eax
 107368c:	setae  %al
 107368f:	or     %dl,%al
 1073691:	movzbl %al,%eax
 1073694:	add    %eax,%r10d
 1073697:	add    %r15d,%r10d
 107369a:	lea    0x8(%rsi,%rbx,1),%r15d
 107369f:	test   %al,%al
 10736a1:	cmove  %r9d,%r15d
 10736a5:	add    $0x8,%rbx
 10736a9:	cmp    %rbx,0x28(%rsp)
 10736ae:	jne    1073580 <check_input_run+0x61f0>
 10736b4:	test   %r8,%r8
 10736b7:	je     1073892 <check_input_run+0x6502>
 10736bd:	add    %rbx,%rdi
 10736c0:	mov    0x30(%rsp),%r11
 10736c5:	mov    0x1b0(%rsp),%r9
 10736cd:	mov    0x58(%rsp),%rbx
 10736d2:	mov    0x48(%rsp),%rdx
 10736d7:	nopw   0x0(%rax,%rax,1)
 10736e0:	mov    (%rdx,%rdi,4),%eax
 10736e3:	cmp    %esi,%eax
 10736e5:	setbe  %dl
 10736e8:	cmp    %r12d,%eax
 10736eb:	setae  %al
 10736ee:	or     %dl,%al
 10736f0:	mov    0x48(%rsp),%rdx
 10736f5:	movzbl %al,%eax
 10736f8:	add    %eax,%r10d
 10736fb:	test   %al,%al
 10736fd:	cmovne %edi,%r15d
 1073701:	inc    %rdi
 1073704:	dec    %r8
 1073707:	jne    10736e0 <check_input_run+0x6350>
 1073709:	xor    %edx,%edx
 107370b:	cmp    $0x1,%r10d
 107370f:	jne    1073c93 <check_input_run+0x6903>
 1073715:	mov    0x130(%rsp),%edi
 107371c:	cmp    $0xffffffff,%r15d
 1073720:	je     1073c93 <check_input_run+0x6903>
 1073726:	mov    %edi,%eax
 1073728:	cmpb   $0x4b,(%rcx,%rax,1)
 107372c:	jne    107374d <check_input_run+0x63bd>
 107372e:	mov    0xc8(%rsp),%eax
 1073735:	inc    %edi
 1073737:	mov    %r15d,0xc8(%rsp)
 107373f:	xor    %esi,%edi
 1073741:	not    %eax
 1073743:	or     %edi,%eax
 1073745:	sete   %cl
 1073748:	jmp    107387d <check_input_run+0x64ed>
 107374d:	mov    0x450(%rsp),%rax
 1073755:	mov    0xc0(%rsp),%edx
 107375c:	mov    (%rax,%rsi,4),%eax
 107375f:	test   %eax,%eax
 1073761:	mov    %eax,0x48(%rsp)
 1073765:	setne  %al
 1073768:	test   %edx,%edx
 107376a:	mov    %edx,%edx
 107376c:	mov    %rdx,0x28(%rsp)
 1073771:	setne  %cl
 1073774:	and    %al,%cl
 1073776:	cmp    $0x1,%cl
 1073779:	jne    10737dd <check_input_run+0x644d>
 107377b:	mov    $0x1,%ebx
 1073780:	mov    0x2b8(%rsp),%rdi
 1073788:	mov    0x90(%rsp),%rax
 1073790:	mov    0x600(%rsp),%rcx
 1073798:	mov    0x48(%rsp),%esi
 107379c:	mov    0xd0(%rsp),%r9d
 10737a4:	mov    -0x4(%rax,%rbx,4),%edx
 10737a8:	mov    0xa0(%rdi),%r8d
 10737af:	vzeroupper
 10737b2:	call   10acf70 <type_compatible_at>
 10737b7:	mov    0x2a0(%rsp),%rdx
 10737bf:	cmp    $0x2,%eax
 10737c2:	sete   %cl
 10737c5:	or     %cl,0x3c5(%rdx)
 10737cb:	test   %eax,%eax
 10737cd:	sete   %al
 10737d0:	jne    10737dd <check_input_run+0x644d>
 10737d2:	cmp    0x28(%rsp),%rbx
 10737d7:	lea    0x1(%rbx),%rbx
 10737db:	jb     1073780 <check_input_run+0x63f0>
 10737dd:	test   %al,%al
 10737df:	je     1074060 <check_input_run+0x6cd0>
 10737e5:	mov    0x90(%rsp),%rax
 10737ed:	mov    0x48(%rsp),%esi
 10737f1:	mov    0x28(%rsp),%rcx
 10737f6:	incl   0xc0(%rsp)
 10737fd:	mov    0x100(%rsp),%edx
 1073804:	mov    0xd0(%rsp),%r9d
 107380c:	mov    %esi,(%rax,%rcx,4)
 107380f:	mov    0x2b8(%rsp),%rdi
 1073817:	mov    0x600(%rsp),%rcx
 107381f:	mov    0xa0(%rdi),%r8d
 1073826:	vzeroupper
 1073829:	call   10acf70 <type_compatible_at>
 107382e:	mov    0x2a0(%rsp),%rsi
 1073836:	mov    0xe8(%rsp),%edi
 107383d:	xor    %edx,%edx
 107383f:	cmp    $0x2,%eax
 1073842:	mov    0x30(%rsp),%r11
 1073847:	mov    0x1b0(%rsp),%r9
 107384f:	mov    0x58(%rsp),%rbx
 1073854:	vpxor  %xmm0,%xmm0,%xmm0
 1073858:	sete   %cl
 107385b:	setne  %dl
 107385e:	or     %cl,0x3c5(%rsi)
 1073864:	xor    %ecx,%ecx
 1073866:	cmp    $0xffffffff,%edi
 1073869:	sete   %cl
 107386c:	cmp    $0x1,%eax
 107386f:	cmove  %r15d,%edi
 1073873:	cmovne %edx,%ecx
 1073876:	mov    %edi,0xe8(%rsp)
 107387d:	inc    %r12d
 1073880:	cmp    %r14d,%r12d
 1073883:	jae    10738b5 <check_input_run+0x6525>
 1073885:	mov    %r12d,%r10d
 1073888:	test   %cl,%cl
 107388a:	jne    107343f <check_input_run+0x60af>
 1073890:	jmp    10738b5 <check_input_run+0x6525>
 1073892:	mov    0x30(%rsp),%r11
 1073897:	mov    0x1b0(%rsp),%r9
 107389f:	mov    0x58(%rsp),%rbx
 10738a4:	xor    %edx,%edx
 10738a6:	cmp    $0x1,%r10d
 10738aa:	je     1073715 <check_input_run+0x6385>
 10738b0:	jmp    1073c93 <check_input_run+0x6903>
 10738b5:	mov    0xe8(%rsp),%eax
 10738bc:	mov    0xc8(%rsp),%r8d
 10738c4:	cmp    $0xffffffff,%eax
 10738c7:	cmovne %eax,%r8d
 10738cb:	cmp    $0xffffffff,%r8d
 10738cf:	sete   %al
 10738d2:	xor    $0x1,%cl
 10738d5:	or     %al,%cl
 10738d7:	jne    1073c91 <check_input_run+0x6901>
 10738dd:	mov    0x440(%rsp),%rax
 10738e5:	mov    0x88(%rsp),%r10d
 10738ed:	mov    %r8d,(%rax,%r14,4)
 10738f1:	jmp    10738ff <check_input_run+0x656f>
 10738f3:	inc    %r10d
 10738f6:	cmp    %r14d,%r10d
 10738f9:	jae    1074078 <check_input_run+0x6ce8>
 10738ff:	mov    0x10(%rbx),%rcx
 1073903:	jmp    1073935 <check_input_run+0x65a5>
 1073905:	data16 cs nopw 0x0(%rax,%rax,1)
 1073910:	cmp    $0xa,%edx
 1073913:	jne    107394d <check_input_run+0x65bd>
 1073915:	mov    0x60(%rbx),%rdx
 1073919:	mov    (%rdx,%rax,4),%edx
 107391c:	lea    0x1(%rdx),%eax
 107391f:	cmp    %r14d,%edx
 1073922:	cmovae %r14d,%eax
 1073926:	cmp    %r10d,%edx
 1073929:	cmovbe %r14d,%eax
 107392d:	mov    %eax,%r10d
 1073930:	cmp    %r14d,%eax
 1073933:	jae    1073962 <check_input_run+0x65d2>
 1073935:	mov    %r10d,%eax
 1073938:	movzbl (%rcx,%rax,1),%edx
 107393c:	cmp    $0x9,%edx
 107393f:	jg     1073910 <check_input_run+0x6580>
 1073941:	cmp    $0x6,%edx
 1073944:	je     1073915 <check_input_run+0x6585>
 1073946:	cmp    $0x8,%edx
 1073949:	je     1073915 <check_input_run+0x6585>
 107394b:	jmp    1073952 <check_input_run+0x65c2>
 107394d:	cmp    $0x2f,%edx
 1073950:	je     107395f <check_input_run+0x65cf>
 1073952:	inc    %r10d
 1073955:	mov    %r10d,%eax
 1073958:	cmp    %r14d,%eax
 107395b:	jb     1073935 <check_input_run+0x65a5>
 107395d:	jmp    1073962 <check_input_run+0x65d2>
 107395f:	mov    %r10d,%eax
 1073962:	inc    %eax
 1073964:	mov    %eax,%r10d
 1073967:	cmp    %r14d,%eax
 107396a:	jae    10739c0 <check_input_run+0x6630>
 107396c:	mov    %eax,%edx
 107396e:	jmp    1073995 <check_input_run+0x6605>
 1073970:	cmp    $0xa,%edi
 1073973:	jne    10739ac <check_input_run+0x661c>
 1073975:	mov    0x60(%rbx),%rdi
 1073979:	mov    (%rdi,%rsi,4),%esi
 107397c:	lea    0x1(%rsi),%r10d
 1073980:	cmp    %r14d,%esi
 1073983:	cmovae %r14d,%r10d
 1073987:	cmp    %edx,%esi
 1073989:	cmovbe %r14d,%r10d
 107398d:	mov    %r10d,%edx
 1073990:	cmp    %r14d,%r10d
 1073993:	jae    10739c0 <check_input_run+0x6630>
 1073995:	mov    %edx,%esi
 1073997:	movzbl (%rcx,%rsi,1),%edi
 107399b:	cmp    $0x9,%edi
 107399e:	jg     1073970 <check_input_run+0x65e0>
 10739a0:	cmp    $0x6,%edi
 10739a3:	je     1073975 <check_input_run+0x65e5>
 10739a5:	cmp    $0x8,%edi
 10739a8:	je     1073975 <check_input_run+0x65e5>
 10739aa:	jmp    10739b1 <check_input_run+0x6621>
 10739ac:	cmp    $0x33,%edi
 10739af:	je     10739bd <check_input_run+0x662d>
 10739b1:	inc    %edx
 10739b3:	mov    %edx,%r10d
 10739b6:	cmp    %r14d,%r10d
 10739b9:	jb     1073995 <check_input_run+0x6605>
 10739bb:	jmp    10739c0 <check_input_run+0x6630>
 10739bd:	mov    %edx,%r10d
 10739c0:	cmp    %eax,%r8d
 10739c3:	jb     10739ce <check_input_run+0x663e>
 10739c5:	cmp    %r10d,%r8d
 10739c8:	jb     10738f3 <check_input_run+0x6563>
 10739ce:	cmp    %r10d,%eax
 10739d1:	jae    1073a5f <check_input_run+0x66cf>
 10739d7:	mov    0x2a0(%rsp),%rcx
 10739df:	cmpq   $0x0,0x2c8(%rcx)
 10739e7:	je     1073a5f <check_input_run+0x66cf>
 10739e9:	mov    0x2a8(%rsp),%rcx
 10739f1:	cmp    0x30(%rcx),%r10d
 10739f5:	ja     1073a5f <check_input_run+0x66cf>
 10739f7:	mov    %r10d,%edx
 10739fa:	sub    %eax,%edx
 10739fc:	mov    %eax,%esi
 10739fe:	mov    %rsi,%rcx
 1073a01:	and    $0x3,%edx
 1073a04:	je     1073a53 <check_input_run+0x66c3>
 1073a06:	mov    %rsi,%rcx
 1073a09:	jmp    1073a13 <check_input_run+0x6683>
 1073a0b:	inc    %rcx
 1073a0e:	dec    %rdx
 1073a11:	je     1073a53 <check_input_run+0x66c3>
 1073a13:	mov    0x520(%rsp),%rdi
 1073a1b:	test   %rdi,%rdi
 1073a1e:	je     1073a26 <check_input_run+0x6696>
 1073a20:	testb  $0x2,(%rdi,%rcx,1)
 1073a24:	jne    1073a0b <check_input_run+0x667b>
 1073a26:	mov    0x2a0(%rsp),%rdi
 1073a2e:	mov    0x2c8(%rdi),%rdi
 1073a35:	andb   $0xf7,(%rdi,%rcx,1)
 1073a39:	mov    0x2a0(%rsp),%rdi
 1073a41:	mov    0x2d0(%rdi),%rdi
 1073a48:	test   %rdi,%rdi
 1073a4b:	je     1073a0b <check_input_run+0x667b>
 1073a4d:	andb   $0xf7,(%rdi,%rcx,1)
 1073a51:	jmp    1073a0b <check_input_run+0x667b>
 1073a53:	mov    %r10d,%edx
 1073a56:	sub    %rdx,%rsi
 1073a59:	cmp    $0xfffffffffffffffc,%rsi
 1073a5d:	jbe    1073aad <check_input_run+0x671d>
 1073a5f:	cmp    %r10d,%eax
 1073a62:	jae    10738f3 <check_input_run+0x6563>
 1073a68:	cmpq   $0x0,0x528(%rsp)
 1073a71:	je     10738f3 <check_input_run+0x6563>
 1073a77:	mov    0x2a8(%rsp),%rcx
 1073a7f:	cmp    0x30(%rcx),%r10d
 1073a83:	ja     10738f3 <check_input_run+0x6563>
 1073a89:	mov    %r10d,%ecx
 1073a8c:	sub    %eax,%ecx
 1073a8e:	mov    %eax,%edx
 1073a90:	mov    %rdx,%rax
 1073a93:	and    $0x3,%ecx
 1073a96:	je     1073be4 <check_input_run+0x6854>
 1073a9c:	mov    %rdx,%rax
 1073a9f:	jmp    1073bcf <check_input_run+0x683f>
 1073aa4:	add    $0x4,%rcx
 1073aa8:	cmp    %rcx,%rdx
 1073aab:	je     1073a5f <check_input_run+0x66cf>
 1073aad:	mov    0x520(%rsp),%rsi
 1073ab5:	test   %rsi,%rsi
 1073ab8:	je     1073ac0 <check_input_run+0x6730>
 1073aba:	testb  $0x2,(%rsi,%rcx,1)
 1073abe:	jne    1073aeb <check_input_run+0x675b>
 1073ac0:	mov    0x2a0(%rsp),%rsi
 1073ac8:	mov    0x2c8(%rsi),%rsi
 1073acf:	andb   $0xf7,(%rsi,%rcx,1)
 1073ad3:	mov    0x2a0(%rsp),%rsi
 1073adb:	mov    0x2d0(%rsi),%rsi
 1073ae2:	test   %rsi,%rsi
 1073ae5:	je     1073aeb <check_input_run+0x675b>
 1073ae7:	andb   $0xf7,(%rsi,%rcx,1)
 1073aeb:	mov    0x520(%rsp),%rsi
 1073af3:	test   %rsi,%rsi
 1073af6:	je     1073aff <check_input_run+0x676f>
 1073af8:	testb  $0x2,0x1(%rsi,%rcx,1)
 1073afd:	jne    1073b2c <check_input_run+0x679c>
 1073aff:	mov    0x2a0(%rsp),%rsi
 1073b07:	mov    0x2c8(%rsi),%rsi
 1073b0e:	andb   $0xf7,0x1(%rsi,%rcx,1)
 1073b13:	mov    0x2a0(%rsp),%rsi
 1073b1b:	mov    0x2d0(%rsi),%rsi
 1073b22:	test   %rsi,%rsi
 1073b25:	je     1073b2c <check_input_run+0x679c>
 1073b27:	andb   $0xf7,0x1(%rsi,%rcx,1)
 1073b2c:	mov    0x520(%rsp),%rsi
 1073b34:	test   %rsi,%rsi
 1073b37:	je     1073b40 <check_input_run+0x67b0>
 1073b39:	testb  $0x2,0x2(%rsi,%rcx,1)
 1073b3e:	jne    1073b6d <check_input_run+0x67dd>
 1073b40:	mov    0x2a0(%rsp),%rsi
 1073b48:	mov    0x2c8(%rsi),%rsi
 1073b4f:	andb   $0xf7,0x2(%rsi,%rcx,1)
 1073b54:	mov    0x2a0(%rsp),%rsi
 1073b5c:	mov    0x2d0(%rsi),%rsi
 1073b63:	test   %rsi,%rsi
 1073b66:	je     1073b6d <check_input_run+0x67dd>
 1073b68:	andb   $0xf7,0x2(%rsi,%rcx,1)
 1073b6d:	mov    0x520(%rsp),%rsi
 1073b75:	test   %rsi,%rsi
 1073b78:	je     1073b85 <check_input_run+0x67f5>
 1073b7a:	testb  $0x2,0x3(%rsi,%rcx,1)
 1073b7f:	jne    1073aa4 <check_input_run+0x6714>
 1073b85:	mov    0x2a0(%rsp),%rsi
 1073b8d:	mov    0x2c8(%rsi),%rsi
 1073b94:	andb   $0xf7,0x3(%rsi,%rcx,1)
 1073b99:	mov    0x2a0(%rsp),%rsi
 1073ba1:	mov    0x2d0(%rsi),%rsi
 1073ba8:	test   %rsi,%rsi
 1073bab:	je     1073aa4 <check_input_run+0x6714>
 1073bb1:	andb   $0xf7,0x3(%rsi,%rcx,1)
 1073bb6:	jmp    1073aa4 <check_input_run+0x6714>
 1073bbb:	mov    0x528(%rsp),%rsi
 1073bc3:	orb    $0x8,(%rsi,%rax,1)
 1073bc7:	inc    %rax
 1073bca:	dec    %rcx
 1073bcd:	je     1073be4 <check_input_run+0x6854>
 1073bcf:	mov    0x520(%rsp),%rsi
 1073bd7:	test   %rsi,%rsi
 1073bda:	je     1073bbb <check_input_run+0x682b>
 1073bdc:	testb  $0x2,(%rsi,%rax,1)
 1073be0:	je     1073bbb <check_input_run+0x682b>
 1073be2:	jmp    1073bc7 <check_input_run+0x6837>
 1073be4:	mov    %r10d,%ecx
 1073be7:	sub    %rcx,%rdx
 1073bea:	cmp    $0xfffffffffffffffc,%rdx
 1073bee:	jbe    1073c0f <check_input_run+0x687f>
 1073bf0:	jmp    10738f3 <check_input_run+0x6563>
 1073bf5:	mov    0x528(%rsp),%rdx
 1073bfd:	orb    $0x8,0x3(%rdx,%rax,1)
 1073c02:	add    $0x4,%rax
 1073c06:	cmp    %rax,%rcx
 1073c09:	je     10738f3 <check_input_run+0x6563>
 1073c0f:	mov    0x520(%rsp),%rdx
 1073c17:	test   %rdx,%rdx
 1073c1a:	je     1073c22 <check_input_run+0x6892>
 1073c1c:	testb  $0x2,(%rdx,%rax,1)
 1073c20:	jne    1073c2e <check_input_run+0x689e>
 1073c22:	mov    0x528(%rsp),%rdx
 1073c2a:	orb    $0x8,(%rdx,%rax,1)
 1073c2e:	mov    0x520(%rsp),%rdx
 1073c36:	test   %rdx,%rdx
 1073c39:	je     1073c42 <check_input_run+0x68b2>
 1073c3b:	testb  $0x2,0x1(%rdx,%rax,1)
 1073c40:	jne    1073c4f <check_input_run+0x68bf>
 1073c42:	mov    0x528(%rsp),%rdx
 1073c4a:	orb    $0x8,0x1(%rdx,%rax,1)
 1073c4f:	mov    0x520(%rsp),%rdx
 1073c57:	test   %rdx,%rdx
 1073c5a:	je     1073c63 <check_input_run+0x68d3>
 1073c5c:	testb  $0x2,0x2(%rdx,%rax,1)
 1073c61:	jne    1073c70 <check_input_run+0x68e0>
 1073c63:	mov    0x528(%rsp),%rdx
 1073c6b:	orb    $0x8,0x2(%rdx,%rax,1)
 1073c70:	mov    0x520(%rsp),%rdx
 1073c78:	test   %rdx,%rdx
 1073c7b:	je     1073bf5 <check_input_run+0x6865>
 1073c81:	testb  $0x2,0x3(%rdx,%rax,1)
 1073c86:	je     1073bf5 <check_input_run+0x6865>
 1073c8c:	jmp    1073c02 <check_input_run+0x6872>
 1073c91:	xor    %edx,%edx
 1073c93:	mov    0x2c8(%rsp),%rax
 1073c9b:	mov    0xd8(%rsp),%rcx
 1073ca3:	cmp    0x8(%rax),%rcx
 1073ca7:	ja     107a8df <check_input_run+0xd54f>
 1073cad:	mov    %rcx,0x8(%rax)
 1073cb1:	mov    0x20(%rsp),%r12
 1073cb6:	mov    0x70(%rsp),%edi
 1073cba:	lea    0x700(%rsp),%r15
 1073cc2:	mov    0x2a0(%rsp),%rax
 1073cca:	cmpq   $0x0,0x2c8(%rax)
 1073cd2:	je     1073d4b <check_input_run+0x69bb>
 1073cd4:	mov    0x2a8(%rsp),%rax
 1073cdc:	cmp    0x30(%rax),%ebp
 1073cdf:	ja     1073d4b <check_input_run+0x69bb>
 1073ce1:	mov    %ebp,%ecx
 1073ce3:	sub    %edi,%ecx
 1073ce5:	mov    %edi,%esi
 1073ce7:	mov    %rsi,%rax
 1073cea:	and    $0x3,%ecx
 1073ced:	je     1073d3c <check_input_run+0x69ac>
 1073cef:	mov    %rsi,%rax
 1073cf2:	jmp    1073cfc <check_input_run+0x696c>
 1073cf4:	inc    %rax
 1073cf7:	dec    %rcx
 1073cfa:	je     1073d3c <check_input_run+0x69ac>
 1073cfc:	mov    0x520(%rsp),%rdi
 1073d04:	test   %rdi,%rdi
 1073d07:	je     1073d0f <check_input_run+0x697f>
 1073d09:	testb  $0x2,(%rdi,%rax,1)
 1073d0d:	jne    1073cf4 <check_input_run+0x6964>
 1073d0f:	mov    0x2a0(%rsp),%rdi
 1073d17:	mov    0x2c8(%rdi),%rdi
 1073d1e:	andb   $0x87,(%rdi,%rax,1)
 1073d22:	mov    0x2a0(%rsp),%rdi
 1073d2a:	mov    0x2d0(%rdi),%rdi
 1073d31:	test   %rdi,%rdi
 1073d34:	je     1073cf4 <check_input_run+0x6964>
 1073d36:	andb   $0x87,(%rdi,%rax,1)
 1073d3a:	jmp    1073cf4 <check_input_run+0x6964>
 1073d3c:	mov    0x70(%rsp),%edi
 1073d40:	mov    %ebp,%ecx
 1073d42:	sub    %rcx,%rsi
 1073d45:	cmp    $0xfffffffffffffffc,%rsi
 1073d49:	jbe    1073d8e <check_input_run+0x69fe>
 1073d4b:	cmpq   $0x0,0x528(%rsp)
 1073d54:	je     1073ed0 <check_input_run+0x6b40>
 1073d5a:	mov    0x2a8(%rsp),%rax
 1073d62:	cmp    0x30(%rax),%ebp
 1073d65:	ja     1073ed0 <check_input_run+0x6b40>
 1073d6b:	mov    %ebp,%ecx
 1073d6d:	sub    %edi,%ecx
 1073d6f:	mov    %edi,%esi
 1073d71:	mov    %rsi,%rax
 1073d74:	and    $0x3,%ecx
 1073d77:	je     1073ec5 <check_input_run+0x6b35>
 1073d7d:	mov    %rsi,%rax
 1073d80:	jmp    1073eb0 <check_input_run+0x6b20>
 1073d85:	add    $0x4,%rax
 1073d89:	cmp    %rax,%rcx
 1073d8c:	je     1073d4b <check_input_run+0x69bb>
 1073d8e:	mov    0x520(%rsp),%rsi
 1073d96:	test   %rsi,%rsi
 1073d99:	je     1073da1 <check_input_run+0x6a11>
 1073d9b:	testb  $0x2,(%rsi,%rax,1)
 1073d9f:	jne    1073dcc <check_input_run+0x6a3c>
 1073da1:	mov    0x2a0(%rsp),%rsi
 1073da9:	mov    0x2c8(%rsi),%rsi
 1073db0:	andb   $0x87,(%rsi,%rax,1)
 1073db4:	mov    0x2a0(%rsp),%rsi
 1073dbc:	mov    0x2d0(%rsi),%rsi
 1073dc3:	test   %rsi,%rsi
 1073dc6:	je     1073dcc <check_input_run+0x6a3c>
 1073dc8:	andb   $0x87,(%rsi,%rax,1)
 1073dcc:	mov    0x520(%rsp),%rsi
 1073dd4:	test   %rsi,%rsi
 1073dd7:	je     1073de0 <check_input_run+0x6a50>
 1073dd9:	testb  $0x2,0x1(%rsi,%rax,1)
 1073dde:	jne    1073e0d <check_input_run+0x6a7d>
 1073de0:	mov    0x2a0(%rsp),%rsi
 1073de8:	mov    0x2c8(%rsi),%rsi
 1073def:	andb   $0x87,0x1(%rsi,%rax,1)
 1073df4:	mov    0x2a0(%rsp),%rsi
 1073dfc:	mov    0x2d0(%rsi),%rsi
 1073e03:	test   %rsi,%rsi
 1073e06:	je     1073e0d <check_input_run+0x6a7d>
 1073e08:	andb   $0x87,0x1(%rsi,%rax,1)
 1073e0d:	mov    0x520(%rsp),%rsi
 1073e15:	test   %rsi,%rsi
 1073e18:	je     1073e21 <check_input_run+0x6a91>
 1073e1a:	testb  $0x2,0x2(%rsi,%rax,1)
 1073e1f:	jne    1073e4e <check_input_run+0x6abe>
 1073e21:	mov    0x2a0(%rsp),%rsi
 1073e29:	mov    0x2c8(%rsi),%rsi
 1073e30:	andb   $0x87,0x2(%rsi,%rax,1)
 1073e35:	mov    0x2a0(%rsp),%rsi
 1073e3d:	mov    0x2d0(%rsi),%rsi
 1073e44:	test   %rsi,%rsi
 1073e47:	je     1073e4e <check_input_run+0x6abe>
 1073e49:	andb   $0x87,0x2(%rsi,%rax,1)
 1073e4e:	mov    0x520(%rsp),%rsi
 1073e56:	test   %rsi,%rsi
 1073e59:	je     1073e66 <check_input_run+0x6ad6>
 1073e5b:	testb  $0x2,0x3(%rsi,%rax,1)
 1073e60:	jne    1073d85 <check_input_run+0x69f5>
 1073e66:	mov    0x2a0(%rsp),%rsi
 1073e6e:	mov    0x2c8(%rsi),%rsi
 1073e75:	andb   $0x87,0x3(%rsi,%rax,1)
 1073e7a:	mov    0x2a0(%rsp),%rsi
 1073e82:	mov    0x2d0(%rsi),%rsi
 1073e89:	test   %rsi,%rsi
 1073e8c:	je     1073d85 <check_input_run+0x69f5>
 1073e92:	andb   $0x87,0x3(%rsi,%rax,1)
 1073e97:	jmp    1073d85 <check_input_run+0x69f5>
 1073e9c:	mov    0x528(%rsp),%rdi
 1073ea4:	orb    $0x78,(%rdi,%rax,1)
 1073ea8:	inc    %rax
 1073eab:	dec    %rcx
 1073eae:	je     1073ec5 <check_input_run+0x6b35>
 1073eb0:	mov    0x520(%rsp),%rdi
 1073eb8:	test   %rdi,%rdi
 1073ebb:	je     1073e9c <check_input_run+0x6b0c>
 1073ebd:	testb  $0x2,(%rdi,%rax,1)
 1073ec1:	je     1073e9c <check_input_run+0x6b0c>
 1073ec3:	jmp    1073ea8 <check_input_run+0x6b18>
 1073ec5:	mov    %ebp,%ecx
 1073ec7:	sub    %rcx,%rsi
 1073eca:	cmp    $0xfffffffffffffffc,%rsi
 1073ece:	jbe    1073ef3 <check_input_run+0x6b63>
 1073ed0:	test   %dl,%dl
 1073ed2:	jne    10730cc <check_input_run+0x5d3c>
 1073ed8:	jmp    10731c3 <check_input_run+0x5e33>
 1073edd:	mov    0x528(%rsp),%rsi
 1073ee5:	orb    $0x78,0x3(%rsi,%rax,1)
 1073eea:	add    $0x4,%rax
 1073eee:	cmp    %rax,%rcx
 1073ef1:	je     1073ed0 <check_input_run+0x6b40>
 1073ef3:	mov    0x520(%rsp),%rsi
 1073efb:	test   %rsi,%rsi
 1073efe:	je     1073f06 <check_input_run+0x6b76>
 1073f00:	testb  $0x2,(%rsi,%rax,1)
 1073f04:	jne    1073f12 <check_input_run+0x6b82>
 1073f06:	mov    0x528(%rsp),%rsi
 1073f0e:	orb    $0x78,(%rsi,%rax,1)
 1073f12:	mov    0x520(%rsp),%rsi
 1073f1a:	test   %rsi,%rsi
 1073f1d:	je     1073f26 <check_input_run+0x6b96>
 1073f1f:	testb  $0x2,0x1(%rsi,%rax,1)
 1073f24:	jne    1073f33 <check_input_run+0x6ba3>
 1073f26:	mov    0x528(%rsp),%rsi
 1073f2e:	orb    $0x78,0x1(%rsi,%rax,1)
 1073f33:	mov    0x520(%rsp),%rsi
 1073f3b:	test   %rsi,%rsi
 1073f3e:	je     1073f47 <check_input_run+0x6bb7>
 1073f40:	testb  $0x2,0x2(%rsi,%rax,1)
 1073f45:	jne    1073f54 <check_input_run+0x6bc4>
 1073f47:	mov    0x528(%rsp),%rsi
 1073f4f:	orb    $0x78,0x2(%rsi,%rax,1)
 1073f54:	mov    0x520(%rsp),%rsi
 1073f5c:	test   %rsi,%rsi
 1073f5f:	je     1073edd <check_input_run+0x6b4d>
 1073f65:	testb  $0x2,0x3(%rsi,%rax,1)
 1073f6a:	je     1073edd <check_input_run+0x6b4d>
 1073f70:	jmp    1073eea <check_input_run+0x6b5a>
 1073f75:	mov    %ecx,%r15d
 1073f78:	cmp    %r14d,%r15d
 1073f7b:	jae    10742db <check_input_run+0x6f4b>
 1073f81:	cmpl   $0x0,0x7d4(%rsp)
 1073f89:	jne    10742db <check_input_run+0x6f4b>
 1073f8f:	cmpl   $0x1,0x78c(%rsp)
 1073f97:	jne    10742db <check_input_run+0x6f4b>
 1073f9d:	mov    0x788(%rsp),%ecx
 1073fa4:	mov    %ecx,%eax
 1073fa6:	and    $0x10,%eax
 1073fa9:	mov    %ecx,0x90(%rsp)
 1073fb0:	shr    $0x4,%eax
 1073fb3:	test   $0x401,%ecx
 1073fb9:	sete   %cl
 1073fbc:	or     %al,%cl
 1073fbe:	jne    10742db <check_input_run+0x6f4b>
 1073fc4:	mov    0x2b8(%rsp),%rdi
 1073fcc:	lea    0x780(%rsp),%rsi
 1073fd4:	lea    0x700(%rsp),%rdx
 1073fdc:	vzeroupper
 1073fdf:	call   10abe30 <check_action_truth>
 1073fe4:	mov    0x1b0(%rsp),%r9
 1073fec:	mov    0x30(%rsp),%r11
 1073ff1:	vpxor  %xmm0,%xmm0,%xmm0
 1073ff5:	test   %al,%al
 1073ff7:	je     10742db <check_input_run+0x6f4b>
 1073ffd:	movzbl 0x700(%rsp),%ecx
 1074005:	lea    0x1(%r15),%edi
 1074009:	mov    %r14d,%esi
 107400c:	mov    %edi,%edx
 107400e:	test   %cl,%cl
 1074010:	cmovne %ebx,%edx
 1074013:	cmovne %r15d,%esi
 1074017:	cmp    %esi,%edx
 1074019:	jae    10742db <check_input_run+0x6f4b>
 107401f:	mov    0x60(%r9),%r10
 1074023:	mov    %esi,%r8d
 1074026:	mov    %rdx,%rax
 1074029:	sub    %r8,%rax
 107402c:	sub    %rdx,%r8
 107402f:	mov    %cl,0xd0(%rsp)
 1074036:	mov    %edi,0x130(%rsp)
 107403d:	mov    %r8,0x28(%rsp)
 1074042:	and    $0x7,%r8d
 1074046:	mov    %r10,0x48(%rsp)
 107404b:	cmp    $0xfffffffffffffff8,%rax
 107404f:	jbe    107407f <check_input_run+0x6cef>
 1074051:	xor    %ecx,%ecx
 1074053:	mov    $0xffffffff,%eax
 1074058:	mov    %rdx,%r9
 107405b:	jmp    10741e2 <check_input_run+0x6e52>
 1074060:	mov    0x30(%rsp),%r11
 1074065:	mov    0x1b0(%rsp),%r9
 107406d:	xor    %edx,%edx
 107406f:	vpxor  %xmm0,%xmm0,%xmm0
 1074073:	jmp    1073c93 <check_input_run+0x6903>
 1074078:	mov    $0x1,%dl
 107407a:	jmp    1073c93 <check_input_run+0x6903>
 107407f:	andq   $0xfffffffffffffff8,0x28(%rsp)
 1074085:	lea    0x1c(%r10,%rdx,4),%r11
 107408a:	mov    $0xffffffff,%eax
 107408f:	xor    %ecx,%ecx
 1074091:	xor    %r9d,%r9d
 1074094:	mov    -0x1c(%r11,%r9,4),%r12d
 1074099:	mov    -0x18(%r11,%r9,4),%edi
 107409e:	cmp    %edx,%r12d
 10740a1:	setb   %r10b
 10740a5:	cmp    %esi,%r12d
 10740a8:	setae  %r12b
 10740ac:	or     %r10b,%r12b
 10740af:	movzbl %r12b,%r10d
 10740b3:	lea    (%rdx,%r9,1),%r12d
 10740b7:	add    %r10d,%ecx
 10740ba:	test   %r10b,%r10b
 10740bd:	cmovne %r12d,%eax
 10740c1:	cmp    %edx,%edi
 10740c3:	setb   %r10b
 10740c7:	cmp    %esi,%edi
 10740c9:	setae  %dil
 10740cd:	or     %r10b,%dil
 10740d0:	lea    0x1(%rdx,%r9,1),%r10d
 10740d5:	movzbl %dil,%r12d
 10740d9:	test   %r12b,%r12b
 10740dc:	cmove  %eax,%r10d
 10740e0:	mov    -0x14(%r11,%r9,4),%eax
 10740e5:	cmp    %edx,%eax
 10740e7:	setb   %dil
 10740eb:	cmp    %esi,%eax
 10740ed:	setae  %al
 10740f0:	or     %dil,%al
 10740f3:	movzbl %al,%eax
 10740f6:	add    %eax,%r12d
 10740f9:	add    %ecx,%r12d
 10740fc:	test   %al,%al
 10740fe:	mov    -0x10(%r11,%r9,4),%eax
 1074103:	lea    0x2(%rdx,%r9,1),%ecx
 1074108:	cmove  %r10d,%ecx
 107410c:	cmp    %edx,%eax
 107410e:	setb   %dil
 1074112:	cmp    %esi,%eax
 1074114:	setae  %al
 1074117:	or     %dil,%al
 107411a:	lea    0x3(%rdx,%r9,1),%edi
 107411f:	movzbl %al,%eax
 1074122:	test   %al,%al
 1074124:	cmove  %ecx,%edi
 1074127:	mov    -0xc(%r11,%r9,4),%ecx
 107412c:	cmp    %edx,%ecx
 107412e:	setb   %r10b
 1074132:	cmp    %esi,%ecx
 1074134:	setae  %cl
 1074137:	or     %r10b,%cl
 107413a:	lea    0x4(%rdx,%r9,1),%r10d
 107413f:	movzbl %cl,%ecx
 1074142:	add    %ecx,%eax
 1074144:	test   %cl,%cl
 1074146:	mov    -0x8(%r11,%r9,4),%ecx
 107414b:	cmove  %edi,%r10d
 107414f:	cmp    %edx,%ecx
 1074151:	setb   %dil
 1074155:	cmp    %esi,%ecx
 1074157:	setae  %cl
 107415a:	or     %dil,%cl
 107415d:	lea    0x5(%rdx,%r9,1),%edi
 1074162:	movzbl %cl,%ecx
 1074165:	add    %ecx,%eax
 1074167:	add    %r12d,%eax
 107416a:	test   %cl,%cl
 107416c:	mov    -0x4(%r11,%r9,4),%ecx
 1074171:	cmove  %r10d,%edi
 1074175:	cmp    %edx,%ecx
 1074177:	setb   %r10b
 107417b:	cmp    %esi,%ecx
 107417d:	setae  %cl
 1074180:	or     %r10b,%cl
 1074183:	lea    0x6(%rdx,%r9,1),%r10d
 1074188:	movzbl %cl,%ecx
 107418b:	test   %cl,%cl
 107418d:	cmove  %edi,%r10d
 1074191:	mov    (%r11,%r9,4),%edi
 1074195:	cmp    %edx,%edi
 1074197:	setb   %r12b
 107419b:	cmp    %esi,%edi
 107419d:	setae  %dil
 10741a1:	or     %r12b,%dil
 10741a4:	movzbl %dil,%edi
 10741a8:	add    %edi,%ecx
 10741aa:	add    %eax,%ecx
 10741ac:	lea    0x7(%rdx,%r9,1),%eax
 10741b1:	test   %dil,%dil
 10741b4:	cmove  %r10d,%eax
 10741b8:	add    $0x8,%r9
 10741bc:	cmp    %r9,0x28(%rsp)
 10741c1:	jne    1074094 <check_input_run+0x6d04>
 10741c7:	test   %r8,%r8
 10741ca:	je     10742e8 <check_input_run+0x6f58>
 10741d0:	mov    0x20(%rsp),%r12
 10741d5:	mov    0x30(%rsp),%r11
 10741da:	mov    0x48(%rsp),%r10
 10741df:	add    %rdx,%r9
 10741e2:	mov    (%r10,%r9,4),%edi
 10741e6:	cmp    %edx,%edi
 10741e8:	setb   %r10b
 10741ec:	cmp    %esi,%edi
 10741ee:	setae  %dil
 10741f2:	or     %r10b,%dil
 10741f5:	mov    0x48(%rsp),%r10
 10741fa:	movzbl %dil,%edi
 10741fe:	add    %edi,%ecx
 1074200:	test   %dil,%dil
 1074203:	cmovne %r9d,%eax
 1074207:	inc    %r9
 107420a:	dec    %r8
 107420d:	jne    10741e2 <check_input_run+0x6e52>
 107420f:	mov    0x1b0(%rsp),%r9
 1074217:	movzbl 0xd0(%rsp),%esi
 107421f:	mov    0x130(%rsp),%edi
 1074226:	cmp    $0x1,%ecx
 1074229:	jne    10742db <check_input_run+0x6f4b>
 107422f:	cmp    $0xffffffff,%eax
 1074232:	je     10742db <check_input_run+0x6f4b>
 1074238:	mov    0x440(%rsp),%rcx
 1074240:	mov    %eax,(%rcx,%r14,4)
 1074244:	mov    0x2a0(%rsp),%rax
 107424c:	mov    0x2a8(%rsp),%rcx
 1074254:	cmp    0x30(%rcx),%ebp
 1074257:	ja     107431c <check_input_run+0x6f8c>
 107425d:	mov    0x2c8(%rax),%rdx
 1074264:	mov    0x90(%rsp),%r8d
 107426c:	test   %rdx,%rdx
 107426f:	sete   %cl
 1074272:	or     %cl,%r8b
 1074275:	test   $0x1,%r8b
 1074279:	jne    107431c <check_input_run+0x6f8c>
 107427f:	mov    0x70(%rsp),%ecx
 1074283:	movzbl (%rdx,%rcx,1),%esi
 1074287:	mov    %esi,%eax
 1074289:	or     $0x2,%al
 107428b:	mov    %al,(%rdx,%rcx,1)
 107428e:	mov    0x2a0(%rsp),%rax
 1074296:	mov    0x2d0(%rax),%rdx
 107429d:	test   %rdx,%rdx
 10742a0:	je     10742f7 <check_input_run+0x6f67>
 10742a2:	and    $0x2,%sil
 10742a6:	mov    0x20(%rsp),%r12
 10742ab:	mov    0x30(%rsp),%r11
 10742b0:	mov    0x1b0(%rsp),%r9
 10742b8:	movzbl 0xd0(%rsp),%esi
 10742c0:	mov    0x130(%rsp),%edi
 10742c7:	vpxor  %xmm0,%xmm0,%xmm0
 10742cb:	jne    107431c <check_input_run+0x6f8c>
 10742cd:	orb    $0x2,(%rdx,%rcx,1)
 10742d1:	mov    0x2a0(%rsp),%rax
 10742d9:	jmp    107431c <check_input_run+0x6f8c>
 10742db:	lea    0x700(%rsp),%r15
 10742e3:	jmp    10731c3 <check_input_run+0x5e33>
 10742e8:	mov    0x20(%rsp),%r12
 10742ed:	mov    0x30(%rsp),%r11
 10742f2:	jmp    107420f <check_input_run+0x6e7f>
 10742f7:	mov    0x20(%rsp),%r12
 10742fc:	mov    0x30(%rsp),%r11
 1074301:	mov    0x1b0(%rsp),%r9
 1074309:	movzbl 0xd0(%rsp),%esi
 1074311:	mov    0x130(%rsp),%edi
 1074318:	vpxor  %xmm0,%xmm0,%xmm0
 107431c:	test   %sil,%sil
 107431f:	cmovne %edi,%ebx
 1074322:	cmovne %r14d,%r15d
 1074326:	cmp    %r15d,%ebx
 1074329:	jae    10743c9 <check_input_run+0x7039>
 107432f:	cmpq   $0x0,0x2c8(%rax)
 1074337:	je     10743c9 <check_input_run+0x7039>
 107433d:	mov    0x2a8(%rsp),%rax
 1074345:	cmp    0x30(%rax),%r15d
 1074349:	ja     10743c9 <check_input_run+0x7039>
 107434b:	mov    %r15d,%ecx
 107434e:	sub    %ebx,%ecx
 1074350:	mov    %ebx,%edx
 1074352:	mov    %rdx,%rax
 1074355:	and    $0x3,%ecx
 1074358:	je     10743a7 <check_input_run+0x7017>
 107435a:	mov    %rdx,%rax
 107435d:	jmp    1074367 <check_input_run+0x6fd7>
 107435f:	inc    %rax
 1074362:	dec    %rcx
 1074365:	je     10743a7 <check_input_run+0x7017>
 1074367:	mov    0x520(%rsp),%rsi
 107436f:	test   %rsi,%rsi
 1074372:	je     107437a <check_input_run+0x6fea>
 1074374:	testb  $0x2,(%rsi,%rax,1)
 1074378:	jne    107435f <check_input_run+0x6fcf>
 107437a:	mov    0x2a0(%rsp),%rsi
 1074382:	mov    0x2c8(%rsi),%rsi
 1074389:	andb   $0xf7,(%rsi,%rax,1)
 107438d:	mov    0x2a0(%rsp),%rsi
 1074395:	mov    0x2d0(%rsi),%rsi
 107439c:	test   %rsi,%rsi
 107439f:	je     107435f <check_input_run+0x6fcf>
 10743a1:	andb   $0xf7,(%rsi,%rax,1)
 10743a5:	jmp    107435f <check_input_run+0x6fcf>
 10743a7:	mov    0x20(%rsp),%r12
 10743ac:	mov    0x30(%rsp),%r11
 10743b1:	mov    0x1b0(%rsp),%r9
 10743b9:	mov    %r15d,%ecx
 10743bc:	sub    %rcx,%rdx
 10743bf:	vpxor  %xmm0,%xmm0,%xmm0
 10743c3:	cmp    $0xfffffffffffffffc,%rdx
 10743c7:	jbe    1074417 <check_input_run+0x7087>
 10743c9:	cmp    %r15d,%ebx
 10743cc:	jae    1074570 <check_input_run+0x71e0>
 10743d2:	cmpq   $0x0,0x528(%rsp)
 10743db:	je     1074570 <check_input_run+0x71e0>
 10743e1:	mov    0x2a8(%rsp),%rax
 10743e9:	cmp    0x30(%rax),%r15d
 10743ed:	ja     1074570 <check_input_run+0x71e0>
 10743f3:	mov    %r15d,%ecx
 10743f6:	sub    %ebx,%ecx
 10743f8:	mov    %ebx,%edx
 10743fa:	mov    %rdx,%rax
 10743fd:	and    $0x3,%ecx
 1074400:	je     107454e <check_input_run+0x71be>
 1074406:	mov    %rdx,%rax
 1074409:	jmp    1074539 <check_input_run+0x71a9>
 107440e:	add    $0x4,%rax
 1074412:	cmp    %rax,%rcx
 1074415:	je     10743c9 <check_input_run+0x7039>
 1074417:	mov    0x520(%rsp),%rdx
 107441f:	test   %rdx,%rdx
 1074422:	je     107442a <check_input_run+0x709a>
 1074424:	testb  $0x2,(%rdx,%rax,1)
 1074428:	jne    1074455 <check_input_run+0x70c5>
 107442a:	mov    0x2a0(%rsp),%rdx
 1074432:	mov    0x2c8(%rdx),%rdx
 1074439:	andb   $0xf7,(%rdx,%rax,1)
 107443d:	mov    0x2a0(%rsp),%rdx
 1074445:	mov    0x2d0(%rdx),%rdx
 107444c:	test   %rdx,%rdx
 107444f:	je     1074455 <check_input_run+0x70c5>
 1074451:	andb   $0xf7,(%rdx,%rax,1)
 1074455:	mov    0x520(%rsp),%rdx
 107445d:	test   %rdx,%rdx
 1074460:	je     1074469 <check_input_run+0x70d9>
 1074462:	testb  $0x2,0x1(%rdx,%rax,1)
 1074467:	jne    1074496 <check_input_run+0x7106>
 1074469:	mov    0x2a0(%rsp),%rdx
 1074471:	mov    0x2c8(%rdx),%rdx
 1074478:	andb   $0xf7,0x1(%rdx,%rax,1)
 107447d:	mov    0x2a0(%rsp),%rdx
 1074485:	mov    0x2d0(%rdx),%rdx
 107448c:	test   %rdx,%rdx
 107448f:	je     1074496 <check_input_run+0x7106>
 1074491:	andb   $0xf7,0x1(%rdx,%rax,1)
 1074496:	mov    0x520(%rsp),%rdx
 107449e:	test   %rdx,%rdx
 10744a1:	je     10744aa <check_input_run+0x711a>
 10744a3:	testb  $0x2,0x2(%rdx,%rax,1)
 10744a8:	jne    10744d7 <check_input_run+0x7147>
 10744aa:	mov    0x2a0(%rsp),%rdx
 10744b2:	mov    0x2c8(%rdx),%rdx
 10744b9:	andb   $0xf7,0x2(%rdx,%rax,1)
 10744be:	mov    0x2a0(%rsp),%rdx
 10744c6:	mov    0x2d0(%rdx),%rdx
 10744cd:	test   %rdx,%rdx
 10744d0:	je     10744d7 <check_input_run+0x7147>
 10744d2:	andb   $0xf7,0x2(%rdx,%rax,1)
 10744d7:	mov    0x520(%rsp),%rdx
 10744df:	test   %rdx,%rdx
 10744e2:	je     10744ef <check_input_run+0x715f>
 10744e4:	testb  $0x2,0x3(%rdx,%rax,1)
 10744e9:	jne    107440e <check_input_run+0x707e>
 10744ef:	mov    0x2a0(%rsp),%rdx
 10744f7:	mov    0x2c8(%rdx),%rdx
 10744fe:	andb   $0xf7,0x3(%rdx,%rax,1)
 1074503:	mov    0x2a0(%rsp),%rdx
 107450b:	mov    0x2d0(%rdx),%rdx
 1074512:	test   %rdx,%rdx
 1074515:	je     107440e <check_input_run+0x707e>
 107451b:	andb   $0xf7,0x3(%rdx,%rax,1)
 1074520:	jmp    107440e <check_input_run+0x707e>
 1074525:	mov    0x528(%rsp),%rsi
 107452d:	orb    $0x8,(%rsi,%rax,1)
 1074531:	inc    %rax
 1074534:	dec    %rcx
 1074537:	je     107454e <check_input_run+0x71be>
 1074539:	mov    0x520(%rsp),%rsi
 1074541:	test   %rsi,%rsi
 1074544:	je     1074525 <check_input_run+0x7195>
 1074546:	testb  $0x2,(%rsi,%rax,1)
 107454a:	je     1074525 <check_input_run+0x7195>
 107454c:	jmp    1074531 <check_input_run+0x71a1>
 107454e:	mov    0x20(%rsp),%r12
 1074553:	mov    0x30(%rsp),%r11
 1074558:	mov    0x1b0(%rsp),%r9
 1074560:	mov    %r15d,%ecx
 1074563:	sub    %rcx,%rdx
 1074566:	vpxor  %xmm0,%xmm0,%xmm0
 107456a:	cmp    $0xfffffffffffffffc,%rdx
 107456e:	jbe    1074593 <check_input_run+0x7203>
 1074570:	lea    0x700(%rsp),%r15
 1074578:	jmp    10730cc <check_input_run+0x5d3c>
 107457d:	mov    0x528(%rsp),%rdx
 1074585:	orb    $0x8,0x3(%rdx,%rax,1)
 107458a:	add    $0x4,%rax
 107458e:	cmp    %rax,%rcx
 1074591:	je     1074570 <check_input_run+0x71e0>
 1074593:	mov    0x520(%rsp),%rdx
 107459b:	test   %rdx,%rdx
 107459e:	je     10745a6 <check_input_run+0x7216>
 10745a0:	testb  $0x2,(%rdx,%rax,1)
 10745a4:	jne    10745b2 <check_input_run+0x7222>
 10745a6:	mov    0x528(%rsp),%rdx
 10745ae:	orb    $0x8,(%rdx,%rax,1)
 10745b2:	mov    0x520(%rsp),%rdx
 10745ba:	test   %rdx,%rdx
 10745bd:	je     10745c6 <check_input_run+0x7236>
 10745bf:	testb  $0x2,0x1(%rdx,%rax,1)
 10745c4:	jne    10745d3 <check_input_run+0x7243>
 10745c6:	mov    0x528(%rsp),%rdx
 10745ce:	orb    $0x8,0x1(%rdx,%rax,1)
 10745d3:	mov    0x520(%rsp),%rdx
 10745db:	test   %rdx,%rdx
 10745de:	je     10745e7 <check_input_run+0x7257>
 10745e0:	testb  $0x2,0x2(%rdx,%rax,1)
 10745e5:	jne    10745f4 <check_input_run+0x7264>
 10745e7:	mov    0x528(%rsp),%rdx
 10745ef:	orb    $0x8,0x2(%rdx,%rax,1)
 10745f4:	mov    0x520(%rsp),%rdx
 10745fc:	test   %rdx,%rdx
 10745ff:	je     107457d <check_input_run+0x71ed>
 1074605:	testb  $0x2,0x3(%rdx,%rax,1)
 107460a:	je     107457d <check_input_run+0x71ed>
 1074610:	jmp    107458a <check_input_run+0x71fa>
 1074615:	mov    0x18(%rsp),%rax
 107461a:	mov    0x230(%rax),%eax
 1074620:	cmpb   $0x0,0x840(%rsp)
 1074628:	je     1074724 <check_input_run+0x7394>
 107462e:	test   %eax,%eax
 1074630:	jne    107472c <check_input_run+0x739c>
 1074636:	mov    0x2a8(%rsp),%rax
 107463e:	cmpl   $0x0,0x30(%rax)
 1074642:	je     107485b <check_input_run+0x74cb>
 1074648:	mov    0x2a0(%rsp),%rdx
 1074650:	xor    %ecx,%ecx
 1074652:	jmp    107466f <check_input_run+0x72df>
 1074654:	movb   $0x1,0x3c5(%rdx)
 107465b:	nopl   0x0(%rax,%rax,1)
 1074660:	mov    0x30(%rax),%esi
 1074663:	inc    %rcx
 1074666:	cmp    %rsi,%rcx
 1074669:	jae    1074719 <check_input_run+0x7389>
 107466f:	mov    0x2a0(%rdx),%rsi
 1074676:	cmpb   $0x0,(%rsi,%rcx,1)
 107467a:	je     1074660 <check_input_run+0x72d0>
 107467c:	mov    0x340(%rsp),%rsi
 1074684:	mov    0x2b8(%rsp),%r8
 107468c:	mov    (%rsi,%rcx,4),%edi
 107468f:	mov    (%r8),%r9
 1074692:	mov    0x10(%r8),%rsi
 1074696:	shr    $0x3,%edi
 1074699:	movzbl (%r9,%rdi,1),%r9d
 107469e:	cmp    $0xf,%r9b
 10746a2:	jne    10746b7 <check_input_run+0x7327>
 10746a4:	mov    0x20(%r8),%r8
 10746a8:	mov    (%r8,%rdi,4),%edi
 10746ac:	shr    $0x3,%edi
 10746af:	testb  $0x4,(%rsi,%rdi,1)
 10746b3:	jne    1074660 <check_input_run+0x72d0>
 10746b5:	jmp    10746c7 <check_input_run+0x7337>
 10746b7:	cmp    $0x9,%r9b
 10746bb:	je     1074660 <check_input_run+0x72d0>
 10746bd:	movzbl (%rsi,%rdi,1),%esi
 10746c1:	and    $0x4,%sil
 10746c5:	jne    1074660 <check_input_run+0x72d0>
 10746c7:	mov    0x230(%rdx),%esi
 10746cd:	cmp    0x234(%rdx),%esi
 10746d3:	jae    1074654 <check_input_run+0x72c4>
 10746d9:	movzbl 0x3c5(%rdx),%edi
 10746e0:	mov    0x228(%rdx),%r8
 10746e7:	lea    0x1(%rsi),%r9d
 10746eb:	mov    %r9d,0x230(%rdx)
 10746f2:	lea    (%rsi,%rsi,2),%rdx
 10746f6:	lea    0x1(%rdi,%rdi,2),%edi
 10746fa:	mov    %ecx,(%r8,%rdx,4)
 10746fe:	mov    %edi,0x4(%r8,%rdx,4)
 1074703:	movl   $0x0,0x8(%r8,%rdx,4)
 107470c:	mov    0x2a0(%rsp),%rdx
 1074714:	jmp    1074660 <check_input_run+0x72d0>
 1074719:	mov    0x18(%rsp),%rax
 107471e:	mov    0x230(%rax),%eax
 1074724:	test   %eax,%eax
 1074726:	je     107485b <check_input_run+0x74cb>
 107472c:	mov    0x670(%rsp),%edi
 1074733:	mov    %eax,%edx
 1074735:	mov    %edx,%ecx
 1074737:	and    $0x7,%ecx
 107473a:	cmp    $0x8,%eax
 107473d:	jae    1074746 <check_input_run+0x73b6>
 107473f:	xor    %eax,%eax
 1074741:	jmp    1074836 <check_input_run+0x74a6>
 1074746:	shr    $0x3,%edx
 1074749:	xor    %eax,%eax
 107474b:	xor    %esi,%esi
 107474d:	shl    $0x5,%rdx
 1074751:	lea    (%rdx,%rdx,2),%rdx
 1074755:	jmp    1074778 <check_input_run+0x73e8>
 1074757:	nopw   0x0(%rax,%rax,1)
 1074760:	add    $0x8,%rax
 1074764:	add    $0x60,%rsi
 1074768:	mov    %edi,0x670(%rsp)
 107476f:	cmp    %rsi,%rdx
 1074772:	je     1074831 <check_input_run+0x74a1>
 1074778:	mov    (%r11),%r8
 107477b:	mov    (%r8,%rsi,1),%r8d
 107477f:	cmp    %edi,%r8d
 1074782:	jb     1074787 <check_input_run+0x73f7>
 1074784:	mov    %edi,%r8d
 1074787:	mov    %r8d,0x670(%rsp)
 107478f:	mov    (%r11),%rdi
 1074792:	mov    0xc(%rdi,%rsi,1),%edi
 1074796:	cmp    %r8d,%edi
 1074799:	jb     107479e <check_input_run+0x740e>
 107479b:	mov    %r8d,%edi
 107479e:	mov    %edi,0x670(%rsp)
 10747a5:	mov    (%r11),%r8
 10747a8:	mov    0x18(%r8,%rsi,1),%r8d
 10747ad:	cmp    %edi,%r8d
 10747b0:	jb     10747b5 <check_input_run+0x7425>
 10747b2:	mov    %edi,%r8d
 10747b5:	mov    %r8d,0x670(%rsp)
 10747bd:	mov    (%r11),%rdi
 10747c0:	mov    0x24(%rdi,%rsi,1),%edi
 10747c4:	cmp    %r8d,%edi
 10747c7:	jb     10747cc <check_input_run+0x743c>
 10747c9:	mov    %r8d,%edi
 10747cc:	mov    %edi,0x670(%rsp)
 10747d3:	mov    (%r11),%r8
 10747d6:	mov    0x30(%r8,%rsi,1),%r8d
 10747db:	cmp    %edi,%r8d
 10747de:	jb     10747e3 <check_input_run+0x7453>
 10747e0:	mov    %edi,%r8d
 10747e3:	mov    %r8d,0x670(%rsp)
 10747eb:	mov    (%r11),%rdi
 10747ee:	mov    0x3c(%rdi,%rsi,1),%edi
 10747f2:	cmp    %r8d,%edi
 10747f5:	jb     10747fa <check_input_run+0x746a>
 10747f7:	mov    %r8d,%edi
 10747fa:	mov    %edi,0x670(%rsp)
 1074801:	mov    (%r11),%r8
 1074804:	mov    0x48(%r8,%rsi,1),%r8d
 1074809:	cmp    %edi,%r8d
 107480c:	jb     1074811 <check_input_run+0x7481>
 107480e:	mov    %edi,%r8d
 1074811:	mov    %r8d,0x670(%rsp)
 1074819:	mov    (%r11),%rdi
 107481c:	mov    0x54(%rdi,%rsi,1),%edi
 1074820:	cmp    %r8d,%edi
 1074823:	jb     1074760 <check_input_run+0x73d0>
 1074829:	mov    %r8d,%edi
 107482c:	jmp    1074760 <check_input_run+0x73d0>
 1074831:	test   %rcx,%rcx
 1074834:	je     107485b <check_input_run+0x74cb>
 1074836:	shl    $0x2,%rax
 107483a:	lea    (%rax,%rax,2),%rax
 107483e:	xchg   %ax,%ax
 1074840:	mov    (%r11),%rdx
 1074843:	mov    (%rdx,%rax,1),%edx
 1074846:	cmp    %edi,%edx
 1074848:	cmovb  %edx,%edi
 107484b:	add    $0xc,%rax
 107484f:	dec    %rcx
 1074852:	mov    %edi,0x670(%rsp)
 1074859:	jne    1074840 <check_input_run+0x74b0>
 107485b:	mov    0xa0(%rsp),%rax
 1074863:	mov    0xa0(%rax),%ebx
 1074869:	test   %rbx,%rbx
 107486c:	je     107488f <check_input_run+0x74ff>
 107486e:	mov    0x10(%rsp),%rax
 1074873:	mov    (%rax),%rcx
 1074876:	mov    0x8(%rax),%rax
 107487a:	lea    0x3(%rax,%rcx,1),%r15
 107487f:	add    %rcx,%rax
 1074882:	and    $0xfffffffffffffffc,%r15
 1074886:	cmp    %rax,%r15
 1074889:	jae    1074921 <check_input_run+0x7591>
 107488f:	mov    0x18(%rsp),%rcx
 1074894:	test   %ebx,%ebx
 1074896:	setne  %al
 1074899:	or     %al,0x3c5(%rcx)
 107489f:	mov    0x600(%rsp),%rsi
 10748a7:	mov    0x10(%rsp),%rdx
 10748ac:	test   %ebx,%ebx
 10748ae:	setne  %al
 10748b1:	test   %rsi,%rsi
 10748b4:	setne  %cl
 10748b7:	and    %al,%cl
 10748b9:	cmp    $0x1,%cl
 10748bc:	jne    10748e6 <check_input_run+0x7556>
 10748be:	mov    (%rdx),%rcx
 10748c1:	mov    0x8(%rdx),%rax
 10748c5:	lea    0x3(%rax,%rcx,1),%r15
 10748ca:	add    %rcx,%rax
 10748cd:	and    $0xfffffffffffffffc,%r15
 10748d1:	cmp    %rax,%r15
 10748d4:	jae    10749a8 <check_input_run+0x7618>
 10748da:	mov    0x18(%rsp),%rax
 10748df:	movb   $0x1,0x3c5(%rax)
 10748e6:	cmpl   $0x0,0xf0(%rsp)
 10748ee:	mov    0x18(%rsp),%rax
 10748f3:	je     1074911 <check_input_run+0x7581>
 10748f5:	mov    0x78(%rsp),%rdx
 10748fa:	mov    0x40(%rsp),%r14
 10748ff:	xor    %eax,%eax
 1074901:	cmp    $0x1,%edx
 1074904:	jne    1074994 <check_input_run+0x7604>
 107490a:	xor    %ecx,%ecx
 107490c:	jmp    1074c44 <check_input_run+0x78b4>
 1074911:	mov    0xdc(%rax),%edi
 1074917:	mov    0x40(%rsp),%r14
 107491c:	jmp    1074c77 <check_input_run+0x78e7>
 1074921:	mov    %r15,%rax
 1074924:	sub    %rcx,%rax
 1074927:	mov    0x10(%rsp),%rcx
 107492c:	mov    0x10(%rcx),%rcx
 1074930:	sub    %rax,%rcx
 1074933:	jb     107488f <check_input_run+0x74ff>
 1074939:	lea    0x0(,%rbx,4),%rdx
 1074941:	cmp    %rcx,%rdx
 1074944:	ja     107488f <check_input_run+0x74ff>
 107494a:	mov    0x10(%rsp),%rcx
 107494f:	mov    0x18(%rsp),%rsi
 1074954:	add    %rdx,%rax
 1074957:	test   %r15,%r15
 107495a:	mov    %rax,0x8(%rcx)
 107495e:	sete   %al
 1074961:	or     %al,0x3c5(%rsi)
 1074967:	test   %r15,%r15
 107496a:	je     107489f <check_input_run+0x750f>
 1074970:	mov    0x5f0(%rsp),%rsi
 1074978:	mov    %r15,%rdi
 107497b:	vzeroupper
 107497e:	call   788550 <memcpy@plt>
 1074983:	mov    0x18(%rsp),%rax
 1074988:	mov    %r15,0x68(%rax)
 107498c:	mov    %ebx,0x78(%rax)
 107498f:	jmp    107489f <check_input_run+0x750f>
 1074994:	and    $0xfffffffe,%edx
 1074997:	movabs $0xc0000a0000,%rsi
 10749a1:	xor    %ecx,%ecx
 10749a3:	jmp    1074a40 <check_input_run+0x76b0>
 10749a8:	mov    %r15,%rax
 10749ab:	sub    %rcx,%rax
 10749ae:	mov    0x10(%rdx),%rcx
 10749b2:	sub    %rax,%rcx
 10749b5:	jb     10748da <check_input_run+0x754a>
 10749bb:	shl    $0x2,%rbx
 10749bf:	cmp    %rcx,%rbx
 10749c2:	ja     10748da <check_input_run+0x754a>
 10749c8:	mov    0x18(%rsp),%rcx
 10749cd:	add    %rbx,%rax
 10749d0:	test   %r15,%r15
 10749d3:	mov    %rax,0x8(%rdx)
 10749d7:	sete   %al
 10749da:	or     %al,0x3c5(%rcx)
 10749e0:	test   %r15,%r15
 10749e3:	je     10748e6 <check_input_run+0x7556>
 10749e9:	mov    %r15,%rdi
 10749ec:	mov    %rbx,%rdx
 10749ef:	vzeroupper
 10749f2:	call   788550 <memcpy@plt>
 10749f7:	mov    0x10(%rsp),%rdx
 10749fc:	mov    0x18(%rsp),%rax
 1074a01:	mov    %r15,0x70(%rax)
 1074a05:	jmp    10748e6 <check_input_run+0x7556>
 1074a0a:	cmp    $0x1ce,%r8d
 1074a11:	jne    1074bc1 <check_input_run+0x7831>
 1074a17:	mov    $0x1,%edi
 1074a1c:	nopl   0x0(%rax)
 1074a20:	mov    0x18(%rsp),%r8
 1074a25:	add    $0x2,%rcx
 1074a29:	add    0xdc(%r8),%edi
 1074a30:	mov    %edi,0xdc(%r8)
 1074a37:	cmp    %rcx,%rdx
 1074a3a:	je     1074c38 <check_input_run+0x78a8>
 1074a40:	mov    0x4a8(%rsp),%rdi
 1074a48:	mov    $0x0,%r8d
 1074a4e:	movzwl (%rdi,%rcx,2),%edi
 1074a52:	lea    -0x120(%rdi),%r9d
 1074a59:	cmp    $0x5,%r9d
 1074a5d:	jae    1074b20 <check_input_run+0x7790>
 1074a63:	mov    0x18(%rsp),%rdi
 1074a68:	add    %r8d,0xdc(%rdi)
 1074a6f:	mov    0x4a8(%rsp),%rdi
 1074a77:	movzwl 0x2(%rdi,%rcx,2),%r8d
 1074a7d:	xor    %edi,%edi
 1074a7f:	lea    -0x120(%r8),%r9d
 1074a86:	cmp    $0x5,%r9d
 1074a8a:	jb     1074a20 <check_input_run+0x7690>
 1074a8c:	cmp    $0x317,%r8d
 1074a93:	je     1074a20 <check_input_run+0x7690>
 1074a95:	lea    -0x160(%r8),%r9d
 1074a9c:	mov    %r8d,%r10d
 1074a9f:	cmp    $0x6,%r9w
 1074aa4:	setb   %r9b
 1074aa8:	and    $0xfffffffc,%r10d
 1074aac:	cmp    $0x1f0,%r10w
 1074ab2:	sete   %r10b
 1074ab6:	or     %r9b,%r10b
 1074ab9:	jne    1074a20 <check_input_run+0x7690>
 1074abf:	lea    -0x140(%r8),%r9d
 1074ac6:	lea    -0x200(%r8),%r10d
 1074acd:	cmp    $0x13,%r9w
 1074ad2:	setb   %r9b
 1074ad6:	cmp    $0xe,%r10w
 1074adb:	setb   %r10b
 1074adf:	or     %r9b,%r10b
 1074ae2:	jne    1074a17 <check_input_run+0x7687>
 1074ae8:	cmp    $0x16f,%r8d
 1074aef:	jle    1074ba7 <check_input_run+0x7817>
 1074af5:	lea    -0x170(%r8),%r9d
 1074afc:	cmp    $0x27,%r9d
 1074b00:	ja     1074a0a <check_input_run+0x767a>
 1074b06:	bt     %r9,%rsi
 1074b0a:	jb     1074a17 <check_input_run+0x7687>
 1074b10:	test   %r9,%r9
 1074b13:	je     1074a20 <check_input_run+0x7690>
 1074b19:	jmp    1074a0a <check_input_run+0x767a>
 1074b1e:	xchg   %ax,%ax
 1074b20:	cmp    $0x317,%edi
 1074b26:	je     1074a63 <check_input_run+0x76d3>
 1074b2c:	lea    -0x160(%rdi),%r8d
 1074b33:	mov    %edi,%r9d
 1074b36:	cmp    $0x6,%r8w
 1074b3b:	setb   %r8b
 1074b3f:	and    $0xfffffffc,%r9d
 1074b43:	cmp    $0x1f0,%r9w
 1074b49:	sete   %r9b
 1074b4d:	or     %r8b,%r9b
 1074b50:	mov    $0x0,%r8d
 1074b56:	jne    1074a63 <check_input_run+0x76d3>
 1074b5c:	lea    -0x140(%rdi),%r8d
 1074b63:	lea    -0x200(%rdi),%r9d
 1074b6a:	cmp    $0x13,%r8w
 1074b6f:	setb   %r8b
 1074b73:	cmp    $0xe,%r9w
 1074b78:	setb   %r9b
 1074b7c:	or     %r8b,%r9b
 1074b7f:	jne    1074b9c <check_input_run+0x780c>
 1074b81:	cmp    $0x16f,%edi
 1074b87:	jle    1074be5 <check_input_run+0x7855>
 1074b89:	lea    -0x170(%rdi),%r9d
 1074b90:	cmp    $0x27,%r9d
 1074b94:	ja     1074c06 <check_input_run+0x7876>
 1074b96:	bt     %r9,%rsi
 1074b9a:	jae    1074bf7 <check_input_run+0x7867>
 1074b9c:	mov    $0x1,%r8d
 1074ba2:	jmp    1074a63 <check_input_run+0x76d3>
 1074ba7:	cmp    $0x130,%r8d
 1074bae:	je     1074a17 <check_input_run+0x7687>
 1074bb4:	cmp    $0x133,%r8d
 1074bbb:	je     1074a17 <check_input_run+0x7687>
 1074bc1:	lea    -0x300(%r8),%r9d
 1074bc8:	cmp    $0x16,%r9w
 1074bcd:	ja     1074a20 <check_input_run+0x7690>
 1074bd3:	xor    %edi,%edi
 1074bd5:	cmp    $0x312,%r8d
 1074bdc:	sete   %dil
 1074be0:	jmp    1074a20 <check_input_run+0x7690>
 1074be5:	cmp    $0x130,%edi
 1074beb:	je     1074b9c <check_input_run+0x780c>
 1074bed:	cmp    $0x133,%edi
 1074bf3:	je     1074b9c <check_input_run+0x780c>
 1074bf5:	jmp    1074c0e <check_input_run+0x787e>
 1074bf7:	mov    $0x0,%r8d
 1074bfd:	test   %r9,%r9
 1074c00:	je     1074a63 <check_input_run+0x76d3>
 1074c06:	cmp    $0x1ce,%edi
 1074c0c:	je     1074b9c <check_input_run+0x780c>
 1074c0e:	lea    -0x300(%rdi),%r9d
 1074c15:	mov    $0x0,%r8d
 1074c1b:	cmp    $0x16,%r9w
 1074c20:	ja     1074a63 <check_input_run+0x76d3>
 1074c26:	xor    %r8d,%r8d
 1074c29:	cmp    $0x312,%edi
 1074c2f:	sete   %r8b
 1074c33:	jmp    1074a63 <check_input_run+0x76d3>
 1074c38:	testb  $0x1,0x78(%rsp)
 1074c3d:	mov    0x10(%rsp),%rdx
 1074c42:	je     1074c77 <check_input_run+0x78e7>
 1074c44:	mov    0x4a8(%rsp),%rdx
 1074c4c:	movzwl (%rdx,%rcx,2),%ecx
 1074c50:	lea    -0x120(%rcx),%edx
 1074c56:	cmp    $0x5,%edx
 1074c59:	jae    1074fb1 <check_input_run+0x7c21>
 1074c5f:	mov    0x10(%rsp),%rdx
 1074c64:	mov    0x18(%rsp),%rcx
 1074c69:	add    0xdc(%rcx),%eax
 1074c6f:	mov    %eax,%edi
 1074c71:	mov    %eax,0xdc(%rcx)
 1074c77:	test   %edi,%edi
 1074c79:	je     1074ce2 <check_input_run+0x7952>
 1074c7b:	mov    (%rdx),%rcx
 1074c7e:	mov    %rdx,%rsi
 1074c81:	mov    0x8(%rdx),%rdx
 1074c85:	lea    0x7(%rdx,%rcx,1),%rax
 1074c8a:	add    %rcx,%rdx
 1074c8d:	and    $0xfffffffffffffff8,%rax
 1074c91:	cmp    %rdx,%rax
 1074c94:	jae    1074c9a <check_input_run+0x790a>
 1074c96:	xor    %ecx,%ecx
 1074c98:	jmp    1074cc5 <check_input_run+0x7935>
 1074c9a:	mov    0x10(%rsi),%rsi
 1074c9e:	mov    %rax,%rdx
 1074ca1:	sub    %rcx,%rdx
 1074ca4:	xor    %ecx,%ecx
 1074ca6:	sub    %rdx,%rsi
 1074ca9:	jb     1074cc5 <check_input_run+0x7935>
 1074cab:	mov    %edi,%edi
 1074cad:	imul   $0x78,%rdi,%rdi
 1074cb1:	cmp    %rsi,%rdi
 1074cb4:	ja     1074cc5 <check_input_run+0x7935>
 1074cb6:	mov    0x10(%rsp),%rcx
 1074cbb:	add    %rdi,%rdx
 1074cbe:	mov    %rdx,0x8(%rcx)
 1074cc2:	mov    %rax,%rcx
 1074cc5:	mov    0x18(%rsp),%rdx
 1074cca:	test   %rcx,%rcx
 1074ccd:	sete   %al
 1074cd0:	mov    %rcx,0xd0(%rdx)
 1074cd7:	or     %al,0x3c5(%rdx)
 1074cdd:	mov    0x10(%rsp),%rdx
 1074ce2:	mov    0x18(%rsp),%rax
 1074ce7:	mov    0x210(%rax),%ecx
 1074ced:	test   %rcx,%rcx
 1074cf0:	je     1074d5b <check_input_run+0x79cb>
 1074cf2:	mov    %ecx,0xfc(%rax)
 1074cf8:	mov    %rdx,%r8
 1074cfb:	mov    (%rdx),%rsi
 1074cfe:	mov    0x8(%rdx),%rdx
 1074d02:	lea    0x7(%rdx,%rsi,1),%rax
 1074d07:	add    %rsi,%rdx
 1074d0a:	and    $0xfffffffffffffff8,%rax
 1074d0e:	cmp    %rdx,%rax
 1074d11:	jb     1074d38 <check_input_run+0x79a8>
 1074d13:	mov    %rax,%rdx
 1074d16:	sub    %rsi,%rdx
 1074d19:	mov    0x10(%r8),%rsi
 1074d1d:	shl    $0x3,%rcx
 1074d21:	lea    (%rcx,%rcx,4),%rcx
 1074d25:	sub    %rdx,%rsi
 1074d28:	setb   %dil
 1074d2c:	cmp    %rsi,%rcx
 1074d2f:	seta   %sil
 1074d33:	or     %dil,%sil
 1074d36:	je     1074d3c <check_input_run+0x79ac>
 1074d38:	xor    %eax,%eax
 1074d3a:	jmp    1074d43 <check_input_run+0x79b3>
 1074d3c:	add    %rcx,%rdx
 1074d3f:	mov    %rdx,0x8(%r8)
 1074d43:	mov    0x18(%rsp),%rcx
 1074d48:	test   %rax,%rax
 1074d4b:	sete   %dl
 1074d4e:	mov    %rax,0xf0(%rcx)
 1074d55:	or     %dl,0x3c5(%rcx)
 1074d5b:	mov    0xf0(%rsp),%rcx
 1074d63:	test   %ecx,%ecx
 1074d65:	je     1074f08 <check_input_run+0x7b78>
 1074d6b:	xor    %ebx,%ebx
 1074d6d:	jmp    1074d86 <check_input_run+0x79f6>
 1074d6f:	nop
 1074d70:	mov    0xf0(%rsp),%rcx
 1074d78:	inc    %rbx
 1074d7b:	cmp    0x78(%rsp),%rbx
 1074d80:	je     1074f08 <check_input_run+0x7b78>
 1074d86:	mov    (%r14),%rax
 1074d89:	cmpb   $0x0,(%rax,%rbx,1)
 1074d8d:	je     1074dcc <check_input_run+0x7a3c>
 1074d8f:	mov    0x260(%rsp),%rax
 1074d97:	mov    0x258(%rsp),%rdx
 1074d9f:	mov    (%rax),%rax
 1074da2:	mov    (%rax,%rbx,4),%edi
 1074da5:	mov    (%rdx),%rax
 1074da8:	mov    (%rax,%rbx,4),%edx
 1074dab:	cmp    %edi,%edx
 1074dad:	jbe    1074dcc <check_input_run+0x7a3c>
 1074daf:	cmp    %ecx,%edx
 1074db1:	ja     1074dcc <check_input_run+0x7a3c>
 1074db3:	mov    %edi,%eax
 1074db5:	add    0x520(%rsp),%rdi
 1074dbd:	sub    %eax,%edx
 1074dbf:	mov    $0x1,%esi
 1074dc4:	vzeroupper
 1074dc7:	call   788430 <memset@plt>
 1074dcc:	mov    0x10(%r12),%rax
 1074dd1:	movzbl (%rax,%rbx,1),%ecx
 1074dd5:	cmp    $0x43,%cl
 1074dd8:	jne    1074e50 <check_input_run+0x7ac0>
 1074dda:	lea    0x1(%rbx),%rdx
 1074dde:	cmp    0x78(%rsp),%rdx
 1074de3:	jae    1074d70 <check_input_run+0x79e0>
 1074de5:	mov    0x60(%r12),%rcx
 1074dea:	mov    0x4(%rcx,%rbx,4),%esi
 1074dee:	cmp    %rsi,%rdx
 1074df1:	setb   %dl
 1074df4:	cmp    0xf0(%rsp),%esi
 1074dfb:	setb   %dil
 1074dff:	and    %dl,%dil
 1074e02:	cmp    $0x1,%dil
 1074e06:	jne    1074d70 <check_input_run+0x79e0>
 1074e0c:	lea    0x2(%rbx),%rdi
 1074e10:	cmp    %rsi,%rdi
 1074e13:	jb     1074ed4 <check_input_run+0x7b44>
 1074e19:	mov    %edi,%edx
 1074e1b:	mov    0x520(%rsp),%rax
 1074e23:	sub    %ebx,%edx
 1074e25:	mov    $0x1,%esi
 1074e2a:	add    $0xfffffffe,%edx
 1074e2d:	lea    0x2(%rax,%rbx,1),%rdi
 1074e32:	vzeroupper
 1074e35:	call   788430 <memset@plt>
 1074e3a:	mov    0x10(%r12),%rax
 1074e3f:	movzbl (%rax,%rbx,1),%ecx
 1074e43:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1074e50:	cmp    $0x4a,%cl
 1074e53:	jne    1074d70 <check_input_run+0x79e0>
 1074e59:	mov    0x60(%r12),%rax
 1074e5e:	mov    (%rax,%rbx,4),%eax
 1074e61:	cmp    %rax,%rbx
 1074e64:	setb   %cl
 1074e67:	cmp    0xf0(%rsp),%eax
 1074e6e:	setb   %dl
 1074e71:	and    %cl,%dl
 1074e73:	cmp    $0x1,%dl
 1074e76:	jne    1074d70 <check_input_run+0x79e0>
 1074e7c:	mov    0x520(%rsp),%rcx
 1074e84:	mov    %ebx,%edx
 1074e86:	not    %edx
 1074e88:	mov    $0x1,%esi
 1074e8d:	add    %eax,%edx
 1074e8f:	lea    0x1(%rcx,%rbx,1),%rdi
 1074e94:	vzeroupper
 1074e97:	call   788430 <memset@plt>
 1074e9c:	jmp    1074d70 <check_input_run+0x79e0>
 1074ea1:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1074eb0:	cmp    $0xa,%r8d
 1074eb4:	jne    1074eef <check_input_run+0x7b5f>
 1074eb6:	mov    (%rcx,%rdx,4),%r8d
 1074eba:	lea    0x1(%r8),%edx
 1074ebe:	cmp    %esi,%r8d
 1074ec1:	cmovae %esi,%edx
 1074ec4:	cmp    %edi,%r8d
 1074ec7:	cmovbe %esi,%edx
 1074eca:	mov    %edx,%edi
 1074ecc:	cmp    %esi,%edx
 1074ece:	jae    1074e1b <check_input_run+0x7a8b>
 1074ed4:	mov    %edi,%edx
 1074ed6:	movzbl (%rax,%rdx,1),%r8d
 1074edb:	cmp    $0x9,%r8d
 1074edf:	jg     1074eb0 <check_input_run+0x7b20>
 1074ee1:	cmp    $0x6,%r8d
 1074ee5:	je     1074eb6 <check_input_run+0x7b26>
 1074ee7:	cmp    $0x8,%r8d
 1074eeb:	je     1074eb6 <check_input_run+0x7b26>
 1074eed:	jmp    1074ef9 <check_input_run+0x7b69>
 1074eef:	cmp    $0x33,%r8d
 1074ef3:	je     1074e19 <check_input_run+0x7a89>
 1074ef9:	inc    %edi
 1074efb:	mov    %edi,%edx
 1074efd:	mov    %edx,%edi
 1074eff:	cmp    %esi,%edx
 1074f01:	jb     1074ed4 <check_input_run+0x7b44>
 1074f03:	jmp    1074e1b <check_input_run+0x7a8b>
 1074f08:	mov    0x2a0(%rsp),%rax
 1074f10:	mov    0x328(%rax),%ecx
 1074f16:	test   %rcx,%rcx
 1074f19:	je     107566e <check_input_run+0x82de>
 1074f1f:	mov    0x318(%rax),%rsi
 1074f26:	mov    (%rsi),%edi
 1074f28:	mov    0x4(%rsi),%r8d
 1074f2c:	cmp    %r8d,%edi
 1074f2f:	jae    1075691 <check_input_run+0x8301>
 1074f35:	mov    0x364(%rax),%r9d
 1074f3c:	cmp    %r9d,%r8d
 1074f3f:	jae    1075691 <check_input_run+0x8301>
 1074f45:	inc    %r8
 1074f48:	mov    %r8,%rdx
 1074f4b:	sub    %rdi,%rdx
 1074f4e:	mov    $0x1,%edi
 1074f53:	cmp    $0x1,%ecx
 1074f56:	je     1075513 <check_input_run+0x8183>
 1074f5c:	add    $0x1c,%rsi
 1074f60:	jmp    1074f72 <check_input_run+0x7be2>
 1074f62:	inc    %rdi
 1074f65:	add    $0x18,%rsi
 1074f69:	cmp    %rdi,%rcx
 1074f6c:	je     1075510 <check_input_run+0x8180>
 1074f72:	mov    -0x4(%rsi),%r11d
 1074f76:	mov    (%rsi),%r10d
 1074f79:	cmp    %r10d,%r11d
 1074f7c:	jae    1075513 <check_input_run+0x8183>
 1074f82:	cmp    %r9d,%r10d
 1074f85:	jae    1075513 <check_input_run+0x8183>
 1074f8b:	cmp    %r11d,-0x1c(%rsi)
 1074f8f:	jae    1075513 <check_input_run+0x8183>
 1074f95:	cmp    %r10,%r8
 1074f98:	ja     1074f62 <check_input_run+0x7bd2>
 1074f9a:	cmp    %r11,%r8
 1074f9d:	cmova  %r8,%r11
 1074fa1:	sub    %r11,%rdx
 1074fa4:	lea    0x1(%rdx,%r10,1),%rdx
 1074fa9:	inc    %r10
 1074fac:	mov    %r10,%r8
 1074faf:	jmp    1074f62 <check_input_run+0x7bd2>
 1074fb1:	cmp    $0x317,%ecx
 1074fb7:	je     1074c5f <check_input_run+0x78cf>
 1074fbd:	lea    -0x160(%rcx),%edx
 1074fc3:	mov    %ecx,%esi
 1074fc5:	cmp    $0x6,%dx
 1074fc9:	setb   %dl
 1074fcc:	and    $0xfffffffc,%esi
 1074fcf:	cmp    $0x1f0,%si
 1074fd4:	sete   %sil
 1074fd8:	or     %dl,%sil
 1074fdb:	jne    1074c5f <check_input_run+0x78cf>
 1074fe1:	lea    -0x140(%rcx),%edx
 1074fe7:	lea    -0x200(%rcx),%esi
 1074fed:	cmp    $0x13,%dx
 1074ff1:	setb   %dl
 1074ff4:	cmp    $0xe,%si
 1074ff8:	setb   %sil
 1074ffc:	or     %dl,%sil
 1074fff:	jne    1077b89 <check_input_run+0xa7f9>
 1075005:	cmp    $0x16f,%ecx
 107500b:	jle    1077b75 <check_input_run+0xa7e5>
 1075011:	lea    -0x170(%rcx),%edx
 1075017:	cmp    $0x27,%edx
 107501a:	ja     1075039 <check_input_run+0x7ca9>
 107501c:	movabs $0xc0000a0000,%rsi
 1075026:	bt     %rdx,%rsi
 107502a:	jb     1077b89 <check_input_run+0xa7f9>
 1075030:	test   %rdx,%rdx
 1075033:	je     1074c5f <check_input_run+0x78cf>
 1075039:	cmp    $0x1ce,%ecx
 107503f:	je     1077b89 <check_input_run+0xa7f9>
 1075045:	jmp    1077fc2 <check_input_run+0xac32>
 107504a:	cmp    %rax,%rdx
 107504d:	jae    10754c5 <check_input_run+0x8135>
 1075053:	mov    0x2c8(%rsp),%rcx
 107505b:	mov    0x58(%rsp),%rax
 1075060:	mov    0x8(%rcx),%r8
 1075064:	cmpq   $0x0,0x828(%rax)
 107506c:	je     107508f <check_input_run+0x7cff>
 107506e:	mov    0x10(%rsp),%rdi
 1075073:	mov    (%rdi),%rsi
 1075076:	mov    0x8(%rdi),%rdx
 107507a:	lea    0x3f(%rdx,%rsi,1),%rax
 107507f:	add    %rsi,%rdx
 1075082:	and    $0xffffffffffffffc0,%rax
 1075086:	cmp    %rdx,%rax
 1075089:	jae    10763db <check_input_run+0x904b>
 107508f:	xor    %ebp,%ebp
 1075091:	movq   $0x0,0x210(%rsp)
 107509d:	mov    0x58(%rsp),%rax
 10750a2:	cmpq   $0x0,0x828(%rax)
 10750aa:	setne  %al
 10750ad:	test   %rbp,%rbp
 10750b0:	sete   %cl
 10750b3:	and    %al,%cl
 10750b5:	or     %cl,0x3c5(%r14)
 10750bc:	test   %rbp,%rbp
 10750bf:	je     1076a2e <check_input_run+0x969e>
 10750c5:	cmpb   $0x0,(%r10)
 10750c9:	mov    %r8,0x130(%rsp)
 10750d1:	mov    %r9,0x1b0(%rsp)
 10750d9:	mov    %r10,0xc8(%rsp)
 10750e1:	jne    10750f5 <check_input_run+0x7d65>
 10750e3:	mov    0x58(%rsp),%rax
 10750e8:	cmpb   $0x1,0xc40(%rax)
 10750ef:	jne    1076497 <check_input_run+0x9107>
 10750f5:	mov    0x58(%rsp),%rbx
 10750fa:	mov    %rbx,%rdi
 10750fd:	vzeroupper
 1075100:	call   101c990 <pp_history_ensure>
 1075105:	cmpl   $0x0,0x830(%rbx)
 107510c:	je     10767f4 <check_input_run+0x9464>
 1075112:	mov    $0xffffffff,%r8d
 1075118:	mov    $0xffffffff,%esi
 107511d:	xor    %r10d,%r10d
 1075120:	movl   $0x0,0x48(%rsp)
 1075128:	xor    %ecx,%ecx
 107512a:	xor    %edx,%edx
 107512c:	xor    %r13d,%r13d
 107512f:	xor    %eax,%eax
 1075131:	jmp    107516f <check_input_run+0x7ddf>
 1075133:	movl   $0x0,0x48(%rsp)
 107513b:	xor    %r10d,%r10d
 107513e:	mov    $0xffffffff,%r9d
 1075144:	xor    %r11d,%r11d
 1075147:	mov    0x58(%rsp),%rax
 107514c:	mov    %r11b,0x0(%rbp,%rcx,1)
 1075151:	inc    %rcx
 1075154:	mov    %r9d,%r8d
 1075157:	mov    0x20(%rsp),%r12
 107515c:	mov    0x830(%rax),%eax
 1075162:	cmp    %rax,%rcx
 1075165:	mov    0x28(%rsp),%eax
 1075169:	jae    10767f4 <check_input_run+0x9464>
 107516f:	mov    %r10d,0x90(%rsp)
 1075177:	mov    0x58(%rsp),%r10
 107517c:	mov    0xce0(%r10),%edi
 1075183:	cmp    %edi,%edx
 1075185:	jae    10751a0 <check_input_run+0x7e10>
 1075187:	mov    0xcd8(%r10),%r9
 107518e:	mov    %edx,%edx
 1075190:	cmp    %ecx,(%r9,%rdx,8)
 1075194:	ja     10751a0 <check_input_run+0x7e10>
 1075196:	inc    %rdx
 1075199:	cmp    %rdx,%rdi
 107519c:	jne    1075190 <check_input_run+0x7e00>
 107519e:	mov    %edi,%edx
 10751a0:	test   %edx,%edx
 10751a2:	je     10752e4 <check_input_run+0x7f54>
 10751a8:	mov    0xcd8(%r10),%rdi
 10751af:	lea    -0x1(%rdx),%r9d
 10751b3:	mov    0x4(%rdi,%r9,8),%r9d
 10751b8:	test   %r9d,%r9d
 10751bb:	je     10752d5 <check_input_run+0x7f45>
 10751c1:	cmp    %eax,%r9d
 10751c4:	je     10752d5 <check_input_run+0x7f45>
 10751ca:	mov    0x828(%r10),%rax
 10751d1:	mov    %r9d,0x28(%rsp)
 10751d6:	test   %rax,%rax
 10751d9:	je     10752f8 <check_input_run+0x7f68>
 10751df:	mov    0xca0(%r10),%r11d
 10751e6:	mov    0xcb0(%r10),%r12d
 10751ed:	mov    (%rax,%rcx,4),%edi
 10751f0:	xor    %r15d,%r15d
 10751f3:	mov    %r12d,%eax
 10751f6:	mov    %r11,0xd0(%rsp)
 10751fe:	add    %r11,%r12
 1075201:	mov    0xcc0(%r10),%r11d
 1075208:	mov    %r9d,%r10d
 107520b:	add    %r11,%r12
 107520e:	mov    %r10d,%r9d
 1075211:	and    $0x3fffffff,%r9d
 1075218:	mov    %r10d,%r13d
 107521b:	and    $0xc0000000,%r13d
 1075222:	dec    %r9d
 1075225:	cmp    $0x40000000,%r13d
 107522c:	jne    1075251 <check_input_run+0x7ec1>
 107522e:	cmp    %eax,%r9d
 1075231:	jae    10752ff <check_input_run+0x7f6f>
 1075237:	mov    0x58(%rsp),%r10
 107523c:	mov    %r9d,%r9d
 107523f:	lea    (%r9,%r9,2),%r9
 1075243:	mov    0xca8(%r10),%r10
 107524a:	lea    0x4(%r10,%r9,4),%r9
 107524f:	jmp    10752bc <check_input_run+0x7f2c>
 1075251:	cmp    $0xbfffffff,%r10d
 1075258:	jg     1075281 <check_input_run+0x7ef1>
 107525a:	cmp    %r11d,%r9d
 107525d:	jae    10752ff <check_input_run+0x7f6f>
 1075263:	mov    0x58(%rsp),%r10
 1075268:	mov    %r9d,%r9d
 107526b:	lea    (%r9,%r9,2),%rbx
 107526f:	mov    0xcb8(%r10),%r10
 1075276:	mov    0x8(%r10,%rbx,8),%edi
 107527b:	lea    (%r10,%rbx,8),%r9
 107527f:	jmp    10752bc <check_input_run+0x7f2c>
 1075281:	xor    %ebx,%ebx
 1075283:	test   %r13d,%r13d
 1075286:	jne    1075301 <check_input_run+0x7f71>
 1075288:	mov    $0x0,%r10d
 107528e:	cmp    0xd0(%rsp),%r9d
 1075296:	jae    1075304 <check_input_run+0x7f74>
 1075298:	mov    0x58(%rsp),%r10
 107529d:	mov    %r9d,%r9d
 10752a0:	lea    (%r9,%r9,8),%rbx
 10752a4:	lea    (%rbx,%rbx,2),%rbx
 10752a8:	add    %r9,%rbx
 10752ab:	mov    0xc98(%r10),%r10
 10752b2:	mov    0x8(%r10,%rbx,1),%edi
 10752b7:	lea    0x10(%r10,%rbx,1),%r9
 10752bc:	mov    (%r9),%r10d
 10752bf:	mov    $0x1,%bl
 10752c1:	test   %r10d,%r10d
 10752c4:	je     1075304 <check_input_run+0x7f74>
 10752c6:	cmp    %r12,%r15
 10752c9:	lea    0x1(%r15),%r15
 10752cd:	jb     107520e <check_input_run+0x7e7e>
 10752d3:	jmp    1075304 <check_input_run+0x7f74>
 10752d5:	test   %r9d,%r9d
 10752d8:	je     10752e4 <check_input_run+0x7f54>
 10752da:	mov    %r9d,0x28(%rsp)
 10752df:	mov    %r13d,%edi
 10752e2:	jmp    107531c <check_input_run+0x7f8c>
 10752e4:	mov    0x828(%r10),%rax
 10752eb:	movl   $0x0,0x28(%rsp)
 10752f3:	mov    (%rax,%rcx,4),%edi
 10752f6:	jmp    107531c <check_input_run+0x7f8c>
 10752f8:	xor    %r13d,%r13d
 10752fb:	xor    %edi,%edi
 10752fd:	jmp    107531c <check_input_run+0x7f8c>
 10752ff:	xor    %ebx,%ebx
 1075301:	xor    %r10d,%r10d
 1075304:	test   %r10d,%r10d
 1075307:	mov    0x58(%rsp),%r10
 107530c:	mov    $0x0,%eax
 1075311:	cmovne %eax,%edi
 1075314:	test   %bl,%bl
 1075316:	cmove  %eax,%edi
 1075319:	mov    %edi,%r13d
 107531c:	mov    0xc18(%r10),%r12d
 1075323:	cmp    %r12d,%r8d
 1075326:	jae    107534f <check_input_run+0x7fbf>
 1075328:	mov    0x58(%rsp),%rax
 107532d:	mov    0xc10(%rax),%rax
 1075334:	test   %rax,%rax
 1075337:	je     107534f <check_input_run+0x7fbf>
 1075339:	mov    %r8d,%r9d
 107533c:	imul   $0x38,%r9,%r9
 1075340:	add    %r9,%rax
 1075343:	mov    %edi,%r9d
 1075346:	sub    (%rax),%r9d
 1075349:	jae    1075432 <check_input_run+0x80a2>
 107534f:	mov    $0xffffffff,%esi
 1075354:	test   %edi,%edi
 1075356:	je     1075133 <check_input_run+0x7da3>
 107535c:	cmp    $0x2,%r12d
 1075360:	jb     10753b0 <check_input_run+0x8020>
 1075362:	mov    0x58(%rsp),%rax
 1075367:	xor    %r8d,%r8d
 107536a:	mov    %r12d,%r10d
 107536d:	mov    %r12d,%r9d
 1075370:	mov    0xc10(%rax),%rax
 1075377:	jmp    107538f <check_input_run+0x7fff>
 1075379:	nopl   0x0(%rax)
 1075380:	mov    %r10d,%r8d
 1075383:	mov    %r9d,%r10d
 1075386:	sub    %r8d,%r10d
 1075389:	cmp    $0x1,%r10d
 107538d:	jbe    10753c8 <check_input_run+0x8038>
 107538f:	shr    $1,%r10d
 1075392:	add    %r8d,%r10d
 1075395:	imul   $0x38,%r10,%r11
 1075399:	cmp    %edi,(%rax,%r11,1)
 107539d:	jbe    1075380 <check_input_run+0x7ff0>
 107539f:	mov    %r10d,%r9d
 10753a2:	mov    %r9d,%r10d
 10753a5:	sub    %r8d,%r10d
 10753a8:	cmp    $0x1,%r10d
 10753ac:	ja     107538f <check_input_run+0x7fff>
 10753ae:	jmp    10753c8 <check_input_run+0x8038>
 10753b0:	test   %r12d,%r12d
 10753b3:	je     1075133 <check_input_run+0x7da3>
 10753b9:	mov    0x58(%rsp),%rax
 10753be:	xor    %r8d,%r8d
 10753c1:	mov    0xc10(%rax),%rax
 10753c8:	mov    %r8d,%r9d
 10753cb:	imul   $0x38,%r9,%rbx
 10753cf:	mov    %edi,%r15d
 10753d2:	mov    $0x0,%r10d
 10753d8:	mov    $0xffffffff,%r9d
 10753de:	mov    $0x0,%r11d
 10753e4:	movl   $0x0,0x48(%rsp)
 10753ec:	sub    (%rax,%rbx,1),%r15d
 10753f0:	jb     1075147 <check_input_run+0x7db7>
 10753f6:	add    %rax,%rbx
 10753f9:	mov    $0xffffffff,%esi
 10753fe:	cmp    0x4(%rbx),%r15d
 1075402:	cmovb  %r8d,%r9d
 1075406:	xor    %r10d,%r10d
 1075409:	cmp    %r12d,%r9d
 107540c:	jae    1075477 <check_input_run+0x80e7>
 107540e:	mov    %r9d,%esi
 1075411:	imul   $0x38,%rsi,%rsi
 1075415:	movzbl 0x28(%rax,%rsi,1),%r9d
 107541b:	mov    (%rax,%rsi,1),%r10d
 107541f:	mov    0x20(%rax,%rsi,1),%esi
 1075423:	mov    %r9d,0x90(%rsp)
 107542b:	mov    %r10d,0x48(%rsp)
 1075430:	jmp    1075446 <check_input_run+0x80b6>
 1075432:	cmp    0x4(%rax),%r9d
 1075436:	jae    107534f <check_input_run+0x7fbf>
 107543c:	cmp    0x48(%rsp),%edi
 1075440:	jb     107534f <check_input_run+0x7fbf>
 1075446:	mov    0x58(%rsp),%r9
 107544b:	mov    0xc28(%r9),%eax
 1075452:	cmp    %eax,%esi
 1075454:	jae    107546d <check_input_run+0x80dd>
 1075456:	mov    0xc20(%r9),%r9
 107545d:	mov    %esi,%r10d
 1075460:	lea    (%r10,%r10,4),%r10
 1075464:	mov    0x4(%r9,%r10,8),%ebx
 1075469:	cmp    %edi,%ebx
 107546b:	jbe    1075484 <check_input_run+0x80f4>
 107546d:	mov    0x90(%rsp),%r10d
 1075475:	jmp    10754ad <check_input_run+0x811d>
 1075477:	mov    %r9d,%r8d
 107547a:	movl   $0x0,0x48(%rsp)
 1075482:	jmp    10754ad <check_input_run+0x811d>
 1075484:	lea    (%r9,%r10,8),%r15
 1075488:	mov    0x1c(%r15),%esi
 107548c:	mov    %r15,%r11
 107548f:	mov    %ebx,0x48(%rsp)
 1075493:	cmp    %eax,%esi
 1075495:	jae    10754a8 <check_input_run+0x8118>
 1075497:	lea    (%rsi,%rsi,4),%r10
 107549b:	mov    0x4(%r9,%r10,8),%ebx
 10754a0:	lea    (%r9,%r10,8),%r15
 10754a4:	cmp    %edi,%ebx
 10754a6:	jbe    1075488 <check_input_run+0x80f8>
 10754a8:	movzbl 0x20(%r11),%r10d
 10754ad:	cmp    %r12d,%r8d
 10754b0:	movzbl %r10b,%r11d
 10754b4:	mov    $0x0,%eax
 10754b9:	mov    %r8d,%r9d
 10754bc:	cmovae %eax,%r11d
 10754c0:	jmp    1075147 <check_input_run+0x7db7>
 10754c5:	mov    0x58(%rsp),%rax
 10754ca:	mov    0xc28(%rax),%ecx
 10754d0:	test   %rcx,%rcx
 10754d3:	je     10754ff <check_input_run+0x816f>
 10754d5:	mov    0x58(%rsp),%rax
 10754da:	shl    $0x3,%rcx
 10754de:	xor    %edx,%edx
 10754e0:	lea    (%rcx,%rcx,4),%rcx
 10754e4:	mov    0xc20(%rax),%rax
 10754eb:	cmpb   $0x0,0x20(%rax,%rdx,1)
 10754f0:	jne    1075053 <check_input_run+0x7cc3>
 10754f6:	add    $0x28,%rdx
 10754fa:	cmp    %rdx,%rcx
 10754fd:	jne    10754eb <check_input_run+0x815b>
 10754ff:	mov    0x2c8(%rsp),%rax
 1075507:	mov    0x8(%rax),%r8
 107550b:	jmp    1076a2e <check_input_run+0x969e>
 1075510:	mov    %rcx,%rdi
 1075513:	cmp    %rcx,%rdi
 1075516:	jb     1075691 <check_input_run+0x8301>
 107551c:	lea    (%rcx,%rdx,8),%rdx
 1075520:	mov    %rdx,%rsi
 1075523:	shr    $0x20,%rsi
 1075527:	jne    1075691 <check_input_run+0x8301>
 107552d:	mov    %ecx,0x12c(%rax)
 1075533:	mov    %edx,0x13c(%rax)
 1075539:	mov    0x2c0(%rsp),%rsi
 1075541:	mov    (%rsi),%r8
 1075544:	mov    0x8(%rsi),%r9
 1075548:	lea    0x3(%r9,%r8,1),%rdi
 107554d:	add    %r8,%r9
 1075550:	and    $0xfffffffffffffffc,%rdi
 1075554:	cmp    %r9,%rdi
 1075557:	jae    107555e <check_input_run+0x81ce>
 1075559:	xor    %r8d,%r8d
 107555c:	jmp    1075591 <check_input_run+0x8201>
 107555e:	mov    0x10(%rsi),%r10
 1075562:	mov    %rdi,%r9
 1075565:	sub    %r8,%r9
 1075568:	xor    %r8d,%r8d
 107556b:	sub    %r9,%r10
 107556e:	jb     1075591 <check_input_run+0x8201>
 1075570:	shl    $0x4,%rcx
 1075574:	cmp    %r10,%rcx
 1075577:	ja     1075591 <check_input_run+0x8201>
 1075579:	add    %rcx,%r9
 107557c:	mov    %rdi,%r8
 107557f:	mov    %r9,0x8(%rsi)
 1075583:	mov    0x13c(%rax),%edx
 1075589:	mov    0x2c0(%rsp),%rsi
 1075591:	mov    %r8,0x120(%rax)
 1075598:	mov    (%rsi),%rdi
 107559b:	mov    0x8(%rsi),%r8
 107559f:	lea    0x3(%r8,%rdi,1),%rcx
 10755a4:	add    %rdi,%r8
 10755a7:	and    $0xfffffffffffffffc,%rcx
 10755ab:	cmp    %r8,%rcx
 10755ae:	jae    10755b4 <check_input_run+0x8224>
 10755b0:	xor    %edi,%edi
 10755b2:	jmp    10755d8 <check_input_run+0x8248>
 10755b4:	mov    0x10(%rsi),%r9
 10755b8:	mov    %rcx,%r8
 10755bb:	sub    %rdi,%r8
 10755be:	xor    %edi,%edi
 10755c0:	sub    %r8,%r9
 10755c3:	jb     10755d8 <check_input_run+0x8248>
 10755c5:	shl    $0x4,%rdx
 10755c9:	cmp    %r9,%rdx
 10755cc:	ja     10755d8 <check_input_run+0x8248>
 10755ce:	add    %rdx,%r8
 10755d1:	mov    %rcx,%rdi
 10755d4:	mov    %r8,0x8(%rsi)
 10755d8:	mov    %rdi,0x130(%rax)
 10755df:	mov    0x2c8(%rsp),%rcx
 10755e7:	mov    (%rcx),%rdi
 10755ea:	mov    0x8(%rcx),%rsi
 10755ee:	lea    0x3(%rsi,%rdi,1),%rdx
 10755f3:	add    %rdi,%rsi
 10755f6:	and    $0xfffffffffffffffc,%rdx
 10755fa:	cmp    %rsi,%rdx
 10755fd:	jae    1075603 <check_input_run+0x8273>
 10755ff:	xor    %edi,%edi
 1075601:	jmp    1075632 <check_input_run+0x82a2>
 1075603:	mov    0x10(%rcx),%r8
 1075607:	mov    %rdx,%rsi
 107560a:	sub    %rdi,%rsi
 107560d:	xor    %edi,%edi
 107560f:	sub    %rsi,%r8
 1075612:	jb     1075632 <check_input_run+0x82a2>
 1075614:	mov    0x364(%rax),%r9d
 107561b:	lea    0x4(,%r9,4),%r9
 1075623:	cmp    %r8,%r9
 1075626:	ja     1075632 <check_input_run+0x82a2>
 1075628:	add    %r9,%rsi
 107562b:	mov    %rdx,%rdi
 107562e:	mov    %rsi,0x8(%rcx)
 1075632:	mov    %rdi,0x518(%rsp)
 107563a:	cmpq   $0x0,0x120(%rax)
 1075642:	je     1075691 <check_input_run+0x8301>
 1075644:	test   %rdi,%rdi
 1075647:	je     1075691 <check_input_run+0x8301>
 1075649:	cmpq   $0x0,0x130(%rax)
 1075651:	je     1075691 <check_input_run+0x8301>
 1075653:	mov    0x364(%rax),%eax
 1075659:	mov    $0xff,%esi
 107565e:	lea    0x4(,%rax,4),%rdx
 1075666:	vzeroupper
 1075669:	call   788430 <memset@plt>
 107566e:	lea    0x2a0(%rsp),%rdi
 1075676:	vzeroupper
 1075679:	call   1089270 <check_input_expressions>
 107567e:	mov    0x18(%rsp),%rax
 1075683:	cmpb   $0x0,0x3c5(%rax)
 107568a:	je     10756aa <check_input_run+0x831a>
 107568c:	jmp    1075a7c <check_input_run+0x86ec>
 1075691:	movb   $0x1,0x3c5(%rax)
 1075698:	mov    0x18(%rsp),%rax
 107569d:	cmpb   $0x0,0x3c5(%rax)
 10756a4:	jne    1075a7c <check_input_run+0x86ec>
 10756aa:	mov    0x2a0(%rsp),%rbx
 10756b2:	mov    0x2a8(%rsp),%r14
 10756ba:	lea    0x2a0(%rsp),%rdi
 10756c2:	vzeroupper
 10756c5:	call   10fbea0 <check_input_asm_labels>
 10756ca:	mov    0x34c(%rbx),%eax
 10756d0:	test   %eax,%eax
 10756d2:	je     10757e2 <check_input_run+0x8452>
 10756d8:	xor    %edx,%edx
 10756da:	jmp    10756f2 <check_input_run+0x8362>
 10756dc:	mov    0x34c(%rbx),%eax
 10756e2:	mov    0x48(%rsp),%rdx
 10756e7:	inc    %rdx
 10756ea:	test   %eax,%eax
 10756ec:	je     10757e2 <check_input_run+0x8452>
 10756f2:	mov    0x670(%rsp),%ecx
 10756f9:	cmp    %rcx,%rdx
 10756fc:	jae    10757e2 <check_input_run+0x8452>
 1075702:	cmpb   $0x1,0x3c5(%rbx)
 1075709:	je     10757e2 <check_input_run+0x8452>
 107570f:	mov    0x270(%rbx),%rcx
 1075716:	cmpb   $0x0,(%rcx,%rdx,1)
 107571a:	je     10756e7 <check_input_run+0x8357>
 107571c:	mov    0x288(%rbx),%rcx
 1075723:	mov    (%rcx,%rdx,8),%r12
 1075727:	test   %r12,%r12
 107572a:	je     10756e7 <check_input_run+0x8357>
 107572c:	cmpl   $0x0,0x8(%r12)
 1075732:	je     10756e7 <check_input_run+0x8357>
 1075734:	mov    %rdx,0x48(%rsp)
 1075739:	xor    %r13d,%r13d
 107573c:	xor    %ebp,%ebp
 107573e:	jmp    1075765 <check_input_run+0x83d5>
 1075740:	movb   $0x1,0x3c5(%rax)
 1075747:	nopw   0x0(%rax,%rax,1)
 1075750:	mov    0x8(%r12),%eax
 1075755:	inc    %rbp
 1075758:	add    $0x50,%r13
 107575c:	cmp    %rax,%rbp
 107575f:	jae    10756dc <check_input_run+0x834c>
 1075765:	mov    (%r12),%r15
 1075769:	cmpl   $0x12,0x1c(%r15,%r13,1)
 107576f:	jne    1075750 <check_input_run+0x83c0>
 1075771:	mov    0x4(%r15,%r13,1),%eax
 1075776:	cmp    0x670(%rsp),%eax
 107577d:	ja     1075750 <check_input_run+0x83c0>
 107577f:	mov    0x38(%r15,%r13,1),%rdi
 1075784:	mov    0x40(%r15,%r13,1),%esi
 1075789:	call   10ea5c0 <check_asm_register>
 107578e:	test   %al,%al
 1075790:	jne    1075750 <check_input_run+0x83c0>
 1075792:	mov    0x2a0(%rsp),%rax
 107579a:	mov    0x230(%rax),%ecx
 10757a0:	cmp    0x234(%rax),%ecx
 10757a6:	jae    1075740 <check_input_run+0x83b0>
 10757a8:	movzbl 0x3c5(%rax),%esi
 10757af:	mov    0x10(%r15,%r13,1),%edx
 10757b4:	mov    0x228(%rax),%rdi
 10757bb:	lea    0x1(%rcx),%r8d
 10757bf:	mov    %r8d,0x230(%rax)
 10757c6:	lea    (%rcx,%rcx,2),%rax
 10757ca:	lea    0x1(%rsi,%rsi,2),%esi
 10757ce:	mov    %edx,(%rdi,%rax,4)
 10757d1:	mov    %esi,0x4(%rdi,%rax,4)
 10757d5:	movl   $0x0,0x8(%rdi,%rax,4)
 10757dd:	jmp    1075750 <check_input_run+0x83c0>
 10757e2:	cmpl   $0x0,0x348(%rbx)
 10757e9:	mov    0x20(%rsp),%r12
 10757ee:	je     1075a7c <check_input_run+0x86ec>
 10757f4:	xor    %eax,%eax
 10757f6:	jmp    1075812 <check_input_run+0x8482>
 10757f8:	nopl   0x0(%rax,%rax,1)
 1075800:	mov    0x348(%rbx),%ecx
 1075806:	inc    %rax
 1075809:	cmp    %rcx,%rax
 107580c:	jae    1075a7c <check_input_run+0x86ec>
 1075812:	cmpb   $0x0,0x3c5(%rbx)
 1075819:	jne    1075a7c <check_input_run+0x86ec>
 107581f:	mov    0x340(%rbx),%rdx
 1075826:	lea    (%rax,%rax,4),%rsi
 107582a:	shl    $0x4,%rsi
 107582e:	mov    0x2c(%rdx,%rsi,1),%edi
 1075832:	lea    (%rdx,%rsi,1),%rcx
 1075836:	add    0x28(%rdx,%rsi,1),%edi
 107583a:	jne    10759d0 <check_input_run+0x8640>
 1075840:	cmpl   $0x0,0x34(%rcx)
 1075844:	je     1075800 <check_input_run+0x8470>
 1075846:	xor    %edx,%edx
 1075848:	jmp    1075868 <check_input_run+0x84d8>
 107584a:	nopw   0x0(%rax,%rax,1)
 1075850:	movb   $0x1,0x3c5(%r8)
 1075858:	mov    0x34(%rcx),%esi
 107585b:	mov    0x20(%rsp),%r12
 1075860:	inc    %rdx
 1075863:	cmp    %rsi,%rdx
 1075866:	jae    1075800 <check_input_run+0x8470>
 1075868:	lea    (%rdx,%rdx,2),%rsi
 107586c:	mov    0x44(%rcx),%r8d
 1075870:	shl    $0x2,%rsi
 1075874:	add    0x20(%rcx),%rsi
 1075878:	cmp    0x364(%rbx),%r8d
 107587f:	jae    10758f0 <check_input_run+0x8560>
 1075881:	mov    0x60(%r14),%rdi
 1075885:	lea    0x1(%r8),%r9
 1075889:	mov    (%rdi,%r8,4),%r10d
 107588d:	mov    0x8(%rsi),%edi
 1075890:	cmp    %r10d,%r9d
 1075893:	jae    10758f3 <check_input_run+0x8563>
 1075895:	not    %r8d
 1075898:	add    %r10d,%r8d
 107589b:	mov    %edi,%r10d
 107589e:	jmp    10758a8 <check_input_run+0x8518>
 10758a0:	inc    %r9
 10758a3:	dec    %r8d
 10758a6:	je     10758f3 <check_input_run+0x8563>
 10758a8:	cmp    $0xffffffff,%r10d
 10758ac:	jne    10758f3 <check_input_run+0x8563>
 10758ae:	mov    0x50(%r14),%r11
 10758b2:	mov    $0xffffffff,%r10d
 10758b8:	cmpb   $0x21,(%r11,%r9,1)
 10758bd:	jne    10758a0 <check_input_run+0x8510>
 10758bf:	mov    0x610(%rsp),%r11
 10758c7:	mov    (%r11,%r9,4),%r11d
 10758cb:	cmp    0x364(%rbx),%r11d
 10758d2:	jae    10758a0 <check_input_run+0x8510>
 10758d4:	mov    0x18(%r14),%r15
 10758d8:	mov    (%r15,%r11,4),%r11d
 10758dc:	cmp    (%rsi),%r11d
 10758df:	jne    10758a0 <check_input_run+0x8510>
 10758e1:	mov    %r9d,0x8(%rsi)
 10758e5:	mov    %r9d,%edi
 10758e8:	mov    %r9d,%r10d
 10758eb:	jmp    10758a0 <check_input_run+0x8510>
 10758ed:	nopl   (%rax)
 10758f0:	mov    0x8(%rsi),%edi
 10758f3:	cmp    $0xffffffff,%edi
 10758f6:	je     1075970 <check_input_run+0x85e0>
 10758f8:	mov    0x2a8(%rsp),%r9
 1075900:	mov    0x30(%r9),%r10d
 1075904:	cmp    %r10d,%edi
 1075907:	jae    1075858 <check_input_run+0x84c8>
 107590d:	mov    0x2a0(%rsp),%r8
 1075915:	mov    0x38(%rcx),%r11d
 1075919:	mov    0x320(%r8),%r15
 1075920:	jmp    1075941 <check_input_run+0x85b1>
 1075922:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1075930:	mov    0x60(%r9),%r12
 1075934:	mov    (%r12,%rdi,4),%edi
 1075938:	cmp    %r10d,%edi
 107593b:	jae    1075858 <check_input_run+0x84c8>
 1075941:	mov    %edi,%edi
 1075943:	mov    (%r15,%rdi,4),%r12d
 1075947:	test   %r12d,%r12d
 107594a:	je     1075930 <check_input_run+0x85a0>
 107594c:	mov    0x318(%r8),%r13
 1075953:	dec    %r12d
 1075956:	lea    (%r12,%r12,2),%r12
 107595a:	cmp    0x0(%r13,%r12,8),%r11d
 107595f:	jbe    1075978 <check_input_run+0x85e8>
 1075961:	lea    0x0(%r13,%r12,8),%r12
 1075966:	cmp    0x4(%r12),%r11d
 107596b:	jb     1075930 <check_input_run+0x85a0>
 107596d:	jmp    1075978 <check_input_run+0x85e8>
 107596f:	nop
 1075970:	mov    0x2a0(%rsp),%r8
 1075978:	mov    0x230(%r8),%edi
 107597f:	cmp    0x234(%r8),%edi
 1075986:	jae    1075850 <check_input_run+0x84c0>
 107598c:	movzbl 0x3c5(%r8),%r9d
 1075994:	mov    0x4(%rsi),%esi
 1075997:	mov    0x228(%r8),%r10
 107599e:	lea    0x1(%rdi),%r11d
 10759a2:	lea    (%rdi,%rdi,2),%rdi
 10759a6:	mov    %r11d,0x230(%r8)
 10759ad:	lea    0x2(%r9,%r9,1),%r9d
 10759b2:	mov    %esi,(%r10,%rdi,4)
 10759b6:	mov    %r9d,0x4(%r10,%rdi,4)
 10759bb:	movl   $0x0,0x8(%r10,%rdi,4)
 10759c4:	jmp    1075858 <check_input_run+0x84c8>
 10759c9:	nopl   0x0(%rax)
 10759d0:	mov    $0x20,%edx
 10759d5:	xor    %esi,%esi
 10759d7:	jmp    10759fe <check_input_run+0x866e>
 10759d9:	nopl   0x0(%rax)
 10759e0:	movb   $0x1,0x3c5(%r8)
 10759e8:	mov    0x2c(%rcx),%edi
 10759eb:	inc    %rsi
 10759ee:	add    $0x30,%rdx
 10759f2:	add    0x28(%rcx),%edi
 10759f5:	cmp    %rdi,%rsi
 10759f8:	jae    1075840 <check_input_run+0x84b0>
 10759fe:	mov    0x10(%rcx),%rdi
 1075a02:	mov    0x2c0(%rbx),%r9
 1075a09:	mov    -0x4(%rdi,%rdx,1),%r8d
 1075a0e:	mov    (%r9,%r8,4),%r9d
 1075a12:	mov    %r9d,(%rdi,%rdx,1)
 1075a16:	cmp    $0xffffffff,%r9d
 1075a1a:	jne    10759e8 <check_input_run+0x8658>
 1075a1c:	cmp    0x670(%rsp),%r8d
 1075a24:	jae    10759e8 <check_input_run+0x8658>
 1075a26:	mov    0x2a0(%rsp),%r8
 1075a2e:	mov    0x230(%r8),%r9d
 1075a35:	cmp    0x234(%r8),%r9d
 1075a3c:	jae    10759e0 <check_input_run+0x8650>
 1075a3e:	movzbl 0x3c5(%r8),%r10d
 1075a46:	mov    -0xc(%rdi,%rdx,1),%edi
 1075a4a:	mov    0x228(%r8),%r11
 1075a51:	lea    0x1(%r9),%ebp
 1075a55:	mov    %ebp,0x230(%r8)
 1075a5c:	lea    (%r9,%r9,2),%r8
 1075a60:	lea    0x1(%r10,%r10,2),%r10d
 1075a65:	mov    %edi,(%r11,%r8,4)
 1075a69:	mov    %r10d,0x4(%r11,%r8,4)
 1075a6e:	movl   $0x0,0x8(%r11,%r8,4)
 1075a77:	jmp    10759e8 <check_input_run+0x8658>
 1075a7c:	mov    0x18(%rsp),%rax
 1075a81:	cmpl   $0x0,0x230(%rax)
 1075a88:	movzbl 0x3c5(%rax),%eax
 1075a8f:	je     1075a9b <check_input_run+0x870b>
 1075a91:	mov    %eax,%ecx
 1075a93:	xor    $0x1,%cl
 1075a96:	jmp    1076310 <check_input_run+0x8f80>
 1075a9b:	test   %al,%al
 1075a9d:	je     1075aa6 <check_input_run+0x8716>
 1075a9f:	mov    $0x1,%al
 1075aa1:	jmp    107630e <check_input_run+0x8f7e>
 1075aa6:	mov    0x2a0(%rsp),%rcx
 1075aae:	mov    0x2a8(%rsp),%rax
 1075ab6:	cmpl   $0x0,0x338(%rcx)
 1075abd:	je     1075b4b <check_input_run+0x87bb>
 1075ac3:	xor    %edx,%edx
 1075ac5:	xor    %esi,%esi
 1075ac7:	jmp    1075ae2 <check_input_run+0x8752>
 1075ac9:	movb   $0x1,0x3c5(%rcx)
 1075ad0:	mov    0x338(%rcx),%edi
 1075ad6:	inc    %rsi
 1075ad9:	add    $0x24,%rdx
 1075add:	cmp    %rdi,%rsi
 1075ae0:	jae    1075b4b <check_input_run+0x87bb>
 1075ae2:	mov    0x330(%rcx),%r8
 1075ae9:	cmpb   $0x1,0x20(%r8,%rdx,1)
 1075aef:	jne    1075ad0 <check_input_run+0x8740>
 1075af1:	cmpl   $0xffffffff,0x10(%r8,%rdx,1)
 1075af7:	jne    1075ad0 <check_input_run+0x8740>
 1075af9:	mov    0x230(%rcx),%edi
 1075aff:	cmp    0x234(%rcx),%edi
 1075b05:	jae    1075ac9 <check_input_run+0x8739>
 1075b07:	movzbl 0x3c5(%rcx),%r9d
 1075b0f:	mov    0x8(%r8,%rdx,1),%r8d
 1075b14:	mov    0x228(%rcx),%r10
 1075b1b:	lea    0x1(%rdi),%r11d
 1075b1f:	mov    %r11d,0x230(%rcx)
 1075b26:	lea    (%rdi,%rdi,2),%rcx
 1075b2a:	lea    0x1(%r9,%r9,2),%r9d
 1075b2f:	mov    %r8d,(%r10,%rcx,4)
 1075b33:	mov    %r9d,0x4(%r10,%rcx,4)
 1075b38:	movl   $0x0,0x8(%r10,%rcx,4)
 1075b41:	mov    0x2a0(%rsp),%rcx
 1075b49:	jmp    1075ad0 <check_input_run+0x8740>
 1075b4b:	cmpl   $0x0,0x30(%rax)
 1075b4f:	je     1075cf1 <check_input_run+0x8961>
 1075b55:	xor    %edx,%edx
 1075b57:	xor    %ecx,%ecx
 1075b59:	jmp    1075b86 <check_input_run+0x87f6>
 1075b5b:	nopl   0x0(%rax,%rax,1)
 1075b60:	mov    0x640(%rsp),%rsi
 1075b68:	lea    -0x1(%rdx),%edi
 1075b6b:	mov    (%rsi,%rdi,4),%esi
 1075b6e:	inc    %esi
 1075b70:	mov    0x638(%rsp),%rdi
 1075b78:	mov    %esi,(%rdi,%rcx,4)
 1075b7b:	inc    %rcx
 1075b7e:	mov    0x30(%rax),%edi
 1075b81:	cmp    %rdi,%rcx
 1075b84:	jae    1075be1 <check_input_run+0x8851>
 1075b86:	mov    0x4f8(%rsp),%rdi
 1075b8e:	mov    $0x0,%esi
 1075b93:	test   %edx,%edx
 1075b95:	je     1075bc2 <check_input_run+0x8832>
 1075b97:	mov    %edx,%esi
 1075b99:	mov    0x640(%rsp),%rdx
 1075ba1:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1075bb0:	mov    -0x4(%rdx,%rsi,4),%r8d
 1075bb5:	cmp    %ecx,(%rdi,%r8,4)
 1075bb9:	ja     1075bc2 <check_input_run+0x8832>
 1075bbb:	dec    %rsi
 1075bbe:	jne    1075bb0 <check_input_run+0x8820>
 1075bc0:	xor    %esi,%esi
 1075bc2:	cmpl   $0x0,(%rdi,%rcx,4)
 1075bc6:	je     1075bd7 <check_input_run+0x8847>
 1075bc8:	mov    0x640(%rsp),%rdx
 1075bd0:	mov    %esi,%edi
 1075bd2:	inc    %esi
 1075bd4:	mov    %ecx,(%rdx,%rdi,4)
 1075bd7:	mov    %esi,%edx
 1075bd9:	test   %esi,%esi
 1075bdb:	jne    1075b60 <check_input_run+0x87d0>
 1075bdd:	xor    %esi,%esi
 1075bdf:	jmp    1075b70 <check_input_run+0x87e0>
 1075be1:	lea    0x10(%rax),%rcx
 1075be5:	test   %edi,%edi
 1075be7:	je     1075cf5 <check_input_run+0x8965>
 1075bed:	xor    %edx,%edx
 1075bef:	jmp    1075c0f <check_input_run+0x887f>
 1075bf1:	movb   $0x1,0x3c5(%rsi)
 1075bf8:	nopl   0x0(%rax,%rax,1)
 1075c00:	mov    0x30(%rax),%edi
 1075c03:	inc    %rdx
 1075c06:	cmp    %rdi,%rdx
 1075c09:	jae    1075cf5 <check_input_run+0x8965>
 1075c0f:	mov    (%rcx),%rsi
 1075c12:	cmpb   $0x4f,(%rsi,%rdx,1)
 1075c16:	jne    1075c35 <check_input_run+0x88a5>
 1075c18:	mov    0x2a0(%rsp),%rsi
 1075c20:	mov    0x300(%rsi),%r8
 1075c27:	mov    (%r8,%rdx,4),%r9d
 1075c2b:	mov    %edx,%r8d
 1075c2e:	cmp    %edi,%r9d
 1075c31:	jae    1075c00 <check_input_run+0x8870>
 1075c33:	jmp    1075c73 <check_input_run+0x88e3>
 1075c35:	mov    0x50(%rax),%rsi
 1075c39:	cmpb   $0x3a,(%rsi,%rdx,1)
 1075c3d:	jne    1075c00 <check_input_run+0x8870>
 1075c3f:	mov    0x2a0(%rsp),%rsi
 1075c47:	mov    0x2f8(%rsi),%r8
 1075c4e:	mov    (%r8,%rdx,4),%r8d
 1075c52:	cmp    %edi,%r8d
 1075c55:	jae    1075c65 <check_input_run+0x88d5>
 1075c57:	mov    0x610(%rsp),%r9
 1075c5f:	mov    (%r9,%r8,4),%r8d
 1075c63:	jmp    1075c6b <check_input_run+0x88db>
 1075c65:	mov    $0xffffffff,%r8d
 1075c6b:	mov    %edx,%r9d
 1075c6e:	cmp    %edi,%r9d
 1075c71:	jae    1075c00 <check_input_run+0x8870>
 1075c73:	mov    0x638(%rsp),%rdi
 1075c7b:	mov    %r9d,%r9d
 1075c7e:	mov    (%rdi,%r9,4),%edi
 1075c82:	test   %edi,%edi
 1075c84:	je     1075c00 <check_input_run+0x8870>
 1075c8a:	dec    %edi
 1075c8c:	cmp    %edi,%r8d
 1075c8f:	jb     1075ca5 <check_input_run+0x8915>
 1075c91:	mov    0x4f8(%rsp),%r9
 1075c99:	mov    %edi,%edi
 1075c9b:	cmp    (%r9,%rdi,4),%r8d
 1075c9f:	jb     1075c00 <check_input_run+0x8870>
 1075ca5:	mov    0x230(%rsi),%edi
 1075cab:	cmp    0x234(%rsi),%edi
 1075cb1:	jae    1075bf1 <check_input_run+0x8861>
 1075cb7:	movzbl 0x3c5(%rsi),%r8d
 1075cbf:	mov    0x228(%rsi),%r9
 1075cc6:	lea    0x1(%rdi),%r10d
 1075cca:	mov    %r10d,0x230(%rsi)
 1075cd1:	lea    (%rdi,%rdi,2),%rsi
 1075cd5:	lea    0x1(%r8,%r8,2),%r8d
 1075cda:	mov    %edx,(%r9,%rsi,4)
 1075cde:	mov    %r8d,0x4(%r9,%rsi,4)
 1075ce3:	movl   $0x0,0x8(%r9,%rsi,4)
 1075cec:	jmp    1075c00 <check_input_run+0x8870>
 1075cf1:	lea    0x10(%rax),%rcx
 1075cf5:	mov    0x678(%rsp),%edi
 1075cfc:	test   %edi,%edi
 1075cfe:	je     10762f5 <check_input_run+0x8f65>
 1075d04:	xor    %esi,%esi
 1075d06:	jmp    1075d19 <check_input_run+0x8989>
 1075d08:	mov    %esi,%r13d
 1075d0b:	inc    %r13d
 1075d0e:	mov    %r13d,%esi
 1075d11:	test   %edi,%edi
 1075d13:	je     10762f5 <check_input_run+0x8f65>
 1075d19:	mov    0x30(%rax),%r10d
 1075d1d:	cmp    %r10d,%esi
 1075d20:	jae    10762f5 <check_input_run+0x8f65>
 1075d26:	mov    0x2a0(%rsp),%r11
 1075d2e:	mov    %esi,%r8d
 1075d31:	mov    0x1f0(%r11),%rdx
 1075d38:	test   %rdx,%rdx
 1075d3b:	je     1075d44 <check_input_run+0x89b4>
 1075d3d:	cmpb   $0x0,(%rdx,%r8,1)
 1075d42:	jne    1075d08 <check_input_run+0x8978>
 1075d44:	mov    0x50(%rax),%rbx
 1075d48:	lea    0x0(,%r8,4),%rdx
 1075d50:	add    0x60(%rax),%rdx
 1075d54:	cmpb   $0x34,(%rbx,%r8,1)
 1075d59:	jne    1075d08 <check_input_run+0x8978>
 1075d5b:	mov    (%rdx),%r13d
 1075d5e:	cmp    %r10d,%r13d
 1075d61:	jae    1075d08 <check_input_run+0x8978>
 1075d63:	lea    0x1(%r8),%r9
 1075d67:	cmp    %r13d,%r9d
 1075d6a:	jae    1075d0b <check_input_run+0x897b>
 1075d6c:	mov    %esi,%r14d
 1075d6f:	sub    %r13d,%r14d
 1075d72:	mov    %esi,%edi
 1075d74:	not    %edi
 1075d76:	lea    -0x2(%r13),%ebp
 1075d7a:	mov    %r8,0x28(%rsp)
 1075d7f:	not    %r14d
 1075d82:	mov    %ebp,%edx
 1075d84:	add    %r13d,%edi
 1075d87:	sub    %esi,%edx
 1075d89:	and    $0x3,%r14d
 1075d8d:	mov    %edi,0x48(%rsp)
 1075d91:	cmp    $0x3,%edx
 1075d94:	jae    1075da7 <check_input_run+0x8a17>
 1075d96:	xor    %r8d,%r8d
 1075d99:	mov    $0xffffffff,%r12d
 1075d9f:	mov    %r9,%r15
 1075da2:	jmp    1075fc8 <check_input_run+0x8c38>
 1075da7:	mov    %ebp,0xd0(%rsp)
 1075dae:	lea    0x3(%rbx,%r9,1),%rbp
 1075db3:	and    $0xfffffffc,%edi
 1075db6:	mov    $0xffffffff,%r12d
 1075dbc:	mov    %r13,0x90(%rsp)
 1075dc4:	xor    %r15d,%r15d
 1075dc7:	xor    %r8d,%r8d
 1075dca:	nopw   0x0(%rax,%rax,1)
 1075dd0:	cmpb   $0x9,-0x3(%rbp,%r15,1)
 1075dd6:	jne    1075e30 <check_input_run+0x8aa0>
 1075dd8:	mov    (%rcx),%rdx
 1075ddb:	add    %r9,%rdx
 1075dde:	cmpb   $0xf,(%r15,%rdx,1)
 1075de3:	jne    1075e30 <check_input_run+0x8aa0>
 1075de5:	mov    0x300(%r11),%rdx
 1075dec:	lea    0x0(,%r9,4),%r13
 1075df4:	add    %r13,%rdx
 1075df7:	mov    (%rdx,%r15,4),%edx
 1075dfb:	cmp    %r10d,%edx
 1075dfe:	jae    1075e30 <check_input_run+0x8aa0>
 1075e00:	mov    0x638(%rsp),%r13
 1075e08:	mov    0x0(%r13,%rdx,4),%edx
 1075e0d:	test   %edx,%edx
 1075e0f:	je     1075e30 <check_input_run+0x8aa0>
 1075e11:	mov    0x4f8(%rsp),%r13
 1075e19:	dec    %edx
 1075e1b:	cmp    %r8d,%edx
 1075e1e:	cmova  %edx,%r8d
 1075e22:	mov    0x0(%r13,%rdx,4),%edx
 1075e27:	cmp    %r12d,%edx
 1075e2a:	cmovb  %edx,%r12d
 1075e2e:	xchg   %ax,%ax
 1075e30:	cmpb   $0x9,-0x2(%rbp,%r15,1)
 1075e36:	jne    1075e90 <check_input_run+0x8b00>
 1075e38:	mov    (%rcx),%rdx
 1075e3b:	add    %r9,%rdx
 1075e3e:	cmpb   $0xf,0x1(%r15,%rdx,1)
 1075e44:	jne    1075e90 <check_input_run+0x8b00>
 1075e46:	mov    0x300(%r11),%rdx
 1075e4d:	lea    0x0(,%r9,4),%r13
 1075e55:	add    %r13,%rdx
 1075e58:	mov    0x4(%rdx,%r15,4),%edx
 1075e5d:	cmp    %r10d,%edx
 1075e60:	jae    1075e90 <check_input_run+0x8b00>
 1075e62:	mov    0x638(%rsp),%r13
 1075e6a:	mov    0x0(%r13,%rdx,4),%edx
 1075e6f:	test   %edx,%edx
 1075e71:	je     1075e90 <check_input_run+0x8b00>
 1075e73:	mov    0x4f8(%rsp),%r13
 1075e7b:	dec    %edx
 1075e7d:	cmp    %r8d,%edx
 1075e80:	cmova  %edx,%r8d
 1075e84:	mov    0x0(%r13,%rdx,4),%edx
 1075e89:	cmp    %r12d,%edx
 1075e8c:	cmovb  %edx,%r12d
 1075e90:	cmpb   $0x9,-0x1(%rbp,%r15,1)
 1075e96:	jne    1075f10 <check_input_run+0x8b80>
 1075e98:	mov    (%rcx),%rdx
 1075e9b:	add    %r9,%rdx
 1075e9e:	cmpb   $0xf,0x2(%r15,%rdx,1)
 1075ea4:	jne    1075f10 <check_input_run+0x8b80>
 1075ea6:	mov    0x300(%r11),%rdx
 1075ead:	lea    0x0(,%r9,4),%r13
 1075eb5:	add    %r13,%rdx
 1075eb8:	mov    0x8(%rdx,%r15,4),%edx
 1075ebd:	cmp    %r10d,%edx
 1075ec0:	jae    1075f10 <check_input_run+0x8b80>
 1075ec2:	mov    0x638(%rsp),%r13
 1075eca:	mov    0x0(%r13,%rdx,4),%edx
 1075ecf:	test   %edx,%edx
 1075ed1:	je     1075f10 <check_input_run+0x8b80>
 1075ed3:	dec    %edx
 1075ed5:	mov    %edx,%r13d
 1075ed8:	cmp    %r8d,%edx
 1075edb:	ja     1075ee0 <check_input_run+0x8b50>
 1075edd:	mov    %r8d,%r13d
 1075ee0:	mov    0x4f8(%rsp),%r8
 1075ee8:	mov    (%r8,%rdx,4),%edx
 1075eec:	cmp    %r12d,%edx
 1075eef:	jb     1075ef4 <check_input_run+0x8b64>
 1075ef1:	mov    %r12d,%edx
 1075ef4:	mov    %edx,%r12d
 1075ef7:	cmpb   $0x9,0x0(%rbp,%r15,1)
 1075efd:	jne    1075f90 <check_input_run+0x8c00>
 1075f03:	jmp    1075f1b <check_input_run+0x8b8b>
 1075f05:	data16 cs nopw 0x0(%rax,%rax,1)
 1075f10:	mov    %r8d,%r13d
 1075f13:	cmpb   $0x9,0x0(%rbp,%r15,1)
 1075f19:	jne    1075f90 <check_input_run+0x8c00>
 1075f1b:	mov    (%rcx),%rdx
 1075f1e:	add    %r9,%rdx
 1075f21:	cmpb   $0xf,0x3(%r15,%rdx,1)
 1075f27:	jne    1075f90 <check_input_run+0x8c00>
 1075f29:	mov    0x300(%r11),%rdx
 1075f30:	lea    0x0(,%r9,4),%r8
 1075f38:	add    %r8,%rdx
 1075f3b:	mov    0xc(%rdx,%r15,4),%edx
 1075f40:	cmp    %r10d,%edx
 1075f43:	jae    1075f90 <check_input_run+0x8c00>
 1075f45:	mov    0x638(%rsp),%r8
 1075f4d:	mov    (%r8,%rdx,4),%edx
 1075f51:	test   %edx,%edx
 1075f53:	je     1075f90 <check_input_run+0x8c00>
 1075f55:	dec    %edx
 1075f57:	mov    %edx,%r8d
 1075f5a:	cmp    %r13d,%edx
 1075f5d:	ja     1075f62 <check_input_run+0x8bd2>
 1075f5f:	mov    %r13d,%r8d
 1075f62:	mov    0x4f8(%rsp),%r13
 1075f6a:	mov    0x0(%r13,%rdx,4),%edx
 1075f6f:	cmp    %r12d,%edx
 1075f72:	jb     1075f77 <check_input_run+0x8be7>
 1075f74:	mov    %r12d,%edx
 1075f77:	mov    %edx,%r12d
 1075f7a:	add    $0x4,%r15
 1075f7e:	cmp    %r15d,%edi
 1075f81:	jne    1075dd0 <check_input_run+0x8a40>
 1075f87:	jmp    1075fa0 <check_input_run+0x8c10>
 1075f89:	nopl   0x0(%rax)
 1075f90:	mov    %r13d,%r8d
 1075f93:	add    $0x4,%r15
 1075f97:	cmp    %r15d,%edi
 1075f9a:	jne    1075dd0 <check_input_run+0x8a40>
 1075fa0:	test   %r14d,%r14d
 1075fa3:	je     1076015 <check_input_run+0x8c85>
 1075fa5:	mov    0x90(%rsp),%r13
 1075fad:	mov    0xd0(%rsp),%ebp
 1075fb4:	add    %r9,%r15
 1075fb7:	jmp    1075fc8 <check_input_run+0x8c38>
 1075fb9:	nopl   0x0(%rax)
 1075fc0:	inc    %r15
 1075fc3:	dec    %r14d
 1075fc6:	je     1076024 <check_input_run+0x8c94>
 1075fc8:	cmpb   $0x9,(%rbx,%r15,1)
 1075fcd:	jne    1075fc0 <check_input_run+0x8c30>
 1075fcf:	mov    (%rcx),%rdx
 1075fd2:	cmpb   $0xf,(%rdx,%r15,1)
 1075fd7:	jne    1075fc0 <check_input_run+0x8c30>
 1075fd9:	mov    0x300(%r11),%rdx
 1075fe0:	mov    (%rdx,%r15,4),%edx
 1075fe4:	cmp    %r10d,%edx
 1075fe7:	jae    1075fc0 <check_input_run+0x8c30>
 1075fe9:	mov    0x638(%rsp),%rdi
 1075ff1:	mov    (%rdi,%rdx,4),%edx
 1075ff4:	test   %edx,%edx
 1075ff6:	je     1075fc0 <check_input_run+0x8c30>
 1075ff8:	mov    0x4f8(%rsp),%rdi
 1076000:	dec    %edx
 1076002:	cmp    %r8d,%edx
 1076005:	cmova  %edx,%r8d
 1076009:	mov    (%rdi,%rdx,4),%edx
 107600c:	cmp    %r12d,%edx
 107600f:	cmovb  %edx,%r12d
 1076013:	jmp    1075fc0 <check_input_run+0x8c30>
 1076015:	mov    0x90(%rsp),%r13
 107601d:	mov    0xd0(%rsp),%ebp
 1076024:	testb  $0x1,0x48(%rsp)
 1076029:	mov    %r12d,%r10d
 107602c:	mov    %r8d,%r11d
 107602f:	jne    107603e <check_input_run+0x8cae>
 1076031:	mov    0x20(%rsp),%r12
 1076036:	mov    %r9,%rdi
 1076039:	jmp    10760f9 <check_input_run+0x8d69>
 107603e:	mov    (%rcx),%r8
 1076041:	mov    0x20(%rsp),%r12
 1076046:	lea    0x1(%r9),%rdi
 107604a:	cmpb   $0x4f,(%r8,%r9,1)
 107604f:	jne    10760f9 <check_input_run+0x8d69>
 1076055:	mov    0x30(%rax),%edx
 1076058:	cmp    %rdx,%rdi
 107605b:	jae    10760f9 <check_input_run+0x8d69>
 1076061:	mov    0x60(%rax),%rdx
 1076065:	mov    0x28(%rsp),%rbx
 107606a:	cmp    0x8(%rdx,%rbx,4),%r9d
 107606f:	jne    10760f9 <check_input_run+0x8d69>
 1076075:	mov    0x50(%rax),%rdx
 1076079:	cmpb   $0x1a,(%rdx,%rdi,1)
 107607d:	jne    10760f9 <check_input_run+0x8d69>
 107607f:	cmpb   $0x11,(%r8,%rdi,1)
 1076084:	jne    10760f9 <check_input_run+0x8d69>
 1076086:	mov    0x2a0(%rsp),%r8
 107608e:	mov    0x350(%r8),%rdx
 1076095:	cmpl   $0x0,0x4(%rdx,%rbx,4)
 107609a:	jne    10760f9 <check_input_run+0x8d69>
 107609c:	cmp    %r11d,%r9d
 107609f:	jb     10760a6 <check_input_run+0x8d16>
 10760a1:	cmp    %r10d,%r9d
 10760a4:	jb     10760f9 <check_input_run+0x8d69>
 10760a6:	mov    0x230(%r8),%edx
 10760ad:	mov    %ebp,%r15d
 10760b0:	cmp    0x234(%r8),%edx
 10760b7:	jae    10760ee <check_input_run+0x8d5e>
 10760b9:	movzbl 0x3c5(%r8),%ebx
 10760c1:	mov    0x228(%r8),%r14
 10760c8:	lea    0x1(%rdx),%ebp
 10760cb:	lea    (%rdx,%rdx,2),%rdx
 10760cf:	mov    %ebp,0x230(%r8)
 10760d6:	lea    0x1(%rbx,%rbx,2),%ebx
 10760da:	mov    %r9d,(%r14,%rdx,4)
 10760de:	mov    %ebx,0x4(%r14,%rdx,4)
 10760e3:	movl   $0x0,0x8(%r14,%rdx,4)
 10760ec:	jmp    10760f6 <check_input_run+0x8d66>
 10760ee:	movb   $0x1,0x3c5(%r8)
 10760f6:	mov    %r15d,%ebp
 10760f9:	cmp    %esi,%ebp
 10760fb:	jne    1076109 <check_input_run+0x8d79>
 10760fd:	mov    0x678(%rsp),%edi
 1076104:	jmp    1075d0b <check_input_run+0x897b>
 1076109:	lea    0x0(,%rdi,4),%r8
 1076111:	mov    %r13d,%esi
 1076114:	sub    %edi,%esi
 1076116:	xor    %r9d,%r9d
 1076119:	jmp    1076169 <check_input_run+0x8dd9>
 107611b:	movzbl 0x3c5(%r14),%ebx
 1076123:	mov    0x228(%r14),%r15
 107612a:	lea    0x1(%rdx),%ebp
 107612d:	lea    (%rdx,%rdx,2),%rdx
 1076131:	mov    %ebp,0x230(%r14)
 1076138:	lea    0x1(%rdi,%r9,1),%ebp
 107613d:	lea    0x1(%rbx,%rbx,2),%ebx
 1076141:	mov    %ebp,(%r15,%rdx,4)
 1076145:	mov    %ebx,0x4(%r15,%rdx,4)
 107614a:	movl   $0x0,0x8(%r15,%rdx,4)
 1076153:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1076160:	add    $0x2,%r9
 1076164:	cmp    %r9d,%esi
 1076167:	je     10760fd <check_input_run+0x8d6d>
 1076169:	mov    (%rcx),%r15
 107616c:	lea    (%rdi,%r9,1),%r14
 1076170:	lea    0x1(%rdi,%r9,1),%rbx
 1076175:	cmpb   $0x4f,(%r15,%r14,1)
 107617a:	jne    1076250 <check_input_run+0x8ec0>
 1076180:	mov    0x30(%rax),%edx
 1076183:	cmp    %rdx,%rbx
 1076186:	jae    1076250 <check_input_run+0x8ec0>
 107618c:	mov    0x60(%rax),%rdx
 1076190:	add    %r8,%rdx
 1076193:	mov    0x4(%rdx,%r9,4),%edx
 1076198:	cmp    %rdx,%r14
 107619b:	jne    1076250 <check_input_run+0x8ec0>
 10761a1:	mov    0x50(%rax),%rdx
 10761a5:	add    %rdi,%rdx
 10761a8:	cmpb   $0x1a,0x1(%r9,%rdx,1)
 10761ae:	jne    1076250 <check_input_run+0x8ec0>
 10761b4:	add    %rdi,%r15
 10761b7:	cmpb   $0x11,0x1(%r9,%r15,1)
 10761bd:	jne    1076250 <check_input_run+0x8ec0>
 10761c3:	mov    0x2a0(%rsp),%r15
 10761cb:	mov    0x350(%r15),%rdx
 10761d2:	add    %r8,%rdx
 10761d5:	cmpl   $0x0,(%rdx,%r9,4)
 10761da:	jne    1076250 <check_input_run+0x8ec0>
 10761dc:	cmp    %r11,%r14
 10761df:	jb     10761e6 <check_input_run+0x8e56>
 10761e1:	cmp    %r10,%r14
 10761e4:	jb     1076250 <check_input_run+0x8ec0>
 10761e6:	mov    0x230(%r15),%edx
 10761ed:	cmp    0x234(%r15),%edx
 10761f4:	jae    1076246 <check_input_run+0x8eb6>
 10761f6:	movzbl 0x3c5(%r15),%r12d
 10761fe:	mov    %r13,0x90(%rsp)
 1076206:	lea    0x1(%rdx),%r13d
 107620a:	lea    (%rdx,%rdx,2),%rdx
 107620e:	lea    0x1(%r12,%r12,2),%ebp
 1076213:	mov    0x228(%r15),%r12
 107621a:	mov    %r13d,0x230(%r15)
 1076221:	lea    (%rdi,%r9,1),%r15d
 1076225:	mov    0x90(%rsp),%r13
 107622d:	mov    %r15d,(%r12,%rdx,4)
 1076231:	mov    %ebp,0x4(%r12,%rdx,4)
 1076236:	movl   $0x0,0x8(%r12,%rdx,4)
 107623f:	mov    0x20(%rsp),%r12
 1076244:	jmp    1076250 <check_input_run+0x8ec0>
 1076246:	movb   $0x1,0x3c5(%r15)
 107624e:	xchg   %ax,%ax
 1076250:	mov    (%rcx),%r15
 1076253:	cmpb   $0x4f,0x1(%r15,%r14,1)
 1076259:	jne    1076160 <check_input_run+0x8dd0>
 107625f:	mov    0x30(%rax),%r14d
 1076263:	lea    0x2(%rdi,%r9,1),%rdx
 1076268:	cmp    %r14,%rdx
 107626b:	jae    1076160 <check_input_run+0x8dd0>
 1076271:	mov    0x60(%rax),%rdx
 1076275:	add    %r8,%rdx
 1076278:	mov    0x8(%rdx,%r9,4),%edx
 107627d:	cmp    %rdx,%rbx
 1076280:	jne    1076160 <check_input_run+0x8dd0>
 1076286:	mov    0x50(%rax),%rdx
 107628a:	add    %rdi,%rdx
 107628d:	cmpb   $0x1a,0x2(%r9,%rdx,1)
 1076293:	jne    1076160 <check_input_run+0x8dd0>
 1076299:	add    %rdi,%r15
 107629c:	cmpb   $0x11,0x2(%r9,%r15,1)
 10762a2:	jne    1076160 <check_input_run+0x8dd0>
 10762a8:	mov    0x2a0(%rsp),%r14
 10762b0:	mov    0x350(%r14),%rdx
 10762b7:	add    %r8,%rdx
 10762ba:	cmpl   $0x0,0x4(%rdx,%r9,4)
 10762c0:	jne    1076160 <check_input_run+0x8dd0>
 10762c6:	cmp    %r11,%rbx
 10762c9:	jb     10762d4 <check_input_run+0x8f44>
 10762cb:	cmp    %r10,%rbx
 10762ce:	jb     1076160 <check_input_run+0x8dd0>
 10762d4:	mov    0x230(%r14),%edx
 10762db:	cmp    0x234(%r14),%edx
 10762e2:	jb     107611b <check_input_run+0x8d8b>
 10762e8:	movb   $0x1,0x3c5(%r14)
 10762f0:	jmp    1076160 <check_input_run+0x8dd0>
 10762f5:	mov    0x18(%rsp),%rax
 10762fa:	cmpl   $0x0,0x230(%rax)
 1076301:	movzbl 0x3c5(%rax),%eax
 1076308:	jne    1075a91 <check_input_run+0x8701>
 107630e:	xor    %ecx,%ecx
 1076310:	mov    0x18(%rsp),%rdx
 1076315:	mov    %cl,0x3c4(%rdx)
 107631b:	mov    0x38(%rsp),%rcx
 1076320:	test   %al,%al
 1076322:	je     1076368 <check_input_run+0x8fd8>
 1076324:	xor    %eax,%eax
 1076326:	mov    0x270(%rsp),%rdx
 107632e:	cmp    0x8(%rcx),%rdx
 1076332:	ja     107a8df <check_input_run+0xd54f>
 1076338:	mov    %rdx,0x8(%rcx)
 107633c:	mov    %fs:0x28,%rcx
 1076345:	cmp    0x800(%rsp),%rcx
 107634d:	jne    107a901 <check_input_run+0xd571>
 1076353:	add    $0x808,%rsp
 107635a:	pop    %rbx
 107635b:	pop    %r12
 107635d:	pop    %r13
 107635f:	pop    %r14
 1076361:	pop    %r15
 1076363:	pop    %rbp
 1076364:	vzeroupper
 1076367:	ret
 1076368:	mov    0x18(%rsp),%rdx
 107636d:	xor    %eax,%eax
 107636f:	cmpl   $0x0,0x230(%rdx)
 1076376:	jne    1076326 <check_input_run+0x8f96>
 1076378:	cmpb   $0x0,0x338(%rsp)
 1076380:	je     1076326 <check_input_run+0x8f96>
 1076382:	mov    0x18(%rsp),%rbx
 1076387:	mov    0x38(%rsp),%rax
 107638c:	mov    0x5f0(%rsp),%r9
 1076394:	mov    0xa0(%rsp),%r8
 107639c:	lea    0x2d0(%rsp),%rdx
 10763a4:	mov    %r12,%rsi
 10763a7:	mov    0x240(%rbx),%rcx
 10763ae:	mov    %rax,0x8(%rsp)
 10763b3:	mov    0x10(%rsp),%rax
 10763b8:	lea    0x140(%rbx),%rdi
 10763bf:	mov    %rax,(%rsp)
 10763c3:	vzeroupper
 10763c6:	call   108eba0 <check_environment_publish>
 10763cb:	mov    %eax,%ecx
 10763cd:	xor    $0x1,%cl
 10763d0:	or     %cl,0x3c5(%rbx)
 10763d6:	jmp    10704b4 <check_input_run+0x3124>
 10763db:	mov    %rax,%rdx
 10763de:	sub    %rsi,%rdx
 10763e1:	mov    0x10(%rdi),%rsi
 10763e5:	xor    %ebp,%ebp
 10763e7:	sub    %rdx,%rsi
 10763ea:	jb     1075091 <check_input_run+0x7d01>
 10763f0:	mov    $0x0,%edi
 10763f5:	mov    %rdi,0x210(%rsp)
 10763fd:	cmp    %r9,%rsi
 1076400:	jbe    107509d <check_input_run+0x7d0d>
 1076406:	mov    0x10(%rsp),%rdi
 107640b:	lea    0x1(%r9),%rsi
 107640f:	add    %rdx,%rsi
 1076412:	mov    %rsi,0x8(%rdi)
 1076416:	test   %rax,%rax
 1076419:	je     107508f <check_input_run+0x7cff>
 107641f:	mov    (%rcx),%rdi
 1076422:	mov    0x8(%rcx),%rdx
 1076426:	lea    0x3f(%rdx,%rdi,1),%rbp
 107642b:	add    %rdi,%rdx
 107642e:	and    $0xffffffffffffffc0,%rbp
 1076432:	cmp    %rdx,%rbp
 1076435:	jae    1077ec3 <check_input_run+0xab33>
 107643b:	xor    %ebp,%ebp
 107643d:	mov    %rax,0x210(%rsp)
 1076445:	jmp    107509d <check_input_run+0x7d0d>
 107644a:	mov    $0xff,%esi
 107644f:	mov    %r15,%rdi
 1076452:	mov    %r8,%r12
 1076455:	call   788430 <memset@plt>
 107645a:	mov    %r13,%rdi
 107645d:	xor    %esi,%esi
 107645f:	mov    %r12,%rdx
 1076462:	call   788430 <memset@plt>
 1076467:	mov    %r13,0x90(%rsp)
 107646f:	test   %rbp,%rbp
 1076472:	je     1079885 <check_input_run+0xc4f5>
 1076478:	mov    %ebp,%ecx
 107647a:	lea    -0x1(%rbp),%rax
 107647e:	and    $0x3,%ecx
 1076481:	cmp    $0x3,%rax
 1076485:	jae    1077c09 <check_input_run+0xa879>
 107648b:	mov    $0xffffffff,%esi
 1076490:	xor    %edx,%edx
 1076492:	jmp    1077e08 <check_input_run+0xaa78>
 1076497:	mov    0x58(%rsp),%rax
 107649c:	vbroadcasti32x4 -0xae6ff6(%rip),%zmm0        # 58f4b0 <abi_test_hex.digits+0xb20>
 10764a6:	xor    %ecx,%ecx
 10764a8:	xor    %ebx,%ebx
 10764aa:	mov    0xc38(%rax),%r10d
 10764b1:	add    $0x830,%rax
 10764b7:	mov    %rax,0x48(%rsp)
 10764bc:	jmp    10764da <check_input_run+0x914a>
 10764be:	mov    0x58(%rsp),%rax
 10764c3:	mov    0x28(%rsp),%rbx
 10764c8:	mov    0xc38(%rax),%r10d
 10764cf:	inc    %ebx
 10764d1:	cmp    %r10d,%ebx
 10764d4:	ja     10767f4 <check_input_run+0x9464>
 10764da:	mov    $0x1,%r11b
 10764dd:	test   %ebx,%ebx
 10764df:	je     1076506 <check_input_run+0x9176>
 10764e1:	mov    0x58(%rsp),%rax
 10764e6:	mov    0xc30(%rax),%rdx
 10764ed:	test   %rdx,%rdx
 10764f0:	je     1076506 <check_input_run+0x9176>
 10764f2:	lea    -0x1(%rbx),%esi
 10764f5:	xor    %r11d,%r11d
 10764f8:	shl    $0x4,%rsi
 10764fc:	mov    (%rdx,%rsi,1),%r8d
 1076500:	lea    (%rdx,%rsi,1),%rax
 1076504:	jmp    107650b <check_input_run+0x917b>
 1076506:	xor    %eax,%eax
 1076508:	xor    %r8d,%r8d
 107650b:	mov    0x48(%rsp),%r9
 1076510:	cmp    %r10d,%ebx
 1076513:	jae    1076528 <check_input_run+0x9198>
 1076515:	mov    0x58(%rsp),%rdx
 107651a:	mov    %ebx,%r9d
 107651d:	shl    $0x4,%r9
 1076521:	add    0xc30(%rdx),%r9
 1076528:	test   %r11b,%r11b
 107652b:	je     1076539 <check_input_run+0x91a9>
 107652d:	vpxor  %xmm1,%xmm1,%xmm1
 1076531:	xor    %eax,%eax
 1076533:	vpxor  %xmm2,%xmm2,%xmm2
 1076537:	jmp    1076585 <check_input_run+0x91f5>
 1076539:	mov    0x4(%rax),%edx
 107653c:	mov    0x58(%rsp),%rsi
 1076541:	vpxor  %xmm1,%xmm1,%xmm1
 1076545:	vpxor  %xmm2,%xmm2,%xmm2
 1076549:	cmp    0xc18(%rsi),%edx
 107654f:	jae    1076581 <check_input_run+0x91f1>
 1076551:	mov    0x58(%rsp),%rdi
 1076556:	imul   $0x38,%rdx,%rdx
 107655a:	mov    0x8(%rax),%esi
 107655d:	mov    0xc10(%rdi),%r11
 1076564:	mov    %rbx,%rdi
 1076567:	vpbroadcastd %esi,%zmm2
 107656d:	mov    (%r11,%rdx,1),%ebx
 1076571:	sub    %esi,%ebx
 1076573:	add    0x4(%r11,%rdx,1),%ebx
 1076578:	vpbroadcastd %ebx,%zmm1
 107657e:	mov    %rdi,%rbx
 1076581:	movzbl 0xc(%rax),%eax
 1076585:	mov    (%r9),%r9d
 1076588:	cmp    %r9d,%r8d
 107658b:	jae    10764cf <check_input_run+0x913f>
 1076591:	vpbroadcastb %eax,%zmm3
 1076597:	mov    %rbx,0x28(%rsp)
 107659c:	jmp    10765ad <check_input_run+0x921d>
 107659e:	xchg   %ax,%ax
 10765a0:	add    $0x40,%r8d
 10765a4:	cmp    %r9d,%r8d
 10765a7:	jae    10764be <check_input_run+0x912e>
 10765ad:	mov    %r9d,%eax
 10765b0:	sub    %r8d,%eax
 10765b3:	mov    $0x40,%edx
 10765b8:	mov    %r8d,%r10d
 10765bb:	cmp    $0x40,%eax
 10765be:	cmovae %edx,%eax
 10765c1:	mov    $0xffffffffffffffff,%rdx
 10765c8:	bzhi   %rax,%rdx,%rax
 10765cd:	mov    0x58(%rsp),%rdx
 10765d2:	kmovq  %rax,%k1
 10765d7:	mov    %rax,%rsi
 10765da:	shr    $0x20,%rsi
 10765de:	mov    0x828(%rdx),%rbx
 10765e5:	mov    0x818(%rdx),%r11
 10765ec:	mov    %eax,%edx
 10765ee:	shr    $0x10,%edx
 10765f1:	kmovd  %edx,%k2
 10765f5:	vmovdqu32 0x40(%rbx,%r10,4),%zmm5{%k2}{z}
 10765fd:	vmovdqu32 (%rbx,%r10,4),%zmm4{%k1}{z}
 1076604:	kunpckwd %k1,%k2,%k2
 1076608:	vpsubd %zmm2,%zmm5,%zmm5
 107660e:	vpsubd %zmm2,%zmm4,%zmm4
 1076614:	vpcmpltud %zmm1,%zmm4,%k0
 107661b:	vpcmpltud %zmm1,%zmm5,%k3
 1076622:	kunpckwd %k0,%k3,%k0
 1076626:	kandd  %k2,%k0,%k0
 107662b:	kmovd  %esi,%k2
 107662f:	vmovdqu32 0x80(%rbx,%r10,4),%zmm4{%k2}{z}
 1076637:	kmovd  %k0,%edx
 107663b:	vpsubd %zmm2,%zmm4,%zmm4
 1076641:	vpcmpltud %zmm1,%zmm4,%k0{%k2}
 1076648:	kmovw  %k0,%esi
 107664c:	shl    $0x20,%rsi
 1076650:	or     %rdx,%rsi
 1076653:	mov    %rax,%rdx
 1076656:	shr    $0x30,%rdx
 107665a:	kmovd  %edx,%k2
 107665e:	vmovdqu32 0xc0(%rbx,%r10,4),%zmm4{%k2}{z}
 1076666:	vpsubd %zmm2,%zmm4,%zmm4
 107666c:	vpcmpltud %zmm1,%zmm4,%k0{%k2}
 1076673:	vptestmb (%r11,%r10,1),%zmm0,%k2{%k1}
 107667a:	vmovdqu8 %zmm3,0x0(%rbp,%r10,1){%k1}
 1076682:	kmovd  %k0,%edx
 1076686:	movzwl %dx,%edx
 1076689:	shl    $0x30,%rdx
 107668d:	or     %rsi,%rdx
 1076690:	kmovq  %k2,%rsi
 1076695:	or     %rdx,%rsi
 1076698:	andn   %rax,%rsi,%r10
 107669d:	jne    10766c8 <check_input_run+0x9338>
 107669f:	jmp    10765a0 <check_input_run+0x9210>
 10766a4:	data16 data16 cs nopw 0x0(%rax,%rax,1)
 10766b0:	xor    %r12d,%r12d
 10766b3:	mov    %r12b,0x0(%rbp,%r11,1)
 10766b8:	mov    0x20(%rsp),%r12
 10766bd:	blsr   %r10,%r10
 10766c2:	je     10765a0 <check_input_run+0x9210>
 10766c8:	mov    0x58(%rsp),%rdx
 10766cd:	xor    %r11d,%r11d
 10766d0:	tzcnt  %r10,%r11
 10766d5:	add    %r8d,%r11d
 10766d8:	mov    0x828(%rdx),%rax
 10766df:	mov    (%rax,%r11,4),%eax
 10766e3:	test   %eax,%eax
 10766e5:	je     10766b0 <check_input_run+0x9320>
 10766e7:	mov    0xc18(%rdx),%r13d
 10766ee:	cmp    $0x2,%r13d
 10766f2:	jb     1076740 <check_input_run+0x93b0>
 10766f4:	mov    0xc10(%rdx),%r15
 10766fb:	xor    %r12d,%r12d
 10766fe:	mov    %r13d,%edx
 1076701:	mov    %r13d,%ebx
 1076704:	jmp    107671d <check_input_run+0x938d>
 1076706:	cs nopw 0x0(%rax,%rax,1)
 1076710:	mov    %edx,%r12d
 1076713:	mov    %ebx,%edx
 1076715:	sub    %r12d,%edx
 1076718:	cmp    $0x1,%edx
 107671b:	jbe    1076758 <check_input_run+0x93c8>
 107671d:	shr    $1,%edx
 107671f:	add    %r12d,%edx
 1076722:	imul   $0x38,%rdx,%rsi
 1076726:	cmp    %eax,(%r15,%rsi,1)
 107672a:	jbe    1076710 <check_input_run+0x9380>
 107672c:	mov    %edx,%ebx
 107672e:	mov    %ebx,%edx
 1076730:	sub    %r12d,%edx
 1076733:	cmp    $0x1,%edx
 1076736:	ja     107671d <check_input_run+0x938d>
 1076738:	jmp    1076758 <check_input_run+0x93c8>
 107673a:	nopw   0x0(%rax,%rax,1)
 1076740:	xor    %r12d,%r12d
 1076743:	test   %r13d,%r13d
 1076746:	je     10766b3 <check_input_run+0x9323>
 107674c:	mov    0x58(%rsp),%rdx
 1076751:	mov    0xc10(%rdx),%r15
 1076758:	mov    %r12d,%edx
 107675b:	imul   $0x38,%rdx,%rdx
 107675f:	mov    %eax,%esi
 1076761:	sub    (%r15,%rdx,1),%esi
 1076765:	jb     10766b0 <check_input_run+0x9320>
 107676b:	add    %r15,%rdx
 107676e:	cmp    0x4(%rdx),%esi
 1076771:	mov    $0xffffffff,%edx
 1076776:	cmovb  %r12d,%edx
 107677a:	cmp    %r13d,%edx
 107677d:	jae    10767df <check_input_run+0x944f>
 107677f:	mov    %edx,%edx
 1076781:	imul   $0x38,%rdx,%rdx
 1076785:	movzbl 0x28(%r15,%rdx,1),%ebx
 107678b:	mov    0x20(%r15,%rdx,1),%esi
 1076790:	mov    0x58(%rsp),%rdx
 1076795:	mov    0xc28(%rdx),%r15d
 107679c:	cmp    %r15d,%esi
 107679f:	jae    10767e4 <check_input_run+0x9454>
 10767a1:	mov    0xc20(%rdx),%rdx
 10767a8:	lea    (%rsi,%rsi,4),%rsi
 10767ac:	cmp    %eax,0x4(%rdx,%rsi,8)
 10767b0:	ja     10767e4 <check_input_run+0x9454>
 10767b2:	lea    (%rdx,%rsi,8),%rbx
 10767b6:	cs nopw 0x0(%rax,%rax,1)
 10767c0:	mov    %rbx,%rsi
 10767c3:	mov    0x1c(%rbx),%ebx
 10767c6:	cmp    %r15d,%ebx
 10767c9:	jae    10767d9 <check_input_run+0x9449>
 10767cb:	lea    (%rbx,%rbx,4),%rdi
 10767cf:	lea    (%rdx,%rdi,8),%rbx
 10767d3:	cmp    %eax,0x4(%rdx,%rdi,8)
 10767d7:	jbe    10767c0 <check_input_run+0x9430>
 10767d9:	movzbl 0x20(%rsi),%ebx
 10767dd:	jmp    10767e4 <check_input_run+0x9454>
 10767df:	xor    %ebx,%ebx
 10767e1:	mov    %edx,%r12d
 10767e4:	cmp    %r13d,%r12d
 10767e7:	movzbl %bl,%r12d
 10767eb:	cmovae %ecx,%r12d
 10767ef:	jmp    10766b3 <check_input_run+0x9323>
 10767f4:	mov    0x1b0(%rsp),%r8
 10767fc:	test   %r8d,%r8d
 10767ff:	je     1076824 <check_input_run+0x9494>
 1076801:	mov    0x210(%rsp),%r10
 1076809:	mov    %r8d,%eax
 107680c:	and    $0x7,%eax
 107680f:	cmp    $0x8,%r8d
 1076813:	jae    1076833 <check_input_run+0x94a3>
 1076815:	mov    0xc8(%rsp),%r9
 107681d:	xor    %ecx,%ecx
 107681f:	jmp    10769d9 <check_input_run+0x9649>
 1076824:	mov    0x210(%rsp),%r10
 107682c:	xor    %eax,%eax
 107682e:	jmp    1076a19 <check_input_run+0x9689>
 1076833:	mov    0xc8(%rsp),%r9
 107683b:	mov    %r8d,%edx
 107683e:	and    $0xfffffff8,%edx
 1076841:	xor    %ecx,%ecx
 1076843:	jmp    1076867 <check_input_run+0x94d7>
 1076845:	movzbl 0x0(%rbp,%rsi,1),%esi
 107684a:	dec    %sil
 107684d:	cmp    $0x2,%sil
 1076851:	setb   %sil
 1076855:	mov    %sil,0x7(%r10,%rcx,1)
 107685a:	add    $0x8,%rcx
 107685e:	cmp    %rcx,%rdx
 1076861:	je     10769d4 <check_input_run+0x9644>
 1076867:	mov    0x20(%r9),%rsi
 107686b:	mov    0x58(%rsp),%rdi
 1076870:	mov    (%rsi,%rcx,4),%esi
 1076873:	cmp    0x830(%rdi),%esi
 1076879:	jae    107688d <check_input_run+0x94fd>
 107687b:	movzbl 0x0(%rbp,%rsi,1),%esi
 1076880:	dec    %sil
 1076883:	cmp    $0x2,%sil
 1076887:	setb   %sil
 107688b:	jmp    107688f <check_input_run+0x94ff>
 107688d:	xor    %esi,%esi
 107688f:	mov    %sil,(%r10,%rcx,1)
 1076893:	mov    0x58(%rsp),%rdi
 1076898:	mov    0x20(%r9),%rsi
 107689c:	mov    0x4(%rsi,%rcx,4),%esi
 10768a0:	cmp    0x830(%rdi),%esi
 10768a6:	jae    10768ba <check_input_run+0x952a>
 10768a8:	movzbl 0x0(%rbp,%rsi,1),%esi
 10768ad:	dec    %sil
 10768b0:	cmp    $0x2,%sil
 10768b4:	setb   %sil
 10768b8:	jmp    10768bc <check_input_run+0x952c>
 10768ba:	xor    %esi,%esi
 10768bc:	mov    %sil,0x1(%r10,%rcx,1)
 10768c1:	mov    0x58(%rsp),%rdi
 10768c6:	mov    0x20(%r9),%rsi
 10768ca:	mov    0x8(%rsi,%rcx,4),%esi
 10768ce:	cmp    0x830(%rdi),%esi
 10768d4:	jae    10768e8 <check_input_run+0x9558>
 10768d6:	movzbl 0x0(%rbp,%rsi,1),%esi
 10768db:	dec    %sil
 10768de:	cmp    $0x2,%sil
 10768e2:	setb   %sil
 10768e6:	jmp    10768ea <check_input_run+0x955a>
 10768e8:	xor    %esi,%esi
 10768ea:	mov    %sil,0x2(%r10,%rcx,1)
 10768ef:	mov    0x58(%rsp),%rdi
 10768f4:	mov    0x20(%r9),%rsi
 10768f8:	mov    0xc(%rsi,%rcx,4),%esi
 10768fc:	cmp    0x830(%rdi),%esi
 1076902:	jae    1076916 <check_input_run+0x9586>
 1076904:	movzbl 0x0(%rbp,%rsi,1),%esi
 1076909:	dec    %sil
 107690c:	cmp    $0x2,%sil
 1076910:	setb   %sil
 1076914:	jmp    1076918 <check_input_run+0x9588>
 1076916:	xor    %esi,%esi
 1076918:	mov    %sil,0x3(%r10,%rcx,1)
 107691d:	mov    0x58(%rsp),%rdi
 1076922:	mov    0x20(%r9),%rsi
 1076926:	mov    0x10(%rsi,%rcx,4),%esi
 107692a:	cmp    0x830(%rdi),%esi
 1076930:	jae    1076944 <check_input_run+0x95b4>
 1076932:	movzbl 0x0(%rbp,%rsi,1),%esi
 1076937:	dec    %sil
 107693a:	cmp    $0x2,%sil
 107693e:	setb   %sil
 1076942:	jmp    1076946 <check_input_run+0x95b6>
 1076944:	xor    %esi,%esi
 1076946:	mov    %sil,0x4(%r10,%rcx,1)
 107694b:	mov    0x58(%rsp),%rdi
 1076950:	mov    0x20(%r9),%rsi
 1076954:	mov    0x14(%rsi,%rcx,4),%esi
 1076958:	cmp    0x830(%rdi),%esi
 107695e:	jae    1076972 <check_input_run+0x95e2>
 1076960:	movzbl 0x0(%rbp,%rsi,1),%esi
 1076965:	dec    %sil
 1076968:	cmp    $0x2,%sil
 107696c:	setb   %sil
 1076970:	jmp    1076974 <check_input_run+0x95e4>
 1076972:	xor    %esi,%esi
 1076974:	mov    %sil,0x5(%r10,%rcx,1)
 1076979:	mov    0x58(%rsp),%rdi
 107697e:	mov    0x20(%r9),%rsi
 1076982:	mov    0x18(%rsi,%rcx,4),%esi
 1076986:	cmp    0x830(%rdi),%esi
 107698c:	jae    10769a0 <check_input_run+0x9610>
 107698e:	movzbl 0x0(%rbp,%rsi,1),%esi
 1076993:	dec    %sil
 1076996:	cmp    $0x2,%sil
 107699a:	setb   %sil
 107699e:	jmp    10769a2 <check_input_run+0x9612>
 10769a0:	xor    %esi,%esi
 10769a2:	mov    %sil,0x6(%r10,%rcx,1)
 10769a7:	mov    0x58(%rsp),%rdi
 10769ac:	mov    0x20(%r9),%rsi
 10769b0:	mov    0x1c(%rsi,%rcx,4),%esi
 10769b4:	cmp    0x830(%rdi),%esi
 10769ba:	jb     1076845 <check_input_run+0x94b5>
 10769c0:	xor    %esi,%esi
 10769c2:	mov    %sil,0x7(%r10,%rcx,1)
 10769c7:	add    $0x8,%rcx
 10769cb:	cmp    %rcx,%rdx
 10769ce:	jne    1076867 <check_input_run+0x94d7>
 10769d4:	test   %rax,%rax
 10769d7:	je     1076a16 <check_input_run+0x9686>
 10769d9:	mov    0x58(%rsp),%rsi
 10769de:	jmp    10769f9 <check_input_run+0x9669>
 10769e0:	movzbl 0x0(%rbp,%rdx,1),%edx
 10769e5:	dec    %dl
 10769e7:	cmp    $0x2,%dl
 10769ea:	setb   %dl
 10769ed:	mov    %dl,(%r10,%rcx,1)
 10769f1:	inc    %rcx
 10769f4:	dec    %rax
 10769f7:	je     1076a16 <check_input_run+0x9686>
 10769f9:	mov    0x20(%r9),%rdx
 10769fd:	mov    (%rdx,%rcx,4),%edx
 1076a00:	cmp    0x830(%rsi),%edx
 1076a06:	jb     10769e0 <check_input_run+0x9650>
 1076a08:	xor    %edx,%edx
 1076a0a:	mov    %dl,(%r10,%rcx,1)
 1076a0e:	inc    %rcx
 1076a11:	dec    %rax
 1076a14:	jne    10769f9 <check_input_run+0x9669>
 1076a16:	mov    %r8,%rax
 1076a19:	movb   $0x0,(%r10,%rax,1)
 1076a1e:	mov    %r10,0x58(%r14)
 1076a22:	mov    %r8d,0x60(%r14)
 1076a26:	mov    0x130(%rsp),%r8
 1076a2e:	mov    0x2c8(%rsp),%rax
 1076a36:	cmp    0x8(%rax),%r8
 1076a3a:	ja     107a8df <check_input_run+0xd54f>
 1076a40:	mov    %r8,0x8(%rax)
 1076a44:	mov    0x2a8(%rsp),%rbx
 1076a4c:	mov    0x30(%rbx),%eax
 1076a4f:	cmp    $0x3,%eax
 1076a52:	jb     1076aca <check_input_run+0x973a>
 1076a54:	mov    $0xfffffffd,%ebp
 1076a59:	xor    %r14d,%r14d
 1076a5c:	jmp    1076a74 <check_input_run+0x96e4>
 1076a5e:	xchg   %ax,%ax
 1076a60:	lea    0x1(%r14),%rdx
 1076a64:	dec    %ebp
 1076a66:	add    $0x3,%r14
 1076a6a:	mov    %eax,%ecx
 1076a6c:	cmp    %rcx,%r14
 1076a6f:	mov    %rdx,%r14
 1076a72:	jae    1076aca <check_input_run+0x973a>
 1076a74:	mov    0x10(%rbx),%rcx
 1076a78:	cmpb   $0x3c,(%rcx,%r14,1)
 1076a7d:	jne    1076a60 <check_input_run+0x96d0>
 1076a7f:	mov    0x50(%rbx),%rcx
 1076a83:	cmpb   $0x2a,0x1(%rcx,%r14,1)
 1076a89:	jne    1076a60 <check_input_run+0x96d0>
 1076a8b:	cmpb   $0x2d,0x2(%rcx,%r14,1)
 1076a91:	jne    1076a60 <check_input_run+0x96d0>
 1076a93:	mov    0x60(%rbx),%rcx
 1076a97:	mov    0x8(%rcx,%r14,4),%edx
 1076a9c:	cmp    %eax,%edx
 1076a9e:	jae    1076a60 <check_input_run+0x96d0>
 1076aa0:	lea    0x2(%r14),%rcx
 1076aa4:	cmp    %rdx,%rcx
 1076aa7:	jae    1076a60 <check_input_run+0x96d0>
 1076aa9:	mov    0x3d8(%rsp),%rax
 1076ab1:	add    %ebp,%edx
 1076ab3:	mov    $0x1,%esi
 1076ab8:	lea    0x3(%rax,%r14,1),%rdi
 1076abd:	vzeroupper
 1076ac0:	call   788430 <memset@plt>
 1076ac5:	mov    0x30(%rbx),%eax
 1076ac8:	jmp    1076a60 <check_input_run+0x96d0>
 1076aca:	lea    0x2a0(%rsp),%rbx
 1076ad2:	mov    0xf0(%rsp),%rdx
 1076ada:	xor    %esi,%esi
 1076adc:	mov    %rbx,%rdi
 1076adf:	vzeroupper
 1076ae2:	call   1082cf0 <check_input_resolve_range>
 1076ae7:	mov    0x860(%rsp),%rdx
 1076aef:	test   %rdx,%rdx
 1076af2:	je     10783d1 <check_input_run+0xb041>
 1076af8:	mov    0x2a0(%rsp),%rsi
 1076b00:	movq   $0x0,0x118(%rdx)
 1076b0b:	lea    -0xa41727(%rip),%rcx        # 6353eb <foreign_touch.flags+0x33115>
 1076b12:	mov    %rdx,%r12
 1076b15:	cmpb   $0x0,0x2ac58(%rdx)
 1076b1c:	mov    0x230(%rsi),%eax
 1076b22:	je     1076b33 <check_input_run+0x97a3>
 1076b24:	xor    %ebp,%ebp
 1076b26:	test   %eax,%eax
 1076b28:	jne    1076b85 <check_input_run+0x97f5>
 1076b2a:	lea    -0x9cf416(%rip),%rax        # 6a771b <pp_string_value.meaning+0x1ef1a>
 1076b31:	jmp    1076b72 <check_input_run+0x97e2>
 1076b33:	test   %eax,%eax
 1076b35:	je     1076b3b <check_input_run+0x97ab>
 1076b37:	xor    %ebp,%ebp
 1076b39:	jmp    1076b85 <check_input_run+0x97f5>
 1076b3b:	xor    %ebp,%ebp
 1076b3d:	cmpb   $0x0,0x3c5(%rsi)
 1076b44:	lea    -0x9cf430(%rip),%rax        # 6a771b <pp_string_value.meaning+0x1ef1a>
 1076b4b:	jne    1076b72 <check_input_run+0x97e2>
 1076b4d:	cmpb   $0x0,0x338(%rsp)
 1076b55:	je     1076b72 <check_input_run+0x97e2>
 1076b57:	cmpb   $0x0,0x174(%r12)
 1076b60:	jne    1076b70 <check_input_run+0x97e0>
 1076b62:	cmpq   $0x0,0x220(%rsi)
 1076b6a:	je     1078d2b <check_input_run+0xb99b>
 1076b70:	xor    %ebp,%ebp
 1076b72:	cmpq   $0x0,0x220(%rsi)
 1076b7a:	lea    -0x9e5c48(%rip),%rcx        # 690f39 <pp_string_value.meaning+0x8738>
 1076b81:	cmove  %rax,%rcx
 1076b85:	mov    %rcx,0x2ac60(%r12)
 1076b8d:	mov    %rbx,0x1f0(%r12)
 1076b95:	mov    %rsi,0x90(%rsp)
 1076b9d:	cmpb   $0x1,0x2ac90(%r12)
 1076ba6:	jne    1076bf5 <check_input_run+0x9865>
 1076ba8:	lea    0x780(%rsp),%rsi
 1076bb0:	mov    $0x1,%edi
 1076bb5:	vpxor  %xmm0,%xmm0,%xmm0
 1076bb9:	vmovdqa %xmm0,0x780(%rsp)
 1076bc2:	call   787bc0 <clock_gettime@plt>
 1076bc7:	imul   $0x3b9aca00,0x780(%rsp),%r14
 1076bd3:	add    0x788(%rsp),%r14
 1076bdb:	cmpb   $0x1,0x2ac90(%r12)
 1076be4:	jne    1076bf8 <check_input_run+0x9868>
 1076be6:	mov    %r14,%rcx
 1076be9:	sub    0x2acb0(%r12),%rcx
 1076bf1:	mov    $0x1,%al
 1076bf3:	jmp    1076bfc <check_input_run+0x986c>
 1076bf5:	xor    %r14d,%r14d
 1076bf8:	xor    %eax,%eax
 1076bfa:	xor    %ecx,%ecx
 1076bfc:	mov    %rcx,0x2acb0(%r12)
 1076c04:	test   %bpl,%bpl
 1076c07:	je     1076c3b <check_input_run+0x98ab>
 1076c09:	mov    0x2c8(%rsp),%rcx
 1076c11:	lea    0x1f8(%r12),%rdi
 1076c19:	lea    0x2ac38(%r12),%rdx
 1076c21:	lea    0x2d0(%rsp),%rsi
 1076c29:	call   10f2470 <c_environment_build>
 1076c2e:	mov    %eax,%ebx
 1076c30:	movzbl 0x2ac90(%r12),%eax
 1076c39:	jmp    1076c3d <check_input_run+0x98ad>
 1076c3b:	xor    %ebx,%ebx
 1076c3d:	test   %al,%al
 1076c3f:	je     1076c76 <check_input_run+0x98e6>
 1076c41:	lea    0x780(%rsp),%rsi
 1076c49:	mov    $0x1,%edi
 1076c4e:	vpxor  %xmm0,%xmm0,%xmm0
 1076c52:	vmovdqa %xmm0,0x780(%rsp)
 1076c5b:	call   787bc0 <clock_gettime@plt>
 1076c60:	imul   $0x3b9aca00,0x780(%rsp),%rax
 1076c6c:	add    0x788(%rsp),%rax
 1076c74:	jmp    1076c78 <check_input_run+0x98e8>
 1076c76:	xor    %eax,%eax
 1076c78:	sub    %r14,%rax
 1076c7b:	mov    %rax,0x2acb8(%r12)
 1076c83:	test   %bl,%bl
 1076c85:	je     1076d98 <check_input_run+0x9a08>
 1076c8b:	mov    0x2ac38(%r12),%rdx
 1076c93:	mov    0x2ac40(%r12),%rcx
 1076c9b:	lea    0x3(%rcx,%rdx,1),%rax
 1076ca0:	add    %rdx,%rcx
 1076ca3:	and    $0xfffffffffffffffc,%rax
 1076ca7:	cmp    %rcx,%rax
 1076caa:	jb     1076d98 <check_input_run+0x9a08>
 1076cb0:	mov    0x2ac48(%r12),%rsi
 1076cb8:	mov    %rax,%rdi
 1076cbb:	sub    %rdx,%rdi
 1076cbe:	mov    %rsi,%r9
 1076cc1:	sub    %rdi,%r9
 1076cc4:	jb     1076d98 <check_input_run+0x9a08>
 1076cca:	mov    0x130(%r12),%ecx
 1076cd2:	lea    0x4(,%rcx,4),%r8
 1076cda:	cmp    %r9,%r8
 1076cdd:	ja     1076d98 <check_input_run+0x9a08>
 1076ce3:	add    %r8,%rdi
 1076ce6:	mov    %rdi,0x2ac40(%r12)
 1076cee:	mov    %rax,0x1b8(%r12)
 1076cf6:	test   %rax,%rax
 1076cf9:	je     1076da4 <check_input_run+0x9a14>
 1076cff:	add    %r8,%rax
 1076d02:	mov    %rax,%rdi
 1076d05:	sub    %rdx,%rdi
 1076d08:	sub    %rdi,%rsi
 1076d0b:	jb     1076da4 <check_input_run+0x9a14>
 1076d11:	mov    0xb0(%r12),%edx
 1076d19:	lea    0x4(,%rdx,4),%r8
 1076d21:	cmp    %rsi,%r8
 1076d24:	ja     1076da4 <check_input_run+0x9a14>
 1076d26:	lea    0xb0(%r12),%rsi
 1076d2e:	add    %rdi,%r8
 1076d31:	mov    %r8,0x2ac40(%r12)
 1076d39:	mov    %rsi,0xc8(%rsp)
 1076d41:	mov    %rax,0x1c8(%r12)
 1076d49:	test   %rax,%rax
 1076d4c:	je     1077fa5 <check_input_run+0xac15>
 1076d52:	test   %edx,%edx
 1076d54:	je     1076d7f <check_input_run+0x99ef>
 1076d56:	xor    %eax,%eax
 1076d58:	mov    0x1c8(%r12),%rcx
 1076d60:	movl   $0xffffffff,(%rcx,%rax,4)
 1076d67:	inc    %rax
 1076d6a:	mov    0xb0(%r12),%ecx
 1076d72:	cmp    %rcx,%rax
 1076d75:	jb     1076d58 <check_input_run+0x99c8>
 1076d77:	mov    0x130(%r12),%ecx
 1076d7f:	test   %ecx,%ecx
 1076d81:	je     1077ef9 <check_input_run+0xab69>
 1076d87:	mov    0x1c0(%r12),%edx
 1076d8f:	xor    %eax,%eax
 1076d91:	xor    %ecx,%ecx
 1076d93:	jmp    1076f7c <check_input_run+0x9bec>
 1076d98:	movq   $0x0,0x1b8(%r12)
 1076da4:	lea    0xb0(%r12),%rax
 1076dac:	movq   $0x0,0x1c8(%r12)
 1076db8:	movq   $0x0,0x2aa28(%r12)
 1076dc4:	movq   $0x0,0x2aa30(%r12)
 1076dd0:	mov    %rax,0xc8(%rsp)
 1076dd8:	lea    0x1d8(%r12),%r15
 1076de0:	movq   $0x0,0x1d8(%r12)
 1076dec:	lea    0x1e0(%r12),%rax
 1076df4:	xor    %ebp,%ebp
 1076df6:	mov    %rax,0x28(%rsp)
 1076dfb:	xor    %eax,%eax
 1076dfd:	mov    %r12,0x278(%rsp)
 1076e05:	mov    $0xffffffffffffffff,%rcx
 1076e0c:	cmpb   $0x0,0x2aca0(%r12)
 1076e15:	jne    1076e41 <check_input_run+0x9ab1>
 1076e17:	mov    0x1e8(%r12),%ecx
 1076e1f:	xor    %edx,%edx
 1076e21:	add    %rcx,%rcx
 1076e24:	sub    %rcx,%rax
 1076e27:	movabs $0xaaaaaaaaaaaaaaab,%rcx
 1076e31:	cmovae %rax,%rdx
 1076e35:	mulx   %rcx,%rcx,%rcx
 1076e3a:	shr    $0xd,%rcx
 1076e3e:	inc    %rcx
 1076e41:	mov    (%r12),%eax
 1076e45:	mov    0x1e0(%r12),%ebx
 1076e4d:	cmp    %ebx,%eax
 1076e4f:	cmovb  %eax,%ebx
 1076e52:	cmp    %rbx,%rcx
 1076e55:	cmovb  %rcx,%rbx
 1076e59:	cmpb   $0x1,0x2ac90(%r12)
 1076e62:	jne    1076e9c <check_input_run+0x9b0c>
 1076e64:	lea    0x780(%rsp),%rsi
 1076e6c:	mov    $0x1,%edi
 1076e71:	vpxor  %xmm0,%xmm0,%xmm0
 1076e75:	vmovdqa %xmm0,0x780(%rsp)
 1076e7e:	vzeroupper
 1076e81:	call   787bc0 <clock_gettime@plt>
 1076e86:	imul   $0x3b9aca00,0x780(%rsp),%r13
 1076e92:	add    0x788(%rsp),%r13
 1076e9a:	jmp    1076e9f <check_input_run+0x9b0f>
 1076e9c:	xor    %r13d,%r13d
 1076e9f:	lea    0x2ac60(%r12),%r14
 1076ea7:	test   %bpl,%bpl
 1076eaa:	je     1076edf <check_input_run+0x9b4f>
 1076eac:	mov    0x28(%rsp),%rax
 1076eb1:	cmpl   $0x0,(%rax)
 1076eb4:	je     1076edf <check_input_run+0x9b4f>
 1076eb6:	mov    0x2ac98(%r12),%rcx
 1076ebe:	lea    0x7c35b(%rip),%rsi        # 10f3220 <check_deferred_lane>
 1076ec5:	lea    0x278(%rsp),%rdx
 1076ecd:	mov    %ebx,%edi
 1076ecf:	vzeroupper
 1076ed2:	call   10f2ab0 <lane_run>
 1076ed7:	test   %al,%al
 1076ed9:	je     1076fb0 <check_input_run+0x9c20>
 1076edf:	mov    (%r14),%rax
 1076ee2:	mov    %rax,0x2ac60(%r12)
 1076eea:	mov    %rbp,0xd0(%rsp)
 1076ef2:	cmpb   $0x1,0x2ac90(%r12)
 1076efb:	jne    1076fd8 <check_input_run+0x9c48>
 1076f01:	lea    0x780(%rsp),%rsi
 1076f09:	mov    $0x1,%edi
 1076f0e:	vpxor  %xmm0,%xmm0,%xmm0
 1076f12:	vmovdqa %xmm0,0x780(%rsp)
 1076f1b:	vzeroupper
 1076f1e:	call   787bc0 <clock_gettime@plt>
 1076f23:	imul   $0x3b9aca00,0x780(%rsp),%rcx
 1076f2f:	mov    0x788(%rsp),%rax
 1076f37:	sub    %r13,%rax
 1076f3a:	add    %rcx,%rax
 1076f3d:	jmp    1076fda <check_input_run+0x9c4a>
 1076f42:	mov    0x1b8(%r12),%rdi
 1076f4a:	mov    %edx,%edx
 1076f4c:	mov    %r8b,%sil
 1076f4f:	add    $0x38,%rax
 1076f53:	mov    %ecx,(%rdi,%rdx,4)
 1076f56:	inc    %rcx
 1076f59:	add    0x1c0(%r12),%esi
 1076f61:	mov    %esi,0x1c0(%r12)
 1076f69:	mov    %esi,%edx
 1076f6b:	mov    0x130(%r12),%edi
 1076f73:	cmp    %rdi,%rcx
 1076f76:	jae    1077ef9 <check_input_run+0xab69>
 1076f7c:	mov    0x128(%r12),%rdi
 1076f84:	xor    %esi,%esi
 1076f86:	movzbl 0x8(%rdi,%rax,1),%r9d
 1076f8c:	lea    -0x4(%r9),%r8d
 1076f90:	cmp    $0x3,%r8b
 1076f94:	setb   %r8b
 1076f98:	cmp    $0x6,%r9b
 1076f9c:	jne    1076f42 <check_input_run+0x9bb2>
 1076f9e:	mov    0x1c8(%r12),%r9
 1076fa6:	mov    0x2c(%rdi,%rax,1),%edi
 1076faa:	mov    %edx,(%r9,%rdi,4)
 1076fae:	jmp    1076f42 <check_input_run+0x9bb2>
 1076fb0:	lea    -0xa41bad(%rip),%rax        # 63540a <foreign_touch.flags+0x33134>
 1076fb7:	xor    %ebp,%ebp
 1076fb9:	mov    %rax,0x2ac60(%r12)
 1076fc1:	mov    %rbp,0xd0(%rsp)
 1076fc9:	cmpb   $0x1,0x2ac90(%r12)
 1076fd2:	je     1076f01 <check_input_run+0x9b71>
 1076fd8:	xor    %eax,%eax
 1076fda:	mov    %rax,0x2acc0(%r12)
 1076fe2:	mov    %r15,0x1b0(%rsp)
 1076fea:	mov    %r14,0x48(%rsp)
 1076fef:	mov    0xcc0(%r12),%rbp
 1076ff7:	mov    (%r12),%edx
 1076ffb:	mov    %rbp,%rax
 1076ffe:	test   %edx,%edx
 1077000:	je     10779c4 <check_input_run+0xa634>
 1077006:	mov    %r12,%rax
 1077009:	mov    0x2ac68(%r12),%r15
 1077011:	mov    0x2ac70(%r12),%r12
 1077019:	mov    0x2ac78(%rax),%rbx
 1077020:	mov    0x2ac80(%rax),%r11
 1077027:	mov    0x2ac88(%rax),%r10
 107702e:	mov    0x2acd8(%rax),%r9
 1077035:	mov    0x2acd0(%rax),%r8
 107703c:	mov    0x2ace0(%rax),%rdi
 1077043:	cmp    $0x40,%edx
 1077046:	mov    $0x40,%ecx
 107704b:	cmovb  %edx,%ecx
 107704e:	cmp    $0x8,%edx
 1077051:	jae    107705e <check_input_run+0x9cce>
 1077053:	xor    %r14d,%r14d
 1077056:	mov    %rbp,%rax
 1077059:	jmp    107791e <check_input_run+0xa58e>
 107705e:	lea    0x228(%rax),%rsi
 1077065:	vpbroadcastq %rsi,%zmm0
 107706b:	cmp    $0x10,%edx
 107706e:	jae    107707b <check_input_run+0x9ceb>
 1077070:	xor    %r14d,%r14d
 1077073:	mov    %rbp,%rax
 1077076:	jmp    10775de <check_input_run+0xa24e>
 107707b:	vmovdqa64 -0xbd9a85(%rip),%zmm19        # 49d600 <cbuiltin_test_generated.edges+0x37c0>
 1077085:	vpbroadcastq -0xacaa5f(%rip),%zmm20        # 5ac630 <check_mutation_families+0x190>
 107708f:	vpbroadcastq -0xacaa61(%rip),%zmm21        # 5ac638 <check_mutation_families+0x198>
 1077099:	vpbroadcastq -0xacaa63(%rip),%zmm22        # 5ac640 <check_mutation_families+0x1a0>
 10770a3:	mov    %ecx,%r14d
 10770a6:	vpbroadcastq %rbp,%zmm1
 10770ac:	and    $0x70,%r14d
 10770b0:	vmovq  %rdi,%xmm15
 10770b5:	vmovq  %r8,%xmm13
 10770ba:	vmovq  %r9,%xmm11
 10770bf:	vmovq  %r10,%xmm9
 10770c4:	vmovq  %r11,%xmm7
 10770c9:	vmovq  %rbx,%xmm5
 10770ce:	vmovq  %r12,%xmm3
 10770d3:	vmovq  %r15,%xmm2
 10770d8:	vpxord %xmm17,%xmm17,%xmm17
 10770de:	vpxord %xmm18,%xmm18,%xmm18
 10770e4:	vpxord %xmm16,%xmm16,%xmm16
 10770ea:	vpxor  %xmm14,%xmm14,%xmm14
 10770ef:	vpxor  %xmm12,%xmm12,%xmm12
 10770f4:	vpxor  %xmm10,%xmm10,%xmm10
 10770f9:	vpxor  %xmm8,%xmm8,%xmm8
 10770fe:	vpxor  %xmm6,%xmm6,%xmm6
 1077102:	mov    %r14,%rdi
 1077105:	vmovdqa64 %zmm1,%zmm4
 107710b:	vpmullq %zmm20,%zmm19,%zmm23
 1077111:	kxnorb %k0,%k0,%k1
 1077115:	vpaddq %zmm22,%zmm19,%zmm19
 107711b:	add    $0xfffffffffffffff0,%rdi
 107711f:	vpaddq %zmm23,%zmm0,%zmm25
 1077125:	vmovq  %xmm25,%rdx
 107712b:	vpextrq $0x1,%xmm25,%rax
 1077132:	vextracti32x4 $0x1,%ymm25,%xmm26
 1077139:	vpaddq %zmm21,%zmm25,%zmm24
 107713f:	vmovd  0x9e0(%rdx),%xmm27
 1077149:	vpextrq $0x1,%xmm26,%rdx
 1077150:	vmovq  %xmm24,%r8
 1077156:	vpinsrb $0x1,0x9e0(%rax),%xmm27,%xmm27
 1077161:	vmovq  %xmm26,%rax
 1077167:	vextracti32x4 $0x2,%zmm25,%xmm26
 107716e:	vextracti32x4 $0x3,%zmm25,%xmm25
 1077175:	vpinsrb $0x2,0x9e0(%rax),%xmm27,%xmm27
 1077180:	vpextrq $0x1,%xmm26,%rax
 1077187:	vpinsrb $0x3,0x9e0(%rdx),%xmm27,%xmm27
 1077192:	vmovq  %xmm26,%rdx
 1077198:	vpinsrb $0x4,0x9e0(%rdx),%xmm27,%xmm26
 10771a3:	vpextrq $0x1,%xmm25,%rdx
 10771aa:	vmovd  0x9e0(%r8),%xmm27
 10771b4:	vpinsrb $0x5,0x9e0(%rax),%xmm26,%xmm26
 10771bf:	vmovq  %xmm25,%rax
 10771c5:	vpinsrb $0x6,0x9e0(%rax),%xmm26,%xmm25
 10771d0:	vextracti32x4 $0x1,%ymm24,%xmm26
 10771d7:	vmovq  %xmm26,%rax
 10771dd:	vpinsrb $0x7,0x9e0(%rdx),%xmm25,%xmm25
 10771e8:	vpextrq $0x1,%xmm24,%rdx
 10771ef:	vpinsrb $0x1,0x9e0(%rdx),%xmm27,%xmm27
 10771fa:	vpextrq $0x1,%xmm26,%rdx
 1077201:	vextracti32x4 $0x2,%zmm24,%xmm26
 1077208:	vextracti32x4 $0x3,%zmm24,%xmm24
 107720f:	vpinsrb $0x2,0x9e0(%rax),%xmm27,%xmm27
 107721a:	vmovq  %xmm26,%rax
 1077220:	vpmovzxbq %xmm25,%zmm25
 1077226:	vpinsrb $0x3,0x9e0(%rdx),%xmm27,%xmm27
 1077231:	vpextrq $0x1,%xmm26,%rdx
 1077238:	vpaddq %zmm25,%zmm9,%zmm9
 107723e:	vpinsrb $0x4,0x9e0(%rax),%xmm27,%xmm26
 1077249:	vmovq  %xmm24,%rax
 107724f:	vpinsrb $0x5,0x9e0(%rdx),%xmm26,%xmm26
 107725a:	vpextrq $0x1,%xmm24,%rdx
 1077261:	vpinsrb $0x6,0x9e0(%rax),%xmm26,%xmm24
 107726c:	vpxord %xmm26,%xmm26,%xmm26
 1077272:	vpgatherqq 0xa98(%rsi,%zmm23,1),%zmm26{%k1}
 107727d:	kxnorb %k0,%k0,%k1
 1077281:	vpinsrb $0x7,0x9e0(%rdx),%xmm24,%xmm24
 107728c:	vpmaxuq %zmm1,%zmm26,%zmm1
 1077292:	vpxord %xmm26,%xmm26,%xmm26
 1077298:	vpgatherqq 0x5f98(%rsi,%zmm23,1),%zmm26{%k1}
 10772a3:	kxnorb %k0,%k0,%k1
 10772a7:	vpmovzxbq %xmm24,%zmm24
 10772ad:	vpmaxuq %zmm4,%zmm26,%zmm4
 10772b3:	vpxord %xmm26,%xmm26,%xmm26
 10772b9:	vpgatherqq 0xa60(%rsi,%zmm23,1),%zmm26{%k1}
 10772c4:	kxnorb %k0,%k0,%k1
 10772c8:	vpaddq %zmm24,%zmm14,%zmm14
 10772ce:	vpxord %xmm24,%xmm24,%xmm24
 10772d4:	vpaddq %zmm2,%zmm26,%zmm2
 10772da:	vpxord %xmm26,%xmm26,%xmm26
 10772e0:	vpgatherqq 0x5f60(%rsi,%zmm23,1),%zmm26{%k1}
 10772eb:	kxnorb %k0,%k0,%k1
 10772ef:	vpaddq %zmm6,%zmm26,%zmm6
 10772f5:	vpxord %xmm26,%xmm26,%xmm26
 10772fb:	vpgatherqq 0xa68(%rsi,%zmm23,1),%zmm26{%k1}
 1077306:	kxnorb %k0,%k0,%k1
 107730a:	vpaddq %zmm3,%zmm26,%zmm3
 1077310:	vpxord %xmm26,%xmm26,%xmm26
 1077316:	vpgatherqq 0x5f68(%rsi,%zmm23,1),%zmm26{%k1}
 1077321:	kxnorb %k0,%k0,%k1
 1077325:	vpaddq %zmm8,%zmm26,%zmm8
 107732b:	vpxord %xmm26,%xmm26,%xmm26
 1077331:	vpgatherqq 0xa70(%rsi,%zmm23,1),%zmm26{%k1}
 107733c:	kxnorb %k0,%k0,%k1
 1077340:	vpaddq %zmm5,%zmm26,%zmm5
 1077346:	vpxord %xmm26,%xmm26,%xmm26
 107734c:	vpgatherqq 0x5f70(%rsi,%zmm23,1),%zmm26{%k1}
 1077357:	kxnorb %k0,%k0,%k1
 107735b:	vpaddq %zmm10,%zmm26,%zmm10
 1077361:	vpxord %xmm26,%xmm26,%xmm26
 1077367:	vpgatherqq 0xa78(%rsi,%zmm23,1),%zmm26{%k1}
 1077372:	kxnorb %k0,%k0,%k1
 1077376:	vpaddq %zmm7,%zmm26,%zmm7
 107737c:	vpxord %xmm26,%xmm26,%xmm26
 1077382:	vpgatherqq 0x5f78(%rsi,%zmm23,1),%zmm26{%k1}
 107738d:	kxnorb %k0,%k0,%k1
 1077391:	vpgatherqq 0xa80(%rsi,%zmm23,1),%zmm24{%k1}
 107739c:	kxnorb %k0,%k0,%k1
 10773a0:	vpaddq %zmm12,%zmm26,%zmm12
 10773a6:	vpaddq %zmm11,%zmm24,%zmm11
 10773ac:	vpxord %xmm24,%xmm24,%xmm24
 10773b2:	vpgatherqq 0x5f80(%rsi,%zmm23,1),%zmm24{%k1}
 10773bd:	kxnorb %k0,%k0,%k1
 10773c1:	vpaddq %zmm16,%zmm24,%zmm16
 10773c7:	vpxord %xmm24,%xmm24,%xmm24
 10773cd:	vpgatherqq 0xa88(%rsi,%zmm23,1),%zmm24{%k1}
 10773d8:	kxnorb %k0,%k0,%k1
 10773dc:	vpaddq %zmm13,%zmm24,%zmm13
 10773e2:	vpxord %xmm24,%xmm24,%xmm24
 10773e8:	vpgatherqq 0x5f88(%rsi,%zmm23,1),%zmm24{%k1}
 10773f3:	kxnorb %k0,%k0,%k1
 10773f7:	vpaddq %zmm18,%zmm24,%zmm18
 10773fd:	vpxord %xmm24,%xmm24,%xmm24
 1077403:	vpgatherqq 0xa90(%rsi,%zmm23,1),%zmm24{%k1}
 107740e:	kxnorb %k0,%k0,%k1
 1077412:	vpaddq %zmm15,%zmm24,%zmm15
 1077418:	vpxord %xmm24,%xmm24,%xmm24
 107741e:	vpgatherqq 0x5f90(%rsi,%zmm23,1),%zmm24{%k1}
 1077429:	vpaddq %zmm17,%zmm24,%zmm17
 107742f:	jne    107710b <check_input_run+0x9d7b>
 1077435:	vpaddq %zmm15,%zmm17,%zmm15
 107743b:	vpaddq %zmm13,%zmm18,%zmm13
 1077441:	vpaddq %zmm11,%zmm16,%zmm11
 1077447:	vpaddq %zmm9,%zmm14,%zmm9
 107744d:	vpaddq %zmm7,%zmm12,%zmm7
 1077453:	vpaddq %zmm5,%zmm10,%zmm5
 1077459:	vpaddq %zmm3,%zmm8,%zmm3
 107745f:	vpaddq %zmm2,%zmm6,%zmm2
 1077465:	vpmaxuq %zmm4,%zmm1,%zmm1
 107746b:	vextracti64x4 $0x1,%zmm15,%ymm17
 1077472:	vpaddq %zmm17,%zmm15,%zmm15
 1077478:	vextracti32x4 $0x1,%ymm15,%xmm17
 107747f:	vpaddq %xmm17,%xmm15,%xmm15
 1077485:	vpshufd $0xee,%xmm15,%xmm17
 107748c:	vpaddq %xmm17,%xmm15,%xmm15
 1077492:	vmovq  %xmm15,%rdi
 1077497:	vextracti64x4 $0x1,%zmm13,%ymm15
 107749e:	vpaddq %zmm15,%zmm13,%zmm13
 10774a4:	vextracti128 $0x1,%ymm13,%xmm15
 10774aa:	vpaddq %xmm15,%xmm13,%xmm13
 10774af:	vpshufd $0xee,%xmm13,%xmm15
 10774b5:	vpaddq %xmm15,%xmm13,%xmm13
 10774ba:	vmovq  %xmm13,%r8
 10774bf:	vextracti64x4 $0x1,%zmm11,%ymm13
 10774c6:	vpaddq %zmm13,%zmm11,%zmm11
 10774cc:	vextracti128 $0x1,%ymm11,%xmm13
 10774d2:	vpaddq %xmm13,%xmm11,%xmm11
 10774d7:	vpshufd $0xee,%xmm11,%xmm13
 10774dd:	vpaddq %xmm13,%xmm11,%xmm11
 10774e2:	vmovq  %xmm11,%r9
 10774e7:	vextracti64x4 $0x1,%zmm9,%ymm11
 10774ee:	vpaddq %zmm11,%zmm9,%zmm9
 10774f4:	vextracti128 $0x1,%ymm9,%xmm11
 10774fa:	vpaddq %xmm11,%xmm9,%xmm9
 10774ff:	vpshufd $0xee,%xmm9,%xmm11
 1077505:	vpaddq %xmm11,%xmm9,%xmm9
 107750a:	vmovq  %xmm9,%r10
 107750f:	vextracti64x4 $0x1,%zmm7,%ymm9
 1077516:	vpaddq %zmm9,%zmm7,%zmm7
 107751c:	vextracti128 $0x1,%ymm7,%xmm9
 1077522:	vpaddq %xmm7,%xmm9,%xmm7
 1077526:	vpshufd $0xee,%xmm7,%xmm9
 107752b:	vpaddq %xmm7,%xmm9,%xmm7
 107752f:	vmovq  %xmm7,%r11
 1077534:	vextracti64x4 $0x1,%zmm5,%ymm7
 107753b:	vpaddq %zmm7,%zmm5,%zmm5
 1077541:	vextracti128 $0x1,%ymm5,%xmm7
 1077547:	vpaddq %xmm7,%xmm5,%xmm5
 107754b:	vpshufd $0xee,%xmm5,%xmm7
 1077550:	vpaddq %xmm7,%xmm5,%xmm5
 1077554:	vmovq  %xmm5,%rbx
 1077559:	vextracti64x4 $0x1,%zmm3,%ymm5
 1077560:	vpaddq %zmm5,%zmm3,%zmm3
 1077566:	vextracti128 $0x1,%ymm3,%xmm5
 107756c:	vpaddq %xmm5,%xmm3,%xmm3
 1077570:	vpshufd $0xee,%xmm3,%xmm5
 1077575:	vpaddq %xmm5,%xmm3,%xmm3
 1077579:	vmovq  %xmm3,%r12
 107757e:	vextracti64x4 $0x1,%zmm2,%ymm3
 1077585:	vpaddq %zmm3,%zmm2,%zmm2
 107758b:	vextracti128 $0x1,%ymm2,%xmm3
 1077591:	vpaddq %xmm3,%xmm2,%xmm2
 1077595:	vpshufd $0xee,%xmm2,%xmm3
 107759a:	vpaddq %xmm3,%xmm2,%xmm2
 107759e:	vmovq  %xmm2,%r15
 10775a3:	vextracti64x4 $0x1,%zmm1,%ymm2
 10775aa:	vpmaxuq %ymm2,%ymm1,%ymm1
 10775b0:	vextracti128 $0x1,%ymm1,%xmm2
 10775b6:	vpmaxuq %xmm2,%xmm1,%xmm1
 10775bc:	vpshufd $0xee,%xmm1,%xmm2
 10775c1:	vpmaxuq %xmm2,%xmm1,%xmm1
 10775c7:	vmovq  %xmm1,%rax
 10775cc:	cmp    %ecx,%r14d
 10775cf:	je     1077974 <check_input_run+0xa5e4>
 10775d5:	test   $0x8,%cl
 10775d8:	je     107791e <check_input_run+0xa58e>
 10775de:	mov    %r14,%rdx
 10775e1:	vpbroadcastq %rdx,%zmm10
 10775e7:	vporq  -0xbd9ff1(%rip),%zmm10,%zmm10        # 49d600 <cbuiltin_test_generated.edges+0x37c0>
 10775f1:	vpbroadcastq -0xacafcb(%rip),%zmm11        # 5ac630 <check_mutation_families+0x190>
 10775fb:	vpbroadcastq -0xacafbd(%rip),%zmm12        # 5ac648 <check_mutation_families+0x1a8>
 1077605:	mov    %ecx,%r14d
 1077608:	and    $0x78,%r14d
 107760c:	vmovq  %rdi,%xmm9
 1077611:	vmovq  %r8,%xmm8
 1077616:	vmovq  %r9,%xmm7
 107761b:	vmovq  %r10,%xmm6
 1077620:	vmovq  %r11,%xmm5
 1077625:	vmovq  %rbx,%xmm4
 107762a:	vmovq  %r12,%xmm3
 107762f:	vmovq  %r15,%xmm2
 1077634:	vpbroadcastq %rax,%zmm1
 107763a:	sub    %r14,%rdx
 107763d:	vpmullq %zmm11,%zmm10,%zmm13
 1077643:	kxnorb %k0,%k0,%k1
 1077647:	vpxor  %xmm15,%xmm15,%xmm15
 107764c:	vpaddq %zmm12,%zmm10,%zmm10
 1077652:	add    $0x8,%rdx
 1077656:	vpaddq %zmm13,%zmm0,%zmm14
 107765c:	vpgatherqq 0xa98(%rsi,%zmm13,1),%zmm15{%k1}
 1077667:	kxnorb %k0,%k0,%k1
 107766b:	vextracti32x4 $0x1,%ymm14,%xmm17
 1077672:	vextracti32x4 $0x2,%zmm14,%xmm16
 1077679:	vmovq  %xmm14,%rax
 107767e:	vpextrq $0x1,%xmm14,%rdi
 1077684:	vextracti32x4 $0x3,%zmm14,%xmm14
 107768b:	vmovq  %xmm14,%rbx
 1077690:	vpextrq $0x1,%xmm14,%r15
 1077696:	vmovd  0x9e0(%rax),%xmm14
 107769e:	vmovq  %xmm17,%r8
 10776a4:	vpextrq $0x1,%xmm17,%r9
 10776ab:	vmovq  %xmm16,%r10
 10776b1:	vpextrq $0x1,%xmm16,%r11
 10776b8:	vpmaxuq %zmm1,%zmm15,%zmm1
 10776be:	vpxor  %xmm15,%xmm15,%xmm15
 10776c3:	vpgatherqq 0xa60(%rsi,%zmm13,1),%zmm15{%k1}
 10776ce:	kxnorb %k0,%k0,%k1
 10776d2:	vpinsrb $0x1,0x9e0(%rdi),%xmm14,%xmm14
 10776dc:	vpinsrb $0x2,0x9e0(%r8),%xmm14,%xmm14
 10776e6:	vpaddq %zmm2,%zmm15,%zmm2
 10776ec:	vpxor  %xmm15,%xmm15,%xmm15
 10776f1:	vpgatherqq 0xa68(%rsi,%zmm13,1),%zmm15{%k1}
 10776fc:	kxnorb %k0,%k0,%k1
 1077700:	vpinsrb $0x3,0x9e0(%r9),%xmm14,%xmm14
 107770a:	vpaddq %zmm3,%zmm15,%zmm3
 1077710:	vpxor  %xmm15,%xmm15,%xmm15
 1077715:	vpgatherqq 0xa70(%rsi,%zmm13,1),%zmm15{%k1}
 1077720:	kxnorb %k0,%k0,%k1
 1077724:	vpinsrb $0x4,0x9e0(%r10),%xmm14,%xmm14
 107772e:	vpaddq %zmm4,%zmm15,%zmm4
 1077734:	vpxor  %xmm15,%xmm15,%xmm15
 1077739:	vpgatherqq 0xa78(%rsi,%zmm13,1),%zmm15{%k1}
 1077744:	kxnorb %k0,%k0,%k1
 1077748:	vpinsrb $0x5,0x9e0(%r11),%xmm14,%xmm14
 1077752:	vpaddq %zmm5,%zmm15,%zmm5
 1077758:	vpinsrb $0x6,0x9e0(%rbx),%xmm14,%xmm14
 1077762:	vpinsrb $0x7,0x9e0(%r15),%xmm14,%xmm14
 107776c:	vpmovzxbq %xmm14,%zmm14
 1077772:	vpaddq %zmm14,%zmm6,%zmm6
 1077778:	vpxor  %xmm14,%xmm14,%xmm14
 107777d:	vpgatherqq 0xa80(%rsi,%zmm13,1),%zmm14{%k1}
 1077788:	kxnorb %k0,%k0,%k1
 107778c:	vpaddq %zmm7,%zmm14,%zmm7
 1077792:	vpxor  %xmm14,%xmm14,%xmm14
 1077797:	vpgatherqq 0xa88(%rsi,%zmm13,1),%zmm14{%k1}
 10777a2:	kxnorb %k0,%k0,%k1
 10777a6:	vpaddq %zmm8,%zmm14,%zmm8
 10777ac:	vpxor  %xmm14,%xmm14,%xmm14
 10777b1:	vpgatherqq 0xa90(%rsi,%zmm13,1),%zmm14{%k1}
 10777bc:	vpaddq %zmm9,%zmm14,%zmm9
 10777c2:	jne    107763d <check_input_run+0xa2ad>
 10777c8:	vextracti64x4 $0x1,%zmm9,%ymm0
 10777cf:	vpaddq %zmm0,%zmm9,%zmm0
 10777d5:	vextracti128 $0x1,%ymm0,%xmm9
 10777db:	vpaddq %xmm0,%xmm9,%xmm0
 10777df:	vpshufd $0xee,%xmm0,%xmm9
 10777e4:	vpaddq %xmm0,%xmm9,%xmm0
 10777e8:	vmovq  %xmm0,%rdi
 10777ed:	vextracti64x4 $0x1,%zmm8,%ymm0
 10777f4:	vpaddq %zmm0,%zmm8,%zmm0
 10777fa:	vextracti128 $0x1,%ymm0,%xmm8
 1077800:	vpaddq %xmm0,%xmm8,%xmm0
 1077804:	vpshufd $0xee,%xmm0,%xmm8
 1077809:	vpaddq %xmm0,%xmm8,%xmm0
 107780d:	vmovq  %xmm0,%r8
 1077812:	vextracti64x4 $0x1,%zmm7,%ymm0
 1077819:	vpaddq %zmm0,%zmm7,%zmm0
 107781f:	vextracti128 $0x1,%ymm0,%xmm7
 1077825:	vpaddq %xmm7,%xmm0,%xmm0
 1077829:	vpshufd $0xee,%xmm0,%xmm7
 107782e:	vpaddq %xmm7,%xmm0,%xmm0
 1077832:	vmovq  %xmm0,%r9
 1077837:	vextracti64x4 $0x1,%zmm6,%ymm0
 107783e:	vpaddq %zmm0,%zmm6,%zmm0
 1077844:	vextracti128 $0x1,%ymm0,%xmm6
 107784a:	vpaddq %xmm6,%xmm0,%xmm0
 107784e:	vpshufd $0xee,%xmm0,%xmm6
 1077853:	vpaddq %xmm6,%xmm0,%xmm0
 1077857:	vmovq  %xmm0,%r10
 107785c:	vextracti64x4 $0x1,%zmm5,%ymm0
 1077863:	vpaddq %zmm0,%zmm5,%zmm0
 1077869:	vextracti128 $0x1,%ymm0,%xmm5
 107786f:	vpaddq %xmm5,%xmm0,%xmm0
 1077873:	vpshufd $0xee,%xmm0,%xmm5
 1077878:	vpaddq %xmm5,%xmm0,%xmm0
 107787c:	vmovq  %xmm0,%r11
 1077881:	vextracti64x4 $0x1,%zmm4,%ymm0
 1077888:	vpaddq %zmm0,%zmm4,%zmm0
 107788e:	vextracti128 $0x1,%ymm0,%xmm4
 1077894:	vpaddq %xmm4,%xmm0,%xmm0
 1077898:	vpshufd $0xee,%xmm0,%xmm4
 107789d:	vpaddq %xmm4,%xmm0,%xmm0
 10778a1:	vmovq  %xmm0,%rbx
 10778a6:	vextracti64x4 $0x1,%zmm3,%ymm0
 10778ad:	vpaddq %zmm0,%zmm3,%zmm0
 10778b3:	vextracti128 $0x1,%ymm0,%xmm3
 10778b9:	vpaddq %xmm3,%xmm0,%xmm0
 10778bd:	vpshufd $0xee,%xmm0,%xmm3
 10778c2:	vpaddq %xmm3,%xmm0,%xmm0
 10778c6:	vmovq  %xmm0,%r12
 10778cb:	vextracti64x4 $0x1,%zmm2,%ymm0
 10778d2:	vpaddq %zmm0,%zmm2,%zmm0
 10778d8:	vextracti128 $0x1,%ymm0,%xmm2
 10778de:	vpaddq %xmm2,%xmm0,%xmm0
 10778e2:	vpshufd $0xee,%xmm0,%xmm2
 10778e7:	vpaddq %xmm2,%xmm0,%xmm0
 10778eb:	vmovq  %xmm0,%r15
 10778f0:	vextracti64x4 $0x1,%zmm1,%ymm0
 10778f7:	vpmaxuq %ymm0,%ymm1,%ymm0
 10778fd:	vextracti128 $0x1,%ymm0,%xmm1
 1077903:	vpmaxuq %xmm1,%xmm0,%xmm0
 1077909:	vpshufd $0xee,%xmm0,%xmm1
 107790e:	vpmaxuq %xmm1,%xmm0,%xmm0
 1077914:	vmovq  %xmm0,%rax
 1077919:	cmp    %ecx,%r14d
 107791c:	je     1077974 <check_input_run+0xa5e4>
 107791e:	mov    0x860(%rsp),%rsi
 1077926:	imul   $0xaa0,%r14,%rdx
 107792d:	sub    %r14,%rcx
 1077930:	lea    0xcc0(%rdx,%rsi,1),%rdx
 1077938:	mov    (%rdx),%rsi
 107793b:	cmp    %rax,%rsi
 107793e:	cmova  %rsi,%rax
 1077942:	movzbl -0xb8(%rdx),%esi
 1077949:	add    -0x38(%rdx),%r15
 107794d:	add    -0x30(%rdx),%r12
 1077951:	add    -0x28(%rdx),%rbx
 1077955:	add    -0x20(%rdx),%r11
 1077959:	add    -0x18(%rdx),%r9
 107795d:	add    -0x10(%rdx),%r8
 1077961:	add    -0x8(%rdx),%rdi
 1077965:	add    $0xaa0,%rdx
 107796c:	add    %rsi,%r10
 107796f:	dec    %rcx
 1077972:	jne    1077938 <check_input_run+0xa5a8>
 1077974:	mov    0x860(%rsp),%rcx
 107797c:	mov    0x48(%rsp),%r14
 1077981:	mov    %r15,0x2ac68(%rcx)
 1077988:	mov    0x1b0(%rsp),%r15
 1077990:	mov    %r12,0x2ac70(%rcx)
 1077997:	mov    %rcx,%r12
 107799a:	mov    %rbx,0x2ac78(%rcx)
 10779a1:	mov    %r11,0x2ac80(%rcx)
 10779a8:	mov    %r10,0x2ac88(%rcx)
 10779af:	mov    %r9,0x2acd8(%rcx)
 10779b6:	mov    %r8,0x2acd0(%rcx)
 10779bd:	mov    %rdi,0x2ace0(%rcx)
 10779c4:	mov    %rbp,%rcx
 10779c7:	sub    %r13,%rcx
 10779ca:	sub    %rbp,%rax
 10779cd:	test   %rbp,%rbp
 10779d0:	cmove  %rbp,%rcx
 10779d4:	cmove  %rbp,%rax
 10779d8:	cmpb   $0x0,0xd0(%rsp)
 10779e0:	mov    %rcx,0x2ace8(%r12)
 10779e8:	mov    %rax,0x2acf0(%r12)
 10779f0:	je     1077a36 <check_input_run+0xa6a6>
 10779f2:	mov    0x28(%rsp),%rax
 10779f7:	mov    $0x1,%bl
 10779f9:	mov    (%rax),%eax
 10779fb:	test   %rax,%rax
 10779fe:	je     1077a38 <check_input_run+0xa6a8>
 1077a00:	imul   $0x150,%rax,%rax
 1077a07:	xor    %ecx,%ecx
 1077a09:	mov    (%r15),%rdx
 1077a0c:	cmpb   $0x0,0x14c(%rdx,%rcx,1)
 1077a14:	lea    0x130(%rdx,%rcx,1),%rsi
 1077a1c:	cmove  %r14,%rsi
 1077a20:	mov    (%rsi),%rdx
 1077a23:	mov    %rdx,(%r14)
 1077a26:	jne    1077a36 <check_input_run+0xa6a6>
 1077a28:	add    $0x150,%rcx
 1077a2f:	cmp    %rcx,%rax
 1077a32:	jne    1077a09 <check_input_run+0xa679>
 1077a34:	jmp    1077a38 <check_input_run+0xa6a8>
 1077a36:	xor    %ebx,%ebx
 1077a38:	cmpb   $0x0,0x2ac90(%r12)
 1077a41:	je     1077a7b <check_input_run+0xa6eb>
 1077a43:	lea    0x780(%rsp),%rsi
 1077a4b:	mov    $0x1,%edi
 1077a50:	vpxor  %xmm0,%xmm0,%xmm0
 1077a54:	vmovdqa %xmm0,0x780(%rsp)
 1077a5d:	vzeroupper
 1077a60:	call   787bc0 <clock_gettime@plt>
 1077a65:	imul   $0xffffffffc4653600,0x780(%rsp),%rax
 1077a71:	sub    0x788(%rsp),%rax
 1077a79:	jmp    1077a7d <check_input_run+0xa6ed>
 1077a7b:	xor    %eax,%eax
 1077a7d:	mov    %ebx,0xd0(%rsp)
 1077a84:	mov    %rax,0x130(%rsp)
 1077a8c:	test   %bl,%bl
 1077a8e:	je     1077ae4 <check_input_run+0xa754>
 1077a90:	mov    0x2a8(%rsp),%rax
 1077a98:	mov    0x2ac40(%r12),%r13
 1077aa0:	mov    0x1e0(%r12),%r14d
 1077aa8:	mov    0x2a0(%rsp),%rbp
 1077ab0:	mov    0x30(%rax),%r9d
 1077ab4:	mov    0x2ac38(%r12),%rax
 1077abc:	lea    0x1(%r14),%rbx
 1077ac0:	lea    0x7(%r13,%rax,1),%r8
 1077ac5:	lea    0x0(%r13,%rax,1),%rcx
 1077aca:	and    $0xfffffffffffffff8,%r8
 1077ace:	cmp    %rcx,%r8
 1077ad1:	jae    1077af2 <check_input_run+0xa762>
 1077ad3:	mov    $0x1,%al
 1077ad5:	xor    %r10d,%r10d
 1077ad8:	mov    %eax,0x210(%rsp)
 1077adf:	jmp    1078295 <check_input_run+0xaf05>
 1077ae4:	mov    $0x1,%cl
 1077ae6:	mov    %ecx,0x210(%rsp)
 1077aed:	jmp    107830e <check_input_run+0xaf7e>
 1077af2:	mov    0x2ac48(%r12),%rdx
 1077afa:	mov    $0x1,%cl
 1077afc:	xor    %r10d,%r10d
 1077aff:	mov    %ecx,0x210(%rsp)
 1077b06:	mov    %r8,%rcx
 1077b09:	sub    %rax,%rcx
 1077b0c:	mov    %rdx,%rsi
 1077b0f:	sub    %rcx,%rsi
 1077b12:	jb     1078295 <check_input_run+0xaf05>
 1077b18:	mov    %rbx,%rdi
 1077b1b:	shl    $0x4,%rdi
 1077b1f:	lea    (%rdi,%rdi,2),%rdi
 1077b23:	cmp    %rsi,%rdi
 1077b26:	ja     1078295 <check_input_run+0xaf05>
 1077b2c:	add    %rdi,%rcx
 1077b2f:	mov    %rcx,0x2ac40(%r12)
 1077b37:	test   %r8,%r8
 1077b3a:	je     1077b93 <check_input_run+0xa803>
 1077b3c:	mov    %r9,0xe8(%rsp)
 1077b44:	mov    0x58(%r12),%r9d
 1077b49:	add    %r8,%rdi
 1077b4c:	mov    %r8,0x70(%rsp)
 1077b51:	mov    %rdx,%r11
 1077b54:	mov    %rdi,%r8
 1077b57:	sub    %rax,%r8
 1077b5a:	shl    $0x2,%r9
 1077b5e:	sub    %r8,%r11
 1077b61:	setb   %sil
 1077b65:	cmp    %r11,%r9
 1077b68:	seta   %r10b
 1077b6c:	or     %sil,%r10b
 1077b6f:	je     1077b9e <check_input_run+0xa80e>
 1077b71:	xor    %esi,%esi
 1077b73:	jmp    1077bbe <check_input_run+0xa82e>
 1077b75:	cmp    $0x130,%ecx
 1077b7b:	je     1077b89 <check_input_run+0xa7f9>
 1077b7d:	cmp    $0x133,%ecx
 1077b83:	jne    1077fc2 <check_input_run+0xac32>
 1077b89:	mov    $0x1,%eax
 1077b8e:	jmp    1074c5f <check_input_run+0x78cf>
 1077b93:	xor    %r10d,%r10d
 1077b96:	mov    %rcx,%r13
 1077b99:	jmp    1078295 <check_input_run+0xaf05>
 1077b9e:	mov    %rdi,%rsi
 1077ba1:	add    %r9,%rdi
 1077ba4:	mov    %r8,%rcx
 1077ba7:	add    %r9,%rcx
 1077baa:	mov    %rdx,%r11
 1077bad:	mov    %rdi,%r8
 1077bb0:	sub    %rax,%r8
 1077bb3:	mov    %rcx,0x2ac40(%r12)
 1077bbb:	sub    %r8,%r11
 1077bbe:	mov    0xc8(%rsp),%r9
 1077bc6:	mov    (%r9),%r10d
 1077bc9:	xor    %r9d,%r9d
 1077bcc:	cmp    %rdx,%r8
 1077bcf:	ja     1077fe7 <check_input_run+0xac57>
 1077bd5:	lea    0x0(,%r10,4),%r15
 1077bdd:	cmp    %r11,%r15
 1077be0:	mov    0x70(%rsp),%r11
 1077be5:	ja     1077fec <check_input_run+0xac5c>
 1077beb:	add    %r8,%r15
 1077bee:	mov    %rdi,%r9
 1077bf1:	mov    %r15,%rcx
 1077bf4:	mov    %r15,0x2ac40(%r12)
 1077bfc:	jmp    1077fec <check_input_run+0xac5c>
 1077c01:	xor    %r11d,%r11d
 1077c04:	jmp    10715d2 <check_input_run+0x4242>
 1077c09:	mov    %ebp,%edi
 1077c0b:	and    $0xfffffffc,%edi
 1077c0e:	mov    $0xffffffff,%esi
 1077c13:	xor    %edx,%edx
 1077c15:	jmp    1077c30 <check_input_run+0xa8a0>
 1077c17:	mov    %esi,0xc(%r15,%rdx,4)
 1077c1c:	lea    0x3(%rdx),%esi
 1077c1f:	mov    %esi,(%r15,%r9,4)
 1077c23:	add    $0x4,%rdx
 1077c27:	cmp    %rdx,%rdi
 1077c2a:	je     1077d4b <check_input_run+0xa9bb>
 1077c30:	mov    0x50(%r14),%r9
 1077c34:	mov    0x60(%r14),%r8
 1077c38:	movzbl (%r9,%rdx,1),%r9d
 1077c3d:	add    $0xde,%r9b
 1077c41:	cmp    $0x18,%r9b
 1077c45:	ja     1077c5c <check_input_run+0xa8cc>
 1077c47:	mov    (%r8,%rdx,4),%r9d
 1077c4b:	cmp    %ebp,%r9d
 1077c4e:	jae    1077c5c <check_input_run+0xa8cc>
 1077c50:	mov    %esi,(%r15,%rdx,4)
 1077c54:	mov    %edx,(%r15,%r9,4)
 1077c58:	mov    %edx,%esi
 1077c5a:	jmp    1077c70 <check_input_run+0xa8e0>
 1077c5c:	cmp    %ebp,%esi
 1077c5e:	jae    1077c70 <check_input_run+0xa8e0>
 1077c60:	mov    %esi,%r9d
 1077c63:	mov    (%r8,%r9,4),%r8d
 1077c67:	cmp    %r8,%rdx
 1077c6a:	jne    1077c70 <check_input_run+0xa8e0>
 1077c6c:	mov    (%r15,%r9,4),%esi
 1077c70:	mov    0x50(%r14),%r9
 1077c74:	mov    0x60(%r14),%r8
 1077c78:	movzbl 0x1(%r9,%rdx,1),%r9d
 1077c7e:	add    $0xde,%r9b
 1077c82:	cmp    $0x18,%r9b
 1077c86:	ja     1077ca0 <check_input_run+0xa910>
 1077c88:	mov    0x4(%r8,%rdx,4),%r9d
 1077c8d:	cmp    %ebp,%r9d
 1077c90:	jae    1077ca0 <check_input_run+0xa910>
 1077c92:	mov    %esi,0x4(%r15,%rdx,4)
 1077c97:	lea    0x1(%rdx),%esi
 1077c9a:	mov    %esi,(%r15,%r9,4)
 1077c9e:	jmp    1077cb8 <check_input_run+0xa928>
 1077ca0:	cmp    %ebp,%esi
 1077ca2:	jae    1077cb8 <check_input_run+0xa928>
 1077ca4:	mov    %esi,%r9d
 1077ca7:	mov    (%r8,%r9,4),%r8d
 1077cab:	lea    0x1(%rdx),%r10
 1077caf:	cmp    %r8,%r10
 1077cb2:	jne    1077cb8 <check_input_run+0xa928>
 1077cb4:	mov    (%r15,%r9,4),%esi
 1077cb8:	mov    0x50(%r14),%r9
 1077cbc:	mov    0x60(%r14),%r8
 1077cc0:	movzbl 0x2(%r9,%rdx,1),%r9d
 1077cc6:	add    $0xde,%r9b
 1077cca:	cmp    $0x18,%r9b
 1077cce:	ja     1077ce8 <check_input_run+0xa958>
 1077cd0:	mov    0x8(%r8,%rdx,4),%r9d
 1077cd5:	cmp    %ebp,%r9d
 1077cd8:	jae    1077ce8 <check_input_run+0xa958>
 1077cda:	mov    %esi,0x8(%r15,%rdx,4)
 1077cdf:	lea    0x2(%rdx),%esi
 1077ce2:	mov    %esi,(%r15,%r9,4)
 1077ce6:	jmp    1077d00 <check_input_run+0xa970>
 1077ce8:	cmp    %ebp,%esi
 1077cea:	jae    1077d00 <check_input_run+0xa970>
 1077cec:	mov    %esi,%r9d
 1077cef:	mov    (%r8,%r9,4),%r8d
 1077cf3:	lea    0x2(%rdx),%r10
 1077cf7:	cmp    %r8,%r10
 1077cfa:	jne    1077d00 <check_input_run+0xa970>
 1077cfc:	mov    (%r15,%r9,4),%esi
 1077d00:	mov    0x50(%r14),%r9
 1077d04:	mov    0x60(%r14),%r8
 1077d08:	movzbl 0x3(%r9,%rdx,1),%r9d
 1077d0e:	add    $0xde,%r9b
 1077d12:	cmp    $0x18,%r9b
 1077d16:	ja     1077d26 <check_input_run+0xa996>
 1077d18:	mov    0xc(%r8,%rdx,4),%r9d
 1077d1d:	cmp    %ebp,%r9d
 1077d20:	jb     1077c17 <check_input_run+0xa887>
 1077d26:	cmp    %ebp,%esi
 1077d28:	jae    1077c23 <check_input_run+0xa893>
 1077d2e:	mov    %esi,%r9d
 1077d31:	mov    (%r8,%r9,4),%r8d
 1077d35:	lea    0x3(%rdx),%r10
 1077d39:	cmp    %r8,%r10
 1077d3c:	jne    1077c23 <check_input_run+0xa893>
 1077d42:	mov    (%r15,%r9,4),%esi
 1077d46:	jmp    1077c23 <check_input_run+0xa893>
 1077d4b:	test   %rcx,%rcx
 1077d4e:	jne    1077e08 <check_input_run+0xaa78>
 1077d54:	mov    %rbp,%rcx
 1077d57:	test   $0x1,%bpl
 1077d5b:	je     107973b <check_input_run+0xc3ab>
 1077d61:	mov    0x68(%r14),%rcx
 1077d65:	mov    0x50(%r14),%rdi
 1077d69:	mov    0x60(%r14),%rdx
 1077d6d:	mov    -0x4(%rcx,%rbp,4),%ecx
 1077d71:	movzbl (%rdi,%rcx,1),%r8d
 1077d76:	mov    (%rdx,%rcx,4),%esi
 1077d79:	mov    $0x1,%dl
 1077d7b:	lea    -0x41(%r8),%r9d
 1077d7f:	cmp    $0xe,%r9d
 1077d83:	ja     1077d95 <check_input_run+0xaa05>
 1077d85:	mov    $0x6005,%r10d
 1077d8b:	bt     %r9d,%r10d
 1077d8f:	jb     1079733 <check_input_run+0xc3a3>
 1077d95:	add    $0xfffffff9,%r8d
 1077d99:	cmp    $0x2,%r8d
 1077d9d:	jb     1079733 <check_input_run+0xc3a3>
 1077da3:	cmp    %ebp,%esi
 1077da5:	jae    1079729 <check_input_run+0xc399>
 1077dab:	mov    0x90(%rsp),%r8
 1077db3:	cmpb   $0x0,(%r8,%rsi,1)
 1077db8:	je     1079729 <check_input_run+0xc399>
 1077dbe:	movzbl (%rdi,%rsi,1),%edi
 1077dc2:	mov    0x90(%rsp),%r13
 1077dca:	add    $0xfffffff9,%edi
 1077dcd:	cmp    $0x44,%edi
 1077dd0:	ja     1079731 <check_input_run+0xc3a1>
 1077dd6:	lea    -0xbda781(%rip),%r8        # 49d65c <cbuiltin_test_generated.edges+0x381c>
 1077ddd:	movslq (%r8,%rdi,4),%rdi
 1077de1:	add    %r8,%rdi
 1077de4:	jmp    *%rdi
 1077de6:	cmp    (%r15,%rsi,4),%ecx
 1077dea:	setb   %dl
 1077ded:	jmp    1079733 <check_input_run+0xc3a3>
 1077df2:	mov    %esi,(%r15,%rdx,4)
 1077df6:	mov    %edx,%esi
 1077df8:	mov    %edx,(%r15,%r8,4)
 1077dfc:	inc    %rdx
 1077dff:	dec    %rcx
 1077e02:	je     1077d54 <check_input_run+0xa9c4>
 1077e08:	mov    0x50(%r14),%r8
 1077e0c:	mov    0x60(%r14),%rdi
 1077e10:	movzbl (%r8,%rdx,1),%r8d
 1077e15:	add    $0xde,%r8b
 1077e19:	cmp    $0x18,%r8b
 1077e1d:	ja     1077e28 <check_input_run+0xaa98>
 1077e1f:	mov    (%rdi,%rdx,4),%r8d
 1077e23:	cmp    %ebp,%r8d
 1077e26:	jb     1077df2 <check_input_run+0xaa62>
 1077e28:	cmp    %ebp,%esi
 1077e2a:	jae    1077dfc <check_input_run+0xaa6c>
 1077e2c:	mov    %esi,%r8d
 1077e2f:	mov    (%rdi,%r8,4),%edi
 1077e33:	cmp    %rdi,%rdx
 1077e36:	jne    1077dfc <check_input_run+0xaa6c>
 1077e38:	mov    (%r15,%r8,4),%esi
 1077e3c:	jmp    1077dfc <check_input_run+0xaa6c>
 1077e3e:	mov    %rcx,%rdx
 1077e41:	sub    %rsi,%rdx
 1077e44:	mov    0x10(%r8),%rsi
 1077e48:	sub    %rdx,%rsi
 1077e4b:	jb     1078d4a <check_input_run+0xb9ba>
 1077e51:	cmp    %rsi,%rax
 1077e54:	ja     1078d4a <check_input_run+0xb9ba>
 1077e5a:	mov    0x10(%rsp),%rsi
 1077e5f:	mov    0x18(%rsp),%rdi
 1077e64:	add    %rax,%rdx
 1077e67:	mov    %rdx,0x8(%rsi)
 1077e6b:	mov    %rcx,0x240(%rdi)
 1077e72:	test   %rcx,%rcx
 1077e75:	je     10795f5 <check_input_run+0xc265>
 1077e7b:	mov    0x8(%rsi),%rcx
 1077e7f:	mov    0x10(%rsi),%rdx
 1077e83:	sub    %rcx,%rdx
 1077e86:	setb   %sil
 1077e8a:	cmp    0x78(%rsp),%rdx
 1077e8f:	setbe  %dl
 1077e92:	or     %sil,%dl
 1077e95:	cmp    $0x1,%dl
 1077e98:	jne    1079615 <check_input_run+0xc285>
 1077e9e:	mov    0x18(%rsp),%rdi
 1077ea3:	mov    0x10(%rsp),%rsi
 1077ea8:	movq   $0x0,0x248(%rdi)
 1077eb3:	movq   $0x0,0x260(%rdi)
 1077ebe:	jmp    106dbd6 <check_input_run+0x846>
 1077ec3:	mov    0x58(%rsp),%rdx
 1077ec8:	mov    %rbp,%rsi
 1077ecb:	sub    %rdi,%rsi
 1077ece:	mov    0x10(%rcx),%rdi
 1077ed2:	mov    %r8,%r11
 1077ed5:	mov    0x830(%rdx),%edx
 1077edb:	sub    %rsi,%rdi
 1077ede:	setb   %r8b
 1077ee2:	cmp    %rdx,%rdi
 1077ee5:	setbe  %dil
 1077ee9:	or     %r8b,%dil
 1077eec:	je     1078d7a <check_input_run+0xb9ea>
 1077ef2:	xor    %ebp,%ebp
 1077ef4:	jmp    1078d84 <check_input_run+0xb9f4>
 1077ef9:	mov    0x2ac38(%r12),%rdx
 1077f01:	mov    0x2ac40(%r12),%rax
 1077f09:	lea    0x7(%rax,%rdx,1),%rcx
 1077f0e:	add    %rdx,%rax
 1077f11:	and    $0xfffffffffffffff8,%rcx
 1077f15:	cmp    %rax,%rcx
 1077f18:	jb     1077fa5 <check_input_run+0xac15>
 1077f1e:	mov    0x2ac48(%r12),%rsi
 1077f26:	mov    %rcx,%rdi
 1077f29:	sub    %rdx,%rdi
 1077f2c:	mov    %rsi,%r9
 1077f2f:	sub    %rdi,%r9
 1077f32:	jb     1077fa5 <check_input_run+0xac15>
 1077f34:	mov    0x1e0(%r12),%eax
 1077f3c:	lea    0x8(,%rax,8),%r8
 1077f44:	cmp    %r9,%r8
 1077f47:	ja     1077fa5 <check_input_run+0xac15>
 1077f49:	add    %r8,%rdi
 1077f4c:	mov    %rdi,0x2ac40(%r12)
 1077f54:	mov    %rcx,0x2aa28(%r12)
 1077f5c:	test   %rcx,%rcx
 1077f5f:	je     1077f8c <check_input_run+0xabfc>
 1077f61:	add    %r8,%rcx
 1077f64:	mov    %rsi,%r8
 1077f67:	mov    %rcx,%rdi
 1077f6a:	sub    %rdx,%rdi
 1077f6d:	sub    %rdi,%r8
 1077f70:	setb   %r9b
 1077f74:	cmp    $0x20008,%r8
 1077f7b:	setb   %r8b
 1077f7f:	or     %r9b,%r8b
 1077f82:	cmp    $0x1,%r8b
 1077f86:	jne    107a000 <check_input_run+0xcc70>
 1077f8c:	mov    0x860(%rsp),%r12
 1077f94:	movq   $0x0,0x2aa30(%r12)
 1077fa0:	jmp    1076dd8 <check_input_run+0x9a48>
 1077fa5:	movq   $0x0,0x2aa28(%r12)
 1077fb1:	movq   $0x0,0x2aa30(%r12)
 1077fbd:	jmp    1076dd8 <check_input_run+0x9a48>
 1077fc2:	lea    -0x300(%rcx),%edx
 1077fc8:	cmp    $0x16,%dx
 1077fcc:	mov    0x10(%rsp),%rdx
 1077fd1:	ja     1074c64 <check_input_run+0x78d4>
 1077fd7:	xor    %eax,%eax
 1077fd9:	cmp    $0x312,%ecx
 1077fdf:	sete   %al
 1077fe2:	jmp    1074c64 <check_input_run+0x78d4>
 1077fe7:	mov    0x70(%rsp),%r11
 1077fec:	xor    %edi,%edi
 1077fee:	lea    0x128(%r12),%r8
 1077ff6:	sub    %rcx,%rdx
 1077ff9:	jb     1078011 <check_input_run+0xac81>
 1077ffb:	cmp    %r10,%rdx
 1077ffe:	jb     1078011 <check_input_run+0xac81>
 1078000:	add    %rcx,%rax
 1078003:	add    %rcx,%r10
 1078006:	mov    %rax,%rdi
 1078009:	mov    %r10,0x2ac40(%r12)
 1078011:	movabs $0x100000040,%rax
 107801b:	mov    %r8,(%r11)
 107801e:	movq   $0x0,0x8(%r11)
 1078026:	mov    %rax,0x10(%r11)
 107802a:	mov    %rsi,0x18(%r11)
 107802e:	mov    %r9,0x20(%r11)
 1078032:	mov    %rdi,0x28(%r11)
 1078036:	test   %rsi,%rsi
 1078039:	je     1078282 <check_input_run+0xaef2>
 107803f:	test   %r9,%r9
 1078042:	mov    %rbx,0xc0(%rsp)
 107804a:	setne  %al
 107804d:	test   %rdi,%rdi
 1078050:	setne  %sil
 1078054:	and    %al,%sil
 1078057:	test   %r14,%r14
 107805a:	setne  0x58(%rsp)
 107805f:	je     10781f3 <check_input_run+0xae63>
 1078065:	test   %sil,%sil
 1078068:	je     10781f3 <check_input_run+0xae63>
 107806e:	mov    0x70(%rsp),%rax
 1078073:	mov    $0x1,%edx
 1078078:	xor    %ecx,%ecx
 107807a:	add    $0x58,%rax
 107807e:	mov    0x2ac38(%r12),%r8
 1078086:	mov    0x2ac40(%r12),%r9
 107808e:	mov    0x1d8(%r12),%rsi
 1078096:	mov    0x2ac48(%r12),%r10
 107809e:	lea    0x3(%r9,%r8,1),%rdi
 10780a3:	lea    (%r9,%r8,1),%r11
 10780a7:	and    $0xfffffffffffffffc,%rdi
 10780ab:	cmp    %r11,%rdi
 10780ae:	jae    10780bf <check_input_run+0xad2f>
 10780b0:	mov    0x54(%rsi,%rcx,1),%r12d
 10780b5:	xor    %r11d,%r11d
 10780b8:	xor    %edi,%edi
 10780ba:	jmp    1078154 <check_input_run+0xadc4>
 10780bf:	mov    %rdi,%r15
 10780c2:	sub    %r8,%r15
 10780c5:	mov    %r10,%r13
 10780c8:	sub    %r15,%r13
 10780cb:	jb     1078108 <check_input_run+0xad78>
 10780cd:	mov    0x50(%rsi,%rcx,1),%r11d
 10780d2:	lea    0x4(,%r11,4),%r12
 10780da:	cmp    %r13,%r12
 10780dd:	ja     1078108 <check_input_run+0xad78>
 10780df:	mov    %r15,%r9
 10780e2:	mov    0x860(%rsp),%r15
 10780ea:	mov    %rdi,%r11
 10780ed:	add    %r12,%r9
 10780f0:	add    %r12,%rdi
 10780f3:	mov    %r10,%r13
 10780f6:	mov    %r9,0x2ac40(%r15)
 10780fd:	mov    %rdi,%r15
 1078100:	sub    %r8,%r15
 1078103:	sub    %r15,%r13
 1078106:	jmp    107810b <check_input_run+0xad7b>
 1078108:	xor    %r11d,%r11d
 107810b:	mov    0x54(%rsi,%rcx,1),%r12d
 1078110:	cmp    %r10,%r15
 1078113:	ja     10780b8 <check_input_run+0xad28>
 1078115:	mov    %r14,%rbx
 1078118:	mov    %rbp,%r14
 107811b:	lea    0x4(,%r12,4),%rbp
 1078123:	cmp    %r13,%rbp
 1078126:	ja     1078144 <check_input_run+0xadb4>
 1078128:	mov    0x860(%rsp),%r9
 1078130:	add    %r15,%rbp
 1078133:	mov    %rbp,0x2ac40(%r9)
 107813a:	mov    %rbp,%r9
 107813d:	mov    0x54(%rsi,%rcx,1),%r12d
 1078142:	jmp    1078146 <check_input_run+0xadb6>
 1078144:	xor    %edi,%edi
 1078146:	mov    %r14,%rbp
 1078149:	mov    %rbx,%r14
 107814c:	mov    0xc0(%rsp),%rbx
 1078154:	sub    %r9,%r10
 1078157:	jb     1078180 <check_input_run+0xadf0>
 1078159:	mov    $0x0,%r15d
 107815f:	cmp    %r12,%r10
 1078162:	jbe    1078183 <check_input_run+0xadf3>
 1078164:	mov    0x860(%rsp),%r10
 107816c:	add    %r9,%r8
 107816f:	lea    0x1(%r12,%r9,1),%r9
 1078174:	mov    %r8,%r15
 1078177:	mov    %r9,0x2ac40(%r10)
 107817e:	jmp    1078183 <check_input_run+0xadf3>
 1078180:	xor    %r15d,%r15d
 1078183:	mov    0x860(%rsp),%r12
 107818b:	mov    0x70(%rsp),%r10
 1078190:	add    %rcx,%rsi
 1078193:	mov    0x58(%r12),%r8d
 1078198:	mov    0xb0(%r12),%r9d
 10781a0:	mov    %rsi,-0x28(%rax)
 10781a4:	mov    %r10,-0x20(%rax)
 10781a8:	mov    %r8d,-0x18(%rax)
 10781ac:	mov    %r9d,-0x14(%rax)
 10781b0:	mov    %r11,-0x10(%rax)
 10781b4:	mov    %rdi,-0x8(%rax)
 10781b8:	mov    %r15,(%rax)
 10781bb:	test   %r11,%r11
 10781be:	je     10795d6 <check_input_run+0xc246>
 10781c4:	test   %rdi,%rdi
 10781c7:	setne  %dil
 10781cb:	test   %r15,%r15
 10781ce:	setne  %sil
 10781d2:	and    %dil,%sil
 10781d5:	cmp    $0x1,%sil
 10781d9:	jne    10781f3 <check_input_run+0xae63>
 10781db:	add    $0x30,%rax
 10781df:	add    $0x150,%rcx
 10781e6:	cmp    %r14,%rdx
 10781e9:	lea    0x1(%rdx),%rdx
 10781ed:	jb     107807e <check_input_run+0xacee>
 10781f3:	mov    0x2ac40(%r12),%r13
 10781fb:	test   %sil,%sil
 10781fe:	je     10795e3 <check_input_run+0xc253>
 1078204:	mov    0xe8(%rsp),%r9
 107820c:	mov    0x70(%rsp),%r10
 1078211:	mov    %r14d,%eax
 1078214:	inc    %eax
 1078216:	mov    %eax,0x100(%rsp)
 107821d:	je     107824b <check_input_run+0xaebb>
 107821f:	mov    0x8(%r12),%rax
 1078224:	cmpq   $0x0,0x108(%rax)
 107822c:	mov    %rax,0xa0(%rsp)
 1078234:	jne    107824b <check_input_run+0xaebb>
 1078236:	mov    0xa0(%rsp),%rax
 107823e:	cmpl   $0x0,0x114(%rax)
 1078245:	je     107a277 <check_input_run+0xcee7>
 107824b:	mov    %rbp,%r15
 107824e:	xor    %edx,%edx
 1078250:	mov    0x860(%rsp),%r12
 1078258:	cmp    0x2ac40(%r12),%r13
 1078260:	ja     107a8df <check_input_run+0xd54f>
 1078266:	mov    %r13,0x2ac40(%r12)
 107826e:	mov    %r15,%rbp
 1078271:	test   %dl,%dl
 1078273:	je     107829d <check_input_run+0xaf0d>
 1078275:	movzbl 0x2aca1(%r12),%eax
 107827e:	xor    $0x1,%al
 1078280:	jmp    107829f <check_input_run+0xaf0f>
 1078282:	mov    0x2ac40(%r12),%r13
 107828a:	mov    0xe8(%rsp),%r9
 1078292:	mov    %r11,%r10
 1078295:	test   %r14,%r14
 1078298:	setne  0x58(%rsp)
 107829d:	xor    %eax,%eax
 107829f:	mov    0x2ac38(%r12),%rdi
 10782a7:	shl    $0x2,%rbx
 10782ab:	lea    0x3(%r13,%rdi,1),%rcx
 10782b0:	lea    0x0(%r13,%rdi,1),%rdx
 10782b5:	and    $0xfffffffffffffffc,%rcx
 10782b9:	cmp    %rdx,%rcx
 10782bc:	jae    10782c2 <check_input_run+0xaf32>
 10782be:	xor    %esi,%esi
 10782c0:	jmp    10782ed <check_input_run+0xaf5d>
 10782c2:	mov    0x2ac48(%r12),%r8
 10782ca:	mov    %rcx,%rdx
 10782cd:	sub    %rdi,%rdx
 10782d0:	xor    %esi,%esi
 10782d2:	sub    %rdx,%r8
 10782d5:	jb     10782ed <check_input_run+0xaf5d>
 10782d7:	cmp    %r8,%rbx
 10782da:	ja     10782ed <check_input_run+0xaf5d>
 10782dc:	add    %rbx,%rdx
 10782df:	mov    %rcx,%rsi
 10782e2:	mov    %rdx,%r13
 10782e5:	mov    %rdx,0x2ac40(%r12)
 10782ed:	test   %rsi,%rsi
 10782f0:	sete   %cl
 10782f3:	xor    $0x1,%al
 10782f5:	or     %cl,%al
 10782f7:	jne    107830e <check_input_run+0xaf7e>
 10782f9:	lea    0x3(%r13,%rdi,1),%rax
 10782fe:	add    %rdi,%r13
 1078301:	and    $0xfffffffffffffffc,%rax
 1078305:	cmp    %r13,%rax
 1078308:	jae    107849c <check_input_run+0xb10c>
 107830e:	mov    0x860(%rsp),%rax
 1078316:	mov    0x20(%rsp),%r12
 107831b:	mov    0x90(%rsp),%rbx
 1078323:	mov    0x48(%rsp),%r14
 1078328:	cmpb   $0x1,0x2ac90(%rax)
 107832f:	jne    1078374 <check_input_run+0xafe4>
 1078331:	lea    0x780(%rsp),%rsi
 1078339:	mov    $0x1,%edi
 107833e:	vpxor  %xmm0,%xmm0,%xmm0
 1078342:	vmovdqa %xmm0,0x780(%rsp)
 107834b:	vzeroupper
 107834e:	call   787bc0 <clock_gettime@plt>
 1078353:	imul   $0x3b9aca00,0x780(%rsp),%rax
 107835f:	mov    0x130(%rsp),%rdx
 1078367:	add    0x788(%rsp),%rdx
 107836f:	add    %rax,%rdx
 1078372:	jmp    1078376 <check_input_run+0xafe6>
 1078374:	xor    %edx,%edx
 1078376:	mov    0x860(%rsp),%rax
 107837e:	mov    0xd0(%rsp),%ecx
 1078385:	mov    0x210(%rsp),%esi
 107838c:	mov    %rdx,0x2acc8(%rax)
 1078393:	test   %sil,%cl
 1078396:	je     10783a1 <check_input_run+0xb011>
 1078398:	lea    -0x96fc7d(%rip),%rax        # 708722 <pp_decode_file_name.meaning+0xc734>
 107839f:	jmp    10783a4 <check_input_run+0xb014>
 10783a1:	mov    (%r14),%rax
 10783a4:	mov    0x860(%rsp),%rcx
 10783ac:	mov    %rax,0x2ac60(%rcx)
 10783b3:	or     %sil,0x2ac58(%rcx)
 10783ba:	or     %sil,0x3c5(%rbx)
 10783c1:	mov    0x2b8(%rsp),%rax
 10783c9:	mov    %rax,0xa0(%rsp)
 10783d1:	mov    0x18(%rsp),%rax
 10783d6:	mov    0x38(%rsp),%rcx
 10783db:	cmpl   $0x0,0x230(%rax)
 10783e2:	jne    1072eba <check_input_run+0x5b2a>
 10783e8:	cmpb   $0x0,0x3c5(%rax)
 10783ef:	jne    1072eba <check_input_run+0x5b2a>
 10783f5:	mov    0x2a8(%rsp),%r15
 10783fd:	mov    0x2c8(%rsp),%rax
 1078405:	mov    $0x1,%edx
 107840a:	mov    0x30(%r15),%r13d
 107840e:	mov    0x8(%rax),%r8
 1078412:	lea    0x0(%r13,%r13,1),%rcx
 1078417:	mov    %rdx,%rbp
 107841a:	add    %rdx,%rdx
 107841d:	cmp    %rcx,%rbp
 1078420:	jbe    1078417 <check_input_run+0xb087>
 1078422:	mov    %rbp,%rcx
 1078425:	shr    $0x3e,%rcx
 1078429:	jne    107846d <check_input_run+0xb0dd>
 107842b:	mov    (%rax),%rsi
 107842e:	lea    0x3(%r8,%rsi,1),%rbx
 1078433:	lea    (%r8,%rsi,1),%rcx
 1078437:	and    $0xfffffffffffffffc,%rbx
 107843b:	cmp    %rcx,%rbx
 107843e:	jb     107846d <check_input_run+0xb0dd>
 1078440:	mov    %rbx,%rcx
 1078443:	sub    %rsi,%rcx
 1078446:	mov    0x10(%rax),%rsi
 107844a:	lea    0x0(,%rbp,4),%rdx
 1078452:	sub    %rcx,%rsi
 1078455:	setb   %dil
 1078459:	cmp    %rsi,%rdx
 107845c:	seta   %sil
 1078460:	or     %dil,%sil
 1078463:	cmp    $0x1,%sil
 1078467:	jne    10789be <check_input_run+0xb62e>
 107846d:	mov    0x2a0(%rsp),%rax
 1078475:	movb   $0x1,0x3c5(%rax)
 107847c:	mov    0x2c8(%rsp),%rax
 1078484:	cmp    0x8(%rax),%r8
 1078488:	ja     107a8df <check_input_run+0xd54f>
 107848e:	mov    0x38(%rsp),%rcx
 1078493:	mov    %r8,0x8(%rax)
 1078497:	jmp    1072eba <check_input_run+0x5b2a>
 107849c:	mov    0x2ac48(%r12),%r8
 10784a4:	mov    %rax,%r13
 10784a7:	sub    %rdi,%rax
 10784aa:	mov    %r8,%rcx
 10784ad:	sub    %rax,%rcx
 10784b0:	jb     107830e <check_input_run+0xaf7e>
 10784b6:	mov    %r9,0xe8(%rsp)
 10784be:	mov    0x360(%rbp),%r9d
 10784c5:	lea    0x4(,%r9,4),%r11
 10784cd:	cmp    %rcx,%r11
 10784d0:	ja     107830e <check_input_run+0xaf7e>
 10784d6:	mov    0x348(%rbp),%ecx
 10784dc:	mov    0x328(%rbp),%r15d
 10784e3:	mov    0x338(%rbp),%edx
 10784e9:	add    %r11,%rax
 10784ec:	mov    %rcx,0x70(%rsp)
 10784f1:	mov    0x4e0(%rsp),%ecx
 10784f8:	mov    %rcx,0xc0(%rsp)
 1078500:	mov    0x2e0(%rsp),%ecx
 1078507:	mov    %rcx,0xa0(%rsp)
 107850f:	mov    0x468(%rsp),%ecx
 1078516:	mov    %rax,0x2ac40(%r12)
 107851e:	mov    %rcx,0x100(%rsp)
 1078526:	test   %r13,%r13
 1078529:	je     107830e <check_input_run+0xaf7e>
 107852f:	add    %r13,%r11
 1078532:	mov    %rdx,0xd8(%rsp)
 107853a:	mov    %r8,%rdx
 107853d:	mov    %r11,%rax
 1078540:	sub    %rdi,%rax
 1078543:	sub    %rax,%rdx
 1078546:	jb     107830e <check_input_run+0xaf7e>
 107854c:	lea    0x4(,%r15,4),%rcx
 1078554:	cmp    %rdx,%rcx
 1078557:	ja     107830e <check_input_run+0xaf7e>
 107855d:	add    %rcx,%rax
 1078560:	mov    %rax,0x2ac40(%r12)
 1078568:	test   %r11,%r11
 107856b:	je     107830e <check_input_run+0xaf7e>
 1078571:	add    %r11,%rcx
 1078574:	mov    %r8,%rdx
 1078577:	mov    %r15,0x98(%rsp)
 107857f:	mov    %r10,0x50(%rsp)
 1078584:	mov    %r9,0x68(%rsp)
 1078589:	mov    %r14,0x60(%rsp)
 107858e:	mov    %rbp,0xb8(%rsp)
 1078596:	mov    %r11,0x110(%rsp)
 107859e:	mov    %rcx,%rax
 10785a1:	sub    %rdi,%rax
 10785a4:	mov    %rcx,0x88(%rsp)
 10785ac:	sub    %rax,%rdx
 10785af:	jb     107830e <check_input_run+0xaf7e>
 10785b5:	mov    0xd8(%rsp),%r9
 10785bd:	lea    0x4(,%r9,4),%r9
 10785c5:	cmp    %rdx,%r9
 10785c8:	ja     107830e <check_input_run+0xaf7e>
 10785ce:	add    %r9,%rax
 10785d1:	mov    0x860(%rsp),%rdx
 10785d9:	cmpq   $0x0,0x88(%rsp)
 10785e2:	mov    %rax,0x2ac40(%rdx)
 10785e9:	je     107830e <check_input_run+0xaf7e>
 10785ef:	mov    %r9,%rax
 10785f2:	add    0x88(%rsp),%rax
 10785fa:	mov    %r8,%rdx
 10785fd:	mov    %rax,0x150(%rsp)
 1078605:	sub    %rdi,%rax
 1078608:	sub    %rax,%rdx
 107860b:	jb     107830e <check_input_run+0xaf7e>
 1078611:	mov    0x70(%rsp),%r9
 1078616:	lea    0x4(,%r9,4),%r9
 107861e:	cmp    %rdx,%r9
 1078621:	ja     107830e <check_input_run+0xaf7e>
 1078627:	add    %r9,%rax
 107862a:	mov    0x860(%rsp),%rdx
 1078632:	cmpq   $0x0,0x150(%rsp)
 107863b:	mov    %r9,%rcx
 107863e:	mov    %rax,0x2ac40(%rdx)
 1078645:	je     107830e <check_input_run+0xaf7e>
 107864b:	add    0x150(%rsp),%rcx
 1078653:	mov    %rcx,%rax
 1078656:	and    $0xfffffffffffffffc,%rax
 107865a:	mov    %rcx,0x118(%rsp)
 1078662:	cmp    %rcx,%rax
 1078665:	jne    107830e <check_input_run+0xaf7e>
 107866b:	sub    %rdi,%rax
 107866e:	mov    %r8,%rdx
 1078671:	sub    %rax,%rdx
 1078674:	jb     107830e <check_input_run+0xaf7e>
 107867a:	mov    0xc0(%rsp),%r9
 1078682:	lea    0x4(,%r9,4),%r9
 107868a:	cmp    %rdx,%r9
 107868d:	ja     107830e <check_input_run+0xaf7e>
 1078693:	add    %r9,%rax
 1078696:	mov    0x860(%rsp),%rdx
 107869e:	cmpq   $0x0,0x118(%rsp)
 10786a7:	mov    %r9,%rcx
 10786aa:	mov    %rax,0x2ac40(%rdx)
 10786b1:	je     107830e <check_input_run+0xaf7e>
 10786b7:	mov    %rcx,%rdx
 10786ba:	add    0x118(%rsp),%rdx
 10786c2:	mov    %r8,%r9
 10786c5:	mov    %rdx,0x148(%rsp)
 10786cd:	sub    %rdi,%rdx
 10786d0:	sub    %rdx,%r9
 10786d3:	jb     107830e <check_input_run+0xaf7e>
 10786d9:	mov    0x100(%rsp),%rax
 10786e1:	lea    0x4(,%rax,4),%rax
 10786e9:	cmp    %r9,%rax
 10786ec:	ja     107830e <check_input_run+0xaf7e>
 10786f2:	add    %rax,%rdx
 10786f5:	mov    0x860(%rsp),%r9
 10786fd:	cmpq   $0x0,0x148(%rsp)
 1078706:	mov    %rdx,0x2ac40(%r9)
 107870d:	je     107830e <check_input_run+0xaf7e>
 1078713:	add    0x148(%rsp),%rax
 107871b:	mov    %r8,%r9
 107871e:	mov    %rax,%rdx
 1078721:	sub    %rdi,%rdx
 1078724:	sub    %rdx,%r9
 1078727:	jb     107830e <check_input_run+0xaf7e>
 107872d:	mov    0xa0(%rsp),%rcx
 1078735:	lea    0x4(,%rcx,4),%r11
 107873d:	cmp    %r9,%r11
 1078740:	ja     107830e <check_input_run+0xaf7e>
 1078746:	mov    0x860(%rsp),%r9
 107874e:	add    %r11,%rdx
 1078751:	mov    %r11,%r10
 1078754:	mov    %rdx,0x2ac40(%r9)
 107875b:	test   %rax,%rax
 107875e:	je     107830e <check_input_run+0xaf7e>
 1078764:	mov    %r10,%rdx
 1078767:	add    %rax,%rdx
 107876a:	mov    %r8,%r9
 107876d:	mov    %rdx,0x80(%rsp)
 1078775:	sub    %rdi,%rdx
 1078778:	sub    %rdx,%r9
 107877b:	jb     107830e <check_input_run+0xaf7e>
 1078781:	cmp    %r9,%rbx
 1078784:	ja     107830e <check_input_run+0xaf7e>
 107878a:	add    %rbx,%rdx
 107878d:	mov    0x860(%rsp),%r9
 1078795:	cmpq   $0x0,0x80(%rsp)
 107879e:	mov    %rdx,0x2ac40(%r9)
 10787a5:	je     107830e <check_input_run+0xaf7e>
 10787ab:	mov    0x80(%rsp),%rdx
 10787b3:	lea    (%rdx,%rbx,1),%rcx
 10787b7:	mov    %rcx,%rdx
 10787ba:	and    $0xfffffffffffffffc,%rdx
 10787be:	mov    %rcx,0xa8(%rsp)
 10787c6:	cmp    %rcx,%rdx
 10787c9:	jne    107830e <check_input_run+0xaf7e>
 10787cf:	sub    %rdi,%rdx
 10787d2:	mov    %r8,%r9
 10787d5:	sub    %rdx,%r9
 10787d8:	jb     107830e <check_input_run+0xaf7e>
 10787de:	cmp    %r9,%rbx
 10787e1:	ja     107830e <check_input_run+0xaf7e>
 10787e7:	add    %rbx,%rdx
 10787ea:	mov    0x860(%rsp),%r9
 10787f2:	cmpq   $0x0,0xa8(%rsp)
 10787fb:	mov    %rdx,0x2ac40(%r9)
 1078802:	je     107830e <check_input_run+0xaf7e>
 1078808:	mov    0xa8(%rsp),%rcx
 1078810:	mov    %r8,%r9
 1078813:	lea    (%rcx,%rbx,1),%rdx
 1078817:	mov    %rdx,0xf8(%rsp)
 107881f:	sub    %rdi,%rdx
 1078822:	sub    %rdx,%r9
 1078825:	jb     107830e <check_input_run+0xaf7e>
 107882b:	cmp    %r9,%rbx
 107882e:	ja     107830e <check_input_run+0xaf7e>
 1078834:	add    %rbx,%rdx
 1078837:	mov    0x860(%rsp),%r9
 107883f:	cmpq   $0x0,0xf8(%rsp)
 1078848:	mov    %rdx,0x2ac40(%r9)
 107884f:	je     107830e <check_input_run+0xaf7e>
 1078855:	mov    0xf8(%rsp),%rcx
 107885d:	mov    %r8,%r9
 1078860:	lea    (%rcx,%rbx,1),%rdx
 1078864:	mov    %rdx,0x1a0(%rsp)
 107886c:	sub    %rdi,%rdx
 107886f:	sub    %rdx,%r9
 1078872:	jb     107830e <check_input_run+0xaf7e>
 1078878:	cmp    %r9,%rbx
 107887b:	ja     107830e <check_input_run+0xaf7e>
 1078881:	add    %rbx,%rdx
 1078884:	mov    0x860(%rsp),%r9
 107888c:	cmpq   $0x0,0x1a0(%rsp)
 1078895:	mov    %rdx,0x2ac40(%r9)
 107889c:	je     107830e <check_input_run+0xaf7e>
 10788a2:	mov    0x1a0(%rsp),%rcx
 10788aa:	mov    %r8,%r9
 10788ad:	lea    (%rcx,%rbx,1),%rdx
 10788b1:	mov    %rdx,0x198(%rsp)
 10788b9:	sub    %rdi,%rdx
 10788bc:	sub    %rdx,%r9
 10788bf:	jb     107830e <check_input_run+0xaf7e>
 10788c5:	cmp    %r9,%rbx
 10788c8:	ja     107830e <check_input_run+0xaf7e>
 10788ce:	add    %rbx,%rdx
 10788d1:	mov    0x860(%rsp),%r9
 10788d9:	cmpq   $0x0,0x198(%rsp)
 10788e2:	mov    %rdx,0x2ac40(%r9)
 10788e9:	je     107830e <check_input_run+0xaf7e>
 10788ef:	mov    0x198(%rsp),%rcx
 10788f7:	mov    %r8,%r9
 10788fa:	lea    (%rcx,%rbx,1),%rdx
 10788fe:	mov    %rdx,0x180(%rsp)
 1078906:	sub    %rdi,%rdx
 1078909:	sub    %rdx,%r9
 107890c:	jb     107830e <check_input_run+0xaf7e>
 1078912:	cmp    %r9,%rbx
 1078915:	ja     107830e <check_input_run+0xaf7e>
 107891b:	add    %rbx,%rdx
 107891e:	mov    0x860(%rsp),%r9
 1078926:	cmpq   $0x0,0x180(%rsp)
 107892f:	mov    %rdx,0x2ac40(%r9)
 1078936:	je     107830e <check_input_run+0xaf7e>
 107893c:	mov    0x180(%rsp),%rcx
 1078944:	add    %rbx,%rcx
 1078947:	mov    %rcx,%r9
 107894a:	and    $0xfffffffffffffffc,%r9
 107894e:	mov    %rcx,0x1a8(%rsp)
 1078956:	cmp    %rcx,%r9
 1078959:	jne    107830e <check_input_run+0xaf7e>
 107895f:	sub    %rdi,%r9
 1078962:	sub    %r9,%r8
 1078965:	jb     107830e <check_input_run+0xaf7e>
 107896b:	cmp    %r8,%rbx
 107896e:	ja     107830e <check_input_run+0xaf7e>
 1078974:	add    %rbx,%r9
 1078977:	mov    0x860(%rsp),%rdi
 107897f:	cmpq   $0x0,0x1a8(%rsp)
 1078988:	mov    %r9,0x2ac40(%rdi)
 107898f:	je     107830e <check_input_run+0xaf7e>
 1078995:	cmpq   $0x0,0x60(%rsp)
 107899b:	je     107afec <check_input_run+0xdc5c>
 10789a1:	mov    0x60(%rsp),%r8
 10789a6:	mov    %r8d,%edi
 10789a9:	and    $0x7,%edi
 10789ac:	cmp    $0x8,%r8d
 10789b0:	jae    107af02 <check_input_run+0xdb72>
 10789b6:	xor    %r8d,%r8d
 10789b9:	jmp    107afb8 <check_input_run+0xdc28>
 10789be:	add    %rdx,%rcx
 10789c1:	test   %rbx,%rbx
 10789c4:	mov    %rcx,0x8(%rax)
 10789c8:	sete   %al
 10789cb:	mov    0x2a0(%rsp),%rcx
 10789d3:	or     %al,0x3c5(%rcx)
 10789d9:	test   %rbx,%rbx
 10789dc:	je     107847c <check_input_run+0xb0ec>
 10789e2:	mov    %r8,0x90(%rsp)
 10789ea:	xor    %r14d,%r14d
 10789ed:	mov    %rbx,%rdi
 10789f0:	xor    %esi,%esi
 10789f2:	vzeroupper
 10789f5:	call   788430 <memset@plt>
 10789fa:	test   %r13,%r13
 10789fd:	je     1079139 <check_input_run+0xbda9>
 1078a03:	dec    %rbp
 1078a06:	mov    $0xffffffff,%esi
 1078a0b:	xor    %edx,%edx
 1078a0d:	mov    %rbx,0x48(%rsp)
 1078a12:	jmp    1078a2a <check_input_run+0xb69a>
 1078a14:	mov    0x2e0(%rdi),%rax
 1078a1b:	mov    %esi,(%rax,%rdx,4)
 1078a1e:	inc    %rdx
 1078a21:	cmp    %r13,%rdx
 1078a24:	je     1078d94 <check_input_run+0xba04>
 1078a2a:	mov    0x2a0(%rsp),%rdi
 1078a32:	mov    0x1f0(%rdi),%rax
 1078a39:	test   %rax,%rax
 1078a3c:	je     1078a44 <check_input_run+0xb6b4>
 1078a3e:	cmpb   $0x0,(%rax,%rdx,1)
 1078a42:	jne    1078a1e <check_input_run+0xb68e>
 1078a44:	mov    0x50(%r15),%r10
 1078a48:	mov    0x10(%r15),%r8
 1078a4c:	mov    %r14d,%ecx
 1078a4f:	cmp    %rcx,%rdx
 1078a52:	mov    $0xffffffff,%ecx
 1078a57:	cmova  %ecx,%esi
 1078a5a:	movzbl (%r10,%rdx,1),%eax
 1078a5f:	cmp    $0x21,%eax
 1078a62:	je     1078a94 <check_input_run+0xb704>
 1078a64:	cmp    $0x34,%eax
 1078a67:	jne    1078a73 <check_input_run+0xb6e3>
 1078a69:	mov    0x60(%r15),%rcx
 1078a6d:	mov    %edx,%esi
 1078a6f:	mov    (%rcx,%rdx,4),%r14d
 1078a73:	movzbl (%r8,%rdx,1),%ecx
 1078a78:	cmp    $0x4f,%cl
 1078a7b:	jne    1078b79 <check_input_run+0xb7e9>
 1078a81:	mov    0x350(%rdi),%rcx
 1078a88:	cmpl   $0x0,(%rcx,%rdx,4)
 1078a8c:	jne    1078b8c <check_input_run+0xb7fc>
 1078a92:	jmp    1078a14 <check_input_run+0xb684>
 1078a94:	cmp    $0xffffffff,%esi
 1078a97:	je     1078c87 <check_input_run+0xb8f7>
 1078a9d:	mov    0x610(%rsp),%rax
 1078aa5:	mov    (%rax,%rdx,4),%eax
 1078aa8:	cmp    %r13d,%eax
 1078aab:	jae    1078c87 <check_input_run+0xb8f7>
 1078ab1:	cmpb   $0x2,(%r8,%rax,1)
 1078ab6:	jne    1078c87 <check_input_run+0xb8f7>
 1078abc:	mov    0x2e0(%rdi),%rcx
 1078ac3:	mov    %esi,%edi
 1078ac5:	mov    %esi,(%rcx,%rdx,4)
 1078ac8:	movabs $0x9e3779b97f4a7c15,%rcx
 1078ad2:	mov    0x18(%r15),%r8
 1078ad6:	mov    (%r8,%rax,4),%r9d
 1078ada:	mov    %r9,%rax
 1078add:	imul   %rcx,%rax
 1078ae1:	add    %rax,%rdi
 1078ae4:	and    %rbp,%rdi
 1078ae7:	mov    (%rbx,%rdi,4),%ecx
 1078aea:	test   %ecx,%ecx
 1078aec:	je     1078d20 <check_input_run+0xb990>
 1078af2:	mov    0x2a0(%rsp),%rax
 1078afa:	mov    0x2e0(%rax),%r10
 1078b01:	jmp    1078b14 <check_input_run+0xb784>
 1078b03:	inc    %rdi
 1078b06:	and    %rbp,%rdi
 1078b09:	mov    (%rbx,%rdi,4),%ecx
 1078b0c:	test   %ecx,%ecx
 1078b0e:	je     1078d20 <check_input_run+0xb990>
 1078b14:	dec    %ecx
 1078b16:	cmp    %esi,(%r10,%rcx,4)
 1078b1a:	jne    1078b03 <check_input_run+0xb773>
 1078b1c:	mov    0x610(%rsp),%r11
 1078b24:	mov    (%r11,%rcx,4),%ecx
 1078b28:	cmp    %r9d,(%r8,%rcx,4)
 1078b2c:	jne    1078b03 <check_input_run+0xb773>
 1078b2e:	mov    0x230(%rax),%ecx
 1078b34:	cmp    0x234(%rax),%ecx
 1078b3a:	jae    1078d0f <check_input_run+0xb97f>
 1078b40:	movzbl 0x3c5(%rax),%r8d
 1078b48:	mov    0x228(%rax),%r9
 1078b4f:	lea    0x1(%rcx),%r10d
 1078b53:	mov    %r10d,0x230(%rax)
 1078b5a:	lea    (%rcx,%rcx,2),%rax
 1078b5e:	xor    $0x5,%r8d
 1078b62:	mov    %edx,(%r9,%rax,4)
 1078b66:	mov    %r8d,0x4(%r9,%rax,4)
 1078b6b:	movl   $0x0,0x8(%r9,%rax,4)
 1078b74:	jmp    1078d16 <check_input_run+0xb986>
 1078b79:	mov    %eax,%r9d
 1078b7c:	xor    $0xf,%cl
 1078b7f:	xor    $0x9,%r9b
 1078b83:	or     %cl,%r9b
 1078b86:	je     1078a14 <check_input_run+0xb684>
 1078b8c:	cmp    $0x3a,%al
 1078b8e:	jne    1078a1e <check_input_run+0xb68e>
 1078b94:	mov    0x60(%r15),%rax
 1078b98:	mov    %r14,0x28(%rsp)
 1078b9d:	mov    (%rax,%rdx,4),%r9d
 1078ba1:	cmp    %r13d,%r9d
 1078ba4:	jae    1078c40 <check_input_run+0xb8b0>
 1078baa:	mov    (%rax,%r9,4),%r11d
 1078bae:	cmp    %r13d,%r11d
 1078bb1:	jae    1078be0 <check_input_run+0xb850>
 1078bb3:	mov    0x610(%rsp),%rcx
 1078bbb:	jmp    1078bc6 <check_input_run+0xb836>
 1078bbd:	mov    (%rax,%r14,4),%r11d
 1078bc1:	cmp    %r13d,%r11d
 1078bc4:	jae    1078be0 <check_input_run+0xb850>
 1078bc6:	mov    %r11d,%r14d
 1078bc9:	cmpb   $0x49,(%r10,%r14,1)
 1078bce:	jne    1078bbd <check_input_run+0xb82d>
 1078bd0:	mov    (%rcx,%r14,4),%r12d
 1078bd4:	cmp    %r13d,%r12d
 1078bd7:	jae    1078bbd <check_input_run+0xb82d>
 1078bd9:	cmpb   $0x49,(%r8,%r12,1)
 1078bde:	jne    1078bbd <check_input_run+0xb82d>
 1078be0:	cmp    %r13d,%r11d
 1078be3:	jae    1078c40 <check_input_run+0xb8b0>
 1078be5:	mov    0x2a8(%rsp),%rax
 1078bed:	mov    0x30(%rax),%r8d
 1078bf1:	cmp    %r8d,%r9d
 1078bf4:	jae    1078ce2 <check_input_run+0xb952>
 1078bfa:	mov    0x320(%rdi),%r10
 1078c01:	mov    %r9d,%ecx
 1078c04:	jmp    1078c17 <check_input_run+0xb887>
 1078c06:	mov    0x60(%rax),%r14
 1078c0a:	mov    (%r14,%rcx,4),%ecx
 1078c0e:	cmp    %r8d,%ecx
 1078c11:	jae    1078ce2 <check_input_run+0xb952>
 1078c17:	mov    %ecx,%ecx
 1078c19:	mov    (%r10,%rcx,4),%r12d
 1078c1d:	test   %r12d,%r12d
 1078c20:	je     1078c06 <check_input_run+0xb876>
 1078c22:	mov    0x318(%rdi),%r14
 1078c29:	dec    %r12d
 1078c2c:	lea    (%r12,%r12,2),%r12
 1078c30:	cmp    (%r14,%r12,8),%r11d
 1078c34:	jbe    1078c40 <check_input_run+0xb8b0>
 1078c36:	lea    (%r14,%r12,8),%r14
 1078c3a:	cmp    0x4(%r14),%r11d
 1078c3e:	jb     1078c06 <check_input_run+0xb876>
 1078c40:	mov    0x230(%rdi),%eax
 1078c46:	cmp    0x234(%rdi),%eax
 1078c4c:	jae    1078cd9 <check_input_run+0xb949>
 1078c52:	movzbl 0x3c5(%rdi),%ecx
 1078c59:	mov    0x228(%rdi),%r8
 1078c60:	lea    0x1(%rax),%r9d
 1078c64:	lea    (%rax,%rax,2),%rax
 1078c68:	mov    %r9d,0x230(%rdi)
 1078c6f:	lea    0x1(%rcx,%rcx,2),%ecx
 1078c73:	mov    %edx,(%r8,%rax,4)
 1078c77:	mov    %ecx,0x4(%r8,%rax,4)
 1078c7c:	movl   $0x0,0x8(%r8,%rax,4)
 1078c85:	jmp    1078d00 <check_input_run+0xb970>
 1078c87:	mov    0x230(%rdi),%eax
 1078c8d:	cmp    0x234(%rdi),%eax
 1078c93:	jae    1078ccd <check_input_run+0xb93d>
 1078c95:	movzbl 0x3c5(%rdi),%ecx
 1078c9c:	mov    0x228(%rdi),%r8
 1078ca3:	lea    0x1(%rax),%r9d
 1078ca7:	lea    (%rax,%rax,2),%rax
 1078cab:	mov    %r9d,0x230(%rdi)
 1078cb2:	lea    0x1(%rcx,%rcx,2),%ecx
 1078cb6:	mov    %edx,(%r8,%rax,4)
 1078cba:	mov    %ecx,0x4(%r8,%rax,4)
 1078cbf:	movl   $0x0,0x8(%r8,%rax,4)
 1078cc8:	jmp    1078a1e <check_input_run+0xb68e>
 1078ccd:	movb   $0x1,0x3c5(%rdi)
 1078cd4:	jmp    1078a1e <check_input_run+0xb68e>
 1078cd9:	movb   $0x1,0x3c5(%rdi)
 1078ce0:	jmp    1078d00 <check_input_run+0xb970>
 1078ce2:	mov    0x2f8(%rdi),%rax
 1078ce9:	mov    %r11d,(%rax,%rdx,4)
 1078ced:	mov    0x2a0(%rsp),%rax
 1078cf5:	mov    0x2f8(%rax),%rax
 1078cfc:	mov    %r11d,(%rax,%r9,4)
 1078d00:	mov    0x20(%rsp),%r12
 1078d05:	mov    0x28(%rsp),%r14
 1078d0a:	jmp    1078a1e <check_input_run+0xb68e>
 1078d0f:	movb   $0x1,0x3c5(%rax)
 1078d16:	mov    0x20(%rsp),%r12
 1078d1b:	mov    0x48(%rsp),%rbx
 1078d20:	lea    0x1(%rdx),%eax
 1078d23:	mov    %eax,(%rbx,%rdi,4)
 1078d26:	jmp    1078a1e <check_input_run+0xb68e>
 1078d2b:	mov    (%r12),%ecx
 1078d2f:	xor    %eax,%eax
 1078d31:	dec    %ecx
 1078d33:	cmp    $0x40,%ecx
 1078d36:	lea    -0x9d1622(%rip),%rcx        # 6a771b <pp_string_value.meaning+0x1ef1a>
 1078d3d:	setb   %bpl
 1078d41:	cmovae %rcx,%rax
 1078d45:	jmp    1076b72 <check_input_run+0x97e2>
 1078d4a:	mov    0x18(%rsp),%rdi
 1078d4f:	mov    0x10(%rsp),%rsi
 1078d54:	movq   $0x0,0x240(%rdi)
 1078d5f:	movq   $0x0,0x248(%rdi)
 1078d6a:	movq   $0x0,0x260(%rdi)
 1078d75:	jmp    106dbd6 <check_input_run+0x846>
 1078d7a:	inc    %rdx
 1078d7d:	add    %rsi,%rdx
 1078d80:	mov    %rdx,0x8(%rcx)
 1078d84:	mov    %rax,0x210(%rsp)
 1078d8c:	mov    %r11,%r8
 1078d8f:	jmp    107509d <check_input_run+0x7d0d>
 1078d94:	xor    %ecx,%ecx
 1078d96:	jmp    1078dab <check_input_run+0xba1b>
 1078d98:	movb   $0x1,0x3c5(%rdi)
 1078d9f:	inc    %rcx
 1078da2:	cmp    %r13,%rcx
 1078da5:	je     1079139 <check_input_run+0xbda9>
 1078dab:	mov    0x2a0(%rsp),%rdi
 1078db3:	mov    0x1f0(%rdi),%rax
 1078dba:	test   %rax,%rax
 1078dbd:	je     1078dc5 <check_input_run+0xba35>
 1078dbf:	cmpb   $0x0,(%rax,%rcx,1)
 1078dc3:	jne    1078d9f <check_input_run+0xba0f>
 1078dc5:	mov    0x10(%r15),%r11
 1078dc9:	movzbl (%r11,%rcx,1),%eax
 1078dce:	cmp    $0xf,%eax
 1078dd1:	je     1078e3b <check_input_run+0xbaab>
 1078dd3:	cmp    $0x30,%eax
 1078dd6:	je     1078e51 <check_input_run+0xbac1>
 1078dd8:	cmp    $0x4f,%eax
 1078ddb:	jne    1078d9f <check_input_run+0xba0f>
 1078ddd:	mov    0x350(%rdi),%rax
 1078de4:	cmpl   $0x0,(%rax,%rcx,4)
 1078de8:	jne    1078d9f <check_input_run+0xba0f>
 1078dea:	mov    0x30(%r15),%edx
 1078dee:	lea    0x1(%rcx),%rax
 1078df2:	cmp    %rdx,%rax
 1078df5:	jae    1078f04 <check_input_run+0xbb74>
 1078dfb:	mov    0x60(%r15),%rdx
 1078dff:	mov    0x4(%rdx,%rcx,4),%edx
 1078e03:	cmp    %rdx,%rcx
 1078e06:	jne    1078f04 <check_input_run+0xbb74>
 1078e0c:	mov    0x50(%r15),%rdx
 1078e10:	cmpb   $0x1a,(%rdx,%rax,1)
 1078e14:	jne    1078eff <check_input_run+0xbb6f>
 1078e1a:	cmpb   $0x11,(%r11,%rax,1)
 1078e1f:	jne    1078eff <check_input_run+0xbb6f>
 1078e25:	incl   0x678(%rsp)
 1078e2c:	mov    0x20(%rsp),%r12
 1078e31:	mov    0x48(%rsp),%rbx
 1078e36:	jmp    1078d9f <check_input_run+0xba0f>
 1078e3b:	mov    0x50(%r15),%rax
 1078e3f:	mov    $0x1,%sil
 1078e42:	cmpb   $0x9,(%rax,%rcx,1)
 1078e46:	jne    1078d9f <check_input_run+0xba0f>
 1078e4c:	jmp    1078f06 <check_input_run+0xbb76>
 1078e51:	mov    0x288(%rdi),%rax
 1078e58:	cmpq   $0x0,(%rax,%rcx,8)
 1078e5d:	je     1078d9f <check_input_run+0xba0f>
 1078e63:	mov    0x60(%r15),%rax
 1078e67:	mov    (%rax,%rcx,4),%r8d
 1078e6b:	cmp    %r13d,%r8d
 1078e6e:	jae    1078eb8 <check_input_run+0xbb28>
 1078e70:	mov    0x610(%rsp),%rdx
 1078e78:	mov    0x50(%r15),%rsi
 1078e7c:	jmp    1078e87 <check_input_run+0xbaf7>
 1078e7e:	mov    (%rax,%r8,4),%r8d
 1078e82:	cmp    %r13d,%r8d
 1078e85:	jae    1078eb8 <check_input_run+0xbb28>
 1078e87:	mov    %r8d,%r8d
 1078e8a:	cmpb   $0x49,(%rsi,%r8,1)
 1078e8f:	jne    1078e7e <check_input_run+0xbaee>
 1078e91:	mov    (%rdx,%r8,4),%r9d
 1078e95:	cmp    %r13d,%r9d
 1078e98:	jae    1078e7e <check_input_run+0xbaee>
 1078e9a:	movzbl (%r11,%r9,1),%r9d
 1078e9f:	mov    (%rax,%r8,4),%r8d
 1078ea3:	cmp    %r13d,%r8d
 1078ea6:	jae    1078eae <check_input_run+0xbb1e>
 1078ea8:	cmp    $0x49,%r9b
 1078eac:	jne    1078e87 <check_input_run+0xbaf7>
 1078eae:	cmp    $0x49,%r9b
 1078eb2:	je     1078d9f <check_input_run+0xba0f>
 1078eb8:	mov    0x230(%rdi),%eax
 1078ebe:	cmp    0x234(%rdi),%eax
 1078ec4:	jae    1078d98 <check_input_run+0xba08>
 1078eca:	movzbl 0x3c5(%rdi),%edx
 1078ed1:	mov    0x228(%rdi),%rsi
 1078ed8:	lea    0x1(%rax),%r8d
 1078edc:	lea    (%rax,%rax,2),%rax
 1078ee0:	mov    %r8d,0x230(%rdi)
 1078ee7:	lea    0x1(%rdx,%rdx,2),%edx
 1078eeb:	mov    %ecx,(%rsi,%rax,4)
 1078eee:	mov    %edx,0x4(%rsi,%rax,4)
 1078ef2:	movl   $0x0,0x8(%rsi,%rax,4)
 1078efa:	jmp    1078d9f <check_input_run+0xba0f>
 1078eff:	mov    0x48(%rsp),%rbx
 1078f04:	xor    %esi,%esi
 1078f06:	mov    0x2e0(%rdi),%r12
 1078f0d:	mov    0x610(%rsp),%rax
 1078f15:	mov    $0xffffffff,%edx
 1078f1a:	xor    %r10d,%r10d
 1078f1d:	mov    (%r12,%rcx,4),%r9d
 1078f21:	mov    (%rax,%rcx,4),%r8d
 1078f25:	cmp    %rdx,%r9
 1078f28:	je     1079091 <check_input_run+0xbd01>
 1078f2e:	cmp    %r13d,%r8d
 1078f31:	jae    1079091 <check_input_run+0xbd01>
 1078f37:	cmpb   $0x2,(%r11,%r8,1)
 1078f3c:	jne    1078ff3 <check_input_run+0xbc63>
 1078f42:	mov    0x18(%r15),%rdx
 1078f46:	mov    %esi,0x28(%rsp)
 1078f4a:	movabs $0x9e3779b97f4a7c15,%rsi
 1078f54:	mov    (%rdx,%r8,4),%edx
 1078f58:	mov    %rdx,%r10
 1078f5b:	imul   %rsi,%r10
 1078f5f:	add    %r9,%r10
 1078f62:	and    %rbp,%r10
 1078f65:	mov    (%rbx,%r10,4),%r11d
 1078f69:	test   %r11d,%r11d
 1078f6c:	je     1078ffb <check_input_run+0xbc6b>
 1078f72:	mov    0x2a8(%rsp),%rsi
 1078f7a:	jmp    1078f90 <check_input_run+0xbc00>
 1078f7c:	mov    0x48(%rsp),%rbx
 1078f81:	inc    %r10
 1078f84:	and    %rbp,%r10
 1078f87:	mov    (%rbx,%r10,4),%r11d
 1078f8b:	test   %r11d,%r11d
 1078f8e:	je     1078ffb <check_input_run+0xbc6b>
 1078f90:	dec    %r11d
 1078f93:	cmp    %r9d,(%r12,%r11,4)
 1078f97:	jne    1078f7c <check_input_run+0xbbec>
 1078f99:	mov    %r8,%rbx
 1078f9c:	mov    (%rax,%r11,4),%r14d
 1078fa0:	mov    0x18(%rsi),%r8
 1078fa4:	cmp    %edx,(%r8,%r14,4)
 1078fa8:	mov    %rbx,%r8
 1078fab:	jne    1078f7c <check_input_run+0xbbec>
 1078fad:	mov    0x300(%rdi),%rax
 1078fb4:	movzbl 0x28(%rsp),%edx
 1078fb9:	mov    $0x1,%r10b
 1078fbc:	mov    %r11d,(%rax,%rcx,4)
 1078fc0:	mov    0x2a0(%rsp),%rax
 1078fc8:	add    %edx,0x308(%rax)
 1078fce:	test   %dl,%dl
 1078fd0:	jne    1079085 <check_input_run+0xbcf5>
 1078fd6:	mov    0x2a8(%rsp),%rdx
 1078fde:	mov    0x30(%rdx),%edi
 1078fe1:	cmp    %edi,%r11d
 1078fe4:	jae    1079085 <check_input_run+0xbcf5>
 1078fea:	mov    0x320(%rax),%r12
 1078ff1:	jmp    1079014 <check_input_run+0xbc84>
 1078ff3:	xor    %r10d,%r10d
 1078ff6:	jmp    1079091 <check_input_run+0xbd01>
 1078ffb:	mov    0x28(%rsp),%esi
 1078fff:	xor    %r10d,%r10d
 1079002:	jmp    1079091 <check_input_run+0xbd01>
 1079007:	mov    0x60(%rdx),%r8
 107900b:	mov    (%r8,%rsi,4),%r11d
 107900f:	cmp    %edi,%r11d
 1079012:	jae    1079085 <check_input_run+0xbcf5>
 1079014:	mov    %r11d,%esi
 1079017:	mov    (%r12,%rsi,4),%r14d
 107901b:	test   %r14d,%r14d
 107901e:	je     1079007 <check_input_run+0xbc77>
 1079020:	mov    0x318(%rax),%r11
 1079027:	dec    %r14d
 107902a:	lea    (%r14,%r14,2),%r14
 107902e:	cmp    %ecx,(%r11,%r14,8)
 1079032:	jae    107903e <check_input_run+0xbcae>
 1079034:	lea    (%r11,%r14,8),%r8
 1079038:	cmp    %ecx,0x4(%r8)
 107903c:	ja     1079007 <check_input_run+0xbc77>
 107903e:	mov    0x230(%rax),%edx
 1079044:	cmp    0x234(%rax),%edx
 107904a:	jae    107907e <check_input_run+0xbcee>
 107904c:	movzbl 0x3c5(%rax),%esi
 1079053:	mov    0x228(%rax),%rdi
 107905a:	lea    0x1(%rdx),%r8d
 107905e:	mov    %r8d,0x230(%rax)
 1079065:	lea    (%rdx,%rdx,2),%rax
 1079069:	lea    0x1(%rsi,%rsi,2),%esi
 107906d:	mov    %ecx,(%rdi,%rax,4)
 1079070:	mov    %esi,0x4(%rdi,%rax,4)
 1079074:	movl   $0x0,0x8(%rdi,%rax,4)
 107907c:	jmp    1079085 <check_input_run+0xbcf5>
 107907e:	movb   $0x1,0x3c5(%rax)
 1079085:	mov    %rbx,%r8
 1079088:	mov    0x28(%rsp),%esi
 107908c:	mov    0x48(%rsp),%rbx
 1079091:	cmp    %r13d,%r9d
 1079094:	jae    10790ba <check_input_run+0xbd2a>
 1079096:	mov    0x50(%r15),%rax
 107909a:	mov    0x20(%rsp),%r12
 107909f:	cmpb   $0x34,(%rax,%r9,1)
 10790a4:	jne    10790bf <check_input_run+0xbd2f>
 10790a6:	mov    0x60(%r15),%rax
 10790aa:	mov    (%rax,%r9,4),%eax
 10790ae:	cmp    0x674(%rsp),%eax
 10790b5:	setae  %al
 10790b8:	jmp    10790c1 <check_input_run+0xbd31>
 10790ba:	mov    0x20(%rsp),%r12
 10790bf:	xor    %eax,%eax
 10790c1:	or     %al,%r10b
 10790c4:	test   $0x1,%r10b
 10790c8:	jne    1078d9f <check_input_run+0xba0f>
 10790ce:	mov    0x2a0(%rsp),%rax
 10790d6:	mov    0x230(%rax),%edx
 10790dc:	cmp    0x234(%rax),%edx
 10790e2:	jae    107912d <check_input_run+0xbd9d>
 10790e4:	cmp    %r13d,%r8d
 10790e7:	mov    %esi,%edi
 10790e9:	mov    %ecx,%esi
 10790eb:	lea    0x1(%rdx),%r9d
 10790ef:	cmovb  %r8d,%esi
 10790f3:	test   %dil,%dil
 10790f6:	movzbl 0x3c5(%rax),%edi
 10790fd:	mov    0x228(%rax),%r8
 1079104:	mov    %r9d,0x230(%rax)
 107910b:	lea    (%rdx,%rdx,2),%rax
 107910f:	cmove  %ecx,%esi
 1079112:	lea    0x2(%rdi,%rdi,1),%edi
 1079116:	mov    %esi,(%r8,%rax,4)
 107911a:	mov    %edi,0x4(%r8,%rax,4)
 107911f:	movl   $0x0,0x8(%r8,%rax,4)
 1079128:	jmp    1078d9f <check_input_run+0xba0f>
 107912d:	movb   $0x1,0x3c5(%rax)
 1079134:	jmp    1078d9f <check_input_run+0xba0f>
 1079139:	cmpl   $0x0,0x678(%rsp)
 1079141:	mov    0x90(%rsp),%r8
 1079149:	je     107847c <check_input_run+0xb0ec>
 107914f:	mov    0x2a8(%rsp),%rax
 1079157:	mov    0x30(%rax),%ecx
 107915a:	test   %ecx,%ecx
 107915c:	je     107847c <check_input_run+0xb0ec>
 1079162:	xor    %r10d,%r10d
 1079165:	jmp    107917e <check_input_run+0xbdee>
 1079167:	mov    0x90(%rsp),%r8
 107916f:	mov    %ebp,%r10d
 1079172:	inc    %r10d
 1079175:	cmp    %ecx,%r10d
 1079178:	jae    107847c <check_input_run+0xb0ec>
 107917e:	mov    0x2a0(%rsp),%r9
 1079186:	mov    %r10d,%edx
 1079189:	mov    0x1f0(%r9),%rsi
 1079190:	test   %rsi,%rsi
 1079193:	je     107919b <check_input_run+0xbe0b>
 1079195:	cmpb   $0x0,(%rsi,%rdx,1)
 1079199:	jne    1079172 <check_input_run+0xbde2>
 107919b:	mov    0x50(%rax),%r15
 107919f:	mov    0x60(%rax),%r11
 10791a3:	cmpb   $0x34,(%r15,%rdx,1)
 10791a8:	lea    (%r11,%rdx,4),%rsi
 10791ac:	jne    1079172 <check_input_run+0xbde2>
 10791ae:	mov    (%rsi),%ebp
 10791b0:	cmp    %ecx,%ebp
 10791b2:	jae    1079172 <check_input_run+0xbde2>
 10791b4:	cmp    0x674(%rsp),%ebp
 10791bb:	jae    1079172 <check_input_run+0xbde2>
 10791bd:	lea    0x1(%r10),%esi
 10791c1:	cmp    %ebp,%esi
 10791c3:	jae    107916f <check_input_run+0xbddf>
 10791c5:	mov    $0xffffffff,%r8d
 10791cb:	mov    $0xffffffff,%edi
 10791d0:	mov    %esi,%r12d
 10791d3:	xor    %esi,%esi
 10791d5:	movl   $0x0,0x48(%rsp)
 10791dd:	mov    %rbp,0x28(%rsp)
 10791e2:	jmp    1079202 <check_input_run+0xbe72>
 10791e4:	mov    0x28(%rsp),%rbp
 10791e9:	cmp    $0xffffffff,%r8d
 10791ed:	je     1079275 <check_input_run+0xbee5>
 10791f3:	mov    %r12d,%r10d
 10791f6:	inc    %r12
 10791f9:	cmp    %r12d,%ebp
 10791fc:	je     10792de <check_input_run+0xbf4e>
 1079202:	cmpb   $0x9,(%r15,%r12,1)
 1079207:	jne    10791e9 <check_input_run+0xbe59>
 1079209:	mov    0x10(%rax),%r14
 107920d:	cmpb   $0xf,(%r14,%r12,1)
 1079212:	jne    10791e9 <check_input_run+0xbe59>
 1079214:	mov    0x300(%r9),%r14
 107921b:	mov    0x48(%rsp),%edx
 107921f:	mov    (%r14,%r12,4),%ebp
 1079223:	cmp    $0xffffffff,%ebp
 1079226:	setne  %r14b
 107922a:	or     %r14b,%dl
 107922d:	mov    %edx,0x48(%rsp)
 1079231:	cmp    %ecx,%ebp
 1079233:	jae    10791e4 <check_input_run+0xbe54>
 1079235:	mov    0x320(%r9),%r13
 107923c:	jmp    1079246 <check_input_run+0xbeb6>
 107923e:	mov    (%r11,%rbp,4),%ebp
 1079242:	cmp    %ecx,%ebp
 1079244:	jae    10791e4 <check_input_run+0xbe54>
 1079246:	mov    %ebp,%ebp
 1079248:	mov    0x0(%r13,%rbp,4),%r14d
 107924d:	test   %r14d,%r14d
 1079250:	je     107923e <check_input_run+0xbeae>
 1079252:	mov    0x318(%r9),%rbx
 1079259:	dec    %r14d
 107925c:	lea    (%r14,%r14,2),%r14
 1079260:	mov    (%rbx,%r14,8),%edx
 1079264:	mov    0x4(%rbx,%r14,8),%ebx
 1079269:	cmp    %esi,%edx
 107926b:	cmova  %edx,%esi
 107926e:	cmp    %edi,%ebx
 1079270:	cmovb  %ebx,%edi
 1079273:	jmp    107923e <check_input_run+0xbeae>
 1079275:	mov    0x10(%rax),%r13
 1079279:	cmpb   $0x4f,0x0(%r13,%r12,1)
 107927f:	jne    10791f3 <check_input_run+0xbe63>
 1079285:	add    $0x2,%r10d
 1079289:	cmp    0x30(%rax),%r10d
 107928d:	jae    10791f3 <check_input_run+0xbe63>
 1079293:	mov    %r10d,%r10d
 1079296:	mov    (%r11,%r10,4),%edx
 107929a:	cmp    %rdx,%r12
 107929d:	jne    10791f3 <check_input_run+0xbe63>
 10792a3:	cmpb   $0x1a,(%r15,%r10,1)
 10792a8:	jne    10791f3 <check_input_run+0xbe63>
 10792ae:	cmpb   $0x11,0x0(%r13,%r10,1)
 10792b4:	jne    10791f3 <check_input_run+0xbe63>
 10792ba:	mov    0x350(%r9),%rdx
 10792c1:	cmpl   $0x0,(%rdx,%r12,4)
 10792c6:	jne    10791f3 <check_input_run+0xbe63>
 10792cc:	mov    %r12d,%r10d
 10792cf:	mov    %r12d,%r8d
 10792d2:	inc    %r12
 10792d5:	cmp    %r12d,%ebp
 10792d8:	jne    1079202 <check_input_run+0xbe72>
 10792de:	mov    0x48(%rsp),%r14d
 10792e3:	mov    0x20(%rsp),%r12
 10792e8:	cmp    $0xffffffff,%r8d
 10792ec:	sete   %r10b
 10792f0:	or     %r14b,%r10b
 10792f3:	test   $0x1,%r10b
 10792f7:	jne    1079347 <check_input_run+0xbfb7>
 10792f9:	mov    0x230(%r9),%r10d
 1079300:	cmp    0x234(%r9),%r10d
 1079307:	jae    107933f <check_input_run+0xbfaf>
 1079309:	movzbl 0x3c5(%r9),%edx
 1079311:	mov    0x228(%r9),%r11
 1079318:	lea    0x1(%r10),%ebx
 107931c:	mov    %ebx,0x230(%r9)
 1079323:	lea    (%r10,%r10,2),%r9
 1079327:	lea    0x1(%rdx,%rdx,2),%edx
 107932b:	mov    %r8d,(%r11,%r9,4)
 107932f:	mov    %edx,0x4(%r11,%r9,4)
 1079334:	movl   $0x0,0x8(%r11,%r9,4)
 107933d:	jmp    1079347 <check_input_run+0xbfb7>
 107933f:	movb   $0x1,0x3c5(%r9)
 1079347:	cmp    %ebp,%r8d
 107934a:	setb   %dl
 107934d:	test   %dl,%r14b
 1079350:	je     1079167 <check_input_run+0xbdd7>
 1079356:	mov    %ebp,%edx
 1079358:	sub    %r8d,%edx
 107935b:	mov    %r8d,%r10d
 107935e:	mov    %r10,%r9
 1079361:	test   $0x1,%dl
 1079364:	je     107941d <check_input_run+0xc08d>
 107936a:	mov    0x10(%rax),%r11
 107936e:	lea    0x1(%r10),%r9
 1079372:	cmpb   $0x4f,(%r11,%r10,1)
 1079377:	jne    107941d <check_input_run+0xc08d>
 107937d:	mov    0x30(%rax),%edx
 1079380:	cmp    %rdx,%r9
 1079383:	jae    1079413 <check_input_run+0xc083>
 1079389:	mov    0x60(%rax),%rdx
 107938d:	cmp    0x4(%rdx,%r10,4),%r8d
 1079392:	jne    1079413 <check_input_run+0xc083>
 1079394:	mov    0x50(%rax),%rdx
 1079398:	cmpb   $0x1a,(%rdx,%r9,1)
 107939d:	jne    1079413 <check_input_run+0xc083>
 107939f:	cmpb   $0x11,(%r11,%r9,1)
 10793a4:	jne    1079413 <check_input_run+0xc083>
 10793a6:	mov    0x2a0(%rsp),%r11
 10793ae:	mov    0x350(%r11),%rdx
 10793b5:	cmpl   $0x0,(%rdx,%r10,4)
 10793ba:	jne    1079413 <check_input_run+0xc083>
 10793bc:	cmp    %esi,%r8d
 10793bf:	jbe    10793c6 <check_input_run+0xc036>
 10793c1:	cmp    %edi,%r8d
 10793c4:	jb     1079413 <check_input_run+0xc083>
 10793c6:	mov    0x230(%r11),%ebx
 10793cd:	cmp    0x234(%r11),%ebx
 10793d4:	jae    107940b <check_input_run+0xc07b>
 10793d6:	movzbl 0x3c5(%r11),%edx
 10793de:	mov    0x228(%r11),%r14
 10793e5:	lea    0x1(%rbx),%ebp
 10793e8:	mov    %ebp,0x230(%r11)
 10793ef:	lea    (%rbx,%rbx,2),%r11
 10793f3:	lea    0x1(%rdx,%rdx,2),%edx
 10793f7:	mov    %r8d,(%r14,%r11,4)
 10793fb:	mov    %edx,0x4(%r14,%r11,4)
 1079400:	movl   $0x0,0x8(%r14,%r11,4)
 1079409:	jmp    1079413 <check_input_run+0xc083>
 107940b:	movb   $0x1,0x3c5(%r11)
 1079413:	mov    0x20(%rsp),%r12
 1079418:	mov    0x28(%rsp),%rbp
 107941d:	lea    -0x1(%rbp),%rdx
 1079421:	cmp    %r10,%rdx
 1079424:	je     1079167 <check_input_run+0xbdd7>
 107942a:	mov    %edi,%edi
 107942c:	mov    %esi,%esi
 107942e:	jmp    107947d <check_input_run+0xc0ed>
 1079430:	movzbl 0x3c5(%r11),%edx
 1079438:	mov    0x228(%r11),%rbx
 107943f:	lea    0x1(%r8),%ebp
 1079443:	lea    (%r8,%r8,2),%r8
 1079447:	inc    %r9d
 107944a:	mov    %ebp,0x230(%r11)
 1079451:	lea    0x1(%rdx,%rdx,2),%edx
 1079455:	mov    %r9d,(%rbx,%r8,4)
 1079459:	mov    %edx,0x4(%rbx,%r8,4)
 107945e:	movl   $0x0,0x8(%rbx,%r8,4)
 1079467:	mov    0x20(%rsp),%r12
 107946c:	mov    0x28(%rsp),%rbp
 1079471:	mov    %r10,%r9
 1079474:	cmp    %r10,%rbp
 1079477:	je     1079167 <check_input_run+0xbdd7>
 107947d:	mov    0x10(%rax),%r10
 1079481:	lea    0x1(%r9),%r8
 1079485:	cmpb   $0x4f,(%r9,%r10,1)
 107948a:	jne    107953e <check_input_run+0xc1ae>
 1079490:	mov    0x30(%rax),%edx
 1079493:	cmp    %rdx,%r8
 1079496:	jae    107953e <check_input_run+0xc1ae>
 107949c:	mov    0x60(%rax),%rdx
 10794a0:	mov    0x4(%rdx,%r9,4),%edx
 10794a5:	cmp    %rdx,%r9
 10794a8:	jne    107953e <check_input_run+0xc1ae>
 10794ae:	mov    0x50(%rax),%rdx
 10794b2:	cmpb   $0x1a,0x1(%rdx,%r9,1)
 10794b8:	jne    107953e <check_input_run+0xc1ae>
 10794be:	cmpb   $0x11,0x1(%r10,%r9,1)
 10794c4:	jne    107953e <check_input_run+0xc1ae>
 10794c6:	mov    0x2a0(%rsp),%r10
 10794ce:	mov    0x350(%r10),%rdx
 10794d5:	cmpl   $0x0,(%rdx,%r9,4)
 10794da:	jne    107953e <check_input_run+0xc1ae>
 10794dc:	cmp    %rsi,%r9
 10794df:	jbe    10794e6 <check_input_run+0xc156>
 10794e1:	cmp    %rdi,%r9
 10794e4:	jb     107953e <check_input_run+0xc1ae>
 10794e6:	mov    0x230(%r10),%r11d
 10794ed:	cmp    0x234(%r10),%r11d
 10794f4:	jae    107952c <check_input_run+0xc19c>
 10794f6:	movzbl 0x3c5(%r10),%edx
 10794fe:	mov    0x228(%r10),%rbx
 1079505:	lea    0x1(%r11),%ebp
 1079509:	mov    %ebp,0x230(%r10)
 1079510:	lea    (%r11,%r11,2),%r10
 1079514:	lea    0x1(%rdx,%rdx,2),%edx
 1079518:	mov    %r9d,(%rbx,%r10,4)
 107951c:	mov    %edx,0x4(%rbx,%r10,4)
 1079521:	movl   $0x0,0x8(%rbx,%r10,4)
 107952a:	jmp    1079534 <check_input_run+0xc1a4>
 107952c:	movb   $0x1,0x3c5(%r10)
 1079534:	mov    0x20(%rsp),%r12
 1079539:	mov    0x28(%rsp),%rbp
 107953e:	mov    0x10(%rax),%r11
 1079542:	lea    0x2(%r9),%r10
 1079546:	cmpb   $0x4f,0x1(%r9,%r11,1)
 107954c:	jne    1079471 <check_input_run+0xc0e1>
 1079552:	mov    0x30(%rax),%edx
 1079555:	cmp    %rdx,%r10
 1079558:	jae    1079471 <check_input_run+0xc0e1>
 107955e:	mov    0x60(%rax),%rdx
 1079562:	mov    0x8(%rdx,%r9,4),%edx
 1079567:	cmp    %rdx,%r8
 107956a:	jne    1079471 <check_input_run+0xc0e1>
 1079570:	mov    0x50(%rax),%rdx
 1079574:	cmpb   $0x1a,0x2(%rdx,%r9,1)
 107957a:	jne    1079471 <check_input_run+0xc0e1>
 1079580:	cmpb   $0x11,0x2(%r11,%r9,1)
 1079586:	jne    1079471 <check_input_run+0xc0e1>
 107958c:	mov    0x2a0(%rsp),%r11
 1079594:	mov    0x350(%r11),%rdx
 107959b:	cmpl   $0x0,0x4(%rdx,%r9,4)
 10795a1:	jne    1079471 <check_input_run+0xc0e1>
 10795a7:	cmp    %rsi,%r9
 10795aa:	jb     10795b5 <check_input_run+0xc225>
 10795ac:	cmp    %rdi,%r8
 10795af:	jb     1079471 <check_input_run+0xc0e1>
 10795b5:	mov    0x230(%r11),%r8d
 10795bc:	cmp    0x234(%r11),%r8d
 10795c3:	jb     1079430 <check_input_run+0xc0a0>
 10795c9:	movb   $0x1,0x3c5(%r11)
 10795d1:	jmp    1079467 <check_input_run+0xc0d7>
 10795d6:	mov    0x2ac40(%r12),%r13
 10795de:	movb   $0x1,0x58(%rsp)
 10795e3:	mov    0x70(%rsp),%r10
 10795e8:	mov    0xe8(%rsp),%r9
 10795f0:	jmp    107829d <check_input_run+0xaf0d>
 10795f5:	mov    0x18(%rsp),%rdi
 10795fa:	movq   $0x0,0x248(%rdi)
 1079605:	movq   $0x0,0x260(%rdi)
 1079610:	jmp    106dbd6 <check_input_run+0x846>
 1079615:	mov    0x78(%rsp),%rdx
 107961a:	mov    0x10(%rsp),%rsi
 107961f:	mov    %r9,0x30(%rsp)
 1079624:	lea    0x1(%rdx,%rcx,1),%rdx
 1079629:	mov    %rdx,0x8(%rsi)
 107962d:	mov    0x18(%rsp),%rdx
 1079632:	add    (%rsi),%rcx
 1079635:	mov    %rcx,0x248(%rdx)
 107963c:	je     10796fd <check_input_run+0xc36d>
 1079642:	mov    0x10(%rsp),%rcx
 1079647:	mov    (%rcx),%rsi
 107964a:	mov    0x8(%rcx),%rdx
 107964e:	lea    0x3(%rdx,%rsi,1),%rcx
 1079653:	add    %rsi,%rdx
 1079656:	and    $0xfffffffffffffffc,%rcx
 107965a:	cmp    %rdx,%rcx
 107965d:	jb     10796fd <check_input_run+0xc36d>
 1079663:	mov    %rcx,%rdx
 1079666:	sub    %rsi,%rdx
 1079669:	mov    0x10(%rsp),%rsi
 107966e:	mov    0x10(%rsi),%rsi
 1079672:	sub    %rdx,%rsi
 1079675:	jb     10796fd <check_input_run+0xc36d>
 107967b:	cmp    %rsi,%rax
 107967e:	ja     10796fd <check_input_run+0xc36d>
 1079680:	mov    0x10(%rsp),%rsi
 1079685:	add    %rax,%rdx
 1079688:	mov    %rdx,0x8(%rsi)
 107968c:	mov    0x18(%rsp),%rsi
 1079691:	mov    %rcx,0x260(%rsi)
 1079698:	test   %rcx,%rcx
 107969b:	je     10796e4 <check_input_run+0xc354>
 107969d:	mov    0x10(%rsp),%rcx
 10796a2:	mov    (%rcx),%rdx
 10796a5:	mov    0x8(%rcx),%rsi
 10796a9:	lea    0x7(%rsi,%rdx,1),%rcx
 10796ae:	add    %rdx,%rsi
 10796b1:	and    $0xfffffffffffffff8,%rcx
 10796b5:	cmp    %rsi,%rcx
 10796b8:	jb     10796e4 <check_input_run+0xc354>
 10796ba:	mov    %rcx,%rsi
 10796bd:	sub    %rdx,%rsi
 10796c0:	mov    0x10(%rsp),%rdx
 10796c5:	mov    0x10(%rdx),%rdx
 10796c9:	sub    %rsi,%rdx
 10796cc:	setb   %dil
 10796d0:	cmp    0x78(%rsp),%rdx
 10796d5:	setbe  %dl
 10796d8:	or     %dil,%dl
 10796db:	cmp    $0x1,%dl
 10796de:	jne    107a82e <check_input_run+0xd49e>
 10796e4:	mov    0x18(%rsp),%rdi
 10796e9:	mov    0x10(%rsp),%rsi
 10796ee:	mov    0x20(%rsp),%r12
 10796f3:	mov    0x30(%rsp),%r9
 10796f8:	jmp    106dbd6 <check_input_run+0x846>
 10796fd:	mov    0x18(%rsp),%rdi
 1079702:	mov    0x10(%rsp),%rsi
 1079707:	mov    0x20(%rsp),%r12
 107970c:	mov    0x30(%rsp),%r9
 1079711:	movq   $0x0,0x260(%rdi)
 107971c:	jmp    106dbd6 <check_input_run+0x846>
 1079721:	xor    %r14d,%r14d
 1079724:	jmp    10715d2 <check_input_run+0x4242>
 1079729:	mov    0x90(%rsp),%r13
 1079731:	xor    %edx,%edx
 1079733:	mov    %dl,0x0(%r13,%rcx,1)
 1079738:	mov    %rax,%rcx
 107973b:	test   %rax,%rax
 107973e:	je     1079885 <check_input_run+0xc4f5>
 1079744:	lea    -0xbdbfdb(%rip),%rax        # 49d770 <cbuiltin_test_generated.edges+0x3930>
 107974b:	lea    -0xbdbece(%rip),%rdx        # 49d884 <cbuiltin_test_generated.edges+0x3a44>
 1079752:	mov    $0x6005,%esi
 1079757:	jmp    1079772 <check_input_run+0xc3e2>
 1079759:	bt     %r12d,%esi
 107975d:	jae    107980f <check_input_run+0xc47f>
 1079763:	add    $0xfffffffffffffffe,%rcx
 1079767:	mov    %r8b,0x0(%r13,%rdi,1)
 107976c:	je     1079885 <check_input_run+0xc4f5>
 1079772:	mov    0x68(%r14),%rdi
 1079776:	mov    0x50(%r14),%r10
 107977a:	mov    0x60(%r14),%r8
 107977e:	mov    -0x4(%rdi,%rcx,4),%edi
 1079782:	movzbl (%r10,%rdi,1),%r11d
 1079787:	mov    (%r8,%rdi,4),%r9d
 107978b:	mov    $0x1,%r8b
 107978e:	lea    -0x41(%r11),%r12d
 1079792:	cmp    $0xe,%r12d
 1079796:	ja     107979e <check_input_run+0xc40e>
 1079798:	bt     %r12d,%esi
 107979c:	jb     10797e0 <check_input_run+0xc450>
 107979e:	add    $0xfffffff9,%r11d
 10797a2:	cmp    $0x2,%r11d
 10797a6:	jb     10797e0 <check_input_run+0xc450>
 10797a8:	cmp    %ebp,%r9d
 10797ab:	jae    10797dd <check_input_run+0xc44d>
 10797ad:	cmpb   $0x0,0x0(%r13,%r9,1)
 10797b3:	je     10797dd <check_input_run+0xc44d>
 10797b5:	movzbl (%r10,%r9,1),%r10d
 10797ba:	add    $0xfffffff9,%r10d
 10797be:	cmp    $0x44,%r10d
 10797c2:	ja     10797dd <check_input_run+0xc44d>
 10797c4:	movslq (%rax,%r10,4),%r10
 10797c8:	add    %rax,%r10
 10797cb:	jmp    *%r10
 10797ce:	cmp    (%r15,%r9,4),%edi
 10797d2:	setb   %r8b
 10797d6:	jmp    10797e0 <check_input_run+0xc450>
 10797d8:	cmp    %r9d,%edi
 10797db:	jb     10797e0 <check_input_run+0xc450>
 10797dd:	xor    %r8d,%r8d
 10797e0:	mov    %r8b,0x0(%r13,%rdi,1)
 10797e5:	mov    0x68(%r14),%rdi
 10797e9:	mov    0x50(%r14),%r10
 10797ed:	mov    0x60(%r14),%r8
 10797f1:	mov    -0x8(%rdi,%rcx,4),%edi
 10797f5:	movzbl (%r10,%rdi,1),%r11d
 10797fa:	mov    (%r8,%rdi,4),%r9d
 10797fe:	mov    $0x1,%r8b
 1079801:	lea    -0x41(%r11),%r12d
 1079805:	cmp    $0xe,%r12d
 1079809:	jbe    1079759 <check_input_run+0xc3c9>
 107980f:	add    $0xfffffff9,%r11d
 1079813:	cmp    $0x2,%r11d
 1079817:	jb     1079763 <check_input_run+0xc3d3>
 107981d:	cmp    %ebp,%r9d
 1079820:	jae    1079859 <check_input_run+0xc4c9>
 1079822:	cmpb   $0x0,0x0(%r13,%r9,1)
 1079828:	je     1079859 <check_input_run+0xc4c9>
 107982a:	movzbl (%r10,%r9,1),%r10d
 107982f:	add    $0xfffffff9,%r10d
 1079833:	cmp    $0x44,%r10d
 1079837:	ja     1079859 <check_input_run+0xc4c9>
 1079839:	movslq (%rdx,%r10,4),%r10
 107983d:	add    %rdx,%r10
 1079840:	jmp    *%r10
 1079843:	cmp    (%r15,%r9,4),%edi
 1079847:	setb   %r8b
 107984b:	jmp    1079763 <check_input_run+0xc3d3>
 1079850:	cmp    %r9d,%edi
 1079853:	jb     1079763 <check_input_run+0xc3d3>
 1079859:	xor    %r8d,%r8d
 107985c:	jmp    1079763 <check_input_run+0xc3d3>
 1079861:	mov    0x10(%r14),%r8
 1079865:	cmpb   $0x11,(%r8,%r9,1)
 107986a:	sete   %r8b
 107986e:	jmp    10797e0 <check_input_run+0xc450>
 1079873:	mov    0x10(%r14),%r8
 1079877:	cmpb   $0x11,(%r8,%r9,1)
 107987c:	sete   %r8b
 1079880:	jmp    1079763 <check_input_run+0xc3d3>
 1079885:	mov    0x130(%rsp),%rax
 107988d:	mov    0xd0(%rsp),%r10
 1079895:	mov    (%rax),%eax
 1079897:	mov    %eax,0x48(%rsp)
 107989b:	test   %eax,%eax
 107989d:	je     1079dbc <check_input_run+0xca2c>
 10798a3:	mov    $0xffffffff,%r8d
 10798a9:	xor    %r12d,%r12d
 10798ac:	xor    %edi,%edi
 10798ae:	jmp    10798e1 <check_input_run+0xc551>
 10798b0:	mov    %eax,0x10(%r9)
 10798b4:	mov    $0x3,%sil
 10798b7:	mov    0x130(%rsp),%rax
 10798bf:	mov    %sil,0x31(%r9)
 10798c3:	mov    (%rax),%eax
 10798c5:	mov    %eax,0x48(%rsp)
 10798c9:	mov    0x48(%rsp),%eax
 10798cd:	mov    0xd0(%rsp),%r10
 10798d5:	inc    %rdi
 10798d8:	cmp    %rax,%rdi
 10798db:	jae    1079dbc <check_input_run+0xca2c>
 10798e1:	mov    (%r10),%r9
 10798e4:	imul   $0x34,%rdi,%r13
 10798e8:	mov    0xc(%r9,%r13,1),%r10d
 10798ed:	cmp    %r10d,%r12d
 10798f0:	jae    1079b01 <check_input_run+0xc771>
 10798f6:	mov    0x50(%r14),%rcx
 10798fa:	mov    %r10d,%esi
 10798fd:	sub    %r12d,%esi
 1079900:	mov    %r12d,%edx
 1079903:	mov    %rdx,%rax
 1079906:	and    $0x7,%esi
 1079909:	jne    1079932 <check_input_run+0xc5a2>
 107990b:	sub    %r10,%rdx
 107990e:	mov    %r10d,%r12d
 1079911:	cmp    $0xfffffffffffffff8,%rdx
 1079915:	ja     1079b01 <check_input_run+0xc771>
 107991b:	mov    %r10,%r12
 107991e:	neg    %r12
 1079921:	add    $0x7,%rax
 1079925:	jmp    1079972 <check_input_run+0xc5e2>
 1079927:	mov    %eax,%r8d
 107992a:	inc    %rax
 107992d:	dec    %rsi
 1079930:	je     107990b <check_input_run+0xc57b>
 1079932:	movzbl (%rcx,%rax,1),%r12d
 1079937:	add    $0xc5,%r12b
 107993b:	cmp    $0xe7,%r12b
 107993f:	jae    1079927 <check_input_run+0xc597>
 1079941:	cmp    %ebp,%r8d
 1079944:	jae    107992a <check_input_run+0xc59a>
 1079946:	mov    0x60(%r14),%r11
 107994a:	mov    %r8d,%r12d
 107994d:	mov    (%r11,%r12,4),%r11d
 1079951:	cmp    %r11,%rax
 1079954:	jne    107992a <check_input_run+0xc59a>
 1079956:	mov    (%r15,%r12,4),%r8d
 107995a:	jmp    107992a <check_input_run+0xc59a>
 107995c:	mov    %eax,%r8d
 107995f:	lea    0x8(%r12,%rax,1),%rdx
 1079964:	add    $0x8,%rax
 1079968:	cmp    $0x7,%rdx
 107996c:	je     1079afe <check_input_run+0xc76e>
 1079972:	movzbl -0x7(%rcx,%rax,1),%esi
 1079977:	lea    -0x7(%rax),%rdx
 107997b:	add    $0xc5,%sil
 107997f:	cmp    $0xe7,%sil
 1079983:	jae    10799a0 <check_input_run+0xc610>
 1079985:	cmp    %ebp,%r8d
 1079988:	jae    10799a3 <check_input_run+0xc613>
 107998a:	mov    0x60(%r14),%r11
 107998e:	mov    %r8d,%esi
 1079991:	mov    (%r11,%rsi,4),%r11d
 1079995:	cmp    %r11,%rdx
 1079998:	jne    10799a3 <check_input_run+0xc613>
 107999a:	mov    (%r15,%rsi,4),%r8d
 107999e:	jmp    10799a3 <check_input_run+0xc613>
 10799a0:	mov    %edx,%r8d
 10799a3:	movzbl -0x6(%rcx,%rax,1),%esi
 10799a8:	lea    -0x6(%rax),%rdx
 10799ac:	add    $0xc5,%sil
 10799b0:	cmp    $0xe7,%sil
 10799b4:	jae    10799d1 <check_input_run+0xc641>
 10799b6:	cmp    %ebp,%r8d
 10799b9:	jae    10799d4 <check_input_run+0xc644>
 10799bb:	mov    0x60(%r14),%r11
 10799bf:	mov    %r8d,%esi
 10799c2:	mov    (%r11,%rsi,4),%r11d
 10799c6:	cmp    %r11,%rdx
 10799c9:	jne    10799d4 <check_input_run+0xc644>
 10799cb:	mov    (%r15,%rsi,4),%r8d
 10799cf:	jmp    10799d4 <check_input_run+0xc644>
 10799d1:	mov    %edx,%r8d
 10799d4:	movzbl -0x5(%rcx,%rax,1),%esi
 10799d9:	lea    -0x5(%rax),%rdx
 10799dd:	add    $0xc5,%sil
 10799e1:	cmp    $0xe7,%sil
 10799e5:	jae    1079a02 <check_input_run+0xc672>
 10799e7:	cmp    %ebp,%r8d
 10799ea:	jae    1079a05 <check_input_run+0xc675>
 10799ec:	mov    0x60(%r14),%r11
 10799f0:	mov    %r8d,%esi
 10799f3:	mov    (%r11,%rsi,4),%r11d
 10799f7:	cmp    %r11,%rdx
 10799fa:	jne    1079a05 <check_input_run+0xc675>
 10799fc:	mov    (%r15,%rsi,4),%r8d
 1079a00:	jmp    1079a05 <check_input_run+0xc675>
 1079a02:	mov    %edx,%r8d
 1079a05:	movzbl -0x4(%rcx,%rax,1),%esi
 1079a0a:	lea    -0x4(%rax),%rdx
 1079a0e:	add    $0xc5,%sil
 1079a12:	cmp    $0xe7,%sil
 1079a16:	jae    1079a33 <check_input_run+0xc6a3>
 1079a18:	cmp    %ebp,%r8d
 1079a1b:	jae    1079a36 <check_input_run+0xc6a6>
 1079a1d:	mov    0x60(%r14),%r11
 1079a21:	mov    %r8d,%esi
 1079a24:	mov    (%r11,%rsi,4),%r11d
 1079a28:	cmp    %r11,%rdx
 1079a2b:	jne    1079a36 <check_input_run+0xc6a6>
 1079a2d:	mov    (%r15,%rsi,4),%r8d
 1079a31:	jmp    1079a36 <check_input_run+0xc6a6>
 1079a33:	mov    %edx,%r8d
 1079a36:	movzbl -0x3(%rcx,%rax,1),%esi
 1079a3b:	lea    -0x3(%rax),%rdx
 1079a3f:	add    $0xc5,%sil
 1079a43:	cmp    $0xe7,%sil
 1079a47:	jae    1079a64 <check_input_run+0xc6d4>
 1079a49:	cmp    %ebp,%r8d
 1079a4c:	jae    1079a67 <check_input_run+0xc6d7>
 1079a4e:	mov    0x60(%r14),%r11
 1079a52:	mov    %r8d,%esi
 1079a55:	mov    (%r11,%rsi,4),%r11d
 1079a59:	cmp    %r11,%rdx
 1079a5c:	jne    1079a67 <check_input_run+0xc6d7>
 1079a5e:	mov    (%r15,%rsi,4),%r8d
 1079a62:	jmp    1079a67 <check_input_run+0xc6d7>
 1079a64:	mov    %edx,%r8d
 1079a67:	movzbl -0x2(%rcx,%rax,1),%esi
 1079a6c:	lea    -0x2(%rax),%rdx
 1079a70:	add    $0xc5,%sil
 1079a74:	cmp    $0xe7,%sil
 1079a78:	jae    1079a95 <check_input_run+0xc705>
 1079a7a:	cmp    %ebp,%r8d
 1079a7d:	jae    1079a98 <check_input_run+0xc708>
 1079a7f:	mov    0x60(%r14),%r11
 1079a83:	mov    %r8d,%esi
 1079a86:	mov    (%r11,%rsi,4),%r11d
 1079a8a:	cmp    %r11,%rdx
 1079a8d:	jne    1079a98 <check_input_run+0xc708>
 1079a8f:	mov    (%r15,%rsi,4),%r8d
 1079a93:	jmp    1079a98 <check_input_run+0xc708>
 1079a95:	mov    %edx,%r8d
 1079a98:	movzbl -0x1(%rcx,%rax,1),%esi
 1079a9d:	lea    -0x1(%rax),%rdx
 1079aa1:	add    $0xc5,%sil
 1079aa5:	cmp    $0xe7,%sil
 1079aa9:	jae    1079ac6 <check_input_run+0xc736>
 1079aab:	cmp    %ebp,%r8d
 1079aae:	jae    1079ac9 <check_input_run+0xc739>
 1079ab0:	mov    0x60(%r14),%r11
 1079ab4:	mov    %r8d,%esi
 1079ab7:	mov    (%r11,%rsi,4),%r11d
 1079abb:	cmp    %r11,%rdx
 1079abe:	jne    1079ac9 <check_input_run+0xc739>
 1079ac0:	mov    (%r15,%rsi,4),%r8d
 1079ac4:	jmp    1079ac9 <check_input_run+0xc739>
 1079ac6:	mov    %edx,%r8d
 1079ac9:	movzbl (%rcx,%rax,1),%edx
 1079acd:	add    $0xc5,%dl
 1079ad0:	cmp    $0xe7,%dl
 1079ad3:	jae    107995c <check_input_run+0xc5cc>
 1079ad9:	cmp    %ebp,%r8d
 1079adc:	jae    107995f <check_input_run+0xc5cf>
 1079ae2:	mov    0x60(%r14),%rsi
 1079ae6:	mov    %r8d,%edx
 1079ae9:	mov    (%rsi,%rdx,4),%esi
 1079aec:	cmp    %rsi,%rax
 1079aef:	jne    107995f <check_input_run+0xc5cf>
 1079af5:	mov    (%r15,%rdx,4),%r8d
 1079af9:	jmp    107995f <check_input_run+0xc5cf>
 1079afe:	mov    %r10d,%r12d
 1079b01:	add    %r13,%r9
 1079b04:	cmpb   $0x1,0x31(%r9)
 1079b09:	jne    10798c9 <check_input_run+0xc539>
 1079b0f:	mov    0x90(%rsp),%r13
 1079b17:	test   %r10d,%r10d
 1079b1a:	je     10798c9 <check_input_run+0xc539>
 1079b20:	movzbl 0x30(%r9),%eax
 1079b25:	and    $0x1,%al
 1079b27:	jne    10798c9 <check_input_run+0xc539>
 1079b2d:	mov    0x60(%r14),%rdx
 1079b31:	lea    -0x1(%r10),%eax
 1079b35:	mov    0x50(%r14),%rcx
 1079b39:	xor    %esi,%esi
 1079b3b:	mov    (%rdx,%rax,4),%r11d
 1079b3f:	cmp    %ebp,%r11d
 1079b42:	jae    1079b49 <check_input_run+0xc7b9>
 1079b44:	movzbl (%rcx,%r11,1),%esi
 1079b49:	mov    %r11,0x70(%rsp)
 1079b4e:	mov    %esi,0xe8(%rsp)
 1079b55:	cmp    %ebp,%r8d
 1079b58:	jae    1079b83 <check_input_run+0xc7f3>
 1079b5a:	mov    %r8d,%r11d
 1079b5d:	movzbl (%rcx,%r11,1),%esi
 1079b62:	cmp    $0x24,%esi
 1079b65:	je     1079b88 <check_input_run+0xc7f8>
 1079b67:	cmp    $0x23,%esi
 1079b6a:	jne    1079b90 <check_input_run+0xc800>
 1079b6c:	mov    (%rdx,%r11,4),%edx
 1079b70:	cmp    %ebp,%edx
 1079b72:	jae    1079b83 <check_input_run+0xc7f3>
 1079b74:	cmpb   $0x0,0x0(%r13,%rdx,1)
 1079b7a:	setne  %sil
 1079b7e:	xor    %r13d,%r13d
 1079b81:	jmp    1079b9e <check_input_run+0xc80e>
 1079b83:	xor    %r13d,%r13d
 1079b86:	jmp    1079b9c <check_input_run+0xc80c>
 1079b88:	xor    %r13d,%r13d
 1079b8b:	mov    $0x1,%sil
 1079b8e:	jmp    1079b9e <check_input_run+0xc80e>
 1079b90:	add    $0xcd,%sil
 1079b94:	cmp    $0x3,%sil
 1079b98:	setb   %r13b
 1079b9c:	xor    %esi,%esi
 1079b9e:	mov    0x10(%r14),%rdx
 1079ba2:	movzbl (%rcx,%rax,1),%ecx
 1079ba6:	cmp    $0xffffffff,%r8d
 1079baa:	movl   $0x1,0x210(%rsp)
 1079bb5:	movzbl (%rdx,%rax,1),%r11d
 1079bba:	mov    %rdx,0xc8(%rsp)
 1079bc2:	sete   %dl
 1079bc5:	mov    %rcx,0x48(%rsp)
 1079bca:	or     %r13b,%dl
 1079bcd:	lea    -0x41(%rcx),%r13d
 1079bd1:	cmp    $0xe,%r13d
 1079bd5:	ja     1079be2 <check_input_run+0xc852>
 1079bd7:	mov    $0x6005,%ecx
 1079bdc:	bt     %r13d,%ecx
 1079be0:	jb     1079bf1 <check_input_run+0xc861>
 1079be2:	mov    0x48(%rsp),%rcx
 1079be7:	lea    -0x7(%rcx),%r13d
 1079beb:	cmp    $0x2,%r13d
 1079bef:	jae    1079c44 <check_input_run+0xc8b4>
 1079bf1:	mov    0x90(%rsp),%r13
 1079bf9:	add    $0xcb,%r11b
 1079bfd:	cmp    $0x2,%r11b
 1079c01:	jb     10798b0 <check_input_run+0xc520>
 1079c07:	mov    0x210(%rsp),%ecx
 1079c0e:	test   %ecx,%ecx
 1079c10:	mov    %ecx,%esi
 1079c12:	sete   %r11b
 1079c16:	cmp    %ebp,%r10d
 1079c19:	jae    1079d23 <check_input_run+0xc993>
 1079c1f:	mov    0xc8(%rsp),%rcx
 1079c27:	cmpb   $0x48,(%rcx,%r10,1)
 1079c2c:	mov    %esi,%ecx
 1079c2e:	mov    %ecx,0x210(%rsp)
 1079c35:	jne    1079d23 <check_input_run+0xc993>
 1079c3b:	mov    %r10d,0x10(%r9)
 1079c3f:	jmp    10798b4 <check_input_run+0xc524>
 1079c44:	mov    0x90(%rsp),%r13
 1079c4c:	test   %sil,%sil
 1079c4f:	je     1079c72 <check_input_run+0xc8e2>
 1079c51:	cmpl   $0x24,0x48(%rsp)
 1079c56:	ja     1079c72 <check_input_run+0xc8e2>
 1079c58:	mov    0x48(%rsp),%esi
 1079c5c:	mov    %r13,%rcx
 1079c5f:	movabs $0x1810000000,%r13
 1079c69:	bt     %rsi,%r13
 1079c6d:	mov    %rcx,%r13
 1079c70:	jb     1079bf9 <check_input_run+0xc869>
 1079c72:	xor    %esi,%esi
 1079c74:	test   %dl,%dl
 1079c76:	je     1079cbf <check_input_run+0xc92f>
 1079c78:	mov    0x48(%rsp),%rcx
 1079c7d:	lea    -0x1e(%rcx),%esi
 1079c80:	cmp    $0x36,%sil
 1079c84:	jae    1079ca4 <check_input_run+0xc914>
 1079c86:	mov    %r13,%rcx
 1079c89:	movzbl %sil,%esi
 1079c8d:	movabs $0x20d00000e0000f,%r13
 1079c97:	bt     %rsi,%r13
 1079c9b:	mov    %rcx,%r13
 1079c9e:	jb     1079bf9 <check_input_run+0xc869>
 1079ca4:	cmpl   $0x49,0x48(%rsp)
 1079ca9:	sete   %cl
 1079cac:	cmpl   $0x1e,0xe8(%rsp)
 1079cb4:	setne  %sil
 1079cb8:	and    %cl,%sil
 1079cbb:	movzbl %sil,%esi
 1079cbf:	cmp    $0x2,%r11b
 1079cc3:	jne    1079d99 <check_input_run+0xca09>
 1079cc9:	cmpb   $0x6,0x48(%rsp)
 1079cce:	jne    1079d99 <check_input_run+0xca09>
 1079cd4:	mov    0xe8(%rsp),%ecx
 1079cdb:	mov    %esi,%r11d
 1079cde:	xor    %esi,%esi
 1079ce0:	and    $0xfffffffe,%ecx
 1079ce3:	cmp    $0x4e,%ecx
 1079ce6:	sete   %sil
 1079cea:	or     %esi,%r11d
 1079ced:	mov    %r11d,%esi
 1079cf0:	sete   %r11b
 1079cf4:	cmp    %ebp,%r10d
 1079cf7:	jae    1079d11 <check_input_run+0xc981>
 1079cf9:	cmp    $0x4e,%ecx
 1079cfc:	jne    1079d11 <check_input_run+0xc981>
 1079cfe:	mov    0xc8(%rsp),%rcx
 1079d06:	cmpb   $0xa,(%rcx,%r10,1)
 1079d0b:	je     1079c3b <check_input_run+0xc8ab>
 1079d11:	mov    %esi,%ecx
 1079d13:	mov    %ecx,0x210(%rsp)
 1079d1a:	cmp    %ebp,%r10d
 1079d1d:	jb     1079c1f <check_input_run+0xc88f>
 1079d23:	mov    0x70(%rsp),%rcx
 1079d28:	cmp    %ebp,%ecx
 1079d2a:	jae    1079d42 <check_input_run+0xc9b2>
 1079d2c:	mov    0xc8(%rsp),%r10
 1079d34:	mov    $0x3,%sil
 1079d37:	cmpb   $0x4d,(%r10,%rcx,1)
 1079d3c:	je     10798b7 <check_input_run+0xc527>
 1079d42:	cmpl   $0x49,0x48(%rsp)
 1079d47:	jne    1079d57 <check_input_run+0xc9c7>
 1079d49:	cmpl   $0x1e,0xe8(%rsp)
 1079d51:	je     10798b0 <check_input_run+0xc520>
 1079d57:	and    %r11b,%dl
 1079d5a:	cmp    $0x1,%dl
 1079d5d:	jne    1079d80 <check_input_run+0xc9f0>
 1079d5f:	mov    0x48(%rsp),%rcx
 1079d64:	lea    -0x2(%rcx),%edx
 1079d67:	cmp    $0x4f,%edx
 1079d6a:	ja     1079da5 <check_input_run+0xca15>
 1079d6c:	lea    -0xbdc3db(%rip),%rsi        # 49d998 <cbuiltin_test_generated.edges+0x3b58>
 1079d73:	movslq (%rsi,%rdx,4),%rdx
 1079d77:	add    %rsi,%rdx
 1079d7a:	jmp    *%rdx
 1079d7c:	mov    %eax,0x10(%r9)
 1079d80:	testb  $0x1,0x210(%rsp)
 1079d88:	mov    $0x3,%sil
 1079d8b:	je     10798b7 <check_input_run+0xc527>
 1079d91:	mov    $0x1,%sil
 1079d94:	jmp    10798b7 <check_input_run+0xc527>
 1079d99:	mov    %esi,0x210(%rsp)
 1079da0:	jmp    1079bf9 <check_input_run+0xc869>
 1079da5:	mov    0x48(%rsp),%rcx
 1079daa:	and    $0xfe,%cl
 1079dad:	cmp    $0x3c,%cl
 1079db0:	jne    1079d80 <check_input_run+0xc9f0>
 1079db2:	cmpb   $0x0,0x0(%r13,%rax,1)
 1079db8:	jne    1079d80 <check_input_run+0xc9f0>
 1079dba:	jmp    1079d7c <check_input_run+0xc9ec>
 1079dbc:	mov    0x2a0(%rsp),%rax
 1079dc4:	mov    0x1b0(%rsp),%rcx
 1079dcc:	mov    0x20(%rsp),%r12
 1079dd1:	mov    0x28(%rsp),%r9
 1079dd6:	mov    %r10,0x1c0(%rax)
 1079ddd:	mov    %rcx,0x1c8(%rax)
 1079de4:	cmpl   $0x0,0x8(%r10)
 1079de9:	je     1079e0e <check_input_run+0xca7e>
 1079deb:	xor    %eax,%eax
 1079ded:	xor    %ecx,%ecx
 1079def:	mov    (%r10),%rdx
 1079df2:	inc    %rcx
 1079df5:	movzbl 0x31(%rdx,%rax,1),%esi
 1079dfa:	mov    (%rdx,%rax,1),%edx
 1079dfd:	add    $0x34,%rax
 1079e01:	mov    %sil,(%rbx,%rdx,1)
 1079e05:	mov    0x8(%r10),%edx
 1079e09:	cmp    %rdx,%rcx
 1079e0c:	jb     1079def <check_input_run+0xca5f>
 1079e0e:	mov    0x2c8(%rsp),%rax
 1079e16:	lea    0x2a0(%rsp),%rdi
 1079e1e:	mov    %rbx,%rsi
 1079e21:	mov    %r9,0x8(%rax)
 1079e25:	call   1081610 <check_input_fp_pragmas>
 1079e2a:	mov    0x18(%rsp),%rcx
 1079e2f:	xor    $0x1,%al
 1079e31:	or     %al,0x3c5(%rcx)
 1079e37:	test   %al,%al
 1079e39:	jne    10724a3 <check_input_run+0x5113>
 1079e3f:	mov    0x48(%r12),%esi
 1079e44:	test   %rsi,%rsi
 1079e47:	je     10724a3 <check_input_run+0x5113>
 1079e4d:	mov    0x18(%rsp),%rax
 1079e52:	mov    0x40(%r12),%rdi
 1079e57:	xor    %edx,%edx
 1079e59:	xor    %ecx,%ecx
 1079e5b:	mov    0x1c0(%rax),%rax
 1079e62:	jmp    1079e70 <check_input_run+0xcae0>
 1079e64:	inc    %rcx
 1079e67:	cmp    %rsi,%rcx
 1079e6a:	je     10724a3 <check_input_run+0x5113>
 1079e70:	test   %rax,%rax
 1079e73:	je     1079ea7 <check_input_run+0xcb17>
 1079e75:	mov    0x8(%rax),%r8d
 1079e79:	cmp    %r8d,%edx
 1079e7c:	jae    1079ea7 <check_input_run+0xcb17>
 1079e7e:	mov    %edx,%edx
 1079e80:	imul   $0x34,%rdx,%r9
 1079e84:	add    (%rax),%r9
 1079e87:	nopw   0x0(%rax,%rax,1)
 1079e90:	mov    (%r9),%r10d
 1079e93:	cmp    %r10,%rcx
 1079e96:	jbe    1079ea7 <check_input_run+0xcb17>
 1079e98:	inc    %rdx
 1079e9b:	add    $0x34,%r9
 1079e9f:	cmp    %rdx,%r8
 1079ea2:	jne    1079e90 <check_input_run+0xcb00>
 1079ea4:	mov    %r8d,%edx
 1079ea7:	mov    (%rdi,%rcx,4),%r8d
 1079eab:	movzbl (%rbx,%rcx,1),%r9d
 1079eb0:	cmp    $0x3,%r9d
 1079eb4:	je     1079ebb <check_input_run+0xcb2b>
 1079eb6:	test   %r9d,%r9d
 1079eb9:	jne    1079e64 <check_input_run+0xcad4>
 1079ebb:	cmpq   $0x0,0x860(%rsp)
 1079ec4:	jne    1079ede <check_input_run+0xcb4e>
 1079ec6:	mov    0x18(%rsp),%r9
 1079ecb:	mov    0x1f0(%r9),%r9
 1079ed2:	test   %r9,%r9
 1079ed5:	je     1079ede <check_input_run+0xcb4e>
 1079ed7:	cmpb   $0x0,(%r9,%r8,1)
 1079edc:	jne    1079e64 <check_input_run+0xcad4>
 1079ede:	mov    %r8d,0x660(%rsp)
 1079ee6:	mov    %ecx,0x664(%rsp)
 1079eed:	xor    %esi,%esi
 1079eef:	cmpb   $0x3,(%rbx,%rcx,1)
 1079ef3:	sete   %sil
 1079ef7:	mov    %esi,0x66c(%rsp)
 1079efe:	test   %rax,%rax
 1079f01:	je     10724a3 <check_input_run+0x5113>
 1079f07:	cmp    0x8(%rax),%edx
 1079f0a:	jae    10724a3 <check_input_run+0x5113>
 1079f10:	mov    (%rax),%rax
 1079f13:	mov    %edx,%edx
 1079f15:	imul   $0x34,%rdx,%rdx
 1079f19:	cmp    %ecx,(%rax,%rdx,1)
 1079f1c:	jne    10724a3 <check_input_run+0x5113>
 1079f22:	add    %rdx,%rax
 1079f25:	mov    0x10(%rax),%eax
 1079f28:	mov    %eax,0x668(%rsp)
 1079f2f:	jmp    10724a3 <check_input_run+0x5113>
 1079f34:	mov    %rax,%rdi
 1079f37:	sub    %r8,%rdi
 1079f3a:	mov    0x10(%rsi),%r8
 1079f3e:	sub    %rdi,%r8
 1079f41:	jb     107a256 <check_input_run+0xcec6>
 1079f47:	shl    $0x2,%rdx
 1079f4b:	cmp    %r8,%rdx
 1079f4e:	ja     107a256 <check_input_run+0xcec6>
 1079f54:	add    %rdx,%rdi
 1079f57:	mov    %rdi,0x8(%rsi)
 1079f5b:	test   %rax,%rax
 1079f5e:	je     1072444 <check_input_run+0x50b4>
 1079f64:	mov    %rbp,%rcx
 1079f67:	shr    $0x3d,%rcx
 1079f6b:	jne    1079fb6 <check_input_run+0xcc26>
 1079f6d:	mov    0x2c8(%rsp),%rcx
 1079f75:	mov    (%rcx),%rdi
 1079f78:	mov    0x8(%rcx),%rdx
 1079f7c:	lea    0x3(%rdx,%rdi,1),%rsi
 1079f81:	add    %rdi,%rdx
 1079f84:	and    $0xfffffffffffffffc,%rsi
 1079f88:	cmp    %rdx,%rsi
 1079f8b:	jb     1079fb6 <check_input_run+0xcc26>
 1079f8d:	mov    %rsi,%r15
 1079f90:	sub    %rdi,%rsi
 1079f93:	mov    0x10(%rcx),%rdi
 1079f97:	lea    0x0(,%rbp,8),%rdx
 1079f9f:	sub    %rsi,%rdi
 1079fa2:	setb   %r8b
 1079fa6:	cmp    %rdi,%rdx
 1079fa9:	seta   %dil
 1079fad:	or     %r8b,%dil
 1079fb0:	je     107a810 <check_input_run+0xd480>
 1079fb6:	xor    %ecx,%ecx
 1079fb8:	mov    %rax,%r14
 1079fbb:	jmp    1072447 <check_input_run+0x50b7>
 1079fc0:	mov    0x38(%rsp),%rax
 1079fc5:	add    %rdx,%rsi
 1079fc8:	mov    %rsi,0x8(%rax)
 1079fcc:	mov    %rdi,0x600(%rsp)
 1079fd4:	test   %rdi,%rdi
 1079fd7:	je     107a481 <check_input_run+0xd0f1>
 1079fdd:	mov    0xa0(%rsp),%rax
 1079fe5:	xor    %esi,%esi
 1079fe7:	mov    0xa4(%rax),%edx
 1079fed:	shl    $0x2,%rdx
 1079ff1:	vzeroupper
 1079ff4:	call   788430 <memset@plt>
 1079ff9:	mov    $0x1,%bl
 1079ffb:	jmp    107a483 <check_input_run+0xd0f3>
 107a000:	mov    0x860(%rsp),%r8
 107a008:	add    $0x20008,%rdi
 107a00f:	mov    %rdi,0x2ac40(%r8)
 107a016:	mov    %rcx,0x2aa30(%r8)
 107a01d:	test   %rcx,%rcx
 107a020:	je     107a26a <check_input_run+0xceda>
 107a026:	add    $0x20008,%rcx
 107a02d:	mov    %rcx,%rdi
 107a030:	sub    %rdx,%rdi
 107a033:	sub    %rdi,%rsi
 107a036:	jb     107a26a <check_input_run+0xceda>
 107a03c:	imul   $0x150,%rax,%rdx
 107a043:	add    $0x150,%rdx
 107a04a:	cmp    %rsi,%rdx
 107a04d:	ja     107a26a <check_input_run+0xceda>
 107a053:	mov    0x860(%rsp),%rsi
 107a05b:	add    %rdx,%rdi
 107a05e:	lea    0x1d8(%rsi),%r15
 107a065:	mov    %rdi,0x2ac40(%rsi)
 107a06c:	mov    %rcx,0x1d8(%rsi)
 107a073:	test   %rcx,%rcx
 107a076:	je     107a7f3 <check_input_run+0xd463>
 107a07c:	mov    0x860(%rsp),%rcx
 107a084:	mov    (%rcx),%ecx
 107a086:	test   %rcx,%rcx
 107a089:	je     107a11a <check_input_run+0xcd8a>
 107a08f:	xor    %edx,%edx
 107a091:	mov    0x860(%rsp),%rsi
 107a099:	mov    0x2ac38(%rsi),%r8
 107a0a0:	mov    0x2ac40(%rsi),%rdi
 107a0a7:	lea    0x3(%rdi,%r8,1),%rsi
 107a0ac:	add    %r8,%rdi
 107a0af:	and    $0xfffffffffffffffc,%rsi
 107a0b3:	cmp    %rdi,%rsi
 107a0b6:	jb     107a8c6 <check_input_run+0xd536>
 107a0bc:	mov    %rsi,%rdi
 107a0bf:	sub    %r8,%rdi
 107a0c2:	mov    0x860(%rsp),%r8
 107a0ca:	mov    0x2ac48(%r8),%r8
 107a0d1:	sub    %rdi,%r8
 107a0d4:	jb     107a8c6 <check_input_run+0xd536>
 107a0da:	cmp    $0x10003,%r8
 107a0e1:	jbe    107a8c6 <check_input_run+0xd536>
 107a0e7:	mov    0x860(%rsp),%r8
 107a0ef:	add    $0x10004,%rdi
 107a0f6:	mov    %rdi,0x2ac40(%r8)
 107a0fd:	mov    %rsi,0x2aa38(%r8,%rdx,8)
 107a105:	test   %rsi,%rsi
 107a108:	je     107a7f3 <check_input_run+0xd463>
 107a10e:	inc    %rdx
 107a111:	cmp    %rdx,%rcx
 107a114:	jne    107a091 <check_input_run+0xcd01>
 107a11a:	mov    0x860(%rsp),%rcx
 107a122:	add    $0x1e0,%rcx
 107a129:	mov    %rcx,0x28(%rsp)
 107a12e:	test   %rax,%rax
 107a131:	je     107a909 <check_input_run+0xd579>
 107a137:	xor    %eax,%eax
 107a139:	vpxor  %xmm0,%xmm0,%xmm0
 107a13d:	xor    %ecx,%ecx
 107a13f:	jmp    107a184 <check_input_run+0xcdf4>
 107a141:	add    %rsi,%rdx
 107a144:	mov    0x860(%rsp),%rsi
 107a14c:	inc    %rcx
 107a14f:	mov    0x4(%rdx),%edx
 107a152:	vmovq  0x1e8(%rsi),%xmm2
 107a15a:	sub    %edi,%edx
 107a15c:	inc    %edx
 107a15e:	vmovd  %edx,%xmm1
 107a162:	vpinsrd $0x1,%r8d,%xmm1,%xmm1
 107a168:	vpmaxud %xmm2,%xmm1,%xmm1
 107a16d:	vmovq  %xmm1,0x1e8(%rsi)
 107a175:	mov    0x1e0(%rsi),%edx
 107a17b:	cmp    %rdx,%rcx
 107a17e:	jae    107a90b <check_input_run+0xd57b>
 107a184:	mov    0x860(%rsp),%r9
 107a18c:	lea    (%rcx,%rcx,2),%rsi
 107a190:	shl    $0x4,%rsi
 107a194:	mov    0x1d0(%r9),%rdx
 107a19b:	mov    0x4(%rdx,%rsi,1),%r8d
 107a1a0:	mov    (%rdx,%rsi,1),%edi
 107a1a3:	add    %rax,%r8
 107a1a6:	sub    %rdi,%r8
 107a1a9:	mov    %r8,%rax
 107a1ac:	mov    0x2aa28(%r9),%r8
 107a1b3:	inc    %rax
 107a1b6:	mov    %rax,(%r8,%rcx,8)
 107a1ba:	imul   $0x150,%rcx,%r8
 107a1c1:	mov    0x1d8(%r9),%rdi
 107a1c8:	vmovdqu64 %zmm0,0x10c(%rdi,%r8,1)
 107a1d3:	vmovdqu64 %zmm0,0x100(%rdi,%r8,1)
 107a1db:	vmovdqu64 %zmm0,0xc0(%rdi,%r8,1)
 107a1e3:	vmovdqu64 %zmm0,0x80(%rdi,%r8,1)
 107a1eb:	vmovdqu64 %zmm0,0x40(%rdi,%r8,1)
 107a1f3:	vmovdqu64 %zmm0,(%rdi,%r8,1)
 107a1fa:	movb   $0x1,0x14c(%rdi,%r8,1)
 107a203:	movw   $0x0,0x14d(%rdi,%r8,1)
 107a20e:	movb   $0x0,0x14f(%rdi,%r8,1)
 107a217:	mov    0x580(%rsp),%r8
 107a21f:	mov    (%rdx,%rsi,1),%edi
 107a222:	mov    (%r8,%rdi,4),%r9d
 107a226:	mov    $0x0,%r8d
 107a22c:	cmp    $0xffffffff,%r9d
 107a230:	je     107a141 <check_input_run+0xcdb1>
 107a236:	mov    0x588(%rsp),%r10
 107a23e:	xor    %r8d,%r8d
 107a241:	mov    %r9d,%r9d
 107a244:	mov    (%r10,%r9,4),%r9d
 107a248:	inc    %r8d
 107a24b:	cmp    $0xffffffff,%r9d
 107a24f:	jne    107a241 <check_input_run+0xceb1>
 107a251:	jmp    107a141 <check_input_run+0xcdb1>
 107a256:	mov    0x20(%rsp),%r12
 107a25b:	mov    0x28(%rsp),%r9
 107a260:	xor    %edi,%edi
 107a262:	xor    %r14d,%r14d
 107a265:	jmp    10715e0 <check_input_run+0x4250>
 107a26a:	mov    0x860(%rsp),%r12
 107a272:	jmp    1076dd8 <check_input_run+0x9a48>
 107a277:	mov    0x100(%rsp),%eax
 107a27e:	xor    %r11d,%r11d
 107a281:	xor    %ecx,%ecx
 107a283:	mov    %rax,0xd8(%rsp)
 107a28b:	xor    %eax,%eax
 107a28d:	jmp    107a2c3 <check_input_run+0xcf33>
 107a28f:	mov    0x860(%rsp),%r8
 107a297:	mov    0xe8(%rsp),%r9
 107a29f:	mov    0xc0(%rsp),%rbx
 107a2a7:	mov    0x70(%rsp),%r10
 107a2ac:	inc    %rcx
 107a2af:	mov    %r15,%rbp
 107a2b2:	mov    %r12,%r14
 107a2b5:	cmp    0xd8(%rsp),%rcx
 107a2bd:	je     107a48d <check_input_run+0xd0fd>
 107a2c3:	lea    (%rcx,%rcx,2),%rsi
 107a2c7:	shl    $0x4,%rsi
 107a2cb:	mov    (%r10,%rsi,1),%rdx
 107a2cf:	test   %rdx,%rdx
 107a2d2:	je     107824b <check_input_run+0xaebb>
 107a2d8:	cmpb   $0x0,0x4c(%rdx)
 107a2dc:	jne    107824b <check_input_run+0xaebb>
 107a2e2:	test   %rcx,%rcx
 107a2e5:	je     107a2f4 <check_input_run+0xcf64>
 107a2e7:	add    %r10,%rsi
 107a2ea:	cmp    %r10,0x8(%rsi)
 107a2ee:	jne    107824b <check_input_run+0xaebb>
 107a2f4:	mov    0x8(%rdx),%edi
 107a2f7:	mov    %r14,%r12
 107a2fa:	mov    %rbp,%r15
 107a2fd:	test   %rdi,%rdi
 107a300:	je     107a28f <check_input_run+0xceff>
 107a302:	mov    (%rdx),%rdx
 107a305:	mov    %edi,%esi
 107a307:	and    $0x3,%esi
 107a30a:	cmp    $0x4,%edi
 107a30d:	jae    107a317 <check_input_run+0xcf87>
 107a30f:	xor    %r8d,%r8d
 107a312:	jmp    107a42e <check_input_run+0xd09e>
 107a317:	and    $0xfffffffc,%edi
 107a31a:	lea    0x8(%rdx),%r9
 107a31e:	xor    %r8d,%r8d
 107a321:	jmp    107a33a <check_input_run+0xcfaa>
 107a323:	mov    %r10d,%eax
 107a326:	add    $0x4,%r8
 107a32a:	add    $0xe0,%r9
 107a331:	cmp    %r8,%rdi
 107a334:	je     107a425 <check_input_run+0xd095>
 107a33a:	movzbl (%r9),%r10d
 107a33e:	cmp    $0x1,%r10d
 107a342:	je     107a357 <check_input_run+0xcfc7>
 107a344:	cmp    $0x3,%r10d
 107a348:	jne    107a36a <check_input_run+0xcfda>
 107a34a:	mov    0x14(%r9),%r10d
 107a34e:	cmp    %eax,%r10d
 107a351:	cmova  %r10d,%eax
 107a355:	jmp    107a36a <check_input_run+0xcfda>
 107a357:	cmpb   $0xb,0x1(%r9)
 107a35c:	jne    107a36a <check_input_run+0xcfda>
 107a35e:	mov    0x8(%r9),%r10
 107a362:	cmp    %r11,%r10
 107a365:	jbe    107a36a <check_input_run+0xcfda>
 107a367:	mov    %r10,%r11
 107a36a:	movzbl 0x38(%r9),%r10d
 107a36f:	cmp    $0x1,%r10d
 107a373:	je     107a388 <check_input_run+0xcff8>
 107a375:	cmp    $0x3,%r10d
 107a379:	jne    107a39b <check_input_run+0xd00b>
 107a37b:	mov    0x4c(%r9),%r10d
 107a37f:	cmp    %eax,%r10d
 107a382:	cmova  %r10d,%eax
 107a386:	jmp    107a39b <check_input_run+0xd00b>
 107a388:	cmpb   $0xb,0x39(%r9)
 107a38d:	jne    107a39b <check_input_run+0xd00b>
 107a38f:	mov    0x40(%r9),%r10
 107a393:	cmp    %r11,%r10
 107a396:	jbe    107a39b <check_input_run+0xd00b>
 107a398:	mov    %r10,%r11
 107a39b:	movzbl 0x70(%r9),%r10d
 107a3a0:	cmp    $0x1,%r10d
 107a3a4:	je     107a3bc <check_input_run+0xd02c>
 107a3a6:	cmp    $0x3,%r10d
 107a3aa:	jne    107a3cf <check_input_run+0xd03f>
 107a3ac:	mov    0x84(%r9),%r10d
 107a3b3:	cmp    %eax,%r10d
 107a3b6:	cmova  %r10d,%eax
 107a3ba:	jmp    107a3cf <check_input_run+0xd03f>
 107a3bc:	cmpb   $0xb,0x71(%r9)
 107a3c1:	jne    107a3cf <check_input_run+0xd03f>
 107a3c3:	mov    0x78(%r9),%r10
 107a3c7:	cmp    %r11,%r10
 107a3ca:	jbe    107a3cf <check_input_run+0xd03f>
 107a3cc:	mov    %r10,%r11
 107a3cf:	movzbl 0xa8(%r9),%r10d
 107a3d7:	cmp    $0x1,%r10d
 107a3db:	je     107a3ff <check_input_run+0xd06f>
 107a3dd:	cmp    $0x3,%r10d
 107a3e1:	jne    107a326 <check_input_run+0xcf96>
 107a3e7:	mov    0xbc(%r9),%r10d
 107a3ee:	cmp    %eax,%r10d
 107a3f1:	ja     107a323 <check_input_run+0xcf93>
 107a3f7:	mov    %eax,%r10d
 107a3fa:	jmp    107a323 <check_input_run+0xcf93>
 107a3ff:	cmpb   $0xb,0xa9(%r9)
 107a407:	jne    107a326 <check_input_run+0xcf96>
 107a40d:	mov    0xb0(%r9),%r10
 107a414:	cmp    %r11,%r10
 107a417:	jbe    107a326 <check_input_run+0xcf96>
 107a41d:	mov    %r10,%r11
 107a420:	jmp    107a326 <check_input_run+0xcf96>
 107a425:	test   %rsi,%rsi
 107a428:	je     107a28f <check_input_run+0xceff>
 107a42e:	imul   $0x38,%r8,%rdi
 107a432:	imul   $0x38,%rsi,%rsi
 107a436:	lea    0x8(%rdx,%rdi,1),%rdx
 107a43b:	xor    %edi,%edi
 107a43d:	jmp    107a44c <check_input_run+0xd0bc>
 107a43f:	add    $0x38,%rdi
 107a443:	cmp    %rdi,%rsi
 107a446:	je     107a28f <check_input_run+0xceff>
 107a44c:	movzbl (%rdx,%rdi,1),%r8d
 107a451:	cmp    $0x1,%r8d
 107a455:	je     107a46b <check_input_run+0xd0db>
 107a457:	cmp    $0x3,%r8d
 107a45b:	jne    107a43f <check_input_run+0xd0af>
 107a45d:	mov    0x14(%rdx,%rdi,1),%r8d
 107a462:	cmp    %eax,%r8d
 107a465:	cmova  %r8d,%eax
 107a469:	jmp    107a43f <check_input_run+0xd0af>
 107a46b:	cmpb   $0xb,0x1(%rdx,%rdi,1)
 107a470:	jne    107a43f <check_input_run+0xd0af>
 107a472:	mov    0x8(%rdx,%rdi,1),%r8
 107a477:	cmp    %r11,%r8
 107a47a:	jbe    107a43f <check_input_run+0xd0af>
 107a47c:	mov    %r8,%r11
 107a47f:	jmp    107a43f <check_input_run+0xd0af>
 107a481:	xor    %ebx,%ebx
 107a483:	mov    0x20(%rsp),%r12
 107a488:	jmp    10702db <check_input_run+0x2f4b>
 107a48d:	mov    %r11,%rcx
 107a490:	inc    %rcx
 107a493:	mov    %rcx,%r11
 107a496:	shr    $0x3e,%rcx
 107a49a:	jne    107824b <check_input_run+0xaebb>
 107a4a0:	mov    0x2ac38(%r8),%rdx
 107a4a7:	lea    0x3(%r13,%rdx,1),%rsi
 107a4ac:	lea    0x0(%r13,%rdx,1),%rcx
 107a4b1:	and    $0xfffffffffffffffc,%rsi
 107a4b5:	mov    %rsi,0x88(%rsp)
 107a4bd:	cmp    %rcx,%rsi
 107a4c0:	jb     107824b <check_input_run+0xaebb>
 107a4c6:	mov    0x88(%rsp),%rsi
 107a4ce:	mov    0x2ac48(%r8),%rcx
 107a4d5:	sub    %rdx,%rsi
 107a4d8:	mov    %rcx,%rdi
 107a4db:	sub    %rsi,%rdi
 107a4de:	jb     107824b <check_input_run+0xaebb>
 107a4e4:	shl    $0x2,%r11
 107a4e8:	mov    %r11,0x68(%rsp)
 107a4ed:	cmp    %rdi,%r11
 107a4f0:	ja     107824b <check_input_run+0xaebb>
 107a4f6:	add    0x68(%rsp),%rsi
 107a4fb:	cmpq   $0x0,0x88(%rsp)
 107a504:	mov    %rsi,0x2ac40(%r8)
 107a50b:	je     107824b <check_input_run+0xaebb>
 107a511:	mov    0x68(%rsp),%rsi
 107a516:	add    0x88(%rsp),%rsi
 107a51e:	mov    %rsi,0x68(%rsp)
 107a523:	sub    %rdx,%rsi
 107a526:	sub    %rsi,%rcx
 107a529:	jb     107824b <check_input_run+0xaebb>
 107a52f:	mov    %eax,%eax
 107a531:	shl    $0x4,%rax
 107a535:	add    $0x10,%rax
 107a539:	cmp    %rcx,%rax
 107a53c:	ja     107824b <check_input_run+0xaebb>
 107a542:	add    %rax,%rsi
 107a545:	cmpq   $0x0,0x68(%rsp)
 107a54b:	vpxor  %xmm0,%xmm0,%xmm0
 107a54f:	mov    %rsi,0x2ac40(%r8)
 107a556:	vmovdqu64 %zmm0,0x7c0(%rsp)
 107a55e:	vmovdqu64 %zmm0,0x780(%rsp)
 107a566:	vmovdqu64 %zmm0,0x740(%rsp)
 107a56e:	vmovdqu64 %zmm0,0x700(%rsp)
 107a576:	je     107a9c8 <check_input_run+0xd638>
 107a57c:	xor    %ebp,%ebp
 107a57e:	test   %r12,%r12
 107a581:	je     107a744 <check_input_run+0xd3b4>
 107a587:	mov    0x70(%rsp),%rax
 107a58c:	add    $0x30,%rax
 107a590:	mov    %rax,0x110(%rsp)
 107a598:	mov    $0x1,%eax
 107a59d:	mov    %rax,0xb8(%rsp)
 107a5a5:	movq   $0x0,0x98(%rsp)
 107a5b1:	mov    0x98(%rsp),%rax
 107a5b9:	mov    %eax,%eax
 107a5bb:	mov    %rax,0x98(%rsp)
 107a5c3:	imul   $0x38,%rax,%rax
 107a5c7:	mov    %rax,0x60(%rsp)
 107a5cc:	jmp    107a63a <check_input_run+0xd2aa>
 107a5ce:	mov    (%rcx),%rdx
 107a5d1:	test   %rdx,%rdx
 107a5d4:	jne    107a695 <check_input_run+0xd305>
 107a5da:	xor    %eax,%eax
 107a5dc:	lea    0x700(%rsp),%rcx
 107a5e4:	mov    0x70(%rsp),%rbx
 107a5e9:	mov    0xa0(%rsp),%rdi
 107a5f1:	mov    0x68(%rsp),%r8
 107a5f6:	lea    0x780(%rsp),%r9
 107a5fe:	mov    %rax,%rdx
 107a601:	mov    %rcx,(%rsp)
 107a605:	mov    0x88(%rsp),%rcx
 107a60d:	mov    %rbx,%rsi
 107a610:	vzeroupper
 107a613:	call   10f9db0 <type_replay_change>
 107a618:	mov    %rbx,%r10
 107a61b:	mov    0xe8(%rsp),%r9
 107a623:	mov    0xc0(%rsp),%rbx
 107a62b:	inc    %ebp
 107a62d:	xor    %edx,%edx
 107a62f:	mov    %r12,%r14
 107a632:	test   %al,%al
 107a634:	je     1078250 <check_input_run+0xaec0>
 107a63a:	mov    0x110(%rsp),%rax
 107a642:	mov    (%rax),%rcx
 107a645:	mov    0x98(%rsp),%rax
 107a64d:	cmp    0x8(%rcx),%eax
 107a650:	je     107a70c <check_input_run+0xd37c>
 107a656:	mov    0x70(%rsp),%rax
 107a65b:	mov    (%rax),%rax
 107a65e:	cmp    0x8(%rax),%ebp
 107a661:	jae    107a5ce <check_input_run+0xd23e>
 107a667:	mov    (%rax),%rsi
 107a66a:	mov    (%rcx),%rdx
 107a66d:	mov    %ebp,%eax
 107a66f:	imul   $0x38,%rax,%rax
 107a673:	add    %rsi,%rax
 107a676:	test   %rdx,%rdx
 107a679:	je     107a5dc <check_input_run+0xd24c>
 107a67f:	add    0x60(%rsp),%rdx
 107a684:	test   %rsi,%rsi
 107a687:	je     107a69a <check_input_run+0xd30a>
 107a689:	mov    (%rax),%ecx
 107a68b:	cmp    (%rdx),%ecx
 107a68d:	jbe    107a5dc <check_input_run+0xd24c>
 107a693:	jmp    107a69a <check_input_run+0xd30a>
 107a695:	add    0x60(%rsp),%rdx
 107a69a:	mov    0xa0(%rsp),%rdi
 107a6a2:	mov    0x110(%rsp),%rsi
 107a6aa:	mov    0x88(%rsp),%rcx
 107a6b2:	mov    0x68(%rsp),%r8
 107a6b7:	lea    0x700(%rsp),%rax
 107a6bf:	lea    0x780(%rsp),%r9
 107a6c7:	mov    %rax,(%rsp)
 107a6cb:	vzeroupper
 107a6ce:	call   10f9db0 <type_replay_change>
 107a6d3:	mov    0x98(%rsp),%rcx
 107a6db:	mov    0xe8(%rsp),%r9
 107a6e3:	mov    0xc0(%rsp),%rbx
 107a6eb:	mov    0x70(%rsp),%r10
 107a6f0:	xor    %edx,%edx
 107a6f2:	mov    %r12,%r14
 107a6f5:	inc    %ecx
 107a6f7:	mov    %rcx,0x98(%rsp)
 107a6ff:	test   %al,%al
 107a701:	jne    107a5b1 <check_input_run+0xd221>
 107a707:	jmp    1078250 <check_input_run+0xaec0>
 107a70c:	mov    0xb8(%rsp),%rax
 107a714:	inc    %rax
 107a717:	lea    (%rax,%rax,2),%rcx
 107a71b:	mov    %rax,0xb8(%rsp)
 107a723:	shl    $0x4,%rcx
 107a727:	add    0x70(%rsp),%rcx
 107a72c:	mov    %rcx,0x110(%rsp)
 107a734:	cmp    0xd8(%rsp),%rax
 107a73c:	jne    107a5a5 <check_input_run+0xd215>
 107a742:	mov    %ebp,%ebp
 107a744:	mov    0x70(%rsp),%r10
 107a749:	imul   $0x38,%rbp,%rax
 107a74d:	dec    %rbp
 107a750:	add    $0xffffffffffffffc8,%rax
 107a754:	mov    %rax,0x98(%rsp)
 107a75c:	mov    (%r10),%rax
 107a75f:	inc    %rbp
 107a762:	mov    0x8(%rax),%ecx
 107a765:	cmp    %rcx,%rbp
 107a768:	jae    107aa85 <check_input_run+0xd6f5>
 107a76e:	mov    0x98(%rsp),%rcx
 107a776:	mov    (%rax),%rdx
 107a779:	mov    0x70(%rsp),%rbx
 107a77e:	mov    0xa0(%rsp),%rdi
 107a786:	mov    0x68(%rsp),%r8
 107a78b:	lea    0x700(%rsp),%rax
 107a793:	lea    0x780(%rsp),%r9
 107a79b:	mov    %rax,(%rsp)
 107a79f:	add    $0x38,%rcx
 107a7a3:	mov    %rbx,%rsi
 107a7a6:	mov    %rcx,0x98(%rsp)
 107a7ae:	add    %rcx,%rdx
 107a7b1:	mov    0x88(%rsp),%rcx
 107a7b9:	vzeroupper
 107a7bc:	call   10f9db0 <type_replay_change>
 107a7c1:	mov    %rbx,%r10
 107a7c4:	mov    0xe8(%rsp),%r9
 107a7cc:	mov    0xc0(%rsp),%rbx
 107a7d4:	xor    %edx,%edx
 107a7d6:	mov    %r12,%r14
 107a7d9:	test   %al,%al
 107a7db:	jne    107a75c <check_input_run+0xd3cc>
 107a7e1:	jmp    1078250 <check_input_run+0xaec0>
 107a7e6:	cmp    %esi,%ecx
 107a7e8:	jae    1079731 <check_input_run+0xc3a1>
 107a7ee:	jmp    1079733 <check_input_run+0xc3a3>
 107a7f3:	mov    0x860(%rsp),%r12
 107a7fb:	jmp    1076dec <check_input_run+0x9a5c>
 107a800:	mov    0x10(%r14),%rdx
 107a804:	cmpb   $0x11,(%rdx,%rsi,1)
 107a808:	sete   %dl
 107a80b:	jmp    1079733 <check_input_run+0xc3a3>
 107a810:	mov    0x20(%rsp),%r12
 107a815:	mov    0x28(%rsp),%r9
 107a81a:	add    %rdx,%rsi
 107a81d:	mov    %rax,%r14
 107a820:	mov    %r15,%rdi
 107a823:	mov    %rsi,0x8(%rcx)
 107a827:	xor    %ecx,%ecx
 107a829:	jmp    10715e0 <check_input_run+0x4250>
 107a82e:	mov    0x78(%rsp),%rdx
 107a833:	mov    0x10(%rsp),%rdi
 107a838:	mov    0x18(%rsp),%r8
 107a83d:	inc    %rdx
 107a840:	add    %rdx,%rsi
 107a843:	mov    %rsi,0x8(%rdi)
 107a847:	lea    0x268(%r8),%rdi
 107a84e:	mov    %rcx,0x268(%r8)
 107a855:	mov    %rdi,0x40(%rsp)
 107a85a:	test   %rcx,%rcx
 107a85d:	je     107a8a8 <check_input_run+0xd518>
 107a85f:	mov    0x10(%rsp),%rcx
 107a864:	mov    (%rcx),%rdi
 107a867:	mov    0x8(%rcx),%rsi
 107a86b:	lea    0x7(%rsi,%rdi,1),%rcx
 107a870:	add    %rdi,%rsi
 107a873:	and    $0xfffffffffffffff8,%rcx
 107a877:	cmp    %rsi,%rcx
 107a87a:	jb     107a8a8 <check_input_run+0xd518>
 107a87c:	mov    %rcx,%rsi
 107a87f:	sub    %rdi,%rsi
 107a882:	mov    0x10(%rsp),%rdi
 107a887:	mov    0x10(%rdi),%rdi
 107a88b:	sub    %rsi,%rdi
 107a88e:	setb   %r8b
 107a892:	cmp    0x78(%rsp),%rdi
 107a897:	setbe  %dil
 107a89b:	or     %r8b,%dil
 107a89e:	cmp    $0x1,%dil
 107a8a2:	jne    107a939 <check_input_run+0xd5a9>
 107a8a8:	mov    0x18(%rsp),%rdi
 107a8ad:	mov    0x10(%rsp),%rsi
 107a8b2:	mov    0x20(%rsp),%r12
 107a8b7:	mov    0x40(%rsp),%rax
 107a8bc:	mov    0x30(%rsp),%r9
 107a8c1:	jmp    106dbe8 <check_input_run+0x858>
 107a8c6:	mov    0x860(%rsp),%r12
 107a8ce:	movq   $0x0,0x2aa38(%r12,%rdx,8)
 107a8da:	jmp    1076dec <check_input_run+0x9a5c>
 107a8df:	lea    -0x9825d8(%rip),%rdi        # 6f830e <pp_string_value.meaning+0x6fb0d>
 107a8e6:	lea    -0x9c9326(%rip),%rsi        # 6b15c7 <pp_string_value.meaning+0x28dc6>
 107a8ed:	lea    -0x9c9312(%rip),%rcx        # 6b15e2 <pp_string_value.meaning+0x28de1>
 107a8f4:	mov    $0xbd,%edx
 107a8f9:	vzeroupper
 107a8fc:	call   787c60 <__assert_fail@plt>
 107a901:	vzeroupper
 107a904:	call   787bf0 <__stack_chk_fail@plt>
 107a909:	xor    %eax,%eax
 107a90b:	mov    0x860(%rsp),%r12
 107a913:	mov    $0x1,%bpl
 107a916:	mov    %r12,0x278(%rsp)
 107a91e:	mov    $0xffffffffffffffff,%rcx
 107a925:	cmpb   $0x0,0x2aca0(%r12)
 107a92e:	je     1076e17 <check_input_run+0x9a87>
 107a934:	jmp    1076e41 <check_input_run+0x9ab1>
 107a939:	mov    0x10(%rsp),%rdi
 107a93e:	mov    0x18(%rsp),%r8
 107a943:	add    %rdx,%rsi
 107a946:	mov    %rsi,0x8(%rdi)
 107a94a:	lea    0x250(%r8),%rdi
 107a951:	mov    %rcx,0x250(%r8)
 107a958:	mov    %rdi,0x98(%rsp)
 107a960:	test   %rcx,%rcx
 107a963:	je     107a9aa <check_input_run+0xd61a>
 107a965:	mov    0x10(%rsp),%rcx
 107a96a:	mov    (%rcx),%rdi
 107a96d:	mov    0x8(%rcx),%rsi
 107a971:	lea    0x7(%rsi,%rdi,1),%rcx
 107a976:	add    %rdi,%rsi
 107a979:	and    $0xfffffffffffffff8,%rcx
 107a97d:	cmp    %rsi,%rcx
 107a980:	jb     107a9aa <check_input_run+0xd61a>
 107a982:	mov    %rcx,%rsi
 107a985:	sub    %rdi,%rsi
 107a988:	mov    0x10(%rsp),%rdi
 107a98d:	mov    0x10(%rdi),%rdi
 107a991:	sub    %rsi,%rdi
 107a994:	setb   %r8b
 107a998:	cmp    0x78(%rsp),%rdi
 107a99d:	setbe  %dil
 107a9a1:	or     %r8b,%dil
 107a9a4:	cmp    $0x1,%dil
 107a9a8:	jne    107a9e7 <check_input_run+0xd657>
 107a9aa:	mov    0x18(%rsp),%rdi
 107a9af:	mov    0x10(%rsp),%rsi
 107a9b4:	mov    0x20(%rsp),%r12
 107a9b9:	mov    0x40(%rsp),%rax
 107a9be:	mov    0x30(%rsp),%r9
 107a9c3:	jmp    106dc02 <check_input_run+0x872>
 107a9c8:	xor    %edx,%edx
 107a9ca:	mov    0xe8(%rsp),%r9
 107a9d2:	mov    0xc0(%rsp),%rbx
 107a9da:	mov    0x70(%rsp),%r10
 107a9df:	mov    %r12,%r14
 107a9e2:	jmp    1078250 <check_input_run+0xaec0>
 107a9e7:	mov    0x10(%rsp),%rdi
 107a9ec:	mov    0x18(%rsp),%r8
 107a9f1:	add    %rdx,%rsi
 107a9f4:	mov    %rsi,0x8(%rdi)
 107a9f8:	lea    0x258(%r8),%rdi
 107a9ff:	mov    %rcx,0x258(%r8)
 107aa06:	mov    %rdi,0x110(%rsp)
 107aa0e:	test   %rcx,%rcx
 107aa11:	je     107aa5c <check_input_run+0xd6cc>
 107aa13:	mov    0x10(%rsp),%rcx
 107aa18:	mov    (%rcx),%rdi
 107aa1b:	mov    0x8(%rcx),%rsi
 107aa1f:	lea    0x7(%rsi,%rdi,1),%rcx
 107aa24:	add    %rdi,%rsi
 107aa27:	and    $0xfffffffffffffff8,%rcx
 107aa2b:	cmp    %rsi,%rcx
 107aa2e:	jb     107aa5c <check_input_run+0xd6cc>
 107aa30:	mov    %rcx,%rsi
 107aa33:	sub    %rdi,%rsi
 107aa36:	mov    0x10(%rsp),%rdi
 107aa3b:	mov    0x10(%rdi),%rdi
 107aa3f:	sub    %rsi,%rdi
 107aa42:	setb   %r8b
 107aa46:	cmp    0x78(%rsp),%rdi
 107aa4b:	setbe  %dil
 107aa4f:	or     %r8b,%dil
 107aa52:	cmp    $0x1,%dil
 107aa56:	jne    107acc3 <check_input_run+0xd933>
 107aa5c:	mov    0x18(%rsp),%rdi
 107aa61:	mov    0x10(%rsp),%rsi
 107aa66:	mov    0x20(%rsp),%r12
 107aa6b:	mov    0x40(%rsp),%rax
 107aa70:	mov    0x30(%rsp),%r9
 107aa75:	movq   $0x0,0x270(%rdi)
 107aa80:	jmp    106dc27 <check_input_run+0x897>
 107aa85:	mov    0xd8(%rsp),%rax
 107aa8d:	and    $0x3,%eax
 107aa90:	cmpl   $0x4,0x100(%rsp)
 107aa98:	jae    107aaad <check_input_run+0xd71d>
 107aa9a:	xor    %r9d,%r9d
 107aa9d:	xor    %ecx,%ecx
 107aa9f:	xor    %esi,%esi
 107aaa1:	xor    %edi,%edi
 107aaa3:	xor    %edx,%edx
 107aaa5:	xor    %r8d,%r8d
 107aaa8:	jmp    107ac39 <check_input_run+0xd8a9>
 107aaad:	mov    0xd8(%rsp),%rcx
 107aab5:	mov    0x70(%rsp),%r10
 107aaba:	xor    %r9d,%r9d
 107aabd:	xor    %esi,%esi
 107aabf:	xor    %edi,%edi
 107aac1:	xor    %edx,%edx
 107aac3:	xor    %r8d,%r8d
 107aac6:	and    $0xfffffffc,%ecx
 107aac9:	mov    %rcx,0xd8(%rsp)
 107aad1:	xor    %ecx,%ecx
 107aad3:	jmp    107ab02 <check_input_run+0xd772>
 107aad5:	mov    0x40(%r11),%edx
 107aad9:	mov    0x44(%r11),%esi
 107aadd:	mov    0x48(%r11),%ecx
 107aae1:	mov    $0x1,%edi
 107aae6:	mov    $0x1,%r8b
 107aae9:	add    $0x4,%r9
 107aaed:	add    $0xc0,%r10
 107aaf4:	cmp    %r9,0xd8(%rsp)
 107aafc:	je     107ac34 <check_input_run+0xd8a4>
 107ab02:	mov    (%r10),%r14
 107ab05:	xor    %r11d,%r11d
 107ab08:	test   %r9,%r9
 107ab0b:	mov    $0x1,%bpl
 107ab0e:	setne  %r11b
 107ab12:	cmp    $0x1,%r8b
 107ab16:	jne    107ab1e <check_input_run+0xd78e>
 107ab18:	cmp    %edx,0x40(%r14)
 107ab1c:	jbe    107ab3e <check_input_run+0xd7ae>
 107ab1e:	cmpb   $0x1,0x3c(%r14)
 107ab23:	jne    107ab54 <check_input_run+0xd7c4>
 107ab25:	test   %bpl,%bpl
 107ab28:	je     107ab54 <check_input_run+0xd7c4>
 107ab2a:	mov    0x40(%r14),%edx
 107ab2e:	mov    0x44(%r14),%esi
 107ab32:	mov    0x48(%r14),%ecx
 107ab36:	mov    $0x1,%r8b
 107ab39:	mov    %r11d,%edi
 107ab3c:	jmp    107ab54 <check_input_run+0xd7c4>
 107ab3e:	jne    107ab51 <check_input_run+0xd7c1>
 107ab40:	cmp    %r11d,%edi
 107ab43:	jb     107ab1e <check_input_run+0xd78e>
 107ab45:	jne    107ab51 <check_input_run+0xd7c1>
 107ab47:	cmp    %esi,0x44(%r14)
 107ab4b:	seta   %bpl
 107ab4f:	jmp    107ab1e <check_input_run+0xd78e>
 107ab51:	mov    $0x1,%r8b
 107ab54:	mov    0x30(%r10),%r11
 107ab58:	mov    $0x1,%bpl
 107ab5b:	cmp    $0x1,%r8b
 107ab5f:	jne    107ab67 <check_input_run+0xd7d7>
 107ab61:	cmp    %edx,0x40(%r11)
 107ab65:	jbe    107ab86 <check_input_run+0xd7f6>
 107ab67:	cmpb   $0x1,0x3c(%r11)
 107ab6c:	jne    107ab9e <check_input_run+0xd80e>
 107ab6e:	test   %bpl,%bpl
 107ab71:	je     107ab9e <check_input_run+0xd80e>
 107ab73:	mov    0x40(%r11),%edx
 107ab77:	mov    0x44(%r11),%esi
 107ab7b:	mov    0x48(%r11),%ecx
 107ab7f:	mov    $0x1,%edi
 107ab84:	jmp    107ab9b <check_input_run+0xd80b>
 107ab86:	jne    107ab9b <check_input_run+0xd80b>
 107ab88:	test   %edi,%edi
 107ab8a:	je     107ab67 <check_input_run+0xd7d7>
 107ab8c:	cmp    $0x1,%edi
 107ab8f:	jne    107ab9b <check_input_run+0xd80b>
 107ab91:	cmp    %esi,0x44(%r11)
 107ab95:	seta   %bpl
 107ab99:	jmp    107ab67 <check_input_run+0xd7d7>
 107ab9b:	mov    $0x1,%r8b
 107ab9e:	mov    0x60(%r10),%r11
 107aba2:	mov    $0x1,%bpl
 107aba5:	cmp    $0x1,%r8b
 107aba9:	jne    107abb1 <check_input_run+0xd821>
 107abab:	cmp    %edx,0x40(%r11)
 107abaf:	jbe    107abd0 <check_input_run+0xd840>
 107abb1:	cmpb   $0x1,0x3c(%r11)
 107abb6:	jne    107abe8 <check_input_run+0xd858>
 107abb8:	test   %bpl,%bpl
 107abbb:	je     107abe8 <check_input_run+0xd858>
 107abbd:	mov    0x40(%r11),%edx
 107abc1:	mov    0x44(%r11),%esi
 107abc5:	mov    0x48(%r11),%ecx
 107abc9:	mov    $0x1,%edi
 107abce:	jmp    107abe5 <check_input_run+0xd855>
 107abd0:	jne    107abe5 <check_input_run+0xd855>
 107abd2:	test   %edi,%edi
 107abd4:	je     107abb1 <check_input_run+0xd821>
 107abd6:	cmp    $0x1,%edi
 107abd9:	jne    107abe5 <check_input_run+0xd855>
 107abdb:	cmp    %esi,0x44(%r11)
 107abdf:	seta   %bpl
 107abe3:	jmp    107abb1 <check_input_run+0xd821>
 107abe5:	mov    $0x1,%r8b
 107abe8:	mov    0x90(%r10),%r11
 107abef:	mov    $0x1,%bpl
 107abf2:	cmp    $0x1,%r8b
 107abf6:	jne    107abfe <check_input_run+0xd86e>
 107abf8:	cmp    %edx,0x40(%r11)
 107abfc:	jbe    107ac17 <check_input_run+0xd887>
 107abfe:	cmpb   $0x1,0x3c(%r11)
 107ac03:	jne    107aae9 <check_input_run+0xd759>
 107ac09:	test   %bpl,%bpl
 107ac0c:	jne    107aad5 <check_input_run+0xd745>
 107ac12:	jmp    107aae9 <check_input_run+0xd759>
 107ac17:	jne    107aae6 <check_input_run+0xd756>
 107ac1d:	test   %edi,%edi
 107ac1f:	je     107abfe <check_input_run+0xd86e>
 107ac21:	cmp    $0x1,%edi
 107ac24:	jne    107aae6 <check_input_run+0xd756>
 107ac2a:	cmp    %esi,0x44(%r11)
 107ac2e:	seta   %bpl
 107ac32:	jmp    107abfe <check_input_run+0xd86e>
 107ac34:	test   %rax,%rax
 107ac37:	je     107aca4 <check_input_run+0xd914>
 107ac39:	shl    $0x4,%r9
 107ac3d:	lea    (%r9,%r9,2),%r9
 107ac41:	jmp    107ac4f <check_input_run+0xd8bf>
 107ac43:	mov    $0x1,%r8b
 107ac46:	add    $0x30,%r9
 107ac4a:	dec    %rax
 107ac4d:	je     107aca4 <check_input_run+0xd914>
 107ac4f:	mov    0x70(%rsp),%r10
 107ac54:	mov    $0x1,%bpl
 107ac57:	mov    (%r10,%r9,1),%r11
 107ac5b:	xor    %r10d,%r10d
 107ac5e:	test   %r9,%r9
 107ac61:	setne  %r10b
 107ac65:	cmp    $0x1,%r8b
 107ac69:	jne    107ac71 <check_input_run+0xd8e1>
 107ac6b:	cmp    %edx,0x40(%r11)
 107ac6f:	jbe    107ac91 <check_input_run+0xd901>
 107ac71:	cmpb   $0x1,0x3c(%r11)
 107ac76:	jne    107ac46 <check_input_run+0xd8b6>
 107ac78:	test   %bpl,%bpl
 107ac7b:	je     107ac46 <check_input_run+0xd8b6>
 107ac7d:	mov    0x40(%r11),%edx
 107ac81:	mov    0x44(%r11),%esi
 107ac85:	mov    0x48(%r11),%ecx
 107ac89:	mov    $0x1,%r8b
 107ac8c:	mov    %r10d,%edi
 107ac8f:	jmp    107ac46 <check_input_run+0xd8b6>
 107ac91:	jne    107ac43 <check_input_run+0xd8b3>
 107ac93:	cmp    %r10d,%edi
 107ac96:	jb     107ac71 <check_input_run+0xd8e1>
 107ac98:	jne    107ac43 <check_input_run+0xd8b3>
 107ac9a:	cmp    %esi,0x44(%r11)
 107ac9e:	seta   %bpl
 107aca2:	jmp    107ac71 <check_input_run+0xd8e1>
 107aca4:	mov    $0x1,%dl
 107aca6:	test   $0x1,%r8b
 107acaa:	je     107a9ca <check_input_run+0xd63a>
 107acb0:	mov    0xa0(%rsp),%rax
 107acb8:	mov    %ecx,0x100(%rax)
 107acbe:	jmp    107a9ca <check_input_run+0xd63a>
 107acc3:	mov    0x10(%rsp),%rdi
 107acc8:	add    %rdx,%rsi
 107accb:	mov    %rsi,0x8(%rdi)
 107accf:	mov    0x18(%rsp),%rdi
 107acd4:	mov    %rcx,0x270(%rdi)
 107acdb:	test   %rcx,%rcx
 107acde:	je     107ad25 <check_input_run+0xd995>
 107ace0:	mov    0x10(%rsp),%rcx
 107ace5:	mov    (%rcx),%rdi
 107ace8:	mov    0x8(%rcx),%rsi
 107acec:	lea    0x7(%rsi,%rdi,1),%rcx
 107acf1:	add    %rdi,%rsi
 107acf4:	and    $0xfffffffffffffff8,%rcx
 107acf8:	cmp    %rsi,%rcx
 107acfb:	jb     107ad25 <check_input_run+0xd995>
 107acfd:	mov    %rcx,%rsi
 107ad00:	sub    %rdi,%rsi
 107ad03:	mov    0x10(%rsp),%rdi
 107ad08:	mov    0x10(%rdi),%rdi
 107ad0c:	sub    %rsi,%rdi
 107ad0f:	setb   %r8b
 107ad13:	cmp    0x78(%rsp),%rdi
 107ad18:	setbe  %dil
 107ad1c:	or     %r8b,%dil
 107ad1f:	cmp    $0x1,%dil
 107ad23:	jne    107ad43 <check_input_run+0xd9b3>
 107ad25:	mov    0x18(%rsp),%rdi
 107ad2a:	mov    0x10(%rsp),%rsi
 107ad2f:	mov    0x20(%rsp),%r12
 107ad34:	mov    0x40(%rsp),%rax
 107ad39:	mov    0x30(%rsp),%r9
 107ad3e:	jmp    106dc27 <check_input_run+0x897>
 107ad43:	mov    0x10(%rsp),%rdi
 107ad48:	mov    0x18(%rsp),%r8
 107ad4d:	add    %rdx,%rsi
 107ad50:	mov    %rsi,0x8(%rdi)
 107ad54:	lea    0x278(%r8),%rdi
 107ad5b:	mov    %rcx,0x278(%r8)
 107ad62:	mov    %rdi,0x60(%rsp)
 107ad67:	test   %rcx,%rcx
 107ad6a:	je     107adb1 <check_input_run+0xda21>
 107ad6c:	mov    0x10(%rsp),%rcx
 107ad71:	mov    (%rcx),%rdi
 107ad74:	mov    0x8(%rcx),%rsi
 107ad78:	lea    0x7(%rsi,%rdi,1),%rcx
 107ad7d:	add    %rdi,%rsi
 107ad80:	and    $0xfffffffffffffff8,%rcx
 107ad84:	cmp    %rsi,%rcx
 107ad87:	jb     107adb1 <check_input_run+0xda21>
 107ad89:	mov    %rcx,%rsi
 107ad8c:	sub    %rdi,%rsi
 107ad8f:	mov    0x10(%rsp),%rdi
 107ad94:	mov    0x10(%rdi),%rdi
 107ad98:	sub    %rsi,%rdi
 107ad9b:	setb   %r8b
 107ad9f:	cmp    0x78(%rsp),%rdi
 107ada4:	setbe  %dil
 107ada8:	or     %r8b,%dil
 107adab:	cmp    $0x1,%dil
 107adaf:	jne    107adcf <check_input_run+0xda3f>
 107adb1:	mov    0x18(%rsp),%rdi
 107adb6:	mov    0x10(%rsp),%rsi
 107adbb:	mov    0x20(%rsp),%r12
 107adc0:	mov    0x40(%rsp),%rax
 107adc5:	mov    0x30(%rsp),%r9
 107adca:	jmp    106dc3e <check_input_run+0x8ae>
 107adcf:	mov    0x10(%rsp),%rdi
 107add4:	mov    0x18(%rsp),%r8
 107add9:	add    %rdx,%rsi
 107addc:	mov    %rsi,0x8(%rdi)
 107ade0:	lea    0x280(%r8),%rdi
 107ade7:	mov    %rcx,0x280(%r8)
 107adee:	mov    %rdi,0xb8(%rsp)
 107adf6:	test   %rcx,%rcx
 107adf9:	je     107ae18 <check_input_run+0xda88>
 107adfb:	mov    0x10(%rsp),%rcx
 107ae00:	mov    (%rcx),%rdi
 107ae03:	mov    0x8(%rcx),%rsi
 107ae07:	lea    0x7(%rsi,%rdi,1),%rcx
 107ae0c:	add    %rdi,%rsi
 107ae0f:	and    $0xfffffffffffffff8,%rcx
 107ae13:	cmp    %rsi,%rcx
 107ae16:	jae    107ae36 <check_input_run+0xdaa6>
 107ae18:	mov    0x18(%rsp),%rdi
 107ae1d:	mov    0x10(%rsp),%rsi
 107ae22:	mov    0x20(%rsp),%r12
 107ae27:	mov    0x40(%rsp),%rax
 107ae2c:	mov    0x30(%rsp),%r9
 107ae31:	jmp    106dc58 <check_input_run+0x8c8>
 107ae36:	mov    %rcx,%rsi
 107ae39:	sub    %rdi,%rsi
 107ae3c:	mov    0x10(%rsp),%rdi
 107ae41:	mov    0x10(%rdi),%rdi
 107ae45:	sub    %rsi,%rdi
 107ae48:	jb     107ae18 <check_input_run+0xda88>
 107ae4a:	mov    0x78(%rsp),%r8
 107ae4f:	lea    0x8(,%r8,8),%r8
 107ae57:	cmp    %rdi,%r8
 107ae5a:	ja     107ae18 <check_input_run+0xda88>
 107ae5c:	add    %r8,%rsi
 107ae5f:	mov    0x10(%rsp),%rdi
 107ae64:	mov    0x18(%rsp),%r8
 107ae69:	mov    %rsi,0x8(%rdi)
 107ae6d:	lea    0x288(%r8),%rdi
 107ae74:	mov    %rcx,0x288(%r8)
 107ae7b:	mov    %rdi,0x50(%rsp)
 107ae80:	test   %rcx,%rcx
 107ae83:	je     107aece <check_input_run+0xdb3e>
 107ae85:	mov    0x10(%rsp),%rcx
 107ae8a:	mov    (%rcx),%rdi
 107ae8d:	mov    0x8(%rcx),%rsi
 107ae91:	lea    0x7(%rsi,%rdi,1),%rcx
 107ae96:	add    %rdi,%rsi
 107ae99:	and    $0xfffffffffffffff8,%rcx
 107ae9d:	cmp    %rsi,%rcx
 107aea0:	jb     107aece <check_input_run+0xdb3e>
 107aea2:	mov    %rcx,%rsi
 107aea5:	sub    %rdi,%rsi
 107aea8:	mov    0x10(%rsp),%rdi
 107aead:	mov    0x10(%rdi),%rdi
 107aeb1:	sub    %rsi,%rdi
 107aeb4:	setb   %r8b
 107aeb8:	cmp    0x78(%rsp),%rdi
 107aebd:	setbe  %dil
 107aec1:	or     %r8b,%dil
 107aec4:	cmp    $0x1,%dil
 107aec8:	jne    107cf17 <check_input_run+0xfb87>
 107aece:	mov    0x18(%rsp),%rdi
 107aed3:	mov    0x10(%rsp),%rsi
 107aed8:	mov    0x20(%rsp),%r12
 107aedd:	mov    0x40(%rsp),%rax
 107aee2:	mov    0x30(%rsp),%r9
 107aee7:	movq   $0x0,0x290(%rdi)
 107aef2:	movq   $0x0,0x298(%rdi)
 107aefd:	jmp    106dc85 <check_input_run+0x8f5>
 107af02:	mov    0x1b0(%rsp),%r14
 107af0a:	mov    0x60(%rsp),%r8
 107af0f:	shr    $0x3,%r8d
 107af13:	xor    %r10d,%r10d
 107af16:	imul   $0xa80,%r8,%r9
 107af1d:	xor    %r8d,%r8d
 107af20:	mov    (%r14),%r11
 107af23:	mov    0xb0(%r11,%r10,1),%r11d
 107af2b:	mov    %r11d,(%rsi,%r8,4)
 107af2f:	mov    (%r14),%r11
 107af32:	mov    0x200(%r11,%r10,1),%r11d
 107af3a:	mov    %r11d,0x4(%rsi,%r8,4)
 107af3f:	mov    (%r14),%r11
 107af42:	mov    0x350(%r11,%r10,1),%r11d
 107af4a:	mov    %r11d,0x8(%rsi,%r8,4)
 107af4f:	mov    (%r14),%r11
 107af52:	mov    0x4a0(%r11,%r10,1),%r11d
 107af5a:	mov    %r11d,0xc(%rsi,%r8,4)
 107af5f:	mov    (%r14),%r11
 107af62:	mov    0x5f0(%r11,%r10,1),%r11d
 107af6a:	mov    %r11d,0x10(%rsi,%r8,4)
 107af6f:	mov    (%r14),%r11
 107af72:	mov    0x740(%r11,%r10,1),%r11d
 107af7a:	mov    %r11d,0x14(%rsi,%r8,4)
 107af7f:	mov    (%r14),%r11
 107af82:	mov    0x890(%r11,%r10,1),%r11d
 107af8a:	mov    %r11d,0x18(%rsi,%r8,4)
 107af8f:	mov    (%r14),%r11
 107af92:	mov    0x9e0(%r11,%r10,1),%r11d
 107af9a:	add    $0xa80,%r10
 107afa1:	mov    %r11d,0x1c(%rsi,%r8,4)
 107afa6:	add    $0x8,%r8
 107afaa:	cmp    %r10,%r9
 107afad:	jne    107af20 <check_input_run+0xdb90>
 107afb3:	test   %rdi,%rdi
 107afb6:	je     107afec <check_input_run+0xdc5c>
 107afb8:	lea    (%rsi,%r8,4),%r9
 107afbc:	imul   $0x150,%r8,%r8
 107afc3:	xor    %r10d,%r10d
 107afc6:	mov    0x1b0(%rsp),%r11
 107afce:	mov    (%r11),%r11
 107afd1:	mov    0xb0(%r11,%r8,1),%r11d
 107afd9:	add    $0x150,%r8
 107afe0:	mov    %r11d,(%r9,%r10,4)
 107afe4:	inc    %r10
 107afe7:	cmp    %r10,%rdi
 107afea:	jne    107afc6 <check_input_run+0xdc36>
 107afec:	mov    0x68(%rsp),%r10
 107aff1:	lea    0x1(%r10),%r8d
 107aff5:	cmp    $0x1,%r8d
 107aff9:	adc    $0x1,%r10d
 107affd:	mov    %r10d,%edi
 107b000:	and    $0x3,%edi
 107b003:	cmp    $0x4,%r8d
 107b007:	jae    107b020 <check_input_run+0xdc90>
 107b009:	xor    %r8d,%r8d
 107b00c:	xor    %r9d,%r9d
 107b00f:	movq   $0x0,0xb0(%rsp)
 107b01b:	jmp    107b25a <check_input_run+0xdeca>
 107b020:	and    $0xfffffffc,%r10d
 107b024:	xor    %r8d,%r8d
 107b027:	xor    %r9d,%r9d
 107b02a:	movq   $0x0,0xb0(%rsp)
 107b036:	jmp    107b045 <check_input_run+0xdcb5>
 107b038:	add    $0x4,%r8
 107b03c:	cmp    %r10,%r8
 107b03f:	je     107b251 <check_input_run+0xdec1>
 107b045:	mov    0x28(%rsp),%rcx
 107b04a:	cmp    (%rcx),%r9d
 107b04d:	jae    107b0ab <check_input_run+0xdd1b>
 107b04f:	mov    %r9d,%r9d
 107b052:	lea    (%r9,%r9,2),%r11
 107b056:	lea    0x6(,%r11,4),%r11
 107b05e:	mov    0x860(%rsp),%r14
 107b066:	mov    0x1d0(%r14),%r14
 107b06d:	cmp    %r8d,(%r14,%r11,4)
 107b071:	ja     107b0ab <check_input_run+0xdd1b>
 107b073:	mov    0xb0(%rsp),%r15
 107b07b:	mov    0x80(%rsp),%r14
 107b083:	mov    0x28(%rsp),%rcx
 107b088:	add    $0xc,%r11
 107b08c:	lea    (%r15,%r8,1),%ebp
 107b090:	mov    %ebp,(%r14,%r9,4)
 107b094:	add    (%rsi,%r9,4),%r15d
 107b098:	mov    (%rcx),%r14d
 107b09b:	inc    %r9
 107b09e:	mov    %r15,0xb0(%rsp)
 107b0a6:	cmp    %r14,%r9
 107b0a9:	jb     107b05e <check_input_run+0xdcce>
 107b0ab:	cmp    0x68(%rsp),%r8
 107b0b0:	jae    107b0c2 <check_input_run+0xdd32>
 107b0b2:	mov    0xb0(%rsp),%r11
 107b0ba:	add    %r8d,%r11d
 107b0bd:	mov    %r11d,0x0(%r13,%r8,4)
 107b0c2:	mov    0x28(%rsp),%rcx
 107b0c7:	lea    0x1(%r8),%r11
 107b0cb:	cmp    (%rcx),%r9d
 107b0ce:	jae    107b12c <check_input_run+0xdd9c>
 107b0d0:	mov    %r9d,%r9d
 107b0d3:	lea    (%r9,%r9,2),%r14
 107b0d7:	lea    0x6(,%r14,4),%r14
 107b0df:	mov    0x860(%rsp),%r15
 107b0e7:	mov    0x1d0(%r15),%r15
 107b0ee:	cmp    %r11d,(%r15,%r14,4)
 107b0f2:	ja     107b12c <check_input_run+0xdd9c>
 107b0f4:	mov    0xb0(%rsp),%r12
 107b0fc:	mov    0x80(%rsp),%r15
 107b104:	mov    0x28(%rsp),%rcx
 107b109:	add    $0xc,%r14
 107b10d:	lea    (%r12,%r11,1),%ebp
 107b111:	mov    %ebp,(%r15,%r9,4)
 107b115:	add    (%rsi,%r9,4),%r12d
 107b119:	mov    (%rcx),%r15d
 107b11c:	inc    %r9
 107b11f:	mov    %r12,0xb0(%rsp)
 107b127:	cmp    %r15,%r9
 107b12a:	jb     107b0df <check_input_run+0xdd4f>
 107b12c:	cmp    0x68(%rsp),%r11
 107b131:	jae    107b144 <check_input_run+0xddb4>
 107b133:	mov    0xb0(%rsp),%r14
 107b13b:	lea    (%r14,%r11,1),%ebp
 107b13f:	mov    %ebp,0x0(%r13,%r11,4)
 107b144:	mov    0x28(%rsp),%rcx
 107b149:	lea    0x2(%r8),%r11
 107b14d:	cmp    (%rcx),%r9d
 107b150:	jae    107b1ae <check_input_run+0xde1e>
 107b152:	mov    %r9d,%r9d
 107b155:	lea    (%r9,%r9,2),%r14
 107b159:	lea    0x6(,%r14,4),%r14
 107b161:	mov    0x860(%rsp),%r15
 107b169:	mov    0x1d0(%r15),%r15
 107b170:	cmp    %r11d,(%r15,%r14,4)
 107b174:	ja     107b1ae <check_input_run+0xde1e>
 107b176:	mov    0xb0(%rsp),%r12
 107b17e:	mov    0x80(%rsp),%r15
 107b186:	mov    0x28(%rsp),%rcx
 107b18b:	add    $0xc,%r14
 107b18f:	lea    (%r12,%r11,1),%ebp
 107b193:	mov    %ebp,(%r15,%r9,4)
 107b197:	add    (%rsi,%r9,4),%r12d
 107b19b:	mov    (%rcx),%r15d
 107b19e:	inc    %r9
 107b1a1:	mov    %r12,0xb0(%rsp)
 107b1a9:	cmp    %r15,%r9
 107b1ac:	jb     107b161 <check_input_run+0xddd1>
 107b1ae:	cmp    0x68(%rsp),%r11
 107b1b3:	jae    107b1c6 <check_input_run+0xde36>
 107b1b5:	mov    0xb0(%rsp),%r14
 107b1bd:	lea    (%r14,%r11,1),%ebp
 107b1c1:	mov    %ebp,0x0(%r13,%r11,4)
 107b1c6:	mov    0x28(%rsp),%rcx
 107b1cb:	lea    0x3(%r8),%r11
 107b1cf:	cmp    (%rcx),%r9d
 107b1d2:	jae    107b230 <check_input_run+0xdea0>
 107b1d4:	mov    %r9d,%r9d
 107b1d7:	lea    (%r9,%r9,2),%r14
 107b1db:	lea    0x6(,%r14,4),%r14
 107b1e3:	mov    0x860(%rsp),%r15
 107b1eb:	mov    0x1d0(%r15),%r15
 107b1f2:	cmp    %r11d,(%r15,%r14,4)
 107b1f6:	ja     107b230 <check_input_run+0xdea0>
 107b1f8:	mov    0xb0(%rsp),%r12
 107b200:	mov    0x80(%rsp),%r15
 107b208:	mov    0x28(%rsp),%rcx
 107b20d:	add    $0xc,%r14
 107b211:	lea    (%r12,%r11,1),%ebp
 107b215:	mov    %ebp,(%r15,%r9,4)
 107b219:	add    (%rsi,%r9,4),%r12d
 107b21d:	mov    (%rcx),%r15d
 107b220:	inc    %r9
 107b223:	mov    %r12,0xb0(%rsp)
 107b22b:	cmp    %r15,%r9
 107b22e:	jb     107b1e3 <check_input_run+0xde53>
 107b230:	cmp    0x68(%rsp),%r11
 107b235:	jae    107b038 <check_input_run+0xdca8>
 107b23b:	mov    0xb0(%rsp),%r14
 107b243:	lea    (%r14,%r11,1),%ebp
 107b247:	mov    %ebp,0x0(%r13,%r11,4)
 107b24c:	jmp    107b038 <check_input_run+0xdca8>
 107b251:	test   %rdi,%rdi
 107b254:	je     107b2f0 <check_input_run+0xdf60>
 107b25a:	xor    %r10d,%r10d
 107b25d:	jmp    107b26e <check_input_run+0xdede>
 107b25f:	inc    %r8
 107b262:	inc    %r10
 107b265:	cmp    %rdi,%r10
 107b268:	je     107b2f0 <check_input_run+0xdf60>
 107b26e:	mov    0x28(%rsp),%rcx
 107b273:	cmp    (%rcx),%r9d
 107b276:	jae    107b2d4 <check_input_run+0xdf44>
 107b278:	mov    %r9d,%r9d
 107b27b:	lea    (%r9,%r9,2),%r11
 107b27f:	lea    0x6(,%r11,4),%r11
 107b287:	mov    0x860(%rsp),%r14
 107b28f:	mov    0x1d0(%r14),%r14
 107b296:	cmp    %r8d,(%r14,%r11,4)
 107b29a:	ja     107b2d4 <check_input_run+0xdf44>
 107b29c:	mov    0xb0(%rsp),%r15
 107b2a4:	mov    0x80(%rsp),%r14
 107b2ac:	mov    0x28(%rsp),%rcx
 107b2b1:	add    $0xc,%r11
 107b2b5:	lea    (%r15,%r8,1),%ebp
 107b2b9:	mov    %ebp,(%r14,%r9,4)
 107b2bd:	add    (%rsi,%r9,4),%r15d
 107b2c1:	mov    (%rcx),%r14d
 107b2c4:	inc    %r9
 107b2c7:	mov    %r15,0xb0(%rsp)
 107b2cf:	cmp    %r14,%r9
 107b2d2:	jb     107b287 <check_input_run+0xdef7>
 107b2d4:	cmp    0x68(%rsp),%r8
 107b2d9:	jae    107b25f <check_input_run+0xdecf>
 107b2db:	mov    0xb0(%rsp),%r11
 107b2e3:	add    %r8d,%r11d
 107b2e6:	mov    %r11d,0x0(%r13,%r8,4)
 107b2eb:	jmp    107b25f <check_input_run+0xdecf>
 107b2f0:	cmpl   $0x0,0x60(%rsp)
 107b2f5:	je     107b3fe <check_input_run+0xe06e>
 107b2fb:	mov    0x60(%rsp),%r8
 107b300:	mov    %r8d,%edi
 107b303:	and    $0x7,%edi
 107b306:	cmp    $0x8,%r8d
 107b30a:	jae    107b314 <check_input_run+0xdf84>
 107b30c:	xor    %r8d,%r8d
 107b30f:	jmp    107b3ca <check_input_run+0xe03a>
 107b314:	mov    0x1b0(%rsp),%r14
 107b31c:	mov    0x60(%rsp),%r8
 107b321:	shr    $0x3,%r8d
 107b325:	xor    %r10d,%r10d
 107b328:	imul   $0xa80,%r8,%r9
 107b32f:	xor    %r8d,%r8d
 107b332:	mov    (%r14),%r11
 107b335:	mov    0xc0(%r11,%r10,1),%r11d
 107b33d:	mov    %r11d,(%rsi,%r8,4)
 107b341:	mov    (%r14),%r11
 107b344:	mov    0x210(%r11,%r10,1),%r11d
 107b34c:	mov    %r11d,0x4(%rsi,%r8,4)
 107b351:	mov    (%r14),%r11
 107b354:	mov    0x360(%r11,%r10,1),%r11d
 107b35c:	mov    %r11d,0x8(%rsi,%r8,4)
 107b361:	mov    (%r14),%r11
 107b364:	mov    0x4b0(%r11,%r10,1),%r11d
 107b36c:	mov    %r11d,0xc(%rsi,%r8,4)
 107b371:	mov    (%r14),%r11
 107b374:	mov    0x600(%r11,%r10,1),%r11d
 107b37c:	mov    %r11d,0x10(%rsi,%r8,4)
 107b381:	mov    (%r14),%r11
 107b384:	mov    0x750(%r11,%r10,1),%r11d
 107b38c:	mov    %r11d,0x14(%rsi,%r8,4)
 107b391:	mov    (%r14),%r11
 107b394:	mov    0x8a0(%r11,%r10,1),%r11d
 107b39c:	mov    %r11d,0x18(%rsi,%r8,4)
 107b3a1:	mov    (%r14),%r11
 107b3a4:	mov    0x9f0(%r11,%r10,1),%r11d
 107b3ac:	add    $0xa80,%r10
 107b3b3:	mov    %r11d,0x1c(%rsi,%r8,4)
 107b3b8:	add    $0x8,%r8
 107b3bc:	cmp    %r10,%r9
 107b3bf:	jne    107b332 <check_input_run+0xdfa2>
 107b3c5:	test   %rdi,%rdi
 107b3c8:	je     107b3fe <check_input_run+0xe06e>
 107b3ca:	lea    (%rsi,%r8,4),%r9
 107b3ce:	imul   $0x150,%r8,%r8
 107b3d5:	xor    %r10d,%r10d
 107b3d8:	mov    0x1b0(%rsp),%r11
 107b3e0:	mov    (%r11),%r11
 107b3e3:	mov    0xc0(%r11,%r8,1),%r11d
 107b3eb:	add    $0x150,%r8
 107b3f2:	mov    %r11d,(%r9,%r10,4)
 107b3f6:	inc    %r10
 107b3f9:	cmp    %r10,%rdi
 107b3fc:	jne    107b3d8 <check_input_run+0xe048>
 107b3fe:	mov    0x98(%rsp),%r10
 107b406:	lea    0x1(%r10),%r8d
 107b40a:	cmp    $0x1,%r8d
 107b40e:	adc    $0x1,%r10d
 107b412:	mov    %r10d,%edi
 107b415:	and    $0x3,%edi
 107b418:	cmp    $0x4,%r8d
 107b41c:	jae    107b435 <check_input_run+0xe0a5>
 107b41e:	xor    %r8d,%r8d
 107b421:	xor    %r9d,%r9d
 107b424:	movq   $0x0,0xe0(%rsp)
 107b430:	jmp    107b698 <check_input_run+0xe308>
 107b435:	and    $0xfffffffc,%r10d
 107b439:	xor    %r8d,%r8d
 107b43c:	xor    %r9d,%r9d
 107b43f:	movq   $0x0,0xe0(%rsp)
 107b44b:	jmp    107b45a <check_input_run+0xe0ca>
 107b44d:	add    $0x4,%r8
 107b451:	cmp    %r10,%r8
 107b454:	je     107b68f <check_input_run+0xe2ff>
 107b45a:	mov    0x28(%rsp),%rcx
 107b45f:	cmp    (%rcx),%r9d
 107b462:	jae    107b4c0 <check_input_run+0xe130>
 107b464:	mov    %r9d,%r9d
 107b467:	lea    (%r9,%r9,2),%r11
 107b46b:	lea    0x7(,%r11,4),%r11
 107b473:	mov    0x860(%rsp),%r14
 107b47b:	mov    0x1d0(%r14),%r14
 107b482:	cmp    %r8d,(%r14,%r11,4)
 107b486:	ja     107b4c0 <check_input_run+0xe130>
 107b488:	mov    0xe0(%rsp),%rdx
 107b490:	mov    0xa8(%rsp),%rcx
 107b498:	add    $0xc,%r11
 107b49c:	lea    (%rdx,%r8,1),%ebp
 107b4a0:	mov    %ebp,(%rcx,%r9,4)
 107b4a4:	add    (%rsi,%r9,4),%edx
 107b4a8:	inc    %r9
 107b4ab:	mov    %rdx,0xe0(%rsp)
 107b4b3:	mov    0x28(%rsp),%rdx
 107b4b8:	mov    (%rdx),%r14d
 107b4bb:	cmp    %r14,%r9
 107b4be:	jb     107b473 <check_input_run+0xe0e3>
 107b4c0:	cmp    0x98(%rsp),%r8
 107b4c8:	jae    107b4e2 <check_input_run+0xe152>
 107b4ca:	mov    0xe0(%rsp),%rcx
 107b4d2:	mov    0x110(%rsp),%r14
 107b4da:	lea    (%rcx,%r8,1),%r11d
 107b4de:	mov    %r11d,(%r14,%r8,4)
 107b4e2:	mov    0x28(%rsp),%rcx
 107b4e7:	lea    0x1(%r8),%r11
 107b4eb:	cmp    (%rcx),%r9d
 107b4ee:	jae    107b54c <check_input_run+0xe1bc>
 107b4f0:	mov    %r9d,%r9d
 107b4f3:	lea    (%r9,%r9,2),%r14
 107b4f7:	lea    0x7(,%r14,4),%r14
 107b4ff:	mov    0x860(%rsp),%r15
 107b507:	mov    0x1d0(%r15),%r15
 107b50e:	cmp    %r11d,(%r15,%r14,4)
 107b512:	ja     107b54c <check_input_run+0xe1bc>
 107b514:	mov    0xe0(%rsp),%rdx
 107b51c:	mov    0xa8(%rsp),%rcx
 107b524:	add    $0xc,%r14
 107b528:	lea    (%rdx,%r11,1),%ebp
 107b52c:	mov    %ebp,(%rcx,%r9,4)
 107b530:	add    (%rsi,%r9,4),%edx
 107b534:	inc    %r9
 107b537:	mov    %rdx,0xe0(%rsp)
 107b53f:	mov    0x28(%rsp),%rdx
 107b544:	mov    (%rdx),%r15d
 107b547:	cmp    %r15,%r9
 107b54a:	jb     107b4ff <check_input_run+0xe16f>
 107b54c:	cmp    0x98(%rsp),%r11
 107b554:	jae    107b56e <check_input_run+0xe1de>
 107b556:	mov    0xe0(%rsp),%rcx
 107b55e:	mov    0x110(%rsp),%r14
 107b566:	lea    (%rcx,%r11,1),%ebp
 107b56a:	mov    %ebp,(%r14,%r11,4)
 107b56e:	mov    0x28(%rsp),%rcx
 107b573:	lea    0x2(%r8),%r11
 107b577:	cmp    (%rcx),%r9d
 107b57a:	jae    107b5d8 <check_input_run+0xe248>
 107b57c:	mov    %r9d,%r9d
 107b57f:	lea    (%r9,%r9,2),%r14
 107b583:	lea    0x7(,%r14,4),%r14
 107b58b:	mov    0x860(%rsp),%r15
 107b593:	mov    0x1d0(%r15),%r15
 107b59a:	cmp    %r11d,(%r15,%r14,4)
 107b59e:	ja     107b5d8 <check_input_run+0xe248>
 107b5a0:	mov    0xe0(%rsp),%rdx
 107b5a8:	mov    0xa8(%rsp),%rcx
 107b5b0:	add    $0xc,%r14
 107b5b4:	lea    (%rdx,%r11,1),%ebp
 107b5b8:	mov    %ebp,(%rcx,%r9,4)
 107b5bc:	add    (%rsi,%r9,4),%edx
 107b5c0:	inc    %r9
 107b5c3:	mov    %rdx,0xe0(%rsp)
 107b5cb:	mov    0x28(%rsp),%rdx
 107b5d0:	mov    (%rdx),%r15d
 107b5d3:	cmp    %r15,%r9
 107b5d6:	jb     107b58b <check_input_run+0xe1fb>
 107b5d8:	cmp    0x98(%rsp),%r11
 107b5e0:	jae    107b5fa <check_input_run+0xe26a>
 107b5e2:	mov    0xe0(%rsp),%rcx
 107b5ea:	mov    0x110(%rsp),%r14
 107b5f2:	lea    (%rcx,%r11,1),%ebp
 107b5f6:	mov    %ebp,(%r14,%r11,4)
 107b5fa:	mov    0x28(%rsp),%rcx
 107b5ff:	lea    0x3(%r8),%r11
 107b603:	cmp    (%rcx),%r9d
 107b606:	jae    107b664 <check_input_run+0xe2d4>
 107b608:	mov    %r9d,%r9d
 107b60b:	lea    (%r9,%r9,2),%r14
 107b60f:	lea    0x7(,%r14,4),%r14
 107b617:	mov    0x860(%rsp),%r15
 107b61f:	mov    0x1d0(%r15),%r15
 107b626:	cmp    %r11d,(%r15,%r14,4)
 107b62a:	ja     107b664 <check_input_run+0xe2d4>
 107b62c:	mov    0xe0(%rsp),%rdx
 107b634:	mov    0xa8(%rsp),%rcx
 107b63c:	add    $0xc,%r14
 107b640:	lea    (%rdx,%r11,1),%ebp
 107b644:	mov    %ebp,(%rcx,%r9,4)
 107b648:	add    (%rsi,%r9,4),%edx
 107b64c:	inc    %r9
 107b64f:	mov    %rdx,0xe0(%rsp)
 107b657:	mov    0x28(%rsp),%rdx
 107b65c:	mov    (%rdx),%r15d
 107b65f:	cmp    %r15,%r9
 107b662:	jb     107b617 <check_input_run+0xe287>
 107b664:	cmp    0x98(%rsp),%r11
 107b66c:	jae    107b44d <check_input_run+0xe0bd>
 107b672:	mov    0xe0(%rsp),%rcx
 107b67a:	mov    0x110(%rsp),%r14
 107b682:	lea    (%rcx,%r11,1),%ebp
 107b686:	mov    %ebp,(%r14,%r11,4)
 107b68a:	jmp    107b44d <check_input_run+0xe0bd>
 107b68f:	test   %rdi,%rdi
 107b692:	je     107b739 <check_input_run+0xe3a9>
 107b698:	xor    %r10d,%r10d
 107b69b:	jmp    107b6ac <check_input_run+0xe31c>
 107b69d:	inc    %r8
 107b6a0:	inc    %r10
 107b6a3:	cmp    %rdi,%r10
 107b6a6:	je     107b739 <check_input_run+0xe3a9>
 107b6ac:	mov    0x28(%rsp),%rcx
 107b6b1:	cmp    (%rcx),%r9d
 107b6b4:	jae    107b712 <check_input_run+0xe382>
 107b6b6:	mov    %r9d,%r9d
 107b6b9:	lea    (%r9,%r9,2),%r11
 107b6bd:	lea    0x7(,%r11,4),%r11
 107b6c5:	mov    0x860(%rsp),%r14
 107b6cd:	mov    0x1d0(%r14),%r14
 107b6d4:	cmp    %r8d,(%r14,%r11,4)
 107b6d8:	ja     107b712 <check_input_run+0xe382>
 107b6da:	mov    0xe0(%rsp),%rdx
 107b6e2:	mov    0xa8(%rsp),%rcx
 107b6ea:	add    $0xc,%r11
 107b6ee:	lea    (%rdx,%r8,1),%ebp
 107b6f2:	mov    %ebp,(%rcx,%r9,4)
 107b6f6:	add    (%rsi,%r9,4),%edx
 107b6fa:	inc    %r9
 107b6fd:	mov    %rdx,0xe0(%rsp)
 107b705:	mov    0x28(%rsp),%rdx
 107b70a:	mov    (%rdx),%r14d
 107b70d:	cmp    %r14,%r9
 107b710:	jb     107b6c5 <check_input_run+0xe335>
 107b712:	cmp    0x98(%rsp),%r8
 107b71a:	jae    107b69d <check_input_run+0xe30d>
 107b71c:	mov    0xe0(%rsp),%rcx
 107b724:	mov    0x110(%rsp),%r14
 107b72c:	lea    (%rcx,%r8,1),%r11d
 107b730:	mov    %r11d,(%r14,%r8,4)
 107b734:	jmp    107b69d <check_input_run+0xe30d>
 107b739:	cmpl   $0x0,0x60(%rsp)
 107b73e:	je     107b847 <check_input_run+0xe4b7>
 107b744:	mov    0x60(%rsp),%r8
 107b749:	mov    %r8d,%edi
 107b74c:	and    $0x7,%edi
 107b74f:	cmp    $0x8,%r8d
 107b753:	jae    107b75d <check_input_run+0xe3cd>
 107b755:	xor    %r8d,%r8d
 107b758:	jmp    107b813 <check_input_run+0xe483>
 107b75d:	mov    0x1b0(%rsp),%r14
 107b765:	mov    0x60(%rsp),%r8
 107b76a:	shr    $0x3,%r8d
 107b76e:	xor    %r10d,%r10d
 107b771:	imul   $0xa80,%r8,%r9
 107b778:	xor    %r8d,%r8d
 107b77b:	mov    (%r14),%r11
 107b77e:	mov    0xd0(%r11,%r10,1),%r11d
 107b786:	mov    %r11d,(%rsi,%r8,4)
 107b78a:	mov    (%r14),%r11
 107b78d:	mov    0x220(%r11,%r10,1),%r11d
 107b795:	mov    %r11d,0x4(%rsi,%r8,4)
 107b79a:	mov    (%r14),%r11
 107b79d:	mov    0x370(%r11,%r10,1),%r11d
 107b7a5:	mov    %r11d,0x8(%rsi,%r8,4)
 107b7aa:	mov    (%r14),%r11
 107b7ad:	mov    0x4c0(%r11,%r10,1),%r11d
 107b7b5:	mov    %r11d,0xc(%rsi,%r8,4)
 107b7ba:	mov    (%r14),%r11
 107b7bd:	mov    0x610(%r11,%r10,1),%r11d
 107b7c5:	mov    %r11d,0x10(%rsi,%r8,4)
 107b7ca:	mov    (%r14),%r11
 107b7cd:	mov    0x760(%r11,%r10,1),%r11d
 107b7d5:	mov    %r11d,0x14(%rsi,%r8,4)
 107b7da:	mov    (%r14),%r11
 107b7dd:	mov    0x8b0(%r11,%r10,1),%r11d
 107b7e5:	mov    %r11d,0x18(%rsi,%r8,4)
 107b7ea:	mov    (%r14),%r11
 107b7ed:	mov    0xa00(%r11,%r10,1),%r11d
 107b7f5:	add    $0xa80,%r10
 107b7fc:	mov    %r11d,0x1c(%rsi,%r8,4)
 107b801:	add    $0x8,%r8
 107b805:	cmp    %r10,%r9
 107b808:	jne    107b77b <check_input_run+0xe3eb>
 107b80e:	test   %rdi,%rdi
 107b811:	je     107b847 <check_input_run+0xe4b7>
 107b813:	lea    (%rsi,%r8,4),%r9
 107b817:	imul   $0x150,%r8,%r8
 107b81e:	xor    %r10d,%r10d
 107b821:	mov    0x1b0(%rsp),%r11
 107b829:	mov    (%r11),%r11
 107b82c:	mov    0xd0(%r11,%r8,1),%r11d
 107b834:	add    $0x150,%r8
 107b83b:	mov    %r11d,(%r9,%r10,4)
 107b83f:	inc    %r10
 107b842:	cmp    %r10,%rdi
 107b845:	jne    107b821 <check_input_run+0xe491>
 107b847:	mov    0xd8(%rsp),%r10
 107b84f:	lea    0x1(%r10),%r8d
 107b853:	cmp    $0x1,%r8d
 107b857:	adc    $0x1,%r10d
 107b85b:	mov    %r10d,%edi
 107b85e:	and    $0x3,%edi
 107b861:	cmp    $0x4,%r8d
 107b865:	jae    107b87e <check_input_run+0xe4ee>
 107b867:	xor    %r8d,%r8d
 107b86a:	xor    %r9d,%r9d
 107b86d:	movq   $0x0,0x108(%rsp)
 107b879:	jmp    107bae1 <check_input_run+0xe751>
 107b87e:	and    $0xfffffffc,%r10d
 107b882:	xor    %r8d,%r8d
 107b885:	xor    %r9d,%r9d
 107b888:	movq   $0x0,0x108(%rsp)
 107b894:	jmp    107b8a3 <check_input_run+0xe513>
 107b896:	add    $0x4,%r8
 107b89a:	cmp    %r10,%r8
 107b89d:	je     107bad8 <check_input_run+0xe748>
 107b8a3:	mov    0x28(%rsp),%rcx
 107b8a8:	cmp    (%rcx),%r9d
 107b8ab:	jae    107b909 <check_input_run+0xe579>
 107b8ad:	mov    %r9d,%r9d
 107b8b0:	lea    (%r9,%r9,2),%r11
 107b8b4:	lea    0x8(,%r11,4),%r11
 107b8bc:	mov    0x860(%rsp),%r14
 107b8c4:	mov    0x1d0(%r14),%r14
 107b8cb:	cmp    %r8d,(%r14,%r11,4)
 107b8cf:	ja     107b909 <check_input_run+0xe579>
 107b8d1:	mov    0x108(%rsp),%rdx
 107b8d9:	mov    0xf8(%rsp),%rcx
 107b8e1:	add    $0xc,%r11
 107b8e5:	lea    (%rdx,%r8,1),%ebp
 107b8e9:	mov    %ebp,(%rcx,%r9,4)
 107b8ed:	add    (%rsi,%r9,4),%edx
 107b8f1:	inc    %r9
 107b8f4:	mov    %rdx,0x108(%rsp)
 107b8fc:	mov    0x28(%rsp),%rdx
 107b901:	mov    (%rdx),%r14d
 107b904:	cmp    %r14,%r9
 107b907:	jb     107b8bc <check_input_run+0xe52c>
 107b909:	cmp    0xd8(%rsp),%r8
 107b911:	jae    107b92b <check_input_run+0xe59b>
 107b913:	mov    0x108(%rsp),%rcx
 107b91b:	mov    0x88(%rsp),%rdx
 107b923:	lea    (%rcx,%r8,1),%r11d
 107b927:	mov    %r11d,(%rdx,%r8,4)
 107b92b:	mov    0x28(%rsp),%rcx
 107b930:	lea    0x1(%r8),%r11
 107b934:	cmp    (%rcx),%r9d
 107b937:	jae    107b995 <check_input_run+0xe605>
 107b939:	mov    %r9d,%r9d
 107b93c:	lea    (%r9,%r9,2),%r14
 107b940:	lea    0x8(,%r14,4),%r14
 107b948:	mov    0x860(%rsp),%r15
 107b950:	mov    0x1d0(%r15),%r15
 107b957:	cmp    %r11d,(%r15,%r14,4)
 107b95b:	ja     107b995 <check_input_run+0xe605>
 107b95d:	mov    0x108(%rsp),%rdx
 107b965:	mov    0xf8(%rsp),%rcx
 107b96d:	add    $0xc,%r14
 107b971:	lea    (%rdx,%r11,1),%ebp
 107b975:	mov    %ebp,(%rcx,%r9,4)
 107b979:	add    (%rsi,%r9,4),%edx
 107b97d:	inc    %r9
 107b980:	mov    %rdx,0x108(%rsp)
 107b988:	mov    0x28(%rsp),%rdx
 107b98d:	mov    (%rdx),%r15d
 107b990:	cmp    %r15,%r9
 107b993:	jb     107b948 <check_input_run+0xe5b8>
 107b995:	cmp    0xd8(%rsp),%r11
 107b99d:	jae    107b9b7 <check_input_run+0xe627>
 107b99f:	mov    0x108(%rsp),%rcx
 107b9a7:	mov    0x88(%rsp),%rdx
 107b9af:	lea    (%rcx,%r11,1),%ebp
 107b9b3:	mov    %ebp,(%rdx,%r11,4)
 107b9b7:	mov    0x28(%rsp),%rcx
 107b9bc:	lea    0x2(%r8),%r11
 107b9c0:	cmp    (%rcx),%r9d
 107b9c3:	jae    107ba21 <check_input_run+0xe691>
 107b9c5:	mov    %r9d,%r9d
 107b9c8:	lea    (%r9,%r9,2),%r14
 107b9cc:	lea    0x8(,%r14,4),%r14
 107b9d4:	mov    0x860(%rsp),%r15
 107b9dc:	mov    0x1d0(%r15),%r15
 107b9e3:	cmp    %r11d,(%r15,%r14,4)
 107b9e7:	ja     107ba21 <check_input_run+0xe691>
 107b9e9:	mov    0x108(%rsp),%rdx
 107b9f1:	mov    0xf8(%rsp),%rcx
 107b9f9:	add    $0xc,%r14
 107b9fd:	lea    (%rdx,%r11,1),%ebp
 107ba01:	mov    %ebp,(%rcx,%r9,4)
 107ba05:	add    (%rsi,%r9,4),%edx
 107ba09:	inc    %r9
 107ba0c:	mov    %rdx,0x108(%rsp)
 107ba14:	mov    0x28(%rsp),%rdx
 107ba19:	mov    (%rdx),%r15d
 107ba1c:	cmp    %r15,%r9
 107ba1f:	jb     107b9d4 <check_input_run+0xe644>
 107ba21:	cmp    0xd8(%rsp),%r11
 107ba29:	jae    107ba43 <check_input_run+0xe6b3>
 107ba2b:	mov    0x108(%rsp),%rcx
 107ba33:	mov    0x88(%rsp),%rdx
 107ba3b:	lea    (%rcx,%r11,1),%ebp
 107ba3f:	mov    %ebp,(%rdx,%r11,4)
 107ba43:	mov    0x28(%rsp),%rcx
 107ba48:	lea    0x3(%r8),%r11
 107ba4c:	cmp    (%rcx),%r9d
 107ba4f:	jae    107baad <check_input_run+0xe71d>
 107ba51:	mov    %r9d,%r9d
 107ba54:	lea    (%r9,%r9,2),%r14
 107ba58:	lea    0x8(,%r14,4),%r14
 107ba60:	mov    0x860(%rsp),%r15
 107ba68:	mov    0x1d0(%r15),%r15
 107ba6f:	cmp    %r11d,(%r15,%r14,4)
 107ba73:	ja     107baad <check_input_run+0xe71d>
 107ba75:	mov    0x108(%rsp),%rdx
 107ba7d:	mov    0xf8(%rsp),%rcx
 107ba85:	add    $0xc,%r14
 107ba89:	lea    (%rdx,%r11,1),%ebp
 107ba8d:	mov    %ebp,(%rcx,%r9,4)
 107ba91:	add    (%rsi,%r9,4),%edx
 107ba95:	inc    %r9
 107ba98:	mov    %rdx,0x108(%rsp)
 107baa0:	mov    0x28(%rsp),%rdx
 107baa5:	mov    (%rdx),%r15d
 107baa8:	cmp    %r15,%r9
 107baab:	jb     107ba60 <check_input_run+0xe6d0>
 107baad:	cmp    0xd8(%rsp),%r11
 107bab5:	jae    107b896 <check_input_run+0xe506>
 107babb:	mov    0x108(%rsp),%rcx
 107bac3:	mov    0x88(%rsp),%rdx
 107bacb:	lea    (%rcx,%r11,1),%ebp
 107bacf:	mov    %ebp,(%rdx,%r11,4)
 107bad3:	jmp    107b896 <check_input_run+0xe506>
 107bad8:	test   %rdi,%rdi
 107badb:	je     107bb82 <check_input_run+0xe7f2>
 107bae1:	xor    %r10d,%r10d
 107bae4:	jmp    107baf5 <check_input_run+0xe765>
 107bae6:	inc    %r8
 107bae9:	inc    %r10
 107baec:	cmp    %rdi,%r10
 107baef:	je     107bb82 <check_input_run+0xe7f2>
 107baf5:	mov    0x28(%rsp),%rcx
 107bafa:	cmp    (%rcx),%r9d
 107bafd:	jae    107bb5b <check_input_run+0xe7cb>
 107baff:	mov    %r9d,%r9d
 107bb02:	lea    (%r9,%r9,2),%r11
 107bb06:	lea    0x8(,%r11,4),%r11
 107bb0e:	mov    0x860(%rsp),%r14
 107bb16:	mov    0x1d0(%r14),%r14
 107bb1d:	cmp    %r8d,(%r14,%r11,4)
 107bb21:	ja     107bb5b <check_input_run+0xe7cb>
 107bb23:	mov    0x108(%rsp),%rdx
 107bb2b:	mov    0xf8(%rsp),%rcx
 107bb33:	add    $0xc,%r11
 107bb37:	lea    (%rdx,%r8,1),%ebp
 107bb3b:	mov    %ebp,(%rcx,%r9,4)
 107bb3f:	add    (%rsi,%r9,4),%edx
 107bb43:	inc    %r9
 107bb46:	mov    %rdx,0x108(%rsp)
 107bb4e:	mov    0x28(%rsp),%rdx
 107bb53:	mov    (%rdx),%r14d
 107bb56:	cmp    %r14,%r9
 107bb59:	jb     107bb0e <check_input_run+0xe77e>
 107bb5b:	cmp    0xd8(%rsp),%r8
 107bb63:	jae    107bae6 <check_input_run+0xe756>
 107bb65:	mov    0x108(%rsp),%rcx
 107bb6d:	mov    0x88(%rsp),%rdx
 107bb75:	lea    (%rcx,%r8,1),%r11d
 107bb79:	mov    %r11d,(%rdx,%r8,4)
 107bb7d:	jmp    107bae6 <check_input_run+0xe756>
 107bb82:	cmpl   $0x0,0x60(%rsp)
 107bb87:	je     107bc90 <check_input_run+0xe900>
 107bb8d:	mov    0x60(%rsp),%r8
 107bb92:	mov    %r8d,%edi
 107bb95:	and    $0x7,%edi
 107bb98:	cmp    $0x8,%r8d
 107bb9c:	jae    107bba6 <check_input_run+0xe816>
 107bb9e:	xor    %r8d,%r8d
 107bba1:	jmp    107bc5c <check_input_run+0xe8cc>
 107bba6:	mov    0x1b0(%rsp),%r14
 107bbae:	mov    0x60(%rsp),%r8
 107bbb3:	shr    $0x3,%r8d
 107bbb7:	xor    %r10d,%r10d
 107bbba:	imul   $0xa80,%r8,%r9
 107bbc1:	xor    %r8d,%r8d
 107bbc4:	mov    (%r14),%r11
 107bbc7:	mov    0xf8(%r11,%r10,1),%r11d
 107bbcf:	mov    %r11d,(%rsi,%r8,4)
 107bbd3:	mov    (%r14),%r11
 107bbd6:	mov    0x248(%r11,%r10,1),%r11d
 107bbde:	mov    %r11d,0x4(%rsi,%r8,4)
 107bbe3:	mov    (%r14),%r11
 107bbe6:	mov    0x398(%r11,%r10,1),%r11d
 107bbee:	mov    %r11d,0x8(%rsi,%r8,4)
 107bbf3:	mov    (%r14),%r11
 107bbf6:	mov    0x4e8(%r11,%r10,1),%r11d
 107bbfe:	mov    %r11d,0xc(%rsi,%r8,4)
 107bc03:	mov    (%r14),%r11
 107bc06:	mov    0x638(%r11,%r10,1),%r11d
 107bc0e:	mov    %r11d,0x10(%rsi,%r8,4)
 107bc13:	mov    (%r14),%r11
 107bc16:	mov    0x788(%r11,%r10,1),%r11d
 107bc1e:	mov    %r11d,0x14(%rsi,%r8,4)
 107bc23:	mov    (%r14),%r11
 107bc26:	mov    0x8d8(%r11,%r10,1),%r11d
 107bc2e:	mov    %r11d,0x18(%rsi,%r8,4)
 107bc33:	mov    (%r14),%r11
 107bc36:	mov    0xa28(%r11,%r10,1),%r11d
 107bc3e:	add    $0xa80,%r10
 107bc45:	mov    %r11d,0x1c(%rsi,%r8,4)
 107bc4a:	add    $0x8,%r8
 107bc4e:	cmp    %r10,%r9
 107bc51:	jne    107bbc4 <check_input_run+0xe834>
 107bc57:	test   %rdi,%rdi
 107bc5a:	je     107bc90 <check_input_run+0xe900>
 107bc5c:	lea    (%rsi,%r8,4),%r9
 107bc60:	imul   $0x150,%r8,%r8
 107bc67:	xor    %r10d,%r10d
 107bc6a:	mov    0x1b0(%rsp),%r11
 107bc72:	mov    (%r11),%r11
 107bc75:	mov    0xf8(%r11,%r8,1),%r11d
 107bc7d:	add    $0x150,%r8
 107bc84:	mov    %r11d,(%r9,%r10,4)
 107bc88:	inc    %r10
 107bc8b:	cmp    %r10,%rdi
 107bc8e:	jne    107bc6a <check_input_run+0xe8da>
 107bc90:	mov    0x70(%rsp),%r10
 107bc95:	lea    0x1(%r10),%r8d
 107bc99:	cmp    $0x1,%r8d
 107bc9d:	adc    $0x1,%r10d
 107bca1:	mov    %r10d,%edi
 107bca4:	and    $0x3,%edi
 107bca7:	cmp    $0x4,%r8d
 107bcab:	jae    107bcc4 <check_input_run+0xe934>
 107bcad:	xor    %r8d,%r8d
 107bcb0:	xor    %r9d,%r9d
 107bcb3:	movq   $0x0,0x128(%rsp)
 107bcbf:	jmp    107bf1b <check_input_run+0xeb8b>
 107bcc4:	and    $0xfffffffc,%r10d
 107bcc8:	xor    %r8d,%r8d
 107bccb:	xor    %r9d,%r9d
 107bcce:	movq   $0x0,0x128(%rsp)
 107bcda:	jmp    107bce9 <check_input_run+0xe959>
 107bcdc:	add    $0x4,%r8
 107bce0:	cmp    %r10,%r8
 107bce3:	je     107bf12 <check_input_run+0xeb82>
 107bce9:	mov    0x28(%rsp),%rcx
 107bcee:	cmp    (%rcx),%r9d
 107bcf1:	jae    107bd4f <check_input_run+0xe9bf>
 107bcf3:	mov    %r9d,%r9d
 107bcf6:	lea    (%r9,%r9,2),%r11
 107bcfa:	lea    0x9(,%r11,4),%r11
 107bd02:	mov    0x860(%rsp),%r14
 107bd0a:	mov    0x1d0(%r14),%r14
 107bd11:	cmp    %r8d,(%r14,%r11,4)
 107bd15:	ja     107bd4f <check_input_run+0xe9bf>
 107bd17:	mov    0x128(%rsp),%rdx
 107bd1f:	mov    0x1a0(%rsp),%rcx
 107bd27:	add    $0xc,%r11
 107bd2b:	lea    (%rdx,%r8,1),%ebp
 107bd2f:	mov    %ebp,(%rcx,%r9,4)
 107bd33:	add    (%rsi,%r9,4),%edx
 107bd37:	inc    %r9
 107bd3a:	mov    %rdx,0x128(%rsp)
 107bd42:	mov    0x28(%rsp),%rdx
 107bd47:	mov    (%rdx),%r14d
 107bd4a:	cmp    %r14,%r9
 107bd4d:	jb     107bd02 <check_input_run+0xe972>
 107bd4f:	cmp    0x70(%rsp),%r8
 107bd54:	jae    107bd6e <check_input_run+0xe9de>
 107bd56:	mov    0x128(%rsp),%rcx
 107bd5e:	mov    0x150(%rsp),%rdx
 107bd66:	lea    (%rcx,%r8,1),%r11d
 107bd6a:	mov    %r11d,(%rdx,%r8,4)
 107bd6e:	mov    0x28(%rsp),%rcx
 107bd73:	lea    0x1(%r8),%r11
 107bd77:	cmp    (%rcx),%r9d
 107bd7a:	jae    107bdd8 <check_input_run+0xea48>
 107bd7c:	mov    %r9d,%r9d
 107bd7f:	lea    (%r9,%r9,2),%r14
 107bd83:	lea    0x9(,%r14,4),%r14
 107bd8b:	mov    0x860(%rsp),%r15
 107bd93:	mov    0x1d0(%r15),%r15
 107bd9a:	cmp    %r11d,(%r15,%r14,4)
 107bd9e:	ja     107bdd8 <check_input_run+0xea48>
 107bda0:	mov    0x128(%rsp),%rdx
 107bda8:	mov    0x1a0(%rsp),%rcx
 107bdb0:	add    $0xc,%r14
 107bdb4:	lea    (%rdx,%r11,1),%ebp
 107bdb8:	mov    %ebp,(%rcx,%r9,4)
 107bdbc:	add    (%rsi,%r9,4),%edx
 107bdc0:	inc    %r9
 107bdc3:	mov    %rdx,0x128(%rsp)
 107bdcb:	mov    0x28(%rsp),%rdx
 107bdd0:	mov    (%rdx),%r15d
 107bdd3:	cmp    %r15,%r9
 107bdd6:	jb     107bd8b <check_input_run+0xe9fb>
 107bdd8:	cmp    0x70(%rsp),%r11
 107bddd:	jae    107bdf7 <check_input_run+0xea67>
 107bddf:	mov    0x128(%rsp),%rcx
 107bde7:	mov    0x150(%rsp),%rdx
 107bdef:	lea    (%rcx,%r11,1),%ebp
 107bdf3:	mov    %ebp,(%rdx,%r11,4)
 107bdf7:	mov    0x28(%rsp),%rcx
 107bdfc:	lea    0x2(%r8),%r11
 107be00:	cmp    (%rcx),%r9d
 107be03:	jae    107be61 <check_input_run+0xead1>
 107be05:	mov    %r9d,%r9d
 107be08:	lea    (%r9,%r9,2),%r14
 107be0c:	lea    0x9(,%r14,4),%r14
 107be14:	mov    0x860(%rsp),%r15
 107be1c:	mov    0x1d0(%r15),%r15
 107be23:	cmp    %r11d,(%r15,%r14,4)
 107be27:	ja     107be61 <check_input_run+0xead1>
 107be29:	mov    0x128(%rsp),%rdx
 107be31:	mov    0x1a0(%rsp),%rcx
 107be39:	add    $0xc,%r14
 107be3d:	lea    (%rdx,%r11,1),%ebp
 107be41:	mov    %ebp,(%rcx,%r9,4)
 107be45:	add    (%rsi,%r9,4),%edx
 107be49:	inc    %r9
 107be4c:	mov    %rdx,0x128(%rsp)
 107be54:	mov    0x28(%rsp),%rdx
 107be59:	mov    (%rdx),%r15d
 107be5c:	cmp    %r15,%r9
 107be5f:	jb     107be14 <check_input_run+0xea84>
 107be61:	cmp    0x70(%rsp),%r11
 107be66:	jae    107be80 <check_input_run+0xeaf0>
 107be68:	mov    0x128(%rsp),%rcx
 107be70:	mov    0x150(%rsp),%rdx
 107be78:	lea    (%rcx,%r11,1),%ebp
 107be7c:	mov    %ebp,(%rdx,%r11,4)
 107be80:	mov    0x28(%rsp),%rcx
 107be85:	lea    0x3(%r8),%r11
 107be89:	cmp    (%rcx),%r9d
 107be8c:	jae    107beea <check_input_run+0xeb5a>
 107be8e:	mov    %r9d,%r9d
 107be91:	lea    (%r9,%r9,2),%r14
 107be95:	lea    0x9(,%r14,4),%r14
 107be9d:	mov    0x860(%rsp),%r15
 107bea5:	mov    0x1d0(%r15),%r15
 107beac:	cmp    %r11d,(%r15,%r14,4)
 107beb0:	ja     107beea <check_input_run+0xeb5a>
 107beb2:	mov    0x128(%rsp),%rdx
 107beba:	mov    0x1a0(%rsp),%rcx
 107bec2:	add    $0xc,%r14
 107bec6:	lea    (%rdx,%r11,1),%ebp
 107beca:	mov    %ebp,(%rcx,%r9,4)
 107bece:	add    (%rsi,%r9,4),%edx
 107bed2:	inc    %r9
 107bed5:	mov    %rdx,0x128(%rsp)
 107bedd:	mov    0x28(%rsp),%rdx
 107bee2:	mov    (%rdx),%r15d
 107bee5:	cmp    %r15,%r9
 107bee8:	jb     107be9d <check_input_run+0xeb0d>
 107beea:	cmp    0x70(%rsp),%r11
 107beef:	jae    107bcdc <check_input_run+0xe94c>
 107bef5:	mov    0x128(%rsp),%rcx
 107befd:	mov    0x150(%rsp),%rdx
 107bf05:	lea    (%rcx,%r11,1),%ebp
 107bf09:	mov    %ebp,(%rdx,%r11,4)
 107bf0d:	jmp    107bcdc <check_input_run+0xe94c>
 107bf12:	test   %rdi,%rdi
 107bf15:	je     107bfb9 <check_input_run+0xec29>
 107bf1b:	xor    %r10d,%r10d
 107bf1e:	jmp    107bf2f <check_input_run+0xeb9f>
 107bf20:	inc    %r8
 107bf23:	inc    %r10
 107bf26:	cmp    %rdi,%r10
 107bf29:	je     107bfb9 <check_input_run+0xec29>
 107bf2f:	mov    0x28(%rsp),%rcx
 107bf34:	cmp    (%rcx),%r9d
 107bf37:	jae    107bf95 <check_input_run+0xec05>
 107bf39:	mov    %r9d,%r9d
 107bf3c:	lea    (%r9,%r9,2),%r11
 107bf40:	lea    0x9(,%r11,4),%r11
 107bf48:	mov    0x860(%rsp),%r14
 107bf50:	mov    0x1d0(%r14),%r14
 107bf57:	cmp    %r8d,(%r14,%r11,4)
 107bf5b:	ja     107bf95 <check_input_run+0xec05>
 107bf5d:	mov    0x128(%rsp),%rdx
 107bf65:	mov    0x1a0(%rsp),%rcx
 107bf6d:	add    $0xc,%r11
 107bf71:	lea    (%rdx,%r8,1),%ebp
 107bf75:	mov    %ebp,(%rcx,%r9,4)
 107bf79:	add    (%rsi,%r9,4),%edx
 107bf7d:	inc    %r9
 107bf80:	mov    %rdx,0x128(%rsp)
 107bf88:	mov    0x28(%rsp),%rdx
 107bf8d:	mov    (%rdx),%r14d
 107bf90:	cmp    %r14,%r9
 107bf93:	jb     107bf48 <check_input_run+0xebb8>
 107bf95:	cmp    0x70(%rsp),%r8
 107bf9a:	jae    107bf20 <check_input_run+0xeb90>
 107bf9c:	mov    0x128(%rsp),%rcx
 107bfa4:	mov    0x150(%rsp),%rdx
 107bfac:	lea    (%rcx,%r8,1),%r11d
 107bfb0:	mov    %r11d,(%rdx,%r8,4)
 107bfb4:	jmp    107bf20 <check_input_run+0xeb90>
 107bfb9:	cmpl   $0x0,0x60(%rsp)
 107bfbe:	je     107c0c7 <check_input_run+0xed37>
 107bfc4:	mov    0x60(%rsp),%r8
 107bfc9:	mov    %r8d,%edi
 107bfcc:	and    $0x7,%edi
 107bfcf:	cmp    $0x8,%r8d
 107bfd3:	jae    107bfdd <check_input_run+0xec4d>
 107bfd5:	xor    %r8d,%r8d
 107bfd8:	jmp    107c093 <check_input_run+0xed03>
 107bfdd:	mov    0x1b0(%rsp),%r14
 107bfe5:	mov    0x60(%rsp),%r8
 107bfea:	shr    $0x3,%r8d
 107bfee:	xor    %r10d,%r10d
 107bff1:	imul   $0xa80,%r8,%r9
 107bff8:	xor    %r8d,%r8d
 107bffb:	mov    (%r14),%r11
 107bffe:	mov    0x108(%r11,%r10,1),%r11d
 107c006:	mov    %r11d,(%rsi,%r8,4)
 107c00a:	mov    (%r14),%r11
 107c00d:	mov    0x258(%r11,%r10,1),%r11d
 107c015:	mov    %r11d,0x4(%rsi,%r8,4)
 107c01a:	mov    (%r14),%r11
 107c01d:	mov    0x3a8(%r11,%r10,1),%r11d
 107c025:	mov    %r11d,0x8(%rsi,%r8,4)
 107c02a:	mov    (%r14),%r11
 107c02d:	mov    0x4f8(%r11,%r10,1),%r11d
 107c035:	mov    %r11d,0xc(%rsi,%r8,4)
 107c03a:	mov    (%r14),%r11
 107c03d:	mov    0x648(%r11,%r10,1),%r11d
 107c045:	mov    %r11d,0x10(%rsi,%r8,4)
 107c04a:	mov    (%r14),%r11
 107c04d:	mov    0x798(%r11,%r10,1),%r11d
 107c055:	mov    %r11d,0x14(%rsi,%r8,4)
 107c05a:	mov    (%r14),%r11
 107c05d:	mov    0x8e8(%r11,%r10,1),%r11d
 107c065:	mov    %r11d,0x18(%rsi,%r8,4)
 107c06a:	mov    (%r14),%r11
 107c06d:	mov    0xa38(%r11,%r10,1),%r11d
 107c075:	add    $0xa80,%r10
 107c07c:	mov    %r11d,0x1c(%rsi,%r8,4)
 107c081:	add    $0x8,%r8
 107c085:	cmp    %r10,%r9
 107c088:	jne    107bffb <check_input_run+0xec6b>
 107c08e:	test   %rdi,%rdi
 107c091:	je     107c0c7 <check_input_run+0xed37>
 107c093:	lea    (%rsi,%r8,4),%r9
 107c097:	imul   $0x150,%r8,%r8
 107c09e:	xor    %r10d,%r10d
 107c0a1:	mov    0x1b0(%rsp),%r11
 107c0a9:	mov    (%r11),%r11
 107c0ac:	mov    0x108(%r11,%r8,1),%r11d
 107c0b4:	add    $0x150,%r8
 107c0bb:	mov    %r11d,(%r9,%r10,4)
 107c0bf:	inc    %r10
 107c0c2:	cmp    %r10,%rdi
 107c0c5:	jne    107c0a1 <check_input_run+0xed11>
 107c0c7:	mov    0xc0(%rsp),%r10
 107c0cf:	lea    0x1(%r10),%r8d
 107c0d3:	cmp    $0x1,%r8d
 107c0d7:	adc    $0x1,%r10d
 107c0db:	mov    %r10d,%edi
 107c0de:	and    $0x3,%edi
 107c0e1:	cmp    $0x4,%r8d
 107c0e5:	jae    107c0fe <check_input_run+0xed6e>
 107c0e7:	xor    %r8d,%r8d
 107c0ea:	xor    %r9d,%r9d
 107c0ed:	movq   $0x0,0x120(%rsp)
 107c0f9:	jmp    107c361 <check_input_run+0xefd1>
 107c0fe:	and    $0xfffffffc,%r10d
 107c102:	xor    %r8d,%r8d
 107c105:	xor    %r9d,%r9d
 107c108:	movq   $0x0,0x120(%rsp)
 107c114:	jmp    107c123 <check_input_run+0xed93>
 107c116:	add    $0x4,%r8
 107c11a:	cmp    %r10,%r8
 107c11d:	je     107c358 <check_input_run+0xefc8>
 107c123:	mov    0x28(%rsp),%rcx
 107c128:	cmp    (%rcx),%r9d
 107c12b:	jae    107c189 <check_input_run+0xedf9>
 107c12d:	mov    %r9d,%r9d
 107c130:	lea    (%r9,%r9,2),%r11
 107c134:	lea    0xa(,%r11,4),%r11
 107c13c:	mov    0x860(%rsp),%r14
 107c144:	mov    0x1d0(%r14),%r14
 107c14b:	cmp    %r8d,(%r14,%r11,4)
 107c14f:	ja     107c189 <check_input_run+0xedf9>
 107c151:	mov    0x120(%rsp),%rdx
 107c159:	mov    0x198(%rsp),%rcx
 107c161:	add    $0xc,%r11
 107c165:	lea    (%rdx,%r8,1),%ebp
 107c169:	mov    %ebp,(%rcx,%r9,4)
 107c16d:	add    (%rsi,%r9,4),%edx
 107c171:	inc    %r9
 107c174:	mov    %rdx,0x120(%rsp)
 107c17c:	mov    0x28(%rsp),%rdx
 107c181:	mov    (%rdx),%r14d
 107c184:	cmp    %r14,%r9
 107c187:	jb     107c13c <check_input_run+0xedac>
 107c189:	cmp    0xc0(%rsp),%r8
 107c191:	jae    107c1ab <check_input_run+0xee1b>
 107c193:	mov    0x120(%rsp),%rcx
 107c19b:	mov    0x118(%rsp),%rdx
 107c1a3:	lea    (%rcx,%r8,1),%r11d
 107c1a7:	mov    %r11d,(%rdx,%r8,4)
 107c1ab:	mov    0x28(%rsp),%rcx
 107c1b0:	lea    0x1(%r8),%r11
 107c1b4:	cmp    (%rcx),%r9d
 107c1b7:	jae    107c215 <check_input_run+0xee85>
 107c1b9:	mov    %r9d,%r9d
 107c1bc:	lea    (%r9,%r9,2),%r14
 107c1c0:	lea    0xa(,%r14,4),%r14
 107c1c8:	mov    0x860(%rsp),%r15
 107c1d0:	mov    0x1d0(%r15),%r15
 107c1d7:	cmp    %r11d,(%r15,%r14,4)
 107c1db:	ja     107c215 <check_input_run+0xee85>
 107c1dd:	mov    0x120(%rsp),%rdx
 107c1e5:	mov    0x198(%rsp),%rcx
 107c1ed:	add    $0xc,%r14
 107c1f1:	lea    (%rdx,%r11,1),%ebp
 107c1f5:	mov    %ebp,(%rcx,%r9,4)
 107c1f9:	add    (%rsi,%r9,4),%edx
 107c1fd:	inc    %r9
 107c200:	mov    %rdx,0x120(%rsp)
 107c208:	mov    0x28(%rsp),%rdx
 107c20d:	mov    (%rdx),%r15d
 107c210:	cmp    %r15,%r9
 107c213:	jb     107c1c8 <check_input_run+0xee38>
 107c215:	cmp    0xc0(%rsp),%r11
 107c21d:	jae    107c237 <check_input_run+0xeea7>
 107c21f:	mov    0x120(%rsp),%rcx
 107c227:	mov    0x118(%rsp),%rdx
 107c22f:	lea    (%rcx,%r11,1),%ebp
 107c233:	mov    %ebp,(%rdx,%r11,4)
 107c237:	mov    0x28(%rsp),%rcx
 107c23c:	lea    0x2(%r8),%r11
 107c240:	cmp    (%rcx),%r9d
 107c243:	jae    107c2a1 <check_input_run+0xef11>
 107c245:	mov    %r9d,%r9d
 107c248:	lea    (%r9,%r9,2),%r14
 107c24c:	lea    0xa(,%r14,4),%r14
 107c254:	mov    0x860(%rsp),%r15
 107c25c:	mov    0x1d0(%r15),%r15
 107c263:	cmp    %r11d,(%r15,%r14,4)
 107c267:	ja     107c2a1 <check_input_run+0xef11>
 107c269:	mov    0x120(%rsp),%rdx
 107c271:	mov    0x198(%rsp),%rcx
 107c279:	add    $0xc,%r14
 107c27d:	lea    (%rdx,%r11,1),%ebp
 107c281:	mov    %ebp,(%rcx,%r9,4)
 107c285:	add    (%rsi,%r9,4),%edx
 107c289:	inc    %r9
 107c28c:	mov    %rdx,0x120(%rsp)
 107c294:	mov    0x28(%rsp),%rdx
 107c299:	mov    (%rdx),%r15d
 107c29c:	cmp    %r15,%r9
 107c29f:	jb     107c254 <check_input_run+0xeec4>
 107c2a1:	cmp    0xc0(%rsp),%r11
 107c2a9:	jae    107c2c3 <check_input_run+0xef33>
 107c2ab:	mov    0x120(%rsp),%rcx
 107c2b3:	mov    0x118(%rsp),%rdx
 107c2bb:	lea    (%rcx,%r11,1),%ebp
 107c2bf:	mov    %ebp,(%rdx,%r11,4)
 107c2c3:	mov    0x28(%rsp),%rcx
 107c2c8:	lea    0x3(%r8),%r11
 107c2cc:	cmp    (%rcx),%r9d
 107c2cf:	jae    107c32d <check_input_run+0xef9d>
 107c2d1:	mov    %r9d,%r9d
 107c2d4:	lea    (%r9,%r9,2),%r14
 107c2d8:	lea    0xa(,%r14,4),%r14
 107c2e0:	mov    0x860(%rsp),%r15
 107c2e8:	mov    0x1d0(%r15),%r15
 107c2ef:	cmp    %r11d,(%r15,%r14,4)
 107c2f3:	ja     107c32d <check_input_run+0xef9d>
 107c2f5:	mov    0x120(%rsp),%rdx
 107c2fd:	mov    0x198(%rsp),%rcx
 107c305:	add    $0xc,%r14
 107c309:	lea    (%rdx,%r11,1),%ebp
 107c30d:	mov    %ebp,(%rcx,%r9,4)
 107c311:	add    (%rsi,%r9,4),%edx
 107c315:	inc    %r9
 107c318:	mov    %rdx,0x120(%rsp)
 107c320:	mov    0x28(%rsp),%rdx
 107c325:	mov    (%rdx),%r15d
 107c328:	cmp    %r15,%r9
 107c32b:	jb     107c2e0 <check_input_run+0xef50>
 107c32d:	cmp    0xc0(%rsp),%r11
 107c335:	jae    107c116 <check_input_run+0xed86>
 107c33b:	mov    0x120(%rsp),%rcx
 107c343:	mov    0x118(%rsp),%rdx
 107c34b:	lea    (%rcx,%r11,1),%ebp
 107c34f:	mov    %ebp,(%rdx,%r11,4)
 107c353:	jmp    107c116 <check_input_run+0xed86>
 107c358:	test   %rdi,%rdi
 107c35b:	je     107c402 <check_input_run+0xf072>
 107c361:	xor    %r10d,%r10d
 107c364:	jmp    107c375 <check_input_run+0xefe5>
 107c366:	inc    %r8
 107c369:	inc    %r10
 107c36c:	cmp    %rdi,%r10
 107c36f:	je     107c402 <check_input_run+0xf072>
 107c375:	mov    0x28(%rsp),%rcx
 107c37a:	cmp    (%rcx),%r9d
 107c37d:	jae    107c3db <check_input_run+0xf04b>
 107c37f:	mov    %r9d,%r9d
 107c382:	lea    (%r9,%r9,2),%r11
 107c386:	lea    0xa(,%r11,4),%r11
 107c38e:	mov    0x860(%rsp),%r14
 107c396:	mov    0x1d0(%r14),%r14
 107c39d:	cmp    %r8d,(%r14,%r11,4)
 107c3a1:	ja     107c3db <check_input_run+0xf04b>
 107c3a3:	mov    0x120(%rsp),%rdx
 107c3ab:	mov    0x198(%rsp),%rcx
 107c3b3:	add    $0xc,%r11
 107c3b7:	lea    (%rdx,%r8,1),%ebp
 107c3bb:	mov    %ebp,(%rcx,%r9,4)
 107c3bf:	add    (%rsi,%r9,4),%edx
 107c3c3:	inc    %r9
 107c3c6:	mov    %rdx,0x120(%rsp)
 107c3ce:	mov    0x28(%rsp),%rdx
 107c3d3:	mov    (%rdx),%r14d
 107c3d6:	cmp    %r14,%r9
 107c3d9:	jb     107c38e <check_input_run+0xeffe>
 107c3db:	cmp    0xc0(%rsp),%r8
 107c3e3:	jae    107c366 <check_input_run+0xefd6>
 107c3e5:	mov    0x120(%rsp),%rcx
 107c3ed:	mov    0x118(%rsp),%rdx
 107c3f5:	lea    (%rcx,%r8,1),%r11d
 107c3f9:	mov    %r11d,(%rdx,%r8,4)
 107c3fd:	jmp    107c366 <check_input_run+0xefd6>
 107c402:	cmpl   $0x0,0x60(%rsp)
 107c407:	je     107c510 <check_input_run+0xf180>
 107c40d:	mov    0x60(%rsp),%r8
 107c412:	mov    %r8d,%edi
 107c415:	and    $0x7,%edi
 107c418:	cmp    $0x8,%r8d
 107c41c:	jae    107c426 <check_input_run+0xf096>
 107c41e:	xor    %r8d,%r8d
 107c421:	jmp    107c4dc <check_input_run+0xf14c>
 107c426:	mov    0x1b0(%rsp),%r14
 107c42e:	mov    0x60(%rsp),%r8
 107c433:	shr    $0x3,%r8d
 107c437:	xor    %r10d,%r10d
 107c43a:	imul   $0xa80,%r8,%r9
 107c441:	xor    %r8d,%r8d
 107c444:	mov    (%r14),%r11
 107c447:	mov    0x118(%r11,%r10,1),%r11d
 107c44f:	mov    %r11d,(%rsi,%r8,4)
 107c453:	mov    (%r14),%r11
 107c456:	mov    0x268(%r11,%r10,1),%r11d
 107c45e:	mov    %r11d,0x4(%rsi,%r8,4)
 107c463:	mov    (%r14),%r11
 107c466:	mov    0x3b8(%r11,%r10,1),%r11d
 107c46e:	mov    %r11d,0x8(%rsi,%r8,4)
 107c473:	mov    (%r14),%r11
 107c476:	mov    0x508(%r11,%r10,1),%r11d
 107c47e:	mov    %r11d,0xc(%rsi,%r8,4)
 107c483:	mov    (%r14),%r11
 107c486:	mov    0x658(%r11,%r10,1),%r11d
 107c48e:	mov    %r11d,0x10(%rsi,%r8,4)
 107c493:	mov    (%r14),%r11
 107c496:	mov    0x7a8(%r11,%r10,1),%r11d
 107c49e:	mov    %r11d,0x14(%rsi,%r8,4)
 107c4a3:	mov    (%r14),%r11
 107c4a6:	mov    0x8f8(%r11,%r10,1),%r11d
 107c4ae:	mov    %r11d,0x18(%rsi,%r8,4)
 107c4b3:	mov    (%r14),%r11
 107c4b6:	mov    0xa48(%r11,%r10,1),%r11d
 107c4be:	add    $0xa80,%r10
 107c4c5:	mov    %r11d,0x1c(%rsi,%r8,4)
 107c4ca:	add    $0x8,%r8
 107c4ce:	cmp    %r10,%r9
 107c4d1:	jne    107c444 <check_input_run+0xf0b4>
 107c4d7:	test   %rdi,%rdi
 107c4da:	je     107c510 <check_input_run+0xf180>
 107c4dc:	lea    (%rsi,%r8,4),%r9
 107c4e0:	imul   $0x150,%r8,%r8
 107c4e7:	xor    %r10d,%r10d
 107c4ea:	mov    0x1b0(%rsp),%r11
 107c4f2:	mov    (%r11),%r11
 107c4f5:	mov    0x118(%r11,%r8,1),%r11d
 107c4fd:	add    $0x150,%r8
 107c504:	mov    %r11d,(%r9,%r10,4)
 107c508:	inc    %r10
 107c50b:	cmp    %r10,%rdi
 107c50e:	jne    107c4ea <check_input_run+0xf15a>
 107c510:	mov    0x100(%rsp),%r10
 107c518:	lea    0x1(%r10),%r8d
 107c51c:	cmp    $0x1,%r8d
 107c520:	adc    $0x1,%r10d
 107c524:	mov    %r10d,%edi
 107c527:	and    $0x3,%edi
 107c52a:	cmp    $0x4,%r8d
 107c52e:	jae    107c53d <check_input_run+0xf1ad>
 107c530:	xor    %r8d,%r8d
 107c533:	xor    %r9d,%r9d
 107c536:	xor    %edx,%edx
 107c538:	jmp    107c736 <check_input_run+0xf3a6>
 107c53d:	and    $0xfffffffc,%r10d
 107c541:	xor    %r8d,%r8d
 107c544:	xor    %r9d,%r9d
 107c547:	xor    %edx,%edx
 107c549:	jmp    107c558 <check_input_run+0xf1c8>
 107c54b:	add    $0x4,%r8
 107c54f:	cmp    %r10,%r8
 107c552:	je     107c72d <check_input_run+0xf39d>
 107c558:	mov    0x28(%rsp),%rcx
 107c55d:	cmp    (%rcx),%r9d
 107c560:	jae    107c5ae <check_input_run+0xf21e>
 107c562:	mov    %r9d,%r9d
 107c565:	lea    (%r9,%r9,2),%r11
 107c569:	lea    0xb(,%r11,4),%r11
 107c571:	mov    0x860(%rsp),%r14
 107c579:	mov    0x1d0(%r14),%r14
 107c580:	cmp    %r8d,(%r14,%r11,4)
 107c584:	ja     107c5ae <check_input_run+0xf21e>
 107c586:	mov    0x180(%rsp),%rcx
 107c58e:	mov    0x28(%rsp),%rbx
 107c593:	lea    (%rdx,%r8,1),%ebp
 107c597:	add    $0xc,%r11
 107c59b:	mov    %ebp,(%rcx,%r9,4)
 107c59f:	add    (%rsi,%r9,4),%edx
 107c5a3:	mov    (%rbx),%r14d
 107c5a6:	inc    %r9
 107c5a9:	cmp    %r14,%r9
 107c5ac:	jb     107c571 <check_input_run+0xf1e1>
 107c5ae:	cmp    0x100(%rsp),%r8
 107c5b6:	jae    107c5c8 <check_input_run+0xf238>
 107c5b8:	mov    0x148(%rsp),%rcx
 107c5c0:	lea    (%rdx,%r8,1),%r11d
 107c5c4:	mov    %r11d,(%rcx,%r8,4)
 107c5c8:	mov    0x28(%rsp),%rcx
 107c5cd:	lea    0x1(%r8),%r11
 107c5d1:	cmp    (%rcx),%r9d
 107c5d4:	jae    107c622 <check_input_run+0xf292>
 107c5d6:	mov    %r9d,%r9d
 107c5d9:	lea    (%r9,%r9,2),%r14
 107c5dd:	lea    0xb(,%r14,4),%r14
 107c5e5:	mov    0x860(%rsp),%r15
 107c5ed:	mov    0x1d0(%r15),%r15
 107c5f4:	cmp    %r11d,(%r15,%r14,4)
 107c5f8:	ja     107c622 <check_input_run+0xf292>
 107c5fa:	mov    0x180(%rsp),%rcx
 107c602:	mov    0x28(%rsp),%rbx
 107c607:	lea    (%rdx,%r11,1),%ebp
 107c60b:	add    $0xc,%r14
 107c60f:	mov    %ebp,(%rcx,%r9,4)
 107c613:	add    (%rsi,%r9,4),%edx
 107c617:	mov    (%rbx),%r15d
 107c61a:	inc    %r9
 107c61d:	cmp    %r15,%r9
 107c620:	jb     107c5e5 <check_input_run+0xf255>
 107c622:	cmp    0x100(%rsp),%r11
 107c62a:	jae    107c63c <check_input_run+0xf2ac>
 107c62c:	mov    0x148(%rsp),%rcx
 107c634:	lea    (%rdx,%r11,1),%ebp
 107c638:	mov    %ebp,(%rcx,%r11,4)
 107c63c:	mov    0x28(%rsp),%rcx
 107c641:	lea    0x2(%r8),%r11
 107c645:	cmp    (%rcx),%r9d
 107c648:	jae    107c696 <check_input_run+0xf306>
 107c64a:	mov    %r9d,%r9d
 107c64d:	lea    (%r9,%r9,2),%r14
 107c651:	lea    0xb(,%r14,4),%r14
 107c659:	mov    0x860(%rsp),%r15
 107c661:	mov    0x1d0(%r15),%r15
 107c668:	cmp    %r11d,(%r15,%r14,4)
 107c66c:	ja     107c696 <check_input_run+0xf306>
 107c66e:	mov    0x180(%rsp),%rcx
 107c676:	mov    0x28(%rsp),%rbx
 107c67b:	lea    (%rdx,%r11,1),%ebp
 107c67f:	add    $0xc,%r14
 107c683:	mov    %ebp,(%rcx,%r9,4)
 107c687:	add    (%rsi,%r9,4),%edx
 107c68b:	mov    (%rbx),%r15d
 107c68e:	inc    %r9
 107c691:	cmp    %r15,%r9
 107c694:	jb     107c659 <check_input_run+0xf2c9>
 107c696:	cmp    0x100(%rsp),%r11
 107c69e:	jae    107c6b0 <check_input_run+0xf320>
 107c6a0:	mov    0x148(%rsp),%rcx
 107c6a8:	lea    (%rdx,%r11,1),%ebp
 107c6ac:	mov    %ebp,(%rcx,%r11,4)
 107c6b0:	mov    0x28(%rsp),%rcx
 107c6b5:	lea    0x3(%r8),%r11
 107c6b9:	cmp    (%rcx),%r9d
 107c6bc:	jae    107c70a <check_input_run+0xf37a>
 107c6be:	mov    %r9d,%r9d
 107c6c1:	lea    (%r9,%r9,2),%r14
 107c6c5:	lea    0xb(,%r14,4),%r14
 107c6cd:	mov    0x860(%rsp),%r15
 107c6d5:	mov    0x1d0(%r15),%r15
 107c6dc:	cmp    %r11d,(%r15,%r14,4)
 107c6e0:	ja     107c70a <check_input_run+0xf37a>
 107c6e2:	mov    0x180(%rsp),%rcx
 107c6ea:	mov    0x28(%rsp),%rbx
 107c6ef:	lea    (%rdx,%r11,1),%ebp
 107c6f3:	add    $0xc,%r14
 107c6f7:	mov    %ebp,(%rcx,%r9,4)
 107c6fb:	add    (%rsi,%r9,4),%edx
 107c6ff:	mov    (%rbx),%r15d
 107c702:	inc    %r9
 107c705:	cmp    %r15,%r9
 107c708:	jb     107c6cd <check_input_run+0xf33d>
 107c70a:	cmp    0x100(%rsp),%r11
 107c712:	jae    107c54b <check_input_run+0xf1bb>
 107c718:	mov    0x148(%rsp),%rcx
 107c720:	lea    (%rdx,%r11,1),%ebp
 107c724:	mov    %ebp,(%rcx,%r11,4)
 107c728:	jmp    107c54b <check_input_run+0xf1bb>
 107c72d:	test   %rdi,%rdi
 107c730:	je     107c7b8 <check_input_run+0xf428>
 107c736:	xor    %r10d,%r10d
 107c739:	jmp    107c746 <check_input_run+0xf3b6>
 107c73b:	inc    %r8
 107c73e:	inc    %r10
 107c741:	cmp    %rdi,%r10
 107c744:	je     107c7b8 <check_input_run+0xf428>
 107c746:	mov    0x28(%rsp),%rcx
 107c74b:	cmp    (%rcx),%r9d
 107c74e:	jae    107c79c <check_input_run+0xf40c>
 107c750:	mov    %r9d,%r9d
 107c753:	lea    (%r9,%r9,2),%r11
 107c757:	lea    0xb(,%r11,4),%r11
 107c75f:	mov    0x860(%rsp),%r14
 107c767:	mov    0x1d0(%r14),%r14
 107c76e:	cmp    %r8d,(%r14,%r11,4)
 107c772:	ja     107c79c <check_input_run+0xf40c>
 107c774:	mov    0x180(%rsp),%rcx
 107c77c:	mov    0x28(%rsp),%rbx
 107c781:	lea    (%rdx,%r8,1),%ebp
 107c785:	add    $0xc,%r11
 107c789:	mov    %ebp,(%rcx,%r9,4)
 107c78d:	add    (%rsi,%r9,4),%edx
 107c791:	mov    (%rbx),%r14d
 107c794:	inc    %r9
 107c797:	cmp    %r14,%r9
 107c79a:	jb     107c75f <check_input_run+0xf3cf>
 107c79c:	cmp    0x100(%rsp),%r8
 107c7a4:	jae    107c73b <check_input_run+0xf3ab>
 107c7a6:	mov    0x148(%rsp),%rcx
 107c7ae:	lea    (%rdx,%r8,1),%r11d
 107c7b2:	mov    %r11d,(%rcx,%r8,4)
 107c7b6:	jmp    107c73b <check_input_run+0xf3ab>
 107c7b8:	cmpl   $0x0,0x60(%rsp)
 107c7bd:	je     107c8c0 <check_input_run+0xf530>
 107c7c3:	mov    0x60(%rsp),%r8
 107c7c8:	mov    %r8d,%edi
 107c7cb:	and    $0x7,%edi
 107c7ce:	cmp    $0x8,%r8d
 107c7d2:	jae    107c7dc <check_input_run+0xf44c>
 107c7d4:	xor    %r8d,%r8d
 107c7d7:	jmp    107c88f <check_input_run+0xf4ff>
 107c7dc:	mov    0x1b0(%rsp),%r14
 107c7e4:	mov    0x60(%rsp),%r8
 107c7e9:	shr    $0x3,%r8d
 107c7ed:	xor    %r10d,%r10d
 107c7f0:	imul   $0xa80,%r8,%r9
 107c7f7:	xor    %r8d,%r8d
 107c7fa:	mov    (%r14),%r11
 107c7fd:	mov    0x60(%r11,%r10,1),%r11d
 107c802:	mov    %r11d,(%rsi,%r8,4)
 107c806:	mov    (%r14),%r11
 107c809:	mov    0x1b0(%r11,%r10,1),%r11d
 107c811:	mov    %r11d,0x4(%rsi,%r8,4)
 107c816:	mov    (%r14),%r11
 107c819:	mov    0x300(%r11,%r10,1),%r11d
 107c821:	mov    %r11d,0x8(%rsi,%r8,4)
 107c826:	mov    (%r14),%r11
 107c829:	mov    0x450(%r11,%r10,1),%r11d
 107c831:	mov    %r11d,0xc(%rsi,%r8,4)
 107c836:	mov    (%r14),%r11
 107c839:	mov    0x5a0(%r11,%r10,1),%r11d
 107c841:	mov    %r11d,0x10(%rsi,%r8,4)
 107c846:	mov    (%r14),%r11
 107c849:	mov    0x6f0(%r11,%r10,1),%r11d
 107c851:	mov    %r11d,0x14(%rsi,%r8,4)
 107c856:	mov    (%r14),%r11
 107c859:	mov    0x840(%r11,%r10,1),%r11d
 107c861:	mov    %r11d,0x18(%rsi,%r8,4)
 107c866:	mov    (%r14),%r11
 107c869:	mov    0x990(%r11,%r10,1),%r11d
 107c871:	add    $0xa80,%r10
 107c878:	mov    %r11d,0x1c(%rsi,%r8,4)
 107c87d:	add    $0x8,%r8
 107c881:	cmp    %r10,%r9
 107c884:	jne    107c7fa <check_input_run+0xf46a>
 107c88a:	test   %rdi,%rdi
 107c88d:	je     107c8c0 <check_input_run+0xf530>
 107c88f:	lea    (%rsi,%r8,4),%r9
 107c893:	imul   $0x150,%r8,%r8
 107c89a:	xor    %r10d,%r10d
 107c89d:	mov    0x1b0(%rsp),%r11
 107c8a5:	mov    (%r11),%r11
 107c8a8:	mov    0x60(%r11,%r8,1),%r11d
 107c8ad:	add    $0x150,%r8
 107c8b4:	mov    %r11d,(%r9,%r10,4)
 107c8b8:	inc    %r10
 107c8bb:	cmp    %r10,%rdi
 107c8be:	jne    107c89d <check_input_run+0xf50d>
 107c8c0:	mov    0xa0(%rsp),%r11
 107c8c8:	mov    0xb0(%rsp),%rdi
 107c8d0:	add    0x68(%rsp),%edi
 107c8d4:	lea    0x1(%r11),%ecx
 107c8d8:	cmp    $0x1,%ecx
 107c8db:	mov    %rdi,0xb0(%rsp)
 107c8e3:	adc    $0x1,%r11d
 107c8e7:	mov    %r11d,%r8d
 107c8ea:	and    $0x3,%r8d
 107c8ee:	cmp    $0x4,%ecx
 107c8f1:	jae    107c900 <check_input_run+0xf570>
 107c8f3:	xor    %r9d,%r9d
 107c8f6:	xor    %r10d,%r10d
 107c8f9:	xor    %edi,%edi
 107c8fb:	jmp    107cad8 <check_input_run+0xf748>
 107c900:	and    $0xfffffffc,%r11d
 107c904:	xor    %r9d,%r9d
 107c907:	xor    %r10d,%r10d
 107c90a:	xor    %edi,%edi
 107c90c:	jmp    107c91b <check_input_run+0xf58b>
 107c90e:	add    $0x4,%r9
 107c912:	cmp    %r11,%r9
 107c915:	je     107cad3 <check_input_run+0xf743>
 107c91b:	mov    0x28(%rsp),%rcx
 107c920:	cmp    (%rcx),%r10d
 107c923:	jae    107c971 <check_input_run+0xf5e1>
 107c925:	mov    %r10d,%r10d
 107c928:	lea    (%r10,%r10,2),%r14
 107c92c:	lea    0x4(,%r14,4),%r14
 107c934:	mov    0x860(%rsp),%r15
 107c93c:	mov    0x1d0(%r15),%r15
 107c943:	cmp    %r9d,(%r15,%r14,4)
 107c947:	ja     107c971 <check_input_run+0xf5e1>
 107c949:	mov    0x1a8(%rsp),%rcx
 107c951:	mov    0x28(%rsp),%rbx
 107c956:	lea    (%rdi,%r9,1),%ebp
 107c95a:	add    $0xc,%r14
 107c95e:	mov    %ebp,(%rcx,%r10,4)
 107c962:	add    (%rsi,%r10,4),%edi
 107c966:	mov    (%rbx),%r15d
 107c969:	inc    %r10
 107c96c:	cmp    %r15,%r10
 107c96f:	jb     107c934 <check_input_run+0xf5a4>
 107c971:	cmp    0xa0(%rsp),%r9
 107c979:	jae    107c983 <check_input_run+0xf5f3>
 107c97b:	lea    (%rdi,%r9,1),%ebp
 107c97f:	mov    %ebp,(%rax,%r9,4)
 107c983:	mov    0x28(%rsp),%rcx
 107c988:	lea    0x1(%r9),%r14
 107c98c:	cmp    (%rcx),%r10d
 107c98f:	jae    107c9de <check_input_run+0xf64e>
 107c991:	mov    %r10d,%r10d
 107c994:	lea    (%r10,%r10,2),%r15
 107c998:	lea    0x4(,%r15,4),%r15
 107c9a0:	mov    0x860(%rsp),%r12
 107c9a8:	mov    0x1d0(%r12),%r12
 107c9b0:	cmp    %r14d,(%r12,%r15,4)
 107c9b4:	ja     107c9de <check_input_run+0xf64e>
 107c9b6:	mov    0x1a8(%rsp),%rcx
 107c9be:	mov    0x28(%rsp),%rbx
 107c9c3:	lea    (%rdi,%r14,1),%ebp
 107c9c7:	add    $0xc,%r15
 107c9cb:	mov    %ebp,(%rcx,%r10,4)
 107c9cf:	add    (%rsi,%r10,4),%edi
 107c9d3:	mov    (%rbx),%r12d
 107c9d6:	inc    %r10
 107c9d9:	cmp    %r12,%r10
 107c9dc:	jb     107c9a0 <check_input_run+0xf610>
 107c9de:	cmp    0xa0(%rsp),%r14
 107c9e6:	jae    107c9f0 <check_input_run+0xf660>
 107c9e8:	lea    (%rdi,%r14,1),%ebp
 107c9ec:	mov    %ebp,(%rax,%r14,4)
 107c9f0:	mov    0x28(%rsp),%rcx
 107c9f5:	lea    0x2(%r9),%r14
 107c9f9:	cmp    (%rcx),%r10d
 107c9fc:	jae    107ca4b <check_input_run+0xf6bb>
 107c9fe:	mov    %r10d,%r10d
 107ca01:	lea    (%r10,%r10,2),%r15
 107ca05:	lea    0x4(,%r15,4),%r15
 107ca0d:	mov    0x860(%rsp),%r12
 107ca15:	mov    0x1d0(%r12),%r12
 107ca1d:	cmp    %r14d,(%r12,%r15,4)
 107ca21:	ja     107ca4b <check_input_run+0xf6bb>
 107ca23:	mov    0x1a8(%rsp),%rcx
 107ca2b:	mov    0x28(%rsp),%rbx
 107ca30:	lea    (%rdi,%r14,1),%ebp
 107ca34:	add    $0xc,%r15
 107ca38:	mov    %ebp,(%rcx,%r10,4)
 107ca3c:	add    (%rsi,%r10,4),%edi
 107ca40:	mov    (%rbx),%r12d
 107ca43:	inc    %r10
 107ca46:	cmp    %r12,%r10
 107ca49:	jb     107ca0d <check_input_run+0xf67d>
 107ca4b:	cmp    0xa0(%rsp),%r14
 107ca53:	jae    107ca5d <check_input_run+0xf6cd>
 107ca55:	lea    (%rdi,%r14,1),%ebp
 107ca59:	mov    %ebp,(%rax,%r14,4)
 107ca5d:	mov    0x28(%rsp),%rcx
 107ca62:	lea    0x3(%r9),%r14
 107ca66:	cmp    (%rcx),%r10d
 107ca69:	jae    107cab8 <check_input_run+0xf728>
 107ca6b:	mov    %r10d,%r10d
 107ca6e:	lea    (%r10,%r10,2),%r15
 107ca72:	lea    0x4(,%r15,4),%r15
 107ca7a:	mov    0x860(%rsp),%r12
 107ca82:	mov    0x1d0(%r12),%r12
 107ca8a:	cmp    %r14d,(%r12,%r15,4)
 107ca8e:	ja     107cab8 <check_input_run+0xf728>
 107ca90:	mov    0x1a8(%rsp),%rcx
 107ca98:	mov    0x28(%rsp),%rbx
 107ca9d:	lea    (%rdi,%r14,1),%ebp
 107caa1:	add    $0xc,%r15
 107caa5:	mov    %ebp,(%rcx,%r10,4)
 107caa9:	add    (%rsi,%r10,4),%edi
 107caad:	mov    (%rbx),%r12d
 107cab0:	inc    %r10
 107cab3:	cmp    %r12,%r10
 107cab6:	jb     107ca7a <check_input_run+0xf6ea>
 107cab8:	cmp    0xa0(%rsp),%r14
 107cac0:	jae    107c90e <check_input_run+0xf57e>
 107cac6:	lea    (%rdi,%r14,1),%ebp
 107caca:	mov    %ebp,(%rax,%r14,4)
 107cace:	jmp    107c90e <check_input_run+0xf57e>
 107cad3:	test   %r8,%r8
 107cad6:	je     107cb52 <check_input_run+0xf7c2>
 107cad8:	xor    %r11d,%r11d
 107cadb:	jmp    107cae8 <check_input_run+0xf758>
 107cadd:	inc    %r9
 107cae0:	inc    %r11
 107cae3:	cmp    %r8,%r11
 107cae6:	je     107cb52 <check_input_run+0xf7c2>
 107cae8:	mov    0x28(%rsp),%rcx
 107caed:	cmp    (%rcx),%r10d
 107caf0:	jae    107cb3e <check_input_run+0xf7ae>
 107caf2:	mov    %r10d,%r10d
 107caf5:	lea    (%r10,%r10,2),%r14
 107caf9:	lea    0x4(,%r14,4),%r14
 107cb01:	mov    0x860(%rsp),%r15
 107cb09:	mov    0x1d0(%r15),%r15
 107cb10:	cmp    %r9d,(%r15,%r14,4)
 107cb14:	ja     107cb3e <check_input_run+0xf7ae>
 107cb16:	mov    0x1a8(%rsp),%rcx
 107cb1e:	mov    0x28(%rsp),%rbx
 107cb23:	lea    (%rdi,%r9,1),%ebp
 107cb27:	add    $0xc,%r14
 107cb2b:	mov    %ebp,(%rcx,%r10,4)
 107cb2f:	add    (%rsi,%r10,4),%edi
 107cb33:	mov    (%rbx),%r15d
 107cb36:	inc    %r10
 107cb39:	cmp    %r15,%r10
 107cb3c:	jb     107cb01 <check_input_run+0xf771>
 107cb3e:	cmp    0xa0(%rsp),%r9
 107cb46:	jae    107cadd <check_input_run+0xf74d>
 107cb48:	lea    (%rdi,%r9,1),%ebp
 107cb4c:	mov    %ebp,(%rax,%r9,4)
 107cb50:	jmp    107cadd <check_input_run+0xf74d>
 107cb52:	mov    0xe8(%rsp),%rcx
 107cb5a:	inc    %ecx
 107cb5c:	mov    %rcx,0x28(%rsp)
 107cb61:	cmp    %ecx,0xb0(%rsp)
 107cb68:	ja     107830e <check_input_run+0xaf7e>
 107cb6e:	mov    0xe0(%rsp),%rcx
 107cb76:	add    0x98(%rsp),%ecx
 107cb7d:	mov    %rcx,0xe0(%rsp)
 107cb85:	cmp    0x28(%rsp),%ecx
 107cb89:	ja     107830e <check_input_run+0xaf7e>
 107cb8f:	mov    0x108(%rsp),%rcx
 107cb97:	mov    0xb8(%rsp),%rsi
 107cb9f:	add    0xd8(%rsp),%ecx
 107cba6:	mov    %rcx,0x108(%rsp)
 107cbae:	cmp    0x33c(%rsi),%ecx
 107cbb4:	ja     107830e <check_input_run+0xaf7e>
 107cbba:	mov    0x128(%rsp),%rcx
 107cbc2:	mov    0xb8(%rsp),%rsi
 107cbca:	add    0x70(%rsp),%ecx
 107cbce:	mov    %rcx,0x128(%rsp)
 107cbd6:	cmp    0x34c(%rsi),%ecx
 107cbdc:	ja     107830e <check_input_run+0xaf7e>
 107cbe2:	mov    0x120(%rsp),%rcx
 107cbea:	add    0xc0(%rsp),%ecx
 107cbf1:	mov    %rcx,0x120(%rsp)
 107cbf9:	cmp    0x4e4(%rsp),%ecx
 107cc00:	ja     107830e <check_input_run+0xaf7e>
 107cc06:	add    0xa0(%rsp),%edi
 107cc0d:	cmp    0x2dc(%rsp),%edi
 107cc14:	ja     107830e <check_input_run+0xaf7e>
 107cc1a:	mov    0x2c0(%rsp),%rsi
 107cc22:	mov    (%rsi),%r9
 107cc25:	mov    0x8(%rsi),%r8
 107cc29:	lea    0x7(%r8,%r9,1),%rcx
 107cc2e:	add    %r9,%r8
 107cc31:	and    $0xfffffffffffffff8,%rcx
 107cc35:	mov    %rcx,0x178(%rsp)
 107cc3d:	cmp    %r8,%rcx
 107cc40:	jb     107830e <check_input_run+0xaf7e>
 107cc46:	mov    0x178(%rsp),%r8
 107cc4e:	sub    %r9,%r8
 107cc51:	mov    0x10(%rsi),%r9
 107cc55:	sub    %r8,%r9
 107cc58:	jb     107830e <check_input_run+0xaf7e>
 107cc5e:	mov    0xe8(%rsp),%rcx
 107cc66:	lea    (%rcx,%rcx,4),%r10
 107cc6a:	lea    0x28(,%r10,8),%r10
 107cc72:	cmp    %r9,%r10
 107cc75:	ja     107830e <check_input_run+0xaf7e>
 107cc7b:	add    %r10,%r8
 107cc7e:	cmpq   $0x0,0x178(%rsp)
 107cc87:	mov    %r8,0x8(%rsi)
 107cc8b:	je     107830e <check_input_run+0xaf7e>
 107cc91:	mov    0x2c0(%rsp),%rsi
 107cc99:	mov    (%rsi),%r9
 107cc9c:	mov    0x8(%rsi),%r8
 107cca0:	lea    0x3(%r8,%r9,1),%rcx
 107cca5:	add    %r9,%r8
 107cca8:	and    $0xfffffffffffffffc,%rcx
 107ccac:	mov    %rcx,0x1f8(%rsp)
 107ccb4:	cmp    %r8,%rcx
 107ccb7:	jb     107830e <check_input_run+0xaf7e>
 107ccbd:	mov    0x1f8(%rsp),%r8
 107ccc5:	sub    %r9,%r8
 107ccc8:	mov    0x10(%rsi),%r9
 107cccc:	sub    %r8,%r9
 107cccf:	jb     107830e <check_input_run+0xaf7e>
 107ccd5:	mov    0xe8(%rsp),%rcx
 107ccdd:	lea    (%rcx,%rcx,2),%r10
 107cce1:	lea    0x18(,%r10,8),%r10
 107cce9:	cmp    %r9,%r10
 107ccec:	ja     107830e <check_input_run+0xaf7e>
 107ccf2:	add    %r10,%r8
 107ccf5:	cmpq   $0x0,0x1f8(%rsp)
 107ccfe:	mov    %r8,0x8(%rsi)
 107cd02:	je     107830e <check_input_run+0xaf7e>
 107cd08:	mov    0x2c0(%rsp),%rsi
 107cd10:	mov    (%rsi),%r9
 107cd13:	mov    0x8(%rsi),%r8
 107cd17:	lea    0x3(%r8,%r9,1),%rcx
 107cd1c:	add    %r9,%r8
 107cd1f:	and    $0xfffffffffffffffc,%rcx
 107cd23:	mov    %rcx,0x160(%rsp)
 107cd2b:	cmp    %r8,%rcx
 107cd2e:	jb     107830e <check_input_run+0xaf7e>
 107cd34:	mov    0x160(%rsp),%r8
 107cd3c:	sub    %r9,%r8
 107cd3f:	mov    0x10(%rsi),%r9
 107cd43:	sub    %r8,%r9
 107cd46:	jb     107830e <check_input_run+0xaf7e>
 107cd4c:	mov    0xb8(%rsp),%r10
 107cd54:	mov    0x33c(%r10),%r10d
 107cd5b:	lea    (%r10,%r10,8),%r10
 107cd5f:	lea    0x24(,%r10,4),%r10
 107cd67:	cmp    %r9,%r10
 107cd6a:	ja     107830e <check_input_run+0xaf7e>
 107cd70:	add    %r10,%r8
 107cd73:	cmpq   $0x0,0x160(%rsp)
 107cd7c:	mov    %r8,0x8(%rsi)
 107cd80:	je     107830e <check_input_run+0xaf7e>
 107cd86:	mov    0x2c0(%rsp),%rsi
 107cd8e:	mov    (%rsi),%r9
 107cd91:	mov    0x8(%rsi),%r8
 107cd95:	lea    0x7(%r8,%r9,1),%rcx
 107cd9a:	add    %r9,%r8
 107cd9d:	and    $0xfffffffffffffff8,%rcx
 107cda1:	mov    %rcx,0x1f0(%rsp)
 107cda9:	cmp    %r8,%rcx
 107cdac:	jb     107830e <check_input_run+0xaf7e>
 107cdb2:	mov    0x1f0(%rsp),%r8
 107cdba:	sub    %r9,%r8
 107cdbd:	mov    0x10(%rsi),%r9
 107cdc1:	sub    %r8,%r9
 107cdc4:	jb     107830e <check_input_run+0xaf7e>
 107cdca:	mov    0xb8(%rsp),%r10
 107cdd2:	mov    0x34c(%r10),%r10d
 107cdd9:	lea    (%r10,%r10,4),%r10
 107cddd:	shl    $0x4,%r10
 107cde1:	add    $0x50,%r10
 107cde5:	cmp    %r9,%r10
 107cde8:	ja     107830e <check_input_run+0xaf7e>
 107cdee:	add    %r10,%r8
 107cdf1:	cmpq   $0x0,0x1f0(%rsp)
 107cdfa:	mov    %r8,0x8(%rsi)
 107cdfe:	je     107830e <check_input_run+0xaf7e>
 107ce04:	mov    0x2c8(%rsp),%rsi
 107ce0c:	mov    (%rsi),%r9
 107ce0f:	mov    0x8(%rsi),%r8
 107ce13:	lea    0x3(%r8,%r9,1),%rcx
 107ce18:	add    %r9,%r8
 107ce1b:	and    $0xfffffffffffffffc,%rcx
 107ce1f:	mov    %rcx,0x208(%rsp)
 107ce27:	cmp    %r8,%rcx
 107ce2a:	jb     107830e <check_input_run+0xaf7e>
 107ce30:	mov    0x208(%rsp),%r8
 107ce38:	sub    %r9,%r8
 107ce3b:	mov    0x10(%rsi),%r9
 107ce3f:	sub    %r8,%r9
 107ce42:	jb     107830e <check_input_run+0xaf7e>
 107ce48:	mov    0x4e4(%rsp),%r10d
 107ce50:	imul   $0x2c,%r10,%r10
 107ce54:	add    $0x2c,%r10
 107ce58:	cmp    %r9,%r10
 107ce5b:	ja     107830e <check_input_run+0xaf7e>
 107ce61:	add    %r10,%r8
 107ce64:	cmpq   $0x0,0x208(%rsp)
 107ce6d:	mov    %r8,0x8(%rsi)
 107ce71:	je     107830e <check_input_run+0xaf7e>
 107ce77:	mov    0x2c8(%rsp),%rsi
 107ce7f:	mov    (%rsi),%r9
 107ce82:	mov    0x8(%rsi),%r8
 107ce86:	add    %r9,%r8
 107ce89:	lea    0xf(%r8),%rcx
 107ce8d:	and    $0xfffffffffffffff0,%rcx
 107ce91:	mov    %rcx,0x140(%rsp)
 107ce99:	cmp    %r8,%rcx
 107ce9c:	jb     107830e <check_input_run+0xaf7e>
 107cea2:	mov    0x140(%rsp),%r8
 107ceaa:	sub    %r9,%r8
 107cead:	mov    0x10(%rsi),%r9
 107ceb1:	sub    %r8,%r9
 107ceb4:	jb     107830e <check_input_run+0xaf7e>
 107ceba:	add    0x100(%rsp),%edx
 107cec1:	mov    %edx,%r10d
 107cec4:	lea    (%r10,%r10,2),%r10
 107cec8:	mov    %rdx,0x268(%rsp)
 107ced0:	shl    $0x5,%r10
 107ced4:	add    $0x60,%r10
 107ced8:	cmp    %r9,%r10
 107cedb:	ja     107830e <check_input_run+0xaf7e>
 107cee1:	add    %r10,%r8
 107cee4:	cmpq   $0x0,0x140(%rsp)
 107ceed:	mov    %r8,0x8(%rsi)
 107cef1:	je     107d28b <check_input_run+0xfefb>
 107cef7:	cmpl   $0x0,0x68(%rsp)
 107cefc:	je     107d28b <check_input_run+0xfefb>
 107cf02:	xor    %r8d,%r8d
 107cf05:	cmpl   $0x1,0x68(%rsp)
 107cf0a:	jne    107cfe7 <check_input_run+0xfc57>
 107cf10:	xor    %esi,%esi
 107cf12:	jmp    107d157 <check_input_run+0xfdc7>
 107cf17:	mov    0x10(%rsp),%rdi
 107cf1c:	add    %rdx,%rsi
 107cf1f:	mov    %rsi,0x8(%rdi)
 107cf23:	mov    0x18(%rsp),%rdi
 107cf28:	mov    %rcx,0x290(%rdi)
 107cf2f:	test   %rcx,%rcx
 107cf32:	je     107cf7d <check_input_run+0xfbed>
 107cf34:	mov    0x10(%rsp),%rcx
 107cf39:	mov    (%rcx),%rdi
 107cf3c:	mov    0x8(%rcx),%rsi
 107cf40:	lea    0x7(%rsi,%rdi,1),%rcx
 107cf45:	add    %rdi,%rsi
 107cf48:	and    $0xfffffffffffffff8,%rcx
 107cf4c:	cmp    %rsi,%rcx
 107cf4f:	jb     107cf7d <check_input_run+0xfbed>
 107cf51:	mov    %rcx,%rsi
 107cf54:	sub    %rdi,%rsi
 107cf57:	mov    0x10(%rsp),%rdi
 107cf5c:	mov    0x10(%rdi),%rdi
 107cf60:	sub    %rsi,%rdi
 107cf63:	setb   %r8b
 107cf67:	cmp    0x78(%rsp),%rdi
 107cf6c:	setbe  %dil
 107cf70:	or     %r8b,%dil
 107cf73:	cmp    $0x1,%dil
 107cf77:	jne    107d1e1 <check_input_run+0xfe51>
 107cf7d:	mov    0x18(%rsp),%rdi
 107cf82:	mov    0x10(%rsp),%rsi
 107cf87:	mov    0x20(%rsp),%r12
 107cf8c:	mov    0x40(%rsp),%rax
 107cf91:	mov    0x30(%rsp),%r9
 107cf96:	movq   $0x0,0x298(%rdi)
 107cfa1:	jmp    106dc85 <check_input_run+0x8f5>
 107cfa6:	xor    %esi,%esi
 107cfa8:	xor    %ecx,%ecx
 107cfaa:	jmp    107cfdd <check_input_run+0xfc4d>
 107cfac:	mov    %rax,%rdi
 107cfaf:	sub    %rcx,%rdi
 107cfb2:	xor    %ecx,%ecx
 107cfb4:	sub    %rdi,%rdx
 107cfb7:	jb     107cfdd <check_input_run+0xfc4d>
 107cfb9:	mov    0x100(%rsp),%r8
 107cfc1:	lea    0x0(,%r8,4),%r8
 107cfc9:	cmp    %rdx,%r8
 107cfcc:	ja     107cfdd <check_input_run+0xfc4d>
 107cfce:	mov    0x38(%rsp),%rcx
 107cfd3:	add    %r8,%rdi
 107cfd6:	mov    %rdi,0x8(%rcx)
 107cfda:	mov    %rax,%rcx
 107cfdd:	mov    0x20(%rsp),%r12
 107cfe2:	jmp    106e4a1 <check_input_run+0x1111>
 107cfe7:	mov    0x68(%rsp),%r9
 107cfec:	and    $0xfffffffe,%r9d
 107cff0:	xor    %esi,%esi
 107cff2:	mov    0xb8(%rsp),%r12
 107cffa:	lea    0x0(,%rsi,8),%r14
 107d002:	mov    0x0(%r13,%rsi,4),%r10d
 107d007:	mov    0x178(%rsp),%rcx
 107d00f:	lea    (%r14,%r14,4),%r14
 107d013:	mov    0x358(%r12),%r11
 107d01b:	lea    (%r10,%r10,4),%r10
 107d01f:	mov    0x20(%r11,%r14,1),%r15
 107d024:	mov    %r15,0x20(%rcx,%r10,8)
 107d029:	vmovdqu (%r11,%r14,1),%ymm0
 107d02f:	mov    $0x0,%r11d
 107d035:	vmovdqu %ymm0,(%rcx,%r10,8)
 107d03b:	mov    0x358(%r12),%r10
 107d043:	mov    0x8(%r10,%r14,1),%r10d
 107d048:	test   %r10d,%r10d
 107d04b:	je     107d085 <check_input_run+0xfcf5>
 107d04d:	mov    %r10d,%r11d
 107d050:	shr    $0x3,%r11d
 107d054:	cmpq   $0x0,0x50(%rsp)
 107d05a:	je     107d07d <check_input_run+0xfced>
 107d05c:	mov    0x50(%rsp),%r14
 107d061:	mov    %r11d,%r15d
 107d064:	sub    0x10(%r14),%r15d
 107d068:	jae    107d075 <check_input_run+0xfce5>
 107d06a:	mov    0x8(%r14),%r14
 107d06e:	test   %r14,%r14
 107d071:	jne    107d061 <check_input_run+0xfcd1>
 107d073:	jmp    107d07d <check_input_run+0xfced>
 107d075:	mov    0x18(%r14),%r11
 107d079:	mov    (%r11,%r15,4),%r11d
 107d07d:	and    $0x7,%r10d
 107d081:	lea    (%r10,%r11,8),%r11d
 107d085:	mov    0x0(%r13,%rsi,4),%r10d
 107d08a:	mov    0x178(%rsp),%rcx
 107d092:	mov    0xb8(%rsp),%r12
 107d09a:	lea    0x8(,%rsi,8),%r14
 107d0a2:	lea    (%r14,%r14,4),%r14
 107d0a6:	lea    (%r10,%r10,4),%r10
 107d0aa:	mov    %r11d,0x8(%rcx,%r10,8)
 107d0af:	mov    0x358(%r12),%r11
 107d0b7:	mov    0x4(%r13,%rsi,4),%r10d
 107d0bc:	mov    0x20(%r11,%r14,1),%r15
 107d0c1:	lea    (%r10,%r10,4),%r10
 107d0c5:	mov    %r15,0x20(%rcx,%r10,8)
 107d0ca:	vmovdqu (%r11,%r14,1),%ymm0
 107d0d0:	vmovdqu %ymm0,(%rcx,%r10,8)
 107d0d6:	mov    0x358(%r12),%r10
 107d0de:	mov    0x8(%r10,%r14,1),%r10d
 107d0e3:	test   %r10d,%r10d
 107d0e6:	je     107d110 <check_input_run+0xfd80>
 107d0e8:	mov    %r10d,%r11d
 107d0eb:	shr    $0x3,%r11d
 107d0ef:	cmpq   $0x0,0x50(%rsp)
 107d0f5:	je     107d11d <check_input_run+0xfd8d>
 107d0f7:	mov    0x50(%rsp),%r14
 107d0fc:	mov    %r11d,%r15d
 107d0ff:	sub    0x10(%r14),%r15d
 107d103:	jae    107d115 <check_input_run+0xfd85>
 107d105:	mov    0x8(%r14),%r14
 107d109:	test   %r14,%r14
 107d10c:	jne    107d0fc <check_input_run+0xfd6c>
 107d10e:	jmp    107d11d <check_input_run+0xfd8d>
 107d110:	xor    %r10d,%r10d
 107d113:	jmp    107d125 <check_input_run+0xfd95>
 107d115:	mov    0x18(%r14),%r11
 107d119:	mov    (%r11,%r15,4),%r11d
 107d11d:	and    $0x7,%r10d
 107d121:	lea    (%r10,%r11,8),%r10d
 107d125:	lea    0x1(%rsi),%r11
 107d129:	mov    0x178(%rsp),%rcx
 107d131:	add    $0x2,%rsi
 107d135:	mov    0x0(%r13,%r11,4),%r11d
 107d13a:	lea    (%r11,%r11,4),%r11
 107d13e:	mov    %r10d,0x8(%rcx,%r11,8)
 107d143:	cmp    %r9,%rsi
 107d146:	jne    107cff2 <check_input_run+0xfc62>
 107d14c:	testb  $0x1,0x68(%rsp)
 107d151:	je     107d28b <check_input_run+0xfefb>
 107d157:	mov    0xb8(%rsp),%r15
 107d15f:	lea    0x0(,%rsi,8),%r11
 107d167:	mov    0x0(%r13,%rsi,4),%r9d
 107d16c:	mov    0x178(%rsp),%rcx
 107d174:	lea    (%r11,%r11,4),%r11
 107d178:	mov    0x358(%r15),%r10
 107d17f:	lea    (%r9,%r9,4),%r9
 107d183:	mov    0x20(%r10,%r11,1),%r14
 107d188:	mov    %r14,0x20(%rcx,%r9,8)
 107d18d:	vmovdqu (%r10,%r11,1),%ymm0
 107d193:	vmovdqu %ymm0,(%rcx,%r9,8)
 107d199:	mov    0x358(%r15),%r9
 107d1a0:	mov    0x8(%r9,%r11,1),%r9d
 107d1a5:	test   %r9d,%r9d
 107d1a8:	je     107d275 <check_input_run+0xfee5>
 107d1ae:	mov    %r9d,%r8d
 107d1b1:	shr    $0x3,%r8d
 107d1b5:	cmpq   $0x0,0x50(%rsp)
 107d1bb:	je     107d26d <check_input_run+0xfedd>
 107d1c1:	mov    0x50(%rsp),%r10
 107d1c6:	mov    %r8d,%r11d
 107d1c9:	sub    0x10(%r10),%r11d
 107d1cd:	jae    107d265 <check_input_run+0xfed5>
 107d1d3:	mov    0x8(%r10),%r10
 107d1d7:	test   %r10,%r10
 107d1da:	jne    107d1c6 <check_input_run+0xfe36>
 107d1dc:	jmp    107d26d <check_input_run+0xfedd>
 107d1e1:	mov    0x10(%rsp),%rdi
 107d1e6:	add    %rdx,%rsi
 107d1e9:	mov    %rsi,0x8(%rdi)
 107d1ed:	mov    0x18(%rsp),%rdi
 107d1f2:	mov    %rcx,0x298(%rdi)
 107d1f9:	test   %rcx,%rcx
 107d1fc:	je     107d247 <check_input_run+0xfeb7>
 107d1fe:	mov    0x10(%rsp),%rcx
 107d203:	mov    (%rcx),%rdi
 107d206:	mov    0x8(%rcx),%rsi
 107d20a:	lea    0x7(%rsi,%rdi,1),%rcx
 107d20f:	add    %rdi,%rsi
 107d212:	and    $0xfffffffffffffff8,%rcx
 107d216:	cmp    %rsi,%rcx
 107d219:	jb     107d247 <check_input_run+0xfeb7>
 107d21b:	mov    %rcx,%rsi
 107d21e:	sub    %rdi,%rsi
 107d221:	mov    0x10(%rsp),%rdi
 107d226:	mov    0x10(%rdi),%rdi
 107d22a:	sub    %rsi,%rdi
 107d22d:	setb   %r8b
 107d231:	cmp    0x78(%rsp),%rdi
 107d236:	setbe  %dil
 107d23a:	or     %r8b,%dil
 107d23d:	cmp    $0x1,%dil
 107d241:	jne    107d2c8 <check_input_run+0xff38>
 107d247:	mov    0x18(%rsp),%rdi
 107d24c:	mov    0x10(%rsp),%rsi
 107d251:	mov    0x20(%rsp),%r12
 107d256:	mov    0x40(%rsp),%rax
 107d25b:	mov    0x30(%rsp),%r9
 107d260:	jmp    106dc85 <check_input_run+0x8f5>
 107d265:	mov    0x18(%r10),%r8
 107d269:	mov    (%r8,%r11,4),%r8d
 107d26d:	and    $0x7,%r9d
 107d271:	lea    (%r9,%r8,8),%r8d
 107d275:	mov    0x0(%r13,%rsi,4),%esi
 107d27a:	mov    0x178(%rsp),%rcx
 107d282:	lea    (%rsi,%rsi,4),%rsi
 107d286:	mov    %r8d,0x8(%rcx,%rsi,8)
 107d28b:	cmpq   $0x0,0x140(%rsp)
 107d294:	je     107d729 <check_input_run+0x10399>
 107d29a:	cmpl   $0x0,0x98(%rsp)
 107d2a2:	je     107d729 <check_input_run+0x10399>
 107d2a8:	mov    0x98(%rsp),%r8
 107d2b0:	mov    %r8d,%esi
 107d2b3:	and    $0x7,%esi
 107d2b6:	cmp    $0x8,%r8d
 107d2ba:	jae    107d539 <check_input_run+0x101a9>
 107d2c0:	xor    %r8d,%r8d
 107d2c3:	jmp    107d6cd <check_input_run+0x1033d>
 107d2c8:	mov    0x10(%rsp),%rdi
 107d2cd:	mov    0x18(%rsp),%r8
 107d2d2:	add    %rdx,%rsi
 107d2d5:	mov    %rsi,0x8(%rdi)
 107d2d9:	lea    0x2a0(%r8),%rdi
 107d2e0:	mov    %rcx,0x2a0(%r8)
 107d2e7:	mov    %rdi,0x118(%rsp)
 107d2ef:	test   %rcx,%rcx
 107d2f2:	je     107d75e <check_input_run+0x103ce>
 107d2f8:	mov    0x10(%rsp),%rcx
 107d2fd:	mov    (%rcx),%rdi
 107d300:	mov    0x8(%rcx),%rsi
 107d304:	lea    0x7(%rsi,%rdi,1),%rcx
 107d309:	add    %rdi,%rsi
 107d30c:	and    $0xfffffffffffffff8,%rcx
 107d310:	cmp    %rsi,%rcx
 107d313:	jb     107d75e <check_input_run+0x103ce>
 107d319:	mov    %rcx,%rsi
 107d31c:	sub    %rdi,%rsi
 107d31f:	mov    0x10(%rsp),%rdi
 107d324:	mov    0x10(%rdi),%rdi
 107d328:	sub    %rsi,%rdi
 107d32b:	jb     107d75e <check_input_run+0x103ce>
 107d331:	cmp    %rdi,%rax
 107d334:	ja     107d75e <check_input_run+0x103ce>
 107d33a:	mov    0x10(%rsp),%rdi
 107d33f:	mov    0x18(%rsp),%r8
 107d344:	add    %rax,%rsi
 107d347:	mov    %rsi,0x8(%rdi)
 107d34b:	lea    0x2a8(%r8),%rdi
 107d352:	mov    %rcx,0x2a8(%r8)
 107d359:	mov    %rdi,0x150(%rsp)
 107d361:	test   %rcx,%rcx
 107d364:	je     107d77c <check_input_run+0x103ec>
 107d36a:	mov    0x10(%rsp),%rcx
 107d36f:	mov    (%rcx),%rdi
 107d372:	mov    0x8(%rcx),%rsi
 107d376:	lea    0x7(%rsi,%rdi,1),%rcx
 107d37b:	add    %rdi,%rsi
 107d37e:	and    $0xfffffffffffffff8,%rcx
 107d382:	cmp    %rsi,%rcx
 107d385:	jb     107d77c <check_input_run+0x103ec>
 107d38b:	mov    %rcx,%rsi
 107d38e:	sub    %rdi,%rsi
 107d391:	mov    0x10(%rsp),%rdi
 107d396:	mov    0x10(%rdi),%rdi
 107d39a:	sub    %rsi,%rdi
 107d39d:	jb     107d77c <check_input_run+0x103ec>
 107d3a3:	cmp    %rdi,%rax
 107d3a6:	ja     107d77c <check_input_run+0x103ec>
 107d3ac:	mov    0x10(%rsp),%rdi
 107d3b1:	mov    0x18(%rsp),%r8
 107d3b6:	add    %rax,%rsi
 107d3b9:	mov    %rsi,0x8(%rdi)
 107d3bd:	lea    0x2b0(%r8),%rdi
 107d3c4:	mov    %rcx,0x2b0(%r8)
 107d3cb:	mov    %rdi,0x260(%rsp)
 107d3d3:	test   %rcx,%rcx
 107d3d6:	je     107d79a <check_input_run+0x1040a>
 107d3dc:	mov    0x10(%rsp),%rcx
 107d3e1:	mov    (%rcx),%rdi
 107d3e4:	mov    0x8(%rcx),%rsi
 107d3e8:	lea    0x7(%rsi,%rdi,1),%rcx
 107d3ed:	add    %rdi,%rsi
 107d3f0:	and    $0xfffffffffffffff8,%rcx
 107d3f4:	cmp    %rsi,%rcx
 107d3f7:	jb     107d79a <check_input_run+0x1040a>
 107d3fd:	mov    %rcx,%rsi
 107d400:	sub    %rdi,%rsi
 107d403:	mov    0x10(%rsp),%rdi
 107d408:	mov    0x10(%rdi),%rdi
 107d40c:	sub    %rsi,%rdi
 107d40f:	jb     107d79a <check_input_run+0x1040a>
 107d415:	cmp    %rdi,%rax
 107d418:	ja     107d79a <check_input_run+0x1040a>
 107d41e:	mov    0x10(%rsp),%rdi
 107d423:	mov    0x18(%rsp),%r8
 107d428:	add    %rax,%rsi
 107d42b:	mov    %rsi,0x8(%rdi)
 107d42f:	lea    0x2b8(%r8),%rdi
 107d436:	mov    %rcx,0x2b8(%r8)
 107d43d:	mov    %rdi,0x258(%rsp)
 107d445:	test   %rcx,%rcx
 107d448:	je     107d7b8 <check_input_run+0x10428>
 107d44e:	mov    0x10(%rsp),%rcx
 107d453:	mov    (%rcx),%rdi
 107d456:	mov    0x8(%rcx),%rsi
 107d45a:	lea    0x7(%rsi,%rdi,1),%rcx
 107d45f:	add    %rdi,%rsi
 107d462:	and    $0xfffffffffffffff8,%rcx
 107d466:	cmp    %rsi,%rcx
 107d469:	jb     107d7b8 <check_input_run+0x10428>
 107d46f:	mov    %rcx,%rsi
 107d472:	sub    %rdi,%rsi
 107d475:	mov    0x10(%rsp),%rdi
 107d47a:	mov    0x10(%rdi),%rdi
 107d47e:	sub    %rsi,%rdi
 107d481:	jb     107d7b8 <check_input_run+0x10428>
 107d487:	cmp    %rdi,%rax
 107d48a:	ja     107d7b8 <check_input_run+0x10428>
 107d490:	mov    0x10(%rsp),%rdi
 107d495:	mov    0x18(%rsp),%r8
 107d49a:	add    %rax,%rsi
 107d49d:	mov    %rsi,0x8(%rdi)
 107d4a1:	lea    0x2c0(%r8),%rdi
 107d4a8:	mov    %rcx,0x2c0(%r8)
 107d4af:	mov    %rdi,0x148(%rsp)
 107d4b7:	test   %rcx,%rcx
 107d4ba:	je     107d505 <check_input_run+0x10175>
 107d4bc:	mov    0x10(%rsp),%rcx
 107d4c1:	mov    (%rcx),%rdi
 107d4c4:	mov    0x8(%rcx),%rsi
 107d4c8:	lea    0x7(%rsi,%rdi,1),%rcx
 107d4cd:	add    %rdi,%rsi
 107d4d0:	and    $0xfffffffffffffff8,%rcx
 107d4d4:	cmp    %rsi,%rcx
 107d4d7:	jb     107d505 <check_input_run+0x10175>
 107d4d9:	mov    %rcx,%rsi
 107d4dc:	sub    %rdi,%rsi
 107d4df:	mov    0x10(%rsp),%rdi
 107d4e4:	mov    0x10(%rdi),%rdi
 107d4e8:	sub    %rsi,%rdi
 107d4eb:	setb   %r8b
 107d4ef:	cmp    0x78(%rsp),%rdi
 107d4f4:	setbe  %dil
 107d4f8:	or     %r8b,%dil
 107d4fb:	cmp    $0x1,%dil
 107d4ff:	jne    107d7d6 <check_input_run+0x10446>
 107d505:	mov    0x18(%rsp),%rdi
 107d50a:	mov    0x10(%rsp),%rsi
 107d50f:	mov    0x20(%rsp),%r12
 107d514:	mov    0x40(%rsp),%rax
 107d519:	mov    0x30(%rsp),%r9
 107d51e:	movq   $0x0,0x2c8(%rdi)
 107d529:	movq   $0x0,0x2d0(%rdi)
 107d534:	jmp    106dd1d <check_input_run+0x98d>
 107d539:	mov    0x110(%rsp),%r8
 107d541:	mov    0xb8(%rsp),%rbp
 107d549:	mov    0x1f8(%rsp),%rcx
 107d551:	xor    %r11d,%r11d
 107d554:	lea    0x1c(%r8),%r9
 107d558:	mov    0x98(%rsp),%r8
 107d560:	shr    $0x3,%r8d
 107d564:	shl    $0x6,%r8
 107d568:	lea    (%r8,%r8,2),%r10
 107d56c:	xor    %r8d,%r8d
 107d56f:	mov    0x318(%rbp),%r15
 107d576:	mov    -0x1c(%r9,%r8,4),%r14d
 107d57b:	mov    0x10(%r15,%r11,1),%r12
 107d580:	lea    (%r14,%r14,2),%r14
 107d584:	mov    %r12,0x10(%rcx,%r14,8)
 107d589:	vmovups (%r15,%r11,1),%xmm0
 107d58f:	vmovups %xmm0,(%rcx,%r14,8)
 107d595:	mov    0x318(%rbp),%r15
 107d59c:	mov    -0x18(%r9,%r8,4),%r14d
 107d5a1:	mov    0x28(%r15,%r11,1),%r12
 107d5a6:	lea    (%r14,%r14,2),%r14
 107d5aa:	mov    %r12,0x10(%rcx,%r14,8)
 107d5af:	vmovups 0x18(%r15,%r11,1),%xmm0
 107d5b6:	vmovups %xmm0,(%rcx,%r14,8)
 107d5bc:	mov    0x318(%rbp),%r15
 107d5c3:	mov    -0x14(%r9,%r8,4),%r14d
 107d5c8:	mov    0x40(%r15,%r11,1),%r12
 107d5cd:	lea    (%r14,%r14,2),%r14
 107d5d1:	mov    %r12,0x10(%rcx,%r14,8)
 107d5d6:	vmovups 0x30(%r15,%r11,1),%xmm0
 107d5dd:	vmovups %xmm0,(%rcx,%r14,8)
 107d5e3:	mov    0x318(%rbp),%r15
 107d5ea:	mov    -0x10(%r9,%r8,4),%r14d
 107d5ef:	mov    0x58(%r15,%r11,1),%r12
 107d5f4:	lea    (%r14,%r14,2),%r14
 107d5f8:	mov    %r12,0x10(%rcx,%r14,8)
 107d5fd:	vmovups 0x48(%r15,%r11,1),%xmm0
 107d604:	vmovups %xmm0,(%rcx,%r14,8)
 107d60a:	mov    0x318(%rbp),%r15
 107d611:	mov    -0xc(%r9,%r8,4),%r14d
 107d616:	mov    0x70(%r15,%r11,1),%r12
 107d61b:	lea    (%r14,%r14,2),%r14
 107d61f:	mov    %r12,0x10(%rcx,%r14,8)
 107d624:	vmovups 0x60(%r15,%r11,1),%xmm0
 107d62b:	vmovups %xmm0,(%rcx,%r14,8)
 107d631:	mov    0x318(%rbp),%r15
 107d638:	mov    -0x8(%r9,%r8,4),%r14d
 107d63d:	mov    0x88(%r15,%r11,1),%r12
 107d645:	lea    (%r14,%r14,2),%r14
 107d649:	mov    %r12,0x10(%rcx,%r14,8)
 107d64e:	vmovups 0x78(%r15,%r11,1),%xmm0
 107d655:	vmovups %xmm0,(%rcx,%r14,8)
 107d65b:	mov    0x318(%rbp),%r15
 107d662:	mov    -0x4(%r9,%r8,4),%r14d
 107d667:	mov    0xa0(%r15,%r11,1),%r12
 107d66f:	lea    (%r14,%r14,2),%r14
 107d673:	mov    %r12,0x10(%rcx,%r14,8)
 107d678:	vmovups 0x90(%r15,%r11,1),%xmm0
 107d682:	vmovups %xmm0,(%rcx,%r14,8)
 107d688:	mov    0x318(%rbp),%r15
 107d68f:	mov    (%r9,%r8,4),%r14d
 107d693:	add    $0x8,%r8
 107d697:	mov    0xb8(%r15,%r11,1),%r12
 107d69f:	lea    (%r14,%r14,2),%r14
 107d6a3:	mov    %r12,0x10(%rcx,%r14,8)
 107d6a8:	vmovdqu 0xa8(%r15,%r11,1),%xmm0
 107d6b2:	add    $0xc0,%r11
 107d6b9:	vmovdqu %xmm0,(%rcx,%r14,8)
 107d6bf:	cmp    %r11,%r10
 107d6c2:	jne    107d56f <check_input_run+0x101df>
 107d6c8:	test   %rsi,%rsi
 107d6cb:	je     107d729 <check_input_run+0x10399>
 107d6cd:	mov    0x110(%rsp),%r10
 107d6d5:	mov    0x1f8(%rsp),%rcx
 107d6dd:	lea    0x0(,%r8,8),%r9
 107d6e5:	lea    (%r9,%r9,2),%r9
 107d6e9:	lea    (%r10,%r8,4),%r8
 107d6ed:	xor    %r10d,%r10d
 107d6f0:	mov    0xb8(%rsp),%r14
 107d6f8:	mov    (%r8,%r10,4),%r11d
 107d6fc:	inc    %r10
 107d6ff:	mov    0x318(%r14),%r14
 107d706:	lea    (%r11,%r11,2),%r11
 107d70a:	mov    0x10(%r14,%r9,1),%r15
 107d70f:	mov    %r15,0x10(%rcx,%r11,8)
 107d714:	vmovdqu (%r14,%r9,1),%xmm0
 107d71a:	add    $0x18,%r9
 107d71e:	vmovdqu %xmm0,(%rcx,%r11,8)
 107d724:	cmp    %r10,%rsi
 107d727:	jne    107d6f0 <check_input_run+0x10360>
 107d729:	cmpq   $0x0,0x140(%rsp)
 107d732:	je     107df5d <check_input_run+0x10bcd>
 107d738:	cmpl   $0x0,0xd8(%rsp)
 107d740:	je     107df5d <check_input_run+0x10bcd>
 107d746:	xor    %r8d,%r8d
 107d749:	cmpl   $0x1,0xd8(%rsp)
 107d751:	jne    107d865 <check_input_run+0x104d5>
 107d757:	xor    %esi,%esi
 107d759:	jmp    107d9ec <check_input_run+0x1065c>
 107d75e:	mov    0x18(%rsp),%rdi
 107d763:	mov    0x10(%rsp),%rsi
 107d768:	mov    0x20(%rsp),%r12
 107d76d:	mov    0x40(%rsp),%rax
 107d772:	mov    0x30(%rsp),%r9
 107d777:	jmp    106dc9f <check_input_run+0x90f>
 107d77c:	mov    0x18(%rsp),%rdi
 107d781:	mov    0x10(%rsp),%rsi
 107d786:	mov    0x20(%rsp),%r12
 107d78b:	mov    0x40(%rsp),%rax
 107d790:	mov    0x30(%rsp),%r9
 107d795:	jmp    106dcb9 <check_input_run+0x929>
 107d79a:	mov    0x18(%rsp),%rdi
 107d79f:	mov    0x10(%rsp),%rsi
 107d7a4:	mov    0x20(%rsp),%r12
 107d7a9:	mov    0x40(%rsp),%rax
 107d7ae:	mov    0x30(%rsp),%r9
 107d7b3:	jmp    106dcd3 <check_input_run+0x943>
 107d7b8:	mov    0x18(%rsp),%rdi
 107d7bd:	mov    0x10(%rsp),%rsi
 107d7c2:	mov    0x20(%rsp),%r12
 107d7c7:	mov    0x40(%rsp),%rax
 107d7cc:	mov    0x30(%rsp),%r9
 107d7d1:	jmp    106dced <check_input_run+0x95d>
 107d7d6:	mov    0x10(%rsp),%rdi
 107d7db:	add    %rdx,%rsi
 107d7de:	mov    %rsi,0x8(%rdi)
 107d7e2:	mov    0x18(%rsp),%rdi
 107d7e7:	mov    %rcx,0x2c8(%rdi)
 107d7ee:	test   %rcx,%rcx
 107d7f1:	je     107d83c <check_input_run+0x104ac>
 107d7f3:	mov    0x10(%rsp),%rcx
 107d7f8:	mov    (%rcx),%rdi
 107d7fb:	mov    0x8(%rcx),%rsi
 107d7ff:	lea    0x7(%rsi,%rdi,1),%rcx
 107d804:	add    %rdi,%rsi
 107d807:	and    $0xfffffffffffffff8,%rcx
 107d80b:	cmp    %rsi,%rcx
 107d80e:	jb     107d83c <check_input_run+0x104ac>
 107d810:	mov    %rcx,%rsi
 107d813:	sub    %rdi,%rsi
 107d816:	mov    0x10(%rsp),%rdi
 107d81b:	mov    0x10(%rdi),%rdi
 107d81f:	sub    %rsi,%rdi
 107d822:	setb   %r8b
 107d826:	cmp    0x78(%rsp),%rdi
 107d82b:	setbe  %dil
 107d82f:	or     %r8b,%dil
 107d832:	cmp    $0x1,%dil
 107d836:	jne    107da7d <check_input_run+0x106ed>
 107d83c:	mov    0x18(%rsp),%rdi
 107d841:	mov    0x10(%rsp),%rsi
 107d846:	mov    0x20(%rsp),%r12
 107d84b:	mov    0x40(%rsp),%rax
 107d850:	mov    0x30(%rsp),%r9
 107d855:	movq   $0x0,0x2d0(%rdi)
 107d860:	jmp    106dd1d <check_input_run+0x98d>
 107d865:	mov    0x160(%rsp),%rdx
 107d86d:	mov    0xd8(%rsp),%r9
 107d875:	and    $0xfffffffe,%r9d
 107d879:	xor    %esi,%esi
 107d87b:	mov    0xb8(%rsp),%r15
 107d883:	mov    0x88(%rsp),%rcx
 107d88b:	lea    0x0(,%rsi,4),%r10
 107d893:	lea    (%r10,%r10,8),%r10
 107d897:	mov    0x330(%r15),%r14
 107d89e:	mov    (%rcx,%rsi,4),%r11d
 107d8a2:	mov    0x160(%rsp),%rcx
 107d8aa:	mov    0x20(%r14,%r10,1),%ebp
 107d8af:	lea    (%r11,%r11,8),%r11
 107d8b3:	mov    %ebp,0x20(%rcx,%r11,4)
 107d8b8:	vmovdqu (%r14,%r10,1),%ymm0
 107d8be:	vmovdqu %ymm0,(%rcx,%r11,4)
 107d8c4:	mov    0x330(%r15),%r11
 107d8cb:	mov    0x4(%r11,%r10,1),%r10d
 107d8d0:	mov    $0x0,%r11d
 107d8d6:	test   %r10d,%r10d
 107d8d9:	je     107d913 <check_input_run+0x10583>
 107d8db:	mov    %r10d,%r11d
 107d8de:	shr    $0x3,%r11d
 107d8e2:	cmpq   $0x0,0x50(%rsp)
 107d8e8:	je     107d90b <check_input_run+0x1057b>
 107d8ea:	mov    0x50(%rsp),%r14
 107d8ef:	mov    %r11d,%r15d
 107d8f2:	sub    0x10(%r14),%r15d
 107d8f6:	jae    107d903 <check_input_run+0x10573>
 107d8f8:	mov    0x8(%r14),%r14
 107d8fc:	test   %r14,%r14
 107d8ff:	jne    107d8ef <check_input_run+0x1055f>
 107d901:	jmp    107d90b <check_input_run+0x1057b>
 107d903:	mov    0x18(%r14),%r11
 107d907:	mov    (%r11,%r15,4),%r11d
 107d90b:	and    $0x7,%r10d
 107d90f:	lea    (%r10,%r11,8),%r11d
 107d913:	mov    0x88(%rsp),%rcx
 107d91b:	mov    0xb8(%rsp),%r15
 107d923:	mov    (%rcx,%rsi,4),%r10d
 107d927:	lea    (%r10,%r10,8),%r10
 107d92b:	mov    %r11d,0x4(%rdx,%r10,4)
 107d930:	lea    0x4(,%rsi,4),%r10
 107d938:	mov    0x330(%r15),%r14
 107d93f:	mov    0x4(%rcx,%rsi,4),%r11d
 107d944:	lea    (%r10,%r10,8),%r10
 107d948:	mov    0x20(%r14,%r10,1),%ebp
 107d94d:	lea    (%r11,%r11,8),%r11
 107d951:	mov    %ebp,0x20(%rdx,%r11,4)
 107d956:	vmovdqu (%r14,%r10,1),%ymm0
 107d95c:	vmovdqu %ymm0,(%rdx,%r11,4)
 107d962:	mov    0x330(%r15),%r11
 107d969:	mov    0x4(%r11,%r10,1),%r10d
 107d96e:	test   %r10d,%r10d
 107d971:	je     107d99b <check_input_run+0x1060b>
 107d973:	mov    %r10d,%r11d
 107d976:	shr    $0x3,%r11d
 107d97a:	cmpq   $0x0,0x50(%rsp)
 107d980:	je     107d9a8 <check_input_run+0x10618>
 107d982:	mov    0x50(%rsp),%r14
 107d987:	mov    %r11d,%r15d
 107d98a:	sub    0x10(%r14),%r15d
 107d98e:	jae    107d9a0 <check_input_run+0x10610>
 107d990:	mov    0x8(%r14),%r14
 107d994:	test   %r14,%r14
 107d997:	jne    107d987 <check_input_run+0x105f7>
 107d999:	jmp    107d9a8 <check_input_run+0x10618>
 107d99b:	xor    %r10d,%r10d
 107d99e:	jmp    107d9b0 <check_input_run+0x10620>
 107d9a0:	mov    0x18(%r14),%r11
 107d9a4:	mov    (%r11,%r15,4),%r11d
 107d9a8:	and    $0x7,%r10d
 107d9ac:	lea    (%r10,%r11,8),%r10d
 107d9b0:	mov    0x88(%rsp),%rcx
 107d9b8:	lea    0x1(%rsi),%r11
 107d9bc:	add    $0x2,%rsi
 107d9c0:	mov    (%rcx,%r11,4),%r11d
 107d9c4:	mov    0x160(%rsp),%rcx
 107d9cc:	lea    (%r11,%r11,8),%r11
 107d9d0:	mov    %r10d,0x4(%rcx,%r11,4)
 107d9d5:	cmp    %r9,%rsi
 107d9d8:	jne    107d87b <check_input_run+0x104eb>
 107d9de:	testb  $0x1,0xd8(%rsp)
 107d9e6:	je     107df5d <check_input_run+0x10bcd>
 107d9ec:	mov    0xb8(%rsp),%r14
 107d9f4:	mov    0x88(%rsp),%rcx
 107d9fc:	lea    0x0(,%rsi,4),%r9
 107da04:	lea    (%r9,%r9,8),%r9
 107da08:	mov    0x330(%r14),%r11
 107da0f:	mov    (%rcx,%rsi,4),%r10d
 107da13:	mov    0x160(%rsp),%rcx
 107da1b:	mov    0x20(%r11,%r9,1),%ebp
 107da20:	lea    (%r10,%r10,8),%r10
 107da24:	mov    %ebp,0x20(%rcx,%r10,4)
 107da29:	vmovdqu (%r11,%r9,1),%ymm0
 107da2f:	vmovdqu %ymm0,(%rcx,%r10,4)
 107da35:	mov    0x330(%r14),%r10
 107da3c:	mov    0x4(%r10,%r9,1),%r9d
 107da41:	test   %r9d,%r9d
 107da44:	je     107df41 <check_input_run+0x10bb1>
 107da4a:	mov    %r9d,%r8d
 107da4d:	shr    $0x3,%r8d
 107da51:	cmpq   $0x0,0x50(%rsp)
 107da57:	je     107df39 <check_input_run+0x10ba9>
 107da5d:	mov    0x50(%rsp),%r10
 107da62:	mov    %r8d,%r11d
 107da65:	sub    0x10(%r10),%r11d
 107da69:	jae    107df31 <check_input_run+0x10ba1>
 107da6f:	mov    0x8(%r10),%r10
 107da73:	test   %r10,%r10
 107da76:	jne    107da62 <check_input_run+0x106d2>
 107da78:	jmp    107df39 <check_input_run+0x10ba9>
 107da7d:	mov    0x10(%rsp),%rdi
 107da82:	add    %rdx,%rsi
 107da85:	mov    %rsi,0x8(%rdi)
 107da89:	mov    0x18(%rsp),%rdi
 107da8e:	mov    %rcx,0x2d0(%rdi)
 107da95:	test   %rcx,%rcx
 107da98:	je     107df94 <check_input_run+0x10c04>
 107da9e:	mov    0x10(%rsp),%rcx
 107daa3:	mov    (%rcx),%rdi
 107daa6:	mov    0x8(%rcx),%rsi
 107daaa:	lea    0x7(%rsi,%rdi,1),%rcx
 107daaf:	add    %rdi,%rsi
 107dab2:	and    $0xfffffffffffffff8,%rcx
 107dab6:	cmp    %rsi,%rcx
 107dab9:	jb     107df94 <check_input_run+0x10c04>
 107dabf:	mov    %rcx,%rsi
 107dac2:	sub    %rdi,%rsi
 107dac5:	mov    0x10(%rsp),%rdi
 107daca:	mov    0x10(%rdi),%rdi
 107dace:	sub    %rsi,%rdi
 107dad1:	jb     107df94 <check_input_run+0x10c04>
 107dad7:	cmp    %rdi,%rax
 107dada:	ja     107df94 <check_input_run+0x10c04>
 107dae0:	mov    0x10(%rsp),%rdi
 107dae5:	mov    0x18(%rsp),%r8
 107daea:	add    %rax,%rsi
 107daed:	mov    %rsi,0x8(%rdi)
 107daf1:	lea    0x2d8(%r8),%rdi
 107daf8:	mov    %rcx,0x2d8(%r8)
 107daff:	mov    %rdi,0x80(%rsp)
 107db07:	test   %rcx,%rcx
 107db0a:	je     107dfb2 <check_input_run+0x10c22>
 107db10:	mov    0x10(%rsp),%rcx
 107db15:	mov    (%rcx),%rdi
 107db18:	mov    0x8(%rcx),%rsi
 107db1c:	lea    0x7(%rsi,%rdi,1),%rcx
 107db21:	add    %rdi,%rsi
 107db24:	and    $0xfffffffffffffff8,%rcx
 107db28:	cmp    %rsi,%rcx
 107db2b:	jb     107dfb2 <check_input_run+0x10c22>
 107db31:	mov    %rcx,%rsi
 107db34:	sub    %rdi,%rsi
 107db37:	mov    0x10(%rsp),%rdi
 107db3c:	mov    0x10(%rdi),%rdi
 107db40:	sub    %rsi,%rdi
 107db43:	jb     107dfb2 <check_input_run+0x10c22>
 107db49:	cmp    %rdi,%rax
 107db4c:	ja     107dfb2 <check_input_run+0x10c22>
 107db52:	mov    0x10(%rsp),%rdi
 107db57:	mov    0x18(%rsp),%r8
 107db5c:	add    %rax,%rsi
 107db5f:	mov    %rsi,0x8(%rdi)
 107db63:	lea    0x2e0(%r8),%rdi
 107db6a:	mov    %rcx,0x2e0(%r8)
 107db71:	mov    %rdi,0xa8(%rsp)
 107db79:	test   %rcx,%rcx
 107db7c:	je     107dfd8 <check_input_run+0x10c48>
 107db82:	mov    0x10(%rsp),%rcx
 107db87:	mov    (%rcx),%rdi
 107db8a:	mov    0x8(%rcx),%rsi
 107db8e:	lea    0x7(%rsi,%rdi,1),%rcx
 107db93:	add    %rdi,%rsi
 107db96:	and    $0xfffffffffffffff8,%rcx
 107db9a:	cmp    %rsi,%rcx
 107db9d:	jb     107dfd8 <check_input_run+0x10c48>
 107dba3:	mov    %rcx,%rsi
 107dba6:	sub    %rdi,%rsi
 107dba9:	mov    0x10(%rsp),%rdi
 107dbae:	mov    0x10(%rdi),%rdi
 107dbb2:	sub    %rsi,%rdi
 107dbb5:	jb     107dfd8 <check_input_run+0x10c48>
 107dbbb:	cmp    %rdi,%rax
 107dbbe:	ja     107dfd8 <check_input_run+0x10c48>
 107dbc4:	mov    0x10(%rsp),%rdi
 107dbc9:	add    %rax,%rsi
 107dbcc:	mov    %rsi,0x8(%rdi)
 107dbd0:	mov    0x18(%rsp),%rdi
 107dbd5:	mov    %rcx,0x2e8(%rdi)
 107dbdc:	test   %rcx,%rcx
 107dbdf:	je     107e006 <check_input_run+0x10c76>
 107dbe5:	mov    0x10(%rsp),%rcx
 107dbea:	mov    (%rcx),%rdi
 107dbed:	mov    0x8(%rcx),%rsi
 107dbf1:	lea    0x7(%rsi,%rdi,1),%rcx
 107dbf6:	add    %rdi,%rsi
 107dbf9:	and    $0xfffffffffffffff8,%rcx
 107dbfd:	cmp    %rsi,%rcx
 107dc00:	jb     107e006 <check_input_run+0x10c76>
 107dc06:	mov    %rcx,%rsi
 107dc09:	sub    %rdi,%rsi
 107dc0c:	mov    0x10(%rsp),%rdi
 107dc11:	mov    0x10(%rdi),%rdi
 107dc15:	sub    %rsi,%rdi
 107dc18:	jb     107e006 <check_input_run+0x10c76>
 107dc1e:	cmp    %rdi,%rax
 107dc21:	ja     107e006 <check_input_run+0x10c76>
 107dc27:	mov    0x10(%rsp),%rdi
 107dc2c:	mov    0x18(%rsp),%r8
 107dc31:	add    %rax,%rsi
 107dc34:	mov    %rsi,0x8(%rdi)
 107dc38:	lea    0x2f0(%r8),%rdi
 107dc3f:	mov    %rcx,0x2f0(%r8)
 107dc46:	mov    %rdi,0xf8(%rsp)
 107dc4e:	test   %rcx,%rcx
 107dc51:	je     107e034 <check_input_run+0x10ca4>
 107dc57:	mov    0x10(%rsp),%rcx
 107dc5c:	mov    (%rcx),%rdi
 107dc5f:	mov    0x8(%rcx),%rsi
 107dc63:	lea    0x7(%rsi,%rdi,1),%rcx
 107dc68:	add    %rdi,%rsi
 107dc6b:	and    $0xfffffffffffffff8,%rcx
 107dc6f:	cmp    %rsi,%rcx
 107dc72:	jb     107e034 <check_input_run+0x10ca4>
 107dc78:	mov    %rcx,%rsi
 107dc7b:	sub    %rdi,%rsi
 107dc7e:	mov    0x10(%rsp),%rdi
 107dc83:	mov    0x10(%rdi),%rdi
 107dc87:	sub    %rsi,%rdi
 107dc8a:	jb     107e034 <check_input_run+0x10ca4>
 107dc90:	cmp    %rdi,%rax
 107dc93:	ja     107e034 <check_input_run+0x10ca4>
 107dc99:	mov    0x10(%rsp),%rdi
 107dc9e:	mov    0x18(%rsp),%r8
 107dca3:	add    %rax,%rsi
 107dca6:	mov    %rsi,0x8(%rdi)
 107dcaa:	lea    0x2f8(%r8),%rdi
 107dcb1:	mov    %rcx,0x2f8(%r8)
 107dcb8:	mov    %rdi,0xb0(%rsp)
 107dcc0:	test   %rcx,%rcx
 107dcc3:	je     107e06a <check_input_run+0x10cda>
 107dcc9:	mov    0x10(%rsp),%rcx
 107dcce:	mov    (%rcx),%rdi
 107dcd1:	mov    0x8(%rcx),%rsi
 107dcd5:	lea    0x7(%rsi,%rdi,1),%rcx
 107dcda:	add    %rdi,%rsi
 107dcdd:	and    $0xfffffffffffffff8,%rcx
 107dce1:	cmp    %rsi,%rcx
 107dce4:	jb     107e06a <check_input_run+0x10cda>
 107dcea:	mov    %rcx,%rsi
 107dced:	sub    %rdi,%rsi
 107dcf0:	mov    0x10(%rsp),%rdi
 107dcf5:	mov    0x10(%rdi),%rdi
 107dcf9:	sub    %rsi,%rdi
 107dcfc:	jb     107e06a <check_input_run+0x10cda>
 107dd02:	cmp    %rdi,%rax
 107dd05:	ja     107e06a <check_input_run+0x10cda>
 107dd0b:	mov    0x10(%rsp),%rdi
 107dd10:	mov    0x18(%rsp),%r8
 107dd15:	add    %rax,%rsi
 107dd18:	mov    %rsi,0x8(%rdi)
 107dd1c:	lea    0x300(%r8),%rdi
 107dd23:	mov    %rcx,0x300(%r8)
 107dd2a:	mov    %rdi,0xe0(%rsp)
 107dd32:	test   %rcx,%rcx
 107dd35:	je     107e0a8 <check_input_run+0x10d18>
 107dd3b:	mov    0x10(%rsp),%rcx
 107dd40:	mov    (%rcx),%rdi
 107dd43:	mov    0x8(%rcx),%rsi
 107dd47:	lea    0x7(%rsi,%rdi,1),%rcx
 107dd4c:	add    %rdi,%rsi
 107dd4f:	and    $0xfffffffffffffff8,%rcx
 107dd53:	cmp    %rsi,%rcx
 107dd56:	jb     107e0a8 <check_input_run+0x10d18>
 107dd5c:	mov    %rcx,%rsi
 107dd5f:	sub    %rdi,%rsi
 107dd62:	mov    0x10(%rsp),%rdi
 107dd67:	mov    0x10(%rdi),%rdi
 107dd6b:	sub    %rsi,%rdi
 107dd6e:	jb     107e0a8 <check_input_run+0x10d18>
 107dd74:	cmp    %rdi,%rax
 107dd77:	ja     107e0a8 <check_input_run+0x10d18>
 107dd7d:	mov    0x10(%rsp),%rdi
 107dd82:	mov    0x18(%rsp),%r8
 107dd87:	add    %rax,%rsi
 107dd8a:	mov    %rsi,0x8(%rdi)
 107dd8e:	lea    0x310(%r8),%rdi
 107dd95:	mov    %rcx,0x310(%r8)
 107dd9c:	mov    %rdi,0x108(%rsp)
 107dda4:	test   %rcx,%rcx
 107dda7:	je     107e0ee <check_input_run+0x10d5e>
 107ddad:	mov    0x10(%rsp),%rcx
 107ddb2:	mov    (%rcx),%rdi
 107ddb5:	mov    0x8(%rcx),%rsi
 107ddb9:	lea    0x7(%rsi,%rdi,1),%rcx
 107ddbe:	add    %rdi,%rsi
 107ddc1:	and    $0xfffffffffffffff8,%rcx
 107ddc5:	cmp    %rsi,%rcx
 107ddc8:	jb     107e0ee <check_input_run+0x10d5e>
 107ddce:	mov    %rcx,%rsi
 107ddd1:	sub    %rdi,%rsi
 107ddd4:	mov    0x10(%rsp),%rdi
 107ddd9:	mov    0x10(%rdi),%rdi
 107dddd:	sub    %rsi,%rdi
 107dde0:	jb     107e0ee <check_input_run+0x10d5e>
 107dde6:	mov    0x78(%rsp),%r8
 107ddeb:	lea    (%r8,%r8,2),%r8
 107ddef:	lea    0x18(,%r8,8),%r8
 107ddf7:	cmp    %rdi,%r8
 107ddfa:	ja     107e0ee <check_input_run+0x10d5e>
 107de00:	mov    0x10(%rsp),%rdi
 107de05:	add    %r8,%rsi
 107de08:	mov    %rsi,0x8(%rdi)
 107de0c:	mov    0x18(%rsp),%rdi
 107de11:	mov    %rcx,0x318(%rdi)
 107de18:	test   %rcx,%rcx
 107de1b:	je     107e13c <check_input_run+0x10dac>
 107de21:	mov    0x10(%rsp),%rcx
 107de26:	mov    (%rcx),%rdi
 107de29:	mov    0x8(%rcx),%rsi
 107de2d:	lea    0x7(%rsi,%rdi,1),%rcx
 107de32:	add    %rdi,%rsi
 107de35:	and    $0xfffffffffffffff8,%rcx
 107de39:	cmp    %rsi,%rcx
 107de3c:	jb     107e13c <check_input_run+0x10dac>
 107de42:	mov    %rcx,%rsi
 107de45:	sub    %rdi,%rsi
 107de48:	mov    0x10(%rsp),%rdi
 107de4d:	mov    0x10(%rdi),%rdi
 107de51:	sub    %rsi,%rdi
 107de54:	jb     107e13c <check_input_run+0x10dac>
 107de5a:	cmp    %rdi,%rax
 107de5d:	ja     107e13c <check_input_run+0x10dac>
 107de63:	mov    0x10(%rsp),%rdi
 107de68:	mov    0x18(%rsp),%r8
 107de6d:	add    %rax,%rsi
 107de70:	mov    %rsi,0x8(%rdi)
 107de74:	lea    0x320(%r8),%rdi
 107de7b:	mov    %rcx,0x320(%r8)
 107de82:	mov    %rdi,0x128(%rsp)
 107de8a:	test   %rcx,%rcx
 107de8d:	je     107e18a <check_input_run+0x10dfa>
 107de93:	mov    0x10(%rsp),%rcx
 107de98:	mov    (%rcx),%rdi
 107de9b:	mov    0x8(%rcx),%rsi
 107de9f:	lea    0x7(%rsi,%rdi,1),%rcx
 107dea4:	add    %rdi,%rsi
 107dea7:	and    $0xfffffffffffffff8,%rcx
 107deab:	cmp    %rsi,%rcx
 107deae:	jb     107e18a <check_input_run+0x10dfa>
 107deb4:	mov    %rcx,%rsi
 107deb7:	sub    %rdi,%rsi
 107deba:	mov    0x10(%rsp),%rdi
 107debf:	mov    0x10(%rdi),%rdi
 107dec3:	sub    %rsi,%rdi
 107dec6:	jb     107e18a <check_input_run+0x10dfa>
 107decc:	cmp    %rdi,%rax
 107decf:	ja     107e18a <check_input_run+0x10dfa>
 107ded5:	mov    0x10(%rsp),%r8
 107deda:	mov    0x18(%rsp),%rdi
 107dedf:	add    %rax,%rsi
 107dee2:	mov    $0x358,%eax
 107dee7:	mov    %rsi,0x8(%r8)
 107deeb:	lea    0x350(%rdi),%rsi
 107def2:	mov    %rcx,0x350(%rdi)
 107def9:	mov    %rsi,0x120(%rsp)
 107df01:	test   %rcx,%rcx
 107df04:	je     107df27 <check_input_run+0x10b97>
 107df06:	mov    0x10(%rsp),%rcx
 107df0b:	mov    (%rcx),%rdi
 107df0e:	mov    0x8(%rcx),%rsi
 107df12:	lea    0x7(%rsi,%rdi,1),%rcx
 107df17:	add    %rdi,%rsi
 107df1a:	and    $0xfffffffffffffff8,%rcx
 107df1e:	cmp    %rsi,%rcx
 107df21:	jae    107e1a3 <check_input_run+0x10e13>
 107df27:	xor    %ebx,%ebx
 107df29:	xor    %r15d,%r15d
 107df2c:	jmp    107e268 <check_input_run+0x10ed8>
 107df31:	mov    0x18(%r10),%r8
 107df35:	mov    (%r8,%r11,4),%r8d
 107df39:	and    $0x7,%r9d
 107df3d:	lea    (%r9,%r8,8),%r8d
 107df41:	mov    0x88(%rsp),%rcx
 107df49:	mov    (%rcx,%rsi,4),%esi
 107df4c:	mov    0x160(%rsp),%rcx
 107df54:	lea    (%rsi,%rsi,8),%rsi
 107df58:	mov    %r8d,0x4(%rcx,%rsi,4)
 107df5d:	cmpq   $0x0,0x140(%rsp)
 107df66:	je     107e511 <check_input_run+0x11181>
 107df6c:	cmpl   $0x0,0x70(%rsp)
 107df71:	je     107e511 <check_input_run+0x11181>
 107df77:	mov    0x70(%rsp),%r8
 107df7c:	mov    %r8d,%esi
 107df7f:	and    $0x7,%esi
 107df82:	cmp    $0x8,%r8d
 107df86:	jae    107e281 <check_input_run+0x10ef1>
 107df8c:	xor    %r8d,%r8d
 107df8f:	jmp    107e4a7 <check_input_run+0x11117>
 107df94:	mov    0x18(%rsp),%rdi
 107df99:	mov    0x10(%rsp),%rsi
 107df9e:	mov    0x20(%rsp),%r12
 107dfa3:	mov    0x40(%rsp),%rax
 107dfa8:	mov    0x30(%rsp),%r9
 107dfad:	jmp    106dd1d <check_input_run+0x98d>
 107dfb2:	mov    0x18(%rsp),%rdi
 107dfb7:	mov    0x10(%rsp),%rsi
 107dfbc:	mov    0x20(%rsp),%r12
 107dfc1:	mov    0x40(%rsp),%rax
 107dfc6:	mov    0x30(%rsp),%r9
 107dfcb:	mov    0x80(%rsp),%rcx
 107dfd3:	jmp    106dd2f <check_input_run+0x99f>
 107dfd8:	mov    0x18(%rsp),%rdi
 107dfdd:	mov    0x10(%rsp),%rsi
 107dfe2:	mov    0x20(%rsp),%r12
 107dfe7:	mov    0x40(%rsp),%rax
 107dfec:	mov    0x30(%rsp),%r9
 107dff1:	mov    0x80(%rsp),%rcx
 107dff9:	mov    0xa8(%rsp),%rdx
 107e001:	jmp    106dd41 <check_input_run+0x9b1>
 107e006:	mov    0x18(%rsp),%rdi
 107e00b:	mov    0x10(%rsp),%rsi
 107e010:	mov    0x20(%rsp),%r12
 107e015:	mov    0x40(%rsp),%rax
 107e01a:	mov    0x30(%rsp),%r9
 107e01f:	mov    0x80(%rsp),%rcx
 107e027:	mov    0xa8(%rsp),%rdx
 107e02f:	jmp    106dd4c <check_input_run+0x9bc>
 107e034:	mov    0x18(%rsp),%rdi
 107e039:	mov    0x10(%rsp),%rsi
 107e03e:	mov    0x20(%rsp),%r12
 107e043:	mov    0x40(%rsp),%rax
 107e048:	mov    0x30(%rsp),%r9
 107e04d:	mov    0x80(%rsp),%rcx
 107e055:	mov    0xa8(%rsp),%rdx
 107e05d:	mov    0xf8(%rsp),%r8
 107e065:	jmp    106dd5e <check_input_run+0x9ce>
 107e06a:	mov    0x18(%rsp),%rdi
 107e06f:	mov    0x10(%rsp),%rsi
 107e074:	mov    0x20(%rsp),%r12
 107e079:	mov    0x40(%rsp),%rax
 107e07e:	mov    0x30(%rsp),%r9
 107e083:	mov    0x80(%rsp),%rcx
 107e08b:	mov    0xa8(%rsp),%rdx
 107e093:	mov    0xf8(%rsp),%r8
 107e09b:	mov    0xb0(%rsp),%r10
 107e0a3:	jmp    106dd70 <check_input_run+0x9e0>
 107e0a8:	mov    0x18(%rsp),%rdi
 107e0ad:	mov    0x10(%rsp),%rsi
 107e0b2:	mov    0x20(%rsp),%r12
 107e0b7:	mov    0x40(%rsp),%rax
 107e0bc:	mov    0x30(%rsp),%r9
 107e0c1:	mov    0x80(%rsp),%rcx
 107e0c9:	mov    0xa8(%rsp),%rdx
 107e0d1:	mov    0xf8(%rsp),%r8
 107e0d9:	mov    0xb0(%rsp),%r10
 107e0e1:	mov    0xe0(%rsp),%r11
 107e0e9:	jmp    106dd82 <check_input_run+0x9f2>
 107e0ee:	mov    0x18(%rsp),%rdi
 107e0f3:	mov    0x10(%rsp),%rsi
 107e0f8:	mov    0x20(%rsp),%r12
 107e0fd:	mov    0x40(%rsp),%rax
 107e102:	mov    0x30(%rsp),%r9
 107e107:	mov    0x80(%rsp),%rcx
 107e10f:	mov    0xa8(%rsp),%rdx
 107e117:	mov    0xf8(%rsp),%r8
 107e11f:	mov    0xb0(%rsp),%r10
 107e127:	mov    0xe0(%rsp),%r11
 107e12f:	mov    0x108(%rsp),%rbx
 107e137:	jmp    106dd94 <check_input_run+0xa04>
 107e13c:	mov    0x18(%rsp),%rdi
 107e141:	mov    0x10(%rsp),%rsi
 107e146:	mov    0x20(%rsp),%r12
 107e14b:	mov    0x40(%rsp),%rax
 107e150:	mov    0x30(%rsp),%r9
 107e155:	mov    0x80(%rsp),%rcx
 107e15d:	mov    0xa8(%rsp),%rdx
 107e165:	mov    0xf8(%rsp),%r8
 107e16d:	mov    0xb0(%rsp),%r10
 107e175:	mov    0xe0(%rsp),%r11
 107e17d:	mov    0x108(%rsp),%rbx
 107e185:	jmp    106dd9f <check_input_run+0xa0f>
 107e18a:	mov    0x18(%rsp),%rdi
 107e18f:	mov    0x10(%rsp),%rsi
 107e194:	mov    0x20(%rsp),%r12
 107e199:	mov    0x30(%rsp),%r9
 107e19e:	jmp    106ddee <check_input_run+0xa5e>
 107e1a3:	mov    %rcx,%rsi
 107e1a6:	sub    %rdi,%rsi
 107e1a9:	mov    0x10(%rsp),%rdi
 107e1ae:	xor    %ebx,%ebx
 107e1b0:	mov    $0x0,%r15d
 107e1b6:	mov    0x10(%rdi),%rdi
 107e1ba:	sub    %rsi,%rdi
 107e1bd:	jb     107e268 <check_input_run+0x10ed8>
 107e1c3:	mov    0x78(%rsp),%r8
 107e1c8:	lea    (%r8,%r8,4),%r8
 107e1cc:	lea    0x28(,%r8,8),%r8
 107e1d4:	cmp    %rdi,%r8
 107e1d7:	ja     107e268 <check_input_run+0x10ed8>
 107e1dd:	mov    0x10(%rsp),%rax
 107e1e2:	add    %r8,%rsi
 107e1e5:	test   %rcx,%rcx
 107e1e8:	setne  %r15b
 107e1ec:	cmpq   $0x0,0x850(%rsp)
 107e1f5:	mov    %rsi,0x8(%rax)
 107e1f9:	mov    0x18(%rsp),%rsi
 107e1fe:	mov    %rcx,0x358(%rsi)
 107e205:	je     107e710 <check_input_run+0x11380>
 107e20b:	test   %rcx,%rcx
 107e20e:	je     107e710 <check_input_run+0x11380>
 107e214:	mov    0x10(%rsp),%rax
 107e219:	mov    0x8(%rax),%rbx
 107e21d:	mov    0x10(%rax),%rax
 107e221:	sub    %rbx,%rax
 107e224:	setb   %cl
 107e227:	cmp    0x78(%rsp),%rax
 107e22c:	setbe  %al
 107e22f:	or     %cl,%al
 107e231:	jne    107e70d <check_input_run+0x1137d>
 107e237:	mov    0x10(%rsp),%rcx
 107e23c:	lea    (%rbx,%rdx,1),%rax
 107e240:	add    (%rcx),%rbx
 107e243:	mov    %rax,0x8(%rcx)
 107e247:	je     107e70d <check_input_run+0x1137d>
 107e24d:	mov    0x850(%rsp),%rsi
 107e255:	mov    %rbx,%rdi
 107e258:	vzeroupper
 107e25b:	call   788550 <memcpy@plt>
 107e260:	mov    $0x1,%r15b
 107e263:	mov    $0x1f0,%eax
 107e268:	mov    0x18(%rsp),%rdi
 107e26d:	mov    0x10(%rsp),%rsi
 107e272:	mov    0x20(%rsp),%r12
 107e277:	mov    0x30(%rsp),%r9
 107e27c:	jmp    106de12 <check_input_run+0xa82>
 107e281:	mov    0x150(%rsp),%rcx
 107e289:	mov    0xb8(%rsp),%r12
 107e291:	mov    0x70(%rsp),%r8
 107e296:	shr    $0x3,%r8d
 107e29a:	xor    %r11d,%r11d
 107e29d:	shl    $0x7,%r8
 107e2a1:	lea    (%r8,%r8,4),%r10
 107e2a5:	xor    %r8d,%r8d
 107e2a8:	lea    0x1c(%rcx),%r9
 107e2ac:	mov    0x1f0(%rsp),%rcx
 107e2b4:	mov    0x340(%r12),%r15
 107e2bc:	mov    -0x1c(%r9,%r8,4),%r14d
 107e2c1:	vmovups (%r15,%r11,1),%zmm0
 107e2c8:	vmovups 0x10(%r15,%r11,1),%zmm1
 107e2d3:	lea    (%r14,%r14,4),%r14
 107e2d7:	shl    $0x4,%r14
 107e2db:	vmovups %zmm1,0x10(%rcx,%r14,1)
 107e2e6:	vmovups %zmm0,(%rcx,%r14,1)
 107e2ed:	mov    0x340(%r12),%r15
 107e2f5:	mov    -0x18(%r9,%r8,4),%r14d
 107e2fa:	vmovups 0x50(%r15,%r11,1),%zmm0
 107e305:	vmovups 0x60(%r15,%r11,1),%zmm1
 107e310:	lea    (%r14,%r14,4),%r14
 107e314:	shl    $0x4,%r14
 107e318:	vmovups %zmm1,0x10(%rcx,%r14,1)
 107e323:	vmovups %zmm0,(%rcx,%r14,1)
 107e32a:	mov    0x340(%r12),%r15
 107e332:	mov    -0x14(%r9,%r8,4),%r14d
 107e337:	vmovups 0xa0(%r15,%r11,1),%zmm0
 107e342:	vmovups 0xb0(%r15,%r11,1),%zmm1
 107e34d:	lea    (%r14,%r14,4),%r14
 107e351:	shl    $0x4,%r14
 107e355:	vmovups %zmm1,0x10(%rcx,%r14,1)
 107e360:	vmovups %zmm0,(%rcx,%r14,1)
 107e367:	mov    0x340(%r12),%r15
 107e36f:	mov    -0x10(%r9,%r8,4),%r14d
 107e374:	vmovups 0xf0(%r15,%r11,1),%zmm0
 107e37f:	vmovups 0x100(%r15,%r11,1),%zmm1
 107e387:	lea    (%r14,%r14,4),%r14
 107e38b:	shl    $0x4,%r14
 107e38f:	vmovups %zmm1,0x10(%rcx,%r14,1)
 107e39a:	vmovups %zmm0,(%rcx,%r14,1)
 107e3a1:	mov    0x340(%r12),%r15
 107e3a9:	mov    -0xc(%r9,%r8,4),%r14d
 107e3ae:	vmovups 0x140(%r15,%r11,1),%zmm0
 107e3b6:	vmovups 0x150(%r15,%r11,1),%zmm1
 107e3c1:	lea    (%r14,%r14,4),%r14
 107e3c5:	shl    $0x4,%r14
 107e3c9:	vmovups %zmm1,0x10(%rcx,%r14,1)
 107e3d4:	vmovups %zmm0,(%rcx,%r14,1)
 107e3db:	mov    0x340(%r12),%r15
 107e3e3:	mov    -0x8(%r9,%r8,4),%r14d
 107e3e8:	vmovups 0x190(%r15,%r11,1),%zmm0
 107e3f3:	vmovups 0x1a0(%r15,%r11,1),%zmm1
 107e3fe:	lea    (%r14,%r14,4),%r14
 107e402:	shl    $0x4,%r14
 107e406:	vmovups %zmm1,0x10(%rcx,%r14,1)
 107e411:	vmovups %zmm0,(%rcx,%r14,1)
 107e418:	mov    0x340(%r12),%r15
 107e420:	mov    -0x4(%r9,%r8,4),%r14d
 107e425:	vmovups 0x1e0(%r15,%r11,1),%zmm0
 107e430:	vmovups 0x1f0(%r15,%r11,1),%zmm1
 107e43b:	lea    (%r14,%r14,4),%r14
 107e43f:	shl    $0x4,%r14
 107e443:	vmovups %zmm1,0x10(%rcx,%r14,1)
 107e44e:	vmovups %zmm0,(%rcx,%r14,1)
 107e455:	mov    0x340(%r12),%r15
 107e45d:	mov    (%r9,%r8,4),%r14d
 107e461:	add    $0x8,%r8
 107e465:	vmovdqu64 0x230(%r15,%r11,1),%zmm0
 107e470:	vmovdqu64 0x240(%r15,%r11,1),%zmm1
 107e478:	lea    (%r14,%r14,4),%r14
 107e47c:	add    $0x280,%r11
 107e483:	shl    $0x4,%r14
 107e487:	vmovdqu64 %zmm1,0x10(%rcx,%r14,1)
 107e492:	vmovdqu64 %zmm0,(%rcx,%r14,1)
 107e499:	cmp    %r11,%r10
 107e49c:	jne    107e2b4 <check_input_run+0x10f24>
 107e4a2:	test   %rsi,%rsi
 107e4a5:	je     107e511 <check_input_run+0x11181>
 107e4a7:	mov    0x150(%rsp),%rcx
 107e4af:	xor    %r10d,%r10d
 107e4b2:	lea    (%rcx,%r8,4),%r9
 107e4b6:	mov    0x1f0(%rsp),%rcx
 107e4be:	shl    $0x4,%r8
 107e4c2:	lea    (%r8,%r8,4),%r8
 107e4c6:	mov    0xb8(%rsp),%r14
 107e4ce:	mov    (%r9,%r10,4),%r11d
 107e4d2:	inc    %r10
 107e4d5:	mov    0x340(%r14),%r14
 107e4dc:	lea    (%r11,%r11,4),%r11
 107e4e0:	shl    $0x4,%r11
 107e4e4:	vmovdqu64 (%r14,%r8,1),%zmm0
 107e4eb:	vmovdqu64 0x10(%r14,%r8,1),%zmm1
 107e4f6:	add    $0x50,%r8
 107e4fa:	vmovdqu64 %zmm1,0x10(%rcx,%r11,1)
 107e505:	vmovdqu64 %zmm0,(%rcx,%r11,1)
 107e50c:	cmp    %r10,%rsi
 107e50f:	jne    107e4c6 <check_input_run+0x11136>
 107e511:	cmpq   $0x0,0x140(%rsp)
 107e51a:	je     107e6dc <check_input_run+0x1134c>
 107e520:	cmpl   $0x0,0xc0(%rsp)
 107e528:	je     107e6dc <check_input_run+0x1134c>
 107e52e:	xor    %esi,%esi
 107e530:	mov    0x4c8(%rsp),%r11
 107e538:	imul   $0x2c,%rsi,%r14
 107e53c:	mov    0x20(%r11,%r14,1),%r9
 107e541:	mov    (%r11,%r14,1),%r12d
 107e545:	mov    0x4(%r11,%r14,1),%r15d
 107e54a:	mov    0x8(%r11,%r14,1),%edx
 107e54f:	mov    0xc(%r11,%r14,1),%r10d
 107e554:	mov    %r9,0x790(%rsp)
 107e55c:	mov    $0x0,%r9d
 107e562:	vmovdqu 0x10(%r11,%r14,1),%xmm0
 107e569:	vmovdqa %xmm0,0x780(%rsp)
 107e572:	test   %r12d,%r12d
 107e575:	je     107e5af <check_input_run+0x1121f>
 107e577:	mov    %r12d,%r9d
 107e57a:	shr    $0x3,%r9d
 107e57e:	cmpq   $0x0,0x50(%rsp)
 107e584:	je     107e5a7 <check_input_run+0x11217>
 107e586:	mov    0x50(%rsp),%r8
 107e58b:	mov    %r9d,%ebp
 107e58e:	sub    0x10(%r8),%ebp
 107e592:	jae    107e59f <check_input_run+0x1120f>
 107e594:	mov    0x8(%r8),%r8
 107e598:	test   %r8,%r8
 107e59b:	jne    107e58b <check_input_run+0x111fb>
 107e59d:	jmp    107e5a7 <check_input_run+0x11217>
 107e59f:	mov    0x18(%r8),%r9
 107e5a3:	mov    (%r9,%rbp,4),%r9d
 107e5a7:	and    $0x7,%r12d
 107e5ab:	lea    (%r12,%r9,8),%r9d
 107e5af:	mov    0x28(%r11,%r14,1),%r11d
 107e5b4:	mov    $0x0,%r14d
 107e5ba:	xor    %ebp,%ebp
 107e5bc:	test   %r15d,%r15d
 107e5bf:	je     107e5fc <check_input_run+0x1126c>
 107e5c1:	mov    %r15d,%r14d
 107e5c4:	shr    $0x3,%r14d
 107e5c8:	cmpq   $0x0,0x50(%rsp)
 107e5ce:	je     107e5f4 <check_input_run+0x11264>
 107e5d0:	mov    0x50(%rsp),%r12
 107e5d5:	mov    %r14d,%r8d
 107e5d8:	sub    0x10(%r12),%r8d
 107e5dd:	jae    107e5eb <check_input_run+0x1125b>
 107e5df:	mov    0x8(%r12),%r12
 107e5e4:	test   %r12,%r12
 107e5e7:	jne    107e5d5 <check_input_run+0x11245>
 107e5e9:	jmp    107e5f4 <check_input_run+0x11264>
 107e5eb:	mov    0x18(%r12),%r14
 107e5f0:	mov    (%r14,%r8,4),%r14d
 107e5f4:	and    $0x7,%r15d
 107e5f8:	lea    (%r15,%r14,8),%r14d
 107e5fc:	test   %r10d,%r10d
 107e5ff:	je     107e63c <check_input_run+0x112ac>
 107e601:	mov    %r10d,%r15d
 107e604:	shr    $0x3,%r15d
 107e608:	cmpq   $0x0,0x50(%rsp)
 107e60e:	je     107e634 <check_input_run+0x112a4>
 107e610:	mov    0x50(%rsp),%r12
 107e615:	mov    %r15d,%r8d
 107e618:	sub    0x10(%r12),%r8d
 107e61d:	jae    107e62b <check_input_run+0x1129b>
 107e61f:	mov    0x8(%r12),%r12
 107e624:	test   %r12,%r12
 107e627:	jne    107e615 <check_input_run+0x11285>
 107e629:	jmp    107e634 <check_input_run+0x112a4>
 107e62b:	mov    0x18(%r12),%r15
 107e630:	mov    (%r15,%r8,4),%r15d
 107e634:	and    $0x7,%r10d
 107e638:	lea    (%r10,%r15,8),%ebp
 107e63c:	test   %r11d,%r11d
 107e63f:	je     107e669 <check_input_run+0x112d9>
 107e641:	mov    %r11d,%r10d
 107e644:	shr    $0x3,%r10d
 107e648:	cmpq   $0x0,0x50(%rsp)
 107e64e:	je     107e676 <check_input_run+0x112e6>
 107e650:	mov    0x50(%rsp),%r15
 107e655:	mov    %r10d,%r12d
 107e658:	sub    0x10(%r15),%r12d
 107e65c:	jae    107e66e <check_input_run+0x112de>
 107e65e:	mov    0x8(%r15),%r15
 107e662:	test   %r15,%r15
 107e665:	jne    107e655 <check_input_run+0x112c5>
 107e667:	jmp    107e676 <check_input_run+0x112e6>
 107e669:	xor    %r10d,%r10d
 107e66c:	jmp    107e67e <check_input_run+0x112ee>
 107e66e:	mov    0x18(%r15),%r10
 107e672:	mov    (%r10,%r12,4),%r10d
 107e676:	and    $0x7,%r11d
 107e67a:	lea    (%r11,%r10,8),%r10d
 107e67e:	mov    0x118(%rsp),%rcx
 107e686:	mov    (%rcx,%rsi,4),%r11d
 107e68a:	mov    0x208(%rsp),%rcx
 107e692:	inc    %rsi
 107e695:	imul   $0x2c,%r11,%r11
 107e699:	mov    %r9d,(%rcx,%r11,1)
 107e69d:	mov    %r14d,0x4(%rcx,%r11,1)
 107e6a2:	mov    %edx,0x8(%rcx,%r11,1)
 107e6a7:	mov    %ebp,0xc(%rcx,%r11,1)
 107e6ac:	vmovdqa 0x780(%rsp),%xmm0
 107e6b5:	vmovdqu %xmm0,0x10(%rcx,%r11,1)
 107e6bc:	mov    0x790(%rsp),%r8
 107e6c4:	mov    %r8,0x20(%rcx,%r11,1)
 107e6c9:	mov    %r10d,0x28(%rcx,%r11,1)
 107e6ce:	cmp    0xc0(%rsp),%rsi
 107e6d6:	jne    107e530 <check_input_run+0x111a0>
 107e6dc:	cmpq   $0x0,0x140(%rsp)
 107e6e5:	je     107e980 <check_input_run+0x115f0>
 107e6eb:	cmpl   $0x0,0x100(%rsp)
 107e6f3:	je     107e980 <check_input_run+0x115f0>
 107e6f9:	xor    %r8d,%r8d
 107e6fc:	cmpl   $0x1,0x100(%rsp)
 107e704:	jne    107e724 <check_input_run+0x11394>
 107e706:	xor    %esi,%esi
 107e708:	jmp    107e8c5 <check_input_run+0x11535>
 107e70d:	xor    %r15d,%r15d
 107e710:	mov    0x18(%rsp),%rdi
 107e715:	mov    0x10(%rsp),%rsi
 107e71a:	mov    0x20(%rsp),%r12
 107e71f:	jmp    106de1b <check_input_run+0xa8b>
 107e724:	mov    0x140(%rsp),%rdx
 107e72c:	mov    0x100(%rsp),%r9
 107e734:	and    $0xfffffffe,%r9d
 107e738:	xor    %esi,%esi
 107e73a:	mov    0x148(%rsp),%rcx
 107e742:	mov    0x458(%rsp),%r11
 107e74a:	mov    %rsi,%r14
 107e74d:	shl    $0x5,%r14
 107e751:	lea    (%r14,%r14,2),%r14
 107e755:	mov    (%rcx,%rsi,4),%r10d
 107e759:	vmovdqu64 (%r11,%r14,1),%zmm0
 107e760:	vmovdqu64 0x20(%r11,%r14,1),%zmm1
 107e76b:	mov    0x140(%rsp),%rcx
 107e773:	mov    $0x0,%r11d
 107e779:	lea    (%r10,%r10,2),%r10
 107e77d:	shl    $0x5,%r10
 107e781:	vmovdqu64 %zmm1,0x20(%rcx,%r10,1)
 107e78c:	vmovdqu64 %zmm0,(%rcx,%r10,1)
 107e793:	mov    0x458(%rsp),%r10
 107e79b:	mov    (%r10,%r14,1),%r10d
 107e79f:	test   %r10d,%r10d
 107e7a2:	je     107e7dc <check_input_run+0x1144c>
 107e7a4:	mov    %r10d,%r11d
 107e7a7:	shr    $0x3,%r11d
 107e7ab:	cmpq   $0x0,0x50(%rsp)
 107e7b1:	je     107e7d4 <check_input_run+0x11444>
 107e7b3:	mov    0x50(%rsp),%r14
 107e7b8:	mov    %r11d,%r15d
 107e7bb:	sub    0x10(%r14),%r15d
 107e7bf:	jae    107e7cc <check_input_run+0x1143c>
 107e7c1:	mov    0x8(%r14),%r14
 107e7c5:	test   %r14,%r14
 107e7c8:	jne    107e7b8 <check_input_run+0x11428>
 107e7ca:	jmp    107e7d4 <check_input_run+0x11444>
 107e7cc:	mov    0x18(%r14),%r11
 107e7d0:	mov    (%r11,%r15,4),%r11d
 107e7d4:	and    $0x7,%r10d
 107e7d8:	lea    (%r10,%r11,8),%r11d
 107e7dc:	mov    0x148(%rsp),%rcx
 107e7e4:	mov    (%rcx,%rsi,4),%r10d
 107e7e8:	lea    (%r10,%r10,2),%r10
 107e7ec:	shl    $0x5,%r10
 107e7f0:	mov    %r11d,(%rdx,%r10,1)
 107e7f4:	lea    0x1(%rsi),%r10
 107e7f8:	mov    0x458(%rsp),%r14
 107e800:	mov    %r10,%r15
 107e803:	shl    $0x5,%r15
 107e807:	mov    0x4(%rcx,%rsi,4),%r11d
 107e80c:	lea    (%r15,%r15,2),%r15
 107e810:	vmovdqu64 (%r14,%r15,1),%zmm0
 107e817:	vmovdqu64 0x20(%r14,%r15,1),%zmm1
 107e822:	lea    (%r11,%r11,2),%r11
 107e826:	shl    $0x5,%r11
 107e82a:	vmovdqu64 %zmm1,0x20(%rdx,%r11,1)
 107e835:	vmovdqu64 %zmm0,(%rdx,%r11,1)
 107e83c:	mov    0x458(%rsp),%r11
 107e844:	mov    (%r11,%r15,1),%r11d
 107e848:	test   %r11d,%r11d
 107e84b:	je     107e875 <check_input_run+0x114e5>
 107e84d:	mov    %r11d,%r14d
 107e850:	shr    $0x3,%r14d
 107e854:	cmpq   $0x0,0x50(%rsp)
 107e85a:	je     107e882 <check_input_run+0x114f2>
 107e85c:	mov    0x50(%rsp),%r15
 107e861:	mov    %r14d,%r12d
 107e864:	sub    0x10(%r15),%r12d
 107e868:	jae    107e87a <check_input_run+0x114ea>
 107e86a:	mov    0x8(%r15),%r15
 107e86e:	test   %r15,%r15
 107e871:	jne    107e861 <check_input_run+0x114d1>
 107e873:	jmp    107e882 <check_input_run+0x114f2>
 107e875:	xor    %r11d,%r11d
 107e878:	jmp    107e88a <check_input_run+0x114fa>
 107e87a:	mov    0x18(%r15),%r14
 107e87e:	mov    (%r14,%r12,4),%r14d
 107e882:	and    $0x7,%r11d
 107e886:	lea    (%r11,%r14,8),%r11d
 107e88a:	mov    0x148(%rsp),%rcx
 107e892:	add    $0x2,%rsi
 107e896:	mov    (%rcx,%r10,4),%r10d
 107e89a:	mov    0x140(%rsp),%rcx
 107e8a2:	lea    (%r10,%r10,2),%r10
 107e8a6:	shl    $0x5,%r10
 107e8aa:	mov    %r11d,(%rcx,%r10,1)
 107e8ae:	cmp    %r9,%rsi
 107e8b1:	jne    107e73a <check_input_run+0x113aa>
 107e8b7:	testb  $0x1,0x100(%rsp)
 107e8bf:	je     107e980 <check_input_run+0x115f0>
 107e8c5:	mov    0x148(%rsp),%rcx
 107e8cd:	mov    0x458(%rsp),%r10
 107e8d5:	mov    %rsi,%r11
 107e8d8:	shl    $0x5,%r11
 107e8dc:	lea    (%r11,%r11,2),%r11
 107e8e0:	mov    (%rcx,%rsi,4),%r9d
 107e8e4:	vmovdqu64 (%r10,%r11,1),%zmm0
 107e8eb:	vmovdqu64 0x20(%r10,%r11,1),%zmm1
 107e8f6:	mov    0x140(%rsp),%rcx
 107e8fe:	lea    (%r9,%r9,2),%r9
 107e902:	shl    $0x5,%r9
 107e906:	vmovdqu64 %zmm1,0x20(%rcx,%r9,1)
 107e911:	vmovdqu64 %zmm0,(%rcx,%r9,1)
 107e918:	mov    0x458(%rsp),%r9
 107e920:	mov    (%r9,%r11,1),%r9d
 107e924:	test   %r9d,%r9d
 107e927:	je     107e961 <check_input_run+0x115d1>
 107e929:	mov    %r9d,%r8d
 107e92c:	shr    $0x3,%r8d
 107e930:	cmpq   $0x0,0x50(%rsp)
 107e936:	je     107e959 <check_input_run+0x115c9>
 107e938:	mov    0x50(%rsp),%r10
 107e93d:	mov    %r8d,%r11d
 107e940:	sub    0x10(%r10),%r11d
 107e944:	jae    107e951 <check_input_run+0x115c1>
 107e946:	mov    0x8(%r10),%r10
 107e94a:	test   %r10,%r10
 107e94d:	jne    107e93d <check_input_run+0x115ad>
 107e94f:	jmp    107e959 <check_input_run+0x115c9>
 107e951:	mov    0x18(%r10),%r8
 107e955:	mov    (%r8,%r11,4),%r8d
 107e959:	and    $0x7,%r9d
 107e95d:	lea    (%r9,%r8,8),%r8d
 107e961:	mov    0x148(%rsp),%rcx
 107e969:	mov    (%rcx,%rsi,4),%esi
 107e96c:	mov    0x140(%rsp),%rcx
 107e974:	lea    (%rsi,%rsi,2),%rsi
 107e978:	shl    $0x5,%rsi
 107e97c:	mov    %r8d,(%rcx,%rsi,1)
 107e980:	cmpq   $0x0,0x140(%rsp)
 107e989:	movzbl 0x58(%rsp),%ecx
 107e98e:	sete   %sil
 107e992:	xor    $0x1,%cl
 107e995:	or     %cl,%sil
 107e998:	mov    %cl,0x58(%rsp)
 107e99c:	jne    107f040 <check_input_run+0x11cb0>
 107e9a2:	mov    0x60(%rsp),%rsi
 107e9a7:	movq   $0x0,0x158(%rsp)
 107e9b3:	cmp    $0x1,%rsi
 107e9b7:	adc    $0x0,%rsi
 107e9bb:	mov    %rsi,0x190(%rsp)
 107e9c3:	mov    0x1b0(%rsp),%rsi
 107e9cb:	mov    0x158(%rsp),%rdx
 107e9d3:	mov    (%rsi),%rsi
 107e9d6:	imul   $0x150,%rdx,%r8
 107e9dd:	lea    0x1(%rdx),%rcx
 107e9e1:	mov    %rdx,0x138(%rsp)
 107e9e9:	lea    (%rcx,%rcx,2),%rdx
 107e9ed:	mov    %rcx,0x158(%rsp)
 107e9f5:	shl    $0x4,%rdx
 107e9f9:	add    0x50(%rsp),%rdx
 107e9fe:	cmpl   $0x0,0xb0(%rsi,%r8,1)
 107ea07:	lea    (%rsi,%r8,1),%rbx
 107ea0b:	je     107eade <check_input_run+0x1174e>
 107ea11:	xor    %esi,%esi
 107ea13:	mov    0x80(%rsp),%r8
 107ea1b:	mov    0x138(%rsp),%rcx
 107ea23:	mov    0xa8(%rbx),%r9
 107ea2a:	lea    0x0(,%rsi,8),%r11
 107ea32:	lea    (%r11,%r11,4),%r11
 107ea36:	mov    (%r8,%rcx,4),%r8d
 107ea3a:	mov    0x20(%r9,%r11,1),%r14
 107ea3f:	mov    0x178(%rsp),%rcx
 107ea47:	add    %esi,%r8d
 107ea4a:	lea    (%r8,%r8,4),%r8
 107ea4e:	mov    %r14,0x20(%rcx,%r8,8)
 107ea53:	vmovdqu (%r9,%r11,1),%ymm0
 107ea59:	vmovdqu %ymm0,(%rcx,%r8,8)
 107ea5f:	mov    0xa8(%rbx),%r8
 107ea66:	mov    0x8(%r8,%r11,1),%r8d
 107ea6b:	test   %r8d,%r8d
 107ea6e:	je     107ea8e <check_input_run+0x116fe>
 107ea70:	mov    %r8d,%r14d
 107ea73:	shr    $0x3,%r14d
 107ea77:	mov    %rdx,%r15
 107ea7a:	mov    %r14d,%r11d
 107ea7d:	sub    0x10(%r15),%r11d
 107ea81:	jae    107ea93 <check_input_run+0x11703>
 107ea83:	mov    0x8(%r15),%r15
 107ea87:	test   %r15,%r15
 107ea8a:	jne    107ea7a <check_input_run+0x116ea>
 107ea8c:	jmp    107ea9b <check_input_run+0x1170b>
 107ea8e:	xor    %r8d,%r8d
 107ea91:	jmp    107eaa3 <check_input_run+0x11713>
 107ea93:	mov    0x18(%r15),%r9
 107ea97:	mov    (%r9,%r11,4),%r14d
 107ea9b:	and    $0x7,%r8d
 107ea9f:	lea    (%r8,%r14,8),%r8d
 107eaa3:	mov    0x80(%rsp),%r9
 107eaab:	mov    0x138(%rsp),%rcx
 107eab3:	mov    (%r9,%rcx,4),%r9d
 107eab7:	mov    0x178(%rsp),%rcx
 107eabf:	add    %esi,%r9d
 107eac2:	inc    %rsi
 107eac5:	lea    (%r9,%r9,4),%r9
 107eac9:	mov    %r8d,0x8(%rcx,%r9,8)
 107eace:	mov    0xb0(%rbx),%r8d
 107ead5:	cmp    %r8,%rsi
 107ead8:	jb     107ea13 <check_input_run+0x11683>
 107eade:	cmpl   $0x0,0xc0(%rbx)
 107eae5:	je     107eb3f <check_input_run+0x117af>
 107eae7:	xor    %esi,%esi
 107eae9:	xor    %r8d,%r8d
 107eaec:	mov    0xa8(%rsp),%rcx
 107eaf4:	mov    0x138(%rsp),%r9
 107eafc:	mov    0xb8(%rbx),%r11
 107eb03:	mov    (%rcx,%r9,4),%r9d
 107eb07:	mov    0x10(%r11,%rsi,1),%r14
 107eb0c:	mov    0x1f8(%rsp),%rcx
 107eb14:	add    %r8d,%r9d
 107eb17:	inc    %r8
 107eb1a:	lea    (%r9,%r9,2),%r9
 107eb1e:	mov    %r14,0x10(%rcx,%r9,8)
 107eb23:	vmovdqu (%r11,%rsi,1),%xmm0
 107eb29:	add    $0x18,%rsi
 107eb2d:	vmovdqu %xmm0,(%rcx,%r9,8)
 107eb33:	mov    0xc0(%rbx),%r9d
 107eb3a:	cmp    %r9,%r8
 107eb3d:	jb     107eaec <check_input_run+0x1175c>
 107eb3f:	cmpl   $0x0,0xd0(%rbx)
 107eb46:	je     107ec19 <check_input_run+0x11889>
 107eb4c:	xor    %esi,%esi
 107eb4e:	mov    0xf8(%rsp),%rcx
 107eb56:	mov    0x138(%rsp),%r8
 107eb5e:	mov    0xc8(%rbx),%r9
 107eb65:	lea    0x0(,%rsi,4),%r11
 107eb6d:	lea    (%r11,%r11,8),%r11
 107eb71:	mov    (%rcx,%r8,4),%r8d
 107eb75:	mov    0x20(%r9,%r11,1),%ebp
 107eb7a:	mov    0x160(%rsp),%rcx
 107eb82:	add    %esi,%r8d
 107eb85:	lea    (%r8,%r8,8),%r8
 107eb89:	mov    %ebp,0x20(%rcx,%r8,4)
 107eb8e:	vmovdqu (%r9,%r11,1),%ymm0
 107eb94:	vmovdqu %ymm0,(%rcx,%r8,4)
 107eb9a:	mov    0xc8(%rbx),%r8
 107eba1:	mov    0x4(%r8,%r11,1),%r8d
 107eba6:	test   %r8d,%r8d
 107eba9:	je     107ebc9 <check_input_run+0x11839>
 107ebab:	mov    %r8d,%r14d
 107ebae:	shr    $0x3,%r14d
 107ebb2:	mov    %rdx,%r15
 107ebb5:	mov    %r14d,%r11d
 107ebb8:	sub    0x10(%r15),%r11d
 107ebbc:	jae    107ebce <check_input_run+0x1183e>
 107ebbe:	mov    0x8(%r15),%r15
 107ebc2:	test   %r15,%r15
 107ebc5:	jne    107ebb5 <check_input_run+0x11825>
 107ebc7:	jmp    107ebd6 <check_input_run+0x11846>
 107ebc9:	xor    %r8d,%r8d
 107ebcc:	jmp    107ebde <check_input_run+0x1184e>
 107ebce:	mov    0x18(%r15),%r9
 107ebd2:	mov    (%r9,%r11,4),%r14d
 107ebd6:	and    $0x7,%r8d
 107ebda:	lea    (%r8,%r14,8),%r8d
 107ebde:	mov    0xf8(%rsp),%rcx
 107ebe6:	mov    0x138(%rsp),%r9
 107ebee:	mov    (%rcx,%r9,4),%r9d
 107ebf2:	mov    0x160(%rsp),%rcx
 107ebfa:	add    %esi,%r9d
 107ebfd:	inc    %rsi
 107ec00:	lea    (%r9,%r9,8),%r9
 107ec04:	mov    %r8d,0x4(%rcx,%r9,4)
 107ec09:	mov    0xd0(%rbx),%r8d
 107ec10:	cmp    %r8,%rsi
 107ec13:	jb     107eb4e <check_input_run+0x117be>
 107ec19:	cmpl   $0x0,0xe8(%rbx)
 107ec20:	je     107ecff <check_input_run+0x1196f>
 107ec26:	xor    %esi,%esi
 107ec28:	mov    0xe0(%rbx),%r9
 107ec2f:	lea    (%rsi,%rsi,8),%r11
 107ec33:	vmovups 0x14(%r9,%r11,4),%xmm0
 107ec3a:	mov    (%r9,%r11,4),%r8d
 107ec3e:	mov    0x4(%r9,%r11,4),%r14d
 107ec43:	vmovups %xmm0,0x78c(%rsp)
 107ec4c:	vmovdqu 0x8(%r9,%r11,4),%xmm0
 107ec53:	vmovdqa %xmm0,0x780(%rsp)
 107ec5c:	test   %r14d,%r14d
 107ec5f:	je     107ec8b <check_input_run+0x118fb>
 107ec61:	mov    %r14d,%r15d
 107ec64:	shr    $0x3,%r15d
 107ec68:	cmpq   $0x0,0x50(%rsp)
 107ec6e:	je     107ec98 <check_input_run+0x11908>
 107ec70:	mov    0x50(%rsp),%r12
 107ec75:	mov    %r15d,%r11d
 107ec78:	sub    0x10(%r12),%r11d
 107ec7d:	jae    107ec8f <check_input_run+0x118ff>
 107ec7f:	mov    0x8(%r12),%r12
 107ec84:	test   %r12,%r12
 107ec87:	jne    107ec75 <check_input_run+0x118e5>
 107ec89:	jmp    107ec98 <check_input_run+0x11908>
 107ec8b:	xor    %ebp,%ebp
 107ec8d:	jmp    107eca0 <check_input_run+0x11910>
 107ec8f:	mov    0x18(%r12),%r9
 107ec94:	mov    (%r9,%r11,4),%r15d
 107ec98:	and    $0x7,%r14d
 107ec9c:	lea    (%r14,%r15,8),%ebp
 107eca0:	mov    0xd8(%rbx),%r9
 107eca7:	mov    0x88(%rsp),%rcx
 107ecaf:	mov    (%r9,%rsi,4),%r9d
 107ecb3:	inc    %rsi
 107ecb6:	mov    (%rcx,%r9,4),%r9d
 107ecba:	mov    0x160(%rsp),%rcx
 107ecc2:	lea    (%r9,%r9,8),%r9
 107ecc6:	mov    %r8d,(%rcx,%r9,4)
 107ecca:	mov    %ebp,0x4(%rcx,%r9,4)
 107eccf:	vmovaps 0x780(%rsp),%xmm0
 107ecd8:	vmovups %xmm0,0x8(%rcx,%r9,4)
 107ecdf:	vmovdqu 0x78c(%rsp),%xmm0
 107ece8:	vmovdqu %xmm0,0x14(%rcx,%r9,4)
 107ecef:	mov    0xe8(%rbx),%r8d
 107ecf6:	cmp    %r8,%rsi
 107ecf9:	jb     107ec28 <check_input_run+0x11898>
 107ecff:	cmpl   $0x0,0xf8(%rbx)
 107ed06:	je     107ed72 <check_input_run+0x119e2>
 107ed08:	xor    %esi,%esi
 107ed0a:	xor    %r8d,%r8d
 107ed0d:	mov    0x1a0(%rsp),%rcx
 107ed15:	mov    0x138(%rsp),%r9
 107ed1d:	mov    0xf0(%rbx),%r11
 107ed24:	mov    (%rcx,%r9,4),%r9d
 107ed28:	vmovdqu64 (%r11,%rsi,1),%zmm0
 107ed2f:	vmovdqu64 0x10(%r11,%rsi,1),%zmm1
 107ed3a:	mov    0x1f0(%rsp),%rcx
 107ed42:	add    $0x50,%rsi
 107ed46:	add    %r8d,%r9d
 107ed49:	inc    %r8
 107ed4c:	lea    (%r9,%r9,4),%r9
 107ed50:	shl    $0x4,%r9
 107ed54:	vmovdqu64 %zmm1,0x10(%rcx,%r9,1)
 107ed5f:	vmovdqu64 %zmm0,(%rcx,%r9,1)
 107ed66:	mov    0xf8(%rbx),%r9d
 107ed6d:	cmp    %r9,%r8
 107ed70:	jb     107ed0d <check_input_run+0x1197d>
 107ed72:	cmpl   $0x0,0x108(%rbx)
 107ed79:	je     107ef3d <check_input_run+0x11bad>
 107ed7f:	xor    %r14d,%r14d
 107ed82:	mov    0x100(%rbx),%r10
 107ed89:	imul   $0x2c,%r14,%rbp
 107ed8d:	movl   $0x0,0x170(%rsp)
 107ed98:	movl   $0x0,0x168(%rsp)
 107eda3:	mov    0x20(%r10,%rbp,1),%r11
 107eda8:	mov    0x8(%r10,%rbp,1),%ecx
 107edad:	mov    (%r10,%rbp,1),%r9d
 107edb1:	mov    0x4(%r10,%rbp,1),%r8d
 107edb6:	mov    0xc(%r10,%rbp,1),%esi
 107edbb:	mov    %r11,0x790(%rsp)
 107edc3:	mov    %ecx,0x188(%rsp)
 107edca:	vmovdqu 0x10(%r10,%rbp,1),%xmm0
 107edd1:	vmovdqa %xmm0,0x780(%rsp)
 107edda:	test   %r9d,%r9d
 107eddd:	je     107ee14 <check_input_run+0x11a84>
 107eddf:	mov    %r9d,%r15d
 107ede2:	shr    $0x3,%r15d
 107ede6:	mov    %rdx,%r11
 107ede9:	mov    %r15d,%r12d
 107edec:	sub    0x10(%r11),%r12d
 107edf0:	jae    107edfd <check_input_run+0x11a6d>
 107edf2:	mov    0x8(%r11),%r11
 107edf6:	test   %r11,%r11
 107edf9:	jne    107ede9 <check_input_run+0x11a59>
 107edfb:	jmp    107ee05 <check_input_run+0x11a75>
 107edfd:	mov    0x18(%r11),%r11
 107ee01:	mov    (%r11,%r12,4),%r15d
 107ee05:	and    $0x7,%r9d
 107ee09:	lea    (%r9,%r15,8),%ecx
 107ee0d:	mov    %ecx,0x168(%rsp)
 107ee14:	mov    0x28(%r10,%rbp,1),%r12d
 107ee19:	test   %r8d,%r8d
 107ee1c:	je     107ee53 <check_input_run+0x11ac3>
 107ee1e:	mov    %r8d,%r15d
 107ee21:	shr    $0x3,%r15d
 107ee25:	mov    %rdx,%r11
 107ee28:	mov    %r15d,%r9d
 107ee2b:	sub    0x10(%r11),%r9d
 107ee2f:	jae    107ee3c <check_input_run+0x11aac>
 107ee31:	mov    0x8(%r11),%r11
 107ee35:	test   %r11,%r11
 107ee38:	jne    107ee28 <check_input_run+0x11a98>
 107ee3a:	jmp    107ee44 <check_input_run+0x11ab4>
 107ee3c:	mov    0x18(%r11),%r11
 107ee40:	mov    (%r11,%r9,4),%r15d
 107ee44:	and    $0x7,%r8d
 107ee48:	lea    (%r8,%r15,8),%ecx
 107ee4c:	mov    %ecx,0x170(%rsp)
 107ee53:	mov    $0x0,%ebp
 107ee58:	xor    %r8d,%r8d
 107ee5b:	test   %esi,%esi
 107ee5d:	je     107ee8c <check_input_run+0x11afc>
 107ee5f:	mov    %esi,%r15d
 107ee62:	shr    $0x3,%r15d
 107ee66:	mov    %rdx,%r11
 107ee69:	mov    %r15d,%r9d
 107ee6c:	sub    0x10(%r11),%r9d
 107ee70:	jae    107ee7d <check_input_run+0x11aed>
 107ee72:	mov    0x8(%r11),%r11
 107ee76:	test   %r11,%r11
 107ee79:	jne    107ee69 <check_input_run+0x11ad9>
 107ee7b:	jmp    107ee85 <check_input_run+0x11af5>
 107ee7d:	mov    0x18(%r11),%r11
 107ee81:	mov    (%r11,%r9,4),%r15d
 107ee85:	and    $0x7,%esi
 107ee88:	lea    (%rsi,%r15,8),%ebp
 107ee8c:	test   %r12d,%r12d
 107ee8f:	je     107eebe <check_input_run+0x11b2e>
 107ee91:	mov    %r12d,%esi
 107ee94:	shr    $0x3,%esi
 107ee97:	mov    %rdx,%r8
 107ee9a:	mov    %esi,%r9d
 107ee9d:	sub    0x10(%r8),%r9d
 107eea1:	jae    107eeae <check_input_run+0x11b1e>
 107eea3:	mov    0x8(%r8),%r8
 107eea7:	test   %r8,%r8
 107eeaa:	jne    107ee9a <check_input_run+0x11b0a>
 107eeac:	jmp    107eeb6 <check_input_run+0x11b26>
 107eeae:	mov    0x18(%r8),%rsi
 107eeb2:	mov    (%rsi,%r9,4),%esi
 107eeb6:	and    $0x7,%r12d
 107eeba:	lea    (%r12,%rsi,8),%r8d
 107eebe:	mov    0x198(%rsp),%rcx
 107eec6:	mov    0x138(%rsp),%rsi
 107eece:	mov    0x168(%rsp),%r9d
 107eed6:	mov    0x170(%rsp),%r11d
 107eede:	mov    0x188(%rsp),%r10d
 107eee6:	mov    (%rcx,%rsi,4),%esi
 107eee9:	mov    0x208(%rsp),%rcx
 107eef1:	add    %r14d,%esi
 107eef4:	inc    %r14
 107eef7:	imul   $0x2c,%rsi,%rsi
 107eefb:	mov    %r9d,(%rcx,%rsi,1)
 107eeff:	mov    %r11d,0x4(%rcx,%rsi,1)
 107ef04:	mov    %r10d,0x8(%rcx,%rsi,1)
 107ef09:	mov    %ebp,0xc(%rcx,%rsi,1)
 107ef0d:	vmovdqa 0x780(%rsp),%xmm0
 107ef16:	vmovdqu %xmm0,0x10(%rcx,%rsi,1)
 107ef1c:	mov    0x790(%rsp),%r9
 107ef24:	mov    %r9,0x20(%rcx,%rsi,1)
 107ef29:	mov    %r8d,0x28(%rcx,%rsi,1)
 107ef2e:	mov    0x108(%rbx),%esi
 107ef34:	cmp    %rsi,%r14
 107ef37:	jb     107ed82 <check_input_run+0x119f2>
 107ef3d:	cmpl   $0x0,0x118(%rbx)
 107ef44:	je     107f02a <check_input_run+0x11c9a>
 107ef4a:	xor    %esi,%esi
 107ef4c:	mov    0x180(%rsp),%rcx
 107ef54:	mov    0x138(%rsp),%r8
 107ef5c:	mov    0x110(%rbx),%r9
 107ef63:	mov    %rsi,%r11
 107ef66:	shl    $0x5,%r11
 107ef6a:	lea    (%r11,%r11,2),%r11
 107ef6e:	mov    (%rcx,%r8,4),%r8d
 107ef72:	vmovdqu64 (%r9,%r11,1),%zmm0
 107ef79:	vmovdqu64 0x20(%r9,%r11,1),%zmm1
 107ef84:	mov    0x140(%rsp),%rcx
 107ef8c:	add    %esi,%r8d
 107ef8f:	lea    (%r8,%r8,2),%r8
 107ef93:	shl    $0x5,%r8
 107ef97:	vmovdqu64 %zmm1,0x20(%rcx,%r8,1)
 107efa2:	vmovdqu64 %zmm0,(%rcx,%r8,1)
 107efa9:	mov    0x110(%rbx),%r8
 107efb0:	mov    (%r8,%r11,1),%r8d
 107efb4:	test   %r8d,%r8d
 107efb7:	je     107efd7 <check_input_run+0x11c47>
 107efb9:	mov    %r8d,%r14d
 107efbc:	shr    $0x3,%r14d
 107efc0:	mov    %rdx,%r11
 107efc3:	mov    %r14d,%r9d
 107efc6:	sub    0x10(%r11),%r9d
 107efca:	jae    107efdc <check_input_run+0x11c4c>
 107efcc:	mov    0x8(%r11),%r11
 107efd0:	test   %r11,%r11
 107efd3:	jne    107efc3 <check_input_run+0x11c33>
 107efd5:	jmp    107efe4 <check_input_run+0x11c54>
 107efd7:	xor    %r8d,%r8d
 107efda:	jmp    107efec <check_input_run+0x11c5c>
 107efdc:	mov    0x18(%r11),%r11
 107efe0:	mov    (%r11,%r9,4),%r14d
 107efe4:	and    $0x7,%r8d
 107efe8:	lea    (%r8,%r14,8),%r8d
 107efec:	mov    0x180(%rsp),%rcx
 107eff4:	mov    0x138(%rsp),%r9
 107effc:	mov    (%rcx,%r9,4),%r9d
 107f000:	mov    0x140(%rsp),%rcx
 107f008:	add    %esi,%r9d
 107f00b:	inc    %rsi
 107f00e:	lea    (%r9,%r9,2),%r9
 107f012:	shl    $0x5,%r9
 107f016:	mov    %r8d,(%rcx,%r9,1)
 107f01a:	mov    0x118(%rbx),%r8d
 107f021:	cmp    %r8,%rsi
 107f024:	jb     107ef4c <check_input_run+0x11bbc>
 107f02a:	mov    0x158(%rsp),%rcx
 107f032:	cmp    0x190(%rsp),%rcx
 107f03a:	jne    107e9c3 <check_input_run+0x11633>
 107f040:	cmpq   $0x0,0x140(%rsp)
 107f049:	je     107830e <check_input_run+0xaf7e>
 107f04f:	mov    0x2c8(%rsp),%r8
 107f057:	mov    (%r8),%rsi
 107f05a:	mov    0x8(%r8),%r9
 107f05e:	lea    0x3(%r9,%rsi,1),%rbx
 107f063:	add    %rsi,%r9
 107f066:	and    $0xfffffffffffffffc,%rbx
 107f06a:	cmp    %r9,%rbx
 107f06d:	jb     107830e <check_input_run+0xaf7e>
 107f073:	mov    0x10(%r8),%r10
 107f077:	mov    %rbx,%r9
 107f07a:	sub    %rsi,%r9
 107f07d:	sub    %r9,%r10
 107f080:	jb     107830e <check_input_run+0xaf7e>
 107f086:	mov    0x2dc(%rsp),%r12d
 107f08e:	lea    0x1(%r12),%r15
 107f093:	lea    0x0(,%r15,4),%rsi
 107f09b:	cmp    %r10,%rsi
 107f09e:	ja     107830e <check_input_run+0xaf7e>
 107f0a4:	add    %rsi,%r9
 107f0a7:	mov    %r9,0x8(%r8)
 107f0ab:	test   %rbx,%rbx
 107f0ae:	je     107830e <check_input_run+0xaf7e>
 107f0b4:	mov    0x2c8(%rsp),%r8
 107f0bc:	mov    (%r8),%r10
 107f0bf:	mov    0x8(%r8),%r9
 107f0c3:	lea    0x3(%r9,%r10,1),%rcx
 107f0c8:	add    %r10,%r9
 107f0cb:	and    $0xfffffffffffffffc,%rcx
 107f0cf:	mov    %rcx,0x138(%rsp)
 107f0d7:	cmp    %r9,%rcx
 107f0da:	jb     107830e <check_input_run+0xaf7e>
 107f0e0:	mov    0x138(%rsp),%r9
 107f0e8:	sub    %r10,%r9
 107f0eb:	mov    0x10(%r8),%r10
 107f0ef:	sub    %r9,%r10
 107f0f2:	jb     107830e <check_input_run+0xaf7e>
 107f0f8:	cmp    %r10,%rsi
 107f0fb:	ja     107830e <check_input_run+0xaf7e>
 107f101:	add    %rsi,%r9
 107f104:	cmpq   $0x0,0x138(%rsp)
 107f10d:	mov    %r9,0x8(%r8)
 107f111:	je     107830e <check_input_run+0xaf7e>
 107f117:	mov    0x2c8(%rsp),%r8
 107f11f:	mov    (%r8),%r10
 107f122:	mov    0x8(%r8),%r9
 107f126:	lea    0x3(%r9,%r10,1),%rcx
 107f12b:	add    %r10,%r9
 107f12e:	and    $0xfffffffffffffffc,%rcx
 107f132:	mov    %rcx,0x158(%rsp)
 107f13a:	cmp    %r9,%rcx
 107f13d:	jb     107830e <check_input_run+0xaf7e>
 107f143:	mov    0x158(%rsp),%r9
 107f14b:	sub    %r10,%r9
 107f14e:	mov    0x10(%r8),%r10
 107f152:	sub    %r9,%r10
 107f155:	jb     107830e <check_input_run+0xaf7e>
 107f15b:	cmp    %r10,%rsi
 107f15e:	ja     107830e <check_input_run+0xaf7e>
 107f164:	add    %rsi,%r9
 107f167:	cmpq   $0x0,0x158(%rsp)
 107f170:	mov    %r9,0x8(%r8)
 107f174:	je     107830e <check_input_run+0xaf7e>
 107f17a:	mov    0x2c8(%rsp),%r8
 107f182:	mov    (%r8),%r10
 107f185:	mov    0x8(%r8),%r9
 107f189:	lea    0x3(%r9,%r10,1),%rcx
 107f18e:	add    %r10,%r9
 107f191:	and    $0xfffffffffffffffc,%rcx
 107f195:	mov    %rcx,0x170(%rsp)
 107f19d:	cmp    %r9,%rcx
 107f1a0:	jb     107830e <check_input_run+0xaf7e>
 107f1a6:	mov    0x170(%rsp),%r9
 107f1ae:	sub    %r10,%r9
 107f1b1:	mov    0x10(%r8),%r10
 107f1b5:	sub    %r9,%r10
 107f1b8:	jb     107830e <check_input_run+0xaf7e>
 107f1be:	cmp    %r10,%rsi
 107f1c1:	ja     107830e <check_input_run+0xaf7e>
 107f1c7:	add    %rsi,%r9
 107f1ca:	cmpq   $0x0,0x170(%rsp)
 107f1d3:	mov    %r9,0x8(%r8)
 107f1d7:	je     107830e <check_input_run+0xaf7e>
 107f1dd:	mov    0x2c8(%rsp),%r8
 107f1e5:	mov    (%r8),%r10
 107f1e8:	mov    0x8(%r8),%r9
 107f1ec:	lea    0x3(%r9,%r10,1),%rcx
 107f1f1:	add    %r10,%r9
 107f1f4:	and    $0xfffffffffffffffc,%rcx
 107f1f8:	mov    %rcx,0x168(%rsp)
 107f200:	cmp    %r9,%rcx
 107f203:	jb     107830e <check_input_run+0xaf7e>
 107f209:	mov    0x168(%rsp),%r9
 107f211:	sub    %r10,%r9
 107f214:	mov    0x10(%r8),%r10
 107f218:	sub    %r9,%r10
 107f21b:	jb     107830e <check_input_run+0xaf7e>
 107f221:	cmp    %r10,%rsi
 107f224:	ja     107830e <check_input_run+0xaf7e>
 107f22a:	add    %rsi,%r9
 107f22d:	cmpq   $0x0,0x168(%rsp)
 107f236:	mov    %r9,0x8(%r8)
 107f23a:	je     107830e <check_input_run+0xaf7e>
 107f240:	mov    0x2c8(%rsp),%r8
 107f248:	mov    (%r8),%r10
 107f24b:	mov    0x8(%r8),%r9
 107f24f:	lea    0x3(%r9,%r10,1),%rcx
 107f254:	add    %r10,%r9
 107f257:	and    $0xfffffffffffffffc,%rcx
 107f25b:	mov    %rcx,0x190(%rsp)
 107f263:	cmp    %r9,%rcx
 107f266:	jb     107830e <check_input_run+0xaf7e>
 107f26c:	mov    0x190(%rsp),%r9
 107f274:	sub    %r10,%r9
 107f277:	mov    0x10(%r8),%r10
 107f27b:	sub    %r9,%r10
 107f27e:	jb     107830e <check_input_run+0xaf7e>
 107f284:	cmp    %r10,%rsi
 107f287:	ja     107830e <check_input_run+0xaf7e>
 107f28d:	add    %rsi,%r9
 107f290:	cmpq   $0x0,0x190(%rsp)
 107f299:	mov    %r9,0x8(%r8)
 107f29d:	je     107830e <check_input_run+0xaf7e>
 107f2a3:	mov    0x2c8(%rsp),%rsi
 107f2ab:	mov    0x8(%rsi),%r9
 107f2af:	mov    0x10(%rsi),%r8
 107f2b3:	sub    %r9,%r8
 107f2b6:	mov    %r9,%rcx
 107f2b9:	setb   %r9b
 107f2bd:	cmp    %r12,%r8
 107f2c0:	setbe  %r8b
 107f2c4:	or     %r9b,%r8b
 107f2c7:	jne    107830e <check_input_run+0xaf7e>
 107f2cd:	lea    (%rcx,%r15,1),%r8
 107f2d1:	add    (%rsi),%rcx
 107f2d4:	mov    %r8,0x8(%rsi)
 107f2d8:	mov    %rcx,0x200(%rsp)
 107f2e0:	je     107830e <check_input_run+0xaf7e>
 107f2e6:	mov    0x2c8(%rsp),%rsi
 107f2ee:	mov    0x8(%rsi),%r8
 107f2f2:	mov    0x10(%rsi),%r9
 107f2f6:	sub    %r8,%r9
 107f2f9:	setb   %r10b
 107f2fd:	cmp    %r12,%r9
 107f300:	setbe  %r9b
 107f304:	or     %r10b,%r9b
 107f307:	jne    107830e <check_input_run+0xaf7e>
 107f30d:	mov    %r8,%rcx
 107f310:	add    %r8,%r15
 107f313:	add    (%rsi),%rcx
 107f316:	mov    %r15,0x8(%rsi)
 107f31a:	mov    %rcx,0x188(%rsp)
 107f322:	je     107f633 <check_input_run+0x122a3>
 107f328:	cmpl   $0x0,0xa0(%rsp)
 107f330:	je     107f633 <check_input_run+0x122a3>
 107f336:	cmpl   $0x1,0xa0(%rsp)
 107f33e:	jne    107f348 <check_input_run+0x11fb8>
 107f340:	xor    %r15d,%r15d
 107f343:	jmp    107f54a <check_input_run+0x121ba>
 107f348:	mov    0xa0(%rsp),%r12
 107f350:	and    $0xfffffffe,%r12d
 107f354:	lea    0x4(%rax),%rdx
 107f358:	mov    $0xffffffff,%ebp
 107f35d:	xor    %r15d,%r15d
 107f360:	mov    0x2f8(%rsp),%r9
 107f368:	mov    -0x4(%rdx,%r15,4),%esi
 107f36d:	mov    0x138(%rsp),%rcx
 107f375:	mov    (%r9,%r15,4),%r9d
 107f379:	mov    %r9d,(%rbx,%rsi,4)
 107f37d:	mov    0x300(%rsp),%r9
 107f385:	mov    (%r9,%r15,4),%r9d
 107f389:	mov    %r9d,(%rcx,%rsi,4)
 107f38d:	mov    0x158(%rsp),%rcx
 107f395:	mov    0x308(%rsp),%r9
 107f39d:	mov    (%r9,%r15,4),%r9d
 107f3a1:	mov    %r9d,(%rcx,%rsi,4)
 107f3a5:	mov    0x310(%rsp),%r9
 107f3ad:	mov    (%r9,%r15,4),%r9d
 107f3b1:	cmp    %rbp,%r9
 107f3b4:	je     107f3bc <check_input_run+0x1202c>
 107f3b6:	mov    (%rax,%r9,4),%r9d
 107f3ba:	jmp    107f3c2 <check_input_run+0x12032>
 107f3bc:	mov    $0xffffffff,%r9d
 107f3c2:	mov    0x170(%rsp),%rcx
 107f3ca:	mov    %r9d,(%rcx,%rsi,4)
 107f3ce:	mov    0x318(%rsp),%r9
 107f3d6:	mov    (%r9,%r15,4),%r9d
 107f3da:	test   %r9d,%r9d
 107f3dd:	je     107f3eb <check_input_run+0x1205b>
 107f3df:	dec    %r9d
 107f3e2:	mov    (%rax,%r9,4),%r9d
 107f3e6:	inc    %r9d
 107f3e9:	jmp    107f3ee <check_input_run+0x1205e>
 107f3eb:	xor    %r9d,%r9d
 107f3ee:	mov    0x168(%rsp),%rcx
 107f3f6:	mov    %r9d,(%rcx,%rsi,4)
 107f3fa:	mov    0x190(%rsp),%rcx
 107f402:	mov    0x320(%rsp),%r9
 107f40a:	mov    (%r9,%r15,4),%r9d
 107f40e:	mov    %r9d,(%rcx,%rsi,4)
 107f412:	mov    0x200(%rsp),%rcx
 107f41a:	mov    0x328(%rsp),%r9
 107f422:	movzbl (%r9,%r15,1),%r9d
 107f427:	mov    %r9b,(%rcx,%rsi,1)
 107f42b:	mov    0x188(%rsp),%rcx
 107f433:	mov    0x330(%rsp),%r9
 107f43b:	movzbl (%r9,%r15,1),%r9d
 107f440:	mov    %r9b,(%rcx,%rsi,1)
 107f444:	mov    0x138(%rsp),%rcx
 107f44c:	mov    0x2f8(%rsp),%r9
 107f454:	mov    (%rdx,%r15,4),%esi
 107f458:	mov    0x4(%r9,%r15,4),%r9d
 107f45d:	mov    %r9d,(%rbx,%rsi,4)
 107f461:	mov    0x300(%rsp),%r9
 107f469:	mov    0x4(%r9,%r15,4),%r9d
 107f46e:	mov    %r9d,(%rcx,%rsi,4)
 107f472:	mov    0x158(%rsp),%rcx
 107f47a:	mov    0x308(%rsp),%r9
 107f482:	mov    0x4(%r9,%r15,4),%r9d
 107f487:	mov    %r9d,(%rcx,%rsi,4)
 107f48b:	mov    0x310(%rsp),%r9
 107f493:	mov    0x4(%r9,%r15,4),%r9d
 107f498:	cmp    %rbp,%r9
 107f49b:	je     107f4a3 <check_input_run+0x12113>
 107f49d:	mov    (%rax,%r9,4),%r9d
 107f4a1:	jmp    107f4a9 <check_input_run+0x12119>
 107f4a3:	mov    $0xffffffff,%r9d
 107f4a9:	mov    0x170(%rsp),%rcx
 107f4b1:	mov    %r9d,(%rcx,%rsi,4)
 107f4b5:	mov    0x318(%rsp),%r9
 107f4bd:	mov    0x4(%r9,%r15,4),%r9d
 107f4c2:	test   %r9d,%r9d
 107f4c5:	je     107f4d3 <check_input_run+0x12143>
 107f4c7:	dec    %r9d
 107f4ca:	mov    (%rax,%r9,4),%r9d
 107f4ce:	inc    %r9d
 107f4d1:	jmp    107f4d6 <check_input_run+0x12146>
 107f4d3:	xor    %r9d,%r9d
 107f4d6:	mov    0x168(%rsp),%rcx
 107f4de:	mov    %r9d,(%rcx,%rsi,4)
 107f4e2:	mov    0x190(%rsp),%rcx
 107f4ea:	mov    0x320(%rsp),%r9
 107f4f2:	mov    0x4(%r9,%r15,4),%r9d
 107f4f7:	mov    %r9d,(%rcx,%rsi,4)
 107f4fb:	mov    0x200(%rsp),%rcx
 107f503:	mov    0x328(%rsp),%r9
 107f50b:	movzbl 0x1(%r9,%r15,1),%r9d
 107f511:	mov    %r9b,(%rcx,%rsi,1)
 107f515:	mov    0x188(%rsp),%rcx
 107f51d:	mov    0x330(%rsp),%r9
 107f525:	movzbl 0x1(%r9,%r15,1),%r9d
 107f52b:	add    $0x2,%r15
 107f52f:	mov    %r9b,(%rcx,%rsi,1)
 107f533:	cmp    %r15,%r12
 107f536:	jne    107f360 <check_input_run+0x11fd0>
 107f53c:	testb  $0x1,0xa0(%rsp)
 107f544:	je     107f633 <check_input_run+0x122a3>
 107f54a:	mov    0x2f8(%rsp),%r9
 107f552:	mov    (%rax,%r15,4),%esi
 107f556:	mov    0x138(%rsp),%rcx
 107f55e:	mov    $0xffffffff,%r10d
 107f564:	mov    (%r9,%r15,4),%r9d
 107f568:	mov    %r9d,(%rbx,%rsi,4)
 107f56c:	mov    0x300(%rsp),%r9
 107f574:	mov    (%r9,%r15,4),%r9d
 107f578:	mov    %r9d,(%rcx,%rsi,4)
 107f57c:	mov    0x158(%rsp),%rcx
 107f584:	mov    0x308(%rsp),%r9
 107f58c:	mov    (%r9,%r15,4),%r9d
 107f590:	mov    %r9d,(%rcx,%rsi,4)
 107f594:	mov    0x310(%rsp),%r9
 107f59c:	mov    (%r9,%r15,4),%r9d
 107f5a0:	cmp    %r10,%r9
 107f5a3:	je     107f5ab <check_input_run+0x1221b>
 107f5a5:	mov    (%rax,%r9,4),%r9d
 107f5a9:	jmp    107f5b1 <check_input_run+0x12221>
 107f5ab:	mov    $0xffffffff,%r9d
 107f5b1:	mov    0x170(%rsp),%rcx
 107f5b9:	mov    %r9d,(%rcx,%rsi,4)
 107f5bd:	mov    0x318(%rsp),%r9
 107f5c5:	mov    (%r9,%r15,4),%r9d
 107f5c9:	test   %r9d,%r9d
 107f5cc:	je     107f5da <check_input_run+0x1224a>
 107f5ce:	dec    %r9d
 107f5d1:	mov    (%rax,%r9,4),%r9d
 107f5d5:	inc    %r9d
 107f5d8:	jmp    107f5dd <check_input_run+0x1224d>
 107f5da:	xor    %r9d,%r9d
 107f5dd:	mov    0x168(%rsp),%rcx
 107f5e5:	mov    %r9d,(%rcx,%rsi,4)
 107f5e9:	mov    0x190(%rsp),%rcx
 107f5f1:	mov    0x320(%rsp),%r9
 107f5f9:	mov    (%r9,%r15,4),%r9d
 107f5fd:	mov    %r9d,(%rcx,%rsi,4)
 107f601:	mov    0x200(%rsp),%rcx
 107f609:	mov    0x328(%rsp),%r9
 107f611:	movzbl (%r9,%r15,1),%r9d
 107f616:	mov    %r9b,(%rcx,%rsi,1)
 107f61a:	mov    0x188(%rsp),%rcx
 107f622:	mov    0x330(%rsp),%r9
 107f62a:	movzbl (%r9,%r15,1),%r9d
 107f62f:	mov    %r9b,(%rcx,%rsi,1)
 107f633:	cmpq   $0x0,0x188(%rsp)
 107f63c:	sete   %sil
 107f640:	or     %sil,0x58(%rsp)
 107f645:	jne    107f7d5 <check_input_run+0x12445>
 107f64b:	mov    0x60(%rsp),%r15
 107f650:	cmp    $0x1,%r15
 107f654:	adc    $0x0,%r15
 107f658:	xor    %r12d,%r12d
 107f65b:	mov    0x1b0(%rsp),%rsi
 107f663:	mov    (%rsi),%rbp
 107f666:	imul   $0x150,%r12,%rsi
 107f66d:	cmpl   $0x0,0x60(%rbp,%rsi,1)
 107f672:	je     107f7c9 <check_input_run+0x12439>
 107f678:	mov    0x1a8(%rsp),%rcx
 107f680:	lea    (%r12,%r12,2),%r10
 107f684:	add    %rsi,%rbp
 107f687:	xor    %esi,%esi
 107f689:	shl    $0x4,%r10
 107f68d:	mov    (%rcx,%r12,4),%ecx
 107f691:	mov    %ecx,%r9d
 107f694:	sub    0xa0(%rsp),%r9d
 107f69c:	mov    %rcx,%rdx
 107f69f:	mov    0x68(%rbp),%r14
 107f6a3:	lea    (%rdx,%rsi,1),%r11d
 107f6a7:	mov    (%r14,%rsi,4),%r14d
 107f6ab:	mov    %r14d,(%rbx,%r11,4)
 107f6af:	mov    0x70(%rbp),%r14
 107f6b3:	mov    0x98(%rbp),%r8
 107f6ba:	cmpb   $0x2,(%r8,%rsi,1)
 107f6bf:	mov    (%r14,%rsi,4),%r14d
 107f6c3:	jne    107f6d9 <check_input_run+0x12349>
 107f6c5:	mov    0x860(%rsp),%r8
 107f6cd:	mov    0x1d0(%r8),%r8
 107f6d4:	add    0x14(%r8,%r10,1),%r14d
 107f6d9:	mov    0x138(%rsp),%rcx
 107f6e1:	mov    %r14d,(%rcx,%r11,4)
 107f6e5:	mov    0x158(%rsp),%rcx
 107f6ed:	mov    0x78(%rbp),%r8
 107f6f1:	mov    (%r8,%rsi,4),%r8d
 107f6f5:	mov    %r8d,(%rcx,%r11,4)
 107f6f9:	mov    $0xffffffff,%ecx
 107f6fe:	mov    0x80(%rbp),%r8
 107f705:	mov    (%r8,%rsi,4),%r14d
 107f709:	cmp    %rcx,%r14
 107f70c:	je     107f71e <check_input_run+0x1238e>
 107f70e:	cmp    0xa0(%rsp),%r14d
 107f716:	jae    107f726 <check_input_run+0x12396>
 107f718:	mov    (%rax,%r14,4),%r14d
 107f71c:	jmp    107f729 <check_input_run+0x12399>
 107f71e:	mov    $0xffffffff,%r14d
 107f724:	jmp    107f729 <check_input_run+0x12399>
 107f726:	add    %r9d,%r14d
 107f729:	mov    0x170(%rsp),%rcx
 107f731:	mov    %r14d,(%rcx,%r11,4)
 107f735:	mov    0x88(%rbp),%r8
 107f73c:	mov    (%r8,%rsi,4),%r14d
 107f740:	test   %r14d,%r14d
 107f743:	je     107f75b <check_input_run+0x123cb>
 107f745:	dec    %r14d
 107f748:	cmp    0xa0(%rsp),%r14d
 107f750:	jae    107f760 <check_input_run+0x123d0>
 107f752:	mov    %r14d,%r8d
 107f755:	mov    (%rax,%r8,4),%r14d
 107f759:	jmp    107f763 <check_input_run+0x123d3>
 107f75b:	xor    %r14d,%r14d
 107f75e:	jmp    107f766 <check_input_run+0x123d6>
 107f760:	add    %r9d,%r14d
 107f763:	inc    %r14d
 107f766:	mov    0x168(%rsp),%rcx
 107f76e:	mov    %r14d,(%rcx,%r11,4)
 107f772:	mov    0x190(%rsp),%rcx
 107f77a:	mov    0x90(%rbp),%r8
 107f781:	mov    (%r8,%rsi,4),%r8d
 107f785:	mov    %r8d,(%rcx,%r11,4)
 107f789:	mov    0x200(%rsp),%rcx
 107f791:	mov    0x98(%rbp),%r8
 107f798:	movzbl (%r8,%rsi,1),%r8d
 107f79d:	mov    %r8b,(%rcx,%r11,1)
 107f7a1:	mov    0x188(%rsp),%rcx
 107f7a9:	mov    0xa0(%rbp),%r8
 107f7b0:	movzbl (%r8,%rsi,1),%r8d
 107f7b5:	inc    %rsi
 107f7b8:	mov    %r8b,(%rcx,%r11,1)
 107f7bc:	mov    0x60(%rbp),%r8d
 107f7c0:	cmp    %r8,%rsi
 107f7c3:	jb     107f69f <check_input_run+0x1230f>
 107f7c9:	inc    %r12
 107f7cc:	cmp    %r15,%r12
 107f7cf:	jne    107f65b <check_input_run+0x122cb>
 107f7d5:	cmpq   $0x0,0x188(%rsp)
 107f7de:	je     107830e <check_input_run+0xaf7e>
 107f7e4:	cmpl   $0x0,0x2f0(%rsp)
 107f7ec:	je     107f810 <check_input_run+0x12480>
 107f7ee:	xor    %ecx,%ecx
 107f7f0:	mov    0x2e8(%rsp),%rdx
 107f7f8:	mov    (%rdx,%rcx,4),%esi
 107f7fb:	mov    (%rax,%rsi,4),%esi
 107f7fe:	mov    %esi,(%rdx,%rcx,4)
 107f801:	inc    %rcx
 107f804:	mov    0x2f0(%rsp),%edx
 107f80b:	cmp    %rdx,%rcx
 107f80e:	jb     107f7f0 <check_input_run+0x12460>
 107f810:	mov    0x2d8(%rsp),%edx
 107f817:	test   %rdx,%rdx
 107f81a:	je     107f9a0 <check_input_run+0x12610>
 107f820:	lea    (%rdx,%rdx,2),%r15
 107f824:	mov    %r15d,%ecx
 107f827:	and    $0x7,%ecx
 107f82a:	cmp    $0x3,%edx
 107f82d:	jae    107f836 <check_input_run+0x124a6>
 107f82f:	xor    %edx,%edx
 107f831:	jmp    107f974 <check_input_run+0x125e4>
 107f836:	and    $0xfffffffffffffff8,%r15
 107f83a:	xor    %edx,%edx
 107f83c:	mov    0x2d0(%rsp),%rsi
 107f844:	mov    $0x0,%r10d
 107f84a:	mov    (%rsi,%rdx,4),%r9d
 107f84e:	test   %r9d,%r9d
 107f851:	je     107f85d <check_input_run+0x124cd>
 107f853:	dec    %r9d
 107f856:	mov    (%rax,%r9,4),%r10d
 107f85a:	inc    %r10d
 107f85d:	mov    %r10d,(%rsi,%rdx,4)
 107f861:	mov    $0x0,%r11d
 107f867:	xor    %esi,%esi
 107f869:	mov    0x2d0(%rsp),%r9
 107f871:	mov    0x4(%r9,%rdx,4),%r10d
 107f876:	test   %r10d,%r10d
 107f879:	je     107f885 <check_input_run+0x124f5>
 107f87b:	dec    %r10d
 107f87e:	mov    (%rax,%r10,4),%r11d
 107f882:	inc    %r11d
 107f885:	mov    %r11d,0x4(%r9,%rdx,4)
 107f88a:	mov    0x2d0(%rsp),%r9
 107f892:	mov    0x8(%r9,%rdx,4),%r10d
 107f897:	test   %r10d,%r10d
 107f89a:	je     107f8a5 <check_input_run+0x12515>
 107f89c:	dec    %r10d
 107f89f:	mov    (%rax,%r10,4),%esi
 107f8a3:	inc    %esi
 107f8a5:	mov    %esi,0x8(%r9,%rdx,4)
 107f8aa:	mov    $0x0,%r11d
 107f8b0:	xor    %esi,%esi
 107f8b2:	mov    0x2d0(%rsp),%r9
 107f8ba:	mov    0xc(%r9,%rdx,4),%r10d
 107f8bf:	test   %r10d,%r10d
 107f8c2:	je     107f8ce <check_input_run+0x1253e>
 107f8c4:	dec    %r10d
 107f8c7:	mov    (%rax,%r10,4),%r11d
 107f8cb:	inc    %r11d
 107f8ce:	mov    %r11d,0xc(%r9,%rdx,4)
 107f8d3:	mov    0x2d0(%rsp),%r9
 107f8db:	mov    0x10(%r9,%rdx,4),%r10d
 107f8e0:	test   %r10d,%r10d
 107f8e3:	je     107f8ee <check_input_run+0x1255e>
 107f8e5:	dec    %r10d
 107f8e8:	mov    (%rax,%r10,4),%esi
 107f8ec:	inc    %esi
 107f8ee:	mov    %esi,0x10(%r9,%rdx,4)
 107f8f3:	mov    $0x0,%r11d
 107f8f9:	xor    %esi,%esi
 107f8fb:	mov    0x2d0(%rsp),%r9
 107f903:	mov    0x14(%r9,%rdx,4),%r10d
 107f908:	test   %r10d,%r10d
 107f90b:	je     107f917 <check_input_run+0x12587>
 107f90d:	dec    %r10d
 107f910:	mov    (%rax,%r10,4),%r11d
 107f914:	inc    %r11d
 107f917:	mov    %r11d,0x14(%r9,%rdx,4)
 107f91c:	mov    0x2d0(%rsp),%r9
 107f924:	mov    0x18(%r9,%rdx,4),%r10d
 107f929:	test   %r10d,%r10d
 107f92c:	je     107f937 <check_input_run+0x125a7>
 107f92e:	dec    %r10d
 107f931:	mov    (%rax,%r10,4),%esi
 107f935:	inc    %esi
 107f937:	mov    %esi,0x18(%r9,%rdx,4)
 107f93c:	mov    0x2d0(%rsp),%rsi
 107f944:	mov    0x1c(%rsi,%rdx,4),%r9d
 107f949:	test   %r9d,%r9d
 107f94c:	je     107f95a <check_input_run+0x125ca>
 107f94e:	dec    %r9d
 107f951:	mov    (%rax,%r9,4),%r9d
 107f955:	inc    %r9d
 107f958:	jmp    107f95d <check_input_run+0x125cd>
 107f95a:	xor    %r9d,%r9d
 107f95d:	mov    %r9d,0x1c(%rsi,%rdx,4)
 107f962:	add    $0x8,%rdx
 107f966:	cmp    %rdx,%r15
 107f969:	jne    107f83c <check_input_run+0x124ac>
 107f96f:	test   %rcx,%rcx
 107f972:	je     107f9a0 <check_input_run+0x12610>
 107f974:	mov    0x2d0(%rsp),%rsi
 107f97c:	mov    (%rsi,%rdx,4),%r9d
 107f980:	test   %r9d,%r9d
 107f983:	je     107f991 <check_input_run+0x12601>
 107f985:	dec    %r9d
 107f988:	mov    (%rax,%r9,4),%r9d
 107f98c:	inc    %r9d
 107f98f:	jmp    107f994 <check_input_run+0x12604>
 107f991:	xor    %r9d,%r9d
 107f994:	mov    %r9d,(%rsi,%rdx,4)
 107f998:	inc    %rdx
 107f99b:	dec    %rcx
 107f99e:	jne    107f974 <check_input_run+0x125e4>
 107f9a0:	mov    0x138(%rsp),%rax
 107f9a8:	mov    0x158(%rsp),%rdx
 107f9b0:	mov    0x170(%rsp),%rcx
 107f9b8:	mov    %rbx,0x2f8(%rsp)
 107f9c0:	mov    %rax,0x300(%rsp)
 107f9c8:	mov    %rdx,0x308(%rsp)
 107f9d0:	mov    %rcx,0x310(%rsp)
 107f9d8:	mov    0x168(%rsp),%rdx
 107f9e0:	mov    0x190(%rsp),%rcx
 107f9e8:	mov    %rdx,0x318(%rsp)
 107f9f0:	mov    %rcx,0x320(%rsp)
 107f9f8:	mov    0x200(%rsp),%rdx
 107fa00:	mov    0x188(%rsp),%rcx
 107fa08:	mov    %rdx,0x328(%rsp)
 107fa10:	mov    %rcx,0x330(%rsp)
 107fa18:	mov    %edi,0x2e0(%rsp)
 107fa1f:	mov    0x2c8(%rsp),%rax
 107fa27:	mov    (%rax),%rsi
 107fa2a:	mov    0x8(%rax),%rdx
 107fa2e:	lea    0x3(%rdx,%rsi,1),%rcx
 107fa33:	add    %rsi,%rdx
 107fa36:	and    $0xfffffffffffffffc,%rcx
 107fa3a:	cmp    %rdx,%rcx
 107fa3d:	jae    107fa4d <check_input_run+0x126bd>
 107fa3f:	movq   $0x0,0xa0(%rsp)
 107fa4b:	jmp    107fa96 <check_input_run+0x12706>
 107fa4d:	mov    %rcx,%rdx
 107fa50:	sub    %rsi,%rdx
 107fa53:	mov    0x10(%rax),%rsi
 107fa57:	movq   $0x0,0xa0(%rsp)
 107fa63:	sub    %rdx,%rsi
 107fa66:	jb     107fa96 <check_input_run+0x12706>
 107fa68:	mov    0x860(%rsp),%rdi
 107fa70:	mov    0x8(%rdi),%rdi
 107fa74:	mov    0xa4(%rdi),%edi
 107fa7a:	lea    0x4(,%rdi,4),%rdi
 107fa82:	cmp    %rsi,%rdi
 107fa85:	ja     107fa96 <check_input_run+0x12706>
 107fa87:	add    %rdi,%rdx
 107fa8a:	mov    %rcx,0xa0(%rsp)
 107fa92:	mov    %rdx,0x8(%rax)
 107fa96:	cmpq   $0x0,0x600(%rsp)
 107fa9f:	je     107fac1 <check_input_run+0x12731>
 107faa1:	mov    0x2c8(%rsp),%rax
 107faa9:	mov    (%rax),%rsi
 107faac:	mov    0x8(%rax),%rdx
 107fab0:	lea    0x3(%rdx,%rsi,1),%rcx
 107fab5:	add    %rsi,%rdx
 107fab8:	and    $0xfffffffffffffffc,%rcx
 107fabc:	cmp    %rdx,%rcx
 107fabf:	jae    107facc <check_input_run+0x1273c>
 107fac1:	movq   $0x0,0x58(%rsp)
 107faca:	jmp    107fb0f <check_input_run+0x1277f>
 107facc:	mov    %rcx,%rdx
 107facf:	sub    %rsi,%rdx
 107fad2:	mov    0x10(%rax),%rsi
 107fad6:	movq   $0x0,0x58(%rsp)
 107fadf:	sub    %rdx,%rsi
 107fae2:	jb     107fb0f <check_input_run+0x1277f>
 107fae4:	mov    0x860(%rsp),%rdi
 107faec:	mov    0x8(%rdi),%rdi
 107faf0:	mov    0xa4(%rdi),%edi
 107faf6:	lea    0x4(,%rdi,4),%rdi
 107fafe:	cmp    %rsi,%rdi
 107fb01:	ja     107fb0f <check_input_run+0x1277f>
 107fb03:	add    %rdi,%rdx
 107fb06:	mov    %rcx,0x58(%rsp)
 107fb0b:	mov    %rdx,0x8(%rax)
 107fb0f:	cmpq   $0x0,0xa0(%rsp)
 107fb18:	je     107830e <check_input_run+0xaf7e>
 107fb1e:	cmpq   $0x0,0x58(%rsp)
 107fb24:	jne    107fb35 <check_input_run+0x127a5>
 107fb26:	cmpq   $0x0,0x600(%rsp)
 107fb2f:	jne    107830e <check_input_run+0xaf7e>
 107fb35:	mov    0x860(%rsp),%rax
 107fb3d:	mov    0xa0(%rsp),%rdi
 107fb45:	mov    $0xff,%esi
 107fb4a:	mov    0x8(%rax),%rax
 107fb4e:	mov    0xa4(%rax),%eax
 107fb54:	lea    0x4(,%rax,4),%rdx
 107fb5c:	vzeroupper
 107fb5f:	call   788430 <memset@plt>
 107fb64:	cmpq   $0x0,0x58(%rsp)
 107fb6a:	je     107fb92 <check_input_run+0x12802>
 107fb6c:	mov    0x860(%rsp),%rax
 107fb74:	mov    0x58(%rsp),%rdi
 107fb79:	xor    %esi,%esi
 107fb7b:	mov    0x8(%rax),%rax
 107fb7f:	mov    0xa4(%rax),%eax
 107fb85:	lea    0x4(,%rax,4),%rdx
 107fb8d:	call   788430 <memset@plt>
 107fb92:	mov    0xc8(%rsp),%rax
 107fb9a:	cmpl   $0x2,(%rax)
 107fb9d:	jb     107fc64 <check_input_run+0x128d4>
 107fba3:	mov    $0x1,%eax
 107fba8:	mov    0x5f0(%rsp),%rcx
 107fbb0:	cmpq   $0x0,0x50(%rsp)
 107fbb6:	mov    (%rcx,%rax,4),%ecx
 107fbb9:	je     107fbd9 <check_input_run+0x12849>
 107fbbb:	mov    0x50(%rsp),%rdx
 107fbc0:	mov    0x14(%rdx),%edi
 107fbc3:	mov    %rax,%rsi
 107fbc6:	sub    %rdi,%rsi
 107fbc9:	jae    107fbfc <check_input_run+0x1286c>
 107fbcb:	mov    0x8(%rdx),%rdx
 107fbcf:	test   %rdx,%rdx
 107fbd2:	jne    107fbc0 <check_input_run+0x12830>
 107fbd4:	mov    %rax,%rdx
 107fbd7:	jmp    107fc03 <check_input_run+0x12873>
 107fbd9:	mov    0xa0(%rsp),%rdx
 107fbe1:	cmpq   $0x0,0x58(%rsp)
 107fbe7:	mov    %ecx,(%rdx,%rax,4)
 107fbea:	je     107fc4e <check_input_run+0x128be>
 107fbec:	mov    0x600(%rsp),%rcx
 107fbf4:	mov    %rax,%rdx
 107fbf7:	mov    (%rcx,%rax,4),%ecx
 107fbfa:	jmp    107fc46 <check_input_run+0x128b6>
 107fbfc:	mov    0x20(%rdx),%rdx
 107fc00:	mov    (%rdx,%rsi,4),%edx
 107fc03:	mov    0xa0(%rsp),%rsi
 107fc0b:	cmpq   $0x0,0x58(%rsp)
 107fc11:	mov    %ecx,(%rsi,%rdx,4)
 107fc14:	je     107fc4e <check_input_run+0x128be>
 107fc16:	mov    0x600(%rsp),%rcx
 107fc1e:	mov    0x50(%rsp),%rdx
 107fc23:	mov    (%rcx,%rax,4),%ecx
 107fc26:	mov    0x14(%rdx),%edi
 107fc29:	mov    %rax,%rsi
 107fc2c:	sub    %rdi,%rsi
 107fc2f:	jae    107fc3f <check_input_run+0x128af>
 107fc31:	mov    0x8(%rdx),%rdx
 107fc35:	test   %rdx,%rdx
 107fc38:	jne    107fc26 <check_input_run+0x12896>
 107fc3a:	mov    %rax,%rdx
 107fc3d:	jmp    107fc46 <check_input_run+0x128b6>
 107fc3f:	mov    0x20(%rdx),%rdx
 107fc43:	mov    (%rdx,%rsi,4),%edx
 107fc46:	mov    0x58(%rsp),%rsi
 107fc4b:	mov    %ecx,(%rsi,%rdx,4)
 107fc4e:	mov    0xc8(%rsp),%rcx
 107fc56:	inc    %rax
 107fc59:	mov    (%rcx),%ecx
 107fc5b:	cmp    %rcx,%rax
 107fc5e:	jb     107fba8 <check_input_run+0x12818>
 107fc64:	cmpl   $0x0,0x60(%rsp)
 107fc69:	je     107fe4d <check_input_run+0x12abd>
 107fc6f:	cmpl   $0x1,0x60(%rsp)
 107fc74:	jne    107fc7d <check_input_run+0x128ed>
 107fc76:	xor    %eax,%eax
 107fc78:	jmp    107fdbc <check_input_run+0x12a2c>
 107fc7d:	mov    0x60(%rsp),%rcx
 107fc82:	and    $0xfffffffe,%ecx
 107fc85:	xor    %eax,%eax
 107fc87:	mov    0x1b0(%rsp),%rdx
 107fc8f:	imul   $0x150,%rax,%rdi
 107fc96:	lea    0x1(%rax),%rsi
 107fc9a:	mov    (%rdx),%rdx
 107fc9d:	mov    0x54(%rdx,%rdi,1),%r9d
 107fca2:	test   %r9d,%r9d
 107fca5:	je     107fd18 <check_input_run+0x12988>
 107fca7:	add    %rdi,%rdx
 107fcaa:	lea    (%rsi,%rsi,2),%rdi
 107fcae:	xor    %r8d,%r8d
 107fcb1:	shl    $0x4,%rdi
 107fcb5:	add    0x50(%rsp),%rdi
 107fcba:	mov    0x28(%rdi),%r10
 107fcbe:	cmpb   $0x0,(%r10,%r8,1)
 107fcc3:	jne    107fd0d <check_input_run+0x1297d>
 107fcc5:	mov    0xc8(%rsp),%r10
 107fccd:	mov    0x58(%rdx),%r9
 107fcd1:	mov    %rdi,%r11
 107fcd4:	mov    (%r10),%r10d
 107fcd7:	mov    (%r9,%r8,4),%r9d
 107fcdb:	add    %r8d,%r10d
 107fcde:	mov    %r10d,%r14d
 107fce1:	sub    0x14(%r11),%r14d
 107fce5:	jae    107fcf2 <check_input_run+0x12962>
 107fce7:	mov    0x8(%r11),%r11
 107fceb:	test   %r11,%r11
 107fcee:	jne    107fcde <check_input_run+0x1294e>
 107fcf0:	jmp    107fcfa <check_input_run+0x1296a>
 107fcf2:	mov    0x20(%r11),%r10
 107fcf6:	mov    (%r10,%r14,4),%r10d
 107fcfa:	mov    0xa0(%rsp),%r11
 107fd02:	mov    %r10d,%r10d
 107fd05:	mov    %r9d,(%r11,%r10,4)
 107fd09:	mov    0x54(%rdx),%r9d
 107fd0d:	inc    %r8
 107fd10:	mov    %r9d,%r10d
 107fd13:	cmp    %r10,%r8
 107fd16:	jb     107fcba <check_input_run+0x1292a>
 107fd18:	mov    0x1b0(%rsp),%rdx
 107fd20:	imul   $0x150,%rsi,%rsi
 107fd27:	add    $0x2,%rax
 107fd2b:	mov    (%rdx),%rdx
 107fd2e:	mov    0x54(%rdx,%rsi,1),%r8d
 107fd33:	test   %r8d,%r8d
 107fd36:	je     107fda8 <check_input_run+0x12a18>
 107fd38:	add    %rsi,%rdx
 107fd3b:	lea    (%rax,%rax,2),%rsi
 107fd3f:	xor    %edi,%edi
 107fd41:	shl    $0x4,%rsi
 107fd45:	add    0x50(%rsp),%rsi
 107fd4a:	mov    0x28(%rsi),%r9
 107fd4e:	cmpb   $0x0,(%r9,%rdi,1)
 107fd53:	jne    107fd9d <check_input_run+0x12a0d>
 107fd55:	mov    0xc8(%rsp),%r9
 107fd5d:	mov    0x58(%rdx),%r8
 107fd61:	mov    %rsi,%r10
 107fd64:	mov    (%r9),%r9d
 107fd67:	mov    (%r8,%rdi,4),%r8d
 107fd6b:	add    %edi,%r9d
 107fd6e:	mov    %r9d,%r11d
 107fd71:	sub    0x14(%r10),%r11d
 107fd75:	jae    107fd82 <check_input_run+0x129f2>
 107fd77:	mov    0x8(%r10),%r10
 107fd7b:	test   %r10,%r10
 107fd7e:	jne    107fd6e <check_input_run+0x129de>
 107fd80:	jmp    107fd8a <check_input_run+0x129fa>
 107fd82:	mov    0x20(%r10),%r9
 107fd86:	mov    (%r9,%r11,4),%r9d
 107fd8a:	mov    0xa0(%rsp),%r10
 107fd92:	mov    %r9d,%r9d
 107fd95:	mov    %r8d,(%r10,%r9,4)
 107fd99:	mov    0x54(%rdx),%r8d
 107fd9d:	inc    %rdi
 107fda0:	mov    %r8d,%r9d
 107fda3:	cmp    %r9,%rdi
 107fda6:	jb     107fd4a <check_input_run+0x129ba>
 107fda8:	cmp    %rcx,%rax
 107fdab:	jne    107fc87 <check_input_run+0x128f7>
 107fdb1:	testb  $0x1,0x60(%rsp)
 107fdb6:	je     107fe4d <check_input_run+0x12abd>
 107fdbc:	mov    0x1b0(%rsp),%rcx
 107fdc4:	imul   $0x150,%rax,%rdx
 107fdcb:	mov    (%rcx),%rcx
 107fdce:	mov    0x54(%rcx,%rdx,1),%edi
 107fdd2:	test   %edi,%edi
 107fdd4:	je     107fe4d <check_input_run+0x12abd>
 107fdd6:	mov    0x50(%rsp),%r8
 107fddb:	lea    (%rax,%rax,2),%rsi
 107fddf:	add    %rdx,%rcx
 107fde2:	shl    $0x4,%rsi
 107fde6:	lea    0x30(%r8,%rsi,1),%rdx
 107fdeb:	lea    (%r8,%rsi,1),%rax
 107fdef:	xor    %esi,%esi
 107fdf1:	mov    0x58(%rax),%r8
 107fdf5:	cmpb   $0x0,(%r8,%rsi,1)
 107fdfa:	jne    107fe42 <check_input_run+0x12ab2>
 107fdfc:	mov    0xc8(%rsp),%r8
 107fe04:	mov    0x58(%rcx),%rdi
 107fe08:	mov    %rdx,%r9
 107fe0b:	mov    (%r8),%r8d
 107fe0e:	mov    (%rdi,%rsi,4),%edi
 107fe11:	add    %esi,%r8d
 107fe14:	mov    %r8d,%r10d
 107fe17:	sub    0x14(%r9),%r10d
 107fe1b:	jae    107fe28 <check_input_run+0x12a98>
 107fe1d:	mov    0x8(%r9),%r9
 107fe21:	test   %r9,%r9
 107fe24:	jne    107fe14 <check_input_run+0x12a84>
 107fe26:	jmp    107fe30 <check_input_run+0x12aa0>
 107fe28:	mov    0x20(%r9),%r8
 107fe2c:	mov    (%r8,%r10,4),%r8d
 107fe30:	mov    0xa0(%rsp),%r9
 107fe38:	mov    %r8d,%r8d
 107fe3b:	mov    %edi,(%r9,%r8,4)
 107fe3f:	mov    0x54(%rcx),%edi
 107fe42:	inc    %rsi
 107fe45:	mov    %edi,%r8d
 107fe48:	cmp    %r8,%rsi
 107fe4b:	jb     107fdf1 <check_input_run+0x12a61>
 107fe4d:	mov    0x860(%rsp),%rax
 107fe55:	mov    0x2ac38(%rax),%rcx
 107fe5c:	mov    0x2ac40(%rax),%rax
 107fe63:	lea    0x3(%rax,%rcx,1),%rdx
 107fe68:	add    %rcx,%rax
 107fe6b:	and    $0xfffffffffffffffc,%rdx
 107fe6f:	mov    %rdx,0xc8(%rsp)
 107fe77:	cmp    %rax,%rdx
 107fe7a:	jb     107830e <check_input_run+0xaf7e>
 107fe80:	mov    0xc8(%rsp),%rax
 107fe88:	sub    %rcx,%rax
 107fe8b:	mov    0x860(%rsp),%rcx
 107fe93:	mov    0x2ac48(%rcx),%rcx
 107fe9a:	sub    %rax,%rcx
 107fe9d:	jb     107830e <check_input_run+0xaf7e>
 107fea3:	mov    0xe8(%rsp),%rdx
 107feab:	lea    0x4(,%rdx,4),%rdx
 107feb3:	cmp    %rcx,%rdx
 107feb6:	ja     107830e <check_input_run+0xaf7e>
 107febc:	add    %rdx,%rax
 107febf:	mov    0x860(%rsp),%rcx
 107fec7:	cmpq   $0x0,0xc8(%rsp)
 107fed0:	mov    %rax,0x2ac40(%rcx)
 107fed7:	je     107830e <check_input_run+0xaf7e>
 107fedd:	mov    0xc8(%rsp),%rdi
 107fee5:	xor    %esi,%esi
 107fee7:	call   788430 <memset@plt>
 107feec:	cmpl   $0x0,0x60(%rsp)
 107fef1:	je     1080070 <check_input_run+0x12ce0>
 107fef7:	cmpl   $0x1,0x60(%rsp)
 107fefc:	jne    107ff05 <check_input_run+0x12b75>
 107fefe:	xor    %eax,%eax
 107ff00:	jmp    1080002 <check_input_run+0x12c72>
 107ff05:	mov    0x60(%rsp),%rcx
 107ff0a:	and    $0xfffffffe,%ecx
 107ff0d:	xor    %eax,%eax
 107ff0f:	mov    0x860(%rsp),%rdx
 107ff17:	lea    (%rax,%rax,2),%rdi
 107ff1b:	shl    $0x4,%rdi
 107ff1f:	mov    0x1d0(%rdx),%rsi
 107ff26:	mov    (%rsi,%rdi,1),%edx
 107ff29:	cmp    0x4(%rsi,%rdi,1),%edx
 107ff2d:	ja     107ff4d <check_input_run+0x12bbd>
 107ff2f:	add    %rdi,%rsi
 107ff32:	lea    0x1(%rax),%edi
 107ff35:	mov    0xc8(%rsp),%r9
 107ff3d:	mov    %edx,%r8d
 107ff40:	inc    %edx
 107ff42:	mov    %edi,(%r9,%r8,4)
 107ff46:	cmp    0x4(%rsi),%edx
 107ff49:	jbe    107ff35 <check_input_run+0x12ba5>
 107ff4b:	mov    (%rsi),%edx
 107ff4d:	mov    0x580(%rsp),%rsi
 107ff55:	mov    %edx,%edx
 107ff57:	mov    (%rsi,%rdx,4),%esi
 107ff5a:	lea    0x1(%rax),%rdx
 107ff5e:	cmp    $0xffffffff,%esi
 107ff61:	je     107ff80 <check_input_run+0x12bf0>
 107ff63:	mov    0xc8(%rsp),%rdi
 107ff6b:	mov    %esi,%esi
 107ff6d:	mov    %edx,(%rdi,%rsi,4)
 107ff70:	mov    0x588(%rsp),%rdi
 107ff78:	mov    (%rdi,%rsi,4),%esi
 107ff7b:	cmp    $0xffffffff,%esi
 107ff7e:	jne    107ff63 <check_input_run+0x12bd3>
 107ff80:	mov    0x860(%rsp),%rsi
 107ff88:	lea    (%rdx,%rdx,2),%r8
 107ff8c:	shl    $0x4,%r8
 107ff90:	mov    0x1d0(%rsi),%rdi
 107ff97:	mov    (%rdi,%r8,1),%esi
 107ff9b:	cmp    0x4(%rdi,%r8,1),%esi
 107ffa0:	ja     107ffbf <check_input_run+0x12c2f>
 107ffa2:	add    %r8,%rdi
 107ffa5:	inc    %edx
 107ffa7:	mov    0xc8(%rsp),%r9
 107ffaf:	mov    %esi,%r8d
 107ffb2:	inc    %esi
 107ffb4:	mov    %edx,(%r9,%r8,4)
 107ffb8:	cmp    0x4(%rdi),%esi
 107ffbb:	jbe    107ffa7 <check_input_run+0x12c17>
 107ffbd:	mov    (%rdi),%esi
 107ffbf:	mov    0x580(%rsp),%rdx
 107ffc7:	mov    %esi,%esi
 107ffc9:	add    $0x2,%rax
 107ffcd:	mov    (%rdx,%rsi,4),%edx
 107ffd0:	cmp    $0xffffffff,%edx
 107ffd3:	je     107fff2 <check_input_run+0x12c62>
 107ffd5:	mov    0xc8(%rsp),%rsi
 107ffdd:	mov    %edx,%edx
 107ffdf:	mov    %eax,(%rsi,%rdx,4)
 107ffe2:	mov    0x588(%rsp),%rsi
 107ffea:	mov    (%rsi,%rdx,4),%edx
 107ffed:	cmp    $0xffffffff,%edx
 107fff0:	jne    107ffd5 <check_input_run+0x12c45>
 107fff2:	cmp    %rcx,%rax
 107fff5:	jne    107ff0f <check_input_run+0x12b7f>
 107fffb:	testb  $0x1,0x60(%rsp)
 1080000:	je     1080070 <check_input_run+0x12ce0>
 1080002:	mov    0x860(%rsp),%rcx
 108000a:	lea    (%rax,%rax,2),%rsi
 108000e:	shl    $0x4,%rsi
 1080012:	mov    0x1d0(%rcx),%rdx
 1080019:	mov    (%rdx,%rsi,1),%ecx
 108001c:	cmp    0x4(%rdx,%rsi,1),%ecx
 1080020:	ja     108003f <check_input_run+0x12caf>
 1080022:	mov    0xc8(%rsp),%r8
 108002a:	add    %rsi,%rdx
 108002d:	lea    0x1(%rax),%esi
 1080030:	mov    %ecx,%edi
 1080032:	mov    %esi,(%r8,%rdi,4)
 1080036:	inc    %ecx
 1080038:	cmp    0x4(%rdx),%ecx
 108003b:	jbe    1080030 <check_input_run+0x12ca0>
 108003d:	mov    (%rdx),%ecx
 108003f:	mov    0x580(%rsp),%rdx
 1080047:	mov    %ecx,%ecx
 1080049:	mov    (%rdx,%rcx,4),%ecx
 108004c:	cmp    $0xffffffff,%ecx
 108004f:	je     1080070 <check_input_run+0x12ce0>
 1080051:	inc    %eax
 1080053:	mov    0xc8(%rsp),%rdx
 108005b:	mov    %ecx,%ecx
 108005d:	mov    %eax,(%rdx,%rcx,4)
 1080060:	mov    0x588(%rsp),%rdx
 1080068:	mov    (%rdx,%rcx,4),%ecx
 108006b:	cmp    $0xffffffff,%ecx
 108006e:	jne    1080053 <check_input_run+0x12cc3>
 1080070:	mov    0x28(%rsp),%rbx
 1080075:	mov    $0xffffffff,%ecx
 108007a:	cmp    $0x1,%ebx
 108007d:	adc    $0x0,%ebx
 1080080:	xor    %eax,%eax
 1080082:	xor    %edx,%edx
 1080084:	mov    0xc8(%rsp),%rsi
 108008c:	mov    0xb8(%rsp),%r9
 1080094:	mov    $0x0,%r11d
 108009a:	mov    (%rsi,%rdx,4),%edi
 108009d:	mov    0x240(%r9),%r9
 10800a4:	cmp    $0x1,%edi
 10800a7:	mov    %edi,%esi
 10800a9:	mov    %edi,%r8d
 10800ac:	mov    (%r9,%rdx,4),%r10d
 10800b0:	adc    $0x0,%esi
 10800b3:	sub    $0x1,%r8d
 10800b7:	cmovb  %eax,%esi
 10800ba:	lea    (%rsi,%rsi,2),%rsi
 10800be:	shl    $0x4,%rsi
 10800c2:	add    0x50(%rsp),%rsi
 10800c7:	test   %r10d,%r10d
 10800ca:	je     1080102 <check_input_run+0x12d72>
 10800cc:	mov    %r10d,%r11d
 10800cf:	shr    $0x3,%r11d
 10800d3:	cmpq   $0x0,0x50(%rsp)
 10800d9:	je     10800fa <check_input_run+0x12d6a>
 10800db:	mov    %rsi,%r14
 10800de:	mov    %r11d,%r15d
 10800e1:	sub    0x10(%r14),%r15d
 10800e5:	jae    10800f2 <check_input_run+0x12d62>
 10800e7:	mov    0x8(%r14),%r14
 10800eb:	test   %r14,%r14
 10800ee:	jne    10800de <check_input_run+0x12d4e>
 10800f0:	jmp    10800fa <check_input_run+0x12d6a>
 10800f2:	mov    0x18(%r14),%r11
 10800f6:	mov    (%r11,%r15,4),%r11d
 10800fa:	and    $0x7,%r10d
 10800fe:	lea    (%r10,%r11,8),%r11d
 1080102:	mov    %r11d,(%r9,%rdx,4)
 1080106:	mov    $0x0,%ebp
 108010b:	xor    %r9d,%r9d
 108010e:	mov    0x348(%rsp),%r10
 1080116:	mov    (%r10,%rdx,4),%r11d
 108011a:	test   %r11d,%r11d
 108011d:	je     1080155 <check_input_run+0x12dc5>
 108011f:	mov    %r11d,%r14d
 1080122:	shr    $0x3,%r14d
 1080126:	cmpq   $0x0,0x50(%rsp)
 108012c:	je     108014d <check_input_run+0x12dbd>
 108012e:	mov    %rsi,%r15
 1080131:	mov    %r14d,%r12d
 1080134:	sub    0x10(%r15),%r12d
 1080138:	jae    1080145 <check_input_run+0x12db5>
 108013a:	mov    0x8(%r15),%r15
 108013e:	test   %r15,%r15
 1080141:	jne    1080131 <check_input_run+0x12da1>
 1080143:	jmp    108014d <check_input_run+0x12dbd>
 1080145:	mov    0x18(%r15),%r14
 1080149:	mov    (%r14,%r12,4),%r14d
 108014d:	and    $0x7,%r11d
 1080151:	lea    (%r11,%r14,8),%ebp
 1080155:	mov    %ebp,(%r10,%rdx,4)
 1080159:	mov    0x398(%rsp),%r10
 1080161:	mov    (%r10,%rdx,4),%r11d
 1080165:	test   %r11d,%r11d
 1080168:	je     10801a0 <check_input_run+0x12e10>
 108016a:	mov    %r11d,%r9d
 108016d:	shr    $0x3,%r9d
 1080171:	cmpq   $0x0,0x50(%rsp)
 1080177:	je     1080198 <check_input_run+0x12e08>
 1080179:	mov    %rsi,%r14
 108017c:	mov    %r9d,%r15d
 108017f:	sub    0x10(%r14),%r15d
 1080183:	jae    1080190 <check_input_run+0x12e00>
 1080185:	mov    0x8(%r14),%r14
 1080189:	test   %r14,%r14
 108018c:	jne    108017c <check_input_run+0x12dec>
 108018e:	jmp    1080198 <check_input_run+0x12e08>
 1080190:	mov    0x18(%r14),%r9
 1080194:	mov    (%r9,%r15,4),%r9d
 1080198:	and    $0x7,%r11d
 108019c:	lea    (%r11,%r9,8),%r9d
 10801a0:	mov    %r9d,(%r10,%rdx,4)
 10801a4:	mov    $0x0,%ebp
 10801a9:	xor    %r9d,%r9d
 10801ac:	mov    0x408(%rsp),%r10
 10801b4:	mov    (%r10,%rdx,4),%r11d
 10801b8:	test   %r11d,%r11d
 10801bb:	je     10801f3 <check_input_run+0x12e63>
 10801bd:	mov    %r11d,%r14d
 10801c0:	shr    $0x3,%r14d
 10801c4:	cmpq   $0x0,0x50(%rsp)
 10801ca:	je     10801eb <check_input_run+0x12e5b>
 10801cc:	mov    %rsi,%r15
 10801cf:	mov    %r14d,%r12d
 10801d2:	sub    0x10(%r15),%r12d
 10801d6:	jae    10801e3 <check_input_run+0x12e53>
 10801d8:	mov    0x8(%r15),%r15
 10801dc:	test   %r15,%r15
 10801df:	jne    10801cf <check_input_run+0x12e3f>
 10801e1:	jmp    10801eb <check_input_run+0x12e5b>
 10801e3:	mov    0x18(%r15),%r14
 10801e7:	mov    (%r14,%r12,4),%r14d
 10801eb:	and    $0x7,%r11d
 10801ef:	lea    (%r11,%r14,8),%ebp
 10801f3:	mov    %ebp,(%r10,%rdx,4)
 10801f7:	mov    0x450(%rsp),%r10
 10801ff:	mov    (%r10,%rdx,4),%r11d
 1080203:	test   %r11d,%r11d
 1080206:	je     108023e <check_input_run+0x12eae>
 1080208:	mov    %r11d,%r9d
 108020b:	shr    $0x3,%r9d
 108020f:	cmpq   $0x0,0x50(%rsp)
 1080215:	je     1080236 <check_input_run+0x12ea6>
 1080217:	mov    %rsi,%r14
 108021a:	mov    %r9d,%r15d
 108021d:	sub    0x10(%r14),%r15d
 1080221:	jae    108022e <check_input_run+0x12e9e>
 1080223:	mov    0x8(%r14),%r14
 1080227:	test   %r14,%r14
 108022a:	jne    108021a <check_input_run+0x12e8a>
 108022c:	jmp    1080236 <check_input_run+0x12ea6>
 108022e:	mov    0x18(%r14),%r9
 1080232:	mov    (%r9,%r15,4),%r9d
 1080236:	and    $0x7,%r11d
 108023a:	lea    (%r11,%r9,8),%r9d
 108023e:	mov    %r9d,(%r10,%rdx,4)
 1080242:	mov    $0x0,%ebp
 1080247:	xor    %r9d,%r9d
 108024a:	mov    0x5d0(%rsp),%r10
 1080252:	mov    (%r10,%rdx,4),%r11d
 1080256:	test   %r11d,%r11d
 1080259:	je     1080291 <check_input_run+0x12f01>
 108025b:	mov    %r11d,%r14d
 108025e:	shr    $0x3,%r14d
 1080262:	cmpq   $0x0,0x50(%rsp)
 1080268:	je     1080289 <check_input_run+0x12ef9>
 108026a:	mov    %rsi,%r15
 108026d:	mov    %r14d,%r12d
 1080270:	sub    0x10(%r15),%r12d
 1080274:	jae    1080281 <check_input_run+0x12ef1>
 1080276:	mov    0x8(%r15),%r15
 108027a:	test   %r15,%r15
 108027d:	jne    108026d <check_input_run+0x12edd>
 108027f:	jmp    1080289 <check_input_run+0x12ef9>
 1080281:	mov    0x18(%r15),%r14
 1080285:	mov    (%r14,%r12,4),%r14d
 1080289:	and    $0x7,%r11d
 108028d:	lea    (%r11,%r14,8),%ebp
 1080291:	mov    %ebp,(%r10,%rdx,4)
 1080295:	mov    0x530(%rsp),%r10
 108029d:	mov    (%r10,%rdx,4),%r11d
 10802a1:	test   %r11d,%r11d
 10802a4:	je     10802dc <check_input_run+0x12f4c>
 10802a6:	mov    %r11d,%r9d
 10802a9:	shr    $0x3,%r9d
 10802ad:	cmpq   $0x0,0x50(%rsp)
 10802b3:	je     10802d4 <check_input_run+0x12f44>
 10802b5:	mov    %rsi,%r14
 10802b8:	mov    %r9d,%r15d
 10802bb:	sub    0x10(%r14),%r15d
 10802bf:	jae    10802cc <check_input_run+0x12f3c>
 10802c1:	mov    0x8(%r14),%r14
 10802c5:	test   %r14,%r14
 10802c8:	jne    10802b8 <check_input_run+0x12f28>
 10802ca:	jmp    10802d4 <check_input_run+0x12f44>
 10802cc:	mov    0x18(%r14),%r9
 10802d0:	mov    (%r9,%r15,4),%r9d
 10802d4:	and    $0x7,%r11d
 10802d8:	lea    (%r11,%r9,8),%r9d
 10802dc:	mov    %r9d,(%r10,%rdx,4)
 10802e0:	test   %edi,%edi
 10802e2:	je     1080331 <check_input_run+0x12fa1>
 10802e4:	mov    0xa8(%rsp),%r14
 10802ec:	mov    %r8d,%edi
 10802ef:	mov    0x80(%rsp),%r15
 10802f7:	mov    0x198(%rsp),%r8
 10802ff:	mov    (%r14,%rdi,4),%r11d
 1080303:	mov    0x1a0(%rsp),%r14
 108030b:	mov    (%r15,%rdi,4),%ebp
 108030f:	mov    0xf8(%rsp),%r15
 1080317:	mov    (%r8,%rdi,4),%r8d
 108031b:	mov    (%r14,%rdi,4),%r9d
 108031f:	mov    0x180(%rsp),%r14
 1080327:	mov    (%r15,%rdi,4),%r10d
 108032b:	mov    (%r14,%rdi,4),%edi
 108032f:	jmp    1080341 <check_input_run+0x12fb1>
 1080331:	xor    %r8d,%r8d
 1080334:	xor    %r10d,%r10d
 1080337:	xor    %ebp,%ebp
 1080339:	xor    %r11d,%r11d
 108033c:	xor    %r9d,%r9d
 108033f:	xor    %edi,%edi
 1080341:	mov    0x418(%rsp),%r14
 1080349:	mov    (%r14,%rdx,4),%r15d
 108034d:	cmp    %rcx,%r15
 1080350:	je     1080360 <check_input_run+0x12fd0>
 1080352:	cmp    0x68(%rsp),%r15d
 1080357:	jae    1080367 <check_input_run+0x12fd7>
 1080359:	mov    0x0(%r13,%r15,4),%ebp
 108035e:	jmp    108036e <check_input_run+0x12fde>
 1080360:	mov    $0xffffffff,%ebp
 1080365:	jmp    108036e <check_input_run+0x12fde>
 1080367:	sub    0x68(%rsp),%ebp
 108036b:	add    %r15d,%ebp
 108036e:	mov    %ebp,(%r14,%rdx,4)
 1080372:	mov    0xb8(%rsp),%r14
 108037a:	mov    $0x0,%r12d
 1080380:	xor    %ebp,%ebp
 1080382:	mov    0x320(%r14),%r14
 1080389:	mov    (%r14,%rdx,4),%r15d
 108038d:	test   %r15d,%r15d
 1080390:	je     10803c1 <check_input_run+0x13031>
 1080392:	dec    %r15d
 1080395:	cmp    0x98(%rsp),%r15d
 108039d:	jae    10803b0 <check_input_run+0x13020>
 108039f:	mov    %r15d,%r11d
 10803a2:	mov    0x110(%rsp),%r15
 10803aa:	mov    (%r15,%r11,4),%r12d
 10803ae:	jmp    10803be <check_input_run+0x1302e>
 10803b0:	sub    0x98(%rsp),%r11d
 10803b8:	add    %r15d,%r11d
 10803bb:	mov    %r11d,%r12d
 10803be:	inc    %r12d
 10803c1:	mov    %r12d,(%r14,%rdx,4)
 10803c5:	mov    0x4e8(%rsp),%r11
 10803cd:	mov    (%r11,%rdx,4),%r14d
 10803d1:	test   %r14d,%r14d
 10803d4:	je     1080403 <check_input_run+0x13073>
 10803d6:	dec    %r14d
 10803d9:	cmp    0xd8(%rsp),%r14d
 10803e1:	jae    10803f4 <check_input_run+0x13064>
 10803e3:	mov    0x88(%rsp),%r15
 10803eb:	mov    %r14d,%r14d
 10803ee:	mov    (%r15,%r14,4),%ebp
 10803f2:	jmp    1080401 <check_input_run+0x13071>
 10803f4:	mov    %r10d,%ebp
 10803f7:	sub    0xd8(%rsp),%ebp
 10803fe:	add    %r14d,%ebp
 1080401:	inc    %ebp
 1080403:	mov    %ebp,(%r11,%rdx,4)
 1080407:	mov    $0x0,%r15d
 108040d:	xor    %r11d,%r11d
 1080410:	mov    0x4f0(%rsp),%r14
 1080418:	mov    (%r14,%rdx,4),%ebp
 108041c:	test   %ebp,%ebp
 108041e:	je     108044d <check_input_run+0x130bd>
 1080420:	dec    %ebp
 1080422:	cmp    0xd8(%rsp),%ebp
 1080429:	jae    108043c <check_input_run+0x130ac>
 108042b:	mov    0x88(%rsp),%r15
 1080433:	mov    %ebp,%r10d
 1080436:	mov    (%r15,%r10,4),%r15d
 108043a:	jmp    108044a <check_input_run+0x130ba>
 108043c:	sub    0xd8(%rsp),%r10d
 1080444:	add    %ebp,%r10d
 1080447:	mov    %r10d,%r15d
 108044a:	inc    %r15d
 108044d:	mov    0xb8(%rsp),%r10
 1080455:	mov    %r15d,(%r14,%rdx,4)
 1080459:	mov    0x350(%r10),%r10
 1080460:	mov    (%r10,%rdx,4),%ebp
 1080464:	test   %ebp,%ebp
 1080466:	je     108048f <check_input_run+0x130ff>
 1080468:	dec    %ebp
 108046a:	cmp    0x70(%rsp),%ebp
 108046e:	jae    1080481 <check_input_run+0x130f1>
 1080470:	mov    0x150(%rsp),%r11
 1080478:	mov    %ebp,%r9d
 108047b:	mov    (%r11,%r9,4),%r11d
 108047f:	jmp    108048c <check_input_run+0x130fc>
 1080481:	sub    0x70(%rsp),%r9d
 1080486:	add    %ebp,%r9d
 1080489:	mov    %r9d,%r11d
 108048c:	inc    %r11d
 108048f:	mov    %r11d,(%r10,%rdx,4)
 1080493:	mov    $0x0,%ebp
 1080498:	xor    %r9d,%r9d
 108049b:	mov    0x4d0(%rsp),%r10
 10804a3:	mov    (%r10,%rdx,4),%r11d
 10804a7:	test   %r11d,%r11d
 10804aa:	je     10804d9 <check_input_run+0x13149>
 10804ac:	dec    %r11d
 10804af:	cmp    0xc0(%rsp),%r11d
 10804b7:	jae    10804ca <check_input_run+0x1313a>
 10804b9:	mov    0x118(%rsp),%r14
 10804c1:	mov    %r11d,%r11d
 10804c4:	mov    (%r14,%r11,4),%ebp
 10804c8:	jmp    10804d7 <check_input_run+0x13147>
 10804ca:	mov    %r8d,%ebp
 10804cd:	sub    0xc0(%rsp),%ebp
 10804d4:	add    %r11d,%ebp
 10804d7:	inc    %ebp
 10804d9:	mov    %ebp,(%r10,%rdx,4)
 10804dd:	mov    0x4d8(%rsp),%r10
 10804e5:	mov    (%r10,%rdx,4),%r11d
 10804e9:	test   %r11d,%r11d
 10804ec:	je     108051d <check_input_run+0x1318d>
 10804ee:	dec    %r11d
 10804f1:	cmp    0xc0(%rsp),%r11d
 10804f9:	jae    108050c <check_input_run+0x1317c>
 10804fb:	mov    0x118(%rsp),%r9
 1080503:	mov    %r11d,%r8d
 1080506:	mov    (%r9,%r8,4),%r9d
 108050a:	jmp    108051a <check_input_run+0x1318a>
 108050c:	sub    0xc0(%rsp),%r8d
 1080514:	add    %r11d,%r8d
 1080517:	mov    %r8d,%r9d
 108051a:	inc    %r9d
 108051d:	mov    %r9d,(%r10,%rdx,4)
 1080521:	mov    0x460(%rsp),%r8
 1080529:	mov    (%r8,%rdx,4),%r9d
 108052d:	test   %r9d,%r9d
 1080530:	je     1080550 <check_input_run+0x131c0>
 1080532:	dec    %r9d
 1080535:	cmp    0x100(%rsp),%r9d
 108053d:	jae    1080554 <check_input_run+0x131c4>
 108053f:	mov    0x148(%rsp),%r10
 1080547:	mov    %r9d,%edi
 108054a:	mov    (%r10,%rdi,4),%edi
 108054e:	jmp    108055e <check_input_run+0x131ce>
 1080550:	xor    %edi,%edi
 1080552:	jmp    1080560 <check_input_run+0x131d0>
 1080554:	sub    0x100(%rsp),%edi
 108055b:	add    %r9d,%edi
 108055e:	inc    %edi
 1080560:	mov    %edi,(%r8,%rdx,4)
 1080564:	mov    0x358(%rsp),%rdi
 108056c:	mov    (%rdi,%rdx,8),%rdi
 1080570:	test   %rdi,%rdi
 1080573:	je     1080605 <check_input_run+0x13275>
 1080579:	mov    0x24(%rdi),%r9d
 108057d:	mov    $0x0,%r10d
 1080583:	xor    %r8d,%r8d
 1080586:	test   %r9d,%r9d
 1080589:	je     10805c1 <check_input_run+0x13231>
 108058b:	mov    %r9d,%r10d
 108058e:	shr    $0x3,%r10d
 1080592:	cmpq   $0x0,0x50(%rsp)
 1080598:	je     10805b9 <check_input_run+0x13229>
 108059a:	mov    %rsi,%r11
 108059d:	mov    %r10d,%r14d
 10805a0:	sub    0x10(%r11),%r14d
 10805a4:	jae    10805b1 <check_input_run+0x13221>
 10805a6:	mov    0x8(%r11),%r11
 10805aa:	test   %r11,%r11
 10805ad:	jne    108059d <check_input_run+0x1320d>
 10805af:	jmp    10805b9 <check_input_run+0x13229>
 10805b1:	mov    0x18(%r11),%r10
 10805b5:	mov    (%r10,%r14,4),%r10d
 10805b9:	and    $0x7,%r9d
 10805bd:	lea    (%r9,%r10,8),%r10d
 10805c1:	mov    %r10d,0x24(%rdi)
 10805c5:	mov    0x28(%rdi),%r9d
 10805c9:	test   %r9d,%r9d
 10805cc:	je     1080601 <check_input_run+0x13271>
 10805ce:	mov    %r9d,%r8d
 10805d1:	shr    $0x3,%r8d
 10805d5:	cmpq   $0x0,0x50(%rsp)
 10805db:	je     10805f9 <check_input_run+0x13269>
 10805dd:	mov    %r8d,%r10d
 10805e0:	sub    0x10(%rsi),%r10d
 10805e4:	jae    10805f1 <check_input_run+0x13261>
 10805e6:	mov    0x8(%rsi),%rsi
 10805ea:	test   %rsi,%rsi
 10805ed:	jne    10805dd <check_input_run+0x1324d>
 10805ef:	jmp    10805f9 <check_input_run+0x13269>
 10805f1:	mov    0x18(%rsi),%rsi
 10805f5:	mov    (%rsi,%r10,4),%r8d
 10805f9:	and    $0x7,%r9d
 10805fd:	lea    (%r9,%r8,8),%r8d
 1080601:	mov    %r8d,0x28(%rdi)
 1080605:	inc    %rdx
 1080608:	cmp    %rbx,%rdx
 108060b:	jne    1080084 <check_input_run+0x12cf4>
 1080611:	cmpl   $0x0,0x2d8(%rsp)
 1080619:	je     1080677 <check_input_run+0x132e7>
 108061b:	xor    %eax,%eax
 108061d:	mov    0x5c8(%rsp),%rcx
 1080625:	mov    $0x0,%esi
 108062a:	mov    (%rcx,%rax,4),%edx
 108062d:	test   %edx,%edx
 108062f:	je     1080665 <check_input_run+0x132d5>
 1080631:	mov    %edx,%esi
 1080633:	shr    $0x3,%esi
 1080636:	cmpq   $0x0,0x50(%rsp)
 108063c:	je     108065f <check_input_run+0x132cf>
 108063e:	mov    0x50(%rsp),%rdi
 1080643:	mov    %esi,%r8d
 1080646:	sub    0x10(%rdi),%r8d
 108064a:	jae    1080657 <check_input_run+0x132c7>
 108064c:	mov    0x8(%rdi),%rdi
 1080650:	test   %rdi,%rdi
 1080653:	jne    1080643 <check_input_run+0x132b3>
 1080655:	jmp    108065f <check_input_run+0x132cf>
 1080657:	mov    0x18(%rdi),%rsi
 108065b:	mov    (%rsi,%r8,4),%esi
 108065f:	and    $0x7,%edx
 1080662:	lea    (%rdx,%rsi,8),%esi
 1080665:	mov    %esi,(%rcx,%rax,4)
 1080668:	inc    %rax
 108066b:	mov    0x2d8(%rsp),%ecx
 1080672:	cmp    %rcx,%rax
 1080675:	jb     108061d <check_input_run+0x1328d>
 1080677:	mov    0x60(%rsp),%rcx
 108067c:	xor    %edx,%edx
 108067e:	lea    -0x1(%rcx),%rax
 1080682:	and    $0xfffffffe,%ecx
 1080685:	mov    0x690(%rsp,%rdx,4),%esi
 108068c:	mov    $0x0,%r8d
 1080692:	test   %esi,%esi
 1080694:	je     10806cb <check_input_run+0x1333b>
 1080696:	mov    %esi,%edi
 1080698:	shr    $0x3,%edi
 108069b:	cmpq   $0x0,0x50(%rsp)
 10806a1:	je     10806c4 <check_input_run+0x13334>
 10806a3:	mov    0x50(%rsp),%r8
 10806a8:	mov    %edi,%r9d
 10806ab:	sub    0x10(%r8),%r9d
 10806af:	jae    10806bc <check_input_run+0x1332c>
 10806b1:	mov    0x8(%r8),%r8
 10806b5:	test   %r8,%r8
 10806b8:	jne    10806a8 <check_input_run+0x13318>
 10806ba:	jmp    10806c4 <check_input_run+0x13334>
 10806bc:	mov    0x18(%r8),%rdi
 10806c0:	mov    (%rdi,%r9,4),%edi
 10806c4:	and    $0x7,%esi
 10806c7:	lea    (%rsi,%rdi,8),%r8d
 10806cb:	mov    0x6d0(%rsp,%rdx,4),%r9d
 10806d3:	cmpl   $0x0,0x60(%rsp)
 10806d8:	je     1080856 <check_input_run+0x134c6>
 10806de:	mov    0x1b0(%rsp),%rsi
 10806e6:	xor    %edi,%edi
 10806e8:	mov    (%rsi),%rsi
 10806eb:	test   %rax,%rax
 10806ee:	je     10807ea <check_input_run+0x1345a>
 10806f4:	imul   $0x150,%rdi,%r10
 10806fb:	add    %rsi,%r10
 10806fe:	mov    0x11c(%r10,%rdx,4),%r10d
 1080706:	test   %r10d,%r10d
 1080709:	je     1080763 <check_input_run+0x133d3>
 108070b:	mov    0x860(%rsp),%r11
 1080713:	lea    (%rdi,%rdi,2),%r14
 1080717:	shl    $0x4,%r14
 108071b:	mov    0x1d0(%r11),%r11
 1080722:	mov    (%r11,%r14,1),%r11d
 1080726:	cmp    %r9d,%r11d
 1080729:	jae    1080763 <check_input_run+0x133d3>
 108072b:	mov    0x50(%rsp),%r8
 1080730:	lea    0x30(%r8,%r14,1),%r9
 1080735:	mov    %r10d,%r8d
 1080738:	shr    $0x3,%r8d
 108073c:	mov    %r8d,%r14d
 108073f:	sub    0x10(%r9),%r14d
 1080743:	jae    1080750 <check_input_run+0x133c0>
 1080745:	mov    0x8(%r9),%r9
 1080749:	test   %r9,%r9
 108074c:	jne    108073c <check_input_run+0x133ac>
 108074e:	jmp    1080758 <check_input_run+0x133c8>
 1080750:	mov    0x18(%r9),%r8
 1080754:	mov    (%r8,%r14,4),%r8d
 1080758:	and    $0x7,%r10d
 108075c:	mov    %r11d,%r9d
 108075f:	lea    (%r10,%r8,8),%r8d
 1080763:	lea    0x1(%rdi),%r11
 1080767:	imul   $0x150,%r11,%r10
 108076e:	add    %rsi,%r10
 1080771:	mov    0x11c(%r10,%rdx,4),%r10d
 1080779:	test   %r10d,%r10d
 108077c:	je     10807d6 <check_input_run+0x13446>
 108077e:	mov    0x860(%rsp),%r14
 1080786:	mov    0x1d0(%r14),%r15
 108078d:	lea    (%r11,%r11,2),%r14
 1080791:	shl    $0x4,%r14
 1080795:	mov    (%r15,%r14,1),%r11d
 1080799:	cmp    %r9d,%r11d
 108079c:	jae    10807d6 <check_input_run+0x13446>
 108079e:	mov    0x50(%rsp),%r8
 10807a3:	lea    0x30(%r8,%r14,1),%r9
 10807a8:	mov    %r10d,%r8d
 10807ab:	shr    $0x3,%r8d
 10807af:	mov    %r8d,%r14d
 10807b2:	sub    0x10(%r9),%r14d
 10807b6:	jae    10807c3 <check_input_run+0x13433>
 10807b8:	mov    0x8(%r9),%r9
 10807bc:	test   %r9,%r9
 10807bf:	jne    10807af <check_input_run+0x1341f>
 10807c1:	jmp    10807cb <check_input_run+0x1343b>
 10807c3:	mov    0x18(%r9),%r8
 10807c7:	mov    (%r8,%r14,4),%r8d
 10807cb:	and    $0x7,%r10d
 10807cf:	mov    %r11d,%r9d
 10807d2:	lea    (%r10,%r8,8),%r8d
 10807d6:	add    $0x2,%rdi
 10807da:	cmp    %rcx,%rdi
 10807dd:	jne    10806f4 <check_input_run+0x13364>
 10807e3:	testb  $0x1,0x60(%rsp)
 10807e8:	je     1080856 <check_input_run+0x134c6>
 10807ea:	imul   $0x150,%rdi,%r10
 10807f1:	add    %r10,%rsi
 10807f4:	mov    0x11c(%rsi,%rdx,4),%esi
 10807fb:	test   %esi,%esi
 10807fd:	je     1080856 <check_input_run+0x134c6>
 10807ff:	mov    0x860(%rsp),%r10
 1080807:	mov    0x1d0(%r10),%r11
 108080e:	lea    (%rdi,%rdi,2),%r10
 1080812:	shl    $0x4,%r10
 1080816:	mov    (%r11,%r10,1),%edi
 108081a:	cmp    %r9d,%edi
 108081d:	jae    1080856 <check_input_run+0x134c6>
 108081f:	mov    0x50(%rsp),%r8
 1080824:	lea    0x30(%r8,%r10,1),%r9
 1080829:	mov    %esi,%r8d
 108082c:	shr    $0x3,%r8d
 1080830:	mov    %r8d,%r10d
 1080833:	sub    0x10(%r9),%r10d
 1080837:	jae    1080844 <check_input_run+0x134b4>
 1080839:	mov    0x8(%r9),%r9
 108083d:	test   %r9,%r9
 1080840:	jne    1080830 <check_input_run+0x134a0>
 1080842:	jmp    108084c <check_input_run+0x134bc>
 1080844:	mov    0x18(%r9),%r8
 1080848:	mov    (%r8,%r10,4),%r8d
 108084c:	and    $0x7,%esi
 108084f:	mov    %edi,%r9d
 1080852:	lea    (%rsi,%r8,8),%r8d
 1080856:	mov    %r8d,0x690(%rsp,%rdx,4)
 108085e:	mov    %r9d,0x6d0(%rsp,%rdx,4)
 1080866:	inc    %rdx
 1080869:	cmp    $0x5,%rdx
 108086d:	jne    1080685 <check_input_run+0x132f5>
 1080873:	mov    0x384(%rsp),%esi
 108087a:	mov    $0xffffffff,%edx
 108087f:	mov    $0xffffffff,%ecx
 1080884:	mov    $0xffffffff,%edi
 1080889:	cmp    %rdx,%rsi
 108088c:	je     1080893 <check_input_run+0x13503>
 108088e:	mov    0x0(%r13,%rsi,4),%edi
 1080893:	mov    %edi,0x384(%rsp)
 108089a:	mov    0x388(%rsp),%esi
 10808a1:	cmp    %rdx,%rsi
 10808a4:	je     10808ab <check_input_run+0x1351b>
 10808a6:	mov    0x0(%r13,%rsi,4),%ecx
 10808ab:	mov    %ecx,0x388(%rsp)
 10808b2:	mov    0x38c(%rsp),%ecx
 10808b9:	cmp    %rdx,%rcx
 10808bc:	je     10808c5 <check_input_run+0x13535>
 10808be:	mov    0x0(%r13,%rcx,4),%ecx
 10808c3:	jmp    10808ca <check_input_run+0x1353a>
 10808c5:	mov    $0xffffffff,%ecx
 10808ca:	mov    0xb8(%rsp),%rdx
 10808d2:	mov    %ecx,0x38c(%rsp)
 10808d9:	cmpl   $0x0,0x200(%rdx)
 10808e0:	je     1080a11 <check_input_run+0x13681>
 10808e6:	xor    %ecx,%ecx
 10808e8:	mov    0xb8(%rsp),%rdx
 10808f0:	imul   $0x130,%rcx,%rsi
 10808f7:	mov    $0x0,%r8d
 10808fd:	mov    0x1f8(%rdx),%rdx
 1080904:	mov    0xc(%rdx,%rsi,1),%edi
 1080908:	test   %edi,%edi
 108090a:	je     1080943 <check_input_run+0x135b3>
 108090c:	mov    %edi,%r8d
 108090f:	shr    $0x3,%r8d
 1080913:	cmpq   $0x0,0x50(%rsp)
 1080919:	je     108093c <check_input_run+0x135ac>
 108091b:	mov    0x50(%rsp),%r9
 1080920:	mov    %r8d,%r10d
 1080923:	sub    0x10(%r9),%r10d
 1080927:	jae    1080934 <check_input_run+0x135a4>
 1080929:	mov    0x8(%r9),%r9
 108092d:	test   %r9,%r9
 1080930:	jne    1080920 <check_input_run+0x13590>
 1080932:	jmp    108093c <check_input_run+0x135ac>
 1080934:	mov    0x18(%r9),%r8
 1080938:	mov    (%r8,%r10,4),%r8d
 108093c:	and    $0x7,%edi
 108093f:	lea    (%rdi,%r8,8),%r8d
 1080943:	add    %rsi,%rdx
 1080946:	mov    %r8d,0xc(%rdx)
 108094a:	mov    0x10(%rdx),%esi
 108094d:	test   %esi,%esi
 108094f:	je     1080977 <check_input_run+0x135e7>
 1080951:	mov    %esi,%edi
 1080953:	shr    $0x3,%edi
 1080956:	cmpq   $0x0,0x50(%rsp)
 108095c:	je     1080983 <check_input_run+0x135f3>
 108095e:	mov    0x50(%rsp),%r8
 1080963:	mov    %edi,%r9d
 1080966:	sub    0x10(%r8),%r9d
 108096a:	jae    108097b <check_input_run+0x135eb>
 108096c:	mov    0x8(%r8),%r8
 1080970:	test   %r8,%r8
 1080973:	jne    1080963 <check_input_run+0x135d3>
 1080975:	jmp    1080983 <check_input_run+0x135f3>
 1080977:	xor    %esi,%esi
 1080979:	jmp    1080989 <check_input_run+0x135f9>
 108097b:	mov    0x18(%r8),%rdi
 108097f:	mov    (%rdi,%r9,4),%edi
 1080983:	and    $0x7,%esi
 1080986:	lea    (%rsi,%rdi,8),%esi
 1080989:	mov    %esi,0x10(%rdx)
 108098c:	cmpl   $0x0,0x114(%rdx)
 1080993:	je     10809f7 <check_input_run+0x13667>
 1080995:	xor    %esi,%esi
 1080997:	mov    0x14(%rdx,%rsi,4),%edi
 108099b:	test   %edi,%edi
 108099d:	je     10809c7 <check_input_run+0x13637>
 108099f:	mov    %edi,%r8d
 10809a2:	shr    $0x3,%r8d
 10809a6:	cmpq   $0x0,0x50(%rsp)
 10809ac:	je     10809d3 <check_input_run+0x13643>
 10809ae:	mov    0x50(%rsp),%r9
 10809b3:	mov    %r8d,%r10d
 10809b6:	sub    0x10(%r9),%r10d
 10809ba:	jae    10809cb <check_input_run+0x1363b>
 10809bc:	mov    0x8(%r9),%r9
 10809c0:	test   %r9,%r9
 10809c3:	jne    10809b3 <check_input_run+0x13623>
 10809c5:	jmp    10809d3 <check_input_run+0x13643>
 10809c7:	xor    %edi,%edi
 10809c9:	jmp    10809da <check_input_run+0x1364a>
 10809cb:	mov    0x18(%r9),%r8
 10809cf:	mov    (%r8,%r10,4),%r8d
 10809d3:	and    $0x7,%edi
 10809d6:	lea    (%rdi,%r8,8),%edi
 10809da:	mov    %edi,0x14(%rdx,%rsi,4)
 10809de:	lea    0x1(%rsi),%rdi
 10809e2:	mov    0x114(%rdx),%r8d
 10809e9:	cmp    %r8,%rdi
 10809ec:	jae    10809f7 <check_input_run+0x13667>
 10809ee:	cmp    $0x3f,%rsi
 10809f2:	mov    %rdi,%rsi
 10809f5:	jb     1080997 <check_input_run+0x13607>
 10809f7:	mov    0xb8(%rsp),%rdx
 10809ff:	inc    %rcx
 1080a02:	mov    0x200(%rdx),%edx
 1080a08:	cmp    %rdx,%rcx
 1080a0b:	jb     10808e8 <check_input_run+0x13558>
 1080a11:	mov    0xb8(%rsp),%rcx
 1080a19:	mov    0x178(%rsp),%rdx
 1080a21:	mov    0x1f8(%rsp),%rsi
 1080a29:	mov    0x160(%rsp),%rdi
 1080a31:	cmpq   $0x0,0x58(%rsp)
 1080a37:	mov    %rdx,0x358(%rcx)
 1080a3e:	mov    0xb0(%rsp),%rdx
 1080a46:	mov    %edx,0x360(%rcx)
 1080a4c:	mov    0xe0(%rsp),%rdx
 1080a54:	mov    %rsi,0x318(%rcx)
 1080a5b:	mov    0x1f0(%rsp),%rsi
 1080a63:	mov    %edx,0x328(%rcx)
 1080a69:	mov    0x108(%rsp),%rdx
 1080a71:	mov    %rdi,0x330(%rcx)
 1080a78:	mov    %edx,0x338(%rcx)
 1080a7e:	mov    0x128(%rsp),%rdx
 1080a86:	mov    %rsi,0x340(%rcx)
 1080a8d:	mov    %edx,0x348(%rcx)
 1080a93:	jne    1080aa2 <check_input_run+0x13712>
 1080a95:	mov    0x600(%rsp),%rcx
 1080a9d:	mov    %rcx,0x58(%rsp)
 1080aa2:	mov    0x208(%rsp),%rcx
 1080aaa:	mov    0x140(%rsp),%rsi
 1080ab2:	mov    0xa0(%rsp),%rdx
 1080aba:	cmpl   $0x0,0x60(%rsp)
 1080abf:	mov    %rcx,0x4c8(%rsp)
 1080ac7:	mov    0x120(%rsp),%rcx
 1080acf:	mov    %ecx,0x4e0(%rsp)
 1080ad6:	mov    0x268(%rsp),%rcx
 1080ade:	mov    %rsi,0x458(%rsp)
 1080ae6:	mov    0x58(%rsp),%rsi
 1080aeb:	mov    %ecx,0x468(%rsp)
 1080af2:	mov    %rdx,0x5f0(%rsp)
 1080afa:	mov    0x860(%rsp),%rdx
 1080b02:	mov    %rsi,0x600(%rsp)
 1080b0a:	mov    0x8(%rdx),%rcx
 1080b0e:	mov    %rcx,0x2b8(%rsp)
 1080b16:	movl   $0xffffffff,0x65c(%rsp)
 1080b21:	movl   $0x0,0x654(%rsp)
 1080b2c:	je     1080e1f <check_input_run+0x13a8f>
 1080b32:	mov    0x410(%rsp),%ecx
 1080b39:	test   %rax,%rax
 1080b3c:	je     1080d31 <check_input_run+0x139a1>
 1080b42:	mov    0x80(%rsp),%rax
 1080b4a:	mov    0x60(%rsp),%rdx
 1080b4f:	and    $0xfffffffe,%edx
 1080b52:	mov    $0xffffffff,%edi
 1080b57:	xor    %r8d,%r8d
 1080b5a:	lea    0x4(%rax),%rsi
 1080b5e:	xor    %eax,%eax
 1080b60:	mov    0x1b0(%rsp),%r9
 1080b68:	mov    (%r9),%r9
 1080b6b:	mov    0x148(%r9,%r8,1),%r10d
 1080b73:	cmp    %ecx,%r10d
 1080b76:	cmova  %r10d,%ecx
 1080b7a:	mov    %ecx,0x410(%rsp)
 1080b81:	mov    0x138(%r9,%r8,1),%r10d
 1080b89:	cmp    $0xffffffff,%r10d
 1080b8d:	je     1080c3a <check_input_run+0x138aa>
 1080b93:	mov    %r10d,0x390(%rsp)
 1080b9b:	mov    $0xffffffff,%r10d
 1080ba1:	mov    $0xffffffff,%ebp
 1080ba6:	mov    0x13c(%r9,%r8,1),%r11d
 1080bae:	cmp    %rdi,%r11
 1080bb1:	je     1080bce <check_input_run+0x1383e>
 1080bb3:	cmp    0x68(%rsp),%r11d
 1080bb8:	jae    1080bc1 <check_input_run+0x13831>
 1080bba:	mov    0x0(%r13,%r11,4),%ebp
 1080bbf:	jmp    1080bce <check_input_run+0x1383e>
 1080bc1:	sub    0x68(%rsp),%r11d
 1080bc6:	add    -0x4(%rsi,%rax,4),%r11d
 1080bcb:	mov    %r11d,%ebp
 1080bce:	mov    %ebp,0x378(%rsp)
 1080bd5:	mov    0x140(%r9,%r8,1),%r11d
 1080bdd:	cmp    %rdi,%r11
 1080be0:	je     1080bfd <check_input_run+0x1386d>
 1080be2:	cmp    0x68(%rsp),%r11d
 1080be7:	jae    1080bf0 <check_input_run+0x13860>
 1080be9:	mov    0x0(%r13,%r11,4),%r10d
 1080bee:	jmp    1080bfd <check_input_run+0x1386d>
 1080bf0:	sub    0x68(%rsp),%r11d
 1080bf5:	add    -0x4(%rsi,%rax,4),%r11d
 1080bfa:	mov    %r11d,%r10d
 1080bfd:	mov    %r10d,0x37c(%rsp)
 1080c05:	mov    0x144(%r9,%r8,1),%r9d
 1080c0d:	cmp    %rdi,%r9
 1080c10:	je     1080c20 <check_input_run+0x13890>
 1080c12:	cmp    0x68(%rsp),%r9d
 1080c17:	jae    1080c28 <check_input_run+0x13898>
 1080c19:	mov    0x0(%r13,%r9,4),%r9d
 1080c1e:	jmp    1080c32 <check_input_run+0x138a2>
 1080c20:	mov    $0xffffffff,%r9d
 1080c26:	jmp    1080c32 <check_input_run+0x138a2>
 1080c28:	sub    0x68(%rsp),%r9d
 1080c2d:	add    -0x4(%rsi,%rax,4),%r9d
 1080c32:	mov    %r9d,0x380(%rsp)
 1080c3a:	mov    0x1b0(%rsp),%r9
 1080c42:	mov    (%r9),%r9
 1080c45:	mov    0x298(%r9,%r8,1),%r10d
 1080c4d:	cmp    %ecx,%r10d
 1080c50:	cmova  %r10d,%ecx
 1080c54:	mov    %ecx,0x410(%rsp)
 1080c5b:	mov    0x288(%r9,%r8,1),%r10d
 1080c63:	cmp    $0xffffffff,%r10d
 1080c67:	je     1080d11 <check_input_run+0x13981>
 1080c6d:	mov    %r10d,0x390(%rsp)
 1080c75:	mov    $0xffffffff,%r10d
 1080c7b:	mov    $0xffffffff,%ebp
 1080c80:	mov    0x28c(%r9,%r8,1),%r11d
 1080c88:	cmp    %rdi,%r11
 1080c8b:	je     1080ca7 <check_input_run+0x13917>
 1080c8d:	cmp    0x68(%rsp),%r11d
 1080c92:	jae    1080c9b <check_input_run+0x1390b>
 1080c94:	mov    0x0(%r13,%r11,4),%ebp
 1080c99:	jmp    1080ca7 <check_input_run+0x13917>
 1080c9b:	sub    0x68(%rsp),%r11d
 1080ca0:	add    (%rsi,%rax,4),%r11d
 1080ca4:	mov    %r11d,%ebp
 1080ca7:	mov    %ebp,0x378(%rsp)
 1080cae:	mov    0x290(%r9,%r8,1),%r11d
 1080cb6:	cmp    %rdi,%r11
 1080cb9:	je     1080cd5 <check_input_run+0x13945>
 1080cbb:	cmp    0x68(%rsp),%r11d
 1080cc0:	jae    1080cc9 <check_input_run+0x13939>
 1080cc2:	mov    0x0(%r13,%r11,4),%r10d
 1080cc7:	jmp    1080cd5 <check_input_run+0x13945>
 1080cc9:	sub    0x68(%rsp),%r11d
 1080cce:	add    (%rsi,%rax,4),%r11d
 1080cd2:	mov    %r11d,%r10d
 1080cd5:	mov    %r10d,0x37c(%rsp)
 1080cdd:	mov    0x294(%r9,%r8,1),%r9d
 1080ce5:	cmp    %rdi,%r9
 1080ce8:	je     1080cf8 <check_input_run+0x13968>
 1080cea:	cmp    0x68(%rsp),%r9d
 1080cef:	jae    1080d00 <check_input_run+0x13970>
 1080cf1:	mov    0x0(%r13,%r9,4),%r9d
 1080cf6:	jmp    1080d09 <check_input_run+0x13979>
 1080cf8:	mov    $0xffffffff,%r9d
 1080cfe:	jmp    1080d09 <check_input_run+0x13979>
 1080d00:	sub    0x68(%rsp),%r9d
 1080d05:	add    (%rsi,%rax,4),%r9d
 1080d09:	mov    %r9d,0x380(%rsp)
 1080d11:	add    $0x2,%rax
 1080d15:	add    $0x2a0,%r8
 1080d1c:	cmp    %rax,%rdx
 1080d1f:	jne    1080b60 <check_input_run+0x137d0>
 1080d25:	testb  $0x1,0x60(%rsp)
 1080d2a:	jne    1080d33 <check_input_run+0x139a3>
 1080d2c:	jmp    1080e1f <check_input_run+0x13a8f>
 1080d31:	xor    %eax,%eax
 1080d33:	mov    0x1b0(%rsp),%rdx
 1080d3b:	imul   $0x150,%rax,%rsi
 1080d42:	mov    (%rdx),%rdx
 1080d45:	mov    0x148(%rdx,%rsi,1),%edi
 1080d4c:	cmp    %ecx,%edi
 1080d4e:	cmova  %edi,%ecx
 1080d51:	mov    %ecx,0x410(%rsp)
 1080d58:	mov    0x138(%rdx,%rsi,1),%ecx
 1080d5f:	cmp    $0xffffffff,%ecx
 1080d62:	je     1080e1f <check_input_run+0x13a8f>
 1080d68:	add    %rsi,%rdx
 1080d6b:	mov    %ecx,0x390(%rsp)
 1080d72:	mov    $0xffffffff,%esi
 1080d77:	mov    $0xffffffff,%ecx
 1080d7c:	mov    $0xffffffff,%r8d
 1080d82:	mov    0x13c(%rdx),%edi
 1080d88:	cmp    %rsi,%rdi
 1080d8b:	je     1080dad <check_input_run+0x13a1d>
 1080d8d:	cmp    0x68(%rsp),%edi
 1080d91:	jae    1080d9a <check_input_run+0x13a0a>
 1080d93:	mov    0x0(%r13,%rdi,4),%r8d
 1080d98:	jmp    1080dad <check_input_run+0x13a1d>
 1080d9a:	mov    0x80(%rsp),%r8
 1080da2:	sub    0x68(%rsp),%edi
 1080da6:	add    (%r8,%rax,4),%edi
 1080daa:	mov    %edi,%r8d
 1080dad:	mov    %r8d,0x378(%rsp)
 1080db5:	mov    0x140(%rdx),%edi
 1080dbb:	cmp    %rsi,%rdi
 1080dbe:	je     1080dde <check_input_run+0x13a4e>
 1080dc0:	cmp    0x68(%rsp),%edi
 1080dc4:	jae    1080dcd <check_input_run+0x13a3d>
 1080dc6:	mov    0x0(%r13,%rdi,4),%ecx
 1080dcb:	jmp    1080dde <check_input_run+0x13a4e>
 1080dcd:	mov    0x80(%rsp),%rcx
 1080dd5:	sub    0x68(%rsp),%edi
 1080dd9:	add    (%rcx,%rax,4),%edi
 1080ddc:	mov    %edi,%ecx
 1080dde:	mov    %ecx,0x37c(%rsp)
 1080de5:	mov    0x144(%rdx),%ecx
 1080deb:	mov    $0xffffffff,%edx
 1080df0:	cmp    %rdx,%rcx
 1080df3:	je     1080e02 <check_input_run+0x13a72>
 1080df5:	cmp    0x68(%rsp),%ecx
 1080df9:	jae    1080e09 <check_input_run+0x13a79>
 1080dfb:	mov    0x0(%r13,%rcx,4),%ecx
 1080e00:	jmp    1080e18 <check_input_run+0x13a88>
 1080e02:	mov    $0xffffffff,%ecx
 1080e07:	jmp    1080e18 <check_input_run+0x13a88>
 1080e09:	mov    0x80(%rsp),%rdx
 1080e11:	sub    0x68(%rsp),%ecx
 1080e15:	add    (%rdx,%rax,4),%ecx
 1080e18:	mov    %ecx,0x380(%rsp)
 1080e1f:	mov    0xb8(%rsp),%rax
 1080e27:	movl   $0x0,0x210(%rsp)
 1080e32:	movq   $0x0,0x1f0(%rax)
 1080e3d:	jmp    107830e <check_input_run+0xaf7e>
