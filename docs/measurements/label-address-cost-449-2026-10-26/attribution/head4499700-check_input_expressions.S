
../campaign/native-images/head449/build/compiler:     file format elf64-x86-64


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

0000000001089270 <check_input_expressions>:
 1089270:	push   %rbp
 1089271:	push   %r15
 1089273:	push   %r14
 1089275:	push   %r13
 1089277:	push   %r12
 1089279:	push   %rbx
 108927a:	sub    $0x168,%rsp
 1089281:	mov    %fs:0x28,%rax
 108928a:	mov    %rax,0x160(%rsp)
 1089292:	mov    0x8(%rdi),%r9
 1089296:	cmpl   $0x0,0x30(%r9)
 108929b:	je     108eb45 <check_input_expressions+0x58d5>
 10892a1:	vpmovsxbq -0xbeb62a(%rip),%xmm3        # 49dc80 <cbuiltin_test_generated.edges+0x3e40>
 10892aa:	mov    (%rdi),%rax
 10892ad:	mov    $0xffffffff,%r11d
 10892b3:	mov    %rdi,%r12
 10892b6:	vxorps %xmm2,%xmm2,%xmm2
 10892ba:	xor    %edx,%edx
 10892bc:	mov    %r9,0x10(%rsp)
 10892c1:	mov    %rax,0x68(%rsp)
 10892c6:	lea    0x30(%r9),%rax
 10892ca:	mov    %rax,0x70(%rsp)
 10892cf:	jmp    10892fb <check_input_expressions+0x8b>
 10892d1:	movb   $0x1,0x3c5(%r13)
 10892d9:	nopl   0x0(%rax)
 10892e0:	mov    0x70(%rsp),%rax
 10892e5:	mov    0xb8(%rsp),%rdx
 10892ed:	mov    (%rax),%eax
 10892ef:	inc    %rdx
 10892f2:	cmp    %rax,%rdx
 10892f5:	jae    108eb45 <check_input_expressions+0x58d5>
 10892fb:	mov    (%r12),%rax
 10892ff:	cmpb   $0x1,0x3c5(%rax)
 1089306:	je     108eb45 <check_input_expressions+0x58d5>
 108930c:	mov    0x68(%r9),%rcx
 1089310:	mov    0x8(%r12),%rsi
 1089315:	mov    %rdx,0xb8(%rsp)
 108931d:	mov    (%rcx,%rdx,4),%edx
 1089320:	mov    0x50(%rsi),%rcx
 1089324:	cmpb   $0x49,(%rcx,%rdx,1)
 1089328:	mov    %edx,%ecx
 108932a:	je     1089337 <check_input_expressions+0xc7>
 108932c:	mov    0x368(%r12),%rcx
 1089334:	mov    (%rcx,%rdx,4),%ecx
 1089337:	mov    %rdx,0x8(%rsp)
 108933c:	inc    %ecx
 108933e:	cmp    0x3d0(%r12),%ecx
 1089346:	ja     10892e0 <check_input_expressions+0x70>
 1089348:	mov    0x1f0(%rax),%rax
 108934f:	test   %rax,%rax
 1089352:	je     108935f <check_input_expressions+0xef>
 1089354:	mov    0x8(%rsp),%rcx
 1089359:	cmpb   $0x0,(%rax,%rcx,1)
 108935d:	jne    10892e0 <check_input_expressions+0x70>
 108935f:	mov    0x10(%r9),%rax
 1089363:	mov    0x8(%rsp),%r14
 1089368:	mov    0x50(%r9),%rcx
 108936c:	movzbl (%rax,%r14,1),%edi
 1089371:	mov    0x370(%r12),%rax
 1089379:	movzbl (%rcx,%r14,1),%r15d
 108937e:	mov    (%rax,%r14,4),%eax
 1089382:	cmp    $0xffffffff,%eax
 1089385:	je     1089457 <check_input_expressions+0x1e7>
 108938b:	mov    $0xffffffff,%r8d
 1089391:	mov    $0xffffffff,%ebx
 1089396:	xor    %ebp,%ebp
 1089398:	jmp    10893b2 <check_input_expressions+0x142>
 108939a:	nopw   0x0(%rax,%rax,1)
 10893a0:	mov    %eax,%eax
 10893a2:	mov    0x378(%r12),%rcx
 10893aa:	mov    (%rcx,%rax,4),%eax
 10893ad:	cmp    $0xffffffff,%eax
 10893b0:	je     1089421 <check_input_expressions+0x1b1>
 10893b2:	cmp    %r14d,%eax
 10893b5:	jae    10893c6 <check_input_expressions+0x156>
 10893b7:	mov    0xb8(%r12),%rcx
 10893bf:	cmpq   $0x0,(%rcx,%r14,8)
 10893c4:	jne    10893a0 <check_input_expressions+0x130>
 10893c6:	mov    0x380(%r12),%rcx
 10893ce:	mov    %eax,%eax
 10893d0:	mov    (%rcx,%rax,4),%ecx
 10893d3:	cmp    $0xffffffff,%ecx
 10893d6:	je     10893a2 <check_input_expressions+0x132>
 10893d8:	mov    %ecx,%edx
 10893da:	cmp    $0xffffffff,%ebx
 10893dd:	je     10893ef <check_input_expressions+0x17f>
 10893df:	mov    0x390(%r12),%rdx
 10893e7:	mov    %ebx,%esi
 10893e9:	mov    %ecx,(%rdx,%rsi,4)
 10893ec:	mov    %r8d,%edx
 10893ef:	mov    0x388(%r12),%r8
 10893f7:	mov    0x390(%r12),%rsi
 10893ff:	mov    (%r8,%rax,4),%ebx
 1089403:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1089410:	mov    %ecx,%ecx
 1089412:	mov    (%rsi,%rcx,4),%ecx
 1089415:	inc    %ebp
 1089417:	cmp    $0xffffffff,%ecx
 108941a:	jne    1089410 <check_input_expressions+0x1a0>
 108941c:	mov    %edx,%r8d
 108941f:	jmp    10893a2 <check_input_expressions+0x132>
 1089421:	mov    $0xffffffff,%esi
 1089426:	cmp    $0xffffffff,%r8d
 108942a:	je     1089481 <check_input_expressions+0x211>
 108942c:	mov    0x390(%r12),%rcx
 1089434:	mov    %r8d,%eax
 1089437:	mov    $0x1,%r10b
 108943a:	mov    (%rcx,%rax,4),%eax
 108943d:	cmp    %r11,%rax
 1089440:	je     108948a <check_input_expressions+0x21a>
 1089442:	mov    (%rcx,%rax,4),%edx
 1089445:	mov    %eax,%esi
 1089447:	mov    %r15,0x38(%rsp)
 108944c:	cmp    $0x3b,%r15b
 1089450:	je     108949e <check_input_expressions+0x22e>
 1089452:	jmp    10895a0 <check_input_expressions+0x330>
 1089457:	xor    %r10d,%r10d
 108945a:	mov    $0xffffffff,%r8d
 1089460:	mov    $0xffffffff,%ebx
 1089465:	xor    %ebp,%ebp
 1089467:	mov    $0xffffffff,%esi
 108946c:	mov    $0xffffffff,%edx
 1089471:	mov    %r15,0x38(%rsp)
 1089476:	cmp    $0x3b,%r15b
 108947a:	je     108949e <check_input_expressions+0x22e>
 108947c:	jmp    10895a0 <check_input_expressions+0x330>
 1089481:	xor    %r10d,%r10d
 1089484:	mov    $0xffffffff,%r8d
 108948a:	mov    $0xffffffff,%edx
 108948f:	mov    %r15,0x38(%rsp)
 1089494:	cmp    $0x3b,%r15b
 1089498:	jne    10895a0 <check_input_expressions+0x330>
 108949e:	mov    (%r12),%r13
 10894a2:	mov    0x320(%r13),%rax
 10894a9:	mov    (%rax,%r14,4),%eax
 10894ad:	test   %eax,%eax
 10894af:	je     10895a0 <check_input_expressions+0x330>
 10894b5:	mov    0x318(%r13),%rcx
 10894bc:	dec    %eax
 10894be:	mov    %ebx,0xa0(%rsp)
 10894c5:	lea    (%rax,%rax,2),%rax
 10894c9:	cmpl   $0xffffffff,0x10(%rcx,%rax,8)
 10894ce:	lea    (%rcx,%rax,8),%rbx
 10894d2:	je     10897fe <check_input_expressions+0x58e>
 10894d8:	mov    0x28(%r12),%rcx
 10894dd:	lea    0x110(%rsp),%rsi
 10894e5:	mov    (%rbx),%edx
 10894e7:	vpxor  %xmm0,%xmm0,%xmm0
 10894eb:	mov    %r8d,0x4(%rsp)
 10894f0:	mov    0x8(%rcx),%rax
 10894f4:	mov    %rax,0x78(%rsp)
 10894f9:	mov    0x4(%rbx),%eax
 10894fc:	vmovdqu64 %zmm0,(%rsi)
 1089502:	mov    %r12,0x100(%rsp)
 108950a:	mov    %rbx,0x108(%rsp)
 1089512:	mov    0x138(%r13),%esi
 1089519:	mov    %esi,0x138(%rsp)
 1089520:	cmp    %eax,%edx
 1089522:	jae    1089721 <check_input_expressions+0x4b1>
 1089528:	cmp    0x364(%r13),%eax
 108952f:	jae    1089721 <check_input_expressions+0x4b1>
 1089535:	sub    %rdx,%rax
 1089538:	lea    0x8(,%rax,8),%rdx
 1089540:	shr    $0x20,%rdx
 1089544:	jne    1089721 <check_input_expressions+0x4b1>
 108954a:	cmpq   $0x0,0x278(%r12)
 1089553:	je     1089721 <check_input_expressions+0x4b1>
 1089559:	mov    0x128(%r13),%edx
 1089560:	cmp    0x12c(%r13),%edx
 1089567:	jae    1089721 <check_input_expressions+0x4b1>
 108956d:	lea    0x9(,%rax,8),%rdx
 1089575:	mov    %edx,0x144(%rsp)
 108957c:	mov    (%rcx),%r8
 108957f:	mov    0x8(%rcx),%rdi
 1089583:	lea    0x3(%rdi,%r8,1),%rsi
 1089588:	add    %r8,%rdi
 108958b:	and    $0xfffffffffffffffc,%rsi
 108958f:	cmp    %rdi,%rsi
 1089592:	jae    108b822 <check_input_expressions+0x25b2>
 1089598:	xor    %esi,%esi
 108959a:	jmp    108b851 <check_input_expressions+0x25e1>
 108959f:	nop
 10895a0:	mov    0x1c0(%r12),%rax
 10895a8:	cmpl   $0x0,(%rax,%r14,4)
 10895ad:	je     1089657 <check_input_expressions+0x3e7>
 10895b3:	mov    $0xffffffff,%ecx
 10895b8:	mov    $0xffffffff,%r8d
 10895be:	mov    $0xffffffff,%r9d
 10895c4:	mov    %r12,%rdi
 10895c7:	xor    %esi,%esi
 10895c9:	mov    %r14d,%edx
 10895cc:	vzeroupper
 10895cf:	call   10fb220 <check_input_add>
 10895d4:	vpmovsxbq -0xbeb95d(%rip),%xmm3        # 49dc80 <cbuiltin_test_generated.edges+0x3e40>
 10895dd:	mov    0x10(%rsp),%r9
 10895e2:	mov    $0xffffffff,%r11d
 10895e8:	vxorps %xmm2,%xmm2,%xmm2
 10895ec:	cmp    $0xffffffff,%eax
 10895ef:	je     10892e0 <check_input_expressions+0x70>
 10895f5:	mov    0x1c0(%r12),%rdx
 10895fd:	mov    0x8(%rsp),%rsi
 1089602:	mov    %eax,%r15d
 1089605:	mov    0x68(%rsp),%rax
 108960a:	mov    %r15d,%ecx
 108960d:	lea    (%rcx,%rcx,2),%rcx
 1089611:	shl    $0x5,%rcx
 1089615:	mov    (%rdx,%rsi,4),%edx
 1089618:	mov    0x1b8(%r12),%rsi
 1089620:	mov    0x28(%rax),%rax
 1089624:	dec    %edx
 1089626:	lea    (%rdx,%rdx,2),%rdx
 108962a:	shl    $0x5,%rdx
 108962e:	vmovdqu64 (%rsi,%rdx,1),%zmm0
 1089635:	vmovups 0x20(%rsi,%rdx,1),%zmm1
 1089640:	vmovups %zmm1,0x20(%rax,%rcx,1)
 108964b:	vmovdqu64 %zmm0,(%rax,%rcx,1)
 1089652:	jmp    108e19f <check_input_expressions+0x4f2f>
 1089657:	mov    0x1a0(%r12),%rax
 108965f:	mov    %ebx,0xa0(%rsp)
 1089666:	mov    (%rax,%r14,4),%eax
 108966a:	cmp    %r11,%rax
 108966d:	je     1089898 <check_input_expressions+0x628>
 1089673:	mov    (%r12),%rcx
 1089677:	mov    0x2c0(%rcx),%rcx
 108967e:	mov    (%rcx,%rax,4),%ecx
 1089681:	cmp    $0xffffffff,%ecx
 1089684:	je     108e17c <check_input_expressions+0x4f0c>
 108968a:	mov    %r8d,%ebx
 108968d:	mov    $0x34,%esi
 1089692:	mov    $0xffffffff,%r8d
 1089698:	mov    $0xffffffff,%r9d
 108969e:	mov    %r12,%rdi
 10896a1:	mov    %r14d,%edx
 10896a4:	vzeroupper
 10896a7:	call   10fb220 <check_input_add>
 10896ac:	vpmovsxbq -0xbeba35(%rip),%xmm3        # 49dc80 <cbuiltin_test_generated.edges+0x3e40>
 10896b5:	mov    0x10(%rsp),%r9
 10896ba:	mov    %ebx,%r8d
 10896bd:	mov    $0xffffffff,%r11d
 10896c3:	vxorps %xmm2,%xmm2,%xmm2
 10896c7:	mov    %eax,%r15d
 10896ca:	xor    %esi,%esi
 10896cc:	cmp    $0xffffffff,%r15d
 10896d0:	jne    108e19f <check_input_expressions+0x4f2f>
 10896d6:	test   %sil,%sil
 10896d9:	je     10892e0 <check_input_expressions+0x70>
 10896df:	mov    (%r12),%r13
 10896e3:	mov    0x2c0(%r13),%rcx
 10896ea:	mov    0x8(%rsp),%rdx
 10896ef:	cmp    $0x1,%ebp
 10896f2:	mov    $0xffffffff,%eax
 10896f7:	cmove  %r8d,%eax
 10896fb:	mov    %eax,(%rcx,%rdx,4)
 10896fe:	mov    0xa0(%rsp),%ecx
 1089705:	mov    0x380(%r12),%rax
 108970d:	mov    %r8d,(%rax,%rdx,4)
 1089711:	mov    0x388(%r12),%rax
 1089719:	mov    %ecx,(%rax,%rdx,4)
 108971c:	jmp    10892e0 <check_input_expressions+0x70>
 1089721:	lea    0x110(%rsp),%rax
 1089729:	vpxor  %xmm0,%xmm0,%xmm0
 108972d:	mov    $0x1,%sil
 1089730:	xor    %edx,%edx
 1089732:	xor    %edi,%edi
 1089734:	vmovdqu %ymm0,(%rax)
 1089738:	mov    %rdi,0x130(%rsp)
 1089740:	mov    0x110(%rsp),%rax
 1089748:	test   %rax,%rax
 108974b:	sete   %cl
 108974e:	cmpq   $0x0,0x118(%rsp)
 1089757:	sete   %r8b
 108975b:	or     %cl,%r8b
 108975e:	cmpq   $0x0,0x120(%rsp)
 1089767:	sete   %cl
 108976a:	test   %rdx,%rdx
 108976d:	sete   %dl
 1089770:	or     %cl,%dl
 1089772:	or     %r8b,%dl
 1089775:	test   %rdi,%rdi
 1089778:	sete   %cl
 108977b:	or     %sil,%cl
 108977e:	mov    (%r12),%rsi
 1089782:	or     %dl,%cl
 1089784:	or     %cl,0x3c5(%rsi)
 108978a:	mov    0x13c(%rsp),%edx
 1089791:	test   %cl,%cl
 1089793:	je     108979d <check_input_expressions+0x52d>
 1089795:	mov    %edx,%r14d
 1089798:	jmp    1089eea <check_input_expressions+0xc7a>
 108979d:	mov    0x108(%rsp),%rcx
 10897a5:	mov    0x8(%r12),%r15
 10897aa:	mov    (%rcx),%esi
 10897ac:	mov    0x8(%rcx),%ecx
 10897af:	mov    %esi,0x30(%rsp)
 10897b3:	cmp    $0xffffffff,%ecx
 10897b6:	je     10899d8 <check_input_expressions+0x768>
 10897bc:	cmp    0x144(%rsp),%edx
 10897c3:	jae    10899cd <check_input_expressions+0x75d>
 10897c9:	vpmovsxbq -0xbebb50(%rip),%xmm0        # 49dc82 <cbuiltin_test_generated.edges+0x3e42>
 10897d2:	mov    %edx,%esi
 10897d4:	inc    %esi
 10897d6:	shl    $0x5,%rdx
 10897da:	mov    %esi,0x13c(%rsp)
 10897e1:	vpinsrd $0x1,%ecx,%xmm0,%xmm0
 10897e7:	vmovdqu %xmm0,(%rax,%rdx,1)
 10897ec:	vmovups %xmm2,0x10(%rax,%rdx,1)
 10897f2:	mov    0x13c(%rsp),%edx
 10897f9:	jmp    10899d8 <check_input_expressions+0x768>
 10897fe:	mov    %r14d,%edx
 1089801:	mov    %rbx,%r14
 1089804:	mov    %r8d,%ebx
 1089807:	mov    $0xffffffff,%ecx
 108980c:	mov    $0xffffffff,%r8d
 1089812:	mov    $0xffffffff,%r9d
 1089818:	mov    %r12,%rdi
 108981b:	xor    %esi,%esi
 108981d:	vzeroupper
 1089820:	call   10fb220 <check_input_add>
 1089825:	vpmovsxbq -0xbebbae(%rip),%xmm3        # 49dc80 <cbuiltin_test_generated.edges+0x3e40>
 108982e:	mov    0x10(%rsp),%r9
 1089833:	mov    $0xffffffff,%r11d
 1089839:	vxorps %xmm2,%xmm2,%xmm2
 108983d:	mov    %eax,0x10(%r14)
 1089841:	cmp    $0xffffffff,%eax
 1089844:	je     10892e0 <check_input_expressions+0x70>
 108984a:	mov    0x68(%rsp),%rcx
 108984f:	mov    %eax,%eax
 1089851:	lea    (%rax,%rax,2),%rax
 1089855:	vpxor  %xmm0,%xmm0,%xmm0
 1089859:	mov    %ebx,%r8d
 108985c:	mov    %r14,%rbx
 108985f:	shl    $0x5,%rax
 1089863:	mov    0x28(%rcx),%rcx
 1089867:	movl   $0x8,(%rcx,%rax,1)
 108986e:	vmovdqu64 %zmm0,0x4(%rcx,%rax,1)
 1089879:	vmovdqu64 %zmm0,0x20(%rcx,%rax,1)
 1089884:	cmpl   $0xffffffff,0x10(%r14)
 1089889:	je     10892e0 <check_input_expressions+0x70>
 108988f:	mov    (%r12),%r13
 1089893:	jmp    10894d8 <check_input_expressions+0x268>
 1089898:	mov    0x230(%r12),%rax
 10898a0:	mov    $0x1,%r13b
 10898a3:	mov    %r10d,0x40(%rsp)
 10898a8:	cmpl   $0x0,(%rax,%r14,4)
 10898ad:	je     10899e0 <check_input_expressions+0x770>
 10898b3:	mov    $0x38,%eax
 10898b8:	movl   $0x0,0x28(%rsp)
 10898c0:	mov    $0xffffffff,%ecx
 10898c5:	cmp    $0x45,%eax
 10898c8:	je     108cd94 <check_input_expressions+0x3b24>
 10898ce:	test   %r13b,%r13b
 10898d1:	je     108cd94 <check_input_expressions+0x3b24>
 10898d7:	mov    %rax,0x30(%rsp)
 10898dc:	mov    %r13d,0x58(%rsp)
 10898e1:	mov    %esi,0x18(%rsp)
 10898e5:	mov    %edx,0x24(%rsp)
 10898e9:	cmp    $0x1f,%eax
 10898ec:	jne    108b767 <check_input_expressions+0x24f7>
 10898f2:	mov    0xa8(%r12),%rax
 10898fa:	mov    %r10d,%ecx
 10898fd:	mov    %r8d,%r13d
 1089900:	cmpl   $0x0,(%rax,%r14,4)
 1089905:	setne  %al
 1089908:	xor    $0x1,%cl
 108990b:	or     %al,%cl
 108990d:	jne    108ba3b <check_input_expressions+0x27cb>
 1089913:	mov    0x68(%rsp),%rax
 1089918:	mov    %r13d,%ecx
 108991b:	mov    0x8(%rax),%rax
 108991f:	mov    (%rax,%rcx,4),%eax
 1089922:	mov    0x70(%rsp),%rcx
 1089927:	mov    (%rcx),%ecx
 1089929:	cmp    %ecx,%eax
 108992b:	jae    108ba3b <check_input_expressions+0x27cb>
 1089931:	mov    (%r12),%rdx
 1089935:	mov    0x238(%rdx),%rsi
 108993c:	mov    (%rsi,%rax,4),%eax
 108993f:	cmp    %ecx,%eax
 1089941:	jae    108ba3b <check_input_expressions+0x27cb>
 1089947:	mov    0x288(%rdx),%rcx
 108994e:	mov    (%rcx,%rax,8),%rcx
 1089952:	test   %rcx,%rcx
 1089955:	je     108ba3b <check_input_expressions+0x27cb>
 108995b:	movzbl 0x1c(%rcx),%r8d
 1089960:	test   %r8d,%r8d
 1089963:	je     108ba3b <check_input_expressions+0x27cb>
 1089969:	mov    0xa0(%r12),%rcx
 1089971:	mov    0x18(%r12),%rdi
 1089976:	dec    %r8d
 1089979:	mov    $0xf,%esi
 108997e:	mov    (%rcx,%rax,4),%ecx
 1089981:	mov    0x18(%rdi),%rax
 1089985:	mov    %ecx,%edx
 1089987:	shr    $0x3,%edx
 108998a:	movzbl (%rax,%rdx,1),%eax
 108998e:	cmp    %eax,%r8d
 1089991:	cmovbe %eax,%r8d
 1089995:	xor    %edx,%edx
 1089997:	vzeroupper
 108999a:	call   10a1d70 <type_derive>
 108999f:	test   %eax,%eax
 10899a1:	jne    10899bc <check_input_expressions+0x74c>
 10899a3:	mov    0x18(%r12),%rcx
 10899a8:	cmpl   $0x1,0x100(%rcx)
 10899af:	jne    10899bc <check_input_expressions+0x74c>
 10899b1:	mov    (%r12),%rcx
 10899b5:	movb   $0x1,0x3c5(%rcx)
 10899bc:	mov    0xa8(%r12),%rcx
 10899c4:	mov    %eax,(%rcx,%r14,4)
 10899c8:	jmp    108ba3b <check_input_expressions+0x27cb>
 10899cd:	mov    (%r12),%rax
 10899d1:	movb   $0x1,0x3c5(%rax)
 10899d8:	xor    %r14d,%r14d
 10899db:	jmp    1089acb <check_input_expressions+0x85b>
 10899e0:	mov    0x190(%r12),%rax
 10899e8:	mov    (%rax,%r14,4),%ebx
 10899ec:	test   %ebx,%ebx
 10899ee:	je     108b787 <check_input_expressions+0x2517>
 10899f4:	mov    $0xffffffff,%ecx
 10899f9:	mov    $0xffffffff,%r8d
 10899ff:	mov    $0xffffffff,%r9d
 1089a05:	mov    %r12,%rdi
 1089a08:	xor    %esi,%esi
 1089a0a:	mov    %r14d,%edx
 1089a0d:	vzeroupper
 1089a10:	call   10fb220 <check_input_add>
 1089a15:	vpmovsxbq -0xbebd9e(%rip),%xmm3        # 49dc80 <cbuiltin_test_generated.edges+0x3e40>
 1089a1e:	mov    0x10(%rsp),%r9
 1089a23:	mov    $0xffffffff,%r11d
 1089a29:	vxorps %xmm2,%xmm2,%xmm2
 1089a2d:	cmp    $0xffffffff,%eax
 1089a30:	je     10892e0 <check_input_expressions+0x70>
 1089a36:	mov    0x68(%rsp),%rcx
 1089a3b:	mov    0x180(%r12),%rdx
 1089a43:	vpmovsxbd -0xaddc04(%rip),%xmm0        # 5abe48 <link_program_emit_worker.forms+0x3d8>
 1089a4c:	dec    %ebx
 1089a4e:	mov    %eax,%r15d
 1089a51:	mov    0x28(%rcx),%rax
 1089a55:	mov    (%rdx,%rbx,8),%rdx
 1089a59:	mov    %r15d,%ecx
 1089a5c:	lea    (%rcx,%rcx,2),%rcx
 1089a60:	shl    $0x5,%rcx
 1089a64:	vmovdqa %xmm0,(%rax,%rcx,1)
 1089a69:	mov    %rdx,0x10(%rax,%rcx,1)
 1089a6e:	movq   $0x0,0x18(%rax,%rcx,1)
 1089a77:	fldz
 1089a79:	fld    %st(0)
 1089a7b:	fstpt  0x20(%rax,%rcx,1)
 1089a7f:	fstpt  0x30(%rax,%rcx,1)
 1089a83:	vpxor  %xmm0,%xmm0,%xmm0
 1089a87:	vmovdqu %ymm0,0x40(%rax,%rcx,1)
 1089a8d:	jmp    108e19f <check_input_expressions+0x4f2f>
 1089a92:	movb   $0x1,0x148(%rsp)
 1089a9a:	lea    0x100(%rsp),%rdi
 1089aa2:	mov    $0xffffffff,%ecx
 1089aa7:	mov    $0xffffffff,%r8d
 1089aad:	mov    %edx,%esi
 1089aaf:	vzeroupper
 1089ab2:	call   10fba70 <check_region_input_children>
 1089ab7:	vpmovsxbq -0xbebe40(%rip),%xmm3        # 49dc80 <cbuiltin_test_generated.edges+0x3e40>
 1089ac0:	vxorps %xmm2,%xmm2,%xmm2
 1089ac4:	mov    0x13c(%rsp),%edx
 1089acb:	test   %edx,%edx
 1089acd:	je     1089e33 <check_input_expressions+0xbc3>
 1089ad3:	mov    (%r12),%rsi
 1089ad7:	cmpb   $0x0,0x3c5(%rsi)
 1089ade:	jne    1089e30 <check_input_expressions+0xbc0>
 1089ae4:	mov    0x110(%rsp),%rdi
 1089aec:	mov    %edx,%eax
 1089aee:	dec    %eax
 1089af0:	mov    %rax,%rcx
 1089af3:	mov    %eax,0x13c(%rsp)
 1089afa:	shl    $0x5,%rcx
 1089afe:	mov    0x50(%r15),%r8
 1089b02:	mov    0x4(%rdi,%rcx,1),%edx
 1089b06:	movzbl (%r8,%rdx,1),%edi
 1089b0b:	lea    -0x1f(%rdi),%r8d
 1089b0f:	cmp    $0x2d,%r8d
 1089b13:	ja     1089c50 <check_input_expressions+0x9e0>
 1089b19:	movabs $0x200000000003,%r9
 1089b23:	bt     %r8,%r9
 1089b27:	jae    1089c50 <check_input_expressions+0x9e0>
 1089b2d:	mov    0x100(%rsp),%rsi
 1089b35:	mov    0x370(%rsi),%rdi
 1089b3c:	mov    (%rdi,%rdx,4),%edx
 1089b3f:	cmp    $0xffffffff,%edx
 1089b42:	jne    1089b94 <check_input_expressions+0x924>
 1089b44:	jmp    1089ac4 <check_input_expressions+0x854>
 1089b49:	nopl   0x0(%rax)
 1089b50:	mov    0x110(%rsp),%r9
 1089b58:	lea    0x1(%r8),%r10d
 1089b5c:	shl    $0x5,%r8
 1089b60:	mov    %r10d,0x13c(%rsp)
 1089b68:	movl   $0x0,(%r9,%r8,1)
 1089b70:	mov    %edx,0x4(%r9,%r8,1)
 1089b75:	movq   $0xffffffffffffffff,0x8(%r9,%r8,1)
 1089b7e:	vmovups %xmm2,0x10(%r9,%r8,1)
 1089b85:	mov    0x378(%rsi),%rdx
 1089b8c:	mov    (%rdx,%rdi,4),%edx
 1089b8f:	cmp    $0xffffffff,%edx
 1089b92:	je     1089be0 <check_input_expressions+0x970>
 1089b94:	mov    0x8(%rsi),%rdi
 1089b98:	mov    0x50(%rdi),%r8
 1089b9c:	mov    %edx,%edi
 1089b9e:	movzbl (%r8,%rdi,1),%r8d
 1089ba3:	add    $0xcd,%r8b
 1089ba7:	cmp    $0x2,%r8b
 1089bab:	jb     1089b85 <check_input_expressions+0x915>
 1089bad:	mov    0x13c(%rsp),%r8d
 1089bb5:	cmp    0x144(%rsp),%r8d
 1089bbd:	jb     1089b50 <check_input_expressions+0x8e0>
 1089bbf:	mov    0x100(%rsp),%rdx
 1089bc7:	mov    (%rdx),%rdx
 1089bca:	movb   $0x1,0x3c5(%rdx)
 1089bd1:	jmp    1089b85 <check_input_expressions+0x915>
 1089bd3:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1089be0:	mov    0x13c(%rsp),%edx
 1089be7:	cmp    %edx,%eax
 1089be9:	jae    1089acb <check_input_expressions+0x85b>
 1089bef:	mov    %rdx,%rsi
 1089bf2:	shl    $0x5,%rsi
 1089bf6:	dec    %rdx
 1089bf9:	add    $0xffffffffffffffe0,%rsi
 1089bfd:	nopl   (%rax)
 1089c00:	cmp    %rdx,%rax
 1089c03:	jae    1089ac4 <check_input_expressions+0x854>
 1089c09:	mov    0x110(%rsp),%rdi
 1089c11:	inc    %rax
 1089c14:	vmovups (%rdi,%rcx,1),%ymm0
 1089c19:	vmovups %ymm0,0xe0(%rsp)
 1089c22:	vmovups (%rdi,%rsi,1),%ymm0
 1089c27:	vmovups %ymm0,(%rdi,%rcx,1)
 1089c2c:	add    $0x20,%rcx
 1089c30:	vmovdqu 0xe0(%rsp),%ymm0
 1089c39:	vmovdqu %ymm0,(%rdi,%rsi,1)
 1089c3e:	add    $0xffffffffffffffe0,%rsi
 1089c42:	cmp    %rdx,%rax
 1089c45:	lea    -0x1(%rdx),%rdx
 1089c49:	jb     1089c00 <check_input_expressions+0x990>
 1089c4b:	jmp    1089ac4 <check_input_expressions+0x854>
 1089c50:	lea    -0x49(%rdi),%eax
 1089c53:	cmp    $0x1,%al
 1089c55:	ja     1089cb6 <check_input_expressions+0xa46>
 1089c57:	cmp    $0x49,%edi
 1089c5a:	jne    1089a9a <check_input_expressions+0x82a>
 1089c60:	mov    0x100(%rsp),%rax
 1089c68:	mov    0x370(%rax),%rcx
 1089c6f:	mov    (%rcx,%rdx,4),%edi
 1089c72:	cmp    $0xffffffff,%edi
 1089c75:	je     1089a9a <check_input_expressions+0x82a>
 1089c7b:	mov    0x378(%rax),%rsi
 1089c82:	mov    $0xffffffff,%ecx
 1089c87:	jmp    1089c9d <check_input_expressions+0xa2d>
 1089c89:	nopl   0x0(%rax)
 1089c90:	mov    (%rsi,%r8,4),%edi
 1089c94:	cmp    $0xffffffff,%edi
 1089c97:	je     1089d54 <check_input_expressions+0xae4>
 1089c9d:	mov    %edi,%r8d
 1089ca0:	cmp    %edx,%edi
 1089ca2:	jae    1089c90 <check_input_expressions+0xa20>
 1089ca4:	mov    0x8(%rax),%r9
 1089ca8:	mov    0x50(%r9),%r9
 1089cac:	cmpb   $0x6,(%r9,%r8,1)
 1089cb1:	cmove  %edi,%ecx
 1089cb4:	jmp    1089c90 <check_input_expressions+0xa20>
 1089cb6:	cmp    $0x53,%edi
 1089cb9:	je     1089d87 <check_input_expressions+0xb17>
 1089cbf:	cmp    $0x21,%edi
 1089cc2:	je     1089a9a <check_input_expressions+0x82a>
 1089cc8:	cmp    $0x1e,%edi
 1089ccb:	jne    1089ac4 <check_input_expressions+0x854>
 1089cd1:	mov    0x370(%r12),%rax
 1089cd9:	mov    (%rax,%rdx,4),%eax
 1089cdc:	jmp    1089cfd <check_input_expressions+0xa8d>
 1089cde:	xchg   %ax,%ax
 1089ce0:	mov    0x100(%rsp),%rax
 1089ce8:	mov    (%rax),%rax
 1089ceb:	movb   $0x1,0x3c5(%rax)
 1089cf2:	mov    0x378(%r12),%rax
 1089cfa:	mov    (%rax,%rcx,4),%eax
 1089cfd:	cmp    $0xffffffff,%eax
 1089d00:	je     1089ac4 <check_input_expressions+0x854>
 1089d06:	mov    0x50(%r15),%rdx
 1089d0a:	mov    %eax,%ecx
 1089d0c:	cmpb   $0x20,(%rdx,%rcx,1)
 1089d10:	jne    1089cf2 <check_input_expressions+0xa82>
 1089d12:	mov    0x13c(%rsp),%edx
 1089d19:	cmp    0x144(%rsp),%edx
 1089d20:	jae    1089ce0 <check_input_expressions+0xa70>
 1089d22:	mov    0x110(%rsp),%rsi
 1089d2a:	lea    0x1(%rdx),%edi
 1089d2d:	shl    $0x5,%rdx
 1089d31:	mov    %edi,0x13c(%rsp)
 1089d38:	movl   $0x0,(%rsi,%rdx,1)
 1089d3f:	mov    %eax,0x4(%rsi,%rdx,1)
 1089d43:	movq   $0xffffffffffffffff,0x8(%rsi,%rdx,1)
 1089d4c:	vmovups %xmm2,0x10(%rsi,%rdx,1)
 1089d52:	jmp    1089cf2 <check_input_expressions+0xa82>
 1089d54:	cmp    $0xffffffff,%ecx
 1089d57:	je     1089a9a <check_input_expressions+0x82a>
 1089d5d:	mov    0x10(%r15),%rax
 1089d61:	mov    %ecx,%ecx
 1089d63:	cmpb   $0x49,(%rax,%rcx,1)
 1089d67:	jne    1089a9a <check_input_expressions+0x82a>
 1089d6d:	mov    %edx,%ecx
 1089d6f:	mov    0x128(%rsp),%rax
 1089d77:	sub    0x30(%rsp),%ecx
 1089d7b:	movl   $0xffffffff,(%rax,%rcx,4)
 1089d82:	jmp    1089a9a <check_input_expressions+0x82a>
 1089d87:	mov    0x2f8(%rsi),%rax
 1089d8e:	mov    (%rax,%rdx,4),%ecx
 1089d91:	mov    %ecx,%eax
 1089d93:	sub    0x30(%rsp),%eax
 1089d97:	jbe    1089a92 <check_input_expressions+0x822>
 1089d9d:	mov    0x108(%rsp),%rdi
 1089da5:	cmp    0x4(%rdi),%ecx
 1089da8:	jae    1089a92 <check_input_expressions+0x822>
 1089dae:	mov    0x310(%rsi),%rcx
 1089db5:	cmpl   $0xffffffff,(%rcx,%rdx,4)
 1089db9:	jne    1089a92 <check_input_expressions+0x822>
 1089dbf:	mov    0x140(%rsp),%ecx
 1089dc6:	cmp    0x144(%rsp),%ecx
 1089dcd:	jae    1089de7 <check_input_expressions+0xb77>
 1089dcf:	mov    0x118(%rsp),%rsi
 1089dd7:	movl   $0xffffffff,(%rsi,%rcx,4)
 1089dde:	incl   0x140(%rsp)
 1089de5:	jmp    1089df9 <check_input_expressions+0xb89>
 1089de7:	mov    0x100(%rsp),%rsi
 1089def:	mov    (%rsi),%rsi
 1089df2:	movb   $0x1,0x3c5(%rsi)
 1089df9:	mov    %edx,%edi
 1089dfb:	mov    0x120(%rsp),%rsi
 1089e03:	sub    0x30(%rsp),%edi
 1089e07:	mov    %ecx,(%rsi,%rdi,4)
 1089e0a:	mov    0x128(%rsp),%rcx
 1089e12:	mov    0x130(%rsp),%rsi
 1089e1a:	mov    (%rcx,%rax,4),%ecx
 1089e1d:	mov    %ecx,(%rsi,%rdi,4)
 1089e20:	mov    0x128(%rsp),%rcx
 1089e28:	mov    %edx,(%rcx,%rax,4)
 1089e2b:	jmp    1089a9a <check_input_expressions+0x82a>
 1089e30:	mov    %edx,%r14d
 1089e33:	cmp    0x144(%rsp),%r14d
 1089e3b:	jae    1089e76 <check_input_expressions+0xc06>
 1089e3d:	vmovdqa -0xb0d525(%rip),%ymm0        # 57c920 <static_test_starved.starved+0xd80>
 1089e45:	mov    0x110(%rsp),%rax
 1089e4d:	lea    0x1(%r14),%ecx
 1089e51:	mov    %ecx,0x13c(%rsp)
 1089e58:	mov    %r14d,%ecx
 1089e5b:	shl    $0x5,%rcx
 1089e5f:	vmovdqu %ymm0,(%rax,%rcx,1)
 1089e64:	mov    0x13c(%rsp),%r14d
 1089e6c:	mov    0x8(%rbx),%eax
 1089e6f:	cmp    $0xffffffff,%eax
 1089e72:	jne    1089e90 <check_input_expressions+0xc20>
 1089e74:	jmp    1089eea <check_input_expressions+0xc7a>
 1089e76:	mov    0x100(%rsp),%rax
 1089e7e:	mov    (%rax),%rax
 1089e81:	movb   $0x1,0x3c5(%rax)
 1089e88:	mov    0x8(%rbx),%eax
 1089e8b:	cmp    $0xffffffff,%eax
 1089e8e:	je     1089eea <check_input_expressions+0xc7a>
 1089e90:	cmp    0x144(%rsp),%r14d
 1089e98:	jae    1089ed8 <check_input_expressions+0xc68>
 1089e9a:	vpmovsxbq -0xbec221(%rip),%xmm0        # 49dc82 <cbuiltin_test_generated.edges+0x3e42>
 1089ea3:	mov    0x110(%rsp),%rcx
 1089eab:	lea    0x1(%r14),%edx
 1089eaf:	mov    %edx,0x13c(%rsp)
 1089eb6:	mov    %r14d,%edx
 1089eb9:	shl    $0x5,%rdx
 1089ebd:	vpinsrd $0x1,%eax,%xmm0,%xmm0
 1089ec3:	vmovdqu %xmm0,(%rcx,%rdx,1)
 1089ec8:	vmovups %xmm2,0x10(%rcx,%rdx,1)
 1089ece:	mov    0x13c(%rsp),%r14d
 1089ed6:	jmp    1089eea <check_input_expressions+0xc7a>
 1089ed8:	mov    0x100(%rsp),%rax
 1089ee0:	mov    (%rax),%rax
 1089ee3:	movb   $0x1,0x3c5(%rax)
 1089eea:	movzbl 0x148(%rsp),%eax
 1089ef2:	test   %r14d,%r14d
 1089ef5:	mov    %rbx,0x30(%rsp)
 1089efa:	sete   %cl
 1089efd:	or     %al,%cl
 1089eff:	test   $0x1,%cl
 1089f02:	je     1089f60 <check_input_expressions+0xcf0>
 1089f04:	test   $0x1,%al
 1089f06:	je     108b5bb <check_input_expressions+0x234b>
 1089f0c:	mov    (%r12),%rax
 1089f10:	cmpb   $0x0,0x3c5(%rax)
 1089f17:	jne    108b5bb <check_input_expressions+0x234b>
 1089f1d:	mov    0x138(%rsp),%eax
 1089f24:	mov    %eax,0x138(%r13)
 1089f2b:	cmp    0x13c(%r13),%eax
 1089f32:	jae    108b5b0 <check_input_expressions+0x2340>
 1089f38:	vpmovsxbd -0xade0f5(%rip),%xmm0        # 5abe4c <link_program_emit_worker.forms+0x3dc>
 1089f41:	mov    0x130(%r13),%rcx
 1089f48:	lea    0x1(%rax),%edx
 1089f4b:	shl    $0x4,%rax
 1089f4f:	mov    %edx,0x138(%r13)
 1089f56:	vmovdqu %xmm0,(%rcx,%rax,1)
 1089f5b:	jmp    108b5bb <check_input_expressions+0x234b>
 1089f60:	mov    (%r12),%rcx
 1089f64:	cmpb   $0x0,0x3c5(%rcx)
 1089f6b:	jne    108b5bb <check_input_expressions+0x234b>
 1089f71:	mov    0x110(%rsp),%rax
 1089f79:	lea    -0x1(%r14),%edx
 1089f7d:	mov    %rdx,%rsi
 1089f80:	mov    %edx,0x13c(%rsp)
 1089f87:	shl    $0x5,%rsi
 1089f8b:	mov    (%rax,%rsi,1),%edi
 1089f8e:	cmp    $0x3,%rdi
 1089f92:	ja     108b570 <check_input_expressions+0x2300>
 1089f98:	lea    -0xbec31b(%rip),%r9        # 49dc84 <cbuiltin_test_generated.edges+0x3e44>
 1089f9f:	mov    0x4(%rax,%rsi,1),%r8d
 1089fa4:	movslq (%r9,%rdi,4),%rdi
 1089fa8:	add    %r9,%rdi
 1089fab:	jmp    *%rdi
 1089fad:	mov    0x100(%rsp),%r10
 1089fb5:	mov    %r8,0x48(%rsp)
 1089fba:	mov    0x8(%r10),%rcx
 1089fbe:	mov    0x50(%rcx),%r11
 1089fc2:	mov    %rcx,0x40(%rsp)
 1089fc7:	movzbl (%r11,%r8,1),%ebx
 1089fcc:	lea    -0x1e(%rbx),%edi
 1089fcf:	cmp    $0x35,%edi
 1089fd2:	ja     108b570 <check_input_expressions+0x2300>
 1089fd8:	lea    -0xbec34b(%rip),%rcx        # 49dc94 <cbuiltin_test_generated.edges+0x3e54>
 1089fdf:	mov    0x8(%rax,%rsi,1),%r8
 1089fe4:	mov    (%r10),%r15
 1089fe7:	mov    %r10,0x28(%rsp)
 1089fec:	movslq (%rcx,%rdi,4),%rdi
 1089ff0:	vmovq  %r8,%xmm0
 1089ff5:	shr    $0x20,%r8
 1089ff9:	add    %rcx,%rdi
 1089ffc:	jmp    *%rdi
 1089ffe:	mov    0x370(%r10),%rax
 108a005:	mov    0x48(%rsp),%rcx
 108a00a:	mov    (%rax,%rcx,4),%eax
 108a00d:	cmp    $0xffffffff,%eax
 108a010:	jne    108a066 <check_input_expressions+0xdf6>
 108a012:	jmp    108b570 <check_input_expressions+0x2300>
 108a017:	nopw   0x0(%rax,%rax,1)
 108a020:	mov    0x110(%rsp),%r8
 108a028:	lea    0x1(%rdi),%r9d
 108a02c:	shl    $0x5,%rdi
 108a030:	mov    %r9d,0x13c(%rsp)
 108a038:	movl   $0x0,(%r8,%rdi,1)
 108a040:	mov    %eax,0x4(%r8,%rdi,1)
 108a045:	vmovq  %xmm0,0x8(%r8,%rdi,1)
 108a04c:	vmovups %xmm2,0x10(%r8,%rdi,1)
 108a053:	mov    0x378(%r10),%rax
 108a05a:	mov    (%rax,%rsi,4),%eax
 108a05d:	cmp    $0xffffffff,%eax
 108a060:	je     108a313 <check_input_expressions+0x10a3>
 108a066:	mov    0x8(%r10),%rsi
 108a06a:	mov    0x50(%rsi),%rdi
 108a06e:	mov    %eax,%esi
 108a070:	movzbl (%rdi,%rsi,1),%edi
 108a074:	add    $0xcd,%dil
 108a078:	cmp    $0x2,%dil
 108a07c:	jb     108a053 <check_input_expressions+0xde3>
 108a07e:	mov    0x13c(%rsp),%edi
 108a085:	cmp    0x144(%rsp),%edi
 108a08c:	jb     108a020 <check_input_expressions+0xdb0>
 108a08e:	mov    0x100(%rsp),%rax
 108a096:	mov    (%rax),%rax
 108a099:	movb   $0x1,0x3c5(%rax)
 108a0a0:	jmp    108a053 <check_input_expressions+0xde3>
 108a0a2:	mov    0x138(%r13),%edx
 108a0a9:	cmp    0x13c(%r13),%edx
 108a0b0:	jae    108a206 <check_input_expressions+0xf96>
 108a0b6:	vmovdqu 0x10(%rax,%rsi,1),%xmm0
 108a0bc:	mov    0x130(%r13),%rax
 108a0c3:	lea    0x1(%rdx),%ecx
 108a0c6:	shl    $0x4,%rdx
 108a0ca:	mov    %ecx,0x138(%r13)
 108a0d1:	vmovdqu %xmm0,(%rax,%rdx,1)
 108a0d6:	jmp    108b570 <check_input_expressions+0x2300>
 108a0db:	mov    0x138(%r13),%eax
 108a0e2:	mov    0x118(%rsp),%rcx
 108a0ea:	sub    0x138(%rsp),%eax
 108a0f1:	mov    %eax,(%rcx,%r8,4)
 108a0f5:	jmp    108b570 <check_input_expressions+0x2300>
 108a0fa:	mov    0x30(%rsp),%rax
 108a0ff:	cmp    0x14(%rax),%r8d
 108a103:	je     108b570 <check_input_expressions+0x2300>
 108a109:	mov    0x278(%r12),%rax
 108a111:	mov    (%rax,%r8,4),%eax
 108a115:	cmp    $0xffffffff,%eax
 108a118:	je     108b570 <check_input_expressions+0x2300>
 108a11e:	mov    $0xffffffff,%r10d
 108a124:	jmp    108a158 <check_input_expressions+0xee8>
 108a126:	cs nopw 0x0(%rax,%rax,1)
 108a130:	mov    0x100(%rsp),%rcx
 108a138:	mov    (%rcx),%rcx
 108a13b:	movb   $0x1,0x3c5(%rcx)
 108a142:	mov    0x390(%r12),%rcx
 108a14a:	mov    %eax,%eax
 108a14c:	mov    (%rcx,%rax,4),%eax
 108a14f:	cmp    $0xffffffff,%eax
 108a152:	je     108a212 <check_input_expressions+0xfa2>
 108a158:	mov    0x0(%r13),%r8
 108a15c:	mov    %eax,%ecx
 108a15e:	jmp    108a167 <check_input_expressions+0xef7>
 108a160:	mov    0x10(%r13),%rdi
 108a164:	mov    (%rdi,%rcx,4),%ecx
 108a167:	mov    %ecx,%ecx
 108a169:	mov    (%r8,%rcx,4),%edi
 108a16d:	cmp    $0x24,%edi
 108a170:	je     108a160 <check_input_expressions+0xef0>
 108a172:	cmp    $0x18,%edi
 108a175:	je     108a160 <check_input_expressions+0xef0>
 108a177:	cmp    $0x23,%edi
 108a17a:	jne    108a1b0 <check_input_expressions+0xf40>
 108a17c:	mov    0x8(%r13),%r9
 108a180:	mov    0x150(%r12),%r8
 108a188:	mov    (%r9,%rcx,4),%r9d
 108a18c:	mov    (%r8,%r9,4),%r8d
 108a190:	cmp    %r10,%r8
 108a193:	je     108a1b0 <check_input_expressions+0xf40>
 108a195:	mov    0x118(%r12),%r9
 108a19d:	cmpb   $0x0,(%r9,%r8,1)
 108a1a2:	jne    108a142 <check_input_expressions+0xed2>
 108a1a4:	data16 data16 cs nopw 0x0(%rax,%rax,1)
 108a1b0:	mov    0x13c(%rsp),%r8d
 108a1b8:	cmp    0x144(%rsp),%r8d
 108a1c0:	jae    108a130 <check_input_expressions+0xec0>
 108a1c6:	mov    0x110(%rsp),%r11
 108a1ce:	cmp    $0x23,%edi
 108a1d1:	lea    0x1(%r8),%r9d
 108a1d5:	cmovne %eax,%ecx
 108a1d8:	shl    $0x5,%r8
 108a1dc:	mov    %r9d,0x13c(%rsp)
 108a1e4:	movl   $0x2,(%r11,%r8,1)
 108a1ec:	vmovups %xmm2,0x4(%r11,%r8,1)
 108a1f3:	mov    %ecx,0x14(%r11,%r8,1)
 108a1f8:	movq   $0xffffffffffffffff,0x18(%r11,%r8,1)
 108a201:	jmp    108a142 <check_input_expressions+0xed2>
 108a206:	movb   $0x1,0x3c5(%rcx)
 108a20d:	jmp    108b570 <check_input_expressions+0x2300>
 108a212:	mov    0x13c(%rsp),%eax
 108a219:	cmp    %eax,%edx
 108a21b:	jae    108b570 <check_input_expressions+0x2300>
 108a221:	mov    %rax,%rcx
 108a224:	shl    $0x5,%rcx
 108a228:	add    $0xffffffffffffffe0,%rcx
 108a22c:	nopl   0x0(%rax)
 108a230:	dec    %rax
 108a233:	cmp    %rax,%rdx
 108a236:	jae    108b570 <check_input_expressions+0x2300>
 108a23c:	mov    0x110(%rsp),%rdi
 108a244:	inc    %rdx
 108a247:	vmovups (%rdi,%rsi,1),%ymm0
 108a24c:	vmovups %ymm0,0xe0(%rsp)
 108a255:	vmovups (%rdi,%rcx,1),%ymm0
 108a25a:	vmovups %ymm0,(%rdi,%rsi,1)
 108a25f:	add    $0x20,%rsi
 108a263:	vmovdqu 0xe0(%rsp),%ymm0
 108a26c:	vmovdqu %ymm0,(%rdi,%rcx,1)
 108a271:	add    $0xffffffffffffffe0,%rcx
 108a275:	cmp    %rax,%rdx
 108a278:	jb     108a230 <check_input_expressions+0xfc0>
 108a27a:	jmp    108b570 <check_input_expressions+0x2300>
 108a27f:	mov    0x48(%rsp),%rdx
 108a284:	vmovd  %xmm0,%ecx
 108a288:	lea    0x100(%rsp),%rdi
 108a290:	mov    %edx,%esi
 108a292:	vzeroupper
 108a295:	call   10fba70 <check_region_input_children>
 108a29a:	vpmovsxbq -0xbec623(%rip),%xmm3        # 49dc80 <cbuiltin_test_generated.edges+0x3e40>
 108a2a3:	vxorps %xmm2,%xmm2,%xmm2
 108a2a7:	cmp    $0x53,%bl
 108a2aa:	jne    108b570 <check_input_expressions+0x2300>
 108a2b0:	mov    0x13c(%rsp),%eax
 108a2b7:	cmp    0x144(%rsp),%eax
 108a2be:	jae    108b555 <check_input_expressions+0x22e5>
 108a2c4:	mov    0x108(%rsp),%rdx
 108a2cc:	mov    0x48(%rsp),%rdi
 108a2d1:	mov    0x120(%rsp),%rcx
 108a2d9:	mov    0x110(%rsp),%rsi
 108a2e1:	sub    (%rdx),%edi
 108a2e3:	lea    0x1(%rax),%edx
 108a2e6:	shl    $0x5,%rax
 108a2ea:	mov    (%rcx,%rdi,4),%ecx
 108a2ed:	mov    %edx,0x13c(%rsp)
 108a2f4:	movl   $0x3,(%rsi,%rax,1)
 108a2fb:	mov    %ecx,0x4(%rsi,%rax,1)
 108a2ff:	vmovups %xmm2,0x8(%rsi,%rax,1)
 108a305:	movq   $0x0,0x18(%rsi,%rax,1)
 108a30e:	jmp    108b570 <check_input_expressions+0x2300>
 108a313:	mov    0x13c(%rsp),%eax
 108a31a:	cmp    %eax,%edx
 108a31c:	jae    108b570 <check_input_expressions+0x2300>
 108a322:	mov    %rax,%rsi
 108a325:	shl    $0x5,%rsi
 108a329:	mov    %rdx,%rcx
 108a32c:	shl    $0x5,%rcx
 108a330:	dec    %rax
 108a333:	add    $0xffffffffffffffe0,%rsi
 108a337:	nopw   0x0(%rax,%rax,1)
 108a340:	cmp    %rax,%rdx
 108a343:	jae    108b570 <check_input_expressions+0x2300>
 108a349:	mov    0x110(%rsp),%rdi
 108a351:	inc    %rdx
 108a354:	vmovups (%rdi,%rcx,1),%ymm0
 108a359:	vmovups %ymm0,0xe0(%rsp)
 108a362:	vmovups (%rdi,%rsi,1),%ymm0
 108a367:	vmovups %ymm0,(%rdi,%rcx,1)
 108a36c:	add    $0x20,%rcx
 108a370:	vmovdqu 0xe0(%rsp),%ymm0
 108a379:	vmovdqu %ymm0,(%rdi,%rsi,1)
 108a37e:	add    $0xffffffffffffffe0,%rsi
 108a382:	cmp    %rax,%rdx
 108a385:	lea    -0x1(%rax),%rax
 108a389:	jb     108a340 <check_input_expressions+0x10d0>
 108a38b:	jmp    108b570 <check_input_expressions+0x2300>
 108a390:	mov    0x370(%r10),%rax
 108a397:	mov    0x48(%rsp),%rbx
 108a39c:	mov    (%rax,%rbx,4),%esi
 108a39f:	cmp    $0xffffffff,%esi
 108a3a2:	je     108a608 <check_input_expressions+0x1398>
 108a3a8:	mov    0x378(%r10),%rcx
 108a3af:	mov    $0xffffffff,%edx
 108a3b4:	mov    $0xffffffff,%r10d
 108a3ba:	mov    %esi,%edi
 108a3bc:	jmp    108a3cc <check_input_expressions+0x115c>
 108a3be:	xchg   %ax,%ax
 108a3c0:	mov    (%rcx,%rax,4),%edi
 108a3c3:	cmp    $0xffffffff,%edi
 108a3c6:	je     108a5e1 <check_input_expressions+0x1371>
 108a3cc:	mov    %edi,%eax
 108a3ce:	cmp    %ebx,%edi
 108a3d0:	jbe    108a3c0 <check_input_expressions+0x1150>
 108a3d2:	cmpb   $0x1f,(%r11,%rax,1)
 108a3d7:	cmove  %eax,%r10d
 108a3db:	cmovne %eax,%edx
 108a3de:	jmp    108a3c0 <check_input_expressions+0x1150>
 108a3e0:	mov    0x370(%r10),%rax
 108a3e7:	mov    0x48(%rsp),%r11
 108a3ec:	mov    (%rax,%r11,4),%edi
 108a3f0:	cmp    $0xffffffff,%edi
 108a3f3:	je     108a6d5 <check_input_expressions+0x1465>
 108a3f9:	mov    0x378(%r10),%rax
 108a400:	mov    0x40(%rsp),%rbx
 108a405:	mov    $0xffffffff,%edx
 108a40a:	mov    $0xffffffff,%esi
 108a40f:	mov    $0xffffffff,%r8d
 108a415:	jmp    108a432 <check_input_expressions+0x11c2>
 108a417:	nopw   0x0(%rax,%rax,1)
 108a420:	cmp    $0xffffffff,%edx
 108a423:	cmovne %edi,%esi
 108a426:	cmove  %edi,%edx
 108a429:	mov    (%rax,%r9,4),%edi
 108a42d:	cmp    $0xffffffff,%edi
 108a430:	je     108a463 <check_input_expressions+0x11f3>
 108a432:	cmp    %r11d,%edi
 108a435:	jae    108a450 <check_input_expressions+0x11e0>
 108a437:	mov    0x10(%rbx),%r10
 108a43b:	mov    %edi,%r9d
 108a43e:	cmpb   $0x30,(%r10,%r9,1)
 108a443:	jne    108a453 <check_input_expressions+0x11e3>
 108a445:	jmp    108a420 <check_input_expressions+0x11b0>
 108a447:	nopw   0x0(%rax,%rax,1)
 108a450:	mov    %edi,%r9d
 108a453:	cmp    %r11d,%edi
 108a456:	cmova  %edi,%r8d
 108a45a:	mov    (%rax,%r9,4),%edi
 108a45e:	cmp    $0xffffffff,%edi
 108a461:	jne    108a432 <check_input_expressions+0x11c2>
 108a463:	cmp    $0xffffffff,%edx
 108a466:	je     108a6d5 <check_input_expressions+0x1465>
 108a46c:	cmp    $0xffffffff,%esi
 108a46f:	je     108a6d5 <check_input_expressions+0x1465>
 108a475:	cmp    $0xffffffff,%r8d
 108a479:	je     108a6d5 <check_input_expressions+0x1465>
 108a47f:	mov    0x140(%rsp),%edi
 108a486:	mov    0x144(%rsp),%r11d
 108a48e:	cmp    %r11d,%edi
 108a491:	jae    108a78a <check_input_expressions+0x151a>
 108a497:	mov    0x118(%rsp),%rax
 108a49f:	movl   $0xffffffff,(%rax,%rdi,4)
 108a4a6:	mov    0x140(%rsp),%r9d
 108a4ae:	mov    0x144(%rsp),%r11d
 108a4b6:	inc    %r9d
 108a4b9:	mov    %r9d,0x140(%rsp)
 108a4c1:	jmp    108a795 <check_input_expressions+0x1525>
 108a4c6:	mov    0x370(%r10),%rdi
 108a4cd:	mov    0x48(%rsp),%rcx
 108a4d2:	mov    %r12,0x18(%rsp)
 108a4d7:	lea    (%rax,%rsi,1),%r9
 108a4db:	mov    (%rdi,%rcx,4),%r12d
 108a4df:	cmp    $0xffffffff,%r12d
 108a4e3:	je     108a6e2 <check_input_expressions+0x1472>
 108a4e9:	mov    %r8,0x58(%rsp)
 108a4ee:	mov    0x378(%r10),%r8
 108a4f5:	mov    %r15,0x98(%rsp)
 108a4fd:	mov    $0xffffffff,%r10d
 108a503:	mov    $0xffffffff,%edi
 108a508:	mov    $0xffffffff,%r15d
 108a50e:	xor    %ebx,%ebx
 108a510:	mov    %r9,0x80(%rsp)
 108a518:	nopl   0x0(%rax,%rax,1)
 108a520:	mov    %r12d,%ecx
 108a523:	movzbl (%r11,%rcx,1),%r9d
 108a528:	cmp    $0x1a,%r9b
 108a52c:	cmove  %r12d,%r15d
 108a530:	cmp    $0x20,%r9b
 108a534:	cmove  %r12d,%edi
 108a538:	cmp    $0x49,%r9b
 108a53c:	cmove  %r12d,%r10d
 108a540:	cmp    $0x47,%r9b
 108a544:	sete   %r9b
 108a548:	or     %r9b,%bl
 108a54b:	mov    %bl,0x148(%rsp)
 108a552:	mov    (%r8,%rcx,4),%r12d
 108a556:	cmp    $0xffffffff,%r12d
 108a55a:	jne    108a520 <check_input_expressions+0x12b0>
 108a55c:	cmp    $0xffffffff,%r15d
 108a560:	je     108a725 <check_input_expressions+0x14b5>
 108a566:	mov    0x40(%rsp),%rax
 108a56b:	mov    %r15d,%ecx
 108a56e:	mov    0x18(%rsp),%r12
 108a573:	vmovd  %xmm0,%esi
 108a577:	mov    0x10(%rax),%rax
 108a57b:	movzbl (%rax,%rcx,1),%eax
 108a57f:	mov    0x58(%rsp),%rcx
 108a584:	cmp    $0x51,%al
 108a586:	jne    108a58d <check_input_expressions+0x131d>
 108a588:	cmp    $0xffffffff,%esi
 108a58b:	jne    108a59e <check_input_expressions+0x132e>
 108a58d:	cmp    $0x50,%al
 108a58f:	jne    108a6d5 <check_input_expressions+0x1465>
 108a595:	cmp    $0xffffffff,%ecx
 108a598:	je     108a6d5 <check_input_expressions+0x1465>
 108a59e:	cmp    0x144(%rsp),%edx
 108a5a5:	jae    108aa80 <check_input_expressions+0x1810>
 108a5ab:	mov    0x80(%rsp),%rdx
 108a5b3:	cmp    $0x51,%al
 108a5b5:	movabs $0xffffffff00000003,%rax
 108a5bf:	mov    %r14d,0x13c(%rsp)
 108a5c7:	cmove  %esi,%ecx
 108a5ca:	vmovups %xmm3,(%rdx)
 108a5ce:	mov    %rax,0x10(%rdx)
 108a5d2:	movl   $0xffffffff,0x18(%rdx)
 108a5d9:	mov    %ecx,0x1c(%rdx)
 108a5dc:	jmp    108b570 <check_input_expressions+0x2300>
 108a5e1:	mov    $0xffffffff,%eax
 108a5e6:	jmp    108a5f8 <check_input_expressions+0x1388>
 108a5e8:	nopl   0x0(%rax,%rax,1)
 108a5f0:	mov    (%rcx,%rdi,4),%esi
 108a5f3:	cmp    $0xffffffff,%esi
 108a5f6:	je     108a618 <check_input_expressions+0x13a8>
 108a5f8:	mov    %esi,%edi
 108a5fa:	cmp    %ebx,%esi
 108a5fc:	jae    108a5f0 <check_input_expressions+0x1380>
 108a5fe:	cmpb   $0x6,(%r11,%rdi,1)
 108a603:	cmove  %edi,%eax
 108a606:	jmp    108a5f0 <check_input_expressions+0x1380>
 108a608:	mov    $0xffffffff,%edx
 108a60d:	mov    $0xffffffff,%r10d
 108a613:	mov    $0xffffffff,%eax
 108a618:	mov    0x2c0(%r15),%rcx
 108a61f:	mov    0x140(%rsp),%esi
 108a626:	mov    (%rcx,%rbx,4),%ecx
 108a629:	cmp    0x144(%rsp),%esi
 108a630:	jae    108a653 <check_input_expressions+0x13e3>
 108a632:	mov    0x118(%rsp),%rdi
 108a63a:	movl   $0xffffffff,(%rdi,%rsi,4)
 108a641:	mov    0x140(%rsp),%edi
 108a648:	inc    %edi
 108a64a:	mov    %edi,0x140(%rsp)
 108a651:	jmp    108a65d <check_input_expressions+0x13ed>
 108a653:	mov    %esi,%edi
 108a655:	movb   $0x1,0x3c5(%r15)
 108a65d:	cmp    $0xffffffff,%eax
 108a660:	je     108a6d5 <check_input_expressions+0x1465>
 108a662:	cmp    $0xffffffff,%ecx
 108a665:	je     108a6d5 <check_input_expressions+0x1465>
 108a667:	cmp    $0xffffffff,%edx
 108a66a:	je     108a6d5 <check_input_expressions+0x1465>
 108a66c:	mov    0x40(%rsp),%r9
 108a671:	mov    %eax,%eax
 108a673:	mov    0x10(%r9),%r9
 108a677:	movzbl (%r9,%rax,1),%eax
 108a67c:	cmp    $0x4c,%eax
 108a67f:	je     108abda <check_input_expressions+0x196a>
 108a685:	cmp    $0x49,%eax
 108a688:	je     108aa8a <check_input_expressions+0x181a>
 108a68e:	cmp    $0x47,%eax
 108a691:	jne    108a6d5 <check_input_expressions+0x1465>
 108a693:	mov    0x144(%rsp),%r8d
 108a69b:	cmp    $0xffffffff,%r10d
 108a69f:	je     108b0ce <check_input_expressions+0x1e5e>
 108a6a5:	cmp    %r8d,%edi
 108a6a8:	jae    108b0f3 <check_input_expressions+0x1e83>
 108a6ae:	mov    0x118(%rsp),%rax
 108a6b6:	mov    %edi,%r8d
 108a6b9:	movl   $0xffffffff,(%rax,%r8,4)
 108a6c1:	incl   0x140(%rsp)
 108a6c8:	mov    0x144(%rsp),%r8d
 108a6d0:	jmp    108b105 <check_input_expressions+0x1e95>
 108a6d5:	movb   $0x1,0x148(%rsp)
 108a6dd:	jmp    108b570 <check_input_expressions+0x2300>
 108a6e2:	mov    0x144(%rsp),%r8d
 108a6ea:	mov    0x18(%rsp),%r12
 108a6ef:	cmp    %r8d,%edx
 108a6f2:	jae    108a71d <check_input_expressions+0x14ad>
 108a6f4:	lea    0x8(%rax,%rsi,1),%rax
 108a6f9:	mov    %r14d,0x13c(%rsp)
 108a701:	movl   $0x1,(%r9)
 108a708:	mov    %ecx,0x4(%r9)
 108a70c:	vmovups %xmm2,(%rax)
 108a710:	movq   $0x0,0x10(%rax)
 108a718:	jmp    108b570 <check_input_expressions+0x2300>
 108a71d:	mov    (%r10),%rax
 108a720:	jmp    108b560 <check_input_expressions+0x22f0>
 108a725:	mov    0x144(%rsp),%r8d
 108a72d:	mov    0x18(%rsp),%r12
 108a732:	cmp    $0xffffffff,%edi
 108a735:	je     108ae3e <check_input_expressions+0x1bce>
 108a73b:	mov    0x48(%rsp),%rcx
 108a740:	lea    (%rax,%rsi,1),%r9
 108a744:	cmp    $0xffffffff,%r10d
 108a748:	je     108ae34 <check_input_expressions+0x1bc4>
 108a74e:	mov    0x140(%rsp),%edx
 108a755:	cmp    %r8d,%edx
 108a758:	jae    108ae51 <check_input_expressions+0x1be1>
 108a75e:	mov    0x118(%rsp),%rax
 108a766:	movl   $0xffffffff,(%rax,%rdx,4)
 108a76d:	mov    0x140(%rsp),%ecx
 108a774:	mov    0x144(%rsp),%r8d
 108a77c:	inc    %ecx
 108a77e:	mov    %ecx,0x140(%rsp)
 108a785:	jmp    108ae62 <check_input_expressions+0x1bf2>
 108a78a:	mov    %edi,%r9d
 108a78d:	movb   $0x1,0x3c5(%r15)
 108a795:	cmp    %r11d,%r9d
 108a798:	jae    108a7c7 <check_input_expressions+0x1557>
 108a79a:	mov    0x118(%rsp),%rax
 108a7a2:	mov    %r9d,%r10d
 108a7a5:	movl   $0xffffffff,(%rax,%r10,4)
 108a7ad:	mov    0x140(%rsp),%eax
 108a7b4:	mov    0x144(%rsp),%r11d
 108a7bc:	inc    %eax
 108a7be:	mov    %eax,0x140(%rsp)
 108a7c5:	jmp    108a7dc <check_input_expressions+0x156c>
 108a7c7:	mov    0x100(%rsp),%rax
 108a7cf:	mov    (%rax),%rax
 108a7d2:	movb   $0x1,0x3c5(%rax)
 108a7d9:	mov    %r9d,%eax
 108a7dc:	cmp    %r11d,%eax
 108a7df:	jae    108a805 <check_input_expressions+0x1595>
 108a7e1:	mov    0x118(%rsp),%r10
 108a7e9:	mov    %eax,%r11d
 108a7ec:	movl   $0xffffffff,(%r10,%r11,4)
 108a7f4:	incl   0x140(%rsp)
 108a7fb:	mov    0x144(%rsp),%r11d
 108a803:	jmp    108a818 <check_input_expressions+0x15a8>
 108a805:	mov    0x100(%rsp),%r10
 108a80d:	mov    (%r10),%r10
 108a810:	movb   $0x1,0x3c5(%r10)
 108a818:	mov    0x13c(%rsp),%r10d
 108a820:	cmp    %r11d,%r10d
 108a823:	jae    108a86c <check_input_expressions+0x15fc>
 108a825:	mov    0x110(%rsp),%r11
 108a82d:	mov    %r10d,%ebx
 108a830:	inc    %ebx
 108a832:	shl    $0x5,%r10
 108a836:	mov    %ebx,0x13c(%rsp)
 108a83d:	movl   $0x3,(%r11,%r10,1)
 108a845:	mov    %eax,0x4(%r11,%r10,1)
 108a84a:	vmovups %xmm2,0x8(%r11,%r10,1)
 108a851:	movq   $0x0,0x18(%r11,%r10,1)
 108a85a:	mov    0x13c(%rsp),%r10d
 108a862:	mov    0x144(%rsp),%r11d
 108a86a:	jmp    108a87e <check_input_expressions+0x160e>
 108a86c:	mov    0x100(%rsp),%rbx
 108a874:	mov    (%rbx),%rbx
 108a877:	movb   $0x1,0x3c5(%rbx)
 108a87e:	cmp    %r11d,%r10d
 108a881:	jae    108a8d2 <check_input_expressions+0x1662>
 108a883:	mov    0x110(%rsp),%r11
 108a88b:	lea    0x1(%r10),%ebx
 108a88f:	mov    %r10d,%r10d
 108a892:	shl    $0x5,%r10
 108a896:	movabs $0xffffffff00000003,%rcx
 108a8a0:	mov    %ebx,0x13c(%rsp)
 108a8a7:	vmovups %xmm3,(%r11,%r10,1)
 108a8ad:	mov    %rcx,0x10(%r11,%r10,1)
 108a8b2:	movl   $0xffffffff,0x18(%r11,%r10,1)
 108a8bb:	mov    %edi,0x1c(%r11,%r10,1)
 108a8c0:	mov    0x13c(%rsp),%r10d
 108a8c8:	mov    0x144(%rsp),%r11d
 108a8d0:	jmp    108a8e4 <check_input_expressions+0x1674>
 108a8d2:	mov    0x100(%rsp),%rbx
 108a8da:	mov    (%rbx),%rbx
 108a8dd:	movb   $0x1,0x3c5(%rbx)
 108a8e4:	cmp    %r11d,%r10d
 108a8e7:	jae    108a937 <check_input_expressions+0x16c7>
 108a8e9:	mov    0x110(%rsp),%r11
 108a8f1:	mov    0x48(%rsp),%rcx
 108a8f6:	lea    0x1(%r10),%ebx
 108a8fa:	mov    %r10d,%r10d
 108a8fd:	shl    $0x5,%r10
 108a901:	mov    %ebx,0x13c(%rsp)
 108a908:	movl   $0x1,(%r11,%r10,1)
 108a910:	mov    %ecx,0x4(%r11,%r10,1)
 108a915:	vmovups %xmm2,0x8(%r11,%r10,1)
 108a91c:	movq   $0x0,0x18(%r11,%r10,1)
 108a925:	mov    0x13c(%rsp),%r10d
 108a92d:	mov    0x144(%rsp),%r11d
 108a935:	jmp    108a949 <check_input_expressions+0x16d9>
 108a937:	mov    0x100(%rsp),%rbx
 108a93f:	mov    (%rbx),%rbx
 108a942:	movb   $0x1,0x3c5(%rbx)
 108a949:	cmp    %r11d,%r10d
 108a94c:	jae    108a997 <check_input_expressions+0x1727>
 108a94e:	mov    0x110(%rsp),%r11
 108a956:	lea    0x1(%r10),%ebx
 108a95a:	mov    %r10d,%r10d
 108a95d:	shl    $0x5,%r10
 108a961:	mov    %ebx,0x13c(%rsp)
 108a968:	movl   $0x3,(%r11,%r10,1)
 108a970:	mov    %r9d,0x4(%r11,%r10,1)
 108a975:	vmovups %xmm2,0x8(%r11,%r10,1)
 108a97c:	movq   $0x0,0x18(%r11,%r10,1)
 108a985:	mov    0x13c(%rsp),%r10d
 108a98d:	mov    0x144(%rsp),%r11d
 108a995:	jmp    108a9a9 <check_input_expressions+0x1739>
 108a997:	mov    0x100(%rsp),%rbx
 108a99f:	mov    (%rbx),%rbx
 108a9a2:	movb   $0x1,0x3c5(%rbx)
 108a9a9:	cmp    %r11d,%r10d
 108a9ac:	jae    108a9f8 <check_input_expressions+0x1788>
 108a9ae:	mov    0x110(%rsp),%r11
 108a9b6:	lea    0x1(%r10),%ebx
 108a9ba:	mov    %r10d,%r10d
 108a9bd:	shl    $0x5,%r10
 108a9c1:	mov    %ebx,0x13c(%rsp)
 108a9c8:	movl   $0x0,(%r11,%r10,1)
 108a9d0:	mov    %r8d,0x4(%r11,%r10,1)
 108a9d5:	mov    %eax,0x8(%r11,%r10,1)
 108a9da:	mov    %r9d,0xc(%r11,%r10,1)
 108a9df:	vmovups %xmm2,0x10(%r11,%r10,1)
 108a9e6:	mov    0x13c(%rsp),%r10d
 108a9ee:	mov    0x144(%rsp),%r11d
 108a9f6:	jmp    108aa0b <check_input_expressions+0x179b>
 108a9f8:	mov    0x100(%rsp),%r8
 108aa00:	mov    (%r8),%r8
 108aa03:	movb   $0x1,0x3c5(%r8)
 108aa0b:	mov    0x28(%rsp),%rcx
 108aa10:	mov    %esi,%esi
 108aa12:	mov    0x278(%rcx),%rcx
 108aa19:	mov    (%rcx,%rsi,4),%ecx
 108aa1c:	cmp    $0xffffffff,%ecx
 108aa1f:	je     108ac24 <check_input_expressions+0x19b4>
 108aa25:	cmp    %r11d,%r10d
 108aa28:	jae    108ac12 <check_input_expressions+0x19a2>
 108aa2e:	mov    0x110(%rsp),%rsi
 108aa36:	lea    0x1(%r10),%r8d
 108aa3a:	mov    %r8d,0x13c(%rsp)
 108aa42:	mov    %r10d,%r8d
 108aa45:	shl    $0x5,%r8
 108aa49:	vmovups %xmm3,(%rsi,%r8,1)
 108aa4f:	movl   $0x1,0x10(%rsi,%r8,1)
 108aa58:	mov    %ecx,0x14(%rsi,%r8,1)
 108aa5d:	movl   $0xffffffff,0x18(%rsi,%r8,1)
 108aa66:	mov    %eax,0x1c(%rsi,%r8,1)
 108aa6b:	mov    0x13c(%rsp),%r10d
 108aa73:	mov    0x144(%rsp),%r11d
 108aa7b:	jmp    108ac24 <check_input_expressions+0x19b4>
 108aa80:	mov    0x28(%rsp),%rax
 108aa85:	jmp    108b55d <check_input_expressions+0x22ed>
 108aa8a:	mov    0x108(%rsp),%rax
 108aa92:	mov    0x128(%rsp),%r9
 108aa9a:	mov    (%rax),%edi
 108aa9c:	mov    %esi,%eax
 108aa9e:	sub    %edi,%ebx
 108aaa0:	mov    (%r9,%rbx,4),%r9d
 108aaa4:	mov    %rbx,0x48(%rsp)
 108aaa9:	cmp    $0xffffffff,%r9d
 108aaad:	je     108aaed <check_input_expressions+0x187d>
 108aaaf:	mov    0x2c0(%r15),%r10
 108aab6:	mov    0x120(%rsp),%r11
 108aabe:	mov    0x130(%rsp),%rbx
 108aac6:	mov    %esi,%eax
 108aac8:	jmp    108aada <check_input_expressions+0x186a>
 108aaca:	nopw   0x0(%rax,%rax,1)
 108aad0:	mov    (%rbx,%r9,4),%r9d
 108aad4:	cmp    $0xffffffff,%r9d
 108aad8:	je     108aaed <check_input_expressions+0x187d>
 108aada:	mov    %r9d,%r14d
 108aadd:	sub    %edi,%r9d
 108aae0:	cmpl   $0xffffffff,(%r10,%r14,4)
 108aae5:	jne    108aad0 <check_input_expressions+0x1860>
 108aae7:	mov    (%r11,%r9,4),%eax
 108aaeb:	jmp    108aad0 <check_input_expressions+0x1860>
 108aaed:	mov    0x13c(%rsp),%r9d
 108aaf5:	cmp    0x144(%rsp),%r9d
 108aafd:	jae    108acaa <check_input_expressions+0x1a3a>
 108ab03:	mov    0x110(%rsp),%r10
 108ab0b:	lea    0x1(%r9),%r11d
 108ab0f:	shl    $0x5,%r9
 108ab13:	mov    %r11d,0x13c(%rsp)
 108ab1b:	movl   $0x3,(%r10,%r9,1)
 108ab23:	mov    %esi,0x4(%r10,%r9,1)
 108ab28:	vmovups %xmm2,0x8(%r10,%r9,1)
 108ab2f:	movq   $0x0,0x18(%r10,%r9,1)
 108ab38:	mov    0x13c(%rsp),%r9d
 108ab40:	cmp    0x144(%rsp),%r9d
 108ab48:	jae    108b332 <check_input_expressions+0x20c2>
 108ab4e:	mov    0x110(%rsp),%r10
 108ab56:	lea    0x1(%r9),%r11d
 108ab5a:	shl    $0x5,%r9
 108ab5e:	mov    %r11d,0x13c(%rsp)
 108ab66:	movl   $0x0,(%r10,%r9,1)
 108ab6e:	mov    %edx,0x4(%r10,%r9,1)
 108ab73:	mov    %esi,0x8(%r10,%r9,1)
 108ab78:	mov    %r8d,0xc(%r10,%r9,1)
 108ab7d:	vmovups %xmm2,0x10(%r10,%r9,1)
 108ab84:	mov    0x13c(%rsp),%edx
 108ab8b:	cmp    0x144(%rsp),%edx
 108ab92:	jae    108b5a3 <check_input_expressions+0x2333>
 108ab98:	mov    0x110(%rsp),%rsi
 108aba0:	lea    0x1(%rdx),%r8d
 108aba4:	shl    $0x5,%rdx
 108aba8:	mov    %r8d,0x13c(%rsp)
 108abb0:	movabs $0xffffffff00000003,%r8
 108abba:	vmovups %xmm3,(%rsi,%rdx,1)
 108abbf:	mov    %r8,0x10(%rsi,%rdx,1)
 108abc4:	movl   $0xffffffff,0x18(%rsi,%rdx,1)
 108abcc:	mov    %eax,0x1c(%rsi,%rdx,1)
 108abd0:	mov    0x48(%rsp),%rdx
 108abd5:	jmp    108b353 <check_input_expressions+0x20e3>
 108abda:	mov    0x144(%rsp),%r8d
 108abe2:	cmp    %r8d,%edi
 108abe5:	jae    108acc1 <check_input_expressions+0x1a51>
 108abeb:	mov    0x118(%rsp),%rax
 108abf3:	mov    %edi,%r8d
 108abf6:	movl   $0xffffffff,(%rax,%r8,4)
 108abfe:	incl   0x140(%rsp)
 108ac05:	mov    0x144(%rsp),%r8d
 108ac0d:	jmp    108acd3 <check_input_expressions+0x1a63>
 108ac12:	mov    0x100(%rsp),%rax
 108ac1a:	mov    (%rax),%rax
 108ac1d:	movb   $0x1,0x3c5(%rax)
 108ac24:	cmp    %r11d,%r10d
 108ac27:	jae    108b31b <check_input_expressions+0x20ab>
 108ac2d:	mov    0x110(%rsp),%rax
 108ac35:	lea    0x1(%r10),%ecx
 108ac39:	mov    %ecx,0x13c(%rsp)
 108ac40:	mov    %r10d,%ecx
 108ac43:	shl    $0x5,%rcx
 108ac47:	movl   $0x3,(%rax,%rcx,1)
 108ac4e:	mov    %edi,0x4(%rax,%rcx,1)
 108ac52:	vmovups %xmm2,0x8(%rax,%rcx,1)
 108ac58:	movq   $0x0,0x18(%rax,%rcx,1)
 108ac61:	mov    0x13c(%rsp),%eax
 108ac68:	cmp    0x144(%rsp),%eax
 108ac6f:	jae    108b555 <check_input_expressions+0x22e5>
 108ac75:	mov    0x110(%rsp),%rcx
 108ac7d:	lea    0x1(%rax),%esi
 108ac80:	shl    $0x5,%rax
 108ac84:	mov    %esi,0x13c(%rsp)
 108ac8b:	movl   $0x1,(%rcx,%rax,1)
 108ac92:	mov    %edx,0x4(%rcx,%rax,1)
 108ac96:	vmovups %xmm2,0x8(%rcx,%rax,1)
 108ac9c:	movq   $0x0,0x18(%rcx,%rax,1)
 108aca5:	jmp    108b570 <check_input_expressions+0x2300>
 108acaa:	mov    0x100(%rsp),%rax
 108acb2:	mov    (%rax),%rdx
 108acb5:	movb   $0x1,0x3c5(%rdx)
 108acbc:	jmp    108b33a <check_input_expressions+0x20ca>
 108acc1:	mov    0x100(%rsp),%rax
 108acc9:	mov    (%rax),%rax
 108accc:	movb   $0x1,0x3c5(%rax)
 108acd3:	mov    0x13c(%rsp),%eax
 108acda:	cmp    %r8d,%eax
 108acdd:	jae    108b0a6 <check_input_expressions+0x1e36>
 108ace3:	mov    0x110(%rsp),%r8
 108aceb:	lea    0x1(%rax),%r9d
 108acef:	shl    $0x5,%rax
 108acf3:	mov    %r9d,0x13c(%rsp)
 108acfb:	movl   $0x3,(%r8,%rax,1)
 108ad03:	mov    %esi,0x4(%r8,%rax,1)
 108ad08:	vmovups %xmm2,0x8(%r8,%rax,1)
 108ad0f:	movq   $0x0,0x18(%r8,%rax,1)
 108ad18:	mov    0x13c(%rsp),%eax
 108ad1f:	cmp    0x144(%rsp),%eax
 108ad26:	jae    108b0d2 <check_input_expressions+0x1e62>
 108ad2c:	mov    0x110(%rsp),%r8
 108ad34:	lea    0x1(%rax),%r9d
 108ad38:	shl    $0x5,%rax
 108ad3c:	mov    %r9d,0x13c(%rsp)
 108ad44:	movabs $0xffffffff00000003,%r9
 108ad4e:	vmovups %xmm3,(%r8,%rax,1)
 108ad54:	mov    %r9,0x10(%r8,%rax,1)
 108ad59:	movl   $0xffffffff,0x18(%r8,%rax,1)
 108ad62:	mov    %edi,0x1c(%r8,%rax,1)
 108ad67:	mov    0x13c(%rsp),%eax
 108ad6e:	cmp    0x144(%rsp),%eax
 108ad75:	jae    108b596 <check_input_expressions+0x2326>
 108ad7b:	mov    0x110(%rsp),%r8
 108ad83:	lea    0x1(%rax),%r9d
 108ad87:	shl    $0x5,%rax
 108ad8b:	mov    %r9d,0x13c(%rsp)
 108ad93:	movl   $0x0,(%r8,%rax,1)
 108ad9b:	mov    %edx,0x4(%r8,%rax,1)
 108ada0:	mov    %esi,0x8(%r8,%rax,1)
 108ada5:	mov    %edi,0xc(%r8,%rax,1)
 108adaa:	vmovups %xmm2,0x10(%r8,%rax,1)
 108adb1:	mov    0x13c(%rsp),%eax
 108adb8:	cmp    0x144(%rsp),%eax
 108adbf:	jae    108b31b <check_input_expressions+0x20ab>
 108adc5:	mov    0x110(%rsp),%rdx
 108adcd:	lea    0x1(%rax),%r8d
 108add1:	shl    $0x5,%rax
 108add5:	mov    %r8d,0x13c(%rsp)
 108addd:	vmovups %xmm3,(%rdx,%rax,1)
 108ade2:	movl   $0x1,0x10(%rdx,%rax,1)
 108adea:	mov    %ecx,0x14(%rdx,%rax,1)
 108adee:	movl   $0xffffffff,0x18(%rdx,%rax,1)
 108adf6:	mov    %esi,0x1c(%rdx,%rax,1)
 108adfa:	mov    0x13c(%rsp),%eax
 108ae01:	cmp    0x144(%rsp),%eax
 108ae08:	jae    108b555 <check_input_expressions+0x22e5>
 108ae0e:	mov    0x110(%rsp),%rcx
 108ae16:	lea    0x1(%rax),%edx
 108ae19:	shl    $0x5,%rax
 108ae1d:	mov    %edx,0x13c(%rsp)
 108ae24:	movl   $0x3,(%rcx,%rax,1)
 108ae2b:	mov    %edi,0x4(%rcx,%rax,1)
 108ae2f:	jmp    108ac96 <check_input_expressions+0x1a26>
 108ae34:	mov    0x28(%rsp),%r10
 108ae39:	jmp    108a6ef <check_input_expressions+0x147f>
 108ae3e:	mov    0x48(%rsp),%rcx
 108ae43:	mov    0x28(%rsp),%r10
 108ae48:	lea    (%rax,%rsi,1),%r9
 108ae4c:	jmp    108a6ef <check_input_expressions+0x147f>
 108ae51:	mov    0x28(%rsp),%rax
 108ae56:	mov    %edx,%ecx
 108ae58:	mov    (%rax),%rax
 108ae5b:	movb   $0x1,0x3c5(%rax)
 108ae62:	cmp    %r8d,%ecx
 108ae65:	jae    108ae92 <check_input_expressions+0x1c22>
 108ae67:	mov    0x118(%rsp),%rax
 108ae6f:	mov    %ecx,%esi
 108ae71:	movl   $0xffffffff,(%rax,%rsi,4)
 108ae78:	mov    0x140(%rsp),%eax
 108ae7f:	mov    0x144(%rsp),%r8d
 108ae87:	inc    %eax
 108ae89:	mov    %eax,0x140(%rsp)
 108ae90:	jmp    108aea6 <check_input_expressions+0x1c36>
 108ae92:	mov    0x100(%rsp),%rax
 108ae9a:	mov    (%rax),%rax
 108ae9d:	movb   $0x1,0x3c5(%rax)
 108aea4:	mov    %ecx,%eax
 108aea6:	cmp    %r8d,%eax
 108aea9:	jae    108aecf <check_input_expressions+0x1c5f>
 108aeab:	mov    0x118(%rsp),%rsi
 108aeb3:	mov    %eax,%r8d
 108aeb6:	movl   $0xffffffff,(%rsi,%r8,4)
 108aebe:	incl   0x140(%rsp)
 108aec5:	mov    0x144(%rsp),%r8d
 108aecd:	jmp    108aee1 <check_input_expressions+0x1c71>
 108aecf:	mov    0x100(%rsp),%rsi
 108aed7:	mov    (%rsi),%rsi
 108aeda:	movb   $0x1,0x3c5(%rsi)
 108aee1:	mov    0x13c(%rsp),%esi
 108aee8:	cmp    %r8d,%esi
 108aeeb:	jae    108b0b0 <check_input_expressions+0x1e40>
 108aef1:	mov    0x110(%rsp),%r8
 108aef9:	lea    0x1(%rsi),%r9d
 108aefd:	shl    $0x5,%rsi
 108af01:	mov    %r9d,0x13c(%rsp)
 108af09:	movl   $0x3,(%r8,%rsi,1)
 108af11:	mov    %eax,0x4(%r8,%rsi,1)
 108af16:	vmovups %xmm2,0x8(%r8,%rsi,1)
 108af1d:	movq   $0x0,0x18(%r8,%rsi,1)
 108af26:	mov    0x13c(%rsp),%esi
 108af2d:	cmp    0x144(%rsp),%esi
 108af34:	jae    108b0a6 <check_input_expressions+0x1e36>
 108af3a:	mov    0x110(%rsp),%r8
 108af42:	lea    0x1(%rsi),%r9d
 108af46:	shl    $0x5,%rsi
 108af4a:	mov    %r9d,0x13c(%rsp)
 108af52:	movabs $0xffffffff00000003,%r9
 108af5c:	vmovups %xmm3,(%r8,%rsi,1)
 108af62:	mov    %r9,0x10(%r8,%rsi,1)
 108af67:	movl   $0xffffffff,0x18(%r8,%rsi,1)
 108af70:	mov    %edx,0x1c(%r8,%rsi,1)
 108af75:	mov    0x13c(%rsp),%esi
 108af7c:	cmp    0x144(%rsp),%esi
 108af83:	jae    108b0d2 <check_input_expressions+0x1e62>
 108af89:	mov    0x98(%rsp),%r8
 108af91:	mov    %r10d,%r9d
 108af94:	mov    0x110(%rsp),%r11
 108af9c:	lea    0x1(%rsi),%r10d
 108afa0:	shl    $0x5,%rsi
 108afa4:	mov    0x2c0(%r8),%r8
 108afab:	mov    (%r8,%r9,4),%r8d
 108afaf:	mov    %r10d,0x13c(%rsp)
 108afb7:	vmovups %xmm3,(%r11,%rsi,1)
 108afbd:	movl   $0x1,0x10(%r11,%rsi,1)
 108afc6:	mov    %r8d,0x14(%r11,%rsi,1)
 108afcb:	movl   $0xffffffff,0x18(%r11,%rsi,1)
 108afd4:	mov    %eax,0x1c(%r11,%rsi,1)
 108afd9:	mov    0x13c(%rsp),%esi
 108afe0:	cmp    0x144(%rsp),%esi
 108afe7:	jae    108b596 <check_input_expressions+0x2326>
 108afed:	mov    0x110(%rsp),%r8
 108aff5:	lea    0x1(%rsi),%r9d
 108aff9:	shl    $0x5,%rsi
 108affd:	mov    %r9d,0x13c(%rsp)
 108b005:	movl   $0x3,(%r8,%rsi,1)
 108b00d:	mov    %ecx,0x4(%r8,%rsi,1)
 108b012:	vmovups %xmm2,0x8(%r8,%rsi,1)
 108b019:	movq   $0x0,0x18(%r8,%rsi,1)
 108b022:	mov    0x13c(%rsp),%esi
 108b029:	cmp    0x144(%rsp),%esi
 108b030:	jae    108b31b <check_input_expressions+0x20ab>
 108b036:	mov    0x110(%rsp),%r8
 108b03e:	lea    0x1(%rsi),%r9d
 108b042:	shl    $0x5,%rsi
 108b046:	mov    %r9d,0x13c(%rsp)
 108b04e:	movl   $0x0,(%r8,%rsi,1)
 108b056:	mov    %edi,0x4(%r8,%rsi,1)
 108b05b:	mov    %eax,0x8(%r8,%rsi,1)
 108b060:	mov    %ecx,0xc(%r8,%rsi,1)
 108b065:	vmovups %xmm2,0x10(%r8,%rsi,1)
 108b06c:	mov    0x13c(%rsp),%eax
 108b073:	cmp    0x144(%rsp),%eax
 108b07a:	jae    108b555 <check_input_expressions+0x22e5>
 108b080:	mov    0x110(%rsp),%rcx
 108b088:	lea    0x1(%rax),%esi
 108b08b:	shl    $0x5,%rax
 108b08f:	mov    %esi,0x13c(%rsp)
 108b096:	movl   $0x3,(%rcx,%rax,1)
 108b09d:	mov    %edx,0x4(%rcx,%rax,1)
 108b0a1:	jmp    108ac96 <check_input_expressions+0x1a26>
 108b0a6:	mov    0x100(%rsp),%rax
 108b0ae:	jmp    108b0c2 <check_input_expressions+0x1e52>
 108b0b0:	mov    0x100(%rsp),%rax
 108b0b8:	mov    (%rax),%rcx
 108b0bb:	movb   $0x1,0x3c5(%rcx)
 108b0c2:	mov    (%rax),%rcx
 108b0c5:	movb   $0x1,0x3c5(%rcx)
 108b0cc:	jmp    108b0da <check_input_expressions+0x1e6a>
 108b0ce:	mov    %esi,%edi
 108b0d0:	jmp    108b105 <check_input_expressions+0x1e95>
 108b0d2:	mov    0x100(%rsp),%rax
 108b0da:	mov    (%rax),%rcx
 108b0dd:	movb   $0x1,0x3c5(%rcx)
 108b0e4:	mov    (%rax),%rcx
 108b0e7:	movb   $0x1,0x3c5(%rcx)
 108b0ee:	jmp    108b323 <check_input_expressions+0x20b3>
 108b0f3:	mov    0x100(%rsp),%rax
 108b0fb:	mov    (%rax),%rax
 108b0fe:	movb   $0x1,0x3c5(%rax)
 108b105:	mov    0x13c(%rsp),%eax
 108b10c:	cmp    %r8d,%eax
 108b10f:	jae    108b159 <check_input_expressions+0x1ee9>
 108b111:	mov    0x110(%rsp),%r8
 108b119:	mov    %eax,%r9d
 108b11c:	inc    %r9d
 108b11f:	shl    $0x5,%rax
 108b123:	mov    %r9d,0x13c(%rsp)
 108b12b:	movl   $0x3,(%r8,%rax,1)
 108b133:	mov    %esi,0x4(%r8,%rax,1)
 108b138:	vmovups %xmm2,0x8(%r8,%rax,1)
 108b13f:	movq   $0x0,0x18(%r8,%rax,1)
 108b148:	mov    0x13c(%rsp),%eax
 108b14f:	mov    0x144(%rsp),%r8d
 108b157:	jmp    108b16c <check_input_expressions+0x1efc>
 108b159:	mov    0x100(%rsp),%r9
 108b161:	mov    (%r9),%r9
 108b164:	movb   $0x1,0x3c5(%r9)
 108b16c:	cmp    $0xffffffff,%r10d
 108b170:	je     108b299 <check_input_expressions+0x2029>
 108b176:	cmp    %r8d,%eax
 108b179:	jae    108b1c1 <check_input_expressions+0x1f51>
 108b17b:	mov    0x110(%rsp),%r8
 108b183:	lea    0x1(%rax),%r9d
 108b187:	mov    %eax,%eax
 108b189:	shl    $0x5,%rax
 108b18d:	mov    %r9d,0x13c(%rsp)
 108b195:	movl   $0x0,(%r8,%rax,1)
 108b19d:	mov    %r10d,0x4(%r8,%rax,1)
 108b1a2:	vmovq  %xmm0,0x8(%r8,%rax,1)
 108b1a9:	vmovups %xmm2,0x10(%r8,%rax,1)
 108b1b0:	mov    0x13c(%rsp),%eax
 108b1b7:	mov    0x144(%rsp),%r8d
 108b1bf:	jmp    108b1d4 <check_input_expressions+0x1f64>
 108b1c1:	mov    0x100(%rsp),%r9
 108b1c9:	mov    (%r9),%r9
 108b1cc:	movb   $0x1,0x3c5(%r9)
 108b1d4:	cmp    %r8d,%eax
 108b1d7:	jae    108b221 <check_input_expressions+0x1fb1>
 108b1d9:	mov    0x110(%rsp),%r8
 108b1e1:	lea    0x1(%rax),%r9d
 108b1e5:	mov    %eax,%eax
 108b1e7:	shl    $0x5,%rax
 108b1eb:	mov    %r9d,0x13c(%rsp)
 108b1f3:	movl   $0x3,(%r8,%rax,1)
 108b1fb:	mov    %edi,0x4(%r8,%rax,1)
 108b200:	vmovups %xmm2,0x8(%r8,%rax,1)
 108b207:	movq   $0x0,0x18(%r8,%rax,1)
 108b210:	mov    0x13c(%rsp),%eax
 108b217:	mov    0x144(%rsp),%r8d
 108b21f:	jmp    108b234 <check_input_expressions+0x1fc4>
 108b221:	mov    0x100(%rsp),%r9
 108b229:	mov    (%r9),%r9
 108b22c:	movb   $0x1,0x3c5(%r9)
 108b234:	cmp    %r8d,%eax
 108b237:	jae    108b287 <check_input_expressions+0x2017>
 108b239:	mov    0x110(%rsp),%r8
 108b241:	lea    0x1(%rax),%r9d
 108b245:	mov    %eax,%eax
 108b247:	shl    $0x5,%rax
 108b24b:	mov    %r9d,0x13c(%rsp)
 108b253:	movabs $0xffffffff00000003,%r9
 108b25d:	vmovups %xmm3,(%r8,%rax,1)
 108b263:	mov    %r9,0x10(%r8,%rax,1)
 108b268:	movl   $0xffffffff,0x18(%r8,%rax,1)
 108b271:	mov    %esi,0x1c(%r8,%rax,1)
 108b276:	mov    0x13c(%rsp),%eax
 108b27d:	mov    0x144(%rsp),%r8d
 108b285:	jmp    108b299 <check_input_expressions+0x2029>
 108b287:	mov    0x100(%rsp),%rsi
 108b28f:	mov    (%rsi),%rsi
 108b292:	movb   $0x1,0x3c5(%rsi)
 108b299:	cmp    %r8d,%eax
 108b29c:	jae    108b31b <check_input_expressions+0x20ab>
 108b29e:	mov    0x110(%rsp),%rsi
 108b2a6:	lea    0x1(%rax),%r8d
 108b2aa:	mov    %eax,%eax
 108b2ac:	shl    $0x5,%rax
 108b2b0:	mov    %r8d,0x13c(%rsp)
 108b2b8:	movl   $0x0,(%rsi,%rax,1)
 108b2bf:	mov    %edx,0x4(%rsi,%rax,1)
 108b2c3:	vmovq  %xmm0,0x8(%rsi,%rax,1)
 108b2c9:	vmovups %xmm2,0x10(%rsi,%rax,1)
 108b2cf:	mov    0x13c(%rsp),%eax
 108b2d6:	cmp    0x144(%rsp),%eax
 108b2dd:	jae    108b555 <check_input_expressions+0x22e5>
 108b2e3:	mov    0x110(%rsp),%rdx
 108b2eb:	lea    0x1(%rax),%esi
 108b2ee:	shl    $0x5,%rax
 108b2f2:	mov    %esi,0x13c(%rsp)
 108b2f9:	vmovups %xmm3,(%rdx,%rax,1)
 108b2fe:	movl   $0x1,0x10(%rdx,%rax,1)
 108b306:	mov    %ecx,0x14(%rdx,%rax,1)
 108b30a:	movl   $0xffffffff,0x18(%rdx,%rax,1)
 108b312:	mov    %edi,0x1c(%rdx,%rax,1)
 108b316:	jmp    108b570 <check_input_expressions+0x2300>
 108b31b:	mov    0x100(%rsp),%rax
 108b323:	mov    (%rax),%rcx
 108b326:	movb   $0x1,0x3c5(%rcx)
 108b32d:	jmp    108b55d <check_input_expressions+0x22ed>
 108b332:	mov    0x100(%rsp),%rax
 108b33a:	mov    (%rax),%rdx
 108b33d:	movb   $0x1,0x3c5(%rdx)
 108b344:	mov    (%rax),%rax
 108b347:	mov    0x48(%rsp),%rdx
 108b34c:	movb   $0x1,0x3c5(%rax)
 108b353:	mov    0x128(%rsp),%rax
 108b35b:	jmp    108b38d <check_input_expressions+0x211d>
 108b35d:	mov    0x100(%rsp),%rax
 108b365:	mov    (%rax),%rsi
 108b368:	movb   $0x1,0x3c5(%rsi)
 108b36f:	mov    (%rax),%rsi
 108b372:	movb   $0x1,0x3c5(%rsi)
 108b379:	mov    (%rax),%rax
 108b37c:	movb   $0x1,0x3c5(%rax)
 108b383:	mov    0x130(%rsp),%rax
 108b38b:	sub    %edi,%edx
 108b38d:	mov    (%rax,%rdx,4),%edx
 108b390:	cmp    $0xffffffff,%edx
 108b393:	je     108b513 <check_input_expressions+0x22a3>
 108b399:	mov    0x2c0(%r15),%rax
 108b3a0:	mov    %edx,%esi
 108b3a2:	mov    (%rax,%rsi,4),%eax
 108b3a5:	cmp    $0xffffffff,%eax
 108b3a8:	je     108b383 <check_input_expressions+0x2113>
 108b3aa:	mov    0x140(%rsp),%esi
 108b3b1:	mov    0x144(%rsp),%r9d
 108b3b9:	cmp    %r9d,%esi
 108b3bc:	jae    108b3f0 <check_input_expressions+0x2180>
 108b3be:	mov    0x118(%rsp),%r8
 108b3c6:	movl   $0xffffffff,(%r8,%rsi,4)
 108b3ce:	incl   0x140(%rsp)
 108b3d5:	mov    0x144(%rsp),%r9d
 108b3dd:	mov    0x13c(%rsp),%r8d
 108b3e5:	cmp    %r9d,%r8d
 108b3e8:	jae    108b35d <check_input_expressions+0x20ed>
 108b3ee:	jmp    108b414 <check_input_expressions+0x21a4>
 108b3f0:	mov    0x100(%rsp),%r8
 108b3f8:	mov    (%r8),%r8
 108b3fb:	movb   $0x1,0x3c5(%r8)
 108b403:	mov    0x13c(%rsp),%r8d
 108b40b:	cmp    %r9d,%r8d
 108b40e:	jae    108b35d <check_input_expressions+0x20ed>
 108b414:	mov    0x110(%rsp),%r9
 108b41c:	lea    0x1(%r8),%r10d
 108b420:	shl    $0x5,%r8
 108b424:	mov    %r10d,0x13c(%rsp)
 108b42c:	movl   $0x3,(%r9,%r8,1)
 108b434:	mov    %esi,0x4(%r9,%r8,1)
 108b439:	vmovups %xmm2,0x8(%r9,%r8,1)
 108b440:	movq   $0x0,0x18(%r9,%r8,1)
 108b449:	mov    0x13c(%rsp),%r8d
 108b451:	cmp    0x144(%rsp),%r8d
 108b459:	jae    108b4f9 <check_input_expressions+0x2289>
 108b45f:	mov    0x120(%rsp),%r10
 108b467:	mov    %edx,%r11d
 108b46a:	sub    %edi,%r11d
 108b46d:	mov    0x110(%rsp),%r9
 108b475:	mov    (%r10,%r11,4),%r10d
 108b479:	lea    0x1(%r8),%r11d
 108b47d:	shl    $0x5,%r8
 108b481:	mov    %r11d,0x13c(%rsp)
 108b489:	movabs $0xffffffff00000003,%r11
 108b493:	vmovups %xmm3,(%r9,%r8,1)
 108b499:	mov    %r11,0x10(%r9,%r8,1)
 108b49e:	movl   $0xffffffff,0x18(%r9,%r8,1)
 108b4a7:	mov    %r10d,0x1c(%r9,%r8,1)
 108b4ac:	mov    0x13c(%rsp),%r8d
 108b4b4:	cmp    0x144(%rsp),%r8d
 108b4bc:	jae    108b506 <check_input_expressions+0x2296>
 108b4be:	mov    0x110(%rsp),%r9
 108b4c6:	lea    0x1(%r8),%r10d
 108b4ca:	shl    $0x5,%r8
 108b4ce:	mov    %r10d,0x13c(%rsp)
 108b4d6:	vmovups %xmm3,(%r9,%r8,1)
 108b4dc:	movl   $0x2,0x10(%r9,%r8,1)
 108b4e5:	mov    %ecx,0x14(%r9,%r8,1)
 108b4ea:	mov    %eax,0x18(%r9,%r8,1)
 108b4ef:	mov    %esi,0x1c(%r9,%r8,1)
 108b4f4:	jmp    108b383 <check_input_expressions+0x2113>
 108b4f9:	mov    0x100(%rsp),%rax
 108b501:	jmp    108b36f <check_input_expressions+0x20ff>
 108b506:	mov    0x100(%rsp),%rax
 108b50e:	jmp    108b379 <check_input_expressions+0x2109>
 108b513:	mov    0x13c(%rsp),%eax
 108b51a:	cmp    0x144(%rsp),%eax
 108b521:	jae    108b555 <check_input_expressions+0x22e5>
 108b523:	mov    0x110(%rsp),%rdx
 108b52b:	lea    0x1(%rax),%esi
 108b52e:	shl    $0x5,%rax
 108b532:	mov    %esi,0x13c(%rsp)
 108b539:	movl   $0x2,(%rdx,%rax,1)
 108b540:	vmovups %xmm2,0x4(%rdx,%rax,1)
 108b546:	mov    %ecx,0x14(%rdx,%rax,1)
 108b54a:	movq   $0xffffffffffffffff,0x18(%rdx,%rax,1)
 108b553:	jmp    108b570 <check_input_expressions+0x2300>
 108b555:	mov    0x100(%rsp),%rax
 108b55d:	mov    (%rax),%rax
 108b560:	movb   $0x1,0x3c5(%rax)
 108b567:	nopw   0x0(%rax,%rax,1)
 108b570:	mov    0x13c(%rsp),%r14d
 108b578:	movzbl 0x148(%rsp),%eax
 108b580:	test   %r14d,%r14d
 108b583:	je     1089f04 <check_input_expressions+0xc94>
 108b589:	test   %al,%al
 108b58b:	je     1089f60 <check_input_expressions+0xcf0>
 108b591:	jmp    1089f04 <check_input_expressions+0xc94>
 108b596:	mov    0x100(%rsp),%rax
 108b59e:	jmp    108b0e4 <check_input_expressions+0x1e74>
 108b5a3:	mov    0x100(%rsp),%rax
 108b5ab:	jmp    108b344 <check_input_expressions+0x20d4>
 108b5b0:	mov    (%r12),%rax
 108b5b4:	movb   $0x1,0x3c5(%rax)
 108b5bb:	mov    (%r12),%rcx
 108b5bf:	mov    $0xffffffff,%r14d
 108b5c5:	mov    $0xffffffff,%r9d
 108b5cb:	cmpb   $0x0,0x3c5(%rcx)
 108b5d2:	je     108b5de <check_input_expressions+0x236e>
 108b5d4:	mov    0x30(%rsp),%r10
 108b5d9:	jmp    108b6b0 <check_input_expressions+0x2440>
 108b5de:	mov    0x138(%rsp),%eax
 108b5e5:	mov    0x30(%rsp),%r10
 108b5ea:	add    $0x3c5,%rcx
 108b5f1:	mov    %rax,%rdx
 108b5f4:	shl    $0x4,%rdx
 108b5f8:	dec    %rax
 108b5fb:	or     $0xc,%rdx
 108b5ff:	jmp    108b62f <check_input_expressions+0x23bf>
 108b601:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 108b610:	movb   $0x1,(%rcx)
 108b613:	mov    (%r12),%rsi
 108b617:	add    $0x10,%rdx
 108b61b:	cmpb   $0x0,0x3c5(%rsi)
 108b622:	lea    0x3c5(%rsi),%rcx
 108b629:	jne    108b6b0 <check_input_expressions+0x2440>
 108b62f:	mov    0x138(%r13),%esi
 108b636:	inc    %rax
 108b639:	cmp    %rsi,%rax
 108b63c:	jae    108b66c <check_input_expressions+0x23fc>
 108b63e:	mov    0x130(%r13),%rsi
 108b645:	mov    (%rsi,%rdx,1),%edi
 108b648:	cmp    %r9,%rdi
 108b64b:	je     108b613 <check_input_expressions+0x23a3>
 108b64d:	cmp    0x140(%rsp),%edi
 108b654:	jae    108b610 <check_input_expressions+0x23a0>
 108b656:	mov    0x118(%rsp),%r8
 108b65e:	mov    (%r8,%rdi,4),%edi
 108b662:	cmp    $0xffffffff,%edi
 108b665:	je     108b610 <check_input_expressions+0x23a0>
 108b667:	mov    %edi,(%rsi,%rdx,1)
 108b66a:	jmp    108b613 <check_input_expressions+0x23a3>
 108b66c:	mov    0x128(%r13),%r14d
 108b673:	lea    0x1(%r14),%eax
 108b677:	mov    %r14,%rcx
 108b67a:	shl    $0x4,%rcx
 108b67e:	mov    %eax,0x128(%r13)
 108b685:	mov    0x138(%rsp),%edx
 108b68c:	mov    0x120(%r13),%rax
 108b693:	movzbl 0x148(%rsp),%edi
 108b69b:	sub    %edx,%esi
 108b69d:	movl   $0xffffffff,(%rax,%rcx,1)
 108b6a4:	mov    %edx,0x4(%rax,%rcx,1)
 108b6a8:	mov    %esi,0x8(%rax,%rcx,1)
 108b6ac:	mov    %edi,0xc(%rax,%rcx,1)
 108b6b0:	mov    0x28(%r12),%rax
 108b6b5:	mov    0x78(%rsp),%rcx
 108b6ba:	cmp    0x8(%rax),%rcx
 108b6be:	ja     108eb75 <check_input_expressions+0x5905>
 108b6c4:	mov    %rcx,0x8(%rax)
 108b6c8:	mov    $0x37,%esi
 108b6cd:	mov    $0xffffffff,%r8d
 108b6d3:	mov    $0xffffffff,%r9d
 108b6d9:	mov    0x8(%rsp),%rdx
 108b6de:	mov    %r12,%rdi
 108b6e1:	mov    0x10(%r10),%ecx
 108b6e5:	vzeroupper
 108b6e8:	call   10fb220 <check_input_add>
 108b6ed:	mov    %eax,%r15d
 108b6f0:	xor    %esi,%esi
 108b6f2:	cmp    $0xffffffff,%r14d
 108b6f6:	je     108b73b <check_input_expressions+0x24cb>
 108b6f8:	vpmovsxbq -0xbeda81(%rip),%xmm3        # 49dc80 <cbuiltin_test_generated.edges+0x3e40>
 108b701:	mov    0x10(%rsp),%r9
 108b706:	mov    0x4(%rsp),%r8d
 108b70b:	mov    $0xffffffff,%r11d
 108b711:	vxorps %xmm2,%xmm2,%xmm2
 108b715:	cmp    $0xffffffff,%r15d
 108b719:	je     108e195 <check_input_expressions+0x4f25>
 108b71f:	mov    0x68(%rsp),%rax
 108b724:	mov    %r14d,%ecx
 108b727:	shl    $0x4,%rcx
 108b72b:	mov    0x120(%rax),%rax
 108b732:	mov    %r15d,(%rax,%rcx,1)
 108b736:	jmp    108e19f <check_input_expressions+0x4f2f>
 108b73b:	vpmovsxbq -0xbedac4(%rip),%xmm3        # 49dc80 <cbuiltin_test_generated.edges+0x3e40>
 108b744:	mov    0x10(%rsp),%r9
 108b749:	mov    0x4(%rsp),%r8d
 108b74e:	vxorps %xmm2,%xmm2,%xmm2
 108b752:	mov    $0xffffffff,%r11d
 108b758:	cmp    $0xffffffff,%r15d
 108b75c:	jne    108e19f <check_input_expressions+0x4f2f>
 108b762:	jmp    10896d6 <check_input_expressions+0x466>
 108b767:	mov    %rax,%rcx
 108b76a:	and    $0xfffffffc,%eax
 108b76d:	mov    $0x1,%r14b
 108b770:	cmp    $0x3c,%eax
 108b773:	jne    108b8e4 <check_input_expressions+0x2674>
 108b779:	mov    $0x1,%al
 108b77b:	mov    %eax,0x8c(%rsp)
 108b782:	jmp    108b8fb <check_input_expressions+0x268b>
 108b787:	mov    0x250(%r12),%rax
 108b78f:	mov    %r14,%rbx
 108b792:	mov    (%r12),%r13
 108b796:	mov    (%rax,%r14,4),%r14d
 108b79a:	test   %r14d,%r14d
 108b79d:	je     108b90a <check_input_expressions+0x269a>
 108b7a3:	cmp    0x338(%r13),%r14d
 108b7aa:	ja     10892e0 <check_input_expressions+0x70>
 108b7b0:	mov    0x330(%r13),%rcx
 108b7b7:	mov    0x18(%r12),%rdx
 108b7bc:	lea    -0x1(%r14),%eax
 108b7c0:	lea    (%rax,%rax,8),%rax
 108b7c4:	mov    0x4(%rcx,%rax,4),%esi
 108b7c8:	mov    0x30(%rdx),%rdx
 108b7cc:	and    $0xfffffff8,%esi
 108b7cf:	cmpq   $0x0,(%rdx,%rsi,1)
 108b7d4:	je     10892e0 <check_input_expressions+0x70>
 108b7da:	lea    (%rcx,%rax,4),%rbp
 108b7de:	mov    0x8(%rbp),%ecx
 108b7e1:	mov    0xc(%rbp),%edx
 108b7e4:	cmp    %edx,%ecx
 108b7e6:	jae    108ca0e <check_input_expressions+0x379e>
 108b7ec:	mov    0x8(%r12),%rbx
 108b7f1:	mov    %rdx,%r9
 108b7f4:	sub    %rcx,%r9
 108b7f7:	mov    %rcx,%rax
 108b7fa:	sub    %rdx,%rax
 108b7fd:	mov    %r9d,%edi
 108b800:	and    $0x7,%edi
 108b803:	mov    0x60(%rbx),%rsi
 108b807:	cmp    $0xfffffffffffffff8,%rax
 108b80b:	jbe    108c7d9 <check_input_expressions+0x3569>
 108b811:	xor    %r10d,%r10d
 108b814:	mov    $0xffffffff,%r15d
 108b81a:	mov    %rcx,%r8
 108b81d:	jmp    108c949 <check_input_expressions+0x36d9>
 108b822:	mov    %rsi,%rdi
 108b825:	sub    %r8,%rdi
 108b828:	mov    0x10(%rcx),%r8
 108b82c:	sub    %rdi,%r8
 108b82f:	jb     1089598 <check_input_expressions+0x328>
 108b835:	mov    %rdx,%r9
 108b838:	shl    $0x5,%r9
 108b83c:	cmp    %r8,%r9
 108b83f:	ja     1089598 <check_input_expressions+0x328>
 108b845:	add    %r9,%rdi
 108b848:	mov    %rdi,0x8(%rcx)
 108b84c:	mov    0x28(%r12),%rcx
 108b851:	mov    %rsi,0x110(%rsp)
 108b859:	mov    (%rcx),%r8
 108b85c:	mov    0x8(%rcx),%rdi
 108b860:	lea    0x3(%rdi,%r8,1),%rsi
 108b865:	add    %r8,%rdi
 108b868:	and    $0xfffffffffffffffc,%rsi
 108b86c:	cmp    %rdi,%rsi
 108b86f:	jae    108b875 <check_input_expressions+0x2605>
 108b871:	xor    %esi,%esi
 108b873:	jmp    108b899 <check_input_expressions+0x2629>
 108b875:	mov    %rsi,%rdi
 108b878:	sub    %r8,%rdi
 108b87b:	mov    0x10(%rcx),%r8
 108b87f:	sub    %rdi,%r8
 108b882:	jb     108b871 <check_input_expressions+0x2601>
 108b884:	shl    $0x2,%rdx
 108b888:	cmp    %r8,%rdx
 108b88b:	ja     108b871 <check_input_expressions+0x2601>
 108b88d:	add    %rdx,%rdi
 108b890:	mov    %rdi,0x8(%rcx)
 108b894:	mov    0x28(%r12),%rcx
 108b899:	inc    %rax
 108b89c:	mov    %rsi,0x118(%rsp)
 108b8a4:	mov    %rax,%rdx
 108b8a7:	shr    $0x3e,%rdx
 108b8ab:	je     108b8c1 <check_input_expressions+0x2651>
 108b8ad:	lea    0x110(%rsp),%rax
 108b8b5:	xor    %edx,%edx
 108b8b7:	vmovups %xmm2,0x10(%rax)
 108b8bc:	jmp    108b9e0 <check_input_expressions+0x2770>
 108b8c1:	mov    (%rcx),%rdi
 108b8c4:	mov    0x8(%rcx),%rsi
 108b8c8:	shl    $0x2,%rax
 108b8cc:	lea    0x3(%rsi,%rdi,1),%rdx
 108b8d1:	add    %rdi,%rsi
 108b8d4:	and    $0xfffffffffffffffc,%rdx
 108b8d8:	cmp    %rsi,%rdx
 108b8db:	jae    108b954 <check_input_expressions+0x26e4>
 108b8dd:	xor    %edx,%edx
 108b8df:	jmp    108b97c <check_input_expressions+0x270c>
 108b8e4:	lea    -0x42(%rcx),%eax
 108b8e7:	cmp    $0x3,%eax
 108b8ea:	jae    108ba25 <check_input_expressions+0x27b5>
 108b8f0:	movl   $0x0,0x8c(%rsp)
 108b8fb:	mov    0x8(%rsp),%rdx
 108b900:	mov    $0xffffffff,%ecx
 108b905:	jmp    108ba69 <check_input_expressions+0x27f9>
 108b90a:	mov    0x350(%r13),%rax
 108b911:	cmpl   $0x0,(%rax,%rbx,4)
 108b915:	je     108c23b <check_input_expressions+0x2fcb>
 108b91b:	mov    %r15d,%eax
 108b91e:	and    $0xfe,%al
 108b920:	cmp    $0x3c,%al
 108b922:	jne    10892e0 <check_input_expressions+0x70>
 108b928:	mov    0x2c0(%r13),%rcx
 108b92f:	mov    0x8(%rsp),%rdx
 108b934:	mov    $0xffffffff,%r15d
 108b93a:	cmp    $0x1,%ebp
 108b93d:	mov    $0xffffffff,%eax
 108b942:	cmove  %r8d,%eax
 108b946:	mov    %eax,(%rcx,%rdx,4)
 108b949:	je     10892e0 <check_input_expressions+0x70>
 108b94f:	jmp    108e182 <check_input_expressions+0x4f12>
 108b954:	mov    %rdx,%rsi
 108b957:	sub    %rdi,%rsi
 108b95a:	mov    0x10(%rcx),%rdi
 108b95e:	sub    %rsi,%rdi
 108b961:	jb     108b8dd <check_input_expressions+0x266d>
 108b967:	cmp    %rdi,%rax
 108b96a:	ja     108b8dd <check_input_expressions+0x266d>
 108b970:	add    %rax,%rsi
 108b973:	mov    %rsi,0x8(%rcx)
 108b977:	mov    0x28(%r12),%rcx
 108b97c:	mov    %rdx,0x120(%rsp)
 108b984:	mov    (%rcx),%rdi
 108b987:	mov    0x8(%rcx),%rsi
 108b98b:	lea    0x3(%rsi,%rdi,1),%rdx
 108b990:	add    %rdi,%rsi
 108b993:	and    $0xfffffffffffffffc,%rdx
 108b997:	cmp    %rsi,%rdx
 108b99a:	jae    108b9a0 <check_input_expressions+0x2730>
 108b99c:	xor    %edx,%edx
 108b99e:	jmp    108b9c0 <check_input_expressions+0x2750>
 108b9a0:	mov    %rdx,%rsi
 108b9a3:	sub    %rdi,%rsi
 108b9a6:	mov    0x10(%rcx),%rdi
 108b9aa:	sub    %rsi,%rdi
 108b9ad:	jb     108b99c <check_input_expressions+0x272c>
 108b9af:	cmp    %rdi,%rax
 108b9b2:	ja     108b99c <check_input_expressions+0x272c>
 108b9b4:	add    %rax,%rsi
 108b9b7:	mov    %rsi,0x8(%rcx)
 108b9bb:	mov    0x28(%r12),%rcx
 108b9c0:	mov    %rdx,0x128(%rsp)
 108b9c8:	mov    (%rcx),%rsi
 108b9cb:	mov    0x8(%rcx),%rdi
 108b9cf:	lea    0x3(%rdi,%rsi,1),%r8
 108b9d4:	add    %rsi,%rdi
 108b9d7:	and    $0xfffffffffffffffc,%r8
 108b9db:	cmp    %rdi,%r8
 108b9de:	jae    108b9e9 <check_input_expressions+0x2779>
 108b9e0:	xor    %esi,%esi
 108b9e2:	xor    %edi,%edi
 108b9e4:	jmp    1089738 <check_input_expressions+0x4c8>
 108b9e9:	mov    0x10(%rcx),%r10
 108b9ed:	mov    %r8,%r9
 108b9f0:	sub    %rsi,%r9
 108b9f3:	xor    %edi,%edi
 108b9f5:	mov    $0x0,%esi
 108b9fa:	sub    %r9,%r10
 108b9fd:	jb     1089738 <check_input_expressions+0x4c8>
 108ba03:	cmp    %r10,%rax
 108ba06:	ja     1089738 <check_input_expressions+0x4c8>
 108ba0c:	add    %rax,%r9
 108ba0f:	xor    %esi,%esi
 108ba11:	mov    %r8,%rdi
 108ba14:	mov    %r9,0x8(%rcx)
 108ba18:	mov    0x128(%rsp),%rdx
 108ba20:	jmp    1089738 <check_input_expressions+0x4c8>
 108ba25:	mov    0x8(%rsp),%r14
 108ba2a:	mov    %ecx,%eax
 108ba2c:	and    $0xfffffffe,%eax
 108ba2f:	mov    %r8d,%r13d
 108ba32:	cmp    $0x1e,%eax
 108ba35:	jne    108c276 <check_input_expressions+0x3006>
 108ba3b:	mov    0xa8(%r12),%rax
 108ba43:	mov    %ebp,%ecx
 108ba45:	xor    $0x1,%ecx
 108ba48:	mov    %r13d,%r8d
 108ba4b:	mov    %r14,%rdx
 108ba4e:	movl   $0x0,0x8c(%rsp)
 108ba59:	or     (%rax,%r14,4),%ecx
 108ba5d:	mov    $0xffffffff,%ecx
 108ba62:	cmove  %r13d,%ecx
 108ba66:	xor    %r14d,%r14d
 108ba69:	mov    0x208(%r12),%rax
 108ba71:	mov    %r8d,0x4(%rsp)
 108ba76:	movzwl (%rax,%rdx,2),%eax
 108ba7a:	add    $0xfffffead,%eax
 108ba7f:	cmp    $0x5,%ax
 108ba83:	ja     108bb71 <check_input_expressions+0x2901>
 108ba89:	mov    $0x24,%esi
 108ba8e:	mov    $0xffffffff,%r8d
 108ba94:	mov    $0xffffffff,%r9d
 108ba9a:	mov    %r12,%rdi
 108ba9d:	vzeroupper
 108baa0:	call   10fb220 <check_input_add>
 108baa5:	mov    $0xffffffff,%ecx
 108baaa:	cmp    $0xffffffff,%eax
 108baad:	je     108bb71 <check_input_expressions+0x2901>
 108bab3:	mov    0x208(%r12),%rcx
 108babb:	mov    0x8(%rsp),%rdx
 108bac0:	mov    $0xaaaaaaab,%esi
 108bac5:	movzwl (%rcx,%rdx,2),%ecx
 108bac9:	add    $0xfffffead,%ecx
 108bacf:	mov    %rcx,%rdx
 108bad2:	imul   %rsi,%rdx
 108bad6:	shr    $0x21,%rdx
 108bada:	lea    (%rdx,%rdx,2),%esi
 108badd:	mov    0x18(%r12),%rdx
 108bae2:	sub    %esi,%ecx
 108bae4:	xor    %esi,%esi
 108bae6:	cmp    $0x2,%ecx
 108bae9:	sete   %sil
 108baed:	cmp    $0x1,%ecx
 108baf0:	lea    0xa0(,%rsi,8),%ecx
 108baf7:	mov    $0x98,%esi
 108bafc:	cmove  %esi,%ecx
 108baff:	mov    %ecx,%esi
 108bb01:	shr    $0x3,%esi
 108bb04:	cmp    0x48(%rdx),%esi
 108bb07:	jae    108bb1a <check_input_expressions+0x28aa>
 108bb09:	mov    (%rdx),%rdi
 108bb0c:	cmpb   $0x0,(%rdi,%rsi,1)
 108bb10:	je     108bb1a <check_input_expressions+0x28aa>
 108bb12:	or     $0x100,%ecx
 108bb18:	jmp    108bb61 <check_input_expressions+0x28f1>
 108bb1a:	mov    0x108(%rdx),%rcx
 108bb21:	movl   $0x2,0x100(%rdx)
 108bb2b:	test   %rcx,%rcx
 108bb2e:	je     108bb46 <check_input_expressions+0x28d6>
 108bb30:	movb   $0x1,0x3c(%rcx)
 108bb34:	mov    0x30(%rcx),%rdx
 108bb38:	mov    %rdx,0x40(%rcx)
 108bb3c:	movl   $0x2,0x48(%rcx)
 108bb43:	incl   0x34(%rcx)
 108bb46:	mov    0x18(%r12),%rdx
 108bb4b:	xor    %ecx,%ecx
 108bb4d:	cmpl   $0x1,0x100(%rdx)
 108bb54:	jne    108bb61 <check_input_expressions+0x28f1>
 108bb56:	mov    (%r12),%rdx
 108bb5a:	movb   $0x1,0x3c5(%rdx)
 108bb61:	mov    0x68(%rsp),%rdx
 108bb66:	mov    %eax,%esi
 108bb68:	mov    0x30(%rdx),%rdx
 108bb6c:	mov    %ecx,(%rdx,%rsi,4)
 108bb6f:	mov    %eax,%ecx
 108bb71:	mov    0x18(%rsp),%edx
 108bb75:	mov    0x30(%rsp),%rax
 108bb7a:	mov    $0x1,%sil
 108bb7d:	cmp    $0x9,%r15b
 108bb81:	jne    108be7a <check_input_expressions+0x2c0a>
 108bb87:	mov    0x30(%rsp),%rax
 108bb8c:	mov    %ecx,0xa4(%rsp)
 108bb93:	mov    %ebp,%ecx
 108bb95:	xor    $0x17,%eax
 108bb98:	xor    $0x2,%ecx
 108bb9b:	or     %eax,%ecx
 108bb9d:	mov    0x30(%rsp),%rax
 108bba2:	sete   %r15b
 108bba6:	cmp    $0x43,%eax
 108bba9:	sete   %cl
 108bbac:	mov    %rcx,0x80(%rsp)
 108bbb4:	jne    108bebc <check_input_expressions+0x2c4c>
 108bbba:	mov    (%r12),%r14
 108bbbe:	mov    0x8(%rsp),%rdx
 108bbc3:	mov    0x280(%r12),%rdi
 108bbcb:	mov    %sil,0x57(%rsp)
 108bbd0:	xor    %esi,%esi
 108bbd2:	mov    0x218(%r14),%rcx
 108bbd9:	mov    0x208(%r14),%r13
 108bbe0:	mov    0x1f8(%r14),%rax
 108bbe7:	mov    (%rcx,%rdx,4),%ebx
 108bbea:	shl    $0x5,%rbx
 108bbee:	mov    -0x20(%r13,%rbx,1),%ecx
 108bbf3:	mov    -0x14(%r13,%rbx,1),%edx
 108bbf8:	imul   $0x130,%rcx,%rcx
 108bbff:	cmpb   $0x0,(%rdi,%rdx,1)
 108bc03:	mov    (%rax,%rcx,1),%rdi
 108bc07:	mov    0x118(%rax,%rcx,1),%rax
 108bc0f:	setne  %sil
 108bc13:	mov    %rax,0x48(%rsp)
 108bc18:	vzeroupper
 108bc1b:	call   10a1510 <check_graph_x86_ice_mask>
 108bc20:	cmpl   $0x0,-0xc(%r13,%rbx,1)
 108bc26:	mov    0xb8(%r14),%edi
 108bc2d:	mov    0x40(%rsp),%ecx
 108bc31:	mov    %rax,%rdx
 108bc34:	sete   %sil
 108bc38:	xor    $0x1,%cl
 108bc3b:	mov    %edi,0x88(%rsp)
 108bc42:	or     %sil,%cl
 108bc45:	jne    108bed5 <check_input_expressions+0x2c65>
 108bc4b:	mov    %r13,%r8
 108bc4e:	or     0x48(%rsp),%rdx
 108bc53:	mov    0x4(%rsp),%r13d
 108bc58:	add    %rbx,%r8
 108bc5b:	mov    %r15b,0x67(%rsp)
 108bc60:	mov    %r14,%rdi
 108bc63:	xor    %r15d,%r15d
 108bc66:	movq   $0x0,0x90(%rsp)
 108bc72:	mov    %r14,0xa8(%rsp)
 108bc7a:	mov    %r8,0x98(%rsp)
 108bc82:	mov    %rdx,0xb0(%rsp)
 108bc8a:	nopw   0x0(%rax,%rax,1)
 108bc90:	mov    0x390(%r12),%rax
 108bc98:	mov    %r13d,%r14d
 108bc9b:	vpxor  %xmm0,%xmm0,%xmm0
 108bc9f:	mov    (%rax,%r14,4),%r9d
 108bca3:	vmovdqu64 %zmm0,0x120(%rsp)
 108bcae:	vmovdqu64 %zmm0,0x100(%rsp)
 108bcb6:	mov    -0x8(%r8),%rax
 108bcba:	mov    (%rax,%r15,8),%esi
 108bcbe:	cmp    $0x3f,%r15
 108bcc2:	ja     108bdfd <check_input_expressions+0x2b8d>
 108bcc8:	mov    0x4(%rax,%r15,8),%edx
 108bccd:	mov    %r9d,0x48(%rsp)
 108bcd2:	mov    %r12,%rdi
 108bcd5:	mov    %esi,0x78(%rsp)
 108bcd9:	xor    %ecx,%ecx
 108bcdb:	mov    $0x1,%r8d
 108bce1:	lea    0x100(%rsp),%r9
 108bce9:	push   $0x0
 108bceb:	lea    0xe8(%rsp),%rax
 108bcf3:	push   %rax
 108bcf4:	vzeroupper
 108bcf7:	call   10c24f0 <check_input_constant_read>
 108bcfc:	add    $0x10,%rsp
 108bd00:	test   %al,%al
 108bd02:	je     108bde4 <check_input_expressions+0x2b74>
 108bd08:	cmpl   $0x0,0x154(%rsp)
 108bd10:	mov    0xa8(%rsp),%rdi
 108bd18:	mov    0x98(%rsp),%r8
 108bd20:	mov    0x48(%rsp),%r9d
 108bd25:	mov    0x78(%rsp),%esi
 108bd29:	jne    108bdfd <check_input_expressions+0x2b8d>
 108bd2f:	cmpl   $0x1,0x10c(%rsp)
 108bd37:	jne    108bdfd <check_input_expressions+0x2b8d>
 108bd3d:	mov    0x108(%rsp),%eax
 108bd44:	mov    %eax,%ecx
 108bd46:	and    $0x10,%ecx
 108bd49:	shr    $0x4,%ecx
 108bd4c:	test   $0x401,%eax
 108bd51:	sete   %al
 108bd54:	or     %cl,%al
 108bd56:	jne    108bdfd <check_input_expressions+0x2b8d>
 108bd5c:	mov    0x90(%rsp),%rax
 108bd64:	mov    0xb0(%rsp),%rcx
 108bd6c:	bts    %r15,%rax
 108bd70:	bt     %r15,%rcx
 108bd74:	mov    %rax,0x90(%rsp)
 108bd7c:	jae    108bdfd <check_input_expressions+0x2b8d>
 108bd7e:	mov    0x8(%rdi),%rax
 108bd82:	mov    $0xffffffff,%ecx
 108bd87:	mov    $0xffffffff,%r8d
 108bd8d:	mov    $0xffffffff,%r9d
 108bd93:	xor    %esi,%esi
 108bd95:	mov    (%rax,%r14,4),%edx
 108bd99:	mov    %rdi,%r14
 108bd9c:	mov    %r12,%rdi
 108bd9f:	call   10fb220 <check_input_add>
 108bda4:	cmp    $0xffffffff,%eax
 108bda7:	je     108bddf <check_input_expressions+0x2b6f>
 108bda9:	vmovdqu64 0x100(%rsp),%zmm0
 108bdb1:	vmovups 0x120(%rsp),%zmm1
 108bdbc:	mov    0x28(%r14),%rcx
 108bdc0:	mov    %eax,%edx
 108bdc2:	lea    (%rdx,%rdx,2),%rdx
 108bdc6:	mov    %eax,%r13d
 108bdc9:	shl    $0x5,%rdx
 108bdcd:	vmovups %zmm1,0x20(%rcx,%rdx,1)
 108bdd8:	vmovdqu64 %zmm0,(%rcx,%rdx,1)
 108bddf:	mov    %r14,%rdi
 108bde2:	jmp    108bdec <check_input_expressions+0x2b7c>
 108bde4:	mov    0xa8(%rsp),%rdi
 108bdec:	mov    0x98(%rsp),%r8
 108bdf4:	mov    0x48(%rsp),%r9d
 108bdf9:	mov    0x78(%rsp),%esi
 108bdfd:	mov    0xb8(%rdi),%eax
 108be03:	cmp    0xbc(%rdi),%eax
 108be09:	jae    108be40 <check_input_expressions+0x2bd0>
 108be0b:	mov    0xb0(%rdi),%rcx
 108be12:	mov    %esi,(%rcx,%rax,4)
 108be15:	mov    0xb8(%rdi),%ecx
 108be1b:	mov    0xa8(%rdi),%rax
 108be22:	lea    0x1(%rcx),%edx
 108be25:	mov    %edx,0xb8(%rdi)
 108be2b:	mov    %r13d,(%rax,%rcx,4)
 108be2f:	jmp    108be4b <check_input_expressions+0x2bdb>
 108be31:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 108be40:	mov    (%r12),%rax
 108be44:	movb   $0x1,0x3c5(%rax)
 108be4b:	mov    -0xc(%r8),%eax
 108be4f:	inc    %r15
 108be52:	cmp    %rax,%r15
 108be55:	jae    108be64 <check_input_expressions+0x2bf4>
 108be57:	mov    %r9d,%r13d
 108be5a:	cmp    $0xffffffff,%r9d
 108be5e:	jne    108bc90 <check_input_expressions+0x2a20>
 108be64:	mov    0x18(%rsp),%edx
 108be68:	mov    0x30(%rsp),%rax
 108be6d:	movzbl 0x57(%rsp),%esi
 108be72:	movzbl 0x67(%rsp),%r15d
 108be78:	jmp    108beef <check_input_expressions+0x2c7f>
 108be7a:	mov    $0xffffffff,%r8d
 108be80:	add    $0xffffffe0,%eax
 108be83:	movq   $0x0,0x80(%rsp)
 108be8f:	cmp    $0x6,%eax
 108be92:	jae    108c062 <check_input_expressions+0x2df2>
 108be98:	mov    0x30(%rsp),%rsi
 108be9d:	movq   $0x0,0x90(%rsp)
 108bea9:	movl   $0x0,0x88(%rsp)
 108beb4:	mov    $0xffffffff,%r9d
 108beba:	jmp    108bf2f <check_input_expressions+0x2cbf>
 108bebc:	movq   $0x0,0x90(%rsp)
 108bec8:	movl   $0x0,0x88(%rsp)
 108bed3:	jmp    108beef <check_input_expressions+0x2c7f>
 108bed5:	mov    0x18(%rsp),%edx
 108bed9:	mov    0x30(%rsp),%rax
 108bede:	movzbl 0x57(%rsp),%esi
 108bee3:	movq   $0x0,0x90(%rsp)
 108beef:	mov    0x24(%rsp),%ecx
 108bef3:	cmp    $0x17,%eax
 108bef6:	mov    $0xffffffff,%r9d
 108befc:	mov    %edx,%r8d
 108beff:	cmove  %ecx,%r9d
 108bf03:	cmp    $0x36,%eax
 108bf06:	mov    $0xffffffff,%eax
 108bf0b:	cmove  %ecx,%r9d
 108bf0f:	test   %r15b,%r15b
 108bf12:	mov    0xa4(%rsp),%ecx
 108bf19:	cmovne 0x4(%rsp),%r8d
 108bf1f:	cmovne %edx,%r9d
 108bf23:	test   %sil,%sil
 108bf26:	mov    0x30(%rsp),%rsi
 108bf2b:	cmovne %eax,%r8d
 108bf2f:	mov    0x8(%rsp),%r14
 108bf34:	mov    %r12,%rdi
 108bf37:	mov    %r14d,%edx
 108bf3a:	vzeroupper
 108bf3d:	call   10fb220 <check_input_add>
 108bf42:	cmp    $0xffffffff,%eax
 108bf45:	je     108c026 <check_input_expressions+0x2db6>
 108bf4b:	mov    %eax,%r15d
 108bf4e:	mov    0xa8(%r12),%rax
 108bf56:	mov    0x68(%rsp),%rbx
 108bf5b:	mov    %r15d,%edx
 108bf5e:	vpmovsxbq -0xbee2e7(%rip),%xmm3        # 49dc80 <cbuiltin_test_generated.edges+0x3e40>
 108bf67:	mov    0x10(%rsp),%r9
 108bf6c:	mov    $0xffffffff,%r11d
 108bf72:	vxorps %xmm2,%xmm2,%xmm2
 108bf76:	mov    (%rax,%r14,4),%eax
 108bf7a:	mov    0x30(%rbx),%rcx
 108bf7e:	mov    %eax,(%rcx,%rdx,4)
 108bf81:	mov    0x208(%r12),%rax
 108bf89:	movzwl (%rax,%r14,2),%eax
 108bf8e:	test   %eax,%eax
 108bf90:	je     108bf99 <check_input_expressions+0x2d29>
 108bf92:	mov    0x38(%rbx),%rcx
 108bf96:	mov    %eax,(%rcx,%rdx,4)
 108bf99:	mov    0x30(%rsp),%rax
 108bf9e:	mov    0x4(%rsp),%r8d
 108bfa3:	mov    0x58(%rsp),%r13d
 108bfa8:	mov    0x18(%rsp),%esi
 108bfac:	mov    0x40(%rsp),%r10d
 108bfb1:	mov    %rdx,0x48(%rsp)
 108bfb6:	cmp    $0x38,%eax
 108bfb9:	jne    108c15b <check_input_expressions+0x2eeb>
 108bfbf:	mov    0x8c(%rbx),%ecx
 108bfc5:	mov    $0xffffffff,%eax
 108bfca:	cmp    %ecx,%esi
 108bfcc:	jae    108c0a2 <check_input_expressions+0x2e32>
 108bfd2:	mov    (%rbx),%rdx
 108bfd5:	jmp    108bfef <check_input_expressions+0x2d7f>
 108bfd7:	nopw   0x0(%rax,%rax,1)
 108bfe0:	mov    0x10(%rbx),%rdi
 108bfe4:	mov    (%rdi,%rsi,4),%esi
 108bfe7:	cmp    %ecx,%esi
 108bfe9:	jae    108c09e <check_input_expressions+0x2e2e>
 108bfef:	mov    %esi,%esi
 108bff1:	mov    (%rdx,%rsi,4),%edi
 108bff4:	cmp    $0x34,%edi
 108bff7:	je     108bfe0 <check_input_expressions+0x2d70>
 108bff9:	cmp    $0x18,%edi
 108bffc:	je     108bfe0 <check_input_expressions+0x2d70>
 108bffe:	mov    0x8(%rbx),%rcx
 108c002:	mov    0x70(%rsp),%rdx
 108c007:	mov    (%rcx,%rsi,4),%ecx
 108c00a:	mov    0x18(%rsp),%esi
 108c00e:	cmp    (%rdx),%ecx
 108c010:	jae    108c0a2 <check_input_expressions+0x2e32>
 108c016:	mov    (%r12),%rax
 108c01a:	mov    0x238(%rax),%rax
 108c021:	mov    (%rax,%rcx,4),%eax
 108c024:	jmp    108c0a2 <check_input_expressions+0x2e32>
 108c026:	vpmovsxbq -0xbee3af(%rip),%xmm3        # 49dc80 <cbuiltin_test_generated.edges+0x3e40>
 108c02f:	mov    0x10(%rsp),%r9
 108c034:	mov    0x4(%rsp),%r8d
 108c039:	mov    0x58(%rsp),%r13d
 108c03e:	mov    0x28(%rsp),%esi
 108c042:	vxorps %xmm2,%xmm2,%xmm2
 108c046:	mov    $0xffffffff,%r11d
 108c04c:	mov    $0xffffffff,%ecx
 108c051:	mov    %ecx,%r15d
 108c054:	test   %r13b,%r13b
 108c057:	je     108e184 <check_input_expressions+0x4f14>
 108c05d:	jmp    108e195 <check_input_expressions+0x4f25>
 108c062:	mov    0x30(%rsp),%rsi
 108c067:	mov    $0x0,%eax
 108c06c:	mov    $0xffffffff,%r9d
 108c072:	movl   $0x0,0x88(%rsp)
 108c07d:	mov    %rax,0x90(%rsp)
 108c085:	cmp    $0x18,%esi
 108c088:	je     108bf2f <check_input_expressions+0x2cbf>
 108c08e:	cmp    $0xa,%r15b
 108c092:	sete   %sil
 108c096:	or     %r14b,%sil
 108c099:	jmp    108bb87 <check_input_expressions+0x2917>
 108c09e:	mov    0x18(%rsp),%esi
 108c0a2:	mov    0xc8(%rbx),%ecx
 108c0a8:	cmp    0xcc(%rbx),%ecx
 108c0ae:	jae    108c14b <check_input_expressions+0x2edb>
 108c0b4:	mov    0x230(%r12),%rdx
 108c0bc:	mov    0x98(%rbx),%rsi
 108c0c3:	mov    0x48(%rsp),%rdi
 108c0c8:	mov    (%rdx,%r14,4),%edx
 108c0cc:	dec    %edx
 108c0ce:	imul   $0x2c,%rdx,%rdx
 108c0d2:	add    0x228(%r12),%rdx
 108c0da:	mov    %ecx,(%rsi,%rdi,4)
 108c0dd:	mov    0xa0(%rbx),%rsi
 108c0e4:	mov    0x20(%rdx),%ecx
 108c0e7:	mov    %ecx,(%rsi,%rdi,4)
 108c0ea:	mov    0xc8(%rbx),%esi
 108c0f0:	mov    0xc0(%rbx),%rcx
 108c0f7:	lea    0x1(%rsi),%edi
 108c0fa:	lea    (%rsi,%rsi,8),%rsi
 108c0fe:	mov    %edi,0xc8(%rbx)
 108c104:	vmovups (%rdx),%xmm0
 108c108:	vmovups 0xc(%rdx),%xmm1
 108c10d:	vmovups %xmm1,0xcc(%rsp)
 108c116:	vmovaps %xmm0,0xc0(%rsp)
 108c11f:	mov    %r15d,(%rcx,%rsi,4)
 108c123:	mov    %eax,0x4(%rcx,%rsi,4)
 108c127:	vmovaps 0xc0(%rsp),%xmm0
 108c130:	vmovups %xmm0,0x8(%rcx,%rsi,4)
 108c136:	vmovdqu 0xcc(%rsp),%xmm0
 108c13f:	vmovdqu %xmm0,0x14(%rcx,%rsi,4)
 108c145:	mov    0x18(%rsp),%esi
 108c149:	jmp    108c156 <check_input_expressions+0x2ee6>
 108c14b:	mov    (%r12),%rax
 108c14f:	movb   $0x1,0x3c5(%rax)
 108c156:	mov    0x30(%rsp),%rax
 108c15b:	and    $0xfffffffe,%eax
 108c15e:	cmp    $0x20,%eax
 108c161:	jne    108c32f <check_input_expressions+0x30bf>
 108c167:	mov    0x18(%r9),%rcx
 108c16b:	lea    0x1(%r14),%eax
 108c16f:	cmpl   $0x20,0x30(%rsp)
 108c174:	mov    0x38(%rbx),%rdx
 108c178:	mov    0x48(%rsp),%rdi
 108c17d:	mov    (%rcx,%rax,4),%ecx
 108c180:	mov    %ecx,(%rdx,%rdi,4)
 108c183:	jne    108c32f <check_input_expressions+0x30bf>
 108c189:	mov    0x8(%r12),%rcx
 108c18e:	mov    (%r12),%r14
 108c192:	lea    0x100(%rsp),%r8
 108c19a:	mov    0x18(%rcx),%rcx
 108c19e:	mov    (%rcx,%rax,4),%eax
 108c1a1:	mov    0x10(%r12),%rcx
 108c1a6:	mov    0x270(%rcx),%rcx
 108c1ad:	mov    0x10(%rcx),%rdx
 108c1b1:	mov    (%rdx,%rax,8),%r13d
 108c1b5:	mov    0x4(%rdx,%rax,8),%ebx
 108c1b9:	xor    %edx,%edx
 108c1bb:	add    0x40(%rcx),%r13
 108c1bf:	xor    %ecx,%ecx
 108c1c1:	mov    %ebx,%esi
 108c1c3:	mov    %r13,%rdi
 108c1c6:	call   10fbc30 <check_vector_member_decode>
 108c1cb:	test   %al,%al
 108c1cd:	jne    108c29a <check_input_expressions+0x302a>
 108c1d3:	mov    0x20(%r12),%rax
 108c1d8:	mov    0x8(%rax),%rdx
 108c1dc:	mov    0x10(%rax),%rcx
 108c1e0:	sub    %rdx,%rcx
 108c1e3:	jb     108c292 <check_input_expressions+0x3022>
 108c1e9:	cmp    %rbx,%rcx
 108c1ec:	jb     108c292 <check_input_expressions+0x3022>
 108c1f2:	lea    (%rdx,%rbx,1),%rcx
 108c1f6:	mov    %rcx,0x8(%rax)
 108c1fa:	mov    %rdx,%rcx
 108c1fd:	mov    (%rax),%rax
 108c200:	mov    (%r12),%rsi
 108c204:	add    %rax,%rcx
 108c207:	sete   %cl
 108c20a:	or     %cl,0x3c5(%rsi)
 108c210:	add    %rax,%rdx
 108c213:	je     108c29a <check_input_expressions+0x302a>
 108c219:	lea    0x100(%rsp),%r8
 108c221:	mov    %r13,%rdi
 108c224:	mov    %ebx,%esi
 108c226:	mov    %ebx,%ecx
 108c228:	call   10fbc30 <check_vector_member_decode>
 108c22d:	mov    (%r12),%rcx
 108c231:	xor    $0x1,%al
 108c233:	or     %al,0x3c5(%rcx)
 108c239:	jmp    108c29a <check_input_expressions+0x302a>
 108c23b:	mov    0x138(%r12),%rax
 108c243:	cmpb   $0x0,(%rax,%rbx,1)
 108c247:	je     108c3ee <check_input_expressions+0x317e>
 108c24d:	movzbl %r15b,%eax
 108c251:	add    $0xfffffff9,%eax
 108c254:	cmp    $0x3e,%eax
 108c257:	ja     10892e0 <check_input_expressions+0x70>
 108c25d:	movabs $0x5c00000000240001,%rcx
 108c267:	bt     %rax,%rcx
 108c26b:	jb     10896e3 <check_input_expressions+0x473>
 108c271:	jmp    10892e0 <check_input_expressions+0x70>
 108c276:	mov    %r14,%rdx
 108c279:	xor    %r14d,%r14d
 108c27c:	movl   $0x0,0x8c(%rsp)
 108c287:	mov    %r13d,%r8d
 108c28a:	mov    %r13d,%ecx
 108c28d:	jmp    108ba69 <check_input_expressions+0x27f9>
 108c292:	movb   $0x1,0x3c5(%r14)
 108c29a:	mov    (%r12),%rax
 108c29e:	vpmovsxbq -0xbee627(%rip),%xmm3        # 49dc80 <cbuiltin_test_generated.edges+0x3e40>
 108c2a7:	mov    0x10(%rsp),%r9
 108c2ac:	mov    0x4(%rsp),%r8d
 108c2b1:	mov    0x58(%rsp),%r13d
 108c2b6:	mov    0x18(%rsp),%esi
 108c2ba:	mov    0x40(%rsp),%r10d
 108c2bf:	mov    $0xffffffff,%r11d
 108c2c5:	vxorps %xmm2,%xmm2,%xmm2
 108c2c9:	cmpb   $0x0,0x3c5(%rax)
 108c2d0:	jne    108c325 <check_input_expressions+0x30b5>
 108c2d2:	cmpb   $0x0,0x10c(%rsp)
 108c2da:	je     108c325 <check_input_expressions+0x30b5>
 108c2dc:	mov    0xe8(%r14),%ecx
 108c2e3:	cmp    0xec(%r14),%ecx
 108c2ea:	jae    108c31e <check_input_expressions+0x30ae>
 108c2ec:	mov    0xe0(%r14),%rax
 108c2f3:	lea    0x1(%rcx),%edx
 108c2f6:	lea    (%rcx,%rcx,2),%rcx
 108c2fa:	mov    %edx,0xe8(%r14)
 108c301:	mov    %r15d,(%rax,%rcx,8)
 108c305:	movl   $0x0,0x4(%rax,%rcx,8)
 108c30d:	vmovdqu 0x100(%rsp),%xmm0
 108c316:	vmovdqu %xmm0,0x8(%rax,%rcx,8)
 108c31c:	jmp    108c325 <check_input_expressions+0x30b5>
 108c31e:	movb   $0x1,0x3c5(%rax)
 108c325:	mov    0x68(%rsp),%rbx
 108c32a:	mov    0x8(%rsp),%r14
 108c32f:	cmpb   $0x0,0x8c(%rsp)
 108c337:	jne    108c363 <check_input_expressions+0x30f3>
 108c339:	mov    0x30(%rsp),%rax
 108c33e:	add    $0xffffffde,%eax
 108c341:	cmp    $0x22,%eax
 108c344:	ja     108cd09 <check_input_expressions+0x3a99>
 108c34a:	mov    0x58(%rsp),%r13d
 108c34f:	movabs $0x700000001,%rcx
 108c359:	bt     %rax,%rcx
 108c35d:	jae    108cd09 <check_input_expressions+0x3a99>
 108c363:	cmpl   $0x22,0x30(%rsp)
 108c368:	mov    0x88(%rsp),%edi
 108c36f:	jne    108c545 <check_input_expressions+0x32d5>
 108c375:	mov    (%r12),%rax
 108c379:	mov    0x220(%rax),%rcx
 108c380:	test   %rcx,%rcx
 108c383:	sete   %dl
 108c386:	xor    $0x1,%r10b
 108c38a:	or     %dl,%r10b
 108c38d:	jne    108c545 <check_input_expressions+0x32d5>
 108c393:	mov    0x8(%rbx),%rdx
 108c397:	mov    %r8d,%esi
 108c39a:	mov    (%rdx,%rsi,4),%edx
 108c39d:	mov    0x70(%rsp),%rsi
 108c3a2:	cmp    (%rsi),%edx
 108c3a4:	mov    0x18(%rsp),%esi
 108c3a8:	jae    108c545 <check_input_expressions+0x32d5>
 108c3ae:	mov    (%rcx,%rdx,4),%ecx
 108c3b1:	test   %ecx,%ecx
 108c3b3:	je     108c545 <check_input_expressions+0x32d5>
 108c3b9:	mov    0x118(%rbx),%edx
 108c3bf:	cmp    0x11c(%rbx),%edx
 108c3c5:	jae    108c53e <check_input_expressions+0x32ce>
 108c3cb:	mov    0x110(%rbx),%rax
 108c3d2:	lea    0x1(%rdx),%esi
 108c3d5:	dec    %ecx
 108c3d7:	mov    %esi,0x118(%rbx)
 108c3dd:	mov    0x18(%rsp),%esi
 108c3e1:	mov    %r15d,(%rax,%rdx,8)
 108c3e5:	mov    %ecx,0x4(%rax,%rdx,8)
 108c3e9:	jmp    108c545 <check_input_expressions+0x32d5>
 108c3ee:	cmp    $0x2,%r15b
 108c3f2:	jne    108cda9 <check_input_expressions+0x3b39>
 108c3f8:	cmp    $0x2,%dil
 108c3fc:	jne    108cda9 <check_input_expressions+0x3b39>
 108c402:	mov    0xa0(%r12),%rax
 108c40a:	cmpl   $0x0,(%rax,%rbx,4)
 108c40e:	je     10892e0 <check_input_expressions+0x70>
 108c414:	mov    $0xffffffff,%ecx
 108c419:	mov    $0xffffffff,%r8d
 108c41f:	mov    $0xffffffff,%r9d
 108c425:	mov    0x8(%rsp),%rdx
 108c42a:	mov    %r12,%rdi
 108c42d:	xor    %esi,%esi
 108c42f:	vzeroupper
 108c432:	call   10fb220 <check_input_add>
 108c437:	vpmovsxbq -0xbee7c0(%rip),%xmm3        # 49dc80 <cbuiltin_test_generated.edges+0x3e40>
 108c440:	mov    0x10(%rsp),%r9
 108c445:	mov    $0xffffffff,%r11d
 108c44b:	vxorps %xmm2,%xmm2,%xmm2
 108c44f:	cmp    $0xffffffff,%eax
 108c452:	je     10892e0 <check_input_expressions+0x70>
 108c458:	mov    (%r12),%rsi
 108c45c:	mov    %eax,%r15d
 108c45f:	mov    0xa0(%r12),%rax
 108c467:	mov    0x8(%rsp),%rdx
 108c46c:	mov    0x238(%rsi),%rcx
 108c473:	mov    (%rax,%rdx,4),%eax
 108c476:	mov    (%rcx,%rdx,4),%ecx
 108c479:	mov    0x100(%r12),%rdx
 108c481:	movzbl (%rdx,%rcx,1),%r8d
 108c486:	xor    %edx,%edx
 108c488:	cmp    $0x3,%r8b
 108c48c:	je     108c4a9 <check_input_expressions+0x3239>
 108c48e:	mov    0x18(%r12),%rdx
 108c493:	mov    %eax,%r9d
 108c496:	shr    $0x3,%r9d
 108c49a:	mov    (%rdx),%rdi
 108c49d:	xor    %edx,%edx
 108c49f:	cmpb   $0xb,(%rdi,%r9,1)
 108c4a4:	sete   %dl
 108c4a7:	inc    %edx
 108c4a9:	mov    0x118(%r12),%r9
 108c4b1:	xor    %edi,%edi
 108c4b3:	cmp    $0x3,%r8b
 108c4b7:	sete   %dil
 108c4bb:	cmpb   $0x0,(%r9,%rcx,1)
 108c4c0:	je     108c4dc <check_input_expressions+0x326c>
 108c4c2:	mov    0x278(%rsi),%r9
 108c4c9:	xor    %r10d,%r10d
 108c4cc:	cmpb   $0x0,(%r9,%rcx,1)
 108c4d1:	sete   %r10b
 108c4d5:	shl    $0x7,%r10d
 108c4d9:	or     %r10d,%edi
 108c4dc:	mov    0x120(%r12),%r10
 108c4e4:	xor    %r9d,%r9d
 108c4e7:	mov    $0x0,%r11d
 108c4ed:	mov    $0x0,%r14d
 108c4f3:	cmpb   $0x0,(%r10,%rcx,1)
 108c4f8:	setne  %bpl
 108c4fc:	xor    %r10d,%r10d
 108c4ff:	cmp    $0x3,%r8b
 108c503:	setne  %r8b
 108c507:	jne    108c521 <check_input_expressions+0x32b1>
 108c509:	mov    0x340(%r12),%rbx
 108c511:	mov    %rcx,%r14
 108c514:	shl    $0x4,%r14
 108c518:	mov    (%rbx,%r14,1),%r11
 108c51c:	mov    0x8(%rbx,%r14,1),%r14
 108c521:	mov    0x220(%rsi),%rsi
 108c528:	test   %rsi,%rsi
 108c52b:	je     108d086 <check_input_expressions+0x3e16>
 108c531:	mov    0x8(%rsp),%rbx
 108c536:	mov    (%rsi,%rbx,4),%esi
 108c539:	jmp    108d088 <check_input_expressions+0x3e18>
 108c53e:	movb   $0x1,0x3c5(%rax)
 108c545:	cmpb   $0x0,0x80(%rsp)
 108c54d:	jne    108c555 <check_input_expressions+0x32e5>
 108c54f:	mov    0xb8(%rbx),%edi
 108c555:	mov    0x98(%rbx),%rcx
 108c55c:	mov    0x48(%rsp),%rdx
 108c561:	xor    %eax,%eax
 108c563:	cmpl   $0x22,0x30(%rsp)
 108c568:	mov    %edi,(%rcx,%rdx,4)
 108c56b:	sete   %al
 108c56e:	cmovne %r8d,%esi
 108c572:	mov    %ebp,%ecx
 108c574:	mov    0xa0(%rbx),%rdi
 108c57b:	sub    %eax,%ecx
 108c57d:	cmp    $0xffffffff,%esi
 108c580:	mov    %ecx,(%rdi,%rdx,4)
 108c583:	sete   %cl
 108c586:	or     0x80(%rsp),%cl
 108c58d:	je     108c5bb <check_input_expressions+0x334b>
 108c58f:	jmp    108c630 <check_input_expressions+0x33c0>
 108c594:	data16 data16 cs nopw 0x0(%rax,%rax,1)
 108c5a0:	mov    (%r12),%rcx
 108c5a4:	movb   $0x1,0x3c5(%rcx)
 108c5ab:	mov    0x390(%r12),%rcx
 108c5b3:	mov    (%rcx,%rax,4),%esi
 108c5b6:	cmp    $0xffffffff,%esi
 108c5b9:	je     108c630 <check_input_expressions+0x33c0>
 108c5bb:	mov    0xb8(%rbx),%ecx
 108c5c1:	mov    %esi,%eax
 108c5c3:	cmp    0xbc(%rbx),%ecx
 108c5c9:	jae    108c5a0 <check_input_expressions+0x3330>
 108c5cb:	mov    0x8(%rbx),%rdx
 108c5cf:	mov    %esi,%r13d
 108c5d2:	mov    %r8d,%r10d
 108c5d5:	mov    (%rdx,%rax,4),%edi
 108c5d8:	mov    0x8(%r12),%rdx
 108c5dd:	mov    0x30(%rdx),%edx
 108c5e0:	mov    %edi,%esi
 108c5e2:	cmp    %edx,%edi
 108c5e4:	jae    108c5f9 <check_input_expressions+0x3389>
 108c5e6:	mov    0x370(%r12),%rdi
 108c5ee:	mov    %esi,%r8d
 108c5f1:	mov    (%rdi,%r8,4),%edi
 108c5f5:	cmp    %esi,%edi
 108c5f7:	jb     108c5e0 <check_input_expressions+0x3370>
 108c5f9:	mov    0xb0(%rbx),%rdx
 108c600:	mov    %r10d,%r8d
 108c603:	mov    %esi,(%rdx,%rcx,4)
 108c606:	mov    0xb8(%rbx),%edx
 108c60c:	mov    0xa8(%rbx),%rcx
 108c613:	lea    0x1(%rdx),%esi
 108c616:	mov    %esi,0xb8(%rbx)
 108c61c:	mov    %r13d,(%rcx,%rdx,4)
 108c620:	mov    0x390(%r12),%rcx
 108c628:	mov    (%rcx,%rax,4),%esi
 108c62b:	cmp    $0xffffffff,%esi
 108c62e:	jne    108c5bb <check_input_expressions+0x334b>
 108c630:	cmpb   $0x0,0x80(%rsp)
 108c638:	je     108c6ee <check_input_expressions+0x347e>
 108c63e:	mov    (%r12),%rcx
 108c642:	mov    0xf8(%rbx),%eax
 108c648:	cmp    0xfc(%rbx),%eax
 108c64e:	jae    108c6e7 <check_input_expressions+0x3477>
 108c654:	mov    0x1f8(%rcx),%rdx
 108c65b:	mov    0x208(%rcx),%rsi
 108c662:	mov    0x218(%rcx),%rcx
 108c669:	lea    0x1(%rax),%edi
 108c66c:	lea    (%rax,%rax,4),%rax
 108c670:	mov    (%rcx,%r14,4),%ecx
 108c674:	shl    $0x5,%rcx
 108c678:	mov    -0x20(%rsi,%rcx,1),%ecx
 108c67c:	mov    0xf0(%rbx),%rsi
 108c683:	mov    %edi,0xf8(%rbx)
 108c689:	mov    0x280(%r12),%r10
 108c691:	imul   $0x130,%rcx,%rcx
 108c698:	cmpb   $0x0,(%r10,%r14,1)
 108c69d:	mov    (%rdx,%rcx,1),%rdi
 108c6a1:	mov    0x118(%rdx,%rcx,1),%rcx
 108c6a9:	mov    0x90(%rsp),%rdx
 108c6b1:	mov    %r15d,(%rsi,%rax,8)
 108c6b5:	movl   $0x0,0x4(%rsi,%rax,8)
 108c6bd:	mov    %rdi,0x8(%rsi,%rax,8)
 108c6c2:	mov    %rcx,0x10(%rsi,%rax,8)
 108c6c7:	mov    %rdx,0x18(%rsi,%rax,8)
 108c6cc:	movl   $0x0,0x20(%rsi,%rax,8)
 108c6d4:	setne  0x24(%rsi,%rax,8)
 108c6d9:	movb   $0x0,0x25(%rsi,%rax,8)
 108c6de:	movw   $0x0,0x26(%rsi,%rax,8)
 108c6e5:	jmp    108c6ee <check_input_expressions+0x347e>
 108c6e7:	movb   $0x1,0x3c5(%rcx)
 108c6ee:	mov    0x30(%rsp),%rax
 108c6f3:	mov    0x58(%rsp),%r13d
 108c6f8:	add    $0xffffffc3,%eax
 108c6fb:	cmp    $0x3,%eax
 108c6fe:	jae    108c7a1 <check_input_expressions+0x3531>
 108c704:	mov    0xd8(%rbx),%eax
 108c70a:	cmp    0xdc(%rbx),%eax
 108c710:	jae    108c7c9 <check_input_expressions+0x3559>
 108c716:	mov    0x370(%r12),%rcx
 108c71e:	mov    %r14d,%esi
 108c721:	mov    (%rcx,%r14,4),%ecx
 108c725:	lea    0x2(%rcx),%r10d
 108c729:	cmp    %r14d,%ecx
 108c72c:	cmovb  %r10d,%esi
 108c730:	mov    %esi,%edx
 108c732:	cmp    %r14d,%esi
 108c735:	jae    108ca5e <check_input_expressions+0x37ee>
 108c73b:	mov    0x10(%r9),%rcx
 108c73f:	mov    %esi,%edi
 108c741:	jmp    108c76e <check_input_expressions+0x34fe>
 108c743:	cmp    $0xa,%r8d
 108c747:	jne    108c789 <check_input_expressions+0x3519>
 108c749:	mov    0x60(%r9),%r8
 108c74d:	mov    (%r8,%rdx,4),%r8d
 108c751:	lea    0x1(%r8),%edx
 108c755:	cmp    %r14d,%r8d
 108c758:	cmovae %r14d,%edx
 108c75c:	cmp    %edi,%r8d
 108c75f:	cmovbe %r14d,%edx
 108c763:	mov    %edx,%edi
 108c765:	cmp    %r14d,%edx
 108c768:	jae    108ca5e <check_input_expressions+0x37ee>
 108c76e:	mov    %edi,%edx
 108c770:	movzbl (%rcx,%rdx,1),%r8d
 108c775:	cmp    $0x9,%r8d
 108c779:	jg     108c743 <check_input_expressions+0x34d3>
 108c77b:	cmp    $0x6,%r8d
 108c77f:	je     108c749 <check_input_expressions+0x34d9>
 108c781:	cmp    $0x8,%r8d
 108c785:	je     108c749 <check_input_expressions+0x34d9>
 108c787:	jmp    108c793 <check_input_expressions+0x3523>
 108c789:	cmp    $0x33,%r8d
 108c78d:	je     108ca5c <check_input_expressions+0x37ec>
 108c793:	inc    %edi
 108c795:	mov    %edi,%edx
 108c797:	cmp    %r14d,%edx
 108c79a:	jb     108c76e <check_input_expressions+0x34fe>
 108c79c:	jmp    108ca5e <check_input_expressions+0x37ee>
 108c7a1:	mov    0x30(%rsp),%rax
 108c7a6:	cmp    $0x42,%eax
 108c7a9:	jne    108cd0e <check_input_expressions+0x3a9e>
 108c7af:	mov    0x208(%r12),%rax
 108c7b7:	cmpw   $0x312,(%rax,%r14,2)
 108c7be:	je     108c704 <check_input_expressions+0x3494>
 108c7c4:	jmp    108cd09 <check_input_expressions+0x3a99>
 108c7c9:	mov    (%r12),%rax
 108c7cd:	movb   $0x1,0x3c5(%rax)
 108c7d4:	jmp    108cd09 <check_input_expressions+0x3a99>
 108c7d9:	lea    0x1c(%rsi,%rcx,4),%r11
 108c7de:	and    $0xfffffffffffffff8,%r9
 108c7e2:	mov    $0xffffffff,%r15d
 108c7e8:	mov    %rbx,0x30(%rsp)
 108c7ed:	mov    %r12,0x18(%rsp)
 108c7f2:	xor    %r10d,%r10d
 108c7f5:	xor    %r8d,%r8d
 108c7f8:	mov    -0x1c(%r11,%r8,4),%eax
 108c7fd:	mov    -0x18(%r11,%r8,4),%ebx
 108c802:	cmp    %ecx,%eax
 108c804:	setb   %r12b
 108c808:	cmp    %edx,%eax
 108c80a:	setae  %al
 108c80d:	or     %r12b,%al
 108c810:	lea    (%r8,%rcx,1),%r12d
 108c814:	movzbl %al,%eax
 108c817:	add    %eax,%r10d
 108c81a:	test   %al,%al
 108c81c:	cmovne %r12d,%r15d
 108c820:	cmp    %ecx,%ebx
 108c822:	lea    0x1(%rcx,%r8,1),%r12d
 108c827:	setb   %al
 108c82a:	cmp    %edx,%ebx
 108c82c:	setae  %bl
 108c82f:	or     %al,%bl
 108c831:	movzbl %bl,%eax
 108c834:	mov    -0x14(%r11,%r8,4),%ebx
 108c839:	test   %al,%al
 108c83b:	cmove  %r15d,%r12d
 108c83f:	cmp    %ecx,%ebx
 108c841:	setb   %r15b
 108c845:	cmp    %edx,%ebx
 108c847:	setae  %bl
 108c84a:	or     %r15b,%bl
 108c84d:	movzbl %bl,%ebx
 108c850:	add    %ebx,%eax
 108c852:	add    %r10d,%eax
 108c855:	test   %bl,%bl
 108c857:	mov    -0x10(%r11,%r8,4),%ebx
 108c85c:	lea    0x2(%rcx,%r8,1),%r10d
 108c861:	cmove  %r12d,%r10d
 108c865:	lea    0x3(%rcx,%r8,1),%r12d
 108c86a:	cmp    %ecx,%ebx
 108c86c:	setb   %r15b
 108c870:	cmp    %edx,%ebx
 108c872:	setae  %bl
 108c875:	or     %r15b,%bl
 108c878:	movzbl %bl,%r15d
 108c87c:	test   %r15b,%r15b
 108c87f:	cmove  %r10d,%r12d
 108c883:	mov    -0xc(%r11,%r8,4),%r10d
 108c888:	cmp    %ecx,%r10d
 108c88b:	setb   %bl
 108c88e:	cmp    %edx,%r10d
 108c891:	setae  %r10b
 108c895:	or     %bl,%r10b
 108c898:	lea    0x4(%rcx,%r8,1),%ebx
 108c89d:	movzbl %r10b,%r10d
 108c8a1:	add    %r10d,%r15d
 108c8a4:	test   %r10b,%r10b
 108c8a7:	mov    -0x8(%r11,%r8,4),%r10d
 108c8ac:	cmove  %r12d,%ebx
 108c8b0:	cmp    %ecx,%r10d
 108c8b3:	setb   %r12b
 108c8b7:	cmp    %edx,%r10d
 108c8ba:	setae  %r10b
 108c8be:	or     %r12b,%r10b
 108c8c1:	movzbl %r10b,%r10d
 108c8c5:	add    %r10d,%r15d
 108c8c8:	add    %eax,%r15d
 108c8cb:	test   %r10b,%r10b
 108c8ce:	mov    -0x4(%r11,%r8,4),%r10d
 108c8d3:	lea    0x5(%rcx,%r8,1),%eax
 108c8d8:	cmove  %ebx,%eax
 108c8db:	cmp    %ecx,%r10d
 108c8de:	setb   %bl
 108c8e1:	cmp    %edx,%r10d
 108c8e4:	setae  %r10b
 108c8e8:	or     %bl,%r10b
 108c8eb:	lea    0x6(%rcx,%r8,1),%ebx
 108c8f0:	movzbl %r10b,%r10d
 108c8f4:	test   %r10b,%r10b
 108c8f7:	cmove  %eax,%ebx
 108c8fa:	mov    (%r11,%r8,4),%eax
 108c8fe:	cmp    %ecx,%eax
 108c900:	setb   %r12b
 108c904:	cmp    %edx,%eax
 108c906:	setae  %al
 108c909:	or     %r12b,%al
 108c90c:	movzbl %al,%eax
 108c90f:	add    %eax,%r10d
 108c912:	add    %r15d,%r10d
 108c915:	lea    0x7(%rcx,%r8,1),%r15d
 108c91a:	test   %al,%al
 108c91c:	cmove  %ebx,%r15d
 108c920:	add    $0x8,%r8
 108c924:	cmp    %r8,%r9
 108c927:	jne    108c7f8 <check_input_expressions+0x3588>
 108c92d:	test   %rdi,%rdi
 108c930:	je     108ce84 <check_input_expressions+0x3c14>
 108c936:	mov    0x18(%rsp),%r12
 108c93b:	mov    0x30(%rsp),%rbx
 108c940:	add    %rcx,%r8
 108c943:	mov    $0xffffffff,%r11d
 108c949:	mov    (%rsi,%r8,4),%eax
 108c94d:	cmp    %ecx,%eax
 108c94f:	setb   %r9b
 108c953:	cmp    %edx,%eax
 108c955:	setae  %al
 108c958:	or     %r9b,%al
 108c95b:	movzbl %al,%eax
 108c95e:	add    %eax,%r10d
 108c961:	test   %al,%al
 108c963:	cmovne %r8d,%r15d
 108c967:	inc    %r8
 108c96a:	dec    %rdi
 108c96d:	jne    108c949 <check_input_expressions+0x36d9>
 108c96f:	mov    0x10(%rsp),%r9
 108c974:	cmp    $0x1,%r10d
 108c978:	mov    $0xffffffff,%eax
 108c97d:	cmovne %eax,%r15d
 108c981:	cmp    0x30(%rbx),%r15d
 108c985:	jae    108ca0e <check_input_expressions+0x379e>
 108c98b:	mov    0x2c0(%r13),%rax
 108c992:	mov    %r15d,%ecx
 108c995:	mov    (%rax,%rcx,4),%ecx
 108c998:	cmp    $0xffffffff,%ecx
 108c99b:	je     108ca0e <check_input_expressions+0x379e>
 108c99d:	mov    $0x39,%esi
 108c9a2:	mov    $0xffffffff,%r8d
 108c9a8:	mov    $0xffffffff,%r9d
 108c9ae:	mov    0x8(%rsp),%rdx
 108c9b3:	mov    %r12,%rdi
 108c9b6:	vzeroupper
 108c9b9:	call   10fb220 <check_input_add>
 108c9be:	vpmovsxbq -0xbeed47(%rip),%xmm3        # 49dc80 <cbuiltin_test_generated.edges+0x3e40>
 108c9c7:	mov    0x10(%rsp),%r9
 108c9cc:	mov    $0xffffffff,%r11d
 108c9d2:	vxorps %xmm2,%xmm2,%xmm2
 108c9d6:	cmp    $0xffffffff,%eax
 108c9d9:	je     10892e0 <check_input_expressions+0x70>
 108c9df:	mov    (%r12),%rcx
 108c9e3:	mov    %eax,%r15d
 108c9e6:	mov    0x38(%rcx),%rax
 108c9ea:	mov    %r15d,%ecx
 108c9ed:	mov    %r14d,(%rax,%rcx,4)
 108c9f1:	mov    %r15d,0x10(%rbp)
 108c9f5:	cmpl   $0xffffffff,0x0(%rbp)
 108c9f9:	jne    10892e0 <check_input_expressions+0x70>
 108c9ff:	cmpb   $0x0,0x20(%rbp)
 108ca03:	je     10892e0 <check_input_expressions+0x70>
 108ca09:	jmp    108e19f <check_input_expressions+0x4f2f>
 108ca0e:	mov    0x230(%r13),%eax
 108ca15:	cmp    0x234(%r13),%eax
 108ca1c:	jae    10892d1 <check_input_expressions+0x61>
 108ca22:	movzbl 0x3c5(%r13),%ecx
 108ca2a:	lea    0x1(%rax),%esi
 108ca2d:	mov    0x228(%r13),%rdx
 108ca34:	lea    (%rax,%rax,2),%rax
 108ca38:	mov    %esi,0x230(%r13)
 108ca3f:	mov    0x8(%rsp),%rsi
 108ca44:	lea    0x1(%rcx,%rcx,2),%ecx
 108ca48:	mov    %esi,(%rdx,%rax,4)
 108ca4b:	mov    %ecx,0x4(%rdx,%rax,4)
 108ca4f:	movl   $0x0,0x8(%rdx,%rax,4)
 108ca57:	jmp    10892e0 <check_input_expressions+0x70>
 108ca5c:	mov    %edi,%edx
 108ca5e:	mov    0xd0(%rbx),%r8
 108ca65:	lea    0x1(%rax),%edi
 108ca68:	imul   $0x78,%rax,%rax
 108ca6c:	cmpl   $0x42,0x30(%rsp)
 108ca71:	vpxor  %xmm0,%xmm0,%xmm0
 108ca75:	mov    %edi,0xd8(%rbx)
 108ca7b:	lea    (%r8,%rax,1),%rcx
 108ca7f:	mov    %r15d,(%r8,%rax,1)
 108ca83:	vmovdqu64 %zmm0,0x4(%r8,%rax,1)
 108ca8e:	vmovdqu64 %zmm0,0x38(%r8,%rax,1)
 108ca99:	mov    %rcx,0x78(%rsp)
 108ca9e:	jne    108cc89 <check_input_expressions+0x3a19>
 108caa4:	mov    0x4(%rsp),%r8d
 108caa9:	mov    0x58(%rsp),%r13d
 108caae:	mov    %r10d,0x40(%rsp)
 108cab3:	mov    %ebp,%r10d
 108cab6:	sub    $0x2,%r10d
 108caba:	mov    $0x0,%eax
 108cabf:	cmovb  %eax,%r10d
 108cac3:	jbe    108ccb6 <check_input_expressions+0x3a46>
 108cac9:	mov    0x20(%r12),%rax
 108cace:	mov    0x8(%rax),%rdi
 108cad2:	mov    0x10(%rax),%rcx
 108cad6:	sub    %rdi,%rcx
 108cad9:	jb     108cd42 <check_input_expressions+0x3ad2>
 108cadf:	mov    %r10d,%edx
 108cae2:	cmp    %rdx,%rcx
 108cae5:	jb     108cd42 <check_input_expressions+0x3ad2>
 108caeb:	lea    (%rdi,%rdx,1),%rcx
 108caef:	mov    %rcx,0x8(%rax)
 108caf3:	mov    %rdi,%rcx
 108caf6:	mov    (%rax),%rax
 108caf9:	mov    (%r12),%rsi
 108cafd:	add    %rax,%rcx
 108cb00:	sete   %cl
 108cb03:	or     %cl,0x3c5(%rsi)
 108cb09:	add    %rax,%rdi
 108cb0c:	je     108cd4d <check_input_expressions+0x3add>
 108cb12:	xor    %esi,%esi
 108cb14:	mov    %r10d,0x80(%rsp)
 108cb1c:	mov    %rdi,0x18(%rsp)
 108cb21:	vzeroupper
 108cb24:	call   788430 <memset@plt>
 108cb29:	mov    0x40(%rsp),%esi
 108cb2d:	cmp    %r14d,%esi
 108cb30:	jae    108cc4d <check_input_expressions+0x39dd>
 108cb36:	mov    %ebp,%ebx
 108cb38:	xor    %r14d,%r14d
 108cb3b:	mov    0x8(%r12),%rax
 108cb40:	mov    %esi,%edx
 108cb42:	mov    0x10(%rax),%rcx
 108cb46:	jmp    108cb74 <check_input_expressions+0x3904>
 108cb48:	cmp    $0xa,%edi
 108cb4b:	jne    108cb8d <check_input_expressions+0x391d>
 108cb4d:	mov    0x60(%rax),%rdi
 108cb51:	mov    (%rdi,%r8,4),%r8d
 108cb55:	mov    0x8(%rsp),%rdi
 108cb5a:	lea    0x1(%r8),%r13d
 108cb5e:	cmp    %edi,%r8d
 108cb61:	cmovae %edi,%r13d
 108cb65:	cmp    %edx,%r8d
 108cb68:	cmovbe %edi,%r13d
 108cb6c:	mov    %r13d,%edx
 108cb6f:	cmp    %edi,%r13d
 108cb72:	jae    108cba6 <check_input_expressions+0x3936>
 108cb74:	mov    %edx,%r8d
 108cb77:	movzbl (%rcx,%r8,1),%edi
 108cb7c:	cmp    $0x9,%edi
 108cb7f:	jg     108cb48 <check_input_expressions+0x38d8>
 108cb81:	cmp    $0x6,%edi
 108cb84:	je     108cb4d <check_input_expressions+0x38dd>
 108cb86:	cmp    $0x8,%edi
 108cb89:	je     108cb4d <check_input_expressions+0x38dd>
 108cb8b:	jmp    108cb92 <check_input_expressions+0x3922>
 108cb8d:	cmp    $0x33,%edi
 108cb90:	je     108cba3 <check_input_expressions+0x3933>
 108cb92:	mov    0x8(%rsp),%rdi
 108cb97:	inc    %edx
 108cb99:	mov    %edx,%r13d
 108cb9c:	cmp    %edi,%r13d
 108cb9f:	jb     108cb74 <check_input_expressions+0x3904>
 108cba1:	jmp    108cba6 <check_input_expressions+0x3936>
 108cba3:	mov    %edx,%r13d
 108cba6:	cmp    $0x2,%r14
 108cbaa:	jb     108cc34 <check_input_expressions+0x39c4>
 108cbb0:	vpxor  %xmm0,%xmm0,%xmm0
 108cbb4:	vmovdqu64 %zmm0,0x120(%rsp)
 108cbbf:	vmovdqu64 %zmm0,0x100(%rsp)
 108cbc7:	mov    %r12,%rdi
 108cbca:	mov    %r13d,%edx
 108cbcd:	xor    %ecx,%ecx
 108cbcf:	mov    $0x1,%r8d
 108cbd5:	lea    0x100(%rsp),%r9
 108cbdd:	push   $0x0
 108cbdf:	lea    0xe8(%rsp),%rax
 108cbe7:	push   %rax
 108cbe8:	vzeroupper
 108cbeb:	call   10c24f0 <check_input_constant_read>
 108cbf0:	add    $0x10,%rsp
 108cbf4:	test   %al,%al
 108cbf6:	je     108cc34 <check_input_expressions+0x39c4>
 108cbf8:	cmpl   $0x1,0x10c(%rsp)
 108cc00:	jne    108cc34 <check_input_expressions+0x39c4>
 108cc02:	cmpl   $0x0,0x154(%rsp)
 108cc0a:	jne    108cc34 <check_input_expressions+0x39c4>
 108cc0c:	mov    0x108(%rsp),%eax
 108cc13:	test   $0x10,%al
 108cc15:	jne    108cc34 <check_input_expressions+0x39c4>
 108cc17:	mov    0x18(%rsp),%rdx
 108cc1c:	mov    %eax,%ecx
 108cc1e:	shr    $0x9,%eax
 108cc21:	mov    $0x1,%esi
 108cc26:	and    $0x2,%eax
 108cc29:	test   $0x1,%cl
 108cc2c:	cmovne %esi,%eax
 108cc2f:	mov    %al,-0x2(%rdx,%r14,1)
 108cc34:	inc    %r13d
 108cc37:	cmp    0x8(%rsp),%r13d
 108cc3c:	jae    108cc4d <check_input_expressions+0x39dd>
 108cc3e:	inc    %r14
 108cc41:	mov    %r13d,%esi
 108cc44:	cmp    %rbx,%r14
 108cc47:	jb     108cb3b <check_input_expressions+0x38cb>
 108cc4d:	vpmovsxbq -0xbeefd6(%rip),%xmm3        # 49dc80 <cbuiltin_test_generated.edges+0x3e40>
 108cc56:	mov    0x78(%rsp),%rax
 108cc5b:	mov    0x18(%rsp),%rcx
 108cc60:	mov    0x80(%rsp),%edx
 108cc67:	mov    0x10(%rsp),%r9
 108cc6c:	mov    0x68(%rsp),%rbx
 108cc71:	mov    0x8(%rsp),%r14
 108cc76:	vxorps %xmm2,%xmm2,%xmm2
 108cc7a:	mov    $0xffffffff,%r11d
 108cc80:	mov    %rcx,0x20(%rax)
 108cc84:	mov    %edx,0x28(%rax)
 108cc87:	jmp    108ccac <check_input_expressions+0x3a3c>
 108cc89:	mov    %r12,%rdi
 108cc8c:	vzeroupper
 108cc8f:	call   10d4c90 <check_input_builtin_evidence>
 108cc94:	vpmovsxbq -0xbef01d(%rip),%xmm3        # 49dc80 <cbuiltin_test_generated.edges+0x3e40>
 108cc9d:	mov    0x10(%rsp),%r9
 108cca2:	mov    $0xffffffff,%r11d
 108cca8:	vxorps %xmm2,%xmm2,%xmm2
 108ccac:	mov    0x4(%rsp),%r8d
 108ccb1:	mov    0x58(%rsp),%r13d
 108ccb6:	mov    0x208(%r12),%rax
 108ccbe:	cmpw   $0x130,(%rax,%r14,2)
 108ccc5:	jne    108cd09 <check_input_expressions+0x3a99>
 108ccc7:	mov    0x30(%rsp),%rax
 108cccc:	cmp    $0x1,%ebp
 108cccf:	jne    108cd0e <check_input_expressions+0x3a9e>
 108ccd1:	mov    %r12,%rdi
 108ccd4:	mov    %r8d,%esi
 108ccd7:	vzeroupper
 108ccda:	call   10fb3d0 <check_input_builtin_syntax_effects>
 108ccdf:	mov    0x78(%rsp),%rcx
 108cce4:	vpmovsxbq -0xbef06d(%rip),%xmm3        # 49dc80 <cbuiltin_test_generated.edges+0x3e40>
 108cced:	mov    0x4(%rsp),%r8d
 108ccf2:	mov    0x10(%rsp),%r9
 108ccf7:	mov    $0xffffffff,%r11d
 108ccfd:	vxorps %xmm2,%xmm2,%xmm2
 108cd01:	mov    $0x1,%ebp
 108cd06:	mov    %al,0x18(%rcx)
 108cd09:	mov    0x30(%rsp),%rax
 108cd0e:	cmp    $0x23,%eax
 108cd11:	je     108cd5c <check_input_expressions+0x3aec>
 108cd13:	mov    0x148(%r12),%rax
 108cd1b:	cmpb   $0x0,(%rax,%r14,1)
 108cd20:	je     108cd5c <check_input_expressions+0x3aec>
 108cd22:	mov    0x40(%rbx),%rax
 108cd26:	mov    0x48(%rsp),%rcx
 108cd2b:	mov    0x28(%rsp),%esi
 108cd2f:	orb    $0x4,(%rax,%rcx,1)
 108cd33:	cmp    $0xffffffff,%r15d
 108cd37:	jne    108e19f <check_input_expressions+0x4f2f>
 108cd3d:	jmp    10896d6 <check_input_expressions+0x466>
 108cd42:	mov    (%r12),%rax
 108cd46:	movb   $0x1,0x3c5(%rax)
 108cd4d:	mov    0x30(%rsp),%rax
 108cd52:	mov    0x58(%rsp),%r13d
 108cd57:	cmp    $0x23,%eax
 108cd5a:	jne    108cd13 <check_input_expressions+0x3aa3>
 108cd5c:	cmpl   $0x23,0x30(%rsp)
 108cd61:	jne    108cd91 <check_input_expressions+0x3b21>
 108cd63:	mov    (%r12),%rax
 108cd67:	mov    0x150(%r12),%rcx
 108cd6f:	mov    0x28(%rsp),%esi
 108cd73:	mov    0x2a8(%rax),%rax
 108cd7a:	mov    (%rcx,%r14,4),%ecx
 108cd7e:	mov    %r15d,(%rax,%rcx,4)
 108cd82:	cmp    $0xffffffff,%r15d
 108cd86:	jne    108e19f <check_input_expressions+0x4f2f>
 108cd8c:	jmp    10896d6 <check_input_expressions+0x466>
 108cd91:	mov    %r15d,%ecx
 108cd94:	mov    0x28(%rsp),%esi
 108cd98:	mov    %ecx,%r15d
 108cd9b:	test   %r13b,%r13b
 108cd9e:	je     108e184 <check_input_expressions+0x4f14>
 108cda4:	jmp    108e195 <check_input_expressions+0x4f25>
 108cda9:	cmp    $0x2,%r15b
 108cdad:	jne    108ce99 <check_input_expressions+0x3c29>
 108cdb3:	lea    -0x3(%rdi),%eax
 108cdb6:	cmp    $0x1,%al
 108cdb8:	ja     108ce99 <check_input_expressions+0x3c29>
 108cdbe:	mov    0x70(%rsp),%rax
 108cdc3:	mov    (%rax),%r14d
 108cdc6:	cmp    %r14d,%ebx
 108cdc9:	jae    108cdde <check_input_expressions+0x3b6e>
 108cdcb:	mov    0x18(%r9),%rax
 108cdcf:	mov    (%rax,%rbx,4),%eax
 108cdd2:	add    $0xffffffbe,%eax
 108cdd5:	cmp    $0x3,%eax
 108cdd8:	jb     108ceba <check_input_expressions+0x3c4a>
 108cdde:	lea    0x100(%rsp),%rdi
 108cde6:	mov    %r8d,%r14d
 108cde9:	mov    %r12,%rsi
 108cdec:	mov    %ebx,%edx
 108cdee:	vzeroupper
 108cdf1:	call   10d1b10 <check_input_literal>
 108cdf6:	cmpb   $0x0,0x122(%rsp)
 108cdfe:	je     108d03e <check_input_expressions+0x3dce>
 108ce04:	mov    $0xffffffff,%ecx
 108ce09:	mov    $0xffffffff,%r8d
 108ce0f:	mov    $0xffffffff,%r9d
 108ce15:	mov    $0xffffffff,%r15d
 108ce1b:	mov    %r12,%rdi
 108ce1e:	xor    %esi,%esi
 108ce20:	mov    %ebx,%edx
 108ce22:	call   10fb220 <check_input_add>
 108ce27:	vpmovsxbq -0xbef1b0(%rip),%xmm3        # 49dc80 <cbuiltin_test_generated.edges+0x3e40>
 108ce30:	mov    0x10(%rsp),%r9
 108ce35:	mov    $0xffffffff,%r11d
 108ce3b:	vxorps %xmm2,%xmm2,%xmm2
 108ce3f:	cmp    $0xffffffff,%eax
 108ce42:	je     108d38a <check_input_expressions+0x411a>
 108ce48:	mov    0x100(%rsp),%ecx
 108ce4f:	mov    0x108(%rsp),%rdx
 108ce57:	fldt   0x110(%rsp)
 108ce5e:	testb  $0x1,0x121(%rsp)
 108ce66:	mov    0x68(%rsp),%r10
 108ce6b:	je     108d313 <check_input_expressions+0x40a3>
 108ce71:	mov    $0x4,%edi
 108ce76:	mov    %rdx,%r8
 108ce79:	xor    %esi,%esi
 108ce7b:	xor    %edx,%edx
 108ce7d:	fldz
 108ce7f:	jmp    108d346 <check_input_expressions+0x40d6>
 108ce84:	mov    0x18(%rsp),%r12
 108ce89:	mov    0x30(%rsp),%rbx
 108ce8e:	mov    $0xffffffff,%r11d
 108ce94:	jmp    108c96f <check_input_expressions+0x36ff>
 108ce99:	cmp    $0x5,%edi
 108ce9c:	jne    108ceb2 <check_input_expressions+0x3c42>
 108ce9e:	cmp    $0x2,%r15b
 108cea2:	jne    108d0fb <check_input_expressions+0x3e8b>
 108cea8:	mov    0x70(%rsp),%rax
 108cead:	mov    (%rax),%r14d
 108ceb0:	jmp    108cee1 <check_input_expressions+0x3c71>
 108ceb2:	mov    0x70(%rsp),%rax
 108ceb7:	mov    (%rax),%r14d
 108ceba:	cmp    %r14d,%ebx
 108cebd:	jae    108cf5b <check_input_expressions+0x3ceb>
 108cec3:	cmp    $0x2,%r15b
 108cec7:	jne    108cf5b <check_input_expressions+0x3ceb>
 108cecd:	mov    0x18(%r9),%rax
 108ced1:	mov    0x8(%rsp),%rcx
 108ced6:	mov    (%rax,%rcx,4),%eax
 108ced9:	add    $0xffffffbe,%eax
 108cedc:	cmp    $0x3,%eax
 108cedf:	jae    108cf5b <check_input_expressions+0x3ceb>
 108cee1:	mov    0x60(%r9),%rcx
 108cee5:	mov    0x8(%rsp),%rax
 108ceea:	mov    (%rcx,%rax,4),%eax
 108ceed:	mov    $0x1,%bpl
 108cef0:	cmp    %r14d,%eax
 108cef3:	jae    108d240 <check_input_expressions+0x3fd0>
 108cef9:	mov    0x50(%r9),%rdx
 108cefd:	movzbl (%rdx,%rax,1),%edx
 108cf01:	cmp    $0x48,%edx
 108cf04:	je     108cf0b <check_input_expressions+0x3c9b>
 108cf06:	cmp    $0x1e,%edx
 108cf09:	jne    108ceea <check_input_expressions+0x3c7a>
 108cf0b:	mov    0x370(%r12),%rcx
 108cf13:	mov    (%rcx,%rax,4),%ebx
 108cf16:	cmp    %eax,%ebx
 108cf18:	jae    108cf2f <check_input_expressions+0x3cbf>
 108cf1a:	lea    0x2(%rbx),%esi
 108cf1d:	mov    $0x33,%ecx
 108cf22:	mov    %r9,%rdi
 108cf25:	mov    %eax,%edx
 108cf27:	vzeroupper
 108cf2a:	call   1089200 <check_constant_punctuation>
 108cf2f:	mov    0x8(%rsp),%rsi
 108cf34:	cmp    %r14d,%ebx
 108cf37:	jae    108d245 <check_input_expressions+0x3fd5>
 108cf3d:	mov    0x10(%rsp),%rcx
 108cf42:	mov    0x10(%rcx),%rcx
 108cf46:	cmpb   $0x43,(%rcx,%rbx,1)
 108cf4a:	setne  %cl
 108cf4d:	cmp    %eax,%esi
 108cf4f:	setbe  %bpl
 108cf53:	or     %cl,%bpl
 108cf56:	jmp    108d245 <check_input_expressions+0x3fd5>
 108cf5b:	xor    %eax,%eax
 108cf5d:	cmp    $0x1a,%r15b
 108cf61:	sete   %cl
 108cf64:	jne    108d104 <check_input_expressions+0x3e94>
 108cf6a:	cmp    $0x11,%dil
 108cf6e:	jne    108d104 <check_input_expressions+0x3e94>
 108cf74:	mov    0x60(%r9),%rax
 108cf78:	mov    0x8(%rsp),%rcx
 108cf7d:	mov    %esi,0x18(%rsp)
 108cf81:	mov    %edx,0x24(%rsp)
 108cf85:	mov    %r8d,0x4(%rsp)
 108cf8a:	mov    (%rax,%rcx,4),%esi
 108cf8d:	cmp    %r14d,%esi
 108cf90:	jae    108e031 <check_input_expressions+0x4dc1>
 108cf96:	mov    0x10(%rsp),%rdi
 108cf9b:	vzeroupper
 108cf9e:	call   10fa3b0 <check_input_indirect_goto>
 108cfa3:	test   %al,%al
 108cfa5:	je     108e031 <check_input_expressions+0x4dc1>
 108cfab:	mov    0x18(%r12),%rdi
 108cfb0:	xor    %esi,%esi
 108cfb2:	mov    %r12,%rbx
 108cfb5:	mov    (%rdi),%rax
 108cfb8:	cmpb   $0xb,0x1(%rax)
 108cfbc:	sete   %sil
 108cfc0:	xor    $0x9,%esi
 108cfc3:	call   10b2d40 <type_pointer>
 108cfc8:	test   %eax,%eax
 108cfca:	jne    108cfe3 <check_input_expressions+0x3d73>
 108cfcc:	mov    0x18(%rbx),%rcx
 108cfd0:	cmpl   $0x1,0x100(%rcx)
 108cfd7:	jne    108cfe3 <check_input_expressions+0x3d73>
 108cfd9:	mov    (%rbx),%rcx
 108cfdc:	movb   $0x1,0x3c5(%rcx)
 108cfe3:	mov    0xa8(%rbx),%rdx
 108cfea:	mov    0x8(%rsp),%r14
 108cfef:	cmp    $0x1,%ebp
 108cff2:	mov    %rbx,%r12
 108cff5:	sete   %cl
 108cff8:	mov    %eax,(%rdx,%r14,4)
 108cffc:	mov    0xa8(%rbx),%rax
 108d003:	cmpl   $0x0,(%rax,%r14,4)
 108d008:	mov    $0x24,%eax
 108d00d:	setne  %r13b
 108d011:	and    %cl,%r13b
 108d014:	vpmovsxbq -0xbef39d(%rip),%xmm3        # 49dc80 <cbuiltin_test_generated.edges+0x3e40>
 108d01d:	mov    0x10(%rsp),%r9
 108d022:	movl   $0x0,0x28(%rsp)
 108d02a:	vxorps %xmm2,%xmm2,%xmm2
 108d02e:	mov    $0xffffffff,%r11d
 108d034:	mov    0x38(%rsp),%r15
 108d039:	jmp    108d20c <check_input_expressions+0x3f9c>
 108d03e:	mov    (%r12),%rax
 108d042:	mov    0x230(%rax),%ecx
 108d048:	cmp    0x234(%rax),%ecx
 108d04e:	jae    108d216 <check_input_expressions+0x3fa6>
 108d054:	movzbl 0x3c5(%rax),%edx
 108d05b:	mov    0x228(%rax),%rsi
 108d062:	lea    0x1(%rcx),%edi
 108d065:	mov    %edi,0x230(%rax)
 108d06b:	lea    (%rcx,%rcx,2),%rax
 108d06f:	add    $0x3,%edx
 108d072:	mov    %ebx,(%rsi,%rax,4)
 108d075:	mov    %edx,0x4(%rsi,%rax,4)
 108d079:	movl   $0x0,0x8(%rsi,%rax,4)
 108d081:	jmp    108d21d <check_input_expressions+0x3fad>
 108d086:	xor    %esi,%esi
 108d088:	mov    0x68(%rsp),%r13
 108d08d:	mov    %r15d,%ebx
 108d090:	lea    (%rbx,%rbx,2),%rbx
 108d094:	mov    %r8b,%r10b
 108d097:	mov    0x130(%r12),%r8
 108d09f:	mov    %bpl,%r9b
 108d0a2:	shl    $0x3,%r9d
 108d0a6:	shl    $0x5,%rbx
 108d0aa:	or     %edi,%r9d
 108d0ad:	lea    0x1(%r10,%r10,1),%edi
 108d0b2:	add    0x28(%r13),%rbx
 108d0b6:	mov    (%r8,%rcx,4),%ecx
 108d0ba:	mov    %eax,(%rbx)
 108d0bc:	mov    %edx,0x4(%rbx)
 108d0bf:	mov    %r9d,0x8(%rbx)
 108d0c3:	mov    %edi,0xc(%rbx)
 108d0c6:	mov    %r11,0x10(%rbx)
 108d0ca:	mov    %r14,0x18(%rbx)
 108d0ce:	fldz
 108d0d0:	fld    %st(0)
 108d0d2:	fstpt  0x20(%rbx)
 108d0d5:	fstpt  0x30(%rbx)
 108d0d8:	mov    %ecx,0x40(%rbx)
 108d0db:	mov    %esi,0x44(%rbx)
 108d0de:	vmovups %xmm2,0x48(%rbx)
 108d0e3:	movq   $0x0,0x58(%rbx)
 108d0eb:	mov    $0xffffffff,%r11d
 108d0f1:	mov    0x10(%rsp),%r9
 108d0f6:	jmp    108e19f <check_input_expressions+0x4f2f>
 108d0fb:	cmp    $0x1a,%r15b
 108d0ff:	mov    $0x1,%al
 108d101:	sete   %cl
 108d104:	mov    %esi,0x18(%rsp)
 108d108:	mov    %edx,0x24(%rsp)
 108d10c:	cmp    $0x9,%r15b
 108d110:	jne    108d156 <check_input_expressions+0x3ee6>
 108d112:	mov    0x8(%rsp),%r14
 108d117:	cmp    $0x1,%ebp
 108d11a:	mov    $0xffffffff,%r15d
 108d120:	sete   %al
 108d123:	add    $0xfffffff2,%edi
 108d126:	xor    %esi,%esi
 108d128:	cmp    $0x37,%edi
 108d12b:	ja     108e184 <check_input_expressions+0x4f14>
 108d131:	lea    -0xbef178(%rip),%rdx        # 49dfc0 <cbuiltin_test_generated.edges+0x4180>
 108d138:	movslq (%rdx,%rdi,4),%rcx
 108d13c:	add    %rdx,%rcx
 108d13f:	jmp    *%rcx
 108d141:	mov    %eax,%r13d
 108d144:	movl   $0x0,0x28(%rsp)
 108d14c:	mov    $0x19,%eax
 108d151:	jmp    108d81f <check_input_expressions+0x45af>
 108d156:	lea    -0xc(%r15),%edx
 108d15a:	mov    %r8d,0x4(%rsp)
 108d15f:	mov    $0xffffffff,%r8d
 108d165:	cmp    $0xb,%dl
 108d168:	setb   %dl
 108d16b:	cmp    $0x19,%r15b
 108d16f:	sete   %sil
 108d173:	or     %dl,%sil
 108d176:	jne    108d19e <check_input_expressions+0x3f2e>
 108d178:	mov    %r12,%rbx
 108d17b:	cmp    $0x1c,%r15b
 108d17f:	jne    108d39e <check_input_expressions+0x412e>
 108d185:	mov    0x268(%rbx),%rax
 108d18c:	mov    0x8(%rsp),%rcx
 108d191:	mov    %rbx,%r12
 108d194:	cmpb   $0x0,(%rax,%rcx,1)
 108d198:	je     108d61e <check_input_expressions+0x43ae>
 108d19e:	vzeroupper
 108d1a1:	call   10d2ca0 <check_input_binary>
 108d1a6:	mov    0x140(%r12),%rdx
 108d1ae:	mov    0x8(%rsp),%r14
 108d1b3:	cmp    $0x2,%ebp
 108d1b6:	sete   %sil
 108d1ba:	cmp    $0x45,%eax
 108d1bd:	setne  %cl
 108d1c0:	movzbl (%rdx,%r14,1),%edx
 108d1c5:	test   %dl,%dl
 108d1c7:	je     108d3de <check_input_expressions+0x416e>
 108d1cd:	vpmovsxbq -0xbef556(%rip),%xmm3        # 49dc80 <cbuiltin_test_generated.edges+0x3e40>
 108d1d6:	mov    0x10(%rsp),%r9
 108d1db:	cmp    $0x1,%dl
 108d1de:	mov    $0x45,%ecx
 108d1e3:	mov    $0x23,%eax
 108d1e8:	vxorps %xmm2,%xmm2,%xmm2
 108d1ec:	mov    $0xffffffff,%r11d
 108d1f2:	cmove  %eax,%ecx
 108d1f5:	cmp    $0x2,%dl
 108d1f8:	sete   %al
 108d1fb:	cmp    $0x1,%ebp
 108d1fe:	sete   %r13b
 108d202:	mov    %eax,0x28(%rsp)
 108d206:	or     %al,%r13b
 108d209:	mov    %rcx,%rax
 108d20c:	mov    0x4(%rsp),%r8d
 108d211:	jmp    108e099 <check_input_expressions+0x4e29>
 108d216:	movb   $0x1,0x3c5(%rax)
 108d21d:	vpmovsxbq -0xbef5a6(%rip),%xmm3        # 49dc80 <cbuiltin_test_generated.edges+0x3e40>
 108d226:	mov    0x10(%rsp),%r9
 108d22b:	mov    $0xffffffff,%r15d
 108d231:	vxorps %xmm2,%xmm2,%xmm2
 108d235:	mov    $0xffffffff,%r11d
 108d23b:	jmp    108d38a <check_input_expressions+0x411a>
 108d240:	mov    0x8(%rsp),%rsi
 108d245:	mov    %r12,%rdi
 108d248:	vzeroupper
 108d24b:	call   10a1740 <check_input_string>
 108d250:	vpmovsxbq -0xbef5d9(%rip),%xmm3        # 49dc80 <cbuiltin_test_generated.edges+0x3e40>
 108d259:	mov    0x10(%rsp),%r9
 108d25e:	mov    $0xffffffff,%r11d
 108d264:	vxorps %xmm2,%xmm2,%xmm2
 108d268:	test   %bpl,%bpl
 108d26b:	je     10892e0 <check_input_expressions+0x70>
 108d271:	mov    %rax,%r13
 108d274:	test   %rax,%rax
 108d277:	je     10892e0 <check_input_expressions+0x70>
 108d27d:	mov    $0xffffffff,%ecx
 108d282:	mov    $0xffffffff,%r8d
 108d288:	mov    $0xffffffff,%r9d
 108d28e:	mov    0x8(%rsp),%rdx
 108d293:	mov    %r12,%rdi
 108d296:	xor    %esi,%esi
 108d298:	call   10fb220 <check_input_add>
 108d29d:	vpmovsxbq -0xbef626(%rip),%xmm3        # 49dc80 <cbuiltin_test_generated.edges+0x3e40>
 108d2a6:	mov    0x10(%rsp),%r9
 108d2ab:	mov    $0xffffffff,%r11d
 108d2b1:	vxorps %xmm2,%xmm2,%xmm2
 108d2b5:	cmp    $0xffffffff,%eax
 108d2b8:	je     10892e0 <check_input_expressions+0x70>
 108d2be:	vpmovzxbd -0xae1477(%rip),%xmm0        # 5abe50 <link_program_emit_worker.forms+0x3e0>
 108d2c7:	mov    %eax,%r15d
 108d2ca:	mov    0x68(%rsp),%rax
 108d2cf:	mov    0x0(%r13),%edx
 108d2d3:	mov    %r15d,%ecx
 108d2d6:	lea    (%rcx,%rcx,2),%rcx
 108d2da:	shl    $0x5,%rcx
 108d2de:	vpinsrd $0x0,0x8(%r13),%xmm0,%xmm0
 108d2e5:	mov    0x28(%rax),%rax
 108d2e9:	vmovdqa %xmm0,(%rax,%rcx,1)
 108d2ee:	vpxor  %xmm0,%xmm0,%xmm0
 108d2f2:	vmovdqu %ymm0,0x10(%rax,%rcx,1)
 108d2f8:	vmovdqu %ymm0,0x20(%rax,%rcx,1)
 108d2fe:	mov    %edx,0x40(%rax,%rcx,1)
 108d302:	vmovups %xmm2,0x44(%rax,%rcx,1)
 108d308:	vmovups %xmm2,0x50(%rax,%rcx,1)
 108d30e:	jmp    108e19f <check_input_expressions+0x4f2f>
 108d313:	xor    %esi,%esi
 108d315:	xor    %edi,%edi
 108d317:	cmp    $0xb8,%ecx
 108d31d:	mov    $0x2,%r8d
 108d323:	sete   %dil
 108d327:	setne  %sil
 108d32b:	testb  $0x1,0x120(%rsp)
 108d333:	fldz
 108d335:	fxch   %st(1)
 108d337:	lea    0x1(%rdi,%rdi,1),%edi
 108d33b:	cmovne %r8d,%esi
 108d33f:	cmovne %r8d,%edi
 108d343:	xor    %r8d,%r8d
 108d346:	mov    %eax,%r9d
 108d349:	lea    (%r9,%r9,2),%r9
 108d34d:	vpxor  %xmm0,%xmm0,%xmm0
 108d351:	mov    %eax,%r15d
 108d354:	shl    $0x5,%r9
 108d358:	add    0x28(%r10),%r9
 108d35c:	mov    %ecx,(%r9)
 108d35f:	movl   $0x0,0x4(%r9)
 108d367:	mov    %esi,0x8(%r9)
 108d36b:	mov    %edi,0xc(%r9)
 108d36f:	mov    %rdx,0x10(%r9)
 108d373:	mov    %r8,0x18(%r9)
 108d377:	fstpt  0x20(%r9)
 108d37b:	fstpt  0x30(%r9)
 108d37f:	vmovdqu %ymm0,0x40(%r9)
 108d385:	mov    0x10(%rsp),%r9
 108d38a:	xor    %esi,%esi
 108d38c:	mov    %r14d,%r8d
 108d38f:	cmp    $0xffffffff,%r15d
 108d393:	jne    108e19f <check_input_expressions+0x4f2f>
 108d399:	jmp    10896d6 <check_input_expressions+0x466>
 108d39e:	cmp    $0x3b,%r15b
 108d3a2:	jne    108d5fa <check_input_expressions+0x438a>
 108d3a8:	cmp    $0x1,%ebp
 108d3ab:	jne    108d85a <check_input_expressions+0x45ea>
 108d3b1:	mov    $0x1,%ebp
 108d3b6:	vpmovsxbq -0xbef73f(%rip),%xmm3        # 49dc80 <cbuiltin_test_generated.edges+0x3e40>
 108d3bf:	mov    0x10(%rsp),%r9
 108d3c4:	mov    0x4(%rsp),%r8d
 108d3c9:	mov    (%rbx),%r13
 108d3cc:	mov    %rbx,%r12
 108d3cf:	vxorps %xmm2,%xmm2,%xmm2
 108d3d3:	mov    $0xffffffff,%r11d
 108d3d9:	jmp    10896e3 <check_input_expressions+0x473>
 108d3de:	mov    %rax,%rdi
 108d3e1:	and    %cl,%sil
 108d3e4:	movl   $0x0,0x28(%rsp)
 108d3ec:	cmp    $0x1e,%edi
 108d3ef:	jne    108d5bb <check_input_expressions+0x434b>
 108d3f5:	test   %sil,%sil
 108d3f8:	je     108d5bb <check_input_expressions+0x434b>
 108d3fe:	mov    0xa8(%r12),%rax
 108d406:	mov    0x8(%rsp),%rcx
 108d40b:	mov    (%rax,%rcx,4),%eax
 108d40e:	mov    %eax,0x30(%rsp)
 108d412:	test   %eax,%eax
 108d414:	jne    108d48f <check_input_expressions+0x421f>
 108d416:	vpxor  %xmm0,%xmm0,%xmm0
 108d41a:	vmovdqu64 %zmm0,0x120(%rsp)
 108d425:	vmovdqu64 %zmm0,0x100(%rsp)
 108d42d:	mov    0x8(%rsp),%rcx
 108d432:	mov    %r12,%rdi
 108d435:	movl   $0x0,0x28(%rsp)
 108d43d:	mov    $0x1,%r8d
 108d443:	lea    0x100(%rsp),%r9
 108d44b:	mov    0x368(%r12),%rax
 108d453:	lea    0x1(%rcx),%esi
 108d456:	mov    (%rax,%rcx,4),%edx
 108d459:	xor    %ecx,%ecx
 108d45b:	inc    %edx
 108d45d:	push   $0x0
 108d45f:	lea    0xe8(%rsp),%rax
 108d467:	push   %rax
 108d468:	vzeroupper
 108d46b:	call   10c24f0 <check_input_constant_read>
 108d470:	add    $0x10,%rsp
 108d474:	mov    0x100(%rsp),%ecx
 108d47b:	test   %ecx,%ecx
 108d47d:	mov    %ecx,0x30(%rsp)
 108d481:	setne  %cl
 108d484:	and    %al,%cl
 108d486:	cmp    $0x1,%cl
 108d489:	jne    108d885 <check_input_expressions+0x4615>
 108d48f:	mov    0x18(%r12),%rcx
 108d494:	movl   $0x0,0x28(%rsp)
 108d49c:	mov    0x48(%rcx),%eax
 108d49f:	test   %eax,%eax
 108d4a1:	je     108d640 <check_input_expressions+0x43d0>
 108d4a7:	mov    (%rcx),%rsi
 108d4aa:	mov    0x30(%rsp),%edi
 108d4ae:	xor    %edx,%edx
 108d4b0:	mov    %edi,%r8d
 108d4b3:	shr    $0x3,%r8d
 108d4b7:	movzbl (%rsi,%r8,1),%r9d
 108d4bc:	cmp    $0xf,%r9b
 108d4c0:	jne    108d4d6 <check_input_expressions+0x4266>
 108d4c2:	mov    0x20(%rcx),%r9
 108d4c6:	mov    (%r9,%r8,4),%r8d
 108d4ca:	or     %r8d,%edi
 108d4cd:	shr    $0x3,%r8d
 108d4d1:	movzbl (%rsi,%r8,1),%r9d
 108d4d6:	lea    -0x8(%r9),%r10d
 108d4da:	cmp    $0x2,%r10b
 108d4de:	ja     108d50a <check_input_expressions+0x429a>
 108d4e0:	mov    0x20(%rcx),%r10
 108d4e4:	cmp    $0xa,%r9b
 108d4e8:	sete   %r9b
 108d4ec:	and    $0x7,%edi
 108d4ef:	or     %r9b,%dl
 108d4f2:	or     (%r10,%r8,4),%edi
 108d4f6:	je     108d50a <check_input_expressions+0x429a>
 108d4f8:	mov    0x28(%rsp),%r8d
 108d4fd:	inc    %r8d
 108d500:	mov    %r8d,0x28(%rsp)
 108d505:	cmp    %r8d,%eax
 108d508:	jne    108d4b0 <check_input_expressions+0x4240>
 108d50a:	movl   $0x0,0x28(%rsp)
 108d512:	test   $0x1,%dl
 108d515:	je     108d640 <check_input_expressions+0x43d0>
 108d51b:	mov    0xa8(%r12),%rdx
 108d523:	mov    0x8(%rsp),%rdi
 108d528:	xor    %r8d,%r8d
 108d52b:	mov    (%r12),%rsi
 108d52f:	mov    %r12,0x18(%rsp)
 108d534:	cmp    (%rdx,%rdi,4),%r8d
 108d538:	mov    %rsi,0x58(%rsp)
 108d53d:	mov    0x30(%rsp),%edi
 108d541:	sbb    %edx,%edx
 108d543:	or     0x4(%rsp),%edx
 108d547:	mov    %edx,0x80(%rsp)
 108d54e:	mov    0x28(%r12),%rdx
 108d553:	mov    0x8(%rdx),%rsi
 108d557:	mov    %rsi,0x78(%rsp)
 108d55c:	mov    (%rcx),%rsi
 108d55f:	jmp    108d599 <check_input_expressions+0x4329>
 108d561:	mov    0x20(%rcx),%r8
 108d565:	mov    (%r8,%rdi,4),%edi
 108d569:	shr    $0x3,%edi
 108d56c:	movzbl (%rsi,%rdi,1),%r9d
 108d571:	add    $0xf8,%r9b
 108d575:	cmp    $0x3,%r9b
 108d579:	jae    108d8e0 <check_input_expressions+0x4670>
 108d57f:	mov    0x28(%rsp),%r9d
 108d584:	mov    (%r8,%rdi,4),%edi
 108d588:	inc    %r9d
 108d58b:	mov    %r9d,0x28(%rsp)
 108d590:	cmp    %r9d,%eax
 108d593:	je     108d8dc <check_input_expressions+0x466c>
 108d599:	shr    $0x3,%edi
 108d59c:	movzbl (%rsi,%rdi,1),%r8d
 108d5a1:	cmp    $0xf,%r8b
 108d5a5:	je     108d561 <check_input_expressions+0x42f1>
 108d5a7:	add    $0xf8,%r8b
 108d5ab:	cmp    $0x2,%r8b
 108d5af:	ja     108d8e0 <check_input_expressions+0x4670>
 108d5b5:	mov    0x20(%rcx),%r8
 108d5b9:	jmp    108d57f <check_input_expressions+0x430f>
 108d5bb:	vpmovsxbq -0xbef944(%rip),%xmm3        # 49dc80 <cbuiltin_test_generated.edges+0x3e40>
 108d5c4:	mov    %esi,%r13d
 108d5c7:	mov    0x10(%rsp),%r9
 108d5cc:	mov    0x8(%rsp),%r14
 108d5d1:	mov    0x38(%rsp),%r15
 108d5d6:	mov    0x4(%rsp),%r8d
 108d5db:	mov    0x18(%rsp),%esi
 108d5df:	mov    0x40(%rsp),%r10d
 108d5e4:	mov    0x24(%rsp),%edx
 108d5e8:	vxorps %xmm2,%xmm2,%xmm2
 108d5ec:	mov    $0xffffffff,%r11d
 108d5f2:	mov    %rdi,%rax
 108d5f5:	jmp    10898c0 <check_input_expressions+0x650>
 108d5fa:	movzbl 0x38(%rsp),%edx
 108d5ff:	lea    -0xa(%rdx),%esi
 108d602:	cmp    $0x48,%esi
 108d605:	ja     108de8c <check_input_expressions+0x4c1c>
 108d60b:	lea    -0xbef8a6(%rip),%r9        # 49dd6c <cbuiltin_test_generated.edges+0x3f2c>
 108d612:	movslq (%r9,%rsi,4),%rsi
 108d616:	add    %r9,%rsi
 108d619:	jmp    *%rsi
 108d61b:	mov    %rbx,%r12
 108d61e:	vpmovsxbq -0xbef9a7(%rip),%xmm3        # 49dc80 <cbuiltin_test_generated.edges+0x3e40>
 108d627:	mov    0x10(%rsp),%r9
 108d62c:	mov    0x4(%rsp),%r8d
 108d631:	vxorps %xmm2,%xmm2,%xmm2
 108d635:	mov    $0xffffffff,%r11d
 108d63b:	jmp    10896e3 <check_input_expressions+0x473>
 108d640:	vpmovsxbq -0xbef9c9(%rip),%xmm3        # 49dc80 <cbuiltin_test_generated.edges+0x3e40>
 108d649:	mov    0x10(%rsp),%r9
 108d64e:	mov    0x8(%rsp),%r14
 108d653:	mov    0x38(%rsp),%r15
 108d658:	mov    0x4(%rsp),%r8d
 108d65d:	mov    0x18(%rsp),%esi
 108d661:	mov    0x40(%rsp),%r10d
 108d666:	mov    0x24(%rsp),%edx
 108d66a:	vxorps %xmm2,%xmm2,%xmm2
 108d66e:	mov    $0xffffffff,%r11d
 108d674:	mov    $0x1,%r13b
 108d677:	mov    $0x1e,%eax
 108d67c:	jmp    10898c0 <check_input_expressions+0x650>
 108d681:	mov    %eax,%r13d
 108d684:	movl   $0x0,0x28(%rsp)
 108d68c:	mov    $0x1a,%eax
 108d691:	jmp    108d81f <check_input_expressions+0x45af>
 108d696:	mov    %eax,%r13d
 108d699:	movl   $0x0,0x28(%rsp)
 108d6a1:	mov    $0x2,%eax
 108d6a6:	jmp    108d81f <check_input_expressions+0x45af>
 108d6ab:	mov    %eax,%r13d
 108d6ae:	movl   $0x0,0x28(%rsp)
 108d6b6:	mov    $0x34,%eax
 108d6bb:	jmp    108d81f <check_input_expressions+0x45af>
 108d6c0:	mov    0x18(%r9),%rcx
 108d6c4:	xor    %edx,%edx
 108d6c6:	movl   $0x0,0x28(%rsp)
 108d6ce:	mov    %eax,%r13d
 108d6d1:	mov    (%rcx,%r14,4),%ecx
 108d6d5:	and    $0xfffffffe,%ecx
 108d6d8:	cmp    $0x56,%ecx
 108d6db:	sete   %dl
 108d6de:	or     $0x40,%edx
 108d6e1:	mov    %rdx,%rax
 108d6e4:	jmp    108d81f <check_input_expressions+0x45af>
 108d6e9:	mov    0x300(%r13),%rax
 108d6f0:	mov    0x18(%r12),%rdi
 108d6f5:	mov    $0x8,%esi
 108d6fa:	mov    %r8d,0x4(%rsp)
 108d6ff:	mov    %r12,%rbx
 108d702:	mov    (%rax,%r14,4),%r14d
 108d706:	vzeroupper
 108d709:	call   10b2d40 <type_pointer>
 108d70e:	test   %eax,%eax
 108d710:	je     108d8b9 <check_input_expressions+0x4649>
 108d716:	mov    %eax,%r13d
 108d719:	mov    0x70(%rsp),%rax
 108d71e:	cmp    (%rax),%r14d
 108d721:	setb   %al
 108d724:	test   %ebp,%ebp
 108d726:	sete   %cl
 108d729:	and    %al,%cl
 108d72b:	cmp    $0x1,%cl
 108d72e:	jne    108e3c2 <check_input_expressions+0x5152>
 108d734:	mov    $0xffffffff,%ecx
 108d739:	mov    $0xffffffff,%r8d
 108d73f:	mov    $0xffffffff,%r9d
 108d745:	mov    0x8(%rsp),%rdx
 108d74a:	mov    %rbx,%r12
 108d74d:	mov    %rbx,%rdi
 108d750:	xor    %esi,%esi
 108d752:	call   10fb220 <check_input_add>
 108d757:	vpmovsxbq -0xbefae0(%rip),%xmm3        # 49dc80 <cbuiltin_test_generated.edges+0x3e40>
 108d760:	mov    0x10(%rsp),%r9
 108d765:	mov    $0xffffffff,%r11d
 108d76b:	vxorps %xmm2,%xmm2,%xmm2
 108d76f:	cmp    $0xffffffff,%eax
 108d772:	je     10892e0 <check_input_expressions+0x70>
 108d778:	mov    0x68(%rsp),%rcx
 108d77d:	mov    %eax,%r15d
 108d780:	inc    %r14d
 108d783:	movabs $0x8000000000,%rdx
 108d78d:	vpxor  %xmm0,%xmm0,%xmm0
 108d791:	mov    0x28(%rcx),%rax
 108d795:	mov    %r15d,%ecx
 108d798:	lea    (%rcx,%rcx,2),%rcx
 108d79c:	shl    $0x5,%rcx
 108d7a0:	mov    %r13d,(%rax,%rcx,1)
 108d7a4:	mov    %rdx,0x4(%rax,%rcx,1)
 108d7a9:	movl   $0x3,0xc(%rax,%rcx,1)
 108d7b1:	vmovdqu %ymm0,0x10(%rax,%rcx,1)
 108d7b7:	vmovdqu %ymm0,0x20(%rax,%rcx,1)
 108d7bd:	mov    %r14d,0x40(%rax,%rcx,1)
 108d7c2:	jmp    108d302 <check_input_expressions+0x4092>
 108d7c7:	mov    %eax,%r13d
 108d7ca:	mov    $0x1,%eax
 108d7cf:	movl   $0x0,0x28(%rsp)
 108d7d7:	jmp    108d81f <check_input_expressions+0x45af>
 108d7d9:	mov    %eax,%r13d
 108d7dc:	movl   $0x0,0x28(%rsp)
 108d7e4:	mov    $0x26,%eax
 108d7e9:	jmp    108d81f <check_input_expressions+0x45af>
 108d7eb:	mov    %eax,%r13d
 108d7ee:	movl   $0x0,0x28(%rsp)
 108d7f6:	mov    $0x27,%eax
 108d7fb:	jmp    108d81f <check_input_expressions+0x45af>
 108d7fd:	mov    %eax,%r13d
 108d800:	movl   $0x0,0x28(%rsp)
 108d808:	mov    $0x4,%eax
 108d80d:	jmp    108d81f <check_input_expressions+0x45af>
 108d80f:	mov    %eax,%r13d
 108d812:	movl   $0x0,0x28(%rsp)
 108d81a:	mov    $0x3,%eax
 108d81f:	mov    0x38(%rsp),%r15
 108d824:	mov    0x18(%rsp),%esi
 108d828:	mov    0x24(%rsp),%edx
 108d82c:	jmp    10898c0 <check_input_expressions+0x650>
 108d831:	mov    0x18(%r9),%rax
 108d835:	xor    %edi,%edi
 108d837:	mov    %r8d,0x4(%rsp)
 108d83c:	cmpl   $0x17,(%rax,%r14,4)
 108d841:	sete   %dil
 108d845:	xor    $0x1f,%edi
 108d848:	cmp    $0x1,%ebp
 108d84b:	jne    108d86b <check_input_expressions+0x45fb>
 108d84d:	mov    $0x1,%sil
 108d850:	mov    $0x1,%ebp
 108d855:	jmp    108d3e4 <check_input_expressions+0x4174>
 108d85a:	mov    $0xffffffff,%r15d
 108d860:	mov    %rbx,%r12
 108d863:	mov    $0x1,%sil
 108d866:	jmp    108e3c7 <check_input_expressions+0x5157>
 108d86b:	mov    0xa8(%r12),%rax
 108d873:	mov    0x8(%rsp),%rcx
 108d878:	cmpl   $0x0,(%rax,%rcx,4)
 108d87c:	setne  %sil
 108d880:	jmp    108d3e4 <check_input_expressions+0x4174>
 108d885:	mov    $0x1e,%eax
 108d88a:	vpmovsxbq -0xbefc13(%rip),%xmm3        # 49dc80 <cbuiltin_test_generated.edges+0x3e40>
 108d893:	mov    0x10(%rsp),%r9
 108d898:	mov    0x8(%rsp),%r14
 108d89d:	mov    0x38(%rsp),%r15
 108d8a2:	mov    0x4(%rsp),%r8d
 108d8a7:	vxorps %xmm2,%xmm2,%xmm2
 108d8ab:	mov    $0xffffffff,%r11d
 108d8b1:	mov    $0x1,%r13b
 108d8b4:	jmp    108e099 <check_input_expressions+0x4e29>
 108d8b9:	mov    0x18(%rbx),%rax
 108d8bd:	cmpl   $0x1,0x100(%rax)
 108d8c4:	jne    108e3c2 <check_input_expressions+0x5152>
 108d8ca:	mov    (%rbx),%rax
 108d8cd:	mov    %rbx,%r12
 108d8d0:	movb   $0x1,0x3c5(%rax)
 108d8d7:	jmp    108e3c5 <check_input_expressions+0x5155>
 108d8dc:	mov    %eax,0x28(%rsp)
 108d8e0:	mov    (%rdx),%rcx
 108d8e3:	mov    0x78(%rsp),%rsi
 108d8e8:	lea    0x7(%rsi,%rcx,1),%rdi
 108d8ed:	lea    (%rsi,%rcx,1),%rax
 108d8f1:	and    $0xfffffffffffffff8,%rdi
 108d8f5:	mov    %rdi,0x48(%rsp)
 108d8fa:	cmp    %rax,%rdi
 108d8fd:	jae    108dc00 <check_input_expressions+0x4990>
 108d903:	mov    0x58(%rsp),%rax
 108d908:	mov    0x18(%rsp),%rcx
 108d90d:	movb   $0x1,0x3c5(%rax)
 108d914:	mov    0x18(%rcx),%rcx
 108d918:	movq   $0x0,0x48(%rsp)
 108d921:	mov    (%rcx),%rsi
 108d924:	mov    0x30(%rsp),%eax
 108d928:	mov    $0x1,%r14d
 108d92e:	xor    %ebx,%ebx
 108d930:	mov    $0x1,%r8b
 108d933:	shr    $0x3,%eax
 108d936:	mov    0x38(%rcx),%rdx
 108d93a:	cmpb   $0xf,(%rsi,%rax,1)
 108d93e:	jne    108d94a <check_input_expressions+0x46da>
 108d940:	mov    0x20(%rcx),%rcx
 108d944:	mov    (%rcx,%rax,4),%eax
 108d947:	shr    $0x3,%eax
 108d94a:	mov    (%rdx,%rax,8),%rcx
 108d94e:	mov    %rcx,%rax
 108d951:	mul    %r14
 108d954:	seto   %al
 108d957:	or     %al,%r8b
 108d95a:	jne    108e496 <check_input_expressions+0x5226>
 108d960:	mov    0x18(%rsp),%rax
 108d965:	imul   %rcx,%r14
 108d969:	mov    $0x1,%r13b
 108d96c:	mov    $0xffffffff,%r12d
 108d972:	mov    (%rax),%r15
 108d975:	mov    0x18(%rsp),%rdi
 108d97a:	mov    $0xffffffff,%ecx
 108d97f:	mov    $0xffffffff,%r8d
 108d985:	mov    $0xffffffff,%r9d
 108d98b:	mov    0x8(%rsp),%rdx
 108d990:	xor    %esi,%esi
 108d992:	vzeroupper
 108d995:	call   10fb220 <check_input_add>
 108d99a:	cmp    $0xffffffff,%eax
 108d99d:	je     108e496 <check_input_expressions+0x5226>
 108d9a3:	vpmovsxbd -0xae1b64(%rip),%xmm0        # 5abe48 <link_program_emit_worker.forms+0x3d8>
 108d9ac:	mov    0x28(%r15),%rcx
 108d9b0:	mov    %eax,%edx
 108d9b2:	lea    (%rdx,%rdx,2),%rdx
 108d9b6:	shl    $0x5,%rdx
 108d9ba:	vmovdqa %xmm0,(%rcx,%rdx,1)
 108d9bf:	mov    %r14,0x10(%rcx,%rdx,1)
 108d9c4:	movq   $0x0,0x18(%rcx,%rdx,1)
 108d9cd:	fldz
 108d9cf:	fld    %st(0)
 108d9d1:	fstpt  0x20(%rcx,%rdx,1)
 108d9d5:	fstpt  0x30(%rcx,%rdx,1)
 108d9d9:	vpxor  %xmm0,%xmm0,%xmm0
 108d9dd:	vmovdqu %ymm0,0x40(%rcx,%rdx,1)
 108d9e3:	test   %r13b,%r13b
 108d9e6:	jne    108da0b <check_input_expressions+0x479b>
 108d9e8:	mov    0x18(%rsp),%rdi
 108d9ed:	mov    $0x7,%esi
 108d9f2:	mov    $0xffffffff,%r9d
 108d9f8:	mov    0x8(%rsp),%rdx
 108d9fd:	mov    %r12d,%ecx
 108da00:	mov    %eax,%r8d
 108da03:	vzeroupper
 108da06:	call   10fb220 <check_input_add>
 108da0b:	mov    %eax,%r12d
 108da0e:	cmp    $0xffffffff,%r12d
 108da12:	setne  %al
 108da15:	test   %ebx,%ebx
 108da17:	setne  %cl
 108da1a:	and    %al,%cl
 108da1c:	cmp    $0x1,%cl
 108da1f:	jne    108dbb2 <check_input_expressions+0x4942>
 108da25:	mov    %ebx,%r14d
 108da28:	shl    $0x4,%r14
 108da2c:	add    $0xfffffffffffffff0,%r14
 108da30:	mov    0x48(%rsp),%rax
 108da35:	mov    (%rax,%r14,1),%rcx
 108da39:	mov    0x8(%rax,%r14,1),%r15d
 108da3e:	movzbl 0xc(%rax,%r14,1),%r13d
 108da44:	mov    %rcx,0x40(%rsp)
 108da49:	test   $0x1,%r13b
 108da4d:	je     108da6c <check_input_expressions+0x47fc>
 108da4f:	mov    0x18(%rsp),%rax
 108da54:	lea    -0x1(%r15),%ecx
 108da58:	lea    (%rcx,%rcx,8),%rcx
 108da5c:	mov    (%rax),%rax
 108da5f:	mov    0x330(%rax),%rax
 108da66:	mov    0x10(%rax,%rcx,4),%ecx
 108da6a:	jmp    108da96 <check_input_expressions+0x4826>
 108da6c:	mov    0x18(%rsp),%rdi
 108da71:	mov    $0x3a,%esi
 108da76:	mov    $0xffffffff,%ecx
 108da7b:	mov    $0xffffffff,%r8d
 108da81:	mov    $0xffffffff,%r9d
 108da87:	mov    0x8(%rsp),%rdx
 108da8c:	vzeroupper
 108da8f:	call   10fb220 <check_input_add>
 108da94:	mov    %eax,%ecx
 108da96:	cmp    $0xffffffff,%ecx
 108da99:	je     108e496 <check_input_expressions+0x5226>
 108da9f:	mov    0x58(%rsp),%rax
 108daa4:	mov    0x18(%rsp),%rdi
 108daa9:	mov    $0x7,%esi
 108daae:	mov    $0xffffffff,%r9d
 108dab4:	mov    %ecx,%edx
 108dab6:	mov    %r12d,%r8d
 108dab9:	mov    0x38(%rax),%rax
 108dabd:	mov    %r15d,(%rax,%rdx,4)
 108dac1:	mov    0x8(%rsp),%rdx
 108dac6:	vzeroupper
 108dac9:	call   10fb220 <check_input_add>
 108dace:	cmp    $0xffffffff,%eax
 108dad1:	je     108e496 <check_input_expressions+0x5226>
 108dad7:	mov    %eax,%r12d
 108dada:	test   $0x1,%r13b
 108dade:	jne    108daf3 <check_input_expressions+0x4883>
 108dae0:	mov    0x18(%rsp),%rax
 108dae5:	dec    %r15d
 108dae8:	mov    0x260(%rax),%rax
 108daef:	mov    %r12d,(%rax,%r15,4)
 108daf3:	cmpq   $0x1,0x40(%rsp)
 108daf9:	je     108db98 <check_input_expressions+0x4928>
 108daff:	mov    0x18(%rsp),%rdi
 108db04:	mov    $0xffffffff,%ecx
 108db09:	mov    $0xffffffff,%r8d
 108db0f:	mov    $0xffffffff,%r9d
 108db15:	mov    0x8(%rsp),%rdx
 108db1a:	xor    %esi,%esi
 108db1c:	mov    (%rdi),%rbx
 108db1f:	call   10fb220 <check_input_add>
 108db24:	cmp    $0xffffffff,%eax
 108db27:	je     108e496 <check_input_expressions+0x5226>
 108db2d:	vpmovsxbd -0xae1cee(%rip),%xmm0        # 5abe48 <link_program_emit_worker.forms+0x3d8>
 108db36:	mov    0x28(%rbx),%rcx
 108db3a:	mov    0x40(%rsp),%rsi
 108db3f:	mov    %eax,%edx
 108db41:	lea    (%rdx,%rdx,2),%rdx
 108db45:	mov    $0xffffffff,%r9d
 108db4b:	mov    %eax,%r8d
 108db4e:	shl    $0x5,%rdx
 108db52:	vmovdqa %xmm0,(%rcx,%rdx,1)
 108db57:	mov    %rsi,0x10(%rcx,%rdx,1)
 108db5c:	movq   $0x0,0x18(%rcx,%rdx,1)
 108db65:	fldz
 108db67:	fld    %st(0)
 108db69:	fstpt  0x20(%rcx,%rdx,1)
 108db6d:	fstpt  0x30(%rcx,%rdx,1)
 108db71:	mov    $0x7,%esi
 108db76:	vpxor  %xmm0,%xmm0,%xmm0
 108db7a:	vmovdqu %ymm0,0x40(%rcx,%rdx,1)
 108db80:	mov    %r12d,%ecx
 108db83:	mov    0x18(%rsp),%rdi
 108db88:	mov    0x8(%rsp),%rdx
 108db8d:	vzeroupper
 108db90:	call   10fb220 <check_input_add>
 108db95:	mov    %eax,%r12d
 108db98:	cmp    $0xffffffff,%r12d
 108db9c:	setne  %al
 108db9f:	test   %r14,%r14
 108dba2:	je     108dbb2 <check_input_expressions+0x4942>
 108dba4:	add    $0xfffffffffffffff0,%r14
 108dba8:	cmp    $0xffffffff,%r12d
 108dbac:	jne    108da30 <check_input_expressions+0x47c0>
 108dbb2:	cmpl   $0xffffffff,0x80(%rsp)
 108dbba:	je     108e44f <check_input_expressions+0x51df>
 108dbc0:	test   %al,%al
 108dbc2:	je     108e44f <check_input_expressions+0x51df>
 108dbc8:	mov    0x18(%rsp),%rdi
 108dbcd:	mov    0x80(%rsp),%ecx
 108dbd4:	mov    $0x1c,%esi
 108dbd9:	mov    $0xffffffff,%r9d
 108dbdf:	mov    0x8(%rsp),%rdx
 108dbe4:	mov    %r12d,%r8d
 108dbe7:	vzeroupper
 108dbea:	call   10fb220 <check_input_add>
 108dbef:	mov    %eax,%r12d
 108dbf2:	cmp    $0xffffffff,%eax
 108dbf5:	jne    108e453 <check_input_expressions+0x51e3>
 108dbfb:	jmp    108e496 <check_input_expressions+0x5226>
 108dc00:	mov    0x48(%rsp),%rax
 108dc05:	sub    %rcx,%rax
 108dc08:	mov    0x10(%rdx),%rcx
 108dc0c:	sub    %rax,%rcx
 108dc0f:	jb     108d903 <check_input_expressions+0x4693>
 108dc15:	mov    0x28(%rsp),%esi
 108dc19:	shl    $0x4,%rsi
 108dc1d:	cmp    %rcx,%rsi
 108dc20:	ja     108d903 <check_input_expressions+0x4693>
 108dc26:	mov    0x18(%rsp),%rdi
 108dc2b:	add    %rsi,%rax
 108dc2e:	mov    0x48(%rsp),%rsi
 108dc33:	mov    %rax,0x8(%rdx)
 108dc37:	mov    (%rdi),%rcx
 108dc3a:	test   %rsi,%rsi
 108dc3d:	sete   %al
 108dc40:	or     %al,0x3c5(%rcx)
 108dc46:	mov    0x18(%rdi),%rcx
 108dc4a:	test   %rsi,%rsi
 108dc4d:	je     108d918 <check_input_expressions+0x46a8>
 108dc53:	mov    0x48(%rcx),%edx
 108dc56:	test   %edx,%edx
 108dc58:	je     108d921 <check_input_expressions+0x46b1>
 108dc5e:	mov    (%rcx),%rsi
 108dc61:	mov    0x30(%rsp),%edi
 108dc65:	xor    %eax,%eax
 108dc67:	mov    %edi,%r8d
 108dc6a:	shr    $0x3,%r8d
 108dc6e:	movzbl (%rsi,%r8,1),%r9d
 108dc73:	cmp    $0xf,%r9b
 108dc77:	jne    108dc8d <check_input_expressions+0x4a1d>
 108dc79:	mov    0x20(%rcx),%r9
 108dc7d:	mov    (%r9,%r8,4),%r8d
 108dc81:	or     %r8d,%edi
 108dc84:	shr    $0x3,%r8d
 108dc88:	movzbl (%rsi,%r8,1),%r9d
 108dc8d:	lea    -0x8(%r9),%r10d
 108dc91:	cmp    $0x2,%r10b
 108dc95:	ja     108dcb3 <check_input_expressions+0x4a43>
 108dc97:	mov    0x20(%rcx),%r10
 108dc9b:	cmp    $0xa,%r9b
 108dc9f:	sete   %r9b
 108dca3:	and    $0x7,%edi
 108dca6:	or     %r9b,%al
 108dca9:	or     (%r10,%r8,4),%edi
 108dcad:	je     108dcb3 <check_input_expressions+0x4a43>
 108dcaf:	dec    %edx
 108dcb1:	jne    108dc67 <check_input_expressions+0x49f7>
 108dcb3:	test   $0x1,%al
 108dcb5:	je     108d921 <check_input_expressions+0x46b1>
 108dcbb:	mov    0x30(%rsp),%eax
 108dcbf:	xor    %ebx,%ebx
 108dcc1:	xor    %edi,%edi
 108dcc3:	mov    (%rcx),%rsi
 108dcc6:	inc    %edi
 108dcc8:	mov    $0x1,%r14d
 108dcce:	mov    %eax,%r8d
 108dcd1:	shr    $0x3,%r8d
 108dcd5:	movzbl (%rsi,%r8,1),%edx
 108dcda:	mov    %edx,%r9d
 108dcdd:	cmp    $0xf,%dl
 108dce0:	jne    108dcf3 <check_input_expressions+0x4a83>
 108dce2:	mov    0x20(%rcx),%r9
 108dce6:	mov    (%r9,%r8,4),%r9d
 108dcea:	shr    $0x3,%r9d
 108dcee:	movzbl (%rsi,%r9,1),%r9d
 108dcf3:	add    $0xf8,%r9b
 108dcf7:	cmp    $0x2,%r9b
 108dcfb:	ja     108e6ca <check_input_expressions+0x545a>
 108dd01:	lea    -0x1(%rdi),%r9d
 108dd05:	cmp    0x48(%rcx),%r9d
 108dd09:	jae    108e6ca <check_input_expressions+0x545a>
 108dd0f:	cmp    $0xf,%dl
 108dd12:	jne    108dd25 <check_input_expressions+0x4ab5>
 108dd14:	mov    0x20(%rcx),%rax
 108dd18:	mov    (%rax,%r8,4),%r8d
 108dd1c:	shr    $0x3,%r8d
 108dd20:	movzbl (%rsi,%r8,1),%edx
 108dd25:	mov    0x30(%rcx),%rax
 108dd29:	mov    (%rax,%r8,8),%rax
 108dd2d:	cmp    $0xa,%dl
 108dd30:	je     108dd53 <check_input_expressions+0x4ae3>
 108dd32:	mov    %rax,%r9
 108dd35:	inc    %edi
 108dd37:	imul   %r14,%r9
 108dd3b:	mul    %r14
 108dd3e:	mov    0x20(%rcx),%rdx
 108dd42:	mov    %r9,%r14
 108dd45:	mov    (%rdx,%r8,4),%eax
 108dd49:	mov    $0x1,%r8b
 108dd4c:	jno    108dcce <check_input_expressions+0x4a5e>
 108dd4e:	jmp    108e700 <check_input_expressions+0x5490>
 108dd53:	test   %rax,%rax
 108dd56:	je     108eaa0 <check_input_expressions+0x5830>
 108dd5c:	mov    0x18(%rsp),%rdx
 108dd61:	mov    0x8(%rdx),%rdx
 108dd65:	mov    0x30(%rdx),%edx
 108dd68:	cmp    %rdx,%rax
 108dd6b:	ja     108eaa0 <check_input_expressions+0x5830>
 108dd71:	mov    0x18(%rsp),%rdx
 108dd76:	mov    0x248(%rdx),%rdx
 108dd7d:	mov    -0x4(%rdx,%rax,4),%eax
 108dd81:	test   %eax,%eax
 108dd83:	je     108eaa0 <check_input_expressions+0x5830>
 108dd89:	mov    0x18(%rsp),%rdx
 108dd8e:	mov    (%rdx),%r15
 108dd91:	cmp    0x338(%r15),%eax
 108dd98:	ja     108eaa0 <check_input_expressions+0x5830>
 108dd9e:	mov    0x330(%r15),%rdx
 108dda5:	lea    -0x1(%rax),%ecx
 108dda8:	lea    (%rcx,%rcx,8),%rsi
 108ddac:	cmpl   $0xffffffff,(%rdx,%rsi,4)
 108ddb0:	jne    108dddc <check_input_expressions+0x4b6c>
 108ddb2:	lea    (%rdx,%rsi,4),%rdx
 108ddb6:	mov    0x8(%rsp),%rsi
 108ddbb:	cmp    %esi,0x8(%rdx)
 108ddbe:	jbe    108dddc <check_input_expressions+0x4b6c>
 108ddc0:	mov    0xc(%rdx),%esi
 108ddc3:	mov    0x18(%rsp),%rdx
 108ddc8:	mov    0x8(%rsp),%r10
 108ddcd:	mov    0x368(%rdx),%r9
 108ddd4:	mov    $0x1,%dl
 108ddd6:	cmp    (%r9,%r10,4),%esi
 108ddda:	jbe    108ddf6 <check_input_expressions+0x4b86>
 108dddc:	mov    0x18(%rsp),%rdx
 108dde1:	mov    0x260(%rdx),%rdx
 108dde8:	mov    (%rdx,%rcx,4),%ecx
 108ddeb:	cmp    $0xffffffff,%ecx
 108ddee:	jne    108eb30 <check_input_expressions+0x58c0>
 108ddf4:	xor    %edx,%edx
 108ddf6:	mov    0x48(%rsp),%rsi
 108ddfb:	mov    %ebx,%ecx
 108ddfd:	shl    $0x4,%rcx
 108de01:	inc    %ebx
 108de03:	mov    %r14,(%rsi,%rcx,1)
 108de07:	mov    %eax,0x8(%rsi,%rcx,1)
 108de0b:	mov    %dl,0xc(%rsi,%rcx,1)
 108de0f:	movw   $0x0,0xd(%rsi,%rcx,1)
 108de16:	movb   $0x0,0xf(%rsi,%rcx,1)
 108de1b:	mov    0x18(%rsp),%rcx
 108de20:	mov    0x18(%rcx),%rcx
 108de24:	mov    0x20(%rcx),%rax
 108de28:	mov    (%rax,%r8,4),%eax
 108de2c:	jmp    108dcc3 <check_input_expressions+0x4a53>
 108de31:	cmp    $0x1,%ebp
 108de34:	sete   %al
 108de37:	xor    %ecx,%ecx
 108de39:	cmp    $0x14,%edi
 108de3c:	sete   %cl
 108de3f:	cmp    $0x18,%edi
 108de42:	sete   %r13b
 108de46:	or     %cl,%r13b
 108de49:	and    %al,%r13b
 108de4c:	mov    %rcx,%rax
 108de4f:	xor    $0x29,%eax
 108de52:	jmp    108dfc4 <check_input_expressions+0x4d54>
 108de57:	cmp    $0x1,%ebp
 108de5a:	jne    108dfb6 <check_input_expressions+0x4d46>
 108de60:	mov    0x8(%rsp),%rax
 108de65:	mov    0x70(%rsp),%rcx
 108de6a:	inc    %eax
 108de6c:	cmp    (%rcx),%eax
 108de6e:	jae    108dfb6 <check_input_expressions+0x4d46>
 108de74:	mov    0x10(%rsp),%rcx
 108de79:	mov    %eax,%eax
 108de7b:	mov    0x50(%rcx),%rcx
 108de7f:	cmpb   $0x3,(%rcx,%rax,1)
 108de83:	sete   %r13b
 108de87:	jmp    108dfb9 <check_input_expressions+0x4d49>
 108de8c:	mov    0x38(%rsp),%rsi
 108de91:	and    $0xfe,%sil
 108de95:	cmp    $0x3c,%sil
 108de99:	jne    108e021 <check_input_expressions+0x4db1>
 108de9f:	mov    0x208(%rbx),%rax
 108dea6:	mov    0x8(%rsp),%rcx
 108deab:	movzwl (%rax,%rcx,2),%r15d
 108deb0:	mov    0x218(%r13),%rax
 108deb7:	test   %rax,%rax
 108deba:	je     108e682 <check_input_expressions+0x5412>
 108dec0:	mov    0x8(%rsp),%rcx
 108dec5:	mov    %r15d,%edi
 108dec8:	mov    (%rax,%rcx,4),%r14d
 108decc:	vzeroupper
 108decf:	call   1089130 <check_graph_builtin_op>
 108ded4:	test   %r14d,%r14d
 108ded7:	je     108e68d <check_input_expressions+0x541d>
 108dedd:	movl   $0x0,0x28(%rsp)
 108dee5:	mov    $0x43,%eax
 108deea:	mov    %rbx,%r12
 108deed:	jmp    108d88a <check_input_expressions+0x461a>
 108def2:	cmp    $0x1,%ebp
 108def5:	jne    108e3bc <check_input_expressions+0x514c>
 108defb:	mov    0xa8(%rbx),%rax
 108df02:	mov    0x8(%rsp),%r14
 108df07:	mov    $0x1,%ebp
 108df0c:	mov    %rbx,%r12
 108df0f:	cmpl   $0x0,(%rax,%r14,4)
 108df14:	mov    $0x18,%eax
 108df19:	setne  %r13b
 108df1d:	jmp    108d014 <check_input_expressions+0x3da4>
 108df22:	mov    0xa8(%rbx),%rax
 108df29:	mov    0x8(%rsp),%rcx
 108df2e:	cmp    $0x1,%ebp
 108df31:	sete   %dil
 108df35:	mov    (%rax,%rcx,4),%ecx
 108df38:	test   %ecx,%ecx
 108df3a:	je     108dff1 <check_input_expressions+0x4d81>
 108df40:	mov    0x10(%rsp),%rdx
 108df45:	mov    0x8(%rsp),%rsi
 108df4a:	mov    0x70(%rsp),%r8
 108df4f:	mov    0x60(%rdx),%rdx
 108df53:	mov    (%rdx,%rsi,4),%edx
 108df56:	cmp    (%r8),%edx
 108df59:	jae    108dff1 <check_input_expressions+0x4d81>
 108df5f:	vpmovsxbq -0xbf02e8(%rip),%xmm3        # 49dc80 <cbuiltin_test_generated.edges+0x3e40>
 108df68:	mov    0x10(%rsp),%r9
 108df6d:	mov    0x4(%rsp),%r8d
 108df72:	mov    %ecx,(%rax,%rdx,4)
 108df75:	mov    %rbx,%r12
 108df78:	vxorps %xmm2,%xmm2,%xmm2
 108df7c:	mov    $0xffffffff,%r11d
 108df82:	cmp    $0x1,%ebp
 108df85:	mov    $0x1,%ebp
 108df8a:	jne    10892e0 <check_input_expressions+0x70>
 108df90:	jmp    10896df <check_input_expressions+0x46f>
 108df95:	cmp    $0x2,%ebp
 108df98:	mov    $0x1d,%eax
 108df9d:	sete   %r13b
 108dfa1:	jmp    108dfc4 <check_input_expressions+0x4d54>
 108dfa3:	mov    %ebp,%eax
 108dfa5:	and    $0xfffffffe,%eax
 108dfa8:	cmp    $0x2,%eax
 108dfab:	mov    $0x17,%eax
 108dfb0:	sete   %r13b
 108dfb4:	jmp    108dfc4 <check_input_expressions+0x4d54>
 108dfb6:	xor    %r13d,%r13d
 108dfb9:	xor    %eax,%eax
 108dfbb:	cmp    $0x17,%edi
 108dfbe:	sete   %al
 108dfc1:	or     $0x20,%eax
 108dfc4:	movl   $0x0,0x28(%rsp)
 108dfcc:	mov    0x10(%rsp),%r9
 108dfd1:	mov    %rbx,%r12
 108dfd4:	vpmovsxbq -0xbf035d(%rip),%xmm3        # 49dc80 <cbuiltin_test_generated.edges+0x3e40>
 108dfdd:	mov    0x8(%rsp),%r14
 108dfe2:	mov    $0xffffffff,%r11d
 108dfe8:	vxorps %xmm2,%xmm2,%xmm2
 108dfec:	jmp    108d034 <check_input_expressions+0x3dc4>
 108dff1:	vpmovsxbq -0xbf037a(%rip),%xmm3        # 49dc80 <cbuiltin_test_generated.edges+0x3e40>
 108dffa:	mov    0x10(%rsp),%r9
 108dfff:	mov    0x4(%rsp),%r8d
 108e004:	mov    $0xffffffff,%r11d
 108e00a:	mov    %rbx,%r12
 108e00d:	vxorps %xmm2,%xmm2,%xmm2
 108e011:	mov    %edi,%esi
 108e013:	test   %sil,%sil
 108e016:	je     10892e0 <check_input_expressions+0x70>
 108e01c:	jmp    10896df <check_input_expressions+0x46f>
 108e021:	mov    0x38(%rsp),%r15
 108e026:	mov    %rbx,%r12
 108e029:	test   %cl,%cl
 108e02b:	je     108e540 <check_input_expressions+0x52d0>
 108e031:	mov    0xf8(%r12),%rax
 108e039:	mov    0x8(%rsp),%r14
 108e03e:	mov    (%rax,%r14,4),%eax
 108e042:	test   %rax,%rax
 108e045:	setne  %cl
 108e048:	cmp    $0x2,%ebp
 108e04b:	setb   %dl
 108e04e:	and    %cl,%dl
 108e050:	mov    %edx,0x58(%rsp)
 108e054:	cmp    $0x1,%ebp
 108e057:	jne    108e0ab <check_input_expressions+0x4e3b>
 108e059:	vpmovsxbq -0xbf03e2(%rip),%xmm3        # 49dc80 <cbuiltin_test_generated.edges+0x3e40>
 108e062:	mov    0xa8(%r12),%rcx
 108e06a:	mov    0x10(%rsp),%r9
 108e06f:	mov    0x4(%rsp),%r8d
 108e074:	mov    0x58(%rsp),%r13d
 108e079:	mov    $0x1,%ebp
 108e07e:	movl   $0x0,0x28(%rsp)
 108e086:	vxorps %xmm2,%xmm2,%xmm2
 108e08a:	mov    $0xffffffff,%r11d
 108e090:	mov    %eax,(%rcx,%r14,4)
 108e094:	mov    $0x24,%eax
 108e099:	mov    0x18(%rsp),%esi
 108e09d:	mov    0x40(%rsp),%r10d
 108e0a2:	mov    0x24(%rsp),%edx
 108e0a6:	jmp    10898c0 <check_input_expressions+0x650>
 108e0ab:	mov    0x18(%r12),%rdx
 108e0b0:	shr    $0x3,%eax
 108e0b3:	mov    %r12,%rbx
 108e0b6:	mov    (%rdx),%rcx
 108e0b9:	movzbl (%rcx,%rax,1),%esi
 108e0bd:	cmp    $0xf,%sil
 108e0c1:	jne    108e0d1 <check_input_expressions+0x4e61>
 108e0c3:	mov    0x20(%rdx),%rdx
 108e0c7:	mov    (%rdx,%rax,4),%eax
 108e0ca:	shr    $0x3,%eax
 108e0cd:	movzbl (%rcx,%rax,1),%esi
 108e0d1:	cmp    $0x1,%sil
 108e0d5:	je     108e151 <check_input_expressions+0x4ee1>
 108e0d7:	mov    0x68(%rsp),%rax
 108e0dc:	mov    0x58(%rax),%rax
 108e0e0:	test   %rax,%rax
 108e0e3:	je     108e0ff <check_input_expressions+0x4e8f>
 108e0e5:	mov    0x68(%rsp),%rcx
 108e0ea:	mov    0x8(%rsp),%rdx
 108e0ef:	cmp    0x60(%rcx),%edx
 108e0f2:	jae    108e0ff <check_input_expressions+0x4e8f>
 108e0f4:	mov    0x8(%rsp),%rcx
 108e0f9:	cmpb   $0x0,(%rax,%rcx,1)
 108e0fd:	jne    108e151 <check_input_expressions+0x4ee1>
 108e0ff:	mov    0x230(%r13),%eax
 108e106:	cmp    0x234(%r13),%eax
 108e10d:	jae    108e149 <check_input_expressions+0x4ed9>
 108e10f:	movzbl 0x3c5(%r13),%ecx
 108e117:	lea    0x1(%rax),%esi
 108e11a:	mov    0x228(%r13),%rdx
 108e121:	lea    (%rax,%rax,2),%rax
 108e125:	mov    %esi,0x230(%r13)
 108e12c:	mov    0x8(%rsp),%rsi
 108e131:	xor    $0x1,%ecx
 108e134:	lea    0x4(%rcx,%rcx,1),%ecx
 108e138:	mov    %esi,(%rdx,%rax,4)
 108e13b:	mov    %ecx,0x4(%rdx,%rax,4)
 108e13f:	movl   $0x0,0x8(%rdx,%rax,4)
 108e147:	jmp    108e151 <check_input_expressions+0x4ee1>
 108e149:	movb   $0x1,0x3c5(%r13)
 108e151:	vpmovsxbq -0xbf04da(%rip),%xmm3        # 49dc80 <cbuiltin_test_generated.edges+0x3e40>
 108e15a:	cmpb   $0x0,0x58(%rsp)
 108e15f:	mov    0x10(%rsp),%r9
 108e164:	mov    0x4(%rsp),%r8d
 108e169:	mov    $0xffffffff,%r11d
 108e16f:	mov    %rbx,%r12
 108e172:	vxorps %xmm2,%xmm2,%xmm2
 108e176:	jne    10892e0 <check_input_expressions+0x70>
 108e17c:	mov    $0xffffffff,%r15d
 108e182:	xor    %esi,%esi
 108e184:	mov    (%r12),%rax
 108e188:	cmpl   $0x0,0x230(%rax)
 108e18f:	je     108e3f5 <check_input_expressions+0x5185>
 108e195:	cmp    $0xffffffff,%r15d
 108e199:	je     10896d6 <check_input_expressions+0x466>
 108e19f:	mov    (%r12),%rax
 108e1a3:	mov    0x68(%rsp),%rbx
 108e1a8:	mov    0x8(%rsp),%r14
 108e1ad:	mov    0x220(%rax),%rcx
 108e1b4:	mov    %r15d,%eax
 108e1b7:	test   %rcx,%rcx
 108e1ba:	je     108e212 <check_input_expressions+0x4fa2>
 108e1bc:	mov    0x10(%rbx),%rdx
 108e1c0:	mov    0x70(%rsp),%rsi
 108e1c5:	mov    (%rdx,%rax,4),%edx
 108e1c8:	cmp    %r11,%rdx
 108e1cb:	je     108e1d8 <check_input_expressions+0x4f68>
 108e1cd:	shl    $0x2,%rdx
 108e1d1:	add    0x8(%rbx),%rdx
 108e1d5:	mov    %rdx,%rsi
 108e1d8:	mov    (%rbx),%rdx
 108e1db:	mov    (%rsi),%esi
 108e1dd:	mov    (%rdx,%rax,4),%edi
 108e1e0:	xor    %edx,%edx
 108e1e2:	cmp    $0x34,%edi
 108e1e5:	je     108e202 <check_input_expressions+0x4f92>
 108e1e7:	cmp    $0x19,%edi
 108e1ea:	je     108e202 <check_input_expressions+0x4f92>
 108e1ec:	test   %edi,%edi
 108e1ee:	jne    108e20e <check_input_expressions+0x4f9e>
 108e1f0:	mov    0x28(%rbx),%rdx
 108e1f4:	lea    (%rax,%rax,2),%rsi
 108e1f8:	shl    $0x5,%rsi
 108e1fc:	mov    0x44(%rdx,%rsi,1),%edx
 108e200:	jmp    108e20e <check_input_expressions+0x4f9e>
 108e202:	mov    0x70(%rsp),%rdi
 108e207:	cmp    (%rdi),%esi
 108e209:	jae    108e20e <check_input_expressions+0x4f9e>
 108e20b:	mov    (%rcx,%rsi,4),%edx
 108e20e:	mov    %edx,(%rcx,%r14,4)
 108e212:	mov    0x280(%r12),%rcx
 108e21a:	cmpb   $0x0,(%rcx,%r14,1)
 108e21f:	je     108e372 <check_input_expressions+0x5102>
 108e225:	mov    (%rbx),%rcx
 108e228:	cmpl   $0x3c,(%rcx,%rax,4)
 108e22c:	jne    108e372 <check_input_expressions+0x5102>
 108e232:	mov    0x38(%rbx),%rcx
 108e236:	cmpl   $0x120,(%rcx,%rax,4)
 108e23d:	jne    108e372 <check_input_expressions+0x5102>
 108e243:	mov    0x370(%r12),%rax
 108e24b:	vpxor  %xmm0,%xmm0,%xmm0
 108e24f:	mov    (%rax,%r14,4),%esi
 108e253:	vmovdqu64 %zmm0,0x120(%rsp)
 108e25e:	vmovdqu64 %zmm0,0x100(%rsp)
 108e266:	cmp    %r14d,%esi
 108e269:	jae    108e372 <check_input_expressions+0x5102>
 108e26f:	lea    0x1(%r14),%edx
 108e273:	mov    %r12,%rdi
 108e276:	xor    %ecx,%ecx
 108e278:	mov    $0x1,%r8d
 108e27e:	lea    0x100(%rsp),%r9
 108e286:	push   $0x0
 108e288:	lea    0xe8(%rsp),%rax
 108e290:	push   %rax
 108e291:	vzeroupper
 108e294:	call   10c24f0 <check_input_constant_read>
 108e299:	add    $0x10,%rsp
 108e29d:	test   %al,%al
 108e29f:	je     108e35a <check_input_expressions+0x50ea>
 108e2a5:	vpmovsxbq -0xbf062e(%rip),%xmm3        # 49dc80 <cbuiltin_test_generated.edges+0x3e40>
 108e2ae:	cmpl   $0x0,0x10c(%rsp)
 108e2b6:	mov    0x10(%rsp),%r9
 108e2bb:	mov    $0xffffffff,%r11d
 108e2c1:	vxorps %xmm2,%xmm2,%xmm2
 108e2c5:	je     108e372 <check_input_expressions+0x5102>
 108e2cb:	cmpl   $0x0,0x154(%rsp)
 108e2d3:	jne    108e372 <check_input_expressions+0x5102>
 108e2d9:	testb  $0x10,0x108(%rsp)
 108e2e1:	jne    108e372 <check_input_expressions+0x5102>
 108e2e7:	mov    $0xffffffff,%ecx
 108e2ec:	mov    $0xffffffff,%r8d
 108e2f2:	mov    $0xffffffff,%r9d
 108e2f8:	mov    %r12,%rdi
 108e2fb:	xor    %esi,%esi
 108e2fd:	mov    %r14d,%edx
 108e300:	call   10fb220 <check_input_add>
 108e305:	vpmovsxbq -0xbf068e(%rip),%xmm3        # 49dc80 <cbuiltin_test_generated.edges+0x3e40>
 108e30e:	mov    0x10(%rsp),%r9
 108e313:	mov    $0xffffffff,%r11d
 108e319:	vxorps %xmm2,%xmm2,%xmm2
 108e31d:	cmp    $0xffffffff,%eax
 108e320:	je     108e372 <check_input_expressions+0x5102>
 108e322:	vmovdqu64 0x100(%rsp),%zmm0
 108e32a:	vmovups 0x120(%rsp),%zmm1
 108e335:	mov    0x28(%rbx),%rcx
 108e339:	mov    %eax,%edx
 108e33b:	lea    (%rdx,%rdx,2),%rdx
 108e33f:	mov    %eax,%r15d
 108e342:	shl    $0x5,%rdx
 108e346:	vmovups %zmm1,0x20(%rcx,%rdx,1)
 108e351:	vmovdqu64 %zmm0,(%rcx,%rdx,1)
 108e358:	jmp    108e372 <check_input_expressions+0x5102>
 108e35a:	vpmovsxbq -0xbf06e3(%rip),%xmm3        # 49dc80 <cbuiltin_test_generated.edges+0x3e40>
 108e363:	mov    0x10(%rsp),%r9
 108e368:	vxorps %xmm2,%xmm2,%xmm2
 108e36c:	mov    $0xffffffff,%r11d
 108e372:	mov    (%r12),%rax
 108e376:	cmpb   $0x1a,0x38(%rsp)
 108e37b:	mov    0x2c0(%rax),%rax
 108e382:	mov    %r15d,(%rax,%r14,4)
 108e386:	je     10892e0 <check_input_expressions+0x70>
 108e38c:	movzbl 0x38(%rsp),%eax
 108e391:	cmp    $0x49,%eax
 108e394:	je     10892e0 <check_input_expressions+0x70>
 108e39a:	mov    0x380(%r12),%rax
 108e3a2:	mov    0x8(%rsp),%rcx
 108e3a7:	mov    %r15d,(%rax,%rcx,4)
 108e3ab:	mov    0x388(%r12),%rax
 108e3b3:	mov    %r15d,(%rax,%rcx,4)
 108e3b7:	jmp    10892e0 <check_input_expressions+0x70>
 108e3bc:	mov    $0xffffffff,%r15d
 108e3c2:	mov    %rbx,%r12
 108e3c5:	xor    %esi,%esi
 108e3c7:	vpmovsxbq -0xbf0750(%rip),%xmm3        # 49dc80 <cbuiltin_test_generated.edges+0x3e40>
 108e3d0:	mov    0x10(%rsp),%r9
 108e3d5:	mov    0x4(%rsp),%r8d
 108e3da:	vxorps %xmm2,%xmm2,%xmm2
 108e3de:	mov    $0xffffffff,%r11d
 108e3e4:	mov    (%r12),%rax
 108e3e8:	cmpl   $0x0,0x230(%rax)
 108e3ef:	jne    108e195 <check_input_expressions+0x4f25>
 108e3f5:	cmpl   $0x0,0x234(%rax)
 108e3fc:	je     108e439 <check_input_expressions+0x51c9>
 108e3fe:	movzbl 0x3c5(%rax),%ecx
 108e405:	mov    0x228(%rax),%rdx
 108e40c:	movl   $0x1,0x230(%rax)
 108e416:	mov    0x8(%rsp),%rax
 108e41b:	shl    $0x2,%ecx
 108e41e:	mov    %eax,(%rdx)
 108e420:	mov    %ecx,0x4(%rdx)
 108e423:	movl   $0x0,0x8(%rdx)
 108e42a:	cmp    $0xffffffff,%r15d
 108e42e:	jne    108e19f <check_input_expressions+0x4f2f>
 108e434:	jmp    10896d6 <check_input_expressions+0x466>
 108e439:	movb   $0x1,0x3c5(%rax)
 108e440:	cmp    $0xffffffff,%r15d
 108e444:	jne    108e19f <check_input_expressions+0x4f2f>
 108e44a:	jmp    10896d6 <check_input_expressions+0x466>
 108e44f:	test   %al,%al
 108e451:	je     108e496 <check_input_expressions+0x5226>
 108e453:	mov    0x18(%rsp),%rdi
 108e458:	mov    $0x3b,%esi
 108e45d:	mov    $0xffffffff,%r8d
 108e463:	mov    $0xffffffff,%r9d
 108e469:	mov    0x8(%rsp),%rdx
 108e46e:	mov    %r12d,%ecx
 108e471:	vzeroupper
 108e474:	call   10fb220 <check_input_add>
 108e479:	cmp    $0xffffffff,%eax
 108e47c:	je     108e496 <check_input_expressions+0x5226>
 108e47e:	mov    0x58(%rsp),%rcx
 108e483:	mov    %eax,%r15d
 108e486:	mov    0x30(%rsp),%edx
 108e48a:	mov    0x30(%rcx),%rax
 108e48e:	mov    %r15d,%ecx
 108e491:	mov    %edx,(%rax,%rcx,4)
 108e494:	jmp    108e4ee <check_input_expressions+0x527e>
 108e496:	mov    0x18(%rsp),%rax
 108e49b:	mov    (%rax),%rax
 108e49e:	mov    0x230(%rax),%ecx
 108e4a4:	cmp    0x234(%rax),%ecx
 108e4aa:	jae    108e4e1 <check_input_expressions+0x5271>
 108e4ac:	movzbl 0x3c5(%rax),%edx
 108e4b3:	lea    0x1(%rcx),%edi
 108e4b6:	mov    0x228(%rax),%rsi
 108e4bd:	mov    %edi,0x230(%rax)
 108e4c3:	lea    (%rcx,%rcx,2),%rax
 108e4c7:	mov    0x8(%rsp),%rcx
 108e4cc:	lea    0x1(%rdx,%rdx,2),%edx
 108e4d0:	mov    %ecx,(%rsi,%rax,4)
 108e4d3:	mov    %edx,0x4(%rsi,%rax,4)
 108e4d7:	movl   $0x0,0x8(%rsi,%rax,4)
 108e4df:	jmp    108e4e8 <check_input_expressions+0x5278>
 108e4e1:	movb   $0x1,0x3c5(%rax)
 108e4e8:	mov    $0xffffffff,%r15d
 108e4ee:	mov    0x18(%rsp),%rax
 108e4f3:	mov    0x78(%rsp),%rcx
 108e4f8:	mov    0x28(%rax),%rax
 108e4fc:	cmp    0x8(%rax),%rcx
 108e500:	ja     108eb75 <check_input_expressions+0x5905>
 108e506:	vpmovsxbq -0xbf088f(%rip),%xmm3        # 49dc80 <cbuiltin_test_generated.edges+0x3e40>
 108e50f:	mov    0x78(%rsp),%rcx
 108e514:	mov    0x18(%rsp),%r12
 108e519:	mov    0x10(%rsp),%r9
 108e51e:	mov    0x4(%rsp),%r8d
 108e523:	mov    $0xffffffff,%r11d
 108e529:	vxorps %xmm2,%xmm2,%xmm2
 108e52d:	mov    %rcx,0x8(%rax)
 108e531:	cmp    $0xffffffff,%r15d
 108e535:	jne    108e19f <check_input_expressions+0x4f2f>
 108e53b:	jmp    108e17c <check_input_expressions+0x4f0c>
 108e540:	mov    $0xffffffff,%r15d
 108e546:	add    $0xfffffff8,%edx
 108e549:	cmp    $0x4b,%edx
 108e54c:	ja     108e74b <check_input_expressions+0x54db>
 108e552:	lea    -0xbf06c9(%rip),%rsi        # 49de90 <cbuiltin_test_generated.edges+0x4050>
 108e559:	movslq (%rsi,%rdx,4),%rcx
 108e55d:	add    %rsi,%rcx
 108e560:	jmp    *%rcx
 108e562:	mov    0x270(%rbx),%rax
 108e569:	mov    0x8(%rsp),%rdx
 108e56e:	mov    0x10(%rsp),%rsi
 108e573:	cmpb   $0x0,(%rax,%rdx,1)
 108e577:	sete   %al
 108e57a:	cmp    $0x2,%ebp
 108e57d:	setb   %cl
 108e580:	or     %al,%cl
 108e582:	mov    0x60(%rsi),%rax
 108e586:	mov    %ecx,0x58(%rsp)
 108e58a:	mov    (%rax,%rdx,4),%eax
 108e58d:	cmp    0x30(%rsi),%eax
 108e590:	jae    108e5d3 <check_input_expressions+0x5363>
 108e592:	mov    0x320(%r13),%rcx
 108e599:	mov    (%rcx,%rax,4),%ecx
 108e59c:	test   %ecx,%ecx
 108e59e:	je     108e5d3 <check_input_expressions+0x5363>
 108e5a0:	mov    0x318(%r13),%rax
 108e5a7:	mov    0x8(%rsp),%rdx
 108e5ac:	dec    %ecx
 108e5ae:	lea    (%rcx,%rcx,2),%rcx
 108e5b2:	cmp    %edx,0x14(%rax,%rcx,8)
 108e5b6:	jne    108e5d3 <check_input_expressions+0x5363>
 108e5b8:	cmp    $0x1,%ebp
 108e5bb:	mov    $0xffffffff,%edx
 108e5c0:	lea    (%rax,%rcx,8),%rax
 108e5c4:	cmove  0x4(%rsp),%edx
 108e5c9:	sete   %cl
 108e5cc:	mov    %ecx,0x58(%rsp)
 108e5d0:	mov    %edx,0x10(%rax)
 108e5d3:	cmpl   $0xffffffff,0x4(%rsp)
 108e5d8:	je     108e99d <check_input_expressions+0x572d>
 108e5de:	mov    0x4(%rsp),%r15d
 108e5e3:	mov    $0xffffffff,%r14d
 108e5e9:	jmp    108e609 <check_input_expressions+0x5399>
 108e5eb:	mov    %r14d,%eax
 108e5ee:	mov    0x390(%rbx),%rcx
 108e5f5:	mov    %r15d,%edx
 108e5f8:	mov    %eax,%r14d
 108e5fb:	mov    (%rcx,%rdx,4),%r15d
 108e5ff:	cmp    $0xffffffff,%r15d
 108e603:	je     108e151 <check_input_expressions+0x4ee1>
 108e609:	mov    0x270(%rbx),%rax
 108e610:	mov    0x8(%rsp),%rdx
 108e615:	mov    $0x25,%esi
 108e61a:	mov    $0xffffffff,%r8d
 108e620:	mov    $0xffffffff,%r9d
 108e626:	mov    %rbx,%rdi
 108e629:	mov    %r15d,%ecx
 108e62c:	cmpb   $0x0,(%rax,%rdx,1)
 108e630:	mov    $0x18,%eax
 108e635:	cmove  %eax,%esi
 108e638:	vzeroupper
 108e63b:	call   10fb220 <check_input_add>
 108e640:	cmp    $0xffffffff,%eax
 108e643:	je     108e5eb <check_input_expressions+0x537b>
 108e645:	mov    0x68(%rsp),%rcx
 108e64a:	mov    %eax,%edx
 108e64c:	mov    0x30(%rcx),%rcx
 108e650:	movl   $0x8,(%rcx,%rdx,4)
 108e657:	mov    0x278(%rbx),%rcx
 108e65e:	test   %rcx,%rcx
 108e661:	je     108e5eb <check_input_expressions+0x537b>
 108e663:	cmp    $0xffffffff,%r14d
 108e667:	je     108e675 <check_input_expressions+0x5405>
 108e669:	mov    0x390(%rbx),%rcx
 108e670:	mov    %r14d,%edx
 108e673:	jmp    108e67a <check_input_expressions+0x540a>
 108e675:	mov    0x8(%rsp),%rdx
 108e67a:	mov    %eax,(%rcx,%rdx,4)
 108e67d:	jmp    108e5ee <check_input_expressions+0x537e>
 108e682:	mov    %r15d,%edi
 108e685:	vzeroupper
 108e688:	call   1089130 <check_graph_builtin_op>
 108e68d:	lea    -0x153(%r15),%ecx
 108e694:	cmp    $0x6,%cx
 108e698:	jae    108e6b4 <check_input_expressions+0x5444>
 108e69a:	cmp    $0x1,%ebp
 108e69d:	mov    $0x40,%eax
 108e6a2:	sete   %r13b
 108e6a6:	cmp    $0x156,%r15w
 108e6ac:	sbb    $0xffffffff,%eax
 108e6af:	jmp    108dfc4 <check_input_expressions+0x4d54>
 108e6b4:	cmp    $0x36,%eax
 108e6b7:	jne    108e6d2 <check_input_expressions+0x5462>
 108e6b9:	cmp    $0x3,%ebp
 108e6bc:	mov    $0x36,%eax
 108e6c1:	sete   %r13b
 108e6c5:	jmp    108dfc4 <check_input_expressions+0x4d54>
 108e6ca:	xor    %r8d,%r8d
 108e6cd:	jmp    108d933 <check_input_expressions+0x46c3>
 108e6d2:	lea    -0x13(%r15),%esi
 108e6d6:	test   %r15d,%r15d
 108e6d9:	je     108e708 <check_input_expressions+0x5498>
 108e6db:	cmp    $0x45,%eax
 108e6de:	jne    108e73e <check_input_expressions+0x54ce>
 108e6e0:	xor    %ecx,%ecx
 108e6e2:	cmp    $0x3,%si
 108e6e6:	setb   %cl
 108e6e9:	cmp    $0x16,%r15w
 108e6ee:	lea    0x1(%rcx,%rcx,1),%ecx
 108e6f2:	setb   %dl
 108e6f5:	cmp    %ecx,%ebp
 108e6f7:	sete   %r13b
 108e6fb:	and    %dl,%r13b
 108e6fe:	jmp    108e717 <check_input_expressions+0x54a7>
 108e700:	xor    %r14d,%r14d
 108e703:	jmp    108d933 <check_input_expressions+0x46c3>
 108e708:	test   %ebp,%ebp
 108e70a:	setne  %r13b
 108e70e:	cmp    $0x45,%eax
 108e711:	jne    108dfc4 <check_input_expressions+0x4d54>
 108e717:	cmp    $0x3,%si
 108e71b:	mov    $0x0,%ecx
 108e720:	mov    $0x22,%eax
 108e725:	movl   $0x0,0x28(%rsp)
 108e72d:	adc    $0x35,%ecx
 108e730:	test   %r15d,%r15d
 108e733:	cmove  %eax,%ecx
 108e736:	mov    %rcx,%rax
 108e739:	jmp    108dfcc <check_input_expressions+0x4d5c>
 108e73e:	movl   $0x0,0x28(%rsp)
 108e746:	jmp    108deea <check_input_expressions+0x4c7a>
 108e74b:	test   %al,%al
 108e74d:	je     108e9aa <check_input_expressions+0x573a>
 108e753:	mov    0x10(%rsp),%rcx
 108e758:	mov    0x8(%rsp),%rdx
 108e75d:	mov    0x60(%rcx),%rax
 108e761:	mov    0x30(%rcx),%ecx
 108e764:	mov    (%rax,%rdx,4),%edx
 108e767:	cmp    %ecx,%edx
 108e769:	jae    108e3c2 <check_input_expressions+0x5152>
 108e76f:	mov    0x10(%rsp),%rsi
 108e774:	mov    0x50(%rsi),%rsi
 108e778:	movzbl (%rsi,%rdx,1),%esi
 108e77c:	cmp    $0x1e,%esi
 108e77f:	je     108e3c2 <check_input_expressions+0x5152>
 108e785:	vpmovsxbq -0xbf0b0e(%rip),%xmm3        # 49dc80 <cbuiltin_test_generated.edges+0x3e40>
 108e78e:	mov    0x10(%rsp),%r9
 108e793:	mov    $0xffffffff,%r11d
 108e799:	mov    %rbx,%r12
 108e79c:	vxorps %xmm2,%xmm2,%xmm2
 108e7a0:	cmp    $0x48,%esi
 108e7a3:	jne    108e764 <check_input_expressions+0x54f4>
 108e7a5:	jmp    10892e0 <check_input_expressions+0x70>
 108e7aa:	cmp    $0x2,%ebp
 108e7ad:	jne    108e3c2 <check_input_expressions+0x5152>
 108e7b3:	mov    0x10(%rsp),%rcx
 108e7b8:	mov    0x8(%rsp),%rdx
 108e7bd:	mov    0x60(%rcx),%rax
 108e7c1:	mov    (%rax,%rdx,4),%eax
 108e7c4:	cmp    0x30(%rcx),%eax
 108e7c7:	jae    108eb26 <check_input_expressions+0x58b6>
 108e7cd:	mov    0x10(%rsp),%rcx
 108e7d2:	mov    $0x2,%ebp
 108e7d7:	mov    0x50(%rcx),%rcx
 108e7db:	cmpb   $0x53,(%rcx,%rax,1)
 108e7df:	je     108d3b6 <check_input_expressions+0x4146>
 108e7e5:	jmp    108e3c2 <check_input_expressions+0x5152>
 108e7ea:	mov    0x208(%rbx),%rax
 108e7f1:	mov    0x8(%rsp),%rcx
 108e7f6:	movzwl (%rax,%rcx,2),%edi
 108e7fa:	test   %edi,%edi
 108e7fc:	je     108eab0 <check_input_expressions+0x5840>
 108e802:	vzeroupper
 108e805:	call   1089130 <check_graph_builtin_op>
 108e80a:	cmp    $0x45,%eax
 108e80d:	setne  %r13b
 108e811:	jmp    108dfc4 <check_input_expressions+0x4d54>
 108e816:	mov    0x370(%rbx),%rax
 108e81d:	mov    0x8(%rsp),%rcx
 108e822:	mov    0x70(%rsp),%rdx
 108e827:	cmp    $0x1,%ebp
 108e82a:	sete   %r13b
 108e82e:	mov    (%rax,%rcx,4),%eax
 108e831:	cmp    (%rdx),%eax
 108e833:	jae    108e9e9 <check_input_expressions+0x5779>
 108e839:	mov    0x10(%rsp),%r9
 108e83e:	movl   $0x0,0x28(%rsp)
 108e846:	mov    %rbx,%r12
 108e849:	mov    0x10(%r9),%rcx
 108e84d:	cmpb   $0x49,(%rcx,%rax,1)
 108e851:	mov    $0x25,%ecx
 108e856:	mov    $0x1,%eax
 108e85b:	cmove  %eax,%ecx
 108e85e:	mov    %rcx,%rax
 108e861:	jmp    108dfd4 <check_input_expressions+0x4d64>
 108e866:	mov    0x150(%rbx),%rax
 108e86d:	mov    0x8(%rsp),%rcx
 108e872:	mov    (%rax,%rcx,4),%r14d
 108e876:	cmp    %r8,%r14
 108e879:	je     108e3c2 <check_input_expressions+0x5152>
 108e87f:	mov    0x280(%r13),%rax
 108e886:	cmpb   $0x0,(%rax,%r14,1)
 108e88b:	je     108e3c2 <check_input_expressions+0x5152>
 108e891:	mov    $0xffffffff,%ecx
 108e896:	mov    $0xffffffff,%r8d
 108e89c:	mov    $0xffffffff,%r9d
 108e8a2:	mov    0x8(%rsp),%rdx
 108e8a7:	mov    %rbx,%r12
 108e8aa:	mov    %rbx,%rdi
 108e8ad:	xor    %esi,%esi
 108e8af:	vzeroupper
 108e8b2:	call   10fb220 <check_input_add>
 108e8b7:	vpmovsxbq -0xbf0c40(%rip),%xmm3        # 49dc80 <cbuiltin_test_generated.edges+0x3e40>
 108e8c0:	mov    0x10(%rsp),%r9
 108e8c5:	mov    $0xffffffff,%r11d
 108e8cb:	vxorps %xmm2,%xmm2,%xmm2
 108e8cf:	cmp    $0xffffffff,%eax
 108e8d2:	je     10892e0 <check_input_expressions+0x70>
 108e8d8:	mov    0x118(%r12),%rsi
 108e8e0:	mov    %eax,%r15d
 108e8e3:	mov    %r15d,%ecx
 108e8e6:	lea    (%rcx,%rcx,2),%rcx
 108e8ea:	mov    0xa0(%r12),%rdx
 108e8f2:	mov    $0x10,%edi
 108e8f7:	mov    0x68(%rsp),%rax
 108e8fc:	shl    $0x5,%rcx
 108e900:	cmpb   $0x0,(%rsi,%r14,1)
 108e905:	mov    $0x80,%esi
 108e90a:	vmovd  (%rdx,%r14,4),%xmm0
 108e910:	mov    0x28(%rax),%rax
 108e914:	mov    $0x1,%edx
 108e919:	cmove  %edi,%esi
 108e91c:	mov    0x130(%r12),%rdi
 108e924:	vpinsrd $0x1,%edx,%xmm0,%xmm0
 108e92a:	mov    $0x3,%edx
 108e92f:	vpinsrd $0x2,%esi,%xmm0,%xmm0
 108e935:	mov    (%rdi,%r14,4),%edi
 108e939:	vpinsrd $0x3,%edx,%xmm0,%xmm0
 108e93f:	vmovdqa %xmm0,(%rax,%rcx,1)
 108e944:	vpxor  %xmm0,%xmm0,%xmm0
 108e948:	vmovdqu %ymm0,0x10(%rax,%rcx,1)
 108e94e:	vmovdqu %ymm0,0x20(%rax,%rcx,1)
 108e954:	mov    %edi,0x40(%rax,%rcx,1)
 108e958:	jmp    108d302 <check_input_expressions+0x4092>
 108e95d:	mov    0x370(%rbx),%rax
 108e964:	mov    0x8(%rsp),%rcx
 108e969:	mov    0x70(%rsp),%rdx
 108e96e:	mov    (%rax,%rcx,4),%ecx
 108e971:	cmp    (%rdx),%ecx
 108e973:	jae    108e9f3 <check_input_expressions+0x5783>
 108e975:	mov    0x10(%rsp),%rax
 108e97a:	xor    %esi,%esi
 108e97c:	mov    %ebp,%edi
 108e97e:	sub    $0x1,%edi
 108e981:	setb   %sil
 108e985:	mov    0x10(%rax),%rdx
 108e989:	xor    %eax,%eax
 108e98b:	cmp    $0x2,%edi
 108e98e:	setb   %al
 108e991:	cmpb   $0x4b,(%rdx,%rcx,1)
 108e995:	sete   %cl
 108e998:	cmove  %esi,%eax
 108e99b:	jmp    108e9fe <check_input_expressions+0x578e>
 108e99d:	movl   $0xffffffff,0x4(%rsp)
 108e9a5:	jmp    108e151 <check_input_expressions+0x4ee1>
 108e9aa:	vpmovsxbq -0xbf0d33(%rip),%xmm3        # 49dc80 <cbuiltin_test_generated.edges+0x3e40>
 108e9b3:	mov    0x10(%rsp),%r9
 108e9b8:	mov    0x4(%rsp),%r8d
 108e9bd:	add    $0xffffffcb,%edi
 108e9c0:	mov    $0xffffffff,%r11d
 108e9c6:	mov    %rbx,%r12
 108e9c9:	vxorps %xmm2,%xmm2,%xmm2
 108e9cd:	cmp    $0x1c,%edi
 108e9d0:	ja     10892e0 <check_input_expressions+0x70>
 108e9d6:	mov    $0x1c73b79b,%eax
 108e9db:	bt     %edi,%eax
 108e9de:	jb     108e182 <check_input_expressions+0x4f12>
 108e9e4:	jmp    10892e0 <check_input_expressions+0x70>
 108e9e9:	mov    $0x25,%eax
 108e9ee:	jmp    108dfc4 <check_input_expressions+0x4d54>
 108e9f3:	lea    -0x1(%rbp),%eax
 108e9f6:	cmp    $0x2,%eax
 108e9f9:	setb   %al
 108e9fc:	xor    %ecx,%ecx
 108e9fe:	mov    0x2f8(%r13),%rdx
 108ea05:	mov    0x8(%rsp),%rsi
 108ea0a:	cmpl   $0xffffffff,(%rdx,%rsi,4)
 108ea0e:	setne  %dl
 108ea11:	and    %al,%dl
 108ea13:	mov    %edx,0x58(%rsp)
 108ea17:	test   %cl,%cl
 108ea19:	jne    108e151 <check_input_expressions+0x4ee1>
 108ea1f:	cmpb   $0x0,0x58(%rsp)
 108ea24:	je     108e151 <check_input_expressions+0x4ee1>
 108ea2a:	mov    0x2c0(%r13),%rax
 108ea31:	mov    0x8(%rsp),%rdx
 108ea36:	mov    0x4(%rsp),%esi
 108ea3a:	cmp    $0x2,%ebp
 108ea3d:	vpmovsxbq -0xbf0dc6(%rip),%xmm3        # 49dc80 <cbuiltin_test_generated.edges+0x3e40>
 108ea46:	mov    0x10(%rsp),%r9
 108ea4b:	mov    $0xffffffff,%r11d
 108ea51:	mov    %rbx,%r12
 108ea54:	vxorps %xmm2,%xmm2,%xmm2
 108ea58:	mov    %esi,(%rax,%rdx,4)
 108ea5b:	mov    $0xffffffff,%eax
 108ea60:	cmove  0x18(%rsp),%eax
 108ea65:	mov    (%rbx),%rcx
 108ea68:	mov    0x310(%rcx),%rcx
 108ea6f:	mov    %eax,(%rcx,%rdx,4)
 108ea72:	mov    0x68(%rsp),%rcx
 108ea77:	mov    0x40(%rcx),%rax
 108ea7b:	mov    %esi,%ecx
 108ea7d:	orb    $0x9,(%rax,%rcx,1)
 108ea81:	cmp    $0x2,%ebp
 108ea84:	jne    10892e0 <check_input_expressions+0x70>
 108ea8a:	mov    0x68(%rsp),%rax
 108ea8f:	mov    0x18(%rsp),%ecx
 108ea93:	mov    0x40(%rax),%rax
 108ea97:	orb    $0x9,(%rax,%rcx,1)
 108ea9b:	jmp    10892e0 <check_input_expressions+0x70>
 108eaa0:	mov    0x20(%rcx),%rax
 108eaa4:	mov    (%rax,%r8,4),%eax
 108eaa8:	mov    $0x1,%r8b
 108eaab:	jmp    108d933 <check_input_expressions+0x46c3>
 108eab0:	mov    0x370(%rbx),%rax
 108eab7:	mov    0x8(%rsp),%rcx
 108eabc:	mov    0x70(%rsp),%rdx
 108eac1:	mov    (%rax,%rcx,4),%eax
 108eac4:	cmp    (%rdx),%eax
 108eac6:	jae    108e3c2 <check_input_expressions+0x5152>
 108eacc:	mov    0x10(%rsp),%rcx
 108ead1:	mov    0x10(%rcx),%rcx
 108ead5:	cmpb   $0x43,(%rcx,%rax,1)
 108ead9:	sete   %al
 108eadc:	cmp    $0x1,%ebp
 108eadf:	sete   %cl
 108eae2:	and    %al,%cl
 108eae4:	cmp    $0x1,%cl
 108eae7:	jne    108e3c2 <check_input_expressions+0x5152>
 108eaed:	mov    0x68(%rsp),%rdx
 108eaf2:	mov    0x4(%rsp),%ecx
 108eaf6:	vpmovsxbq -0xbf0e7f(%rip),%xmm3        # 49dc80 <cbuiltin_test_generated.edges+0x3e40>
 108eaff:	mov    0x10(%rsp),%r9
 108eb04:	mov    %rbx,%r12
 108eb07:	vxorps %xmm2,%xmm2,%xmm2
 108eb0b:	mov    $0xffffffff,%r11d
 108eb11:	mov    0x40(%rdx),%rax
 108eb15:	orb    $0x3,(%rax,%rcx,1)
 108eb19:	mov    0x40(%rdx),%rax
 108eb1d:	orb    $0x8,(%rax,%rcx,1)
 108eb21:	jmp    10892e0 <check_input_expressions+0x70>
 108eb26:	mov    $0x2,%ebp
 108eb2b:	jmp    108e3c2 <check_input_expressions+0x5152>
 108eb30:	mov    %ecx,%r12d
 108eb33:	cmp    $0x1,%r14
 108eb37:	je     108da0e <check_input_expressions+0x479e>
 108eb3d:	xor    %r13d,%r13d
 108eb40:	jmp    108d975 <check_input_expressions+0x4705>
 108eb45:	mov    %fs:0x28,%rax
 108eb4e:	cmp    0x160(%rsp),%rax
 108eb56:	jne    108eb6d <check_input_expressions+0x58fd>
 108eb58:	add    $0x168,%rsp
 108eb5f:	pop    %rbx
 108eb60:	pop    %r12
 108eb62:	pop    %r13
 108eb64:	pop    %r14
 108eb66:	pop    %r15
 108eb68:	pop    %rbp
 108eb69:	vzeroupper
 108eb6c:	ret
 108eb6d:	vzeroupper
 108eb70:	call   787bf0 <__stack_chk_fail@plt>
 108eb75:	lea    -0x99686e(%rip),%rdi        # 6f830e <pp_string_value.meaning+0x6fb0d>
 108eb7c:	lea    -0x9dd5bc(%rip),%rsi        # 6b15c7 <pp_string_value.meaning+0x28dc6>
 108eb83:	lea    -0x9dd5a8(%rip),%rcx        # 6b15e2 <pp_string_value.meaning+0x28de1>
 108eb8a:	mov    $0xbd,%edx
 108eb8f:	vzeroupper
 108eb92:	call   787c60 <__assert_fail@plt>
