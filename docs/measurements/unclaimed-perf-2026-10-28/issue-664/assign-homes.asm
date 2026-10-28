
build/compiler:     file format elf64-x86-64


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

0000000000c9a1a0 <tier0_assign_homes>:
  c9a1a0:	push   %rbp
  c9a1a1:	push   %r15
  c9a1a3:	push   %r14
  c9a1a5:	push   %r13
  c9a1a7:	push   %r12
  c9a1a9:	push   %rbx
  c9a1aa:	sub    $0x118,%rsp
  c9a1b1:	mov    %r9d,0x20(%rsp)
  c9a1b6:	mov    %r8,(%rsp)
  c9a1ba:	mov    %rsi,0x18(%rsp)
  c9a1bf:	mov    %rcx,%r14
  c9a1c2:	mov    %rdx,%r15
  c9a1c5:	mov    %rdi,%r12
  c9a1c8:	mov    %fs:0x28,%rax
  c9a1d1:	mov    %rax,0x110(%rsp)
  c9a1d9:	mov    0x30(%rdi),%r11d
  c9a1dd:	mov    0x34(%rdi),%eax
  c9a1e0:	mov    %r11,%r13
  c9a1e3:	test   %rax,%rax
  c9a1e6:	je     c9a1fb <tier0_assign_homes+0x5b>
  c9a1e8:	mov    0x38(%r12),%rcx
  c9a1ed:	cmp    $0x9,%eax
  c9a1f0:	jae    c9a202 <tier0_assign_homes+0x62>
  c9a1f2:	xor    %edx,%edx
  c9a1f4:	xor    %ebx,%ebx
  c9a1f6:	jmp    c9a528 <tier0_assign_homes+0x388>
  c9a1fb:	xor    %ebx,%ebx
  c9a1fd:	jmp    c9ab02 <tier0_assign_homes+0x962>
  c9a202:	cmp    $0x41,%eax
  c9a205:	jae    c9a210 <tier0_assign_homes+0x70>
  c9a207:	xor    %edx,%edx
  c9a209:	xor    %ebx,%ebx
  c9a20b:	jmp    c9a450 <tier0_assign_homes+0x2b0>
  c9a210:	vmovdqa -0x6ea018(%rip),%xmm1        # 5b0200 <tier0_program_class_type.types+0x28d0>
  c9a218:	vmovdqa -0x6ea010(%rip),%xmm2        # 5b0210 <tier0_program_class_type.types+0x28e0>
  c9a220:	vpbroadcastb -0x7bf1a9(%rip),%xmm3        # 4db080 <check_builtin_atomic_rmw_test_clang.native_source+0xa570>
  c9a229:	vpbroadcastb -0x7bf1b1(%rip),%xmm5        # 4db081 <check_builtin_atomic_rmw_test_clang.native_source+0xa571>
  c9a232:	vpbroadcastb -0x7bf1b9(%rip),%xmm6        # 4db082 <check_builtin_atomic_rmw_test_clang.native_source+0xa572>
  c9a23b:	vpbroadcastb -0x7bf1c1(%rip),%xmm7        # 4db083 <check_builtin_atomic_rmw_test_clang.native_source+0xa573>
  c9a244:	vpbroadcastd -0x6d3dea(%rip),%zmm8        # 5c6464 <unwind_tier0_test_terminal.ids+0x4c4>
  c9a24e:	mov    %eax,%edx
  c9a250:	and    $0x3f,%edx
  c9a253:	mov    $0x40,%esi
  c9a258:	vpcmpeqd %xmm4,%xmm4,%xmm4
  c9a25c:	vpxor  %xmm0,%xmm0,%xmm0
  c9a260:	vpxor  %xmm9,%xmm9,%xmm9
  c9a265:	vpxor  %xmm11,%xmm11,%xmm11
  c9a26a:	vpxor  %xmm10,%xmm10,%xmm10
  c9a26f:	cmovne %rdx,%rsi
  c9a273:	mov    %rax,%rdx
  c9a276:	xor    %edi,%edi
  c9a278:	sub    %rsi,%rdx
  c9a27b:	nopl   0x0(%rax,%rax,1)
  c9a280:	vmovdqu64 0x4(%rcx,%rdi,8),%zmm12
  c9a28b:	vmovdqu64 0x104(%rcx,%rdi,8),%zmm17
  c9a296:	vmovdqu64 0x44(%rcx,%rdi,8),%zmm13
  c9a2a1:	vmovdqu64 0x84(%rcx,%rdi,8),%zmm14
  c9a2ac:	vmovdqu64 0xc4(%rcx,%rdi,8),%zmm15
  c9a2b7:	vmovdqu64 0x144(%rcx,%rdi,8),%zmm19
  c9a2c2:	vmovdqa64 %zmm12,%zmm16
  c9a2c8:	vmovdqa64 %zmm17,%zmm18
  c9a2ce:	vpermt2b %zmm13,%zmm2,%zmm12
  c9a2d4:	vpermt2b %zmm13,%zmm1,%zmm16
  c9a2da:	vmovdqa64 %zmm14,%zmm13
  c9a2e0:	vpermt2b %zmm15,%zmm2,%zmm14
  c9a2e6:	vpermt2b %zmm19,%zmm2,%zmm17
  c9a2ec:	vpermt2b %zmm15,%zmm1,%zmm13
  c9a2f2:	vpermt2b %zmm19,%zmm1,%zmm18
  c9a2f8:	vmovdqu64 0x184(%rcx,%rdi,8),%zmm19
  c9a303:	vmovdqu64 0x1c4(%rcx,%rdi,8),%zmm15
  c9a30e:	add    $0x40,%rdi
  c9a312:	vpcmpeqb %xmm3,%xmm12,%k1
  c9a318:	vpcmpeqb %xmm3,%xmm14,%k2
  c9a31e:	vpandq %xmm6,%xmm16,%xmm12
  c9a324:	vpand  %xmm6,%xmm13,%xmm14
  c9a328:	vpcmpeqb %xmm3,%xmm17,%k5
  c9a32e:	vptestnmb %xmm5,%xmm16,%k7
  c9a334:	vpcmpneqb %xmm4,%xmm16,%k4{%k1}
  c9a33b:	vpaddb %xmm7,%xmm12,%xmm12
  c9a33f:	vpcmpneqb %xmm4,%xmm13,%k3{%k2}
  c9a346:	vpcmpneqb %xmm4,%xmm18,%k2{%k5}
  c9a34d:	vpaddb %xmm7,%xmm14,%xmm14
  c9a351:	vmovdqu8 %xmm16,%xmm12{%k7}
  c9a357:	vpmovzxbd %xmm12,%zmm12
  c9a35d:	vmovdqa64 %zmm19,%zmm20
  c9a363:	vpermt2b %zmm15,%zmm2,%zmm19
  c9a369:	vpermt2b %zmm15,%zmm1,%zmm20
  c9a36f:	vpandq %xmm6,%xmm18,%xmm15
  c9a375:	vpaddb %xmm7,%xmm15,%xmm15
  c9a379:	vpsllvd %zmm12,%zmm8,%zmm12
  c9a37f:	vpord  %zmm12,%zmm9,%zmm9{%k4}
  c9a385:	vpcmpeqb %xmm3,%xmm19,%k6
  c9a38b:	vpandq %xmm6,%xmm20,%xmm17
  c9a391:	vptestnmb %xmm5,%xmm20,%k5
  c9a397:	vpcmpneqb %xmm4,%xmm20,%k1{%k6}
  c9a39e:	vpaddb %xmm7,%xmm17,%xmm17
  c9a3a4:	vptestnmb %xmm5,%xmm18,%k6
  c9a3aa:	kmovw  %k1,0x8(%rsp)
  c9a3b0:	vptestnmb %xmm5,%xmm13,%k1
  c9a3b6:	vmovdqu8 %xmm18,%xmm15{%k6}
  c9a3bc:	vmovdqu8 %xmm20,%xmm17{%k5}
  c9a3c2:	vmovdqu8 %xmm13,%xmm14{%k1}
  c9a3c8:	vpmovzxbd %xmm14,%zmm13
  c9a3ce:	vpmovzxbd %xmm15,%zmm14
  c9a3d4:	vpmovzxbd %xmm17,%zmm15
  c9a3da:	kmovw  0x8(%rsp),%k1
  c9a3e0:	vpsllvd %zmm13,%zmm8,%zmm13
  c9a3e6:	vpsllvd %zmm14,%zmm8,%zmm14
  c9a3ec:	vpsllvd %zmm15,%zmm8,%zmm15
  c9a3f2:	vpord  %zmm13,%zmm11,%zmm11{%k3}
  c9a3f8:	vpord  %zmm14,%zmm10,%zmm10{%k2}
  c9a3fe:	vpord  %zmm15,%zmm0,%zmm0{%k1}
  c9a404:	cmp    %rdi,%rdx
  c9a407:	jne    c9a280 <tier0_assign_homes+0xe0>
  c9a40d:	vpord  %zmm9,%zmm11,%zmm1
  c9a413:	vpternlogd $0xfe,%zmm1,%zmm10,%zmm0
  c9a41a:	vextracti64x4 $0x1,%zmm0,%ymm1
  c9a421:	vpord  %zmm1,%zmm0,%zmm0
  c9a427:	vextracti128 $0x1,%ymm0,%xmm1
  c9a42d:	vpor   %xmm1,%xmm0,%xmm0
  c9a431:	vpshufd $0xee,%xmm0,%xmm1
  c9a436:	vpor   %xmm1,%xmm0,%xmm0
  c9a43a:	vpshufd $0x55,%xmm0,%xmm1
  c9a43f:	vpor   %xmm1,%xmm0,%xmm0
  c9a443:	vmovd  %xmm0,%ebx
  c9a447:	cmp    $0x9,%esi
  c9a44a:	jb     c9a528 <tier0_assign_homes+0x388>
  c9a450:	vpbroadcastb -0x7bf3d9(%rip),%xmm1        # 4db080 <check_builtin_atomic_rmw_test_clang.native_source+0xa570>
  c9a459:	vpbroadcastb -0x7bf3e1(%rip),%xmm3        # 4db081 <check_builtin_atomic_rmw_test_clang.native_source+0xa571>
  c9a462:	vpbroadcastb -0x7bf3e9(%rip),%xmm4        # 4db082 <check_builtin_atomic_rmw_test_clang.native_source+0xa572>
  c9a46b:	vpbroadcastb -0x7bf3f1(%rip),%xmm5        # 4db083 <check_builtin_atomic_rmw_test_clang.native_source+0xa573>
  c9a474:	vpbroadcastd -0x6d4019(%rip),%ymm6        # 5c6464 <unwind_tier0_test_terminal.ids+0x4c4>
  c9a47d:	mov    %rdx,%rsi
  c9a480:	mov    %eax,%edx
  c9a482:	and    $0x7,%edx
  c9a485:	mov    $0x8,%edi
  c9a48a:	vmovd  %ebx,%xmm0
  c9a48e:	vpcmpeqd %xmm2,%xmm2,%xmm2
  c9a492:	cmovne %rdx,%rdi
  c9a496:	mov    %rax,%rdx
  c9a499:	sub    %rdi,%rdx
  c9a49c:	nopl   0x0(%rax)
  c9a4a0:	vmovdqu64 0x4(%rcx,%rsi,8),%zmm7
  c9a4ab:	add    $0x8,%rsi
  c9a4af:	vpmovqb %zmm7,%xmm8
  c9a4b5:	vpsrlq $0x10,%zmm7,%zmm7
  c9a4bc:	vpmovqb %zmm7,%xmm7
  c9a4c2:	vptestnmb %xmm3,%xmm8,%k2
  c9a4c8:	vpcmpneqb %xmm2,%xmm8,%k1
  c9a4cf:	vpcmpeqb %xmm1,%xmm7,%k0
  c9a4d5:	vpand  %xmm4,%xmm8,%xmm7
  c9a4d9:	vpaddb %xmm5,%xmm7,%xmm7
  c9a4dd:	kandb  %k1,%k0,%k1
  c9a4e1:	vmovdqu8 %xmm8,%xmm7{%k2}
  c9a4e7:	vpmovzxbd %xmm7,%ymm7
  c9a4ec:	vpsllvd %ymm7,%ymm6,%ymm7
  c9a4f1:	vpord  %ymm7,%ymm0,%ymm0{%k1}
  c9a4f7:	cmp    %rsi,%rdx
  c9a4fa:	jne    c9a4a0 <tier0_assign_homes+0x300>
  c9a4fc:	vextracti128 $0x1,%ymm0,%xmm1
  c9a502:	vpor   %xmm1,%xmm0,%xmm0
  c9a506:	vpshufd $0xee,%xmm0,%xmm1
  c9a50b:	vpor   %xmm1,%xmm0,%xmm0
  c9a50f:	vpshufd $0x55,%xmm0,%xmm1
  c9a514:	vpor   %xmm1,%xmm0,%xmm0
  c9a518:	vmovd  %xmm0,%ebx
  c9a51c:	jmp    c9a528 <tier0_assign_homes+0x388>
  c9a51e:	xchg   %ax,%ax
  c9a520:	inc    %rdx
  c9a523:	cmp    %rdx,%rax
  c9a526:	je     c9a558 <tier0_assign_homes+0x3b8>
  c9a528:	cmpb   $0x1,0x6(%rcx,%rdx,8)
  c9a52d:	jne    c9a520 <tier0_assign_homes+0x380>
  c9a52f:	movzbl 0x4(%rcx,%rdx,8),%esi
  c9a534:	cmp    $0xff,%sil
  c9a538:	je     c9a520 <tier0_assign_homes+0x380>
  c9a53a:	mov    %esi,%edi
  c9a53c:	and    $0x1f,%dil
  c9a540:	add    $0x10,%dil
  c9a544:	test   $0x20,%sil
  c9a548:	movzbl %sil,%esi
  c9a54c:	movzbl %dil,%edi
  c9a550:	cmove  %esi,%edi
  c9a553:	bts    %edi,%ebx
  c9a556:	jmp    c9a520 <tier0_assign_homes+0x380>
  c9a558:	mov    0x18(%rsp),%rcx
  c9a55d:	cmpb   $0x1,0x5b(%rcx)
  c9a561:	jne    c9ab02 <tier0_assign_homes+0x962>
  c9a567:	mov    0x38(%r12),%rcx
  c9a56c:	mov    0x88(%r12),%rdx
  c9a574:	cmp    $0x8,%eax
  c9a577:	jae    c9a580 <tier0_assign_homes+0x3e0>
  c9a579:	xor    %esi,%esi
  c9a57b:	jmp    c9b51a <tier0_assign_homes+0x137a>
  c9a580:	cmp    $0x20,%eax
  c9a583:	jae    c9a58c <tier0_assign_homes+0x3ec>
  c9a585:	xor    %esi,%esi
  c9a587:	jmp    c9a9b2 <tier0_assign_homes+0x812>
  c9a58c:	mov    %eax,%esi
  c9a58e:	and    $0xffffffe0,%esi
  c9a591:	mov    %rdx,%rdi
  c9a594:	neg    %rdi
  c9a597:	vpbroadcastq -0x6d4cc1(%rip),%zmm0        # 5c58e0 <check_mutation_families+0xad4>
  c9a5a1:	vpbroadcastq -0x6d4cc3(%rip),%zmm1        # 5c58e8 <check_mutation_families+0xadc>
  c9a5ab:	vpbroadcastb -0x7bf533(%rip),%xmm3        # 4db081 <check_builtin_atomic_rmw_test_clang.native_source+0xa571>
  c9a5b4:	vpbroadcastb -0x7bf53b(%rip),%xmm4        # 4db082 <check_builtin_atomic_rmw_test_clang.native_source+0xa572>
  c9a5bd:	vpbroadcastb -0x7bf543(%rip),%xmm5        # 4db083 <check_builtin_atomic_rmw_test_clang.native_source+0xa573>
  c9a5c6:	vpbroadcastd -0x6d416b(%rip),%ymm6        # 5c6464 <unwind_tier0_test_terminal.ids+0x4c4>
  c9a5cf:	vmovd  %ebx,%xmm7
  c9a5d3:	lea    0x60(%rdx),%r8
  c9a5d7:	vpcmpeqd %xmm2,%xmm2,%xmm2
  c9a5db:	vpxor  %xmm8,%xmm8,%xmm8
  c9a5e0:	vpxor  %xmm10,%xmm10,%xmm10
  c9a5e5:	vpxor  %xmm9,%xmm9,%xmm9
  c9a5ea:	sbb    %edi,%edi
  c9a5ec:	xor    %r9d,%r9d
  c9a5ef:	kmovd  %edi,%k1
  c9a5f3:	mov    %eax,%edi
  c9a5f5:	shr    $0x5,%edi
  c9a5f8:	kmovw  %k1,0x28(%rsp)
  c9a5fe:	shl    $0x6,%rdi
  c9a602:	kmovw  0x28(%rsp),%k1
  c9a608:	jmp    c9a816 <tier0_assign_homes+0x676>
  c9a60d:	nopl   (%rax)
  c9a610:	vmovdqu32 -0x60(%r8,%r9,2),%ymm27{%k1}{z}
  c9a618:	vmovdqu32 -0x40(%r8,%r9,2),%ymm28{%k1}{z}
  c9a620:	vmovdqu32 -0x20(%r8,%r9,2),%ymm29{%k1}{z}
  c9a628:	vpsrlq $0x28,%zmm21,%zmm25
  c9a62f:	vpsrlq $0x28,%zmm19,%zmm23
  c9a636:	vpandq %zmm0,%zmm19,%zmm19
  c9a63c:	vpsrlq $0x28,%zmm20,%zmm24
  c9a643:	vmovdqu32 (%r8,%r9,2),%ymm30{%k1}{z}
  c9a64a:	vpandq %zmm0,%zmm20,%zmm20
  c9a650:	vpandq %zmm0,%zmm21,%zmm21
  c9a656:	vpsrlq $0x28,%zmm22,%zmm26
  c9a65d:	vpandq %zmm0,%zmm22,%zmm22
  c9a663:	add    $0x40,%r9
  c9a667:	vpmovqb %zmm25,%xmm25
  c9a66d:	vpcmpeqq %zmm1,%zmm19,%k2
  c9a673:	vpmovqb %zmm23,%xmm23
  c9a679:	vpcmpeqq %zmm1,%zmm20,%k3
  c9a67f:	vpcmpeqq %zmm1,%zmm21,%k4
  c9a685:	vpmovqb %zmm24,%xmm24
  c9a68b:	vpmovqb %zmm26,%xmm26
  c9a691:	vpcmpeqq %zmm1,%zmm22,%k6
  c9a697:	vpcmpneqb %xmm2,%xmm25,%k7
  c9a69e:	vpandq %xmm4,%xmm23,%xmm19
  c9a6a4:	vpandq %xmm4,%xmm24,%xmm20
  c9a6aa:	vpandq %xmm4,%xmm25,%xmm21
  c9a6b0:	vpandq %xmm4,%xmm26,%xmm22
  c9a6b6:	kmovw  %k7,0x10(%rsp)
  c9a6bc:	vpaddb %xmm5,%xmm19,%xmm19
  c9a6c2:	vpaddb %xmm5,%xmm20,%xmm20
  c9a6c8:	vpaddb %xmm5,%xmm21,%xmm21
  c9a6ce:	vpaddb %xmm5,%xmm22,%xmm22
  c9a6d4:	vptestmd %ymm27,%ymm27,%k0{%k2}
  c9a6da:	vptestmd %ymm28,%ymm28,%k2{%k3}
  c9a6e0:	vptestmd %ymm29,%ymm29,%k5{%k4}
  c9a6e6:	vpcmpneqb %xmm2,%xmm23,%k4
  c9a6ed:	vptestmd %ymm30,%ymm30,%k3{%k6}
  c9a6f3:	vpcmpneqb %xmm2,%xmm24,%k6
  c9a6fa:	kandb  %k1,%k0,%k7
  c9a6fe:	kmovw  %k0,0x30(%rsp)
  c9a704:	kmovq  %k2,%k0
  c9a709:	kmovw  %k5,0x8(%rsp)
  c9a70f:	kmovw  %k3,0x38(%rsp)
  c9a715:	kandb  %k4,%k7,%k4
  c9a719:	kandb  %k1,%k2,%k7
  c9a71d:	kmovw  0x10(%rsp),%k2
  c9a723:	kandb  %k6,%k7,%k6
  c9a727:	kandb  %k1,%k5,%k7
  c9a72b:	kandb  %k2,%k7,%k2
  c9a72f:	kandb  %k1,%k3,%k7
  c9a733:	kandnb %k1,%k0,%k3
  c9a737:	kmovw  0x38(%rsp),%k0
  c9a73d:	kmovw  %k2,0x10(%rsp)
  c9a743:	vpcmpneqb %xmm2,%xmm26,%k2
  c9a74a:	kandb  %k2,%k7,%k5
  c9a74e:	kmovw  0x30(%rsp),%k2
  c9a754:	vptestnmb %xmm3,%xmm23,%k7
  c9a75a:	vmovdqu8 %xmm23,%xmm19{%k7}
  c9a760:	vpmovzxbd %xmm19,%ymm19
  c9a766:	vptestnmb %xmm3,%xmm24,%k7
  c9a76c:	vmovdqu8 %xmm24,%xmm20{%k7}
  c9a772:	vptestnmb %xmm3,%xmm25,%k7
  c9a778:	vpsllvd %ymm19,%ymm6,%ymm19
  c9a77e:	vmovdqu8 %xmm25,%xmm21{%k7}
  c9a784:	vptestnmb %xmm3,%xmm26,%k7
  c9a78a:	vpord  %ymm13,%ymm19,%ymm11{%k4}
  c9a790:	vmovdqu8 %xmm26,%xmm22{%k7}
  c9a796:	kandnb %k1,%k2,%k4
  c9a79a:	kmovw  0x10(%rsp),%k2
  c9a7a0:	vmovdqa32 %ymm7,%ymm11{%k4}
  c9a7a6:	vpmovzxbd %xmm20,%ymm7
  c9a7ac:	vpsllvd %ymm7,%ymm6,%ymm7
  c9a7b1:	vpord  %ymm15,%ymm7,%ymm12{%k6}
  c9a7b7:	vpmovzxbd %xmm21,%ymm7
  c9a7bd:	vmovdqa32 %ymm8,%ymm12{%k3}
  c9a7c3:	vmovdqa %ymm12,%ymm8
  c9a7c8:	vpsllvd %ymm7,%ymm6,%ymm7
  c9a7cd:	vpord  %ymm17,%ymm7,%ymm14{%k2}
  c9a7d3:	kmovw  0x8(%rsp),%k2
  c9a7d9:	vpmovzxbd %xmm22,%ymm7
  c9a7df:	vpsllvd %ymm7,%ymm6,%ymm7
  c9a7e4:	vpord  %ymm18,%ymm7,%ymm16{%k5}
  c9a7ea:	vmovdqa %ymm11,%ymm7
  c9a7ee:	kandnb %k1,%k2,%k2
  c9a7f2:	vmovdqa32 %ymm10,%ymm14{%k2}
  c9a7f8:	kandnb %k1,%k0,%k2
  c9a7fc:	vmovdqa %ymm14,%ymm10
  c9a801:	vmovdqa32 %ymm9,%ymm16{%k2}
  c9a807:	vmovdqa64 %ymm16,%ymm9
  c9a80d:	cmp    %r9,%rdi
  c9a810:	je     c9a973 <tier0_assign_homes+0x7d3>
  c9a816:	vmovdqu64 (%rcx,%r9,4),%zmm19
  c9a81d:	vmovdqa %ymm7,%ymm13
  c9a821:	vpsrlq $0x20,%zmm19,%zmm11
  c9a828:	vpmovqb %zmm11,%xmm11
  c9a82e:	vpand  %xmm4,%xmm11,%xmm12
  c9a832:	vptestnmb %xmm3,%xmm11,%k3
  c9a838:	vpcmpneqb %xmm2,%xmm11,%k2
  c9a83f:	vpaddb %xmm5,%xmm12,%xmm12
  c9a843:	vmovdqu8 %xmm11,%xmm12{%k3}
  c9a849:	vpmovzxbd %xmm12,%ymm11
  c9a84e:	vpsllvd %ymm11,%ymm6,%ymm11
  c9a853:	vpord  %ymm11,%ymm7,%ymm13{%k2}
  c9a859:	vmovdqa %ymm13,%ymm11
  c9a85e:	test   %rdx,%rdx
  c9a861:	jne    c9a867 <tier0_assign_homes+0x6c7>
  c9a863:	vmovdqa %ymm7,%ymm11
  c9a867:	vmovdqu64 0x40(%rcx,%r9,4),%zmm20
  c9a86f:	vmovdqa %ymm8,%ymm15
  c9a874:	vpsrlq $0x20,%zmm20,%zmm12
  c9a87b:	vpmovqb %zmm12,%xmm12
  c9a881:	vpand  %xmm4,%xmm12,%xmm14
  c9a885:	vptestnmb %xmm3,%xmm12,%k3
  c9a88b:	vpcmpneqb %xmm2,%xmm12,%k2
  c9a892:	vpaddb %xmm5,%xmm14,%xmm14
  c9a896:	vmovdqu8 %xmm12,%xmm14{%k3}
  c9a89c:	vpmovzxbd %xmm14,%ymm12
  c9a8a1:	vpsllvd %ymm12,%ymm6,%ymm12
  c9a8a6:	vpord  %ymm12,%ymm8,%ymm15{%k2}
  c9a8ac:	vmovdqa %ymm15,%ymm12
  c9a8b1:	jne    c9a8b8 <tier0_assign_homes+0x718>
  c9a8b3:	vmovdqa %ymm8,%ymm12
  c9a8b8:	vmovdqu64 0x80(%rcx,%r9,4),%zmm21
  c9a8c0:	vmovdqa64 %ymm10,%ymm17
  c9a8c6:	vpsrlq $0x20,%zmm21,%zmm14
  c9a8cd:	vpmovqb %zmm14,%xmm14
  c9a8d3:	vpandq %xmm4,%xmm14,%xmm16
  c9a8d9:	vptestnmb %xmm3,%xmm14,%k3
  c9a8df:	vpcmpneqb %xmm2,%xmm14,%k2
  c9a8e6:	vpaddb %xmm5,%xmm16,%xmm16
  c9a8ec:	vmovdqu8 %xmm14,%xmm16{%k3}
  c9a8f2:	vpmovzxbd %xmm16,%ymm14
  c9a8f8:	vpsllvd %ymm14,%ymm6,%ymm14
  c9a8fd:	vpord  %ymm14,%ymm10,%ymm17{%k2}
  c9a903:	vmovdqa64 %ymm17,%ymm14
  c9a909:	jne    c9a910 <tier0_assign_homes+0x770>
  c9a90b:	vmovdqa %ymm10,%ymm14
  c9a910:	vmovdqu64 0xc0(%rcx,%r9,4),%zmm22
  c9a918:	vpsrlq $0x20,%zmm22,%zmm16
  c9a91f:	vpmovqb %zmm16,%xmm16
  c9a925:	vpandq %xmm4,%xmm16,%xmm18
  c9a92b:	vptestnmb %xmm3,%xmm16,%k3
  c9a931:	vpcmpneqb %xmm2,%xmm16,%k2
  c9a938:	vpaddb %xmm5,%xmm18,%xmm18
  c9a93e:	vmovdqu8 %xmm16,%xmm18{%k3}
  c9a944:	vpmovzxbd %xmm18,%ymm16
  c9a94a:	vmovdqa64 %ymm9,%ymm18
  c9a950:	vpsllvd %ymm16,%ymm6,%ymm16
  c9a956:	vpord  %ymm16,%ymm9,%ymm18{%k2}
  c9a95c:	vmovdqa64 %ymm18,%ymm16
  c9a962:	jne    c9a610 <tier0_assign_homes+0x470>
  c9a968:	vmovdqa64 %ymm9,%ymm16
  c9a96e:	jmp    c9a610 <tier0_assign_homes+0x470>
  c9a973:	vpor   %ymm11,%ymm12,%ymm0
  c9a978:	vpternlogd $0xfe,%ymm0,%ymm14,%ymm16
  c9a97f:	vextracti32x4 $0x1,%ymm16,%xmm0
  c9a986:	vpord  %xmm0,%xmm16,%xmm0
  c9a98c:	vpshufd $0xee,%xmm0,%xmm1
  c9a991:	vpor   %xmm1,%xmm0,%xmm0
  c9a995:	vpshufd $0x55,%xmm0,%xmm1
  c9a99a:	vpor   %xmm1,%xmm0,%xmm0
  c9a99e:	vmovd  %xmm0,%ebx
  c9a9a2:	cmp    %eax,%esi
  c9a9a4:	je     c9ab02 <tier0_assign_homes+0x962>
  c9a9aa:	test   $0x18,%al
  c9a9ac:	je     c9b51a <tier0_assign_homes+0x137a>
  c9a9b2:	vpbroadcastq -0x6d50dc(%rip),%zmm1        # 5c58e0 <check_mutation_families+0xad4>
  c9a9bc:	vpbroadcastq -0x6d50de(%rip),%zmm2        # 5c58e8 <check_mutation_families+0xadc>
  c9a9c6:	vpbroadcastb -0x7bf94e(%rip),%xmm4        # 4db081 <check_builtin_atomic_rmw_test_clang.native_source+0xa571>
  c9a9cf:	vpbroadcastb -0x7bf956(%rip),%xmm5        # 4db082 <check_builtin_atomic_rmw_test_clang.native_source+0xa572>
  c9a9d8:	vpbroadcastb -0x7bf95e(%rip),%xmm6        # 4db083 <check_builtin_atomic_rmw_test_clang.native_source+0xa573>
  c9a9e1:	vpbroadcastd -0x6d4586(%rip),%ymm7        # 5c6464 <unwind_tier0_test_terminal.ids+0x4c4>
  c9a9ea:	mov    %rsi,%rdi
  c9a9ed:	mov    %eax,%esi
  c9a9ef:	and    $0xfffffff8,%esi
  c9a9f2:	mov    %rdx,%r8
  c9a9f5:	neg    %r8
  c9a9f8:	vmovd  %ebx,%xmm0
  c9a9fc:	vpcmpeqd %xmm3,%xmm3,%xmm3
  c9aa00:	sbb    %r8d,%r8d
  c9aa03:	kmovd  %r8d,%k1
  c9aa08:	jmp    c9aa80 <tier0_assign_homes+0x8e0>
  c9aa0a:	nopw   0x0(%rax,%rax,1)
  c9aa10:	vmovdqu32 (%rdx,%rdi,4),%ymm12{%k1}{z}
  c9aa17:	vpsrlq $0x28,%zmm10,%zmm11
  c9aa1e:	vpandq %zmm1,%zmm10,%zmm10
  c9aa24:	add    $0x8,%rdi
  c9aa28:	vpmovqb %zmm11,%xmm11
  c9aa2e:	vpcmpeqq %zmm2,%zmm10,%k2
  c9aa34:	vpand  %xmm5,%xmm11,%xmm10
  c9aa38:	vptestnmb %xmm4,%xmm11,%k3
  c9aa3e:	vpaddb %xmm6,%xmm10,%xmm10
  c9aa42:	vptestmd %ymm12,%ymm12,%k0{%k2}
  c9aa48:	vmovdqu8 %xmm11,%xmm10{%k3}
  c9aa4e:	vpcmpneqb %xmm3,%xmm11,%k2
  c9aa55:	vpmovzxbd %xmm10,%ymm10
  c9aa5a:	kandb  %k1,%k2,%k2
  c9aa5e:	vpsllvd %ymm10,%ymm7,%ymm10
  c9aa63:	kandb  %k2,%k0,%k2
  c9aa67:	kandnb %k1,%k0,%k3
  c9aa6b:	vpord  %ymm9,%ymm10,%ymm8{%k2}
  c9aa71:	vmovdqa32 %ymm0,%ymm8{%k3}
  c9aa77:	vmovdqa %ymm8,%ymm0
  c9aa7b:	cmp    %rdi,%rsi
  c9aa7e:	je     c9aada <tier0_assign_homes+0x93a>
  c9aa80:	vmovdqu64 (%rcx,%rdi,8),%zmm10
  c9aa87:	vpsrlq $0x20,%zmm10,%zmm8
  c9aa8e:	vpmovqb %zmm8,%xmm8
  c9aa94:	vpand  %xmm5,%xmm8,%xmm9
  c9aa98:	vptestnmb %xmm4,%xmm8,%k3
  c9aa9e:	vpcmpneqb %xmm3,%xmm8,%k2
  c9aaa5:	vpaddb %xmm6,%xmm9,%xmm9
  c9aaa9:	vmovdqu8 %xmm8,%xmm9{%k3}
  c9aaaf:	vpmovzxbd %xmm9,%ymm8
  c9aab4:	vmovdqa %ymm0,%ymm9
  c9aab8:	vpsllvd %ymm8,%ymm7,%ymm8
  c9aabd:	vpord  %ymm8,%ymm0,%ymm9{%k2}
  c9aac3:	vmovdqa %ymm9,%ymm8
  c9aac8:	test   %rdx,%rdx
  c9aacb:	jne    c9aa10 <tier0_assign_homes+0x870>
  c9aad1:	vmovdqa %ymm0,%ymm8
  c9aad5:	jmp    c9aa10 <tier0_assign_homes+0x870>
  c9aada:	vextracti128 $0x1,%ymm8,%xmm0
  c9aae0:	vpor   %xmm0,%xmm8,%xmm0
  c9aae4:	vpshufd $0xee,%xmm0,%xmm1
  c9aae9:	vpor   %xmm1,%xmm0,%xmm0
  c9aaed:	vpshufd $0x55,%xmm0,%xmm1
  c9aaf2:	vpor   %xmm1,%xmm0,%xmm0
  c9aaf6:	vmovd  %xmm0,%ebx
  c9aafa:	cmp    %eax,%esi
  c9aafc:	jne    c9b51a <tier0_assign_homes+0x137a>
  c9ab02:	mov    0x18(%rsp),%rdx
  c9ab07:	movzbl 0x59(%rdx),%ecx
  c9ab0b:	movzbl 0x5a(%rdx),%ebp
  c9ab0f:	or     0x3c(%rdx),%ebx
  c9ab12:	shl    $0x5,%ecx
  c9ab15:	shl    $0xf,%ebp
  c9ab18:	or     %ecx,%ebp
  c9ab1a:	test   %r11,%r11
  c9ab1d:	je     c9ab3c <tier0_assign_homes+0x99c>
  c9ab1f:	lea    0x0(,%r11,8),%rdx
  c9ab27:	mov    %r15,%rdi
  c9ab2a:	xor    %esi,%esi
  c9ab2c:	vzeroupper
  c9ab2f:	call   7e6180 <memset@plt>
  c9ab34:	mov    0x34(%r12),%eax
  c9ab39:	mov    %r13,%r11
  c9ab3c:	or     %ebx,%ebp
  c9ab3e:	test   %eax,%eax
  c9ab40:	je     c9abb1 <tier0_assign_homes+0xa11>
  c9ab42:	mov    $0x10000,%edx
  c9ab47:	mov    $0x1,%esi
  c9ab4c:	xor    %ecx,%ecx
  c9ab4e:	jmp    c9ab5a <tier0_assign_homes+0x9ba>
  c9ab50:	inc    %rcx
  c9ab53:	mov    %eax,%edi
  c9ab55:	cmp    %rdi,%rcx
  c9ab58:	jae    c9abb1 <tier0_assign_homes+0xa11>
  c9ab5a:	mov    0x38(%r12),%rdi
  c9ab5f:	cmpb   $0x1,0x6(%rdi,%rcx,8)
  c9ab64:	jne    c9ab50 <tier0_assign_homes+0x9b0>
  c9ab66:	mov    0x28(%r12),%r8
  c9ab6b:	testb  $0x1,(%r8,%rcx,1)
  c9ab70:	jne    c9ab50 <tier0_assign_homes+0x9b0>
  c9ab72:	cmpl   $0x0,(%r14,%rcx,4)
  c9ab77:	je     c9ab50 <tier0_assign_homes+0x9b0>
  c9ab79:	movzbl 0x4(%rdi,%rcx,8),%edi
  c9ab7e:	mov    0x18(%rsp),%r10
  c9ab83:	test   $0x20,%dil
  c9ab87:	shlx   %edi,%edx,%r8d
  c9ab8c:	shlx   %edi,%esi,%r9d
  c9ab91:	cmovne %r8d,%r9d
  c9ab95:	test   %r9d,0x3c(%r10)
  c9ab99:	jne    c9ab50 <tier0_assign_homes+0x9b0>
  c9ab9b:	and    $0x1f,%dil
  c9ab9f:	mov    %dil,0x4(%r15,%rcx,8)
  c9aba4:	movb   $0x1,0x6(%r15,%rcx,8)
  c9abaa:	mov    0x34(%r12),%eax
  c9abaf:	jmp    c9ab50 <tier0_assign_homes+0x9b0>
  c9abb1:	mov    0x20(%rsp),%ecx
  c9abb5:	or     $0x10,%ebp
  c9abb8:	cmp    $0x41,%r11d
  c9abbc:	setb   %al
  c9abbf:	test   %al,%cl
  c9abc1:	je     c9b1b6 <tier0_assign_homes+0x1016>
  c9abc7:	mov    %ebp,%ecx
  c9abc9:	not    %ecx
  c9abcb:	mov    0x30(%r12),%eax
  c9abd0:	vpxor  %xmm0,%xmm0,%xmm0
  c9abd4:	vmovdqu64 %zmm0,0xd0(%rsp)
  c9abdf:	movl   $0x0,0xd0(%rsp)
  c9abea:	vpxor  %xmm1,%xmm1,%xmm1
  c9abee:	vmovdqu %xmm1,0xbc(%rsp)
  c9abf7:	vmovdqa %xmm1,0xb0(%rsp)
  c9ac00:	movl   $0x1,0xb4(%rsp)
  c9ac0b:	mov    %ebx,%r9d
  c9ac0e:	vmovdqu64 %zmm0,0x70(%rsp)
  c9ac19:	and    $0x1,%ecx
  c9ac1c:	bt     $0x1,%ebp
  c9ac20:	movl   $0x1,0xd0(%rsp,%rcx,4)
  c9ac2b:	sbb    $0xffffffff,%ecx
  c9ac2e:	bt     $0x2,%ebp
  c9ac32:	movl   $0x2,0xd0(%rsp,%rcx,4)
  c9ac3d:	sbb    $0xffffffff,%ecx
  c9ac40:	bt     $0x6,%ebp
  c9ac44:	movl   $0x6,0xd0(%rsp,%rcx,4)
  c9ac4f:	sbb    $0xffffffff,%ecx
  c9ac52:	bt     $0x7,%ebp
  c9ac56:	movl   $0x7,0xd0(%rsp,%rcx,4)
  c9ac61:	sbb    $0xffffffff,%ecx
  c9ac64:	bt     $0x8,%ebp
  c9ac68:	mov    %rax,0x10(%rsp)
  c9ac6d:	movl   $0x8,0xd0(%rsp,%rcx,4)
  c9ac78:	sbb    $0xffffffff,%ecx
  c9ac7b:	bt     $0x9,%ebp
  c9ac7f:	movl   $0x9,0xd0(%rsp,%rcx,4)
  c9ac8a:	sbb    $0xffffffff,%ecx
  c9ac8d:	bt     $0xa,%ebp
  c9ac91:	movl   $0xa,0xd0(%rsp,%rcx,4)
  c9ac9c:	sbb    $0xffffffff,%ecx
  c9ac9f:	bt     $0xb,%ebp
  c9aca3:	movl   $0xb,0xd0(%rsp,%rcx,4)
  c9acae:	sbb    $0xffffffff,%ecx
  c9acb1:	xor    %edi,%edi
  c9acb3:	test   $0x8,%bpl
  c9acb7:	sete   %dil
  c9acbb:	movl   $0x3,0xd0(%rsp,%rcx,4)
  c9acc6:	lea    (%rcx,%rdi,1),%eax
  c9acc9:	movl   $0x5,0xd0(%rsp,%rax,4)
  c9acd4:	mov    0xb0(%rsp,%rdi,4),%eax
  c9acdb:	or     $0x2,%eax
  c9acde:	bt     $0x5,%ebp
  c9ace2:	mov    %eax,0xb4(%rsp,%rdi,4)
  c9ace9:	sbb    $0xffffffff,%edi
  c9acec:	lea    (%rcx,%rdi,1),%eax
  c9acef:	mov    %rax,0x8(%rsp)
  c9acf4:	mov    0xb0(%rsp,%rdi,4),%eax
  c9acfb:	or     $0x4,%eax
  c9acfe:	bt     $0xc,%ebp
  c9ad02:	mov    %eax,0xb4(%rsp,%rdi,4)
  c9ad09:	sbb    $0xffffffff,%edi
  c9ad0c:	lea    (%rcx,%rdi,1),%eax
  c9ad0f:	mov    %rax,(%rsp)
  c9ad13:	mov    0xb0(%rsp,%rdi,4),%eax
  c9ad1a:	or     $0x8,%eax
  c9ad1d:	bt     $0xd,%ebp
  c9ad21:	mov    %eax,0xb4(%rsp,%rdi,4)
  c9ad28:	sbb    $0xffffffff,%edi
  c9ad2b:	lea    (%rcx,%rdi,1),%eax
  c9ad2e:	mov    %rax,0x38(%rsp)
  c9ad33:	mov    0xb0(%rsp,%rdi,4),%eax
  c9ad3a:	or     $0x10,%eax
  c9ad3d:	bt     $0xe,%ebp
  c9ad41:	mov    %eax,0xb4(%rsp,%rdi,4)
  c9ad48:	sbb    $0xffffffff,%edi
  c9ad4b:	xor    %edx,%edx
  c9ad4d:	mov    0xb0(%rsp,%rdi,4),%eax
  c9ad54:	or     $0x20,%eax
  c9ad57:	test   $0x10000,%ebx
  c9ad5d:	sete   %dl
  c9ad60:	xor    %r13d,%r13d
  c9ad63:	test   $0x20000,%ebx
  c9ad69:	mov    %eax,0x30(%rsp)
  c9ad6d:	sete   %r13b
  c9ad71:	mov    %rdx,0x20(%rsp)
  c9ad76:	lea    (%rdx,%r13,1),%eax
  c9ad7a:	mov    %rax,0x28(%rsp)
  c9ad7f:	mov    %ebx,%eax
  c9ad81:	and    $0x40000,%eax
  c9ad86:	cmp    $0x1,%eax
  c9ad89:	adc    %edx,%r13d
  c9ad8c:	xor    %r11d,%r11d
  c9ad8f:	test   $0x80000,%ebx
  c9ad95:	sete   %r11b
  c9ad99:	lea    0x0(%r13,%r11,1),%eax
  c9ad9e:	mov    %rax,0x58(%rsp)
  c9ada3:	mov    %ebx,%eax
  c9ada5:	and    $0x100000,%eax
  c9adaa:	cmp    $0x1,%eax
  c9adad:	mov    %ebx,%eax
  c9adaf:	adc    %r13d,%r11d
  c9adb2:	xor    %r10d,%r10d
  c9adb5:	test   $0x200000,%ebx
  c9adbb:	sete   %r10b
  c9adbf:	and    $0x400000,%eax
  c9adc4:	cmp    $0x1,%eax
  c9adc7:	lea    (%r11,%r10,1),%eax
  c9adcb:	adc    %r11d,%r10d
  c9adce:	xor    %r8d,%r8d
  c9add1:	test   $0x800000,%ebx
  c9add7:	mov    %rax,0x50(%rsp)
  c9addc:	mov    %ebx,%eax
  c9adde:	sete   %r8b
  c9ade2:	and    $0x1000000,%eax
  c9ade7:	cmp    $0x1,%eax
  c9adea:	lea    (%r10,%r8,1),%eax
  c9adee:	adc    %r10d,%r8d
  c9adf1:	xor    %edx,%edx
  c9adf3:	test   $0x2000000,%ebx
  c9adf9:	mov    %rax,0x48(%rsp)
  c9adfe:	mov    %ebx,%eax
  c9ae00:	sete   %dl
  c9ae03:	and    $0x4000000,%eax
  c9ae08:	cmp    $0x1,%eax
  c9ae0b:	lea    (%r8,%rdx,1),%eax
  c9ae0f:	mov    %rax,0x40(%rsp)
  c9ae14:	adc    %r8d,%edx
  c9ae17:	xor    %eax,%eax
  c9ae19:	test   $0x8000000,%ebx
  c9ae1f:	sete   %al
  c9ae22:	and    $0x10000000,%r9d
  c9ae29:	cmp    $0x1,%r9d
  c9ae2d:	lea    (%rdx,%rax,1),%esi
  c9ae30:	mov    %ebx,%r9d
  c9ae33:	mov    %rsi,0x68(%rsp)
  c9ae38:	adc    %edx,%eax
  c9ae3a:	xor    %esi,%esi
  c9ae3c:	test   $0x20000000,%ebx
  c9ae42:	sete   %sil
  c9ae46:	and    $0x40000000,%r9d
  c9ae4d:	cmp    $0x1,%r9d
  c9ae51:	lea    (%rax,%rsi,1),%r9d
  c9ae55:	mov    %r9,0x60(%rsp)
  c9ae5a:	mov    0x20(%rsp),%r9
  c9ae5f:	adc    %eax,%esi
  c9ae61:	test   %bp,%bp
  c9ae64:	mov    0x8(%rsp),%rbp
  c9ae69:	movl   $0x1,0x70(%rsp,%r9,4)
  c9ae72:	mov    0x28(%rsp),%r9
  c9ae77:	movl   $0xc,0xd0(%rsp,%rbp,4)
  c9ae82:	mov    (%rsp),%rbp
  c9ae86:	movl   $0x2,0x70(%rsp,%r9,4)
  c9ae8f:	mov    0x58(%rsp),%r9
  c9ae94:	movl   $0x3,0x70(%rsp,%r13,4)
  c9ae9d:	movl   $0xd,0xd0(%rsp,%rbp,4)
  c9aea8:	mov    0x38(%rsp),%rbp
  c9aead:	movl   $0x4,0x70(%rsp,%r9,4)
  c9aeb6:	mov    0x50(%rsp),%r9
  c9aebb:	movl   $0x5,0x70(%rsp,%r11,4)
  c9aec4:	movl   $0xe,0xd0(%rsp,%rbp,4)
  c9aecf:	mov    0x30(%rsp),%ebp
  c9aed3:	mov    %rcx,0x30(%rsp)
  c9aed8:	lea    (%rcx,%rdi,1),%ecx
  c9aedb:	movl   $0xf,0xd0(%rsp,%rcx,4)
  c9aee6:	movl   $0x6,0x70(%rsp,%r9,4)
  c9aeef:	mov    0x48(%rsp),%r9
  c9aef4:	movl   $0x7,0x70(%rsp,%r10,4)
  c9aefd:	mov    %ebp,0xb4(%rsp,%rdi,4)
  c9af04:	mov    0x10(%rsp),%rbp
  c9af09:	movl   $0x8,0x70(%rsp,%r9,4)
  c9af12:	movl   $0x9,0x70(%rsp,%r8,4)
  c9af1b:	mov    0x40(%rsp),%r8
  c9af20:	movl   $0xa,0x70(%rsp,%r8,4)
  c9af29:	movl   $0xb,0x70(%rsp,%rdx,4)
  c9af31:	mov    0x68(%rsp),%rdx
  c9af36:	movl   $0xc,0x70(%rsp,%rdx,4)
  c9af3e:	movl   $0xd,0x70(%rsp,%rax,4)
  c9af46:	mov    0x60(%rsp),%rax
  c9af4b:	movl   $0xe,0x70(%rsp,%rax,4)
  c9af53:	setns  %al
  c9af56:	movl   $0xf,0x70(%rsp,%rsi,4)
  c9af5e:	test   %rbp,%rbp
  c9af61:	je     c9b5b0 <tier0_assign_homes+0x1410>
  c9af67:	not    %ebx
  c9af69:	mov    %rsi,%rdi
  c9af6c:	mov    %rcx,0x28(%rsp)
  c9af71:	lea    -0x1(%rbp),%rcx
  c9af75:	xor    %r11d,%r11d
  c9af78:	mov    %al,%r11b
  c9af7b:	mov    %rbp,%rax
  c9af7e:	shr    $0x1f,%ebx
  c9af81:	mov    %rcx,%r13
  c9af84:	add    %ebx,%edi
  c9af86:	mov    0x20(%r12),%rbx
  c9af8b:	mov    0x28(%r12),%r12
  c9af90:	shr    $0x4,%r13
  c9af94:	je     c9b5b7 <tier0_assign_homes+0x1417>
  c9af9a:	mov    %rcx,0x40(%rsp)
  c9af9f:	lea    0x10(%r12),%rcx
  c9afa4:	vpbroadcastq -0x6d56be(%rip),%zmm0        # 5c58f0 <check_mutation_families+0xae4>
  c9afae:	vpbroadcastb -0x7bff33(%rip),%xmm1        # 4db084 <check_builtin_atomic_rmw_test_clang.native_source+0xa574>
  c9afb7:	vpbroadcastb -0x7bff3b(%rip),%xmm2        # 4db085 <check_builtin_atomic_rmw_test_clang.native_source+0xa575>
  c9afc0:	mov    %rbx,0x50(%rsp)
  c9afc5:	inc    %r13
  c9afc8:	mov    %r15,0x8(%rsp)
  c9afcd:	mov    $0xffffffffffffffff,%r15
  c9afd4:	mov    %r11d,0x58(%rsp)
  c9afd9:	mov    %rdi,0x20(%rsp)
  c9afde:	mov    %r12,0x48(%rsp)
  c9afe3:	xor    %r10d,%r10d
  c9afe6:	xor    %r8d,%r8d
  c9afe9:	xor    %r9d,%r9d
  c9afec:	mov    %rcx,(%rsp)
  c9aff0:	lea    0x10(%rbx),%rcx
  c9aff4:	and    $0xfffffffffffffffe,%r13
  c9aff8:	mov    %rcx,0x38(%rsp)
  c9affd:	mov    (%rsp),%rbx
  c9b001:	mov    0x38(%rsp),%rbp
  c9b006:	cs nopw 0x0(%rax,%rax,1)
  c9b010:	mov    0x8(%rsp),%rdx
  c9b015:	shlx   %rax,%r15,%rcx
  c9b01a:	cmp    $0x40,%rax
  c9b01e:	lea    0x40(%r14),%r11
  c9b022:	not    %rcx
  c9b025:	cmovae %r15,%rcx
  c9b029:	kmovd  %ecx,%k1
  c9b02d:	lea    0xc0(%rdx),%rsi
  c9b034:	mov    %ecx,%edx
  c9b036:	shr    $0x8,%edx
  c9b039:	vmovdqu64 -0xc0(%rsi,%r10,8),%zmm3{%k1}{z}
  c9b041:	kmovd  %edx,%k1
  c9b045:	vmovdqu64 -0x80(%rsi,%r10,8),%zmm4{%k1}{z}
  c9b04d:	vptestmq %zmm0,%zmm3,%k0
  c9b053:	vptestmq %zmm0,%zmm4,%k1
  c9b059:	kunpckbw %k0,%k1,%k0
  c9b05d:	kmovd  %ecx,%k1
  c9b061:	vmovdqu8 -0x10(%rbx,%r10,1),%xmm4{%k1}{z}
  c9b069:	vmovdqu32 -0x40(%r11,%r10,4),%zmm3{%k1}{z}
  c9b071:	vmovdqu8 -0x10(%rbp,%r10,1),%xmm5{%k1}{z}
  c9b079:	vpsllw $0x7,%xmm4,%xmm4
  c9b07e:	vptestmd %zmm3,%zmm3,%k2
  c9b084:	vpmovb2m %xmm4,%k1
  c9b08a:	vpaddb %xmm1,%xmm5,%xmm4
  c9b08e:	kmovw  %k2,%edi
  c9b092:	korw   %k1,%k0,%k0
  c9b096:	vpcmpltub %xmm2,%xmm4,%k1
  c9b09d:	kmovw  %k0,%edx
  c9b0a1:	andn   %edi,%edx,%edx
  c9b0a6:	kmovw  %k1,%edi
  c9b0aa:	and    %ecx,%edx
  c9b0ac:	andn   %edx,%edi,%ecx
  c9b0b1:	and    %edi,%edx
  c9b0b3:	shlx   %r10,%rdx,%rdi
  c9b0b8:	mov    %r9,%rdx
  c9b0bb:	shlx   %r10,%rcx,%r12
  c9b0c0:	mov    %r8,%rcx
  c9b0c3:	or     %rdi,%rdx
  c9b0c6:	lea    -0x10(%rax),%rdi
  c9b0ca:	or     %r12,%rcx
  c9b0cd:	lea    0x10(%r10),%r12d
  c9b0d1:	shlx   %rdi,%r15,%r8
  c9b0d6:	cmp    $0x40,%rdi
  c9b0da:	not    %r8
  c9b0dd:	cmovae %r15,%r8
  c9b0e1:	add    $0xffffffffffffffe0,%rax
  c9b0e5:	mov    %r8d,%edi
  c9b0e8:	kmovd  %r8d,%k1
  c9b0ed:	shr    $0x8,%edi
  c9b0f0:	vmovdqu64 -0x40(%rsi,%r10,8),%zmm3{%k1}{z}
  c9b0f8:	kmovd  %edi,%k1
  c9b0fc:	vmovdqu64 (%rsi,%r10,8),%zmm4{%k1}{z}
  c9b103:	vptestmq %zmm0,%zmm3,%k0
  c9b109:	vptestmq %zmm0,%zmm4,%k1
  c9b10f:	kunpckbw %k0,%k1,%k0
  c9b113:	kmovd  %r8d,%k1
  c9b118:	vmovdqu8 (%rbx,%r10,1),%xmm4{%k1}{z}
  c9b11f:	vmovdqu32 (%r11,%r10,4),%zmm3{%k1}{z}
  c9b126:	vmovdqu8 0x0(%rbp,%r10,1),%xmm5{%k1}{z}
  c9b12e:	add    $0x20,%r10
  c9b132:	vpsllw $0x7,%xmm4,%xmm4
  c9b137:	vptestmd %zmm3,%zmm3,%k2
  c9b13d:	vpmovb2m %xmm4,%k1
  c9b143:	vpaddb %xmm1,%xmm5,%xmm4
  c9b147:	kmovw  %k2,%r9d
  c9b14b:	korw   %k1,%k0,%k0
  c9b14f:	vpcmpltub %xmm2,%xmm4,%k1
  c9b156:	kmovw  %k0,%edi
  c9b15a:	andn   %r9d,%edi,%edi
  c9b15f:	kmovw  %k1,%r9d
  c9b163:	and    %r8d,%edi
  c9b166:	andn   %edi,%r9d,%r8d
  c9b16b:	and    %r9d,%edi
  c9b16e:	shlx   %r12,%r8,%r8
  c9b173:	shlx   %r12,%rdi,%r9
  c9b178:	or     %rcx,%r8
  c9b17b:	or     %rdx,%r9
  c9b17e:	add    $0xfffffffffffffffe,%r13
  c9b182:	jne    c9b010 <tier0_assign_homes+0xe70>
  c9b188:	testb  $0x10,0x40(%rsp)
  c9b18d:	mov    0x10(%rsp),%r13
  c9b192:	mov    0x20(%rsp),%rdi
  c9b197:	mov    0x58(%rsp),%r11d
  c9b19c:	mov    0x50(%rsp),%rbx
  c9b1a1:	mov    0x48(%rsp),%r12
  c9b1a6:	mov    0x8(%rsp),%r15
  c9b1ab:	je     c9b5c3 <tier0_assign_homes+0x1423>
  c9b1b1:	jmp    c9b687 <tier0_assign_homes+0x14e7>
  c9b1b6:	mov    %ecx,%eax
  c9b1b8:	test   %al,%al
  c9b1ba:	je     c9b37d <tier0_assign_homes+0x11dd>
  c9b1c0:	vpbroadcastq -0x6d58da(%rip),%zmm0        # 5c58f0 <check_mutation_families+0xae4>
  c9b1ca:	vpbroadcastb -0x7c014f(%rip),%xmm1        # 4db084 <check_builtin_atomic_rmw_test_clang.native_source+0xa574>
  c9b1d3:	vpbroadcastb -0x7c0157(%rip),%xmm2        # 4db085 <check_builtin_atomic_rmw_test_clang.native_source+0xa575>
  c9b1dc:	vmovdqa64 -0x7c0226(%rip),%zmm3        # 4dafc0 <check_builtin_atomic_rmw_test_clang.native_source+0xa4b0>
  c9b1e6:	mov    (%rsp),%rbx
  c9b1ea:	mov    $0xffff,%esi
  c9b1ef:	mov    $0x1,%dl
  c9b1f1:	mov    $0xffffffffffffffff,%rcx
  c9b1f8:	xor    %eax,%eax
  c9b1fa:	jmp    c9b230 <tier0_assign_homes+0x1090>
  c9b1fc:	nopl   0x0(%rax)
  c9b200:	mov    (%rsp),%rbx
  c9b204:	vptestmd %zmm5,%zmm5,%k1
  c9b20a:	mov    %eax,%esi
  c9b20c:	vpcompressd %zmm4,(%rbx,%rsi,4){%k1}
  c9b213:	kmovw  %k1,%esi
  c9b217:	popcnt %esi,%esi
  c9b21b:	add    %esi,%eax
  c9b21d:	mov    $0x10000,%esi
  c9b222:	test   $0x1,%dl
  c9b225:	mov    $0x0,%edx
  c9b22a:	je     c9b395 <tier0_assign_homes+0x11f5>
  c9b230:	mov    0x30(%r12),%edi
  c9b235:	test   %rdi,%rdi
  c9b238:	je     c9b370 <tier0_assign_homes+0x11d0>
  c9b23e:	mov    0x20(%r12),%r8
  c9b243:	mov    0x28(%r12),%r9
  c9b248:	vpxor  %xmm4,%xmm4,%xmm4
  c9b24c:	xor    %r10d,%r10d
  c9b24f:	vpxor  %xmm5,%xmm5,%xmm5
  c9b253:	jmp    c9b269 <tier0_assign_homes+0x10c9>
  c9b255:	data16 cs nopw 0x0(%rax,%rax,1)
  c9b260:	add    $0x10,%r10
  c9b264:	cmp    %rdi,%r10
  c9b267:	jae    c9b200 <tier0_assign_homes+0x1060>
  c9b269:	mov    %rdi,%r11
  c9b26c:	sub    %r10,%r11
  c9b26f:	vpshufd $0xff,%zmm5,%zmm7
  c9b276:	cmp    $0x40,%r11
  c9b27a:	shlx   %r11,%rcx,%r11
  c9b27f:	vshufi64x2 $0xff,%zmm7,%zmm7,%zmm7
  c9b286:	not    %r11
  c9b289:	cmovae %rcx,%r11
  c9b28d:	kmovd  %r11d,%k1
  c9b292:	mov    %r11d,%ebx
  c9b295:	kmovd  %r11d,%k2
  c9b29a:	shr    $0x8,%ebx
  c9b29d:	vmovdqu32 (%r14,%r10,4),%zmm6{%k1}{z}
  c9b2a4:	vpcmpnleud %zmm7,%zmm6,%k0
  c9b2ab:	vmovdqu64 (%r15,%r10,8),%zmm6{%k2}{z}
  c9b2b2:	kmovd  %ebx,%k2
  c9b2b6:	vmovdqu64 0x40(%r15,%r10,8),%zmm7{%k2}{z}
  c9b2be:	kmovw  %k0,%r13d
  c9b2c2:	and    %r11d,%r13d
  c9b2c5:	vptestmq %zmm0,%zmm6,%k0
  c9b2cb:	vmovdqu8 (%r9,%r10,1),%xmm6{%k1}{z}
  c9b2d2:	vptestmq %zmm0,%zmm7,%k2
  c9b2d8:	vmovdqu8 (%r8,%r10,1),%xmm7{%k1}{z}
  c9b2df:	kunpckbw %k0,%k2,%k0
  c9b2e3:	vpsllw $0x7,%xmm6,%xmm6
  c9b2e8:	vpmovb2m %xmm6,%k1
  c9b2ee:	vpaddb %xmm1,%xmm7,%xmm7
  c9b2f2:	korw   %k1,%k0,%k0
  c9b2f6:	vpcmpltub %xmm2,%xmm7,%k1
  c9b2fd:	kmovw  %k0,%r11d
  c9b301:	kmovw  %k1,%ebx
  c9b305:	xor    %esi,%ebx
  c9b307:	andn   %r13d,%r11d,%r11d
  c9b30c:	and    %ebx,%r11d
  c9b30f:	jne    c9b32b <tier0_assign_homes+0x118b>
  c9b311:	jmp    c9b260 <tier0_assign_homes+0x10c0>
  c9b316:	cs nopw 0x0(%rax,%rax,1)
  c9b320:	blsr   %r11d,%r11d
  c9b325:	je     c9b260 <tier0_assign_homes+0x10c0>
  c9b32b:	tzcnt  %r11d,%ebx
  c9b330:	add    %r10d,%ebx
  c9b333:	vpbroadcastd (%r14,%rbx,4),%zmm6
  c9b33a:	vpcmpnleud %zmm5,%zmm6,%k1
  c9b341:	kortestw %k1,%k1
  c9b345:	je     c9b320 <tier0_assign_homes+0x1180>
  c9b347:	vpermd %zmm4,%zmm3,%zmm4{%k1}
  c9b34d:	vpermd %zmm5,%zmm3,%zmm5{%k1}
  c9b353:	kmovd  %k1,%r13d
  c9b357:	blsi   %r13d,%r13d
  c9b35c:	kmovd  %r13d,%k2
  c9b361:	vpbroadcastd %ebx,%zmm4{%k2}
  c9b367:	vmovdqa32 %zmm6,%zmm5{%k2}
  c9b36d:	jmp    c9b320 <tier0_assign_homes+0x1180>
  c9b36f:	nop
  c9b370:	kxorw  %k0,%k0,%k1
  c9b374:	vpxor  %xmm4,%xmm4,%xmm4
  c9b378:	jmp    c9b20a <tier0_assign_homes+0x106a>
  c9b37d:	mov    (%rsp),%rbx
  c9b381:	mov    %r12,%rdi
  c9b384:	mov    %r15,%rsi
  c9b387:	mov    %r14,%rdx
  c9b38a:	mov    %rbx,%rcx
  c9b38d:	vzeroupper
  c9b390:	call   ca0800 <tier0_register_locals>
  c9b395:	test   %eax,%eax
  c9b397:	je     c9b865 <tier0_assign_homes+0x16c5>
  c9b39d:	mov    $0x10000,%edx
  c9b3a2:	lea    -0x7b72c9(%rip),%rsi        # 4e40e0 <tier0_integer_depths>
  c9b3a9:	mov    $0x1,%edi
  c9b3ae:	mov    %eax,%eax
  c9b3b0:	xor    %ecx,%ecx
  c9b3b2:	jmp    c9b3ec <tier0_assign_homes+0x124c>
  c9b3b4:	mov    $0x3,%r9d
  c9b3ba:	xor    %r10d,%r10d
  c9b3bd:	mov    0x18(%rsp),%r11
  c9b3c2:	shlx   %r10d,%edi,%r10d
  c9b3c7:	or     %r10d,0x4(%r11)
  c9b3cb:	shlx   %r9d,%edi,%r10d
  c9b3d0:	or     %r10d,%ebp
  c9b3d3:	mov    %r9b,0x4(%r15,%r8,8)
  c9b3d8:	movb   $0x1,0x6(%r15,%r8,8)
  c9b3de:	xchg   %ax,%ax
  c9b3e0:	inc    %rcx
  c9b3e3:	cmp    %rax,%rcx
  c9b3e6:	je     c9b865 <tier0_assign_homes+0x16c5>
  c9b3ec:	mov    (%rbx,%rcx,4),%r8d
  c9b3f0:	cmpb   $0x0,0x6(%r15,%r8,8)
  c9b3f6:	jne    c9b3e0 <tier0_assign_homes+0x1240>
  c9b3f8:	mov    0x28(%r12),%r9
  c9b3fd:	testb  $0x1,(%r9,%r8,1)
  c9b402:	jne    c9b3e0 <tier0_assign_homes+0x1240>
  c9b404:	cmpl   $0x0,(%r14,%r8,4)
  c9b409:	je     c9b3e0 <tier0_assign_homes+0x1240>
  c9b40b:	mov    0x20(%r12),%r9
  c9b410:	movzbl (%r9,%r8,1),%r9d
  c9b415:	add    $0xf7,%r9b
  c9b419:	cmp    $0x2,%r9b
  c9b41d:	jae    c9b459 <tier0_assign_homes+0x12b9>
  c9b41f:	xor    %r9d,%r9d
  c9b422:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  c9b430:	shlx   %r9d,%edx,%r10d
  c9b435:	cmp    $0xe,%r9d
  c9b439:	lea    0x1(%r9),%r9d
  c9b43d:	ja     c9b447 <tier0_assign_homes+0x12a7>
  c9b43f:	mov    %r10d,%r11d
  c9b442:	and    %ebp,%r11d
  c9b445:	jne    c9b430 <tier0_assign_homes+0x1290>
  c9b447:	test   %ebp,%r10d
  c9b44a:	jne    c9b3e0 <tier0_assign_homes+0x1240>
  c9b44c:	dec    %r9d
  c9b44f:	shlx   %r9d,%edx,%r10d
  c9b454:	jmp    c9b3d0 <tier0_assign_homes+0x1230>
  c9b459:	xor    %r10d,%r10d
  c9b45c:	nopl   0x0(%rax)
  c9b460:	movzbl (%r10,%rsi,1),%r9d
  c9b465:	shlx   %r9d,%edi,%r11d
  c9b46a:	cmp    $0x7,%r10
  c9b46e:	ja     c9b47c <tier0_assign_homes+0x12dc>
  c9b470:	mov    %r11d,%ebx
  c9b473:	and    %ebp,%ebx
  c9b475:	inc    %r10
  c9b478:	test   %ebx,%ebx
  c9b47a:	jne    c9b460 <tier0_assign_homes+0x12c0>
  c9b47c:	mov    (%rsp),%rbx
  c9b480:	test   %ebp,%r11d
  c9b483:	je     c9b3cb <tier0_assign_homes+0x122b>
  c9b489:	cmpl   $0x2,(%r14,%r8,4)
  c9b48e:	jb     c9b3e0 <tier0_assign_homes+0x1240>
  c9b494:	test   $0x8,%bpl
  c9b498:	je     c9b3b4 <tier0_assign_homes+0x1214>
  c9b49e:	test   $0x20,%bpl
  c9b4a2:	jne    c9b4b5 <tier0_assign_homes+0x1315>
  c9b4a4:	mov    $0x5,%r9d
  c9b4aa:	mov    $0x1,%r10d
  c9b4b0:	jmp    c9b3bd <tier0_assign_homes+0x121d>
  c9b4b5:	test   $0x1000,%ebp
  c9b4bb:	jne    c9b4ce <tier0_assign_homes+0x132e>
  c9b4bd:	mov    $0xc,%r9d
  c9b4c3:	mov    $0x2,%r10d
  c9b4c9:	jmp    c9b3bd <tier0_assign_homes+0x121d>
  c9b4ce:	test   $0x2000,%ebp
  c9b4d4:	jne    c9b4e7 <tier0_assign_homes+0x1347>
  c9b4d6:	mov    $0xd,%r9d
  c9b4dc:	mov    $0x3,%r10d
  c9b4e2:	jmp    c9b3bd <tier0_assign_homes+0x121d>
  c9b4e7:	test   $0x4000,%ebp
  c9b4ed:	jne    c9b500 <tier0_assign_homes+0x1360>
  c9b4ef:	mov    $0xe,%r9d
  c9b4f5:	mov    $0x4,%r10d
  c9b4fb:	jmp    c9b3bd <tier0_assign_homes+0x121d>
  c9b500:	test   %bp,%bp
  c9b503:	js     c9b3e0 <tier0_assign_homes+0x1240>
  c9b509:	mov    $0xf,%r9d
  c9b50f:	mov    $0x5,%r10d
  c9b515:	jmp    c9b3bd <tier0_assign_homes+0x121d>
  c9b51a:	movabs $0xfd000000000000,%rdi
  c9b524:	movabs $0x1000000000000,%r8
  c9b52e:	jmp    c9b53c <tier0_assign_homes+0x139c>
  c9b530:	inc    %rsi
  c9b533:	cmp    %rsi,%rax
  c9b536:	je     c9ab02 <tier0_assign_homes+0x962>
  c9b53c:	test   %rdx,%rdx
  c9b53f:	je     c9b530 <tier0_assign_homes+0x1390>
  c9b541:	cmpl   $0x0,(%rdx,%rsi,4)
  c9b545:	je     c9b530 <tier0_assign_homes+0x1390>
  c9b547:	mov    (%rcx,%rsi,8),%r9
  c9b54b:	mov    %r9,%r10
  c9b54e:	and    %rdi,%r10
  c9b551:	cmp    %r8,%r10
  c9b554:	jne    c9b530 <tier0_assign_homes+0x1390>
  c9b556:	mov    %r9,%r10
  c9b559:	shr    $0x20,%r10
  c9b55d:	cmp    $0xff,%r10b
  c9b561:	je     c9b585 <tier0_assign_homes+0x13e5>
  c9b563:	mov    %r10d,%r11d
  c9b566:	and    $0x1f,%r11b
  c9b56a:	add    $0x10,%r11b
  c9b56e:	test   $0x20,%r10b
  c9b572:	movzbl %r10b,%r10d
  c9b576:	movzbl %r11b,%r11d
  c9b57a:	cmove  %r10d,%r11d
  c9b57e:	bts    %r11d,%ebx
  c9b582:	mov    %r13,%r11
  c9b585:	shr    $0x28,%r9
  c9b589:	cmp    $0xff,%r9b
  c9b58d:	je     c9b530 <tier0_assign_homes+0x1390>
  c9b58f:	mov    %r9d,%r10d
  c9b592:	and    $0x1f,%r10b
  c9b596:	add    $0x10,%r10b
  c9b59a:	test   $0x20,%r9b
  c9b59e:	movzbl %r9b,%r9d
  c9b5a2:	movzbl %r10b,%r10d
  c9b5a6:	cmove  %r9d,%r10d
  c9b5aa:	bts    %r10d,%ebx
  c9b5ae:	jmp    c9b530 <tier0_assign_homes+0x1390>
  c9b5b0:	xor    %eax,%eax
  c9b5b2:	jmp    c9b856 <tier0_assign_homes+0x16b6>
  c9b5b7:	xor    %r10d,%r10d
  c9b5ba:	xor    %r8d,%r8d
  c9b5bd:	xor    %r9d,%r9d
  c9b5c0:	mov    %rax,%r13
  c9b5c3:	mov    %r13,%rdx
  c9b5c6:	sub    %r10,%rdx
  c9b5c9:	mov    $0xffffffffffffffff,%rsi
  c9b5d0:	vpbroadcastq -0x6d5cea(%rip),%zmm2        # 5c58f0 <check_mutation_families+0xae4>
  c9b5da:	mov    %r8,%rcx
  c9b5dd:	mov    %r9,%rax
  c9b5e0:	cmp    $0x40,%rdx
  c9b5e4:	shlx   %rdx,%rsi,%rdx
  c9b5e9:	not    %rdx
  c9b5ec:	cmovae %rsi,%rdx
  c9b5f0:	mov    %edx,%esi
  c9b5f2:	kmovd  %edx,%k1
  c9b5f6:	shr    $0x8,%esi
  c9b5f9:	vmovdqu64 (%r15,%r10,8),%zmm0{%k1}{z}
  c9b600:	kmovd  %esi,%k1
  c9b604:	vmovdqu64 0x40(%r15,%r10,8),%zmm1{%k1}{z}
  c9b60c:	vptestmq %zmm2,%zmm0,%k0
  c9b612:	vptestmq %zmm2,%zmm1,%k1
  c9b618:	kunpckbw %k0,%k1,%k0
  c9b61c:	kmovd  %edx,%k1
  c9b620:	vmovdqu8 (%r12,%r10,1),%xmm1{%k1}{z}
  c9b627:	vmovdqu32 (%r14,%r10,4),%zmm0{%k1}{z}
  c9b62e:	vmovdqu8 (%rbx,%r10,1),%xmm2{%k1}{z}
  c9b635:	vpsllw $0x7,%xmm1,%xmm1
  c9b63a:	vptestmd %zmm0,%zmm0,%k2
  c9b640:	vpmovb2m %xmm1,%k1
  c9b646:	vpaddb -0x6eb3ae(%rip),%xmm2,%xmm1        # 5b02a0 <tier0_program_class_type.types+0x2970>
  c9b64e:	kmovw  %k2,%r8d
  c9b652:	vpcmpltub -0x6eb3ad(%rip),%xmm1,%k3        # 5b02b0 <tier0_program_class_type.types+0x2980>
  c9b65d:	korw   %k1,%k0,%k0
  c9b661:	kmovw  %k0,%esi
  c9b665:	andn   %r8d,%esi,%esi
  c9b66a:	and    %edx,%esi
  c9b66c:	kmovw  %k3,%edx
  c9b670:	andn   %esi,%edx,%r8d
  c9b675:	and    %edx,%esi
  c9b677:	shlx   %r10,%r8,%r8
  c9b67c:	shlx   %r10,%rsi,%r9
  c9b681:	or     %rcx,%r8
  c9b684:	or     %rax,%r9
  c9b687:	mov    0x30(%rsp),%rax
  c9b68c:	vmovdqu64 0xd0(%rsp),%zmm0
  c9b697:	vmovdqu64 0x70(%rsp),%zmm1
  c9b6a2:	vmovdqa64 -0x7c06ac(%rip),%zmm5        # 4db000 <check_builtin_atomic_rmw_test_clang.native_source+0xa4f0>
  c9b6ac:	vpbroadcastd -0x6d5252(%rip),%zmm6        # 5c6464 <unwind_tier0_test_terminal.ids+0x4c4>
  c9b6b6:	vpbroadcastq -0x6d5dd8(%rip),%zmm7        # 5c58e8 <check_mutation_families+0xadc>
  c9b6c0:	vmovdqa64 -0x7c068a(%rip),%zmm9        # 4db040 <check_builtin_atomic_rmw_test_clang.native_source+0xa530>
  c9b6ca:	mov    %r8,%r10
  c9b6cd:	or     %r9,%r10
  c9b6d0:	vpbroadcastd %edi,%zmm4
  c9b6d6:	mov    $0xffff,%esi
  c9b6db:	xor    %ecx,%ecx
  c9b6dd:	vpxor  %xmm8,%xmm8,%xmm8
  c9b6e2:	xor    %ebx,%ebx
  c9b6e4:	vpbroadcastd %eax,%zmm2
  c9b6ea:	mov    0x28(%rsp),%rax
  c9b6ef:	add    %r11d,%eax
  c9b6f2:	vpbroadcastd %eax,%zmm3
  c9b6f8:	mov    $0xffffffffffffffff,%rax
  c9b6ff:	jmp    c9b7a8 <tier0_assign_homes+0x1608>
  c9b704:	data16 data16 cs nopw 0x0(%rax,%rax,1)
  c9b710:	vpcmpltud %zmm2,%zmm10,%k0
  c9b717:	vpcmpltud %zmm3,%zmm10,%k1
  c9b71e:	kmovd  %k0,%ebx
  c9b722:	vpcmpnleud %zmm6,%zmm11,%k0{%k1}
  c9b729:	vpermd %zmm0,%zmm10,%zmm11
  c9b72f:	kmovd  %k0,%ebp
  c9b733:	vpcmpltud %zmm4,%zmm10,%k0
  c9b73a:	and    %r11d,%ebx
  c9b73d:	kmovd  %k0,%r12d
  c9b741:	xor    %ebx,%r11d
  c9b744:	and    %edi,%r12d
  c9b747:	and    %r11d,%ebp
  c9b74a:	kmovd  %r12d,%k1
  c9b74f:	or     %r12d,%ebx
  c9b752:	movzwl %bp,%edi
  c9b755:	vpermd %zmm1,%zmm10,%zmm11{%k1}
  c9b75b:	or     %ebp,%ebx
  c9b75d:	popcnt %edi,%edi
  c9b761:	kmovd  %ebx,%k1
  c9b765:	shr    $0x8,%ebx
  c9b768:	add    %edi,%ecx
  c9b76a:	vpmovzxdq %ymm11,%zmm10
  c9b770:	vpermt2d %zmm8,%zmm9,%zmm11
  c9b776:	vpsllq $0x20,%zmm10,%zmm10
  c9b77d:	vporq  %zmm7,%zmm10,%zmm10
  c9b783:	vporq  %zmm7,%zmm11,%zmm11
  c9b789:	vmovdqu64 %zmm10,(%r15,%rdx,8){%k1}
  c9b790:	kmovd  %ebx,%k1
  c9b794:	lea    0x10(%rdx),%ebx
  c9b797:	vmovdqu64 %zmm11,0x40(%r15,%rdx,8){%k1}
  c9b79f:	cmp    %r13d,%ebx
  c9b7a2:	jae    c9b854 <tier0_assign_homes+0x16b4>
  c9b7a8:	mov    %r13d,%edx
  c9b7ab:	sub    %ebx,%edx
  c9b7ad:	shrx   %rbx,%r8,%r11
  c9b7b2:	shrx   %rbx,%r9,%rdi
  c9b7b7:	vpxor  %xmm10,%xmm10,%xmm10
  c9b7bc:	shlx   %rdx,%rax,%r12
  c9b7c1:	cmp    $0x40,%edx
  c9b7c4:	mov    %ebx,%edx
  c9b7c6:	not    %r12d
  c9b7c9:	cmovae %esi,%r12d
  c9b7cd:	kmovd  %r12d,%k1
  c9b7d2:	vmovdqu32 (%r14,%rdx,4),%zmm11{%k1}{z}
  c9b7d9:	test   %r10,%r10
  c9b7dc:	je     c9b710 <tier0_assign_homes+0x1570>
  c9b7e2:	vpbroadcastd %ebx,%zmm10
  c9b7e8:	mov    %r10,%rbx
  c9b7eb:	vpord  %zmm5,%zmm10,%zmm12
  c9b7f1:	vpxor  %xmm10,%xmm10,%xmm10
  c9b7f6:	cs nopw 0x0(%rax,%rax,1)
  c9b800:	tzcnt  %rbx,%r12
  c9b805:	mov    %edi,%ebp
  c9b807:	vpbroadcastd (%r14,%r12,4),%zmm13
  c9b80e:	vpbroadcastd %r12d,%zmm14
  c9b814:	bt     %r12,%r9
  c9b818:	vpcmpnleud %zmm14,%zmm12,%k2
  c9b81f:	cmovae %r11d,%ebp
  c9b823:	blsr   %rbx,%rbx
  c9b828:	kmovd  %ebp,%k0
  c9b82c:	vpcmpnleud %zmm11,%zmm13,%k1
  c9b833:	vpcmpeqd %zmm11,%zmm13,%k2{%k2}
  c9b839:	korw   %k2,%k1,%k1
  c9b83d:	kandw  %k0,%k1,%k0
  c9b841:	vpmovm2d %k0,%zmm13
  c9b847:	vpsubd %zmm13,%zmm10,%zmm10
  c9b84d:	jne    c9b800 <tier0_assign_homes+0x1660>
  c9b84f:	jmp    c9b710 <tier0_assign_homes+0x1570>
  c9b854:	mov    %ecx,%eax
  c9b856:	mov    0xb0(%rsp,%rax,4),%eax
  c9b85d:	mov    0x18(%rsp),%rcx
  c9b862:	or     %eax,0x4(%rcx)
  c9b865:	mov    0x18(%rsp),%rdi
  c9b86a:	mov    $0x103,%ecx
  c9b86f:	mov    0x3c(%rdi),%eax
  c9b872:	bextr  %ecx,%eax,%ecx
  c9b877:	mov    %eax,%edx
  c9b879:	shr    $0xa,%eax
  c9b87c:	shr    $0x4,%edx
  c9b87f:	or     0x4(%rdi),%ecx
  c9b882:	mov    %eax,%esi
  c9b884:	and    $0x2,%edx
  c9b887:	and    $0x4,%esi
  c9b88a:	mov    %eax,%r9d
  c9b88d:	and    $0x8,%r9d
  c9b891:	mov    %eax,%r8d
  c9b894:	and    $0x10,%r8d
  c9b898:	and    $0x20,%eax
  c9b89b:	or     %edx,%esi
  c9b89d:	or     %esi,%r9d
  c9b8a0:	or     %r9d,%r8d
  c9b8a3:	or     %ecx,%r8d
  c9b8a6:	movzbl 0x5a(%rdi),%ecx
  c9b8aa:	shl    $0x5,%ecx
  c9b8ad:	or     %eax,%ecx
  c9b8af:	or     %r8d,%ecx
  c9b8b2:	mov    %ecx,0x4(%rdi)
  c9b8b5:	popcnt %ecx,%eax
  c9b8b9:	movzbl 0x59(%rdi),%ecx
  c9b8bd:	add    %eax,%ecx
  c9b8bf:	mov    %ecx,0x8(%rdi)
  c9b8c2:	mov    %fs:0x28,%rax
  c9b8cb:	cmp    0x110(%rsp),%rax
  c9b8d3:	jne    c9b8ea <tier0_assign_homes+0x174a>
  c9b8d5:	add    $0x118,%rsp
  c9b8dc:	pop    %rbx
  c9b8dd:	pop    %r12
  c9b8df:	pop    %r13
  c9b8e1:	pop    %r14
  c9b8e3:	pop    %r15
  c9b8e5:	pop    %rbp
  c9b8e6:	vzeroupper
  c9b8e9:	ret
  c9b8ea:	vzeroupper
  c9b8ed:	call   7e58a0 <__stack_chk_fail@plt>
