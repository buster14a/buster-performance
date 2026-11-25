
bin/direct-v2:	file format elf64-x86-64

Disassembly of section .text:

000000000040d140 <fast_pp_lex_window>:
  40d140:      	pushq	%rbp
  40d141:      	pushq	%r15
  40d143:      	pushq	%r14
  40d145:      	pushq	%r13
  40d147:      	pushq	%r12
  40d149:      	pushq	%rbx
  40d14a:      	subq	$0x68, %rsp
  40d14e:      	movq	0xe798(%rdi), %rax
  40d155:      	vmovdqa64	0xd5d21(%rip), %zmm1 # 0x4e2e80 <conversion_rate+0x820>
  40d15f:      	vmovdqa64	0xd5d57(%rip), %zmm2 # 0x4e2ec0 <conversion_rate+0x860>
  40d169:      	vmovdqa64	0xd5d8d(%rip), %zmm3 # 0x4e2f00 <conversion_rate+0x8a0>
  40d173:      	vmovdqa64	0xd5dc3(%rip), %zmm4 # 0x4e2f40 <conversion_rate+0x8e0>
  40d17d:      	vmovdqa64	0xd5df9(%rip), %zmm5 # 0x4e2f80 <conversion_rate+0x920>
  40d187:      	vmovdqa64	0xd5e2f(%rip), %zmm6 # 0x4e2fc0 <conversion_rate+0x960>
  40d191:      	vmovdqa64	0xd5e65(%rip), %zmm7 # 0x4e3000 <conversion_rate+0x9a0>
  40d19b:      	vmovdqa64	0xd5e9b(%rip), %zmm8 # 0x4e3040 <conversion_rate+0x9e0>
  40d1a5:      	vpbroadcastd	0xd4e61(%rip), %zmm9 # 0x4e2010 <_IO_stdin_used+0x10>
  40d1af:      	vmovdqa64	0xd5ec7(%rip), %zmm10 # 0x4e3080 <conversion_rate+0xa20>
  40d1b9:      	vmovdqa64	0xd5efd(%rip), %zmm11 # 0x4e30c0 <conversion_rate+0xa60>
  40d1c3:      	vbroadcasti32x4	0xd4fc3(%rip), %zmm12 # zmm12 = mem[0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3]
                                                # 0x4e2190 <dummy_bucket.6+0x168>
  40d1cd:      	vbroadcasti32x4	0xd4fc9(%rip), %zmm13 # zmm13 = mem[0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3]
                                                # 0x4e21a0 <dummy_bucket.6+0x178>
  40d1d7:      	vbroadcasti32x4	0xd4fcf(%rip), %zmm14 # zmm14 = mem[0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3]
                                                # 0x4e21b0 <dummy_bucket.6+0x188>
  40d1e1:      	vmovdqa64	0xd5fd5(%rip), %zmm15 # 0x4e31c0 <conversion_rate+0xb60>
  40d1eb:      	vmovdqa64	0xd600b(%rip), %zmm16 # 0x4e3200 <conversion_rate+0xba0>
  40d1f5:      	vbroadcasti32x4	0xd4fc1(%rip), %zmm17 # zmm17 = mem[0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3]
                                                # 0x4e21c0 <dummy_bucket.6+0x198>
  40d1ff:      	vbroadcasti32x4	0xd4ec7(%rip), %zmm18 # zmm18 = mem[0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3]
                                                # 0x4e20d0 <dummy_bucket.6+0xa8>
  40d209:      	vbroadcasti32x4	0xd4efd(%rip), %zmm19 # zmm19 = mem[0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3]
                                                # 0x4e2110 <dummy_bucket.6+0xe8>
  40d213:      	vbroadcasti32x4	0xd4ee3(%rip), %zmm20 # zmm20 = mem[0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3]
                                                # 0x4e2100 <dummy_bucket.6+0xd8>
  40d21d:      	vbroadcasti32x4	0xd4ef9(%rip), %zmm21 # zmm21 = mem[0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3]
                                                # 0x4e2120 <dummy_bucket.6+0xf8>
  40d227:      	vbroadcasti32x4	0xd4f0f(%rip), %zmm22 # zmm22 = mem[0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3]
                                                # 0x4e2140 <dummy_bucket.6+0x118>
  40d231:      	movq	(%rsi), %r12
  40d234:      	movq	0x10(%rsi), %r10
  40d238:      	movq	%rsi, 0x38(%rsp)
  40d23d:      	movl	%ecx, 0x14(%rsp)
  40d241:      	movq	%rdi, 0x20(%rsp)
  40d246:      	movq	%r8, 0x40(%rsp)
  40d24b:      	xorl	%ecx, %ecx
  40d24d:      	xorl	%r11d, %r11d
  40d250:      	xorl	%ebx, %ebx
  40d252:      	movq	%rax, 0x18(%rsp)
  40d257:      	leal	(%r8,%r8), %eax
  40d25b:      	movq	%r10, %rsi
  40d25e:      	subq	%r12, %rsi
  40d261:      	subq	%r12, %rdx
  40d264:      	movq	%r12, 0x30(%rsp)
  40d269:      	movq	%r10, 0x28(%rsp)
  40d26e:      	orb	$0x4, %al
  40d270:      	movq	%rdx, 0x8(%rsp)
  40d275:      	movq	%rsi, 0x48(%rsp)
  40d27a:      	xorl	%edx, %edx
  40d27c:      	vpbroadcastb	%eax, %zmm0
  40d282:      	jmp	0x40d2b3 <fast_pp_lex_window+0x173>
  40d284:      	nopw	%cs:(%rax,%rax)
  40d290:      	addq	$0x40, 0x8(%rsp)
  40d296:      	movq	0x30(%rsp), %r12
  40d29b:      	shrq	$0x3f, %r10
  40d29f:      	movq	%rbp, %r11
  40d2a2:      	movq	%r10, %rdx
  40d2a5:      	leal	0x40(%rcx), %eax
  40d2a8:      	cmpl	$0x801, %eax            # imm = 0x801
  40d2ad:      	jae	0x40db2a <fast_pp_lex_window+0x9ea>
  40d2b3:      	movq	0x8(%rsp), %rax
  40d2b8:      	movq	%rbx, %r14
  40d2bb:      	addq	$0x50, %rax
  40d2bf:      	cmpq	0x48(%rsp), %rax
  40d2c4:      	ja	0x40dbe1 <fast_pp_lex_window+0xaa1>
  40d2ca:      	movq	0x8(%rsp), %rax
  40d2cf:      	vmovdqa64	%zmm7, %zmm25
  40d2d5:      	vmovdqa64	%zmm3, %zmm23
  40d2db:      	movq	%rdx, 0x50(%rsp)
  40d2e0:      	vmovdqu64	0x1(%r12,%rax), %zmm26
  40d2eb:      	vmovdqu64	(%r12,%rax), %zmm24
  40d2f2:      	movq	$-0x1, %rax
  40d2f9:      	vpmovb2m	%zmm26, %k0
  40d2ff:      	vpermt2b	%zmm8, %zmm24, %zmm25
  40d305:      	vpermt2b	%zmm4, %zmm24, %zmm23
  40d30b:      	knotq	%k0, %k1
  40d310:      	vpermi2b	%zmm6, %zmm5, %zmm26 {%k1} {z}
  40d316:      	vpmovb2m	%zmm24, %k1
  40d31c:      	vptestmb	%zmm0, %zmm23, %k0
  40d322:      	korq	%k0, %k1, %k0
  40d327:      	vpternlogd	$0xf8, %zmm9, %zmm26, %zmm25 # zmm25 = zmm25 | (zmm26 & zmm9)
  40d32e:      	kmovq	%k0, %r15
  40d333:      	vpandq	%zmm26, %zmm23, %zmm27
  40d339:      	vpermi2b	%zmm11, %zmm10, %zmm25
  40d33f:      	xorl	%r9d, %r9d
  40d342:      	tzcntq	%r15, %r9
  40d347:      	movq	%r15, 0x60(%rsp)
  40d34c:      	bzhiq	%r9, %rax, %rdi
  40d351:      	movabsq	$-0x8000000000000000, %rax # imm = 0x8000000000000000
  40d35b:      	movq	%r9, 0x58(%rsp)
  40d360:      	vptestmb	%zmm25, %zmm25, %k0
  40d366:      	kmovq	%k0, %r8
  40d36b:      	vptestmb	%zmm14, %zmm27, %k0
  40d371:      	andq	%rdi, %r8
  40d374:      	kmovq	%k0, %rsi
  40d379:      	movq	%r8, %rbx
  40d37c:      	shrq	%rbx
  40d37f:      	andq	%rdi, %rsi
  40d382:      	orq	%rax, %rbx
  40d385:      	movq	%rbx, %rax
  40d388:      	andq	%r8, %rax
  40d38b:      	orq	%rsi, %rax
  40d38e:      	jne	0x40da52 <fast_pp_lex_window+0x912>
  40d394:      	xorl	%ebx, %ebx
  40d396:      	vptestnmb	%zmm12, %zmm23, %k0
  40d39c:      	movq	0x8(%rsp), %r13
  40d3a1:      	vptestmb	%zmm13, %zmm26, %k1
  40d3a7:      	movq	%rdi, %r10
  40d3aa:      	movq	%r8, %rax
  40d3ad:      	movq	%rcx, %r15
  40d3b0:      	decl	%ecx
  40d3b2:      	movl	$0x83f, %edx            # imm = 0x83F
  40d3b7:      	kmovq	%k0, %r12
  40d3bc:      	vptestmb	%zmm13, %zmm23, %k0
  40d3c2:      	kmovq	%k1, %rbp
  40d3c7:      	kmovq	%k0, %r9
  40d3cc:      	andq	%rdi, %r12
  40d3cf:      	andq	%r9, %r10
  40d3d2:      	andq	%r10, %rbp
  40d3d5:      	orq	%rbp, %rax
  40d3d8:      	subq	%r14, %r13
  40d3db:      	andnq	%r12, %rax, %rsi
  40d3e0:      	xorl	%eax, %eax
  40d3e2:      	tzcntq	%rsi, %rax
  40d3e7:      	testq	%r11, %r11
  40d3ea:      	leaq	0x1(%r13,%rax), %r13
  40d3ef:      	movq	%rcx, %rax
  40d3f2:      	cmoveq	%rdx, %rax
  40d3f6:      	movq	%r11, %rdx
  40d3f9:      	movq	0x18(%rsp), %r11
  40d3fe:      	movb	%r13b, 0x840(%r11,%rax)
  40d406:      	movq	%rdx, %rax
  40d409:      	negq	%rax
  40d40c:      	andq	%r13, %rax
  40d40f:      	cmpq	$0x100, %rax            # imm = 0x100
  40d415:      	jae	0x40da91 <fast_pp_lex_window+0x951>
  40d41b:      	leaq	(%rdx,%r10,2), %rax
  40d41f:      	vpermi2b	%zmm2, %zmm1, %zmm24
  40d425:      	leaq	(%r8,%r8), %rcx
  40d429:      	kmovq	%r8, %k1
  40d42e:      	andq	%r10, %rax
  40d431:      	orq	%rax, %rcx
  40d434:      	movq	%rsi, %rax
  40d437:      	subq	%rdx, %rax
  40d43a:      	movq	%r15, %rdx
  40d43d:      	andnq	%r12, %rcx, %r13
  40d442:      	andq	%rsi, %rax
  40d445:      	movq	0x8(%rsp), %rcx
  40d44a:      	vmovdqu8	%zmm25, %zmm24 {%k1}
  40d450:      	kmovq	%r13, %k1
  40d455:      	popcntq	%r13, %rsi
  40d45a:      	vpcompressb	%zmm24, %zmm25 {%k1} {z}
  40d460:      	vpxord	%xmm24, %xmm24, %xmm24
  40d466:      	vpcompressb	%zmm15, %zmm24 {%k1} {z}
  40d46c:      	kmovq	%rax, %k1
  40d471:      	movl	%r15d, %eax
  40d474:      	vpcompressb	%zmm16, %zmm26 {%k1} {z}
  40d47a:      	vpmovzxbd	%xmm24, %zmm28  # zmm28 = xmm24[0],zero,zero,zero,xmm24[1],zero,zero,zero,xmm24[2],zero,zero,zero,xmm24[3],zero,zero,zero,xmm24[4],zero,zero,zero,xmm24[5],zero,zero,zero,xmm24[6],zero,zero,zero,xmm24[7],zero,zero,zero,xmm24[8],zero,zero,zero,xmm24[9],zero,zero,zero,xmm24[10],zero,zero,zero,xmm24[11],zero,zero,zero,xmm24[12],zero,zero,zero,xmm24[13],zero,zero,zero,xmm24[14],zero,zero,zero,xmm24[15],zero,zero,zero
  40d480:      	vmovdqu64	%zmm25, (%r11,%rax)
  40d487:      	vextracti32x4	$0x1, %ymm24, %xmm27
  40d48e:      	vpsubb	%zmm24, %zmm26, %zmm25
  40d494:      	vmovdqu64	%zmm25, 0x840(%r11,%rax)
  40d49c:      	vpbroadcastd	%ecx, %zmm25
  40d4a2:      	vpaddd	%zmm28, %zmm25, %zmm26
  40d4a8:      	vmovdqu64	%zmm26, 0x1080(%r11,%rax,4)
  40d4b0:      	vpmovzxbd	%xmm27, %zmm26  # zmm26 = xmm27[0],zero,zero,zero,xmm27[1],zero,zero,zero,xmm27[2],zero,zero,zero,xmm27[3],zero,zero,zero,xmm27[4],zero,zero,zero,xmm27[5],zero,zero,zero,xmm27[6],zero,zero,zero,xmm27[7],zero,zero,zero,xmm27[8],zero,zero,zero,xmm27[9],zero,zero,zero,xmm27[10],zero,zero,zero,xmm27[11],zero,zero,zero,xmm27[12],zero,zero,zero,xmm27[13],zero,zero,zero,xmm27[14],zero,zero,zero,xmm27[15],zero,zero,zero
  40d4b6:      	vpaddd	%zmm26, %zmm25, %zmm26
  40d4bc:      	vmovdqu64	%zmm26, 0x10c0(%r11,%rax,4)
  40d4c4:      	cmpq	$0x21, %rsi
  40d4c8:      	jae	0x40da9b <fast_pp_lex_window+0x95b>
  40d4ce:      	movq	0x60(%rsp), %r15
  40d4d3:      	testq	%rbx, %rbx
  40d4d6:      	jne	0x40dadf <fast_pp_lex_window+0x99f>
  40d4dc:      	movq	0x8(%rsp), %rbx
  40d4e1:      	andq	%r9, %r13
  40d4e4:      	movl	0x14(%rsp), %ecx
  40d4e8:      	vptestmb	%zmm17, %zmm23, %k0
  40d4ee:      	lzcntq	%r13, %rax
  40d4f3:      	subq	%rax, %rbx
  40d4f6:      	kmovq	%k0, %rax
  40d4fb:      	movzbl	%cl, %ecx
  40d4fe:      	addq	$0x3f, %rbx
  40d502:      	testq	%r13, %r13
  40d505:      	cmoveq	%r14, %rbx
  40d509:      	andq	%rax, %rdi
  40d50c:      	shrq	$0x3f, %rbp
  40d510:      	xorl	%eax, %eax
  40d512:      	cmpq	%r12, %rdi
  40d515:      	movl	$0x0, %edi
  40d51a:      	seta	%al
  40d51d:      	testq	%r12, %r12
  40d520:      	cmovnel	%edi, %ecx
  40d523:      	orl	%eax, %ecx
  40d525:      	movl	%ecx, 0x14(%rsp)
  40d529:      	movq	%rdx, %rcx
  40d52c:      	addl	%esi, %ecx
  40d52e:      	testq	%r15, %r15
  40d531:      	je	0x40d290 <fast_pp_lex_window+0x150>
  40d537:      	movq	0x8(%rsp), %rax
  40d53c:      	movq	0x58(%rsp), %rdx
  40d541:      	movq	0x30(%rsp), %r12
  40d546:      	addq	%rdx, %rax
  40d549:      	leaq	(%r12,%rax), %r14
  40d54d:      	movq	%rax, 0x8(%rsp)
  40d552:      	testq	%rdx, %rdx
  40d555:      	je	0x40d570 <fast_pp_lex_window+0x430>
  40d557:      	movzbl	-0x1(%r14), %eax
  40d55c:      	leaq	0xd6ecd(%rip), %rdx     # 0x4e4430 <fast_char_class>
  40d563:      	testb	$0x1, (%rax,%rdx)
  40d567:      	jmp	0x40d576 <fast_pp_lex_window+0x436>
  40d569:      	nopl	(%rax)
  40d570:      	cmpq	$0x0, 0x50(%rsp)
  40d576:      	movq	0x28(%rsp), %r10
  40d57b:      	movzbl	(%r14), %esi
  40d57f:      	sete	%al
  40d582:      	movq	%rbp, %r11
  40d585:      	cmpl	$0x23, %esi
  40d588:      	je	0x40d690 <fast_pp_lex_window+0x550>
  40d58e:      	cmpl	$0x2f, %esi
  40d591:      	je	0x40d5e0 <fast_pp_lex_window+0x4a0>
  40d593:      	cmpl	$0xa, %esi
  40d596:      	je	0x40db41 <fast_pp_lex_window+0xa01>
  40d59c:      	testb	%al, %al
  40d59e:      	jne	0x40d887 <fast_pp_lex_window+0x747>
  40d5a4:      	movq	0x8(%rsp), %rax
  40d5a9:      	subl	%ebx, %eax
  40d5ab:      	cmpl	$0x2, %eax
  40d5ae:      	je	0x40d835 <fast_pp_lex_window+0x6f5>
  40d5b4:      	cmpl	$0x1, %eax
  40d5b7:      	jne	0x40d848 <fast_pp_lex_window+0x708>
  40d5bd:      	movzbl	(%r12,%rbx), %eax
  40d5c2:      	addb	$-0x4c, %al
  40d5c4:      	cmpb	$0x2a, %al
  40d5c6:      	jae	0x40d848 <fast_pp_lex_window+0x708>
  40d5cc:      	movabsq	$0x20000000201, %rdx    # imm = 0x20000000201
  40d5d6:      	shrxq	%rax, %rdx, %rdi
  40d5db:      	jmp	0x40d84a <fast_pp_lex_window+0x70a>
  40d5e0:      	movzbl	0x1(%r14), %eax
  40d5e5:      	cmpl	$0x2f, %eax
  40d5e8:      	je	0x40d6db <fast_pp_lex_window+0x59b>
  40d5ee:      	movq	%rcx, %r15
  40d5f1:      	cmpl	$0x2a, %eax
  40d5f4:      	jne	0x40d7ba <fast_pp_lex_window+0x67a>
  40d5fa:      	addq	$0x2, %r14
  40d5fe:      	cmpq	%r10, %r14
  40d601:      	jae	0x40db4e <fast_pp_lex_window+0xa0e>
  40d607:      	xorl	%edi, %edi
  40d609:      	nopl	(%rax)
  40d610:      	movq	%r10, %rsi
  40d613:      	subq	%r14, %rsi
  40d616:      	cmpq	$0x40, %rsi
  40d61a:      	jb	0x40d66b <fast_pp_lex_window+0x52b>
  40d61c:      	vmovdqu64	(%r14), %zmm23
  40d622:      	movq	$-0x1, %r8
  40d629:      	movl	$0x40, %esi
  40d62e:      	vpcmpeqb	%zmm19, %zmm23, %k0
  40d634:      	kmovq	%k0, %rax
  40d639:      	vpcmpeqb	%zmm20, %zmm23, %k0
  40d63f:      	andq	%r8, %rax
  40d642:      	kmovq	%k0, %rcx
  40d647:      	leaq	(%rdi,%rax,2), %rdi
  40d64b:      	andq	%rcx, %rdi
  40d64e:      	andq	%r8, %rdi
  40d651:      	jne	0x40d802 <fast_pp_lex_window+0x6c2>
  40d657:      	shrq	$0x3f, %rax
  40d65b:      	addq	%rsi, %r14
  40d65e:      	movq	%rax, %rdi
  40d661:      	cmpq	%r10, %r14
  40d664:      	jb	0x40d610 <fast_pp_lex_window+0x4d0>
  40d666:      	jmp	0x40db4e <fast_pp_lex_window+0xa0e>
  40d66b:      	movq	$-0x1, %rax
  40d672:      	shlxq	%rsi, %rax, %r8
  40d677:      	notq	%r8
  40d67a:      	kmovq	%r8, %k1
  40d67f:      	vmovdqu8	(%r14), %zmm23 {%k1} {z}
  40d685:      	jmp	0x40d62e <fast_pp_lex_window+0x4ee>
  40d687:      	nopw	(%rax,%rax)
  40d690:      	cmpl	$0x0, 0x14(%rsp)
  40d695:      	movq	%rcx, %r15
  40d698:      	jne	0x40db49 <fast_pp_lex_window+0xa09>
  40d69e:      	xorl	%eax, %eax
  40d6a0:      	cmpb	$0x23, 0x1(%r14)
  40d6a5:      	movq	0x18(%rsp), %rdx
  40d6aa:      	movq	0x8(%rsp), %rdi
  40d6af:      	movl	%r15d, %esi
  40d6b2:      	sete	%al
  40d6b5:      	leal	0x34(%rax), %ecx
  40d6b8:      	movb	%cl, (%rdx,%rsi)
  40d6bb:      	leal	0x1(%rax), %ecx
  40d6be:      	movl	%edi, 0x1080(%rdx,%rsi,4)
  40d6c5:      	leaq	0x1(%rax,%rdi), %rdi
  40d6ca:      	movb	%cl, 0x840(%rdx,%rsi)
  40d6d1:      	movq	%r15, %rcx
  40d6d4:      	incl	%ecx
  40d6d6:      	jmp	0x40da3e <fast_pp_lex_window+0x8fe>
  40d6db:      	addq	$0x2, %r14
  40d6df:      	cmpq	%r10, %r14
  40d6e2:      	jae	0x40d824 <fast_pp_lex_window+0x6e4>
  40d6e8:      	movq	%r10, %rsi
  40d6eb:      	subq	%r14, %rsi
  40d6ee:      	cmpq	$0x40, %rsi
  40d6f2:      	jb	0x40d728 <fast_pp_lex_window+0x5e8>
  40d6f4:      	vmovdqu64	(%r14), %zmm23
  40d6fa:      	movq	$-0x1, %rax
  40d701:      	movl	$0x40, %esi
  40d706:      	vpcmpeqb	%zmm18, %zmm23, %k0
  40d70c:      	kmovq	%k0, %rdi
  40d711:      	andq	%rax, %rdi
  40d714:      	jne	0x40d767 <fast_pp_lex_window+0x627>
  40d716:      	addq	%rsi, %r14
  40d719:      	movq	%r14, 0x8(%rsp)
  40d71e:      	cmpq	%r10, %r14
  40d721:      	jb	0x40d6e8 <fast_pp_lex_window+0x5a8>
  40d723:      	jmp	0x40d829 <fast_pp_lex_window+0x6e9>
  40d728:      	movq	$-0x1, %rax
  40d72f:      	shlxq	%rsi, %rax, %rax
  40d734:      	notq	%rax
  40d737:      	kmovq	%rax, %k1
  40d73c:      	vmovdqu8	(%r14), %zmm23 {%k1} {z}
  40d742:      	vpcmpeqb	%zmm18, %zmm23, %k0
  40d748:      	kmovq	%k0, %rdi
  40d74d:      	andq	%rax, %rdi
  40d750:      	jne	0x40d767 <fast_pp_lex_window+0x627>
  40d752:      	jmp	0x40d716 <fast_pp_lex_window+0x5d6>
  40d754:      	nopw	%cs:(%rax,%rax)
  40d760:      	blsrq	%rdi, %rdi
  40d765:      	je	0x40d716 <fast_pp_lex_window+0x5d6>
  40d767:      	xorl	%eax, %eax
  40d769:      	tzcntq	%rdi, %rax
  40d76e:      	leaq	(%r14,%rax), %r8
  40d772:      	movq	%r8, 0x8(%rsp)
  40d777:      	testq	%rax, %rax
  40d77a:      	je	0x40d78c <fast_pp_lex_window+0x64c>
  40d77c:      	leaq	(%r14,%rax), %rdx
  40d780:      	cmpb	$0xd, -0x1(%rdx)
  40d784:      	leaq	-0x1(%rdx), %r8
  40d788:      	cmovneq	%rdx, %r8
  40d78c:      	cmpq	%r14, %r8
  40d78f:      	jbe	0x40d798 <fast_pp_lex_window+0x658>
  40d791:      	cmpb	$0x5c, -0x1(%r8)
  40d796:      	je	0x40d760 <fast_pp_lex_window+0x620>
  40d798:      	cmpl	$0x1, %eax
  40d79b:      	ja	0x40d829 <fast_pp_lex_window+0x6e9>
  40d7a1:      	movq	0x8(%rsp), %rdx
  40d7a6:      	xorl	%eax, %eax
  40d7a8:      	cmpb	$0xd, -0x1(%rdx)
  40d7ac:      	sete	%al
  40d7af:      	notq	%rax
  40d7b2:      	cmpb	$0x5c, (%rdx,%rax)
  40d7b6:      	je	0x40d760 <fast_pp_lex_window+0x620>
  40d7b8:      	jmp	0x40d829 <fast_pp_lex_window+0x6e9>
  40d7ba:      	movq	0x18(%rsp), %r8
  40d7bf:      	movq	0x8(%rsp), %rdi
  40d7c4:      	xorl	%ecx, %ecx
  40d7c6:      	cmpb	$0x3d, %al
  40d7c8:      	movl	$0x1a, %eax
  40d7cd:      	movl	$0x2d, %edx
  40d7d2:      	movl	%r15d, %esi
  40d7d5:      	cmovel	%edx, %eax
  40d7d8:      	sete	%cl
  40d7db:      	incl	%r15d
  40d7de:      	movb	%al, (%r8,%rsi)
  40d7e2:      	movl	%edi, 0x1080(%r8,%rsi,4)
  40d7ea:      	leaq	0x1(%rcx,%rdi), %rdi
  40d7ef:      	leal	0x1(%rcx), %eax
  40d7f2:      	movq	%r15, %rcx
  40d7f5:      	movb	%al, 0x840(%r8,%rsi)
  40d7fd:      	jmp	0x40da3e <fast_pp_lex_window+0x8fe>
  40d802:      	xorl	%eax, %eax
  40d804:      	tzcntq	%rdi, %rax
  40d809:      	xorl	%edx, %edx
  40d80b:      	movq	%r15, %rcx
  40d80e:      	movq	%rbp, %r11
  40d811:      	addq	%rax, %r14
  40d814:      	subq	%r12, %r14
  40d817:      	incq	%r14
  40d81a:      	movq	%r14, 0x8(%rsp)
  40d81f:      	jmp	0x40d2a5 <fast_pp_lex_window+0x165>
  40d824:      	movq	%r14, 0x8(%rsp)
  40d829:      	subq	%r12, 0x8(%rsp)
  40d82e:      	xorl	%edx, %edx
  40d830:      	jmp	0x40d2a5 <fast_pp_lex_window+0x165>
  40d835:      	cmpb	$0x75, (%r12,%rbx)
  40d83a:      	jne	0x40d848 <fast_pp_lex_window+0x708>
  40d83c:      	cmpb	$0x38, 0x1(%r12,%rbx)
  40d842:      	sete	%dil
  40d846:      	jmp	0x40d84a <fast_pp_lex_window+0x70a>
  40d848:      	xorl	%edi, %edi
  40d84a:      	cmpl	$0x5c, %esi
  40d84d:      	je	0x40db32 <fast_pp_lex_window+0x9f2>
  40d853:      	cmpl	$0x27, %esi
  40d856:      	jne	0x40d867 <fast_pp_lex_window+0x727>
  40d858:      	movzbl	(%r12,%rbx), %eax
  40d85d:      	addb	$-0x30, %al
  40d85f:      	cmpb	$0xa, %al
  40d861:      	jb	0x40db32 <fast_pp_lex_window+0x9f2>
  40d867:      	cmpl	$0x27, %esi
  40d86a:      	movq	%rcx, %r8
  40d86d:      	sete	%al
  40d870:      	cmpl	$0x22, %esi
  40d873:      	sete	%cl
  40d876:      	orb	%al, %cl
  40d878:      	andb	%dil, %cl
  40d87b:      	cmpb	$0x1, %cl
  40d87e:      	movq	%r8, %rcx
  40d881:      	je	0x40db32 <fast_pp_lex_window+0x9f2>
  40d887:      	movb	$0x3, %r9b
  40d88a:      	cmpl	$0x27, %esi
  40d88d:      	je	0x40d97b <fast_pp_lex_window+0x83b>
  40d893:      	cmpl	$0x22, %esi
  40d896:      	jne	0x40db25 <fast_pp_lex_window+0x9e5>
  40d89c:      	incq	%r14
  40d89f:      	cmpq	%r10, %r14
  40d8a2:      	jb	0x40d8bc <fast_pp_lex_window+0x77c>
  40d8a4:      	jmp	0x40db25 <fast_pp_lex_window+0x9e5>
  40d8a9:      	nopl	(%rax)
  40d8b0:      	addq	%rsi, %r14
  40d8b3:      	cmpq	%r10, %r14
  40d8b6:      	jae	0x40db25 <fast_pp_lex_window+0x9e5>
  40d8bc:      	movq	%r10, %rsi
  40d8bf:      	subq	%r14, %rsi
  40d8c2:      	cmpq	$0x40, %rsi
  40d8c6:      	jb	0x40d95c <fast_pp_lex_window+0x81c>
  40d8cc:      	vmovdqu64	(%r14), %zmm23
  40d8d2:      	movq	$-0x1, %rax
  40d8d9:      	movl	$0x40, %esi
  40d8de:      	vpcmpeqb	%zmm21, %zmm23, %k0
  40d8e4:      	vpcmpeqb	%zmm22, %zmm23, %k1
  40d8ea:      	korq	%k1, %k0, %k0
  40d8ef:      	vpcmpeqb	%zmm18, %zmm23, %k1
  40d8f5:      	korq	%k0, %k1, %k0
  40d8fa:      	kmovq	%k0, %rdi
  40d8ff:      	andq	%rax, %rdi
  40d902:      	je	0x40d8b0 <fast_pp_lex_window+0x770>
  40d904:      	xorl	%eax, %eax
  40d906:      	tzcntq	%rdi, %rax
  40d90b:      	leaq	(%r14,%rax), %rsi
  40d90f:      	movzbl	(%r14,%rax), %eax
  40d914:      	cmpl	$0x5c, %eax
  40d917:      	jne	0x40d9b2 <fast_pp_lex_window+0x872>
  40d91d:      	leaq	0x1(%rsi), %r14
  40d921:      	cmpq	%r10, %r14
  40d924:      	jae	0x40d8b3 <fast_pp_lex_window+0x773>
  40d926:      	cmpb	$0xd, (%r14)
  40d92a:      	jne	0x40d950 <fast_pp_lex_window+0x810>
  40d92c:      	leaq	0x2(%rsi), %rax
  40d930:      	cmpq	%r10, %rax
  40d933:      	jae	0x40d950 <fast_pp_lex_window+0x810>
  40d935:      	cmpb	$0xa, (%rax)
  40d938:      	jne	0x40d950 <fast_pp_lex_window+0x810>
  40d93a:      	addq	$0x3, %rsi
  40d93e:      	movq	%rsi, %r14
  40d941:      	jmp	0x40d8b3 <fast_pp_lex_window+0x773>
  40d946:      	nopw	%cs:(%rax,%rax)
  40d950:      	addq	$0x2, %rsi
  40d954:      	movq	%rsi, %r14
  40d957:      	jmp	0x40d8b3 <fast_pp_lex_window+0x773>
  40d95c:      	movq	$-0x1, %rax
  40d963:      	shlxq	%rsi, %rax, %rax
  40d968:      	notq	%rax
  40d96b:      	kmovq	%rax, %k1
  40d970:      	vmovdqu8	(%r14), %zmm23 {%k1} {z}
  40d976:      	jmp	0x40d8de <fast_pp_lex_window+0x79e>
  40d97b:      	movzbl	0x1(%r14), %esi
  40d980:      	cmpl	$0x5c, %esi
  40d983:      	je	0x40d9e9 <fast_pp_lex_window+0x8a9>
  40d985:      	cmpl	$0xa, %esi
  40d988:      	je	0x40db25 <fast_pp_lex_window+0x9e5>
  40d98e:      	cmpl	$0x27, %esi
  40d991:      	je	0x40db25 <fast_pp_lex_window+0x9e5>
  40d997:      	movzbl	0x2(%r14), %edi
  40d99c:      	movl	$0x3, %eax
  40d9a1:      	cmpb	$0x27, %dil
  40d9a5:      	je	0x40da13 <fast_pp_lex_window+0x8d3>
  40d9a7:      	cmpb	$0x5c, %sil
  40d9ab:      	je	0x40d9ee <fast_pp_lex_window+0x8ae>
  40d9ad:      	jmp	0x40db25 <fast_pp_lex_window+0x9e5>
  40d9b2:      	cmpl	$0x22, %eax
  40d9b5:      	jne	0x40db25 <fast_pp_lex_window+0x9e5>
  40d9bb:      	movq	0x18(%rsp), %rdi
  40d9c0:      	movq	0x8(%rsp), %rdx
  40d9c5:      	subq	%r12, %rsi
  40d9c8:      	movl	%ecx, %eax
  40d9ca:      	incl	%ecx
  40d9cc:      	incq	%rsi
  40d9cf:      	movq	%rsi, 0x8(%rsp)
  40d9d4:      	movb	$0x5, (%rdi,%rax)
  40d9d8:      	movl	%edx, 0x1080(%rdi,%rax,4)
  40d9df:      	movb	$0x0, 0x840(%rdi,%rax)
  40d9e7:      	jmp	0x40da43 <fast_pp_lex_window+0x903>
  40d9e9:      	movzbl	0x2(%r14), %edi
  40d9ee:      	movzbl	%dil, %eax
  40d9f2:      	leaq	0xd6c87(%rip), %rdx     # 0x4e4680 <fast_simple_escape>
  40d9f9:      	cmpb	$0x0, (%rax,%rdx)
  40d9fd:      	je	0x40db25 <fast_pp_lex_window+0x9e5>
  40da03:      	cmpb	$0x27, 0x3(%r14)
  40da08:      	movl	$0x4, %eax
  40da0d:      	jne	0x40db25 <fast_pp_lex_window+0x9e5>
  40da13:      	movq	0x18(%rsp), %rdx
  40da18:      	movq	0x8(%rsp), %rdi
  40da1d:      	movq	%rcx, %rsi
  40da20:      	movl	%esi, %ecx
  40da22:      	movb	$0x4, (%rdx,%rcx)
  40da26:      	movl	%edi, 0x1080(%rdx,%rcx,4)
  40da2d:      	movb	%al, 0x840(%rdx,%rcx)
  40da34:      	movq	%rsi, %rcx
  40da37:      	movl	%eax, %eax
  40da39:      	incl	%ecx
  40da3b:      	addq	%rax, %rdi
  40da3e:      	movq	%rdi, 0x8(%rsp)
  40da43:      	xorl	%edx, %edx
  40da45:      	movl	$0x0, 0x14(%rsp)
  40da4d:      	jmp	0x40d2a5 <fast_pp_lex_window+0x165>
  40da52:      	movabsq	$0x5555555555555555, %rdx # imm = 0x5555555555555555
  40da5c:      	movq	%r8, %r9
  40da5f:      	leaq	(%r8,%r8), %rax
  40da63:      	andq	%rdx, %r9
  40da66:      	movabsq	$-0x5555555555555556, %rdx # imm = 0xAAAAAAAAAAAAAAAA
  40da70:      	andnq	%r9, %rax, %rax
  40da75:      	addq	%r8, %rax
  40da78:      	andq	%rdx, %r8
  40da7b:      	andnq	%r9, %rax, %r9
  40da80:      	andq	%rax, %r8
  40da83:      	orq	%r9, %r8
  40da86:      	andq	%r8, %rbx
  40da89:      	orq	%rsi, %rbx
  40da8c:      	jmp	0x40d396 <fast_pp_lex_window+0x256>
  40da91:      	movb	$0x0, (%r11,%rcx)
  40da96:      	jmp	0x40d41b <fast_pp_lex_window+0x2db>
  40da9b:      	vextracti32x4	$0x2, %zmm24, %xmm26
  40daa2:      	vextracti32x4	$0x3, %zmm24, %xmm24
  40daa9:      	vpmovzxbd	%xmm26, %zmm26  # zmm26 = xmm26[0],zero,zero,zero,xmm26[1],zero,zero,zero,xmm26[2],zero,zero,zero,xmm26[3],zero,zero,zero,xmm26[4],zero,zero,zero,xmm26[5],zero,zero,zero,xmm26[6],zero,zero,zero,xmm26[7],zero,zero,zero,xmm26[8],zero,zero,zero,xmm26[9],zero,zero,zero,xmm26[10],zero,zero,zero,xmm26[11],zero,zero,zero,xmm26[12],zero,zero,zero,xmm26[13],zero,zero,zero,xmm26[14],zero,zero,zero,xmm26[15],zero,zero,zero
  40daaf:      	vpmovzxbd	%xmm24, %zmm24  # zmm24 = xmm24[0],zero,zero,zero,xmm24[1],zero,zero,zero,xmm24[2],zero,zero,zero,xmm24[3],zero,zero,zero,xmm24[4],zero,zero,zero,xmm24[5],zero,zero,zero,xmm24[6],zero,zero,zero,xmm24[7],zero,zero,zero,xmm24[8],zero,zero,zero,xmm24[9],zero,zero,zero,xmm24[10],zero,zero,zero,xmm24[11],zero,zero,zero,xmm24[12],zero,zero,zero,xmm24[13],zero,zero,zero,xmm24[14],zero,zero,zero,xmm24[15],zero,zero,zero
  40dab5:      	vpaddd	%zmm26, %zmm25, %zmm26
  40dabb:      	vpaddd	%zmm24, %zmm25, %zmm24
  40dac1:      	vmovdqu64	%zmm26, 0x1100(%r11,%rax,4)
  40dac9:      	vmovdqu64	%zmm24, 0x1140(%r11,%rax,4)
  40dad1:      	movq	0x60(%rsp), %r15
  40dad6:      	testq	%rbx, %rbx
  40dad9:      	je	0x40d4dc <fast_pp_lex_window+0x39c>
  40dadf:      	xorl	%eax, %eax
  40dae1:      	tzcntq	%rbx, %rax
  40dae6:      	movq	$-0x1, %rcx
  40daed:      	movq	0x18(%rsp), %r11
  40daf2:      	bzhiq	%rax, %rcx, %rcx
  40daf7:      	andq	%r13, %rcx
  40dafa:      	popcntq	%rcx, %rcx
  40daff:      	addl	%edx, %ecx
  40db01:      	btq	%rax, %r8
  40db05:      	movl	$0x0, %eax
  40db0a:      	adcb	$0x1, %al
  40db0c:      	blsrq	%rbx, %rbx
  40db11:      	movb	$0x0, (%r11,%rcx)
  40db16:      	movb	%al, 0x840(%r11,%rcx)
  40db1e:      	jne	0x40dadf <fast_pp_lex_window+0x99f>
  40db20:      	jmp	0x40d4dc <fast_pp_lex_window+0x39c>
  40db25:      	movq	%rcx, %r15
  40db28:      	jmp	0x40db68 <fast_pp_lex_window+0xa28>
  40db2a:      	movq	%rcx, %r15
  40db2d:      	xorl	%r9d, %r9d
  40db30:      	jmp	0x40db68 <fast_pp_lex_window+0xa28>
  40db32:      	decl	%ecx
  40db34:      	movb	$0x3, %r9b
  40db37:      	movq	%rbx, 0x8(%rsp)
  40db3c:      	movq	%rcx, %r15
  40db3f:      	jmp	0x40db68 <fast_pp_lex_window+0xa28>
  40db41:      	movq	%rcx, %r15
  40db44:      	movb	$0x4, %r9b
  40db47:      	jmp	0x40db68 <fast_pp_lex_window+0xa28>
  40db49:      	movb	$0x2, %r9b
  40db4c:      	jmp	0x40db68 <fast_pp_lex_window+0xa28>
  40db4e:      	movq	0x20(%rsp), %rdi
  40db53:      	leaq	0xd9fb8(%rip), %rsi     # 0x4e7b12 <c_direct_test_overwrite.source+0x2cc2>
  40db5a:      	vzeroupper
  40db5d:      	callq	0x401100 <fast_pp_bail>
  40db62:      	movb	$0x5, %r9b
  40db65:      	movq	%rbp, %r11
  40db68:      	movzbl	0x14(%rsp), %edx
  40db6d:      	xorl	%eax, %eax
  40db6f:      	xorl	%ecx, %ecx
  40db71:      	testq	%r11, %r11
  40db74:      	movq	0x20(%rsp), %rsi
  40db79:      	setne	%cl
  40db7c:      	cmoveq	0x8(%rsp), %rbx
  40db82:      	cmovnel	%eax, %edx
  40db85:      	subl	%ecx, %r15d
  40db88:      	movq	0x38(%rsp), %rcx
  40db8d:      	movl	%r15d, 0xe7b0(%rsi)
  40db94:      	movl	$0x0, 0xe7b4(%rsi)
  40db9e:      	addq	%rbx, %r12
  40dba1:      	movl	0x3c(%rcx), %ecx
  40dba4:      	movl	%ecx, 0xe7b8(%rsi)
  40dbaa:      	incl	0xe7bc(%rsi)
  40dbb0:      	movq	0x40(%rsp), %rcx
  40dbb5:      	movq	%r12, 0xe7c0(%rsi)
  40dbbc:      	movb	%r9b, 0xe7c8(%rsi)
  40dbc3:      	movb	%dl, 0xe7c9(%rsi)
  40dbc9:      	movb	%cl, 0xe7ca(%rsi)
  40dbcf:      	addq	$0x68, %rsp
  40dbd3:      	popq	%rbx
  40dbd4:      	popq	%r12
  40dbd6:      	popq	%r13
  40dbd8:      	popq	%r14
  40dbda:      	popq	%r15
  40dbdc:      	popq	%rbp
  40dbdd:      	vzeroupper
  40dbe0:      	retq
  40dbe1:      	movq	%rcx, %r15
  40dbe4:      	movb	$0x1, %r9b
  40dbe7:      	movq	%r14, %rbx
  40dbea:      	jmp	0x40db68 <fast_pp_lex_window+0xa28>
  40dbef:      	nop
