compiler:     file format elf64-x86-64
Disassembly of section .text.buster_start:
Disassembly of section .text.buster_checker:
Disassembly of section .text:
0000000001f80dc0 <node_contexts_window_loop>:
 1f80dc0:	push   %rbp
 1f80dc1:	mov    %rsp,%rbp
 1f80dc4:	push   %r15
 1f80dc6:	push   %r14
 1f80dc8:	push   %r13
 1f80dca:	push   %r12
 1f80dcc:	push   %rbx
 1f80dcd:	and    $0xffffffffffffffc0,%rsp
 1f80dd1:	sub    $0x980,%rsp
 1f80dd8:	mov    (%rdi),%rax
 1f80ddb:	mov    0xb38(%rdi),%r14
 1f80de2:	add    $0x3f,%edx
 1f80de5:	vpxor  %xmm0,%xmm0,%xmm0
 1f80de9:	mov    0x8(%rax),%rax
 1f80ded:	movzbl 0x14a(%rax),%eax
 1f80df4:	vmovdqa64 %zmm0,0x900(%rsp)
 1f80dfc:	vmovdqa64 %zmm0,0x8c0(%rsp)
 1f80e04:	vmovdqa64 %zmm0,0x880(%rsp)
 1f80e0c:	vmovdqa64 %zmm0,0x840(%rsp)
 1f80e14:	vmovdqa64 %zmm0,0x800(%rsp)
 1f80e1c:	vmovdqa64 %zmm0,0x7c0(%rsp)
 1f80e24:	vmovdqa64 %zmm0,0x780(%rsp)
 1f80e2c:	vmovdqa64 %zmm0,0x740(%rsp)
 1f80e34:	mov    %al,0x2f(%rsp)
 1f80e38:	cmp    $0x40,%edx
 1f80e3b:	jae    1f80e4a <node_contexts_window_loop+0x8a>
 1f80e3d:	xor    %edx,%edx
 1f80e3f:	xor    %eax,%eax
 1f80e41:	vpxor  %xmm5,%xmm5,%xmm5
 1f80e45:	jmp    1f82775 <node_contexts_window_loop+0x19b5>
 1f80e4a:	vbroadcasti32x4 -0x19d8464(%rip),%zmm9        # 5a89f0 <.LCPI0_36>
 1f80e54:	vbroadcasti32x4 -0x19d845e(%rip),%zmm10        # 5a8a00 <.LCPI0_37>
 1f80e5e:	vbroadcasti32x4 -0x19d8458(%rip),%zmm11        # 5a8a10 <.LCPI0_38>
 1f80e68:	vbroadcasti32x4 -0x19d8452(%rip),%zmm12        # 5a8a20 <.LCPI0_39>
 1f80e72:	vbroadcasti32x4 -0x19d844c(%rip),%zmm14        # 5a8a30 <.LCPI0_40>
 1f80e7c:	vbroadcasti32x4 -0x19d8446(%rip),%zmm15        # 5a8a40 <.LCPI0_41>
 1f80e86:	vbroadcasti32x4 -0x19d8440(%rip),%zmm16        # 5a8a50 <.LCPI0_42>
 1f80e90:	vbroadcasti32x4 -0x19d843a(%rip),%zmm17        # 5a8a60 <.LCPI0_43>
 1f80e9a:	vbroadcasti32x4 -0x19d8434(%rip),%zmm18        # 5a8a70 <.LCPI0_44>
 1f80ea4:	vbroadcasti32x4 -0x19d842e(%rip),%zmm19        # 5a8a80 <.LCPI0_45>
 1f80eae:	vbroadcasti32x4 -0x19d8428(%rip),%zmm20        # 5a8a90 <.LCPI0_46>
 1f80eb8:	vbroadcasti32x4 -0x19d8422(%rip),%zmm21        # 5a8aa0 <.LCPI0_47>
 1f80ec2:	shr    $0x6,%edx
 1f80ec5:	mov    $0xffffffff,%r12d
 1f80ecb:	mov    %rcx,0x148(%rsp)
 1f80ed3:	vpxor  %xmm5,%xmm5,%xmm5
 1f80ed7:	vpxord %xmm27,%xmm27,%xmm27
 1f80edd:	movq   $0x0,0x58(%rsp)
 1f80ee6:	movq   $0x0,0xb0(%rsp)
 1f80ef2:	movq   $0x0,0xa8(%rsp)
 1f80efe:	movq   $0x0,0x108(%rsp)
 1f80f0a:	vpxord %xmm22,%xmm22,%xmm22
 1f80f10:	vpxord %xmm28,%xmm28,%xmm28
 1f80f16:	mov    %rdi,0x48(%rsp)
 1f80f1b:	mov    %rsi,0x80(%rsp)
 1f80f23:	mov    %r14,0x118(%rsp)
 1f80f2b:	jmp    1f810c0 <node_contexts_window_loop+0x300>
 1f80f30:	kmovq  0x150(%rsp),%k1
 1f80f3a:	vpcmpeqb %zmm20,%zmm4,%k0
 1f80f40:	vpcmpeqb -0x1acec0a(%rip),%zmm4,%k3        # 4b2340 <abi_test_hex.digits+0xb640>
 1f80f4a:	vpaddb -0x1ace7d4(%rip),%zmm4,%zmm3        # 4b2780 <abi_test_hex.digits+0xba80>
 1f80f54:	vpandq %zmm21,%zmm26,%zmm2
 1f80f5a:	mov    0x180(%rsp),%rbx
 1f80f62:	mov    0x300(%rsp),%rdi
 1f80f6a:	mov    0x160(%rsp),%r11
 1f80f72:	mov    0x30(%rsp),%r14
 1f80f77:	vpcmpeqb %zmm16,%zmm4,%k2
 1f80f7d:	mov    0xa0(%rsp),%r10
 1f80f85:	vmovdqa64 %zmm23,%zmm27
 1f80f8b:	vmovdqa64 %zmm0,%zmm28
 1f80f91:	or     0x1c0(%rsp),%rbx
 1f80f99:	andn   0x38(%rsp),%rdi,%r9
 1f80fa0:	mov    0x48(%rsp),%rdi
 1f80fa5:	vpcmpeqb %zmm9,%zmm24,%k2{%k2}
 1f80fab:	or     0x200(%rsp),%rbx
 1f80fb3:	korq   %k1,%k0,%k0
 1f80fb8:	kmovq  0x158(%rsp),%k1
 1f80fc2:	vmovq  %r11,%xmm4
 1f80fc7:	or     %rcx,%rbx
 1f80fca:	andn   %r11,%r14,%rcx
 1f80fcf:	vptestnmb %zmm2,%zmm2,%k3{%k3}
 1f80fd5:	or     %rcx,%rbx
 1f80fd8:	andn   %r10,%rdx,%rcx
 1f80fdd:	mov    0xbd0(%rdi),%rdx
 1f80fe4:	and    %rax,%rcx
 1f80fe7:	kandq  %k1,%k0,%k0
 1f80fec:	vpcmpltub -0x1ace7f7(%rip),%zmm3,%k1        # 4b2800 <abi_test_hex.digits+0xbb00>
 1f80ff7:	vmovq  %r14,%xmm3
 1f80ffc:	mov    0x118(%rsp),%r14
 1f81004:	korq   %k3,%k1,%k1
 1f81009:	vpmovb2m %zmm25,%k3
 1f8100f:	korq   %k3,%k1,%k1
 1f81014:	korq   %k0,%k1,%k1
 1f81019:	korq   %k2,%k1,%k1
 1f8101e:	kmovq  %k1,%r8
 1f81023:	vptestnmb %zmm1,%zmm1,%k1
 1f81029:	kmovq  %k1,%r15
 1f8102e:	or     %r9,%r8
 1f81031:	mov    0x170(%rsp),%r9
 1f81039:	kmovq  0x128(%rsp),%k1
 1f81043:	or     %r8,%rbx
 1f81046:	and    %rcx,%r15
 1f81049:	and    %r10,%rbx
 1f8104c:	mov    %r9d,%eax
 1f8104f:	shl    $0x6,%rax
 1f81053:	kandq  %k1,%k0,%k0
 1f81058:	vpcmpgtb %zmm25,%zmm13,%k1{%k1}
 1f8105e:	mov    %rcx,(%rdx,%rax,1)
 1f81062:	mov    %r15,0x8(%rdx,%rax,1)
 1f81067:	mov    %rbx,0x10(%rdx,%rax,1)
 1f8106c:	kmovq  %k0,0x18(%rdx,%rax,1)
 1f81073:	kmovq  %k1,0x20(%rdx,%rax,1)
 1f8107a:	mov    0x40(%rsp),%rdx
 1f8107f:	kmovq  %k4,%rcx
 1f81084:	and    %r10,%rdx
 1f81087:	and    %rdx,%rcx
 1f8108a:	vmovq  %rdx,%xmm1
 1f8108f:	mov    0x178(%rsp),%rdx
 1f81097:	vmovq  %rcx,%xmm2
 1f8109c:	vpunpcklqdq %xmm2,%xmm1,%xmm1
 1f810a0:	vpunpcklqdq %xmm3,%xmm4,%xmm2
 1f810a4:	vinserti128 $0x1,%xmm1,%ymm2,%ymm1
 1f810aa:	vpopcntq %ymm1,%ymm1
 1f810b0:	vpaddq %ymm5,%ymm1,%ymm5
 1f810b4:	dec    %rdx
 1f810b7:	test   %r9d,%r9d
 1f810ba:	je     1f8274a <node_contexts_window_loop+0x198a>
 1f810c0:	lea    -0x1(%rdx),%r9d
 1f810c4:	vpbroadcastq -0x19d2326(%rip),%zmm1        # 5aeda8 <.LCPI0_0>
 1f810ce:	mov    0xba0(%rdi),%r11
 1f810d5:	vmovdqa64 %zmm22,%zmm0
 1f810db:	vmovdqu64 (%r14),%zmm22
 1f810e1:	vmovdqa64 -0x1acf06b(%rip),%zmm7        # 4b2080 <abi_test_hex.digits+0xb380>
 1f810eb:	vmovdqa64 -0x1aceff5(%rip),%zmm8        # 4b2100 <abi_test_hex.digits+0xb400>
 1f810f5:	mov    0xb80(%rdi),%rax
 1f810fc:	mov    %rdx,0x178(%rsp)
 1f81104:	mov    0xb88(%rdi),%rcx
 1f8110b:	mov    0xb90(%rdi),%rdx
 1f81112:	mov    0xb98(%rdi),%r15
 1f81119:	vmovdqa64 %zmm21,%zmm6
 1f8111f:	vmovdqa64 %zmm17,%zmm21
 1f81125:	vmovdqa64 %zmm19,%zmm17
 1f8112b:	vmovdqa64 %zmm20,%zmm19
 1f81131:	mov    %r12d,0x7c(%rsp)
 1f81136:	mov    %r9,%r13
 1f81139:	shl    $0x6,%r13
 1f8113d:	test   %r9d,%r9d
 1f81140:	mov    %r9,0x170(%rsp)
 1f81148:	lea    -0x40(%r13),%r8d
 1f8114c:	vpandq 0x2c(%rsi,%r13,1),%zmm1,%zmm23
 1f81157:	cmove  %r9d,%r8d
 1f8115b:	shl    $0x7,%r9
 1f8115f:	vmovdqu64 0x6b554(%rsi,%r9,1),%zmm1
 1f8116a:	vmovdqu64 0x6b594(%rsi,%r9,1),%zmm2
 1f81175:	vmovdqu64 (%r11,%r13,1),%zmm26
 1f8117c:	vmovdqu64 (%rax,%r13,1),%zmm13
 1f81183:	vmovdqu64 (%rcx,%r13,1),%zmm20
 1f8118a:	vmovdqu64 (%rdx,%r13,1),%zmm24
 1f81191:	vmovdqu64 (%r15,%r13,1),%zmm25
 1f81198:	vmovdqu64 (%rcx,%r8,1),%zmm30
 1f8119f:	vpermt2b 0x40(%r14),%zmm23,%zmm22
 1f811a6:	vpmovuswb %zmm1,%ymm1
 1f811ac:	vpmovuswb %zmm2,%ymm2
 1f811b2:	vmovdqa64 %zmm20,0x300(%rsp)
 1f811ba:	vinserti64x4 $0x1,%ymm2,%zmm1,%zmm3
 1f811c1:	vpandq %zmm9,%zmm26,%zmm1
 1f811c7:	vmovdqu64 0x6f694(%rsi,%r9,1),%zmm2
 1f811d2:	vmovdqu64 (%r11,%r8,1),%zmm9
 1f811d9:	vptestmb %zmm1,%zmm1,%k4
 1f811df:	vmovdqu64 0x6f654(%rsi,%r9,1),%zmm1
 1f811ea:	vptestmb %zmm3,%zmm3,%k0
 1f811f0:	vpsubb %zmm3,%zmm8,%zmm31
 1f811f6:	kandq  %k0,%k4,%k2
 1f811fb:	kmovq  %k0,%r10
 1f81200:	vpcmpnltub %zmm3,%zmm8,%k0
 1f81207:	kmovq  %k4,0x128(%rsp)
 1f81211:	kmovq  %k0,%rbx
 1f81216:	vpcmpltub %zmm3,%zmm8,%k2{%k2}
 1f8121d:	and    %r10,%rbx
 1f81220:	mov    %rbx,0x38(%rsp)
 1f81225:	vpmovuswb %zmm2,%ymm2
 1f8122b:	vpmovuswb %zmm1,%ymm1
 1f81231:	vinserti64x4 $0x1,%ymm2,%zmm1,%zmm1
 1f81238:	vmovdqu64 0x196ac(%rsi,%r13,1),%zmm2
 1f81243:	vpaddb -0x1acf18d(%rip),%zmm1,%zmm29        # 4b20c0 <abi_test_hex.digits+0xb3c0>
 1f8124d:	vptestmb %zmm2,%zmm2,%k3
 1f81253:	vmovdqa64 %zmm22,%zmm2
 1f81259:	vpcmpleub %zmm7,%zmm1,%k1{%k3}
 1f81260:	kandq  %k4,%k3,%k3
 1f81265:	vpermt2b %zmm0,%zmm29,%zmm2{%k1}{z}
 1f8126b:	vmovdqu64 0x6d5d4(%rsi,%r9,1),%zmm0
 1f81276:	kmovq  %k1,0x168(%rsp)
 1f81280:	vpcmpnleub %zmm7,%zmm1,%k5{%k3}
 1f81287:	vbroadcasti32x4 -0x19d87e1(%rip),%zmm7        # 5a8ab0 <.LCPI0_48>
 1f81291:	vmovdqu64 (%r15,%r8,1),%zmm1
 1f81298:	kmovq  %rbx,%k3
 1f8129d:	vpandq 0x2c(%rsi,%r8,1),%zmm7,%zmm7
 1f812a8:	vpermt2b %zmm26,%zmm31,%zmm9{%k3}{z}
 1f812ae:	kortestq %k5,%k2
 1f812b3:	kmovq  %k5,0x110(%rsp)
 1f812bd:	vmovdqa64 %zmm2,0x200(%rsp)
 1f812c5:	vmovdqu64 0x6d614(%rsi,%r9,1),%zmm2
 1f812d0:	kmovq  %k4,%r9
 1f812d5:	mov    %r9,0xa0(%rsp)
 1f812dd:	vmovdqa64 %zmm9,0x1c0(%rsp)
 1f812e5:	vpmovuswb %zmm0,%ymm0
 1f812eb:	vpermt2b %zmm23,%zmm31,%zmm7{%k3}{z}
 1f812f1:	vpmovuswb %zmm2,%ymm2
 1f812f7:	vinserti64x4 $0x1,%ymm2,%zmm0,%zmm0
 1f812fe:	vpcmpltub -0x1acf1c9(%rip),%zmm0,%k1        # 4b2140 <abi_test_hex.digits+0xb440>
 1f81309:	vmovdqu64 (%rdx,%r8,1),%zmm2
 1f81310:	vpsubb %zmm0,%zmm8,%zmm4
 1f81316:	vmovdqa64 %zmm30,%zmm8
 1f8131c:	vpermt2b %zmm20,%zmm31,%zmm8{%k3}{z}
 1f81322:	vptestmb %zmm0,%zmm0,%k6{%k1}
 1f81328:	vmovdqu64 (%rax,%r8,1),%zmm0
 1f8132f:	vpermt2b %zmm20,%zmm4,%zmm30{%k6}{z}
 1f81335:	vmovdqa64 %zmm0,%zmm3
 1f8133b:	vpermt2b %zmm13,%zmm31,%zmm3{%k3}{z}
 1f81341:	vpermt2b %zmm13,%zmm4,%zmm0
 1f81347:	vmovdqa64 %zmm3,0x180(%rsp)
 1f8134f:	vmovdqa64 %zmm2,%zmm3
 1f81355:	vpermt2b %zmm24,%zmm31,%zmm3{%k3}{z}
 1f8135b:	vpermi2b %zmm25,%zmm1,%zmm31{%k3}{z}
 1f81361:	vpermt2b %zmm24,%zmm4,%zmm2
 1f81367:	vpermt2b %zmm25,%zmm4,%zmm1
 1f8136d:	jne    1f82312 <node_contexts_window_loop+0x1552>
 1f81373:	vmovdqa64 %zmm31,0x2c0(%rsp)
 1f8137b:	vmovdqa64 %zmm19,%zmm20
 1f81381:	vbroadcasti32x4 -0x19d88cb(%rip),%zmm4        # 5a8ac0 <.LCPI0_49>
 1f8138b:	vmovdqu64 0x1a72c(%rsi,%r13,1),%zmm31
 1f81396:	vptestmb %zmm11,%zmm8,%k3
 1f8139c:	vpxor  %xmm9,%xmm9,%xmm9
 1f813a1:	vmovdqa64 %zmm17,%zmm19
 1f813a7:	vmovdqa64 %zmm21,%zmm17
 1f813ad:	vpandq %zmm18,%zmm1,%zmm1
 1f813b3:	vmovdqa64 %zmm13,0x700(%rsp)
 1f813bb:	kmovq  %k3,%r12
 1f813c0:	vptestmb %zmm11,%zmm30,%k3
 1f813c6:	vpandq %zmm4,%zmm3,%zmm3
 1f813cc:	vpandq %zmm4,%zmm2,%zmm2
 1f813d2:	vptestnmb %zmm31,%zmm31,%k2
 1f813d8:	vpandq -0x19d2632(%rip){1to8},%zmm22,%zmm4        # 5aedb0 <.LCPI0_26>
 1f813e2:	vpcmpeqb %zmm11,%zmm3,%k0
 1f813e8:	vmovdqa64 0x300(%rsp),%zmm3
 1f813f0:	kmovq  %k2,0x40(%rsp)
 1f813f7:	vpcmpgtb 0x200(%rsp),%zmm9,%k2{%k2}
 1f813ff:	kmovq  %k0,%rsi
 1f81404:	vpcmpeqb %zmm11,%zmm2,%k0{%k6}
 1f8140a:	vpandq %zmm21,%zmm25,%zmm2
 1f81410:	and    0x38(%rsp),%rsi
 1f81415:	korq   %k0,%k3,%k1
 1f8141a:	vptestmb -0x1acee64(%rip),%zmm3,%k0        # 4b25c0 <abi_test_hex.digits+0xb8c0>
 1f81424:	vpcmpeqb %zmm10,%zmm2,%k5
 1f8142a:	vptestnmb %zmm2,%zmm2,%k3
 1f81430:	vpandq %zmm18,%zmm25,%zmm2
 1f81436:	vpcmpeqb %zmm20,%zmm2,%k7
 1f8143c:	vmovdqa64 %zmm2,0x6c0(%rsp)
 1f81444:	kmovq  %k5,0xf8(%rsp)
 1f8144e:	or     %rsi,%r12
 1f81451:	kmovq  %k0,%rax
 1f81456:	vptestmb %zmm15,%zmm3,%k0
 1f8145c:	korq   %k2,%k0,%k4
 1f81461:	mov    %rax,0x50(%rsp)
 1f81466:	kmovq  %k3,%rax
 1f8146b:	vptestmb %zmm2,%zmm2,%k3
 1f81471:	vmovdqu8 %zmm10,%zmm2{%k2}{z}
 1f81477:	kandq  %k7,%k4,%k0
 1f8147c:	kmovq  %k3,%rcx
 1f81481:	knotq  %k2,%k3
 1f81486:	kmovq  %k4,0xe8(%rsp)
 1f81490:	kmovq  %k0,%rbx
 1f81495:	vptestmb %zmm12,%zmm3,%k0{%k5}
 1f8149b:	vpternlogd $0xff,%zmm3,%zmm3,%zmm3
 1f814a2:	kmovq  %k3,%r15
 1f814a7:	vptestnmb %zmm7,%zmm7,%k3
 1f814ad:	mov    %rcx,0x30(%rsp)
 1f814b2:	vpaddb %zmm3,%zmm13,%zmm21
 1f814b8:	and    %r15,%rax
 1f814bb:	mov    %r15,0x120(%rsp)
 1f814c3:	vpaddb %zmm3,%zmm0,%zmm0
 1f814c9:	vpxor  %xmm13,%xmm13,%xmm13
 1f814ce:	kmovq  %k3,0x100(%rsp)
 1f814d8:	vpcmpltub %zmm11,%zmm21,%k2
 1f814df:	vpcmpltub %zmm14,%zmm21,%k5
 1f814e6:	or     %rax,%rbx
 1f814e9:	vmovdqa64 %zmm6,%zmm21
 1f814ef:	and    0x30(%rsp),%rbx
 1f814f4:	mov    %r13,0x30(%rsp)
 1f814f9:	kmovq  %k2,0xb8(%rsp)
 1f81503:	vptestmb %zmm12,%zmm22,%k2{%k2}
 1f81509:	kmovq  %k5,%rsi
 1f8150e:	kmovq  %k5,0xd8(%rsp)
 1f81518:	kmovq  %k0,%rdx
 1f8151d:	vpcmpeqb %zmm15,%zmm1,%k0{%k6}
 1f81523:	vpandq %zmm12,%zmm8,%zmm1
 1f81529:	kmovq  %k0,0x158(%rsp)
 1f81533:	and    %r15,%rdx
 1f81536:	mov    0x48(%rsp),%r15
 1f8153b:	vmovdqa64 %zmm1,0x680(%rsp)
 1f81543:	or     0x50(%rsp),%rdx
 1f81548:	mov    %r12,0x50(%rsp)
 1f8154d:	kandq  %k0,%k2,%k0
 1f81552:	kmovq  %k2,0x150(%rsp)
 1f8155c:	vpcmpgtb 0x1c0(%rsp),%zmm9,%k2{%k3}
 1f81564:	knotq  %k0,%k0
 1f81569:	kmovq  %k0,%r8
 1f8156e:	vpcmpeqb %zmm19,%zmm4,%k0{%k5}
 1f81574:	kmovq  %k0,%rdi
 1f81579:	vptestmb %zmm1,%zmm1,%k0
 1f8157f:	vbroadcasti32x4 -0x19d8ab9(%rip),%zmm1        # 5a8ad0 <.LCPI0_50>
 1f81589:	mov    0xbb0(%r15),%rax
 1f81590:	mov    %rdx,0xf0(%rsp)
 1f81598:	not    %rdx
 1f8159b:	and    %r8,%rdi
 1f8159e:	korq   %k2,%k0,%k0
 1f815a3:	vpcmpltub %zmm14,%zmm0,%k2{%k6}
 1f815aa:	vpcmpeqb %zmm15,%zmm4,%k6
 1f815b0:	vmovdqu64 %zmm2,(%rax,%r13,1)
 1f815b7:	vpsllw $0x7,%zmm26,%zmm0
 1f815be:	knotq  %k0,%k0
 1f815c3:	mov    0xbc0(%r15),%rax
 1f815ca:	kmovq  %k6,0x98(%rsp)
 1f815d4:	kmovq  %k0,%r9
 1f815d9:	vptestmb %zmm6,%zmm22,%k0
 1f815df:	vpandq %zmm16,%zmm26,%zmm6
 1f815e5:	kmovq  %k0,0xd0(%rsp)
 1f815ef:	korq   %k2,%k0,%k0
 1f815f4:	kmovq  %k0,%rcx
 1f815f9:	vpcmpeqb %zmm1,%zmm4,%k0
 1f815ff:	korq   %k0,%k6,%k0
 1f81604:	or     %r12,%rcx
 1f81607:	kmovq  %k0,%r10
 1f8160c:	vpcmpneqb %zmm1,%zmm4,%k0
 1f81613:	and    %r9,%rcx
 1f81616:	mov    %rsi,%r9
 1f81619:	kmovq  %k4,%rsi
 1f8161e:	vmovdqu64 %zmm4,(%rax,%r13,1)
 1f81625:	kmovq  %k0,%r14
 1f8162a:	vptestmb %zmm6,%zmm6,%k0
 1f81630:	mov    %rsi,0xc8(%rsp)
 1f81638:	korq   %k0,%k1,%k0
 1f8163d:	or     %r9,%r14
 1f81640:	or     %rsi,%r14
 1f81643:	knotq  %k0,%k0
 1f81648:	and    0xa0(%rsp),%r14
 1f81650:	kmovq  %k0,%r11
 1f81655:	vpmovb2m %zmm0,%k0
 1f8165b:	kmovq  %k0,%rax
 1f81660:	and    %r10,%r11
 1f81663:	kmovq  %k0,0xe0(%rsp)
 1f8166d:	andn   %rbx,%rax,%r8
 1f81672:	mov    %rax,0x88(%rsp)
 1f8167a:	mov    %r8,0xc0(%rsp)
 1f81682:	andn   %rdx,%r8,%r8
 1f81687:	and    %r8,%r14
 1f8168a:	and    %r8,%rdi
 1f8168d:	mov    %r8,0x90(%rsp)
 1f81695:	and    %rdi,%rcx
 1f81698:	and    %r11,%r14
 1f8169b:	mov    %rdi,0x160(%rsp)
 1f816a3:	or     %rcx,%r14
 1f816a6:	mov    %rcx,0x68(%rsp)
 1f816ab:	and    %r12,%r14
 1f816ae:	je     1f81930 <node_contexts_window_loop+0xb70>
 1f816b4:	mov    %r13,%r10
 1f816b7:	shl    $0x6,%r10
 1f816bb:	add    0x2c0(%r15),%r10
 1f816c2:	mov    0x20(%r15),%rbx
 1f816c6:	mov    0x60(%r15),%r12d
 1f816ca:	mov    0x58(%rsp),%rdx
 1f816cf:	kmovq  0x40(%rsp),%k6
 1f816d6:	mov    %r14,%r13
 1f816d9:	nopl   0x0(%rax)
 1f816e0:	xor    %r15d,%r15d
 1f816e3:	tzcnt  %r13,%r15
 1f816e8:	mov    %r15d,%eax
 1f816eb:	shl    $0x6,%eax
 1f816ee:	mov    0x20(%r10,%rax,1),%esi
 1f816f3:	mov    %esi,%ecx
 1f816f5:	shr    $0x3,%ecx
 1f816f8:	cmp    %r12d,%ecx
 1f816fb:	cmovae %r12d,%ecx
 1f816ff:	shl    $0x6,%rcx
 1f81703:	cmpl   $0x0,0x38(%rbx,%rcx,1)
 1f81708:	setne  %al
 1f8170b:	testb  $0x4,0x34(%rbx,%rcx,1)
 1f81710:	je     1f81730 <node_contexts_window_loop+0x970>
 1f81712:	xor    $0x1,%al
 1f81714:	inc    %rdx
 1f81717:	movzbl %al,%eax
 1f8171a:	shlx   %r15,%rax,%rax
 1f8171f:	andn   %r14,%rax,%r14
 1f81724:	blsr   %r13,%r13
 1f81729:	jne    1f816e0 <node_contexts_window_loop+0x920>
 1f8172b:	jmp    1f8193f <node_contexts_window_loop+0xb7f>
 1f81730:	mov    0x48(%rsp),%rdi
 1f81735:	vmovdqa64 %zmm5,0x280(%rsp)
 1f8173d:	mov    %rdx,0x58(%rsp)
 1f81742:	vmovdqa64 %zmm22,0x240(%rsp)
 1f8174a:	vmovdqa64 %zmm23,0x640(%rsp)
 1f81752:	vmovdqa64 %zmm24,0x600(%rsp)
 1f8175a:	vmovdqa64 %zmm25,0x5c0(%rsp)
 1f81762:	vmovdqa64 %zmm26,0x580(%rsp)
 1f8176a:	vmovdqa64 %zmm27,0x540(%rsp)
 1f81772:	vmovdqa64 %zmm28,0x500(%rsp)
 1f8177a:	vmovdqa64 %zmm7,0x4c0(%rsp)
 1f81782:	vmovdqa64 %zmm29,0x480(%rsp)
 1f8178a:	vmovdqa64 %zmm4,0x440(%rsp)
 1f81792:	vmovdqa64 %zmm30,0x3c0(%rsp)
 1f8179a:	vmovdqa64 %zmm8,0x380(%rsp)
 1f817a2:	vmovdqa64 %zmm31,0x400(%rsp)
 1f817aa:	kmovq  %k7,0x60(%rsp)
 1f817b1:	vmovdqa64 %zmm6,0x340(%rsp)
 1f817b9:	kmovq  %k1,0x70(%rsp)
 1f817c0:	kmovq  %k2,0x140(%rsp)
 1f817ca:	mov    %r9,0x138(%rsp)
 1f817d2:	mov    %r10,0x130(%rsp)
 1f817da:	vzeroupper
 1f817dd:	call   1f82dba <node_contexts_stride_asked>
 1f817e2:	vmovdqa64 0x340(%rsp),%zmm6
 1f817ea:	vmovdqa64 0x400(%rsp),%zmm31
 1f817f2:	vmovdqa64 0x380(%rsp),%zmm8
 1f817fa:	vmovdqa64 0x3c0(%rsp),%zmm30
 1f81802:	vmovdqa64 0x440(%rsp),%zmm4
 1f8180a:	vmovdqa64 0x480(%rsp),%zmm29
 1f81812:	vmovdqa64 0x4c0(%rsp),%zmm7
 1f8181a:	vmovdqa64 0x500(%rsp),%zmm28
 1f81822:	vmovdqa64 0x540(%rsp),%zmm27
 1f8182a:	vmovdqa64 0x580(%rsp),%zmm26
 1f81832:	vmovdqa64 0x5c0(%rsp),%zmm25
 1f8183a:	vmovdqa64 0x600(%rsp),%zmm24
 1f81842:	vmovdqa64 0x640(%rsp),%zmm23
 1f8184a:	vmovdqa64 0x240(%rsp),%zmm22
 1f81852:	vbroadcasti32x4 -0x19d8dbc(%rip),%zmm21        # 5a8aa0 <.LCPI0_47>
 1f8185c:	vbroadcasti32x4 -0x19d8dd6(%rip),%zmm20        # 5a8a90 <.LCPI0_46>
 1f81866:	vbroadcasti32x4 -0x19d8df0(%rip),%zmm19        # 5a8a80 <.LCPI0_45>
 1f81870:	vbroadcasti32x4 -0x19d8e0a(%rip),%zmm18        # 5a8a70 <.LCPI0_44>
 1f8187a:	vbroadcasti32x4 -0x19d8e24(%rip),%zmm17        # 5a8a60 <.LCPI0_43>
 1f81884:	vbroadcasti32x4 -0x19d8e3e(%rip),%zmm16        # 5a8a50 <.LCPI0_42>
 1f8188e:	vbroadcasti32x4 -0x19d8e58(%rip),%zmm15        # 5a8a40 <.LCPI0_41>
 1f81898:	vbroadcasti32x4 -0x19d8e72(%rip),%zmm14        # 5a8a30 <.LCPI0_40>
 1f818a2:	vbroadcasti32x4 -0x19d8e8c(%rip),%zmm12        # 5a8a20 <.LCPI0_39>
 1f818ac:	vbroadcasti32x4 -0x19d8ea6(%rip),%zmm11        # 5a8a10 <.LCPI0_38>
 1f818b6:	vbroadcasti32x4 -0x19d8ec0(%rip),%zmm10        # 5a8a00 <.LCPI0_37>
 1f818c0:	vmovdqa64 0x280(%rsp),%zmm5
 1f818c8:	mov    0x130(%rsp),%r10
 1f818d0:	mov    0x138(%rsp),%r9
 1f818d8:	kmovq  0x140(%rsp),%k2
 1f818e2:	kmovq  0x70(%rsp),%k1
 1f818e9:	mov    0x90(%rsp),%r8
 1f818f1:	kmovq  0x60(%rsp),%k7
 1f818f8:	kmovq  0x40(%rsp),%k6
 1f818ff:	kmovq  0x100(%rsp),%k3
 1f81909:	mov    0x58(%rsp),%rdx
 1f8190e:	incq   0x108(%rsp)
 1f81916:	vpternlogd $0xff,%zmm3,%zmm3,%zmm3
 1f8191d:	vpxor  %xmm13,%xmm13,%xmm13
 1f81922:	jmp    1f81712 <node_contexts_window_loop+0x952>
 1f81927:	nopw   0x0(%rax,%rax,1)
 1f81930:	mov    0x58(%rsp),%rdx
 1f81935:	kmovq  0x40(%rsp),%k6
 1f8193c:	xor    %r14d,%r14d
 1f8193f:	vpaddb 0x180(%rsp),%zmm3,%zmm0
 1f81947:	vpaddb -0x1acf211(%rip),%zmm4,%zmm1        # 4b2740 <abi_test_hex.digits+0xba40>
 1f81951:	kmovq  0x98(%rsp),%k0
 1f8195b:	kmovq  %k1,%rax
 1f81960:	or     0x50(%rsp),%rax
 1f81965:	mov    %rdx,0x58(%rsp)
 1f8196a:	mov    %r9,%rdi
 1f8196d:	kmovq  %k0,%rcx
 1f81972:	andn   %rcx,%rax,%rax
 1f81977:	vpcmpltub %zmm14,%zmm0,%k1{%k2}
 1f8197e:	vpcmpltub %zmm16,%zmm1,%k0
 1f81985:	kmovq  %k1,%rsi
 1f8198a:	kmovq  %k0,%rdx
 1f8198f:	andn   %r9,%rsi,%rbx
 1f81994:	and    0xa0(%rsp),%rbx
 1f8199c:	and    %rsi,%rdi
 1f8199f:	or     %rdx,%rax
 1f819a2:	and    %r8,%rdi
 1f819a5:	and    %rax,%rdi
 1f819a8:	mov    %rdi,0x98(%rsp)
 1f819b0:	and    %rax,%rbx
 1f819b3:	and    %r8,%rbx
 1f819b6:	je     1f81bc0 <node_contexts_window_loop+0xe00>
 1f819bc:	mov    0x48(%rsp),%rax
 1f819c1:	mov    0xb0(%rsp),%r13
 1f819c9:	xor    %r15d,%r15d
 1f819cc:	vmovdqa64 %zmm6,0x340(%rsp)
 1f819d4:	kmovq  %k7,0x60(%rsp)
 1f819db:	vmovdqa64 %zmm31,0x400(%rsp)
 1f819e3:	vmovdqa64 %zmm8,0x380(%rsp)
 1f819eb:	vmovdqa64 %zmm30,0x3c0(%rsp)
 1f819f3:	vmovdqa64 %zmm4,0x440(%rsp)
 1f819fb:	vmovdqa64 %zmm29,0x480(%rsp)
 1f81a03:	vmovdqa64 %zmm7,0x4c0(%rsp)
 1f81a0b:	vmovdqa64 %zmm28,0x500(%rsp)
 1f81a13:	vmovdqa64 %zmm27,0x540(%rsp)
 1f81a1b:	vmovdqa64 %zmm26,0x580(%rsp)
 1f81a23:	vmovdqa64 %zmm25,0x5c0(%rsp)
 1f81a2b:	vmovdqa64 %zmm24,0x600(%rsp)
 1f81a33:	vmovdqa64 %zmm23,0x640(%rsp)
 1f81a3b:	vmovdqa64 %zmm22,0x240(%rsp)
 1f81a43:	vmovdqa64 %zmm5,0x280(%rsp)
 1f81a4b:	mov    (%rax),%rcx
 1f81a4e:	mov    0x2c0(%rax),%rax
 1f81a55:	mov    %rcx,0x180(%rsp)
 1f81a5d:	mov    %rax,0x70(%rsp)
 1f81a62:	mov    0x30(%rsp),%rax
 1f81a67:	mov    0x180(%rsp),%rdi
 1f81a6f:	mov    0x70(%rsp),%rsi
 1f81a74:	xor    %r12d,%r12d
 1f81a77:	tzcnt  %rbx,%r12
 1f81a7c:	lea    (%rax,%r12,1),%edx
 1f81a80:	vzeroupper
 1f81a83:	call   1f82d70 <node_contexts_converted>
 1f81a88:	movzbl %al,%eax
 1f81a8b:	inc    %r13
 1f81a8e:	shlx   %r12,%rax,%rax
 1f81a93:	or     %rax,%r15
 1f81a96:	blsr   %rbx,%rbx
 1f81a9b:	jne    1f81a62 <node_contexts_window_loop+0xca2>
 1f81a9d:	vmovdqa64 0x280(%rsp),%zmm5
 1f81aa5:	vbroadcasti32x4 -0x19d90af(%rip),%zmm10        # 5a8a00 <.LCPI0_37>
 1f81aaf:	vbroadcasti32x4 -0x19d90a9(%rip),%zmm11        # 5a8a10 <.LCPI0_38>
 1f81ab9:	vbroadcasti32x4 -0x19d90a3(%rip),%zmm12        # 5a8a20 <.LCPI0_39>
 1f81ac3:	vbroadcasti32x4 -0x19d909d(%rip),%zmm14        # 5a8a30 <.LCPI0_40>
 1f81acd:	vbroadcasti32x4 -0x19d9097(%rip),%zmm15        # 5a8a40 <.LCPI0_41>
 1f81ad7:	vbroadcasti32x4 -0x19d9091(%rip),%zmm16        # 5a8a50 <.LCPI0_42>
 1f81ae1:	vbroadcasti32x4 -0x19d908b(%rip),%zmm17        # 5a8a60 <.LCPI0_43>
 1f81aeb:	vbroadcasti32x4 -0x19d9085(%rip),%zmm18        # 5a8a70 <.LCPI0_44>
 1f81af5:	vbroadcasti32x4 -0x19d907f(%rip),%zmm19        # 5a8a80 <.LCPI0_45>
 1f81aff:	vbroadcasti32x4 -0x19d9079(%rip),%zmm20        # 5a8a90 <.LCPI0_46>
 1f81b09:	vbroadcasti32x4 -0x19d9073(%rip),%zmm21        # 5a8aa0 <.LCPI0_47>
 1f81b13:	vmovdqa64 0x240(%rsp),%zmm22
 1f81b1b:	vmovdqa64 0x640(%rsp),%zmm23
 1f81b23:	vmovdqa64 0x600(%rsp),%zmm24
 1f81b2b:	vmovdqa64 0x5c0(%rsp),%zmm25
 1f81b33:	vmovdqa64 0x580(%rsp),%zmm26
 1f81b3b:	vmovdqa64 0x540(%rsp),%zmm27
 1f81b43:	vmovdqa64 0x500(%rsp),%zmm28
 1f81b4b:	vmovdqa64 0x4c0(%rsp),%zmm7
 1f81b53:	vmovdqa64 0x480(%rsp),%zmm29
 1f81b5b:	vmovdqa64 0x440(%rsp),%zmm4
 1f81b63:	vmovdqa64 0x3c0(%rsp),%zmm30
 1f81b6b:	vmovdqa64 0x380(%rsp),%zmm8
 1f81b73:	vmovdqa64 0x400(%rsp),%zmm31
 1f81b7b:	vmovdqa64 0x340(%rsp),%zmm6
 1f81b83:	or     %r15,0x98(%rsp)
 1f81b8b:	mov    0x80(%rsp),%rsi
 1f81b93:	kmovq  0x100(%rsp),%k3
 1f81b9d:	kmovq  0x40(%rsp),%k6
 1f81ba4:	kmovq  0x60(%rsp),%k7
 1f81bab:	vpxor  %xmm13,%xmm13,%xmm13
 1f81bb0:	mov    %r13,0xb0(%rsp)
 1f81bb8:	jmp    1f81bc8 <node_contexts_window_loop+0xe08>
 1f81bba:	nopw   0x0(%rax,%rax,1)
 1f81bc0:	mov    0x80(%rsp),%rsi
 1f81bc8:	vmovdqa64 0x1c0(%rsp),%zmm9
 1f81bd0:	vpsllw $0x7,0x300(%rsp),%zmm0
 1f81bd9:	vmovdqa64 0x700(%rsp),%zmm1
 1f81be1:	kmovq  0xd8(%rsp),%k4
 1f81beb:	kmovq  0xf8(%rsp),%k5
 1f81bf5:	vmovdqa64 0x2c0(%rsp),%zmm2
 1f81bfd:	vbroadcasti32x4 -0x19d9127(%rip),%zmm3        # 5a8ae0 <.LCPI0_51>
 1f81c07:	mov    0x38(%rsp),%rbx
 1f81c0c:	vptestmb %zmm15,%zmm9,%k1
 1f81c12:	vpmovb2m %zmm0,%k2
 1f81c18:	vmovdqa64 0x680(%rsp),%zmm0
 1f81c20:	kandq  %k3,%k1,%k0
 1f81c25:	kmovq  0xb8(%rsp),%k3
 1f81c2f:	kmovq  %k0,%rax
 1f81c34:	vpcmpltub %zmm19,%zmm1,%k0
 1f81c3b:	korq   %k2,%k0,%k2
 1f81c40:	vptestmb %zmm15,%zmm26,%k0
 1f81c46:	mov    %rax,0x180(%rsp)
 1f81c4e:	kmovq  %k0,%rax
 1f81c53:	vpcmpeqb %zmm10,%zmm4,%k0
 1f81c59:	and    0x180(%rsp),%rbx
 1f81c61:	kmovq  %k0,%rdx
 1f81c66:	vpcmpeqb %zmm17,%zmm4,%k0
 1f81c6c:	mov    %rax,0x280(%rsp)
 1f81c74:	kmovq  %k0,%rcx
 1f81c79:	korq   %k3,%k7,%k0
 1f81c7e:	vpcmpeqb 0x6c0(%rsp),%zmm11,%k3{%k4}
 1f81c86:	mov    %rdx,0x300(%rsp)
 1f81c8e:	mov    %rcx,0x240(%rsp)
 1f81c96:	korq   %k3,%k0,%k0
 1f81c9b:	kmovq  0x128(%rsp),%k3
 1f81ca5:	kmovq  %k0,%rdi
 1f81caa:	vpcmpeqb %zmm11,%zmm4,%k0{%k4}
 1f81cb0:	kmovq  %k0,%r8
 1f81cb5:	vptestnmb %zmm0,%zmm0,%k0
 1f81cbb:	kmovq  %k0,%r11
 1f81cc0:	and    %r8,%r11
 1f81cc3:	mov    0xf0(%rsp),%r8
 1f81ccb:	vptestnmb %zmm1,%zmm1,%k0{%k3}
 1f81cd1:	kmovq  0xe8(%rsp),%k3
 1f81cdb:	vbroadcasti32x4 -0x19d91f5(%rip),%zmm1        # 5a8af0 <.LCPI0_52>
 1f81ce5:	andn   %rdi,%r8,%rdi
 1f81cea:	and    0xc0(%rsp),%rdi
 1f81cf2:	mov    0x280(%rsp),%r8
 1f81cfa:	korq   %k3,%k0,%k0
 1f81cff:	kmovq  %k0,%r13
 1f81d04:	kandq  %k5,%k4,%k0
 1f81d09:	kmovq  %k0,%r15
 1f81d0e:	vpcmpeqb %zmm16,%zmm4,%k0{%k2}
 1f81d14:	vpcmpeqb -0x1acf61e(%rip),%zmm4,%k2        # 4b2700 <abi_test_hex.digits+0xba00>
 1f81d1e:	vpandq %zmm1,%zmm2,%zmm0
 1f81d24:	mov    %rdi,0xc0(%rsp)
 1f81d2c:	mov    0xc8(%rsp),%rdi
 1f81d34:	andn   %r15,%rdi,%r15
 1f81d39:	mov    0x90(%rsp),%rdi
 1f81d41:	and    0x300(%rsp),%r15
 1f81d49:	korq   %k0,%k2,%k0
 1f81d4e:	kmovq  %k0,%r10
 1f81d53:	vpcmpeqb %zmm3,%zmm0,%k0{%k1}
 1f81d59:	vptestnmb %zmm18,%zmm2,%k1
 1f81d5f:	vbroadcasti32x4 -0x19d9269(%rip),%zmm2        # 5a8b00 <.LCPI0_53>
 1f81d69:	vpandq 0x200(%rsp),%zmm1,%zmm0
 1f81d71:	vbroadcasti32x4 -0x19d926b(%rip),%zmm1        # 5a8b10 <.LCPI0_54>
 1f81d7b:	korq   %k0,%k1,%k0
 1f81d80:	korq   %k4,%k3,%k1
 1f81d85:	kmovq  0xd0(%rsp),%k3
 1f81d8f:	kmovq  %k1,%rax
 1f81d94:	vpcmpeqb %zmm14,%zmm4,%k1{%k1}
 1f81d9a:	kmovq  %k1,%rdx
 1f81d9f:	vptestnmb %zmm6,%zmm6,%k1
 1f81da5:	mov    %rax,0x2c0(%rsp)
 1f81dad:	and    %rdi,%r10
 1f81db0:	and    %r8,%r15
 1f81db3:	and    %rdi,%r11
 1f81db6:	and    %rdi,%r13
 1f81db9:	kmovq  %k1,%rax
 1f81dbe:	vpcmpeqb -0x1acf608(%rip),%zmm4,%k1{%k4}        # 4b27c0 <abi_test_hex.digits+0xbac0>
 1f81dc8:	and    0x240(%rsp),%rax
 1f81dd0:	mov    %r10,0xf0(%rsp)
 1f81dd8:	and    %rdi,%rdx
 1f81ddb:	and    %rdi,%r15
 1f81dde:	mov    %r13,0x200(%rsp)
 1f81de6:	mov    0x30(%rsp),%r13
 1f81deb:	and    0x2c0(%rsp),%rax
 1f81df3:	mov    %rdx,0xd0(%rsp)
 1f81dfb:	vpcmpeqb %zmm1,%zmm0,%k2
 1f81e01:	and    %rdi,%rax
 1f81e04:	mov    %rax,0xd8(%rsp)
 1f81e0c:	andn   %r11,%rbx,%rax
 1f81e11:	kmovq  %k1,%rcx
 1f81e16:	vpcmpeqb %zmm2,%zmm4,%k1
 1f81e1c:	mov    %rax,0x680(%rsp)
 1f81e24:	kmovq  %k7,%rax
 1f81e29:	kandq  %k1,%k3,%k4
 1f81e2e:	and    %rdi,%rcx
 1f81e31:	kxorq  %k4,%k1,%k3
 1f81e36:	mov    %rcx,0x6c0(%rsp)
 1f81e3e:	kmovq  %k4,0x70(%rsp)
 1f81e45:	kmovq  %k3,0xe8(%rsp)
 1f81e4f:	kandq  %k3,%k2,%k3
 1f81e54:	kmovq  %k3,%r12
 1f81e59:	vpcmpeqb %zmm2,%zmm0,%k3
 1f81e5f:	korq   %k3,%k2,%k2
 1f81e64:	vpcmpeqb %zmm1,%zmm4,%k3
 1f81e6a:	vpaddb -0x1acf9b4(%rip),%zmm7,%zmm1        # 4b24c0 <abi_test_hex.digits+0xb7c0>
 1f81e74:	and    %rdi,%r12
 1f81e77:	kandq  %k0,%k3,%k0
 1f81e7c:	mov    %r12,0x1c0(%rsp)
 1f81e84:	kmovq  %k3,0x700(%rsp)
 1f81e8e:	kandq  %k2,%k0,%k0
 1f81e93:	kmovq  %k0,%r9
 1f81e98:	vptestnmb %zmm10,%zmm8,%k0{%k1}
 1f81e9e:	vpcmpeqb %zmm3,%zmm4,%k1
 1f81ea4:	and    %rdi,%r9
 1f81ea7:	mov    %r9,0x180(%rsp)
 1f81eaf:	kmovq  %k0,%r10
 1f81eb4:	vptestmb %zmm11,%zmm9,%k0
 1f81eba:	kmovq  %k0,%rcx
 1f81ebf:	vptestmb %zmm12,%zmm26,%k0{%k1}
 1f81ec5:	kmovq  0xe0(%rsp),%k1
 1f81ecf:	and    %rdi,%r10
 1f81ed2:	mov    %r11,%rdi
 1f81ed5:	and    %rbx,%rdi
 1f81ed8:	andn   %rdi,%rcx,%rbx
 1f81edd:	and    %rcx,%rdi
 1f81ee0:	mov    %r10,0xc8(%rsp)
 1f81ee8:	mov    %rdi,0xb8(%rsp)
 1f81ef0:	kmovq  %k0,%rcx
 1f81ef5:	vptestmb %zmm21,%zmm25,%k0
 1f81efb:	korq   %k5,%k0,%k0
 1f81f00:	and    %rcx,0x120(%rsp)
 1f81f08:	korq   %k1,%k0,%k0
 1f81f0d:	vpcmpeqb %zmm3,%zmm0,%k1
 1f81f13:	vporq  %zmm30,%zmm8,%zmm0
 1f81f19:	knotq  %k0,%k0
 1f81f1e:	kmovq  %k1,%rcx
 1f81f23:	vpcmpltub %zmm16,%zmm1,%k1
 1f81f2a:	kmovq  %k0,%rdx
 1f81f2f:	vptestmb %zmm11,%zmm26,%k0
 1f81f35:	kmovq  %k1,0x2c0(%rsp)
 1f81f3f:	and    %rcx,%rdx
 1f81f42:	kmovq  %k6,%rcx
 1f81f47:	and    %rcx,%rax
 1f81f4a:	and    %r8,%rax
 1f81f4d:	kmovq  %k0,%r8
 1f81f52:	kandq  %k4,%k1,%k0
 1f81f57:	kmovq  %k0,%r11
 1f81f5c:	mov    %rax,0xe0(%rsp)
 1f81f64:	mov    %r15,%rax
 1f81f67:	and    %r8,%rax
 1f81f6a:	vptestnmb %zmm10,%zmm0,%k0
 1f81f70:	mov    %r8,0x90(%rsp)
 1f81f78:	or     %r9,%r11
 1f81f7b:	mov    %rax,0xf8(%rsp)
 1f81f83:	kmovq  %k0,%rax
 1f81f88:	or     %r12,%r11
 1f81f8b:	mov    0x7c(%rsp),%r12d
 1f81f90:	and    %r11,%rax
 1f81f93:	cmpb   $0x0,0x2f(%rsp)
 1f81f98:	mov    %rax,0x40(%rsp)
 1f81f9d:	jne    1f824db <node_contexts_window_loop+0x171b>
 1f81fa3:	vbroadcasti32x4 -0x19d95bd(%rip),%zmm9        # 5a89f0 <.LCPI0_36>
 1f81fad:	mov    0x68(%rsp),%rcx
 1f81fb2:	mov    0x88(%rsp),%rax
 1f81fba:	or     %rax,0x200(%rsp)
 1f81fc2:	andn   0x50(%rsp),%r14,%rax
 1f81fc9:	and    0xe0(%rsp),%rdx
 1f81fd1:	mov    0x680(%rsp),%r8
 1f81fd9:	mov    0x6c0(%rsp),%r10
 1f81fe1:	mov    %rbx,%r9
 1f81fe4:	or     %r9,%r15
 1f81fe7:	vmovdqa64 %zmm23,%zmm0
 1f81fed:	kmovq  0xe8(%rsp),%k0
 1f81ff7:	vpermt2b %zmm27,%zmm29,%zmm0
 1f81ffd:	kmovq  0x168(%rsp),%k7
 1f82007:	kmovq  0x100(%rsp),%k6
 1f82011:	vptestmb %zmm31,%zmm31,%k3
 1f82017:	vmovdqu8 %zmm10,%zmm2{%k3}{z}
 1f8201d:	andn   %rcx,%rax,%rax
 1f82022:	mov    %rdx,0x38(%rsp)
 1f82027:	mov    0xc0(%rsp),%rdx
 1f8202f:	mov    %r8,%rcx
 1f82032:	or     %r10,%rcx
 1f82035:	mov    %rax,0x30(%rsp)
 1f8203a:	or     0xf8(%rsp),%rdx
 1f82042:	mov    0xd0(%rsp),%rax
 1f8204a:	or     %rbx,%rcx
 1f8204d:	mov    0xb8(%rsp),%rbx
 1f82055:	or     %rax,%rdx
 1f82058:	or     %r8,%rax
 1f8205b:	or     0xf0(%rsp),%rax
 1f82063:	or     %rbx,%r15
 1f82066:	or     %rdx,%rcx
 1f82069:	mov    0xc8(%rsp),%rdx
 1f82071:	or     %rax,%r15
 1f82074:	mov    %rdx,%rdi
 1f82077:	or     %rbx,%rdi
 1f8207a:	or     %r10,%rdx
 1f8207d:	or     %r14,%r15
 1f82080:	mov    0x1c0(%rsp),%r10
 1f82088:	or     %rax,%rdi
 1f8208b:	mov    0xd8(%rsp),%rax
 1f82093:	or     %rbx,%rdx
 1f82096:	kmovq  %r15,%k2
 1f8209b:	mov    $0x0,%r15d
 1f820a1:	or     %r8,%rax
 1f820a4:	or     %r9,%rax
 1f820a7:	or     %rax,%rdx
 1f820aa:	mov    0x98(%rsp),%rax
 1f820b2:	or     %r14,%rdx
 1f820b5:	or     %rax,%rcx
 1f820b8:	or     %rax,%rdi
 1f820bb:	or     %rax,%rdx
 1f820be:	mov    0x120(%rsp),%rax
 1f820c6:	kmovq  %rcx,%k4
 1f820cb:	kmovq  %k0,%rcx
 1f820d0:	vpcmpeqb -0x1acfe9a(%rip),%zmm0,%k0{%k7}        # 4b2240 <abi_test_hex.digits+0xb540>
 1f820da:	kmovq  %rdi,%k1
 1f820df:	mov    0x30(%rsp),%rdi
 1f820e4:	kmovq  %rdx,%k3
 1f820e9:	vmovdqu8 -0x1acfef3(%rip),%zmm1{%k4}{z}        # 4b2200 <abi_test_hex.digits+0xb500>
 1f820f3:	xor    %r10,%rcx
 1f820f6:	kmovq  %rax,%k5
 1f820fb:	kmovq  %k6,%rax
 1f82100:	andn   %rdi,%rax,%rax
 1f82105:	kmovq  %rax,%k6
 1f8210a:	mov    0x50(%rsp),%rax
 1f8210f:	kmovq  %k0,%rdx
 1f82114:	vporq  %zmm15,%zmm1,%zmm0
 1f8211a:	or     %rdx,%r11
 1f8211d:	vmovdqu8 %zmm0,%zmm1{%k2}
 1f82123:	vporq  %zmm16,%zmm1,%zmm0
 1f82129:	not    %r11
 1f8212c:	vmovdqu8 %zmm0,%zmm1{%k1}
 1f82132:	vpord  -0x19d0934(%rip){1to16},%zmm1,%zmm0        # 5b1808 <.LCPI0_55>
 1f8213c:	kmovq  %rdi,%k1
 1f82141:	and    %rdi,%rax
 1f82144:	kmovq  %rax,%k4
 1f82149:	mov    0x40(%rsp),%rax
 1f8214e:	vmovdqu8 %zmm0,%zmm1{%k3}
 1f82154:	vmovdqu8 -0x1acf91e(%rip),%zmm1{%k5}        # 4b2840 <abi_test_hex.digits+0xbb40>
 1f8215e:	vmovdqu8 -0x1acf8e8(%rip),%zmm1{%k1}        # 4b2880 <abi_test_hex.digits+0xbb80>
 1f82168:	kmovq  %rax,%k1
 1f8216d:	mov    0x118(%rsp),%rax
 1f82175:	vmovdqu8 -0x1acf8bf(%rip),%zmm1{%k1}        # 4b28c0 <abi_test_hex.digits+0xbbc0>
 1f8217f:	kmovq  0x110(%rsp),%k1
 1f82189:	vmovdqa64 %zmm1,%zmm0
 1f8218f:	vpaddb %zmm16,%zmm1,%zmm0{%k6}
 1f82195:	vpaddb %zmm15,%zmm0,%zmm0{%k4}
 1f8219b:	vpermi2b %zmm28,%zmm0,%zmm29{%k7}{z}
 1f821a1:	vmovdqu8 0x780(%rsp),%zmm29{%k1}
 1f821a9:	kmovq  %r11,%k1
 1f821ae:	vpaddw %zmm29,%zmm29,%zmm3
 1f821b4:	vporq  %zmm2,%zmm3,%zmm2
 1f821ba:	vpermb 0x80(%rax),%zmm2,%zmm2
 1f821c1:	mov    0x48(%rsp),%rax
 1f821c6:	vpandd -0x19d09c4(%rip){1to16},%zmm2,%zmm3        # 5b180c <.LCPI0_56>
 1f821d0:	mov    0xba8(%rax),%rdx
 1f821d7:	vmovdqu8 %zmm3,%zmm3{%k1}{z}
 1f821dd:	vmovdqu64 %zmm1,(%rdx,%r13,1)
 1f821e4:	mov    0xbb8(%rax),%rdx
 1f821eb:	mov    %r12d,%eax
 1f821ee:	sub    %r13d,%eax
 1f821f1:	vmovdqu64 %zmm3,(%rdx,%r13,1)
 1f821f8:	mov    $0xffffffffffffffff,%rdx
 1f821ff:	jbe    1f82218 <node_contexts_window_loop+0x1458>
 1f82201:	lea    0x40(%r13),%edx
 1f82205:	cmp    %edx,%r12d
 1f82208:	mov    $0xffffffffffffffff,%rdx
 1f8220f:	shlx   %rax,%rdx,%rdx
 1f82214:	cmovae %r15,%rdx
 1f82218:	kmovq  0x2c0(%rsp),%k0
 1f82222:	mov    0x300(%rsp),%rdi
 1f8222a:	kmovq  0x70(%rsp),%k4
 1f82231:	kmovq  %k0,%rax
 1f82236:	vpcmpeqb %zmm17,%zmm7,%k0
 1f8223c:	and    %rdi,0x200(%rsp)
 1f82244:	kmovq  %k0,%r9
 1f82249:	kmovq  0x700(%rsp),%k0
 1f82253:	and    %rax,%rcx
 1f82256:	and    %r9,%r10
 1f82259:	mov    0x90(%rsp),%r9
 1f82261:	and    0x38(%rsp),%r9
 1f82266:	mov    %r10,0x1c0(%rsp)
 1f8226e:	kmovq  %k0,%r8
 1f82273:	vpmovb2m %zmm2,%k0
 1f82279:	kmovq  %k0,%rax
 1f8227e:	xor    %r8,0x180(%rsp)
 1f82286:	andn   %rax,%r9,%rax
 1f8228b:	mov    %rax,%r8
 1f8228e:	or     %rdi,%r8
 1f82291:	andn   0xa0(%rsp),%r8,%rbx
 1f8229b:	je     1f80f30 <node_contexts_window_loop+0x170>
 1f822a1:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
 1f822b0:	xor    %r8d,%r8d
 1f822b3:	tzcnt  %rbx,%r8
 1f822b8:	mov    $0xffffffffffffffff,%r14
 1f822bf:	mov    %r12d,%r11d
 1f822c2:	movabs $0x7fffffffffffffff,%rdi
 1f822cc:	lea    0x0(%r13,%r8,1),%r9d
 1f822d1:	sub    0x651b8(%rsi,%r9,4),%r9d
 1f822d9:	lea    0x1(%r9),%r9d
 1f822dd:	cmovb  %r15d,%r9d
 1f822e1:	mov    %r9d,%r10d
 1f822e4:	sub    %r13d,%r10d
 1f822e7:	cmp    %r12d,%r9d
 1f822ea:	cmovb  %r9d,%r11d
 1f822ee:	cmp    %r13d,%r9d
 1f822f1:	shlx   %r10,%r14,%r14
 1f822f6:	cmovbe %rdi,%r14
 1f822fa:	cmovb  %r11d,%r12d
 1f822fe:	bzhi   %r8,%r14,%r8
 1f82303:	or     %r8,%rdx
 1f82306:	blsr   %rbx,%rbx
 1f8230b:	jne    1f822b0 <node_contexts_window_loop+0x14f0>
 1f8230d:	jmp    1f80f30 <node_contexts_window_loop+0x170>
 1f82312:	kmovq  %k5,%r8
 1f82317:	test   %r8,%r8
 1f8231a:	je     1f823b6 <node_contexts_window_loop+0x15f6>
 1f82320:	mov    0x48(%rsp),%rdi
 1f82325:	mov    %r14,%r12
 1f82328:	mov    %r8,%r10
 1f8232b:	mov    0xba8(%rdi),%rdi
 1f82332:	mov    %rdi,0x30(%rsp)
 1f82337:	xor    %edi,%edi
 1f82339:	tzcnt  %r10,%rdi
 1f8233e:	mov    %r12,%r9
 1f82341:	lea    0x0(%r13,%rdi,1),%ebx
 1f82346:	mov    %rdi,0x50(%rsp)
 1f8234b:	mov    0x30(%rsp),%rdi
 1f82350:	movzwl 0x6f654(%rsi,%rbx,2),%r14d
 1f82359:	add    %ebx,%r14d
 1f8235c:	movzwl 0x6b554(%rsi,%r14,2),%r12d
 1f82365:	movzbl 0x2c(%rsi,%r14,1),%ebx
 1f8236b:	movzbl (%rdi,%r14,1),%edi
 1f82370:	sub    %r12d,%r14d
 1f82373:	and    $0x7f,%ebx
 1f82376:	mov    %r9,%r12
 1f82379:	testb  $0x7f,0x2c(%rsi,%r14,1)
 1f8237f:	movzbl (%r9,%rbx,1),%ebx
 1f82384:	mov    0x50(%rsp),%r9
 1f82389:	setne  %r14b
 1f8238d:	mov    %bl,0x740(%rsp,%r9,1)
 1f82395:	add    %r14b,%r14b
 1f82398:	or     $0x14,%r14b
 1f8239c:	cmp    $0x14,%dil
 1f823a0:	movzbl %r14b,%ebx
 1f823a4:	cmovne %edi,%ebx
 1f823a7:	blsr   %r10,%r10
 1f823ac:	mov    %bl,0x780(%rsp,%r9,1)
 1f823b4:	jne    1f82337 <node_contexts_window_loop+0x1577>
 1f823b6:	kmovq  %k2,%r9
 1f823bb:	vmovdqa64 %zmm19,%zmm20
 1f823c1:	mov    %r9,%r10
 1f823c4:	test   %r9,%r9
 1f823c7:	je     1f8243a <node_contexts_window_loop+0x167a>
 1f823c9:	xor    %edi,%edi
 1f823cb:	tzcnt  %r10,%rdi
 1f823d0:	lea    0x0(%r13,%rdi,1),%ebx
 1f823d5:	movzwl 0x6b554(%rsi,%rbx,2),%r14d
 1f823de:	sub    %r14d,%ebx
 1f823e1:	movzbl 0x2c(%rsi,%rbx,1),%r14d
 1f823e7:	and    $0x7f,%r14b
 1f823eb:	blsr   %r10,%r10
 1f823f0:	mov    %r14b,0x7c0(%rsp,%rdi,1)
 1f823f8:	movzbl (%rax,%rbx,1),%r14d
 1f823fd:	mov    %r14b,0x800(%rsp,%rdi,1)
 1f82405:	movzbl (%rcx,%rbx,1),%r14d
 1f8240a:	mov    %r14b,0x840(%rsp,%rdi,1)
 1f82412:	movzbl (%rdx,%rbx,1),%r14d
 1f82417:	mov    %r14b,0x880(%rsp,%rdi,1)
 1f8241f:	movzbl (%r11,%rbx,1),%r14d
 1f82424:	mov    %r14b,0x8c0(%rsp,%rdi,1)
 1f8242c:	movzbl (%r15,%rbx,1),%ebx
 1f82431:	mov    %bl,0x900(%rsp,%rdi,1)
 1f82438:	jne    1f823c9 <node_contexts_window_loop+0x1609>
 1f8243a:	vmovdqa64 0x180(%rsp),%zmm19
 1f82442:	vmovdqa64 0x1c0(%rsp),%zmm9
 1f8244a:	vmovdqa64 0x200(%rsp),%zmm4
 1f82452:	kmovq  0x110(%rsp),%k3
 1f8245c:	vmovdqu8 0x900(%rsp),%zmm31{%k2}
 1f82464:	vmovdqu8 0x7c0(%rsp),%zmm7{%k2}
 1f8246c:	vmovdqu8 0x840(%rsp),%zmm8{%k2}
 1f82474:	vmovdqu8 0x880(%rsp),%zmm3{%k2}
 1f8247c:	popcnt %r8,%rax
 1f82481:	add    0xa8(%rsp),%rax
 1f82489:	or     %r9,0x38(%rsp)
 1f8248e:	popcnt %r9,%rcx
 1f82493:	add    %rcx,%rax
 1f82496:	mov    %rax,0xa8(%rsp)
 1f8249e:	vmovdqu8 0x740(%rsp),%zmm4{%k3}
 1f824a6:	vmovdqu8 0x800(%rsp),%zmm19{%k2}
 1f824ae:	vmovdqu8 0x8c0(%rsp),%zmm9{%k2}
 1f824b6:	vmovdqa64 %zmm31,0x2c0(%rsp)
 1f824be:	vmovdqa64 %zmm4,0x200(%rsp)
 1f824c6:	vmovdqa64 %zmm19,0x180(%rsp)
 1f824ce:	vmovdqa64 %zmm9,0x1c0(%rsp)
 1f824d6:	jmp    1f81381 <node_contexts_window_loop+0x5c1>
 1f824db:	vbroadcasti32x4 -0x19d9af5(%rip),%zmm9        # 5a89f0 <.LCPI0_36>
 1f824e5:	cmpq   $0x0,0x68(%rsp)
 1f824eb:	mov    0x48(%rsp),%rax
 1f824f0:	je     1f825a0 <node_contexts_window_loop+0x17e0>
 1f824f6:	mov    %rax,%rcx
 1f824f9:	mov    (%rax),%rax
 1f824fc:	mov    0x8(%rax),%rax
 1f82500:	cmpb   $0x1,0x14a(%rax)
 1f82507:	jne    1f81fad <node_contexts_window_loop+0x11ed>
 1f8250d:	mov    0x2c0(%rcx),%rcx
 1f82514:	mov    0x68(%rsp),%r13
 1f82519:	xor    %r12d,%r12d
 1f8251c:	mov    %rax,0x3c0(%rsp)
 1f82524:	mov    %rbx,0x340(%rsp)
 1f8252c:	mov    %r11,0x60(%rsp)
 1f82531:	mov    %rdx,0x38(%rsp)
 1f82536:	vmovdqa64 %zmm31,0x400(%rsp)
 1f8253e:	vmovdqa64 %zmm4,0x440(%rsp)
 1f82546:	vmovdqa64 %zmm29,0x480(%rsp)
 1f8254e:	vmovdqa64 %zmm7,0x4c0(%rsp)
 1f82556:	vmovdqa64 %zmm28,0x500(%rsp)
 1f8255e:	vmovdqa64 %zmm27,0x540(%rsp)
 1f82566:	vmovdqa64 %zmm26,0x580(%rsp)
 1f8256e:	vmovdqa64 %zmm25,0x5c0(%rsp)
 1f82576:	vmovdqa64 %zmm24,0x600(%rsp)
 1f8257e:	vmovdqa64 %zmm23,0x640(%rsp)
 1f82586:	vmovdqa64 %zmm22,0x240(%rsp)
 1f8258e:	vmovdqa64 %zmm5,0x280(%rsp)
 1f82596:	mov    %rcx,0x380(%rsp)
 1f8259e:	jmp    1f825d2 <node_contexts_window_loop+0x1812>
 1f825a0:	mov    0x88(%rsp),%rax
 1f825a8:	xor    %ecx,%ecx
 1f825aa:	jmp    1f81fba <node_contexts_window_loop+0x11fa>
 1f825af:	lea    -0x1ab9a21(%rip),%rdx        # 4c8b95 <check_lower_segment_override.segments>
 1f825b6:	xor    %ecx,%ecx
 1f825b8:	testb  $0x3,-0x110(%rax,%rdx,1)
 1f825c0:	setne  %cl
 1f825c3:	shlx   %rbx,%rcx,%rax
 1f825c8:	or     %rax,%r12
 1f825cb:	blsr   %r13,%r13
 1f825d0:	je     1f82632 <node_contexts_window_loop+0x1872>
 1f825d2:	mov    0x30(%rsp),%rax
 1f825d7:	mov    0x80(%rsp),%rcx
 1f825df:	xor    %ebx,%ebx
 1f825e1:	tzcnt  %r13,%rbx
 1f825e6:	mov    0x380(%rsp),%rdx
 1f825ee:	mov    0x3c0(%rsp),%rdi
 1f825f6:	add    %ebx,%eax
 1f825f8:	movzwl 0x6b554(%rcx,%rax,2),%ecx
 1f82600:	sub    %ecx,%eax
 1f82602:	shl    $0x6,%rax
 1f82606:	mov    (%rdx,%rax,1),%esi
 1f82609:	vzeroupper
 1f8260c:	call   1f2a830 <type_object_qualifiers_slow>
 1f82611:	and    $0xffffff,%eax
 1f82616:	lea    -0x110(%rax),%ecx
 1f8261c:	cmp    $0x2,%ecx
 1f8261f:	jbe    1f825af <node_contexts_window_loop+0x17ef>
 1f82621:	xor    %ecx,%ecx
 1f82623:	shlx   %rbx,%rcx,%rax
 1f82628:	or     %rax,%r12
 1f8262b:	blsr   %r13,%r13
 1f82630:	jne    1f825d2 <node_contexts_window_loop+0x1812>
 1f82632:	mov    0x68(%rsp),%rcx
 1f82637:	vmovdqa64 0x280(%rsp),%zmm5
 1f8263f:	vbroadcasti32x4 -0x19d9c59(%rip),%zmm9        # 5a89f0 <.LCPI0_36>
 1f82649:	vbroadcasti32x4 -0x19d9c53(%rip),%zmm10        # 5a8a00 <.LCPI0_37>
 1f82653:	vbroadcasti32x4 -0x19d9c4d(%rip),%zmm11        # 5a8a10 <.LCPI0_38>
 1f8265d:	vbroadcasti32x4 -0x19d9c47(%rip),%zmm12        # 5a8a20 <.LCPI0_39>
 1f82667:	vbroadcasti32x4 -0x19d9c41(%rip),%zmm14        # 5a8a30 <.LCPI0_40>
 1f82671:	vbroadcasti32x4 -0x19d9c3b(%rip),%zmm15        # 5a8a40 <.LCPI0_41>
 1f8267b:	vbroadcasti32x4 -0x19d9c35(%rip),%zmm16        # 5a8a50 <.LCPI0_42>
 1f82685:	vbroadcasti32x4 -0x19d9c2f(%rip),%zmm17        # 5a8a60 <.LCPI0_43>
 1f8268f:	vbroadcasti32x4 -0x19d9c29(%rip),%zmm18        # 5a8a70 <.LCPI0_44>
 1f82699:	vbroadcasti32x4 -0x19d9c23(%rip),%zmm19        # 5a8a80 <.LCPI0_45>
 1f826a3:	vbroadcasti32x4 -0x19d9c1d(%rip),%zmm20        # 5a8a90 <.LCPI0_46>
 1f826ad:	vbroadcasti32x4 -0x19d9c17(%rip),%zmm21        # 5a8aa0 <.LCPI0_47>
 1f826b7:	vmovdqa64 0x240(%rsp),%zmm22
 1f826bf:	vmovdqa64 0x640(%rsp),%zmm23
 1f826c7:	vmovdqa64 0x600(%rsp),%zmm24
 1f826cf:	vmovdqa64 0x5c0(%rsp),%zmm25
 1f826d7:	vmovdqa64 0x580(%rsp),%zmm26
 1f826df:	vmovdqa64 0x540(%rsp),%zmm27
 1f826e7:	vmovdqa64 0x500(%rsp),%zmm28
 1f826ef:	vmovdqa64 0x4c0(%rsp),%zmm7
 1f826f7:	vmovdqa64 0x480(%rsp),%zmm29
 1f826ff:	vmovdqa64 0x440(%rsp),%zmm4
 1f82707:	vmovdqa64 0x400(%rsp),%zmm31
 1f8270f:	mov    0x80(%rsp),%rsi
 1f82717:	mov    0x30(%rsp),%r13
 1f8271c:	mov    0x88(%rsp),%rax
 1f82724:	mov    0x38(%rsp),%rdx
 1f82729:	mov    0x60(%rsp),%r11
 1f8272e:	mov    0x340(%rsp),%rbx
 1f82736:	vpxor  %xmm13,%xmm13,%xmm13
 1f8273b:	andn   %rcx,%r12,%rcx
 1f82740:	mov    0x7c(%rsp),%r12d
 1f82745:	jmp    1f81fba <node_contexts_window_loop+0x11fa>
 1f8274a:	vmovq  0xa8(%rsp),%xmm0
 1f82753:	vmovq  0xb0(%rsp),%xmm1
 1f8275c:	mov    0x148(%rsp),%rcx
 1f82764:	mov    0x58(%rsp),%rax
 1f82769:	mov    0x108(%rsp),%rdx
 1f82771:	vpunpcklqdq %xmm0,%xmm1,%xmm0
 1f82775:	vmovq  %rdx,%xmm1
 1f8277a:	vmovq  %rax,%xmm2
 1f8277f:	vpunpcklqdq %xmm1,%xmm2,%xmm1
 1f82783:	vinserti128 $0x1,%xmm0,%ymm1,%ymm0
 1f82789:	vinserti64x4 $0x1,%ymm5,%zmm0,%zmm0
 1f82790:	vpaddq (%rcx),%zmm0,%zmm0
 1f82796:	vmovdqu64 %zmm0,(%rcx)
 1f8279c:	lea    -0x28(%rbp),%rsp
 1f827a0:	pop    %rbx
 1f827a1:	pop    %r12
 1f827a3:	pop    %r13
 1f827a5:	pop    %r14
 1f827a7:	pop    %r15
 1f827a9:	pop    %rbp
 1f827aa:	vzeroupper
 1f827ad:	ret
Disassembly of section .init:
Disassembly of section .fini:
Disassembly of section .iplt:
