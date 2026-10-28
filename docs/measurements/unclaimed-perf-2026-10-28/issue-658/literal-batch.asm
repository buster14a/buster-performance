
build/compiler:     file format elf64-x86-64


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

00000000008880b0 <check_literal_table_batch>:
  8880b0:	push   %rbp
  8880b1:	push   %r15
  8880b3:	push   %r14
  8880b5:	push   %r13
  8880b7:	push   %r12
  8880b9:	push   %rbx
  8880ba:	sub    $0x458,%rsp
  8880c1:	mov    %r8d,(%rsp)
  8880c5:	vpxor  %xmm0,%xmm0,%xmm0
  8880c9:	mov    %ecx,%r8d
  8880cc:	mov    %rsi,%r12
  8880cf:	mov    %rdi,%rbx
  8880d2:	xor    %r14d,%r14d
  8880d5:	mov    %fs:0x28,%rax
  8880de:	mov    %rax,0x450(%rsp)
  8880e6:	vmovdqu64 %zmm0,0x200(%rsp)
  8880ee:	vmovdqu64 %zmm0,0x1c0(%rsp)
  8880f6:	mov    %r8,0x10(%rsp)
  8880fb:	mov    %r9,0x38(%rsp)
  888100:	mov    0x28(%rdi),%rax
  888104:	mov    0x8(%rax),%rax
  888108:	mov    %rax,0x40(%rsp)
  88810d:	test   %edx,%edx
  88810f:	je     888203 <check_literal_table_batch+0x153>
  888115:	lea    0x140(%rsp),%r13
  88811d:	mov    %edx,%r14d
  888120:	mov    %edx,%r15d
  888123:	xor    %ebp,%ebp
  888125:	jmp    888140 <check_literal_table_batch+0x90>
  888127:	nopw   0x0(%rax,%rax,1)
  888130:	inc    %rbp
  888133:	add    $0x8,%r13
  888137:	cmp    %r15,%rbp
  88813a:	jae    888942 <check_literal_table_batch+0x892>
  888140:	mov    0x8(%rbx),%rdx
  888144:	mov    0x10(%rbx),%rax
  888148:	mov    (%r12,%rbp,4),%ecx
  88814c:	mov    0x28(%rdx),%rdx
  888150:	mov    0x810(%rax),%rdi
  888157:	mov    (%rdx,%rcx,4),%ecx
  88815a:	mov    $0x18,%edx
  88815f:	movzbl (%rdi,%rcx,1),%esi
  888163:	cmp    $0xfd,%sil
  888167:	je     888183 <check_literal_table_batch+0xd3>
  888169:	mov    0x820(%rax),%rdx
  888170:	mov    0x828(%rax),%rdi
  888177:	mov    (%rdx,%rcx,4),%edx
  88817a:	mov    (%rdi,%rcx,4),%edi
  88817d:	sub    %rdi,%rdx
  888180:	inc    %rdx
  888183:	mov    0x28(%rbx),%rdi
  888187:	mov    0x8(%rdi),%r8
  88818b:	mov    0x10(%rdi),%r9
  88818f:	sub    %r8,%r9
  888192:	jb     8881f4 <check_literal_table_batch+0x144>
  888194:	cmp    %r9,%rdx
  888197:	ja     8881f4 <check_literal_table_batch+0x144>
  888199:	add    %r8,%rdx
  88819c:	add    (%rdi),%r8
  88819f:	mov    %rdx,0x8(%rdi)
  8881a3:	je     8881f4 <check_literal_table_batch+0x144>
  8881a5:	mov    0x820(%rax),%rdx
  8881ac:	mov    0x828(%rax),%rax
  8881b3:	mov    0x10(%rbx),%rdi
  8881b7:	movzbl %sil,%esi
  8881bb:	mov    %r13,%r9
  8881be:	mov    (%rdx,%rcx,4),%edx
  8881c1:	mov    (%rax,%rcx,4),%ecx
  8881c4:	vzeroupper
  8881c7:	call   12695d0 <pp_spelling>
  8881cc:	mov    %eax,0x1c0(%rsp,%rbp,4)
  8881d3:	cmp    $0x4,%eax
  8881d6:	ja     888130 <check_literal_table_batch+0x80>
  8881dc:	mov    0x0(%r13),%rsi
  8881e0:	lea    0x200(%rsp,%rbp,4),%rdi
  8881e8:	mov    %eax,%edx
  8881ea:	call   7e6c20 <memcpy@plt>
  8881ef:	jmp    888130 <check_literal_table_batch+0x80>
  8881f4:	mov    (%rbx),%rax
  8881f7:	movb   $0x1,0x3fd(%rax)
  8881fe:	jmp    888905 <check_literal_table_batch+0x855>
  888203:	xor    %eax,%eax
  888205:	mov    0x8(%rbx),%rcx
  888209:	cmpb   $0x0,(%rcx)
  88820c:	jne    8883b5 <check_literal_table_batch+0x305>
  888212:	vmovdqu64 0x1c0(%rsp),%zmm3
  88821a:	vpbroadcastd -0x2c39b4(%rip),%zmm7        # 5c4870 <check_test_initializer_nesting.timed+0x260>
  888224:	vmovdqu64 0x200(%rsp),%zmm2
  88822c:	vpbroadcastd -0x2c39ce(%rip),%zmm4        # 5c4868 <check_test_initializer_nesting.timed+0x258>
  888236:	vpternlogd $0xff,%zmm8,%zmm8,%zmm8
  88823d:	vpbroadcastd -0x2c39d3(%rip),%zmm13        # 5c4874 <check_test_initializer_nesting.timed+0x264>
  888247:	vpbroadcastd -0x2c39d1(%rip),%zmm12        # 5c4880 <check_test_initializer_nesting.timed+0x270>
  888251:	vpbroadcastd -0x2c39d3(%rip),%zmm10        # 5c4888 <check_test_initializer_nesting.timed+0x278>
  88825b:	vpandd -0x2c3a01(%rip){1to16},%zmm2,%zmm0        # 5c4864 <check_test_initializer_nesting.timed+0x254>
  888265:	vpshufb -0x3e432f(%rip),%zmm2,%zmm1        # 4a3f40 <cbuiltin_test_generated.edges+0x5370>
  88826f:	vpshufb -0x3e42f9(%rip),%zmm2,%zmm6        # 4a3f80 <cbuiltin_test_generated.edges+0x53b0>
  888279:	vpaddd %zmm8,%zmm3,%zmm8
  88827f:	vpsrld $0x18,%zmm2,%zmm11
  888286:	vpandd -0x2c3a00(%rip){1to16},%zmm2,%zmm2        # 5c4890 <check_test_initializer_nesting.timed+0x280>
  888290:	vpcmpneqd %zmm7,%zmm3,%k0
  888297:	vpcmpeqd %zmm7,%zmm3,%k3
  88829d:	vpcmpltud %zmm7,%zmm8,%k1
  8882a4:	vpandd -0x2c3a36(%rip){1to16},%zmm3,%zmm8        # 5c4878 <check_test_initializer_nesting.timed+0x268>
  8882ae:	vpaddd %zmm4,%zmm0,%zmm0
  8882b4:	vpaddd %zmm4,%zmm1,%zmm5
  8882ba:	vpaddd %zmm4,%zmm6,%zmm1
  8882c0:	vpord  %zmm12,%zmm6,%zmm6
  8882c6:	kmovd  %k0,%ecx
  8882ca:	vpaddd %zmm4,%zmm11,%zmm4
  8882d0:	vpcmpeqd -0x2c3a5e(%rip){1to16},%zmm8,%k4        # 5c487c <check_test_initializer_nesting.timed+0x26c>
  8882da:	vpmaddwd %zmm13,%zmm0,%zmm8
  8882e0:	vpcmpltud %zmm13,%zmm5,%k2
  8882e7:	vpcmpltud %zmm13,%zmm0,%k1{%k1}
  8882ee:	vpcmpltud %zmm13,%zmm1,%k0
  8882f5:	vptestmd %zmm0,%zmm0,%k2{%k2}
  8882fb:	kmovd  %k0,%esi
  8882ff:	or     %esi,%ecx
  888301:	vpaddd %zmm5,%zmm8,%zmm0{%k4}
  888307:	vpbroadcastd -0x2c3a8d(%rip),%zmm8        # 5c4884 <check_test_initializer_nesting.timed+0x274>
  888311:	vpcmpeqd -0x2c3aaf(%rip){1to16},%zmm3,%k4        # 5c486c <check_test_initializer_nesting.timed+0x25c>
  88831b:	vpmaddwd %zmm13,%zmm0,%zmm5
  888321:	vpaddd %zmm1,%zmm5,%zmm0{%k3}
  888327:	vpord  %zmm12,%zmm11,%zmm5
  88832d:	vpaddd %zmm8,%zmm6,%zmm9
  888333:	korw   %k2,%k4,%k2
  888337:	vpcmpeqd -0x2c3ab5(%rip){1to16},%zmm3,%k4        # 5c488c <check_test_initializer_nesting.timed+0x27c>
  888341:	vpaddd %zmm8,%zmm5,%zmm8
  888347:	kandw  %k2,%k1,%k1
  88834b:	vpcmpltud %zmm10,%zmm9,%k3
  888352:	vpcmpltud %zmm10,%zmm8,%k2
  888359:	kmovd  %k1,%edi
  88835d:	korw   %k3,%k0,%k1
  888361:	vpcmpeqd -0x2c3ad7(%rip){1to16},%zmm2,%k0{%k4}        # 5c4894 <check_test_initializer_nesting.timed+0x284>
  88836b:	vpaddd -0x2c3add(%rip){1to16},%zmm6,%zmm1{%k3}        # 5c4898 <check_test_initializer_nesting.timed+0x288>
  888375:	vpcmpltud %zmm13,%zmm4,%k4
  88837c:	vpaddd -0x2c3aea(%rip){1to16},%zmm5,%zmm4{%k2}        # 5c489c <check_test_initializer_nesting.timed+0x28c>
  888386:	korw   %k2,%k4,%k4
  88838a:	and    %edi,%ecx
  88838c:	kandw  %k1,%k4,%k1
  888390:	kandw  %k0,%k1,%k1
  888394:	vpslld $0x4,%zmm1,%zmm1
  88839b:	kmovd  %k1,%esi
  88839f:	vpord  %zmm4,%zmm1,%zmm0{%k1}
  8883a5:	or     %ecx,%esi
  8883a7:	vmovdqu64 %zmm0,0x100(%rsp)
  8883af:	and    %esi,%eax
  8883b1:	movzwl %ax,%r14d
  8883b5:	mov    %edx,0xc(%rsp)
  8883b9:	test   %edx,%edx
  8883bb:	je     8887d1 <check_literal_table_batch+0x721>
  8883c1:	mov    $0xffffffffffffffff,%r9
  8883c8:	lea    -0x1(%r8),%ecx
  8883cc:	cmp    $0x40,%r8d
  8883d0:	mov    $0x1,%esi
  8883d5:	mov    $0x0,%ebp
  8883da:	mov    %edx,%edx
  8883dc:	shlx   %r8,%r9,%rax
  8883e1:	shlx   %rcx,%r9,%r10
  8883e6:	mov    %rax,%rdi
  8883e9:	not    %rdi
  8883ec:	not    %r10
  8883ef:	cmove  %r9,%rdi
  8883f3:	xor    %r11d,%r11d
  8883f6:	shld   %cl,%rsi,%r11
  8883fa:	xor    %r13d,%r13d
  8883fd:	shlx   %rcx,%rsi,%rsi
  888402:	test   $0x40,%cl
  888405:	mov    $0xffffffffffffffff,%rcx
  88840c:	cmovne %rsi,%r11
  888410:	cmovne %r13,%rsi
  888414:	mov    %rsi,%r15
  888417:	neg    %r15
  88841a:	sbb    %r11,%rbp
  88841d:	test   $0x40,%r8b
  888421:	cmovne %rax,%rcx
  888425:	cmovne %r13,%rax
  888429:	cmp    $0x80,%r8d
  888430:	not    %rax
  888433:	not    %rcx
  888436:	cmove  %r9,%rcx
  88843a:	cmove  %r9,%rax
  88843e:	add    $0xffffffffffffffff,%rsi
  888442:	adc    $0xffffffffffffffff,%r11
  888446:	cmpb   $0x0,(%rsp)
  88844a:	mov    %rdx,(%rsp)
  88844e:	cmove  %r13,%rbp
  888452:	cmove  %r13,%r15
  888456:	cmove  %rdi,%r10
  88845a:	cmove  %rax,%rsi
  88845e:	cmove  %rcx,%r11
  888462:	mov    %rbp,0x18(%rsp)
  888467:	lea    -0x3d763e(%rip),%rbp        # 4b0e30 <type_integer_info>
  88846e:	mov    %r15,0x20(%rsp)
  888473:	mov    %r10,0x48(%rsp)
  888478:	mov    %rsi,0x28(%rsp)
  88847d:	mov    %r11,0x30(%rsp)
  888482:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  888490:	mov    0x8(%rbx),%rax
  888494:	mov    (%r12,%r13,4),%ecx
  888498:	mov    0x18(%rax),%rax
  88849c:	dec    %ecx
  88849e:	bt     %r13d,%r14d
  8884a2:	movzbl (%rax,%rcx,1),%eax
  8884a6:	jae    8884d0 <check_literal_table_batch+0x420>
  8884a8:	cmp    $0x16,%al
  8884aa:	je     8884d0 <check_literal_table_batch+0x420>
  8884ac:	mov    0x100(%rsp,%r13,4),%eax
  8884b4:	cmp    %rax,0x48(%rsp)
  8884b9:	mov    %rax,0x80(%rsp,%r13,8)
  8884c1:	setae  %al
  8884c4:	jmp    8887b0 <check_literal_table_batch+0x700>
  8884c9:	nopl   0x0(%rax)
  8884d0:	mov    0x140(%rsp,%r13,8),%rdi
  8884d8:	mov    0x1c0(%rsp,%r13,4),%esi
  8884e0:	lea    0x50(%rsp),%rdx
  8884e5:	cmp    $0x16,%al
  8884e7:	mov    %r12,%r15
  8884ea:	mov    %rbp,%r12
  8884ed:	mov    %r14d,%ebp
  8884f0:	vpxor  %xmm0,%xmm0,%xmm0
  8884f4:	vmovdqu %ymm0,0x60(%rsp)
  8884fa:	vmovdqu %ymm0,0x50(%rsp)
  888500:	setne  %r14b
  888504:	vzeroupper
  888507:	call   83bd30 <check_literal_integer>
  88850c:	movzbl 0x72(%rsp),%ecx
  888511:	mov    0x50(%rsp),%esi
  888515:	mov    0x58(%rsp),%rax
  88851a:	mov    %ecx,%edx
  88851c:	xor    $0x1,%dl
  88851f:	or     %r14b,%dl
  888522:	jne    888630 <check_literal_table_batch+0x580>
  888528:	vpmovsxbd -0x2c3c91(%rip),%xmm0        # 5c48a0 <check_test_initializer_nesting.timed+0x290>
  888531:	lea    0x2d4(%rsp),%rcx
  888539:	movl   $0x2,0x2d0(%rsp)
  888544:	lea    0x240(%rsp),%rdx
  88854c:	xor    %r8d,%r8d
  88854f:	movl   $0x0,0x8(%rcx)
  888556:	movq   $0x0,(%rcx)
  88855d:	vpinsrd $0x0,%esi,%xmm0,%xmm0
  888563:	lea    0x2d0(%rsp),%rsi
  88856b:	vmovdqa %xmm0,0x2e0(%rsp)
  888574:	mov    %rax,0x2f0(%rsp)
  88857c:	movq   $0x0,0x2f8(%rsp)
  888588:	fldz
  88858a:	fld    %st(0)
  88858c:	fstpt  0x300(%rsp)
  888593:	fstpt  0x310(%rsp)
  88859a:	vpxor  %xmm0,%xmm0,%xmm0
  88859e:	vmovdqu64 %zmm0,0x13c(%rcx)
  8885a8:	vmovdqu64 %zmm0,0x10c(%rcx)
  8885b2:	vmovdqu64 %zmm0,0xcc(%rcx)
  8885bc:	vmovdqu64 %zmm0,0x8c(%rcx)
  8885c6:	vmovdqu64 %zmm0,0x4c(%rcx)
  8885d0:	xor    %ecx,%ecx
  8885d2:	mov    0x18(%rbx),%rdi
  8885d6:	vzeroupper
  8885d9:	call   855940 <check_action_compute>
  8885de:	mov    0x2c8(%rsp),%eax
  8885e5:	mov    0x240(%rsp),%esi
  8885ec:	mov    0x258(%rsp),%rdx
  8885f4:	or     0x2c0(%rsp),%eax
  8885fb:	or     0x294(%rsp),%eax
  888602:	mov    0x250(%rsp),%rax
  88860a:	sete   %cl
  88860d:	mov    %ebp,%r14d
  888610:	test   %cl,%cl
  888612:	jne    888639 <check_literal_table_batch+0x589>
  888614:	mov    (%rsp),%rdx
  888618:	mov    %r12,%rbp
  88861b:	xor    %eax,%eax
  88861d:	mov    %r15,%r12
  888620:	jmp    8887b0 <check_literal_table_batch+0x700>
  888625:	data16 cs nopw 0x0(%rax,%rax,1)
  888630:	xor    %edx,%edx
  888632:	mov    %ebp,%r14d
  888635:	test   %cl,%cl
  888637:	je     888614 <check_literal_table_batch+0x564>
  888639:	mov    0x18(%rbx),%rcx
  88863d:	mov    %esi,%r8d
  888640:	shr    $0x3,%r8d
  888644:	mov    %r12,%rbp
  888647:	mov    (%rcx),%rdi
  88864a:	movzbl (%rdi,%r8,1),%r9d
  88864f:	cmp    $0xf,%r9b
  888653:	jne    888669 <check_literal_table_batch+0x5b9>
  888655:	mov    0x20(%rcx),%rsi
  888659:	mov    (%rsi,%r8,4),%esi
  88865d:	mov    %esi,%r8d
  888660:	shr    $0x3,%r8d
  888664:	movzbl (%rdi,%r8,1),%r9d
  888669:	mov    %r15,%r12
  88866c:	cmp    $0x12,%r9b
  888670:	jne    888685 <check_literal_table_batch+0x5d5>
  888672:	mov    0x10(%rcx),%r9
  888676:	testb  $0x4,(%r9,%r8,1)
  88867b:	je     888685 <check_literal_table_batch+0x5d5>
  88867d:	mov    0x20(%rcx),%rsi
  888681:	mov    (%rsi,%r8,4),%esi
  888685:	shr    $0x3,%esi
  888688:	movzbl (%rdi,%rsi,1),%edi
  88868c:	cmp    $0x2,%edi
  88868f:	je     888727 <check_literal_table_batch+0x677>
  888695:	cmp    $0x5,%edi
  888698:	jne    8887a9 <check_literal_table_batch+0x6f9>
  88869e:	mov    0x10(%rcx),%rdi
  8886a2:	mov    0x30(%rcx),%rcx
  8886a6:	testb  $0x1,(%rdi,%rsi,1)
  8886aa:	mov    (%rcx,%rsi,8),%rcx
  8886ae:	sete   %r9b
  8886b2:	lea    -0x1(%rcx),%rsi
  8886b6:	cmp    $0x3f,%rsi
  8886ba:	ja     8887a9 <check_literal_table_batch+0x6f9>
  8886c0:	mov    $0xffffffffffffffff,%r10
  8886c7:	mov    $0xffffffffffffffff,%rsi
  8886ce:	shld   %cl,%r10,%r10
  8886d2:	shlx   %rcx,%rsi,%rdi
  8886d7:	test   $0x40,%cl
  8886da:	mov    $0x0,%esi
  8886df:	cmove  %rdi,%rsi
  8886e3:	cmovne %rdi,%r10
  8886e7:	andn   %rax,%rsi,%rdi
  8886ec:	andn   %rdx,%r10,%r8
  8886f1:	test   %r9b,%r9b
  8886f4:	je     888752 <check_literal_table_batch+0x6a2>
  8886f6:	dec    %cl
  8886f8:	mov    %rdi,%r9
  8886fb:	shrd   %cl,%r8,%r9
  8886ff:	shrx   %rcx,%r8,%r11
  888704:	test   $0x40,%cl
  888707:	mov    $0x0,%ecx
  88870c:	cmove  %r11,%rcx
  888710:	cmovne %r11,%r9
  888714:	or     %rax,%rsi
  888717:	or     %rdx,%r10
  88871a:	or     %r9,%rcx
  88871d:	cmovne %r10,%r8
  888721:	cmove  %rdi,%rsi
  888725:	jmp    888755 <check_literal_table_batch+0x6a5>
  888727:	lea    (%rsi,%rsi,2),%rdi
  88872b:	cmp    $0x3,%rsi
  88872f:	jne    88878c <check_literal_table_batch+0x6dc>
  888731:	movzbl 0x118(%rcx),%r9d
  888739:	xor    $0x1,%r9b
  88873d:	movzbl 0x2(%rbp,%rdi,2),%ecx
  888742:	lea    -0x1(%rcx),%rsi
  888746:	cmp    $0x3f,%rsi
  88874a:	jbe    8886c0 <check_literal_table_batch+0x610>
  888750:	jmp    8887a9 <check_literal_table_batch+0x6f9>
  888752:	mov    %rdi,%rsi
  888755:	cmp    0x20(%rsp),%rsi
  88875a:	mov    %r8,%rax
  88875d:	mov    (%rsp),%rdx
  888761:	sbb    0x18(%rsp),%rax
  888766:	mov    0x30(%rsp),%rax
  88876b:	setge  %cl
  88876e:	cmp    %rsi,0x28(%rsp)
  888773:	sbb    %r8,%rax
  888776:	setge  %al
  888779:	and    %cl,%al
  88877b:	test   %r8,%r8
  88877e:	cmovs  %rsi,%rdi
  888782:	mov    %rdi,0x80(%rsp,%r13,8)
  88878a:	jmp    8887b0 <check_literal_table_batch+0x700>
  88878c:	lea    0x0(%rbp,%rdi,2),%rcx
  888791:	movzbl 0x3(%rcx),%r9d
  888796:	movzbl 0x2(%rbp,%rdi,2),%ecx
  88879b:	lea    -0x1(%rcx),%rsi
  88879f:	cmp    $0x3f,%rsi
  8887a3:	jbe    8886c0 <check_literal_table_batch+0x610>
  8887a9:	mov    (%rsp),%rdx
  8887ad:	xor    %eax,%eax
  8887af:	nop
  8887b0:	test   %al,%al
  8887b2:	je     8887c0 <check_literal_table_batch+0x710>
  8887b4:	inc    %r13
  8887b7:	cmp    %rdx,%r13
  8887ba:	jb     888490 <check_literal_table_batch+0x3e0>
  8887c0:	mov    0x10(%rsp),%r8
  8887c5:	mov    0xc(%rsp),%edx
  8887c9:	test   %al,%al
  8887cb:	je     888905 <check_literal_table_batch+0x855>
  8887d1:	mov    0x8(%rbx),%rax
  8887d5:	mov    0x38(%rsp),%rbp
  8887da:	test   %edx,%edx
  8887dc:	mov    %r8d,%r12d
  8887df:	sete   %cl
  8887e2:	shr    $0x3,%r12d
  8887e6:	movzbl (%rax),%eax
  8887e9:	mov    %eax,%edx
  8887eb:	xor    $0x1,%dl
  8887ee:	or     %cl,%dl
  8887f0:	jne    88882a <check_literal_table_batch+0x77a>
  8887f2:	mov    0xc(%rsp),%r14d
  8887f7:	mov    $0x1,%r15d
  8887fd:	mov    %rbp,%r13
  888800:	lea    0x78(%rsp,%r15,8),%rsi
  888805:	mov    %r13,%rdi
  888808:	mov    %r12,%rdx
  88880b:	vzeroupper
  88880e:	call   7e6c20 <memcpy@plt>
  888813:	mov    0x8(%rbx),%rax
  888817:	movzbl (%rax),%eax
  88881a:	cmp    $0x1,%al
  88881c:	jne    88882a <check_literal_table_batch+0x77a>
  88881e:	add    %r12,%r13
  888821:	cmp    %r14,%r15
  888824:	lea    0x1(%r15),%r15
  888828:	jb     888800 <check_literal_table_batch+0x750>
  88882a:	mov    0xc(%rsp),%r10d
  88882f:	test   %r10d,%r10d
  888832:	sete   %cl
  888835:	or     %al,%cl
  888837:	mov    $0x1,%al
  888839:	jne    888907 <check_literal_table_batch+0x857>
  88883f:	mov    0x10(%rsp),%r9
  888844:	mov    $0xffffffff,%edx
  888849:	xor    %ecx,%ecx
  88884b:	mov    %r10d,%esi
  88884e:	jmp    888877 <check_literal_table_batch+0x7c7>
  888850:	kmovd  %r8d,%k1
  888855:	vpmovqw %zmm0,(%rdi){%k1}
  88885b:	mov    0x8(%rbx),%rdi
  88885f:	cmpb   $0x0,(%rdi)
  888862:	jne    888907 <check_literal_table_batch+0x857>
  888868:	add    $0x8,%ecx
  88886b:	add    $0xfffffff8,%esi
  88886e:	cmp    %r10d,%ecx
  888871:	jae    888907 <check_literal_table_batch+0x857>
  888877:	cmp    $0x8,%esi
  88887a:	mov    $0x8,%edi
  88887f:	cmovb  %esi,%edi
  888882:	shlx   %edi,%edx,%r8d
  888887:	mov    %ecx,%edi
  888889:	not    %r8b
  88888c:	kmovd  %r8d,%k1
  888891:	vmovdqu64 0x80(%rsp,%rdi,8),%zmm0{%k1}{z}
  888899:	imul   %r12,%rdi
  88889d:	add    %rbp,%rdi
  8888a0:	cmp    $0x8,%r9d
  8888a4:	je     8888d0 <check_literal_table_batch+0x820>
  8888a6:	cmp    $0x10,%r9d
  8888aa:	je     888850 <check_literal_table_batch+0x7a0>
  8888ac:	cmp    $0x20,%r9d
  8888b0:	jne    8888f0 <check_literal_table_batch+0x840>
  8888b2:	kmovd  %r8d,%k1
  8888b7:	vpmovqd %zmm0,(%rdi){%k1}
  8888bd:	mov    0x8(%rbx),%rdi
  8888c1:	cmpb   $0x0,(%rdi)
  8888c4:	je     888868 <check_literal_table_batch+0x7b8>
  8888c6:	jmp    888907 <check_literal_table_batch+0x857>
  8888c8:	nopl   0x0(%rax,%rax,1)
  8888d0:	kmovd  %r8d,%k1
  8888d5:	vpmovqb %zmm0,(%rdi){%k1}
  8888db:	mov    0x8(%rbx),%rdi
  8888df:	cmpb   $0x0,(%rdi)
  8888e2:	je     888868 <check_literal_table_batch+0x7b8>
  8888e4:	jmp    888907 <check_literal_table_batch+0x857>
  8888e6:	cs nopw 0x0(%rax,%rax,1)
  8888f0:	vmovdqu64 %zmm0,(%rdi){%k1}
  8888f6:	mov    0x8(%rbx),%rdi
  8888fa:	cmpb   $0x0,(%rdi)
  8888fd:	je     888868 <check_literal_table_batch+0x7b8>
  888903:	jmp    888907 <check_literal_table_batch+0x857>
  888905:	xor    %eax,%eax
  888907:	mov    0x28(%rbx),%rcx
  88890b:	mov    0x40(%rsp),%rdx
  888910:	cmp    0x8(%rcx),%rdx
  888914:	ja     88896b <check_literal_table_batch+0x8bb>
  888916:	mov    %rdx,0x8(%rcx)
  88891a:	mov    %fs:0x28,%rcx
  888923:	cmp    0x450(%rsp),%rcx
  88892b:	jne    88898d <check_literal_table_batch+0x8dd>
  88892d:	add    $0x458,%rsp
  888934:	pop    %rbx
  888935:	pop    %r12
  888937:	pop    %r13
  888939:	pop    %r14
  88893b:	pop    %r15
  88893d:	pop    %rbp
  88893e:	vzeroupper
  888941:	ret
  888942:	mov    0x10(%rsp),%r8
  888947:	mov    $0xffffffff,%eax
  88894c:	mov    %r14d,%edx
  88894f:	shlx   %r14d,%eax,%eax
  888954:	xor    %r14d,%r14d
  888957:	not    %eax
  888959:	mov    0x8(%rbx),%rcx
  88895d:	cmpb   $0x0,(%rcx)
  888960:	je     888212 <check_literal_table_batch+0x162>
  888966:	jmp    8883b5 <check_literal_table_batch+0x305>
  88896b:	lea    -0x143887(%rip),%rdi        # 7450eb <pp_string_value.meaning+0x82834>
  888972:	lea    -0x196163(%rip),%rsi        # 6f2816 <pp_string_value.meaning+0x2ff5f>
  888979:	lea    -0x19614f(%rip),%rcx        # 6f2831 <pp_string_value.meaning+0x2ff7a>
  888980:	mov    $0xce,%edx
  888985:	vzeroupper
  888988:	call   7e6290 <__assert_fail@plt>
  88898d:	vzeroupper
  888990:	call   7e6210 <__stack_chk_fail@plt>
