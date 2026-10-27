
/home/david/buster-fast-bench/codex-180-fix-20261026-main/build/compiler:     file format elf64-x86-64


Disassembly of section .text:

00000000018e7370 <tier0_tables_open>:
 18e7370:	55                   	push   %rbp
 18e7371:	41 57                	push   %r15
 18e7373:	41 56                	push   %r14
 18e7375:	41 55                	push   %r13
 18e7377:	41 54                	push   %r12
 18e7379:	53                   	push   %rbx
 18e737a:	48 81 ec c8 02 00 00 	sub    $0x2c8,%rsp
 18e7381:	64 48 8b 04 25 28 00 00 00 	mov    %fs:0x28,%rax
 18e738a:	be 00 a0 00 00       	mov    $0xa000,%esi
 18e738f:	ba 03 00 00 00       	mov    $0x3,%edx
 18e7394:	b9 22 40 00 00       	mov    $0x4022,%ecx
 18e7399:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
 18e739f:	48 89 fb             	mov    %rdi,%rbx
 18e73a2:	45 31 f6             	xor    %r14d,%r14d
 18e73a5:	31 ff                	xor    %edi,%edi
 18e73a7:	45 31 c9             	xor    %r9d,%r9d
 18e73aa:	48 89 84 24 c0 02 00 00 	mov    %rax,0x2c0(%rsp)
 18e73b2:	e8 d9 2c eb fe       	call   79a090 <mmap@plt>
 18e73b7:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
 18e73bb:	74 1c                	je     18e73d9 <tier0_tables_open+0x69>
 18e73bd:	be 00 a0 00 00       	mov    $0xa000,%esi
 18e73c2:	ba 0f 00 00 00       	mov    $0xf,%edx
 18e73c7:	48 89 c7             	mov    %rax,%rdi
 18e73ca:	49 89 c6             	mov    %rax,%r14
 18e73cd:	e8 6e 2c eb fe       	call   79a040 <madvise@plt>
 18e73d2:	b8 99 9e 00 00       	mov    $0x9e99,%eax
 18e73d7:	eb 02                	jmp    18e73db <tier0_tables_open+0x6b>
 18e73d9:	31 c0                	xor    %eax,%eax
 18e73db:	be 00 90 00 00       	mov    $0x9000,%esi
 18e73e0:	ba 03 00 00 00       	mov    $0x3,%edx
 18e73e5:	b9 22 40 00 00       	mov    $0x4022,%ecx
 18e73ea:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
 18e73f0:	4c 89 b3 20 01 00 00 	mov    %r14,0x120(%rbx)
 18e73f7:	48 c7 83 28 01 00 00 00 00 00 00 	movq   $0x0,0x128(%rbx)
 18e7402:	48 89 83 30 01 00 00 	mov    %rax,0x130(%rbx)
 18e7409:	48 c7 83 38 01 00 00 00 00 00 00 	movq   $0x0,0x138(%rbx)
 18e7414:	45 31 ff             	xor    %r15d,%r15d
 18e7417:	31 ff                	xor    %edi,%edi
 18e7419:	45 31 c9             	xor    %r9d,%r9d
 18e741c:	e8 6f 2c eb fe       	call   79a090 <mmap@plt>
 18e7421:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
 18e7425:	74 1d                	je     18e7444 <tier0_tables_open+0xd4>
 18e7427:	be 00 90 00 00       	mov    $0x9000,%esi
 18e742c:	ba 0f 00 00 00       	mov    $0xf,%edx
 18e7431:	48 89 c7             	mov    %rax,%rdi
 18e7434:	49 89 c6             	mov    %rax,%r14
 18e7437:	e8 04 2c eb fe       	call   79a040 <madvise@plt>
 18e743c:	41 bf 40 80 00 00    	mov    $0x8040,%r15d
 18e7442:	eb 03                	jmp    18e7447 <tier0_tables_open+0xd7>
 18e7444:	45 31 f6             	xor    %r14d,%r14d
 18e7447:	4c 89 b3 40 01 00 00 	mov    %r14,0x140(%rbx)
 18e744e:	48 c7 83 48 01 00 00 00 00 00 00 	movq   $0x0,0x148(%rbx)
 18e7459:	4c 89 bb 50 01 00 00 	mov    %r15,0x150(%rbx)
 18e7460:	48 c7 83 58 01 00 00 00 00 00 00 	movq   $0x0,0x158(%rbx)
 18e746b:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 18e746f:	48 8b 83 28 01 00 00 	mov    0x128(%rbx),%rax
 18e7476:	c5 fa 7f 84 24 bc 01 00 00 	vmovdqu %xmm0,0x1bc(%rsp)
 18e747f:	c5 f9 7f 84 24 b0 01 00 00 	vmovdqa %xmm0,0x1b0(%rsp)
 18e7488:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18e748f:	4c 8d 74 10 3f       	lea    0x3f(%rax,%rdx,1),%r14
 18e7494:	48 8d 0c 10          	lea    (%rax,%rdx,1),%rcx
 18e7498:	49 83 e6 c0          	and    $0xffffffffffffffc0,%r14
 18e749c:	49 39 ce             	cmp    %rcx,%r14
 18e749f:	0f 82 6c 10 00 00    	jb     18e8511 <tier0_tables_open+0x11a1>
 18e74a5:	4c 89 f1             	mov    %r14,%rcx
 18e74a8:	48 29 d1             	sub    %rdx,%rcx
 18e74ab:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18e74b2:	48 29 ca             	sub    %rcx,%rdx
 18e74b5:	40 0f 92 c6          	setb   %sil
 18e74b9:	48 81 fa 40 02 00 00 	cmp    $0x240,%rdx
 18e74c0:	0f 92 c2             	setb   %dl
 18e74c3:	40 08 f2             	or     %sil,%dl
 18e74c6:	0f 85 45 10 00 00    	jne    18e8511 <tier0_tables_open+0x11a1>
 18e74cc:	48 81 c1 40 02 00 00 	add    $0x240,%rcx
 18e74d3:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18e74da:	4d 85 f6             	test   %r14,%r14
 18e74dd:	0f 84 2e 10 00 00    	je     18e8511 <tier0_tables_open+0x11a1>
 18e74e3:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 18e74e7:	62 d1 fd 48 7f 06    	vmovdqa64 %zmm0,(%r14)
 18e74ed:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18e74f4:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18e74fb:	4c 8d 4c 11 3f       	lea    0x3f(%rcx,%rdx,1),%r9
 18e7500:	48 01 d1             	add    %rdx,%rcx
 18e7503:	49 83 e1 c0          	and    $0xffffffffffffffc0,%r9
 18e7507:	49 39 c9             	cmp    %rcx,%r9
 18e750a:	0f 82 01 10 00 00    	jb     18e8511 <tier0_tables_open+0x11a1>
 18e7510:	4c 89 c9             	mov    %r9,%rcx
 18e7513:	48 29 d1             	sub    %rdx,%rcx
 18e7516:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18e751d:	48 29 ca             	sub    %rcx,%rdx
 18e7520:	40 0f 92 c6          	setb   %sil
 18e7524:	48 81 fa 40 02 00 00 	cmp    $0x240,%rdx
 18e752b:	0f 92 c2             	setb   %dl
 18e752e:	40 08 f2             	or     %sil,%dl
 18e7531:	0f 85 da 0f 00 00    	jne    18e8511 <tier0_tables_open+0x11a1>
 18e7537:	48 81 c1 40 02 00 00 	add    $0x240,%rcx
 18e753e:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18e7545:	4d 85 c9             	test   %r9,%r9
 18e7548:	0f 84 c3 0f 00 00    	je     18e8511 <tier0_tables_open+0x11a1>
 18e754e:	62 d1 fd 48 7f 01    	vmovdqa64 %zmm0,(%r9)
 18e7554:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18e755b:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18e7562:	4c 8d 54 11 3f       	lea    0x3f(%rcx,%rdx,1),%r10
 18e7567:	48 01 d1             	add    %rdx,%rcx
 18e756a:	49 83 e2 c0          	and    $0xffffffffffffffc0,%r10
 18e756e:	49 39 ca             	cmp    %rcx,%r10
 18e7571:	0f 82 9a 0f 00 00    	jb     18e8511 <tier0_tables_open+0x11a1>
 18e7577:	4c 89 d1             	mov    %r10,%rcx
 18e757a:	48 29 d1             	sub    %rdx,%rcx
 18e757d:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18e7584:	48 29 ca             	sub    %rcx,%rdx
 18e7587:	40 0f 92 c6          	setb   %sil
 18e758b:	48 81 fa 40 02 00 00 	cmp    $0x240,%rdx
 18e7592:	0f 92 c2             	setb   %dl
 18e7595:	40 08 f2             	or     %sil,%dl
 18e7598:	0f 85 73 0f 00 00    	jne    18e8511 <tier0_tables_open+0x11a1>
 18e759e:	48 81 c1 40 02 00 00 	add    $0x240,%rcx
 18e75a5:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18e75ac:	4d 85 d2             	test   %r10,%r10
 18e75af:	0f 84 5c 0f 00 00    	je     18e8511 <tier0_tables_open+0x11a1>
 18e75b5:	62 d1 fd 48 7f 02    	vmovdqa64 %zmm0,(%r10)
 18e75bb:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18e75c2:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18e75c9:	4c 8d 5c 11 3f       	lea    0x3f(%rcx,%rdx,1),%r11
 18e75ce:	48 01 d1             	add    %rdx,%rcx
 18e75d1:	49 83 e3 c0          	and    $0xffffffffffffffc0,%r11
 18e75d5:	49 39 cb             	cmp    %rcx,%r11
 18e75d8:	0f 82 33 0f 00 00    	jb     18e8511 <tier0_tables_open+0x11a1>
 18e75de:	4c 89 d9             	mov    %r11,%rcx
 18e75e1:	48 29 d1             	sub    %rdx,%rcx
 18e75e4:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18e75eb:	48 29 ca             	sub    %rcx,%rdx
 18e75ee:	40 0f 92 c6          	setb   %sil
 18e75f2:	48 81 fa 40 02 00 00 	cmp    $0x240,%rdx
 18e75f9:	0f 92 c2             	setb   %dl
 18e75fc:	40 08 f2             	or     %sil,%dl
 18e75ff:	0f 85 0c 0f 00 00    	jne    18e8511 <tier0_tables_open+0x11a1>
 18e7605:	48 81 c1 40 02 00 00 	add    $0x240,%rcx
 18e760c:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18e7613:	4d 85 db             	test   %r11,%r11
 18e7616:	0f 84 f5 0e 00 00    	je     18e8511 <tier0_tables_open+0x11a1>
 18e761c:	62 d1 fd 48 7f 03    	vmovdqa64 %zmm0,(%r11)
 18e7622:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18e7629:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18e7630:	4c 8d 7c 11 3f       	lea    0x3f(%rcx,%rdx,1),%r15
 18e7635:	48 01 d1             	add    %rdx,%rcx
 18e7638:	49 83 e7 c0          	and    $0xffffffffffffffc0,%r15
 18e763c:	49 39 cf             	cmp    %rcx,%r15
 18e763f:	0f 82 cc 0e 00 00    	jb     18e8511 <tier0_tables_open+0x11a1>
 18e7645:	4c 89 f9             	mov    %r15,%rcx
 18e7648:	48 29 d1             	sub    %rdx,%rcx
 18e764b:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18e7652:	48 29 ca             	sub    %rcx,%rdx
 18e7655:	40 0f 92 c6          	setb   %sil
 18e7659:	48 81 fa 00 09 00 00 	cmp    $0x900,%rdx
 18e7660:	0f 92 c2             	setb   %dl
 18e7663:	40 08 f2             	or     %sil,%dl
 18e7666:	0f 85 a5 0e 00 00    	jne    18e8511 <tier0_tables_open+0x11a1>
 18e766c:	48 81 c1 00 09 00 00 	add    $0x900,%rcx
 18e7673:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18e767a:	4d 85 ff             	test   %r15,%r15
 18e767d:	0f 84 8e 0e 00 00    	je     18e8511 <tier0_tables_open+0x11a1>
 18e7683:	62 d1 fd 48 7f 47 03 	vmovdqa64 %zmm0,0xc0(%r15)
 18e768a:	62 d1 fd 48 7f 47 02 	vmovdqa64 %zmm0,0x80(%r15)
 18e7691:	62 d1 fd 48 7f 47 01 	vmovdqa64 %zmm0,0x40(%r15)
 18e7698:	62 d1 fd 48 7f 07    	vmovdqa64 %zmm0,(%r15)
 18e769e:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18e76a5:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18e76ac:	4c 8d 6c 11 3f       	lea    0x3f(%rcx,%rdx,1),%r13
 18e76b1:	48 01 d1             	add    %rdx,%rcx
 18e76b4:	49 83 e5 c0          	and    $0xffffffffffffffc0,%r13
 18e76b8:	49 39 cd             	cmp    %rcx,%r13
 18e76bb:	0f 82 50 0e 00 00    	jb     18e8511 <tier0_tables_open+0x11a1>
 18e76c1:	4c 89 e9             	mov    %r13,%rcx
 18e76c4:	48 29 d1             	sub    %rdx,%rcx
 18e76c7:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18e76ce:	48 29 ca             	sub    %rcx,%rdx
 18e76d1:	40 0f 92 c6          	setb   %sil
 18e76d5:	48 81 fa 00 09 00 00 	cmp    $0x900,%rdx
 18e76dc:	0f 92 c2             	setb   %dl
 18e76df:	40 08 f2             	or     %sil,%dl
 18e76e2:	0f 85 29 0e 00 00    	jne    18e8511 <tier0_tables_open+0x11a1>
 18e76e8:	48 81 c1 00 09 00 00 	add    $0x900,%rcx
 18e76ef:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18e76f6:	4d 85 ed             	test   %r13,%r13
 18e76f9:	0f 84 12 0e 00 00    	je     18e8511 <tier0_tables_open+0x11a1>
 18e76ff:	62 d1 fd 48 7f 45 03 	vmovdqa64 %zmm0,0xc0(%r13)
 18e7706:	62 d1 fd 48 7f 45 02 	vmovdqa64 %zmm0,0x80(%r13)
 18e770d:	62 d1 fd 48 7f 45 01 	vmovdqa64 %zmm0,0x40(%r13)
 18e7714:	62 d1 fd 48 7f 45 00 	vmovdqa64 %zmm0,0x0(%r13)
 18e771b:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18e7722:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18e7729:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 18e772e:	48 01 d1             	add    %rdx,%rcx
 18e7731:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 18e7735:	48 89 74 24 10       	mov    %rsi,0x10(%rsp)
 18e773a:	48 39 ce             	cmp    %rcx,%rsi
 18e773d:	0f 82 ce 0d 00 00    	jb     18e8511 <tier0_tables_open+0x11a1>
 18e7743:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
 18e7748:	48 29 d1             	sub    %rdx,%rcx
 18e774b:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18e7752:	48 29 ca             	sub    %rcx,%rdx
 18e7755:	40 0f 92 c6          	setb   %sil
 18e7759:	48 81 fa 00 12 00 00 	cmp    $0x1200,%rdx
 18e7760:	0f 92 c2             	setb   %dl
 18e7763:	40 08 f2             	or     %sil,%dl
 18e7766:	0f 85 a5 0d 00 00    	jne    18e8511 <tier0_tables_open+0x11a1>
 18e776c:	48 81 c1 00 12 00 00 	add    $0x1200,%rcx
 18e7773:	48 83 7c 24 10 00    	cmpq   $0x0,0x10(%rsp)
 18e7779:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18e7780:	0f 84 8b 0d 00 00    	je     18e8511 <tier0_tables_open+0x11a1>
 18e7786:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
 18e778b:	62 f1 fd 48 7f 41 07 	vmovdqa64 %zmm0,0x1c0(%rcx)
 18e7792:	62 f1 fd 48 7f 41 06 	vmovdqa64 %zmm0,0x180(%rcx)
 18e7799:	62 f1 fd 48 7f 41 05 	vmovdqa64 %zmm0,0x140(%rcx)
 18e77a0:	62 f1 fd 48 7f 41 04 	vmovdqa64 %zmm0,0x100(%rcx)
 18e77a7:	62 f1 fd 48 7f 41 03 	vmovdqa64 %zmm0,0xc0(%rcx)
 18e77ae:	62 f1 fd 48 7f 41 02 	vmovdqa64 %zmm0,0x80(%rcx)
 18e77b5:	62 f1 fd 48 7f 41 01 	vmovdqa64 %zmm0,0x40(%rcx)
 18e77bc:	62 f1 fd 48 7f 01    	vmovdqa64 %zmm0,(%rcx)
 18e77c2:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18e77c9:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18e77d0:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 18e77d5:	48 01 d1             	add    %rdx,%rcx
 18e77d8:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 18e77dc:	48 89 74 24 08       	mov    %rsi,0x8(%rsp)
 18e77e1:	48 39 ce             	cmp    %rcx,%rsi
 18e77e4:	0f 82 27 0d 00 00    	jb     18e8511 <tier0_tables_open+0x11a1>
 18e77ea:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
 18e77ef:	48 29 d1             	sub    %rdx,%rcx
 18e77f2:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18e77f9:	48 29 ca             	sub    %rcx,%rdx
 18e77fc:	40 0f 92 c6          	setb   %sil
 18e7800:	48 81 fa 00 12 00 00 	cmp    $0x1200,%rdx
 18e7807:	0f 92 c2             	setb   %dl
 18e780a:	40 08 f2             	or     %sil,%dl
 18e780d:	0f 85 fe 0c 00 00    	jne    18e8511 <tier0_tables_open+0x11a1>
 18e7813:	48 81 c1 00 12 00 00 	add    $0x1200,%rcx
 18e781a:	48 83 7c 24 08 00    	cmpq   $0x0,0x8(%rsp)
 18e7820:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18e7827:	0f 84 e4 0c 00 00    	je     18e8511 <tier0_tables_open+0x11a1>
 18e782d:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
 18e7832:	62 f1 fd 48 7f 41 07 	vmovdqa64 %zmm0,0x1c0(%rcx)
 18e7839:	62 f1 fd 48 7f 41 06 	vmovdqa64 %zmm0,0x180(%rcx)
 18e7840:	62 f1 fd 48 7f 41 05 	vmovdqa64 %zmm0,0x140(%rcx)
 18e7847:	62 f1 fd 48 7f 41 04 	vmovdqa64 %zmm0,0x100(%rcx)
 18e784e:	62 f1 fd 48 7f 41 03 	vmovdqa64 %zmm0,0xc0(%rcx)
 18e7855:	62 f1 fd 48 7f 41 02 	vmovdqa64 %zmm0,0x80(%rcx)
 18e785c:	62 f1 fd 48 7f 41 01 	vmovdqa64 %zmm0,0x40(%rcx)
 18e7863:	62 f1 fd 48 7f 01    	vmovdqa64 %zmm0,(%rcx)
 18e7869:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18e7870:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18e7877:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 18e787c:	48 01 d1             	add    %rdx,%rcx
 18e787f:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 18e7883:	48 89 b4 24 80 00 00 00 	mov    %rsi,0x80(%rsp)
 18e788b:	48 39 ce             	cmp    %rcx,%rsi
 18e788e:	0f 82 7d 0c 00 00    	jb     18e8511 <tier0_tables_open+0x11a1>
 18e7894:	48 8b 8c 24 80 00 00 00 	mov    0x80(%rsp),%rcx
 18e789c:	48 29 d1             	sub    %rdx,%rcx
 18e789f:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18e78a6:	48 29 ca             	sub    %rcx,%rdx
 18e78a9:	40 0f 92 c6          	setb   %sil
 18e78ad:	48 81 fa 00 12 00 00 	cmp    $0x1200,%rdx
 18e78b4:	0f 92 c2             	setb   %dl
 18e78b7:	40 08 f2             	or     %sil,%dl
 18e78ba:	0f 85 51 0c 00 00    	jne    18e8511 <tier0_tables_open+0x11a1>
 18e78c0:	48 81 c1 00 12 00 00 	add    $0x1200,%rcx
 18e78c7:	48 83 bc 24 80 00 00 00 00 	cmpq   $0x0,0x80(%rsp)
 18e78d0:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18e78d7:	0f 84 34 0c 00 00    	je     18e8511 <tier0_tables_open+0x11a1>
 18e78dd:	48 8b 8c 24 80 00 00 00 	mov    0x80(%rsp),%rcx
 18e78e5:	62 f1 fd 48 7f 41 07 	vmovdqa64 %zmm0,0x1c0(%rcx)
 18e78ec:	62 f1 fd 48 7f 41 06 	vmovdqa64 %zmm0,0x180(%rcx)
 18e78f3:	62 f1 fd 48 7f 41 05 	vmovdqa64 %zmm0,0x140(%rcx)
 18e78fa:	62 f1 fd 48 7f 41 04 	vmovdqa64 %zmm0,0x100(%rcx)
 18e7901:	62 f1 fd 48 7f 41 03 	vmovdqa64 %zmm0,0xc0(%rcx)
 18e7908:	62 f1 fd 48 7f 41 02 	vmovdqa64 %zmm0,0x80(%rcx)
 18e790f:	62 f1 fd 48 7f 41 01 	vmovdqa64 %zmm0,0x40(%rcx)
 18e7916:	62 f1 fd 48 7f 01    	vmovdqa64 %zmm0,(%rcx)
 18e791c:	48 8b 8b 20 01 00 00 	mov    0x120(%rbx),%rcx
 18e7923:	48 8b b3 28 01 00 00 	mov    0x128(%rbx),%rsi
 18e792a:	48 8d 54 0e 3f       	lea    0x3f(%rsi,%rcx,1),%rdx
 18e792f:	48 01 ce             	add    %rcx,%rsi
 18e7932:	48 83 e2 c0          	and    $0xffffffffffffffc0,%rdx
 18e7936:	48 89 54 24 40       	mov    %rdx,0x40(%rsp)
 18e793b:	48 39 f2             	cmp    %rsi,%rdx
 18e793e:	0f 82 cd 0b 00 00    	jb     18e8511 <tier0_tables_open+0x11a1>
 18e7944:	49 89 f4             	mov    %rsi,%r12
 18e7947:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
 18e794c:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18e7953:	48 29 ce             	sub    %rcx,%rsi
 18e7956:	48 89 d7             	mov    %rdx,%rdi
 18e7959:	48 29 f7             	sub    %rsi,%rdi
 18e795c:	41 0f 92 c0          	setb   %r8b
 18e7960:	48 81 ff 04 10 00 00 	cmp    $0x1004,%rdi
 18e7967:	40 0f 92 c7          	setb   %dil
 18e796b:	44 08 c7             	or     %r8b,%dil
 18e796e:	0f 85 9d 0b 00 00    	jne    18e8511 <tier0_tables_open+0x11a1>
 18e7974:	48 81 c6 04 10 00 00 	add    $0x1004,%rsi
 18e797b:	48 83 7c 24 40 00    	cmpq   $0x0,0x40(%rsp)
 18e7981:	48 89 b3 28 01 00 00 	mov    %rsi,0x128(%rbx)
 18e7988:	0f 84 83 0b 00 00    	je     18e8511 <tier0_tables_open+0x11a1>
 18e798e:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
 18e7993:	49 81 c4 7f 10 00 00 	add    $0x107f,%r12
 18e799a:	49 83 e4 c0          	and    $0xffffffffffffffc0,%r12
 18e799e:	4c 89 64 24 60       	mov    %r12,0x60(%rsp)
 18e79a3:	48 81 c6 04 10 00 00 	add    $0x1004,%rsi
 18e79aa:	49 39 f4             	cmp    %rsi,%r12
 18e79ad:	0f 82 5e 0b 00 00    	jb     18e8511 <tier0_tables_open+0x11a1>
 18e79b3:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
 18e79b8:	48 29 ce             	sub    %rcx,%rsi
 18e79bb:	48 29 f2             	sub    %rsi,%rdx
 18e79be:	0f 92 c1             	setb   %cl
 18e79c1:	48 81 fa 04 02 00 00 	cmp    $0x204,%rdx
 18e79c8:	0f 92 c2             	setb   %dl
 18e79cb:	08 ca                	or     %cl,%dl
 18e79cd:	0f 85 3e 0b 00 00    	jne    18e8511 <tier0_tables_open+0x11a1>
 18e79d3:	48 81 c6 04 02 00 00 	add    $0x204,%rsi
 18e79da:	48 83 7c 24 60 00    	cmpq   $0x0,0x60(%rsp)
 18e79e0:	48 89 b3 28 01 00 00 	mov    %rsi,0x128(%rbx)
 18e79e7:	0f 84 24 0b 00 00    	je     18e8511 <tier0_tables_open+0x11a1>
 18e79ed:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
 18e79f2:	c7 01 00 00 00 00    	movl   $0x0,(%rcx)
 18e79f8:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18e79ff:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18e7a06:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 18e7a0b:	48 01 d1             	add    %rdx,%rcx
 18e7a0e:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 18e7a12:	48 89 74 24 58       	mov    %rsi,0x58(%rsp)
 18e7a17:	48 39 ce             	cmp    %rcx,%rsi
 18e7a1a:	0f 82 f1 0a 00 00    	jb     18e8511 <tier0_tables_open+0x11a1>
 18e7a20:	48 8b 4c 24 58       	mov    0x58(%rsp),%rcx
 18e7a25:	48 29 d1             	sub    %rdx,%rcx
 18e7a28:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18e7a2f:	48 29 ca             	sub    %rcx,%rdx
 18e7a32:	40 0f 92 c6          	setb   %sil
 18e7a36:	48 81 fa 04 02 00 00 	cmp    $0x204,%rdx
 18e7a3d:	0f 92 c2             	setb   %dl
 18e7a40:	40 08 f2             	or     %sil,%dl
 18e7a43:	0f 85 c8 0a 00 00    	jne    18e8511 <tier0_tables_open+0x11a1>
 18e7a49:	48 81 c1 04 02 00 00 	add    $0x204,%rcx
 18e7a50:	48 83 7c 24 58 00    	cmpq   $0x0,0x58(%rsp)
 18e7a56:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18e7a5d:	0f 84 ae 0a 00 00    	je     18e8511 <tier0_tables_open+0x11a1>
 18e7a63:	48 8b 4c 24 58       	mov    0x58(%rsp),%rcx
 18e7a68:	c7 01 00 00 00 00    	movl   $0x0,(%rcx)
 18e7a6e:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18e7a75:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18e7a7c:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 18e7a81:	48 01 d1             	add    %rdx,%rcx
 18e7a84:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 18e7a88:	48 89 b4 24 08 01 00 00 	mov    %rsi,0x108(%rsp)
 18e7a90:	48 39 ce             	cmp    %rcx,%rsi
 18e7a93:	0f 82 78 0a 00 00    	jb     18e8511 <tier0_tables_open+0x11a1>
 18e7a99:	48 8b 8c 24 08 01 00 00 	mov    0x108(%rsp),%rcx
 18e7aa1:	48 29 d1             	sub    %rdx,%rcx
 18e7aa4:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18e7aab:	48 29 ca             	sub    %rcx,%rdx
 18e7aae:	40 0f 92 c6          	setb   %sil
 18e7ab2:	48 81 fa 04 02 00 00 	cmp    $0x204,%rdx
 18e7ab9:	0f 92 c2             	setb   %dl
 18e7abc:	40 08 f2             	or     %sil,%dl
 18e7abf:	0f 85 4c 0a 00 00    	jne    18e8511 <tier0_tables_open+0x11a1>
 18e7ac5:	48 81 c1 04 02 00 00 	add    $0x204,%rcx
 18e7acc:	48 83 bc 24 08 01 00 00 00 	cmpq   $0x0,0x108(%rsp)
 18e7ad5:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18e7adc:	0f 84 2f 0a 00 00    	je     18e8511 <tier0_tables_open+0x11a1>
 18e7ae2:	48 8b 8c 24 08 01 00 00 	mov    0x108(%rsp),%rcx
 18e7aea:	c7 01 00 00 00 00    	movl   $0x0,(%rcx)
 18e7af0:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18e7af7:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18e7afe:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 18e7b03:	48 01 d1             	add    %rdx,%rcx
 18e7b06:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 18e7b0a:	48 89 74 24 50       	mov    %rsi,0x50(%rsp)
 18e7b0f:	48 39 ce             	cmp    %rcx,%rsi
 18e7b12:	0f 82 f9 09 00 00    	jb     18e8511 <tier0_tables_open+0x11a1>
 18e7b18:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
 18e7b1d:	48 29 d1             	sub    %rdx,%rcx
 18e7b20:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18e7b27:	48 29 ca             	sub    %rcx,%rdx
 18e7b2a:	40 0f 92 c6          	setb   %sil
 18e7b2e:	48 81 fa 04 02 00 00 	cmp    $0x204,%rdx
 18e7b35:	0f 92 c2             	setb   %dl
 18e7b38:	40 08 f2             	or     %sil,%dl
 18e7b3b:	0f 85 d0 09 00 00    	jne    18e8511 <tier0_tables_open+0x11a1>
 18e7b41:	48 81 c1 04 02 00 00 	add    $0x204,%rcx
 18e7b48:	48 83 7c 24 50 00    	cmpq   $0x0,0x50(%rsp)
 18e7b4e:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18e7b55:	0f 84 b6 09 00 00    	je     18e8511 <tier0_tables_open+0x11a1>
 18e7b5b:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
 18e7b60:	c7 01 00 00 00 00    	movl   $0x0,(%rcx)
 18e7b66:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18e7b6d:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18e7b74:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 18e7b79:	48 01 d1             	add    %rdx,%rcx
 18e7b7c:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 18e7b80:	48 89 b4 24 00 01 00 00 	mov    %rsi,0x100(%rsp)
 18e7b88:	48 39 ce             	cmp    %rcx,%rsi
 18e7b8b:	0f 82 80 09 00 00    	jb     18e8511 <tier0_tables_open+0x11a1>
 18e7b91:	48 8b 8c 24 00 01 00 00 	mov    0x100(%rsp),%rcx
 18e7b99:	48 29 d1             	sub    %rdx,%rcx
 18e7b9c:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18e7ba3:	48 29 ca             	sub    %rcx,%rdx
 18e7ba6:	40 0f 92 c6          	setb   %sil
 18e7baa:	48 81 fa 04 02 00 00 	cmp    $0x204,%rdx
 18e7bb1:	0f 92 c2             	setb   %dl
 18e7bb4:	40 08 f2             	or     %sil,%dl
 18e7bb7:	0f 85 54 09 00 00    	jne    18e8511 <tier0_tables_open+0x11a1>
 18e7bbd:	48 81 c1 04 02 00 00 	add    $0x204,%rcx
 18e7bc4:	48 83 bc 24 00 01 00 00 00 	cmpq   $0x0,0x100(%rsp)
 18e7bcd:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18e7bd4:	0f 84 37 09 00 00    	je     18e8511 <tier0_tables_open+0x11a1>
 18e7bda:	48 8b 8c 24 00 01 00 00 	mov    0x100(%rsp),%rcx
 18e7be2:	c7 01 00 00 00 00    	movl   $0x0,(%rcx)
 18e7be8:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18e7bef:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18e7bf6:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 18e7bfb:	48 01 d1             	add    %rdx,%rcx
 18e7bfe:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 18e7c02:	48 89 b4 24 a8 00 00 00 	mov    %rsi,0xa8(%rsp)
 18e7c0a:	48 39 ce             	cmp    %rcx,%rsi
 18e7c0d:	0f 82 fe 08 00 00    	jb     18e8511 <tier0_tables_open+0x11a1>
 18e7c13:	48 8b 8c 24 a8 00 00 00 	mov    0xa8(%rsp),%rcx
 18e7c1b:	48 29 d1             	sub    %rdx,%rcx
 18e7c1e:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18e7c25:	48 29 ca             	sub    %rcx,%rdx
 18e7c28:	40 0f 92 c6          	setb   %sil
 18e7c2c:	48 81 fa 81 00 00 00 	cmp    $0x81,%rdx
 18e7c33:	0f 92 c2             	setb   %dl
 18e7c36:	40 08 f2             	or     %sil,%dl
 18e7c39:	0f 85 d2 08 00 00    	jne    18e8511 <tier0_tables_open+0x11a1>
 18e7c3f:	48 81 c1 81 00 00 00 	add    $0x81,%rcx
 18e7c46:	48 83 bc 24 a8 00 00 00 00 	cmpq   $0x0,0xa8(%rsp)
 18e7c4f:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18e7c56:	0f 84 b5 08 00 00    	je     18e8511 <tier0_tables_open+0x11a1>
 18e7c5c:	48 8b 8c 24 a8 00 00 00 	mov    0xa8(%rsp),%rcx
 18e7c64:	c6 01 00             	movb   $0x0,(%rcx)
 18e7c67:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18e7c6e:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18e7c75:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 18e7c7a:	48 01 d1             	add    %rdx,%rcx
 18e7c7d:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 18e7c81:	48 89 74 24 18       	mov    %rsi,0x18(%rsp)
 18e7c86:	48 39 ce             	cmp    %rcx,%rsi
 18e7c89:	0f 82 82 08 00 00    	jb     18e8511 <tier0_tables_open+0x11a1>
 18e7c8f:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
 18e7c94:	48 29 d1             	sub    %rdx,%rcx
 18e7c97:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18e7c9e:	48 29 ca             	sub    %rcx,%rdx
 18e7ca1:	40 0f 92 c6          	setb   %sil
 18e7ca5:	48 81 fa 81 00 00 00 	cmp    $0x81,%rdx
 18e7cac:	0f 92 c2             	setb   %dl
 18e7caf:	40 08 f2             	or     %sil,%dl
 18e7cb2:	0f 85 59 08 00 00    	jne    18e8511 <tier0_tables_open+0x11a1>
 18e7cb8:	48 81 c1 81 00 00 00 	add    $0x81,%rcx
 18e7cbf:	48 83 7c 24 18 00    	cmpq   $0x0,0x18(%rsp)
 18e7cc5:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18e7ccc:	0f 84 3f 08 00 00    	je     18e8511 <tier0_tables_open+0x11a1>
 18e7cd2:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
 18e7cd7:	c6 01 00             	movb   $0x0,(%rcx)
 18e7cda:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18e7ce1:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18e7ce8:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 18e7ced:	48 01 d1             	add    %rdx,%rcx
 18e7cf0:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 18e7cf4:	48 89 b4 24 f8 00 00 00 	mov    %rsi,0xf8(%rsp)
 18e7cfc:	48 39 ce             	cmp    %rcx,%rsi
 18e7cff:	0f 82 0c 08 00 00    	jb     18e8511 <tier0_tables_open+0x11a1>
 18e7d05:	48 8b 8c 24 f8 00 00 00 	mov    0xf8(%rsp),%rcx
 18e7d0d:	48 29 d1             	sub    %rdx,%rcx
 18e7d10:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18e7d17:	48 29 ca             	sub    %rcx,%rdx
 18e7d1a:	40 0f 92 c6          	setb   %sil
 18e7d1e:	48 81 fa 81 00 00 00 	cmp    $0x81,%rdx
 18e7d25:	0f 92 c2             	setb   %dl
 18e7d28:	40 08 f2             	or     %sil,%dl
 18e7d2b:	0f 85 e0 07 00 00    	jne    18e8511 <tier0_tables_open+0x11a1>
 18e7d31:	48 81 c1 81 00 00 00 	add    $0x81,%rcx
 18e7d38:	48 83 bc 24 f8 00 00 00 00 	cmpq   $0x0,0xf8(%rsp)
 18e7d41:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18e7d48:	0f 84 c3 07 00 00    	je     18e8511 <tier0_tables_open+0x11a1>
 18e7d4e:	48 8b 8c 24 f8 00 00 00 	mov    0xf8(%rsp),%rcx
 18e7d56:	c6 01 00             	movb   $0x0,(%rcx)
 18e7d59:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18e7d60:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18e7d67:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 18e7d6c:	48 01 d1             	add    %rdx,%rcx
 18e7d6f:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 18e7d73:	48 89 b4 24 38 01 00 00 	mov    %rsi,0x138(%rsp)
 18e7d7b:	48 39 ce             	cmp    %rcx,%rsi
 18e7d7e:	0f 82 8d 07 00 00    	jb     18e8511 <tier0_tables_open+0x11a1>
 18e7d84:	48 8b 8c 24 38 01 00 00 	mov    0x138(%rsp),%rcx
 18e7d8c:	48 29 d1             	sub    %rdx,%rcx
 18e7d8f:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18e7d96:	48 29 ca             	sub    %rcx,%rdx
 18e7d99:	40 0f 92 c6          	setb   %sil
 18e7d9d:	48 81 fa 04 08 00 00 	cmp    $0x804,%rdx
 18e7da4:	0f 92 c2             	setb   %dl
 18e7da7:	40 08 f2             	or     %sil,%dl
 18e7daa:	0f 85 61 07 00 00    	jne    18e8511 <tier0_tables_open+0x11a1>
 18e7db0:	48 81 c1 04 08 00 00 	add    $0x804,%rcx
 18e7db7:	48 83 bc 24 38 01 00 00 00 	cmpq   $0x0,0x138(%rsp)
 18e7dc0:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18e7dc7:	0f 84 44 07 00 00    	je     18e8511 <tier0_tables_open+0x11a1>
 18e7dcd:	48 8b 8c 24 38 01 00 00 	mov    0x138(%rsp),%rcx
 18e7dd5:	c7 01 00 00 00 00    	movl   $0x0,(%rcx)
 18e7ddb:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18e7de2:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18e7de9:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 18e7dee:	48 01 d1             	add    %rdx,%rcx
 18e7df1:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 18e7df5:	48 89 b4 24 a0 00 00 00 	mov    %rsi,0xa0(%rsp)
 18e7dfd:	48 39 ce             	cmp    %rcx,%rsi
 18e7e00:	0f 82 0b 07 00 00    	jb     18e8511 <tier0_tables_open+0x11a1>
 18e7e06:	48 8b 8c 24 a0 00 00 00 	mov    0xa0(%rsp),%rcx
 18e7e0e:	48 29 d1             	sub    %rdx,%rcx
 18e7e11:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18e7e18:	48 29 ca             	sub    %rcx,%rdx
 18e7e1b:	40 0f 92 c6          	setb   %sil
 18e7e1f:	48 81 fa 04 08 00 00 	cmp    $0x804,%rdx
 18e7e26:	0f 92 c2             	setb   %dl
 18e7e29:	40 08 f2             	or     %sil,%dl
 18e7e2c:	0f 85 df 06 00 00    	jne    18e8511 <tier0_tables_open+0x11a1>
 18e7e32:	48 81 c1 04 08 00 00 	add    $0x804,%rcx
 18e7e39:	48 83 bc 24 a0 00 00 00 00 	cmpq   $0x0,0xa0(%rsp)
 18e7e42:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18e7e49:	0f 84 c2 06 00 00    	je     18e8511 <tier0_tables_open+0x11a1>
 18e7e4f:	48 8b 8c 24 a0 00 00 00 	mov    0xa0(%rsp),%rcx
 18e7e57:	c7 01 00 00 00 00    	movl   $0x0,(%rcx)
 18e7e5d:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18e7e64:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18e7e6b:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 18e7e70:	48 01 d1             	add    %rdx,%rcx
 18e7e73:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 18e7e77:	48 89 b4 24 30 01 00 00 	mov    %rsi,0x130(%rsp)
 18e7e7f:	48 39 ce             	cmp    %rcx,%rsi
 18e7e82:	0f 82 89 06 00 00    	jb     18e8511 <tier0_tables_open+0x11a1>
 18e7e88:	48 8b 8c 24 30 01 00 00 	mov    0x130(%rsp),%rcx
 18e7e90:	48 29 d1             	sub    %rdx,%rcx
 18e7e93:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18e7e9a:	48 29 ca             	sub    %rcx,%rdx
 18e7e9d:	40 0f 92 c6          	setb   %sil
 18e7ea1:	48 81 fa 04 08 00 00 	cmp    $0x804,%rdx
 18e7ea8:	0f 92 c2             	setb   %dl
 18e7eab:	40 08 f2             	or     %sil,%dl
 18e7eae:	0f 85 5d 06 00 00    	jne    18e8511 <tier0_tables_open+0x11a1>
 18e7eb4:	48 81 c1 04 08 00 00 	add    $0x804,%rcx
 18e7ebb:	48 83 bc 24 30 01 00 00 00 	cmpq   $0x0,0x130(%rsp)
 18e7ec4:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18e7ecb:	0f 84 40 06 00 00    	je     18e8511 <tier0_tables_open+0x11a1>
 18e7ed1:	48 8b 8c 24 30 01 00 00 	mov    0x130(%rsp),%rcx
 18e7ed9:	c7 01 00 00 00 00    	movl   $0x0,(%rcx)
 18e7edf:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18e7ee6:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18e7eed:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 18e7ef2:	48 01 d1             	add    %rdx,%rcx
 18e7ef5:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 18e7ef9:	48 89 74 24 38       	mov    %rsi,0x38(%rsp)
 18e7efe:	48 39 ce             	cmp    %rcx,%rsi
 18e7f01:	0f 82 0a 06 00 00    	jb     18e8511 <tier0_tables_open+0x11a1>
 18e7f07:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
 18e7f0c:	48 29 d1             	sub    %rdx,%rcx
 18e7f0f:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18e7f16:	48 29 ca             	sub    %rcx,%rdx
 18e7f19:	40 0f 92 c6          	setb   %sil
 18e7f1d:	48 81 fa 01 02 00 00 	cmp    $0x201,%rdx
 18e7f24:	0f 92 c2             	setb   %dl
 18e7f27:	40 08 f2             	or     %sil,%dl
 18e7f2a:	0f 85 e1 05 00 00    	jne    18e8511 <tier0_tables_open+0x11a1>
 18e7f30:	48 81 c1 01 02 00 00 	add    $0x201,%rcx
 18e7f37:	48 83 7c 24 38 00    	cmpq   $0x0,0x38(%rsp)
 18e7f3d:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18e7f44:	0f 84 c7 05 00 00    	je     18e8511 <tier0_tables_open+0x11a1>
 18e7f4a:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
 18e7f4f:	c6 01 00             	movb   $0x0,(%rcx)
 18e7f52:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18e7f59:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18e7f60:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 18e7f65:	48 01 d1             	add    %rdx,%rcx
 18e7f68:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 18e7f6c:	48 89 b4 24 28 01 00 00 	mov    %rsi,0x128(%rsp)
 18e7f74:	48 39 ce             	cmp    %rcx,%rsi
 18e7f77:	0f 82 94 05 00 00    	jb     18e8511 <tier0_tables_open+0x11a1>
 18e7f7d:	48 8b 8c 24 28 01 00 00 	mov    0x128(%rsp),%rcx
 18e7f85:	48 29 d1             	sub    %rdx,%rcx
 18e7f88:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18e7f8f:	48 29 ca             	sub    %rcx,%rdx
 18e7f92:	40 0f 92 c6          	setb   %sil
 18e7f96:	48 81 fa 01 02 00 00 	cmp    $0x201,%rdx
 18e7f9d:	0f 92 c2             	setb   %dl
 18e7fa0:	40 08 f2             	or     %sil,%dl
 18e7fa3:	0f 85 68 05 00 00    	jne    18e8511 <tier0_tables_open+0x11a1>
 18e7fa9:	48 81 c1 01 02 00 00 	add    $0x201,%rcx
 18e7fb0:	48 83 bc 24 28 01 00 00 00 	cmpq   $0x0,0x128(%rsp)
 18e7fb9:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18e7fc0:	0f 84 4b 05 00 00    	je     18e8511 <tier0_tables_open+0x11a1>
 18e7fc6:	48 8b 8c 24 28 01 00 00 	mov    0x128(%rsp),%rcx
 18e7fce:	c6 01 00             	movb   $0x0,(%rcx)
 18e7fd1:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18e7fd8:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18e7fdf:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 18e7fe4:	48 01 d1             	add    %rdx,%rcx
 18e7fe7:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 18e7feb:	48 89 b4 24 c8 00 00 00 	mov    %rsi,0xc8(%rsp)
 18e7ff3:	48 39 ce             	cmp    %rcx,%rsi
 18e7ff6:	0f 82 15 05 00 00    	jb     18e8511 <tier0_tables_open+0x11a1>
 18e7ffc:	48 8b 8c 24 c8 00 00 00 	mov    0xc8(%rsp),%rcx
 18e8004:	48 29 d1             	sub    %rdx,%rcx
 18e8007:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18e800e:	48 29 ca             	sub    %rcx,%rdx
 18e8011:	40 0f 92 c6          	setb   %sil
 18e8015:	48 81 fa 08 10 00 00 	cmp    $0x1008,%rdx
 18e801c:	0f 92 c2             	setb   %dl
 18e801f:	40 08 f2             	or     %sil,%dl
 18e8022:	0f 85 e9 04 00 00    	jne    18e8511 <tier0_tables_open+0x11a1>
 18e8028:	48 81 c1 08 10 00 00 	add    $0x1008,%rcx
 18e802f:	48 83 bc 24 c8 00 00 00 00 	cmpq   $0x0,0xc8(%rsp)
 18e8038:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18e803f:	0f 84 cc 04 00 00    	je     18e8511 <tier0_tables_open+0x11a1>
 18e8045:	48 8b 8c 24 c8 00 00 00 	mov    0xc8(%rsp),%rcx
 18e804d:	48 c7 01 00 00 00 00 	movq   $0x0,(%rcx)
 18e8054:	48 8b 93 40 01 00 00 	mov    0x140(%rbx),%rdx
 18e805b:	48 8b 8b 48 01 00 00 	mov    0x148(%rbx),%rcx
 18e8062:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 18e8067:	48 01 d1             	add    %rdx,%rcx
 18e806a:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 18e806e:	48 89 74 24 70       	mov    %rsi,0x70(%rsp)
 18e8073:	48 39 ce             	cmp    %rcx,%rsi
 18e8076:	0f 82 95 04 00 00    	jb     18e8511 <tier0_tables_open+0x11a1>
 18e807c:	48 8b 4c 24 70       	mov    0x70(%rsp),%rcx
 18e8081:	48 29 d1             	sub    %rdx,%rcx
 18e8084:	48 8b 93 50 01 00 00 	mov    0x150(%rbx),%rdx
 18e808b:	48 29 ca             	sub    %rcx,%rdx
 18e808e:	40 0f 92 c6          	setb   %sil
 18e8092:	48 81 fa 00 10 00 00 	cmp    $0x1000,%rdx
 18e8099:	0f 92 c2             	setb   %dl
 18e809c:	40 08 f2             	or     %sil,%dl
 18e809f:	0f 85 6c 04 00 00    	jne    18e8511 <tier0_tables_open+0x11a1>
 18e80a5:	48 81 c1 00 10 00 00 	add    $0x1000,%rcx
 18e80ac:	48 83 7c 24 70 00    	cmpq   $0x0,0x70(%rsp)
 18e80b2:	48 89 8b 48 01 00 00 	mov    %rcx,0x148(%rbx)
 18e80b9:	0f 84 52 04 00 00    	je     18e8511 <tier0_tables_open+0x11a1>
 18e80bf:	48 8b 7c 24 70       	mov    0x70(%rsp),%rdi
 18e80c4:	48 8d 83 40 01 00 00 	lea    0x140(%rbx),%rax
 18e80cb:	ba 00 10 00 00       	mov    $0x1000,%edx
 18e80d0:	4c 89 ac 24 d8 00 00 00 	mov    %r13,0xd8(%rsp)
 18e80d8:	4c 89 7c 24 20       	mov    %r15,0x20(%rsp)
 18e80dd:	48 89 1c 24          	mov    %rbx,(%rsp)
 18e80e1:	31 f6                	xor    %esi,%esi
 18e80e3:	45 31 ff             	xor    %r15d,%r15d
 18e80e6:	4d 89 cd             	mov    %r9,%r13
 18e80e9:	4d 89 d4             	mov    %r10,%r12
 18e80ec:	4c 89 db             	mov    %r11,%rbx
 18e80ef:	48 89 84 24 d0 00 00 00 	mov    %rax,0xd0(%rsp)
 18e80f7:	c5 f8 77             	vzeroupper
 18e80fa:	e8 81 1d eb fe       	call   799e80 <memset@plt>
 18e80ff:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 18e8104:	41 c6 46 01 01       	movb   $0x1,0x1(%r14)
 18e8109:	41 c6 45 01 01       	movb   $0x1,0x1(%r13)
 18e810e:	41 c6 44 24 01 00    	movb   $0x0,0x1(%r12)
 18e8114:	c6 43 01 00          	movb   $0x0,0x1(%rbx)
 18e8118:	4c 89 b4 24 90 00 00 00 	mov    %r14,0x90(%rsp)
 18e8120:	4c 89 ef             	mov    %r13,%rdi
 18e8123:	4d 89 e0             	mov    %r12,%r8
 18e8126:	49 89 d9             	mov    %rbx,%r9
 18e8129:	48 c7 40 08 01 00 00 00 	movq   $0x1,0x8(%rax)
 18e8131:	48 8d 05 d2 67 9d 00 	lea    0x9d67d2(%rip),%rax        # 22be90a <type_builtins+0x6a>
 18e8138:	41 8d 4f ea          	lea    -0x16(%r15),%ecx
 18e813c:	83 f9 e9             	cmp    $0xffffffe9,%ecx
 18e813f:	73 43                	jae    18e8184 <tier0_tables_open+0xe14>
 18e8141:	41 8d 4f eb          	lea    -0x15(%r15),%ecx
 18e8145:	83 f9 e9             	cmp    $0xffffffe9,%ecx
 18e8148:	73 7a                	jae    18e81c4 <tier0_tables_open+0xe54>
 18e814a:	41 8d 4f ec          	lea    -0x14(%r15),%ecx
 18e814e:	83 f9 e9             	cmp    $0xffffffe9,%ecx
 18e8151:	0f 83 b1 00 00 00    	jae    18e8208 <tier0_tables_open+0xe98>
 18e8157:	41 8d 4f ed          	lea    -0x13(%r15),%ecx
 18e815b:	83 f9 e9             	cmp    $0xffffffe9,%ecx
 18e815e:	0f 83 e8 00 00 00    	jae    18e824c <tier0_tables_open+0xedc>
 18e8164:	41 8d 4f ee          	lea    -0x12(%r15),%ecx
 18e8168:	83 f9 e9             	cmp    $0xffffffe9,%ecx
 18e816b:	0f 83 1f 01 00 00    	jae    18e8290 <tier0_tables_open+0xf20>
 18e8171:	49 83 c7 05          	add    $0x5,%r15
 18e8175:	48 83 c0 50          	add    $0x50,%rax
 18e8179:	49 83 ff 1e          	cmp    $0x1e,%r15
 18e817d:	75 b9                	jne    18e8138 <tier0_tables_open+0xdc8>
 18e817f:	e9 54 01 00 00       	jmp    18e82d8 <tier0_tables_open+0xf68>
 18e8184:	0f b6 48 be          	movzbl -0x42(%rax),%ecx
 18e8188:	48 8b b4 24 90 00 00 00 	mov    0x90(%rsp),%rsi
 18e8190:	0f b6 50 c0          	movzbl -0x40(%rax),%edx
 18e8194:	42 88 4c 3e 02       	mov    %cl,0x2(%rsi,%r15,1)
 18e8199:	41 8d 4f 02          	lea    0x2(%r15),%ecx
 18e819d:	42 88 4c 3f 02       	mov    %cl,0x2(%rdi,%r15,1)
 18e81a2:	43 c6 44 38 02 04    	movb   $0x4,0x2(%r8,%r15,1)
 18e81a8:	43 88 54 39 02       	mov    %dl,0x2(%r9,%r15,1)
 18e81ad:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
 18e81b2:	0f b6 48 bf          	movzbl -0x41(%rax),%ecx
 18e81b6:	4a 89 4c fa 10       	mov    %rcx,0x10(%rdx,%r15,8)
 18e81bb:	41 8d 4f eb          	lea    -0x15(%r15),%ecx
 18e81bf:	83 f9 e9             	cmp    $0xffffffe9,%ecx
 18e81c2:	72 86                	jb     18e814a <tier0_tables_open+0xdda>
 18e81c4:	0f b6 48 ce          	movzbl -0x32(%rax),%ecx
 18e81c8:	48 8b b4 24 90 00 00 00 	mov    0x90(%rsp),%rsi
 18e81d0:	0f b6 50 d0          	movzbl -0x30(%rax),%edx
 18e81d4:	42 88 4c 3e 03       	mov    %cl,0x3(%rsi,%r15,1)
 18e81d9:	41 8d 4f 03          	lea    0x3(%r15),%ecx
 18e81dd:	42 88 4c 3f 03       	mov    %cl,0x3(%rdi,%r15,1)
 18e81e2:	43 c6 44 38 03 04    	movb   $0x4,0x3(%r8,%r15,1)
 18e81e8:	43 88 54 39 03       	mov    %dl,0x3(%r9,%r15,1)
 18e81ed:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
 18e81f2:	0f b6 48 cf          	movzbl -0x31(%rax),%ecx
 18e81f6:	4a 89 4c fa 18       	mov    %rcx,0x18(%rdx,%r15,8)
 18e81fb:	41 8d 4f ec          	lea    -0x14(%r15),%ecx
 18e81ff:	83 f9 e9             	cmp    $0xffffffe9,%ecx
 18e8202:	0f 82 4f ff ff ff    	jb     18e8157 <tier0_tables_open+0xde7>
 18e8208:	0f b6 48 de          	movzbl -0x22(%rax),%ecx
 18e820c:	48 8b b4 24 90 00 00 00 	mov    0x90(%rsp),%rsi
 18e8214:	0f b6 50 e0          	movzbl -0x20(%rax),%edx
 18e8218:	42 88 4c 3e 04       	mov    %cl,0x4(%rsi,%r15,1)
 18e821d:	41 8d 4f 04          	lea    0x4(%r15),%ecx
 18e8221:	42 88 4c 3f 04       	mov    %cl,0x4(%rdi,%r15,1)
 18e8226:	43 c6 44 38 04 04    	movb   $0x4,0x4(%r8,%r15,1)
 18e822c:	43 88 54 39 04       	mov    %dl,0x4(%r9,%r15,1)
 18e8231:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
 18e8236:	0f b6 48 df          	movzbl -0x21(%rax),%ecx
 18e823a:	4a 89 4c fa 20       	mov    %rcx,0x20(%rdx,%r15,8)
 18e823f:	41 8d 4f ed          	lea    -0x13(%r15),%ecx
 18e8243:	83 f9 e9             	cmp    $0xffffffe9,%ecx
 18e8246:	0f 82 18 ff ff ff    	jb     18e8164 <tier0_tables_open+0xdf4>
 18e824c:	0f b6 48 ee          	movzbl -0x12(%rax),%ecx
 18e8250:	48 8b b4 24 90 00 00 00 	mov    0x90(%rsp),%rsi
 18e8258:	0f b6 50 f0          	movzbl -0x10(%rax),%edx
 18e825c:	42 88 4c 3e 05       	mov    %cl,0x5(%rsi,%r15,1)
 18e8261:	41 8d 4f 05          	lea    0x5(%r15),%ecx
 18e8265:	42 88 4c 3f 05       	mov    %cl,0x5(%rdi,%r15,1)
 18e826a:	43 c6 44 38 05 04    	movb   $0x4,0x5(%r8,%r15,1)
 18e8270:	43 88 54 39 05       	mov    %dl,0x5(%r9,%r15,1)
 18e8275:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
 18e827a:	0f b6 48 ef          	movzbl -0x11(%rax),%ecx
 18e827e:	4a 89 4c fa 28       	mov    %rcx,0x28(%rdx,%r15,8)
 18e8283:	41 8d 4f ee          	lea    -0x12(%r15),%ecx
 18e8287:	83 f9 e9             	cmp    $0xffffffe9,%ecx
 18e828a:	0f 82 e1 fe ff ff    	jb     18e8171 <tier0_tables_open+0xe01>
 18e8290:	0f b6 48 fe          	movzbl -0x2(%rax),%ecx
 18e8294:	48 8b b4 24 90 00 00 00 	mov    0x90(%rsp),%rsi
 18e829c:	0f b6 10             	movzbl (%rax),%edx
 18e829f:	42 88 4c 3e 06       	mov    %cl,0x6(%rsi,%r15,1)
 18e82a4:	41 8d 4f 06          	lea    0x6(%r15),%ecx
 18e82a8:	42 88 4c 3f 06       	mov    %cl,0x6(%rdi,%r15,1)
 18e82ad:	43 c6 44 38 06 04    	movb   $0x4,0x6(%r8,%r15,1)
 18e82b3:	43 88 54 39 06       	mov    %dl,0x6(%r9,%r15,1)
 18e82b8:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
 18e82bd:	0f b6 48 ff          	movzbl -0x1(%rax),%ecx
 18e82c1:	4a 89 4c fa 30       	mov    %rcx,0x30(%rdx,%r15,8)
 18e82c6:	49 83 c7 05          	add    $0x5,%r15
 18e82ca:	48 83 c0 50          	add    $0x50,%rax
 18e82ce:	49 83 ff 1e          	cmp    $0x1e,%r15
 18e82d2:	0f 85 60 fe ff ff    	jne    18e8138 <tier0_tables_open+0xdc8>
 18e82d8:	c5 fa 7e 0d 30 3f cc fe 	vmovq  -0x133c0d0(%rip),%xmm1        # 5ac210 <x86_effects_unknown+0x240>
 18e82e0:	c4 e2 79 31 15 db e7 cc fe 	vpmovzxbd -0x1331825(%rip),%xmm2        # 5b6ac4 <tier0_emit_x87.operations+0x74>
 18e82e9:	c5 fa 7e 05 2f 3f cc fe 	vmovq  -0x133c0d1(%rip),%xmm0        # 5ac220 <x86_effects_unknown+0x250>
 18e82f1:	bb 10 11 11 00       	mov    $0x111110,%ebx
 18e82f6:	41 be 02 00 00 00    	mov    $0x2,%r14d
 18e82fc:	41 bf 04 00 00 00    	mov    $0x4,%r15d
 18e8302:	41 bc 08 00 00 00    	mov    $0x8,%r12d
 18e8308:	4c 8d 15 91 65 9d 00 	lea    0x9d6591(%rip),%r10        # 22be8a0 <type_builtins>
 18e830f:	31 d2                	xor    %edx,%edx
 18e8311:	45 31 db             	xor    %r11d,%r11d
 18e8314:	48 0f a3 d3          	bt     %rdx,%rbx
 18e8318:	73 47                	jae    18e8361 <tier0_tables_open+0xff1>
 18e831a:	48 8b 84 24 90 00 00 00 	mov    0x90(%rsp),%rax
 18e8322:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
 18e8327:	c6 44 10 20 06       	movb   $0x6,0x20(%rax,%rdx,1)
 18e832c:	8d 42 20             	lea    0x20(%rdx),%eax
 18e832f:	88 44 17 20          	mov    %al,0x20(%rdi,%rdx,1)
 18e8333:	41 c6 44 10 20 04    	movb   $0x4,0x20(%r8,%rdx,1)
 18e8339:	43 0f b6 44 5a 0a    	movzbl 0xa(%r10,%r11,2),%eax
 18e833f:	41 88 44 11 20       	mov    %al,0x20(%r9,%rdx,1)
 18e8344:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
 18e8349:	44 89 9c 90 80 00 00 00 	mov    %r11d,0x80(%rax,%rdx,4)
 18e8351:	43 0f b6 44 5a 09    	movzbl 0x9(%r10,%r11,2),%eax
 18e8357:	01 c0                	add    %eax,%eax
 18e8359:	48 89 84 d1 00 01 00 00 	mov    %rax,0x100(%rcx,%rdx,8)
 18e8361:	c4 c2 e9 f7 c6       	shlx   %rdx,%r14,%rax
 18e8366:	a9 20 22 22 00       	test   $0x222220,%eax
 18e836b:	74 42                	je     18e83af <tier0_tables_open+0x103f>
 18e836d:	48 8b 8c 24 90 00 00 00 	mov    0x90(%rsp),%rcx
 18e8375:	48 89 d0             	mov    %rdx,%rax
 18e8378:	48 83 c8 21          	or     $0x21,%rax
 18e837c:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
 18e8381:	c6 04 01 06          	movb   $0x6,(%rcx,%rax,1)
 18e8385:	88 04 07             	mov    %al,(%rdi,%rax,1)
 18e8388:	41 c6 04 00 04       	movb   $0x4,(%r8,%rax,1)
 18e838d:	43 0f b6 4c 5a 1a    	movzbl 0x1a(%r10,%r11,2),%ecx
 18e8393:	41 88 0c 01          	mov    %cl,(%r9,%rax,1)
 18e8397:	41 8d 4b 08          	lea    0x8(%r11),%ecx
 18e839b:	89 0c 86             	mov    %ecx,(%rsi,%rax,4)
 18e839e:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
 18e83a3:	43 0f b6 4c 5a 19    	movzbl 0x19(%r10,%r11,2),%ecx
 18e83a9:	01 c9                	add    %ecx,%ecx
 18e83ab:	48 89 0c c6          	mov    %rcx,(%rsi,%rax,8)
 18e83af:	c4 c2 e9 f7 c7       	shlx   %rdx,%r15,%rax
 18e83b4:	a9 40 44 40 00       	test   $0x404440,%eax
 18e83b9:	74 42                	je     18e83fd <tier0_tables_open+0x108d>
 18e83bb:	48 8b 8c 24 90 00 00 00 	mov    0x90(%rsp),%rcx
 18e83c3:	48 89 d0             	mov    %rdx,%rax
 18e83c6:	48 83 c8 22          	or     $0x22,%rax
 18e83ca:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
 18e83cf:	c6 04 01 06          	movb   $0x6,(%rcx,%rax,1)
 18e83d3:	88 04 07             	mov    %al,(%rdi,%rax,1)
 18e83d6:	41 c6 04 00 04       	movb   $0x4,(%r8,%rax,1)
 18e83db:	43 0f b6 4c 5a 2a    	movzbl 0x2a(%r10,%r11,2),%ecx
 18e83e1:	41 88 0c 01          	mov    %cl,(%r9,%rax,1)
 18e83e5:	41 8d 4b 10          	lea    0x10(%r11),%ecx
 18e83e9:	89 0c 86             	mov    %ecx,(%rsi,%rax,4)
 18e83ec:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
 18e83f1:	43 0f b6 4c 5a 29    	movzbl 0x29(%r10,%r11,2),%ecx
 18e83f7:	01 c9                	add    %ecx,%ecx
 18e83f9:	48 89 0c c6          	mov    %rcx,(%rsi,%rax,8)
 18e83fd:	c4 c2 e9 f7 c4       	shlx   %rdx,%r12,%rax
 18e8402:	a9 88 88 08 00       	test   $0x88888,%eax
 18e8407:	74 42                	je     18e844b <tier0_tables_open+0x10db>
 18e8409:	48 8b 8c 24 90 00 00 00 	mov    0x90(%rsp),%rcx
 18e8411:	48 89 d0             	mov    %rdx,%rax
 18e8414:	48 83 c8 23          	or     $0x23,%rax
 18e8418:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
 18e841d:	c6 04 01 06          	movb   $0x6,(%rcx,%rax,1)
 18e8421:	88 04 07             	mov    %al,(%rdi,%rax,1)
 18e8424:	41 c6 04 00 04       	movb   $0x4,(%r8,%rax,1)
 18e8429:	43 0f b6 4c 5a 3a    	movzbl 0x3a(%r10,%r11,2),%ecx
 18e842f:	41 88 0c 01          	mov    %cl,(%r9,%rax,1)
 18e8433:	41 8d 4b 18          	lea    0x18(%r11),%ecx
 18e8437:	89 0c 86             	mov    %ecx,(%rsi,%rax,4)
 18e843a:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
 18e843f:	43 0f b6 4c 5a 39    	movzbl 0x39(%r10,%r11,2),%ecx
 18e8445:	01 c9                	add    %ecx,%ecx
 18e8447:	48 89 0c c6          	mov    %rcx,(%rsi,%rax,8)
 18e844b:	b0 01                	mov    $0x1,%al
 18e844d:	48 83 c2 04          	add    $0x4,%rdx
 18e8451:	49 83 c3 20          	add    $0x20,%r11
 18e8455:	48 89 84 24 b8 00 00 00 	mov    %rax,0xb8(%rsp)
 18e845d:	48 83 fa 20          	cmp    $0x20,%rdx
 18e8461:	0f 85 ad fe ff ff    	jne    18e8314 <tier0_tables_open+0xfa4>
 18e8467:	ba 40 60 00 00       	mov    $0x6040,%edx
 18e846c:	48 89 bc 24 40 01 00 00 	mov    %rdi,0x140(%rsp)
 18e8474:	4c 89 84 24 18 01 00 00 	mov    %r8,0x118(%rsp)
 18e847c:	4c 89 4c 24 68       	mov    %r9,0x68(%rsp)
 18e8481:	48 8b 1c 24          	mov    (%rsp),%rbx
 18e8485:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
 18e848a:	48 8b 4c 24 58       	mov    0x58(%rsp),%rcx
 18e848f:	4c 8b bc 24 08 01 00 00 	mov    0x108(%rsp),%r15
 18e8497:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
 18e849c:	4c 8b 94 24 00 01 00 00 	mov    0x100(%rsp),%r10
 18e84a4:	48 8b bc 24 a8 00 00 00 	mov    0xa8(%rsp),%rdi
 18e84ac:	4c 8b 44 24 18       	mov    0x18(%rsp),%r8
 18e84b1:	4c 8b b4 24 f8 00 00 00 	mov    0xf8(%rsp),%r14
 18e84b9:	4c 8b 9c 24 38 01 00 00 	mov    0x138(%rsp),%r11
 18e84c1:	4c 8b ac 24 a0 00 00 00 	mov    0xa0(%rsp),%r13
 18e84c9:	48 8b ac 24 30 01 00 00 	mov    0x130(%rsp),%rbp
 18e84d1:	4c 8b 8c 24 28 01 00 00 	mov    0x128(%rsp),%r9
 18e84d9:	4c 8b a4 24 c8 00 00 00 	mov    0xc8(%rsp),%r12
 18e84e1:	c7 44 24 48 00 00 00 00 	movl   $0x0,0x48(%rsp)
 18e84e9:	c7 44 24 30 40 00 00 00 	movl   $0x40,0x30(%rsp)
 18e84f1:	c7 84 24 10 01 00 00 00 04 00 00 	movl   $0x400,0x110(%rsp)
 18e84fc:	48 89 94 24 48 01 00 00 	mov    %rdx,0x148(%rsp)
 18e8504:	48 8b 94 24 90 00 00 00 	mov    0x90(%rsp),%rdx
 18e850c:	e9 10 01 00 00       	jmp    18e8621 <tier0_tables_open+0x12b1>
 18e8511:	48 3b 83 28 01 00 00 	cmp    0x128(%rbx),%rax
 18e8518:	0f 87 04 4c 00 00    	ja     18ed122 <tier0_tables_open+0x5db2>
 18e851e:	48 89 83 28 01 00 00 	mov    %rax,0x128(%rbx)
 18e8525:	b8 c0 01 00 00       	mov    $0x1c0,%eax
 18e852a:	48 c7 83 48 01 00 00 00 00 00 00 	movq   $0x0,0x148(%rbx)
 18e8535:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 18e8539:	c5 fa 7f 84 24 bc 01 00 00 	vmovdqu %xmm0,0x1bc(%rsp)
 18e8542:	c5 f9 7f 84 24 b0 01 00 00 	vmovdqa %xmm0,0x1b0(%rsp)
 18e854b:	c7 44 24 48 01 00 00 00 	movl   $0x1,0x48(%rsp)
 18e8553:	48 c7 84 24 b8 00 00 00 00 00 00 00 	movq   $0x0,0xb8(%rsp)
 18e855f:	31 d2                	xor    %edx,%edx
 18e8561:	48 c7 84 24 40 01 00 00 00 00 00 00 	movq   $0x0,0x140(%rsp)
 18e856d:	48 c7 84 24 18 01 00 00 00 00 00 00 	movq   $0x0,0x118(%rsp)
 18e8579:	48 c7 44 24 68 00 00 00 00 	movq   $0x0,0x68(%rsp)
 18e8582:	48 c7 44 24 20 00 00 00 00 	movq   $0x0,0x20(%rsp)
 18e858b:	48 c7 84 24 d8 00 00 00 00 00 00 00 	movq   $0x0,0xd8(%rsp)
 18e8597:	48 c7 44 24 10 00 00 00 00 	movq   $0x0,0x10(%rsp)
 18e85a0:	48 c7 44 24 08 00 00 00 00 	movq   $0x0,0x8(%rsp)
 18e85a9:	48 c7 84 24 80 00 00 00 00 00 00 00 	movq   $0x0,0x80(%rsp)
 18e85b5:	c7 44 24 30 00 00 00 00 	movl   $0x0,0x30(%rsp)
 18e85bd:	48 c7 44 24 40 00 00 00 00 	movq   $0x0,0x40(%rsp)
 18e85c6:	c7 84 24 10 01 00 00 00 00 00 00 	movl   $0x0,0x110(%rsp)
 18e85d1:	c5 e9 ef d2          	vpxor  %xmm2,%xmm2,%xmm2
 18e85d5:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
 18e85d9:	31 c9                	xor    %ecx,%ecx
 18e85db:	45 31 ff             	xor    %r15d,%r15d
 18e85de:	31 f6                	xor    %esi,%esi
 18e85e0:	45 31 d2             	xor    %r10d,%r10d
 18e85e3:	31 ff                	xor    %edi,%edi
 18e85e5:	45 31 c0             	xor    %r8d,%r8d
 18e85e8:	45 31 f6             	xor    %r14d,%r14d
 18e85eb:	45 31 db             	xor    %r11d,%r11d
 18e85ee:	45 31 ed             	xor    %r13d,%r13d
 18e85f1:	31 ed                	xor    %ebp,%ebp
 18e85f3:	48 c7 44 24 38 00 00 00 00 	movq   $0x0,0x38(%rsp)
 18e85fc:	45 31 c9             	xor    %r9d,%r9d
 18e85ff:	45 31 e4             	xor    %r12d,%r12d
 18e8602:	48 c7 84 24 d0 00 00 00 00 00 00 00 	movq   $0x0,0xd0(%rsp)
 18e860e:	48 c7 44 24 70 00 00 00 00 	movq   $0x0,0x70(%rsp)
 18e8617:	48 89 84 24 48 01 00 00 	mov    %rax,0x148(%rsp)
 18e861f:	31 c0                	xor    %eax,%eax
 18e8621:	48 89 13             	mov    %rdx,(%rbx)
 18e8624:	48 8b 94 24 40 01 00 00 	mov    0x140(%rsp),%rdx
 18e862c:	48 89 53 08          	mov    %rdx,0x8(%rbx)
 18e8630:	48 8b 94 24 18 01 00 00 	mov    0x118(%rsp),%rdx
 18e8638:	48 89 53 10          	mov    %rdx,0x10(%rbx)
 18e863c:	48 8b 54 24 68       	mov    0x68(%rsp),%rdx
 18e8641:	48 89 53 18          	mov    %rdx,0x18(%rbx)
 18e8645:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
 18e864a:	48 89 53 20          	mov    %rdx,0x20(%rbx)
 18e864e:	48 8b 94 24 d8 00 00 00 	mov    0xd8(%rsp),%rdx
 18e8656:	48 89 53 28          	mov    %rdx,0x28(%rbx)
 18e865a:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
 18e865f:	48 89 53 30          	mov    %rdx,0x30(%rbx)
 18e8663:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
 18e8668:	48 89 53 38          	mov    %rdx,0x38(%rbx)
 18e866c:	48 8b 94 24 80 00 00 00 	mov    0x80(%rsp),%rdx
 18e8674:	48 89 53 40          	mov    %rdx,0x40(%rbx)
 18e8678:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
 18e867d:	c5 f9 d6 43 48       	vmovq  %xmm0,0x48(%rbx)
 18e8682:	48 89 53 50          	mov    %rdx,0x50(%rbx)
 18e8686:	8b 94 24 10 01 00 00 	mov    0x110(%rsp),%edx
 18e868d:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%rbx)
 18e8694:	89 53 5c             	mov    %edx,0x5c(%rbx)
 18e8697:	48 89 43 60          	mov    %rax,0x60(%rbx)
 18e869b:	48 89 4b 68          	mov    %rcx,0x68(%rbx)
 18e869f:	4c 89 7b 70          	mov    %r15,0x70(%rbx)
 18e86a3:	48 89 73 78          	mov    %rsi,0x78(%rbx)
 18e86a7:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
 18e86ac:	4c 89 93 80 00 00 00 	mov    %r10,0x80(%rbx)
 18e86b3:	48 89 bb 88 00 00 00 	mov    %rdi,0x88(%rbx)
 18e86ba:	4c 89 83 90 00 00 00 	mov    %r8,0x90(%rbx)
 18e86c1:	4c 89 b3 98 00 00 00 	mov    %r14,0x98(%rbx)
 18e86c8:	c5 f9 d6 93 a0 00 00 00 	vmovq  %xmm2,0xa0(%rbx)
 18e86d0:	48 c7 83 a8 00 00 00 00 00 00 00 	movq   $0x0,0xa8(%rbx)
 18e86db:	4c 89 9b b0 00 00 00 	mov    %r11,0xb0(%rbx)
 18e86e2:	4c 89 ab b8 00 00 00 	mov    %r13,0xb8(%rbx)
 18e86e9:	48 89 ab c0 00 00 00 	mov    %rbp,0xc0(%rbx)
 18e86f0:	4c 8b 94 24 d0 00 00 00 	mov    0xd0(%rsp),%r10
 18e86f8:	8b 54 24 30          	mov    0x30(%rsp),%edx
 18e86fc:	8b 4c 24 48          	mov    0x48(%rsp),%ecx
 18e8700:	4c 8b bc 24 48 01 00 00 	mov    0x148(%rsp),%r15
 18e8708:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
 18e870e:	31 ed                	xor    %ebp,%ebp
 18e8710:	31 ff                	xor    %edi,%edi
 18e8712:	48 89 b3 c8 00 00 00 	mov    %rsi,0xc8(%rbx)
 18e8719:	48 8b 74 24 70       	mov    0x70(%rsp),%rsi
 18e871e:	4c 89 8b d0 00 00 00 	mov    %r9,0xd0(%rbx)
 18e8725:	4c 89 a3 d8 00 00 00 	mov    %r12,0xd8(%rbx)
 18e872c:	c5 f9 d6 8b e0 00 00 00 	vmovq  %xmm1,0xe0(%rbx)
 18e8734:	4c 89 93 e8 00 00 00 	mov    %r10,0xe8(%rbx)
 18e873b:	45 8d b7 c0 0f 00 00 	lea    0xfc0(%r15),%r14d
 18e8742:	45 31 c9             	xor    %r9d,%r9d
 18e8745:	41 81 e6 00 70 00 00 	and    $0x7000,%r14d
 18e874c:	48 89 b3 f0 00 00 00 	mov    %rsi,0xf0(%rbx)
 18e8753:	89 93 f8 00 00 00    	mov    %edx,0xf8(%rbx)
 18e8759:	c7 83 fc 00 00 00 00 00 00 00 	movl   $0x0,0xfc(%rbx)
 18e8763:	89 8b 00 01 00 00    	mov    %ecx,0x100(%rbx)
 18e8769:	ba 03 00 00 00       	mov    $0x3,%edx
 18e876e:	b9 22 40 00 00       	mov    $0x4022,%ecx
 18e8773:	4c 89 f6             	mov    %r14,%rsi
 18e8776:	c5 f8 10 84 24 bc 01 00 00 	vmovups 0x1bc(%rsp),%xmm0
 18e877f:	c5 f8 11 83 10 01 00 00 	vmovups %xmm0,0x110(%rbx)
 18e8787:	c5 f9 6f 84 24 b0 01 00 00 	vmovdqa 0x1b0(%rsp),%xmm0
 18e8790:	c5 fa 7f 83 04 01 00 00 	vmovdqu %xmm0,0x104(%rbx)
 18e8798:	c5 f8 77             	vzeroupper
 18e879b:	e8 f0 18 eb fe       	call   79a090 <mmap@plt>
 18e87a0:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
 18e87a4:	74 18                	je     18e87be <tier0_tables_open+0x144e>
 18e87a6:	ba 0f 00 00 00       	mov    $0xf,%edx
 18e87ab:	49 89 c4             	mov    %rax,%r12
 18e87ae:	48 89 c7             	mov    %rax,%rdi
 18e87b1:	4c 89 f6             	mov    %r14,%rsi
 18e87b4:	e8 87 18 eb fe       	call   79a040 <madvise@plt>
 18e87b9:	4c 89 fd             	mov    %r15,%rbp
 18e87bc:	eb 03                	jmp    18e87c1 <tier0_tables_open+0x1451>
 18e87be:	45 31 e4             	xor    %r12d,%r12d
 18e87c1:	80 bc 24 b8 00 00 00 00 	cmpb   $0x0,0xb8(%rsp)
 18e87c9:	4c 89 a3 40 02 00 00 	mov    %r12,0x240(%rbx)
 18e87d0:	48 c7 83 48 02 00 00 00 00 00 00 	movq   $0x0,0x248(%rbx)
 18e87db:	48 89 ab 50 02 00 00 	mov    %rbp,0x250(%rbx)
 18e87e2:	48 c7 83 58 02 00 00 00 00 00 00 	movq   $0x0,0x258(%rbx)
 18e87ed:	0f 84 ac 00 00 00    	je     18e889f <tier0_tables_open+0x152f>
 18e87f3:	44 8b 7b 4c          	mov    0x4c(%rbx),%r15d
 18e87f7:	49 8d 44 24 3f       	lea    0x3f(%r12),%rax
 18e87fc:	4c 8d b3 80 01 00 00 	lea    0x180(%rbx),%r14
 18e8803:	48 83 e0 c0          	and    $0xffffffffffffffc0,%rax
 18e8807:	48 89 c2             	mov    %rax,%rdx
 18e880a:	4c 29 e2             	sub    %r12,%rdx
 18e880d:	72 25                	jb     18e8834 <tier0_tables_open+0x14c4>
 18e880f:	4c 89 f9             	mov    %r15,%rcx
 18e8812:	48 c1 e1 04          	shl    $0x4,%rcx
 18e8816:	48 89 ee             	mov    %rbp,%rsi
 18e8819:	48 29 d6             	sub    %rdx,%rsi
 18e881c:	40 0f 92 c7          	setb   %dil
 18e8820:	48 39 f1             	cmp    %rsi,%rcx
 18e8823:	40 0f 97 c6          	seta   %sil
 18e8827:	40 08 fe             	or     %dil,%sil
 18e882a:	40 80 fe 01          	cmp    $0x1,%sil
 18e882e:	0f 85 99 00 00 00    	jne    18e88cd <tier0_tables_open+0x155d>
 18e8834:	49 c7 06 00 00 00 00 	movq   $0x0,(%r14)
 18e883b:	48 c7 83 88 01 00 00 00 00 00 00 	movq   $0x0,0x188(%rbx)
 18e8846:	48 c7 83 90 01 00 00 00 00 00 00 	movq   $0x0,0x190(%rbx)
 18e8851:	48 c7 83 98 01 00 00 00 00 00 00 	movq   $0x0,0x198(%rbx)
 18e885c:	48 c7 83 a0 01 00 00 00 00 00 00 	movq   $0x0,0x1a0(%rbx)
 18e8867:	48 c7 83 a8 01 00 00 00 00 00 00 	movq   $0x0,0x1a8(%rbx)
 18e8872:	c4 e2 79 21 05 4d e2 cc fe 	vpmovsxbd -0x1331db3(%rip),%xmm0        # 5b6ac8 <tier0_emit_x87.operations+0x78>
 18e887b:	48 c7 83 b0 01 00 00 00 00 00 00 	movq   $0x0,0x1b0(%rbx)
 18e8886:	c4 c3 79 22 c7 00    	vpinsrd $0x0,%r15d,%xmm0,%xmm0
 18e888c:	c5 fa 7f 83 b8 01 00 00 	vmovdqu %xmm0,0x1b8(%rbx)
 18e8894:	48 c7 83 48 02 00 00 00 00 00 00 	movq   $0x0,0x248(%rbx)
 18e889f:	31 c0                	xor    %eax,%eax
 18e88a1:	64 48 8b 0c 25 28 00 00 00 	mov    %fs:0x28,%rcx
 18e88aa:	48 3b 8c 24 c0 02 00 00 	cmp    0x2c0(%rsp),%rcx
 18e88b2:	0f 85 92 12 00 00    	jne    18e9b4a <tier0_tables_open+0x27da>
 18e88b8:	48 81 c4 c8 02 00 00 	add    $0x2c8,%rsp
 18e88bf:	5b                   	pop    %rbx
 18e88c0:	41 5c                	pop    %r12
 18e88c2:	41 5d                	pop    %r13
 18e88c4:	41 5e                	pop    %r14
 18e88c6:	41 5f                	pop    %r15
 18e88c8:	5d                   	pop    %rbp
 18e88c9:	c5 f8 77             	vzeroupper
 18e88cc:	c3                   	ret
 18e88cd:	48 01 ca             	add    %rcx,%rdx
 18e88d0:	48 89 93 48 02 00 00 	mov    %rdx,0x248(%rbx)
 18e88d7:	48 89 83 80 01 00 00 	mov    %rax,0x180(%rbx)
 18e88de:	48 85 c0             	test   %rax,%rax
 18e88e1:	0f 84 54 ff ff ff    	je     18e883b <tier0_tables_open+0x14cb>
 18e88e7:	48 8d 7c 01 30       	lea    0x30(%rcx,%rax,1),%rdi
 18e88ec:	48 8d 14 01          	lea    (%rcx,%rax,1),%rdx
 18e88f0:	48 83 e7 c0          	and    $0xffffffffffffffc0,%rdi
 18e88f4:	48 39 d7             	cmp    %rdx,%rdi
 18e88f7:	0f 82 3e ff ff ff    	jb     18e883b <tier0_tables_open+0x14cb>
 18e88fd:	48 89 f8             	mov    %rdi,%rax
 18e8900:	4a 8d 14 bd 00 00 00 00 	lea    0x0(,%r15,4),%rdx
 18e8908:	4c 29 e0             	sub    %r12,%rax
 18e890b:	48 89 e9             	mov    %rbp,%rcx
 18e890e:	48 29 c1             	sub    %rax,%rcx
 18e8911:	40 0f 92 c6          	setb   %sil
 18e8915:	48 39 ca             	cmp    %rcx,%rdx
 18e8918:	0f 97 c1             	seta   %cl
 18e891b:	40 08 f1             	or     %sil,%cl
 18e891e:	80 f9 01             	cmp    $0x1,%cl
 18e8921:	0f 84 14 ff ff ff    	je     18e883b <tier0_tables_open+0x14cb>
 18e8927:	48 01 d0             	add    %rdx,%rax
 18e892a:	48 89 83 48 02 00 00 	mov    %rax,0x248(%rbx)
 18e8931:	48 89 bb 88 01 00 00 	mov    %rdi,0x188(%rbx)
 18e8938:	48 85 ff             	test   %rdi,%rdi
 18e893b:	0f 84 05 ff ff ff    	je     18e8846 <tier0_tables_open+0x14d6>
 18e8941:	48 8d 4c 17 3c       	lea    0x3c(%rdi,%rdx,1),%rcx
 18e8946:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
 18e894a:	48 83 e1 c0          	and    $0xffffffffffffffc0,%rcx
 18e894e:	48 39 c1             	cmp    %rax,%rcx
 18e8951:	0f 82 ef fe ff ff    	jb     18e8846 <tier0_tables_open+0x14d6>
 18e8957:	48 89 c8             	mov    %rcx,%rax
 18e895a:	4c 29 e0             	sub    %r12,%rax
 18e895d:	48 89 ee             	mov    %rbp,%rsi
 18e8960:	48 29 c6             	sub    %rax,%rsi
 18e8963:	41 0f 92 c0          	setb   %r8b
 18e8967:	48 39 f2             	cmp    %rsi,%rdx
 18e896a:	40 0f 97 c6          	seta   %sil
 18e896e:	44 08 c6             	or     %r8b,%sil
 18e8971:	40 80 fe 01          	cmp    $0x1,%sil
 18e8975:	0f 84 cb fe ff ff    	je     18e8846 <tier0_tables_open+0x14d6>
 18e897b:	48 01 d0             	add    %rdx,%rax
 18e897e:	48 89 83 48 02 00 00 	mov    %rax,0x248(%rbx)
 18e8985:	48 89 8b 90 01 00 00 	mov    %rcx,0x190(%rbx)
 18e898c:	48 85 c9             	test   %rcx,%rcx
 18e898f:	0f 84 bc fe ff ff    	je     18e8851 <tier0_tables_open+0x14e1>
 18e8995:	48 8d 44 11 3c       	lea    0x3c(%rcx,%rdx,1),%rax
 18e899a:	48 01 d1             	add    %rdx,%rcx
 18e899d:	48 83 e0 c0          	and    $0xffffffffffffffc0,%rax
 18e89a1:	48 39 c8             	cmp    %rcx,%rax
 18e89a4:	0f 82 a7 fe ff ff    	jb     18e8851 <tier0_tables_open+0x14e1>
 18e89aa:	48 89 c1             	mov    %rax,%rcx
 18e89ad:	4c 29 e1             	sub    %r12,%rcx
 18e89b0:	48 89 ee             	mov    %rbp,%rsi
 18e89b3:	48 29 ce             	sub    %rcx,%rsi
 18e89b6:	41 0f 92 c0          	setb   %r8b
 18e89ba:	4c 39 fe             	cmp    %r15,%rsi
 18e89bd:	40 0f 92 c6          	setb   %sil
 18e89c1:	44 08 c6             	or     %r8b,%sil
 18e89c4:	40 80 fe 01          	cmp    $0x1,%sil
 18e89c8:	0f 84 83 fe ff ff    	je     18e8851 <tier0_tables_open+0x14e1>
 18e89ce:	4c 01 f9             	add    %r15,%rcx
 18e89d1:	48 89 8b 48 02 00 00 	mov    %rcx,0x248(%rbx)
 18e89d8:	48 89 83 98 01 00 00 	mov    %rax,0x198(%rbx)
 18e89df:	48 85 c0             	test   %rax,%rax
 18e89e2:	0f 84 74 fe ff ff    	je     18e885c <tier0_tables_open+0x14ec>
 18e89e8:	4a 8d 4c 38 3f       	lea    0x3f(%rax,%r15,1),%rcx
 18e89ed:	4c 01 f8             	add    %r15,%rax
 18e89f0:	48 83 e1 c0          	and    $0xffffffffffffffc0,%rcx
 18e89f4:	48 39 c1             	cmp    %rax,%rcx
 18e89f7:	0f 82 5f fe ff ff    	jb     18e885c <tier0_tables_open+0x14ec>
 18e89fd:	48 89 c8             	mov    %rcx,%rax
 18e8a00:	4c 29 e0             	sub    %r12,%rax
 18e8a03:	48 89 ee             	mov    %rbp,%rsi
 18e8a06:	48 29 c6             	sub    %rax,%rsi
 18e8a09:	41 0f 92 c0          	setb   %r8b
 18e8a0d:	4c 39 fe             	cmp    %r15,%rsi
 18e8a10:	40 0f 92 c6          	setb   %sil
 18e8a14:	44 08 c6             	or     %r8b,%sil
 18e8a17:	40 80 fe 01          	cmp    $0x1,%sil
 18e8a1b:	0f 84 3b fe ff ff    	je     18e885c <tier0_tables_open+0x14ec>
 18e8a21:	4c 01 f8             	add    %r15,%rax
 18e8a24:	48 89 83 48 02 00 00 	mov    %rax,0x248(%rbx)
 18e8a2b:	48 89 8b a0 01 00 00 	mov    %rcx,0x1a0(%rbx)
 18e8a32:	48 85 c9             	test   %rcx,%rcx
 18e8a35:	0f 84 2c fe ff ff    	je     18e8867 <tier0_tables_open+0x14f7>
 18e8a3b:	4a 8d 44 39 3f       	lea    0x3f(%rcx,%r15,1),%rax
 18e8a40:	4c 01 f9             	add    %r15,%rcx
 18e8a43:	48 83 e0 c0          	and    $0xffffffffffffffc0,%rax
 18e8a47:	48 39 c8             	cmp    %rcx,%rax
 18e8a4a:	0f 82 17 fe ff ff    	jb     18e8867 <tier0_tables_open+0x14f7>
 18e8a50:	48 89 c1             	mov    %rax,%rcx
 18e8a53:	4e 8d 2c fd 00 00 00 00 	lea    0x0(,%r15,8),%r13
 18e8a5b:	4c 29 e1             	sub    %r12,%rcx
 18e8a5e:	48 89 ee             	mov    %rbp,%rsi
 18e8a61:	48 29 ce             	sub    %rcx,%rsi
 18e8a64:	41 0f 92 c0          	setb   %r8b
 18e8a68:	49 39 f5             	cmp    %rsi,%r13
 18e8a6b:	40 0f 97 c6          	seta   %sil
 18e8a6f:	44 08 c6             	or     %r8b,%sil
 18e8a72:	40 80 fe 01          	cmp    $0x1,%sil
 18e8a76:	0f 84 eb fd ff ff    	je     18e8867 <tier0_tables_open+0x14f7>
 18e8a7c:	4c 01 e9             	add    %r13,%rcx
 18e8a7f:	48 89 8b 48 02 00 00 	mov    %rcx,0x248(%rbx)
 18e8a86:	48 89 83 a8 01 00 00 	mov    %rax,0x1a8(%rbx)
 18e8a8d:	48 85 c0             	test   %rax,%rax
 18e8a90:	0f 84 dc fd ff ff    	je     18e8872 <tier0_tables_open+0x1502>
 18e8a96:	4a 8d 4c 28 38       	lea    0x38(%rax,%r13,1),%rcx
 18e8a9b:	4c 01 e8             	add    %r13,%rax
 18e8a9e:	48 83 e1 c0          	and    $0xffffffffffffffc0,%rcx
 18e8aa2:	48 39 c1             	cmp    %rax,%rcx
 18e8aa5:	0f 82 c7 fd ff ff    	jb     18e8872 <tier0_tables_open+0x1502>
 18e8aab:	48 89 c8             	mov    %rcx,%rax
 18e8aae:	4c 29 e0             	sub    %r12,%rax
 18e8ab1:	48 29 c5             	sub    %rax,%rbp
 18e8ab4:	40 0f 92 c6          	setb   %sil
 18e8ab8:	49 39 ed             	cmp    %rbp,%r13
 18e8abb:	41 0f 97 c0          	seta   %r8b
 18e8abf:	41 08 f0             	or     %sil,%r8b
 18e8ac2:	41 80 f8 01          	cmp    $0x1,%r8b
 18e8ac6:	0f 84 a6 fd ff ff    	je     18e8872 <tier0_tables_open+0x1502>
 18e8acc:	c4 e2 79 21 05 f3 df cc fe 	vpmovsxbd -0x133200d(%rip),%xmm0        # 5b6ac8 <tier0_emit_x87.operations+0x78>
 18e8ad5:	4c 01 e8             	add    %r13,%rax
 18e8ad8:	48 89 83 48 02 00 00 	mov    %rax,0x248(%rbx)
 18e8adf:	48 89 8b b0 01 00 00 	mov    %rcx,0x1b0(%rbx)
 18e8ae6:	c4 c3 79 22 c7 00    	vpinsrd $0x0,%r15d,%xmm0,%xmm0
 18e8aec:	c5 fa 7f 83 b8 01 00 00 	vmovdqu %xmm0,0x1b8(%rbx)
 18e8af4:	48 85 c9             	test   %rcx,%rcx
 18e8af7:	0f 84 97 fd ff ff    	je     18e8894 <tier0_tables_open+0x1524>
 18e8afd:	31 f6                	xor    %esi,%esi
 18e8aff:	45 31 e4             	xor    %r12d,%r12d
 18e8b02:	e8 79 13 eb fe       	call   799e80 <memset@plt>
 18e8b07:	48 8b bb a0 01 00 00 	mov    0x1a0(%rbx),%rdi
 18e8b0e:	31 f6                	xor    %esi,%esi
 18e8b10:	4c 89 fa             	mov    %r15,%rdx
 18e8b13:	e8 68 13 eb fe       	call   799e80 <memset@plt>
 18e8b18:	48 8b bb a8 01 00 00 	mov    0x1a8(%rbx),%rdi
 18e8b1f:	31 f6                	xor    %esi,%esi
 18e8b21:	4c 89 ea             	mov    %r13,%rdx
 18e8b24:	e8 57 13 eb fe       	call   799e80 <memset@plt>
 18e8b29:	c5 fd 6f 05 6f de c9 fe 	vmovdqa -0x1362191(%rip),%ymm0        # 5869a0 <x86_disassembly_format.rounding_names+0x180>
 18e8b31:	c5 f9 6f 0d 37 36 cc fe 	vmovdqa -0x133c9c9(%rip),%xmm1        # 5ac170 <x86_effects_unknown+0x1a0>
 18e8b39:	48 b8 07 07 07 07 07 07 07 07 	movabs $0x707070707070707,%rax
 18e8b43:	41 bf 01 00 00 00    	mov    $0x1,%r15d
 18e8b49:	bd 77 00 00 00       	mov    $0x77,%ebp
 18e8b4e:	66 41 bd 01 00       	mov    $0x1,%r13w
 18e8b53:	c7 83 00 02 00 00 00 00 00 00 	movl   $0x0,0x200(%rbx)
 18e8b5d:	c7 83 03 02 00 00 00 00 00 00 	movl   $0x0,0x203(%rbx)
 18e8b67:	48 89 1c 24          	mov    %rbx,(%rsp)
 18e8b6b:	c5 fe 7f 83 07 02 00 00 	vmovdqu %ymm0,0x207(%rbx)
 18e8b73:	c5 fa 7f 8b 27 02 00 00 	vmovdqu %xmm1,0x227(%rbx)
 18e8b7b:	c6 83 37 02 00 00 07 	movb   $0x7,0x237(%rbx)
 18e8b82:	48 89 83 38 02 00 00 	mov    %rax,0x238(%rbx)
 18e8b89:	e9 a3 00 00 00       	jmp    18e8c31 <tier0_tables_open+0x18c1>
 18e8b8e:	c1 e8 18             	shr    $0x18,%eax
 18e8b91:	62 f2 7d 08 7a c0    	vpbroadcastb %eax,%xmm0
 18e8b97:	c5 f9 fc 05 e1 35 cc fe 	vpaddb -0x133ca1f(%rip),%xmm0,%xmm0        # 5ac180 <x86_effects_unknown+0x1b0>
 18e8b9f:	89 c8                	mov    %ecx,%eax
 18e8ba1:	62 f3 7d 08 3e 0d e4 35 cc fe 06 	vpcmpnleub -0x133ca1c(%rip),%xmm0,%k1        # 5ac190 <x86_effects_unknown+0x1c0>
 18e8bac:	0c 60                	or     $0x60,%al
 18e8bae:	62 f2 7d 08 7a c0    	vpbroadcastb %eax,%xmm0
 18e8bb4:	89 c8                	mov    %ecx,%eax
 18e8bb6:	c1 e0 04             	shl    $0x4,%eax
 18e8bb9:	09 c1                	or     %eax,%ecx
 18e8bbb:	0c 06                	or     $0x6,%al
 18e8bbd:	62 f2 7d 08 7a c8    	vpbroadcastb %eax,%xmm1
 18e8bc3:	62 f2 7d 09 7a c1    	vpbroadcastb %ecx,%xmm0{%k1}
 18e8bc9:	c5 f9 6c c1          	vpunpcklqdq %xmm1,%xmm0,%xmm0
 18e8bcd:	b8 10 00 00 00       	mov    $0x10,%eax
 18e8bd2:	b9 00 00 00 00       	mov    $0x0,%ecx
 18e8bd7:	48 8b 34 24          	mov    (%rsp),%rsi
 18e8bdb:	c4 c1 7b 92 cd       	kmovd  %r13d,%k1
 18e8be0:	4c 89 f7             	mov    %r14,%rdi
 18e8be3:	48 29 d0             	sub    %rdx,%rax
 18e8be6:	44 89 fa             	mov    %r15d,%edx
 18e8be9:	48 0f 43 c8          	cmovae %rax,%rcx
 18e8bed:	62 f2 7d 08 7a c9    	vpbroadcastb %ecx,%xmm1
 18e8bf3:	62 f3 75 08 3e 05 82 35 cc fe 05 	vpcmpnltub -0x133ca7e(%rip),%xmm1,%k0        # 5ac180 <x86_effects_unknown+0x1b0>
 18e8bfe:	c4 e2 79 78 0d b9 da c5 fe 	vpbroadcastb -0x13a2547(%rip),%xmm1        # 5466c0 <branch_sizing_patterns+0xa30>
 18e8c07:	48 8b 86 80 01 00 00 	mov    0x180(%rsi),%rax
 18e8c0e:	c5 fc 45 c9          	korw   %k1,%k0,%k1
 18e8c12:	62 f2 75 09 66 c0    	vpblendmb %xmm0,%xmm1,%xmm0{%k1}
 18e8c18:	c4 a1 79 7f 44 20 10 	vmovdqa %xmm0,0x10(%rax,%r12,1)
 18e8c1f:	e8 8c 30 01 00       	call   18fbcb0 <abi_finish>
 18e8c24:	49 ff c7             	inc    %r15
 18e8c27:	49 83 c4 10          	add    $0x10,%r12
 18e8c2b:	49 83 ff 40          	cmp    $0x40,%r15
 18e8c2f:	74 65                	je     18e8c96 <tier0_tables_open+0x1926>
 18e8c31:	48 8b 04 24          	mov    (%rsp),%rax
 18e8c35:	8b 40 48             	mov    0x48(%rax),%eax
 18e8c38:	49 39 c7             	cmp    %rax,%r15
 18e8c3b:	73 59                	jae    18e8c96 <tier0_tables_open+0x1926>
 18e8c3d:	48 8b 04 24          	mov    (%rsp),%rax
 18e8c41:	48 8b 00             	mov    (%rax),%rax
 18e8c44:	42 80 3c 38 00       	cmpb   $0x0,(%rax,%r15,1)
 18e8c49:	74 d9                	je     18e8c24 <tier0_tables_open+0x18b4>
 18e8c4b:	48 8b 34 24          	mov    (%rsp),%rsi
 18e8c4f:	4c 89 f7             	mov    %r14,%rdi
 18e8c52:	44 89 fa             	mov    %r15d,%edx
 18e8c55:	c5 f8 77             	vzeroupper
 18e8c58:	e8 23 2e 01 00       	call   18fba80 <abi_simple>
 18e8c5d:	89 c6                	mov    %eax,%esi
 18e8c5f:	c1 ee 10             	shr    $0x10,%esi
 18e8c62:	48 89 c1             	mov    %rax,%rcx
 18e8c65:	48 c1 e9 08          	shr    $0x8,%rcx
 18e8c69:	89 f7                	mov    %esi,%edi
 18e8c6b:	40 c0 e7 04          	shl    $0x4,%dil
 18e8c6f:	40 08 cf             	or     %cl,%dil
 18e8c72:	40 80 fe 07          	cmp    $0x7,%sil
 18e8c76:	40 0f b6 f7          	movzbl %dil,%esi
 18e8c7a:	0f 44 f5             	cmove  %ebp,%esi
 18e8c7d:	80 f9 07             	cmp    $0x7,%cl
 18e8c80:	0f 44 f5             	cmove  %ebp,%esi
 18e8c83:	3c 01                	cmp    $0x1,%al
 18e8c85:	0f 84 03 ff ff ff    	je     18e8b8e <tier0_tables_open+0x181e>
 18e8c8b:	62 f2 7d 08 7a c6    	vpbroadcastb %esi,%xmm0
 18e8c91:	e9 37 ff ff ff       	jmp    18e8bcd <tier0_tables_open+0x185d>
 18e8c96:	48 8b 04 24          	mov    (%rsp),%rax
 18e8c9a:	ba 04 1d 00 00       	mov    $0x1d04,%edx
 18e8c9f:	31 f6                	xor    %esi,%esi
 18e8ca1:	48 8d b8 60 02 00 00 	lea    0x260(%rax),%rdi
 18e8ca8:	c5 f8 77             	vzeroupper
 18e8cab:	e8 d0 11 eb fe       	call   799e80 <memset@plt>
 18e8cb0:	48 c7 44 24 68 00 00 00 00 	movq   $0x0,0x68(%rsp)
 18e8cb9:	48 8b 4c 24 68       	mov    0x68(%rsp),%rcx
 18e8cbe:	48 8d 05 db 5d 9d 00 	lea    0x9d5ddb(%rip),%rax        # 22beaa0 <tier0_record_shapes>
 18e8cc5:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
 18e8cc9:	80 3e 75             	cmpb   $0x75,(%rsi)
 18e8ccc:	75 09                	jne    18e8cd7 <tier0_tables_open+0x1967>
 18e8cce:	80 7e 01 3a          	cmpb   $0x3a,0x1(%rsi)
 18e8cd2:	0f 94 c0             	sete   %al
 18e8cd5:	eb 02                	jmp    18e8cd9 <tier0_tables_open+0x1969>
 18e8cd7:	31 c0                	xor    %eax,%eax
 18e8cd9:	48 6b 54 24 68 74    	imul   $0x74,0x68(%rsp),%rdx
 18e8cdf:	48 8b 0c 24          	mov    (%rsp),%rcx
 18e8ce3:	48 81 c1 60 02 00 00 	add    $0x260,%rcx
 18e8cea:	48 01 ca             	add    %rcx,%rdx
 18e8ced:	88 42 64             	mov    %al,0x64(%rdx)
 18e8cf0:	48 89 54 24 10       	mov    %rdx,0x10(%rsp)
 18e8cf5:	80 3e 61             	cmpb   $0x61,(%rsi)
 18e8cf8:	75 09                	jne    18e8d03 <tier0_tables_open+0x1993>
 18e8cfa:	80 7e 01 3a          	cmpb   $0x3a,0x1(%rsi)
 18e8cfe:	0f 94 c2             	sete   %dl
 18e8d01:	eb 02                	jmp    18e8d05 <tier0_tables_open+0x1995>
 18e8d03:	31 d2                	xor    %edx,%edx
 18e8d05:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
 18e8d0a:	41 b8 01 00 00 00    	mov    $0x1,%r8d
 18e8d10:	88 51 65             	mov    %dl,0x65(%rcx)
 18e8d13:	c7 41 60 01 00 00 00 	movl   $0x1,0x60(%rcx)
 18e8d1a:	8b 79 58             	mov    0x58(%rcx),%edi
 18e8d1d:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
 18e8d22:	48 83 ff 10          	cmp    $0x10,%rdi
 18e8d26:	0f 87 38 01 00 00    	ja     18e8e64 <tier0_tables_open+0x1af4>
 18e8d2c:	41 89 d1             	mov    %edx,%r9d
 18e8d2f:	41 08 c1             	or     %al,%r9b
 18e8d32:	45 0f b6 c9          	movzbl %r9b,%r9d
 18e8d36:	41 83 e1 01          	and    $0x1,%r9d
 18e8d3a:	4a 8d 34 4e          	lea    (%rsi,%r9,2),%rsi
 18e8d3e:	44 0f b6 14 37       	movzbl (%rdi,%rsi,1),%r10d
 18e8d43:	45 84 d2             	test   %r10b,%r10b
 18e8d46:	0f 84 18 01 00 00    	je     18e8e64 <tier0_tables_open+0x1af4>
 18e8d4c:	31 c0                	xor    %eax,%eax
 18e8d4e:	41 89 f9             	mov    %edi,%r9d
 18e8d51:	31 c9                	xor    %ecx,%ecx
 18e8d53:	41 80 c2 b7          	add    $0xb7,%r10b
 18e8d57:	bd 0a 00 00 00       	mov    $0xa,%ebp
 18e8d5c:	41 80 fa 2a          	cmp    $0x2a,%r10b
 18e8d60:	77 10                	ja     18e8d72 <tier0_tables_open+0x1a02>
 18e8d62:	45 0f b6 c2          	movzbl %r10b,%r8d
 18e8d66:	4c 8d 15 4f 18 c6 fe 	lea    -0x139e7b1(%rip),%r10        # 54a5bc <tier0_emit_int128.extensions+0x10>
 18e8d6d:	43 0f b6 2c 10       	movzbl (%r8,%r10,1),%ebp
 18e8d72:	4c 8d 05 87 3c cc fe 	lea    -0x133c379(%rip),%r8        # 5aca00 <tier0_class_bytes.bytes>
 18e8d79:	41 89 ea             	mov    %ebp,%r10d
 18e8d7c:	f6 c2 01             	test   $0x1,%dl
 18e8d7f:	ba 10 00 00 00       	mov    $0x10,%edx
 18e8d84:	4c 8b 7c 24 10       	mov    0x10(%rsp),%r15
 18e8d89:	41 bd 00 00 00 00    	mov    $0x0,%r13d
 18e8d8f:	47 0f b6 1c 02       	movzbl (%r10,%r8,1),%r11d
 18e8d94:	45 89 d8             	mov    %r11d,%r8d
 18e8d97:	44 0f 45 c2          	cmovne %edx,%r8d
 18e8d9b:	45 85 c9             	test   %r9d,%r9d
 18e8d9e:	45 0f 45 c3          	cmovne %r11d,%r8d
 18e8da2:	42 8d 54 00 ff       	lea    -0x1(%rax,%r8,1),%edx
 18e8da7:	44 89 c0             	mov    %r8d,%eax
 18e8daa:	f7 d8                	neg    %eax
 18e8dac:	21 d0                	and    %edx,%eax
 18e8dae:	41 80 7f 64 00       	cmpb   $0x0,0x64(%r15)
 18e8db3:	41 88 2c 3f          	mov    %bpl,(%r15,%rdi,1)
 18e8db7:	41 0f 45 c5          	cmovne %r13d,%eax
 18e8dbb:	45 31 e4             	xor    %r12d,%r12d
 18e8dbe:	41 89 44 bf 14       	mov    %eax,0x14(%r15,%rdi,4)
 18e8dc3:	41 0f b6 57 65       	movzbl 0x65(%r15),%edx
 18e8dc8:	41 8b 5f 60          	mov    0x60(%r15),%ebx
 18e8dcc:	84 d2                	test   %dl,%dl
 18e8dce:	41 0f 95 c4          	setne  %r12b
 18e8dd2:	45 85 c9             	test   %r9d,%r9d
 18e8dd5:	43 8d 2c a4          	lea    (%r12,%r12,4),%ebp
 18e8dd9:	41 0f 45 ed          	cmovne %r13d,%ebp
 18e8ddd:	44 01 d8             	add    %r11d,%eax
 18e8de0:	4c 8d 1d 89 16 c6 fe 	lea    -0x139e977(%rip),%r11        # 54a470 <tier0_program_class_type.types>
 18e8de7:	39 c8                	cmp    %ecx,%eax
 18e8de9:	0f 47 c8             	cmova  %eax,%ecx
 18e8dec:	41 39 d8             	cmp    %ebx,%r8d
 18e8def:	44 0f 46 c3          	cmovbe %ebx,%r8d
 18e8df3:	48 c1 e7 04          	shl    $0x4,%rdi
 18e8df7:	41 ff c1             	inc    %r9d
 18e8dfa:	45 89 47 60          	mov    %r8d,0x60(%r15)
 18e8dfe:	44 89 8c 3c b0 01 00 00 	mov    %r9d,0x1b0(%rsp,%rdi,1)
 18e8e06:	47 8b 14 93          	mov    (%r11,%r10,4),%r10d
 18e8e0a:	44 89 94 3c b4 01 00 00 	mov    %r10d,0x1b4(%rsp,%rdi,1)
 18e8e12:	c7 84 3c b8 01 00 00 ff ff ff ff 	movl   $0xffffffff,0x1b8(%rsp,%rdi,1)
 18e8e1d:	40 88 ac 3c bc 01 00 00 	mov    %bpl,0x1bc(%rsp,%rdi,1)
 18e8e25:	c6 84 3c bd 01 00 00 00 	movb   $0x0,0x1bd(%rsp,%rdi,1)
 18e8e2d:	66 c7 84 3c be 01 00 00 00 00 	movw   $0x0,0x1be(%rsp,%rdi,1)
 18e8e37:	45 8b 4f 58          	mov    0x58(%r15),%r9d
 18e8e3b:	41 ff c1             	inc    %r9d
 18e8e3e:	45 89 4f 58          	mov    %r9d,0x58(%r15)
 18e8e42:	41 83 f9 10          	cmp    $0x10,%r9d
 18e8e46:	77 11                	ja     18e8e59 <tier0_tables_open+0x1ae9>
 18e8e48:	46 0f b6 14 0e       	movzbl (%rsi,%r9,1),%r10d
 18e8e4d:	4c 89 cf             	mov    %r9,%rdi
 18e8e50:	45 84 d2             	test   %r10b,%r10b
 18e8e53:	0f 85 fa fe ff ff    	jne    18e8d53 <tier0_tables_open+0x19e3>
 18e8e59:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
 18e8e5e:	ff c9                	dec    %ecx
 18e8e60:	0f b6 40 64          	movzbl 0x64(%rax),%eax
 18e8e64:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
 18e8e69:	48 8b 14 24          	mov    (%rsp),%rdx
 18e8e6d:	44 01 c1             	add    %r8d,%ecx
 18e8e70:	41 f7 d8             	neg    %r8d
 18e8e73:	41 21 c8             	and    %ecx,%r8d
 18e8e76:	44 89 46 5c          	mov    %r8d,0x5c(%rsi)
 18e8e7a:	44 8b 62 48          	mov    0x48(%rdx),%r12d
 18e8e7e:	44 3b 62 4c          	cmp    0x4c(%rdx),%r12d
 18e8e82:	0f 84 ca 0c 00 00    	je     18e9b52 <tier0_tables_open+0x27e2>
 18e8e88:	48 8b 14 24          	mov    (%rsp),%rdx
 18e8e8c:	8b 8a a0 00 00 00    	mov    0xa0(%rdx),%ecx
 18e8e92:	3b 8a a4 00 00 00    	cmp    0xa4(%rdx),%ecx
 18e8e98:	0f 84 b4 0c 00 00    	je     18e9b52 <tier0_tables_open+0x27e2>
 18e8e9e:	48 8b 3c 24          	mov    (%rsp),%rdi
 18e8ea2:	0c 10                	or     $0x10,%al
 18e8ea4:	42 8d 34 e5 00 00 00 00 	lea    0x0(,%r12,8),%esi
 18e8eac:	89 74 24 40          	mov    %esi,0x40(%rsp)
 18e8eb0:	48 8b 17             	mov    (%rdi),%rdx
 18e8eb3:	42 88 04 22          	mov    %al,(%rdx,%r12,1)
 18e8eb7:	48 8b 57 08          	mov    0x8(%rdi),%rdx
 18e8ebb:	42 c6 04 22 00       	movb   $0x0,(%rdx,%r12,1)
 18e8ec0:	48 8b 57 10          	mov    0x10(%rdi),%rdx
 18e8ec4:	42 c6 04 22 00       	movb   $0x0,(%rdx,%r12,1)
 18e8ec9:	48 8b 57 18          	mov    0x18(%rdi),%rdx
 18e8ecd:	42 c6 04 22 00       	movb   $0x0,(%rdx,%r12,1)
 18e8ed2:	48 8b 57 20          	mov    0x20(%rdi),%rdx
 18e8ed6:	42 c7 04 a2 00 00 00 00 	movl   $0x0,(%rdx,%r12,4)
 18e8ede:	48 8b 57 28          	mov    0x28(%rdi),%rdx
 18e8ee2:	42 89 0c a2          	mov    %ecx,(%rdx,%r12,4)
 18e8ee6:	48 8b 57 30          	mov    0x30(%rdi),%rdx
 18e8eea:	4a c7 04 e2 00 00 00 00 	movq   $0x0,(%rdx,%r12,8)
 18e8ef2:	48 8b 57 38          	mov    0x38(%rdi),%rdx
 18e8ef6:	4a c7 04 e2 00 00 00 00 	movq   $0x0,(%rdx,%r12,8)
 18e8efe:	48 8b 57 40          	mov    0x40(%rdi),%rdx
 18e8f02:	4a c7 04 e2 00 00 00 00 	movq   $0x0,(%rdx,%r12,8)
 18e8f0a:	ff 47 48             	incl   0x48(%rdi)
 18e8f0d:	48 8b 57 60          	mov    0x60(%rdi),%rdx
 18e8f11:	89 34 8a             	mov    %esi,(%rdx,%rcx,4)
 18e8f14:	48 8b 54 24 68       	mov    0x68(%rsp),%rdx
 18e8f19:	48 8b 77 68          	mov    0x68(%rdi),%rsi
 18e8f1d:	81 c2 e8 03 00 00    	add    $0x3e8,%edx
 18e8f23:	89 14 8e             	mov    %edx,(%rsi,%rcx,4)
 18e8f26:	48 8b 77 70          	mov    0x70(%rdi),%rsi
 18e8f2a:	c7 04 8e 00 00 00 00 	movl   $0x0,(%rsi,%rcx,4)
 18e8f31:	48 8b 77 78          	mov    0x78(%rdi),%rsi
 18e8f35:	c7 04 8e 00 00 00 00 	movl   $0x0,(%rsi,%rcx,4)
 18e8f3c:	48 8b b7 80 00 00 00 	mov    0x80(%rdi),%rsi
 18e8f43:	c7 04 8e 00 00 00 00 	movl   $0x0,(%rsi,%rcx,4)
 18e8f4a:	48 8b b7 88 00 00 00 	mov    0x88(%rdi),%rsi
 18e8f51:	c6 04 0e 00          	movb   $0x0,(%rsi,%rcx,1)
 18e8f55:	48 8b b7 90 00 00 00 	mov    0x90(%rdi),%rsi
 18e8f5c:	c6 04 0e 00          	movb   $0x0,(%rsi,%rcx,1)
 18e8f60:	48 8b b7 98 00 00 00 	mov    0x98(%rdi),%rsi
 18e8f67:	c6 04 0e 00          	movb   $0x0,(%rsi,%rcx,1)
 18e8f6b:	ff 87 a0 00 00 00    	incl   0xa0(%rdi)
 18e8f71:	48 8b b7 08 01 00 00 	mov    0x108(%rdi),%rsi
 18e8f78:	48 85 f6             	test   %rsi,%rsi
 18e8f7b:	74 76                	je     18e8ff3 <tier0_tables_open+0x1c83>
 18e8f7d:	80 7e 4c 00          	cmpb   $0x0,0x4c(%rsi)
 18e8f81:	75 70                	jne    18e8ff3 <tier0_tables_open+0x1c83>
 18e8f83:	8b 7e 08             	mov    0x8(%rsi),%edi
 18e8f86:	3b 7e 0c             	cmp    0xc(%rsi),%edi
 18e8f89:	75 06                	jne    18e8f91 <tier0_tables_open+0x1c21>
 18e8f8b:	c6 46 4c 01          	movb   $0x1,0x4c(%rsi)
 18e8f8f:	eb 62                	jmp    18e8ff3 <tier0_tables_open+0x1c83>
 18e8f91:	44 8d 4f 01          	lea    0x1(%rdi),%r9d
 18e8f95:	44 8b 46 38          	mov    0x38(%rsi),%r8d
 18e8f99:	c6 46 4c 00          	movb   $0x0,0x4c(%rsi)
 18e8f9d:	48 6b ff 38          	imul   $0x38,%rdi,%rdi
 18e8fa1:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 18e8fa5:	44 89 4e 08          	mov    %r9d,0x8(%rsi)
 18e8fa9:	4c 8b 0e             	mov    (%rsi),%r9
 18e8fac:	4c 8b 56 30          	mov    0x30(%rsi),%r10
 18e8fb0:	ff 46 34             	incl   0x34(%rsi)
 18e8fb3:	8b 74 24 40          	mov    0x40(%rsp),%esi
 18e8fb7:	4d 89 14 39          	mov    %r10,(%r9,%rdi,1)
 18e8fbb:	41 c6 44 39 08 02    	movb   $0x2,0x8(%r9,%rdi,1)
 18e8fc1:	41 88 44 39 09       	mov    %al,0x9(%r9,%rdi,1)
 18e8fc6:	c4 c1 7a 7f 44 39 0a 	vmovdqu %xmm0,0xa(%r9,%rdi,1)
 18e8fcd:	49 c7 44 39 18 00 00 00 00 	movq   $0x0,0x18(%r9,%rdi,1)
 18e8fd6:	41 89 74 39 20       	mov    %esi,0x20(%r9,%rdi,1)
 18e8fdb:	41 89 54 39 24       	mov    %edx,0x24(%r9,%rdi,1)
 18e8fe0:	45 89 44 39 28       	mov    %r8d,0x28(%r9,%rdi,1)
 18e8fe5:	41 89 4c 39 2c       	mov    %ecx,0x2c(%r9,%rdi,1)
 18e8fea:	49 c7 44 39 30 00 00 00 00 	movq   $0x0,0x30(%r9,%rdi,1)
 18e8ff3:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
 18e8ff8:	8b 4c 24 40          	mov    0x40(%rsp),%ecx
 18e8ffc:	89 48 68             	mov    %ecx,0x68(%rax)
 18e8fff:	85 c9                	test   %ecx,%ecx
 18e9001:	0f 84 c1 0b 00 00    	je     18e9bc8 <tier0_tables_open+0x2858>
 18e9007:	48 8b 04 24          	mov    (%rsp),%rax
 18e900b:	41 81 e4 ff ff ff 1f 	and    $0x1fffffff,%r12d
 18e9012:	41 ba 0d 00 00 00    	mov    $0xd,%r10d
 18e9018:	8b 58 48             	mov    0x48(%rax),%ebx
 18e901b:	41 39 dc             	cmp    %ebx,%r12d
 18e901e:	0f 83 7a 0b 00 00    	jae    18e9b9e <tier0_tables_open+0x282e>
 18e9024:	48 8b 04 24          	mov    (%rsp),%rax
 18e9028:	48 8b 30             	mov    (%rax),%rsi
 18e902b:	42 0f b6 04 26       	movzbl (%rsi,%r12,1),%eax
 18e9030:	24 fe                	and    $0xfe,%al
 18e9032:	3c 10                	cmp    $0x10,%al
 18e9034:	0f 85 64 0b 00 00    	jne    18e9b9e <tier0_tables_open+0x282e>
 18e903a:	48 8b 04 24          	mov    (%rsp),%rax
 18e903e:	48 8b 40 10          	mov    0x10(%rax),%rax
 18e9042:	42 f6 04 20 24       	testb  $0x24,(%rax,%r12,1)
 18e9047:	0f 85 51 0b 00 00    	jne    18e9b9e <tier0_tables_open+0x282e>
 18e904d:	49 89 c7             	mov    %rax,%r15
 18e9050:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
 18e9055:	8b 48 58             	mov    0x58(%rax),%ecx
 18e9058:	48 8b 04 24          	mov    (%rsp),%rax
 18e905c:	8b 90 e0 00 00 00    	mov    0xe0(%rax),%edx
 18e9062:	8b 80 e4 00 00 00    	mov    0xe4(%rax),%eax
 18e9068:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
 18e906d:	ff c9                	dec    %ecx
 18e906f:	29 d0                	sub    %edx,%eax
 18e9071:	89 94 24 80 00 00 00 	mov    %edx,0x80(%rsp)
 18e9078:	39 c1                	cmp    %eax,%ecx
 18e907a:	0f 83 e1 01 00 00    	jae    18e9261 <tier0_tables_open+0x1ef1>
 18e9080:	41 b8 01 00 00 00    	mov    $0x1,%r8d
 18e9086:	4c 8d 8c 24 bc 01 00 00 	lea    0x1bc(%rsp),%r9
 18e908e:	c6 44 24 20 20       	movb   $0x20,0x20(%rsp)
 18e9093:	45 8b 59 f8          	mov    -0x8(%r9),%r11d
 18e9097:	41 ba 02 00 00 00    	mov    $0x2,%r10d
 18e909d:	45 89 dd             	mov    %r11d,%r13d
 18e90a0:	41 c1 ed 03          	shr    $0x3,%r13d
 18e90a4:	0f 84 f4 0a 00 00    	je     18e9b9e <tier0_tables_open+0x282e>
 18e90aa:	41 39 dd             	cmp    %ebx,%r13d
 18e90ad:	0f 83 eb 0a 00 00    	jae    18e9b9e <tier0_tables_open+0x282e>
 18e90b3:	42 0f b6 0c 2e       	movzbl (%rsi,%r13,1),%ecx
 18e90b8:	84 c9                	test   %cl,%cl
 18e90ba:	0f 84 de 0a 00 00    	je     18e9b9e <tier0_tables_open+0x282e>
 18e90c0:	89 cd                	mov    %ecx,%ebp
 18e90c2:	80 f9 0f             	cmp    $0xf,%cl
 18e90c5:	75 13                	jne    18e90da <tier0_tables_open+0x1d6a>
 18e90c7:	48 8b 04 24          	mov    (%rsp),%rax
 18e90cb:	48 8b 40 20          	mov    0x20(%rax),%rax
 18e90cf:	42 8b 04 a8          	mov    (%rax,%r13,4),%eax
 18e90d3:	c1 e8 03             	shr    $0x3,%eax
 18e90d6:	0f b6 2c 06          	movzbl (%rsi,%rax,1),%ebp
 18e90da:	41 ba 0e 00 00 00    	mov    $0xe,%r10d
 18e90e0:	40 80 fd 01          	cmp    $0x1,%bpl
 18e90e4:	0f 84 b4 0a 00 00    	je     18e9b9e <tier0_tables_open+0x282e>
 18e90ea:	40 0f b6 c5          	movzbl %bpl,%eax
 18e90ee:	83 f8 0b             	cmp    $0xb,%eax
 18e90f1:	0f 84 a7 0a 00 00    	je     18e9b9e <tier0_tables_open+0x282e>
 18e90f7:	43 0f b6 14 2f       	movzbl (%r15,%r13,1),%edx
 18e90fc:	f6 c2 08             	test   $0x8,%dl
 18e90ff:	0f 85 99 0a 00 00    	jne    18e9b9e <tier0_tables_open+0x282e>
 18e9105:	80 f9 0f             	cmp    $0xf,%cl
 18e9108:	75 2a                	jne    18e9134 <tier0_tables_open+0x1dc4>
 18e910a:	48 8b 04 24          	mov    (%rsp),%rax
 18e910e:	48 8b 40 20          	mov    0x20(%rax),%rax
 18e9112:	42 8b 04 a8          	mov    (%rax,%r13,4),%eax
 18e9116:	c1 e8 03             	shr    $0x3,%eax
 18e9119:	41 0f b6 14 07       	movzbl (%r15,%rax,1),%edx
 18e911e:	41 8b 41 fc          	mov    -0x4(%r9),%eax
 18e9122:	45 31 d2             	xor    %r10d,%r10d
 18e9125:	f6 c2 04             	test   $0x4,%dl
 18e9128:	74 16                	je     18e9140 <tier0_tables_open+0x1dd0>
 18e912a:	45 85 d2             	test   %r10d,%r10d
 18e912d:	74 53                	je     18e9182 <tier0_tables_open+0x1e12>
 18e912f:	e9 ce 00 00 00       	jmp    18e9202 <tier0_tables_open+0x1e92>
 18e9134:	41 8b 41 fc          	mov    -0x4(%r9),%eax
 18e9138:	45 31 d2             	xor    %r10d,%r10d
 18e913b:	f6 c2 04             	test   $0x4,%dl
 18e913e:	75 ea                	jne    18e912a <tier0_tables_open+0x1dba>
 18e9140:	83 f8 ff             	cmp    $0xffffffff,%eax
 18e9143:	0f 95 c2             	setne  %dl
 18e9146:	4c 39 44 24 08       	cmp    %r8,0x8(%rsp)
 18e914b:	40 0f 95 c7          	setne  %dil
 18e914f:	40 80 fd 09          	cmp    $0x9,%bpl
 18e9153:	41 0f 95 c2          	setne  %r10b
 18e9157:	40 08 d7             	or     %dl,%dil
 18e915a:	ba 0e 00 00 00       	mov    $0xe,%edx
 18e915f:	44 08 d7             	or     %r10b,%dil
 18e9162:	41 ba 00 00 00 00    	mov    $0x0,%r10d
 18e9168:	44 0f 45 d2          	cmovne %edx,%r10d
 18e916c:	40 80 f7 01          	xor    $0x1,%dil
 18e9170:	40 c0 e7 06          	shl    $0x6,%dil
 18e9174:	40 08 7c 24 20       	or     %dil,0x20(%rsp)
 18e9179:	45 85 d2             	test   %r10d,%r10d
 18e917c:	0f 85 80 00 00 00    	jne    18e9202 <tier0_tables_open+0x1e92>
 18e9182:	83 f8 ff             	cmp    $0xffffffff,%eax
 18e9185:	74 7b                	je     18e9202 <tier0_tables_open+0x1e92>
 18e9187:	80 f9 0f             	cmp    $0xf,%cl
 18e918a:	75 18                	jne    18e91a4 <tier0_tables_open+0x1e34>
 18e918c:	48 8b 0c 24          	mov    (%rsp),%rcx
 18e9190:	48 8b 49 20          	mov    0x20(%rcx),%rcx
 18e9194:	46 8b 1c a9          	mov    (%rcx,%r13,4),%r11d
 18e9198:	45 89 dd             	mov    %r11d,%r13d
 18e919b:	41 c1 ed 03          	shr    $0x3,%r13d
 18e919f:	42 0f b6 0c 2e       	movzbl (%rsi,%r13,1),%ecx
 18e91a4:	80 f9 12             	cmp    $0x12,%cl
 18e91a7:	75 21                	jne    18e91ca <tier0_tables_open+0x1e5a>
 18e91a9:	43 f6 04 2f 04       	testb  $0x4,(%r15,%r13,1)
 18e91ae:	0f 84 e4 09 00 00    	je     18e9b98 <tier0_tables_open+0x2828>
 18e91b4:	48 8b 0c 24          	mov    (%rsp),%rcx
 18e91b8:	48 8b 49 20          	mov    0x20(%rcx),%rcx
 18e91bc:	46 8b 1c a9          	mov    (%rcx,%r13,4),%r11d
 18e91c0:	44 89 d9             	mov    %r11d,%ecx
 18e91c3:	c1 e9 03             	shr    $0x3,%ecx
 18e91c6:	0f b6 0c 0e          	movzbl (%rsi,%rcx,1),%ecx
 18e91ca:	41 ba 0f 00 00 00    	mov    $0xf,%r10d
 18e91d0:	80 f9 05             	cmp    $0x5,%cl
 18e91d3:	74 37                	je     18e920c <tier0_tables_open+0x1e9c>
 18e91d5:	0f b6 c9             	movzbl %cl,%ecx
 18e91d8:	83 f9 02             	cmp    $0x2,%ecx
 18e91db:	0f 85 bd 09 00 00    	jne    18e9b9e <tier0_tables_open+0x282e>
 18e91e1:	41 83 e3 f8          	and    $0xfffffff8,%r11d
 18e91e5:	b9 01 00 00 00       	mov    $0x1,%ecx
 18e91ea:	41 83 fb 10          	cmp    $0x10,%r11d
 18e91ee:	74 35                	je     18e9225 <tier0_tables_open+0x1eb5>
 18e91f0:	48 8b 0c 24          	mov    (%rsp),%rcx
 18e91f4:	48 8b 49 38          	mov    0x38(%rcx),%rcx
 18e91f8:	4a 8b 0c 19          	mov    (%rcx,%r11,1),%rcx
 18e91fc:	48 c1 e1 03          	shl    $0x3,%rcx
 18e9200:	eb 1a                	jmp    18e921c <tier0_tables_open+0x1eac>
 18e9202:	45 85 d2             	test   %r10d,%r10d
 18e9205:	74 37                	je     18e923e <tier0_tables_open+0x1ece>
 18e9207:	e9 92 09 00 00       	jmp    18e9b9e <tier0_tables_open+0x282e>
 18e920c:	48 8b 0c 24          	mov    (%rsp),%rcx
 18e9210:	41 83 e3 f8          	and    $0xfffffff8,%r11d
 18e9214:	48 8b 49 30          	mov    0x30(%rcx),%rcx
 18e9218:	4a 8b 0c 19          	mov    (%rcx,%r11,1),%rcx
 18e921c:	48 85 c9             	test   %rcx,%rcx
 18e921f:	0f 84 79 09 00 00    	je     18e9b9e <tier0_tables_open+0x282e>
 18e9225:	48 39 c1             	cmp    %rax,%rcx
 18e9228:	0f 82 70 09 00 00    	jb     18e9b9e <tier0_tables_open+0x282e>
 18e922e:	48 85 c0             	test   %rax,%rax
 18e9231:	75 0b                	jne    18e923e <tier0_tables_open+0x1ece>
 18e9233:	41 83 79 f4 00       	cmpl   $0x0,-0xc(%r9)
 18e9238:	0f 85 60 09 00 00    	jne    18e9b9e <tier0_tables_open+0x282e>
 18e923e:	41 0f b6 01          	movzbl (%r9),%eax
 18e9242:	4c 3b 44 24 08       	cmp    0x8(%rsp),%r8
 18e9247:	73 0f                	jae    18e9258 <tier0_tables_open+0x1ee8>
 18e9249:	49 ff c0             	inc    %r8
 18e924c:	49 83 c1 10          	add    $0x10,%r9
 18e9250:	3c 22                	cmp    $0x22,%al
 18e9252:	0f 82 3b fe ff ff    	jb     18e9093 <tier0_tables_open+0x1d23>
 18e9258:	3c 22                	cmp    $0x22,%al
 18e925a:	72 14                	jb     18e9270 <tier0_tables_open+0x1f00>
 18e925c:	e9 26 0a 00 00       	jmp    18e9c87 <tier0_tables_open+0x2917>
 18e9261:	c6 44 24 20 20       	movb   $0x20,0x20(%rsp)
 18e9266:	39 44 24 08          	cmp    %eax,0x8(%rsp)
 18e926a:	0f 87 20 09 00 00    	ja     18e9b90 <tier0_tables_open+0x2820>
 18e9270:	48 8b 04 24          	mov    (%rsp),%rax
 18e9274:	83 7c 24 08 00       	cmpl   $0x0,0x8(%rsp)
 18e9279:	48 8b 40 28          	mov    0x28(%rax),%rax
 18e927d:	46 8b 3c a0          	mov    (%rax,%r12,4),%r15d
 18e9281:	8b 84 24 80 00 00 00 	mov    0x80(%rsp),%eax
 18e9288:	0f 84 bd 01 00 00    	je     18e944b <tier0_tables_open+0x20db>
 18e928e:	83 7c 24 08 01       	cmpl   $0x1,0x8(%rsp)
 18e9293:	75 07                	jne    18e929c <tier0_tables_open+0x1f2c>
 18e9295:	31 c0                	xor    %eax,%eax
 18e9297:	e9 18 01 00 00       	jmp    18e93b4 <tier0_tables_open+0x2044>
 18e929c:	8b 84 24 80 00 00 00 	mov    0x80(%rsp),%eax
 18e92a3:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
 18e92a8:	83 e1 fe             	and    $0xfffffffe,%ecx
 18e92ab:	48 8d b4 24 cd 01 00 00 	lea    0x1cd(%rsp),%rsi
 18e92b3:	89 c2                	mov    %eax,%edx
 18e92b5:	31 c0                	xor    %eax,%eax
 18e92b7:	48 8b 1c 24          	mov    (%rsp),%rbx
 18e92bb:	8b 7e e3             	mov    -0x1d(%rsi),%edi
 18e92be:	44 8b 46 eb          	mov    -0x15(%rsi),%r8d
 18e92c2:	41 89 d3             	mov    %edx,%r11d
 18e92c5:	41 bd 00 00 00 00    	mov    $0x0,%r13d
 18e92cb:	4c 8b 93 b0 00 00 00 	mov    0xb0(%rbx),%r10
 18e92d2:	41 83 f8 ff          	cmp    $0xffffffff,%r8d
 18e92d6:	45 0f 44 c5          	cmove  %r13d,%r8d
 18e92da:	41 0f 95 c1          	setne  %r9b
 18e92de:	45 00 c9             	add    %r9b,%r9b
 18e92e1:	43 89 3c 9a          	mov    %edi,(%r10,%r11,4)
 18e92e5:	8b 7e e7             	mov    -0x19(%rsi),%edi
 18e92e8:	4c 8b 93 b8 00 00 00 	mov    0xb8(%rbx),%r10
 18e92ef:	43 89 3c 9a          	mov    %edi,(%r10,%r11,4)
 18e92f3:	48 8b bb c0 00 00 00 	mov    0xc0(%rbx),%rdi
 18e92fa:	46 89 04 9f          	mov    %r8d,(%rdi,%r11,4)
 18e92fe:	0f b6 7e ef          	movzbl -0x11(%rsi),%edi
 18e9302:	4c 8b 83 c8 00 00 00 	mov    0xc8(%rbx),%r8
 18e9309:	43 88 3c 18          	mov    %dil,(%r8,%r11,1)
 18e930d:	44 0a 4e f0          	or     -0x10(%rsi),%r9b
 18e9311:	48 8b bb d0 00 00 00 	mov    0xd0(%rbx),%rdi
 18e9318:	46 88 0c 1f          	mov    %r9b,(%rdi,%r11,1)
 18e931c:	44 8d 4a 01          	lea    0x1(%rdx),%r9d
 18e9320:	48 8b bb d8 00 00 00 	mov    0xd8(%rbx),%rdi
 18e9327:	4a c7 04 df 00 00 00 00 	movq   $0x0,(%rdi,%r11,8)
 18e932f:	8b 7e f3             	mov    -0xd(%rsi),%edi
 18e9332:	4c 8b 9b b0 00 00 00 	mov    0xb0(%rbx),%r11
 18e9339:	44 8b 46 fb          	mov    -0x5(%rsi),%r8d
 18e933d:	43 89 3c 8b          	mov    %edi,(%r11,%r9,4)
 18e9341:	41 83 f8 ff          	cmp    $0xffffffff,%r8d
 18e9345:	8b 7e f7             	mov    -0x9(%rsi),%edi
 18e9348:	4c 8b 9b b8 00 00 00 	mov    0xb8(%rbx),%r11
 18e934f:	45 0f 44 c5          	cmove  %r13d,%r8d
 18e9353:	41 0f 95 c2          	setne  %r10b
 18e9357:	48 83 c0 02          	add    $0x2,%rax
 18e935b:	83 c2 02             	add    $0x2,%edx
 18e935e:	45 00 d2             	add    %r10b,%r10b
 18e9361:	43 89 3c 8b          	mov    %edi,(%r11,%r9,4)
 18e9365:	48 8b bb c0 00 00 00 	mov    0xc0(%rbx),%rdi
 18e936c:	46 89 04 8f          	mov    %r8d,(%rdi,%r9,4)
 18e9370:	0f b6 7e ff          	movzbl -0x1(%rsi),%edi
 18e9374:	4c 8b 83 c8 00 00 00 	mov    0xc8(%rbx),%r8
 18e937b:	43 88 3c 08          	mov    %dil,(%r8,%r9,1)
 18e937f:	44 0a 16             	or     (%rsi),%r10b
 18e9382:	48 8b bb d0 00 00 00 	mov    0xd0(%rbx),%rdi
 18e9389:	48 83 c6 20          	add    $0x20,%rsi
 18e938d:	46 88 14 0f          	mov    %r10b,(%rdi,%r9,1)
 18e9391:	48 8b bb d8 00 00 00 	mov    0xd8(%rbx),%rdi
 18e9398:	4a c7 04 cf 00 00 00 00 	movq   $0x0,(%rdi,%r9,8)
 18e93a0:	48 39 c1             	cmp    %rax,%rcx
 18e93a3:	0f 85 0e ff ff ff    	jne    18e92b7 <tier0_tables_open+0x1f47>
 18e93a9:	f6 44 24 08 01       	testb  $0x1,0x8(%rsp)
 18e93ae:	0f 84 8d 00 00 00    	je     18e9441 <tier0_tables_open+0x20d1>
 18e93b4:	4c 8b 0c 24          	mov    (%rsp),%r9
 18e93b8:	48 89 c1             	mov    %rax,%rcx
 18e93bb:	48 c1 e1 04          	shl    $0x4,%rcx
 18e93bf:	03 84 24 80 00 00 00 	add    0x80(%rsp),%eax
 18e93c6:	8b 94 0c b0 01 00 00 	mov    0x1b0(%rsp,%rcx,1),%edx
 18e93cd:	8b b4 0c b8 01 00 00 	mov    0x1b8(%rsp,%rcx,1),%esi
 18e93d4:	4d 8b 81 b0 00 00 00 	mov    0xb0(%r9),%r8
 18e93db:	83 fe ff             	cmp    $0xffffffff,%esi
 18e93de:	40 0f 95 c7          	setne  %dil
 18e93e2:	41 89 14 80          	mov    %edx,(%r8,%rax,4)
 18e93e6:	8b 94 0c b4 01 00 00 	mov    0x1b4(%rsp,%rcx,1),%edx
 18e93ed:	4d 8b 81 b8 00 00 00 	mov    0xb8(%r9),%r8
 18e93f4:	41 89 14 80          	mov    %edx,(%r8,%rax,4)
 18e93f8:	ba 00 00 00 00       	mov    $0x0,%edx
 18e93fd:	0f 44 f2             	cmove  %edx,%esi
 18e9400:	49 8b 91 c0 00 00 00 	mov    0xc0(%r9),%rdx
 18e9407:	40 00 ff             	add    %dil,%dil
 18e940a:	89 34 82             	mov    %esi,(%rdx,%rax,4)
 18e940d:	0f b6 94 0c bc 01 00 00 	movzbl 0x1bc(%rsp,%rcx,1),%edx
 18e9415:	49 8b b1 c8 00 00 00 	mov    0xc8(%r9),%rsi
 18e941c:	88 14 06             	mov    %dl,(%rsi,%rax,1)
 18e941f:	40 0a bc 0c bd 01 00 00 	or     0x1bd(%rsp,%rcx,1),%dil
 18e9427:	49 8b 91 d0 00 00 00 	mov    0xd0(%r9),%rdx
 18e942e:	40 88 3c 02          	mov    %dil,(%rdx,%rax,1)
 18e9432:	49 8b 89 d8 00 00 00 	mov    0xd8(%r9),%rcx
 18e9439:	48 c7 04 c1 00 00 00 00 	movq   $0x0,(%rcx,%rax,8)
 18e9441:	48 8b 04 24          	mov    (%rsp),%rax
 18e9445:	8b 80 e0 00 00 00    	mov    0xe0(%rax),%eax
 18e944b:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
 18e9450:	48 8b 0c 24          	mov    (%rsp),%rcx
 18e9454:	8b b4 24 80 00 00 00 	mov    0x80(%rsp),%esi
 18e945b:	01 d0                	add    %edx,%eax
 18e945d:	89 81 e0 00 00 00    	mov    %eax,0xe0(%rcx)
 18e9463:	48 8b 41 70          	mov    0x70(%rcx),%rax
 18e9467:	42 89 34 b8          	mov    %esi,(%rax,%r15,4)
 18e946b:	48 8b 41 78          	mov    0x78(%rcx),%rax
 18e946f:	42 89 14 b8          	mov    %edx,(%rax,%r15,4)
 18e9473:	0f b6 54 24 20       	movzbl 0x20(%rsp),%edx
 18e9478:	48 8b 81 88 00 00 00 	mov    0x88(%rcx),%rax
 18e947f:	42 c6 04 38 00       	movb   $0x0,(%rax,%r15,1)
 18e9484:	48 8b 81 90 00 00 00 	mov    0x90(%rcx),%rax
 18e948b:	42 c6 04 38 00       	movb   $0x0,(%rax,%r15,1)
 18e9490:	48 8b 81 98 00 00 00 	mov    0x98(%rcx),%rax
 18e9497:	42 c6 04 38 00       	movb   $0x0,(%rax,%r15,1)
 18e949c:	48 8b 41 10          	mov    0x10(%rcx),%rax
 18e94a0:	42 08 14 20          	or     %dl,(%rax,%r12,1)
 18e94a4:	4c 8b a9 08 01 00 00 	mov    0x108(%rcx),%r13
 18e94ab:	4d 85 ed             	test   %r13,%r13
 18e94ae:	0f 84 e4 00 00 00    	je     18e9598 <tier0_tables_open+0x2228>
 18e94b4:	41 80 7d 4c 00       	cmpb   $0x0,0x4c(%r13)
 18e94b9:	0f 85 d9 00 00 00    	jne    18e9598 <tier0_tables_open+0x2228>
 18e94bf:	41 8b 45 08          	mov    0x8(%r13),%eax
 18e94c3:	41 3b 45 0c          	cmp    0xc(%r13),%eax
 18e94c7:	75 0a                	jne    18e94d3 <tier0_tables_open+0x2163>
 18e94c9:	41 c6 45 4c 01       	movb   $0x1,0x4c(%r13)
 18e94ce:	e9 c5 00 00 00       	jmp    18e9598 <tier0_tables_open+0x2228>
 18e94d3:	41 8b 6d 28          	mov    0x28(%r13),%ebp
 18e94d7:	41 8b 4d 2c          	mov    0x2c(%r13),%ecx
 18e94db:	29 e9                	sub    %ebp,%ecx
 18e94dd:	39 4c 24 08          	cmp    %ecx,0x8(%rsp)
 18e94e1:	41 0f 97 45 4c       	seta   0x4c(%r13)
 18e94e6:	0f 87 ac 00 00 00    	ja     18e9598 <tier0_tables_open+0x2228>
 18e94ec:	c4 c1 7b 10 45 30    	vmovsd 0x30(%r13),%xmm0
 18e94f2:	41 ff 45 34          	incl   0x34(%r13)
 18e94f6:	83 7c 24 08 00       	cmpl   $0x0,0x8(%rsp)
 18e94fb:	c5 f8 29 84 24 80 00 00 00 	vmovaps %xmm0,0x80(%rsp)
 18e9504:	74 2e                	je     18e9534 <tier0_tables_open+0x21c4>
 18e9506:	48 8b 5c 24 08       	mov    0x8(%rsp),%rbx
 18e950b:	48 89 ef             	mov    %rbp,%rdi
 18e950e:	48 c1 e7 04          	shl    $0x4,%rdi
 18e9512:	49 03 7d 20          	add    0x20(%r13),%rdi
 18e9516:	48 8d b4 24 b0 01 00 00 	lea    0x1b0(%rsp),%rsi
 18e951e:	48 89 da             	mov    %rbx,%rdx
 18e9521:	48 c1 e2 04          	shl    $0x4,%rdx
 18e9525:	e8 76 0a eb fe       	call   799fa0 <memcpy@plt>
 18e952a:	41 01 5d 28          	add    %ebx,0x28(%r13)
 18e952e:	41 8b 45 08          	mov    0x8(%r13),%eax
 18e9532:	eb 02                	jmp    18e9536 <tier0_tables_open+0x21c6>
 18e9534:	31 ed                	xor    %ebp,%ebp
 18e9536:	c5 f9 6f 84 24 80 00 00 00 	vmovdqa 0x80(%rsp),%xmm0
 18e953f:	8d 50 01             	lea    0x1(%rax),%edx
 18e9542:	49 8b 4d 00          	mov    0x0(%r13),%rcx
 18e9546:	8b 74 24 40          	mov    0x40(%rsp),%esi
 18e954a:	89 c0                	mov    %eax,%eax
 18e954c:	48 6b c0 38          	imul   $0x38,%rax,%rax
 18e9550:	41 89 55 08          	mov    %edx,0x8(%r13)
 18e9554:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
 18e9559:	c5 f9 d6 04 01       	vmovq  %xmm0,(%rcx,%rax,1)
 18e955e:	c6 44 01 08 03       	movb   $0x3,0x8(%rcx,%rax,1)
 18e9563:	48 c7 44 01 09 00 00 00 00 	movq   $0x0,0x9(%rcx,%rax,1)
 18e956c:	48 c7 44 01 10 00 00 00 00 	movq   $0x0,0x10(%rcx,%rax,1)
 18e9575:	89 6c 01 18          	mov    %ebp,0x18(%rcx,%rax,1)
 18e9579:	89 54 01 1c          	mov    %edx,0x1c(%rcx,%rax,1)
 18e957d:	89 74 01 20          	mov    %esi,0x20(%rcx,%rax,1)
 18e9581:	48 c7 44 01 24 00 00 00 00 	movq   $0x0,0x24(%rcx,%rax,1)
 18e958a:	44 89 7c 01 2c       	mov    %r15d,0x2c(%rcx,%rax,1)
 18e958f:	48 c7 44 01 30 00 00 00 00 	movq   $0x0,0x30(%rcx,%rax,1)
 18e9598:	48 8b 0c 24          	mov    (%rsp),%rcx
 18e959c:	b8 0d 00 00 00       	mov    $0xd,%eax
 18e95a1:	44 3b 61 48          	cmp    0x48(%rcx),%r12d
 18e95a5:	0f 83 31 06 00 00    	jae    18e9bdc <tier0_tables_open+0x286c>
 18e95ab:	48 8b 0c 24          	mov    (%rsp),%rcx
 18e95af:	48 8b 09             	mov    (%rcx),%rcx
 18e95b2:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
 18e95b7:	42 0f b6 0c 21       	movzbl (%rcx,%r12,1),%ecx
 18e95bc:	84 c9                	test   %cl,%cl
 18e95be:	0f 84 18 06 00 00    	je     18e9bdc <tier0_tables_open+0x286c>
 18e95c4:	80 e1 fe             	and    $0xfe,%cl
 18e95c7:	80 f9 10             	cmp    $0x10,%cl
 18e95ca:	0f 85 0c 06 00 00    	jne    18e9bdc <tier0_tables_open+0x286c>
 18e95d0:	48 8b 0c 24          	mov    (%rsp),%rcx
 18e95d4:	48 8b 49 10          	mov    0x10(%rcx),%rcx
 18e95d8:	42 0f b6 0c 21       	movzbl (%rcx,%r12,1),%ecx
 18e95dd:	80 e1 24             	and    $0x24,%cl
 18e95e0:	80 f9 20             	cmp    $0x20,%cl
 18e95e3:	0f 85 f3 05 00 00    	jne    18e9bdc <tier0_tables_open+0x286c>
 18e95e9:	48 8b 3c 24          	mov    (%rsp),%rdi
 18e95ed:	be ff ff ff ff       	mov    $0xffffffff,%esi
 18e95f2:	bb 00 00 00 00       	mov    $0x0,%ebx
 18e95f7:	48 8b 47 28          	mov    0x28(%rdi),%rax
 18e95fb:	48 8b 8f 90 00 00 00 	mov    0x90(%rdi),%rcx
 18e9602:	46 8b 04 a0          	mov    (%rax,%r12,4),%r8d
 18e9606:	48 8b 47 38          	mov    0x38(%rdi),%rax
 18e960a:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
 18e960f:	48 8b 47 60          	mov    0x60(%rdi),%rax
 18e9613:	42 0f b6 0c 01       	movzbl (%rcx,%r8,1),%ecx
 18e9618:	4c 89 44 24 60       	mov    %r8,0x60(%rsp)
 18e961d:	42 8b 04 80          	mov    (%rax,%r8,4),%eax
 18e9621:	89 ca                	mov    %ecx,%edx
 18e9623:	01 f1                	add    %esi,%ecx
 18e9625:	c1 e8 03             	shr    $0x3,%eax
 18e9628:	84 d2                	test   %dl,%dl
 18e962a:	ba 08 00 00 00       	mov    $0x8,%edx
 18e962f:	c4 e2 f1 f7 ca       	shlx   %rcx,%rdx,%rcx
 18e9634:	48 0f 45 d9          	cmovne %rcx,%rbx
 18e9638:	48 8b 4f 78          	mov    0x78(%rdi),%rcx
 18e963c:	46 8b 0c 81          	mov    (%rcx,%r8,4),%r9d
 18e9640:	48 8b 8f 98 00 00 00 	mov    0x98(%rdi),%rcx
 18e9647:	42 0f b6 0c 01       	movzbl (%rcx,%r8,1),%ecx
 18e964c:	4c 89 8c 24 d8 00 00 00 	mov    %r9,0xd8(%rsp)
 18e9654:	89 ca                	mov    %ecx,%edx
 18e9656:	01 f1                	add    %esi,%ecx
 18e9658:	84 d2                	test   %dl,%dl
 18e965a:	ba 01 00 00 00       	mov    $0x1,%edx
 18e965f:	c4 e2 f1 f7 f2       	shlx   %rcx,%rdx,%rsi
 18e9664:	48 0f 44 f2          	cmove  %rdx,%rsi
 18e9668:	4d 85 c9             	test   %r9,%r9
 18e966b:	0f 84 58 03 00 00    	je     18e99c9 <tier0_tables_open+0x2659>
 18e9671:	48 8b 0c 24          	mov    (%rsp),%rcx
 18e9675:	45 31 e4             	xor    %r12d,%r12d
 18e9678:	45 31 db             	xor    %r11d,%r11d
 18e967b:	45 31 c9             	xor    %r9d,%r9d
 18e967e:	48 c7 84 24 80 00 00 00 00 00 00 00 	movq   $0x0,0x80(%rsp)
 18e968a:	48 8b b9 b8 00 00 00 	mov    0xb8(%rcx),%rdi
 18e9691:	4c 8b 41 20          	mov    0x20(%rcx),%r8
 18e9695:	48 8b 51 18          	mov    0x18(%rcx),%rdx
 18e9699:	48 89 7c 24 70       	mov    %rdi,0x70(%rsp)
 18e969e:	48 8b b9 c0 00 00 00 	mov    0xc0(%rcx),%rdi
 18e96a5:	4c 89 84 24 40 01 00 00 	mov    %r8,0x140(%rsp)
 18e96ad:	4c 8b 81 c8 00 00 00 	mov    0xc8(%rcx),%r8
 18e96b4:	48 89 54 24 38       	mov    %rdx,0x38(%rsp)
 18e96b9:	48 8b 54 24 60       	mov    0x60(%rsp),%rdx
 18e96be:	48 89 bc 24 18 01 00 00 	mov    %rdi,0x118(%rsp)
 18e96c6:	48 8b b9 b0 00 00 00 	mov    0xb0(%rcx),%rdi
 18e96cd:	4c 89 84 24 d0 00 00 00 	mov    %r8,0xd0(%rsp)
 18e96d5:	4c 8b 81 d0 00 00 00 	mov    0xd0(%rcx),%r8
 18e96dc:	48 89 bc 24 10 01 00 00 	mov    %rdi,0x110(%rsp)
 18e96e4:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
 18e96e9:	4c 89 84 24 b8 00 00 00 	mov    %r8,0xb8(%rsp)
 18e96f1:	4c 8b 81 d8 00 00 00 	mov    0xd8(%rcx),%r8
 18e96f8:	0f b6 04 07          	movzbl (%rdi,%rax,1),%eax
 18e96fc:	4c 89 84 24 48 01 00 00 	mov    %r8,0x148(%rsp)
 18e9704:	88 44 24 08          	mov    %al,0x8(%rsp)
 18e9708:	48 8b 81 88 00 00 00 	mov    0x88(%rcx),%rax
 18e970f:	48 8b 49 70          	mov    0x70(%rcx),%rcx
 18e9713:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
 18e9717:	88 44 24 48          	mov    %al,0x48(%rsp)
 18e971b:	8b 04 91             	mov    (%rcx,%rdx,4),%eax
 18e971e:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
 18e9723:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
 18e9728:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
 18e972d:	42 8d 2c 20          	lea    (%rax,%r12,1),%ebp
 18e9731:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
 18e9736:	8b 04 a8             	mov    (%rax,%rbp,4),%eax
 18e9739:	c1 e8 03             	shr    $0x3,%eax
 18e973c:	80 3c 01 0f          	cmpb   $0xf,(%rcx,%rax,1)
 18e9740:	48 89 c1             	mov    %rax,%rcx
 18e9743:	75 0e                	jne    18e9753 <tier0_tables_open+0x23e3>
 18e9745:	48 8b 8c 24 40 01 00 00 	mov    0x140(%rsp),%rcx
 18e974d:	8b 0c 81             	mov    (%rcx,%rax,4),%ecx
 18e9750:	c1 e9 03             	shr    $0x3,%ecx
 18e9753:	48 8b 94 24 d0 00 00 00 	mov    0xd0(%rsp),%rdx
 18e975b:	80 7c 24 48 00       	cmpb   $0x0,0x48(%rsp)
 18e9760:	41 ba 08 00 00 00    	mov    $0x8,%r10d
 18e9766:	0f b6 3c 2a          	movzbl (%rdx,%rbp,1),%edi
 18e976a:	48 8b 94 24 b8 00 00 00 	mov    0xb8(%rsp),%rdx
 18e9772:	41 0f 95 c5          	setne  %r13b
 18e9776:	44 0f b6 04 2a       	movzbl (%rdx,%rbp,1),%r8d
 18e977b:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
 18e9780:	48 8b 14 ca          	mov    (%rdx,%rcx,8),%rdx
 18e9784:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
 18e9789:	0f b6 04 01          	movzbl (%rcx,%rax,1),%eax
 18e978d:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
 18e9792:	48 c1 e2 03          	shl    $0x3,%rdx
 18e9796:	40 84 ff             	test   %dil,%dil
 18e9799:	8d 0c 39             	lea    (%rcx,%rdi,1),%ecx
 18e979c:	c4 c2 f1 f7 fa       	shlx   %rcx,%r10,%rdi
 18e97a1:	b9 00 00 00 00       	mov    $0x0,%ecx
 18e97a6:	48 0f 45 cf          	cmovne %rdi,%rcx
 18e97aa:	45 08 c5             	or     %r8b,%r13b
 18e97ad:	c4 c2 f9 f7 c2       	shlx   %rax,%r10,%rax
 18e97b2:	41 f6 c0 02          	test   $0x2,%r8b
 18e97b6:	0f 85 89 00 00 00    	jne    18e9845 <tier0_tables_open+0x24d5>
 18e97bc:	48 39 c8             	cmp    %rcx,%rax
 18e97bf:	48 0f 46 c1          	cmovbe %rcx,%rax
 18e97c3:	48 83 f9 09          	cmp    $0x9,%rcx
 18e97c7:	73 05                	jae    18e97ce <tier0_tables_open+0x245e>
 18e97c9:	b9 08 00 00 00       	mov    $0x8,%ecx
 18e97ce:	48 85 db             	test   %rbx,%rbx
 18e97d1:	74 10                	je     18e97e3 <tier0_tables_open+0x2473>
 18e97d3:	48 39 d8             	cmp    %rbx,%rax
 18e97d6:	72 03                	jb     18e97db <tier0_tables_open+0x246b>
 18e97d8:	48 89 d8             	mov    %rbx,%rax
 18e97db:	48 39 d9             	cmp    %rbx,%rcx
 18e97de:	72 03                	jb     18e97e3 <tier0_tables_open+0x2473>
 18e97e0:	48 89 d9             	mov    %rbx,%rcx
 18e97e3:	44 0f b6 7c 24 08    	movzbl 0x8(%rsp),%r15d
 18e97e9:	41 f6 c5 01          	test   $0x1,%r13b
 18e97ed:	48 89 c7             	mov    %rax,%rdi
 18e97f0:	49 8d 43 ff          	lea    -0x1(%r11),%rax
 18e97f4:	48 0f 45 f9          	cmovne %rcx,%rdi
 18e97f8:	48 c7 c1 ff ff ff ff 	mov    $0xffffffffffffffff,%rcx
 18e97ff:	49 89 fa             	mov    %rdi,%r10
 18e9802:	41 80 ff 11          	cmp    $0x11,%r15b
 18e9806:	48 0f 44 c1          	cmove  %rcx,%rax
 18e980a:	49 f7 da             	neg    %r10
 18e980d:	48 01 f8             	add    %rdi,%rax
 18e9810:	49 21 c2             	and    %rax,%r10
 18e9813:	4c 89 d1             	mov    %r10,%rcx
 18e9816:	48 01 d1             	add    %rdx,%rcx
 18e9819:	41 0f 93 c0          	setae  %r8b
 18e981d:	0f 99 c0             	setns  %al
 18e9820:	44 20 c0             	and    %r8b,%al
 18e9823:	41 80 ff 11          	cmp    $0x11,%r15b
 18e9827:	0f 85 b2 00 00 00    	jne    18e98df <tier0_tables_open+0x256f>
 18e982d:	49 39 d3             	cmp    %rdx,%r11
 18e9830:	48 c7 84 24 80 00 00 00 00 00 00 00 	movq   $0x0,0x80(%rsp)
 18e983c:	4c 0f 46 da          	cmovbe %rdx,%r11
 18e9840:	e9 1f 01 00 00       	jmp    18e9964 <tier0_tables_open+0x25f4>
 18e9845:	48 8b bc 24 18 01 00 00 	mov    0x118(%rsp),%rdi
 18e984d:	41 ba 00 00 00 00    	mov    $0x0,%r10d
 18e9853:	41 bf 01 00 00 00    	mov    $0x1,%r15d
 18e9859:	44 8b 04 af          	mov    (%rdi,%rbp,4),%r8d
 18e985d:	4c 89 df             	mov    %r11,%rdi
 18e9860:	48 2b bc 24 80 00 00 00 	sub    0x80(%rsp),%rdi
 18e9868:	80 7c 24 08 11       	cmpb   $0x11,0x8(%rsp)
 18e986d:	4c 0f 45 d7          	cmovne %rdi,%r10
 18e9871:	45 85 c0             	test   %r8d,%r8d
 18e9874:	48 89 c7             	mov    %rax,%rdi
 18e9877:	49 0f 45 ff          	cmovne %r15,%rdi
 18e987b:	41 f6 c5 01          	test   $0x1,%r13b
 18e987f:	48 0f 44 f8          	cmove  %rax,%rdi
 18e9883:	48 85 c9             	test   %rcx,%rcx
 18e9886:	74 0e                	je     18e9896 <tier0_tables_open+0x2526>
 18e9888:	48 39 cf             	cmp    %rcx,%rdi
 18e988b:	48 0f 46 f9          	cmovbe %rcx,%rdi
 18e988f:	48 39 c8             	cmp    %rcx,%rax
 18e9892:	48 0f 46 c1          	cmovbe %rcx,%rax
 18e9896:	48 85 db             	test   %rbx,%rbx
 18e9899:	74 19                	je     18e98b4 <tier0_tables_open+0x2544>
 18e989b:	45 85 c0             	test   %r8d,%r8d
 18e989e:	74 14                	je     18e98b4 <tier0_tables_open+0x2544>
 18e98a0:	41 f6 c5 01          	test   $0x1,%r13b
 18e98a4:	48 0f 45 f8          	cmovne %rax,%rdi
 18e98a8:	48 39 df             	cmp    %rbx,%rdi
 18e98ab:	72 03                	jb     18e98b0 <tier0_tables_open+0x2540>
 18e98ad:	48 89 df             	mov    %rbx,%rdi
 18e98b0:	b0 01                	mov    $0x1,%al
 18e98b2:	eb 3e                	jmp    18e98f2 <tier0_tables_open+0x2582>
 18e98b4:	4d 85 c0             	test   %r8,%r8
 18e98b7:	74 16                	je     18e98cf <tier0_tables_open+0x255f>
 18e98b9:	b0 01                	mov    $0x1,%al
 18e98bb:	48 85 db             	test   %rbx,%rbx
 18e98be:	75 32                	jne    18e98f2 <tier0_tables_open+0x2582>
 18e98c0:	48 8d 47 ff          	lea    -0x1(%rdi),%rax
 18e98c4:	4c 21 d0             	and    %r10,%rax
 18e98c7:	4c 01 c0             	add    %r8,%rax
 18e98ca:	48 39 d0             	cmp    %rdx,%rax
 18e98cd:	76 21                	jbe    18e98f0 <tier0_tables_open+0x2580>
 18e98cf:	49 8d 44 3a ff       	lea    -0x1(%r10,%rdi,1),%rax
 18e98d4:	49 89 fa             	mov    %rdi,%r10
 18e98d7:	49 f7 da             	neg    %r10
 18e98da:	49 21 c2             	and    %rax,%r10
 18e98dd:	eb 30                	jmp    18e990f <tier0_tables_open+0x259f>
 18e98df:	48 c7 84 24 80 00 00 00 00 00 00 00 	movq   $0x0,0x80(%rsp)
 18e98eb:	49 89 cb             	mov    %rcx,%r11
 18e98ee:	eb 74                	jmp    18e9964 <tier0_tables_open+0x25f4>
 18e98f0:	31 c0                	xor    %eax,%eax
 18e98f2:	48 39 d9             	cmp    %rbx,%rcx
 18e98f5:	0f 97 c2             	seta   %dl
 18e98f8:	48 85 c9             	test   %rcx,%rcx
 18e98fb:	74 12                	je     18e990f <tier0_tables_open+0x259f>
 18e98fd:	20 c2                	and    %al,%dl
 18e98ff:	75 0e                	jne    18e990f <tier0_tables_open+0x259f>
 18e9901:	49 8d 44 0a ff       	lea    -0x1(%r10,%rcx,1),%rax
 18e9906:	48 f7 d9             	neg    %rcx
 18e9909:	48 21 c1             	and    %rax,%rcx
 18e990c:	49 89 ca             	mov    %rcx,%r10
 18e990f:	48 8b 84 24 10 01 00 00 	mov    0x110(%rsp),%rax
 18e9917:	83 3c a8 00          	cmpl   $0x0,(%rax,%rbp,4)
 18e991b:	b8 01 00 00 00       	mov    $0x1,%eax
 18e9920:	48 0f 44 f8          	cmove  %rax,%rdi
 18e9924:	80 7c 24 08 11       	cmpb   $0x11,0x8(%rsp)
 18e9929:	75 1d                	jne    18e9948 <tier0_tables_open+0x25d8>
 18e992b:	49 83 c0 07          	add    $0x7,%r8
 18e992f:	48 b8 f8 ff ff ff 01 00 00 00 	movabs $0x1fffffff8,%rax
 18e9939:	49 21 c0             	and    %rax,%r8
 18e993c:	4d 39 c3             	cmp    %r8,%r11
 18e993f:	77 03                	ja     18e9944 <tier0_tables_open+0x25d4>
 18e9941:	4d 89 c3             	mov    %r8,%r11
 18e9944:	b0 01                	mov    $0x1,%al
 18e9946:	eb 1c                	jmp    18e9964 <tier0_tables_open+0x25f4>
 18e9948:	4f 8d 5c 02 07       	lea    0x7(%r10,%r8,1),%r11
 18e994d:	49 83 e3 f8          	and    $0xfffffffffffffff8,%r11
 18e9951:	4c 89 d9             	mov    %r11,%rcx
 18e9954:	4c 29 d1             	sub    %r10,%rcx
 18e9957:	4c 29 c1             	sub    %r8,%rcx
 18e995a:	b0 01                	mov    $0x1,%al
 18e995c:	48 89 8c 24 80 00 00 00 	mov    %rcx,0x80(%rsp)
 18e9964:	48 8b 8c 24 48 01 00 00 	mov    0x148(%rsp),%rcx
 18e996c:	4d 39 d9             	cmp    %r11,%r9
 18e996f:	4d 0f 46 cb          	cmovbe %r11,%r9
 18e9973:	48 c1 ef 03          	shr    $0x3,%rdi
 18e9977:	48 39 fe             	cmp    %rdi,%rsi
 18e997a:	48 0f 46 f7          	cmovbe %rdi,%rsi
 18e997e:	4d 85 db             	test   %r11,%r11
 18e9981:	4c 89 14 e9          	mov    %r10,(%rcx,%rbp,8)
 18e9985:	0f 99 c1             	setns  %cl
 18e9988:	20 c1                	and    %al,%cl
 18e998a:	80 f9 01             	cmp    $0x1,%cl
 18e998d:	75 11                	jne    18e99a0 <tier0_tables_open+0x2630>
 18e998f:	49 ff c4             	inc    %r12
 18e9992:	4c 3b a4 24 d8 00 00 00 	cmp    0xd8(%rsp),%r12
 18e999a:	0f 82 83 fd ff ff    	jb     18e9723 <tier0_tables_open+0x23b3>
 18e99a0:	84 c9                	test   %cl,%cl
 18e99a2:	0f 84 2f 02 00 00    	je     18e9bd7 <tier0_tables_open+0x2867>
 18e99a8:	48 8b 04 24          	mov    (%rsp),%rax
 18e99ac:	49 ff c9             	dec    %r9
 18e99af:	48 8b 48 38          	mov    0x38(%rax),%rcx
 18e99b3:	48 8b 40 60          	mov    0x60(%rax),%rax
 18e99b7:	48 89 4c 24 40       	mov    %rcx,0x40(%rsp)
 18e99bc:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
 18e99c1:	8b 04 88             	mov    (%rax,%rcx,4),%eax
 18e99c4:	c1 e8 03             	shr    $0x3,%eax
 18e99c7:	eb 07                	jmp    18e99d0 <tier0_tables_open+0x2660>
 18e99c9:	49 c7 c1 ff ff ff ff 	mov    $0xffffffffffffffff,%r9
 18e99d0:	48 8b 7c 24 40       	mov    0x40(%rsp),%rdi
 18e99d5:	31 c9                	xor    %ecx,%ecx
 18e99d7:	f3 48 0f bc ce       	tzcnt  %rsi,%rcx
 18e99dc:	49 8d 14 f1          	lea    (%r9,%rsi,8),%rdx
 18e99e0:	48 c1 e6 03          	shl    $0x3,%rsi
 18e99e4:	48 f7 de             	neg    %rsi
 18e99e7:	48 21 d6             	and    %rdx,%rsi
 18e99ea:	48 c1 ee 03          	shr    $0x3,%rsi
 18e99ee:	48 89 34 c7          	mov    %rsi,(%rdi,%rax,8)
 18e99f2:	48 8b 3c 24          	mov    (%rsp),%rdi
 18e99f6:	48 8b 57 18          	mov    0x18(%rdi),%rdx
 18e99fa:	88 0c 02             	mov    %cl,(%rdx,%rax,1)
 18e99fd:	48 8b 54 24 60       	mov    0x60(%rsp),%rdx
 18e9a02:	48 8b 4f 10          	mov    0x10(%rdi),%rcx
 18e9a06:	80 0c 01 04          	orb    $0x4,(%rcx,%rax,1)
 18e9a0a:	8b 87 a8 00 00 00    	mov    0xa8(%rdi),%eax
 18e9a10:	ff c0                	inc    %eax
 18e9a12:	89 87 a8 00 00 00    	mov    %eax,0xa8(%rdi)
 18e9a18:	48 8b 8f 80 00 00 00 	mov    0x80(%rdi),%rcx
 18e9a1f:	89 04 91             	mov    %eax,(%rcx,%rdx,4)
 18e9a22:	48 8b 87 08 01 00 00 	mov    0x108(%rdi),%rax
 18e9a29:	48 85 c0             	test   %rax,%rax
 18e9a2c:	74 74                	je     18e9aa2 <tier0_tables_open+0x2732>
 18e9a2e:	80 78 4c 00          	cmpb   $0x0,0x4c(%rax)
 18e9a32:	75 6e                	jne    18e9aa2 <tier0_tables_open+0x2732>
 18e9a34:	8b 48 08             	mov    0x8(%rax),%ecx
 18e9a37:	3b 48 0c             	cmp    0xc(%rax),%ecx
 18e9a3a:	75 06                	jne    18e9a42 <tier0_tables_open+0x26d2>
 18e9a3c:	c6 40 4c 01          	movb   $0x1,0x4c(%rax)
 18e9a40:	eb 60                	jmp    18e9aa2 <tier0_tables_open+0x2732>
 18e9a42:	48 8b 14 24          	mov    (%rsp),%rdx
 18e9a46:	4c 8b 44 24 60       	mov    0x60(%rsp),%r8
 18e9a4b:	8d 71 01             	lea    0x1(%rcx),%esi
 18e9a4e:	48 6b c9 38          	imul   $0x38,%rcx,%rcx
 18e9a52:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 18e9a56:	48 8b 52 60          	mov    0x60(%rdx),%rdx
 18e9a5a:	42 8b 14 82          	mov    (%rdx,%r8,4),%edx
 18e9a5e:	c6 40 4c 00          	movb   $0x0,0x4c(%rax)
 18e9a62:	89 70 08             	mov    %esi,0x8(%rax)
 18e9a65:	48 8b 30             	mov    (%rax),%rsi
 18e9a68:	48 8b 78 30          	mov    0x30(%rax),%rdi
 18e9a6c:	ff 40 34             	incl   0x34(%rax)
 18e9a6f:	48 89 3c 0e          	mov    %rdi,(%rsi,%rcx,1)
 18e9a73:	c6 44 0e 08 04       	movb   $0x4,0x8(%rsi,%rcx,1)
 18e9a78:	c5 fa 7f 44 0e 09    	vmovdqu %xmm0,0x9(%rsi,%rcx,1)
 18e9a7e:	48 c7 44 0e 18 00 00 00 00 	movq   $0x0,0x18(%rsi,%rcx,1)
 18e9a87:	89 54 0e 20          	mov    %edx,0x20(%rsi,%rcx,1)
 18e9a8b:	48 c7 44 0e 24 00 00 00 00 	movq   $0x0,0x24(%rsi,%rcx,1)
 18e9a94:	44 89 44 0e 2c       	mov    %r8d,0x2c(%rsi,%rcx,1)
 18e9a99:	48 c7 44 0e 30 00 00 00 00 	movq   $0x0,0x30(%rsi,%rcx,1)
 18e9aa2:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
 18e9aa7:	48 8b 0c 24          	mov    (%rsp),%rcx
 18e9aab:	8b 40 68             	mov    0x68(%rax),%eax
 18e9aae:	48 8b 11             	mov    (%rcx),%rdx
 18e9ab1:	48 8b 49 38          	mov    0x38(%rcx),%rcx
 18e9ab5:	c1 e8 03             	shr    $0x3,%eax
 18e9ab8:	80 3c 02 0f          	cmpb   $0xf,(%rdx,%rax,1)
 18e9abc:	48 89 c2             	mov    %rax,%rdx
 18e9abf:	75 0e                	jne    18e9acf <tier0_tables_open+0x275f>
 18e9ac1:	48 8b 14 24          	mov    (%rsp),%rdx
 18e9ac5:	48 8b 52 20          	mov    0x20(%rdx),%rdx
 18e9ac9:	8b 14 82             	mov    (%rdx,%rax,4),%edx
 18e9acc:	c1 ea 03             	shr    $0x3,%edx
 18e9acf:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
 18e9ad4:	8b 76 5c             	mov    0x5c(%rsi),%esi
 18e9ad7:	48 39 34 d1          	cmp    %rsi,(%rcx,%rdx,8)
 18e9adb:	0f 85 e7 00 00 00    	jne    18e9bc8 <tier0_tables_open+0x2858>
 18e9ae1:	48 8b 14 24          	mov    (%rsp),%rdx
 18e9ae5:	48 8b 4a 18          	mov    0x18(%rdx),%rcx
 18e9ae9:	0f b6 04 01          	movzbl (%rcx,%rax,1),%eax
 18e9aed:	b9 01 00 00 00       	mov    $0x1,%ecx
 18e9af2:	c4 e2 79 f7 c1       	shlx   %eax,%ecx,%eax
 18e9af7:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
 18e9afc:	8b 49 60             	mov    0x60(%rcx),%ecx
 18e9aff:	ff 82 60 1f 00 00    	incl   0x1f60(%rdx)
 18e9b05:	48 83 7c 24 68 39    	cmpq   $0x39,0x68(%rsp)
 18e9b0b:	77 0d                	ja     18e9b1a <tier0_tables_open+0x27aa>
 18e9b0d:	48 ff 44 24 68       	incq   0x68(%rsp)
 18e9b12:	39 c8                	cmp    %ecx,%eax
 18e9b14:	0f 84 9f f1 ff ff    	je     18e8cb9 <tier0_tables_open+0x1949>
 18e9b1a:	39 c8                	cmp    %ecx,%eax
 18e9b1c:	0f 85 7d ed ff ff    	jne    18e889f <tier0_tables_open+0x152f>
 18e9b22:	64 4c 8b 24 25 10 ff ff ff 	mov    %fs:0xffffffffffffff10,%r12
 18e9b2b:	4d 85 e4             	test   %r12,%r12
 18e9b2e:	0f 84 d2 00 00 00    	je     18e9c06 <tier0_tables_open+0x2896>
 18e9b34:	64 48 8b 04 25 18 ff ff ff 	mov    %fs:0xffffffffffffff18,%rax
 18e9b3d:	48 89 84 24 58 01 00 00 	mov    %rax,0x158(%rsp)
 18e9b45:	e9 81 01 00 00       	jmp    18e9ccb <tier0_tables_open+0x295b>
 18e9b4a:	c5 f8 77             	vzeroupper
 18e9b4d:	e8 de fa ea fe       	call   799630 <__stack_chk_fail@plt>
 18e9b52:	48 8b 0c 24          	mov    (%rsp),%rcx
 18e9b56:	48 8b 81 08 01 00 00 	mov    0x108(%rcx),%rax
 18e9b5d:	c7 81 00 01 00 00 01 00 00 00 	movl   $0x1,0x100(%rcx)
 18e9b67:	48 85 c0             	test   %rax,%rax
 18e9b6a:	74 16                	je     18e9b82 <tier0_tables_open+0x2812>
 18e9b6c:	c6 40 3c 01          	movb   $0x1,0x3c(%rax)
 18e9b70:	48 8b 48 30          	mov    0x30(%rax),%rcx
 18e9b74:	48 89 48 40          	mov    %rcx,0x40(%rax)
 18e9b78:	c7 40 48 01 00 00 00 	movl   $0x1,0x48(%rax)
 18e9b7f:	ff 40 34             	incl   0x34(%rax)
 18e9b82:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
 18e9b87:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%rax)
 18e9b8e:	eb 38                	jmp    18e9bc8 <tier0_tables_open+0x2858>
 18e9b90:	41 ba 01 00 00 00    	mov    $0x1,%r10d
 18e9b96:	eb 06                	jmp    18e9b9e <tier0_tables_open+0x282e>
 18e9b98:	41 ba 0f 00 00 00    	mov    $0xf,%r10d
 18e9b9e:	48 8b 0c 24          	mov    (%rsp),%rcx
 18e9ba2:	48 8b 81 08 01 00 00 	mov    0x108(%rcx),%rax
 18e9ba9:	44 89 91 00 01 00 00 	mov    %r10d,0x100(%rcx)
 18e9bb0:	48 85 c0             	test   %rax,%rax
 18e9bb3:	74 13                	je     18e9bc8 <tier0_tables_open+0x2858>
 18e9bb5:	c6 40 3c 01          	movb   $0x1,0x3c(%rax)
 18e9bb9:	48 8b 48 30          	mov    0x30(%rax),%rcx
 18e9bbd:	48 89 48 40          	mov    %rcx,0x40(%rax)
 18e9bc1:	44 89 50 48          	mov    %r10d,0x48(%rax)
 18e9bc5:	ff 40 34             	incl   0x34(%rax)
 18e9bc8:	48 8b 04 24          	mov    (%rsp),%rax
 18e9bcc:	ff 80 60 1f 00 00    	incl   0x1f60(%rax)
 18e9bd2:	e9 c8 ec ff ff       	jmp    18e889f <tier0_tables_open+0x152f>
 18e9bd7:	b8 05 00 00 00       	mov    $0x5,%eax
 18e9bdc:	48 8b 14 24          	mov    (%rsp),%rdx
 18e9be0:	48 8b 8a 08 01 00 00 	mov    0x108(%rdx),%rcx
 18e9be7:	89 82 00 01 00 00    	mov    %eax,0x100(%rdx)
 18e9bed:	48 85 c9             	test   %rcx,%rcx
 18e9bf0:	74 d6                	je     18e9bc8 <tier0_tables_open+0x2858>
 18e9bf2:	c6 41 3c 01          	movb   $0x1,0x3c(%rcx)
 18e9bf6:	48 8b 51 30          	mov    0x30(%rcx),%rdx
 18e9bfa:	48 89 51 40          	mov    %rdx,0x40(%rcx)
 18e9bfe:	89 41 48             	mov    %eax,0x48(%rcx)
 18e9c01:	ff 41 34             	incl   0x34(%rcx)
 18e9c04:	eb c2                	jmp    18e9bc8 <tier0_tables_open+0x2858>
 18e9c06:	49 bf 00 00 20 00 10 00 00 00 	movabs $0x1000200000,%r15
 18e9c10:	ba 03 00 00 00       	mov    $0x3,%edx
 18e9c15:	b9 22 40 00 00       	mov    $0x4022,%ecx
 18e9c1a:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
 18e9c20:	45 31 ed             	xor    %r13d,%r13d
 18e9c23:	31 ff                	xor    %edi,%edi
 18e9c25:	45 31 c9             	xor    %r9d,%r9d
 18e9c28:	4c 89 fe             	mov    %r15,%rsi
 18e9c2b:	e8 60 04 eb fe       	call   79a090 <mmap@plt>
 18e9c30:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
 18e9c34:	74 5c                	je     18e9c92 <tier0_tables_open+0x2922>
 18e9c36:	4c 8d a0 ff ff 20 00 	lea    0x20ffff(%rax),%r12
 18e9c3d:	ba 0f 00 00 00       	mov    $0xf,%edx
 18e9c42:	48 89 c7             	mov    %rax,%rdi
 18e9c45:	49 81 e4 00 00 e0 ff 	and    $0xffffffffffe00000,%r12
 18e9c4c:	4d 89 e5             	mov    %r12,%r13
 18e9c4f:	49 29 c5             	sub    %rax,%r13
 18e9c52:	4c 89 ee             	mov    %r13,%rsi
 18e9c55:	49 8d ad 00 00 ff ff 	lea    -0x10000(%r13),%rbp
 18e9c5c:	e8 df 03 eb fe       	call   79a040 <madvise@plt>
 18e9c61:	4c 89 fe             	mov    %r15,%rsi
 18e9c64:	4c 29 ee             	sub    %r13,%rsi
 18e9c67:	ba 0e 00 00 00       	mov    $0xe,%edx
 18e9c6c:	4c 89 e7             	mov    %r12,%rdi
 18e9c6f:	e8 cc 03 eb fe       	call   79a040 <madvise@plt>
 18e9c74:	49 81 c7 00 00 e0 ff 	add    $0xffffffffffe00000,%r15
 18e9c7b:	49 81 c4 00 00 ff ff 	add    $0xffffffffffff0000,%r12
 18e9c82:	4d 89 fd             	mov    %r15,%r13
 18e9c85:	eb 10                	jmp    18e9c97 <tier0_tables_open+0x2927>
 18e9c87:	41 ba 0c 00 00 00    	mov    $0xc,%r10d
 18e9c8d:	e9 0c ff ff ff       	jmp    18e9b9e <tier0_tables_open+0x282e>
 18e9c92:	45 31 e4             	xor    %r12d,%r12d
 18e9c95:	31 ed                	xor    %ebp,%ebp
 18e9c97:	64 4c 89 24 25 10 ff ff ff 	mov    %r12,%fs:0xffffffffffffff10
 18e9ca0:	64 48 c7 04 25 18 ff ff ff 00 00 00 00 	movq   $0x0,%fs:0xffffffffffffff18
 18e9cad:	64 4c 89 2c 25 20 ff ff ff 	mov    %r13,%fs:0xffffffffffffff20
 18e9cb6:	64 48 89 2c 25 28 ff ff ff 	mov    %rbp,%fs:0xffffffffffffff28
 18e9cbf:	48 c7 84 24 58 01 00 00 00 00 00 00 	movq   $0x0,0x158(%rsp)
 18e9ccb:	48 8b 04 24          	mov    (%rsp),%rax
 18e9ccf:	48 8b 8c 24 58 01 00 00 	mov    0x158(%rsp),%rcx
 18e9cd7:	44 8b 68 48          	mov    0x48(%rax),%r13d
 18e9cdb:	4a 8d 04 21          	lea    (%rcx,%r12,1),%rax
 18e9cdf:	4a 8d 4c 21 03       	lea    0x3(%rcx,%r12,1),%rcx
 18e9ce4:	48 83 e1 fc          	and    $0xfffffffffffffffc,%rcx
 18e9ce8:	48 89 4c 24 48       	mov    %rcx,0x48(%rsp)
 18e9ced:	48 39 c1             	cmp    %rax,%rcx
 18e9cf0:	72 6f                	jb     18e9d61 <tier0_tables_open+0x29f1>
 18e9cf2:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
 18e9cf7:	64 48 8b 0c 25 20 ff ff ff 	mov    %fs:0xffffffffffffff20,%rcx
 18e9d00:	4a 8d 04 ad 00 00 00 00 	lea    0x0(,%r13,4),%rax
 18e9d08:	4c 29 e2             	sub    %r12,%rdx
 18e9d0b:	48 89 ce             	mov    %rcx,%rsi
 18e9d0e:	48 29 d6             	sub    %rdx,%rsi
 18e9d11:	40 0f 92 c7          	setb   %dil
 18e9d15:	48 39 f0             	cmp    %rsi,%rax
 18e9d18:	40 0f 97 c6          	seta   %sil
 18e9d1c:	40 08 fe             	or     %dil,%sil
 18e9d1f:	75 40                	jne    18e9d61 <tier0_tables_open+0x29f1>
 18e9d21:	48 01 c2             	add    %rax,%rdx
 18e9d24:	48 83 7c 24 48 00    	cmpq   $0x0,0x48(%rsp)
 18e9d2a:	64 48 89 14 25 18 ff ff ff 	mov    %rdx,%fs:0xffffffffffffff18
 18e9d33:	74 2c                	je     18e9d61 <tier0_tables_open+0x29f1>
 18e9d35:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
 18e9d3a:	48 01 c2             	add    %rax,%rdx
 18e9d3d:	48 89 94 24 60 01 00 00 	mov    %rdx,0x160(%rsp)
 18e9d45:	4c 29 e2             	sub    %r12,%rdx
 18e9d48:	48 29 d1             	sub    %rdx,%rcx
 18e9d4b:	40 0f 92 c6          	setb   %sil
 18e9d4f:	48 39 c8             	cmp    %rcx,%rax
 18e9d52:	0f 97 c1             	seta   %cl
 18e9d55:	40 08 f1             	or     %sil,%cl
 18e9d58:	80 f9 01             	cmp    $0x1,%cl
 18e9d5b:	0f 85 f1 04 00 00    	jne    18ea252 <tier0_tables_open+0x2ee2>
 18e9d61:	48 8b 04 24          	mov    (%rsp),%rax
 18e9d65:	83 b8 c0 01 00 00 00 	cmpl   $0x0,0x1c0(%rax)
 18e9d6c:	0f 95 c0             	setne  %al
 18e9d6f:	89 44 24 18          	mov    %eax,0x18(%rsp)
 18e9d73:	41 83 fd 02          	cmp    $0x2,%r13d
 18e9d77:	0f 82 54 33 00 00    	jb     18ed0d1 <tier0_tables_open+0x5d61>
 18e9d7d:	b8 01 00 00 00       	mov    $0x1,%eax
 18e9d82:	49 83 fd 02          	cmp    $0x2,%r13
 18e9d86:	0f 84 08 02 00 00    	je     18e9f94 <tier0_tables_open+0x2c24>
 18e9d8c:	49 8d 4d ff          	lea    -0x1(%r13),%rcx
 18e9d90:	48 89 ca             	mov    %rcx,%rdx
 18e9d93:	48 83 e2 fe          	and    $0xfffffffffffffffe,%rdx
 18e9d97:	48 f7 da             	neg    %rdx
 18e9d9a:	eb 1b                	jmp    18e9db7 <tier0_tables_open+0x2a47>
 18e9d9c:	c7 44 24 18 00 00 00 00 	movl   $0x0,0x18(%rsp)
 18e9da4:	48 8d 74 02 02       	lea    0x2(%rdx,%rax,1),%rsi
 18e9da9:	48 83 c0 02          	add    $0x2,%rax
 18e9dad:	48 83 fe 01          	cmp    $0x1,%rsi
 18e9db1:	0f 84 d4 01 00 00    	je     18e9f8b <tier0_tables_open+0x2c1b>
 18e9db7:	f6 44 24 18 01       	testb  $0x1,0x18(%rsp)
 18e9dbc:	74 09                	je     18e9dc7 <tier0_tables_open+0x2a57>
 18e9dbe:	40 b6 01             	mov    $0x1,%sil
 18e9dc1:	89 74 24 18          	mov    %esi,0x18(%rsp)
 18e9dc5:	eb dd                	jmp    18e9da4 <tier0_tables_open+0x2a34>
 18e9dc7:	48 8b 34 24          	mov    (%rsp),%rsi
 18e9dcb:	48 8b b6 88 01 00 00 	mov    0x188(%rsi),%rsi
 18e9dd2:	f6 44 86 01 80       	testb  $0x80,0x1(%rsi,%rax,4)
 18e9dd7:	0f 85 ae 00 00 00    	jne    18e9e8b <tier0_tables_open+0x2b1b>
 18e9ddd:	48 8b 34 24          	mov    (%rsp),%rsi
 18e9de1:	89 c7                	mov    %eax,%edi
 18e9de3:	81 e7 ff ff ff 1f    	and    $0x1fffffff,%edi
 18e9de9:	48 8b 36             	mov    (%rsi),%rsi
 18e9dec:	44 0f b6 0c 3e       	movzbl (%rsi,%rdi,1),%r9d
 18e9df1:	41 80 f9 0f          	cmp    $0xf,%r9b
 18e9df5:	75 14                	jne    18e9e0b <tier0_tables_open+0x2a9b>
 18e9df7:	4c 8b 04 24          	mov    (%rsp),%r8
 18e9dfb:	4d 8b 40 20          	mov    0x20(%r8),%r8
 18e9dff:	41 8b 3c b8          	mov    (%r8,%rdi,4),%edi
 18e9e03:	c1 ef 03             	shr    $0x3,%edi
 18e9e06:	44 0f b6 0c 3e       	movzbl (%rsi,%rdi,1),%r9d
 18e9e0b:	45 0f b6 d1          	movzbl %r9b,%r10d
 18e9e0f:	45 31 c0             	xor    %r8d,%r8d
 18e9e12:	45 8d 5a f7          	lea    -0x9(%r10),%r11d
 18e9e16:	41 83 fb 03          	cmp    $0x3,%r11d
 18e9e1a:	72 72                	jb     18e9e8e <tier0_tables_open+0x2b1e>
 18e9e1c:	45 85 d2             	test   %r10d,%r10d
 18e9e1f:	74 6d                	je     18e9e8e <tier0_tables_open+0x2b1e>
 18e9e21:	41 83 fa 01          	cmp    $0x1,%r10d
 18e9e25:	74 1b                	je     18e9e42 <tier0_tables_open+0x2ad2>
 18e9e27:	45 31 c0             	xor    %r8d,%r8d
 18e9e2a:	45 84 c9             	test   %r9b,%r9b
 18e9e2d:	74 5f                	je     18e9e8e <tier0_tables_open+0x2b1e>
 18e9e2f:	4c 8b 0c 24          	mov    (%rsp),%r9
 18e9e33:	4d 8b 49 10          	mov    0x10(%r9),%r9
 18e9e37:	41 0f b6 3c 39       	movzbl (%r9,%rdi,1),%edi
 18e9e3c:	40 80 e7 04          	and    $0x4,%dil
 18e9e40:	74 4c                	je     18e9e8e <tier0_tables_open+0x2b1e>
 18e9e42:	80 3c 06 0e          	cmpb   $0xe,(%rsi,%rax,1)
 18e9e46:	0f 85 27 01 00 00    	jne    18e9f73 <tier0_tables_open+0x2c03>
 18e9e4c:	48 8b 3c 24          	mov    (%rsp),%rdi
 18e9e50:	4c 8b 47 20          	mov    0x20(%rdi),%r8
 18e9e54:	41 8b 3c 80          	mov    (%r8,%rax,4),%edi
 18e9e58:	c1 ef 03             	shr    $0x3,%edi
 18e9e5b:	80 3c 3e 0f          	cmpb   $0xf,(%rsi,%rdi,1)
 18e9e5f:	75 07                	jne    18e9e68 <tier0_tables_open+0x2af8>
 18e9e61:	41 8b 3c b8          	mov    (%r8,%rdi,4),%edi
 18e9e65:	c1 ef 03             	shr    $0x3,%edi
 18e9e68:	48 8b 34 24          	mov    (%rsp),%rsi
 18e9e6c:	48 8b 76 38          	mov    0x38(%rsi),%rsi
 18e9e70:	48 83 3c fe 00       	cmpq   $0x0,(%rsi,%rdi,8)
 18e9e75:	41 0f 94 c0          	sete   %r8b
 18e9e79:	40 b6 01             	mov    $0x1,%sil
 18e9e7c:	89 74 24 18          	mov    %esi,0x18(%rsp)
 18e9e80:	45 84 c0             	test   %r8b,%r8b
 18e9e83:	0f 85 1b ff ff ff    	jne    18e9da4 <tier0_tables_open+0x2a34>
 18e9e89:	eb 13                	jmp    18e9e9e <tier0_tables_open+0x2b2e>
 18e9e8b:	45 31 c0             	xor    %r8d,%r8d
 18e9e8e:	40 b6 01             	mov    $0x1,%sil
 18e9e91:	89 74 24 18          	mov    %esi,0x18(%rsp)
 18e9e95:	45 84 c0             	test   %r8b,%r8b
 18e9e98:	0f 85 06 ff ff ff    	jne    18e9da4 <tier0_tables_open+0x2a34>
 18e9e9e:	48 8b 34 24          	mov    (%rsp),%rsi
 18e9ea2:	48 8b b6 88 01 00 00 	mov    0x188(%rsi),%rsi
 18e9ea9:	f6 44 86 05 80       	testb  $0x80,0x5(%rsi,%rax,4)
 18e9eae:	0f 85 e8 fe ff ff    	jne    18e9d9c <tier0_tables_open+0x2a2c>
 18e9eb4:	48 8b 34 24          	mov    (%rsp),%rsi
 18e9eb8:	48 8d 78 01          	lea    0x1(%rax),%rdi
 18e9ebc:	81 e7 ff ff ff 1f    	and    $0x1fffffff,%edi
 18e9ec2:	48 8b 36             	mov    (%rsi),%rsi
 18e9ec5:	44 0f b6 04 3e       	movzbl (%rsi,%rdi,1),%r8d
 18e9eca:	41 80 f8 0f          	cmp    $0xf,%r8b
 18e9ece:	75 14                	jne    18e9ee4 <tier0_tables_open+0x2b74>
 18e9ed0:	4c 8b 04 24          	mov    (%rsp),%r8
 18e9ed4:	4d 8b 40 20          	mov    0x20(%r8),%r8
 18e9ed8:	41 8b 3c b8          	mov    (%r8,%rdi,4),%edi
 18e9edc:	c1 ef 03             	shr    $0x3,%edi
 18e9edf:	44 0f b6 04 3e       	movzbl (%rsi,%rdi,1),%r8d
 18e9ee4:	45 0f b6 c8          	movzbl %r8b,%r9d
 18e9ee8:	c7 44 24 18 00 00 00 00 	movl   $0x0,0x18(%rsp)
 18e9ef0:	45 8d 51 f7          	lea    -0x9(%r9),%r10d
 18e9ef4:	41 83 fa 03          	cmp    $0x3,%r10d
 18e9ef8:	0f 82 a6 fe ff ff    	jb     18e9da4 <tier0_tables_open+0x2a34>
 18e9efe:	45 85 c9             	test   %r9d,%r9d
 18e9f01:	0f 84 9d fe ff ff    	je     18e9da4 <tier0_tables_open+0x2a34>
 18e9f07:	41 83 f9 01          	cmp    $0x1,%r9d
 18e9f0b:	74 28                	je     18e9f35 <tier0_tables_open+0x2bc5>
 18e9f0d:	c7 44 24 18 00 00 00 00 	movl   $0x0,0x18(%rsp)
 18e9f15:	45 84 c0             	test   %r8b,%r8b
 18e9f18:	0f 84 86 fe ff ff    	je     18e9da4 <tier0_tables_open+0x2a34>
 18e9f1e:	4c 8b 04 24          	mov    (%rsp),%r8
 18e9f22:	4d 8b 40 10          	mov    0x10(%r8),%r8
 18e9f26:	41 0f b6 3c 38       	movzbl (%r8,%rdi,1),%edi
 18e9f2b:	40 80 e7 04          	and    $0x4,%dil
 18e9f2f:	0f 84 6f fe ff ff    	je     18e9da4 <tier0_tables_open+0x2a34>
 18e9f35:	80 7c 06 01 0e       	cmpb   $0xe,0x1(%rsi,%rax,1)
 18e9f3a:	0f 85 5c fe ff ff    	jne    18e9d9c <tier0_tables_open+0x2a2c>
 18e9f40:	48 8b 3c 24          	mov    (%rsp),%rdi
 18e9f44:	4c 8b 47 20          	mov    0x20(%rdi),%r8
 18e9f48:	41 8b 7c 80 04       	mov    0x4(%r8,%rax,4),%edi
 18e9f4d:	c1 ef 03             	shr    $0x3,%edi
 18e9f50:	80 3c 3e 0f          	cmpb   $0xf,(%rsi,%rdi,1)
 18e9f54:	75 07                	jne    18e9f5d <tier0_tables_open+0x2bed>
 18e9f56:	41 8b 3c b8          	mov    (%r8,%rdi,4),%edi
 18e9f5a:	c1 ef 03             	shr    $0x3,%edi
 18e9f5d:	48 8b 34 24          	mov    (%rsp),%rsi
 18e9f61:	48 8b 76 38          	mov    0x38(%rsi),%rsi
 18e9f65:	48 83 3c fe 00       	cmpq   $0x0,(%rsi,%rdi,8)
 18e9f6a:	40 0f 94 c6          	sete   %sil
 18e9f6e:	e9 4e fe ff ff       	jmp    18e9dc1 <tier0_tables_open+0x2a51>
 18e9f73:	45 31 c0             	xor    %r8d,%r8d
 18e9f76:	40 b6 01             	mov    $0x1,%sil
 18e9f79:	89 74 24 18          	mov    %esi,0x18(%rsp)
 18e9f7d:	45 84 c0             	test   %r8b,%r8b
 18e9f80:	0f 85 1e fe ff ff    	jne    18e9da4 <tier0_tables_open+0x2a34>
 18e9f86:	e9 13 ff ff ff       	jmp    18e9e9e <tier0_tables_open+0x2b2e>
 18e9f8b:	f6 c1 01             	test   $0x1,%cl
 18e9f8e:	0f 84 c9 00 00 00    	je     18ea05d <tier0_tables_open+0x2ced>
 18e9f94:	80 7c 24 18 00       	cmpb   $0x0,0x18(%rsp)
 18e9f99:	b1 01                	mov    $0x1,%cl
 18e9f9b:	89 4c 24 18          	mov    %ecx,0x18(%rsp)
 18e9f9f:	0f 85 b8 00 00 00    	jne    18ea05d <tier0_tables_open+0x2ced>
 18e9fa5:	48 8b 0c 24          	mov    (%rsp),%rcx
 18e9fa9:	48 8b 89 88 01 00 00 	mov    0x188(%rcx),%rcx
 18e9fb0:	f6 44 81 01 80       	testb  $0x80,0x1(%rcx,%rax,4)
 18e9fb5:	0f 85 9a 00 00 00    	jne    18ea055 <tier0_tables_open+0x2ce5>
 18e9fbb:	48 8b 0c 24          	mov    (%rsp),%rcx
 18e9fbf:	89 c2                	mov    %eax,%edx
 18e9fc1:	81 e2 ff ff ff 1f    	and    $0x1fffffff,%edx
 18e9fc7:	48 8b 09             	mov    (%rcx),%rcx
 18e9fca:	0f b6 34 11          	movzbl (%rcx,%rdx,1),%esi
 18e9fce:	40 80 fe 0f          	cmp    $0xf,%sil
 18e9fd2:	75 12                	jne    18e9fe6 <tier0_tables_open+0x2c76>
 18e9fd4:	48 8b 34 24          	mov    (%rsp),%rsi
 18e9fd8:	48 8b 76 20          	mov    0x20(%rsi),%rsi
 18e9fdc:	8b 14 96             	mov    (%rsi,%rdx,4),%edx
 18e9fdf:	c1 ea 03             	shr    $0x3,%edx
 18e9fe2:	0f b6 34 11          	movzbl (%rcx,%rdx,1),%esi
 18e9fe6:	40 0f b6 fe          	movzbl %sil,%edi
 18e9fea:	c7 44 24 18 00 00 00 00 	movl   $0x0,0x18(%rsp)
 18e9ff2:	44 8d 47 f7          	lea    -0x9(%rdi),%r8d
 18e9ff6:	41 83 f8 03          	cmp    $0x3,%r8d
 18e9ffa:	72 61                	jb     18ea05d <tier0_tables_open+0x2ced>
 18e9ffc:	85 ff                	test   %edi,%edi
 18e9ffe:	74 5d                	je     18ea05d <tier0_tables_open+0x2ced>
 18ea000:	83 ff 01             	cmp    $0x1,%edi
 18ea003:	74 1e                	je     18ea023 <tier0_tables_open+0x2cb3>
 18ea005:	c7 44 24 18 00 00 00 00 	movl   $0x0,0x18(%rsp)
 18ea00d:	40 84 f6             	test   %sil,%sil
 18ea010:	74 4b                	je     18ea05d <tier0_tables_open+0x2ced>
 18ea012:	48 8b 34 24          	mov    (%rsp),%rsi
 18ea016:	48 8b 76 10          	mov    0x10(%rsi),%rsi
 18ea01a:	0f b6 14 16          	movzbl (%rsi,%rdx,1),%edx
 18ea01e:	80 e2 04             	and    $0x4,%dl
 18ea021:	74 3a                	je     18ea05d <tier0_tables_open+0x2ced>
 18ea023:	80 3c 01 0e          	cmpb   $0xe,(%rcx,%rax,1)
 18ea027:	75 2c                	jne    18ea055 <tier0_tables_open+0x2ce5>
 18ea029:	48 8b 14 24          	mov    (%rsp),%rdx
 18ea02d:	48 8b 72 20          	mov    0x20(%rdx),%rsi
 18ea031:	48 8b 52 38          	mov    0x38(%rdx),%rdx
 18ea035:	8b 04 86             	mov    (%rsi,%rax,4),%eax
 18ea038:	c1 e8 03             	shr    $0x3,%eax
 18ea03b:	80 3c 01 0f          	cmpb   $0xf,(%rcx,%rax,1)
 18ea03f:	75 06                	jne    18ea047 <tier0_tables_open+0x2cd7>
 18ea041:	8b 04 86             	mov    (%rsi,%rax,4),%eax
 18ea044:	c1 e8 03             	shr    $0x3,%eax
 18ea047:	48 83 3c c2 00       	cmpq   $0x0,(%rdx,%rax,8)
 18ea04c:	0f 94 c0             	sete   %al
 18ea04f:	89 44 24 18          	mov    %eax,0x18(%rsp)
 18ea053:	eb 08                	jmp    18ea05d <tier0_tables_open+0x2ced>
 18ea055:	c7 44 24 18 00 00 00 00 	movl   $0x0,0x18(%rsp)
 18ea05d:	bd 01 00 00 00       	mov    $0x1,%ebp
 18ea062:	45 31 ff             	xor    %r15d,%r15d
 18ea065:	48 8d 9c 24 b0 01 00 00 	lea    0x1b0(%rsp),%rbx
 18ea06d:	41 bc 01 00 00 00    	mov    $0x1,%r12d
 18ea073:	eb 35                	jmp    18ea0aa <tier0_tables_open+0x2d3a>
 18ea075:	48 8b 34 24          	mov    (%rsp),%rsi
 18ea079:	b9 01 00 00 00       	mov    $0x1,%ecx
 18ea07e:	4c 89 f7             	mov    %r14,%rdi
 18ea081:	48 89 da             	mov    %rbx,%rdx
 18ea084:	e8 97 43 01 00       	call   18fe420 <abi_classify_scalar>
 18ea089:	41 b7 01             	mov    $0x1,%r15b
 18ea08c:	49 ff c4             	inc    %r12
 18ea08f:	4d 39 ec             	cmp    %r13,%r12
 18ea092:	0f 95 c0             	setne  %al
 18ea095:	4c 0f 44 e5          	cmove  %rbp,%r12
 18ea099:	89 c1                	mov    %eax,%ecx
 18ea09b:	44 08 f9             	or     %r15b,%cl
 18ea09e:	41 20 c7             	and    %al,%r15b
 18ea0a1:	f6 c1 01             	test   $0x1,%cl
 18ea0a4:	0f 84 27 30 00 00    	je     18ed0d1 <tier0_tables_open+0x5d61>
 18ea0aa:	48 8b 0c 24          	mov    (%rsp),%rcx
 18ea0ae:	42 8d 04 e5 00 00 00 00 	lea    0x0(,%r12,8),%eax
 18ea0b6:	89 84 24 b0 01 00 00 	mov    %eax,0x1b0(%rsp)
 18ea0bd:	48 8b 81 88 01 00 00 	mov    0x188(%rcx),%rax
 18ea0c4:	42 f6 44 a0 01 80    	testb  $0x80,0x1(%rax,%r12,4)
 18ea0ca:	75 c0                	jne    18ea08c <tier0_tables_open+0x2d1c>
 18ea0cc:	48 8b 0c 24          	mov    (%rsp),%rcx
 18ea0d0:	44 89 e2             	mov    %r12d,%edx
 18ea0d3:	81 e2 ff ff ff 1f    	and    $0x1fffffff,%edx
 18ea0d9:	48 8b 09             	mov    (%rcx),%rcx
 18ea0dc:	0f b6 34 11          	movzbl (%rcx,%rdx,1),%esi
 18ea0e0:	40 80 fe 0f          	cmp    $0xf,%sil
 18ea0e4:	75 12                	jne    18ea0f8 <tier0_tables_open+0x2d88>
 18ea0e6:	48 8b 34 24          	mov    (%rsp),%rsi
 18ea0ea:	48 8b 76 20          	mov    0x20(%rsi),%rsi
 18ea0ee:	8b 14 96             	mov    (%rsi,%rdx,4),%edx
 18ea0f1:	c1 ea 03             	shr    $0x3,%edx
 18ea0f4:	0f b6 34 11          	movzbl (%rcx,%rdx,1),%esi
 18ea0f8:	40 0f b6 fe          	movzbl %sil,%edi
 18ea0fc:	44 8d 47 f7          	lea    -0x9(%rdi),%r8d
 18ea100:	41 83 f8 03          	cmp    $0x3,%r8d
 18ea104:	72 86                	jb     18ea08c <tier0_tables_open+0x2d1c>
 18ea106:	85 ff                	test   %edi,%edi
 18ea108:	74 82                	je     18ea08c <tier0_tables_open+0x2d1c>
 18ea10a:	83 ff 01             	cmp    $0x1,%edi
 18ea10d:	74 1e                	je     18ea12d <tier0_tables_open+0x2dbd>
 18ea10f:	40 84 f6             	test   %sil,%sil
 18ea112:	0f 84 74 ff ff ff    	je     18ea08c <tier0_tables_open+0x2d1c>
 18ea118:	48 8b 34 24          	mov    (%rsp),%rsi
 18ea11c:	48 8b 76 10          	mov    0x10(%rsi),%rsi
 18ea120:	0f b6 14 16          	movzbl (%rsi,%rdx,1),%edx
 18ea124:	80 e2 04             	and    $0x4,%dl
 18ea127:	0f 84 5f ff ff ff    	je     18ea08c <tier0_tables_open+0x2d1c>
 18ea12d:	42 0f b6 0c 21       	movzbl (%rcx,%r12,1),%ecx
 18ea132:	83 f9 0f             	cmp    $0xf,%ecx
 18ea135:	77 53                	ja     18ea18a <tier0_tables_open+0x2e1a>
 18ea137:	ba 00 c1 00 00       	mov    $0xc100,%edx
 18ea13c:	0f a3 ca             	bt     %ecx,%edx
 18ea13f:	73 49                	jae    18ea18a <tier0_tables_open+0x2e1a>
 18ea141:	48 8b 14 24          	mov    (%rsp),%rdx
 18ea145:	48 8b 52 20          	mov    0x20(%rdx),%rdx
 18ea149:	42 8b 14 a2          	mov    (%rdx,%r12,4),%edx
 18ea14d:	89 d6                	mov    %edx,%esi
 18ea14f:	c1 ee 03             	shr    $0x3,%esi
 18ea152:	f6 44 b0 01 80       	testb  $0x80,0x1(%rax,%rsi,4)
 18ea157:	0f 84 2f ff ff ff    	je     18ea08c <tier0_tables_open+0x2d1c>
 18ea15d:	80 f9 08             	cmp    $0x8,%cl
 18ea160:	0f 85 0f ff ff ff    	jne    18ea075 <tier0_tables_open+0x2d05>
 18ea166:	48 8b 04 24          	mov    (%rsp),%rax
 18ea16a:	48 8b 40 38          	mov    0x38(%rax),%rax
 18ea16e:	4a 83 3c e0 00       	cmpq   $0x0,(%rax,%r12,8)
 18ea173:	0f 85 fc fe ff ff    	jne    18ea075 <tier0_tables_open+0x2d05>
 18ea179:	48 8b 34 24          	mov    (%rsp),%rsi
 18ea17d:	4c 89 f7             	mov    %r14,%rdi
 18ea180:	e8 32 a3 0c 00       	call   19b44b7 <abi_wide_classified>
 18ea185:	e9 bb 00 00 00       	jmp    18ea245 <tier0_tables_open+0x2ed5>
 18ea18a:	80 e1 fe             	and    $0xfe,%cl
 18ea18d:	80 f9 10             	cmp    $0x10,%cl
 18ea190:	0f 85 df fe ff ff    	jne    18ea075 <tier0_tables_open+0x2d05>
 18ea196:	48 8b 0c 24          	mov    (%rsp),%rcx
 18ea19a:	48 8b 49 38          	mov    0x38(%rcx),%rcx
 18ea19e:	4a 8b 0c e1          	mov    (%rcx,%r12,8),%rcx
 18ea1a2:	48 83 f9 40          	cmp    $0x40,%rcx
 18ea1a6:	77 69                	ja     18ea211 <tier0_tables_open+0x2ea1>
 18ea1a8:	48 8b 14 24          	mov    (%rsp),%rdx
 18ea1ac:	48 8b 52 10          	mov    0x10(%rdx),%rdx
 18ea1b0:	42 f6 04 22 40       	testb  $0x40,(%rdx,%r12,1)
 18ea1b5:	75 5a                	jne    18ea211 <tier0_tables_open+0x2ea1>
 18ea1b7:	48 8b 3c 24          	mov    (%rsp),%rdi
 18ea1bb:	48 8b 4f 28          	mov    0x28(%rdi),%rcx
 18ea1bf:	48 8b 57 70          	mov    0x70(%rdi),%rdx
 18ea1c3:	48 8b 7f 78          	mov    0x78(%rdi),%rdi
 18ea1c7:	42 8b 34 a1          	mov    (%rcx,%r12,4),%esi
 18ea1cb:	8b 0c b2             	mov    (%rdx,%rsi,4),%ecx
 18ea1ce:	8b 34 b7             	mov    (%rdi,%rsi,4),%esi
 18ea1d1:	01 ce                	add    %ecx,%esi
 18ea1d3:	39 f1                	cmp    %esi,%ecx
 18ea1d5:	0f 83 9a fe ff ff    	jae    18ea075 <tier0_tables_open+0x2d05>
 18ea1db:	48 8b 14 24          	mov    (%rsp),%rdx
 18ea1df:	48 ff c1             	inc    %rcx
 18ea1e2:	89 f6                	mov    %esi,%esi
 18ea1e4:	48 8b 92 b8 00 00 00 	mov    0xb8(%rdx),%rdx
 18ea1eb:	8b 7c 8a fc          	mov    -0x4(%rdx,%rcx,4),%edi
 18ea1ef:	c1 ef 03             	shr    $0x3,%edi
 18ea1f2:	8b 3c b8             	mov    (%rax,%rdi,4),%edi
 18ea1f5:	66 85 ff             	test   %di,%di
 18ea1f8:	79 09                	jns    18ea203 <tier0_tables_open+0x2e93>
 18ea1fa:	48 39 f1             	cmp    %rsi,%rcx
 18ea1fd:	48 8d 49 01          	lea    0x1(%rcx),%rcx
 18ea201:	72 e8                	jb     18ea1eb <tier0_tables_open+0x2e7b>
 18ea203:	66 85 ff             	test   %di,%di
 18ea206:	0f 88 69 fe ff ff    	js     18ea075 <tier0_tables_open+0x2d05>
 18ea20c:	e9 7b fe ff ff       	jmp    18ea08c <tier0_tables_open+0x2d1c>
 18ea211:	80 7c 24 18 00       	cmpb   $0x0,0x18(%rsp)
 18ea216:	75 1e                	jne    18ea236 <tier0_tables_open+0x2ec6>
 18ea218:	48 85 c9             	test   %rcx,%rcx
 18ea21b:	0f 85 54 fe ff ff    	jne    18ea075 <tier0_tables_open+0x2d05>
 18ea221:	48 8b 04 24          	mov    (%rsp),%rax
 18ea225:	48 8b 40 10          	mov    0x10(%rax),%rax
 18ea229:	42 0f b6 04 20       	movzbl (%rax,%r12,1),%eax
 18ea22e:	24 40                	and    $0x40,%al
 18ea230:	0f 84 3f fe ff ff    	je     18ea075 <tier0_tables_open+0x2d05>
 18ea236:	48 8b 34 24          	mov    (%rsp),%rsi
 18ea23a:	4c 89 f7             	mov    %r14,%rdi
 18ea23d:	44 89 e2             	mov    %r12d,%edx
 18ea240:	e8 ad a2 0c 00       	call   19b44f2 <abi_members_classified>
 18ea245:	84 c0                	test   %al,%al
 18ea247:	0f 85 28 fe ff ff    	jne    18ea075 <tier0_tables_open+0x2d05>
 18ea24d:	e9 3a fe ff ff       	jmp    18ea08c <tier0_tables_open+0x2d1c>
 18ea252:	48 01 c2             	add    %rax,%rdx
 18ea255:	48 8b 04 24          	mov    (%rsp),%rax
 18ea259:	64 48 89 14 25 18 ff ff ff 	mov    %rdx,%fs:0xffffffffffffff18
 18ea262:	83 b8 c0 01 00 00 00 	cmpl   $0x0,0x1c0(%rax)
 18ea269:	0f 95 c0             	setne  %al
 18ea26c:	48 83 bc 24 60 01 00 00 00 	cmpq   $0x0,0x160(%rsp)
 18ea275:	89 44 24 18          	mov    %eax,0x18(%rsp)
 18ea279:	0f 84 f4 fa ff ff    	je     18e9d73 <tier0_tables_open+0x2a03>
 18ea27f:	41 83 fd 02          	cmp    $0x2,%r13d
 18ea283:	0f 82 48 2e 00 00    	jb     18ed0d1 <tier0_tables_open+0x5d61>
 18ea289:	49 83 fd 02          	cmp    $0x2,%r13
 18ea28d:	75 14                	jne    18ea2a3 <tier0_tables_open+0x2f33>
 18ea28f:	31 c0                	xor    %eax,%eax
 18ea291:	b9 01 00 00 00       	mov    $0x1,%ecx
 18ea296:	c7 44 24 2c 00 00 00 00 	movl   $0x0,0x2c(%rsp)
 18ea29e:	e9 81 01 00 00       	jmp    18ea424 <tier0_tables_open+0x30b4>
 18ea2a3:	49 ff cd             	dec    %r13
 18ea2a6:	b9 01 00 00 00       	mov    $0x1,%ecx
 18ea2ab:	31 c0                	xor    %eax,%eax
 18ea2ad:	c7 44 24 2c 00 00 00 00 	movl   $0x0,0x2c(%rsp)
 18ea2b5:	4c 89 ea             	mov    %r13,%rdx
 18ea2b8:	48 83 e2 fe          	and    $0xfffffffffffffffe,%rdx
 18ea2bc:	48 f7 da             	neg    %rdx
 18ea2bf:	eb 37                	jmp    18ea2f8 <tier0_tables_open+0x2f88>
 18ea2c1:	44 8b 54 24 2c       	mov    0x2c(%rsp),%r10d
 18ea2c6:	4c 8b 4c 24 48       	mov    0x48(%rsp),%r9
 18ea2cb:	44 89 d7             	mov    %r10d,%edi
 18ea2ce:	41 ff c2             	inc    %r10d
 18ea2d1:	41 83 f8 0e          	cmp    $0xe,%r8d
 18ea2d5:	41 89 34 b9          	mov    %esi,(%r9,%rdi,4)
 18ea2d9:	40 0f 94 c6          	sete   %sil
 18ea2dd:	44 89 54 24 2c       	mov    %r10d,0x2c(%rsp)
 18ea2e2:	40 08 f0             	or     %sil,%al
 18ea2e5:	48 8d 74 0a 02       	lea    0x2(%rdx,%rcx,1),%rsi
 18ea2ea:	48 83 c1 02          	add    $0x2,%rcx
 18ea2ee:	48 83 fe 01          	cmp    $0x1,%rsi
 18ea2f2:	0f 84 22 01 00 00    	je     18ea41a <tier0_tables_open+0x30aa>
 18ea2f8:	48 8b 34 24          	mov    (%rsp),%rsi
 18ea2fc:	48 8b b6 88 01 00 00 	mov    0x188(%rsi),%rsi
 18ea303:	f6 44 8e 01 80       	testb  $0x80,0x1(%rsi,%rcx,4)
 18ea308:	75 7e                	jne    18ea388 <tier0_tables_open+0x3018>
 18ea30a:	48 8b 3c 24          	mov    (%rsp),%rdi
 18ea30e:	89 ce                	mov    %ecx,%esi
 18ea310:	81 e6 ff ff ff 1f    	and    $0x1fffffff,%esi
 18ea316:	4c 8b 07             	mov    (%rdi),%r8
 18ea319:	41 0f b6 3c 30       	movzbl (%r8,%rsi,1),%edi
 18ea31e:	40 80 ff 0f          	cmp    $0xf,%dil
 18ea322:	75 13                	jne    18ea337 <tier0_tables_open+0x2fc7>
 18ea324:	48 8b 3c 24          	mov    (%rsp),%rdi
 18ea328:	48 8b 7f 20          	mov    0x20(%rdi),%rdi
 18ea32c:	8b 34 b7             	mov    (%rdi,%rsi,4),%esi
 18ea32f:	c1 ee 03             	shr    $0x3,%esi
 18ea332:	41 0f b6 3c 30       	movzbl (%r8,%rsi,1),%edi
 18ea337:	40 0f b6 ff          	movzbl %dil,%edi
 18ea33b:	44 8d 47 f7          	lea    -0x9(%rdi),%r8d
 18ea33f:	41 83 f8 03          	cmp    $0x3,%r8d
 18ea343:	72 43                	jb     18ea388 <tier0_tables_open+0x3018>
 18ea345:	85 ff                	test   %edi,%edi
 18ea347:	74 3f                	je     18ea388 <tier0_tables_open+0x3018>
 18ea349:	83 ff 01             	cmp    $0x1,%edi
 18ea34c:	74 17                	je     18ea365 <tier0_tables_open+0x2ff5>
 18ea34e:	85 ff                	test   %edi,%edi
 18ea350:	74 36                	je     18ea388 <tier0_tables_open+0x3018>
 18ea352:	4c 8b 04 24          	mov    (%rsp),%r8
 18ea356:	4d 8b 40 10          	mov    0x10(%r8),%r8
 18ea35a:	41 0f b6 34 30       	movzbl (%r8,%rsi,1),%esi
 18ea35f:	40 80 e6 04          	and    $0x4,%sil
 18ea363:	74 23                	je     18ea388 <tier0_tables_open+0x3018>
 18ea365:	44 8b 4c 24 2c       	mov    0x2c(%rsp),%r9d
 18ea36a:	4c 8b 44 24 48       	mov    0x48(%rsp),%r8
 18ea36f:	44 89 ce             	mov    %r9d,%esi
 18ea372:	41 ff c1             	inc    %r9d
 18ea375:	83 ff 0e             	cmp    $0xe,%edi
 18ea378:	41 89 0c b0          	mov    %ecx,(%r8,%rsi,4)
 18ea37c:	40 0f 94 c6          	sete   %sil
 18ea380:	44 89 4c 24 2c       	mov    %r9d,0x2c(%rsp)
 18ea385:	40 08 f0             	or     %sil,%al
 18ea388:	48 8b 34 24          	mov    (%rsp),%rsi
 18ea38c:	48 8b b6 88 01 00 00 	mov    0x188(%rsi),%rsi
 18ea393:	f6 44 8e 05 80       	testb  $0x80,0x5(%rsi,%rcx,4)
 18ea398:	0f 85 47 ff ff ff    	jne    18ea2e5 <tier0_tables_open+0x2f75>
 18ea39e:	4c 8b 04 24          	mov    (%rsp),%r8
 18ea3a2:	48 8d 71 01          	lea    0x1(%rcx),%rsi
 18ea3a6:	89 f7                	mov    %esi,%edi
 18ea3a8:	81 e7 ff ff ff 1f    	and    $0x1fffffff,%edi
 18ea3ae:	4d 8b 08             	mov    (%r8),%r9
 18ea3b1:	45 0f b6 04 39       	movzbl (%r9,%rdi,1),%r8d
 18ea3b6:	41 80 f8 0f          	cmp    $0xf,%r8b
 18ea3ba:	75 14                	jne    18ea3d0 <tier0_tables_open+0x3060>
 18ea3bc:	4c 8b 04 24          	mov    (%rsp),%r8
 18ea3c0:	4d 8b 40 20          	mov    0x20(%r8),%r8
 18ea3c4:	41 8b 3c b8          	mov    (%r8,%rdi,4),%edi
 18ea3c8:	c1 ef 03             	shr    $0x3,%edi
 18ea3cb:	45 0f b6 04 39       	movzbl (%r9,%rdi,1),%r8d
 18ea3d0:	45 0f b6 c0          	movzbl %r8b,%r8d
 18ea3d4:	45 8d 48 f7          	lea    -0x9(%r8),%r9d
 18ea3d8:	41 83 f9 03          	cmp    $0x3,%r9d
 18ea3dc:	0f 82 03 ff ff ff    	jb     18ea2e5 <tier0_tables_open+0x2f75>
 18ea3e2:	45 85 c0             	test   %r8d,%r8d
 18ea3e5:	0f 84 fa fe ff ff    	je     18ea2e5 <tier0_tables_open+0x2f75>
 18ea3eb:	41 83 f8 01          	cmp    $0x1,%r8d
 18ea3ef:	0f 84 cc fe ff ff    	je     18ea2c1 <tier0_tables_open+0x2f51>
 18ea3f5:	45 85 c0             	test   %r8d,%r8d
 18ea3f8:	0f 84 e7 fe ff ff    	je     18ea2e5 <tier0_tables_open+0x2f75>
 18ea3fe:	4c 8b 0c 24          	mov    (%rsp),%r9
 18ea402:	4d 8b 49 10          	mov    0x10(%r9),%r9
 18ea406:	41 0f b6 3c 39       	movzbl (%r9,%rdi,1),%edi
 18ea40b:	40 80 e7 04          	and    $0x4,%dil
 18ea40f:	0f 85 ac fe ff ff    	jne    18ea2c1 <tier0_tables_open+0x2f51>
 18ea415:	e9 cb fe ff ff       	jmp    18ea2e5 <tier0_tables_open+0x2f75>
 18ea41a:	41 f6 c5 01          	test   $0x1,%r13b
 18ea41e:	0f 84 87 00 00 00    	je     18ea4ab <tier0_tables_open+0x313b>
 18ea424:	48 8b 14 24          	mov    (%rsp),%rdx
 18ea428:	48 8b 92 88 01 00 00 	mov    0x188(%rdx),%rdx
 18ea42f:	f6 44 8a 01 80       	testb  $0x80,0x1(%rdx,%rcx,4)
 18ea434:	75 75                	jne    18ea4ab <tier0_tables_open+0x313b>
 18ea436:	48 8b 34 24          	mov    (%rsp),%rsi
 18ea43a:	89 ca                	mov    %ecx,%edx
 18ea43c:	81 e2 ff ff ff 1f    	and    $0x1fffffff,%edx
 18ea442:	48 8b 3e             	mov    (%rsi),%rdi
 18ea445:	0f b6 34 17          	movzbl (%rdi,%rdx,1),%esi
 18ea449:	40 80 fe 0f          	cmp    $0xf,%sil
 18ea44d:	75 12                	jne    18ea461 <tier0_tables_open+0x30f1>
 18ea44f:	48 8b 34 24          	mov    (%rsp),%rsi
 18ea453:	48 8b 76 20          	mov    0x20(%rsi),%rsi
 18ea457:	8b 14 96             	mov    (%rsi,%rdx,4),%edx
 18ea45a:	c1 ea 03             	shr    $0x3,%edx
 18ea45d:	0f b6 34 17          	movzbl (%rdi,%rdx,1),%esi
 18ea461:	40 0f b6 f6          	movzbl %sil,%esi
 18ea465:	8d 7e f7             	lea    -0x9(%rsi),%edi
 18ea468:	83 ff 03             	cmp    $0x3,%edi
 18ea46b:	72 3e                	jb     18ea4ab <tier0_tables_open+0x313b>
 18ea46d:	85 f6                	test   %esi,%esi
 18ea46f:	74 3a                	je     18ea4ab <tier0_tables_open+0x313b>
 18ea471:	83 fe 01             	cmp    $0x1,%esi
 18ea474:	74 15                	je     18ea48b <tier0_tables_open+0x311b>
 18ea476:	85 f6                	test   %esi,%esi
 18ea478:	74 31                	je     18ea4ab <tier0_tables_open+0x313b>
 18ea47a:	48 8b 3c 24          	mov    (%rsp),%rdi
 18ea47e:	48 8b 7f 10          	mov    0x10(%rdi),%rdi
 18ea482:	0f b6 14 17          	movzbl (%rdi,%rdx,1),%edx
 18ea486:	80 e2 04             	and    $0x4,%dl
 18ea489:	74 20                	je     18ea4ab <tier0_tables_open+0x313b>
 18ea48b:	44 8b 44 24 2c       	mov    0x2c(%rsp),%r8d
 18ea490:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
 18ea495:	44 89 c2             	mov    %r8d,%edx
 18ea498:	41 ff c0             	inc    %r8d
 18ea49b:	83 fe 0e             	cmp    $0xe,%esi
 18ea49e:	89 0c 97             	mov    %ecx,(%rdi,%rdx,4)
 18ea4a1:	0f 94 c1             	sete   %cl
 18ea4a4:	44 89 44 24 2c       	mov    %r8d,0x2c(%rsp)
 18ea4a9:	08 c8                	or     %cl,%al
 18ea4ab:	a8 01                	test   $0x1,%al
 18ea4ad:	0f 84 dc 01 00 00    	je     18ea68f <tier0_tables_open+0x331f>
 18ea4b3:	83 7c 24 2c 00       	cmpl   $0x0,0x2c(%rsp)
 18ea4b8:	0f 84 d1 01 00 00    	je     18ea68f <tier0_tables_open+0x331f>
 18ea4be:	8b 4c 24 2c          	mov    0x2c(%rsp),%ecx
 18ea4c2:	89 ca                	mov    %ecx,%edx
 18ea4c4:	89 d0                	mov    %edx,%eax
 18ea4c6:	83 e0 03             	and    $0x3,%eax
 18ea4c9:	83 f9 04             	cmp    $0x4,%ecx
 18ea4cc:	73 07                	jae    18ea4d5 <tier0_tables_open+0x3165>
 18ea4ce:	31 c9                	xor    %ecx,%ecx
 18ea4d0:	e9 4c 01 00 00       	jmp    18ea621 <tier0_tables_open+0x32b1>
 18ea4d5:	83 e2 fc             	and    $0xfffffffc,%edx
 18ea4d8:	31 c9                	xor    %ecx,%ecx
 18ea4da:	eb 15                	jmp    18ea4f1 <tier0_tables_open+0x3181>
 18ea4dc:	c7 44 24 18 00 00 00 00 	movl   $0x0,0x18(%rsp)
 18ea4e4:	48 83 c1 04          	add    $0x4,%rcx
 18ea4e8:	48 39 ca             	cmp    %rcx,%rdx
 18ea4eb:	0f 84 2b 01 00 00    	je     18ea61c <tier0_tables_open+0x32ac>
 18ea4f1:	8b 74 24 18          	mov    0x18(%rsp),%esi
 18ea4f5:	40 f6 c6 01          	test   $0x1,%sil
 18ea4f9:	40 b6 01             	mov    $0x1,%sil
 18ea4fc:	89 74 24 18          	mov    %esi,0x18(%rsp)
 18ea500:	75 e2                	jne    18ea4e4 <tier0_tables_open+0x3174>
 18ea502:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
 18ea507:	48 8b 3c 24          	mov    (%rsp),%rdi
 18ea50b:	8b 34 8e             	mov    (%rsi,%rcx,4),%esi
 18ea50e:	48 8b 3f             	mov    (%rdi),%rdi
 18ea511:	80 3c 37 0e          	cmpb   $0xe,(%rdi,%rsi,1)
 18ea515:	75 2b                	jne    18ea542 <tier0_tables_open+0x31d2>
 18ea517:	4c 8b 04 24          	mov    (%rsp),%r8
 18ea51b:	4d 8b 40 20          	mov    0x20(%r8),%r8
 18ea51f:	41 8b 34 b0          	mov    (%r8,%rsi,4),%esi
 18ea523:	c1 ee 03             	shr    $0x3,%esi
 18ea526:	80 3c 37 0f          	cmpb   $0xf,(%rdi,%rsi,1)
 18ea52a:	75 07                	jne    18ea533 <tier0_tables_open+0x31c3>
 18ea52c:	41 8b 34 b0          	mov    (%r8,%rsi,4),%esi
 18ea530:	c1 ee 03             	shr    $0x3,%esi
 18ea533:	48 8b 3c 24          	mov    (%rsp),%rdi
 18ea537:	48 8b 7f 38          	mov    0x38(%rdi),%rdi
 18ea53b:	48 83 3c f7 00       	cmpq   $0x0,(%rdi,%rsi,8)
 18ea540:	74 a2                	je     18ea4e4 <tier0_tables_open+0x3174>
 18ea542:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
 18ea547:	48 8b 3c 24          	mov    (%rsp),%rdi
 18ea54b:	8b 74 8e 04          	mov    0x4(%rsi,%rcx,4),%esi
 18ea54f:	48 8b 3f             	mov    (%rdi),%rdi
 18ea552:	80 3c 37 0e          	cmpb   $0xe,(%rdi,%rsi,1)
 18ea556:	75 2f                	jne    18ea587 <tier0_tables_open+0x3217>
 18ea558:	4c 8b 04 24          	mov    (%rsp),%r8
 18ea55c:	4d 8b 40 20          	mov    0x20(%r8),%r8
 18ea560:	41 8b 34 b0          	mov    (%r8,%rsi,4),%esi
 18ea564:	c1 ee 03             	shr    $0x3,%esi
 18ea567:	80 3c 37 0f          	cmpb   $0xf,(%rdi,%rsi,1)
 18ea56b:	75 07                	jne    18ea574 <tier0_tables_open+0x3204>
 18ea56d:	41 8b 34 b0          	mov    (%r8,%rsi,4),%esi
 18ea571:	c1 ee 03             	shr    $0x3,%esi
 18ea574:	48 8b 3c 24          	mov    (%rsp),%rdi
 18ea578:	48 8b 7f 38          	mov    0x38(%rdi),%rdi
 18ea57c:	48 83 3c f7 00       	cmpq   $0x0,(%rdi,%rsi,8)
 18ea581:	0f 84 5d ff ff ff    	je     18ea4e4 <tier0_tables_open+0x3174>
 18ea587:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
 18ea58c:	48 8b 3c 24          	mov    (%rsp),%rdi
 18ea590:	8b 74 8e 08          	mov    0x8(%rsi,%rcx,4),%esi
 18ea594:	48 8b 3f             	mov    (%rdi),%rdi
 18ea597:	80 3c 37 0e          	cmpb   $0xe,(%rdi,%rsi,1)
 18ea59b:	75 2f                	jne    18ea5cc <tier0_tables_open+0x325c>
 18ea59d:	4c 8b 04 24          	mov    (%rsp),%r8
 18ea5a1:	4d 8b 40 20          	mov    0x20(%r8),%r8
 18ea5a5:	41 8b 34 b0          	mov    (%r8,%rsi,4),%esi
 18ea5a9:	c1 ee 03             	shr    $0x3,%esi
 18ea5ac:	80 3c 37 0f          	cmpb   $0xf,(%rdi,%rsi,1)
 18ea5b0:	75 07                	jne    18ea5b9 <tier0_tables_open+0x3249>
 18ea5b2:	41 8b 34 b0          	mov    (%r8,%rsi,4),%esi
 18ea5b6:	c1 ee 03             	shr    $0x3,%esi
 18ea5b9:	48 8b 3c 24          	mov    (%rsp),%rdi
 18ea5bd:	48 8b 7f 38          	mov    0x38(%rdi),%rdi
 18ea5c1:	48 83 3c f7 00       	cmpq   $0x0,(%rdi,%rsi,8)
 18ea5c6:	0f 84 18 ff ff ff    	je     18ea4e4 <tier0_tables_open+0x3174>
 18ea5cc:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
 18ea5d1:	48 8b 3c 24          	mov    (%rsp),%rdi
 18ea5d5:	8b 74 8e 0c          	mov    0xc(%rsi,%rcx,4),%esi
 18ea5d9:	48 8b 3f             	mov    (%rdi),%rdi
 18ea5dc:	80 3c 37 0e          	cmpb   $0xe,(%rdi,%rsi,1)
 18ea5e0:	0f 85 f6 fe ff ff    	jne    18ea4dc <tier0_tables_open+0x316c>
 18ea5e6:	4c 8b 04 24          	mov    (%rsp),%r8
 18ea5ea:	4d 8b 40 20          	mov    0x20(%r8),%r8
 18ea5ee:	41 8b 34 b0          	mov    (%r8,%rsi,4),%esi
 18ea5f2:	c1 ee 03             	shr    $0x3,%esi
 18ea5f5:	80 3c 37 0f          	cmpb   $0xf,(%rdi,%rsi,1)
 18ea5f9:	75 07                	jne    18ea602 <tier0_tables_open+0x3292>
 18ea5fb:	41 8b 34 b0          	mov    (%r8,%rsi,4),%esi
 18ea5ff:	c1 ee 03             	shr    $0x3,%esi
 18ea602:	48 8b 3c 24          	mov    (%rsp),%rdi
 18ea606:	48 8b 7f 38          	mov    0x38(%rdi),%rdi
 18ea60a:	48 83 3c f7 00       	cmpq   $0x0,(%rdi,%rsi,8)
 18ea60f:	40 0f 94 c6          	sete   %sil
 18ea613:	89 74 24 18          	mov    %esi,0x18(%rsp)
 18ea617:	e9 c8 fe ff ff       	jmp    18ea4e4 <tier0_tables_open+0x3174>
 18ea61c:	48 85 c0             	test   %rax,%rax
 18ea61f:	74 6e                	je     18ea68f <tier0_tables_open+0x331f>
 18ea621:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
 18ea626:	48 8d 0c 8a          	lea    (%rdx,%rcx,4),%rcx
 18ea62a:	31 d2                	xor    %edx,%edx
 18ea62c:	eb 10                	jmp    18ea63e <tier0_tables_open+0x32ce>
 18ea62e:	c7 44 24 18 00 00 00 00 	movl   $0x0,0x18(%rsp)
 18ea636:	48 ff c2             	inc    %rdx
 18ea639:	48 39 d0             	cmp    %rdx,%rax
 18ea63c:	74 51                	je     18ea68f <tier0_tables_open+0x331f>
 18ea63e:	f6 44 24 18 01       	testb  $0x1,0x18(%rsp)
 18ea643:	40 b6 01             	mov    $0x1,%sil
 18ea646:	89 74 24 18          	mov    %esi,0x18(%rsp)
 18ea64a:	75 ea                	jne    18ea636 <tier0_tables_open+0x32c6>
 18ea64c:	48 8b 3c 24          	mov    (%rsp),%rdi
 18ea650:	8b 34 91             	mov    (%rcx,%rdx,4),%esi
 18ea653:	48 8b 3f             	mov    (%rdi),%rdi
 18ea656:	80 3c 37 0e          	cmpb   $0xe,(%rdi,%rsi,1)
 18ea65a:	75 d2                	jne    18ea62e <tier0_tables_open+0x32be>
 18ea65c:	4c 8b 04 24          	mov    (%rsp),%r8
 18ea660:	4d 8b 40 20          	mov    0x20(%r8),%r8
 18ea664:	41 8b 34 b0          	mov    (%r8,%rsi,4),%esi
 18ea668:	c1 ee 03             	shr    $0x3,%esi
 18ea66b:	80 3c 37 0f          	cmpb   $0xf,(%rdi,%rsi,1)
 18ea66f:	75 07                	jne    18ea678 <tier0_tables_open+0x3308>
 18ea671:	41 8b 34 b0          	mov    (%r8,%rsi,4),%esi
 18ea675:	c1 ee 03             	shr    $0x3,%esi
 18ea678:	48 8b 3c 24          	mov    (%rsp),%rdi
 18ea67c:	48 8b 7f 38          	mov    0x38(%rdi),%rdi
 18ea680:	48 83 3c f7 00       	cmpq   $0x0,(%rdi,%rsi,8)
 18ea685:	40 0f 94 c6          	sete   %sil
 18ea689:	89 74 24 18          	mov    %esi,0x18(%rsp)
 18ea68d:	eb a7                	jmp    18ea636 <tier0_tables_open+0x32c6>
 18ea68f:	83 7c 24 2c 00       	cmpl   $0x0,0x2c(%rsp)
 18ea694:	0f 84 37 2a 00 00    	je     18ed0d1 <tier0_tables_open+0x5d61>
 18ea69a:	44 8b 7c 24 2c       	mov    0x2c(%rsp),%r15d
 18ea69f:	45 31 e4             	xor    %r12d,%r12d
 18ea6a2:	c7 44 24 2c 00 00 00 00 	movl   $0x0,0x2c(%rsp)
 18ea6aa:	c7 84 24 a0 00 00 00 00 00 00 00 	movl   $0x0,0xa0(%rsp)
 18ea6b5:	eb 35                	jmp    18ea6ec <tier0_tables_open+0x337c>
 18ea6b7:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
 18ea6bc:	8b b4 24 a0 00 00 00 	mov    0xa0(%rsp),%esi
 18ea6c3:	48 8b 94 24 60 01 00 00 	mov    0x160(%rsp),%rdx
 18ea6cb:	42 8b 04 a0          	mov    (%rax,%r12,4),%eax
 18ea6cf:	89 f1                	mov    %esi,%ecx
 18ea6d1:	ff c6                	inc    %esi
 18ea6d3:	89 b4 24 a0 00 00 00 	mov    %esi,0xa0(%rsp)
 18ea6da:	c1 e0 03             	shl    $0x3,%eax
 18ea6dd:	89 04 8a             	mov    %eax,(%rdx,%rcx,4)
 18ea6e0:	49 ff c4             	inc    %r12
 18ea6e3:	4d 39 fc             	cmp    %r15,%r12
 18ea6e6:	0f 84 64 01 00 00    	je     18ea850 <tier0_tables_open+0x34e0>
 18ea6ec:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
 18ea6f1:	48 8b 34 24          	mov    (%rsp),%rsi
 18ea6f5:	42 8b 14 a0          	mov    (%rax,%r12,4),%edx
 18ea6f9:	48 8b 06             	mov    (%rsi),%rax
 18ea6fc:	0f b6 0c 10          	movzbl (%rax,%rdx,1),%ecx
 18ea700:	83 f9 0f             	cmp    $0xf,%ecx
 18ea703:	77 7f                	ja     18ea784 <tier0_tables_open+0x3414>
 18ea705:	b8 00 c1 00 00       	mov    $0xc100,%eax
 18ea70a:	0f a3 c8             	bt     %ecx,%eax
 18ea70d:	73 75                	jae    18ea784 <tier0_tables_open+0x3414>
 18ea70f:	48 8b 34 24          	mov    (%rsp),%rsi
 18ea713:	48 8b 46 20          	mov    0x20(%rsi),%rax
 18ea717:	48 8b b6 88 01 00 00 	mov    0x188(%rsi),%rsi
 18ea71e:	8b 04 90             	mov    (%rax,%rdx,4),%eax
 18ea721:	89 c7                	mov    %eax,%edi
 18ea723:	c1 ef 03             	shr    $0x3,%edi
 18ea726:	f6 44 be 01 80       	testb  $0x80,0x1(%rsi,%rdi,4)
 18ea72b:	75 25                	jne    18ea752 <tier0_tables_open+0x33e2>
 18ea72d:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
 18ea732:	8b 74 24 2c          	mov    0x2c(%rsp),%esi
 18ea736:	42 8b 04 a2          	mov    (%rdx,%r12,4),%eax
 18ea73a:	89 f1                	mov    %esi,%ecx
 18ea73c:	ff c6                	inc    %esi
 18ea73e:	89 74 24 2c          	mov    %esi,0x2c(%rsp)
 18ea742:	89 04 8a             	mov    %eax,(%rdx,%rcx,4)
 18ea745:	49 ff c4             	inc    %r12
 18ea748:	4d 39 fc             	cmp    %r15,%r12
 18ea74b:	75 9f                	jne    18ea6ec <tier0_tables_open+0x337c>
 18ea74d:	e9 fe 00 00 00       	jmp    18ea850 <tier0_tables_open+0x34e0>
 18ea752:	80 f9 08             	cmp    $0x8,%cl
 18ea755:	0f 85 5c ff ff ff    	jne    18ea6b7 <tier0_tables_open+0x3347>
 18ea75b:	48 8b 0c 24          	mov    (%rsp),%rcx
 18ea75f:	48 8b 49 38          	mov    0x38(%rcx),%rcx
 18ea763:	48 83 3c d1 00       	cmpq   $0x0,(%rcx,%rdx,8)
 18ea768:	0f 85 49 ff ff ff    	jne    18ea6b7 <tier0_tables_open+0x3347>
 18ea76e:	48 8b 34 24          	mov    (%rsp),%rsi
 18ea772:	4c 89 f7             	mov    %r14,%rdi
 18ea775:	89 c2                	mov    %eax,%edx
 18ea777:	c5 f8 77             	vzeroupper
 18ea77a:	e8 38 9d 0c 00       	call   19b44b7 <abi_wide_classified>
 18ea77f:	e9 bf 00 00 00       	jmp    18ea843 <tier0_tables_open+0x34d3>
 18ea784:	80 e1 fe             	and    $0xfe,%cl
 18ea787:	80 f9 10             	cmp    $0x10,%cl
 18ea78a:	0f 85 27 ff ff ff    	jne    18ea6b7 <tier0_tables_open+0x3347>
 18ea790:	48 8b 04 24          	mov    (%rsp),%rax
 18ea794:	48 8b 40 38          	mov    0x38(%rax),%rax
 18ea798:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
 18ea79c:	48 83 f8 40          	cmp    $0x40,%rax
 18ea7a0:	77 6e                	ja     18ea810 <tier0_tables_open+0x34a0>
 18ea7a2:	48 8b 0c 24          	mov    (%rsp),%rcx
 18ea7a6:	48 8b 49 10          	mov    0x10(%rcx),%rcx
 18ea7aa:	f6 04 11 40          	testb  $0x40,(%rcx,%rdx,1)
 18ea7ae:	75 60                	jne    18ea810 <tier0_tables_open+0x34a0>
 18ea7b0:	48 8b 34 24          	mov    (%rsp),%rsi
 18ea7b4:	48 8b 46 28          	mov    0x28(%rsi),%rax
 18ea7b8:	48 8b 4e 70          	mov    0x70(%rsi),%rcx
 18ea7bc:	48 8b 7e 78          	mov    0x78(%rsi),%rdi
 18ea7c0:	8b 14 90             	mov    (%rax,%rdx,4),%edx
 18ea7c3:	8b 04 91             	mov    (%rcx,%rdx,4),%eax
 18ea7c6:	8b 34 97             	mov    (%rdi,%rdx,4),%esi
 18ea7c9:	01 c6                	add    %eax,%esi
 18ea7cb:	39 f0                	cmp    %esi,%eax
 18ea7cd:	0f 83 e4 fe ff ff    	jae    18ea6b7 <tier0_tables_open+0x3347>
 18ea7d3:	48 8b 14 24          	mov    (%rsp),%rdx
 18ea7d7:	48 ff c0             	inc    %rax
 18ea7da:	89 f6                	mov    %esi,%esi
 18ea7dc:	48 8b 8a b8 00 00 00 	mov    0xb8(%rdx),%rcx
 18ea7e3:	48 8b 92 88 01 00 00 	mov    0x188(%rdx),%rdx
 18ea7ea:	8b 7c 81 fc          	mov    -0x4(%rcx,%rax,4),%edi
 18ea7ee:	c1 ef 03             	shr    $0x3,%edi
 18ea7f1:	8b 3c ba             	mov    (%rdx,%rdi,4),%edi
 18ea7f4:	66 85 ff             	test   %di,%di
 18ea7f7:	79 09                	jns    18ea802 <tier0_tables_open+0x3492>
 18ea7f9:	48 39 f0             	cmp    %rsi,%rax
 18ea7fc:	48 8d 40 01          	lea    0x1(%rax),%rax
 18ea800:	72 e8                	jb     18ea7ea <tier0_tables_open+0x347a>
 18ea802:	66 85 ff             	test   %di,%di
 18ea805:	0f 88 ac fe ff ff    	js     18ea6b7 <tier0_tables_open+0x3347>
 18ea80b:	e9 1d ff ff ff       	jmp    18ea72d <tier0_tables_open+0x33bd>
 18ea810:	80 7c 24 18 00       	cmpb   $0x0,0x18(%rsp)
 18ea815:	75 1d                	jne    18ea834 <tier0_tables_open+0x34c4>
 18ea817:	48 85 c0             	test   %rax,%rax
 18ea81a:	0f 85 97 fe ff ff    	jne    18ea6b7 <tier0_tables_open+0x3347>
 18ea820:	48 8b 04 24          	mov    (%rsp),%rax
 18ea824:	48 8b 40 10          	mov    0x10(%rax),%rax
 18ea828:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
 18ea82c:	24 40                	and    $0x40,%al
 18ea82e:	0f 84 83 fe ff ff    	je     18ea6b7 <tier0_tables_open+0x3347>
 18ea834:	48 8b 34 24          	mov    (%rsp),%rsi
 18ea838:	4c 89 f7             	mov    %r14,%rdi
 18ea83b:	c5 f8 77             	vzeroupper
 18ea83e:	e8 af 9c 0c 00       	call   19b44f2 <abi_members_classified>
 18ea843:	84 c0                	test   %al,%al
 18ea845:	0f 85 6c fe ff ff    	jne    18ea6b7 <tier0_tables_open+0x3347>
 18ea84b:	e9 dd fe ff ff       	jmp    18ea72d <tier0_tables_open+0x33bd>
 18ea850:	64 4c 8b 24 25 10 ff ff ff 	mov    %fs:0xffffffffffffff10,%r12
 18ea859:	4d 85 e4             	test   %r12,%r12
 18ea85c:	74 16                	je     18ea874 <tier0_tables_open+0x3504>
 18ea85e:	64 48 8b 04 25 18 ff ff ff 	mov    %fs:0xffffffffffffff18,%rax
 18ea867:	48 89 84 24 c0 00 00 00 	mov    %rax,0xc0(%rsp)
 18ea86f:	e9 c1 00 00 00       	jmp    18ea935 <tier0_tables_open+0x35c5>
 18ea874:	48 be 00 00 20 00 10 00 00 00 	movabs $0x1000200000,%rsi
 18ea87e:	ba 03 00 00 00       	mov    $0x3,%edx
 18ea883:	b9 22 40 00 00       	mov    $0x4022,%ecx
 18ea888:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
 18ea88e:	31 ff                	xor    %edi,%edi
 18ea890:	45 31 c9             	xor    %r9d,%r9d
 18ea893:	c5 f8 77             	vzeroupper
 18ea896:	e8 f5 f7 ea fe       	call   79a090 <mmap@plt>
 18ea89b:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
 18ea89f:	74 58                	je     18ea8f9 <tier0_tables_open+0x3589>
 18ea8a1:	4c 8d a0 ff ff 20 00 	lea    0x20ffff(%rax),%r12
 18ea8a8:	ba 0f 00 00 00       	mov    $0xf,%edx
 18ea8ad:	48 89 c7             	mov    %rax,%rdi
 18ea8b0:	49 81 e4 00 00 e0 ff 	and    $0xffffffffffe00000,%r12
 18ea8b7:	4d 89 e5             	mov    %r12,%r13
 18ea8ba:	49 29 c5             	sub    %rax,%r13
 18ea8bd:	4c 89 ee             	mov    %r13,%rsi
 18ea8c0:	4d 8d bd 00 00 ff ff 	lea    -0x10000(%r13),%r15
 18ea8c7:	e8 74 f7 ea fe       	call   79a040 <madvise@plt>
 18ea8cc:	48 bd 00 00 20 00 10 00 00 00 	movabs $0x1000200000,%rbp
 18ea8d6:	ba 0e 00 00 00       	mov    $0xe,%edx
 18ea8db:	4c 89 e7             	mov    %r12,%rdi
 18ea8de:	48 89 ee             	mov    %rbp,%rsi
 18ea8e1:	4c 29 ee             	sub    %r13,%rsi
 18ea8e4:	e8 57 f7 ea fe       	call   79a040 <madvise@plt>
 18ea8e9:	49 81 c4 00 00 ff ff 	add    $0xffffffffffff0000,%r12
 18ea8f0:	48 8d 85 00 00 e0 ff 	lea    -0x200000(%rbp),%rax
 18ea8f7:	eb 08                	jmp    18ea901 <tier0_tables_open+0x3591>
 18ea8f9:	45 31 e4             	xor    %r12d,%r12d
 18ea8fc:	31 c0                	xor    %eax,%eax
 18ea8fe:	45 31 ff             	xor    %r15d,%r15d
 18ea901:	64 4c 89 24 25 10 ff ff ff 	mov    %r12,%fs:0xffffffffffffff10
 18ea90a:	64 48 c7 04 25 18 ff ff ff 00 00 00 00 	movq   $0x0,%fs:0xffffffffffffff18
 18ea917:	64 48 89 04 25 20 ff ff ff 	mov    %rax,%fs:0xffffffffffffff20
 18ea920:	64 4c 89 3c 25 28 ff ff ff 	mov    %r15,%fs:0xffffffffffffff28
 18ea929:	48 c7 84 24 c0 00 00 00 00 00 00 00 	movq   $0x0,0xc0(%rsp)
 18ea935:	48 8b 8c 24 c0 00 00 00 	mov    0xc0(%rsp),%rcx
 18ea93d:	4e 8d 7c 21 03       	lea    0x3(%rcx,%r12,1),%r15
 18ea942:	4a 8d 04 21          	lea    (%rcx,%r12,1),%rax
 18ea946:	49 83 e7 fc          	and    $0xfffffffffffffffc,%r15
 18ea94a:	49 39 c7             	cmp    %rax,%r15
 18ea94d:	73 0f                	jae    18ea95e <tier0_tables_open+0x35ee>
 18ea94f:	48 8b 84 24 c0 00 00 00 	mov    0xc0(%rsp),%rax
 18ea957:	31 c9                	xor    %ecx,%ecx
 18ea959:	e9 1d 27 00 00       	jmp    18ed07b <tier0_tables_open+0x5d0b>
 18ea95e:	64 48 8b 34 25 20 ff ff ff 	mov    %fs:0xffffffffffffff20,%rsi
 18ea967:	4c 89 fa             	mov    %r15,%rdx
 18ea96a:	4c 29 e2             	sub    %r12,%rdx
 18ea96d:	31 c9                	xor    %ecx,%ecx
 18ea96f:	48 29 d6             	sub    %rdx,%rsi
 18ea972:	0f 82 5f 04 00 00    	jb     18eadd7 <tier0_tables_open+0x3a67>
 18ea978:	8b ac 24 a0 00 00 00 	mov    0xa0(%rsp),%ebp
 18ea97f:	48 8d 04 ad 00 00 00 00 	lea    0x0(,%rbp,4),%rax
 18ea987:	48 8d 3c 40          	lea    (%rax,%rax,2),%rdi
 18ea98b:	48 8b 84 24 c0 00 00 00 	mov    0xc0(%rsp),%rax
 18ea993:	48 39 f7             	cmp    %rsi,%rdi
 18ea996:	0f 87 df 26 00 00    	ja     18ed07b <tier0_tables_open+0x5d0b>
 18ea99c:	48 01 fa             	add    %rdi,%rdx
 18ea99f:	83 bc 24 a0 00 00 00 00 	cmpl   $0x0,0xa0(%rsp)
 18ea9a7:	64 48 89 14 25 18 ff ff ff 	mov    %rdx,%fs:0xffffffffffffff18
 18ea9b0:	0f 84 2e 04 00 00    	je     18eade4 <tier0_tables_open+0x3a74>
 18ea9b6:	4d 85 ff             	test   %r15,%r15
 18ea9b9:	0f 84 25 04 00 00    	je     18eade4 <tier0_tables_open+0x3a74>
 18ea9bf:	31 db                	xor    %ebx,%ebx
 18ea9c1:	45 31 e4             	xor    %r12d,%r12d
 18ea9c4:	e9 ac 00 00 00       	jmp    18eaa75 <tier0_tables_open+0x3705>
 18ea9c9:	4c 8b 0c 24          	mov    (%rsp),%r9
 18ea9cd:	42 8d 0c ad 00 00 00 00 	lea    0x0(,%r13,4),%ecx
 18ea9d5:	4c 89 ef             	mov    %r13,%rdi
 18ea9d8:	48 c1 e7 04          	shl    $0x4,%rdi
 18ea9dc:	49 8b 41 20          	mov    0x20(%r9),%rax
 18ea9e0:	49 8b 91 80 01 00 00 	mov    0x180(%r9),%rdx
 18ea9e7:	8b 04 08             	mov    (%rax,%rcx,1),%eax
 18ea9ea:	89 c6                	mov    %eax,%esi
 18ea9ec:	c1 ee 03             	shr    $0x3,%esi
 18ea9ef:	83 e0 f8             	and    $0xfffffff8,%eax
 18ea9f2:	49 89 f0             	mov    %rsi,%r8
 18ea9f5:	49 c1 e0 04          	shl    $0x4,%r8
 18ea9f9:	c4 a1 7a 6f 04 02    	vmovdqu (%rdx,%r8,1),%xmm0
 18ea9ff:	c5 fa 7f 04 3a       	vmovdqu %xmm0,(%rdx,%rdi,1)
 18eaa04:	89 f7                	mov    %esi,%edi
 18eaa06:	c1 e7 02             	shl    $0x2,%edi
 18eaa09:	49 8b 91 88 01 00 00 	mov    0x188(%r9),%rdx
 18eaa10:	44 8b 04 3a          	mov    (%rdx,%rdi,1),%r8d
 18eaa14:	44 89 04 0a          	mov    %r8d,(%rdx,%rcx,1)
 18eaa18:	49 8b 91 90 01 00 00 	mov    0x190(%r9),%rdx
 18eaa1f:	8b 3c 3a             	mov    (%rdx,%rdi,1),%edi
 18eaa22:	89 3c 0a             	mov    %edi,(%rdx,%rcx,1)
 18eaa25:	49 8b 89 98 01 00 00 	mov    0x198(%r9),%rcx
 18eaa2c:	0f b6 14 31          	movzbl (%rcx,%rsi,1),%edx
 18eaa30:	42 88 14 29          	mov    %dl,(%rcx,%r13,1)
 18eaa34:	49 8b 89 a0 01 00 00 	mov    0x1a0(%r9),%rcx
 18eaa3b:	0f b6 14 31          	movzbl (%rcx,%rsi,1),%edx
 18eaa3f:	42 8d 34 ed 00 00 00 00 	lea    0x0(,%r13,8),%esi
 18eaa47:	42 88 14 29          	mov    %dl,(%rcx,%r13,1)
 18eaa4b:	49 8b 89 a8 01 00 00 	mov    0x1a8(%r9),%rcx
 18eaa52:	48 8b 14 01          	mov    (%rcx,%rax,1),%rdx
 18eaa56:	48 89 14 31          	mov    %rdx,(%rcx,%rsi,1)
 18eaa5a:	49 8b 89 b0 01 00 00 	mov    0x1b0(%r9),%rcx
 18eaa61:	48 8b 04 01          	mov    (%rcx,%rax,1),%rax
 18eaa65:	48 89 04 31          	mov    %rax,(%rcx,%rsi,1)
 18eaa69:	49 ff c4             	inc    %r12
 18eaa6c:	4c 39 e5             	cmp    %r12,%rbp
 18eaa6f:	0f 84 8a 03 00 00    	je     18eadff <tier0_tables_open+0x3a8f>
 18eaa75:	48 8b 84 24 60 01 00 00 	mov    0x160(%rsp),%rax
 18eaa7d:	48 8b 0c 24          	mov    (%rsp),%rcx
 18eaa81:	42 8b 04 a0          	mov    (%rax,%r12,4),%eax
 18eaa85:	48 8b 31             	mov    (%rcx),%rsi
 18eaa88:	41 89 c5             	mov    %eax,%r13d
 18eaa8b:	41 c1 ed 03          	shr    $0x3,%r13d
 18eaa8f:	42 0f b6 0c 2e       	movzbl (%rsi,%r13,1),%ecx
 18eaa94:	80 f9 0f             	cmp    $0xf,%cl
 18eaa97:	0f 84 2c ff ff ff    	je     18ea9c9 <tier0_tables_open+0x3659>
 18eaa9d:	48 8b 14 24          	mov    (%rsp),%rdx
 18eaaa1:	83 e0 f8             	and    $0xfffffff8,%eax
 18eaaa4:	89 cf                	mov    %ecx,%edi
 18eaaa6:	40 80 e7 fe          	and    $0xfe,%dil
 18eaaaa:	48 8b 52 38          	mov    0x38(%rdx),%rdx
 18eaaae:	48 8b 04 02          	mov    (%rdx,%rax,1),%rax
 18eaab2:	40 80 ff 10          	cmp    $0x10,%dil
 18eaab6:	0f 85 b8 00 00 00    	jne    18eab74 <tier0_tables_open+0x3804>
 18eaabc:	48 8b 14 24          	mov    (%rsp),%rdx
 18eaac0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
 18eaac4:	42 f6 04 2a 40       	testb  $0x40,(%rdx,%r13,1)
 18eaac9:	0f 85 fe 00 00 00    	jne    18eabcd <tier0_tables_open+0x385d>
 18eaacf:	48 83 f8 40          	cmp    $0x40,%rax
 18eaad3:	0f 87 f4 00 00 00    	ja     18eabcd <tier0_tables_open+0x385d>
 18eaad9:	48 83 f8 11          	cmp    $0x11,%rax
 18eaadd:	72 13                	jb     18eaaf2 <tier0_tables_open+0x3782>
 18eaadf:	48 8b 14 24          	mov    (%rsp),%rdx
 18eaae3:	8b 92 bc 01 00 00    	mov    0x1bc(%rdx),%edx
 18eaae9:	48 39 d0             	cmp    %rdx,%rax
 18eaaec:	0f 87 db 00 00 00    	ja     18eabcd <tier0_tables_open+0x385d>
 18eaaf2:	48 8b 34 24          	mov    (%rsp),%rsi
 18eaaf6:	80 f9 10             	cmp    $0x10,%cl
 18eaaf9:	89 df                	mov    %ebx,%edi
 18eaafb:	48 8d 3c 7f          	lea    (%rdi,%rdi,2),%rdi
 18eaaff:	0f 94 c1             	sete   %cl
 18eab02:	48 8b 56 28          	mov    0x28(%rsi),%rdx
 18eab06:	48 8b 76 78          	mov    0x78(%rsi),%rsi
 18eab0a:	42 8b 14 aa          	mov    (%rdx,%r13,4),%edx
 18eab0e:	8b 14 96             	mov    (%rsi,%rdx,4),%edx
 18eab11:	81 fa 00 00 40 00    	cmp    $0x400000,%edx
 18eab17:	40 0f 92 c6          	setb   %sil
 18eab1b:	40 08 ce             	or     %cl,%sil
 18eab1e:	48 83 f8 11          	cmp    $0x11,%rax
 18eab22:	0f 92 c1             	setb   %cl
 18eab25:	41 0f 93 44 bf 0a    	setae  0xa(%r15,%rdi,4)
 18eab2b:	45 89 2c bf          	mov    %r13d,(%r15,%rdi,4)
 18eab2f:	41 89 54 bf 04       	mov    %edx,0x4(%r15,%rdi,4)
 18eab34:	40 20 f1             	and    %sil,%cl
 18eab37:	be 10 00 00 00       	mov    $0x10,%esi
 18eab3c:	48 29 c6             	sub    %rax,%rsi
 18eab3f:	b8 00 00 00 00       	mov    $0x0,%eax
 18eab44:	48 0f 43 c6          	cmovae %rsi,%rax
 18eab48:	ff c3                	inc    %ebx
 18eab4a:	62 f2 7d 08 7a c0    	vpbroadcastb %eax,%xmm0
 18eab50:	62 f3 7d 08 3e 05 25 16 cc fe 01 	vpcmpltub -0x133e9db(%rip),%xmm0,%k0        # 5ac180 <x86_effects_unknown+0x1b0>
 18eab5b:	c5 fb 93 c0          	kmovd  %k0,%eax
 18eab5f:	25 fe ff 00 00       	and    $0xfffe,%eax
 18eab64:	66 41 89 44 bf 08    	mov    %ax,0x8(%r15,%rdi,4)
 18eab6a:	41 88 4c bf 0b       	mov    %cl,0xb(%r15,%rdi,4)
 18eab6f:	e9 f5 fe ff ff       	jmp    18eaa69 <tier0_tables_open+0x36f9>
 18eab74:	80 f9 08             	cmp    $0x8,%cl
 18eab77:	75 74                	jne    18eabed <tier0_tables_open+0x387d>
 18eab79:	48 8b 0c 24          	mov    (%rsp),%rcx
 18eab7d:	48 8b 79 20          	mov    0x20(%rcx),%rdi
 18eab81:	42 8b 0c af          	mov    (%rdi,%r13,4),%ecx
 18eab85:	c1 e9 03             	shr    $0x3,%ecx
 18eab88:	80 3c 0e 0f          	cmpb   $0xf,(%rsi,%rcx,1)
 18eab8c:	48 89 ce             	mov    %rcx,%rsi
 18eab8f:	75 06                	jne    18eab97 <tier0_tables_open+0x3827>
 18eab91:	8b 34 8f             	mov    (%rdi,%rcx,4),%esi
 18eab94:	c1 ee 03             	shr    $0x3,%esi
 18eab97:	48 8b 3c 24          	mov    (%rsp),%rdi
 18eab9b:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
 18eaba1:	48 8b 7f 18          	mov    0x18(%rdi),%rdi
 18eaba5:	0f b6 3c 0f          	movzbl (%rdi,%rcx,1),%edi
 18eaba9:	40 80 ff 07          	cmp    $0x7,%dil
 18eabad:	c4 c2 41 f7 f8       	shlx   %edi,%r8d,%edi
 18eabb2:	41 b8 7f 00 00 00    	mov    $0x7f,%r8d
 18eabb8:	40 f6 d7             	not    %dil
 18eabbb:	40 0f b6 ff          	movzbl %dil,%edi
 18eabbf:	41 0f 43 f8          	cmovae %r8d,%edi
 18eabc3:	48 83 f8 41          	cmp    $0x41,%rax
 18eabc7:	0f 82 a9 00 00 00    	jb     18eac76 <tier0_tables_open+0x3906>
 18eabcd:	48 8b 34 24          	mov    (%rsp),%rsi
 18eabd1:	c4 e2 79 59 05 26 bb cc fe 	vpbroadcastq -0x13344da(%rip),%xmm0        # 5b6700 <x86_semantics_benchmark_code.registers+0x108>
 18eabda:	4c 89 e9             	mov    %r13,%rcx
 18eabdd:	48 c1 e1 04          	shl    $0x4,%rcx
 18eabe1:	48 8b 86 80 01 00 00 	mov    0x180(%rsi),%rax
 18eabe8:	e9 34 01 00 00       	jmp    18ead21 <tier0_tables_open+0x39b1>
 18eabed:	48 8b 34 24          	mov    (%rsp),%rsi
 18eabf1:	4c 89 f7             	mov    %r14,%rdi
 18eabf4:	44 89 ea             	mov    %r13d,%edx
 18eabf7:	c5 f8 77             	vzeroupper
 18eabfa:	e8 81 0e 01 00       	call   18fba80 <abi_simple>
 18eabff:	89 c6                	mov    %eax,%esi
 18eac01:	c1 ee 10             	shr    $0x10,%esi
 18eac04:	48 89 c1             	mov    %rax,%rcx
 18eac07:	48 c1 e9 08          	shr    $0x8,%rcx
 18eac0b:	41 b8 77 00 00 00    	mov    $0x77,%r8d
 18eac11:	89 f7                	mov    %esi,%edi
 18eac13:	40 c0 e7 04          	shl    $0x4,%dil
 18eac17:	40 08 cf             	or     %cl,%dil
 18eac1a:	40 80 fe 07          	cmp    $0x7,%sil
 18eac1e:	40 0f b6 f7          	movzbl %dil,%esi
 18eac22:	41 0f 44 f0          	cmove  %r8d,%esi
 18eac26:	80 f9 07             	cmp    $0x7,%cl
 18eac29:	41 0f 44 f0          	cmove  %r8d,%esi
 18eac2d:	3c 01                	cmp    $0x1,%al
 18eac2f:	0f 85 97 00 00 00    	jne    18eaccc <tier0_tables_open+0x395c>
 18eac35:	c1 e8 18             	shr    $0x18,%eax
 18eac38:	62 f2 7d 08 7a c0    	vpbroadcastb %eax,%xmm0
 18eac3e:	c5 f9 fc 05 3a 15 cc fe 	vpaddb -0x133eac6(%rip),%xmm0,%xmm0        # 5ac180 <x86_effects_unknown+0x1b0>
 18eac46:	89 c8                	mov    %ecx,%eax
 18eac48:	62 f3 7d 08 3e 0d 3d 15 cc fe 06 	vpcmpnleub -0x133eac3(%rip),%xmm0,%k1        # 5ac190 <x86_effects_unknown+0x1c0>
 18eac53:	0c 60                	or     $0x60,%al
 18eac55:	62 f2 7d 08 7a c0    	vpbroadcastb %eax,%xmm0
 18eac5b:	89 c8                	mov    %ecx,%eax
 18eac5d:	c1 e0 04             	shl    $0x4,%eax
 18eac60:	09 c1                	or     %eax,%ecx
 18eac62:	0c 06                	or     $0x6,%al
 18eac64:	62 f2 7d 08 7a c8    	vpbroadcastb %eax,%xmm1
 18eac6a:	62 f2 7d 09 7a c1    	vpbroadcastb %ecx,%xmm0{%k1}
 18eac70:	c5 f9 6c c1          	vpunpcklqdq %xmm1,%xmm0,%xmm0
 18eac74:	eb 5c                	jmp    18eacd2 <tier0_tables_open+0x3962>
 18eac76:	62 f2 7d 08 7a c7    	vpbroadcastb %edi,%xmm0
 18eac7c:	c5 f9 db 05 fc 14 cc fe 	vpand  -0x133eb04(%rip),%xmm0,%xmm0        # 5ac180 <x86_effects_unknown+0x1b0>
 18eac84:	48 8b 34 f2          	mov    (%rdx,%rsi,8),%rsi
 18eac88:	62 f2 7e 08 26 c8    	vptestnmb %xmm0,%xmm0,%k1
 18eac8e:	48 83 f8 11          	cmp    $0x11,%rax
 18eac92:	0f 82 a1 00 00 00    	jb     18ead39 <tier0_tables_open+0x39c9>
 18eac98:	48 39 f0             	cmp    %rsi,%rax
 18eac9b:	75 13                	jne    18eacb0 <tier0_tables_open+0x3940>
 18eac9d:	48 8b 0c 24          	mov    (%rsp),%rcx
 18eaca1:	8b 89 bc 01 00 00    	mov    0x1bc(%rcx),%ecx
 18eaca7:	48 39 c8             	cmp    %rcx,%rax
 18eacaa:	0f 86 be 00 00 00    	jbe    18ead6e <tier0_tables_open+0x39fe>
 18eacb0:	48 8b 34 24          	mov    (%rsp),%rsi
 18eacb4:	c5 f9 6f 05 f4 14 cc fe 	vmovdqa -0x133eb0c(%rip),%xmm0        # 5ac1b0 <x86_effects_unknown+0x1e0>
 18eacbc:	4c 89 e9             	mov    %r13,%rcx
 18eacbf:	48 c1 e1 04          	shl    $0x4,%rcx
 18eacc3:	48 8b 86 80 01 00 00 	mov    0x180(%rsi),%rax
 18eacca:	eb 55                	jmp    18ead21 <tier0_tables_open+0x39b1>
 18eaccc:	62 f2 7d 08 7a c6    	vpbroadcastb %esi,%xmm0
 18eacd2:	b8 10 00 00 00       	mov    $0x10,%eax
 18eacd7:	b9 00 00 00 00       	mov    $0x0,%ecx
 18eacdc:	48 8b 34 24          	mov    (%rsp),%rsi
 18eace0:	48 29 d0             	sub    %rdx,%rax
 18eace3:	48 0f 43 c8          	cmovae %rax,%rcx
 18eace7:	66 b8 01 00          	mov    $0x1,%ax
 18eaceb:	62 f2 7d 08 7a c9    	vpbroadcastb %ecx,%xmm1
 18eacf1:	62 f3 75 08 3e 05 84 14 cc fe 05 	vpcmpnltub -0x133eb7c(%rip),%xmm1,%k0        # 5ac180 <x86_effects_unknown+0x1b0>
 18eacfc:	c4 e2 79 78 0d bb b9 c5 fe 	vpbroadcastb -0x13a4645(%rip),%xmm1        # 5466c0 <branch_sizing_patterns+0xa30>
 18ead05:	c5 fb 92 c8          	kmovd  %eax,%k1
 18ead09:	48 8b 86 80 01 00 00 	mov    0x180(%rsi),%rax
 18ead10:	c5 fc 45 c9          	korw   %k1,%k0,%k1
 18ead14:	62 f2 75 09 66 c0    	vpblendmb %xmm0,%xmm1,%xmm0{%k1}
 18ead1a:	4c 89 e9             	mov    %r13,%rcx
 18ead1d:	48 c1 e1 04          	shl    $0x4,%rcx
 18ead21:	c5 f9 7f 04 08       	vmovdqa %xmm0,(%rax,%rcx,1)
 18ead26:	4c 89 f7             	mov    %r14,%rdi
 18ead29:	44 89 ea             	mov    %r13d,%edx
 18ead2c:	c5 f8 77             	vzeroupper
 18ead2f:	e8 7c 0f 01 00       	call   18fbcb0 <abi_finish>
 18ead34:	e9 30 fd ff ff       	jmp    18eaa69 <tier0_tables_open+0x36f9>
 18ead39:	48 8b 14 24          	mov    (%rsp),%rdx
 18ead3d:	48 8b 52 30          	mov    0x30(%rdx),%rdx
 18ead41:	48 85 f6             	test   %rsi,%rsi
 18ead44:	75 30                	jne    18ead76 <tier0_tables_open+0x3a06>
 18ead46:	4a 83 3c ea 00       	cmpq   $0x0,(%rdx,%r13,8)
 18ead4b:	74 29                	je     18ead76 <tier0_tables_open+0x3a06>
 18ead4d:	48 8b 34 24          	mov    (%rsp),%rsi
 18ead51:	c4 e2 79 78 05 66 b9 c5 fe 	vpbroadcastb -0x13a469a(%rip),%xmm0        # 5466c0 <branch_sizing_patterns+0xa30>
 18ead5a:	48 c1 e1 04          	shl    $0x4,%rcx
 18ead5e:	48 8b 86 80 01 00 00 	mov    0x180(%rsi),%rax
 18ead65:	62 f2 7d 09 66 04 08 	vpblendmb (%rax,%rcx,1),%xmm0,%xmm0{%k1}
 18ead6c:	eb ac                	jmp    18ead1a <tier0_tables_open+0x39aa>
 18ead6e:	48 8b 0c 24          	mov    (%rsp),%rcx
 18ead72:	48 8b 51 30          	mov    0x30(%rcx),%rdx
 18ead76:	be 10 00 00 00       	mov    $0x10,%esi
 18ead7b:	bf 00 00 00 00       	mov    $0x0,%edi
 18ead80:	42 8b 14 ea          	mov    (%rdx,%r13,8),%edx
 18ead84:	c5 fb 93 c9          	kmovd  %k1,%ecx
 18ead88:	48 29 c6             	sub    %rax,%rsi
 18ead8b:	48 0f 43 fe          	cmovae %rsi,%rdi
 18ead8f:	62 f2 7d 08 7a c7    	vpbroadcastb %edi,%xmm0
 18ead95:	62 f3 7d 08 3e 05 e0 13 cc fe 05 	vpcmpnltub -0x133ec20(%rip),%xmm0,%k0        # 5ac180 <x86_effects_unknown+0x1b0>
 18eada0:	c5 fb 93 f0          	kmovd  %k0,%esi
 18eada4:	83 ce 01             	or     $0x1,%esi
 18eada7:	21 f1                	and    %esi,%ecx
 18eada9:	48 83 f8 11          	cmp    $0x11,%rax
 18eadad:	89 d8                	mov    %ebx,%eax
 18eadaf:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
 18eadb3:	f7 d1                	not    %ecx
 18eadb5:	45 89 2c 87          	mov    %r13d,(%r15,%rax,4)
 18eadb9:	41 89 54 87 04       	mov    %edx,0x4(%r15,%rax,4)
 18eadbe:	66 41 89 4c 87 08    	mov    %cx,0x8(%r15,%rax,4)
 18eadc4:	41 0f 93 44 87 0a    	setae  0xa(%r15,%rax,4)
 18eadca:	41 0f 92 44 87 0b    	setb   0xb(%r15,%rax,4)
 18eadd0:	ff c3                	inc    %ebx
 18eadd2:	e9 92 fc ff ff       	jmp    18eaa69 <tier0_tables_open+0x36f9>
 18eadd7:	48 8b 84 24 c0 00 00 00 	mov    0xc0(%rsp),%rax
 18eaddf:	e9 97 22 00 00       	jmp    18ed07b <tier0_tables_open+0x5d0b>
 18eade4:	c7 84 24 b4 00 00 00 00 00 00 00 	movl   $0x0,0xb4(%rsp)
 18eadef:	4d 85 ff             	test   %r15,%r15
 18eadf2:	0f 84 b9 01 00 00    	je     18eafb1 <tier0_tables_open+0x3c41>
 18eadf8:	31 db                	xor    %ebx,%ebx
 18eadfa:	48 89 d0             	mov    %rdx,%rax
 18eadfd:	eb 1f                	jmp    18eae1e <tier0_tables_open+0x3aae>
 18eadff:	64 48 8b 04 25 18 ff ff ff 	mov    %fs:0xffffffffffffff18,%rax
 18eae08:	64 4c 8b 24 25 10 ff ff ff 	mov    %fs:0xffffffffffffff10,%r12
 18eae11:	8d 4b 03             	lea    0x3(%rbx),%ecx
 18eae14:	c1 e9 02             	shr    $0x2,%ecx
 18eae17:	89 8c 24 b4 00 00 00 	mov    %ecx,0xb4(%rsp)
 18eae1e:	4a 8d 54 20 03       	lea    0x3(%rax,%r12,1),%rdx
 18eae23:	89 d9                	mov    %ebx,%ecx
 18eae25:	48 89 8c 24 98 00 00 00 	mov    %rcx,0x98(%rsp)
 18eae2d:	4a 8d 0c 20          	lea    (%rax,%r12,1),%rcx
 18eae31:	48 83 e2 fc          	and    $0xfffffffffffffffc,%rdx
 18eae35:	48 39 ca             	cmp    %rcx,%rdx
 18eae38:	72 54                	jb     18eae8e <tier0_tables_open+0x3b1e>
 18eae3a:	64 4c 8b 04 25 20 ff ff ff 	mov    %fs:0xffffffffffffff20,%r8
 18eae43:	48 89 d6             	mov    %rdx,%rsi
 18eae46:	4c 29 e6             	sub    %r12,%rsi
 18eae49:	49 29 f0             	sub    %rsi,%r8
 18eae4c:	72 40                	jb     18eae8e <tier0_tables_open+0x3b1e>
 18eae4e:	48 8b bc 24 98 00 00 00 	mov    0x98(%rsp),%rdi
 18eae56:	41 b9 00 00 00 00    	mov    $0x0,%r9d
 18eae5c:	4c 89 4c 24 78       	mov    %r9,0x78(%rsp)
 18eae61:	48 8d 3c bd 00 00 00 00 	lea    0x0(,%rdi,4),%rdi
 18eae69:	48 8d 3c 7f          	lea    (%rdi,%rdi,2),%rdi
 18eae6d:	4c 39 c7             	cmp    %r8,%rdi
 18eae70:	77 25                	ja     18eae97 <tier0_tables_open+0x3b27>
 18eae72:	48 01 fe             	add    %rdi,%rsi
 18eae75:	48 89 d1             	mov    %rdx,%rcx
 18eae78:	48 01 f9             	add    %rdi,%rcx
 18eae7b:	48 89 54 24 78       	mov    %rdx,0x78(%rsp)
 18eae80:	48 89 f0             	mov    %rsi,%rax
 18eae83:	64 48 89 34 25 18 ff ff ff 	mov    %rsi,%fs:0xffffffffffffff18
 18eae8c:	eb 09                	jmp    18eae97 <tier0_tables_open+0x3b27>
 18eae8e:	48 c7 44 24 78 00 00 00 00 	movq   $0x0,0x78(%rsp)
 18eae97:	8b 94 24 b4 00 00 00 	mov    0xb4(%rsp),%edx
 18eae9e:	48 89 94 24 50 01 00 00 	mov    %rdx,0x150(%rsp)
 18eaea6:	48 8d 51 07          	lea    0x7(%rcx),%rdx
 18eaeaa:	48 83 e2 f8          	and    $0xfffffffffffffff8,%rdx
 18eaeae:	48 39 ca             	cmp    %rcx,%rdx
 18eaeb1:	72 50                	jb     18eaf03 <tier0_tables_open+0x3b93>
 18eaeb3:	64 48 8b 34 25 20 ff ff ff 	mov    %fs:0xffffffffffffff20,%rsi
 18eaebc:	48 89 d1             	mov    %rdx,%rcx
 18eaebf:	4c 29 e1             	sub    %r12,%rcx
 18eaec2:	48 29 ce             	sub    %rcx,%rsi
 18eaec5:	72 3c                	jb     18eaf03 <tier0_tables_open+0x3b93>
 18eaec7:	48 8b bc 24 50 01 00 00 	mov    0x150(%rsp),%rdi
 18eaecf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
 18eaed5:	4c 89 84 24 20 01 00 00 	mov    %r8,0x120(%rsp)
 18eaedd:	48 c1 e7 04          	shl    $0x4,%rdi
 18eaee1:	48 8d 3c 7f          	lea    (%rdi,%rdi,2),%rdi
 18eaee5:	48 39 f7             	cmp    %rsi,%rdi
 18eaee8:	77 25                	ja     18eaf0f <tier0_tables_open+0x3b9f>
 18eaeea:	48 01 f9             	add    %rdi,%rcx
 18eaeed:	48 89 94 24 20 01 00 00 	mov    %rdx,0x120(%rsp)
 18eaef5:	48 89 c8             	mov    %rcx,%rax
 18eaef8:	64 48 89 0c 25 18 ff ff ff 	mov    %rcx,%fs:0xffffffffffffff18
 18eaf01:	eb 0c                	jmp    18eaf0f <tier0_tables_open+0x3b9f>
 18eaf03:	48 c7 84 24 20 01 00 00 00 00 00 00 	movq   $0x0,0x120(%rsp)
 18eaf0f:	48 83 bc 24 98 00 00 00 00 	cmpq   $0x0,0x98(%rsp)
 18eaf18:	74 73                	je     18eaf8d <tier0_tables_open+0x3c1d>
 18eaf1a:	31 c9                	xor    %ecx,%ecx
 18eaf1c:	48 83 7c 24 78 00    	cmpq   $0x0,0x78(%rsp)
 18eaf22:	0f 84 53 21 00 00    	je     18ed07b <tier0_tables_open+0x5d0b>
 18eaf28:	48 83 bc 24 20 01 00 00 00 	cmpq   $0x0,0x120(%rsp)
 18eaf31:	0f 84 44 21 00 00    	je     18ed07b <tier0_tables_open+0x5d0b>
 18eaf37:	48 8b 8c 24 98 00 00 00 	mov    0x98(%rsp),%rcx
 18eaf3f:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 18eaf43:	62 f1 fe 48 7f 84 24 70 02 00 00 	vmovdqu64 %zmm0,0x270(%rsp)
 18eaf4e:	62 f1 fe 48 7f 84 24 30 02 00 00 	vmovdqu64 %zmm0,0x230(%rsp)
 18eaf59:	62 f1 fe 48 7f 84 24 f0 01 00 00 	vmovdqu64 %zmm0,0x1f0(%rsp)
 18eaf64:	62 f1 fe 48 7f 84 24 b0 01 00 00 	vmovdqu64 %zmm0,0x1b0(%rsp)
 18eaf6f:	c7 84 24 b0 02 00 00 00 00 00 00 	movl   $0x0,0x2b0(%rsp)
 18eaf7a:	89 c8                	mov    %ecx,%eax
 18eaf7c:	83 e0 07             	and    $0x7,%eax
 18eaf7f:	83 f9 08             	cmp    $0x8,%ecx
 18eaf82:	73 37                	jae    18eafbb <tier0_tables_open+0x3c4b>
 18eaf84:	31 c9                	xor    %ecx,%ecx
 18eaf86:	31 ff                	xor    %edi,%edi
 18eaf88:	e9 4f 01 00 00       	jmp    18eb0dc <tier0_tables_open+0x3d6c>
 18eaf8d:	48 39 84 24 c0 00 00 00 	cmp    %rax,0xc0(%rsp)
 18eaf95:	0f 87 87 21 00 00    	ja     18ed122 <tier0_tables_open+0x5db2>
 18eaf9b:	48 8b 84 24 c0 00 00 00 	mov    0xc0(%rsp),%rax
 18eafa3:	64 48 89 04 25 18 ff ff ff 	mov    %rax,%fs:0xffffffffffffff18
 18eafac:	e9 0b 21 00 00       	jmp    18ed0bc <tier0_tables_open+0x5d4c>
 18eafb1:	48 89 d0             	mov    %rdx,%rax
 18eafb4:	31 c9                	xor    %ecx,%ecx
 18eafb6:	e9 c0 20 00 00       	jmp    18ed07b <tier0_tables_open+0x5d0b>
 18eafbb:	48 8b 94 24 98 00 00 00 	mov    0x98(%rsp),%rdx
 18eafc3:	83 e2 f8             	and    $0xfffffff8,%edx
 18eafc6:	49 8d 77 04          	lea    0x4(%r15),%rsi
 18eafca:	31 c9                	xor    %ecx,%ecx
 18eafcc:	31 ff                	xor    %edi,%edi
 18eafce:	eb 11                	jmp    18eafe1 <tier0_tables_open+0x3c71>
 18eafd0:	48 83 c1 08          	add    $0x8,%rcx
 18eafd4:	48 83 c6 60          	add    $0x60,%rsi
 18eafd8:	48 39 ca             	cmp    %rcx,%rdx
 18eafdb:	0f 84 f6 00 00 00    	je     18eb0d7 <tier0_tables_open+0x3d67>
 18eafe1:	44 8b 06             	mov    (%rsi),%r8d
 18eafe4:	41 b9 3f 00 00 00    	mov    $0x3f,%r9d
 18eafea:	41 83 f8 3f          	cmp    $0x3f,%r8d
 18eafee:	45 0f 43 c1          	cmovae %r9d,%r8d
 18eaff2:	41 ff c0             	inc    %r8d
 18eaff5:	42 ff 84 84 b0 01 00 00 	incl   0x1b0(%rsp,%r8,4)
 18eaffd:	41 39 f8             	cmp    %edi,%r8d
 18eb000:	77 03                	ja     18eb005 <tier0_tables_open+0x3c95>
 18eb002:	41 89 f8             	mov    %edi,%r8d
 18eb005:	8b 7e 0c             	mov    0xc(%rsi),%edi
 18eb008:	83 ff 3f             	cmp    $0x3f,%edi
 18eb00b:	41 0f 43 f9          	cmovae %r9d,%edi
 18eb00f:	ff c7                	inc    %edi
 18eb011:	ff 84 bc b0 01 00 00 	incl   0x1b0(%rsp,%rdi,4)
 18eb018:	44 39 c7             	cmp    %r8d,%edi
 18eb01b:	77 03                	ja     18eb020 <tier0_tables_open+0x3cb0>
 18eb01d:	44 89 c7             	mov    %r8d,%edi
 18eb020:	44 8b 46 18          	mov    0x18(%rsi),%r8d
 18eb024:	41 83 f8 3f          	cmp    $0x3f,%r8d
 18eb028:	45 0f 43 c1          	cmovae %r9d,%r8d
 18eb02c:	41 ff c0             	inc    %r8d
 18eb02f:	42 ff 84 84 b0 01 00 00 	incl   0x1b0(%rsp,%r8,4)
 18eb037:	41 39 f8             	cmp    %edi,%r8d
 18eb03a:	77 03                	ja     18eb03f <tier0_tables_open+0x3ccf>
 18eb03c:	41 89 f8             	mov    %edi,%r8d
 18eb03f:	8b 7e 24             	mov    0x24(%rsi),%edi
 18eb042:	83 ff 3f             	cmp    $0x3f,%edi
 18eb045:	41 0f 43 f9          	cmovae %r9d,%edi
 18eb049:	ff c7                	inc    %edi
 18eb04b:	ff 84 bc b0 01 00 00 	incl   0x1b0(%rsp,%rdi,4)
 18eb052:	44 39 c7             	cmp    %r8d,%edi
 18eb055:	77 03                	ja     18eb05a <tier0_tables_open+0x3cea>
 18eb057:	44 89 c7             	mov    %r8d,%edi
 18eb05a:	44 8b 46 30          	mov    0x30(%rsi),%r8d
 18eb05e:	41 83 f8 3f          	cmp    $0x3f,%r8d
 18eb062:	45 0f 43 c1          	cmovae %r9d,%r8d
 18eb066:	41 ff c0             	inc    %r8d
 18eb069:	42 ff 84 84 b0 01 00 00 	incl   0x1b0(%rsp,%r8,4)
 18eb071:	41 39 f8             	cmp    %edi,%r8d
 18eb074:	77 03                	ja     18eb079 <tier0_tables_open+0x3d09>
 18eb076:	41 89 f8             	mov    %edi,%r8d
 18eb079:	8b 7e 3c             	mov    0x3c(%rsi),%edi
 18eb07c:	83 ff 3f             	cmp    $0x3f,%edi
 18eb07f:	41 0f 43 f9          	cmovae %r9d,%edi
 18eb083:	ff c7                	inc    %edi
 18eb085:	ff 84 bc b0 01 00 00 	incl   0x1b0(%rsp,%rdi,4)
 18eb08c:	44 39 c7             	cmp    %r8d,%edi
 18eb08f:	77 03                	ja     18eb094 <tier0_tables_open+0x3d24>
 18eb091:	44 89 c7             	mov    %r8d,%edi
 18eb094:	44 8b 46 48          	mov    0x48(%rsi),%r8d
 18eb098:	41 83 f8 3f          	cmp    $0x3f,%r8d
 18eb09c:	45 0f 43 c1          	cmovae %r9d,%r8d
 18eb0a0:	41 ff c0             	inc    %r8d
 18eb0a3:	42 ff 84 84 b0 01 00 00 	incl   0x1b0(%rsp,%r8,4)
 18eb0ab:	41 39 f8             	cmp    %edi,%r8d
 18eb0ae:	77 03                	ja     18eb0b3 <tier0_tables_open+0x3d43>
 18eb0b0:	41 89 f8             	mov    %edi,%r8d
 18eb0b3:	8b 7e 54             	mov    0x54(%rsi),%edi
 18eb0b6:	83 ff 3f             	cmp    $0x3f,%edi
 18eb0b9:	41 0f 43 f9          	cmovae %r9d,%edi
 18eb0bd:	ff c7                	inc    %edi
 18eb0bf:	ff 84 bc b0 01 00 00 	incl   0x1b0(%rsp,%rdi,4)
 18eb0c6:	44 39 c7             	cmp    %r8d,%edi
 18eb0c9:	0f 87 01 ff ff ff    	ja     18eafd0 <tier0_tables_open+0x3c60>
 18eb0cf:	44 89 c7             	mov    %r8d,%edi
 18eb0d2:	e9 f9 fe ff ff       	jmp    18eafd0 <tier0_tables_open+0x3c60>
 18eb0d7:	48 85 c0             	test   %rax,%rax
 18eb0da:	74 3b                	je     18eb117 <tier0_tables_open+0x3da7>
 18eb0dc:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
 18eb0e0:	c1 e0 02             	shl    $0x2,%eax
 18eb0e3:	31 d2                	xor    %edx,%edx
 18eb0e5:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
 18eb0e9:	49 8d 4c 8f 04       	lea    0x4(%r15,%rcx,4),%rcx
 18eb0ee:	89 fe                	mov    %edi,%esi
 18eb0f0:	8b 3c 11             	mov    (%rcx,%rdx,1),%edi
 18eb0f3:	41 b8 3f 00 00 00    	mov    $0x3f,%r8d
 18eb0f9:	83 ff 3f             	cmp    $0x3f,%edi
 18eb0fc:	41 0f 43 f8          	cmovae %r8d,%edi
 18eb100:	ff c7                	inc    %edi
 18eb102:	ff 84 bc b0 01 00 00 	incl   0x1b0(%rsp,%rdi,4)
 18eb109:	39 f7                	cmp    %esi,%edi
 18eb10b:	0f 46 fe             	cmovbe %esi,%edi
 18eb10e:	48 83 c2 0c          	add    $0xc,%rdx
 18eb112:	48 39 d0             	cmp    %rdx,%rax
 18eb115:	75 d7                	jne    18eb0ee <tier0_tables_open+0x3d7e>
 18eb117:	89 fa                	mov    %edi,%edx
 18eb119:	89 d0                	mov    %edx,%eax
 18eb11b:	83 e0 07             	and    $0x7,%eax
 18eb11e:	ff cf                	dec    %edi
 18eb120:	83 ff 07             	cmp    $0x7,%edi
 18eb123:	73 09                	jae    18eb12e <tier0_tables_open+0x3dbe>
 18eb125:	31 c9                	xor    %ecx,%ecx
 18eb127:	31 f6                	xor    %esi,%esi
 18eb129:	e9 88 00 00 00       	jmp    18eb1b6 <tier0_tables_open+0x3e46>
 18eb12e:	81 e2 f8 ff ff 7f    	and    $0x7ffffff8,%edx
 18eb134:	31 c9                	xor    %ecx,%ecx
 18eb136:	31 f6                	xor    %esi,%esi
 18eb138:	03 8c b4 b4 01 00 00 	add    0x1b4(%rsp,%rsi,4),%ecx
 18eb13f:	89 8c b4 b4 01 00 00 	mov    %ecx,0x1b4(%rsp,%rsi,4)
 18eb146:	03 8c b4 b8 01 00 00 	add    0x1b8(%rsp,%rsi,4),%ecx
 18eb14d:	89 8c b4 b8 01 00 00 	mov    %ecx,0x1b8(%rsp,%rsi,4)
 18eb154:	03 8c b4 bc 01 00 00 	add    0x1bc(%rsp,%rsi,4),%ecx
 18eb15b:	89 8c b4 bc 01 00 00 	mov    %ecx,0x1bc(%rsp,%rsi,4)
 18eb162:	03 8c b4 c0 01 00 00 	add    0x1c0(%rsp,%rsi,4),%ecx
 18eb169:	89 8c b4 c0 01 00 00 	mov    %ecx,0x1c0(%rsp,%rsi,4)
 18eb170:	03 8c b4 c4 01 00 00 	add    0x1c4(%rsp,%rsi,4),%ecx
 18eb177:	89 8c b4 c4 01 00 00 	mov    %ecx,0x1c4(%rsp,%rsi,4)
 18eb17e:	03 8c b4 c8 01 00 00 	add    0x1c8(%rsp,%rsi,4),%ecx
 18eb185:	89 8c b4 c8 01 00 00 	mov    %ecx,0x1c8(%rsp,%rsi,4)
 18eb18c:	03 8c b4 cc 01 00 00 	add    0x1cc(%rsp,%rsi,4),%ecx
 18eb193:	89 8c b4 cc 01 00 00 	mov    %ecx,0x1cc(%rsp,%rsi,4)
 18eb19a:	03 8c b4 d0 01 00 00 	add    0x1d0(%rsp,%rsi,4),%ecx
 18eb1a1:	89 8c b4 d0 01 00 00 	mov    %ecx,0x1d0(%rsp,%rsi,4)
 18eb1a8:	48 83 c6 08          	add    $0x8,%rsi
 18eb1ac:	48 39 f2             	cmp    %rsi,%rdx
 18eb1af:	75 87                	jne    18eb138 <tier0_tables_open+0x3dc8>
 18eb1b1:	48 85 c0             	test   %rax,%rax
 18eb1b4:	74 1c                	je     18eb1d2 <tier0_tables_open+0x3e62>
 18eb1b6:	48 8d 94 24 b4 01 00 00 	lea    0x1b4(%rsp),%rdx
 18eb1be:	48 8d 14 b2          	lea    (%rdx,%rsi,4),%rdx
 18eb1c2:	31 f6                	xor    %esi,%esi
 18eb1c4:	03 0c b2             	add    (%rdx,%rsi,4),%ecx
 18eb1c7:	89 0c b2             	mov    %ecx,(%rdx,%rsi,4)
 18eb1ca:	48 ff c6             	inc    %rsi
 18eb1cd:	48 39 f0             	cmp    %rsi,%rax
 18eb1d0:	75 f2                	jne    18eb1c4 <tier0_tables_open+0x3e54>
 18eb1d2:	48 8b 8c 24 98 00 00 00 	mov    0x98(%rsp),%rcx
 18eb1da:	89 c8                	mov    %ecx,%eax
 18eb1dc:	83 e0 03             	and    $0x3,%eax
 18eb1df:	83 f9 04             	cmp    $0x4,%ecx
 18eb1e2:	73 07                	jae    18eb1eb <tier0_tables_open+0x3e7b>
 18eb1e4:	31 c9                	xor    %ecx,%ecx
 18eb1e6:	e9 f9 00 00 00       	jmp    18eb2e4 <tier0_tables_open+0x3f74>
 18eb1eb:	48 8b 94 24 98 00 00 00 	mov    0x98(%rsp),%rdx
 18eb1f3:	83 e2 fc             	and    $0xfffffffc,%edx
 18eb1f6:	49 8d 77 28          	lea    0x28(%r15),%rsi
 18eb1fa:	31 c9                	xor    %ecx,%ecx
 18eb1fc:	8b 7e dc             	mov    -0x24(%rsi),%edi
 18eb1ff:	41 bb 3f 00 00 00    	mov    $0x3f,%r11d
 18eb205:	44 8b 56 e0          	mov    -0x20(%rsi),%r10d
 18eb209:	4c 8b 64 24 78       	mov    0x78(%rsp),%r12
 18eb20e:	83 ff 3f             	cmp    $0x3f,%edi
 18eb211:	41 0f 43 fb          	cmovae %r11d,%edi
 18eb215:	44 8b 84 bc b0 01 00 00 	mov    0x1b0(%rsp,%rdi,4),%r8d
 18eb21d:	4f 8d 0c 40          	lea    (%r8,%r8,2),%r9
 18eb221:	41 ff c0             	inc    %r8d
 18eb224:	47 89 54 8c 08       	mov    %r10d,0x8(%r12,%r9,4)
 18eb229:	4c 8b 56 d8          	mov    -0x28(%rsi),%r10
 18eb22d:	4f 89 14 8c          	mov    %r10,(%r12,%r9,4)
 18eb231:	44 89 84 bc b0 01 00 00 	mov    %r8d,0x1b0(%rsp,%rdi,4)
 18eb239:	8b 7e e8             	mov    -0x18(%rsi),%edi
 18eb23c:	44 8b 56 ec          	mov    -0x14(%rsi),%r10d
 18eb240:	83 ff 3f             	cmp    $0x3f,%edi
 18eb243:	41 0f 43 fb          	cmovae %r11d,%edi
 18eb247:	44 8b 84 bc b0 01 00 00 	mov    0x1b0(%rsp,%rdi,4),%r8d
 18eb24f:	4f 8d 0c 40          	lea    (%r8,%r8,2),%r9
 18eb253:	41 ff c0             	inc    %r8d
 18eb256:	47 89 54 8c 08       	mov    %r10d,0x8(%r12,%r9,4)
 18eb25b:	4c 8b 56 e4          	mov    -0x1c(%rsi),%r10
 18eb25f:	4f 89 14 8c          	mov    %r10,(%r12,%r9,4)
 18eb263:	44 89 84 bc b0 01 00 00 	mov    %r8d,0x1b0(%rsp,%rdi,4)
 18eb26b:	8b 7e f4             	mov    -0xc(%rsi),%edi
 18eb26e:	44 8b 56 f8          	mov    -0x8(%rsi),%r10d
 18eb272:	83 ff 3f             	cmp    $0x3f,%edi
 18eb275:	41 0f 43 fb          	cmovae %r11d,%edi
 18eb279:	44 8b 84 bc b0 01 00 00 	mov    0x1b0(%rsp,%rdi,4),%r8d
 18eb281:	4f 8d 0c 40          	lea    (%r8,%r8,2),%r9
 18eb285:	41 ff c0             	inc    %r8d
 18eb288:	47 89 54 8c 08       	mov    %r10d,0x8(%r12,%r9,4)
 18eb28d:	4c 8b 56 f0          	mov    -0x10(%rsi),%r10
 18eb291:	4f 89 14 8c          	mov    %r10,(%r12,%r9,4)
 18eb295:	44 89 84 bc b0 01 00 00 	mov    %r8d,0x1b0(%rsp,%rdi,4)
 18eb29d:	8b 3e                	mov    (%rsi),%edi
 18eb29f:	44 8b 56 04          	mov    0x4(%rsi),%r10d
 18eb2a3:	83 ff 3f             	cmp    $0x3f,%edi
 18eb2a6:	41 0f 43 fb          	cmovae %r11d,%edi
 18eb2aa:	48 83 c1 04          	add    $0x4,%rcx
 18eb2ae:	44 8b 84 bc b0 01 00 00 	mov    0x1b0(%rsp,%rdi,4),%r8d
 18eb2b6:	4f 8d 0c 40          	lea    (%r8,%r8,2),%r9
 18eb2ba:	41 ff c0             	inc    %r8d
 18eb2bd:	47 89 54 8c 08       	mov    %r10d,0x8(%r12,%r9,4)
 18eb2c2:	4c 8b 56 fc          	mov    -0x4(%rsi),%r10
 18eb2c6:	48 83 c6 30          	add    $0x30,%rsi
 18eb2ca:	4f 89 14 8c          	mov    %r10,(%r12,%r9,4)
 18eb2ce:	44 89 84 bc b0 01 00 00 	mov    %r8d,0x1b0(%rsp,%rdi,4)
 18eb2d6:	48 39 ca             	cmp    %rcx,%rdx
 18eb2d9:	0f 85 1d ff ff ff    	jne    18eb1fc <tier0_tables_open+0x3e8c>
 18eb2df:	48 85 c0             	test   %rax,%rax
 18eb2e2:	74 55                	je     18eb339 <tier0_tables_open+0x3fc9>
 18eb2e4:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
 18eb2e8:	c1 e0 02             	shl    $0x2,%eax
 18eb2eb:	31 d2                	xor    %edx,%edx
 18eb2ed:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
 18eb2f1:	49 8d 4c 8f 04       	lea    0x4(%r15,%rcx,4),%rcx
 18eb2f6:	8b 34 11             	mov    (%rcx,%rdx,1),%esi
 18eb2f9:	bf 3f 00 00 00       	mov    $0x3f,%edi
 18eb2fe:	44 8b 4c 11 04       	mov    0x4(%rcx,%rdx,1),%r9d
 18eb303:	4c 8b 54 24 78       	mov    0x78(%rsp),%r10
 18eb308:	83 fe 3f             	cmp    $0x3f,%esi
 18eb30b:	0f 43 f7             	cmovae %edi,%esi
 18eb30e:	8b bc b4 b0 01 00 00 	mov    0x1b0(%rsp,%rsi,4),%edi
 18eb315:	4c 8d 04 7f          	lea    (%rdi,%rdi,2),%r8
 18eb319:	ff c7                	inc    %edi
 18eb31b:	47 89 4c 82 08       	mov    %r9d,0x8(%r10,%r8,4)
 18eb320:	4c 8b 4c 11 fc       	mov    -0x4(%rcx,%rdx,1),%r9
 18eb325:	48 83 c2 0c          	add    $0xc,%rdx
 18eb329:	4f 89 0c 82          	mov    %r9,(%r10,%r8,4)
 18eb32d:	89 bc b4 b0 01 00 00 	mov    %edi,0x1b0(%rsp,%rsi,4)
 18eb334:	48 39 d0             	cmp    %rdx,%rax
 18eb337:	75 bd                	jne    18eb2f6 <tier0_tables_open+0x3f86>
 18eb339:	83 bc 24 b4 00 00 00 00 	cmpl   $0x0,0xb4(%rsp)
 18eb341:	0f 84 a8 01 00 00    	je     18eb4ef <tier0_tables_open+0x417f>
 18eb347:	48 8b 84 24 50 01 00 00 	mov    0x150(%rsp),%rax
 18eb34f:	b9 0a 00 00 00       	mov    $0xa,%ecx
 18eb354:	31 d2                	xor    %edx,%edx
 18eb356:	31 ff                	xor    %edi,%edi
 18eb358:	8d 1c 85 00 00 00 00 	lea    0x0(,%rax,4),%ebx
 18eb35f:	eb 66                	jmp    18eb3c7 <tier0_tables_open+0x4057>
 18eb361:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
 18eb367:	bd ff ff ff ff       	mov    $0xffffffff,%ebp
 18eb36c:	41 bb ff ff ff ff    	mov    $0xffffffff,%r11d
 18eb372:	45 31 c0             	xor    %r8d,%r8d
 18eb375:	45 31 c9             	xor    %r9d,%r9d
 18eb378:	45 31 d2             	xor    %r10d,%r10d
 18eb37b:	48 8b 84 24 20 01 00 00 	mov    0x120(%rsp),%rax
 18eb383:	48 83 c2 04          	add    $0x4,%rdx
 18eb387:	44 89 5c 88 d8       	mov    %r11d,-0x28(%rax,%rcx,4)
 18eb38c:	89 6c 88 dc          	mov    %ebp,-0x24(%rax,%rcx,4)
 18eb390:	44 89 7c 88 e0       	mov    %r15d,-0x20(%rax,%rcx,4)
 18eb395:	89 7c 88 e4          	mov    %edi,-0x1c(%rax,%rcx,4)
 18eb399:	44 89 cf             	mov    %r9d,%edi
 18eb39c:	48 89 74 88 e8       	mov    %rsi,-0x18(%rax,%rcx,4)
 18eb3a1:	44 89 4c 88 f0       	mov    %r9d,-0x10(%rax,%rcx,4)
 18eb3a6:	c7 44 88 f4 00 00 00 00 	movl   $0x0,-0xc(%rax,%rcx,4)
 18eb3ae:	4c 89 44 88 f8       	mov    %r8,-0x8(%rax,%rcx,4)
 18eb3b3:	4c 89 14 88          	mov    %r10,(%rax,%rcx,4)
 18eb3b7:	48 01 f7             	add    %rsi,%rdi
 18eb3ba:	48 83 c1 0c          	add    $0xc,%rcx
 18eb3be:	48 39 d3             	cmp    %rdx,%rbx
 18eb3c1:	0f 84 1e 01 00 00    	je     18eb4e5 <tier0_tables_open+0x4175>
 18eb3c7:	48 89 fe             	mov    %rdi,%rsi
 18eb3ca:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 18eb3cf:	48 3b 94 24 98 00 00 00 	cmp    0x98(%rsp),%rdx
 18eb3d7:	73 88                	jae    18eb361 <tier0_tables_open+0x3ff1>
 18eb3d9:	48 8b 44 24 78       	mov    0x78(%rsp),%rax
 18eb3de:	4c 8d 7a 01          	lea    0x1(%rdx),%r15
 18eb3e2:	44 0f b6 54 88 e2    	movzbl -0x1e(%rax,%rcx,4),%r10d
 18eb3e8:	44 8b 5c 88 d8       	mov    -0x28(%rax,%rcx,4),%r11d
 18eb3ed:	44 8b 4c 88 dc       	mov    -0x24(%rax,%rcx,4),%r9d
 18eb3f2:	44 0f b7 44 88 e0    	movzwl -0x20(%rax,%rcx,4),%r8d
 18eb3f8:	41 83 e2 01          	and    $0x1,%r10d
 18eb3fc:	4c 3b bc 24 98 00 00 00 	cmp    0x98(%rsp),%r15
 18eb404:	0f 83 c0 00 00 00    	jae    18eb4ca <tier0_tables_open+0x415a>
 18eb40a:	48 8b 44 24 78       	mov    0x78(%rsp),%rax
 18eb40f:	44 8b 7c 88 e8       	mov    -0x18(%rax,%rcx,4),%r15d
 18eb414:	44 0f b6 64 88 ee    	movzbl -0x12(%rax,%rcx,4),%r12d
 18eb41a:	8b 6c 88 e4          	mov    -0x1c(%rax,%rcx,4),%ebp
 18eb41e:	45 39 cf             	cmp    %r9d,%r15d
 18eb421:	45 0f 47 cf          	cmova  %r15d,%r9d
 18eb425:	44 8b 7c 88 ec       	mov    -0x14(%rax,%rcx,4),%r15d
 18eb42a:	41 83 e4 01          	and    $0x1,%r12d
 18eb42e:	48 8d 42 02          	lea    0x2(%rdx),%rax
 18eb432:	41 c1 e4 10          	shl    $0x10,%r12d
 18eb436:	4d 09 e2             	or     %r12,%r10
 18eb439:	41 c1 e7 10          	shl    $0x10,%r15d
 18eb43d:	4d 09 f8             	or     %r15,%r8
 18eb440:	48 3b 84 24 98 00 00 00 	cmp    0x98(%rsp),%rax
 18eb448:	0f 83 8c 00 00 00    	jae    18eb4da <tier0_tables_open+0x416a>
 18eb44e:	48 8b 44 24 78       	mov    0x78(%rsp),%rax
 18eb453:	44 8b 64 88 f4       	mov    -0xc(%rax,%rcx,4),%r12d
 18eb458:	44 8b 7c 88 f0       	mov    -0x10(%rax,%rcx,4),%r15d
 18eb45d:	44 0f b7 6c 88 f8    	movzwl -0x8(%rax,%rcx,4),%r13d
 18eb463:	0f b6 44 88 fa       	movzbl -0x6(%rax,%rcx,4),%eax
 18eb468:	45 39 cc             	cmp    %r9d,%r12d
 18eb46b:	45 0f 47 cc          	cmova  %r12d,%r9d
 18eb46f:	83 e0 01             	and    $0x1,%eax
 18eb472:	49 c1 e5 20          	shl    $0x20,%r13
 18eb476:	4c 8d 62 03          	lea    0x3(%rdx),%r12
 18eb47a:	48 c1 e0 20          	shl    $0x20,%rax
 18eb47e:	4d 09 e8             	or     %r13,%r8
 18eb481:	49 09 c2             	or     %rax,%r10
 18eb484:	4c 3b a4 24 98 00 00 00 	cmp    0x98(%rsp),%r12
 18eb48c:	0f 83 e9 fe ff ff    	jae    18eb37b <tier0_tables_open+0x400b>
 18eb492:	4c 8b 6c 24 78       	mov    0x78(%rsp),%r13
 18eb497:	41 8b 44 8d 00       	mov    0x0(%r13,%rcx,4),%eax
 18eb49c:	45 0f b6 64 8d 06    	movzbl 0x6(%r13,%rcx,4),%r12d
 18eb4a2:	41 8b 7c 8d fc       	mov    -0x4(%r13,%rcx,4),%edi
 18eb4a7:	44 39 c8             	cmp    %r9d,%eax
 18eb4aa:	44 0f 47 c8          	cmova  %eax,%r9d
 18eb4ae:	41 8b 44 8d 04       	mov    0x4(%r13,%rcx,4),%eax
 18eb4b3:	41 83 e4 01          	and    $0x1,%r12d
 18eb4b7:	49 c1 e4 30          	shl    $0x30,%r12
 18eb4bb:	4d 09 e2             	or     %r12,%r10
 18eb4be:	48 c1 e0 30          	shl    $0x30,%rax
 18eb4c2:	49 09 c0             	or     %rax,%r8
 18eb4c5:	e9 b1 fe ff ff       	jmp    18eb37b <tier0_tables_open+0x400b>
 18eb4ca:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
 18eb4d0:	bd ff ff ff ff       	mov    $0xffffffff,%ebp
 18eb4d5:	e9 a1 fe ff ff       	jmp    18eb37b <tier0_tables_open+0x400b>
 18eb4da:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
 18eb4e0:	e9 96 fe ff ff       	jmp    18eb37b <tier0_tables_open+0x400b>
 18eb4e5:	48 c1 e7 06          	shl    $0x6,%rdi
 18eb4e9:	48 83 c7 40          	add    $0x40,%rdi
 18eb4ed:	eb 05                	jmp    18eb4f4 <tier0_tables_open+0x4184>
 18eb4ef:	bf 40 00 00 00       	mov    $0x40,%edi
 18eb4f4:	64 48 8b 0c 25 10 ff ff ff 	mov    %fs:0xffffffffffffff10,%rcx
 18eb4fd:	64 48 8b 04 25 18 ff ff ff 	mov    %fs:0xffffffffffffff18,%rax
 18eb506:	48 8d 54 08 3f       	lea    0x3f(%rax,%rcx,1),%rdx
 18eb50b:	48 01 c8             	add    %rcx,%rax
 18eb50e:	48 83 e2 c0          	and    $0xffffffffffffffc0,%rdx
 18eb512:	48 89 94 24 e8 00 00 00 	mov    %rdx,0xe8(%rsp)
 18eb51a:	48 39 c2             	cmp    %rax,%rdx
 18eb51d:	73 07                	jae    18eb526 <tier0_tables_open+0x41b6>
 18eb51f:	31 c9                	xor    %ecx,%ecx
 18eb521:	e9 4c 1b 00 00       	jmp    18ed072 <tier0_tables_open+0x5d02>
 18eb526:	48 8b 84 24 e8 00 00 00 	mov    0xe8(%rsp),%rax
 18eb52e:	64 48 8b 14 25 20 ff ff ff 	mov    %fs:0xffffffffffffff20,%rdx
 18eb537:	48 29 c8             	sub    %rcx,%rax
 18eb53a:	31 c9                	xor    %ecx,%ecx
 18eb53c:	48 29 c2             	sub    %rax,%rdx
 18eb53f:	0f 82 2d 1b 00 00    	jb     18ed072 <tier0_tables_open+0x5d02>
 18eb545:	48 39 d7             	cmp    %rdx,%rdi
 18eb548:	0f 87 24 1b 00 00    	ja     18ed072 <tier0_tables_open+0x5d02>
 18eb54e:	48 01 f8             	add    %rdi,%rax
 18eb551:	48 83 bc 24 e8 00 00 00 00 	cmpq   $0x0,0xe8(%rsp)
 18eb55a:	64 48 89 04 25 18 ff ff ff 	mov    %rax,%fs:0xffffffffffffff18
 18eb563:	0f 84 45 16 00 00    	je     18ecbae <tier0_tables_open+0x583e>
 18eb569:	83 bc 24 b4 00 00 00 00 	cmpl   $0x0,0xb4(%rsp)
 18eb571:	0f 84 37 16 00 00    	je     18ecbae <tier0_tables_open+0x583e>
 18eb577:	48 8b 84 24 e8 00 00 00 	mov    0xe8(%rsp),%rax
 18eb57f:	48 c7 84 24 68 01 00 00 00 00 00 00 	movq   $0x0,0x168(%rsp)
 18eb58b:	48 05 00 01 00 00    	add    $0x100,%rax
 18eb591:	48 89 84 24 a0 01 00 00 	mov    %rax,0x1a0(%rsp)
 18eb599:	eb 21                	jmp    18eb5bc <tier0_tables_open+0x424c>
 18eb59b:	48 8b 8c 24 68 01 00 00 	mov    0x168(%rsp),%rcx
 18eb5a3:	48 ff c1             	inc    %rcx
 18eb5a6:	48 89 8c 24 68 01 00 00 	mov    %rcx,0x168(%rsp)
 18eb5ae:	48 3b 8c 24 50 01 00 00 	cmp    0x150(%rsp),%rcx
 18eb5b6:	0f 84 f2 15 00 00    	je     18ecbae <tier0_tables_open+0x583e>
 18eb5bc:	48 8b 84 24 68 01 00 00 	mov    0x168(%rsp),%rax
 18eb5c4:	48 8b b4 24 20 01 00 00 	mov    0x120(%rsp),%rsi
 18eb5cc:	48 8b 94 24 a0 01 00 00 	mov    0x1a0(%rsp),%rdx
 18eb5d4:	48 c7 84 24 c8 00 00 00 00 00 00 00 	movq   $0x0,0xc8(%rsp)
 18eb5e0:	48 c1 e0 04          	shl    $0x4,%rax
 18eb5e4:	48 89 94 24 78 01 00 00 	mov    %rdx,0x178(%rsp)
 18eb5ec:	48 8d 0c 40          	lea    (%rax,%rax,2),%rcx
 18eb5f0:	48 8d 04 0e          	lea    (%rsi,%rcx,1),%rax
 18eb5f4:	48 03 4c 24 78       	add    0x78(%rsp),%rcx
 18eb5f9:	48 89 84 24 48 01 00 00 	mov    %rax,0x148(%rsp)
 18eb601:	48 89 8c 24 a8 01 00 00 	mov    %rcx,0x1a8(%rsp)
 18eb609:	48 8b 8c 24 e8 00 00 00 	mov    0xe8(%rsp),%rcx
 18eb611:	48 89 8c 24 80 01 00 00 	mov    %rcx,0x180(%rsp)
 18eb619:	eb 7d                	jmp    18eb698 <tier0_tables_open+0x4328>
 18eb61b:	48 8b 34 24          	mov    (%rsp),%rsi
 18eb61f:	48 8b 94 24 f0 00 00 00 	mov    0xf0(%rsp),%rdx
 18eb627:	4c 89 f7             	mov    %r14,%rdi
 18eb62a:	c5 f8 77             	vzeroupper
 18eb62d:	e8 ae 0d 01 00       	call   18fc3e0 <abi_storage>
 18eb632:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
 18eb637:	b1 30                	mov    $0x30,%cl
 18eb639:	c4 e2 f0 f5 d2       	bzhi   %rcx,%rdx,%rdx
 18eb63e:	48 89 54 24 30       	mov    %rdx,0x30(%rsp)
 18eb643:	48 8b 34 24          	mov    (%rsp),%rsi
 18eb647:	48 8b 94 24 f0 00 00 00 	mov    0xf0(%rsp),%rdx
 18eb64f:	48 8b 8e a0 01 00 00 	mov    0x1a0(%rsi),%rcx
 18eb656:	88 04 11             	mov    %al,(%rcx,%rdx,1)
 18eb659:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
 18eb65e:	48 8b 86 a8 01 00 00 	mov    0x1a8(%rsi),%rax
 18eb665:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
 18eb669:	48 8b 8c 24 c8 00 00 00 	mov    0xc8(%rsp),%rcx
 18eb671:	48 83 84 24 80 01 00 00 10 	addq   $0x10,0x180(%rsp)
 18eb67a:	48 83 84 24 78 01 00 00 10 	addq   $0x10,0x178(%rsp)
 18eb683:	48 ff c1             	inc    %rcx
 18eb686:	48 89 8c 24 c8 00 00 00 	mov    %rcx,0xc8(%rsp)
 18eb68e:	48 83 f9 04          	cmp    $0x4,%rcx
 18eb692:	0f 84 03 ff ff ff    	je     18eb59b <tier0_tables_open+0x422b>
 18eb698:	48 8b 84 24 48 01 00 00 	mov    0x148(%rsp),%rax
 18eb6a0:	48 8b 8c 24 c8 00 00 00 	mov    0xc8(%rsp),%rcx
 18eb6a8:	48 8b 50 10          	mov    0x10(%rax),%rdx
 18eb6ac:	48 89 ce             	mov    %rcx,%rsi
 18eb6af:	48 c1 e6 04          	shl    $0x4,%rsi
 18eb6b3:	48 03 b4 24 e8 00 00 00 	add    0xe8(%rsp),%rsi
 18eb6bb:	48 c1 e2 06          	shl    $0x6,%rdx
 18eb6bf:	48 01 d6             	add    %rdx,%rsi
 18eb6c2:	48 89 94 24 88 01 00 00 	mov    %rdx,0x188(%rsp)
 18eb6ca:	8b 14 88             	mov    (%rax,%rcx,4),%edx
 18eb6cd:	8b 40 18             	mov    0x18(%rax),%eax
 18eb6d0:	48 89 74 24 08       	mov    %rsi,0x8(%rsp)
 18eb6d5:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
 18eb6da:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 18eb6df:	48 89 94 24 f0 00 00 00 	mov    %rdx,0xf0(%rsp)
 18eb6e7:	48 39 c2             	cmp    %rax,%rdx
 18eb6ea:	0f 84 ec 00 00 00    	je     18eb7dc <tier0_tables_open+0x446c>
 18eb6f0:	48 8b 84 24 c8 00 00 00 	mov    0xc8(%rsp),%rax
 18eb6f8:	48 8b 8c 24 a8 01 00 00 	mov    0x1a8(%rsp),%rcx
 18eb700:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
 18eb704:	0f b6 44 81 0b       	movzbl 0xb(%rcx,%rax,4),%eax
 18eb709:	48 8b 0c 24          	mov    (%rsp),%rcx
 18eb70d:	88 84 24 00 01 00 00 	mov    %al,0x100(%rsp)
 18eb714:	48 8b 01             	mov    (%rcx),%rax
 18eb717:	48 8b 8c 24 f0 00 00 00 	mov    0xf0(%rsp),%rcx
 18eb71f:	0f b6 0c 08          	movzbl (%rax,%rcx,1),%ecx
 18eb723:	88 8c 24 d0 00 00 00 	mov    %cl,0xd0(%rsp)
 18eb72a:	80 f9 08             	cmp    $0x8,%cl
 18eb72d:	0f 85 ed 00 00 00    	jne    18eb820 <tier0_tables_open+0x44b0>
 18eb733:	48 8b 0c 24          	mov    (%rsp),%rcx
 18eb737:	48 8b 94 24 f0 00 00 00 	mov    0xf0(%rsp),%rdx
 18eb73f:	48 8b 49 20          	mov    0x20(%rcx),%rcx
 18eb743:	8b 14 91             	mov    (%rcx,%rdx,4),%edx
 18eb746:	c1 ea 03             	shr    $0x3,%edx
 18eb749:	80 3c 10 0f          	cmpb   $0xf,(%rax,%rdx,1)
 18eb74d:	48 89 d0             	mov    %rdx,%rax
 18eb750:	75 06                	jne    18eb758 <tier0_tables_open+0x43e8>
 18eb752:	8b 04 91             	mov    (%rcx,%rdx,4),%eax
 18eb755:	c1 e8 03             	shr    $0x3,%eax
 18eb758:	48 8b 0c 24          	mov    (%rsp),%rcx
 18eb75c:	48 8b b4 24 f0 00 00 00 	mov    0xf0(%rsp),%rsi
 18eb764:	48 8b 49 30          	mov    0x30(%rcx),%rcx
 18eb768:	48 8b 34 f1          	mov    (%rcx,%rsi,8),%rsi
 18eb76c:	48 89 74 24 58       	mov    %rsi,0x58(%rsp)
 18eb771:	48 85 f6             	test   %rsi,%rsi
 18eb774:	0f 84 fb 0b 00 00    	je     18ec375 <tier0_tables_open+0x5005>
 18eb77a:	48 8b 0c 24          	mov    (%rsp),%rcx
 18eb77e:	48 8b 49 38          	mov    0x38(%rcx),%rcx
 18eb782:	48 8b 0c c1          	mov    (%rcx,%rax,8),%rcx
 18eb786:	48 89 d0             	mov    %rdx,%rax
 18eb789:	48 c1 e0 04          	shl    $0x4,%rax
 18eb78d:	80 bc 24 00 01 00 00 00 	cmpb   $0x0,0x100(%rsp)
 18eb795:	0f 84 e8 0b 00 00    	je     18ec383 <tier0_tables_open+0x5013>
 18eb79b:	48 85 c9             	test   %rcx,%rcx
 18eb79e:	0f 84 99 0e 00 00    	je     18ec63d <tier0_tables_open+0x52cd>
 18eb7a4:	48 8b 34 24          	mov    (%rsp),%rsi
 18eb7a8:	48 8b be a8 01 00 00 	mov    0x1a8(%rsi),%rdi
 18eb7af:	48 8b 1c d7          	mov    (%rdi,%rdx,8),%rbx
 18eb7b3:	48 89 da             	mov    %rbx,%rdx
 18eb7b6:	48 c1 ea 20          	shr    $0x20,%rdx
 18eb7ba:	48 83 7c 24 58 01    	cmpq   $0x1,0x58(%rsp)
 18eb7c0:	48 89 54 24 10       	mov    %rdx,0x10(%rsp)
 18eb7c5:	0f 85 8d 0e 00 00    	jne    18ec658 <tier0_tables_open+0x52e8>
 18eb7cb:	48 c7 44 24 30 00 00 00 00 	movq   $0x0,0x30(%rsp)
 18eb7d4:	45 31 c0             	xor    %r8d,%r8d
 18eb7d7:	e9 db 0f 00 00       	jmp    18ec7b7 <tier0_tables_open+0x5447>
 18eb7dc:	48 83 7c 24 68 00    	cmpq   $0x0,0x68(%rsp)
 18eb7e2:	0f 84 81 fe ff ff    	je     18eb669 <tier0_tables_open+0x42f9>
 18eb7e8:	31 c0                	xor    %eax,%eax
 18eb7ea:	31 c9                	xor    %ecx,%ecx
 18eb7ec:	c4 e2 79 59 05 13 af cc fe 	vpbroadcastq -0x13350ed(%rip),%xmm0        # 5b6708 <x86_semantics_benchmark_code.registers+0x110>
 18eb7f5:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
 18eb7fa:	89 c2                	mov    %eax,%edx
 18eb7fc:	83 e2 c0             	and    $0xffffffc0,%edx
 18eb7ff:	48 ff c1             	inc    %rcx
 18eb802:	48 83 c0 40          	add    $0x40,%rax
 18eb806:	c5 f9 7f 04 16       	vmovdqa %xmm0,(%rsi,%rdx,1)
 18eb80b:	48 8b b4 24 48 01 00 00 	mov    0x148(%rsp),%rsi
 18eb813:	8b 56 18             	mov    0x18(%rsi),%edx
 18eb816:	48 39 d1             	cmp    %rdx,%rcx
 18eb819:	72 d1                	jb     18eb7ec <tier0_tables_open+0x447c>
 18eb81b:	e9 49 fe ff ff       	jmp    18eb669 <tier0_tables_open+0x42f9>
 18eb820:	48 8b 34 24          	mov    (%rsp),%rsi
 18eb824:	48 8b 8c 24 f0 00 00 00 	mov    0xf0(%rsp),%rcx
 18eb82c:	48 8b 46 28          	mov    0x28(%rsi),%rax
 18eb830:	48 8b 56 70          	mov    0x70(%rsi),%rdx
 18eb834:	48 8b 76 78          	mov    0x78(%rsi),%rsi
 18eb838:	8b 04 88             	mov    (%rax,%rcx,4),%eax
 18eb83b:	8b 14 82             	mov    (%rdx,%rax,4),%edx
 18eb83e:	8b 04 86             	mov    (%rsi,%rax,4),%eax
 18eb841:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
 18eb846:	01 d0                	add    %edx,%eax
 18eb848:	48 89 54 24 20       	mov    %rdx,0x20(%rsp)
 18eb84d:	89 84 24 e0 00 00 00 	mov    %eax,0xe0(%rsp)
 18eb854:	39 c2                	cmp    %eax,%edx
 18eb856:	0f 83 19 0b 00 00    	jae    18ec375 <tier0_tables_open+0x5005>
 18eb85c:	48 8b 04 24          	mov    (%rsp),%rax
 18eb860:	48 8b 8c 24 f0 00 00 00 	mov    0xf0(%rsp),%rcx
 18eb868:	4c 8b 6c 24 20       	mov    0x20(%rsp),%r13
 18eb86d:	48 c7 84 24 70 01 00 00 00 00 00 00 	movq   $0x0,0x170(%rsp)
 18eb879:	48 c7 84 24 28 01 00 00 00 00 00 00 	movq   $0x0,0x128(%rsp)
 18eb885:	48 c7 84 24 a8 00 00 00 00 00 00 00 	movq   $0x0,0xa8(%rsp)
 18eb891:	48 c7 44 24 40 00 00 00 00 	movq   $0x0,0x40(%rsp)
 18eb89a:	48 c7 44 24 30 00 00 00 00 	movq   $0x0,0x30(%rsp)
 18eb8a3:	48 c7 44 24 50 00 00 00 00 	movq   $0x0,0x50(%rsp)
 18eb8ac:	48 8b 40 38          	mov    0x38(%rax),%rax
 18eb8b0:	4c 89 6c 24 10       	mov    %r13,0x10(%rsp)
 18eb8b5:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
 18eb8b9:	48 89 84 24 b8 00 00 00 	mov    %rax,0xb8(%rsp)
 18eb8c1:	8b 84 24 e0 00 00 00 	mov    0xe0(%rsp),%eax
 18eb8c8:	48 89 84 24 98 01 00 00 	mov    %rax,0x198(%rsp)
 18eb8d0:	44 89 e8             	mov    %r13d,%eax
 18eb8d3:	f7 d0                	not    %eax
 18eb8d5:	48 89 84 24 f8 00 00 00 	mov    %rax,0xf8(%rsp)
 18eb8dd:	41 8d 45 01          	lea    0x1(%r13),%eax
 18eb8e1:	48 89 84 24 80 00 00 00 	mov    %rax,0x80(%rsp)
 18eb8e9:	b0 ff                	mov    $0xff,%al
 18eb8eb:	89 84 24 e4 00 00 00 	mov    %eax,0xe4(%rsp)
 18eb8f2:	e9 93 01 00 00       	jmp    18eba8a <tier0_tables_open+0x471a>
 18eb8f7:	48 89 c8             	mov    %rcx,%rax
 18eb8fa:	48 c7 44 24 38 00 00 00 00 	movq   $0x0,0x38(%rsp)
 18eb903:	4c 8b 84 24 a8 00 00 00 	mov    0xa8(%rsp),%r8
 18eb90b:	45 89 fa             	mov    %r15d,%r10d
 18eb90e:	48 09 ac 24 28 01 00 00 	or     %rbp,0x128(%rsp)
 18eb916:	31 c9                	xor    %ecx,%ecx
 18eb918:	41 bb 00 00 00 00    	mov    $0x0,%r11d
 18eb91e:	48 be 00 00 00 00 00 00 02 00 	movabs $0x2000000000000,%rsi
 18eb928:	49 89 ed             	mov    %rbp,%r13
 18eb92b:	bd 00 00 00 00       	mov    $0x0,%ebp
 18eb930:	48 8b 9c 24 18 01 00 00 	mov    0x118(%rsp),%rbx
 18eb938:	45 08 c2             	or     %r8b,%r10b
 18eb93b:	48 83 bc 24 08 01 00 00 00 	cmpq   $0x0,0x108(%rsp)
 18eb944:	4c 89 94 24 70 01 00 00 	mov    %r10,0x170(%rsp)
 18eb94c:	4c 89 94 24 a8 00 00 00 	mov    %r10,0xa8(%rsp)
 18eb954:	0f 95 c1             	setne  %cl
 18eb957:	41 f6 c1 10          	test   $0x10,%r9b
 18eb95b:	49 b9 00 00 00 00 fe ff 7f 00 	movabs $0x7ffffe00000000,%r9
 18eb965:	4c 0f 45 de          	cmovne %rsi,%r11
 18eb969:	be ff ff ff ff       	mov    $0xffffffff,%esi
 18eb96e:	4c 8d 66 01          	lea    0x1(%rsi),%r12
 18eb972:	be 1f 00 00 00       	mov    $0x1f,%esi
 18eb977:	4c 0f 44 e5          	cmove  %rbp,%r12
 18eb97b:	41 f6 c0 01          	test   $0x1,%r8b
 18eb97f:	4c 8b 44 24 40       	mov    0x40(%rsp),%r8
 18eb984:	4c 0f 45 dd          	cmovne %rbp,%r11
 18eb988:	45 84 ff             	test   %r15b,%r15b
 18eb98b:	49 89 ff             	mov    %rdi,%r15
 18eb98e:	4c 0f 44 dd          	cmove  %rbp,%r11
 18eb992:	49 c1 e7 3c          	shl    $0x3c,%r15
 18eb996:	48 83 fb 1f          	cmp    $0x1f,%rbx
 18eb99a:	48 0f 42 f3          	cmovb  %rbx,%rsi
 18eb99e:	48 c1 e6 37          	shl    $0x37,%rsi
 18eb9a2:	49 c1 e0 21          	shl    $0x21,%r8
 18eb9a6:	4d 29 c1             	sub    %r8,%r9
 18eb9a9:	48 85 db             	test   %rbx,%rbx
 18eb9ac:	44 0f b6 84 24 d0 00 00 00 	movzbl 0xd0(%rsp),%r8d
 18eb9b5:	4c 0f 44 e3          	cmove  %rbx,%r12
 18eb9b9:	49 09 f1             	or     %rsi,%r9
 18eb9bc:	40 80 cf 20          	or     $0x20,%dil
 18eb9c0:	31 f6                	xor    %esi,%esi
 18eb9c2:	48 bb 00 00 00 00 00 00 04 00 	movabs $0x4000000000000,%rbx
 18eb9cc:	4d 09 f9             	or     %r15,%r9
 18eb9cf:	4c 0b 8c 24 10 01 00 00 	or     0x110(%rsp),%r9
 18eb9d7:	4d 09 e1             	or     %r12,%r9
 18eb9da:	f6 44 24 70 20       	testb  $0x20,0x70(%rsp)
 18eb9df:	40 0f 94 c6          	sete   %sil
 18eb9e3:	f6 84 24 d8 00 00 00 02 	testb  $0x2,0xd8(%rsp)
 18eb9eb:	0f 45 f1             	cmovne %ecx,%esi
 18eb9ee:	b9 00 00 00 00       	mov    $0x0,%ecx
 18eb9f3:	40 84 f6             	test   %sil,%sil
 18eb9f6:	48 0f 45 cb          	cmovne %rbx,%rcx
 18eb9fa:	48 03 4c 24 38       	add    0x38(%rsp),%rcx
 18eb9ff:	49 0f ab fb          	bts    %rdi,%r11
 18eba03:	4c 09 ea             	or     %r13,%rdx
 18eba06:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
 18eba0b:	48 01 c8             	add    %rcx,%rax
 18eba0e:	4c 01 d8             	add    %r11,%rax
 18eba11:	41 80 f8 11          	cmp    $0x11,%r8b
 18eba15:	49 0f 44 c1          	cmove  %r9,%rax
 18eba19:	80 bc 24 40 01 00 00 00 	cmpb   $0x0,0x140(%rsp)
 18eba21:	48 0f 44 c5          	cmove  %rbp,%rax
 18eba25:	48 0f 44 d5          	cmove  %rbp,%rdx
 18eba29:	48 89 c6             	mov    %rax,%rsi
 18eba2c:	48 09 fe             	or     %rdi,%rsi
 18eba2f:	48 39 f8             	cmp    %rdi,%rax
 18eba32:	48 0f 46 c7          	cmovbe %rdi,%rax
 18eba36:	41 80 f8 11          	cmp    $0x11,%r8b
 18eba3a:	48 0f 45 c6          	cmovne %rsi,%rax
 18eba3e:	48 0f 45 cd          	cmovne %rbp,%rcx
 18eba42:	48 0b 54 24 30       	or     0x30(%rsp),%rdx
 18eba47:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
 18eba4c:	48 09 ca             	or     %rcx,%rdx
 18eba4f:	48 89 54 24 30       	mov    %rdx,0x30(%rsp)
 18eba54:	48 8b 84 24 80 00 00 00 	mov    0x80(%rsp),%rax
 18eba5c:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
 18eba61:	48 ff 44 24 10       	incq   0x10(%rsp)
 18eba66:	48 ff 8c 24 f8 00 00 00 	decq   0xf8(%rsp)
 18eba6e:	48 ff c1             	inc    %rcx
 18eba71:	ff c0                	inc    %eax
 18eba73:	48 89 84 24 80 00 00 00 	mov    %rax,0x80(%rsp)
 18eba7b:	48 89 4c 24 40       	mov    %rcx,0x40(%rsp)
 18eba80:	39 4c 24 58          	cmp    %ecx,0x58(%rsp)
 18eba84:	0f 84 d7 0e 00 00    	je     18ec961 <tier0_tables_open+0x55f1>
 18eba8a:	48 8b 04 24          	mov    (%rsp),%rax
 18eba8e:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
 18eba93:	c5 fc 47 c8          	kxorw  %k0,%k0,%k1
 18eba97:	48 8b 80 d0 00 00 00 	mov    0xd0(%rax),%rax
 18eba9e:	0f b6 0c 08          	movzbl (%rax,%rcx,1),%ecx
 18ebaa2:	f6 c1 02             	test   $0x2,%cl
 18ebaa5:	74 1a                	je     18ebac1 <tier0_tables_open+0x4751>
 18ebaa7:	48 8b 04 24          	mov    (%rsp),%rax
 18ebaab:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
 18ebab0:	48 8b 80 b0 00 00 00 	mov    0xb0(%rax),%rax
 18ebab7:	83 3c 90 01          	cmpl   $0x1,(%rax,%rdx,4)
 18ebabb:	19 c0                	sbb    %eax,%eax
 18ebabd:	c5 fb 92 c8          	kmovd  %eax,%k1
 18ebac1:	48 8b 14 24          	mov    (%rsp),%rdx
 18ebac5:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
 18ebaca:	48 8b 82 b8 00 00 00 	mov    0xb8(%rdx),%rax
 18ebad1:	48 8b 12             	mov    (%rdx),%rdx
 18ebad4:	8b 04 b0             	mov    (%rax,%rsi,4),%eax
 18ebad7:	c1 e8 03             	shr    $0x3,%eax
 18ebada:	80 3c 02 0f          	cmpb   $0xf,(%rdx,%rax,1)
 18ebade:	48 89 c2             	mov    %rax,%rdx
 18ebae1:	75 0e                	jne    18ebaf1 <tier0_tables_open+0x4781>
 18ebae3:	48 8b 14 24          	mov    (%rsp),%rdx
 18ebae7:	48 8b 52 20          	mov    0x20(%rdx),%rdx
 18ebaeb:	8b 14 82             	mov    (%rdx,%rax,4),%edx
 18ebaee:	c1 ea 03             	shr    $0x3,%edx
 18ebaf1:	48 8b 34 24          	mov    (%rsp),%rsi
 18ebaf5:	48 83 bc 24 b8 00 00 00 11 	cmpq   $0x11,0xb8(%rsp)
 18ebafe:	48 8b 7e 38          	mov    0x38(%rsi),%rdi
 18ebb02:	4c 8b 0c d7          	mov    (%rdi,%rdx,8),%r9
 18ebb06:	48 8b be d8 00 00 00 	mov    0xd8(%rsi),%rdi
 18ebb0d:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
 18ebb12:	48 8b 14 f7          	mov    (%rdi,%rsi,8),%rdx
 18ebb16:	72 42                	jb     18ebb5a <tier0_tables_open+0x47ea>
 18ebb18:	80 bc 24 d0 00 00 00 11 	cmpb   $0x11,0xd0(%rsp)
 18ebb20:	74 17                	je     18ebb39 <tier0_tables_open+0x47c9>
 18ebb22:	c4 e2 79 78 05 95 ab c5 fe 	vpbroadcastb -0x13a546b(%rip),%xmm0        # 5466c0 <branch_sizing_patterns+0xa30>
 18ebb2b:	4c 39 8c 24 b8 00 00 00 	cmp    %r9,0xb8(%rsp)
 18ebb33:	0f 85 67 01 00 00    	jne    18ebca0 <tier0_tables_open+0x4930>
 18ebb39:	48 8b 34 24          	mov    (%rsp),%rsi
 18ebb3d:	c4 e2 79 78 05 7a ab c5 fe 	vpbroadcastb -0x13a5486(%rip),%xmm0        # 5466c0 <branch_sizing_patterns+0xa30>
 18ebb46:	8b be bc 01 00 00    	mov    0x1bc(%rsi),%edi
 18ebb4c:	48 39 bc 24 b8 00 00 00 	cmp    %rdi,0xb8(%rsp)
 18ebb54:	0f 87 46 01 00 00    	ja     18ebca0 <tier0_tables_open+0x4930>
 18ebb5a:	f6 c1 02             	test   $0x2,%cl
 18ebb5d:	0f 85 ba 00 00 00    	jne    18ebc1d <tier0_tables_open+0x48ad>
 18ebb63:	48 c1 ea 03          	shr    $0x3,%rdx
 18ebb67:	31 ff                	xor    %edi,%edi
 18ebb69:	4d 85 c9             	test   %r9,%r9
 18ebb6c:	75 1b                	jne    18ebb89 <tier0_tables_open+0x4819>
 18ebb6e:	48 85 d2             	test   %rdx,%rdx
 18ebb71:	74 16                	je     18ebb89 <tier0_tables_open+0x4819>
 18ebb73:	48 8b 0c 24          	mov    (%rsp),%rcx
 18ebb77:	be 0d 01 00 00       	mov    $0x10d,%esi
 18ebb7c:	48 8b 89 88 01 00 00 	mov    0x188(%rcx),%rcx
 18ebb83:	c4 e2 48 f7 3c 81    	bextr  %esi,(%rcx,%rax,4),%edi
 18ebb89:	48 8b 34 24          	mov    (%rsp),%rsi
 18ebb8d:	62 f2 7d 08 7a c2    	vpbroadcastb %edx,%xmm0
 18ebb93:	c5 f9 fc 05 e5 05 cc fe 	vpaddb -0x133fa1b(%rip),%xmm0,%xmm0        # 5ac180 <x86_effects_unknown+0x1b0>
 18ebb9b:	b1 10                	mov    $0x10,%cl
 18ebb9d:	41 b8 fe ff ff ff    	mov    $0xfffffffe,%r8d
 18ebba3:	28 d1                	sub    %dl,%cl
 18ebba5:	62 f1 7d 18 db 1d 1d af cc fe 	vpandd -0x13350e3(%rip){1to4},%xmm0,%xmm3        # 5b6acc <tier0_emit_x87.operations+0x7c>
 18ebbaf:	4c 8b 96 98 01 00 00 	mov    0x198(%rsi),%r10
 18ebbb6:	4c 8b 8e 80 01 00 00 	mov    0x180(%rsi),%r9
 18ebbbd:	be ff ff ff ff       	mov    $0xffffffff,%esi
 18ebbc2:	45 0f b6 14 02       	movzbl (%r10,%rax,1),%r10d
 18ebbc7:	41 80 fa 07          	cmp    $0x7,%r10b
 18ebbcb:	c4 62 29 f7 d6       	shlx   %r10d,%esi,%r10d
 18ebbd0:	be 7f 00 00 00       	mov    $0x7f,%esi
 18ebbd5:	41 f6 d2             	not    %r10b
 18ebbd8:	41 0f b6 d2          	movzbl %r10b,%edx
 18ebbdc:	0f 43 d6             	cmovae %esi,%edx
 18ebbdf:	41 d3 c0             	rol    %cl,%r8d
 18ebbe2:	40 84 ff             	test   %dil,%dil
 18ebbe5:	be ff ff 00 00       	mov    $0xffff,%esi
 18ebbea:	44 0f 44 c6          	cmove  %esi,%r8d
 18ebbee:	48 c1 e0 04          	shl    $0x4,%rax
 18ebbf2:	62 f2 7d 08 7a ca    	vpbroadcastb %edx,%xmm1
 18ebbf8:	c4 c1 7b 92 d0       	kmovd  %r8d,%k2
 18ebbfd:	c4 c1 79 6f 14 01    	vmovdqa (%r9,%rax,1),%xmm2
 18ebc03:	62 f2 76 0a 26 d0    	vptestnmb %xmm0,%xmm1,%k2{%k2}
 18ebc09:	c4 e2 79 78 05 ae aa c5 fe 	vpbroadcastb -0x13a5552(%rip),%xmm0        # 5466c0 <branch_sizing_patterns+0xa30>
 18ebc12:	62 f2 6d 0a 00 c3    	vpshufb %xmm3,%xmm2,%xmm0{%k2}
 18ebc18:	e9 83 00 00 00       	jmp    18ebca0 <tier0_tables_open+0x4930>
 18ebc1d:	48 8b 04 24          	mov    (%rsp),%rax
 18ebc21:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
 18ebc26:	bf 47 00 00 00       	mov    $0x47,%edi
 18ebc2b:	41 b9 48 00 00 00    	mov    $0x48,%r9d
 18ebc31:	29 d7                	sub    %edx,%edi
 18ebc33:	c1 ef 03             	shr    $0x3,%edi
 18ebc36:	48 8b 80 c0 00 00 00 	mov    0xc0(%rax),%rax
 18ebc3d:	8b 04 88             	mov    (%rax,%rcx,4),%eax
 18ebc40:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
 18ebc44:	48 8d 44 02 bf       	lea    -0x41(%rdx,%rax,1),%rax
 18ebc49:	41 29 c9             	sub    %ecx,%r9d
 18ebc4c:	b9 00 00 00 00       	mov    $0x0,%ecx
 18ebc51:	41 c1 e9 03          	shr    $0x3,%r9d
 18ebc55:	48 83 fa 40          	cmp    $0x40,%rdx
 18ebc59:	0f 43 f9             	cmovae %ecx,%edi
 18ebc5c:	48 83 f8 c0          	cmp    $0xffffffffffffffc0,%rax
 18ebc60:	44 0f 42 c9          	cmovb  %ecx,%r9d
 18ebc64:	62 f2 7d 08 7a c7    	vpbroadcastb %edi,%xmm0
 18ebc6a:	62 f3 7d 08 3e 15 0b 05 cc fe 06 	vpcmpnleub -0x133faf5(%rip),%xmm0,%k2        # 5ac180 <x86_effects_unknown+0x1b0>
 18ebc75:	62 d2 7d 08 7a c1    	vpbroadcastb %r9d,%xmm0
 18ebc7b:	62 f3 7d 08 3e 1d 3a 05 cc fe 05 	vpcmpnltub -0x133fac6(%rip),%xmm0,%k3        # 5ac1c0 <x86_effects_unknown+0x1f0>
 18ebc86:	62 f1 7f 8b 6f 0d 40 05 cc fe 	vmovdqu8 -0x133fac0(%rip),%xmm1{%k3}{z}        # 5ac1d0 <x86_effects_unknown+0x200>
 18ebc90:	62 f1 75 18 eb 05 36 ae cc fe 	vpord  -0x13351ca(%rip){1to4},%xmm1,%xmm0        # 5b6ad0 <tier0_emit_x87.operations+0x80>
 18ebc9a:	62 f1 7f 0a 6f c1    	vmovdqu8 %xmm1,%xmm0{%k2}
 18ebca0:	48 8b 84 24 80 00 00 00 	mov    0x80(%rsp),%rax
 18ebca8:	62 f1 7f 09 6f 05 4e 05 cc fe 	vmovdqu8 -0x133fab2(%rip),%xmm0{%k1}        # 5ac200 <x86_effects_unknown+0x230>
 18ebcb2:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
 18ebcb7:	89 c0                	mov    %eax,%eax
 18ebcb9:	48 89 84 24 80 00 00 00 	mov    %rax,0x80(%rsp)
 18ebcc1:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
 18ebcc6:	48 c1 e0 06          	shl    $0x6,%rax
 18ebcca:	80 bc 24 00 01 00 00 00 	cmpb   $0x0,0x100(%rsp)
 18ebcd2:	c5 f9 7f 04 01       	vmovdqa %xmm0,(%rcx,%rax,1)
 18ebcd7:	0f 84 77 fd ff ff    	je     18eba54 <tier0_tables_open+0x46e4>
 18ebcdd:	48 8b 04 24          	mov    (%rsp),%rax
 18ebce1:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
 18ebce6:	4c 8b a8 b8 00 00 00 	mov    0xb8(%rax),%r13
 18ebced:	48 8b 00             	mov    (%rax),%rax
 18ebcf0:	45 8b 54 8d 00       	mov    0x0(%r13,%rcx,4),%r10d
 18ebcf5:	48 89 84 24 90 00 00 00 	mov    %rax,0x90(%rsp)
 18ebcfd:	41 c1 ea 03          	shr    $0x3,%r10d
 18ebd01:	42 80 3c 10 0f       	cmpb   $0xf,(%rax,%r10,1)
 18ebd06:	4c 89 d0             	mov    %r10,%rax
 18ebd09:	75 0f                	jne    18ebd1a <tier0_tables_open+0x49aa>
 18ebd0b:	48 8b 04 24          	mov    (%rsp),%rax
 18ebd0f:	48 8b 40 20          	mov    0x20(%rax),%rax
 18ebd13:	42 8b 04 90          	mov    (%rax,%r10,4),%eax
 18ebd17:	c1 e8 03             	shr    $0x3,%eax
 18ebd1a:	48 8b 14 24          	mov    (%rsp),%rdx
 18ebd1e:	48 8b 4a 38          	mov    0x38(%rdx),%rcx
 18ebd22:	48 8b 3c c1          	mov    (%rcx,%rax,8),%rdi
 18ebd26:	48 8b 8a c0 00 00 00 	mov    0xc0(%rdx),%rcx
 18ebd2d:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
 18ebd32:	48 8b 92 d0 00 00 00 	mov    0xd0(%rdx),%rdx
 18ebd39:	44 8b 1c 81          	mov    (%rcx,%rax,4),%r11d
 18ebd3d:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
 18ebd41:	48 8d 2c fd 00 00 00 00 	lea    0x0(,%rdi,8),%rbp
 18ebd49:	48 89 8c 24 30 01 00 00 	mov    %rcx,0x130(%rsp)
 18ebd51:	48 89 94 24 38 01 00 00 	mov    %rdx,0x138(%rsp)
 18ebd59:	4d 85 db             	test   %r11,%r11
 18ebd5c:	4c 89 9c 24 08 01 00 00 	mov    %r11,0x108(%rsp)
 18ebd64:	88 84 24 d8 00 00 00 	mov    %al,0xd8(%rsp)
 18ebd6b:	41 0f 95 c0          	setne  %r8b
 18ebd6f:	a8 02                	test   $0x2,%al
 18ebd71:	48 b8 f8 ff ff ff 01 00 00 00 	movabs $0x1fffffff8,%rax
 18ebd7b:	0f 94 44 24 70       	sete   0x70(%rsp)
 18ebd80:	4c 39 dd             	cmp    %r11,%rbp
 18ebd83:	4c 0f 42 dd          	cmovb  %rbp,%r11
 18ebd87:	45 31 ff             	xor    %r15d,%r15d
 18ebd8a:	49 83 c3 07          	add    $0x7,%r11
 18ebd8e:	49 21 c3             	and    %rax,%r11
 18ebd91:	49 83 fb 09          	cmp    $0x9,%r11
 18ebd95:	72 26                	jb     18ebdbd <tier0_tables_open+0x4a4d>
 18ebd97:	41 bf 01 00 00 00    	mov    $0x1,%r15d
 18ebd9d:	49 83 fb 11          	cmp    $0x11,%r11
 18ebda1:	72 1a                	jb     18ebdbd <tier0_tables_open+0x4a4d>
 18ebda3:	41 bf 02 00 00 00    	mov    $0x2,%r15d
 18ebda9:	49 83 fb 21          	cmp    $0x21,%r11
 18ebdad:	72 0e                	jb     18ebdbd <tier0_tables_open+0x4a4d>
 18ebdaf:	49 83 fb 41          	cmp    $0x41,%r11
 18ebdb3:	41 bf 04 00 00 00    	mov    $0x4,%r15d
 18ebdb9:	41 83 df 00          	sbb    $0x0,%r15d
 18ebdbd:	48 8b 04 24          	mov    (%rsp),%rax
 18ebdc1:	48 8b 88 d8 00 00 00 	mov    0xd8(%rax),%rcx
 18ebdc8:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
 18ebdcd:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
 18ebdd1:	48 89 8c 24 90 01 00 00 	mov    %rcx,0x190(%rsp)
 18ebdd9:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
 18ebdde:	48 c1 e8 03          	shr    $0x3,%rax
 18ebde2:	f6 84 24 d8 00 00 00 02 	testb  $0x2,0xd8(%rsp)
 18ebdea:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
 18ebdef:	74 39                	je     18ebe2a <tier0_tables_open+0x4aba>
 18ebdf1:	31 c0                	xor    %eax,%eax
 18ebdf3:	c4 e2 f8 f3 cf       	blsr   %rdi,%rax
 18ebdf8:	0f 94 c0             	sete   %al
 18ebdfb:	48 85 ed             	test   %rbp,%rbp
 18ebdfe:	0f 94 c1             	sete   %cl
 18ebe01:	08 c1                	or     %al,%cl
 18ebe03:	0f 85 93 00 00 00    	jne    18ebe9c <tier0_tables_open+0x4b2c>
 18ebe09:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
 18ebe0e:	48 09 e8             	or     %rbp,%rax
 18ebe11:	48 c1 e8 20          	shr    $0x20,%rax
 18ebe15:	0f 84 8e 00 00 00    	je     18ebea9 <tier0_tables_open+0x4b39>
 18ebe1b:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
 18ebe20:	31 d2                	xor    %edx,%edx
 18ebe22:	48 f7 f5             	div    %rbp
 18ebe25:	e9 88 00 00 00       	jmp    18ebeb2 <tier0_tables_open+0x4b42>
 18ebe2a:	48 8b 04 24          	mov    (%rsp),%rax
 18ebe2e:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
 18ebe33:	4c 8b 4c 24 38       	mov    0x38(%rsp),%r9
 18ebe38:	48 89 bc 24 18 01 00 00 	mov    %rdi,0x118(%rsp)
 18ebe40:	48 8b 80 a8 01 00 00 	mov    0x1a8(%rax),%rax
 18ebe47:	8d 0c 36             	lea    (%rsi,%rsi,1),%ecx
 18ebe4a:	49 f7 c1 88 ff ff ff 	test   $0xffffffffffffff88,%r9
 18ebe51:	4a 8b 04 d0          	mov    (%rax,%r10,8),%rax
 18ebe55:	c4 e2 f1 f7 c8       	shlx   %rcx,%rax,%rcx
 18ebe5a:	89 ca                	mov    %ecx,%edx
 18ebe5c:	b9 00 00 00 00       	mov    $0x0,%ecx
 18ebe61:	48 0f 45 d1          	cmovne %rcx,%rdx
 18ebe65:	48 c1 e8 20          	shr    $0x20,%rax
 18ebe69:	48 89 94 24 10 01 00 00 	mov    %rdx,0x110(%rsp)
 18ebe71:	c4 e2 c9 f7 d0       	shlx   %rsi,%rax,%rdx
 18ebe76:	48 b8 00 00 00 00 ff ff 00 00 	movabs $0xffff00000000,%rax
 18ebe80:	48 c1 e2 20          	shl    $0x20,%rdx
 18ebe84:	48 21 c2             	and    %rax,%rdx
 18ebe87:	49 81 f9 80 00 00 00 	cmp    $0x80,%r9
 18ebe8e:	48 89 f0             	mov    %rsi,%rax
 18ebe91:	48 0f 43 d1          	cmovae %rcx,%rdx
 18ebe95:	b1 01                	mov    $0x1,%cl
 18ebe97:	e9 f1 00 00 00       	jmp    18ebf8d <tier0_tables_open+0x4c1d>
 18ebe9c:	48 89 f8             	mov    %rdi,%rax
 18ebe9f:	48 f7 d8             	neg    %rax
 18ebea2:	48 23 44 24 60       	and    0x60(%rsp),%rax
 18ebea7:	eb 0d                	jmp    18ebeb6 <tier0_tables_open+0x4b46>
 18ebea9:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
 18ebeae:	31 d2                	xor    %edx,%edx
 18ebeb0:	f7 f5                	div    %ebp
 18ebeb2:	48 0f af c7          	imul   %rdi,%rax
 18ebeb6:	80 bc 24 d0 00 00 00 11 	cmpb   $0x11,0xd0(%rsp)
 18ebebe:	b9 01 00 00 00       	mov    $0x1,%ecx
 18ebec3:	be 00 00 00 00       	mov    $0x0,%esi
 18ebec8:	41 bc 10 00 00 00    	mov    $0x10,%r12d
 18ebece:	c4 e2 81 f7 d1       	shlx   %r15,%rcx,%rdx
 18ebed3:	48 0f 45 d7          	cmovne %rdi,%rdx
 18ebed7:	48 0f 44 c6          	cmove  %rsi,%rax
 18ebedb:	f3 48 0f b8 ca       	popcnt %rdx,%rcx
 18ebee0:	48 89 94 24 18 01 00 00 	mov    %rdx,0x118(%rsp)
 18ebee8:	f3 48 0f bc d2       	tzcnt  %rdx,%rdx
 18ebeed:	44 8d 4a 01          	lea    0x1(%rdx),%r9d
 18ebef1:	48 83 fa 04          	cmp    $0x4,%rdx
 18ebef5:	ba 09 00 00 00       	mov    $0x9,%edx
 18ebefa:	4c 0f 43 ca          	cmovae %rdx,%r9
 18ebefe:	83 f9 01             	cmp    $0x1,%ecx
 18ebf01:	8d 0c 00             	lea    (%rax,%rax,1),%ecx
 18ebf04:	4c 0f 45 ca          	cmovne %rdx,%r9
 18ebf08:	48 a9 f1 ff ff ff    	test   $0xfffffffffffffff1,%rax
 18ebf0e:	c4 c2 f1 f7 d1       	shlx   %rcx,%r9,%rdx
 18ebf13:	41 b9 10 00 00 00    	mov    $0x10,%r9d
 18ebf19:	89 d2                	mov    %edx,%edx
 18ebf1b:	48 0f 45 d6          	cmovne %rsi,%rdx
 18ebf1f:	48 89 94 24 10 01 00 00 	mov    %rdx,0x110(%rsp)
 18ebf27:	ba 0f 00 00 00       	mov    $0xf,%edx
 18ebf2c:	c4 e2 f1 f7 ca       	shlx   %rcx,%rdx,%rcx
 18ebf31:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
 18ebf36:	48 0f 45 ce          	cmovne %rsi,%rcx
 18ebf3a:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
 18ebf3f:	48 8d 54 15 ff       	lea    -0x1(%rbp,%rdx,1),%rdx
 18ebf44:	48 c1 ea 03          	shr    $0x3,%rdx
 18ebf48:	48 29 f2             	sub    %rsi,%rdx
 18ebf4b:	48 ff c2             	inc    %rdx
 18ebf4e:	48 83 fe 10          	cmp    $0x10,%rsi
 18ebf52:	4c 0f 42 ce          	cmovb  %rsi,%r9
 18ebf56:	be 10 00 00 00       	mov    $0x10,%esi
 18ebf5b:	4d 29 cc             	sub    %r9,%r12
 18ebf5e:	4c 39 e2             	cmp    %r12,%rdx
 18ebf61:	42 8d 14 0a          	lea    (%rdx,%r9,1),%edx
 18ebf65:	0f 43 d6             	cmovae %esi,%edx
 18ebf68:	48 c7 c6 ff ff ff ff 	mov    $0xffffffffffffffff,%rsi
 18ebf6f:	44 29 ca             	sub    %r9d,%edx
 18ebf72:	c4 e2 e9 f7 d6       	shlx   %rdx,%rsi,%rdx
 18ebf77:	f7 d2                	not    %edx
 18ebf79:	c4 e2 b1 f7 d2       	shlx   %r9,%rdx,%rdx
 18ebf7e:	48 c1 e2 20          	shl    $0x20,%rdx
 18ebf82:	48 85 8c 24 28 01 00 00 	test   %rcx,0x128(%rsp)
 18ebf8a:	0f 94 c1             	sete   %cl
 18ebf8d:	44 89 c6             	mov    %r8d,%esi
 18ebf90:	40 0a 74 24 70       	or     0x70(%rsp),%sil
 18ebf95:	f6 c1 01             	test   $0x1,%cl
 18ebf98:	44 0f b6 8c 24 d0 00 00 00 	movzbl 0xd0(%rsp),%r9d
 18ebfa1:	bd 00 00 00 00       	mov    $0x0,%ebp
 18ebfa6:	b9 00 00 00 00       	mov    $0x0,%ecx
 18ebfab:	48 0f 45 ac 24 10 01 00 00 	cmovne 0x110(%rsp),%rbp
 18ebfb4:	41 80 f9 11          	cmp    $0x11,%r9b
 18ebfb8:	40 88 b4 24 40 01 00 00 	mov    %sil,0x140(%rsp)
 18ebfc0:	48 0f 44 e9          	cmove  %rcx,%rbp
 18ebfc4:	40 84 f6             	test   %sil,%sil
 18ebfc7:	48 0f 44 e9          	cmove  %rcx,%rbp
 18ebfcb:	41 80 f9 11          	cmp    $0x11,%r9b
 18ebfcf:	75 2e                	jne    18ebfff <tier0_tables_open+0x4c8f>
 18ebfd1:	48 8b 04 24          	mov    (%rsp),%rax
 18ebfd5:	48 8b 80 a0 01 00 00 	mov    0x1a0(%rax),%rax
 18ebfdc:	42 0f b6 04 10       	movzbl (%rax,%r10,1),%eax
 18ebfe1:	88 44 24 70          	mov    %al,0x70(%rsp)
 18ebfe5:	31 c0                	xor    %eax,%eax
 18ebfe7:	49 81 fb 80 00 00 00 	cmp    $0x80,%r11
 18ebfee:	0f 94 c0             	sete   %al
 18ebff1:	45 31 db             	xor    %r11d,%r11d
 18ebff4:	c1 e0 04             	shl    $0x4,%eax
 18ebff7:	41 09 c7             	or     %eax,%r15d
 18ebffa:	e9 bf 02 00 00       	jmp    18ec2be <tier0_tables_open+0x4f4e>
 18ebfff:	44 0f b6 84 24 d8 00 00 00 	movzbl 0xd8(%rsp),%r8d
 18ec008:	48 83 bc 24 08 01 00 00 00 	cmpq   $0x0,0x108(%rsp)
 18ec011:	41 b9 10 00 00 00    	mov    $0x10,%r9d
 18ec017:	45 89 c3             	mov    %r8d,%r11d
 18ec01a:	0f 95 c1             	setne  %cl
 18ec01d:	41 b8 10 00 00 00    	mov    $0x10,%r8d
 18ec023:	41 80 e3 02          	and    $0x2,%r11b
 18ec027:	41 d0 eb             	shr    $1,%r11b
 18ec02a:	48 83 f8 10          	cmp    $0x10,%rax
 18ec02e:	49 0f 43 c0          	cmovae %r8,%rax
 18ec032:	4c 8b 04 24          	mov    (%rsp),%r8
 18ec036:	49 29 c1             	sub    %rax,%r9
 18ec039:	8d 34 07             	lea    (%rdi,%rax,1),%esi
 18ec03c:	4c 39 cf             	cmp    %r9,%rdi
 18ec03f:	41 b9 10 00 00 00    	mov    $0x10,%r9d
 18ec045:	41 0f 43 f1          	cmovae %r9d,%esi
 18ec049:	41 20 cb             	and    %cl,%r11b
 18ec04c:	49 8b b8 a0 01 00 00 	mov    0x1a0(%r8),%rdi
 18ec053:	48 89 fb             	mov    %rdi,%rbx
 18ec056:	42 0f b6 3c 17       	movzbl (%rdi,%r10,1),%edi
 18ec05b:	40 88 7c 24 70       	mov    %dil,0x70(%rsp)
 18ec060:	41 80 fb 01          	cmp    $0x1,%r11b
 18ec064:	0f 85 15 02 00 00    	jne    18ec27f <tier0_tables_open+0x4f0f>
 18ec06a:	8b 4c 24 20          	mov    0x20(%rsp),%ecx
 18ec06e:	48 39 4c 24 10       	cmp    %rcx,0x10(%rsp)
 18ec073:	0f 82 06 02 00 00    	jb     18ec27f <tier0_tables_open+0x4f0f>
 18ec079:	4c 8b 44 24 10       	mov    0x10(%rsp),%r8
 18ec07e:	48 8b 8c 24 08 01 00 00 	mov    0x108(%rsp),%rcx
 18ec086:	48 8b 7c 24 38       	mov    0x38(%rsp),%rdi
 18ec08b:	41 ff c0             	inc    %r8d
 18ec08e:	48 01 cf             	add    %rcx,%rdi
 18ec091:	4c 89 44 24 20       	mov    %r8,0x20(%rsp)
 18ec096:	44 3b 84 24 e0 00 00 00 	cmp    0xe0(%rsp),%r8d
 18ec09e:	0f 83 ac 00 00 00    	jae    18ec150 <tier0_tables_open+0x4de0>
 18ec0a4:	4c 8b 84 24 80 00 00 00 	mov    0x80(%rsp),%r8
 18ec0ac:	4c 8b 94 24 98 01 00 00 	mov    0x198(%rsp),%r10
 18ec0b4:	4c 8b bc 24 38 01 00 00 	mov    0x138(%rsp),%r15
 18ec0bc:	48 c7 44 24 20 00 00 00 00 	movq   $0x0,0x20(%rsp)
 18ec0c5:	4a 8d 0c 85 00 00 00 00 	lea    0x0(,%r8,4),%rcx
 18ec0cd:	4e 8d 0c c5 00 00 00 00 	lea    0x0(,%r8,8),%r9
 18ec0d5:	48 03 8c 24 30 01 00 00 	add    0x130(%rsp),%rcx
 18ec0dd:	4c 03 8c 24 90 01 00 00 	add    0x190(%rsp),%r9
 18ec0e5:	4d 29 c2             	sub    %r8,%r10
 18ec0e8:	4d 01 f8             	add    %r15,%r8
 18ec0eb:	4c 89 84 24 a8 00 00 00 	mov    %r8,0xa8(%rsp)
 18ec0f3:	4c 8b 44 24 20       	mov    0x20(%rsp),%r8
 18ec0f8:	4c 8b bc 24 a8 00 00 00 	mov    0xa8(%rsp),%r15
 18ec100:	43 f6 04 07 02       	testb  $0x2,(%r15,%r8,1)
 18ec105:	74 38                	je     18ec13f <tier0_tables_open+0x4dcf>
 18ec107:	4c 8b 44 24 20       	mov    0x20(%rsp),%r8
 18ec10c:	4f 8b 3c c1          	mov    (%r9,%r8,8),%r15
 18ec110:	41 f6 c7 07          	test   $0x7,%r15b
 18ec114:	74 29                	je     18ec13f <tier0_tables_open+0x4dcf>
 18ec116:	4c 8b 44 24 20       	mov    0x20(%rsp),%r8
 18ec11b:	46 8b 24 81          	mov    (%rcx,%r8,4),%r12d
 18ec11f:	4d 01 e7             	add    %r12,%r15
 18ec122:	49 39 ff             	cmp    %rdi,%r15
 18ec125:	49 0f 47 ff          	cmova  %r15,%rdi
 18ec129:	49 ff c0             	inc    %r8
 18ec12c:	4c 89 44 24 20       	mov    %r8,0x20(%rsp)
 18ec131:	4d 39 c2             	cmp    %r8,%r10
 18ec134:	75 bd                	jne    18ec0f3 <tier0_tables_open+0x4d83>
 18ec136:	8b 8c 24 e0 00 00 00 	mov    0xe0(%rsp),%ecx
 18ec13d:	eb 0c                	jmp    18ec14b <tier0_tables_open+0x4ddb>
 18ec13f:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
 18ec144:	2b 8c 24 f8 00 00 00 	sub    0xf8(%rsp),%ecx
 18ec14b:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
 18ec150:	48 2b 7c 24 38       	sub    0x38(%rsp),%rdi
 18ec155:	b1 ff                	mov    $0xff,%cl
 18ec157:	89 8c 24 e4 00 00 00 	mov    %ecx,0xe4(%rsp)
 18ec15e:	48 83 c7 07          	add    $0x7,%rdi
 18ec162:	48 83 ff 48          	cmp    $0x48,%rdi
 18ec166:	0f 82 03 01 00 00    	jb     18ec26f <tier0_tables_open+0x4eff>
 18ec16c:	48 8b 8c 24 b8 00 00 00 	mov    0xb8(%rsp),%rcx
 18ec174:	4c 8b 44 24 20       	mov    0x20(%rsp),%r8
 18ec179:	44 3b 84 24 e0 00 00 00 	cmp    0xe0(%rsp),%r8d
 18ec181:	0f 83 ad 00 00 00    	jae    18ec234 <tier0_tables_open+0x4ec4>
 18ec187:	44 8b 54 24 20       	mov    0x20(%rsp),%r10d
 18ec18c:	48 8b 8c 24 38 01 00 00 	mov    0x138(%rsp),%rcx
 18ec194:	46 0f b6 0c 11       	movzbl (%rcx,%r10,1),%r9d
 18ec199:	b1 01                	mov    $0x1,%cl
 18ec19b:	41 f6 c1 02          	test   $0x2,%r9b
 18ec19f:	74 10                	je     18ec1b1 <tier0_tables_open+0x4e41>
 18ec1a1:	48 8b 8c 24 30 01 00 00 	mov    0x130(%rsp),%rcx
 18ec1a9:	42 83 3c 91 00       	cmpl   $0x0,(%rcx,%r10,4)
 18ec1ae:	0f 95 c1             	setne  %cl
 18ec1b1:	47 8b 64 95 00       	mov    0x0(%r13,%r10,4),%r12d
 18ec1b6:	4c 8b 84 24 90 00 00 00 	mov    0x90(%rsp),%r8
 18ec1be:	41 c1 ec 03          	shr    $0x3,%r12d
 18ec1c2:	43 80 3c 20 0f       	cmpb   $0xf,(%r8,%r12,1)
 18ec1c7:	75 23                	jne    18ec1ec <tier0_tables_open+0x4e7c>
 18ec1c9:	4c 8b 04 24          	mov    (%rsp),%r8
 18ec1cd:	4d 8b 78 20          	mov    0x20(%r8),%r15
 18ec1d1:	47 8b 24 a7          	mov    (%r15,%r12,4),%r12d
 18ec1d5:	41 c1 ec 03          	shr    $0x3,%r12d
 18ec1d9:	41 b7 01             	mov    $0x1,%r15b
 18ec1dc:	41 f6 c1 02          	test   $0x2,%r9b
 18ec1e0:	74 13                	je     18ec1f5 <tier0_tables_open+0x4e85>
 18ec1e2:	44 20 f9             	and    %r15b,%cl
 18ec1e5:	80 f9 01             	cmp    $0x1,%cl
 18ec1e8:	75 1f                	jne    18ec209 <tier0_tables_open+0x4e99>
 18ec1ea:	eb 38                	jmp    18ec224 <tier0_tables_open+0x4eb4>
 18ec1ec:	41 b7 01             	mov    $0x1,%r15b
 18ec1ef:	41 f6 c1 02          	test   $0x2,%r9b
 18ec1f3:	75 ed                	jne    18ec1e2 <tier0_tables_open+0x4e72>
 18ec1f5:	45 89 e1             	mov    %r12d,%r9d
 18ec1f8:	42 f6 04 0b 20       	testb  $0x20,(%rbx,%r9,1)
 18ec1fd:	41 0f 94 c7          	sete   %r15b
 18ec201:	44 20 f9             	and    %r15b,%cl
 18ec204:	80 f9 01             	cmp    $0x1,%cl
 18ec207:	74 1b                	je     18ec224 <tier0_tables_open+0x4eb4>
 18ec209:	49 ff c2             	inc    %r10
 18ec20c:	4c 39 94 24 98 01 00 00 	cmp    %r10,0x198(%rsp)
 18ec214:	0f 85 72 ff ff ff    	jne    18ec18c <tier0_tables_open+0x4e1c>
 18ec21a:	48 8b 8c 24 b8 00 00 00 	mov    0xb8(%rsp),%rcx
 18ec222:	eb 10                	jmp    18ec234 <tier0_tables_open+0x4ec4>
 18ec224:	48 8b 8c 24 90 01 00 00 	mov    0x190(%rsp),%rcx
 18ec22c:	4a 8b 0c d1          	mov    (%rcx,%r10,8),%rcx
 18ec230:	48 c1 e9 03          	shr    $0x3,%rcx
 18ec234:	4c 8b 44 24 60       	mov    0x60(%rsp),%r8
 18ec239:	48 c1 ef 03          	shr    $0x3,%rdi
 18ec23d:	48 83 c7 0f          	add    $0xf,%rdi
 18ec241:	48 83 e7 f0          	and    $0xfffffffffffffff0,%rdi
 18ec245:	48 83 ff 10          	cmp    $0x10,%rdi
 18ec249:	4e 8d 0c 07          	lea    (%rdi,%r8,1),%r9
 18ec24d:	41 0f 94 c0          	sete   %r8b
 18ec251:	bf 00 00 00 00       	mov    $0x0,%edi
 18ec256:	41 c0 e0 04          	shl    $0x4,%r8b
 18ec25a:	41 80 c8 04          	or     $0x4,%r8b
 18ec25e:	49 39 c9             	cmp    %rcx,%r9
 18ec261:	41 0f b6 c8          	movzbl %r8b,%ecx
 18ec265:	0f 47 cf             	cmova  %edi,%ecx
 18ec268:	89 8c 24 e4 00 00 00 	mov    %ecx,0xe4(%rsp)
 18ec26f:	48 8b 9c 24 70 01 00 00 	mov    0x170(%rsp),%rbx
 18ec277:	48 89 9c 24 a8 00 00 00 	mov    %rbx,0xa8(%rsp)
 18ec27f:	29 c6                	sub    %eax,%esi
 18ec281:	48 c7 c1 ff ff ff ff 	mov    $0xffffffffffffffff,%rcx
 18ec288:	c4 e2 c9 f7 c9       	shlx   %rsi,%rcx,%rcx
 18ec28d:	f7 d1                	not    %ecx
 18ec28f:	c4 e2 f9 f7 c1       	shlx   %rax,%rcx,%rax
 18ec294:	8b 8c 24 e4 00 00 00 	mov    0xe4(%rsp),%ecx
 18ec29b:	48 c1 e0 30          	shl    $0x30,%rax
 18ec29f:	48 09 c2             	or     %rax,%rdx
 18ec2a2:	0f b6 44 24 70       	movzbl 0x70(%rsp),%eax
 18ec2a7:	44 0f b6 f9          	movzbl %cl,%r15d
 18ec2ab:	24 0f                	and    $0xf,%al
 18ec2ad:	80 f9 ff             	cmp    $0xff,%cl
 18ec2b0:	0f b6 c0             	movzbl %al,%eax
 18ec2b3:	44 0f 44 f8          	cmove  %eax,%r15d
 18ec2b7:	45 84 db             	test   %r11b,%r11b
 18ec2ba:	44 0f 44 f8          	cmove  %eax,%r15d
 18ec2be:	44 0f b6 84 24 d8 00 00 00 	movzbl 0xd8(%rsp),%r8d
 18ec2c7:	0f b6 44 24 70       	movzbl 0x70(%rsp),%eax
 18ec2cc:	41 0f b6 cf          	movzbl %r15b,%ecx
 18ec2d0:	41 f6 c0 02          	test   $0x2,%r8b
 18ec2d4:	0f 44 c8             	cmove  %eax,%ecx
 18ec2d7:	89 cf                	mov    %ecx,%edi
 18ec2d9:	83 e7 0f             	and    $0xf,%edi
 18ec2dc:	48 83 7c 24 38 00    	cmpq   $0x0,0x38(%rsp)
 18ec2e2:	44 0f b6 c9          	movzbl %cl,%r9d
 18ec2e6:	0f 94 c0             	sete   %al
 18ec2e9:	22 84 24 40 01 00 00 	and    0x140(%rsp),%al
 18ec2f0:	48 83 bc 24 18 01 00 00 00 	cmpq   $0x0,0x118(%rsp)
 18ec2f9:	41 0f 95 c7          	setne  %r15b
 18ec2fd:	41 20 c7             	and    %al,%r15b
 18ec300:	41 f6 c0 02          	test   $0x2,%r8b
 18ec304:	74 33                	je     18ec339 <tier0_tables_open+0x4fc9>
 18ec306:	80 bc 24 e4 00 00 00 ff 	cmpb   $0xff,0xe4(%rsp)
 18ec30e:	49 ba 00 00 00 00 00 00 08 00 	movabs $0x8000000000000,%r10
 18ec318:	b9 00 00 00 00       	mov    $0x0,%ecx
 18ec31d:	b8 00 00 00 00       	mov    $0x0,%eax
 18ec322:	4c 89 54 24 38       	mov    %r10,0x38(%rsp)
 18ec327:	41 0f 94 c4          	sete   %r12b
 18ec32b:	45 84 e3             	test   %r12b,%r11b
 18ec32e:	0f 84 c3 f5 ff ff    	je     18eb8f7 <tier0_tables_open+0x4587>
 18ec334:	e9 ca f5 ff ff       	jmp    18eb903 <tier0_tables_open+0x4593>
 18ec339:	c4 e2 40 f5 44 24 60 	bzhi   %edi,0x60(%rsp),%eax
 18ec340:	48 b9 00 00 00 00 00 00 01 00 	movabs $0x1000000000000,%rcx
 18ec34a:	b8 00 00 00 00       	mov    $0x0,%eax
 18ec34f:	49 ba 00 00 00 00 00 00 08 00 	movabs $0x8000000000000,%r10
 18ec359:	4c 89 54 24 38       	mov    %r10,0x38(%rsp)
 18ec35e:	48 0f 44 c8          	cmove  %rax,%rcx
 18ec362:	f6 44 24 70 40       	testb  $0x40,0x70(%rsp)
 18ec367:	48 89 c8             	mov    %rcx,%rax
 18ec36a:	0f 85 93 f5 ff ff    	jne    18eb903 <tier0_tables_open+0x4593>
 18ec370:	e9 82 f5 ff ff       	jmp    18eb8f7 <tier0_tables_open+0x4587>
 18ec375:	48 c7 44 24 58 00 00 00 00 	movq   $0x0,0x58(%rsp)
 18ec37e:	e9 cc 05 00 00       	jmp    18ec94f <tier0_tables_open+0x55df>
 18ec383:	48 8b 74 24 58       	mov    0x58(%rsp),%rsi
 18ec388:	89 f2                	mov    %esi,%edx
 18ec38a:	83 e2 07             	and    $0x7,%edx
 18ec38d:	48 83 fe 08          	cmp    $0x8,%rsi
 18ec391:	73 07                	jae    18ec39a <tier0_tables_open+0x502a>
 18ec393:	31 ff                	xor    %edi,%edi
 18ec395:	e9 42 02 00 00       	jmp    18ec5dc <tier0_tables_open+0x526c>
 18ec39a:	8d 34 cd 00 00 00 00 	lea    0x0(,%rcx,8),%esi
 18ec3a1:	8d 3c cd 00 00 00 00 	lea    0x0(,%rcx,8),%edi
 18ec3a8:	48 8b 5c 24 58       	mov    0x58(%rsp),%rbx
 18ec3ad:	44 8d 24 8d 00 00 00 00 	lea    0x0(,%rcx,4),%r12d
 18ec3b5:	44 8d 2c 49          	lea    (%rcx,%rcx,2),%r13d
 18ec3b9:	8d 2c 09             	lea    (%rcx,%rcx,1),%ebp
 18ec3bc:	41 ba c0 01 00 00    	mov    $0x1c0,%r10d
 18ec3c2:	45 31 c0             	xor    %r8d,%r8d
 18ec3c5:	29 ce                	sub    %ecx,%esi
 18ec3c7:	89 bc 24 80 00 00 00 	mov    %edi,0x80(%rsp)
 18ec3ce:	8d 3c 09             	lea    (%rcx,%rcx,1),%edi
 18ec3d1:	48 89 74 24 10       	mov    %rsi,0x10(%rsp)
 18ec3d6:	8d 34 7f             	lea    (%rdi,%rdi,2),%esi
 18ec3d9:	31 ff                	xor    %edi,%edi
 18ec3db:	48 89 74 24 40       	mov    %rsi,0x40(%rsp)
 18ec3e0:	8d 34 89             	lea    (%rcx,%rcx,4),%esi
 18ec3e3:	48 83 e3 f8          	and    $0xfffffffffffffff8,%rbx
 18ec3e7:	48 89 74 24 20       	mov    %rsi,0x20(%rsp)
 18ec3ec:	4d 8b 0e             	mov    (%r14),%r9
 18ec3ef:	c5 f9 6f 15 89 fd cb fe 	vmovdqa -0x1340277(%rip),%xmm2        # 5ac180 <x86_effects_unknown+0x1b0>
 18ec3f7:	c4 e2 79 78 1d c1 a2 c5 fe 	vpbroadcastb -0x13a5d3f(%rip),%xmm3        # 5466c1 <branch_sizing_patterns+0xa31>
 18ec400:	62 d2 7d 08 7a c8    	vpbroadcastb %r8d,%xmm1
 18ec406:	4c 8b 7c 24 08       	mov    0x8(%rsp),%r15
 18ec40b:	4d 8d 9a 40 fe ff ff 	lea    -0x1c0(%r10),%r11
 18ec412:	48 be 00 fe ff ff 3f 00 00 00 	movabs $0x3ffffffe00,%rsi
 18ec41c:	48 83 c7 08          	add    $0x8,%rdi
 18ec420:	49 21 f3             	and    %rsi,%r11
 18ec423:	c4 c1 79 6f 04 01    	vmovdqa (%r9,%rax,1),%xmm0
 18ec429:	c5 f1 fc ca          	vpaddb %xmm2,%xmm1,%xmm1
 18ec42d:	c5 f1 db cb          	vpand  %xmm3,%xmm1,%xmm1
 18ec431:	c4 e2 79 00 c1       	vpshufb %xmm1,%xmm0,%xmm0
 18ec436:	c4 81 79 7f 04 1f    	vmovdqa %xmm0,(%r15,%r11,1)
 18ec43c:	4d 8d 9a 80 fe ff ff 	lea    -0x180(%r10),%r11
 18ec443:	4d 8b 0e             	mov    (%r14),%r9
 18ec446:	c4 c1 79 6f 04 01    	vmovdqa (%r9,%rax,1),%xmm0
 18ec44c:	46 8d 0c 01          	lea    (%rcx,%r8,1),%r9d
 18ec450:	62 d2 7d 08 7a c9    	vpbroadcastb %r9d,%xmm1
 18ec456:	4c 8d 4e 40          	lea    0x40(%rsi),%r9
 18ec45a:	c5 f1 fc ca          	vpaddb %xmm2,%xmm1,%xmm1
 18ec45e:	4d 21 cb             	and    %r9,%r11
 18ec461:	c5 f1 db cb          	vpand  %xmm3,%xmm1,%xmm1
 18ec465:	c4 e2 79 00 c1       	vpshufb %xmm1,%xmm0,%xmm0
 18ec46a:	c4 81 79 7f 04 1f    	vmovdqa %xmm0,(%r15,%r11,1)
 18ec470:	46 8d 5c 05 00       	lea    0x0(%rbp,%r8,1),%r11d
 18ec475:	4d 8b 0e             	mov    (%r14),%r9
 18ec478:	62 d2 7d 08 7a cb    	vpbroadcastb %r11d,%xmm1
 18ec47e:	4c 8d 9e 80 00 00 00 	lea    0x80(%rsi),%r11
 18ec485:	c5 f1 fc ca          	vpaddb %xmm2,%xmm1,%xmm1
 18ec489:	c5 f1 db cb          	vpand  %xmm3,%xmm1,%xmm1
 18ec48d:	c4 c1 79 6f 04 01    	vmovdqa (%r9,%rax,1),%xmm0
 18ec493:	4d 8d 8a c0 fe ff ff 	lea    -0x140(%r10),%r9
 18ec49a:	4d 21 cb             	and    %r9,%r11
 18ec49d:	c4 e2 79 00 c1       	vpshufb %xmm1,%xmm0,%xmm0
 18ec4a2:	c4 81 79 7f 04 1f    	vmovdqa %xmm0,(%r15,%r11,1)
 18ec4a8:	4d 8d 9a 00 ff ff ff 	lea    -0x100(%r10),%r11
 18ec4af:	4d 8b 0e             	mov    (%r14),%r9
 18ec4b2:	c4 c1 79 6f 04 01    	vmovdqa (%r9,%rax,1),%xmm0
 18ec4b8:	47 8d 4c 05 00       	lea    0x0(%r13,%r8,1),%r9d
 18ec4bd:	62 d2 7d 08 7a c9    	vpbroadcastb %r9d,%xmm1
 18ec4c3:	4c 8d 8e c0 00 00 00 	lea    0xc0(%rsi),%r9
 18ec4ca:	c5 f1 fc ca          	vpaddb %xmm2,%xmm1,%xmm1
 18ec4ce:	4d 21 d9             	and    %r11,%r9
 18ec4d1:	c5 f1 db cb          	vpand  %xmm3,%xmm1,%xmm1
 18ec4d5:	c4 e2 79 00 c1       	vpshufb %xmm1,%xmm0,%xmm0
 18ec4da:	c4 81 79 7f 04 0f    	vmovdqa %xmm0,(%r15,%r9,1)
 18ec4e0:	4d 8d 8a 40 ff ff ff 	lea    -0xc0(%r10),%r9
 18ec4e7:	4d 8b 1e             	mov    (%r14),%r11
 18ec4ea:	c4 c1 79 6f 04 03    	vmovdqa (%r11,%rax,1),%xmm0
 18ec4f0:	4c 8d 9e 00 01 00 00 	lea    0x100(%rsi),%r11
 18ec4f7:	4d 21 cb             	and    %r9,%r11
 18ec4fa:	47 8d 0c 04          	lea    (%r12,%r8,1),%r9d
 18ec4fe:	62 d2 7d 08 7a c9    	vpbroadcastb %r9d,%xmm1
 18ec504:	4d 8d 4a 80          	lea    -0x80(%r10),%r9
 18ec508:	c5 f1 fc ca          	vpaddb %xmm2,%xmm1,%xmm1
 18ec50c:	c5 f1 db cb          	vpand  %xmm3,%xmm1,%xmm1
 18ec510:	c4 e2 79 00 c1       	vpshufb %xmm1,%xmm0,%xmm0
 18ec515:	c4 81 79 7f 04 1f    	vmovdqa %xmm0,(%r15,%r11,1)
 18ec51b:	4c 8d 9e 40 01 00 00 	lea    0x140(%rsi),%r11
 18ec522:	4d 21 cb             	and    %r9,%r11
 18ec525:	4d 8b 0e             	mov    (%r14),%r9
 18ec528:	c4 c1 79 6f 04 01    	vmovdqa (%r9,%rax,1),%xmm0
 18ec52e:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
 18ec533:	45 01 c1             	add    %r8d,%r9d
 18ec536:	62 d2 7d 08 7a c9    	vpbroadcastb %r9d,%xmm1
 18ec53c:	4d 8d 4a c0          	lea    -0x40(%r10),%r9
 18ec540:	c5 f1 fc ca          	vpaddb %xmm2,%xmm1,%xmm1
 18ec544:	c5 f1 db cb          	vpand  %xmm3,%xmm1,%xmm1
 18ec548:	c4 e2 79 00 c1       	vpshufb %xmm1,%xmm0,%xmm0
 18ec54d:	c4 81 79 7f 04 1f    	vmovdqa %xmm0,(%r15,%r11,1)
 18ec553:	4d 8b 1e             	mov    (%r14),%r11
 18ec556:	c4 c1 79 6f 04 03    	vmovdqa (%r11,%rax,1),%xmm0
 18ec55c:	4c 8b 5c 24 40       	mov    0x40(%rsp),%r11
 18ec561:	45 01 c3             	add    %r8d,%r11d
 18ec564:	62 d2 7d 08 7a cb    	vpbroadcastb %r11d,%xmm1
 18ec56a:	4c 8d 9e 80 01 00 00 	lea    0x180(%rsi),%r11
 18ec571:	c5 f1 fc ca          	vpaddb %xmm2,%xmm1,%xmm1
 18ec575:	4d 21 cb             	and    %r9,%r11
 18ec578:	c5 f1 db cb          	vpand  %xmm3,%xmm1,%xmm1
 18ec57c:	c4 e2 79 00 c1       	vpshufb %xmm1,%xmm0,%xmm0
 18ec581:	c4 81 79 7f 04 1f    	vmovdqa %xmm0,(%r15,%r11,1)
 18ec587:	4d 8b 0e             	mov    (%r14),%r9
 18ec58a:	c4 c1 79 6f 04 01    	vmovdqa (%r9,%rax,1),%xmm0
 18ec590:	4c 8b 4c 24 10       	mov    0x10(%rsp),%r9
 18ec595:	45 01 c1             	add    %r8d,%r9d
 18ec598:	44 02 84 24 80 00 00 00 	add    0x80(%rsp),%r8b
 18ec5a0:	62 d2 7d 08 7a c9    	vpbroadcastb %r9d,%xmm1
 18ec5a6:	4c 8d 8e c0 01 00 00 	lea    0x1c0(%rsi),%r9
 18ec5ad:	c5 f1 fc ca          	vpaddb %xmm2,%xmm1,%xmm1
 18ec5b1:	4d 21 d1             	and    %r10,%r9
 18ec5b4:	49 81 c2 00 02 00 00 	add    $0x200,%r10
 18ec5bb:	c5 f1 db cb          	vpand  %xmm3,%xmm1,%xmm1
 18ec5bf:	c4 e2 79 00 c1       	vpshufb %xmm1,%xmm0,%xmm0
 18ec5c4:	c4 81 79 7f 04 0f    	vmovdqa %xmm0,(%r15,%r9,1)
 18ec5ca:	48 39 fb             	cmp    %rdi,%rbx
 18ec5cd:	0f 85 19 fe ff ff    	jne    18ec3ec <tier0_tables_open+0x507c>
 18ec5d3:	48 85 d2             	test   %rdx,%rdx
 18ec5d6:	0f 84 73 03 00 00    	je     18ec94f <tier0_tables_open+0x55df>
 18ec5dc:	41 89 c8             	mov    %ecx,%r8d
 18ec5df:	44 0f af c7          	imul   %edi,%r8d
 18ec5e3:	48 c1 e7 06          	shl    $0x6,%rdi
 18ec5e7:	4d 8b 0e             	mov    (%r14),%r9
 18ec5ea:	62 d2 7d 08 7a c8    	vpbroadcastb %r8d,%xmm1
 18ec5f0:	c5 f1 fc 0d 88 fb cb fe 	vpaddb -0x1340478(%rip),%xmm1,%xmm1        # 5ac180 <x86_effects_unknown+0x1b0>
 18ec5f8:	48 be 00 fe ff ff 3f 00 00 00 	movabs $0x3ffffffe00,%rsi
 18ec602:	41 00 c8             	add    %cl,%r8b
 18ec605:	62 f1 75 18 db 0d bd a4 cc fe 	vpandd -0x1335b43(%rip){1to4},%xmm1,%xmm1        # 5b6acc <tier0_emit_x87.operations+0x7c>
 18ec60f:	48 81 c6 c0 01 00 00 	add    $0x1c0,%rsi
 18ec616:	48 21 fe             	and    %rdi,%rsi
 18ec619:	48 83 c7 40          	add    $0x40,%rdi
 18ec61d:	48 ff ca             	dec    %rdx
 18ec620:	c4 c1 79 6f 04 01    	vmovdqa (%r9,%rax,1),%xmm0
 18ec626:	4c 8b 4c 24 08       	mov    0x8(%rsp),%r9
 18ec62b:	c4 e2 79 00 c1       	vpshufb %xmm1,%xmm0,%xmm0
 18ec630:	c4 c1 79 7f 04 31    	vmovdqa %xmm0,(%r9,%rsi,1)
 18ec636:	75 af                	jne    18ec5e7 <tier0_tables_open+0x5277>
 18ec638:	e9 12 03 00 00       	jmp    18ec94f <tier0_tables_open+0x55df>
 18ec63d:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
 18ec642:	89 d1                	mov    %edx,%ecx
 18ec644:	83 e1 07             	and    $0x7,%ecx
 18ec647:	48 83 fa 08          	cmp    $0x8,%rdx
 18ec64b:	0f 83 fe 01 00 00    	jae    18ec84f <tier0_tables_open+0x54df>
 18ec651:	31 d2                	xor    %edx,%edx
 18ec653:	e9 c4 02 00 00       	jmp    18ec91c <tier0_tables_open+0x55ac>
 18ec658:	4c 8b 4c 24 58       	mov    0x58(%rsp),%r9
 18ec65d:	41 89 cf             	mov    %ecx,%r15d
 18ec660:	41 83 e7 7f          	and    $0x7f,%r15d
 18ec664:	45 31 e4             	xor    %r12d,%r12d
 18ec667:	45 31 ed             	xor    %r13d,%r13d
 18ec66a:	31 ed                	xor    %ebp,%ebp
 18ec66c:	45 31 db             	xor    %r11d,%r11d
 18ec66f:	48 c7 44 24 30 00 00 00 00 	movq   $0x0,0x30(%rsp)
 18ec678:	45 31 c0             	xor    %r8d,%r8d
 18ec67b:	45 01 ff             	add    %r15d,%r15d
 18ec67e:	49 83 e1 fe          	and    $0xfffffffffffffffe,%r9
 18ec682:	eb 25                	jmp    18ec6a9 <tier0_tables_open+0x5339>
 18ec684:	48 8d 14 8d 00 00 00 00 	lea    0x0(,%rcx,4),%rdx
 18ec68c:	49 83 c0 02          	add    $0x2,%r8
 18ec690:	49 83 eb 80          	sub    $0xffffffffffffff80,%r11
 18ec694:	4d 01 fc             	add    %r15,%r12
 18ec697:	49 01 cd             	add    %rcx,%r13
 18ec69a:	49 01 cd             	add    %rcx,%r13
 18ec69d:	48 01 d5             	add    %rdx,%rbp
 18ec6a0:	4d 39 c1             	cmp    %r8,%r9
 18ec6a3:	0f 84 03 01 00 00    	je     18ec7ac <tier0_tables_open+0x543c>
 18ec6a9:	49 8b 36             	mov    (%r14),%rsi
 18ec6ac:	62 d2 7d 08 7a cc    	vpbroadcastb %r12d,%xmm1
 18ec6b2:	c5 f1 fc 0d c6 fa cb fe 	vpaddb -0x134053a(%rip),%xmm1,%xmm1        # 5ac180 <x86_effects_unknown+0x1b0>
 18ec6ba:	48 ba 00 fe ff ff 3f 00 00 00 	movabs $0x3ffffffe00,%rdx
 18ec6c4:	62 f1 75 18 db 0d fe a3 cc fe 	vpandd -0x1335c02(%rip){1to4},%xmm1,%xmm1        # 5b6acc <tier0_emit_x87.operations+0x7c>
 18ec6ce:	4c 8d 92 80 01 00 00 	lea    0x180(%rdx),%r10
 18ec6d5:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
 18ec6da:	4d 21 da             	and    %r11,%r10
 18ec6dd:	c5 f9 6f 04 06       	vmovdqa (%rsi,%rax,1),%xmm0
 18ec6e2:	c4 e2 79 00 c1       	vpshufb %xmm1,%xmm0,%xmm0
 18ec6e7:	c4 a1 79 7f 04 12    	vmovdqa %xmm0,(%rdx,%r10,1)
 18ec6ed:	49 83 fd 0f          	cmp    $0xf,%r13
 18ec6f1:	77 28                	ja     18ec71b <tier0_tables_open+0x53ab>
 18ec6f3:	c4 e2 91 f7 54 24 10 	shlx   %r13,0x10(%rsp),%rdx
 18ec6fa:	48 be 00 00 00 00 ff ff 00 00 	movabs $0xffff00000000,%rsi
 18ec704:	c4 62 d1 f7 d3       	shlx   %rbp,%rbx,%r10
 18ec709:	45 89 d2             	mov    %r10d,%r10d
 18ec70c:	48 c1 e2 20          	shl    $0x20,%rdx
 18ec710:	48 21 f2             	and    %rsi,%rdx
 18ec713:	4c 09 d2             	or     %r10,%rdx
 18ec716:	48 09 54 24 30       	or     %rdx,0x30(%rsp)
 18ec71b:	49 8b 3e             	mov    (%r14),%rdi
 18ec71e:	48 be 00 fe ff ff 3f 00 00 00 	movabs $0x3ffffffe00,%rsi
 18ec728:	49 8d 53 40          	lea    0x40(%r11),%rdx
 18ec72c:	4c 8d 96 c0 01 00 00 	lea    0x1c0(%rsi),%r10
 18ec733:	42 8d 34 21          	lea    (%rcx,%r12,1),%esi
 18ec737:	62 f2 7d 08 7a ce    	vpbroadcastb %esi,%xmm1
 18ec73d:	c5 f1 fc 0d 3b fa cb fe 	vpaddb -0x13405c5(%rip),%xmm1,%xmm1        # 5ac180 <x86_effects_unknown+0x1b0>
 18ec745:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
 18ec74a:	4c 21 d2             	and    %r10,%rdx
 18ec74d:	4e 8d 14 29          	lea    (%rcx,%r13,1),%r10
 18ec751:	62 f1 75 18 db 0d 71 a3 cc fe 	vpandd -0x1335c8f(%rip){1to4},%xmm1,%xmm1        # 5b6acc <tier0_emit_x87.operations+0x7c>
 18ec75b:	c5 f9 6f 04 07       	vmovdqa (%rdi,%rax,1),%xmm0
 18ec760:	c4 e2 79 00 c1       	vpshufb %xmm1,%xmm0,%xmm0
 18ec765:	c5 f9 7f 04 16       	vmovdqa %xmm0,(%rsi,%rdx,1)
 18ec76a:	49 83 fa 0f          	cmp    $0xf,%r10
 18ec76e:	0f 87 10 ff ff ff    	ja     18ec684 <tier0_tables_open+0x5314>
 18ec774:	c4 e2 a9 f7 7c 24 10 	shlx   %r10,0x10(%rsp),%rdi
 18ec77b:	48 8d 14 09          	lea    (%rcx,%rcx,1),%rdx
 18ec77f:	be 00 00 00 00       	mov    $0x0,%esi
 18ec784:	01 ea                	add    %ebp,%edx
 18ec786:	c4 e2 e9 f7 d3       	shlx   %rdx,%rbx,%rdx
 18ec78b:	83 e2 fe             	and    $0xfffffffe,%edx
 18ec78e:	f6 c1 01             	test   $0x1,%cl
 18ec791:	48 0f 45 d6          	cmovne %rsi,%rdx
 18ec795:	81 e7 fe ff 00 00    	and    $0xfffe,%edi
 18ec79b:	48 c1 e7 20          	shl    $0x20,%rdi
 18ec79f:	48 09 d7             	or     %rdx,%rdi
 18ec7a2:	48 09 7c 24 30       	or     %rdi,0x30(%rsp)
 18ec7a7:	e9 d8 fe ff ff       	jmp    18ec684 <tier0_tables_open+0x5314>
 18ec7ac:	f6 44 24 58 01       	testb  $0x1,0x58(%rsp)
 18ec7b1:	0f 84 8a 00 00 00    	je     18ec841 <tier0_tables_open+0x54d1>
 18ec7b7:	49 8b 3e             	mov    (%r14),%rdi
 18ec7ba:	49 0f af c8          	imul   %r8,%rcx
 18ec7be:	48 be 00 fe ff ff 3f 00 00 00 	movabs $0x3ffffffe00,%rsi
 18ec7c8:	4c 89 c2             	mov    %r8,%rdx
 18ec7cb:	48 c1 e2 06          	shl    $0x6,%rdx
 18ec7cf:	48 81 c6 c0 01 00 00 	add    $0x1c0,%rsi
 18ec7d6:	48 21 d6             	and    %rdx,%rsi
 18ec7d9:	62 f2 7d 08 7a c9    	vpbroadcastb %ecx,%xmm1
 18ec7df:	c5 f1 fc 0d 99 f9 cb fe 	vpaddb -0x1340667(%rip),%xmm1,%xmm1        # 5ac180 <x86_effects_unknown+0x1b0>
 18ec7e7:	62 f1 75 18 db 0d db a2 cc fe 	vpandd -0x1335d25(%rip){1to4},%xmm1,%xmm1        # 5b6acc <tier0_emit_x87.operations+0x7c>
 18ec7f1:	c5 f9 6f 04 07       	vmovdqa (%rdi,%rax,1),%xmm0
 18ec7f6:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 18ec7fb:	c4 e2 79 00 c1       	vpshufb %xmm1,%xmm0,%xmm0
 18ec800:	c5 f9 7f 04 30       	vmovdqa %xmm0,(%rax,%rsi,1)
 18ec805:	48 83 f9 0f          	cmp    $0xf,%rcx
 18ec809:	77 36                	ja     18ec841 <tier0_tables_open+0x54d1>
 18ec80b:	c4 e2 f1 f7 54 24 10 	shlx   %rcx,0x10(%rsp),%rdx
 18ec812:	89 c8                	mov    %ecx,%eax
 18ec814:	01 c9                	add    %ecx,%ecx
 18ec816:	a8 01                	test   $0x1,%al
 18ec818:	c4 e2 f1 f7 c3       	shlx   %rcx,%rbx,%rax
 18ec81d:	b9 00 00 00 00       	mov    $0x0,%ecx
 18ec822:	89 c0                	mov    %eax,%eax
 18ec824:	48 0f 45 c1          	cmovne %rcx,%rax
 18ec828:	48 b9 00 00 00 00 ff ff 00 00 	movabs $0xffff00000000,%rcx
 18ec832:	48 c1 e2 20          	shl    $0x20,%rdx
 18ec836:	48 21 ca             	and    %rcx,%rdx
 18ec839:	48 09 c2             	or     %rax,%rdx
 18ec83c:	48 09 54 24 30       	or     %rdx,0x30(%rsp)
 18ec841:	48 c7 44 24 50 00 00 00 00 	movq   $0x0,0x50(%rsp)
 18ec84a:	e9 12 01 00 00       	jmp    18ec961 <tier0_tables_open+0x55f1>
 18ec84f:	48 8b 7c 24 58       	mov    0x58(%rsp),%rdi
 18ec854:	45 31 c0             	xor    %r8d,%r8d
 18ec857:	31 d2                	xor    %edx,%edx
 18ec859:	48 83 e7 f8          	and    $0xfffffffffffffff8,%rdi
 18ec85d:	4d 8b 16             	mov    (%r14),%r10
 18ec860:	48 be 00 fe ff ff 3f 00 00 00 	movabs $0x3ffffffe00,%rsi
 18ec86a:	4d 89 c1             	mov    %r8,%r9
 18ec86d:	48 83 c2 08          	add    $0x8,%rdx
 18ec871:	49 81 c0 00 02 00 00 	add    $0x200,%r8
 18ec878:	49 21 f1             	and    %rsi,%r9
 18ec87b:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
 18ec880:	c4 c1 78 28 04 02    	vmovaps (%r10,%rax,1),%xmm0
 18ec886:	c4 a1 78 29 04 0e    	vmovaps %xmm0,(%rsi,%r9,1)
 18ec88c:	4d 8b 16             	mov    (%r14),%r10
 18ec88f:	c4 c1 78 28 04 02    	vmovaps (%r10,%rax,1),%xmm0
 18ec895:	c4 a1 78 29 44 0e 40 	vmovaps %xmm0,0x40(%rsi,%r9,1)
 18ec89c:	4d 8b 16             	mov    (%r14),%r10
 18ec89f:	c4 c1 78 28 04 02    	vmovaps (%r10,%rax,1),%xmm0
 18ec8a5:	c4 a1 78 29 84 0e 80 00 00 00 	vmovaps %xmm0,0x80(%rsi,%r9,1)
 18ec8af:	4d 8b 16             	mov    (%r14),%r10
 18ec8b2:	c4 c1 78 28 04 02    	vmovaps (%r10,%rax,1),%xmm0
 18ec8b8:	c4 a1 78 29 84 0e c0 00 00 00 	vmovaps %xmm0,0xc0(%rsi,%r9,1)
 18ec8c2:	4d 8b 16             	mov    (%r14),%r10
 18ec8c5:	c4 c1 78 28 04 02    	vmovaps (%r10,%rax,1),%xmm0
 18ec8cb:	c4 a1 78 29 84 0e 00 01 00 00 	vmovaps %xmm0,0x100(%rsi,%r9,1)
 18ec8d5:	4d 8b 16             	mov    (%r14),%r10
 18ec8d8:	c4 c1 78 28 04 02    	vmovaps (%r10,%rax,1),%xmm0
 18ec8de:	c4 a1 78 29 84 0e 40 01 00 00 	vmovaps %xmm0,0x140(%rsi,%r9,1)
 18ec8e8:	4d 8b 16             	mov    (%r14),%r10
 18ec8eb:	c4 c1 78 28 04 02    	vmovaps (%r10,%rax,1),%xmm0
 18ec8f1:	c4 a1 78 29 84 0e 80 01 00 00 	vmovaps %xmm0,0x180(%rsi,%r9,1)
 18ec8fb:	4d 8b 16             	mov    (%r14),%r10
 18ec8fe:	c4 c1 79 6f 04 02    	vmovdqa (%r10,%rax,1),%xmm0
 18ec904:	c4 a1 79 7f 84 0e c0 01 00 00 	vmovdqa %xmm0,0x1c0(%rsi,%r9,1)
 18ec90e:	48 39 d7             	cmp    %rdx,%rdi
 18ec911:	0f 85 46 ff ff ff    	jne    18ec85d <tier0_tables_open+0x54ed>
 18ec917:	48 85 c9             	test   %rcx,%rcx
 18ec91a:	74 33                	je     18ec94f <tier0_tables_open+0x55df>
 18ec91c:	48 c1 e2 06          	shl    $0x6,%rdx
 18ec920:	49 8b 3e             	mov    (%r14),%rdi
 18ec923:	48 be 00 fe ff ff 3f 00 00 00 	movabs $0x3ffffffe00,%rsi
 18ec92d:	48 81 c6 c0 01 00 00 	add    $0x1c0,%rsi
 18ec934:	48 21 d6             	and    %rdx,%rsi
 18ec937:	48 83 c2 40          	add    $0x40,%rdx
 18ec93b:	48 ff c9             	dec    %rcx
 18ec93e:	c5 f9 6f 04 07       	vmovdqa (%rdi,%rax,1),%xmm0
 18ec943:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
 18ec948:	c5 f9 7f 04 37       	vmovdqa %xmm0,(%rdi,%rsi,1)
 18ec94d:	75 d1                	jne    18ec920 <tier0_tables_open+0x55b0>
 18ec94f:	48 c7 44 24 50 00 00 00 00 	movq   $0x0,0x50(%rsp)
 18ec958:	48 c7 44 24 30 00 00 00 00 	movq   $0x0,0x30(%rsp)
 18ec961:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
 18ec966:	3b 44 24 68          	cmp    0x68(%rsp),%eax
 18ec96a:	0f 83 c2 00 00 00    	jae    18eca32 <tier0_tables_open+0x56c2>
 18ec970:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
 18ec975:	48 8b 4c 24 68       	mov    0x68(%rsp),%rcx
 18ec97a:	29 d1                	sub    %edx,%ecx
 18ec97c:	89 d0                	mov    %edx,%eax
 18ec97e:	48 89 c2             	mov    %rax,%rdx
 18ec981:	83 e1 07             	and    $0x7,%ecx
 18ec984:	74 3b                	je     18ec9c1 <tier0_tables_open+0x5651>
 18ec986:	48 89 c2             	mov    %rax,%rdx
 18ec989:	48 c1 e2 06          	shl    $0x6,%rdx
 18ec98d:	48 03 94 24 88 01 00 00 	add    0x188(%rsp),%rdx
 18ec995:	48 f7 d9             	neg    %rcx
 18ec998:	31 ff                	xor    %edi,%edi
 18ec99a:	48 03 94 24 80 01 00 00 	add    0x180(%rsp),%rdx
 18ec9a2:	c4 e2 79 59 05 5d 9d cc fe 	vpbroadcastq -0x13362a3(%rip),%xmm0        # 5b6708 <x86_semantics_benchmark_code.registers+0x110>
 18ec9ab:	48 ff cf             	dec    %rdi
 18ec9ae:	c5 f9 7f 02          	vmovdqa %xmm0,(%rdx)
 18ec9b2:	48 83 c2 40          	add    $0x40,%rdx
 18ec9b6:	48 39 f9             	cmp    %rdi,%rcx
 18ec9b9:	75 e7                	jne    18ec9a2 <tier0_tables_open+0x5632>
 18ec9bb:	48 89 c2             	mov    %rax,%rdx
 18ec9be:	48 29 fa             	sub    %rdi,%rdx
 18ec9c1:	48 2b 44 24 68       	sub    0x68(%rsp),%rax
 18ec9c6:	48 83 f8 f8          	cmp    $0xfffffffffffffff8,%rax
 18ec9ca:	77 66                	ja     18eca32 <tier0_tables_open+0x56c2>
 18ec9cc:	48 8b 84 24 88 01 00 00 	mov    0x188(%rsp),%rax
 18ec9d4:	48 29 54 24 68       	sub    %rdx,0x68(%rsp)
 18ec9d9:	48 c1 e2 06          	shl    $0x6,%rdx
 18ec9dd:	48 03 84 24 78 01 00 00 	add    0x178(%rsp),%rax
 18ec9e5:	48 01 d0             	add    %rdx,%rax
 18ec9e8:	c4 e2 79 59 05 17 9d cc fe 	vpbroadcastq -0x13362e9(%rip),%xmm0        # 5b6708 <x86_semantics_benchmark_code.registers+0x110>
 18ec9f1:	c5 f9 7f 80 00 ff ff ff 	vmovdqa %xmm0,-0x100(%rax)
 18ec9f9:	c5 f9 7f 80 40 ff ff ff 	vmovdqa %xmm0,-0xc0(%rax)
 18eca01:	c5 f9 7f 40 80       	vmovdqa %xmm0,-0x80(%rax)
 18eca06:	c5 f9 7f 40 c0       	vmovdqa %xmm0,-0x40(%rax)
 18eca0b:	c5 f9 7f 00          	vmovdqa %xmm0,(%rax)
 18eca0f:	c5 f9 7f 40 40       	vmovdqa %xmm0,0x40(%rax)
 18eca14:	c5 f9 7f 80 80 00 00 00 	vmovdqa %xmm0,0x80(%rax)
 18eca1c:	c5 f9 7f 80 c0 00 00 00 	vmovdqa %xmm0,0xc0(%rax)
 18eca24:	48 05 00 02 00 00    	add    $0x200,%rax
 18eca2a:	48 83 44 24 68 f8    	addq   $0xfffffffffffffff8,0x68(%rsp)
 18eca30:	75 b6                	jne    18ec9e8 <tier0_tables_open+0x5678>
 18eca32:	80 bc 24 00 01 00 00 00 	cmpb   $0x0,0x100(%rsp)
 18eca3a:	0f 84 29 ec ff ff    	je     18eb669 <tier0_tables_open+0x42f9>
 18eca40:	48 8b 0c 24          	mov    (%rsp),%rcx
 18eca44:	48 8b 94 24 f0 00 00 00 	mov    0xf0(%rsp),%rdx
 18eca4c:	48 8b 01             	mov    (%rcx),%rax
 18eca4f:	48 8b 49 38          	mov    0x38(%rcx),%rcx
 18eca53:	0f b6 34 10          	movzbl (%rax,%rdx,1),%esi
 18eca57:	48 8b 0c d1          	mov    (%rcx,%rdx,8),%rcx
 18eca5b:	40 80 fe 11          	cmp    $0x11,%sil
 18eca5f:	75 52                	jne    18ecab3 <tier0_tables_open+0x5743>
 18eca61:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
 18eca66:	ba ff ff ff ff       	mov    $0xffffffff,%edx
 18eca6b:	4c 8d 42 01          	lea    0x1(%rdx),%r8
 18eca6f:	48 89 f8             	mov    %rdi,%rax
 18eca72:	48 c1 e8 3c          	shr    $0x3c,%rax
 18eca76:	49 21 f8             	and    %rdi,%r8
 18eca79:	c4 e2 78 f5 d1       	bzhi   %eax,%ecx,%edx
 18eca7e:	ba 00 00 00 00       	mov    $0x0,%edx
 18eca83:	0f 44 d0             	cmove  %eax,%edx
 18eca86:	b8 37 05 00 00       	mov    $0x537,%eax
 18eca8b:	c4 e2 f8 f7 c7       	bextr  %rax,%rdi,%rax
 18eca90:	bf 10 00 00 00       	mov    $0x10,%edi
 18eca95:	48 83 f8 10          	cmp    $0x10,%rax
 18eca99:	48 0f 43 c7          	cmovae %rdi,%rax
 18eca9d:	48 c7 c7 ff ff ff ff 	mov    $0xffffffffffffffff,%rdi
 18ecaa4:	c4 e2 f9 f7 ff       	shlx   %rax,%rdi,%rdi
 18ecaa9:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
 18ecaae:	48 f7 d7             	not    %rdi
 18ecab1:	eb 5f                	jmp    18ecb12 <tier0_tables_open+0x57a2>
 18ecab3:	48 b8 00 00 00 00 00 00 01 00 	movabs $0x1000000000000,%rax
 18ecabd:	31 d2                	xor    %edx,%edx
 18ecabf:	48 85 44 24 50       	test   %rax,0x50(%rsp)
 18ecac4:	75 23                	jne    18ecae9 <tier0_tables_open+0x5779>
 18ecac6:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
 18ecacb:	48 c1 e8 20          	shr    $0x20,%rax
 18ecacf:	83 c8 01             	or     $0x1,%eax
 18ecad2:	0f b7 c0             	movzwl %ax,%eax
 18ecad5:	f3 0f bd d0          	lzcnt  %eax,%edx
 18ecad9:	83 f2 1f             	xor    $0x1f,%edx
 18ecadc:	c4 e2 68 f5 c1       	bzhi   %edx,%ecx,%eax
 18ecae1:	b8 00 00 00 00       	mov    $0x0,%eax
 18ecae6:	0f 45 d0             	cmovne %eax,%edx
 18ecae9:	4c 8b 54 24 50       	mov    0x50(%rsp),%r10
 18ecaee:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
 18ecaf3:	48 b8 00 00 00 00 00 00 02 00 	movabs $0x2000000000000,%rax
 18ecafd:	4d 89 d0             	mov    %r10,%r8
 18ecb00:	4c 89 cf             	mov    %r9,%rdi
 18ecb03:	49 21 c0             	and    %rax,%r8
 18ecb06:	48 c1 ef 30          	shr    $0x30,%rdi
 18ecb0a:	4c 89 d0             	mov    %r10,%rax
 18ecb0d:	4c 89 4c 24 50       	mov    %r9,0x50(%rsp)
 18ecb12:	45 31 c9             	xor    %r9d,%r9d
 18ecb15:	4d 85 c0             	test   %r8,%r8
 18ecb18:	41 b8 10 00 00 00    	mov    $0x10,%r8d
 18ecb1e:	49 bb 00 00 00 00 00 00 04 00 	movabs $0x4000000000000,%r11
 18ecb28:	41 0f 95 c2          	setne  %r10b
 18ecb2c:	48 83 f9 10          	cmp    $0x10,%rcx
 18ecb30:	49 0f 43 c8          	cmovae %r8,%rcx
 18ecb34:	45 31 c0             	xor    %r8d,%r8d
 18ecb37:	4c 85 d8             	test   %r11,%rax
 18ecb3a:	41 0f 94 c3          	sete   %r11b
 18ecb3e:	40 80 fe 08          	cmp    $0x8,%sil
 18ecb42:	0f 84 d3 ea ff ff    	je     18eb61b <tier0_tables_open+0x42ab>
 18ecb48:	45 88 d1             	mov    %r10b,%r9b
 18ecb4b:	45 88 d8             	mov    %r11b,%r8b
 18ecb4e:	bd ff ff ff ff       	mov    $0xffffffff,%ebp
 18ecb53:	48 c1 e8 2d          	shr    $0x2d,%rax
 18ecb57:	8b 74 24 50          	mov    0x50(%rsp),%esi
 18ecb5b:	41 c1 e1 04          	shl    $0x4,%r9d
 18ecb5f:	41 c1 e0 05          	shl    $0x5,%r8d
 18ecb63:	c4 e2 71 f7 cd       	shlx   %ecx,%ebp,%ecx
 18ecb68:	83 e0 40             	and    $0x40,%eax
 18ecb6b:	45 09 c8             	or     %r9d,%r8d
 18ecb6e:	09 cf                	or     %ecx,%edi
 18ecb70:	b9 55 55 00 00       	mov    $0x5555,%ecx
 18ecb75:	41 09 d0             	or     %edx,%r8d
 18ecb78:	f7 d7                	not    %edi
 18ecb7a:	48 ba 00 00 00 00 ff ff 00 00 	movabs $0xffff00000000,%rdx
 18ecb84:	44 09 c0             	or     %r8d,%eax
 18ecb87:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
 18ecb8c:	c4 e2 42 f5 c9       	pext   %ecx,%edi,%ecx
 18ecb91:	bf 11 11 11 11       	mov    $0x11111111,%edi
 18ecb96:	c4 e2 73 f5 cf       	pdep   %edi,%ecx,%ecx
 18ecb9b:	49 21 d0             	and    %rdx,%r8
 18ecb9e:	49 09 f0             	or     %rsi,%r8
 18ecba1:	49 09 c8             	or     %rcx,%r8
 18ecba4:	4c 89 44 24 30       	mov    %r8,0x30(%rsp)
 18ecba9:	e9 95 ea ff ff       	jmp    18eb643 <tier0_tables_open+0x42d3>
 18ecbae:	48 83 bc 24 e8 00 00 00 00 	cmpq   $0x0,0xe8(%rsp)
 18ecbb7:	0f 84 62 e9 ff ff    	je     18eb51f <tier0_tables_open+0x41af>
 18ecbbd:	83 bc 24 b4 00 00 00 00 	cmpl   $0x0,0xb4(%rsp)
 18ecbc5:	0f 84 79 04 00 00    	je     18ed044 <tier0_tables_open+0x5cd4>
 18ecbcb:	48 8b 04 24          	mov    (%rsp),%rax
 18ecbcf:	31 c9                	xor    %ecx,%ecx
 18ecbd1:	48 05 00 02 00 00    	add    $0x200,%rax
 18ecbd7:	62 f1 fd 48 6f 00    	vmovdqa64 (%rax),%zmm0
 18ecbdd:	48 8b 84 24 e8 00 00 00 	mov    0xe8(%rsp),%rax
 18ecbe5:	48 05 c0 01 00 00    	add    $0x1c0,%rax
 18ecbeb:	eb 11                	jmp    18ecbfe <tier0_tables_open+0x588e>
 18ecbed:	48 ff c1             	inc    %rcx
 18ecbf0:	48 3b 8c 24 50 01 00 00 	cmp    0x150(%rsp),%rcx
 18ecbf8:	0f 84 46 04 00 00    	je     18ed044 <tier0_tables_open+0x5cd4>
 18ecbfe:	4c 8b 94 24 20 01 00 00 	mov    0x120(%rsp),%r10
 18ecc06:	4c 8d 0c 49          	lea    (%rcx,%rcx,2),%r9
 18ecc0a:	62 f2 fd 48 59 0d f4 9a cc fe 	vpbroadcastq -0x133650c(%rip),%zmm1        # 5b6708 <x86_semantics_benchmark_code.registers+0x110>
 18ecc14:	49 c1 e1 04          	shl    $0x4,%r9
 18ecc18:	47 8b 04 0a          	mov    (%r10,%r9,1),%r8d
 18ecc1c:	43 8b 7c 0a 04       	mov    0x4(%r10,%r9,1),%edi
 18ecc21:	43 8b 74 0a 08       	mov    0x8(%r10,%r9,1),%esi
 18ecc26:	43 8b 54 0a 0c       	mov    0xc(%r10,%r9,1),%edx
 18ecc2b:	4f 8b 5c 0a 10       	mov    0x10(%r10,%r9,1),%r11
 18ecc30:	47 8b 7c 0a 18       	mov    0x18(%r10,%r9,1),%r15d
 18ecc35:	c4 81 f8 90 4c 0a 20 	kmovq  0x20(%r10,%r9,1),%k1
 18ecc3c:	c4 81 f8 90 44 0a 28 	kmovq  0x28(%r10,%r9,1),%k0
 18ecc43:	4d 85 ff             	test   %r15,%r15
 18ecc46:	0f 84 e6 02 00 00    	je     18ecf32 <tier0_tables_open+0x5bc2>
 18ecc4c:	45 89 f9             	mov    %r15d,%r9d
 18ecc4f:	49 c1 e3 06          	shl    $0x6,%r11
 18ecc53:	41 83 e1 07          	and    $0x7,%r9d
 18ecc57:	41 83 ff 08          	cmp    $0x8,%r15d
 18ecc5b:	73 12                	jae    18ecc6f <tier0_tables_open+0x58ff>
 18ecc5d:	62 f2 fd 48 59 0d a1 9a cc fe 	vpbroadcastq -0x133655f(%rip),%zmm1        # 5b6708 <x86_semantics_benchmark_code.registers+0x110>
 18ecc67:	45 31 d2             	xor    %r10d,%r10d
 18ecc6a:	e9 57 02 00 00       	jmp    18ecec6 <tier0_tables_open+0x5b56>
 18ecc6f:	62 f2 fd 48 59 0d 8f 9a cc fe 	vpbroadcastq -0x1336571(%rip),%zmm1        # 5b6708 <x86_semantics_benchmark_code.registers+0x110>
 18ecc79:	41 83 e7 f8          	and    $0xfffffff8,%r15d
 18ecc7d:	4e 8d 24 18          	lea    (%rax,%r11,1),%r12
 18ecc81:	45 31 d2             	xor    %r10d,%r10d
 18ecc84:	62 d1 fd 48 6f 5c 24 f9 	vmovdqa64 -0x1c0(%r12),%zmm3
 18ecc8c:	62 f2 7d 48 58 3d 2a 9e cc fe 	vpbroadcastd -0x13361d6(%rip),%zmm7        # 5b6ac0 <tier0_emit_x87.operations+0x70>
 18ecc96:	62 f1 6d 48 71 f1 03 	vpsllw $0x3,%zmm1,%zmm2
 18ecc9d:	62 f1 75 48 71 d1 01 	vpsrlw $0x1,%zmm1,%zmm1
 18ecca4:	62 d1 fd 48 6f 64 24 fa 	vmovdqa64 -0x180(%r12),%zmm4
 18eccac:	62 d1 fd 48 6f 6c 24 fb 	vmovdqa64 -0x140(%r12),%zmm5
 18eccb4:	62 d1 fd 48 6f 74 24 fc 	vmovdqa64 -0x100(%r12),%zmm6
 18eccbc:	49 83 c2 08          	add    $0x8,%r10
 18eccc0:	62 f3 65 48 25 d7 e4 	vpternlogd $0xe4,%zmm7,%zmm3,%zmm2
 18eccc7:	62 f1 65 48 71 d3 04 	vpsrlw $0x4,%zmm3,%zmm3
 18eccce:	62 f3 75 48 25 df d8 	vpternlogd $0xd8,%zmm7,%zmm1,%zmm3
 18eccd5:	62 f2 6d 48 8d c8    	vpermb %zmm0,%zmm2,%zmm1
 18eccdb:	62 f2 65 48 8d d0    	vpermb %zmm0,%zmm3,%zmm2
 18ecce1:	62 f1 65 48 71 d4 04 	vpsrlw $0x4,%zmm4,%zmm3
 18ecce8:	62 f1 6d 48 71 f2 04 	vpsllw $0x4,%zmm2,%zmm2
 18eccef:	62 f1 ed 48 eb c9    	vporq  %zmm1,%zmm2,%zmm1
 18eccf5:	62 f1 6d 48 71 f1 03 	vpsllw $0x3,%zmm1,%zmm2
 18eccfc:	62 f1 75 48 71 d1 01 	vpsrlw $0x1,%zmm1,%zmm1
 18ecd03:	62 f3 75 48 25 df d8 	vpternlogd $0xd8,%zmm7,%zmm1,%zmm3
 18ecd0a:	62 f3 5d 48 25 d7 e4 	vpternlogd $0xe4,%zmm7,%zmm4,%zmm2
 18ecd11:	62 f2 65 48 8d d8    	vpermb %zmm0,%zmm3,%zmm3
 18ecd17:	62 f2 6d 48 8d c8    	vpermb %zmm0,%zmm2,%zmm1
 18ecd1d:	62 f1 6d 48 71 f3 04 	vpsllw $0x4,%zmm3,%zmm2
 18ecd24:	62 f1 65 48 71 d5 04 	vpsrlw $0x4,%zmm5,%zmm3
 18ecd2b:	62 f1 ed 48 eb c9    	vporq  %zmm1,%zmm2,%zmm1
 18ecd31:	62 f1 6d 48 71 f1 03 	vpsllw $0x3,%zmm1,%zmm2
 18ecd38:	62 f1 75 48 71 d1 01 	vpsrlw $0x1,%zmm1,%zmm1
 18ecd3f:	62 f3 75 48 25 df d8 	vpternlogd $0xd8,%zmm7,%zmm1,%zmm3
 18ecd46:	62 f3 55 48 25 d7 e4 	vpternlogd $0xe4,%zmm7,%zmm5,%zmm2
 18ecd4d:	62 d1 fd 48 6f 6c 24 fd 	vmovdqa64 -0xc0(%r12),%zmm5
 18ecd55:	62 f2 65 48 8d e0    	vpermb %zmm0,%zmm3,%zmm4
 18ecd5b:	62 f2 6d 48 8d c8    	vpermb %zmm0,%zmm2,%zmm1
 18ecd61:	62 f1 65 48 71 d6 04 	vpsrlw $0x4,%zmm6,%zmm3
 18ecd68:	62 f1 6d 48 71 f4 04 	vpsllw $0x4,%zmm4,%zmm2
 18ecd6f:	62 d1 fd 48 6f 64 24 fe 	vmovdqa64 -0x80(%r12),%zmm4
 18ecd77:	62 f1 ed 48 eb c9    	vporq  %zmm1,%zmm2,%zmm1
 18ecd7d:	62 f1 6d 48 71 f1 03 	vpsllw $0x3,%zmm1,%zmm2
 18ecd84:	62 f1 75 48 71 d1 01 	vpsrlw $0x1,%zmm1,%zmm1
 18ecd8b:	62 f3 75 48 25 df d8 	vpternlogd $0xd8,%zmm7,%zmm1,%zmm3
 18ecd92:	62 f3 4d 48 25 d7 e4 	vpternlogd $0xe4,%zmm7,%zmm6,%zmm2
 18ecd99:	62 f2 65 48 8d d8    	vpermb %zmm0,%zmm3,%zmm3
 18ecd9f:	62 f2 6d 48 8d c8    	vpermb %zmm0,%zmm2,%zmm1
 18ecda5:	62 f1 6d 48 71 f3 04 	vpsllw $0x4,%zmm3,%zmm2
 18ecdac:	62 f1 ed 48 eb c9    	vporq  %zmm1,%zmm2,%zmm1
 18ecdb2:	62 f1 6d 48 71 d5 04 	vpsrlw $0x4,%zmm5,%zmm2
 18ecdb9:	62 f1 65 48 71 f1 03 	vpsllw $0x3,%zmm1,%zmm3
 18ecdc0:	62 f1 75 48 71 d1 01 	vpsrlw $0x1,%zmm1,%zmm1
 18ecdc7:	62 f3 75 48 25 d7 d8 	vpternlogd $0xd8,%zmm7,%zmm1,%zmm2
 18ecdce:	62 f3 55 48 25 df e4 	vpternlogd $0xe4,%zmm7,%zmm5,%zmm3
 18ecdd5:	62 d1 fd 48 6f 6c 24 ff 	vmovdqa64 -0x40(%r12),%zmm5
 18ecddd:	62 f2 6d 48 8d d0    	vpermb %zmm0,%zmm2,%zmm2
 18ecde3:	62 f2 65 48 8d c8    	vpermb %zmm0,%zmm3,%zmm1
 18ecde9:	62 f1 6d 48 71 f2 04 	vpsllw $0x4,%zmm2,%zmm2
 18ecdf0:	62 f1 ed 48 eb c9    	vporq  %zmm1,%zmm2,%zmm1
 18ecdf6:	62 f1 6d 48 71 d4 04 	vpsrlw $0x4,%zmm4,%zmm2
 18ecdfd:	62 f1 65 48 71 f1 03 	vpsllw $0x3,%zmm1,%zmm3
 18ece04:	62 f1 75 48 71 d1 01 	vpsrlw $0x1,%zmm1,%zmm1
 18ece0b:	62 f3 75 48 25 d7 d8 	vpternlogd $0xd8,%zmm7,%zmm1,%zmm2
 18ece12:	62 f3 5d 48 25 df e4 	vpternlogd $0xe4,%zmm7,%zmm4,%zmm3
 18ece19:	62 d1 fd 48 6f 24 24 	vmovdqa64 (%r12),%zmm4
 18ece20:	49 81 c4 00 02 00 00 	add    $0x200,%r12
 18ece27:	62 f2 6d 48 8d d0    	vpermb %zmm0,%zmm2,%zmm2
 18ece2d:	62 f2 65 48 8d c8    	vpermb %zmm0,%zmm3,%zmm1
 18ece33:	62 f1 6d 48 71 f2 04 	vpsllw $0x4,%zmm2,%zmm2
 18ece3a:	62 f1 ed 48 eb c9    	vporq  %zmm1,%zmm2,%zmm1
 18ece40:	62 f1 6d 48 71 d5 04 	vpsrlw $0x4,%zmm5,%zmm2
 18ece47:	62 f1 65 48 71 f1 03 	vpsllw $0x3,%zmm1,%zmm3
 18ece4e:	62 f1 75 48 71 d1 01 	vpsrlw $0x1,%zmm1,%zmm1
 18ece55:	62 f3 75 48 25 d7 d8 	vpternlogd $0xd8,%zmm7,%zmm1,%zmm2
 18ece5c:	62 f3 55 48 25 df e4 	vpternlogd $0xe4,%zmm7,%zmm5,%zmm3
 18ece63:	62 f2 6d 48 8d d0    	vpermb %zmm0,%zmm2,%zmm2
 18ece69:	62 f2 65 48 8d c8    	vpermb %zmm0,%zmm3,%zmm1
 18ece6f:	62 f1 6d 48 71 f2 04 	vpsllw $0x4,%zmm2,%zmm2
 18ece76:	62 f1 ed 48 eb c9    	vporq  %zmm1,%zmm2,%zmm1
 18ece7c:	62 f1 6d 48 71 d4 04 	vpsrlw $0x4,%zmm4,%zmm2
 18ece83:	62 f1 65 48 71 f1 03 	vpsllw $0x3,%zmm1,%zmm3
 18ece8a:	62 f1 75 48 71 d1 01 	vpsrlw $0x1,%zmm1,%zmm1
 18ece91:	62 f3 75 48 25 d7 d8 	vpternlogd $0xd8,%zmm7,%zmm1,%zmm2
 18ece98:	62 f3 5d 48 25 df e4 	vpternlogd $0xe4,%zmm7,%zmm4,%zmm3
 18ece9f:	62 f2 6d 48 8d d0    	vpermb %zmm0,%zmm2,%zmm2
 18ecea5:	62 f2 65 48 8d c8    	vpermb %zmm0,%zmm3,%zmm1
 18eceab:	62 f1 6d 48 71 f2 04 	vpsllw $0x4,%zmm2,%zmm2
 18eceb2:	62 f1 ed 48 eb c9    	vporq  %zmm1,%zmm2,%zmm1
 18eceb8:	4d 39 d7             	cmp    %r10,%r15
 18ecebb:	0f 85 c3 fd ff ff    	jne    18ecc84 <tier0_tables_open+0x5914>
 18ecec1:	4d 85 c9             	test   %r9,%r9
 18ecec4:	74 6c                	je     18ecf32 <tier0_tables_open+0x5bc2>
 18ecec6:	49 c1 e2 06          	shl    $0x6,%r10
 18ececa:	4c 03 94 24 e8 00 00 00 	add    0xe8(%rsp),%r10
 18eced2:	41 c1 e1 06          	shl    $0x6,%r9d
 18eced6:	4d 01 da             	add    %r11,%r10
 18eced9:	45 31 db             	xor    %r11d,%r11d
 18ecedc:	62 91 fd 48 6f 14 1a 	vmovdqa64 (%r10,%r11,1),%zmm2
 18ecee3:	62 f2 7d 48 58 25 d3 9b cc fe 	vpbroadcastd -0x133642d(%rip),%zmm4        # 5b6ac0 <tier0_emit_x87.operations+0x70>
 18eceed:	62 f1 65 48 71 f1 03 	vpsllw $0x3,%zmm1,%zmm3
 18ecef4:	62 f1 75 48 71 d1 01 	vpsrlw $0x1,%zmm1,%zmm1
 18ecefb:	49 83 c3 40          	add    $0x40,%r11
 18eceff:	62 f3 6d 48 25 dc e4 	vpternlogd $0xe4,%zmm4,%zmm2,%zmm3
 18ecf06:	62 f1 6d 48 71 d2 04 	vpsrlw $0x4,%zmm2,%zmm2
 18ecf0d:	62 f3 75 48 25 d4 d8 	vpternlogd $0xd8,%zmm4,%zmm1,%zmm2
 18ecf14:	62 f2 65 48 8d c8    	vpermb %zmm0,%zmm3,%zmm1
 18ecf1a:	62 f2 6d 48 8d d0    	vpermb %zmm0,%zmm2,%zmm2
 18ecf20:	62 f1 6d 48 71 f2 04 	vpsllw $0x4,%zmm2,%zmm2
 18ecf27:	62 f1 ed 48 eb c9    	vporq  %zmm1,%zmm2,%zmm1
 18ecf2d:	4d 39 d9             	cmp    %r11,%r9
 18ecf30:	75 aa                	jne    18ecedc <tier0_tables_open+0x5b6c>
 18ecf32:	62 f2 7d 48 5a 25 f4 f2 cb fe 	vbroadcasti32x4 -0x1340d0c(%rip),%zmm4        # 5ac230 <x86_effects_unknown+0x260>
 18ecf3c:	62 f1 f5 58 db 1d ca 97 cc fe 	vpandq -0x1336836(%rip){1to8},%zmm1,%zmm3        # 5b6710 <x86_semantics_benchmark_code.registers+0x118>
 18ecf46:	62 f1 6d 48 71 d1 04 	vpsrlw $0x4,%zmm1,%zmm2
 18ecf4d:	62 f3 65 48 3f 1d 68 96 c5 fe 04 	vpcmpneqb -0x13a6998(%rip),%zmm3,%k3        # 5465c0 <branch_sizing_patterns+0x930>
 18ecf58:	62 f1 ed 48 db d4    	vpandq %zmm4,%zmm2,%zmm2
 18ecf5e:	62 f1 6d 48 74 15 18 96 c5 fe 	vpcmpeqb -0x13a69e8(%rip),%zmm2,%k2        # 546580 <branch_sizing_patterns+0x8f0>
 18ecf68:	62 f1 65 48 74 e4    	vpcmpeqb %zmm4,%zmm3,%k4
 18ecf6e:	62 f1 6d 4b 74 1d 88 96 c5 fe 	vpcmpeqb -0x13a6978(%rip),%zmm2,%k3{%k3}        # 546600 <branch_sizing_patterns+0x970>
 18ecf78:	62 f1 6d 48 74 ec    	vpcmpeqb %zmm4,%zmm2,%k5
 18ecf7e:	62 f2 7d 48 5a 25 b8 f2 cb fe 	vbroadcasti32x4 -0x1340d48(%rip),%zmm4        # 5ac240 <x86_effects_unknown+0x270>
 18ecf88:	62 f1 65 58 eb 15 42 9b cc fe 	vpord  -0x13364be(%rip){1to16},%zmm3,%zmm2        # 5b6ad4 <tier0_emit_x87.operations+0x84>
 18ecf92:	c4 e1 dc 45 e5       	korq   %k5,%k4,%k4
 18ecf97:	c4 e1 dc 45 db       	korq   %k3,%k4,%k3
 18ecf9c:	c4 e1 f4 45 cb       	korq   %k3,%k1,%k1
 18ecfa1:	62 f1 65 4a 74 dc    	vpcmpeqb %zmm4,%zmm3,%k3{%k2}
 18ecfa7:	62 f3 65 4a 3f d4 04 	vpcmpneqb %zmm4,%zmm3,%k2{%k2}
 18ecfae:	c4 e1 f8 44 db       	knotq  %k3,%k3
 18ecfb3:	62 f1 7f 4a 6f ca    	vmovdqu8 %zmm2,%zmm1{%k2}
 18ecfb9:	c4 e1 fc 41 c3       	kandq  %k3,%k0,%k0
 18ecfbe:	c4 e1 f4 45 c8       	korq   %k0,%k1,%k1
 18ecfc3:	62 f1 7f 49 6f 0d b3 96 c5 fe 	vmovdqu8 -0x13a694d(%rip),%zmm1{%k1}        # 546680 <branch_sizing_patterns+0x9f0>
 18ecfcd:	41 83 f8 ff          	cmp    $0xffffffff,%r8d
 18ecfd1:	74 0d                	je     18ecfe0 <tier0_tables_open+0x5c70>
 18ecfd3:	4d 8b 0e             	mov    (%r14),%r9
 18ecfd6:	49 c1 e0 04          	shl    $0x4,%r8
 18ecfda:	c4 81 7a 7f 0c 01    	vmovdqu %xmm1,(%r9,%r8,1)
 18ecfe0:	83 ff ff             	cmp    $0xffffffff,%edi
 18ecfe3:	74 0f                	je     18ecff4 <tier0_tables_open+0x5c84>
 18ecfe5:	4d 8b 06             	mov    (%r14),%r8
 18ecfe8:	48 c1 e7 04          	shl    $0x4,%rdi
 18ecfec:	62 d3 7d 48 39 0c 38 01 	vextracti32x4 $0x1,%zmm1,(%r8,%rdi,1)
 18ecff4:	83 fe ff             	cmp    $0xffffffff,%esi
 18ecff7:	74 0f                	je     18ed008 <tier0_tables_open+0x5c98>
 18ecff9:	49 8b 3e             	mov    (%r14),%rdi
 18ecffc:	48 c1 e6 04          	shl    $0x4,%rsi
 18ed000:	62 f3 7d 48 39 0c 37 02 	vextracti32x4 $0x2,%zmm1,(%rdi,%rsi,1)
 18ed008:	83 fa ff             	cmp    $0xffffffff,%edx
 18ed00b:	0f 84 dc fb ff ff    	je     18ecbed <tier0_tables_open+0x587d>
 18ed011:	49 8b 36             	mov    (%r14),%rsi
 18ed014:	48 c1 e2 04          	shl    $0x4,%rdx
 18ed018:	62 f3 7d 48 39 0c 16 03 	vextracti32x4 $0x3,%zmm1,(%rsi,%rdx,1)
 18ed020:	e9 c8 fb ff ff       	jmp    18ecbed <tier0_tables_open+0x587d>
 18ed025:	48 8b 34 24          	mov    (%rsp),%rsi
 18ed029:	4c 89 f7             	mov    %r14,%rdi
 18ed02c:	c5 f8 77             	vzeroupper
 18ed02f:	e8 7c ec 00 00       	call   18fbcb0 <abi_finish>
 18ed034:	48 83 44 24 78 0c    	addq   $0xc,0x78(%rsp)
 18ed03a:	48 ff 8c 24 98 00 00 00 	decq   0x98(%rsp)
 18ed042:	74 2c                	je     18ed070 <tier0_tables_open+0x5d00>
 18ed044:	48 8b 44 24 78       	mov    0x78(%rsp),%rax
 18ed049:	8b 10                	mov    (%rax),%edx
 18ed04b:	80 78 0b 01          	cmpb   $0x1,0xb(%rax)
 18ed04f:	75 d4                	jne    18ed025 <tier0_tables_open+0x5cb5>
 18ed051:	48 8b 34 24          	mov    (%rsp),%rsi
 18ed055:	4c 89 f7             	mov    %r14,%rdi
 18ed058:	c5 f8 77             	vzeroupper
 18ed05b:	e8 c0 f9 00 00       	call   18fca20 <abi_finish_passing>
 18ed060:	48 83 44 24 78 0c    	addq   $0xc,0x78(%rsp)
 18ed066:	48 ff 8c 24 98 00 00 00 	decq   0x98(%rsp)
 18ed06e:	75 d4                	jne    18ed044 <tier0_tables_open+0x5cd4>
 18ed070:	b1 01                	mov    $0x1,%cl
 18ed072:	64 48 8b 04 25 18 ff ff ff 	mov    %fs:0xffffffffffffff18,%rax
 18ed07b:	48 39 84 24 c0 00 00 00 	cmp    %rax,0xc0(%rsp)
 18ed083:	0f 87 99 00 00 00    	ja     18ed122 <tier0_tables_open+0x5db2>
 18ed089:	48 8b 84 24 c0 00 00 00 	mov    0xc0(%rsp),%rax
 18ed091:	64 48 89 04 25 18 ff ff ff 	mov    %rax,%fs:0xffffffffffffff18
 18ed09a:	84 c9                	test   %cl,%cl
 18ed09c:	75 1e                	jne    18ed0bc <tier0_tables_open+0x5d4c>
 18ed09e:	48 8b 34 24          	mov    (%rsp),%rsi
 18ed0a2:	48 8b 94 24 60 01 00 00 	mov    0x160(%rsp),%rdx
 18ed0aa:	8b 8c 24 a0 00 00 00 	mov    0xa0(%rsp),%ecx
 18ed0b1:	4c 89 f7             	mov    %r14,%rdi
 18ed0b4:	c5 f8 77             	vzeroupper
 18ed0b7:	e8 64 13 01 00       	call   18fe420 <abi_classify_scalar>
 18ed0bc:	83 7c 24 2c 00       	cmpl   $0x0,0x2c(%rsp)
 18ed0c1:	74 0e                	je     18ed0d1 <tier0_tables_open+0x5d61>
 18ed0c3:	83 bc 24 a0 00 00 00 00 	cmpl   $0x0,0xa0(%rsp)
 18ed0cb:	0f 85 c9 d5 ff ff    	jne    18ea69a <tier0_tables_open+0x332a>
 18ed0d1:	48 8b 84 24 58 01 00 00 	mov    0x158(%rsp),%rax
 18ed0d9:	64 48 3b 04 25 18 ff ff ff 	cmp    %fs:0xffffffffffffff18,%rax
 18ed0e2:	77 3e                	ja     18ed122 <tier0_tables_open+0x5db2>
 18ed0e4:	48 8b 84 24 58 01 00 00 	mov    0x158(%rsp),%rax
 18ed0ec:	48 8b 0c 24          	mov    (%rsp),%rcx
 18ed0f0:	64 48 89 04 25 18 ff ff ff 	mov    %rax,%fs:0xffffffffffffff18
 18ed0f9:	8b b1 60 1f 00 00    	mov    0x1f60(%rcx),%esi
 18ed0ff:	48 85 f6             	test   %rsi,%rsi
 18ed102:	74 40                	je     18ed144 <tier0_tables_open+0x5dd4>
 18ed104:	48 8b 04 24          	mov    (%rsp),%rax
 18ed108:	89 f2                	mov    %esi,%edx
 18ed10a:	83 e2 03             	and    $0x3,%edx
 18ed10d:	48 8b 88 b0 01 00 00 	mov    0x1b0(%rax),%rcx
 18ed114:	83 fe 04             	cmp    $0x4,%esi
 18ed117:	73 32                	jae    18ed14b <tier0_tables_open+0x5ddb>
 18ed119:	b0 01                	mov    $0x1,%al
 18ed11b:	31 ff                	xor    %edi,%edi
 18ed11d:	e9 8b 01 00 00       	jmp    18ed2ad <tier0_tables_open+0x5f3d>
 18ed122:	48 8d 3d 74 92 e1 fe 	lea    -0x11e6d8c(%rip),%rdi        # 70639d <pp_string_value.meaning+0x72de5>
 18ed129:	48 8d 35 e4 0b dd fe 	lea    -0x122f41c(%rip),%rsi        # 6bdd14 <pp_string_value.meaning+0x2a75c>
 18ed130:	48 8d 0d f8 0b dd fe 	lea    -0x122f408(%rip),%rcx        # 6bdd2f <pp_string_value.meaning+0x2a777>
 18ed137:	ba bf 00 00 00       	mov    $0xbf,%edx
 18ed13c:	c5 f8 77             	vzeroupper
 18ed13f:	e8 5c c5 ea fe       	call   7996a0 <__assert_fail@plt>
 18ed144:	b0 01                	mov    $0x1,%al
 18ed146:	e9 56 b7 ff ff       	jmp    18e88a1 <tier0_tables_open+0x1531>
 18ed14b:	48 8b 04 24          	mov    (%rsp),%rax
 18ed14f:	83 e6 fc             	and    $0xfffffffc,%esi
 18ed152:	31 ff                	xor    %edi,%edi
 18ed154:	4c 8d 80 28 04 00 00 	lea    0x428(%rax),%r8
 18ed15b:	b0 01                	mov    $0x1,%al
 18ed15d:	45 8b 88 a0 fe ff ff 	mov    -0x160(%r8),%r9d
 18ed164:	45 89 ca             	mov    %r9d,%r10d
 18ed167:	41 83 e2 f8          	and    $0xfffffff8,%r10d
 18ed16b:	4e 8b 14 11          	mov    (%rcx,%r10,1),%r10
 18ed16f:	4d 89 90 a4 fe ff ff 	mov    %r10,-0x15c(%r8)
 18ed176:	3c 01                	cmp    $0x1,%al
 18ed178:	75 19                	jne    18ed193 <tier0_tables_open+0x5e23>
 18ed17a:	48 8b 04 24          	mov    (%rsp),%rax
 18ed17e:	41 c1 e9 03          	shr    $0x3,%r9d
 18ed182:	48 8b 80 88 01 00 00 	mov    0x188(%rax),%rax
 18ed189:	46 8b 0c 88          	mov    (%rax,%r9,4),%r9d
 18ed18d:	66 45 85 c9          	test   %r9w,%r9w
 18ed191:	78 49                	js     18ed1dc <tier0_tables_open+0x5e6c>
 18ed193:	41 8b 80 14 ff ff ff 	mov    -0xec(%r8),%eax
 18ed19a:	83 e0 f8             	and    $0xfffffff8,%eax
 18ed19d:	48 8b 04 01          	mov    (%rcx,%rax,1),%rax
 18ed1a1:	49 89 80 18 ff ff ff 	mov    %rax,-0xe8(%r8)
 18ed1a8:	41 8b 40 88          	mov    -0x78(%r8),%eax
 18ed1ac:	83 e0 f8             	and    $0xfffffff8,%eax
 18ed1af:	48 8b 04 01          	mov    (%rcx,%rax,1),%rax
 18ed1b3:	49 89 40 8c          	mov    %rax,-0x74(%r8)
 18ed1b7:	41 8b 40 fc          	mov    -0x4(%r8),%eax
 18ed1bb:	83 e0 f8             	and    $0xfffffff8,%eax
 18ed1be:	48 8b 04 01          	mov    (%rcx,%rax,1),%rax
 18ed1c2:	49 89 00             	mov    %rax,(%r8)
 18ed1c5:	31 c0                	xor    %eax,%eax
 18ed1c7:	48 83 c7 04          	add    $0x4,%rdi
 18ed1cb:	49 81 c0 d0 01 00 00 	add    $0x1d0,%r8
 18ed1d2:	48 39 fe             	cmp    %rdi,%rsi
 18ed1d5:	75 86                	jne    18ed15d <tier0_tables_open+0x5ded>
 18ed1d7:	e9 c8 00 00 00       	jmp    18ed2a4 <tier0_tables_open+0x5f34>
 18ed1dc:	41 8b 80 14 ff ff ff 	mov    -0xec(%r8),%eax
 18ed1e3:	41 89 c2             	mov    %eax,%r10d
 18ed1e6:	41 83 e2 f8          	and    $0xfffffff8,%r10d
 18ed1ea:	4e 8b 14 11          	mov    (%rcx,%r10,1),%r10
 18ed1ee:	4d 89 90 18 ff ff ff 	mov    %r10,-0xe8(%r8)
 18ed1f5:	41 f7 c1 00 40 00 00 	test   $0x4000,%r9d
 18ed1fc:	75 aa                	jne    18ed1a8 <tier0_tables_open+0x5e38>
 18ed1fe:	4c 8b 0c 24          	mov    (%rsp),%r9
 18ed202:	c1 e8 03             	shr    $0x3,%eax
 18ed205:	4d 8b 89 88 01 00 00 	mov    0x188(%r9),%r9
 18ed20c:	45 8b 0c 81          	mov    (%r9,%rax,4),%r9d
 18ed210:	66 45 85 c9          	test   %r9w,%r9w
 18ed214:	79 92                	jns    18ed1a8 <tier0_tables_open+0x5e38>
 18ed216:	41 8b 40 88          	mov    -0x78(%r8),%eax
 18ed21a:	41 89 c2             	mov    %eax,%r10d
 18ed21d:	41 83 e2 f8          	and    $0xfffffff8,%r10d
 18ed221:	4e 8b 14 11          	mov    (%rcx,%r10,1),%r10
 18ed225:	4d 89 50 8c          	mov    %r10,-0x74(%r8)
 18ed229:	41 f7 c1 00 40 00 00 	test   $0x4000,%r9d
 18ed230:	75 85                	jne    18ed1b7 <tier0_tables_open+0x5e47>
 18ed232:	4c 8b 0c 24          	mov    (%rsp),%r9
 18ed236:	c1 e8 03             	shr    $0x3,%eax
 18ed239:	4d 8b 89 88 01 00 00 	mov    0x188(%r9),%r9
 18ed240:	45 8b 0c 81          	mov    (%r9,%rax,4),%r9d
 18ed244:	66 45 85 c9          	test   %r9w,%r9w
 18ed248:	0f 89 69 ff ff ff    	jns    18ed1b7 <tier0_tables_open+0x5e47>
 18ed24e:	41 8b 40 fc          	mov    -0x4(%r8),%eax
 18ed252:	41 89 c2             	mov    %eax,%r10d
 18ed255:	41 83 e2 f8          	and    $0xfffffff8,%r10d
 18ed259:	4e 8b 14 11          	mov    (%rcx,%r10,1),%r10
 18ed25d:	4d 89 10             	mov    %r10,(%r8)
 18ed260:	41 f7 c1 00 40 00 00 	test   $0x4000,%r9d
 18ed267:	0f 85 58 ff ff ff    	jne    18ed1c5 <tier0_tables_open+0x5e55>
 18ed26d:	4c 8b 0c 24          	mov    (%rsp),%r9
 18ed271:	c1 e8 03             	shr    $0x3,%eax
 18ed274:	4d 8b 89 88 01 00 00 	mov    0x188(%r9),%r9
 18ed27b:	41 8b 04 81          	mov    (%r9,%rax,4),%eax
 18ed27f:	66 85 c0             	test   %ax,%ax
 18ed282:	0f 89 3d ff ff ff    	jns    18ed1c5 <tier0_tables_open+0x5e55>
 18ed288:	a9 00 40 00 00       	test   $0x4000,%eax
 18ed28d:	0f 94 c0             	sete   %al
 18ed290:	48 83 c7 04          	add    $0x4,%rdi
 18ed294:	49 81 c0 d0 01 00 00 	add    $0x1d0,%r8
 18ed29b:	48 39 fe             	cmp    %rdi,%rsi
 18ed29e:	0f 85 b9 fe ff ff    	jne    18ed15d <tier0_tables_open+0x5ded>
 18ed2a4:	48 85 d2             	test   %rdx,%rdx
 18ed2a7:	0f 84 f4 b5 ff ff    	je     18e88a1 <tier0_tables_open+0x1531>
 18ed2ad:	48 6b f7 74          	imul   $0x74,%rdi,%rsi
 18ed2b1:	48 8b 3c 24          	mov    (%rsp),%rdi
 18ed2b5:	48 6b d2 74          	imul   $0x74,%rdx,%rdx
 18ed2b9:	48 8d b4 3e cc 02 00 00 	lea    0x2cc(%rsi,%rdi,1),%rsi
 18ed2c1:	31 ff                	xor    %edi,%edi
 18ed2c3:	eb 0f                	jmp    18ed2d4 <tier0_tables_open+0x5f64>
 18ed2c5:	31 c0                	xor    %eax,%eax
 18ed2c7:	48 83 c7 74          	add    $0x74,%rdi
 18ed2cb:	48 39 fa             	cmp    %rdi,%rdx
 18ed2ce:	0f 84 cd b5 ff ff    	je     18e88a1 <tier0_tables_open+0x1531>
 18ed2d4:	44 8b 44 3e fc       	mov    -0x4(%rsi,%rdi,1),%r8d
 18ed2d9:	45 89 c1             	mov    %r8d,%r9d
 18ed2dc:	41 83 e1 f8          	and    $0xfffffff8,%r9d
 18ed2e0:	4e 8b 0c 09          	mov    (%rcx,%r9,1),%r9
 18ed2e4:	4c 89 0c 3e          	mov    %r9,(%rsi,%rdi,1)
 18ed2e8:	3c 01                	cmp    $0x1,%al
 18ed2ea:	75 d9                	jne    18ed2c5 <tier0_tables_open+0x5f55>
 18ed2ec:	48 8b 04 24          	mov    (%rsp),%rax
 18ed2f0:	41 c1 e8 03          	shr    $0x3,%r8d
 18ed2f4:	48 8b 80 88 01 00 00 	mov    0x188(%rax),%rax
 18ed2fb:	42 8b 04 80          	mov    (%rax,%r8,4),%eax
 18ed2ff:	66 85 c0             	test   %ax,%ax
 18ed302:	79 c1                	jns    18ed2c5 <tier0_tables_open+0x5f55>
 18ed304:	a9 00 40 00 00       	test   $0x4000,%eax
 18ed309:	0f 94 c0             	sete   %al
 18ed30c:	48 83 c7 74          	add    $0x74,%rdi
 18ed310:	48 39 fa             	cmp    %rdi,%rdx
 18ed313:	75 bf                	jne    18ed2d4 <tier0_tables_open+0x5f64>
 18ed315:	e9 87 b5 ff ff       	jmp    18e88a1 <tier0_tables_open+0x1531>
