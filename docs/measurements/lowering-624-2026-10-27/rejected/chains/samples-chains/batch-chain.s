
chains/build/compiler:     file format elf64-x86-64


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

00000000008d95f0 <check_lower_batch_chain>:
  8d95f0:	55                   	push   %rbp
  8d95f1:	41 57                	push   %r15
  8d95f3:	41 56                	push   %r14
  8d95f5:	41 55                	push   %r13
  8d95f7:	41 54                	push   %r12
  8d95f9:	53                   	push   %rbx
  8d95fa:	48 81 ec 38 01 00 00 	sub    $0x138,%rsp
  8d9601:	64 48 8b 04 25 28 00 	mov    %fs:0x28,%rax
  8d9608:	00 00 
  8d960a:	89 f1                	mov    %esi,%ecx
  8d960c:	48 89 84 24 30 01 00 	mov    %rax,0x130(%rsp)
  8d9613:	00 
  8d9614:	48 8b 2f             	mov    (%rdi),%rbp
  8d9617:	4c 8b 6d 00          	mov    0x0(%rbp),%r13
  8d961b:	4c 8b 65 08          	mov    0x8(%rbp),%r12
  8d961f:	49 8b 45 00          	mov    0x0(%r13),%rax
  8d9623:	44 8b 04 88          	mov    (%rax,%rcx,4),%r8d
  8d9627:	45 85 c0             	test   %r8d,%r8d
  8d962a:	0f 84 c7 01 00 00    	je     8d97f7 <check_lower_batch_chain+0x207>
  8d9630:	4d 8b 4c 24 08       	mov    0x8(%r12),%r9
  8d9635:	4c 8d 14 49          	lea    (%rcx,%rcx,2),%r10
  8d9639:	49 c1 e2 05          	shl    $0x5,%r10
  8d963d:	43 83 7c 11 0c 00    	cmpl   $0x0,0xc(%r9,%r10,1)
  8d9643:	74 23                	je     8d9668 <check_lower_batch_chain+0x78>
  8d9645:	4d 01 d1             	add    %r10,%r9
  8d9648:	41 83 79 54 00       	cmpl   $0x0,0x54(%r9)
  8d964d:	75 19                	jne    8d9668 <check_lower_batch_chain+0x78>
  8d964f:	45 0f b7 51 08       	movzwl 0x8(%r9),%r10d
  8d9654:	41 f7 c2 10 08 00 00 	test   $0x810,%r10d
  8d965b:	75 0b                	jne    8d9668 <check_lower_batch_chain+0x78>
  8d965d:	41 83 79 04 00       	cmpl   $0x0,0x4(%r9)
  8d9662:	0f 84 c4 02 00 00    	je     8d992c <check_lower_batch_chain+0x33c>
  8d9668:	41 83 f8 34          	cmp    $0x34,%r8d
  8d966c:	0f 87 e5 08 00 00    	ja     8d9f57 <check_lower_batch_chain+0x967>
  8d9672:	49 b9 02 00 00 01 12 	movabs $0x10001201000002,%r9
  8d9679:	00 10 00 
  8d967c:	45 89 c0             	mov    %r8d,%r8d
  8d967f:	4d 0f a3 c1          	bt     %r8,%r9
  8d9683:	0f 83 ce 08 00 00    	jae    8d9f57 <check_lower_batch_chain+0x967>
  8d9689:	85 f6                	test   %esi,%esi
  8d968b:	0f 84 c6 08 00 00    	je     8d9f57 <check_lower_batch_chain+0x967>
  8d9691:	4d 8b 45 10          	mov    0x10(%r13),%r8
  8d9695:	45 8b 04 88          	mov    (%r8,%rcx,4),%r8d
  8d9699:	41 ff c0             	inc    %r8d
  8d969c:	41 39 f0             	cmp    %esi,%r8d
  8d969f:	0f 85 b2 08 00 00    	jne    8d9f57 <check_lower_batch_chain+0x967>
  8d96a5:	8d 5e ff             	lea    -0x1(%rsi),%ebx
  8d96a8:	41 89 da             	mov    %ebx,%r10d
  8d96ab:	46 8b 04 90          	mov    (%rax,%r10,4),%r8d
  8d96af:	45 85 c0             	test   %r8d,%r8d
  8d96b2:	0f 84 69 02 00 00    	je     8d9921 <check_lower_batch_chain+0x331>
  8d96b8:	4d 8b 5c 24 08       	mov    0x8(%r12),%r11
  8d96bd:	4f 8d 34 52          	lea    (%r10,%r10,2),%r14
  8d96c1:	49 c1 e6 05          	shl    $0x5,%r14
  8d96c5:	43 83 7c 33 0c 00    	cmpl   $0x0,0xc(%r11,%r14,1)
  8d96cb:	74 23                	je     8d96f0 <check_lower_batch_chain+0x100>
  8d96cd:	4d 01 f3             	add    %r14,%r11
  8d96d0:	41 83 7b 54 00       	cmpl   $0x0,0x54(%r11)
  8d96d5:	75 19                	jne    8d96f0 <check_lower_batch_chain+0x100>
  8d96d7:	45 0f b7 73 08       	movzwl 0x8(%r11),%r14d
  8d96dc:	41 f7 c6 10 08 00 00 	test   $0x810,%r14d
  8d96e3:	75 0b                	jne    8d96f0 <check_lower_batch_chain+0x100>
  8d96e5:	41 83 7b 04 00       	cmpl   $0x0,0x4(%r11)
  8d96ea:	0f 84 2f 08 00 00    	je     8d9f1f <check_lower_batch_chain+0x92f>
  8d96f0:	41 83 f8 34          	cmp    $0x34,%r8d
  8d96f4:	0f 87 5d 08 00 00    	ja     8d9f57 <check_lower_batch_chain+0x967>
  8d96fa:	45 89 c0             	mov    %r8d,%r8d
  8d96fd:	4d 0f a3 c1          	bt     %r8,%r9
  8d9701:	0f 83 50 08 00 00    	jae    8d9f57 <check_lower_batch_chain+0x967>
  8d9707:	85 db                	test   %ebx,%ebx
  8d9709:	0f 84 48 08 00 00    	je     8d9f57 <check_lower_batch_chain+0x967>
  8d970f:	4d 8b 45 10          	mov    0x10(%r13),%r8
  8d9713:	8d 5e fe             	lea    -0x2(%rsi),%ebx
  8d9716:	43 39 1c 90          	cmp    %ebx,(%r8,%r10,4)
  8d971a:	0f 85 37 08 00 00    	jne    8d9f57 <check_lower_batch_chain+0x967>
  8d9720:	41 89 da             	mov    %ebx,%r10d
  8d9723:	46 8b 04 90          	mov    (%rax,%r10,4),%r8d
  8d9727:	45 85 c0             	test   %r8d,%r8d
  8d972a:	0f 84 2a 02 00 00    	je     8d995a <check_lower_batch_chain+0x36a>
  8d9730:	4d 8b 5c 24 08       	mov    0x8(%r12),%r11
  8d9735:	4f 8d 34 52          	lea    (%r10,%r10,2),%r14
  8d9739:	49 c1 e6 05          	shl    $0x5,%r14
  8d973d:	43 83 7c 33 0c 00    	cmpl   $0x0,0xc(%r11,%r14,1)
  8d9743:	74 23                	je     8d9768 <check_lower_batch_chain+0x178>
  8d9745:	4d 01 f3             	add    %r14,%r11
  8d9748:	41 83 7b 54 00       	cmpl   $0x0,0x54(%r11)
  8d974d:	75 19                	jne    8d9768 <check_lower_batch_chain+0x178>
  8d974f:	45 0f b7 73 08       	movzwl 0x8(%r11),%r14d
  8d9754:	41 f7 c6 10 08 00 00 	test   $0x810,%r14d
  8d975b:	75 0b                	jne    8d9768 <check_lower_batch_chain+0x178>
  8d975d:	41 83 7b 04 00       	cmpl   $0x0,0x4(%r11)
  8d9762:	0f 84 cd 07 00 00    	je     8d9f35 <check_lower_batch_chain+0x945>
  8d9768:	41 83 f8 34          	cmp    $0x34,%r8d
  8d976c:	0f 87 e5 07 00 00    	ja     8d9f57 <check_lower_batch_chain+0x967>
  8d9772:	45 89 c0             	mov    %r8d,%r8d
  8d9775:	4d 0f a3 c1          	bt     %r8,%r9
  8d9779:	0f 83 d8 07 00 00    	jae    8d9f57 <check_lower_batch_chain+0x967>
  8d977f:	85 db                	test   %ebx,%ebx
  8d9781:	0f 84 d0 07 00 00    	je     8d9f57 <check_lower_batch_chain+0x967>
  8d9787:	4d 8b 45 10          	mov    0x10(%r13),%r8
  8d978b:	8d 5e fd             	lea    -0x3(%rsi),%ebx
  8d978e:	43 39 1c 90          	cmp    %ebx,(%r8,%r10,4)
  8d9792:	0f 85 bf 07 00 00    	jne    8d9f57 <check_lower_batch_chain+0x967>
  8d9798:	41 89 da             	mov    %ebx,%r10d
  8d979b:	46 8b 04 90          	mov    (%rax,%r10,4),%r8d
  8d979f:	45 85 c0             	test   %r8d,%r8d
  8d97a2:	0f 84 82 07 00 00    	je     8d9f2a <check_lower_batch_chain+0x93a>
  8d97a8:	4d 8b 4c 24 08       	mov    0x8(%r12),%r9
  8d97ad:	4f 8d 14 52          	lea    (%r10,%r10,2),%r10
  8d97b1:	49 c1 e2 05          	shl    $0x5,%r10
  8d97b5:	43 83 7c 11 0c 00    	cmpl   $0x0,0xc(%r9,%r10,1)
  8d97bb:	0f 84 96 07 00 00    	je     8d9f57 <check_lower_batch_chain+0x967>
  8d97c1:	4d 01 d1             	add    %r10,%r9
  8d97c4:	41 83 79 54 00       	cmpl   $0x0,0x54(%r9)
  8d97c9:	0f 85 88 07 00 00    	jne    8d9f57 <check_lower_batch_chain+0x967>
  8d97cf:	45 0f b7 51 08       	movzwl 0x8(%r9),%r10d
  8d97d4:	41 f7 c2 10 08 00 00 	test   $0x810,%r10d
  8d97db:	0f 85 76 07 00 00    	jne    8d9f57 <check_lower_batch_chain+0x967>
  8d97e1:	41 83 79 04 00       	cmpl   $0x0,0x4(%r9)
  8d97e6:	0f 85 6b 07 00 00    	jne    8d9f57 <check_lower_batch_chain+0x967>
  8d97ec:	41 be 04 00 00 00    	mov    $0x4,%r14d
  8d97f2:	e9 3d 01 00 00       	jmp    8d9934 <check_lower_batch_chain+0x344>
  8d97f7:	41 be 01 00 00 00    	mov    $0x1,%r14d
  8d97fd:	89 f3                	mov    %esi,%ebx
  8d97ff:	41 83 fe 02          	cmp    $0x2,%r14d
  8d9803:	41 89 d0             	mov    %edx,%r8d
  8d9806:	41 0f 93 c7          	setae  %r15b
  8d980a:	45 20 f8             	and    %r15b,%r8b
  8d980d:	41 80 f8 01          	cmp    $0x1,%r8b
  8d9811:	75 23                	jne    8d9836 <check_lower_batch_chain+0x246>
  8d9813:	44 8b 87 40 01 00 00 	mov    0x140(%rdi),%r8d
  8d981a:	41 b9 00 00 00 01    	mov    $0x1000000,%r9d
  8d9820:	41 81 f8 00 00 00 01 	cmp    $0x1000000,%r8d
  8d9827:	45 0f 42 c8          	cmovb  %r8d,%r9d
  8d982b:	83 3c 88 21          	cmpl   $0x21,(%rax,%rcx,4)
  8d982f:	74 2a                	je     8d985b <check_lower_batch_chain+0x26b>
  8d9831:	e9 21 07 00 00       	jmp    8d9f57 <check_lower_batch_chain+0x967>
  8d9836:	44 8b 87 40 01 00 00 	mov    0x140(%rdi),%r8d
  8d983d:	41 b9 00 00 00 01    	mov    $0x1000000,%r9d
  8d9843:	41 b7 01             	mov    $0x1,%r15b
  8d9846:	41 81 f8 00 00 00 01 	cmp    $0x1000000,%r8d
  8d984d:	45 0f 42 c8          	cmovb  %r8d,%r9d
  8d9851:	41 83 fe 02          	cmp    $0x2,%r14d
  8d9855:	0f 82 fc 06 00 00    	jb     8d9f57 <check_lower_batch_chain+0x967>
  8d985b:	44 2b 8f 38 01 00 00 	sub    0x138(%rdi),%r9d
  8d9862:	0f 82 ef 06 00 00    	jb     8d9f57 <check_lower_batch_chain+0x967>
  8d9868:	42 8d 04 b5 00 00 00 	lea    0x0(,%r14,4),%eax
  8d986f:	00 
  8d9870:	44 39 c8             	cmp    %r9d,%eax
  8d9873:	0f 87 de 06 00 00    	ja     8d9f57 <check_lower_batch_chain+0x967>
  8d9879:	44 2b 87 3c 01 00 00 	sub    0x13c(%rdi),%r8d
  8d9880:	0f 82 d1 06 00 00    	jb     8d9f57 <check_lower_batch_chain+0x967>
  8d9886:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
  8d988a:	c5 f9 7f 84 24 e0 00 	vmovdqa %xmm0,0xe0(%rsp)
  8d9891:	00 00 
  8d9893:	c5 f9 7f 84 24 d0 00 	vmovdqa %xmm0,0xd0(%rsp)
  8d989a:	00 00 
  8d989c:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
  8d98a0:	62 f1 fe 48 7f 84 24 	vmovdqu64 %zmm0,0x90(%rsp)
  8d98a7:	90 00 00 00 
  8d98ab:	62 f1 fe 48 7f 84 24 	vmovdqu64 %zmm0,0x50(%rsp)
  8d98b2:	50 00 00 00 
  8d98b6:	44 39 c0             	cmp    %r8d,%eax
  8d98b9:	0f 83 98 06 00 00    	jae    8d9f57 <check_lower_batch_chain+0x967>
  8d98bf:	48 89 7c 24 30       	mov    %rdi,0x30(%rsp)
  8d98c4:	48 89 74 24 10       	mov    %rsi,0x10(%rsp)
  8d98c9:	89 54 24 3c          	mov    %edx,0x3c(%rsp)
  8d98cd:	89 de                	mov    %ebx,%esi
  8d98cf:	44 89 f2             	mov    %r14d,%edx
  8d98d2:	48 8b 7c 24 30       	mov    0x30(%rsp),%rdi
  8d98d7:	e8 24 07 00 00       	call   8da000 <check_lower_batch_classify>
  8d98dc:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  8d98e1:	62 f1 fe 48 7f 84 24 	vmovdqu64 %zmm0,0xf0(%rsp)
  8d98e8:	f0 00 00 00 
  8d98ec:	c5 f9 7e c2          	vmovd  %xmm0,%edx
  8d98f0:	48 8b 38             	mov    (%rax),%rdi
  8d98f3:	48 8b 47 08          	mov    0x8(%rdi),%rax
  8d98f7:	48 8b 70 08          	mov    0x8(%rax),%rsi
  8d98fb:	89 d8                	mov    %ebx,%eax
  8d98fd:	48 8d 0c 40          	lea    (%rax,%rax,2),%rcx
  8d9901:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  8d9906:	48 c1 e1 05          	shl    $0x5,%rcx
  8d990a:	44 8b 44 0e 40       	mov    0x40(%rsi,%rcx,1),%r8d
  8d990f:	4d 85 c0             	test   %r8,%r8
  8d9912:	74 51                	je     8d9965 <check_lower_batch_chain+0x375>
  8d9914:	44 3b 87 c0 00 00 00 	cmp    0xc0(%rdi),%r8d
  8d991b:	41 0f 92 c3          	setb   %r11b
  8d991f:	eb 47                	jmp    8d9968 <check_lower_batch_chain+0x378>
  8d9921:	41 be 02 00 00 00    	mov    $0x2,%r14d
  8d9927:	e9 d3 fe ff ff       	jmp    8d97ff <check_lower_batch_chain+0x20f>
  8d992c:	41 be 01 00 00 00    	mov    $0x1,%r14d
  8d9932:	89 f3                	mov    %esi,%ebx
  8d9934:	41 83 f8 3e          	cmp    $0x3e,%r8d
  8d9938:	0f 87 c1 fe ff ff    	ja     8d97ff <check_lower_batch_chain+0x20f>
  8d993e:	49 b9 00 00 00 00 08 	movabs $0x4080000800000000,%r9
  8d9945:	00 80 40 
  8d9948:	45 89 c0             	mov    %r8d,%r8d
  8d994b:	4d 0f a3 c1          	bt     %r8,%r9
  8d994f:	0f 82 02 06 00 00    	jb     8d9f57 <check_lower_batch_chain+0x967>
  8d9955:	e9 a5 fe ff ff       	jmp    8d97ff <check_lower_batch_chain+0x20f>
  8d995a:	41 be 03 00 00 00    	mov    $0x3,%r14d
  8d9960:	e9 9a fe ff ff       	jmp    8d97ff <check_lower_batch_chain+0x20f>
  8d9965:	45 31 db             	xor    %r11d,%r11d
  8d9968:	44 0f b6 d2          	movzbl %dl,%r10d
  8d996c:	89 54 24 0c          	mov    %edx,0xc(%rsp)
  8d9970:	45 8d 4a ff          	lea    -0x1(%r10),%r9d
  8d9974:	41 83 f9 0a          	cmp    $0xa,%r9d
  8d9978:	0f 93 c0             	setae  %al
  8d997b:	f7 c2 00 05 00 00    	test   $0x500,%edx
  8d9981:	0f 95 c2             	setne  %dl
  8d9984:	08 c2                	or     %al,%dl
  8d9986:	0f 85 cb 05 00 00    	jne    8d9f57 <check_lower_batch_chain+0x967>
  8d998c:	48 01 ce             	add    %rcx,%rsi
  8d998f:	83 7e 44 00          	cmpl   $0x0,0x44(%rsi)
  8d9993:	0f 85 be 05 00 00    	jne    8d9f57 <check_lower_batch_chain+0x967>
  8d9999:	48 8b 07             	mov    (%rdi),%rax
  8d999c:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
  8d99a1:	48 8b 08             	mov    (%rax),%rcx
  8d99a4:	8b 0c 91             	mov    (%rcx,%rdx,4),%ecx
  8d99a7:	85 c9                	test   %ecx,%ecx
  8d99a9:	0f 94 c2             	sete   %dl
  8d99ac:	44 20 da             	and    %r11b,%dl
  8d99af:	80 fa 01             	cmp    $0x1,%dl
  8d99b2:	75 34                	jne    8d99e8 <check_lower_batch_chain+0x3f8>
  8d99b4:	48 8b 90 90 02 00 00 	mov    0x290(%rax),%rdx
  8d99bb:	89 4c 24 24          	mov    %ecx,0x24(%rsp)
  8d99bf:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
  8d99c4:	41 8d 50 ff          	lea    -0x1(%r8),%edx
  8d99c8:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  8d99cd:	80 3c 11 00          	cmpb   $0x0,(%rcx,%rdx,1)
  8d99d1:	8b 4c 24 24          	mov    0x24(%rsp),%ecx
  8d99d5:	74 11                	je     8d99e8 <check_lower_batch_chain+0x3f8>
  8d99d7:	48 8b 80 78 02 00 00 	mov    0x278(%rax),%rax
  8d99de:	80 3c 10 00          	cmpb   $0x0,(%rax,%rdx,1)
  8d99e2:	0f 84 6f 05 00 00    	je     8d9f57 <check_lower_batch_chain+0x967>
  8d99e8:	8b 46 0c             	mov    0xc(%rsi),%eax
  8d99eb:	85 c0                	test   %eax,%eax
  8d99ed:	74 1c                	je     8d9a0b <check_lower_batch_chain+0x41b>
  8d99ef:	83 7e 54 00          	cmpl   $0x0,0x54(%rsi)
  8d99f3:	75 16                	jne    8d9a0b <check_lower_batch_chain+0x41b>
  8d99f5:	0f b7 56 08          	movzwl 0x8(%rsi),%edx
  8d99f9:	f7 c2 10 08 00 00    	test   $0x810,%edx
  8d99ff:	75 0a                	jne    8d9a0b <check_lower_batch_chain+0x41b>
  8d9a01:	83 7e 04 00          	cmpl   $0x0,0x4(%rsi)
  8d9a05:	0f 84 35 05 00 00    	je     8d9f40 <check_lower_batch_chain+0x950>
  8d9a0b:	85 c9                	test   %ecx,%ecx
  8d9a0d:	0f 85 44 05 00 00    	jne    8d9f57 <check_lower_batch_chain+0x967>
  8d9a13:	83 7e 04 01          	cmpl   $0x1,0x4(%rsi)
  8d9a17:	0f 94 c0             	sete   %al
  8d9a1a:	44 20 d8             	and    %r11b,%al
  8d9a1d:	3c 01                	cmp    $0x1,%al
  8d9a1f:	0f 85 32 05 00 00    	jne    8d9f57 <check_lower_batch_chain+0x967>
  8d9a25:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  8d9a2a:	48 8b 8f 80 00 00 00 	mov    0x80(%rdi),%rcx
  8d9a31:	49 8b 41 68          	mov    0x68(%r9),%rax
  8d9a35:	42 8b 0c 81          	mov    (%rcx,%r8,4),%ecx
  8d9a39:	42 8b 04 80          	mov    (%rax,%r8,4),%eax
  8d9a3d:	85 c9                	test   %ecx,%ecx
  8d9a3f:	0f 95 c2             	setne  %dl
  8d9a42:	83 f8 ff             	cmp    $0xffffffff,%eax
  8d9a45:	40 0f 94 c6          	sete   %sil
  8d9a49:	41 0f 95 c0          	setne  %r8b
  8d9a4d:	0f 45 c8             	cmovne %eax,%ecx
  8d9a50:	40 00 f6             	add    %sil,%sil
  8d9a53:	41 08 d0             	or     %dl,%r8b
  8d9a56:	40 80 c6 02          	add    $0x2,%sil
  8d9a5a:	40 88 b4 24 e0 00 00 	mov    %sil,0xe0(%rsp)
  8d9a61:	00 
  8d9a62:	8b 54 24 0c          	mov    0xc(%rsp),%edx
  8d9a66:	48 89 4c 24 50       	mov    %rcx,0x50(%rsp)
  8d9a6b:	4c 8b 5c 24 28       	mov    0x28(%rsp),%r11
  8d9a70:	45 20 c7             	and    %r8b,%r15b
  8d9a73:	88 94 24 d0 00 00 00 	mov    %dl,0xd0(%rsp)
  8d9a7a:	c7 44 24 20 01 00 00 	movl   $0x1,0x20(%rsp)
  8d9a81:	00 
  8d9a82:	41 80 ff 01          	cmp    $0x1,%r15b
  8d9a86:	0f 85 c9 03 00 00    	jne    8d9e55 <check_lower_batch_chain+0x865>
  8d9a8c:	2b 5c 24 10          	sub    0x10(%rsp),%ebx
  8d9a90:	44 89 f0             	mov    %r14d,%eax
  8d9a93:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  8d9a98:	ba 02 00 00 00       	mov    $0x2,%edx
  8d9a9d:	b8 06 00 00 00       	mov    $0x6,%eax
  8d9aa2:	c7 44 24 20 01 00 00 	movl   $0x1,0x20(%rsp)
  8d9aa9:	00 
  8d9aaa:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  8d9aaf:	45 8d 54 13 ff       	lea    -0x1(%r11,%rdx,1),%r10d
  8d9ab4:	49 8b 7c 24 08       	mov    0x8(%r12),%rdi
  8d9ab9:	31 c0                	xor    %eax,%eax
  8d9abb:	4b 8d 0c 52          	lea    (%r10,%r10,2),%rcx
  8d9abf:	48 c1 e1 05          	shl    $0x5,%rcx
  8d9ac3:	83 7c 0f 44 00       	cmpl   $0x0,0x44(%rdi,%rcx,1)
  8d9ac8:	0f 85 8b 04 00 00    	jne    8d9f59 <check_lower_batch_chain+0x969>
  8d9ace:	44 8b 8c 94 ec 00 00 	mov    0xec(%rsp,%rdx,4),%r9d
  8d9ad5:	00 
  8d9ad6:	49 89 d7             	mov    %rdx,%r15
  8d9ad9:	41 0f b6 f1          	movzbl %r9b,%esi
  8d9add:	8d 56 ff             	lea    -0x1(%rsi),%edx
  8d9ae0:	83 fa 09             	cmp    $0x9,%edx
  8d9ae3:	0f 87 70 04 00 00    	ja     8d9f59 <check_lower_batch_chain+0x969>
  8d9ae9:	44 89 ca             	mov    %r9d,%edx
  8d9aec:	81 e2 00 07 00 00    	and    $0x700,%edx
  8d9af2:	44 89 4c 24 18       	mov    %r9d,0x18(%rsp)
  8d9af7:	0f 85 5c 04 00 00    	jne    8d9f59 <check_lower_batch_chain+0x969>
  8d9afd:	49 8b 45 00          	mov    0x0(%r13),%rax
  8d9b01:	48 01 cf             	add    %rcx,%rdi
  8d9b04:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
  8d9b09:	8b 54 24 0c          	mov    0xc(%rsp),%edx
  8d9b0d:	83 7f 0c 00          	cmpl   $0x0,0xc(%rdi)
  8d9b11:	46 8b 0c 90          	mov    (%rax,%r10,4),%r9d
  8d9b15:	8d 41 fe             	lea    -0x2(%rcx),%eax
  8d9b18:	89 44 24 24          	mov    %eax,0x24(%rsp)
  8d9b1c:	74 1b                	je     8d9b39 <check_lower_batch_chain+0x549>
  8d9b1e:	83 7f 54 00          	cmpl   $0x0,0x54(%rdi)
  8d9b22:	75 15                	jne    8d9b39 <check_lower_batch_chain+0x549>
  8d9b24:	0f b7 47 08          	movzwl 0x8(%rdi),%eax
  8d9b28:	a9 10 08 00 00       	test   $0x810,%eax
  8d9b2d:	75 0a                	jne    8d9b39 <check_lower_batch_chain+0x549>
  8d9b2f:	83 7f 04 00          	cmpl   $0x0,0x4(%rdi)
  8d9b33:	0f 84 d9 01 00 00    	je     8d9d12 <check_lower_batch_chain+0x722>
  8d9b39:	41 83 f9 34          	cmp    $0x34,%r9d
  8d9b3d:	0f b6 c2             	movzbl %dl,%eax
  8d9b40:	41 0f 95 c0          	setne  %r8b
  8d9b44:	39 c6                	cmp    %eax,%esi
  8d9b46:	0f 94 c0             	sete   %al
  8d9b49:	41 83 f9 21          	cmp    $0x21,%r9d
  8d9b4d:	0f 85 fb 01 00 00    	jne    8d9d4e <check_lower_batch_chain+0x75e>
  8d9b53:	f6 47 08 04          	testb  $0x4,0x8(%rdi)
  8d9b57:	0f 85 cf 02 00 00    	jne    8d9e2c <check_lower_batch_chain+0x83c>
  8d9b5d:	49 8b 44 24 10       	mov    0x10(%r12),%rax
  8d9b62:	4c 89 d1             	mov    %r10,%rcx
  8d9b65:	48 c1 e1 05          	shl    $0x5,%rcx
  8d9b69:	8b 34 08             	mov    (%rax,%rcx,1),%esi
  8d9b6c:	48 85 f6             	test   %rsi,%rsi
  8d9b6f:	74 09                	je     8d9b7a <check_lower_batch_chain+0x58a>
  8d9b71:	44 8b 4f a0          	mov    -0x60(%rdi),%r9d
  8d9b75:	41 39 f1             	cmp    %esi,%r9d
  8d9b78:	75 75                	jne    8d9bef <check_lower_batch_chain+0x5ff>
  8d9b7a:	89 f0                	mov    %esi,%eax
  8d9b7c:	c1 e8 03             	shr    $0x3,%eax
  8d9b7f:	48 c7 44 24 48 00 00 	movq   $0x0,0x48(%rsp)
  8d9b86:	00 00 
  8d9b88:	48 8b 7d 10          	mov    0x10(%rbp),%rdi
  8d9b8c:	89 c0                	mov    %eax,%eax
  8d9b8e:	83 e6 07             	and    $0x7,%esi
  8d9b91:	45 31 c0             	xor    %r8d,%r8d
  8d9b94:	48 8b 0f             	mov    (%rdi),%rcx
  8d9b97:	48 8b 57 20          	mov    0x20(%rdi),%rdx
  8d9b9b:	0f b6 0c 01          	movzbl (%rcx,%rax,1),%ecx
  8d9b9f:	80 c1 f8             	add    $0xf8,%cl
  8d9ba2:	80 f9 03             	cmp    $0x3,%cl
  8d9ba5:	48 8d 4c 24 48       	lea    0x48(%rsp),%rcx
  8d9baa:	41 0f 43 f0          	cmovae %r8d,%esi
  8d9bae:	0b 34 82             	or     (%rdx,%rax,4),%esi
  8d9bb1:	49 8b 45 38          	mov    0x38(%r13),%rax
  8d9bb5:	42 8b 14 90          	mov    (%rax,%r10,4),%edx
  8d9bb9:	c5 f8 77             	vzeroupper
  8d9bbc:	e8 ef d1 90 00       	call   11e6db0 <type_find_member>
  8d9bc1:	85 c0                	test   %eax,%eax
  8d9bc3:	0f 84 59 02 00 00    	je     8d9e22 <check_lower_batch_chain+0x832>
  8d9bc9:	48 8b 4c 24 48       	mov    0x48(%rsp),%rcx
  8d9bce:	8b 44 24 3c          	mov    0x3c(%rsp),%eax
  8d9bd2:	44 8b 4c 24 18       	mov    0x18(%rsp),%r9d
  8d9bd7:	f6 c1 07             	test   $0x7,%cl
  8d9bda:	0f 84 8e 00 00 00    	je     8d9c6e <check_lower_batch_chain+0x67e>
  8d9be0:	4c 8b 5c 24 28       	mov    0x28(%rsp),%r11
  8d9be5:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
  8d9bea:	e9 42 02 00 00       	jmp    8d9e31 <check_lower_batch_chain+0x841>
  8d9bef:	48 8b 7c 24 30       	mov    0x30(%rsp),%rdi
  8d9bf4:	41 c1 e9 03          	shr    $0x3,%r9d
  8d9bf8:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  8d9bfe:	31 c9                	xor    %ecx,%ecx
  8d9c00:	44 8b 87 b0 01 00 00 	mov    0x1b0(%rdi),%r8d
  8d9c07:	45 39 c1             	cmp    %r8d,%r9d
  8d9c0a:	73 0c                	jae    8d9c18 <check_lower_batch_chain+0x628>
  8d9c0c:	48 8b 87 a0 01 00 00 	mov    0x1a0(%rdi),%rax
  8d9c13:	46 0f b6 1c 08       	movzbl (%rax,%r9,1),%r11d
  8d9c18:	89 f0                	mov    %esi,%eax
  8d9c1a:	c1 e8 03             	shr    $0x3,%eax
  8d9c1d:	44 39 c0             	cmp    %r8d,%eax
  8d9c20:	73 0b                	jae    8d9c2d <check_lower_batch_chain+0x63d>
  8d9c22:	48 8b 8f a0 01 00 00 	mov    0x1a0(%rdi),%rcx
  8d9c29:	0f b6 0c 01          	movzbl (%rcx,%rax,1),%ecx
  8d9c2d:	89 cf                	mov    %ecx,%edi
  8d9c2f:	41 f6 c3 01          	test   $0x1,%r11b
  8d9c33:	b9 ff 00 00 00       	mov    $0xff,%ecx
  8d9c38:	ba 08 00 00 00       	mov    $0x8,%edx
  8d9c3d:	44 89 5c 24 0c       	mov    %r11d,0xc(%rsp)
  8d9c42:	0f 45 ca             	cmovne %edx,%ecx
  8d9c45:	45 39 c1             	cmp    %r8d,%r9d
  8d9c48:	0f 83 6c 01 00 00    	jae    8d9dba <check_lower_batch_chain+0x7ca>
  8d9c4e:	41 f6 c3 01          	test   $0x1,%r11b
  8d9c52:	4c 8b 5c 24 30       	mov    0x30(%rsp),%r11
  8d9c57:	0f 85 62 01 00 00    	jne    8d9dbf <check_lower_batch_chain+0x7cf>
  8d9c5d:	49 8b 8b 98 01 00 00 	mov    0x198(%r11),%rcx
  8d9c64:	42 0f b6 0c 09       	movzbl (%rcx,%r9,1),%ecx
  8d9c69:	e9 51 01 00 00       	jmp    8d9dbf <check_lower_batch_chain+0x7cf>
  8d9c6e:	44 8b 5c 24 24       	mov    0x24(%rsp),%r11d
  8d9c73:	48 89 cf             	mov    %rcx,%rdi
  8d9c76:	48 c1 ef 03          	shr    $0x3,%rdi
  8d9c7a:	48 85 c9             	test   %rcx,%rcx
  8d9c7d:	b9 03 00 00 00       	mov    $0x3,%ecx
  8d9c82:	4a 8d 14 3b          	lea    (%rbx,%r15,1),%rdx
  8d9c86:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8d9c8c:	c4 e2 21 f7 c9       	shlx   %r11d,%ecx,%ecx
  8d9c91:	44 89 de             	mov    %r11d,%esi
  8d9c94:	48 89 7c f4 50       	mov    %rdi,0x50(%rsp,%rsi,8)
  8d9c99:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
  8d9c9e:	c6 84 34 e0 00 00 00 	movb   $0x1,0xe0(%rsp,%rsi,1)
  8d9ca5:	01 
  8d9ca6:	c6 84 34 d0 00 00 00 	movb   $0x8,0xd0(%rsp,%rsi,1)
  8d9cad:	08 
  8d9cae:	41 0f 44 c8          	cmove  %r8d,%ecx
  8d9cb2:	83 fa 01             	cmp    $0x1,%edx
  8d9cb5:	ba 04 00 00 00       	mov    $0x4,%edx
  8d9cba:	c4 e2 21 f7 d2       	shlx   %r11d,%edx,%edx
  8d9cbf:	4c 8b 5c 24 28       	mov    0x28(%rsp),%r11
  8d9cc4:	41 89 d2             	mov    %edx,%r10d
  8d9cc7:	45 0f 44 d0          	cmove  %r8d,%r10d
  8d9ccb:	84 c0                	test   %al,%al
  8d9ccd:	41 b0 01             	mov    $0x1,%r8b
  8d9cd0:	44 0f 44 d2          	cmove  %edx,%r10d
  8d9cd4:	41 09 ca             	or     %ecx,%r10d
  8d9cd7:	8d 77 ff             	lea    -0x1(%rdi),%esi
  8d9cda:	48 89 f9             	mov    %rdi,%rcx
  8d9cdd:	44 09 54 24 20       	or     %r10d,0x20(%rsp)
  8d9ce2:	c6 84 34 e0 00 00 00 	movb   $0x15,0xe0(%rsp,%rsi,1)
  8d9ce9:	15 
  8d9cea:	c6 84 34 d0 00 00 00 	movb   $0x8,0xd0(%rsp,%rsi,1)
  8d9cf1:	08 
  8d9cf2:	48 c7 44 f4 50 01 00 	movq   $0x1,0x50(%rsp,%rsi,8)
  8d9cf9:	00 00 
  8d9cfb:	89 fe                	mov    %edi,%esi
  8d9cfd:	c6 84 34 e0 00 00 00 	movb   $0xa,0xe0(%rsp,%rsi,1)
  8d9d04:	0a 
  8d9d05:	44 88 8c 34 d0 00 00 	mov    %r9b,0xd0(%rsp,%rsi,1)
  8d9d0c:	00 
  8d9d0d:	e9 22 01 00 00       	jmp    8d9e34 <check_lower_batch_chain+0x844>
  8d9d12:	31 c0                	xor    %eax,%eax
  8d9d14:	41 83 f9 3e          	cmp    $0x3e,%r9d
  8d9d18:	0f 87 3b 02 00 00    	ja     8d9f59 <check_lower_batch_chain+0x969>
  8d9d1e:	48 ba 00 00 00 00 08 	movabs $0x4080000800000000,%rdx
  8d9d25:	00 80 40 
  8d9d28:	44 89 c9             	mov    %r9d,%ecx
  8d9d2b:	48 0f a3 ca          	bt     %rcx,%rdx
  8d9d2f:	0f 83 24 02 00 00    	jae    8d9f59 <check_lower_batch_chain+0x969>
  8d9d35:	8b 54 24 0c          	mov    0xc(%rsp),%edx
  8d9d39:	41 83 f9 34          	cmp    $0x34,%r9d
  8d9d3d:	0f 95 c0             	setne  %al
  8d9d40:	0f b6 ca             	movzbl %dl,%ecx
  8d9d43:	39 ce                	cmp    %ecx,%esi
  8d9d45:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
  8d9d4a:	41 0f 94 c0          	sete   %r8b
  8d9d4e:	41 08 c0             	or     %al,%r8b
  8d9d51:	41 83 f9 34          	cmp    $0x34,%r9d
  8d9d55:	0f 95 c0             	setne  %al
  8d9d58:	44 20 c0             	and    %r8b,%al
  8d9d5b:	3c 01                	cmp    $0x1,%al
  8d9d5d:	75 54                	jne    8d9db3 <check_lower_batch_chain+0x7c3>
  8d9d5f:	44 8b 4c 24 18       	mov    0x18(%rsp),%r9d
  8d9d64:	8b 47 a0             	mov    -0x60(%rdi),%eax
  8d9d67:	41 b0 01             	mov    $0x1,%r8b
  8d9d6a:	3b 07                	cmp    (%rdi),%eax
  8d9d6c:	0f 84 c2 00 00 00    	je     8d9e34 <check_lower_batch_chain+0x844>
  8d9d72:	8b 7c 24 24          	mov    0x24(%rsp),%edi
  8d9d76:	41 f7 c1 00 10 00 00 	test   $0x1000,%r9d
  8d9d7d:	41 0f 94 c0          	sete   %r8b
  8d9d81:	89 f8                	mov    %edi,%eax
  8d9d83:	c6 84 04 e0 00 00 00 	movb   $0x9,0xe0(%rsp,%rax,1)
  8d9d8a:	09 
  8d9d8b:	40 88 b4 04 d0 00 00 	mov    %sil,0xd0(%rsp,%rax,1)
  8d9d92:	00 
  8d9d93:	0f b6 c2             	movzbl %dl,%eax
  8d9d96:	ba 00 00 00 00       	mov    $0x0,%edx
  8d9d9b:	39 c6                	cmp    %eax,%esi
  8d9d9d:	b8 01 00 00 00       	mov    $0x1,%eax
  8d9da2:	c4 e2 41 f7 c0       	shlx   %edi,%eax,%eax
  8d9da7:	0f 44 c2             	cmove  %edx,%eax
  8d9daa:	09 44 24 20          	or     %eax,0x20(%rsp)
  8d9dae:	e9 81 00 00 00       	jmp    8d9e34 <check_lower_batch_chain+0x844>
  8d9db3:	44 8b 4c 24 18       	mov    0x18(%rsp),%r9d
  8d9db8:	eb 7a                	jmp    8d9e34 <check_lower_batch_chain+0x844>
  8d9dba:	4c 8b 5c 24 30       	mov    0x30(%rsp),%r11
  8d9dbf:	40 f6 c7 01          	test   $0x1,%dil
  8d9dc3:	41 b9 ff 00 00 00    	mov    $0xff,%r9d
  8d9dc9:	44 0f 45 ca          	cmovne %edx,%r9d
  8d9dcd:	44 39 c0             	cmp    %r8d,%eax
  8d9dd0:	73 12                	jae    8d9de4 <check_lower_batch_chain+0x7f4>
  8d9dd2:	40 f6 c7 01          	test   $0x1,%dil
  8d9dd6:	75 0c                	jne    8d9de4 <check_lower_batch_chain+0x7f4>
  8d9dd8:	4d 8b 8b 98 01 00 00 	mov    0x198(%r11),%r9
  8d9ddf:	45 0f b6 0c 01       	movzbl (%r9,%rax,1),%r9d
  8d9de4:	44 39 c9             	cmp    %r9d,%ecx
  8d9de7:	41 0f 94 c1          	sete   %r9b
  8d9deb:	83 f9 0f             	cmp    $0xf,%ecx
  8d9dee:	0f 92 c1             	setb   %cl
  8d9df1:	44 20 c9             	and    %r9b,%cl
  8d9df4:	80 f9 01             	cmp    $0x1,%cl
  8d9df7:	75 29                	jne    8d9e22 <check_lower_batch_chain+0x832>
  8d9df9:	89 f9                	mov    %edi,%ecx
  8d9dfb:	33 4c 24 0c          	xor    0xc(%rsp),%ecx
  8d9dff:	f6 c1 01             	test   $0x1,%cl
  8d9e02:	75 1e                	jne    8d9e22 <check_lower_batch_chain+0x832>
  8d9e04:	8b 4c 24 0c          	mov    0xc(%rsp),%ecx
  8d9e08:	09 f9                	or     %edi,%ecx
  8d9e0a:	f6 c1 02             	test   $0x2,%cl
  8d9e0d:	75 13                	jne    8d9e22 <check_lower_batch_chain+0x832>
  8d9e0f:	48 c7 44 24 48 00 00 	movq   $0x0,0x48(%rsp)
  8d9e16:	00 00 
  8d9e18:	40 f6 c7 10          	test   $0x10,%dil
  8d9e1c:	0f 84 66 fd ff ff    	je     8d9b88 <check_lower_batch_chain+0x598>
  8d9e22:	4c 8b 5c 24 28       	mov    0x28(%rsp),%r11
  8d9e27:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
  8d9e2c:	44 8b 4c 24 18       	mov    0x18(%rsp),%r9d
  8d9e31:	45 31 c0             	xor    %r8d,%r8d
  8d9e34:	45 84 c0             	test   %r8b,%r8b
  8d9e37:	74 1c                	je     8d9e55 <check_lower_batch_chain+0x865>
  8d9e39:	83 c1 04             	add    $0x4,%ecx
  8d9e3c:	49 8d 57 01          	lea    0x1(%r15),%rdx
  8d9e40:	44 89 4c 24 0c       	mov    %r9d,0xc(%rsp)
  8d9e45:	48 89 4c 24 10       	mov    %rcx,0x10(%rsp)
  8d9e4a:	4c 3b 7c 24 40       	cmp    0x40(%rsp),%r15
  8d9e4f:	0f 82 5a fc ff ff    	jb     8d9aaf <check_lower_batch_chain+0x4bf>
  8d9e55:	45 84 c0             	test   %r8b,%r8b
  8d9e58:	0f 84 f9 00 00 00    	je     8d9f57 <check_lower_batch_chain+0x967>
  8d9e5e:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  8d9e63:	c5 f9 6f 84 24 e0 00 	vmovdqa 0xe0(%rsp),%xmm0
  8d9e6a:	00 00 
  8d9e6c:	8b 7c 24 20          	mov    0x20(%rsp),%edi
  8d9e70:	48 8b 46 20          	mov    0x20(%rsi),%rax
  8d9e74:	8b 8e 38 01 00 00    	mov    0x138(%rsi),%ecx
  8d9e7a:	c5 fb 92 cf          	kmovd  %edi,%k1
  8d9e7e:	f3 0f b8 d7          	popcnt %edi,%edx
  8d9e82:	62 f2 7d 09 63 04 08 	vpcompressb %xmm0,(%rax,%rcx,1){%k1}
  8d9e89:	c5 f9 6f 84 24 d0 00 	vmovdqa 0xd0(%rsp),%xmm0
  8d9e90:	00 00 
  8d9e92:	48 8b 46 28          	mov    0x28(%rsi),%rax
  8d9e96:	8b 8e 38 01 00 00    	mov    0x138(%rsi),%ecx
  8d9e9c:	62 f2 7d 09 63 04 08 	vpcompressb %xmm0,(%rax,%rcx,1){%k1}
  8d9ea3:	62 f1 fe 48 6f 84 24 	vmovdqu64 0x50(%rsp),%zmm0
  8d9eaa:	50 00 00 00 
  8d9eae:	48 8b 46 30          	mov    0x30(%rsi),%rax
  8d9eb2:	8b 8e 38 01 00 00    	mov    0x138(%rsi),%ecx
  8d9eb8:	62 f2 fd 49 8b 04 c8 	vpcompressq %zmm0,(%rax,%rcx,8){%k1}
  8d9ebf:	40 0f b6 c7          	movzbl %dil,%eax
  8d9ec3:	c1 ef 08             	shr    $0x8,%edi
  8d9ec6:	8b 8e 38 01 00 00    	mov    0x138(%rsi),%ecx
  8d9ecc:	62 f1 fe 48 6f 84 24 	vmovdqu64 0x90(%rsp),%zmm0
  8d9ed3:	90 00 00 00 
  8d9ed7:	f3 0f b8 c0          	popcnt %eax,%eax
  8d9edb:	c5 fb 92 cf          	kmovd  %edi,%k1
  8d9edf:	48 c1 e1 03          	shl    $0x3,%rcx
  8d9ee3:	48 03 4e 30          	add    0x30(%rsi),%rcx
  8d9ee7:	62 f2 fd 49 8b 04 c1 	vpcompressq %zmm0,(%rcx,%rax,8){%k1}
  8d9eee:	01 96 38 01 00 00    	add    %edx,0x138(%rsi)
  8d9ef4:	49 8b 45 08          	mov    0x8(%r13),%rax
  8d9ef8:	42 8b 04 98          	mov    (%rax,%r11,4),%eax
  8d9efc:	89 86 64 01 00 00    	mov    %eax,0x164(%rsi)
  8d9f02:	44 89 f0             	mov    %r14d,%eax
  8d9f05:	62 f2 fd 08 7c c0    	vpbroadcastq %rax,%xmm0
  8d9f0b:	b0 01                	mov    $0x1,%al
  8d9f0d:	c5 f9 d4 86 00 02 00 	vpaddq 0x200(%rsi),%xmm0,%xmm0
  8d9f14:	00 
  8d9f15:	c5 fa 7f 86 00 02 00 	vmovdqu %xmm0,0x200(%rsi)
  8d9f1c:	00 
  8d9f1d:	eb 3a                	jmp    8d9f59 <check_lower_batch_chain+0x969>
  8d9f1f:	41 be 02 00 00 00    	mov    $0x2,%r14d
  8d9f25:	e9 0a fa ff ff       	jmp    8d9934 <check_lower_batch_chain+0x344>
  8d9f2a:	41 be 04 00 00 00    	mov    $0x4,%r14d
  8d9f30:	e9 ca f8 ff ff       	jmp    8d97ff <check_lower_batch_chain+0x20f>
  8d9f35:	41 be 03 00 00 00    	mov    $0x3,%r14d
  8d9f3b:	e9 f4 f9 ff ff       	jmp    8d9934 <check_lower_batch_chain+0x344>
  8d9f40:	83 f9 3e             	cmp    $0x3e,%ecx
  8d9f43:	77 3c                	ja     8d9f81 <check_lower_batch_chain+0x991>
  8d9f45:	48 ba 00 00 00 00 08 	movabs $0x4080000800000000,%rdx
  8d9f4c:	00 80 40 
  8d9f4f:	89 c9                	mov    %ecx,%ecx
  8d9f51:	48 0f a3 ca          	bt     %rcx,%rdx
  8d9f55:	73 2a                	jae    8d9f81 <check_lower_batch_chain+0x991>
  8d9f57:	31 c0                	xor    %eax,%eax
  8d9f59:	64 48 8b 0c 25 28 00 	mov    %fs:0x28,%rcx
  8d9f60:	00 00 
  8d9f62:	48 3b 8c 24 30 01 00 	cmp    0x130(%rsp),%rcx
  8d9f69:	00 
  8d9f6a:	75 7f                	jne    8d9feb <check_lower_batch_chain+0x9fb>
  8d9f6c:	48 81 c4 38 01 00 00 	add    $0x138,%rsp
  8d9f73:	5b                   	pop    %rbx
  8d9f74:	41 5c                	pop    %r12
  8d9f76:	41 5d                	pop    %r13
  8d9f78:	41 5e                	pop    %r14
  8d9f7a:	41 5f                	pop    %r15
  8d9f7c:	5d                   	pop    %rbp
  8d9f7d:	c5 f8 77             	vzeroupper
  8d9f80:	c3                   	ret
  8d9f81:	83 f8 01             	cmp    $0x1,%eax
  8d9f84:	75 d1                	jne    8d9f57 <check_lower_batch_chain+0x967>
  8d9f86:	c6 84 24 e0 00 00 00 	movb   $0x1,0xe0(%rsp)
  8d9f8d:	01 
  8d9f8e:	8b 54 24 0c          	mov    0xc(%rsp),%edx
  8d9f92:	41 b0 01             	mov    $0x1,%r8b
  8d9f95:	48 8b 46 10          	mov    0x10(%rsi),%rax
  8d9f99:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  8d9f9e:	41 83 fa 06          	cmp    $0x6,%r10d
  8d9fa2:	0f 87 c3 fa ff ff    	ja     8d9a6b <check_lower_batch_chain+0x47b>
  8d9fa8:	41 d1 e9             	shr    $1,%r9d
  8d9fab:	b9 08 00 00 00       	mov    $0x8,%ecx
  8d9fb0:	89 d6                	mov    %edx,%esi
  8d9fb2:	48 c7 c2 ff ff ff ff 	mov    $0xffffffffffffffff,%rdx
  8d9fb9:	41 b0 01             	mov    $0x1,%r8b
  8d9fbc:	c4 e2 31 f7 c9       	shlx   %r9d,%ecx,%ecx
  8d9fc1:	c4 e2 f1 f7 d2       	shlx   %rcx,%rdx,%rdx
  8d9fc6:	c4 e2 f0 f5 c0       	bzhi   %rcx,%rax,%rax
  8d9fcb:	ff c9                	dec    %ecx
  8d9fcd:	c4 e2 f3 f7 c8       	shrx   %rcx,%rax,%rcx
  8d9fd2:	48 85 c9             	test   %rcx,%rcx
  8d9fd5:	48 0f 44 d1          	cmove  %rcx,%rdx
  8d9fd9:	31 c9                	xor    %ecx,%ecx
  8d9fdb:	40 f6 c6 01          	test   $0x1,%sil
  8d9fdf:	48 0f 45 ca          	cmovne %rdx,%rcx
  8d9fe3:	48 09 c1             	or     %rax,%rcx
  8d9fe6:	e9 77 fa ff ff       	jmp    8d9a62 <check_lower_batch_chain+0x472>
  8d9feb:	c5 f8 77             	vzeroupper
  8d9fee:	e8 cd 3d ef ff       	call   7cddc0 <__stack_chk_fail@plt>
