 2dd03e0:	push   %rbp
 2dd03e1:	push   %r15
 2dd03e3:	push   %r14
 2dd03e5:	push   %r13
 2dd03e7:	push   %r12
 2dd03e9:	push   %rbx
 2dd03ea:	sub    $0xf8,%rsp
 2dd03f1:	mov    0x10(%rsi),%r11
 2dd03f5:	mov    %rdi,%rcx
 2dd03f8:	cmpb   $0x0,0xe9d0(%rdi)
 2dd03ff:	mov    0x8(%rsi),%r12
 2dd0403:	mov    0x2c(%rsi),%edi
 2dd0406:	movzbl 0x45(%rsi),%ebx
 2dd040a:	mov    %r11,0x18(%rsp)
 2dd040f:	je     2dd103f <fast_pp_skip_inactive+0xc5f>
 2dd0415:	cmp    %r11,%r12
 2dd0418:	jae    2dd1a55 <fast_pp_skip_inactive+0x1675>
 2dd041e:	vbroadcasti32x4 -0x23b6128(%rip),%zmm1        # a1a300 <switch.table.ir_if_convert_test_reload+0x118>
 2dd0428:	vbroadcasti32x4 -0x23b6112(%rip),%zmm2        # a1a320 <switch.table.ir_if_convert_test_reload+0x138>
 2dd0432:	vbroadcasti32x4 -0x23b610c(%rip),%zmm3        # a1a330 <switch.table.ir_if_convert_test_reload+0x148>
 2dd043c:	vbroadcasti32x4 -0x23b6106(%rip),%zmm4        # a1a340 <switch.table.ir_if_convert_test_reload+0x158>
 2dd0446:	vbroadcasti32x4 -0x23b6100(%rip),%zmm5        # a1a350 <switch.table.ir_if_convert_test_reload+0x168>
 2dd0450:	vbroadcasti32x4 -0x23b60fa(%rip),%zmm6        # a1a360 <switch.table.ir_if_convert_test_reload+0x178>
 2dd045a:	vbroadcasti32x4 -0x23b60f4(%rip),%zmm7        # a1a370 <switch.table.ir_if_convert_test_reload+0x188>
 2dd0464:	vbroadcasti32x4 -0x23b60ee(%rip),%zmm8        # a1a380 <switch.table.ir_if_convert_test_reload+0x198>
 2dd046e:	vbroadcasti32x4 -0x23b60e8(%rip),%zmm9        # a1a390 <switch.table.ir_if_convert_test_reload+0x1a8>
 2dd0478:	vbroadcasti32x4 -0x23b60e2(%rip),%zmm10        # a1a3a0 <switch.table.ir_if_convert_test_reload+0x1b8>
 2dd0482:	vbroadcasti32x4 -0x23b60dc(%rip),%zmm11        # a1a3b0 <switch.table.ir_if_convert_test_reload+0x1c8>
 2dd048c:	mov    %rcx,0x38(%rsp)
 2dd0491:	movq   $0x0,0x70(%rsp)
 2dd049a:	movq   $0x0,0x80(%rsp)
 2dd04a6:	movl   $0x0,0x34(%rsp)
 2dd04ae:	xor    %r9d,%r9d
 2dd04b1:	xor    %ebp,%ebp
 2dd04b3:	xor    %r14d,%r14d
 2dd04b6:	xor    %eax,%eax
 2dd04b8:	xor    %r8d,%r8d
 2dd04bb:	xor    %r10d,%r10d
 2dd04be:	mov    %r12,0x8(%rsp)
 2dd04c3:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 2dd04d0:	mov    %r11,%rdx
 2dd04d3:	sub    %r12,%rdx
 2dd04d6:	mov    %rbx,%r13
 2dd04d9:	mov    %rax,0x50(%rsp)
 2dd04de:	mov    %r12,0x58(%rsp)
 2dd04e3:	mov    %r8,0x40(%rsp)
 2dd04e8:	mov    %r14,0x28(%rsp)
 2dd04ed:	mov    %rbp,%rbx
 2dd04f0:	cmp    $0x40,%rdx
 2dd04f4:	jb     2dd07c8 <fast_pp_skip_inactive+0x3e8>
 2dd04fa:	vmovdqu64 (%r12),%zmm12
 2dd0501:	mov    $0x40,%edx
 2dd0506:	vpcmpeqb %zmm1,%zmm12,%k0
 2dd050c:	vpcmpeqb %zmm6,%zmm12,%k1
 2dd0512:	mov    $0xffffffffffffffff,%rax
 2dd0519:	vpaddb %zmm9,%zmm12,%zmm0
 2dd051f:	mov    %rdx,0xa8(%rsp)
 2dd0527:	kmovq  %k0,%r15
 2dd052c:	vpcmpeqb %zmm5,%zmm12,%k0
 2dd0532:	bzhi   %rdx,%rax,%rbp
 2dd0537:	korq   %k1,%k0,%k1
 2dd053c:	mov    %rbp,0x48(%rsp)
 2dd0541:	not    %rbp
 2dd0544:	lea    (%r15,%r15,1),%r12
 2dd0548:	mov    %r15,%r8
 2dd054b:	not    %r8
 2dd054e:	kmovq  %k1,%r14
 2dd0553:	vpcmpeqb %zmm7,%zmm12,%k1
 2dd0559:	or     %r13,%r12
 2dd055c:	kmovq  %k1,%rax
 2dd0561:	vpcmpeqb %zmm8,%zmm12,%k1
 2dd0567:	kmovq  %k1,%rcx
 2dd056c:	vpcmpltub %zmm10,%zmm0,%k1
 2dd0573:	mov    %rax,0xa0(%rsp)
 2dd057b:	kmovq  %k1,%rdx
 2dd0580:	or     %rcx,%rbp
 2dd0583:	lea    (%rax,%rax,1),%rcx
 2dd0587:	vpcmpeqb %zmm11,%zmm12,%k1
 2dd058d:	andn   %rdx,%r15,%rdx
 2dd0592:	or     %rdx,%rbp
 2dd0595:	mov    %rbp,%r13
 2dd0598:	and    %r12,%r13
 2dd059b:	add    %rbp,%r13
 2dd059e:	setb   0x33(%rsp)
 2dd05a3:	or     %rcx,%rbx
 2dd05a6:	or     %r8,%rbx
 2dd05a9:	add    $0xff,%r9b
 2dd05ad:	adc    %rbx,%r14
 2dd05b0:	mov    %rbx,0x20(%rsp)
 2dd05b5:	mov    %r14,0x78(%rsp)
 2dd05ba:	kmovq  %k1,%r14
 2dd05bf:	setb   %al
 2dd05c2:	lea    (%r14,%r14,1),%rbx
 2dd05c6:	mov    %rax,0x60(%rsp)
 2dd05cb:	kmovq  %k0,%rax
 2dd05d0:	or     %r10,%rbx
 2dd05d3:	and    %rax,%rbx
 2dd05d6:	jne    2dd06a2 <fast_pp_skip_inactive+0x2c2>
 2dd05dc:	xor    %r10d,%r10d
 2dd05df:	vpcmpeqb %zmm2,%zmm12,%k0
 2dd05e5:	vpcmpeqb %zmm4,%zmm12,%k1
 2dd05eb:	or     %r12,%r13
 2dd05ee:	kmovq  %k0,%rax
 2dd05f3:	vpcmpeqb %zmm3,%zmm12,%k0
 2dd05f9:	andn   %r13,%rbp,%r9
 2dd05fe:	kmovq  %k0,%rdx
 2dd0603:	korq   %k0,%k1,%k1
 2dd0608:	and    %r9,%rax
 2dd060b:	lea    (%rdx,%rdx,1),%rcx
 2dd060f:	or     0x28(%rsp),%rcx
 2dd0614:	kmovq  %k1,%r8
 2dd0619:	and    %r8,%rcx
 2dd061c:	mov    0x78(%rsp),%r8
 2dd0621:	or     %rax,%rcx
 2dd0624:	andn   0x20(%rsp),%r8,%r8
 2dd062b:	or     %r10,%rcx
 2dd062e:	and    0x48(%rsp),%rcx
 2dd0633:	jne    2dd07e8 <fast_pp_skip_inactive+0x408>
 2dd0639:	movzbl 0x33(%rsp),%eax
 2dd063e:	xor    %ecx,%ecx
 2dd0640:	mov    0xa0(%rsp),%rbp
 2dd0648:	mov    0x58(%rsp),%r12
 2dd064d:	shr    $0x3f,%r9
 2dd0651:	shr    $0x3f,%r14
 2dd0655:	shr    $0x3f,%rdx
 2dd0659:	shr    $0x3f,%r8
 2dd065d:	add    0xa8(%rsp),%r12
 2dd0665:	mov    %r14,%r10
 2dd0668:	mov    %rdx,%r14
 2dd066b:	mov    %al,%cl
 2dd066d:	popcnt %r15,%rax
 2dd0672:	shr    $0x3f,%r15
 2dd0676:	shr    $0x3f,%rbp
 2dd067a:	add    %eax,%edi
 2dd067c:	mov    %r9,%rax
 2dd067f:	mov    0x60(%rsp),%r9
 2dd0684:	or     %rcx,%r15
 2dd0687:	xor    %ecx,%ecx
 2dd0689:	mov    %r15,%rbx
 2dd068c:	cmp    %r11,%r12
 2dd068f:	jae    2dd1b4c <fast_pp_skip_inactive+0x176c>
 2dd0695:	test   %cl,%cl
 2dd0697:	je     2dd04d0 <fast_pp_skip_inactive+0xf0>
 2dd069d:	jmp    2dd1b4c <fast_pp_skip_inactive+0x176c>
 2dd06a2:	mov    (%rsi),%rax
 2dd06a5:	xor    %r10d,%r10d
 2dd06a8:	mov    %rsi,0x10(%rsp)
 2dd06ad:	mov    %edi,0x4(%rsp)
 2dd06b1:	vmovdqu64 %zmm12,0xb0(%rsp)
 2dd06bc:	mov    %rax,0x90(%rsp)
 2dd06c4:	mov    0x38(%rsp),%rax
 2dd06c9:	movzbl 0xe9d0(%rax),%eax
 2dd06d0:	mov    %al,0x32(%rsp)
 2dd06d4:	mov    0x58(%rsp),%rax
 2dd06d9:	movzbl 0x32(%rsp),%edx
 2dd06de:	mov    0x90(%rsp),%rdi
 2dd06e6:	xor    %ecx,%ecx
 2dd06e8:	tzcnt  %rbx,%rcx
 2dd06ed:	mov    %r10,0x98(%rsp)
 2dd06f5:	mov    %rcx,0x88(%rsp)
 2dd06fd:	lea    (%rax,%rcx,1),%rsi
 2dd0701:	vzeroupper
 2dd0704:	call   45de670 <fast_raw_string_before>
 2dd0709:	vmovdqu64 0xb0(%rsp),%zmm12
 2dd0714:	vbroadcasti32x4 -0x23b636e(%rip),%zmm11        # a1a3b0 <switch.table.ir_if_convert_test_reload+0x1c8>
 2dd071e:	vbroadcasti32x4 -0x23b6388(%rip),%zmm10        # a1a3a0 <switch.table.ir_if_convert_test_reload+0x1b8>
 2dd0728:	vbroadcasti32x4 -0x23b63a2(%rip),%zmm9        # a1a390 <switch.table.ir_if_convert_test_reload+0x1a8>
 2dd0732:	vbroadcasti32x4 -0x23b63bc(%rip),%zmm8        # a1a380 <switch.table.ir_if_convert_test_reload+0x198>
 2dd073c:	vbroadcasti32x4 -0x23b63d6(%rip),%zmm7        # a1a370 <switch.table.ir_if_convert_test_reload+0x188>
 2dd0746:	vbroadcasti32x4 -0x23b63f0(%rip),%zmm6        # a1a360 <switch.table.ir_if_convert_test_reload+0x178>
 2dd0750:	vbroadcasti32x4 -0x23b640a(%rip),%zmm5        # a1a350 <switch.table.ir_if_convert_test_reload+0x168>
 2dd075a:	vbroadcasti32x4 -0x23b6424(%rip),%zmm4        # a1a340 <switch.table.ir_if_convert_test_reload+0x158>
 2dd0764:	vbroadcasti32x4 -0x23b643e(%rip),%zmm3        # a1a330 <switch.table.ir_if_convert_test_reload+0x148>
 2dd076e:	vbroadcasti32x4 -0x23b6458(%rip),%zmm2        # a1a320 <switch.table.ir_if_convert_test_reload+0x138>
 2dd0778:	vbroadcasti32x4 -0x23b6482(%rip),%zmm1        # a1a300 <switch.table.ir_if_convert_test_reload+0x118>
 2dd0782:	mov    0x88(%rsp),%rdx
 2dd078a:	mov    0x98(%rsp),%r10
 2dd0792:	mov    0x18(%rsp),%r11
 2dd0797:	mov    0x4(%rsp),%edi
 2dd079b:	mov    0x10(%rsp),%rsi
 2dd07a0:	mov    $0x1,%ecx
 2dd07a5:	test   %al,%al
 2dd07a7:	mov    $0x0,%eax
 2dd07ac:	shlx   %rdx,%rcx,%rcx
 2dd07b1:	cmove  %rax,%rcx
 2dd07b5:	or     %rcx,%r10
 2dd07b8:	blsr   %rbx,%rbx
 2dd07bd:	je     2dd05df <fast_pp_skip_inactive+0x1ff>
 2dd07c3:	jmp    2dd06d4 <fast_pp_skip_inactive+0x2f4>
 2dd07c8:	mov    $0xffffffffffffffff,%rax
 2dd07cf:	shlx   %rdx,%rax,%rcx
 2dd07d4:	not    %rcx
 2dd07d7:	kmovq  %rcx,%k1
 2dd07dc:	vmovdqu8 (%r12),%zmm12{%k1}{z}
 2dd07e3:	jmp    2dd0506 <fast_pp_skip_inactive+0x126>
 2dd07e8:	mov    0x58(%rsp),%r14
 2dd07ed:	xor    %edx,%edx
 2dd07ef:	tzcnt  %rcx,%rdx
 2dd07f4:	mov    $0x0,%ebp
 2dd07f9:	mov    %edi,%ebx
 2dd07fb:	shrx   %rdx,%r10,%rcx
 2dd0800:	shrx   %rdx,%rax,%rax
 2dd0805:	mov    %rcx,%r10
 2dd0808:	or     $0xfffffffffffffffe,%r10
 2dd080c:	inc    %r10
 2dd080f:	test   $0x1,%al
 2dd0811:	cmove  %r10,%rbp
 2dd0815:	lea    (%r14,%rdx,1),%r12
 2dd0819:	add    %rbp,%r12
 2dd081c:	test   $0x1,%al
 2dd081e:	je     2dd0843 <fast_pp_skip_inactive+0x463>
 2dd0820:	mov    0x50(%rsp),%r13
 2dd0825:	test   $0x1,%cl
 2dd0828:	jne    2dd0c02 <fast_pp_skip_inactive+0x822>
 2dd082e:	shrx   %rdx,%r8,%r8
 2dd0833:	mov    $0x1,%edi
 2dd0838:	and    $0x1,%r8d
 2dd083c:	mov    %rdi,0x28(%rsp)
 2dd0841:	jmp    2dd0898 <fast_pp_skip_inactive+0x4b8>
 2dd0843:	mov    $0xffffffff,%edi
 2dd0848:	lea    (%rdx,%rdi,1),%r10d
 2dd084c:	mov    0x50(%rsp),%rdi
 2dd0851:	shrx   %r10,%r9,%r9
 2dd0856:	and    $0x1,%r9d
 2dd085a:	test   %rdx,%rdx
 2dd085d:	mov    %edi,%r11d
 2dd0860:	cmovne %r9d,%r11d
 2dd0864:	mov    %rdi,%r13
 2dd0867:	xor    %edi,%edi
 2dd0869:	test   %r11d,%r11d
 2dd086c:	setne  %dil
 2dd0870:	mov    %rdi,0x28(%rsp)
 2dd0875:	test   $0x1,%cl
 2dd0878:	jne    2dd0c0d <fast_pp_skip_inactive+0x82d>
 2dd087e:	test   %rdx,%rdx
 2dd0881:	je     2dd088e <fast_pp_skip_inactive+0x4ae>
 2dd0883:	shrx   %r10,%r8,%r8
 2dd0888:	and    $0x1,%r8d
 2dd088c:	jmp    2dd0893 <fast_pp_skip_inactive+0x4b3>
 2dd088e:	mov    0x40(%rsp),%r8
 2dd0893:	mov    0x18(%rsp),%r11
 2dd0898:	mov    $0xffffffffffffffff,%rdi
 2dd089f:	bzhi   %rdx,%rdi,%r9
 2dd08a4:	and    %r15,%r9
 2dd08a7:	popcnt %r9,%r9
 2dd08ac:	add    %r9d,%ebx
 2dd08af:	test   %r8d,%r8d
 2dd08b2:	jne    2dd0c24 <fast_pp_skip_inactive+0x844>
 2dd08b8:	mov    0x38(%rsp),%r14
 2dd08bd:	test   $0x1,%al
 2dd08bf:	je     2dd0cf4 <fast_pp_skip_inactive+0x914>
 2dd08c5:	inc    %r12
 2dd08c8:	mov    %rsi,0x10(%rsp)
 2dd08cd:	mov    %ebx,0x4(%rsp)
 2dd08d1:	mov    %r11,%rsi
 2dd08d4:	mov    %r12,%rdi
 2dd08d7:	vzeroupper
 2dd08da:	call   45dad30 <fast_skip_hspace>
 2dd08df:	mov    0x18(%rsp),%r11
 2dd08e4:	mov    %rax,%rdi
 2dd08e7:	cmp    %r11,%rax
 2dd08ea:	jae    2dd08fc <fast_pp_skip_inactive+0x51c>
 2dd08ec:	movzbl (%rdi),%ebx
 2dd08ef:	lea    -0x23b2bb6(%rip),%rax        # a1dd40 <fast_char_class>
 2dd08f6:	testb  $0x2,(%rbx,%rax,1)
 2dd08fa:	jne    2dd0912 <fast_pp_skip_inactive+0x532>
 2dd08fc:	mov    %rdi,0x8(%rsp)
 2dd0901:	mov    %rdi,%r12
 2dd0904:	mov    0x10(%rsp),%rsi
 2dd0909:	mov    0x4(%rsp),%edi
 2dd090d:	jmp    2dd0a77 <fast_pp_skip_inactive+0x697>
 2dd0912:	mov    %r11,%rsi
 2dd0915:	mov    %rdi,%r14
 2dd0918:	call   45dd190 <fast_scan_ident_len>
 2dd091d:	lea    -0x2(%rax),%ecx
 2dd0920:	mov    %r14,%rsi
 2dd0923:	cmp    $0x6,%ecx
 2dd0926:	ja     2dd0a5c <fast_pp_skip_inactive+0x67c>
 2dd092c:	lea    -0x23ac7df(%rip),%rdx        # a24154 <c_direct_test_dependencies.levels+0x57>
 2dd0933:	movslq (%rdx,%rcx,4),%rcx
 2dd0937:	add    %rdx,%rcx
 2dd093a:	jmp    *%rcx
 2dd093c:	cmp    $0x69,%bl
 2dd093f:	jne    2dd0a5c <fast_pp_skip_inactive+0x67c>
 2dd0945:	cmpb   $0x66,0x1(%rsi)
 2dd0949:	je     2dd0a0b <fast_pp_skip_inactive+0x62b>
 2dd094f:	jmp    2dd0a5c <fast_pp_skip_inactive+0x67c>
 2dd0954:	movzbl 0x4(%rsi),%edi
 2dd0958:	mov    (%rsi),%ecx
 2dd095a:	mov    $0x65646669,%edx
 2dd095f:	xor    %edx,%ecx
 2dd0961:	xor    $0x66,%edi
 2dd0964:	or     %ecx,%edi
 2dd0966:	je     2dd0a0b <fast_pp_skip_inactive+0x62b>
 2dd096c:	movzbl 0x4(%rsi),%edi
 2dd0970:	mov    (%rsi),%ecx
 2dd0972:	mov    $0x69646e65,%edx
 2dd0977:	xor    %edx,%ecx
 2dd0979:	xor    $0x66,%edi
 2dd097c:	or     %ecx,%edi
 2dd097e:	jne    2dd0a5c <fast_pp_skip_inactive+0x67c>
 2dd0984:	add    $0x5,%rsi
 2dd0988:	cmpl   $0x0,0x70(%rsp)
 2dd098d:	mov    %rsi,0x8(%rsp)
 2dd0992:	je     2dd1ae5 <fast_pp_skip_inactive+0x1705>
 2dd0998:	mov    0x70(%rsp),%rax
 2dd099d:	xor    %ecx,%ecx
 2dd099f:	dec    %eax
 2dd09a1:	mov    %rax,0x70(%rsp)
 2dd09a6:	mov    0x8(%rsp),%r12
 2dd09ab:	xor    %r10d,%r10d
 2dd09ae:	xor    %r14d,%r14d
 2dd09b1:	xor    %ebp,%ebp
 2dd09b3:	xor    %r9d,%r9d
 2dd09b6:	xor    %ebx,%ebx
 2dd09b8:	jmp    2dd0b77 <fast_pp_skip_inactive+0x797>
 2dd09bd:	movabs $0x6665646e66696c65,%rcx
 2dd09c7:	cmp    %rcx,(%rsi)
 2dd09ca:	jne    2dd0a5c <fast_pp_skip_inactive+0x67c>
 2dd09d0:	mov    $0x32,%bpl
 2dd09d3:	jmp    2dd0b0d <fast_pp_skip_inactive+0x72d>
 2dd09d8:	cmpl   $0x65736c65,(%rsi)
 2dd09de:	je     2dd0afe <fast_pp_skip_inactive+0x71e>
 2dd09e4:	cmpl   $0x66696c65,(%rsi)
 2dd09ea:	jne    2dd0a5c <fast_pp_skip_inactive+0x67c>
 2dd09ec:	mov    $0x4,%bpl
 2dd09ef:	jmp    2dd0b20 <fast_pp_skip_inactive+0x740>
 2dd09f4:	movzwl 0x4(%rsi),%edi
 2dd09f8:	mov    (%rsi),%ecx
 2dd09fa:	mov    $0x646e6669,%edx
 2dd09ff:	xor    %edx,%ecx
 2dd0a01:	xor    $0x6665,%edi
 2dd0a07:	or     %ecx,%edi
 2dd0a09:	jne    2dd0a5c <fast_pp_skip_inactive+0x67c>
 2dd0a0b:	mov    0x70(%rsp),%rcx
 2dd0a10:	mov    %eax,%eax
 2dd0a12:	add    %rax,%rsi
 2dd0a15:	xor    %eax,%eax
 2dd0a17:	mov    0x80(%rsp),%rdx
 2dd0a1f:	inc    %ecx
 2dd0a21:	cmp    $0x40,%ecx
 2dd0a24:	mov    %rcx,0x70(%rsp)
 2dd0a29:	setae  %al
 2dd0a2c:	btr    %rcx,%rdx
 2dd0a30:	or     %eax,0x34(%rsp)
 2dd0a34:	mov    %rdx,0x80(%rsp)
 2dd0a3c:	jmp    2dd0a61 <fast_pp_skip_inactive+0x681>
 2dd0a3e:	mov    (%rsi),%ecx
 2dd0a40:	mov    0x3(%rsi),%r8d
 2dd0a44:	mov    $0x66696c65,%edx
 2dd0a49:	mov    $0x66656466,%edi
 2dd0a4e:	xor    %edx,%ecx
 2dd0a50:	xor    %edi,%r8d
 2dd0a53:	or     %ecx,%r8d
 2dd0a56:	je     2dd0b0a <fast_pp_skip_inactive+0x72a>
 2dd0a5c:	mov    %eax,%eax
 2dd0a5e:	add    %rax,%rsi
 2dd0a61:	mov    %rsi,0x8(%rsp)
 2dd0a66:	mov    %rsi,%r12
 2dd0a69:	mov    0x10(%rsp),%rsi
 2dd0a6e:	mov    0x4(%rsp),%edi
 2dd0a72:	mov    0x18(%rsp),%r11
 2dd0a77:	xor    %ecx,%ecx
 2dd0a79:	xor    %r10d,%r10d
 2dd0a7c:	xor    %r14d,%r14d
 2dd0a7f:	xor    %ebp,%ebp
 2dd0a81:	xor    %r9d,%r9d
 2dd0a84:	xor    %ebx,%ebx
 2dd0a86:	vbroadcasti32x4 -0x23b6790(%rip),%zmm1        # a1a300 <switch.table.ir_if_convert_test_reload+0x118>
 2dd0a90:	vbroadcasti32x4 -0x23b677a(%rip),%zmm2        # a1a320 <switch.table.ir_if_convert_test_reload+0x138>
 2dd0a9a:	vbroadcasti32x4 -0x23b6774(%rip),%zmm3        # a1a330 <switch.table.ir_if_convert_test_reload+0x148>
 2dd0aa4:	vbroadcasti32x4 -0x23b676e(%rip),%zmm4        # a1a340 <switch.table.ir_if_convert_test_reload+0x158>
 2dd0aae:	vbroadcasti32x4 -0x23b6768(%rip),%zmm5        # a1a350 <switch.table.ir_if_convert_test_reload+0x168>
 2dd0ab8:	vbroadcasti32x4 -0x23b6762(%rip),%zmm6        # a1a360 <switch.table.ir_if_convert_test_reload+0x178>
 2dd0ac2:	vbroadcasti32x4 -0x23b675c(%rip),%zmm7        # a1a370 <switch.table.ir_if_convert_test_reload+0x188>
 2dd0acc:	vbroadcasti32x4 -0x23b6756(%rip),%zmm8        # a1a380 <switch.table.ir_if_convert_test_reload+0x198>
 2dd0ad6:	vbroadcasti32x4 -0x23b6750(%rip),%zmm9        # a1a390 <switch.table.ir_if_convert_test_reload+0x1a8>
 2dd0ae0:	vbroadcasti32x4 -0x23b674a(%rip),%zmm10        # a1a3a0 <switch.table.ir_if_convert_test_reload+0x1b8>
 2dd0aea:	vbroadcasti32x4 -0x23b6744(%rip),%zmm11        # a1a3b0 <switch.table.ir_if_convert_test_reload+0x1c8>
 2dd0af4:	mov    0x40(%rsp),%r8
 2dd0af9:	jmp    2dd0de9 <fast_pp_skip_inactive+0xa09>
 2dd0afe:	mov    $0xffffffffffffffff,%rcx
 2dd0b05:	mov    $0x5,%bpl
 2dd0b08:	jmp    2dd0b22 <fast_pp_skip_inactive+0x742>
 2dd0b0a:	mov    $0x31,%bpl
 2dd0b0d:	mov    0x38(%rsp),%rcx
 2dd0b12:	movzbl 0xe979(%rcx),%ecx
 2dd0b19:	xor    $0x1,%ecx
 2dd0b1c:	or     %ecx,0x34(%rsp)
 2dd0b20:	xor    %ecx,%ecx
 2dd0b22:	mov    0x70(%rsp),%rdx
 2dd0b27:	mov    %eax,%eax
 2dd0b29:	add    %rax,%rsi
 2dd0b2c:	mov    %rsi,0x8(%rsp)
 2dd0b31:	test   %edx,%edx
 2dd0b33:	je     2dd1ae8 <fast_pp_skip_inactive+0x1708>
 2dd0b39:	mov    0x80(%rsp),%rdi
 2dd0b41:	mov    $0x1,%eax
 2dd0b46:	xor    %r10d,%r10d
 2dd0b49:	xor    %r14d,%r14d
 2dd0b4c:	xor    %ebp,%ebp
 2dd0b4e:	xor    %r9d,%r9d
 2dd0b51:	xor    %ebx,%ebx
 2dd0b53:	mov    %rsi,%r12
 2dd0b56:	shlx   %rdx,%rax,%rax
 2dd0b5b:	and    %rax,%rcx
 2dd0b5e:	shrx   %rdx,%rdi,%rax
 2dd0b63:	or     %rcx,%rdi
 2dd0b66:	xor    %ecx,%ecx
 2dd0b68:	and    $0x1,%eax
 2dd0b6b:	mov    %rdi,0x80(%rsp)
 2dd0b73:	or     %eax,0x34(%rsp)
 2dd0b77:	vbroadcasti32x4 -0x23b6881(%rip),%zmm1        # a1a300 <switch.table.ir_if_convert_test_reload+0x118>
 2dd0b81:	vbroadcasti32x4 -0x23b686b(%rip),%zmm2        # a1a320 <switch.table.ir_if_convert_test_reload+0x138>
 2dd0b8b:	vbroadcasti32x4 -0x23b6865(%rip),%zmm3        # a1a330 <switch.table.ir_if_convert_test_reload+0x148>
 2dd0b95:	vbroadcasti32x4 -0x23b685f(%rip),%zmm4        # a1a340 <switch.table.ir_if_convert_test_reload+0x158>
 2dd0b9f:	vbroadcasti32x4 -0x23b6859(%rip),%zmm5        # a1a350 <switch.table.ir_if_convert_test_reload+0x168>
 2dd0ba9:	vbroadcasti32x4 -0x23b6853(%rip),%zmm6        # a1a360 <switch.table.ir_if_convert_test_reload+0x178>
 2dd0bb3:	vbroadcasti32x4 -0x23b684d(%rip),%zmm7        # a1a370 <switch.table.ir_if_convert_test_reload+0x188>
 2dd0bbd:	vbroadcasti32x4 -0x23b6847(%rip),%zmm8        # a1a380 <switch.table.ir_if_convert_test_reload+0x198>
 2dd0bc7:	vbroadcasti32x4 -0x23b6841(%rip),%zmm9        # a1a390 <switch.table.ir_if_convert_test_reload+0x1a8>
 2dd0bd1:	vbroadcasti32x4 -0x23b683b(%rip),%zmm10        # a1a3a0 <switch.table.ir_if_convert_test_reload+0x1b8>
 2dd0bdb:	vbroadcasti32x4 -0x23b6835(%rip),%zmm11        # a1a3b0 <switch.table.ir_if_convert_test_reload+0x1c8>
 2dd0be5:	mov    0x10(%rsp),%rsi
 2dd0bea:	mov    0x4(%rsp),%edi
 2dd0bee:	mov    0x18(%rsp),%r11
 2dd0bf3:	mov    0x50(%rsp),%rax
 2dd0bf8:	mov    0x40(%rsp),%r8
 2dd0bfd:	jmp    2dd068c <fast_pp_skip_inactive+0x2ac>
 2dd0c02:	mov    $0x1,%r8d
 2dd0c08:	mov    %r8,0x28(%rsp)
 2dd0c0d:	mov    $0xffffffffffffffff,%r8
 2dd0c14:	bzhi   %rdx,%r8,%r8
 2dd0c19:	and    %r15,%r8
 2dd0c1c:	popcnt %r8,%r8
 2dd0c21:	add    %r8d,%ebx
 2dd0c24:	mov    %ebx,0x4(%rsp)
 2dd0c28:	mov    %rsi,0x10(%rsp)
 2dd0c2d:	mov    %r12,0x20(%rsp)
 2dd0c32:	cmp    0x8(%rsp),%r12
 2dd0c37:	jbe    2dd0c79 <fast_pp_skip_inactive+0x899>
 2dd0c39:	mov    0x20(%rsp),%r12
 2dd0c3e:	lea    0x0(%rbp,%rdx,1),%rsi
 2dd0c43:	lea    -0x1(%r14,%rsi,1),%rsi
 2dd0c48:	jmp    2dd0c58 <fast_pp_skip_inactive+0x878>
 2dd0c4a:	dec    %r12
 2dd0c4d:	cmp    0x8(%rsp),%rsi
 2dd0c52:	lea    -0x1(%rsi),%rsi
 2dd0c56:	jbe    2dd0c6c <fast_pp_skip_inactive+0x88c>
 2dd0c58:	cmpb   $0xa,(%rsi)
 2dd0c5b:	jne    2dd0c4a <fast_pp_skip_inactive+0x86a>
 2dd0c5d:	cmp    0x8(%rsp),%rsi
 2dd0c62:	jbe    2dd0c73 <fast_pp_skip_inactive+0x893>
 2dd0c64:	cmpb   $0x5c,-0x1(%rsi)
 2dd0c68:	je     2dd0c4a <fast_pp_skip_inactive+0x86a>
 2dd0c6a:	jmp    2dd0c79 <fast_pp_skip_inactive+0x899>
 2dd0c6c:	mov    0x8(%rsp),%r12
 2dd0c71:	jmp    2dd0c79 <fast_pp_skip_inactive+0x899>
 2dd0c73:	inc    %rsi
 2dd0c76:	mov    %rsi,%r12
 2dd0c79:	and    $0x1,%ecx
 2dd0c7c:	add    0x20(%rsp),%rcx
 2dd0c81:	cmp    %rcx,%r12
 2dd0c84:	jae    2dd0ccf <fast_pp_skip_inactive+0x8ef>
 2dd0c86:	mov    %rbp,%r15
 2dd0c89:	add    %rdx,%r15
 2dd0c8c:	lea    0x30(%r12),%rbx
 2dd0c91:	mov    %r12,%r13
 2dd0c94:	add    %r14,%r15
 2dd0c97:	xor    %r14d,%r14d
 2dd0c9a:	mov    %r15,0x58(%rsp)
 2dd0c9f:	sub    %r12,%r15
 2dd0ca2:	movzbl (%r12,%r14,1),%ebp
 2dd0ca7:	cmp    $0x22,%ebp
 2dd0caa:	je     2dd0df1 <fast_pp_skip_inactive+0xa11>
 2dd0cb0:	cmp    $0x27,%ebp
 2dd0cb3:	je     2dd0e19 <fast_pp_skip_inactive+0xa39>
 2dd0cb9:	lea    0x1(%r12,%r14,1),%rdx
 2dd0cbe:	inc    %r14
 2dd0cc1:	dec    %r15
 2dd0cc4:	inc    %rbx
 2dd0cc7:	inc    %r13
 2dd0cca:	cmp    %rcx,%rdx
 2dd0ccd:	jb     2dd0ca2 <fast_pp_skip_inactive+0x8c2>
 2dd0ccf:	mov    0x10(%rsp),%rsi
 2dd0cd4:	mov    0x4(%rsp),%ebx
 2dd0cd8:	mov    0x18(%rsp),%r11
 2dd0cdd:	mov    0x50(%rsp),%r13
 2dd0ce2:	mov    0x20(%rsp),%r12
 2dd0ce7:	mov    0x38(%rsp),%r14
 2dd0cec:	test   $0x1,%al
 2dd0cee:	jne    2dd08c5 <fast_pp_skip_inactive+0x4e5>
 2dd0cf4:	movl   $0x0,0x6c(%rsp)
 2dd0cfc:	lea    0x2(%r12),%rdi
 2dd0d01:	mov    %ebx,%ebp
 2dd0d03:	mov    %rsi,%rbx
 2dd0d06:	cmpb   $0x2a,0x1(%r12)
 2dd0d0c:	jne    2dd0d3e <fast_pp_skip_inactive+0x95e>
 2dd0d0e:	lea    0x6c(%rsp),%rdx
 2dd0d13:	mov    %r11,%rsi
 2dd0d16:	vzeroupper
 2dd0d19:	call   45dc940 <fast_skip_block_comment>
 2dd0d1e:	test   %rax,%rax
 2dd0d21:	jne    2dd0d4e <fast_pp_skip_inactive+0x96e>
 2dd0d23:	lea    -0x23a9e22(%rip),%rsi        # a26f08 <fast_cc_binary_questioned.range_narrow+0x29a8>
 2dd0d2a:	mov    %r14,%rdi
 2dd0d2d:	call   45da059 <fast_pp_bail>
 2dd0d32:	mov    0x18(%rsp),%r11
 2dd0d37:	mov    $0x1,%cl
 2dd0d39:	mov    %r11,%rax
 2dd0d3c:	jmp    2dd0d55 <fast_pp_skip_inactive+0x975>
 2dd0d3e:	lea    0x6c(%rsp),%rdx
 2dd0d43:	mov    %r11,%rsi
 2dd0d46:	vzeroupper
 2dd0d49:	call   45dca30 <fast_skip_line_comment>
 2dd0d4e:	mov    0x18(%rsp),%r11
 2dd0d53:	xor    %ecx,%ecx
 2dd0d55:	vbroadcasti32x4 -0x23b6a5f(%rip),%zmm1        # a1a300 <switch.table.ir_if_convert_test_reload+0x118>
 2dd0d5f:	vbroadcasti32x4 -0x23b6a49(%rip),%zmm2        # a1a320 <switch.table.ir_if_convert_test_reload+0x138>
 2dd0d69:	vbroadcasti32x4 -0x23b6a43(%rip),%zmm3        # a1a330 <switch.table.ir_if_convert_test_reload+0x148>
 2dd0d73:	vbroadcasti32x4 -0x23b6a3d(%rip),%zmm4        # a1a340 <switch.table.ir_if_convert_test_reload+0x158>
 2dd0d7d:	vbroadcasti32x4 -0x23b6a37(%rip),%zmm5        # a1a350 <switch.table.ir_if_convert_test_reload+0x168>
 2dd0d87:	vbroadcasti32x4 -0x23b6a31(%rip),%zmm6        # a1a360 <switch.table.ir_if_convert_test_reload+0x178>
 2dd0d91:	vbroadcasti32x4 -0x23b6a2b(%rip),%zmm7        # a1a370 <switch.table.ir_if_convert_test_reload+0x188>
 2dd0d9b:	vbroadcasti32x4 -0x23b6a25(%rip),%zmm8        # a1a380 <switch.table.ir_if_convert_test_reload+0x198>
 2dd0da5:	vbroadcasti32x4 -0x23b6a1f(%rip),%zmm9        # a1a390 <switch.table.ir_if_convert_test_reload+0x1a8>
 2dd0daf:	vbroadcasti32x4 -0x23b6a19(%rip),%zmm10        # a1a3a0 <switch.table.ir_if_convert_test_reload+0x1b8>
 2dd0db9:	vbroadcasti32x4 -0x23b6a13(%rip),%zmm11        # a1a3b0 <switch.table.ir_if_convert_test_reload+0x1c8>
 2dd0dc3:	mov    %ebp,%edi
 2dd0dc5:	mov    %rbx,%rsi
 2dd0dc8:	add    0x6c(%rsp),%edi
 2dd0dcc:	mov    0x40(%rsp),%r8
 2dd0dd1:	mov    0x28(%rsp),%rbx
 2dd0dd6:	xor    %r10d,%r10d
 2dd0dd9:	xor    %r14d,%r14d
 2dd0ddc:	xor    %ebp,%ebp
 2dd0dde:	xor    %r9d,%r9d
 2dd0de1:	mov    %rax,%r12
 2dd0de4:	mov    %rax,0x8(%rsp)
 2dd0de9:	mov    %r13,%rax
 2dd0dec:	jmp    2dd068c <fast_pp_skip_inactive+0x2ac>
 2dd0df1:	mov    0x10(%rsp),%rax
 2dd0df6:	lea    (%r12,%r14,1),%rsi
 2dd0dfa:	mov    (%rax),%rdi
 2dd0dfd:	mov    0x38(%rsp),%rax
 2dd0e02:	movzbl 0xe9d0(%rax),%edx
 2dd0e09:	vzeroupper
 2dd0e0c:	call   45de670 <fast_raw_string_before>
 2dd0e11:	test   %al,%al
 2dd0e13:	jne    2dd1b2b <fast_pp_skip_inactive+0x174b>
 2dd0e19:	lea    (%r12,%r14,1),%rax
 2dd0e1d:	cmp    0x20(%rsp),%rax
 2dd0e22:	jae    2dd0fa3 <fast_pp_skip_inactive+0xbc3>
 2dd0e28:	mov    0x58(%rsp),%rcx
 2dd0e2d:	sub    %r12,%rcx
 2dd0e30:	sub    %r14,%rcx
 2dd0e33:	cmp    $0x8,%rcx
 2dd0e37:	jb     2dd0f8d <fast_pp_skip_inactive+0xbad>
 2dd0e3d:	mov    %rcx,%rsi
 2dd0e40:	cmp    $0x40,%rcx
 2dd0e44:	jae    2dd0e4d <fast_pp_skip_inactive+0xa6d>
 2dd0e46:	xor    %ecx,%ecx
 2dd0e48:	jmp    2dd0f22 <fast_pp_skip_inactive+0xb42>
 2dd0e4d:	vmovd  0x4(%rsp),%xmm0
 2dd0e53:	mov    %r15,%rdx
 2dd0e56:	and    $0xffffffffffffffc0,%rdx
 2dd0e5a:	lea    (%r12,%r14,1),%rax
 2dd0e5e:	mov    %rsi,%rcx
 2dd0e61:	and    $0xffffffffffffffc0,%rcx
 2dd0e65:	vpxor  %xmm1,%xmm1,%xmm1
 2dd0e69:	vpxor  %xmm2,%xmm2,%xmm2
 2dd0e6d:	vpxor  %xmm3,%xmm3,%xmm3
 2dd0e71:	add    %rdx,%rax
 2dd0e74:	vpbroadcastb -0x23b53bd(%rip),%xmm4        # a1bac0 <fast_operand_complex_class+0xd68>
 2dd0e7d:	vpcmpeqb -0x30(%rbx),%xmm4,%k0
 2dd0e84:	vpcmpeqb -0x20(%rbx),%xmm4,%k1
 2dd0e8b:	vpcmpeqb -0x10(%rbx),%xmm4,%k2
 2dd0e92:	vpcmpeqb (%rbx),%xmm4,%k3
 2dd0e98:	add    $0x40,%rbx
 2dd0e9c:	add    $0xffffffffffffffc0,%rdx
 2dd0ea0:	vpmovm2d %k0,%zmm4
 2dd0ea6:	vpaddd %zmm4,%zmm0,%zmm0
 2dd0eac:	vpmovm2d %k1,%zmm4
 2dd0eb2:	vpaddd %zmm4,%zmm1,%zmm1
 2dd0eb8:	vpmovm2d %k2,%zmm4
 2dd0ebe:	vpaddd %zmm4,%zmm2,%zmm2
 2dd0ec4:	vpmovm2d %k3,%zmm4
 2dd0eca:	vpaddd %zmm4,%zmm3,%zmm3
 2dd0ed0:	jne    2dd0e74 <fast_pp_skip_inactive+0xa94>
 2dd0ed2:	vpaddd %zmm0,%zmm1,%zmm0
 2dd0ed8:	vpaddd %zmm0,%zmm2,%zmm0
 2dd0ede:	vpaddd %zmm0,%zmm3,%zmm0
 2dd0ee4:	vextracti64x4 $0x1,%zmm0,%ymm1
 2dd0eeb:	vpaddd %zmm1,%zmm0,%zmm0
 2dd0ef1:	vextracti128 $0x1,%ymm0,%xmm1
 2dd0ef7:	vpaddd %xmm1,%xmm0,%xmm0
 2dd0efb:	vpshufd $0xee,%xmm0,%xmm1
 2dd0f00:	vpaddd %xmm1,%xmm0,%xmm0
 2dd0f04:	vpshufd $0x55,%xmm0,%xmm1
 2dd0f09:	vpaddd %xmm1,%xmm0,%xmm0
 2dd0f0d:	vmovd  %xmm0,0x4(%rsp)
 2dd0f13:	cmp    %rcx,%rsi
 2dd0f16:	je     2dd0fa3 <fast_pp_skip_inactive+0xbc3>
 2dd0f1c:	test   $0x38,%sil
 2dd0f20:	je     2dd0f8d <fast_pp_skip_inactive+0xbad>
 2dd0f22:	vmovd  0x4(%rsp),%xmm0
 2dd0f28:	and    $0xfffffffffffffff8,%r15
 2dd0f2c:	lea    (%r12,%r14,1),%rax
 2dd0f30:	mov    %rsi,%rdx
 2dd0f33:	and    $0xfffffffffffffff8,%rdx
 2dd0f37:	add    %rcx,%r13
 2dd0f3a:	add    %r15,%rax
 2dd0f3d:	sub    %rcx,%r15
 2dd0f40:	xor    %ecx,%ecx
 2dd0f42:	vmovq  0x0(%r13,%rcx,1),%xmm1
 2dd0f49:	add    $0x8,%rcx
 2dd0f4d:	vpcmpeqb -0x23b6c47(%rip),%xmm1,%k0        # a1a310 <switch.table.ir_if_convert_test_reload+0x128>
 2dd0f57:	vpmovm2d %k0,%ymm1
 2dd0f5d:	vpaddd %ymm1,%ymm0,%ymm0
 2dd0f61:	cmp    %rcx,%r15
 2dd0f64:	jne    2dd0f42 <fast_pp_skip_inactive+0xb62>
 2dd0f66:	vextracti128 $0x1,%ymm0,%xmm1
 2dd0f6c:	vpaddd %xmm1,%xmm0,%xmm0
 2dd0f70:	vpshufd $0xee,%xmm0,%xmm1
 2dd0f75:	vpaddd %xmm1,%xmm0,%xmm0
 2dd0f79:	vpshufd $0x55,%xmm0,%xmm1
 2dd0f7e:	vpaddd %xmm1,%xmm0,%xmm0
 2dd0f82:	vmovd  %xmm0,0x4(%rsp)
 2dd0f88:	cmp    %rdx,%rsi
 2dd0f8b:	je     2dd0fa3 <fast_pp_skip_inactive+0xbc3>
 2dd0f8d:	xor    %ecx,%ecx
 2dd0f8f:	cmpb   $0xa,(%rax)
 2dd0f92:	sete   %cl
 2dd0f95:	inc    %rax
 2dd0f98:	sub    %ecx,0x4(%rsp)
 2dd0f9c:	cmp    0x20(%rsp),%rax
 2dd0fa1:	jb     2dd0f8d <fast_pp_skip_inactive+0xbad>
 2dd0fa3:	lea    0x1(%r12,%r14,1),%rax
 2dd0fa8:	mov    %rax,0x8(%rsp)
 2dd0fad:	cmp    0x18(%rsp),%rax
 2dd0fb2:	jb     2dd0fd5 <fast_pp_skip_inactive+0xbf5>
 2dd0fb4:	xor    %ecx,%ecx
 2dd0fb6:	jmp    2dd09a6 <fast_pp_skip_inactive+0x5c6>
 2dd0fbb:	mov    0x8(%rsp),%rdx
 2dd0fc0:	xor    %ecx,%ecx
 2dd0fc2:	add    %rax,%rdx
 2dd0fc5:	mov    %rdx,0x8(%rsp)
 2dd0fca:	cmp    0x18(%rsp),%rdx
 2dd0fcf:	jae    2dd09a6 <fast_pp_skip_inactive+0x5c6>
 2dd0fd5:	mov    0x8(%rsp),%rax
 2dd0fda:	movzbl (%rax),%ecx
 2dd0fdd:	cmp    %bpl,%cl
 2dd0fe0:	je     2dd1013 <fast_pp_skip_inactive+0xc33>
 2dd0fe2:	cmp    $0xa,%cl
 2dd0fe5:	je     2dd1013 <fast_pp_skip_inactive+0xc33>
 2dd0fe7:	mov    $0x1,%eax
 2dd0fec:	cmp    $0x5c,%cl
 2dd0fef:	jne    2dd0fbb <fast_pp_skip_inactive+0xbdb>
 2dd0ff1:	mov    0x8(%rsp),%rcx
 2dd0ff6:	inc    %rcx
 2dd0ff9:	cmp    0x18(%rsp),%rcx
 2dd0ffe:	jae    2dd0fbb <fast_pp_skip_inactive+0xbdb>
 2dd1000:	xor    %eax,%eax
 2dd1002:	cmpb   $0xa,(%rcx)
 2dd1005:	sete   %al
 2dd1008:	add    %eax,0x4(%rsp)
 2dd100c:	mov    $0x2,%eax
 2dd1011:	jmp    2dd0fbb <fast_pp_skip_inactive+0xbdb>
 2dd1013:	mov    0x8(%rsp),%rdx
 2dd1018:	xor    %eax,%eax
 2dd101a:	cmp    %bpl,%cl
 2dd101d:	sete   %al
 2dd1020:	xor    %ecx,%ecx
 2dd1022:	xor    %r10d,%r10d
 2dd1025:	xor    %r14d,%r14d
 2dd1028:	xor    %ebp,%ebp
 2dd102a:	xor    %r9d,%r9d
 2dd102d:	xor    %ebx,%ebx
 2dd102f:	add    %rax,%rdx
 2dd1032:	mov    %rdx,0x8(%rsp)
 2dd1037:	mov    %rdx,%r12
 2dd103a:	jmp    2dd0b77 <fast_pp_skip_inactive+0x797>
 2dd103f:	cmp    %r11,%r12
 2dd1042:	jae    2dd1a55 <fast_pp_skip_inactive+0x1675>
 2dd1048:	vbroadcasti32x4 -0x23b6d52(%rip),%zmm5        # a1a300 <switch.table.ir_if_convert_test_reload+0x118>
 2dd1052:	vbroadcasti32x4 -0x23b6d3c(%rip),%zmm6        # a1a320 <switch.table.ir_if_convert_test_reload+0x138>
 2dd105c:	vbroadcasti32x4 -0x23b6d36(%rip),%zmm7        # a1a330 <switch.table.ir_if_convert_test_reload+0x148>
 2dd1066:	vbroadcasti32x4 -0x23b6d30(%rip),%zmm8        # a1a340 <switch.table.ir_if_convert_test_reload+0x158>
 2dd1070:	vbroadcasti32x4 -0x23b6d2a(%rip),%zmm9        # a1a350 <switch.table.ir_if_convert_test_reload+0x168>
 2dd107a:	vbroadcasti32x4 -0x23b6d24(%rip),%zmm10        # a1a360 <switch.table.ir_if_convert_test_reload+0x178>
 2dd1084:	vbroadcasti32x4 -0x23b6d1e(%rip),%zmm11        # a1a370 <switch.table.ir_if_convert_test_reload+0x188>
 2dd108e:	vbroadcasti32x4 -0x23b6d18(%rip),%zmm12        # a1a380 <switch.table.ir_if_convert_test_reload+0x198>
 2dd1098:	vbroadcasti32x4 -0x23b6d12(%rip),%zmm13        # a1a390 <switch.table.ir_if_convert_test_reload+0x1a8>
 2dd10a2:	vbroadcasti32x4 -0x23b6d0c(%rip),%zmm14        # a1a3a0 <switch.table.ir_if_convert_test_reload+0x1b8>
 2dd10ac:	vpbroadcastb -0x23b55f5(%rip),%xmm15        # a1bac0 <fast_operand_complex_class+0xd68>
 2dd10b5:	vpbroadcastb -0x23b55ff(%rip),%xmm16        # a1bac0 <fast_operand_complex_class+0xd68>
 2dd10bf:	mov    %rcx,0x38(%rsp)
 2dd10c4:	mov    %edi,0x4(%rsp)
 2dd10c8:	movq   $0x0,0x48(%rsp)
 2dd10d1:	movq   $0x0,0x60(%rsp)
 2dd10da:	movq   $0x0,0x78(%rsp)
 2dd10e3:	xor    %eax,%eax
 2dd10e5:	xor    %r9d,%r9d
 2dd10e8:	xor    %r8d,%r8d
 2dd10eb:	xor    %r13d,%r13d
 2dd10ee:	xor    %edx,%edx
 2dd10f0:	mov    %r12,0x8(%rsp)
 2dd10f5:	data16 cs nopw 0x0(%rax,%rax,1)
 2dd1100:	mov    %rdx,0x28(%rsp)
 2dd1105:	mov    %r11,%rdx
 2dd1108:	sub    %r12,%rdx
 2dd110b:	mov    %r13,0x20(%rsp)
 2dd1110:	mov    %rbx,%r13
 2dd1113:	cmp    $0x40,%rdx
 2dd1117:	jb     2dd1260 <fast_pp_skip_inactive+0xe80>
 2dd111d:	vmovdqu64 (%r12),%zmm0
 2dd1124:	mov    %r12,%rdi
 2dd1127:	mov    $0x40,%edx
 2dd112c:	mov    $0xffffffffffffffff,%rcx
 2dd1133:	vpcmpeqb %zmm5,%zmm0,%k0
 2dd1139:	vpcmpeqb %zmm8,%zmm0,%k2
 2dd113f:	vpaddb %zmm13,%zmm0,%zmm1
 2dd1145:	xor    %ebp,%ebp
 2dd1147:	bzhi   %rdx,%rcx,%r10
 2dd114c:	kmovq  %k0,%rcx
 2dd1151:	vpcmpeqb %zmm7,%zmm0,%k0
 2dd1157:	vpcmpltub %zmm14,%zmm1,%k1
 2dd115e:	korq   %k0,%k2,%k3
 2dd1163:	kmovq  %k0,%r11
 2dd1168:	vpcmpeqb %zmm9,%zmm0,%k0
 2dd116e:	vpcmpeqb %zmm10,%zmm0,%k2
 2dd1174:	kmovq  %k1,%r14
 2dd1179:	mov    %r10,%r15
 2dd117c:	not    %r15
 2dd117f:	vpcmpeqb %zmm11,%zmm0,%k1
 2dd1185:	korq   %k2,%k0,%k2
 2dd118a:	vpcmpeqb %zmm12,%zmm0,%k0
 2dd1190:	andn   %r14,%rcx,%r14
 2dd1195:	kmovq  %k0,%rbx
 2dd119a:	vpcmpeqb %zmm6,%zmm0,%k0
 2dd11a0:	or     %rbx,%r15
 2dd11a3:	lea    (%rcx,%rcx,1),%rbx
 2dd11a7:	or     %r14,%r15
 2dd11aa:	or     %r13,%rbx
 2dd11ad:	kmovq  %k1,%r14
 2dd11b2:	mov    %r15,%r12
 2dd11b5:	and    %rbx,%r12
 2dd11b8:	add    %r15,%r12
 2dd11bb:	setb   %r13b
 2dd11bf:	or     %rbx,%r12
 2dd11c2:	andn   %r12,%r15,%rbx
 2dd11c7:	lea    (%r11,%r11,1),%r12
 2dd11cb:	mov    %rcx,%r15
 2dd11ce:	not    %r15
 2dd11d1:	or     %r8,%r12
 2dd11d4:	kmovq  %k3,%r8
 2dd11d9:	and    %r8,%r12
 2dd11dc:	lea    (%r14,%r14,1),%r8
 2dd11e0:	or     %r8,%r9
 2dd11e3:	kmovq  %k2,%r8
 2dd11e8:	or     %r15,%r9
 2dd11eb:	add    $0xff,%al
 2dd11ed:	kmovq  %k0,%r15
 2dd11f2:	adc    %r9,%r8
 2dd11f5:	setb   %al
 2dd11f8:	and    %rbx,%r15
 2dd11fb:	andn   %r9,%r8,%r9
 2dd1200:	or     %r15,%r12
 2dd1203:	and    %r10,%r12
 2dd1206:	jne    2dd1283 <fast_pp_skip_inactive+0xea3>
 2dd1208:	popcnt %rcx,%r8
 2dd120d:	mov    %r13b,%bpl
 2dd1210:	shr    $0x3f,%rcx
 2dd1214:	shr    $0x3f,%rbx
 2dd1218:	shr    $0x3f,%r14
 2dd121c:	shr    $0x3f,%r11
 2dd1220:	shr    $0x3f,%r9
 2dd1224:	mov    %rdi,%r12
 2dd1227:	add    %rdx,%r12
 2dd122a:	xor    %r10d,%r10d
 2dd122d:	add    %r8d,0x4(%rsp)
 2dd1232:	or     %rbp,%rcx
 2dd1235:	mov    %r9,%rdx
 2dd1238:	mov    %rbx,%r13
 2dd123b:	mov    %r11,%r8
 2dd123e:	mov    %r14,%r9
 2dd1241:	mov    %rcx,%rbx
 2dd1244:	mov    0x18(%rsp),%r11
 2dd1249:	cmp    %r11,%r12
 2dd124c:	jae    2dd1a7e <fast_pp_skip_inactive+0x169e>
 2dd1252:	test   %r10b,%r10b
 2dd1255:	je     2dd1100 <fast_pp_skip_inactive+0xd20>
 2dd125b:	jmp    2dd1a7e <fast_pp_skip_inactive+0x169e>
 2dd1260:	mov    $0xffffffffffffffff,%rcx
 2dd1267:	mov    %r12,%rdi
 2dd126a:	shlx   %rdx,%rcx,%rcx
 2dd126f:	not    %rcx
 2dd1272:	kmovq  %rcx,%k1
 2dd1277:	vmovdqu8 (%r12),%zmm0{%k1}{z}
 2dd127e:	jmp    2dd112c <fast_pp_skip_inactive+0xd4c>
 2dd1283:	xor    %r8d,%r8d
 2dd1286:	tzcnt  %r12,%r8
 2dd128b:	bt     %r8,%r15
 2dd128f:	jae    2dd12a2 <fast_pp_skip_inactive+0xec2>
 2dd1291:	mov    0x20(%rsp),%r13
 2dd1296:	shrx   %r8,%r9,%rdx
 2dd129b:	mov    $0x1,%bl
 2dd129d:	and    $0x1,%edx
 2dd12a0:	jmp    2dd12db <fast_pp_skip_inactive+0xefb>
 2dd12a2:	mov    0x20(%rsp),%r13
 2dd12a7:	mov    $0xffffffff,%eax
 2dd12ac:	add    %r8d,%eax
 2dd12af:	shrx   %rax,%rbx,%rdx
 2dd12b4:	and    $0x1,%edx
 2dd12b7:	test   %r8,%r8
 2dd12ba:	mov    %r13d,%r10d
 2dd12bd:	cmovne %edx,%r10d
 2dd12c1:	test   %r10d,%r10d
 2dd12c4:	setne  %bl
 2dd12c7:	test   %r8,%r8
 2dd12ca:	je     2dd12d6 <fast_pp_skip_inactive+0xef6>
 2dd12cc:	shrx   %rax,%r9,%rdx
 2dd12d1:	and    $0x1,%edx
 2dd12d4:	jmp    2dd12db <fast_pp_skip_inactive+0xefb>
 2dd12d6:	mov    0x28(%rsp),%rdx
 2dd12db:	mov    $0xffffffffffffffff,%r11
 2dd12e2:	shrx   %r8,%r15,%r14
 2dd12e7:	lea    (%rdi,%r8,1),%r10
 2dd12eb:	bzhi   %r8,%r11,%r11
 2dd12f0:	mov    %r14,%r9
 2dd12f3:	or     $0xfffffffffffffffe,%r9
 2dd12f7:	and    %rcx,%r11
 2dd12fa:	lea    (%r10,%r9,1),%rax
 2dd12fe:	popcnt %r11,%rcx
 2dd1303:	add    %ecx,0x4(%rsp)
 2dd1307:	test   %edx,%edx
 2dd1309:	jne    2dd1773 <fast_pp_skip_inactive+0x1393>
 2dd130f:	test   $0x1,%r14b
 2dd1313:	je     2dd136f <fast_pp_skip_inactive+0xf8f>
 2dd1315:	mov    0x18(%rsp),%rbx
 2dd131a:	add    $0x2,%rax
 2dd131e:	mov    %rsi,0x10(%rsp)
 2dd1323:	mov    %rax,%rdi
 2dd1326:	mov    %rbx,%rsi
 2dd1329:	vzeroupper
 2dd132c:	call   45dad30 <fast_skip_hspace>
 2dd1331:	mov    %rbx,%r11
 2dd1334:	mov    %rax,%rdi
 2dd1337:	cmp    %rbx,%rax
 2dd133a:	jae    2dd1350 <fast_pp_skip_inactive+0xf70>
 2dd133c:	movzbl (%rdi),%ebx
 2dd133f:	lea    -0x23b3606(%rip),%rax        # a1dd40 <fast_char_class>
 2dd1346:	testb  $0x2,(%rbx,%rax,1)
 2dd134a:	jne    2dd146a <fast_pp_skip_inactive+0x108a>
 2dd1350:	mov    0x10(%rsp),%rsi
 2dd1355:	xor    %r10d,%r10d
 2dd1358:	xor    %r8d,%r8d
 2dd135b:	xor    %r9d,%r9d
 2dd135e:	xor    %eax,%eax
 2dd1360:	xor    %ebx,%ebx
 2dd1362:	mov    %rdi,%r12
 2dd1365:	mov    %rdi,0x8(%rsp)
 2dd136a:	jmp    2dd15e1 <fast_pp_skip_inactive+0x1201>
 2dd136f:	movl   $0x0,0x68(%rsp)
 2dd1377:	mov    %rsi,%r15
 2dd137a:	mov    0x38(%rsp),%r14
 2dd137f:	mov    0x18(%rsp),%rsi
 2dd1384:	lea    0x3(%rax),%rdi
 2dd1388:	lea    0x68(%rsp),%rdx
 2dd138d:	cmpb   $0x2a,0x2(%rax)
 2dd1391:	jne    2dd13b9 <fast_pp_skip_inactive+0xfd9>
 2dd1393:	vzeroupper
 2dd1396:	call   45dc940 <fast_skip_block_comment>
 2dd139b:	test   %rax,%rax
 2dd139e:	jne    2dd13c1 <fast_pp_skip_inactive+0xfe1>
 2dd13a0:	lea    -0x23aa49f(%rip),%rsi        # a26f08 <fast_cc_binary_questioned.range_narrow+0x29a8>
 2dd13a7:	mov    %r14,%rdi
 2dd13aa:	call   45da059 <fast_pp_bail>
 2dd13af:	mov    0x18(%rsp),%rcx
 2dd13b4:	mov    $0x1,%r10b
 2dd13b7:	jmp    2dd13c7 <fast_pp_skip_inactive+0xfe7>
 2dd13b9:	vzeroupper
 2dd13bc:	call   45dca30 <fast_skip_line_comment>
 2dd13c1:	mov    %rax,%rcx
 2dd13c4:	xor    %r10d,%r10d
 2dd13c7:	vbroadcasti32x4 -0x23b70d1(%rip),%zmm5        # a1a300 <switch.table.ir_if_convert_test_reload+0x118>
 2dd13d1:	vbroadcasti32x4 -0x23b70bb(%rip),%zmm6        # a1a320 <switch.table.ir_if_convert_test_reload+0x138>
 2dd13db:	vbroadcasti32x4 -0x23b70b5(%rip),%zmm7        # a1a330 <switch.table.ir_if_convert_test_reload+0x148>
 2dd13e5:	vbroadcasti32x4 -0x23b70af(%rip),%zmm8        # a1a340 <switch.table.ir_if_convert_test_reload+0x158>
 2dd13ef:	vbroadcasti32x4 -0x23b70a9(%rip),%zmm9        # a1a350 <switch.table.ir_if_convert_test_reload+0x168>
 2dd13f9:	vbroadcasti32x4 -0x23b70a3(%rip),%zmm10        # a1a360 <switch.table.ir_if_convert_test_reload+0x178>
 2dd1403:	vbroadcasti32x4 -0x23b709d(%rip),%zmm11        # a1a370 <switch.table.ir_if_convert_test_reload+0x188>
 2dd140d:	vbroadcasti32x4 -0x23b7097(%rip),%zmm12        # a1a380 <switch.table.ir_if_convert_test_reload+0x198>
 2dd1417:	vbroadcasti32x4 -0x23b7091(%rip),%zmm13        # a1a390 <switch.table.ir_if_convert_test_reload+0x1a8>
 2dd1421:	vbroadcasti32x4 -0x23b708b(%rip),%zmm14        # a1a3a0 <switch.table.ir_if_convert_test_reload+0x1b8>
 2dd142b:	vpbroadcastb -0x23b5974(%rip),%xmm15        # a1bac0 <fast_operand_complex_class+0xd68>
 2dd1434:	vpbroadcastb -0x23b597e(%rip),%xmm16        # a1bac0 <fast_operand_complex_class+0xd68>
 2dd143e:	mov    0x4(%rsp),%eax
 2dd1442:	mov    0x28(%rsp),%rdx
 2dd1447:	movzbl %bl,%ebx
 2dd144a:	mov    %r15,%rsi
 2dd144d:	xor    %r8d,%r8d
 2dd1450:	xor    %r9d,%r9d
 2dd1453:	mov    %rcx,0x8(%rsp)
 2dd1458:	mov    %rcx,%r12
 2dd145b:	add    0x68(%rsp),%eax
 2dd145f:	mov    %eax,0x4(%rsp)
 2dd1463:	xor    %eax,%eax
 2dd1465:	jmp    2dd1244 <fast_pp_skip_inactive+0xe64>
 2dd146a:	mov    %r11,%rsi
 2dd146d:	mov    %rdi,%r14
 2dd1470:	call   45dd190 <fast_scan_ident_len>
 2dd1475:	lea    -0x2(%rax),%ecx
 2dd1478:	mov    %r14,%rsi
 2dd147b:	cmp    $0x6,%ecx
 2dd147e:	ja     2dd15bd <fast_pp_skip_inactive+0x11dd>
 2dd1484:	lea    -0x23ad31b(%rip),%rdx        # a24170 <c_direct_test_dependencies.levels+0x73>
 2dd148b:	movslq (%rdx,%rcx,4),%rcx
 2dd148f:	add    %rdx,%rcx
 2dd1492:	jmp    *%rcx
 2dd1494:	cmp    $0x69,%bl
 2dd1497:	jne    2dd15bd <fast_pp_skip_inactive+0x11dd>
 2dd149d:	cmpb   $0x66,0x1(%rsi)
 2dd14a1:	je     2dd156a <fast_pp_skip_inactive+0x118a>
 2dd14a7:	jmp    2dd15bd <fast_pp_skip_inactive+0x11dd>
 2dd14ac:	movzbl 0x4(%rsi),%edi
 2dd14b0:	mov    (%rsi),%ecx
 2dd14b2:	mov    $0x65646669,%edx
 2dd14b7:	xor    %edx,%ecx
 2dd14b9:	xor    $0x66,%edi
 2dd14bc:	or     %ecx,%edi
 2dd14be:	je     2dd156a <fast_pp_skip_inactive+0x118a>
 2dd14c4:	movzbl 0x4(%rsi),%edi
 2dd14c8:	mov    (%rsi),%ecx
 2dd14ca:	mov    $0x69646e65,%edx
 2dd14cf:	xor    %edx,%ecx
 2dd14d1:	xor    $0x66,%edi
 2dd14d4:	or     %ecx,%edi
 2dd14d6:	jne    2dd15bd <fast_pp_skip_inactive+0x11dd>
 2dd14dc:	add    $0x5,%rsi
 2dd14e0:	cmpl   $0x0,0x60(%rsp)
 2dd14e5:	mov    %rsi,0x8(%rsp)
 2dd14ea:	je     2dd1b09 <fast_pp_skip_inactive+0x1729>
 2dd14f0:	mov    0x60(%rsp),%rax
 2dd14f5:	mov    0x8(%rsp),%r12
 2dd14fa:	xor    %r10d,%r10d
 2dd14fd:	xor    %r8d,%r8d
 2dd1500:	xor    %r9d,%r9d
 2dd1503:	xor    %ebx,%ebx
 2dd1505:	dec    %eax
 2dd1507:	mov    %rax,0x60(%rsp)
 2dd150c:	xor    %eax,%eax
 2dd150e:	jmp    2dd16e3 <fast_pp_skip_inactive+0x1303>
 2dd1513:	movabs $0x6665646e66696c65,%rcx
 2dd151d:	cmp    %rcx,(%rsi)
 2dd1520:	jne    2dd15bd <fast_pp_skip_inactive+0x11dd>
 2dd1526:	mov    $0x32,%bpl
 2dd1529:	jmp    2dd1671 <fast_pp_skip_inactive+0x1291>
 2dd152e:	cmpl   $0x65736c65,(%rsi)
 2dd1534:	je     2dd1662 <fast_pp_skip_inactive+0x1282>
 2dd153a:	cmpl   $0x66696c65,(%r14)
 2dd1541:	mov    0x20(%rsp),%r13
 2dd1546:	mov    %r14,%rsi
 2dd1549:	jne    2dd15bd <fast_pp_skip_inactive+0x11dd>
 2dd154b:	mov    $0x4,%bpl
 2dd154e:	jmp    2dd168c <fast_pp_skip_inactive+0x12ac>
 2dd1553:	movzwl 0x4(%rsi),%edi
 2dd1557:	mov    (%rsi),%ecx
 2dd1559:	mov    $0x646e6669,%edx
 2dd155e:	xor    %edx,%ecx
 2dd1560:	xor    $0x6665,%edi
 2dd1566:	or     %ecx,%edi
 2dd1568:	jne    2dd15bd <fast_pp_skip_inactive+0x11dd>
 2dd156a:	mov    0x60(%rsp),%rdx
 2dd156f:	mov    0x48(%rsp),%rcx
 2dd1574:	mov    %eax,%eax
 2dd1576:	add    %rax,%rsi
 2dd1579:	xor    %eax,%eax
 2dd157b:	inc    %edx
 2dd157d:	cmp    $0x40,%edx
 2dd1580:	mov    %rdx,0x60(%rsp)
 2dd1585:	setae  %al
 2dd1588:	or     %eax,%ecx
 2dd158a:	mov    %rcx,0x48(%rsp)
 2dd158f:	mov    0x78(%rsp),%rcx
 2dd1594:	btr    %rdx,%rcx
 2dd1598:	mov    %rcx,0x78(%rsp)
 2dd159d:	jmp    2dd15c2 <fast_pp_skip_inactive+0x11e2>
 2dd159f:	mov    (%rsi),%ecx
 2dd15a1:	mov    0x3(%rsi),%r8d
 2dd15a5:	mov    $0x66696c65,%edx
 2dd15aa:	mov    $0x66656466,%edi
 2dd15af:	xor    %edx,%ecx
 2dd15b1:	xor    %edi,%r8d
 2dd15b4:	or     %ecx,%r8d
 2dd15b7:	je     2dd166e <fast_pp_skip_inactive+0x128e>
 2dd15bd:	mov    %eax,%eax
 2dd15bf:	add    %rax,%rsi
 2dd15c2:	mov    %rsi,0x8(%rsp)
 2dd15c7:	mov    %rsi,%r12
 2dd15ca:	mov    0x10(%rsp),%rsi
 2dd15cf:	mov    0x18(%rsp),%r11
 2dd15d4:	xor    %r10d,%r10d
 2dd15d7:	xor    %r8d,%r8d
 2dd15da:	xor    %r9d,%r9d
 2dd15dd:	xor    %eax,%eax
 2dd15df:	xor    %ebx,%ebx
 2dd15e1:	vbroadcasti32x4 -0x23b72eb(%rip),%zmm5        # a1a300 <switch.table.ir_if_convert_test_reload+0x118>
 2dd15eb:	vbroadcasti32x4 -0x23b72d5(%rip),%zmm6        # a1a320 <switch.table.ir_if_convert_test_reload+0x138>
 2dd15f5:	vbroadcasti32x4 -0x23b72cf(%rip),%zmm7        # a1a330 <switch.table.ir_if_convert_test_reload+0x148>
 2dd15ff:	vbroadcasti32x4 -0x23b72c9(%rip),%zmm8        # a1a340 <switch.table.ir_if_convert_test_reload+0x158>
 2dd1609:	vbroadcasti32x4 -0x23b72c3(%rip),%zmm9        # a1a350 <switch.table.ir_if_convert_test_reload+0x168>
 2dd1613:	vbroadcasti32x4 -0x23b72bd(%rip),%zmm10        # a1a360 <switch.table.ir_if_convert_test_reload+0x178>
 2dd161d:	vbroadcasti32x4 -0x23b72b7(%rip),%zmm11        # a1a370 <switch.table.ir_if_convert_test_reload+0x188>
 2dd1627:	vbroadcasti32x4 -0x23b72b1(%rip),%zmm12        # a1a380 <switch.table.ir_if_convert_test_reload+0x198>
 2dd1631:	vbroadcasti32x4 -0x23b72ab(%rip),%zmm13        # a1a390 <switch.table.ir_if_convert_test_reload+0x1a8>
 2dd163b:	vbroadcasti32x4 -0x23b72a5(%rip),%zmm14        # a1a3a0 <switch.table.ir_if_convert_test_reload+0x1b8>
 2dd1645:	vpbroadcastb -0x23b5b8e(%rip),%xmm15        # a1bac0 <fast_operand_complex_class+0xd68>
 2dd164e:	vpbroadcastb -0x23b5b98(%rip),%xmm16        # a1bac0 <fast_operand_complex_class+0xd68>
 2dd1658:	mov    0x28(%rsp),%rdx
 2dd165d:	jmp    2dd1249 <fast_pp_skip_inactive+0xe69>
 2dd1662:	mov    $0xffffffffffffffff,%rcx
 2dd1669:	mov    $0x5,%bpl
 2dd166c:	jmp    2dd168e <fast_pp_skip_inactive+0x12ae>
 2dd166e:	mov    $0x31,%bpl
 2dd1671:	mov    0x38(%rsp),%rcx
 2dd1676:	mov    0x48(%rsp),%rdx
 2dd167b:	movzbl 0xe979(%rcx),%ecx
 2dd1682:	xor    $0x1,%ecx
 2dd1685:	or     %ecx,%edx
 2dd1687:	mov    %rdx,0x48(%rsp)
 2dd168c:	xor    %ecx,%ecx
 2dd168e:	mov    0x60(%rsp),%rdx
 2dd1693:	mov    %eax,%eax
 2dd1695:	add    %rax,%r14
 2dd1698:	mov    %r14,0x8(%rsp)
 2dd169d:	test   %edx,%edx
 2dd169f:	je     2dd1b0c <fast_pp_skip_inactive+0x172c>
 2dd16a5:	mov    0x78(%rsp),%rsi
 2dd16aa:	mov    $0x1,%eax
 2dd16af:	xor    %r10d,%r10d
 2dd16b2:	xor    %r8d,%r8d
 2dd16b5:	xor    %r9d,%r9d
 2dd16b8:	xor    %ebx,%ebx
 2dd16ba:	mov    %r14,%r12
 2dd16bd:	shlx   %rdx,%rax,%rax
 2dd16c2:	and    %rax,%rcx
 2dd16c5:	shrx   %rdx,%rsi,%rax
 2dd16ca:	mov    0x48(%rsp),%rdx
 2dd16cf:	or     %rcx,%rsi
 2dd16d2:	and    $0x1,%eax
 2dd16d5:	mov    %rsi,0x78(%rsp)
 2dd16da:	or     %eax,%edx
 2dd16dc:	xor    %eax,%eax
 2dd16de:	mov    %rdx,0x48(%rsp)
 2dd16e3:	vbroadcasti32x4 -0x23b73ed(%rip),%zmm5        # a1a300 <switch.table.ir_if_convert_test_reload+0x118>
 2dd16ed:	vbroadcasti32x4 -0x23b73d7(%rip),%zmm6        # a1a320 <switch.table.ir_if_convert_test_reload+0x138>
 2dd16f7:	vbroadcasti32x4 -0x23b73d1(%rip),%zmm7        # a1a330 <switch.table.ir_if_convert_test_reload+0x148>
 2dd1701:	vbroadcasti32x4 -0x23b73cb(%rip),%zmm8        # a1a340 <switch.table.ir_if_convert_test_reload+0x158>
 2dd170b:	vbroadcasti32x4 -0x23b73c5(%rip),%zmm9        # a1a350 <switch.table.ir_if_convert_test_reload+0x168>
 2dd1715:	vbroadcasti32x4 -0x23b73bf(%rip),%zmm10        # a1a360 <switch.table.ir_if_convert_test_reload+0x178>
 2dd171f:	vbroadcasti32x4 -0x23b73b9(%rip),%zmm11        # a1a370 <switch.table.ir_if_convert_test_reload+0x188>
 2dd1729:	vbroadcasti32x4 -0x23b73b3(%rip),%zmm12        # a1a380 <switch.table.ir_if_convert_test_reload+0x198>
 2dd1733:	vbroadcasti32x4 -0x23b73ad(%rip),%zmm13        # a1a390 <switch.table.ir_if_convert_test_reload+0x1a8>
 2dd173d:	vbroadcasti32x4 -0x23b73a7(%rip),%zmm14        # a1a3a0 <switch.table.ir_if_convert_test_reload+0x1b8>
 2dd1747:	vpbroadcastb -0x23b5c90(%rip),%xmm15        # a1bac0 <fast_operand_complex_class+0xd68>
 2dd1750:	vpbroadcastb -0x23b5c9a(%rip),%xmm16        # a1bac0 <fast_operand_complex_class+0xd68>
 2dd175a:	mov    0x10(%rsp),%rsi
 2dd175f:	mov    0x18(%rsp),%r11
 2dd1764:	mov    0x20(%rsp),%r13
 2dd1769:	mov    0x28(%rsp),%rdx
 2dd176e:	jmp    2dd1249 <fast_pp_skip_inactive+0xe69>
 2dd1773:	lea    0x1(%r9,%r10,1),%rcx
 2dd1778:	cmp    0x8(%rsp),%rcx
 2dd177d:	jbe    2dd130f <fast_pp_skip_inactive+0xf2f>
 2dd1783:	mov    %rcx,%r12
 2dd1786:	xor    %r10d,%r10d
 2dd1789:	mov    %rdi,0x58(%rsp)
 2dd178e:	mov    %rsi,0x10(%rsp)
 2dd1793:	jmp    2dd17a4 <fast_pp_skip_inactive+0x13c4>
 2dd1795:	dec    %r10
 2dd1798:	lea    0x1(%rax,%r10,1),%rcx
 2dd179d:	cmp    0x8(%rsp),%rcx
 2dd17a2:	jbe    2dd17be <fast_pp_skip_inactive+0x13de>
 2dd17a4:	cmpb   $0xa,(%rax,%r10,1)
 2dd17a9:	jne    2dd1795 <fast_pp_skip_inactive+0x13b5>
 2dd17ab:	lea    (%rax,%r10,1),%rcx
 2dd17af:	cmp    0x8(%rsp),%rcx
 2dd17b4:	jbe    2dd17be <fast_pp_skip_inactive+0x13de>
 2dd17b6:	cmpb   $0x5c,-0x1(%rax,%r10,1)
 2dd17bc:	je     2dd1795 <fast_pp_skip_inactive+0x13b5>
 2dd17be:	mov    0x10(%rsp),%rsi
 2dd17c3:	mov    0x58(%rsp),%rdi
 2dd17c8:	mov    0x20(%rsp),%r13
 2dd17cd:	test   %r10,%r10
 2dd17d0:	jns    2dd130f <fast_pp_skip_inactive+0xf2f>
 2dd17d6:	add    %r10,%r8
 2dd17d9:	mov    %r10,%rdx
 2dd17dc:	neg    %rdx
 2dd17df:	xor    %r11d,%r11d
 2dd17e2:	add    %r9,%r8
 2dd17e5:	mov    %rdx,%rbp
 2dd17e8:	lea    0x31(%rdi,%r8,1),%rcx
 2dd17ed:	lea    0x1(%rdi,%r8,1),%r15
 2dd17f2:	lea    (%rdi,%r8,1),%r9
 2dd17f6:	movzbl 0x1(%r9,%r11,1),%esi
 2dd17fc:	cmp    $0x22,%esi
 2dd17ff:	je     2dd1826 <fast_pp_skip_inactive+0x1446>
 2dd1801:	cmp    $0x27,%esi
 2dd1804:	je     2dd1826 <fast_pp_skip_inactive+0x1446>
 2dd1806:	mov    0x10(%rsp),%rsi
 2dd180b:	mov    0x20(%rsp),%r13
 2dd1810:	inc    %r11
 2dd1813:	dec    %rbp
 2dd1816:	inc    %rcx
 2dd1819:	inc    %r15
 2dd181c:	cmp    %r11,%rdx
 2dd181f:	jne    2dd17f6 <fast_pp_skip_inactive+0x1416>
 2dd1821:	jmp    2dd130f <fast_pp_skip_inactive+0xf2f>
 2dd1826:	lea    0x1(%r11,%r9,1),%rdi
 2dd182b:	cmp    %r12,%rdi
 2dd182e:	jae    2dd19ae <fast_pp_skip_inactive+0x15ce>
 2dd1834:	add    %r11,%r10
 2dd1837:	neg    %r10
 2dd183a:	cmp    $0x8,%r10
 2dd183e:	jb     2dd1995 <fast_pp_skip_inactive+0x15b5>
 2dd1844:	cmp    $0x40,%r10
 2dd1848:	jae    2dd1851 <fast_pp_skip_inactive+0x1471>
 2dd184a:	xor    %ebx,%ebx
 2dd184c:	jmp    2dd1926 <fast_pp_skip_inactive+0x1546>
 2dd1851:	mov    0x58(%rsp),%rdi
 2dd1856:	vmovd  0x4(%rsp),%xmm0
 2dd185c:	mov    %rbp,%rdx
 2dd185f:	and    $0xffffffffffffffc0,%rdx
 2dd1863:	mov    %r10,%rbx
 2dd1866:	and    $0xffffffffffffffc0,%rbx
 2dd186a:	vpxor  %xmm1,%xmm1,%xmm1
 2dd186e:	vpxor  %xmm2,%xmm2,%xmm2
 2dd1872:	vpxor  %xmm3,%xmm3,%xmm3
 2dd1876:	add    %rdx,%rdi
 2dd1879:	add    %r8,%rdi
 2dd187c:	lea    0x1(%r11,%rdi,1),%rdi
 2dd1881:	vpcmpeqb -0x30(%rcx),%xmm16,%k0
 2dd1888:	vpcmpeqb -0x20(%rcx),%xmm16,%k1
 2dd188f:	vpcmpeqb -0x10(%rcx),%xmm16,%k2
 2dd1896:	vpcmpeqb (%rcx),%xmm16,%k3
 2dd189c:	add    $0x40,%rcx
 2dd18a0:	add    $0xffffffffffffffc0,%rdx
 2dd18a4:	vpmovm2d %k0,%zmm4
 2dd18aa:	vpaddd %zmm4,%zmm0,%zmm0
 2dd18b0:	vpmovm2d %k1,%zmm4
 2dd18b6:	vpaddd %zmm4,%zmm1,%zmm1
 2dd18bc:	vpmovm2d %k2,%zmm4
 2dd18c2:	vpaddd %zmm4,%zmm2,%zmm2
 2dd18c8:	vpmovm2d %k3,%zmm4
 2dd18ce:	vpaddd %zmm4,%zmm3,%zmm3
 2dd18d4:	jne    2dd1881 <fast_pp_skip_inactive+0x14a1>
 2dd18d6:	vpaddd %zmm0,%zmm1,%zmm0
 2dd18dc:	vpaddd %zmm0,%zmm2,%zmm0
 2dd18e2:	vpaddd %zmm0,%zmm3,%zmm0
 2dd18e8:	vextracti64x4 $0x1,%zmm0,%ymm1
 2dd18ef:	vpaddd %zmm1,%zmm0,%zmm0
 2dd18f5:	vextracti128 $0x1,%ymm0,%xmm1
 2dd18fb:	vpaddd %xmm1,%xmm0,%xmm0
 2dd18ff:	vpshufd $0xee,%xmm0,%xmm1
 2dd1904:	vpaddd %xmm1,%xmm0,%xmm0
 2dd1908:	vpshufd $0x55,%xmm0,%xmm1
 2dd190d:	vpaddd %xmm1,%xmm0,%xmm0
 2dd1911:	vmovd  %xmm0,0x4(%rsp)
 2dd1917:	cmp    %rbx,%r10
 2dd191a:	je     2dd19ae <fast_pp_skip_inactive+0x15ce>
 2dd1920:	test   $0x38,%r10b
 2dd1924:	je     2dd1995 <fast_pp_skip_inactive+0x15b5>
 2dd1926:	mov    0x58(%rsp),%r12
 2dd192b:	vmovd  0x4(%rsp),%xmm0
 2dd1931:	and    $0xfffffffffffffff8,%rbp
 2dd1935:	mov    %r10,%rcx
 2dd1938:	and    $0xfffffffffffffff8,%rcx
 2dd193c:	add    %rbx,%r15
 2dd193f:	xor    %edx,%edx
 2dd1941:	add    %rbp,%r12
 2dd1944:	sub    %rbx,%rbp
 2dd1947:	add    %r8,%r12
 2dd194a:	lea    0x1(%r11,%r12,1),%rdi
 2dd194f:	vmovq  (%r15,%rdx,1),%xmm1
 2dd1955:	add    $0x8,%rdx
 2dd1959:	vpcmpeqb %xmm15,%xmm1,%k0
 2dd195f:	vpmovm2d %k0,%ymm1
 2dd1965:	vpaddd %ymm1,%ymm0,%ymm0
 2dd1969:	cmp    %rdx,%rbp
 2dd196c:	jne    2dd194f <fast_pp_skip_inactive+0x156f>
 2dd196e:	vextracti128 $0x1,%ymm0,%xmm1
 2dd1974:	vpaddd %xmm1,%xmm0,%xmm0
 2dd1978:	vpshufd $0xee,%xmm0,%xmm1
 2dd197d:	vpaddd %xmm1,%xmm0,%xmm0
 2dd1981:	vpshufd $0x55,%xmm0,%xmm1
 2dd1986:	vpaddd %xmm1,%xmm0,%xmm0
 2dd198a:	vmovd  %xmm0,0x4(%rsp)
 2dd1990:	cmp    %rcx,%r10
 2dd1993:	je     2dd19ae <fast_pp_skip_inactive+0x15ce>
 2dd1995:	dec    %rdi
 2dd1998:	xor    %ecx,%ecx
 2dd199a:	cmpb   $0xa,0x1(%rdi)
 2dd199e:	lea    0x1(%rdi),%rdi
 2dd19a2:	sete   %cl
 2dd19a5:	sub    %ecx,0x4(%rsp)
 2dd19a9:	cmp    %rax,%rdi
 2dd19ac:	jne    2dd1998 <fast_pp_skip_inactive+0x15b8>
 2dd19ae:	lea    0x2(%r11,%r9,1),%rax
 2dd19b3:	mov    %rax,0x8(%rsp)
 2dd19b8:	cmp    0x18(%rsp),%rax
 2dd19bd:	jb     2dd19ed <fast_pp_skip_inactive+0x160d>
 2dd19bf:	xor    %r10d,%r10d
 2dd19c2:	mov    0x8(%rsp),%r12
 2dd19c7:	xor    %r8d,%r8d
 2dd19ca:	xor    %r9d,%r9d
 2dd19cd:	xor    %eax,%eax
 2dd19cf:	xor    %ebx,%ebx
 2dd19d1:	jmp    2dd175a <fast_pp_skip_inactive+0x137a>
 2dd19d6:	mov    0x8(%rsp),%rcx
 2dd19db:	xor    %r10d,%r10d
 2dd19de:	add    %rax,%rcx
 2dd19e1:	mov    %rcx,0x8(%rsp)
 2dd19e6:	cmp    0x18(%rsp),%rcx
 2dd19eb:	jae    2dd19c2 <fast_pp_skip_inactive+0x15e2>
 2dd19ed:	mov    0x8(%rsp),%rax
 2dd19f2:	movzbl (%rax),%ecx
 2dd19f5:	cmp    %sil,%cl
 2dd19f8:	je     2dd1a2b <fast_pp_skip_inactive+0x164b>
 2dd19fa:	cmp    $0xa,%cl
 2dd19fd:	je     2dd1a2b <fast_pp_skip_inactive+0x164b>
 2dd19ff:	mov    $0x1,%eax
 2dd1a04:	cmp    $0x5c,%cl
 2dd1a07:	jne    2dd19d6 <fast_pp_skip_inactive+0x15f6>
 2dd1a09:	mov    0x8(%rsp),%rcx
 2dd1a0e:	inc    %rcx
 2dd1a11:	cmp    0x18(%rsp),%rcx
 2dd1a16:	jae    2dd19d6 <fast_pp_skip_inactive+0x15f6>
 2dd1a18:	xor    %eax,%eax
 2dd1a1a:	cmpb   $0xa,(%rcx)
 2dd1a1d:	sete   %al
 2dd1a20:	add    %eax,0x4(%rsp)
 2dd1a24:	mov    $0x2,%eax
 2dd1a29:	jmp    2dd19d6 <fast_pp_skip_inactive+0x15f6>
 2dd1a2b:	mov    0x8(%rsp),%rdx
 2dd1a30:	xor    %eax,%eax
 2dd1a32:	cmp    %sil,%cl
 2dd1a35:	sete   %al
 2dd1a38:	xor    %r10d,%r10d
 2dd1a3b:	xor    %r8d,%r8d
 2dd1a3e:	xor    %r9d,%r9d
 2dd1a41:	xor    %ebx,%ebx
 2dd1a43:	add    %rax,%rdx
 2dd1a46:	xor    %eax,%eax
 2dd1a48:	mov    %rdx,0x8(%rsp)
 2dd1a4d:	mov    %rdx,%r12
 2dd1a50:	jmp    2dd175a <fast_pp_skip_inactive+0x137a>
 2dd1a55:	xor    %eax,%eax
 2dd1a57:	cmpb   $0x0,0xe968(%rcx)
 2dd1a5e:	mov    $0x1,%r15b
 2dd1a61:	jne    2dd1b94 <fast_pp_skip_inactive+0x17b4>
 2dd1a67:	mov    %rsi,0x10(%rsp)
 2dd1a6c:	mov    %edi,0x4(%rsp)
 2dd1a70:	xor    %ebp,%ebp
 2dd1a72:	lea    -0x23aab54(%rip),%rsi        # a26f25 <fast_cc_binary_questioned.range_narrow+0x29c5>
 2dd1a79:	jmp    2dd1b78 <fast_pp_skip_inactive+0x1798>
 2dd1a7e:	mov    0x38(%rsp),%rcx
 2dd1a83:	cmpb   $0x0,0xe968(%rcx)
 2dd1a8a:	je     2dd1aa1 <fast_pp_skip_inactive+0x16c1>
 2dd1a8c:	xor    %eax,%eax
 2dd1a8e:	cmpl   $0x0,0x48(%rsp)
 2dd1a93:	mov    $0x1,%r15b
 2dd1a96:	je     2dd1b90 <fast_pp_skip_inactive+0x17b0>
 2dd1a9c:	jmp    2dd1b6a <fast_pp_skip_inactive+0x178a>
 2dd1aa1:	mov    %rsi,0x10(%rsp)
 2dd1aa6:	lea    -0x23aab88(%rip),%rsi        # a26f25 <fast_cc_binary_questioned.range_narrow+0x29c5>
 2dd1aad:	mov    %rbx,%r13
 2dd1ab0:	mov    %rcx,%rdi
 2dd1ab3:	mov    %rcx,%rbx
 2dd1ab6:	vzeroupper
 2dd1ab9:	call   45da059 <fast_pp_bail>
 2dd1abe:	xor    %eax,%eax
 2dd1ac0:	cmpl   $0x0,0x48(%rsp)
 2dd1ac5:	mov    $0x1,%r15b
 2dd1ac8:	je     2dd1be7 <fast_pp_skip_inactive+0x1807>
 2dd1ace:	mov    %rbx,%rcx
 2dd1ad1:	xor    %ebp,%ebp
 2dd1ad3:	lea    -0x23aaba4(%rip),%rsi        # a26f36 <fast_cc_binary_questioned.range_narrow+0x29d6>
 2dd1ada:	mov    %r12,%r14
 2dd1add:	mov    %r13,%rbx
 2dd1ae0:	jmp    2dd1b7b <fast_pp_skip_inactive+0x179b>
 2dd1ae5:	mov    $0x6,%bpl
 2dd1ae8:	xor    %r15d,%r15d
 2dd1aeb:	cmpl   $0x0,0x34(%rsp)
 2dd1af0:	jne    2dd1b16 <fast_pp_skip_inactive+0x1736>
 2dd1af2:	mov    0x8(%rsp),%r12
 2dd1af7:	mov    0x10(%rsp),%rsi
 2dd1afc:	mov    0x4(%rsp),%edi
 2dd1b00:	mov    %ebp,%eax
 2dd1b02:	xor    %ebx,%ebx
 2dd1b04:	jmp    2dd1b94 <fast_pp_skip_inactive+0x17b4>
 2dd1b09:	mov    $0x6,%bpl
 2dd1b0c:	xor    %r15d,%r15d
 2dd1b0f:	cmpl   $0x0,0x48(%rsp)
 2dd1b14:	je     2dd1af2 <fast_pp_skip_inactive+0x1712>
 2dd1b16:	mov    0x38(%rsp),%rcx
 2dd1b1b:	mov    0x8(%rsp),%r14
 2dd1b20:	lea    -0x23aabf1(%rip),%rsi        # a26f36 <fast_cc_binary_questioned.range_narrow+0x29d6>
 2dd1b27:	xor    %ebx,%ebx
 2dd1b29:	jmp    2dd1b7b <fast_pp_skip_inactive+0x179b>
 2dd1b2b:	mov    0x38(%rsp),%rdi
 2dd1b30:	lea    -0x23aac55(%rip),%rsi        # a26ee2 <fast_cc_binary_questioned.range_narrow+0x2982>
 2dd1b37:	call   45da059 <fast_pp_bail>
 2dd1b3c:	mov    0x18(%rsp),%r12
 2dd1b41:	mov    0x10(%rsp),%rsi
 2dd1b46:	mov    0x4(%rsp),%edi
 2dd1b4a:	xor    %ebx,%ebx
 2dd1b4c:	mov    0x38(%rsp),%rcx
 2dd1b51:	cmpb   $0x0,0xe968(%rcx)
 2dd1b58:	je     2dd1bb6 <fast_pp_skip_inactive+0x17d6>
 2dd1b5a:	xor    %eax,%eax
 2dd1b5c:	cmpl   $0x0,0x34(%rsp)
 2dd1b61:	mov    $0x1,%r15b
 2dd1b64:	je     2dd1b94 <fast_pp_skip_inactive+0x17b4>
 2dd1b66:	mov    %edi,0x4(%rsp)
 2dd1b6a:	mov    %rsi,0x10(%rsp)
 2dd1b6f:	lea    -0x23aac40(%rip),%rsi        # a26f36 <fast_cc_binary_questioned.range_narrow+0x29d6>
 2dd1b76:	xor    %ebp,%ebp
 2dd1b78:	mov    %r12,%r14
 2dd1b7b:	mov    %rcx,%rdi
 2dd1b7e:	vzeroupper
 2dd1b81:	call   45da059 <fast_pp_bail>
 2dd1b86:	mov    0x10(%rsp),%rsi
 2dd1b8b:	mov    %r14,%r12
 2dd1b8e:	mov    %ebp,%eax
 2dd1b90:	mov    0x4(%rsp),%edi
 2dd1b94:	and    %r15b,%bl
 2dd1b97:	mov    %r12,0x8(%rsi)
 2dd1b9b:	mov    %edi,0x2c(%rsi)
 2dd1b9e:	mov    %bl,0x45(%rsi)
 2dd1ba1:	add    $0xf8,%rsp
 2dd1ba8:	pop    %rbx
 2dd1ba9:	pop    %r12
 2dd1bab:	pop    %r13
 2dd1bad:	pop    %r14
 2dd1baf:	pop    %r15
 2dd1bb1:	pop    %rbp
 2dd1bb2:	vzeroupper
 2dd1bb5:	ret
 2dd1bb6:	mov    %rsi,0x10(%rsp)
 2dd1bbb:	lea    -0x23aac9d(%rip),%rsi        # a26f25 <fast_cc_binary_questioned.range_narrow+0x29c5>
 2dd1bc2:	mov    %rbx,%r13
 2dd1bc5:	mov    %edi,0x4(%rsp)
 2dd1bc9:	mov    %rcx,%rdi
 2dd1bcc:	mov    %rcx,%rbx
 2dd1bcf:	vzeroupper
 2dd1bd2:	call   45da059 <fast_pp_bail>
 2dd1bd7:	xor    %eax,%eax
 2dd1bd9:	cmpl   $0x0,0x34(%rsp)
 2dd1bde:	mov    $0x1,%r15b
 2dd1be1:	jne    2dd1ace <fast_pp_skip_inactive+0x16ee>
 2dd1be7:	mov    0x10(%rsp),%rsi
 2dd1bec:	mov    0x4(%rsp),%edi
 2dd1bf0:	mov    %r13,%rbx
 2dd1bf3:	jmp    2dd1b94 <fast_pp_skip_inactive+0x17b4>
