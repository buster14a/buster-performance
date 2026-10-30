
/home/david/buster-fast-bench/codex-pr915-20261030/head/build/compiler:     file format elf64-x86-64


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

0000000000ff44c0 <ir_optimize_licm>:
  ff44c0:	55                   	push   %rbp
  ff44c1:	48 89 e5             	mov    %rsp,%rbp
  ff44c4:	41 57                	push   %r15
  ff44c6:	41 56                	push   %r14
  ff44c8:	41 55                	push   %r13
  ff44ca:	41 54                	push   %r12
  ff44cc:	53                   	push   %rbx
  ff44cd:	48 83 e4 c0          	and    $0xffffffffffffffc0,%rsp
  ff44d1:	48 81 ec 40 0b 00 00 	sub    $0xb40,%rsp
  ff44d8:	48 8b 46 08          	mov    0x8(%rsi),%rax
  ff44dc:	4c 8b 72 08          	mov    0x8(%rdx),%r14
  ff44e0:	48 89 d3             	mov    %rdx,%rbx
  ff44e3:	49 89 fc             	mov    %rdi,%r12
  ff44e6:	48 8d bc 24 98 02 00 00 	lea    0x298(%rsp),%rdi
  ff44ee:	ba 28 05 00 00       	mov    $0x528,%edx
  ff44f3:	49 89 cd             	mov    %rcx,%r13
  ff44f6:	49 89 f7             	mov    %rsi,%r15
  ff44f9:	31 f6                	xor    %esi,%esi
  ff44fb:	4c 89 84 24 f0 00 00 00 	mov    %r8,0xf0(%rsp)
  ff4503:	48 89 8c 24 88 00 00 00 	mov    %rcx,0x88(%rsp)
  ff450b:	49 c1 ed 20          	shr    $0x20,%r13
  ff450f:	48 89 84 24 f8 00 00 00 	mov    %rax,0xf8(%rsp)
  ff4517:	e8 c4 56 90 ff       	call   8f9be0 <memset@plt>
  ff451c:	4d 89 fa             	mov    %r15,%r10
  ff451f:	4c 89 b4 24 e8 00 00 00 	mov    %r14,0xe8(%rsp)
  ff4527:	49 39 df             	cmp    %rbx,%r15
  ff452a:	74 32                	je     ff455e <ir_optimize_licm+0x9e>
  ff452c:	48 8d bc 24 98 02 00 00 	lea    0x298(%rsp),%rdi
  ff4534:	4c 89 e6             	mov    %r12,%rsi
  ff4537:	4c 89 d2             	mov    %r10,%rdx
  ff453a:	48 89 d9             	mov    %rbx,%rcx
  ff453d:	45 89 e8             	mov    %r13d,%r8d
  ff4540:	4d 89 ef             	mov    %r13,%r15
  ff4543:	4d 89 d6             	mov    %r10,%r14
  ff4546:	e8 75 04 01 00       	call   10049c0 <ir_optimize_prepare>
  ff454b:	4d 89 f2             	mov    %r14,%r10
  ff454e:	49 89 d0             	mov    %rdx,%r8
  ff4551:	41 89 c5             	mov    %eax,%r13d
  ff4554:	85 c0                	test   %eax,%eax
  ff4556:	0f 85 d2 04 00 00    	jne    ff4a2e <ir_optimize_licm+0x56e>
  ff455c:	eb 1b                	jmp    ff4579 <ir_optimize_licm+0xb9>
  ff455e:	4d 89 ef             	mov    %r13,%r15
  ff4561:	48 b8 07 00 00 00 ff ff ff ff 	movabs $0xffffffff00000007,%rax
  ff456b:	45 31 c0             	xor    %r8d,%r8d
  ff456e:	41 89 c5             	mov    %eax,%r13d
  ff4571:	85 c0                	test   %eax,%eax
  ff4573:	0f 85 b5 04 00 00    	jne    ff4a2e <ir_optimize_licm+0x56e>
  ff4579:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
  ff457e:	48 8b 84 24 a0 02 00 00 	mov    0x2a0(%rsp),%rax
  ff4586:	c5 fe 6f 84 24 a8 02 00 00 	vmovdqu 0x2a8(%rsp),%ymm0
  ff458f:	4c 89 44 24 40       	mov    %r8,0x40(%rsp)
  ff4594:	4c 8d 8c 24 70 05 00 00 	lea    0x570(%rsp),%r9
  ff459c:	48 8d 94 24 c0 07 00 00 	lea    0x7c0(%rsp),%rdx
  ff45a4:	41 b8 00 00 00 04    	mov    $0x4000000,%r8d
  ff45aa:	48 89 df             	mov    %rbx,%rdi
  ff45ad:	4c 89 54 24 30       	mov    %r10,0x30(%rsp)
  ff45b2:	4c 89 d6             	mov    %r10,%rsi
  ff45b5:	48 89 84 24 c0 07 00 00 	mov    %rax,0x7c0(%rsp)
  ff45bd:	41 83 7c 24 48 01    	cmpl   $0x1,0x48(%r12)
  ff45c3:	19 c0                	sbb    %eax,%eax
  ff45c5:	89 84 24 c8 07 00 00 	mov    %eax,0x7c8(%rsp)
  ff45cc:	48 b8 00 00 00 00 02 00 00 00 	movabs $0x200000000,%rax
  ff45d6:	c7 84 24 cc 07 00 00 00 00 00 00 	movl   $0x0,0x7cc(%rsp)
  ff45e1:	c5 fe 7f 84 24 d0 07 00 00 	vmovdqu %ymm0,0x7d0(%rsp)
  ff45ea:	4a 8d 0c 78          	lea    (%rax,%r15,2),%rcx
  ff45ee:	c5 f8 77             	vzeroupper
  ff45f1:	e8 ea 0c e5 ff       	call   e452e0 <dominators_analyze>
  ff45f6:	31 c9                	xor    %ecx,%ecx
  ff45f8:	83 f8 02             	cmp    $0x2,%eax
  ff45fb:	0f 95 c2             	setne  %dl
  ff45fe:	85 c0                	test   %eax,%eax
  ff4600:	74 1e                	je     ff4620 <ir_optimize_licm+0x160>
  ff4602:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  ff4607:	4c 8b 54 24 30       	mov    0x30(%rsp),%r10
  ff460c:	4c 8b 44 24 40       	mov    0x40(%rsp),%r8
  ff4611:	88 d1                	mov    %dl,%cl
  ff4613:	44 8d 2c cd 02 00 00 00 	lea    0x2(,%rcx,8),%r13d
  ff461b:	e9 0e 04 00 00       	jmp    ff4a2e <ir_optimize_licm+0x56e>
  ff4620:	4c 89 bc 24 d0 00 00 00 	mov    %r15,0xd0(%rsp)
  ff4628:	45 8b 7c 24 38       	mov    0x38(%r12),%r15d
  ff462d:	48 89 5c 24 20       	mov    %rbx,0x20(%rsp)
  ff4632:	4d 85 ff             	test   %r15,%r15
  ff4635:	0f 84 dc 00 00 00    	je     ff4717 <ir_optimize_licm+0x257>
  ff463b:	48 8b 0b             	mov    (%rbx),%rcx
  ff463e:	48 8b 43 08          	mov    0x8(%rbx),%rax
  ff4642:	4c 8d 64 08 3f       	lea    0x3f(%rax,%rcx,1),%r12
  ff4647:	48 01 c8             	add    %rcx,%rax
  ff464a:	49 83 e4 c0          	and    $0xffffffffffffffc0,%r12
  ff464e:	49 39 c4             	cmp    %rax,%r12
  ff4651:	0f 82 c0 00 00 00    	jb     ff4717 <ir_optimize_licm+0x257>
  ff4657:	4c 89 e0             	mov    %r12,%rax
  ff465a:	48 29 c8             	sub    %rcx,%rax
  ff465d:	48 8b 4b 10          	mov    0x10(%rbx),%rcx
  ff4661:	4e 8d 34 bd 00 00 00 00 	lea    0x0(,%r15,4),%r14
  ff4669:	48 29 c1             	sub    %rax,%rcx
  ff466c:	0f 92 c2             	setb   %dl
  ff466f:	49 39 ce             	cmp    %rcx,%r14
  ff4672:	0f 97 c1             	seta   %cl
  ff4675:	08 d1                	or     %dl,%cl
  ff4677:	0f 85 9a 00 00 00    	jne    ff4717 <ir_optimize_licm+0x257>
  ff467d:	4c 01 f0             	add    %r14,%rax
  ff4680:	48 89 43 08          	mov    %rax,0x8(%rbx)
  ff4684:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  ff4688:	48 39 c8             	cmp    %rcx,%rax
  ff468b:	48 0f 46 c1          	cmovbe %rcx,%rax
  ff468f:	48 89 43 20          	mov    %rax,0x20(%rbx)
  ff4693:	4d 85 e4             	test   %r12,%r12
  ff4696:	74 7f                	je     ff4717 <ir_optimize_licm+0x257>
  ff4698:	4c 89 e7             	mov    %r12,%rdi
  ff469b:	31 f6                	xor    %esi,%esi
  ff469d:	4c 89 f2             	mov    %r14,%rdx
  ff46a0:	e8 3b 55 90 ff       	call   8f9be0 <memset@plt>
  ff46a5:	4c 89 a4 24 38 06 00 00 	mov    %r12,0x638(%rsp)
  ff46ad:	48 8b 0b             	mov    (%rbx),%rcx
  ff46b0:	48 8b 43 08          	mov    0x8(%rbx),%rax
  ff46b4:	4c 8d 64 08 3f       	lea    0x3f(%rax,%rcx,1),%r12
  ff46b9:	48 01 c8             	add    %rcx,%rax
  ff46bc:	49 83 e4 c0          	and    $0xffffffffffffffc0,%r12
  ff46c0:	49 39 c4             	cmp    %rax,%r12
  ff46c3:	0f 82 1b 03 00 00    	jb     ff49e4 <ir_optimize_licm+0x524>
  ff46c9:	4c 89 e0             	mov    %r12,%rax
  ff46cc:	48 29 c8             	sub    %rcx,%rax
  ff46cf:	48 8b 4b 10          	mov    0x10(%rbx),%rcx
  ff46d3:	48 29 c1             	sub    %rax,%rcx
  ff46d6:	0f 92 c2             	setb   %dl
  ff46d9:	49 39 ce             	cmp    %rcx,%r14
  ff46dc:	0f 97 c1             	seta   %cl
  ff46df:	08 d1                	or     %dl,%cl
  ff46e1:	0f 85 fd 02 00 00    	jne    ff49e4 <ir_optimize_licm+0x524>
  ff46e7:	4c 01 f0             	add    %r14,%rax
  ff46ea:	48 89 43 08          	mov    %rax,0x8(%rbx)
  ff46ee:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  ff46f2:	48 39 c8             	cmp    %rcx,%rax
  ff46f5:	48 0f 46 c1          	cmovbe %rcx,%rax
  ff46f9:	48 89 43 20          	mov    %rax,0x20(%rbx)
  ff46fd:	4d 85 e4             	test   %r12,%r12
  ff4700:	0f 84 de 02 00 00    	je     ff49e4 <ir_optimize_licm+0x524>
  ff4706:	4c 89 e7             	mov    %r12,%rdi
  ff4709:	31 f6                	xor    %esi,%esi
  ff470b:	4c 89 f2             	mov    %r14,%rdx
  ff470e:	e8 cd 54 90 ff       	call   8f9be0 <memset@plt>
  ff4713:	b3 01                	mov    $0x1,%bl
  ff4715:	eb 15                	jmp    ff472c <ir_optimize_licm+0x26c>
  ff4717:	4d 85 ff             	test   %r15,%r15
  ff471a:	48 c7 84 24 38 06 00 00 00 00 00 00 	movq   $0x0,0x638(%rsp)
  ff4726:	0f 94 c3             	sete   %bl
  ff4729:	45 31 e4             	xor    %r12d,%r12d
  ff472c:	4d 85 ff             	test   %r15,%r15
  ff472f:	41 89 de             	mov    %ebx,%r14d
  ff4732:	4c 8b 54 24 30       	mov    0x30(%rsp),%r10
  ff4737:	4c 8b 44 24 40       	mov    0x40(%rsp),%r8
  ff473c:	4c 89 a4 24 40 06 00 00 	mov    %r12,0x640(%rsp)
  ff4744:	0f 94 c0             	sete   %al
  ff4747:	41 80 f6 01          	xor    $0x1,%r14b
  ff474b:	44 08 f0             	or     %r14b,%al
  ff474e:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  ff4753:	0f 85 88 00 00 00    	jne    ff47e1 <ir_optimize_licm+0x321>
  ff4759:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  ff475e:	48 8b 11             	mov    (%rcx),%rdx
  ff4761:	48 8b 49 08          	mov    0x8(%rcx),%rcx
  ff4765:	4c 8d 64 11 3f       	lea    0x3f(%rcx,%rdx,1),%r12
  ff476a:	48 01 d1             	add    %rdx,%rcx
  ff476d:	49 83 e4 c0          	and    $0xffffffffffffffc0,%r12
  ff4771:	49 39 cc             	cmp    %rcx,%r12
  ff4774:	0f 82 85 02 00 00    	jb     ff49ff <ir_optimize_licm+0x53f>
  ff477a:	4c 89 e1             	mov    %r12,%rcx
  ff477d:	48 29 d1             	sub    %rdx,%rcx
  ff4780:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
  ff4785:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  ff4789:	48 29 ca             	sub    %rcx,%rdx
  ff478c:	40 0f 92 c6          	setb   %sil
  ff4790:	4c 39 fa             	cmp    %r15,%rdx
  ff4793:	0f 92 c2             	setb   %dl
  ff4796:	40 08 f2             	or     %sil,%dl
  ff4799:	0f 85 60 02 00 00    	jne    ff49ff <ir_optimize_licm+0x53f>
  ff479f:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
  ff47a4:	4c 01 f9             	add    %r15,%rcx
  ff47a7:	48 89 4e 08          	mov    %rcx,0x8(%rsi)
  ff47ab:	48 8b 56 20          	mov    0x20(%rsi),%rdx
  ff47af:	48 39 d1             	cmp    %rdx,%rcx
  ff47b2:	48 0f 46 ca          	cmovbe %rdx,%rcx
  ff47b6:	48 89 4e 20          	mov    %rcx,0x20(%rsi)
  ff47ba:	4d 85 e4             	test   %r12,%r12
  ff47bd:	0f 84 3c 02 00 00    	je     ff49ff <ir_optimize_licm+0x53f>
  ff47c3:	4c 89 e7             	mov    %r12,%rdi
  ff47c6:	31 f6                	xor    %esi,%esi
  ff47c8:	4c 89 fa             	mov    %r15,%rdx
  ff47cb:	e8 10 54 90 ff       	call   8f9be0 <memset@plt>
  ff47d0:	4c 8b 44 24 40       	mov    0x40(%rsp),%r8
  ff47d5:	4c 8b 54 24 30       	mov    0x30(%rsp),%r10
  ff47da:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  ff47df:	eb 03                	jmp    ff47e4 <ir_optimize_licm+0x324>
  ff47e1:	45 31 e4             	xor    %r12d,%r12d
  ff47e4:	4d 85 ff             	test   %r15,%r15
  ff47e7:	4c 89 a4 24 48 06 00 00 	mov    %r12,0x648(%rsp)
  ff47ef:	0f 94 c1             	sete   %cl
  ff47f2:	44 08 f1             	or     %r14b,%cl
  ff47f5:	0f 85 88 00 00 00    	jne    ff4883 <ir_optimize_licm+0x3c3>
  ff47fb:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  ff4800:	48 8b 11             	mov    (%rcx),%rdx
  ff4803:	48 8b 49 08          	mov    0x8(%rcx),%rcx
  ff4807:	4c 8d 64 11 3f       	lea    0x3f(%rcx,%rdx,1),%r12
  ff480c:	48 01 d1             	add    %rdx,%rcx
  ff480f:	49 83 e4 c0          	and    $0xffffffffffffffc0,%r12
  ff4813:	49 39 cc             	cmp    %rcx,%r12
  ff4816:	0f 82 ef 01 00 00    	jb     ff4a0b <ir_optimize_licm+0x54b>
  ff481c:	4c 89 e1             	mov    %r12,%rcx
  ff481f:	48 29 d1             	sub    %rdx,%rcx
  ff4822:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
  ff4827:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  ff482b:	48 29 ca             	sub    %rcx,%rdx
  ff482e:	40 0f 92 c6          	setb   %sil
  ff4832:	4c 39 fa             	cmp    %r15,%rdx
  ff4835:	0f 92 c2             	setb   %dl
  ff4838:	40 08 f2             	or     %sil,%dl
  ff483b:	0f 85 ca 01 00 00    	jne    ff4a0b <ir_optimize_licm+0x54b>
  ff4841:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
  ff4846:	4c 01 f9             	add    %r15,%rcx
  ff4849:	48 89 4e 08          	mov    %rcx,0x8(%rsi)
  ff484d:	48 8b 56 20          	mov    0x20(%rsi),%rdx
  ff4851:	48 39 d1             	cmp    %rdx,%rcx
  ff4854:	48 0f 46 ca          	cmovbe %rdx,%rcx
  ff4858:	48 89 4e 20          	mov    %rcx,0x20(%rsi)
  ff485c:	4d 85 e4             	test   %r12,%r12
  ff485f:	0f 84 a6 01 00 00    	je     ff4a0b <ir_optimize_licm+0x54b>
  ff4865:	4c 89 e7             	mov    %r12,%rdi
  ff4868:	31 f6                	xor    %esi,%esi
  ff486a:	4c 89 fa             	mov    %r15,%rdx
  ff486d:	e8 6e 53 90 ff       	call   8f9be0 <memset@plt>
  ff4872:	4c 8b 44 24 40       	mov    0x40(%rsp),%r8
  ff4877:	4c 8b 54 24 30       	mov    0x30(%rsp),%r10
  ff487c:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  ff4881:	eb 03                	jmp    ff4886 <ir_optimize_licm+0x3c6>
  ff4883:	45 31 e4             	xor    %r12d,%r12d
  ff4886:	4d 85 ff             	test   %r15,%r15
  ff4889:	4c 89 a4 24 50 06 00 00 	mov    %r12,0x650(%rsp)
  ff4891:	0f 94 c1             	sete   %cl
  ff4894:	44 08 f1             	or     %r14b,%cl
  ff4897:	75 7c                	jne    ff4915 <ir_optimize_licm+0x455>
  ff4899:	48 8b 5c 24 20       	mov    0x20(%rsp),%rbx
  ff489e:	48 8b 13             	mov    (%rbx),%rdx
  ff48a1:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  ff48a5:	4c 8d 64 11 3f       	lea    0x3f(%rcx,%rdx,1),%r12
  ff48aa:	48 01 d1             	add    %rdx,%rcx
  ff48ad:	49 83 e4 c0          	and    $0xffffffffffffffc0,%r12
  ff48b1:	49 39 cc             	cmp    %rcx,%r12
  ff48b4:	0f 82 62 01 00 00    	jb     ff4a1c <ir_optimize_licm+0x55c>
  ff48ba:	4c 89 e1             	mov    %r12,%rcx
  ff48bd:	48 29 d1             	sub    %rdx,%rcx
  ff48c0:	48 8b 53 10          	mov    0x10(%rbx),%rdx
  ff48c4:	48 29 ca             	sub    %rcx,%rdx
  ff48c7:	40 0f 92 c6          	setb   %sil
  ff48cb:	4c 39 fa             	cmp    %r15,%rdx
  ff48ce:	0f 92 c2             	setb   %dl
  ff48d1:	40 08 f2             	or     %sil,%dl
  ff48d4:	0f 85 42 01 00 00    	jne    ff4a1c <ir_optimize_licm+0x55c>
  ff48da:	4c 01 f9             	add    %r15,%rcx
  ff48dd:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  ff48e1:	48 8b 53 20          	mov    0x20(%rbx),%rdx
  ff48e5:	48 39 d1             	cmp    %rdx,%rcx
  ff48e8:	48 0f 46 ca          	cmovbe %rdx,%rcx
  ff48ec:	48 89 4b 20          	mov    %rcx,0x20(%rbx)
  ff48f0:	4d 85 e4             	test   %r12,%r12
  ff48f3:	0f 84 23 01 00 00    	je     ff4a1c <ir_optimize_licm+0x55c>
  ff48f9:	4c 89 e7             	mov    %r12,%rdi
  ff48fc:	31 f6                	xor    %esi,%esi
  ff48fe:	4c 89 fa             	mov    %r15,%rdx
  ff4901:	e8 da 52 90 ff       	call   8f9be0 <memset@plt>
  ff4906:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  ff490b:	4c 89 a4 24 58 06 00 00 	mov    %r12,0x658(%rsp)
  ff4913:	eb 1f                	jmp    ff4934 <ir_optimize_licm+0x474>
  ff4915:	48 c7 84 24 58 06 00 00 00 00 00 00 	movq   $0x0,0x658(%rsp)
  ff4921:	41 bd 02 00 00 00    	mov    $0x2,%r13d
  ff4927:	84 db                	test   %bl,%bl
  ff4929:	48 8b 5c 24 20       	mov    0x20(%rsp),%rbx
  ff492e:	0f 84 fa 00 00 00    	je     ff4a2e <ir_optimize_licm+0x56e>
  ff4934:	48 8b 8c 24 98 02 00 00 	mov    0x298(%rsp),%rcx
  ff493c:	83 79 38 00          	cmpl   $0x0,0x38(%rcx)
  ff4940:	0f 84 6b 01 00 00    	je     ff4ab1 <ir_optimize_licm+0x5f1>
  ff4946:	31 d2                	xor    %edx,%edx
  ff4948:	31 f6                	xor    %esi,%esi
  ff494a:	eb 14                	jmp    ff4960 <ir_optimize_licm+0x4a0>
  ff494c:	0f 1f 40 00          	nopl   0x0(%rax)
  ff4950:	44 8b 41 38          	mov    0x38(%rcx),%r8d
  ff4954:	48 ff c6             	inc    %rsi
  ff4957:	4c 39 c6             	cmp    %r8,%rsi
  ff495a:	0f 83 54 01 00 00    	jae    ff4ab4 <ir_optimize_licm+0x5f4>
  ff4960:	48 8b bc 24 c8 02 00 00 	mov    0x2c8(%rsp),%rdi
  ff4968:	4c 8b 84 24 38 06 00 00 	mov    0x638(%rsp),%r8
  ff4970:	8b 3c b7             	mov    (%rdi,%rsi,4),%edi
  ff4973:	41 89 3c b0          	mov    %edi,(%r8,%rsi,4)
  ff4977:	48 8b 39             	mov    (%rcx),%rdi
  ff497a:	80 3c 37 02          	cmpb   $0x2,(%rdi,%rsi,1)
  ff497e:	75 d0                	jne    ff4950 <ir_optimize_licm+0x490>
  ff4980:	48 8b bc 24 50 06 00 00 	mov    0x650(%rsp),%rdi
  ff4988:	c6 04 37 01          	movb   $0x1,(%rdi,%rsi,1)
  ff498c:	48 8b bc 24 e8 03 00 00 	mov    0x3e8(%rsp),%rdi
  ff4994:	80 3c 37 00          	cmpb   $0x0,(%rdi,%rsi,1)
  ff4998:	75 b6                	jne    ff4950 <ir_optimize_licm+0x490>
  ff499a:	c6 04 37 01          	movb   $0x1,(%rdi,%rsi,1)
  ff499e:	48 8b bc 24 f0 03 00 00 	mov    0x3f0(%rsp),%rdi
  ff49a6:	44 8b 84 24 fc 03 00 00 	mov    0x3fc(%rsp),%r8d
  ff49ae:	42 89 34 87          	mov    %esi,(%rdi,%r8,4)
  ff49b2:	8b bc 24 fc 03 00 00 	mov    0x3fc(%rsp),%edi
  ff49b9:	ff c7                	inc    %edi
  ff49bb:	89 bc 24 fc 03 00 00 	mov    %edi,0x3fc(%rsp)
  ff49c2:	4c 8b 84 24 98 02 00 00 	mov    0x298(%rsp),%r8
  ff49ca:	41 3b 78 38          	cmp    0x38(%r8),%edi
  ff49ce:	0f 44 fa             	cmove  %edx,%edi
  ff49d1:	89 bc 24 fc 03 00 00 	mov    %edi,0x3fc(%rsp)
  ff49d8:	ff 84 24 00 04 00 00 	incl   0x400(%rsp)
  ff49df:	e9 6c ff ff ff       	jmp    ff4950 <ir_optimize_licm+0x490>
  ff49e4:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  ff49e9:	4c 8b 54 24 30       	mov    0x30(%rsp),%r10
  ff49ee:	4c 8b 44 24 40       	mov    0x40(%rsp),%r8
  ff49f3:	48 c7 84 24 40 06 00 00 00 00 00 00 	movq   $0x0,0x640(%rsp)
  ff49ff:	48 c7 84 24 48 06 00 00 00 00 00 00 	movq   $0x0,0x648(%rsp)
  ff4a0b:	48 8b 5c 24 20       	mov    0x20(%rsp),%rbx
  ff4a10:	48 c7 84 24 50 06 00 00 00 00 00 00 	movq   $0x0,0x650(%rsp)
  ff4a1c:	41 bd 02 00 00 00    	mov    $0x2,%r13d
  ff4a22:	48 c7 84 24 58 06 00 00 00 00 00 00 	movq   $0x0,0x658(%rsp)
  ff4a2e:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
  ff4a32:	62 f1 fe 48 7f 84 24 30 02 00 00 	vmovdqu64 %zmm0,0x230(%rsp)
  ff4a3d:	62 f1 fd 48 7f 44 24 08 	vmovdqa64 %zmm0,0x200(%rsp)
  ff4a45:	62 f1 fd 48 7f 44 24 07 	vmovdqa64 %zmm0,0x1c0(%rsp)
  ff4a4d:	62 f1 fd 48 7f 44 24 06 	vmovdqa64 %zmm0,0x180(%rsp)
  ff4a55:	62 f1 fd 48 7f 44 24 05 	vmovdqa64 %zmm0,0x140(%rsp)
  ff4a5d:	48 8b 8c 24 f8 00 00 00 	mov    0xf8(%rsp),%rcx
  ff4a65:	49 3b 4a 08          	cmp    0x8(%r10),%rcx
  ff4a69:	0f 87 30 28 00 00    	ja     ff729f <ir_optimize_licm+0x2ddf>
  ff4a6f:	49 89 4a 08          	mov    %rcx,0x8(%r10)
  ff4a73:	44 89 e9             	mov    %r13d,%ecx
  ff4a76:	48 8b b4 24 e8 00 00 00 	mov    0xe8(%rsp),%rsi
  ff4a7e:	48 3b 73 08          	cmp    0x8(%rbx),%rsi
  ff4a82:	0f 87 17 28 00 00    	ja     ff729f <ir_optimize_licm+0x2ddf>
  ff4a88:	48 ba 00 00 00 00 ff ff ff ff 	movabs $0xffffffff00000000,%rdx
  ff4a92:	48 89 73 08          	mov    %rsi,0x8(%rbx)
  ff4a96:	48 21 d0             	and    %rdx,%rax
  ff4a99:	4c 89 c2             	mov    %r8,%rdx
  ff4a9c:	48 09 c8             	or     %rcx,%rax
  ff4a9f:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  ff4aa3:	5b                   	pop    %rbx
  ff4aa4:	41 5c                	pop    %r12
  ff4aa6:	41 5d                	pop    %r13
  ff4aa8:	41 5e                	pop    %r14
  ff4aaa:	41 5f                	pop    %r15
  ff4aac:	5d                   	pop    %rbp
  ff4aad:	c5 f8 77             	vzeroupper
  ff4ab0:	c3                   	ret
  ff4ab1:	45 31 c0             	xor    %r8d,%r8d
  ff4ab4:	8b bc 24 00 04 00 00 	mov    0x400(%rsp),%edi
  ff4abb:	85 ff                	test   %edi,%edi
  ff4abd:	0f 84 29 01 00 00    	je     ff4bec <ir_optimize_licm+0x72c>
  ff4ac3:	31 d2                	xor    %edx,%edx
  ff4ac5:	eb 18                	jmp    ff4adf <ir_optimize_licm+0x61f>
  ff4ac7:	66 0f 1f 84 00 00 00 00 00 	nopw   0x0(%rax,%rax,1)
  ff4ad0:	8b bc 24 00 04 00 00 	mov    0x400(%rsp),%edi
  ff4ad7:	85 ff                	test   %edi,%edi
  ff4ad9:	0f 84 09 01 00 00    	je     ff4be8 <ir_optimize_licm+0x728>
  ff4adf:	48 8b b4 24 f0 03 00 00 	mov    0x3f0(%rsp),%rsi
  ff4ae7:	44 8b 84 24 f8 03 00 00 	mov    0x3f8(%rsp),%r8d
  ff4aef:	42 8b 34 86          	mov    (%rsi,%r8,4),%esi
  ff4af3:	41 ff c0             	inc    %r8d
  ff4af6:	44 89 84 24 f8 03 00 00 	mov    %r8d,0x3f8(%rsp)
  ff4afe:	4c 8b 8c 24 98 02 00 00 	mov    0x298(%rsp),%r9
  ff4b06:	4c 8b 94 24 e8 03 00 00 	mov    0x3e8(%rsp),%r10
  ff4b0e:	45 3b 41 38          	cmp    0x38(%r9),%r8d
  ff4b12:	44 0f 44 c2          	cmove  %edx,%r8d
  ff4b16:	ff cf                	dec    %edi
  ff4b18:	44 89 84 24 f8 03 00 00 	mov    %r8d,0x3f8(%rsp)
  ff4b20:	89 bc 24 00 04 00 00 	mov    %edi,0x400(%rsp)
  ff4b27:	41 c6 04 32 00       	movb   $0x0,(%r10,%rsi,1)
  ff4b2c:	4c 8b 84 24 d8 02 00 00 	mov    0x2d8(%rsp),%r8
  ff4b34:	41 8b 3c b0          	mov    (%r8,%rsi,4),%edi
  ff4b38:	41 3b 7c b0 04       	cmp    0x4(%r8,%rsi,4),%edi
  ff4b3d:	72 2a                	jb     ff4b69 <ir_optimize_licm+0x6a9>
  ff4b3f:	eb 8f                	jmp    ff4ad0 <ir_optimize_licm+0x610>
  ff4b41:	66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  ff4b50:	4c 8b 84 24 d8 02 00 00 	mov    0x2d8(%rsp),%r8
  ff4b58:	48 ff c7             	inc    %rdi
  ff4b5b:	45 8b 44 b0 04       	mov    0x4(%r8,%rsi,4),%r8d
  ff4b60:	4c 39 c7             	cmp    %r8,%rdi
  ff4b63:	0f 83 67 ff ff ff    	jae    ff4ad0 <ir_optimize_licm+0x610>
  ff4b69:	4c 8b 84 24 e0 02 00 00 	mov    0x2e0(%rsp),%r8
  ff4b71:	4c 8b 8c 24 50 06 00 00 	mov    0x650(%rsp),%r9
  ff4b79:	45 8b 04 f8          	mov    (%r8,%rdi,8),%r8d
  ff4b7d:	43 80 3c 01 00       	cmpb   $0x0,(%r9,%r8,1)
  ff4b82:	75 cc                	jne    ff4b50 <ir_optimize_licm+0x690>
  ff4b84:	43 c6 04 01 01       	movb   $0x1,(%r9,%r8,1)
  ff4b89:	4c 8b 8c 24 e8 03 00 00 	mov    0x3e8(%rsp),%r9
  ff4b91:	43 80 3c 01 00       	cmpb   $0x0,(%r9,%r8,1)
  ff4b96:	75 b8                	jne    ff4b50 <ir_optimize_licm+0x690>
  ff4b98:	43 c6 04 01 01       	movb   $0x1,(%r9,%r8,1)
  ff4b9d:	4c 8b 8c 24 f0 03 00 00 	mov    0x3f0(%rsp),%r9
  ff4ba5:	44 8b 94 24 fc 03 00 00 	mov    0x3fc(%rsp),%r10d
  ff4bad:	47 89 04 91          	mov    %r8d,(%r9,%r10,4)
  ff4bb1:	44 8b 84 24 fc 03 00 00 	mov    0x3fc(%rsp),%r8d
  ff4bb9:	41 ff c0             	inc    %r8d
  ff4bbc:	44 89 84 24 fc 03 00 00 	mov    %r8d,0x3fc(%rsp)
  ff4bc4:	4c 8b 8c 24 98 02 00 00 	mov    0x298(%rsp),%r9
  ff4bcc:	45 3b 41 38          	cmp    0x38(%r9),%r8d
  ff4bd0:	44 0f 44 c2          	cmove  %edx,%r8d
  ff4bd4:	44 89 84 24 fc 03 00 00 	mov    %r8d,0x3fc(%rsp)
  ff4bdc:	ff 84 24 00 04 00 00 	incl   0x400(%rsp)
  ff4be3:	e9 68 ff ff ff       	jmp    ff4b50 <ir_optimize_licm+0x690>
  ff4be8:	44 8b 41 38          	mov    0x38(%rcx),%r8d
  ff4bec:	45 85 c0             	test   %r8d,%r8d
  ff4bef:	0f 84 86 00 00 00    	je     ff4c7b <ir_optimize_licm+0x7bb>
  ff4bf5:	62 f1 fd 48 6f 05 81 4a 51 ff 	vmovdqa64 -0xaeb57f(%rip),%zmm0        # 509680 <check_builtin_atomic_rmw_test_clang.native_source+0x124d0>
  ff4bff:	48 8b 94 24 48 06 00 00 	mov    0x648(%rsp),%rdx
  ff4c07:	48 8b b4 24 50 06 00 00 	mov    0x650(%rsp),%rsi
  ff4c0f:	45 89 c3             	mov    %r8d,%r11d
  ff4c12:	41 b8 10 00 00 00    	mov    $0x10,%r8d
  ff4c18:	41 b9 ff ff ff ff    	mov    $0xffffffff,%r9d
  ff4c1e:	31 ff                	xor    %edi,%edi
  ff4c20:	45 31 d2             	xor    %r10d,%r10d
  ff4c23:	66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  ff4c30:	49 01 fb             	add    %rdi,%r11
  ff4c33:	48 8b 19             	mov    (%rcx),%rbx
  ff4c36:	49 83 fb 10          	cmp    $0x10,%r11
  ff4c3a:	4d 0f 43 d8          	cmovae %r8,%r11
  ff4c3e:	48 83 c7 f0          	add    $0xfffffffffffffff0,%rdi
  ff4c42:	c4 42 21 f7 d9       	shlx   %r11d,%r9d,%r11d
  ff4c47:	41 f7 d3             	not    %r11d
  ff4c4a:	c4 c1 7b 92 cb       	kmovd  %r11d,%k1
  ff4c4f:	62 b1 7f 89 6f 0c 13 	vmovdqu8 (%rbx,%r10,1),%xmm1{%k1}{z}
  ff4c56:	62 b1 7f 89 6f 14 16 	vmovdqu8 (%rsi,%r10,1),%xmm2{%k1}{z}
  ff4c5d:	62 f2 75 48 8d c8    	vpermb %zmm0,%zmm1,%zmm1
  ff4c63:	c5 e9 df c9          	vpandn %xmm1,%xmm2,%xmm1
  ff4c67:	62 b1 7f 09 7f 0c 12 	vmovdqu8 %xmm1,(%rdx,%r10,1){%k1}
  ff4c6e:	49 83 c2 10          	add    $0x10,%r10
  ff4c72:	44 8b 59 38          	mov    0x38(%rcx),%r11d
  ff4c76:	4d 39 da             	cmp    %r11,%r10
  ff4c79:	72 b5                	jb     ff4c30 <ir_optimize_licm+0x770>
  ff4c7b:	8b 94 24 7c 05 00 00 	mov    0x57c(%rsp),%edx
  ff4c82:	48 85 d2             	test   %rdx,%rdx
  ff4c85:	0f 84 ea 00 00 00    	je     ff4d75 <ir_optimize_licm+0x8b5>
  ff4c8b:	48 8b 5c 24 20       	mov    0x20(%rsp),%rbx
  ff4c90:	4c 8b 54 24 30       	mov    0x30(%rsp),%r10
  ff4c95:	4c 8b 44 24 40       	mov    0x40(%rsp),%r8
  ff4c9a:	41 bd 02 00 00 00    	mov    $0x2,%r13d
  ff4ca0:	48 8b 33             	mov    (%rbx),%rsi
  ff4ca3:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  ff4ca7:	48 8d 7c 31 3f       	lea    0x3f(%rcx,%rsi,1),%rdi
  ff4cac:	48 01 f1             	add    %rsi,%rcx
  ff4caf:	48 83 e7 c0          	and    $0xffffffffffffffc0,%rdi
  ff4cb3:	48 39 cf             	cmp    %rcx,%rdi
  ff4cb6:	0f 82 72 fd ff ff    	jb     ff4a2e <ir_optimize_licm+0x56e>
  ff4cbc:	48 89 f9             	mov    %rdi,%rcx
  ff4cbf:	48 29 f1             	sub    %rsi,%rcx
  ff4cc2:	48 8b 73 10          	mov    0x10(%rbx),%rsi
  ff4cc6:	48 89 bc 24 a8 00 00 00 	mov    %rdi,0xa8(%rsp)
  ff4cce:	48 29 ce             	sub    %rcx,%rsi
  ff4cd1:	0f 82 57 fd ff ff    	jb     ff4a2e <ir_optimize_licm+0x56e>
  ff4cd7:	48 c1 e2 02          	shl    $0x2,%rdx
  ff4cdb:	48 39 f2             	cmp    %rsi,%rdx
  ff4cde:	0f 87 4a fd ff ff    	ja     ff4a2e <ir_optimize_licm+0x56e>
  ff4ce4:	48 01 d1             	add    %rdx,%rcx
  ff4ce7:	4c 8b b4 24 a8 00 00 00 	mov    0xa8(%rsp),%r14
  ff4cef:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  ff4cf3:	48 8b 73 20          	mov    0x20(%rbx),%rsi
  ff4cf7:	48 39 f1             	cmp    %rsi,%rcx
  ff4cfa:	48 0f 46 ce          	cmovbe %rsi,%rcx
  ff4cfe:	48 89 4b 20          	mov    %rcx,0x20(%rbx)
  ff4d02:	4d 85 f6             	test   %r14,%r14
  ff4d05:	0f 84 23 fd ff ff    	je     ff4a2e <ir_optimize_licm+0x56e>
  ff4d0b:	31 db                	xor    %ebx,%ebx
  ff4d0d:	4c 89 f7             	mov    %r14,%rdi
  ff4d10:	31 f6                	xor    %esi,%esi
  ff4d12:	c5 f8 77             	vzeroupper
  ff4d15:	e8 c6 4e 90 ff       	call   8f9be0 <memset@plt>
  ff4d1a:	4c 8b 8c 24 d0 00 00 00 	mov    0xd0(%rsp),%r9
  ff4d22:	eb 1a                	jmp    ff4d3e <ir_optimize_licm+0x87e>
  ff4d24:	31 c0                	xor    %eax,%eax
  ff4d26:	41 89 1c 86          	mov    %ebx,(%r14,%rax,4)
  ff4d2a:	48 ff c3             	inc    %rbx
  ff4d2d:	44 8b 84 24 7c 05 00 00 	mov    0x57c(%rsp),%r8d
  ff4d35:	4c 39 c3             	cmp    %r8,%rbx
  ff4d38:	0f 83 30 04 00 00    	jae    ff516e <ir_optimize_licm+0xcae>
  ff4d3e:	48 89 d8             	mov    %rbx,%rax
  ff4d41:	48 85 db             	test   %rbx,%rbx
  ff4d44:	74 de                	je     ff4d24 <ir_optimize_licm+0x864>
  ff4d46:	66 2e 0f 1f 84 00 00 00 00 00 	cs nopw 0x0(%rax,%rax,1)
  ff4d50:	8d 48 ff             	lea    -0x1(%rax),%ecx
  ff4d53:	48 8b b4 24 08 06 00 00 	mov    0x608(%rsp),%rsi
  ff4d5b:	41 8b 14 8e          	mov    (%r14,%rcx,4),%edx
  ff4d5f:	8b 3c 96             	mov    (%rsi,%rdx,4),%edi
  ff4d62:	3b 3c 9e             	cmp    (%rsi,%rbx,4),%edi
  ff4d65:	76 bf                	jbe    ff4d26 <ir_optimize_licm+0x866>
  ff4d67:	41 89 14 86          	mov    %edx,(%r14,%rax,4)
  ff4d6b:	48 ff c8             	dec    %rax
  ff4d6e:	48 85 c9             	test   %rcx,%rcx
  ff4d71:	75 dd                	jne    ff4d50 <ir_optimize_licm+0x890>
  ff4d73:	eb af                	jmp    ff4d24 <ir_optimize_licm+0x864>
  ff4d75:	4c 8b ac 24 98 02 00 00 	mov    0x298(%rsp),%r13
  ff4d7d:	48 8b 5c 24 20       	mov    0x20(%rsp),%rbx
  ff4d82:	4c 8b 54 24 30       	mov    0x30(%rsp),%r10
  ff4d87:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
  ff4d8b:	62 f1 fe 48 7f 84 24 30 02 00 00 	vmovdqu64 %zmm0,0x230(%rsp)
  ff4d96:	62 f1 fd 48 7f 44 24 08 	vmovdqa64 %zmm0,0x200(%rsp)
  ff4d9e:	62 f1 fd 48 7f 44 24 07 	vmovdqa64 %zmm0,0x1c0(%rsp)
  ff4da6:	62 f1 fd 48 7f 44 24 06 	vmovdqa64 %zmm0,0x180(%rsp)
  ff4dae:	62 f1 fd 48 7f 44 24 05 	vmovdqa64 %zmm0,0x140(%rsp)
  ff4db6:	4c 8b 44 24 40       	mov    0x40(%rsp),%r8
  ff4dbb:	4c 89 6c 24 28       	mov    %r13,0x28(%rsp)
  ff4dc0:	48 8b 0b             	mov    (%rbx),%rcx
  ff4dc3:	48 8b 53 08          	mov    0x8(%rbx),%rdx
  ff4dc7:	4c 8d 74 0a 3f       	lea    0x3f(%rdx,%rcx,1),%r14
  ff4dcc:	48 01 ca             	add    %rcx,%rdx
  ff4dcf:	49 83 e6 c0          	and    $0xffffffffffffffc0,%r14
  ff4dd3:	49 39 d6             	cmp    %rdx,%r14
  ff4dd6:	0f 83 2c 02 00 00    	jae    ff5008 <ir_optimize_licm+0xb48>
  ff4ddc:	31 c9                	xor    %ecx,%ecx
  ff4dde:	49 8d 55 38          	lea    0x38(%r13),%rdx
  ff4de2:	45 31 db             	xor    %r11d,%r11d
  ff4de5:	48 c7 84 24 b8 00 00 00 00 00 00 00 	movq   $0x0,0xb8(%rsp)
  ff4df1:	48 89 4c 24 60       	mov    %rcx,0x60(%rsp)
  ff4df6:	48 c7 84 24 80 00 00 00 00 00 00 00 	movq   $0x0,0x80(%rsp)
  ff4e02:	45 31 f6             	xor    %r14d,%r14d
  ff4e05:	45 31 c9             	xor    %r9d,%r9d
  ff4e08:	48 89 54 24 48       	mov    %rdx,0x48(%rsp)
  ff4e0d:	c4 c1 7c 10 45 70    	vmovups 0x70(%r13),%ymm0
  ff4e13:	49 8b 5d 38          	mov    0x38(%r13),%rbx
  ff4e17:	4d 8b 7d 48          	mov    0x48(%r13),%r15
  ff4e1b:	89 da                	mov    %ebx,%edx
  ff4e1d:	c5 fc 11 84 24 14 01 00 00 	vmovups %ymm0,0x114(%rsp)
  ff4e26:	c4 c1 7c 10 45 5c    	vmovups 0x5c(%r13),%ymm0
  ff4e2c:	c5 fc 29 84 24 00 01 00 00 	vmovaps %ymm0,0x100(%rsp)
  ff4e35:	62 d1 fe 48 6f 85 9c 00 00 00 	vmovdqu64 0x9c(%r13),%zmm0
  ff4e3f:	62 d1 fe 48 6f 8d dc 00 00 00 	vmovdqu64 0xdc(%r13),%zmm1
  ff4e49:	62 d1 fe 48 6f 95 f0 00 00 00 	vmovdqu64 0xf0(%r13),%zmm2
  ff4e53:	62 f1 fd 48 7f 4c 24 20 	vmovdqa64 %zmm1,0x800(%rsp)
  ff4e5b:	62 f1 fd 48 7f 44 24 1f 	vmovdqa64 %zmm0,0x7c0(%rsp)
  ff4e63:	62 f1 fe 48 7f 94 24 14 08 00 00 	vmovdqu64 %zmm2,0x814(%rsp)
  ff4e6e:	45 84 f6             	test   %r14b,%r14b
  ff4e71:	0f 84 b9 00 00 00    	je     ff4f30 <ir_optimize_licm+0xa70>
  ff4e77:	85 db                	test   %ebx,%ebx
  ff4e79:	0f 84 b1 00 00 00    	je     ff4f30 <ir_optimize_licm+0xa70>
  ff4e7f:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  ff4e84:	4d 89 cc             	mov    %r9,%r12
  ff4e87:	41 bd 02 00 00 00    	mov    $0x2,%r13d
  ff4e8d:	48 8b 37             	mov    (%rdi),%rsi
  ff4e90:	48 8b 4f 08          	mov    0x8(%rdi),%rcx
  ff4e94:	4c 8d 4c 31 3f       	lea    0x3f(%rcx,%rsi,1),%r9
  ff4e99:	48 01 f1             	add    %rsi,%rcx
  ff4e9c:	49 83 e1 c0          	and    $0xffffffffffffffc0,%r9
  ff4ea0:	49 39 c9             	cmp    %rcx,%r9
  ff4ea3:	0f 82 37 13 00 00    	jb     ff61e0 <ir_optimize_licm+0x1d20>
  ff4ea9:	4c 89 8c 24 88 00 00 00 	mov    %r9,0x88(%rsp)
  ff4eb1:	49 29 f1             	sub    %rsi,%r9
  ff4eb4:	48 8b 77 10          	mov    0x10(%rdi),%rsi
  ff4eb8:	4c 29 ce             	sub    %r9,%rsi
  ff4ebb:	0f 82 1f 13 00 00    	jb     ff61e0 <ir_optimize_licm+0x1d20>
  ff4ec1:	48 39 d6             	cmp    %rdx,%rsi
  ff4ec4:	0f 82 16 13 00 00    	jb     ff61e0 <ir_optimize_licm+0x1d20>
  ff4eca:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  ff4ecf:	49 01 d1             	add    %rdx,%r9
  ff4ed2:	4c 89 5c 24 70       	mov    %r11,0x70(%rsp)
  ff4ed7:	4c 89 4f 08          	mov    %r9,0x8(%rdi)
  ff4edb:	48 8b 77 20          	mov    0x20(%rdi),%rsi
  ff4edf:	49 39 f1             	cmp    %rsi,%r9
  ff4ee2:	4c 0f 46 ce          	cmovbe %rsi,%r9
  ff4ee6:	48 83 bc 24 88 00 00 00 00 	cmpq   $0x0,0x88(%rsp)
  ff4eef:	4c 89 4f 20          	mov    %r9,0x20(%rdi)
  ff4ef3:	0f 84 e7 12 00 00    	je     ff61e0 <ir_optimize_licm+0x1d20>
  ff4ef9:	48 8b bc 24 88 00 00 00 	mov    0x88(%rsp),%rdi
  ff4f01:	31 f6                	xor    %esi,%esi
  ff4f03:	4c 89 bc 24 d8 00 00 00 	mov    %r15,0xd8(%rsp)
  ff4f0b:	c5 f8 77             	vzeroupper
  ff4f0e:	e8 cd 4c 90 ff       	call   8f9be0 <memset@plt>
  ff4f13:	48 8b 4c 24 48       	mov    0x48(%rsp),%rcx
  ff4f18:	4c 8b 44 24 40       	mov    0x40(%rsp),%r8
  ff4f1d:	4c 8b 54 24 30       	mov    0x30(%rsp),%r10
  ff4f22:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  ff4f27:	4d 89 e1             	mov    %r12,%r9
  ff4f2a:	8b 11                	mov    (%rcx),%edx
  ff4f2c:	89 d1                	mov    %edx,%ecx
  ff4f2e:	eb 1b                	jmp    ff4f4b <ir_optimize_licm+0xa8b>
  ff4f30:	4c 89 bc 24 d8 00 00 00 	mov    %r15,0xd8(%rsp)
  ff4f38:	48 c7 84 24 88 00 00 00 00 00 00 00 	movq   $0x0,0x88(%rsp)
  ff4f44:	4c 89 5c 24 70       	mov    %r11,0x70(%rsp)
  ff4f49:	89 d9                	mov    %ebx,%ecx
  ff4f4b:	85 c9                	test   %ecx,%ecx
  ff4f4d:	45 89 f4             	mov    %r14d,%r12d
  ff4f50:	40 0f 94 c6          	sete   %sil
  ff4f54:	41 80 f4 01          	xor    $0x1,%r12b
  ff4f58:	44 08 e6             	or     %r12b,%sil
  ff4f5b:	0f 85 47 01 00 00    	jne    ff50a8 <ir_optimize_licm+0xbe8>
  ff4f61:	4d 89 cb             	mov    %r9,%r11
  ff4f64:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
  ff4f69:	41 bd 02 00 00 00    	mov    $0x2,%r13d
  ff4f6f:	49 8b 31             	mov    (%r9),%rsi
  ff4f72:	49 8b 49 08          	mov    0x8(%r9),%rcx
  ff4f76:	48 8d 7c 31 3f       	lea    0x3f(%rcx,%rsi,1),%rdi
  ff4f7b:	48 01 f1             	add    %rsi,%rcx
  ff4f7e:	48 83 e7 c0          	and    $0xffffffffffffffc0,%rdi
  ff4f82:	48 39 cf             	cmp    %rcx,%rdi
  ff4f85:	0f 82 55 12 00 00    	jb     ff61e0 <ir_optimize_licm+0x1d20>
  ff4f8b:	48 89 f9             	mov    %rdi,%rcx
  ff4f8e:	48 29 f1             	sub    %rsi,%rcx
  ff4f91:	49 8b 71 10          	mov    0x10(%r9),%rsi
  ff4f95:	48 29 ce             	sub    %rcx,%rsi
  ff4f98:	0f 82 42 12 00 00    	jb     ff61e0 <ir_optimize_licm+0x1d20>
  ff4f9e:	48 39 d6             	cmp    %rdx,%rsi
  ff4fa1:	0f 82 39 12 00 00    	jb     ff61e0 <ir_optimize_licm+0x1d20>
  ff4fa7:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
  ff4fac:	48 01 d1             	add    %rdx,%rcx
  ff4faf:	49 89 49 08          	mov    %rcx,0x8(%r9)
  ff4fb3:	49 8b 71 20          	mov    0x20(%r9),%rsi
  ff4fb7:	48 39 f1             	cmp    %rsi,%rcx
  ff4fba:	48 0f 46 ce          	cmovbe %rsi,%rcx
  ff4fbe:	49 89 49 20          	mov    %rcx,0x20(%r9)
  ff4fc2:	48 85 ff             	test   %rdi,%rdi
  ff4fc5:	0f 84 15 12 00 00    	je     ff61e0 <ir_optimize_licm+0x1d20>
  ff4fcb:	31 f6                	xor    %esi,%esi
  ff4fcd:	48 89 5c 24 58       	mov    %rbx,0x58(%rsp)
  ff4fd2:	4d 89 dd             	mov    %r11,%r13
  ff4fd5:	48 89 fb             	mov    %rdi,%rbx
  ff4fd8:	c5 f8 77             	vzeroupper
  ff4fdb:	e8 00 4c 90 ff       	call   8f9be0 <memset@plt>
  ff4fe0:	48 8b 4c 24 48       	mov    0x48(%rsp),%rcx
  ff4fe5:	49 89 df             	mov    %rbx,%r15
  ff4fe8:	48 8b 5c 24 58       	mov    0x58(%rsp),%rbx
  ff4fed:	4c 8b 44 24 40       	mov    0x40(%rsp),%r8
  ff4ff2:	4c 8b 54 24 30       	mov    0x30(%rsp),%r10
  ff4ff7:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  ff4ffc:	4d 89 e9             	mov    %r13,%r9
  ff4fff:	8b 11                	mov    (%rcx),%edx
  ff5001:	89 d1                	mov    %edx,%ecx
  ff5003:	e9 a3 00 00 00       	jmp    ff50ab <ir_optimize_licm+0xbeb>
  ff5008:	48 8b 7b 10          	mov    0x10(%rbx),%rdi
  ff500c:	4c 89 f6             	mov    %r14,%rsi
  ff500f:	48 29 ce             	sub    %rcx,%rsi
  ff5012:	31 c9                	xor    %ecx,%ecx
  ff5014:	48 29 f7             	sub    %rsi,%rdi
  ff5017:	0f 82 39 0d 00 00    	jb     ff5d56 <ir_optimize_licm+0x1896>
  ff501d:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  ff5022:	41 8b 55 48          	mov    0x48(%r13),%edx
  ff5026:	48 8d 14 95 04 00 00 00 	lea    0x4(,%rdx,4),%rdx
  ff502e:	48 39 fa             	cmp    %rdi,%rdx
  ff5031:	0f 87 a7 fd ff ff    	ja     ff4dde <ir_optimize_licm+0x91e>
  ff5037:	48 01 d6             	add    %rdx,%rsi
  ff503a:	48 89 73 08          	mov    %rsi,0x8(%rbx)
  ff503e:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  ff5042:	48 39 ce             	cmp    %rcx,%rsi
  ff5045:	48 0f 46 f1          	cmovbe %rcx,%rsi
  ff5049:	48 89 73 20          	mov    %rsi,0x20(%rbx)
  ff504d:	4d 85 f6             	test   %r14,%r14
  ff5050:	0f 84 86 fd ff ff    	je     ff4ddc <ir_optimize_licm+0x91c>
  ff5056:	4c 89 f7             	mov    %r14,%rdi
  ff5059:	31 f6                	xor    %esi,%esi
  ff505b:	c5 f8 77             	vzeroupper
  ff505e:	e8 7d 4b 90 ff       	call   8f9be0 <memset@plt>
  ff5063:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  ff5068:	41 8b 55 48          	mov    0x48(%r13),%edx
  ff506c:	48 85 d2             	test   %rdx,%rdx
  ff506f:	0f 84 c8 0d 00 00    	je     ff5e3d <ir_optimize_licm+0x197d>
  ff5075:	48 8b 03             	mov    (%rbx),%rax
  ff5078:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  ff507c:	4c 8b 44 24 40       	mov    0x40(%rsp),%r8
  ff5081:	48 8d 7c 01 3f       	lea    0x3f(%rcx,%rax,1),%rdi
  ff5086:	48 01 c1             	add    %rax,%rcx
  ff5089:	48 83 e7 c0          	and    $0xffffffffffffffc0,%rdi
  ff508d:	48 39 cf             	cmp    %rcx,%rdi
  ff5090:	0f 83 9d 0e 00 00    	jae    ff5f33 <ir_optimize_licm+0x1a73>
  ff5096:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  ff509b:	4c 8b 54 24 30       	mov    0x30(%rsp),%r10
  ff50a0:	4c 89 f1             	mov    %r14,%rcx
  ff50a3:	e9 36 fd ff ff       	jmp    ff4dde <ir_optimize_licm+0x91e>
  ff50a8:	45 31 ff             	xor    %r15d,%r15d
  ff50ab:	85 c9                	test   %ecx,%ecx
  ff50ad:	40 0f 94 c6          	sete   %sil
  ff50b1:	44 08 e6             	or     %r12b,%sil
  ff50b4:	0f 85 ce 0b 00 00    	jne    ff5c88 <ir_optimize_licm+0x17c8>
  ff50ba:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  ff50bf:	4d 89 cb             	mov    %r9,%r11
  ff50c2:	41 bd 02 00 00 00    	mov    $0x2,%r13d
  ff50c8:	48 8b 37             	mov    (%rdi),%rsi
  ff50cb:	48 8b 4f 08          	mov    0x8(%rdi),%rcx
  ff50cf:	4c 8d 4c 31 3f       	lea    0x3f(%rcx,%rsi,1),%r9
  ff50d4:	48 01 f1             	add    %rsi,%rcx
  ff50d7:	49 83 e1 c0          	and    $0xffffffffffffffc0,%r9
  ff50db:	49 39 c9             	cmp    %rcx,%r9
  ff50de:	0f 82 fc 10 00 00    	jb     ff61e0 <ir_optimize_licm+0x1d20>
  ff50e4:	4c 89 8c 24 c0 00 00 00 	mov    %r9,0xc0(%rsp)
  ff50ec:	49 29 f1             	sub    %rsi,%r9
  ff50ef:	48 8b 77 10          	mov    0x10(%rdi),%rsi
  ff50f3:	4c 29 ce             	sub    %r9,%rsi
  ff50f6:	0f 82 e4 10 00 00    	jb     ff61e0 <ir_optimize_licm+0x1d20>
  ff50fc:	48 39 d6             	cmp    %rdx,%rsi
  ff50ff:	0f 82 db 10 00 00    	jb     ff61e0 <ir_optimize_licm+0x1d20>
  ff5105:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  ff510a:	49 01 d1             	add    %rdx,%r9
  ff510d:	4c 89 4f 08          	mov    %r9,0x8(%rdi)
  ff5111:	48 8b 77 20          	mov    0x20(%rdi),%rsi
  ff5115:	49 39 f1             	cmp    %rsi,%r9
  ff5118:	4c 0f 46 ce          	cmovbe %rsi,%r9
  ff511c:	48 83 bc 24 c0 00 00 00 00 	cmpq   $0x0,0xc0(%rsp)
  ff5125:	4c 89 4f 20          	mov    %r9,0x20(%rdi)
  ff5129:	0f 84 b1 10 00 00    	je     ff61e0 <ir_optimize_licm+0x1d20>
  ff512f:	48 8b bc 24 c0 00 00 00 	mov    0xc0(%rsp),%rdi
  ff5137:	31 f6                	xor    %esi,%esi
  ff5139:	4d 89 dd             	mov    %r11,%r13
  ff513c:	48 89 5c 24 58       	mov    %rbx,0x58(%rsp)
  ff5141:	c5 f8 77             	vzeroupper
  ff5144:	e8 97 4a 90 ff       	call   8f9be0 <memset@plt>
  ff5149:	48 8b 4c 24 48       	mov    0x48(%rsp),%rcx
  ff514e:	48 8b 5c 24 58       	mov    0x58(%rsp),%rbx
  ff5153:	4c 8b 44 24 40       	mov    0x40(%rsp),%r8
  ff5158:	4c 8b 54 24 30       	mov    0x30(%rsp),%r10
  ff515d:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  ff5162:	4d 89 e9             	mov    %r13,%r9
  ff5165:	8b 11                	mov    (%rcx),%edx
  ff5167:	89 d1                	mov    %edx,%ecx
  ff5169:	e9 26 0b 00 00       	jmp    ff5c94 <ir_optimize_licm+0x17d4>
  ff516e:	4c 8b ac 24 98 02 00 00 	mov    0x298(%rsp),%r13
  ff5176:	4d 85 c9             	test   %r9,%r9
  ff5179:	0f 94 84 24 98 00 00 00 	sete   0x98(%rsp)
  ff5181:	45 85 c0             	test   %r8d,%r8d
  ff5184:	0f 84 a9 0c 00 00    	je     ff5e33 <ir_optimize_licm+0x1973>
  ff518a:	62 f2 7d 48 58 2d 90 a9 62 ff 	vpbroadcastd -0x9d5670(%rip),%zmm5        # 61fb24 <check_test_member_scaling.timed+0xa74>
  ff5194:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  ff5199:	48 8b 5c 24 20       	mov    0x20(%rsp),%rbx
  ff519e:	4c 8b 54 24 30       	mov    0x30(%rsp),%r10
  ff51a3:	62 f3 4d 48 25 f6 ff 	vpternlogd $0xff,%zmm6,%zmm6,%zmm6
  ff51aa:	45 31 c9             	xor    %r9d,%r9d
  ff51ad:	4c 89 6c 24 28       	mov    %r13,0x28(%rsp)
  ff51b2:	eb 1b                	jmp    ff51cf <ir_optimize_licm+0xd0f>
  ff51b4:	ff 84 24 98 07 00 00 	incl   0x798(%rsp)
  ff51bb:	44 8b 84 24 7c 05 00 00 	mov    0x57c(%rsp),%r8d
  ff51c3:	49 ff c1             	inc    %r9
  ff51c6:	4d 39 c1             	cmp    %r8,%r9
  ff51c9:	0f 83 7a 0b 00 00    	jae    ff5d49 <ir_optimize_licm+0x1889>
  ff51cf:	48 8b 8c 24 a8 00 00 00 	mov    0xa8(%rsp),%rcx
  ff51d7:	48 8b 94 24 f8 05 00 00 	mov    0x5f8(%rsp),%rdx
  ff51df:	48 8b b4 24 b8 02 00 00 	mov    0x2b8(%rsp),%rsi
  ff51e7:	42 8b 0c 89          	mov    (%rcx,%r9,4),%ecx
  ff51eb:	8b 14 8a             	mov    (%rdx,%rcx,4),%edx
  ff51ee:	44 8b 3c 96          	mov    (%rsi,%rdx,4),%r15d
  ff51f2:	8b 7c 96 04          	mov    0x4(%rsi,%rdx,4),%edi
  ff51f6:	41 39 ff             	cmp    %edi,%r15d
  ff51f9:	73 b9                	jae    ff51b4 <ir_optimize_licm+0xcf4>
  ff51fb:	48 8b b4 24 c0 02 00 00 	mov    0x2c0(%rsp),%rsi
  ff5203:	48 8b 94 24 c8 05 00 00 	mov    0x5c8(%rsp),%rdx
  ff520b:	4c 89 8c 24 a0 00 00 00 	mov    %r9,0xa0(%rsp)
  ff5213:	44 39 c1             	cmp    %r8d,%ecx
  ff5216:	73 44                	jae    ff525c <ir_optimize_licm+0xd9c>
  ff5218:	4c 8b 94 24 88 05 00 00 	mov    0x588(%rsp),%r10
  ff5220:	44 8b 8c 24 70 05 00 00 	mov    0x570(%rsp),%r9d
  ff5228:	4d 89 f8             	mov    %r15,%r8
  ff522b:	49 29 f8             	sub    %rdi,%r8
  ff522e:	4c 29 ff             	sub    %r15,%rdi
  ff5231:	41 89 fb             	mov    %edi,%r11d
  ff5234:	41 83 e3 03          	and    $0x3,%r11d
  ff5238:	4c 0f af d1          	imul   %rcx,%r10
  ff523c:	49 c1 e2 03          	shl    $0x3,%r10
  ff5240:	4c 03 94 24 10 06 00 00 	add    0x610(%rsp),%r10
  ff5248:	49 83 f8 fc          	cmp    $0xfffffffffffffffc,%r8
  ff524c:	76 2f                	jbe    ff527d <ir_optimize_licm+0xdbd>
  ff524e:	45 31 c0             	xor    %r8d,%r8d
  ff5251:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  ff5257:	e9 06 02 00 00       	jmp    ff5462 <ir_optimize_licm+0xfa2>
  ff525c:	49 89 fa             	mov    %rdi,%r10
  ff525f:	4d 29 fa             	sub    %r15,%r10
  ff5262:	49 83 fa 10          	cmp    $0x10,%r10
  ff5266:	0f 83 63 01 00 00    	jae    ff53cf <ir_optimize_licm+0xf0f>
  ff526c:	45 31 c0             	xor    %r8d,%r8d
  ff526f:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  ff5275:	4d 89 f9             	mov    %r15,%r9
  ff5278:	e9 e5 02 00 00       	jmp    ff5562 <ir_optimize_licm+0x10a2>
  ff527d:	48 83 e7 fc          	and    $0xfffffffffffffffc,%rdi
  ff5281:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  ff5287:	45 31 c0             	xor    %r8d,%r8d
  ff528a:	eb 11                	jmp    ff529d <ir_optimize_licm+0xddd>
  ff528c:	41 89 dd             	mov    %ebx,%r13d
  ff528f:	49 83 c7 04          	add    $0x4,%r15
  ff5293:	48 83 c7 fc          	add    $0xfffffffffffffffc,%rdi
  ff5297:	0f 84 bc 01 00 00    	je     ff5459 <ir_optimize_licm+0xf99>
  ff529d:	42 8b 1c be          	mov    (%rsi,%r15,4),%ebx
  ff52a1:	83 3c 9a ff          	cmpl   $0xffffffff,(%rdx,%rbx,4)
  ff52a5:	74 39                	je     ff52e0 <ir_optimize_licm+0xe20>
  ff52a7:	44 39 cb             	cmp    %r9d,%ebx
  ff52aa:	73 7b                	jae    ff5327 <ir_optimize_licm+0xe67>
  ff52ac:	41 89 de             	mov    %ebx,%r14d
  ff52af:	41 c1 ee 06          	shr    $0x6,%r14d
  ff52b3:	c4 02 e3 f7 34 f2    	shrx   %rbx,(%r10,%r14,8),%r14
  ff52b9:	45 89 f4             	mov    %r14d,%r12d
  ff52bc:	41 f6 d4             	not    %r12b
  ff52bf:	45 0f b6 e4          	movzbl %r12b,%r12d
  ff52c3:	41 83 e4 01          	and    $0x1,%r12d
  ff52c7:	45 01 e0             	add    %r12d,%r8d
  ff52ca:	41 f6 c6 01          	test   $0x1,%r14b
  ff52ce:	41 0f 45 dd          	cmovne %r13d,%ebx
  ff52d2:	46 8b 74 be 04       	mov    0x4(%rsi,%r15,4),%r14d
  ff52d7:	42 83 3c b2 ff       	cmpl   $0xffffffff,(%rdx,%r14,4)
  ff52dc:	75 11                	jne    ff52ef <ir_optimize_licm+0xe2f>
  ff52de:	eb 56                	jmp    ff5336 <ir_optimize_licm+0xe76>
  ff52e0:	44 89 eb             	mov    %r13d,%ebx
  ff52e3:	46 8b 74 be 04       	mov    0x4(%rsi,%r15,4),%r14d
  ff52e8:	42 83 3c b2 ff       	cmpl   $0xffffffff,(%rdx,%r14,4)
  ff52ed:	74 47                	je     ff5336 <ir_optimize_licm+0xe76>
  ff52ef:	45 39 ce             	cmp    %r9d,%r14d
  ff52f2:	73 7d                	jae    ff5371 <ir_optimize_licm+0xeb1>
  ff52f4:	45 89 f4             	mov    %r14d,%r12d
  ff52f7:	41 c1 ec 06          	shr    $0x6,%r12d
  ff52fb:	c4 02 8b f7 24 e2    	shrx   %r14,(%r10,%r12,8),%r12
  ff5301:	45 89 e5             	mov    %r12d,%r13d
  ff5304:	41 f6 d5             	not    %r13b
  ff5307:	45 0f b6 ed          	movzbl %r13b,%r13d
  ff530b:	41 83 e5 01          	and    $0x1,%r13d
  ff530f:	45 01 e8             	add    %r13d,%r8d
  ff5312:	41 f6 c4 01          	test   $0x1,%r12b
  ff5316:	44 0f 45 f3          	cmovne %ebx,%r14d
  ff531a:	42 8b 5c be 08       	mov    0x8(%rsi,%r15,4),%ebx
  ff531f:	83 3c 9a ff          	cmpl   $0xffffffff,(%rdx,%rbx,4)
  ff5323:	75 1f                	jne    ff5344 <ir_optimize_licm+0xe84>
  ff5325:	eb 58                	jmp    ff537f <ir_optimize_licm+0xebf>
  ff5327:	41 ff c0             	inc    %r8d
  ff532a:	46 8b 74 be 04       	mov    0x4(%rsi,%r15,4),%r14d
  ff532f:	42 83 3c b2 ff       	cmpl   $0xffffffff,(%rdx,%r14,4)
  ff5334:	75 b9                	jne    ff52ef <ir_optimize_licm+0xe2f>
  ff5336:	41 89 de             	mov    %ebx,%r14d
  ff5339:	42 8b 5c be 08       	mov    0x8(%rsi,%r15,4),%ebx
  ff533e:	83 3c 9a ff          	cmpl   $0xffffffff,(%rdx,%rbx,4)
  ff5342:	74 3b                	je     ff537f <ir_optimize_licm+0xebf>
  ff5344:	44 39 cb             	cmp    %r9d,%ebx
  ff5347:	73 3b                	jae    ff5384 <ir_optimize_licm+0xec4>
  ff5349:	41 89 dc             	mov    %ebx,%r12d
  ff534c:	41 c1 ec 06          	shr    $0x6,%r12d
  ff5350:	c4 02 e3 f7 24 e2    	shrx   %rbx,(%r10,%r12,8),%r12
  ff5356:	45 89 e5             	mov    %r12d,%r13d
  ff5359:	41 f6 d5             	not    %r13b
  ff535c:	45 0f b6 ed          	movzbl %r13b,%r13d
  ff5360:	41 83 e5 01          	and    $0x1,%r13d
  ff5364:	45 01 e8             	add    %r13d,%r8d
  ff5367:	41 f6 c4 01          	test   $0x1,%r12b
  ff536b:	41 0f 45 de          	cmovne %r14d,%ebx
  ff536f:	eb 16                	jmp    ff5387 <ir_optimize_licm+0xec7>
  ff5371:	41 ff c0             	inc    %r8d
  ff5374:	42 8b 5c be 08       	mov    0x8(%rsi,%r15,4),%ebx
  ff5379:	83 3c 9a ff          	cmpl   $0xffffffff,(%rdx,%rbx,4)
  ff537d:	75 c5                	jne    ff5344 <ir_optimize_licm+0xe84>
  ff537f:	44 89 f3             	mov    %r14d,%ebx
  ff5382:	eb 03                	jmp    ff5387 <ir_optimize_licm+0xec7>
  ff5384:	41 ff c0             	inc    %r8d
  ff5387:	46 8b 6c be 0c       	mov    0xc(%rsi,%r15,4),%r13d
  ff538c:	42 83 3c aa ff       	cmpl   $0xffffffff,(%rdx,%r13,4)
  ff5391:	0f 84 f5 fe ff ff    	je     ff528c <ir_optimize_licm+0xdcc>
  ff5397:	45 39 cd             	cmp    %r9d,%r13d
  ff539a:	73 2b                	jae    ff53c7 <ir_optimize_licm+0xf07>
  ff539c:	45 89 ee             	mov    %r13d,%r14d
  ff539f:	41 c1 ee 06          	shr    $0x6,%r14d
  ff53a3:	c4 02 93 f7 34 f2    	shrx   %r13,(%r10,%r14,8),%r14
  ff53a9:	45 89 f4             	mov    %r14d,%r12d
  ff53ac:	41 f6 d4             	not    %r12b
  ff53af:	45 0f b6 e4          	movzbl %r12b,%r12d
  ff53b3:	41 83 e4 01          	and    $0x1,%r12d
  ff53b7:	45 01 e0             	add    %r12d,%r8d
  ff53ba:	41 f6 c6 01          	test   $0x1,%r14b
  ff53be:	44 0f 45 eb          	cmovne %ebx,%r13d
  ff53c2:	e9 c8 fe ff ff       	jmp    ff528f <ir_optimize_licm+0xdcf>
  ff53c7:	41 ff c0             	inc    %r8d
  ff53ca:	e9 c0 fe ff ff       	jmp    ff528f <ir_optimize_licm+0xdcf>
  ff53cf:	4d 89 d3             	mov    %r10,%r11
  ff53d2:	49 83 e3 f0          	and    $0xfffffffffffffff0,%r11
  ff53d6:	4e 8d 04 be          	lea    (%rsi,%r15,4),%r8
  ff53da:	c5 fc 47 c8          	kxorw  %k0,%k0,%k1
  ff53de:	62 f3 75 48 25 c9 ff 	vpternlogd $0xff,%zmm1,%zmm1,%zmm1
  ff53e5:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
  ff53e9:	31 db                	xor    %ebx,%ebx
  ff53eb:	4f 8d 0c 3b          	lea    (%r11,%r15,1),%r9
  ff53ef:	eb 19                	jmp    ff540a <ir_optimize_licm+0xf4a>
  ff53f1:	62 f2 7e 48 38 d0    	vpmovm2d %k0,%zmm2
  ff53f7:	62 f1 7d 48 fa c2    	vpsubd %zmm2,%zmm0,%zmm0
  ff53fd:	48 83 c3 10          	add    $0x10,%rbx
  ff5401:	49 39 db             	cmp    %rbx,%r11
  ff5404:	0f 84 b2 00 00 00    	je     ff54bc <ir_optimize_licm+0xffc>
  ff540a:	62 d2 7d 48 35 1c 98 	vpmovzxdq (%r8,%rbx,4),%zmm3
  ff5411:	62 d2 7d 48 35 54 98 01 	vpmovzxdq 0x20(%r8,%rbx,4),%zmm2
  ff5419:	c5 fd 46 d0          	kxnorb %k0,%k0,%k2
  ff541d:	c5 d9 ef e4          	vpxor  %xmm4,%xmm4,%xmm4
  ff5421:	62 f2 7d 4a 91 24 9a 	vpgatherqd (%rdx,%zmm3,4),%ymm4{%k2}
  ff5428:	c5 fd 46 d0          	kxnorb %k0,%k0,%k2
  ff542c:	c5 e1 ef db          	vpxor  %xmm3,%xmm3,%xmm3
  ff5430:	62 f2 7d 4a 91 1c 92 	vpgatherqd (%rdx,%zmm2,4),%ymm3{%k2}
  ff5437:	62 f3 dd 48 3a d3 01 	vinserti64x4 $0x1,%ymm3,%zmm4,%zmm2
  ff543e:	62 f3 6d 48 1f c6 04 	vpcmpneqd %zmm6,%zmm2,%k0
  ff5445:	c5 f8 98 c0          	kortestw %k0,%k0
  ff5449:	74 a6                	je     ff53f1 <ir_optimize_licm+0xf31>
  ff544b:	62 d1 fe 48 6f 0c 98 	vmovdqu64 (%r8,%rbx,4),%zmm1
  ff5452:	c4 e1 f8 90 c8       	kmovq  %k0,%k1
  ff5457:	eb 98                	jmp    ff53f1 <ir_optimize_licm+0xf31>
  ff5459:	4d 85 db             	test   %r11,%r11
  ff545c:	0f 84 1f 01 00 00    	je     ff5581 <ir_optimize_licm+0x10c1>
  ff5462:	4a 8d 34 be          	lea    (%rsi,%r15,4),%rsi
  ff5466:	44 89 eb             	mov    %r13d,%ebx
  ff5469:	31 ff                	xor    %edi,%edi
  ff546b:	eb 12                	jmp    ff547f <ir_optimize_licm+0xfbf>
  ff546d:	41 89 dd             	mov    %ebx,%r13d
  ff5470:	48 ff c7             	inc    %rdi
  ff5473:	44 89 eb             	mov    %r13d,%ebx
  ff5476:	49 39 fb             	cmp    %rdi,%r11
  ff5479:	0f 84 02 01 00 00    	je     ff5581 <ir_optimize_licm+0x10c1>
  ff547f:	44 8b 2c be          	mov    (%rsi,%rdi,4),%r13d
  ff5483:	42 83 3c aa ff       	cmpl   $0xffffffff,(%rdx,%r13,4)
  ff5488:	74 e3                	je     ff546d <ir_optimize_licm+0xfad>
  ff548a:	45 39 cd             	cmp    %r9d,%r13d
  ff548d:	73 28                	jae    ff54b7 <ir_optimize_licm+0xff7>
  ff548f:	45 89 ee             	mov    %r13d,%r14d
  ff5492:	41 c1 ee 06          	shr    $0x6,%r14d
  ff5496:	c4 02 93 f7 34 f2    	shrx   %r13,(%r10,%r14,8),%r14
  ff549c:	45 89 f7             	mov    %r14d,%r15d
  ff549f:	41 f6 d7             	not    %r15b
  ff54a2:	45 0f b6 ff          	movzbl %r15b,%r15d
  ff54a6:	41 83 e7 01          	and    $0x1,%r15d
  ff54aa:	45 01 f8             	add    %r15d,%r8d
  ff54ad:	41 f6 c6 01          	test   $0x1,%r14b
  ff54b1:	44 0f 45 eb          	cmovne %ebx,%r13d
  ff54b5:	eb b9                	jmp    ff5470 <ir_optimize_licm+0xfb0>
  ff54b7:	41 ff c0             	inc    %r8d
  ff54ba:	eb b4                	jmp    ff5470 <ir_optimize_licm+0xfb0>
  ff54bc:	62 f1 fd 48 7f 4c 24 2b 	vmovdqa64 %zmm1,0xac0(%rsp)
  ff54c4:	c5 f1 76 c9          	vpcmpeqd %xmm1,%xmm1,%xmm1
  ff54c8:	c4 e3 f9 30 c1 08    	kshiftrw $0x8,%k1,%k0
  ff54ce:	62 f2 75 09 66 0d b8 55 61 ff 	vpblendmb -0x9eaa48(%rip),%xmm1,%xmm1{%k1}        # 60aa90 <tier0_program_class_type.types+0x3b70>
  ff54d8:	c5 f5 45 c0          	korb   %k0,%k1,%k0
  ff54dc:	c4 e3 79 30 d0 04    	kshiftrb $0x4,%k0,%k2
  ff54e2:	c5 fc 45 c2          	korw   %k2,%k0,%k0
  ff54e6:	c4 e3 79 30 d0 02    	kshiftrb $0x2,%k0,%k2
  ff54ec:	c5 fc 45 c2          	korw   %k2,%k0,%k0
  ff54f0:	c4 e3 79 30 d0 01    	kshiftrb $0x1,%k0,%k2
  ff54f6:	c5 fc 45 c2          	korw   %k2,%k0,%k0
  ff54fa:	c5 7b 93 c0          	kmovd  %k0,%r8d
  ff54fe:	c5 e9 71 d1 08       	vpsrlw $0x8,%xmm1,%xmm2
  ff5503:	41 80 e0 01          	and    $0x1,%r8b
  ff5507:	c5 f1 da ca          	vpminub %xmm2,%xmm1,%xmm1
  ff550b:	41 80 f8 01          	cmp    $0x1,%r8b
  ff550f:	c4 e2 79 41 c9       	vphminposuw %xmm1,%xmm1
  ff5514:	45 19 ed             	sbb    %r13d,%r13d
  ff5517:	c4 c1 79 7e c8       	vmovd  %xmm1,%r8d
  ff551c:	62 f3 fd 48 3b c1 01 	vextracti64x4 $0x1,%zmm0,%ymm1
  ff5523:	41 f6 d0             	not    %r8b
  ff5526:	62 f1 7d 48 fe c1    	vpaddd %zmm1,%zmm0,%zmm0
  ff552c:	45 0f b6 c0          	movzbl %r8b,%r8d
  ff5530:	c4 e3 7d 39 c1 01    	vextracti128 $0x1,%ymm0,%xmm1
  ff5536:	c5 f9 fe c1          	vpaddd %xmm1,%xmm0,%xmm0
  ff553a:	41 83 e0 0f          	and    $0xf,%r8d
  ff553e:	c5 f9 70 c8 ee       	vpshufd $0xee,%xmm0,%xmm1
  ff5543:	46 0b ac 84 c0 0a 00 00 	or     0xac0(%rsp,%r8,4),%r13d
  ff554b:	c5 f9 fe c1          	vpaddd %xmm1,%xmm0,%xmm0
  ff554f:	c5 f9 70 c8 55       	vpshufd $0x55,%xmm0,%xmm1
  ff5554:	c5 f9 fe c1          	vpaddd %xmm1,%xmm0,%xmm0
  ff5558:	c4 c1 79 7e c0       	vmovd  %xmm0,%r8d
  ff555d:	4d 39 da             	cmp    %r11,%r10
  ff5560:	74 1f                	je     ff5581 <ir_optimize_licm+0x10c1>
  ff5562:	46 8b 14 8e          	mov    (%rsi,%r9,4),%r10d
  ff5566:	45 31 db             	xor    %r11d,%r11d
  ff5569:	42 83 3c 92 ff       	cmpl   $0xffffffff,(%rdx,%r10,4)
  ff556e:	41 0f 95 c3          	setne  %r11b
  ff5572:	45 0f 45 ea          	cmovne %r10d,%r13d
  ff5576:	49 ff c1             	inc    %r9
  ff5579:	45 01 d8             	add    %r11d,%r8d
  ff557c:	4c 39 cf             	cmp    %r9,%rdi
  ff557f:	75 e1                	jne    ff5562 <ir_optimize_licm+0x10a2>
  ff5581:	48 8b 94 24 30 06 00 00 	mov    0x630(%rsp),%rdx
  ff5589:	48 8b 5c 24 20       	mov    0x20(%rsp),%rbx
  ff558e:	4c 8b 54 24 30       	mov    0x30(%rsp),%r10
  ff5593:	4c 8b 8c 24 a0 00 00 00 	mov    0xa0(%rsp),%r9
  ff559b:	80 3c 0a 00          	cmpb   $0x0,(%rdx,%rcx,1)
  ff559f:	0f 85 0f fc ff ff    	jne    ff51b4 <ir_optimize_licm+0xcf4>
  ff55a5:	41 83 f8 01          	cmp    $0x1,%r8d
  ff55a9:	0f 85 05 fc ff ff    	jne    ff51b4 <ir_optimize_licm+0xcf4>
  ff55af:	48 8b b4 24 a8 02 00 00 	mov    0x2a8(%rsp),%rsi
  ff55b7:	44 89 ea             	mov    %r13d,%edx
  ff55ba:	8b 7c 96 04          	mov    0x4(%rsi,%rdx,4),%edi
  ff55be:	2b 3c 96             	sub    (%rsi,%rdx,4),%edi
  ff55c1:	83 ff 01             	cmp    $0x1,%edi
  ff55c4:	0f 85 ea fb ff ff    	jne    ff51b4 <ir_optimize_licm+0xcf4>
  ff55ca:	41 83 fd ff          	cmp    $0xffffffff,%r13d
  ff55ce:	0f 84 e0 fb ff ff    	je     ff51b4 <ir_optimize_licm+0xcf4>
  ff55d4:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  ff55d9:	ff 84 24 94 07 00 00 	incl   0x794(%rsp)
  ff55e0:	4c 8b 94 24 d0 00 00 00 	mov    0xd0(%rsp),%r10
  ff55e8:	4c 89 6c 24 78       	mov    %r13,0x78(%rsp)
  ff55ed:	49 bd ff ff ff ff ff 9b f7 ff 	movabs $0xfff79bffffffffff,%r13
  ff55f7:	83 78 38 00          	cmpl   $0x0,0x38(%rax)
  ff55fb:	0f 84 05 01 00 00    	je     ff5706 <ir_optimize_licm+0x1246>
  ff5601:	31 c0                	xor    %eax,%eax
  ff5603:	eb 31                	jmp    ff5636 <ir_optimize_licm+0x1176>
  ff5605:	48 8b b4 24 48 06 00 00 	mov    0x648(%rsp),%rsi
  ff560d:	80 3c 06 00          	cmpb   $0x0,(%rsi,%rax,1)
  ff5611:	0f 95 04 07          	setne  (%rdi,%rax,1)
  ff5615:	31 f6                	xor    %esi,%esi
  ff5617:	48 8b bc 24 40 06 00 00 	mov    0x640(%rsp),%rdi
  ff561f:	89 34 87             	mov    %esi,(%rdi,%rax,4)
  ff5622:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  ff5627:	48 ff c0             	inc    %rax
  ff562a:	8b 77 38             	mov    0x38(%rdi),%esi
  ff562d:	48 39 f0             	cmp    %rsi,%rax
  ff5630:	0f 83 d0 00 00 00    	jae    ff5706 <ir_optimize_licm+0x1246>
  ff5636:	3b 8c 24 7c 05 00 00 	cmp    0x57c(%rsp),%ecx
  ff563d:	73 47                	jae    ff5686 <ir_optimize_licm+0x11c6>
  ff563f:	48 8b b4 24 38 06 00 00 	mov    0x638(%rsp),%rsi
  ff5647:	8b 34 86             	mov    (%rsi,%rax,4),%esi
  ff564a:	3b b4 24 70 05 00 00 	cmp    0x570(%rsp),%esi
  ff5651:	73 33                	jae    ff5686 <ir_optimize_licm+0x11c6>
  ff5653:	48 8b bc 24 88 05 00 00 	mov    0x588(%rsp),%rdi
  ff565b:	41 89 f0             	mov    %esi,%r8d
  ff565e:	41 c1 e8 06          	shr    $0x6,%r8d
  ff5662:	48 0f af f9          	imul   %rcx,%rdi
  ff5666:	48 c1 e7 03          	shl    $0x3,%rdi
  ff566a:	48 03 bc 24 10 06 00 00 	add    0x610(%rsp),%rdi
  ff5672:	4e 8b 04 c7          	mov    (%rdi,%r8,8),%r8
  ff5676:	48 8b bc 24 58 06 00 00 	mov    0x658(%rsp),%rdi
  ff567e:	49 0f a3 f0          	bt     %rsi,%r8
  ff5682:	72 81                	jb     ff5605 <ir_optimize_licm+0x1145>
  ff5684:	eb 08                	jmp    ff568e <ir_optimize_licm+0x11ce>
  ff5686:	48 8b bc 24 58 06 00 00 	mov    0x658(%rsp),%rdi
  ff568e:	c6 04 07 00          	movb   $0x0,(%rdi,%rax,1)
  ff5692:	48 8b b4 24 38 06 00 00 	mov    0x638(%rsp),%rsi
  ff569a:	44 8b 84 24 70 05 00 00 	mov    0x570(%rsp),%r8d
  ff56a2:	8b 3c 86             	mov    (%rsi,%rax,4),%edi
  ff56a5:	31 f6                	xor    %esi,%esi
  ff56a7:	44 39 c7             	cmp    %r8d,%edi
  ff56aa:	0f 83 67 ff ff ff    	jae    ff5617 <ir_optimize_licm+0x1157>
  ff56b0:	44 39 44 24 78       	cmp    %r8d,0x78(%rsp)
  ff56b5:	0f 83 5c ff ff ff    	jae    ff5617 <ir_optimize_licm+0x1157>
  ff56bb:	4c 8b 84 24 b8 05 00 00 	mov    0x5b8(%rsp),%r8
  ff56c3:	41 83 3c b8 ff       	cmpl   $0xffffffff,(%r8,%rdi,4)
  ff56c8:	0f 84 49 ff ff ff    	je     ff5617 <ir_optimize_licm+0x1157>
  ff56ce:	41 83 3c 90 ff       	cmpl   $0xffffffff,(%r8,%rdx,4)
  ff56d3:	0f 84 3e ff ff ff    	je     ff5617 <ir_optimize_licm+0x1157>
  ff56d9:	4c 8b 8c 24 e0 05 00 00 	mov    0x5e0(%rsp),%r9
  ff56e1:	45 8b 04 91          	mov    (%r9,%rdx,4),%r8d
  ff56e5:	45 39 04 b9          	cmp    %r8d,(%r9,%rdi,4)
  ff56e9:	0f 87 28 ff ff ff    	ja     ff5617 <ir_optimize_licm+0x1157>
  ff56ef:	4c 8b 8c 24 e8 05 00 00 	mov    0x5e8(%rsp),%r9
  ff56f7:	31 f6                	xor    %esi,%esi
  ff56f9:	45 3b 04 b9          	cmp    (%r9,%rdi,4),%r8d
  ff56fd:	40 0f 92 c6          	setb   %sil
  ff5701:	e9 11 ff ff ff       	jmp    ff5617 <ir_optimize_licm+0x1157>
  ff5706:	48 8b 8c 24 98 02 00 00 	mov    0x298(%rsp),%rcx
  ff570e:	4d 85 d2             	test   %r10,%r10
  ff5711:	0f 95 c0             	setne  %al
  ff5714:	8b 51 38             	mov    0x38(%rcx),%edx
  ff5717:	85 d2                	test   %edx,%edx
  ff5719:	48 89 54 24 68       	mov    %rdx,0x68(%rsp)
  ff571e:	0f 98 c2             	sets   %dl
  ff5721:	08 c2                	or     %al,%dl
  ff5723:	74 14                	je     ff5739 <ir_optimize_licm+0x1279>
  ff5725:	0f b6 84 24 b8 07 00 00 	movzbl 0x7b8(%rsp),%eax
  ff572d:	0a 84 24 98 00 00 00 	or     0x98(%rsp),%al
  ff5734:	e9 c0 04 00 00       	jmp    ff5bf9 <ir_optimize_licm+0x1739>
  ff5739:	83 bc 24 88 00 00 00 00 	cmpl   $0x0,0x88(%rsp)
  ff5741:	b0 01                	mov    $0x1,%al
  ff5743:	0f 84 b0 04 00 00    	je     ff5bf9 <ir_optimize_licm+0x1739>
  ff5749:	4c 8b 84 24 40 06 00 00 	mov    0x640(%rsp),%r8
  ff5751:	48 8b 84 24 58 06 00 00 	mov    0x658(%rsp),%rax
  ff5759:	45 31 c9             	xor    %r9d,%r9d
  ff575c:	48 89 84 24 d8 00 00 00 	mov    %rax,0xd8(%rsp)
  ff5764:	4c 89 44 24 50       	mov    %r8,0x50(%rsp)
  ff5769:	8b 71 38             	mov    0x38(%rcx),%esi
  ff576c:	ba 00 00 00 00       	mov    $0x0,%edx
  ff5771:	48 85 f6             	test   %rsi,%rsi
  ff5774:	0f 84 4f 04 00 00    	je     ff5bc9 <ir_optimize_licm+0x1709>
  ff577a:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  ff5780:	45 31 d2             	xor    %r10d,%r10d
  ff5783:	31 c0                	xor    %eax,%eax
  ff5785:	45 31 f6             	xor    %r14d,%r14d
  ff5788:	31 d2                	xor    %edx,%edx
  ff578a:	44 89 4c 24 58       	mov    %r9d,0x58(%rsp)
  ff578f:	e9 fd 00 00 00       	jmp    ff5891 <ir_optimize_licm+0x13d1>
  ff5794:	66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  ff57a0:	31 ff                	xor    %edi,%edi
  ff57a2:	45 31 ff             	xor    %r15d,%r15d
  ff57a5:	45 31 e4             	xor    %r12d,%r12d
  ff57a8:	44 89 e6             	mov    %r12d,%esi
  ff57ab:	21 d6                	and    %edx,%esi
  ff57ad:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
  ff57b1:	41 f7 d4             	not    %r12d
  ff57b4:	4c 8b b4 24 b8 00 00 00 	mov    0xb8(%rsp),%r14
  ff57bc:	4c 8b 5c 24 60       	mov    0x60(%rsp),%r11
  ff57c1:	48 83 c0 40          	add    $0x40,%rax
  ff57c5:	c5 fb 92 ce          	kmovd  %esi,%k1
  ff57c9:	48 8b 71 20          	mov    0x20(%rcx),%rsi
  ff57cd:	49 83 c6 f0          	add    $0xfffffffffffffff0,%r14
  ff57d1:	49 83 c3 10          	add    $0x10,%r11
  ff57d5:	62 b1 7e c9 6f 04 96 	vmovdqu32 (%rsi,%r10,4),%zmm0{%k1}{z}
  ff57dc:	62 d2 7d 49 90 0c 80 	vpgatherdd (%r8,%zmm0,4),%zmm1{%k1}
  ff57e3:	62 f2 75 48 27 c1    	vptestmd %zmm1,%zmm1,%k0
  ff57e9:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
  ff57ed:	c5 fb 93 f0          	kmovd  %k0,%esi
  ff57f1:	41 09 f4             	or     %esi,%r12d
  ff57f4:	41 21 d4             	and    %edx,%r12d
  ff57f7:	48 8b 94 24 80 00 00 00 	mov    0x80(%rsp),%rdx
  ff57ff:	44 89 e6             	mov    %r12d,%esi
  ff5802:	44 21 fe             	and    %r15d,%esi
  ff5805:	41 f7 d7             	not    %r15d
  ff5808:	c5 fb 92 ce          	kmovd  %esi,%k1
  ff580c:	48 8b 71 28          	mov    0x28(%rcx),%rsi
  ff5810:	62 b1 7e c9 6f 04 96 	vmovdqu32 (%rsi,%r10,4),%zmm0{%k1}{z}
  ff5817:	62 d2 7d 49 90 0c 80 	vpgatherdd (%r8,%zmm0,4),%zmm1{%k1}
  ff581e:	62 f2 75 48 27 c1    	vptestmd %zmm1,%zmm1,%k0
  ff5824:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
  ff5828:	c5 fb 93 f0          	kmovd  %k0,%esi
  ff582c:	41 09 f7             	or     %esi,%r15d
  ff582f:	45 21 e7             	and    %r12d,%r15d
  ff5832:	44 89 fe             	mov    %r15d,%esi
  ff5835:	21 fe                	and    %edi,%esi
  ff5837:	f7 d7                	not    %edi
  ff5839:	c5 fb 92 ce          	kmovd  %esi,%k1
  ff583d:	48 8b 71 30          	mov    0x30(%rcx),%rsi
  ff5841:	62 b1 7e c9 6f 04 96 	vmovdqu32 (%rsi,%r10,4),%zmm0{%k1}{z}
  ff5848:	62 d2 7d 49 90 0c 80 	vpgatherdd (%r8,%zmm0,4),%zmm1{%k1}
  ff584f:	62 f2 75 48 27 c1    	vptestmd %zmm1,%zmm1,%k0
  ff5855:	c5 fb 93 f0          	kmovd  %k0,%esi
  ff5859:	09 f7                	or     %esi,%edi
  ff585b:	4b 8d 34 90          	lea    (%r8,%r10,4),%rsi
  ff585f:	49 83 c2 10          	add    $0x10,%r10
  ff5863:	44 21 ff             	and    %r15d,%edi
  ff5866:	c5 fb 92 cf          	kmovd  %edi,%k1
  ff586a:	62 f1 7e 49 7f 2e    	vmovdqu32 %zmm5,(%rsi){%k1}
  ff5870:	48 01 94 24 a8 07 00 00 	add    %rdx,0x7a8(%rsp)
  ff5878:	8b 54 24 48          	mov    0x48(%rsp),%edx
  ff587c:	0f b7 f7             	movzwl %di,%esi
  ff587f:	f3 0f b8 f6          	popcnt %esi,%esi
  ff5883:	01 f2                	add    %esi,%edx
  ff5885:	8b 71 38             	mov    0x38(%rcx),%esi
  ff5888:	49 39 f2             	cmp    %rsi,%r10
  ff588b:	0f 83 38 03 00 00    	jae    ff5bc9 <ir_optimize_licm+0x1709>
  ff5891:	49 89 f7             	mov    %rsi,%r15
  ff5894:	4d 29 d7             	sub    %r10,%r15
  ff5897:	89 54 24 48          	mov    %edx,0x48(%rsp)
  ff589b:	ba 10 00 00 00       	mov    $0x10,%edx
  ff58a0:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  ff58a5:	4c 89 5c 24 60       	mov    %r11,0x60(%rsp)
  ff58aa:	4c 89 b4 24 b8 00 00 00 	mov    %r14,0xb8(%rsp)
  ff58b2:	49 83 ff 10          	cmp    $0x10,%r15
  ff58b6:	4c 0f 43 fa          	cmovae %rdx,%r15
  ff58ba:	48 8b 94 24 d8 00 00 00 	mov    0xd8(%rsp),%rdx
  ff58c2:	c4 e2 01 f7 ff       	shlx   %r15d,%edi,%edi
  ff58c7:	4c 89 bc 24 80 00 00 00 	mov    %r15,0x80(%rsp)
  ff58cf:	f7 d7                	not    %edi
  ff58d1:	c5 fb 92 cf          	kmovd  %edi,%k1
  ff58d5:	62 91 7e c9 6f 0c 90 	vmovdqu32 (%r8,%r10,4),%zmm1{%k1}{z}
  ff58dc:	62 b1 7f 89 6f 04 12 	vmovdqu8 (%rdx,%r10,1),%xmm0{%k1}{z}
  ff58e3:	62 f2 76 48 27 c9    	vptestnmd %zmm1,%zmm1,%k1
  ff58e9:	62 f2 7d 09 26 c0    	vptestmb %xmm0,%xmm0,%k0{%k1}
  ff58ef:	c5 fb 93 f8          	kmovd  %k0,%edi
  ff58f3:	c4 e2 00 f5 d7       	bzhi   %r15d,%edi,%edx
  ff58f8:	4c 39 d6             	cmp    %r10,%rsi
  ff58fb:	0f 84 9f fe ff ff    	je     ff57a0 <ir_optimize_licm+0x12e0>
  ff5901:	4c 01 f6             	add    %r14,%rsi
  ff5904:	48 8b 39             	mov    (%rcx),%rdi
  ff5907:	41 b8 10 00 00 00    	mov    $0x10,%r8d
  ff590d:	89 54 24 70          	mov    %edx,0x70(%rsp)
  ff5911:	ba 01 00 00 00       	mov    $0x1,%edx
  ff5916:	48 83 fe 10          	cmp    $0x10,%rsi
  ff591a:	4c 0f 42 c6          	cmovb  %rsi,%r8
  ff591e:	41 83 f8 02          	cmp    $0x2,%r8d
  ff5922:	44 0f 42 c2          	cmovb  %edx,%r8d
  ff5926:	48 89 bc 24 c0 00 00 00 	mov    %rdi,0xc0(%rsp)
  ff592e:	48 83 fe 02          	cmp    $0x2,%rsi
  ff5932:	73 10                	jae    ff5944 <ir_optimize_licm+0x1484>
  ff5934:	31 ff                	xor    %edi,%edi
  ff5936:	45 31 ff             	xor    %r15d,%r15d
  ff5939:	45 31 e4             	xor    %r12d,%r12d
  ff593c:	45 31 f6             	xor    %r14d,%r14d
  ff593f:	e9 bf 01 00 00       	jmp    ff5b03 <ir_optimize_licm+0x1643>
  ff5944:	44 89 c3             	mov    %r8d,%ebx
  ff5947:	4a 8d 34 1f          	lea    (%rdi,%r11,1),%rsi
  ff594b:	83 e3 1e             	and    $0x1e,%ebx
  ff594e:	4c 89 84 24 b0 00 00 00 	mov    %r8,0xb0(%rsp)
  ff5956:	31 ff                	xor    %edi,%edi
  ff5958:	45 31 ff             	xor    %r15d,%r15d
  ff595b:	45 31 e4             	xor    %r12d,%r12d
  ff595e:	45 31 f6             	xor    %r14d,%r14d
  ff5961:	eb 4f                	jmp    ff59b2 <ir_optimize_licm+0x14f2>
  ff5963:	66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  ff5970:	44 89 ca             	mov    %r9d,%edx
  ff5973:	45 8d 46 01          	lea    0x1(%r14),%r8d
  ff5977:	83 e2 01             	and    $0x1,%edx
  ff597a:	49 83 c6 02          	add    $0x2,%r14
  ff597e:	c4 e2 39 f7 d2       	shlx   %r8d,%edx,%edx
  ff5983:	41 09 d4             	or     %edx,%r12d
  ff5986:	ba 01 01 00 00       	mov    $0x101,%edx
  ff598b:	c4 c2 68 f7 d1       	bextr  %edx,%r9d,%edx
  ff5990:	c4 e2 39 f7 d2       	shlx   %r8d,%edx,%edx
  ff5995:	41 09 d7             	or     %edx,%r15d
  ff5998:	ba 02 01 00 00       	mov    $0x102,%edx
  ff599d:	c4 c2 68 f7 d1       	bextr  %edx,%r9d,%edx
  ff59a2:	c4 e2 39 f7 d2       	shlx   %r8d,%edx,%edx
  ff59a7:	09 d7                	or     %edx,%edi
  ff59a9:	49 39 de             	cmp    %rbx,%r14
  ff59ac:	0f 84 30 01 00 00    	je     ff5ae2 <ir_optimize_licm+0x1622>
  ff59b2:	46 0f b6 5c 36 ff    	movzbl -0x1(%rsi,%r14,1),%r11d
  ff59b8:	48 8d 15 41 1e 52 ff 	lea    -0xade1bf(%rip),%rdx        # 517800 <ir_operand_table>
  ff59bf:	45 0f b6 0c 13       	movzbl (%r11,%rdx,1),%r9d
  ff59c4:	4d 0f a3 dd          	bt     %r11,%r13
  ff59c8:	72 62                	jb     ff5a2c <ir_optimize_licm+0x156c>
  ff59ca:	48 8d 15 ef 1f 52 ff 	lea    -0xade011(%rip),%rdx        # 5179c0 <ir_optional_table>
  ff59d1:	45 31 ed             	xor    %r13d,%r13d
  ff59d4:	45 0f b6 1c 13       	movzbl (%r11,%rdx,1),%r11d
  ff59d9:	48 8b 51 20          	mov    0x20(%rcx),%rdx
  ff59dd:	48 01 c2             	add    %rax,%rdx
  ff59e0:	42 83 3c b2 ff       	cmpl   $0xffffffff,(%rdx,%r14,4)
  ff59e5:	48 8b 51 28          	mov    0x28(%rcx),%rdx
  ff59e9:	41 0f 95 c5          	setne  %r13b
  ff59ed:	48 01 c2             	add    %rax,%rdx
  ff59f0:	45 31 c0             	xor    %r8d,%r8d
  ff59f3:	42 83 3c b2 ff       	cmpl   $0xffffffff,(%rdx,%r14,4)
  ff59f8:	48 8b 51 30          	mov    0x30(%rcx),%rdx
  ff59fc:	41 0f 95 c0          	setne  %r8b
  ff5a00:	48 01 c2             	add    %rax,%rdx
  ff5a03:	45 01 c0             	add    %r8d,%r8d
  ff5a06:	45 09 e8             	or     %r13d,%r8d
  ff5a09:	45 31 ed             	xor    %r13d,%r13d
  ff5a0c:	42 83 3c b2 ff       	cmpl   $0xffffffff,(%rdx,%r14,4)
  ff5a11:	41 0f 95 c5          	setne  %r13b
  ff5a15:	41 c1 e5 02          	shl    $0x2,%r13d
  ff5a19:	45 09 c5             	or     %r8d,%r13d
  ff5a1c:	45 21 dd             	and    %r11d,%r13d
  ff5a1f:	45 09 e9             	or     %r13d,%r9d
  ff5a22:	49 bd ff ff ff ff ff 9b f7 ff 	movabs $0xfff79bffffffffff,%r13
  ff5a2c:	44 89 ca             	mov    %r9d,%edx
  ff5a2f:	83 e2 01             	and    $0x1,%edx
  ff5a32:	46 0f b6 1c 36       	movzbl (%rsi,%r14,1),%r11d
  ff5a37:	c4 e2 09 f7 d2       	shlx   %r14d,%edx,%edx
  ff5a3c:	41 09 d4             	or     %edx,%r12d
  ff5a3f:	ba 01 01 00 00       	mov    $0x101,%edx
  ff5a44:	c4 c2 68 f7 d1       	bextr  %edx,%r9d,%edx
  ff5a49:	c4 e2 09 f7 d2       	shlx   %r14d,%edx,%edx
  ff5a4e:	41 09 d7             	or     %edx,%r15d
  ff5a51:	ba 02 01 00 00       	mov    $0x102,%edx
  ff5a56:	c4 c2 68 f7 d1       	bextr  %edx,%r9d,%edx
  ff5a5b:	c4 e2 09 f7 d2       	shlx   %r14d,%edx,%edx
  ff5a60:	09 d7                	or     %edx,%edi
  ff5a62:	48 8d 15 97 1d 52 ff 	lea    -0xade269(%rip),%rdx        # 517800 <ir_operand_table>
  ff5a69:	4d 0f a3 dd          	bt     %r11,%r13
  ff5a6d:	45 0f b6 0c 13       	movzbl (%r11,%rdx,1),%r9d
  ff5a72:	0f 82 f8 fe ff ff    	jb     ff5970 <ir_optimize_licm+0x14b0>
  ff5a78:	48 8d 15 41 1f 52 ff 	lea    -0xade0bf(%rip),%rdx        # 5179c0 <ir_optional_table>
  ff5a7f:	45 31 c0             	xor    %r8d,%r8d
  ff5a82:	45 0f b6 1c 13       	movzbl (%r11,%rdx,1),%r11d
  ff5a87:	48 8b 51 20          	mov    0x20(%rcx),%rdx
  ff5a8b:	48 01 c2             	add    %rax,%rdx
  ff5a8e:	42 83 7c b2 04 ff    	cmpl   $0xffffffff,0x4(%rdx,%r14,4)
  ff5a94:	48 8b 51 28          	mov    0x28(%rcx),%rdx
  ff5a98:	41 0f 95 c0          	setne  %r8b
  ff5a9c:	48 01 c2             	add    %rax,%rdx
  ff5a9f:	45 31 ed             	xor    %r13d,%r13d
  ff5aa2:	42 83 7c b2 04 ff    	cmpl   $0xffffffff,0x4(%rdx,%r14,4)
  ff5aa8:	48 8b 51 30          	mov    0x30(%rcx),%rdx
  ff5aac:	41 0f 95 c5          	setne  %r13b
  ff5ab0:	48 01 c2             	add    %rax,%rdx
  ff5ab3:	45 01 ed             	add    %r13d,%r13d
  ff5ab6:	45 09 c5             	or     %r8d,%r13d
  ff5ab9:	45 31 c0             	xor    %r8d,%r8d
  ff5abc:	42 83 7c b2 04 ff    	cmpl   $0xffffffff,0x4(%rdx,%r14,4)
  ff5ac2:	41 0f 95 c0          	setne  %r8b
  ff5ac6:	41 c1 e0 02          	shl    $0x2,%r8d
  ff5aca:	45 09 e8             	or     %r13d,%r8d
  ff5acd:	49 bd ff ff ff ff ff 9b f7 ff 	movabs $0xfff79bffffffffff,%r13
  ff5ad7:	45 21 d8             	and    %r11d,%r8d
  ff5ada:	45 09 c1             	or     %r8d,%r9d
  ff5add:	e9 8e fe ff ff       	jmp    ff5970 <ir_optimize_licm+0x14b0>
  ff5ae2:	f6 84 24 b0 00 00 00 01 	testb  $0x1,0xb0(%rsp)
  ff5aea:	48 8b 5c 24 20       	mov    0x20(%rsp),%rbx
  ff5aef:	4c 8b 44 24 50       	mov    0x50(%rsp),%r8
  ff5af4:	44 8b 4c 24 58       	mov    0x58(%rsp),%r9d
  ff5af9:	8b 54 24 70          	mov    0x70(%rsp),%edx
  ff5afd:	0f 84 a5 fc ff ff    	je     ff57a8 <ir_optimize_licm+0x12e8>
  ff5b03:	48 8b b4 24 c0 00 00 00 	mov    0xc0(%rsp),%rsi
  ff5b0b:	4c 89 ea             	mov    %r13,%rdx
  ff5b0e:	4f 8d 2c 16          	lea    (%r14,%r10,1),%r13
  ff5b12:	46 0f b6 1c 2e       	movzbl (%rsi,%r13,1),%r11d
  ff5b17:	48 8d 35 e2 1c 52 ff 	lea    -0xade31e(%rip),%rsi        # 517800 <ir_operand_table>
  ff5b1e:	41 0f b6 34 33       	movzbl (%r11,%rsi,1),%esi
  ff5b23:	4c 0f a3 da          	bt     %r11,%rdx
  ff5b27:	72 51                	jb     ff5b7a <ir_optimize_licm+0x16ba>
  ff5b29:	48 8b 59 20          	mov    0x20(%rcx),%rbx
  ff5b2d:	48 8d 15 8c 1e 52 ff 	lea    -0xade174(%rip),%rdx        # 5179c0 <ir_optional_table>
  ff5b34:	45 31 c9             	xor    %r9d,%r9d
  ff5b37:	4c 8b 41 30          	mov    0x30(%rcx),%r8
  ff5b3b:	41 0f b6 14 13       	movzbl (%r11,%rdx,1),%edx
  ff5b40:	4c 8b 59 28          	mov    0x28(%rcx),%r11
  ff5b44:	42 83 3c ab ff       	cmpl   $0xffffffff,(%rbx,%r13,4)
  ff5b49:	41 0f 95 c1          	setne  %r9b
  ff5b4d:	31 db                	xor    %ebx,%ebx
  ff5b4f:	43 83 3c ab ff       	cmpl   $0xffffffff,(%r11,%r13,4)
  ff5b54:	0f 95 c3             	setne  %bl
  ff5b57:	45 31 db             	xor    %r11d,%r11d
  ff5b5a:	01 db                	add    %ebx,%ebx
  ff5b5c:	44 09 cb             	or     %r9d,%ebx
  ff5b5f:	43 83 3c a8 ff       	cmpl   $0xffffffff,(%r8,%r13,4)
  ff5b64:	41 0f 95 c3          	setne  %r11b
  ff5b68:	41 c1 e3 02          	shl    $0x2,%r11d
  ff5b6c:	41 09 db             	or     %ebx,%r11d
  ff5b6f:	48 8b 5c 24 20       	mov    0x20(%rsp),%rbx
  ff5b74:	41 21 d3             	and    %edx,%r11d
  ff5b77:	44 09 de             	or     %r11d,%esi
  ff5b7a:	41 89 f1             	mov    %esi,%r9d
  ff5b7d:	41 83 e1 01          	and    $0x1,%r9d
  ff5b81:	ba 01 01 00 00       	mov    $0x101,%edx
  ff5b86:	4c 8b 44 24 50       	mov    0x50(%rsp),%r8
  ff5b8b:	49 bd ff ff ff ff ff 9b f7 ff 	movabs $0xfff79bffffffffff,%r13
  ff5b95:	c4 42 09 f7 c9       	shlx   %r14d,%r9d,%r9d
  ff5b9a:	45 09 cc             	or     %r9d,%r12d
  ff5b9d:	c4 62 68 f7 ce       	bextr  %edx,%esi,%r9d
  ff5ba2:	ba 02 01 00 00       	mov    $0x102,%edx
  ff5ba7:	c4 42 09 f7 c9       	shlx   %r14d,%r9d,%r9d
  ff5bac:	c4 e2 68 f7 f6       	bextr  %edx,%esi,%esi
  ff5bb1:	8b 54 24 70          	mov    0x70(%rsp),%edx
  ff5bb5:	45 09 cf             	or     %r9d,%r15d
  ff5bb8:	44 8b 4c 24 58       	mov    0x58(%rsp),%r9d
  ff5bbd:	c4 e2 09 f7 f6       	shlx   %r14d,%esi,%esi
  ff5bc2:	09 f7                	or     %esi,%edi
  ff5bc4:	e9 df fb ff ff       	jmp    ff57a8 <ir_optimize_licm+0x12e8>
  ff5bc9:	48 ff 84 24 a0 07 00 00 	incq   0x7a0(%rsp)
  ff5bd1:	85 d2                	test   %edx,%edx
  ff5bd3:	74 1e                	je     ff5bf3 <ir_optimize_licm+0x1733>
  ff5bd5:	89 d0                	mov    %edx,%eax
  ff5bd7:	48 c1 e0 04          	shl    $0x4,%rax
  ff5bdb:	48 3b 44 24 68       	cmp    0x68(%rsp),%rax
  ff5be0:	72 11                	jb     ff5bf3 <ir_optimize_licm+0x1733>
  ff5be2:	41 ff c1             	inc    %r9d
  ff5be5:	44 3b 8c 24 88 00 00 00 	cmp    0x88(%rsp),%r9d
  ff5bed:	0f 82 76 fb ff ff    	jb     ff5769 <ir_optimize_licm+0x12a9>
  ff5bf3:	b0 01                	mov    $0x1,%al
  ff5bf5:	85 d2                	test   %edx,%edx
  ff5bf7:	74 21                	je     ff5c1a <ir_optimize_licm+0x175a>
  ff5bf9:	48 8d bc 24 98 02 00 00 	lea    0x298(%rsp),%rdi
  ff5c01:	88 84 24 b8 07 00 00 	mov    %al,0x7b8(%rsp)
  ff5c08:	c5 f8 77             	vzeroupper
  ff5c0b:	e8 00 69 01 00       	call   100c510 <ir_licm_worklist>
  ff5c10:	62 f2 7d 48 58 2d 0a 9f 62 ff 	vpbroadcastd -0x9d60f6(%rip),%zmm5        # 61fb24 <check_test_member_scaling.timed+0xa74>
  ff5c1a:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  ff5c1f:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  ff5c24:	4c 8b 54 24 30       	mov    0x30(%rsp),%r10
  ff5c29:	4c 8b 8c 24 a0 00 00 00 	mov    0xa0(%rsp),%r9
  ff5c31:	62 f3 4d 48 25 f6 ff 	vpternlogd $0xff,%zmm6,%zmm6,%zmm6
  ff5c38:	41 8b 4d 38          	mov    0x38(%r13),%ecx
  ff5c3c:	85 c9                	test   %ecx,%ecx
  ff5c3e:	0f 84 77 f5 ff ff    	je     ff51bb <ir_optimize_licm+0xcfb>
  ff5c44:	31 d2                	xor    %edx,%edx
  ff5c46:	eb 0e                	jmp    ff5c56 <ir_optimize_licm+0x1796>
  ff5c48:	48 ff c2             	inc    %rdx
  ff5c4b:	89 ce                	mov    %ecx,%esi
  ff5c4d:	48 39 f2             	cmp    %rsi,%rdx
  ff5c50:	0f 83 65 f5 ff ff    	jae    ff51bb <ir_optimize_licm+0xcfb>
  ff5c56:	48 8b b4 24 58 06 00 00 	mov    0x658(%rsp),%rsi
  ff5c5e:	80 3c 16 00          	cmpb   $0x0,(%rsi,%rdx,1)
  ff5c62:	74 e4                	je     ff5c48 <ir_optimize_licm+0x1788>
  ff5c64:	48 8b b4 24 40 06 00 00 	mov    0x640(%rsp),%rsi
  ff5c6c:	83 3c 96 00          	cmpl   $0x0,(%rsi,%rdx,4)
  ff5c70:	74 d6                	je     ff5c48 <ir_optimize_licm+0x1788>
  ff5c72:	48 8b 8c 24 38 06 00 00 	mov    0x638(%rsp),%rcx
  ff5c7a:	48 8b 74 24 78       	mov    0x78(%rsp),%rsi
  ff5c7f:	89 34 91             	mov    %esi,(%rcx,%rdx,4)
  ff5c82:	41 8b 4d 38          	mov    0x38(%r13),%ecx
  ff5c86:	eb c0                	jmp    ff5c48 <ir_optimize_licm+0x1788>
  ff5c88:	48 c7 84 24 c0 00 00 00 00 00 00 00 	movq   $0x0,0xc0(%rsp)
  ff5c94:	85 c9                	test   %ecx,%ecx
  ff5c96:	40 0f 94 c6          	sete   %sil
  ff5c9a:	44 08 e6             	or     %r12b,%sil
  ff5c9d:	0f 85 bd 00 00 00    	jne    ff5d60 <ir_optimize_licm+0x18a0>
  ff5ca3:	4d 89 cb             	mov    %r9,%r11
  ff5ca6:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
  ff5cab:	41 bd 02 00 00 00    	mov    $0x2,%r13d
  ff5cb1:	49 8b 31             	mov    (%r9),%rsi
  ff5cb4:	49 8b 49 08          	mov    0x8(%r9),%rcx
  ff5cb8:	48 8d 7c 31 3f       	lea    0x3f(%rcx,%rsi,1),%rdi
  ff5cbd:	48 01 f1             	add    %rsi,%rcx
  ff5cc0:	48 83 e7 c0          	and    $0xffffffffffffffc0,%rdi
  ff5cc4:	48 39 cf             	cmp    %rcx,%rdi
  ff5cc7:	0f 82 13 05 00 00    	jb     ff61e0 <ir_optimize_licm+0x1d20>
  ff5ccd:	48 89 f9             	mov    %rdi,%rcx
  ff5cd0:	48 29 f1             	sub    %rsi,%rcx
  ff5cd3:	49 8b 71 10          	mov    0x10(%r9),%rsi
  ff5cd7:	48 29 ce             	sub    %rcx,%rsi
  ff5cda:	0f 82 00 05 00 00    	jb     ff61e0 <ir_optimize_licm+0x1d20>
  ff5ce0:	48 39 d6             	cmp    %rdx,%rsi
  ff5ce3:	0f 82 f7 04 00 00    	jb     ff61e0 <ir_optimize_licm+0x1d20>
  ff5ce9:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
  ff5cee:	48 01 d1             	add    %rdx,%rcx
  ff5cf1:	49 89 49 08          	mov    %rcx,0x8(%r9)
  ff5cf5:	49 8b 71 20          	mov    0x20(%r9),%rsi
  ff5cf9:	48 39 f1             	cmp    %rsi,%rcx
  ff5cfc:	48 0f 46 ce          	cmovbe %rsi,%rcx
  ff5d00:	49 89 49 20          	mov    %rcx,0x20(%r9)
  ff5d04:	48 85 ff             	test   %rdi,%rdi
  ff5d07:	0f 84 d3 04 00 00    	je     ff61e0 <ir_optimize_licm+0x1d20>
  ff5d0d:	31 f6                	xor    %esi,%esi
  ff5d0f:	4d 89 dd             	mov    %r11,%r13
  ff5d12:	48 89 5c 24 58       	mov    %rbx,0x58(%rsp)
  ff5d17:	48 89 7c 24 78       	mov    %rdi,0x78(%rsp)
  ff5d1c:	c5 f8 77             	vzeroupper
  ff5d1f:	e8 bc 3e 90 ff       	call   8f9be0 <memset@plt>
  ff5d24:	48 8b 4c 24 48       	mov    0x48(%rsp),%rcx
  ff5d29:	4c 8b 5c 24 78       	mov    0x78(%rsp),%r11
  ff5d2e:	48 8b 5c 24 58       	mov    0x58(%rsp),%rbx
  ff5d33:	4c 8b 44 24 40       	mov    0x40(%rsp),%r8
  ff5d38:	4c 8b 54 24 30       	mov    0x30(%rsp),%r10
  ff5d3d:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  ff5d42:	4d 89 e9             	mov    %r13,%r9
  ff5d45:	8b 09                	mov    (%rcx),%ecx
  ff5d47:	eb 1a                	jmp    ff5d63 <ir_optimize_licm+0x18a3>
  ff5d49:	4c 8b ac 24 98 02 00 00 	mov    0x298(%rsp),%r13
  ff5d51:	e9 31 f0 ff ff       	jmp    ff4d87 <ir_optimize_licm+0x8c7>
  ff5d56:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  ff5d5b:	e9 7e f0 ff ff       	jmp    ff4dde <ir_optimize_licm+0x91e>
  ff5d60:	45 31 db             	xor    %r11d,%r11d
  ff5d63:	85 c9                	test   %ecx,%ecx
  ff5d65:	0f 94 c2             	sete   %dl
  ff5d68:	44 08 e2             	or     %r12b,%dl
  ff5d6b:	0f 85 e2 00 00 00    	jne    ff5e53 <ir_optimize_licm+0x1993>
  ff5d71:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  ff5d76:	4c 89 4c 24 50       	mov    %r9,0x50(%rsp)
  ff5d7b:	41 bd 02 00 00 00    	mov    $0x2,%r13d
  ff5d81:	48 8b 17             	mov    (%rdi),%rdx
  ff5d84:	4c 8b 4f 08          	mov    0x8(%rdi),%r9
  ff5d88:	49 8d 74 11 3f       	lea    0x3f(%r9,%rdx,1),%rsi
  ff5d8d:	49 01 d1             	add    %rdx,%r9
  ff5d90:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
  ff5d94:	4c 39 ce             	cmp    %r9,%rsi
  ff5d97:	0f 82 43 04 00 00    	jb     ff61e0 <ir_optimize_licm+0x1d20>
  ff5d9d:	48 8b 7f 10          	mov    0x10(%rdi),%rdi
  ff5da1:	48 89 b4 24 b0 00 00 00 	mov    %rsi,0xb0(%rsp)
  ff5da9:	48 29 d6             	sub    %rdx,%rsi
  ff5dac:	48 29 f7             	sub    %rsi,%rdi
  ff5daf:	0f 82 2b 04 00 00    	jb     ff61e0 <ir_optimize_licm+0x1d20>
  ff5db5:	89 ca                	mov    %ecx,%edx
  ff5db7:	48 c1 e2 02          	shl    $0x2,%rdx
  ff5dbb:	48 39 fa             	cmp    %rdi,%rdx
  ff5dbe:	0f 87 1c 04 00 00    	ja     ff61e0 <ir_optimize_licm+0x1d20>
  ff5dc4:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  ff5dc9:	48 01 d6             	add    %rdx,%rsi
  ff5dcc:	48 89 77 08          	mov    %rsi,0x8(%rdi)
  ff5dd0:	48 8b 4f 20          	mov    0x20(%rdi),%rcx
  ff5dd4:	48 39 ce             	cmp    %rcx,%rsi
  ff5dd7:	48 0f 46 f1          	cmovbe %rcx,%rsi
  ff5ddb:	48 89 77 20          	mov    %rsi,0x20(%rdi)
  ff5ddf:	48 8b bc 24 b0 00 00 00 	mov    0xb0(%rsp),%rdi
  ff5de7:	48 85 ff             	test   %rdi,%rdi
  ff5dea:	0f 84 f0 03 00 00    	je     ff61e0 <ir_optimize_licm+0x1d20>
  ff5df0:	31 f6                	xor    %esi,%esi
  ff5df2:	48 89 5c 24 58       	mov    %rbx,0x58(%rsp)
  ff5df7:	4c 89 5c 24 78       	mov    %r11,0x78(%rsp)
  ff5dfc:	c5 f8 77             	vzeroupper
  ff5dff:	e8 dc 3d 90 ff       	call   8f9be0 <memset@plt>
  ff5e04:	48 8b 4c 24 48       	mov    0x48(%rsp),%rcx
  ff5e09:	48 8b b4 24 b0 00 00 00 	mov    0xb0(%rsp),%rsi
  ff5e11:	4c 8b 5c 24 78       	mov    0x78(%rsp),%r11
  ff5e16:	48 8b 5c 24 58       	mov    0x58(%rsp),%rbx
  ff5e1b:	4c 8b 4c 24 50       	mov    0x50(%rsp),%r9
  ff5e20:	4c 8b 44 24 40       	mov    0x40(%rsp),%r8
  ff5e25:	4c 8b 54 24 30       	mov    0x30(%rsp),%r10
  ff5e2a:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  ff5e2f:	8b 09                	mov    (%rcx),%ecx
  ff5e31:	eb 22                	jmp    ff5e55 <ir_optimize_licm+0x1995>
  ff5e33:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  ff5e38:	e9 40 ef ff ff       	jmp    ff4d7d <ir_optimize_licm+0x8bd>
  ff5e3d:	4c 89 74 24 60       	mov    %r14,0x60(%rsp)
  ff5e42:	48 c7 84 24 b8 00 00 00 00 00 00 00 	movq   $0x0,0xb8(%rsp)
  ff5e4e:	e9 4a 01 00 00       	jmp    ff5f9d <ir_optimize_licm+0x1add>
  ff5e53:	31 f6                	xor    %esi,%esi
  ff5e55:	85 c9                	test   %ecx,%ecx
  ff5e57:	48 89 b4 24 b0 00 00 00 	mov    %rsi,0xb0(%rsp)
  ff5e5f:	0f 94 c2             	sete   %dl
  ff5e62:	44 08 e2             	or     %r12b,%dl
  ff5e65:	0f 85 9a 01 00 00    	jne    ff6005 <ir_optimize_licm+0x1b45>
  ff5e6b:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
  ff5e70:	41 bd 02 00 00 00    	mov    $0x2,%r13d
  ff5e76:	48 8b 16             	mov    (%rsi),%rdx
  ff5e79:	48 8b 76 08          	mov    0x8(%rsi),%rsi
  ff5e7d:	48 8d 7c 16 3f       	lea    0x3f(%rsi,%rdx,1),%rdi
  ff5e82:	48 01 d6             	add    %rdx,%rsi
  ff5e85:	48 83 e7 c0          	and    $0xffffffffffffffc0,%rdi
  ff5e89:	48 39 f7             	cmp    %rsi,%rdi
  ff5e8c:	0f 82 4e 03 00 00    	jb     ff61e0 <ir_optimize_licm+0x1d20>
  ff5e92:	48 89 fe             	mov    %rdi,%rsi
  ff5e95:	48 89 7c 24 68       	mov    %rdi,0x68(%rsp)
  ff5e9a:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  ff5e9f:	48 29 d6             	sub    %rdx,%rsi
  ff5ea2:	4c 89 5c 24 78       	mov    %r11,0x78(%rsp)
  ff5ea7:	4c 89 bc 24 a8 00 00 00 	mov    %r15,0xa8(%rsp)
  ff5eaf:	4c 89 4c 24 50       	mov    %r9,0x50(%rsp)
  ff5eb4:	48 8b 7f 10          	mov    0x10(%rdi),%rdi
  ff5eb8:	48 29 f7             	sub    %rsi,%rdi
  ff5ebb:	0f 82 1f 03 00 00    	jb     ff61e0 <ir_optimize_licm+0x1d20>
  ff5ec1:	89 ca                	mov    %ecx,%edx
  ff5ec3:	48 c1 e2 02          	shl    $0x2,%rdx
  ff5ec7:	48 39 fa             	cmp    %rdi,%rdx
  ff5eca:	0f 87 10 03 00 00    	ja     ff61e0 <ir_optimize_licm+0x1d20>
  ff5ed0:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  ff5ed5:	48 01 d6             	add    %rdx,%rsi
  ff5ed8:	48 89 77 08          	mov    %rsi,0x8(%rdi)
  ff5edc:	48 8b 4f 20          	mov    0x20(%rdi),%rcx
  ff5ee0:	48 39 ce             	cmp    %rcx,%rsi
  ff5ee3:	48 0f 46 f1          	cmovbe %rcx,%rsi
  ff5ee7:	48 83 7c 24 68 00    	cmpq   $0x0,0x68(%rsp)
  ff5eed:	48 89 77 20          	mov    %rsi,0x20(%rdi)
  ff5ef1:	0f 84 e9 02 00 00    	je     ff61e0 <ir_optimize_licm+0x1d20>
  ff5ef7:	48 8b 7c 24 68       	mov    0x68(%rsp),%rdi
  ff5efc:	31 f6                	xor    %esi,%esi
  ff5efe:	c5 f8 77             	vzeroupper
  ff5f01:	e8 da 3c 90 ff       	call   8f9be0 <memset@plt>
  ff5f06:	48 8b 4c 24 48       	mov    0x48(%rsp),%rcx
  ff5f0b:	48 8b 7c 24 68       	mov    0x68(%rsp),%rdi
  ff5f10:	4c 8b bc 24 a8 00 00 00 	mov    0xa8(%rsp),%r15
  ff5f18:	4c 8b 4c 24 50       	mov    0x50(%rsp),%r9
  ff5f1d:	4c 8b 44 24 40       	mov    0x40(%rsp),%r8
  ff5f22:	4c 8b 54 24 30       	mov    0x30(%rsp),%r10
  ff5f27:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  ff5f2c:	8b 09                	mov    (%rcx),%ecx
  ff5f2e:	e9 d9 00 00 00       	jmp    ff600c <ir_optimize_licm+0x1b4c>
  ff5f33:	4c 8b 4b 10          	mov    0x10(%rbx),%r9
  ff5f37:	48 89 fe             	mov    %rdi,%rsi
  ff5f3a:	48 29 c6             	sub    %rax,%rsi
  ff5f3d:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  ff5f42:	4c 8b 54 24 30       	mov    0x30(%rsp),%r10
  ff5f47:	49 29 f1             	sub    %rsi,%r9
  ff5f4a:	0f 82 9a 02 00 00    	jb     ff61ea <ir_optimize_licm+0x1d2a>
  ff5f50:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  ff5f55:	48 c1 e2 02          	shl    $0x2,%rdx
  ff5f59:	4c 89 f1             	mov    %r14,%rcx
  ff5f5c:	4c 39 ca             	cmp    %r9,%rdx
  ff5f5f:	0f 87 79 ee ff ff    	ja     ff4dde <ir_optimize_licm+0x91e>
  ff5f65:	48 01 d6             	add    %rdx,%rsi
  ff5f68:	48 89 73 08          	mov    %rsi,0x8(%rbx)
  ff5f6c:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  ff5f70:	48 39 ce             	cmp    %rcx,%rsi
  ff5f73:	48 0f 46 f1          	cmovbe %rcx,%rsi
  ff5f77:	48 89 73 20          	mov    %rsi,0x20(%rbx)
  ff5f7b:	48 85 ff             	test   %rdi,%rdi
  ff5f7e:	0f 84 6b 02 00 00    	je     ff61ef <ir_optimize_licm+0x1d2f>
  ff5f84:	31 f6                	xor    %esi,%esi
  ff5f86:	4c 89 74 24 60       	mov    %r14,0x60(%rsp)
  ff5f8b:	48 89 bc 24 b8 00 00 00 	mov    %rdi,0xb8(%rsp)
  ff5f93:	e8 48 3c 90 ff       	call   8f9be0 <memset@plt>
  ff5f98:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  ff5f9d:	49 8d 45 38          	lea    0x38(%r13),%rax
  ff5fa1:	41 8b 55 38          	mov    0x38(%r13),%edx
  ff5fa5:	4c 8b 54 24 30       	mov    0x30(%rsp),%r10
  ff5faa:	4c 8b 44 24 40       	mov    0x40(%rsp),%r8
  ff5faf:	41 b6 01             	mov    $0x1,%r14b
  ff5fb2:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
  ff5fb7:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  ff5fbc:	48 85 d2             	test   %rdx,%rdx
  ff5fbf:	0f 84 15 01 00 00    	je     ff60da <ir_optimize_licm+0x1c1a>
  ff5fc5:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
  ff5fca:	49 8b 31             	mov    (%r9),%rsi
  ff5fcd:	49 8b 49 08          	mov    0x8(%r9),%rcx
  ff5fd1:	48 8d 7c 31 3f       	lea    0x3f(%rcx,%rsi,1),%rdi
  ff5fd6:	48 01 f1             	add    %rsi,%rcx
  ff5fd9:	48 83 e7 c0          	and    $0xffffffffffffffc0,%rdi
  ff5fdd:	48 39 cf             	cmp    %rcx,%rdi
  ff5fe0:	0f 83 0b 01 00 00    	jae    ff60f1 <ir_optimize_licm+0x1c31>
  ff5fe6:	45 31 db             	xor    %r11d,%r11d
  ff5fe9:	48 c7 84 24 80 00 00 00 00 00 00 00 	movq   $0x0,0x80(%rsp)
  ff5ff5:	45 31 f6             	xor    %r14d,%r14d
  ff5ff8:	45 31 c9             	xor    %r9d,%r9d
  ff5ffb:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  ff6000:	e9 08 ee ff ff       	jmp    ff4e0d <ir_optimize_licm+0x94d>
  ff6005:	4c 89 5c 24 78       	mov    %r11,0x78(%rsp)
  ff600a:	31 ff                	xor    %edi,%edi
  ff600c:	85 c9                	test   %ecx,%ecx
  ff600e:	4d 89 cb             	mov    %r9,%r11
  ff6011:	0f 94 c2             	sete   %dl
  ff6014:	41 08 d4             	or     %dl,%r12b
  ff6017:	0f 85 63 01 00 00    	jne    ff6180 <ir_optimize_licm+0x1cc0>
  ff601d:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
  ff6022:	41 bd 02 00 00 00    	mov    $0x2,%r13d
  ff6028:	48 8b 16             	mov    (%rsi),%rdx
  ff602b:	48 8b 76 08          	mov    0x8(%rsi),%rsi
  ff602f:	4c 8d 4c 16 3f       	lea    0x3f(%rsi,%rdx,1),%r9
  ff6034:	48 01 d6             	add    %rdx,%rsi
  ff6037:	49 83 e1 c0          	and    $0xffffffffffffffc0,%r9
  ff603b:	49 39 f1             	cmp    %rsi,%r9
  ff603e:	0f 82 9c 01 00 00    	jb     ff61e0 <ir_optimize_licm+0x1d20>
  ff6044:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
  ff6049:	4c 89 c8             	mov    %r9,%rax
  ff604c:	48 29 d0             	sub    %rdx,%rax
  ff604f:	48 89 7c 24 68       	mov    %rdi,0x68(%rsp)
  ff6054:	4c 89 bc 24 a8 00 00 00 	mov    %r15,0xa8(%rsp)
  ff605c:	48 89 5c 24 58       	mov    %rbx,0x58(%rsp)
  ff6061:	4c 89 5c 24 50       	mov    %r11,0x50(%rsp)
  ff6066:	4c 89 8c 24 a0 00 00 00 	mov    %r9,0xa0(%rsp)
  ff606e:	48 8b 76 10          	mov    0x10(%rsi),%rsi
  ff6072:	48 29 c6             	sub    %rax,%rsi
  ff6075:	0f 82 56 01 00 00    	jb     ff61d1 <ir_optimize_licm+0x1d11>
  ff607b:	89 ca                	mov    %ecx,%edx
  ff607d:	48 c1 e2 02          	shl    $0x2,%rdx
  ff6081:	48 39 f2             	cmp    %rsi,%rdx
  ff6084:	0f 87 47 01 00 00    	ja     ff61d1 <ir_optimize_licm+0x1d11>
  ff608a:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
  ff608f:	48 01 d0             	add    %rdx,%rax
  ff6092:	4c 8b 54 24 30       	mov    0x30(%rsp),%r10
  ff6097:	4c 8b 44 24 40       	mov    0x40(%rsp),%r8
  ff609c:	48 89 46 08          	mov    %rax,0x8(%rsi)
  ff60a0:	48 8b 4e 20          	mov    0x20(%rsi),%rcx
  ff60a4:	48 39 c8             	cmp    %rcx,%rax
  ff60a7:	48 0f 46 c1          	cmovbe %rcx,%rax
  ff60ab:	48 83 bc 24 a0 00 00 00 00 	cmpq   $0x0,0xa0(%rsp)
  ff60b4:	48 89 46 20          	mov    %rax,0x20(%rsi)
  ff60b8:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  ff60bd:	0f 84 1d 01 00 00    	je     ff61e0 <ir_optimize_licm+0x1d20>
  ff60c3:	48 8b bc 24 a0 00 00 00 	mov    0xa0(%rsp),%rdi
  ff60cb:	31 f6                	xor    %esi,%esi
  ff60cd:	c5 f8 77             	vzeroupper
  ff60d0:	e8 0b 3b 90 ff       	call   8f9be0 <memset@plt>
  ff60d5:	e9 d4 00 00 00       	jmp    ff61ae <ir_optimize_licm+0x1cee>
  ff60da:	45 31 db             	xor    %r11d,%r11d
  ff60dd:	48 c7 84 24 80 00 00 00 00 00 00 00 	movq   $0x0,0x80(%rsp)
  ff60e9:	45 31 c9             	xor    %r9d,%r9d
  ff60ec:	e9 1c ed ff ff       	jmp    ff4e0d <ir_optimize_licm+0x94d>
  ff60f1:	48 89 f9             	mov    %rdi,%rcx
  ff60f4:	48 29 f1             	sub    %rsi,%rcx
  ff60f7:	49 8b 71 10          	mov    0x10(%r9),%rsi
  ff60fb:	45 31 db             	xor    %r11d,%r11d
  ff60fe:	48 29 ce             	sub    %rcx,%rsi
  ff6101:	0f 82 e2 fe ff ff    	jb     ff5fe9 <ir_optimize_licm+0x1b29>
  ff6107:	48 c1 e2 02          	shl    $0x2,%rdx
  ff610b:	48 39 f2             	cmp    %rsi,%rdx
  ff610e:	0f 87 d5 fe ff ff    	ja     ff5fe9 <ir_optimize_licm+0x1b29>
  ff6114:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
  ff6119:	48 01 d1             	add    %rdx,%rcx
  ff611c:	48 89 4e 08          	mov    %rcx,0x8(%rsi)
  ff6120:	48 8b 46 20          	mov    0x20(%rsi),%rax
  ff6124:	48 39 c1             	cmp    %rax,%rcx
  ff6127:	48 0f 46 c8          	cmovbe %rax,%rcx
  ff612b:	48 89 4e 20          	mov    %rcx,0x20(%rsi)
  ff612f:	48 85 ff             	test   %rdi,%rdi
  ff6132:	0f 84 f5 01 00 00    	je     ff632d <ir_optimize_licm+0x1e6d>
  ff6138:	31 f6                	xor    %esi,%esi
  ff613a:	48 89 bc 24 80 00 00 00 	mov    %rdi,0x80(%rsp)
  ff6142:	e8 99 3a 90 ff       	call   8f9be0 <memset@plt>
  ff6147:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  ff614c:	8b 10                	mov    (%rax),%edx
  ff614e:	48 85 d2             	test   %rdx,%rdx
  ff6151:	0f 84 6a 03 00 00    	je     ff64c1 <ir_optimize_licm+0x2001>
  ff6157:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  ff615c:	48 8b 08             	mov    (%rax),%rcx
  ff615f:	48 8b 40 08          	mov    0x8(%rax),%rax
  ff6163:	4c 8d 64 08 3f       	lea    0x3f(%rax,%rcx,1),%r12
  ff6168:	48 01 c8             	add    %rcx,%rax
  ff616b:	49 83 e4 c0          	and    $0xffffffffffffffc0,%r12
  ff616f:	49 39 c4             	cmp    %rax,%r12
  ff6172:	0f 83 de 01 00 00    	jae    ff6356 <ir_optimize_licm+0x1e96>
  ff6178:	45 31 db             	xor    %r11d,%r11d
  ff617b:	e9 bc 01 00 00       	jmp    ff633c <ir_optimize_licm+0x1e7c>
  ff6180:	41 bd 02 00 00 00    	mov    $0x2,%r13d
  ff6186:	45 84 f6             	test   %r14b,%r14b
  ff6189:	74 55                	je     ff61e0 <ir_optimize_licm+0x1d20>
  ff618b:	48 89 7c 24 68       	mov    %rdi,0x68(%rsp)
  ff6190:	4c 89 bc 24 a8 00 00 00 	mov    %r15,0xa8(%rsp)
  ff6198:	48 89 5c 24 58       	mov    %rbx,0x58(%rsp)
  ff619d:	4c 89 5c 24 50       	mov    %r11,0x50(%rsp)
  ff61a2:	48 c7 84 24 a0 00 00 00 00 00 00 00 	movq   $0x0,0xa0(%rsp)
  ff61ae:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  ff61b3:	48 8b 08             	mov    (%rax),%rcx
  ff61b6:	48 8b 40 08          	mov    0x8(%rax),%rax
  ff61ba:	48 8d 54 08 3f       	lea    0x3f(%rax,%rcx,1),%rdx
  ff61bf:	48 01 c8             	add    %rcx,%rax
  ff61c2:	48 83 e2 c0          	and    $0xffffffffffffffc0,%rdx
  ff61c6:	48 39 c2             	cmp    %rax,%rdx
  ff61c9:	73 2c                	jae    ff61f7 <ir_optimize_licm+0x1d37>
  ff61cb:	41 bd 02 00 00 00    	mov    $0x2,%r13d
  ff61d1:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  ff61d6:	4c 8b 54 24 30       	mov    0x30(%rsp),%r10
  ff61db:	4c 8b 44 24 40       	mov    0x40(%rsp),%r8
  ff61e0:	48 8b 5c 24 20       	mov    0x20(%rsp),%rbx
  ff61e5:	e9 73 e8 ff ff       	jmp    ff4a5d <ir_optimize_licm+0x59d>
  ff61ea:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  ff61ef:	4c 89 f1             	mov    %r14,%rcx
  ff61f2:	e9 e7 eb ff ff       	jmp    ff4dde <ir_optimize_licm+0x91e>
  ff61f7:	48 89 d0             	mov    %rdx,%rax
  ff61fa:	48 29 c8             	sub    %rcx,%rax
  ff61fd:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  ff6202:	48 89 94 24 98 00 00 00 	mov    %rdx,0x98(%rsp)
  ff620a:	48 8b 49 10          	mov    0x10(%rcx),%rcx
  ff620e:	48 29 c1             	sub    %rax,%rcx
  ff6211:	72 b8                	jb     ff61cb <ir_optimize_licm+0x1d0b>
  ff6213:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
  ff6218:	8b 52 48             	mov    0x48(%rdx),%edx
  ff621b:	48 8d 14 95 04 00 00 00 	lea    0x4(,%rdx,4),%rdx
  ff6223:	48 39 ca             	cmp    %rcx,%rdx
  ff6226:	77 a3                	ja     ff61cb <ir_optimize_licm+0x1d0b>
  ff6228:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
  ff622d:	48 01 d0             	add    %rdx,%rax
  ff6230:	48 89 46 08          	mov    %rax,0x8(%rsi)
  ff6234:	48 8b 4e 20          	mov    0x20(%rsi),%rcx
  ff6238:	48 39 c8             	cmp    %rcx,%rax
  ff623b:	48 0f 46 c1          	cmovbe %rcx,%rax
  ff623f:	48 83 bc 24 98 00 00 00 00 	cmpq   $0x0,0x98(%rsp)
  ff6248:	48 89 46 20          	mov    %rax,0x20(%rsi)
  ff624c:	0f 84 79 ff ff ff    	je     ff61cb <ir_optimize_licm+0x1d0b>
  ff6252:	48 8b bc 24 98 00 00 00 	mov    0x98(%rsp),%rdi
  ff625a:	31 f6                	xor    %esi,%esi
  ff625c:	45 31 f6             	xor    %r14d,%r14d
  ff625f:	c5 f8 77             	vzeroupper
  ff6262:	e8 79 39 90 ff       	call   8f9be0 <memset@plt>
  ff6267:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  ff626c:	83 38 00             	cmpl   $0x0,(%rax)
  ff626f:	0f 84 6b 02 00 00    	je     ff64e0 <ir_optimize_licm+0x2020>
  ff6275:	48 8b 74 24 28       	mov    0x28(%rsp),%rsi
  ff627a:	4c 8b 44 24 60       	mov    0x60(%rsp),%r8
  ff627f:	31 ff                	xor    %edi,%edi
  ff6281:	45 31 e4             	xor    %r12d,%r12d
  ff6284:	31 c0                	xor    %eax,%eax
  ff6286:	eb 1f                	jmp    ff62a7 <ir_optimize_licm+0x1de7>
  ff6288:	48 8b 4e 30          	mov    0x30(%rsi),%rcx
  ff628c:	8b 0c 81             	mov    (%rcx,%rax,4),%ecx
  ff628f:	48 8d 7c 4f 01       	lea    0x1(%rdi,%rcx,2),%rdi
  ff6294:	48 8b 4c 24 48       	mov    0x48(%rsp),%rcx
  ff6299:	48 ff c0             	inc    %rax
  ff629c:	8b 09                	mov    (%rcx),%ecx
  ff629e:	48 39 c8             	cmp    %rcx,%rax
  ff62a1:	0f 83 3e 01 00 00    	jae    ff63e5 <ir_optimize_licm+0x1f25>
  ff62a7:	48 8b 8c 24 38 06 00 00 	mov    0x638(%rsp),%rcx
  ff62af:	48 8b 94 24 c8 02 00 00 	mov    0x2c8(%rsp),%rdx
  ff62b7:	8b 0c 81             	mov    (%rcx,%rax,4),%ecx
  ff62ba:	3b 0c 82             	cmp    (%rdx,%rax,4),%ecx
  ff62bd:	74 0c                	je     ff62cb <ir_optimize_licm+0x1e0b>
  ff62bf:	41 ff 44 88 04       	incl   0x4(%r8,%rcx,4)
  ff62c4:	ff 84 24 90 07 00 00 	incl   0x790(%rsp)
  ff62cb:	48 8b 0e             	mov    (%rsi),%rcx
  ff62ce:	0f b6 0c 01          	movzbl (%rcx,%rax,1),%ecx
  ff62d2:	83 f9 38             	cmp    $0x38,%ecx
  ff62d5:	74 17                	je     ff62ee <ir_optimize_licm+0x1e2e>
  ff62d7:	83 f9 32             	cmp    $0x32,%ecx
  ff62da:	74 ac                	je     ff6288 <ir_optimize_licm+0x1dc8>
  ff62dc:	83 f9 2f             	cmp    $0x2f,%ecx
  ff62df:	75 23                	jne    ff6304 <ir_optimize_licm+0x1e44>
  ff62e1:	48 8b 4e 28          	mov    0x28(%rsi),%rcx
  ff62e5:	8b 0c 81             	mov    (%rcx,%rax,4),%ecx
  ff62e8:	48 8d 3c 4f          	lea    (%rdi,%rcx,2),%rdi
  ff62ec:	eb a6                	jmp    ff6294 <ir_optimize_licm+0x1dd4>
  ff62ee:	48 8b 4e 28          	mov    0x28(%rsi),%rcx
  ff62f2:	83 3c 81 ff          	cmpl   $0xffffffff,(%rcx,%rax,4)
  ff62f6:	74 9c                	je     ff6294 <ir_optimize_licm+0x1dd4>
  ff62f8:	48 8b 4e 30          	mov    0x30(%rsi),%rcx
  ff62fc:	8b 0c 81             	mov    (%rcx,%rax,4),%ecx
  ff62ff:	48 01 cf             	add    %rcx,%rdi
  ff6302:	eb 90                	jmp    ff6294 <ir_optimize_licm+0x1dd4>
  ff6304:	80 c1 d3             	add    $0xd3,%cl
  ff6307:	80 f9 01             	cmp    $0x1,%cl
  ff630a:	77 88                	ja     ff6294 <ir_optimize_licm+0x1dd4>
  ff630c:	48 8b 4e 28          	mov    0x28(%rsi),%rcx
  ff6310:	48 8b 96 90 00 00 00 	mov    0x90(%rsi),%rdx
  ff6317:	49 ff c4             	inc    %r12
  ff631a:	8b 0c 81             	mov    (%rcx,%rax,4),%ecx
  ff631d:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
  ff6321:	8b 4c ca 04          	mov    0x4(%rdx,%rcx,8),%ecx
  ff6325:	48 01 cf             	add    %rcx,%rdi
  ff6328:	e9 67 ff ff ff       	jmp    ff6294 <ir_optimize_licm+0x1dd4>
  ff632d:	45 31 db             	xor    %r11d,%r11d
  ff6330:	48 c7 84 24 80 00 00 00 00 00 00 00 	movq   $0x0,0x80(%rsp)
  ff633c:	45 31 f6             	xor    %r14d,%r14d
  ff633f:	45 31 c9             	xor    %r9d,%r9d
  ff6342:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  ff6347:	4c 8b 54 24 30       	mov    0x30(%rsp),%r10
  ff634c:	4c 8b 44 24 40       	mov    0x40(%rsp),%r8
  ff6351:	e9 a5 fc ff ff       	jmp    ff5ffb <ir_optimize_licm+0x1b3b>
  ff6356:	4c 89 e0             	mov    %r12,%rax
  ff6359:	48 29 c8             	sub    %rcx,%rax
  ff635c:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  ff6361:	48 8b 49 10          	mov    0x10(%rcx),%rcx
  ff6365:	48 29 c1             	sub    %rax,%rcx
  ff6368:	0f 82 50 01 00 00    	jb     ff64be <ir_optimize_licm+0x1ffe>
  ff636e:	48 c1 e2 02          	shl    $0x2,%rdx
  ff6372:	48 39 ca             	cmp    %rcx,%rdx
  ff6375:	0f 87 43 01 00 00    	ja     ff64be <ir_optimize_licm+0x1ffe>
  ff637b:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
  ff6380:	48 01 d0             	add    %rdx,%rax
  ff6383:	48 89 46 08          	mov    %rax,0x8(%rsi)
  ff6387:	48 8b 4e 20          	mov    0x20(%rsi),%rcx
  ff638b:	48 39 c8             	cmp    %rcx,%rax
  ff638e:	48 0f 46 c1          	cmovbe %rcx,%rax
  ff6392:	48 89 46 20          	mov    %rax,0x20(%rsi)
  ff6396:	4d 85 e4             	test   %r12,%r12
  ff6399:	0f 84 d9 fd ff ff    	je     ff6178 <ir_optimize_licm+0x1cb8>
  ff639f:	4c 89 e7             	mov    %r12,%rdi
  ff63a2:	31 f6                	xor    %esi,%esi
  ff63a4:	e8 37 38 90 ff       	call   8f9be0 <memset@plt>
  ff63a9:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  ff63ae:	8b 10                	mov    (%rax),%edx
  ff63b0:	48 85 d2             	test   %rdx,%rdx
  ff63b3:	0f 84 db 08 00 00    	je     ff6c94 <ir_optimize_licm+0x27d4>
  ff63b9:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  ff63be:	48 8b 08             	mov    (%rax),%rcx
  ff63c1:	48 8b 40 08          	mov    0x8(%rax),%rax
  ff63c5:	48 8d 5c 08 3f       	lea    0x3f(%rax,%rcx,1),%rbx
  ff63ca:	48 01 c8             	add    %rcx,%rax
  ff63cd:	48 83 e3 c0          	and    $0xffffffffffffffc0,%rbx
  ff63d1:	48 39 c3             	cmp    %rax,%rbx
  ff63d4:	0f 83 9a 09 00 00    	jae    ff6d74 <ir_optimize_licm+0x28b4>
  ff63da:	45 31 f6             	xor    %r14d,%r14d
  ff63dd:	4d 89 e3             	mov    %r12,%r11
  ff63e0:	e9 5a ff ff ff       	jmp    ff633f <ir_optimize_licm+0x1e7f>
  ff63e5:	48 89 f8             	mov    %rdi,%rax
  ff63e8:	4c 09 e0             	or     %r12,%rax
  ff63eb:	4c 8b 54 24 30       	mov    0x30(%rsp),%r10
  ff63f0:	4c 8b 44 24 40       	mov    0x40(%rsp),%r8
  ff63f5:	41 bd 01 00 00 00    	mov    $0x1,%r13d
  ff63fb:	48 89 bc 24 c8 00 00 00 	mov    %rdi,0xc8(%rsp)
  ff6403:	48 c1 e8 20          	shr    $0x20,%rax
  ff6407:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  ff640c:	0f 85 ce fd ff ff    	jne    ff61e0 <ir_optimize_licm+0x1d20>
  ff6412:	48 83 bc 24 c8 00 00 00 00 	cmpq   $0x0,0xc8(%rsp)
  ff641b:	48 c7 84 24 e0 00 00 00 00 00 00 00 	movq   $0x0,0xe0(%rsp)
  ff6427:	0f 84 6f 08 00 00    	je     ff6c9c <ir_optimize_licm+0x27dc>
  ff642d:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  ff6432:	48 8b 08             	mov    (%rax),%rcx
  ff6435:	48 8b 40 08          	mov    0x8(%rax),%rax
  ff6439:	48 8d 74 08 3f       	lea    0x3f(%rax,%rcx,1),%rsi
  ff643e:	48 01 c8             	add    %rcx,%rax
  ff6441:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
  ff6445:	48 89 74 24 48       	mov    %rsi,0x48(%rsp)
  ff644a:	48 39 c6             	cmp    %rax,%rsi
  ff644d:	0f 82 78 fd ff ff    	jb     ff61cb <ir_optimize_licm+0x1d0b>
  ff6453:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  ff6458:	48 29 c8             	sub    %rcx,%rax
  ff645b:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  ff6460:	48 8b 49 10          	mov    0x10(%rcx),%rcx
  ff6464:	48 29 c1             	sub    %rax,%rcx
  ff6467:	0f 82 5e fd ff ff    	jb     ff61cb <ir_optimize_licm+0x1d0b>
  ff646d:	48 8b 94 24 c8 00 00 00 	mov    0xc8(%rsp),%rdx
  ff6475:	48 8d 14 95 00 00 00 00 	lea    0x0(,%rdx,4),%rdx
  ff647d:	48 39 ca             	cmp    %rcx,%rdx
  ff6480:	0f 87 45 fd ff ff    	ja     ff61cb <ir_optimize_licm+0x1d0b>
  ff6486:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
  ff648b:	48 01 d0             	add    %rdx,%rax
  ff648e:	48 89 46 08          	mov    %rax,0x8(%rsi)
  ff6492:	48 8b 4e 20          	mov    0x20(%rsi),%rcx
  ff6496:	48 39 c8             	cmp    %rcx,%rax
  ff6499:	48 0f 46 c1          	cmovbe %rcx,%rax
  ff649d:	48 83 7c 24 48 00    	cmpq   $0x0,0x48(%rsp)
  ff64a3:	48 89 46 20          	mov    %rax,0x20(%rsi)
  ff64a7:	0f 84 1e fd ff ff    	je     ff61cb <ir_optimize_licm+0x1d0b>
  ff64ad:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  ff64b2:	31 f6                	xor    %esi,%esi
  ff64b4:	e8 27 37 90 ff       	call   8f9be0 <memset@plt>
  ff64b9:	e9 f3 07 00 00       	jmp    ff6cb1 <ir_optimize_licm+0x27f1>
  ff64be:	45 31 f6             	xor    %r14d,%r14d
  ff64c1:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  ff64c6:	4c 8b 54 24 30       	mov    0x30(%rsp),%r10
  ff64cb:	4c 8b 44 24 40       	mov    0x40(%rsp),%r8
  ff64d0:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  ff64d5:	45 31 c9             	xor    %r9d,%r9d
  ff64d8:	45 31 db             	xor    %r11d,%r11d
  ff64db:	e9 2d e9 ff ff       	jmp    ff4e0d <ir_optimize_licm+0x94d>
  ff64e0:	48 c7 44 24 48 00 00 00 00 	movq   $0x0,0x48(%rsp)
  ff64e9:	48 c7 84 24 c8 00 00 00 00 00 00 00 	movq   $0x0,0xc8(%rsp)
  ff64f5:	48 c7 84 24 90 00 00 00 00 00 00 00 	movq   $0x0,0x90(%rsp)
  ff6501:	48 c7 84 24 e0 00 00 00 00 00 00 00 	movq   $0x0,0xe0(%rsp)
  ff650d:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  ff6512:	83 78 48 00          	cmpl   $0x0,0x48(%rax)
  ff6516:	74 75                	je     ff658d <ir_optimize_licm+0x20cd>
  ff6518:	48 83 7c 24 60 ff    	cmpq   $0xffffffffffffffff,0x60(%rsp)
  ff651e:	74 37                	je     ff6557 <ir_optimize_licm+0x2097>
  ff6520:	48 83 bc 24 b8 00 00 00 ff 	cmpq   $0xffffffffffffffff,0xb8(%rsp)
  ff6529:	74 2c                	je     ff6557 <ir_optimize_licm+0x2097>
  ff652b:	31 c0                	xor    %eax,%eax
  ff652d:	48 8b 54 24 60       	mov    0x60(%rsp),%rdx
  ff6532:	48 8b b4 24 b8 00 00 00 	mov    0xb8(%rsp),%rsi
  ff653a:	8b 0c 82             	mov    (%rdx,%rax,4),%ecx
  ff653d:	01 4c 82 04          	add    %ecx,0x4(%rdx,%rax,4)
  ff6541:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
  ff6546:	89 0c 86             	mov    %ecx,(%rsi,%rax,4)
  ff6549:	48 ff c0             	inc    %rax
  ff654c:	44 8b 72 48          	mov    0x48(%rdx),%r14d
  ff6550:	4c 39 f0             	cmp    %r14,%rax
  ff6553:	72 d8                	jb     ff652d <ir_optimize_licm+0x206d>
  ff6555:	eb 36                	jmp    ff658d <ir_optimize_licm+0x20cd>
  ff6557:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  ff655c:	31 c9                	xor    %ecx,%ecx
  ff655e:	8b 00                	mov    (%rax),%eax
  ff6560:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
  ff6565:	89 c2                	mov    %eax,%edx
  ff6567:	48 8b bc 24 b8 00 00 00 	mov    0xb8(%rsp),%rdi
  ff656f:	8b 44 8e 04          	mov    0x4(%rsi,%rcx,4),%eax
  ff6573:	01 d0                	add    %edx,%eax
  ff6575:	89 44 8e 04          	mov    %eax,0x4(%rsi,%rcx,4)
  ff6579:	48 8b 74 24 28       	mov    0x28(%rsp),%rsi
  ff657e:	89 14 8f             	mov    %edx,(%rdi,%rcx,4)
  ff6581:	48 ff c1             	inc    %rcx
  ff6584:	44 8b 76 48          	mov    0x48(%rsi),%r14d
  ff6588:	4c 39 f1             	cmp    %r14,%rcx
  ff658b:	72 d3                	jb     ff6560 <ir_optimize_licm+0x20a0>
  ff658d:	8b 94 24 00 03 00 00 	mov    0x300(%rsp),%edx
  ff6594:	85 d2                	test   %edx,%edx
  ff6596:	0f 84 83 00 00 00    	je     ff661f <ir_optimize_licm+0x215f>
  ff659c:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  ff65a1:	4c 8b 8c 24 80 00 00 00 	mov    0x80(%rsp),%r9
  ff65a9:	4c 8b 94 24 b8 00 00 00 	mov    0xb8(%rsp),%r10
  ff65b1:	48 8b 48 40          	mov    0x40(%rax),%rcx
  ff65b5:	31 c0                	xor    %eax,%eax
  ff65b7:	eb 11                	jmp    ff65ca <ir_optimize_licm+0x210a>
  ff65b9:	8b 94 24 00 03 00 00 	mov    0x300(%rsp),%edx
  ff65c0:	48 ff c0             	inc    %rax
  ff65c3:	89 d6                	mov    %edx,%esi
  ff65c5:	48 39 f0             	cmp    %rsi,%rax
  ff65c8:	73 4c                	jae    ff6616 <ir_optimize_licm+0x2156>
  ff65ca:	48 8b b4 24 48 03 00 00 	mov    0x348(%rsp),%rsi
  ff65d2:	8b 34 86             	mov    (%rsi,%rax,4),%esi
  ff65d5:	8b 3c b1             	mov    (%rcx,%rsi,4),%edi
  ff65d8:	3b 7c b1 04          	cmp    0x4(%rcx,%rsi,4),%edi
  ff65dc:	72 0e                	jb     ff65ec <ir_optimize_licm+0x212c>
  ff65de:	eb e0                	jmp    ff65c0 <ir_optimize_licm+0x2100>
  ff65e0:	8b 54 b1 04          	mov    0x4(%rcx,%rsi,4),%edx
  ff65e4:	48 ff c7             	inc    %rdi
  ff65e7:	48 39 d7             	cmp    %rdx,%rdi
  ff65ea:	73 cd                	jae    ff65b9 <ir_optimize_licm+0x20f9>
  ff65ec:	48 8b 94 24 38 06 00 00 	mov    0x638(%rsp),%rdx
  ff65f4:	8b 14 ba             	mov    (%rdx,%rdi,4),%edx
  ff65f7:	39 f2                	cmp    %esi,%edx
  ff65f9:	74 e5                	je     ff65e0 <ir_optimize_licm+0x2120>
  ff65fb:	41 8b 0c 92          	mov    (%r10,%rdx,4),%ecx
  ff65ff:	44 8d 41 01          	lea    0x1(%rcx),%r8d
  ff6603:	45 89 04 92          	mov    %r8d,(%r10,%rdx,4)
  ff6607:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
  ff660c:	41 89 3c 89          	mov    %edi,(%r9,%rcx,4)
  ff6610:	48 8b 4a 40          	mov    0x40(%rdx),%rcx
  ff6614:	eb ca                	jmp    ff65e0 <ir_optimize_licm+0x2120>
  ff6616:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  ff661b:	44 8b 70 48          	mov    0x48(%rax),%r14d
  ff661f:	45 85 f6             	test   %r14d,%r14d
  ff6622:	0f 84 4b 02 00 00    	je     ff6873 <ir_optimize_licm+0x23b3>
  ff6628:	48 8b 74 24 28       	mov    0x28(%rsp),%rsi
  ff662d:	31 c0                	xor    %eax,%eax
  ff662f:	31 c9                	xor    %ecx,%ecx
  ff6631:	eb 20                	jmp    ff6653 <ir_optimize_licm+0x2193>
  ff6633:	ff ca                	dec    %edx
  ff6635:	89 c6                	mov    %eax,%esi
  ff6637:	ff c0                	inc    %eax
  ff6639:	4c 89 74 24 70       	mov    %r14,0x70(%rsp)
  ff663e:	41 89 14 b6          	mov    %edx,(%r14,%rsi,4)
  ff6642:	48 8b 74 24 28       	mov    0x28(%rsp),%rsi
  ff6647:	8b 56 48             	mov    0x48(%rsi),%edx
  ff664a:	48 39 d1             	cmp    %rdx,%rcx
  ff664d:	0f 83 f8 01 00 00    	jae    ff684b <ir_optimize_licm+0x238b>
  ff6653:	48 8b 94 24 98 00 00 00 	mov    0x98(%rsp),%rdx
  ff665b:	89 04 8a             	mov    %eax,(%rdx,%rcx,4)
  ff665e:	48 8b 56 40          	mov    0x40(%rsi),%rdx
  ff6662:	8b 3c 8a             	mov    (%rdx,%rcx,4),%edi
  ff6665:	8b 54 8a 04          	mov    0x4(%rdx,%rcx,4),%edx
  ff6669:	8d 77 01             	lea    0x1(%rdi),%esi
  ff666c:	39 d6                	cmp    %edx,%esi
  ff666e:	73 45                	jae    ff66b5 <ir_optimize_licm+0x21f5>
  ff6670:	41 89 f8             	mov    %edi,%r8d
  ff6673:	41 29 d0             	sub    %edx,%r8d
  ff6676:	89 f6                	mov    %esi,%esi
  ff6678:	41 89 fa             	mov    %edi,%r10d
  ff667b:	41 f7 d0             	not    %r8d
  ff667e:	41 83 e0 07          	and    $0x7,%r8d
  ff6682:	74 38                	je     ff66bc <ir_optimize_licm+0x21fc>
  ff6684:	4c 8b 74 24 70       	mov    0x70(%rsp),%r14
  ff6689:	eb 0b                	jmp    ff6696 <ir_optimize_licm+0x21d6>
  ff668b:	48 ff c6             	inc    %rsi
  ff668e:	41 ff c2             	inc    %r10d
  ff6691:	41 ff c8             	dec    %r8d
  ff6694:	74 2b                	je     ff66c1 <ir_optimize_licm+0x2201>
  ff6696:	4c 8b 8c 24 38 06 00 00 	mov    0x638(%rsp),%r9
  ff669e:	45 89 d3             	mov    %r10d,%r11d
  ff66a1:	47 8b 0c 99          	mov    (%r9,%r11,4),%r9d
  ff66a5:	4c 39 c9             	cmp    %r9,%rcx
  ff66a8:	75 e1                	jne    ff668b <ir_optimize_licm+0x21cb>
  ff66aa:	41 89 c1             	mov    %eax,%r9d
  ff66ad:	ff c0                	inc    %eax
  ff66af:	47 89 14 8e          	mov    %r10d,(%r14,%r9,4)
  ff66b3:	eb d6                	jmp    ff668b <ir_optimize_licm+0x21cb>
  ff66b5:	4c 8b 74 24 70       	mov    0x70(%rsp),%r14
  ff66ba:	eb 15                	jmp    ff66d1 <ir_optimize_licm+0x2211>
  ff66bc:	4c 8b 74 24 70       	mov    0x70(%rsp),%r14
  ff66c1:	41 89 d0             	mov    %edx,%r8d
  ff66c4:	41 29 f8             	sub    %edi,%r8d
  ff66c7:	41 83 c0 fe          	add    $0xfffffffe,%r8d
  ff66cb:	41 83 f8 07          	cmp    $0x7,%r8d
  ff66cf:	73 3c                	jae    ff670d <ir_optimize_licm+0x224d>
  ff66d1:	4c 8b 54 24 60       	mov    0x60(%rsp),%r10
  ff66d6:	4c 8b 8c 24 80 00 00 00 	mov    0x80(%rsp),%r9
  ff66de:	41 8b 34 8a          	mov    (%r10,%rcx,4),%esi
  ff66e2:	48 ff c1             	inc    %rcx
  ff66e5:	41 3b 34 8a          	cmp    (%r10,%rcx,4),%esi
  ff66e9:	0f 83 44 ff ff ff    	jae    ff6633 <ir_optimize_licm+0x2173>
  ff66ef:	41 8b 3c b1          	mov    (%r9,%rsi,4),%edi
  ff66f3:	41 89 c0             	mov    %eax,%r8d
  ff66f6:	ff c0                	inc    %eax
  ff66f8:	48 ff c6             	inc    %rsi
  ff66fb:	43 89 3c 86          	mov    %edi,(%r14,%r8,4)
  ff66ff:	41 8b 3c 8a          	mov    (%r10,%rcx,4),%edi
  ff6703:	48 39 fe             	cmp    %rdi,%rsi
  ff6706:	72 e7                	jb     ff66ef <ir_optimize_licm+0x222f>
  ff6708:	e9 26 ff ff ff       	jmp    ff6633 <ir_optimize_licm+0x2173>
  ff670d:	89 d7                	mov    %edx,%edi
  ff670f:	f7 df                	neg    %edi
  ff6711:	4c 8d 04 b5 00 00 00 00 	lea    0x0(,%rsi,4),%r8
  ff6719:	45 31 c9             	xor    %r9d,%r9d
  ff671c:	48 01 f7             	add    %rsi,%rdi
  ff671f:	eb 11                	jmp    ff6732 <ir_optimize_licm+0x2272>
  ff6721:	46 8d 54 0e 07       	lea    0x7(%rsi,%r9,1),%r10d
  ff6726:	49 83 c1 08          	add    $0x8,%r9
  ff672a:	41 89 fb             	mov    %edi,%r11d
  ff672d:	45 01 cb             	add    %r9d,%r11d
  ff6730:	74 9f                	je     ff66d1 <ir_optimize_licm+0x2211>
  ff6732:	4c 8b 9c 24 38 06 00 00 	mov    0x638(%rsp),%r11
  ff673a:	44 89 d3             	mov    %r10d,%ebx
  ff673d:	45 8b 1c 9b          	mov    (%r11,%rbx,4),%r11d
  ff6741:	4c 39 d9             	cmp    %r11,%rcx
  ff6744:	75 09                	jne    ff674f <ir_optimize_licm+0x228f>
  ff6746:	41 89 c3             	mov    %eax,%r11d
  ff6749:	ff c0                	inc    %eax
  ff674b:	47 89 14 9e          	mov    %r10d,(%r14,%r11,4)
  ff674f:	4c 8b 94 24 38 06 00 00 	mov    0x638(%rsp),%r10
  ff6757:	4d 01 c2             	add    %r8,%r10
  ff675a:	47 8b 14 8a          	mov    (%r10,%r9,4),%r10d
  ff675e:	4c 39 d1             	cmp    %r10,%rcx
  ff6761:	75 0d                	jne    ff6770 <ir_optimize_licm+0x22b0>
  ff6763:	41 89 c3             	mov    %eax,%r11d
  ff6766:	46 8d 14 0e          	lea    (%rsi,%r9,1),%r10d
  ff676a:	ff c0                	inc    %eax
  ff676c:	47 89 14 9e          	mov    %r10d,(%r14,%r11,4)
  ff6770:	4c 8b 94 24 38 06 00 00 	mov    0x638(%rsp),%r10
  ff6778:	4d 01 c2             	add    %r8,%r10
  ff677b:	47 8b 54 8a 04       	mov    0x4(%r10,%r9,4),%r10d
  ff6780:	4c 39 d1             	cmp    %r10,%rcx
  ff6783:	75 0e                	jne    ff6793 <ir_optimize_licm+0x22d3>
  ff6785:	46 8d 54 0e 01       	lea    0x1(%rsi,%r9,1),%r10d
  ff678a:	41 89 c3             	mov    %eax,%r11d
  ff678d:	ff c0                	inc    %eax
  ff678f:	47 89 14 9e          	mov    %r10d,(%r14,%r11,4)
  ff6793:	4c 8b 94 24 38 06 00 00 	mov    0x638(%rsp),%r10
  ff679b:	4d 01 c2             	add    %r8,%r10
  ff679e:	47 8b 54 8a 08       	mov    0x8(%r10,%r9,4),%r10d
  ff67a3:	4c 39 d1             	cmp    %r10,%rcx
  ff67a6:	75 0e                	jne    ff67b6 <ir_optimize_licm+0x22f6>
  ff67a8:	46 8d 54 0e 02       	lea    0x2(%rsi,%r9,1),%r10d
  ff67ad:	41 89 c3             	mov    %eax,%r11d
  ff67b0:	ff c0                	inc    %eax
  ff67b2:	47 89 14 9e          	mov    %r10d,(%r14,%r11,4)
  ff67b6:	4c 8b 94 24 38 06 00 00 	mov    0x638(%rsp),%r10
  ff67be:	4d 01 c2             	add    %r8,%r10
  ff67c1:	47 8b 54 8a 0c       	mov    0xc(%r10,%r9,4),%r10d
  ff67c6:	4c 39 d1             	cmp    %r10,%rcx
  ff67c9:	75 0e                	jne    ff67d9 <ir_optimize_licm+0x2319>
  ff67cb:	46 8d 54 0e 03       	lea    0x3(%rsi,%r9,1),%r10d
  ff67d0:	41 89 c3             	mov    %eax,%r11d
  ff67d3:	ff c0                	inc    %eax
  ff67d5:	47 89 14 9e          	mov    %r10d,(%r14,%r11,4)
  ff67d9:	4c 8b 94 24 38 06 00 00 	mov    0x638(%rsp),%r10
  ff67e1:	4d 01 c2             	add    %r8,%r10
  ff67e4:	47 8b 54 8a 10       	mov    0x10(%r10,%r9,4),%r10d
  ff67e9:	4c 39 d1             	cmp    %r10,%rcx
  ff67ec:	75 0e                	jne    ff67fc <ir_optimize_licm+0x233c>
  ff67ee:	46 8d 54 0e 04       	lea    0x4(%rsi,%r9,1),%r10d
  ff67f3:	41 89 c3             	mov    %eax,%r11d
  ff67f6:	ff c0                	inc    %eax
  ff67f8:	47 89 14 9e          	mov    %r10d,(%r14,%r11,4)
  ff67fc:	4c 8b 94 24 38 06 00 00 	mov    0x638(%rsp),%r10
  ff6804:	4d 01 c2             	add    %r8,%r10
  ff6807:	47 8b 54 8a 14       	mov    0x14(%r10,%r9,4),%r10d
  ff680c:	4c 39 d1             	cmp    %r10,%rcx
  ff680f:	75 0e                	jne    ff681f <ir_optimize_licm+0x235f>
  ff6811:	46 8d 54 0e 05       	lea    0x5(%rsi,%r9,1),%r10d
  ff6816:	41 89 c3             	mov    %eax,%r11d
  ff6819:	ff c0                	inc    %eax
  ff681b:	47 89 14 9e          	mov    %r10d,(%r14,%r11,4)
  ff681f:	4c 8b 94 24 38 06 00 00 	mov    0x638(%rsp),%r10
  ff6827:	4d 01 c2             	add    %r8,%r10
  ff682a:	47 8b 54 8a 18       	mov    0x18(%r10,%r9,4),%r10d
  ff682f:	4c 39 d1             	cmp    %r10,%rcx
  ff6832:	0f 85 e9 fe ff ff    	jne    ff6721 <ir_optimize_licm+0x2261>
  ff6838:	46 8d 54 0e 06       	lea    0x6(%rsi,%r9,1),%r10d
  ff683d:	41 89 c3             	mov    %eax,%r11d
  ff6840:	ff c0                	inc    %eax
  ff6842:	47 89 14 9e          	mov    %r10d,(%r14,%r11,4)
  ff6846:	e9 d6 fe ff ff       	jmp    ff6721 <ir_optimize_licm+0x2261>
  ff684b:	48 8b 8c 24 98 00 00 00 	mov    0x98(%rsp),%rcx
  ff6853:	89 04 91             	mov    %eax,(%rcx,%rdx,4)
  ff6856:	85 c0                	test   %eax,%eax
  ff6858:	74 27                	je     ff6881 <ir_optimize_licm+0x23c1>
  ff685a:	41 89 c6             	mov    %eax,%r14d
  ff685d:	44 89 f1             	mov    %r14d,%ecx
  ff6860:	83 e1 07             	and    $0x7,%ecx
  ff6863:	83 f8 08             	cmp    $0x8,%eax
  ff6866:	0f 83 66 05 00 00    	jae    ff6dd2 <ir_optimize_licm+0x2912>
  ff686c:	31 c0                	xor    %eax,%eax
  ff686e:	e9 db 05 00 00       	jmp    ff6e4e <ir_optimize_licm+0x298e>
  ff6873:	48 8b 84 24 98 00 00 00 	mov    0x98(%rsp),%rax
  ff687b:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
  ff6881:	48 8b 84 24 88 00 00 00 	mov    0x88(%rsp),%rax
  ff6889:	48 8b 94 24 a8 00 00 00 	mov    0xa8(%rsp),%rdx
  ff6891:	48 8b 8c 24 c0 00 00 00 	mov    0xc0(%rsp),%rcx
  ff6899:	c5 fd 6f 84 24 00 01 00 00 	vmovdqa 0x100(%rsp),%ymm0
  ff68a2:	c5 fe 6f 9c 24 14 01 00 00 	vmovdqu 0x114(%rsp),%ymm3
  ff68ab:	62 f1 7c 48 10 8c 24 14 08 00 00 	vmovups 0x814(%rsp),%zmm1
  ff68b6:	62 f1 fd 48 6f 54 24 1f 	vmovdqa64 0x7c0(%rsp),%zmm2
  ff68be:	48 8b 5c 24 30       	mov    0x30(%rsp),%rbx
  ff68c3:	48 8d bc 24 40 01 00 00 	lea    0x140(%rsp),%rdi
  ff68cb:	48 33 5c 24 20       	xor    0x20(%rsp),%rbx
  ff68d0:	48 89 bc 24 98 02 00 00 	mov    %rdi,0x298(%rsp)
  ff68d8:	48 89 84 24 40 01 00 00 	mov    %rax,0x140(%rsp)
  ff68e0:	48 89 94 24 48 01 00 00 	mov    %rdx,0x148(%rsp)
  ff68e8:	48 89 8c 24 50 01 00 00 	mov    %rcx,0x150(%rsp)
  ff68f0:	48 8b 54 24 78       	mov    0x78(%rsp),%rdx
  ff68f5:	48 8b 8c 24 b0 00 00 00 	mov    0xb0(%rsp),%rcx
  ff68fd:	48 8b 84 24 c8 00 00 00 	mov    0xc8(%rsp),%rax
  ff6905:	48 89 94 24 58 01 00 00 	mov    %rdx,0x158(%rsp)
  ff690d:	48 89 8c 24 60 01 00 00 	mov    %rcx,0x160(%rsp)
  ff6915:	48 8b 54 24 68       	mov    0x68(%rsp),%rdx
  ff691a:	48 8b 8c 24 a0 00 00 00 	mov    0xa0(%rsp),%rcx
  ff6922:	48 89 94 24 68 01 00 00 	mov    %rdx,0x168(%rsp)
  ff692a:	48 89 8c 24 70 01 00 00 	mov    %rcx,0x170(%rsp)
  ff6932:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  ff6937:	48 8b 8c 24 98 00 00 00 	mov    0x98(%rsp),%rcx
  ff693f:	48 89 94 24 78 01 00 00 	mov    %rdx,0x178(%rsp)
  ff6947:	48 89 8c 24 80 01 00 00 	mov    %rcx,0x180(%rsp)
  ff694f:	48 8b 94 24 d8 00 00 00 	mov    0xd8(%rsp),%rdx
  ff6957:	48 8b 4c 24 48       	mov    0x48(%rsp),%rcx
  ff695c:	48 89 94 24 88 01 00 00 	mov    %rdx,0x188(%rsp)
  ff6964:	48 89 8c 24 90 01 00 00 	mov    %rcx,0x190(%rsp)
  ff696c:	89 84 24 98 01 00 00 	mov    %eax,0x198(%rsp)
  ff6973:	48 8b 84 24 90 00 00 00 	mov    0x90(%rsp),%rax
  ff697b:	c5 fe 7f 84 24 9c 01 00 00 	vmovdqu %ymm0,0x19c(%rsp)
  ff6984:	c5 fe 7f 9c 24 b0 01 00 00 	vmovdqu %ymm3,0x1b0(%rsp)
  ff698d:	48 89 84 24 d0 01 00 00 	mov    %rax,0x1d0(%rsp)
  ff6995:	48 8b 84 24 e0 00 00 00 	mov    0xe0(%rsp),%rax
  ff699d:	89 84 24 d8 01 00 00 	mov    %eax,0x1d8(%rsp)
  ff69a4:	62 f1 7c 48 11 8c 24 30 02 00 00 	vmovups %zmm1,0x230(%rsp)
  ff69af:	62 f1 fd 48 6f 4c 24 20 	vmovdqa64 0x800(%rsp),%zmm1
  ff69b7:	62 f1 fe 48 7f 94 24 dc 01 00 00 	vmovdqu64 %zmm2,0x1dc(%rsp)
  ff69c2:	62 f1 fe 48 7f 8c 24 1c 02 00 00 	vmovdqu64 %zmm1,0x21c(%rsp)
  ff69cd:	c5 f8 77             	vzeroupper
  ff69d0:	e8 fb bb e2 ff       	call   e225d0 <ir_check_shape>
  ff69d5:	89 c1                	mov    %eax,%ecx
  ff69d7:	4c 8d 68 03          	lea    0x3(%rax),%r13
  ff69db:	48 09 d9             	or     %rbx,%rcx
  ff69de:	4c 0f 45 e8          	cmovne %rax,%r13
  ff69e2:	45 85 ed             	test   %r13d,%r13d
  ff69e5:	74 23                	je     ff6a0a <ir_optimize_licm+0x254a>
  ff69e7:	45 85 ed             	test   %r13d,%r13d
  ff69ea:	74 38                	je     ff6a24 <ir_optimize_licm+0x2564>
  ff69ec:	45 85 ed             	test   %r13d,%r13d
  ff69ef:	74 5c                	je     ff6a4d <ir_optimize_licm+0x258d>
  ff69f1:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  ff69f6:	48 8b 5c 24 20       	mov    0x20(%rsp),%rbx
  ff69fb:	4c 8b 54 24 30       	mov    0x30(%rsp),%r10
  ff6a00:	4c 8b 44 24 40       	mov    0x40(%rsp),%r8
  ff6a05:	e9 53 e0 ff ff       	jmp    ff4a5d <ir_optimize_licm+0x59d>
  ff6a0a:	48 8d bc 24 40 01 00 00 	lea    0x140(%rsp),%rdi
  ff6a12:	be 01 00 00 00       	mov    $0x1,%esi
  ff6a17:	e8 64 c1 e2 ff       	call   e22b80 <ir_check_rows>
  ff6a1c:	49 89 c5             	mov    %rax,%r13
  ff6a1f:	45 85 ed             	test   %r13d,%r13d
  ff6a22:	75 c8                	jne    ff69ec <ir_optimize_licm+0x252c>
  ff6a24:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
  ff6a29:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
  ff6a2e:	48 8d 8c 24 a0 02 00 00 	lea    0x2a0(%rsp),%rcx
  ff6a36:	48 8d bc 24 40 01 00 00 	lea    0x140(%rsp),%rdi
  ff6a3e:	e8 fd d4 e2 ff       	call   e23f40 <ir_cfg_validated>
  ff6a43:	89 c0                	mov    %eax,%eax
  ff6a45:	49 09 c5             	or     %rax,%r13
  ff6a48:	45 85 ed             	test   %r13d,%r13d
  ff6a4b:	75 a4                	jne    ff69f1 <ir_optimize_licm+0x2531>
  ff6a4d:	83 bc 24 88 01 00 00 00 	cmpl   $0x0,0x188(%rsp)
  ff6a55:	74 69                	je     ff6ac0 <ir_optimize_licm+0x2600>
  ff6a57:	31 c0                	xor    %eax,%eax
  ff6a59:	eb 0f                	jmp    ff6a6a <ir_optimize_licm+0x25aa>
  ff6a5b:	8b 8c 24 88 01 00 00 	mov    0x188(%rsp),%ecx
  ff6a62:	48 ff c0             	inc    %rax
  ff6a65:	48 39 c8             	cmp    %rcx,%rax
  ff6a68:	73 56                	jae    ff6ac0 <ir_optimize_licm+0x2600>
  ff6a6a:	48 8b 8c 24 50 03 00 00 	mov    0x350(%rsp),%rcx
  ff6a72:	48 8b 94 24 d0 03 00 00 	mov    0x3d0(%rsp),%rdx
  ff6a7a:	83 3c 81 ff          	cmpl   $0xffffffff,(%rcx,%rax,4)
  ff6a7e:	0f 95 04 02          	setne  (%rdx,%rax,1)
  ff6a82:	48 8b 94 24 a8 02 00 00 	mov    0x2a8(%rsp),%rdx
  ff6a8a:	8b 0c 82             	mov    (%rdx,%rax,4),%ecx
  ff6a8d:	3b 4c 82 04          	cmp    0x4(%rdx,%rax,4),%ecx
  ff6a91:	73 c8                	jae    ff6a5b <ir_optimize_licm+0x259b>
  ff6a93:	48 8b 94 24 d0 03 00 00 	mov    0x3d0(%rsp),%rdx
  ff6a9b:	48 8b b4 24 d8 03 00 00 	mov    0x3d8(%rsp),%rsi
  ff6aa3:	0f b6 14 02          	movzbl (%rdx,%rax,1),%edx
  ff6aa7:	88 14 0e             	mov    %dl,(%rsi,%rcx,1)
  ff6aaa:	48 ff c1             	inc    %rcx
  ff6aad:	48 8b 94 24 a8 02 00 00 	mov    0x2a8(%rsp),%rdx
  ff6ab5:	8b 54 82 04          	mov    0x4(%rdx,%rax,4),%edx
  ff6ab9:	48 39 d1             	cmp    %rdx,%rcx
  ff6abc:	72 d5                	jb     ff6a93 <ir_optimize_licm+0x25d3>
  ff6abe:	eb 9b                	jmp    ff6a5b <ir_optimize_licm+0x259b>
  ff6ac0:	83 bc 24 78 01 00 00 00 	cmpl   $0x0,0x178(%rsp)
  ff6ac8:	74 3f                	je     ff6b09 <ir_optimize_licm+0x2649>
  ff6aca:	31 c0                	xor    %eax,%eax
  ff6acc:	48 8b 8c 24 c0 03 00 00 	mov    0x3c0(%rsp),%rcx
  ff6ad4:	c6 04 01 02          	movb   $0x2,(%rcx,%rax,1)
  ff6ad8:	48 8b 8c 24 c8 02 00 00 	mov    0x2c8(%rsp),%rcx
  ff6ae0:	48 8b 94 24 d0 03 00 00 	mov    0x3d0(%rsp),%rdx
  ff6ae8:	48 8b b4 24 e0 03 00 00 	mov    0x3e0(%rsp),%rsi
  ff6af0:	8b 0c 81             	mov    (%rcx,%rax,4),%ecx
  ff6af3:	0f b6 0c 0a          	movzbl (%rdx,%rcx,1),%ecx
  ff6af7:	88 0c 06             	mov    %cl,(%rsi,%rax,1)
  ff6afa:	48 ff c0             	inc    %rax
  ff6afd:	8b 8c 24 78 01 00 00 	mov    0x178(%rsp),%ecx
  ff6b04:	48 39 c8             	cmp    %rcx,%rax
  ff6b07:	72 c3                	jb     ff6acc <ir_optimize_licm+0x260c>
  ff6b09:	4c 8b 74 24 30       	mov    0x30(%rsp),%r14
  ff6b0e:	48 8b 5c 24 20       	mov    0x20(%rsp),%rbx
  ff6b13:	4c 8d bc 24 60 06 00 00 	lea    0x660(%rsp),%r15
  ff6b1b:	48 8d bc 24 98 02 00 00 	lea    0x298(%rsp),%rdi
  ff6b23:	48 b9 00 00 00 00 40 00 00 00 	movabs $0x4000000000,%rcx
  ff6b2d:	4c 8b 84 24 d0 00 00 00 	mov    0xd0(%rsp),%r8
  ff6b35:	4d 89 f9             	mov    %r15,%r9
  ff6b38:	4c 89 f6             	mov    %r14,%rsi
  ff6b3b:	48 89 da             	mov    %rbx,%rdx
  ff6b3e:	e8 bd ed 00 00       	call   1005900 <ir_optimize_rewrite>
  ff6b43:	4d 89 f2             	mov    %r14,%r10
  ff6b46:	41 89 c5             	mov    %eax,%r13d
  ff6b49:	4c 8b 44 24 40       	mov    0x40(%rsp),%r8
  ff6b4e:	85 c0                	test   %eax,%eax
  ff6b50:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  ff6b55:	0f 85 02 df ff ff    	jne    ff4a5d <ir_optimize_licm+0x59d>
  ff6b5b:	48 89 d9             	mov    %rbx,%rcx
  ff6b5e:	48 8b 5b 08          	mov    0x8(%rbx),%rbx
  ff6b62:	48 8d bc 24 c0 07 00 00 	lea    0x7c0(%rsp),%rdi
  ff6b6a:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
  ff6b6e:	4c 8b 84 24 d0 00 00 00 	mov    0xd0(%rsp),%r8
  ff6b76:	62 f1 fe 48 7f 84 24 58 0a 00 00 	vmovdqu64 %zmm0,0xa58(%rsp)
  ff6b81:	62 f1 fe 48 7f 84 24 48 0a 00 00 	vmovdqu64 %zmm0,0xa48(%rsp)
  ff6b8c:	62 f1 fe 48 7f 84 24 08 0a 00 00 	vmovdqu64 %zmm0,0xa08(%rsp)
  ff6b97:	62 f1 fe 48 7f 84 24 c8 09 00 00 	vmovdqu64 %zmm0,0x9c8(%rsp)
  ff6ba2:	62 f1 fe 48 7f 84 24 88 09 00 00 	vmovdqu64 %zmm0,0x988(%rsp)
  ff6bad:	62 f1 fe 48 7f 84 24 48 09 00 00 	vmovdqu64 %zmm0,0x948(%rsp)
  ff6bb8:	62 f1 fe 48 7f 84 24 08 09 00 00 	vmovdqu64 %zmm0,0x908(%rsp)
  ff6bc3:	62 f1 fe 48 7f 84 24 c8 08 00 00 	vmovdqu64 %zmm0,0x8c8(%rsp)
  ff6bce:	62 f1 fe 48 7f 84 24 88 08 00 00 	vmovdqu64 %zmm0,0x888(%rsp)
  ff6bd9:	62 f1 fe 48 7f 84 24 48 08 00 00 	vmovdqu64 %zmm0,0x848(%rsp)
  ff6be4:	62 f1 fe 48 7f 84 24 08 08 00 00 	vmovdqu64 %zmm0,0x808(%rsp)
  ff6bef:	62 f1 fe 48 7f 84 24 c8 07 00 00 	vmovdqu64 %zmm0,0x7c8(%rsp)
  ff6bfa:	4c 89 fe             	mov    %r15,%rsi
  ff6bfd:	4c 89 d2             	mov    %r10,%rdx
  ff6c00:	c5 f8 77             	vzeroupper
  ff6c03:	e8 b8 dd 00 00       	call   10049c0 <ir_optimize_prepare>
  ff6c08:	48 89 c1             	mov    %rax,%rcx
  ff6c0b:	85 c9                	test   %ecx,%ecx
  ff6c0d:	75 50                	jne    ff6c5f <ir_optimize_licm+0x279f>
  ff6c0f:	c5 fa 6f 84 24 90 08 00 00 	vmovdqu 0x890(%rsp),%xmm0
  ff6c18:	8b 84 24 a8 06 00 00 	mov    0x6a8(%rsp),%eax
  ff6c1f:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
  ff6c24:	48 8d 94 24 00 01 00 00 	lea    0x100(%rsp),%rdx
  ff6c2c:	4c 89 ff             	mov    %r15,%rdi
  ff6c2f:	c5 f9 7f 84 24 00 01 00 00 	vmovdqa %xmm0,0x100(%rsp)
  ff6c38:	89 84 24 10 01 00 00 	mov    %eax,0x110(%rsp)
  ff6c3f:	48 8b 84 24 d0 00 00 00 	mov    0xd0(%rsp),%rax
  ff6c47:	c7 84 24 14 01 00 00 00 00 00 00 	movl   $0x0,0x114(%rsp)
  ff6c52:	f6 d0                	not    %al
  ff6c54:	0f b6 c8             	movzbl %al,%ecx
  ff6c57:	83 e1 01             	and    $0x1,%ecx
  ff6c5a:	e8 61 ab e2 ff       	call   e217c0 <ir_verify_path>
  ff6c5f:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  ff6c64:	48 3b 59 08          	cmp    0x8(%rcx),%rbx
  ff6c68:	0f 87 31 06 00 00    	ja     ff729f <ir_optimize_licm+0x2ddf>
  ff6c6e:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  ff6c73:	48 89 59 08          	mov    %rbx,0x8(%rcx)
  ff6c77:	85 c0                	test   %eax,%eax
  ff6c79:	0f 84 94 05 00 00    	je     ff7213 <ir_optimize_licm+0x2d53>
  ff6c7f:	48 8b 5c 24 20       	mov    0x20(%rsp),%rbx
  ff6c84:	4c 8b 54 24 30       	mov    0x30(%rsp),%r10
  ff6c89:	41 89 c5             	mov    %eax,%r13d
  ff6c8c:	49 89 d0             	mov    %rdx,%r8
  ff6c8f:	e9 c9 dd ff ff       	jmp    ff4a5d <ir_optimize_licm+0x59d>
  ff6c94:	4d 89 e3             	mov    %r12,%r11
  ff6c97:	e9 4a 05 00 00       	jmp    ff71e6 <ir_optimize_licm+0x2d26>
  ff6c9c:	48 c7 84 24 c8 00 00 00 00 00 00 00 	movq   $0x0,0xc8(%rsp)
  ff6ca8:	48 c7 44 24 48 00 00 00 00 	movq   $0x0,0x48(%rsp)
  ff6cb1:	4d 85 e4             	test   %r12,%r12
  ff6cb4:	0f 84 48 05 00 00    	je     ff7202 <ir_optimize_licm+0x2d42>
  ff6cba:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  ff6cbf:	48 8b 08             	mov    (%rax),%rcx
  ff6cc2:	48 8b 40 08          	mov    0x8(%rax),%rax
  ff6cc6:	48 8d 74 08 3f       	lea    0x3f(%rax,%rcx,1),%rsi
  ff6ccb:	48 01 c8             	add    %rcx,%rax
  ff6cce:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
  ff6cd2:	48 89 b4 24 90 00 00 00 	mov    %rsi,0x90(%rsp)
  ff6cda:	48 39 c6             	cmp    %rax,%rsi
  ff6cdd:	0f 82 e8 f4 ff ff    	jb     ff61cb <ir_optimize_licm+0x1d0b>
  ff6ce3:	4a 8d 04 e5 00 00 00 00 	lea    0x0(,%r12,8),%rax
  ff6ceb:	48 8d 14 40          	lea    (%rax,%rax,2),%rdx
  ff6cef:	48 8b 84 24 90 00 00 00 	mov    0x90(%rsp),%rax
  ff6cf7:	48 29 c8             	sub    %rcx,%rax
  ff6cfa:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  ff6cff:	48 8b 49 10          	mov    0x10(%rcx),%rcx
  ff6d03:	48 29 c1             	sub    %rax,%rcx
  ff6d06:	40 0f 92 c6          	setb   %sil
  ff6d0a:	48 39 ca             	cmp    %rcx,%rdx
  ff6d0d:	0f 97 c1             	seta   %cl
  ff6d10:	40 08 f1             	or     %sil,%cl
  ff6d13:	0f 85 b2 f4 ff ff    	jne    ff61cb <ir_optimize_licm+0x1d0b>
  ff6d19:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
  ff6d1e:	48 01 d0             	add    %rdx,%rax
  ff6d21:	4c 8b 54 24 30       	mov    0x30(%rsp),%r10
  ff6d26:	4c 8b 44 24 40       	mov    0x40(%rsp),%r8
  ff6d2b:	41 bd 02 00 00 00    	mov    $0x2,%r13d
  ff6d31:	48 89 46 08          	mov    %rax,0x8(%rsi)
  ff6d35:	48 8b 4e 20          	mov    0x20(%rsi),%rcx
  ff6d39:	48 39 c8             	cmp    %rcx,%rax
  ff6d3c:	48 0f 46 c1          	cmovbe %rcx,%rax
  ff6d40:	48 83 bc 24 90 00 00 00 00 	cmpq   $0x0,0x90(%rsp)
  ff6d49:	48 89 46 20          	mov    %rax,0x20(%rsi)
  ff6d4d:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  ff6d52:	0f 84 88 f4 ff ff    	je     ff61e0 <ir_optimize_licm+0x1d20>
  ff6d58:	48 8b bc 24 90 00 00 00 	mov    0x90(%rsp),%rdi
  ff6d60:	31 f6                	xor    %esi,%esi
  ff6d62:	e8 79 2e 90 ff       	call   8f9be0 <memset@plt>
  ff6d67:	4c 89 a4 24 e0 00 00 00 	mov    %r12,0xe0(%rsp)
  ff6d6f:	e9 99 f7 ff ff       	jmp    ff650d <ir_optimize_licm+0x204d>
  ff6d74:	48 89 d8             	mov    %rbx,%rax
  ff6d77:	48 29 c8             	sub    %rcx,%rax
  ff6d7a:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  ff6d7f:	48 8b 49 10          	mov    0x10(%rcx),%rcx
  ff6d83:	48 29 c1             	sub    %rax,%rcx
  ff6d86:	0f 82 54 04 00 00    	jb     ff71e0 <ir_optimize_licm+0x2d20>
  ff6d8c:	48 c1 e2 02          	shl    $0x2,%rdx
  ff6d90:	48 39 ca             	cmp    %rcx,%rdx
  ff6d93:	0f 87 47 04 00 00    	ja     ff71e0 <ir_optimize_licm+0x2d20>
  ff6d99:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
  ff6d9e:	48 01 d0             	add    %rdx,%rax
  ff6da1:	48 89 46 08          	mov    %rax,0x8(%rsi)
  ff6da5:	48 8b 4e 20          	mov    0x20(%rsi),%rcx
  ff6da9:	48 39 c8             	cmp    %rcx,%rax
  ff6dac:	48 0f 46 c1          	cmovbe %rcx,%rax
  ff6db0:	48 89 46 20          	mov    %rax,0x20(%rsi)
  ff6db4:	48 85 db             	test   %rbx,%rbx
  ff6db7:	0f 84 1d f6 ff ff    	je     ff63da <ir_optimize_licm+0x1f1a>
  ff6dbd:	48 89 df             	mov    %rbx,%rdi
  ff6dc0:	31 f6                	xor    %esi,%esi
  ff6dc2:	e8 19 2e 90 ff       	call   8f9be0 <memset@plt>
  ff6dc7:	4d 89 e3             	mov    %r12,%r11
  ff6dca:	49 89 d9             	mov    %rbx,%r9
  ff6dcd:	e9 70 f5 ff ff       	jmp    ff6342 <ir_optimize_licm+0x1e82>
  ff6dd2:	4c 8b 44 24 70       	mov    0x70(%rsp),%r8
  ff6dd7:	4c 8b 4c 24 50       	mov    0x50(%rsp),%r9
  ff6ddc:	44 89 f2             	mov    %r14d,%edx
  ff6ddf:	83 e2 f8             	and    $0xfffffff8,%edx
  ff6de2:	31 c0                	xor    %eax,%eax
  ff6de4:	41 8b 34 80          	mov    (%r8,%rax,4),%esi
  ff6de8:	8d 78 01             	lea    0x1(%rax),%edi
  ff6deb:	41 89 04 b1          	mov    %eax,(%r9,%rsi,4)
  ff6def:	41 8b 74 80 04       	mov    0x4(%r8,%rax,4),%esi
  ff6df4:	41 89 3c b1          	mov    %edi,(%r9,%rsi,4)
  ff6df8:	8d 78 02             	lea    0x2(%rax),%edi
  ff6dfb:	41 8b 74 80 08       	mov    0x8(%r8,%rax,4),%esi
  ff6e00:	41 89 3c b1          	mov    %edi,(%r9,%rsi,4)
  ff6e04:	8d 78 03             	lea    0x3(%rax),%edi
  ff6e07:	41 8b 74 80 0c       	mov    0xc(%r8,%rax,4),%esi
  ff6e0c:	41 89 3c b1          	mov    %edi,(%r9,%rsi,4)
  ff6e10:	8d 78 04             	lea    0x4(%rax),%edi
  ff6e13:	41 8b 74 80 10       	mov    0x10(%r8,%rax,4),%esi
  ff6e18:	41 89 3c b1          	mov    %edi,(%r9,%rsi,4)
  ff6e1c:	8d 78 05             	lea    0x5(%rax),%edi
  ff6e1f:	41 8b 74 80 14       	mov    0x14(%r8,%rax,4),%esi
  ff6e24:	41 89 3c b1          	mov    %edi,(%r9,%rsi,4)
  ff6e28:	8d 78 06             	lea    0x6(%rax),%edi
  ff6e2b:	41 8b 74 80 18       	mov    0x18(%r8,%rax,4),%esi
  ff6e30:	41 89 3c b1          	mov    %edi,(%r9,%rsi,4)
  ff6e34:	8d 78 07             	lea    0x7(%rax),%edi
  ff6e37:	41 8b 74 80 1c       	mov    0x1c(%r8,%rax,4),%esi
  ff6e3c:	48 83 c0 08          	add    $0x8,%rax
  ff6e40:	41 89 3c b1          	mov    %edi,(%r9,%rsi,4)
  ff6e44:	48 39 d0             	cmp    %rdx,%rax
  ff6e47:	75 9b                	jne    ff6de4 <ir_optimize_licm+0x2924>
  ff6e49:	48 85 c9             	test   %rcx,%rcx
  ff6e4c:	74 18                	je     ff6e66 <ir_optimize_licm+0x29a6>
  ff6e4e:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  ff6e53:	48 8b 54 24 70       	mov    0x70(%rsp),%rdx
  ff6e58:	8b 14 82             	mov    (%rdx,%rax,4),%edx
  ff6e5b:	89 04 96             	mov    %eax,(%rsi,%rdx,4)
  ff6e5e:	48 ff c0             	inc    %rax
  ff6e61:	48 ff c9             	dec    %rcx
  ff6e64:	75 ed                	jne    ff6e53 <ir_optimize_licm+0x2993>
  ff6e66:	45 31 e4             	xor    %r12d,%r12d
  ff6e69:	31 db                	xor    %ebx,%ebx
  ff6e6b:	c7 44 24 60 00 00 00 00 	movl   $0x0,0x60(%rsp)
  ff6e73:	eb 59                	jmp    ff6ece <ir_optimize_licm+0x2a0e>
  ff6e75:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  ff6e7a:	4c 8b 44 24 28       	mov    0x28(%rsp),%r8
  ff6e7f:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  ff6e84:	44 89 e2             	mov    %r12d,%edx
  ff6e87:	44 89 24 98          	mov    %r12d,(%rax,%rbx,4)
  ff6e8b:	48 8d 3c 96          	lea    (%rsi,%rdx,4),%rdi
  ff6e8f:	49 8b 40 28          	mov    0x28(%r8),%rax
  ff6e93:	49 8b 48 30          	mov    0x30(%r8),%rcx
  ff6e97:	42 8b 34 a8          	mov    (%rax,%r13,4),%esi
  ff6e9b:	42 8b 0c a9          	mov    (%rcx,%r13,4),%ecx
  ff6e9f:	48 c1 e6 02          	shl    $0x2,%rsi
  ff6ea3:	49 03 70 50          	add    0x50(%r8),%rsi
  ff6ea7:	4c 8d 7c 09 01       	lea    0x1(%rcx,%rcx,1),%r15
  ff6eac:	48 01 c9             	add    %rcx,%rcx
  ff6eaf:	48 8d 14 8d 04 00 00 00 	lea    0x4(,%rcx,4),%rdx
  ff6eb7:	e8 54 2e 90 ff       	call   8f9d10 <memcpy@plt>
  ff6ebc:	45 01 e7             	add    %r12d,%r15d
  ff6ebf:	45 89 fc             	mov    %r15d,%r12d
  ff6ec2:	48 ff c3             	inc    %rbx
  ff6ec5:	4c 39 f3             	cmp    %r14,%rbx
  ff6ec8:	0f 84 b3 f9 ff ff    	je     ff6881 <ir_optimize_licm+0x23c1>
  ff6ece:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  ff6ed3:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  ff6ed8:	48 ba ff ff ff ff ff 9b f7 ff 	movabs $0xfff79bffffffffff,%rdx
  ff6ee2:	44 8b 2c 98          	mov    (%rax,%rbx,4),%r13d
  ff6ee6:	48 8b 01             	mov    (%rcx),%rax
  ff6ee9:	42 0f b6 0c 28       	movzbl (%rax,%r13,1),%ecx
  ff6eee:	48 8d 05 0b 09 52 ff 	lea    -0xadf6f5(%rip),%rax        # 517800 <ir_operand_table>
  ff6ef5:	0f b6 04 01          	movzbl (%rcx,%rax,1),%eax
  ff6ef9:	48 0f a3 ca          	bt     %rcx,%rdx
  ff6efd:	72 51                	jb     ff6f50 <ir_optimize_licm+0x2a90>
  ff6eff:	4c 8b 4c 24 28       	mov    0x28(%rsp),%r9
  ff6f04:	45 31 c0             	xor    %r8d,%r8d
  ff6f07:	48 8d 15 b2 0a 52 ff 	lea    -0xadf54e(%rip),%rdx        # 5179c0 <ir_optional_table>
  ff6f0e:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
  ff6f12:	49 8b 71 20          	mov    0x20(%r9),%rsi
  ff6f16:	49 8b 79 28          	mov    0x28(%r9),%rdi
  ff6f1a:	42 83 3c ae ff       	cmpl   $0xffffffff,(%rsi,%r13,4)
  ff6f1f:	41 0f 95 c0          	setne  %r8b
  ff6f23:	31 f6                	xor    %esi,%esi
  ff6f25:	42 83 3c af ff       	cmpl   $0xffffffff,(%rdi,%r13,4)
  ff6f2a:	49 8b 79 30          	mov    0x30(%r9),%rdi
  ff6f2e:	40 0f 95 c6          	setne  %sil
  ff6f32:	01 f6                	add    %esi,%esi
  ff6f34:	44 09 c6             	or     %r8d,%esi
  ff6f37:	45 31 c0             	xor    %r8d,%r8d
  ff6f3a:	42 83 3c af ff       	cmpl   $0xffffffff,(%rdi,%r13,4)
  ff6f3f:	41 0f 95 c0          	setne  %r8b
  ff6f43:	41 c1 e0 02          	shl    $0x2,%r8d
  ff6f47:	41 09 f0             	or     %esi,%r8d
  ff6f4a:	41 21 d0             	and    %edx,%r8d
  ff6f4d:	44 09 c0             	or     %r8d,%eax
  ff6f50:	48 8b 94 24 88 00 00 00 	mov    0x88(%rsp),%rdx
  ff6f58:	48 8b b4 24 a8 00 00 00 	mov    0xa8(%rsp),%rsi
  ff6f60:	88 0c 1a             	mov    %cl,(%rdx,%rbx,1)
  ff6f63:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
  ff6f68:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  ff6f6c:	42 0f b6 0c 29       	movzbl (%rcx,%r13,1),%ecx
  ff6f71:	88 0c 1e             	mov    %cl,(%rsi,%rbx,1)
  ff6f74:	48 8b b4 24 c0 00 00 00 	mov    0xc0(%rsp),%rsi
  ff6f7c:	48 8b 4a 10          	mov    0x10(%rdx),%rcx
  ff6f80:	42 0f b6 0c 29       	movzbl (%rcx,%r13,1),%ecx
  ff6f85:	88 0c 1e             	mov    %cl,(%rsi,%rbx,1)
  ff6f88:	48 8b 74 24 78       	mov    0x78(%rsp),%rsi
  ff6f8d:	48 8b 4a 18          	mov    0x18(%rdx),%rcx
  ff6f91:	42 0f b6 0c 29       	movzbl (%rcx,%r13,1),%ecx
  ff6f96:	88 0c 1e             	mov    %cl,(%rsi,%rbx,1)
  ff6f99:	4a 8d 0c ad 00 00 00 00 	lea    0x0(,%r13,4),%rcx
  ff6fa1:	48 8b 52 20          	mov    0x20(%rdx),%rdx
  ff6fa5:	48 01 ca             	add    %rcx,%rdx
  ff6fa8:	a8 01                	test   $0x1,%al
  ff6faa:	74 0b                	je     ff6fb7 <ir_optimize_licm+0x2af7>
  ff6fac:	8b 12                	mov    (%rdx),%edx
  ff6fae:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  ff6fb3:	48 8d 14 96          	lea    (%rsi,%rdx,4),%rdx
  ff6fb7:	8b 12                	mov    (%rdx),%edx
  ff6fb9:	48 8b b4 24 b0 00 00 00 	mov    0xb0(%rsp),%rsi
  ff6fc1:	89 14 9e             	mov    %edx,(%rsi,%rbx,4)
  ff6fc4:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
  ff6fc9:	48 8b 52 28          	mov    0x28(%rdx),%rdx
  ff6fcd:	48 01 ca             	add    %rcx,%rdx
  ff6fd0:	a8 02                	test   $0x2,%al
  ff6fd2:	74 0b                	je     ff6fdf <ir_optimize_licm+0x2b1f>
  ff6fd4:	8b 12                	mov    (%rdx),%edx
  ff6fd6:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  ff6fdb:	48 8d 14 96          	lea    (%rsi,%rdx,4),%rdx
  ff6fdf:	8b 12                	mov    (%rdx),%edx
  ff6fe1:	48 8b 74 24 68       	mov    0x68(%rsp),%rsi
  ff6fe6:	89 14 9e             	mov    %edx,(%rsi,%rbx,4)
  ff6fe9:	48 8b 74 24 28       	mov    0x28(%rsp),%rsi
  ff6fee:	48 03 4e 30          	add    0x30(%rsi),%rcx
  ff6ff2:	a8 04                	test   $0x4,%al
  ff6ff4:	74 0b                	je     ff7001 <ir_optimize_licm+0x2b41>
  ff6ff6:	8b 01                	mov    (%rcx),%eax
  ff6ff8:	48 8b 54 24 50       	mov    0x50(%rsp),%rdx
  ff6ffd:	48 8d 0c 82          	lea    (%rdx,%rax,4),%rcx
  ff7001:	8b 01                	mov    (%rcx),%eax
  ff7003:	48 8b 94 24 a0 00 00 00 	mov    0xa0(%rsp),%rdx
  ff700b:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  ff7010:	89 04 9a             	mov    %eax,(%rdx,%rbx,4)
  ff7013:	48 8b 01             	mov    (%rcx),%rax
  ff7016:	42 0f b6 04 28       	movzbl (%rax,%r13,1),%eax
  ff701b:	83 f8 38             	cmp    $0x38,%eax
  ff701e:	0f 84 a9 00 00 00    	je     ff70cd <ir_optimize_licm+0x2c0d>
  ff7024:	83 f8 32             	cmp    $0x32,%eax
  ff7027:	0f 84 48 fe ff ff    	je     ff6e75 <ir_optimize_licm+0x29b5>
  ff702d:	83 f8 2f             	cmp    $0x2f,%eax
  ff7030:	0f 85 f3 00 00 00    	jne    ff7129 <ir_optimize_licm+0x2c69>
  ff7036:	48 8b 84 24 b0 00 00 00 	mov    0xb0(%rsp),%rax
  ff703e:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  ff7043:	44 89 24 98          	mov    %r12d,(%rax,%rbx,4)
  ff7047:	48 8b 41 28          	mov    0x28(%rcx),%rax
  ff704b:	42 83 3c a8 00       	cmpl   $0x0,(%rax,%r13,4)
  ff7050:	0f 84 6c fe ff ff    	je     ff6ec2 <ir_optimize_licm+0x2a02>
  ff7056:	48 8b 74 24 28       	mov    0x28(%rsp),%rsi
  ff705b:	4c 8b 44 24 50       	mov    0x50(%rsp),%r8
  ff7060:	4c 8b 4c 24 48       	mov    0x48(%rsp),%r9
  ff7065:	31 c0                	xor    %eax,%eax
  ff7067:	31 c9                	xor    %ecx,%ecx
  ff7069:	48 8b 76 20          	mov    0x20(%rsi),%rsi
  ff706d:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  ff7072:	41 8d 14 04          	lea    (%r12,%rax,1),%edx
  ff7076:	ff c1                	inc    %ecx
  ff7078:	42 8b 34 ae          	mov    (%rsi,%r13,4),%esi
  ff707c:	48 8b 7f 50          	mov    0x50(%rdi),%rdi
  ff7080:	01 c6                	add    %eax,%esi
  ff7082:	8b 34 b7             	mov    (%rdi,%rsi,4),%esi
  ff7085:	41 8d 7c 04 01       	lea    0x1(%r12,%rax,1),%edi
  ff708a:	41 89 34 91          	mov    %esi,(%r9,%rdx,4)
  ff708e:	48 8b 74 24 28       	mov    0x28(%rsp),%rsi
  ff7093:	48 8b 56 20          	mov    0x20(%rsi),%rdx
  ff7097:	48 8b 74 24 28       	mov    0x28(%rsp),%rsi
  ff709c:	42 8b 14 aa          	mov    (%rdx,%r13,4),%edx
  ff70a0:	48 8b 76 50          	mov    0x50(%rsi),%rsi
  ff70a4:	8d 54 10 01          	lea    0x1(%rax,%rdx,1),%edx
  ff70a8:	83 c0 02             	add    $0x2,%eax
  ff70ab:	8b 14 96             	mov    (%rsi,%rdx,4),%edx
  ff70ae:	48 8b 74 24 28       	mov    0x28(%rsp),%rsi
  ff70b3:	41 8b 14 90          	mov    (%r8,%rdx,4),%edx
  ff70b7:	41 89 14 b9          	mov    %edx,(%r9,%rdi,4)
  ff70bb:	48 8b 56 28          	mov    0x28(%rsi),%rdx
  ff70bf:	42 3b 0c aa          	cmp    (%rdx,%r13,4),%ecx
  ff70c3:	72 a4                	jb     ff7069 <ir_optimize_licm+0x2ba9>
  ff70c5:	41 01 c4             	add    %eax,%r12d
  ff70c8:	e9 f5 fd ff ff       	jmp    ff6ec2 <ir_optimize_licm+0x2a02>
  ff70cd:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  ff70d2:	48 8b 40 28          	mov    0x28(%rax),%rax
  ff70d6:	42 83 3c a8 ff       	cmpl   $0xffffffff,(%rax,%r13,4)
  ff70db:	0f 84 e1 fd ff ff    	je     ff6ec2 <ir_optimize_licm+0x2a02>
  ff70e1:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  ff70e6:	48 8b 4c 24 48       	mov    0x48(%rsp),%rcx
  ff70eb:	4c 8b 7c 24 28       	mov    0x28(%rsp),%r15
  ff70f0:	44 89 24 98          	mov    %r12d,(%rax,%rbx,4)
  ff70f4:	44 89 e0             	mov    %r12d,%eax
  ff70f7:	48 8d 3c 81          	lea    (%rcx,%rax,4),%rdi
  ff70fb:	49 8b 47 28          	mov    0x28(%r15),%rax
  ff70ff:	49 8b 4f 30          	mov    0x30(%r15),%rcx
  ff7103:	42 8b 34 a8          	mov    (%rax,%r13,4),%esi
  ff7107:	42 8b 14 a9          	mov    (%rcx,%r13,4),%edx
  ff710b:	48 c1 e6 02          	shl    $0x2,%rsi
  ff710f:	49 03 77 50          	add    0x50(%r15),%rsi
  ff7113:	48 c1 e2 02          	shl    $0x2,%rdx
  ff7117:	e8 f4 2b 90 ff       	call   8f9d10 <memcpy@plt>
  ff711c:	49 8b 47 30          	mov    0x30(%r15),%rax
  ff7120:	46 03 24 a8          	add    (%rax,%r13,4),%r12d
  ff7124:	e9 99 fd ff ff       	jmp    ff6ec2 <ir_optimize_licm+0x2a02>
  ff7129:	04 d3                	add    $0xd3,%al
  ff712b:	3c 01                	cmp    $0x1,%al
  ff712d:	0f 87 8f fd ff ff    	ja     ff6ec2 <ir_optimize_licm+0x2a02>
  ff7133:	8b 54 24 60          	mov    0x60(%rsp),%edx
  ff7137:	48 8b 4c 24 68       	mov    0x68(%rsp),%rcx
  ff713c:	48 8b 74 24 28       	mov    0x28(%rsp),%rsi
  ff7141:	89 14 99             	mov    %edx,(%rcx,%rbx,4)
  ff7144:	89 d0                	mov    %edx,%eax
  ff7146:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  ff714a:	48 8b 4e 28          	mov    0x28(%rsi),%rcx
  ff714e:	48 8b 96 90 00 00 00 	mov    0x90(%rsi),%rdx
  ff7155:	48 8b b4 24 90 00 00 00 	mov    0x90(%rsp),%rsi
  ff715d:	42 8b 0c a9          	mov    (%rcx,%r13,4),%ecx
  ff7161:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
  ff7165:	c5 fa 6f 04 ca       	vmovdqu (%rdx,%rcx,8),%xmm0
  ff716a:	c5 fa 7f 04 c6       	vmovdqu %xmm0,(%rsi,%rax,8)
  ff716f:	48 8b 4c ca 10       	mov    0x10(%rdx,%rcx,8),%rcx
  ff7174:	44 89 24 c6          	mov    %r12d,(%rsi,%rax,8)
  ff7178:	48 89 4c c6 10       	mov    %rcx,0x10(%rsi,%rax,8)
  ff717d:	83 7c c6 04 00       	cmpl   $0x0,0x4(%rsi,%rax,8)
  ff7182:	74 53                	je     ff71d7 <ir_optimize_licm+0x2d17>
  ff7184:	48 8b 8c 24 90 00 00 00 	mov    0x90(%rsp),%rcx
  ff718c:	4c 8b 4c 24 28       	mov    0x28(%rsp),%r9
  ff7191:	4c 8b 54 24 50       	mov    0x50(%rsp),%r10
  ff7196:	4c 8b 5c 24 48       	mov    0x48(%rsp),%r11
  ff719b:	48 8d 0c c1          	lea    (%rcx,%rax,8),%rcx
  ff719f:	31 c0                	xor    %eax,%eax
  ff71a1:	49 8b 71 28          	mov    0x28(%r9),%rsi
  ff71a5:	4d 8b 81 90 00 00 00 	mov    0x90(%r9),%r8
  ff71ac:	49 8b 79 50          	mov    0x50(%r9),%rdi
  ff71b0:	41 8d 14 04          	lea    (%r12,%rax,1),%edx
  ff71b4:	42 8b 34 ae          	mov    (%rsi,%r13,4),%esi
  ff71b8:	48 8d 34 76          	lea    (%rsi,%rsi,2),%rsi
  ff71bc:	41 8b 34 f0          	mov    (%r8,%rsi,8),%esi
  ff71c0:	01 c6                	add    %eax,%esi
  ff71c2:	ff c0                	inc    %eax
  ff71c4:	8b 34 b7             	mov    (%rdi,%rsi,4),%esi
  ff71c7:	41 8b 34 b2          	mov    (%r10,%rsi,4),%esi
  ff71cb:	41 89 34 93          	mov    %esi,(%r11,%rdx,4)
  ff71cf:	3b 41 04             	cmp    0x4(%rcx),%eax
  ff71d2:	72 cd                	jb     ff71a1 <ir_optimize_licm+0x2ce1>
  ff71d4:	41 01 c4             	add    %eax,%r12d
  ff71d7:	ff 44 24 60          	incl   0x60(%rsp)
  ff71db:	e9 e2 fc ff ff       	jmp    ff6ec2 <ir_optimize_licm+0x2a02>
  ff71e0:	4d 89 e3             	mov    %r12,%r11
  ff71e3:	45 31 f6             	xor    %r14d,%r14d
  ff71e6:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  ff71eb:	4c 8b 54 24 30       	mov    0x30(%rsp),%r10
  ff71f0:	4c 8b 44 24 40       	mov    0x40(%rsp),%r8
  ff71f5:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  ff71fa:	45 31 c9             	xor    %r9d,%r9d
  ff71fd:	e9 0b dc ff ff       	jmp    ff4e0d <ir_optimize_licm+0x94d>
  ff7202:	48 c7 84 24 90 00 00 00 00 00 00 00 	movq   $0x0,0x90(%rsp)
  ff720e:	e9 fa f2 ff ff       	jmp    ff650d <ir_optimize_licm+0x204d>
  ff7213:	48 2b 9c 24 e8 00 00 00 	sub    0xe8(%rsp),%rbx
  ff721b:	48 8b 8c 24 f0 00 00 00 	mov    0xf0(%rsp),%rcx
  ff7223:	49 89 d0             	mov    %rdx,%r8
  ff7226:	48 89 9c 24 b0 07 00 00 	mov    %rbx,0x7b0(%rsp)
  ff722e:	48 8b 5c 24 20       	mov    0x20(%rsp),%rbx
  ff7233:	62 d1 7c 48 10 87 20 01 00 00 	vmovups 0x120(%r15),%zmm0
  ff723d:	62 f1 7c 48 11 81 20 01 00 00 	vmovups %zmm0,0x120(%rcx)
  ff7247:	62 d1 7c 48 10 47 04 	vmovups 0x100(%r15),%zmm0
  ff724e:	62 f1 7c 48 11 41 04 	vmovups %zmm0,0x100(%rcx)
  ff7255:	62 d1 fe 48 6f 07    	vmovdqu64 (%r15),%zmm0
  ff725b:	62 d1 fe 48 6f 4f 01 	vmovdqu64 0x40(%r15),%zmm1
  ff7262:	62 d1 fe 48 6f 57 02 	vmovdqu64 0x80(%r15),%zmm2
  ff7269:	62 d1 fe 48 6f 5f 03 	vmovdqu64 0xc0(%r15),%zmm3
  ff7270:	62 f1 fe 48 7f 59 03 	vmovdqu64 %zmm3,0xc0(%rcx)
  ff7277:	62 f1 fe 48 7f 51 02 	vmovdqu64 %zmm2,0x80(%rcx)
  ff727e:	62 f1 fe 48 7f 49 01 	vmovdqu64 %zmm1,0x40(%rcx)
  ff7285:	62 f1 fe 48 7f 01    	vmovdqu64 %zmm0,(%rcx)
  ff728b:	31 c9                	xor    %ecx,%ecx
  ff728d:	48 8b b4 24 e8 00 00 00 	mov    0xe8(%rsp),%rsi
  ff7295:	48 3b 73 08          	cmp    0x8(%rbx),%rsi
  ff7299:	0f 86 e9 d7 ff ff    	jbe    ff4a88 <ir_optimize_licm+0x5c8>
  ff729f:	48 8d 3d 9f 42 83 ff 	lea    -0x7cbd61(%rip),%rdi        # 82b545 <pp_string_value.meaning+0xb84ed>
  ff72a6:	48 8d 35 cd 2e 7c ff 	lea    -0x83d133(%rip),%rsi        # 7ba17a <pp_string_value.meaning+0x47122>
  ff72ad:	48 8d 0d e1 2e 7c ff 	lea    -0x83d11f(%rip),%rcx        # 7ba195 <pp_string_value.meaning+0x4713d>
  ff72b4:	ba 5b 01 00 00       	mov    $0x15b,%edx
  ff72b9:	c5 f8 77             	vzeroupper
  ff72bc:	e8 5f 20 90 ff       	call   8f9320 <__assert_fail@plt>
