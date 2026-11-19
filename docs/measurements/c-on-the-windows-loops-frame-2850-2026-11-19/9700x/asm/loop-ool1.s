compiler:     file format elf64-x86-64
Disassembly of section .text.buster_start:
Disassembly of section .text.buster_checker:
Disassembly of section .text:
0000000001f80e00 <node_contexts_window_loop>:
 1f80e00:	push   %rbp
 1f80e01:	mov    %rsp,%rbp
 1f80e04:	push   %r15
 1f80e06:	push   %r14
 1f80e08:	push   %r13
 1f80e0a:	push   %r12
 1f80e0c:	push   %rbx
 1f80e0d:	and    $0xffffffffffffffc0,%rsp
 1f80e11:	sub    $0xb80,%rsp
 1f80e18:	mov    0xb38(%rdi),%r14
 1f80e1f:	movq   $0x0,0xc0(%rsp)
 1f80e2b:	add    $0x3f,%edx
 1f80e2e:	vpxor  %xmm0,%xmm0,%xmm0
 1f80e32:	mov    (%rdi),%rax
 1f80e35:	mov    0x8(%rax),%rax
 1f80e39:	movzbl 0x14a(%rax),%eax
 1f80e40:	vmovdqa64 %zmm0,0x9c0(%rsp)
 1f80e48:	vmovdqa64 %zmm0,0x980(%rsp)
 1f80e50:	vmovdqa64 %zmm0,0x940(%rsp)
 1f80e58:	vmovdqa64 %zmm0,0x900(%rsp)
 1f80e60:	vmovdqa64 %zmm0,0x8c0(%rsp)
 1f80e68:	vmovdqa64 %zmm0,0x880(%rsp)
 1f80e70:	vmovdqa64 %zmm0,0x840(%rsp)
 1f80e78:	vmovdqa64 %zmm0,0x800(%rsp)
 1f80e80:	mov    %al,0x17(%rsp)
 1f80e84:	cmp    $0x40,%edx
 1f80e87:	jb     1f82380 <node_contexts_window_loop+0x1580>
 1f80e8d:	mov    0xb90(%rdi),%r9
 1f80e94:	mov    0xb98(%rdi),%r10
 1f80e9b:	mov    %edx,%r12d
 1f80e9e:	and    $0xffffffc0,%r12d
 1f80ea2:	mov    %rcx,0xc8(%rsp)
 1f80eaa:	vmovdqa64 0x4fc37cc(%rip),%zmm3        # 6f44680 <node_views_x>
 1f80eb4:	vmovdqa64 0x4fc3842(%rip),%zmm4        # 6f44700 <node_views_x+0x80>
 1f80ebe:	mov    %rsi,%r15
 1f80ec1:	mov    0xb80(%rdi),%rsi
 1f80ec8:	vmovdqu64 (%r14),%zmm7
 1f80ece:	mov    0xb88(%rdi),%r8
 1f80ed5:	vmovdqa64 0x4fc37e1(%rip),%zmm5        # 6f446c0 <node_views_x+0x40>
 1f80edf:	mov    0xba8(%rdi),%rax
 1f80ee6:	mov    0xba0(%rdi),%r11
 1f80eed:	vbroadcasti32x4 -0x19d8487(%rip),%zmm6        # 5a8a70 <.LCPI0_35>
 1f80ef7:	vbroadcasti32x4 -0x19d8481(%rip),%zmm11        # 5a8a80 <.LCPI0_36>
 1f80f01:	vbroadcasti32x4 -0x19d847b(%rip),%zmm12        # 5a8a90 <.LCPI0_37>
 1f80f0b:	shr    $0x6,%edx
 1f80f0e:	mov    %rdi,0x38(%rsp)
 1f80f13:	vpxor  %xmm8,%xmm8,%xmm8
 1f80f18:	movq   $0x0,0x48(%rsp)
 1f80f21:	vpxor  %xmm15,%xmm15,%xmm15
 1f80f26:	mov    %r15,0x90(%rsp)
 1f80f2e:	mov    %r14,0xb0(%rsp)
 1f80f36:	lea    -0x40(%r12),%ecx
 1f80f3b:	vmovdqu64 0x2c(%r15,%rcx,1),%zmm0
 1f80f46:	vmovdqu64 (%r9,%rcx,1),%zmm1
 1f80f4d:	vmovdqu64 (%r10,%rcx,1),%zmm2
 1f80f54:	mov    %rax,0xe8(%rsp)
 1f80f5c:	mov    0xbb0(%rdi),%rax
 1f80f63:	mov    %rsi,0x110(%rsp)
 1f80f6b:	mov    %r8,0x108(%rsp)
 1f80f73:	mov    %r10,0xf8(%rsp)
 1f80f7b:	mov    %r9,0x100(%rsp)
 1f80f83:	mov    %r11,0xf0(%rsp)
 1f80f8b:	xor    %r10d,%r10d
 1f80f8e:	vmovdqa64 %zmm4,0x640(%rsp)
 1f80f96:	vmovdqa64 %zmm5,0x680(%rsp)
 1f80f9e:	vmovdqa64 %zmm3,0x6c0(%rsp)
 1f80fa6:	vpermt2b 0x40(%r14),%zmm0,%zmm7
 1f80fad:	vmovdqu64 (%rsi,%rcx,1),%zmm0
 1f80fb4:	mov    %rax,0xe0(%rsp)
 1f80fbc:	mov    0xbb8(%rdi),%rax
 1f80fc3:	mov    $0x40,%esi
 1f80fc8:	sub    %r12d,%esi
 1f80fcb:	vpermb %zmm3,%zmm1,%zmm9
 1f80fd1:	vpermb %zmm4,%zmm2,%zmm1
 1f80fd7:	vpbroadcastq -0x19d2229(%rip),%zmm4        # 5aedb8 <.LCPI0_0>
 1f80fe1:	vpxor  %xmm3,%xmm3,%xmm3
 1f80fe5:	mov    %rax,0xd8(%rsp)
 1f80fed:	mov    0xbc0(%rdi),%rax
 1f80ff4:	vpermb %zmm5,%zmm0,%zmm0
 1f80ffa:	vmovdqa64 0x4fc373c(%rip),%zmm5        # 6f44740 <node_views_x+0xc0>
 1f81004:	mov    %rax,0xd0(%rsp)
 1f8100c:	mov    0xbd0(%rdi),%rax
 1f81013:	vpternlogq $0xf8,(%r8,%rcx,1),%zmm4,%zmm9
 1f8101b:	mov    $0xffffffff,%r8d
 1f81021:	vpermb %zmm5,%zmm7,%zmm10
 1f81027:	vmovdqa64 %zmm5,0x600(%rsp)
 1f8102f:	vpternlogq $0xfe,%zmm1,%zmm0,%zmm9
 1f81036:	vpbroadcastq -0x19d2280(%rip),%zmm0        # 5aedc0 <.LCPI0_1>
 1f81040:	vpternlogq $0xf8,(%r11,%rcx,1),%zmm0,%zmm10
 1f81048:	lea    -0x1(%rdx),%ecx
 1f8104b:	vpxor  %xmm0,%xmm0,%xmm0
 1f8104f:	xor    %r11d,%r11d
 1f81052:	shl    $0x6,%rcx
 1f81056:	lea    0x20(%rcx,%rax,1),%rdi
 1f8105b:	jmp    1f8130e <node_contexts_window_loop+0x50e>
 1f81060:	kmovq  0x60(%rsp),%k0
 1f81067:	mov    0x240(%rsp),%r11
 1f8106f:	vpmovb2m %zmm1,%k1
 1f81075:	popcnt 0x130(%rsp),%r14
 1f8107f:	popcnt 0x5c0(%rsp),%r10
 1f81089:	mov    0x90(%rsp),%r15
 1f81091:	kmovq  %k0,%rcx
 1f81096:	vptestmb %zmm11,%zmm9,%k0
 1f8109c:	and    %r11,0x1c0(%rsp)
 1f810a4:	kmovq  %k0,%rdx
 1f810a9:	kmovq  0x68(%rsp),%k0
 1f810b0:	and    %rcx,%rbx
 1f810b3:	kmovq  %k1,%rcx
 1f810b8:	and    %rdx,%r13
 1f810bb:	mov    0x70(%rsp),%rdx
 1f810c0:	and    0x280(%rsp),%rdx
 1f810c8:	kmovq  %k0,%rdi
 1f810cd:	xor    %rdi,0x20(%rsp)
 1f810d2:	andn   %rcx,%rdx,%r9
 1f810d7:	mov    %r9,%rcx
 1f810da:	or     %r11,%rcx
 1f810dd:	andn   0x40(%rsp),%rcx,%rdx
 1f810e4:	je     1f819c0 <node_contexts_window_loop+0xbc0>
 1f810ea:	mov    %r15,%rdi
 1f810ed:	mov    %rax,%rcx
 1f810f0:	mov    %rsi,%r12
 1f810f3:	vmovdqa64 %zmm14,0x380(%rsp)
 1f810fb:	vmovdqa64 %zmm16,0x2c0(%rsp)
 1f81103:	call   1f83000 <node_contexts_x_dead>
 1f81108:	vmovdqa64 0x2c0(%rsp),%zmm16
 1f81110:	vmovdqa64 0x380(%rsp),%zmm14
 1f81118:	vmovdqa64 0x300(%rsp),%zmm13
 1f81120:	vmovdqa64 0x480(%rsp),%zmm8
 1f81128:	vmovdqa64 0x4c0(%rsp),%zmm7
 1f81130:	vbroadcasti32x4 -0x19d86ba(%rip),%zmm11        # 5a8a80 <.LCPI0_36>
 1f8113a:	vmovdqa64 0x740(%rsp),%zmm9
 1f81142:	vmovdqa64 0x700(%rsp),%zmm10
 1f8114a:	kmovq  0x30(%rsp),%k7
 1f81151:	mov    0xa0(%rsp),%rdi
 1f81159:	mov    %rdx,%r8
 1f8115c:	vbroadcasti32x4 -0x19d86d6(%rip),%zmm12        # 5a8a90 <.LCPI0_37>
 1f81166:	mov    0x160(%rsp),%rcx
 1f8116e:	kmovq  0x78(%rsp),%k0
 1f81175:	kmovq  0x140(%rsp),%k2
 1f8117f:	vpaddb -0x1acea09(%rip),%zmm13,%zmm3        # 4b2780 <abi_test_hex.digits+0xba80>
 1f81189:	vbroadcasti32x4 -0x19d8723(%rip),%zmm6        # 5a8a70 <.LCPI0_35>
 1f81193:	mov    0x168(%rsp),%r11
 1f8119b:	mov    0x340(%rsp),%rdx
 1f811a3:	vpcmpeqb %zmm11,%zmm13,%k3
 1f811a9:	mov    0x18(%rsp),%rsi
 1f811ae:	vpmovb2m %zmm7,%k4
 1f811b4:	vmovdqa64 %zmm16,%zmm15
 1f811ba:	vpcmpltub -0x1ace945(%rip),%zmm3,%k1        # 4b2880 <abi_test_hex.digits+0xbb80>
 1f811c5:	vpandd -0x19cf9af(%rip){1to16},%zmm8,%zmm3        # 5b1820 <.LCPI0_38>
 1f811cf:	vpxor  %xmm8,%xmm8,%xmm8
 1f811d4:	add    %r10,%rcx
 1f811d7:	add    %r14,%r11
 1f811da:	mov    0x40(%rsp),%r14
 1f811df:	vmovq  %rsi,%xmm4
 1f811e4:	mov    %rcx,%r10
 1f811e7:	kmovq  %k0,%rcx
 1f811ec:	vpcmpeqb %zmm12,%zmm13,%k0
 1f811f2:	vpcmpeqb 0xb00(%rsp),%zmm6,%k3{%k3}
 1f811fa:	korq   %k2,%k0,%k0
 1f811ff:	kmovq  0x150(%rsp),%k2
 1f81209:	and    %r14,%rdx
 1f8120c:	andn   %r14,%rax,%rax
 1f81211:	and    %rdx,%rcx
 1f81214:	vmovq  %rdx,%xmm1
 1f81219:	mov    0x148(%rsp),%rdx
 1f81221:	and    %r9,%rax
 1f81224:	vmovq  %rcx,%xmm2
 1f81229:	mov    0x240(%rsp),%rcx
 1f81231:	mov    %rax,-0x20(%rdi)
 1f81235:	andn   0x280(%rsp),%rcx,%rcx
 1f8123f:	vpunpcklqdq %xmm2,%xmm1,%xmm1
 1f81243:	kandq  %k2,%k0,%k0
 1f81248:	vpcmpeqb -0x1acee52(%rip),%zmm13,%k2        # 4b2400 <abi_test_hex.digits+0xb700>
 1f81252:	vmovq  %rdx,%xmm5
 1f81257:	andn   %rdx,%rsi,%rdx
 1f8125c:	vpunpcklqdq %xmm4,%xmm5,%xmm2
 1f81260:	vinserti128 $0x1,%xmm1,%ymm2,%ymm1
 1f81266:	vpopcntq %ymm1,%ymm1
 1f8126c:	vpaddq %ymm0,%ymm1,%ymm0
 1f81270:	vptestnmb %zmm3,%zmm3,%k2{%k2}
 1f81276:	vmovdqa64 0x7c0(%rsp),%zmm3
 1f8127e:	korq   %k2,%k1,%k1
 1f81283:	korq   %k4,%k1,%k1
 1f81288:	korq   %k3,%k1,%k1
 1f8128d:	korq   %k0,%k1,%k1
 1f81292:	kandq  %k7,%k0,%k0
 1f81297:	kmovq  %k1,%rsi
 1f8129c:	vptestnmb %zmm14,%zmm14,%k1
 1f812a2:	or     %rcx,%rsi
 1f812a5:	kmovq  %k1,%rcx
 1f812aa:	vpcmpgtb %zmm7,%zmm8,%k1{%k7}
 1f812b0:	vmovdqa64 0xac0(%rsp),%zmm7
 1f812b8:	or     %r13,%rsi
 1f812bb:	or     0x1c0(%rsp),%rsi
 1f812c3:	and    %rax,%rcx
 1f812c6:	or     0x20(%rsp),%rsi
 1f812cb:	mov    %rcx,-0x18(%rdi)
 1f812cf:	or     %rbx,%rsi
 1f812d2:	or     %rdx,%rsi
 1f812d5:	mov    0x178(%rsp),%rdx
 1f812dd:	and    %r14,%rsi
 1f812e0:	mov    0xb0(%rsp),%r14
 1f812e8:	mov    %rsi,-0x10(%rdi)
 1f812ec:	mov    0xb8(%rsp),%rsi
 1f812f4:	kmovq  %k0,-0x8(%rdi)
 1f812fa:	kmovq  %k1,(%rdi)
 1f812ff:	add    $0xffffffffffffffc0,%rdi
 1f81303:	add    $0x40,%esi
 1f81306:	dec    %edx
 1f81308:	je     1f8234a <node_contexts_window_loop+0x154a>
 1f8130e:	mov    0x100(%rsp),%r13
 1f81316:	mov    %r11,0x168(%rsp)
 1f8131e:	lea    -0x40(%r12),%r11d
 1f81323:	vmovdqa64 %zmm9,%zmm1
 1f81329:	vmovdqa64 %zmm10,%zmm2
 1f8132f:	mov    0xf0(%rsp),%r9
 1f81337:	vmovdqa64 %zmm7,%zmm21
 1f8133d:	lea    -0x80(%r12),%eax
 1f81342:	cmp    $0x1,%edx
 1f81345:	mov    $0x0,%ecx
 1f8134a:	vmovdqu64 (%r14),%zmm22
 1f81350:	vmovdqu64 0x40(%r14),%zmm23
 1f81357:	vpbroadcastq -0x19d25a9(%rip),%zmm24        # 5aedb8 <.LCPI0_0>
 1f81361:	mov    %r8,0x170(%rsp)
 1f81369:	mov    %rdx,0x178(%rsp)
 1f81371:	mov    0x110(%rsp),%rdx
 1f81379:	mov    0xf8(%rsp),%r8
 1f81381:	mov    %rsi,0xb8(%rsp)
 1f81389:	mov    0x108(%rsp),%rsi
 1f81391:	mov    %rdi,0xa0(%rsp)
 1f81399:	vmovdqa64 %zmm7,0x7c0(%rsp)
 1f813a1:	mov    %r10,0x160(%rsp)
 1f813a9:	mov    %r12,0x120(%rsp)
 1f813b1:	vmovdqu64 0x6f654(%r15,%r11,2),%zmm5
 1f813bc:	vmovdqu64 0x196ac(%r15,%r11,1),%zmm9
 1f813c7:	cmove  %ecx,%eax
 1f813ca:	mov    %r11,0x18(%rsp)
 1f813cf:	vmovups 0x0(%r13,%r11,1),%zmm4
 1f813d7:	vmovdqu64 (%r9,%r11,1),%zmm14
 1f813de:	vmovdqu64 (%rdx,%r11,1),%zmm19
 1f813e5:	vmovdqu64 (%rsi,%r11,1),%zmm20
 1f813ec:	vmovdqu64 (%r8,%r11,1),%zmm13
 1f813f3:	vptestmb %zmm9,%zmm9,%k1
 1f813f9:	vmovdqa64 -0x1acf283(%rip),%zmm9        # 4b2180 <abi_test_hex.digits+0xb480>
 1f81403:	vmovaps %zmm4,0xb00(%rsp)
 1f8140b:	vpmovuswb %zmm5,%ymm4
 1f81411:	vmovdqu64 0x6f694(%r15,%r11,2),%zmm5
 1f8141c:	vmovdqa64 %zmm13,0x4c0(%rsp)
 1f81424:	vmovdqa64 %zmm14,0x480(%rsp)
 1f8142c:	vmovdqa64 %zmm19,0x1c0(%rsp)
 1f81434:	vmovdqa64 %zmm20,0x240(%rsp)
 1f8143c:	vpmovuswb %zmm5,%ymm5
 1f81442:	vinserti64x4 $0x1,%ymm5,%zmm4,%zmm4
 1f81449:	vpaddb -0x1acf293(%rip),%zmm4,%zmm10        # 4b21c0 <abi_test_hex.digits+0xb4c0>
 1f81453:	vmovdqu64 0x6b594(%r15,%r11,2),%zmm5
 1f8145e:	vpcmpleub %zmm9,%zmm4,%k2{%k1}
 1f81465:	kmovq  %k2,0x158(%rsp)
 1f8146f:	vpermt2b %zmm3,%zmm10,%zmm21{%k2}{z}
 1f81475:	vmovdqa64 %zmm10,0xa80(%rsp)
 1f8147d:	vmovdqu64 0x6b554(%r15,%r11,2),%zmm10
 1f81488:	vpmovuswb %zmm5,%ymm5
 1f8148e:	vpandd -0x19cfc74(%rip){1to16},%zmm21,%zmm17        # 5b1824 <.LCPI0_39>
 1f81498:	vpmovuswb %zmm10,%ymm3
 1f8149e:	vpandq %zmm6,%zmm14,%zmm10
 1f814a4:	vmovdqu64 0x6d5d4(%r15,%r11,2),%zmm6
 1f814af:	vmovdqa64 %zmm17,0x780(%rsp)
 1f814b7:	vptestmb %zmm10,%zmm10,%k7
 1f814bd:	vmovdqa64 -0x1acf247(%rip),%zmm10        # 4b2280 <abi_test_hex.digits+0xb580>
 1f814c7:	kandq  %k7,%k1,%k1
 1f814cc:	kmovq  %k7,0x30(%rsp)
 1f814d3:	vpcmpnleub %zmm9,%zmm4,%k4{%k1}
 1f814da:	vmovdqu64 0x2c(%r15,%rax,1),%zmm9
 1f814e5:	vmovdqu64 0x0(%r13,%rax,1),%zmm4
 1f814ed:	vpermb 0x6c0(%rsp),%zmm4,%zmm25
 1f814f5:	kmovq  %k4,0xa8(%rsp)
 1f814ff:	vinserti64x4 $0x1,%ymm5,%zmm3,%zmm3
 1f81506:	vpternlogq $0xf8,(%rsi,%rax,1),%zmm24,%zmm25
 1f8150e:	vptestmb %zmm3,%zmm3,%k0
 1f81514:	kandq  %k0,%k7,%k3
 1f81519:	kmovq  %k0,%rcx
 1f8151e:	vpmovuswb %zmm6,%ymm5
 1f81524:	vmovdqu64 0x6d614(%r15,%r11,2),%zmm6
 1f8152f:	vpcmpnltub %zmm3,%zmm10,%k0
 1f81536:	vpsubb %zmm3,%zmm10,%zmm16
 1f8153c:	vpcmpltub %zmm3,%zmm10,%k3{%k3}
 1f81543:	vmovdqu64 (%rdx,%rax,1),%zmm3
 1f8154a:	vpermb 0x680(%rsp),%zmm3,%zmm3
 1f81552:	kmovq  %k0,%rbx
 1f81557:	vpermi2b %zmm23,%zmm22,%zmm9
 1f8155d:	and    %rcx,%rbx
 1f81560:	kmovq  %k7,%rcx
 1f81565:	kortestq %k4,%k3
 1f8156a:	kmovq  %rbx,%k1
 1f8156f:	mov    %rcx,0x40(%rsp)
 1f81574:	vpmovuswb %zmm6,%ymm6
 1f8157a:	vmovdqa64 %zmm9,0xac0(%rsp)
 1f81582:	vpermb 0x600(%rsp),%zmm9,%zmm9
 1f8158a:	vinserti64x4 $0x1,%ymm6,%zmm5,%zmm5
 1f81591:	vpcmpltub -0x1acf2dc(%rip),%zmm5,%k2        # 4b22c0 <abi_test_hex.digits+0xb5c0>
 1f8159c:	vpsubb %zmm5,%zmm10,%zmm18
 1f815a2:	vpbroadcastq -0x19d27ec(%rip),%zmm10        # 5aedc0 <.LCPI0_1>
 1f815ac:	vptestmb %zmm5,%zmm5,%k2{%k2}
 1f815b2:	vmovdqu64 (%r8,%rax,1),%zmm5
 1f815b9:	vpermb 0x640(%rsp),%zmm5,%zmm5
 1f815c1:	vpternlogq $0xf8,(%r9,%rax,1),%zmm10,%zmm9
 1f815c9:	vpternlogq $0xfe,%zmm5,%zmm3,%zmm25
 1f815d0:	vmovdqa64 %zmm9,0x700(%rsp)
 1f815d8:	vmovdqa64 %zmm25,%zmm10
 1f815de:	vpermt2b %zmm1,%zmm16,%zmm10{%k1}{z}
 1f815e4:	vpermi2b %zmm1,%zmm25,%zmm18{%k2}{z}
 1f815ea:	vpermi2b %zmm2,%zmm9,%zmm16{%k1}{z}
 1f815f0:	vmovdqa64 %zmm25,0x740(%rsp)
 1f815f8:	vmovdqa64 %zmm18,0x280(%rsp)
 1f81600:	jne    1f820a8 <node_contexts_window_loop+0x12a8>
 1f81606:	mov    %rbx,0x20(%rsp)
 1f8160b:	vmovdqu64 0x1a72c(%r15,%r11,1),%zmm1
 1f81616:	vbroadcasti32x4 -0x19d8b80(%rip),%zmm4        # 5a8aa0 <.LCPI0_40>
 1f81620:	vpandd -0x19cfe02(%rip){1to16},%zmm13,%zmm2        # 5b1828 <.LCPI0_41>
 1f8162a:	vbroadcasti32x4 -0x19d8b84(%rip),%zmm3        # 5a8ab0 <.LCPI0_42>
 1f81634:	vbroadcasti32x4 -0x19d8b7e(%rip),%zmm6        # 5a8ac0 <.LCPI0_43>
 1f8163e:	vbroadcasti32x4 -0x19d8b78(%rip),%zmm5        # 5a8ad0 <.LCPI0_44>
 1f81648:	vmovdqa64 %zmm16,0x2c0(%rsp)
 1f81650:	vptestnmb %zmm1,%zmm1,%k1
 1f81656:	vptestnmb %zmm2,%zmm2,%k2
 1f8165c:	vpcmpeqb %zmm3,%zmm2,%k5
 1f81662:	vpandd -0x19cfe40(%rip){1to16},%zmm13,%zmm2        # 5b182c <.LCPI0_45>
 1f8166c:	vmovdqa64 %zmm1,0xa40(%rsp)
 1f81674:	vpternlogd $0xff,%zmm1,%zmm1,%zmm1
 1f8167b:	vpandq -0x19d28bd(%rip){1to8},%zmm7,%zmm13        # 5aedc8 <.LCPI0_24>
 1f81685:	vptestmb %zmm6,%zmm18,%k3
 1f8168b:	kmovq  %k1,0x340(%rsp)
 1f81695:	vpcmpgtb %zmm21,%zmm8,%k1{%k1}
 1f8169b:	vpandq %zmm4,%zmm10,%zmm8
 1f816a1:	kmovq  %k2,%rcx
 1f816a6:	vpaddb %zmm1,%zmm19,%zmm1
 1f816ac:	kmovq  %k3,0x150(%rsp)
 1f816b6:	kmovq  %k5,0x78(%rsp)
 1f816bd:	vptestmb %zmm8,%zmm8,%k0
 1f816c3:	kmovq  %k0,%r12
 1f816c8:	vptestmb -0x1acf152(%rip),%zmm20,%k0        # 4b2580 <abi_test_hex.digits+0xb880>
 1f816d2:	mov    %r12,0x138(%rsp)
 1f816da:	vptestmb %zmm2,%zmm2,%k2
 1f816e0:	vpcmpeqb %zmm12,%zmm2,%k4
 1f816e6:	vmovdqa64 %zmm2,0x400(%rsp)
 1f816ee:	vmovdqu8 %zmm3,%zmm2{%k1}{z}
 1f816f4:	vpandq %zmm5,%zmm10,%zmm3
 1f816fa:	vmovdqa64 %zmm13,0x300(%rsp)
 1f81702:	kmovq  %k2,%rdx
 1f81707:	knotq  %k1,%k2
 1f8170c:	kmovq  %k4,0x80(%rsp)
 1f81716:	vmovdqa64 %zmm3,0x500(%rsp)
 1f8171e:	kmovq  %k2,%r14
 1f81723:	kmovq  %k0,%rax
 1f81728:	vptestmb %zmm6,%zmm20,%k0
 1f8172e:	and    %r14,%rcx
 1f81731:	mov    %r14,0x380(%rsp)
 1f81739:	korq   %k1,%k0,%k2
 1f8173e:	kandq  %k4,%k2,%k0
 1f81743:	vpcmpltub %zmm4,%zmm1,%k4
 1f8174a:	kmovq  %k2,0x68(%rsp)
 1f81751:	kmovq  %k0,%rsi
 1f81756:	vptestmb %zmm5,%zmm20,%k0{%k5}
 1f8175c:	kmovq  %k4,0x28(%rsp)
 1f81763:	or     %rcx,%rsi
 1f81766:	mov    0x18(%rsp),%rcx
 1f8176b:	and    %rdx,%rsi
 1f8176e:	kmovq  %k0,%r9
 1f81773:	vptestmb %zmm5,%zmm7,%k0{%k4}
 1f81779:	vpandd -0x19cff63(%rip){1to16},%zmm7,%zmm7        # 5b1820 <.LCPI0_38>
 1f81783:	vpandq %zmm11,%zmm18,%zmm5
 1f81789:	and    %r14,%r9
 1f8178c:	or     %rax,%r9
 1f8178f:	mov    0xe0(%rsp),%rax
 1f81797:	kmovq  %k0,0x140(%rsp)
 1f817a1:	kandq  %k3,%k0,%k0
 1f817a6:	vpcmpltub -0x1acf1f1(%rip),%zmm1,%k3        # 4b25c0 <abi_test_hex.digits+0xb8c0>
 1f817b1:	vpandd -0x19cff8b(%rip){1to16},%zmm16,%zmm1        # 5b1830 <.LCPI0_46>
 1f817bb:	knotq  %k0,%k0
 1f817c0:	vpcmpeqb -0x1acef8a(%rip),%zmm1,%k1        # 4b2840 <abi_test_hex.digits+0xbb40>
 1f817ca:	vmovdqa64 %zmm8,%zmm1
 1f817d0:	kmovq  %k0,%rdi
 1f817d5:	vpcmpeqb -0x1acf1df(%rip),%zmm13,%k0{%k3}        # 4b2600 <abi_test_hex.digits+0xb900>
 1f817df:	vmovdqu64 %zmm2,(%rax,%rcx,1)
 1f817e6:	kmovq  %k2,%rcx
 1f817eb:	vpternlogq $0xfe,%zmm7,%zmm5,%zmm1
 1f817f2:	vmovdqa64 %zmm7,0x580(%rsp)
 1f817fa:	mov    %rcx,0x58(%rsp)
 1f817ff:	kmovq  %k3,0x60(%rsp)
 1f81806:	kmovq  %k0,%r15
 1f8180b:	vptestmb %zmm3,%zmm3,%k0
 1f81811:	vbroadcasti32x4 -0x19d8d3b(%rip),%zmm3        # 5a8ae0 <.LCPI0_47>
 1f8181b:	korq   %k0,%k1,%k0
 1f81820:	vpcmpeqb %zmm6,%zmm13,%k1
 1f81826:	and    %rdi,%r15
 1f81829:	knotq  %k0,%k0
 1f8182e:	kmovq  %k0,%r8
 1f81833:	vptestmb %zmm1,%zmm1,%k0
 1f81839:	vpandq %zmm11,%zmm14,%zmm1
 1f8183f:	kmovq  %k0,%r13
 1f81844:	vmovdqa64 %zmm1,0x540(%rsp)
 1f8184c:	and    %r8,%r13
 1f8184f:	vpcmpeqb %zmm3,%zmm13,%k0
 1f81855:	korq   %k0,%k1,%k0
 1f8185a:	kmovq  %k0,%r11
 1f8185f:	vpcmpneqb %zmm3,%zmm13,%k0
 1f81866:	vpandq %zmm4,%zmm18,%zmm3
 1f8186c:	kmovq  %k0,%r10
 1f81871:	vporq  %zmm1,%zmm3,%zmm1
 1f81877:	mov    %r10,%rdx
 1f8187a:	kmovq  %k3,%r10
 1f8187f:	vptestnmb %zmm1,%zmm1,%k0
 1f81885:	vpsllw $0x7,%zmm14,%zmm1
 1f8188c:	or     %r10,%rdx
 1f8188f:	kmovq  %k0,%rbx
 1f81894:	vpmovb2m %zmm1,%k0
 1f8189a:	or     %rcx,%rdx
 1f8189d:	and    0x40(%rsp),%rdx
 1f818a2:	kmovq  %k0,%rax
 1f818a7:	and    %r11,%rbx
 1f818aa:	kmovq  %k0,0x70(%rsp)
 1f818b1:	andn   %rsi,%rax,%rdi
 1f818b6:	mov    %rax,0x128(%rsp)
 1f818be:	mov    %r9,%rax
 1f818c1:	not    %rax
 1f818c4:	mov    0x18(%rsp),%rsi
 1f818c9:	andn   %rax,%rdi,%r14
 1f818ce:	mov    0xd0(%rsp),%rax
 1f818d6:	mov    %rdi,0x50(%rsp)
 1f818db:	and    %r14,%r15
 1f818de:	and    %r15,%r13
 1f818e1:	mov    %r15,0x148(%rsp)
 1f818e9:	and    %r14,%rdx
 1f818ec:	mov    %r13,0x88(%rsp)
 1f818f4:	and    %rbx,%rdx
 1f818f7:	or     %r13,%rdx
 1f818fa:	vmovdqu64 %zmm13,(%rax,%rsi,1)
 1f81901:	and    %r12,%rdx
 1f81904:	mov    %rdx,0x130(%rsp)
 1f8190c:	je     1f819e0 <node_contexts_window_loop+0xbe0>
 1f81912:	mov    0x38(%rsp),%rdi
 1f81917:	lea    0xc0(%rsp),%rcx
 1f8191f:	vmovdqa64 %zmm15,0x200(%rsp)
 1f81927:	vmovdqa64 %zmm10,0x180(%rsp)
 1f8192f:	vmovdqa64 %zmm17,0x3c0(%rsp)
 1f81937:	vmovdqa64 %zmm8,0x5c0(%rsp)
 1f8193f:	vmovdqa64 %zmm5,0x440(%rsp)
 1f81947:	kmovq  %k1,0x118(%rsp)
 1f81951:	vmovdqa64 %zmm3,0xa00(%rsp)
 1f81959:	call   1f82aa0 <node_contexts_x_strides>
 1f8195e:	vmovdqa64 0xa00(%rsp),%zmm3
 1f81966:	vmovdqa64 0x440(%rsp),%zmm5
 1f8196e:	vmovdqa64 0x5c0(%rsp),%zmm8
 1f81976:	vmovdqa64 0x3c0(%rsp),%zmm17
 1f8197e:	vmovdqa64 0x180(%rsp),%zmm10
 1f81986:	vmovdqa64 0x300(%rsp),%zmm13
 1f8198e:	vmovdqa64 0x200(%rsp),%zmm15
 1f81996:	vbroadcasti32x4 -0x19d8f20(%rip),%zmm11        # 5a8a80 <.LCPI0_36>
 1f819a0:	kmovq  0x118(%rsp),%k1
 1f819aa:	kmovq  0x30(%rsp),%k7
 1f819b1:	mov    %rax,0x98(%rsp)
 1f819b9:	jmp    1f819ec <node_contexts_window_loop+0xbec>
 1f819bb:	nopl   0x0(%rax,%rax,1)
 1f819c0:	vmovdqa64 0x740(%rsp),%zmm9
 1f819c8:	vmovdqa64 0x700(%rsp),%zmm10
 1f819d0:	mov    0xa0(%rsp),%rdi
 1f819d8:	mov    %rsi,%r12
 1f819db:	jmp    1f8115c <node_contexts_window_loop+0x35c>
 1f819e0:	movq   $0x0,0x98(%rsp)
 1f819ec:	vpaddb -0x1acf2b6(%rip),%zmm13,%zmm2        # 4b2740 <abi_test_hex.digits+0xba40>
 1f819f6:	mov    %r14,%r8
 1f819f9:	and    %r10,%r8
 1f819fc:	vporq  %zmm3,%zmm8,%zmm1
 1f81a02:	kmovq  %k1,%rax
 1f81a07:	vpcmpltub %zmm11,%zmm2,%k0
 1f81a0e:	kmovq  %k0,%rcx
 1f81a13:	vptestmb %zmm10,%zmm5,%k0
 1f81a19:	kmovq  %k0,%rdx
 1f81a1e:	vptestnmb %zmm1,%zmm1,%k0
 1f81a24:	and    %rdx,%r8
 1f81a27:	andn   %r10,%rdx,%rdx
 1f81a2c:	and    0x40(%rsp),%rdx
 1f81a31:	kmovq  %k0,%rsi
 1f81a36:	and    %rax,%rsi
 1f81a39:	or     %rcx,%rsi
 1f81a3c:	and    %rsi,%r8
 1f81a3f:	and    %r14,%rdx
 1f81a42:	and    %rsi,%rdx
 1f81a45:	mov    %rdx,0x5c0(%rsp)
 1f81a4d:	jne    1f8224d <node_contexts_window_loop+0x144d>
 1f81a53:	vmovdqa64 0x1c0(%rsp),%zmm3
 1f81a5b:	vpsllw $0x7,0x240(%rsp),%zmm1
 1f81a64:	vbroadcasti32x4 -0x19d8fae(%rip),%zmm6        # 5a8ac0 <.LCPI0_43>
 1f81a6e:	vmovdqa64 0x480(%rsp),%zmm8
 1f81a76:	vbroadcasti32x4 -0x19d8fd0(%rip),%zmm2        # 5a8ab0 <.LCPI0_42>
 1f81a80:	vbroadcasti32x4 -0x19d8fea(%rip),%zmm4        # 5a8aa0 <.LCPI0_40>
 1f81a8a:	kmovq  0x80(%rsp),%k4
 1f81a94:	kmovq  0x28(%rsp),%k2
 1f81a9b:	kmovq  0x60(%rsp),%k6
 1f81aa2:	vmovdqa64 0x500(%rsp),%zmm5
 1f81aaa:	kmovq  0x68(%rsp),%k3
 1f81ab1:	kmovq  0x78(%rsp),%k5
 1f81ab8:	vmovdqa64 0x2c0(%rsp),%zmm9
 1f81ac0:	vbroadcasti32x4 -0x19d8fda(%rip),%zmm12        # 5a8af0 <.LCPI0_48>
 1f81aca:	vmovdqa64 0x580(%rsp),%zmm7
 1f81ad2:	mov    %r8,0x440(%rsp)
 1f81ada:	vpcmpltub -0x1acf4e5(%rip),%zmm3,%k0        # 4b2600 <abi_test_hex.digits+0xb900>
 1f81ae5:	vpmovb2m %zmm1,%k1
 1f81aeb:	vbroadcasti32x4 -0x19d8ff5(%rip),%zmm1        # 5a8b00 <.LCPI0_49>
 1f81af5:	korq   %k1,%k0,%k1
 1f81afa:	vptestmb %zmm6,%zmm8,%k0
 1f81b00:	kmovq  %k0,%rax
 1f81b05:	vpcmpeqb %zmm2,%zmm13,%k0
 1f81b0b:	vpcmpeqb %zmm11,%zmm13,%k1{%k1}
 1f81b11:	kmovq  %k0,%r15
 1f81b16:	vpcmpeqb -0x1acf4e0(%rip),%zmm13,%k0        # 4b2640 <abi_test_hex.digits+0xb940>
 1f81b20:	mov    %rax,0x180(%rsp)
 1f81b28:	kmovq  %k0,%rax
 1f81b2d:	korq   %k2,%k4,%k0
 1f81b32:	vpcmpeqb 0x400(%rsp),%zmm4,%k2{%k6}
 1f81b3a:	mov    %rax,0x240(%rsp)
 1f81b42:	korq   %k2,%k0,%k0
 1f81b47:	kmovq  %k0,%rax
 1f81b4c:	vpcmpeqb %zmm4,%zmm13,%k0{%k6}
 1f81b52:	kmovq  %k0,%rdx
 1f81b57:	vptestnmb %zmm5,%zmm5,%k0
 1f81b5d:	mov    %rax,0x400(%rsp)
 1f81b65:	vbroadcasti32x4 -0x19d90ff(%rip),%zmm5        # 5a8a70 <.LCPI0_35>
 1f81b6f:	kmovq  %k0,%r13
 1f81b74:	vptestnmb %zmm3,%zmm3,%k0{%k7}
 1f81b7a:	vmovdqa64 0x540(%rsp),%zmm3
 1f81b82:	and    %rdx,%r13
 1f81b85:	andn   0x400(%rsp),%r9,%rdx
 1f81b8f:	and    0x50(%rsp),%rdx
 1f81b94:	and    %r14,%r13
 1f81b97:	korq   %k3,%k0,%k0
 1f81b9c:	kmovq  %k0,%rax
 1f81ba1:	kandq  %k5,%k6,%k0
 1f81ba6:	mov    %rax,0x1c0(%rsp)
 1f81bae:	kmovq  %k0,%rax
 1f81bb3:	vpcmpeqb -0x1acf97d(%rip),%zmm13,%k0        # 4b2240 <abi_test_hex.digits+0xb540>
 1f81bbd:	vptestnmb %zmm5,%zmm10,%k2
 1f81bc3:	mov    %rdx,0x50(%rsp)
 1f81bc8:	mov    0x58(%rsp),%rdx
 1f81bcd:	mov    %rax,0x28(%rsp)
 1f81bd2:	mov    0x20(%rsp),%rax
 1f81bd7:	andn   0x28(%rsp),%rdx,%r9
 1f81bde:	mov    0x1c0(%rsp),%rdx
 1f81be6:	and    %r15,%r9
 1f81be9:	and    %r14,%rdx
 1f81bec:	korq   %k1,%k0,%k0
 1f81bf1:	vptestmb %zmm6,%zmm9,%k1
 1f81bf7:	vbroadcasti32x4 -0x19d90f1(%rip),%zmm6        # 5a8b10 <.LCPI0_50>
 1f81c01:	kmovq  %k1,%rbx
 1f81c06:	kmovq  %k0,%rsi
 1f81c0b:	and    %rbx,%rax
 1f81c0e:	and    %r14,%rsi
 1f81c11:	kmovq  %k4,%rbx
 1f81c16:	mov    %rsi,0x540(%rsp)
 1f81c1e:	vptestmb %zmm6,%zmm10,%k1{%k1}
 1f81c24:	korq   %k1,%k2,%k2
 1f81c29:	korq   %k6,%k3,%k1
 1f81c2e:	vpcmpeqb -0x1acf678(%rip),%zmm13,%k0{%k1}        # 4b25c0 <abi_test_hex.digits+0xb8c0>
 1f81c38:	vpcmpeqb %zmm1,%zmm17,%k3
 1f81c3e:	kmovq  %k1,%r8
 1f81c43:	vpcmpeqb %zmm12,%zmm13,%k1
 1f81c49:	kmovq  %k0,%r10
 1f81c4e:	vptestnmb %zmm3,%zmm3,%k0
 1f81c54:	kmovq  %k0,%r12
 1f81c59:	vpcmpeqb -0x1acf4a3(%rip),%zmm13,%k0{%k6}        # 4b27c0 <abi_test_hex.digits+0xbac0>
 1f81c63:	vptestmb %zmm7,%zmm7,%k6{%k1}
 1f81c69:	and    0x240(%rsp),%r12
 1f81c71:	mov    %r15,0x240(%rsp)
 1f81c79:	and    %r14,%r10
 1f81c7c:	vmovdqa64 0x4c0(%rsp),%zmm7
 1f81c84:	mov    %r10,0x500(%rsp)
 1f81c8c:	and    %r8,%r12
 1f81c8f:	mov    0x180(%rsp),%r8
 1f81c97:	kmovq  %k6,0x78(%rsp)
 1f81c9e:	and    %r14,%r12
 1f81ca1:	kmovq  %k0,%rcx
 1f81ca6:	kxorq  %k6,%k1,%k0
 1f81cab:	kmovq  %k0,0x580(%rsp)
 1f81cb5:	kandq  %k0,%k3,%k0
 1f81cba:	and    %r14,%rcx
 1f81cbd:	kmovq  %k0,%r11
 1f81cc2:	vpcmpeqb %zmm12,%zmm17,%k0
 1f81cc8:	mov    %rcx,0x400(%rsp)
 1f81cd0:	and    %r8,%r9
 1f81cd3:	korq   %k0,%k3,%k0
 1f81cd8:	vpcmpeqb %zmm1,%zmm13,%k3
 1f81cde:	vbroadcasti32x4 -0x19d91c8(%rip),%zmm1        # 5a8b20 <.LCPI0_51>
 1f81ce8:	and    %r14,%r9
 1f81ceb:	and    %r14,%r11
 1f81cee:	kandq  %k0,%k3,%k0
 1f81cf3:	kmovq  %k3,0x68(%rsp)
 1f81cfa:	mov    %r11,0x80(%rsp)
 1f81d02:	kandq  %k2,%k0,%k0
 1f81d07:	kmovq  %k0,%rdi
 1f81d0c:	vptestnmb %zmm2,%zmm10,%k0{%k1}
 1f81d12:	and    %r14,%rdi
 1f81d15:	mov    %rdi,0x20(%rsp)
 1f81d1a:	kmovq  %k0,%r15
 1f81d1f:	vptestnmb %zmm2,%zmm9,%k0
 1f81d25:	vpcmpeqb %zmm1,%zmm13,%k1
 1f81d2b:	kmovq  %k0,%rcx
 1f81d30:	vptestmb %zmm4,%zmm9,%k0
 1f81d36:	and    %r14,%r15
 1f81d39:	kmovq  %k0,%r10
 1f81d3e:	vptestmb -0x1acf888(%rip),%zmm8,%k0{%k1}        # 4b24c0 <abi_test_hex.digits+0xb7c0>
 1f81d48:	kmovq  0x70(%rsp),%k1
 1f81d4f:	and    %rcx,%rax
 1f81d52:	mov    %rcx,0x58(%rsp)
 1f81d57:	andn   %r13,%rax,%rcx
 1f81d5c:	and    %rax,%r13
 1f81d5f:	mov    %rcx,0x28(%rsp)
 1f81d64:	andn   %r13,%r10,%rax
 1f81d69:	and    %r10,%r13
 1f81d6c:	mov    %rax,0x3c0(%rsp)
 1f81d74:	kmovq  %k0,%rcx
 1f81d79:	vptestmb %zmm6,%zmm7,%k0
 1f81d7f:	korq   %k5,%k0,%k0
 1f81d84:	and    %rcx,0x380(%rsp)
 1f81d8c:	korq   %k1,%k0,%k0
 1f81d91:	vpcmpeqb %zmm1,%zmm17,%k1
 1f81d97:	vporq  0x280(%rsp),%zmm10,%zmm1
 1f81d9f:	kmovq  %k1,%rcx
 1f81da4:	kmovq  0x340(%rsp),%k1
 1f81dae:	knotq  %k0,%k0
 1f81db3:	kmovq  %k0,%rax
 1f81db8:	vptestmb %zmm4,%zmm8,%k0
 1f81dbe:	and    %rcx,%rax
 1f81dc1:	kmovq  %k0,%rsi
 1f81dc6:	mov    %rsi,0x70(%rsp)
 1f81dcb:	kmovq  %k1,%rcx
 1f81dd0:	vptestmb %zmm5,%zmm9,%k1
 1f81dd6:	and    %rcx,%rbx
 1f81dd9:	kandq  %k6,%k1,%k0
 1f81dde:	kmovq  %k1,0x60(%rsp)
 1f81de5:	and    %r8,%rbx
 1f81de8:	mov    %r9,%r8
 1f81deb:	and    %rsi,%r8
 1f81dee:	kmovq  %k0,%rsi
 1f81df3:	vptestnmb %zmm2,%zmm1,%k0
 1f81df9:	vmovdqa64 0x780(%rsp),%zmm1
 1f81e01:	or     %r11,%rsi
 1f81e04:	kmovq  %k0,%rcx
 1f81e09:	or     %rdi,%rsi
 1f81e0c:	and    %rsi,%rcx
 1f81e0f:	cmpb   $0x0,0x17(%rsp)
 1f81e14:	mov    %rsi,0x180(%rsp)
 1f81e1c:	mov    %rcx,0x340(%rsp)
 1f81e24:	jne    1f822ad <node_contexts_window_loop+0x14ad>
 1f81e2a:	mov    0x18(%rsp),%rsi
 1f81e2f:	or     0x128(%rsp),%rdx
 1f81e37:	mov    0x50(%rsp),%rcx
 1f81e3c:	mov    0x28(%rsp),%r10
 1f81e41:	and    %rbx,%rax
 1f81e44:	mov    0x3c0(%rsp),%r14
 1f81e4c:	mov    0x138(%rsp),%rdi
 1f81e54:	mov    0x98(%rsp),%rbx
 1f81e5c:	vbroadcasti32x4 -0x19d93a6(%rip),%zmm3        # 5a8ac0 <.LCPI0_43>
 1f81e66:	kmovq  0x580(%rsp),%k0
 1f81e70:	mov    %rax,0x280(%rsp)
 1f81e78:	mov    %rdx,0x1c0(%rsp)
 1f81e80:	mov    0x500(%rsp),%rdx
 1f81e88:	or     %r8,%rcx
 1f81e8b:	mov    0x400(%rsp),%r8
 1f81e93:	andn   %rdi,%rbx,%rax
 1f81e98:	andn   0x88(%rsp),%rax,%r11
 1f81ea2:	or     %r14,%r9
 1f81ea5:	or     %r10,%r12
 1f81ea8:	or     %r14,%r12
 1f81eab:	or     %r10,%rdx
 1f81eae:	mov    %r8,%rax
 1f81eb1:	or     %r14,%rax
 1f81eb4:	and    %r11,%rdi
 1f81eb7:	mov    %r11,0x18(%rsp)
 1f81ebc:	or     %rdx,%rcx
 1f81ebf:	or     0x540(%rsp),%rdx
 1f81ec7:	or     %rcx,%rax
 1f81eca:	mov    %r15,%rcx
 1f81ecd:	or     %r13,%rcx
 1f81ed0:	or     %r8,%r15
 1f81ed3:	mov    0x170(%rsp),%r8
 1f81edb:	or     %r13,%r15
 1f81ede:	or     %r12,%r15
 1f81ee1:	or     %rdx,%rcx
 1f81ee4:	or     %rdx,%r9
 1f81ee7:	mov    %r13,%rdx
 1f81eea:	or     %rbx,%rdx
 1f81eed:	mov    0x80(%rsp),%r13
 1f81ef5:	or     %r9,%rdx
 1f81ef8:	mov    0x440(%rsp),%r9
 1f81f00:	kmovq  %rdx,%k3
 1f81f05:	mov    0xe8(%rsp),%rdx
 1f81f0d:	or     %r9,%rax
 1f81f10:	or     %r9,%rcx
 1f81f13:	or     %r9,%rbx
 1f81f16:	kmovq  %rax,%k6
 1f81f1b:	kmovq  %rcx,%k1
 1f81f20:	mov    0x380(%rsp),%rax
 1f81f28:	or     %r15,%rbx
 1f81f2b:	mov    0x58(%rsp),%rcx
 1f81f30:	vmovdqu8 -0x1acfbfa(%rip),%zmm14{%k6}{z}        # 4b2340 <abi_test_hex.digits+0xb640>
 1f81f3a:	kmovq  %rbx,%k2
 1f81f3f:	kmovq  %k0,%rbx
 1f81f44:	vpcmpeqb -0x1acfd0e(%rip),%zmm1,%k0        # 4b2240 <abi_test_hex.digits+0xb540>
 1f81f4e:	vmovdqa64 0xa40(%rsp),%zmm1
 1f81f56:	kmovq  %rdi,%k6
 1f81f5b:	xor    %r13,%rbx
 1f81f5e:	kmovq  %rax,%k4
 1f81f63:	andn   %r11,%rcx,%rcx
 1f81f68:	vporq  %zmm3,%zmm14,%zmm2
 1f81f6e:	vptestmb %zmm1,%zmm1,%k5
 1f81f74:	kmovq  %k0,%rax
 1f81f79:	vmovdqu8 %zmm2,%zmm14{%k3}
 1f81f7f:	vporq  %zmm11,%zmm14,%zmm2
 1f81f85:	vmovdqu8 -0x1acfc4f(%rip),%zmm1{%k5}{z}        # 4b2340 <abi_test_hex.digits+0xb640>
 1f81f8f:	kmovq  %rcx,%k5
 1f81f94:	mov    0x180(%rsp),%rcx
 1f81f9c:	vmovdqu8 %zmm2,%zmm14{%k1}
 1f81fa2:	vpord  -0x19d0778(%rip){1to16},%zmm14,%zmm2        # 5b1834 <.LCPI0_52>
 1f81fac:	kmovq  %r11,%k1
 1f81fb1:	or     %rax,%rcx
 1f81fb4:	mov    0x340(%rsp),%rax
 1f81fbc:	not    %rcx
 1f81fbf:	vmovdqu8 %zmm2,%zmm14{%k2}
 1f81fc5:	vmovdqu8 -0x1acf70f(%rip),%zmm14{%k4}        # 4b28c0 <abi_test_hex.digits+0xbbc0>
 1f81fcf:	vmovdqa64 0xa80(%rsp),%zmm2
 1f81fd7:	vmovdqu8 -0x1acf6e1(%rip),%zmm14{%k1}        # 4b2900 <abi_test_hex.digits+0xbc00>
 1f81fe1:	kmovq  %rax,%k1
 1f81fe6:	mov    0xb0(%rsp),%rax
 1f81fee:	vmovdqu8 -0x1acf6b8(%rip),%zmm14{%k1}        # 4b2940 <abi_test_hex.digits+0xbc40>
 1f81ff8:	kmovq  0x158(%rsp),%k1
 1f82002:	vmovdqa64 %zmm14,%zmm16
 1f82008:	vpaddb %zmm11,%zmm14,%zmm16{%k5}
 1f8200e:	vpaddb %zmm3,%zmm16,%zmm16{%k6}
 1f82014:	vpermi2b %zmm15,%zmm16,%zmm2{%k1}{z}
 1f8201a:	kmovq  0xa8(%rsp),%k1
 1f82024:	vmovdqu8 0x840(%rsp),%zmm2{%k1}
 1f8202c:	kmovq  %rcx,%k1
 1f82031:	mov    0xd8(%rsp),%rcx
 1f82039:	vpaddw %zmm2,%zmm2,%zmm2
 1f8203f:	vporq  %zmm1,%zmm2,%zmm1
 1f82045:	vpermb 0x80(%rax),%zmm1,%zmm1
 1f8204c:	mov    $0xffffffffffffffff,%rax
 1f82053:	vmovdqu64 %zmm14,(%rdx,%rsi,1)
 1f8205a:	vpandd -0x19d082c(%rip){1to16},%zmm1,%zmm2        # 5b1838 <.LCPI0_53>
 1f82064:	vmovdqu8 %zmm2,%zmm2{%k1}{z}
 1f8206a:	vmovdqu64 %zmm2,(%rcx,%rsi,1)
 1f82071:	cmp    %esi,%r8d
 1f82074:	jbe    1f81060 <node_contexts_window_loop+0x260>
 1f8207a:	mov    0xb8(%rsp),%rax
 1f82082:	cmp    0x120(%rsp),%r8d
 1f8208a:	mov    $0xffffffffffffffff,%rcx
 1f82091:	lea    (%rax,%r8,1),%eax
 1f82095:	shlx   %rax,%rcx,%rax
 1f8209a:	mov    $0x0,%ecx
 1f8209f:	cmovae %rcx,%rax
 1f820a3:	jmp    1f81060 <node_contexts_window_loop+0x260>
 1f820a8:	mov    0x38(%rsp),%rdi
 1f820ad:	lea    0x800(%rsp),%rax
 1f820b5:	kmovq  %k4,%r8
 1f820ba:	kmovq  %k3,%r9
 1f820bf:	mov    %r15,%rsi
 1f820c2:	mov    %r14,%rdx
 1f820c5:	mov    %r11d,%ecx
 1f820c8:	vmovdqa64 %zmm15,0x200(%rsp)
 1f820d0:	vmovdqa64 %zmm16,0x2c0(%rsp)
 1f820d8:	vmovdqa64 %zmm10,0x180(%rsp)
 1f820e0:	vmovdqa64 %zmm21,0x380(%rsp)
 1f820e8:	kmovq  %k3,0x20(%rsp)
 1f820ef:	vmovdqa64 %zmm22,0x300(%rsp)
 1f820f7:	vmovdqa64 %zmm23,0x340(%rsp)
 1f820ff:	mov    %rax,(%rsp)
 1f82103:	call   1f82960 <node_contexts_x_far>
 1f82108:	vmovdqa64 0x880(%rsp),%zmm1
 1f82110:	vpbroadcastq -0x19d3362(%rip),%zmm6        # 5aedb8 <.LCPI0_0>
 1f8211a:	vmovdqa64 0x300(%rsp),%zmm5
 1f82122:	vmovdqa64 0x940(%rsp),%zmm3
 1f8212a:	vmovdqa64 0x8c0(%rsp),%zmm2
 1f82132:	vmovdqa64 0x9c0(%rsp),%zmm4
 1f8213a:	vmovdqa64 0x380(%rsp),%zmm21
 1f82142:	kmovq  0xa8(%rsp),%k1
 1f8214c:	vmovdqa64 0x240(%rsp),%zmm20
 1f82154:	vmovdqa64 0x1c0(%rsp),%zmm19
 1f8215c:	vmovdqa64 0x180(%rsp),%zmm10
 1f82164:	vmovdqa64 0x280(%rsp),%zmm18
 1f8216c:	vmovdqa64 0x2c0(%rsp),%zmm16
 1f82174:	vmovdqa64 0x200(%rsp),%zmm15
 1f8217c:	vmovdqa64 0x480(%rsp),%zmm14
 1f82184:	vmovdqa64 0x4c0(%rsp),%zmm13
 1f8218c:	vbroadcasti32x4 -0x19d9706(%rip),%zmm12        # 5a8a90 <.LCPI0_37>
 1f82196:	vbroadcasti32x4 -0x19d9720(%rip),%zmm11        # 5a8a80 <.LCPI0_36>
 1f821a0:	vmovdqa64 0x7c0(%rsp),%zmm7
 1f821a8:	popcnt %r8,%rax
 1f821ad:	add    0x48(%rsp),%rax
 1f821b2:	kmovq  0x30(%rsp),%k7
 1f821b9:	mov    0x18(%rsp),%r11
 1f821be:	popcnt %r9,%rcx
 1f821c3:	or     %r9,%rbx
 1f821c6:	vpxor  %xmm8,%xmm8,%xmm8
 1f821cb:	vpermb 0x680(%rsp),%zmm2,%zmm2
 1f821d3:	add    %rcx,%rax
 1f821d6:	mov    %rax,0x48(%rsp)
 1f821db:	vpermt2b 0x340(%rsp),%zmm1,%zmm5
 1f821e3:	vpermb 0x6c0(%rsp),%zmm3,%zmm1
 1f821eb:	vpermb 0x640(%rsp),%zmm4,%zmm3
 1f821f3:	vmovdqu8 0x800(%rsp),%zmm21{%k1}
 1f821fb:	kmovq  0x20(%rsp),%k1
 1f82202:	mov    %rbx,0x20(%rsp)
 1f82207:	vpternlogq $0xf8,0x900(%rsp),%zmm6,%zmm1
 1f82210:	vpermb 0x600(%rsp),%zmm5,%zmm4
 1f82218:	vpandd -0x19d09fe(%rip){1to16},%zmm21,%zmm17        # 5b1824 <.LCPI0_39>
 1f82222:	vpternlogq $0xfe,%zmm3,%zmm2,%zmm1
 1f82229:	vpbroadcastq -0x19d3473(%rip),%zmm3        # 5aedc0 <.LCPI0_1>
 1f82233:	vmovdqu8 %zmm1,%zmm10{%k1}
 1f82239:	vpternlogq $0xf8,0x980(%rsp),%zmm3,%zmm4
 1f82242:	vmovdqu8 %zmm4,%zmm16{%k1}
 1f82248:	jmp    1f8160b <node_contexts_window_loop+0x80b>
 1f8224d:	mov    0x38(%rsp),%rdi
 1f82252:	mov    0x18(%rsp),%rsi
 1f82257:	vmovdqa64 %zmm15,0x200(%rsp)
 1f8225f:	vmovdqa64 %zmm10,0x180(%rsp)
 1f82267:	vmovdqa64 %zmm17,0x3c0(%rsp)
 1f8226f:	call   1f82c7d <node_contexts_x_converted>
 1f82274:	vmovdqa64 0x3c0(%rsp),%zmm17
 1f8227c:	vmovdqa64 0x180(%rsp),%zmm10
 1f82284:	vmovdqa64 0x300(%rsp),%zmm13
 1f8228c:	vmovdqa64 0x200(%rsp),%zmm15
 1f82294:	vbroadcasti32x4 -0x19d981e(%rip),%zmm11        # 5a8a80 <.LCPI0_36>
 1f8229e:	kmovq  0x30(%rsp),%k7
 1f822a5:	or     %rax,%r8
 1f822a8:	jmp    1f81a53 <node_contexts_window_loop+0xc53>
 1f822ad:	mov    %rdx,0x1c0(%rsp)
 1f822b5:	mov    0x38(%rsp),%rdi
 1f822ba:	mov    0x90(%rsp),%rsi
 1f822c2:	mov    0x18(%rsp),%rdx
 1f822c7:	mov    0x88(%rsp),%rcx
 1f822cf:	vmovdqa64 %zmm15,0x200(%rsp)
 1f822d7:	mov    %rax,0x280(%rsp)
 1f822df:	call   1f82dfe <node_contexts_x_spaced>
 1f822e4:	vmovdqa64 0x300(%rsp),%zmm13
 1f822ec:	vmovdqa64 0x780(%rsp),%zmm1
 1f822f4:	vmovdqa64 0x2c0(%rsp),%zmm9
 1f822fc:	vmovdqa64 0x200(%rsp),%zmm15
 1f82304:	vmovdqa64 0x480(%rsp),%zmm8
 1f8230c:	vmovdqa64 0x4c0(%rsp),%zmm7
 1f82314:	vbroadcasti32x4 -0x19d989e(%rip),%zmm11        # 5a8a80 <.LCPI0_36>
 1f8231e:	andn   %rcx,%rax,%rcx
 1f82323:	mov    %rdx,%rsi
 1f82326:	kmovq  0x30(%rsp),%k7
 1f8232d:	mov    0x1c0(%rsp),%rdx
 1f82335:	mov    0x280(%rsp),%rax
 1f8233d:	mov    %rcx,0x88(%rsp)
 1f82345:	jmp    1f81e2f <node_contexts_window_loop+0x102f>
 1f8234a:	vmovq  0x48(%rsp),%xmm1
 1f82350:	vmovq  0xc0(%rsp),%xmm3
 1f82359:	vmovq  %r10,%xmm2
 1f8235e:	mov    0xc8(%rsp),%rcx
 1f82366:	vpunpcklqdq %xmm1,%xmm2,%xmm1
 1f8236a:	vmovq  %r11,%xmm2
 1f8236f:	vpunpcklqdq %xmm3,%xmm2,%xmm2
 1f82373:	vinserti128 $0x1,%xmm1,%ymm2,%ymm1
 1f82379:	vinserti64x4 $0x1,%ymm0,%zmm1,%zmm0
 1f82380:	vpaddq (%rcx),%zmm0,%zmm0
 1f82386:	vmovdqu64 %zmm0,(%rcx)
 1f8238c:	lea    -0x28(%rbp),%rsp
 1f82390:	pop    %rbx
 1f82391:	pop    %r12
 1f82393:	pop    %r13
 1f82395:	pop    %r14
 1f82397:	pop    %r15
 1f82399:	pop    %rbp
 1f8239a:	vzeroupper
 1f8239d:	ret
Disassembly of section .init:
Disassembly of section .fini:
Disassembly of section .iplt:
