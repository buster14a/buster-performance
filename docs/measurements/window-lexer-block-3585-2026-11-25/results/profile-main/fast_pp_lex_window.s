
/home/user/dp/bin/direct-main:	file format elf64-x86-64

Disassembly of section .text:

000000000040d190 <fast_pp_lex_window>:
  40d190:      	pushq	%rbp
  40d191:      	pushq	%r15
  40d193:      	pushq	%r14
  40d195:      	pushq	%r13
  40d197:      	pushq	%r12
  40d199:      	pushq	%rbx
  40d19a:      	subq	$0x98, %rsp
  40d1a1:      	movq	(%rsi), %rax
  40d1a4:      	vmovdqa64	0xd5cd2(%rip), %zmm1 # 0x4e2e80 <conversion_rate+0x830>
  40d1ae:      	vmovdqa64	0xd5d08(%rip), %zmm2 # 0x4e2ec0 <conversion_rate+0x870>
  40d1b8:      	vmovdqa64	0xd5d3e(%rip), %zmm3 # 0x4e2f00 <conversion_rate+0x8b0>
  40d1c2:      	vmovdqa64	0xd5d74(%rip), %zmm4 # 0x4e2f40 <conversion_rate+0x8f0>
  40d1cc:      	vbroadcasti32x4	0xd4fba(%rip), %zmm5 # zmm5 = mem[0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3]
                                                # 0x4e2190 <dummy_bucket.6+0x16c>
  40d1d6:      	vbroadcasti32x4	0xd4fc0(%rip), %zmm6 # zmm6 = mem[0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3]
                                                # 0x4e21a0 <dummy_bucket.6+0x17c>
  40d1e0:      	vbroadcasti32x4	0xd4fc6(%rip), %zmm7 # zmm7 = mem[0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3]
                                                # 0x4e21b0 <dummy_bucket.6+0x18c>
  40d1ea:      	vbroadcasti32x4	0xd4e7c(%rip), %zmm8 # zmm8 = mem[0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3]
                                                # 0x4e2070 <dummy_bucket.6+0x4c>
  40d1f4:      	vmovdqa64	0xd5e82(%rip), %zmm9 # 0x4e3080 <conversion_rate+0xa30>
  40d1fe:      	vmovdqa64	0xd5eb8(%rip), %zmm10 # 0x4e30c0 <conversion_rate+0xa70>
  40d208:      	vmovdqa64	0xd5eee(%rip), %zmm11 # 0x4e3100 <conversion_rate+0xab0>
  40d212:      	vmovdqa64	0xd5f24(%rip), %zmm12 # 0x4e3140 <conversion_rate+0xaf0>
  40d21c:      	vmovdqa64	0xd5f5a(%rip), %zmm13 # 0x4e3180 <conversion_rate+0xb30>
  40d226:      	vmovdqa64	0xd5f90(%rip), %zmm14 # 0x4e31c0 <conversion_rate+0xb70>
  40d230:      	vmovdqa64	0xd5fc6(%rip), %zmm15 # 0x4e3200 <conversion_rate+0xbb0>
  40d23a:      	vmovdqa64	0xd5ffc(%rip), %zmm16 # 0x4e3240 <conversion_rate+0xbf0>
  40d244:      	vbroadcasti32x4	0xd4e82(%rip), %zmm17 # zmm17 = mem[0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3]
                                                # 0x4e20d0 <dummy_bucket.6+0xac>
  40d24e:      	vbroadcasti32x4	0xd4eb8(%rip), %zmm18 # zmm18 = mem[0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3]
                                                # 0x4e2110 <dummy_bucket.6+0xec>
  40d258:      	vbroadcasti32x4	0xd4e9e(%rip), %zmm19 # zmm19 = mem[0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3]
                                                # 0x4e2100 <dummy_bucket.6+0xdc>
  40d262:      	vbroadcasti32x4	0xd4eb4(%rip), %zmm20 # zmm20 = mem[0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3]
                                                # 0x4e2120 <dummy_bucket.6+0xfc>
  40d26c:      	vbroadcasti32x4	0xd4eca(%rip), %zmm21 # zmm21 = mem[0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3]
                                                # 0x4e2140 <dummy_bucket.6+0x11c>
  40d276:      	movq	0x10(%rsi), %r9
  40d27a:      	movabsq	$-0x8000000000000000, %r14 # imm = 0x8000000000000000
  40d284:      	movq	%rdx, 0x8(%rsp)
  40d289:      	movq	%rcx, 0x10(%rsp)
  40d28e:      	movq	%rsi, 0x48(%rsp)
  40d293:      	movq	%rdi, 0x60(%rsp)
  40d298:      	movq	%r8, 0x50(%rsp)
  40d29d:      	movl	$0x83f, 0x1c(%rsp)      # imm = 0x83F
  40d2a5:      	xorl	%r12d, %r12d
  40d2a8:      	xorl	%ebx, %ebx
  40d2aa:      	xorl	%edx, %edx
  40d2ac:      	xorl	%r15d, %r15d
  40d2af:      	movq	%rax, 0x20(%rsp)
  40d2b4:      	movq	0xe798(%rdi), %rax
  40d2bb:      	movq	%r9, 0x28(%rsp)
  40d2c0:      	movq	%rax, 0x40(%rsp)
  40d2c5:      	movq	0xe7a0(%rdi), %rax
  40d2cc:      	movq	%rax, 0x30(%rsp)
  40d2d1:      	movq	0xe7a8(%rdi), %rax
  40d2d8:      	movq	%rax, 0x38(%rsp)
  40d2dd:      	leal	(%r8,%r8), %eax
  40d2e1:      	orb	$0x4, %al
  40d2e3:      	vpbroadcastb	%eax, %zmm0
  40d2e9:      	jmp	0x40d30f <fast_pp_lex_window+0x17f>
  40d2eb:      	nopl	(%rax,%rax)
  40d2f0:      	addq	$0x40, 0x8(%rsp)
  40d2f6:      	movq	0x28(%rsp), %r9
  40d2fb:      	leal	0x40(%r12), %ecx
  40d300:      	movq	%rax, %rdx
  40d303:      	cmpl	$0x801, %ecx            # imm = 0x801
  40d309:      	jae	0x40dcc7 <fast_pp_lex_window+0xb37>
  40d30f:      	movq	0x8(%rsp), %rax
  40d314:      	addq	$0x50, %rax
  40d318:      	cmpq	%r9, %rax
  40d31b:      	ja	0x40dd87 <fast_pp_lex_window+0xbf7>
  40d321:      	movq	0x8(%rsp), %rsi
  40d326:      	vmovdqa64	%zmm3, %zmm22
  40d32c:      	vmovdqa64	%zmm1, %zmm23
  40d332:      	movq	%rdx, 0x80(%rsp)
  40d33a:      	movq	%r12, 0x90(%rsp)
  40d342:      	vmovdqu64	(%rsi), %zmm24
  40d348:      	vmovdqu64	0x1(%rsi), %zmm25
  40d352:      	movl	%esi, %r11d
  40d355:      	subl	0x20(%rsp), %r11d
  40d35a:      	vpermt2b	%zmm4, %zmm24, %zmm22
  40d360:      	vpermi2b	%zmm12, %zmm11, %zmm25
  40d366:      	vpermt2b	%zmm2, %zmm24, %zmm23
  40d36c:      	vpmovb2m	%zmm24, %k1
  40d372:      	vpermi2b	%zmm10, %zmm9, %zmm24
  40d378:      	vptestmb	%zmm0, %zmm22, %k0
  40d37e:      	vpsllw	$0x7, %zmm22, %zmm26
  40d385:      	vporq	%zmm24, %zmm25, %zmm24
  40d38b:      	korq	%k0, %k1, %k0
  40d390:      	vptestmb	%zmm6, %zmm22, %k1
  40d396:      	vpermi2b	%zmm14, %zmm13, %zmm24
  40d39c:      	kmovq	%k0, %rdx
  40d3a1:      	vpmovb2m	%zmm26, %k0
  40d3a7:      	vmovdqu64	0x31(%rsi), %xmm26
  40d3b1:      	kmovq	%k1, %rcx
  40d3b6:      	korq	%k0, %k1, %k2
  40d3bb:      	vptestmb	%zmm8, %zmm22, %k1
  40d3c1:      	xorl	%r8d, %r8d
  40d3c4:      	tzcntq	%rdx, %r8
  40d3c9:      	movq	%rdx, 0x78(%rsp)
  40d3ce:      	movq	$-0x1, %rdx
  40d3d5:      	kmovq	%k1, %rax
  40d3da:      	movq	%r8, 0x68(%rsp)
  40d3df:      	bzhiq	%r8, %rdx, %r8
  40d3e4:      	knotq	%k2, %k1
  40d3e9:      	leaq	0xd7040(%rip), %rdx     # 0x4e4430 <fast_char_class>
  40d3f0:      	movq	%r8, %r9
  40d3f3:      	andq	%rcx, %r9
  40d3f6:      	kmovq	%k1, %rcx
  40d3fb:      	movq	%r8, 0x88(%rsp)
  40d403:      	vmovq	%rax, %xmm27
  40d409:      	andq	%r8, %rcx
  40d40c:      	shrq	%r8
  40d40f:      	vptestmb	%zmm24, %zmm24, %k1
  40d415:      	orq	%r14, %r8
  40d418:      	kmovq	%k1, %r10
  40d41d:      	andq	%rcx, %r8
  40d420:      	andq	%r8, %r10
  40d423:      	vpextrb	$0xf, %xmm26, %esi
  40d42a:      	movq	%r10, %rbp
  40d42d:      	leaq	(%r10,%r10), %r13
  40d431:      	vmovq	%r9, %xmm26
  40d437:      	movzbl	(%rsi,%rdx), %edi
  40d43b:      	movabsq	$0x5555555555555555, %rdx # imm = 0x5555555555555555
  40d445:      	andl	$0x7f, %esi
  40d448:      	vpunpcklqdq	%xmm27, %xmm26, %xmm26 # xmm26 = xmm26[0],xmm27[0]
  40d44e:      	andq	%rdx, %rbp
  40d451:      	movl	%r15d, %edx
  40d454:      	leaq	0xd71a5(%rip), %r15     # 0x4e4600 <fast_lex_class>
  40d45b:      	movl	%edx, 0x5c(%rsp)
  40d45f:      	movzbl	(%rsi,%r15), %esi
  40d464:      	andnq	%rbp, %r13, %r14
  40d469:      	movq	%r10, %r13
  40d46c:      	movq	0x38(%rsp), %r15
  40d471:      	addq	%r10, %r14
  40d474:      	andnq	%rbp, %r14, %r12
  40d479:      	movabsq	$-0x5555555555555556, %rbp # imm = 0xAAAAAAAAAAAAAAAA
  40d483:      	vmovd	%edi, %xmm25
  40d489:      	andq	%rbp, %r13
  40d48c:      	movq	%rdi, 0x70(%rsp)
  40d491:      	movl	$0x83f, %edi            # imm = 0x83F
  40d496:      	andq	%r14, %r13
  40d499:      	leaq	(%r9,%r9), %r14
  40d49d:      	shrb	$0x5, %sil
  40d4a1:      	orq	%rbx, %r14
  40d4a4:      	orq	%r12, %r13
  40d4a7:      	movl	$0x83f, %r12d           # imm = 0x83F
  40d4ad:      	vpinsrb	$0x8, %esi, %xmm25, %xmm25
  40d4b4:      	andnq	%r9, %r14, %rbp
  40d4b9:      	leaq	(%r13,%r13), %r14
  40d4be:      	kmovq	%r13, %k1
  40d4c3:      	vpshldq	$0x3f, %xmm26, %xmm25, %xmm25
  40d4ca:      	orq	%rbp, %rcx
  40d4cd:      	vmovdqu8	%zmm24, %zmm23 {%k1}
  40d4d3:      	andnq	%rcx, %r14, %rcx
  40d4d8:      	movl	%r11d, %r14d
  40d4db:      	subl	%edx, %r14d
  40d4de:      	movq	0x40(%rsp), %rdx
  40d4e3:      	vmovq	%xmm25, %rax
  40d4e9:      	kmovq	%rcx, %k1
  40d4ee:      	andnq	%r9, %rax, %rax
  40d4f3:      	vpcompressb	%zmm23, %zmm24 {%k1} {z}
  40d4f9:      	vpxord	%xmm23, %xmm23, %xmm23
  40d4ff:      	vpcompressb	%zmm15, %zmm23 {%k1} {z}
  40d505:      	xorl	%esi, %esi
  40d507:      	tzcntq	%rax, %rsi
  40d50c:      	leal	0x1(%r14,%rsi), %esi
  40d511:      	movl	0x1c(%rsp), %r14d
  40d516:      	cmpl	$0x100, %esi            # imm = 0x100
  40d51c:      	vextracti32x4	$0x1, %ymm23, %xmm27
  40d523:      	cmovaeq	%r14, %r12
  40d527:      	addq	$-0x1, %rbx
  40d52b:      	cmovaeq	%rdi, %r14
  40d52f:      	cmovaeq	%rdi, %r12
  40d533:      	movb	%sil, (%r15,%r14)
  40d537:      	leaq	-0x1(%rax), %rsi
  40d53b:      	movb	$0x0, (%rdx,%r12)
  40d540:      	movq	0x90(%rsp), %r12
  40d548:      	orq	%rbx, %rsi
  40d54b:      	andq	%rax, %rsi
  40d54e:      	popcntq	%rcx, %rax
  40d553:      	kmovq	%rsi, %k1
  40d558:      	pextq	%rcx, %rbp, %rsi
  40d55d:      	vpxord	%xmm26, %xmm26, %xmm26
  40d563:      	vpcompressb	%zmm16, %zmm26 {%k1} {z}
  40d569:      	kmovq	%rsi, %k1
  40d56e:      	movl	%r12d, %esi
  40d571:      	vmovdqu64	%zmm24, (%rdx,%rsi)
  40d578:      	movq	0x30(%rsp), %rdx
  40d57d:      	vpexpandb	%zmm26, %zmm26 {%k1} {z}
  40d583:      	vpsubb	%zmm23, %zmm26, %zmm24
  40d589:      	vpmovzxbd	%xmm23, %zmm26  # zmm26 = xmm23[0],zero,zero,zero,xmm23[1],zero,zero,zero,xmm23[2],zero,zero,zero,xmm23[3],zero,zero,zero,xmm23[4],zero,zero,zero,xmm23[5],zero,zero,zero,xmm23[6],zero,zero,zero,xmm23[7],zero,zero,zero,xmm23[8],zero,zero,zero,xmm23[9],zero,zero,zero,xmm23[10],zero,zero,zero,xmm23[11],zero,zero,zero,xmm23[12],zero,zero,zero,xmm23[13],zero,zero,zero,xmm23[14],zero,zero,zero,xmm23[15],zero,zero,zero
  40d58f:      	vmovdqu64	%zmm24, (%r15,%rsi)
  40d596:      	vpbroadcastd	%r11d, %zmm24
  40d59c:      	movl	%r11d, %r15d
  40d59f:      	vpaddd	%zmm26, %zmm24, %zmm26
  40d5a5:      	vmovdqu64	%zmm26, (%rdx,%rsi,4)
  40d5ac:      	vpmovzxbd	%xmm27, %zmm26  # zmm26 = xmm27[0],zero,zero,zero,xmm27[1],zero,zero,zero,xmm27[2],zero,zero,zero,xmm27[3],zero,zero,zero,xmm27[4],zero,zero,zero,xmm27[5],zero,zero,zero,xmm27[6],zero,zero,zero,xmm27[7],zero,zero,zero,xmm27[8],zero,zero,zero,xmm27[9],zero,zero,zero,xmm27[10],zero,zero,zero,xmm27[11],zero,zero,zero,xmm27[12],zero,zero,zero,xmm27[13],zero,zero,zero,xmm27[14],zero,zero,zero,xmm27[15],zero,zero,zero
  40d5b2:      	vpaddd	%zmm26, %zmm24, %zmm26
  40d5b8:      	vmovdqu64	%zmm26, 0x40(%rdx,%rsi,4)
  40d5c0:      	cmpq	$0x21, %rax
  40d5c4:      	jae	0x40dc83 <fast_pp_lex_window+0xaf3>
  40d5ca:      	vptestmb	%zmm7, %zmm22, %k1
  40d5d0:      	vpextrq	$0x1, %xmm25, %r14
  40d5d7:      	shrq	%r10
  40d5da:      	kmovq	%k1, %rsi
  40d5df:      	andq	%r8, %rsi
  40d5e2:      	andq	%r14, %rsi
  40d5e5:      	movabsq	$-0x8000000000000000, %r14 # imm = 0x8000000000000000
  40d5ef:      	orq	%r14, %r10
  40d5f2:      	andq	%r13, %r10
  40d5f5:      	orq	%rsi, %r10
  40d5f8:      	jne	0x40dc32 <fast_pp_lex_window+0xaa2>
  40d5fe:      	lzcntq	%rbp, %r8
  40d603:      	movq	0x88(%rsp), %rdx
  40d60b:      	kmovq	%k0, %rsi
  40d610:      	vptestmb	%zmm5, %zmm22, %k0
  40d616:      	leal	-0x1(%r12,%rax), %r10d
  40d61b:      	subl	%r8d, %r15d
  40d61e:      	movl	0x1c(%rsp), %r8d
  40d623:      	kmovq	%k0, %rcx
  40d628:      	addl	$0x3f, %r15d
  40d62c:      	testq	%rbp, %rbp
  40d62f:      	cmovel	0x5c(%rsp), %r15d
  40d635:      	cmovnel	%r10d, %r8d
  40d639:      	andq	%rdx, %rcx
  40d63c:      	andnq	%rdx, %rsi, %rsi
  40d641:      	movl	%r8d, 0x1c(%rsp)
  40d646:      	je	0x40d650 <fast_pp_lex_window+0x4c0>
  40d648:      	cmpq	%rsi, %rcx
  40d64b:      	seta	%cl
  40d64e:      	jmp	0x40d65f <fast_pp_lex_window+0x4cf>
  40d650:      	testq	%rcx, %rcx
  40d653:      	movq	0x10(%rsp), %rcx
  40d658:      	setne	%sil
  40d65c:      	orb	%sil, %cl
  40d65f:      	movq	%rcx, 0x10(%rsp)
  40d664:      	movq	0x70(%rsp), %rbx
  40d669:      	movq	0x78(%rsp), %rdx
  40d66e:      	addl	%eax, %r12d
  40d671:      	movq	%r9, %rax
  40d674:      	shrq	$0x3f, %rax
  40d678:      	movq	0x10(%rsp), %rcx
  40d67d:      	andl	$0x1, %ebx
  40d680:      	andl	%eax, %ebx
  40d682:      	andb	$0x1, %cl
  40d685:      	movq	%rcx, 0x10(%rsp)
  40d68a:      	testq	%rdx, %rdx
  40d68d:      	je	0x40d2f0 <fast_pp_lex_window+0x160>
  40d693:      	movq	0x8(%rsp), %rax
  40d698:      	movq	0x68(%rsp), %rdx
  40d69d:      	movzbl	(%rax,%rdx), %ecx
  40d6a1:      	addq	%rdx, %rax
  40d6a4:      	movq	%rax, 0x8(%rsp)
  40d6a9:      	cmpl	$0x23, %ecx
  40d6ac:      	je	0x40d800 <fast_pp_lex_window+0x670>
  40d6b2:      	movq	%r14, %r11
  40d6b5:      	movl	%r15d, %r14d
  40d6b8:      	cmpl	$0x2f, %ecx
  40d6bb:      	je	0x40d740 <fast_pp_lex_window+0x5b0>
  40d6c1:      	cmpl	$0xa, %ecx
  40d6c4:      	je	0x40dcd5 <fast_pp_lex_window+0xb45>
  40d6ca:      	movq	0x68(%rsp), %rsi
  40d6cf:      	movl	$0x1, %edx
  40d6d4:      	leal	-0x1(%rsi), %eax
  40d6d7:      	shlxq	%rax, %rdx, %rax
  40d6dc:      	andq	%r9, %rax
  40d6df:      	testq	%rsi, %rsi
  40d6e2:      	cmoveq	0x80(%rsp), %rax
  40d6eb:      	testq	%rax, %rax
  40d6ee:      	je	0x40da1e <fast_pp_lex_window+0x88e>
  40d6f4:      	movq	0x20(%rsp), %rax
  40d6f9:      	leaq	(%rax,%r14), %rdi
  40d6fd:      	movq	0x8(%rsp), %rax
  40d702:      	subl	%edi, %eax
  40d704:      	cmpl	$0x2, %eax
  40d707:      	je	0x40d9d5 <fast_pp_lex_window+0x845>
  40d70d:      	cmpl	$0x1, %eax
  40d710:      	jne	0x40d9e4 <fast_pp_lex_window+0x854>
  40d716:      	movzbl	(%rdi), %eax
  40d719:      	addb	$-0x4c, %al
  40d71b:      	cmpb	$0x2a, %al
  40d71d:      	jae	0x40d9e4 <fast_pp_lex_window+0x854>
  40d723:      	movabsq	$0x20000000201, %rdx    # imm = 0x20000000201
  40d72d:      	shrxq	%rax, %rdx, %rsi
  40d732:      	jmp	0x40d9e6 <fast_pp_lex_window+0x856>
  40d737:      	nopw	(%rax,%rax)
  40d740:      	movq	0x8(%rsp), %rax
  40d745:      	movzbl	0x1(%rax), %eax
  40d749:      	cmpl	$0x2f, %eax
  40d74c:      	je	0x40d864 <fast_pp_lex_window+0x6d4>
  40d752:      	movq	0x28(%rsp), %r9
  40d757:      	cmpl	$0x2a, %eax
  40d75a:      	jne	0x40d95c <fast_pp_lex_window+0x7cc>
  40d760:      	movq	0x8(%rsp), %rax
  40d765:      	addq	$0x2, %rax
  40d769:      	cmpq	%r9, %rax
  40d76c:      	jae	0x40dd6c <fast_pp_lex_window+0xbdc>
  40d772:      	xorl	%esi, %esi
  40d774:      	nopw	%cs:(%rax,%rax)
  40d780:      	movq	%r9, %rcx
  40d783:      	subq	%rax, %rcx
  40d786:      	cmpq	$0x40, %rcx
  40d78a:      	jb	0x40d7db <fast_pp_lex_window+0x64b>
  40d78c:      	vmovdqu64	(%rax), %zmm22
  40d792:      	movq	$-0x1, %rdi
  40d799:      	movl	$0x40, %ecx
  40d79e:      	vpcmpeqb	%zmm18, %zmm22, %k0
  40d7a4:      	kmovq	%k0, %r8
  40d7a9:      	vpcmpeqb	%zmm19, %zmm22, %k0
  40d7af:      	andq	%rdi, %r8
  40d7b2:      	kmovq	%k0, %rdx
  40d7b7:      	leaq	(%rsi,%r8,2), %rsi
  40d7bb:      	andq	%rdx, %rsi
  40d7be:      	andq	%rdi, %rsi
  40d7c1:      	jne	0x40d9ba <fast_pp_lex_window+0x82a>
  40d7c7:      	shrq	$0x3f, %r8
  40d7cb:      	addq	%rcx, %rax
  40d7ce:      	movq	%r8, %rsi
  40d7d1:      	cmpq	%r9, %rax
  40d7d4:      	jb	0x40d780 <fast_pp_lex_window+0x5f0>
  40d7d6:      	jmp	0x40dd6c <fast_pp_lex_window+0xbdc>
  40d7db:      	movq	$-0x1, %rdx
  40d7e2:      	shlxq	%rcx, %rdx, %rdi
  40d7e7:      	notq	%rdi
  40d7ea:      	kmovq	%rdi, %k1
  40d7ef:      	vmovdqu8	(%rax), %zmm22 {%k1} {z}
  40d7f5:      	jmp	0x40d79e <fast_pp_lex_window+0x60e>
  40d7f7:      	nopw	(%rax,%rax)
  40d800:      	cmpb	$0x0, 0x10(%rsp)
  40d805:      	jne	0x40dcd9 <fast_pp_lex_window+0xb49>
  40d80b:      	movq	0x8(%rsp), %rcx
  40d810:      	xorl	%eax, %eax
  40d812:      	movq	0x40(%rsp), %rdi
  40d817:      	movl	%r12d, %esi
  40d81a:      	movq	0x30(%rsp), %r9
  40d81f:      	movq	0x38(%rsp), %r8
  40d824:      	movq	$0x0, 0x10(%rsp)
  40d82d:      	cmpb	$0x23, 0x1(%rcx)
  40d831:      	sete	%al
  40d834:      	incl	%r12d
  40d837:      	leal	0x34(%rax), %edx
  40d83a:      	movb	%dl, (%rdi,%rsi)
  40d83d:      	movl	%ecx, %edx
  40d83f:      	subl	0x20(%rsp), %edx
  40d843:      	leaq	0x1(%rcx,%rax), %rcx
  40d848:      	movq	%rcx, 0x8(%rsp)
  40d84d:      	movl	%edx, (%r9,%rsi,4)
  40d851:      	movq	0x28(%rsp), %r9
  40d856:      	leal	0x1(%rax), %edx
  40d859:      	xorl	%eax, %eax
  40d85b:      	movb	%dl, (%r8,%rsi)
  40d85f:      	jmp	0x40d2fb <fast_pp_lex_window+0x16b>
  40d864:      	movq	0x8(%rsp), %rax
  40d869:      	movq	0x28(%rsp), %r9
  40d86e:      	addq	$0x2, %rax
  40d872:      	movq	%rax, 0x8(%rsp)
  40d877:      	cmpq	%r9, %rax
  40d87a:      	jae	0x40d9cb <fast_pp_lex_window+0x83b>
  40d880:      	movq	%r11, %r14
  40d883:      	movq	%r9, %rax
  40d886:      	subq	0x8(%rsp), %rax
  40d88b:      	cmpq	$0x40, %rax
  40d88f:      	jb	0x40d8cf <fast_pp_lex_window+0x73f>
  40d891:      	movq	0x8(%rsp), %rax
  40d896:      	movq	$-0x1, %rsi
  40d89d:      	vmovdqu64	(%rax), %zmm22
  40d8a3:      	movl	$0x40, %eax
  40d8a8:      	vpcmpeqb	%zmm17, %zmm22, %k0
  40d8ae:      	kmovq	%k0, %rcx
  40d8b3:      	andq	%rsi, %rcx
  40d8b6:      	jne	0x40d907 <fast_pp_lex_window+0x777>
  40d8b8:      	movq	0x8(%rsp), %rcx
  40d8bd:      	addq	%rax, %rcx
  40d8c0:      	movq	%rcx, 0x8(%rsp)
  40d8c5:      	cmpq	%r9, %rcx
  40d8c8:      	jb	0x40d883 <fast_pp_lex_window+0x6f3>
  40d8ca:      	jmp	0x40dc7c <fast_pp_lex_window+0xaec>
  40d8cf:      	movq	0x8(%rsp), %rdx
  40d8d4:      	movq	$-0x1, %rcx
  40d8db:      	shlxq	%rax, %rcx, %rsi
  40d8e0:      	notq	%rsi
  40d8e3:      	kmovq	%rsi, %k1
  40d8e8:      	vmovdqu8	(%rdx), %zmm22 {%k1} {z}
  40d8ee:      	vpcmpeqb	%zmm17, %zmm22, %k0
  40d8f4:      	kmovq	%k0, %rcx
  40d8f9:      	andq	%rsi, %rcx
  40d8fc:      	jne	0x40d907 <fast_pp_lex_window+0x777>
  40d8fe:      	jmp	0x40d8b8 <fast_pp_lex_window+0x728>
  40d900:      	blsrq	%rcx, %rcx
  40d905:      	je	0x40d8b8 <fast_pp_lex_window+0x728>
  40d907:      	movq	0x8(%rsp), %rdx
  40d90c:      	xorl	%edi, %edi
  40d90e:      	tzcntq	%rcx, %rdi
  40d913:      	leaq	(%rdx,%rdi), %rsi
  40d917:      	movq	%rsi, %r8
  40d91a:      	testq	%rdi, %rdi
  40d91d:      	je	0x40d92b <fast_pp_lex_window+0x79b>
  40d91f:      	cmpb	$0xd, -0x1(%rsi)
  40d923:      	leaq	-0x1(%rsi), %r8
  40d927:      	cmovneq	%rsi, %r8
  40d92b:      	cmpq	0x8(%rsp), %r8
  40d930:      	jbe	0x40d939 <fast_pp_lex_window+0x7a9>
  40d932:      	cmpb	$0x5c, -0x1(%r8)
  40d937:      	je	0x40d900 <fast_pp_lex_window+0x770>
  40d939:      	cmpl	$0x1, %edi
  40d93c:      	ja	0x40d950 <fast_pp_lex_window+0x7c0>
  40d93e:      	xorl	%edx, %edx
  40d940:      	cmpb	$0xd, -0x1(%rsi)
  40d944:      	sete	%dl
  40d947:      	notq	%rdx
  40d94a:      	cmpb	$0x5c, (%rsi,%rdx)
  40d94e:      	je	0x40d900 <fast_pp_lex_window+0x770>
  40d950:      	xorl	%eax, %eax
  40d952:      	movq	%rsi, 0x8(%rsp)
  40d957:      	jmp	0x40d2fb <fast_pp_lex_window+0x16b>
  40d95c:      	movq	0x40(%rsp), %rsi
  40d961:      	xorl	%ecx, %ecx
  40d963:      	cmpb	$0x3d, %al
  40d965:      	movl	$0x1a, %eax
  40d96a:      	movl	$0x2d, %edx
  40d96f:      	movq	0x30(%rsp), %rdi
  40d974:      	movq	0x38(%rsp), %r8
  40d979:      	movq	$0x0, 0x10(%rsp)
  40d982:      	movq	%r11, %r14
  40d985:      	cmovel	%edx, %eax
  40d988:      	movl	%r12d, %edx
  40d98b:      	sete	%cl
  40d98e:      	incl	%r12d
  40d991:      	movb	%al, (%rsi,%rdx)
  40d994:      	movq	0x8(%rsp), %rax
  40d999:      	movl	%eax, %esi
  40d99b:      	subl	0x20(%rsp), %esi
  40d99f:      	leaq	0x1(%rcx,%rax), %rax
  40d9a4:      	movq	%rax, 0x8(%rsp)
  40d9a9:      	xorl	%eax, %eax
  40d9ab:      	movl	%esi, (%rdi,%rdx,4)
  40d9ae:      	leal	0x1(%rcx), %esi
  40d9b1:      	movb	%sil, (%r8,%rdx)
  40d9b5:      	jmp	0x40d2fb <fast_pp_lex_window+0x16b>
  40d9ba:      	xorl	%ecx, %ecx
  40d9bc:      	tzcntq	%rsi, %rcx
  40d9c1:      	leaq	0x1(%rax,%rcx), %rax
  40d9c6:      	movq	%rax, 0x8(%rsp)
  40d9cb:      	xorl	%eax, %eax
  40d9cd:      	movq	%r11, %r14
  40d9d0:      	jmp	0x40d2fb <fast_pp_lex_window+0x16b>
  40d9d5:      	cmpb	$0x75, (%rdi)
  40d9d8:      	jne	0x40d9e4 <fast_pp_lex_window+0x854>
  40d9da:      	cmpb	$0x38, 0x1(%rdi)
  40d9de:      	sete	%sil
  40d9e2:      	jmp	0x40d9e6 <fast_pp_lex_window+0x856>
  40d9e4:      	xorl	%esi, %esi
  40d9e6:      	movb	$0x3, %al
  40d9e8:      	cmpl	$0x5c, %ecx
  40d9eb:      	je	0x40dccb <fast_pp_lex_window+0xb3b>
  40d9f1:      	cmpl	$0x27, %ecx
  40d9f4:      	jne	0x40da05 <fast_pp_lex_window+0x875>
  40d9f6:      	movzbl	(%rdi), %edx
  40d9f9:      	addb	$-0x30, %dl
  40d9fc:      	cmpb	$0xa, %dl
  40d9ff:      	jb	0x40dccb <fast_pp_lex_window+0xb3b>
  40da05:      	cmpl	$0x27, %ecx
  40da08:      	sete	%dl
  40da0b:      	cmpl	$0x22, %ecx
  40da0e:      	sete	%r8b
  40da12:      	orb	%dl, %r8b
  40da15:      	testb	%sil, %r8b
  40da18:      	jne	0x40dccb <fast_pp_lex_window+0xb3b>
  40da1e:      	movb	$0x3, %al
  40da20:      	cmpl	$0x27, %ecx
  40da23:      	je	0x40db1b <fast_pp_lex_window+0x98b>
  40da29:      	movq	0x28(%rsp), %r9
  40da2e:      	cmpl	$0x22, %ecx
  40da31:      	jne	0x40dce2 <fast_pp_lex_window+0xb52>
  40da37:      	movq	0x8(%rsp), %rcx
  40da3c:      	incq	%rcx
  40da3f:      	cmpq	%r9, %rcx
  40da42:      	jb	0x40da5c <fast_pp_lex_window+0x8cc>
  40da44:      	jmp	0x40dce2 <fast_pp_lex_window+0xb52>
  40da49:      	nopl	(%rax)
  40da50:      	addq	%rax, %rcx
  40da53:      	cmpq	%r9, %rcx
  40da56:      	jae	0x40dcc3 <fast_pp_lex_window+0xb33>
  40da5c:      	movq	%r9, %rax
  40da5f:      	subq	%rcx, %rax
  40da62:      	cmpq	$0x40, %rax
  40da66:      	jb	0x40dafc <fast_pp_lex_window+0x96c>
  40da6c:      	vmovdqu64	(%rcx), %zmm22
  40da72:      	movq	$-0x1, %rsi
  40da79:      	movl	$0x40, %eax
  40da7e:      	vpcmpeqb	%zmm20, %zmm22, %k0
  40da84:      	vpcmpeqb	%zmm21, %zmm22, %k1
  40da8a:      	korq	%k1, %k0, %k0
  40da8f:      	vpcmpeqb	%zmm17, %zmm22, %k1
  40da95:      	korq	%k0, %k1, %k0
  40da9a:      	kmovq	%k0, %rdi
  40da9f:      	andq	%rsi, %rdi
  40daa2:      	je	0x40da50 <fast_pp_lex_window+0x8c0>
  40daa4:      	xorl	%eax, %eax
  40daa6:      	tzcntq	%rdi, %rax
  40daab:      	leaq	(%rcx,%rax), %rdi
  40daaf:      	movzbl	(%rcx,%rax), %ecx
  40dab3:      	cmpl	$0x5c, %ecx
  40dab6:      	jne	0x40db6a <fast_pp_lex_window+0x9da>
  40dabc:      	leaq	0x1(%rdi), %rcx
  40dac0:      	cmpq	%r9, %rcx
  40dac3:      	jae	0x40da53 <fast_pp_lex_window+0x8c3>
  40dac5:      	cmpb	$0xd, (%rcx)
  40dac8:      	jne	0x40daf0 <fast_pp_lex_window+0x960>
  40daca:      	leaq	0x2(%rdi), %rax
  40dace:      	cmpq	%r9, %rax
  40dad1:      	jae	0x40daf0 <fast_pp_lex_window+0x960>
  40dad3:      	cmpb	$0xa, (%rax)
  40dad6:      	jne	0x40daf0 <fast_pp_lex_window+0x960>
  40dad8:      	addq	$0x3, %rdi
  40dadc:      	movq	%rdi, %rcx
  40dadf:      	jmp	0x40da53 <fast_pp_lex_window+0x8c3>
  40dae4:      	nopw	%cs:(%rax,%rax)
  40daf0:      	addq	$0x2, %rdi
  40daf4:      	movq	%rdi, %rcx
  40daf7:      	jmp	0x40da53 <fast_pp_lex_window+0x8c3>
  40dafc:      	movq	$-0x1, %rdx
  40db03:      	shlxq	%rax, %rdx, %rsi
  40db08:      	notq	%rsi
  40db0b:      	kmovq	%rsi, %k1
  40db10:      	vmovdqu8	(%rcx), %zmm22 {%k1} {z}
  40db16:      	jmp	0x40da7e <fast_pp_lex_window+0x8ee>
  40db1b:      	movq	0x8(%rsp), %rcx
  40db20:      	movq	0x28(%rsp), %r9
  40db25:      	movzbl	0x1(%rcx), %esi
  40db29:      	cmpl	$0x5c, %esi
  40db2c:      	je	0x40dbb9 <fast_pp_lex_window+0xa29>
  40db32:      	cmpl	$0xa, %esi
  40db35:      	je	0x40dce2 <fast_pp_lex_window+0xb52>
  40db3b:      	cmpl	$0x27, %esi
  40db3e:      	je	0x40dce2 <fast_pp_lex_window+0xb52>
  40db44:      	movq	0x8(%rsp), %rcx
  40db49:      	movq	%r11, %r14
  40db4c:      	movzbl	0x2(%rcx), %edi
  40db50:      	movl	$0x3, %ecx
  40db55:      	cmpb	$0x27, %dil
  40db59:      	je	0x40dbee <fast_pp_lex_window+0xa5e>
  40db5f:      	cmpb	$0x5c, %sil
  40db63:      	je	0x40dbc5 <fast_pp_lex_window+0xa35>
  40db65:      	jmp	0x40dce2 <fast_pp_lex_window+0xb52>
  40db6a:      	movb	$0x3, %al
  40db6c:      	cmpl	$0x22, %ecx
  40db6f:      	jne	0x40dce5 <fast_pp_lex_window+0xb55>
  40db75:      	movq	0x40(%rsp), %rcx
  40db7a:      	movl	%r12d, %eax
  40db7d:      	movq	0x30(%rsp), %rdx
  40db82:      	incq	%rdi
  40db85:      	incl	%r12d
  40db88:      	movq	$0x0, 0x10(%rsp)
  40db91:      	movq	%r11, %r14
  40db94:      	movb	$0x5, (%rcx,%rax)
  40db98:      	movq	0x8(%rsp), %rcx
  40db9d:      	movq	%rdi, 0x8(%rsp)
  40dba2:      	subl	0x20(%rsp), %ecx
  40dba6:      	movl	%ecx, (%rdx,%rax,4)
  40dba9:      	movq	0x38(%rsp), %rdx
  40dbae:      	movb	$0x0, (%rdx,%rax)
  40dbb2:      	xorl	%eax, %eax
  40dbb4:      	jmp	0x40d2fb <fast_pp_lex_window+0x16b>
  40dbb9:      	movq	0x8(%rsp), %rcx
  40dbbe:      	movq	%r11, %r14
  40dbc1:      	movzbl	0x2(%rcx), %edi
  40dbc5:      	movzbl	%dil, %ecx
  40dbc9:      	leaq	0xd6ab0(%rip), %rdx     # 0x4e4680 <fast_simple_escape>
  40dbd0:      	cmpb	$0x0, (%rcx,%rdx)
  40dbd4:      	je	0x40dce2 <fast_pp_lex_window+0xb52>
  40dbda:      	movq	0x8(%rsp), %rdx
  40dbdf:      	movl	$0x4, %ecx
  40dbe4:      	cmpb	$0x27, 0x3(%rdx)
  40dbe8:      	jne	0x40dce2 <fast_pp_lex_window+0xb52>
  40dbee:      	movq	0x40(%rsp), %rdx
  40dbf3:      	movl	%r12d, %eax
  40dbf6:      	movq	0x30(%rsp), %rdi
  40dbfb:      	incl	%r12d
  40dbfe:      	movq	$0x0, 0x10(%rsp)
  40dc07:      	movb	$0x4, (%rdx,%rax)
  40dc0b:      	movq	0x8(%rsp), %rdx
  40dc10:      	movl	%edx, %esi
  40dc12:      	subl	0x20(%rsp), %esi
  40dc16:      	movl	%esi, (%rdi,%rax,4)
  40dc19:      	movq	0x38(%rsp), %rdi
  40dc1e:      	movb	%cl, (%rdi,%rax)
  40dc21:      	movl	%ecx, %eax
  40dc23:      	addq	%rax, %rdx
  40dc26:      	xorl	%eax, %eax
  40dc28:      	movq	%rdx, 0x8(%rsp)
  40dc2d:      	jmp	0x40d2fb <fast_pp_lex_window+0x16b>
  40dc32:      	xorl	%esi, %esi
  40dc34:      	tzcntq	%r10, %rsi
  40dc39:      	movq	$-0x1, %rdx
  40dc40:      	movq	0x40(%rsp), %r11
  40dc45:      	movq	0x38(%rsp), %rdi
  40dc4a:      	bzhiq	%rsi, %rdx, %r8
  40dc4f:      	andq	%rcx, %r8
  40dc52:      	popcntq	%r8, %r8
  40dc57:      	addl	%r12d, %r8d
  40dc5a:      	btq	%rsi, %r13
  40dc5e:      	movl	$0x0, %esi
  40dc63:      	adcb	$0x1, %sil
  40dc67:      	blsrq	%r10, %r10
  40dc6c:      	movb	$0x0, (%r11,%r8)
  40dc71:      	movb	%sil, (%rdi,%r8)
  40dc75:      	jne	0x40dc32 <fast_pp_lex_window+0xaa2>
  40dc77:      	jmp	0x40d5fe <fast_pp_lex_window+0x46e>
  40dc7c:      	xorl	%eax, %eax
  40dc7e:      	jmp	0x40d2fb <fast_pp_lex_window+0x16b>
  40dc83:      	vextracti32x4	$0x2, %zmm23, %xmm26
  40dc8a:      	vextracti32x4	$0x3, %zmm23, %xmm23
  40dc91:      	movq	0x30(%rsp), %rdx
  40dc96:      	vpmovzxbd	%xmm26, %zmm26  # zmm26 = xmm26[0],zero,zero,zero,xmm26[1],zero,zero,zero,xmm26[2],zero,zero,zero,xmm26[3],zero,zero,zero,xmm26[4],zero,zero,zero,xmm26[5],zero,zero,zero,xmm26[6],zero,zero,zero,xmm26[7],zero,zero,zero,xmm26[8],zero,zero,zero,xmm26[9],zero,zero,zero,xmm26[10],zero,zero,zero,xmm26[11],zero,zero,zero,xmm26[12],zero,zero,zero,xmm26[13],zero,zero,zero,xmm26[14],zero,zero,zero,xmm26[15],zero,zero,zero
  40dc9c:      	vpmovzxbd	%xmm23, %zmm23  # zmm23 = xmm23[0],zero,zero,zero,xmm23[1],zero,zero,zero,xmm23[2],zero,zero,zero,xmm23[3],zero,zero,zero,xmm23[4],zero,zero,zero,xmm23[5],zero,zero,zero,xmm23[6],zero,zero,zero,xmm23[7],zero,zero,zero,xmm23[8],zero,zero,zero,xmm23[9],zero,zero,zero,xmm23[10],zero,zero,zero,xmm23[11],zero,zero,zero,xmm23[12],zero,zero,zero,xmm23[13],zero,zero,zero,xmm23[14],zero,zero,zero,xmm23[15],zero,zero,zero
  40dca2:      	vpaddd	%zmm26, %zmm24, %zmm26
  40dca8:      	vpaddd	%zmm23, %zmm24, %zmm23
  40dcae:      	vmovdqu64	%zmm26, 0x80(%rdx,%rsi,4)
  40dcb6:      	vmovdqu64	%zmm23, 0xc0(%rdx,%rsi,4)
  40dcbe:      	jmp	0x40d5ca <fast_pp_lex_window+0x43a>
  40dcc3:      	movb	$0x3, %al
  40dcc5:      	jmp	0x40dce5 <fast_pp_lex_window+0xb55>
  40dcc7:      	xorl	%eax, %eax
  40dcc9:      	jmp	0x40dce2 <fast_pp_lex_window+0xb52>
  40dccb:      	movl	%r10d, %r12d
  40dcce:      	movq	%rdi, 0x8(%rsp)
  40dcd3:      	jmp	0x40dce2 <fast_pp_lex_window+0xb52>
  40dcd5:      	movb	$0x4, %al
  40dcd7:      	jmp	0x40dce2 <fast_pp_lex_window+0xb52>
  40dcd9:      	movb	$0x1, %al
  40dcdb:      	movq	%rax, 0x10(%rsp)
  40dce0:      	movb	$0x2, %al
  40dce2:      	movl	%r15d, %r14d
  40dce5:      	movq	0x20(%rsp), %r8
  40dcea:      	movl	0x1c(%rsp), %r9d
  40dcef:      	movq	0x60(%rsp), %r10
  40dcf4:      	movq	0x48(%rsp), %rsi
  40dcf9:      	xorl	%ecx, %ecx
  40dcfb:      	movzbl	0x10(%rsp), %edx
  40dd00:      	movq	0x50(%rsp), %rdi
  40dd05:      	addq	%r14, %r8
  40dd08:      	testq	%rbx, %rbx
  40dd0b:      	cmovel	%r12d, %r9d
  40dd0f:      	cmovnel	%ecx, %edx
  40dd12:      	cmoveq	0x8(%rsp), %r8
  40dd18:      	movl	%r9d, 0xe7b0(%r10)
  40dd1f:      	movl	$0x0, 0xe7b4(%r10)
  40dd2a:      	movl	0x3c(%rsi), %esi
  40dd2d:      	movl	%esi, 0xe7b8(%r10)
  40dd34:      	incl	0xe7bc(%r10)
  40dd3b:      	movq	%r8, 0xe7c0(%r10)
  40dd42:      	movb	%al, 0xe7c8(%r10)
  40dd49:      	movb	%dl, 0xe7c9(%r10)
  40dd50:      	movb	%dil, 0xe7ca(%r10)
  40dd57:      	addq	$0x98, %rsp
  40dd5e:      	popq	%rbx
  40dd5f:      	popq	%r12
  40dd61:      	popq	%r13
  40dd63:      	popq	%r14
  40dd65:      	popq	%r15
  40dd67:      	popq	%rbp
  40dd68:      	vzeroupper
  40dd6b:      	retq
  40dd6c:      	movq	0x60(%rsp), %rdi
  40dd71:      	leaq	0xd9d9a(%rip), %rsi     # 0x4e7b12 <c_direct_test_overwrite.source+0x2cc2>
  40dd78:      	vzeroupper
  40dd7b:      	callq	0x401100 <fast_pp_bail>
  40dd80:      	movb	$0x5, %al
  40dd82:      	jmp	0x40dce5 <fast_pp_lex_window+0xb55>
  40dd87:      	movb	$0x1, %al
  40dd89:      	jmp	0x40dce2 <fast_pp_lex_window+0xb52>
  40dd8e:      	nop
