
compiler:     file format elf64-x86-64


Disassembly of section .text.buster_start:

Disassembly of section .text.buster_checker:

Disassembly of section .text:

0000000001f93e40 <node_contexts_window_loop>:
 1f93e40:	add    $0x3f,%edx
 1f93e43:	cmp    $0x40,%edx
 1f93e46:	jae    1f93e61 <node_contexts_window_loop+0x21>
 1f93e48:	vpxor  %xmm3,%xmm3,%xmm3
 1f93e4c:	xor    %esi,%esi
 1f93e4e:	xor    %edx,%edx
 1f93e50:	xor    %eax,%eax
 1f93e52:	xor    %r8d,%r8d
 1f93e55:	xor    %r10d,%r10d
 1f93e58:	vpxor  %xmm0,%xmm0,%xmm0
 1f93e5c:	jmp    1f95be6 <node_contexts_window_loop+0x1da6>
 1f93e61:	push   %rbp
 1f93e62:	mov    %rsp,%rbp
 1f93e65:	push   %r15
 1f93e67:	push   %r14
 1f93e69:	push   %r13
 1f93e6b:	push   %r12
 1f93e6d:	push   %rbx
 1f93e6e:	and    $0xffffffffffffffc0,%rsp
 1f93e72:	sub    $0xa00,%rsp
 1f93e79:	mov    (%rdi),%rax
 1f93e7c:	vbroadcasti32x4 -0x19cbf26(%rip),%zmm8        # 5c7f60 <.LCPI44_39>
 1f93e86:	mov    0xb40(%rdi),%r15
 1f93e8d:	shr    $0x6,%edx
 1f93e90:	mov    $0xffffffff,%ebx
 1f93e95:	vpxor  %xmm0,%xmm0,%xmm0
 1f93e99:	mov    %rcx,0x118(%rsp)
 1f93ea1:	vpxor  %xmm3,%xmm3,%xmm3
 1f93ea5:	vpxor  %xmm13,%xmm13,%xmm13
 1f93eaa:	xor    %r9d,%r9d
 1f93ead:	xor    %r10d,%r10d
 1f93eb0:	xor    %r8d,%r8d
 1f93eb3:	movq   $0x0,0x58(%rsp)
 1f93ebc:	xor    %r12d,%r12d
 1f93ebf:	movq   $0x0,0xc8(%rsp)
 1f93ecb:	movq   $0x0,0xe8(%rsp)
 1f93ed7:	vmovdqa64 %zmm0,0x6c0(%rsp)
 1f93edf:	vpxor  %xmm12,%xmm12,%xmm12
 1f93ee4:	mov    %rdi,0x40(%rsp)
 1f93ee9:	mov    %rsi,0x68(%rsp)
 1f93eee:	mov    0x8(%rax),%rax
 1f93ef2:	mov    %r15,0xf8(%rsp)
 1f93efa:	movzbl 0x14a(%rax),%eax
 1f93f01:	mov    %al,0x1f(%rsp)
 1f93f05:	xor    %eax,%eax
 1f93f07:	jmp    1f94011 <node_contexts_window_loop+0x1d1>
 1f93f0c:	nopl   0x0(%rax)
 1f93f10:	andn   0x90(%rsp),%rax,%rax
 1f93f1a:	vmovdqa64 0x180(%rsp),%zmm4
 1f93f22:	mov    0x158(%rsp),%rcx
 1f93f2a:	or     0x80(%rsp),%r12
 1f93f32:	vpunpcklqdq %xmm1,%xmm0,%xmm0
 1f93f36:	vpunpcklqdq %xmm2,%xmm3,%xmm1
 1f93f3a:	vmovdqa64 0x780(%rsp),%zmm3
 1f93f42:	vmovdqa64 0x700(%rsp),%zmm13
 1f93f4a:	vmovdqa64 0x680(%rsp),%zmm12
 1f93f52:	mov    0x168(%rsp),%r10
 1f93f5a:	mov    0xf8(%rsp),%r15
 1f93f62:	add    0x10(%rsp),%r10
 1f93f67:	vinserti128 $0x1,%xmm0,%ymm1,%ymm0
 1f93f6d:	vpopcntq %ymm0,%ymm0
 1f93f73:	and    %rdi,%rax
 1f93f76:	mov    0x40(%rsp),%rdi
 1f93f7b:	mov    %ecx,%r8d
 1f93f7e:	shl    $0x6,%r8
 1f93f82:	vptestnmb %zmm4,%zmm4,%k1
 1f93f88:	vpxor  %xmm4,%xmm4,%xmm4
 1f93f8c:	vpaddq %ymm3,%ymm0,%ymm3
 1f93f90:	kmovq  %k1,%r9
 1f93f95:	kmovq  0x108(%rsp),%k1
 1f93f9f:	mov    0xbe8(%rdi),%rdx
 1f93fa6:	and    %rax,%r9
 1f93fa9:	kandq  %k1,%k0,%k0
 1f93fae:	vpcmpgtb %zmm9,%zmm4,%k1{%k1}
 1f93fb4:	mov    %rax,(%rdx,%r8,1)
 1f93fb8:	mov    %r9,0x8(%rdx,%r8,1)
 1f93fbd:	mov    0x88(%rsp),%r9
 1f93fc5:	mov    %r12,0x10(%rdx,%r8,1)
 1f93fca:	mov    0x170(%rsp),%rax
 1f93fd2:	kmovq  %k0,0x18(%rdx,%r8,1)
 1f93fd9:	kmovq  %k1,0x20(%rdx,%r8,1)
 1f93fe0:	mov    0x160(%rsp),%r8
 1f93fe8:	mov    0x178(%rsp),%rdx
 1f93ff0:	mov    0xd8(%rsp),%r12
 1f93ff8:	add    0x8(%rsp),%rax
 1f93ffd:	add    0x20(%rsp),%r8
 1f94002:	and    $0x1,%r9d
 1f94006:	dec    %rdx
 1f94009:	test   %ecx,%ecx
 1f9400b:	je     1f95bb1 <node_contexts_window_loop+0x1d71>
 1f94011:	mov    %r9,0x88(%rsp)
 1f94019:	lea    -0x1(%rdx),%r9d
 1f9401d:	mov    %r10,0x168(%rsp)
 1f94025:	mov    %r8,0x160(%rsp)
 1f9402d:	vpbroadcastq -0x19c5abf(%rip),%zmm1        # 5ce578 <.LCPI44_0>
 1f94037:	mov    0xba8(%rdi),%r14
 1f9403e:	vmovdqa64 %zmm3,0x780(%rsp)
 1f94046:	vmovdqa64 -0x1add1d0(%rip),%zmm5        # 4b6e80 <abi_test_hex.digits+0xbb00>
 1f94050:	vmovdqu64 (%r15),%zmm4
 1f94056:	vmovdqa64 0x6c0(%rsp),%zmm0
 1f9405e:	mov    %ebx,0xe4(%rsp)
 1f94065:	vmovdqa64 -0x1add16f(%rip),%zmm6        # 4b6f00 <abi_test_hex.digits+0xbb80>
 1f9406f:	mov    %rax,0x170(%rsp)
 1f94077:	mov    %rdx,0x178(%rsp)
 1f9407f:	mov    0xb88(%rdi),%rax
 1f94086:	mov    0xb90(%rdi),%rcx
 1f9408d:	mov    0xb98(%rdi),%rdx
 1f94094:	mov    %r12,0xd8(%rsp)
 1f9409c:	mov    %r9,%r10
 1f9409f:	shl    $0x6,%r10
 1f940a3:	test   %r9d,%r9d
 1f940a6:	mov    %r9,0x158(%rsp)
 1f940ae:	lea    -0x40(%r10),%r8d
 1f940b2:	vpandq 0x2c(%rsi,%r10,1),%zmm1,%zmm7
 1f940bd:	mov    %r10,0x10(%rsp)
 1f940c2:	cmove  %r9d,%r8d
 1f940c6:	shl    $0x7,%r9
 1f940ca:	vmovdqu64 0x6f654(%rsi,%r9,1),%zmm1
 1f940d5:	vmovdqu64 0x6f694(%rsi,%r9,1),%zmm2
 1f940e0:	vmovdqu64 0x6b594(%rsi,%r9,1),%zmm3
 1f940eb:	vmovdqu64 (%r14,%r10,1),%zmm11
 1f940f2:	vmovdqu64 (%rdx,%r10,1),%zmm10
 1f940f9:	vmovdqu64 (%rcx,%r8,1),%zmm23
 1f94100:	vmovdqu64 (%rax,%r10,1),%zmm15
 1f94107:	vmovdqu64 (%rcx,%r10,1),%zmm16
 1f9410e:	vmovdqu64 (%r14,%r8,1),%zmm18
 1f94115:	vpermt2b 0x40(%r15),%zmm7,%zmm4
 1f9411c:	vmovdqa64 %zmm7,0x700(%rsp)
 1f94124:	vpmovuswb %zmm1,%ymm1
 1f9412a:	vpmovuswb %zmm2,%ymm2
 1f94130:	vpmovuswb %zmm3,%ymm3
 1f94136:	vmovdqa64 %zmm23,%zmm20
 1f9413c:	vmovdqa64 %zmm10,0x740(%rsp)
 1f94144:	vinserti64x4 $0x1,%ymm2,%zmm1,%zmm1
 1f9414b:	vmovdqu64 0x196ac(%rsi,%r10,1),%zmm2
 1f94156:	vpaddb -0x1add2a0(%rip),%zmm1,%zmm14        # 4b6ec0 <abi_test_hex.digits+0xbb40>
 1f94160:	vmovdqa64 %zmm4,%zmm22
 1f94166:	vmovdqa64 %zmm4,0x6c0(%rsp)
 1f9416e:	vptestmb %zmm2,%zmm2,%k0
 1f94174:	vpandd -0x19c31ce(%rip){1to16},%zmm11,%zmm2        # 5d0fb0 <.LCPI44_40>
 1f9417e:	kmovq  %k0,%r11
 1f94183:	vptestmb %zmm2,%zmm2,%k4
 1f94189:	vmovdqu64 0x6b554(%rsi,%r9,1),%zmm2
 1f94194:	kandq  %k4,%k0,%k2
 1f94199:	vpcmpleub %zmm5,%zmm1,%k0
 1f941a0:	kmovq  %k4,0x108(%rsp)
 1f941aa:	kmovq  %k0,%rbx
 1f941af:	and    %r11,%rbx
 1f941b2:	kmovq  %rbx,%k1
 1f941b7:	mov    %rbx,0x80(%rsp)
 1f941bf:	vpermt2b %zmm0,%zmm14,%zmm22{%k1}{z}
 1f941c5:	vmovdqu64 0x6d5d4(%rsi,%r9,1),%zmm0
 1f941d0:	kmovq  %k1,0x150(%rsp)
 1f941da:	vpmovuswb %zmm2,%ymm2
 1f941e0:	vinserti64x4 $0x1,%ymm3,%zmm2,%zmm3
 1f941e7:	vmovdqu64 0x6d614(%rsi,%r9,1),%zmm2
 1f941f2:	vpmovuswb %zmm0,%ymm0
 1f941f8:	kmovq  %k4,%r9
 1f941fd:	vptestmb %zmm3,%zmm3,%k0
 1f94203:	vpsubb %zmm3,%zmm6,%zmm21
 1f94209:	mov    %r9,0x90(%rsp)
 1f94211:	kandq  %k0,%k4,%k3
 1f94216:	kmovq  %k0,%r13
 1f9421b:	vpcmpnltub %zmm3,%zmm6,%k0
 1f94222:	vpcmpnleub %zmm5,%zmm1,%k4{%k2}
 1f94229:	vbroadcasti32x4 -0x19cc2c3(%rip),%zmm5        # 5c7f70 <.LCPI44_41>
 1f94233:	kmovq  %k0,%r11
 1f94238:	vpandq 0x2c(%rsi,%r8,1),%zmm5,%zmm19
 1f94243:	vpcmpltub %zmm3,%zmm6,%k2{%k3}
 1f9424a:	kmovq  %k4,0xf0(%rsp)
 1f94254:	and    %r13,%r11
 1f94257:	mov    0xba0(%rdi),%r13
 1f9425e:	kortestq %k4,%k2
 1f94263:	kmovq  %r11,%k3
 1f94268:	mov    %r11,0x20(%rsp)
 1f9426d:	vpermt2b %zmm16,%zmm21,%zmm20{%k3}{z}
 1f94273:	vpermt2b %zmm11,%zmm21,%zmm18{%k3}{z}
 1f94279:	vpmovuswb %zmm2,%ymm2
 1f9427f:	vmovdqu64 0x0(%r13,%r10,1),%zmm9
 1f94287:	vmovdqu64 0x0(%r13,%r8,1),%zmm1
 1f9428f:	vpermt2b %zmm7,%zmm21,%zmm19{%k3}{z}
 1f94295:	vinserti64x4 $0x1,%ymm2,%zmm0,%zmm0
 1f9429c:	vpcmpltub -0x1add367(%rip),%zmm0,%k1        # 4b6f40 <abi_test_hex.digits+0xbbc0>
 1f942a7:	vmovdqu64 (%rdx,%r8,1),%zmm2
 1f942ae:	vpsubb %zmm0,%zmm6,%zmm4
 1f942b4:	vptestmb %zmm0,%zmm0,%k5{%k1}
 1f942ba:	vmovdqu64 (%rax,%r8,1),%zmm0
 1f942c1:	vmovdqa64 %zmm2,%zmm3
 1f942c7:	vpermt2b %zmm10,%zmm21,%zmm3{%k3}{z}
 1f942cd:	vpermt2b %zmm10,%zmm4,%zmm2
 1f942d3:	kmovq  %k4,%r8
 1f942d8:	mov    %r8,0x30(%rsp)
 1f942dd:	vpermt2b %zmm16,%zmm4,%zmm23{%k5}{z}
 1f942e3:	vmovdqa64 %zmm0,%zmm25
 1f942e9:	vpermt2b %zmm15,%zmm21,%zmm25{%k3}{z}
 1f942ef:	vpermi2b %zmm9,%zmm1,%zmm21{%k3}{z}
 1f942f5:	vpermt2b %zmm15,%zmm4,%zmm0
 1f942fb:	vpermt2b %zmm9,%zmm4,%zmm1
 1f94301:	jne    1f95a34 <node_contexts_window_loop+0x1bf4>
 1f94307:	mov    0x10(%rsp),%r14
 1f9430c:	vbroadcasti32x4 -0x19cc396(%rip),%zmm5        # 5c7f80 <.LCPI44_42>
 1f94316:	vbroadcasti32x4 -0x19cc390(%rip),%zmm6        # 5c7f90 <.LCPI44_43>
 1f94320:	vpxor  %xmm4,%xmm4,%xmm4
 1f94324:	vbroadcasti32x4 -0x19cc38e(%rip),%zmm7        # 5c7fa0 <.LCPI44_44>
 1f9432e:	vmovdqa64 0x6c0(%rsp),%zmm26
 1f94336:	vmovdqa64 %zmm9,0x640(%rsp)
 1f9433e:	vmovdqa64 %zmm11,0x600(%rsp)
 1f94346:	vpandq -0x19c5dd0(%rip){1to8},%zmm26,%zmm10        # 5ce580 <.LCPI44_20>
 1f94350:	vmovdqu64 0x1a72c(%rsi,%r14,1),%zmm17
 1f9435b:	vpandq %zmm5,%zmm3,%zmm3
 1f94361:	vpandq %zmm5,%zmm2,%zmm2
 1f94367:	vbroadcasti32x4 -0x19cc3c1(%rip),%zmm5        # 5c7fb0 <.LCPI44_45>
 1f94371:	vpcmpeqb %zmm6,%zmm3,%k0
 1f94377:	vbroadcasti32x4 -0x19cc3c1(%rip),%zmm3        # 5c7fc0 <.LCPI44_46>
 1f94381:	vmovdqa64 %zmm10,0x5c0(%rsp)
 1f94389:	kmovq  %k0,%rax
 1f9438e:	vpcmpeqb %zmm6,%zmm2,%k0{%k5}
 1f94394:	vpandd -0x19c33ea(%rip){1to16},%zmm9,%zmm2        # 5d0fb4 <.LCPI44_47>
 1f9439e:	and    0x20(%rsp),%rax
 1f943a3:	vpcmpeqb -0x1add3ad(%rip),%zmm2,%k3        # 4b7000 <abi_test_hex.digits+0xbc80>
 1f943ad:	vptestnmb %zmm17,%zmm17,%k2
 1f943b3:	vpcmpgtb %zmm22,%zmm4,%k4{%k2}
 1f943b9:	kmovq  %k2,0x50(%rsp)
 1f943c0:	vptestmb %zmm6,%zmm20,%k2
 1f943c6:	kmovq  %k2,%rdx
 1f943cb:	vptestmb %zmm6,%zmm23,%k2
 1f943d1:	kmovq  %k4,%r13
 1f943d6:	kmovq  %k4,0x130(%rsp)
 1f943e0:	korq   %k0,%k2,%k1
 1f943e5:	vptestmb -0x1add1ef(%rip),%zmm16,%k0        # 4b7200 <abi_test_hex.digits+0xbe80>
 1f943ef:	or     %rax,%rdx
 1f943f2:	mov    %r13,0x120(%rsp)
 1f943fa:	vpandq %zmm3,%zmm9,%zmm24
 1f94400:	vpcmpeqb -0x1add14a(%rip),%zmm24,%k7        # 4b72c0 <abi_test_hex.digits+0xbf40>
 1f9440a:	vpandq %zmm3,%zmm1,%zmm1
 1f94410:	vpternlogd $0xff,%zmm3,%zmm3,%zmm3
 1f94417:	mov    %rdx,0x680(%rsp)
 1f9441f:	vptestnmb %zmm2,%zmm2,%k2
 1f94425:	vbroadcasti32x4 -0x19cc45f(%rip),%zmm2        # 5c7fd0 <.LCPI44_48>
 1f9442f:	vpaddb %zmm3,%zmm15,%zmm27
 1f94435:	vpaddb %zmm3,%zmm0,%zmm0
 1f9443b:	kmovq  %k3,0x580(%rsp)
 1f94445:	kmovq  %k0,%rcx
 1f9444a:	vptestmb %zmm7,%zmm16,%k0
 1f94450:	korq   %k4,%k0,%k6
 1f94455:	mov    %rcx,0x540(%rsp)
 1f9445d:	kmovq  %k2,%rcx
 1f94462:	vptestmb %zmm24,%zmm24,%k2
 1f94468:	kandq  %k7,%k6,%k0
 1f9446d:	kmovq  %k2,%rsi
 1f94472:	vpcmpltub %zmm6,%zmm27,%k2
 1f94479:	mov    %rcx,0x28(%rsp)
 1f9447e:	kmovq  %k6,0x78(%rsp)
 1f94485:	kmovq  %k0,%rdi
 1f9448a:	vptestmb %zmm2,%zmm16,%k0{%k3}
 1f94490:	kmovq  %k2,0xa0(%rsp)
 1f9449a:	vptestmb %zmm2,%zmm26,%k2{%k2}
 1f944a0:	vpcmpltub %zmm5,%zmm27,%k3
 1f944a7:	vpandq %zmm2,%zmm20,%zmm2
 1f944ad:	andn   0x28(%rsp),%r13,%rax
 1f944b4:	kmovq  %k3,0xb8(%rsp)
 1f944be:	kmovq  %k0,%r8
 1f944c3:	vpcmpeqb %zmm7,%zmm1,%k0{%k5}
 1f944c9:	kmovq  %k2,0x140(%rsp)
 1f944d3:	vpcmpltub %zmm5,%zmm0,%k5{%k5}
 1f944da:	vbroadcasti32x4 -0x19cc504(%rip),%zmm0        # 5c7fe0 <.LCPI44_49>
 1f944e4:	or     %rax,%rdi
 1f944e7:	vpandq %zmm8,%zmm11,%zmm5
 1f944ed:	kmovq  %k0,0x148(%rsp)
 1f944f7:	kandq  %k0,%k2,%k0
 1f944fc:	vptestnmb %zmm19,%zmm19,%k2
 1f94502:	andn   %r8,%r13,%r8
 1f94507:	mov    0x40(%rsp),%r13
 1f9450c:	and    %rsi,%rdi
 1f9450f:	or     0x540(%rsp),%r8
 1f94517:	kmovq  %k3,%rsi
 1f9451c:	knotq  %k0,%k0
 1f94521:	kmovq  %k2,0x100(%rsp)
 1f9452b:	vpcmpgtb %zmm18,%zmm4,%k2{%k2}
 1f94531:	kmovq  %k0,%r9
 1f94536:	vpcmpeqb -0x1add300(%rip),%zmm10,%k0{%k3}        # 4b7240 <abi_test_hex.digits+0xbec0>
 1f94540:	mov    0xbd0(%r13),%rax
 1f94547:	mov    %r8,0xc0(%rsp)
 1f9454f:	kmovq  %k0,%r15
 1f94554:	vptestmb %zmm2,%zmm2,%k0
 1f9455a:	vmovdqu64 %zmm10,(%rax,%r14,1)
 1f94561:	korq   %k2,%k0,%k0
 1f94566:	vpcmpeqb %zmm7,%zmm10,%k2
 1f9456c:	and    %r9,%r15
 1f9456f:	kmovq  %k6,%r9
 1f94574:	knotq  %k0,%k0
 1f94579:	kmovq  %k2,0x8(%rsp)
 1f94580:	mov    %r9,0xa8(%rsp)
 1f94588:	kmovq  %k0,%r10
 1f9458d:	vptestmb -0x1adcf97(%rip),%zmm26,%k0        # 4b7600 <abi_test_hex.digits+0xc280>
 1f94597:	kmovq  %k0,0xb0(%rsp)
 1f945a1:	korq   %k5,%k0,%k0
 1f945a6:	kmovq  %k0,%rcx
 1f945ab:	vpcmpeqb %zmm0,%zmm10,%k0
 1f945b1:	korq   %k0,%k2,%k0
 1f945b6:	or     %rdx,%rcx
 1f945b9:	kmovq  %k0,%r11
 1f945be:	vpcmpneqb %zmm0,%zmm10,%k0
 1f945c5:	and    %r10,%rcx
 1f945c8:	mov    %rsi,%r10
 1f945cb:	vpsllw $0x7,%zmm11,%zmm0
 1f945d2:	kmovq  %k0,%r12
 1f945d7:	vptestmb %zmm5,%zmm5,%k0
 1f945dd:	korq   %k0,%k1,%k0
 1f945e2:	or     %r10,%r12
 1f945e5:	or     %r9,%r12
 1f945e8:	knotq  %k0,%k0
 1f945ed:	and    0x90(%rsp),%r12
 1f945f5:	kmovq  %k0,%rbx
 1f945fa:	vpmovb2m %zmm0,%k0
 1f94600:	kmovq  %k0,%rax
 1f94605:	and    %r11,%rbx
 1f94608:	kmovq  %k0,0x48(%rsp)
 1f9460f:	andn   %rdi,%rax,%rsi
 1f94614:	mov    %r8,%rdi
 1f94617:	not    %rdi
 1f9461a:	mov    %rax,0x128(%rsp)
 1f94622:	andn   %rdi,%rsi,%rax
 1f94627:	mov    %rsi,0xd0(%rsp)
 1f9462f:	and    %rax,%r12
 1f94632:	and    %rax,%r15
 1f94635:	mov    %rax,0x60(%rsp)
 1f9463a:	and    %r15,%rcx
 1f9463d:	and    %rbx,%r12
 1f94640:	mov    %r15,0x138(%rsp)
 1f94648:	or     %rcx,%r12
 1f9464b:	mov    %rcx,0x70(%rsp)
 1f94650:	and    %rdx,%r12
 1f94653:	je     1f94870 <node_contexts_window_loop+0xa30>
 1f94659:	mov    0x58(%rsp),%r8
 1f9465e:	mov    0x10(%rsp),%r11
 1f94663:	mov    %r12,%rbx
 1f94666:	cs nopw 0x0(%rax,%rax,1)
 1f94670:	mov    0x2c0(%r13),%rax
 1f94677:	xor    %r14d,%r14d
 1f9467a:	tzcnt  %rbx,%r14
 1f9467f:	mov    0x60(%r13),%edx
 1f94683:	lea    (%r14,%r11,1),%r15
 1f94687:	mov    %r15,%rcx
 1f9468a:	shl    $0x6,%rcx
 1f9468e:	mov    0x20(%rax,%rcx,1),%esi
 1f94692:	mov    0x20(%r13),%rcx
 1f94696:	mov    %esi,%eax
 1f94698:	shr    $0x3,%eax
 1f9469b:	cmp    %edx,%eax
 1f9469d:	cmovae %edx,%eax
 1f946a0:	shl    $0x6,%rax
 1f946a4:	testb  $0x4,0x34(%rcx,%rax,1)
 1f946a9:	je     1f946db <node_contexts_window_loop+0x89b>
 1f946ab:	mov    0x38(%rcx,%rax,1),%eax
 1f946af:	mov    0xbe0(%r13),%rcx
 1f946b6:	mov    %rax,(%rcx,%r15,8)
 1f946ba:	xor    %ecx,%ecx
 1f946bc:	test   %rax,%rax
 1f946bf:	sete   %cl
 1f946c2:	inc    %r8
 1f946c5:	shlx   %r14,%rcx,%rax
 1f946ca:	andn   %r12,%rax,%r12
 1f946cf:	blsr   %rbx,%rbx
 1f946d4:	jne    1f94670 <node_contexts_window_loop+0x830>
 1f946d6:	jmp    1f9487d <node_contexts_window_loop+0xa3d>
 1f946db:	mov    %r13,%rdi
 1f946de:	mov    %r8,0x58(%rsp)
 1f946e3:	vmovdqa64 %zmm12,0x180(%rsp)
 1f946eb:	vmovdqa64 %zmm13,0x340(%rsp)
 1f946f3:	vmovdqa64 %zmm14,0x300(%rsp)
 1f946fb:	vmovdqa64 %zmm15,0x2c0(%rsp)
 1f94703:	vmovdqa64 %zmm16,0x280(%rsp)
 1f9470b:	vmovdqa64 %zmm17,0x240(%rsp)
 1f94713:	vmovdqa64 %zmm18,0x200(%rsp)
 1f9471b:	vmovdqa64 %zmm19,0x500(%rsp)
 1f94723:	vmovdqa64 %zmm20,0x4c0(%rsp)
 1f9472b:	vmovdqa64 %zmm21,0x480(%rsp)
 1f94733:	vmovdqa64 %zmm22,0x440(%rsp)
 1f9473b:	vmovdqa64 %zmm23,0x400(%rsp)
 1f94743:	vmovdqa64 %zmm24,0x3c0(%rsp)
 1f9474b:	kmovq  %k7,0x38(%rsp)
 1f94752:	vmovdqa64 %zmm25,0x540(%rsp)
 1f9475a:	vmovdqa64 %zmm2,0x380(%rsp)
 1f94762:	vmovdqa64 %zmm5,0x1c0(%rsp)
 1f9476a:	kmovq  %k1,0x28(%rsp)
 1f94771:	kmovq  %k5,0x98(%rsp)
 1f9477b:	mov    %r10,0x110(%rsp)
 1f94783:	vzeroupper
 1f94786:	call   1f96380 <node_contexts_stride_asked>
 1f9478b:	vmovdqa64 0x1c0(%rsp),%zmm5
 1f94793:	vmovdqa64 0x380(%rsp),%zmm2
 1f9479b:	vmovdqa64 0x540(%rsp),%zmm25
 1f947a3:	vmovdqa64 0x3c0(%rsp),%zmm24
 1f947ab:	vmovdqa64 0x400(%rsp),%zmm23
 1f947b3:	vmovdqa64 0x440(%rsp),%zmm22
 1f947bb:	vmovdqa64 0x480(%rsp),%zmm21
 1f947c3:	vmovdqa64 0x4c0(%rsp),%zmm20
 1f947cb:	vmovdqa64 0x500(%rsp),%zmm19
 1f947d3:	vmovdqa64 0x200(%rsp),%zmm18
 1f947db:	vmovdqa64 0x240(%rsp),%zmm17
 1f947e3:	vmovdqa64 0x280(%rsp),%zmm16
 1f947eb:	vmovdqa64 0x2c0(%rsp),%zmm15
 1f947f3:	vmovdqa64 0x5c0(%rsp),%zmm10
 1f947fb:	vmovdqa64 0x300(%rsp),%zmm14
 1f94803:	vmovdqa64 0x340(%rsp),%zmm13
 1f9480b:	vmovdqa64 0x180(%rsp),%zmm12
 1f94813:	vmovdqa64 0x600(%rsp),%zmm11
 1f9481b:	vmovdqa64 0x640(%rsp),%zmm9
 1f94823:	vbroadcasti32x4 -0x19cc8cd(%rip),%zmm8        # 5c7f60 <.LCPI44_39>
 1f9482d:	mov    0x110(%rsp),%r10
 1f94835:	kmovq  0x98(%rsp),%k5
 1f9483f:	kmovq  0x28(%rsp),%k1
 1f94846:	kmovq  0x38(%rsp),%k7
 1f9484d:	mov    0x10(%rsp),%r11
 1f94852:	mov    0x58(%rsp),%r8
 1f94857:	incq   0xe8(%rsp)
 1f9485f:	jmp    1f946af <node_contexts_window_loop+0x86f>
 1f94864:	data16 data16 cs nopw 0x0(%rax,%rax,1)
 1f94870:	mov    0x58(%rsp),%r8
 1f94875:	mov    0x10(%rsp),%r11
 1f9487a:	xor    %r12d,%r12d
 1f9487d:	vpternlogd $0xff,%zmm0,%zmm0,%zmm0
 1f94884:	kmovq  %k1,%rax
 1f94889:	vpaddb -0x1add493(%rip),%zmm10,%zmm1        # 4b7400 <abi_test_hex.digits+0xc080>
 1f94893:	kmovq  0x8(%rsp),%k0
 1f9489a:	or     0x680(%rsp),%rax
 1f948a2:	mov    0x60(%rsp),%r9
 1f948a7:	mov    %r8,0x58(%rsp)
 1f948ac:	vpaddb %zmm0,%zmm25,%zmm0
 1f948b2:	vpcmpltub -0x1add77d(%rip),%zmm0,%k1{%k5}        # 4b7140 <abi_test_hex.digits+0xbdc0>
 1f948bd:	kmovq  %k0,%rcx
 1f948c2:	mov    %r9,%r8
 1f948c5:	and    %r10,%r8
 1f948c8:	andn   %rcx,%rax,%rax
 1f948cd:	mov    %r8,0x540(%rsp)
 1f948d5:	vpcmpltub %zmm8,%zmm1,%k0
 1f948dc:	kmovq  %k0,%rdx
 1f948e1:	kmovq  %k1,%rsi
 1f948e6:	or     %rdx,%rax
 1f948e9:	andn   %r10,%rsi,%rbx
 1f948ee:	and    0x90(%rsp),%rbx
 1f948f6:	and    %rsi,%r8
 1f948f9:	and    %rax,%r8
 1f948fc:	mov    %r8,0x98(%rsp)
 1f94904:	and    %rax,%rbx
 1f94907:	and    %r9,%rbx
 1f9490a:	je     1f94fd0 <node_contexts_window_loop+0x1190>
 1f94910:	mov    0x0(%r13),%rax
 1f94914:	mov    0x2c0(%r13),%rcx
 1f9491b:	mov    0xd8(%rsp),%r13
 1f94923:	xor    %r14d,%r14d
 1f94926:	vmovdqa64 %zmm5,0x1c0(%rsp)
 1f9492e:	vmovdqa64 %zmm2,0x380(%rsp)
 1f94936:	kmovq  %k7,0x38(%rsp)
 1f9493d:	vmovdqa64 %zmm24,0x3c0(%rsp)
 1f94945:	vmovdqa64 %zmm23,0x400(%rsp)
 1f9494d:	vmovdqa64 %zmm22,0x440(%rsp)
 1f94955:	vmovdqa64 %zmm21,0x480(%rsp)
 1f9495d:	vmovdqa64 %zmm20,0x4c0(%rsp)
 1f94965:	vmovdqa64 %zmm19,0x500(%rsp)
 1f9496d:	vmovdqa64 %zmm18,0x200(%rsp)
 1f94975:	vmovdqa64 %zmm17,0x240(%rsp)
 1f9497d:	vmovdqa64 %zmm16,0x280(%rsp)
 1f94985:	vmovdqa64 %zmm15,0x2c0(%rsp)
 1f9498d:	vmovdqa64 %zmm14,0x300(%rsp)
 1f94995:	vmovdqa64 %zmm13,0x340(%rsp)
 1f9499d:	vmovdqa64 %zmm12,0x180(%rsp)
 1f949a5:	mov    %rax,0x8(%rsp)
 1f949aa:	mov    %rcx,0x28(%rsp)
 1f949af:	mov    0x8(%rsp),%rdi
 1f949b4:	mov    0x28(%rsp),%rsi
 1f949b9:	xor    %r15d,%r15d
 1f949bc:	tzcnt  %rbx,%r15
 1f949c1:	lea    (%r11,%r15,1),%edx
 1f949c5:	vzeroupper
 1f949c8:	call   1f962b7 <node_contexts_converted>
 1f949cd:	mov    0x10(%rsp),%r11
 1f949d2:	movzbl %al,%eax
 1f949d5:	inc    %r13
 1f949d8:	shlx   %r15,%rax,%rax
 1f949dd:	or     %rax,%r14
 1f949e0:	blsr   %rbx,%rbx
 1f949e5:	jne    1f949af <node_contexts_window_loop+0xb6f>
 1f949e7:	vbroadcasti32x4 -0x19cca91(%rip),%zmm8        # 5c7f60 <.LCPI44_39>
 1f949f1:	vmovdqa64 0x640(%rsp),%zmm9
 1f949f9:	vmovdqa64 0x600(%rsp),%zmm11
 1f94a01:	vmovdqa64 0x180(%rsp),%zmm12
 1f94a09:	vmovdqa64 0x340(%rsp),%zmm13
 1f94a11:	vmovdqa64 0x300(%rsp),%zmm14
 1f94a19:	vmovdqa64 0x5c0(%rsp),%zmm10
 1f94a21:	vmovdqa64 0x2c0(%rsp),%zmm15
 1f94a29:	vmovdqa64 0x280(%rsp),%zmm16
 1f94a31:	vmovdqa64 0x240(%rsp),%zmm17
 1f94a39:	vmovdqa64 0x200(%rsp),%zmm18
 1f94a41:	vmovdqa64 0x500(%rsp),%zmm19
 1f94a49:	vmovdqa64 0x4c0(%rsp),%zmm20
 1f94a51:	vmovdqa64 0x480(%rsp),%zmm21
 1f94a59:	vmovdqa64 0x440(%rsp),%zmm22
 1f94a61:	vmovdqa64 0x400(%rsp),%zmm23
 1f94a69:	vmovdqa64 0x3c0(%rsp),%zmm24
 1f94a71:	vmovdqa64 0x380(%rsp),%zmm2
 1f94a79:	vmovdqa64 0x1c0(%rsp),%zmm5
 1f94a81:	mov    %r13,0xd8(%rsp)
 1f94a89:	or     %r14,0x98(%rsp)
 1f94a91:	mov    0x88(%rsp),%rax
 1f94a99:	mov    0x40(%rsp),%r13
 1f94a9e:	kmovq  0x38(%rsp),%k7
 1f94aa5:	cmpb   $0x0,0x1f(%rsp)
 1f94aaa:	mov    0x20(%rsp),%rdx
 1f94aaf:	jne    1f94fe8 <node_contexts_window_loop+0x11a8>
 1f94ab5:	mov    %rdx,%rdi
 1f94ab8:	vbroadcasti32x4 -0x19ccad2(%rip),%zmm3        # 5c7ff0 <.LCPI44_50>
 1f94ac2:	vbroadcasti32x4 -0x19ccb2c(%rip),%zmm1        # 5c7fa0 <.LCPI44_44>
 1f94acc:	kmovq  0x100(%rsp),%k2
 1f94ad6:	vbroadcasti32x4 -0x19ccae0(%rip),%zmm4        # 5c8000 <.LCPI44_51>
 1f94ae0:	vbroadcasti32x4 -0x19ccada(%rip),%zmm6        # 5c8010 <.LCPI44_52>
 1f94aea:	kmovq  %k7,%r9
 1f94aef:	vbroadcasti32x4 -0x19ccad9(%rip),%zmm7        # 5c8020 <.LCPI44_53>
 1f94af9:	kmovq  0x580(%rsp),%k3
 1f94b03:	kmovq  0x50(%rsp),%k5
 1f94b0a:	shl    $0x3f,%rax
 1f94b0e:	mov    %r9,0x28(%rsp)
 1f94b13:	vpandq %zmm3,%zmm23,%zmm0
 1f94b19:	vptestmb %zmm1,%zmm18,%k1
 1f94b1f:	vbroadcasti32x4 -0x19ccaf9(%rip),%zmm23        # 5c8030 <.LCPI44_54>
 1f94b29:	vptestnmb %zmm0,%zmm0,%k0
 1f94b2f:	kmovq  %k0,%rcx
 1f94b34:	kandq  %k2,%k1,%k0
 1f94b39:	kmovq  0xa0(%rsp),%k2
 1f94b43:	mov    %rcx,0x8(%rsp)
 1f94b48:	kmovq  %k0,%rcx
 1f94b4d:	vptestmb %zmm1,%zmm11,%k0
 1f94b53:	vbroadcasti32x4 -0x19ccbcd(%rip),%zmm1        # 5c7f90 <.LCPI44_43>
 1f94b5d:	kmovq  %k0,%rdx
 1f94b62:	vpcmpeqb %zmm3,%zmm10,%k0
 1f94b68:	and    %rcx,%rdi
 1f94b6b:	mov    0xc0(%rsp),%rcx
 1f94b73:	kmovq  %k0,%rsi
 1f94b78:	vpcmpeqb %zmm4,%zmm10,%k0
 1f94b7e:	mov    %rdx,0x180(%rsp)
 1f94b86:	mov    %rdi,0x20(%rsp)
 1f94b8b:	mov    %rsi,0x340(%rsp)
 1f94b93:	kmovq  %k0,%rsi
 1f94b98:	vpcmpeqb %zmm6,%zmm10,%k0
 1f94b9e:	kmovq  %k0,%rdx
 1f94ba3:	korq   %k2,%k7,%k0
 1f94ba8:	kmovq  0xb8(%rsp),%k7
 1f94bb2:	mov    %rdx,0x300(%rsp)
 1f94bba:	vpcmpeqb %zmm1,%zmm24,%k2{%k7}
 1f94bc0:	korq   %k2,%k0,%k0
 1f94bc5:	vptestnmb %zmm2,%zmm2,%k2
 1f94bcb:	vpandd -0x19c3c1d(%rip){1to16},%zmm22,%zmm2        # 5d0fb8 <.LCPI44_55>
 1f94bd5:	vpcmpeqb -0x1add65f(%rip),%zmm2,%k4        # 4b7580 <abi_test_hex.digits+0xc200>
 1f94bdf:	kmovq  %k0,%r8
 1f94be4:	vpcmpeqb %zmm1,%zmm10,%k0{%k7}
 1f94bea:	kmovq  %k2,%rbx
 1f94bef:	kandq  %k3,%k7,%k2
 1f94bf4:	vpandq %zmm7,%zmm22,%zmm1
 1f94bfa:	vpandq %zmm7,%zmm21,%zmm2
 1f94c00:	kmovq  %k0,%r11
 1f94c05:	vptestnmb %zmm5,%zmm5,%k0
 1f94c0b:	kmovq  %k2,%r10
 1f94c10:	vpcmpeqb %zmm23,%zmm1,%k2
 1f94c16:	vbroadcasti32x4 -0x19ccbe0(%rip),%zmm5        # 5c8040 <.LCPI44_56>
 1f94c20:	andn   %r8,%rcx,%rcx
 1f94c25:	kmovq  %k0,%r9
 1f94c2a:	mov    %rcx,0x580(%rsp)
 1f94c32:	mov    0xa8(%rsp),%rcx
 1f94c3a:	and    %r11,%rbx
 1f94c3d:	mov    %rbx,0x1c0(%rsp)
 1f94c45:	mov    0x60(%rsp),%rbx
 1f94c4a:	and    %rsi,%r9
 1f94c4d:	andn   %r10,%rcx,%rdi
 1f94c52:	and    0x340(%rsp),%rdi
 1f94c5a:	kxorq  %k2,%k4,%k0
 1f94c5f:	vpcmpeqb %zmm23,%zmm10,%k2
 1f94c65:	kmovq  %k4,0x500(%rsp)
 1f94c6f:	kmovq  %k0,%rdx
 1f94c74:	kmovq  0xb0(%rsp),%k0
 1f94c7e:	kmovq  %k2,0x380(%rsp)
 1f94c88:	mov    %rdx,0xc0(%rsp)
 1f94c90:	kandq  %k2,%k0,%k6
 1f94c95:	kmovq  0x78(%rsp),%k0
 1f94c9c:	kxorq  %k2,%k6,%k2
 1f94ca1:	kmovq  %k6,0x4c0(%rsp)
 1f94cab:	kmovq  %k2,%r15
 1f94cb0:	vpcmpeqb %zmm4,%zmm19,%k2
 1f94cb6:	vbroadcasti32x4 -0x19ccc70(%rip),%zmm4        # 5c8050 <.LCPI44_57>
 1f94cc0:	kmovq  %k2,%r14
 1f94cc5:	vptestnmb -0x1addb0f(%rip),%zmm21,%k2        # 4b71c0 <abi_test_hex.digits+0xbe40>
 1f94ccf:	and    %rbx,%r15
 1f94cd2:	mov    %r14,0xb0(%rsp)
 1f94cda:	kmovq  %k5,%r14
 1f94cdf:	vpcmpeqb %zmm4,%zmm2,%k1{%k1}
 1f94ce5:	vpandq %zmm3,%zmm20,%zmm2
 1f94ceb:	korq   %k1,%k2,%k1
 1f94cf0:	vptestmb -0x1add6fa(%rip),%zmm9,%k2        # 4b7600 <abi_test_hex.digits+0xc280>
 1f94cfa:	vporq  %zmm0,%zmm2,%zmm0
 1f94d00:	kmovq  %k1,%r11
 1f94d05:	vpcmpeqb %zmm6,%zmm1,%k1
 1f94d0b:	kmovq  %k1,%rcx
 1f94d10:	kandq  %k1,%k5,%k1
 1f94d15:	and    %rbx,%r11
 1f94d18:	kmovq  %k1,%rsi
 1f94d1d:	andn   %rcx,%r14,%rcx
 1f94d22:	or     %rdx,%rcx
 1f94d25:	mov    0xb0(%rsp),%rdx
 1f94d2d:	korq   %k3,%k2,%k3
 1f94d32:	vpcmpeqb %zmm5,%zmm1,%k2
 1f94d38:	kandq  %k2,%k5,%k1
 1f94d3d:	korq   %k4,%k1,%k1
 1f94d42:	kmovq  0x48(%rsp),%k4
 1f94d49:	kmovq  %k1,%r8
 1f94d4e:	korq   %k7,%k0,%k1
 1f94d53:	kmovq  %k1,%r10
 1f94d58:	and    %r10,%r9
 1f94d5b:	mov    %r9,0xa0(%rsp)
 1f94d63:	mov    %r11,%r9
 1f94d66:	and    0x300(%rsp),%r9
 1f94d6e:	korq   %k4,%k3,%k3
 1f94d73:	kmovq  0x108(%rsp),%k4
 1f94d7d:	knotq  %k3,%k3
 1f94d82:	lea    (%r15,%r9,2),%r10
 1f94d86:	vptestnmb %zmm15,%zmm15,%k5{%k4}
 1f94d8c:	andn   %r15,%r10,%r10
 1f94d91:	or     %r9,%r15
 1f94d94:	and    %r15,%rcx
 1f94d97:	mov    %r10,0x400(%rsp)
 1f94d9f:	or     %r9,%r10
 1f94da2:	and    %r15,%rsi
 1f94da5:	mov    %r15,0x480(%rsp)
 1f94dad:	andn   0x8(%rsp),%rdx,%r15
 1f94db4:	and    %rcx,%rax
 1f94db7:	and    %r10,%r8
 1f94dba:	or     %rsi,%rax
 1f94dbd:	or     %r8,%rax
 1f94dc0:	mov    %rcx,%r8
 1f94dc3:	shr    $1,%r8
 1f94dc6:	korq   %k5,%k0,%k4
 1f94dcb:	korq   %k7,%k5,%k5
 1f94dd0:	mov    %rax,%rsi
 1f94dd3:	shr    $1,%rsi
 1f94dd6:	and    %rcx,%r8
 1f94dd9:	and    %rcx,%rsi
 1f94ddc:	kmovq  %k2,%rcx
 1f94de1:	vpcmpeqb %zmm8,%zmm1,%k2
 1f94de7:	mov    %r8,%r10
 1f94dea:	shr    $0x2,%r10
 1f94dee:	or     %rax,%rsi
 1f94df1:	and    %r8,%r10
 1f94df4:	andn   %rcx,%r14,%rcx
 1f94df9:	mov    %rsi,%rax
 1f94dfc:	shr    $0x2,%rax
 1f94e00:	mov    %r10,0x3c0(%rsp)
 1f94e08:	and    %r8,%rax
 1f94e0b:	mov    0x80(%rsp),%r8
 1f94e13:	mov    %r9,0x80(%rsp)
 1f94e1b:	or     %rsi,%rax
 1f94e1e:	kmovq  %k2,%rsi
 1f94e23:	vptestnmb %zmm2,%zmm2,%k2
 1f94e29:	vpaddb -0x1add7f3(%rip),%zmm19,%zmm2        # 4b7640 <abi_test_hex.digits+0xc2c0>
 1f94e33:	or     0x30(%rsp),%r8
 1f94e38:	kmovq  %k2,%rdx
 1f94e3d:	or     %rsi,%rcx
 1f94e40:	kmovq  %k4,%rsi
 1f94e45:	kandq  %k2,%k5,%k5
 1f94e4a:	mov    %rax,0x88(%rsp)
 1f94e52:	and    %rdx,%r15
 1f94e55:	mov    0x180(%rsp),%rdx
 1f94e5d:	mov    %rsi,0x8(%rsp)
 1f94e62:	and    %r8,%rcx
 1f94e65:	and    %rdx,%rdi
 1f94e68:	and    0x28(%rsp),%rdx
 1f94e6d:	vpcmpltub %zmm8,%zmm2,%k4{%k6}
 1f94e74:	vbroadcasti32x4 -0x19cce1e(%rip),%zmm2        # 5c8060 <.LCPI44_58>
 1f94e7e:	and    %rbx,%rdi
 1f94e81:	mov    %rdi,0x240(%rsp)
 1f94e89:	kmovq  %k4,%rdi
 1f94e8e:	vpcmpeqb %zmm5,%zmm10,%k4
 1f94e94:	kmovq  %k4,%rsi
 1f94e99:	or     %rax,%rdi
 1f94e9c:	mov    %rdi,0x280(%rsp)
 1f94ea4:	kmovq  %k5,%rdi
 1f94ea9:	and    %rsi,%r11
 1f94eac:	mov    %rsi,0x38(%rsp)
 1f94eb1:	mov    %rdx,0x180(%rsp)
 1f94eb9:	mov    %rax,%rdx
 1f94ebc:	or     %r10,%rdx
 1f94ebf:	and    %r11,%rdi
 1f94ec2:	mov    %r11,0x440(%rsp)
 1f94eca:	andn   %r9,%rdx,%rdx
 1f94ecf:	mov    %rdi,0x200(%rsp)
 1f94ed7:	and    %rdx,%r15
 1f94eda:	mov    %rdx,0x78(%rsp)
 1f94edf:	mov    0x540(%rsp),%rdx
 1f94ee7:	mov    %r15,0x2c0(%rsp)
 1f94eef:	mov    0x1c0(%rsp),%r15
 1f94ef7:	mov    %r14,0x1c0(%rsp)
 1f94eff:	vpcmpeqb %zmm2,%zmm10,%k5
 1f94f05:	vpcmpeqb %zmm2,%zmm1,%k4
 1f94f0b:	kmovq  %k5,%r8
 1f94f10:	vptestnmb %zmm0,%zmm0,%k5
 1f94f16:	mov    %r8,0xa8(%rsp)
 1f94f1e:	and    %r8,%rdx
 1f94f21:	kmovq  %k4,%r8
 1f94f26:	vpcmpeqb %zmm4,%zmm1,%k4
 1f94f2c:	and    %rbx,%r15
 1f94f2f:	andn   %r8,%r14,%rdi
 1f94f34:	mov    %rdx,0x540(%rsp)
 1f94f3c:	mov    %r8,0x48(%rsp)
 1f94f41:	mov    %r15,%rsi
 1f94f44:	and    0x20(%rsp),%rsi
 1f94f49:	and    %rdx,%rcx
 1f94f4c:	kmovq  %k5,%rdx
 1f94f51:	mov    %rdi,0x28(%rsp)
 1f94f56:	kmovq  %k3,%rdi
 1f94f5b:	mov    %rdx,0x50(%rsp)
 1f94f60:	kmovq  %k4,%rdx
 1f94f65:	mov    %rdi,0x30(%rsp)
 1f94f6a:	je     1f951c0 <node_contexts_window_loop+0x1380>
 1f94f70:	mov    0xb88(%r13),%rdi
 1f94f77:	mov    0x68(%rsp),%rax
 1f94f7c:	mov    0x10(%rsp),%r9
 1f94f81:	xor    %r10d,%r10d
 1f94f84:	data16 data16 cs nopw 0x0(%rax,%rax,1)
 1f94f90:	xor    %r11d,%r11d
 1f94f93:	tzcnt  %rcx,%r11
 1f94f98:	lea    (%r9,%r11,1),%ebx
 1f94f9c:	movzwl 0x6f654(%rax,%rbx,2),%r14d
 1f94fa5:	add    %ebx,%r14d
 1f94fa8:	xor    %ebx,%ebx
 1f94faa:	cmpb   $0x0,(%rdi,%r14,1)
 1f94faf:	sete   %bl
 1f94fb2:	shlx   %r11,%rbx,%r11
 1f94fb7:	or     %r11,%r10
 1f94fba:	blsr   %rcx,%rcx
 1f94fbf:	jne    1f94f90 <node_contexts_window_loop+0x1150>
 1f94fc1:	jmp    1f951c8 <node_contexts_window_loop+0x1388>
 1f94fc6:	cs nopw 0x0(%rax,%rax,1)
 1f94fd0:	mov    0x88(%rsp),%rax
 1f94fd8:	cmpb   $0x0,0x1f(%rsp)
 1f94fdd:	mov    0x20(%rsp),%rdx
 1f94fe2:	je     1f94ab5 <node_contexts_window_loop+0xc75>
 1f94fe8:	mov    0x70(%rsp),%rcx
 1f94fed:	test   %rcx,%rcx
 1f94ff0:	je     1f95ba0 <node_contexts_window_loop+0x1d60>
 1f94ff6:	mov    0x0(%r13),%rax
 1f94ffa:	xor    %r14d,%r14d
 1f94ffd:	mov    %rcx,%r15
 1f95000:	mov    0x8(%rax),%rdi
 1f95004:	movzbl 0x14a(%rdi),%ebx
 1f9500b:	xor    %r13d,%r13d
 1f9500e:	tzcnt  %r15,%r13
 1f95013:	test   %bl,%bl
 1f95015:	jne    1f95032 <node_contexts_window_loop+0x11f2>
 1f95017:	xor    %ecx,%ecx
 1f95019:	shlx   %r13,%rcx,%rax
 1f9501e:	or     %rax,%r14
 1f95021:	mov    0x70(%rsp),%rax
 1f95026:	blsr   %r15,%r15
 1f9502b:	jne    1f9500b <node_contexts_window_loop+0x11cb>
 1f9502d:	jmp    1f95b7f <node_contexts_window_loop+0x1d3f>
 1f95032:	mov    0x68(%rsp),%rdx
 1f95037:	mov    0x40(%rsp),%rax
 1f9503c:	lea    (%r11,%r13,1),%ecx
 1f95040:	vmovdqa64 %zmm5,0x1c0(%rsp)
 1f95048:	vmovdqa64 %zmm2,0x380(%rsp)
 1f95050:	kmovq  %k7,0x38(%rsp)
 1f95057:	vmovdqa64 %zmm24,0x3c0(%rsp)
 1f9505f:	vmovdqa64 %zmm23,0x400(%rsp)
 1f95067:	vmovdqa64 %zmm22,0x440(%rsp)
 1f9506f:	vmovdqa64 %zmm21,0x480(%rsp)
 1f95077:	vmovdqa64 %zmm20,0x4c0(%rsp)
 1f9507f:	vmovdqa64 %zmm19,0x500(%rsp)
 1f95087:	vmovdqa64 %zmm18,0x200(%rsp)
 1f9508f:	vmovdqa64 %zmm17,0x240(%rsp)
 1f95097:	vmovdqa64 %zmm16,0x280(%rsp)
 1f9509f:	vmovdqa64 %zmm15,0x2c0(%rsp)
 1f950a7:	vmovdqa64 %zmm14,0x300(%rsp)
 1f950af:	vmovdqa64 %zmm13,0x340(%rsp)
 1f950b7:	vmovdqa64 %zmm12,0x180(%rsp)
 1f950bf:	mov    %rdi,0x8(%rsp)
 1f950c4:	movzwl 0x6b554(%rdx,%rcx,2),%edx
 1f950cc:	mov    0x2c0(%rax),%rax
 1f950d3:	sub    %edx,%ecx
 1f950d5:	shl    $0x6,%rcx
 1f950d9:	mov    (%rax,%rcx,1),%esi
 1f950dc:	vzeroupper
 1f950df:	call   1f35e90 <type_object_qualifiers_slow>
 1f950e4:	and    $0xffffff,%eax
 1f950e9:	lea    -0x110(%rax),%ecx
 1f950ef:	cmp    $0x2,%ecx
 1f950f2:	ja     1f9510a <node_contexts_window_loop+0x12ca>
 1f950f4:	lea    -0x1ac5486(%rip),%rdx        # 4cfc75 <check_lower_segment_override.segments>
 1f950fb:	xor    %ecx,%ecx
 1f950fd:	testb  $0x3,-0x110(%rax,%rdx,1)
 1f95105:	setne  %cl
 1f95108:	jmp    1f9510c <node_contexts_window_loop+0x12cc>
 1f9510a:	xor    %ecx,%ecx
 1f9510c:	vbroadcasti32x4 -0x19cd1b6(%rip),%zmm8        # 5c7f60 <.LCPI44_39>
 1f95116:	vmovdqa64 0x640(%rsp),%zmm9
 1f9511e:	vmovdqa64 0x600(%rsp),%zmm11
 1f95126:	vmovdqa64 0x180(%rsp),%zmm12
 1f9512e:	vmovdqa64 0x340(%rsp),%zmm13
 1f95136:	vmovdqa64 0x300(%rsp),%zmm14
 1f9513e:	vmovdqa64 0x5c0(%rsp),%zmm10
 1f95146:	vmovdqa64 0x2c0(%rsp),%zmm15
 1f9514e:	vmovdqa64 0x280(%rsp),%zmm16
 1f95156:	vmovdqa64 0x240(%rsp),%zmm17
 1f9515e:	vmovdqa64 0x200(%rsp),%zmm18
 1f95166:	vmovdqa64 0x500(%rsp),%zmm19
 1f9516e:	vmovdqa64 0x4c0(%rsp),%zmm20
 1f95176:	vmovdqa64 0x480(%rsp),%zmm21
 1f9517e:	vmovdqa64 0x440(%rsp),%zmm22
 1f95186:	vmovdqa64 0x400(%rsp),%zmm23
 1f9518e:	vmovdqa64 0x3c0(%rsp),%zmm24
 1f95196:	vmovdqa64 0x380(%rsp),%zmm2
 1f9519e:	vmovdqa64 0x1c0(%rsp),%zmm5
 1f951a6:	mov    0x10(%rsp),%r11
 1f951ab:	kmovq  0x38(%rsp),%k7
 1f951b2:	mov    0x8(%rsp),%rdi
 1f951b7:	jmp    1f95019 <node_contexts_window_loop+0x11d9>
 1f951bc:	nopl   0x0(%rax)
 1f951c0:	mov    0x10(%rsp),%r9
 1f951c5:	xor    %r10d,%r10d
 1f951c8:	vbroadcasti32x4 -0x19cd242(%rip),%zmm1        # 5c7f90 <.LCPI44_43>
 1f951d2:	vpcmpeqb -0x1ade09c(%rip),%zmm10,%k1{%k1}        # 4b7140 <abi_test_hex.digits+0xbdc0>
 1f951dc:	vpcmpeqb -0x1adde26(%rip),%zmm10,%k0        # 4b73c0 <abi_test_hex.digits+0xc040>
 1f951e6:	mov    0x50(%rsp),%rax
 1f951eb:	mov    0x580(%rsp),%rcx
 1f951f3:	vpsllw $0x7,%zmm16,%zmm0
 1f951fa:	mov    0x20(%rsp),%r11
 1f951ff:	and    %rdx,0x30(%rsp)
 1f95204:	and    0x280(%rsp),%rax
 1f9520c:	and    0xd0(%rsp),%rcx
 1f95214:	vpmovb2m %zmm0,%k4
 1f9521a:	andn   %r15,%r11,%r14
 1f9521f:	mov    0x48(%rsp),%r11
 1f95224:	mov    %rax,0x50(%rsp)
 1f95229:	mov    0x60(%rsp),%rax
 1f9522e:	mov    %rcx,0x580(%rsp)
 1f95236:	and    0xa8(%rsp),%r11
 1f9523e:	vptestmb %zmm1,%zmm18,%k3
 1f95244:	kmovq  %k1,%rdi
 1f95249:	kmovq  0xb8(%rsp),%k1
 1f95253:	vpcmpeqb -0x1addd9d(%rip),%zmm10,%k1{%k1}        # 4b74c0 <abi_test_hex.digits+0xc140>
 1f9525d:	kmovq  %k3,%rbx
 1f95262:	vpcmpltub -0x1ade02d(%rip),%zmm15,%k3        # 4b7240 <abi_test_hex.digits+0xbec0>
 1f9526d:	andn   %rsi,%rbx,%r8
 1f95272:	and    %rbx,%rsi
 1f95275:	mov    %rax,%rbx
 1f95278:	mov    %r8,0xd0(%rsp)
 1f95280:	mov    0x1c0(%rsp),%r8
 1f95288:	and    %rax,0x8(%rsp)
 1f9528d:	and    %rax,%rdi
 1f95290:	and    %rax,0xa0(%rsp)
 1f95298:	not    %rbx
 1f9529b:	kmovq  %k1,%rcx
 1f952a0:	vpcmpeqb -0x1adde6a(%rip),%zmm10,%k1        # 4b7440 <abi_test_hex.digits+0xc0c0>
 1f952aa:	and    %r8,%r11
 1f952ad:	and    %r8,0x180(%rsp)
 1f952b5:	korq   %k4,%k3,%k3
 1f952ba:	vptestmb -0x1ade1c4(%rip),%zmm11,%k1{%k1}        # 4b7100 <abi_test_hex.digits+0xbd80>
 1f952c4:	and    %rax,%rcx
 1f952c7:	mov    %r11,%r8
 1f952ca:	mov    0x200(%rsp),%r11
 1f952d2:	vpcmpeqb %zmm8,%zmm10,%k3{%k3}
 1f952d8:	korq   %k3,%k0,%k3
 1f952dd:	kmovq  0x380(%rsp),%k0
 1f952e7:	kmovq  %k3,%rdx
 1f952ec:	and    %rax,%rdx
 1f952ef:	or     %r11,0x2c0(%rsp)
 1f952f7:	mov    %r9,%r11
 1f952fa:	mov    0x40(%rsp),%r9
 1f952ff:	kandq  %k0,%k2,%k0
 1f95304:	kmovq  %k0,%r13
 1f95309:	kmovq  %k1,%r15
 1f9530e:	kmovq  0x130(%rsp),%k1
 1f95318:	vptestmb %zmm1,%zmm11,%k0
 1f9531e:	and    %rax,%r13
 1f95321:	mov    0x120(%rsp),%rax
 1f95329:	vmovdqu8 -0x1ade333(%rip),%zmm0{%k1}{z}        # 4b7000 <abi_test_hex.digits+0xbc80>
 1f95333:	or     %rax,0x28(%rsp)
 1f95338:	andn   %r15,%rax,%rax
 1f9533d:	andn   0x680(%rsp),%r12,%r15
 1f95347:	andn   0x70(%rsp),%r15,%r15
 1f9534e:	mov    %rax,0xb8(%rsp)
 1f95356:	kmovq  %k0,%rax
 1f9535b:	mov    %rax,0x20(%rsp)
 1f95360:	mov    %r15,0x60(%rsp)
 1f95365:	mov    0x240(%rsp),%r15
 1f9536d:	and    %rax,%r15
 1f95370:	or     %r10,%r8
 1f95373:	mov    0xbc0(%r9),%r10
 1f9537a:	mov    %r8,0x48(%rsp)
 1f9537f:	vmovdqu64 %zmm0,(%r10,%r11,1)
 1f95386:	mov    %r8,%r10
 1f95389:	je     1f953aa <node_contexts_window_loop+0x156a>
 1f9538b:	nopl   0x0(%rax,%rax,1)
 1f95390:	xor    %eax,%eax
 1f95392:	tzcnt  %r10,%rax
 1f95397:	add    0xbc0(%r9),%rax
 1f9539e:	blsr   %r10,%r10
 1f953a3:	movb   $0x4,(%r11,%rax,1)
 1f953a8:	jne    1f95390 <node_contexts_window_loop+0x1550>
 1f953aa:	mov    0x8(%rsp),%rax
 1f953af:	or     %rbx,0x28(%rsp)
 1f953b4:	mov    0x580(%rsp),%rbx
 1f953bc:	mov    0x180(%rsp),%r8
 1f953c4:	movabs $0x7fffffffffffffff,%r10
 1f953ce:	vmovdqa64 0x700(%rsp),%zmm1
 1f953d6:	vbroadcasti32x4 -0x19cd440(%rip),%zmm2        # 5c7fa0 <.LCPI44_44>
 1f953e0:	kmovq  0x150(%rsp),%k7
 1f953ea:	kmovq  0x100(%rsp),%k3
 1f953f4:	vptestmb %zmm17,%zmm17,%k1
 1f953fa:	or     0x128(%rsp),%rax
 1f95402:	inc    %r10
 1f95405:	vmovdqu8 -0x1ade40f(%rip),%zmm0{%k1}{z}        # 4b7000 <abi_test_hex.digits+0xbc80>
 1f9540f:	and    %r10,0xc0(%rsp)
 1f95417:	mov    %r14,%r10
 1f9541a:	or     %rcx,%r10
 1f9541d:	or     %r13,%rcx
 1f95420:	or     %rsi,%rcx
 1f95423:	or     %r15,%rbx
 1f95426:	and    %r8,0x30(%rsp)
 1f9542b:	mov    0xd0(%rsp),%r8
 1f95433:	mov    %rax,0x8(%rsp)
 1f95438:	mov    0x540(%rsp),%rax
 1f95440:	or     %rdi,%rbx
 1f95443:	or     %r14,%rdi
 1f95446:	mov    %rdi,%r15
 1f95449:	or     0x240(%rsp),%rdi
 1f95451:	or     %r13,%r15
 1f95454:	vpermt2b %zmm13,%zmm14,%zmm1
 1f9545a:	or     %r8,%r10
 1f9545d:	or     %rax,%rdx
 1f95460:	or     %rbx,%r10
 1f95463:	mov    %rdx,%rbx
 1f95466:	or     %r8,%rdx
 1f95469:	or     %rsi,%rbx
 1f9546c:	or     %rdi,%rdx
 1f9546f:	mov    0xa0(%rsp),%rdi
 1f95477:	or     %r15,%rbx
 1f9547a:	vpcmpeqb -0x1ade444(%rip),%zmm1,%k0{%k7}        # 4b7040 <abi_test_hex.digits+0xbcc0>
 1f95484:	or     %rsi,%rdx
 1f95487:	mov    0x60(%rsp),%rsi
 1f9548c:	or     %r12,%rdx
 1f9548f:	kmovq  %rdx,%k5
 1f95494:	or     %r14,%rdi
 1f95497:	or     %r8,%rdi
 1f9549a:	or     %rdi,%rcx
 1f9549d:	mov    0x98(%rsp),%rdi
 1f954a5:	or     %r12,%rcx
 1f954a8:	kmovq  %k0,%rdx
 1f954ad:	or     %rdi,%r10
 1f954b0:	or     %rdi,%rbx
 1f954b3:	or     %rdi,%rcx
 1f954b6:	mov    0x280(%rsp),%rdi
 1f954be:	kmovq  %r10,%k6
 1f954c3:	kmovq  %rbx,%k2
 1f954c8:	kmovq  %rcx,%k4
 1f954cd:	mov    0xb8(%rsp),%rcx
 1f954d5:	vmovdqu8 -0x1ade4df(%rip),%zmm3{%k6}{z}        # 4b7000 <abi_test_hex.digits+0xbc80>
 1f954df:	or     %rdx,%rdi
 1f954e2:	mov    0x50(%rsp),%rdx
 1f954e7:	kmovq  %rcx,%k1
 1f954ec:	kmovq  %k3,%rcx
 1f954f1:	not    %rdi
 1f954f4:	andn   %rsi,%rcx,%rcx
 1f954f9:	kmovq  %rcx,%k3
 1f954fe:	mov    0x680(%rsp),%rcx
 1f95506:	vporq  %zmm2,%zmm3,%zmm1
 1f9550c:	vmovdqu8 %zmm1,%zmm3{%k5}
 1f95512:	vporq  %zmm8,%zmm3,%zmm1
 1f95518:	vmovdqu8 %zmm1,%zmm3{%k2}
 1f9551e:	vpord  -0x19c456c(%rip){1to16},%zmm3,%zmm1        # 5d0fbc <.LCPI44_59>
 1f95528:	and    %rsi,%rcx
 1f9552b:	kmovq  %rcx,%k6
 1f95530:	mov    0x48(%rsp),%rcx
 1f95535:	kmovq  %rcx,%k5
 1f9553a:	mov    0x200(%rsp),%rcx
 1f95542:	vmovdqu8 %zmm1,%zmm3{%k4}
 1f95548:	vmovdqu8 -0x1added2(%rip),%zmm3{%k1}        # 4b7680 <abi_test_hex.digits+0xc300>
 1f95552:	kmovq  %rsi,%k1
 1f95557:	vbroadcasti32x4 -0x19cd4f1(%rip),%zmm1        # 5c8070 <.LCPI44_60>
 1f95561:	kmovq  %rcx,%k2
 1f95566:	or     %rax,%rcx
 1f95569:	kmovq  %rcx,%k4
 1f9556e:	mov    0x2c0(%rsp),%rcx
 1f95576:	vmovdqu8 -0x1addec0(%rip),%zmm3{%k1}        # 4b76c0 <abi_test_hex.digits+0xc340>
 1f95580:	kmovq  %rdx,%k1
 1f95585:	vpblendmb -0x1ade3cf(%rip),%zmm1,%zmm1{%k5}        # 4b71c0 <abi_test_hex.digits+0xbe40>
 1f9558f:	mov    0xf8(%rsp),%rax
 1f95597:	mov    0x90(%rsp),%rsi
 1f9559f:	and    %rsi,%rdx
 1f955a2:	mov    %rdx,0x48(%rsp)
 1f955a7:	vmovdqu8 -0x1addeb1(%rip),%zmm3{%k1}        # 4b7700 <abi_test_hex.digits+0xc380>
 1f955b1:	kmovq  %rcx,%k1
 1f955b6:	vmovdqu8 -0x1adde40(%rip),%zmm1{%k2}        # 4b7780 <abi_test_hex.digits+0xc400>
 1f955c0:	and    %rsi,%rcx
 1f955c3:	mov    %rcx,0x50(%rsp)
 1f955c8:	vmovdqu8 -0x1ade652(%rip),%zmm3{%k1}        # 4b6f80 <abi_test_hex.digits+0xbc00>
 1f955d2:	kmovq  0xf0(%rsp),%k1
 1f955dc:	vmovdqa64 %zmm3,%zmm4
 1f955e2:	vpaddb %zmm8,%zmm3,%zmm4{%k3}
 1f955e8:	vmovdqa64 %zmm3,0x180(%rsp)
 1f955f0:	vpaddb %zmm2,%zmm4,%zmm4{%k6}
 1f955f6:	vmovdqu8 %zmm1,%zmm4{%k4}
 1f955fc:	vpermi2b %zmm12,%zmm4,%zmm14{%k7}{z}
 1f95602:	vmovdqa64 %zmm4,0x680(%rsp)
 1f9560a:	vmovdqu8 0x800(%rsp),%zmm14{%k1}
 1f95612:	kmovq  %rdi,%k1
 1f95617:	mov    0xbb0(%r9),%rdi
 1f9561e:	vpaddw %zmm14,%zmm14,%zmm1
 1f95624:	vporq  %zmm0,%zmm1,%zmm0
 1f9562a:	vpermb 0x80(%rax),%zmm0,%zmm0
 1f95631:	vmovdqu64 %zmm3,(%rdi,%r11,1)
 1f95638:	mov    0xbb8(%r9),%rax
 1f9563f:	vmovdqu64 %zmm4,(%rax,%r11,1)
 1f95646:	mov    0xbc8(%r9),%rax
 1f9564d:	vmovdqa64 %zmm0,0x580(%rsp)
 1f95655:	vpandd -0x19c469f(%rip){1to16},%zmm0,%zmm0        # 5d0fc0 <.LCPI44_61>
 1f9565f:	vmovdqu8 %zmm0,%zmm0{%k1}{z}
 1f95665:	vmovdqu64 %zmm0,(%rax,%r11,1)
 1f9566c:	test   %rcx,%rcx
 1f9566f:	je     1f957b0 <node_contexts_window_loop+0x1970>
 1f95675:	mov    0xbc8(%r9),%r13
 1f9567c:	mov    0x2c0(%r9),%r15
 1f95683:	mov    0x68(%rsp),%rsi
 1f95688:	mov    0x10(%rsp),%r9
 1f9568d:	lea    -0x19b5d84(%rip),%r8        # 5df910 <switch.table.tier1_burs_check_function.51217+0xda18>
 1f95694:	mov    %rcx,%r14
 1f95697:	xor    %r12d,%r12d
 1f9569a:	jmp    1f956d3 <node_contexts_window_loop+0x1893>
 1f9569c:	nopl   0x0(%rax)
 1f956a0:	mov    $0x50,%ecx
 1f956a5:	movzwl 0x6b554(%rsi,%rdx,2),%edi
 1f956ad:	mov    $0x1,%eax
 1f956b2:	cmp    0x6d5d4(%rsi,%rdx,2),%di
 1f956ba:	jne    1f9574f <node_contexts_window_loop+0x190f>
 1f956c0:	shlx   %rbx,%rax,%rax
 1f956c5:	or     %rax,%r12
 1f956c8:	blsr   %r14,%r14
 1f956cd:	je     1f957bd <node_contexts_window_loop+0x197d>
 1f956d3:	xor    %ebx,%ebx
 1f956d5:	tzcnt  %r14,%rbx
 1f956da:	mov    %r9d,%edx
 1f956dd:	or     %rbx,%rdx
 1f956e0:	cmpb   $0x0,0x196ac(%rsi,%rdx,1)
 1f956e8:	mov    %rdx,%rax
 1f956eb:	je     1f956f7 <node_contexts_window_loop+0x18b7>
 1f956ed:	movzwl 0x6f654(%rsi,%rdx,2),%eax
 1f956f5:	add    %edx,%eax
 1f956f7:	movzbl 0x0(%r13,%rdx,1),%ecx
 1f956fd:	dec    %ecx
 1f956ff:	cmp    $0x3,%ecx
 1f95702:	ja     1f95748 <node_contexts_window_loop+0x1908>
 1f95704:	movslq (%r8,%rcx,4),%rcx
 1f95708:	shl    $0x6,%rax
 1f9570c:	add    %r15,%rax
 1f9570f:	add    %r8,%rcx
 1f95712:	jmp    *%rcx
 1f95714:	xor    %ecx,%ecx
 1f95716:	cmpb   $0x0,0x1a72c(%rsi,%rdx,1)
 1f9571e:	setne  %cl
 1f95721:	mov    0x20(%rax,%rcx,4),%ecx
 1f95725:	jmp    1f956a5 <node_contexts_window_loop+0x1865>
 1f9572a:	nopw   0x0(%rax,%rax,1)
 1f95730:	mov    %rdx,%rax
 1f95733:	shl    $0x6,%rax
 1f95737:	mov    0x38(%r15,%rax,1),%ecx
 1f9573c:	jmp    1f956a5 <node_contexts_window_loop+0x1865>
 1f95741:	mov    (%rax),%ecx
 1f95743:	jmp    1f956a5 <node_contexts_window_loop+0x1865>
 1f95748:	xor    %ecx,%ecx
 1f9574a:	jmp    1f956a5 <node_contexts_window_loop+0x1865>
 1f9574f:	mov    0x40(%rsp),%rdi
 1f95754:	vzeroupper
 1f95757:	call   1f96301 <node_contexts_sinks>
 1f9575c:	vmovdqa64 0x5c0(%rsp),%zmm10
 1f95764:	vmovdqa64 0x600(%rsp),%zmm11
 1f9576c:	vmovdqa64 0x640(%rsp),%zmm9
 1f95774:	vbroadcasti32x4 -0x19cd81e(%rip),%zmm8        # 5c7f60 <.LCPI44_39>
 1f9577e:	mov    0x10(%rsp),%r9
 1f95783:	mov    0x68(%rsp),%rsi
 1f95788:	lea    -0x19b5e7f(%rip),%r8        # 5df910 <switch.table.tier1_burs_check_function.51217+0xda18>
 1f9578f:	movzbl %al,%eax
 1f95792:	shlx   %rbx,%rax,%rax
 1f95797:	or     %rax,%r12
 1f9579a:	blsr   %r14,%r14
 1f9579f:	jne    1f956d3 <node_contexts_window_loop+0x1893>
 1f957a5:	jmp    1f957bd <node_contexts_window_loop+0x197d>
 1f957a7:	nopw   0x0(%rax,%rax,1)
 1f957b0:	mov    0x68(%rsp),%rsi
 1f957b5:	mov    0x10(%rsp),%r9
 1f957ba:	xor    %r12d,%r12d
 1f957bd:	mov    0x78(%rsp),%rdx
 1f957c2:	mov    0x340(%rsp),%r8
 1f957ca:	mov    0xa8(%rsp),%r14
 1f957d2:	kmovq  0x500(%rsp),%k0
 1f957dc:	kmovq  0x4c0(%rsp),%k1
 1f957e6:	mov    0xc0(%rsp),%r10
 1f957ee:	mov    0x80(%rsp),%r11
 1f957f6:	mov    0x400(%rsp),%r13
 1f957fe:	mov    0x48(%rsp),%rdi
 1f95803:	mov    0xe4(%rsp),%ebx
 1f9580a:	mov    $0x0,%r15d
 1f95810:	and    0xb0(%rsp),%rdx
 1f95818:	and    0x480(%rsp),%r10
 1f95820:	xor    0x300(%rsp),%r11
 1f95828:	and    %r8,0x8(%rsp)
 1f9582d:	and    %r14,0x28(%rsp)
 1f95832:	kmovq  %k1,%rcx
 1f95837:	kmovq  %k0,%rax
 1f9583c:	mov    %rdx,0x78(%rsp)
 1f95841:	mov    0x20(%rsp),%rdx
 1f95846:	and    %rax,%r13
 1f95849:	and    %rdi,%rcx
 1f9584c:	mov    $0xffffffffffffffff,%rax
 1f95853:	and    0x30(%rsp),%rdx
 1f95858:	mov    %rdx,0x20(%rsp)
 1f9585d:	mov    %ebx,%edx
 1f9585f:	sub    %r9d,%edx
 1f95862:	jbe    1f9587a <node_contexts_window_loop+0x1a3a>
 1f95864:	lea    0x40(%r9),%eax
 1f95868:	cmp    %eax,%ebx
 1f9586a:	mov    $0xffffffffffffffff,%rax
 1f95871:	shlx   %rdx,%rax,%rax
 1f95876:	cmovae %r15,%rax
 1f9587a:	vmovdqa64 0x740(%rsp),%zmm5
 1f95882:	vpcmpeqb -0x1ade5cc(%rip),%zmm10,%k0        # 4b72c0 <abi_test_hex.digits+0xbf40>
 1f9588c:	kmovq  0x140(%rsp),%k1
 1f95896:	vpandd -0x19c48dc(%rip){1to16},%zmm11,%zmm4        # 5d0fc4 <.LCPI44_62>
 1f958a0:	vpcmpeqb -0x1ade46a(%rip),%zmm10,%k2        # 4b7440 <abi_test_hex.digits+0xc0c0>
 1f958aa:	mov    0x440(%rsp),%r14
 1f958b2:	vpcmpeqb %zmm8,%zmm10,%k3
 1f958b8:	or     0x8(%rsp),%r11
 1f958bd:	vmovq  %rcx,%xmm1
 1f958c2:	mov    0x60(%rsp),%rdx
 1f958c7:	mov    0x138(%rsp),%rcx
 1f958cf:	vpmovb2m %zmm9,%k4
 1f958d5:	vmovq  %rdi,%xmm0
 1f958da:	xor    0x38(%rsp),%r14
 1f958df:	vmovq  %rcx,%xmm3
 1f958e4:	vmovq  %rdx,%xmm2
 1f958e9:	andn   %rcx,%rdx,%rcx
 1f958ee:	andn   0x30(%rsp),%r8,%rdx
 1f958f5:	or     %r14,%r11
 1f958f8:	or     0x28(%rsp),%r11
 1f958fd:	mov    $0xffffffffffffffff,%r14
 1f95904:	vpcmpeqb -0x1ade98e(%rip),%zmm5,%k3{%k3}        # 4b6f80 <abi_test_hex.digits+0xbc00>
 1f9590e:	korq   %k1,%k0,%k0
 1f95913:	kmovq  0x148(%rsp),%k1
 1f9591d:	vptestnmb %zmm4,%zmm4,%k2{%k2}
 1f95923:	vmovdqa64 0x580(%rsp),%zmm4
 1f9592b:	or     %r10,%r11
 1f9592e:	popcnt 0x50(%rsp),%r10
 1f95935:	or     %r13,%r11
 1f95938:	or     0x78(%rsp),%r11
 1f9593d:	mov    %r9,%r13
 1f95940:	kandq  %k1,%k0,%k0
 1f95945:	vptestnmb %zmm10,%zmm10,%k1
 1f9594b:	korq   %k3,%k1,%k1
 1f95950:	mov    %r10,0x10(%rsp)
 1f95955:	mov    0x90(%rsp),%r10
 1f9595d:	korq   %k4,%k1,%k1
 1f95962:	or     %rcx,%r11
 1f95965:	or     0x3c0(%rsp),%r11
 1f9596d:	movabs $0x7fffffffffffffff,%rcx
 1f95977:	korq   %k0,%k1,%k1
 1f9597c:	korq   %k2,%k1,%k1
 1f95981:	kmovq  %k1,%rdi
 1f95986:	vpmovb2m %zmm4,%k1
 1f9598c:	or     %rdx,%rdi
 1f9598f:	popcnt 0x540(%rsp),%rdx
 1f95999:	or     %rdi,%r11
 1f9599c:	kmovq  %k1,%rdi
 1f959a1:	and    %r10,%r11
 1f959a4:	mov    %r11,0x80(%rsp)
 1f959ac:	mov    %rdx,0x8(%rsp)
 1f959b1:	mov    0x20(%rsp),%rdx
 1f959b6:	andn   %rdi,%rdx,%rdi
 1f959bb:	popcnt %r12,%rdx
 1f959c0:	or     %rdi,%r8
 1f959c3:	mov    %rdx,0x20(%rsp)
 1f959c8:	andn   %r10,%r8,%r8
 1f959cd:	je     1f93f10 <node_contexts_window_loop+0xd0>
 1f959d3:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1f959e0:	xor    %r9d,%r9d
 1f959e3:	tzcnt  %r8,%r9
 1f959e8:	mov    %ebx,%edx
 1f959ea:	lea    0x0(%r13,%r9,1),%r10d
 1f959ef:	sub    0x651b8(%rsi,%r10,4),%r10d
 1f959f7:	mov    0x68(%rsp),%rsi
 1f959fc:	lea    0x1(%r10),%r10d
 1f95a00:	cmovb  %r15d,%r10d
 1f95a04:	mov    %r10d,%r11d
 1f95a07:	sub    %r13d,%r11d
 1f95a0a:	cmp    %ebx,%r10d
 1f95a0d:	cmovb  %r10d,%edx
 1f95a11:	cmp    %r13d,%r10d
 1f95a14:	shlx   %r11,%r14,%r11
 1f95a19:	cmovbe %rcx,%r11
 1f95a1d:	cmovb  %edx,%ebx
 1f95a20:	bzhi   %r9,%r11,%r9
 1f95a25:	or     %r9,%rax
 1f95a28:	blsr   %r8,%r8
 1f95a2d:	jne    1f959e0 <node_contexts_window_loop+0x1ba0>
 1f95a2f:	jmp    1f93f10 <node_contexts_window_loop+0xd0>
 1f95a34:	cmpq   $0x0,0x30(%rsp)
 1f95a3a:	mov    0x10(%rsp),%r8
 1f95a3f:	je     1f95a95 <node_contexts_window_loop+0x1c55>
 1f95a41:	mov    0x40(%rsp),%r9
 1f95a46:	mov    0xbb8(%r9),%rdi
 1f95a4d:	mov    0x30(%rsp),%r9
 1f95a52:	xor    %r10d,%r10d
 1f95a55:	tzcnt  %r9,%r10
 1f95a5a:	lea    (%r8,%r10,1),%r11d
 1f95a5e:	movzwl 0x6f654(%rsi,%r11,2),%ebx
 1f95a67:	add    %r11d,%ebx
 1f95a6a:	movzbl 0x2c(%rsi,%rbx,1),%r11d
 1f95a70:	and    $0x7f,%r11d
 1f95a74:	blsr   %r9,%r9
 1f95a79:	movzbl (%r15,%r11,1),%r11d
 1f95a7e:	mov    %r11b,0x7c0(%rsp,%r10,1)
 1f95a86:	movzbl (%rdi,%rbx,1),%r11d
 1f95a8b:	mov    %r11b,0x800(%rsp,%r10,1)
 1f95a93:	jne    1f95a52 <node_contexts_window_loop+0x1c12>
 1f95a95:	kmovq  %k2,%rdi
 1f95a9a:	mov    %rdi,%r9
 1f95a9d:	test   %rdi,%rdi
 1f95aa0:	je     1f95b14 <node_contexts_window_loop+0x1cd4>
 1f95aa2:	xor    %r10d,%r10d
 1f95aa5:	tzcnt  %r9,%r10
 1f95aaa:	lea    (%r8,%r10,1),%r11d
 1f95aae:	movzwl 0x6b554(%rsi,%r11,2),%ebx
 1f95ab7:	sub    %ebx,%r11d
 1f95aba:	movzbl 0x2c(%rsi,%r11,1),%ebx
 1f95ac0:	and    $0x7f,%bl
 1f95ac3:	blsr   %r9,%r9
 1f95ac8:	mov    %bl,0x840(%rsp,%r10,1)
 1f95ad0:	movzbl (%rax,%r11,1),%ebx
 1f95ad5:	mov    %bl,0x880(%rsp,%r10,1)
 1f95add:	movzbl (%rcx,%r11,1),%ebx
 1f95ae2:	mov    %bl,0x8c0(%rsp,%r10,1)
 1f95aea:	movzbl (%rdx,%r11,1),%ebx
 1f95aef:	mov    %bl,0x900(%rsp,%r10,1)
 1f95af7:	movzbl (%r14,%r11,1),%ebx
 1f95afc:	mov    %bl,0x940(%rsp,%r10,1)
 1f95b04:	movzbl 0x0(%r13,%r11,1),%r11d
 1f95b0a:	mov    %r11b,0x980(%rsp,%r10,1)
 1f95b12:	jne    1f95aa2 <node_contexts_window_loop+0x1c62>
 1f95b14:	kmovq  0xf0(%rsp),%k3
 1f95b1e:	vmovdqu8 0x840(%rsp),%zmm19{%k2}
 1f95b26:	vmovdqu8 0x880(%rsp),%zmm25{%k2}
 1f95b2e:	vmovdqu8 0x8c0(%rsp),%zmm20{%k2}
 1f95b36:	vmovdqu8 0x900(%rsp),%zmm3{%k2}
 1f95b3e:	vmovdqu8 0x940(%rsp),%zmm18{%k2}
 1f95b46:	vmovdqu8 0x980(%rsp),%zmm21{%k2}
 1f95b4e:	popcnt 0x30(%rsp),%rax
 1f95b55:	or     %rdi,0x20(%rsp)
 1f95b5a:	popcnt %rdi,%rcx
 1f95b5f:	add    0xc8(%rsp),%rax
 1f95b67:	vmovdqu8 0x7c0(%rsp),%zmm22{%k3}
 1f95b6f:	add    %rcx,%rax
 1f95b72:	mov    %rax,0xc8(%rsp)
 1f95b7a:	jmp    1f94307 <node_contexts_window_loop+0x4c7>
 1f95b7f:	andn   %rax,%r14,%rax
 1f95b84:	mov    0x40(%rsp),%r13
 1f95b89:	mov    0x20(%rsp),%rdi
 1f95b8e:	mov    %rax,0x70(%rsp)
 1f95b93:	mov    0x88(%rsp),%rax
 1f95b9b:	jmp    1f94ab8 <node_contexts_window_loop+0xc78>
 1f95ba0:	mov    %rdx,%rdi
 1f95ba3:	movq   $0x0,0x70(%rsp)
 1f95bac:	jmp    1f94ab8 <node_contexts_window_loop+0xc78>
 1f95bb1:	vmovq  0xc8(%rsp),%xmm0
 1f95bba:	mov    0x118(%rsp),%rcx
 1f95bc2:	mov    0x58(%rsp),%rdx
 1f95bc7:	mov    0xe8(%rsp),%rsi
 1f95bcf:	vmovq  %r12,%xmm1
 1f95bd4:	vpunpcklqdq %xmm0,%xmm1,%xmm0
 1f95bd8:	lea    -0x28(%rbp),%rsp
 1f95bdc:	pop    %rbx
 1f95bdd:	pop    %r12
 1f95bdf:	pop    %r13
 1f95be1:	pop    %r14
 1f95be3:	pop    %r15
 1f95be5:	pop    %rbp
 1f95be6:	vmovq  %rsi,%xmm1
 1f95beb:	vmovq  %rdx,%xmm2
 1f95bf0:	vpunpcklqdq %xmm1,%xmm2,%xmm1
 1f95bf4:	vinserti128 $0x1,%xmm0,%ymm1,%ymm0
 1f95bfa:	vmovq  %r10,%xmm1
 1f95bff:	vinserti64x4 $0x1,%ymm3,%zmm0,%zmm0
 1f95c06:	vpaddq (%rcx),%zmm0,%zmm0
 1f95c0c:	vmovdqu64 %zmm0,(%rcx)
 1f95c12:	vmovq  %r8,%xmm0
 1f95c17:	vpunpcklqdq %xmm0,%xmm1,%xmm0
 1f95c1b:	vpaddq 0x40(%rcx),%xmm0,%xmm0
 1f95c20:	vmovdqu %xmm0,0x40(%rcx)
 1f95c25:	add    %rax,0x50(%rcx)
 1f95c29:	vzeroupper
 1f95c2c:	ret

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .iplt:
