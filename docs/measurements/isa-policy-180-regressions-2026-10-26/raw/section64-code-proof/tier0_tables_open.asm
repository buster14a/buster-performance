
/home/david/buster-fast-bench/codex-180-fix-20261027-section64/build/compiler:     file format elf64-x86-64


Disassembly of section .text:

00000000018b74d0 <tier0_tables_open>:
 18b74d0:	55                   	push   %rbp
 18b74d1:	41 57                	push   %r15
 18b74d3:	41 56                	push   %r14
 18b74d5:	41 55                	push   %r13
 18b74d7:	41 54                	push   %r12
 18b74d9:	53                   	push   %rbx
 18b74da:	48 81 ec c8 02 00 00 	sub    $0x2c8,%rsp
 18b74e1:	64 48 8b 04 25 28 00 00 00 	mov    %fs:0x28,%rax
 18b74ea:	be 00 a0 00 00       	mov    $0xa000,%esi
 18b74ef:	ba 03 00 00 00       	mov    $0x3,%edx
 18b74f4:	b9 22 40 00 00       	mov    $0x4022,%ecx
 18b74f9:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
 18b74ff:	48 89 fb             	mov    %rdi,%rbx
 18b7502:	45 31 f6             	xor    %r14d,%r14d
 18b7505:	31 ff                	xor    %edi,%edi
 18b7507:	45 31 c9             	xor    %r9d,%r9d
 18b750a:	48 89 84 24 c0 02 00 00 	mov    %rax,0x2c0(%rsp)
 18b7512:	e8 29 d0 ea fe       	call   764540 <mmap@plt>
 18b7517:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
 18b751b:	74 1c                	je     18b7539 <tier0_tables_open+0x69>
 18b751d:	be 00 a0 00 00       	mov    $0xa000,%esi
 18b7522:	ba 0f 00 00 00       	mov    $0xf,%edx
 18b7527:	48 89 c7             	mov    %rax,%rdi
 18b752a:	49 89 c6             	mov    %rax,%r14
 18b752d:	e8 be cf ea fe       	call   7644f0 <madvise@plt>
 18b7532:	b8 99 9e 00 00       	mov    $0x9e99,%eax
 18b7537:	eb 02                	jmp    18b753b <tier0_tables_open+0x6b>
 18b7539:	31 c0                	xor    %eax,%eax
 18b753b:	be 00 90 00 00       	mov    $0x9000,%esi
 18b7540:	ba 03 00 00 00       	mov    $0x3,%edx
 18b7545:	b9 22 40 00 00       	mov    $0x4022,%ecx
 18b754a:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
 18b7550:	4c 89 b3 20 01 00 00 	mov    %r14,0x120(%rbx)
 18b7557:	48 c7 83 28 01 00 00 00 00 00 00 	movq   $0x0,0x128(%rbx)
 18b7562:	48 89 83 30 01 00 00 	mov    %rax,0x130(%rbx)
 18b7569:	48 c7 83 38 01 00 00 00 00 00 00 	movq   $0x0,0x138(%rbx)
 18b7574:	45 31 ff             	xor    %r15d,%r15d
 18b7577:	31 ff                	xor    %edi,%edi
 18b7579:	45 31 c9             	xor    %r9d,%r9d
 18b757c:	e8 bf cf ea fe       	call   764540 <mmap@plt>
 18b7581:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
 18b7585:	74 1d                	je     18b75a4 <tier0_tables_open+0xd4>
 18b7587:	be 00 90 00 00       	mov    $0x9000,%esi
 18b758c:	ba 0f 00 00 00       	mov    $0xf,%edx
 18b7591:	48 89 c7             	mov    %rax,%rdi
 18b7594:	49 89 c6             	mov    %rax,%r14
 18b7597:	e8 54 cf ea fe       	call   7644f0 <madvise@plt>
 18b759c:	41 bf 40 80 00 00    	mov    $0x8040,%r15d
 18b75a2:	eb 03                	jmp    18b75a7 <tier0_tables_open+0xd7>
 18b75a4:	45 31 f6             	xor    %r14d,%r14d
 18b75a7:	4c 89 b3 40 01 00 00 	mov    %r14,0x140(%rbx)
 18b75ae:	48 c7 83 48 01 00 00 00 00 00 00 	movq   $0x0,0x148(%rbx)
 18b75b9:	4c 89 bb 50 01 00 00 	mov    %r15,0x150(%rbx)
 18b75c0:	48 c7 83 58 01 00 00 00 00 00 00 	movq   $0x0,0x158(%rbx)
 18b75cb:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 18b75cf:	48 8b 83 28 01 00 00 	mov    0x128(%rbx),%rax
 18b75d6:	c5 fa 7f 84 24 bc 01 00 00 	vmovdqu %xmm0,0x1bc(%rsp)
 18b75df:	c5 f9 7f 84 24 b0 01 00 00 	vmovdqa %xmm0,0x1b0(%rsp)
 18b75e8:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18b75ef:	4c 8d 74 10 3f       	lea    0x3f(%rax,%rdx,1),%r14
 18b75f4:	48 8d 0c 10          	lea    (%rax,%rdx,1),%rcx
 18b75f8:	49 83 e6 c0          	and    $0xffffffffffffffc0,%r14
 18b75fc:	49 39 ce             	cmp    %rcx,%r14
 18b75ff:	0f 82 6c 10 00 00    	jb     18b8671 <tier0_tables_open+0x11a1>
 18b7605:	4c 89 f1             	mov    %r14,%rcx
 18b7608:	48 29 d1             	sub    %rdx,%rcx
 18b760b:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18b7612:	48 29 ca             	sub    %rcx,%rdx
 18b7615:	40 0f 92 c6          	setb   %sil
 18b7619:	48 81 fa 40 02 00 00 	cmp    $0x240,%rdx
 18b7620:	0f 92 c2             	setb   %dl
 18b7623:	40 08 f2             	or     %sil,%dl
 18b7626:	0f 85 45 10 00 00    	jne    18b8671 <tier0_tables_open+0x11a1>
 18b762c:	48 81 c1 40 02 00 00 	add    $0x240,%rcx
 18b7633:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18b763a:	4d 85 f6             	test   %r14,%r14
 18b763d:	0f 84 2e 10 00 00    	je     18b8671 <tier0_tables_open+0x11a1>
 18b7643:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 18b7647:	62 d1 fd 48 7f 06    	vmovdqa64 %zmm0,(%r14)
 18b764d:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18b7654:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18b765b:	4c 8d 4c 11 3f       	lea    0x3f(%rcx,%rdx,1),%r9
 18b7660:	48 01 d1             	add    %rdx,%rcx
 18b7663:	49 83 e1 c0          	and    $0xffffffffffffffc0,%r9
 18b7667:	49 39 c9             	cmp    %rcx,%r9
 18b766a:	0f 82 01 10 00 00    	jb     18b8671 <tier0_tables_open+0x11a1>
 18b7670:	4c 89 c9             	mov    %r9,%rcx
 18b7673:	48 29 d1             	sub    %rdx,%rcx
 18b7676:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18b767d:	48 29 ca             	sub    %rcx,%rdx
 18b7680:	40 0f 92 c6          	setb   %sil
 18b7684:	48 81 fa 40 02 00 00 	cmp    $0x240,%rdx
 18b768b:	0f 92 c2             	setb   %dl
 18b768e:	40 08 f2             	or     %sil,%dl
 18b7691:	0f 85 da 0f 00 00    	jne    18b8671 <tier0_tables_open+0x11a1>
 18b7697:	48 81 c1 40 02 00 00 	add    $0x240,%rcx
 18b769e:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18b76a5:	4d 85 c9             	test   %r9,%r9
 18b76a8:	0f 84 c3 0f 00 00    	je     18b8671 <tier0_tables_open+0x11a1>
 18b76ae:	62 d1 fd 48 7f 01    	vmovdqa64 %zmm0,(%r9)
 18b76b4:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18b76bb:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18b76c2:	4c 8d 54 11 3f       	lea    0x3f(%rcx,%rdx,1),%r10
 18b76c7:	48 01 d1             	add    %rdx,%rcx
 18b76ca:	49 83 e2 c0          	and    $0xffffffffffffffc0,%r10
 18b76ce:	49 39 ca             	cmp    %rcx,%r10
 18b76d1:	0f 82 9a 0f 00 00    	jb     18b8671 <tier0_tables_open+0x11a1>
 18b76d7:	4c 89 d1             	mov    %r10,%rcx
 18b76da:	48 29 d1             	sub    %rdx,%rcx
 18b76dd:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18b76e4:	48 29 ca             	sub    %rcx,%rdx
 18b76e7:	40 0f 92 c6          	setb   %sil
 18b76eb:	48 81 fa 40 02 00 00 	cmp    $0x240,%rdx
 18b76f2:	0f 92 c2             	setb   %dl
 18b76f5:	40 08 f2             	or     %sil,%dl
 18b76f8:	0f 85 73 0f 00 00    	jne    18b8671 <tier0_tables_open+0x11a1>
 18b76fe:	48 81 c1 40 02 00 00 	add    $0x240,%rcx
 18b7705:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18b770c:	4d 85 d2             	test   %r10,%r10
 18b770f:	0f 84 5c 0f 00 00    	je     18b8671 <tier0_tables_open+0x11a1>
 18b7715:	62 d1 fd 48 7f 02    	vmovdqa64 %zmm0,(%r10)
 18b771b:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18b7722:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18b7729:	4c 8d 5c 11 3f       	lea    0x3f(%rcx,%rdx,1),%r11
 18b772e:	48 01 d1             	add    %rdx,%rcx
 18b7731:	49 83 e3 c0          	and    $0xffffffffffffffc0,%r11
 18b7735:	49 39 cb             	cmp    %rcx,%r11
 18b7738:	0f 82 33 0f 00 00    	jb     18b8671 <tier0_tables_open+0x11a1>
 18b773e:	4c 89 d9             	mov    %r11,%rcx
 18b7741:	48 29 d1             	sub    %rdx,%rcx
 18b7744:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18b774b:	48 29 ca             	sub    %rcx,%rdx
 18b774e:	40 0f 92 c6          	setb   %sil
 18b7752:	48 81 fa 40 02 00 00 	cmp    $0x240,%rdx
 18b7759:	0f 92 c2             	setb   %dl
 18b775c:	40 08 f2             	or     %sil,%dl
 18b775f:	0f 85 0c 0f 00 00    	jne    18b8671 <tier0_tables_open+0x11a1>
 18b7765:	48 81 c1 40 02 00 00 	add    $0x240,%rcx
 18b776c:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18b7773:	4d 85 db             	test   %r11,%r11
 18b7776:	0f 84 f5 0e 00 00    	je     18b8671 <tier0_tables_open+0x11a1>
 18b777c:	62 d1 fd 48 7f 03    	vmovdqa64 %zmm0,(%r11)
 18b7782:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18b7789:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18b7790:	4c 8d 7c 11 3f       	lea    0x3f(%rcx,%rdx,1),%r15
 18b7795:	48 01 d1             	add    %rdx,%rcx
 18b7798:	49 83 e7 c0          	and    $0xffffffffffffffc0,%r15
 18b779c:	49 39 cf             	cmp    %rcx,%r15
 18b779f:	0f 82 cc 0e 00 00    	jb     18b8671 <tier0_tables_open+0x11a1>
 18b77a5:	4c 89 f9             	mov    %r15,%rcx
 18b77a8:	48 29 d1             	sub    %rdx,%rcx
 18b77ab:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18b77b2:	48 29 ca             	sub    %rcx,%rdx
 18b77b5:	40 0f 92 c6          	setb   %sil
 18b77b9:	48 81 fa 00 09 00 00 	cmp    $0x900,%rdx
 18b77c0:	0f 92 c2             	setb   %dl
 18b77c3:	40 08 f2             	or     %sil,%dl
 18b77c6:	0f 85 a5 0e 00 00    	jne    18b8671 <tier0_tables_open+0x11a1>
 18b77cc:	48 81 c1 00 09 00 00 	add    $0x900,%rcx
 18b77d3:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18b77da:	4d 85 ff             	test   %r15,%r15
 18b77dd:	0f 84 8e 0e 00 00    	je     18b8671 <tier0_tables_open+0x11a1>
 18b77e3:	62 d1 fd 48 7f 47 03 	vmovdqa64 %zmm0,0xc0(%r15)
 18b77ea:	62 d1 fd 48 7f 47 02 	vmovdqa64 %zmm0,0x80(%r15)
 18b77f1:	62 d1 fd 48 7f 47 01 	vmovdqa64 %zmm0,0x40(%r15)
 18b77f8:	62 d1 fd 48 7f 07    	vmovdqa64 %zmm0,(%r15)
 18b77fe:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18b7805:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18b780c:	4c 8d 6c 11 3f       	lea    0x3f(%rcx,%rdx,1),%r13
 18b7811:	48 01 d1             	add    %rdx,%rcx
 18b7814:	49 83 e5 c0          	and    $0xffffffffffffffc0,%r13
 18b7818:	49 39 cd             	cmp    %rcx,%r13
 18b781b:	0f 82 50 0e 00 00    	jb     18b8671 <tier0_tables_open+0x11a1>
 18b7821:	4c 89 e9             	mov    %r13,%rcx
 18b7824:	48 29 d1             	sub    %rdx,%rcx
 18b7827:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18b782e:	48 29 ca             	sub    %rcx,%rdx
 18b7831:	40 0f 92 c6          	setb   %sil
 18b7835:	48 81 fa 00 09 00 00 	cmp    $0x900,%rdx
 18b783c:	0f 92 c2             	setb   %dl
 18b783f:	40 08 f2             	or     %sil,%dl
 18b7842:	0f 85 29 0e 00 00    	jne    18b8671 <tier0_tables_open+0x11a1>
 18b7848:	48 81 c1 00 09 00 00 	add    $0x900,%rcx
 18b784f:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18b7856:	4d 85 ed             	test   %r13,%r13
 18b7859:	0f 84 12 0e 00 00    	je     18b8671 <tier0_tables_open+0x11a1>
 18b785f:	62 d1 fd 48 7f 45 03 	vmovdqa64 %zmm0,0xc0(%r13)
 18b7866:	62 d1 fd 48 7f 45 02 	vmovdqa64 %zmm0,0x80(%r13)
 18b786d:	62 d1 fd 48 7f 45 01 	vmovdqa64 %zmm0,0x40(%r13)
 18b7874:	62 d1 fd 48 7f 45 00 	vmovdqa64 %zmm0,0x0(%r13)
 18b787b:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18b7882:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18b7889:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 18b788e:	48 01 d1             	add    %rdx,%rcx
 18b7891:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 18b7895:	48 89 74 24 10       	mov    %rsi,0x10(%rsp)
 18b789a:	48 39 ce             	cmp    %rcx,%rsi
 18b789d:	0f 82 ce 0d 00 00    	jb     18b8671 <tier0_tables_open+0x11a1>
 18b78a3:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
 18b78a8:	48 29 d1             	sub    %rdx,%rcx
 18b78ab:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18b78b2:	48 29 ca             	sub    %rcx,%rdx
 18b78b5:	40 0f 92 c6          	setb   %sil
 18b78b9:	48 81 fa 00 12 00 00 	cmp    $0x1200,%rdx
 18b78c0:	0f 92 c2             	setb   %dl
 18b78c3:	40 08 f2             	or     %sil,%dl
 18b78c6:	0f 85 a5 0d 00 00    	jne    18b8671 <tier0_tables_open+0x11a1>
 18b78cc:	48 81 c1 00 12 00 00 	add    $0x1200,%rcx
 18b78d3:	48 83 7c 24 10 00    	cmpq   $0x0,0x10(%rsp)
 18b78d9:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18b78e0:	0f 84 8b 0d 00 00    	je     18b8671 <tier0_tables_open+0x11a1>
 18b78e6:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
 18b78eb:	62 f1 fd 48 7f 41 07 	vmovdqa64 %zmm0,0x1c0(%rcx)
 18b78f2:	62 f1 fd 48 7f 41 06 	vmovdqa64 %zmm0,0x180(%rcx)
 18b78f9:	62 f1 fd 48 7f 41 05 	vmovdqa64 %zmm0,0x140(%rcx)
 18b7900:	62 f1 fd 48 7f 41 04 	vmovdqa64 %zmm0,0x100(%rcx)
 18b7907:	62 f1 fd 48 7f 41 03 	vmovdqa64 %zmm0,0xc0(%rcx)
 18b790e:	62 f1 fd 48 7f 41 02 	vmovdqa64 %zmm0,0x80(%rcx)
 18b7915:	62 f1 fd 48 7f 41 01 	vmovdqa64 %zmm0,0x40(%rcx)
 18b791c:	62 f1 fd 48 7f 01    	vmovdqa64 %zmm0,(%rcx)
 18b7922:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18b7929:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18b7930:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 18b7935:	48 01 d1             	add    %rdx,%rcx
 18b7938:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 18b793c:	48 89 74 24 08       	mov    %rsi,0x8(%rsp)
 18b7941:	48 39 ce             	cmp    %rcx,%rsi
 18b7944:	0f 82 27 0d 00 00    	jb     18b8671 <tier0_tables_open+0x11a1>
 18b794a:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
 18b794f:	48 29 d1             	sub    %rdx,%rcx
 18b7952:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18b7959:	48 29 ca             	sub    %rcx,%rdx
 18b795c:	40 0f 92 c6          	setb   %sil
 18b7960:	48 81 fa 00 12 00 00 	cmp    $0x1200,%rdx
 18b7967:	0f 92 c2             	setb   %dl
 18b796a:	40 08 f2             	or     %sil,%dl
 18b796d:	0f 85 fe 0c 00 00    	jne    18b8671 <tier0_tables_open+0x11a1>
 18b7973:	48 81 c1 00 12 00 00 	add    $0x1200,%rcx
 18b797a:	48 83 7c 24 08 00    	cmpq   $0x0,0x8(%rsp)
 18b7980:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18b7987:	0f 84 e4 0c 00 00    	je     18b8671 <tier0_tables_open+0x11a1>
 18b798d:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
 18b7992:	62 f1 fd 48 7f 41 07 	vmovdqa64 %zmm0,0x1c0(%rcx)
 18b7999:	62 f1 fd 48 7f 41 06 	vmovdqa64 %zmm0,0x180(%rcx)
 18b79a0:	62 f1 fd 48 7f 41 05 	vmovdqa64 %zmm0,0x140(%rcx)
 18b79a7:	62 f1 fd 48 7f 41 04 	vmovdqa64 %zmm0,0x100(%rcx)
 18b79ae:	62 f1 fd 48 7f 41 03 	vmovdqa64 %zmm0,0xc0(%rcx)
 18b79b5:	62 f1 fd 48 7f 41 02 	vmovdqa64 %zmm0,0x80(%rcx)
 18b79bc:	62 f1 fd 48 7f 41 01 	vmovdqa64 %zmm0,0x40(%rcx)
 18b79c3:	62 f1 fd 48 7f 01    	vmovdqa64 %zmm0,(%rcx)
 18b79c9:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18b79d0:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18b79d7:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 18b79dc:	48 01 d1             	add    %rdx,%rcx
 18b79df:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 18b79e3:	48 89 b4 24 80 00 00 00 	mov    %rsi,0x80(%rsp)
 18b79eb:	48 39 ce             	cmp    %rcx,%rsi
 18b79ee:	0f 82 7d 0c 00 00    	jb     18b8671 <tier0_tables_open+0x11a1>
 18b79f4:	48 8b 8c 24 80 00 00 00 	mov    0x80(%rsp),%rcx
 18b79fc:	48 29 d1             	sub    %rdx,%rcx
 18b79ff:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18b7a06:	48 29 ca             	sub    %rcx,%rdx
 18b7a09:	40 0f 92 c6          	setb   %sil
 18b7a0d:	48 81 fa 00 12 00 00 	cmp    $0x1200,%rdx
 18b7a14:	0f 92 c2             	setb   %dl
 18b7a17:	40 08 f2             	or     %sil,%dl
 18b7a1a:	0f 85 51 0c 00 00    	jne    18b8671 <tier0_tables_open+0x11a1>
 18b7a20:	48 81 c1 00 12 00 00 	add    $0x1200,%rcx
 18b7a27:	48 83 bc 24 80 00 00 00 00 	cmpq   $0x0,0x80(%rsp)
 18b7a30:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18b7a37:	0f 84 34 0c 00 00    	je     18b8671 <tier0_tables_open+0x11a1>
 18b7a3d:	48 8b 8c 24 80 00 00 00 	mov    0x80(%rsp),%rcx
 18b7a45:	62 f1 fd 48 7f 41 07 	vmovdqa64 %zmm0,0x1c0(%rcx)
 18b7a4c:	62 f1 fd 48 7f 41 06 	vmovdqa64 %zmm0,0x180(%rcx)
 18b7a53:	62 f1 fd 48 7f 41 05 	vmovdqa64 %zmm0,0x140(%rcx)
 18b7a5a:	62 f1 fd 48 7f 41 04 	vmovdqa64 %zmm0,0x100(%rcx)
 18b7a61:	62 f1 fd 48 7f 41 03 	vmovdqa64 %zmm0,0xc0(%rcx)
 18b7a68:	62 f1 fd 48 7f 41 02 	vmovdqa64 %zmm0,0x80(%rcx)
 18b7a6f:	62 f1 fd 48 7f 41 01 	vmovdqa64 %zmm0,0x40(%rcx)
 18b7a76:	62 f1 fd 48 7f 01    	vmovdqa64 %zmm0,(%rcx)
 18b7a7c:	48 8b 8b 20 01 00 00 	mov    0x120(%rbx),%rcx
 18b7a83:	48 8b b3 28 01 00 00 	mov    0x128(%rbx),%rsi
 18b7a8a:	48 8d 54 0e 3f       	lea    0x3f(%rsi,%rcx,1),%rdx
 18b7a8f:	48 01 ce             	add    %rcx,%rsi
 18b7a92:	48 83 e2 c0          	and    $0xffffffffffffffc0,%rdx
 18b7a96:	48 89 54 24 40       	mov    %rdx,0x40(%rsp)
 18b7a9b:	48 39 f2             	cmp    %rsi,%rdx
 18b7a9e:	0f 82 cd 0b 00 00    	jb     18b8671 <tier0_tables_open+0x11a1>
 18b7aa4:	49 89 f4             	mov    %rsi,%r12
 18b7aa7:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
 18b7aac:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18b7ab3:	48 29 ce             	sub    %rcx,%rsi
 18b7ab6:	48 89 d7             	mov    %rdx,%rdi
 18b7ab9:	48 29 f7             	sub    %rsi,%rdi
 18b7abc:	41 0f 92 c0          	setb   %r8b
 18b7ac0:	48 81 ff 04 10 00 00 	cmp    $0x1004,%rdi
 18b7ac7:	40 0f 92 c7          	setb   %dil
 18b7acb:	44 08 c7             	or     %r8b,%dil
 18b7ace:	0f 85 9d 0b 00 00    	jne    18b8671 <tier0_tables_open+0x11a1>
 18b7ad4:	48 81 c6 04 10 00 00 	add    $0x1004,%rsi
 18b7adb:	48 83 7c 24 40 00    	cmpq   $0x0,0x40(%rsp)
 18b7ae1:	48 89 b3 28 01 00 00 	mov    %rsi,0x128(%rbx)
 18b7ae8:	0f 84 83 0b 00 00    	je     18b8671 <tier0_tables_open+0x11a1>
 18b7aee:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
 18b7af3:	49 81 c4 7f 10 00 00 	add    $0x107f,%r12
 18b7afa:	49 83 e4 c0          	and    $0xffffffffffffffc0,%r12
 18b7afe:	4c 89 64 24 60       	mov    %r12,0x60(%rsp)
 18b7b03:	48 81 c6 04 10 00 00 	add    $0x1004,%rsi
 18b7b0a:	49 39 f4             	cmp    %rsi,%r12
 18b7b0d:	0f 82 5e 0b 00 00    	jb     18b8671 <tier0_tables_open+0x11a1>
 18b7b13:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
 18b7b18:	48 29 ce             	sub    %rcx,%rsi
 18b7b1b:	48 29 f2             	sub    %rsi,%rdx
 18b7b1e:	0f 92 c1             	setb   %cl
 18b7b21:	48 81 fa 04 02 00 00 	cmp    $0x204,%rdx
 18b7b28:	0f 92 c2             	setb   %dl
 18b7b2b:	08 ca                	or     %cl,%dl
 18b7b2d:	0f 85 3e 0b 00 00    	jne    18b8671 <tier0_tables_open+0x11a1>
 18b7b33:	48 81 c6 04 02 00 00 	add    $0x204,%rsi
 18b7b3a:	48 83 7c 24 60 00    	cmpq   $0x0,0x60(%rsp)
 18b7b40:	48 89 b3 28 01 00 00 	mov    %rsi,0x128(%rbx)
 18b7b47:	0f 84 24 0b 00 00    	je     18b8671 <tier0_tables_open+0x11a1>
 18b7b4d:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
 18b7b52:	c7 01 00 00 00 00    	movl   $0x0,(%rcx)
 18b7b58:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18b7b5f:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18b7b66:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 18b7b6b:	48 01 d1             	add    %rdx,%rcx
 18b7b6e:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 18b7b72:	48 89 74 24 58       	mov    %rsi,0x58(%rsp)
 18b7b77:	48 39 ce             	cmp    %rcx,%rsi
 18b7b7a:	0f 82 f1 0a 00 00    	jb     18b8671 <tier0_tables_open+0x11a1>
 18b7b80:	48 8b 4c 24 58       	mov    0x58(%rsp),%rcx
 18b7b85:	48 29 d1             	sub    %rdx,%rcx
 18b7b88:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18b7b8f:	48 29 ca             	sub    %rcx,%rdx
 18b7b92:	40 0f 92 c6          	setb   %sil
 18b7b96:	48 81 fa 04 02 00 00 	cmp    $0x204,%rdx
 18b7b9d:	0f 92 c2             	setb   %dl
 18b7ba0:	40 08 f2             	or     %sil,%dl
 18b7ba3:	0f 85 c8 0a 00 00    	jne    18b8671 <tier0_tables_open+0x11a1>
 18b7ba9:	48 81 c1 04 02 00 00 	add    $0x204,%rcx
 18b7bb0:	48 83 7c 24 58 00    	cmpq   $0x0,0x58(%rsp)
 18b7bb6:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18b7bbd:	0f 84 ae 0a 00 00    	je     18b8671 <tier0_tables_open+0x11a1>
 18b7bc3:	48 8b 4c 24 58       	mov    0x58(%rsp),%rcx
 18b7bc8:	c7 01 00 00 00 00    	movl   $0x0,(%rcx)
 18b7bce:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18b7bd5:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18b7bdc:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 18b7be1:	48 01 d1             	add    %rdx,%rcx
 18b7be4:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 18b7be8:	48 89 b4 24 08 01 00 00 	mov    %rsi,0x108(%rsp)
 18b7bf0:	48 39 ce             	cmp    %rcx,%rsi
 18b7bf3:	0f 82 78 0a 00 00    	jb     18b8671 <tier0_tables_open+0x11a1>
 18b7bf9:	48 8b 8c 24 08 01 00 00 	mov    0x108(%rsp),%rcx
 18b7c01:	48 29 d1             	sub    %rdx,%rcx
 18b7c04:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18b7c0b:	48 29 ca             	sub    %rcx,%rdx
 18b7c0e:	40 0f 92 c6          	setb   %sil
 18b7c12:	48 81 fa 04 02 00 00 	cmp    $0x204,%rdx
 18b7c19:	0f 92 c2             	setb   %dl
 18b7c1c:	40 08 f2             	or     %sil,%dl
 18b7c1f:	0f 85 4c 0a 00 00    	jne    18b8671 <tier0_tables_open+0x11a1>
 18b7c25:	48 81 c1 04 02 00 00 	add    $0x204,%rcx
 18b7c2c:	48 83 bc 24 08 01 00 00 00 	cmpq   $0x0,0x108(%rsp)
 18b7c35:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18b7c3c:	0f 84 2f 0a 00 00    	je     18b8671 <tier0_tables_open+0x11a1>
 18b7c42:	48 8b 8c 24 08 01 00 00 	mov    0x108(%rsp),%rcx
 18b7c4a:	c7 01 00 00 00 00    	movl   $0x0,(%rcx)
 18b7c50:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18b7c57:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18b7c5e:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 18b7c63:	48 01 d1             	add    %rdx,%rcx
 18b7c66:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 18b7c6a:	48 89 74 24 50       	mov    %rsi,0x50(%rsp)
 18b7c6f:	48 39 ce             	cmp    %rcx,%rsi
 18b7c72:	0f 82 f9 09 00 00    	jb     18b8671 <tier0_tables_open+0x11a1>
 18b7c78:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
 18b7c7d:	48 29 d1             	sub    %rdx,%rcx
 18b7c80:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18b7c87:	48 29 ca             	sub    %rcx,%rdx
 18b7c8a:	40 0f 92 c6          	setb   %sil
 18b7c8e:	48 81 fa 04 02 00 00 	cmp    $0x204,%rdx
 18b7c95:	0f 92 c2             	setb   %dl
 18b7c98:	40 08 f2             	or     %sil,%dl
 18b7c9b:	0f 85 d0 09 00 00    	jne    18b8671 <tier0_tables_open+0x11a1>
 18b7ca1:	48 81 c1 04 02 00 00 	add    $0x204,%rcx
 18b7ca8:	48 83 7c 24 50 00    	cmpq   $0x0,0x50(%rsp)
 18b7cae:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18b7cb5:	0f 84 b6 09 00 00    	je     18b8671 <tier0_tables_open+0x11a1>
 18b7cbb:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
 18b7cc0:	c7 01 00 00 00 00    	movl   $0x0,(%rcx)
 18b7cc6:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18b7ccd:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18b7cd4:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 18b7cd9:	48 01 d1             	add    %rdx,%rcx
 18b7cdc:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 18b7ce0:	48 89 b4 24 00 01 00 00 	mov    %rsi,0x100(%rsp)
 18b7ce8:	48 39 ce             	cmp    %rcx,%rsi
 18b7ceb:	0f 82 80 09 00 00    	jb     18b8671 <tier0_tables_open+0x11a1>
 18b7cf1:	48 8b 8c 24 00 01 00 00 	mov    0x100(%rsp),%rcx
 18b7cf9:	48 29 d1             	sub    %rdx,%rcx
 18b7cfc:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18b7d03:	48 29 ca             	sub    %rcx,%rdx
 18b7d06:	40 0f 92 c6          	setb   %sil
 18b7d0a:	48 81 fa 04 02 00 00 	cmp    $0x204,%rdx
 18b7d11:	0f 92 c2             	setb   %dl
 18b7d14:	40 08 f2             	or     %sil,%dl
 18b7d17:	0f 85 54 09 00 00    	jne    18b8671 <tier0_tables_open+0x11a1>
 18b7d1d:	48 81 c1 04 02 00 00 	add    $0x204,%rcx
 18b7d24:	48 83 bc 24 00 01 00 00 00 	cmpq   $0x0,0x100(%rsp)
 18b7d2d:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18b7d34:	0f 84 37 09 00 00    	je     18b8671 <tier0_tables_open+0x11a1>
 18b7d3a:	48 8b 8c 24 00 01 00 00 	mov    0x100(%rsp),%rcx
 18b7d42:	c7 01 00 00 00 00    	movl   $0x0,(%rcx)
 18b7d48:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18b7d4f:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18b7d56:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 18b7d5b:	48 01 d1             	add    %rdx,%rcx
 18b7d5e:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 18b7d62:	48 89 b4 24 a8 00 00 00 	mov    %rsi,0xa8(%rsp)
 18b7d6a:	48 39 ce             	cmp    %rcx,%rsi
 18b7d6d:	0f 82 fe 08 00 00    	jb     18b8671 <tier0_tables_open+0x11a1>
 18b7d73:	48 8b 8c 24 a8 00 00 00 	mov    0xa8(%rsp),%rcx
 18b7d7b:	48 29 d1             	sub    %rdx,%rcx
 18b7d7e:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18b7d85:	48 29 ca             	sub    %rcx,%rdx
 18b7d88:	40 0f 92 c6          	setb   %sil
 18b7d8c:	48 81 fa 81 00 00 00 	cmp    $0x81,%rdx
 18b7d93:	0f 92 c2             	setb   %dl
 18b7d96:	40 08 f2             	or     %sil,%dl
 18b7d99:	0f 85 d2 08 00 00    	jne    18b8671 <tier0_tables_open+0x11a1>
 18b7d9f:	48 81 c1 81 00 00 00 	add    $0x81,%rcx
 18b7da6:	48 83 bc 24 a8 00 00 00 00 	cmpq   $0x0,0xa8(%rsp)
 18b7daf:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18b7db6:	0f 84 b5 08 00 00    	je     18b8671 <tier0_tables_open+0x11a1>
 18b7dbc:	48 8b 8c 24 a8 00 00 00 	mov    0xa8(%rsp),%rcx
 18b7dc4:	c6 01 00             	movb   $0x0,(%rcx)
 18b7dc7:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18b7dce:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18b7dd5:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 18b7dda:	48 01 d1             	add    %rdx,%rcx
 18b7ddd:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 18b7de1:	48 89 74 24 18       	mov    %rsi,0x18(%rsp)
 18b7de6:	48 39 ce             	cmp    %rcx,%rsi
 18b7de9:	0f 82 82 08 00 00    	jb     18b8671 <tier0_tables_open+0x11a1>
 18b7def:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
 18b7df4:	48 29 d1             	sub    %rdx,%rcx
 18b7df7:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18b7dfe:	48 29 ca             	sub    %rcx,%rdx
 18b7e01:	40 0f 92 c6          	setb   %sil
 18b7e05:	48 81 fa 81 00 00 00 	cmp    $0x81,%rdx
 18b7e0c:	0f 92 c2             	setb   %dl
 18b7e0f:	40 08 f2             	or     %sil,%dl
 18b7e12:	0f 85 59 08 00 00    	jne    18b8671 <tier0_tables_open+0x11a1>
 18b7e18:	48 81 c1 81 00 00 00 	add    $0x81,%rcx
 18b7e1f:	48 83 7c 24 18 00    	cmpq   $0x0,0x18(%rsp)
 18b7e25:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18b7e2c:	0f 84 3f 08 00 00    	je     18b8671 <tier0_tables_open+0x11a1>
 18b7e32:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
 18b7e37:	c6 01 00             	movb   $0x0,(%rcx)
 18b7e3a:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18b7e41:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18b7e48:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 18b7e4d:	48 01 d1             	add    %rdx,%rcx
 18b7e50:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 18b7e54:	48 89 b4 24 f8 00 00 00 	mov    %rsi,0xf8(%rsp)
 18b7e5c:	48 39 ce             	cmp    %rcx,%rsi
 18b7e5f:	0f 82 0c 08 00 00    	jb     18b8671 <tier0_tables_open+0x11a1>
 18b7e65:	48 8b 8c 24 f8 00 00 00 	mov    0xf8(%rsp),%rcx
 18b7e6d:	48 29 d1             	sub    %rdx,%rcx
 18b7e70:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18b7e77:	48 29 ca             	sub    %rcx,%rdx
 18b7e7a:	40 0f 92 c6          	setb   %sil
 18b7e7e:	48 81 fa 81 00 00 00 	cmp    $0x81,%rdx
 18b7e85:	0f 92 c2             	setb   %dl
 18b7e88:	40 08 f2             	or     %sil,%dl
 18b7e8b:	0f 85 e0 07 00 00    	jne    18b8671 <tier0_tables_open+0x11a1>
 18b7e91:	48 81 c1 81 00 00 00 	add    $0x81,%rcx
 18b7e98:	48 83 bc 24 f8 00 00 00 00 	cmpq   $0x0,0xf8(%rsp)
 18b7ea1:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18b7ea8:	0f 84 c3 07 00 00    	je     18b8671 <tier0_tables_open+0x11a1>
 18b7eae:	48 8b 8c 24 f8 00 00 00 	mov    0xf8(%rsp),%rcx
 18b7eb6:	c6 01 00             	movb   $0x0,(%rcx)
 18b7eb9:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18b7ec0:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18b7ec7:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 18b7ecc:	48 01 d1             	add    %rdx,%rcx
 18b7ecf:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 18b7ed3:	48 89 b4 24 38 01 00 00 	mov    %rsi,0x138(%rsp)
 18b7edb:	48 39 ce             	cmp    %rcx,%rsi
 18b7ede:	0f 82 8d 07 00 00    	jb     18b8671 <tier0_tables_open+0x11a1>
 18b7ee4:	48 8b 8c 24 38 01 00 00 	mov    0x138(%rsp),%rcx
 18b7eec:	48 29 d1             	sub    %rdx,%rcx
 18b7eef:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18b7ef6:	48 29 ca             	sub    %rcx,%rdx
 18b7ef9:	40 0f 92 c6          	setb   %sil
 18b7efd:	48 81 fa 04 08 00 00 	cmp    $0x804,%rdx
 18b7f04:	0f 92 c2             	setb   %dl
 18b7f07:	40 08 f2             	or     %sil,%dl
 18b7f0a:	0f 85 61 07 00 00    	jne    18b8671 <tier0_tables_open+0x11a1>
 18b7f10:	48 81 c1 04 08 00 00 	add    $0x804,%rcx
 18b7f17:	48 83 bc 24 38 01 00 00 00 	cmpq   $0x0,0x138(%rsp)
 18b7f20:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18b7f27:	0f 84 44 07 00 00    	je     18b8671 <tier0_tables_open+0x11a1>
 18b7f2d:	48 8b 8c 24 38 01 00 00 	mov    0x138(%rsp),%rcx
 18b7f35:	c7 01 00 00 00 00    	movl   $0x0,(%rcx)
 18b7f3b:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18b7f42:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18b7f49:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 18b7f4e:	48 01 d1             	add    %rdx,%rcx
 18b7f51:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 18b7f55:	48 89 b4 24 a0 00 00 00 	mov    %rsi,0xa0(%rsp)
 18b7f5d:	48 39 ce             	cmp    %rcx,%rsi
 18b7f60:	0f 82 0b 07 00 00    	jb     18b8671 <tier0_tables_open+0x11a1>
 18b7f66:	48 8b 8c 24 a0 00 00 00 	mov    0xa0(%rsp),%rcx
 18b7f6e:	48 29 d1             	sub    %rdx,%rcx
 18b7f71:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18b7f78:	48 29 ca             	sub    %rcx,%rdx
 18b7f7b:	40 0f 92 c6          	setb   %sil
 18b7f7f:	48 81 fa 04 08 00 00 	cmp    $0x804,%rdx
 18b7f86:	0f 92 c2             	setb   %dl
 18b7f89:	40 08 f2             	or     %sil,%dl
 18b7f8c:	0f 85 df 06 00 00    	jne    18b8671 <tier0_tables_open+0x11a1>
 18b7f92:	48 81 c1 04 08 00 00 	add    $0x804,%rcx
 18b7f99:	48 83 bc 24 a0 00 00 00 00 	cmpq   $0x0,0xa0(%rsp)
 18b7fa2:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18b7fa9:	0f 84 c2 06 00 00    	je     18b8671 <tier0_tables_open+0x11a1>
 18b7faf:	48 8b 8c 24 a0 00 00 00 	mov    0xa0(%rsp),%rcx
 18b7fb7:	c7 01 00 00 00 00    	movl   $0x0,(%rcx)
 18b7fbd:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18b7fc4:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18b7fcb:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 18b7fd0:	48 01 d1             	add    %rdx,%rcx
 18b7fd3:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 18b7fd7:	48 89 b4 24 30 01 00 00 	mov    %rsi,0x130(%rsp)
 18b7fdf:	48 39 ce             	cmp    %rcx,%rsi
 18b7fe2:	0f 82 89 06 00 00    	jb     18b8671 <tier0_tables_open+0x11a1>
 18b7fe8:	48 8b 8c 24 30 01 00 00 	mov    0x130(%rsp),%rcx
 18b7ff0:	48 29 d1             	sub    %rdx,%rcx
 18b7ff3:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18b7ffa:	48 29 ca             	sub    %rcx,%rdx
 18b7ffd:	40 0f 92 c6          	setb   %sil
 18b8001:	48 81 fa 04 08 00 00 	cmp    $0x804,%rdx
 18b8008:	0f 92 c2             	setb   %dl
 18b800b:	40 08 f2             	or     %sil,%dl
 18b800e:	0f 85 5d 06 00 00    	jne    18b8671 <tier0_tables_open+0x11a1>
 18b8014:	48 81 c1 04 08 00 00 	add    $0x804,%rcx
 18b801b:	48 83 bc 24 30 01 00 00 00 	cmpq   $0x0,0x130(%rsp)
 18b8024:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18b802b:	0f 84 40 06 00 00    	je     18b8671 <tier0_tables_open+0x11a1>
 18b8031:	48 8b 8c 24 30 01 00 00 	mov    0x130(%rsp),%rcx
 18b8039:	c7 01 00 00 00 00    	movl   $0x0,(%rcx)
 18b803f:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18b8046:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18b804d:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 18b8052:	48 01 d1             	add    %rdx,%rcx
 18b8055:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 18b8059:	48 89 74 24 38       	mov    %rsi,0x38(%rsp)
 18b805e:	48 39 ce             	cmp    %rcx,%rsi
 18b8061:	0f 82 0a 06 00 00    	jb     18b8671 <tier0_tables_open+0x11a1>
 18b8067:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
 18b806c:	48 29 d1             	sub    %rdx,%rcx
 18b806f:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18b8076:	48 29 ca             	sub    %rcx,%rdx
 18b8079:	40 0f 92 c6          	setb   %sil
 18b807d:	48 81 fa 01 02 00 00 	cmp    $0x201,%rdx
 18b8084:	0f 92 c2             	setb   %dl
 18b8087:	40 08 f2             	or     %sil,%dl
 18b808a:	0f 85 e1 05 00 00    	jne    18b8671 <tier0_tables_open+0x11a1>
 18b8090:	48 81 c1 01 02 00 00 	add    $0x201,%rcx
 18b8097:	48 83 7c 24 38 00    	cmpq   $0x0,0x38(%rsp)
 18b809d:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18b80a4:	0f 84 c7 05 00 00    	je     18b8671 <tier0_tables_open+0x11a1>
 18b80aa:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
 18b80af:	c6 01 00             	movb   $0x0,(%rcx)
 18b80b2:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18b80b9:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18b80c0:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 18b80c5:	48 01 d1             	add    %rdx,%rcx
 18b80c8:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 18b80cc:	48 89 b4 24 28 01 00 00 	mov    %rsi,0x128(%rsp)
 18b80d4:	48 39 ce             	cmp    %rcx,%rsi
 18b80d7:	0f 82 94 05 00 00    	jb     18b8671 <tier0_tables_open+0x11a1>
 18b80dd:	48 8b 8c 24 28 01 00 00 	mov    0x128(%rsp),%rcx
 18b80e5:	48 29 d1             	sub    %rdx,%rcx
 18b80e8:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18b80ef:	48 29 ca             	sub    %rcx,%rdx
 18b80f2:	40 0f 92 c6          	setb   %sil
 18b80f6:	48 81 fa 01 02 00 00 	cmp    $0x201,%rdx
 18b80fd:	0f 92 c2             	setb   %dl
 18b8100:	40 08 f2             	or     %sil,%dl
 18b8103:	0f 85 68 05 00 00    	jne    18b8671 <tier0_tables_open+0x11a1>
 18b8109:	48 81 c1 01 02 00 00 	add    $0x201,%rcx
 18b8110:	48 83 bc 24 28 01 00 00 00 	cmpq   $0x0,0x128(%rsp)
 18b8119:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18b8120:	0f 84 4b 05 00 00    	je     18b8671 <tier0_tables_open+0x11a1>
 18b8126:	48 8b 8c 24 28 01 00 00 	mov    0x128(%rsp),%rcx
 18b812e:	c6 01 00             	movb   $0x0,(%rcx)
 18b8131:	48 8b 93 20 01 00 00 	mov    0x120(%rbx),%rdx
 18b8138:	48 8b 8b 28 01 00 00 	mov    0x128(%rbx),%rcx
 18b813f:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 18b8144:	48 01 d1             	add    %rdx,%rcx
 18b8147:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 18b814b:	48 89 b4 24 c8 00 00 00 	mov    %rsi,0xc8(%rsp)
 18b8153:	48 39 ce             	cmp    %rcx,%rsi
 18b8156:	0f 82 15 05 00 00    	jb     18b8671 <tier0_tables_open+0x11a1>
 18b815c:	48 8b 8c 24 c8 00 00 00 	mov    0xc8(%rsp),%rcx
 18b8164:	48 29 d1             	sub    %rdx,%rcx
 18b8167:	48 8b 93 30 01 00 00 	mov    0x130(%rbx),%rdx
 18b816e:	48 29 ca             	sub    %rcx,%rdx
 18b8171:	40 0f 92 c6          	setb   %sil
 18b8175:	48 81 fa 08 10 00 00 	cmp    $0x1008,%rdx
 18b817c:	0f 92 c2             	setb   %dl
 18b817f:	40 08 f2             	or     %sil,%dl
 18b8182:	0f 85 e9 04 00 00    	jne    18b8671 <tier0_tables_open+0x11a1>
 18b8188:	48 81 c1 08 10 00 00 	add    $0x1008,%rcx
 18b818f:	48 83 bc 24 c8 00 00 00 00 	cmpq   $0x0,0xc8(%rsp)
 18b8198:	48 89 8b 28 01 00 00 	mov    %rcx,0x128(%rbx)
 18b819f:	0f 84 cc 04 00 00    	je     18b8671 <tier0_tables_open+0x11a1>
 18b81a5:	48 8b 8c 24 c8 00 00 00 	mov    0xc8(%rsp),%rcx
 18b81ad:	48 c7 01 00 00 00 00 	movq   $0x0,(%rcx)
 18b81b4:	48 8b 93 40 01 00 00 	mov    0x140(%rbx),%rdx
 18b81bb:	48 8b 8b 48 01 00 00 	mov    0x148(%rbx),%rcx
 18b81c2:	48 8d 74 11 3f       	lea    0x3f(%rcx,%rdx,1),%rsi
 18b81c7:	48 01 d1             	add    %rdx,%rcx
 18b81ca:	48 83 e6 c0          	and    $0xffffffffffffffc0,%rsi
 18b81ce:	48 89 74 24 70       	mov    %rsi,0x70(%rsp)
 18b81d3:	48 39 ce             	cmp    %rcx,%rsi
 18b81d6:	0f 82 95 04 00 00    	jb     18b8671 <tier0_tables_open+0x11a1>
 18b81dc:	48 8b 4c 24 70       	mov    0x70(%rsp),%rcx
 18b81e1:	48 29 d1             	sub    %rdx,%rcx
 18b81e4:	48 8b 93 50 01 00 00 	mov    0x150(%rbx),%rdx
 18b81eb:	48 29 ca             	sub    %rcx,%rdx
 18b81ee:	40 0f 92 c6          	setb   %sil
 18b81f2:	48 81 fa 00 10 00 00 	cmp    $0x1000,%rdx
 18b81f9:	0f 92 c2             	setb   %dl
 18b81fc:	40 08 f2             	or     %sil,%dl
 18b81ff:	0f 85 6c 04 00 00    	jne    18b8671 <tier0_tables_open+0x11a1>
 18b8205:	48 81 c1 00 10 00 00 	add    $0x1000,%rcx
 18b820c:	48 83 7c 24 70 00    	cmpq   $0x0,0x70(%rsp)
 18b8212:	48 89 8b 48 01 00 00 	mov    %rcx,0x148(%rbx)
 18b8219:	0f 84 52 04 00 00    	je     18b8671 <tier0_tables_open+0x11a1>
 18b821f:	48 8b 7c 24 70       	mov    0x70(%rsp),%rdi
 18b8224:	48 8d 83 40 01 00 00 	lea    0x140(%rbx),%rax
 18b822b:	ba 00 10 00 00       	mov    $0x1000,%edx
 18b8230:	4c 89 ac 24 d8 00 00 00 	mov    %r13,0xd8(%rsp)
 18b8238:	4c 89 7c 24 20       	mov    %r15,0x20(%rsp)
 18b823d:	48 89 1c 24          	mov    %rbx,(%rsp)
 18b8241:	31 f6                	xor    %esi,%esi
 18b8243:	45 31 ff             	xor    %r15d,%r15d
 18b8246:	4d 89 cd             	mov    %r9,%r13
 18b8249:	4d 89 d4             	mov    %r10,%r12
 18b824c:	4c 89 db             	mov    %r11,%rbx
 18b824f:	48 89 84 24 d0 00 00 00 	mov    %rax,0xd0(%rsp)
 18b8257:	c5 f8 77             	vzeroupper
 18b825a:	e8 d1 c0 ea fe       	call   764330 <memset@plt>
 18b825f:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 18b8264:	41 c6 46 01 01       	movb   $0x1,0x1(%r14)
 18b8269:	41 c6 45 01 01       	movb   $0x1,0x1(%r13)
 18b826e:	41 c6 44 24 01 00    	movb   $0x0,0x1(%r12)
 18b8274:	c6 43 01 00          	movb   $0x0,0x1(%rbx)
 18b8278:	4c 89 b4 24 90 00 00 00 	mov    %r14,0x90(%rsp)
 18b8280:	4c 89 ef             	mov    %r13,%rdi
 18b8283:	4d 89 e0             	mov    %r12,%r8
 18b8286:	49 89 d9             	mov    %rbx,%r9
 18b8289:	48 c7 40 08 01 00 00 00 	movq   $0x1,0x8(%rax)
 18b8291:	48 8d 05 e2 77 7e 00 	lea    0x7e77e2(%rip),%rax        # 209fa7a <type_builtins+0x6a>
 18b8298:	41 8d 4f ea          	lea    -0x16(%r15),%ecx
 18b829c:	83 f9 e9             	cmp    $0xffffffe9,%ecx
 18b829f:	73 43                	jae    18b82e4 <tier0_tables_open+0xe14>
 18b82a1:	41 8d 4f eb          	lea    -0x15(%r15),%ecx
 18b82a5:	83 f9 e9             	cmp    $0xffffffe9,%ecx
 18b82a8:	73 7a                	jae    18b8324 <tier0_tables_open+0xe54>
 18b82aa:	41 8d 4f ec          	lea    -0x14(%r15),%ecx
 18b82ae:	83 f9 e9             	cmp    $0xffffffe9,%ecx
 18b82b1:	0f 83 b1 00 00 00    	jae    18b8368 <tier0_tables_open+0xe98>
 18b82b7:	41 8d 4f ed          	lea    -0x13(%r15),%ecx
 18b82bb:	83 f9 e9             	cmp    $0xffffffe9,%ecx
 18b82be:	0f 83 e8 00 00 00    	jae    18b83ac <tier0_tables_open+0xedc>
 18b82c4:	41 8d 4f ee          	lea    -0x12(%r15),%ecx
 18b82c8:	83 f9 e9             	cmp    $0xffffffe9,%ecx
 18b82cb:	0f 83 1f 01 00 00    	jae    18b83f0 <tier0_tables_open+0xf20>
 18b82d1:	49 83 c7 05          	add    $0x5,%r15
 18b82d5:	48 83 c0 50          	add    $0x50,%rax
 18b82d9:	49 83 ff 1e          	cmp    $0x1e,%r15
 18b82dd:	75 b9                	jne    18b8298 <tier0_tables_open+0xdc8>
 18b82df:	e9 54 01 00 00       	jmp    18b8438 <tier0_tables_open+0xf68>
 18b82e4:	0f b6 48 be          	movzbl -0x42(%rax),%ecx
 18b82e8:	48 8b b4 24 90 00 00 00 	mov    0x90(%rsp),%rsi
 18b82f0:	0f b6 50 c0          	movzbl -0x40(%rax),%edx
 18b82f4:	42 88 4c 3e 02       	mov    %cl,0x2(%rsi,%r15,1)
 18b82f9:	41 8d 4f 02          	lea    0x2(%r15),%ecx
 18b82fd:	42 88 4c 3f 02       	mov    %cl,0x2(%rdi,%r15,1)
 18b8302:	43 c6 44 38 02 04    	movb   $0x4,0x2(%r8,%r15,1)
 18b8308:	43 88 54 39 02       	mov    %dl,0x2(%r9,%r15,1)
 18b830d:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
 18b8312:	0f b6 48 bf          	movzbl -0x41(%rax),%ecx
 18b8316:	4a 89 4c fa 10       	mov    %rcx,0x10(%rdx,%r15,8)
 18b831b:	41 8d 4f eb          	lea    -0x15(%r15),%ecx
 18b831f:	83 f9 e9             	cmp    $0xffffffe9,%ecx
 18b8322:	72 86                	jb     18b82aa <tier0_tables_open+0xdda>
 18b8324:	0f b6 48 ce          	movzbl -0x32(%rax),%ecx
 18b8328:	48 8b b4 24 90 00 00 00 	mov    0x90(%rsp),%rsi
 18b8330:	0f b6 50 d0          	movzbl -0x30(%rax),%edx
 18b8334:	42 88 4c 3e 03       	mov    %cl,0x3(%rsi,%r15,1)
 18b8339:	41 8d 4f 03          	lea    0x3(%r15),%ecx
 18b833d:	42 88 4c 3f 03       	mov    %cl,0x3(%rdi,%r15,1)
 18b8342:	43 c6 44 38 03 04    	movb   $0x4,0x3(%r8,%r15,1)
 18b8348:	43 88 54 39 03       	mov    %dl,0x3(%r9,%r15,1)
 18b834d:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
 18b8352:	0f b6 48 cf          	movzbl -0x31(%rax),%ecx
 18b8356:	4a 89 4c fa 18       	mov    %rcx,0x18(%rdx,%r15,8)
 18b835b:	41 8d 4f ec          	lea    -0x14(%r15),%ecx
 18b835f:	83 f9 e9             	cmp    $0xffffffe9,%ecx
 18b8362:	0f 82 4f ff ff ff    	jb     18b82b7 <tier0_tables_open+0xde7>
 18b8368:	0f b6 48 de          	movzbl -0x22(%rax),%ecx
 18b836c:	48 8b b4 24 90 00 00 00 	mov    0x90(%rsp),%rsi
 18b8374:	0f b6 50 e0          	movzbl -0x20(%rax),%edx
 18b8378:	42 88 4c 3e 04       	mov    %cl,0x4(%rsi,%r15,1)
 18b837d:	41 8d 4f 04          	lea    0x4(%r15),%ecx
 18b8381:	42 88 4c 3f 04       	mov    %cl,0x4(%rdi,%r15,1)
 18b8386:	43 c6 44 38 04 04    	movb   $0x4,0x4(%r8,%r15,1)
 18b838c:	43 88 54 39 04       	mov    %dl,0x4(%r9,%r15,1)
 18b8391:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
 18b8396:	0f b6 48 df          	movzbl -0x21(%rax),%ecx
 18b839a:	4a 89 4c fa 20       	mov    %rcx,0x20(%rdx,%r15,8)
 18b839f:	41 8d 4f ed          	lea    -0x13(%r15),%ecx
 18b83a3:	83 f9 e9             	cmp    $0xffffffe9,%ecx
 18b83a6:	0f 82 18 ff ff ff    	jb     18b82c4 <tier0_tables_open+0xdf4>
 18b83ac:	0f b6 48 ee          	movzbl -0x12(%rax),%ecx
 18b83b0:	48 8b b4 24 90 00 00 00 	mov    0x90(%rsp),%rsi
 18b83b8:	0f b6 50 f0          	movzbl -0x10(%rax),%edx
 18b83bc:	42 88 4c 3e 05       	mov    %cl,0x5(%rsi,%r15,1)
 18b83c1:	41 8d 4f 05          	lea    0x5(%r15),%ecx
 18b83c5:	42 88 4c 3f 05       	mov    %cl,0x5(%rdi,%r15,1)
 18b83ca:	43 c6 44 38 05 04    	movb   $0x4,0x5(%r8,%r15,1)
 18b83d0:	43 88 54 39 05       	mov    %dl,0x5(%r9,%r15,1)
 18b83d5:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
 18b83da:	0f b6 48 ef          	movzbl -0x11(%rax),%ecx
 18b83de:	4a 89 4c fa 28       	mov    %rcx,0x28(%rdx,%r15,8)
 18b83e3:	41 8d 4f ee          	lea    -0x12(%r15),%ecx
 18b83e7:	83 f9 e9             	cmp    $0xffffffe9,%ecx
 18b83ea:	0f 82 e1 fe ff ff    	jb     18b82d1 <tier0_tables_open+0xe01>
 18b83f0:	0f b6 48 fe          	movzbl -0x2(%rax),%ecx
 18b83f4:	48 8b b4 24 90 00 00 00 	mov    0x90(%rsp),%rsi
 18b83fc:	0f b6 10             	movzbl (%rax),%edx
 18b83ff:	42 88 4c 3e 06       	mov    %cl,0x6(%rsi,%r15,1)
 18b8404:	41 8d 4f 06          	lea    0x6(%r15),%ecx
 18b8408:	42 88 4c 3f 06       	mov    %cl,0x6(%rdi,%r15,1)
 18b840d:	43 c6 44 38 06 04    	movb   $0x4,0x6(%r8,%r15,1)
 18b8413:	43 88 54 39 06       	mov    %dl,0x6(%r9,%r15,1)
 18b8418:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
 18b841d:	0f b6 48 ff          	movzbl -0x1(%rax),%ecx
 18b8421:	4a 89 4c fa 30       	mov    %rcx,0x30(%rdx,%r15,8)
 18b8426:	49 83 c7 05          	add    $0x5,%r15
 18b842a:	48 83 c0 50          	add    $0x50,%rax
 18b842e:	49 83 ff 1e          	cmp    $0x1e,%r15
 18b8432:	0f 85 60 fe ff ff    	jne    18b8298 <tier0_tables_open+0xdc8>
 18b8438:	c5 fa 7e 0d 60 d8 cb fe 	vmovq  -0x13427a0(%rip),%xmm1        # 575ca0 <x86_effects_unknown+0x240>
 18b8440:	c4 e2 79 31 15 73 80 cc fe 	vpmovzxbd -0x1337f8d(%rip),%xmm2        # 5804bc <tier0_emit_x87.operations+0x74>
 18b8449:	c5 fa 7e 05 5f d8 cb fe 	vmovq  -0x13427a1(%rip),%xmm0        # 575cb0 <x86_effects_unknown+0x250>
 18b8451:	bb 10 11 11 00       	mov    $0x111110,%ebx
 18b8456:	41 be 02 00 00 00    	mov    $0x2,%r14d
 18b845c:	41 bf 04 00 00 00    	mov    $0x4,%r15d
 18b8462:	41 bc 08 00 00 00    	mov    $0x8,%r12d
 18b8468:	4c 8d 15 a1 75 7e 00 	lea    0x7e75a1(%rip),%r10        # 209fa10 <type_builtins>
 18b846f:	31 d2                	xor    %edx,%edx
 18b8471:	45 31 db             	xor    %r11d,%r11d
 18b8474:	48 0f a3 d3          	bt     %rdx,%rbx
 18b8478:	73 47                	jae    18b84c1 <tier0_tables_open+0xff1>
 18b847a:	48 8b 84 24 90 00 00 00 	mov    0x90(%rsp),%rax
 18b8482:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
 18b8487:	c6 44 10 20 06       	movb   $0x6,0x20(%rax,%rdx,1)
 18b848c:	8d 42 20             	lea    0x20(%rdx),%eax
 18b848f:	88 44 17 20          	mov    %al,0x20(%rdi,%rdx,1)
 18b8493:	41 c6 44 10 20 04    	movb   $0x4,0x20(%r8,%rdx,1)
 18b8499:	43 0f b6 44 5a 0a    	movzbl 0xa(%r10,%r11,2),%eax
 18b849f:	41 88 44 11 20       	mov    %al,0x20(%r9,%rdx,1)
 18b84a4:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
 18b84a9:	44 89 9c 90 80 00 00 00 	mov    %r11d,0x80(%rax,%rdx,4)
 18b84b1:	43 0f b6 44 5a 09    	movzbl 0x9(%r10,%r11,2),%eax
 18b84b7:	01 c0                	add    %eax,%eax
 18b84b9:	48 89 84 d1 00 01 00 00 	mov    %rax,0x100(%rcx,%rdx,8)
 18b84c1:	c4 c2 e9 f7 c6       	shlx   %rdx,%r14,%rax
 18b84c6:	a9 20 22 22 00       	test   $0x222220,%eax
 18b84cb:	74 42                	je     18b850f <tier0_tables_open+0x103f>
 18b84cd:	48 8b 8c 24 90 00 00 00 	mov    0x90(%rsp),%rcx
 18b84d5:	48 89 d0             	mov    %rdx,%rax
 18b84d8:	48 83 c8 21          	or     $0x21,%rax
 18b84dc:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
 18b84e1:	c6 04 01 06          	movb   $0x6,(%rcx,%rax,1)
 18b84e5:	88 04 07             	mov    %al,(%rdi,%rax,1)
 18b84e8:	41 c6 04 00 04       	movb   $0x4,(%r8,%rax,1)
 18b84ed:	43 0f b6 4c 5a 1a    	movzbl 0x1a(%r10,%r11,2),%ecx
 18b84f3:	41 88 0c 01          	mov    %cl,(%r9,%rax,1)
 18b84f7:	41 8d 4b 08          	lea    0x8(%r11),%ecx
 18b84fb:	89 0c 86             	mov    %ecx,(%rsi,%rax,4)
 18b84fe:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
 18b8503:	43 0f b6 4c 5a 19    	movzbl 0x19(%r10,%r11,2),%ecx
 18b8509:	01 c9                	add    %ecx,%ecx
 18b850b:	48 89 0c c6          	mov    %rcx,(%rsi,%rax,8)
 18b850f:	c4 c2 e9 f7 c7       	shlx   %rdx,%r15,%rax
 18b8514:	a9 40 44 40 00       	test   $0x404440,%eax
 18b8519:	74 42                	je     18b855d <tier0_tables_open+0x108d>
 18b851b:	48 8b 8c 24 90 00 00 00 	mov    0x90(%rsp),%rcx
 18b8523:	48 89 d0             	mov    %rdx,%rax
 18b8526:	48 83 c8 22          	or     $0x22,%rax
 18b852a:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
 18b852f:	c6 04 01 06          	movb   $0x6,(%rcx,%rax,1)
 18b8533:	88 04 07             	mov    %al,(%rdi,%rax,1)
 18b8536:	41 c6 04 00 04       	movb   $0x4,(%r8,%rax,1)
 18b853b:	43 0f b6 4c 5a 2a    	movzbl 0x2a(%r10,%r11,2),%ecx
 18b8541:	41 88 0c 01          	mov    %cl,(%r9,%rax,1)
 18b8545:	41 8d 4b 10          	lea    0x10(%r11),%ecx
 18b8549:	89 0c 86             	mov    %ecx,(%rsi,%rax,4)
 18b854c:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
 18b8551:	43 0f b6 4c 5a 29    	movzbl 0x29(%r10,%r11,2),%ecx
 18b8557:	01 c9                	add    %ecx,%ecx
 18b8559:	48 89 0c c6          	mov    %rcx,(%rsi,%rax,8)
 18b855d:	c4 c2 e9 f7 c4       	shlx   %rdx,%r12,%rax
 18b8562:	a9 88 88 08 00       	test   $0x88888,%eax
 18b8567:	74 42                	je     18b85ab <tier0_tables_open+0x10db>
 18b8569:	48 8b 8c 24 90 00 00 00 	mov    0x90(%rsp),%rcx
 18b8571:	48 89 d0             	mov    %rdx,%rax
 18b8574:	48 83 c8 23          	or     $0x23,%rax
 18b8578:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
 18b857d:	c6 04 01 06          	movb   $0x6,(%rcx,%rax,1)
 18b8581:	88 04 07             	mov    %al,(%rdi,%rax,1)
 18b8584:	41 c6 04 00 04       	movb   $0x4,(%r8,%rax,1)
 18b8589:	43 0f b6 4c 5a 3a    	movzbl 0x3a(%r10,%r11,2),%ecx
 18b858f:	41 88 0c 01          	mov    %cl,(%r9,%rax,1)
 18b8593:	41 8d 4b 18          	lea    0x18(%r11),%ecx
 18b8597:	89 0c 86             	mov    %ecx,(%rsi,%rax,4)
 18b859a:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
 18b859f:	43 0f b6 4c 5a 39    	movzbl 0x39(%r10,%r11,2),%ecx
 18b85a5:	01 c9                	add    %ecx,%ecx
 18b85a7:	48 89 0c c6          	mov    %rcx,(%rsi,%rax,8)
 18b85ab:	b0 01                	mov    $0x1,%al
 18b85ad:	48 83 c2 04          	add    $0x4,%rdx
 18b85b1:	49 83 c3 20          	add    $0x20,%r11
 18b85b5:	48 89 84 24 b8 00 00 00 	mov    %rax,0xb8(%rsp)
 18b85bd:	48 83 fa 20          	cmp    $0x20,%rdx
 18b85c1:	0f 85 ad fe ff ff    	jne    18b8474 <tier0_tables_open+0xfa4>
 18b85c7:	ba 40 60 00 00       	mov    $0x6040,%edx
 18b85cc:	48 89 bc 24 40 01 00 00 	mov    %rdi,0x140(%rsp)
 18b85d4:	4c 89 84 24 18 01 00 00 	mov    %r8,0x118(%rsp)
 18b85dc:	4c 89 4c 24 68       	mov    %r9,0x68(%rsp)
 18b85e1:	48 8b 1c 24          	mov    (%rsp),%rbx
 18b85e5:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
 18b85ea:	48 8b 4c 24 58       	mov    0x58(%rsp),%rcx
 18b85ef:	4c 8b bc 24 08 01 00 00 	mov    0x108(%rsp),%r15
 18b85f7:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
 18b85fc:	4c 8b 94 24 00 01 00 00 	mov    0x100(%rsp),%r10
 18b8604:	48 8b bc 24 a8 00 00 00 	mov    0xa8(%rsp),%rdi
 18b860c:	4c 8b 44 24 18       	mov    0x18(%rsp),%r8
 18b8611:	4c 8b b4 24 f8 00 00 00 	mov    0xf8(%rsp),%r14
 18b8619:	4c 8b 9c 24 38 01 00 00 	mov    0x138(%rsp),%r11
 18b8621:	4c 8b ac 24 a0 00 00 00 	mov    0xa0(%rsp),%r13
 18b8629:	48 8b ac 24 30 01 00 00 	mov    0x130(%rsp),%rbp
 18b8631:	4c 8b 8c 24 28 01 00 00 	mov    0x128(%rsp),%r9
 18b8639:	4c 8b a4 24 c8 00 00 00 	mov    0xc8(%rsp),%r12
 18b8641:	c7 44 24 48 00 00 00 00 	movl   $0x0,0x48(%rsp)
 18b8649:	c7 44 24 30 40 00 00 00 	movl   $0x40,0x30(%rsp)
 18b8651:	c7 84 24 10 01 00 00 00 04 00 00 	movl   $0x400,0x110(%rsp)
 18b865c:	48 89 94 24 48 01 00 00 	mov    %rdx,0x148(%rsp)
 18b8664:	48 8b 94 24 90 00 00 00 	mov    0x90(%rsp),%rdx
 18b866c:	e9 10 01 00 00       	jmp    18b8781 <tier0_tables_open+0x12b1>
 18b8671:	48 3b 83 28 01 00 00 	cmp    0x128(%rbx),%rax
 18b8678:	0f 87 04 4c 00 00    	ja     18bd282 <tier0_tables_open+0x5db2>
 18b867e:	48 89 83 28 01 00 00 	mov    %rax,0x128(%rbx)
 18b8685:	b8 c0 01 00 00       	mov    $0x1c0,%eax
 18b868a:	48 c7 83 48 01 00 00 00 00 00 00 	movq   $0x0,0x148(%rbx)
 18b8695:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 18b8699:	c5 fa 7f 84 24 bc 01 00 00 	vmovdqu %xmm0,0x1bc(%rsp)
 18b86a2:	c5 f9 7f 84 24 b0 01 00 00 	vmovdqa %xmm0,0x1b0(%rsp)
 18b86ab:	c7 44 24 48 01 00 00 00 	movl   $0x1,0x48(%rsp)
 18b86b3:	48 c7 84 24 b8 00 00 00 00 00 00 00 	movq   $0x0,0xb8(%rsp)
 18b86bf:	31 d2                	xor    %edx,%edx
 18b86c1:	48 c7 84 24 40 01 00 00 00 00 00 00 	movq   $0x0,0x140(%rsp)
 18b86cd:	48 c7 84 24 18 01 00 00 00 00 00 00 	movq   $0x0,0x118(%rsp)
 18b86d9:	48 c7 44 24 68 00 00 00 00 	movq   $0x0,0x68(%rsp)
 18b86e2:	48 c7 44 24 20 00 00 00 00 	movq   $0x0,0x20(%rsp)
 18b86eb:	48 c7 84 24 d8 00 00 00 00 00 00 00 	movq   $0x0,0xd8(%rsp)
 18b86f7:	48 c7 44 24 10 00 00 00 00 	movq   $0x0,0x10(%rsp)
 18b8700:	48 c7 44 24 08 00 00 00 00 	movq   $0x0,0x8(%rsp)
 18b8709:	48 c7 84 24 80 00 00 00 00 00 00 00 	movq   $0x0,0x80(%rsp)
 18b8715:	c7 44 24 30 00 00 00 00 	movl   $0x0,0x30(%rsp)
 18b871d:	48 c7 44 24 40 00 00 00 00 	movq   $0x0,0x40(%rsp)
 18b8726:	c7 84 24 10 01 00 00 00 00 00 00 	movl   $0x0,0x110(%rsp)
 18b8731:	c5 e9 ef d2          	vpxor  %xmm2,%xmm2,%xmm2
 18b8735:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
 18b8739:	31 c9                	xor    %ecx,%ecx
 18b873b:	45 31 ff             	xor    %r15d,%r15d
 18b873e:	31 f6                	xor    %esi,%esi
 18b8740:	45 31 d2             	xor    %r10d,%r10d
 18b8743:	31 ff                	xor    %edi,%edi
 18b8745:	45 31 c0             	xor    %r8d,%r8d
 18b8748:	45 31 f6             	xor    %r14d,%r14d
 18b874b:	45 31 db             	xor    %r11d,%r11d
 18b874e:	45 31 ed             	xor    %r13d,%r13d
 18b8751:	31 ed                	xor    %ebp,%ebp
 18b8753:	48 c7 44 24 38 00 00 00 00 	movq   $0x0,0x38(%rsp)
 18b875c:	45 31 c9             	xor    %r9d,%r9d
 18b875f:	45 31 e4             	xor    %r12d,%r12d
 18b8762:	48 c7 84 24 d0 00 00 00 00 00 00 00 	movq   $0x0,0xd0(%rsp)
 18b876e:	48 c7 44 24 70 00 00 00 00 	movq   $0x0,0x70(%rsp)
 18b8777:	48 89 84 24 48 01 00 00 	mov    %rax,0x148(%rsp)
 18b877f:	31 c0                	xor    %eax,%eax
 18b8781:	48 89 13             	mov    %rdx,(%rbx)
 18b8784:	48 8b 94 24 40 01 00 00 	mov    0x140(%rsp),%rdx
 18b878c:	48 89 53 08          	mov    %rdx,0x8(%rbx)
 18b8790:	48 8b 94 24 18 01 00 00 	mov    0x118(%rsp),%rdx
 18b8798:	48 89 53 10          	mov    %rdx,0x10(%rbx)
 18b879c:	48 8b 54 24 68       	mov    0x68(%rsp),%rdx
 18b87a1:	48 89 53 18          	mov    %rdx,0x18(%rbx)
 18b87a5:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
 18b87aa:	48 89 53 20          	mov    %rdx,0x20(%rbx)
 18b87ae:	48 8b 94 24 d8 00 00 00 	mov    0xd8(%rsp),%rdx
 18b87b6:	48 89 53 28          	mov    %rdx,0x28(%rbx)
 18b87ba:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
 18b87bf:	48 89 53 30          	mov    %rdx,0x30(%rbx)
 18b87c3:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
 18b87c8:	48 89 53 38          	mov    %rdx,0x38(%rbx)
 18b87cc:	48 8b 94 24 80 00 00 00 	mov    0x80(%rsp),%rdx
 18b87d4:	48 89 53 40          	mov    %rdx,0x40(%rbx)
 18b87d8:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
 18b87dd:	c5 f9 d6 43 48       	vmovq  %xmm0,0x48(%rbx)
 18b87e2:	48 89 53 50          	mov    %rdx,0x50(%rbx)
 18b87e6:	8b 94 24 10 01 00 00 	mov    0x110(%rsp),%edx
 18b87ed:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%rbx)
 18b87f4:	89 53 5c             	mov    %edx,0x5c(%rbx)
 18b87f7:	48 89 43 60          	mov    %rax,0x60(%rbx)
 18b87fb:	48 89 4b 68          	mov    %rcx,0x68(%rbx)
 18b87ff:	4c 89 7b 70          	mov    %r15,0x70(%rbx)
 18b8803:	48 89 73 78          	mov    %rsi,0x78(%rbx)
 18b8807:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
 18b880c:	4c 89 93 80 00 00 00 	mov    %r10,0x80(%rbx)
 18b8813:	48 89 bb 88 00 00 00 	mov    %rdi,0x88(%rbx)
 18b881a:	4c 89 83 90 00 00 00 	mov    %r8,0x90(%rbx)
 18b8821:	4c 89 b3 98 00 00 00 	mov    %r14,0x98(%rbx)
 18b8828:	c5 f9 d6 93 a0 00 00 00 	vmovq  %xmm2,0xa0(%rbx)
 18b8830:	48 c7 83 a8 00 00 00 00 00 00 00 	movq   $0x0,0xa8(%rbx)
 18b883b:	4c 89 9b b0 00 00 00 	mov    %r11,0xb0(%rbx)
 18b8842:	4c 89 ab b8 00 00 00 	mov    %r13,0xb8(%rbx)
 18b8849:	48 89 ab c0 00 00 00 	mov    %rbp,0xc0(%rbx)
 18b8850:	4c 8b 94 24 d0 00 00 00 	mov    0xd0(%rsp),%r10
 18b8858:	8b 54 24 30          	mov    0x30(%rsp),%edx
 18b885c:	8b 4c 24 48          	mov    0x48(%rsp),%ecx
 18b8860:	4c 8b bc 24 48 01 00 00 	mov    0x148(%rsp),%r15
 18b8868:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
 18b886e:	31 ed                	xor    %ebp,%ebp
 18b8870:	31 ff                	xor    %edi,%edi
 18b8872:	48 89 b3 c8 00 00 00 	mov    %rsi,0xc8(%rbx)
 18b8879:	48 8b 74 24 70       	mov    0x70(%rsp),%rsi
 18b887e:	4c 89 8b d0 00 00 00 	mov    %r9,0xd0(%rbx)
 18b8885:	4c 89 a3 d8 00 00 00 	mov    %r12,0xd8(%rbx)
 18b888c:	c5 f9 d6 8b e0 00 00 00 	vmovq  %xmm1,0xe0(%rbx)
 18b8894:	4c 89 93 e8 00 00 00 	mov    %r10,0xe8(%rbx)
 18b889b:	45 8d b7 c0 0f 00 00 	lea    0xfc0(%r15),%r14d
 18b88a2:	45 31 c9             	xor    %r9d,%r9d
 18b88a5:	41 81 e6 00 70 00 00 	and    $0x7000,%r14d
 18b88ac:	48 89 b3 f0 00 00 00 	mov    %rsi,0xf0(%rbx)
 18b88b3:	89 93 f8 00 00 00    	mov    %edx,0xf8(%rbx)
 18b88b9:	c7 83 fc 00 00 00 00 00 00 00 	movl   $0x0,0xfc(%rbx)
 18b88c3:	89 8b 00 01 00 00    	mov    %ecx,0x100(%rbx)
 18b88c9:	ba 03 00 00 00       	mov    $0x3,%edx
 18b88ce:	b9 22 40 00 00       	mov    $0x4022,%ecx
 18b88d3:	4c 89 f6             	mov    %r14,%rsi
 18b88d6:	c5 f8 10 84 24 bc 01 00 00 	vmovups 0x1bc(%rsp),%xmm0
 18b88df:	c5 f8 11 83 10 01 00 00 	vmovups %xmm0,0x110(%rbx)
 18b88e7:	c5 f9 6f 84 24 b0 01 00 00 	vmovdqa 0x1b0(%rsp),%xmm0
 18b88f0:	c5 fa 7f 83 04 01 00 00 	vmovdqu %xmm0,0x104(%rbx)
 18b88f8:	c5 f8 77             	vzeroupper
 18b88fb:	e8 40 bc ea fe       	call   764540 <mmap@plt>
 18b8900:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
 18b8904:	74 18                	je     18b891e <tier0_tables_open+0x144e>
 18b8906:	ba 0f 00 00 00       	mov    $0xf,%edx
 18b890b:	49 89 c4             	mov    %rax,%r12
 18b890e:	48 89 c7             	mov    %rax,%rdi
 18b8911:	4c 89 f6             	mov    %r14,%rsi
 18b8914:	e8 d7 bb ea fe       	call   7644f0 <madvise@plt>
 18b8919:	4c 89 fd             	mov    %r15,%rbp
 18b891c:	eb 03                	jmp    18b8921 <tier0_tables_open+0x1451>
 18b891e:	45 31 e4             	xor    %r12d,%r12d
 18b8921:	80 bc 24 b8 00 00 00 00 	cmpb   $0x0,0xb8(%rsp)
 18b8929:	4c 89 a3 40 02 00 00 	mov    %r12,0x240(%rbx)
 18b8930:	48 c7 83 48 02 00 00 00 00 00 00 	movq   $0x0,0x248(%rbx)
 18b893b:	48 89 ab 50 02 00 00 	mov    %rbp,0x250(%rbx)
 18b8942:	48 c7 83 58 02 00 00 00 00 00 00 	movq   $0x0,0x258(%rbx)
 18b894d:	0f 84 ac 00 00 00    	je     18b89ff <tier0_tables_open+0x152f>
 18b8953:	44 8b 7b 4c          	mov    0x4c(%rbx),%r15d
 18b8957:	49 8d 44 24 3f       	lea    0x3f(%r12),%rax
 18b895c:	4c 8d b3 80 01 00 00 	lea    0x180(%rbx),%r14
 18b8963:	48 83 e0 c0          	and    $0xffffffffffffffc0,%rax
 18b8967:	48 89 c2             	mov    %rax,%rdx
 18b896a:	4c 29 e2             	sub    %r12,%rdx
 18b896d:	72 25                	jb     18b8994 <tier0_tables_open+0x14c4>
 18b896f:	4c 89 f9             	mov    %r15,%rcx
 18b8972:	48 c1 e1 04          	shl    $0x4,%rcx
 18b8976:	48 89 ee             	mov    %rbp,%rsi
 18b8979:	48 29 d6             	sub    %rdx,%rsi
 18b897c:	40 0f 92 c7          	setb   %dil
 18b8980:	48 39 f1             	cmp    %rsi,%rcx
 18b8983:	40 0f 97 c6          	seta   %sil
 18b8987:	40 08 fe             	or     %dil,%sil
 18b898a:	40 80 fe 01          	cmp    $0x1,%sil
 18b898e:	0f 85 99 00 00 00    	jne    18b8a2d <tier0_tables_open+0x155d>
 18b8994:	49 c7 06 00 00 00 00 	movq   $0x0,(%r14)
 18b899b:	48 c7 83 88 01 00 00 00 00 00 00 	movq   $0x0,0x188(%rbx)
 18b89a6:	48 c7 83 90 01 00 00 00 00 00 00 	movq   $0x0,0x190(%rbx)
 18b89b1:	48 c7 83 98 01 00 00 00 00 00 00 	movq   $0x0,0x198(%rbx)
 18b89bc:	48 c7 83 a0 01 00 00 00 00 00 00 	movq   $0x0,0x1a0(%rbx)
 18b89c7:	48 c7 83 a8 01 00 00 00 00 00 00 	movq   $0x0,0x1a8(%rbx)
 18b89d2:	c4 e2 79 21 05 e5 7a cc fe 	vpmovsxbd -0x133851b(%rip),%xmm0        # 5804c0 <tier0_emit_x87.operations+0x78>
 18b89db:	48 c7 83 b0 01 00 00 00 00 00 00 	movq   $0x0,0x1b0(%rbx)
 18b89e6:	c4 c3 79 22 c7 00    	vpinsrd $0x0,%r15d,%xmm0,%xmm0
 18b89ec:	c5 fa 7f 83 b8 01 00 00 	vmovdqu %xmm0,0x1b8(%rbx)
 18b89f4:	48 c7 83 48 02 00 00 00 00 00 00 	movq   $0x0,0x248(%rbx)
 18b89ff:	31 c0                	xor    %eax,%eax
 18b8a01:	64 48 8b 0c 25 28 00 00 00 	mov    %fs:0x28,%rcx
 18b8a0a:	48 3b 8c 24 c0 02 00 00 	cmp    0x2c0(%rsp),%rcx
 18b8a12:	0f 85 92 12 00 00    	jne    18b9caa <tier0_tables_open+0x27da>
 18b8a18:	48 81 c4 c8 02 00 00 	add    $0x2c8,%rsp
 18b8a1f:	5b                   	pop    %rbx
 18b8a20:	41 5c                	pop    %r12
 18b8a22:	41 5d                	pop    %r13
 18b8a24:	41 5e                	pop    %r14
 18b8a26:	41 5f                	pop    %r15
 18b8a28:	5d                   	pop    %rbp
 18b8a29:	c5 f8 77             	vzeroupper
 18b8a2c:	c3                   	ret
 18b8a2d:	48 01 ca             	add    %rcx,%rdx
 18b8a30:	48 89 93 48 02 00 00 	mov    %rdx,0x248(%rbx)
 18b8a37:	48 89 83 80 01 00 00 	mov    %rax,0x180(%rbx)
 18b8a3e:	48 85 c0             	test   %rax,%rax
 18b8a41:	0f 84 54 ff ff ff    	je     18b899b <tier0_tables_open+0x14cb>
 18b8a47:	48 8d 7c 01 30       	lea    0x30(%rcx,%rax,1),%rdi
 18b8a4c:	48 8d 14 01          	lea    (%rcx,%rax,1),%rdx
 18b8a50:	48 83 e7 c0          	and    $0xffffffffffffffc0,%rdi
 18b8a54:	48 39 d7             	cmp    %rdx,%rdi
 18b8a57:	0f 82 3e ff ff ff    	jb     18b899b <tier0_tables_open+0x14cb>
 18b8a5d:	48 89 f8             	mov    %rdi,%rax
 18b8a60:	4a 8d 14 bd 00 00 00 00 	lea    0x0(,%r15,4),%rdx
 18b8a68:	4c 29 e0             	sub    %r12,%rax
 18b8a6b:	48 89 e9             	mov    %rbp,%rcx
 18b8a6e:	48 29 c1             	sub    %rax,%rcx
 18b8a71:	40 0f 92 c6          	setb   %sil
 18b8a75:	48 39 ca             	cmp    %rcx,%rdx
 18b8a78:	0f 97 c1             	seta   %cl
 18b8a7b:	40 08 f1             	or     %sil,%cl
 18b8a7e:	80 f9 01             	cmp    $0x1,%cl
 18b8a81:	0f 84 14 ff ff ff    	je     18b899b <tier0_tables_open+0x14cb>
 18b8a87:	48 01 d0             	add    %rdx,%rax
 18b8a8a:	48 89 83 48 02 00 00 	mov    %rax,0x248(%rbx)
 18b8a91:	48 89 bb 88 01 00 00 	mov    %rdi,0x188(%rbx)
 18b8a98:	48 85 ff             	test   %rdi,%rdi
 18b8a9b:	0f 84 05 ff ff ff    	je     18b89a6 <tier0_tables_open+0x14d6>
 18b8aa1:	48 8d 4c 17 3c       	lea    0x3c(%rdi,%rdx,1),%rcx
 18b8aa6:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
 18b8aaa:	48 83 e1 c0          	and    $0xffffffffffffffc0,%rcx
 18b8aae:	48 39 c1             	cmp    %rax,%rcx
 18b8ab1:	0f 82 ef fe ff ff    	jb     18b89a6 <tier0_tables_open+0x14d6>
 18b8ab7:	48 89 c8             	mov    %rcx,%rax
 18b8aba:	4c 29 e0             	sub    %r12,%rax
 18b8abd:	48 89 ee             	mov    %rbp,%rsi
 18b8ac0:	48 29 c6             	sub    %rax,%rsi
 18b8ac3:	41 0f 92 c0          	setb   %r8b
 18b8ac7:	48 39 f2             	cmp    %rsi,%rdx
 18b8aca:	40 0f 97 c6          	seta   %sil
 18b8ace:	44 08 c6             	or     %r8b,%sil
 18b8ad1:	40 80 fe 01          	cmp    $0x1,%sil
 18b8ad5:	0f 84 cb fe ff ff    	je     18b89a6 <tier0_tables_open+0x14d6>
 18b8adb:	48 01 d0             	add    %rdx,%rax
 18b8ade:	48 89 83 48 02 00 00 	mov    %rax,0x248(%rbx)
 18b8ae5:	48 89 8b 90 01 00 00 	mov    %rcx,0x190(%rbx)
 18b8aec:	48 85 c9             	test   %rcx,%rcx
 18b8aef:	0f 84 bc fe ff ff    	je     18b89b1 <tier0_tables_open+0x14e1>
 18b8af5:	48 8d 44 11 3c       	lea    0x3c(%rcx,%rdx,1),%rax
 18b8afa:	48 01 d1             	add    %rdx,%rcx
 18b8afd:	48 83 e0 c0          	and    $0xffffffffffffffc0,%rax
 18b8b01:	48 39 c8             	cmp    %rcx,%rax
 18b8b04:	0f 82 a7 fe ff ff    	jb     18b89b1 <tier0_tables_open+0x14e1>
 18b8b0a:	48 89 c1             	mov    %rax,%rcx
 18b8b0d:	4c 29 e1             	sub    %r12,%rcx
 18b8b10:	48 89 ee             	mov    %rbp,%rsi
 18b8b13:	48 29 ce             	sub    %rcx,%rsi
 18b8b16:	41 0f 92 c0          	setb   %r8b
 18b8b1a:	4c 39 fe             	cmp    %r15,%rsi
 18b8b1d:	40 0f 92 c6          	setb   %sil
 18b8b21:	44 08 c6             	or     %r8b,%sil
 18b8b24:	40 80 fe 01          	cmp    $0x1,%sil
 18b8b28:	0f 84 83 fe ff ff    	je     18b89b1 <tier0_tables_open+0x14e1>
 18b8b2e:	4c 01 f9             	add    %r15,%rcx
 18b8b31:	48 89 8b 48 02 00 00 	mov    %rcx,0x248(%rbx)
 18b8b38:	48 89 83 98 01 00 00 	mov    %rax,0x198(%rbx)
 18b8b3f:	48 85 c0             	test   %rax,%rax
 18b8b42:	0f 84 74 fe ff ff    	je     18b89bc <tier0_tables_open+0x14ec>
 18b8b48:	4a 8d 4c 38 3f       	lea    0x3f(%rax,%r15,1),%rcx
 18b8b4d:	4c 01 f8             	add    %r15,%rax
 18b8b50:	48 83 e1 c0          	and    $0xffffffffffffffc0,%rcx
 18b8b54:	48 39 c1             	cmp    %rax,%rcx
 18b8b57:	0f 82 5f fe ff ff    	jb     18b89bc <tier0_tables_open+0x14ec>
 18b8b5d:	48 89 c8             	mov    %rcx,%rax
 18b8b60:	4c 29 e0             	sub    %r12,%rax
 18b8b63:	48 89 ee             	mov    %rbp,%rsi
 18b8b66:	48 29 c6             	sub    %rax,%rsi
 18b8b69:	41 0f 92 c0          	setb   %r8b
 18b8b6d:	4c 39 fe             	cmp    %r15,%rsi
 18b8b70:	40 0f 92 c6          	setb   %sil
 18b8b74:	44 08 c6             	or     %r8b,%sil
 18b8b77:	40 80 fe 01          	cmp    $0x1,%sil
 18b8b7b:	0f 84 3b fe ff ff    	je     18b89bc <tier0_tables_open+0x14ec>
 18b8b81:	4c 01 f8             	add    %r15,%rax
 18b8b84:	48 89 83 48 02 00 00 	mov    %rax,0x248(%rbx)
 18b8b8b:	48 89 8b a0 01 00 00 	mov    %rcx,0x1a0(%rbx)
 18b8b92:	48 85 c9             	test   %rcx,%rcx
 18b8b95:	0f 84 2c fe ff ff    	je     18b89c7 <tier0_tables_open+0x14f7>
 18b8b9b:	4a 8d 44 39 3f       	lea    0x3f(%rcx,%r15,1),%rax
 18b8ba0:	4c 01 f9             	add    %r15,%rcx
 18b8ba3:	48 83 e0 c0          	and    $0xffffffffffffffc0,%rax
 18b8ba7:	48 39 c8             	cmp    %rcx,%rax
 18b8baa:	0f 82 17 fe ff ff    	jb     18b89c7 <tier0_tables_open+0x14f7>
 18b8bb0:	48 89 c1             	mov    %rax,%rcx
 18b8bb3:	4e 8d 2c fd 00 00 00 00 	lea    0x0(,%r15,8),%r13
 18b8bbb:	4c 29 e1             	sub    %r12,%rcx
 18b8bbe:	48 89 ee             	mov    %rbp,%rsi
 18b8bc1:	48 29 ce             	sub    %rcx,%rsi
 18b8bc4:	41 0f 92 c0          	setb   %r8b
 18b8bc8:	49 39 f5             	cmp    %rsi,%r13
 18b8bcb:	40 0f 97 c6          	seta   %sil
 18b8bcf:	44 08 c6             	or     %r8b,%sil
 18b8bd2:	40 80 fe 01          	cmp    $0x1,%sil
 18b8bd6:	0f 84 eb fd ff ff    	je     18b89c7 <tier0_tables_open+0x14f7>
 18b8bdc:	4c 01 e9             	add    %r13,%rcx
 18b8bdf:	48 89 8b 48 02 00 00 	mov    %rcx,0x248(%rbx)
 18b8be6:	48 89 83 a8 01 00 00 	mov    %rax,0x1a8(%rbx)
 18b8bed:	48 85 c0             	test   %rax,%rax
 18b8bf0:	0f 84 dc fd ff ff    	je     18b89d2 <tier0_tables_open+0x1502>
 18b8bf6:	4a 8d 4c 28 38       	lea    0x38(%rax,%r13,1),%rcx
 18b8bfb:	4c 01 e8             	add    %r13,%rax
 18b8bfe:	48 83 e1 c0          	and    $0xffffffffffffffc0,%rcx
 18b8c02:	48 39 c1             	cmp    %rax,%rcx
 18b8c05:	0f 82 c7 fd ff ff    	jb     18b89d2 <tier0_tables_open+0x1502>
 18b8c0b:	48 89 c8             	mov    %rcx,%rax
 18b8c0e:	4c 29 e0             	sub    %r12,%rax
 18b8c11:	48 29 c5             	sub    %rax,%rbp
 18b8c14:	40 0f 92 c6          	setb   %sil
 18b8c18:	49 39 ed             	cmp    %rbp,%r13
 18b8c1b:	41 0f 97 c0          	seta   %r8b
 18b8c1f:	41 08 f0             	or     %sil,%r8b
 18b8c22:	41 80 f8 01          	cmp    $0x1,%r8b
 18b8c26:	0f 84 a6 fd ff ff    	je     18b89d2 <tier0_tables_open+0x1502>
 18b8c2c:	c4 e2 79 21 05 8b 78 cc fe 	vpmovsxbd -0x1338775(%rip),%xmm0        # 5804c0 <tier0_emit_x87.operations+0x78>
 18b8c35:	4c 01 e8             	add    %r13,%rax
 18b8c38:	48 89 83 48 02 00 00 	mov    %rax,0x248(%rbx)
 18b8c3f:	48 89 8b b0 01 00 00 	mov    %rcx,0x1b0(%rbx)
 18b8c46:	c4 c3 79 22 c7 00    	vpinsrd $0x0,%r15d,%xmm0,%xmm0
 18b8c4c:	c5 fa 7f 83 b8 01 00 00 	vmovdqu %xmm0,0x1b8(%rbx)
 18b8c54:	48 85 c9             	test   %rcx,%rcx
 18b8c57:	0f 84 97 fd ff ff    	je     18b89f4 <tier0_tables_open+0x1524>
 18b8c5d:	31 f6                	xor    %esi,%esi
 18b8c5f:	45 31 e4             	xor    %r12d,%r12d
 18b8c62:	e8 c9 b6 ea fe       	call   764330 <memset@plt>
 18b8c67:	48 8b bb a0 01 00 00 	mov    0x1a0(%rbx),%rdi
 18b8c6e:	31 f6                	xor    %esi,%esi
 18b8c70:	4c 89 fa             	mov    %r15,%rdx
 18b8c73:	e8 b8 b6 ea fe       	call   764330 <memset@plt>
 18b8c78:	48 8b bb a8 01 00 00 	mov    0x1a8(%rbx),%rdi
 18b8c7f:	31 f6                	xor    %esi,%esi
 18b8c81:	4c 89 ea             	mov    %r13,%rdx
 18b8c84:	e8 a7 b6 ea fe       	call   764330 <memset@plt>
 18b8c89:	c5 fd 6f 05 cf 78 c9 fe 	vmovdqa -0x1368731(%rip),%ymm0        # 550560 <x86_disassembly_format.rounding_names+0x180>
 18b8c91:	c5 f9 6f 0d 67 cf cb fe 	vmovdqa -0x1343099(%rip),%xmm1        # 575c00 <x86_effects_unknown+0x1a0>
 18b8c99:	48 b8 07 07 07 07 07 07 07 07 	movabs $0x707070707070707,%rax
 18b8ca3:	41 bf 01 00 00 00    	mov    $0x1,%r15d
 18b8ca9:	bd 77 00 00 00       	mov    $0x77,%ebp
 18b8cae:	66 41 bd 01 00       	mov    $0x1,%r13w
 18b8cb3:	c7 83 00 02 00 00 00 00 00 00 	movl   $0x0,0x200(%rbx)
 18b8cbd:	c7 83 03 02 00 00 00 00 00 00 	movl   $0x0,0x203(%rbx)
 18b8cc7:	48 89 1c 24          	mov    %rbx,(%rsp)
 18b8ccb:	c5 fe 7f 83 07 02 00 00 	vmovdqu %ymm0,0x207(%rbx)
 18b8cd3:	c5 fa 7f 8b 27 02 00 00 	vmovdqu %xmm1,0x227(%rbx)
 18b8cdb:	c6 83 37 02 00 00 07 	movb   $0x7,0x237(%rbx)
 18b8ce2:	48 89 83 38 02 00 00 	mov    %rax,0x238(%rbx)
 18b8ce9:	e9 a3 00 00 00       	jmp    18b8d91 <tier0_tables_open+0x18c1>
 18b8cee:	c1 e8 18             	shr    $0x18,%eax
 18b8cf1:	62 f2 7d 08 7a c0    	vpbroadcastb %eax,%xmm0
 18b8cf7:	c5 f9 fc 05 11 cf cb fe 	vpaddb -0x13430ef(%rip),%xmm0,%xmm0        # 575c10 <x86_effects_unknown+0x1b0>
 18b8cff:	89 c8                	mov    %ecx,%eax
 18b8d01:	62 f3 7d 08 3e 0d 14 cf cb fe 06 	vpcmpnleub -0x13430ec(%rip),%xmm0,%k1        # 575c20 <x86_effects_unknown+0x1c0>
 18b8d0c:	0c 60                	or     $0x60,%al
 18b8d0e:	62 f2 7d 08 7a c0    	vpbroadcastb %eax,%xmm0
 18b8d14:	89 c8                	mov    %ecx,%eax
 18b8d16:	c1 e0 04             	shl    $0x4,%eax
 18b8d19:	09 c1                	or     %eax,%ecx
 18b8d1b:	0c 06                	or     $0x6,%al
 18b8d1d:	62 f2 7d 08 7a c8    	vpbroadcastb %eax,%xmm1
 18b8d23:	62 f2 7d 09 7a c1    	vpbroadcastb %ecx,%xmm0{%k1}
 18b8d29:	c5 f9 6c c1          	vpunpcklqdq %xmm1,%xmm0,%xmm0
 18b8d2d:	b8 10 00 00 00       	mov    $0x10,%eax
 18b8d32:	b9 00 00 00 00       	mov    $0x0,%ecx
 18b8d37:	48 8b 34 24          	mov    (%rsp),%rsi
 18b8d3b:	c4 c1 7b 92 cd       	kmovd  %r13d,%k1
 18b8d40:	4c 89 f7             	mov    %r14,%rdi
 18b8d43:	48 29 d0             	sub    %rdx,%rax
 18b8d46:	44 89 fa             	mov    %r15d,%edx
 18b8d49:	48 0f 43 c8          	cmovae %rax,%rcx
 18b8d4d:	62 f2 7d 08 7a c9    	vpbroadcastb %ecx,%xmm1
 18b8d53:	62 f3 75 08 3e 05 b2 ce cb fe 05 	vpcmpnltub -0x134314e(%rip),%xmm1,%k0        # 575c10 <x86_effects_unknown+0x1b0>
 18b8d5e:	c4 e2 79 78 0d 59 7a c6 fe 	vpbroadcastb -0x13985a7(%rip),%xmm1        # 5207c0 <branch_sizing_patterns+0xa30>
 18b8d67:	48 8b 86 80 01 00 00 	mov    0x180(%rsi),%rax
 18b8d6e:	c5 fc 45 c9          	korw   %k1,%k0,%k1
 18b8d72:	62 f2 75 09 66 c0    	vpblendmb %xmm0,%xmm1,%xmm0{%k1}
 18b8d78:	c4 a1 79 7f 44 20 10 	vmovdqa %xmm0,0x10(%rax,%r12,1)
 18b8d7f:	e8 8c 30 01 00       	call   18cbe10 <abi_finish>
 18b8d84:	49 ff c7             	inc    %r15
 18b8d87:	49 83 c4 10          	add    $0x10,%r12
 18b8d8b:	49 83 ff 40          	cmp    $0x40,%r15
 18b8d8f:	74 65                	je     18b8df6 <tier0_tables_open+0x1926>
 18b8d91:	48 8b 04 24          	mov    (%rsp),%rax
 18b8d95:	8b 40 48             	mov    0x48(%rax),%eax
 18b8d98:	49 39 c7             	cmp    %rax,%r15
 18b8d9b:	73 59                	jae    18b8df6 <tier0_tables_open+0x1926>
 18b8d9d:	48 8b 04 24          	mov    (%rsp),%rax
 18b8da1:	48 8b 00             	mov    (%rax),%rax
 18b8da4:	42 80 3c 38 00       	cmpb   $0x0,(%rax,%r15,1)
 18b8da9:	74 d9                	je     18b8d84 <tier0_tables_open+0x18b4>
 18b8dab:	48 8b 34 24          	mov    (%rsp),%rsi
 18b8daf:	4c 89 f7             	mov    %r14,%rdi
 18b8db2:	44 89 fa             	mov    %r15d,%edx
 18b8db5:	c5 f8 77             	vzeroupper
 18b8db8:	e8 23 2e 01 00       	call   18cbbe0 <abi_simple>
 18b8dbd:	89 c6                	mov    %eax,%esi
 18b8dbf:	c1 ee 10             	shr    $0x10,%esi
 18b8dc2:	48 89 c1             	mov    %rax,%rcx
 18b8dc5:	48 c1 e9 08          	shr    $0x8,%rcx
 18b8dc9:	89 f7                	mov    %esi,%edi
 18b8dcb:	40 c0 e7 04          	shl    $0x4,%dil
 18b8dcf:	40 08 cf             	or     %cl,%dil
 18b8dd2:	40 80 fe 07          	cmp    $0x7,%sil
 18b8dd6:	40 0f b6 f7          	movzbl %dil,%esi
 18b8dda:	0f 44 f5             	cmove  %ebp,%esi
 18b8ddd:	80 f9 07             	cmp    $0x7,%cl
 18b8de0:	0f 44 f5             	cmove  %ebp,%esi
 18b8de3:	3c 01                	cmp    $0x1,%al
 18b8de5:	0f 84 03 ff ff ff    	je     18b8cee <tier0_tables_open+0x181e>
 18b8deb:	62 f2 7d 08 7a c6    	vpbroadcastb %esi,%xmm0
 18b8df1:	e9 37 ff ff ff       	jmp    18b8d2d <tier0_tables_open+0x185d>
 18b8df6:	48 8b 04 24          	mov    (%rsp),%rax
 18b8dfa:	ba 04 1d 00 00       	mov    $0x1d04,%edx
 18b8dff:	31 f6                	xor    %esi,%esi
 18b8e01:	48 8d b8 60 02 00 00 	lea    0x260(%rax),%rdi
 18b8e08:	c5 f8 77             	vzeroupper
 18b8e0b:	e8 20 b5 ea fe       	call   764330 <memset@plt>
 18b8e10:	48 c7 44 24 68 00 00 00 00 	movq   $0x0,0x68(%rsp)
 18b8e19:	48 8b 4c 24 68       	mov    0x68(%rsp),%rcx
 18b8e1e:	48 8d 05 eb 6d 7e 00 	lea    0x7e6deb(%rip),%rax        # 209fc10 <tier0_record_shapes>
 18b8e25:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
 18b8e29:	80 3e 75             	cmpb   $0x75,(%rsi)
 18b8e2c:	75 09                	jne    18b8e37 <tier0_tables_open+0x1967>
 18b8e2e:	80 7e 01 3a          	cmpb   $0x3a,0x1(%rsi)
 18b8e32:	0f 94 c0             	sete   %al
 18b8e35:	eb 02                	jmp    18b8e39 <tier0_tables_open+0x1969>
 18b8e37:	31 c0                	xor    %eax,%eax
 18b8e39:	48 6b 54 24 68 74    	imul   $0x74,0x68(%rsp),%rdx
 18b8e3f:	48 8b 0c 24          	mov    (%rsp),%rcx
 18b8e43:	48 81 c1 60 02 00 00 	add    $0x260,%rcx
 18b8e4a:	48 01 ca             	add    %rcx,%rdx
 18b8e4d:	88 42 64             	mov    %al,0x64(%rdx)
 18b8e50:	48 89 54 24 10       	mov    %rdx,0x10(%rsp)
 18b8e55:	80 3e 61             	cmpb   $0x61,(%rsi)
 18b8e58:	75 09                	jne    18b8e63 <tier0_tables_open+0x1993>
 18b8e5a:	80 7e 01 3a          	cmpb   $0x3a,0x1(%rsi)
 18b8e5e:	0f 94 c2             	sete   %dl
 18b8e61:	eb 02                	jmp    18b8e65 <tier0_tables_open+0x1995>
 18b8e63:	31 d2                	xor    %edx,%edx
 18b8e65:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
 18b8e6a:	41 b8 01 00 00 00    	mov    $0x1,%r8d
 18b8e70:	88 51 65             	mov    %dl,0x65(%rcx)
 18b8e73:	c7 41 60 01 00 00 00 	movl   $0x1,0x60(%rcx)
 18b8e7a:	8b 79 58             	mov    0x58(%rcx),%edi
 18b8e7d:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
 18b8e82:	48 83 ff 10          	cmp    $0x10,%rdi
 18b8e86:	0f 87 38 01 00 00    	ja     18b8fc4 <tier0_tables_open+0x1af4>
 18b8e8c:	41 89 d1             	mov    %edx,%r9d
 18b8e8f:	41 08 c1             	or     %al,%r9b
 18b8e92:	45 0f b6 c9          	movzbl %r9b,%r9d
 18b8e96:	41 83 e1 01          	and    $0x1,%r9d
 18b8e9a:	4a 8d 34 4e          	lea    (%rsi,%r9,2),%rsi
 18b8e9e:	44 0f b6 14 37       	movzbl (%rdi,%rsi,1),%r10d
 18b8ea3:	45 84 d2             	test   %r10b,%r10b
 18b8ea6:	0f 84 18 01 00 00    	je     18b8fc4 <tier0_tables_open+0x1af4>
 18b8eac:	31 c0                	xor    %eax,%eax
 18b8eae:	41 89 f9             	mov    %edi,%r9d
 18b8eb1:	31 c9                	xor    %ecx,%ecx
 18b8eb3:	41 80 c2 b7          	add    $0xb7,%r10b
 18b8eb7:	bd 0a 00 00 00       	mov    $0xa,%ebp
 18b8ebc:	41 80 fa 2a          	cmp    $0x2a,%r10b
 18b8ec0:	77 10                	ja     18b8ed2 <tier0_tables_open+0x1a02>
 18b8ec2:	45 0f b6 c2          	movzbl %r10b,%r8d
 18b8ec6:	4c 8d 15 ef b7 c6 fe 	lea    -0x1394811(%rip),%r10        # 5246bc <tier0_emit_int128.extensions+0x10>
 18b8ecd:	43 0f b6 2c 10       	movzbl (%r8,%r10,1),%ebp
 18b8ed2:	4c 8d 05 b7 d5 cb fe 	lea    -0x1342a49(%rip),%r8        # 576490 <tier0_class_bytes.bytes>
 18b8ed9:	41 89 ea             	mov    %ebp,%r10d
 18b8edc:	f6 c2 01             	test   $0x1,%dl
 18b8edf:	ba 10 00 00 00       	mov    $0x10,%edx
 18b8ee4:	4c 8b 7c 24 10       	mov    0x10(%rsp),%r15
 18b8ee9:	41 bd 00 00 00 00    	mov    $0x0,%r13d
 18b8eef:	47 0f b6 1c 02       	movzbl (%r10,%r8,1),%r11d
 18b8ef4:	45 89 d8             	mov    %r11d,%r8d
 18b8ef7:	44 0f 45 c2          	cmovne %edx,%r8d
 18b8efb:	45 85 c9             	test   %r9d,%r9d
 18b8efe:	45 0f 45 c3          	cmovne %r11d,%r8d
 18b8f02:	42 8d 54 00 ff       	lea    -0x1(%rax,%r8,1),%edx
 18b8f07:	44 89 c0             	mov    %r8d,%eax
 18b8f0a:	f7 d8                	neg    %eax
 18b8f0c:	21 d0                	and    %edx,%eax
 18b8f0e:	41 80 7f 64 00       	cmpb   $0x0,0x64(%r15)
 18b8f13:	41 88 2c 3f          	mov    %bpl,(%r15,%rdi,1)
 18b8f17:	41 0f 45 c5          	cmovne %r13d,%eax
 18b8f1b:	45 31 e4             	xor    %r12d,%r12d
 18b8f1e:	41 89 44 bf 14       	mov    %eax,0x14(%r15,%rdi,4)
 18b8f23:	41 0f b6 57 65       	movzbl 0x65(%r15),%edx
 18b8f28:	41 8b 5f 60          	mov    0x60(%r15),%ebx
 18b8f2c:	84 d2                	test   %dl,%dl
 18b8f2e:	41 0f 95 c4          	setne  %r12b
 18b8f32:	45 85 c9             	test   %r9d,%r9d
 18b8f35:	43 8d 2c a4          	lea    (%r12,%r12,4),%ebp
 18b8f39:	41 0f 45 ed          	cmovne %r13d,%ebp
 18b8f3d:	44 01 d8             	add    %r11d,%eax
 18b8f40:	4c 8d 1d 29 b6 c6 fe 	lea    -0x13949d7(%rip),%r11        # 524570 <tier0_program_class_type.types>
 18b8f47:	39 c8                	cmp    %ecx,%eax
 18b8f49:	0f 47 c8             	cmova  %eax,%ecx
 18b8f4c:	41 39 d8             	cmp    %ebx,%r8d
 18b8f4f:	44 0f 46 c3          	cmovbe %ebx,%r8d
 18b8f53:	48 c1 e7 04          	shl    $0x4,%rdi
 18b8f57:	41 ff c1             	inc    %r9d
 18b8f5a:	45 89 47 60          	mov    %r8d,0x60(%r15)
 18b8f5e:	44 89 8c 3c b0 01 00 00 	mov    %r9d,0x1b0(%rsp,%rdi,1)
 18b8f66:	47 8b 14 93          	mov    (%r11,%r10,4),%r10d
 18b8f6a:	44 89 94 3c b4 01 00 00 	mov    %r10d,0x1b4(%rsp,%rdi,1)
 18b8f72:	c7 84 3c b8 01 00 00 ff ff ff ff 	movl   $0xffffffff,0x1b8(%rsp,%rdi,1)
 18b8f7d:	40 88 ac 3c bc 01 00 00 	mov    %bpl,0x1bc(%rsp,%rdi,1)
 18b8f85:	c6 84 3c bd 01 00 00 00 	movb   $0x0,0x1bd(%rsp,%rdi,1)
 18b8f8d:	66 c7 84 3c be 01 00 00 00 00 	movw   $0x0,0x1be(%rsp,%rdi,1)
 18b8f97:	45 8b 4f 58          	mov    0x58(%r15),%r9d
 18b8f9b:	41 ff c1             	inc    %r9d
 18b8f9e:	45 89 4f 58          	mov    %r9d,0x58(%r15)
 18b8fa2:	41 83 f9 10          	cmp    $0x10,%r9d
 18b8fa6:	77 11                	ja     18b8fb9 <tier0_tables_open+0x1ae9>
 18b8fa8:	46 0f b6 14 0e       	movzbl (%rsi,%r9,1),%r10d
 18b8fad:	4c 89 cf             	mov    %r9,%rdi
 18b8fb0:	45 84 d2             	test   %r10b,%r10b
 18b8fb3:	0f 85 fa fe ff ff    	jne    18b8eb3 <tier0_tables_open+0x19e3>
 18b8fb9:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
 18b8fbe:	ff c9                	dec    %ecx
 18b8fc0:	0f b6 40 64          	movzbl 0x64(%rax),%eax
 18b8fc4:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
 18b8fc9:	48 8b 14 24          	mov    (%rsp),%rdx
 18b8fcd:	44 01 c1             	add    %r8d,%ecx
 18b8fd0:	41 f7 d8             	neg    %r8d
 18b8fd3:	41 21 c8             	and    %ecx,%r8d
 18b8fd6:	44 89 46 5c          	mov    %r8d,0x5c(%rsi)
 18b8fda:	44 8b 62 48          	mov    0x48(%rdx),%r12d
 18b8fde:	44 3b 62 4c          	cmp    0x4c(%rdx),%r12d
 18b8fe2:	0f 84 ca 0c 00 00    	je     18b9cb2 <tier0_tables_open+0x27e2>
 18b8fe8:	48 8b 14 24          	mov    (%rsp),%rdx
 18b8fec:	8b 8a a0 00 00 00    	mov    0xa0(%rdx),%ecx
 18b8ff2:	3b 8a a4 00 00 00    	cmp    0xa4(%rdx),%ecx
 18b8ff8:	0f 84 b4 0c 00 00    	je     18b9cb2 <tier0_tables_open+0x27e2>
 18b8ffe:	48 8b 3c 24          	mov    (%rsp),%rdi
 18b9002:	0c 10                	or     $0x10,%al
 18b9004:	42 8d 34 e5 00 00 00 00 	lea    0x0(,%r12,8),%esi
 18b900c:	89 74 24 40          	mov    %esi,0x40(%rsp)
 18b9010:	48 8b 17             	mov    (%rdi),%rdx
 18b9013:	42 88 04 22          	mov    %al,(%rdx,%r12,1)
 18b9017:	48 8b 57 08          	mov    0x8(%rdi),%rdx
 18b901b:	42 c6 04 22 00       	movb   $0x0,(%rdx,%r12,1)
 18b9020:	48 8b 57 10          	mov    0x10(%rdi),%rdx
 18b9024:	42 c6 04 22 00       	movb   $0x0,(%rdx,%r12,1)
 18b9029:	48 8b 57 18          	mov    0x18(%rdi),%rdx
 18b902d:	42 c6 04 22 00       	movb   $0x0,(%rdx,%r12,1)
 18b9032:	48 8b 57 20          	mov    0x20(%rdi),%rdx
 18b9036:	42 c7 04 a2 00 00 00 00 	movl   $0x0,(%rdx,%r12,4)
 18b903e:	48 8b 57 28          	mov    0x28(%rdi),%rdx
 18b9042:	42 89 0c a2          	mov    %ecx,(%rdx,%r12,4)
 18b9046:	48 8b 57 30          	mov    0x30(%rdi),%rdx
 18b904a:	4a c7 04 e2 00 00 00 00 	movq   $0x0,(%rdx,%r12,8)
 18b9052:	48 8b 57 38          	mov    0x38(%rdi),%rdx
 18b9056:	4a c7 04 e2 00 00 00 00 	movq   $0x0,(%rdx,%r12,8)
 18b905e:	48 8b 57 40          	mov    0x40(%rdi),%rdx
 18b9062:	4a c7 04 e2 00 00 00 00 	movq   $0x0,(%rdx,%r12,8)
 18b906a:	ff 47 48             	incl   0x48(%rdi)
 18b906d:	48 8b 57 60          	mov    0x60(%rdi),%rdx
 18b9071:	89 34 8a             	mov    %esi,(%rdx,%rcx,4)
 18b9074:	48 8b 54 24 68       	mov    0x68(%rsp),%rdx
 18b9079:	48 8b 77 68          	mov    0x68(%rdi),%rsi
 18b907d:	81 c2 e8 03 00 00    	add    $0x3e8,%edx
 18b9083:	89 14 8e             	mov    %edx,(%rsi,%rcx,4)
 18b9086:	48 8b 77 70          	mov    0x70(%rdi),%rsi
 18b908a:	c7 04 8e 00 00 00 00 	movl   $0x0,(%rsi,%rcx,4)
 18b9091:	48 8b 77 78          	mov    0x78(%rdi),%rsi
 18b9095:	c7 04 8e 00 00 00 00 	movl   $0x0,(%rsi,%rcx,4)
 18b909c:	48 8b b7 80 00 00 00 	mov    0x80(%rdi),%rsi
 18b90a3:	c7 04 8e 00 00 00 00 	movl   $0x0,(%rsi,%rcx,4)
 18b90aa:	48 8b b7 88 00 00 00 	mov    0x88(%rdi),%rsi
 18b90b1:	c6 04 0e 00          	movb   $0x0,(%rsi,%rcx,1)
 18b90b5:	48 8b b7 90 00 00 00 	mov    0x90(%rdi),%rsi
 18b90bc:	c6 04 0e 00          	movb   $0x0,(%rsi,%rcx,1)
 18b90c0:	48 8b b7 98 00 00 00 	mov    0x98(%rdi),%rsi
 18b90c7:	c6 04 0e 00          	movb   $0x0,(%rsi,%rcx,1)
 18b90cb:	ff 87 a0 00 00 00    	incl   0xa0(%rdi)
 18b90d1:	48 8b b7 08 01 00 00 	mov    0x108(%rdi),%rsi
 18b90d8:	48 85 f6             	test   %rsi,%rsi
 18b90db:	74 76                	je     18b9153 <tier0_tables_open+0x1c83>
 18b90dd:	80 7e 4c 00          	cmpb   $0x0,0x4c(%rsi)
 18b90e1:	75 70                	jne    18b9153 <tier0_tables_open+0x1c83>
 18b90e3:	8b 7e 08             	mov    0x8(%rsi),%edi
 18b90e6:	3b 7e 0c             	cmp    0xc(%rsi),%edi
 18b90e9:	75 06                	jne    18b90f1 <tier0_tables_open+0x1c21>
 18b90eb:	c6 46 4c 01          	movb   $0x1,0x4c(%rsi)
 18b90ef:	eb 62                	jmp    18b9153 <tier0_tables_open+0x1c83>
 18b90f1:	44 8d 4f 01          	lea    0x1(%rdi),%r9d
 18b90f5:	44 8b 46 38          	mov    0x38(%rsi),%r8d
 18b90f9:	c6 46 4c 00          	movb   $0x0,0x4c(%rsi)
 18b90fd:	48 6b ff 38          	imul   $0x38,%rdi,%rdi
 18b9101:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 18b9105:	44 89 4e 08          	mov    %r9d,0x8(%rsi)
 18b9109:	4c 8b 0e             	mov    (%rsi),%r9
 18b910c:	4c 8b 56 30          	mov    0x30(%rsi),%r10
 18b9110:	ff 46 34             	incl   0x34(%rsi)
 18b9113:	8b 74 24 40          	mov    0x40(%rsp),%esi
 18b9117:	4d 89 14 39          	mov    %r10,(%r9,%rdi,1)
 18b911b:	41 c6 44 39 08 02    	movb   $0x2,0x8(%r9,%rdi,1)
 18b9121:	41 88 44 39 09       	mov    %al,0x9(%r9,%rdi,1)
 18b9126:	c4 c1 7a 7f 44 39 0a 	vmovdqu %xmm0,0xa(%r9,%rdi,1)
 18b912d:	49 c7 44 39 18 00 00 00 00 	movq   $0x0,0x18(%r9,%rdi,1)
 18b9136:	41 89 74 39 20       	mov    %esi,0x20(%r9,%rdi,1)
 18b913b:	41 89 54 39 24       	mov    %edx,0x24(%r9,%rdi,1)
 18b9140:	45 89 44 39 28       	mov    %r8d,0x28(%r9,%rdi,1)
 18b9145:	41 89 4c 39 2c       	mov    %ecx,0x2c(%r9,%rdi,1)
 18b914a:	49 c7 44 39 30 00 00 00 00 	movq   $0x0,0x30(%r9,%rdi,1)
 18b9153:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
 18b9158:	8b 4c 24 40          	mov    0x40(%rsp),%ecx
 18b915c:	89 48 68             	mov    %ecx,0x68(%rax)
 18b915f:	85 c9                	test   %ecx,%ecx
 18b9161:	0f 84 c1 0b 00 00    	je     18b9d28 <tier0_tables_open+0x2858>
 18b9167:	48 8b 04 24          	mov    (%rsp),%rax
 18b916b:	41 81 e4 ff ff ff 1f 	and    $0x1fffffff,%r12d
 18b9172:	41 ba 0d 00 00 00    	mov    $0xd,%r10d
 18b9178:	8b 58 48             	mov    0x48(%rax),%ebx
 18b917b:	41 39 dc             	cmp    %ebx,%r12d
 18b917e:	0f 83 7a 0b 00 00    	jae    18b9cfe <tier0_tables_open+0x282e>
 18b9184:	48 8b 04 24          	mov    (%rsp),%rax
 18b9188:	48 8b 30             	mov    (%rax),%rsi
 18b918b:	42 0f b6 04 26       	movzbl (%rsi,%r12,1),%eax
 18b9190:	24 fe                	and    $0xfe,%al
 18b9192:	3c 10                	cmp    $0x10,%al
 18b9194:	0f 85 64 0b 00 00    	jne    18b9cfe <tier0_tables_open+0x282e>
 18b919a:	48 8b 04 24          	mov    (%rsp),%rax
 18b919e:	48 8b 40 10          	mov    0x10(%rax),%rax
 18b91a2:	42 f6 04 20 24       	testb  $0x24,(%rax,%r12,1)
 18b91a7:	0f 85 51 0b 00 00    	jne    18b9cfe <tier0_tables_open+0x282e>
 18b91ad:	49 89 c7             	mov    %rax,%r15
 18b91b0:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
 18b91b5:	8b 48 58             	mov    0x58(%rax),%ecx
 18b91b8:	48 8b 04 24          	mov    (%rsp),%rax
 18b91bc:	8b 90 e0 00 00 00    	mov    0xe0(%rax),%edx
 18b91c2:	8b 80 e4 00 00 00    	mov    0xe4(%rax),%eax
 18b91c8:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
 18b91cd:	ff c9                	dec    %ecx
 18b91cf:	29 d0                	sub    %edx,%eax
 18b91d1:	89 94 24 80 00 00 00 	mov    %edx,0x80(%rsp)
 18b91d8:	39 c1                	cmp    %eax,%ecx
 18b91da:	0f 83 e1 01 00 00    	jae    18b93c1 <tier0_tables_open+0x1ef1>
 18b91e0:	41 b8 01 00 00 00    	mov    $0x1,%r8d
 18b91e6:	4c 8d 8c 24 bc 01 00 00 	lea    0x1bc(%rsp),%r9
 18b91ee:	c6 44 24 20 20       	movb   $0x20,0x20(%rsp)
 18b91f3:	45 8b 59 f8          	mov    -0x8(%r9),%r11d
 18b91f7:	41 ba 02 00 00 00    	mov    $0x2,%r10d
 18b91fd:	45 89 dd             	mov    %r11d,%r13d
 18b9200:	41 c1 ed 03          	shr    $0x3,%r13d
 18b9204:	0f 84 f4 0a 00 00    	je     18b9cfe <tier0_tables_open+0x282e>
 18b920a:	41 39 dd             	cmp    %ebx,%r13d
 18b920d:	0f 83 eb 0a 00 00    	jae    18b9cfe <tier0_tables_open+0x282e>
 18b9213:	42 0f b6 0c 2e       	movzbl (%rsi,%r13,1),%ecx
 18b9218:	84 c9                	test   %cl,%cl
 18b921a:	0f 84 de 0a 00 00    	je     18b9cfe <tier0_tables_open+0x282e>
 18b9220:	89 cd                	mov    %ecx,%ebp
 18b9222:	80 f9 0f             	cmp    $0xf,%cl
 18b9225:	75 13                	jne    18b923a <tier0_tables_open+0x1d6a>
 18b9227:	48 8b 04 24          	mov    (%rsp),%rax
 18b922b:	48 8b 40 20          	mov    0x20(%rax),%rax
 18b922f:	42 8b 04 a8          	mov    (%rax,%r13,4),%eax
 18b9233:	c1 e8 03             	shr    $0x3,%eax
 18b9236:	0f b6 2c 06          	movzbl (%rsi,%rax,1),%ebp
 18b923a:	41 ba 0e 00 00 00    	mov    $0xe,%r10d
 18b9240:	40 80 fd 01          	cmp    $0x1,%bpl
 18b9244:	0f 84 b4 0a 00 00    	je     18b9cfe <tier0_tables_open+0x282e>
 18b924a:	40 0f b6 c5          	movzbl %bpl,%eax
 18b924e:	83 f8 0b             	cmp    $0xb,%eax
 18b9251:	0f 84 a7 0a 00 00    	je     18b9cfe <tier0_tables_open+0x282e>
 18b9257:	43 0f b6 14 2f       	movzbl (%r15,%r13,1),%edx
 18b925c:	f6 c2 08             	test   $0x8,%dl
 18b925f:	0f 85 99 0a 00 00    	jne    18b9cfe <tier0_tables_open+0x282e>
 18b9265:	80 f9 0f             	cmp    $0xf,%cl
 18b9268:	75 2a                	jne    18b9294 <tier0_tables_open+0x1dc4>
 18b926a:	48 8b 04 24          	mov    (%rsp),%rax
 18b926e:	48 8b 40 20          	mov    0x20(%rax),%rax
 18b9272:	42 8b 04 a8          	mov    (%rax,%r13,4),%eax
 18b9276:	c1 e8 03             	shr    $0x3,%eax
 18b9279:	41 0f b6 14 07       	movzbl (%r15,%rax,1),%edx
 18b927e:	41 8b 41 fc          	mov    -0x4(%r9),%eax
 18b9282:	45 31 d2             	xor    %r10d,%r10d
 18b9285:	f6 c2 04             	test   $0x4,%dl
 18b9288:	74 16                	je     18b92a0 <tier0_tables_open+0x1dd0>
 18b928a:	45 85 d2             	test   %r10d,%r10d
 18b928d:	74 53                	je     18b92e2 <tier0_tables_open+0x1e12>
 18b928f:	e9 ce 00 00 00       	jmp    18b9362 <tier0_tables_open+0x1e92>
 18b9294:	41 8b 41 fc          	mov    -0x4(%r9),%eax
 18b9298:	45 31 d2             	xor    %r10d,%r10d
 18b929b:	f6 c2 04             	test   $0x4,%dl
 18b929e:	75 ea                	jne    18b928a <tier0_tables_open+0x1dba>
 18b92a0:	83 f8 ff             	cmp    $0xffffffff,%eax
 18b92a3:	0f 95 c2             	setne  %dl
 18b92a6:	4c 39 44 24 08       	cmp    %r8,0x8(%rsp)
 18b92ab:	40 0f 95 c7          	setne  %dil
 18b92af:	40 80 fd 09          	cmp    $0x9,%bpl
 18b92b3:	41 0f 95 c2          	setne  %r10b
 18b92b7:	40 08 d7             	or     %dl,%dil
 18b92ba:	ba 0e 00 00 00       	mov    $0xe,%edx
 18b92bf:	44 08 d7             	or     %r10b,%dil
 18b92c2:	41 ba 00 00 00 00    	mov    $0x0,%r10d
 18b92c8:	44 0f 45 d2          	cmovne %edx,%r10d
 18b92cc:	40 80 f7 01          	xor    $0x1,%dil
 18b92d0:	40 c0 e7 06          	shl    $0x6,%dil
 18b92d4:	40 08 7c 24 20       	or     %dil,0x20(%rsp)
 18b92d9:	45 85 d2             	test   %r10d,%r10d
 18b92dc:	0f 85 80 00 00 00    	jne    18b9362 <tier0_tables_open+0x1e92>
 18b92e2:	83 f8 ff             	cmp    $0xffffffff,%eax
 18b92e5:	74 7b                	je     18b9362 <tier0_tables_open+0x1e92>
 18b92e7:	80 f9 0f             	cmp    $0xf,%cl
 18b92ea:	75 18                	jne    18b9304 <tier0_tables_open+0x1e34>
 18b92ec:	48 8b 0c 24          	mov    (%rsp),%rcx
 18b92f0:	48 8b 49 20          	mov    0x20(%rcx),%rcx
 18b92f4:	46 8b 1c a9          	mov    (%rcx,%r13,4),%r11d
 18b92f8:	45 89 dd             	mov    %r11d,%r13d
 18b92fb:	41 c1 ed 03          	shr    $0x3,%r13d
 18b92ff:	42 0f b6 0c 2e       	movzbl (%rsi,%r13,1),%ecx
 18b9304:	80 f9 12             	cmp    $0x12,%cl
 18b9307:	75 21                	jne    18b932a <tier0_tables_open+0x1e5a>
 18b9309:	43 f6 04 2f 04       	testb  $0x4,(%r15,%r13,1)
 18b930e:	0f 84 e4 09 00 00    	je     18b9cf8 <tier0_tables_open+0x2828>
 18b9314:	48 8b 0c 24          	mov    (%rsp),%rcx
 18b9318:	48 8b 49 20          	mov    0x20(%rcx),%rcx
 18b931c:	46 8b 1c a9          	mov    (%rcx,%r13,4),%r11d
 18b9320:	44 89 d9             	mov    %r11d,%ecx
 18b9323:	c1 e9 03             	shr    $0x3,%ecx
 18b9326:	0f b6 0c 0e          	movzbl (%rsi,%rcx,1),%ecx
 18b932a:	41 ba 0f 00 00 00    	mov    $0xf,%r10d
 18b9330:	80 f9 05             	cmp    $0x5,%cl
 18b9333:	74 37                	je     18b936c <tier0_tables_open+0x1e9c>
 18b9335:	0f b6 c9             	movzbl %cl,%ecx
 18b9338:	83 f9 02             	cmp    $0x2,%ecx
 18b933b:	0f 85 bd 09 00 00    	jne    18b9cfe <tier0_tables_open+0x282e>
 18b9341:	41 83 e3 f8          	and    $0xfffffff8,%r11d
 18b9345:	b9 01 00 00 00       	mov    $0x1,%ecx
 18b934a:	41 83 fb 10          	cmp    $0x10,%r11d
 18b934e:	74 35                	je     18b9385 <tier0_tables_open+0x1eb5>
 18b9350:	48 8b 0c 24          	mov    (%rsp),%rcx
 18b9354:	48 8b 49 38          	mov    0x38(%rcx),%rcx
 18b9358:	4a 8b 0c 19          	mov    (%rcx,%r11,1),%rcx
 18b935c:	48 c1 e1 03          	shl    $0x3,%rcx
 18b9360:	eb 1a                	jmp    18b937c <tier0_tables_open+0x1eac>
 18b9362:	45 85 d2             	test   %r10d,%r10d
 18b9365:	74 37                	je     18b939e <tier0_tables_open+0x1ece>
 18b9367:	e9 92 09 00 00       	jmp    18b9cfe <tier0_tables_open+0x282e>
 18b936c:	48 8b 0c 24          	mov    (%rsp),%rcx
 18b9370:	41 83 e3 f8          	and    $0xfffffff8,%r11d
 18b9374:	48 8b 49 30          	mov    0x30(%rcx),%rcx
 18b9378:	4a 8b 0c 19          	mov    (%rcx,%r11,1),%rcx
 18b937c:	48 85 c9             	test   %rcx,%rcx
 18b937f:	0f 84 79 09 00 00    	je     18b9cfe <tier0_tables_open+0x282e>
 18b9385:	48 39 c1             	cmp    %rax,%rcx
 18b9388:	0f 82 70 09 00 00    	jb     18b9cfe <tier0_tables_open+0x282e>
 18b938e:	48 85 c0             	test   %rax,%rax
 18b9391:	75 0b                	jne    18b939e <tier0_tables_open+0x1ece>
 18b9393:	41 83 79 f4 00       	cmpl   $0x0,-0xc(%r9)
 18b9398:	0f 85 60 09 00 00    	jne    18b9cfe <tier0_tables_open+0x282e>
 18b939e:	41 0f b6 01          	movzbl (%r9),%eax
 18b93a2:	4c 3b 44 24 08       	cmp    0x8(%rsp),%r8
 18b93a7:	73 0f                	jae    18b93b8 <tier0_tables_open+0x1ee8>
 18b93a9:	49 ff c0             	inc    %r8
 18b93ac:	49 83 c1 10          	add    $0x10,%r9
 18b93b0:	3c 22                	cmp    $0x22,%al
 18b93b2:	0f 82 3b fe ff ff    	jb     18b91f3 <tier0_tables_open+0x1d23>
 18b93b8:	3c 22                	cmp    $0x22,%al
 18b93ba:	72 14                	jb     18b93d0 <tier0_tables_open+0x1f00>
 18b93bc:	e9 26 0a 00 00       	jmp    18b9de7 <tier0_tables_open+0x2917>
 18b93c1:	c6 44 24 20 20       	movb   $0x20,0x20(%rsp)
 18b93c6:	39 44 24 08          	cmp    %eax,0x8(%rsp)
 18b93ca:	0f 87 20 09 00 00    	ja     18b9cf0 <tier0_tables_open+0x2820>
 18b93d0:	48 8b 04 24          	mov    (%rsp),%rax
 18b93d4:	83 7c 24 08 00       	cmpl   $0x0,0x8(%rsp)
 18b93d9:	48 8b 40 28          	mov    0x28(%rax),%rax
 18b93dd:	46 8b 3c a0          	mov    (%rax,%r12,4),%r15d
 18b93e1:	8b 84 24 80 00 00 00 	mov    0x80(%rsp),%eax
 18b93e8:	0f 84 bd 01 00 00    	je     18b95ab <tier0_tables_open+0x20db>
 18b93ee:	83 7c 24 08 01       	cmpl   $0x1,0x8(%rsp)
 18b93f3:	75 07                	jne    18b93fc <tier0_tables_open+0x1f2c>
 18b93f5:	31 c0                	xor    %eax,%eax
 18b93f7:	e9 18 01 00 00       	jmp    18b9514 <tier0_tables_open+0x2044>
 18b93fc:	8b 84 24 80 00 00 00 	mov    0x80(%rsp),%eax
 18b9403:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
 18b9408:	83 e1 fe             	and    $0xfffffffe,%ecx
 18b940b:	48 8d b4 24 cd 01 00 00 	lea    0x1cd(%rsp),%rsi
 18b9413:	89 c2                	mov    %eax,%edx
 18b9415:	31 c0                	xor    %eax,%eax
 18b9417:	48 8b 1c 24          	mov    (%rsp),%rbx
 18b941b:	8b 7e e3             	mov    -0x1d(%rsi),%edi
 18b941e:	44 8b 46 eb          	mov    -0x15(%rsi),%r8d
 18b9422:	41 89 d3             	mov    %edx,%r11d
 18b9425:	41 bd 00 00 00 00    	mov    $0x0,%r13d
 18b942b:	4c 8b 93 b0 00 00 00 	mov    0xb0(%rbx),%r10
 18b9432:	41 83 f8 ff          	cmp    $0xffffffff,%r8d
 18b9436:	45 0f 44 c5          	cmove  %r13d,%r8d
 18b943a:	41 0f 95 c1          	setne  %r9b
 18b943e:	45 00 c9             	add    %r9b,%r9b
 18b9441:	43 89 3c 9a          	mov    %edi,(%r10,%r11,4)
 18b9445:	8b 7e e7             	mov    -0x19(%rsi),%edi
 18b9448:	4c 8b 93 b8 00 00 00 	mov    0xb8(%rbx),%r10
 18b944f:	43 89 3c 9a          	mov    %edi,(%r10,%r11,4)
 18b9453:	48 8b bb c0 00 00 00 	mov    0xc0(%rbx),%rdi
 18b945a:	46 89 04 9f          	mov    %r8d,(%rdi,%r11,4)
 18b945e:	0f b6 7e ef          	movzbl -0x11(%rsi),%edi
 18b9462:	4c 8b 83 c8 00 00 00 	mov    0xc8(%rbx),%r8
 18b9469:	43 88 3c 18          	mov    %dil,(%r8,%r11,1)
 18b946d:	44 0a 4e f0          	or     -0x10(%rsi),%r9b
 18b9471:	48 8b bb d0 00 00 00 	mov    0xd0(%rbx),%rdi
 18b9478:	46 88 0c 1f          	mov    %r9b,(%rdi,%r11,1)
 18b947c:	44 8d 4a 01          	lea    0x1(%rdx),%r9d
 18b9480:	48 8b bb d8 00 00 00 	mov    0xd8(%rbx),%rdi
 18b9487:	4a c7 04 df 00 00 00 00 	movq   $0x0,(%rdi,%r11,8)
 18b948f:	8b 7e f3             	mov    -0xd(%rsi),%edi
 18b9492:	4c 8b 9b b0 00 00 00 	mov    0xb0(%rbx),%r11
 18b9499:	44 8b 46 fb          	mov    -0x5(%rsi),%r8d
 18b949d:	43 89 3c 8b          	mov    %edi,(%r11,%r9,4)
 18b94a1:	41 83 f8 ff          	cmp    $0xffffffff,%r8d
 18b94a5:	8b 7e f7             	mov    -0x9(%rsi),%edi
 18b94a8:	4c 8b 9b b8 00 00 00 	mov    0xb8(%rbx),%r11
 18b94af:	45 0f 44 c5          	cmove  %r13d,%r8d
 18b94b3:	41 0f 95 c2          	setne  %r10b
 18b94b7:	48 83 c0 02          	add    $0x2,%rax
 18b94bb:	83 c2 02             	add    $0x2,%edx
 18b94be:	45 00 d2             	add    %r10b,%r10b
 18b94c1:	43 89 3c 8b          	mov    %edi,(%r11,%r9,4)
 18b94c5:	48 8b bb c0 00 00 00 	mov    0xc0(%rbx),%rdi
 18b94cc:	46 89 04 8f          	mov    %r8d,(%rdi,%r9,4)
 18b94d0:	0f b6 7e ff          	movzbl -0x1(%rsi),%edi
 18b94d4:	4c 8b 83 c8 00 00 00 	mov    0xc8(%rbx),%r8
 18b94db:	43 88 3c 08          	mov    %dil,(%r8,%r9,1)
 18b94df:	44 0a 16             	or     (%rsi),%r10b
 18b94e2:	48 8b bb d0 00 00 00 	mov    0xd0(%rbx),%rdi
 18b94e9:	48 83 c6 20          	add    $0x20,%rsi
 18b94ed:	46 88 14 0f          	mov    %r10b,(%rdi,%r9,1)
 18b94f1:	48 8b bb d8 00 00 00 	mov    0xd8(%rbx),%rdi
 18b94f8:	4a c7 04 cf 00 00 00 00 	movq   $0x0,(%rdi,%r9,8)
 18b9500:	48 39 c1             	cmp    %rax,%rcx
 18b9503:	0f 85 0e ff ff ff    	jne    18b9417 <tier0_tables_open+0x1f47>
 18b9509:	f6 44 24 08 01       	testb  $0x1,0x8(%rsp)
 18b950e:	0f 84 8d 00 00 00    	je     18b95a1 <tier0_tables_open+0x20d1>
 18b9514:	4c 8b 0c 24          	mov    (%rsp),%r9
 18b9518:	48 89 c1             	mov    %rax,%rcx
 18b951b:	48 c1 e1 04          	shl    $0x4,%rcx
 18b951f:	03 84 24 80 00 00 00 	add    0x80(%rsp),%eax
 18b9526:	8b 94 0c b0 01 00 00 	mov    0x1b0(%rsp,%rcx,1),%edx
 18b952d:	8b b4 0c b8 01 00 00 	mov    0x1b8(%rsp,%rcx,1),%esi
 18b9534:	4d 8b 81 b0 00 00 00 	mov    0xb0(%r9),%r8
 18b953b:	83 fe ff             	cmp    $0xffffffff,%esi
 18b953e:	40 0f 95 c7          	setne  %dil
 18b9542:	41 89 14 80          	mov    %edx,(%r8,%rax,4)
 18b9546:	8b 94 0c b4 01 00 00 	mov    0x1b4(%rsp,%rcx,1),%edx
 18b954d:	4d 8b 81 b8 00 00 00 	mov    0xb8(%r9),%r8
 18b9554:	41 89 14 80          	mov    %edx,(%r8,%rax,4)
 18b9558:	ba 00 00 00 00       	mov    $0x0,%edx
 18b955d:	0f 44 f2             	cmove  %edx,%esi
 18b9560:	49 8b 91 c0 00 00 00 	mov    0xc0(%r9),%rdx
 18b9567:	40 00 ff             	add    %dil,%dil
 18b956a:	89 34 82             	mov    %esi,(%rdx,%rax,4)
 18b956d:	0f b6 94 0c bc 01 00 00 	movzbl 0x1bc(%rsp,%rcx,1),%edx
 18b9575:	49 8b b1 c8 00 00 00 	mov    0xc8(%r9),%rsi
 18b957c:	88 14 06             	mov    %dl,(%rsi,%rax,1)
 18b957f:	40 0a bc 0c bd 01 00 00 	or     0x1bd(%rsp,%rcx,1),%dil
 18b9587:	49 8b 91 d0 00 00 00 	mov    0xd0(%r9),%rdx
 18b958e:	40 88 3c 02          	mov    %dil,(%rdx,%rax,1)
 18b9592:	49 8b 89 d8 00 00 00 	mov    0xd8(%r9),%rcx
 18b9599:	48 c7 04 c1 00 00 00 00 	movq   $0x0,(%rcx,%rax,8)
 18b95a1:	48 8b 04 24          	mov    (%rsp),%rax
 18b95a5:	8b 80 e0 00 00 00    	mov    0xe0(%rax),%eax
 18b95ab:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
 18b95b0:	48 8b 0c 24          	mov    (%rsp),%rcx
 18b95b4:	8b b4 24 80 00 00 00 	mov    0x80(%rsp),%esi
 18b95bb:	01 d0                	add    %edx,%eax
 18b95bd:	89 81 e0 00 00 00    	mov    %eax,0xe0(%rcx)
 18b95c3:	48 8b 41 70          	mov    0x70(%rcx),%rax
 18b95c7:	42 89 34 b8          	mov    %esi,(%rax,%r15,4)
 18b95cb:	48 8b 41 78          	mov    0x78(%rcx),%rax
 18b95cf:	42 89 14 b8          	mov    %edx,(%rax,%r15,4)
 18b95d3:	0f b6 54 24 20       	movzbl 0x20(%rsp),%edx
 18b95d8:	48 8b 81 88 00 00 00 	mov    0x88(%rcx),%rax
 18b95df:	42 c6 04 38 00       	movb   $0x0,(%rax,%r15,1)
 18b95e4:	48 8b 81 90 00 00 00 	mov    0x90(%rcx),%rax
 18b95eb:	42 c6 04 38 00       	movb   $0x0,(%rax,%r15,1)
 18b95f0:	48 8b 81 98 00 00 00 	mov    0x98(%rcx),%rax
 18b95f7:	42 c6 04 38 00       	movb   $0x0,(%rax,%r15,1)
 18b95fc:	48 8b 41 10          	mov    0x10(%rcx),%rax
 18b9600:	42 08 14 20          	or     %dl,(%rax,%r12,1)
 18b9604:	4c 8b a9 08 01 00 00 	mov    0x108(%rcx),%r13
 18b960b:	4d 85 ed             	test   %r13,%r13
 18b960e:	0f 84 e4 00 00 00    	je     18b96f8 <tier0_tables_open+0x2228>
 18b9614:	41 80 7d 4c 00       	cmpb   $0x0,0x4c(%r13)
 18b9619:	0f 85 d9 00 00 00    	jne    18b96f8 <tier0_tables_open+0x2228>
 18b961f:	41 8b 45 08          	mov    0x8(%r13),%eax
 18b9623:	41 3b 45 0c          	cmp    0xc(%r13),%eax
 18b9627:	75 0a                	jne    18b9633 <tier0_tables_open+0x2163>
 18b9629:	41 c6 45 4c 01       	movb   $0x1,0x4c(%r13)
 18b962e:	e9 c5 00 00 00       	jmp    18b96f8 <tier0_tables_open+0x2228>
 18b9633:	41 8b 6d 28          	mov    0x28(%r13),%ebp
 18b9637:	41 8b 4d 2c          	mov    0x2c(%r13),%ecx
 18b963b:	29 e9                	sub    %ebp,%ecx
 18b963d:	39 4c 24 08          	cmp    %ecx,0x8(%rsp)
 18b9641:	41 0f 97 45 4c       	seta   0x4c(%r13)
 18b9646:	0f 87 ac 00 00 00    	ja     18b96f8 <tier0_tables_open+0x2228>
 18b964c:	c4 c1 7b 10 45 30    	vmovsd 0x30(%r13),%xmm0
 18b9652:	41 ff 45 34          	incl   0x34(%r13)
 18b9656:	83 7c 24 08 00       	cmpl   $0x0,0x8(%rsp)
 18b965b:	c5 f8 29 84 24 80 00 00 00 	vmovaps %xmm0,0x80(%rsp)
 18b9664:	74 2e                	je     18b9694 <tier0_tables_open+0x21c4>
 18b9666:	48 8b 5c 24 08       	mov    0x8(%rsp),%rbx
 18b966b:	48 89 ef             	mov    %rbp,%rdi
 18b966e:	48 c1 e7 04          	shl    $0x4,%rdi
 18b9672:	49 03 7d 20          	add    0x20(%r13),%rdi
 18b9676:	48 8d b4 24 b0 01 00 00 	lea    0x1b0(%rsp),%rsi
 18b967e:	48 89 da             	mov    %rbx,%rdx
 18b9681:	48 c1 e2 04          	shl    $0x4,%rdx
 18b9685:	e8 c6 ad ea fe       	call   764450 <memcpy@plt>
 18b968a:	41 01 5d 28          	add    %ebx,0x28(%r13)
 18b968e:	41 8b 45 08          	mov    0x8(%r13),%eax
 18b9692:	eb 02                	jmp    18b9696 <tier0_tables_open+0x21c6>
 18b9694:	31 ed                	xor    %ebp,%ebp
 18b9696:	c5 f9 6f 84 24 80 00 00 00 	vmovdqa 0x80(%rsp),%xmm0
 18b969f:	8d 50 01             	lea    0x1(%rax),%edx
 18b96a2:	49 8b 4d 00          	mov    0x0(%r13),%rcx
 18b96a6:	8b 74 24 40          	mov    0x40(%rsp),%esi
 18b96aa:	89 c0                	mov    %eax,%eax
 18b96ac:	48 6b c0 38          	imul   $0x38,%rax,%rax
 18b96b0:	41 89 55 08          	mov    %edx,0x8(%r13)
 18b96b4:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
 18b96b9:	c5 f9 d6 04 01       	vmovq  %xmm0,(%rcx,%rax,1)
 18b96be:	c6 44 01 08 03       	movb   $0x3,0x8(%rcx,%rax,1)
 18b96c3:	48 c7 44 01 09 00 00 00 00 	movq   $0x0,0x9(%rcx,%rax,1)
 18b96cc:	48 c7 44 01 10 00 00 00 00 	movq   $0x0,0x10(%rcx,%rax,1)
 18b96d5:	89 6c 01 18          	mov    %ebp,0x18(%rcx,%rax,1)
 18b96d9:	89 54 01 1c          	mov    %edx,0x1c(%rcx,%rax,1)
 18b96dd:	89 74 01 20          	mov    %esi,0x20(%rcx,%rax,1)
 18b96e1:	48 c7 44 01 24 00 00 00 00 	movq   $0x0,0x24(%rcx,%rax,1)
 18b96ea:	44 89 7c 01 2c       	mov    %r15d,0x2c(%rcx,%rax,1)
 18b96ef:	48 c7 44 01 30 00 00 00 00 	movq   $0x0,0x30(%rcx,%rax,1)
 18b96f8:	48 8b 0c 24          	mov    (%rsp),%rcx
 18b96fc:	b8 0d 00 00 00       	mov    $0xd,%eax
 18b9701:	44 3b 61 48          	cmp    0x48(%rcx),%r12d
 18b9705:	0f 83 31 06 00 00    	jae    18b9d3c <tier0_tables_open+0x286c>
 18b970b:	48 8b 0c 24          	mov    (%rsp),%rcx
 18b970f:	48 8b 09             	mov    (%rcx),%rcx
 18b9712:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
 18b9717:	42 0f b6 0c 21       	movzbl (%rcx,%r12,1),%ecx
 18b971c:	84 c9                	test   %cl,%cl
 18b971e:	0f 84 18 06 00 00    	je     18b9d3c <tier0_tables_open+0x286c>
 18b9724:	80 e1 fe             	and    $0xfe,%cl
 18b9727:	80 f9 10             	cmp    $0x10,%cl
 18b972a:	0f 85 0c 06 00 00    	jne    18b9d3c <tier0_tables_open+0x286c>
 18b9730:	48 8b 0c 24          	mov    (%rsp),%rcx
 18b9734:	48 8b 49 10          	mov    0x10(%rcx),%rcx
 18b9738:	42 0f b6 0c 21       	movzbl (%rcx,%r12,1),%ecx
 18b973d:	80 e1 24             	and    $0x24,%cl
 18b9740:	80 f9 20             	cmp    $0x20,%cl
 18b9743:	0f 85 f3 05 00 00    	jne    18b9d3c <tier0_tables_open+0x286c>
 18b9749:	48 8b 3c 24          	mov    (%rsp),%rdi
 18b974d:	be ff ff ff ff       	mov    $0xffffffff,%esi
 18b9752:	bb 00 00 00 00       	mov    $0x0,%ebx
 18b9757:	48 8b 47 28          	mov    0x28(%rdi),%rax
 18b975b:	48 8b 8f 90 00 00 00 	mov    0x90(%rdi),%rcx
 18b9762:	46 8b 04 a0          	mov    (%rax,%r12,4),%r8d
 18b9766:	48 8b 47 38          	mov    0x38(%rdi),%rax
 18b976a:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
 18b976f:	48 8b 47 60          	mov    0x60(%rdi),%rax
 18b9773:	42 0f b6 0c 01       	movzbl (%rcx,%r8,1),%ecx
 18b9778:	4c 89 44 24 60       	mov    %r8,0x60(%rsp)
 18b977d:	42 8b 04 80          	mov    (%rax,%r8,4),%eax
 18b9781:	89 ca                	mov    %ecx,%edx
 18b9783:	01 f1                	add    %esi,%ecx
 18b9785:	c1 e8 03             	shr    $0x3,%eax
 18b9788:	84 d2                	test   %dl,%dl
 18b978a:	ba 08 00 00 00       	mov    $0x8,%edx
 18b978f:	c4 e2 f1 f7 ca       	shlx   %rcx,%rdx,%rcx
 18b9794:	48 0f 45 d9          	cmovne %rcx,%rbx
 18b9798:	48 8b 4f 78          	mov    0x78(%rdi),%rcx
 18b979c:	46 8b 0c 81          	mov    (%rcx,%r8,4),%r9d
 18b97a0:	48 8b 8f 98 00 00 00 	mov    0x98(%rdi),%rcx
 18b97a7:	42 0f b6 0c 01       	movzbl (%rcx,%r8,1),%ecx
 18b97ac:	4c 89 8c 24 d8 00 00 00 	mov    %r9,0xd8(%rsp)
 18b97b4:	89 ca                	mov    %ecx,%edx
 18b97b6:	01 f1                	add    %esi,%ecx
 18b97b8:	84 d2                	test   %dl,%dl
 18b97ba:	ba 01 00 00 00       	mov    $0x1,%edx
 18b97bf:	c4 e2 f1 f7 f2       	shlx   %rcx,%rdx,%rsi
 18b97c4:	48 0f 44 f2          	cmove  %rdx,%rsi
 18b97c8:	4d 85 c9             	test   %r9,%r9
 18b97cb:	0f 84 58 03 00 00    	je     18b9b29 <tier0_tables_open+0x2659>
 18b97d1:	48 8b 0c 24          	mov    (%rsp),%rcx
 18b97d5:	45 31 e4             	xor    %r12d,%r12d
 18b97d8:	45 31 db             	xor    %r11d,%r11d
 18b97db:	45 31 c9             	xor    %r9d,%r9d
 18b97de:	48 c7 84 24 80 00 00 00 00 00 00 00 	movq   $0x0,0x80(%rsp)
 18b97ea:	48 8b b9 b8 00 00 00 	mov    0xb8(%rcx),%rdi
 18b97f1:	4c 8b 41 20          	mov    0x20(%rcx),%r8
 18b97f5:	48 8b 51 18          	mov    0x18(%rcx),%rdx
 18b97f9:	48 89 7c 24 70       	mov    %rdi,0x70(%rsp)
 18b97fe:	48 8b b9 c0 00 00 00 	mov    0xc0(%rcx),%rdi
 18b9805:	4c 89 84 24 40 01 00 00 	mov    %r8,0x140(%rsp)
 18b980d:	4c 8b 81 c8 00 00 00 	mov    0xc8(%rcx),%r8
 18b9814:	48 89 54 24 38       	mov    %rdx,0x38(%rsp)
 18b9819:	48 8b 54 24 60       	mov    0x60(%rsp),%rdx
 18b981e:	48 89 bc 24 18 01 00 00 	mov    %rdi,0x118(%rsp)
 18b9826:	48 8b b9 b0 00 00 00 	mov    0xb0(%rcx),%rdi
 18b982d:	4c 89 84 24 d0 00 00 00 	mov    %r8,0xd0(%rsp)
 18b9835:	4c 8b 81 d0 00 00 00 	mov    0xd0(%rcx),%r8
 18b983c:	48 89 bc 24 10 01 00 00 	mov    %rdi,0x110(%rsp)
 18b9844:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
 18b9849:	4c 89 84 24 b8 00 00 00 	mov    %r8,0xb8(%rsp)
 18b9851:	4c 8b 81 d8 00 00 00 	mov    0xd8(%rcx),%r8
 18b9858:	0f b6 04 07          	movzbl (%rdi,%rax,1),%eax
 18b985c:	4c 89 84 24 48 01 00 00 	mov    %r8,0x148(%rsp)
 18b9864:	88 44 24 08          	mov    %al,0x8(%rsp)
 18b9868:	48 8b 81 88 00 00 00 	mov    0x88(%rcx),%rax
 18b986f:	48 8b 49 70          	mov    0x70(%rcx),%rcx
 18b9873:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
 18b9877:	88 44 24 48          	mov    %al,0x48(%rsp)
 18b987b:	8b 04 91             	mov    (%rcx,%rdx,4),%eax
 18b987e:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
 18b9883:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
 18b9888:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
 18b988d:	42 8d 2c 20          	lea    (%rax,%r12,1),%ebp
 18b9891:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
 18b9896:	8b 04 a8             	mov    (%rax,%rbp,4),%eax
 18b9899:	c1 e8 03             	shr    $0x3,%eax
 18b989c:	80 3c 01 0f          	cmpb   $0xf,(%rcx,%rax,1)
 18b98a0:	48 89 c1             	mov    %rax,%rcx
 18b98a3:	75 0e                	jne    18b98b3 <tier0_tables_open+0x23e3>
 18b98a5:	48 8b 8c 24 40 01 00 00 	mov    0x140(%rsp),%rcx
 18b98ad:	8b 0c 81             	mov    (%rcx,%rax,4),%ecx
 18b98b0:	c1 e9 03             	shr    $0x3,%ecx
 18b98b3:	48 8b 94 24 d0 00 00 00 	mov    0xd0(%rsp),%rdx
 18b98bb:	80 7c 24 48 00       	cmpb   $0x0,0x48(%rsp)
 18b98c0:	41 ba 08 00 00 00    	mov    $0x8,%r10d
 18b98c6:	0f b6 3c 2a          	movzbl (%rdx,%rbp,1),%edi
 18b98ca:	48 8b 94 24 b8 00 00 00 	mov    0xb8(%rsp),%rdx
 18b98d2:	41 0f 95 c5          	setne  %r13b
 18b98d6:	44 0f b6 04 2a       	movzbl (%rdx,%rbp,1),%r8d
 18b98db:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
 18b98e0:	48 8b 14 ca          	mov    (%rdx,%rcx,8),%rdx
 18b98e4:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
 18b98e9:	0f b6 04 01          	movzbl (%rcx,%rax,1),%eax
 18b98ed:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
 18b98f2:	48 c1 e2 03          	shl    $0x3,%rdx
 18b98f6:	40 84 ff             	test   %dil,%dil
 18b98f9:	8d 0c 39             	lea    (%rcx,%rdi,1),%ecx
 18b98fc:	c4 c2 f1 f7 fa       	shlx   %rcx,%r10,%rdi
 18b9901:	b9 00 00 00 00       	mov    $0x0,%ecx
 18b9906:	48 0f 45 cf          	cmovne %rdi,%rcx
 18b990a:	45 08 c5             	or     %r8b,%r13b
 18b990d:	c4 c2 f9 f7 c2       	shlx   %rax,%r10,%rax
 18b9912:	41 f6 c0 02          	test   $0x2,%r8b
 18b9916:	0f 85 89 00 00 00    	jne    18b99a5 <tier0_tables_open+0x24d5>
 18b991c:	48 39 c8             	cmp    %rcx,%rax
 18b991f:	48 0f 46 c1          	cmovbe %rcx,%rax
 18b9923:	48 83 f9 09          	cmp    $0x9,%rcx
 18b9927:	73 05                	jae    18b992e <tier0_tables_open+0x245e>
 18b9929:	b9 08 00 00 00       	mov    $0x8,%ecx
 18b992e:	48 85 db             	test   %rbx,%rbx
 18b9931:	74 10                	je     18b9943 <tier0_tables_open+0x2473>
 18b9933:	48 39 d8             	cmp    %rbx,%rax
 18b9936:	72 03                	jb     18b993b <tier0_tables_open+0x246b>
 18b9938:	48 89 d8             	mov    %rbx,%rax
 18b993b:	48 39 d9             	cmp    %rbx,%rcx
 18b993e:	72 03                	jb     18b9943 <tier0_tables_open+0x2473>
 18b9940:	48 89 d9             	mov    %rbx,%rcx
 18b9943:	44 0f b6 7c 24 08    	movzbl 0x8(%rsp),%r15d
 18b9949:	41 f6 c5 01          	test   $0x1,%r13b
 18b994d:	48 89 c7             	mov    %rax,%rdi
 18b9950:	49 8d 43 ff          	lea    -0x1(%r11),%rax
 18b9954:	48 0f 45 f9          	cmovne %rcx,%rdi
 18b9958:	48 c7 c1 ff ff ff ff 	mov    $0xffffffffffffffff,%rcx
 18b995f:	49 89 fa             	mov    %rdi,%r10
 18b9962:	41 80 ff 11          	cmp    $0x11,%r15b
 18b9966:	48 0f 44 c1          	cmove  %rcx,%rax
 18b996a:	49 f7 da             	neg    %r10
 18b996d:	48 01 f8             	add    %rdi,%rax
 18b9970:	49 21 c2             	and    %rax,%r10
 18b9973:	4c 89 d1             	mov    %r10,%rcx
 18b9976:	48 01 d1             	add    %rdx,%rcx
 18b9979:	41 0f 93 c0          	setae  %r8b
 18b997d:	0f 99 c0             	setns  %al
 18b9980:	44 20 c0             	and    %r8b,%al
 18b9983:	41 80 ff 11          	cmp    $0x11,%r15b
 18b9987:	0f 85 b2 00 00 00    	jne    18b9a3f <tier0_tables_open+0x256f>
 18b998d:	49 39 d3             	cmp    %rdx,%r11
 18b9990:	48 c7 84 24 80 00 00 00 00 00 00 00 	movq   $0x0,0x80(%rsp)
 18b999c:	4c 0f 46 da          	cmovbe %rdx,%r11
 18b99a0:	e9 1f 01 00 00       	jmp    18b9ac4 <tier0_tables_open+0x25f4>
 18b99a5:	48 8b bc 24 18 01 00 00 	mov    0x118(%rsp),%rdi
 18b99ad:	41 ba 00 00 00 00    	mov    $0x0,%r10d
 18b99b3:	41 bf 01 00 00 00    	mov    $0x1,%r15d
 18b99b9:	44 8b 04 af          	mov    (%rdi,%rbp,4),%r8d
 18b99bd:	4c 89 df             	mov    %r11,%rdi
 18b99c0:	48 2b bc 24 80 00 00 00 	sub    0x80(%rsp),%rdi
 18b99c8:	80 7c 24 08 11       	cmpb   $0x11,0x8(%rsp)
 18b99cd:	4c 0f 45 d7          	cmovne %rdi,%r10
 18b99d1:	45 85 c0             	test   %r8d,%r8d
 18b99d4:	48 89 c7             	mov    %rax,%rdi
 18b99d7:	49 0f 45 ff          	cmovne %r15,%rdi
 18b99db:	41 f6 c5 01          	test   $0x1,%r13b
 18b99df:	48 0f 44 f8          	cmove  %rax,%rdi
 18b99e3:	48 85 c9             	test   %rcx,%rcx
 18b99e6:	74 0e                	je     18b99f6 <tier0_tables_open+0x2526>
 18b99e8:	48 39 cf             	cmp    %rcx,%rdi
 18b99eb:	48 0f 46 f9          	cmovbe %rcx,%rdi
 18b99ef:	48 39 c8             	cmp    %rcx,%rax
 18b99f2:	48 0f 46 c1          	cmovbe %rcx,%rax
 18b99f6:	48 85 db             	test   %rbx,%rbx
 18b99f9:	74 19                	je     18b9a14 <tier0_tables_open+0x2544>
 18b99fb:	45 85 c0             	test   %r8d,%r8d
 18b99fe:	74 14                	je     18b9a14 <tier0_tables_open+0x2544>
 18b9a00:	41 f6 c5 01          	test   $0x1,%r13b
 18b9a04:	48 0f 45 f8          	cmovne %rax,%rdi
 18b9a08:	48 39 df             	cmp    %rbx,%rdi
 18b9a0b:	72 03                	jb     18b9a10 <tier0_tables_open+0x2540>
 18b9a0d:	48 89 df             	mov    %rbx,%rdi
 18b9a10:	b0 01                	mov    $0x1,%al
 18b9a12:	eb 3e                	jmp    18b9a52 <tier0_tables_open+0x2582>
 18b9a14:	4d 85 c0             	test   %r8,%r8
 18b9a17:	74 16                	je     18b9a2f <tier0_tables_open+0x255f>
 18b9a19:	b0 01                	mov    $0x1,%al
 18b9a1b:	48 85 db             	test   %rbx,%rbx
 18b9a1e:	75 32                	jne    18b9a52 <tier0_tables_open+0x2582>
 18b9a20:	48 8d 47 ff          	lea    -0x1(%rdi),%rax
 18b9a24:	4c 21 d0             	and    %r10,%rax
 18b9a27:	4c 01 c0             	add    %r8,%rax
 18b9a2a:	48 39 d0             	cmp    %rdx,%rax
 18b9a2d:	76 21                	jbe    18b9a50 <tier0_tables_open+0x2580>
 18b9a2f:	49 8d 44 3a ff       	lea    -0x1(%r10,%rdi,1),%rax
 18b9a34:	49 89 fa             	mov    %rdi,%r10
 18b9a37:	49 f7 da             	neg    %r10
 18b9a3a:	49 21 c2             	and    %rax,%r10
 18b9a3d:	eb 30                	jmp    18b9a6f <tier0_tables_open+0x259f>
 18b9a3f:	48 c7 84 24 80 00 00 00 00 00 00 00 	movq   $0x0,0x80(%rsp)
 18b9a4b:	49 89 cb             	mov    %rcx,%r11
 18b9a4e:	eb 74                	jmp    18b9ac4 <tier0_tables_open+0x25f4>
 18b9a50:	31 c0                	xor    %eax,%eax
 18b9a52:	48 39 d9             	cmp    %rbx,%rcx
 18b9a55:	0f 97 c2             	seta   %dl
 18b9a58:	48 85 c9             	test   %rcx,%rcx
 18b9a5b:	74 12                	je     18b9a6f <tier0_tables_open+0x259f>
 18b9a5d:	20 c2                	and    %al,%dl
 18b9a5f:	75 0e                	jne    18b9a6f <tier0_tables_open+0x259f>
 18b9a61:	49 8d 44 0a ff       	lea    -0x1(%r10,%rcx,1),%rax
 18b9a66:	48 f7 d9             	neg    %rcx
 18b9a69:	48 21 c1             	and    %rax,%rcx
 18b9a6c:	49 89 ca             	mov    %rcx,%r10
 18b9a6f:	48 8b 84 24 10 01 00 00 	mov    0x110(%rsp),%rax
 18b9a77:	83 3c a8 00          	cmpl   $0x0,(%rax,%rbp,4)
 18b9a7b:	b8 01 00 00 00       	mov    $0x1,%eax
 18b9a80:	48 0f 44 f8          	cmove  %rax,%rdi
 18b9a84:	80 7c 24 08 11       	cmpb   $0x11,0x8(%rsp)
 18b9a89:	75 1d                	jne    18b9aa8 <tier0_tables_open+0x25d8>
 18b9a8b:	49 83 c0 07          	add    $0x7,%r8
 18b9a8f:	48 b8 f8 ff ff ff 01 00 00 00 	movabs $0x1fffffff8,%rax
 18b9a99:	49 21 c0             	and    %rax,%r8
 18b9a9c:	4d 39 c3             	cmp    %r8,%r11
 18b9a9f:	77 03                	ja     18b9aa4 <tier0_tables_open+0x25d4>
 18b9aa1:	4d 89 c3             	mov    %r8,%r11
 18b9aa4:	b0 01                	mov    $0x1,%al
 18b9aa6:	eb 1c                	jmp    18b9ac4 <tier0_tables_open+0x25f4>
 18b9aa8:	4f 8d 5c 02 07       	lea    0x7(%r10,%r8,1),%r11
 18b9aad:	49 83 e3 f8          	and    $0xfffffffffffffff8,%r11
 18b9ab1:	4c 89 d9             	mov    %r11,%rcx
 18b9ab4:	4c 29 d1             	sub    %r10,%rcx
 18b9ab7:	4c 29 c1             	sub    %r8,%rcx
 18b9aba:	b0 01                	mov    $0x1,%al
 18b9abc:	48 89 8c 24 80 00 00 00 	mov    %rcx,0x80(%rsp)
 18b9ac4:	48 8b 8c 24 48 01 00 00 	mov    0x148(%rsp),%rcx
 18b9acc:	4d 39 d9             	cmp    %r11,%r9
 18b9acf:	4d 0f 46 cb          	cmovbe %r11,%r9
 18b9ad3:	48 c1 ef 03          	shr    $0x3,%rdi
 18b9ad7:	48 39 fe             	cmp    %rdi,%rsi
 18b9ada:	48 0f 46 f7          	cmovbe %rdi,%rsi
 18b9ade:	4d 85 db             	test   %r11,%r11
 18b9ae1:	4c 89 14 e9          	mov    %r10,(%rcx,%rbp,8)
 18b9ae5:	0f 99 c1             	setns  %cl
 18b9ae8:	20 c1                	and    %al,%cl
 18b9aea:	80 f9 01             	cmp    $0x1,%cl
 18b9aed:	75 11                	jne    18b9b00 <tier0_tables_open+0x2630>
 18b9aef:	49 ff c4             	inc    %r12
 18b9af2:	4c 3b a4 24 d8 00 00 00 	cmp    0xd8(%rsp),%r12
 18b9afa:	0f 82 83 fd ff ff    	jb     18b9883 <tier0_tables_open+0x23b3>
 18b9b00:	84 c9                	test   %cl,%cl
 18b9b02:	0f 84 2f 02 00 00    	je     18b9d37 <tier0_tables_open+0x2867>
 18b9b08:	48 8b 04 24          	mov    (%rsp),%rax
 18b9b0c:	49 ff c9             	dec    %r9
 18b9b0f:	48 8b 48 38          	mov    0x38(%rax),%rcx
 18b9b13:	48 8b 40 60          	mov    0x60(%rax),%rax
 18b9b17:	48 89 4c 24 40       	mov    %rcx,0x40(%rsp)
 18b9b1c:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
 18b9b21:	8b 04 88             	mov    (%rax,%rcx,4),%eax
 18b9b24:	c1 e8 03             	shr    $0x3,%eax
 18b9b27:	eb 07                	jmp    18b9b30 <tier0_tables_open+0x2660>
 18b9b29:	49 c7 c1 ff ff ff ff 	mov    $0xffffffffffffffff,%r9
 18b9b30:	48 8b 7c 24 40       	mov    0x40(%rsp),%rdi
 18b9b35:	31 c9                	xor    %ecx,%ecx
 18b9b37:	f3 48 0f bc ce       	tzcnt  %rsi,%rcx
 18b9b3c:	49 8d 14 f1          	lea    (%r9,%rsi,8),%rdx
 18b9b40:	48 c1 e6 03          	shl    $0x3,%rsi
 18b9b44:	48 f7 de             	neg    %rsi
 18b9b47:	48 21 d6             	and    %rdx,%rsi
 18b9b4a:	48 c1 ee 03          	shr    $0x3,%rsi
 18b9b4e:	48 89 34 c7          	mov    %rsi,(%rdi,%rax,8)
 18b9b52:	48 8b 3c 24          	mov    (%rsp),%rdi
 18b9b56:	48 8b 57 18          	mov    0x18(%rdi),%rdx
 18b9b5a:	88 0c 02             	mov    %cl,(%rdx,%rax,1)
 18b9b5d:	48 8b 54 24 60       	mov    0x60(%rsp),%rdx
 18b9b62:	48 8b 4f 10          	mov    0x10(%rdi),%rcx
 18b9b66:	80 0c 01 04          	orb    $0x4,(%rcx,%rax,1)
 18b9b6a:	8b 87 a8 00 00 00    	mov    0xa8(%rdi),%eax
 18b9b70:	ff c0                	inc    %eax
 18b9b72:	89 87 a8 00 00 00    	mov    %eax,0xa8(%rdi)
 18b9b78:	48 8b 8f 80 00 00 00 	mov    0x80(%rdi),%rcx
 18b9b7f:	89 04 91             	mov    %eax,(%rcx,%rdx,4)
 18b9b82:	48 8b 87 08 01 00 00 	mov    0x108(%rdi),%rax
 18b9b89:	48 85 c0             	test   %rax,%rax
 18b9b8c:	74 74                	je     18b9c02 <tier0_tables_open+0x2732>
 18b9b8e:	80 78 4c 00          	cmpb   $0x0,0x4c(%rax)
 18b9b92:	75 6e                	jne    18b9c02 <tier0_tables_open+0x2732>
 18b9b94:	8b 48 08             	mov    0x8(%rax),%ecx
 18b9b97:	3b 48 0c             	cmp    0xc(%rax),%ecx
 18b9b9a:	75 06                	jne    18b9ba2 <tier0_tables_open+0x26d2>
 18b9b9c:	c6 40 4c 01          	movb   $0x1,0x4c(%rax)
 18b9ba0:	eb 60                	jmp    18b9c02 <tier0_tables_open+0x2732>
 18b9ba2:	48 8b 14 24          	mov    (%rsp),%rdx
 18b9ba6:	4c 8b 44 24 60       	mov    0x60(%rsp),%r8
 18b9bab:	8d 71 01             	lea    0x1(%rcx),%esi
 18b9bae:	48 6b c9 38          	imul   $0x38,%rcx,%rcx
 18b9bb2:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 18b9bb6:	48 8b 52 60          	mov    0x60(%rdx),%rdx
 18b9bba:	42 8b 14 82          	mov    (%rdx,%r8,4),%edx
 18b9bbe:	c6 40 4c 00          	movb   $0x0,0x4c(%rax)
 18b9bc2:	89 70 08             	mov    %esi,0x8(%rax)
 18b9bc5:	48 8b 30             	mov    (%rax),%rsi
 18b9bc8:	48 8b 78 30          	mov    0x30(%rax),%rdi
 18b9bcc:	ff 40 34             	incl   0x34(%rax)
 18b9bcf:	48 89 3c 0e          	mov    %rdi,(%rsi,%rcx,1)
 18b9bd3:	c6 44 0e 08 04       	movb   $0x4,0x8(%rsi,%rcx,1)
 18b9bd8:	c5 fa 7f 44 0e 09    	vmovdqu %xmm0,0x9(%rsi,%rcx,1)
 18b9bde:	48 c7 44 0e 18 00 00 00 00 	movq   $0x0,0x18(%rsi,%rcx,1)
 18b9be7:	89 54 0e 20          	mov    %edx,0x20(%rsi,%rcx,1)
 18b9beb:	48 c7 44 0e 24 00 00 00 00 	movq   $0x0,0x24(%rsi,%rcx,1)
 18b9bf4:	44 89 44 0e 2c       	mov    %r8d,0x2c(%rsi,%rcx,1)
 18b9bf9:	48 c7 44 0e 30 00 00 00 00 	movq   $0x0,0x30(%rsi,%rcx,1)
 18b9c02:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
 18b9c07:	48 8b 0c 24          	mov    (%rsp),%rcx
 18b9c0b:	8b 40 68             	mov    0x68(%rax),%eax
 18b9c0e:	48 8b 11             	mov    (%rcx),%rdx
 18b9c11:	48 8b 49 38          	mov    0x38(%rcx),%rcx
 18b9c15:	c1 e8 03             	shr    $0x3,%eax
 18b9c18:	80 3c 02 0f          	cmpb   $0xf,(%rdx,%rax,1)
 18b9c1c:	48 89 c2             	mov    %rax,%rdx
 18b9c1f:	75 0e                	jne    18b9c2f <tier0_tables_open+0x275f>
 18b9c21:	48 8b 14 24          	mov    (%rsp),%rdx
 18b9c25:	48 8b 52 20          	mov    0x20(%rdx),%rdx
 18b9c29:	8b 14 82             	mov    (%rdx,%rax,4),%edx
 18b9c2c:	c1 ea 03             	shr    $0x3,%edx
 18b9c2f:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
 18b9c34:	8b 76 5c             	mov    0x5c(%rsi),%esi
 18b9c37:	48 39 34 d1          	cmp    %rsi,(%rcx,%rdx,8)
 18b9c3b:	0f 85 e7 00 00 00    	jne    18b9d28 <tier0_tables_open+0x2858>
 18b9c41:	48 8b 14 24          	mov    (%rsp),%rdx
 18b9c45:	48 8b 4a 18          	mov    0x18(%rdx),%rcx
 18b9c49:	0f b6 04 01          	movzbl (%rcx,%rax,1),%eax
 18b9c4d:	b9 01 00 00 00       	mov    $0x1,%ecx
 18b9c52:	c4 e2 79 f7 c1       	shlx   %eax,%ecx,%eax
 18b9c57:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
 18b9c5c:	8b 49 60             	mov    0x60(%rcx),%ecx
 18b9c5f:	ff 82 60 1f 00 00    	incl   0x1f60(%rdx)
 18b9c65:	48 83 7c 24 68 39    	cmpq   $0x39,0x68(%rsp)
 18b9c6b:	77 0d                	ja     18b9c7a <tier0_tables_open+0x27aa>
 18b9c6d:	48 ff 44 24 68       	incq   0x68(%rsp)
 18b9c72:	39 c8                	cmp    %ecx,%eax
 18b9c74:	0f 84 9f f1 ff ff    	je     18b8e19 <tier0_tables_open+0x1949>
 18b9c7a:	39 c8                	cmp    %ecx,%eax
 18b9c7c:	0f 85 7d ed ff ff    	jne    18b89ff <tier0_tables_open+0x152f>
 18b9c82:	64 4c 8b 24 25 10 ff ff ff 	mov    %fs:0xffffffffffffff10,%r12
 18b9c8b:	4d 85 e4             	test   %r12,%r12
 18b9c8e:	0f 84 d2 00 00 00    	je     18b9d66 <tier0_tables_open+0x2896>
 18b9c94:	64 48 8b 04 25 18 ff ff ff 	mov    %fs:0xffffffffffffff18,%rax
 18b9c9d:	48 89 84 24 58 01 00 00 	mov    %rax,0x158(%rsp)
 18b9ca5:	e9 81 01 00 00       	jmp    18b9e2b <tier0_tables_open+0x295b>
 18b9caa:	c5 f8 77             	vzeroupper
 18b9cad:	e8 2e 9e ea fe       	call   763ae0 <__stack_chk_fail@plt>
 18b9cb2:	48 8b 0c 24          	mov    (%rsp),%rcx
 18b9cb6:	48 8b 81 08 01 00 00 	mov    0x108(%rcx),%rax
 18b9cbd:	c7 81 00 01 00 00 01 00 00 00 	movl   $0x1,0x100(%rcx)
 18b9cc7:	48 85 c0             	test   %rax,%rax
 18b9cca:	74 16                	je     18b9ce2 <tier0_tables_open+0x2812>
 18b9ccc:	c6 40 3c 01          	movb   $0x1,0x3c(%rax)
 18b9cd0:	48 8b 48 30          	mov    0x30(%rax),%rcx
 18b9cd4:	48 89 48 40          	mov    %rcx,0x40(%rax)
 18b9cd8:	c7 40 48 01 00 00 00 	movl   $0x1,0x48(%rax)
 18b9cdf:	ff 40 34             	incl   0x34(%rax)
 18b9ce2:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
 18b9ce7:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%rax)
 18b9cee:	eb 38                	jmp    18b9d28 <tier0_tables_open+0x2858>
 18b9cf0:	41 ba 01 00 00 00    	mov    $0x1,%r10d
 18b9cf6:	eb 06                	jmp    18b9cfe <tier0_tables_open+0x282e>
 18b9cf8:	41 ba 0f 00 00 00    	mov    $0xf,%r10d
 18b9cfe:	48 8b 0c 24          	mov    (%rsp),%rcx
 18b9d02:	48 8b 81 08 01 00 00 	mov    0x108(%rcx),%rax
 18b9d09:	44 89 91 00 01 00 00 	mov    %r10d,0x100(%rcx)
 18b9d10:	48 85 c0             	test   %rax,%rax
 18b9d13:	74 13                	je     18b9d28 <tier0_tables_open+0x2858>
 18b9d15:	c6 40 3c 01          	movb   $0x1,0x3c(%rax)
 18b9d19:	48 8b 48 30          	mov    0x30(%rax),%rcx
 18b9d1d:	48 89 48 40          	mov    %rcx,0x40(%rax)
 18b9d21:	44 89 50 48          	mov    %r10d,0x48(%rax)
 18b9d25:	ff 40 34             	incl   0x34(%rax)
 18b9d28:	48 8b 04 24          	mov    (%rsp),%rax
 18b9d2c:	ff 80 60 1f 00 00    	incl   0x1f60(%rax)
 18b9d32:	e9 c8 ec ff ff       	jmp    18b89ff <tier0_tables_open+0x152f>
 18b9d37:	b8 05 00 00 00       	mov    $0x5,%eax
 18b9d3c:	48 8b 14 24          	mov    (%rsp),%rdx
 18b9d40:	48 8b 8a 08 01 00 00 	mov    0x108(%rdx),%rcx
 18b9d47:	89 82 00 01 00 00    	mov    %eax,0x100(%rdx)
 18b9d4d:	48 85 c9             	test   %rcx,%rcx
 18b9d50:	74 d6                	je     18b9d28 <tier0_tables_open+0x2858>
 18b9d52:	c6 41 3c 01          	movb   $0x1,0x3c(%rcx)
 18b9d56:	48 8b 51 30          	mov    0x30(%rcx),%rdx
 18b9d5a:	48 89 51 40          	mov    %rdx,0x40(%rcx)
 18b9d5e:	89 41 48             	mov    %eax,0x48(%rcx)
 18b9d61:	ff 41 34             	incl   0x34(%rcx)
 18b9d64:	eb c2                	jmp    18b9d28 <tier0_tables_open+0x2858>
 18b9d66:	49 bf 00 00 20 00 10 00 00 00 	movabs $0x1000200000,%r15
 18b9d70:	ba 03 00 00 00       	mov    $0x3,%edx
 18b9d75:	b9 22 40 00 00       	mov    $0x4022,%ecx
 18b9d7a:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
 18b9d80:	45 31 ed             	xor    %r13d,%r13d
 18b9d83:	31 ff                	xor    %edi,%edi
 18b9d85:	45 31 c9             	xor    %r9d,%r9d
 18b9d88:	4c 89 fe             	mov    %r15,%rsi
 18b9d8b:	e8 b0 a7 ea fe       	call   764540 <mmap@plt>
 18b9d90:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
 18b9d94:	74 5c                	je     18b9df2 <tier0_tables_open+0x2922>
 18b9d96:	4c 8d a0 ff ff 20 00 	lea    0x20ffff(%rax),%r12
 18b9d9d:	ba 0f 00 00 00       	mov    $0xf,%edx
 18b9da2:	48 89 c7             	mov    %rax,%rdi
 18b9da5:	49 81 e4 00 00 e0 ff 	and    $0xffffffffffe00000,%r12
 18b9dac:	4d 89 e5             	mov    %r12,%r13
 18b9daf:	49 29 c5             	sub    %rax,%r13
 18b9db2:	4c 89 ee             	mov    %r13,%rsi
 18b9db5:	49 8d ad 00 00 ff ff 	lea    -0x10000(%r13),%rbp
 18b9dbc:	e8 2f a7 ea fe       	call   7644f0 <madvise@plt>
 18b9dc1:	4c 89 fe             	mov    %r15,%rsi
 18b9dc4:	4c 29 ee             	sub    %r13,%rsi
 18b9dc7:	ba 0e 00 00 00       	mov    $0xe,%edx
 18b9dcc:	4c 89 e7             	mov    %r12,%rdi
 18b9dcf:	e8 1c a7 ea fe       	call   7644f0 <madvise@plt>
 18b9dd4:	49 81 c7 00 00 e0 ff 	add    $0xffffffffffe00000,%r15
 18b9ddb:	49 81 c4 00 00 ff ff 	add    $0xffffffffffff0000,%r12
 18b9de2:	4d 89 fd             	mov    %r15,%r13
 18b9de5:	eb 10                	jmp    18b9df7 <tier0_tables_open+0x2927>
 18b9de7:	41 ba 0c 00 00 00    	mov    $0xc,%r10d
 18b9ded:	e9 0c ff ff ff       	jmp    18b9cfe <tier0_tables_open+0x282e>
 18b9df2:	45 31 e4             	xor    %r12d,%r12d
 18b9df5:	31 ed                	xor    %ebp,%ebp
 18b9df7:	64 4c 89 24 25 10 ff ff ff 	mov    %r12,%fs:0xffffffffffffff10
 18b9e00:	64 48 c7 04 25 18 ff ff ff 00 00 00 00 	movq   $0x0,%fs:0xffffffffffffff18
 18b9e0d:	64 4c 89 2c 25 20 ff ff ff 	mov    %r13,%fs:0xffffffffffffff20
 18b9e16:	64 48 89 2c 25 28 ff ff ff 	mov    %rbp,%fs:0xffffffffffffff28
 18b9e1f:	48 c7 84 24 58 01 00 00 00 00 00 00 	movq   $0x0,0x158(%rsp)
 18b9e2b:	48 8b 04 24          	mov    (%rsp),%rax
 18b9e2f:	48 8b 8c 24 58 01 00 00 	mov    0x158(%rsp),%rcx
 18b9e37:	44 8b 68 48          	mov    0x48(%rax),%r13d
 18b9e3b:	4a 8d 04 21          	lea    (%rcx,%r12,1),%rax
 18b9e3f:	4a 8d 4c 21 03       	lea    0x3(%rcx,%r12,1),%rcx
 18b9e44:	48 83 e1 fc          	and    $0xfffffffffffffffc,%rcx
 18b9e48:	48 89 4c 24 48       	mov    %rcx,0x48(%rsp)
 18b9e4d:	48 39 c1             	cmp    %rax,%rcx
 18b9e50:	72 6f                	jb     18b9ec1 <tier0_tables_open+0x29f1>
 18b9e52:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
 18b9e57:	64 48 8b 0c 25 20 ff ff ff 	mov    %fs:0xffffffffffffff20,%rcx
 18b9e60:	4a 8d 04 ad 00 00 00 00 	lea    0x0(,%r13,4),%rax
 18b9e68:	4c 29 e2             	sub    %r12,%rdx
 18b9e6b:	48 89 ce             	mov    %rcx,%rsi
 18b9e6e:	48 29 d6             	sub    %rdx,%rsi
 18b9e71:	40 0f 92 c7          	setb   %dil
 18b9e75:	48 39 f0             	cmp    %rsi,%rax
 18b9e78:	40 0f 97 c6          	seta   %sil
 18b9e7c:	40 08 fe             	or     %dil,%sil
 18b9e7f:	75 40                	jne    18b9ec1 <tier0_tables_open+0x29f1>
 18b9e81:	48 01 c2             	add    %rax,%rdx
 18b9e84:	48 83 7c 24 48 00    	cmpq   $0x0,0x48(%rsp)
 18b9e8a:	64 48 89 14 25 18 ff ff ff 	mov    %rdx,%fs:0xffffffffffffff18
 18b9e93:	74 2c                	je     18b9ec1 <tier0_tables_open+0x29f1>
 18b9e95:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
 18b9e9a:	48 01 c2             	add    %rax,%rdx
 18b9e9d:	48 89 94 24 60 01 00 00 	mov    %rdx,0x160(%rsp)
 18b9ea5:	4c 29 e2             	sub    %r12,%rdx
 18b9ea8:	48 29 d1             	sub    %rdx,%rcx
 18b9eab:	40 0f 92 c6          	setb   %sil
 18b9eaf:	48 39 c8             	cmp    %rcx,%rax
 18b9eb2:	0f 97 c1             	seta   %cl
 18b9eb5:	40 08 f1             	or     %sil,%cl
 18b9eb8:	80 f9 01             	cmp    $0x1,%cl
 18b9ebb:	0f 85 f1 04 00 00    	jne    18ba3b2 <tier0_tables_open+0x2ee2>
 18b9ec1:	48 8b 04 24          	mov    (%rsp),%rax
 18b9ec5:	83 b8 c0 01 00 00 00 	cmpl   $0x0,0x1c0(%rax)
 18b9ecc:	0f 95 c0             	setne  %al
 18b9ecf:	89 44 24 18          	mov    %eax,0x18(%rsp)
 18b9ed3:	41 83 fd 02          	cmp    $0x2,%r13d
 18b9ed7:	0f 82 54 33 00 00    	jb     18bd231 <tier0_tables_open+0x5d61>
 18b9edd:	b8 01 00 00 00       	mov    $0x1,%eax
 18b9ee2:	49 83 fd 02          	cmp    $0x2,%r13
 18b9ee6:	0f 84 08 02 00 00    	je     18ba0f4 <tier0_tables_open+0x2c24>
 18b9eec:	49 8d 4d ff          	lea    -0x1(%r13),%rcx
 18b9ef0:	48 89 ca             	mov    %rcx,%rdx
 18b9ef3:	48 83 e2 fe          	and    $0xfffffffffffffffe,%rdx
 18b9ef7:	48 f7 da             	neg    %rdx
 18b9efa:	eb 1b                	jmp    18b9f17 <tier0_tables_open+0x2a47>
 18b9efc:	c7 44 24 18 00 00 00 00 	movl   $0x0,0x18(%rsp)
 18b9f04:	48 8d 74 02 02       	lea    0x2(%rdx,%rax,1),%rsi
 18b9f09:	48 83 c0 02          	add    $0x2,%rax
 18b9f0d:	48 83 fe 01          	cmp    $0x1,%rsi
 18b9f11:	0f 84 d4 01 00 00    	je     18ba0eb <tier0_tables_open+0x2c1b>
 18b9f17:	f6 44 24 18 01       	testb  $0x1,0x18(%rsp)
 18b9f1c:	74 09                	je     18b9f27 <tier0_tables_open+0x2a57>
 18b9f1e:	40 b6 01             	mov    $0x1,%sil
 18b9f21:	89 74 24 18          	mov    %esi,0x18(%rsp)
 18b9f25:	eb dd                	jmp    18b9f04 <tier0_tables_open+0x2a34>
 18b9f27:	48 8b 34 24          	mov    (%rsp),%rsi
 18b9f2b:	48 8b b6 88 01 00 00 	mov    0x188(%rsi),%rsi
 18b9f32:	f6 44 86 01 80       	testb  $0x80,0x1(%rsi,%rax,4)
 18b9f37:	0f 85 ae 00 00 00    	jne    18b9feb <tier0_tables_open+0x2b1b>
 18b9f3d:	48 8b 34 24          	mov    (%rsp),%rsi
 18b9f41:	89 c7                	mov    %eax,%edi
 18b9f43:	81 e7 ff ff ff 1f    	and    $0x1fffffff,%edi
 18b9f49:	48 8b 36             	mov    (%rsi),%rsi
 18b9f4c:	44 0f b6 0c 3e       	movzbl (%rsi,%rdi,1),%r9d
 18b9f51:	41 80 f9 0f          	cmp    $0xf,%r9b
 18b9f55:	75 14                	jne    18b9f6b <tier0_tables_open+0x2a9b>
 18b9f57:	4c 8b 04 24          	mov    (%rsp),%r8
 18b9f5b:	4d 8b 40 20          	mov    0x20(%r8),%r8
 18b9f5f:	41 8b 3c b8          	mov    (%r8,%rdi,4),%edi
 18b9f63:	c1 ef 03             	shr    $0x3,%edi
 18b9f66:	44 0f b6 0c 3e       	movzbl (%rsi,%rdi,1),%r9d
 18b9f6b:	45 0f b6 d1          	movzbl %r9b,%r10d
 18b9f6f:	45 31 c0             	xor    %r8d,%r8d
 18b9f72:	45 8d 5a f7          	lea    -0x9(%r10),%r11d
 18b9f76:	41 83 fb 03          	cmp    $0x3,%r11d
 18b9f7a:	72 72                	jb     18b9fee <tier0_tables_open+0x2b1e>
 18b9f7c:	45 85 d2             	test   %r10d,%r10d
 18b9f7f:	74 6d                	je     18b9fee <tier0_tables_open+0x2b1e>
 18b9f81:	41 83 fa 01          	cmp    $0x1,%r10d
 18b9f85:	74 1b                	je     18b9fa2 <tier0_tables_open+0x2ad2>
 18b9f87:	45 31 c0             	xor    %r8d,%r8d
 18b9f8a:	45 84 c9             	test   %r9b,%r9b
 18b9f8d:	74 5f                	je     18b9fee <tier0_tables_open+0x2b1e>
 18b9f8f:	4c 8b 0c 24          	mov    (%rsp),%r9
 18b9f93:	4d 8b 49 10          	mov    0x10(%r9),%r9
 18b9f97:	41 0f b6 3c 39       	movzbl (%r9,%rdi,1),%edi
 18b9f9c:	40 80 e7 04          	and    $0x4,%dil
 18b9fa0:	74 4c                	je     18b9fee <tier0_tables_open+0x2b1e>
 18b9fa2:	80 3c 06 0e          	cmpb   $0xe,(%rsi,%rax,1)
 18b9fa6:	0f 85 27 01 00 00    	jne    18ba0d3 <tier0_tables_open+0x2c03>
 18b9fac:	48 8b 3c 24          	mov    (%rsp),%rdi
 18b9fb0:	4c 8b 47 20          	mov    0x20(%rdi),%r8
 18b9fb4:	41 8b 3c 80          	mov    (%r8,%rax,4),%edi
 18b9fb8:	c1 ef 03             	shr    $0x3,%edi
 18b9fbb:	80 3c 3e 0f          	cmpb   $0xf,(%rsi,%rdi,1)
 18b9fbf:	75 07                	jne    18b9fc8 <tier0_tables_open+0x2af8>
 18b9fc1:	41 8b 3c b8          	mov    (%r8,%rdi,4),%edi
 18b9fc5:	c1 ef 03             	shr    $0x3,%edi
 18b9fc8:	48 8b 34 24          	mov    (%rsp),%rsi
 18b9fcc:	48 8b 76 38          	mov    0x38(%rsi),%rsi
 18b9fd0:	48 83 3c fe 00       	cmpq   $0x0,(%rsi,%rdi,8)
 18b9fd5:	41 0f 94 c0          	sete   %r8b
 18b9fd9:	40 b6 01             	mov    $0x1,%sil
 18b9fdc:	89 74 24 18          	mov    %esi,0x18(%rsp)
 18b9fe0:	45 84 c0             	test   %r8b,%r8b
 18b9fe3:	0f 85 1b ff ff ff    	jne    18b9f04 <tier0_tables_open+0x2a34>
 18b9fe9:	eb 13                	jmp    18b9ffe <tier0_tables_open+0x2b2e>
 18b9feb:	45 31 c0             	xor    %r8d,%r8d
 18b9fee:	40 b6 01             	mov    $0x1,%sil
 18b9ff1:	89 74 24 18          	mov    %esi,0x18(%rsp)
 18b9ff5:	45 84 c0             	test   %r8b,%r8b
 18b9ff8:	0f 85 06 ff ff ff    	jne    18b9f04 <tier0_tables_open+0x2a34>
 18b9ffe:	48 8b 34 24          	mov    (%rsp),%rsi
 18ba002:	48 8b b6 88 01 00 00 	mov    0x188(%rsi),%rsi
 18ba009:	f6 44 86 05 80       	testb  $0x80,0x5(%rsi,%rax,4)
 18ba00e:	0f 85 e8 fe ff ff    	jne    18b9efc <tier0_tables_open+0x2a2c>
 18ba014:	48 8b 34 24          	mov    (%rsp),%rsi
 18ba018:	48 8d 78 01          	lea    0x1(%rax),%rdi
 18ba01c:	81 e7 ff ff ff 1f    	and    $0x1fffffff,%edi
 18ba022:	48 8b 36             	mov    (%rsi),%rsi
 18ba025:	44 0f b6 04 3e       	movzbl (%rsi,%rdi,1),%r8d
 18ba02a:	41 80 f8 0f          	cmp    $0xf,%r8b
 18ba02e:	75 14                	jne    18ba044 <tier0_tables_open+0x2b74>
 18ba030:	4c 8b 04 24          	mov    (%rsp),%r8
 18ba034:	4d 8b 40 20          	mov    0x20(%r8),%r8
 18ba038:	41 8b 3c b8          	mov    (%r8,%rdi,4),%edi
 18ba03c:	c1 ef 03             	shr    $0x3,%edi
 18ba03f:	44 0f b6 04 3e       	movzbl (%rsi,%rdi,1),%r8d
 18ba044:	45 0f b6 c8          	movzbl %r8b,%r9d
 18ba048:	c7 44 24 18 00 00 00 00 	movl   $0x0,0x18(%rsp)
 18ba050:	45 8d 51 f7          	lea    -0x9(%r9),%r10d
 18ba054:	41 83 fa 03          	cmp    $0x3,%r10d
 18ba058:	0f 82 a6 fe ff ff    	jb     18b9f04 <tier0_tables_open+0x2a34>
 18ba05e:	45 85 c9             	test   %r9d,%r9d
 18ba061:	0f 84 9d fe ff ff    	je     18b9f04 <tier0_tables_open+0x2a34>
 18ba067:	41 83 f9 01          	cmp    $0x1,%r9d
 18ba06b:	74 28                	je     18ba095 <tier0_tables_open+0x2bc5>
 18ba06d:	c7 44 24 18 00 00 00 00 	movl   $0x0,0x18(%rsp)
 18ba075:	45 84 c0             	test   %r8b,%r8b
 18ba078:	0f 84 86 fe ff ff    	je     18b9f04 <tier0_tables_open+0x2a34>
 18ba07e:	4c 8b 04 24          	mov    (%rsp),%r8
 18ba082:	4d 8b 40 10          	mov    0x10(%r8),%r8
 18ba086:	41 0f b6 3c 38       	movzbl (%r8,%rdi,1),%edi
 18ba08b:	40 80 e7 04          	and    $0x4,%dil
 18ba08f:	0f 84 6f fe ff ff    	je     18b9f04 <tier0_tables_open+0x2a34>
 18ba095:	80 7c 06 01 0e       	cmpb   $0xe,0x1(%rsi,%rax,1)
 18ba09a:	0f 85 5c fe ff ff    	jne    18b9efc <tier0_tables_open+0x2a2c>
 18ba0a0:	48 8b 3c 24          	mov    (%rsp),%rdi
 18ba0a4:	4c 8b 47 20          	mov    0x20(%rdi),%r8
 18ba0a8:	41 8b 7c 80 04       	mov    0x4(%r8,%rax,4),%edi
 18ba0ad:	c1 ef 03             	shr    $0x3,%edi
 18ba0b0:	80 3c 3e 0f          	cmpb   $0xf,(%rsi,%rdi,1)
 18ba0b4:	75 07                	jne    18ba0bd <tier0_tables_open+0x2bed>
 18ba0b6:	41 8b 3c b8          	mov    (%r8,%rdi,4),%edi
 18ba0ba:	c1 ef 03             	shr    $0x3,%edi
 18ba0bd:	48 8b 34 24          	mov    (%rsp),%rsi
 18ba0c1:	48 8b 76 38          	mov    0x38(%rsi),%rsi
 18ba0c5:	48 83 3c fe 00       	cmpq   $0x0,(%rsi,%rdi,8)
 18ba0ca:	40 0f 94 c6          	sete   %sil
 18ba0ce:	e9 4e fe ff ff       	jmp    18b9f21 <tier0_tables_open+0x2a51>
 18ba0d3:	45 31 c0             	xor    %r8d,%r8d
 18ba0d6:	40 b6 01             	mov    $0x1,%sil
 18ba0d9:	89 74 24 18          	mov    %esi,0x18(%rsp)
 18ba0dd:	45 84 c0             	test   %r8b,%r8b
 18ba0e0:	0f 85 1e fe ff ff    	jne    18b9f04 <tier0_tables_open+0x2a34>
 18ba0e6:	e9 13 ff ff ff       	jmp    18b9ffe <tier0_tables_open+0x2b2e>
 18ba0eb:	f6 c1 01             	test   $0x1,%cl
 18ba0ee:	0f 84 c9 00 00 00    	je     18ba1bd <tier0_tables_open+0x2ced>
 18ba0f4:	80 7c 24 18 00       	cmpb   $0x0,0x18(%rsp)
 18ba0f9:	b1 01                	mov    $0x1,%cl
 18ba0fb:	89 4c 24 18          	mov    %ecx,0x18(%rsp)
 18ba0ff:	0f 85 b8 00 00 00    	jne    18ba1bd <tier0_tables_open+0x2ced>
 18ba105:	48 8b 0c 24          	mov    (%rsp),%rcx
 18ba109:	48 8b 89 88 01 00 00 	mov    0x188(%rcx),%rcx
 18ba110:	f6 44 81 01 80       	testb  $0x80,0x1(%rcx,%rax,4)
 18ba115:	0f 85 9a 00 00 00    	jne    18ba1b5 <tier0_tables_open+0x2ce5>
 18ba11b:	48 8b 0c 24          	mov    (%rsp),%rcx
 18ba11f:	89 c2                	mov    %eax,%edx
 18ba121:	81 e2 ff ff ff 1f    	and    $0x1fffffff,%edx
 18ba127:	48 8b 09             	mov    (%rcx),%rcx
 18ba12a:	0f b6 34 11          	movzbl (%rcx,%rdx,1),%esi
 18ba12e:	40 80 fe 0f          	cmp    $0xf,%sil
 18ba132:	75 12                	jne    18ba146 <tier0_tables_open+0x2c76>
 18ba134:	48 8b 34 24          	mov    (%rsp),%rsi
 18ba138:	48 8b 76 20          	mov    0x20(%rsi),%rsi
 18ba13c:	8b 14 96             	mov    (%rsi,%rdx,4),%edx
 18ba13f:	c1 ea 03             	shr    $0x3,%edx
 18ba142:	0f b6 34 11          	movzbl (%rcx,%rdx,1),%esi
 18ba146:	40 0f b6 fe          	movzbl %sil,%edi
 18ba14a:	c7 44 24 18 00 00 00 00 	movl   $0x0,0x18(%rsp)
 18ba152:	44 8d 47 f7          	lea    -0x9(%rdi),%r8d
 18ba156:	41 83 f8 03          	cmp    $0x3,%r8d
 18ba15a:	72 61                	jb     18ba1bd <tier0_tables_open+0x2ced>
 18ba15c:	85 ff                	test   %edi,%edi
 18ba15e:	74 5d                	je     18ba1bd <tier0_tables_open+0x2ced>
 18ba160:	83 ff 01             	cmp    $0x1,%edi
 18ba163:	74 1e                	je     18ba183 <tier0_tables_open+0x2cb3>
 18ba165:	c7 44 24 18 00 00 00 00 	movl   $0x0,0x18(%rsp)
 18ba16d:	40 84 f6             	test   %sil,%sil
 18ba170:	74 4b                	je     18ba1bd <tier0_tables_open+0x2ced>
 18ba172:	48 8b 34 24          	mov    (%rsp),%rsi
 18ba176:	48 8b 76 10          	mov    0x10(%rsi),%rsi
 18ba17a:	0f b6 14 16          	movzbl (%rsi,%rdx,1),%edx
 18ba17e:	80 e2 04             	and    $0x4,%dl
 18ba181:	74 3a                	je     18ba1bd <tier0_tables_open+0x2ced>
 18ba183:	80 3c 01 0e          	cmpb   $0xe,(%rcx,%rax,1)
 18ba187:	75 2c                	jne    18ba1b5 <tier0_tables_open+0x2ce5>
 18ba189:	48 8b 14 24          	mov    (%rsp),%rdx
 18ba18d:	48 8b 72 20          	mov    0x20(%rdx),%rsi
 18ba191:	48 8b 52 38          	mov    0x38(%rdx),%rdx
 18ba195:	8b 04 86             	mov    (%rsi,%rax,4),%eax
 18ba198:	c1 e8 03             	shr    $0x3,%eax
 18ba19b:	80 3c 01 0f          	cmpb   $0xf,(%rcx,%rax,1)
 18ba19f:	75 06                	jne    18ba1a7 <tier0_tables_open+0x2cd7>
 18ba1a1:	8b 04 86             	mov    (%rsi,%rax,4),%eax
 18ba1a4:	c1 e8 03             	shr    $0x3,%eax
 18ba1a7:	48 83 3c c2 00       	cmpq   $0x0,(%rdx,%rax,8)
 18ba1ac:	0f 94 c0             	sete   %al
 18ba1af:	89 44 24 18          	mov    %eax,0x18(%rsp)
 18ba1b3:	eb 08                	jmp    18ba1bd <tier0_tables_open+0x2ced>
 18ba1b5:	c7 44 24 18 00 00 00 00 	movl   $0x0,0x18(%rsp)
 18ba1bd:	bd 01 00 00 00       	mov    $0x1,%ebp
 18ba1c2:	45 31 ff             	xor    %r15d,%r15d
 18ba1c5:	48 8d 9c 24 b0 01 00 00 	lea    0x1b0(%rsp),%rbx
 18ba1cd:	41 bc 01 00 00 00    	mov    $0x1,%r12d
 18ba1d3:	eb 35                	jmp    18ba20a <tier0_tables_open+0x2d3a>
 18ba1d5:	48 8b 34 24          	mov    (%rsp),%rsi
 18ba1d9:	b9 01 00 00 00       	mov    $0x1,%ecx
 18ba1de:	4c 89 f7             	mov    %r14,%rdi
 18ba1e1:	48 89 da             	mov    %rbx,%rdx
 18ba1e4:	e8 97 43 01 00       	call   18ce580 <abi_classify_scalar>
 18ba1e9:	41 b7 01             	mov    $0x1,%r15b
 18ba1ec:	49 ff c4             	inc    %r12
 18ba1ef:	4d 39 ec             	cmp    %r13,%r12
 18ba1f2:	0f 95 c0             	setne  %al
 18ba1f5:	4c 0f 44 e5          	cmove  %rbp,%r12
 18ba1f9:	89 c1                	mov    %eax,%ecx
 18ba1fb:	44 08 f9             	or     %r15b,%cl
 18ba1fe:	41 20 c7             	and    %al,%r15b
 18ba201:	f6 c1 01             	test   $0x1,%cl
 18ba204:	0f 84 27 30 00 00    	je     18bd231 <tier0_tables_open+0x5d61>
 18ba20a:	48 8b 0c 24          	mov    (%rsp),%rcx
 18ba20e:	42 8d 04 e5 00 00 00 00 	lea    0x0(,%r12,8),%eax
 18ba216:	89 84 24 b0 01 00 00 	mov    %eax,0x1b0(%rsp)
 18ba21d:	48 8b 81 88 01 00 00 	mov    0x188(%rcx),%rax
 18ba224:	42 f6 44 a0 01 80    	testb  $0x80,0x1(%rax,%r12,4)
 18ba22a:	75 c0                	jne    18ba1ec <tier0_tables_open+0x2d1c>
 18ba22c:	48 8b 0c 24          	mov    (%rsp),%rcx
 18ba230:	44 89 e2             	mov    %r12d,%edx
 18ba233:	81 e2 ff ff ff 1f    	and    $0x1fffffff,%edx
 18ba239:	48 8b 09             	mov    (%rcx),%rcx
 18ba23c:	0f b6 34 11          	movzbl (%rcx,%rdx,1),%esi
 18ba240:	40 80 fe 0f          	cmp    $0xf,%sil
 18ba244:	75 12                	jne    18ba258 <tier0_tables_open+0x2d88>
 18ba246:	48 8b 34 24          	mov    (%rsp),%rsi
 18ba24a:	48 8b 76 20          	mov    0x20(%rsi),%rsi
 18ba24e:	8b 14 96             	mov    (%rsi,%rdx,4),%edx
 18ba251:	c1 ea 03             	shr    $0x3,%edx
 18ba254:	0f b6 34 11          	movzbl (%rcx,%rdx,1),%esi
 18ba258:	40 0f b6 fe          	movzbl %sil,%edi
 18ba25c:	44 8d 47 f7          	lea    -0x9(%rdi),%r8d
 18ba260:	41 83 f8 03          	cmp    $0x3,%r8d
 18ba264:	72 86                	jb     18ba1ec <tier0_tables_open+0x2d1c>
 18ba266:	85 ff                	test   %edi,%edi
 18ba268:	74 82                	je     18ba1ec <tier0_tables_open+0x2d1c>
 18ba26a:	83 ff 01             	cmp    $0x1,%edi
 18ba26d:	74 1e                	je     18ba28d <tier0_tables_open+0x2dbd>
 18ba26f:	40 84 f6             	test   %sil,%sil
 18ba272:	0f 84 74 ff ff ff    	je     18ba1ec <tier0_tables_open+0x2d1c>
 18ba278:	48 8b 34 24          	mov    (%rsp),%rsi
 18ba27c:	48 8b 76 10          	mov    0x10(%rsi),%rsi
 18ba280:	0f b6 14 16          	movzbl (%rsi,%rdx,1),%edx
 18ba284:	80 e2 04             	and    $0x4,%dl
 18ba287:	0f 84 5f ff ff ff    	je     18ba1ec <tier0_tables_open+0x2d1c>
 18ba28d:	42 0f b6 0c 21       	movzbl (%rcx,%r12,1),%ecx
 18ba292:	83 f9 0f             	cmp    $0xf,%ecx
 18ba295:	77 53                	ja     18ba2ea <tier0_tables_open+0x2e1a>
 18ba297:	ba 00 c1 00 00       	mov    $0xc100,%edx
 18ba29c:	0f a3 ca             	bt     %ecx,%edx
 18ba29f:	73 49                	jae    18ba2ea <tier0_tables_open+0x2e1a>
 18ba2a1:	48 8b 14 24          	mov    (%rsp),%rdx
 18ba2a5:	48 8b 52 20          	mov    0x20(%rdx),%rdx
 18ba2a9:	42 8b 14 a2          	mov    (%rdx,%r12,4),%edx
 18ba2ad:	89 d6                	mov    %edx,%esi
 18ba2af:	c1 ee 03             	shr    $0x3,%esi
 18ba2b2:	f6 44 b0 01 80       	testb  $0x80,0x1(%rax,%rsi,4)
 18ba2b7:	0f 84 2f ff ff ff    	je     18ba1ec <tier0_tables_open+0x2d1c>
 18ba2bd:	80 f9 08             	cmp    $0x8,%cl
 18ba2c0:	0f 85 0f ff ff ff    	jne    18ba1d5 <tier0_tables_open+0x2d05>
 18ba2c6:	48 8b 04 24          	mov    (%rsp),%rax
 18ba2ca:	48 8b 40 38          	mov    0x38(%rax),%rax
 18ba2ce:	4a 83 3c e0 00       	cmpq   $0x0,(%rax,%r12,8)
 18ba2d3:	0f 85 fc fe ff ff    	jne    18ba1d5 <tier0_tables_open+0x2d05>
 18ba2d9:	48 8b 34 24          	mov    (%rsp),%rsi
 18ba2dd:	4c 89 f7             	mov    %r14,%rdi
 18ba2e0:	e8 12 3c 0c 00       	call   197def7 <abi_wide_classified>
 18ba2e5:	e9 bb 00 00 00       	jmp    18ba3a5 <tier0_tables_open+0x2ed5>
 18ba2ea:	80 e1 fe             	and    $0xfe,%cl
 18ba2ed:	80 f9 10             	cmp    $0x10,%cl
 18ba2f0:	0f 85 df fe ff ff    	jne    18ba1d5 <tier0_tables_open+0x2d05>
 18ba2f6:	48 8b 0c 24          	mov    (%rsp),%rcx
 18ba2fa:	48 8b 49 38          	mov    0x38(%rcx),%rcx
 18ba2fe:	4a 8b 0c e1          	mov    (%rcx,%r12,8),%rcx
 18ba302:	48 83 f9 40          	cmp    $0x40,%rcx
 18ba306:	77 69                	ja     18ba371 <tier0_tables_open+0x2ea1>
 18ba308:	48 8b 14 24          	mov    (%rsp),%rdx
 18ba30c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
 18ba310:	42 f6 04 22 40       	testb  $0x40,(%rdx,%r12,1)
 18ba315:	75 5a                	jne    18ba371 <tier0_tables_open+0x2ea1>
 18ba317:	48 8b 3c 24          	mov    (%rsp),%rdi
 18ba31b:	48 8b 4f 28          	mov    0x28(%rdi),%rcx
 18ba31f:	48 8b 57 70          	mov    0x70(%rdi),%rdx
 18ba323:	48 8b 7f 78          	mov    0x78(%rdi),%rdi
 18ba327:	42 8b 34 a1          	mov    (%rcx,%r12,4),%esi
 18ba32b:	8b 0c b2             	mov    (%rdx,%rsi,4),%ecx
 18ba32e:	8b 34 b7             	mov    (%rdi,%rsi,4),%esi
 18ba331:	01 ce                	add    %ecx,%esi
 18ba333:	39 f1                	cmp    %esi,%ecx
 18ba335:	0f 83 9a fe ff ff    	jae    18ba1d5 <tier0_tables_open+0x2d05>
 18ba33b:	48 8b 14 24          	mov    (%rsp),%rdx
 18ba33f:	48 ff c1             	inc    %rcx
 18ba342:	89 f6                	mov    %esi,%esi
 18ba344:	48 8b 92 b8 00 00 00 	mov    0xb8(%rdx),%rdx
 18ba34b:	8b 7c 8a fc          	mov    -0x4(%rdx,%rcx,4),%edi
 18ba34f:	c1 ef 03             	shr    $0x3,%edi
 18ba352:	8b 3c b8             	mov    (%rax,%rdi,4),%edi
 18ba355:	66 85 ff             	test   %di,%di
 18ba358:	79 09                	jns    18ba363 <tier0_tables_open+0x2e93>
 18ba35a:	48 39 f1             	cmp    %rsi,%rcx
 18ba35d:	48 8d 49 01          	lea    0x1(%rcx),%rcx
 18ba361:	72 e8                	jb     18ba34b <tier0_tables_open+0x2e7b>
 18ba363:	66 85 ff             	test   %di,%di
 18ba366:	0f 88 69 fe ff ff    	js     18ba1d5 <tier0_tables_open+0x2d05>
 18ba36c:	e9 7b fe ff ff       	jmp    18ba1ec <tier0_tables_open+0x2d1c>
 18ba371:	80 7c 24 18 00       	cmpb   $0x0,0x18(%rsp)
 18ba376:	75 1e                	jne    18ba396 <tier0_tables_open+0x2ec6>
 18ba378:	48 85 c9             	test   %rcx,%rcx
 18ba37b:	0f 85 54 fe ff ff    	jne    18ba1d5 <tier0_tables_open+0x2d05>
 18ba381:	48 8b 04 24          	mov    (%rsp),%rax
 18ba385:	48 8b 40 10          	mov    0x10(%rax),%rax
 18ba389:	42 0f b6 04 20       	movzbl (%rax,%r12,1),%eax
 18ba38e:	24 40                	and    $0x40,%al
 18ba390:	0f 84 3f fe ff ff    	je     18ba1d5 <tier0_tables_open+0x2d05>
 18ba396:	48 8b 34 24          	mov    (%rsp),%rsi
 18ba39a:	4c 89 f7             	mov    %r14,%rdi
 18ba39d:	44 89 e2             	mov    %r12d,%edx
 18ba3a0:	e8 8d 3b 0c 00       	call   197df32 <abi_members_classified>
 18ba3a5:	84 c0                	test   %al,%al
 18ba3a7:	0f 85 28 fe ff ff    	jne    18ba1d5 <tier0_tables_open+0x2d05>
 18ba3ad:	e9 3a fe ff ff       	jmp    18ba1ec <tier0_tables_open+0x2d1c>
 18ba3b2:	48 01 c2             	add    %rax,%rdx
 18ba3b5:	48 8b 04 24          	mov    (%rsp),%rax
 18ba3b9:	64 48 89 14 25 18 ff ff ff 	mov    %rdx,%fs:0xffffffffffffff18
 18ba3c2:	83 b8 c0 01 00 00 00 	cmpl   $0x0,0x1c0(%rax)
 18ba3c9:	0f 95 c0             	setne  %al
 18ba3cc:	48 83 bc 24 60 01 00 00 00 	cmpq   $0x0,0x160(%rsp)
 18ba3d5:	89 44 24 18          	mov    %eax,0x18(%rsp)
 18ba3d9:	0f 84 f4 fa ff ff    	je     18b9ed3 <tier0_tables_open+0x2a03>
 18ba3df:	41 83 fd 02          	cmp    $0x2,%r13d
 18ba3e3:	0f 82 48 2e 00 00    	jb     18bd231 <tier0_tables_open+0x5d61>
 18ba3e9:	49 83 fd 02          	cmp    $0x2,%r13
 18ba3ed:	75 14                	jne    18ba403 <tier0_tables_open+0x2f33>
 18ba3ef:	31 c0                	xor    %eax,%eax
 18ba3f1:	b9 01 00 00 00       	mov    $0x1,%ecx
 18ba3f6:	c7 44 24 2c 00 00 00 00 	movl   $0x0,0x2c(%rsp)
 18ba3fe:	e9 81 01 00 00       	jmp    18ba584 <tier0_tables_open+0x30b4>
 18ba403:	49 ff cd             	dec    %r13
 18ba406:	b9 01 00 00 00       	mov    $0x1,%ecx
 18ba40b:	31 c0                	xor    %eax,%eax
 18ba40d:	c7 44 24 2c 00 00 00 00 	movl   $0x0,0x2c(%rsp)
 18ba415:	4c 89 ea             	mov    %r13,%rdx
 18ba418:	48 83 e2 fe          	and    $0xfffffffffffffffe,%rdx
 18ba41c:	48 f7 da             	neg    %rdx
 18ba41f:	eb 37                	jmp    18ba458 <tier0_tables_open+0x2f88>
 18ba421:	44 8b 54 24 2c       	mov    0x2c(%rsp),%r10d
 18ba426:	4c 8b 4c 24 48       	mov    0x48(%rsp),%r9
 18ba42b:	44 89 d7             	mov    %r10d,%edi
 18ba42e:	41 ff c2             	inc    %r10d
 18ba431:	41 83 f8 0e          	cmp    $0xe,%r8d
 18ba435:	41 89 34 b9          	mov    %esi,(%r9,%rdi,4)
 18ba439:	40 0f 94 c6          	sete   %sil
 18ba43d:	44 89 54 24 2c       	mov    %r10d,0x2c(%rsp)
 18ba442:	40 08 f0             	or     %sil,%al
 18ba445:	48 8d 74 0a 02       	lea    0x2(%rdx,%rcx,1),%rsi
 18ba44a:	48 83 c1 02          	add    $0x2,%rcx
 18ba44e:	48 83 fe 01          	cmp    $0x1,%rsi
 18ba452:	0f 84 22 01 00 00    	je     18ba57a <tier0_tables_open+0x30aa>
 18ba458:	48 8b 34 24          	mov    (%rsp),%rsi
 18ba45c:	48 8b b6 88 01 00 00 	mov    0x188(%rsi),%rsi
 18ba463:	f6 44 8e 01 80       	testb  $0x80,0x1(%rsi,%rcx,4)
 18ba468:	75 7e                	jne    18ba4e8 <tier0_tables_open+0x3018>
 18ba46a:	48 8b 3c 24          	mov    (%rsp),%rdi
 18ba46e:	89 ce                	mov    %ecx,%esi
 18ba470:	81 e6 ff ff ff 1f    	and    $0x1fffffff,%esi
 18ba476:	4c 8b 07             	mov    (%rdi),%r8
 18ba479:	41 0f b6 3c 30       	movzbl (%r8,%rsi,1),%edi
 18ba47e:	40 80 ff 0f          	cmp    $0xf,%dil
 18ba482:	75 13                	jne    18ba497 <tier0_tables_open+0x2fc7>
 18ba484:	48 8b 3c 24          	mov    (%rsp),%rdi
 18ba488:	48 8b 7f 20          	mov    0x20(%rdi),%rdi
 18ba48c:	8b 34 b7             	mov    (%rdi,%rsi,4),%esi
 18ba48f:	c1 ee 03             	shr    $0x3,%esi
 18ba492:	41 0f b6 3c 30       	movzbl (%r8,%rsi,1),%edi
 18ba497:	40 0f b6 ff          	movzbl %dil,%edi
 18ba49b:	44 8d 47 f7          	lea    -0x9(%rdi),%r8d
 18ba49f:	41 83 f8 03          	cmp    $0x3,%r8d
 18ba4a3:	72 43                	jb     18ba4e8 <tier0_tables_open+0x3018>
 18ba4a5:	85 ff                	test   %edi,%edi
 18ba4a7:	74 3f                	je     18ba4e8 <tier0_tables_open+0x3018>
 18ba4a9:	83 ff 01             	cmp    $0x1,%edi
 18ba4ac:	74 17                	je     18ba4c5 <tier0_tables_open+0x2ff5>
 18ba4ae:	85 ff                	test   %edi,%edi
 18ba4b0:	74 36                	je     18ba4e8 <tier0_tables_open+0x3018>
 18ba4b2:	4c 8b 04 24          	mov    (%rsp),%r8
 18ba4b6:	4d 8b 40 10          	mov    0x10(%r8),%r8
 18ba4ba:	41 0f b6 34 30       	movzbl (%r8,%rsi,1),%esi
 18ba4bf:	40 80 e6 04          	and    $0x4,%sil
 18ba4c3:	74 23                	je     18ba4e8 <tier0_tables_open+0x3018>
 18ba4c5:	44 8b 4c 24 2c       	mov    0x2c(%rsp),%r9d
 18ba4ca:	4c 8b 44 24 48       	mov    0x48(%rsp),%r8
 18ba4cf:	44 89 ce             	mov    %r9d,%esi
 18ba4d2:	41 ff c1             	inc    %r9d
 18ba4d5:	83 ff 0e             	cmp    $0xe,%edi
 18ba4d8:	41 89 0c b0          	mov    %ecx,(%r8,%rsi,4)
 18ba4dc:	40 0f 94 c6          	sete   %sil
 18ba4e0:	44 89 4c 24 2c       	mov    %r9d,0x2c(%rsp)
 18ba4e5:	40 08 f0             	or     %sil,%al
 18ba4e8:	48 8b 34 24          	mov    (%rsp),%rsi
 18ba4ec:	48 8b b6 88 01 00 00 	mov    0x188(%rsi),%rsi
 18ba4f3:	f6 44 8e 05 80       	testb  $0x80,0x5(%rsi,%rcx,4)
 18ba4f8:	0f 85 47 ff ff ff    	jne    18ba445 <tier0_tables_open+0x2f75>
 18ba4fe:	4c 8b 04 24          	mov    (%rsp),%r8
 18ba502:	48 8d 71 01          	lea    0x1(%rcx),%rsi
 18ba506:	89 f7                	mov    %esi,%edi
 18ba508:	81 e7 ff ff ff 1f    	and    $0x1fffffff,%edi
 18ba50e:	4d 8b 08             	mov    (%r8),%r9
 18ba511:	45 0f b6 04 39       	movzbl (%r9,%rdi,1),%r8d
 18ba516:	41 80 f8 0f          	cmp    $0xf,%r8b
 18ba51a:	75 14                	jne    18ba530 <tier0_tables_open+0x3060>
 18ba51c:	4c 8b 04 24          	mov    (%rsp),%r8
 18ba520:	4d 8b 40 20          	mov    0x20(%r8),%r8
 18ba524:	41 8b 3c b8          	mov    (%r8,%rdi,4),%edi
 18ba528:	c1 ef 03             	shr    $0x3,%edi
 18ba52b:	45 0f b6 04 39       	movzbl (%r9,%rdi,1),%r8d
 18ba530:	45 0f b6 c0          	movzbl %r8b,%r8d
 18ba534:	45 8d 48 f7          	lea    -0x9(%r8),%r9d
 18ba538:	41 83 f9 03          	cmp    $0x3,%r9d
 18ba53c:	0f 82 03 ff ff ff    	jb     18ba445 <tier0_tables_open+0x2f75>
 18ba542:	45 85 c0             	test   %r8d,%r8d
 18ba545:	0f 84 fa fe ff ff    	je     18ba445 <tier0_tables_open+0x2f75>
 18ba54b:	41 83 f8 01          	cmp    $0x1,%r8d
 18ba54f:	0f 84 cc fe ff ff    	je     18ba421 <tier0_tables_open+0x2f51>
 18ba555:	45 85 c0             	test   %r8d,%r8d
 18ba558:	0f 84 e7 fe ff ff    	je     18ba445 <tier0_tables_open+0x2f75>
 18ba55e:	4c 8b 0c 24          	mov    (%rsp),%r9
 18ba562:	4d 8b 49 10          	mov    0x10(%r9),%r9
 18ba566:	41 0f b6 3c 39       	movzbl (%r9,%rdi,1),%edi
 18ba56b:	40 80 e7 04          	and    $0x4,%dil
 18ba56f:	0f 85 ac fe ff ff    	jne    18ba421 <tier0_tables_open+0x2f51>
 18ba575:	e9 cb fe ff ff       	jmp    18ba445 <tier0_tables_open+0x2f75>
 18ba57a:	41 f6 c5 01          	test   $0x1,%r13b
 18ba57e:	0f 84 87 00 00 00    	je     18ba60b <tier0_tables_open+0x313b>
 18ba584:	48 8b 14 24          	mov    (%rsp),%rdx
 18ba588:	48 8b 92 88 01 00 00 	mov    0x188(%rdx),%rdx
 18ba58f:	f6 44 8a 01 80       	testb  $0x80,0x1(%rdx,%rcx,4)
 18ba594:	75 75                	jne    18ba60b <tier0_tables_open+0x313b>
 18ba596:	48 8b 34 24          	mov    (%rsp),%rsi
 18ba59a:	89 ca                	mov    %ecx,%edx
 18ba59c:	81 e2 ff ff ff 1f    	and    $0x1fffffff,%edx
 18ba5a2:	48 8b 3e             	mov    (%rsi),%rdi
 18ba5a5:	0f b6 34 17          	movzbl (%rdi,%rdx,1),%esi
 18ba5a9:	40 80 fe 0f          	cmp    $0xf,%sil
 18ba5ad:	75 12                	jne    18ba5c1 <tier0_tables_open+0x30f1>
 18ba5af:	48 8b 34 24          	mov    (%rsp),%rsi
 18ba5b3:	48 8b 76 20          	mov    0x20(%rsi),%rsi
 18ba5b7:	8b 14 96             	mov    (%rsi,%rdx,4),%edx
 18ba5ba:	c1 ea 03             	shr    $0x3,%edx
 18ba5bd:	0f b6 34 17          	movzbl (%rdi,%rdx,1),%esi
 18ba5c1:	40 0f b6 f6          	movzbl %sil,%esi
 18ba5c5:	8d 7e f7             	lea    -0x9(%rsi),%edi
 18ba5c8:	83 ff 03             	cmp    $0x3,%edi
 18ba5cb:	72 3e                	jb     18ba60b <tier0_tables_open+0x313b>
 18ba5cd:	85 f6                	test   %esi,%esi
 18ba5cf:	74 3a                	je     18ba60b <tier0_tables_open+0x313b>
 18ba5d1:	83 fe 01             	cmp    $0x1,%esi
 18ba5d4:	74 15                	je     18ba5eb <tier0_tables_open+0x311b>
 18ba5d6:	85 f6                	test   %esi,%esi
 18ba5d8:	74 31                	je     18ba60b <tier0_tables_open+0x313b>
 18ba5da:	48 8b 3c 24          	mov    (%rsp),%rdi
 18ba5de:	48 8b 7f 10          	mov    0x10(%rdi),%rdi
 18ba5e2:	0f b6 14 17          	movzbl (%rdi,%rdx,1),%edx
 18ba5e6:	80 e2 04             	and    $0x4,%dl
 18ba5e9:	74 20                	je     18ba60b <tier0_tables_open+0x313b>
 18ba5eb:	44 8b 44 24 2c       	mov    0x2c(%rsp),%r8d
 18ba5f0:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
 18ba5f5:	44 89 c2             	mov    %r8d,%edx
 18ba5f8:	41 ff c0             	inc    %r8d
 18ba5fb:	83 fe 0e             	cmp    $0xe,%esi
 18ba5fe:	89 0c 97             	mov    %ecx,(%rdi,%rdx,4)
 18ba601:	0f 94 c1             	sete   %cl
 18ba604:	44 89 44 24 2c       	mov    %r8d,0x2c(%rsp)
 18ba609:	08 c8                	or     %cl,%al
 18ba60b:	a8 01                	test   $0x1,%al
 18ba60d:	0f 84 dc 01 00 00    	je     18ba7ef <tier0_tables_open+0x331f>
 18ba613:	83 7c 24 2c 00       	cmpl   $0x0,0x2c(%rsp)
 18ba618:	0f 84 d1 01 00 00    	je     18ba7ef <tier0_tables_open+0x331f>
 18ba61e:	8b 4c 24 2c          	mov    0x2c(%rsp),%ecx
 18ba622:	89 ca                	mov    %ecx,%edx
 18ba624:	89 d0                	mov    %edx,%eax
 18ba626:	83 e0 03             	and    $0x3,%eax
 18ba629:	83 f9 04             	cmp    $0x4,%ecx
 18ba62c:	73 07                	jae    18ba635 <tier0_tables_open+0x3165>
 18ba62e:	31 c9                	xor    %ecx,%ecx
 18ba630:	e9 4c 01 00 00       	jmp    18ba781 <tier0_tables_open+0x32b1>
 18ba635:	83 e2 fc             	and    $0xfffffffc,%edx
 18ba638:	31 c9                	xor    %ecx,%ecx
 18ba63a:	eb 15                	jmp    18ba651 <tier0_tables_open+0x3181>
 18ba63c:	c7 44 24 18 00 00 00 00 	movl   $0x0,0x18(%rsp)
 18ba644:	48 83 c1 04          	add    $0x4,%rcx
 18ba648:	48 39 ca             	cmp    %rcx,%rdx
 18ba64b:	0f 84 2b 01 00 00    	je     18ba77c <tier0_tables_open+0x32ac>
 18ba651:	8b 74 24 18          	mov    0x18(%rsp),%esi
 18ba655:	40 f6 c6 01          	test   $0x1,%sil
 18ba659:	40 b6 01             	mov    $0x1,%sil
 18ba65c:	89 74 24 18          	mov    %esi,0x18(%rsp)
 18ba660:	75 e2                	jne    18ba644 <tier0_tables_open+0x3174>
 18ba662:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
 18ba667:	48 8b 3c 24          	mov    (%rsp),%rdi
 18ba66b:	8b 34 8e             	mov    (%rsi,%rcx,4),%esi
 18ba66e:	48 8b 3f             	mov    (%rdi),%rdi
 18ba671:	80 3c 37 0e          	cmpb   $0xe,(%rdi,%rsi,1)
 18ba675:	75 2b                	jne    18ba6a2 <tier0_tables_open+0x31d2>
 18ba677:	4c 8b 04 24          	mov    (%rsp),%r8
 18ba67b:	4d 8b 40 20          	mov    0x20(%r8),%r8
 18ba67f:	41 8b 34 b0          	mov    (%r8,%rsi,4),%esi
 18ba683:	c1 ee 03             	shr    $0x3,%esi
 18ba686:	80 3c 37 0f          	cmpb   $0xf,(%rdi,%rsi,1)
 18ba68a:	75 07                	jne    18ba693 <tier0_tables_open+0x31c3>
 18ba68c:	41 8b 34 b0          	mov    (%r8,%rsi,4),%esi
 18ba690:	c1 ee 03             	shr    $0x3,%esi
 18ba693:	48 8b 3c 24          	mov    (%rsp),%rdi
 18ba697:	48 8b 7f 38          	mov    0x38(%rdi),%rdi
 18ba69b:	48 83 3c f7 00       	cmpq   $0x0,(%rdi,%rsi,8)
 18ba6a0:	74 a2                	je     18ba644 <tier0_tables_open+0x3174>
 18ba6a2:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
 18ba6a7:	48 8b 3c 24          	mov    (%rsp),%rdi
 18ba6ab:	8b 74 8e 04          	mov    0x4(%rsi,%rcx,4),%esi
 18ba6af:	48 8b 3f             	mov    (%rdi),%rdi
 18ba6b2:	80 3c 37 0e          	cmpb   $0xe,(%rdi,%rsi,1)
 18ba6b6:	75 2f                	jne    18ba6e7 <tier0_tables_open+0x3217>
 18ba6b8:	4c 8b 04 24          	mov    (%rsp),%r8
 18ba6bc:	4d 8b 40 20          	mov    0x20(%r8),%r8
 18ba6c0:	41 8b 34 b0          	mov    (%r8,%rsi,4),%esi
 18ba6c4:	c1 ee 03             	shr    $0x3,%esi
 18ba6c7:	80 3c 37 0f          	cmpb   $0xf,(%rdi,%rsi,1)
 18ba6cb:	75 07                	jne    18ba6d4 <tier0_tables_open+0x3204>
 18ba6cd:	41 8b 34 b0          	mov    (%r8,%rsi,4),%esi
 18ba6d1:	c1 ee 03             	shr    $0x3,%esi
 18ba6d4:	48 8b 3c 24          	mov    (%rsp),%rdi
 18ba6d8:	48 8b 7f 38          	mov    0x38(%rdi),%rdi
 18ba6dc:	48 83 3c f7 00       	cmpq   $0x0,(%rdi,%rsi,8)
 18ba6e1:	0f 84 5d ff ff ff    	je     18ba644 <tier0_tables_open+0x3174>
 18ba6e7:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
 18ba6ec:	48 8b 3c 24          	mov    (%rsp),%rdi
 18ba6f0:	8b 74 8e 08          	mov    0x8(%rsi,%rcx,4),%esi
 18ba6f4:	48 8b 3f             	mov    (%rdi),%rdi
 18ba6f7:	80 3c 37 0e          	cmpb   $0xe,(%rdi,%rsi,1)
 18ba6fb:	75 2f                	jne    18ba72c <tier0_tables_open+0x325c>
 18ba6fd:	4c 8b 04 24          	mov    (%rsp),%r8
 18ba701:	4d 8b 40 20          	mov    0x20(%r8),%r8
 18ba705:	41 8b 34 b0          	mov    (%r8,%rsi,4),%esi
 18ba709:	c1 ee 03             	shr    $0x3,%esi
 18ba70c:	80 3c 37 0f          	cmpb   $0xf,(%rdi,%rsi,1)
 18ba710:	75 07                	jne    18ba719 <tier0_tables_open+0x3249>
 18ba712:	41 8b 34 b0          	mov    (%r8,%rsi,4),%esi
 18ba716:	c1 ee 03             	shr    $0x3,%esi
 18ba719:	48 8b 3c 24          	mov    (%rsp),%rdi
 18ba71d:	48 8b 7f 38          	mov    0x38(%rdi),%rdi
 18ba721:	48 83 3c f7 00       	cmpq   $0x0,(%rdi,%rsi,8)
 18ba726:	0f 84 18 ff ff ff    	je     18ba644 <tier0_tables_open+0x3174>
 18ba72c:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
 18ba731:	48 8b 3c 24          	mov    (%rsp),%rdi
 18ba735:	8b 74 8e 0c          	mov    0xc(%rsi,%rcx,4),%esi
 18ba739:	48 8b 3f             	mov    (%rdi),%rdi
 18ba73c:	80 3c 37 0e          	cmpb   $0xe,(%rdi,%rsi,1)
 18ba740:	0f 85 f6 fe ff ff    	jne    18ba63c <tier0_tables_open+0x316c>
 18ba746:	4c 8b 04 24          	mov    (%rsp),%r8
 18ba74a:	4d 8b 40 20          	mov    0x20(%r8),%r8
 18ba74e:	41 8b 34 b0          	mov    (%r8,%rsi,4),%esi
 18ba752:	c1 ee 03             	shr    $0x3,%esi
 18ba755:	80 3c 37 0f          	cmpb   $0xf,(%rdi,%rsi,1)
 18ba759:	75 07                	jne    18ba762 <tier0_tables_open+0x3292>
 18ba75b:	41 8b 34 b0          	mov    (%r8,%rsi,4),%esi
 18ba75f:	c1 ee 03             	shr    $0x3,%esi
 18ba762:	48 8b 3c 24          	mov    (%rsp),%rdi
 18ba766:	48 8b 7f 38          	mov    0x38(%rdi),%rdi
 18ba76a:	48 83 3c f7 00       	cmpq   $0x0,(%rdi,%rsi,8)
 18ba76f:	40 0f 94 c6          	sete   %sil
 18ba773:	89 74 24 18          	mov    %esi,0x18(%rsp)
 18ba777:	e9 c8 fe ff ff       	jmp    18ba644 <tier0_tables_open+0x3174>
 18ba77c:	48 85 c0             	test   %rax,%rax
 18ba77f:	74 6e                	je     18ba7ef <tier0_tables_open+0x331f>
 18ba781:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
 18ba786:	48 8d 0c 8a          	lea    (%rdx,%rcx,4),%rcx
 18ba78a:	31 d2                	xor    %edx,%edx
 18ba78c:	eb 10                	jmp    18ba79e <tier0_tables_open+0x32ce>
 18ba78e:	c7 44 24 18 00 00 00 00 	movl   $0x0,0x18(%rsp)
 18ba796:	48 ff c2             	inc    %rdx
 18ba799:	48 39 d0             	cmp    %rdx,%rax
 18ba79c:	74 51                	je     18ba7ef <tier0_tables_open+0x331f>
 18ba79e:	f6 44 24 18 01       	testb  $0x1,0x18(%rsp)
 18ba7a3:	40 b6 01             	mov    $0x1,%sil
 18ba7a6:	89 74 24 18          	mov    %esi,0x18(%rsp)
 18ba7aa:	75 ea                	jne    18ba796 <tier0_tables_open+0x32c6>
 18ba7ac:	48 8b 3c 24          	mov    (%rsp),%rdi
 18ba7b0:	8b 34 91             	mov    (%rcx,%rdx,4),%esi
 18ba7b3:	48 8b 3f             	mov    (%rdi),%rdi
 18ba7b6:	80 3c 37 0e          	cmpb   $0xe,(%rdi,%rsi,1)
 18ba7ba:	75 d2                	jne    18ba78e <tier0_tables_open+0x32be>
 18ba7bc:	4c 8b 04 24          	mov    (%rsp),%r8
 18ba7c0:	4d 8b 40 20          	mov    0x20(%r8),%r8
 18ba7c4:	41 8b 34 b0          	mov    (%r8,%rsi,4),%esi
 18ba7c8:	c1 ee 03             	shr    $0x3,%esi
 18ba7cb:	80 3c 37 0f          	cmpb   $0xf,(%rdi,%rsi,1)
 18ba7cf:	75 07                	jne    18ba7d8 <tier0_tables_open+0x3308>
 18ba7d1:	41 8b 34 b0          	mov    (%r8,%rsi,4),%esi
 18ba7d5:	c1 ee 03             	shr    $0x3,%esi
 18ba7d8:	48 8b 3c 24          	mov    (%rsp),%rdi
 18ba7dc:	48 8b 7f 38          	mov    0x38(%rdi),%rdi
 18ba7e0:	48 83 3c f7 00       	cmpq   $0x0,(%rdi,%rsi,8)
 18ba7e5:	40 0f 94 c6          	sete   %sil
 18ba7e9:	89 74 24 18          	mov    %esi,0x18(%rsp)
 18ba7ed:	eb a7                	jmp    18ba796 <tier0_tables_open+0x32c6>
 18ba7ef:	83 7c 24 2c 00       	cmpl   $0x0,0x2c(%rsp)
 18ba7f4:	0f 84 37 2a 00 00    	je     18bd231 <tier0_tables_open+0x5d61>
 18ba7fa:	44 8b 7c 24 2c       	mov    0x2c(%rsp),%r15d
 18ba7ff:	45 31 e4             	xor    %r12d,%r12d
 18ba802:	c7 44 24 2c 00 00 00 00 	movl   $0x0,0x2c(%rsp)
 18ba80a:	c7 84 24 a0 00 00 00 00 00 00 00 	movl   $0x0,0xa0(%rsp)
 18ba815:	eb 35                	jmp    18ba84c <tier0_tables_open+0x337c>
 18ba817:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
 18ba81c:	8b b4 24 a0 00 00 00 	mov    0xa0(%rsp),%esi
 18ba823:	48 8b 94 24 60 01 00 00 	mov    0x160(%rsp),%rdx
 18ba82b:	42 8b 04 a0          	mov    (%rax,%r12,4),%eax
 18ba82f:	89 f1                	mov    %esi,%ecx
 18ba831:	ff c6                	inc    %esi
 18ba833:	89 b4 24 a0 00 00 00 	mov    %esi,0xa0(%rsp)
 18ba83a:	c1 e0 03             	shl    $0x3,%eax
 18ba83d:	89 04 8a             	mov    %eax,(%rdx,%rcx,4)
 18ba840:	49 ff c4             	inc    %r12
 18ba843:	4d 39 fc             	cmp    %r15,%r12
 18ba846:	0f 84 64 01 00 00    	je     18ba9b0 <tier0_tables_open+0x34e0>
 18ba84c:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
 18ba851:	48 8b 34 24          	mov    (%rsp),%rsi
 18ba855:	42 8b 14 a0          	mov    (%rax,%r12,4),%edx
 18ba859:	48 8b 06             	mov    (%rsi),%rax
 18ba85c:	0f b6 0c 10          	movzbl (%rax,%rdx,1),%ecx
 18ba860:	83 f9 0f             	cmp    $0xf,%ecx
 18ba863:	77 7f                	ja     18ba8e4 <tier0_tables_open+0x3414>
 18ba865:	b8 00 c1 00 00       	mov    $0xc100,%eax
 18ba86a:	0f a3 c8             	bt     %ecx,%eax
 18ba86d:	73 75                	jae    18ba8e4 <tier0_tables_open+0x3414>
 18ba86f:	48 8b 34 24          	mov    (%rsp),%rsi
 18ba873:	48 8b 46 20          	mov    0x20(%rsi),%rax
 18ba877:	48 8b b6 88 01 00 00 	mov    0x188(%rsi),%rsi
 18ba87e:	8b 04 90             	mov    (%rax,%rdx,4),%eax
 18ba881:	89 c7                	mov    %eax,%edi
 18ba883:	c1 ef 03             	shr    $0x3,%edi
 18ba886:	f6 44 be 01 80       	testb  $0x80,0x1(%rsi,%rdi,4)
 18ba88b:	75 25                	jne    18ba8b2 <tier0_tables_open+0x33e2>
 18ba88d:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
 18ba892:	8b 74 24 2c          	mov    0x2c(%rsp),%esi
 18ba896:	42 8b 04 a2          	mov    (%rdx,%r12,4),%eax
 18ba89a:	89 f1                	mov    %esi,%ecx
 18ba89c:	ff c6                	inc    %esi
 18ba89e:	89 74 24 2c          	mov    %esi,0x2c(%rsp)
 18ba8a2:	89 04 8a             	mov    %eax,(%rdx,%rcx,4)
 18ba8a5:	49 ff c4             	inc    %r12
 18ba8a8:	4d 39 fc             	cmp    %r15,%r12
 18ba8ab:	75 9f                	jne    18ba84c <tier0_tables_open+0x337c>
 18ba8ad:	e9 fe 00 00 00       	jmp    18ba9b0 <tier0_tables_open+0x34e0>
 18ba8b2:	80 f9 08             	cmp    $0x8,%cl
 18ba8b5:	0f 85 5c ff ff ff    	jne    18ba817 <tier0_tables_open+0x3347>
 18ba8bb:	48 8b 0c 24          	mov    (%rsp),%rcx
 18ba8bf:	48 8b 49 38          	mov    0x38(%rcx),%rcx
 18ba8c3:	48 83 3c d1 00       	cmpq   $0x0,(%rcx,%rdx,8)
 18ba8c8:	0f 85 49 ff ff ff    	jne    18ba817 <tier0_tables_open+0x3347>
 18ba8ce:	48 8b 34 24          	mov    (%rsp),%rsi
 18ba8d2:	4c 89 f7             	mov    %r14,%rdi
 18ba8d5:	89 c2                	mov    %eax,%edx
 18ba8d7:	c5 f8 77             	vzeroupper
 18ba8da:	e8 18 36 0c 00       	call   197def7 <abi_wide_classified>
 18ba8df:	e9 bf 00 00 00       	jmp    18ba9a3 <tier0_tables_open+0x34d3>
 18ba8e4:	80 e1 fe             	and    $0xfe,%cl
 18ba8e7:	80 f9 10             	cmp    $0x10,%cl
 18ba8ea:	0f 85 27 ff ff ff    	jne    18ba817 <tier0_tables_open+0x3347>
 18ba8f0:	48 8b 04 24          	mov    (%rsp),%rax
 18ba8f4:	48 8b 40 38          	mov    0x38(%rax),%rax
 18ba8f8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
 18ba8fc:	48 83 f8 40          	cmp    $0x40,%rax
 18ba900:	77 6e                	ja     18ba970 <tier0_tables_open+0x34a0>
 18ba902:	48 8b 0c 24          	mov    (%rsp),%rcx
 18ba906:	48 8b 49 10          	mov    0x10(%rcx),%rcx
 18ba90a:	f6 04 11 40          	testb  $0x40,(%rcx,%rdx,1)
 18ba90e:	75 60                	jne    18ba970 <tier0_tables_open+0x34a0>
 18ba910:	48 8b 34 24          	mov    (%rsp),%rsi
 18ba914:	48 8b 46 28          	mov    0x28(%rsi),%rax
 18ba918:	48 8b 4e 70          	mov    0x70(%rsi),%rcx
 18ba91c:	48 8b 7e 78          	mov    0x78(%rsi),%rdi
 18ba920:	8b 14 90             	mov    (%rax,%rdx,4),%edx
 18ba923:	8b 04 91             	mov    (%rcx,%rdx,4),%eax
 18ba926:	8b 34 97             	mov    (%rdi,%rdx,4),%esi
 18ba929:	01 c6                	add    %eax,%esi
 18ba92b:	39 f0                	cmp    %esi,%eax
 18ba92d:	0f 83 e4 fe ff ff    	jae    18ba817 <tier0_tables_open+0x3347>
 18ba933:	48 8b 14 24          	mov    (%rsp),%rdx
 18ba937:	48 ff c0             	inc    %rax
 18ba93a:	89 f6                	mov    %esi,%esi
 18ba93c:	48 8b 8a b8 00 00 00 	mov    0xb8(%rdx),%rcx
 18ba943:	48 8b 92 88 01 00 00 	mov    0x188(%rdx),%rdx
 18ba94a:	8b 7c 81 fc          	mov    -0x4(%rcx,%rax,4),%edi
 18ba94e:	c1 ef 03             	shr    $0x3,%edi
 18ba951:	8b 3c ba             	mov    (%rdx,%rdi,4),%edi
 18ba954:	66 85 ff             	test   %di,%di
 18ba957:	79 09                	jns    18ba962 <tier0_tables_open+0x3492>
 18ba959:	48 39 f0             	cmp    %rsi,%rax
 18ba95c:	48 8d 40 01          	lea    0x1(%rax),%rax
 18ba960:	72 e8                	jb     18ba94a <tier0_tables_open+0x347a>
 18ba962:	66 85 ff             	test   %di,%di
 18ba965:	0f 88 ac fe ff ff    	js     18ba817 <tier0_tables_open+0x3347>
 18ba96b:	e9 1d ff ff ff       	jmp    18ba88d <tier0_tables_open+0x33bd>
 18ba970:	80 7c 24 18 00       	cmpb   $0x0,0x18(%rsp)
 18ba975:	75 1d                	jne    18ba994 <tier0_tables_open+0x34c4>
 18ba977:	48 85 c0             	test   %rax,%rax
 18ba97a:	0f 85 97 fe ff ff    	jne    18ba817 <tier0_tables_open+0x3347>
 18ba980:	48 8b 04 24          	mov    (%rsp),%rax
 18ba984:	48 8b 40 10          	mov    0x10(%rax),%rax
 18ba988:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
 18ba98c:	24 40                	and    $0x40,%al
 18ba98e:	0f 84 83 fe ff ff    	je     18ba817 <tier0_tables_open+0x3347>
 18ba994:	48 8b 34 24          	mov    (%rsp),%rsi
 18ba998:	4c 89 f7             	mov    %r14,%rdi
 18ba99b:	c5 f8 77             	vzeroupper
 18ba99e:	e8 8f 35 0c 00       	call   197df32 <abi_members_classified>
 18ba9a3:	84 c0                	test   %al,%al
 18ba9a5:	0f 85 6c fe ff ff    	jne    18ba817 <tier0_tables_open+0x3347>
 18ba9ab:	e9 dd fe ff ff       	jmp    18ba88d <tier0_tables_open+0x33bd>
 18ba9b0:	64 4c 8b 24 25 10 ff ff ff 	mov    %fs:0xffffffffffffff10,%r12
 18ba9b9:	4d 85 e4             	test   %r12,%r12
 18ba9bc:	74 16                	je     18ba9d4 <tier0_tables_open+0x3504>
 18ba9be:	64 48 8b 04 25 18 ff ff ff 	mov    %fs:0xffffffffffffff18,%rax
 18ba9c7:	48 89 84 24 c0 00 00 00 	mov    %rax,0xc0(%rsp)
 18ba9cf:	e9 c1 00 00 00       	jmp    18baa95 <tier0_tables_open+0x35c5>
 18ba9d4:	48 be 00 00 20 00 10 00 00 00 	movabs $0x1000200000,%rsi
 18ba9de:	ba 03 00 00 00       	mov    $0x3,%edx
 18ba9e3:	b9 22 40 00 00       	mov    $0x4022,%ecx
 18ba9e8:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
 18ba9ee:	31 ff                	xor    %edi,%edi
 18ba9f0:	45 31 c9             	xor    %r9d,%r9d
 18ba9f3:	c5 f8 77             	vzeroupper
 18ba9f6:	e8 45 9b ea fe       	call   764540 <mmap@plt>
 18ba9fb:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
 18ba9ff:	74 58                	je     18baa59 <tier0_tables_open+0x3589>
 18baa01:	4c 8d a0 ff ff 20 00 	lea    0x20ffff(%rax),%r12
 18baa08:	ba 0f 00 00 00       	mov    $0xf,%edx
 18baa0d:	48 89 c7             	mov    %rax,%rdi
 18baa10:	49 81 e4 00 00 e0 ff 	and    $0xffffffffffe00000,%r12
 18baa17:	4d 89 e5             	mov    %r12,%r13
 18baa1a:	49 29 c5             	sub    %rax,%r13
 18baa1d:	4c 89 ee             	mov    %r13,%rsi
 18baa20:	4d 8d bd 00 00 ff ff 	lea    -0x10000(%r13),%r15
 18baa27:	e8 c4 9a ea fe       	call   7644f0 <madvise@plt>
 18baa2c:	48 bd 00 00 20 00 10 00 00 00 	movabs $0x1000200000,%rbp
 18baa36:	ba 0e 00 00 00       	mov    $0xe,%edx
 18baa3b:	4c 89 e7             	mov    %r12,%rdi
 18baa3e:	48 89 ee             	mov    %rbp,%rsi
 18baa41:	4c 29 ee             	sub    %r13,%rsi
 18baa44:	e8 a7 9a ea fe       	call   7644f0 <madvise@plt>
 18baa49:	49 81 c4 00 00 ff ff 	add    $0xffffffffffff0000,%r12
 18baa50:	48 8d 85 00 00 e0 ff 	lea    -0x200000(%rbp),%rax
 18baa57:	eb 08                	jmp    18baa61 <tier0_tables_open+0x3591>
 18baa59:	45 31 e4             	xor    %r12d,%r12d
 18baa5c:	31 c0                	xor    %eax,%eax
 18baa5e:	45 31 ff             	xor    %r15d,%r15d
 18baa61:	64 4c 89 24 25 10 ff ff ff 	mov    %r12,%fs:0xffffffffffffff10
 18baa6a:	64 48 c7 04 25 18 ff ff ff 00 00 00 00 	movq   $0x0,%fs:0xffffffffffffff18
 18baa77:	64 48 89 04 25 20 ff ff ff 	mov    %rax,%fs:0xffffffffffffff20
 18baa80:	64 4c 89 3c 25 28 ff ff ff 	mov    %r15,%fs:0xffffffffffffff28
 18baa89:	48 c7 84 24 c0 00 00 00 00 00 00 00 	movq   $0x0,0xc0(%rsp)
 18baa95:	48 8b 8c 24 c0 00 00 00 	mov    0xc0(%rsp),%rcx
 18baa9d:	4e 8d 7c 21 03       	lea    0x3(%rcx,%r12,1),%r15
 18baaa2:	4a 8d 04 21          	lea    (%rcx,%r12,1),%rax
 18baaa6:	49 83 e7 fc          	and    $0xfffffffffffffffc,%r15
 18baaaa:	49 39 c7             	cmp    %rax,%r15
 18baaad:	73 0f                	jae    18baabe <tier0_tables_open+0x35ee>
 18baaaf:	48 8b 84 24 c0 00 00 00 	mov    0xc0(%rsp),%rax
 18baab7:	31 c9                	xor    %ecx,%ecx
 18baab9:	e9 1d 27 00 00       	jmp    18bd1db <tier0_tables_open+0x5d0b>
 18baabe:	64 48 8b 34 25 20 ff ff ff 	mov    %fs:0xffffffffffffff20,%rsi
 18baac7:	4c 89 fa             	mov    %r15,%rdx
 18baaca:	4c 29 e2             	sub    %r12,%rdx
 18baacd:	31 c9                	xor    %ecx,%ecx
 18baacf:	48 29 d6             	sub    %rdx,%rsi
 18baad2:	0f 82 5f 04 00 00    	jb     18baf37 <tier0_tables_open+0x3a67>
 18baad8:	8b ac 24 a0 00 00 00 	mov    0xa0(%rsp),%ebp
 18baadf:	48 8d 04 ad 00 00 00 00 	lea    0x0(,%rbp,4),%rax
 18baae7:	48 8d 3c 40          	lea    (%rax,%rax,2),%rdi
 18baaeb:	48 8b 84 24 c0 00 00 00 	mov    0xc0(%rsp),%rax
 18baaf3:	48 39 f7             	cmp    %rsi,%rdi
 18baaf6:	0f 87 df 26 00 00    	ja     18bd1db <tier0_tables_open+0x5d0b>
 18baafc:	48 01 fa             	add    %rdi,%rdx
 18baaff:	83 bc 24 a0 00 00 00 00 	cmpl   $0x0,0xa0(%rsp)
 18bab07:	64 48 89 14 25 18 ff ff ff 	mov    %rdx,%fs:0xffffffffffffff18
 18bab10:	0f 84 2e 04 00 00    	je     18baf44 <tier0_tables_open+0x3a74>
 18bab16:	4d 85 ff             	test   %r15,%r15
 18bab19:	0f 84 25 04 00 00    	je     18baf44 <tier0_tables_open+0x3a74>
 18bab1f:	31 db                	xor    %ebx,%ebx
 18bab21:	45 31 e4             	xor    %r12d,%r12d
 18bab24:	e9 ac 00 00 00       	jmp    18babd5 <tier0_tables_open+0x3705>
 18bab29:	4c 8b 0c 24          	mov    (%rsp),%r9
 18bab2d:	42 8d 0c ad 00 00 00 00 	lea    0x0(,%r13,4),%ecx
 18bab35:	4c 89 ef             	mov    %r13,%rdi
 18bab38:	48 c1 e7 04          	shl    $0x4,%rdi
 18bab3c:	49 8b 41 20          	mov    0x20(%r9),%rax
 18bab40:	49 8b 91 80 01 00 00 	mov    0x180(%r9),%rdx
 18bab47:	8b 04 08             	mov    (%rax,%rcx,1),%eax
 18bab4a:	89 c6                	mov    %eax,%esi
 18bab4c:	c1 ee 03             	shr    $0x3,%esi
 18bab4f:	83 e0 f8             	and    $0xfffffff8,%eax
 18bab52:	49 89 f0             	mov    %rsi,%r8
 18bab55:	49 c1 e0 04          	shl    $0x4,%r8
 18bab59:	c4 a1 7a 6f 04 02    	vmovdqu (%rdx,%r8,1),%xmm0
 18bab5f:	c5 fa 7f 04 3a       	vmovdqu %xmm0,(%rdx,%rdi,1)
 18bab64:	89 f7                	mov    %esi,%edi
 18bab66:	c1 e7 02             	shl    $0x2,%edi
 18bab69:	49 8b 91 88 01 00 00 	mov    0x188(%r9),%rdx
 18bab70:	44 8b 04 3a          	mov    (%rdx,%rdi,1),%r8d
 18bab74:	44 89 04 0a          	mov    %r8d,(%rdx,%rcx,1)
 18bab78:	49 8b 91 90 01 00 00 	mov    0x190(%r9),%rdx
 18bab7f:	8b 3c 3a             	mov    (%rdx,%rdi,1),%edi
 18bab82:	89 3c 0a             	mov    %edi,(%rdx,%rcx,1)
 18bab85:	49 8b 89 98 01 00 00 	mov    0x198(%r9),%rcx
 18bab8c:	0f b6 14 31          	movzbl (%rcx,%rsi,1),%edx
 18bab90:	42 88 14 29          	mov    %dl,(%rcx,%r13,1)
 18bab94:	49 8b 89 a0 01 00 00 	mov    0x1a0(%r9),%rcx
 18bab9b:	0f b6 14 31          	movzbl (%rcx,%rsi,1),%edx
 18bab9f:	42 8d 34 ed 00 00 00 00 	lea    0x0(,%r13,8),%esi
 18baba7:	42 88 14 29          	mov    %dl,(%rcx,%r13,1)
 18babab:	49 8b 89 a8 01 00 00 	mov    0x1a8(%r9),%rcx
 18babb2:	48 8b 14 01          	mov    (%rcx,%rax,1),%rdx
 18babb6:	48 89 14 31          	mov    %rdx,(%rcx,%rsi,1)
 18babba:	49 8b 89 b0 01 00 00 	mov    0x1b0(%r9),%rcx
 18babc1:	48 8b 04 01          	mov    (%rcx,%rax,1),%rax
 18babc5:	48 89 04 31          	mov    %rax,(%rcx,%rsi,1)
 18babc9:	49 ff c4             	inc    %r12
 18babcc:	4c 39 e5             	cmp    %r12,%rbp
 18babcf:	0f 84 8a 03 00 00    	je     18baf5f <tier0_tables_open+0x3a8f>
 18babd5:	48 8b 84 24 60 01 00 00 	mov    0x160(%rsp),%rax
 18babdd:	48 8b 0c 24          	mov    (%rsp),%rcx
 18babe1:	42 8b 04 a0          	mov    (%rax,%r12,4),%eax
 18babe5:	48 8b 31             	mov    (%rcx),%rsi
 18babe8:	41 89 c5             	mov    %eax,%r13d
 18babeb:	41 c1 ed 03          	shr    $0x3,%r13d
 18babef:	42 0f b6 0c 2e       	movzbl (%rsi,%r13,1),%ecx
 18babf4:	80 f9 0f             	cmp    $0xf,%cl
 18babf7:	0f 84 2c ff ff ff    	je     18bab29 <tier0_tables_open+0x3659>
 18babfd:	48 8b 14 24          	mov    (%rsp),%rdx
 18bac01:	83 e0 f8             	and    $0xfffffff8,%eax
 18bac04:	89 cf                	mov    %ecx,%edi
 18bac06:	40 80 e7 fe          	and    $0xfe,%dil
 18bac0a:	48 8b 52 38          	mov    0x38(%rdx),%rdx
 18bac0e:	48 8b 04 02          	mov    (%rdx,%rax,1),%rax
 18bac12:	40 80 ff 10          	cmp    $0x10,%dil
 18bac16:	0f 85 b8 00 00 00    	jne    18bacd4 <tier0_tables_open+0x3804>
 18bac1c:	48 8b 14 24          	mov    (%rsp),%rdx
 18bac20:	48 8b 52 10          	mov    0x10(%rdx),%rdx
 18bac24:	42 f6 04 2a 40       	testb  $0x40,(%rdx,%r13,1)
 18bac29:	0f 85 fe 00 00 00    	jne    18bad2d <tier0_tables_open+0x385d>
 18bac2f:	48 83 f8 40          	cmp    $0x40,%rax
 18bac33:	0f 87 f4 00 00 00    	ja     18bad2d <tier0_tables_open+0x385d>
 18bac39:	48 83 f8 11          	cmp    $0x11,%rax
 18bac3d:	72 13                	jb     18bac52 <tier0_tables_open+0x3782>
 18bac3f:	48 8b 14 24          	mov    (%rsp),%rdx
 18bac43:	8b 92 bc 01 00 00    	mov    0x1bc(%rdx),%edx
 18bac49:	48 39 d0             	cmp    %rdx,%rax
 18bac4c:	0f 87 db 00 00 00    	ja     18bad2d <tier0_tables_open+0x385d>
 18bac52:	48 8b 34 24          	mov    (%rsp),%rsi
 18bac56:	80 f9 10             	cmp    $0x10,%cl
 18bac59:	89 df                	mov    %ebx,%edi
 18bac5b:	48 8d 3c 7f          	lea    (%rdi,%rdi,2),%rdi
 18bac5f:	0f 94 c1             	sete   %cl
 18bac62:	48 8b 56 28          	mov    0x28(%rsi),%rdx
 18bac66:	48 8b 76 78          	mov    0x78(%rsi),%rsi
 18bac6a:	42 8b 14 aa          	mov    (%rdx,%r13,4),%edx
 18bac6e:	8b 14 96             	mov    (%rsi,%rdx,4),%edx
 18bac71:	81 fa 00 00 40 00    	cmp    $0x400000,%edx
 18bac77:	40 0f 92 c6          	setb   %sil
 18bac7b:	40 08 ce             	or     %cl,%sil
 18bac7e:	48 83 f8 11          	cmp    $0x11,%rax
 18bac82:	0f 92 c1             	setb   %cl
 18bac85:	41 0f 93 44 bf 0a    	setae  0xa(%r15,%rdi,4)
 18bac8b:	45 89 2c bf          	mov    %r13d,(%r15,%rdi,4)
 18bac8f:	41 89 54 bf 04       	mov    %edx,0x4(%r15,%rdi,4)
 18bac94:	40 20 f1             	and    %sil,%cl
 18bac97:	be 10 00 00 00       	mov    $0x10,%esi
 18bac9c:	48 29 c6             	sub    %rax,%rsi
 18bac9f:	b8 00 00 00 00       	mov    $0x0,%eax
 18baca4:	48 0f 43 c6          	cmovae %rsi,%rax
 18baca8:	ff c3                	inc    %ebx
 18bacaa:	62 f2 7d 08 7a c0    	vpbroadcastb %eax,%xmm0
 18bacb0:	62 f3 7d 08 3e 05 55 af cb fe 01 	vpcmpltub -0x13450ab(%rip),%xmm0,%k0        # 575c10 <x86_effects_unknown+0x1b0>
 18bacbb:	c5 fb 93 c0          	kmovd  %k0,%eax
 18bacbf:	25 fe ff 00 00       	and    $0xfffe,%eax
 18bacc4:	66 41 89 44 bf 08    	mov    %ax,0x8(%r15,%rdi,4)
 18bacca:	41 88 4c bf 0b       	mov    %cl,0xb(%r15,%rdi,4)
 18baccf:	e9 f5 fe ff ff       	jmp    18babc9 <tier0_tables_open+0x36f9>
 18bacd4:	80 f9 08             	cmp    $0x8,%cl
 18bacd7:	75 74                	jne    18bad4d <tier0_tables_open+0x387d>
 18bacd9:	48 8b 0c 24          	mov    (%rsp),%rcx
 18bacdd:	48 8b 79 20          	mov    0x20(%rcx),%rdi
 18bace1:	42 8b 0c af          	mov    (%rdi,%r13,4),%ecx
 18bace5:	c1 e9 03             	shr    $0x3,%ecx
 18bace8:	80 3c 0e 0f          	cmpb   $0xf,(%rsi,%rcx,1)
 18bacec:	48 89 ce             	mov    %rcx,%rsi
 18bacef:	75 06                	jne    18bacf7 <tier0_tables_open+0x3827>
 18bacf1:	8b 34 8f             	mov    (%rdi,%rcx,4),%esi
 18bacf4:	c1 ee 03             	shr    $0x3,%esi
 18bacf7:	48 8b 3c 24          	mov    (%rsp),%rdi
 18bacfb:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
 18bad01:	48 8b 7f 18          	mov    0x18(%rdi),%rdi
 18bad05:	0f b6 3c 0f          	movzbl (%rdi,%rcx,1),%edi
 18bad09:	40 80 ff 07          	cmp    $0x7,%dil
 18bad0d:	c4 c2 41 f7 f8       	shlx   %edi,%r8d,%edi
 18bad12:	41 b8 7f 00 00 00    	mov    $0x7f,%r8d
 18bad18:	40 f6 d7             	not    %dil
 18bad1b:	40 0f b6 ff          	movzbl %dil,%edi
 18bad1f:	41 0f 43 f8          	cmovae %r8d,%edi
 18bad23:	48 83 f8 41          	cmp    $0x41,%rax
 18bad27:	0f 82 a9 00 00 00    	jb     18badd6 <tier0_tables_open+0x3906>
 18bad2d:	48 8b 34 24          	mov    (%rsp),%rsi
 18bad31:	c4 e2 79 59 05 be 53 cc fe 	vpbroadcastq -0x133ac42(%rip),%xmm0        # 5800f8 <x86_semantics_benchmark_code.registers+0x108>
 18bad3a:	4c 89 e9             	mov    %r13,%rcx
 18bad3d:	48 c1 e1 04          	shl    $0x4,%rcx
 18bad41:	48 8b 86 80 01 00 00 	mov    0x180(%rsi),%rax
 18bad48:	e9 34 01 00 00       	jmp    18bae81 <tier0_tables_open+0x39b1>
 18bad4d:	48 8b 34 24          	mov    (%rsp),%rsi
 18bad51:	4c 89 f7             	mov    %r14,%rdi
 18bad54:	44 89 ea             	mov    %r13d,%edx
 18bad57:	c5 f8 77             	vzeroupper
 18bad5a:	e8 81 0e 01 00       	call   18cbbe0 <abi_simple>
 18bad5f:	89 c6                	mov    %eax,%esi
 18bad61:	c1 ee 10             	shr    $0x10,%esi
 18bad64:	48 89 c1             	mov    %rax,%rcx
 18bad67:	48 c1 e9 08          	shr    $0x8,%rcx
 18bad6b:	41 b8 77 00 00 00    	mov    $0x77,%r8d
 18bad71:	89 f7                	mov    %esi,%edi
 18bad73:	40 c0 e7 04          	shl    $0x4,%dil
 18bad77:	40 08 cf             	or     %cl,%dil
 18bad7a:	40 80 fe 07          	cmp    $0x7,%sil
 18bad7e:	40 0f b6 f7          	movzbl %dil,%esi
 18bad82:	41 0f 44 f0          	cmove  %r8d,%esi
 18bad86:	80 f9 07             	cmp    $0x7,%cl
 18bad89:	41 0f 44 f0          	cmove  %r8d,%esi
 18bad8d:	3c 01                	cmp    $0x1,%al
 18bad8f:	0f 85 97 00 00 00    	jne    18bae2c <tier0_tables_open+0x395c>
 18bad95:	c1 e8 18             	shr    $0x18,%eax
 18bad98:	62 f2 7d 08 7a c0    	vpbroadcastb %eax,%xmm0
 18bad9e:	c5 f9 fc 05 6a ae cb fe 	vpaddb -0x1345196(%rip),%xmm0,%xmm0        # 575c10 <x86_effects_unknown+0x1b0>
 18bada6:	89 c8                	mov    %ecx,%eax
 18bada8:	62 f3 7d 08 3e 0d 6d ae cb fe 06 	vpcmpnleub -0x1345193(%rip),%xmm0,%k1        # 575c20 <x86_effects_unknown+0x1c0>
 18badb3:	0c 60                	or     $0x60,%al
 18badb5:	62 f2 7d 08 7a c0    	vpbroadcastb %eax,%xmm0
 18badbb:	89 c8                	mov    %ecx,%eax
 18badbd:	c1 e0 04             	shl    $0x4,%eax
 18badc0:	09 c1                	or     %eax,%ecx
 18badc2:	0c 06                	or     $0x6,%al
 18badc4:	62 f2 7d 08 7a c8    	vpbroadcastb %eax,%xmm1
 18badca:	62 f2 7d 09 7a c1    	vpbroadcastb %ecx,%xmm0{%k1}
 18badd0:	c5 f9 6c c1          	vpunpcklqdq %xmm1,%xmm0,%xmm0
 18badd4:	eb 5c                	jmp    18bae32 <tier0_tables_open+0x3962>
 18badd6:	62 f2 7d 08 7a c7    	vpbroadcastb %edi,%xmm0
 18baddc:	c5 f9 db 05 2c ae cb fe 	vpand  -0x13451d4(%rip),%xmm0,%xmm0        # 575c10 <x86_effects_unknown+0x1b0>
 18bade4:	48 8b 34 f2          	mov    (%rdx,%rsi,8),%rsi
 18bade8:	62 f2 7e 08 26 c8    	vptestnmb %xmm0,%xmm0,%k1
 18badee:	48 83 f8 11          	cmp    $0x11,%rax
 18badf2:	0f 82 a1 00 00 00    	jb     18bae99 <tier0_tables_open+0x39c9>
 18badf8:	48 39 f0             	cmp    %rsi,%rax
 18badfb:	75 13                	jne    18bae10 <tier0_tables_open+0x3940>
 18badfd:	48 8b 0c 24          	mov    (%rsp),%rcx
 18bae01:	8b 89 bc 01 00 00    	mov    0x1bc(%rcx),%ecx
 18bae07:	48 39 c8             	cmp    %rcx,%rax
 18bae0a:	0f 86 be 00 00 00    	jbe    18baece <tier0_tables_open+0x39fe>
 18bae10:	48 8b 34 24          	mov    (%rsp),%rsi
 18bae14:	c5 f9 6f 05 24 ae cb fe 	vmovdqa -0x13451dc(%rip),%xmm0        # 575c40 <x86_effects_unknown+0x1e0>
 18bae1c:	4c 89 e9             	mov    %r13,%rcx
 18bae1f:	48 c1 e1 04          	shl    $0x4,%rcx
 18bae23:	48 8b 86 80 01 00 00 	mov    0x180(%rsi),%rax
 18bae2a:	eb 55                	jmp    18bae81 <tier0_tables_open+0x39b1>
 18bae2c:	62 f2 7d 08 7a c6    	vpbroadcastb %esi,%xmm0
 18bae32:	b8 10 00 00 00       	mov    $0x10,%eax
 18bae37:	b9 00 00 00 00       	mov    $0x0,%ecx
 18bae3c:	48 8b 34 24          	mov    (%rsp),%rsi
 18bae40:	48 29 d0             	sub    %rdx,%rax
 18bae43:	48 0f 43 c8          	cmovae %rax,%rcx
 18bae47:	66 b8 01 00          	mov    $0x1,%ax
 18bae4b:	62 f2 7d 08 7a c9    	vpbroadcastb %ecx,%xmm1
 18bae51:	62 f3 75 08 3e 05 b4 ad cb fe 05 	vpcmpnltub -0x134524c(%rip),%xmm1,%k0        # 575c10 <x86_effects_unknown+0x1b0>
 18bae5c:	c4 e2 79 78 0d 5b 59 c6 fe 	vpbroadcastb -0x139a6a5(%rip),%xmm1        # 5207c0 <branch_sizing_patterns+0xa30>
 18bae65:	c5 fb 92 c8          	kmovd  %eax,%k1
 18bae69:	48 8b 86 80 01 00 00 	mov    0x180(%rsi),%rax
 18bae70:	c5 fc 45 c9          	korw   %k1,%k0,%k1
 18bae74:	62 f2 75 09 66 c0    	vpblendmb %xmm0,%xmm1,%xmm0{%k1}
 18bae7a:	4c 89 e9             	mov    %r13,%rcx
 18bae7d:	48 c1 e1 04          	shl    $0x4,%rcx
 18bae81:	c5 f9 7f 04 08       	vmovdqa %xmm0,(%rax,%rcx,1)
 18bae86:	4c 89 f7             	mov    %r14,%rdi
 18bae89:	44 89 ea             	mov    %r13d,%edx
 18bae8c:	c5 f8 77             	vzeroupper
 18bae8f:	e8 7c 0f 01 00       	call   18cbe10 <abi_finish>
 18bae94:	e9 30 fd ff ff       	jmp    18babc9 <tier0_tables_open+0x36f9>
 18bae99:	48 8b 14 24          	mov    (%rsp),%rdx
 18bae9d:	48 8b 52 30          	mov    0x30(%rdx),%rdx
 18baea1:	48 85 f6             	test   %rsi,%rsi
 18baea4:	75 30                	jne    18baed6 <tier0_tables_open+0x3a06>
 18baea6:	4a 83 3c ea 00       	cmpq   $0x0,(%rdx,%r13,8)
 18baeab:	74 29                	je     18baed6 <tier0_tables_open+0x3a06>
 18baead:	48 8b 34 24          	mov    (%rsp),%rsi
 18baeb1:	c4 e2 79 78 05 06 59 c6 fe 	vpbroadcastb -0x139a6fa(%rip),%xmm0        # 5207c0 <branch_sizing_patterns+0xa30>
 18baeba:	48 c1 e1 04          	shl    $0x4,%rcx
 18baebe:	48 8b 86 80 01 00 00 	mov    0x180(%rsi),%rax
 18baec5:	62 f2 7d 09 66 04 08 	vpblendmb (%rax,%rcx,1),%xmm0,%xmm0{%k1}
 18baecc:	eb ac                	jmp    18bae7a <tier0_tables_open+0x39aa>
 18baece:	48 8b 0c 24          	mov    (%rsp),%rcx
 18baed2:	48 8b 51 30          	mov    0x30(%rcx),%rdx
 18baed6:	be 10 00 00 00       	mov    $0x10,%esi
 18baedb:	bf 00 00 00 00       	mov    $0x0,%edi
 18baee0:	42 8b 14 ea          	mov    (%rdx,%r13,8),%edx
 18baee4:	c5 fb 93 c9          	kmovd  %k1,%ecx
 18baee8:	48 29 c6             	sub    %rax,%rsi
 18baeeb:	48 0f 43 fe          	cmovae %rsi,%rdi
 18baeef:	62 f2 7d 08 7a c7    	vpbroadcastb %edi,%xmm0
 18baef5:	62 f3 7d 08 3e 05 10 ad cb fe 05 	vpcmpnltub -0x13452f0(%rip),%xmm0,%k0        # 575c10 <x86_effects_unknown+0x1b0>
 18baf00:	c5 fb 93 f0          	kmovd  %k0,%esi
 18baf04:	83 ce 01             	or     $0x1,%esi
 18baf07:	21 f1                	and    %esi,%ecx
 18baf09:	48 83 f8 11          	cmp    $0x11,%rax
 18baf0d:	89 d8                	mov    %ebx,%eax
 18baf0f:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
 18baf13:	f7 d1                	not    %ecx
 18baf15:	45 89 2c 87          	mov    %r13d,(%r15,%rax,4)
 18baf19:	41 89 54 87 04       	mov    %edx,0x4(%r15,%rax,4)
 18baf1e:	66 41 89 4c 87 08    	mov    %cx,0x8(%r15,%rax,4)
 18baf24:	41 0f 93 44 87 0a    	setae  0xa(%r15,%rax,4)
 18baf2a:	41 0f 92 44 87 0b    	setb   0xb(%r15,%rax,4)
 18baf30:	ff c3                	inc    %ebx
 18baf32:	e9 92 fc ff ff       	jmp    18babc9 <tier0_tables_open+0x36f9>
 18baf37:	48 8b 84 24 c0 00 00 00 	mov    0xc0(%rsp),%rax
 18baf3f:	e9 97 22 00 00       	jmp    18bd1db <tier0_tables_open+0x5d0b>
 18baf44:	c7 84 24 b4 00 00 00 00 00 00 00 	movl   $0x0,0xb4(%rsp)
 18baf4f:	4d 85 ff             	test   %r15,%r15
 18baf52:	0f 84 b9 01 00 00    	je     18bb111 <tier0_tables_open+0x3c41>
 18baf58:	31 db                	xor    %ebx,%ebx
 18baf5a:	48 89 d0             	mov    %rdx,%rax
 18baf5d:	eb 1f                	jmp    18baf7e <tier0_tables_open+0x3aae>
 18baf5f:	64 48 8b 04 25 18 ff ff ff 	mov    %fs:0xffffffffffffff18,%rax
 18baf68:	64 4c 8b 24 25 10 ff ff ff 	mov    %fs:0xffffffffffffff10,%r12
 18baf71:	8d 4b 03             	lea    0x3(%rbx),%ecx
 18baf74:	c1 e9 02             	shr    $0x2,%ecx
 18baf77:	89 8c 24 b4 00 00 00 	mov    %ecx,0xb4(%rsp)
 18baf7e:	4a 8d 54 20 03       	lea    0x3(%rax,%r12,1),%rdx
 18baf83:	89 d9                	mov    %ebx,%ecx
 18baf85:	48 89 8c 24 98 00 00 00 	mov    %rcx,0x98(%rsp)
 18baf8d:	4a 8d 0c 20          	lea    (%rax,%r12,1),%rcx
 18baf91:	48 83 e2 fc          	and    $0xfffffffffffffffc,%rdx
 18baf95:	48 39 ca             	cmp    %rcx,%rdx
 18baf98:	72 54                	jb     18bafee <tier0_tables_open+0x3b1e>
 18baf9a:	64 4c 8b 04 25 20 ff ff ff 	mov    %fs:0xffffffffffffff20,%r8
 18bafa3:	48 89 d6             	mov    %rdx,%rsi
 18bafa6:	4c 29 e6             	sub    %r12,%rsi
 18bafa9:	49 29 f0             	sub    %rsi,%r8
 18bafac:	72 40                	jb     18bafee <tier0_tables_open+0x3b1e>
 18bafae:	48 8b bc 24 98 00 00 00 	mov    0x98(%rsp),%rdi
 18bafb6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
 18bafbc:	4c 89 4c 24 78       	mov    %r9,0x78(%rsp)
 18bafc1:	48 8d 3c bd 00 00 00 00 	lea    0x0(,%rdi,4),%rdi
 18bafc9:	48 8d 3c 7f          	lea    (%rdi,%rdi,2),%rdi
 18bafcd:	4c 39 c7             	cmp    %r8,%rdi
 18bafd0:	77 25                	ja     18baff7 <tier0_tables_open+0x3b27>
 18bafd2:	48 01 fe             	add    %rdi,%rsi
 18bafd5:	48 89 d1             	mov    %rdx,%rcx
 18bafd8:	48 01 f9             	add    %rdi,%rcx
 18bafdb:	48 89 54 24 78       	mov    %rdx,0x78(%rsp)
 18bafe0:	48 89 f0             	mov    %rsi,%rax
 18bafe3:	64 48 89 34 25 18 ff ff ff 	mov    %rsi,%fs:0xffffffffffffff18
 18bafec:	eb 09                	jmp    18baff7 <tier0_tables_open+0x3b27>
 18bafee:	48 c7 44 24 78 00 00 00 00 	movq   $0x0,0x78(%rsp)
 18baff7:	8b 94 24 b4 00 00 00 	mov    0xb4(%rsp),%edx
 18baffe:	48 89 94 24 50 01 00 00 	mov    %rdx,0x150(%rsp)
 18bb006:	48 8d 51 07          	lea    0x7(%rcx),%rdx
 18bb00a:	48 83 e2 f8          	and    $0xfffffffffffffff8,%rdx
 18bb00e:	48 39 ca             	cmp    %rcx,%rdx
 18bb011:	72 50                	jb     18bb063 <tier0_tables_open+0x3b93>
 18bb013:	64 48 8b 34 25 20 ff ff ff 	mov    %fs:0xffffffffffffff20,%rsi
 18bb01c:	48 89 d1             	mov    %rdx,%rcx
 18bb01f:	4c 29 e1             	sub    %r12,%rcx
 18bb022:	48 29 ce             	sub    %rcx,%rsi
 18bb025:	72 3c                	jb     18bb063 <tier0_tables_open+0x3b93>
 18bb027:	48 8b bc 24 50 01 00 00 	mov    0x150(%rsp),%rdi
 18bb02f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
 18bb035:	4c 89 84 24 20 01 00 00 	mov    %r8,0x120(%rsp)
 18bb03d:	48 c1 e7 04          	shl    $0x4,%rdi
 18bb041:	48 8d 3c 7f          	lea    (%rdi,%rdi,2),%rdi
 18bb045:	48 39 f7             	cmp    %rsi,%rdi
 18bb048:	77 25                	ja     18bb06f <tier0_tables_open+0x3b9f>
 18bb04a:	48 01 f9             	add    %rdi,%rcx
 18bb04d:	48 89 94 24 20 01 00 00 	mov    %rdx,0x120(%rsp)
 18bb055:	48 89 c8             	mov    %rcx,%rax
 18bb058:	64 48 89 0c 25 18 ff ff ff 	mov    %rcx,%fs:0xffffffffffffff18
 18bb061:	eb 0c                	jmp    18bb06f <tier0_tables_open+0x3b9f>
 18bb063:	48 c7 84 24 20 01 00 00 00 00 00 00 	movq   $0x0,0x120(%rsp)
 18bb06f:	48 83 bc 24 98 00 00 00 00 	cmpq   $0x0,0x98(%rsp)
 18bb078:	74 73                	je     18bb0ed <tier0_tables_open+0x3c1d>
 18bb07a:	31 c9                	xor    %ecx,%ecx
 18bb07c:	48 83 7c 24 78 00    	cmpq   $0x0,0x78(%rsp)
 18bb082:	0f 84 53 21 00 00    	je     18bd1db <tier0_tables_open+0x5d0b>
 18bb088:	48 83 bc 24 20 01 00 00 00 	cmpq   $0x0,0x120(%rsp)
 18bb091:	0f 84 44 21 00 00    	je     18bd1db <tier0_tables_open+0x5d0b>
 18bb097:	48 8b 8c 24 98 00 00 00 	mov    0x98(%rsp),%rcx
 18bb09f:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 18bb0a3:	62 f1 fe 48 7f 84 24 70 02 00 00 	vmovdqu64 %zmm0,0x270(%rsp)
 18bb0ae:	62 f1 fe 48 7f 84 24 30 02 00 00 	vmovdqu64 %zmm0,0x230(%rsp)
 18bb0b9:	62 f1 fe 48 7f 84 24 f0 01 00 00 	vmovdqu64 %zmm0,0x1f0(%rsp)
 18bb0c4:	62 f1 fe 48 7f 84 24 b0 01 00 00 	vmovdqu64 %zmm0,0x1b0(%rsp)
 18bb0cf:	c7 84 24 b0 02 00 00 00 00 00 00 	movl   $0x0,0x2b0(%rsp)
 18bb0da:	89 c8                	mov    %ecx,%eax
 18bb0dc:	83 e0 07             	and    $0x7,%eax
 18bb0df:	83 f9 08             	cmp    $0x8,%ecx
 18bb0e2:	73 37                	jae    18bb11b <tier0_tables_open+0x3c4b>
 18bb0e4:	31 c9                	xor    %ecx,%ecx
 18bb0e6:	31 ff                	xor    %edi,%edi
 18bb0e8:	e9 4f 01 00 00       	jmp    18bb23c <tier0_tables_open+0x3d6c>
 18bb0ed:	48 39 84 24 c0 00 00 00 	cmp    %rax,0xc0(%rsp)
 18bb0f5:	0f 87 87 21 00 00    	ja     18bd282 <tier0_tables_open+0x5db2>
 18bb0fb:	48 8b 84 24 c0 00 00 00 	mov    0xc0(%rsp),%rax
 18bb103:	64 48 89 04 25 18 ff ff ff 	mov    %rax,%fs:0xffffffffffffff18
 18bb10c:	e9 0b 21 00 00       	jmp    18bd21c <tier0_tables_open+0x5d4c>
 18bb111:	48 89 d0             	mov    %rdx,%rax
 18bb114:	31 c9                	xor    %ecx,%ecx
 18bb116:	e9 c0 20 00 00       	jmp    18bd1db <tier0_tables_open+0x5d0b>
 18bb11b:	48 8b 94 24 98 00 00 00 	mov    0x98(%rsp),%rdx
 18bb123:	83 e2 f8             	and    $0xfffffff8,%edx
 18bb126:	49 8d 77 04          	lea    0x4(%r15),%rsi
 18bb12a:	31 c9                	xor    %ecx,%ecx
 18bb12c:	31 ff                	xor    %edi,%edi
 18bb12e:	eb 11                	jmp    18bb141 <tier0_tables_open+0x3c71>
 18bb130:	48 83 c1 08          	add    $0x8,%rcx
 18bb134:	48 83 c6 60          	add    $0x60,%rsi
 18bb138:	48 39 ca             	cmp    %rcx,%rdx
 18bb13b:	0f 84 f6 00 00 00    	je     18bb237 <tier0_tables_open+0x3d67>
 18bb141:	44 8b 06             	mov    (%rsi),%r8d
 18bb144:	41 b9 3f 00 00 00    	mov    $0x3f,%r9d
 18bb14a:	41 83 f8 3f          	cmp    $0x3f,%r8d
 18bb14e:	45 0f 43 c1          	cmovae %r9d,%r8d
 18bb152:	41 ff c0             	inc    %r8d
 18bb155:	42 ff 84 84 b0 01 00 00 	incl   0x1b0(%rsp,%r8,4)
 18bb15d:	41 39 f8             	cmp    %edi,%r8d
 18bb160:	77 03                	ja     18bb165 <tier0_tables_open+0x3c95>
 18bb162:	41 89 f8             	mov    %edi,%r8d
 18bb165:	8b 7e 0c             	mov    0xc(%rsi),%edi
 18bb168:	83 ff 3f             	cmp    $0x3f,%edi
 18bb16b:	41 0f 43 f9          	cmovae %r9d,%edi
 18bb16f:	ff c7                	inc    %edi
 18bb171:	ff 84 bc b0 01 00 00 	incl   0x1b0(%rsp,%rdi,4)
 18bb178:	44 39 c7             	cmp    %r8d,%edi
 18bb17b:	77 03                	ja     18bb180 <tier0_tables_open+0x3cb0>
 18bb17d:	44 89 c7             	mov    %r8d,%edi
 18bb180:	44 8b 46 18          	mov    0x18(%rsi),%r8d
 18bb184:	41 83 f8 3f          	cmp    $0x3f,%r8d
 18bb188:	45 0f 43 c1          	cmovae %r9d,%r8d
 18bb18c:	41 ff c0             	inc    %r8d
 18bb18f:	42 ff 84 84 b0 01 00 00 	incl   0x1b0(%rsp,%r8,4)
 18bb197:	41 39 f8             	cmp    %edi,%r8d
 18bb19a:	77 03                	ja     18bb19f <tier0_tables_open+0x3ccf>
 18bb19c:	41 89 f8             	mov    %edi,%r8d
 18bb19f:	8b 7e 24             	mov    0x24(%rsi),%edi
 18bb1a2:	83 ff 3f             	cmp    $0x3f,%edi
 18bb1a5:	41 0f 43 f9          	cmovae %r9d,%edi
 18bb1a9:	ff c7                	inc    %edi
 18bb1ab:	ff 84 bc b0 01 00 00 	incl   0x1b0(%rsp,%rdi,4)
 18bb1b2:	44 39 c7             	cmp    %r8d,%edi
 18bb1b5:	77 03                	ja     18bb1ba <tier0_tables_open+0x3cea>
 18bb1b7:	44 89 c7             	mov    %r8d,%edi
 18bb1ba:	44 8b 46 30          	mov    0x30(%rsi),%r8d
 18bb1be:	41 83 f8 3f          	cmp    $0x3f,%r8d
 18bb1c2:	45 0f 43 c1          	cmovae %r9d,%r8d
 18bb1c6:	41 ff c0             	inc    %r8d
 18bb1c9:	42 ff 84 84 b0 01 00 00 	incl   0x1b0(%rsp,%r8,4)
 18bb1d1:	41 39 f8             	cmp    %edi,%r8d
 18bb1d4:	77 03                	ja     18bb1d9 <tier0_tables_open+0x3d09>
 18bb1d6:	41 89 f8             	mov    %edi,%r8d
 18bb1d9:	8b 7e 3c             	mov    0x3c(%rsi),%edi
 18bb1dc:	83 ff 3f             	cmp    $0x3f,%edi
 18bb1df:	41 0f 43 f9          	cmovae %r9d,%edi
 18bb1e3:	ff c7                	inc    %edi
 18bb1e5:	ff 84 bc b0 01 00 00 	incl   0x1b0(%rsp,%rdi,4)
 18bb1ec:	44 39 c7             	cmp    %r8d,%edi
 18bb1ef:	77 03                	ja     18bb1f4 <tier0_tables_open+0x3d24>
 18bb1f1:	44 89 c7             	mov    %r8d,%edi
 18bb1f4:	44 8b 46 48          	mov    0x48(%rsi),%r8d
 18bb1f8:	41 83 f8 3f          	cmp    $0x3f,%r8d
 18bb1fc:	45 0f 43 c1          	cmovae %r9d,%r8d
 18bb200:	41 ff c0             	inc    %r8d
 18bb203:	42 ff 84 84 b0 01 00 00 	incl   0x1b0(%rsp,%r8,4)
 18bb20b:	41 39 f8             	cmp    %edi,%r8d
 18bb20e:	77 03                	ja     18bb213 <tier0_tables_open+0x3d43>
 18bb210:	41 89 f8             	mov    %edi,%r8d
 18bb213:	8b 7e 54             	mov    0x54(%rsi),%edi
 18bb216:	83 ff 3f             	cmp    $0x3f,%edi
 18bb219:	41 0f 43 f9          	cmovae %r9d,%edi
 18bb21d:	ff c7                	inc    %edi
 18bb21f:	ff 84 bc b0 01 00 00 	incl   0x1b0(%rsp,%rdi,4)
 18bb226:	44 39 c7             	cmp    %r8d,%edi
 18bb229:	0f 87 01 ff ff ff    	ja     18bb130 <tier0_tables_open+0x3c60>
 18bb22f:	44 89 c7             	mov    %r8d,%edi
 18bb232:	e9 f9 fe ff ff       	jmp    18bb130 <tier0_tables_open+0x3c60>
 18bb237:	48 85 c0             	test   %rax,%rax
 18bb23a:	74 3b                	je     18bb277 <tier0_tables_open+0x3da7>
 18bb23c:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
 18bb240:	c1 e0 02             	shl    $0x2,%eax
 18bb243:	31 d2                	xor    %edx,%edx
 18bb245:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
 18bb249:	49 8d 4c 8f 04       	lea    0x4(%r15,%rcx,4),%rcx
 18bb24e:	89 fe                	mov    %edi,%esi
 18bb250:	8b 3c 11             	mov    (%rcx,%rdx,1),%edi
 18bb253:	41 b8 3f 00 00 00    	mov    $0x3f,%r8d
 18bb259:	83 ff 3f             	cmp    $0x3f,%edi
 18bb25c:	41 0f 43 f8          	cmovae %r8d,%edi
 18bb260:	ff c7                	inc    %edi
 18bb262:	ff 84 bc b0 01 00 00 	incl   0x1b0(%rsp,%rdi,4)
 18bb269:	39 f7                	cmp    %esi,%edi
 18bb26b:	0f 46 fe             	cmovbe %esi,%edi
 18bb26e:	48 83 c2 0c          	add    $0xc,%rdx
 18bb272:	48 39 d0             	cmp    %rdx,%rax
 18bb275:	75 d7                	jne    18bb24e <tier0_tables_open+0x3d7e>
 18bb277:	89 fa                	mov    %edi,%edx
 18bb279:	89 d0                	mov    %edx,%eax
 18bb27b:	83 e0 07             	and    $0x7,%eax
 18bb27e:	ff cf                	dec    %edi
 18bb280:	83 ff 07             	cmp    $0x7,%edi
 18bb283:	73 09                	jae    18bb28e <tier0_tables_open+0x3dbe>
 18bb285:	31 c9                	xor    %ecx,%ecx
 18bb287:	31 f6                	xor    %esi,%esi
 18bb289:	e9 88 00 00 00       	jmp    18bb316 <tier0_tables_open+0x3e46>
 18bb28e:	81 e2 f8 ff ff 7f    	and    $0x7ffffff8,%edx
 18bb294:	31 c9                	xor    %ecx,%ecx
 18bb296:	31 f6                	xor    %esi,%esi
 18bb298:	03 8c b4 b4 01 00 00 	add    0x1b4(%rsp,%rsi,4),%ecx
 18bb29f:	89 8c b4 b4 01 00 00 	mov    %ecx,0x1b4(%rsp,%rsi,4)
 18bb2a6:	03 8c b4 b8 01 00 00 	add    0x1b8(%rsp,%rsi,4),%ecx
 18bb2ad:	89 8c b4 b8 01 00 00 	mov    %ecx,0x1b8(%rsp,%rsi,4)
 18bb2b4:	03 8c b4 bc 01 00 00 	add    0x1bc(%rsp,%rsi,4),%ecx
 18bb2bb:	89 8c b4 bc 01 00 00 	mov    %ecx,0x1bc(%rsp,%rsi,4)
 18bb2c2:	03 8c b4 c0 01 00 00 	add    0x1c0(%rsp,%rsi,4),%ecx
 18bb2c9:	89 8c b4 c0 01 00 00 	mov    %ecx,0x1c0(%rsp,%rsi,4)
 18bb2d0:	03 8c b4 c4 01 00 00 	add    0x1c4(%rsp,%rsi,4),%ecx
 18bb2d7:	89 8c b4 c4 01 00 00 	mov    %ecx,0x1c4(%rsp,%rsi,4)
 18bb2de:	03 8c b4 c8 01 00 00 	add    0x1c8(%rsp,%rsi,4),%ecx
 18bb2e5:	89 8c b4 c8 01 00 00 	mov    %ecx,0x1c8(%rsp,%rsi,4)
 18bb2ec:	03 8c b4 cc 01 00 00 	add    0x1cc(%rsp,%rsi,4),%ecx
 18bb2f3:	89 8c b4 cc 01 00 00 	mov    %ecx,0x1cc(%rsp,%rsi,4)
 18bb2fa:	03 8c b4 d0 01 00 00 	add    0x1d0(%rsp,%rsi,4),%ecx
 18bb301:	89 8c b4 d0 01 00 00 	mov    %ecx,0x1d0(%rsp,%rsi,4)
 18bb308:	48 83 c6 08          	add    $0x8,%rsi
 18bb30c:	48 39 f2             	cmp    %rsi,%rdx
 18bb30f:	75 87                	jne    18bb298 <tier0_tables_open+0x3dc8>
 18bb311:	48 85 c0             	test   %rax,%rax
 18bb314:	74 1c                	je     18bb332 <tier0_tables_open+0x3e62>
 18bb316:	48 8d 94 24 b4 01 00 00 	lea    0x1b4(%rsp),%rdx
 18bb31e:	48 8d 14 b2          	lea    (%rdx,%rsi,4),%rdx
 18bb322:	31 f6                	xor    %esi,%esi
 18bb324:	03 0c b2             	add    (%rdx,%rsi,4),%ecx
 18bb327:	89 0c b2             	mov    %ecx,(%rdx,%rsi,4)
 18bb32a:	48 ff c6             	inc    %rsi
 18bb32d:	48 39 f0             	cmp    %rsi,%rax
 18bb330:	75 f2                	jne    18bb324 <tier0_tables_open+0x3e54>
 18bb332:	48 8b 8c 24 98 00 00 00 	mov    0x98(%rsp),%rcx
 18bb33a:	89 c8                	mov    %ecx,%eax
 18bb33c:	83 e0 03             	and    $0x3,%eax
 18bb33f:	83 f9 04             	cmp    $0x4,%ecx
 18bb342:	73 07                	jae    18bb34b <tier0_tables_open+0x3e7b>
 18bb344:	31 c9                	xor    %ecx,%ecx
 18bb346:	e9 f9 00 00 00       	jmp    18bb444 <tier0_tables_open+0x3f74>
 18bb34b:	48 8b 94 24 98 00 00 00 	mov    0x98(%rsp),%rdx
 18bb353:	83 e2 fc             	and    $0xfffffffc,%edx
 18bb356:	49 8d 77 28          	lea    0x28(%r15),%rsi
 18bb35a:	31 c9                	xor    %ecx,%ecx
 18bb35c:	8b 7e dc             	mov    -0x24(%rsi),%edi
 18bb35f:	41 bb 3f 00 00 00    	mov    $0x3f,%r11d
 18bb365:	44 8b 56 e0          	mov    -0x20(%rsi),%r10d
 18bb369:	4c 8b 64 24 78       	mov    0x78(%rsp),%r12
 18bb36e:	83 ff 3f             	cmp    $0x3f,%edi
 18bb371:	41 0f 43 fb          	cmovae %r11d,%edi
 18bb375:	44 8b 84 bc b0 01 00 00 	mov    0x1b0(%rsp,%rdi,4),%r8d
 18bb37d:	4f 8d 0c 40          	lea    (%r8,%r8,2),%r9
 18bb381:	41 ff c0             	inc    %r8d
 18bb384:	47 89 54 8c 08       	mov    %r10d,0x8(%r12,%r9,4)
 18bb389:	4c 8b 56 d8          	mov    -0x28(%rsi),%r10
 18bb38d:	4f 89 14 8c          	mov    %r10,(%r12,%r9,4)
 18bb391:	44 89 84 bc b0 01 00 00 	mov    %r8d,0x1b0(%rsp,%rdi,4)
 18bb399:	8b 7e e8             	mov    -0x18(%rsi),%edi
 18bb39c:	44 8b 56 ec          	mov    -0x14(%rsi),%r10d
 18bb3a0:	83 ff 3f             	cmp    $0x3f,%edi
 18bb3a3:	41 0f 43 fb          	cmovae %r11d,%edi
 18bb3a7:	44 8b 84 bc b0 01 00 00 	mov    0x1b0(%rsp,%rdi,4),%r8d
 18bb3af:	4f 8d 0c 40          	lea    (%r8,%r8,2),%r9
 18bb3b3:	41 ff c0             	inc    %r8d
 18bb3b6:	47 89 54 8c 08       	mov    %r10d,0x8(%r12,%r9,4)
 18bb3bb:	4c 8b 56 e4          	mov    -0x1c(%rsi),%r10
 18bb3bf:	4f 89 14 8c          	mov    %r10,(%r12,%r9,4)
 18bb3c3:	44 89 84 bc b0 01 00 00 	mov    %r8d,0x1b0(%rsp,%rdi,4)
 18bb3cb:	8b 7e f4             	mov    -0xc(%rsi),%edi
 18bb3ce:	44 8b 56 f8          	mov    -0x8(%rsi),%r10d
 18bb3d2:	83 ff 3f             	cmp    $0x3f,%edi
 18bb3d5:	41 0f 43 fb          	cmovae %r11d,%edi
 18bb3d9:	44 8b 84 bc b0 01 00 00 	mov    0x1b0(%rsp,%rdi,4),%r8d
 18bb3e1:	4f 8d 0c 40          	lea    (%r8,%r8,2),%r9
 18bb3e5:	41 ff c0             	inc    %r8d
 18bb3e8:	47 89 54 8c 08       	mov    %r10d,0x8(%r12,%r9,4)
 18bb3ed:	4c 8b 56 f0          	mov    -0x10(%rsi),%r10
 18bb3f1:	4f 89 14 8c          	mov    %r10,(%r12,%r9,4)
 18bb3f5:	44 89 84 bc b0 01 00 00 	mov    %r8d,0x1b0(%rsp,%rdi,4)
 18bb3fd:	8b 3e                	mov    (%rsi),%edi
 18bb3ff:	44 8b 56 04          	mov    0x4(%rsi),%r10d
 18bb403:	83 ff 3f             	cmp    $0x3f,%edi
 18bb406:	41 0f 43 fb          	cmovae %r11d,%edi
 18bb40a:	48 83 c1 04          	add    $0x4,%rcx
 18bb40e:	44 8b 84 bc b0 01 00 00 	mov    0x1b0(%rsp,%rdi,4),%r8d
 18bb416:	4f 8d 0c 40          	lea    (%r8,%r8,2),%r9
 18bb41a:	41 ff c0             	inc    %r8d
 18bb41d:	47 89 54 8c 08       	mov    %r10d,0x8(%r12,%r9,4)
 18bb422:	4c 8b 56 fc          	mov    -0x4(%rsi),%r10
 18bb426:	48 83 c6 30          	add    $0x30,%rsi
 18bb42a:	4f 89 14 8c          	mov    %r10,(%r12,%r9,4)
 18bb42e:	44 89 84 bc b0 01 00 00 	mov    %r8d,0x1b0(%rsp,%rdi,4)
 18bb436:	48 39 ca             	cmp    %rcx,%rdx
 18bb439:	0f 85 1d ff ff ff    	jne    18bb35c <tier0_tables_open+0x3e8c>
 18bb43f:	48 85 c0             	test   %rax,%rax
 18bb442:	74 55                	je     18bb499 <tier0_tables_open+0x3fc9>
 18bb444:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
 18bb448:	c1 e0 02             	shl    $0x2,%eax
 18bb44b:	31 d2                	xor    %edx,%edx
 18bb44d:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
 18bb451:	49 8d 4c 8f 04       	lea    0x4(%r15,%rcx,4),%rcx
 18bb456:	8b 34 11             	mov    (%rcx,%rdx,1),%esi
 18bb459:	bf 3f 00 00 00       	mov    $0x3f,%edi
 18bb45e:	44 8b 4c 11 04       	mov    0x4(%rcx,%rdx,1),%r9d
 18bb463:	4c 8b 54 24 78       	mov    0x78(%rsp),%r10
 18bb468:	83 fe 3f             	cmp    $0x3f,%esi
 18bb46b:	0f 43 f7             	cmovae %edi,%esi
 18bb46e:	8b bc b4 b0 01 00 00 	mov    0x1b0(%rsp,%rsi,4),%edi
 18bb475:	4c 8d 04 7f          	lea    (%rdi,%rdi,2),%r8
 18bb479:	ff c7                	inc    %edi
 18bb47b:	47 89 4c 82 08       	mov    %r9d,0x8(%r10,%r8,4)
 18bb480:	4c 8b 4c 11 fc       	mov    -0x4(%rcx,%rdx,1),%r9
 18bb485:	48 83 c2 0c          	add    $0xc,%rdx
 18bb489:	4f 89 0c 82          	mov    %r9,(%r10,%r8,4)
 18bb48d:	89 bc b4 b0 01 00 00 	mov    %edi,0x1b0(%rsp,%rsi,4)
 18bb494:	48 39 d0             	cmp    %rdx,%rax
 18bb497:	75 bd                	jne    18bb456 <tier0_tables_open+0x3f86>
 18bb499:	83 bc 24 b4 00 00 00 00 	cmpl   $0x0,0xb4(%rsp)
 18bb4a1:	0f 84 a8 01 00 00    	je     18bb64f <tier0_tables_open+0x417f>
 18bb4a7:	48 8b 84 24 50 01 00 00 	mov    0x150(%rsp),%rax
 18bb4af:	b9 0a 00 00 00       	mov    $0xa,%ecx
 18bb4b4:	31 d2                	xor    %edx,%edx
 18bb4b6:	31 ff                	xor    %edi,%edi
 18bb4b8:	8d 1c 85 00 00 00 00 	lea    0x0(,%rax,4),%ebx
 18bb4bf:	eb 66                	jmp    18bb527 <tier0_tables_open+0x4057>
 18bb4c1:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
 18bb4c7:	bd ff ff ff ff       	mov    $0xffffffff,%ebp
 18bb4cc:	41 bb ff ff ff ff    	mov    $0xffffffff,%r11d
 18bb4d2:	45 31 c0             	xor    %r8d,%r8d
 18bb4d5:	45 31 c9             	xor    %r9d,%r9d
 18bb4d8:	45 31 d2             	xor    %r10d,%r10d
 18bb4db:	48 8b 84 24 20 01 00 00 	mov    0x120(%rsp),%rax
 18bb4e3:	48 83 c2 04          	add    $0x4,%rdx
 18bb4e7:	44 89 5c 88 d8       	mov    %r11d,-0x28(%rax,%rcx,4)
 18bb4ec:	89 6c 88 dc          	mov    %ebp,-0x24(%rax,%rcx,4)
 18bb4f0:	44 89 7c 88 e0       	mov    %r15d,-0x20(%rax,%rcx,4)
 18bb4f5:	89 7c 88 e4          	mov    %edi,-0x1c(%rax,%rcx,4)
 18bb4f9:	44 89 cf             	mov    %r9d,%edi
 18bb4fc:	48 89 74 88 e8       	mov    %rsi,-0x18(%rax,%rcx,4)
 18bb501:	44 89 4c 88 f0       	mov    %r9d,-0x10(%rax,%rcx,4)
 18bb506:	c7 44 88 f4 00 00 00 00 	movl   $0x0,-0xc(%rax,%rcx,4)
 18bb50e:	4c 89 44 88 f8       	mov    %r8,-0x8(%rax,%rcx,4)
 18bb513:	4c 89 14 88          	mov    %r10,(%rax,%rcx,4)
 18bb517:	48 01 f7             	add    %rsi,%rdi
 18bb51a:	48 83 c1 0c          	add    $0xc,%rcx
 18bb51e:	48 39 d3             	cmp    %rdx,%rbx
 18bb521:	0f 84 1e 01 00 00    	je     18bb645 <tier0_tables_open+0x4175>
 18bb527:	48 89 fe             	mov    %rdi,%rsi
 18bb52a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 18bb52f:	48 3b 94 24 98 00 00 00 	cmp    0x98(%rsp),%rdx
 18bb537:	73 88                	jae    18bb4c1 <tier0_tables_open+0x3ff1>
 18bb539:	48 8b 44 24 78       	mov    0x78(%rsp),%rax
 18bb53e:	4c 8d 7a 01          	lea    0x1(%rdx),%r15
 18bb542:	44 0f b6 54 88 e2    	movzbl -0x1e(%rax,%rcx,4),%r10d
 18bb548:	44 8b 5c 88 d8       	mov    -0x28(%rax,%rcx,4),%r11d
 18bb54d:	44 8b 4c 88 dc       	mov    -0x24(%rax,%rcx,4),%r9d
 18bb552:	44 0f b7 44 88 e0    	movzwl -0x20(%rax,%rcx,4),%r8d
 18bb558:	41 83 e2 01          	and    $0x1,%r10d
 18bb55c:	4c 3b bc 24 98 00 00 00 	cmp    0x98(%rsp),%r15
 18bb564:	0f 83 c0 00 00 00    	jae    18bb62a <tier0_tables_open+0x415a>
 18bb56a:	48 8b 44 24 78       	mov    0x78(%rsp),%rax
 18bb56f:	44 8b 7c 88 e8       	mov    -0x18(%rax,%rcx,4),%r15d
 18bb574:	44 0f b6 64 88 ee    	movzbl -0x12(%rax,%rcx,4),%r12d
 18bb57a:	8b 6c 88 e4          	mov    -0x1c(%rax,%rcx,4),%ebp
 18bb57e:	45 39 cf             	cmp    %r9d,%r15d
 18bb581:	45 0f 47 cf          	cmova  %r15d,%r9d
 18bb585:	44 8b 7c 88 ec       	mov    -0x14(%rax,%rcx,4),%r15d
 18bb58a:	41 83 e4 01          	and    $0x1,%r12d
 18bb58e:	48 8d 42 02          	lea    0x2(%rdx),%rax
 18bb592:	41 c1 e4 10          	shl    $0x10,%r12d
 18bb596:	4d 09 e2             	or     %r12,%r10
 18bb599:	41 c1 e7 10          	shl    $0x10,%r15d
 18bb59d:	4d 09 f8             	or     %r15,%r8
 18bb5a0:	48 3b 84 24 98 00 00 00 	cmp    0x98(%rsp),%rax
 18bb5a8:	0f 83 8c 00 00 00    	jae    18bb63a <tier0_tables_open+0x416a>
 18bb5ae:	48 8b 44 24 78       	mov    0x78(%rsp),%rax
 18bb5b3:	44 8b 64 88 f4       	mov    -0xc(%rax,%rcx,4),%r12d
 18bb5b8:	44 8b 7c 88 f0       	mov    -0x10(%rax,%rcx,4),%r15d
 18bb5bd:	44 0f b7 6c 88 f8    	movzwl -0x8(%rax,%rcx,4),%r13d
 18bb5c3:	0f b6 44 88 fa       	movzbl -0x6(%rax,%rcx,4),%eax
 18bb5c8:	45 39 cc             	cmp    %r9d,%r12d
 18bb5cb:	45 0f 47 cc          	cmova  %r12d,%r9d
 18bb5cf:	83 e0 01             	and    $0x1,%eax
 18bb5d2:	49 c1 e5 20          	shl    $0x20,%r13
 18bb5d6:	4c 8d 62 03          	lea    0x3(%rdx),%r12
 18bb5da:	48 c1 e0 20          	shl    $0x20,%rax
 18bb5de:	4d 09 e8             	or     %r13,%r8
 18bb5e1:	49 09 c2             	or     %rax,%r10
 18bb5e4:	4c 3b a4 24 98 00 00 00 	cmp    0x98(%rsp),%r12
 18bb5ec:	0f 83 e9 fe ff ff    	jae    18bb4db <tier0_tables_open+0x400b>
 18bb5f2:	4c 8b 6c 24 78       	mov    0x78(%rsp),%r13
 18bb5f7:	41 8b 44 8d 00       	mov    0x0(%r13,%rcx,4),%eax
 18bb5fc:	45 0f b6 64 8d 06    	movzbl 0x6(%r13,%rcx,4),%r12d
 18bb602:	41 8b 7c 8d fc       	mov    -0x4(%r13,%rcx,4),%edi
 18bb607:	44 39 c8             	cmp    %r9d,%eax
 18bb60a:	44 0f 47 c8          	cmova  %eax,%r9d
 18bb60e:	41 8b 44 8d 04       	mov    0x4(%r13,%rcx,4),%eax
 18bb613:	41 83 e4 01          	and    $0x1,%r12d
 18bb617:	49 c1 e4 30          	shl    $0x30,%r12
 18bb61b:	4d 09 e2             	or     %r12,%r10
 18bb61e:	48 c1 e0 30          	shl    $0x30,%rax
 18bb622:	49 09 c0             	or     %rax,%r8
 18bb625:	e9 b1 fe ff ff       	jmp    18bb4db <tier0_tables_open+0x400b>
 18bb62a:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
 18bb630:	bd ff ff ff ff       	mov    $0xffffffff,%ebp
 18bb635:	e9 a1 fe ff ff       	jmp    18bb4db <tier0_tables_open+0x400b>
 18bb63a:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
 18bb640:	e9 96 fe ff ff       	jmp    18bb4db <tier0_tables_open+0x400b>
 18bb645:	48 c1 e7 06          	shl    $0x6,%rdi
 18bb649:	48 83 c7 40          	add    $0x40,%rdi
 18bb64d:	eb 05                	jmp    18bb654 <tier0_tables_open+0x4184>
 18bb64f:	bf 40 00 00 00       	mov    $0x40,%edi
 18bb654:	64 48 8b 0c 25 10 ff ff ff 	mov    %fs:0xffffffffffffff10,%rcx
 18bb65d:	64 48 8b 04 25 18 ff ff ff 	mov    %fs:0xffffffffffffff18,%rax
 18bb666:	48 8d 54 08 3f       	lea    0x3f(%rax,%rcx,1),%rdx
 18bb66b:	48 01 c8             	add    %rcx,%rax
 18bb66e:	48 83 e2 c0          	and    $0xffffffffffffffc0,%rdx
 18bb672:	48 89 94 24 e8 00 00 00 	mov    %rdx,0xe8(%rsp)
 18bb67a:	48 39 c2             	cmp    %rax,%rdx
 18bb67d:	73 07                	jae    18bb686 <tier0_tables_open+0x41b6>
 18bb67f:	31 c9                	xor    %ecx,%ecx
 18bb681:	e9 4c 1b 00 00       	jmp    18bd1d2 <tier0_tables_open+0x5d02>
 18bb686:	48 8b 84 24 e8 00 00 00 	mov    0xe8(%rsp),%rax
 18bb68e:	64 48 8b 14 25 20 ff ff ff 	mov    %fs:0xffffffffffffff20,%rdx
 18bb697:	48 29 c8             	sub    %rcx,%rax
 18bb69a:	31 c9                	xor    %ecx,%ecx
 18bb69c:	48 29 c2             	sub    %rax,%rdx
 18bb69f:	0f 82 2d 1b 00 00    	jb     18bd1d2 <tier0_tables_open+0x5d02>
 18bb6a5:	48 39 d7             	cmp    %rdx,%rdi
 18bb6a8:	0f 87 24 1b 00 00    	ja     18bd1d2 <tier0_tables_open+0x5d02>
 18bb6ae:	48 01 f8             	add    %rdi,%rax
 18bb6b1:	48 83 bc 24 e8 00 00 00 00 	cmpq   $0x0,0xe8(%rsp)
 18bb6ba:	64 48 89 04 25 18 ff ff ff 	mov    %rax,%fs:0xffffffffffffff18
 18bb6c3:	0f 84 45 16 00 00    	je     18bcd0e <tier0_tables_open+0x583e>
 18bb6c9:	83 bc 24 b4 00 00 00 00 	cmpl   $0x0,0xb4(%rsp)
 18bb6d1:	0f 84 37 16 00 00    	je     18bcd0e <tier0_tables_open+0x583e>
 18bb6d7:	48 8b 84 24 e8 00 00 00 	mov    0xe8(%rsp),%rax
 18bb6df:	48 c7 84 24 68 01 00 00 00 00 00 00 	movq   $0x0,0x168(%rsp)
 18bb6eb:	48 05 00 01 00 00    	add    $0x100,%rax
 18bb6f1:	48 89 84 24 a0 01 00 00 	mov    %rax,0x1a0(%rsp)
 18bb6f9:	eb 21                	jmp    18bb71c <tier0_tables_open+0x424c>
 18bb6fb:	48 8b 8c 24 68 01 00 00 	mov    0x168(%rsp),%rcx
 18bb703:	48 ff c1             	inc    %rcx
 18bb706:	48 89 8c 24 68 01 00 00 	mov    %rcx,0x168(%rsp)
 18bb70e:	48 3b 8c 24 50 01 00 00 	cmp    0x150(%rsp),%rcx
 18bb716:	0f 84 f2 15 00 00    	je     18bcd0e <tier0_tables_open+0x583e>
 18bb71c:	48 8b 84 24 68 01 00 00 	mov    0x168(%rsp),%rax
 18bb724:	48 8b b4 24 20 01 00 00 	mov    0x120(%rsp),%rsi
 18bb72c:	48 8b 94 24 a0 01 00 00 	mov    0x1a0(%rsp),%rdx
 18bb734:	48 c7 84 24 c8 00 00 00 00 00 00 00 	movq   $0x0,0xc8(%rsp)
 18bb740:	48 c1 e0 04          	shl    $0x4,%rax
 18bb744:	48 89 94 24 78 01 00 00 	mov    %rdx,0x178(%rsp)
 18bb74c:	48 8d 0c 40          	lea    (%rax,%rax,2),%rcx
 18bb750:	48 8d 04 0e          	lea    (%rsi,%rcx,1),%rax
 18bb754:	48 03 4c 24 78       	add    0x78(%rsp),%rcx
 18bb759:	48 89 84 24 48 01 00 00 	mov    %rax,0x148(%rsp)
 18bb761:	48 89 8c 24 a8 01 00 00 	mov    %rcx,0x1a8(%rsp)
 18bb769:	48 8b 8c 24 e8 00 00 00 	mov    0xe8(%rsp),%rcx
 18bb771:	48 89 8c 24 80 01 00 00 	mov    %rcx,0x180(%rsp)
 18bb779:	eb 7d                	jmp    18bb7f8 <tier0_tables_open+0x4328>
 18bb77b:	48 8b 34 24          	mov    (%rsp),%rsi
 18bb77f:	48 8b 94 24 f0 00 00 00 	mov    0xf0(%rsp),%rdx
 18bb787:	4c 89 f7             	mov    %r14,%rdi
 18bb78a:	c5 f8 77             	vzeroupper
 18bb78d:	e8 ae 0d 01 00       	call   18cc540 <abi_storage>
 18bb792:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
 18bb797:	b1 30                	mov    $0x30,%cl
 18bb799:	c4 e2 f0 f5 d2       	bzhi   %rcx,%rdx,%rdx
 18bb79e:	48 89 54 24 30       	mov    %rdx,0x30(%rsp)
 18bb7a3:	48 8b 34 24          	mov    (%rsp),%rsi
 18bb7a7:	48 8b 94 24 f0 00 00 00 	mov    0xf0(%rsp),%rdx
 18bb7af:	48 8b 8e a0 01 00 00 	mov    0x1a0(%rsi),%rcx
 18bb7b6:	88 04 11             	mov    %al,(%rcx,%rdx,1)
 18bb7b9:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
 18bb7be:	48 8b 86 a8 01 00 00 	mov    0x1a8(%rsi),%rax
 18bb7c5:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
 18bb7c9:	48 8b 8c 24 c8 00 00 00 	mov    0xc8(%rsp),%rcx
 18bb7d1:	48 83 84 24 80 01 00 00 10 	addq   $0x10,0x180(%rsp)
 18bb7da:	48 83 84 24 78 01 00 00 10 	addq   $0x10,0x178(%rsp)
 18bb7e3:	48 ff c1             	inc    %rcx
 18bb7e6:	48 89 8c 24 c8 00 00 00 	mov    %rcx,0xc8(%rsp)
 18bb7ee:	48 83 f9 04          	cmp    $0x4,%rcx
 18bb7f2:	0f 84 03 ff ff ff    	je     18bb6fb <tier0_tables_open+0x422b>
 18bb7f8:	48 8b 84 24 48 01 00 00 	mov    0x148(%rsp),%rax
 18bb800:	48 8b 8c 24 c8 00 00 00 	mov    0xc8(%rsp),%rcx
 18bb808:	48 8b 50 10          	mov    0x10(%rax),%rdx
 18bb80c:	48 89 ce             	mov    %rcx,%rsi
 18bb80f:	48 c1 e6 04          	shl    $0x4,%rsi
 18bb813:	48 03 b4 24 e8 00 00 00 	add    0xe8(%rsp),%rsi
 18bb81b:	48 c1 e2 06          	shl    $0x6,%rdx
 18bb81f:	48 01 d6             	add    %rdx,%rsi
 18bb822:	48 89 94 24 88 01 00 00 	mov    %rdx,0x188(%rsp)
 18bb82a:	8b 14 88             	mov    (%rax,%rcx,4),%edx
 18bb82d:	8b 40 18             	mov    0x18(%rax),%eax
 18bb830:	48 89 74 24 08       	mov    %rsi,0x8(%rsp)
 18bb835:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
 18bb83a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 18bb83f:	48 89 94 24 f0 00 00 00 	mov    %rdx,0xf0(%rsp)
 18bb847:	48 39 c2             	cmp    %rax,%rdx
 18bb84a:	0f 84 ec 00 00 00    	je     18bb93c <tier0_tables_open+0x446c>
 18bb850:	48 8b 84 24 c8 00 00 00 	mov    0xc8(%rsp),%rax
 18bb858:	48 8b 8c 24 a8 01 00 00 	mov    0x1a8(%rsp),%rcx
 18bb860:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
 18bb864:	0f b6 44 81 0b       	movzbl 0xb(%rcx,%rax,4),%eax
 18bb869:	48 8b 0c 24          	mov    (%rsp),%rcx
 18bb86d:	88 84 24 00 01 00 00 	mov    %al,0x100(%rsp)
 18bb874:	48 8b 01             	mov    (%rcx),%rax
 18bb877:	48 8b 8c 24 f0 00 00 00 	mov    0xf0(%rsp),%rcx
 18bb87f:	0f b6 0c 08          	movzbl (%rax,%rcx,1),%ecx
 18bb883:	88 8c 24 d0 00 00 00 	mov    %cl,0xd0(%rsp)
 18bb88a:	80 f9 08             	cmp    $0x8,%cl
 18bb88d:	0f 85 ed 00 00 00    	jne    18bb980 <tier0_tables_open+0x44b0>
 18bb893:	48 8b 0c 24          	mov    (%rsp),%rcx
 18bb897:	48 8b 94 24 f0 00 00 00 	mov    0xf0(%rsp),%rdx
 18bb89f:	48 8b 49 20          	mov    0x20(%rcx),%rcx
 18bb8a3:	8b 14 91             	mov    (%rcx,%rdx,4),%edx
 18bb8a6:	c1 ea 03             	shr    $0x3,%edx
 18bb8a9:	80 3c 10 0f          	cmpb   $0xf,(%rax,%rdx,1)
 18bb8ad:	48 89 d0             	mov    %rdx,%rax
 18bb8b0:	75 06                	jne    18bb8b8 <tier0_tables_open+0x43e8>
 18bb8b2:	8b 04 91             	mov    (%rcx,%rdx,4),%eax
 18bb8b5:	c1 e8 03             	shr    $0x3,%eax
 18bb8b8:	48 8b 0c 24          	mov    (%rsp),%rcx
 18bb8bc:	48 8b b4 24 f0 00 00 00 	mov    0xf0(%rsp),%rsi
 18bb8c4:	48 8b 49 30          	mov    0x30(%rcx),%rcx
 18bb8c8:	48 8b 34 f1          	mov    (%rcx,%rsi,8),%rsi
 18bb8cc:	48 89 74 24 58       	mov    %rsi,0x58(%rsp)
 18bb8d1:	48 85 f6             	test   %rsi,%rsi
 18bb8d4:	0f 84 fb 0b 00 00    	je     18bc4d5 <tier0_tables_open+0x5005>
 18bb8da:	48 8b 0c 24          	mov    (%rsp),%rcx
 18bb8de:	48 8b 49 38          	mov    0x38(%rcx),%rcx
 18bb8e2:	48 8b 0c c1          	mov    (%rcx,%rax,8),%rcx
 18bb8e6:	48 89 d0             	mov    %rdx,%rax
 18bb8e9:	48 c1 e0 04          	shl    $0x4,%rax
 18bb8ed:	80 bc 24 00 01 00 00 00 	cmpb   $0x0,0x100(%rsp)
 18bb8f5:	0f 84 e8 0b 00 00    	je     18bc4e3 <tier0_tables_open+0x5013>
 18bb8fb:	48 85 c9             	test   %rcx,%rcx
 18bb8fe:	0f 84 99 0e 00 00    	je     18bc79d <tier0_tables_open+0x52cd>
 18bb904:	48 8b 34 24          	mov    (%rsp),%rsi
 18bb908:	48 8b be a8 01 00 00 	mov    0x1a8(%rsi),%rdi
 18bb90f:	48 8b 1c d7          	mov    (%rdi,%rdx,8),%rbx
 18bb913:	48 89 da             	mov    %rbx,%rdx
 18bb916:	48 c1 ea 20          	shr    $0x20,%rdx
 18bb91a:	48 83 7c 24 58 01    	cmpq   $0x1,0x58(%rsp)
 18bb920:	48 89 54 24 10       	mov    %rdx,0x10(%rsp)
 18bb925:	0f 85 8d 0e 00 00    	jne    18bc7b8 <tier0_tables_open+0x52e8>
 18bb92b:	48 c7 44 24 30 00 00 00 00 	movq   $0x0,0x30(%rsp)
 18bb934:	45 31 c0             	xor    %r8d,%r8d
 18bb937:	e9 db 0f 00 00       	jmp    18bc917 <tier0_tables_open+0x5447>
 18bb93c:	48 83 7c 24 68 00    	cmpq   $0x0,0x68(%rsp)
 18bb942:	0f 84 81 fe ff ff    	je     18bb7c9 <tier0_tables_open+0x42f9>
 18bb948:	31 c0                	xor    %eax,%eax
 18bb94a:	31 c9                	xor    %ecx,%ecx
 18bb94c:	c4 e2 79 59 05 ab 47 cc fe 	vpbroadcastq -0x133b855(%rip),%xmm0        # 580100 <x86_semantics_benchmark_code.registers+0x110>
 18bb955:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
 18bb95a:	89 c2                	mov    %eax,%edx
 18bb95c:	83 e2 c0             	and    $0xffffffc0,%edx
 18bb95f:	48 ff c1             	inc    %rcx
 18bb962:	48 83 c0 40          	add    $0x40,%rax
 18bb966:	c5 f9 7f 04 16       	vmovdqa %xmm0,(%rsi,%rdx,1)
 18bb96b:	48 8b b4 24 48 01 00 00 	mov    0x148(%rsp),%rsi
 18bb973:	8b 56 18             	mov    0x18(%rsi),%edx
 18bb976:	48 39 d1             	cmp    %rdx,%rcx
 18bb979:	72 d1                	jb     18bb94c <tier0_tables_open+0x447c>
 18bb97b:	e9 49 fe ff ff       	jmp    18bb7c9 <tier0_tables_open+0x42f9>
 18bb980:	48 8b 34 24          	mov    (%rsp),%rsi
 18bb984:	48 8b 8c 24 f0 00 00 00 	mov    0xf0(%rsp),%rcx
 18bb98c:	48 8b 46 28          	mov    0x28(%rsi),%rax
 18bb990:	48 8b 56 70          	mov    0x70(%rsi),%rdx
 18bb994:	48 8b 76 78          	mov    0x78(%rsi),%rsi
 18bb998:	8b 04 88             	mov    (%rax,%rcx,4),%eax
 18bb99b:	8b 14 82             	mov    (%rdx,%rax,4),%edx
 18bb99e:	8b 04 86             	mov    (%rsi,%rax,4),%eax
 18bb9a1:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
 18bb9a6:	01 d0                	add    %edx,%eax
 18bb9a8:	48 89 54 24 20       	mov    %rdx,0x20(%rsp)
 18bb9ad:	89 84 24 e0 00 00 00 	mov    %eax,0xe0(%rsp)
 18bb9b4:	39 c2                	cmp    %eax,%edx
 18bb9b6:	0f 83 19 0b 00 00    	jae    18bc4d5 <tier0_tables_open+0x5005>
 18bb9bc:	48 8b 04 24          	mov    (%rsp),%rax
 18bb9c0:	48 8b 8c 24 f0 00 00 00 	mov    0xf0(%rsp),%rcx
 18bb9c8:	4c 8b 6c 24 20       	mov    0x20(%rsp),%r13
 18bb9cd:	48 c7 84 24 70 01 00 00 00 00 00 00 	movq   $0x0,0x170(%rsp)
 18bb9d9:	48 c7 84 24 28 01 00 00 00 00 00 00 	movq   $0x0,0x128(%rsp)
 18bb9e5:	48 c7 84 24 a8 00 00 00 00 00 00 00 	movq   $0x0,0xa8(%rsp)
 18bb9f1:	48 c7 44 24 40 00 00 00 00 	movq   $0x0,0x40(%rsp)
 18bb9fa:	48 c7 44 24 30 00 00 00 00 	movq   $0x0,0x30(%rsp)
 18bba03:	48 c7 44 24 50 00 00 00 00 	movq   $0x0,0x50(%rsp)
 18bba0c:	48 8b 40 38          	mov    0x38(%rax),%rax
 18bba10:	4c 89 6c 24 10       	mov    %r13,0x10(%rsp)
 18bba15:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
 18bba19:	48 89 84 24 b8 00 00 00 	mov    %rax,0xb8(%rsp)
 18bba21:	8b 84 24 e0 00 00 00 	mov    0xe0(%rsp),%eax
 18bba28:	48 89 84 24 98 01 00 00 	mov    %rax,0x198(%rsp)
 18bba30:	44 89 e8             	mov    %r13d,%eax
 18bba33:	f7 d0                	not    %eax
 18bba35:	48 89 84 24 f8 00 00 00 	mov    %rax,0xf8(%rsp)
 18bba3d:	41 8d 45 01          	lea    0x1(%r13),%eax
 18bba41:	48 89 84 24 80 00 00 00 	mov    %rax,0x80(%rsp)
 18bba49:	b0 ff                	mov    $0xff,%al
 18bba4b:	89 84 24 e4 00 00 00 	mov    %eax,0xe4(%rsp)
 18bba52:	e9 93 01 00 00       	jmp    18bbbea <tier0_tables_open+0x471a>
 18bba57:	48 89 c8             	mov    %rcx,%rax
 18bba5a:	48 c7 44 24 38 00 00 00 00 	movq   $0x0,0x38(%rsp)
 18bba63:	4c 8b 84 24 a8 00 00 00 	mov    0xa8(%rsp),%r8
 18bba6b:	45 89 fa             	mov    %r15d,%r10d
 18bba6e:	48 09 ac 24 28 01 00 00 	or     %rbp,0x128(%rsp)
 18bba76:	31 c9                	xor    %ecx,%ecx
 18bba78:	41 bb 00 00 00 00    	mov    $0x0,%r11d
 18bba7e:	48 be 00 00 00 00 00 00 02 00 	movabs $0x2000000000000,%rsi
 18bba88:	49 89 ed             	mov    %rbp,%r13
 18bba8b:	bd 00 00 00 00       	mov    $0x0,%ebp
 18bba90:	48 8b 9c 24 18 01 00 00 	mov    0x118(%rsp),%rbx
 18bba98:	45 08 c2             	or     %r8b,%r10b
 18bba9b:	48 83 bc 24 08 01 00 00 00 	cmpq   $0x0,0x108(%rsp)
 18bbaa4:	4c 89 94 24 70 01 00 00 	mov    %r10,0x170(%rsp)
 18bbaac:	4c 89 94 24 a8 00 00 00 	mov    %r10,0xa8(%rsp)
 18bbab4:	0f 95 c1             	setne  %cl
 18bbab7:	41 f6 c1 10          	test   $0x10,%r9b
 18bbabb:	49 b9 00 00 00 00 fe ff 7f 00 	movabs $0x7ffffe00000000,%r9
 18bbac5:	4c 0f 45 de          	cmovne %rsi,%r11
 18bbac9:	be ff ff ff ff       	mov    $0xffffffff,%esi
 18bbace:	4c 8d 66 01          	lea    0x1(%rsi),%r12
 18bbad2:	be 1f 00 00 00       	mov    $0x1f,%esi
 18bbad7:	4c 0f 44 e5          	cmove  %rbp,%r12
 18bbadb:	41 f6 c0 01          	test   $0x1,%r8b
 18bbadf:	4c 8b 44 24 40       	mov    0x40(%rsp),%r8
 18bbae4:	4c 0f 45 dd          	cmovne %rbp,%r11
 18bbae8:	45 84 ff             	test   %r15b,%r15b
 18bbaeb:	49 89 ff             	mov    %rdi,%r15
 18bbaee:	4c 0f 44 dd          	cmove  %rbp,%r11
 18bbaf2:	49 c1 e7 3c          	shl    $0x3c,%r15
 18bbaf6:	48 83 fb 1f          	cmp    $0x1f,%rbx
 18bbafa:	48 0f 42 f3          	cmovb  %rbx,%rsi
 18bbafe:	48 c1 e6 37          	shl    $0x37,%rsi
 18bbb02:	49 c1 e0 21          	shl    $0x21,%r8
 18bbb06:	4d 29 c1             	sub    %r8,%r9
 18bbb09:	48 85 db             	test   %rbx,%rbx
 18bbb0c:	44 0f b6 84 24 d0 00 00 00 	movzbl 0xd0(%rsp),%r8d
 18bbb15:	4c 0f 44 e3          	cmove  %rbx,%r12
 18bbb19:	49 09 f1             	or     %rsi,%r9
 18bbb1c:	40 80 cf 20          	or     $0x20,%dil
 18bbb20:	31 f6                	xor    %esi,%esi
 18bbb22:	48 bb 00 00 00 00 00 00 04 00 	movabs $0x4000000000000,%rbx
 18bbb2c:	4d 09 f9             	or     %r15,%r9
 18bbb2f:	4c 0b 8c 24 10 01 00 00 	or     0x110(%rsp),%r9
 18bbb37:	4d 09 e1             	or     %r12,%r9
 18bbb3a:	f6 44 24 70 20       	testb  $0x20,0x70(%rsp)
 18bbb3f:	40 0f 94 c6          	sete   %sil
 18bbb43:	f6 84 24 d8 00 00 00 02 	testb  $0x2,0xd8(%rsp)
 18bbb4b:	0f 45 f1             	cmovne %ecx,%esi
 18bbb4e:	b9 00 00 00 00       	mov    $0x0,%ecx
 18bbb53:	40 84 f6             	test   %sil,%sil
 18bbb56:	48 0f 45 cb          	cmovne %rbx,%rcx
 18bbb5a:	48 03 4c 24 38       	add    0x38(%rsp),%rcx
 18bbb5f:	49 0f ab fb          	bts    %rdi,%r11
 18bbb63:	4c 09 ea             	or     %r13,%rdx
 18bbb66:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
 18bbb6b:	48 01 c8             	add    %rcx,%rax
 18bbb6e:	4c 01 d8             	add    %r11,%rax
 18bbb71:	41 80 f8 11          	cmp    $0x11,%r8b
 18bbb75:	49 0f 44 c1          	cmove  %r9,%rax
 18bbb79:	80 bc 24 40 01 00 00 00 	cmpb   $0x0,0x140(%rsp)
 18bbb81:	48 0f 44 c5          	cmove  %rbp,%rax
 18bbb85:	48 0f 44 d5          	cmove  %rbp,%rdx
 18bbb89:	48 89 c6             	mov    %rax,%rsi
 18bbb8c:	48 09 fe             	or     %rdi,%rsi
 18bbb8f:	48 39 f8             	cmp    %rdi,%rax
 18bbb92:	48 0f 46 c7          	cmovbe %rdi,%rax
 18bbb96:	41 80 f8 11          	cmp    $0x11,%r8b
 18bbb9a:	48 0f 45 c6          	cmovne %rsi,%rax
 18bbb9e:	48 0f 45 cd          	cmovne %rbp,%rcx
 18bbba2:	48 0b 54 24 30       	or     0x30(%rsp),%rdx
 18bbba7:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
 18bbbac:	48 09 ca             	or     %rcx,%rdx
 18bbbaf:	48 89 54 24 30       	mov    %rdx,0x30(%rsp)
 18bbbb4:	48 8b 84 24 80 00 00 00 	mov    0x80(%rsp),%rax
 18bbbbc:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
 18bbbc1:	48 ff 44 24 10       	incq   0x10(%rsp)
 18bbbc6:	48 ff 8c 24 f8 00 00 00 	decq   0xf8(%rsp)
 18bbbce:	48 ff c1             	inc    %rcx
 18bbbd1:	ff c0                	inc    %eax
 18bbbd3:	48 89 84 24 80 00 00 00 	mov    %rax,0x80(%rsp)
 18bbbdb:	48 89 4c 24 40       	mov    %rcx,0x40(%rsp)
 18bbbe0:	39 4c 24 58          	cmp    %ecx,0x58(%rsp)
 18bbbe4:	0f 84 d7 0e 00 00    	je     18bcac1 <tier0_tables_open+0x55f1>
 18bbbea:	48 8b 04 24          	mov    (%rsp),%rax
 18bbbee:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
 18bbbf3:	c5 fc 47 c8          	kxorw  %k0,%k0,%k1
 18bbbf7:	48 8b 80 d0 00 00 00 	mov    0xd0(%rax),%rax
 18bbbfe:	0f b6 0c 08          	movzbl (%rax,%rcx,1),%ecx
 18bbc02:	f6 c1 02             	test   $0x2,%cl
 18bbc05:	74 1a                	je     18bbc21 <tier0_tables_open+0x4751>
 18bbc07:	48 8b 04 24          	mov    (%rsp),%rax
 18bbc0b:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
 18bbc10:	48 8b 80 b0 00 00 00 	mov    0xb0(%rax),%rax
 18bbc17:	83 3c 90 01          	cmpl   $0x1,(%rax,%rdx,4)
 18bbc1b:	19 c0                	sbb    %eax,%eax
 18bbc1d:	c5 fb 92 c8          	kmovd  %eax,%k1
 18bbc21:	48 8b 14 24          	mov    (%rsp),%rdx
 18bbc25:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
 18bbc2a:	48 8b 82 b8 00 00 00 	mov    0xb8(%rdx),%rax
 18bbc31:	48 8b 12             	mov    (%rdx),%rdx
 18bbc34:	8b 04 b0             	mov    (%rax,%rsi,4),%eax
 18bbc37:	c1 e8 03             	shr    $0x3,%eax
 18bbc3a:	80 3c 02 0f          	cmpb   $0xf,(%rdx,%rax,1)
 18bbc3e:	48 89 c2             	mov    %rax,%rdx
 18bbc41:	75 0e                	jne    18bbc51 <tier0_tables_open+0x4781>
 18bbc43:	48 8b 14 24          	mov    (%rsp),%rdx
 18bbc47:	48 8b 52 20          	mov    0x20(%rdx),%rdx
 18bbc4b:	8b 14 82             	mov    (%rdx,%rax,4),%edx
 18bbc4e:	c1 ea 03             	shr    $0x3,%edx
 18bbc51:	48 8b 34 24          	mov    (%rsp),%rsi
 18bbc55:	48 83 bc 24 b8 00 00 00 11 	cmpq   $0x11,0xb8(%rsp)
 18bbc5e:	48 8b 7e 38          	mov    0x38(%rsi),%rdi
 18bbc62:	4c 8b 0c d7          	mov    (%rdi,%rdx,8),%r9
 18bbc66:	48 8b be d8 00 00 00 	mov    0xd8(%rsi),%rdi
 18bbc6d:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
 18bbc72:	48 8b 14 f7          	mov    (%rdi,%rsi,8),%rdx
 18bbc76:	72 42                	jb     18bbcba <tier0_tables_open+0x47ea>
 18bbc78:	80 bc 24 d0 00 00 00 11 	cmpb   $0x11,0xd0(%rsp)
 18bbc80:	74 17                	je     18bbc99 <tier0_tables_open+0x47c9>
 18bbc82:	c4 e2 79 78 05 35 4b c6 fe 	vpbroadcastb -0x139b4cb(%rip),%xmm0        # 5207c0 <branch_sizing_patterns+0xa30>
 18bbc8b:	4c 39 8c 24 b8 00 00 00 	cmp    %r9,0xb8(%rsp)
 18bbc93:	0f 85 67 01 00 00    	jne    18bbe00 <tier0_tables_open+0x4930>
 18bbc99:	48 8b 34 24          	mov    (%rsp),%rsi
 18bbc9d:	c4 e2 79 78 05 1a 4b c6 fe 	vpbroadcastb -0x139b4e6(%rip),%xmm0        # 5207c0 <branch_sizing_patterns+0xa30>
 18bbca6:	8b be bc 01 00 00    	mov    0x1bc(%rsi),%edi
 18bbcac:	48 39 bc 24 b8 00 00 00 	cmp    %rdi,0xb8(%rsp)
 18bbcb4:	0f 87 46 01 00 00    	ja     18bbe00 <tier0_tables_open+0x4930>
 18bbcba:	f6 c1 02             	test   $0x2,%cl
 18bbcbd:	0f 85 ba 00 00 00    	jne    18bbd7d <tier0_tables_open+0x48ad>
 18bbcc3:	48 c1 ea 03          	shr    $0x3,%rdx
 18bbcc7:	31 ff                	xor    %edi,%edi
 18bbcc9:	4d 85 c9             	test   %r9,%r9
 18bbccc:	75 1b                	jne    18bbce9 <tier0_tables_open+0x4819>
 18bbcce:	48 85 d2             	test   %rdx,%rdx
 18bbcd1:	74 16                	je     18bbce9 <tier0_tables_open+0x4819>
 18bbcd3:	48 8b 0c 24          	mov    (%rsp),%rcx
 18bbcd7:	be 0d 01 00 00       	mov    $0x10d,%esi
 18bbcdc:	48 8b 89 88 01 00 00 	mov    0x188(%rcx),%rcx
 18bbce3:	c4 e2 48 f7 3c 81    	bextr  %esi,(%rcx,%rax,4),%edi
 18bbce9:	48 8b 34 24          	mov    (%rsp),%rsi
 18bbced:	62 f2 7d 08 7a c2    	vpbroadcastb %edx,%xmm0
 18bbcf3:	c5 f9 fc 05 15 9f cb fe 	vpaddb -0x13460eb(%rip),%xmm0,%xmm0        # 575c10 <x86_effects_unknown+0x1b0>
 18bbcfb:	b1 10                	mov    $0x10,%cl
 18bbcfd:	41 b8 fe ff ff ff    	mov    $0xfffffffe,%r8d
 18bbd03:	28 d1                	sub    %dl,%cl
 18bbd05:	62 f1 7d 18 db 1d b5 47 cc fe 	vpandd -0x133b84b(%rip){1to4},%xmm0,%xmm3        # 5804c4 <tier0_emit_x87.operations+0x7c>
 18bbd0f:	4c 8b 96 98 01 00 00 	mov    0x198(%rsi),%r10
 18bbd16:	4c 8b 8e 80 01 00 00 	mov    0x180(%rsi),%r9
 18bbd1d:	be ff ff ff ff       	mov    $0xffffffff,%esi
 18bbd22:	45 0f b6 14 02       	movzbl (%r10,%rax,1),%r10d
 18bbd27:	41 80 fa 07          	cmp    $0x7,%r10b
 18bbd2b:	c4 62 29 f7 d6       	shlx   %r10d,%esi,%r10d
 18bbd30:	be 7f 00 00 00       	mov    $0x7f,%esi
 18bbd35:	41 f6 d2             	not    %r10b
 18bbd38:	41 0f b6 d2          	movzbl %r10b,%edx
 18bbd3c:	0f 43 d6             	cmovae %esi,%edx
 18bbd3f:	41 d3 c0             	rol    %cl,%r8d
 18bbd42:	40 84 ff             	test   %dil,%dil
 18bbd45:	be ff ff 00 00       	mov    $0xffff,%esi
 18bbd4a:	44 0f 44 c6          	cmove  %esi,%r8d
 18bbd4e:	48 c1 e0 04          	shl    $0x4,%rax
 18bbd52:	62 f2 7d 08 7a ca    	vpbroadcastb %edx,%xmm1
 18bbd58:	c4 c1 7b 92 d0       	kmovd  %r8d,%k2
 18bbd5d:	c4 c1 79 6f 14 01    	vmovdqa (%r9,%rax,1),%xmm2
 18bbd63:	62 f2 76 0a 26 d0    	vptestnmb %xmm0,%xmm1,%k2{%k2}
 18bbd69:	c4 e2 79 78 05 4e 4a c6 fe 	vpbroadcastb -0x139b5b2(%rip),%xmm0        # 5207c0 <branch_sizing_patterns+0xa30>
 18bbd72:	62 f2 6d 0a 00 c3    	vpshufb %xmm3,%xmm2,%xmm0{%k2}
 18bbd78:	e9 83 00 00 00       	jmp    18bbe00 <tier0_tables_open+0x4930>
 18bbd7d:	48 8b 04 24          	mov    (%rsp),%rax
 18bbd81:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
 18bbd86:	bf 47 00 00 00       	mov    $0x47,%edi
 18bbd8b:	41 b9 48 00 00 00    	mov    $0x48,%r9d
 18bbd91:	29 d7                	sub    %edx,%edi
 18bbd93:	c1 ef 03             	shr    $0x3,%edi
 18bbd96:	48 8b 80 c0 00 00 00 	mov    0xc0(%rax),%rax
 18bbd9d:	8b 04 88             	mov    (%rax,%rcx,4),%eax
 18bbda0:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
 18bbda4:	48 8d 44 02 bf       	lea    -0x41(%rdx,%rax,1),%rax
 18bbda9:	41 29 c9             	sub    %ecx,%r9d
 18bbdac:	b9 00 00 00 00       	mov    $0x0,%ecx
 18bbdb1:	41 c1 e9 03          	shr    $0x3,%r9d
 18bbdb5:	48 83 fa 40          	cmp    $0x40,%rdx
 18bbdb9:	0f 43 f9             	cmovae %ecx,%edi
 18bbdbc:	48 83 f8 c0          	cmp    $0xffffffffffffffc0,%rax
 18bbdc0:	44 0f 42 c9          	cmovb  %ecx,%r9d
 18bbdc4:	62 f2 7d 08 7a c7    	vpbroadcastb %edi,%xmm0
 18bbdca:	62 f3 7d 08 3e 15 3b 9e cb fe 06 	vpcmpnleub -0x13461c5(%rip),%xmm0,%k2        # 575c10 <x86_effects_unknown+0x1b0>
 18bbdd5:	62 d2 7d 08 7a c1    	vpbroadcastb %r9d,%xmm0
 18bbddb:	62 f3 7d 08 3e 1d 6a 9e cb fe 05 	vpcmpnltub -0x1346196(%rip),%xmm0,%k3        # 575c50 <x86_effects_unknown+0x1f0>
 18bbde6:	62 f1 7f 8b 6f 0d 70 9e cb fe 	vmovdqu8 -0x1346190(%rip),%xmm1{%k3}{z}        # 575c60 <x86_effects_unknown+0x200>
 18bbdf0:	62 f1 75 18 eb 05 ce 46 cc fe 	vpord  -0x133b932(%rip){1to4},%xmm1,%xmm0        # 5804c8 <tier0_emit_x87.operations+0x80>
 18bbdfa:	62 f1 7f 0a 6f c1    	vmovdqu8 %xmm1,%xmm0{%k2}
 18bbe00:	48 8b 84 24 80 00 00 00 	mov    0x80(%rsp),%rax
 18bbe08:	62 f1 7f 09 6f 05 7e 9e cb fe 	vmovdqu8 -0x1346182(%rip),%xmm0{%k1}        # 575c90 <x86_effects_unknown+0x230>
 18bbe12:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
 18bbe17:	89 c0                	mov    %eax,%eax
 18bbe19:	48 89 84 24 80 00 00 00 	mov    %rax,0x80(%rsp)
 18bbe21:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
 18bbe26:	48 c1 e0 06          	shl    $0x6,%rax
 18bbe2a:	80 bc 24 00 01 00 00 00 	cmpb   $0x0,0x100(%rsp)
 18bbe32:	c5 f9 7f 04 01       	vmovdqa %xmm0,(%rcx,%rax,1)
 18bbe37:	0f 84 77 fd ff ff    	je     18bbbb4 <tier0_tables_open+0x46e4>
 18bbe3d:	48 8b 04 24          	mov    (%rsp),%rax
 18bbe41:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
 18bbe46:	4c 8b a8 b8 00 00 00 	mov    0xb8(%rax),%r13
 18bbe4d:	48 8b 00             	mov    (%rax),%rax
 18bbe50:	45 8b 54 8d 00       	mov    0x0(%r13,%rcx,4),%r10d
 18bbe55:	48 89 84 24 90 00 00 00 	mov    %rax,0x90(%rsp)
 18bbe5d:	41 c1 ea 03          	shr    $0x3,%r10d
 18bbe61:	42 80 3c 10 0f       	cmpb   $0xf,(%rax,%r10,1)
 18bbe66:	4c 89 d0             	mov    %r10,%rax
 18bbe69:	75 0f                	jne    18bbe7a <tier0_tables_open+0x49aa>
 18bbe6b:	48 8b 04 24          	mov    (%rsp),%rax
 18bbe6f:	48 8b 40 20          	mov    0x20(%rax),%rax
 18bbe73:	42 8b 04 90          	mov    (%rax,%r10,4),%eax
 18bbe77:	c1 e8 03             	shr    $0x3,%eax
 18bbe7a:	48 8b 14 24          	mov    (%rsp),%rdx
 18bbe7e:	48 8b 4a 38          	mov    0x38(%rdx),%rcx
 18bbe82:	48 8b 3c c1          	mov    (%rcx,%rax,8),%rdi
 18bbe86:	48 8b 8a c0 00 00 00 	mov    0xc0(%rdx),%rcx
 18bbe8d:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
 18bbe92:	48 8b 92 d0 00 00 00 	mov    0xd0(%rdx),%rdx
 18bbe99:	44 8b 1c 81          	mov    (%rcx,%rax,4),%r11d
 18bbe9d:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
 18bbea1:	48 8d 2c fd 00 00 00 00 	lea    0x0(,%rdi,8),%rbp
 18bbea9:	48 89 8c 24 30 01 00 00 	mov    %rcx,0x130(%rsp)
 18bbeb1:	48 89 94 24 38 01 00 00 	mov    %rdx,0x138(%rsp)
 18bbeb9:	4d 85 db             	test   %r11,%r11
 18bbebc:	4c 89 9c 24 08 01 00 00 	mov    %r11,0x108(%rsp)
 18bbec4:	88 84 24 d8 00 00 00 	mov    %al,0xd8(%rsp)
 18bbecb:	41 0f 95 c0          	setne  %r8b
 18bbecf:	a8 02                	test   $0x2,%al
 18bbed1:	48 b8 f8 ff ff ff 01 00 00 00 	movabs $0x1fffffff8,%rax
 18bbedb:	0f 94 44 24 70       	sete   0x70(%rsp)
 18bbee0:	4c 39 dd             	cmp    %r11,%rbp
 18bbee3:	4c 0f 42 dd          	cmovb  %rbp,%r11
 18bbee7:	45 31 ff             	xor    %r15d,%r15d
 18bbeea:	49 83 c3 07          	add    $0x7,%r11
 18bbeee:	49 21 c3             	and    %rax,%r11
 18bbef1:	49 83 fb 09          	cmp    $0x9,%r11
 18bbef5:	72 26                	jb     18bbf1d <tier0_tables_open+0x4a4d>
 18bbef7:	41 bf 01 00 00 00    	mov    $0x1,%r15d
 18bbefd:	49 83 fb 11          	cmp    $0x11,%r11
 18bbf01:	72 1a                	jb     18bbf1d <tier0_tables_open+0x4a4d>
 18bbf03:	41 bf 02 00 00 00    	mov    $0x2,%r15d
 18bbf09:	49 83 fb 21          	cmp    $0x21,%r11
 18bbf0d:	72 0e                	jb     18bbf1d <tier0_tables_open+0x4a4d>
 18bbf0f:	49 83 fb 41          	cmp    $0x41,%r11
 18bbf13:	41 bf 04 00 00 00    	mov    $0x4,%r15d
 18bbf19:	41 83 df 00          	sbb    $0x0,%r15d
 18bbf1d:	48 8b 04 24          	mov    (%rsp),%rax
 18bbf21:	48 8b 88 d8 00 00 00 	mov    0xd8(%rax),%rcx
 18bbf28:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
 18bbf2d:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
 18bbf31:	48 89 8c 24 90 01 00 00 	mov    %rcx,0x190(%rsp)
 18bbf39:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
 18bbf3e:	48 c1 e8 03          	shr    $0x3,%rax
 18bbf42:	f6 84 24 d8 00 00 00 02 	testb  $0x2,0xd8(%rsp)
 18bbf4a:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
 18bbf4f:	74 39                	je     18bbf8a <tier0_tables_open+0x4aba>
 18bbf51:	31 c0                	xor    %eax,%eax
 18bbf53:	c4 e2 f8 f3 cf       	blsr   %rdi,%rax
 18bbf58:	0f 94 c0             	sete   %al
 18bbf5b:	48 85 ed             	test   %rbp,%rbp
 18bbf5e:	0f 94 c1             	sete   %cl
 18bbf61:	08 c1                	or     %al,%cl
 18bbf63:	0f 85 93 00 00 00    	jne    18bbffc <tier0_tables_open+0x4b2c>
 18bbf69:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
 18bbf6e:	48 09 e8             	or     %rbp,%rax
 18bbf71:	48 c1 e8 20          	shr    $0x20,%rax
 18bbf75:	0f 84 8e 00 00 00    	je     18bc009 <tier0_tables_open+0x4b39>
 18bbf7b:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
 18bbf80:	31 d2                	xor    %edx,%edx
 18bbf82:	48 f7 f5             	div    %rbp
 18bbf85:	e9 88 00 00 00       	jmp    18bc012 <tier0_tables_open+0x4b42>
 18bbf8a:	48 8b 04 24          	mov    (%rsp),%rax
 18bbf8e:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
 18bbf93:	4c 8b 4c 24 38       	mov    0x38(%rsp),%r9
 18bbf98:	48 89 bc 24 18 01 00 00 	mov    %rdi,0x118(%rsp)
 18bbfa0:	48 8b 80 a8 01 00 00 	mov    0x1a8(%rax),%rax
 18bbfa7:	8d 0c 36             	lea    (%rsi,%rsi,1),%ecx
 18bbfaa:	49 f7 c1 88 ff ff ff 	test   $0xffffffffffffff88,%r9
 18bbfb1:	4a 8b 04 d0          	mov    (%rax,%r10,8),%rax
 18bbfb5:	c4 e2 f1 f7 c8       	shlx   %rcx,%rax,%rcx
 18bbfba:	89 ca                	mov    %ecx,%edx
 18bbfbc:	b9 00 00 00 00       	mov    $0x0,%ecx
 18bbfc1:	48 0f 45 d1          	cmovne %rcx,%rdx
 18bbfc5:	48 c1 e8 20          	shr    $0x20,%rax
 18bbfc9:	48 89 94 24 10 01 00 00 	mov    %rdx,0x110(%rsp)
 18bbfd1:	c4 e2 c9 f7 d0       	shlx   %rsi,%rax,%rdx
 18bbfd6:	48 b8 00 00 00 00 ff ff 00 00 	movabs $0xffff00000000,%rax
 18bbfe0:	48 c1 e2 20          	shl    $0x20,%rdx
 18bbfe4:	48 21 c2             	and    %rax,%rdx
 18bbfe7:	49 81 f9 80 00 00 00 	cmp    $0x80,%r9
 18bbfee:	48 89 f0             	mov    %rsi,%rax
 18bbff1:	48 0f 43 d1          	cmovae %rcx,%rdx
 18bbff5:	b1 01                	mov    $0x1,%cl
 18bbff7:	e9 f1 00 00 00       	jmp    18bc0ed <tier0_tables_open+0x4c1d>
 18bbffc:	48 89 f8             	mov    %rdi,%rax
 18bbfff:	48 f7 d8             	neg    %rax
 18bc002:	48 23 44 24 60       	and    0x60(%rsp),%rax
 18bc007:	eb 0d                	jmp    18bc016 <tier0_tables_open+0x4b46>
 18bc009:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
 18bc00e:	31 d2                	xor    %edx,%edx
 18bc010:	f7 f5                	div    %ebp
 18bc012:	48 0f af c7          	imul   %rdi,%rax
 18bc016:	80 bc 24 d0 00 00 00 11 	cmpb   $0x11,0xd0(%rsp)
 18bc01e:	b9 01 00 00 00       	mov    $0x1,%ecx
 18bc023:	be 00 00 00 00       	mov    $0x0,%esi
 18bc028:	41 bc 10 00 00 00    	mov    $0x10,%r12d
 18bc02e:	c4 e2 81 f7 d1       	shlx   %r15,%rcx,%rdx
 18bc033:	48 0f 45 d7          	cmovne %rdi,%rdx
 18bc037:	48 0f 44 c6          	cmove  %rsi,%rax
 18bc03b:	f3 48 0f b8 ca       	popcnt %rdx,%rcx
 18bc040:	48 89 94 24 18 01 00 00 	mov    %rdx,0x118(%rsp)
 18bc048:	f3 48 0f bc d2       	tzcnt  %rdx,%rdx
 18bc04d:	44 8d 4a 01          	lea    0x1(%rdx),%r9d
 18bc051:	48 83 fa 04          	cmp    $0x4,%rdx
 18bc055:	ba 09 00 00 00       	mov    $0x9,%edx
 18bc05a:	4c 0f 43 ca          	cmovae %rdx,%r9
 18bc05e:	83 f9 01             	cmp    $0x1,%ecx
 18bc061:	8d 0c 00             	lea    (%rax,%rax,1),%ecx
 18bc064:	4c 0f 45 ca          	cmovne %rdx,%r9
 18bc068:	48 a9 f1 ff ff ff    	test   $0xfffffffffffffff1,%rax
 18bc06e:	c4 c2 f1 f7 d1       	shlx   %rcx,%r9,%rdx
 18bc073:	41 b9 10 00 00 00    	mov    $0x10,%r9d
 18bc079:	89 d2                	mov    %edx,%edx
 18bc07b:	48 0f 45 d6          	cmovne %rsi,%rdx
 18bc07f:	48 89 94 24 10 01 00 00 	mov    %rdx,0x110(%rsp)
 18bc087:	ba 0f 00 00 00       	mov    $0xf,%edx
 18bc08c:	c4 e2 f1 f7 ca       	shlx   %rcx,%rdx,%rcx
 18bc091:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
 18bc096:	48 0f 45 ce          	cmovne %rsi,%rcx
 18bc09a:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
 18bc09f:	48 8d 54 15 ff       	lea    -0x1(%rbp,%rdx,1),%rdx
 18bc0a4:	48 c1 ea 03          	shr    $0x3,%rdx
 18bc0a8:	48 29 f2             	sub    %rsi,%rdx
 18bc0ab:	48 ff c2             	inc    %rdx
 18bc0ae:	48 83 fe 10          	cmp    $0x10,%rsi
 18bc0b2:	4c 0f 42 ce          	cmovb  %rsi,%r9
 18bc0b6:	be 10 00 00 00       	mov    $0x10,%esi
 18bc0bb:	4d 29 cc             	sub    %r9,%r12
 18bc0be:	4c 39 e2             	cmp    %r12,%rdx
 18bc0c1:	42 8d 14 0a          	lea    (%rdx,%r9,1),%edx
 18bc0c5:	0f 43 d6             	cmovae %esi,%edx
 18bc0c8:	48 c7 c6 ff ff ff ff 	mov    $0xffffffffffffffff,%rsi
 18bc0cf:	44 29 ca             	sub    %r9d,%edx
 18bc0d2:	c4 e2 e9 f7 d6       	shlx   %rdx,%rsi,%rdx
 18bc0d7:	f7 d2                	not    %edx
 18bc0d9:	c4 e2 b1 f7 d2       	shlx   %r9,%rdx,%rdx
 18bc0de:	48 c1 e2 20          	shl    $0x20,%rdx
 18bc0e2:	48 85 8c 24 28 01 00 00 	test   %rcx,0x128(%rsp)
 18bc0ea:	0f 94 c1             	sete   %cl
 18bc0ed:	44 89 c6             	mov    %r8d,%esi
 18bc0f0:	40 0a 74 24 70       	or     0x70(%rsp),%sil
 18bc0f5:	f6 c1 01             	test   $0x1,%cl
 18bc0f8:	44 0f b6 8c 24 d0 00 00 00 	movzbl 0xd0(%rsp),%r9d
 18bc101:	bd 00 00 00 00       	mov    $0x0,%ebp
 18bc106:	b9 00 00 00 00       	mov    $0x0,%ecx
 18bc10b:	48 0f 45 ac 24 10 01 00 00 	cmovne 0x110(%rsp),%rbp
 18bc114:	41 80 f9 11          	cmp    $0x11,%r9b
 18bc118:	40 88 b4 24 40 01 00 00 	mov    %sil,0x140(%rsp)
 18bc120:	48 0f 44 e9          	cmove  %rcx,%rbp
 18bc124:	40 84 f6             	test   %sil,%sil
 18bc127:	48 0f 44 e9          	cmove  %rcx,%rbp
 18bc12b:	41 80 f9 11          	cmp    $0x11,%r9b
 18bc12f:	75 2e                	jne    18bc15f <tier0_tables_open+0x4c8f>
 18bc131:	48 8b 04 24          	mov    (%rsp),%rax
 18bc135:	48 8b 80 a0 01 00 00 	mov    0x1a0(%rax),%rax
 18bc13c:	42 0f b6 04 10       	movzbl (%rax,%r10,1),%eax
 18bc141:	88 44 24 70          	mov    %al,0x70(%rsp)
 18bc145:	31 c0                	xor    %eax,%eax
 18bc147:	49 81 fb 80 00 00 00 	cmp    $0x80,%r11
 18bc14e:	0f 94 c0             	sete   %al
 18bc151:	45 31 db             	xor    %r11d,%r11d
 18bc154:	c1 e0 04             	shl    $0x4,%eax
 18bc157:	41 09 c7             	or     %eax,%r15d
 18bc15a:	e9 bf 02 00 00       	jmp    18bc41e <tier0_tables_open+0x4f4e>
 18bc15f:	44 0f b6 84 24 d8 00 00 00 	movzbl 0xd8(%rsp),%r8d
 18bc168:	48 83 bc 24 08 01 00 00 00 	cmpq   $0x0,0x108(%rsp)
 18bc171:	41 b9 10 00 00 00    	mov    $0x10,%r9d
 18bc177:	45 89 c3             	mov    %r8d,%r11d
 18bc17a:	0f 95 c1             	setne  %cl
 18bc17d:	41 b8 10 00 00 00    	mov    $0x10,%r8d
 18bc183:	41 80 e3 02          	and    $0x2,%r11b
 18bc187:	41 d0 eb             	shr    $1,%r11b
 18bc18a:	48 83 f8 10          	cmp    $0x10,%rax
 18bc18e:	49 0f 43 c0          	cmovae %r8,%rax
 18bc192:	4c 8b 04 24          	mov    (%rsp),%r8
 18bc196:	49 29 c1             	sub    %rax,%r9
 18bc199:	8d 34 07             	lea    (%rdi,%rax,1),%esi
 18bc19c:	4c 39 cf             	cmp    %r9,%rdi
 18bc19f:	41 b9 10 00 00 00    	mov    $0x10,%r9d
 18bc1a5:	41 0f 43 f1          	cmovae %r9d,%esi
 18bc1a9:	41 20 cb             	and    %cl,%r11b
 18bc1ac:	49 8b b8 a0 01 00 00 	mov    0x1a0(%r8),%rdi
 18bc1b3:	48 89 fb             	mov    %rdi,%rbx
 18bc1b6:	42 0f b6 3c 17       	movzbl (%rdi,%r10,1),%edi
 18bc1bb:	40 88 7c 24 70       	mov    %dil,0x70(%rsp)
 18bc1c0:	41 80 fb 01          	cmp    $0x1,%r11b
 18bc1c4:	0f 85 15 02 00 00    	jne    18bc3df <tier0_tables_open+0x4f0f>
 18bc1ca:	8b 4c 24 20          	mov    0x20(%rsp),%ecx
 18bc1ce:	48 39 4c 24 10       	cmp    %rcx,0x10(%rsp)
 18bc1d3:	0f 82 06 02 00 00    	jb     18bc3df <tier0_tables_open+0x4f0f>
 18bc1d9:	4c 8b 44 24 10       	mov    0x10(%rsp),%r8
 18bc1de:	48 8b 8c 24 08 01 00 00 	mov    0x108(%rsp),%rcx
 18bc1e6:	48 8b 7c 24 38       	mov    0x38(%rsp),%rdi
 18bc1eb:	41 ff c0             	inc    %r8d
 18bc1ee:	48 01 cf             	add    %rcx,%rdi
 18bc1f1:	4c 89 44 24 20       	mov    %r8,0x20(%rsp)
 18bc1f6:	44 3b 84 24 e0 00 00 00 	cmp    0xe0(%rsp),%r8d
 18bc1fe:	0f 83 ac 00 00 00    	jae    18bc2b0 <tier0_tables_open+0x4de0>
 18bc204:	4c 8b 84 24 80 00 00 00 	mov    0x80(%rsp),%r8
 18bc20c:	4c 8b 94 24 98 01 00 00 	mov    0x198(%rsp),%r10
 18bc214:	4c 8b bc 24 38 01 00 00 	mov    0x138(%rsp),%r15
 18bc21c:	48 c7 44 24 20 00 00 00 00 	movq   $0x0,0x20(%rsp)
 18bc225:	4a 8d 0c 85 00 00 00 00 	lea    0x0(,%r8,4),%rcx
 18bc22d:	4e 8d 0c c5 00 00 00 00 	lea    0x0(,%r8,8),%r9
 18bc235:	48 03 8c 24 30 01 00 00 	add    0x130(%rsp),%rcx
 18bc23d:	4c 03 8c 24 90 01 00 00 	add    0x190(%rsp),%r9
 18bc245:	4d 29 c2             	sub    %r8,%r10
 18bc248:	4d 01 f8             	add    %r15,%r8
 18bc24b:	4c 89 84 24 a8 00 00 00 	mov    %r8,0xa8(%rsp)
 18bc253:	4c 8b 44 24 20       	mov    0x20(%rsp),%r8
 18bc258:	4c 8b bc 24 a8 00 00 00 	mov    0xa8(%rsp),%r15
 18bc260:	43 f6 04 07 02       	testb  $0x2,(%r15,%r8,1)
 18bc265:	74 38                	je     18bc29f <tier0_tables_open+0x4dcf>
 18bc267:	4c 8b 44 24 20       	mov    0x20(%rsp),%r8
 18bc26c:	4f 8b 3c c1          	mov    (%r9,%r8,8),%r15
 18bc270:	41 f6 c7 07          	test   $0x7,%r15b
 18bc274:	74 29                	je     18bc29f <tier0_tables_open+0x4dcf>
 18bc276:	4c 8b 44 24 20       	mov    0x20(%rsp),%r8
 18bc27b:	46 8b 24 81          	mov    (%rcx,%r8,4),%r12d
 18bc27f:	4d 01 e7             	add    %r12,%r15
 18bc282:	49 39 ff             	cmp    %rdi,%r15
 18bc285:	49 0f 47 ff          	cmova  %r15,%rdi
 18bc289:	49 ff c0             	inc    %r8
 18bc28c:	4c 89 44 24 20       	mov    %r8,0x20(%rsp)
 18bc291:	4d 39 c2             	cmp    %r8,%r10
 18bc294:	75 bd                	jne    18bc253 <tier0_tables_open+0x4d83>
 18bc296:	8b 8c 24 e0 00 00 00 	mov    0xe0(%rsp),%ecx
 18bc29d:	eb 0c                	jmp    18bc2ab <tier0_tables_open+0x4ddb>
 18bc29f:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
 18bc2a4:	2b 8c 24 f8 00 00 00 	sub    0xf8(%rsp),%ecx
 18bc2ab:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
 18bc2b0:	48 2b 7c 24 38       	sub    0x38(%rsp),%rdi
 18bc2b5:	b1 ff                	mov    $0xff,%cl
 18bc2b7:	89 8c 24 e4 00 00 00 	mov    %ecx,0xe4(%rsp)
 18bc2be:	48 83 c7 07          	add    $0x7,%rdi
 18bc2c2:	48 83 ff 48          	cmp    $0x48,%rdi
 18bc2c6:	0f 82 03 01 00 00    	jb     18bc3cf <tier0_tables_open+0x4eff>
 18bc2cc:	48 8b 8c 24 b8 00 00 00 	mov    0xb8(%rsp),%rcx
 18bc2d4:	4c 8b 44 24 20       	mov    0x20(%rsp),%r8
 18bc2d9:	44 3b 84 24 e0 00 00 00 	cmp    0xe0(%rsp),%r8d
 18bc2e1:	0f 83 ad 00 00 00    	jae    18bc394 <tier0_tables_open+0x4ec4>
 18bc2e7:	44 8b 54 24 20       	mov    0x20(%rsp),%r10d
 18bc2ec:	48 8b 8c 24 38 01 00 00 	mov    0x138(%rsp),%rcx
 18bc2f4:	46 0f b6 0c 11       	movzbl (%rcx,%r10,1),%r9d
 18bc2f9:	b1 01                	mov    $0x1,%cl
 18bc2fb:	41 f6 c1 02          	test   $0x2,%r9b
 18bc2ff:	74 10                	je     18bc311 <tier0_tables_open+0x4e41>
 18bc301:	48 8b 8c 24 30 01 00 00 	mov    0x130(%rsp),%rcx
 18bc309:	42 83 3c 91 00       	cmpl   $0x0,(%rcx,%r10,4)
 18bc30e:	0f 95 c1             	setne  %cl
 18bc311:	47 8b 64 95 00       	mov    0x0(%r13,%r10,4),%r12d
 18bc316:	4c 8b 84 24 90 00 00 00 	mov    0x90(%rsp),%r8
 18bc31e:	41 c1 ec 03          	shr    $0x3,%r12d
 18bc322:	43 80 3c 20 0f       	cmpb   $0xf,(%r8,%r12,1)
 18bc327:	75 23                	jne    18bc34c <tier0_tables_open+0x4e7c>
 18bc329:	4c 8b 04 24          	mov    (%rsp),%r8
 18bc32d:	4d 8b 78 20          	mov    0x20(%r8),%r15
 18bc331:	47 8b 24 a7          	mov    (%r15,%r12,4),%r12d
 18bc335:	41 c1 ec 03          	shr    $0x3,%r12d
 18bc339:	41 b7 01             	mov    $0x1,%r15b
 18bc33c:	41 f6 c1 02          	test   $0x2,%r9b
 18bc340:	74 13                	je     18bc355 <tier0_tables_open+0x4e85>
 18bc342:	44 20 f9             	and    %r15b,%cl
 18bc345:	80 f9 01             	cmp    $0x1,%cl
 18bc348:	75 1f                	jne    18bc369 <tier0_tables_open+0x4e99>
 18bc34a:	eb 38                	jmp    18bc384 <tier0_tables_open+0x4eb4>
 18bc34c:	41 b7 01             	mov    $0x1,%r15b
 18bc34f:	41 f6 c1 02          	test   $0x2,%r9b
 18bc353:	75 ed                	jne    18bc342 <tier0_tables_open+0x4e72>
 18bc355:	45 89 e1             	mov    %r12d,%r9d
 18bc358:	42 f6 04 0b 20       	testb  $0x20,(%rbx,%r9,1)
 18bc35d:	41 0f 94 c7          	sete   %r15b
 18bc361:	44 20 f9             	and    %r15b,%cl
 18bc364:	80 f9 01             	cmp    $0x1,%cl
 18bc367:	74 1b                	je     18bc384 <tier0_tables_open+0x4eb4>
 18bc369:	49 ff c2             	inc    %r10
 18bc36c:	4c 39 94 24 98 01 00 00 	cmp    %r10,0x198(%rsp)
 18bc374:	0f 85 72 ff ff ff    	jne    18bc2ec <tier0_tables_open+0x4e1c>
 18bc37a:	48 8b 8c 24 b8 00 00 00 	mov    0xb8(%rsp),%rcx
 18bc382:	eb 10                	jmp    18bc394 <tier0_tables_open+0x4ec4>
 18bc384:	48 8b 8c 24 90 01 00 00 	mov    0x190(%rsp),%rcx
 18bc38c:	4a 8b 0c d1          	mov    (%rcx,%r10,8),%rcx
 18bc390:	48 c1 e9 03          	shr    $0x3,%rcx
 18bc394:	4c 8b 44 24 60       	mov    0x60(%rsp),%r8
 18bc399:	48 c1 ef 03          	shr    $0x3,%rdi
 18bc39d:	48 83 c7 0f          	add    $0xf,%rdi
 18bc3a1:	48 83 e7 f0          	and    $0xfffffffffffffff0,%rdi
 18bc3a5:	48 83 ff 10          	cmp    $0x10,%rdi
 18bc3a9:	4e 8d 0c 07          	lea    (%rdi,%r8,1),%r9
 18bc3ad:	41 0f 94 c0          	sete   %r8b
 18bc3b1:	bf 00 00 00 00       	mov    $0x0,%edi
 18bc3b6:	41 c0 e0 04          	shl    $0x4,%r8b
 18bc3ba:	41 80 c8 04          	or     $0x4,%r8b
 18bc3be:	49 39 c9             	cmp    %rcx,%r9
 18bc3c1:	41 0f b6 c8          	movzbl %r8b,%ecx
 18bc3c5:	0f 47 cf             	cmova  %edi,%ecx
 18bc3c8:	89 8c 24 e4 00 00 00 	mov    %ecx,0xe4(%rsp)
 18bc3cf:	48 8b 9c 24 70 01 00 00 	mov    0x170(%rsp),%rbx
 18bc3d7:	48 89 9c 24 a8 00 00 00 	mov    %rbx,0xa8(%rsp)
 18bc3df:	29 c6                	sub    %eax,%esi
 18bc3e1:	48 c7 c1 ff ff ff ff 	mov    $0xffffffffffffffff,%rcx
 18bc3e8:	c4 e2 c9 f7 c9       	shlx   %rsi,%rcx,%rcx
 18bc3ed:	f7 d1                	not    %ecx
 18bc3ef:	c4 e2 f9 f7 c1       	shlx   %rax,%rcx,%rax
 18bc3f4:	8b 8c 24 e4 00 00 00 	mov    0xe4(%rsp),%ecx
 18bc3fb:	48 c1 e0 30          	shl    $0x30,%rax
 18bc3ff:	48 09 c2             	or     %rax,%rdx
 18bc402:	0f b6 44 24 70       	movzbl 0x70(%rsp),%eax
 18bc407:	44 0f b6 f9          	movzbl %cl,%r15d
 18bc40b:	24 0f                	and    $0xf,%al
 18bc40d:	80 f9 ff             	cmp    $0xff,%cl
 18bc410:	0f b6 c0             	movzbl %al,%eax
 18bc413:	44 0f 44 f8          	cmove  %eax,%r15d
 18bc417:	45 84 db             	test   %r11b,%r11b
 18bc41a:	44 0f 44 f8          	cmove  %eax,%r15d
 18bc41e:	44 0f b6 84 24 d8 00 00 00 	movzbl 0xd8(%rsp),%r8d
 18bc427:	0f b6 44 24 70       	movzbl 0x70(%rsp),%eax
 18bc42c:	41 0f b6 cf          	movzbl %r15b,%ecx
 18bc430:	41 f6 c0 02          	test   $0x2,%r8b
 18bc434:	0f 44 c8             	cmove  %eax,%ecx
 18bc437:	89 cf                	mov    %ecx,%edi
 18bc439:	83 e7 0f             	and    $0xf,%edi
 18bc43c:	48 83 7c 24 38 00    	cmpq   $0x0,0x38(%rsp)
 18bc442:	44 0f b6 c9          	movzbl %cl,%r9d
 18bc446:	0f 94 c0             	sete   %al
 18bc449:	22 84 24 40 01 00 00 	and    0x140(%rsp),%al
 18bc450:	48 83 bc 24 18 01 00 00 00 	cmpq   $0x0,0x118(%rsp)
 18bc459:	41 0f 95 c7          	setne  %r15b
 18bc45d:	41 20 c7             	and    %al,%r15b
 18bc460:	41 f6 c0 02          	test   $0x2,%r8b
 18bc464:	74 33                	je     18bc499 <tier0_tables_open+0x4fc9>
 18bc466:	80 bc 24 e4 00 00 00 ff 	cmpb   $0xff,0xe4(%rsp)
 18bc46e:	49 ba 00 00 00 00 00 00 08 00 	movabs $0x8000000000000,%r10
 18bc478:	b9 00 00 00 00       	mov    $0x0,%ecx
 18bc47d:	b8 00 00 00 00       	mov    $0x0,%eax
 18bc482:	4c 89 54 24 38       	mov    %r10,0x38(%rsp)
 18bc487:	41 0f 94 c4          	sete   %r12b
 18bc48b:	45 84 e3             	test   %r12b,%r11b
 18bc48e:	0f 84 c3 f5 ff ff    	je     18bba57 <tier0_tables_open+0x4587>
 18bc494:	e9 ca f5 ff ff       	jmp    18bba63 <tier0_tables_open+0x4593>
 18bc499:	c4 e2 40 f5 44 24 60 	bzhi   %edi,0x60(%rsp),%eax
 18bc4a0:	48 b9 00 00 00 00 00 00 01 00 	movabs $0x1000000000000,%rcx
 18bc4aa:	b8 00 00 00 00       	mov    $0x0,%eax
 18bc4af:	49 ba 00 00 00 00 00 00 08 00 	movabs $0x8000000000000,%r10
 18bc4b9:	4c 89 54 24 38       	mov    %r10,0x38(%rsp)
 18bc4be:	48 0f 44 c8          	cmove  %rax,%rcx
 18bc4c2:	f6 44 24 70 40       	testb  $0x40,0x70(%rsp)
 18bc4c7:	48 89 c8             	mov    %rcx,%rax
 18bc4ca:	0f 85 93 f5 ff ff    	jne    18bba63 <tier0_tables_open+0x4593>
 18bc4d0:	e9 82 f5 ff ff       	jmp    18bba57 <tier0_tables_open+0x4587>
 18bc4d5:	48 c7 44 24 58 00 00 00 00 	movq   $0x0,0x58(%rsp)
 18bc4de:	e9 cc 05 00 00       	jmp    18bcaaf <tier0_tables_open+0x55df>
 18bc4e3:	48 8b 74 24 58       	mov    0x58(%rsp),%rsi
 18bc4e8:	89 f2                	mov    %esi,%edx
 18bc4ea:	83 e2 07             	and    $0x7,%edx
 18bc4ed:	48 83 fe 08          	cmp    $0x8,%rsi
 18bc4f1:	73 07                	jae    18bc4fa <tier0_tables_open+0x502a>
 18bc4f3:	31 ff                	xor    %edi,%edi
 18bc4f5:	e9 42 02 00 00       	jmp    18bc73c <tier0_tables_open+0x526c>
 18bc4fa:	8d 34 cd 00 00 00 00 	lea    0x0(,%rcx,8),%esi
 18bc501:	8d 3c cd 00 00 00 00 	lea    0x0(,%rcx,8),%edi
 18bc508:	48 8b 5c 24 58       	mov    0x58(%rsp),%rbx
 18bc50d:	44 8d 24 8d 00 00 00 00 	lea    0x0(,%rcx,4),%r12d
 18bc515:	44 8d 2c 49          	lea    (%rcx,%rcx,2),%r13d
 18bc519:	8d 2c 09             	lea    (%rcx,%rcx,1),%ebp
 18bc51c:	41 ba c0 01 00 00    	mov    $0x1c0,%r10d
 18bc522:	45 31 c0             	xor    %r8d,%r8d
 18bc525:	29 ce                	sub    %ecx,%esi
 18bc527:	89 bc 24 80 00 00 00 	mov    %edi,0x80(%rsp)
 18bc52e:	8d 3c 09             	lea    (%rcx,%rcx,1),%edi
 18bc531:	48 89 74 24 10       	mov    %rsi,0x10(%rsp)
 18bc536:	8d 34 7f             	lea    (%rdi,%rdi,2),%esi
 18bc539:	31 ff                	xor    %edi,%edi
 18bc53b:	48 89 74 24 40       	mov    %rsi,0x40(%rsp)
 18bc540:	8d 34 89             	lea    (%rcx,%rcx,4),%esi
 18bc543:	48 83 e3 f8          	and    $0xfffffffffffffff8,%rbx
 18bc547:	48 89 74 24 20       	mov    %rsi,0x20(%rsp)
 18bc54c:	4d 8b 0e             	mov    (%r14),%r9
 18bc54f:	c5 f9 6f 15 b9 96 cb fe 	vmovdqa -0x1346947(%rip),%xmm2        # 575c10 <x86_effects_unknown+0x1b0>
 18bc557:	c4 e2 79 78 1d 61 42 c6 fe 	vpbroadcastb -0x139bd9f(%rip),%xmm3        # 5207c1 <branch_sizing_patterns+0xa31>
 18bc560:	62 d2 7d 08 7a c8    	vpbroadcastb %r8d,%xmm1
 18bc566:	4c 8b 7c 24 08       	mov    0x8(%rsp),%r15
 18bc56b:	4d 8d 9a 40 fe ff ff 	lea    -0x1c0(%r10),%r11
 18bc572:	48 be 00 fe ff ff 3f 00 00 00 	movabs $0x3ffffffe00,%rsi
 18bc57c:	48 83 c7 08          	add    $0x8,%rdi
 18bc580:	49 21 f3             	and    %rsi,%r11
 18bc583:	c4 c1 79 6f 04 01    	vmovdqa (%r9,%rax,1),%xmm0
 18bc589:	c5 f1 fc ca          	vpaddb %xmm2,%xmm1,%xmm1
 18bc58d:	c5 f1 db cb          	vpand  %xmm3,%xmm1,%xmm1
 18bc591:	c4 e2 79 00 c1       	vpshufb %xmm1,%xmm0,%xmm0
 18bc596:	c4 81 79 7f 04 1f    	vmovdqa %xmm0,(%r15,%r11,1)
 18bc59c:	4d 8d 9a 80 fe ff ff 	lea    -0x180(%r10),%r11
 18bc5a3:	4d 8b 0e             	mov    (%r14),%r9
 18bc5a6:	c4 c1 79 6f 04 01    	vmovdqa (%r9,%rax,1),%xmm0
 18bc5ac:	46 8d 0c 01          	lea    (%rcx,%r8,1),%r9d
 18bc5b0:	62 d2 7d 08 7a c9    	vpbroadcastb %r9d,%xmm1
 18bc5b6:	4c 8d 4e 40          	lea    0x40(%rsi),%r9
 18bc5ba:	c5 f1 fc ca          	vpaddb %xmm2,%xmm1,%xmm1
 18bc5be:	4d 21 cb             	and    %r9,%r11
 18bc5c1:	c5 f1 db cb          	vpand  %xmm3,%xmm1,%xmm1
 18bc5c5:	c4 e2 79 00 c1       	vpshufb %xmm1,%xmm0,%xmm0
 18bc5ca:	c4 81 79 7f 04 1f    	vmovdqa %xmm0,(%r15,%r11,1)
 18bc5d0:	46 8d 5c 05 00       	lea    0x0(%rbp,%r8,1),%r11d
 18bc5d5:	4d 8b 0e             	mov    (%r14),%r9
 18bc5d8:	62 d2 7d 08 7a cb    	vpbroadcastb %r11d,%xmm1
 18bc5de:	4c 8d 9e 80 00 00 00 	lea    0x80(%rsi),%r11
 18bc5e5:	c5 f1 fc ca          	vpaddb %xmm2,%xmm1,%xmm1
 18bc5e9:	c5 f1 db cb          	vpand  %xmm3,%xmm1,%xmm1
 18bc5ed:	c4 c1 79 6f 04 01    	vmovdqa (%r9,%rax,1),%xmm0
 18bc5f3:	4d 8d 8a c0 fe ff ff 	lea    -0x140(%r10),%r9
 18bc5fa:	4d 21 cb             	and    %r9,%r11
 18bc5fd:	c4 e2 79 00 c1       	vpshufb %xmm1,%xmm0,%xmm0
 18bc602:	c4 81 79 7f 04 1f    	vmovdqa %xmm0,(%r15,%r11,1)
 18bc608:	4d 8d 9a 00 ff ff ff 	lea    -0x100(%r10),%r11
 18bc60f:	4d 8b 0e             	mov    (%r14),%r9
 18bc612:	c4 c1 79 6f 04 01    	vmovdqa (%r9,%rax,1),%xmm0
 18bc618:	47 8d 4c 05 00       	lea    0x0(%r13,%r8,1),%r9d
 18bc61d:	62 d2 7d 08 7a c9    	vpbroadcastb %r9d,%xmm1
 18bc623:	4c 8d 8e c0 00 00 00 	lea    0xc0(%rsi),%r9
 18bc62a:	c5 f1 fc ca          	vpaddb %xmm2,%xmm1,%xmm1
 18bc62e:	4d 21 d9             	and    %r11,%r9
 18bc631:	c5 f1 db cb          	vpand  %xmm3,%xmm1,%xmm1
 18bc635:	c4 e2 79 00 c1       	vpshufb %xmm1,%xmm0,%xmm0
 18bc63a:	c4 81 79 7f 04 0f    	vmovdqa %xmm0,(%r15,%r9,1)
 18bc640:	4d 8d 8a 40 ff ff ff 	lea    -0xc0(%r10),%r9
 18bc647:	4d 8b 1e             	mov    (%r14),%r11
 18bc64a:	c4 c1 79 6f 04 03    	vmovdqa (%r11,%rax,1),%xmm0
 18bc650:	4c 8d 9e 00 01 00 00 	lea    0x100(%rsi),%r11
 18bc657:	4d 21 cb             	and    %r9,%r11
 18bc65a:	47 8d 0c 04          	lea    (%r12,%r8,1),%r9d
 18bc65e:	62 d2 7d 08 7a c9    	vpbroadcastb %r9d,%xmm1
 18bc664:	4d 8d 4a 80          	lea    -0x80(%r10),%r9
 18bc668:	c5 f1 fc ca          	vpaddb %xmm2,%xmm1,%xmm1
 18bc66c:	c5 f1 db cb          	vpand  %xmm3,%xmm1,%xmm1
 18bc670:	c4 e2 79 00 c1       	vpshufb %xmm1,%xmm0,%xmm0
 18bc675:	c4 81 79 7f 04 1f    	vmovdqa %xmm0,(%r15,%r11,1)
 18bc67b:	4c 8d 9e 40 01 00 00 	lea    0x140(%rsi),%r11
 18bc682:	4d 21 cb             	and    %r9,%r11
 18bc685:	4d 8b 0e             	mov    (%r14),%r9
 18bc688:	c4 c1 79 6f 04 01    	vmovdqa (%r9,%rax,1),%xmm0
 18bc68e:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
 18bc693:	45 01 c1             	add    %r8d,%r9d
 18bc696:	62 d2 7d 08 7a c9    	vpbroadcastb %r9d,%xmm1
 18bc69c:	4d 8d 4a c0          	lea    -0x40(%r10),%r9
 18bc6a0:	c5 f1 fc ca          	vpaddb %xmm2,%xmm1,%xmm1
 18bc6a4:	c5 f1 db cb          	vpand  %xmm3,%xmm1,%xmm1
 18bc6a8:	c4 e2 79 00 c1       	vpshufb %xmm1,%xmm0,%xmm0
 18bc6ad:	c4 81 79 7f 04 1f    	vmovdqa %xmm0,(%r15,%r11,1)
 18bc6b3:	4d 8b 1e             	mov    (%r14),%r11
 18bc6b6:	c4 c1 79 6f 04 03    	vmovdqa (%r11,%rax,1),%xmm0
 18bc6bc:	4c 8b 5c 24 40       	mov    0x40(%rsp),%r11
 18bc6c1:	45 01 c3             	add    %r8d,%r11d
 18bc6c4:	62 d2 7d 08 7a cb    	vpbroadcastb %r11d,%xmm1
 18bc6ca:	4c 8d 9e 80 01 00 00 	lea    0x180(%rsi),%r11
 18bc6d1:	c5 f1 fc ca          	vpaddb %xmm2,%xmm1,%xmm1
 18bc6d5:	4d 21 cb             	and    %r9,%r11
 18bc6d8:	c5 f1 db cb          	vpand  %xmm3,%xmm1,%xmm1
 18bc6dc:	c4 e2 79 00 c1       	vpshufb %xmm1,%xmm0,%xmm0
 18bc6e1:	c4 81 79 7f 04 1f    	vmovdqa %xmm0,(%r15,%r11,1)
 18bc6e7:	4d 8b 0e             	mov    (%r14),%r9
 18bc6ea:	c4 c1 79 6f 04 01    	vmovdqa (%r9,%rax,1),%xmm0
 18bc6f0:	4c 8b 4c 24 10       	mov    0x10(%rsp),%r9
 18bc6f5:	45 01 c1             	add    %r8d,%r9d
 18bc6f8:	44 02 84 24 80 00 00 00 	add    0x80(%rsp),%r8b
 18bc700:	62 d2 7d 08 7a c9    	vpbroadcastb %r9d,%xmm1
 18bc706:	4c 8d 8e c0 01 00 00 	lea    0x1c0(%rsi),%r9
 18bc70d:	c5 f1 fc ca          	vpaddb %xmm2,%xmm1,%xmm1
 18bc711:	4d 21 d1             	and    %r10,%r9
 18bc714:	49 81 c2 00 02 00 00 	add    $0x200,%r10
 18bc71b:	c5 f1 db cb          	vpand  %xmm3,%xmm1,%xmm1
 18bc71f:	c4 e2 79 00 c1       	vpshufb %xmm1,%xmm0,%xmm0
 18bc724:	c4 81 79 7f 04 0f    	vmovdqa %xmm0,(%r15,%r9,1)
 18bc72a:	48 39 fb             	cmp    %rdi,%rbx
 18bc72d:	0f 85 19 fe ff ff    	jne    18bc54c <tier0_tables_open+0x507c>
 18bc733:	48 85 d2             	test   %rdx,%rdx
 18bc736:	0f 84 73 03 00 00    	je     18bcaaf <tier0_tables_open+0x55df>
 18bc73c:	41 89 c8             	mov    %ecx,%r8d
 18bc73f:	44 0f af c7          	imul   %edi,%r8d
 18bc743:	48 c1 e7 06          	shl    $0x6,%rdi
 18bc747:	4d 8b 0e             	mov    (%r14),%r9
 18bc74a:	62 d2 7d 08 7a c8    	vpbroadcastb %r8d,%xmm1
 18bc750:	c5 f1 fc 0d b8 94 cb fe 	vpaddb -0x1346b48(%rip),%xmm1,%xmm1        # 575c10 <x86_effects_unknown+0x1b0>
 18bc758:	48 be 00 fe ff ff 3f 00 00 00 	movabs $0x3ffffffe00,%rsi
 18bc762:	41 00 c8             	add    %cl,%r8b
 18bc765:	62 f1 75 18 db 0d 55 3d cc fe 	vpandd -0x133c2ab(%rip){1to4},%xmm1,%xmm1        # 5804c4 <tier0_emit_x87.operations+0x7c>
 18bc76f:	48 81 c6 c0 01 00 00 	add    $0x1c0,%rsi
 18bc776:	48 21 fe             	and    %rdi,%rsi
 18bc779:	48 83 c7 40          	add    $0x40,%rdi
 18bc77d:	48 ff ca             	dec    %rdx
 18bc780:	c4 c1 79 6f 04 01    	vmovdqa (%r9,%rax,1),%xmm0
 18bc786:	4c 8b 4c 24 08       	mov    0x8(%rsp),%r9
 18bc78b:	c4 e2 79 00 c1       	vpshufb %xmm1,%xmm0,%xmm0
 18bc790:	c4 c1 79 7f 04 31    	vmovdqa %xmm0,(%r9,%rsi,1)
 18bc796:	75 af                	jne    18bc747 <tier0_tables_open+0x5277>
 18bc798:	e9 12 03 00 00       	jmp    18bcaaf <tier0_tables_open+0x55df>
 18bc79d:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
 18bc7a2:	89 d1                	mov    %edx,%ecx
 18bc7a4:	83 e1 07             	and    $0x7,%ecx
 18bc7a7:	48 83 fa 08          	cmp    $0x8,%rdx
 18bc7ab:	0f 83 fe 01 00 00    	jae    18bc9af <tier0_tables_open+0x54df>
 18bc7b1:	31 d2                	xor    %edx,%edx
 18bc7b3:	e9 c4 02 00 00       	jmp    18bca7c <tier0_tables_open+0x55ac>
 18bc7b8:	4c 8b 4c 24 58       	mov    0x58(%rsp),%r9
 18bc7bd:	41 89 cf             	mov    %ecx,%r15d
 18bc7c0:	41 83 e7 7f          	and    $0x7f,%r15d
 18bc7c4:	45 31 e4             	xor    %r12d,%r12d
 18bc7c7:	45 31 ed             	xor    %r13d,%r13d
 18bc7ca:	31 ed                	xor    %ebp,%ebp
 18bc7cc:	45 31 db             	xor    %r11d,%r11d
 18bc7cf:	48 c7 44 24 30 00 00 00 00 	movq   $0x0,0x30(%rsp)
 18bc7d8:	45 31 c0             	xor    %r8d,%r8d
 18bc7db:	45 01 ff             	add    %r15d,%r15d
 18bc7de:	49 83 e1 fe          	and    $0xfffffffffffffffe,%r9
 18bc7e2:	eb 25                	jmp    18bc809 <tier0_tables_open+0x5339>
 18bc7e4:	48 8d 14 8d 00 00 00 00 	lea    0x0(,%rcx,4),%rdx
 18bc7ec:	49 83 c0 02          	add    $0x2,%r8
 18bc7f0:	49 83 eb 80          	sub    $0xffffffffffffff80,%r11
 18bc7f4:	4d 01 fc             	add    %r15,%r12
 18bc7f7:	49 01 cd             	add    %rcx,%r13
 18bc7fa:	49 01 cd             	add    %rcx,%r13
 18bc7fd:	48 01 d5             	add    %rdx,%rbp
 18bc800:	4d 39 c1             	cmp    %r8,%r9
 18bc803:	0f 84 03 01 00 00    	je     18bc90c <tier0_tables_open+0x543c>
 18bc809:	49 8b 36             	mov    (%r14),%rsi
 18bc80c:	62 d2 7d 08 7a cc    	vpbroadcastb %r12d,%xmm1
 18bc812:	c5 f1 fc 0d f6 93 cb fe 	vpaddb -0x1346c0a(%rip),%xmm1,%xmm1        # 575c10 <x86_effects_unknown+0x1b0>
 18bc81a:	48 ba 00 fe ff ff 3f 00 00 00 	movabs $0x3ffffffe00,%rdx
 18bc824:	62 f1 75 18 db 0d 96 3c cc fe 	vpandd -0x133c36a(%rip){1to4},%xmm1,%xmm1        # 5804c4 <tier0_emit_x87.operations+0x7c>
 18bc82e:	4c 8d 92 80 01 00 00 	lea    0x180(%rdx),%r10
 18bc835:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
 18bc83a:	4d 21 da             	and    %r11,%r10
 18bc83d:	c5 f9 6f 04 06       	vmovdqa (%rsi,%rax,1),%xmm0
 18bc842:	c4 e2 79 00 c1       	vpshufb %xmm1,%xmm0,%xmm0
 18bc847:	c4 a1 79 7f 04 12    	vmovdqa %xmm0,(%rdx,%r10,1)
 18bc84d:	49 83 fd 0f          	cmp    $0xf,%r13
 18bc851:	77 28                	ja     18bc87b <tier0_tables_open+0x53ab>
 18bc853:	c4 e2 91 f7 54 24 10 	shlx   %r13,0x10(%rsp),%rdx
 18bc85a:	48 be 00 00 00 00 ff ff 00 00 	movabs $0xffff00000000,%rsi
 18bc864:	c4 62 d1 f7 d3       	shlx   %rbp,%rbx,%r10
 18bc869:	45 89 d2             	mov    %r10d,%r10d
 18bc86c:	48 c1 e2 20          	shl    $0x20,%rdx
 18bc870:	48 21 f2             	and    %rsi,%rdx
 18bc873:	4c 09 d2             	or     %r10,%rdx
 18bc876:	48 09 54 24 30       	or     %rdx,0x30(%rsp)
 18bc87b:	49 8b 3e             	mov    (%r14),%rdi
 18bc87e:	48 be 00 fe ff ff 3f 00 00 00 	movabs $0x3ffffffe00,%rsi
 18bc888:	49 8d 53 40          	lea    0x40(%r11),%rdx
 18bc88c:	4c 8d 96 c0 01 00 00 	lea    0x1c0(%rsi),%r10
 18bc893:	42 8d 34 21          	lea    (%rcx,%r12,1),%esi
 18bc897:	62 f2 7d 08 7a ce    	vpbroadcastb %esi,%xmm1
 18bc89d:	c5 f1 fc 0d 6b 93 cb fe 	vpaddb -0x1346c95(%rip),%xmm1,%xmm1        # 575c10 <x86_effects_unknown+0x1b0>
 18bc8a5:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
 18bc8aa:	4c 21 d2             	and    %r10,%rdx
 18bc8ad:	4e 8d 14 29          	lea    (%rcx,%r13,1),%r10
 18bc8b1:	62 f1 75 18 db 0d 09 3c cc fe 	vpandd -0x133c3f7(%rip){1to4},%xmm1,%xmm1        # 5804c4 <tier0_emit_x87.operations+0x7c>
 18bc8bb:	c5 f9 6f 04 07       	vmovdqa (%rdi,%rax,1),%xmm0
 18bc8c0:	c4 e2 79 00 c1       	vpshufb %xmm1,%xmm0,%xmm0
 18bc8c5:	c5 f9 7f 04 16       	vmovdqa %xmm0,(%rsi,%rdx,1)
 18bc8ca:	49 83 fa 0f          	cmp    $0xf,%r10
 18bc8ce:	0f 87 10 ff ff ff    	ja     18bc7e4 <tier0_tables_open+0x5314>
 18bc8d4:	c4 e2 a9 f7 7c 24 10 	shlx   %r10,0x10(%rsp),%rdi
 18bc8db:	48 8d 14 09          	lea    (%rcx,%rcx,1),%rdx
 18bc8df:	be 00 00 00 00       	mov    $0x0,%esi
 18bc8e4:	01 ea                	add    %ebp,%edx
 18bc8e6:	c4 e2 e9 f7 d3       	shlx   %rdx,%rbx,%rdx
 18bc8eb:	83 e2 fe             	and    $0xfffffffe,%edx
 18bc8ee:	f6 c1 01             	test   $0x1,%cl
 18bc8f1:	48 0f 45 d6          	cmovne %rsi,%rdx
 18bc8f5:	81 e7 fe ff 00 00    	and    $0xfffe,%edi
 18bc8fb:	48 c1 e7 20          	shl    $0x20,%rdi
 18bc8ff:	48 09 d7             	or     %rdx,%rdi
 18bc902:	48 09 7c 24 30       	or     %rdi,0x30(%rsp)
 18bc907:	e9 d8 fe ff ff       	jmp    18bc7e4 <tier0_tables_open+0x5314>
 18bc90c:	f6 44 24 58 01       	testb  $0x1,0x58(%rsp)
 18bc911:	0f 84 8a 00 00 00    	je     18bc9a1 <tier0_tables_open+0x54d1>
 18bc917:	49 8b 3e             	mov    (%r14),%rdi
 18bc91a:	49 0f af c8          	imul   %r8,%rcx
 18bc91e:	48 be 00 fe ff ff 3f 00 00 00 	movabs $0x3ffffffe00,%rsi
 18bc928:	4c 89 c2             	mov    %r8,%rdx
 18bc92b:	48 c1 e2 06          	shl    $0x6,%rdx
 18bc92f:	48 81 c6 c0 01 00 00 	add    $0x1c0,%rsi
 18bc936:	48 21 d6             	and    %rdx,%rsi
 18bc939:	62 f2 7d 08 7a c9    	vpbroadcastb %ecx,%xmm1
 18bc93f:	c5 f1 fc 0d c9 92 cb fe 	vpaddb -0x1346d37(%rip),%xmm1,%xmm1        # 575c10 <x86_effects_unknown+0x1b0>
 18bc947:	62 f1 75 18 db 0d 73 3b cc fe 	vpandd -0x133c48d(%rip){1to4},%xmm1,%xmm1        # 5804c4 <tier0_emit_x87.operations+0x7c>
 18bc951:	c5 f9 6f 04 07       	vmovdqa (%rdi,%rax,1),%xmm0
 18bc956:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 18bc95b:	c4 e2 79 00 c1       	vpshufb %xmm1,%xmm0,%xmm0
 18bc960:	c5 f9 7f 04 30       	vmovdqa %xmm0,(%rax,%rsi,1)
 18bc965:	48 83 f9 0f          	cmp    $0xf,%rcx
 18bc969:	77 36                	ja     18bc9a1 <tier0_tables_open+0x54d1>
 18bc96b:	c4 e2 f1 f7 54 24 10 	shlx   %rcx,0x10(%rsp),%rdx
 18bc972:	89 c8                	mov    %ecx,%eax
 18bc974:	01 c9                	add    %ecx,%ecx
 18bc976:	a8 01                	test   $0x1,%al
 18bc978:	c4 e2 f1 f7 c3       	shlx   %rcx,%rbx,%rax
 18bc97d:	b9 00 00 00 00       	mov    $0x0,%ecx
 18bc982:	89 c0                	mov    %eax,%eax
 18bc984:	48 0f 45 c1          	cmovne %rcx,%rax
 18bc988:	48 b9 00 00 00 00 ff ff 00 00 	movabs $0xffff00000000,%rcx
 18bc992:	48 c1 e2 20          	shl    $0x20,%rdx
 18bc996:	48 21 ca             	and    %rcx,%rdx
 18bc999:	48 09 c2             	or     %rax,%rdx
 18bc99c:	48 09 54 24 30       	or     %rdx,0x30(%rsp)
 18bc9a1:	48 c7 44 24 50 00 00 00 00 	movq   $0x0,0x50(%rsp)
 18bc9aa:	e9 12 01 00 00       	jmp    18bcac1 <tier0_tables_open+0x55f1>
 18bc9af:	48 8b 7c 24 58       	mov    0x58(%rsp),%rdi
 18bc9b4:	45 31 c0             	xor    %r8d,%r8d
 18bc9b7:	31 d2                	xor    %edx,%edx
 18bc9b9:	48 83 e7 f8          	and    $0xfffffffffffffff8,%rdi
 18bc9bd:	4d 8b 16             	mov    (%r14),%r10
 18bc9c0:	48 be 00 fe ff ff 3f 00 00 00 	movabs $0x3ffffffe00,%rsi
 18bc9ca:	4d 89 c1             	mov    %r8,%r9
 18bc9cd:	48 83 c2 08          	add    $0x8,%rdx
 18bc9d1:	49 81 c0 00 02 00 00 	add    $0x200,%r8
 18bc9d8:	49 21 f1             	and    %rsi,%r9
 18bc9db:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
 18bc9e0:	c4 c1 78 28 04 02    	vmovaps (%r10,%rax,1),%xmm0
 18bc9e6:	c4 a1 78 29 04 0e    	vmovaps %xmm0,(%rsi,%r9,1)
 18bc9ec:	4d 8b 16             	mov    (%r14),%r10
 18bc9ef:	c4 c1 78 28 04 02    	vmovaps (%r10,%rax,1),%xmm0
 18bc9f5:	c4 a1 78 29 44 0e 40 	vmovaps %xmm0,0x40(%rsi,%r9,1)
 18bc9fc:	4d 8b 16             	mov    (%r14),%r10
 18bc9ff:	c4 c1 78 28 04 02    	vmovaps (%r10,%rax,1),%xmm0
 18bca05:	c4 a1 78 29 84 0e 80 00 00 00 	vmovaps %xmm0,0x80(%rsi,%r9,1)
 18bca0f:	4d 8b 16             	mov    (%r14),%r10
 18bca12:	c4 c1 78 28 04 02    	vmovaps (%r10,%rax,1),%xmm0
 18bca18:	c4 a1 78 29 84 0e c0 00 00 00 	vmovaps %xmm0,0xc0(%rsi,%r9,1)
 18bca22:	4d 8b 16             	mov    (%r14),%r10
 18bca25:	c4 c1 78 28 04 02    	vmovaps (%r10,%rax,1),%xmm0
 18bca2b:	c4 a1 78 29 84 0e 00 01 00 00 	vmovaps %xmm0,0x100(%rsi,%r9,1)
 18bca35:	4d 8b 16             	mov    (%r14),%r10
 18bca38:	c4 c1 78 28 04 02    	vmovaps (%r10,%rax,1),%xmm0
 18bca3e:	c4 a1 78 29 84 0e 40 01 00 00 	vmovaps %xmm0,0x140(%rsi,%r9,1)
 18bca48:	4d 8b 16             	mov    (%r14),%r10
 18bca4b:	c4 c1 78 28 04 02    	vmovaps (%r10,%rax,1),%xmm0
 18bca51:	c4 a1 78 29 84 0e 80 01 00 00 	vmovaps %xmm0,0x180(%rsi,%r9,1)
 18bca5b:	4d 8b 16             	mov    (%r14),%r10
 18bca5e:	c4 c1 79 6f 04 02    	vmovdqa (%r10,%rax,1),%xmm0
 18bca64:	c4 a1 79 7f 84 0e c0 01 00 00 	vmovdqa %xmm0,0x1c0(%rsi,%r9,1)
 18bca6e:	48 39 d7             	cmp    %rdx,%rdi
 18bca71:	0f 85 46 ff ff ff    	jne    18bc9bd <tier0_tables_open+0x54ed>
 18bca77:	48 85 c9             	test   %rcx,%rcx
 18bca7a:	74 33                	je     18bcaaf <tier0_tables_open+0x55df>
 18bca7c:	48 c1 e2 06          	shl    $0x6,%rdx
 18bca80:	49 8b 3e             	mov    (%r14),%rdi
 18bca83:	48 be 00 fe ff ff 3f 00 00 00 	movabs $0x3ffffffe00,%rsi
 18bca8d:	48 81 c6 c0 01 00 00 	add    $0x1c0,%rsi
 18bca94:	48 21 d6             	and    %rdx,%rsi
 18bca97:	48 83 c2 40          	add    $0x40,%rdx
 18bca9b:	48 ff c9             	dec    %rcx
 18bca9e:	c5 f9 6f 04 07       	vmovdqa (%rdi,%rax,1),%xmm0
 18bcaa3:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
 18bcaa8:	c5 f9 7f 04 37       	vmovdqa %xmm0,(%rdi,%rsi,1)
 18bcaad:	75 d1                	jne    18bca80 <tier0_tables_open+0x55b0>
 18bcaaf:	48 c7 44 24 50 00 00 00 00 	movq   $0x0,0x50(%rsp)
 18bcab8:	48 c7 44 24 30 00 00 00 00 	movq   $0x0,0x30(%rsp)
 18bcac1:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
 18bcac6:	3b 44 24 68          	cmp    0x68(%rsp),%eax
 18bcaca:	0f 83 c2 00 00 00    	jae    18bcb92 <tier0_tables_open+0x56c2>
 18bcad0:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
 18bcad5:	48 8b 4c 24 68       	mov    0x68(%rsp),%rcx
 18bcada:	29 d1                	sub    %edx,%ecx
 18bcadc:	89 d0                	mov    %edx,%eax
 18bcade:	48 89 c2             	mov    %rax,%rdx
 18bcae1:	83 e1 07             	and    $0x7,%ecx
 18bcae4:	74 3b                	je     18bcb21 <tier0_tables_open+0x5651>
 18bcae6:	48 89 c2             	mov    %rax,%rdx
 18bcae9:	48 c1 e2 06          	shl    $0x6,%rdx
 18bcaed:	48 03 94 24 88 01 00 00 	add    0x188(%rsp),%rdx
 18bcaf5:	48 f7 d9             	neg    %rcx
 18bcaf8:	31 ff                	xor    %edi,%edi
 18bcafa:	48 03 94 24 80 01 00 00 	add    0x180(%rsp),%rdx
 18bcb02:	c4 e2 79 59 05 f5 35 cc fe 	vpbroadcastq -0x133ca0b(%rip),%xmm0        # 580100 <x86_semantics_benchmark_code.registers+0x110>
 18bcb0b:	48 ff cf             	dec    %rdi
 18bcb0e:	c5 f9 7f 02          	vmovdqa %xmm0,(%rdx)
 18bcb12:	48 83 c2 40          	add    $0x40,%rdx
 18bcb16:	48 39 f9             	cmp    %rdi,%rcx
 18bcb19:	75 e7                	jne    18bcb02 <tier0_tables_open+0x5632>
 18bcb1b:	48 89 c2             	mov    %rax,%rdx
 18bcb1e:	48 29 fa             	sub    %rdi,%rdx
 18bcb21:	48 2b 44 24 68       	sub    0x68(%rsp),%rax
 18bcb26:	48 83 f8 f8          	cmp    $0xfffffffffffffff8,%rax
 18bcb2a:	77 66                	ja     18bcb92 <tier0_tables_open+0x56c2>
 18bcb2c:	48 8b 84 24 88 01 00 00 	mov    0x188(%rsp),%rax
 18bcb34:	48 29 54 24 68       	sub    %rdx,0x68(%rsp)
 18bcb39:	48 c1 e2 06          	shl    $0x6,%rdx
 18bcb3d:	48 03 84 24 78 01 00 00 	add    0x178(%rsp),%rax
 18bcb45:	48 01 d0             	add    %rdx,%rax
 18bcb48:	c4 e2 79 59 05 af 35 cc fe 	vpbroadcastq -0x133ca51(%rip),%xmm0        # 580100 <x86_semantics_benchmark_code.registers+0x110>
 18bcb51:	c5 f9 7f 80 00 ff ff ff 	vmovdqa %xmm0,-0x100(%rax)
 18bcb59:	c5 f9 7f 80 40 ff ff ff 	vmovdqa %xmm0,-0xc0(%rax)
 18bcb61:	c5 f9 7f 40 80       	vmovdqa %xmm0,-0x80(%rax)
 18bcb66:	c5 f9 7f 40 c0       	vmovdqa %xmm0,-0x40(%rax)
 18bcb6b:	c5 f9 7f 00          	vmovdqa %xmm0,(%rax)
 18bcb6f:	c5 f9 7f 40 40       	vmovdqa %xmm0,0x40(%rax)
 18bcb74:	c5 f9 7f 80 80 00 00 00 	vmovdqa %xmm0,0x80(%rax)
 18bcb7c:	c5 f9 7f 80 c0 00 00 00 	vmovdqa %xmm0,0xc0(%rax)
 18bcb84:	48 05 00 02 00 00    	add    $0x200,%rax
 18bcb8a:	48 83 44 24 68 f8    	addq   $0xfffffffffffffff8,0x68(%rsp)
 18bcb90:	75 b6                	jne    18bcb48 <tier0_tables_open+0x5678>
 18bcb92:	80 bc 24 00 01 00 00 00 	cmpb   $0x0,0x100(%rsp)
 18bcb9a:	0f 84 29 ec ff ff    	je     18bb7c9 <tier0_tables_open+0x42f9>
 18bcba0:	48 8b 0c 24          	mov    (%rsp),%rcx
 18bcba4:	48 8b 94 24 f0 00 00 00 	mov    0xf0(%rsp),%rdx
 18bcbac:	48 8b 01             	mov    (%rcx),%rax
 18bcbaf:	48 8b 49 38          	mov    0x38(%rcx),%rcx
 18bcbb3:	0f b6 34 10          	movzbl (%rax,%rdx,1),%esi
 18bcbb7:	48 8b 0c d1          	mov    (%rcx,%rdx,8),%rcx
 18bcbbb:	40 80 fe 11          	cmp    $0x11,%sil
 18bcbbf:	75 52                	jne    18bcc13 <tier0_tables_open+0x5743>
 18bcbc1:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
 18bcbc6:	ba ff ff ff ff       	mov    $0xffffffff,%edx
 18bcbcb:	4c 8d 42 01          	lea    0x1(%rdx),%r8
 18bcbcf:	48 89 f8             	mov    %rdi,%rax
 18bcbd2:	48 c1 e8 3c          	shr    $0x3c,%rax
 18bcbd6:	49 21 f8             	and    %rdi,%r8
 18bcbd9:	c4 e2 78 f5 d1       	bzhi   %eax,%ecx,%edx
 18bcbde:	ba 00 00 00 00       	mov    $0x0,%edx
 18bcbe3:	0f 44 d0             	cmove  %eax,%edx
 18bcbe6:	b8 37 05 00 00       	mov    $0x537,%eax
 18bcbeb:	c4 e2 f8 f7 c7       	bextr  %rax,%rdi,%rax
 18bcbf0:	bf 10 00 00 00       	mov    $0x10,%edi
 18bcbf5:	48 83 f8 10          	cmp    $0x10,%rax
 18bcbf9:	48 0f 43 c7          	cmovae %rdi,%rax
 18bcbfd:	48 c7 c7 ff ff ff ff 	mov    $0xffffffffffffffff,%rdi
 18bcc04:	c4 e2 f9 f7 ff       	shlx   %rax,%rdi,%rdi
 18bcc09:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
 18bcc0e:	48 f7 d7             	not    %rdi
 18bcc11:	eb 5f                	jmp    18bcc72 <tier0_tables_open+0x57a2>
 18bcc13:	48 b8 00 00 00 00 00 00 01 00 	movabs $0x1000000000000,%rax
 18bcc1d:	31 d2                	xor    %edx,%edx
 18bcc1f:	48 85 44 24 50       	test   %rax,0x50(%rsp)
 18bcc24:	75 23                	jne    18bcc49 <tier0_tables_open+0x5779>
 18bcc26:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
 18bcc2b:	48 c1 e8 20          	shr    $0x20,%rax
 18bcc2f:	83 c8 01             	or     $0x1,%eax
 18bcc32:	0f b7 c0             	movzwl %ax,%eax
 18bcc35:	f3 0f bd d0          	lzcnt  %eax,%edx
 18bcc39:	83 f2 1f             	xor    $0x1f,%edx
 18bcc3c:	c4 e2 68 f5 c1       	bzhi   %edx,%ecx,%eax
 18bcc41:	b8 00 00 00 00       	mov    $0x0,%eax
 18bcc46:	0f 45 d0             	cmovne %eax,%edx
 18bcc49:	4c 8b 54 24 50       	mov    0x50(%rsp),%r10
 18bcc4e:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
 18bcc53:	48 b8 00 00 00 00 00 00 02 00 	movabs $0x2000000000000,%rax
 18bcc5d:	4d 89 d0             	mov    %r10,%r8
 18bcc60:	4c 89 cf             	mov    %r9,%rdi
 18bcc63:	49 21 c0             	and    %rax,%r8
 18bcc66:	48 c1 ef 30          	shr    $0x30,%rdi
 18bcc6a:	4c 89 d0             	mov    %r10,%rax
 18bcc6d:	4c 89 4c 24 50       	mov    %r9,0x50(%rsp)
 18bcc72:	45 31 c9             	xor    %r9d,%r9d
 18bcc75:	4d 85 c0             	test   %r8,%r8
 18bcc78:	41 b8 10 00 00 00    	mov    $0x10,%r8d
 18bcc7e:	49 bb 00 00 00 00 00 00 04 00 	movabs $0x4000000000000,%r11
 18bcc88:	41 0f 95 c2          	setne  %r10b
 18bcc8c:	48 83 f9 10          	cmp    $0x10,%rcx
 18bcc90:	49 0f 43 c8          	cmovae %r8,%rcx
 18bcc94:	45 31 c0             	xor    %r8d,%r8d
 18bcc97:	4c 85 d8             	test   %r11,%rax
 18bcc9a:	41 0f 94 c3          	sete   %r11b
 18bcc9e:	40 80 fe 08          	cmp    $0x8,%sil
 18bcca2:	0f 84 d3 ea ff ff    	je     18bb77b <tier0_tables_open+0x42ab>
 18bcca8:	45 88 d1             	mov    %r10b,%r9b
 18bccab:	45 88 d8             	mov    %r11b,%r8b
 18bccae:	bd ff ff ff ff       	mov    $0xffffffff,%ebp
 18bccb3:	48 c1 e8 2d          	shr    $0x2d,%rax
 18bccb7:	8b 74 24 50          	mov    0x50(%rsp),%esi
 18bccbb:	41 c1 e1 04          	shl    $0x4,%r9d
 18bccbf:	41 c1 e0 05          	shl    $0x5,%r8d
 18bccc3:	c4 e2 71 f7 cd       	shlx   %ecx,%ebp,%ecx
 18bccc8:	83 e0 40             	and    $0x40,%eax
 18bcccb:	45 09 c8             	or     %r9d,%r8d
 18bccce:	09 cf                	or     %ecx,%edi
 18bccd0:	b9 55 55 00 00       	mov    $0x5555,%ecx
 18bccd5:	41 09 d0             	or     %edx,%r8d
 18bccd8:	f7 d7                	not    %edi
 18bccda:	48 ba 00 00 00 00 ff ff 00 00 	movabs $0xffff00000000,%rdx
 18bcce4:	44 09 c0             	or     %r8d,%eax
 18bcce7:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
 18bccec:	c4 e2 42 f5 c9       	pext   %ecx,%edi,%ecx
 18bccf1:	bf 11 11 11 11       	mov    $0x11111111,%edi
 18bccf6:	c4 e2 73 f5 cf       	pdep   %edi,%ecx,%ecx
 18bccfb:	49 21 d0             	and    %rdx,%r8
 18bccfe:	49 09 f0             	or     %rsi,%r8
 18bcd01:	49 09 c8             	or     %rcx,%r8
 18bcd04:	4c 89 44 24 30       	mov    %r8,0x30(%rsp)
 18bcd09:	e9 95 ea ff ff       	jmp    18bb7a3 <tier0_tables_open+0x42d3>
 18bcd0e:	48 83 bc 24 e8 00 00 00 00 	cmpq   $0x0,0xe8(%rsp)
 18bcd17:	0f 84 62 e9 ff ff    	je     18bb67f <tier0_tables_open+0x41af>
 18bcd1d:	83 bc 24 b4 00 00 00 00 	cmpl   $0x0,0xb4(%rsp)
 18bcd25:	0f 84 79 04 00 00    	je     18bd1a4 <tier0_tables_open+0x5cd4>
 18bcd2b:	48 8b 04 24          	mov    (%rsp),%rax
 18bcd2f:	31 c9                	xor    %ecx,%ecx
 18bcd31:	48 05 00 02 00 00    	add    $0x200,%rax
 18bcd37:	62 f1 fd 48 6f 00    	vmovdqa64 (%rax),%zmm0
 18bcd3d:	48 8b 84 24 e8 00 00 00 	mov    0xe8(%rsp),%rax
 18bcd45:	48 05 c0 01 00 00    	add    $0x1c0,%rax
 18bcd4b:	eb 11                	jmp    18bcd5e <tier0_tables_open+0x588e>
 18bcd4d:	48 ff c1             	inc    %rcx
 18bcd50:	48 3b 8c 24 50 01 00 00 	cmp    0x150(%rsp),%rcx
 18bcd58:	0f 84 46 04 00 00    	je     18bd1a4 <tier0_tables_open+0x5cd4>
 18bcd5e:	4c 8b 94 24 20 01 00 00 	mov    0x120(%rsp),%r10
 18bcd66:	4c 8d 0c 49          	lea    (%rcx,%rcx,2),%r9
 18bcd6a:	62 f2 fd 48 59 0d 8c 33 cc fe 	vpbroadcastq -0x133cc74(%rip),%zmm1        # 580100 <x86_semantics_benchmark_code.registers+0x110>
 18bcd74:	49 c1 e1 04          	shl    $0x4,%r9
 18bcd78:	47 8b 04 0a          	mov    (%r10,%r9,1),%r8d
 18bcd7c:	43 8b 7c 0a 04       	mov    0x4(%r10,%r9,1),%edi
 18bcd81:	43 8b 74 0a 08       	mov    0x8(%r10,%r9,1),%esi
 18bcd86:	43 8b 54 0a 0c       	mov    0xc(%r10,%r9,1),%edx
 18bcd8b:	4f 8b 5c 0a 10       	mov    0x10(%r10,%r9,1),%r11
 18bcd90:	47 8b 7c 0a 18       	mov    0x18(%r10,%r9,1),%r15d
 18bcd95:	c4 81 f8 90 4c 0a 20 	kmovq  0x20(%r10,%r9,1),%k1
 18bcd9c:	c4 81 f8 90 44 0a 28 	kmovq  0x28(%r10,%r9,1),%k0
 18bcda3:	4d 85 ff             	test   %r15,%r15
 18bcda6:	0f 84 e6 02 00 00    	je     18bd092 <tier0_tables_open+0x5bc2>
 18bcdac:	45 89 f9             	mov    %r15d,%r9d
 18bcdaf:	49 c1 e3 06          	shl    $0x6,%r11
 18bcdb3:	41 83 e1 07          	and    $0x7,%r9d
 18bcdb7:	41 83 ff 08          	cmp    $0x8,%r15d
 18bcdbb:	73 12                	jae    18bcdcf <tier0_tables_open+0x58ff>
 18bcdbd:	62 f2 fd 48 59 0d 39 33 cc fe 	vpbroadcastq -0x133ccc7(%rip),%zmm1        # 580100 <x86_semantics_benchmark_code.registers+0x110>
 18bcdc7:	45 31 d2             	xor    %r10d,%r10d
 18bcdca:	e9 57 02 00 00       	jmp    18bd026 <tier0_tables_open+0x5b56>
 18bcdcf:	62 f2 fd 48 59 0d 27 33 cc fe 	vpbroadcastq -0x133ccd9(%rip),%zmm1        # 580100 <x86_semantics_benchmark_code.registers+0x110>
 18bcdd9:	41 83 e7 f8          	and    $0xfffffff8,%r15d
 18bcddd:	4e 8d 24 18          	lea    (%rax,%r11,1),%r12
 18bcde1:	45 31 d2             	xor    %r10d,%r10d
 18bcde4:	62 d1 fd 48 6f 5c 24 f9 	vmovdqa64 -0x1c0(%r12),%zmm3
 18bcdec:	62 f2 7d 48 58 3d c2 36 cc fe 	vpbroadcastd -0x133c93e(%rip),%zmm7        # 5804b8 <tier0_emit_x87.operations+0x70>
 18bcdf6:	62 f1 6d 48 71 f1 03 	vpsllw $0x3,%zmm1,%zmm2
 18bcdfd:	62 f1 75 48 71 d1 01 	vpsrlw $0x1,%zmm1,%zmm1
 18bce04:	62 d1 fd 48 6f 64 24 fa 	vmovdqa64 -0x180(%r12),%zmm4
 18bce0c:	62 d1 fd 48 6f 6c 24 fb 	vmovdqa64 -0x140(%r12),%zmm5
 18bce14:	62 d1 fd 48 6f 74 24 fc 	vmovdqa64 -0x100(%r12),%zmm6
 18bce1c:	49 83 c2 08          	add    $0x8,%r10
 18bce20:	62 f3 65 48 25 d7 e4 	vpternlogd $0xe4,%zmm7,%zmm3,%zmm2
 18bce27:	62 f1 65 48 71 d3 04 	vpsrlw $0x4,%zmm3,%zmm3
 18bce2e:	62 f3 75 48 25 df d8 	vpternlogd $0xd8,%zmm7,%zmm1,%zmm3
 18bce35:	62 f2 6d 48 8d c8    	vpermb %zmm0,%zmm2,%zmm1
 18bce3b:	62 f2 65 48 8d d0    	vpermb %zmm0,%zmm3,%zmm2
 18bce41:	62 f1 65 48 71 d4 04 	vpsrlw $0x4,%zmm4,%zmm3
 18bce48:	62 f1 6d 48 71 f2 04 	vpsllw $0x4,%zmm2,%zmm2
 18bce4f:	62 f1 ed 48 eb c9    	vporq  %zmm1,%zmm2,%zmm1
 18bce55:	62 f1 6d 48 71 f1 03 	vpsllw $0x3,%zmm1,%zmm2
 18bce5c:	62 f1 75 48 71 d1 01 	vpsrlw $0x1,%zmm1,%zmm1
 18bce63:	62 f3 75 48 25 df d8 	vpternlogd $0xd8,%zmm7,%zmm1,%zmm3
 18bce6a:	62 f3 5d 48 25 d7 e4 	vpternlogd $0xe4,%zmm7,%zmm4,%zmm2
 18bce71:	62 f2 65 48 8d d8    	vpermb %zmm0,%zmm3,%zmm3
 18bce77:	62 f2 6d 48 8d c8    	vpermb %zmm0,%zmm2,%zmm1
 18bce7d:	62 f1 6d 48 71 f3 04 	vpsllw $0x4,%zmm3,%zmm2
 18bce84:	62 f1 65 48 71 d5 04 	vpsrlw $0x4,%zmm5,%zmm3
 18bce8b:	62 f1 ed 48 eb c9    	vporq  %zmm1,%zmm2,%zmm1
 18bce91:	62 f1 6d 48 71 f1 03 	vpsllw $0x3,%zmm1,%zmm2
 18bce98:	62 f1 75 48 71 d1 01 	vpsrlw $0x1,%zmm1,%zmm1
 18bce9f:	62 f3 75 48 25 df d8 	vpternlogd $0xd8,%zmm7,%zmm1,%zmm3
 18bcea6:	62 f3 55 48 25 d7 e4 	vpternlogd $0xe4,%zmm7,%zmm5,%zmm2
 18bcead:	62 d1 fd 48 6f 6c 24 fd 	vmovdqa64 -0xc0(%r12),%zmm5
 18bceb5:	62 f2 65 48 8d e0    	vpermb %zmm0,%zmm3,%zmm4
 18bcebb:	62 f2 6d 48 8d c8    	vpermb %zmm0,%zmm2,%zmm1
 18bcec1:	62 f1 65 48 71 d6 04 	vpsrlw $0x4,%zmm6,%zmm3
 18bcec8:	62 f1 6d 48 71 f4 04 	vpsllw $0x4,%zmm4,%zmm2
 18bcecf:	62 d1 fd 48 6f 64 24 fe 	vmovdqa64 -0x80(%r12),%zmm4
 18bced7:	62 f1 ed 48 eb c9    	vporq  %zmm1,%zmm2,%zmm1
 18bcedd:	62 f1 6d 48 71 f1 03 	vpsllw $0x3,%zmm1,%zmm2
 18bcee4:	62 f1 75 48 71 d1 01 	vpsrlw $0x1,%zmm1,%zmm1
 18bceeb:	62 f3 75 48 25 df d8 	vpternlogd $0xd8,%zmm7,%zmm1,%zmm3
 18bcef2:	62 f3 4d 48 25 d7 e4 	vpternlogd $0xe4,%zmm7,%zmm6,%zmm2
 18bcef9:	62 f2 65 48 8d d8    	vpermb %zmm0,%zmm3,%zmm3
 18bceff:	62 f2 6d 48 8d c8    	vpermb %zmm0,%zmm2,%zmm1
 18bcf05:	62 f1 6d 48 71 f3 04 	vpsllw $0x4,%zmm3,%zmm2
 18bcf0c:	62 f1 ed 48 eb c9    	vporq  %zmm1,%zmm2,%zmm1
 18bcf12:	62 f1 6d 48 71 d5 04 	vpsrlw $0x4,%zmm5,%zmm2
 18bcf19:	62 f1 65 48 71 f1 03 	vpsllw $0x3,%zmm1,%zmm3
 18bcf20:	62 f1 75 48 71 d1 01 	vpsrlw $0x1,%zmm1,%zmm1
 18bcf27:	62 f3 75 48 25 d7 d8 	vpternlogd $0xd8,%zmm7,%zmm1,%zmm2
 18bcf2e:	62 f3 55 48 25 df e4 	vpternlogd $0xe4,%zmm7,%zmm5,%zmm3
 18bcf35:	62 d1 fd 48 6f 6c 24 ff 	vmovdqa64 -0x40(%r12),%zmm5
 18bcf3d:	62 f2 6d 48 8d d0    	vpermb %zmm0,%zmm2,%zmm2
 18bcf43:	62 f2 65 48 8d c8    	vpermb %zmm0,%zmm3,%zmm1
 18bcf49:	62 f1 6d 48 71 f2 04 	vpsllw $0x4,%zmm2,%zmm2
 18bcf50:	62 f1 ed 48 eb c9    	vporq  %zmm1,%zmm2,%zmm1
 18bcf56:	62 f1 6d 48 71 d4 04 	vpsrlw $0x4,%zmm4,%zmm2
 18bcf5d:	62 f1 65 48 71 f1 03 	vpsllw $0x3,%zmm1,%zmm3
 18bcf64:	62 f1 75 48 71 d1 01 	vpsrlw $0x1,%zmm1,%zmm1
 18bcf6b:	62 f3 75 48 25 d7 d8 	vpternlogd $0xd8,%zmm7,%zmm1,%zmm2
 18bcf72:	62 f3 5d 48 25 df e4 	vpternlogd $0xe4,%zmm7,%zmm4,%zmm3
 18bcf79:	62 d1 fd 48 6f 24 24 	vmovdqa64 (%r12),%zmm4
 18bcf80:	49 81 c4 00 02 00 00 	add    $0x200,%r12
 18bcf87:	62 f2 6d 48 8d d0    	vpermb %zmm0,%zmm2,%zmm2
 18bcf8d:	62 f2 65 48 8d c8    	vpermb %zmm0,%zmm3,%zmm1
 18bcf93:	62 f1 6d 48 71 f2 04 	vpsllw $0x4,%zmm2,%zmm2
 18bcf9a:	62 f1 ed 48 eb c9    	vporq  %zmm1,%zmm2,%zmm1
 18bcfa0:	62 f1 6d 48 71 d5 04 	vpsrlw $0x4,%zmm5,%zmm2
 18bcfa7:	62 f1 65 48 71 f1 03 	vpsllw $0x3,%zmm1,%zmm3
 18bcfae:	62 f1 75 48 71 d1 01 	vpsrlw $0x1,%zmm1,%zmm1
 18bcfb5:	62 f3 75 48 25 d7 d8 	vpternlogd $0xd8,%zmm7,%zmm1,%zmm2
 18bcfbc:	62 f3 55 48 25 df e4 	vpternlogd $0xe4,%zmm7,%zmm5,%zmm3
 18bcfc3:	62 f2 6d 48 8d d0    	vpermb %zmm0,%zmm2,%zmm2
 18bcfc9:	62 f2 65 48 8d c8    	vpermb %zmm0,%zmm3,%zmm1
 18bcfcf:	62 f1 6d 48 71 f2 04 	vpsllw $0x4,%zmm2,%zmm2
 18bcfd6:	62 f1 ed 48 eb c9    	vporq  %zmm1,%zmm2,%zmm1
 18bcfdc:	62 f1 6d 48 71 d4 04 	vpsrlw $0x4,%zmm4,%zmm2
 18bcfe3:	62 f1 65 48 71 f1 03 	vpsllw $0x3,%zmm1,%zmm3
 18bcfea:	62 f1 75 48 71 d1 01 	vpsrlw $0x1,%zmm1,%zmm1
 18bcff1:	62 f3 75 48 25 d7 d8 	vpternlogd $0xd8,%zmm7,%zmm1,%zmm2
 18bcff8:	62 f3 5d 48 25 df e4 	vpternlogd $0xe4,%zmm7,%zmm4,%zmm3
 18bcfff:	62 f2 6d 48 8d d0    	vpermb %zmm0,%zmm2,%zmm2
 18bd005:	62 f2 65 48 8d c8    	vpermb %zmm0,%zmm3,%zmm1
 18bd00b:	62 f1 6d 48 71 f2 04 	vpsllw $0x4,%zmm2,%zmm2
 18bd012:	62 f1 ed 48 eb c9    	vporq  %zmm1,%zmm2,%zmm1
 18bd018:	4d 39 d7             	cmp    %r10,%r15
 18bd01b:	0f 85 c3 fd ff ff    	jne    18bcde4 <tier0_tables_open+0x5914>
 18bd021:	4d 85 c9             	test   %r9,%r9
 18bd024:	74 6c                	je     18bd092 <tier0_tables_open+0x5bc2>
 18bd026:	49 c1 e2 06          	shl    $0x6,%r10
 18bd02a:	4c 03 94 24 e8 00 00 00 	add    0xe8(%rsp),%r10
 18bd032:	41 c1 e1 06          	shl    $0x6,%r9d
 18bd036:	4d 01 da             	add    %r11,%r10
 18bd039:	45 31 db             	xor    %r11d,%r11d
 18bd03c:	62 91 fd 48 6f 14 1a 	vmovdqa64 (%r10,%r11,1),%zmm2
 18bd043:	62 f2 7d 48 58 25 6b 34 cc fe 	vpbroadcastd -0x133cb95(%rip),%zmm4        # 5804b8 <tier0_emit_x87.operations+0x70>
 18bd04d:	62 f1 65 48 71 f1 03 	vpsllw $0x3,%zmm1,%zmm3
 18bd054:	62 f1 75 48 71 d1 01 	vpsrlw $0x1,%zmm1,%zmm1
 18bd05b:	49 83 c3 40          	add    $0x40,%r11
 18bd05f:	62 f3 6d 48 25 dc e4 	vpternlogd $0xe4,%zmm4,%zmm2,%zmm3
 18bd066:	62 f1 6d 48 71 d2 04 	vpsrlw $0x4,%zmm2,%zmm2
 18bd06d:	62 f3 75 48 25 d4 d8 	vpternlogd $0xd8,%zmm4,%zmm1,%zmm2
 18bd074:	62 f2 65 48 8d c8    	vpermb %zmm0,%zmm3,%zmm1
 18bd07a:	62 f2 6d 48 8d d0    	vpermb %zmm0,%zmm2,%zmm2
 18bd080:	62 f1 6d 48 71 f2 04 	vpsllw $0x4,%zmm2,%zmm2
 18bd087:	62 f1 ed 48 eb c9    	vporq  %zmm1,%zmm2,%zmm1
 18bd08d:	4d 39 d9             	cmp    %r11,%r9
 18bd090:	75 aa                	jne    18bd03c <tier0_tables_open+0x5b6c>
 18bd092:	62 f2 7d 48 5a 25 24 8c cb fe 	vbroadcasti32x4 -0x13473dc(%rip),%zmm4        # 575cc0 <x86_effects_unknown+0x260>
 18bd09c:	62 f1 f5 58 db 1d 62 30 cc fe 	vpandq -0x133cf9e(%rip){1to8},%zmm1,%zmm3        # 580108 <x86_semantics_benchmark_code.registers+0x118>
 18bd0a6:	62 f1 6d 48 71 d1 04 	vpsrlw $0x4,%zmm1,%zmm2
 18bd0ad:	62 f3 65 48 3f 1d 08 36 c6 fe 04 	vpcmpneqb -0x139c9f8(%rip),%zmm3,%k3        # 5206c0 <branch_sizing_patterns+0x930>
 18bd0b8:	62 f1 ed 48 db d4    	vpandq %zmm4,%zmm2,%zmm2
 18bd0be:	62 f1 6d 48 74 15 b8 35 c6 fe 	vpcmpeqb -0x139ca48(%rip),%zmm2,%k2        # 520680 <branch_sizing_patterns+0x8f0>
 18bd0c8:	62 f1 65 48 74 e4    	vpcmpeqb %zmm4,%zmm3,%k4
 18bd0ce:	62 f1 6d 4b 74 1d 28 36 c6 fe 	vpcmpeqb -0x139c9d8(%rip),%zmm2,%k3{%k3}        # 520700 <branch_sizing_patterns+0x970>
 18bd0d8:	62 f1 6d 48 74 ec    	vpcmpeqb %zmm4,%zmm2,%k5
 18bd0de:	62 f2 7d 48 5a 25 e8 8b cb fe 	vbroadcasti32x4 -0x1347418(%rip),%zmm4        # 575cd0 <x86_effects_unknown+0x270>
 18bd0e8:	62 f1 65 58 eb 15 da 33 cc fe 	vpord  -0x133cc26(%rip){1to16},%zmm3,%zmm2        # 5804cc <tier0_emit_x87.operations+0x84>
 18bd0f2:	c4 e1 dc 45 e5       	korq   %k5,%k4,%k4
 18bd0f7:	c4 e1 dc 45 db       	korq   %k3,%k4,%k3
 18bd0fc:	c4 e1 f4 45 cb       	korq   %k3,%k1,%k1
 18bd101:	62 f1 65 4a 74 dc    	vpcmpeqb %zmm4,%zmm3,%k3{%k2}
 18bd107:	62 f3 65 4a 3f d4 04 	vpcmpneqb %zmm4,%zmm3,%k2{%k2}
 18bd10e:	c4 e1 f8 44 db       	knotq  %k3,%k3
 18bd113:	62 f1 7f 4a 6f ca    	vmovdqu8 %zmm2,%zmm1{%k2}
 18bd119:	c4 e1 fc 41 c3       	kandq  %k3,%k0,%k0
 18bd11e:	c4 e1 f4 45 c8       	korq   %k0,%k1,%k1
 18bd123:	62 f1 7f 49 6f 0d 53 36 c6 fe 	vmovdqu8 -0x139c9ad(%rip),%zmm1{%k1}        # 520780 <branch_sizing_patterns+0x9f0>
 18bd12d:	41 83 f8 ff          	cmp    $0xffffffff,%r8d
 18bd131:	74 0d                	je     18bd140 <tier0_tables_open+0x5c70>
 18bd133:	4d 8b 0e             	mov    (%r14),%r9
 18bd136:	49 c1 e0 04          	shl    $0x4,%r8
 18bd13a:	c4 81 7a 7f 0c 01    	vmovdqu %xmm1,(%r9,%r8,1)
 18bd140:	83 ff ff             	cmp    $0xffffffff,%edi
 18bd143:	74 0f                	je     18bd154 <tier0_tables_open+0x5c84>
 18bd145:	4d 8b 06             	mov    (%r14),%r8
 18bd148:	48 c1 e7 04          	shl    $0x4,%rdi
 18bd14c:	62 d3 7d 48 39 0c 38 01 	vextracti32x4 $0x1,%zmm1,(%r8,%rdi,1)
 18bd154:	83 fe ff             	cmp    $0xffffffff,%esi
 18bd157:	74 0f                	je     18bd168 <tier0_tables_open+0x5c98>
 18bd159:	49 8b 3e             	mov    (%r14),%rdi
 18bd15c:	48 c1 e6 04          	shl    $0x4,%rsi
 18bd160:	62 f3 7d 48 39 0c 37 02 	vextracti32x4 $0x2,%zmm1,(%rdi,%rsi,1)
 18bd168:	83 fa ff             	cmp    $0xffffffff,%edx
 18bd16b:	0f 84 dc fb ff ff    	je     18bcd4d <tier0_tables_open+0x587d>
 18bd171:	49 8b 36             	mov    (%r14),%rsi
 18bd174:	48 c1 e2 04          	shl    $0x4,%rdx
 18bd178:	62 f3 7d 48 39 0c 16 03 	vextracti32x4 $0x3,%zmm1,(%rsi,%rdx,1)
 18bd180:	e9 c8 fb ff ff       	jmp    18bcd4d <tier0_tables_open+0x587d>
 18bd185:	48 8b 34 24          	mov    (%rsp),%rsi
 18bd189:	4c 89 f7             	mov    %r14,%rdi
 18bd18c:	c5 f8 77             	vzeroupper
 18bd18f:	e8 7c ec 00 00       	call   18cbe10 <abi_finish>
 18bd194:	48 83 44 24 78 0c    	addq   $0xc,0x78(%rsp)
 18bd19a:	48 ff 8c 24 98 00 00 00 	decq   0x98(%rsp)
 18bd1a2:	74 2c                	je     18bd1d0 <tier0_tables_open+0x5d00>
 18bd1a4:	48 8b 44 24 78       	mov    0x78(%rsp),%rax
 18bd1a9:	8b 10                	mov    (%rax),%edx
 18bd1ab:	80 78 0b 01          	cmpb   $0x1,0xb(%rax)
 18bd1af:	75 d4                	jne    18bd185 <tier0_tables_open+0x5cb5>
 18bd1b1:	48 8b 34 24          	mov    (%rsp),%rsi
 18bd1b5:	4c 89 f7             	mov    %r14,%rdi
 18bd1b8:	c5 f8 77             	vzeroupper
 18bd1bb:	e8 c0 f9 00 00       	call   18ccb80 <abi_finish_passing>
 18bd1c0:	48 83 44 24 78 0c    	addq   $0xc,0x78(%rsp)
 18bd1c6:	48 ff 8c 24 98 00 00 00 	decq   0x98(%rsp)
 18bd1ce:	75 d4                	jne    18bd1a4 <tier0_tables_open+0x5cd4>
 18bd1d0:	b1 01                	mov    $0x1,%cl
 18bd1d2:	64 48 8b 04 25 18 ff ff ff 	mov    %fs:0xffffffffffffff18,%rax
 18bd1db:	48 39 84 24 c0 00 00 00 	cmp    %rax,0xc0(%rsp)
 18bd1e3:	0f 87 99 00 00 00    	ja     18bd282 <tier0_tables_open+0x5db2>
 18bd1e9:	48 8b 84 24 c0 00 00 00 	mov    0xc0(%rsp),%rax
 18bd1f1:	64 48 89 04 25 18 ff ff ff 	mov    %rax,%fs:0xffffffffffffff18
 18bd1fa:	84 c9                	test   %cl,%cl
 18bd1fc:	75 1e                	jne    18bd21c <tier0_tables_open+0x5d4c>
 18bd1fe:	48 8b 34 24          	mov    (%rsp),%rsi
 18bd202:	48 8b 94 24 60 01 00 00 	mov    0x160(%rsp),%rdx
 18bd20a:	8b 8c 24 a0 00 00 00 	mov    0xa0(%rsp),%ecx
 18bd211:	4c 89 f7             	mov    %r14,%rdi
 18bd214:	c5 f8 77             	vzeroupper
 18bd217:	e8 64 13 01 00       	call   18ce580 <abi_classify_scalar>
 18bd21c:	83 7c 24 2c 00       	cmpl   $0x0,0x2c(%rsp)
 18bd221:	74 0e                	je     18bd231 <tier0_tables_open+0x5d61>
 18bd223:	83 bc 24 a0 00 00 00 00 	cmpl   $0x0,0xa0(%rsp)
 18bd22b:	0f 85 c9 d5 ff ff    	jne    18ba7fa <tier0_tables_open+0x332a>
 18bd231:	48 8b 84 24 58 01 00 00 	mov    0x158(%rsp),%rax
 18bd239:	64 48 3b 04 25 18 ff ff ff 	cmp    %fs:0xffffffffffffff18,%rax
 18bd242:	77 3e                	ja     18bd282 <tier0_tables_open+0x5db2>
 18bd244:	48 8b 84 24 58 01 00 00 	mov    0x158(%rsp),%rax
 18bd24c:	48 8b 0c 24          	mov    (%rsp),%rcx
 18bd250:	64 48 89 04 25 18 ff ff ff 	mov    %rax,%fs:0xffffffffffffff18
 18bd259:	8b b1 60 1f 00 00    	mov    0x1f60(%rcx),%esi
 18bd25f:	48 85 f6             	test   %rsi,%rsi
 18bd262:	74 40                	je     18bd2a4 <tier0_tables_open+0x5dd4>
 18bd264:	48 8b 04 24          	mov    (%rsp),%rax
 18bd268:	89 f2                	mov    %esi,%edx
 18bd26a:	83 e2 03             	and    $0x3,%edx
 18bd26d:	48 8b 88 b0 01 00 00 	mov    0x1b0(%rax),%rcx
 18bd274:	83 fe 04             	cmp    $0x4,%esi
 18bd277:	73 32                	jae    18bd2ab <tier0_tables_open+0x5ddb>
 18bd279:	b0 01                	mov    $0x1,%al
 18bd27b:	31 ff                	xor    %edi,%edi
 18bd27d:	e9 8b 01 00 00       	jmp    18bd40d <tier0_tables_open+0x5f3d>
 18bd282:	48 8d 3d 6e 2d e1 fe 	lea    -0x11ed292(%rip),%rdi        # 6cfff7 <pp_string_value.meaning+0x72dab>
 18bd289:	48 8d 35 03 a5 dc fe 	lea    -0x1235afd(%rip),%rsi        # 687793 <pp_string_value.meaning+0x2a547>
 18bd290:	48 8d 0d 17 a5 dc fe 	lea    -0x1235ae9(%rip),%rcx        # 6877ae <pp_string_value.meaning+0x2a562>
 18bd297:	ba bf 00 00 00       	mov    $0xbf,%edx
 18bd29c:	c5 f8 77             	vzeroupper
 18bd29f:	e8 ac 68 ea fe       	call   763b50 <__assert_fail@plt>
 18bd2a4:	b0 01                	mov    $0x1,%al
 18bd2a6:	e9 56 b7 ff ff       	jmp    18b8a01 <tier0_tables_open+0x1531>
 18bd2ab:	48 8b 04 24          	mov    (%rsp),%rax
 18bd2af:	83 e6 fc             	and    $0xfffffffc,%esi
 18bd2b2:	31 ff                	xor    %edi,%edi
 18bd2b4:	4c 8d 80 28 04 00 00 	lea    0x428(%rax),%r8
 18bd2bb:	b0 01                	mov    $0x1,%al
 18bd2bd:	45 8b 88 a0 fe ff ff 	mov    -0x160(%r8),%r9d
 18bd2c4:	45 89 ca             	mov    %r9d,%r10d
 18bd2c7:	41 83 e2 f8          	and    $0xfffffff8,%r10d
 18bd2cb:	4e 8b 14 11          	mov    (%rcx,%r10,1),%r10
 18bd2cf:	4d 89 90 a4 fe ff ff 	mov    %r10,-0x15c(%r8)
 18bd2d6:	3c 01                	cmp    $0x1,%al
 18bd2d8:	75 19                	jne    18bd2f3 <tier0_tables_open+0x5e23>
 18bd2da:	48 8b 04 24          	mov    (%rsp),%rax
 18bd2de:	41 c1 e9 03          	shr    $0x3,%r9d
 18bd2e2:	48 8b 80 88 01 00 00 	mov    0x188(%rax),%rax
 18bd2e9:	46 8b 0c 88          	mov    (%rax,%r9,4),%r9d
 18bd2ed:	66 45 85 c9          	test   %r9w,%r9w
 18bd2f1:	78 49                	js     18bd33c <tier0_tables_open+0x5e6c>
 18bd2f3:	41 8b 80 14 ff ff ff 	mov    -0xec(%r8),%eax
 18bd2fa:	83 e0 f8             	and    $0xfffffff8,%eax
 18bd2fd:	48 8b 04 01          	mov    (%rcx,%rax,1),%rax
 18bd301:	49 89 80 18 ff ff ff 	mov    %rax,-0xe8(%r8)
 18bd308:	41 8b 40 88          	mov    -0x78(%r8),%eax
 18bd30c:	83 e0 f8             	and    $0xfffffff8,%eax
 18bd30f:	48 8b 04 01          	mov    (%rcx,%rax,1),%rax
 18bd313:	49 89 40 8c          	mov    %rax,-0x74(%r8)
 18bd317:	41 8b 40 fc          	mov    -0x4(%r8),%eax
 18bd31b:	83 e0 f8             	and    $0xfffffff8,%eax
 18bd31e:	48 8b 04 01          	mov    (%rcx,%rax,1),%rax
 18bd322:	49 89 00             	mov    %rax,(%r8)
 18bd325:	31 c0                	xor    %eax,%eax
 18bd327:	48 83 c7 04          	add    $0x4,%rdi
 18bd32b:	49 81 c0 d0 01 00 00 	add    $0x1d0,%r8
 18bd332:	48 39 fe             	cmp    %rdi,%rsi
 18bd335:	75 86                	jne    18bd2bd <tier0_tables_open+0x5ded>
 18bd337:	e9 c8 00 00 00       	jmp    18bd404 <tier0_tables_open+0x5f34>
 18bd33c:	41 8b 80 14 ff ff ff 	mov    -0xec(%r8),%eax
 18bd343:	41 89 c2             	mov    %eax,%r10d
 18bd346:	41 83 e2 f8          	and    $0xfffffff8,%r10d
 18bd34a:	4e 8b 14 11          	mov    (%rcx,%r10,1),%r10
 18bd34e:	4d 89 90 18 ff ff ff 	mov    %r10,-0xe8(%r8)
 18bd355:	41 f7 c1 00 40 00 00 	test   $0x4000,%r9d
 18bd35c:	75 aa                	jne    18bd308 <tier0_tables_open+0x5e38>
 18bd35e:	4c 8b 0c 24          	mov    (%rsp),%r9
 18bd362:	c1 e8 03             	shr    $0x3,%eax
 18bd365:	4d 8b 89 88 01 00 00 	mov    0x188(%r9),%r9
 18bd36c:	45 8b 0c 81          	mov    (%r9,%rax,4),%r9d
 18bd370:	66 45 85 c9          	test   %r9w,%r9w
 18bd374:	79 92                	jns    18bd308 <tier0_tables_open+0x5e38>
 18bd376:	41 8b 40 88          	mov    -0x78(%r8),%eax
 18bd37a:	41 89 c2             	mov    %eax,%r10d
 18bd37d:	41 83 e2 f8          	and    $0xfffffff8,%r10d
 18bd381:	4e 8b 14 11          	mov    (%rcx,%r10,1),%r10
 18bd385:	4d 89 50 8c          	mov    %r10,-0x74(%r8)
 18bd389:	41 f7 c1 00 40 00 00 	test   $0x4000,%r9d
 18bd390:	75 85                	jne    18bd317 <tier0_tables_open+0x5e47>
 18bd392:	4c 8b 0c 24          	mov    (%rsp),%r9
 18bd396:	c1 e8 03             	shr    $0x3,%eax
 18bd399:	4d 8b 89 88 01 00 00 	mov    0x188(%r9),%r9
 18bd3a0:	45 8b 0c 81          	mov    (%r9,%rax,4),%r9d
 18bd3a4:	66 45 85 c9          	test   %r9w,%r9w
 18bd3a8:	0f 89 69 ff ff ff    	jns    18bd317 <tier0_tables_open+0x5e47>
 18bd3ae:	41 8b 40 fc          	mov    -0x4(%r8),%eax
 18bd3b2:	41 89 c2             	mov    %eax,%r10d
 18bd3b5:	41 83 e2 f8          	and    $0xfffffff8,%r10d
 18bd3b9:	4e 8b 14 11          	mov    (%rcx,%r10,1),%r10
 18bd3bd:	4d 89 10             	mov    %r10,(%r8)
 18bd3c0:	41 f7 c1 00 40 00 00 	test   $0x4000,%r9d
 18bd3c7:	0f 85 58 ff ff ff    	jne    18bd325 <tier0_tables_open+0x5e55>
 18bd3cd:	4c 8b 0c 24          	mov    (%rsp),%r9
 18bd3d1:	c1 e8 03             	shr    $0x3,%eax
 18bd3d4:	4d 8b 89 88 01 00 00 	mov    0x188(%r9),%r9
 18bd3db:	41 8b 04 81          	mov    (%r9,%rax,4),%eax
 18bd3df:	66 85 c0             	test   %ax,%ax
 18bd3e2:	0f 89 3d ff ff ff    	jns    18bd325 <tier0_tables_open+0x5e55>
 18bd3e8:	a9 00 40 00 00       	test   $0x4000,%eax
 18bd3ed:	0f 94 c0             	sete   %al
 18bd3f0:	48 83 c7 04          	add    $0x4,%rdi
 18bd3f4:	49 81 c0 d0 01 00 00 	add    $0x1d0,%r8
 18bd3fb:	48 39 fe             	cmp    %rdi,%rsi
 18bd3fe:	0f 85 b9 fe ff ff    	jne    18bd2bd <tier0_tables_open+0x5ded>
 18bd404:	48 85 d2             	test   %rdx,%rdx
 18bd407:	0f 84 f4 b5 ff ff    	je     18b8a01 <tier0_tables_open+0x1531>
 18bd40d:	48 6b f7 74          	imul   $0x74,%rdi,%rsi
 18bd411:	48 8b 3c 24          	mov    (%rsp),%rdi
 18bd415:	48 6b d2 74          	imul   $0x74,%rdx,%rdx
 18bd419:	48 8d b4 3e cc 02 00 00 	lea    0x2cc(%rsi,%rdi,1),%rsi
 18bd421:	31 ff                	xor    %edi,%edi
 18bd423:	eb 0f                	jmp    18bd434 <tier0_tables_open+0x5f64>
 18bd425:	31 c0                	xor    %eax,%eax
 18bd427:	48 83 c7 74          	add    $0x74,%rdi
 18bd42b:	48 39 fa             	cmp    %rdi,%rdx
 18bd42e:	0f 84 cd b5 ff ff    	je     18b8a01 <tier0_tables_open+0x1531>
 18bd434:	44 8b 44 3e fc       	mov    -0x4(%rsi,%rdi,1),%r8d
 18bd439:	45 89 c1             	mov    %r8d,%r9d
 18bd43c:	41 83 e1 f8          	and    $0xfffffff8,%r9d
 18bd440:	4e 8b 0c 09          	mov    (%rcx,%r9,1),%r9
 18bd444:	4c 89 0c 3e          	mov    %r9,(%rsi,%rdi,1)
 18bd448:	3c 01                	cmp    $0x1,%al
 18bd44a:	75 d9                	jne    18bd425 <tier0_tables_open+0x5f55>
 18bd44c:	48 8b 04 24          	mov    (%rsp),%rax
 18bd450:	41 c1 e8 03          	shr    $0x3,%r8d
 18bd454:	48 8b 80 88 01 00 00 	mov    0x188(%rax),%rax
 18bd45b:	42 8b 04 80          	mov    (%rax,%r8,4),%eax
 18bd45f:	66 85 c0             	test   %ax,%ax
 18bd462:	79 c1                	jns    18bd425 <tier0_tables_open+0x5f55>
 18bd464:	a9 00 40 00 00       	test   $0x4000,%eax
 18bd469:	0f 94 c0             	sete   %al
 18bd46c:	48 83 c7 74          	add    $0x74,%rdi
 18bd470:	48 39 fa             	cmp    %rdi,%rdx
 18bd473:	75 bf                	jne    18bd434 <tier0_tables_open+0x5f64>
 18bd475:	e9 87 b5 ff ff       	jmp    18b8a01 <tier0_tables_open+0x1531>
