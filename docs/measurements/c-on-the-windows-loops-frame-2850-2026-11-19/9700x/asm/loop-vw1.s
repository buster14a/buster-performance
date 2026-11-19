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
 1f80e18:	mov    (%rdi),%rax
 1f80e1b:	mov    0xb38(%rdi),%r14
 1f80e22:	add    $0x3f,%edx
 1f80e25:	vpxor  %xmm0,%xmm0,%xmm0
 1f80e29:	mov    0x8(%rax),%rax
 1f80e2d:	movzbl 0x14a(%rax),%eax
 1f80e34:	vmovdqa64 %zmm0,0xa80(%rsp)
 1f80e3c:	vmovdqa64 %zmm0,0xa40(%rsp)
 1f80e44:	vmovdqa64 %zmm0,0xa00(%rsp)
 1f80e4c:	vmovdqa64 %zmm0,0x9c0(%rsp)
 1f80e54:	vmovdqa64 %zmm0,0x980(%rsp)
 1f80e5c:	vmovdqa64 %zmm0,0x940(%rsp)
 1f80e64:	vmovdqa64 %zmm0,0x900(%rsp)
 1f80e6c:	vmovdqa64 %zmm0,0x8c0(%rsp)
 1f80e74:	mov    %al,0x3f(%rsp)
 1f80e78:	cmp    $0x40,%edx
 1f80e7b:	jae    1f80e8b <node_contexts_window_loop+0x8b>
 1f80e7d:	xor    %edx,%edx
 1f80e7f:	xor    %eax,%eax
 1f80e81:	vpxor  %xmm8,%xmm8,%xmm8
 1f80e86:	jmp    1f8292b <node_contexts_window_loop+0x1b2b>
 1f80e8b:	mov    0xba8(%rdi),%rax
 1f80e92:	mov    0xb90(%rdi),%r11
 1f80e99:	vmovdqa64 0x4fc37dd(%rip),%zmm3        # 6f44680 <node_views_x>
 1f80ea3:	mov    0xb98(%rdi),%r8
 1f80eaa:	mov    %rcx,0x138(%rsp)
 1f80eb2:	mov    0xb80(%rdi),%rcx
 1f80eb9:	vmovdqu64 (%r14),%zmm9
 1f80ebf:	vmovdqa64 0x4fc37f7(%rip),%zmm4        # 6f446c0 <node_views_x+0x40>
 1f80ec9:	mov    0xb88(%rdi),%r10
 1f80ed0:	mov    0xba0(%rdi),%r9
 1f80ed7:	vbroadcasti32x4 -0x19d8471(%rip),%zmm11        # 5a8a70 <.LCPI0_35>
 1f80ee1:	vbroadcasti32x4 -0x19d846b(%rip),%zmm13        # 5a8a80 <.LCPI0_36>
 1f80eeb:	vbroadcasti32x4 -0x19d8465(%rip),%zmm14        # 5a8a90 <.LCPI0_37>
 1f80ef5:	vbroadcasti32x4 -0x19d845f(%rip),%zmm15        # 5a8aa0 <.LCPI0_38>
 1f80eff:	vbroadcasti32x4 -0x19d8459(%rip),%zmm16        # 5a8ab0 <.LCPI0_39>
 1f80f09:	vbroadcasti32x4 -0x19d8453(%rip),%zmm17        # 5a8ac0 <.LCPI0_40>
 1f80f13:	vbroadcasti32x4 -0x19d844d(%rip),%zmm18        # 5a8ad0 <.LCPI0_41>
 1f80f1d:	vbroadcasti32x4 -0x19d8447(%rip),%zmm19        # 5a8ae0 <.LCPI0_42>
 1f80f27:	vbroadcasti32x4 -0x19d8441(%rip),%zmm21        # 5a8af0 <.LCPI0_43>
 1f80f31:	vbroadcasti32x4 -0x19d843b(%rip),%zmm24        # 5a8b00 <.LCPI0_44>
 1f80f3b:	vbroadcasti32x4 -0x19d8435(%rip),%zmm31        # 5a8b10 <.LCPI0_45>
 1f80f45:	vbroadcasti32x4 -0x19d842f(%rip),%zmm25        # 5a8b20 <.LCPI0_46>
 1f80f4f:	mov    $0xffffffff,%r15d
 1f80f55:	vpxor  %xmm8,%xmm8,%xmm8
 1f80f5a:	movq   $0x0,0x50(%rsp)
 1f80f63:	xor    %r13d,%r13d
 1f80f66:	movq   $0x0,0xb0(%rsp)
 1f80f72:	movq   $0x0,0x108(%rsp)
 1f80f7e:	vpxord %xmm28,%xmm28,%xmm28
 1f80f84:	mov    %rdi,0x48(%rsp)
 1f80f89:	mov    %rsi,0x110(%rsp)
 1f80f91:	mov    %r14,0x128(%rsp)
 1f80f99:	mov    %rax,0x160(%rsp)
 1f80fa1:	mov    0xbb0(%rdi),%rax
 1f80fa8:	mov    %rcx,0x180(%rsp)
 1f80fb0:	mov    %r8,0x170(%rsp)
 1f80fb8:	mov    %r10,0x178(%rsp)
 1f80fc0:	mov    %r9,0x168(%rsp)
 1f80fc8:	mov    %r11,0x120(%rsp)
 1f80fd0:	vmovdqa64 %zmm3,0x880(%rsp)
 1f80fd8:	vmovdqa64 %zmm4,0x840(%rsp)
 1f80fe0:	mov    %rax,0x158(%rsp)
 1f80fe8:	mov    0xbb8(%rdi),%rax
 1f80fef:	mov    %rax,0x150(%rsp)
 1f80ff7:	mov    0xbc0(%rdi),%rax
 1f80ffe:	mov    %rax,0x148(%rsp)
 1f81006:	mov    0xbd0(%rdi),%rax
 1f8100d:	mov    %rax,0x140(%rsp)
 1f81015:	mov    %edx,%eax
 1f81017:	and    $0xffffffc0,%eax
 1f8101a:	shr    $0x6,%edx
 1f8101d:	add    $0xffffffc0,%eax
 1f81020:	vmovdqu64 (%r11,%rax,1),%zmm1
 1f81027:	vmovdqu64 0x2c(%rsi,%rax,1),%zmm0
 1f81032:	vmovdqu64 (%r8,%rax,1),%zmm2
 1f81039:	vpermb %zmm3,%zmm1,%zmm20
 1f8103f:	vmovdqa64 0x4fc36b7(%rip),%zmm3        # 6f44700 <node_views_x+0x80>
 1f81049:	vpermt2b 0x40(%r14),%zmm0,%zmm9
 1f81050:	vmovdqu64 (%rcx,%rax,1),%zmm0
 1f81057:	vpermb %zmm3,%zmm2,%zmm1
 1f8105d:	vmovdqa64 %zmm3,0x800(%rsp)
 1f81065:	vpbroadcastq -0x19d2277(%rip),%zmm3        # 5aedf8 <.LCPI0_0>
 1f8106f:	vpermb %zmm4,%zmm0,%zmm0
 1f81075:	vmovdqa64 0x4fc36c1(%rip),%zmm4        # 6f44740 <node_views_x+0xc0>
 1f8107f:	vpbroadcastq -0x19d2289(%rip),%zmm2        # 5aee00 <.LCPI0_1>
 1f81089:	vpternlogq $0xf8,(%r10,%rax,1),%zmm3,%zmm20
 1f81091:	vpermb %zmm4,%zmm9,%zmm10
 1f81097:	vpternlogq $0xf8,(%r9,%rax,1),%zmm2,%zmm10
 1f8109f:	vmovdqa64 %zmm4,0x7c0(%rsp)
 1f810a7:	vpternlogq $0xfe,%zmm1,%zmm0,%zmm20
 1f810ae:	vpxor  %xmm1,%xmm1,%xmm1
 1f810b2:	jmp    1f8125a <node_contexts_window_loop+0x45a>
 1f810b7:	nopw   0x0(%rax,%rax,1)
 1f810c0:	kmovq  0x600(%rsp),%k0
 1f810ca:	kmovq  0x190(%rsp),%k2
 1f810d4:	vpaddb -0x1ace95e(%rip),%zmm5,%zmm4        # 4b2780 <abi_test_hex.digits+0xba80>
 1f810de:	mov    0x98(%rsp),%r9
 1f810e6:	mov    0x70(%rsp),%r8
 1f810eb:	mov    0x78(%rsp),%r10
 1f810f0:	vpmovb2m %zmm26,%k4
 1f810f6:	vpcmpeqb %zmm16,%zmm5,%k3
 1f810fc:	mov    0x120(%rsp),%r11
 1f81104:	mov    0xf8(%rsp),%r13
 1f8110c:	mov    0x128(%rsp),%r14
 1f81114:	vmovdqa64 %zmm0,%zmm28
 1f8111a:	vpcmpltub -0x1ace8a5(%rip),%zmm4,%k1        # 4b2880 <abi_test_hex.digits+0xbb80>
 1f81125:	vpandq %zmm19,%zmm27,%zmm4
 1f8112b:	or     0x200(%rsp),%r10
 1f81133:	vpcmpeqb %zmm13,%zmm6,%k3{%k3}
 1f81139:	or     0x1c0(%rsp),%r10
 1f81141:	kmovq  %k0,%rdi
 1f81146:	vpcmpeqb %zmm25,%zmm5,%k0
 1f8114c:	and    %r9,%r8
 1f8114f:	korq   %k2,%k0,%k0
 1f81154:	kmovq  0x1a0(%rsp),%k2
 1f8115e:	and    %r8,%rdi
 1f81161:	vmovq  %r8,%xmm2
 1f81166:	mov    0x198(%rsp),%r8
 1f8116e:	vmovq  %rdi,%xmm3
 1f81173:	mov    0x240(%rsp),%rdi
 1f8117b:	or     %rcx,%r10
 1f8117e:	andn   0x40(%rsp),%rdi,%rdi
 1f81185:	kandq  %k2,%k0,%k0
 1f8118a:	vpcmpeqb -0x1aced94(%rip),%zmm5,%k2        # 4b2400 <abi_test_hex.digits+0xb700>
 1f81194:	vmovq  %rax,%xmm5
 1f81199:	andn   %r8,%rax,%rax
 1f8119e:	vmovq  %r8,%xmm6
 1f811a3:	or     %rax,%r10
 1f811a6:	andn   %r9,%rdx,%rax
 1f811ab:	and    %rbx,%rax
 1f811ae:	vptestnmb %zmm4,%zmm4,%k2{%k2}
 1f811b4:	korq   %k2,%k1,%k1
 1f811b9:	korq   %k4,%k1,%k1
 1f811be:	korq   %k0,%k1,%k1
 1f811c3:	kandq  %k7,%k0,%k0
 1f811c8:	korq   %k3,%k1,%k1
 1f811cd:	kmovq  %k1,%r8
 1f811d2:	vptestnmb %zmm1,%zmm1,%k1
 1f811d8:	vpunpcklqdq %xmm3,%xmm2,%xmm1
 1f811dc:	vpunpcklqdq %xmm5,%xmm6,%xmm2
 1f811e0:	or     %rdi,%r8
 1f811e3:	mov    0x140(%rsp),%rdi
 1f811eb:	kmovq  %k1,%rdx
 1f811f0:	vinserti128 $0x1,%xmm1,%ymm2,%ymm1
 1f811f6:	or     %r8,%r10
 1f811f9:	mov    0x1b0(%rsp),%r8
 1f81201:	and    %rax,%rdx
 1f81204:	vpopcntq %ymm1,%ymm1
 1f8120a:	and    %r9,%r10
 1f8120d:	vpaddq %ymm1,%ymm8,%ymm8
 1f81211:	vmovdqa64 %zmm9,%zmm1
 1f81217:	vmovdqa64 %zmm12,%zmm9
 1f8121d:	mov    %r8d,%ecx
 1f81220:	shl    $0x6,%rcx
 1f81224:	mov    %rax,(%rdi,%rcx,1)
 1f81228:	mov    %rdx,0x8(%rdi,%rcx,1)
 1f8122d:	mov    0x1b8(%rsp),%rdx
 1f81235:	mov    %r10,0x10(%rdi,%rcx,1)
 1f8123a:	kmovq  %k0,0x18(%rdi,%rcx,1)
 1f81241:	vpcmpgtb %zmm26,%zmm7,%k0{%k7}
 1f81247:	kmovq  %k0,0x20(%rdi,%rcx,1)
 1f8124e:	dec    %rdx
 1f81251:	test   %r8d,%r8d
 1f81254:	je     1f82904 <node_contexts_window_loop+0x1b04>
 1f8125a:	lea    -0x1(%rdx),%ecx
 1f8125d:	mov    0x168(%rsp),%r9
 1f81265:	mov    %r15d,0x104(%rsp)
 1f8126d:	mov    0x180(%rsp),%r15
 1f81275:	mov    0x178(%rsp),%rdi
 1f8127d:	vmovdqa64 -0x1acf107(%rip),%zmm7        # 4b2180 <abi_test_hex.digits+0xb480>
 1f81287:	vmovdqa64 -0x1acf011(%rip),%zmm12        # 4b2280 <abi_test_hex.digits+0xb580>
 1f81291:	vmovdqa64 %zmm20,%zmm4
 1f81297:	vmovdqa64 %zmm10,%zmm3
 1f8129d:	mov    0x170(%rsp),%r8
 1f812a5:	mov    %rdx,0x1b8(%rsp)
 1f812ad:	mov    %rcx,%rbx
 1f812b0:	shl    $0x6,%rbx
 1f812b4:	test   %ecx,%ecx
 1f812b6:	mov    %rcx,0x1b0(%rsp)
 1f812be:	lea    -0x40(%rbx),%eax
 1f812c1:	mov    %rbx,0x80(%rsp)
 1f812c9:	cmove  %ecx,%eax
 1f812cc:	shl    $0x7,%rcx
 1f812d0:	vmovdqu64 0x6b554(%rsi,%rcx,1),%zmm0
 1f812db:	vmovdqu64 0x6b594(%rsi,%rcx,1),%zmm2
 1f812e6:	vmovdqu64 0x6f694(%rsi,%rcx,1),%zmm5
 1f812f1:	vmovdqu64 0x6d5d4(%rsi,%rcx,1),%zmm6
 1f812fc:	vmovdqu64 (%r9,%rbx,1),%zmm27
 1f81303:	vmovdqu64 (%r8,%rbx,1),%zmm26
 1f8130a:	vpmovuswb %zmm0,%ymm0
 1f81310:	vpmovuswb %zmm2,%ymm2
 1f81316:	vpmovuswb %zmm5,%ymm5
 1f8131c:	vinserti64x4 $0x1,%ymm2,%zmm0,%zmm2
 1f81323:	vpandq %zmm13,%zmm27,%zmm0
 1f81329:	vptestmb %zmm0,%zmm0,%k4
 1f8132f:	vmovups (%r15,%rbx,1),%zmm0
 1f81336:	vptestmb %zmm2,%zmm2,%k0
 1f8133c:	vpcmpnltub %zmm2,%zmm12,%k1
 1f81343:	vpsubb %zmm2,%zmm12,%zmm29
 1f81349:	kmovq  %k1,%r10
 1f8134e:	kandq  %k0,%k4,%k1
 1f81353:	kmovq  %k0,%rdx
 1f81358:	kmovq  %k4,0x90(%rsp)
 1f81362:	vpcmpltub %zmm2,%zmm12,%k1{%k1}
 1f81369:	vmovdqu64 0x40(%r14),%zmm2
 1f81370:	and    %rdx,%r10
 1f81373:	mov    %r10,0x70(%rsp)
 1f81378:	vmovaps %zmm0,0x200(%rsp)
 1f81380:	vmovups (%rdi,%rbx,1),%zmm0
 1f81387:	vmovaps %zmm0,0x240(%rsp)
 1f8138f:	vmovdqu64 0x6f654(%rsi,%rcx,1),%zmm0
 1f8139a:	vpmovuswb %zmm0,%ymm0
 1f813a0:	vinserti64x4 $0x1,%ymm5,%zmm0,%zmm5
 1f813a7:	vmovdqu64 0x196ac(%rsi,%rbx,1),%zmm0
 1f813b2:	vpaddb -0x1acf1fc(%rip),%zmm5,%zmm30        # 4b21c0 <abi_test_hex.digits+0xb4c0>
 1f813bc:	vptestmb %zmm0,%zmm0,%k3
 1f813c2:	vmovdqa64 %zmm9,%zmm0
 1f813c8:	vpcmpleub %zmm7,%zmm5,%k2{%k3}
 1f813cf:	kandq  %k4,%k3,%k3
 1f813d4:	vpermt2b %zmm1,%zmm30,%zmm0{%k2}{z}
 1f813da:	vpmovuswb %zmm6,%ymm1
 1f813e0:	vmovdqu64 0x6d614(%rsi,%rcx,1),%zmm6
 1f813eb:	kmovq  %k2,0x1a8(%rsp)
 1f813f5:	vpcmpnleub %zmm7,%zmm5,%k5{%k3}
 1f813fc:	vmovdqu64 (%r15,%rax,1),%zmm5
 1f81403:	vmovdqu64 (%r8,%rax,1),%zmm7
 1f8140a:	vpandd -0x19cfbb4(%rip){1to16},%zmm0,%zmm22        # 5b1860 <.LCPI0_47>
 1f81414:	kmovq  %r10,%k3
 1f81419:	kmovq  %k4,%rcx
 1f8141e:	vpermb 0x840(%rsp),%zmm5,%zmm5
 1f81426:	kortestq %k5,%k1
 1f8142b:	kmovq  %k5,0x118(%rsp)
 1f81435:	mov    %rcx,0x98(%rsp)
 1f8143d:	vpmovuswb %zmm6,%ymm6
 1f81443:	vinserti64x4 $0x1,%ymm6,%zmm1,%zmm1
 1f8144a:	vpcmpltub -0x1acf195(%rip),%zmm1,%k2        # 4b22c0 <abi_test_hex.digits+0xb5c0>
 1f81455:	vmovdqu64 (%r11,%rax,1),%zmm6
 1f8145c:	vpermb 0x880(%rsp),%zmm6,%zmm20
 1f81464:	vpbroadcastq -0x19d2676(%rip),%zmm6        # 5aedf8 <.LCPI0_0>
 1f8146e:	vpsubb %zmm1,%zmm12,%zmm10
 1f81474:	vmovdqu64 0x2c(%rsi,%rax,1),%zmm12
 1f8147f:	vptestmb %zmm1,%zmm1,%k2{%k2}
 1f81485:	vmovdqu64 (%r14),%zmm1
 1f8148b:	vpternlogq $0xf8,(%rdi,%rax,1),%zmm6,%zmm20
 1f81493:	vpbroadcastq -0x19d269d(%rip),%zmm6        # 5aee00 <.LCPI0_1>
 1f8149d:	vpermi2b %zmm2,%zmm1,%zmm12
 1f814a3:	vpermb 0x7c0(%rsp),%zmm12,%zmm23
 1f814ab:	vpternlogq $0xf8,(%r9,%rax,1),%zmm6,%zmm23
 1f814b3:	vpermb 0x800(%rsp),%zmm7,%zmm6
 1f814bb:	vmovdqa64 %zmm10,%zmm7
 1f814c1:	vmovdqa64 %zmm12,0x640(%rsp)
 1f814c9:	vpternlogq $0xfe,%zmm6,%zmm5,%zmm20
 1f814d0:	vmovdqa64 %zmm20,%zmm6
 1f814d6:	vpermt2b %zmm4,%zmm29,%zmm6{%k3}{z}
 1f814dc:	vpermi2b %zmm3,%zmm23,%zmm29{%k3}{z}
 1f814e2:	vpermi2b %zmm4,%zmm20,%zmm7{%k2}{z}
 1f814e8:	jne    1f82451 <node_contexts_window_loop+0x1651>
 1f814ee:	vmovdqa64 %zmm22,0x600(%rsp)
 1f814f6:	vpxor  %xmm10,%xmm10,%xmm10
 1f814fb:	vmovdqa64 %zmm6,%zmm4
 1f81501:	vpandq %zmm15,%zmm4,%zmm6
 1f81507:	vpandq %zmm31,%zmm26,%zmm1
 1f8150d:	vmovdqu64 0x1a72c(%rsi,%rbx,1),%zmm3
 1f81518:	vmovdqa64 0x240(%rsp),%zmm2
 1f81520:	mov    %r13,0xf8(%rsp)
 1f81528:	vpandq -0x19d272a(%rip){1to8},%zmm9,%zmm5        # 5aee08 <.LCPI0_24>
 1f81532:	vptestmb %zmm18,%zmm7,%k3
 1f81538:	vpandq %zmm16,%zmm27,%zmm12
 1f8153e:	vmovdqa64 %zmm8,0xb00(%rsp)
 1f81546:	vmovdqa64 %zmm23,0xac0(%rsp)
 1f8154e:	vptestmb %zmm6,%zmm6,%k0
 1f81554:	vptestnmb %zmm1,%zmm1,%k2
 1f8155a:	vpcmpeqb %zmm14,%zmm1,%k7
 1f81560:	vpandd -0x19cfd06(%rip){1to16},%zmm26,%zmm1        # 5b1864 <.LCPI0_48>
 1f8156a:	vmovdqa64 %zmm12,0x740(%rsp)
 1f81572:	kmovq  %k3,0x1a0(%rsp)
 1f8157c:	kmovq  %k0,%r13
 1f81581:	vptestmb -0x1acf00b(%rip),%zmm2,%k0        # 4b2580 <abi_test_hex.digits+0xb880>
 1f8158b:	kmovq  %k2,%rcx
 1f81590:	kmovq  %k7,0xe8(%rsp)
 1f8159a:	mov    %r13,0x188(%rsp)
 1f815a2:	vptestnmb %zmm3,%zmm3,%k5
 1f815a8:	vpcmpgtb %zmm0,%zmm10,%k1{%k5}
 1f815ae:	vpternlogd $0xff,%zmm0,%zmm0,%zmm0
 1f815b5:	vpaddb 0x200(%rsp),%zmm0,%zmm0
 1f815bd:	vptestmb %zmm1,%zmm1,%k2
 1f815c3:	vpcmpeqb %zmm25,%zmm1,%k6
 1f815c9:	vmovdqa64 %zmm1,0x5c0(%rsp)
 1f815d1:	vpandq %zmm16,%zmm7,%zmm10
 1f815d7:	kmovq  %k0,%rax
 1f815dc:	vptestmb %zmm18,%zmm2,%k0
 1f815e2:	vmovdqu8 %zmm14,%zmm1{%k1}{z}
 1f815e8:	mov    %rax,0x40(%rsp)
 1f815ed:	kmovq  %k2,%rax
 1f815f2:	knotq  %k1,%k2
 1f815f7:	kmovq  %k2,%r12
 1f815fc:	korq   %k1,%k0,%k2
 1f81601:	kandq  %k6,%k2,%k0
 1f81606:	and    %r12,%rcx
 1f81609:	mov    %r12,0x130(%rsp)
 1f81611:	kmovq  %k2,0xd0(%rsp)
 1f8161b:	kmovq  %k0,%rsi
 1f81620:	vptestmb %zmm17,%zmm2,%k0{%k7}
 1f81626:	vpandq %zmm17,%zmm4,%zmm2
 1f8162c:	vmovdqa64 %zmm2,0x700(%rsp)
 1f81634:	or     %rcx,%rsi
 1f81637:	mov    0x120(%rsp),%rcx
 1f8163f:	and    %rax,%rsi
 1f81642:	mov    0x158(%rsp),%rax
 1f8164a:	vpcmpltub %zmm15,%zmm0,%k4
 1f81651:	vpcmpltub %zmm21,%zmm0,%k7
 1f81658:	vpandd -0x19cfdfa(%rip){1to16},%zmm29,%zmm0        # 5b1868 <.LCPI0_49>
 1f81662:	vpcmpeqb -0x1acee2c(%rip),%zmm0,%k1        # 4b2840 <abi_test_hex.digits+0xbb40>
 1f8166c:	vmovdqa64 %zmm6,%zmm0
 1f81672:	kmovq  %k4,0xb8(%rsp)
 1f8167c:	kmovq  %k0,%rdx
 1f81681:	vptestmb %zmm17,%zmm9,%k0{%k4}
 1f81687:	and    %r12,%rdx
 1f8168a:	or     0x40(%rsp),%rdx
 1f8168f:	kmovq  %k7,%r12
 1f81694:	mov    %r12,0x40(%rsp)
 1f81699:	kmovq  %k0,0x190(%rsp)
 1f816a3:	kandq  %k3,%k0,%k0
 1f816a8:	knotq  %k0,%k0
 1f816ad:	mov    %rdx,0xe0(%rsp)
 1f816b5:	not    %rdx
 1f816b8:	kmovq  %k0,%rdi
 1f816bd:	vpcmpeqb %zmm24,%zmm5,%k0{%k7}
 1f816c3:	kmovq  %k0,%r15
 1f816c8:	vptestmb %zmm2,%zmm2,%k0
 1f816ce:	vpandq %zmm19,%zmm9,%zmm2
 1f816d4:	vmovdqa64 %zmm2,0x780(%rsp)
 1f816dc:	vpternlogq $0xfe,%zmm2,%zmm10,%zmm0
 1f816e3:	vbroadcasti32x4 -0x19d8bbd(%rip),%zmm2        # 5a8b30 <.LCPI0_50>
 1f816ed:	korq   %k0,%k1,%k0
 1f816f2:	vpcmpeqb %zmm18,%zmm5,%k1
 1f816f8:	and    %rdi,%r15
 1f816fb:	knotq  %k0,%k0
 1f81700:	kmovq  %k0,%r8
 1f81705:	vptestmb %zmm0,%zmm0,%k0
 1f8170b:	kmovq  %k0,%r11
 1f81710:	and    %r8,%r11
 1f81713:	vpcmpeqb %zmm2,%zmm5,%k0
 1f81719:	korq   %k0,%k1,%k0
 1f8171e:	kmovq  %k0,%r9
 1f81723:	vpcmpneqb %zmm2,%zmm5,%k0
 1f8172a:	vpandq %zmm15,%zmm7,%zmm2
 1f81730:	vporq  %zmm12,%zmm2,%zmm0
 1f81736:	kmovq  %k0,%r14
 1f8173b:	vmovdqu64 (%rcx,%rbx,1),%zmm12
 1f81742:	kmovq  %k2,%rcx
 1f81747:	vmovdqu64 %zmm1,(%rax,%rbx,1)
 1f8174e:	vptestnmb %zmm0,%zmm0,%k0
 1f81754:	vpsllw $0x7,%zmm27,%zmm0
 1f8175b:	or     %r12,%r14
 1f8175e:	mov    %rcx,0xc8(%rsp)
 1f81766:	kmovq  %k0,%r10
 1f8176b:	vpmovb2m %zmm0,%k0
 1f81771:	or     %rcx,%r14
 1f81774:	and    %r9,%r10
 1f81777:	mov    0x98(%rsp),%r9
 1f8177f:	kmovq  %k0,%rax
 1f81784:	kmovq  %k0,0xd8(%rsp)
 1f8178e:	andn   %rsi,%rax,%rsi
 1f81793:	mov    %rax,0x88(%rsp)
 1f8179b:	mov    0x148(%rsp),%rax
 1f817a3:	andn   %rdx,%rsi,%r8
 1f817a8:	mov    %rsi,0xc0(%rsp)
 1f817b0:	and    %r8,%r15
 1f817b3:	mov    %r8,0x78(%rsp)
 1f817b8:	and    %r15,%r11
 1f817bb:	mov    %r15,0x198(%rsp)
 1f817c3:	and    %r9,%r14
 1f817c6:	mov    %r11,0xf0(%rsp)
 1f817ce:	and    %r8,%r14
 1f817d1:	vmovdqu64 %zmm5,(%rax,%rbx,1)
 1f817d8:	and    %r10,%r14
 1f817db:	or     %r11,%r14
 1f817de:	and    %r13,%r14
 1f817e1:	je     1f81a60 <node_contexts_window_loop+0xc60>
 1f817e7:	mov    0x48(%rsp),%rax
 1f817ec:	mov    %rbx,%rdi
 1f817ef:	shl    $0x6,%rdi
 1f817f3:	mov    0x50(%rsp),%rdx
 1f817f8:	mov    %r14,%r13
 1f817fb:	add    0x2c0(%rax),%rdi
 1f81802:	mov    0x20(%rax),%rbx
 1f81806:	mov    0x60(%rax),%r12d
 1f8180a:	nopw   0x0(%rax,%rax,1)
 1f81810:	xor    %r15d,%r15d
 1f81813:	tzcnt  %r13,%r15
 1f81818:	mov    %r15d,%eax
 1f8181b:	shl    $0x6,%eax
 1f8181e:	mov    0x20(%rdi,%rax,1),%esi
 1f81822:	mov    %esi,%ecx
 1f81824:	shr    $0x3,%ecx
 1f81827:	cmp    %r12d,%ecx
 1f8182a:	cmovae %r12d,%ecx
 1f8182e:	shl    $0x6,%rcx
 1f81832:	cmpl   $0x0,0x38(%rbx,%rcx,1)
 1f81837:	setne  %al
 1f8183a:	testb  $0x4,0x34(%rbx,%rcx,1)
 1f8183f:	je     1f8185f <node_contexts_window_loop+0xa5f>
 1f81841:	xor    $0x1,%al
 1f81843:	inc    %rdx
 1f81846:	movzbl %al,%eax
 1f81849:	shlx   %r15,%rax,%rax
 1f8184e:	andn   %r14,%rax,%r14
 1f81853:	blsr   %r13,%r13
 1f81858:	jne    1f81810 <node_contexts_window_loop+0xa10>
 1f8185a:	jmp    1f81a68 <node_contexts_window_loop+0xc68>
 1f8185f:	mov    %rdi,0xa0(%rsp)
 1f81867:	mov    0x48(%rsp),%rdi
 1f8186c:	vmovdqa64 %zmm9,0x500(%rsp)
 1f81874:	vmovdqa64 %zmm20,0x4c0(%rsp)
 1f8187c:	mov    %rdx,0x50(%rsp)
 1f81881:	vmovdqa64 %zmm26,0x480(%rsp)
 1f81889:	vmovdqa64 %zmm27,0x440(%rsp)
 1f81891:	vmovdqa64 %zmm28,0x400(%rsp)
 1f81899:	vmovdqa64 %zmm29,0x3c0(%rsp)
 1f818a1:	vmovdqa64 %zmm30,0x380(%rsp)
 1f818a9:	vmovdqa64 %zmm22,0x340(%rsp)
 1f818b1:	vmovdqa64 %zmm5,0x300(%rsp)
 1f818b9:	vmovdqa64 %zmm12,0x2c0(%rsp)
 1f818c1:	vmovdqa64 %zmm7,0x580(%rsp)
 1f818c9:	vmovdqa64 %zmm3,0x280(%rsp)
 1f818d1:	vmovdqa64 %zmm4,0x540(%rsp)
 1f818d9:	kmovq  %k5,0x68(%rsp)
 1f818e0:	kmovq  %k6,0x60(%rsp)
 1f818e7:	kmovq  %k7,0x58(%rsp)
 1f818ee:	vmovdqa64 %zmm6,0x1c0(%rsp)
 1f818f6:	vmovdqa64 %zmm10,0x680(%rsp)
 1f818fe:	kmovq  %k1,0xa8(%rsp)
 1f81908:	vmovdqa64 %zmm2,0x6c0(%rsp)
 1f81910:	vzeroupper
 1f81913:	call   1f82f7a <node_contexts_stride_asked>
 1f81918:	vmovdqa64 0x6c0(%rsp),%zmm2
 1f81920:	vmovdqa64 0x680(%rsp),%zmm10
 1f81928:	vmovdqa64 0x1c0(%rsp),%zmm6
 1f81930:	vmovdqa64 0x540(%rsp),%zmm4
 1f81938:	vmovdqa64 0x280(%rsp),%zmm3
 1f81940:	vmovdqa64 0x580(%rsp),%zmm7
 1f81948:	vmovdqa64 0x2c0(%rsp),%zmm12
 1f81950:	vmovdqa64 0x300(%rsp),%zmm5
 1f81958:	vmovdqa64 0x340(%rsp),%zmm22
 1f81960:	vmovdqa64 0x380(%rsp),%zmm30
 1f81968:	vmovdqa64 0x3c0(%rsp),%zmm29
 1f81970:	vmovdqa64 0x400(%rsp),%zmm28
 1f81978:	vmovdqa64 0x440(%rsp),%zmm27
 1f81980:	vmovdqa64 0x480(%rsp),%zmm26
 1f81988:	vbroadcasti32x4 -0x19d8e72(%rip),%zmm25        # 5a8b20 <.LCPI0_46>
 1f81992:	vbroadcasti32x4 -0x19d8e8c(%rip),%zmm31        # 5a8b10 <.LCPI0_45>
 1f8199c:	vbroadcasti32x4 -0x19d8ea6(%rip),%zmm24        # 5a8b00 <.LCPI0_44>
 1f819a6:	vbroadcasti32x4 -0x19d8ec0(%rip),%zmm21        # 5a8af0 <.LCPI0_43>
 1f819b0:	vmovdqa64 0x4c0(%rsp),%zmm20
 1f819b8:	vbroadcasti32x4 -0x19d8ee2(%rip),%zmm19        # 5a8ae0 <.LCPI0_42>
 1f819c2:	vbroadcasti32x4 -0x19d8efc(%rip),%zmm18        # 5a8ad0 <.LCPI0_41>
 1f819cc:	vbroadcasti32x4 -0x19d8f16(%rip),%zmm17        # 5a8ac0 <.LCPI0_40>
 1f819d6:	vbroadcasti32x4 -0x19d8f30(%rip),%zmm16        # 5a8ab0 <.LCPI0_39>
 1f819e0:	vbroadcasti32x4 -0x19d8f4a(%rip),%zmm15        # 5a8aa0 <.LCPI0_38>
 1f819ea:	vbroadcasti32x4 -0x19d8f64(%rip),%zmm14        # 5a8a90 <.LCPI0_37>
 1f819f4:	vbroadcasti32x4 -0x19d8f7e(%rip),%zmm13        # 5a8a80 <.LCPI0_36>
 1f819fe:	vbroadcasti32x4 -0x19d8f98(%rip),%zmm11        # 5a8a70 <.LCPI0_35>
 1f81a08:	vmovdqa64 0x500(%rsp),%zmm9
 1f81a10:	mov    0xa0(%rsp),%rdi
 1f81a18:	kmovq  0xa8(%rsp),%k1
 1f81a22:	mov    0x78(%rsp),%r8
 1f81a27:	kmovq  0x58(%rsp),%k7
 1f81a2e:	kmovq  0x60(%rsp),%k6
 1f81a35:	kmovq  0x68(%rsp),%k5
 1f81a3c:	mov    0x98(%rsp),%r9
 1f81a44:	mov    0x50(%rsp),%rdx
 1f81a49:	incq   0x108(%rsp)
 1f81a51:	jmp    1f81841 <node_contexts_window_loop+0xa41>
 1f81a56:	cs nopw 0x0(%rax,%rax,1)
 1f81a60:	mov    0x50(%rsp),%rdx
 1f81a65:	xor    %r14d,%r14d
 1f81a68:	vpaddb -0x1acf332(%rip),%zmm5,%zmm1        # 4b2740 <abi_test_hex.digits+0xba40>
 1f81a72:	mov    0x40(%rsp),%r10
 1f81a77:	vporq  %zmm2,%zmm6,%zmm0
 1f81a7d:	kmovq  %k1,%rax
 1f81a82:	mov    %rdx,0x50(%rsp)
 1f81a87:	mov    %r8,%rdi
 1f81a8a:	vptestnmb %zmm0,%zmm0,%k1
 1f81a90:	kmovq  %k1,%rsi
 1f81a95:	and    %rax,%rsi
 1f81a98:	and    %r10,%rdi
 1f81a9b:	vpcmpltub %zmm16,%zmm1,%k0
 1f81aa2:	kmovq  %k0,%rcx
 1f81aa7:	vptestmb %zmm4,%zmm10,%k0
 1f81aad:	kmovq  %k0,%rdx
 1f81ab2:	or     %rcx,%rsi
 1f81ab5:	andn   %r10,%rdx,%rbx
 1f81aba:	and    %rdx,%rdi
 1f81abd:	and    %r9,%rbx
 1f81ac0:	and    %rsi,%rdi
 1f81ac3:	and    %rsi,%rbx
 1f81ac6:	mov    %rdi,0x680(%rsp)
 1f81ace:	and    %r8,%rbx
 1f81ad1:	je     1f81cc0 <node_contexts_window_loop+0xec0>
 1f81ad7:	mov    0x48(%rsp),%rax
 1f81adc:	mov    0xf8(%rsp),%r13
 1f81ae4:	xor    %r15d,%r15d
 1f81ae7:	kmovq  %k7,0x58(%rsp)
 1f81aee:	kmovq  %k6,0x60(%rsp)
 1f81af5:	kmovq  %k5,0x68(%rsp)
 1f81afc:	vmovdqa64 %zmm4,0x540(%rsp)
 1f81b04:	vmovdqa64 %zmm3,0x280(%rsp)
 1f81b0c:	vmovdqa64 %zmm7,0x580(%rsp)
 1f81b14:	vmovdqa64 %zmm12,0x2c0(%rsp)
 1f81b1c:	vmovdqa64 %zmm5,0x300(%rsp)
 1f81b24:	vmovdqa64 %zmm22,0x340(%rsp)
 1f81b2c:	vmovdqa64 %zmm30,0x380(%rsp)
 1f81b34:	vmovdqa64 %zmm29,0x3c0(%rsp)
 1f81b3c:	vmovdqa64 %zmm28,0x400(%rsp)
 1f81b44:	vmovdqa64 %zmm27,0x440(%rsp)
 1f81b4c:	vmovdqa64 %zmm26,0x480(%rsp)
 1f81b54:	vmovdqa64 %zmm20,0x4c0(%rsp)
 1f81b5c:	vmovdqa64 %zmm9,0x500(%rsp)
 1f81b64:	mov    (%rax),%rcx
 1f81b67:	mov    0x2c0(%rax),%rax
 1f81b6e:	mov    %rcx,0x40(%rsp)
 1f81b73:	mov    %rax,0x1c0(%rsp)
 1f81b7b:	mov    0x80(%rsp),%rax
 1f81b83:	mov    0x40(%rsp),%rdi
 1f81b88:	mov    0x1c0(%rsp),%rsi
 1f81b90:	xor    %r12d,%r12d
 1f81b93:	tzcnt  %rbx,%r12
 1f81b98:	lea    (%rax,%r12,1),%edx
 1f81b9c:	vzeroupper
 1f81b9f:	call   1f82f30 <node_contexts_converted>
 1f81ba4:	movzbl %al,%eax
 1f81ba7:	inc    %r13
 1f81baa:	shlx   %r12,%rax,%rax
 1f81baf:	or     %rax,%r15
 1f81bb2:	blsr   %rbx,%rbx
 1f81bb7:	jne    1f81b7b <node_contexts_window_loop+0xd7b>
 1f81bb9:	vmovdqa64 0x500(%rsp),%zmm9
 1f81bc1:	vbroadcasti32x4 -0x19d915b(%rip),%zmm11        # 5a8a70 <.LCPI0_35>
 1f81bcb:	vbroadcasti32x4 -0x19d9155(%rip),%zmm10        # 5a8a80 <.LCPI0_36>
 1f81bd5:	vbroadcasti32x4 -0x19d914f(%rip),%zmm14        # 5a8a90 <.LCPI0_37>
 1f81bdf:	vbroadcasti32x4 -0x19d9149(%rip),%zmm15        # 5a8aa0 <.LCPI0_38>
 1f81be9:	vbroadcasti32x4 -0x19d9143(%rip),%zmm16        # 5a8ab0 <.LCPI0_39>
 1f81bf3:	vbroadcasti32x4 -0x19d913d(%rip),%zmm23        # 5a8ac0 <.LCPI0_40>
 1f81bfd:	vbroadcasti32x4 -0x19d9137(%rip),%zmm18        # 5a8ad0 <.LCPI0_41>
 1f81c07:	vbroadcasti32x4 -0x19d9131(%rip),%zmm6        # 5a8ae0 <.LCPI0_42>
 1f81c11:	vmovdqa64 0x4c0(%rsp),%zmm20
 1f81c19:	vbroadcasti32x4 -0x19d9133(%rip),%zmm21        # 5a8af0 <.LCPI0_43>
 1f81c23:	vbroadcasti32x4 -0x19d912d(%rip),%zmm24        # 5a8b00 <.LCPI0_44>
 1f81c2d:	vbroadcasti32x4 -0x19d9127(%rip),%zmm31        # 5a8b10 <.LCPI0_45>
 1f81c37:	vbroadcasti32x4 -0x19d9121(%rip),%zmm22        # 5a8b20 <.LCPI0_46>
 1f81c41:	vmovdqa64 0x480(%rsp),%zmm26
 1f81c49:	vmovdqa64 0x440(%rsp),%zmm27
 1f81c51:	vmovdqa64 0x400(%rsp),%zmm8
 1f81c59:	vmovdqa64 0x3c0(%rsp),%zmm29
 1f81c61:	vmovdqa64 0x380(%rsp),%zmm30
 1f81c69:	vmovdqa64 0x340(%rsp),%zmm28
 1f81c71:	vmovdqa64 0x300(%rsp),%zmm5
 1f81c79:	vmovdqa64 0x2c0(%rsp),%zmm12
 1f81c81:	vmovdqa64 0x580(%rsp),%zmm7
 1f81c89:	vmovdqa64 0x280(%rsp),%zmm3
 1f81c91:	vmovdqa64 0x540(%rsp),%zmm4
 1f81c99:	or     %r15,0x680(%rsp)
 1f81ca1:	kmovq  0x68(%rsp),%k5
 1f81ca8:	kmovq  0x60(%rsp),%k6
 1f81caf:	kmovq  0x58(%rsp),%k7
 1f81cb6:	mov    %r13,0xf8(%rsp)
 1f81cbe:	jmp    1f81ce4 <node_contexts_window_loop+0xee4>
 1f81cc0:	vmovdqa64 %zmm28,%zmm8
 1f81cc6:	vmovdqa64 %zmm22,%zmm28
 1f81ccc:	vmovdqa64 %zmm19,%zmm6
 1f81cd2:	vmovdqa64 %zmm25,%zmm22
 1f81cd8:	vmovdqa64 %zmm13,%zmm10
 1f81cde:	vmovdqa64 %zmm17,%zmm23
 1f81ce4:	vmovdqa64 0x200(%rsp),%zmm1
 1f81cec:	vpsllw $0x7,0x240(%rsp),%zmm0
 1f81cf5:	kmovq  0xb8(%rsp),%k2
 1f81cff:	kmovq  0xd0(%rsp),%k3
 1f81d09:	kmovq  0xe8(%rsp),%k4
 1f81d13:	vbroadcasti32x4 -0x19d929d(%rip),%zmm2        # 5a8a80 <.LCPI0_36>
 1f81d1d:	vbroadcasti32x4 -0x19d91e7(%rip),%zmm19        # 5a8b40 <.LCPI0_51>
 1f81d27:	vmovdqa64 0x780(%rsp),%zmm25
 1f81d2f:	mov    0x70(%rsp),%r11
 1f81d34:	vmovdqa64 %zmm11,%zmm13
 1f81d3a:	vmovdqa64 %zmm24,%zmm17
 1f81d40:	vpcmpltub %zmm24,%zmm1,%k0
 1f81d47:	vpmovb2m %zmm0,%k1
 1f81d4d:	vmovdqa64 0x700(%rsp),%zmm0
 1f81d55:	vmovdqa64 %zmm21,%zmm24
 1f81d5b:	korq   %k1,%k0,%k1
 1f81d60:	vptestmb %zmm18,%zmm27,%k0
 1f81d66:	kmovq  %k0,%rax
 1f81d6b:	vpcmpeqb %zmm14,%zmm5,%k0
 1f81d71:	vpcmpeqb %zmm16,%zmm5,%k1{%k1}
 1f81d77:	kmovq  %k0,%rcx
 1f81d7c:	vpcmpeqb %zmm31,%zmm5,%k0
 1f81d82:	mov    %rax,0x1c0(%rsp)
 1f81d8a:	vmovdqa64 %zmm23,%zmm31
 1f81d90:	kmovq  %k0,%rdx
 1f81d95:	korq   %k2,%k6,%k0
 1f81d9a:	vpcmpeqb 0x5c0(%rsp),%zmm15,%k2{%k7}
 1f81da2:	mov    %rcx,0x240(%rsp)
 1f81daa:	mov    %rdx,0x40(%rsp)
 1f81daf:	korq   %k2,%k0,%k0
 1f81db4:	kmovq  0x90(%rsp),%k2
 1f81dbe:	kmovq  %k0,%rax
 1f81dc3:	vpcmpeqb %zmm15,%zmm5,%k0{%k7}
 1f81dc9:	kmovq  %k0,%rdi
 1f81dce:	vptestnmb %zmm0,%zmm0,%k0
 1f81dd4:	mov    %rax,0x5c0(%rsp)
 1f81ddc:	vbroadcasti32x4 -0x19d9296(%rip),%zmm0        # 5a8b50 <.LCPI0_52>
 1f81de6:	kmovq  %k0,%rdx
 1f81deb:	and    %rdi,%rdx
 1f81dee:	mov    0xe0(%rsp),%rdi
 1f81df6:	vptestnmb %zmm1,%zmm1,%k0{%k2}
 1f81dfc:	vmovdqa64 0x740(%rsp),%zmm1
 1f81e04:	vptestnmb %zmm2,%zmm4,%k2
 1f81e0a:	korq   %k3,%k0,%k0
 1f81e0f:	kmovq  %k0,%r13
 1f81e14:	kandq  %k4,%k7,%k0
 1f81e19:	kmovq  %k0,%r15
 1f81e1e:	vpcmpeqb %zmm11,%zmm5,%k0
 1f81e24:	vmovdqa64 0x600(%rsp),%zmm11
 1f81e2c:	korq   %k1,%k0,%k0
 1f81e31:	vptestmb %zmm18,%zmm29,%k1
 1f81e37:	kmovq  %k1,%rsi
 1f81e3c:	vptestmb %zmm6,%zmm4,%k1{%k1}
 1f81e42:	kmovq  %k0,%rcx
 1f81e47:	and    %rsi,%r11
 1f81e4a:	andn   0x5c0(%rsp),%rdi,%rsi
 1f81e54:	and    0xc0(%rsp),%rsi
 1f81e5c:	korq   %k1,%k2,%k2
 1f81e61:	korq   %k7,%k3,%k1
 1f81e66:	vpcmpeqb %zmm21,%zmm5,%k0{%k1}
 1f81e6c:	kmovq  %k1,%r12
 1f81e71:	vpcmpeqb %zmm19,%zmm5,%k1
 1f81e77:	vpcmpeqb %zmm0,%zmm11,%k3
 1f81e7d:	kmovq  %k0,%rax
 1f81e82:	vptestnmb %zmm1,%zmm1,%k0
 1f81e88:	mov    %rsi,0x700(%rsp)
 1f81e90:	mov    0xc8(%rsp),%rsi
 1f81e98:	kmovq  %k0,%r8
 1f81e9d:	vpcmpeqb -0x1acf6e7(%rip),%zmm5,%k0{%k7}        # 4b27c0 <abi_test_hex.digits+0xbac0>
 1f81ea7:	vptestmb %zmm25,%zmm25,%k7{%k1}
 1f81ead:	and    0x40(%rsp),%r8
 1f81eb2:	andn   %r15,%rsi,%r15
 1f81eb7:	mov    0x78(%rsp),%rsi
 1f81ebc:	and    0x240(%rsp),%r15
 1f81ec4:	and    %r12,%r8
 1f81ec7:	mov    0x1c0(%rsp),%r12
 1f81ecf:	kmovq  %k7,0x600(%rsp)
 1f81ed9:	kmovq  %k0,%rbx
 1f81ede:	kxorq  %k7,%k1,%k0
 1f81ee3:	kmovq  %k0,0x780(%rsp)
 1f81eed:	kandq  %k0,%k3,%k0
 1f81ef2:	and    %rsi,%rax
 1f81ef5:	and    %rsi,%rcx
 1f81ef8:	and    %rsi,%r8
 1f81efb:	and    %rsi,%rbx
 1f81efe:	and    %rsi,%r13
 1f81f01:	and    %rsi,%rdx
 1f81f04:	kmovq  %k0,%r10
 1f81f09:	vpcmpeqb %zmm19,%zmm11,%k0
 1f81f0f:	and    %r12,%r15
 1f81f12:	mov    %rax,0x740(%rsp)
 1f81f1a:	mov    %rcx,0xc0(%rsp)
 1f81f22:	mov    %r8,0x5c0(%rsp)
 1f81f2a:	mov    %rbx,0x540(%rsp)
 1f81f32:	vmovdqa64 %zmm6,%zmm19
 1f81f38:	korq   %k0,%k3,%k0
 1f81f3d:	vpcmpeqb %zmm0,%zmm5,%k3
 1f81f43:	vbroadcasti32x4 -0x19d93ed(%rip),%zmm0        # 5a8b60 <.LCPI0_53>
 1f81f4d:	and    %rsi,%r15
 1f81f50:	and    %rsi,%r10
 1f81f53:	kandq  %k0,%k3,%k0
 1f81f58:	mov    %r15,%rbx
 1f81f5b:	mov    %r10,0x200(%rsp)
 1f81f63:	kmovq  %k3,0xd0(%rsp)
 1f81f6d:	kandq  %k2,%k0,%k0
 1f81f72:	kmovq  %k0,%r9
 1f81f77:	vptestnmb %zmm14,%zmm4,%k0{%k1}
 1f81f7d:	and    %rsi,%r9
 1f81f80:	mov    %r9,0x78(%rsp)
 1f81f85:	kmovq  %k0,%rax
 1f81f8a:	vptestnmb %zmm14,%zmm29,%k0
 1f81f90:	vpcmpeqb %zmm0,%zmm5,%k1
 1f81f96:	and    %rsi,%rax
 1f81f99:	kmovq  %k0,%rsi
 1f81f9e:	vptestmb %zmm15,%zmm29,%k0
 1f81fa4:	kmovq  %k0,%rcx
 1f81fa9:	vptestmb %zmm23,%zmm27,%k0{%k1}
 1f81faf:	kmovq  0xd8(%rsp),%k1
 1f81fb9:	and    %rsi,%r11
 1f81fbc:	mov    %rax,0xb8(%rsp)
 1f81fc4:	mov    %rsi,0xc8(%rsp)
 1f81fcc:	andn   %rdx,%r11,%rax
 1f81fd1:	and    %r11,%rdx
 1f81fd4:	andn   %rdx,%rcx,%r11
 1f81fd9:	and    %rcx,%rdx
 1f81fdc:	mov    %rax,0x60(%rsp)
 1f81fe1:	kmovq  %k6,%rax
 1f81fe6:	mov    %rdx,0x580(%rsp)
 1f81fee:	kmovq  %k5,%rdx
 1f81ff3:	mov    %r11,0x68(%rsp)
 1f81ff8:	and    %rdx,%rax
 1f81ffb:	kmovq  %k0,%rcx
 1f82000:	vptestmb %zmm6,%zmm26,%k0
 1f82006:	and    %r12,%rax
 1f82009:	mov    $0x0,%r12d
 1f8200f:	korq   %k4,%k0,%k0
 1f82014:	and    %rcx,0x130(%rsp)
 1f8201c:	mov    %rax,0x58(%rsp)
 1f82021:	korq   %k1,%k0,%k0
 1f82026:	vpcmpeqb %zmm0,%zmm11,%k1
 1f8202c:	vporq  %zmm7,%zmm4,%zmm0
 1f82032:	knotq  %k0,%k0
 1f82037:	kmovq  %k1,%rcx
 1f8203c:	vptestmb %zmm2,%zmm29,%k1
 1f82042:	kmovq  %k0,%rdi
 1f82047:	vptestmb %zmm15,%zmm27,%k0
 1f8204d:	kmovq  %k1,0xe0(%rsp)
 1f82057:	kmovq  %k0,%r8
 1f8205c:	kandq  %k7,%k1,%k0
 1f82061:	and    %rcx,%rdi
 1f82064:	kmovq  %k0,%rdx
 1f82069:	vptestnmb %zmm14,%zmm0,%k0
 1f8206f:	and    %r8,%rbx
 1f82072:	mov    %rdi,0x40(%rsp)
 1f82077:	mov    %r8,0xe8(%rsp)
 1f8207f:	or     %r10,%rdx
 1f82082:	kmovq  %k0,%rcx
 1f82087:	or     %r9,%rdx
 1f8208a:	and    %rdx,%rcx
 1f8208d:	cmpb   $0x0,0x3f(%rsp)
 1f82092:	mov    %rdx,0xd8(%rsp)
 1f8209a:	mov    %rcx,0x70(%rsp)
 1f8209f:	jne    1f82668 <node_contexts_window_loop+0x1868>
 1f820a5:	vmovdqa64 %zmm12,%zmm6
 1f820ab:	vmovdqa64 0x640(%rsp),%zmm12
 1f820b3:	mov    0xf0(%rsp),%rcx
 1f820bb:	mov    0x88(%rsp),%rax
 1f820c3:	kmovq  0x90(%rsp),%k7
 1f820cd:	vmovdqa64 %zmm13,%zmm11
 1f820d3:	vmovdqa64 %zmm24,%zmm21
 1f820d9:	vmovdqa64 %zmm10,%zmm13
 1f820df:	vpxor  %xmm7,%xmm7,%xmm7
 1f820e3:	vmovdqa64 %zmm22,%zmm25
 1f820e9:	vmovdqa64 %zmm17,%zmm24
 1f820ef:	mov    0x700(%rsp),%rdx
 1f820f7:	mov    0x188(%rsp),%r8
 1f820ff:	or     %rax,%r13
 1f82102:	mov    0x60(%rsp),%r10
 1f82107:	mov    0x740(%rsp),%r11
 1f8210f:	mov    0xb8(%rsp),%rsi
 1f82117:	mov    0x580(%rsp),%rdi
 1f8211f:	vptestmb %zmm3,%zmm3,%k6
 1f82125:	kmovq  0x780(%rsp),%k0
 1f8212f:	vmovdqa64 %zmm31,%zmm17
 1f82135:	vmovdqu8 %zmm14,%zmm2{%k6}{z}
 1f8213b:	mov    %r13,0x1c0(%rsp)
 1f82143:	mov    0x40(%rsp),%r13
 1f82148:	and    0x58(%rsp),%r13
 1f8214d:	or     %rbx,%rdx
 1f82150:	andn   %r8,%r14,%rax
 1f82155:	mov    0x540(%rsp),%rbx
 1f8215d:	andn   %rcx,%rax,%r9
 1f82162:	mov    0x68(%rsp),%rax
 1f82167:	mov    %r10,%rcx
 1f8216a:	or     %r11,%rdx
 1f8216d:	or     %r10,%r11
 1f82170:	or     0xc0(%rsp),%r11
 1f82178:	and    %r9,%r8
 1f8217b:	or     %rbx,%rcx
 1f8217e:	or     %rax,%rcx
 1f82181:	or     %rax,%r15
 1f82184:	or     %rdx,%rcx
 1f82187:	mov    %rsi,%rdx
 1f8218a:	or     %rbx,%rsi
 1f8218d:	or     %rdi,%rdx
 1f82190:	or     %rdi,%r15
 1f82193:	or     %rdi,%rsi
 1f82196:	mov    0x680(%rsp),%rdi
 1f8219e:	or     %r11,%r15
 1f821a1:	or     %r11,%rdx
 1f821a4:	mov    0x5c0(%rsp),%r11
 1f821ac:	or     %r14,%r15
 1f821af:	kmovq  %r15,%k3
 1f821b4:	mov    0x104(%rsp),%r15d
 1f821bc:	or     %rdi,%rcx
 1f821bf:	or     %rdi,%rdx
 1f821c2:	or     %r10,%r11
 1f821c5:	kmovq  %rcx,%k4
 1f821ca:	kmovq  %rdx,%k1
 1f821cf:	mov    0x130(%rsp),%rdx
 1f821d7:	or     %rax,%r11
 1f821da:	mov    %r9,%rax
 1f821dd:	kmovq  %k0,%rcx
 1f821e2:	vpcmpeqb %zmm11,%zmm28,%k0
 1f821e8:	vmovdqu8 -0x1acfeb2(%rip),%zmm1{%k4}{z}        # 4b2340 <abi_test_hex.digits+0xb640>
 1f821f2:	or     %r11,%rsi
 1f821f5:	kmovq  %r8,%k4
 1f821fa:	or     %r14,%rsi
 1f821fd:	mov    0x200(%rsp),%r14
 1f82205:	or     %rdi,%rsi
 1f82208:	mov    0x160(%rsp),%rdi
 1f82210:	kmovq  %rsi,%k2
 1f82215:	mov    0xc8(%rsp),%rsi
 1f8221d:	kmovq  %rdx,%k5
 1f82222:	kmovq  %k0,%rdx
 1f82227:	xor    %r14,%rcx
 1f8222a:	vporq  %zmm18,%zmm1,%zmm0
 1f82230:	andn   %r9,%rsi,%rsi
 1f82235:	mov    0x80(%rsp),%r9
 1f8223d:	vmovdqu8 %zmm0,%zmm1{%k3}
 1f82243:	vporq  %zmm16,%zmm1,%zmm0
 1f82249:	kmovq  %rsi,%k6
 1f8224e:	mov    0x70(%rsp),%rsi
 1f82253:	vmovdqu8 %zmm0,%zmm1{%k1}
 1f82259:	vpord  -0x19d09f7(%rip){1to16},%zmm1,%zmm0        # 5b186c <.LCPI0_54>
 1f82263:	kmovq  %rax,%k1
 1f82268:	vmovdqu8 %zmm0,%zmm1{%k2}
 1f8226e:	vmovdqu8 -0x1acf9b8(%rip),%zmm1{%k5}        # 4b28c0 <abi_test_hex.digits+0xbbc0>
 1f82278:	vmovdqu8 -0x1acf982(%rip),%zmm1{%k1}        # 4b2900 <abi_test_hex.digits+0xbc00>
 1f82282:	kmovq  %rsi,%k1
 1f82287:	mov    0x128(%rsp),%rsi
 1f8228f:	vmovdqu8 -0x1acf959(%rip),%zmm1{%k1}        # 4b2940 <abi_test_hex.digits+0xbc40>
 1f82299:	kmovq  0x1a8(%rsp),%k1
 1f822a3:	vmovdqa64 %zmm1,%zmm0
 1f822a9:	vpaddb %zmm16,%zmm1,%zmm0{%k6}
 1f822af:	vpaddb %zmm18,%zmm0,%zmm0{%k4}
 1f822b5:	vpermi2b %zmm8,%zmm0,%zmm30{%k1}{z}
 1f822bb:	kmovq  0x118(%rsp),%k1
 1f822c5:	vmovdqu8 0x900(%rsp),%zmm30{%k1}
 1f822cd:	vpaddw %zmm30,%zmm30,%zmm3
 1f822d3:	vporq  %zmm2,%zmm3,%zmm2
 1f822d9:	vpermb 0x80(%rsi),%zmm2,%zmm2
 1f822e0:	mov    0xd8(%rsp),%rsi
 1f822e8:	vmovdqu64 %zmm1,(%rdi,%r9,1)
 1f822ef:	vpandd -0x19d0a89(%rip){1to16},%zmm2,%zmm3        # 5b1870 <.LCPI0_55>
 1f822f9:	or     %rdx,%rsi
 1f822fc:	mov    $0xffffffffffffffff,%rdx
 1f82303:	not    %rsi
 1f82306:	kmovq  %rsi,%k1
 1f8230b:	mov    0x150(%rsp),%rsi
 1f82313:	vmovdqu8 %zmm3,%zmm3{%k1}{z}
 1f82319:	vmovdqu64 %zmm3,(%rsi,%r9,1)
 1f82320:	mov    %r15d,%esi
 1f82323:	sub    %r9d,%esi
 1f82326:	jbe    1f8233f <node_contexts_window_loop+0x153f>
 1f82328:	lea    0x40(%r9),%edx
 1f8232c:	cmp    %edx,%r15d
 1f8232f:	mov    $0xffffffffffffffff,%rdx
 1f82336:	shlx   %rsi,%rdx,%rdx
 1f8233b:	cmovae %r12,%rdx
 1f8233f:	kmovq  0xe0(%rsp),%k0
 1f82349:	mov    0x240(%rsp),%r11
 1f82351:	vpmovb2m %zmm2,%k1
 1f82357:	vmovdqa64 0xac0(%rsp),%zmm10
 1f8235f:	vbroadcasti32x4 -0x19d9859(%rip),%zmm31        # 5a8b10 <.LCPI0_45>
 1f82369:	vmovdqa64 0xb00(%rsp),%zmm8
 1f82371:	mov    %r13,0x40(%rsp)
 1f82376:	kmovq  %k0,%rsi
 1f8237b:	vptestmb %zmm16,%zmm29,%k0
 1f82381:	and    %r11,0x1c0(%rsp)
 1f82389:	kmovq  %k0,%rdi
 1f8238e:	kmovq  0xd0(%rsp),%k0
 1f82398:	and    %rsi,%rcx
 1f8239b:	kmovq  %k1,%rsi
 1f823a0:	and    %rdi,%r14
 1f823a3:	mov    0xe8(%rsp),%rdi
 1f823ab:	mov    %r14,0x200(%rsp)
 1f823b3:	mov    %r9,%r14
 1f823b6:	kmovq  %k0,%r8
 1f823bb:	and    %r13,%rdi
 1f823be:	xor    %r8,0x78(%rsp)
 1f823c3:	andn   %rsi,%rdi,%rbx
 1f823c8:	mov    0x110(%rsp),%rsi
 1f823d0:	mov    %rbx,%rdi
 1f823d3:	or     %r11,%rdi
 1f823d6:	andn   0x98(%rsp),%rdi,%rdi
 1f823e0:	je     1f810c0 <node_contexts_window_loop+0x2c0>
 1f823e6:	cs nopw 0x0(%rax,%rax,1)
 1f823f0:	xor    %r8d,%r8d
 1f823f3:	tzcnt  %rdi,%r8
 1f823f8:	mov    $0xffffffffffffffff,%r13
 1f823ff:	mov    %r15d,%r11d
 1f82402:	lea    (%r14,%r8,1),%r9d
 1f82406:	sub    0x651b8(%rsi,%r9,4),%r9d
 1f8240e:	lea    0x1(%r9),%r9d
 1f82412:	cmovb  %r12d,%r9d
 1f82416:	mov    %r9d,%r10d
 1f82419:	sub    %r14d,%r10d
 1f8241c:	cmp    %r15d,%r9d
 1f8241f:	cmovb  %r9d,%r11d
 1f82423:	cmp    %r14d,%r9d
 1f82426:	shlx   %r10,%r13,%r9
 1f8242b:	movabs $0x7fffffffffffffff,%r13
 1f82435:	cmovbe %r13,%r9
 1f82439:	cmovb  %r11d,%r15d
 1f8243d:	bzhi   %r8,%r9,%r8
 1f82442:	or     %r8,%rdx
 1f82445:	blsr   %rdi,%rdi
 1f8244a:	jne    1f823f0 <node_contexts_window_loop+0x15f0>
 1f8244c:	jmp    1f810c0 <node_contexts_window_loop+0x2c0>
 1f82451:	kmovq  %k5,%rax
 1f82456:	test   %rax,%rax
 1f82459:	je     1f824d5 <node_contexts_window_loop+0x16d5>
 1f8245b:	mov    0x48(%rsp),%rcx
 1f82460:	mov    %rax,%rdx
 1f82463:	mov    0xba8(%rcx),%rcx
 1f8246a:	xor    %r11d,%r11d
 1f8246d:	tzcnt  %rdx,%r11
 1f82472:	lea    (%rbx,%r11,1),%edi
 1f82476:	movzwl 0x6f654(%rsi,%rdi,2),%r8d
 1f8247f:	add    %edi,%r8d
 1f82482:	movzwl 0x6b554(%rsi,%r8,2),%r10d
 1f8248b:	movzbl 0x2c(%rsi,%r8,1),%edi
 1f82491:	movzbl (%rcx,%r8,1),%r9d
 1f82496:	sub    %r10d,%r8d
 1f82499:	and    $0x7f,%edi
 1f8249c:	testb  $0x7f,0x2c(%rsi,%r8,1)
 1f824a2:	movzbl (%r14,%rdi,1),%edi
 1f824a7:	setne  %r8b
 1f824ab:	mov    %dil,0x8c0(%rsp,%r11,1)
 1f824b3:	add    %r8b,%r8b
 1f824b6:	or     $0x14,%r8b
 1f824ba:	cmp    $0x14,%r9b
 1f824be:	movzbl %r8b,%edi
 1f824c2:	cmovne %r9d,%edi
 1f824c6:	blsr   %rdx,%rdx
 1f824cb:	mov    %dil,0x900(%rsp,%r11,1)
 1f824d3:	jne    1f8246a <node_contexts_window_loop+0x166a>
 1f824d5:	kmovq  %k1,%rcx
 1f824da:	vpxor  %xmm10,%xmm10,%xmm10
 1f824df:	test   %rcx,%rcx
 1f824e2:	je     1f82598 <node_contexts_window_loop+0x1798>
 1f824e8:	mov    0x48(%rsp),%r9
 1f824ed:	mov    %rcx,%r10
 1f824f0:	mov    0xb80(%r9),%rdx
 1f824f7:	mov    0xb88(%r9),%r15
 1f824fe:	mov    0xb90(%r9),%rdi
 1f82505:	mov    0xba0(%r9),%r8
 1f8250c:	mov    0xb98(%r9),%r9
 1f82513:	mov    0x80(%rsp),%rbx
 1f8251b:	xor    %r11d,%r11d
 1f8251e:	tzcnt  %r10,%r11
 1f82523:	add    %r11d,%ebx
 1f82526:	movzwl 0x6b554(%rsi,%rbx,2),%r14d
 1f8252f:	sub    %r14d,%ebx
 1f82532:	movzbl 0x2c(%rsi,%rbx,1),%r14d
 1f82538:	and    $0x7f,%r14b
 1f8253c:	blsr   %r10,%r10
 1f82541:	mov    %r14b,0x940(%rsp,%r11,1)
 1f82549:	movzbl (%rdx,%rbx,1),%r14d
 1f8254e:	mov    %r14b,0x980(%rsp,%r11,1)
 1f82556:	movzbl (%r15,%rbx,1),%r14d
 1f8255b:	mov    %r14b,0x9c0(%rsp,%r11,1)
 1f82563:	movzbl (%rdi,%rbx,1),%r14d
 1f82568:	mov    %r14b,0xa00(%rsp,%r11,1)
 1f82570:	movzbl (%r8,%rbx,1),%r14d
 1f82575:	mov    %r14b,0xa40(%rsp,%r11,1)
 1f8257d:	movzbl (%r9,%rbx,1),%ebx
 1f82582:	mov    %bl,0xa80(%rsp,%r11,1)
 1f8258a:	mov    0x80(%rsp),%rbx
 1f82592:	jne    1f82513 <node_contexts_window_loop+0x1713>
 1f82598:	vmovdqa64 0x940(%rsp),%zmm3
 1f825a0:	vmovdqa64 0x980(%rsp),%zmm12
 1f825a8:	vmovdqa64 0xa00(%rsp),%zmm5
 1f825b0:	vmovdqa64 0xa80(%rsp),%zmm4
 1f825b8:	kmovq  0x118(%rsp),%k2
 1f825c2:	popcnt %rax,%rax
 1f825c7:	add    0xb0(%rsp),%rax
 1f825cf:	or     %rcx,0x70(%rsp)
 1f825d4:	popcnt %rcx,%rdx
 1f825d9:	vpermb 0x800(%rsp),%zmm4,%zmm4
 1f825e1:	vmovdqu8 0x8c0(%rsp),%zmm0{%k2}
 1f825e9:	add    %rdx,%rax
 1f825ec:	mov    %rax,0xb0(%rsp)
 1f825f4:	vpermt2b %zmm2,%zmm3,%zmm1
 1f825fa:	vpermb 0x840(%rsp),%zmm12,%zmm3
 1f82602:	vpbroadcastq -0x19d3814(%rip),%zmm12        # 5aedf8 <.LCPI0_0>
 1f8260c:	vpermb 0x880(%rsp),%zmm5,%zmm2
 1f82614:	vpermb 0x7c0(%rsp),%zmm1,%zmm1
 1f8261c:	vpternlogq $0xf8,0x9c0(%rsp),%zmm12,%zmm2
 1f82625:	vpternlogq $0xfe,%zmm4,%zmm3,%zmm2
 1f8262c:	vpbroadcastq -0x19d3836(%rip),%zmm4        # 5aee00 <.LCPI0_1>
 1f82636:	vpternlogq $0xf8,0xa40(%rsp),%zmm4,%zmm1
 1f8263f:	vmovdqa64 %zmm6,%zmm4
 1f82645:	vmovdqu8 %zmm2,%zmm4{%k1}
 1f8264b:	vpandd -0x19d0df5(%rip){1to16},%zmm0,%zmm2        # 5b1860 <.LCPI0_47>
 1f82655:	vmovdqu8 %zmm1,%zmm29{%k1}
 1f8265b:	vmovdqa64 %zmm2,0x600(%rsp)
 1f82663:	jmp    1f81501 <node_contexts_window_loop+0x701>
 1f82668:	mov    0xf0(%rsp),%rcx
 1f82670:	kmovq  0x90(%rsp),%k7
 1f8267a:	vmovdqa64 %zmm13,%zmm11
 1f82680:	vmovdqa64 %zmm22,%zmm25
 1f82686:	vmovdqa64 %zmm12,%zmm6
 1f8268c:	test   %rcx,%rcx
 1f8268f:	je     1f826cb <node_contexts_window_loop+0x18cb>
 1f82691:	mov    0x48(%rsp),%rax
 1f82696:	vmovdqa64 0x640(%rsp),%zmm12
 1f8269e:	mov    (%rax),%rax
 1f826a1:	mov    0x8(%rax),%rax
 1f826a5:	cmpb   $0x1,0x14a(%rax)
 1f826ac:	je     1f826f2 <node_contexts_window_loop+0x18f2>
 1f826ae:	mov    0x88(%rsp),%rax
 1f826b6:	vmovdqa64 %zmm24,%zmm21
 1f826bc:	vmovdqa64 %zmm10,%zmm13
 1f826c2:	vpxor  %xmm7,%xmm7,%xmm7
 1f826c6:	jmp    1f820e9 <node_contexts_window_loop+0x12e9>
 1f826cb:	vmovdqa64 0x640(%rsp),%zmm12
 1f826d3:	mov    0x88(%rsp),%rax
 1f826db:	vmovdqa64 %zmm24,%zmm21
 1f826e1:	xor    %ecx,%ecx
 1f826e3:	vmovdqa64 %zmm10,%zmm13
 1f826e9:	vpxor  %xmm7,%xmm7,%xmm7
 1f826ed:	jmp    1f820e9 <node_contexts_window_loop+0x12e9>
 1f826f2:	mov    0x48(%rsp),%rdx
 1f826f7:	mov    %rax,0x6c0(%rsp)
 1f826ff:	mov    %r13,0x1c0(%rsp)
 1f82707:	vmovdqa64 %zmm3,0x280(%rsp)
 1f8270f:	vmovdqa64 %zmm6,0x2c0(%rsp)
 1f82717:	vmovdqa64 %zmm5,0x300(%rsp)
 1f8271f:	vmovdqa64 %zmm28,0x340(%rsp)
 1f82727:	vmovdqa64 %zmm30,0x380(%rsp)
 1f8272f:	vmovdqa64 %zmm29,0x3c0(%rsp)
 1f82737:	vmovdqa64 %zmm8,0x400(%rsp)
 1f8273f:	vmovdqa64 %zmm27,0x440(%rsp)
 1f82747:	vmovdqa64 %zmm26,0x480(%rsp)
 1f8274f:	vmovdqa64 %zmm20,0x4c0(%rsp)
 1f82757:	vmovdqa64 %zmm9,0x500(%rsp)
 1f8275f:	xor    %r12d,%r12d
 1f82762:	mov    %rcx,%r13
 1f82765:	mov    0x2c0(%rdx),%rax
 1f8276c:	mov    %rax,0xa0(%rsp)
 1f82774:	jmp    1f827a1 <node_contexts_window_loop+0x19a1>
 1f82776:	lea    -0x1ab9b68(%rip),%rdx        # 4c8c15 <check_lower_segment_override.segments>
 1f8277d:	xor    %ecx,%ecx
 1f8277f:	testb  $0x3,-0x110(%rax,%rdx,1)
 1f82787:	setne  %cl
 1f8278a:	mov    0xa8(%rsp),%rax
 1f82792:	shlx   %rax,%rcx,%rax
 1f82797:	or     %rax,%r12
 1f8279a:	blsr   %r13,%r13
 1f8279f:	je     1f82803 <node_contexts_window_loop+0x1a03>
 1f827a1:	mov    0x80(%rsp),%rax
 1f827a9:	xor    %ecx,%ecx
 1f827ab:	tzcnt  %r13,%rcx
 1f827b0:	mov    0xa0(%rsp),%rdx
 1f827b8:	mov    0x6c0(%rsp),%rdi
 1f827c0:	mov    %rcx,0xa8(%rsp)
 1f827c8:	add    %ecx,%eax
 1f827ca:	mov    0x110(%rsp),%rcx
 1f827d2:	movzwl 0x6b554(%rcx,%rax,2),%ecx
 1f827da:	sub    %ecx,%eax
 1f827dc:	shl    $0x6,%rax
 1f827e0:	mov    (%rdx,%rax,1),%esi
 1f827e3:	vzeroupper
 1f827e6:	call   1f2a830 <type_object_qualifiers_slow>
 1f827eb:	and    $0xffffff,%eax
 1f827f0:	lea    -0x110(%rax),%ecx
 1f827f6:	cmp    $0x2,%ecx
 1f827f9:	jbe    1f82776 <node_contexts_window_loop+0x1976>
 1f827ff:	xor    %ecx,%ecx
 1f82801:	jmp    1f8278a <node_contexts_window_loop+0x198a>
 1f82803:	vmovdqa64 0x500(%rsp),%zmm9
 1f8280b:	vbroadcasti32x4 -0x19d9da5(%rip),%zmm11        # 5a8a70 <.LCPI0_35>
 1f82815:	vbroadcasti32x4 -0x19d9d9f(%rip),%zmm13        # 5a8a80 <.LCPI0_36>
 1f8281f:	vbroadcasti32x4 -0x19d9d99(%rip),%zmm14        # 5a8a90 <.LCPI0_37>
 1f82829:	vbroadcasti32x4 -0x19d9d93(%rip),%zmm15        # 5a8aa0 <.LCPI0_38>
 1f82833:	vbroadcasti32x4 -0x19d9d8d(%rip),%zmm16        # 5a8ab0 <.LCPI0_39>
 1f8283d:	vbroadcasti32x4 -0x19d9d87(%rip),%zmm31        # 5a8ac0 <.LCPI0_40>
 1f82847:	vbroadcasti32x4 -0x19d9d81(%rip),%zmm18        # 5a8ad0 <.LCPI0_41>
 1f82851:	vbroadcasti32x4 -0x19d9d7b(%rip),%zmm19        # 5a8ae0 <.LCPI0_42>
 1f8285b:	vmovdqa64 0x4c0(%rsp),%zmm20
 1f82863:	vbroadcasti32x4 -0x19d9d7d(%rip),%zmm21        # 5a8af0 <.LCPI0_43>
 1f8286d:	vbroadcasti32x4 -0x19d9d77(%rip),%zmm24        # 5a8b00 <.LCPI0_44>
 1f82877:	vbroadcasti32x4 -0x19d9d61(%rip),%zmm25        # 5a8b20 <.LCPI0_46>
 1f82881:	vmovdqa64 0x480(%rsp),%zmm26
 1f82889:	vmovdqa64 0x640(%rsp),%zmm12
 1f82891:	vmovdqa64 0x440(%rsp),%zmm27
 1f82899:	vmovdqa64 0x400(%rsp),%zmm8
 1f828a1:	vmovdqa64 0x3c0(%rsp),%zmm29
 1f828a9:	vmovdqa64 0x380(%rsp),%zmm30
 1f828b1:	vmovdqa64 0x340(%rsp),%zmm28
 1f828b9:	vmovdqa64 0x300(%rsp),%zmm5
 1f828c1:	vmovdqa64 0x2c0(%rsp),%zmm6
 1f828c9:	vmovdqa64 0x280(%rsp),%zmm3
 1f828d1:	mov    0xf0(%rsp),%rcx
 1f828d9:	kmovq  0x90(%rsp),%k7
 1f828e3:	mov    0x1c0(%rsp),%r13
 1f828eb:	mov    0x88(%rsp),%rax
 1f828f3:	vpxor  %xmm7,%xmm7,%xmm7
 1f828f7:	andn   %rcx,%r12,%rcx
 1f828fc:	xor    %r12d,%r12d
 1f828ff:	jmp    1f820ef <node_contexts_window_loop+0x12ef>
 1f82904:	vmovq  0xb0(%rsp),%xmm0
 1f8290d:	mov    0x138(%rsp),%rcx
 1f82915:	mov    0x50(%rsp),%rax
 1f8291a:	mov    0x108(%rsp),%rdx
 1f82922:	vmovq  %r13,%xmm1
 1f82927:	vpunpcklqdq %xmm0,%xmm1,%xmm0
 1f8292b:	vmovq  %rdx,%xmm1
 1f82930:	vmovq  %rax,%xmm2
 1f82935:	vpunpcklqdq %xmm1,%xmm2,%xmm1
 1f82939:	vinserti128 $0x1,%xmm0,%ymm1,%ymm0
 1f8293f:	vinserti64x4 $0x1,%ymm8,%zmm0,%zmm0
 1f82946:	vpaddq (%rcx),%zmm0,%zmm0
 1f8294c:	vmovdqu64 %zmm0,(%rcx)
 1f82952:	lea    -0x28(%rbp),%rsp
 1f82956:	pop    %rbx
 1f82957:	pop    %r12
 1f82959:	pop    %r13
 1f8295b:	pop    %r14
 1f8295d:	pop    %r15
 1f8295f:	pop    %rbp
 1f82960:	vzeroupper
 1f82963:	ret
Disassembly of section .init:
Disassembly of section .fini:
Disassembly of section .iplt:
