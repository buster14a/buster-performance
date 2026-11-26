 2dd03e0:	push   %rbp
 2dd03e1:	push   %r15
 2dd03e3:	push   %r14
 2dd03e5:	push   %r13
 2dd03e7:	push   %r12
 2dd03e9:	push   %rbx
 2dd03ea:	sub    $0x118,%rsp
 2dd03f1:	cmpb   $0x0,0xe9d0(%rdi)
 2dd03f8:	mov    0x8(%rsi),%r10
 2dd03fc:	mov    0x10(%rsi),%r9
 2dd0400:	mov    0x2c(%rsi),%r11d
 2dd0404:	movzbl 0x45(%rsi),%ebx
 2dd0408:	mov    %rdi,%r15
 2dd040b:	je     2dd12cc <fast_pp_skip_inactive+0xeec>
 2dd0411:	cmp    %r9,%r10
 2dd0414:	jae    2dd1eb3 <fast_pp_skip_inactive+0x1ad3>
 2dd041a:	vbroadcasti32x4 -0x23b6124(%rip),%zmm1        # a1a300 <switch.table.ir_if_convert_test_reload+0x118>
 2dd0424:	vbroadcasti32x4 -0x23b610e(%rip),%zmm2        # a1a320 <switch.table.ir_if_convert_test_reload+0x138>
 2dd042e:	vbroadcasti32x4 -0x23b6108(%rip),%zmm3        # a1a330 <switch.table.ir_if_convert_test_reload+0x148>
 2dd0438:	vbroadcasti32x4 -0x23b6102(%rip),%zmm4        # a1a340 <switch.table.ir_if_convert_test_reload+0x158>
 2dd0442:	vbroadcasti32x4 -0x23b60fc(%rip),%zmm5        # a1a350 <switch.table.ir_if_convert_test_reload+0x168>
 2dd044c:	vbroadcasti32x4 -0x23b60f6(%rip),%zmm6        # a1a360 <switch.table.ir_if_convert_test_reload+0x178>
 2dd0456:	vbroadcasti32x4 -0x23b60f0(%rip),%zmm7        # a1a370 <switch.table.ir_if_convert_test_reload+0x188>
 2dd0460:	vbroadcasti32x4 -0x23b60ea(%rip),%zmm8        # a1a380 <switch.table.ir_if_convert_test_reload+0x198>
 2dd046a:	vbroadcasti32x4 -0x23b60e4(%rip),%zmm9        # a1a390 <switch.table.ir_if_convert_test_reload+0x1a8>
 2dd0474:	vbroadcasti32x4 -0x23b60de(%rip),%zmm10        # a1a3a0 <switch.table.ir_if_convert_test_reload+0x1b8>
 2dd047e:	vbroadcasti32x4 -0x23b60d8(%rip),%zmm11        # a1a3b0 <switch.table.ir_if_convert_test_reload+0x1c8>
 2dd0488:	vbroadcasti32x4 -0x23b60d2(%rip),%zmm12        # a1a3c0 <switch.table.ir_if_convert_test_reload+0x1d8>
 2dd0492:	vbroadcasti32x4 -0x23b60cc(%rip),%zmm13        # a1a3d0 <switch.table.ir_if_convert_test_reload+0x1e8>
 2dd049c:	vbroadcasti32x4 -0x23b60c6(%rip),%zmm14        # a1a3e0 <switch.table.ir_if_convert_test_reload+0x1f8>
 2dd04a6:	lea    -0x23a93c5(%rip),%rax        # a270e8 <fast_cc_binary_questioned.range_narrow+0x29a8>
 2dd04ad:	mov    %rsi,0x48(%rsp)
 2dd04b2:	mov    %r15,0x58(%rsp)
 2dd04b7:	movq   $0x0,0x80(%rsp)
 2dd04c3:	movq   $0x0,0x90(%rsp)
 2dd04cf:	movl   $0x0,0x64(%rsp)
 2dd04d7:	xor    %r14d,%r14d
 2dd04da:	xor    %edx,%edx
 2dd04dc:	xor    %r13d,%r13d
 2dd04df:	xor    %ebp,%ebp
 2dd04e1:	xor    %r8d,%r8d
 2dd04e4:	xor    %esi,%esi
 2dd04e6:	mov    %r10,0x8(%rsp)
 2dd04eb:	mov    %rax,0xa8(%rsp)
 2dd04f3:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 2dd0500:	mov    %r9,%r15
 2dd0503:	sub    %r10,%r15
 2dd0506:	mov    %rbp,0x68(%rsp)
 2dd050b:	mov    %r8,0x30(%rsp)
 2dd0510:	mov    %r13,0x18(%rsp)
 2dd0515:	cmp    $0x40,%r15
 2dd0519:	jb     2dd085b <fast_pp_skip_inactive+0x47b>
 2dd051f:	vmovdqu64 (%r10),%zmm15
 2dd0525:	mov    $0x40,%r15d
 2dd052b:	mov    $0xffffffffffffffff,%rcx
 2dd0532:	vpcmpeqb %zmm1,%zmm15,%k0
 2dd0538:	mov    %r15,0x70(%rsp)
 2dd053d:	vpcmpeqb %zmm6,%zmm15,%k1
 2dd0543:	vpaddb %zmm9,%zmm15,%zmm0
 2dd0549:	mov    %r10,0x50(%rsp)
 2dd054e:	bzhi   %r15,%rcx,%r12
 2dd0553:	kmovq  %k0,%r15
 2dd0558:	vpcmpeqb %zmm5,%zmm15,%k0
 2dd055e:	korq   %k1,%k0,%k1
 2dd0563:	mov    %r12,0x28(%rsp)
 2dd0568:	not    %r12
 2dd056b:	lea    (%r15,%r15,1),%r13
 2dd056f:	mov    %r15,%rbp
 2dd0572:	not    %rbp
 2dd0575:	kmovq  %k1,%rax
 2dd057a:	vpcmpeqb %zmm7,%zmm15,%k1
 2dd0580:	or     %rbx,%r13
 2dd0583:	kmovq  %k1,%rdi
 2dd0588:	vpcmpeqb %zmm8,%zmm15,%k1
 2dd058e:	kmovq  %k1,%rcx
 2dd0593:	vpcmpltub %zmm10,%zmm0,%k1
 2dd059a:	mov    %rdi,0x20(%rsp)
 2dd059f:	kmovq  %k1,%r8
 2dd05a4:	or     %rcx,%r12
 2dd05a7:	lea    (%rdi,%rdi,1),%rcx
 2dd05ab:	vpcmpeqb %zmm14,%zmm15,%k1
 2dd05b1:	mov    %rax,%rdi
 2dd05b4:	andn   %r8,%r15,%r8
 2dd05b9:	kmovq  %k1,%rax
 2dd05be:	or     %r8,%r12
 2dd05c1:	mov    %rax,0xa0(%rsp)
 2dd05c9:	mov    %r12,%rbx
 2dd05cc:	and    %r13,%rbx
 2dd05cf:	add    %r12,%rbx
 2dd05d2:	setb   0x98(%rsp)
 2dd05da:	or     %rdx,%rcx
 2dd05dd:	or     %rcx,%rbp
 2dd05e0:	add    $0xff,%r14b
 2dd05e4:	lea    (%rax,%rax,1),%r14
 2dd05e8:	mov    %rcx,0x10(%rsp)
 2dd05ed:	kmovq  %k0,%rax
 2dd05f2:	adc    %rbp,%rdi
 2dd05f5:	setb   %cl
 2dd05f8:	or     %rsi,%r14
 2dd05fb:	and    %rax,%r14
 2dd05fe:	mov    %rcx,0x88(%rsp)
 2dd0606:	jne    2dd0706 <fast_pp_skip_inactive+0x326>
 2dd060c:	xor    %esi,%esi
 2dd060e:	vpcmpeqb %zmm2,%zmm15,%k0
 2dd0614:	vpcmpeqb %zmm4,%zmm15,%k1
 2dd061a:	or     %r13,%rbx
 2dd061d:	mov    %r9,%r14
 2dd0620:	vpandq %zmm11,%zmm15,%zmm0
 2dd0626:	kmovq  %k0,%rcx
 2dd062b:	vpcmpeqb %zmm3,%zmm15,%k0
 2dd0631:	andn   %rbx,%r12,%r9
 2dd0636:	mov    0x10(%rsp),%r12
 2dd063b:	kmovq  %k0,%rdx
 2dd0640:	korq   %k0,%k1,%k1
 2dd0645:	vpcmpeqb %zmm12,%zmm0,%k0
 2dd064b:	and    %r9,%rcx
 2dd064e:	lea    (%rdx,%rdx,1),%rax
 2dd0652:	or     0x18(%rsp),%rax
 2dd0657:	kmovq  %k1,%r8
 2dd065c:	vpcmpeqb %zmm13,%zmm15,%k1
 2dd0662:	korq   %k0,%k1,%k0
 2dd0667:	kmovq  %k0,%r10
 2dd066c:	and    %r12,%r10
 2dd066f:	and    %r8,%rax
 2dd0672:	andn   %rbp,%rdi,%r8
 2dd0677:	mov    0x20(%rsp),%rdi
 2dd067c:	and    %rdi,%r12
 2dd067f:	or     %r10,%r12
 2dd0682:	or     %r12,%rax
 2dd0685:	or     %rcx,%rax
 2dd0688:	or     %rsi,%rax
 2dd068b:	and    0x28(%rsp),%rax
 2dd0690:	jne    2dd087a <fast_pp_skip_inactive+0x49a>
 2dd0696:	movzbl 0x98(%rsp),%eax
 2dd069e:	mov    0xa0(%rsp),%rsi
 2dd06a6:	mov    0x50(%rsp),%r10
 2dd06ab:	shr    $0x3f,%r9
 2dd06af:	xor    %ecx,%ecx
 2dd06b1:	shr    $0x3f,%rdx
 2dd06b5:	shr    $0x3f,%rdi
 2dd06b9:	shr    $0x3f,%r8
 2dd06bd:	mov    %r9,%rbp
 2dd06c0:	mov    %r14,%r9
 2dd06c3:	add    0x70(%rsp),%r10
 2dd06c8:	mov    0x88(%rsp),%r14
 2dd06d0:	mov    %rdx,%r13
 2dd06d3:	mov    %rdi,%rdx
 2dd06d6:	mov    %al,%cl
 2dd06d8:	popcnt %r15,%rax
 2dd06dd:	shr    $0x3f,%r15
 2dd06e1:	shr    $0x3f,%rsi
 2dd06e5:	or     %rcx,%r15
 2dd06e8:	add    %eax,%r11d
 2dd06eb:	xor    %ecx,%ecx
 2dd06ed:	mov    %r15,%rbx
 2dd06f0:	cmp    %r9,%r10
 2dd06f3:	jae    2dd1f23 <fast_pp_skip_inactive+0x1b43>
 2dd06f9:	test   %cl,%cl
 2dd06fb:	je     2dd0500 <fast_pp_skip_inactive+0x120>
 2dd0701:	jmp    2dd1f23 <fast_pp_skip_inactive+0x1b43>
 2dd0706:	mov    0x48(%rsp),%rax
 2dd070b:	xor    %esi,%esi
 2dd070d:	mov    %r11d,0x4(%rsp)
 2dd0712:	mov    %r9,0x38(%rsp)
 2dd0717:	vmovdqu64 %zmm15,0xd0(%rsp)
 2dd0722:	mov    %rdi,0xc8(%rsp)
 2dd072a:	mov    (%rax),%rax
 2dd072d:	mov    %rax,0xb8(%rsp)
 2dd0735:	mov    0x58(%rsp),%rax
 2dd073a:	movzbl 0xe9d0(%rax),%eax
 2dd0741:	mov    %al,0x47(%rsp)
 2dd0745:	mov    0x50(%rsp),%rax
 2dd074a:	movzbl 0x47(%rsp),%edx
 2dd074f:	mov    0xb8(%rsp),%rdi
 2dd0757:	xor    %ecx,%ecx
 2dd0759:	tzcnt  %r14,%rcx
 2dd075e:	mov    %rsi,0xc0(%rsp)
 2dd0766:	mov    %rcx,0xb0(%rsp)
 2dd076e:	lea    (%rax,%rcx,1),%rsi
 2dd0772:	vzeroupper
 2dd0775:	call   45df0d0 <fast_raw_string_before>
 2dd077a:	vmovdqu64 0xd0(%rsp),%zmm15
 2dd0785:	vbroadcasti32x4 -0x23b63af(%rip),%zmm14        # a1a3e0 <switch.table.ir_if_convert_test_reload+0x1f8>
 2dd078f:	vbroadcasti32x4 -0x23b63c9(%rip),%zmm13        # a1a3d0 <switch.table.ir_if_convert_test_reload+0x1e8>
 2dd0799:	vbroadcasti32x4 -0x23b63e3(%rip),%zmm12        # a1a3c0 <switch.table.ir_if_convert_test_reload+0x1d8>
 2dd07a3:	vbroadcasti32x4 -0x23b63fd(%rip),%zmm11        # a1a3b0 <switch.table.ir_if_convert_test_reload+0x1c8>
 2dd07ad:	vbroadcasti32x4 -0x23b6417(%rip),%zmm10        # a1a3a0 <switch.table.ir_if_convert_test_reload+0x1b8>
 2dd07b7:	vbroadcasti32x4 -0x23b6431(%rip),%zmm9        # a1a390 <switch.table.ir_if_convert_test_reload+0x1a8>
 2dd07c1:	vbroadcasti32x4 -0x23b644b(%rip),%zmm8        # a1a380 <switch.table.ir_if_convert_test_reload+0x198>
 2dd07cb:	vbroadcasti32x4 -0x23b6465(%rip),%zmm7        # a1a370 <switch.table.ir_if_convert_test_reload+0x188>
 2dd07d5:	vbroadcasti32x4 -0x23b647f(%rip),%zmm6        # a1a360 <switch.table.ir_if_convert_test_reload+0x178>
 2dd07df:	vbroadcasti32x4 -0x23b6499(%rip),%zmm5        # a1a350 <switch.table.ir_if_convert_test_reload+0x168>
 2dd07e9:	vbroadcasti32x4 -0x23b64b3(%rip),%zmm4        # a1a340 <switch.table.ir_if_convert_test_reload+0x158>
 2dd07f3:	vbroadcasti32x4 -0x23b64cd(%rip),%zmm3        # a1a330 <switch.table.ir_if_convert_test_reload+0x148>
 2dd07fd:	vbroadcasti32x4 -0x23b64e7(%rip),%zmm2        # a1a320 <switch.table.ir_if_convert_test_reload+0x138>
 2dd0807:	vbroadcasti32x4 -0x23b6511(%rip),%zmm1        # a1a300 <switch.table.ir_if_convert_test_reload+0x118>
 2dd0811:	mov    0xb0(%rsp),%rdx
 2dd0819:	mov    0xc0(%rsp),%rsi
 2dd0821:	mov    0xc8(%rsp),%rdi
 2dd0829:	mov    0x38(%rsp),%r9
 2dd082e:	mov    0x4(%rsp),%r11d
 2dd0833:	mov    $0x1,%ecx
 2dd0838:	test   %al,%al
 2dd083a:	mov    $0x0,%eax
 2dd083f:	shlx   %rdx,%rcx,%rcx
 2dd0844:	cmove  %rax,%rcx
 2dd0848:	or     %rcx,%rsi
 2dd084b:	blsr   %r14,%r14
 2dd0850:	je     2dd060e <fast_pp_skip_inactive+0x22e>
 2dd0856:	jmp    2dd0745 <fast_pp_skip_inactive+0x365>
 2dd085b:	mov    $0xffffffffffffffff,%rcx
 2dd0862:	shlx   %r15,%rcx,%rcx
 2dd0867:	not    %rcx
 2dd086a:	kmovq  %rcx,%k1
 2dd086f:	vmovdqu8 (%r10),%zmm15{%k1}{z}
 2dd0875:	jmp    2dd052b <fast_pp_skip_inactive+0x14b>
 2dd087a:	mov    0x50(%rsp),%r10
 2dd087f:	tzcnt  %rax,%rax
 2dd0884:	mov    $0x0,%ebx
 2dd0889:	shrx   %rax,%rsi,%rdx
 2dd088e:	shrx   %rax,%rcx,%rcx
 2dd0893:	mov    %rdx,%rsi
 2dd0896:	or     $0xfffffffffffffffe,%rsi
 2dd089a:	inc    %rsi
 2dd089d:	test   $0x1,%cl
 2dd08a0:	cmove  %rsi,%rbx
 2dd08a4:	lea    (%r10,%rax,1),%r13
 2dd08a8:	mov    %rbx,0x18(%rsp)
 2dd08ad:	add    %rbx,%r13
 2dd08b0:	test   $0x1,%cl
 2dd08b3:	je     2dd08d3 <fast_pp_skip_inactive+0x4f3>
 2dd08b5:	mov    0x68(%rsp),%rbp
 2dd08ba:	test   $0x1,%dl
 2dd08bd:	jne    2dd0c66 <fast_pp_skip_inactive+0x886>
 2dd08c3:	shrx   %rax,%r8,%r8
 2dd08c8:	mov    $0x1,%ebx
 2dd08cd:	and    $0x1,%r8d
 2dd08d1:	jmp    2dd0935 <fast_pp_skip_inactive+0x555>
 2dd08d3:	mov    0x68(%rsp),%rbp
 2dd08d8:	mov    $0xffffffff,%r10d
 2dd08de:	mov    %r11d,%ebx
 2dd08e1:	mov    %r12,0x10(%rsp)
 2dd08e6:	mov    %r13,%r12
 2dd08e9:	add    %eax,%r10d
 2dd08ec:	shrx   %r10,%r9,%r9
 2dd08f1:	and    $0x1,%r9d
 2dd08f5:	test   %rax,%rax
 2dd08f8:	mov    %ebp,%r11d
 2dd08fb:	cmovne %r9d,%r11d
 2dd08ff:	xor    %r13d,%r13d
 2dd0902:	test   %r11d,%r11d
 2dd0905:	setne  %r13b
 2dd0909:	test   $0x1,%dl
 2dd090c:	jne    2dd0c7e <fast_pp_skip_inactive+0x89e>
 2dd0912:	mov    %ebx,%r11d
 2dd0915:	test   %rax,%rax
 2dd0918:	je     2dd0925 <fast_pp_skip_inactive+0x545>
 2dd091a:	shrx   %r10,%r8,%r8
 2dd091f:	and    $0x1,%r8d
 2dd0923:	jmp    2dd092a <fast_pp_skip_inactive+0x54a>
 2dd0925:	mov    0x30(%rsp),%r8
 2dd092a:	mov    %r13,%rbx
 2dd092d:	mov    %r12,%r13
 2dd0930:	mov    0x10(%rsp),%r12
 2dd0935:	mov    $0xffffffffffffffff,%r9
 2dd093c:	bzhi   %rax,%r9,%r9
 2dd0941:	and    %r15,%r9
 2dd0944:	popcnt %r9,%r9
 2dd0949:	add    %r9d,%r11d
 2dd094c:	test   %r8d,%r8d
 2dd094f:	jne    2dd0cad <fast_pp_skip_inactive+0x8cd>
 2dd0955:	test   $0x1,%cl
 2dd0958:	mov    %r14,%rcx
 2dd095b:	je     2dd0d90 <fast_pp_skip_inactive+0x9b0>
 2dd0961:	mov    0x58(%rsp),%r15
 2dd0966:	inc    %r13
 2dd0969:	mov    %r11d,0x4(%rsp)
 2dd096e:	mov    %rcx,%r14
 2dd0971:	mov    %rcx,%rsi
 2dd0974:	mov    %r13,%rdi
 2dd0977:	vzeroupper
 2dd097a:	call   45db790 <fast_skip_hspace>
 2dd097f:	mov    %r14,%r9
 2dd0982:	mov    %rax,%r12
 2dd0985:	cmp    %r14,%rax
 2dd0988:	jae    2dd099c <fast_pp_skip_inactive+0x5bc>
 2dd098a:	movzbl (%r12),%ebx
 2dd098f:	lea    -0x23b2b96(%rip),%rax        # a1de00 <fast_char_class>
 2dd0996:	testb  $0x2,(%rbx,%rax,1)
 2dd099a:	jne    2dd09bc <fast_pp_skip_inactive+0x5dc>
 2dd099c:	mov    0x4(%rsp),%r11d
 2dd09a1:	xor    %ecx,%ecx
 2dd09a3:	xor    %esi,%esi
 2dd09a5:	xor    %r13d,%r13d
 2dd09a8:	xor    %edx,%edx
 2dd09aa:	xor    %r14d,%r14d
 2dd09ad:	xor    %ebx,%ebx
 2dd09af:	mov    %r12,0x8(%rsp)
 2dd09b4:	mov    %r12,%r10
 2dd09b7:	jmp    2dd0efb <fast_pp_skip_inactive+0xb1b>
 2dd09bc:	mov    %r12,%rdi
 2dd09bf:	mov    %r9,%rsi
 2dd09c2:	call   45ddbf0 <fast_scan_ident_len>
 2dd09c7:	lea    -0x2(%rax),%ecx
 2dd09ca:	cmp    $0x6,%ecx
 2dd09cd:	ja     2dd0b24 <fast_pp_skip_inactive+0x744>
 2dd09d3:	lea    -0x23ac6a6(%rip),%rdx        # a24334 <c_direct_test_dependencies.levels+0x57>
 2dd09da:	movslq (%rdx,%rcx,4),%rcx
 2dd09de:	add    %rdx,%rcx
 2dd09e1:	jmp    *%rcx
 2dd09e3:	cmp    $0x69,%bl
 2dd09e6:	jne    2dd0b24 <fast_pp_skip_inactive+0x744>
 2dd09ec:	cmpb   $0x66,0x1(%r12)
 2dd09f2:	je     2dd0ad0 <fast_pp_skip_inactive+0x6f0>
 2dd09f8:	jmp    2dd0b24 <fast_pp_skip_inactive+0x744>
 2dd09fd:	movzbl 0x4(%r12),%esi
 2dd0a03:	mov    (%r12),%ecx
 2dd0a07:	mov    $0x65646669,%edx
 2dd0a0c:	xor    %edx,%ecx
 2dd0a0e:	xor    $0x66,%esi
 2dd0a11:	or     %ecx,%esi
 2dd0a13:	je     2dd0ad0 <fast_pp_skip_inactive+0x6f0>
 2dd0a19:	movzbl 0x4(%r12),%esi
 2dd0a1f:	mov    (%r12),%ecx
 2dd0a23:	mov    $0x69646e65,%edx
 2dd0a28:	xor    %edx,%ecx
 2dd0a2a:	xor    $0x66,%esi
 2dd0a2d:	or     %ecx,%esi
 2dd0a2f:	jne    2dd0b24 <fast_pp_skip_inactive+0x744>
 2dd0a35:	add    $0x5,%r12
 2dd0a39:	cmpl   $0x0,0x80(%rsp)
 2dd0a41:	mov    %r12,%rdi
 2dd0a44:	je     2dd2061 <fast_pp_skip_inactive+0x1c81>
 2dd0a4a:	mov    0x80(%rsp),%rax
 2dd0a52:	xor    %ecx,%ecx
 2dd0a54:	xor    %esi,%esi
 2dd0a56:	xor    %r13d,%r13d
 2dd0a59:	xor    %edx,%edx
 2dd0a5b:	xor    %ebx,%ebx
 2dd0a5d:	mov    %rdi,%r10
 2dd0a60:	mov    %rdi,0x8(%rsp)
 2dd0a65:	dec    %eax
 2dd0a67:	mov    %rax,0x80(%rsp)
 2dd0a6f:	jmp    2dd0bc0 <fast_pp_skip_inactive+0x7e0>
 2dd0a74:	movabs $0x6665646e66696c65,%rcx
 2dd0a7e:	cmp    %rcx,(%r12)
 2dd0a82:	jne    2dd0b24 <fast_pp_skip_inactive+0x744>
 2dd0a88:	mov    $0x32,%bpl
 2dd0a8b:	jmp    2dd0b5b <fast_pp_skip_inactive+0x77b>
 2dd0a90:	cmpl   $0x65736c65,(%r12)
 2dd0a98:	je     2dd0b4c <fast_pp_skip_inactive+0x76c>
 2dd0a9e:	cmpl   $0x66696c65,(%r12)
 2dd0aa6:	mov    0x68(%rsp),%rbp
 2dd0aab:	jne    2dd0b24 <fast_pp_skip_inactive+0x744>
 2dd0aad:	mov    $0x4,%bpl
 2dd0ab0:	jmp    2dd0b6a <fast_pp_skip_inactive+0x78a>
 2dd0ab5:	movzwl 0x4(%r12),%esi
 2dd0abb:	mov    (%r12),%ecx
 2dd0abf:	mov    $0x646e6669,%edx
 2dd0ac4:	xor    %edx,%ecx
 2dd0ac6:	xor    $0x6665,%esi
 2dd0acc:	or     %ecx,%esi
 2dd0ace:	jne    2dd0b24 <fast_pp_skip_inactive+0x744>
 2dd0ad0:	mov    0x80(%rsp),%rcx
 2dd0ad8:	mov    %eax,%eax
 2dd0ada:	add    %rax,%r12
 2dd0add:	xor    %eax,%eax
 2dd0adf:	mov    0x90(%rsp),%rdx
 2dd0ae7:	inc    %ecx
 2dd0ae9:	cmp    $0x40,%ecx
 2dd0aec:	mov    %rcx,0x80(%rsp)
 2dd0af4:	setae  %al
 2dd0af7:	btr    %rcx,%rdx
 2dd0afb:	or     %eax,0x64(%rsp)
 2dd0aff:	mov    %rdx,0x90(%rsp)
 2dd0b07:	jmp    2dd0b29 <fast_pp_skip_inactive+0x749>
 2dd0b09:	mov    (%r12),%ecx
 2dd0b0d:	mov    0x3(%r12),%edi
 2dd0b12:	mov    $0x66696c65,%edx
 2dd0b17:	mov    $0x66656466,%esi
 2dd0b1c:	xor    %edx,%ecx
 2dd0b1e:	xor    %esi,%edi
 2dd0b20:	or     %ecx,%edi
 2dd0b22:	je     2dd0b58 <fast_pp_skip_inactive+0x778>
 2dd0b24:	mov    %eax,%eax
 2dd0b26:	add    %rax,%r12
 2dd0b29:	mov    0x4(%rsp),%r11d
 2dd0b2e:	mov    %r14,%r9
 2dd0b31:	xor    %ecx,%ecx
 2dd0b33:	xor    %esi,%esi
 2dd0b35:	xor    %r13d,%r13d
 2dd0b38:	xor    %edx,%edx
 2dd0b3a:	xor    %ebx,%ebx
 2dd0b3c:	mov    %r12,0x8(%rsp)
 2dd0b41:	mov    %r12,%r10
 2dd0b44:	xor    %r14d,%r14d
 2dd0b47:	jmp    2dd0efb <fast_pp_skip_inactive+0xb1b>
 2dd0b4c:	mov    $0xffffffffffffffff,%rcx
 2dd0b53:	mov    $0x5,%bpl
 2dd0b56:	jmp    2dd0b6c <fast_pp_skip_inactive+0x78c>
 2dd0b58:	mov    $0x31,%bpl
 2dd0b5b:	movzbl 0xe979(%r15),%ecx
 2dd0b63:	xor    $0x1,%ecx
 2dd0b66:	or     %ecx,0x64(%rsp)
 2dd0b6a:	xor    %ecx,%ecx
 2dd0b6c:	mov    0x80(%rsp),%rdx
 2dd0b74:	mov    %eax,%eax
 2dd0b76:	add    %rax,%r12
 2dd0b79:	test   %edx,%edx
 2dd0b7b:	je     2dd1ede <fast_pp_skip_inactive+0x1afe>
 2dd0b81:	mov    0x90(%rsp),%rsi
 2dd0b89:	mov    $0x1,%eax
 2dd0b8e:	xor    %r13d,%r13d
 2dd0b91:	xor    %ebx,%ebx
 2dd0b93:	mov    %r12,0x8(%rsp)
 2dd0b98:	mov    %r12,%r10
 2dd0b9b:	shlx   %rdx,%rax,%rax
 2dd0ba0:	and    %rax,%rcx
 2dd0ba3:	shrx   %rdx,%rsi,%rax
 2dd0ba8:	or     %rcx,%rsi
 2dd0bab:	xor    %ecx,%ecx
 2dd0bad:	xor    %edx,%edx
 2dd0baf:	and    $0x1,%eax
 2dd0bb2:	mov    %rsi,0x90(%rsp)
 2dd0bba:	xor    %esi,%esi
 2dd0bbc:	or     %eax,0x64(%rsp)
 2dd0bc0:	mov    0x4(%rsp),%r11d
 2dd0bc5:	vbroadcasti32x4 -0x23b68cf(%rip),%zmm1        # a1a300 <switch.table.ir_if_convert_test_reload+0x118>
 2dd0bcf:	vbroadcasti32x4 -0x23b68b9(%rip),%zmm2        # a1a320 <switch.table.ir_if_convert_test_reload+0x138>
 2dd0bd9:	vbroadcasti32x4 -0x23b68b3(%rip),%zmm3        # a1a330 <switch.table.ir_if_convert_test_reload+0x148>
 2dd0be3:	vbroadcasti32x4 -0x23b68ad(%rip),%zmm4        # a1a340 <switch.table.ir_if_convert_test_reload+0x158>
 2dd0bed:	vbroadcasti32x4 -0x23b68a7(%rip),%zmm5        # a1a350 <switch.table.ir_if_convert_test_reload+0x168>
 2dd0bf7:	vbroadcasti32x4 -0x23b68a1(%rip),%zmm6        # a1a360 <switch.table.ir_if_convert_test_reload+0x178>
 2dd0c01:	vbroadcasti32x4 -0x23b689b(%rip),%zmm7        # a1a370 <switch.table.ir_if_convert_test_reload+0x188>
 2dd0c0b:	vbroadcasti32x4 -0x23b6895(%rip),%zmm8        # a1a380 <switch.table.ir_if_convert_test_reload+0x198>
 2dd0c15:	vbroadcasti32x4 -0x23b688f(%rip),%zmm9        # a1a390 <switch.table.ir_if_convert_test_reload+0x1a8>
 2dd0c1f:	vbroadcasti32x4 -0x23b6889(%rip),%zmm10        # a1a3a0 <switch.table.ir_if_convert_test_reload+0x1b8>
 2dd0c29:	vbroadcasti32x4 -0x23b6883(%rip),%zmm11        # a1a3b0 <switch.table.ir_if_convert_test_reload+0x1c8>
 2dd0c33:	vbroadcasti32x4 -0x23b687d(%rip),%zmm12        # a1a3c0 <switch.table.ir_if_convert_test_reload+0x1d8>
 2dd0c3d:	vbroadcasti32x4 -0x23b6877(%rip),%zmm13        # a1a3d0 <switch.table.ir_if_convert_test_reload+0x1e8>
 2dd0c47:	vbroadcasti32x4 -0x23b6871(%rip),%zmm14        # a1a3e0 <switch.table.ir_if_convert_test_reload+0x1f8>
 2dd0c51:	mov    0x68(%rsp),%rbp
 2dd0c56:	mov    0x30(%rsp),%r8
 2dd0c5b:	mov    %r14,%r9
 2dd0c5e:	xor    %r14d,%r14d
 2dd0c61:	jmp    2dd06f0 <fast_pp_skip_inactive+0x310>
 2dd0c66:	mov    0x8(%rsp),%rsi
 2dd0c6b:	mov    %r12,0x10(%rsp)
 2dd0c70:	mov    %r13,%r12
 2dd0c73:	mov    $0x1,%r13d
 2dd0c79:	mov    %r11d,%ebx
 2dd0c7c:	jmp    2dd0c83 <fast_pp_skip_inactive+0x8a3>
 2dd0c7e:	mov    0x8(%rsp),%rsi
 2dd0c83:	mov    $0xffffffffffffffff,%r8
 2dd0c8a:	mov    %ebx,%r11d
 2dd0c8d:	mov    %r13,%rbx
 2dd0c90:	mov    %r12,%r13
 2dd0c93:	mov    0x10(%rsp),%r12
 2dd0c98:	mov    %rsi,0x8(%rsp)
 2dd0c9d:	bzhi   %rax,%r8,%r8
 2dd0ca2:	and    %r15,%r8
 2dd0ca5:	popcnt %r8,%r8
 2dd0caa:	add    %r8d,%r11d
 2dd0cad:	mov    0x8(%rsp),%rdi
 2dd0cb2:	mov    %r12,0x10(%rsp)
 2dd0cb7:	mov    %rbx,%r9
 2dd0cba:	mov    %r11d,%r15d
 2dd0cbd:	mov    %r13,0x28(%rsp)
 2dd0cc2:	cmp    %rdi,%r13
 2dd0cc5:	jbe    2dd0d0c <fast_pp_skip_inactive+0x92c>
 2dd0cc7:	mov    0x18(%rsp),%rsi
 2dd0ccc:	mov    %rdi,%r8
 2dd0ccf:	mov    0x50(%rsp),%rdi
 2dd0cd4:	mov    0x28(%rsp),%r13
 2dd0cd9:	add    %rax,%rsi
 2dd0cdc:	lea    -0x1(%rdi,%rsi,1),%rsi
 2dd0ce1:	jmp    2dd0cef <fast_pp_skip_inactive+0x90f>
 2dd0ce3:	dec    %r13
 2dd0ce6:	cmp    %r8,%rsi
 2dd0ce9:	lea    -0x1(%rsi),%rsi
 2dd0ced:	jbe    2dd0d01 <fast_pp_skip_inactive+0x921>
 2dd0cef:	cmpb   $0xa,(%rsi)
 2dd0cf2:	jne    2dd0ce3 <fast_pp_skip_inactive+0x903>
 2dd0cf4:	cmp    %r8,%rsi
 2dd0cf7:	jbe    2dd0d06 <fast_pp_skip_inactive+0x926>
 2dd0cf9:	cmpb   $0x5c,-0x1(%rsi)
 2dd0cfd:	je     2dd0ce3 <fast_pp_skip_inactive+0x903>
 2dd0cff:	jmp    2dd0d0c <fast_pp_skip_inactive+0x92c>
 2dd0d01:	mov    %r8,%r13
 2dd0d04:	jmp    2dd0d0c <fast_pp_skip_inactive+0x92c>
 2dd0d06:	inc    %rsi
 2dd0d09:	mov    %rsi,%r13
 2dd0d0c:	and    $0x1,%edx
 2dd0d0f:	add    0x28(%rsp),%rdx
 2dd0d14:	cmp    %rdx,%r13
 2dd0d17:	jae    2dd0d6f <fast_pp_skip_inactive+0x98f>
 2dd0d19:	mov    0x18(%rsp),%r12
 2dd0d1e:	lea    0x30(%r13),%rbx
 2dd0d22:	mov    %r13,0x20(%rsp)
 2dd0d27:	xor    %ebp,%ebp
 2dd0d29:	add    %rax,%r12
 2dd0d2c:	add    0x50(%rsp),%r12
 2dd0d31:	mov    %r12,0x18(%rsp)
 2dd0d36:	sub    %r13,%r12
 2dd0d39:	movzbl 0x0(%r13,%rbp,1),%esi
 2dd0d3f:	mov    %esi,0x50(%rsp)
 2dd0d43:	cmp    $0x22,%esi
 2dd0d46:	je     2dd109a <fast_pp_skip_inactive+0xcba>
 2dd0d4c:	cmpl   $0x27,0x50(%rsp)
 2dd0d51:	je     2dd105e <fast_pp_skip_inactive+0xc7e>
 2dd0d57:	incq   0x20(%rsp)
 2dd0d5c:	lea    0x1(%r13,%rbp,1),%rsi
 2dd0d61:	inc    %rbp
 2dd0d64:	dec    %r12
 2dd0d67:	inc    %rbx
 2dd0d6a:	cmp    %rdx,%rsi
 2dd0d6d:	jb     2dd0d39 <fast_pp_skip_inactive+0x959>
 2dd0d6f:	mov    0x68(%rsp),%rbp
 2dd0d74:	mov    0x28(%rsp),%r13
 2dd0d79:	mov    0x10(%rsp),%r12
 2dd0d7e:	mov    %r15d,%r11d
 2dd0d81:	mov    %r9,%rbx
 2dd0d84:	test   $0x1,%cl
 2dd0d87:	mov    %r14,%rcx
 2dd0d8a:	jne    2dd0961 <fast_pp_skip_inactive+0x581>
 2dd0d90:	mov    0x58(%rsp),%r14
 2dd0d95:	shrx   %rax,%r12,%rax
 2dd0d9a:	test   $0x1,%al
 2dd0d9c:	je     2dd0e93 <fast_pp_skip_inactive+0xab3>
 2dd0da2:	inc    %r13
 2dd0da5:	mov    %r11d,%r15d
 2dd0da8:	mov    %rcx,%r14
 2dd0dab:	mov    %rcx,%rsi
 2dd0dae:	mov    %r13,%rdi
 2dd0db1:	vzeroupper
 2dd0db4:	call   45df190 <fast_skip_splices>
 2dd0db9:	mov    %r14,%r9
 2dd0dbc:	cmp    %r14,%rax
 2dd0dbf:	jae    2dd0ee2 <fast_pp_skip_inactive+0xb02>
 2dd0dc5:	vbroadcasti32x4 -0x23b6acf(%rip),%zmm1        # a1a300 <switch.table.ir_if_convert_test_reload+0x118>
 2dd0dcf:	vbroadcasti32x4 -0x23b6ab9(%rip),%zmm2        # a1a320 <switch.table.ir_if_convert_test_reload+0x138>
 2dd0dd9:	vbroadcasti32x4 -0x23b6ab3(%rip),%zmm3        # a1a330 <switch.table.ir_if_convert_test_reload+0x148>
 2dd0de3:	vbroadcasti32x4 -0x23b6aad(%rip),%zmm4        # a1a340 <switch.table.ir_if_convert_test_reload+0x158>
 2dd0ded:	vbroadcasti32x4 -0x23b6aa7(%rip),%zmm5        # a1a350 <switch.table.ir_if_convert_test_reload+0x168>
 2dd0df7:	vbroadcasti32x4 -0x23b6aa1(%rip),%zmm6        # a1a360 <switch.table.ir_if_convert_test_reload+0x178>
 2dd0e01:	vbroadcasti32x4 -0x23b6a9b(%rip),%zmm7        # a1a370 <switch.table.ir_if_convert_test_reload+0x188>
 2dd0e0b:	vbroadcasti32x4 -0x23b6a95(%rip),%zmm8        # a1a380 <switch.table.ir_if_convert_test_reload+0x198>
 2dd0e15:	vbroadcasti32x4 -0x23b6a8f(%rip),%zmm9        # a1a390 <switch.table.ir_if_convert_test_reload+0x1a8>
 2dd0e1f:	vbroadcasti32x4 -0x23b6a89(%rip),%zmm10        # a1a3a0 <switch.table.ir_if_convert_test_reload+0x1b8>
 2dd0e29:	vbroadcasti32x4 -0x23b6a83(%rip),%zmm11        # a1a3b0 <switch.table.ir_if_convert_test_reload+0x1c8>
 2dd0e33:	vbroadcasti32x4 -0x23b6a7d(%rip),%zmm12        # a1a3c0 <switch.table.ir_if_convert_test_reload+0x1d8>
 2dd0e3d:	vbroadcasti32x4 -0x23b6a77(%rip),%zmm13        # a1a3d0 <switch.table.ir_if_convert_test_reload+0x1e8>
 2dd0e47:	vbroadcasti32x4 -0x23b6a71(%rip),%zmm14        # a1a3e0 <switch.table.ir_if_convert_test_reload+0x1f8>
 2dd0e51:	movzbl (%rax),%edx
 2dd0e54:	mov    0x30(%rsp),%r8
 2dd0e59:	xor    %esi,%esi
 2dd0e5b:	xor    %ecx,%ecx
 2dd0e5d:	mov    %r15d,%r11d
 2dd0e60:	add    $0xffffffb2,%edx
 2dd0e63:	cmp    $0x27,%edx
 2dd0e66:	ja     2dd0e7c <fast_pp_skip_inactive+0xa9c>
 2dd0e68:	movabs $0x8000000081,%rdi
 2dd0e72:	bt     %rdx,%rdi
 2dd0e76:	jb     2dd1ef7 <fast_pp_skip_inactive+0x1b17>
 2dd0e7c:	mov    %r13,0x8(%rsp)
 2dd0e81:	mov    %r13,%r10
 2dd0e84:	xor    %edx,%edx
 2dd0e86:	xor    %ebx,%ebx
 2dd0e88:	xor    %r13d,%r13d
 2dd0e8b:	xor    %r14d,%r14d
 2dd0e8e:	jmp    2dd06f0 <fast_pp_skip_inactive+0x310>
 2dd0e93:	movl   $0x0,0x7c(%rsp)
 2dd0e9b:	lea    0x2(%r13),%rdi
 2dd0e9f:	mov    %r11d,%ebp
 2dd0ea2:	cmpb   $0x2a,0x1(%r13)
 2dd0ea7:	jne    2dd0f91 <fast_pp_skip_inactive+0xbb1>
 2dd0ead:	lea    0x7c(%rsp),%rdx
 2dd0eb2:	mov    %rcx,%rsi
 2dd0eb5:	mov    %rcx,%r15
 2dd0eb8:	vzeroupper
 2dd0ebb:	call   45dd3a0 <fast_skip_block_comment>
 2dd0ec0:	test   %rax,%rax
 2dd0ec3:	jne    2dd0fa4 <fast_pp_skip_inactive+0xbc4>
 2dd0ec9:	lea    -0x23a9d8c(%rip),%rsi        # a27144 <fast_cc_binary_questioned.range_narrow+0x2a04>
 2dd0ed0:	mov    %r14,%rdi
 2dd0ed3:	call   45daab9 <fast_pp_bail>
 2dd0ed8:	mov    $0x1,%cl
 2dd0eda:	mov    %r15,%rax
 2dd0edd:	jmp    2dd0fa6 <fast_pp_skip_inactive+0xbc6>
 2dd0ee2:	xor    %ecx,%ecx
 2dd0ee4:	mov    %r13,0x8(%rsp)
 2dd0ee9:	mov    %r13,%r10
 2dd0eec:	xor    %esi,%esi
 2dd0eee:	xor    %edx,%edx
 2dd0ef0:	xor    %r14d,%r14d
 2dd0ef3:	xor    %ebx,%ebx
 2dd0ef5:	xor    %r13d,%r13d
 2dd0ef8:	mov    %r15d,%r11d
 2dd0efb:	vbroadcasti32x4 -0x23b6c05(%rip),%zmm1        # a1a300 <switch.table.ir_if_convert_test_reload+0x118>
 2dd0f05:	vbroadcasti32x4 -0x23b6bef(%rip),%zmm2        # a1a320 <switch.table.ir_if_convert_test_reload+0x138>
 2dd0f0f:	vbroadcasti32x4 -0x23b6be9(%rip),%zmm3        # a1a330 <switch.table.ir_if_convert_test_reload+0x148>
 2dd0f19:	vbroadcasti32x4 -0x23b6be3(%rip),%zmm4        # a1a340 <switch.table.ir_if_convert_test_reload+0x158>
 2dd0f23:	vbroadcasti32x4 -0x23b6bdd(%rip),%zmm5        # a1a350 <switch.table.ir_if_convert_test_reload+0x168>
 2dd0f2d:	vbroadcasti32x4 -0x23b6bd7(%rip),%zmm6        # a1a360 <switch.table.ir_if_convert_test_reload+0x178>
 2dd0f37:	vbroadcasti32x4 -0x23b6bd1(%rip),%zmm7        # a1a370 <switch.table.ir_if_convert_test_reload+0x188>
 2dd0f41:	vbroadcasti32x4 -0x23b6bcb(%rip),%zmm8        # a1a380 <switch.table.ir_if_convert_test_reload+0x198>
 2dd0f4b:	vbroadcasti32x4 -0x23b6bc5(%rip),%zmm9        # a1a390 <switch.table.ir_if_convert_test_reload+0x1a8>
 2dd0f55:	vbroadcasti32x4 -0x23b6bbf(%rip),%zmm10        # a1a3a0 <switch.table.ir_if_convert_test_reload+0x1b8>
 2dd0f5f:	vbroadcasti32x4 -0x23b6bb9(%rip),%zmm11        # a1a3b0 <switch.table.ir_if_convert_test_reload+0x1c8>
 2dd0f69:	vbroadcasti32x4 -0x23b6bb3(%rip),%zmm12        # a1a3c0 <switch.table.ir_if_convert_test_reload+0x1d8>
 2dd0f73:	vbroadcasti32x4 -0x23b6bad(%rip),%zmm13        # a1a3d0 <switch.table.ir_if_convert_test_reload+0x1e8>
 2dd0f7d:	vbroadcasti32x4 -0x23b6ba7(%rip),%zmm14        # a1a3e0 <switch.table.ir_if_convert_test_reload+0x1f8>
 2dd0f87:	mov    0x30(%rsp),%r8
 2dd0f8c:	jmp    2dd06f0 <fast_pp_skip_inactive+0x310>
 2dd0f91:	lea    0x7c(%rsp),%rdx
 2dd0f96:	mov    %rcx,%rsi
 2dd0f99:	mov    %rcx,%r15
 2dd0f9c:	vzeroupper
 2dd0f9f:	call   45dd490 <fast_skip_line_comment>
 2dd0fa4:	xor    %ecx,%ecx
 2dd0fa6:	vbroadcasti32x4 -0x23b6cb0(%rip),%zmm1        # a1a300 <switch.table.ir_if_convert_test_reload+0x118>
 2dd0fb0:	vbroadcasti32x4 -0x23b6c9a(%rip),%zmm2        # a1a320 <switch.table.ir_if_convert_test_reload+0x138>
 2dd0fba:	vbroadcasti32x4 -0x23b6c94(%rip),%zmm3        # a1a330 <switch.table.ir_if_convert_test_reload+0x148>
 2dd0fc4:	vbroadcasti32x4 -0x23b6c8e(%rip),%zmm4        # a1a340 <switch.table.ir_if_convert_test_reload+0x158>
 2dd0fce:	vbroadcasti32x4 -0x23b6c88(%rip),%zmm5        # a1a350 <switch.table.ir_if_convert_test_reload+0x168>
 2dd0fd8:	vbroadcasti32x4 -0x23b6c82(%rip),%zmm6        # a1a360 <switch.table.ir_if_convert_test_reload+0x178>
 2dd0fe2:	vbroadcasti32x4 -0x23b6c7c(%rip),%zmm7        # a1a370 <switch.table.ir_if_convert_test_reload+0x188>
 2dd0fec:	vbroadcasti32x4 -0x23b6c76(%rip),%zmm8        # a1a380 <switch.table.ir_if_convert_test_reload+0x198>
 2dd0ff6:	vbroadcasti32x4 -0x23b6c70(%rip),%zmm9        # a1a390 <switch.table.ir_if_convert_test_reload+0x1a8>
 2dd1000:	vbroadcasti32x4 -0x23b6c6a(%rip),%zmm10        # a1a3a0 <switch.table.ir_if_convert_test_reload+0x1b8>
 2dd100a:	vbroadcasti32x4 -0x23b6c64(%rip),%zmm11        # a1a3b0 <switch.table.ir_if_convert_test_reload+0x1c8>
 2dd1014:	vbroadcasti32x4 -0x23b6c5e(%rip),%zmm12        # a1a3c0 <switch.table.ir_if_convert_test_reload+0x1d8>
 2dd101e:	vbroadcasti32x4 -0x23b6c58(%rip),%zmm13        # a1a3d0 <switch.table.ir_if_convert_test_reload+0x1e8>
 2dd1028:	vbroadcasti32x4 -0x23b6c52(%rip),%zmm14        # a1a3e0 <switch.table.ir_if_convert_test_reload+0x1f8>
 2dd1032:	mov    %ebp,%r11d
 2dd1035:	mov    0x30(%rsp),%r8
 2dd103a:	add    0x7c(%rsp),%r11d
 2dd103f:	mov    0x68(%rsp),%rbp
 2dd1044:	xor    %esi,%esi
 2dd1046:	xor    %r13d,%r13d
 2dd1049:	xor    %edx,%edx
 2dd104b:	xor    %r14d,%r14d
 2dd104e:	mov    %rax,0x8(%rsp)
 2dd1053:	mov    %rax,%r10
 2dd1056:	mov    %r15,%r9
 2dd1059:	jmp    2dd06f0 <fast_pp_skip_inactive+0x310>
 2dd105e:	cmpb   $0x27,0x50(%rsp)
 2dd1063:	jne    2dd10c3 <fast_pp_skip_inactive+0xce3>
 2dd1065:	mov    0x58(%rsp),%rax
 2dd106a:	cmpb   $0x0,0xe979(%rax)
 2dd1071:	je     2dd10c3 <fast_pp_skip_inactive+0xce3>
 2dd1073:	mov    0x48(%rsp),%rax
 2dd1078:	lea    0x0(%r13,%rbp,1),%rcx
 2dd107d:	cmp    (%rax),%rcx
 2dd1080:	jbe    2dd10c3 <fast_pp_skip_inactive+0xce3>
 2dd1082:	movzbl -0x1(%r13,%rbp,1),%eax
 2dd1088:	lea    -0x23b328f(%rip),%rcx        # a1de00 <fast_char_class>
 2dd108f:	testb  $0x1,(%rax,%rcx,1)
 2dd1093:	je     2dd10c3 <fast_pp_skip_inactive+0xce3>
 2dd1095:	jmp    2dd1f06 <fast_pp_skip_inactive+0x1b26>
 2dd109a:	mov    0x48(%rsp),%rax
 2dd109f:	lea    0x0(%r13,%rbp,1),%rsi
 2dd10a4:	mov    (%rax),%rdi
 2dd10a7:	mov    0x58(%rsp),%rax
 2dd10ac:	movzbl 0xe9d0(%rax),%edx
 2dd10b3:	vzeroupper
 2dd10b6:	call   45df0d0 <fast_raw_string_before>
 2dd10bb:	test   %al,%al
 2dd10bd:	jne    2dd20be <fast_pp_skip_inactive+0x1cde>
 2dd10c3:	lea    0x0(%r13,%rbp,1),%rax
 2dd10c8:	cmp    0x28(%rsp),%rax
 2dd10cd:	jae    2dd1251 <fast_pp_skip_inactive+0xe71>
 2dd10d3:	mov    0x18(%rsp),%rcx
 2dd10d8:	sub    %r13,%rcx
 2dd10db:	sub    %rbp,%rcx
 2dd10de:	cmp    $0x8,%rcx
 2dd10e2:	jb     2dd123c <fast_pp_skip_inactive+0xe5c>
 2dd10e8:	mov    %rcx,%rsi
 2dd10eb:	cmp    $0x40,%rcx
 2dd10ef:	jae    2dd10f8 <fast_pp_skip_inactive+0xd18>
 2dd10f1:	xor    %ecx,%ecx
 2dd10f3:	jmp    2dd11cc <fast_pp_skip_inactive+0xdec>
 2dd10f8:	mov    %r12,%rdx
 2dd10fb:	and    $0xffffffffffffffc0,%rdx
 2dd10ff:	lea    0x0(%r13,%rbp,1),%rax
 2dd1104:	mov    %rsi,%rcx
 2dd1107:	and    $0xffffffffffffffc0,%rcx
 2dd110b:	vmovd  %r15d,%xmm0
 2dd1110:	vpxor  %xmm1,%xmm1,%xmm1
 2dd1114:	vpxor  %xmm2,%xmm2,%xmm2
 2dd1118:	vpxor  %xmm3,%xmm3,%xmm3
 2dd111c:	add    %rdx,%rax
 2dd111f:	vpbroadcastb -0x23b55a8(%rip),%xmm4        # a1bb80 <fast_operand_complex_class+0xdf8>
 2dd1128:	vpcmpeqb -0x30(%rbx),%xmm4,%k0
 2dd112f:	vpcmpeqb -0x20(%rbx),%xmm4,%k1
 2dd1136:	vpcmpeqb -0x10(%rbx),%xmm4,%k2
 2dd113d:	vpcmpeqb (%rbx),%xmm4,%k3
 2dd1143:	add    $0x40,%rbx
 2dd1147:	add    $0xffffffffffffffc0,%rdx
 2dd114b:	vpmovm2d %k0,%zmm4
 2dd1151:	vpaddd %zmm4,%zmm0,%zmm0
 2dd1157:	vpmovm2d %k1,%zmm4
 2dd115d:	vpaddd %zmm4,%zmm1,%zmm1
 2dd1163:	vpmovm2d %k2,%zmm4
 2dd1169:	vpaddd %zmm4,%zmm2,%zmm2
 2dd116f:	vpmovm2d %k3,%zmm4
 2dd1175:	vpaddd %zmm4,%zmm3,%zmm3
 2dd117b:	jne    2dd111f <fast_pp_skip_inactive+0xd3f>
 2dd117d:	vpaddd %zmm0,%zmm1,%zmm0
 2dd1183:	vpaddd %zmm0,%zmm2,%zmm0
 2dd1189:	vpaddd %zmm0,%zmm3,%zmm0
 2dd118f:	vextracti64x4 $0x1,%zmm0,%ymm1
 2dd1196:	vpaddd %zmm1,%zmm0,%zmm0
 2dd119c:	vextracti128 $0x1,%ymm0,%xmm1
 2dd11a2:	vpaddd %xmm1,%xmm0,%xmm0
 2dd11a6:	vpshufd $0xee,%xmm0,%xmm1
 2dd11ab:	vpaddd %xmm1,%xmm0,%xmm0
 2dd11af:	vpshufd $0x55,%xmm0,%xmm1
 2dd11b4:	vpaddd %xmm1,%xmm0,%xmm0
 2dd11b8:	vmovd  %xmm0,%r15d
 2dd11bd:	cmp    %rcx,%rsi
 2dd11c0:	je     2dd1251 <fast_pp_skip_inactive+0xe71>
 2dd11c6:	test   $0x38,%sil
 2dd11ca:	je     2dd123c <fast_pp_skip_inactive+0xe5c>
 2dd11cc:	add    %rcx,0x20(%rsp)
 2dd11d1:	and    $0xfffffffffffffff8,%r12
 2dd11d5:	lea    0x0(%r13,%rbp,1),%rax
 2dd11da:	mov    %rsi,%rdx
 2dd11dd:	and    $0xfffffffffffffff8,%rdx
 2dd11e1:	vmovd  %r15d,%xmm0
 2dd11e6:	add    %r12,%rax
 2dd11e9:	sub    %rcx,%r12
 2dd11ec:	xor    %ecx,%ecx
 2dd11ee:	mov    0x20(%rsp),%r8
 2dd11f3:	vmovq  (%r8,%rcx,1),%xmm1
 2dd11f9:	add    $0x8,%rcx
 2dd11fd:	vpcmpeqb -0x23b6ef7(%rip),%xmm1,%k0        # a1a310 <switch.table.ir_if_convert_test_reload+0x128>
 2dd1207:	vpmovm2d %k0,%ymm1
 2dd120d:	vpaddd %ymm1,%ymm0,%ymm0
 2dd1211:	cmp    %rcx,%r12
 2dd1214:	jne    2dd11ee <fast_pp_skip_inactive+0xe0e>
 2dd1216:	vextracti128 $0x1,%ymm0,%xmm1
 2dd121c:	vpaddd %xmm1,%xmm0,%xmm0
 2dd1220:	vpshufd $0xee,%xmm0,%xmm1
 2dd1225:	vpaddd %xmm1,%xmm0,%xmm0
 2dd1229:	vpshufd $0x55,%xmm0,%xmm1
 2dd122e:	vpaddd %xmm1,%xmm0,%xmm0
 2dd1232:	vmovd  %xmm0,%r15d
 2dd1237:	cmp    %rdx,%rsi
 2dd123a:	je     2dd1251 <fast_pp_skip_inactive+0xe71>
 2dd123c:	xor    %ecx,%ecx
 2dd123e:	cmpb   $0xa,(%rax)
 2dd1241:	sete   %cl
 2dd1244:	inc    %rax
 2dd1247:	sub    %ecx,%r15d
 2dd124a:	cmp    0x28(%rsp),%rax
 2dd124f:	jb     2dd123c <fast_pp_skip_inactive+0xe5c>
 2dd1251:	lea    0x1(%r13,%rbp,1),%rax
 2dd1256:	mov    %rax,%rdi
 2dd1259:	cmp    %r14,%rax
 2dd125c:	jb     2dd1272 <fast_pp_skip_inactive+0xe92>
 2dd125e:	xor    %ecx,%ecx
 2dd1260:	jmp    2dd12b3 <fast_pp_skip_inactive+0xed3>
 2dd1262:	mov    %rdi,%rdx
 2dd1265:	add    %rax,%rdx
 2dd1268:	xor    %ecx,%ecx
 2dd126a:	mov    %rdx,%rdi
 2dd126d:	cmp    %r14,%rdx
 2dd1270:	jae    2dd12b3 <fast_pp_skip_inactive+0xed3>
 2dd1272:	movzbl (%rdi),%ecx
 2dd1275:	cmp    0x50(%rsp),%cl
 2dd1279:	je     2dd12a5 <fast_pp_skip_inactive+0xec5>
 2dd127b:	cmp    $0xa,%cl
 2dd127e:	je     2dd12a5 <fast_pp_skip_inactive+0xec5>
 2dd1280:	mov    $0x1,%eax
 2dd1285:	cmp    $0x5c,%cl
 2dd1288:	jne    2dd1262 <fast_pp_skip_inactive+0xe82>
 2dd128a:	lea    0x1(%rdi),%rcx
 2dd128e:	cmp    %r14,%rcx
 2dd1291:	jae    2dd1262 <fast_pp_skip_inactive+0xe82>
 2dd1293:	xor    %eax,%eax
 2dd1295:	cmpb   $0xa,(%rcx)
 2dd1298:	sete   %al
 2dd129b:	add    %eax,%r15d
 2dd129e:	mov    $0x2,%eax
 2dd12a3:	jmp    2dd1262 <fast_pp_skip_inactive+0xe82>
 2dd12a5:	xor    %eax,%eax
 2dd12a7:	cmp    0x50(%rsp),%cl
 2dd12ab:	sete   %al
 2dd12ae:	xor    %ecx,%ecx
 2dd12b0:	add    %rax,%rdi
 2dd12b3:	xor    %esi,%esi
 2dd12b5:	xor    %r13d,%r13d
 2dd12b8:	xor    %edx,%edx
 2dd12ba:	xor    %ebx,%ebx
 2dd12bc:	mov    %rdi,0x8(%rsp)
 2dd12c1:	mov    %rdi,%r10
 2dd12c4:	mov    %r15d,%r11d
 2dd12c7:	jmp    2dd0bc5 <fast_pp_skip_inactive+0x7e5>
 2dd12cc:	cmp    %r9,%r10
 2dd12cf:	jae    2dd1eb3 <fast_pp_skip_inactive+0x1ad3>
 2dd12d5:	vbroadcasti32x4 -0x23b6fdf(%rip),%zmm2        # a1a300 <switch.table.ir_if_convert_test_reload+0x118>
 2dd12df:	vbroadcasti32x4 -0x23b6fc9(%rip),%zmm3        # a1a320 <switch.table.ir_if_convert_test_reload+0x138>
 2dd12e9:	vbroadcasti32x4 -0x23b6fc3(%rip),%zmm4        # a1a330 <switch.table.ir_if_convert_test_reload+0x148>
 2dd12f3:	vbroadcasti32x4 -0x23b6fbd(%rip),%zmm5        # a1a340 <switch.table.ir_if_convert_test_reload+0x158>
 2dd12fd:	vbroadcasti32x4 -0x23b6fb7(%rip),%zmm6        # a1a350 <switch.table.ir_if_convert_test_reload+0x168>
 2dd1307:	vbroadcasti32x4 -0x23b6fb1(%rip),%zmm7        # a1a360 <switch.table.ir_if_convert_test_reload+0x178>
 2dd1311:	vbroadcasti32x4 -0x23b6fab(%rip),%zmm8        # a1a370 <switch.table.ir_if_convert_test_reload+0x188>
 2dd131b:	vbroadcasti32x4 -0x23b6fa5(%rip),%zmm9        # a1a380 <switch.table.ir_if_convert_test_reload+0x198>
 2dd1325:	vbroadcasti32x4 -0x23b6f9f(%rip),%zmm10        # a1a390 <switch.table.ir_if_convert_test_reload+0x1a8>
 2dd132f:	vbroadcasti32x4 -0x23b6f99(%rip),%zmm11        # a1a3a0 <switch.table.ir_if_convert_test_reload+0x1b8>
 2dd1339:	vbroadcasti32x4 -0x23b6f93(%rip),%zmm12        # a1a3b0 <switch.table.ir_if_convert_test_reload+0x1c8>
 2dd1343:	vbroadcasti32x4 -0x23b6f8d(%rip),%zmm13        # a1a3c0 <switch.table.ir_if_convert_test_reload+0x1d8>
 2dd134d:	vbroadcasti32x4 -0x23b6f87(%rip),%zmm14        # a1a3d0 <switch.table.ir_if_convert_test_reload+0x1e8>
 2dd1357:	vpbroadcastb -0x23b57e0(%rip),%xmm15        # a1bb80 <fast_operand_complex_class+0xdf8>
 2dd1360:	vpbroadcastb -0x23b57ea(%rip),%xmm16        # a1bb80 <fast_operand_complex_class+0xdf8>
 2dd136a:	lea    -0x23aa289(%rip),%rax        # a270e8 <fast_cc_binary_questioned.range_narrow+0x29a8>
 2dd1371:	mov    %rsi,0x48(%rsp)
 2dd1376:	mov    %r15,0x58(%rsp)
 2dd137b:	mov    %r9,0x38(%rsp)
 2dd1380:	movq   $0x0,0x28(%rsp)
 2dd1389:	movq   $0x0,0x70(%rsp)
 2dd1392:	movq   $0x0,0x88(%rsp)
 2dd139e:	movq   $0x0,0x10(%rsp)
 2dd13a7:	xor    %r8d,%r8d
 2dd13aa:	xor    %edi,%edi
 2dd13ac:	xor    %r14d,%r14d
 2dd13af:	xor    %ecx,%ecx
 2dd13b1:	mov    %r10,0x8(%rsp)
 2dd13b6:	mov    %rax,0xa0(%rsp)
 2dd13be:	xchg   %ax,%ax
 2dd13c0:	mov    0x38(%rsp),%rdx
 2dd13c5:	mov    %rcx,0x20(%rsp)
 2dd13ca:	mov    %r14,0x18(%rsp)
 2dd13cf:	mov    %rbx,%r13
 2dd13d2:	mov    %r11d,%eax
 2dd13d5:	sub    %r10,%rdx
 2dd13d8:	cmp    $0x40,%rdx
 2dd13dc:	jb     2dd1550 <fast_pp_skip_inactive+0x1170>
 2dd13e2:	vmovdqu64 (%r10),%zmm0
 2dd13e8:	mov    %r10,%rsi
 2dd13eb:	mov    $0x40,%edx
 2dd13f0:	vpcmpeqb %zmm4,%zmm0,%k1
 2dd13f6:	vpcmpeqb %zmm5,%zmm0,%k2
 2dd13fc:	vpcmpeqb %zmm7,%zmm0,%k3
 2dd1402:	mov    $0xffffffffffffffff,%rcx
 2dd1409:	vpaddb %zmm10,%zmm0,%zmm1
 2dd140f:	vpcmpeqb %zmm2,%zmm0,%k0
 2dd1415:	xor    %ebp,%ebp
 2dd1417:	korq   %k1,%k2,%k2
 2dd141c:	kmovq  %k1,%rbx
 2dd1421:	vpcmpeqb %zmm6,%zmm0,%k1
 2dd1427:	bzhi   %rdx,%rcx,%r11
 2dd142c:	kmovq  %k0,%r9
 2dd1431:	vpcmpeqb %zmm3,%zmm0,%k0
 2dd1437:	korq   %k3,%k1,%k1
 2dd143c:	vpcmpeqb %zmm9,%zmm0,%k3
 2dd1442:	mov    %r11,%r12
 2dd1445:	not    %r12
 2dd1448:	kmovq  %k3,%r14
 2dd144d:	vpcmpltub %zmm11,%zmm1,%k3
 2dd1454:	kmovq  %k1,%rcx
 2dd1459:	vpcmpeqb %zmm8,%zmm0,%k1
 2dd145f:	vpandq %zmm12,%zmm0,%zmm1
 2dd1465:	kmovq  %k3,%r15
 2dd146a:	or     %r14,%r12
 2dd146d:	lea    (%r9,%r9,1),%r14
 2dd1471:	andn   %r15,%r9,%r15
 2dd1476:	or     %r13,%r14
 2dd1479:	kmovq  %k1,%r13
 2dd147e:	vpcmpeqb %zmm13,%zmm1,%k1
 2dd1484:	or     %r15,%r12
 2dd1487:	mov    %r12,%r10
 2dd148a:	and    %r14,%r10
 2dd148d:	add    %r12,%r10
 2dd1490:	setb   %r15b
 2dd1494:	or     %r14,%r10
 2dd1497:	andn   %r10,%r12,%r14
 2dd149c:	lea    0x0(%r13,%r13,1),%r10
 2dd14a1:	lea    (%rbx,%rbx,1),%r12
 2dd14a5:	or     %r8,%r10
 2dd14a8:	mov    0x10(%rsp),%r8
 2dd14ad:	or     %rdi,%r12
 2dd14b0:	kmovq  %k2,%rdi
 2dd14b5:	vpcmpeqb %zmm14,%zmm0,%k2
 2dd14bb:	and    %rdi,%r12
 2dd14be:	mov    %r9,%rdi
 2dd14c1:	not    %rdi
 2dd14c4:	korq   %k1,%k2,%k1
 2dd14c9:	or     %r10,%rdi
 2dd14cc:	add    $0xff,%r8b
 2dd14d0:	adc    %rdi,%rcx
 2dd14d3:	setb   %r8b
 2dd14d7:	andn   %rdi,%rcx,%rcx
 2dd14dc:	mov    %r8,0x10(%rsp)
 2dd14e1:	kmovq  %k1,%r8
 2dd14e6:	and    %r10,%r8
 2dd14e9:	and    %r13,%r10
 2dd14ec:	or     %r8,%r10
 2dd14ef:	kmovq  %k0,%r8
 2dd14f4:	and    %r14,%r8
 2dd14f7:	or     %r10,%r12
 2dd14fa:	or     %r8,%r12
 2dd14fd:	and    %r11,%r12
 2dd1500:	jne    2dd1572 <fast_pp_skip_inactive+0x1192>
 2dd1502:	popcnt %r9,%rdi
 2dd1507:	mov    %r15b,%bpl
 2dd150a:	shr    $0x3f,%r9
 2dd150e:	shr    $0x3f,%r13
 2dd1512:	shr    $0x3f,%rbx
 2dd1516:	mov    %eax,%r11d
 2dd1519:	mov    %rsi,%r10
 2dd151c:	add    %rdx,%r10
 2dd151f:	shr    $0x3f,%r14
 2dd1523:	shr    $0x3f,%rcx
 2dd1527:	xor    %edx,%edx
 2dd1529:	or     %rbp,%r9
 2dd152c:	add    %edi,%r11d
 2dd152f:	mov    %rbx,%rdi
 2dd1532:	mov    %r13,%r8
 2dd1535:	mov    %r9,%rbx
 2dd1538:	cmp    0x38(%rsp),%r10
 2dd153d:	jae    2dd1fb8 <fast_pp_skip_inactive+0x1bd8>
 2dd1543:	test   %dl,%dl
 2dd1545:	je     2dd13c0 <fast_pp_skip_inactive+0xfe0>
 2dd154b:	jmp    2dd1fb8 <fast_pp_skip_inactive+0x1bd8>
 2dd1550:	mov    $0xffffffffffffffff,%rcx
 2dd1557:	mov    %r10,%rsi
 2dd155a:	shlx   %rdx,%rcx,%rcx
 2dd155f:	not    %rcx
 2dd1562:	kmovq  %rcx,%k1
 2dd1567:	vmovdqu8 (%r10),%zmm0{%k1}{z}
 2dd156d:	jmp    2dd13f0 <fast_pp_skip_inactive+0x1010>
 2dd1572:	xor    %ebp,%ebp
 2dd1574:	tzcnt  %r12,%rbp
 2dd1579:	mov    %eax,%r11d
 2dd157c:	bt     %rbp,%r8
 2dd1580:	jae    2dd1594 <fast_pp_skip_inactive+0x11b4>
 2dd1582:	mov    0x38(%rsp),%rbx
 2dd1587:	shrx   %rbp,%rcx,%rdx
 2dd158c:	mov    $0x1,%r12b
 2dd158f:	and    $0x1,%edx
 2dd1592:	jmp    2dd15cd <fast_pp_skip_inactive+0x11ed>
 2dd1594:	mov    $0xffffffff,%eax
 2dd1599:	mov    0x38(%rsp),%rbx
 2dd159e:	mov    0x18(%rsp),%rdi
 2dd15a3:	add    %ebp,%eax
 2dd15a5:	shrx   %rax,%r14,%rdx
 2dd15aa:	and    $0x1,%edx
 2dd15ad:	test   %rbp,%rbp
 2dd15b0:	cmovne %edx,%edi
 2dd15b3:	test   %edi,%edi
 2dd15b5:	setne  %r12b
 2dd15b9:	test   %rbp,%rbp
 2dd15bc:	je     2dd15c8 <fast_pp_skip_inactive+0x11e8>
 2dd15be:	shrx   %rax,%rcx,%rdx
 2dd15c3:	and    $0x1,%edx
 2dd15c6:	jmp    2dd15cd <fast_pp_skip_inactive+0x11ed>
 2dd15c8:	mov    0x20(%rsp),%rdx
 2dd15cd:	mov    $0xffffffffffffffff,%rdi
 2dd15d4:	shrx   %rbp,%r8,%rcx
 2dd15d9:	lea    (%rsi,%rbp,1),%r8
 2dd15dd:	bzhi   %rbp,%rdi,%rdi
 2dd15e2:	mov    %rcx,%rax
 2dd15e5:	or     $0xfffffffffffffffe,%rax
 2dd15e9:	and    %r9,%rdi
 2dd15ec:	lea    (%r8,%rax,1),%r13
 2dd15f0:	popcnt %rdi,%rdi
 2dd15f5:	add    %edi,%r11d
 2dd15f8:	mov    %r11d,0x4(%rsp)
 2dd15fd:	test   %edx,%edx
 2dd15ff:	jne    2dd1b54 <fast_pp_skip_inactive+0x1774>
 2dd1605:	test   $0x1,%cl
 2dd1608:	je     2dd1660 <fast_pp_skip_inactive+0x1280>
 2dd160a:	mov    0x38(%rsp),%rsi
 2dd160f:	mov    0x58(%rsp),%r14
 2dd1614:	add    $0x2,%r13
 2dd1618:	mov    %r13,%rdi
 2dd161b:	vzeroupper
 2dd161e:	call   45db790 <fast_skip_hspace>
 2dd1623:	mov    0x38(%rsp),%rsi
 2dd1628:	cmp    %rsi,%rax
 2dd162b:	jae    2dd1641 <fast_pp_skip_inactive+0x1261>
 2dd162d:	movzbl (%rax),%ebx
 2dd1630:	lea    -0x23b3837(%rip),%rcx        # a1de00 <fast_char_class>
 2dd1637:	testb  $0x2,(%rbx,%rcx,1)
 2dd163b:	jne    2dd17ad <fast_pp_skip_inactive+0x13cd>
 2dd1641:	xor    %edx,%edx
 2dd1643:	xor    %edi,%edi
 2dd1645:	xor    %r8d,%r8d
 2dd1648:	movq   $0x0,0x10(%rsp)
 2dd1651:	xor    %ebx,%ebx
 2dd1653:	mov    %rax,%r10
 2dd1656:	mov    %rax,0x8(%rsp)
 2dd165b:	jmp    2dd1a1e <fast_pp_skip_inactive+0x163e>
 2dd1660:	mov    0x58(%rsp),%r14
 2dd1665:	shrx   %rbp,%r10,%rax
 2dd166a:	test   $0x1,%al
 2dd166c:	je     2dd1765 <fast_pp_skip_inactive+0x1385>
 2dd1672:	add    $0x2,%r13
 2dd1676:	mov    %rbx,%rsi
 2dd1679:	mov    %r13,%rdi
 2dd167c:	vzeroupper
 2dd167f:	call   45df190 <fast_skip_splices>
 2dd1684:	cmp    %rbx,%rax
 2dd1687:	jae    2dd17ef <fast_pp_skip_inactive+0x140f>
 2dd168d:	vbroadcasti32x4 -0x23b7397(%rip),%zmm2        # a1a300 <switch.table.ir_if_convert_test_reload+0x118>
 2dd1697:	vbroadcasti32x4 -0x23b7381(%rip),%zmm3        # a1a320 <switch.table.ir_if_convert_test_reload+0x138>
 2dd16a1:	vbroadcasti32x4 -0x23b737b(%rip),%zmm4        # a1a330 <switch.table.ir_if_convert_test_reload+0x148>
 2dd16ab:	vbroadcasti32x4 -0x23b7375(%rip),%zmm5        # a1a340 <switch.table.ir_if_convert_test_reload+0x158>
 2dd16b5:	vbroadcasti32x4 -0x23b736f(%rip),%zmm6        # a1a350 <switch.table.ir_if_convert_test_reload+0x168>
 2dd16bf:	vbroadcasti32x4 -0x23b7369(%rip),%zmm7        # a1a360 <switch.table.ir_if_convert_test_reload+0x178>
 2dd16c9:	vbroadcasti32x4 -0x23b7363(%rip),%zmm8        # a1a370 <switch.table.ir_if_convert_test_reload+0x188>
 2dd16d3:	vbroadcasti32x4 -0x23b735d(%rip),%zmm9        # a1a380 <switch.table.ir_if_convert_test_reload+0x198>
 2dd16dd:	vbroadcasti32x4 -0x23b7357(%rip),%zmm10        # a1a390 <switch.table.ir_if_convert_test_reload+0x1a8>
 2dd16e7:	vbroadcasti32x4 -0x23b7351(%rip),%zmm11        # a1a3a0 <switch.table.ir_if_convert_test_reload+0x1b8>
 2dd16f1:	vbroadcasti32x4 -0x23b734b(%rip),%zmm12        # a1a3b0 <switch.table.ir_if_convert_test_reload+0x1c8>
 2dd16fb:	vbroadcasti32x4 -0x23b7345(%rip),%zmm13        # a1a3c0 <switch.table.ir_if_convert_test_reload+0x1d8>
 2dd1705:	vbroadcasti32x4 -0x23b733f(%rip),%zmm14        # a1a3d0 <switch.table.ir_if_convert_test_reload+0x1e8>
 2dd170f:	vpbroadcastb -0x23b5b98(%rip),%xmm15        # a1bb80 <fast_operand_complex_class+0xdf8>
 2dd1718:	vpbroadcastb -0x23b5ba2(%rip),%xmm16        # a1bb80 <fast_operand_complex_class+0xdf8>
 2dd1722:	movzbl (%rax),%ecx
 2dd1725:	mov    0x4(%rsp),%r11d
 2dd172a:	xor    %edi,%edi
 2dd172c:	movq   $0x0,0x10(%rsp)
 2dd1735:	xor    %edx,%edx
 2dd1737:	add    $0xffffffb2,%ecx
 2dd173a:	cmp    $0x27,%ecx
 2dd173d:	ja     2dd1753 <fast_pp_skip_inactive+0x1373>
 2dd173f:	movabs $0x8000000081,%rax
 2dd1749:	bt     %rcx,%rax
 2dd174d:	jb     2dd1f88 <fast_pp_skip_inactive+0x1ba8>
 2dd1753:	mov    %r13,0x8(%rsp)
 2dd1758:	xor    %r8d,%r8d
 2dd175b:	xor    %ebx,%ebx
 2dd175d:	mov    %r13,%r10
 2dd1760:	jmp    2dd1ab8 <fast_pp_skip_inactive+0x16d8>
 2dd1765:	movl   $0x0,0x78(%rsp)
 2dd176d:	lea    0x3(%r13),%rdi
 2dd1771:	cmpb   $0x2a,0x2(%r13)
 2dd1776:	jne    2dd180e <fast_pp_skip_inactive+0x142e>
 2dd177c:	lea    0x78(%rsp),%rdx
 2dd1781:	mov    %rbx,%rsi
 2dd1784:	vzeroupper
 2dd1787:	call   45dd3a0 <fast_skip_block_comment>
 2dd178c:	test   %rax,%rax
 2dd178f:	jne    2dd181e <fast_pp_skip_inactive+0x143e>
 2dd1795:	lea    -0x23aa658(%rip),%rsi        # a27144 <fast_cc_binary_questioned.range_narrow+0x2a04>
 2dd179c:	mov    %r14,%rdi
 2dd179f:	call   45daab9 <fast_pp_bail>
 2dd17a4:	mov    0x38(%rsp),%rax
 2dd17a9:	mov    $0x1,%dl
 2dd17ab:	jmp    2dd1820 <fast_pp_skip_inactive+0x1440>
 2dd17ad:	mov    %rax,%rdi
 2dd17b0:	mov    %rax,%r15
 2dd17b3:	call   45ddbf0 <fast_scan_ident_len>
 2dd17b8:	lea    -0x2(%rax),%ecx
 2dd17bb:	mov    %r15,%rsi
 2dd17be:	cmp    $0x6,%ecx
 2dd17c1:	ja     2dd19ff <fast_pp_skip_inactive+0x161f>
 2dd17c7:	lea    -0x23ad47e(%rip),%rdx        # a24350 <c_direct_test_dependencies.levels+0x73>
 2dd17ce:	movslq (%rdx,%rcx,4),%rcx
 2dd17d2:	add    %rdx,%rcx
 2dd17d5:	jmp    *%rcx
 2dd17d7:	cmp    $0x69,%bl
 2dd17da:	jne    2dd19ff <fast_pp_skip_inactive+0x161f>
 2dd17e0:	cmpb   $0x66,0x1(%rsi)
 2dd17e4:	je     2dd19a6 <fast_pp_skip_inactive+0x15c6>
 2dd17ea:	jmp    2dd19ff <fast_pp_skip_inactive+0x161f>
 2dd17ef:	xor    %edx,%edx
 2dd17f1:	mov    %r13,0x8(%rsp)
 2dd17f6:	xor    %edi,%edi
 2dd17f8:	xor    %r8d,%r8d
 2dd17fb:	movq   $0x0,0x10(%rsp)
 2dd1804:	xor    %ebx,%ebx
 2dd1806:	mov    %r13,%r10
 2dd1809:	jmp    2dd1a1e <fast_pp_skip_inactive+0x163e>
 2dd180e:	lea    0x78(%rsp),%rdx
 2dd1813:	mov    %rbx,%rsi
 2dd1816:	vzeroupper
 2dd1819:	call   45dd490 <fast_skip_line_comment>
 2dd181e:	xor    %edx,%edx
 2dd1820:	vbroadcasti32x4 -0x23b752a(%rip),%zmm2        # a1a300 <switch.table.ir_if_convert_test_reload+0x118>
 2dd182a:	vbroadcasti32x4 -0x23b7514(%rip),%zmm3        # a1a320 <switch.table.ir_if_convert_test_reload+0x138>
 2dd1834:	vbroadcasti32x4 -0x23b750e(%rip),%zmm4        # a1a330 <switch.table.ir_if_convert_test_reload+0x148>
 2dd183e:	vbroadcasti32x4 -0x23b7508(%rip),%zmm5        # a1a340 <switch.table.ir_if_convert_test_reload+0x158>
 2dd1848:	vbroadcasti32x4 -0x23b7502(%rip),%zmm6        # a1a350 <switch.table.ir_if_convert_test_reload+0x168>
 2dd1852:	vbroadcasti32x4 -0x23b74fc(%rip),%zmm7        # a1a360 <switch.table.ir_if_convert_test_reload+0x178>
 2dd185c:	vbroadcasti32x4 -0x23b74f6(%rip),%zmm8        # a1a370 <switch.table.ir_if_convert_test_reload+0x188>
 2dd1866:	vbroadcasti32x4 -0x23b74f0(%rip),%zmm9        # a1a380 <switch.table.ir_if_convert_test_reload+0x198>
 2dd1870:	vbroadcasti32x4 -0x23b74ea(%rip),%zmm10        # a1a390 <switch.table.ir_if_convert_test_reload+0x1a8>
 2dd187a:	vbroadcasti32x4 -0x23b74e4(%rip),%zmm11        # a1a3a0 <switch.table.ir_if_convert_test_reload+0x1b8>
 2dd1884:	vbroadcasti32x4 -0x23b74de(%rip),%zmm12        # a1a3b0 <switch.table.ir_if_convert_test_reload+0x1c8>
 2dd188e:	vbroadcasti32x4 -0x23b74d8(%rip),%zmm13        # a1a3c0 <switch.table.ir_if_convert_test_reload+0x1d8>
 2dd1898:	vbroadcasti32x4 -0x23b74d2(%rip),%zmm14        # a1a3d0 <switch.table.ir_if_convert_test_reload+0x1e8>
 2dd18a2:	vpbroadcastb -0x23b5d2b(%rip),%xmm15        # a1bb80 <fast_operand_complex_class+0xdf8>
 2dd18ab:	vpbroadcastb -0x23b5d35(%rip),%xmm16        # a1bb80 <fast_operand_complex_class+0xdf8>
 2dd18b5:	mov    0x4(%rsp),%r11d
 2dd18ba:	mov    0x18(%rsp),%r14
 2dd18bf:	mov    0x20(%rsp),%rcx
 2dd18c4:	movzbl %r12b,%ebx
 2dd18c8:	xor    %edi,%edi
 2dd18ca:	xor    %r8d,%r8d
 2dd18cd:	movq   $0x0,0x10(%rsp)
 2dd18d6:	mov    %rax,0x8(%rsp)
 2dd18db:	mov    %rax,%r10
 2dd18de:	add    0x78(%rsp),%r11d
 2dd18e3:	jmp    2dd1538 <fast_pp_skip_inactive+0x1158>
 2dd18e8:	movzbl 0x4(%rsi),%edi
 2dd18ec:	mov    (%rsi),%ecx
 2dd18ee:	mov    $0x65646669,%edx
 2dd18f3:	xor    %edx,%ecx
 2dd18f5:	xor    $0x66,%edi
 2dd18f8:	or     %ecx,%edi
 2dd18fa:	je     2dd19a6 <fast_pp_skip_inactive+0x15c6>
 2dd1900:	movzbl 0x4(%rsi),%edi
 2dd1904:	mov    (%rsi),%ecx
 2dd1906:	mov    $0x69646e65,%edx
 2dd190b:	xor    %edx,%ecx
 2dd190d:	xor    $0x66,%edi
 2dd1910:	or     %ecx,%edi
 2dd1912:	jne    2dd19ff <fast_pp_skip_inactive+0x161f>
 2dd1918:	add    $0x5,%rsi
 2dd191c:	cmpl   $0x0,0x70(%rsp)
 2dd1921:	mov    %rsi,0x8(%rsp)
 2dd1926:	je     2dd2083 <fast_pp_skip_inactive+0x1ca3>
 2dd192c:	mov    0x70(%rsp),%rax
 2dd1931:	mov    0x8(%rsp),%r10
 2dd1936:	xor    %edx,%edx
 2dd1938:	xor    %edi,%edi
 2dd193a:	xor    %r8d,%r8d
 2dd193d:	movq   $0x0,0x10(%rsp)
 2dd1946:	xor    %ebx,%ebx
 2dd1948:	dec    %eax
 2dd194a:	mov    %rax,0x70(%rsp)
 2dd194f:	jmp    2dd1a1e <fast_pp_skip_inactive+0x163e>
 2dd1954:	movabs $0x6665646e66696c65,%rcx
 2dd195e:	cmp    %rcx,(%rsi)
 2dd1961:	jne    2dd19ff <fast_pp_skip_inactive+0x161f>
 2dd1967:	mov    $0x32,%bpl
 2dd196a:	jmp    2dd1ad6 <fast_pp_skip_inactive+0x16f6>
 2dd196f:	cmpl   $0x65736c65,(%rsi)
 2dd1975:	je     2dd1ac7 <fast_pp_skip_inactive+0x16e7>
 2dd197b:	cmpl   $0x66696c65,(%r15)
 2dd1982:	mov    %r15,%rsi
 2dd1985:	jne    2dd19ff <fast_pp_skip_inactive+0x161f>
 2dd1987:	mov    $0x4,%bpl
 2dd198a:	jmp    2dd1aed <fast_pp_skip_inactive+0x170d>
 2dd198f:	movzwl 0x4(%rsi),%edi
 2dd1993:	mov    (%rsi),%ecx
 2dd1995:	mov    $0x646e6669,%edx
 2dd199a:	xor    %edx,%ecx
 2dd199c:	xor    $0x6665,%edi
 2dd19a2:	or     %ecx,%edi
 2dd19a4:	jne    2dd19ff <fast_pp_skip_inactive+0x161f>
 2dd19a6:	mov    0x70(%rsp),%rdx
 2dd19ab:	mov    0x28(%rsp),%rcx
 2dd19b0:	mov    %eax,%eax
 2dd19b2:	add    %rax,%rsi
 2dd19b5:	xor    %eax,%eax
 2dd19b7:	inc    %edx
 2dd19b9:	cmp    $0x40,%edx
 2dd19bc:	mov    %rdx,0x70(%rsp)
 2dd19c1:	setae  %al
 2dd19c4:	or     %eax,%ecx
 2dd19c6:	mov    %rcx,0x28(%rsp)
 2dd19cb:	mov    0x88(%rsp),%rcx
 2dd19d3:	btr    %rdx,%rcx
 2dd19d7:	mov    %rcx,0x88(%rsp)
 2dd19df:	jmp    2dd1a04 <fast_pp_skip_inactive+0x1624>
 2dd19e1:	mov    (%rsi),%ecx
 2dd19e3:	mov    0x3(%rsi),%r8d
 2dd19e7:	mov    $0x66696c65,%edx
 2dd19ec:	mov    $0x66656466,%edi
 2dd19f1:	xor    %edx,%ecx
 2dd19f3:	xor    %edi,%r8d
 2dd19f6:	or     %ecx,%r8d
 2dd19f9:	je     2dd1ad3 <fast_pp_skip_inactive+0x16f3>
 2dd19ff:	mov    %eax,%eax
 2dd1a01:	add    %rax,%rsi
 2dd1a04:	xor    %edx,%edx
 2dd1a06:	xor    %edi,%edi
 2dd1a08:	xor    %r8d,%r8d
 2dd1a0b:	movq   $0x0,0x10(%rsp)
 2dd1a14:	xor    %ebx,%ebx
 2dd1a16:	mov    %rsi,0x8(%rsp)
 2dd1a1b:	mov    %rsi,%r10
 2dd1a1e:	vbroadcasti32x4 -0x23b7728(%rip),%zmm2        # a1a300 <switch.table.ir_if_convert_test_reload+0x118>
 2dd1a28:	vbroadcasti32x4 -0x23b7712(%rip),%zmm3        # a1a320 <switch.table.ir_if_convert_test_reload+0x138>
 2dd1a32:	vbroadcasti32x4 -0x23b770c(%rip),%zmm4        # a1a330 <switch.table.ir_if_convert_test_reload+0x148>
 2dd1a3c:	vbroadcasti32x4 -0x23b7706(%rip),%zmm5        # a1a340 <switch.table.ir_if_convert_test_reload+0x158>
 2dd1a46:	vbroadcasti32x4 -0x23b7700(%rip),%zmm6        # a1a350 <switch.table.ir_if_convert_test_reload+0x168>
 2dd1a50:	vbroadcasti32x4 -0x23b76fa(%rip),%zmm7        # a1a360 <switch.table.ir_if_convert_test_reload+0x178>
 2dd1a5a:	vbroadcasti32x4 -0x23b76f4(%rip),%zmm8        # a1a370 <switch.table.ir_if_convert_test_reload+0x188>
 2dd1a64:	vbroadcasti32x4 -0x23b76ee(%rip),%zmm9        # a1a380 <switch.table.ir_if_convert_test_reload+0x198>
 2dd1a6e:	vbroadcasti32x4 -0x23b76e8(%rip),%zmm10        # a1a390 <switch.table.ir_if_convert_test_reload+0x1a8>
 2dd1a78:	vbroadcasti32x4 -0x23b76e2(%rip),%zmm11        # a1a3a0 <switch.table.ir_if_convert_test_reload+0x1b8>
 2dd1a82:	vbroadcasti32x4 -0x23b76dc(%rip),%zmm12        # a1a3b0 <switch.table.ir_if_convert_test_reload+0x1c8>
 2dd1a8c:	vbroadcasti32x4 -0x23b76d6(%rip),%zmm13        # a1a3c0 <switch.table.ir_if_convert_test_reload+0x1d8>
 2dd1a96:	vbroadcasti32x4 -0x23b76d0(%rip),%zmm14        # a1a3d0 <switch.table.ir_if_convert_test_reload+0x1e8>
 2dd1aa0:	vpbroadcastb -0x23b5f29(%rip),%xmm15        # a1bb80 <fast_operand_complex_class+0xdf8>
 2dd1aa9:	vpbroadcastb -0x23b5f33(%rip),%xmm16        # a1bb80 <fast_operand_complex_class+0xdf8>
 2dd1ab3:	mov    0x4(%rsp),%r11d
 2dd1ab8:	mov    0x18(%rsp),%r14
 2dd1abd:	mov    0x20(%rsp),%rcx
 2dd1ac2:	jmp    2dd1538 <fast_pp_skip_inactive+0x1158>
 2dd1ac7:	mov    $0xffffffffffffffff,%rcx
 2dd1ace:	mov    $0x5,%bpl
 2dd1ad1:	jmp    2dd1aef <fast_pp_skip_inactive+0x170f>
 2dd1ad3:	mov    $0x31,%bpl
 2dd1ad6:	movzbl 0xe979(%r14),%ecx
 2dd1ade:	mov    0x28(%rsp),%rdx
 2dd1ae3:	xor    $0x1,%ecx
 2dd1ae6:	or     %ecx,%edx
 2dd1ae8:	mov    %rdx,0x28(%rsp)
 2dd1aed:	xor    %ecx,%ecx
 2dd1aef:	mov    0x70(%rsp),%rdx
 2dd1af4:	mov    %eax,%eax
 2dd1af6:	add    %rax,%r15
 2dd1af9:	mov    %r15,0x8(%rsp)
 2dd1afe:	test   %edx,%edx
 2dd1b00:	je     2dd2086 <fast_pp_skip_inactive+0x1ca6>
 2dd1b06:	mov    0x88(%rsp),%rsi
 2dd1b0e:	mov    $0x1,%eax
 2dd1b13:	xor    %edi,%edi
 2dd1b15:	xor    %r8d,%r8d
 2dd1b18:	movq   $0x0,0x10(%rsp)
 2dd1b21:	xor    %ebx,%ebx
 2dd1b23:	mov    %r15,%r10
 2dd1b26:	shlx   %rdx,%rax,%rax
 2dd1b2b:	and    %rax,%rcx
 2dd1b2e:	shrx   %rdx,%rsi,%rax
 2dd1b33:	mov    0x28(%rsp),%rdx
 2dd1b38:	or     %rcx,%rsi
 2dd1b3b:	and    $0x1,%eax
 2dd1b3e:	mov    %rsi,0x88(%rsp)
 2dd1b46:	or     %eax,%edx
 2dd1b48:	mov    %rdx,0x28(%rsp)
 2dd1b4d:	xor    %edx,%edx
 2dd1b4f:	jmp    2dd1a1e <fast_pp_skip_inactive+0x163e>
 2dd1b54:	lea    0x1(%rax,%r8,1),%rdi
 2dd1b59:	cmp    0x8(%rsp),%rdi
 2dd1b5e:	jbe    2dd1605 <fast_pp_skip_inactive+0x1225>
 2dd1b64:	vmovdqa64 %zmm2,%zmm5
 2dd1b6a:	xor    %edx,%edx
 2dd1b6c:	mov    %rsi,0x50(%rsp)
 2dd1b71:	jmp    2dd1b82 <fast_pp_skip_inactive+0x17a2>
 2dd1b73:	dec    %rdx
 2dd1b76:	lea    0x1(%r13,%rdx,1),%rsi
 2dd1b7b:	cmp    0x8(%rsp),%rsi
 2dd1b80:	jbe    2dd1b9e <fast_pp_skip_inactive+0x17be>
 2dd1b82:	cmpb   $0xa,0x0(%r13,%rdx,1)
 2dd1b88:	jne    2dd1b73 <fast_pp_skip_inactive+0x1793>
 2dd1b8a:	lea    0x0(%r13,%rdx,1),%rsi
 2dd1b8f:	cmp    0x8(%rsp),%rsi
 2dd1b94:	jbe    2dd1b9e <fast_pp_skip_inactive+0x17be>
 2dd1b96:	cmpb   $0x5c,-0x1(%r13,%rdx,1)
 2dd1b9c:	je     2dd1b73 <fast_pp_skip_inactive+0x1793>
 2dd1b9e:	mov    0x38(%rsp),%rbx
 2dd1ba3:	mov    0x50(%rsp),%rsi
 2dd1ba8:	test   %rdx,%rdx
 2dd1bab:	jns    2dd1605 <fast_pp_skip_inactive+0x1225>
 2dd1bb1:	mov    %rbp,%r8
 2dd1bb4:	add    %rdx,%r8
 2dd1bb7:	mov    %rdx,%r15
 2dd1bba:	neg    %r15
 2dd1bbd:	add    %rax,%r8
 2dd1bc0:	mov    %r15,%r11
 2dd1bc3:	lea    0x31(%rsi,%r8,1),%r14
 2dd1bc8:	lea    0x1(%rsi,%r8,1),%r9
 2dd1bcd:	lea    (%rsi,%r8,1),%rax
 2dd1bd1:	mov    %r8,0x98(%rsp)
 2dd1bd9:	xor    %r8d,%r8d
 2dd1bdc:	mov    %rax,0x10(%rsp)
 2dd1be1:	mov    0x10(%rsp),%rax
 2dd1be6:	movzbl 0x1(%rax,%r8,1),%eax
 2dd1bec:	cmp    $0x22,%eax
 2dd1bef:	je     2dd1c11 <fast_pp_skip_inactive+0x1831>
 2dd1bf1:	cmp    $0x27,%eax
 2dd1bf4:	je     2dd1c11 <fast_pp_skip_inactive+0x1831>
 2dd1bf6:	mov    0x38(%rsp),%rbx
 2dd1bfb:	inc    %r8
 2dd1bfe:	dec    %r11
 2dd1c01:	inc    %r14
 2dd1c04:	inc    %r9
 2dd1c07:	cmp    %r8,%r15
 2dd1c0a:	jne    2dd1be1 <fast_pp_skip_inactive+0x1801>
 2dd1c0c:	jmp    2dd1605 <fast_pp_skip_inactive+0x1225>
 2dd1c11:	mov    0x10(%rsp),%rcx
 2dd1c16:	lea    0x1(%r8,%rcx,1),%rsi
 2dd1c1b:	cmp    $0x27,%al
 2dd1c1d:	jne    2dd1c53 <fast_pp_skip_inactive+0x1873>
 2dd1c1f:	mov    0x58(%rsp),%rcx
 2dd1c24:	cmpb   $0x0,0xe979(%rcx)
 2dd1c2b:	je     2dd1c53 <fast_pp_skip_inactive+0x1873>
 2dd1c2d:	mov    0x48(%rsp),%rcx
 2dd1c32:	cmp    (%rcx),%rsi
 2dd1c35:	jbe    2dd1c53 <fast_pp_skip_inactive+0x1873>
 2dd1c37:	mov    0x10(%rsp),%rcx
 2dd1c3c:	lea    -0x23b3e43(%rip),%r10        # a1de00 <fast_char_class>
 2dd1c43:	movzbl (%r8,%rcx,1),%ecx
 2dd1c48:	testb  $0x1,(%rcx,%r10,1)
 2dd1c4d:	jne    2dd1f97 <fast_pp_skip_inactive+0x1bb7>
 2dd1c53:	cmp    %rdi,%rsi
 2dd1c56:	jae    2dd1ddf <fast_pp_skip_inactive+0x19ff>
 2dd1c5c:	add    %r8,%rdx
 2dd1c5f:	neg    %rdx
 2dd1c62:	cmp    $0x8,%rdx
 2dd1c66:	jb     2dd1dc6 <fast_pp_skip_inactive+0x19e6>
 2dd1c6c:	cmp    $0x40,%rdx
 2dd1c70:	jae    2dd1c79 <fast_pp_skip_inactive+0x1899>
 2dd1c72:	xor    %ecx,%ecx
 2dd1c74:	jmp    2dd1d52 <fast_pp_skip_inactive+0x1972>
 2dd1c79:	mov    0x50(%rsp),%rsi
 2dd1c7e:	mov    %r11,%rdi
 2dd1c81:	and    $0xffffffffffffffc0,%rdi
 2dd1c85:	vmovd  0x4(%rsp),%xmm0
 2dd1c8b:	mov    %rdx,%rcx
 2dd1c8e:	and    $0xffffffffffffffc0,%rcx
 2dd1c92:	vpxor  %xmm1,%xmm1,%xmm1
 2dd1c96:	vpxor  %xmm2,%xmm2,%xmm2
 2dd1c9a:	vpxor  %xmm3,%xmm3,%xmm3
 2dd1c9e:	add    %rdi,%rsi
 2dd1ca1:	add    0x98(%rsp),%rsi
 2dd1ca9:	lea    0x1(%r8,%rsi,1),%rsi
 2dd1cae:	vpcmpeqb -0x30(%r14),%xmm16,%k0
 2dd1cb5:	vpcmpeqb -0x20(%r14),%xmm16,%k1
 2dd1cbc:	vpcmpeqb -0x10(%r14),%xmm16,%k2
 2dd1cc3:	vpcmpeqb (%r14),%xmm16,%k3
 2dd1cc9:	add    $0x40,%r14
 2dd1ccd:	add    $0xffffffffffffffc0,%rdi
 2dd1cd1:	vpmovm2d %k0,%zmm4
 2dd1cd7:	vpaddd %zmm4,%zmm0,%zmm0
 2dd1cdd:	vpmovm2d %k1,%zmm4
 2dd1ce3:	vpaddd %zmm4,%zmm1,%zmm1
 2dd1ce9:	vpmovm2d %k2,%zmm4
 2dd1cef:	vpaddd %zmm4,%zmm2,%zmm2
 2dd1cf5:	vpmovm2d %k3,%zmm4
 2dd1cfb:	vpaddd %zmm4,%zmm3,%zmm3
 2dd1d01:	jne    2dd1cae <fast_pp_skip_inactive+0x18ce>
 2dd1d03:	vpaddd %zmm0,%zmm1,%zmm0
 2dd1d09:	vpaddd %zmm0,%zmm2,%zmm0
 2dd1d0f:	vpaddd %zmm0,%zmm3,%zmm0
 2dd1d15:	vextracti64x4 $0x1,%zmm0,%ymm1
 2dd1d1c:	vpaddd %zmm1,%zmm0,%zmm0
 2dd1d22:	vextracti128 $0x1,%ymm0,%xmm1
 2dd1d28:	vpaddd %xmm1,%xmm0,%xmm0
 2dd1d2c:	vpshufd $0xee,%xmm0,%xmm1
 2dd1d31:	vpaddd %xmm1,%xmm0,%xmm0
 2dd1d35:	vpshufd $0x55,%xmm0,%xmm1
 2dd1d3a:	vpaddd %xmm1,%xmm0,%xmm0
 2dd1d3e:	vmovd  %xmm0,0x4(%rsp)
 2dd1d44:	cmp    %rcx,%rdx
 2dd1d47:	je     2dd1ddf <fast_pp_skip_inactive+0x19ff>
 2dd1d4d:	test   $0x38,%dl
 2dd1d50:	je     2dd1dc6 <fast_pp_skip_inactive+0x19e6>
 2dd1d52:	mov    0x50(%rsp),%rsi
 2dd1d57:	and    $0xfffffffffffffff8,%r11
 2dd1d5b:	vmovd  0x4(%rsp),%xmm0
 2dd1d61:	mov    %rdx,%rdi
 2dd1d64:	and    $0xfffffffffffffff8,%rdi
 2dd1d68:	add    %rcx,%r9
 2dd1d6b:	add    %r11,%rsi
 2dd1d6e:	add    0x98(%rsp),%rsi
 2dd1d76:	sub    %rcx,%r11
 2dd1d79:	xor    %ecx,%ecx
 2dd1d7b:	lea    0x1(%r8,%rsi,1),%rsi
 2dd1d80:	vmovq  (%r9,%rcx,1),%xmm1
 2dd1d86:	add    $0x8,%rcx
 2dd1d8a:	vpcmpeqb %xmm15,%xmm1,%k0
 2dd1d90:	vpmovm2d %k0,%ymm1
 2dd1d96:	vpaddd %ymm1,%ymm0,%ymm0
 2dd1d9a:	cmp    %rcx,%r11
 2dd1d9d:	jne    2dd1d80 <fast_pp_skip_inactive+0x19a0>
 2dd1d9f:	vextracti128 $0x1,%ymm0,%xmm1
 2dd1da5:	vpaddd %xmm1,%xmm0,%xmm0
 2dd1da9:	vpshufd $0xee,%xmm0,%xmm1
 2dd1dae:	vpaddd %xmm1,%xmm0,%xmm0
 2dd1db2:	vpshufd $0x55,%xmm0,%xmm1
 2dd1db7:	vpaddd %xmm1,%xmm0,%xmm0
 2dd1dbb:	vmovd  %xmm0,0x4(%rsp)
 2dd1dc1:	cmp    %rdi,%rdx
 2dd1dc4:	je     2dd1ddf <fast_pp_skip_inactive+0x19ff>
 2dd1dc6:	dec    %rsi
 2dd1dc9:	xor    %ecx,%ecx
 2dd1dcb:	cmpb   $0xa,0x1(%rsi)
 2dd1dcf:	lea    0x1(%rsi),%rsi
 2dd1dd3:	sete   %cl
 2dd1dd6:	sub    %ecx,0x4(%rsp)
 2dd1dda:	cmp    %r13,%rsi
 2dd1ddd:	jne    2dd1dc9 <fast_pp_skip_inactive+0x19e9>
 2dd1ddf:	mov    0x10(%rsp),%rcx
 2dd1de4:	lea    0x2(%r8,%rcx,1),%rcx
 2dd1de9:	mov    %rcx,0x8(%rsp)
 2dd1dee:	cmp    0x38(%rsp),%rcx
 2dd1df3:	jb     2dd1e24 <fast_pp_skip_inactive+0x1a44>
 2dd1df5:	xor    %edx,%edx
 2dd1df7:	mov    0x8(%rsp),%r10
 2dd1dfc:	xor    %edi,%edi
 2dd1dfe:	xor    %r8d,%r8d
 2dd1e01:	xor    %ebx,%ebx
 2dd1e03:	movq   $0x0,0x10(%rsp)
 2dd1e0c:	jmp    2dd1e8a <fast_pp_skip_inactive+0x1aaa>
 2dd1e0e:	mov    0x8(%rsp),%rsi
 2dd1e13:	xor    %edx,%edx
 2dd1e15:	add    %rcx,%rsi
 2dd1e18:	mov    %rsi,0x8(%rsp)
 2dd1e1d:	cmp    0x38(%rsp),%rsi
 2dd1e22:	jae    2dd1df7 <fast_pp_skip_inactive+0x1a17>
 2dd1e24:	mov    0x8(%rsp),%rcx
 2dd1e29:	movzbl (%rcx),%edx
 2dd1e2c:	cmp    %al,%dl
 2dd1e2e:	je     2dd1e61 <fast_pp_skip_inactive+0x1a81>
 2dd1e30:	cmp    $0xa,%dl
 2dd1e33:	je     2dd1e61 <fast_pp_skip_inactive+0x1a81>
 2dd1e35:	mov    $0x1,%ecx
 2dd1e3a:	cmp    $0x5c,%dl
 2dd1e3d:	jne    2dd1e0e <fast_pp_skip_inactive+0x1a2e>
 2dd1e3f:	mov    0x8(%rsp),%rdx
 2dd1e44:	inc    %rdx
 2dd1e47:	cmp    0x38(%rsp),%rdx
 2dd1e4c:	jae    2dd1e0e <fast_pp_skip_inactive+0x1a2e>
 2dd1e4e:	xor    %ecx,%ecx
 2dd1e50:	cmpb   $0xa,(%rdx)
 2dd1e53:	sete   %cl
 2dd1e56:	add    %ecx,0x4(%rsp)
 2dd1e5a:	mov    $0x2,%ecx
 2dd1e5f:	jmp    2dd1e0e <fast_pp_skip_inactive+0x1a2e>
 2dd1e61:	mov    0x8(%rsp),%rsi
 2dd1e66:	xor    %ecx,%ecx
 2dd1e68:	cmp    %al,%dl
 2dd1e6a:	movq   $0x0,0x10(%rsp)
 2dd1e73:	sete   %cl
 2dd1e76:	xor    %edx,%edx
 2dd1e78:	xor    %edi,%edi
 2dd1e7a:	xor    %r8d,%r8d
 2dd1e7d:	xor    %ebx,%ebx
 2dd1e7f:	add    %rcx,%rsi
 2dd1e82:	mov    %rsi,0x8(%rsp)
 2dd1e87:	mov    %rsi,%r10
 2dd1e8a:	vmovdqa64 %zmm5,%zmm2
 2dd1e90:	vbroadcasti32x4 -0x23b7b7a(%rip),%zmm3        # a1a320 <switch.table.ir_if_convert_test_reload+0x138>
 2dd1e9a:	vbroadcasti32x4 -0x23b7b74(%rip),%zmm4        # a1a330 <switch.table.ir_if_convert_test_reload+0x148>
 2dd1ea4:	vbroadcasti32x4 -0x23b7b6e(%rip),%zmm5        # a1a340 <switch.table.ir_if_convert_test_reload+0x158>
 2dd1eae:	jmp    2dd1ab3 <fast_pp_skip_inactive+0x16d3>
 2dd1eb3:	xor    %eax,%eax
 2dd1eb5:	cmpb   $0x0,0xe968(%r15)
 2dd1ebd:	mov    $0x1,%r12b
 2dd1ec0:	jne    2dd2003 <fast_pp_skip_inactive+0x1c23>
 2dd1ec6:	mov    %rsi,0x48(%rsp)
 2dd1ecb:	mov    %r11d,0x4(%rsp)
 2dd1ed0:	xor    %ebp,%ebp
 2dd1ed2:	lea    -0x23aad78(%rip),%rsi        # a27161 <fast_cc_binary_questioned.range_narrow+0x2a21>
 2dd1ed9:	jmp    2dd1fe6 <fast_pp_skip_inactive+0x1c06>
 2dd1ede:	mov    %r12,%rdi
 2dd1ee1:	xor    %r12d,%r12d
 2dd1ee4:	cmpl   $0x0,0x64(%rsp)
 2dd1ee9:	jne    2dd2072 <fast_pp_skip_inactive+0x1c92>
 2dd1eef:	mov    %rdi,%r10
 2dd1ef2:	jmp    2dd2095 <fast_pp_skip_inactive+0x1cb5>
 2dd1ef7:	lea    -0x23aade6(%rip),%rax        # a27118 <fast_cc_binary_questioned.range_narrow+0x29d8>
 2dd1efe:	mov    %rax,0xa8(%rsp)
 2dd1f06:	mov    0x58(%rsp),%rdi
 2dd1f0b:	mov    0xa8(%rsp),%rsi
 2dd1f13:	vzeroupper
 2dd1f16:	call   45daab9 <fast_pp_bail>
 2dd1f1b:	xor    %ebx,%ebx
 2dd1f1d:	mov    %r14,%r10
 2dd1f20:	mov    %r15d,%r11d
 2dd1f23:	mov    0x58(%rsp),%r15
 2dd1f28:	cmpb   $0x0,0xe968(%r15)
 2dd1f30:	je     2dd1f4c <fast_pp_skip_inactive+0x1b6c>
 2dd1f32:	xor    %eax,%eax
 2dd1f34:	cmpl   $0x0,0x64(%rsp)
 2dd1f39:	mov    $0x1,%r12b
 2dd1f3c:	mov    0x48(%rsp),%rsi
 2dd1f41:	je     2dd2003 <fast_pp_skip_inactive+0x1c23>
 2dd1f47:	jmp    2dd1fd8 <fast_pp_skip_inactive+0x1bf8>
 2dd1f4c:	lea    -0x23aadf2(%rip),%rsi        # a27161 <fast_cc_binary_questioned.range_narrow+0x2a21>
 2dd1f53:	mov    %r15,%rdi
 2dd1f56:	mov    %r10,%r14
 2dd1f59:	mov    %r11d,0x4(%rsp)
 2dd1f5e:	mov    %r15,%r13
 2dd1f61:	vzeroupper
 2dd1f64:	call   45daab9 <fast_pp_bail>
 2dd1f69:	xor    %eax,%eax
 2dd1f6b:	cmpl   $0x0,0x64(%rsp)
 2dd1f70:	mov    $0x1,%r12b
 2dd1f73:	jne    2dd2053 <fast_pp_skip_inactive+0x1c73>
 2dd1f79:	mov    0x48(%rsp),%rsi
 2dd1f7e:	mov    0x4(%rsp),%r11d
 2dd1f83:	mov    %r14,%r10
 2dd1f86:	jmp    2dd2003 <fast_pp_skip_inactive+0x1c23>
 2dd1f88:	lea    -0x23aae77(%rip),%rax        # a27118 <fast_cc_binary_questioned.range_narrow+0x29d8>
 2dd1f8f:	mov    %rax,0xa0(%rsp)
 2dd1f97:	mov    0x58(%rsp),%rdi
 2dd1f9c:	mov    0xa0(%rsp),%rsi
 2dd1fa4:	vzeroupper
 2dd1fa7:	call   45daab9 <fast_pp_bail>
 2dd1fac:	mov    0x38(%rsp),%r10
 2dd1fb1:	mov    0x4(%rsp),%r11d
 2dd1fb6:	xor    %ebx,%ebx
 2dd1fb8:	mov    0x58(%rsp),%r15
 2dd1fbd:	cmpb   $0x0,0xe968(%r15)
 2dd1fc5:	je     2dd2026 <fast_pp_skip_inactive+0x1c46>
 2dd1fc7:	xor    %eax,%eax
 2dd1fc9:	cmpl   $0x0,0x28(%rsp)
 2dd1fce:	mov    $0x1,%r12b
 2dd1fd1:	mov    0x48(%rsp),%rsi
 2dd1fd6:	je     2dd2003 <fast_pp_skip_inactive+0x1c23>
 2dd1fd8:	lea    -0x23aae6d(%rip),%rsi        # a27172 <fast_cc_binary_questioned.range_narrow+0x2a32>
 2dd1fdf:	xor    %ebp,%ebp
 2dd1fe1:	mov    %r11d,0x4(%rsp)
 2dd1fe6:	mov    %r10,%r14
 2dd1fe9:	mov    %r15,%rdi
 2dd1fec:	vzeroupper
 2dd1fef:	call   45daab9 <fast_pp_bail>
 2dd1ff4:	mov    0x48(%rsp),%rsi
 2dd1ff9:	mov    0x4(%rsp),%r11d
 2dd1ffe:	mov    %r14,%r10
 2dd2001:	mov    %ebp,%eax
 2dd2003:	and    %r12b,%bl
 2dd2006:	mov    %r10,0x8(%rsi)
 2dd200a:	mov    %r11d,0x2c(%rsi)
 2dd200e:	mov    %bl,0x45(%rsi)
 2dd2011:	add    $0x118,%rsp
 2dd2018:	pop    %rbx
 2dd2019:	pop    %r12
 2dd201b:	pop    %r13
 2dd201d:	pop    %r14
 2dd201f:	pop    %r15
 2dd2021:	pop    %rbp
 2dd2022:	vzeroupper
 2dd2025:	ret
 2dd2026:	lea    -0x23aaecc(%rip),%rsi        # a27161 <fast_cc_binary_questioned.range_narrow+0x2a21>
 2dd202d:	mov    %r15,%rdi
 2dd2030:	mov    %r10,%r14
 2dd2033:	mov    %r11d,0x4(%rsp)
 2dd2038:	mov    %r15,%r13
 2dd203b:	vzeroupper
 2dd203e:	call   45daab9 <fast_pp_bail>
 2dd2043:	xor    %eax,%eax
 2dd2045:	cmpl   $0x0,0x28(%rsp)
 2dd204a:	mov    $0x1,%r12b
 2dd204d:	je     2dd1f79 <fast_pp_skip_inactive+0x1b99>
 2dd2053:	xor    %ebp,%ebp
 2dd2055:	lea    -0x23aaeea(%rip),%rsi        # a27172 <fast_cc_binary_questioned.range_narrow+0x2a32>
 2dd205c:	mov    %r13,%r15
 2dd205f:	jmp    2dd1fe9 <fast_pp_skip_inactive+0x1c09>
 2dd2061:	mov    $0x6,%bpl
 2dd2064:	xor    %r12d,%r12d
 2dd2067:	cmpl   $0x0,0x64(%rsp)
 2dd206c:	je     2dd1eef <fast_pp_skip_inactive+0x1b0f>
 2dd2072:	lea    -0x23aaf07(%rip),%rsi        # a27172 <fast_cc_binary_questioned.range_narrow+0x2a32>
 2dd2079:	mov    %rdi,%r14
 2dd207c:	xor    %ebx,%ebx
 2dd207e:	jmp    2dd1fe9 <fast_pp_skip_inactive+0x1c09>
 2dd2083:	mov    $0x6,%bpl
 2dd2086:	xor    %r12d,%r12d
 2dd2089:	cmpl   $0x0,0x28(%rsp)
 2dd208e:	jne    2dd20a8 <fast_pp_skip_inactive+0x1cc8>
 2dd2090:	mov    0x8(%rsp),%r10
 2dd2095:	mov    0x48(%rsp),%rsi
 2dd209a:	mov    0x4(%rsp),%r11d
 2dd209f:	mov    %ebp,%eax
 2dd20a1:	xor    %ebx,%ebx
 2dd20a3:	jmp    2dd2003 <fast_pp_skip_inactive+0x1c23>
 2dd20a8:	mov    %r14,%r15
 2dd20ab:	mov    0x8(%rsp),%r14
 2dd20b0:	lea    -0x23aaf45(%rip),%rsi        # a27172 <fast_cc_binary_questioned.range_narrow+0x2a32>
 2dd20b7:	xor    %ebx,%ebx
 2dd20b9:	jmp    2dd1fe9 <fast_pp_skip_inactive+0x1c09>
 2dd20be:	lea    -0x23ab003(%rip),%rax        # a270c2 <fast_cc_binary_questioned.range_narrow+0x2982>
 2dd20c5:	jmp    2dd1efe <fast_pp_skip_inactive+0x1b1e>
