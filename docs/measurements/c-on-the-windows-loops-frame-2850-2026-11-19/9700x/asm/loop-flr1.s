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
 1f80dd1:	sub    $0x2c0,%rsp
 1f80dd8:	mov    0xb38(%rdi),%rax
 1f80ddf:	add    $0x3f,%edx
 1f80de2:	vpxor  %xmm0,%xmm0,%xmm0
 1f80de6:	mov    %rcx,0x70(%rsp)
 1f80deb:	vmovdqa64 %zmm0,0x240(%rsp)
 1f80df3:	vmovdqa64 %zmm0,0x200(%rsp)
 1f80dfb:	vmovdqa64 %zmm0,0x1c0(%rsp)
 1f80e03:	vmovdqa64 %zmm0,0x180(%rsp)
 1f80e0b:	vmovdqa64 %zmm0,0x140(%rsp)
 1f80e13:	vmovdqa64 %zmm0,0x100(%rsp)
 1f80e1b:	vmovdqa64 %zmm0,0xc0(%rsp)
 1f80e23:	vmovdqa64 %zmm0,0x80(%rsp)
 1f80e2b:	cmp    $0x40,%edx
 1f80e2e:	jae    1f80e59 <node_contexts_window_loop+0x99>
 1f80e30:	movq   $0x0,0x30(%rsp)
 1f80e39:	mov    0x70(%rsp),%rax
 1f80e3e:	mov    0x30(%rsp),%rcx
 1f80e43:	add    %rcx,0x18(%rax)
 1f80e47:	lea    -0x28(%rbp),%rsp
 1f80e4b:	pop    %rbx
 1f80e4c:	pop    %r12
 1f80e4e:	pop    %r13
 1f80e50:	pop    %r14
 1f80e52:	pop    %r15
 1f80e54:	pop    %rbp
 1f80e55:	vzeroupper
 1f80e58:	ret
 1f80e59:	vmovdqa64 -0x1acede3(%rip),%zmm2        # 4b2080 <abi_test_hex.digits+0xb380>
 1f80e63:	vmovdqa64 -0x1aced6d(%rip),%zmm4        # 4b2100 <abi_test_hex.digits+0xb400>
 1f80e6d:	vbroadcasti32x4 -0x19d8ac7(%rip),%zmm8        # 5a83b0 <.LCPI0_12>
 1f80e77:	vpbroadcastq -0x19d2801(%rip),%zmm9        # 5ae680 <.LCPI0_8>
 1f80e81:	vbroadcasti32x4 -0x19d8acb(%rip),%zmm11        # 5a83c0 <.LCPI0_13>
 1f80e8b:	vpbroadcastq -0x19d280d(%rip),%zmm12        # 5ae688 <.LCPI0_10>
 1f80e95:	vbroadcasti32x4 -0x19d8acf(%rip),%zmm13        # 5a83d0 <.LCPI0_14>
 1f80e9f:	vbroadcasti32x4 -0x19d8af9(%rip),%zmm15        # 5a83b0 <.LCPI0_12>
 1f80ea9:	shr    $0x6,%edx
 1f80eac:	mov    $0xffffffff,%r12d
 1f80eb2:	vpternlogd $0xff,%zmm10,%zmm10,%zmm10
 1f80eb9:	mov    $0xffffffffffffffff,%r10
 1f80ec0:	movabs $0x7fffffffffffffff,%r11
 1f80eca:	vpxor  %xmm14,%xmm14,%xmm14
 1f80ecf:	vpxord %xmm18,%xmm18,%xmm18
 1f80ed5:	movq   $0x0,0x30(%rsp)
 1f80ede:	mov    %rax,0x48(%rsp)
 1f80ee3:	mov    %rdi,0x50(%rsp)
 1f80ee8:	jmp    1f80f75 <node_contexts_window_loop+0x1b5>
 1f80eed:	nopl   (%rax)
 1f80ef0:	vptestmb %zmm17,%zmm17,%k1{%k1}
 1f80ef6:	vpmovb2m %zmm19,%k2
 1f80efc:	mov    0x78(%rsp),%r9
 1f80f01:	mov    0x40(%rsp),%rdx
 1f80f06:	kmovq  %k0,%rbx
 1f80f0b:	mov    0xbd0(%rdi),%r14
 1f80f12:	vmovdqa64 %zmm16,%zmm18
 1f80f18:	vptestmb %zmm17,%zmm17,%k0{%k2}
 1f80f1e:	andn   %rbx,%rax,%rax
 1f80f23:	vptestnmb %zmm16,%zmm16,%k2
 1f80f29:	and    %rcx,%rax
 1f80f2c:	kmovq  %k2,%r15
 1f80f31:	and    %rax,%r15
 1f80f34:	kmovq  %k1,%r8
 1f80f39:	mov    %r9d,%ebx
 1f80f3c:	shl    $0x6,%rbx
 1f80f40:	and    %r8,%rdx
 1f80f43:	mov    %rax,(%r14,%rbx,1)
 1f80f47:	mov    %r15,0x8(%r14,%rbx,1)
 1f80f4c:	kmovq  %k0,0x10(%r14,%rbx,1)
 1f80f53:	mov    0x48(%rsp),%rax
 1f80f58:	mov    %rdx,0x18(%r14,%rbx,1)
 1f80f5d:	mov    0x28(%rsp),%rdx
 1f80f62:	kmovq  %k0,0x20(%r14,%rbx,1)
 1f80f69:	dec    %rdx
 1f80f6c:	test   %r9d,%r9d
 1f80f6f:	je     1f80e39 <node_contexts_window_loop+0x79>
 1f80f75:	lea    -0x1(%rdx),%ebx
 1f80f78:	vmovdqa64 %zmm0,%zmm3
 1f80f7e:	vpbroadcastq -0x19d2910(%rip),%zmm0        # 5ae678 <.LCPI0_0>
 1f80f88:	vmovdqa64 %zmm14,%zmm1
 1f80f8e:	mov    0xba0(%rdi),%r8
 1f80f95:	mov    0xb88(%rdi),%r9
 1f80f9c:	mov    %rbx,%r15
 1f80f9f:	shl    $0x6,%r15
 1f80fa3:	test   %ebx,%ebx
 1f80fa5:	mov    %rbx,0x78(%rsp)
 1f80faa:	lea    -0x40(%r15),%ecx
 1f80fae:	vpandq 0x2c(%rsi,%r15,1),%zmm0,%zmm14
 1f80fb9:	vmovdqu64 0x196ac(%rsi,%r15,1),%zmm7
 1f80fc4:	vmovdqu64 (%rax),%zmm0
 1f80fca:	cmove  %ebx,%ecx
 1f80fcd:	shl    $0x7,%rbx
 1f80fd1:	vmovdqu64 0x6f654(%rsi,%rbx,1),%zmm22
 1f80fdc:	vmovdqu64 0x6f694(%rsi,%rbx,1),%zmm23
 1f80fe7:	vmovdqu64 0x6b554(%rsi,%rbx,1),%zmm5
 1f80ff2:	vmovdqu64 0x6b594(%rsi,%rbx,1),%zmm16
 1f80ffd:	vmovdqu64 0x6d5d4(%rsi,%rbx,1),%zmm26
 1f81008:	vmovdqu64 0x6d614(%rsi,%rbx,1),%zmm27
 1f81013:	mov    0xb98(%rdi),%rbx
 1f8101a:	vmovdqu64 (%r8,%r15,1),%zmm6
 1f81021:	vmovdqu64 (%r9,%r15,1),%zmm21
 1f81028:	vmovdqu64 (%r9,%rcx,1),%zmm30
 1f8102f:	vpandd -0x19cff59(%rip){1to16},%zmm6,%zmm17        # 5b10e0 <.LCPI0_15>
 1f81039:	vmovdqu64 (%rbx,%r15,1),%zmm19
 1f81040:	vmovdqu64 (%rbx,%rcx,1),%zmm31
 1f81047:	vpermt2b 0x40(%rax),%zmm14,%zmm0
 1f8104e:	vptestmb %zmm7,%zmm7,%k3
 1f81054:	vmovdqa64 %zmm14,%zmm24
 1f8105a:	mov    0xb80(%rdi),%rax
 1f81061:	vpmovuswb %zmm22,%ymm22
 1f81067:	vpmovuswb %zmm23,%ymm23
 1f8106d:	vpmovuswb %zmm5,%ymm5
 1f81073:	vpmovuswb %zmm16,%ymm16
 1f81079:	vptestmb %zmm17,%zmm17,%k0
 1f8107f:	vmovdqu64 (%rax,%r15,1),%zmm20
 1f81086:	vmovdqu64 (%rax,%rcx,1),%zmm29
 1f8108d:	vinserti64x4 $0x1,%ymm23,%zmm22,%zmm28
 1f81094:	vpaddb -0x1acefde(%rip),%zmm28,%zmm22        # 4b20c0 <abi_test_hex.digits+0xb3c0>
 1f8109e:	vinserti64x4 $0x1,%ymm16,%zmm5,%zmm5
 1f810a5:	vpcmpleub %zmm2,%zmm28,%k2{%k3}
 1f810ac:	vmovdqa64 %zmm0,%zmm23
 1f810b2:	vptestmb %zmm5,%zmm5,%k1
 1f810b8:	kandq  %k0,%k3,%k3
 1f810bd:	vpsubb %zmm5,%zmm4,%zmm25
 1f810c3:	kandq  %k1,%k0,%k4
 1f810c8:	kmovq  %k1,%r13
 1f810cd:	vpcmpnltub %zmm5,%zmm4,%k1
 1f810d4:	vpcmpnleub %zmm2,%zmm28,%k3{%k3}
 1f810db:	vmovdqu64 (%r8,%rcx,1),%zmm28
 1f810e2:	kmovq  %k1,%r14
 1f810e7:	vpcmpltub %zmm5,%zmm4,%k4{%k4}
 1f810ee:	and    %r13,%r14
 1f810f1:	mov    0xb90(%rdi),%r13
 1f810f8:	kortestq %k3,%k4
 1f810fd:	kmovq  %r14,%k5
 1f81102:	vpermt2b %zmm3,%zmm22,%zmm23{%k2}{z}
 1f81108:	vpermt2b %zmm1,%zmm22,%zmm24{%k2}{z}
 1f8110e:	vpmovuswb %zmm27,%ymm3
 1f81114:	vpmovuswb %zmm26,%ymm1
 1f8111a:	vmovdqu64 0x0(%r13,%rcx,1),%zmm27
 1f81122:	vmovdqu64 0x0(%r13,%r15,1),%zmm16
 1f8112a:	vpermt2b %zmm6,%zmm25,%zmm28{%k5}{z}
 1f81130:	vinserti64x4 $0x1,%ymm3,%zmm1,%zmm1
 1f81137:	vpcmpltub -0x1acf002(%rip),%zmm1,%k1        # 4b2140 <abi_test_hex.digits+0xb440>
 1f81142:	vmovdqa64 %zmm30,%zmm3
 1f81148:	vpermt2b %zmm21,%zmm25,%zmm3{%k5}{z}
 1f8114e:	vpsubb %zmm1,%zmm4,%zmm7
 1f81154:	vpermt2b %zmm21,%zmm7,%zmm30
 1f8115a:	vmovdqa64 %zmm27,%zmm5
 1f81160:	vpermt2b %zmm16,%zmm25,%zmm5{%k5}{z}
 1f81166:	vpermt2b %zmm16,%zmm7,%zmm27
 1f8116c:	vptestmb %zmm1,%zmm1,%k1{%k1}
 1f81172:	vbroadcasti32x4 -0x19d8d9c(%rip),%zmm1        # 5a83e0 <.LCPI0_16>
 1f8117c:	vpandq 0x2c(%rsi,%rcx,1),%zmm1,%zmm26
 1f81187:	vmovdqa64 %zmm29,%zmm1
 1f8118d:	vpermt2b %zmm20,%zmm25,%zmm1{%k5}{z}
 1f81193:	vpermt2b %zmm20,%zmm7,%zmm29
 1f81199:	kmovq  %k3,%rcx
 1f8119e:	mov    %rcx,0x38(%rsp)
 1f811a3:	vpermt2b %zmm14,%zmm25,%zmm26{%k5}{z}
 1f811a9:	vpermi2b %zmm19,%zmm31,%zmm25{%k5}{z}
 1f811af:	vpermt2b %zmm19,%zmm7,%zmm31
 1f811b5:	jne    1f81350 <node_contexts_window_loop+0x590>
 1f811bb:	vmovdqu64 0x1a72c(%rsi,%r15,1),%zmm6
 1f811c6:	mov    0x50(%rsp),%rdi
 1f811cb:	vpternlogq $0x96,%zmm29,%zmm30,%zmm27
 1f811d2:	vpcmpgtb %zmm10,%zmm23,%k5
 1f811d8:	mov    $0x0,%r8d
 1f811de:	mov    %r14,0x40(%rsp)
 1f811e3:	mov    %rdx,0x28(%rsp)
 1f811e8:	vpternlogq $0x96,%zmm31,%zmm25,%zmm27
 1f811ef:	vmovdqu8 %zmm27,%zmm25{%k1}
 1f811f5:	vpxorq %zmm28,%zmm25,%zmm7
 1f811fb:	vpternlogq $0x96,%zmm5,%zmm3,%zmm7
 1f81202:	vpternlogq $0x96,%zmm1,%zmm26,%zmm7
 1f81209:	vpandq %zmm12,%zmm0,%zmm1
 1f8120f:	mov    0xbb0(%rdi),%rax
 1f81216:	vpternlogq $0x96,%zmm24,%zmm23,%zmm7
 1f8121d:	vpternlogq $0x96,%zmm7,%zmm0,%zmm20
 1f81224:	vpternlogq $0x96,%zmm21,%zmm20,%zmm16
 1f8122b:	vptestmb %zmm6,%zmm6,%k4
 1f81231:	vpternlogq $0x28,%zmm9,%zmm19,%zmm16
 1f81238:	korq   %k4,%k5,%k6
 1f8123d:	vpermi2b %zmm18,%zmm16,%zmm22{%k2}{z}
 1f81243:	vpcmpneqb %zmm11,%zmm24,%k5
 1f8124a:	knotq  %k6,%k6
 1f8124f:	vmovdqu8 %zmm8,%zmm3{%k6}{z}
 1f81255:	vmovdqu64 %zmm3,(%rax,%r15,1)
 1f8125c:	mov    0xbc0(%rdi),%rax
 1f81263:	vmovdqu64 %zmm1,(%rax,%r15,1)
 1f8126a:	mov    0x48(%rsp),%rax
 1f8126f:	vmovdqu8 0xc0(%rsp),%zmm22{%k3}
 1f81277:	mov    0xba8(%rdi),%rcx
 1f8127e:	vpaddw %zmm22,%zmm22,%zmm3
 1f81284:	vporq  %zmm8,%zmm3,%zmm5
 1f8128a:	vmovdqu8 %zmm5,%zmm3{%k4}
 1f81290:	vpermb 0x80(%rax),%zmm3,%zmm3
 1f81297:	vmovdqu64 %zmm16,(%rcx,%r15,1)
 1f8129e:	mov    %r12d,%ecx
 1f812a1:	sub    %r15d,%ecx
 1f812a4:	mov    0xbb8(%rdi),%rax
 1f812ab:	vpandq %zmm13,%zmm3,%zmm5
 1f812b1:	vmovdqu8 %zmm5,%zmm5{%k5}{z}
 1f812b7:	vmovdqu64 %zmm5,(%rax,%r15,1)
 1f812be:	mov    $0xffffffffffffffff,%rax
 1f812c5:	jbe    1f812d7 <node_contexts_window_loop+0x517>
 1f812c7:	lea    0x40(%r15),%eax
 1f812cb:	cmp    %eax,%r12d
 1f812ce:	shlx   %rcx,%r10,%rax
 1f812d3:	cmovae %r8,%rax
 1f812d7:	vpmovb2m %zmm3,%k2
 1f812dd:	vpcmpneqb %zmm15,%zmm1,%k3
 1f812e4:	kmovq  %k2,%rcx
 1f812e9:	kmovq  %k3,%rbx
 1f812ee:	andn   %rbx,%rcx,%rbx
 1f812f3:	and    0x38(%rsp),%rbx
 1f812f8:	je     1f80ef0 <node_contexts_window_loop+0x130>
 1f812fe:	xchg   %ax,%ax
 1f81300:	xor    %r13d,%r13d
 1f81303:	tzcnt  %rbx,%r13
 1f81308:	mov    %r12d,%r9d
 1f8130b:	lea    (%r15,%r13,1),%r14d
 1f8130f:	sub    0x651b8(%rsi,%r14,4),%r14d
 1f81317:	lea    0x1(%r14),%r14d
 1f8131b:	cmovb  %r8d,%r14d
 1f8131f:	mov    %r14d,%edx
 1f81322:	sub    %r15d,%edx
 1f81325:	cmp    %r12d,%r14d
 1f81328:	cmovb  %r14d,%r9d
 1f8132c:	cmp    %r15d,%r14d
 1f8132f:	shlx   %rdx,%r10,%rdx
 1f81334:	cmovbe %r11,%rdx
 1f81338:	cmovb  %r9d,%r12d
 1f8133c:	bzhi   %r13,%rdx,%rdx
 1f81341:	or     %rdx,%rax
 1f81344:	blsr   %rbx,%rbx
 1f81349:	jne    1f81300 <node_contexts_window_loop+0x540>
 1f8134b:	jmp    1f80ef0 <node_contexts_window_loop+0x130>
 1f81350:	cmpq   $0x0,0x38(%rsp)
 1f81356:	mov    %r8,0x58(%rsp)
 1f8135b:	mov    %r9,0x40(%rsp)
 1f81360:	mov    %rax,0x68(%rsp)
 1f81365:	je     1f813fa <node_contexts_window_loop+0x63a>
 1f8136b:	mov    0x50(%rsp),%rcx
 1f81370:	mov    0xba8(%rcx),%rax
 1f81377:	mov    %rax,0x60(%rsp)
 1f8137c:	mov    0x38(%rsp),%rax
 1f81381:	xor    %r9d,%r9d
 1f81384:	tzcnt  %rax,%r9
 1f81389:	mov    %rax,0x28(%rsp)
 1f8138e:	lea    (%r15,%r9,1),%eax
 1f81392:	movzwl 0x6f654(%rsi,%rax,2),%edi
 1f8139a:	add    %eax,%edi
 1f8139c:	mov    0x60(%rsp),%rax
 1f813a1:	movzwl 0x6b554(%rsi,%rdi,2),%ecx
 1f813a9:	movzbl 0x2c(%rsi,%rdi,1),%r8d
 1f813af:	movzbl (%rax,%rdi,1),%eax
 1f813b3:	sub    %ecx,%edi
 1f813b5:	mov    0x48(%rsp),%rcx
 1f813ba:	and    $0x7f,%r8d
 1f813be:	testb  $0x7f,0x2c(%rsi,%rdi,1)
 1f813c3:	movzbl (%rcx,%r8,1),%ecx
 1f813c8:	setne  %dil
 1f813cc:	add    %dil,%dil
 1f813cf:	or     $0x14,%dil
 1f813d3:	cmp    $0x14,%al
 1f813d5:	mov    %cl,0x80(%rsp,%r9,1)
 1f813dd:	movzbl %dil,%ecx
 1f813e1:	cmovne %eax,%ecx
 1f813e4:	mov    %cl,0xc0(%rsp,%r9,1)
 1f813ec:	mov    0x28(%rsp),%rcx
 1f813f1:	xor    %eax,%eax
 1f813f3:	blsr   %rcx,%rax
 1f813f8:	jne    1f81381 <node_contexts_window_loop+0x5c1>
 1f813fa:	mov    0x58(%rsp),%r8
 1f813ff:	kmovq  %k4,%rax
 1f81404:	mov    %rax,%rdi
 1f81407:	mov    %rax,0x28(%rsp)
 1f8140c:	test   %rax,%rax
 1f8140f:	je     1f81486 <node_contexts_window_loop+0x6c6>
 1f81411:	xor    %eax,%eax
 1f81413:	tzcnt  %rdi,%rax
 1f81418:	lea    (%r15,%rax,1),%r9d
 1f8141c:	movzwl 0x6b554(%rsi,%r9,2),%ecx
 1f81425:	sub    %ecx,%r9d
 1f81428:	movzbl 0x2c(%rsi,%r9,1),%ecx
 1f8142e:	and    $0x7f,%cl
 1f81431:	blsr   %rdi,%rdi
 1f81436:	mov    %cl,0x100(%rsp,%rax,1)
 1f8143d:	mov    0x68(%rsp),%rcx
 1f81442:	movzbl (%rcx,%r9,1),%ecx
 1f81447:	mov    %cl,0x140(%rsp,%rax,1)
 1f8144e:	mov    0x40(%rsp),%rcx
 1f81453:	movzbl (%rcx,%r9,1),%ecx
 1f81458:	mov    %cl,0x180(%rsp,%rax,1)
 1f8145f:	movzbl 0x0(%r13,%r9,1),%ecx
 1f81465:	mov    %cl,0x1c0(%rsp,%rax,1)
 1f8146c:	movzbl (%r8,%r9,1),%ecx
 1f81471:	mov    %cl,0x200(%rsp,%rax,1)
 1f81478:	movzbl (%rbx,%r9,1),%ecx
 1f8147d:	mov    %cl,0x240(%rsp,%rax,1)
 1f81484:	jne    1f81411 <node_contexts_window_loop+0x651>
 1f81486:	vmovdqu8 0x80(%rsp),%zmm23{%k3}
 1f8148e:	vmovdqu8 0x100(%rsp),%zmm26{%k4}
 1f81496:	vmovdqu8 0x140(%rsp),%zmm1{%k4}
 1f8149e:	vmovdqu8 0x180(%rsp),%zmm3{%k4}
 1f814a6:	vmovdqu8 0x1c0(%rsp),%zmm5{%k4}
 1f814ae:	vmovdqu8 0x200(%rsp),%zmm28{%k4}
 1f814b6:	vmovdqu8 0x240(%rsp),%zmm25{%k4}
 1f814be:	popcnt 0x38(%rsp),%rax
 1f814c5:	mov    0x28(%rsp),%rdi
 1f814ca:	add    0x30(%rsp),%rax
 1f814cf:	popcnt %rdi,%rcx
 1f814d4:	or     %rdi,%r14
 1f814d7:	add    %rcx,%rax
 1f814da:	mov    %rax,0x30(%rsp)
 1f814df:	jmp    1f811bb <node_contexts_window_loop+0x3fb>
Disassembly of section .init:
Disassembly of section .fini:
Disassembly of section .iplt:
