 2dd03e0:	push   %rbp
 2dd03e1:	push   %r15
 2dd03e3:	push   %r14
 2dd03e5:	push   %r13
 2dd03e7:	push   %r12
 2dd03e9:	push   %rbx
 2dd03ea:	sub    $0x118,%rsp
 2dd03f1:	mov    %rsi,%rax
 2dd03f4:	mov    0x8(%rsi),%r14
 2dd03f8:	mov    0x10(%rsi),%rsi
 2dd03fc:	cmpb   $0x0,0xe9d0(%rdi)
 2dd0403:	mov    0x2c(%rax),%r10d
 2dd0407:	movzbl 0x45(%rax),%ebx
 2dd040b:	mov    %rdi,0x38(%rsp)
 2dd0410:	mov    %rax,0x50(%rsp)
 2dd0415:	mov    %rsi,0x18(%rsp)
 2dd041a:	je     2dd1263 <fast_pp_skip_inactive+0xe83>
 2dd0420:	cmp    %rsi,%r14
 2dd0423:	jae    2dd1ee1 <fast_pp_skip_inactive+0x1b01>
 2dd0429:	vbroadcasti32x4 -0x23b6133(%rip),%zmm1        # a1a300 <switch.table.ir_if_convert_test_reload+0x118>
 2dd0433:	vbroadcasti32x4 -0x23b611d(%rip),%zmm2        # a1a320 <switch.table.ir_if_convert_test_reload+0x138>
 2dd043d:	vbroadcasti32x4 -0x23b6117(%rip),%zmm3        # a1a330 <switch.table.ir_if_convert_test_reload+0x148>
 2dd0447:	vbroadcasti32x4 -0x23b6111(%rip),%zmm4        # a1a340 <switch.table.ir_if_convert_test_reload+0x158>
 2dd0451:	vbroadcasti32x4 -0x23b610b(%rip),%zmm5        # a1a350 <switch.table.ir_if_convert_test_reload+0x168>
 2dd045b:	vbroadcasti32x4 -0x23b6105(%rip),%zmm6        # a1a360 <switch.table.ir_if_convert_test_reload+0x178>
 2dd0465:	vbroadcasti32x4 -0x23b60ff(%rip),%zmm7        # a1a370 <switch.table.ir_if_convert_test_reload+0x188>
 2dd046f:	vbroadcasti32x4 -0x23b60f9(%rip),%zmm8        # a1a380 <switch.table.ir_if_convert_test_reload+0x198>
 2dd0479:	vbroadcasti32x4 -0x23b60f3(%rip),%zmm9        # a1a390 <switch.table.ir_if_convert_test_reload+0x1a8>
 2dd0483:	vbroadcasti32x4 -0x23b60ed(%rip),%zmm10        # a1a3a0 <switch.table.ir_if_convert_test_reload+0x1b8>
 2dd048d:	vbroadcasti32x4 -0x23b60e7(%rip),%zmm11        # a1a3b0 <switch.table.ir_if_convert_test_reload+0x1c8>
 2dd0497:	vbroadcasti32x4 -0x23b60e1(%rip),%zmm12        # a1a3c0 <switch.table.ir_if_convert_test_reload+0x1d8>
 2dd04a1:	vbroadcasti32x4 -0x23b60db(%rip),%zmm13        # a1a3d0 <switch.table.ir_if_convert_test_reload+0x1e8>
 2dd04ab:	vbroadcasti32x4 -0x23b60d5(%rip),%zmm14        # a1a3e0 <switch.table.ir_if_convert_test_reload+0x1f8>
 2dd04b5:	lea    -0x23a93d4(%rip),%rax        # a270e8 <fast_cc_binary_questioned.range_narrow+0x29a8>
 2dd04bc:	movq   $0x0,0x88(%rsp)
 2dd04c8:	movq   $0x0,0x98(%rsp)
 2dd04d4:	movl   $0x0,0x5c(%rsp)
 2dd04dc:	xor    %r12d,%r12d
 2dd04df:	xor    %edx,%edx
 2dd04e1:	xor    %edi,%edi
 2dd04e3:	xor    %r15d,%r15d
 2dd04e6:	xor    %r8d,%r8d
 2dd04e9:	xor    %r11d,%r11d
 2dd04ec:	mov    %r14,0x10(%rsp)
 2dd04f1:	mov    %rax,0xa8(%rsp)
 2dd04f9:	nopl   0x0(%rax)
 2dd0500:	mov    %r8,0x48(%rsp)
 2dd0505:	mov    %rsi,%r8
 2dd0508:	sub    %r14,%r8
 2dd050b:	mov    %r15,0x68(%rsp)
 2dd0510:	mov    %r14,0x20(%rsp)
 2dd0515:	mov    %rdi,0x30(%rsp)
 2dd051a:	cmp    $0x40,%r8
 2dd051e:	jb     2dd0832 <fast_pp_skip_inactive+0x452>
 2dd0524:	vmovdqu64 (%r14),%zmm15
 2dd052a:	mov    $0x40,%r8d
 2dd0530:	mov    $0xffffffffffffffff,%rax
 2dd0537:	vpcmpeqb %zmm8,%zmm15,%k2
 2dd053d:	vpaddb %zmm9,%zmm15,%zmm0
 2dd0543:	vpcmpeqb %zmm1,%zmm15,%k0
 2dd0549:	vpcmpeqb %zmm6,%zmm15,%k1
 2dd054f:	bzhi   %r8,%rax,%r15
 2dd0554:	kmovq  %k2,%rcx
 2dd0559:	vpcmpltub %zmm10,%zmm0,%k2
 2dd0560:	kmovq  %k0,%rax
 2dd0565:	vpcmpeqb %zmm5,%zmm15,%k0
 2dd056b:	kmovq  %k2,%rdi
 2dd0570:	mov    %r15,0x60(%rsp)
 2dd0575:	not    %r15
 2dd0578:	lea    (%rax,%rax,1),%r14
 2dd057c:	korq   %k1,%k0,%k1
 2dd0581:	mov    %rax,%rbp
 2dd0584:	not    %rbp
 2dd0587:	mov    %rax,0x28(%rsp)
 2dd058c:	andn   %rdi,%rax,%rdi
 2dd0591:	or     %rcx,%r15
 2dd0594:	kmovq  %k1,%r9
 2dd0599:	vpcmpeqb %zmm7,%zmm15,%k1
 2dd059f:	or     %rbx,%r14
 2dd05a2:	or     %rdi,%r15
 2dd05a5:	kmovq  %k1,%r13
 2dd05aa:	mov    %r15,%rbx
 2dd05ad:	and    %r14,%rbx
 2dd05b0:	lea    0x0(%r13,%r13,1),%rdi
 2dd05b5:	mov    %r13,0xc8(%rsp)
 2dd05bd:	add    %r15,%rbx
 2dd05c0:	setb   0x47(%rsp)
 2dd05c5:	or     %rdx,%rdi
 2dd05c8:	or     %rdi,%rbp
 2dd05cb:	add    $0xff,%r12b
 2dd05cf:	adc    %rbp,%r9
 2dd05d2:	setb   %al
 2dd05d5:	mov    %r9,0x90(%rsp)
 2dd05dd:	mov    %rax,0x78(%rsp)
 2dd05e2:	test   %rdi,%rdi
 2dd05e5:	jne    2dd0851 <fast_pp_skip_inactive+0x471>
 2dd05eb:	movq   $0x0,0x70(%rsp)
 2dd05f4:	vpcmpeqb %zmm11,%zmm15,%k1
 2dd05fa:	kmovq  %k0,%rcx
 2dd05ff:	mov    %r8,0xa0(%rsp)
 2dd0607:	kmovq  %k1,%r12
 2dd060c:	lea    (%r12,%r12,1),%r13
 2dd0610:	or     %r11,%r13
 2dd0613:	and    %rcx,%r13
 2dd0616:	jne    2dd06f1 <fast_pp_skip_inactive+0x311>
 2dd061c:	xor    %r11d,%r11d
 2dd061f:	vpcmpeqb %zmm2,%zmm15,%k0
 2dd0625:	vpcmpeqb %zmm4,%zmm15,%k1
 2dd062b:	mov    0x70(%rsp),%r13
 2dd0630:	mov    0x90(%rsp),%r8
 2dd0638:	or     %r14,%rbx
 2dd063b:	kmovq  %k0,%rcx
 2dd0640:	vpcmpeqb %zmm3,%zmm15,%k0
 2dd0646:	andn   %rbx,%r15,%r9
 2dd064b:	kmovq  %k0,%rdx
 2dd0650:	korq   %k0,%k1,%k1
 2dd0655:	and    %r9,%rcx
 2dd0658:	lea    (%rdx,%rdx,1),%rax
 2dd065c:	or     0x30(%rsp),%rax
 2dd0661:	kmovq  %k1,%rdi
 2dd0666:	andn   %rbp,%r8,%r8
 2dd066b:	and    %rdi,%rax
 2dd066e:	or     %rcx,%rax
 2dd0671:	or     %r13,%rax
 2dd0674:	or     %r11,%rax
 2dd0677:	and    0x60(%rsp),%rax
 2dd067c:	jne    2dd087f <fast_pp_skip_inactive+0x49f>
 2dd0682:	mov    0xc8(%rsp),%r13
 2dd068a:	movzbl 0x47(%rsp),%eax
 2dd068f:	mov    0x28(%rsp),%rbx
 2dd0694:	mov    0x20(%rsp),%r14
 2dd0699:	shr    $0x3f,%r12
 2dd069d:	xor    %ecx,%ecx
 2dd069f:	shr    $0x3f,%rdx
 2dd06a3:	shr    $0x3f,%r9
 2dd06a7:	shr    $0x3f,%r8
 2dd06ab:	mov    %r12,%r11
 2dd06ae:	add    0xa0(%rsp),%r14
 2dd06b6:	mov    0x78(%rsp),%r12
 2dd06bb:	mov    %r9,%r15
 2dd06be:	mov    %rdx,%rdi
 2dd06c1:	mov    %al,%cl
 2dd06c3:	popcnt %rbx,%rax
 2dd06c8:	shr    $0x3f,%rbx
 2dd06cc:	shr    $0x3f,%r13
 2dd06d0:	or     %rcx,%rbx
 2dd06d3:	add    %eax,%r10d
 2dd06d6:	xor    %ecx,%ecx
 2dd06d8:	mov    %r13,%rdx
 2dd06db:	cmp    %rsi,%r14
 2dd06de:	jae    2dd1f3f <fast_pp_skip_inactive+0x1b5f>
 2dd06e4:	test   %cl,%cl
 2dd06e6:	je     2dd0500 <fast_pp_skip_inactive+0x120>
 2dd06ec:	jmp    2dd1f3f <fast_pp_skip_inactive+0x1b5f>
 2dd06f1:	mov    0x50(%rsp),%rax
 2dd06f6:	xor    %r11d,%r11d
 2dd06f9:	mov    %r10d,0xc(%rsp)
 2dd06fe:	vmovdqu64 %zmm15,0xd0(%rsp)
 2dd0709:	mov    (%rax),%rax
 2dd070c:	mov    %rax,0xb8(%rsp)
 2dd0714:	mov    0x38(%rsp),%rax
 2dd0719:	movzbl 0xe9d0(%rax),%eax
 2dd0720:	mov    %al,0x46(%rsp)
 2dd0724:	mov    0x20(%rsp),%rax
 2dd0729:	movzbl 0x46(%rsp),%edx
 2dd072e:	mov    0xb8(%rsp),%rdi
 2dd0736:	xor    %ecx,%ecx
 2dd0738:	tzcnt  %r13,%rcx
 2dd073d:	mov    %r11,0xc0(%rsp)
 2dd0745:	mov    %rcx,0xb0(%rsp)
 2dd074d:	lea    (%rax,%rcx,1),%rsi
 2dd0751:	vzeroupper
 2dd0754:	call   45df090 <fast_raw_string_before>
 2dd0759:	vmovdqu64 0xd0(%rsp),%zmm15
 2dd0764:	vbroadcasti32x4 -0x23b638e(%rip),%zmm14        # a1a3e0 <switch.table.ir_if_convert_test_reload+0x1f8>
 2dd076e:	vbroadcasti32x4 -0x23b63a8(%rip),%zmm13        # a1a3d0 <switch.table.ir_if_convert_test_reload+0x1e8>
 2dd0778:	vbroadcasti32x4 -0x23b63c2(%rip),%zmm12        # a1a3c0 <switch.table.ir_if_convert_test_reload+0x1d8>
 2dd0782:	vbroadcasti32x4 -0x23b63dc(%rip),%zmm11        # a1a3b0 <switch.table.ir_if_convert_test_reload+0x1c8>
 2dd078c:	vbroadcasti32x4 -0x23b63f6(%rip),%zmm10        # a1a3a0 <switch.table.ir_if_convert_test_reload+0x1b8>
 2dd0796:	vbroadcasti32x4 -0x23b6410(%rip),%zmm9        # a1a390 <switch.table.ir_if_convert_test_reload+0x1a8>
 2dd07a0:	vbroadcasti32x4 -0x23b642a(%rip),%zmm8        # a1a380 <switch.table.ir_if_convert_test_reload+0x198>
 2dd07aa:	vbroadcasti32x4 -0x23b6444(%rip),%zmm7        # a1a370 <switch.table.ir_if_convert_test_reload+0x188>
 2dd07b4:	vbroadcasti32x4 -0x23b645e(%rip),%zmm6        # a1a360 <switch.table.ir_if_convert_test_reload+0x178>
 2dd07be:	vbroadcasti32x4 -0x23b6478(%rip),%zmm5        # a1a350 <switch.table.ir_if_convert_test_reload+0x168>
 2dd07c8:	vbroadcasti32x4 -0x23b6492(%rip),%zmm4        # a1a340 <switch.table.ir_if_convert_test_reload+0x158>
 2dd07d2:	vbroadcasti32x4 -0x23b64ac(%rip),%zmm3        # a1a330 <switch.table.ir_if_convert_test_reload+0x148>
 2dd07dc:	vbroadcasti32x4 -0x23b64c6(%rip),%zmm2        # a1a320 <switch.table.ir_if_convert_test_reload+0x138>
 2dd07e6:	vbroadcasti32x4 -0x23b64f0(%rip),%zmm1        # a1a300 <switch.table.ir_if_convert_test_reload+0x118>
 2dd07f0:	mov    0xb0(%rsp),%rdx
 2dd07f8:	mov    0xc0(%rsp),%r11
 2dd0800:	mov    0x18(%rsp),%rsi
 2dd0805:	mov    0xc(%rsp),%r10d
 2dd080a:	mov    $0x1,%ecx
 2dd080f:	test   %al,%al
 2dd0811:	mov    $0x0,%eax
 2dd0816:	shlx   %rdx,%rcx,%rcx
 2dd081b:	cmove  %rax,%rcx
 2dd081f:	or     %rcx,%r11
 2dd0822:	blsr   %r13,%r13
 2dd0827:	je     2dd061f <fast_pp_skip_inactive+0x23f>
 2dd082d:	jmp    2dd0724 <fast_pp_skip_inactive+0x344>
 2dd0832:	mov    $0xffffffffffffffff,%rax
 2dd0839:	shlx   %r8,%rax,%rcx
 2dd083e:	not    %rcx
 2dd0841:	kmovq  %rcx,%k1
 2dd0846:	vmovdqu8 (%r14),%zmm15{%k1}{z}
 2dd084c:	jmp    2dd0530 <fast_pp_skip_inactive+0x150>
 2dd0851:	vpandq %zmm12,%zmm15,%zmm0
 2dd0857:	vpcmpeqb %zmm14,%zmm15,%k3
 2dd085d:	vpcmpeqb %zmm13,%zmm0,%k2
 2dd0863:	korq   %k3,%k1,%k1
 2dd0868:	korq   %k2,%k1,%k1
 2dd086d:	kmovq  %k1,%rcx
 2dd0872:	and    %rcx,%rdi
 2dd0875:	mov    %rdi,0x70(%rsp)
 2dd087a:	jmp    2dd05f4 <fast_pp_skip_inactive+0x214>
 2dd087f:	mov    0x20(%rsp),%rbx
 2dd0884:	tzcnt  %rax,%rax
 2dd0889:	mov    $0x0,%r12d
 2dd088f:	shrx   %rax,%r11,%rdx
 2dd0894:	shrx   %rax,%rcx,%rcx
 2dd0899:	mov    %rdx,%rdi
 2dd089c:	or     $0xfffffffffffffffe,%rdi
 2dd08a0:	inc    %rdi
 2dd08a3:	test   $0x1,%cl
 2dd08a6:	cmove  %rdi,%r12
 2dd08aa:	lea    (%rbx,%rax,1),%r14
 2dd08ae:	add    %r12,%r14
 2dd08b1:	test   $0x1,%cl
 2dd08b4:	je     2dd08d5 <fast_pp_skip_inactive+0x4f5>
 2dd08b6:	mov    0x68(%rsp),%r15
 2dd08bb:	test   $0x1,%dl
 2dd08be:	jne    2dd0c22 <fast_pp_skip_inactive+0x842>
 2dd08c4:	shrx   %rax,%r8,%r8
 2dd08c9:	mov    $0x1,%r9d
 2dd08cf:	and    $0x1,%r8d
 2dd08d3:	jmp    2dd0920 <fast_pp_skip_inactive+0x540>
 2dd08d5:	mov    0x68(%rsp),%r15
 2dd08da:	mov    $0xffffffff,%edi
 2dd08df:	lea    (%rax,%rdi,1),%r11d
 2dd08e3:	shrx   %r11,%r9,%rdi
 2dd08e8:	and    $0x1,%edi
 2dd08eb:	test   %rax,%rax
 2dd08ee:	mov    %r15d,%r9d
 2dd08f1:	cmovne %edi,%r9d
 2dd08f5:	test   %r9d,%r9d
 2dd08f8:	mov    $0x0,%r9d
 2dd08fe:	setne  %r9b
 2dd0902:	test   $0x1,%dl
 2dd0905:	jne    2dd0c28 <fast_pp_skip_inactive+0x848>
 2dd090b:	test   %rax,%rax
 2dd090e:	je     2dd091b <fast_pp_skip_inactive+0x53b>
 2dd0910:	shrx   %r11,%r8,%r8
 2dd0915:	and    $0x1,%r8d
 2dd0919:	jmp    2dd0920 <fast_pp_skip_inactive+0x540>
 2dd091b:	mov    0x48(%rsp),%r8
 2dd0920:	mov    $0xffffffffffffffff,%rdi
 2dd0927:	bzhi   %rax,%rdi,%rdi
 2dd092c:	and    0x28(%rsp),%rdi
 2dd0931:	popcnt %rdi,%rdi
 2dd0936:	add    %edi,%r10d
 2dd0939:	test   %r8d,%r8d
 2dd093c:	jne    2dd0c41 <fast_pp_skip_inactive+0x861>
 2dd0942:	test   $0x1,%cl
 2dd0945:	je     2dd0d11 <fast_pp_skip_inactive+0x931>
 2dd094b:	mov    0x38(%rsp),%r12
 2dd0950:	inc    %r14
 2dd0953:	mov    %r10d,0xc(%rsp)
 2dd0958:	mov    %r14,%rdi
 2dd095b:	vzeroupper
 2dd095e:	call   45db750 <fast_skip_hspace>
 2dd0963:	mov    0x18(%rsp),%rsi
 2dd0968:	mov    %rax,%r14
 2dd096b:	cmp    %rsi,%rax
 2dd096e:	jae    2dd0981 <fast_pp_skip_inactive+0x5a1>
 2dd0970:	movzbl (%r14),%ebx
 2dd0974:	lea    -0x23b2b7b(%rip),%rax        # a1de00 <fast_char_class>
 2dd097b:	testb  $0x2,(%rbx,%rax,1)
 2dd097f:	jne    2dd098b <fast_pp_skip_inactive+0x5ab>
 2dd0981:	mov    0xc(%rsp),%r10d
 2dd0986:	jmp    2dd0af5 <fast_pp_skip_inactive+0x715>
 2dd098b:	mov    %r14,%rdi
 2dd098e:	call   45ddbb0 <fast_scan_ident_len>
 2dd0993:	lea    -0x2(%rax),%ecx
 2dd0996:	cmp    $0x6,%ecx
 2dd0999:	ja     2dd0ae6 <fast_pp_skip_inactive+0x706>
 2dd099f:	lea    -0x23ac672(%rip),%rdx        # a24334 <c_direct_test_dependencies.levels+0x57>
 2dd09a6:	movslq (%rdx,%rcx,4),%rcx
 2dd09aa:	add    %rdx,%rcx
 2dd09ad:	jmp    *%rcx
 2dd09af:	cmp    $0x69,%bl
 2dd09b2:	jne    2dd0ae6 <fast_pp_skip_inactive+0x706>
 2dd09b8:	cmpb   $0x66,0x1(%r14)
 2dd09bd:	je     2dd0a94 <fast_pp_skip_inactive+0x6b4>
 2dd09c3:	jmp    2dd0ae6 <fast_pp_skip_inactive+0x706>
 2dd09c8:	movzbl 0x4(%r14),%esi
 2dd09cd:	mov    (%r14),%ecx
 2dd09d0:	mov    $0x65646669,%edx
 2dd09d5:	xor    %edx,%ecx
 2dd09d7:	xor    $0x66,%esi
 2dd09da:	or     %ecx,%esi
 2dd09dc:	je     2dd0a94 <fast_pp_skip_inactive+0x6b4>
 2dd09e2:	movzbl 0x4(%r14),%esi
 2dd09e7:	mov    (%r14),%ecx
 2dd09ea:	mov    $0x69646e65,%edx
 2dd09ef:	xor    %edx,%ecx
 2dd09f1:	xor    $0x66,%esi
 2dd09f4:	or     %ecx,%esi
 2dd09f6:	jne    2dd0ae6 <fast_pp_skip_inactive+0x706>
 2dd09fc:	add    $0x5,%r14
 2dd0a00:	cmpl   $0x0,0x88(%rsp)
 2dd0a08:	mov    %r14,0x10(%rsp)
 2dd0a0d:	je     2dd2051 <fast_pp_skip_inactive+0x1c71>
 2dd0a13:	mov    0x88(%rsp),%rax
 2dd0a1b:	mov    0x10(%rsp),%r14
 2dd0a20:	mov    0xc(%rsp),%r10d
 2dd0a25:	xor    %ecx,%ecx
 2dd0a27:	xor    %r11d,%r11d
 2dd0a2a:	xor    %edi,%edi
 2dd0a2c:	xor    %edx,%edx
 2dd0a2e:	xor    %r12d,%r12d
 2dd0a31:	xor    %ebx,%ebx
 2dd0a33:	dec    %eax
 2dd0a35:	mov    %rax,0x88(%rsp)
 2dd0a3d:	jmp    2dd0b87 <fast_pp_skip_inactive+0x7a7>
 2dd0a42:	movabs $0x6665646e66696c65,%rcx
 2dd0a4c:	cmp    %rcx,(%r14)
 2dd0a4f:	jne    2dd0ae6 <fast_pp_skip_inactive+0x706>
 2dd0a55:	mov    $0x32,%bpl
 2dd0a58:	jmp    2dd0b1c <fast_pp_skip_inactive+0x73c>
 2dd0a5d:	cmpl   $0x65736c65,(%r14)
 2dd0a64:	je     2dd0b0d <fast_pp_skip_inactive+0x72d>
 2dd0a6a:	cmpl   $0x66696c65,(%r14)
 2dd0a71:	jne    2dd0ae6 <fast_pp_skip_inactive+0x706>
 2dd0a73:	mov    $0x4,%bpl
 2dd0a76:	jmp    2dd0b2c <fast_pp_skip_inactive+0x74c>
 2dd0a7b:	movzwl 0x4(%r14),%esi
 2dd0a80:	mov    (%r14),%ecx
 2dd0a83:	mov    $0x646e6669,%edx
 2dd0a88:	xor    %edx,%ecx
 2dd0a8a:	xor    $0x6665,%esi
 2dd0a90:	or     %ecx,%esi
 2dd0a92:	jne    2dd0ae6 <fast_pp_skip_inactive+0x706>
 2dd0a94:	mov    0x88(%rsp),%rcx
 2dd0a9c:	mov    %eax,%eax
 2dd0a9e:	add    %rax,%r14
 2dd0aa1:	xor    %eax,%eax
 2dd0aa3:	mov    0x98(%rsp),%rdx
 2dd0aab:	inc    %ecx
 2dd0aad:	cmp    $0x40,%ecx
 2dd0ab0:	mov    %rcx,0x88(%rsp)
 2dd0ab8:	setae  %al
 2dd0abb:	btr    %rcx,%rdx
 2dd0abf:	or     %eax,0x5c(%rsp)
 2dd0ac3:	mov    %rdx,0x98(%rsp)
 2dd0acb:	jmp    2dd0aeb <fast_pp_skip_inactive+0x70b>
 2dd0acd:	mov    (%r14),%ecx
 2dd0ad0:	mov    0x3(%r14),%edi
 2dd0ad4:	mov    $0x66696c65,%edx
 2dd0ad9:	mov    $0x66656466,%esi
 2dd0ade:	xor    %edx,%ecx
 2dd0ae0:	xor    %esi,%edi
 2dd0ae2:	or     %ecx,%edi
 2dd0ae4:	je     2dd0b19 <fast_pp_skip_inactive+0x739>
 2dd0ae6:	mov    %eax,%eax
 2dd0ae8:	add    %rax,%r14
 2dd0aeb:	mov    0xc(%rsp),%r10d
 2dd0af0:	mov    0x18(%rsp),%rsi
 2dd0af5:	xor    %ecx,%ecx
 2dd0af7:	xor    %r11d,%r11d
 2dd0afa:	xor    %edi,%edi
 2dd0afc:	xor    %edx,%edx
 2dd0afe:	xor    %r12d,%r12d
 2dd0b01:	xor    %ebx,%ebx
 2dd0b03:	mov    %r14,0x10(%rsp)
 2dd0b08:	jmp    2dd0e74 <fast_pp_skip_inactive+0xa94>
 2dd0b0d:	mov    $0xffffffffffffffff,%rcx
 2dd0b14:	mov    $0x5,%bpl
 2dd0b17:	jmp    2dd0b2e <fast_pp_skip_inactive+0x74e>
 2dd0b19:	mov    $0x31,%bpl
 2dd0b1c:	movzbl 0xe979(%r12),%ecx
 2dd0b25:	xor    $0x1,%ecx
 2dd0b28:	or     %ecx,0x5c(%rsp)
 2dd0b2c:	xor    %ecx,%ecx
 2dd0b2e:	mov    0x88(%rsp),%rdx
 2dd0b36:	mov    %eax,%eax
 2dd0b38:	add    %rax,%r14
 2dd0b3b:	mov    %r14,0x10(%rsp)
 2dd0b40:	test   %edx,%edx
 2dd0b42:	je     2dd2054 <fast_pp_skip_inactive+0x1c74>
 2dd0b48:	mov    0x98(%rsp),%rsi
 2dd0b50:	mov    $0x1,%eax
 2dd0b55:	mov    0xc(%rsp),%r10d
 2dd0b5a:	xor    %r11d,%r11d
 2dd0b5d:	xor    %edi,%edi
 2dd0b5f:	xor    %r12d,%r12d
 2dd0b62:	xor    %ebx,%ebx
 2dd0b64:	shlx   %rdx,%rax,%rax
 2dd0b69:	and    %rax,%rcx
 2dd0b6c:	shrx   %rdx,%rsi,%rax
 2dd0b71:	or     %rcx,%rsi
 2dd0b74:	xor    %ecx,%ecx
 2dd0b76:	xor    %edx,%edx
 2dd0b78:	and    $0x1,%eax
 2dd0b7b:	mov    %rsi,0x98(%rsp)
 2dd0b83:	or     %eax,0x5c(%rsp)
 2dd0b87:	vbroadcasti32x4 -0x23b6891(%rip),%zmm1        # a1a300 <switch.table.ir_if_convert_test_reload+0x118>
 2dd0b91:	vbroadcasti32x4 -0x23b687b(%rip),%zmm2        # a1a320 <switch.table.ir_if_convert_test_reload+0x138>
 2dd0b9b:	vbroadcasti32x4 -0x23b6875(%rip),%zmm3        # a1a330 <switch.table.ir_if_convert_test_reload+0x148>
 2dd0ba5:	vbroadcasti32x4 -0x23b686f(%rip),%zmm4        # a1a340 <switch.table.ir_if_convert_test_reload+0x158>
 2dd0baf:	vbroadcasti32x4 -0x23b6869(%rip),%zmm5        # a1a350 <switch.table.ir_if_convert_test_reload+0x168>
 2dd0bb9:	vbroadcasti32x4 -0x23b6863(%rip),%zmm6        # a1a360 <switch.table.ir_if_convert_test_reload+0x178>
 2dd0bc3:	vbroadcasti32x4 -0x23b685d(%rip),%zmm7        # a1a370 <switch.table.ir_if_convert_test_reload+0x188>
 2dd0bcd:	vbroadcasti32x4 -0x23b6857(%rip),%zmm8        # a1a380 <switch.table.ir_if_convert_test_reload+0x198>
 2dd0bd7:	vbroadcasti32x4 -0x23b6851(%rip),%zmm9        # a1a390 <switch.table.ir_if_convert_test_reload+0x1a8>
 2dd0be1:	vbroadcasti32x4 -0x23b684b(%rip),%zmm10        # a1a3a0 <switch.table.ir_if_convert_test_reload+0x1b8>
 2dd0beb:	vbroadcasti32x4 -0x23b6845(%rip),%zmm11        # a1a3b0 <switch.table.ir_if_convert_test_reload+0x1c8>
 2dd0bf5:	vbroadcasti32x4 -0x23b683f(%rip),%zmm12        # a1a3c0 <switch.table.ir_if_convert_test_reload+0x1d8>
 2dd0bff:	vbroadcasti32x4 -0x23b6839(%rip),%zmm13        # a1a3d0 <switch.table.ir_if_convert_test_reload+0x1e8>
 2dd0c09:	vbroadcasti32x4 -0x23b6833(%rip),%zmm14        # a1a3e0 <switch.table.ir_if_convert_test_reload+0x1f8>
 2dd0c13:	mov    0x18(%rsp),%rsi
 2dd0c18:	mov    0x68(%rsp),%r15
 2dd0c1d:	jmp    2dd0fc5 <fast_pp_skip_inactive+0xbe5>
 2dd0c22:	mov    $0x1,%r9d
 2dd0c28:	mov    $0xffffffffffffffff,%r8
 2dd0c2f:	bzhi   %rax,%r8,%r8
 2dd0c34:	and    0x28(%rsp),%r8
 2dd0c39:	popcnt %r8,%r8
 2dd0c3e:	add    %r8d,%r10d
 2dd0c41:	mov    %r9,%rdi
 2dd0c44:	mov    %r10d,%r13d
 2dd0c47:	mov    %r14,%r15
 2dd0c4a:	mov    %r14,0x28(%rsp)
 2dd0c4f:	cmp    0x10(%rsp),%r14
 2dd0c54:	jbe    2dd0c95 <fast_pp_skip_inactive+0x8b5>
 2dd0c56:	mov    0x28(%rsp),%r15
 2dd0c5b:	lea    (%r12,%rax,1),%rsi
 2dd0c5f:	lea    -0x1(%rbx,%rsi,1),%rsi
 2dd0c64:	jmp    2dd0c74 <fast_pp_skip_inactive+0x894>
 2dd0c66:	dec    %r15
 2dd0c69:	cmp    0x10(%rsp),%rsi
 2dd0c6e:	lea    -0x1(%rsi),%rsi
 2dd0c72:	jbe    2dd0c88 <fast_pp_skip_inactive+0x8a8>
 2dd0c74:	cmpb   $0xa,(%rsi)
 2dd0c77:	jne    2dd0c66 <fast_pp_skip_inactive+0x886>
 2dd0c79:	cmp    0x10(%rsp),%rsi
 2dd0c7e:	jbe    2dd0c8f <fast_pp_skip_inactive+0x8af>
 2dd0c80:	cmpb   $0x5c,-0x1(%rsi)
 2dd0c84:	je     2dd0c66 <fast_pp_skip_inactive+0x886>
 2dd0c86:	jmp    2dd0c95 <fast_pp_skip_inactive+0x8b5>
 2dd0c88:	mov    0x10(%rsp),%r15
 2dd0c8d:	jmp    2dd0c95 <fast_pp_skip_inactive+0x8b5>
 2dd0c8f:	inc    %rsi
 2dd0c92:	mov    %rsi,%r15
 2dd0c95:	and    $0x1,%edx
 2dd0c98:	add    0x28(%rsp),%rdx
 2dd0c9d:	cmp    %rdx,%r15
 2dd0ca0:	jae    2dd0cee <fast_pp_skip_inactive+0x90e>
 2dd0ca2:	add    %rax,%r12
 2dd0ca5:	mov    %r15,0x30(%rsp)
 2dd0caa:	xor    %ebp,%ebp
 2dd0cac:	add    %rbx,%r12
 2dd0caf:	lea    0x30(%r15),%rbx
 2dd0cb3:	mov    %r12,%r14
 2dd0cb6:	sub    %r15,%r14
 2dd0cb9:	movzbl (%r15,%rbp,1),%esi
 2dd0cbe:	mov    %esi,0x20(%rsp)
 2dd0cc2:	cmp    $0x22,%esi
 2dd0cc5:	je     2dd1013 <fast_pp_skip_inactive+0xc33>
 2dd0ccb:	cmpl   $0x27,0x20(%rsp)
 2dd0cd0:	je     2dd0fd8 <fast_pp_skip_inactive+0xbf8>
 2dd0cd6:	incq   0x30(%rsp)
 2dd0cdb:	lea    0x1(%r15,%rbp,1),%rsi
 2dd0ce0:	inc    %rbp
 2dd0ce3:	dec    %r14
 2dd0ce6:	inc    %rbx
 2dd0ce9:	cmp    %rdx,%rsi
 2dd0cec:	jb     2dd0cb9 <fast_pp_skip_inactive+0x8d9>
 2dd0cee:	mov    %r13d,%r10d
 2dd0cf1:	mov    0x18(%rsp),%rsi
 2dd0cf6:	mov    0x68(%rsp),%r15
 2dd0cfb:	mov    0x28(%rsp),%r14
 2dd0d00:	mov    0x70(%rsp),%r13
 2dd0d05:	mov    %rdi,%r9
 2dd0d08:	test   $0x1,%cl
 2dd0d0b:	jne    2dd094b <fast_pp_skip_inactive+0x56b>
 2dd0d11:	shrx   %rax,%r13,%rax
 2dd0d16:	test   $0x1,%al
 2dd0d18:	je     2dd0e03 <fast_pp_skip_inactive+0xa23>
 2dd0d1e:	inc    %r14
 2dd0d21:	mov    %r10d,%r13d
 2dd0d24:	mov    %r14,%rdi
 2dd0d27:	vzeroupper
 2dd0d2a:	call   45df150 <fast_skip_splices>
 2dd0d2f:	mov    0x18(%rsp),%rsi
 2dd0d34:	cmp    %rsi,%rax
 2dd0d37:	jae    2dd0e5e <fast_pp_skip_inactive+0xa7e>
 2dd0d3d:	vbroadcasti32x4 -0x23b6a47(%rip),%zmm1        # a1a300 <switch.table.ir_if_convert_test_reload+0x118>
 2dd0d47:	vbroadcasti32x4 -0x23b6a31(%rip),%zmm2        # a1a320 <switch.table.ir_if_convert_test_reload+0x138>
 2dd0d51:	vbroadcasti32x4 -0x23b6a2b(%rip),%zmm3        # a1a330 <switch.table.ir_if_convert_test_reload+0x148>
 2dd0d5b:	vbroadcasti32x4 -0x23b6a25(%rip),%zmm4        # a1a340 <switch.table.ir_if_convert_test_reload+0x158>
 2dd0d65:	vbroadcasti32x4 -0x23b6a1f(%rip),%zmm5        # a1a350 <switch.table.ir_if_convert_test_reload+0x168>
 2dd0d6f:	vbroadcasti32x4 -0x23b6a19(%rip),%zmm6        # a1a360 <switch.table.ir_if_convert_test_reload+0x178>
 2dd0d79:	vbroadcasti32x4 -0x23b6a13(%rip),%zmm7        # a1a370 <switch.table.ir_if_convert_test_reload+0x188>
 2dd0d83:	vbroadcasti32x4 -0x23b6a0d(%rip),%zmm8        # a1a380 <switch.table.ir_if_convert_test_reload+0x198>
 2dd0d8d:	vbroadcasti32x4 -0x23b6a07(%rip),%zmm9        # a1a390 <switch.table.ir_if_convert_test_reload+0x1a8>
 2dd0d97:	vbroadcasti32x4 -0x23b6a01(%rip),%zmm10        # a1a3a0 <switch.table.ir_if_convert_test_reload+0x1b8>
 2dd0da1:	vbroadcasti32x4 -0x23b69fb(%rip),%zmm11        # a1a3b0 <switch.table.ir_if_convert_test_reload+0x1c8>
 2dd0dab:	vbroadcasti32x4 -0x23b69f5(%rip),%zmm12        # a1a3c0 <switch.table.ir_if_convert_test_reload+0x1d8>
 2dd0db5:	vbroadcasti32x4 -0x23b69ef(%rip),%zmm13        # a1a3d0 <switch.table.ir_if_convert_test_reload+0x1e8>
 2dd0dbf:	vbroadcasti32x4 -0x23b69e9(%rip),%zmm14        # a1a3e0 <switch.table.ir_if_convert_test_reload+0x1f8>
 2dd0dc9:	movzbl (%rax),%edx
 2dd0dcc:	xor    %r11d,%r11d
 2dd0dcf:	xor    %r12d,%r12d
 2dd0dd2:	xor    %ecx,%ecx
 2dd0dd4:	mov    %r13d,%r10d
 2dd0dd7:	add    $0xffffffb2,%edx
 2dd0dda:	cmp    $0x27,%edx
 2dd0ddd:	ja     2dd0df3 <fast_pp_skip_inactive+0xa13>
 2dd0ddf:	movabs $0x8000000081,%rax
 2dd0de9:	bt     %rdx,%rax
 2dd0ded:	jb     2dd1f11 <fast_pp_skip_inactive+0x1b31>
 2dd0df3:	mov    %r14,0x10(%rsp)
 2dd0df8:	xor    %edi,%edi
 2dd0dfa:	xor    %edx,%edx
 2dd0dfc:	xor    %ebx,%ebx
 2dd0dfe:	jmp    2dd0fc5 <fast_pp_skip_inactive+0xbe5>
 2dd0e03:	movl   $0x0,0x84(%rsp)
 2dd0e0e:	mov    %r14,%rax
 2dd0e11:	mov    0x38(%rsp),%r14
 2dd0e16:	lea    0x2(%rax),%rdi
 2dd0e1a:	mov    %r9,%rbx
 2dd0e1d:	mov    %r10d,%ebp
 2dd0e20:	cmpb   $0x2a,0x1(%rax)
 2dd0e24:	jne    2dd0f05 <fast_pp_skip_inactive+0xb25>
 2dd0e2a:	lea    0x84(%rsp),%rdx
 2dd0e32:	vzeroupper
 2dd0e35:	call   45dd360 <fast_skip_block_comment>
 2dd0e3a:	test   %rax,%rax
 2dd0e3d:	jne    2dd0f15 <fast_pp_skip_inactive+0xb35>
 2dd0e43:	lea    -0x23a9d06(%rip),%rsi        # a27144 <fast_cc_binary_questioned.range_narrow+0x2a04>
 2dd0e4a:	mov    %r14,%rdi
 2dd0e4d:	call   45daa79 <fast_pp_bail>
 2dd0e52:	mov    0x18(%rsp),%rax
 2dd0e57:	mov    $0x1,%cl
 2dd0e59:	jmp    2dd0f17 <fast_pp_skip_inactive+0xb37>
 2dd0e5e:	xor    %ecx,%ecx
 2dd0e60:	mov    %r14,0x10(%rsp)
 2dd0e65:	xor    %r11d,%r11d
 2dd0e68:	xor    %edi,%edi
 2dd0e6a:	xor    %edx,%edx
 2dd0e6c:	xor    %r12d,%r12d
 2dd0e6f:	xor    %ebx,%ebx
 2dd0e71:	mov    %r13d,%r10d
 2dd0e74:	vbroadcasti32x4 -0x23b6b7e(%rip),%zmm1        # a1a300 <switch.table.ir_if_convert_test_reload+0x118>
 2dd0e7e:	vbroadcasti32x4 -0x23b6b68(%rip),%zmm2        # a1a320 <switch.table.ir_if_convert_test_reload+0x138>
 2dd0e88:	vbroadcasti32x4 -0x23b6b62(%rip),%zmm3        # a1a330 <switch.table.ir_if_convert_test_reload+0x148>
 2dd0e92:	vbroadcasti32x4 -0x23b6b5c(%rip),%zmm4        # a1a340 <switch.table.ir_if_convert_test_reload+0x158>
 2dd0e9c:	vbroadcasti32x4 -0x23b6b56(%rip),%zmm5        # a1a350 <switch.table.ir_if_convert_test_reload+0x168>
 2dd0ea6:	vbroadcasti32x4 -0x23b6b50(%rip),%zmm6        # a1a360 <switch.table.ir_if_convert_test_reload+0x178>
 2dd0eb0:	vbroadcasti32x4 -0x23b6b4a(%rip),%zmm7        # a1a370 <switch.table.ir_if_convert_test_reload+0x188>
 2dd0eba:	vbroadcasti32x4 -0x23b6b44(%rip),%zmm8        # a1a380 <switch.table.ir_if_convert_test_reload+0x198>
 2dd0ec4:	vbroadcasti32x4 -0x23b6b3e(%rip),%zmm9        # a1a390 <switch.table.ir_if_convert_test_reload+0x1a8>
 2dd0ece:	vbroadcasti32x4 -0x23b6b38(%rip),%zmm10        # a1a3a0 <switch.table.ir_if_convert_test_reload+0x1b8>
 2dd0ed8:	vbroadcasti32x4 -0x23b6b32(%rip),%zmm11        # a1a3b0 <switch.table.ir_if_convert_test_reload+0x1c8>
 2dd0ee2:	vbroadcasti32x4 -0x23b6b2c(%rip),%zmm12        # a1a3c0 <switch.table.ir_if_convert_test_reload+0x1d8>
 2dd0eec:	vbroadcasti32x4 -0x23b6b26(%rip),%zmm13        # a1a3d0 <switch.table.ir_if_convert_test_reload+0x1e8>
 2dd0ef6:	vbroadcasti32x4 -0x23b6b20(%rip),%zmm14        # a1a3e0 <switch.table.ir_if_convert_test_reload+0x1f8>
 2dd0f00:	jmp    2dd0fc5 <fast_pp_skip_inactive+0xbe5>
 2dd0f05:	lea    0x84(%rsp),%rdx
 2dd0f0d:	vzeroupper
 2dd0f10:	call   45dd450 <fast_skip_line_comment>
 2dd0f15:	xor    %ecx,%ecx
 2dd0f17:	vbroadcasti32x4 -0x23b6c21(%rip),%zmm1        # a1a300 <switch.table.ir_if_convert_test_reload+0x118>
 2dd0f21:	vbroadcasti32x4 -0x23b6c0b(%rip),%zmm2        # a1a320 <switch.table.ir_if_convert_test_reload+0x138>
 2dd0f2b:	vbroadcasti32x4 -0x23b6c05(%rip),%zmm3        # a1a330 <switch.table.ir_if_convert_test_reload+0x148>
 2dd0f35:	vbroadcasti32x4 -0x23b6bff(%rip),%zmm4        # a1a340 <switch.table.ir_if_convert_test_reload+0x158>
 2dd0f3f:	vbroadcasti32x4 -0x23b6bf9(%rip),%zmm5        # a1a350 <switch.table.ir_if_convert_test_reload+0x168>
 2dd0f49:	vbroadcasti32x4 -0x23b6bf3(%rip),%zmm6        # a1a360 <switch.table.ir_if_convert_test_reload+0x178>
 2dd0f53:	vbroadcasti32x4 -0x23b6bed(%rip),%zmm7        # a1a370 <switch.table.ir_if_convert_test_reload+0x188>
 2dd0f5d:	vbroadcasti32x4 -0x23b6be7(%rip),%zmm8        # a1a380 <switch.table.ir_if_convert_test_reload+0x198>
 2dd0f67:	vbroadcasti32x4 -0x23b6be1(%rip),%zmm9        # a1a390 <switch.table.ir_if_convert_test_reload+0x1a8>
 2dd0f71:	vbroadcasti32x4 -0x23b6bdb(%rip),%zmm10        # a1a3a0 <switch.table.ir_if_convert_test_reload+0x1b8>
 2dd0f7b:	vbroadcasti32x4 -0x23b6bd5(%rip),%zmm11        # a1a3b0 <switch.table.ir_if_convert_test_reload+0x1c8>
 2dd0f85:	vbroadcasti32x4 -0x23b6bcf(%rip),%zmm12        # a1a3c0 <switch.table.ir_if_convert_test_reload+0x1d8>
 2dd0f8f:	vbroadcasti32x4 -0x23b6bc9(%rip),%zmm13        # a1a3d0 <switch.table.ir_if_convert_test_reload+0x1e8>
 2dd0f99:	vbroadcasti32x4 -0x23b6bc3(%rip),%zmm14        # a1a3e0 <switch.table.ir_if_convert_test_reload+0x1f8>
 2dd0fa3:	mov    %ebp,%r10d
 2dd0fa6:	add    0x84(%rsp),%r10d
 2dd0fae:	mov    0x18(%rsp),%rsi
 2dd0fb3:	xor    %r11d,%r11d
 2dd0fb6:	xor    %edi,%edi
 2dd0fb8:	xor    %edx,%edx
 2dd0fba:	xor    %r12d,%r12d
 2dd0fbd:	mov    %rax,%r14
 2dd0fc0:	mov    %rax,0x10(%rsp)
 2dd0fc5:	mov    0x48(%rsp),%r8
 2dd0fca:	cmp    %rsi,%r14
 2dd0fcd:	jb     2dd06e4 <fast_pp_skip_inactive+0x304>
 2dd0fd3:	jmp    2dd1f3f <fast_pp_skip_inactive+0x1b5f>
 2dd0fd8:	cmpb   $0x27,0x20(%rsp)
 2dd0fdd:	jne    2dd103b <fast_pp_skip_inactive+0xc5b>
 2dd0fdf:	mov    0x38(%rsp),%rax
 2dd0fe4:	cmpb   $0x0,0xe979(%rax)
 2dd0feb:	je     2dd103b <fast_pp_skip_inactive+0xc5b>
 2dd0fed:	mov    0x50(%rsp),%rax
 2dd0ff2:	lea    (%r15,%rbp,1),%rcx
 2dd0ff6:	cmp    (%rax),%rcx
 2dd0ff9:	jbe    2dd103b <fast_pp_skip_inactive+0xc5b>
 2dd0ffb:	movzbl -0x1(%r15,%rbp,1),%eax
 2dd1001:	lea    -0x23b3208(%rip),%rcx        # a1de00 <fast_char_class>
 2dd1008:	testb  $0x1,(%rax,%rcx,1)
 2dd100c:	je     2dd103b <fast_pp_skip_inactive+0xc5b>
 2dd100e:	jmp    2dd1f20 <fast_pp_skip_inactive+0x1b40>
 2dd1013:	mov    0x50(%rsp),%rax
 2dd1018:	lea    (%r15,%rbp,1),%rsi
 2dd101c:	mov    (%rax),%rdi
 2dd101f:	mov    0x38(%rsp),%rax
 2dd1024:	movzbl 0xe9d0(%rax),%edx
 2dd102b:	vzeroupper
 2dd102e:	call   45df090 <fast_raw_string_before>
 2dd1033:	test   %al,%al
 2dd1035:	jne    2dd2095 <fast_pp_skip_inactive+0x1cb5>
 2dd103b:	lea    (%r15,%rbp,1),%rax
 2dd103f:	cmp    0x28(%rsp),%rax
 2dd1044:	jae    2dd11bd <fast_pp_skip_inactive+0xddd>
 2dd104a:	sub    %r15,%r12
 2dd104d:	sub    %rbp,%r12
 2dd1050:	cmp    $0x8,%r12
 2dd1054:	jb     2dd11a8 <fast_pp_skip_inactive+0xdc8>
 2dd105a:	cmp    $0x40,%r12
 2dd105e:	jae    2dd1067 <fast_pp_skip_inactive+0xc87>
 2dd1060:	xor    %ecx,%ecx
 2dd1062:	jmp    2dd113a <fast_pp_skip_inactive+0xd5a>
 2dd1067:	mov    %r14,%rdx
 2dd106a:	and    $0xffffffffffffffc0,%rdx
 2dd106e:	lea    (%r15,%rbp,1),%rax
 2dd1072:	mov    %r12,%rcx
 2dd1075:	and    $0xffffffffffffffc0,%rcx
 2dd1079:	vmovd  %r13d,%xmm0
 2dd107e:	vpxor  %xmm1,%xmm1,%xmm1
 2dd1082:	vpxor  %xmm2,%xmm2,%xmm2
 2dd1086:	vpxor  %xmm3,%xmm3,%xmm3
 2dd108a:	add    %rdx,%rax
 2dd108d:	vpbroadcastb -0x23b5516(%rip),%xmm4        # a1bb80 <fast_operand_complex_class+0xdf8>
 2dd1096:	vpcmpeqb -0x30(%rbx),%xmm4,%k0
 2dd109d:	vpcmpeqb -0x20(%rbx),%xmm4,%k1
 2dd10a4:	vpcmpeqb -0x10(%rbx),%xmm4,%k2
 2dd10ab:	vpcmpeqb (%rbx),%xmm4,%k3
 2dd10b1:	add    $0x40,%rbx
 2dd10b5:	add    $0xffffffffffffffc0,%rdx
 2dd10b9:	vpmovm2d %k0,%zmm4
 2dd10bf:	vpaddd %zmm4,%zmm0,%zmm0
 2dd10c5:	vpmovm2d %k1,%zmm4
 2dd10cb:	vpaddd %zmm4,%zmm1,%zmm1
 2dd10d1:	vpmovm2d %k2,%zmm4
 2dd10d7:	vpaddd %zmm4,%zmm2,%zmm2
 2dd10dd:	vpmovm2d %k3,%zmm4
 2dd10e3:	vpaddd %zmm4,%zmm3,%zmm3
 2dd10e9:	jne    2dd108d <fast_pp_skip_inactive+0xcad>
 2dd10eb:	vpaddd %zmm0,%zmm1,%zmm0
 2dd10f1:	vpaddd %zmm0,%zmm2,%zmm0
 2dd10f7:	vpaddd %zmm0,%zmm3,%zmm0
 2dd10fd:	vextracti64x4 $0x1,%zmm0,%ymm1
 2dd1104:	vpaddd %zmm1,%zmm0,%zmm0
 2dd110a:	vextracti128 $0x1,%ymm0,%xmm1
 2dd1110:	vpaddd %xmm1,%xmm0,%xmm0
 2dd1114:	vpshufd $0xee,%xmm0,%xmm1
 2dd1119:	vpaddd %xmm1,%xmm0,%xmm0
 2dd111d:	vpshufd $0x55,%xmm0,%xmm1
 2dd1122:	vpaddd %xmm1,%xmm0,%xmm0
 2dd1126:	vmovd  %xmm0,%r13d
 2dd112b:	cmp    %rcx,%r12
 2dd112e:	je     2dd11bd <fast_pp_skip_inactive+0xddd>
 2dd1134:	test   $0x38,%r12b
 2dd1138:	je     2dd11a8 <fast_pp_skip_inactive+0xdc8>
 2dd113a:	add    %rcx,0x30(%rsp)
 2dd113f:	and    $0xfffffffffffffff8,%r14
 2dd1143:	lea    (%r15,%rbp,1),%rax
 2dd1147:	mov    %r12,%rdx
 2dd114a:	and    $0xfffffffffffffff8,%rdx
 2dd114e:	vmovd  %r13d,%xmm0
 2dd1153:	add    %r14,%rax
 2dd1156:	sub    %rcx,%r14
 2dd1159:	xor    %ecx,%ecx
 2dd115b:	mov    0x30(%rsp),%rsi
 2dd1160:	vmovq  (%rsi,%rcx,1),%xmm1
 2dd1165:	add    $0x8,%rcx
 2dd1169:	vpcmpeqb -0x23b6e63(%rip),%xmm1,%k0        # a1a310 <switch.table.ir_if_convert_test_reload+0x128>
 2dd1173:	vpmovm2d %k0,%ymm1
 2dd1179:	vpaddd %ymm1,%ymm0,%ymm0
 2dd117d:	cmp    %rcx,%r14
 2dd1180:	jne    2dd115b <fast_pp_skip_inactive+0xd7b>
 2dd1182:	vextracti128 $0x1,%ymm0,%xmm1
 2dd1188:	vpaddd %xmm1,%xmm0,%xmm0
 2dd118c:	vpshufd $0xee,%xmm0,%xmm1
 2dd1191:	vpaddd %xmm1,%xmm0,%xmm0
 2dd1195:	vpshufd $0x55,%xmm0,%xmm1
 2dd119a:	vpaddd %xmm1,%xmm0,%xmm0
 2dd119e:	vmovd  %xmm0,%r13d
 2dd11a3:	cmp    %rdx,%r12
 2dd11a6:	je     2dd11bd <fast_pp_skip_inactive+0xddd>
 2dd11a8:	xor    %ecx,%ecx
 2dd11aa:	cmpb   $0xa,(%rax)
 2dd11ad:	sete   %cl
 2dd11b0:	inc    %rax
 2dd11b3:	sub    %ecx,%r13d
 2dd11b6:	cmp    0x28(%rsp),%rax
 2dd11bb:	jb     2dd11a8 <fast_pp_skip_inactive+0xdc8>
 2dd11bd:	lea    0x1(%r15,%rbp,1),%rax
 2dd11c2:	mov    %rax,0x10(%rsp)
 2dd11c7:	cmp    0x18(%rsp),%rax
 2dd11cc:	jb     2dd11f9 <fast_pp_skip_inactive+0xe19>
 2dd11ce:	xor    %ecx,%ecx
 2dd11d0:	mov    0x10(%rsp),%r14
 2dd11d5:	xor    %r11d,%r11d
 2dd11d8:	xor    %edi,%edi
 2dd11da:	xor    %edx,%edx
 2dd11dc:	xor    %r12d,%r12d
 2dd11df:	xor    %ebx,%ebx
 2dd11e1:	jmp    2dd125b <fast_pp_skip_inactive+0xe7b>
 2dd11e3:	mov    0x10(%rsp),%rdx
 2dd11e8:	xor    %ecx,%ecx
 2dd11ea:	add    %rax,%rdx
 2dd11ed:	mov    %rdx,0x10(%rsp)
 2dd11f2:	cmp    0x18(%rsp),%rdx
 2dd11f7:	jae    2dd11d0 <fast_pp_skip_inactive+0xdf0>
 2dd11f9:	mov    0x10(%rsp),%rax
 2dd11fe:	movzbl (%rax),%ecx
 2dd1201:	cmp    0x20(%rsp),%cl
 2dd1205:	je     2dd1237 <fast_pp_skip_inactive+0xe57>
 2dd1207:	cmp    $0xa,%cl
 2dd120a:	je     2dd1237 <fast_pp_skip_inactive+0xe57>
 2dd120c:	mov    $0x1,%eax
 2dd1211:	cmp    $0x5c,%cl
 2dd1214:	jne    2dd11e3 <fast_pp_skip_inactive+0xe03>
 2dd1216:	mov    0x10(%rsp),%rcx
 2dd121b:	inc    %rcx
 2dd121e:	cmp    0x18(%rsp),%rcx
 2dd1223:	jae    2dd11e3 <fast_pp_skip_inactive+0xe03>
 2dd1225:	xor    %eax,%eax
 2dd1227:	cmpb   $0xa,(%rcx)
 2dd122a:	sete   %al
 2dd122d:	add    %eax,%r13d
 2dd1230:	mov    $0x2,%eax
 2dd1235:	jmp    2dd11e3 <fast_pp_skip_inactive+0xe03>
 2dd1237:	xor    %eax,%eax
 2dd1239:	cmp    0x20(%rsp),%cl
 2dd123d:	mov    0x10(%rsp),%r14
 2dd1242:	sete   %al
 2dd1245:	xor    %ecx,%ecx
 2dd1247:	xor    %r11d,%r11d
 2dd124a:	xor    %edi,%edi
 2dd124c:	xor    %edx,%edx
 2dd124e:	xor    %r12d,%r12d
 2dd1251:	xor    %ebx,%ebx
 2dd1253:	add    %rax,%r14
 2dd1256:	mov    %r14,0x10(%rsp)
 2dd125b:	mov    %r13d,%r10d
 2dd125e:	jmp    2dd0b87 <fast_pp_skip_inactive+0x7a7>
 2dd1263:	cmp    %rsi,%r14
 2dd1266:	jae    2dd1ee1 <fast_pp_skip_inactive+0x1b01>
 2dd126c:	vbroadcasti32x4 -0x23b6f76(%rip),%zmm5        # a1a300 <switch.table.ir_if_convert_test_reload+0x118>
 2dd1276:	vbroadcasti32x4 -0x23b6f60(%rip),%zmm6        # a1a320 <switch.table.ir_if_convert_test_reload+0x138>
 2dd1280:	vbroadcasti32x4 -0x23b6f5a(%rip),%zmm7        # a1a330 <switch.table.ir_if_convert_test_reload+0x148>
 2dd128a:	vbroadcasti32x4 -0x23b6f54(%rip),%zmm8        # a1a340 <switch.table.ir_if_convert_test_reload+0x158>
 2dd1294:	vbroadcasti32x4 -0x23b6f4e(%rip),%zmm9        # a1a350 <switch.table.ir_if_convert_test_reload+0x168>
 2dd129e:	vbroadcasti32x4 -0x23b6f48(%rip),%zmm10        # a1a360 <switch.table.ir_if_convert_test_reload+0x178>
 2dd12a8:	vbroadcasti32x4 -0x23b6f42(%rip),%zmm11        # a1a370 <switch.table.ir_if_convert_test_reload+0x188>
 2dd12b2:	vbroadcasti32x4 -0x23b6f3c(%rip),%zmm12        # a1a380 <switch.table.ir_if_convert_test_reload+0x198>
 2dd12bc:	vbroadcasti32x4 -0x23b6f36(%rip),%zmm13        # a1a390 <switch.table.ir_if_convert_test_reload+0x1a8>
 2dd12c6:	vbroadcasti32x4 -0x23b6f30(%rip),%zmm14        # a1a3a0 <switch.table.ir_if_convert_test_reload+0x1b8>
 2dd12d0:	vpbroadcastb -0x23b5759(%rip),%xmm15        # a1bb80 <fast_operand_complex_class+0xdf8>
 2dd12d9:	vpbroadcastb -0x23b5763(%rip),%xmm16        # a1bb80 <fast_operand_complex_class+0xdf8>
 2dd12e3:	vbroadcasti32x4 -0x23b6f2d(%rip),%zmm17        # a1a3c0 <switch.table.ir_if_convert_test_reload+0x1d8>
 2dd12ed:	vbroadcasti32x4 -0x23b6f27(%rip),%zmm18        # a1a3d0 <switch.table.ir_if_convert_test_reload+0x1e8>
 2dd12f7:	vbroadcasti32x4 -0x23b6f21(%rip),%zmm19        # a1a3e0 <switch.table.ir_if_convert_test_reload+0x1f8>
 2dd1301:	lea    -0x23aa220(%rip),%rax        # a270e8 <fast_cc_binary_questioned.range_narrow+0x29a8>
 2dd1308:	mov    %rbx,%r9
 2dd130b:	movq   $0x0,0x60(%rsp)
 2dd1314:	movq   $0x0,0x78(%rsp)
 2dd131d:	movq   $0x0,0x90(%rsp)
 2dd1329:	movq   $0x0,0x20(%rsp)
 2dd1332:	xor    %r8d,%r8d
 2dd1335:	xor    %ebx,%ebx
 2dd1337:	xor    %r15d,%r15d
 2dd133a:	xor    %edi,%edi
 2dd133c:	mov    %r14,0x10(%rsp)
 2dd1341:	mov    %rax,0xa0(%rsp)
 2dd1349:	nopl   0x0(%rax)
 2dd1350:	mov    %rsi,%rdx
 2dd1353:	sub    %r14,%rdx
 2dd1356:	mov    %rdi,0x28(%rsp)
 2dd135b:	mov    %r15,0x30(%rsp)
 2dd1360:	mov    %r10d,0xc(%rsp)
 2dd1365:	mov    %rbx,0x70(%rsp)
 2dd136a:	cmp    $0x40,%rdx
 2dd136e:	jb     2dd14d6 <fast_pp_skip_inactive+0x10f6>
 2dd1374:	vmovdqu64 (%r14),%zmm0
 2dd137a:	mov    %r14,%rax
 2dd137d:	mov    $0x40,%edx
 2dd1382:	vpcmpeqb %zmm5,%zmm0,%k0
 2dd1388:	vpcmpeqb %zmm10,%zmm0,%k1
 2dd138e:	mov    $0xffffffffffffffff,%rcx
 2dd1395:	vpaddb %zmm13,%zmm0,%zmm1
 2dd139b:	xor    %r14d,%r14d
 2dd139e:	kmovq  %k0,%r10
 2dd13a3:	vpcmpeqb %zmm9,%zmm0,%k0
 2dd13a9:	bzhi   %rdx,%rcx,%rbx
 2dd13ae:	korq   %k1,%k0,%k0
 2dd13b3:	vpcmpeqb %zmm12,%zmm0,%k1
 2dd13b9:	mov    %rbx,%r12
 2dd13bc:	not    %r12
 2dd13bf:	lea    (%r10,%r10,1),%rdi
 2dd13c3:	mov    %r10,%rbp
 2dd13c6:	not    %rbp
 2dd13c9:	kmovq  %k1,%rcx
 2dd13ce:	vpcmpltub %zmm14,%zmm1,%k1
 2dd13d5:	kmovq  %k0,%r13
 2dd13da:	vpcmpeqb %zmm11,%zmm0,%k0
 2dd13e0:	or     %r9,%rdi
 2dd13e3:	kmovq  %k1,%rsi
 2dd13e8:	or     %rcx,%r12
 2dd13eb:	mov    0x20(%rsp),%rcx
 2dd13f0:	kmovq  %k0,%r11
 2dd13f5:	andn   %rsi,%r10,%rsi
 2dd13fa:	lea    (%r11,%r11,1),%r9
 2dd13fe:	or     %rsi,%r12
 2dd1401:	mov    %r12,%rsi
 2dd1404:	and    %rdi,%rsi
 2dd1407:	add    %r12,%rsi
 2dd140a:	setb   %r15b
 2dd140e:	or     %r8,%r9
 2dd1411:	or     %r9,%rbp
 2dd1414:	add    $0xff,%cl
 2dd1417:	adc    %rbp,%r13
 2dd141a:	setb   %cl
 2dd141d:	mov    %rcx,0x20(%rsp)
 2dd1422:	test   %r9,%r9
 2dd1425:	jne    2dd14f8 <fast_pp_skip_inactive+0x1118>
 2dd142b:	xor    %r9d,%r9d
 2dd142e:	vpcmpeqb %zmm6,%zmm0,%k0
 2dd1434:	or     %rdi,%rsi
 2dd1437:	vpcmpeqb %zmm8,%zmm0,%k1
 2dd143d:	kmovq  %k0,%r8
 2dd1442:	vpcmpeqb %zmm7,%zmm0,%k0
 2dd1448:	andn   %rsi,%r12,%r12
 2dd144d:	kmovq  %k0,%rcx
 2dd1452:	korq   %k0,%k1,%k1
 2dd1457:	and    %r12,%r8
 2dd145a:	lea    (%rcx,%rcx,1),%rsi
 2dd145e:	or     0x70(%rsp),%rsi
 2dd1463:	kmovq  %k1,%rdi
 2dd1468:	and    %rdi,%rsi
 2dd146b:	andn   %rbp,%r13,%rdi
 2dd1470:	or     %r8,%rsi
 2dd1473:	or     %r9,%rsi
 2dd1476:	and    %rbx,%rsi
 2dd1479:	jne    2dd1521 <fast_pp_skip_inactive+0x1141>
 2dd147f:	popcnt %r10,%rsi
 2dd1484:	mov    %r15b,%r14b
 2dd1487:	shr    $0x3f,%r10
 2dd148b:	shr    $0x3f,%r11
 2dd148f:	shr    $0x3f,%rcx
 2dd1493:	shr    $0x3f,%r12
 2dd1497:	shr    $0x3f,%rdi
 2dd149b:	add    %esi,0xc(%rsp)
 2dd149f:	mov    0x18(%rsp),%rsi
 2dd14a4:	or     %r14,%r10
 2dd14a7:	mov    %rax,%r14
 2dd14aa:	add    %rdx,%r14
 2dd14ad:	xor    %edx,%edx
 2dd14af:	mov    %r12,%r15
 2dd14b2:	mov    %rcx,%rbx
 2dd14b5:	mov    %r11,%r8
 2dd14b8:	mov    %r10,%r9
 2dd14bb:	cmp    %rsi,%r14
 2dd14be:	jae    2dd1fb6 <fast_pp_skip_inactive+0x1bd6>
 2dd14c4:	mov    0xc(%rsp),%r10d
 2dd14c9:	test   %dl,%dl
 2dd14cb:	je     2dd1350 <fast_pp_skip_inactive+0xf70>
 2dd14d1:	jmp    2dd1fbb <fast_pp_skip_inactive+0x1bdb>
 2dd14d6:	mov    $0xffffffffffffffff,%rax
 2dd14dd:	shlx   %rdx,%rax,%rcx
 2dd14e2:	mov    %r14,%rax
 2dd14e5:	not    %rcx
 2dd14e8:	kmovq  %rcx,%k1
 2dd14ed:	vmovdqu8 (%r14),%zmm0{%k1}{z}
 2dd14f3:	jmp    2dd1382 <fast_pp_skip_inactive+0xfa2>
 2dd14f8:	vpandq %zmm17,%zmm0,%zmm1
 2dd14fe:	vpcmpeqb %zmm19,%zmm0,%k2
 2dd1504:	vpcmpeqb %zmm18,%zmm1,%k1
 2dd150a:	korq   %k2,%k0,%k0
 2dd150f:	korq   %k1,%k0,%k0
 2dd1514:	kmovq  %k0,%rcx
 2dd1519:	and    %rcx,%r9
 2dd151c:	jmp    2dd142e <fast_pp_skip_inactive+0x104e>
 2dd1521:	xor    %ebp,%ebp
 2dd1523:	tzcnt  %rsi,%rbp
 2dd1528:	bt     %rbp,%r8
 2dd152c:	jae    2dd1544 <fast_pp_skip_inactive+0x1164>
 2dd152e:	mov    0xc(%rsp),%r11d
 2dd1533:	mov    0x30(%rsp),%r15
 2dd1538:	shrx   %rbp,%rdi,%rdx
 2dd153d:	mov    $0x1,%bl
 2dd153f:	and    $0x1,%edx
 2dd1542:	jmp    2dd1581 <fast_pp_skip_inactive+0x11a1>
 2dd1544:	mov    0x30(%rsp),%r15
 2dd1549:	mov    $0xffffffff,%ecx
 2dd154e:	mov    0xc(%rsp),%r11d
 2dd1553:	lea    0x0(%rbp,%rcx,1),%esi
 2dd1557:	shrx   %rsi,%r12,%rcx
 2dd155c:	and    $0x1,%ecx
 2dd155f:	test   %rbp,%rbp
 2dd1562:	mov    %r15d,%edx
 2dd1565:	cmovne %ecx,%edx
 2dd1568:	test   %edx,%edx
 2dd156a:	setne  %bl
 2dd156d:	test   %rbp,%rbp
 2dd1570:	je     2dd157c <fast_pp_skip_inactive+0x119c>
 2dd1572:	shrx   %rsi,%rdi,%rdx
 2dd1577:	and    $0x1,%edx
 2dd157a:	jmp    2dd1581 <fast_pp_skip_inactive+0x11a1>
 2dd157c:	mov    0x28(%rsp),%rdx
 2dd1581:	mov    $0xffffffffffffffff,%rdi
 2dd1588:	shrx   %rbp,%r8,%rcx
 2dd158d:	lea    (%rax,%rbp,1),%rsi
 2dd1591:	bzhi   %rbp,%rdi,%rdi
 2dd1596:	mov    %rcx,%r8
 2dd1599:	or     $0xfffffffffffffffe,%r8
 2dd159d:	and    %r10,%rdi
 2dd15a0:	lea    (%rsi,%r8,1),%r13
 2dd15a4:	popcnt %rdi,%rdi
 2dd15a9:	add    %edi,%r11d
 2dd15ac:	mov    %r11d,0xc(%rsp)
 2dd15b1:	test   %edx,%edx
 2dd15b3:	jne    2dd1bbd <fast_pp_skip_inactive+0x17dd>
 2dd15b9:	test   $0x1,%cl
 2dd15bc:	je     2dd1612 <fast_pp_skip_inactive+0x1232>
 2dd15be:	mov    0x18(%rsp),%rbx
 2dd15c3:	mov    0x38(%rsp),%r12
 2dd15c8:	add    $0x2,%r13
 2dd15cc:	mov    %r13,%rdi
 2dd15cf:	mov    %rbx,%rsi
 2dd15d2:	vzeroupper
 2dd15d5:	call   45db750 <fast_skip_hspace>
 2dd15da:	mov    %rbx,%rsi
 2dd15dd:	mov    %rax,%r14
 2dd15e0:	cmp    %rbx,%rax
 2dd15e3:	jae    2dd15fa <fast_pp_skip_inactive+0x121a>
 2dd15e5:	movzbl (%r14),%ebx
 2dd15e9:	lea    -0x23b37f0(%rip),%rax        # a1de00 <fast_char_class>
 2dd15f0:	testb  $0x2,(%rbx,%rax,1)
 2dd15f4:	jne    2dd1765 <fast_pp_skip_inactive+0x1385>
 2dd15fa:	xor    %edx,%edx
 2dd15fc:	xor    %ebx,%ebx
 2dd15fe:	xor    %r8d,%r8d
 2dd1601:	xor    %r9d,%r9d
 2dd1604:	movq   $0x0,0x20(%rsp)
 2dd160d:	jmp    2dd19e9 <fast_pp_skip_inactive+0x1609>
 2dd1612:	mov    0x18(%rsp),%rsi
 2dd1617:	shrx   %rbp,%r9,%rax
 2dd161c:	test   $0x1,%al
 2dd161e:	je     2dd1715 <fast_pp_skip_inactive+0x1335>
 2dd1624:	add    $0x2,%r13
 2dd1628:	mov    %r13,%rdi
 2dd162b:	vzeroupper
 2dd162e:	call   45df150 <fast_skip_splices>
 2dd1633:	mov    0x18(%rsp),%rsi
 2dd1638:	cmp    %rsi,%rax
 2dd163b:	jae    2dd17a2 <fast_pp_skip_inactive+0x13c2>
 2dd1641:	vbroadcasti32x4 -0x23b734b(%rip),%zmm5        # a1a300 <switch.table.ir_if_convert_test_reload+0x118>
 2dd164b:	vbroadcasti32x4 -0x23b7335(%rip),%zmm6        # a1a320 <switch.table.ir_if_convert_test_reload+0x138>
 2dd1655:	vbroadcasti32x4 -0x23b732f(%rip),%zmm7        # a1a330 <switch.table.ir_if_convert_test_reload+0x148>
 2dd165f:	vbroadcasti32x4 -0x23b7329(%rip),%zmm8        # a1a340 <switch.table.ir_if_convert_test_reload+0x158>
 2dd1669:	vbroadcasti32x4 -0x23b7323(%rip),%zmm9        # a1a350 <switch.table.ir_if_convert_test_reload+0x168>
 2dd1673:	vbroadcasti32x4 -0x23b731d(%rip),%zmm10        # a1a360 <switch.table.ir_if_convert_test_reload+0x178>
 2dd167d:	vbroadcasti32x4 -0x23b7317(%rip),%zmm11        # a1a370 <switch.table.ir_if_convert_test_reload+0x188>
 2dd1687:	vbroadcasti32x4 -0x23b7311(%rip),%zmm12        # a1a380 <switch.table.ir_if_convert_test_reload+0x198>
 2dd1691:	vbroadcasti32x4 -0x23b730b(%rip),%zmm13        # a1a390 <switch.table.ir_if_convert_test_reload+0x1a8>
 2dd169b:	vbroadcasti32x4 -0x23b7305(%rip),%zmm14        # a1a3a0 <switch.table.ir_if_convert_test_reload+0x1b8>
 2dd16a5:	vpbroadcastb -0x23b5b2e(%rip),%xmm15        # a1bb80 <fast_operand_complex_class+0xdf8>
 2dd16ae:	vpbroadcastb -0x23b5b38(%rip),%xmm16        # a1bb80 <fast_operand_complex_class+0xdf8>
 2dd16b8:	vbroadcasti32x4 -0x23b7302(%rip),%zmm17        # a1a3c0 <switch.table.ir_if_convert_test_reload+0x1d8>
 2dd16c2:	vbroadcasti32x4 -0x23b72fc(%rip),%zmm18        # a1a3d0 <switch.table.ir_if_convert_test_reload+0x1e8>
 2dd16cc:	vbroadcasti32x4 -0x23b72f6(%rip),%zmm19        # a1a3e0 <switch.table.ir_if_convert_test_reload+0x1f8>
 2dd16d6:	movzbl (%rax),%ecx
 2dd16d9:	xor    %ebx,%ebx
 2dd16db:	movq   $0x0,0x20(%rsp)
 2dd16e4:	xor    %edx,%edx
 2dd16e6:	add    $0xffffffb2,%ecx
 2dd16e9:	cmp    $0x27,%ecx
 2dd16ec:	ja     2dd1702 <fast_pp_skip_inactive+0x1322>
 2dd16ee:	movabs $0x8000000081,%rax
 2dd16f8:	bt     %rcx,%rax
 2dd16fc:	jb     2dd1f8a <fast_pp_skip_inactive+0x1baa>
 2dd1702:	mov    %r13,0x10(%rsp)
 2dd1707:	xor    %r8d,%r8d
 2dd170a:	xor    %r9d,%r9d
 2dd170d:	mov    %r13,%r14
 2dd1710:	jmp    2dd1a83 <fast_pp_skip_inactive+0x16a3>
 2dd1715:	movl   $0x0,0x80(%rsp)
 2dd1720:	mov    0x38(%rsp),%r14
 2dd1725:	lea    0x3(%r13),%rdi
 2dd1729:	cmpb   $0x2a,0x2(%r13)
 2dd172e:	jne    2dd17c2 <fast_pp_skip_inactive+0x13e2>
 2dd1734:	lea    0x80(%rsp),%rdx
 2dd173c:	vzeroupper
 2dd173f:	call   45dd360 <fast_skip_block_comment>
 2dd1744:	test   %rax,%rax
 2dd1747:	jne    2dd17d2 <fast_pp_skip_inactive+0x13f2>
 2dd174d:	lea    -0x23aa610(%rip),%rsi        # a27144 <fast_cc_binary_questioned.range_narrow+0x2a04>
 2dd1754:	mov    %r14,%rdi
 2dd1757:	call   45daa79 <fast_pp_bail>
 2dd175c:	mov    0x18(%rsp),%rcx
 2dd1761:	mov    $0x1,%dl
 2dd1763:	jmp    2dd17d7 <fast_pp_skip_inactive+0x13f7>
 2dd1765:	mov    %r14,%rdi
 2dd1768:	call   45ddbb0 <fast_scan_ident_len>
 2dd176d:	lea    -0x2(%rax),%ecx
 2dd1770:	cmp    $0x6,%ecx
 2dd1773:	ja     2dd19cc <fast_pp_skip_inactive+0x15ec>
 2dd1779:	lea    -0x23ad430(%rip),%rdx        # a24350 <c_direct_test_dependencies.levels+0x73>
 2dd1780:	movslq (%rdx,%rcx,4),%rcx
 2dd1784:	add    %rdx,%rcx
 2dd1787:	jmp    *%rcx
 2dd1789:	cmp    $0x69,%bl
 2dd178c:	jne    2dd19cc <fast_pp_skip_inactive+0x15ec>
 2dd1792:	cmpb   $0x66,0x1(%r14)
 2dd1797:	je     2dd1974 <fast_pp_skip_inactive+0x1594>
 2dd179d:	jmp    2dd19cc <fast_pp_skip_inactive+0x15ec>
 2dd17a2:	xor    %edx,%edx
 2dd17a4:	mov    %r13,0x10(%rsp)
 2dd17a9:	xor    %ebx,%ebx
 2dd17ab:	xor    %r8d,%r8d
 2dd17ae:	movq   $0x0,0x20(%rsp)
 2dd17b7:	xor    %r9d,%r9d
 2dd17ba:	mov    %r13,%r14
 2dd17bd:	jmp    2dd19ee <fast_pp_skip_inactive+0x160e>
 2dd17c2:	lea    0x80(%rsp),%rdx
 2dd17ca:	vzeroupper
 2dd17cd:	call   45dd450 <fast_skip_line_comment>
 2dd17d2:	mov    %rax,%rcx
 2dd17d5:	xor    %edx,%edx
 2dd17d7:	vbroadcasti32x4 -0x23b74e1(%rip),%zmm5        # a1a300 <switch.table.ir_if_convert_test_reload+0x118>
 2dd17e1:	vbroadcasti32x4 -0x23b74cb(%rip),%zmm6        # a1a320 <switch.table.ir_if_convert_test_reload+0x138>
 2dd17eb:	vbroadcasti32x4 -0x23b74c5(%rip),%zmm7        # a1a330 <switch.table.ir_if_convert_test_reload+0x148>
 2dd17f5:	vbroadcasti32x4 -0x23b74bf(%rip),%zmm8        # a1a340 <switch.table.ir_if_convert_test_reload+0x158>
 2dd17ff:	vbroadcasti32x4 -0x23b74b9(%rip),%zmm9        # a1a350 <switch.table.ir_if_convert_test_reload+0x168>
 2dd1809:	vbroadcasti32x4 -0x23b74b3(%rip),%zmm10        # a1a360 <switch.table.ir_if_convert_test_reload+0x178>
 2dd1813:	vbroadcasti32x4 -0x23b74ad(%rip),%zmm11        # a1a370 <switch.table.ir_if_convert_test_reload+0x188>
 2dd181d:	vbroadcasti32x4 -0x23b74a7(%rip),%zmm12        # a1a380 <switch.table.ir_if_convert_test_reload+0x198>
 2dd1827:	vbroadcasti32x4 -0x23b74a1(%rip),%zmm13        # a1a390 <switch.table.ir_if_convert_test_reload+0x1a8>
 2dd1831:	vbroadcasti32x4 -0x23b749b(%rip),%zmm14        # a1a3a0 <switch.table.ir_if_convert_test_reload+0x1b8>
 2dd183b:	vpbroadcastb -0x23b5cc4(%rip),%xmm15        # a1bb80 <fast_operand_complex_class+0xdf8>
 2dd1844:	vpbroadcastb -0x23b5cce(%rip),%xmm16        # a1bb80 <fast_operand_complex_class+0xdf8>
 2dd184e:	vbroadcasti32x4 -0x23b7498(%rip),%zmm17        # a1a3c0 <switch.table.ir_if_convert_test_reload+0x1d8>
 2dd1858:	vbroadcasti32x4 -0x23b7492(%rip),%zmm18        # a1a3d0 <switch.table.ir_if_convert_test_reload+0x1e8>
 2dd1862:	vbroadcasti32x4 -0x23b748c(%rip),%zmm19        # a1a3e0 <switch.table.ir_if_convert_test_reload+0x1f8>
 2dd186c:	mov    0xc(%rsp),%eax
 2dd1870:	movzbl %bl,%r9d
 2dd1874:	xor    %ebx,%ebx
 2dd1876:	xor    %r8d,%r8d
 2dd1879:	mov    %rcx,%r14
 2dd187c:	movq   $0x0,0x20(%rsp)
 2dd1885:	mov    %rcx,0x10(%rsp)
 2dd188a:	add    0x80(%rsp),%eax
 2dd1891:	mov    %eax,0xc(%rsp)
 2dd1895:	mov    0x18(%rsp),%rsi
 2dd189a:	mov    0x30(%rsp),%r15
 2dd189f:	jmp    2dd1a83 <fast_pp_skip_inactive+0x16a3>
 2dd18a4:	movzbl 0x4(%r14),%esi
 2dd18a9:	mov    (%r14),%ecx
 2dd18ac:	mov    $0x65646669,%edx
 2dd18b1:	xor    %edx,%ecx
 2dd18b3:	xor    $0x66,%esi
 2dd18b6:	or     %ecx,%esi
 2dd18b8:	je     2dd1974 <fast_pp_skip_inactive+0x1594>
 2dd18be:	movzbl 0x4(%r14),%esi
 2dd18c3:	mov    (%r14),%ecx
 2dd18c6:	mov    $0x69646e65,%edx
 2dd18cb:	xor    %edx,%ecx
 2dd18cd:	xor    $0x66,%esi
 2dd18d0:	or     %ecx,%esi
 2dd18d2:	jne    2dd19cc <fast_pp_skip_inactive+0x15ec>
 2dd18d8:	add    $0x5,%r14
 2dd18dc:	cmpl   $0x0,0x78(%rsp)
 2dd18e1:	mov    %r14,0x10(%rsp)
 2dd18e6:	je     2dd2075 <fast_pp_skip_inactive+0x1c95>
 2dd18ec:	mov    0x78(%rsp),%rax
 2dd18f1:	mov    0x10(%rsp),%r14
 2dd18f6:	xor    %edx,%edx
 2dd18f8:	xor    %ebx,%ebx
 2dd18fa:	xor    %r8d,%r8d
 2dd18fd:	xor    %r9d,%r9d
 2dd1900:	movq   $0x0,0x20(%rsp)
 2dd1909:	dec    %eax
 2dd190b:	mov    %rax,0x78(%rsp)
 2dd1910:	jmp    2dd1b23 <fast_pp_skip_inactive+0x1743>
 2dd1915:	movabs $0x6665646e66696c65,%rcx
 2dd191f:	cmp    %rcx,(%r14)
 2dd1922:	jne    2dd19cc <fast_pp_skip_inactive+0x15ec>
 2dd1928:	mov    $0x32,%bpl
 2dd192b:	mov    %r14,%rdx
 2dd192e:	jmp    2dd1aa8 <fast_pp_skip_inactive+0x16c8>
 2dd1933:	cmpl   $0x65736c65,(%r14)
 2dd193a:	mov    %r14,%rdx
 2dd193d:	je     2dd1a96 <fast_pp_skip_inactive+0x16b6>
 2dd1943:	cmpl   $0x66696c65,(%rdx)
 2dd1949:	mov    0x30(%rsp),%r15
 2dd194e:	mov    %rdx,%r14
 2dd1951:	jne    2dd19cc <fast_pp_skip_inactive+0x15ec>
 2dd1953:	mov    $0x4,%bpl
 2dd1956:	jmp    2dd1ac0 <fast_pp_skip_inactive+0x16e0>
 2dd195b:	movzwl 0x4(%r14),%esi
 2dd1960:	mov    (%r14),%ecx
 2dd1963:	mov    $0x646e6669,%edx
 2dd1968:	xor    %edx,%ecx
 2dd196a:	xor    $0x6665,%esi
 2dd1970:	or     %ecx,%esi
 2dd1972:	jne    2dd19cc <fast_pp_skip_inactive+0x15ec>
 2dd1974:	mov    0x78(%rsp),%rdx
 2dd1979:	mov    0x60(%rsp),%rcx
 2dd197e:	mov    %eax,%eax
 2dd1980:	add    %rax,%r14
 2dd1983:	xor    %eax,%eax
 2dd1985:	inc    %edx
 2dd1987:	cmp    $0x40,%edx
 2dd198a:	mov    %rdx,0x78(%rsp)
 2dd198f:	setae  %al
 2dd1992:	or     %eax,%ecx
 2dd1994:	mov    %rcx,0x60(%rsp)
 2dd1999:	mov    0x90(%rsp),%rcx
 2dd19a1:	btr    %rdx,%rcx
 2dd19a5:	mov    %rcx,0x90(%rsp)
 2dd19ad:	jmp    2dd19d1 <fast_pp_skip_inactive+0x15f1>
 2dd19af:	mov    (%r14),%ecx
 2dd19b2:	mov    0x3(%r14),%edi
 2dd19b6:	mov    $0x66696c65,%edx
 2dd19bb:	mov    $0x66656466,%esi
 2dd19c0:	xor    %edx,%ecx
 2dd19c2:	xor    %esi,%edi
 2dd19c4:	or     %ecx,%edi
 2dd19c6:	je     2dd1aa2 <fast_pp_skip_inactive+0x16c2>
 2dd19cc:	mov    %eax,%eax
 2dd19ce:	add    %rax,%r14
 2dd19d1:	mov    0x18(%rsp),%rsi
 2dd19d6:	xor    %edx,%edx
 2dd19d8:	xor    %ebx,%ebx
 2dd19da:	xor    %r8d,%r8d
 2dd19dd:	movq   $0x0,0x20(%rsp)
 2dd19e6:	xor    %r9d,%r9d
 2dd19e9:	mov    %r14,0x10(%rsp)
 2dd19ee:	vbroadcasti32x4 -0x23b76f8(%rip),%zmm5        # a1a300 <switch.table.ir_if_convert_test_reload+0x118>
 2dd19f8:	vbroadcasti32x4 -0x23b76e2(%rip),%zmm6        # a1a320 <switch.table.ir_if_convert_test_reload+0x138>
 2dd1a02:	vbroadcasti32x4 -0x23b76dc(%rip),%zmm7        # a1a330 <switch.table.ir_if_convert_test_reload+0x148>
 2dd1a0c:	vbroadcasti32x4 -0x23b76d6(%rip),%zmm8        # a1a340 <switch.table.ir_if_convert_test_reload+0x158>
 2dd1a16:	vbroadcasti32x4 -0x23b76d0(%rip),%zmm9        # a1a350 <switch.table.ir_if_convert_test_reload+0x168>
 2dd1a20:	vbroadcasti32x4 -0x23b76ca(%rip),%zmm10        # a1a360 <switch.table.ir_if_convert_test_reload+0x178>
 2dd1a2a:	vbroadcasti32x4 -0x23b76c4(%rip),%zmm11        # a1a370 <switch.table.ir_if_convert_test_reload+0x188>
 2dd1a34:	vbroadcasti32x4 -0x23b76be(%rip),%zmm12        # a1a380 <switch.table.ir_if_convert_test_reload+0x198>
 2dd1a3e:	vbroadcasti32x4 -0x23b76b8(%rip),%zmm13        # a1a390 <switch.table.ir_if_convert_test_reload+0x1a8>
 2dd1a48:	vbroadcasti32x4 -0x23b76b2(%rip),%zmm14        # a1a3a0 <switch.table.ir_if_convert_test_reload+0x1b8>
 2dd1a52:	vpbroadcastb -0x23b5edb(%rip),%xmm15        # a1bb80 <fast_operand_complex_class+0xdf8>
 2dd1a5b:	vpbroadcastb -0x23b5ee5(%rip),%xmm16        # a1bb80 <fast_operand_complex_class+0xdf8>
 2dd1a65:	vbroadcasti32x4 -0x23b76af(%rip),%zmm17        # a1a3c0 <switch.table.ir_if_convert_test_reload+0x1d8>
 2dd1a6f:	vbroadcasti32x4 -0x23b76a9(%rip),%zmm18        # a1a3d0 <switch.table.ir_if_convert_test_reload+0x1e8>
 2dd1a79:	vbroadcasti32x4 -0x23b76a3(%rip),%zmm19        # a1a3e0 <switch.table.ir_if_convert_test_reload+0x1f8>
 2dd1a83:	mov    0x28(%rsp),%rdi
 2dd1a88:	cmp    %rsi,%r14
 2dd1a8b:	jb     2dd14c4 <fast_pp_skip_inactive+0x10e4>
 2dd1a91:	jmp    2dd1fb6 <fast_pp_skip_inactive+0x1bd6>
 2dd1a96:	mov    $0xffffffffffffffff,%rcx
 2dd1a9d:	mov    $0x5,%bpl
 2dd1aa0:	jmp    2dd1ac2 <fast_pp_skip_inactive+0x16e2>
 2dd1aa2:	mov    %r14,%rdx
 2dd1aa5:	mov    $0x31,%bpl
 2dd1aa8:	movzbl 0xe979(%r12),%ecx
 2dd1ab1:	mov    0x60(%rsp),%rsi
 2dd1ab6:	xor    $0x1,%ecx
 2dd1ab9:	or     %ecx,%esi
 2dd1abb:	mov    %rsi,0x60(%rsp)
 2dd1ac0:	xor    %ecx,%ecx
 2dd1ac2:	mov    %rdx,%r14
 2dd1ac5:	mov    0x78(%rsp),%rdx
 2dd1aca:	mov    %eax,%eax
 2dd1acc:	add    %rax,%r14
 2dd1acf:	mov    %r14,0x10(%rsp)
 2dd1ad4:	test   %edx,%edx
 2dd1ad6:	je     2dd2078 <fast_pp_skip_inactive+0x1c98>
 2dd1adc:	mov    0x90(%rsp),%rdi
 2dd1ae4:	mov    $0x1,%eax
 2dd1ae9:	xor    %ebx,%ebx
 2dd1aeb:	xor    %r8d,%r8d
 2dd1aee:	movq   $0x0,0x20(%rsp)
 2dd1af7:	xor    %r9d,%r9d
 2dd1afa:	shlx   %rdx,%rax,%rax
 2dd1aff:	and    %rax,%rcx
 2dd1b02:	shrx   %rdx,%rdi,%rax
 2dd1b07:	mov    0x60(%rsp),%rdx
 2dd1b0c:	or     %rcx,%rdi
 2dd1b0f:	and    $0x1,%eax
 2dd1b12:	mov    %rdi,0x90(%rsp)
 2dd1b1a:	or     %eax,%edx
 2dd1b1c:	mov    %rdx,0x60(%rsp)
 2dd1b21:	xor    %edx,%edx
 2dd1b23:	vbroadcasti32x4 -0x23b782d(%rip),%zmm5        # a1a300 <switch.table.ir_if_convert_test_reload+0x118>
 2dd1b2d:	vbroadcasti32x4 -0x23b7817(%rip),%zmm6        # a1a320 <switch.table.ir_if_convert_test_reload+0x138>
 2dd1b37:	vbroadcasti32x4 -0x23b7811(%rip),%zmm7        # a1a330 <switch.table.ir_if_convert_test_reload+0x148>
 2dd1b41:	vbroadcasti32x4 -0x23b780b(%rip),%zmm8        # a1a340 <switch.table.ir_if_convert_test_reload+0x158>
 2dd1b4b:	vbroadcasti32x4 -0x23b7805(%rip),%zmm9        # a1a350 <switch.table.ir_if_convert_test_reload+0x168>
 2dd1b55:	vbroadcasti32x4 -0x23b77ff(%rip),%zmm10        # a1a360 <switch.table.ir_if_convert_test_reload+0x178>
 2dd1b5f:	vbroadcasti32x4 -0x23b77f9(%rip),%zmm11        # a1a370 <switch.table.ir_if_convert_test_reload+0x188>
 2dd1b69:	vbroadcasti32x4 -0x23b77f3(%rip),%zmm12        # a1a380 <switch.table.ir_if_convert_test_reload+0x198>
 2dd1b73:	vbroadcasti32x4 -0x23b77ed(%rip),%zmm13        # a1a390 <switch.table.ir_if_convert_test_reload+0x1a8>
 2dd1b7d:	vbroadcasti32x4 -0x23b77e7(%rip),%zmm14        # a1a3a0 <switch.table.ir_if_convert_test_reload+0x1b8>
 2dd1b87:	vpbroadcastb -0x23b6010(%rip),%xmm15        # a1bb80 <fast_operand_complex_class+0xdf8>
 2dd1b90:	vpbroadcastb -0x23b601a(%rip),%xmm16        # a1bb80 <fast_operand_complex_class+0xdf8>
 2dd1b9a:	vbroadcasti32x4 -0x23b77e4(%rip),%zmm17        # a1a3c0 <switch.table.ir_if_convert_test_reload+0x1d8>
 2dd1ba4:	vbroadcasti32x4 -0x23b77de(%rip),%zmm18        # a1a3d0 <switch.table.ir_if_convert_test_reload+0x1e8>
 2dd1bae:	vbroadcasti32x4 -0x23b77d8(%rip),%zmm19        # a1a3e0 <switch.table.ir_if_convert_test_reload+0x1f8>
 2dd1bb8:	jmp    2dd1895 <fast_pp_skip_inactive+0x14b5>
 2dd1bbd:	lea    0x1(%r8,%rsi,1),%rdi
 2dd1bc2:	cmp    0x10(%rsp),%rdi
 2dd1bc7:	jbe    2dd15b9 <fast_pp_skip_inactive+0x11d9>
 2dd1bcd:	mov    %rax,%r12
 2dd1bd0:	xor    %edx,%edx
 2dd1bd2:	jmp    2dd1be3 <fast_pp_skip_inactive+0x1803>
 2dd1bd4:	dec    %rdx
 2dd1bd7:	lea    0x1(%r13,%rdx,1),%rsi
 2dd1bdc:	cmp    0x10(%rsp),%rsi
 2dd1be1:	jbe    2dd1bff <fast_pp_skip_inactive+0x181f>
 2dd1be3:	cmpb   $0xa,0x0(%r13,%rdx,1)
 2dd1be9:	jne    2dd1bd4 <fast_pp_skip_inactive+0x17f4>
 2dd1beb:	lea    0x0(%r13,%rdx,1),%rsi
 2dd1bf0:	cmp    0x10(%rsp),%rsi
 2dd1bf5:	jbe    2dd1bff <fast_pp_skip_inactive+0x181f>
 2dd1bf7:	cmpb   $0x5c,-0x1(%r13,%rdx,1)
 2dd1bfd:	je     2dd1bd4 <fast_pp_skip_inactive+0x17f4>
 2dd1bff:	mov    0x30(%rsp),%r15
 2dd1c04:	test   %rdx,%rdx
 2dd1c07:	jns    2dd15b9 <fast_pp_skip_inactive+0x11d9>
 2dd1c0d:	mov    %rbp,%r10
 2dd1c10:	add    %rdx,%r10
 2dd1c13:	mov    %rdx,%rsi
 2dd1c16:	neg    %rsi
 2dd1c19:	add    %r8,%r10
 2dd1c1c:	mov    %rsi,%r11
 2dd1c1f:	lea    (%r12,%r10,1),%r8
 2dd1c23:	lea    0x31(%r12,%r10,1),%r14
 2dd1c28:	mov    %r10,0x70(%rsp)
 2dd1c2d:	lea    0x1(%r12,%r10,1),%r10
 2dd1c32:	mov    %r8,0x20(%rsp)
 2dd1c37:	xor    %r8d,%r8d
 2dd1c3a:	mov    0x20(%rsp),%rax
 2dd1c3f:	movzbl 0x1(%rax,%r8,1),%r15d
 2dd1c45:	cmp    $0x22,%r15d
 2dd1c49:	je     2dd1c6c <fast_pp_skip_inactive+0x188c>
 2dd1c4b:	cmp    $0x27,%r15d
 2dd1c4f:	je     2dd1c6c <fast_pp_skip_inactive+0x188c>
 2dd1c51:	mov    0x30(%rsp),%r15
 2dd1c56:	inc    %r8
 2dd1c59:	dec    %r11
 2dd1c5c:	inc    %r14
 2dd1c5f:	inc    %r10
 2dd1c62:	cmp    %r8,%rsi
 2dd1c65:	jne    2dd1c3a <fast_pp_skip_inactive+0x185a>
 2dd1c67:	jmp    2dd15b9 <fast_pp_skip_inactive+0x11d9>
 2dd1c6c:	mov    0x20(%rsp),%rax
 2dd1c71:	lea    0x1(%r8,%rax,1),%rsi
 2dd1c76:	cmp    $0x27,%r15b
 2dd1c7a:	jne    2dd1caf <fast_pp_skip_inactive+0x18cf>
 2dd1c7c:	mov    0x38(%rsp),%rcx
 2dd1c81:	cmpb   $0x0,0xe979(%rcx)
 2dd1c88:	je     2dd1caf <fast_pp_skip_inactive+0x18cf>
 2dd1c8a:	mov    0x50(%rsp),%rcx
 2dd1c8f:	cmp    (%rcx),%rsi
 2dd1c92:	jbe    2dd1caf <fast_pp_skip_inactive+0x18cf>
 2dd1c94:	mov    0x20(%rsp),%rax
 2dd1c99:	movzbl (%r8,%rax,1),%ecx
 2dd1c9e:	lea    -0x23b3ea5(%rip),%rax        # a1de00 <fast_char_class>
 2dd1ca5:	testb  $0x1,(%rcx,%rax,1)
 2dd1ca9:	jne    2dd1f99 <fast_pp_skip_inactive+0x1bb9>
 2dd1caf:	cmp    %rdi,%rsi
 2dd1cb2:	jae    2dd1e2c <fast_pp_skip_inactive+0x1a4c>
 2dd1cb8:	add    %r8,%rdx
 2dd1cbb:	neg    %rdx
 2dd1cbe:	cmp    $0x8,%rdx
 2dd1cc2:	jb     2dd1e13 <fast_pp_skip_inactive+0x1a33>
 2dd1cc8:	cmp    $0x40,%rdx
 2dd1ccc:	jae    2dd1cd5 <fast_pp_skip_inactive+0x18f5>
 2dd1cce:	xor    %ecx,%ecx
 2dd1cd0:	jmp    2dd1da7 <fast_pp_skip_inactive+0x19c7>
 2dd1cd5:	mov    %r11,%rdi
 2dd1cd8:	and    $0xffffffffffffffc0,%rdi
 2dd1cdc:	vmovd  0xc(%rsp),%xmm0
 2dd1ce2:	mov    %rdx,%rcx
 2dd1ce5:	and    $0xffffffffffffffc0,%rcx
 2dd1ce9:	vpxor  %xmm1,%xmm1,%xmm1
 2dd1ced:	vpxor  %xmm2,%xmm2,%xmm2
 2dd1cf1:	vpxor  %xmm3,%xmm3,%xmm3
 2dd1cf5:	lea    (%r12,%rdi,1),%rsi
 2dd1cf9:	add    0x70(%rsp),%rsi
 2dd1cfe:	lea    0x1(%r8,%rsi,1),%rsi
 2dd1d03:	vpcmpeqb -0x30(%r14),%xmm16,%k0
 2dd1d0a:	vpcmpeqb -0x20(%r14),%xmm16,%k1
 2dd1d11:	vpcmpeqb -0x10(%r14),%xmm16,%k2
 2dd1d18:	vpcmpeqb (%r14),%xmm16,%k3
 2dd1d1e:	add    $0x40,%r14
 2dd1d22:	add    $0xffffffffffffffc0,%rdi
 2dd1d26:	vpmovm2d %k0,%zmm4
 2dd1d2c:	vpaddd %zmm4,%zmm0,%zmm0
 2dd1d32:	vpmovm2d %k1,%zmm4
 2dd1d38:	vpaddd %zmm4,%zmm1,%zmm1
 2dd1d3e:	vpmovm2d %k2,%zmm4
 2dd1d44:	vpaddd %zmm4,%zmm2,%zmm2
 2dd1d4a:	vpmovm2d %k3,%zmm4
 2dd1d50:	vpaddd %zmm4,%zmm3,%zmm3
 2dd1d56:	jne    2dd1d03 <fast_pp_skip_inactive+0x1923>
 2dd1d58:	vpaddd %zmm0,%zmm1,%zmm0
 2dd1d5e:	vpaddd %zmm0,%zmm2,%zmm0
 2dd1d64:	vpaddd %zmm0,%zmm3,%zmm0
 2dd1d6a:	vextracti64x4 $0x1,%zmm0,%ymm1
 2dd1d71:	vpaddd %zmm1,%zmm0,%zmm0
 2dd1d77:	vextracti128 $0x1,%ymm0,%xmm1
 2dd1d7d:	vpaddd %xmm1,%xmm0,%xmm0
 2dd1d81:	vpshufd $0xee,%xmm0,%xmm1
 2dd1d86:	vpaddd %xmm1,%xmm0,%xmm0
 2dd1d8a:	vpshufd $0x55,%xmm0,%xmm1
 2dd1d8f:	vpaddd %xmm1,%xmm0,%xmm0
 2dd1d93:	vmovd  %xmm0,0xc(%rsp)
 2dd1d99:	cmp    %rcx,%rdx
 2dd1d9c:	je     2dd1e2c <fast_pp_skip_inactive+0x1a4c>
 2dd1da2:	test   $0x38,%dl
 2dd1da5:	je     2dd1e13 <fast_pp_skip_inactive+0x1a33>
 2dd1da7:	and    $0xfffffffffffffff8,%r11
 2dd1dab:	vmovd  0xc(%rsp),%xmm0
 2dd1db1:	mov    %rdx,%rdi
 2dd1db4:	and    $0xfffffffffffffff8,%rdi
 2dd1db8:	add    %rcx,%r10
 2dd1dbb:	add    %r11,%r12
 2dd1dbe:	add    0x70(%rsp),%r12
 2dd1dc3:	sub    %rcx,%r11
 2dd1dc6:	xor    %ecx,%ecx
 2dd1dc8:	lea    0x1(%r8,%r12,1),%rsi
 2dd1dcd:	vmovq  (%r10,%rcx,1),%xmm1
 2dd1dd3:	add    $0x8,%rcx
 2dd1dd7:	vpcmpeqb %xmm15,%xmm1,%k0
 2dd1ddd:	vpmovm2d %k0,%ymm1
 2dd1de3:	vpaddd %ymm1,%ymm0,%ymm0
 2dd1de7:	cmp    %rcx,%r11
 2dd1dea:	jne    2dd1dcd <fast_pp_skip_inactive+0x19ed>
 2dd1dec:	vextracti128 $0x1,%ymm0,%xmm1
 2dd1df2:	vpaddd %xmm1,%xmm0,%xmm0
 2dd1df6:	vpshufd $0xee,%xmm0,%xmm1
 2dd1dfb:	vpaddd %xmm1,%xmm0,%xmm0
 2dd1dff:	vpshufd $0x55,%xmm0,%xmm1
 2dd1e04:	vpaddd %xmm1,%xmm0,%xmm0
 2dd1e08:	vmovd  %xmm0,0xc(%rsp)
 2dd1e0e:	cmp    %rdi,%rdx
 2dd1e11:	je     2dd1e2c <fast_pp_skip_inactive+0x1a4c>
 2dd1e13:	dec    %rsi
 2dd1e16:	xor    %ecx,%ecx
 2dd1e18:	cmpb   $0xa,0x1(%rsi)
 2dd1e1c:	lea    0x1(%rsi),%rsi
 2dd1e20:	sete   %cl
 2dd1e23:	sub    %ecx,0xc(%rsp)
 2dd1e27:	cmp    %r13,%rsi
 2dd1e2a:	jne    2dd1e16 <fast_pp_skip_inactive+0x1a36>
 2dd1e2c:	mov    0x20(%rsp),%rax
 2dd1e31:	lea    0x2(%r8,%rax,1),%rcx
 2dd1e36:	mov    %rcx,0x10(%rsp)
 2dd1e3b:	cmp    0x18(%rsp),%rcx
 2dd1e40:	jb     2dd1e75 <fast_pp_skip_inactive+0x1a95>
 2dd1e42:	xor    %edx,%edx
 2dd1e44:	mov    0x10(%rsp),%r14
 2dd1e49:	xor    %ebx,%ebx
 2dd1e4b:	xor    %r8d,%r8d
 2dd1e4e:	movq   $0x0,0x20(%rsp)
 2dd1e57:	xor    %r9d,%r9d
 2dd1e5a:	jmp    2dd1895 <fast_pp_skip_inactive+0x14b5>
 2dd1e5f:	mov    0x10(%rsp),%rsi
 2dd1e64:	xor    %edx,%edx
 2dd1e66:	add    %rcx,%rsi
 2dd1e69:	mov    %rsi,0x10(%rsp)
 2dd1e6e:	cmp    0x18(%rsp),%rsi
 2dd1e73:	jae    2dd1e44 <fast_pp_skip_inactive+0x1a64>
 2dd1e75:	mov    0x10(%rsp),%rax
 2dd1e7a:	movzbl (%rax),%edx
 2dd1e7d:	cmp    %r15b,%dl
 2dd1e80:	je     2dd1eb4 <fast_pp_skip_inactive+0x1ad4>
 2dd1e82:	cmp    $0xa,%dl
 2dd1e85:	je     2dd1eb4 <fast_pp_skip_inactive+0x1ad4>
 2dd1e87:	mov    $0x1,%ecx
 2dd1e8c:	cmp    $0x5c,%dl
 2dd1e8f:	jne    2dd1e5f <fast_pp_skip_inactive+0x1a7f>
 2dd1e91:	mov    0x10(%rsp),%rax
 2dd1e96:	lea    0x1(%rax),%rdx
 2dd1e9a:	cmp    0x18(%rsp),%rdx
 2dd1e9f:	jae    2dd1e5f <fast_pp_skip_inactive+0x1a7f>
 2dd1ea1:	xor    %ecx,%ecx
 2dd1ea3:	cmpb   $0xa,(%rdx)
 2dd1ea6:	sete   %cl
 2dd1ea9:	add    %ecx,0xc(%rsp)
 2dd1ead:	mov    $0x2,%ecx
 2dd1eb2:	jmp    2dd1e5f <fast_pp_skip_inactive+0x1a7f>
 2dd1eb4:	mov    0x10(%rsp),%r14
 2dd1eb9:	xor    %ecx,%ecx
 2dd1ebb:	cmp    %r15b,%dl
 2dd1ebe:	movq   $0x0,0x20(%rsp)
 2dd1ec7:	sete   %cl
 2dd1eca:	xor    %edx,%edx
 2dd1ecc:	xor    %ebx,%ebx
 2dd1ece:	xor    %r8d,%r8d
 2dd1ed1:	xor    %r9d,%r9d
 2dd1ed4:	add    %rcx,%r14
 2dd1ed7:	mov    %r14,0x10(%rsp)
 2dd1edc:	jmp    2dd1895 <fast_pp_skip_inactive+0x14b5>
 2dd1ee1:	mov    0x38(%rsp),%rcx
 2dd1ee6:	xor    %eax,%eax
 2dd1ee8:	mov    $0x1,%r15b
 2dd1eeb:	cmpb   $0x0,0xe968(%rcx)
 2dd1ef2:	je     2dd1efe <fast_pp_skip_inactive+0x1b1e>
 2dd1ef4:	mov    0x50(%rsp),%rcx
 2dd1ef9:	jmp    2dd202e <fast_pp_skip_inactive+0x1c4e>
 2dd1efe:	mov    %r10d,0xc(%rsp)
 2dd1f03:	xor    %ebp,%ebp
 2dd1f05:	lea    -0x23aadab(%rip),%rsi        # a27161 <fast_cc_binary_questioned.range_narrow+0x2a21>
 2dd1f0c:	jmp    2dd1feb <fast_pp_skip_inactive+0x1c0b>
 2dd1f11:	lea    -0x23aae00(%rip),%rax        # a27118 <fast_cc_binary_questioned.range_narrow+0x29d8>
 2dd1f18:	mov    %rax,0xa8(%rsp)
 2dd1f20:	mov    0x38(%rsp),%rdi
 2dd1f25:	mov    0xa8(%rsp),%rsi
 2dd1f2d:	vzeroupper
 2dd1f30:	call   45daa79 <fast_pp_bail>
 2dd1f35:	mov    0x18(%rsp),%r14
 2dd1f3a:	xor    %ebx,%ebx
 2dd1f3c:	mov    %r13d,%r10d
 2dd1f3f:	mov    0x38(%rsp),%rdi
 2dd1f44:	cmpb   $0x0,0xe968(%rdi)
 2dd1f4b:	je     2dd1f64 <fast_pp_skip_inactive+0x1b84>
 2dd1f4d:	xor    %eax,%eax
 2dd1f4f:	cmpl   $0x0,0x5c(%rsp)
 2dd1f54:	mov    0x50(%rsp),%rcx
 2dd1f59:	mov    $0x1,%r15b
 2dd1f5c:	je     2dd202e <fast_pp_skip_inactive+0x1c4e>
 2dd1f62:	jmp    2dd1fdd <fast_pp_skip_inactive+0x1bfd>
 2dd1f64:	lea    -0x23aae0a(%rip),%rsi        # a27161 <fast_cc_binary_questioned.range_narrow+0x2a21>
 2dd1f6b:	mov    %r10d,0xc(%rsp)
 2dd1f70:	vzeroupper
 2dd1f73:	call   45daa79 <fast_pp_bail>
 2dd1f78:	xor    %eax,%eax
 2dd1f7a:	cmpl   $0x0,0x5c(%rsp)
 2dd1f7f:	mov    $0x1,%r15b
 2dd1f82:	je     2dd2024 <fast_pp_skip_inactive+0x1c44>
 2dd1f88:	jmp    2dd1fe2 <fast_pp_skip_inactive+0x1c02>
 2dd1f8a:	lea    -0x23aae79(%rip),%rax        # a27118 <fast_cc_binary_questioned.range_narrow+0x29d8>
 2dd1f91:	mov    %rax,0xa0(%rsp)
 2dd1f99:	mov    0x38(%rsp),%rdi
 2dd1f9e:	mov    0xa0(%rsp),%rsi
 2dd1fa6:	vzeroupper
 2dd1fa9:	call   45daa79 <fast_pp_bail>
 2dd1fae:	mov    0x18(%rsp),%r14
 2dd1fb3:	xor    %r9d,%r9d
 2dd1fb6:	mov    0xc(%rsp),%r10d
 2dd1fbb:	mov    0x38(%rsp),%rdi
 2dd1fc0:	cmpb   $0x0,0xe968(%rdi)
 2dd1fc7:	je     2dd2001 <fast_pp_skip_inactive+0x1c21>
 2dd1fc9:	xor    %eax,%eax
 2dd1fcb:	cmpl   $0x0,0x60(%rsp)
 2dd1fd0:	mov    0x50(%rsp),%rcx
 2dd1fd5:	mov    $0x1,%r15b
 2dd1fd8:	mov    %r9,%rbx
 2dd1fdb:	je     2dd202e <fast_pp_skip_inactive+0x1c4e>
 2dd1fdd:	mov    %r10d,0xc(%rsp)
 2dd1fe2:	lea    -0x23aae77(%rip),%rsi        # a27172 <fast_cc_binary_questioned.range_narrow+0x2a32>
 2dd1fe9:	xor    %ebp,%ebp
 2dd1feb:	mov    0x38(%rsp),%rdi
 2dd1ff0:	vzeroupper
 2dd1ff3:	call   45daa79 <fast_pp_bail>
 2dd1ff8:	mov    0x50(%rsp),%rcx
 2dd1ffd:	mov    %ebp,%eax
 2dd1fff:	jmp    2dd2029 <fast_pp_skip_inactive+0x1c49>
 2dd2001:	lea    -0x23aaea7(%rip),%rsi        # a27161 <fast_cc_binary_questioned.range_narrow+0x2a21>
 2dd2008:	mov    %r9,%rbx
 2dd200b:	mov    %r10d,0xc(%rsp)
 2dd2010:	vzeroupper
 2dd2013:	call   45daa79 <fast_pp_bail>
 2dd2018:	xor    %eax,%eax
 2dd201a:	cmpl   $0x0,0x60(%rsp)
 2dd201f:	mov    $0x1,%r15b
 2dd2022:	jne    2dd1fe2 <fast_pp_skip_inactive+0x1c02>
 2dd2024:	mov    0x50(%rsp),%rcx
 2dd2029:	mov    0xc(%rsp),%r10d
 2dd202e:	and    %r15b,%bl
 2dd2031:	mov    %r14,0x8(%rcx)
 2dd2035:	mov    %r10d,0x2c(%rcx)
 2dd2039:	mov    %bl,0x45(%rcx)
 2dd203c:	add    $0x118,%rsp
 2dd2043:	pop    %rbx
 2dd2044:	pop    %r12
 2dd2046:	pop    %r13
 2dd2048:	pop    %r14
 2dd204a:	pop    %r15
 2dd204c:	pop    %rbp
 2dd204d:	vzeroupper
 2dd2050:	ret
 2dd2051:	mov    $0x6,%bpl
 2dd2054:	xor    %ebx,%ebx
 2dd2056:	xor    %r15d,%r15d
 2dd2059:	cmpl   $0x0,0x5c(%rsp)
 2dd205e:	jne    2dd2084 <fast_pp_skip_inactive+0x1ca4>
 2dd2060:	mov    0x10(%rsp),%r14
 2dd2065:	mov    0x50(%rsp),%rcx
 2dd206a:	mov    0xc(%rsp),%r10d
 2dd206f:	mov    %ebp,%eax
 2dd2071:	xor    %ebx,%ebx
 2dd2073:	jmp    2dd202e <fast_pp_skip_inactive+0x1c4e>
 2dd2075:	mov    $0x6,%bpl
 2dd2078:	xor    %ebx,%ebx
 2dd207a:	xor    %r15d,%r15d
 2dd207d:	cmpl   $0x0,0x60(%rsp)
 2dd2082:	je     2dd2060 <fast_pp_skip_inactive+0x1c80>
 2dd2084:	mov    0x10(%rsp),%r14
 2dd2089:	lea    -0x23aaf1e(%rip),%rsi        # a27172 <fast_cc_binary_questioned.range_narrow+0x2a32>
 2dd2090:	jmp    2dd1feb <fast_pp_skip_inactive+0x1c0b>
 2dd2095:	lea    -0x23aafda(%rip),%rax        # a270c2 <fast_cc_binary_questioned.range_narrow+0x2982>
 2dd209c:	jmp    2dd1f18 <fast_pp_skip_inactive+0x1b38>
