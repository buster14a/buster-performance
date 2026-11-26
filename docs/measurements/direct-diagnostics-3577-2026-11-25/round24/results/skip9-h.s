 2dd03e0:	push   %rbp
 2dd03e1:	push   %r15
 2dd03e3:	push   %r14
 2dd03e5:	push   %r13
 2dd03e7:	push   %r12
 2dd03e9:	push   %rbx
 2dd03ea:	sub    $0x118,%rsp
 2dd03f1:	mov    %rsi,%rcx
 2dd03f4:	mov    0x8(%rsi),%rbp
 2dd03f8:	mov    0x10(%rsi),%rsi
 2dd03fc:	cmpb   $0x0,0xe9d0(%rdi)
 2dd0403:	mov    0x2c(%rcx),%r11d
 2dd0407:	movzbl 0x45(%rcx),%ebx
 2dd040b:	mov    %rsi,0x18(%rsp)
 2dd0410:	je     2dd1259 <fast_pp_skip_inactive+0xe79>
 2dd0416:	cmp    %rsi,%rbp
 2dd0419:	jae    2dd1e64 <fast_pp_skip_inactive+0x1a84>
 2dd041f:	vbroadcasti32x4 -0x23b6129(%rip),%zmm1        # a1a300 <switch.table.ir_if_convert_test_reload+0x118>
 2dd0429:	vbroadcasti32x4 -0x23b6113(%rip),%zmm2        # a1a320 <switch.table.ir_if_convert_test_reload+0x138>
 2dd0433:	vbroadcasti32x4 -0x23b610d(%rip),%zmm3        # a1a330 <switch.table.ir_if_convert_test_reload+0x148>
 2dd043d:	vbroadcasti32x4 -0x23b6107(%rip),%zmm4        # a1a340 <switch.table.ir_if_convert_test_reload+0x158>
 2dd0447:	vbroadcasti32x4 -0x23b6101(%rip),%zmm5        # a1a350 <switch.table.ir_if_convert_test_reload+0x168>
 2dd0451:	vbroadcasti32x4 -0x23b60fb(%rip),%zmm6        # a1a360 <switch.table.ir_if_convert_test_reload+0x178>
 2dd045b:	vbroadcasti32x4 -0x23b60f5(%rip),%zmm7        # a1a370 <switch.table.ir_if_convert_test_reload+0x188>
 2dd0465:	vbroadcasti32x4 -0x23b60ef(%rip),%zmm8        # a1a380 <switch.table.ir_if_convert_test_reload+0x198>
 2dd046f:	vbroadcasti32x4 -0x23b60e9(%rip),%zmm9        # a1a390 <switch.table.ir_if_convert_test_reload+0x1a8>
 2dd0479:	vbroadcasti32x4 -0x23b60e3(%rip),%zmm10        # a1a3a0 <switch.table.ir_if_convert_test_reload+0x1b8>
 2dd0483:	vbroadcasti32x4 -0x23b60dd(%rip),%zmm11        # a1a3b0 <switch.table.ir_if_convert_test_reload+0x1c8>
 2dd048d:	vbroadcasti32x4 -0x23b60d7(%rip),%zmm12        # a1a3c0 <switch.table.ir_if_convert_test_reload+0x1d8>
 2dd0497:	vbroadcasti32x4 -0x23b60d1(%rip),%zmm13        # a1a3d0 <switch.table.ir_if_convert_test_reload+0x1e8>
 2dd04a1:	vbroadcasti32x4 -0x23b60cb(%rip),%zmm14        # a1a3e0 <switch.table.ir_if_convert_test_reload+0x1f8>
 2dd04ab:	lea    -0x23a93ca(%rip),%rax        # a270e8 <fast_cc_binary_questioned.range_narrow+0x29a8>
 2dd04b2:	mov    %rdi,0x20(%rsp)
 2dd04b7:	mov    %rcx,0x40(%rsp)
 2dd04bc:	movq   $0x0,0x88(%rsp)
 2dd04c8:	movq   $0x0,0x98(%rsp)
 2dd04d4:	movl   $0x0,0x6c(%rsp)
 2dd04dc:	movq   $0x0,0x10(%rsp)
 2dd04e5:	xor    %r12d,%r12d
 2dd04e8:	xor    %edi,%edi
 2dd04ea:	xor    %r9d,%r9d
 2dd04ed:	xor    %r10d,%r10d
 2dd04f0:	xor    %r8d,%r8d
 2dd04f3:	mov    %rbp,0x8(%rsp)
 2dd04f8:	mov    %rax,0xa8(%rsp)
 2dd0500:	mov    %r10,0x48(%rsp)
 2dd0505:	mov    %rsi,%r10
 2dd0508:	sub    %rbp,%r10
 2dd050b:	mov    %r8,%rdx
 2dd050e:	mov    %r9,0x50(%rsp)
 2dd0513:	mov    %rbp,0x70(%rsp)
 2dd0518:	mov    %rdi,0x60(%rsp)
 2dd051d:	mov    %r12,%r14
 2dd0520:	mov    %r11d,%r8d
 2dd0523:	cmp    $0x40,%r10
 2dd0527:	jb     2dd084e <fast_pp_skip_inactive+0x46e>
 2dd052d:	vmovdqu64 0x0(%rbp),%zmm15
 2dd0534:	mov    $0x40,%r10d
 2dd053a:	mov    $0xffffffffffffffff,%rax
 2dd0541:	vpcmpeqb %zmm1,%zmm15,%k0
 2dd0547:	vpcmpeqb %zmm6,%zmm15,%k1
 2dd054d:	vpaddb %zmm9,%zmm15,%zmm0
 2dd0553:	mov    0x10(%rsp),%r9
 2dd0558:	vpcmpeqb %zmm7,%zmm15,%k2
 2dd055e:	mov    %r10,0x90(%rsp)
 2dd0566:	bzhi   %r10,%rax,%r13
 2dd056b:	kmovq  %k0,%rax
 2dd0570:	vpcmpeqb %zmm5,%zmm15,%k0
 2dd0576:	kmovq  %k2,%r10
 2dd057b:	korq   %k1,%k0,%k1
 2dd0580:	mov    %r13,0x30(%rsp)
 2dd0585:	not    %r13
 2dd0588:	lea    (%rax,%rax,1),%r15
 2dd058c:	lea    (%r10,%r10,1),%r12
 2dd0590:	mov    %rax,%rbp
 2dd0593:	not    %rbp
 2dd0596:	mov    %rax,0x58(%rsp)
 2dd059b:	mov    %r10,0x78(%rsp)
 2dd05a0:	kmovq  %k1,%r11
 2dd05a5:	vpcmpeqb %zmm8,%zmm15,%k1
 2dd05ab:	or     %rbx,%r15
 2dd05ae:	kmovq  %k1,%rcx
 2dd05b3:	vpcmpltub %zmm10,%zmm0,%k1
 2dd05ba:	kmovq  %k1,%rdi
 2dd05bf:	or     %rcx,%r13
 2dd05c2:	vpcmpeqb %zmm11,%zmm15,%k1
 2dd05c8:	andn   %rdi,%rax,%rdi
 2dd05cd:	or     %rdi,%r13
 2dd05d0:	mov    %r13,%rbx
 2dd05d3:	and    %r15,%rbx
 2dd05d6:	add    %r13,%rbx
 2dd05d9:	setb   0x3f(%rsp)
 2dd05de:	or     %r14,%r12
 2dd05e1:	or     %r12,%rbp
 2dd05e4:	add    $0xff,%r9b
 2dd05e8:	adc    %rbp,%r11
 2dd05eb:	setb   %al
 2dd05ee:	mov    %r11,0x28(%rsp)
 2dd05f3:	mov    %rax,0x10(%rsp)
 2dd05f8:	kmovq  %k1,%rax
 2dd05fd:	lea    (%rax,%rax,1),%r14
 2dd0601:	mov    %rax,0xa0(%rsp)
 2dd0609:	kmovq  %k0,%rax
 2dd060e:	or     %rdx,%r14
 2dd0611:	and    %rax,%r14
 2dd0614:	jne    2dd06f9 <fast_pp_skip_inactive+0x319>
 2dd061a:	xor    %r10d,%r10d
 2dd061d:	mov    %r8d,%r11d
 2dd0620:	vpcmpeqb %zmm2,%zmm15,%k0
 2dd0626:	vpcmpeqb %zmm4,%zmm15,%k1
 2dd062c:	or     %r15,%rbx
 2dd062f:	kmovq  %k0,%rdi
 2dd0634:	vpcmpeqb %zmm3,%zmm15,%k0
 2dd063a:	andn   %rbx,%r13,%r9
 2dd063f:	mov    %r10,%rbx
 2dd0642:	kmovq  %k0,%rdx
 2dd0647:	korq   %k0,%k1,%k1
 2dd064c:	and    %r9,%rdi
 2dd064f:	lea    (%rdx,%rdx,1),%rax
 2dd0653:	or     0x60(%rsp),%rax
 2dd0658:	kmovq  %k1,%rcx
 2dd065d:	and    %rcx,%rax
 2dd0660:	or     %rdi,%rax
 2dd0663:	or     %r10,%rax
 2dd0666:	mov    0x30(%rsp),%r10
 2dd066b:	mov    %rax,%rcx
 2dd066e:	and    %r10,%rcx
 2dd0671:	mov    %rcx,%r8
 2dd0674:	or     %r12,%r8
 2dd0677:	jne    2dd086e <fast_pp_skip_inactive+0x48e>
 2dd067d:	mov    0x28(%rsp),%r8
 2dd0682:	andn   %rbp,%r8,%r10
 2dd0687:	test   %rcx,%rcx
 2dd068a:	jne    2dd08ae <fast_pp_skip_inactive+0x4ce>
 2dd0690:	mov    0x78(%rsp),%r14
 2dd0695:	movzbl 0x3f(%rsp),%eax
 2dd069a:	mov    0x58(%rsp),%rbx
 2dd069f:	mov    0xa0(%rsp),%r8
 2dd06a7:	mov    0x70(%rsp),%rbp
 2dd06ac:	xor    %ecx,%ecx
 2dd06ae:	shr    $0x3f,%rdx
 2dd06b2:	shr    $0x3f,%r9
 2dd06b6:	shr    $0x3f,%r10
 2dd06ba:	add    0x90(%rsp),%rbp
 2dd06c2:	mov    %rdx,%rdi
 2dd06c5:	mov    %al,%cl
 2dd06c7:	popcnt %rbx,%rax
 2dd06cc:	shr    $0x3f,%rbx
 2dd06d0:	shr    $0x3f,%r14
 2dd06d4:	shr    $0x3f,%r8
 2dd06d8:	or     %rcx,%rbx
 2dd06db:	add    %eax,%r11d
 2dd06de:	xor    %ecx,%ecx
 2dd06e0:	mov    %r14,%r12
 2dd06e3:	cmp    %rsi,%rbp
 2dd06e6:	jae    2dd1ebd <fast_pp_skip_inactive+0x1add>
 2dd06ec:	test   %cl,%cl
 2dd06ee:	je     2dd0500 <fast_pp_skip_inactive+0x120>
 2dd06f4:	jmp    2dd1ebd <fast_pp_skip_inactive+0x1add>
 2dd06f9:	mov    0x40(%rsp),%rax
 2dd06fe:	xor    %r10d,%r10d
 2dd0701:	mov    %r8d,0x4(%rsp)
 2dd0706:	vmovdqu64 %zmm15,0xd0(%rsp)
 2dd0711:	kmovq  %k2,0xc8(%rsp)
 2dd071b:	mov    (%rax),%rax
 2dd071e:	mov    %rax,0xb8(%rsp)
 2dd0726:	mov    0x20(%rsp),%rax
 2dd072b:	movzbl 0xe9d0(%rax),%eax
 2dd0732:	mov    %al,0x3e(%rsp)
 2dd0736:	mov    0x70(%rsp),%rax
 2dd073b:	movzbl 0x3e(%rsp),%edx
 2dd0740:	mov    0xb8(%rsp),%rdi
 2dd0748:	xor    %ecx,%ecx
 2dd074a:	tzcnt  %r14,%rcx
 2dd074f:	mov    %r10,0xc0(%rsp)
 2dd0757:	mov    %rcx,0xb0(%rsp)
 2dd075f:	lea    (%rax,%rcx,1),%rsi
 2dd0763:	vzeroupper
 2dd0766:	call   45df010 <fast_raw_string_before>
 2dd076b:	vmovdqu64 0xd0(%rsp),%zmm15
 2dd0776:	vbroadcasti32x4 -0x23b63a0(%rip),%zmm14        # a1a3e0 <switch.table.ir_if_convert_test_reload+0x1f8>
 2dd0780:	vbroadcasti32x4 -0x23b63ba(%rip),%zmm13        # a1a3d0 <switch.table.ir_if_convert_test_reload+0x1e8>
 2dd078a:	vbroadcasti32x4 -0x23b63d4(%rip),%zmm12        # a1a3c0 <switch.table.ir_if_convert_test_reload+0x1d8>
 2dd0794:	vbroadcasti32x4 -0x23b63ee(%rip),%zmm11        # a1a3b0 <switch.table.ir_if_convert_test_reload+0x1c8>
 2dd079e:	vbroadcasti32x4 -0x23b6408(%rip),%zmm10        # a1a3a0 <switch.table.ir_if_convert_test_reload+0x1b8>
 2dd07a8:	vbroadcasti32x4 -0x23b6422(%rip),%zmm9        # a1a390 <switch.table.ir_if_convert_test_reload+0x1a8>
 2dd07b2:	vbroadcasti32x4 -0x23b643c(%rip),%zmm8        # a1a380 <switch.table.ir_if_convert_test_reload+0x198>
 2dd07bc:	vbroadcasti32x4 -0x23b6456(%rip),%zmm7        # a1a370 <switch.table.ir_if_convert_test_reload+0x188>
 2dd07c6:	vbroadcasti32x4 -0x23b6470(%rip),%zmm6        # a1a360 <switch.table.ir_if_convert_test_reload+0x178>
 2dd07d0:	vbroadcasti32x4 -0x23b648a(%rip),%zmm5        # a1a350 <switch.table.ir_if_convert_test_reload+0x168>
 2dd07da:	vbroadcasti32x4 -0x23b64a4(%rip),%zmm4        # a1a340 <switch.table.ir_if_convert_test_reload+0x158>
 2dd07e4:	vbroadcasti32x4 -0x23b64be(%rip),%zmm3        # a1a330 <switch.table.ir_if_convert_test_reload+0x148>
 2dd07ee:	vbroadcasti32x4 -0x23b64d8(%rip),%zmm2        # a1a320 <switch.table.ir_if_convert_test_reload+0x138>
 2dd07f8:	vbroadcasti32x4 -0x23b6502(%rip),%zmm1        # a1a300 <switch.table.ir_if_convert_test_reload+0x118>
 2dd0802:	mov    0xb0(%rsp),%rdx
 2dd080a:	mov    0xc0(%rsp),%r10
 2dd0812:	kmovq  0xc8(%rsp),%k2
 2dd081c:	mov    0x18(%rsp),%rsi
 2dd0821:	mov    0x4(%rsp),%r11d
 2dd0826:	mov    $0x1,%ecx
 2dd082b:	test   %al,%al
 2dd082d:	mov    $0x0,%eax
 2dd0832:	shlx   %rdx,%rcx,%rcx
 2dd0837:	cmove  %rax,%rcx
 2dd083b:	or     %rcx,%r10
 2dd083e:	blsr   %r14,%r14
 2dd0843:	je     2dd0620 <fast_pp_skip_inactive+0x240>
 2dd0849:	jmp    2dd0736 <fast_pp_skip_inactive+0x356>
 2dd084e:	mov    $0xffffffffffffffff,%rax
 2dd0855:	shlx   %r10,%rax,%rcx
 2dd085a:	not    %rcx
 2dd085d:	kmovq  %rcx,%k1
 2dd0862:	vmovdqu8 0x0(%rbp),%zmm15{%k1}{z}
 2dd0869:	jmp    2dd053a <fast_pp_skip_inactive+0x15a>
 2dd086e:	vpcmpeqb %zmm14,%zmm15,%k1
 2dd0874:	vpandq %zmm12,%zmm15,%zmm0
 2dd087a:	vpcmpeqb %zmm13,%zmm0,%k0
 2dd0880:	korq   %k1,%k2,%k1
 2dd0885:	korq   %k0,%k1,%k0
 2dd088a:	kmovq  %k0,%rcx
 2dd088f:	and    %rcx,%r12
 2dd0892:	or     %rax,%r12
 2dd0895:	and    %r10,%r12
 2dd0898:	mov    %r12,%rcx
 2dd089b:	mov    0x28(%rsp),%r8
 2dd08a0:	andn   %rbp,%r8,%r10
 2dd08a5:	test   %rcx,%rcx
 2dd08a8:	je     2dd0690 <fast_pp_skip_inactive+0x2b0>
 2dd08ae:	tzcnt  %rcx,%rcx
 2dd08b3:	mov    $0x0,%r12d
 2dd08b9:	shrx   %rcx,%rbx,%r8
 2dd08be:	mov    0x70(%rsp),%rbx
 2dd08c3:	shrx   %rcx,%rdi,%rdx
 2dd08c8:	mov    %r8,%rsi
 2dd08cb:	or     $0xfffffffffffffffe,%rsi
 2dd08cf:	inc    %rsi
 2dd08d2:	test   $0x1,%dl
 2dd08d5:	cmove  %rsi,%r12
 2dd08d9:	lea    (%rbx,%rcx,1),%r15
 2dd08dd:	add    %r12,%r15
 2dd08e0:	test   $0x1,%dl
 2dd08e3:	je     2dd0904 <fast_pp_skip_inactive+0x524>
 2dd08e5:	test   $0x1,%r8b
 2dd08e9:	jne    2dd0be4 <fast_pp_skip_inactive+0x804>
 2dd08ef:	mov    0x58(%rsp),%r9
 2dd08f4:	shrx   %rcx,%r10,%rsi
 2dd08f9:	mov    $0x1,%r14d
 2dd08ff:	and    $0x1,%esi
 2dd0902:	jmp    2dd094c <fast_pp_skip_inactive+0x56c>
 2dd0904:	mov    $0xffffffff,%esi
 2dd0909:	add    %ecx,%esi
 2dd090b:	shrx   %rsi,%r9,%rdi
 2dd0910:	mov    0x50(%rsp),%r9
 2dd0915:	and    $0x1,%edi
 2dd0918:	test   %rcx,%rcx
 2dd091b:	cmovne %edi,%r9d
 2dd091f:	xor    %r14d,%r14d
 2dd0922:	test   %r9d,%r9d
 2dd0925:	setne  %r14b
 2dd0929:	test   $0x1,%r8b
 2dd092d:	jne    2dd0bea <fast_pp_skip_inactive+0x80a>
 2dd0933:	mov    0x58(%rsp),%r9
 2dd0938:	test   %rcx,%rcx
 2dd093b:	je     2dd0947 <fast_pp_skip_inactive+0x567>
 2dd093d:	shrx   %rsi,%r10,%rsi
 2dd0942:	and    $0x1,%esi
 2dd0945:	jmp    2dd094c <fast_pp_skip_inactive+0x56c>
 2dd0947:	mov    0x48(%rsp),%rsi
 2dd094c:	mov    $0xffffffffffffffff,%rdi
 2dd0953:	bzhi   %rcx,%rdi,%rdi
 2dd0958:	and    %r9,%rdi
 2dd095b:	popcnt %rdi,%rdi
 2dd0960:	add    %edi,%r11d
 2dd0963:	test   %esi,%esi
 2dd0965:	jne    2dd0c03 <fast_pp_skip_inactive+0x823>
 2dd096b:	test   $0x1,%dl
 2dd096e:	je     2dd0cc2 <fast_pp_skip_inactive+0x8e2>
 2dd0974:	mov    0x18(%rsp),%rbx
 2dd0979:	inc    %r15
 2dd097c:	mov    %r11d,0x4(%rsp)
 2dd0981:	mov    %r15,%rdi
 2dd0984:	mov    %rbx,%rsi
 2dd0987:	vzeroupper
 2dd098a:	call   45db6d0 <fast_skip_hspace>
 2dd098f:	mov    %rbx,%rsi
 2dd0992:	mov    %rax,%rbp
 2dd0995:	cmp    %rbx,%rax
 2dd0998:	jae    2dd09ab <fast_pp_skip_inactive+0x5cb>
 2dd099a:	movzbl 0x0(%rbp),%ebx
 2dd099e:	lea    -0x23b2ba5(%rip),%rax        # a1de00 <fast_char_class>
 2dd09a5:	testb  $0x2,(%rbx,%rax,1)
 2dd09a9:	jne    2dd09cf <fast_pp_skip_inactive+0x5ef>
 2dd09ab:	mov    0x4(%rsp),%r11d
 2dd09b0:	xor    %ecx,%ecx
 2dd09b2:	xor    %r8d,%r8d
 2dd09b5:	xor    %edi,%edi
 2dd09b7:	xor    %r12d,%r12d
 2dd09ba:	movq   $0x0,0x10(%rsp)
 2dd09c3:	mov    %rbp,0x8(%rsp)
 2dd09c8:	xor    %ebx,%ebx
 2dd09ca:	jmp    2dd0f02 <fast_pp_skip_inactive+0xb22>
 2dd09cf:	mov    %rbp,%rdi
 2dd09d2:	call   45ddb30 <fast_scan_ident_len>
 2dd09d7:	lea    -0x2(%rax),%ecx
 2dd09da:	cmp    $0x6,%ecx
 2dd09dd:	ja     2dd0b2d <fast_pp_skip_inactive+0x74d>
 2dd09e3:	lea    -0x23ac6b6(%rip),%rdx        # a24334 <c_direct_test_dependencies.levels+0x57>
 2dd09ea:	movslq (%rdx,%rcx,4),%rcx
 2dd09ee:	add    %rdx,%rcx
 2dd09f1:	jmp    *%rcx
 2dd09f3:	cmp    $0x69,%bl
 2dd09f6:	jne    2dd0b2d <fast_pp_skip_inactive+0x74d>
 2dd09fc:	cmpb   $0x66,0x1(%rbp)
 2dd0a00:	je     2dd0adc <fast_pp_skip_inactive+0x6fc>
 2dd0a06:	jmp    2dd0b2d <fast_pp_skip_inactive+0x74d>
 2dd0a0b:	movzbl 0x4(%rbp),%esi
 2dd0a0f:	mov    0x0(%rbp),%ecx
 2dd0a12:	mov    $0x65646669,%edx
 2dd0a17:	xor    %edx,%ecx
 2dd0a19:	xor    $0x66,%esi
 2dd0a1c:	or     %ecx,%esi
 2dd0a1e:	je     2dd0adc <fast_pp_skip_inactive+0x6fc>
 2dd0a24:	movzbl 0x4(%rbp),%esi
 2dd0a28:	mov    0x0(%rbp),%ecx
 2dd0a2b:	mov    $0x69646e65,%edx
 2dd0a30:	xor    %edx,%ecx
 2dd0a32:	xor    $0x66,%esi
 2dd0a35:	or     %ecx,%esi
 2dd0a37:	jne    2dd0b2d <fast_pp_skip_inactive+0x74d>
 2dd0a3d:	add    $0x5,%rbp
 2dd0a41:	cmpl   $0x0,0x88(%rsp)
 2dd0a49:	mov    %rbp,0x8(%rsp)
 2dd0a4e:	je     2dd1fce <fast_pp_skip_inactive+0x1bee>
 2dd0a54:	mov    0x88(%rsp),%rax
 2dd0a5c:	mov    0x8(%rsp),%rbp
 2dd0a61:	mov    0x4(%rsp),%r11d
 2dd0a66:	xor    %ecx,%ecx
 2dd0a68:	xor    %r8d,%r8d
 2dd0a6b:	xor    %edi,%edi
 2dd0a6d:	xor    %r12d,%r12d
 2dd0a70:	movq   $0x0,0x10(%rsp)
 2dd0a79:	xor    %ebx,%ebx
 2dd0a7b:	dec    %eax
 2dd0a7d:	mov    %rax,0x88(%rsp)
 2dd0a85:	jmp    2dd0b51 <fast_pp_skip_inactive+0x771>
 2dd0a8a:	movabs $0x6665646e66696c65,%rcx
 2dd0a94:	cmp    %rcx,0x0(%rbp)
 2dd0a98:	jne    2dd0b2d <fast_pp_skip_inactive+0x74d>
 2dd0a9e:	mov    $0x32,%r14b
 2dd0aa1:	jmp    2dd0b6a <fast_pp_skip_inactive+0x78a>
 2dd0aa6:	cmpl   $0x65736c65,0x0(%rbp)
 2dd0aad:	je     2dd0b5b <fast_pp_skip_inactive+0x77b>
 2dd0ab3:	cmpl   $0x66696c65,0x0(%rbp)
 2dd0aba:	jne    2dd0b2d <fast_pp_skip_inactive+0x74d>
 2dd0abc:	mov    $0x4,%r14b
 2dd0abf:	jmp    2dd0b7d <fast_pp_skip_inactive+0x79d>
 2dd0ac4:	movzwl 0x4(%rbp),%esi
 2dd0ac8:	mov    0x0(%rbp),%ecx
 2dd0acb:	mov    $0x646e6669,%edx
 2dd0ad0:	xor    %edx,%ecx
 2dd0ad2:	xor    $0x6665,%esi
 2dd0ad8:	or     %ecx,%esi
 2dd0ada:	jne    2dd0b2d <fast_pp_skip_inactive+0x74d>
 2dd0adc:	mov    0x88(%rsp),%rcx
 2dd0ae4:	mov    %eax,%eax
 2dd0ae6:	add    %rax,%rbp
 2dd0ae9:	xor    %eax,%eax
 2dd0aeb:	mov    0x98(%rsp),%rdx
 2dd0af3:	inc    %ecx
 2dd0af5:	cmp    $0x40,%ecx
 2dd0af8:	mov    %rcx,0x88(%rsp)
 2dd0b00:	setae  %al
 2dd0b03:	btr    %rcx,%rdx
 2dd0b07:	or     %eax,0x6c(%rsp)
 2dd0b0b:	mov    %rdx,0x98(%rsp)
 2dd0b13:	jmp    2dd0b32 <fast_pp_skip_inactive+0x752>
 2dd0b15:	mov    0x0(%rbp),%ecx
 2dd0b18:	mov    0x3(%rbp),%esi
 2dd0b1b:	mov    $0x66696c65,%edx
 2dd0b20:	mov    $0x66656466,%edi
 2dd0b25:	xor    %edx,%ecx
 2dd0b27:	xor    %edi,%esi
 2dd0b29:	or     %ecx,%esi
 2dd0b2b:	je     2dd0b67 <fast_pp_skip_inactive+0x787>
 2dd0b2d:	mov    %eax,%eax
 2dd0b2f:	add    %rax,%rbp
 2dd0b32:	mov    0x4(%rsp),%r11d
 2dd0b37:	xor    %ecx,%ecx
 2dd0b39:	xor    %r8d,%r8d
 2dd0b3c:	xor    %edi,%edi
 2dd0b3e:	xor    %r12d,%r12d
 2dd0b41:	movq   $0x0,0x10(%rsp)
 2dd0b4a:	xor    %ebx,%ebx
 2dd0b4c:	mov    %rbp,0x8(%rsp)
 2dd0b51:	mov    0x18(%rsp),%rsi
 2dd0b56:	jmp    2dd0f02 <fast_pp_skip_inactive+0xb22>
 2dd0b5b:	mov    $0xffffffffffffffff,%rcx
 2dd0b62:	mov    $0x5,%r14b
 2dd0b65:	jmp    2dd0b7f <fast_pp_skip_inactive+0x79f>
 2dd0b67:	mov    $0x31,%r14b
 2dd0b6a:	mov    0x20(%rsp),%rcx
 2dd0b6f:	movzbl 0xe979(%rcx),%ecx
 2dd0b76:	xor    $0x1,%ecx
 2dd0b79:	or     %ecx,0x6c(%rsp)
 2dd0b7d:	xor    %ecx,%ecx
 2dd0b7f:	mov    0x88(%rsp),%rdx
 2dd0b87:	mov    %eax,%eax
 2dd0b89:	add    %rax,%rbp
 2dd0b8c:	mov    %rbp,0x8(%rsp)
 2dd0b91:	test   %edx,%edx
 2dd0b93:	je     2dd1fd1 <fast_pp_skip_inactive+0x1bf1>
 2dd0b99:	mov    0x98(%rsp),%rdi
 2dd0ba1:	mov    $0x1,%eax
 2dd0ba6:	mov    0x4(%rsp),%r11d
 2dd0bab:	xor    %r8d,%r8d
 2dd0bae:	xor    %r12d,%r12d
 2dd0bb1:	movq   $0x0,0x10(%rsp)
 2dd0bba:	xor    %ebx,%ebx
 2dd0bbc:	shlx   %rdx,%rax,%rax
 2dd0bc1:	and    %rax,%rcx
 2dd0bc4:	shrx   %rdx,%rdi,%rax
 2dd0bc9:	or     %rcx,%rdi
 2dd0bcc:	xor    %ecx,%ecx
 2dd0bce:	and    $0x1,%eax
 2dd0bd1:	mov    %rdi,0x98(%rsp)
 2dd0bd9:	xor    %edi,%edi
 2dd0bdb:	or     %eax,0x6c(%rsp)
 2dd0bdf:	jmp    2dd0b51 <fast_pp_skip_inactive+0x771>
 2dd0be4:	mov    $0x1,%r14d
 2dd0bea:	mov    $0xffffffffffffffff,%r9
 2dd0bf1:	bzhi   %rcx,%r9,%r9
 2dd0bf6:	and    0x58(%rsp),%r9
 2dd0bfb:	popcnt %r9,%r9
 2dd0c00:	add    %r9d,%r11d
 2dd0c03:	mov    %r14,%rdi
 2dd0c06:	mov    %r11d,%r13d
 2dd0c09:	mov    %r15,0x60(%rsp)
 2dd0c0e:	cmp    0x8(%rsp),%r15
 2dd0c13:	jbe    2dd0c54 <fast_pp_skip_inactive+0x874>
 2dd0c15:	mov    0x60(%rsp),%r15
 2dd0c1a:	lea    (%r12,%rcx,1),%rsi
 2dd0c1e:	lea    -0x1(%rbx,%rsi,1),%rsi
 2dd0c23:	jmp    2dd0c33 <fast_pp_skip_inactive+0x853>
 2dd0c25:	dec    %r15
 2dd0c28:	cmp    0x8(%rsp),%rsi
 2dd0c2d:	lea    -0x1(%rsi),%rsi
 2dd0c31:	jbe    2dd0c47 <fast_pp_skip_inactive+0x867>
 2dd0c33:	cmpb   $0xa,(%rsi)
 2dd0c36:	jne    2dd0c25 <fast_pp_skip_inactive+0x845>
 2dd0c38:	cmp    0x8(%rsp),%rsi
 2dd0c3d:	jbe    2dd0c4e <fast_pp_skip_inactive+0x86e>
 2dd0c3f:	cmpb   $0x5c,-0x1(%rsi)
 2dd0c43:	je     2dd0c25 <fast_pp_skip_inactive+0x845>
 2dd0c45:	jmp    2dd0c54 <fast_pp_skip_inactive+0x874>
 2dd0c47:	mov    0x8(%rsp),%r15
 2dd0c4c:	jmp    2dd0c54 <fast_pp_skip_inactive+0x874>
 2dd0c4e:	inc    %rsi
 2dd0c51:	mov    %rsi,%r15
 2dd0c54:	and    $0x1,%r8d
 2dd0c58:	add    0x60(%rsp),%r8
 2dd0c5d:	cmp    %r8,%r15
 2dd0c60:	jae    2dd0cae <fast_pp_skip_inactive+0x8ce>
 2dd0c62:	add    %rcx,%r12
 2dd0c65:	mov    %r15,0x10(%rsp)
 2dd0c6a:	xor    %ebp,%ebp
 2dd0c6c:	add    %rbx,%r12
 2dd0c6f:	lea    0x30(%r15),%rbx
 2dd0c73:	mov    %r12,%r14
 2dd0c76:	sub    %r15,%r14
 2dd0c79:	movzbl (%r15,%rbp,1),%esi
 2dd0c7e:	mov    %esi,0x70(%rsp)
 2dd0c82:	cmp    $0x22,%esi
 2dd0c85:	je     2dd0ffb <fast_pp_skip_inactive+0xc1b>
 2dd0c8b:	cmpl   $0x27,0x70(%rsp)
 2dd0c90:	je     2dd0fc0 <fast_pp_skip_inactive+0xbe0>
 2dd0c96:	incq   0x10(%rsp)
 2dd0c9b:	lea    0x1(%r15,%rbp,1),%rsi
 2dd0ca0:	inc    %rbp
 2dd0ca3:	dec    %r14
 2dd0ca6:	inc    %rbx
 2dd0ca9:	cmp    %r8,%rsi
 2dd0cac:	jb     2dd0c79 <fast_pp_skip_inactive+0x899>
 2dd0cae:	mov    0x60(%rsp),%r15
 2dd0cb3:	mov    %r13d,%r11d
 2dd0cb6:	mov    %rdi,%r14
 2dd0cb9:	test   $0x1,%dl
 2dd0cbc:	jne    2dd0974 <fast_pp_skip_inactive+0x594>
 2dd0cc2:	mov    0x18(%rsp),%rsi
 2dd0cc7:	mov    $0x1,%edx
 2dd0ccc:	shlx   %rcx,%rdx,%rcx
 2dd0cd1:	test   %rax,%rcx
 2dd0cd4:	je     2dd0d2f <fast_pp_skip_inactive+0x94f>
 2dd0cd6:	movl   $0x0,0x84(%rsp)
 2dd0ce1:	mov    %r14,%rbx
 2dd0ce4:	mov    0x20(%rsp),%r14
 2dd0ce9:	lea    0x2(%r15),%rdi
 2dd0ced:	mov    %r11d,%ebp
 2dd0cf0:	cmpb   $0x2a,0x1(%r15)
 2dd0cf5:	jne    2dd0e16 <fast_pp_skip_inactive+0xa36>
 2dd0cfb:	lea    0x84(%rsp),%rdx
 2dd0d03:	vzeroupper
 2dd0d06:	call   45dd2e0 <fast_skip_block_comment>
 2dd0d0b:	test   %rax,%rax
 2dd0d0e:	jne    2dd0e26 <fast_pp_skip_inactive+0xa46>
 2dd0d14:	lea    -0x23a9bd7(%rip),%rsi        # a27144 <fast_cc_binary_questioned.range_narrow+0x2a04>
 2dd0d1b:	mov    %r14,%rdi
 2dd0d1e:	call   45da9f9 <fast_pp_bail>
 2dd0d23:	mov    0x18(%rsp),%rax
 2dd0d28:	mov    $0x1,%cl
 2dd0d2a:	jmp    2dd0e28 <fast_pp_skip_inactive+0xa48>
 2dd0d2f:	inc    %r15
 2dd0d32:	mov    %r11d,%r13d
 2dd0d35:	mov    %r15,%rdi
 2dd0d38:	vzeroupper
 2dd0d3b:	call   45df0d0 <fast_skip_splices>
 2dd0d40:	mov    0x18(%rsp),%rcx
 2dd0d45:	mov    %rcx,%rsi
 2dd0d48:	cmp    %rcx,%rax
 2dd0d4b:	jae    2dd0ee2 <fast_pp_skip_inactive+0xb02>
 2dd0d51:	vbroadcasti32x4 -0x23b6a5b(%rip),%zmm1        # a1a300 <switch.table.ir_if_convert_test_reload+0x118>
 2dd0d5b:	vbroadcasti32x4 -0x23b6a45(%rip),%zmm2        # a1a320 <switch.table.ir_if_convert_test_reload+0x138>
 2dd0d65:	vbroadcasti32x4 -0x23b6a3f(%rip),%zmm3        # a1a330 <switch.table.ir_if_convert_test_reload+0x148>
 2dd0d6f:	vbroadcasti32x4 -0x23b6a39(%rip),%zmm4        # a1a340 <switch.table.ir_if_convert_test_reload+0x158>
 2dd0d79:	vbroadcasti32x4 -0x23b6a33(%rip),%zmm5        # a1a350 <switch.table.ir_if_convert_test_reload+0x168>
 2dd0d83:	vbroadcasti32x4 -0x23b6a2d(%rip),%zmm6        # a1a360 <switch.table.ir_if_convert_test_reload+0x178>
 2dd0d8d:	vbroadcasti32x4 -0x23b6a27(%rip),%zmm7        # a1a370 <switch.table.ir_if_convert_test_reload+0x188>
 2dd0d97:	vbroadcasti32x4 -0x23b6a21(%rip),%zmm8        # a1a380 <switch.table.ir_if_convert_test_reload+0x198>
 2dd0da1:	vbroadcasti32x4 -0x23b6a1b(%rip),%zmm9        # a1a390 <switch.table.ir_if_convert_test_reload+0x1a8>
 2dd0dab:	vbroadcasti32x4 -0x23b6a15(%rip),%zmm10        # a1a3a0 <switch.table.ir_if_convert_test_reload+0x1b8>
 2dd0db5:	vbroadcasti32x4 -0x23b6a0f(%rip),%zmm11        # a1a3b0 <switch.table.ir_if_convert_test_reload+0x1c8>
 2dd0dbf:	vbroadcasti32x4 -0x23b6a09(%rip),%zmm12        # a1a3c0 <switch.table.ir_if_convert_test_reload+0x1d8>
 2dd0dc9:	vbroadcasti32x4 -0x23b6a03(%rip),%zmm13        # a1a3d0 <switch.table.ir_if_convert_test_reload+0x1e8>
 2dd0dd3:	vbroadcasti32x4 -0x23b69fd(%rip),%zmm14        # a1a3e0 <switch.table.ir_if_convert_test_reload+0x1f8>
 2dd0ddd:	movzbl (%rax),%edx
 2dd0de0:	xor    %r8d,%r8d
 2dd0de3:	xor    %ecx,%ecx
 2dd0de5:	mov    %r13d,%r11d
 2dd0de8:	add    $0xffffffb2,%edx
 2dd0deb:	cmp    $0x27,%edx
 2dd0dee:	ja     2dd0fa6 <fast_pp_skip_inactive+0xbc6>
 2dd0df4:	movabs $0x8000000081,%rax
 2dd0dfe:	movq   $0x0,0x10(%rsp)
 2dd0e07:	bt     %rdx,%rax
 2dd0e0b:	jae    2dd0faf <fast_pp_skip_inactive+0xbcf>
 2dd0e11:	jmp    2dd1e8f <fast_pp_skip_inactive+0x1aaf>
 2dd0e16:	lea    0x84(%rsp),%rdx
 2dd0e1e:	vzeroupper
 2dd0e21:	call   45dd3d0 <fast_skip_line_comment>
 2dd0e26:	xor    %ecx,%ecx
 2dd0e28:	vbroadcasti32x4 -0x23b6b32(%rip),%zmm1        # a1a300 <switch.table.ir_if_convert_test_reload+0x118>
 2dd0e32:	vbroadcasti32x4 -0x23b6b1c(%rip),%zmm2        # a1a320 <switch.table.ir_if_convert_test_reload+0x138>
 2dd0e3c:	vbroadcasti32x4 -0x23b6b16(%rip),%zmm3        # a1a330 <switch.table.ir_if_convert_test_reload+0x148>
 2dd0e46:	vbroadcasti32x4 -0x23b6b10(%rip),%zmm4        # a1a340 <switch.table.ir_if_convert_test_reload+0x158>
 2dd0e50:	vbroadcasti32x4 -0x23b6b0a(%rip),%zmm5        # a1a350 <switch.table.ir_if_convert_test_reload+0x168>
 2dd0e5a:	vbroadcasti32x4 -0x23b6b04(%rip),%zmm6        # a1a360 <switch.table.ir_if_convert_test_reload+0x178>
 2dd0e64:	vbroadcasti32x4 -0x23b6afe(%rip),%zmm7        # a1a370 <switch.table.ir_if_convert_test_reload+0x188>
 2dd0e6e:	vbroadcasti32x4 -0x23b6af8(%rip),%zmm8        # a1a380 <switch.table.ir_if_convert_test_reload+0x198>
 2dd0e78:	vbroadcasti32x4 -0x23b6af2(%rip),%zmm9        # a1a390 <switch.table.ir_if_convert_test_reload+0x1a8>
 2dd0e82:	vbroadcasti32x4 -0x23b6aec(%rip),%zmm10        # a1a3a0 <switch.table.ir_if_convert_test_reload+0x1b8>
 2dd0e8c:	vbroadcasti32x4 -0x23b6ae6(%rip),%zmm11        # a1a3b0 <switch.table.ir_if_convert_test_reload+0x1c8>
 2dd0e96:	vbroadcasti32x4 -0x23b6ae0(%rip),%zmm12        # a1a3c0 <switch.table.ir_if_convert_test_reload+0x1d8>
 2dd0ea0:	vbroadcasti32x4 -0x23b6ada(%rip),%zmm13        # a1a3d0 <switch.table.ir_if_convert_test_reload+0x1e8>
 2dd0eaa:	vbroadcasti32x4 -0x23b6ad4(%rip),%zmm14        # a1a3e0 <switch.table.ir_if_convert_test_reload+0x1f8>
 2dd0eb4:	mov    %ebp,%r11d
 2dd0eb7:	add    0x84(%rsp),%r11d
 2dd0ebf:	mov    0x18(%rsp),%rsi
 2dd0ec4:	xor    %r8d,%r8d
 2dd0ec7:	xor    %edi,%edi
 2dd0ec9:	xor    %r12d,%r12d
 2dd0ecc:	mov    %rax,%rbp
 2dd0ecf:	movq   $0x0,0x10(%rsp)
 2dd0ed8:	mov    %rax,0x8(%rsp)
 2dd0edd:	jmp    2dd0f8e <fast_pp_skip_inactive+0xbae>
 2dd0ee2:	xor    %ecx,%ecx
 2dd0ee4:	mov    %r15,0x8(%rsp)
 2dd0ee9:	xor    %r8d,%r8d
 2dd0eec:	xor    %edi,%edi
 2dd0eee:	xor    %r12d,%r12d
 2dd0ef1:	movq   $0x0,0x10(%rsp)
 2dd0efa:	xor    %ebx,%ebx
 2dd0efc:	mov    %r15,%rbp
 2dd0eff:	mov    %r13d,%r11d
 2dd0f02:	vbroadcasti32x4 -0x23b6c0c(%rip),%zmm1        # a1a300 <switch.table.ir_if_convert_test_reload+0x118>
 2dd0f0c:	vbroadcasti32x4 -0x23b6bf6(%rip),%zmm2        # a1a320 <switch.table.ir_if_convert_test_reload+0x138>
 2dd0f16:	vbroadcasti32x4 -0x23b6bf0(%rip),%zmm3        # a1a330 <switch.table.ir_if_convert_test_reload+0x148>
 2dd0f20:	vbroadcasti32x4 -0x23b6bea(%rip),%zmm4        # a1a340 <switch.table.ir_if_convert_test_reload+0x158>
 2dd0f2a:	vbroadcasti32x4 -0x23b6be4(%rip),%zmm5        # a1a350 <switch.table.ir_if_convert_test_reload+0x168>
 2dd0f34:	vbroadcasti32x4 -0x23b6bde(%rip),%zmm6        # a1a360 <switch.table.ir_if_convert_test_reload+0x178>
 2dd0f3e:	vbroadcasti32x4 -0x23b6bd8(%rip),%zmm7        # a1a370 <switch.table.ir_if_convert_test_reload+0x188>
 2dd0f48:	vbroadcasti32x4 -0x23b6bd2(%rip),%zmm8        # a1a380 <switch.table.ir_if_convert_test_reload+0x198>
 2dd0f52:	vbroadcasti32x4 -0x23b6bcc(%rip),%zmm9        # a1a390 <switch.table.ir_if_convert_test_reload+0x1a8>
 2dd0f5c:	vbroadcasti32x4 -0x23b6bc6(%rip),%zmm10        # a1a3a0 <switch.table.ir_if_convert_test_reload+0x1b8>
 2dd0f66:	vbroadcasti32x4 -0x23b6bc0(%rip),%zmm11        # a1a3b0 <switch.table.ir_if_convert_test_reload+0x1c8>
 2dd0f70:	vbroadcasti32x4 -0x23b6bba(%rip),%zmm12        # a1a3c0 <switch.table.ir_if_convert_test_reload+0x1d8>
 2dd0f7a:	vbroadcasti32x4 -0x23b6bb4(%rip),%zmm13        # a1a3d0 <switch.table.ir_if_convert_test_reload+0x1e8>
 2dd0f84:	vbroadcasti32x4 -0x23b6bae(%rip),%zmm14        # a1a3e0 <switch.table.ir_if_convert_test_reload+0x1f8>
 2dd0f8e:	mov    0x50(%rsp),%r9
 2dd0f93:	mov    0x48(%rsp),%r10
 2dd0f98:	cmp    %rsi,%rbp
 2dd0f9b:	jb     2dd06ec <fast_pp_skip_inactive+0x30c>
 2dd0fa1:	jmp    2dd1ebd <fast_pp_skip_inactive+0x1add>
 2dd0fa6:	movq   $0x0,0x10(%rsp)
 2dd0faf:	mov    %r15,0x8(%rsp)
 2dd0fb4:	xor    %edi,%edi
 2dd0fb6:	xor    %r12d,%r12d
 2dd0fb9:	xor    %ebx,%ebx
 2dd0fbb:	mov    %r15,%rbp
 2dd0fbe:	jmp    2dd0f8e <fast_pp_skip_inactive+0xbae>
 2dd0fc0:	cmpb   $0x27,0x70(%rsp)
 2dd0fc5:	jne    2dd1023 <fast_pp_skip_inactive+0xc43>
 2dd0fc7:	mov    0x20(%rsp),%rax
 2dd0fcc:	cmpb   $0x0,0xe979(%rax)
 2dd0fd3:	je     2dd1023 <fast_pp_skip_inactive+0xc43>
 2dd0fd5:	mov    0x40(%rsp),%rax
 2dd0fda:	lea    (%r15,%rbp,1),%rcx
 2dd0fde:	cmp    (%rax),%rcx
 2dd0fe1:	jbe    2dd1023 <fast_pp_skip_inactive+0xc43>
 2dd0fe3:	movzbl -0x1(%r15,%rbp,1),%eax
 2dd0fe9:	lea    -0x23b31f0(%rip),%rcx        # a1de00 <fast_char_class>
 2dd0ff0:	testb  $0x1,(%rax,%rcx,1)
 2dd0ff4:	je     2dd1023 <fast_pp_skip_inactive+0xc43>
 2dd0ff6:	jmp    2dd1e9e <fast_pp_skip_inactive+0x1abe>
 2dd0ffb:	mov    0x40(%rsp),%rax
 2dd1000:	lea    (%r15,%rbp,1),%rsi
 2dd1004:	mov    (%rax),%rdi
 2dd1007:	mov    0x20(%rsp),%rax
 2dd100c:	movzbl 0xe9d0(%rax),%edx
 2dd1013:	vzeroupper
 2dd1016:	call   45df010 <fast_raw_string_before>
 2dd101b:	test   %al,%al
 2dd101d:	jne    2dd2018 <fast_pp_skip_inactive+0x1c38>
 2dd1023:	lea    (%r15,%rbp,1),%rax
 2dd1027:	cmp    0x60(%rsp),%rax
 2dd102c:	jae    2dd11a5 <fast_pp_skip_inactive+0xdc5>
 2dd1032:	sub    %r15,%r12
 2dd1035:	sub    %rbp,%r12
 2dd1038:	cmp    $0x8,%r12
 2dd103c:	jb     2dd1190 <fast_pp_skip_inactive+0xdb0>
 2dd1042:	cmp    $0x40,%r12
 2dd1046:	jae    2dd104f <fast_pp_skip_inactive+0xc6f>
 2dd1048:	xor    %ecx,%ecx
 2dd104a:	jmp    2dd1122 <fast_pp_skip_inactive+0xd42>
 2dd104f:	mov    %r14,%rdx
 2dd1052:	and    $0xffffffffffffffc0,%rdx
 2dd1056:	lea    (%r15,%rbp,1),%rax
 2dd105a:	mov    %r12,%rcx
 2dd105d:	and    $0xffffffffffffffc0,%rcx
 2dd1061:	vmovd  %r13d,%xmm0
 2dd1066:	vpxor  %xmm1,%xmm1,%xmm1
 2dd106a:	vpxor  %xmm2,%xmm2,%xmm2
 2dd106e:	vpxor  %xmm3,%xmm3,%xmm3
 2dd1072:	add    %rdx,%rax
 2dd1075:	vpbroadcastb -0x23b54fe(%rip),%xmm4        # a1bb80 <fast_operand_complex_class+0xdf8>
 2dd107e:	vpcmpeqb -0x30(%rbx),%xmm4,%k0
 2dd1085:	vpcmpeqb -0x20(%rbx),%xmm4,%k1
 2dd108c:	vpcmpeqb -0x10(%rbx),%xmm4,%k2
 2dd1093:	vpcmpeqb (%rbx),%xmm4,%k3
 2dd1099:	add    $0x40,%rbx
 2dd109d:	add    $0xffffffffffffffc0,%rdx
 2dd10a1:	vpmovm2d %k0,%zmm4
 2dd10a7:	vpaddd %zmm4,%zmm0,%zmm0
 2dd10ad:	vpmovm2d %k1,%zmm4
 2dd10b3:	vpaddd %zmm4,%zmm1,%zmm1
 2dd10b9:	vpmovm2d %k2,%zmm4
 2dd10bf:	vpaddd %zmm4,%zmm2,%zmm2
 2dd10c5:	vpmovm2d %k3,%zmm4
 2dd10cb:	vpaddd %zmm4,%zmm3,%zmm3
 2dd10d1:	jne    2dd1075 <fast_pp_skip_inactive+0xc95>
 2dd10d3:	vpaddd %zmm0,%zmm1,%zmm0
 2dd10d9:	vpaddd %zmm0,%zmm2,%zmm0
 2dd10df:	vpaddd %zmm0,%zmm3,%zmm0
 2dd10e5:	vextracti64x4 $0x1,%zmm0,%ymm1
 2dd10ec:	vpaddd %zmm1,%zmm0,%zmm0
 2dd10f2:	vextracti128 $0x1,%ymm0,%xmm1
 2dd10f8:	vpaddd %xmm1,%xmm0,%xmm0
 2dd10fc:	vpshufd $0xee,%xmm0,%xmm1
 2dd1101:	vpaddd %xmm1,%xmm0,%xmm0
 2dd1105:	vpshufd $0x55,%xmm0,%xmm1
 2dd110a:	vpaddd %xmm1,%xmm0,%xmm0
 2dd110e:	vmovd  %xmm0,%r13d
 2dd1113:	cmp    %rcx,%r12
 2dd1116:	je     2dd11a5 <fast_pp_skip_inactive+0xdc5>
 2dd111c:	test   $0x38,%r12b
 2dd1120:	je     2dd1190 <fast_pp_skip_inactive+0xdb0>
 2dd1122:	add    %rcx,0x10(%rsp)
 2dd1127:	and    $0xfffffffffffffff8,%r14
 2dd112b:	lea    (%r15,%rbp,1),%rax
 2dd112f:	mov    %r12,%rdx
 2dd1132:	and    $0xfffffffffffffff8,%rdx
 2dd1136:	vmovd  %r13d,%xmm0
 2dd113b:	add    %r14,%rax
 2dd113e:	sub    %rcx,%r14
 2dd1141:	xor    %ecx,%ecx
 2dd1143:	mov    0x10(%rsp),%rsi
 2dd1148:	vmovq  (%rsi,%rcx,1),%xmm1
 2dd114d:	add    $0x8,%rcx
 2dd1151:	vpcmpeqb -0x23b6e4b(%rip),%xmm1,%k0        # a1a310 <switch.table.ir_if_convert_test_reload+0x128>
 2dd115b:	vpmovm2d %k0,%ymm1
 2dd1161:	vpaddd %ymm1,%ymm0,%ymm0
 2dd1165:	cmp    %rcx,%r14
 2dd1168:	jne    2dd1143 <fast_pp_skip_inactive+0xd63>
 2dd116a:	vextracti128 $0x1,%ymm0,%xmm1
 2dd1170:	vpaddd %xmm1,%xmm0,%xmm0
 2dd1174:	vpshufd $0xee,%xmm0,%xmm1
 2dd1179:	vpaddd %xmm1,%xmm0,%xmm0
 2dd117d:	vpshufd $0x55,%xmm0,%xmm1
 2dd1182:	vpaddd %xmm1,%xmm0,%xmm0
 2dd1186:	vmovd  %xmm0,%r13d
 2dd118b:	cmp    %rdx,%r12
 2dd118e:	je     2dd11a5 <fast_pp_skip_inactive+0xdc5>
 2dd1190:	xor    %ecx,%ecx
 2dd1192:	cmpb   $0xa,(%rax)
 2dd1195:	sete   %cl
 2dd1198:	inc    %rax
 2dd119b:	sub    %ecx,%r13d
 2dd119e:	cmp    0x60(%rsp),%rax
 2dd11a3:	jb     2dd1190 <fast_pp_skip_inactive+0xdb0>
 2dd11a5:	lea    0x1(%r15,%rbp,1),%rax
 2dd11aa:	mov    %rax,0x8(%rsp)
 2dd11af:	cmp    0x18(%rsp),%rax
 2dd11b4:	jb     2dd11e8 <fast_pp_skip_inactive+0xe08>
 2dd11b6:	xor    %ecx,%ecx
 2dd11b8:	mov    0x8(%rsp),%rbp
 2dd11bd:	xor    %r8d,%r8d
 2dd11c0:	xor    %edi,%edi
 2dd11c2:	xor    %r12d,%r12d
 2dd11c5:	xor    %ebx,%ebx
 2dd11c7:	movq   $0x0,0x10(%rsp)
 2dd11d0:	jmp    2dd1251 <fast_pp_skip_inactive+0xe71>
 2dd11d2:	mov    0x8(%rsp),%rdx
 2dd11d7:	xor    %ecx,%ecx
 2dd11d9:	add    %rax,%rdx
 2dd11dc:	mov    %rdx,0x8(%rsp)
 2dd11e1:	cmp    0x18(%rsp),%rdx
 2dd11e6:	jae    2dd11b8 <fast_pp_skip_inactive+0xdd8>
 2dd11e8:	mov    0x8(%rsp),%rax
 2dd11ed:	movzbl (%rax),%ecx
 2dd11f0:	cmp    0x70(%rsp),%cl
 2dd11f4:	je     2dd1226 <fast_pp_skip_inactive+0xe46>
 2dd11f6:	cmp    $0xa,%cl
 2dd11f9:	je     2dd1226 <fast_pp_skip_inactive+0xe46>
 2dd11fb:	mov    $0x1,%eax
 2dd1200:	cmp    $0x5c,%cl
 2dd1203:	jne    2dd11d2 <fast_pp_skip_inactive+0xdf2>
 2dd1205:	mov    0x8(%rsp),%rcx
 2dd120a:	inc    %rcx
 2dd120d:	cmp    0x18(%rsp),%rcx
 2dd1212:	jae    2dd11d2 <fast_pp_skip_inactive+0xdf2>
 2dd1214:	xor    %eax,%eax
 2dd1216:	cmpb   $0xa,(%rcx)
 2dd1219:	sete   %al
 2dd121c:	add    %eax,%r13d
 2dd121f:	mov    $0x2,%eax
 2dd1224:	jmp    2dd11d2 <fast_pp_skip_inactive+0xdf2>
 2dd1226:	xor    %eax,%eax
 2dd1228:	cmp    0x70(%rsp),%cl
 2dd122c:	mov    0x8(%rsp),%rbp
 2dd1231:	movq   $0x0,0x10(%rsp)
 2dd123a:	sete   %al
 2dd123d:	xor    %ecx,%ecx
 2dd123f:	xor    %r8d,%r8d
 2dd1242:	xor    %edi,%edi
 2dd1244:	xor    %r12d,%r12d
 2dd1247:	xor    %ebx,%ebx
 2dd1249:	add    %rax,%rbp
 2dd124c:	mov    %rbp,0x8(%rsp)
 2dd1251:	mov    %r13d,%r11d
 2dd1254:	jmp    2dd0b51 <fast_pp_skip_inactive+0x771>
 2dd1259:	cmp    %rsi,%rbp
 2dd125c:	jae    2dd1e64 <fast_pp_skip_inactive+0x1a84>
 2dd1262:	vbroadcasti32x4 -0x23b6f6c(%rip),%zmm2        # a1a300 <switch.table.ir_if_convert_test_reload+0x118>
 2dd126c:	vbroadcasti32x4 -0x23b6f56(%rip),%zmm3        # a1a320 <switch.table.ir_if_convert_test_reload+0x138>
 2dd1276:	vbroadcasti32x4 -0x23b6f50(%rip),%zmm4        # a1a330 <switch.table.ir_if_convert_test_reload+0x148>
 2dd1280:	vbroadcasti32x4 -0x23b6f4a(%rip),%zmm5        # a1a340 <switch.table.ir_if_convert_test_reload+0x158>
 2dd128a:	vbroadcasti32x4 -0x23b6f44(%rip),%zmm6        # a1a350 <switch.table.ir_if_convert_test_reload+0x168>
 2dd1294:	vbroadcasti32x4 -0x23b6f3e(%rip),%zmm7        # a1a360 <switch.table.ir_if_convert_test_reload+0x178>
 2dd129e:	vbroadcasti32x4 -0x23b6f38(%rip),%zmm8        # a1a370 <switch.table.ir_if_convert_test_reload+0x188>
 2dd12a8:	vbroadcasti32x4 -0x23b6f32(%rip),%zmm9        # a1a380 <switch.table.ir_if_convert_test_reload+0x198>
 2dd12b2:	vbroadcasti32x4 -0x23b6f2c(%rip),%zmm10        # a1a390 <switch.table.ir_if_convert_test_reload+0x1a8>
 2dd12bc:	vbroadcasti32x4 -0x23b6f26(%rip),%zmm11        # a1a3a0 <switch.table.ir_if_convert_test_reload+0x1b8>
 2dd12c6:	vpbroadcastb -0x23b574f(%rip),%xmm12        # a1bb80 <fast_operand_complex_class+0xdf8>
 2dd12cf:	vpbroadcastb -0x23b5758(%rip),%xmm13        # a1bb80 <fast_operand_complex_class+0xdf8>
 2dd12d8:	vbroadcasti32x4 -0x23b6f22(%rip),%zmm14        # a1a3c0 <switch.table.ir_if_convert_test_reload+0x1d8>
 2dd12e2:	vbroadcasti32x4 -0x23b6f1c(%rip),%zmm15        # a1a3d0 <switch.table.ir_if_convert_test_reload+0x1e8>
 2dd12ec:	vbroadcasti32x4 -0x23b6f16(%rip),%zmm16        # a1a3e0 <switch.table.ir_if_convert_test_reload+0x1f8>
 2dd12f6:	lea    -0x23aa215(%rip),%rax        # a270e8 <fast_cc_binary_questioned.range_narrow+0x29a8>
 2dd12fd:	mov    %rdi,0x20(%rsp)
 2dd1302:	mov    %rcx,0x40(%rsp)
 2dd1307:	mov    %r11d,0x4(%rsp)
 2dd130c:	movq   $0x0,0x58(%rsp)
 2dd1315:	movq   $0x0,0x78(%rsp)
 2dd131e:	movq   $0x0,0x90(%rsp)
 2dd132a:	movq   $0x0,0x10(%rsp)
 2dd1333:	xor    %r13d,%r13d
 2dd1336:	xor    %edi,%edi
 2dd1338:	xor    %r12d,%r12d
 2dd133b:	mov    %rbp,0x8(%rsp)
 2dd1340:	mov    %rax,0xa0(%rsp)
 2dd1348:	xor    %eax,%eax
 2dd134a:	nopw   0x0(%rax,%rax,1)
 2dd1350:	mov    %rsi,%r11
 2dd1353:	sub    %rbp,%r11
 2dd1356:	mov    %rax,0x28(%rsp)
 2dd135b:	mov    %r12,0x30(%rsp)
 2dd1360:	mov    %rbp,0x70(%rsp)
 2dd1365:	mov    %r13,0x60(%rsp)
 2dd136a:	mov    %rdi,%rcx
 2dd136d:	mov    %rbx,%rsi
 2dd1370:	cmp    $0x40,%r11
 2dd1374:	jb     2dd14d4 <fast_pp_skip_inactive+0x10f4>
 2dd137a:	vmovdqu64 0x0(%rbp),%zmm0
 2dd1381:	mov    $0x40,%r11d
 2dd1387:	vpcmpeqb %zmm2,%zmm0,%k0
 2dd138d:	vpcmpeqb %zmm5,%zmm0,%k1
 2dd1393:	mov    $0xffffffffffffffff,%rax
 2dd139a:	vpaddb %zmm10,%zmm0,%zmm1
 2dd13a0:	vpcmpeqb %zmm7,%zmm0,%k2
 2dd13a6:	xor    %ebp,%ebp
 2dd13a8:	kmovq  %k0,%r8
 2dd13ad:	vpcmpeqb %zmm3,%zmm0,%k0
 2dd13b3:	bzhi   %r11,%rax,%rbx
 2dd13b8:	vpcmpltub %zmm11,%zmm1,%k3
 2dd13bf:	kmovq  %k0,%rdx
 2dd13c4:	vpcmpeqb %zmm4,%zmm0,%k0
 2dd13ca:	kmovq  %k3,%rdi
 2dd13cf:	mov    %rbx,%r10
 2dd13d2:	not    %r10
 2dd13d5:	mov    %r8,%r9
 2dd13d8:	not    %r9
 2dd13db:	korq   %k0,%k1,%k1
 2dd13e0:	kmovq  %k0,%r14
 2dd13e5:	vpcmpeqb %zmm6,%zmm0,%k0
 2dd13eb:	andn   %rdi,%r8,%rdi
 2dd13f0:	korq   %k2,%k0,%k0
 2dd13f5:	vpcmpeqb %zmm9,%zmm0,%k2
 2dd13fb:	kmovq  %k2,%rax
 2dd1400:	kmovq  %k0,%r15
 2dd1405:	vpcmpeqb %zmm8,%zmm0,%k0
 2dd140b:	or     %rax,%r10
 2dd140e:	lea    (%r8,%r8,1),%rax
 2dd1412:	kmovq  %k0,%r13
 2dd1417:	or     %rdi,%r10
 2dd141a:	or     %rsi,%rax
 2dd141d:	lea    0x0(%r13,%r13,1),%rsi
 2dd1422:	mov    %r10,%r12
 2dd1425:	and    %rax,%r12
 2dd1428:	add    %r10,%r12
 2dd142b:	setb   %dil
 2dd142f:	or     %rax,%r12
 2dd1432:	lea    (%r14,%r14,1),%rax
 2dd1436:	or     0x60(%rsp),%rsi
 2dd143b:	or     %rcx,%rax
 2dd143e:	mov    0x10(%rsp),%rcx
 2dd1443:	andn   %r12,%r10,%r12
 2dd1448:	kmovq  %k1,%r10
 2dd144d:	and    %r10,%rax
 2dd1450:	or     %rsi,%r9
 2dd1453:	add    $0xff,%cl
 2dd1456:	adc    %r9,%r15
 2dd1459:	setb   %cl
 2dd145c:	and    %r12,%rdx
 2dd145f:	or     %rdx,%rax
 2dd1462:	mov    %rcx,0x10(%rsp)
 2dd1467:	mov    %rax,%r10
 2dd146a:	and    %rbx,%r10
 2dd146d:	mov    %r10,%rcx
 2dd1470:	or     %rsi,%rcx
 2dd1473:	jne    2dd14f4 <fast_pp_skip_inactive+0x1114>
 2dd1475:	andn   %r9,%r15,%rcx
 2dd147a:	test   %r10,%r10
 2dd147d:	jne    2dd152f <fast_pp_skip_inactive+0x114f>
 2dd1483:	popcnt %r8,%rax
 2dd1488:	mov    %dil,%bpl
 2dd148b:	shr    $0x3f,%r8
 2dd148f:	mov    0x18(%rsp),%rsi
 2dd1494:	shr    $0x3f,%r14
 2dd1498:	shr    $0x3f,%rcx
 2dd149c:	shr    $0x3f,%r13
 2dd14a0:	shr    $0x3f,%r12
 2dd14a4:	xor    %edx,%edx
 2dd14a6:	add    %eax,0x4(%rsp)
 2dd14aa:	or     %rbp,%r8
 2dd14ad:	mov    0x70(%rsp),%rbp
 2dd14b2:	mov    %rcx,%rax
 2dd14b5:	mov    %r14,%rdi
 2dd14b8:	mov    %r8,%rbx
 2dd14bb:	add    %r11,%rbp
 2dd14be:	cmp    %rsi,%rbp
 2dd14c1:	jae    2dd1f3d <fast_pp_skip_inactive+0x1b5d>
 2dd14c7:	test   %dl,%dl
 2dd14c9:	je     2dd1350 <fast_pp_skip_inactive+0xf70>
 2dd14cf:	jmp    2dd1f3d <fast_pp_skip_inactive+0x1b5d>
 2dd14d4:	mov    $0xffffffffffffffff,%rax
 2dd14db:	shlx   %r11,%rax,%rax
 2dd14e0:	not    %rax
 2dd14e3:	kmovq  %rax,%k1
 2dd14e8:	vmovdqu8 0x0(%rbp),%zmm0{%k1}{z}
 2dd14ef:	jmp    2dd1387 <fast_pp_skip_inactive+0xfa7>
 2dd14f4:	vpandq %zmm14,%zmm0,%zmm1
 2dd14fa:	vpcmpeqb %zmm16,%zmm0,%k2
 2dd1500:	vpcmpeqb %zmm15,%zmm1,%k1
 2dd1506:	korq   %k2,%k0,%k0
 2dd150b:	korq   %k1,%k0,%k0
 2dd1510:	kmovq  %k0,%rcx
 2dd1515:	and    %rcx,%rsi
 2dd1518:	or     %rax,%rsi
 2dd151b:	and    %rbx,%rsi
 2dd151e:	mov    %rsi,%r10
 2dd1521:	andn   %r9,%r15,%rcx
 2dd1526:	test   %r10,%r10
 2dd1529:	je     2dd1483 <fast_pp_skip_inactive+0x10a3>
 2dd152f:	xor    %r13d,%r13d
 2dd1532:	tzcnt  %r10,%r13
 2dd1537:	bt     %r13,%rdx
 2dd153b:	jae    2dd1553 <fast_pp_skip_inactive+0x1173>
 2dd153d:	mov    0x4(%rsp),%r10d
 2dd1542:	mov    0x70(%rsp),%r15
 2dd1547:	shrx   %r13,%rcx,%rsi
 2dd154c:	mov    $0x1,%bl
 2dd154e:	and    $0x1,%esi
 2dd1551:	jmp    2dd1593 <fast_pp_skip_inactive+0x11b3>
 2dd1553:	mov    $0xffffffff,%esi
 2dd1558:	mov    0x4(%rsp),%r10d
 2dd155d:	mov    0x70(%rsp),%r15
 2dd1562:	mov    0x30(%rsp),%r9
 2dd1567:	add    %r13d,%esi
 2dd156a:	shrx   %rsi,%r12,%rdi
 2dd156f:	and    $0x1,%edi
 2dd1572:	test   %r13,%r13
 2dd1575:	cmovne %edi,%r9d
 2dd1579:	test   %r9d,%r9d
 2dd157c:	setne  %bl
 2dd157f:	test   %r13,%r13
 2dd1582:	je     2dd158e <fast_pp_skip_inactive+0x11ae>
 2dd1584:	shrx   %rsi,%rcx,%rsi
 2dd1589:	and    $0x1,%esi
 2dd158c:	jmp    2dd1593 <fast_pp_skip_inactive+0x11b3>
 2dd158e:	mov    0x28(%rsp),%rsi
 2dd1593:	mov    $0xffffffffffffffff,%r9
 2dd159a:	shrx   %r13,%rdx,%rcx
 2dd159f:	lea    (%r15,%r13,1),%rdx
 2dd15a3:	bzhi   %r13,%r9,%r9
 2dd15a8:	mov    %rcx,%rdi
 2dd15ab:	or     $0xfffffffffffffffe,%rdi
 2dd15af:	and    %r8,%r9
 2dd15b2:	lea    (%rdx,%rdi,1),%rbp
 2dd15b6:	popcnt %r9,%r8
 2dd15bb:	add    %r8d,%r10d
 2dd15be:	mov    %r10d,0x4(%rsp)
 2dd15c3:	test   %esi,%esi
 2dd15c5:	jne    2dd1b28 <fast_pp_skip_inactive+0x1748>
 2dd15cb:	test   $0x1,%cl
 2dd15ce:	je     2dd1622 <fast_pp_skip_inactive+0x1242>
 2dd15d0:	mov    0x18(%rsp),%rbx
 2dd15d5:	add    $0x2,%rbp
 2dd15d9:	mov    %rbp,%rdi
 2dd15dc:	mov    %rbx,%rsi
 2dd15df:	vzeroupper
 2dd15e2:	call   45db6d0 <fast_skip_hspace>
 2dd15e7:	mov    %rbx,%rsi
 2dd15ea:	cmp    %rbx,%rax
 2dd15ed:	jae    2dd1603 <fast_pp_skip_inactive+0x1223>
 2dd15ef:	movzbl (%rax),%ebx
 2dd15f2:	lea    -0x23b37f9(%rip),%rcx        # a1de00 <fast_char_class>
 2dd15f9:	testb  $0x2,(%rbx,%rcx,1)
 2dd15fd:	jne    2dd184c <fast_pp_skip_inactive+0x146c>
 2dd1603:	xor    %edx,%edx
 2dd1605:	xor    %edi,%edi
 2dd1607:	xor    %r13d,%r13d
 2dd160a:	movq   $0x0,0x10(%rsp)
 2dd1613:	xor    %ebx,%ebx
 2dd1615:	mov    %rax,0x8(%rsp)
 2dd161a:	mov    %rax,%rbp
 2dd161d:	jmp    2dd19eb <fast_pp_skip_inactive+0x160b>
 2dd1622:	mov    0x18(%rsp),%rsi
 2dd1627:	mov    $0x1,%ecx
 2dd162c:	shlx   %r13,%rcx,%rcx
 2dd1631:	test   %rax,%rcx
 2dd1634:	je     2dd1688 <fast_pp_skip_inactive+0x12a8>
 2dd1636:	movl   $0x0,0x80(%rsp)
 2dd1641:	mov    0x20(%rsp),%r14
 2dd1646:	lea    0x3(%rbp),%rdi
 2dd164a:	cmpb   $0x2a,0x2(%rbp)
 2dd164e:	jne    2dd1774 <fast_pp_skip_inactive+0x1394>
 2dd1654:	lea    0x80(%rsp),%rdx
 2dd165c:	vzeroupper
 2dd165f:	call   45dd2e0 <fast_skip_block_comment>
 2dd1664:	test   %rax,%rax
 2dd1667:	jne    2dd1784 <fast_pp_skip_inactive+0x13a4>
 2dd166d:	lea    -0x23aa530(%rip),%rsi        # a27144 <fast_cc_binary_questioned.range_narrow+0x2a04>
 2dd1674:	mov    %r14,%rdi
 2dd1677:	call   45da9f9 <fast_pp_bail>
 2dd167c:	mov    0x18(%rsp),%rbp
 2dd1681:	mov    $0x1,%dl
 2dd1683:	jmp    2dd1789 <fast_pp_skip_inactive+0x13a9>
 2dd1688:	add    $0x2,%rbp
 2dd168c:	mov    %rbp,%rdi
 2dd168f:	vzeroupper
 2dd1692:	call   45df0d0 <fast_skip_splices>
 2dd1697:	mov    0x18(%rsp),%rsi
 2dd169c:	cmp    %rsi,%rax
 2dd169f:	jae    2dd188e <fast_pp_skip_inactive+0x14ae>
 2dd16a5:	vbroadcasti32x4 -0x23b73af(%rip),%zmm2        # a1a300 <switch.table.ir_if_convert_test_reload+0x118>
 2dd16af:	vbroadcasti32x4 -0x23b7399(%rip),%zmm3        # a1a320 <switch.table.ir_if_convert_test_reload+0x138>
 2dd16b9:	vbroadcasti32x4 -0x23b7393(%rip),%zmm4        # a1a330 <switch.table.ir_if_convert_test_reload+0x148>
 2dd16c3:	vbroadcasti32x4 -0x23b738d(%rip),%zmm5        # a1a340 <switch.table.ir_if_convert_test_reload+0x158>
 2dd16cd:	vbroadcasti32x4 -0x23b7387(%rip),%zmm6        # a1a350 <switch.table.ir_if_convert_test_reload+0x168>
 2dd16d7:	vbroadcasti32x4 -0x23b7381(%rip),%zmm7        # a1a360 <switch.table.ir_if_convert_test_reload+0x178>
 2dd16e1:	vbroadcasti32x4 -0x23b737b(%rip),%zmm8        # a1a370 <switch.table.ir_if_convert_test_reload+0x188>
 2dd16eb:	vbroadcasti32x4 -0x23b7375(%rip),%zmm9        # a1a380 <switch.table.ir_if_convert_test_reload+0x198>
 2dd16f5:	vbroadcasti32x4 -0x23b736f(%rip),%zmm10        # a1a390 <switch.table.ir_if_convert_test_reload+0x1a8>
 2dd16ff:	vbroadcasti32x4 -0x23b7369(%rip),%zmm11        # a1a3a0 <switch.table.ir_if_convert_test_reload+0x1b8>
 2dd1709:	vpbroadcastb -0x23b5b92(%rip),%xmm12        # a1bb80 <fast_operand_complex_class+0xdf8>
 2dd1712:	vpbroadcastb -0x23b5b9b(%rip),%xmm13        # a1bb80 <fast_operand_complex_class+0xdf8>
 2dd171b:	vbroadcasti32x4 -0x23b7365(%rip),%zmm14        # a1a3c0 <switch.table.ir_if_convert_test_reload+0x1d8>
 2dd1725:	vbroadcasti32x4 -0x23b735f(%rip),%zmm15        # a1a3d0 <switch.table.ir_if_convert_test_reload+0x1e8>
 2dd172f:	vbroadcasti32x4 -0x23b7359(%rip),%zmm16        # a1a3e0 <switch.table.ir_if_convert_test_reload+0x1f8>
 2dd1739:	movzbl (%rax),%eax
 2dd173c:	xor    %edi,%edi
 2dd173e:	movq   $0x0,0x10(%rsp)
 2dd1747:	xor    %edx,%edx
 2dd1749:	add    $0xffffffb2,%eax
 2dd174c:	cmp    $0x27,%eax
 2dd174f:	ja     2dd1765 <fast_pp_skip_inactive+0x1385>
 2dd1751:	movabs $0x8000000081,%rcx
 2dd175b:	bt     %rax,%rcx
 2dd175f:	jb     2dd1f12 <fast_pp_skip_inactive+0x1b32>
 2dd1765:	mov    %rbp,0x8(%rsp)
 2dd176a:	xor    %r13d,%r13d
 2dd176d:	xor    %ebx,%ebx
 2dd176f:	jmp    2dd1a7f <fast_pp_skip_inactive+0x169f>
 2dd1774:	lea    0x80(%rsp),%rdx
 2dd177c:	vzeroupper
 2dd177f:	call   45dd3d0 <fast_skip_line_comment>
 2dd1784:	mov    %rax,%rbp
 2dd1787:	xor    %edx,%edx
 2dd1789:	vbroadcasti32x4 -0x23b7493(%rip),%zmm2        # a1a300 <switch.table.ir_if_convert_test_reload+0x118>
 2dd1793:	vbroadcasti32x4 -0x23b747d(%rip),%zmm3        # a1a320 <switch.table.ir_if_convert_test_reload+0x138>
 2dd179d:	vbroadcasti32x4 -0x23b7477(%rip),%zmm4        # a1a330 <switch.table.ir_if_convert_test_reload+0x148>
 2dd17a7:	vbroadcasti32x4 -0x23b7471(%rip),%zmm5        # a1a340 <switch.table.ir_if_convert_test_reload+0x158>
 2dd17b1:	vbroadcasti32x4 -0x23b746b(%rip),%zmm6        # a1a350 <switch.table.ir_if_convert_test_reload+0x168>
 2dd17bb:	vbroadcasti32x4 -0x23b7465(%rip),%zmm7        # a1a360 <switch.table.ir_if_convert_test_reload+0x178>
 2dd17c5:	vbroadcasti32x4 -0x23b745f(%rip),%zmm8        # a1a370 <switch.table.ir_if_convert_test_reload+0x188>
 2dd17cf:	vbroadcasti32x4 -0x23b7459(%rip),%zmm9        # a1a380 <switch.table.ir_if_convert_test_reload+0x198>
 2dd17d9:	vbroadcasti32x4 -0x23b7453(%rip),%zmm10        # a1a390 <switch.table.ir_if_convert_test_reload+0x1a8>
 2dd17e3:	vbroadcasti32x4 -0x23b744d(%rip),%zmm11        # a1a3a0 <switch.table.ir_if_convert_test_reload+0x1b8>
 2dd17ed:	vpbroadcastb -0x23b5c76(%rip),%xmm12        # a1bb80 <fast_operand_complex_class+0xdf8>
 2dd17f6:	vpbroadcastb -0x23b5c7f(%rip),%xmm13        # a1bb80 <fast_operand_complex_class+0xdf8>
 2dd17ff:	vbroadcasti32x4 -0x23b7449(%rip),%zmm14        # a1a3c0 <switch.table.ir_if_convert_test_reload+0x1d8>
 2dd1809:	vbroadcasti32x4 -0x23b7443(%rip),%zmm15        # a1a3d0 <switch.table.ir_if_convert_test_reload+0x1e8>
 2dd1813:	vbroadcasti32x4 -0x23b743d(%rip),%zmm16        # a1a3e0 <switch.table.ir_if_convert_test_reload+0x1f8>
 2dd181d:	mov    0x4(%rsp),%ecx
 2dd1821:	mov    0x18(%rsp),%rsi
 2dd1826:	movzbl %bl,%ebx
 2dd1829:	xor    %edi,%edi
 2dd182b:	xor    %r13d,%r13d
 2dd182e:	movq   $0x0,0x10(%rsp)
 2dd1837:	mov    %rbp,0x8(%rsp)
 2dd183c:	add    0x80(%rsp),%ecx
 2dd1843:	mov    %ecx,0x4(%rsp)
 2dd1847:	jmp    2dd1a7f <fast_pp_skip_inactive+0x169f>
 2dd184c:	mov    %rax,%rdi
 2dd184f:	mov    %rax,%r14
 2dd1852:	call   45ddb30 <fast_scan_ident_len>
 2dd1857:	lea    -0x2(%rax),%ecx
 2dd185a:	mov    %r14,%rsi
 2dd185d:	cmp    $0x6,%ecx
 2dd1860:	ja     2dd19c7 <fast_pp_skip_inactive+0x15e7>
 2dd1866:	lea    -0x23ad51d(%rip),%rdx        # a24350 <c_direct_test_dependencies.levels+0x73>
 2dd186d:	movslq (%rdx,%rcx,4),%rcx
 2dd1871:	add    %rdx,%rcx
 2dd1874:	jmp    *%rcx
 2dd1876:	cmp    $0x69,%bl
 2dd1879:	jne    2dd19c7 <fast_pp_skip_inactive+0x15e7>
 2dd187f:	cmpb   $0x66,0x1(%rsi)
 2dd1883:	je     2dd196e <fast_pp_skip_inactive+0x158e>
 2dd1889:	jmp    2dd19c7 <fast_pp_skip_inactive+0x15e7>
 2dd188e:	xor    %edx,%edx
 2dd1890:	mov    %rbp,0x8(%rsp)
 2dd1895:	xor    %edi,%edi
 2dd1897:	xor    %r13d,%r13d
 2dd189a:	movq   $0x0,0x10(%rsp)
 2dd18a3:	xor    %ebx,%ebx
 2dd18a5:	jmp    2dd19eb <fast_pp_skip_inactive+0x160b>
 2dd18aa:	movzbl 0x4(%rsi),%edi
 2dd18ae:	mov    (%rsi),%ecx
 2dd18b0:	mov    $0x65646669,%edx
 2dd18b5:	xor    %edx,%ecx
 2dd18b7:	xor    $0x66,%edi
 2dd18ba:	or     %ecx,%edi
 2dd18bc:	je     2dd196e <fast_pp_skip_inactive+0x158e>
 2dd18c2:	movzbl 0x4(%rsi),%edi
 2dd18c6:	mov    (%rsi),%ecx
 2dd18c8:	mov    $0x69646e65,%edx
 2dd18cd:	xor    %edx,%ecx
 2dd18cf:	xor    $0x66,%edi
 2dd18d2:	or     %ecx,%edi
 2dd18d4:	jne    2dd19c7 <fast_pp_skip_inactive+0x15e7>
 2dd18da:	add    $0x5,%rsi
 2dd18de:	cmpl   $0x0,0x78(%rsp)
 2dd18e3:	mov    %rsi,0x8(%rsp)
 2dd18e8:	je     2dd1ff3 <fast_pp_skip_inactive+0x1c13>
 2dd18ee:	mov    0x78(%rsp),%rax
 2dd18f3:	mov    0x8(%rsp),%rbp
 2dd18f8:	xor    %edx,%edx
 2dd18fa:	xor    %edi,%edi
 2dd18fc:	xor    %r13d,%r13d
 2dd18ff:	movq   $0x0,0x10(%rsp)
 2dd1908:	xor    %ebx,%ebx
 2dd190a:	dec    %eax
 2dd190c:	mov    %rax,0x78(%rsp)
 2dd1911:	jmp    2dd19e6 <fast_pp_skip_inactive+0x1606>
 2dd1916:	movabs $0x6665646e66696c65,%rcx
 2dd1920:	cmp    %rcx,(%rsi)
 2dd1923:	jne    2dd19c7 <fast_pp_skip_inactive+0x15e7>
 2dd1929:	mov    $0x32,%r14b
 2dd192c:	mov    %rsi,%rbp
 2dd192f:	jmp    2dd1aa9 <fast_pp_skip_inactive+0x16c9>
 2dd1934:	cmpl   $0x65736c65,(%rsi)
 2dd193a:	mov    %rsi,%rbp
 2dd193d:	je     2dd1a97 <fast_pp_skip_inactive+0x16b7>
 2dd1943:	cmpl   $0x66696c65,0x0(%rbp)
 2dd194a:	mov    %rbp,%rsi
 2dd194d:	jne    2dd19c7 <fast_pp_skip_inactive+0x15e7>
 2dd194f:	mov    $0x4,%r14b
 2dd1952:	jmp    2dd1ac4 <fast_pp_skip_inactive+0x16e4>
 2dd1957:	movzwl 0x4(%rsi),%edi
 2dd195b:	mov    (%rsi),%ecx
 2dd195d:	mov    $0x646e6669,%edx
 2dd1962:	xor    %edx,%ecx
 2dd1964:	xor    $0x6665,%edi
 2dd196a:	or     %ecx,%edi
 2dd196c:	jne    2dd19c7 <fast_pp_skip_inactive+0x15e7>
 2dd196e:	mov    0x78(%rsp),%rdx
 2dd1973:	mov    0x58(%rsp),%rcx
 2dd1978:	mov    %eax,%eax
 2dd197a:	add    %rax,%rsi
 2dd197d:	xor    %eax,%eax
 2dd197f:	inc    %edx
 2dd1981:	cmp    $0x40,%edx
 2dd1984:	mov    %rdx,0x78(%rsp)
 2dd1989:	setae  %al
 2dd198c:	or     %eax,%ecx
 2dd198e:	mov    %rcx,0x58(%rsp)
 2dd1993:	mov    0x90(%rsp),%rcx
 2dd199b:	btr    %rdx,%rcx
 2dd199f:	mov    %rcx,0x90(%rsp)
 2dd19a7:	jmp    2dd19cc <fast_pp_skip_inactive+0x15ec>
 2dd19a9:	mov    (%rsi),%ecx
 2dd19ab:	mov    0x3(%rsi),%r8d
 2dd19af:	mov    $0x66696c65,%edx
 2dd19b4:	mov    $0x66656466,%edi
 2dd19b9:	xor    %edx,%ecx
 2dd19bb:	xor    %edi,%r8d
 2dd19be:	or     %ecx,%r8d
 2dd19c1:	je     2dd1aa3 <fast_pp_skip_inactive+0x16c3>
 2dd19c7:	mov    %eax,%eax
 2dd19c9:	add    %rax,%rsi
 2dd19cc:	xor    %edx,%edx
 2dd19ce:	xor    %edi,%edi
 2dd19d0:	xor    %r13d,%r13d
 2dd19d3:	movq   $0x0,0x10(%rsp)
 2dd19dc:	xor    %ebx,%ebx
 2dd19de:	mov    %rsi,%rbp
 2dd19e1:	mov    %rsi,0x8(%rsp)
 2dd19e6:	mov    0x18(%rsp),%rsi
 2dd19eb:	vbroadcasti32x4 -0x23b76f5(%rip),%zmm2        # a1a300 <switch.table.ir_if_convert_test_reload+0x118>
 2dd19f5:	vbroadcasti32x4 -0x23b76df(%rip),%zmm3        # a1a320 <switch.table.ir_if_convert_test_reload+0x138>
 2dd19ff:	vbroadcasti32x4 -0x23b76d9(%rip),%zmm4        # a1a330 <switch.table.ir_if_convert_test_reload+0x148>
 2dd1a09:	vbroadcasti32x4 -0x23b76d3(%rip),%zmm5        # a1a340 <switch.table.ir_if_convert_test_reload+0x158>
 2dd1a13:	vbroadcasti32x4 -0x23b76cd(%rip),%zmm6        # a1a350 <switch.table.ir_if_convert_test_reload+0x168>
 2dd1a1d:	vbroadcasti32x4 -0x23b76c7(%rip),%zmm7        # a1a360 <switch.table.ir_if_convert_test_reload+0x178>
 2dd1a27:	vbroadcasti32x4 -0x23b76c1(%rip),%zmm8        # a1a370 <switch.table.ir_if_convert_test_reload+0x188>
 2dd1a31:	vbroadcasti32x4 -0x23b76bb(%rip),%zmm9        # a1a380 <switch.table.ir_if_convert_test_reload+0x198>
 2dd1a3b:	vbroadcasti32x4 -0x23b76b5(%rip),%zmm10        # a1a390 <switch.table.ir_if_convert_test_reload+0x1a8>
 2dd1a45:	vbroadcasti32x4 -0x23b76af(%rip),%zmm11        # a1a3a0 <switch.table.ir_if_convert_test_reload+0x1b8>
 2dd1a4f:	vpbroadcastb -0x23b5ed8(%rip),%xmm12        # a1bb80 <fast_operand_complex_class+0xdf8>
 2dd1a58:	vpbroadcastb -0x23b5ee1(%rip),%xmm13        # a1bb80 <fast_operand_complex_class+0xdf8>
 2dd1a61:	vbroadcasti32x4 -0x23b76ab(%rip),%zmm14        # a1a3c0 <switch.table.ir_if_convert_test_reload+0x1d8>
 2dd1a6b:	vbroadcasti32x4 -0x23b76a5(%rip),%zmm15        # a1a3d0 <switch.table.ir_if_convert_test_reload+0x1e8>
 2dd1a75:	vbroadcasti32x4 -0x23b769f(%rip),%zmm16        # a1a3e0 <switch.table.ir_if_convert_test_reload+0x1f8>
 2dd1a7f:	mov    0x30(%rsp),%r12
 2dd1a84:	mov    0x28(%rsp),%rax
 2dd1a89:	cmp    %rsi,%rbp
 2dd1a8c:	jb     2dd14c7 <fast_pp_skip_inactive+0x10e7>
 2dd1a92:	jmp    2dd1f3d <fast_pp_skip_inactive+0x1b5d>
 2dd1a97:	mov    $0xffffffffffffffff,%rcx
 2dd1a9e:	mov    $0x5,%r14b
 2dd1aa1:	jmp    2dd1ac6 <fast_pp_skip_inactive+0x16e6>
 2dd1aa3:	mov    %rsi,%rbp
 2dd1aa6:	mov    $0x31,%r14b
 2dd1aa9:	mov    0x20(%rsp),%rcx
 2dd1aae:	mov    0x58(%rsp),%rsi
 2dd1ab3:	movzbl 0xe979(%rcx),%ecx
 2dd1aba:	xor    $0x1,%ecx
 2dd1abd:	or     %ecx,%esi
 2dd1abf:	mov    %rsi,0x58(%rsp)
 2dd1ac4:	xor    %ecx,%ecx
 2dd1ac6:	mov    0x78(%rsp),%rdx
 2dd1acb:	mov    %eax,%eax
 2dd1acd:	add    %rax,%rbp
 2dd1ad0:	mov    %rbp,0x8(%rsp)
 2dd1ad5:	test   %edx,%edx
 2dd1ad7:	je     2dd1ff6 <fast_pp_skip_inactive+0x1c16>
 2dd1add:	mov    0x90(%rsp),%rdi
 2dd1ae5:	mov    $0x1,%eax
 2dd1aea:	xor    %r13d,%r13d
 2dd1aed:	movq   $0x0,0x10(%rsp)
 2dd1af6:	xor    %ebx,%ebx
 2dd1af8:	shlx   %rdx,%rax,%rax
 2dd1afd:	and    %rax,%rcx
 2dd1b00:	shrx   %rdx,%rdi,%rax
 2dd1b05:	mov    0x58(%rsp),%rdx
 2dd1b0a:	or     %rcx,%rdi
 2dd1b0d:	and    $0x1,%eax
 2dd1b10:	mov    %rdi,0x90(%rsp)
 2dd1b18:	xor    %edi,%edi
 2dd1b1a:	or     %eax,%edx
 2dd1b1c:	mov    %rdx,0x58(%rsp)
 2dd1b21:	xor    %edx,%edx
 2dd1b23:	jmp    2dd19e6 <fast_pp_skip_inactive+0x1606>
 2dd1b28:	lea    0x1(%rdi,%rdx,1),%r12
 2dd1b2d:	cmp    0x8(%rsp),%r12
 2dd1b32:	jbe    2dd15cb <fast_pp_skip_inactive+0x11eb>
 2dd1b38:	vmovdqa64 %zmm2,%zmm5
 2dd1b3e:	xor    %edx,%edx
 2dd1b40:	jmp    2dd1b51 <fast_pp_skip_inactive+0x1771>
 2dd1b42:	dec    %rdx
 2dd1b45:	lea    0x1(%rbp,%rdx,1),%rsi
 2dd1b4a:	cmp    0x8(%rsp),%rsi
 2dd1b4f:	jbe    2dd1b6b <fast_pp_skip_inactive+0x178b>
 2dd1b51:	cmpb   $0xa,0x0(%rbp,%rdx,1)
 2dd1b56:	jne    2dd1b42 <fast_pp_skip_inactive+0x1762>
 2dd1b58:	lea    0x0(%rbp,%rdx,1),%rsi
 2dd1b5d:	cmp    0x8(%rsp),%rsi
 2dd1b62:	jbe    2dd1b6b <fast_pp_skip_inactive+0x178b>
 2dd1b64:	cmpb   $0x5c,-0x1(%rbp,%rdx,1)
 2dd1b69:	je     2dd1b42 <fast_pp_skip_inactive+0x1762>
 2dd1b6b:	test   %rdx,%rdx
 2dd1b6e:	jns    2dd15cb <fast_pp_skip_inactive+0x11eb>
 2dd1b74:	mov    %r13,%r9
 2dd1b77:	add    %rdx,%r9
 2dd1b7a:	mov    %rdx,%rsi
 2dd1b7d:	neg    %rsi
 2dd1b80:	xor    %r8d,%r8d
 2dd1b83:	add    %rdi,%r9
 2dd1b86:	mov    %rsi,%r11
 2dd1b89:	lea    (%r15,%r9,1),%rdi
 2dd1b8d:	lea    0x31(%r15,%r9,1),%r14
 2dd1b92:	mov    %r9,0x60(%rsp)
 2dd1b97:	lea    0x1(%r15,%r9,1),%r9
 2dd1b9c:	mov    %rdi,0x10(%rsp)
 2dd1ba1:	mov    0x10(%rsp),%rdi
 2dd1ba6:	movzbl 0x1(%rdi,%r8,1),%r10d
 2dd1bac:	cmp    $0x22,%r10d
 2dd1bb0:	je     2dd1bce <fast_pp_skip_inactive+0x17ee>
 2dd1bb2:	cmp    $0x27,%r10d
 2dd1bb6:	je     2dd1bce <fast_pp_skip_inactive+0x17ee>
 2dd1bb8:	inc    %r8
 2dd1bbb:	dec    %r11
 2dd1bbe:	inc    %r14
 2dd1bc1:	inc    %r9
 2dd1bc4:	cmp    %r8,%rsi
 2dd1bc7:	jne    2dd1ba1 <fast_pp_skip_inactive+0x17c1>
 2dd1bc9:	jmp    2dd15cb <fast_pp_skip_inactive+0x11eb>
 2dd1bce:	mov    0x10(%rsp),%rax
 2dd1bd3:	lea    0x1(%r8,%rax,1),%rsi
 2dd1bd8:	cmp    $0x27,%r10b
 2dd1bdc:	jne    2dd1c11 <fast_pp_skip_inactive+0x1831>
 2dd1bde:	mov    0x20(%rsp),%rax
 2dd1be3:	cmpb   $0x0,0xe979(%rax)
 2dd1bea:	je     2dd1c11 <fast_pp_skip_inactive+0x1831>
 2dd1bec:	mov    0x40(%rsp),%rax
 2dd1bf1:	cmp    (%rax),%rsi
 2dd1bf4:	jbe    2dd1c11 <fast_pp_skip_inactive+0x1831>
 2dd1bf6:	mov    0x10(%rsp),%rax
 2dd1bfb:	lea    -0x23b3e02(%rip),%rcx        # a1de00 <fast_char_class>
 2dd1c02:	movzbl (%r8,%rax,1),%eax
 2dd1c07:	testb  $0x1,(%rax,%rcx,1)
 2dd1c0b:	jne    2dd1f21 <fast_pp_skip_inactive+0x1b41>
 2dd1c11:	cmp    %r12,%rsi
 2dd1c14:	jae    2dd1d8e <fast_pp_skip_inactive+0x19ae>
 2dd1c1a:	add    %r8,%rdx
 2dd1c1d:	neg    %rdx
 2dd1c20:	cmp    $0x8,%rdx
 2dd1c24:	jb     2dd1d75 <fast_pp_skip_inactive+0x1995>
 2dd1c2a:	cmp    $0x40,%rdx
 2dd1c2e:	jae    2dd1c37 <fast_pp_skip_inactive+0x1857>
 2dd1c30:	xor    %ecx,%ecx
 2dd1c32:	jmp    2dd1d09 <fast_pp_skip_inactive+0x1929>
 2dd1c37:	mov    %r11,%rdi
 2dd1c3a:	and    $0xffffffffffffffc0,%rdi
 2dd1c3e:	vmovd  0x4(%rsp),%xmm0
 2dd1c44:	mov    %rdx,%rcx
 2dd1c47:	and    $0xffffffffffffffc0,%rcx
 2dd1c4b:	vpxor  %xmm1,%xmm1,%xmm1
 2dd1c4f:	vpxor  %xmm2,%xmm2,%xmm2
 2dd1c53:	vpxor  %xmm3,%xmm3,%xmm3
 2dd1c57:	lea    (%r15,%rdi,1),%rax
 2dd1c5b:	add    0x60(%rsp),%rax
 2dd1c60:	lea    0x1(%r8,%rax,1),%rsi
 2dd1c65:	vpcmpeqb -0x30(%r14),%xmm13,%k0
 2dd1c6c:	vpcmpeqb -0x20(%r14),%xmm13,%k1
 2dd1c73:	vpcmpeqb -0x10(%r14),%xmm13,%k2
 2dd1c7a:	vpcmpeqb (%r14),%xmm13,%k3
 2dd1c80:	add    $0x40,%r14
 2dd1c84:	add    $0xffffffffffffffc0,%rdi
 2dd1c88:	vpmovm2d %k0,%zmm4
 2dd1c8e:	vpaddd %zmm4,%zmm0,%zmm0
 2dd1c94:	vpmovm2d %k1,%zmm4
 2dd1c9a:	vpaddd %zmm4,%zmm1,%zmm1
 2dd1ca0:	vpmovm2d %k2,%zmm4
 2dd1ca6:	vpaddd %zmm4,%zmm2,%zmm2
 2dd1cac:	vpmovm2d %k3,%zmm4
 2dd1cb2:	vpaddd %zmm4,%zmm3,%zmm3
 2dd1cb8:	jne    2dd1c65 <fast_pp_skip_inactive+0x1885>
 2dd1cba:	vpaddd %zmm0,%zmm1,%zmm0
 2dd1cc0:	vpaddd %zmm0,%zmm2,%zmm0
 2dd1cc6:	vpaddd %zmm0,%zmm3,%zmm0
 2dd1ccc:	vextracti64x4 $0x1,%zmm0,%ymm1
 2dd1cd3:	vpaddd %zmm1,%zmm0,%zmm0
 2dd1cd9:	vextracti128 $0x1,%ymm0,%xmm1
 2dd1cdf:	vpaddd %xmm1,%xmm0,%xmm0
 2dd1ce3:	vpshufd $0xee,%xmm0,%xmm1
 2dd1ce8:	vpaddd %xmm1,%xmm0,%xmm0
 2dd1cec:	vpshufd $0x55,%xmm0,%xmm1
 2dd1cf1:	vpaddd %xmm1,%xmm0,%xmm0
 2dd1cf5:	vmovd  %xmm0,0x4(%rsp)
 2dd1cfb:	cmp    %rcx,%rdx
 2dd1cfe:	je     2dd1d8e <fast_pp_skip_inactive+0x19ae>
 2dd1d04:	test   $0x38,%dl
 2dd1d07:	je     2dd1d75 <fast_pp_skip_inactive+0x1995>
 2dd1d09:	and    $0xfffffffffffffff8,%r11
 2dd1d0d:	vmovd  0x4(%rsp),%xmm0
 2dd1d13:	mov    %rdx,%rdi
 2dd1d16:	and    $0xfffffffffffffff8,%rdi
 2dd1d1a:	add    %rcx,%r9
 2dd1d1d:	add    %r11,%r15
 2dd1d20:	add    0x60(%rsp),%r15
 2dd1d25:	sub    %rcx,%r11
 2dd1d28:	xor    %ecx,%ecx
 2dd1d2a:	lea    0x1(%r8,%r15,1),%rsi
 2dd1d2f:	vmovq  (%r9,%rcx,1),%xmm1
 2dd1d35:	add    $0x8,%rcx
 2dd1d39:	vpcmpeqb %xmm12,%xmm1,%k0
 2dd1d3f:	vpmovm2d %k0,%ymm1
 2dd1d45:	vpaddd %ymm1,%ymm0,%ymm0
 2dd1d49:	cmp    %rcx,%r11
 2dd1d4c:	jne    2dd1d2f <fast_pp_skip_inactive+0x194f>
 2dd1d4e:	vextracti128 $0x1,%ymm0,%xmm1
 2dd1d54:	vpaddd %xmm1,%xmm0,%xmm0
 2dd1d58:	vpshufd $0xee,%xmm0,%xmm1
 2dd1d5d:	vpaddd %xmm1,%xmm0,%xmm0
 2dd1d61:	vpshufd $0x55,%xmm0,%xmm1
 2dd1d66:	vpaddd %xmm1,%xmm0,%xmm0
 2dd1d6a:	vmovd  %xmm0,0x4(%rsp)
 2dd1d70:	cmp    %rdi,%rdx
 2dd1d73:	je     2dd1d8e <fast_pp_skip_inactive+0x19ae>
 2dd1d75:	dec    %rsi
 2dd1d78:	xor    %eax,%eax
 2dd1d7a:	cmpb   $0xa,0x1(%rsi)
 2dd1d7e:	lea    0x1(%rsi),%rsi
 2dd1d82:	sete   %al
 2dd1d85:	sub    %eax,0x4(%rsp)
 2dd1d89:	cmp    %rbp,%rsi
 2dd1d8c:	jne    2dd1d78 <fast_pp_skip_inactive+0x1998>
 2dd1d8e:	mov    0x10(%rsp),%rax
 2dd1d93:	lea    0x2(%r8,%rax,1),%rax
 2dd1d98:	mov    %rax,0x8(%rsp)
 2dd1d9d:	cmp    0x18(%rsp),%rax
 2dd1da2:	jb     2dd1dd3 <fast_pp_skip_inactive+0x19f3>
 2dd1da4:	xor    %edx,%edx
 2dd1da6:	mov    0x8(%rsp),%rbp
 2dd1dab:	xor    %edi,%edi
 2dd1dad:	xor    %r13d,%r13d
 2dd1db0:	xor    %ebx,%ebx
 2dd1db2:	movq   $0x0,0x10(%rsp)
 2dd1dbb:	jmp    2dd1e36 <fast_pp_skip_inactive+0x1a56>
 2dd1dbd:	mov    0x8(%rsp),%rax
 2dd1dc2:	xor    %edx,%edx
 2dd1dc4:	add    %rcx,%rax
 2dd1dc7:	mov    %rax,0x8(%rsp)
 2dd1dcc:	cmp    0x18(%rsp),%rax
 2dd1dd1:	jae    2dd1da6 <fast_pp_skip_inactive+0x19c6>
 2dd1dd3:	mov    0x8(%rsp),%rax
 2dd1dd8:	movzbl (%rax),%eax
 2dd1ddb:	cmp    %r10b,%al
 2dd1dde:	je     2dd1e0f <fast_pp_skip_inactive+0x1a2f>
 2dd1de0:	cmp    $0xa,%al
 2dd1de2:	je     2dd1e0f <fast_pp_skip_inactive+0x1a2f>
 2dd1de4:	mov    $0x1,%ecx
 2dd1de9:	cmp    $0x5c,%al
 2dd1deb:	jne    2dd1dbd <fast_pp_skip_inactive+0x19dd>
 2dd1ded:	mov    0x8(%rsp),%rax
 2dd1df2:	inc    %rax
 2dd1df5:	cmp    0x18(%rsp),%rax
 2dd1dfa:	jae    2dd1dbd <fast_pp_skip_inactive+0x19dd>
 2dd1dfc:	xor    %ecx,%ecx
 2dd1dfe:	cmpb   $0xa,(%rax)
 2dd1e01:	sete   %cl
 2dd1e04:	add    %ecx,0x4(%rsp)
 2dd1e08:	mov    $0x2,%ecx
 2dd1e0d:	jmp    2dd1dbd <fast_pp_skip_inactive+0x19dd>
 2dd1e0f:	mov    0x8(%rsp),%rbp
 2dd1e14:	xor    %ecx,%ecx
 2dd1e16:	cmp    %r10b,%al
 2dd1e19:	movq   $0x0,0x10(%rsp)
 2dd1e22:	sete   %cl
 2dd1e25:	xor    %edx,%edx
 2dd1e27:	xor    %edi,%edi
 2dd1e29:	xor    %r13d,%r13d
 2dd1e2c:	xor    %ebx,%ebx
 2dd1e2e:	add    %rcx,%rbp
 2dd1e31:	mov    %rbp,0x8(%rsp)
 2dd1e36:	vmovdqa64 %zmm5,%zmm2
 2dd1e3c:	vbroadcasti32x4 -0x23b7b26(%rip),%zmm3        # a1a320 <switch.table.ir_if_convert_test_reload+0x138>
 2dd1e46:	vbroadcasti32x4 -0x23b7b20(%rip),%zmm4        # a1a330 <switch.table.ir_if_convert_test_reload+0x148>
 2dd1e50:	vbroadcasti32x4 -0x23b7b1a(%rip),%zmm5        # a1a340 <switch.table.ir_if_convert_test_reload+0x158>
 2dd1e5a:	mov    0x18(%rsp),%rsi
 2dd1e5f:	jmp    2dd1a7f <fast_pp_skip_inactive+0x169f>
 2dd1e64:	xor    %eax,%eax
 2dd1e66:	cmpb   $0x0,0xe968(%rdi)
 2dd1e6d:	mov    $0x1,%r15b
 2dd1e70:	jne    2dd1f7b <fast_pp_skip_inactive+0x1b9b>
 2dd1e76:	mov    %r11d,0x4(%rsp)
 2dd1e7b:	xor    %r14d,%r14d
 2dd1e7e:	mov    %rcx,0x40(%rsp)
 2dd1e83:	lea    -0x23aad29(%rip),%rsi        # a27161 <fast_cc_binary_questioned.range_narrow+0x2a21>
 2dd1e8a:	jmp    2dd1f66 <fast_pp_skip_inactive+0x1b86>
 2dd1e8f:	lea    -0x23aad7e(%rip),%rax        # a27118 <fast_cc_binary_questioned.range_narrow+0x29d8>
 2dd1e96:	mov    %rax,0xa8(%rsp)
 2dd1e9e:	mov    0x20(%rsp),%rdi
 2dd1ea3:	mov    0xa8(%rsp),%rsi
 2dd1eab:	vzeroupper
 2dd1eae:	call   45da9f9 <fast_pp_bail>
 2dd1eb3:	mov    0x18(%rsp),%rbp
 2dd1eb8:	xor    %ebx,%ebx
 2dd1eba:	mov    %r13d,%r11d
 2dd1ebd:	mov    0x20(%rsp),%rdi
 2dd1ec2:	cmpb   $0x0,0xe968(%rdi)
 2dd1ec9:	je     2dd1ee7 <fast_pp_skip_inactive+0x1b07>
 2dd1ecb:	xor    %eax,%eax
 2dd1ecd:	cmpl   $0x0,0x6c(%rsp)
 2dd1ed2:	mov    0x40(%rsp),%rcx
 2dd1ed7:	mov    $0x1,%r15b
 2dd1eda:	je     2dd1f7b <fast_pp_skip_inactive+0x1b9b>
 2dd1ee0:	mov    %r11d,0x4(%rsp)
 2dd1ee5:	jmp    2dd1f5c <fast_pp_skip_inactive+0x1b7c>
 2dd1ee7:	lea    -0x23aad8d(%rip),%rsi        # a27161 <fast_cc_binary_questioned.range_narrow+0x2a21>
 2dd1eee:	mov    %r11d,0x4(%rsp)
 2dd1ef3:	vzeroupper
 2dd1ef6:	call   45da9f9 <fast_pp_bail>
 2dd1efb:	xor    %eax,%eax
 2dd1efd:	cmpl   $0x0,0x6c(%rsp)
 2dd1f02:	mov    $0x1,%r15b
 2dd1f05:	jne    2dd1fbd <fast_pp_skip_inactive+0x1bdd>
 2dd1f0b:	mov    0x40(%rsp),%rcx
 2dd1f10:	jmp    2dd1f76 <fast_pp_skip_inactive+0x1b96>
 2dd1f12:	lea    -0x23aae01(%rip),%rax        # a27118 <fast_cc_binary_questioned.range_narrow+0x29d8>
 2dd1f19:	mov    %rax,0xa0(%rsp)
 2dd1f21:	mov    0x20(%rsp),%rdi
 2dd1f26:	mov    0xa0(%rsp),%rsi
 2dd1f2e:	vzeroupper
 2dd1f31:	call   45da9f9 <fast_pp_bail>
 2dd1f36:	mov    0x18(%rsp),%rbp
 2dd1f3b:	xor    %ebx,%ebx
 2dd1f3d:	mov    0x20(%rsp),%rdi
 2dd1f42:	cmpb   $0x0,0xe968(%rdi)
 2dd1f49:	je     2dd1f9e <fast_pp_skip_inactive+0x1bbe>
 2dd1f4b:	xor    %eax,%eax
 2dd1f4d:	cmpl   $0x0,0x58(%rsp)
 2dd1f52:	mov    0x40(%rsp),%rcx
 2dd1f57:	mov    $0x1,%r15b
 2dd1f5a:	je     2dd1f76 <fast_pp_skip_inactive+0x1b96>
 2dd1f5c:	lea    -0x23aadf1(%rip),%rsi        # a27172 <fast_cc_binary_questioned.range_narrow+0x2a32>
 2dd1f63:	xor    %r14d,%r14d
 2dd1f66:	vzeroupper
 2dd1f69:	call   45da9f9 <fast_pp_bail>
 2dd1f6e:	mov    0x40(%rsp),%rcx
 2dd1f73:	mov    %r14d,%eax
 2dd1f76:	mov    0x4(%rsp),%r11d
 2dd1f7b:	and    %r15b,%bl
 2dd1f7e:	mov    %rbp,0x8(%rcx)
 2dd1f82:	mov    %r11d,0x2c(%rcx)
 2dd1f86:	mov    %bl,0x45(%rcx)
 2dd1f89:	add    $0x118,%rsp
 2dd1f90:	pop    %rbx
 2dd1f91:	pop    %r12
 2dd1f93:	pop    %r13
 2dd1f95:	pop    %r14
 2dd1f97:	pop    %r15
 2dd1f99:	pop    %rbp
 2dd1f9a:	vzeroupper
 2dd1f9d:	ret
 2dd1f9e:	lea    -0x23aae44(%rip),%rsi        # a27161 <fast_cc_binary_questioned.range_narrow+0x2a21>
 2dd1fa5:	vzeroupper
 2dd1fa8:	call   45da9f9 <fast_pp_bail>
 2dd1fad:	xor    %eax,%eax
 2dd1faf:	cmpl   $0x0,0x58(%rsp)
 2dd1fb4:	mov    $0x1,%r15b
 2dd1fb7:	je     2dd1f0b <fast_pp_skip_inactive+0x1b2b>
 2dd1fbd:	mov    0x20(%rsp),%rdi
 2dd1fc2:	xor    %r14d,%r14d
 2dd1fc5:	lea    -0x23aae5a(%rip),%rsi        # a27172 <fast_cc_binary_questioned.range_narrow+0x2a32>
 2dd1fcc:	jmp    2dd1f66 <fast_pp_skip_inactive+0x1b86>
 2dd1fce:	mov    $0x6,%r14b
 2dd1fd1:	xor    %ebx,%ebx
 2dd1fd3:	xor    %r15d,%r15d
 2dd1fd6:	cmpl   $0x0,0x6c(%rsp)
 2dd1fdb:	jne    2dd2002 <fast_pp_skip_inactive+0x1c22>
 2dd1fdd:	mov    0x8(%rsp),%rbp
 2dd1fe2:	mov    0x40(%rsp),%rcx
 2dd1fe7:	mov    0x4(%rsp),%r11d
 2dd1fec:	mov    %r14d,%eax
 2dd1fef:	xor    %ebx,%ebx
 2dd1ff1:	jmp    2dd1f7b <fast_pp_skip_inactive+0x1b9b>
 2dd1ff3:	mov    $0x6,%r14b
 2dd1ff6:	xor    %ebx,%ebx
 2dd1ff8:	xor    %r15d,%r15d
 2dd1ffb:	cmpl   $0x0,0x58(%rsp)
 2dd2000:	je     2dd1fdd <fast_pp_skip_inactive+0x1bfd>
 2dd2002:	mov    0x20(%rsp),%rdi
 2dd2007:	mov    0x8(%rsp),%rbp
 2dd200c:	lea    -0x23aaea1(%rip),%rsi        # a27172 <fast_cc_binary_questioned.range_narrow+0x2a32>
 2dd2013:	jmp    2dd1f66 <fast_pp_skip_inactive+0x1b86>
 2dd2018:	lea    -0x23aaf5d(%rip),%rax        # a270c2 <fast_cc_binary_questioned.range_narrow+0x2982>
 2dd201f:	jmp    2dd1e96 <fast_pp_skip_inactive+0x1ab6>
