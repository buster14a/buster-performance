
/home/david/buster-fast-bench/codex-180-fix-20261026-main/build/compiler:     file format elf64-x86-64


Disassembly of section .text:

000000000193c240 <x86_encode_16>:
 193c240:	55                   	push   %rbp
 193c241:	48 89 e5             	mov    %rsp,%rbp
 193c244:	41 57                	push   %r15
 193c246:	41 56                	push   %r14
 193c248:	41 54                	push   %r12
 193c24a:	53                   	push   %rbx
 193c24b:	48 83 e4 c0          	and    $0xffffffffffffffc0,%rsp
 193c24f:	48 81 ec 80 01 00 00 	sub    $0x180,%rsp
 193c256:	64 48 8b 04 25 28 00 00 00 	mov    %fs:0x28,%rax
 193c25f:	48 89 d3             	mov    %rdx,%rbx
 193c262:	48 89 f2             	mov    %rsi,%rdx
 193c265:	48 89 fe             	mov    %rdi,%rsi
 193c268:	48 89 84 24 48 01 00 00 	mov    %rax,0x148(%rsp)
 193c270:	48 85 c9             	test   %rcx,%rcx
 193c273:	74 10                	je     193c285 <x86_encode_16+0x45>
 193c275:	48 83 fa 10          	cmp    $0x10,%rdx
 193c279:	73 1e                	jae    193c299 <x86_encode_16+0x59>
 193c27b:	31 c0                	xor    %eax,%eax
 193c27d:	48 89 df             	mov    %rbx,%rdi
 193c280:	e9 49 06 00 00       	jmp    193c8ce <x86_encode_16+0x68e>
 193c285:	48 83 fa 10          	cmp    $0x10,%rdx
 193c289:	0f 83 0c 13 00 00    	jae    193d59b <x86_encode_16+0x135b>
 193c28f:	31 c0                	xor    %eax,%eax
 193c291:	49 89 de             	mov    %rbx,%r14
 193c294:	e9 a0 18 00 00       	jmp    193db39 <x86_encode_16+0x18f9>
 193c299:	62 f2 7d 48 5a 1d ad 06 c7 fe 	vbroadcasti32x4 -0x138f953(%rip),%zmm3        # 5ac950 <x86_effects_unknown+0x980>
 193c2a3:	62 72 7d 48 58 0d 7b a9 c7 fe 	vpbroadcastd -0x1385685(%rip),%zmm9        # 5b6c28 <tier0_emit_x87.operations+0x1d8>
 193c2ad:	4c 8d 42 f0          	lea    -0x10(%rdx),%r8
 193c2b1:	40 b7 cc             	mov    $0xcc,%dil
 193c2b4:	4c 8d 8e fc 00 00 00 	lea    0xfc(%rsi),%r9
 193c2bb:	4c 8d 15 7e 01 32 0d 	lea    0xd32017e(%rip),%r10        # ec5c440 <x86_template_storage>
 193c2c2:	62 53 1d 48 25 e4 ff 	vpternlogd $0xff,%zmm12,%zmm12,%zmm12
 193c2c9:	31 c0                	xor    %eax,%eax
 193c2cb:	49 89 db             	mov    %rbx,%r11
 193c2ce:	49 c1 e8 04          	shr    $0x4,%r8
 193c2d2:	c5 fb 92 cf          	kmovd  %edi,%k1
 193c2d6:	49 ff c0             	inc    %r8
 193c2d9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
 193c2e0:	41 0f b7 b9 10 ff ff ff 	movzwl -0xf0(%r9),%edi
 193c2e8:	45 0f b7 b1 20 ff ff ff 	movzwl -0xe0(%r9),%r14d
 193c2f0:	45 0f b7 b9 30 ff ff ff 	movzwl -0xd0(%r9),%r15d
 193c2f8:	45 0f b7 a1 40 ff ff ff 	movzwl -0xc0(%r9),%r12d
 193c300:	62 c1 fe 48 6f a1 04 ff ff ff 	vmovdqu64 -0xfc(%r9),%zmm20
 193c30a:	62 41 fe 48 6f 99 44 ff ff ff 	vmovdqu64 -0xbc(%r9),%zmm27
 193c314:	62 41 fe 48 6f a9 84 ff ff ff 	vmovdqu64 -0x7c(%r9),%zmm29
 193c31e:	62 41 fe 48 6f b1 c4 ff ff ff 	vmovdqu64 -0x3c(%r9),%zmm30
 193c328:	62 f2 7d 48 5a 2d 5e 06 c7 fe 	vbroadcasti32x4 -0x138f9a2(%rip),%zmm5        # 5ac990 <x86_effects_unknown+0x9c0>
 193c332:	62 f2 7d 48 5a 05 64 06 c7 fe 	vbroadcasti32x4 -0x138f99c(%rip),%zmm0        # 5ac9a0 <x86_effects_unknown+0x9d0>
 193c33c:	62 72 7d 48 58 05 ca a8 c7 fe 	vpbroadcastd -0x1385736(%rip),%zmm8        # 5b6c10 <tier0_emit_x87.operations+0x1c0>
 193c346:	48 83 c0 10          	add    $0x10,%rax
 193c34a:	c1 e7 06             	shl    $0x6,%edi
 193c34d:	41 c1 e6 06          	shl    $0x6,%r14d
 193c351:	41 c1 e7 06          	shl    $0x6,%r15d
 193c355:	41 c1 e4 06          	shl    $0x6,%r12d
 193c359:	c4 a1 7d 6f 4c 17 40 	vmovdqa 0x40(%rdi,%r10,1),%ymm1
 193c360:	41 0f b7 b9 50 ff ff ff 	movzwl -0xb0(%r9),%edi
 193c368:	62 13 f5 48 3a 5c 17 02 01 	vinserti64x4 $0x1,0x40(%r15,%r10,1),%zmm1,%zmm11
 193c371:	45 0f b7 b9 70 ff ff ff 	movzwl -0x90(%r9),%r15d
 193c379:	c4 81 7d 6f 4c 16 60 	vmovdqa 0x60(%r14,%r10,1),%ymm1
 193c380:	45 0f b7 b1 60 ff ff ff 	movzwl -0xa0(%r9),%r14d
 193c388:	62 83 f5 48 3a 74 14 03 01 	vinserti64x4 $0x1,0x60(%r12,%r10,1),%zmm1,%zmm22
 193c391:	45 0f b7 61 80       	movzwl -0x80(%r9),%r12d
 193c396:	62 11 15 40 62 fe    	vpunpckldq %zmm30,%zmm29,%zmm15
 193c39c:	62 01 5d 40 6a e3    	vpunpckhdq %zmm27,%zmm20,%zmm28
 193c3a2:	62 01 15 40 6a ee    	vpunpckhdq %zmm30,%zmm29,%zmm29
 193c3a8:	62 11 5d 40 62 f3    	vpunpckldq %zmm27,%zmm20,%zmm14
 193c3ae:	62 11 9d 40 6c d5    	vpunpcklqdq %zmm29,%zmm28,%zmm10
 193c3b4:	62 41 8d 48 6d f7    	vpunpckhqdq %zmm15,%zmm14,%zmm30
 193c3ba:	62 d2 fd 48 83 f2    	vpmultishiftqb %zmm10,%zmm0,%zmm6
 193c3c0:	62 92 0d 40 27 c6    	vptestmd %zmm30,%zmm30,%k0
 193c3c6:	62 91 7d 48 72 e6 1f 	vpsrad $0x1f,%zmm30,%zmm0
 193c3cd:	62 41 fd 48 6f da    	vmovdqa64 %zmm10,%zmm27
 193c3d3:	c1 e7 06             	shl    $0x6,%edi
 193c3d6:	c4 a1 7d 6f 4c 17 40 	vmovdqa 0x40(%rdi,%r10,1),%ymm1
 193c3dd:	41 0f b7 79 90       	movzwl -0x70(%r9),%edi
 193c3e2:	41 c1 e7 06          	shl    $0x6,%r15d
 193c3e6:	41 c1 e6 06          	shl    $0x6,%r14d
 193c3ea:	62 83 f5 48 3a 44 17 02 01 	vinserti64x4 $0x1,0x40(%r15,%r10,1),%zmm1,%zmm16
 193c3f3:	45 0f b7 79 b0       	movzwl -0x50(%r9),%r15d
 193c3f8:	c4 81 7d 6f 4c 16 60 	vmovdqa 0x60(%r14,%r10,1),%ymm1
 193c3ff:	45 0f b7 71 a0       	movzwl -0x60(%r9),%r14d
 193c404:	41 c1 e4 06          	shl    $0x6,%r12d
 193c408:	62 03 f5 48 3a 44 14 03 01 	vinserti64x4 $0x1,0x60(%r12,%r10,1),%zmm1,%zmm24
 193c411:	45 0f b7 61 c0       	movzwl -0x40(%r9),%r12d
 193c416:	62 32 a5 49 64 ee    	vpblendmq %zmm22,%zmm11,%zmm13{%k1}
 193c41c:	c1 e7 06             	shl    $0x6,%edi
 193c41f:	c4 a1 7d 6f 4c 17 40 	vmovdqa 0x40(%rdi,%r10,1),%ymm1
 193c426:	41 0f b7 79 d0       	movzwl -0x30(%r9),%edi
 193c42b:	41 c1 e7 06          	shl    $0x6,%r15d
 193c42f:	41 c1 e6 06          	shl    $0x6,%r14d
 193c433:	62 83 f5 48 3a 54 17 02 01 	vinserti64x4 $0x1,0x40(%r15,%r10,1),%zmm1,%zmm18
 193c43c:	45 0f b7 79 f0       	movzwl -0x10(%r9),%r15d
 193c441:	c4 81 7d 6f 4c 16 60 	vmovdqa 0x60(%r14,%r10,1),%ymm1
 193c448:	45 0f b7 71 e0       	movzwl -0x20(%r9),%r14d
 193c44d:	41 c1 e4 06          	shl    $0x6,%r12d
 193c451:	62 03 f5 48 3a 4c 14 03 01 	vinserti64x4 $0x1,0x60(%r12,%r10,1),%zmm1,%zmm25
 193c45a:	45 0f b7 21          	movzwl (%r9),%r12d
 193c45e:	49 81 c1 00 01 00 00 	add    $0x100,%r9
 193c465:	62 82 fd 41 64 c8    	vpblendmq %zmm24,%zmm16,%zmm17{%k1}
 193c46b:	c1 e7 06             	shl    $0x6,%edi
 193c46e:	41 c1 e6 06          	shl    $0x6,%r14d
 193c472:	41 c1 e7 06          	shl    $0x6,%r15d
 193c476:	c4 a1 7d 6f 4c 17 40 	vmovdqa 0x40(%rdi,%r10,1),%ymm1
 193c47d:	62 83 f5 48 3a 6c 17 02 01 	vinserti64x4 $0x1,0x40(%r15,%r10,1),%zmm1,%zmm21
 193c486:	41 c1 e4 06          	shl    $0x6,%r12d
 193c48a:	c4 81 7d 6f 4c 16 60 	vmovdqa 0x60(%r14,%r10,1),%ymm1
 193c491:	62 03 f5 48 3a 54 14 03 01 	vinserti64x4 $0x1,0x60(%r12,%r10,1),%zmm1,%zmm26
 193c49a:	62 b1 15 48 6a c9    	vpunpckhdq %zmm17,%zmm13,%zmm1
 193c4a0:	62 82 ed 41 64 d9    	vpblendmq %zmm25,%zmm18,%zmm19{%k1}
 193c4a6:	62 82 d5 41 64 fa    	vpblendmq %zmm26,%zmm21,%zmm23{%k1}
 193c4ac:	62 b1 65 40 6a d7    	vpunpckhdq %zmm23,%zmm19,%zmm2
 193c4b2:	62 e1 f5 48 6d e2    	vpunpckhqdq %zmm2,%zmm1,%zmm20
 193c4b8:	62 d1 75 48 72 d2 1a 	vpsrld $0x1a,%zmm10,%zmm1
 193c4bf:	62 f2 75 48 36 3d f7 bf c0 fe 	vpermd -0x13f4009(%rip),%zmm1,%zmm7        # 5484c0 <branch_sizing_patterns+0x2830>
 193c4c9:	62 62 75 48 36 3d 2d c0 c0 fe 	vpermd -0x13f3fd3(%rip),%zmm1,%zmm31        # 548500 <branch_sizing_patterns+0x2870>
 193c4d3:	62 f2 75 48 36 25 63 c0 c0 fe 	vpermd -0x13f3f9d(%rip),%zmm1,%zmm4        # 548540 <branch_sizing_patterns+0x28b0>
 193c4dd:	62 d2 d5 48 83 ca    	vpmultishiftqb %zmm10,%zmm5,%zmm1
 193c4e3:	62 f2 7d 48 5a 2d c3 04 c7 fe 	vbroadcasti32x4 -0x138fb3d(%rip),%zmm5        # 5ac9b0 <x86_effects_unknown+0x9e0>
 193c4ed:	62 d2 d5 48 83 ea    	vpmultishiftqb %zmm10,%zmm5,%zmm5
 193c4f3:	62 f3 75 58 25 2d 06 a7 c7 fe d8 	vpternlogd $0xd8,-0x13858fa(%rip){1to16},%zmm1,%zmm5        # 5b6c04 <tier0_emit_x87.operations+0x1b4>
 193c4fe:	62 d1 75 48 72 f2 04 	vpslld $0x4,%zmm10,%zmm1
 193c505:	62 f1 6d 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm2
 193c50c:	62 f3 55 58 25 35 f1 a6 c7 fe e4 	vpternlogd $0xe4,-0x138590f(%rip){1to16},%zmm5,%zmm6        # 5b6c08 <tier0_emit_x87.operations+0x1b8>
 193c517:	62 f2 7d 48 5a 2d 9f 04 c7 fe 	vbroadcasti32x4 -0x138fb61(%rip),%zmm5        # 5ac9c0 <x86_effects_unknown+0x9f0>
 193c521:	62 d2 55 48 00 ea    	vpshufb %zmm10,%zmm5,%zmm5
 193c527:	62 63 4d 48 25 ff f8 	vpternlogd $0xf8,%zmm7,%zmm6,%zmm31
 193c52e:	62 f1 75 48 72 f5 10 	vpslld $0x10,%zmm5,%zmm1
 193c535:	62 f1 6d 48 db ed    	vpandd %zmm5,%zmm2,%zmm5
 193c53b:	62 f3 5d 58 25 2d fe a6 c7 fe ec 	vpternlogd $0xec,-0x1385902(%rip){1to16},%zmm4,%zmm5        # 5b6c44 <tier0_emit_x87.operations+0x1f4>
 193c546:	62 f1 45 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm7
 193c54d:	62 f2 7e 48 38 c8    	vpmovm2d %k0,%zmm1
 193c553:	62 f3 5d 50 25 2d ea a6 c7 fe f8 	vpternlogd $0xf8,-0x1385916(%rip){1to16},%zmm20,%zmm5        # 5b6c48 <tier0_emit_x87.operations+0x1f8>
 193c55e:	62 f3 6d 48 25 cf c8 	vpternlogd $0xc8,%zmm7,%zmm2,%zmm1
 193c565:	62 91 7d 48 ef fe    	vpxord %zmm30,%zmm0,%zmm7
 193c56b:	62 f2 7d 48 58 05 97 a6 c7 fe 	vpbroadcastd -0x1385969(%rip),%zmm0        # 5b6c0c <tier0_emit_x87.operations+0x1bc>
 193c575:	62 f2 7d 48 44 ff    	vplzcntd %zmm7,%zmm7
 193c57b:	62 f2 3d 48 45 ff    	vpsrlvd %zmm7,%zmm8,%zmm7
 193c581:	62 51 0d 40 fe c4    	vpaddd %zmm12,%zmm30,%zmm8
 193c587:	62 73 0d 40 25 c7 14 	vpternlogd $0x14,%zmm7,%zmm30,%zmm8
 193c58e:	62 d1 45 48 72 d2 08 	vpsrld $0x8,%zmm10,%zmm7
 193c595:	62 63 7d 58 25 1d 7c a6 c7 fe 6c 	vpternlogd $0x6c,-0x1385984(%rip){1to16},%zmm0,%zmm27        # 5b6c1c <tier0_emit_x87.operations+0x1cc>
 193c5a0:	62 f3 7d 58 25 3d 75 a6 c7 fe 6c 	vpternlogd $0x6c,-0x138598b(%rip){1to16},%zmm0,%zmm7        # 5b6c20 <tier0_emit_x87.operations+0x1d0>
 193c5ab:	62 91 7d 48 72 ce 01 	vprold $0x1,%zmm30,%zmm0
 193c5b2:	62 41 25 40 fe dc    	vpaddd %zmm12,%zmm27,%zmm27
 193c5b8:	62 63 35 58 25 1d 61 a6 c7 fe ec 	vpternlogd $0xec,-0x138599f(%rip){1to16},%zmm9,%zmm27        # 5b6c24 <tier0_emit_x87.operations+0x1d4>
 193c5c3:	62 d1 45 48 fe fc    	vpaddd %zmm12,%zmm7,%zmm7
 193c5c9:	62 f3 25 50 25 3d 58 a6 c7 fe ec 	vpternlogd $0xec,-0x13859a8(%rip){1to16},%zmm27,%zmm7        # 5b6c2c <tier0_emit_x87.operations+0x1dc>
 193c5d4:	62 61 4d 58 db 1d 52 a6 c7 fe 	vpandd -0x13859ae(%rip){1to16},%zmm6,%zmm27        # 5b6c30 <tier0_emit_x87.operations+0x1e0>
 193c5de:	62 f1 4d 48 72 d6 03 	vpsrld $0x3,%zmm6,%zmm6
 193c5e5:	62 f3 5d 50 25 35 4c a6 c7 fe a2 	vpternlogd $0xa2,-0x13859b4(%rip){1to16},%zmm20,%zmm6        # 5b6c3c <tier0_emit_x87.operations+0x1ec>
 193c5f0:	62 f2 4d 58 3b 25 46 a6 c7 fe 	vpminud -0x13859ba(%rip){1to16},%zmm6,%zmm4        # 5b6c40 <tier0_emit_x87.operations+0x1f0>
 193c5fa:	62 63 5d 40 25 df f8 	vpternlogd $0xf8,%zmm7,%zmm20,%zmm27
 193c601:	62 62 25 50 3b 1d 29 a6 c7 fe 	vpminud -0x13859d7(%rip){1to16},%zmm27,%zmm27        # 5b6c34 <tier0_emit_x87.operations+0x1e4>
 193c60b:	62 b1 45 48 72 d4 1d 	vpsrld $0x1d,%zmm20,%zmm7
 193c612:	62 72 3d 48 14 c7    	vprorvd %zmm7,%zmm8,%zmm8
 193c618:	62 f2 7d 48 14 ff    	vprorvd %zmm7,%zmm0,%zmm7
 193c61e:	62 f1 fd 48 6f 05 58 be c0 fe 	vmovdqa64 -0x13f41a8(%rip),%zmm0        # 548480 <branch_sizing_patterns+0x27f0>
 193c628:	62 d1 3d 48 72 e0 1f 	vpsrad $0x1f,%zmm8,%zmm8
 193c62f:	62 93 75 48 25 fe e2 	vpternlogd $0xe2,%zmm30,%zmm1,%zmm7
 193c636:	62 93 3d 48 25 fe e2 	vpternlogd $0xe2,%zmm30,%zmm8,%zmm7
 193c63d:	62 93 5d 48 25 eb fe 	vpternlogd $0xfe,%zmm27,%zmm4,%zmm5
 193c644:	62 91 fd 48 6f e7    	vmovdqa64 %zmm31,%zmm4
 193c64a:	62 01 fd 48 6f df    	vmovdqa64 %zmm31,%zmm27
 193c650:	62 f3 6d 58 25 25 bd a5 c7 fe f8 	vpternlogd $0xf8,-0x1385a43(%rip){1to16},%zmm2,%zmm4        # 5b6c18 <tier0_emit_x87.operations+0x1c8>
 193c65b:	62 63 75 58 25 1d ae a5 c7 fe f8 	vpternlogd $0xf8,-0x1385a52(%rip){1to16},%zmm1,%zmm27        # 5b6c14 <tier0_emit_x87.operations+0x1c4>
 193c666:	62 f1 6d 58 db 15 e0 a5 c7 fe 	vpandd -0x1385a20(%rip){1to16},%zmm2,%zmm2        # 5b6c50 <tier0_emit_x87.operations+0x200>
 193c670:	62 32 fd 48 7e de    	vpermt2q %zmm22,%zmm0,%zmm11
 193c676:	62 82 fd 48 7e c0    	vpermt2q %zmm24,%zmm0,%zmm16
 193c67c:	62 82 fd 48 7e d1    	vpermt2q %zmm25,%zmm0,%zmm18
 193c682:	62 82 fd 48 7e ea    	vpermt2q %zmm26,%zmm0,%zmm21
 193c688:	62 91 7d 48 72 d7 10 	vpsrld $0x10,%zmm31,%zmm0
 193c68f:	62 91 4d 40 72 d7 03 	vpsrld $0x3,%zmm31,%zmm22
 193c696:	62 e3 7d 58 25 35 97 a5 c7 fe ec 	vpternlogd $0xec,-0x1385a69(%rip){1to16},%zmm0,%zmm22        # 5b6c38 <tier0_emit_x87.operations+0x1e8>
 193c6a1:	62 f2 7d 48 5a 05 25 03 c7 fe 	vbroadcasti32x4 -0x138fcdb(%rip),%zmm0        # 5ac9d0 <x86_effects_unknown+0xa00>
 193c6ab:	62 93 3d 48 25 e3 b8 	vpternlogd $0xb8,%zmm27,%zmm8,%zmm4
 193c6b2:	62 61 75 58 db 1d 90 a5 c7 fe 	vpandd -0x1385a70(%rip){1to16},%zmm1,%zmm27        # 5b6c4c <tier0_emit_x87.operations+0x1fc>
 193c6bc:	62 d1 4d 48 fe cc    	vpaddd %zmm12,%zmm6,%zmm1
 193c6c2:	62 f1 75 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm1
 193c6c9:	62 93 3d 48 25 d3 b8 	vpternlogd $0xb8,%zmm27,%zmm8,%zmm2
 193c6d0:	62 51 8d 48 6c c7    	vpunpcklqdq %zmm15,%zmm14,%zmm8
 193c6d6:	62 11 9d 40 6d f5    	vpunpckhqdq %zmm29,%zmm28,%zmm14
 193c6dc:	62 f1 3d 48 6a f7    	vpunpckhdq %zmm7,%zmm8,%zmm6
 193c6e2:	62 51 0d 48 eb d2    	vpord  %zmm10,%zmm14,%zmm10
 193c6e8:	62 71 6d 48 eb fd    	vpord  %zmm5,%zmm2,%zmm15
 193c6ee:	62 b1 6d 48 72 f6 08 	vpslld $0x8,%zmm22,%zmm2
 193c6f5:	62 f3 75 58 25 15 54 a5 c7 fe 08 	vpternlogd $0x8,-0x1385aac(%rip){1to16},%zmm1,%zmm2        # 5b6c54 <tier0_emit_x87.operations+0x204>
 193c700:	62 d1 55 48 72 f2 07 	vpslld $0x7,%zmm10,%zmm5
 193c707:	62 f3 55 58 25 15 46 a5 c7 fe d8 	vpternlogd $0xd8,-0x1385aba(%rip){1to16},%zmm5,%zmm2        # 5b6c58 <tier0_emit_x87.operations+0x208>
 193c712:	62 d2 fd 48 83 ee    	vpmultishiftqb %zmm14,%zmm0,%zmm5
 193c718:	62 f3 4d 50 25 2d 39 a5 c7 fe d8 	vpternlogd $0xd8,-0x1385ac7(%rip){1to16},%zmm22,%zmm5        # 5b6c5c <tier0_emit_x87.operations+0x20c>
 193c723:	62 d1 7d 48 70 c7 55 	vpshufd $0x55,%zmm15,%zmm0
 193c72a:	62 b2 7d 48 8f d0    	vpshufbitqmb %zmm16,%zmm0,%k2
 193c730:	c4 61 fb 93 f2       	kmovq  %k2,%r14
 193c735:	f3 4d 0f b8 f6       	popcnt %r14,%r14
 193c73a:	62 f3 6d 58 25 2d 1b a5 c7 fe d8 	vpternlogd $0xd8,-0x1385ae5(%rip){1to16},%zmm2,%zmm5        # 5b6c60 <tier0_emit_x87.operations+0x210>
 193c745:	62 f1 3d 48 62 d7    	vpunpckldq %zmm7,%zmm8,%zmm2
 193c74b:	62 f1 5d 48 62 fd    	vpunpckldq %zmm5,%zmm4,%zmm7
 193c751:	62 f1 5d 48 6a e5    	vpunpckhdq %zmm5,%zmm4,%zmm4
 193c757:	62 f1 ed 48 6c ef    	vpunpcklqdq %zmm7,%zmm2,%zmm5
 193c75d:	62 f1 ed 48 6d d7    	vpunpckhqdq %zmm7,%zmm2,%zmm2
 193c763:	62 f1 cd 48 6c fc    	vpunpcklqdq %zmm4,%zmm6,%zmm7
 193c769:	62 f1 cd 48 6d e4    	vpunpckhqdq %zmm4,%zmm6,%zmm4
 193c76f:	62 d1 7d 48 70 f7 00 	vpshufd $0x0,%zmm15,%zmm6
 193c776:	62 d2 55 48 00 eb    	vpshufb %zmm11,%zmm5,%zmm5
 193c77c:	62 d2 4d 48 8f db    	vpshufbitqmb %zmm11,%zmm6,%k3
 193c782:	62 b2 6d 48 00 d0    	vpshufb %zmm16,%zmm2,%zmm2
 193c788:	62 b2 45 48 00 c2    	vpshufb %zmm18,%zmm7,%zmm0
 193c78e:	62 f3 95 48 25 eb 78 	vpternlogq $0x78,%zmm3,%zmm13,%zmm5
 193c795:	62 f3 f5 40 25 d3 78 	vpternlogq $0x78,%zmm3,%zmm17,%zmm2
 193c79c:	62 f3 e5 40 25 c3 78 	vpternlogq $0x78,%zmm3,%zmm19,%zmm0
 193c7a3:	62 f2 7d cb 63 ed    	vpcompressb %zmm5,%zmm5{%k3}{z}
 193c7a9:	62 f2 7d ca 63 d2    	vpcompressb %zmm2,%zmm2{%k2}{z}
 193c7af:	c4 e1 fb 93 fb       	kmovq  %k3,%rdi
 193c7b4:	f3 48 0f b8 ff       	popcnt %rdi,%rdi
 193c7b9:	62 d1 fe 48 7f 2b    	vmovdqu64 %zmm5,(%r11)
 193c7bf:	62 d1 7d 48 70 ef aa 	vpshufd $0xaa,%zmm15,%zmm5
 193c7c6:	62 d1 fe 48 7f 14 3b 	vmovdqu64 %zmm2,(%r11,%rdi,1)
 193c7cd:	4c 01 df             	add    %r11,%rdi
 193c7d0:	41 29 db             	sub    %ebx,%r11d
 193c7d3:	62 b2 55 48 8f da    	vpshufbitqmb %zmm18,%zmm5,%k3
 193c7d9:	62 d1 7d 48 70 ef ff 	vpshufd $0xff,%zmm15,%zmm5
 193c7e0:	62 73 5d 50 25 3d 79 a4 c7 fe 20 	vpternlogd $0x20,-0x1385b87(%rip){1to16},%zmm20,%zmm15        # 5b6c64 <tier0_emit_x87.operations+0x214>
 193c7eb:	62 b2 55 48 8f d5    	vpshufbitqmb %zmm21,%zmm5,%k2
 193c7f1:	c5 e9 ef d2          	vpxor  %xmm2,%xmm2,%xmm2
 193c7f5:	62 f2 7d cb 63 c2    	vpcompressb %zmm0,%zmm2{%k3}{z}
 193c7fb:	62 b2 5d 48 00 c5    	vpshufb %zmm21,%zmm4,%zmm0
 193c801:	62 f1 5d 50 db 25 5d a4 c7 fe 	vpandd -0x1385ba3(%rip){1to16},%zmm20,%zmm4        # 5b6c68 <tier0_emit_x87.operations+0x218>
 193c80b:	62 f3 c5 40 25 c3 78 	vpternlogq $0x78,%zmm3,%zmm23,%zmm0
 193c812:	62 d1 fe 48 7f 14 3e 	vmovdqu64 %zmm2,(%r14,%rdi,1)
 193c819:	c5 e9 ef d2          	vpxor  %xmm2,%xmm2,%xmm2
 193c81d:	62 f2 7d ca 63 c2    	vpcompressb %zmm0,%zmm2{%k2}{z}
 193c823:	62 d2 7d 48 55 c7    	vpopcntd %zmm15,%zmm0
 193c829:	49 01 fe             	add    %rdi,%r14
 193c82c:	c4 e1 fb 93 fb       	kmovq  %k3,%rdi
 193c831:	f3 4c 0f b8 ff       	popcnt %rdi,%r15
 193c836:	c4 e1 fb 93 fa       	kmovq  %k2,%rdi
 193c83b:	f3 48 0f b8 ff       	popcnt %rdi,%rdi
 193c840:	62 f1 75 48 fe cc    	vpaddd %zmm4,%zmm1,%zmm1
 193c846:	4c 01 ff             	add    %r15,%rdi
 193c849:	62 f1 75 48 fe c8    	vpaddd %zmm0,%zmm1,%zmm1
 193c84f:	c5 f9 6f 05 09 01 c7 fe 	vmovdqa -0x138fef7(%rip),%xmm0        # 5ac960 <x86_effects_unknown+0x990>
 193c857:	4c 01 f7             	add    %r14,%rdi
 193c85a:	62 91 fe 48 7f 14 37 	vmovdqu64 %zmm2,(%r15,%r14,1)
 193c861:	44 89 5c 24 40       	mov    %r11d,0x40(%rsp)
 193c866:	62 f2 7d 48 8d c9    	vpermb %zmm1,%zmm0,%zmm1
 193c86c:	c5 f9 6f 05 fc 00 c7 fe 	vmovdqa -0x138ff04(%rip),%xmm0        # 5ac970 <x86_effects_unknown+0x9a0>
 193c874:	62 f2 f5 18 40 0d ca a1 c7 fe 	vpmullq -0x1385e36(%rip){1to2},%xmm1,%xmm1        # 5b6a48 <x86_semantics_benchmark_code.registers+0x450>
 193c87e:	62 d2 7d 48 8d d6    	vpermb %zmm14,%zmm0,%zmm2
 193c884:	c4 e2 71 00 05 f3 00 c7 fe 	vpshufb -0x138ff0d(%rip),%xmm1,%xmm0        # 5ac980 <x86_effects_unknown+0x9b0>
 193c88d:	62 f2 7e 48 29 da    	vpmovb2m %zmm2,%k3
 193c893:	c5 7b 93 db          	kmovd  %k3,%r11d
 193c897:	45 0f b7 db          	movzwl %r11w,%r11d
 193c89b:	c5 f9 fc c9          	vpaddb %xmm1,%xmm0,%xmm1
 193c89f:	f3 45 0f b8 db       	popcnt %r11d,%r11d
 193c8a4:	49 ff c8             	dec    %r8
 193c8a7:	62 f2 7d 48 31 c9    	vpmovzxbd %xmm1,%zmm1
 193c8ad:	62 f1 75 58 fe 4c 24 10 	vpaddd 0x40(%rsp){1to16},%zmm1,%zmm1
 193c8b5:	62 f2 7d cb 8b c9    	vpcompressd %zmm1,%zmm1{%k3}{z}
 193c8bb:	62 f1 fe 48 7f 09    	vmovdqu64 %zmm1,(%rcx)
 193c8c1:	4a 8d 0c 99          	lea    (%rcx,%r11,4),%rcx
 193c8c5:	49 89 fb             	mov    %rdi,%r11
 193c8c8:	0f 85 12 fa ff ff    	jne    193c2e0 <x86_encode_16+0xa0>
 193c8ce:	4c 8d 40 10          	lea    0x10(%rax),%r8
 193c8d2:	49 39 d0             	cmp    %rdx,%r8
 193c8d5:	76 08                	jbe    193c8df <x86_encode_16+0x69f>
 193c8d7:	49 89 fe             	mov    %rdi,%r14
 193c8da:	e9 3f 06 00 00       	jmp    193cf1e <x86_encode_16+0xcde>
 193c8df:	62 f2 7d 48 5a 1d 67 00 c7 fe 	vbroadcasti32x4 -0x138ff99(%rip),%zmm3        # 5ac950 <x86_effects_unknown+0x980>
 193c8e9:	62 72 7d 48 58 0d 35 a3 c7 fe 	vpbroadcastd -0x1385ccb(%rip),%zmm9        # 5b6c28 <tier0_emit_x87.operations+0x1d8>
 193c8f3:	49 89 d0             	mov    %rdx,%r8
 193c8f6:	49 29 c0             	sub    %rax,%r8
 193c8f9:	49 89 c1             	mov    %rax,%r9
 193c8fc:	49 c1 e1 04          	shl    $0x4,%r9
 193c900:	41 b3 cc             	mov    $0xcc,%r11b
 193c903:	4c 8d 15 36 fb 31 0d 	lea    0xd31fb36(%rip),%r10        # ec5c440 <x86_template_storage>
 193c90a:	62 53 1d 48 25 e4 ff 	vpternlogd $0xff,%zmm12,%zmm12,%zmm12
 193c911:	49 83 c0 f0          	add    $0xfffffffffffffff0,%r8
 193c915:	4d 8d 8c 31 fc 00 00 00 	lea    0xfc(%r9,%rsi,1),%r9
 193c91d:	c4 c1 7b 92 cb       	kmovd  %r11d,%k1
 193c922:	49 c1 e8 04          	shr    $0x4,%r8
 193c926:	49 ff c0             	inc    %r8
 193c929:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
 193c930:	45 0f b7 99 10 ff ff ff 	movzwl -0xf0(%r9),%r11d
 193c938:	45 0f b7 b1 20 ff ff ff 	movzwl -0xe0(%r9),%r14d
 193c940:	45 0f b7 b9 30 ff ff ff 	movzwl -0xd0(%r9),%r15d
 193c948:	45 0f b7 a1 40 ff ff ff 	movzwl -0xc0(%r9),%r12d
 193c950:	62 c1 fe 48 6f a1 04 ff ff ff 	vmovdqu64 -0xfc(%r9),%zmm20
 193c95a:	62 41 fe 48 6f 99 44 ff ff ff 	vmovdqu64 -0xbc(%r9),%zmm27
 193c964:	62 41 fe 48 6f a9 84 ff ff ff 	vmovdqu64 -0x7c(%r9),%zmm29
 193c96e:	62 41 fe 48 6f b1 c4 ff ff ff 	vmovdqu64 -0x3c(%r9),%zmm30
 193c978:	62 f2 7d 48 5a 2d 0e 00 c7 fe 	vbroadcasti32x4 -0x138fff2(%rip),%zmm5        # 5ac990 <x86_effects_unknown+0x9c0>
 193c982:	62 f2 7d 48 5a 05 14 00 c7 fe 	vbroadcasti32x4 -0x138ffec(%rip),%zmm0        # 5ac9a0 <x86_effects_unknown+0x9d0>
 193c98c:	62 72 7d 48 58 05 7a a2 c7 fe 	vpbroadcastd -0x1385d86(%rip),%zmm8        # 5b6c10 <tier0_emit_x87.operations+0x1c0>
 193c996:	48 83 c0 10          	add    $0x10,%rax
 193c99a:	41 c1 e3 06          	shl    $0x6,%r11d
 193c99e:	41 c1 e6 06          	shl    $0x6,%r14d
 193c9a2:	41 c1 e7 06          	shl    $0x6,%r15d
 193c9a6:	41 c1 e4 06          	shl    $0x6,%r12d
 193c9aa:	c4 81 7d 6f 4c 13 40 	vmovdqa 0x40(%r11,%r10,1),%ymm1
 193c9b1:	45 0f b7 99 50 ff ff ff 	movzwl -0xb0(%r9),%r11d
 193c9b9:	62 13 f5 48 3a 5c 17 02 01 	vinserti64x4 $0x1,0x40(%r15,%r10,1),%zmm1,%zmm11
 193c9c2:	45 0f b7 b9 70 ff ff ff 	movzwl -0x90(%r9),%r15d
 193c9ca:	c4 81 7d 6f 4c 16 60 	vmovdqa 0x60(%r14,%r10,1),%ymm1
 193c9d1:	45 0f b7 b1 60 ff ff ff 	movzwl -0xa0(%r9),%r14d
 193c9d9:	62 83 f5 48 3a 74 14 03 01 	vinserti64x4 $0x1,0x60(%r12,%r10,1),%zmm1,%zmm22
 193c9e2:	45 0f b7 61 80       	movzwl -0x80(%r9),%r12d
 193c9e7:	62 11 15 40 62 fe    	vpunpckldq %zmm30,%zmm29,%zmm15
 193c9ed:	62 01 5d 40 6a e3    	vpunpckhdq %zmm27,%zmm20,%zmm28
 193c9f3:	62 01 15 40 6a ee    	vpunpckhdq %zmm30,%zmm29,%zmm29
 193c9f9:	62 11 5d 40 62 f3    	vpunpckldq %zmm27,%zmm20,%zmm14
 193c9ff:	62 11 9d 40 6c d5    	vpunpcklqdq %zmm29,%zmm28,%zmm10
 193ca05:	62 41 8d 48 6d f7    	vpunpckhqdq %zmm15,%zmm14,%zmm30
 193ca0b:	62 d2 fd 48 83 f2    	vpmultishiftqb %zmm10,%zmm0,%zmm6
 193ca11:	62 92 0d 40 27 c6    	vptestmd %zmm30,%zmm30,%k0
 193ca17:	62 91 7d 48 72 e6 1f 	vpsrad $0x1f,%zmm30,%zmm0
 193ca1e:	62 41 fd 48 6f da    	vmovdqa64 %zmm10,%zmm27
 193ca24:	41 c1 e3 06          	shl    $0x6,%r11d
 193ca28:	c4 81 7d 6f 4c 13 40 	vmovdqa 0x40(%r11,%r10,1),%ymm1
 193ca2f:	45 0f b7 59 90       	movzwl -0x70(%r9),%r11d
 193ca34:	41 c1 e7 06          	shl    $0x6,%r15d
 193ca38:	41 c1 e6 06          	shl    $0x6,%r14d
 193ca3c:	62 83 f5 48 3a 44 17 02 01 	vinserti64x4 $0x1,0x40(%r15,%r10,1),%zmm1,%zmm16
 193ca45:	45 0f b7 79 b0       	movzwl -0x50(%r9),%r15d
 193ca4a:	c4 81 7d 6f 4c 16 60 	vmovdqa 0x60(%r14,%r10,1),%ymm1
 193ca51:	45 0f b7 71 a0       	movzwl -0x60(%r9),%r14d
 193ca56:	41 c1 e4 06          	shl    $0x6,%r12d
 193ca5a:	62 03 f5 48 3a 44 14 03 01 	vinserti64x4 $0x1,0x60(%r12,%r10,1),%zmm1,%zmm24
 193ca63:	45 0f b7 61 c0       	movzwl -0x40(%r9),%r12d
 193ca68:	62 32 a5 49 64 ee    	vpblendmq %zmm22,%zmm11,%zmm13{%k1}
 193ca6e:	41 c1 e3 06          	shl    $0x6,%r11d
 193ca72:	c4 81 7d 6f 4c 13 40 	vmovdqa 0x40(%r11,%r10,1),%ymm1
 193ca79:	45 0f b7 59 d0       	movzwl -0x30(%r9),%r11d
 193ca7e:	41 c1 e7 06          	shl    $0x6,%r15d
 193ca82:	41 c1 e6 06          	shl    $0x6,%r14d
 193ca86:	62 83 f5 48 3a 54 17 02 01 	vinserti64x4 $0x1,0x40(%r15,%r10,1),%zmm1,%zmm18
 193ca8f:	45 0f b7 79 f0       	movzwl -0x10(%r9),%r15d
 193ca94:	c4 81 7d 6f 4c 16 60 	vmovdqa 0x60(%r14,%r10,1),%ymm1
 193ca9b:	45 0f b7 71 e0       	movzwl -0x20(%r9),%r14d
 193caa0:	41 c1 e4 06          	shl    $0x6,%r12d
 193caa4:	62 03 f5 48 3a 4c 14 03 01 	vinserti64x4 $0x1,0x60(%r12,%r10,1),%zmm1,%zmm25
 193caad:	45 0f b7 21          	movzwl (%r9),%r12d
 193cab1:	49 81 c1 00 01 00 00 	add    $0x100,%r9
 193cab8:	62 82 fd 41 64 c8    	vpblendmq %zmm24,%zmm16,%zmm17{%k1}
 193cabe:	41 c1 e3 06          	shl    $0x6,%r11d
 193cac2:	41 c1 e6 06          	shl    $0x6,%r14d
 193cac6:	41 c1 e7 06          	shl    $0x6,%r15d
 193caca:	c4 81 7d 6f 4c 13 40 	vmovdqa 0x40(%r11,%r10,1),%ymm1
 193cad1:	62 83 f5 48 3a 6c 17 02 01 	vinserti64x4 $0x1,0x40(%r15,%r10,1),%zmm1,%zmm21
 193cada:	41 c1 e4 06          	shl    $0x6,%r12d
 193cade:	c4 81 7d 6f 4c 16 60 	vmovdqa 0x60(%r14,%r10,1),%ymm1
 193cae5:	62 03 f5 48 3a 54 14 03 01 	vinserti64x4 $0x1,0x60(%r12,%r10,1),%zmm1,%zmm26
 193caee:	62 b1 15 48 6a c9    	vpunpckhdq %zmm17,%zmm13,%zmm1
 193caf4:	62 82 ed 41 64 d9    	vpblendmq %zmm25,%zmm18,%zmm19{%k1}
 193cafa:	62 82 d5 41 64 fa    	vpblendmq %zmm26,%zmm21,%zmm23{%k1}
 193cb00:	62 b1 65 40 6a d7    	vpunpckhdq %zmm23,%zmm19,%zmm2
 193cb06:	62 e1 f5 48 6d e2    	vpunpckhqdq %zmm2,%zmm1,%zmm20
 193cb0c:	62 d1 75 48 72 d2 1a 	vpsrld $0x1a,%zmm10,%zmm1
 193cb13:	62 f2 75 48 36 3d a3 b9 c0 fe 	vpermd -0x13f465d(%rip),%zmm1,%zmm7        # 5484c0 <branch_sizing_patterns+0x2830>
 193cb1d:	62 62 75 48 36 3d d9 b9 c0 fe 	vpermd -0x13f4627(%rip),%zmm1,%zmm31        # 548500 <branch_sizing_patterns+0x2870>
 193cb27:	62 f2 75 48 36 25 0f ba c0 fe 	vpermd -0x13f45f1(%rip),%zmm1,%zmm4        # 548540 <branch_sizing_patterns+0x28b0>
 193cb31:	62 d2 d5 48 83 ca    	vpmultishiftqb %zmm10,%zmm5,%zmm1
 193cb37:	62 f2 7d 48 5a 2d 6f fe c6 fe 	vbroadcasti32x4 -0x1390191(%rip),%zmm5        # 5ac9b0 <x86_effects_unknown+0x9e0>
 193cb41:	62 d2 d5 48 83 ea    	vpmultishiftqb %zmm10,%zmm5,%zmm5
 193cb47:	62 f3 75 58 25 2d b2 a0 c7 fe d8 	vpternlogd $0xd8,-0x1385f4e(%rip){1to16},%zmm1,%zmm5        # 5b6c04 <tier0_emit_x87.operations+0x1b4>
 193cb52:	62 d1 75 48 72 f2 04 	vpslld $0x4,%zmm10,%zmm1
 193cb59:	62 f1 6d 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm2
 193cb60:	62 f3 55 58 25 35 9d a0 c7 fe e4 	vpternlogd $0xe4,-0x1385f63(%rip){1to16},%zmm5,%zmm6        # 5b6c08 <tier0_emit_x87.operations+0x1b8>
 193cb6b:	62 f2 7d 48 5a 2d 4b fe c6 fe 	vbroadcasti32x4 -0x13901b5(%rip),%zmm5        # 5ac9c0 <x86_effects_unknown+0x9f0>
 193cb75:	62 d2 55 48 00 ea    	vpshufb %zmm10,%zmm5,%zmm5
 193cb7b:	62 63 4d 48 25 ff f8 	vpternlogd $0xf8,%zmm7,%zmm6,%zmm31
 193cb82:	62 f1 75 48 72 f5 10 	vpslld $0x10,%zmm5,%zmm1
 193cb89:	62 f1 6d 48 db ed    	vpandd %zmm5,%zmm2,%zmm5
 193cb8f:	62 f3 5d 58 25 2d aa a0 c7 fe ec 	vpternlogd $0xec,-0x1385f56(%rip){1to16},%zmm4,%zmm5        # 5b6c44 <tier0_emit_x87.operations+0x1f4>
 193cb9a:	62 f1 45 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm7
 193cba1:	62 f2 7e 48 38 c8    	vpmovm2d %k0,%zmm1
 193cba7:	62 f3 5d 50 25 2d 96 a0 c7 fe f8 	vpternlogd $0xf8,-0x1385f6a(%rip){1to16},%zmm20,%zmm5        # 5b6c48 <tier0_emit_x87.operations+0x1f8>
 193cbb2:	62 f3 6d 48 25 cf c8 	vpternlogd $0xc8,%zmm7,%zmm2,%zmm1
 193cbb9:	62 91 7d 48 ef fe    	vpxord %zmm30,%zmm0,%zmm7
 193cbbf:	62 f2 7d 48 58 05 43 a0 c7 fe 	vpbroadcastd -0x1385fbd(%rip),%zmm0        # 5b6c0c <tier0_emit_x87.operations+0x1bc>
 193cbc9:	62 f2 7d 48 44 ff    	vplzcntd %zmm7,%zmm7
 193cbcf:	62 f2 3d 48 45 ff    	vpsrlvd %zmm7,%zmm8,%zmm7
 193cbd5:	62 51 0d 40 fe c4    	vpaddd %zmm12,%zmm30,%zmm8
 193cbdb:	62 73 0d 40 25 c7 14 	vpternlogd $0x14,%zmm7,%zmm30,%zmm8
 193cbe2:	62 d1 45 48 72 d2 08 	vpsrld $0x8,%zmm10,%zmm7
 193cbe9:	62 63 7d 58 25 1d 28 a0 c7 fe 6c 	vpternlogd $0x6c,-0x1385fd8(%rip){1to16},%zmm0,%zmm27        # 5b6c1c <tier0_emit_x87.operations+0x1cc>
 193cbf4:	62 f3 7d 58 25 3d 21 a0 c7 fe 6c 	vpternlogd $0x6c,-0x1385fdf(%rip){1to16},%zmm0,%zmm7        # 5b6c20 <tier0_emit_x87.operations+0x1d0>
 193cbff:	62 91 7d 48 72 ce 01 	vprold $0x1,%zmm30,%zmm0
 193cc06:	62 41 25 40 fe dc    	vpaddd %zmm12,%zmm27,%zmm27
 193cc0c:	62 63 35 58 25 1d 0d a0 c7 fe ec 	vpternlogd $0xec,-0x1385ff3(%rip){1to16},%zmm9,%zmm27        # 5b6c24 <tier0_emit_x87.operations+0x1d4>
 193cc17:	62 d1 45 48 fe fc    	vpaddd %zmm12,%zmm7,%zmm7
 193cc1d:	62 f3 25 50 25 3d 04 a0 c7 fe ec 	vpternlogd $0xec,-0x1385ffc(%rip){1to16},%zmm27,%zmm7        # 5b6c2c <tier0_emit_x87.operations+0x1dc>
 193cc28:	62 61 4d 58 db 1d fe 9f c7 fe 	vpandd -0x1386002(%rip){1to16},%zmm6,%zmm27        # 5b6c30 <tier0_emit_x87.operations+0x1e0>
 193cc32:	62 f1 4d 48 72 d6 03 	vpsrld $0x3,%zmm6,%zmm6
 193cc39:	62 f3 5d 50 25 35 f8 9f c7 fe a2 	vpternlogd $0xa2,-0x1386008(%rip){1to16},%zmm20,%zmm6        # 5b6c3c <tier0_emit_x87.operations+0x1ec>
 193cc44:	62 f2 4d 58 3b 25 f2 9f c7 fe 	vpminud -0x138600e(%rip){1to16},%zmm6,%zmm4        # 5b6c40 <tier0_emit_x87.operations+0x1f0>
 193cc4e:	62 63 5d 40 25 df f8 	vpternlogd $0xf8,%zmm7,%zmm20,%zmm27
 193cc55:	62 62 25 50 3b 1d d5 9f c7 fe 	vpminud -0x138602b(%rip){1to16},%zmm27,%zmm27        # 5b6c34 <tier0_emit_x87.operations+0x1e4>
 193cc5f:	62 b1 45 48 72 d4 1d 	vpsrld $0x1d,%zmm20,%zmm7
 193cc66:	62 72 3d 48 14 c7    	vprorvd %zmm7,%zmm8,%zmm8
 193cc6c:	62 f2 7d 48 14 ff    	vprorvd %zmm7,%zmm0,%zmm7
 193cc72:	62 f1 fd 48 6f 05 04 b8 c0 fe 	vmovdqa64 -0x13f47fc(%rip),%zmm0        # 548480 <branch_sizing_patterns+0x27f0>
 193cc7c:	62 d1 3d 48 72 e0 1f 	vpsrad $0x1f,%zmm8,%zmm8
 193cc83:	62 93 75 48 25 fe e2 	vpternlogd $0xe2,%zmm30,%zmm1,%zmm7
 193cc8a:	62 93 3d 48 25 fe e2 	vpternlogd $0xe2,%zmm30,%zmm8,%zmm7
 193cc91:	62 93 5d 48 25 eb fe 	vpternlogd $0xfe,%zmm27,%zmm4,%zmm5
 193cc98:	62 91 fd 48 6f e7    	vmovdqa64 %zmm31,%zmm4
 193cc9e:	62 01 fd 48 6f df    	vmovdqa64 %zmm31,%zmm27
 193cca4:	62 f3 6d 58 25 25 69 9f c7 fe f8 	vpternlogd $0xf8,-0x1386097(%rip){1to16},%zmm2,%zmm4        # 5b6c18 <tier0_emit_x87.operations+0x1c8>
 193ccaf:	62 63 75 58 25 1d 5a 9f c7 fe f8 	vpternlogd $0xf8,-0x13860a6(%rip){1to16},%zmm1,%zmm27        # 5b6c14 <tier0_emit_x87.operations+0x1c4>
 193ccba:	62 f1 6d 58 db 15 8c 9f c7 fe 	vpandd -0x1386074(%rip){1to16},%zmm2,%zmm2        # 5b6c50 <tier0_emit_x87.operations+0x200>
 193ccc4:	62 32 fd 48 7e de    	vpermt2q %zmm22,%zmm0,%zmm11
 193ccca:	62 82 fd 48 7e c0    	vpermt2q %zmm24,%zmm0,%zmm16
 193ccd0:	62 82 fd 48 7e d1    	vpermt2q %zmm25,%zmm0,%zmm18
 193ccd6:	62 82 fd 48 7e ea    	vpermt2q %zmm26,%zmm0,%zmm21
 193ccdc:	62 91 7d 48 72 d7 10 	vpsrld $0x10,%zmm31,%zmm0
 193cce3:	62 91 4d 40 72 d7 03 	vpsrld $0x3,%zmm31,%zmm22
 193ccea:	62 e3 7d 58 25 35 43 9f c7 fe ec 	vpternlogd $0xec,-0x13860bd(%rip){1to16},%zmm0,%zmm22        # 5b6c38 <tier0_emit_x87.operations+0x1e8>
 193ccf5:	62 f2 7d 48 5a 05 d1 fc c6 fe 	vbroadcasti32x4 -0x139032f(%rip),%zmm0        # 5ac9d0 <x86_effects_unknown+0xa00>
 193ccff:	62 93 3d 48 25 e3 b8 	vpternlogd $0xb8,%zmm27,%zmm8,%zmm4
 193cd06:	62 61 75 58 db 1d 3c 9f c7 fe 	vpandd -0x13860c4(%rip){1to16},%zmm1,%zmm27        # 5b6c4c <tier0_emit_x87.operations+0x1fc>
 193cd10:	62 d1 4d 48 fe cc    	vpaddd %zmm12,%zmm6,%zmm1
 193cd16:	62 f1 75 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm1
 193cd1d:	62 93 3d 48 25 d3 b8 	vpternlogd $0xb8,%zmm27,%zmm8,%zmm2
 193cd24:	62 51 8d 48 6c c7    	vpunpcklqdq %zmm15,%zmm14,%zmm8
 193cd2a:	62 11 9d 40 6d f5    	vpunpckhqdq %zmm29,%zmm28,%zmm14
 193cd30:	62 f1 3d 48 6a f7    	vpunpckhdq %zmm7,%zmm8,%zmm6
 193cd36:	62 51 0d 48 eb d2    	vpord  %zmm10,%zmm14,%zmm10
 193cd3c:	62 71 6d 48 eb fd    	vpord  %zmm5,%zmm2,%zmm15
 193cd42:	62 b1 6d 48 72 f6 08 	vpslld $0x8,%zmm22,%zmm2
 193cd49:	62 f3 75 58 25 15 00 9f c7 fe 08 	vpternlogd $0x8,-0x1386100(%rip){1to16},%zmm1,%zmm2        # 5b6c54 <tier0_emit_x87.operations+0x204>
 193cd54:	62 d1 55 48 72 f2 07 	vpslld $0x7,%zmm10,%zmm5
 193cd5b:	62 f3 55 58 25 15 f2 9e c7 fe d8 	vpternlogd $0xd8,-0x138610e(%rip){1to16},%zmm5,%zmm2        # 5b6c58 <tier0_emit_x87.operations+0x208>
 193cd66:	62 d2 fd 48 83 ee    	vpmultishiftqb %zmm14,%zmm0,%zmm5
 193cd6c:	62 f3 4d 50 25 2d e5 9e c7 fe d8 	vpternlogd $0xd8,-0x138611b(%rip){1to16},%zmm22,%zmm5        # 5b6c5c <tier0_emit_x87.operations+0x20c>
 193cd77:	62 d1 7d 48 70 c7 55 	vpshufd $0x55,%zmm15,%zmm0
 193cd7e:	62 b2 7d 48 8f d0    	vpshufbitqmb %zmm16,%zmm0,%k2
 193cd84:	c4 61 fb 93 f2       	kmovq  %k2,%r14
 193cd89:	f3 4d 0f b8 f6       	popcnt %r14,%r14
 193cd8e:	62 f3 6d 58 25 2d c7 9e c7 fe d8 	vpternlogd $0xd8,-0x1386139(%rip){1to16},%zmm2,%zmm5        # 5b6c60 <tier0_emit_x87.operations+0x210>
 193cd99:	62 f1 3d 48 62 d7    	vpunpckldq %zmm7,%zmm8,%zmm2
 193cd9f:	62 f1 5d 48 62 fd    	vpunpckldq %zmm5,%zmm4,%zmm7
 193cda5:	62 f1 5d 48 6a e5    	vpunpckhdq %zmm5,%zmm4,%zmm4
 193cdab:	62 f1 ed 48 6c ef    	vpunpcklqdq %zmm7,%zmm2,%zmm5
 193cdb1:	62 f1 ed 48 6d d7    	vpunpckhqdq %zmm7,%zmm2,%zmm2
 193cdb7:	62 f1 cd 48 6c fc    	vpunpcklqdq %zmm4,%zmm6,%zmm7
 193cdbd:	62 f1 cd 48 6d e4    	vpunpckhqdq %zmm4,%zmm6,%zmm4
 193cdc3:	62 d1 7d 48 70 f7 00 	vpshufd $0x0,%zmm15,%zmm6
 193cdca:	62 d2 55 48 00 eb    	vpshufb %zmm11,%zmm5,%zmm5
 193cdd0:	62 d2 4d 48 8f db    	vpshufbitqmb %zmm11,%zmm6,%k3
 193cdd6:	62 b2 6d 48 00 d0    	vpshufb %zmm16,%zmm2,%zmm2
 193cddc:	62 b2 45 48 00 c2    	vpshufb %zmm18,%zmm7,%zmm0
 193cde2:	62 f3 95 48 25 eb 78 	vpternlogq $0x78,%zmm3,%zmm13,%zmm5
 193cde9:	62 f3 f5 40 25 d3 78 	vpternlogq $0x78,%zmm3,%zmm17,%zmm2
 193cdf0:	62 f3 e5 40 25 c3 78 	vpternlogq $0x78,%zmm3,%zmm19,%zmm0
 193cdf7:	62 f2 7d cb 63 ed    	vpcompressb %zmm5,%zmm5{%k3}{z}
 193cdfd:	62 f2 7d ca 63 d2    	vpcompressb %zmm2,%zmm2{%k2}{z}
 193ce03:	c4 61 fb 93 db       	kmovq  %k3,%r11
 193ce08:	f3 4d 0f b8 db       	popcnt %r11,%r11
 193ce0d:	62 f1 fe 48 7f 2f    	vmovdqu64 %zmm5,(%rdi)
 193ce13:	62 d1 7d 48 70 ef aa 	vpshufd $0xaa,%zmm15,%zmm5
 193ce1a:	62 b1 fe 48 7f 14 1f 	vmovdqu64 %zmm2,(%rdi,%r11,1)
 193ce21:	49 01 fb             	add    %rdi,%r11
 193ce24:	29 df                	sub    %ebx,%edi
 193ce26:	62 b2 55 48 8f da    	vpshufbitqmb %zmm18,%zmm5,%k3
 193ce2c:	62 d1 7d 48 70 ef ff 	vpshufd $0xff,%zmm15,%zmm5
 193ce33:	62 73 5d 50 25 3d 26 9e c7 fe 20 	vpternlogd $0x20,-0x13861da(%rip){1to16},%zmm20,%zmm15        # 5b6c64 <tier0_emit_x87.operations+0x214>
 193ce3e:	62 b2 55 48 8f d5    	vpshufbitqmb %zmm21,%zmm5,%k2
 193ce44:	c5 e9 ef d2          	vpxor  %xmm2,%xmm2,%xmm2
 193ce48:	62 f2 7d cb 63 c2    	vpcompressb %zmm0,%zmm2{%k3}{z}
 193ce4e:	62 b2 5d 48 00 c5    	vpshufb %zmm21,%zmm4,%zmm0
 193ce54:	62 f1 5d 50 db 25 0a 9e c7 fe 	vpandd -0x13861f6(%rip){1to16},%zmm20,%zmm4        # 5b6c68 <tier0_emit_x87.operations+0x218>
 193ce5e:	62 f3 c5 40 25 c3 78 	vpternlogq $0x78,%zmm3,%zmm23,%zmm0
 193ce65:	62 91 fe 48 7f 14 1e 	vmovdqu64 %zmm2,(%r14,%r11,1)
 193ce6c:	c5 e9 ef d2          	vpxor  %xmm2,%xmm2,%xmm2
 193ce70:	62 f2 7d ca 63 c2    	vpcompressb %zmm0,%zmm2{%k2}{z}
 193ce76:	62 d2 7d 48 55 c7    	vpopcntd %zmm15,%zmm0
 193ce7c:	4d 01 f3             	add    %r14,%r11
 193ce7f:	c4 61 fb 93 f3       	kmovq  %k3,%r14
 193ce84:	f3 4d 0f b8 fe       	popcnt %r14,%r15
 193ce89:	62 f1 75 48 fe cc    	vpaddd %zmm4,%zmm1,%zmm1
 193ce8f:	62 f1 75 48 fe c8    	vpaddd %zmm0,%zmm1,%zmm1
 193ce95:	c5 f9 6f 05 c3 fa c6 fe 	vmovdqa -0x139053d(%rip),%xmm0        # 5ac960 <x86_effects_unknown+0x990>
 193ce9d:	62 91 fe 48 7f 14 1f 	vmovdqu64 %zmm2,(%r15,%r11,1)
 193cea4:	89 7c 24 40          	mov    %edi,0x40(%rsp)
 193cea8:	c4 e1 fb 93 fa       	kmovq  %k2,%rdi
 193cead:	f3 4c 0f b8 f7       	popcnt %rdi,%r14
 193ceb2:	4d 01 fe             	add    %r15,%r14
 193ceb5:	4d 01 de             	add    %r11,%r14
 193ceb8:	62 f2 7d 48 8d c9    	vpermb %zmm1,%zmm0,%zmm1
 193cebe:	c5 f9 6f 05 aa fa c6 fe 	vmovdqa -0x1390556(%rip),%xmm0        # 5ac970 <x86_effects_unknown+0x9a0>
 193cec6:	62 f2 f5 18 40 0d 78 9b c7 fe 	vpmullq -0x1386488(%rip){1to2},%xmm1,%xmm1        # 5b6a48 <x86_semantics_benchmark_code.registers+0x450>
 193ced0:	62 d2 7d 48 8d d6    	vpermb %zmm14,%zmm0,%zmm2
 193ced6:	c4 e2 71 00 05 a1 fa c6 fe 	vpshufb -0x139055f(%rip),%xmm1,%xmm0        # 5ac980 <x86_effects_unknown+0x9b0>
 193cedf:	62 f2 7e 48 29 da    	vpmovb2m %zmm2,%k3
 193cee5:	c5 fb 93 fb          	kmovd  %k3,%edi
 193cee9:	0f b7 ff             	movzwl %di,%edi
 193ceec:	c5 f9 fc c9          	vpaddb %xmm1,%xmm0,%xmm1
 193cef0:	f3 0f b8 ff          	popcnt %edi,%edi
 193cef4:	49 ff c8             	dec    %r8
 193cef7:	62 f2 7d 48 31 c9    	vpmovzxbd %xmm1,%zmm1
 193cefd:	62 f1 75 58 fe 4c 24 10 	vpaddd 0x40(%rsp){1to16},%zmm1,%zmm1
 193cf05:	62 f2 7d cb 8b c9    	vpcompressd %zmm1,%zmm1{%k3}{z}
 193cf0b:	62 f1 fe 48 7f 09    	vmovdqu64 %zmm1,(%rcx)
 193cf11:	48 8d 0c b9          	lea    (%rcx,%rdi,4),%rcx
 193cf15:	4c 89 f7             	mov    %r14,%rdi
 193cf18:	0f 85 12 fa ff ff    	jne    193c930 <x86_encode_16+0x6f0>
 193cf1e:	48 29 c2             	sub    %rax,%rdx
 193cf21:	0f 86 b1 17 00 00    	jbe    193e6d8 <x86_encode_16+0x2498>
 193cf27:	48 c1 e0 04          	shl    $0x4,%rax
 193cf2b:	48 c1 e2 04          	shl    $0x4,%rdx
 193cf2f:	48 8d 7c 24 40       	lea    0x40(%rsp),%rdi
 193cf34:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 193cf38:	62 f1 fd 48 7f 44 24 04 	vmovdqa64 %zmm0,0x100(%rsp)
 193cf40:	62 f1 fd 48 7f 44 24 03 	vmovdqa64 %zmm0,0xc0(%rsp)
 193cf48:	62 f1 fd 48 7f 44 24 02 	vmovdqa64 %zmm0,0x80(%rsp)
 193cf50:	62 f1 fd 48 7f 44 24 01 	vmovdqa64 %zmm0,0x40(%rsp)
 193cf58:	49 89 cf             	mov    %rcx,%r15
 193cf5b:	48 01 c6             	add    %rax,%rsi
 193cf5e:	c5 f8 77             	vzeroupper
 193cf61:	e8 3a d0 e5 fe       	call   799fa0 <memcpy@plt>
 193cf66:	c5 f9 6f 4c 24 40    	vmovdqa 0x40(%rsp),%xmm1
 193cf6c:	c5 f9 6f 54 24 50    	vmovdqa 0x50(%rsp),%xmm2
 193cf72:	c5 f9 6f 5c 24 60    	vmovdqa 0x60(%rsp),%xmm3
 193cf78:	c5 f9 6f 64 24 70    	vmovdqa 0x70(%rsp),%xmm4
 193cf7e:	48 8d 05 bb f4 31 0d 	lea    0xd31f4bb(%rip),%rax        # ec5c440 <x86_template_storage>
 193cf85:	c5 f9 6f b4 24 80 00 00 00 	vmovdqa 0x80(%rsp),%xmm6
 193cf8e:	62 71 fd 48 6f 3d e8 b4 c0 fe 	vmovdqa64 -0x13f4b18(%rip),%zmm15        # 548480 <branch_sizing_patterns+0x27f0>
 193cf98:	c5 f9 6f bc 24 c0 00 00 00 	vmovdqa 0xc0(%rsp),%xmm7
 193cfa1:	c5 79 6f 84 24 e0 00 00 00 	vmovdqa 0xe0(%rsp),%xmm8
 193cfaa:	62 f1 fd 48 6f 6c 24 01 	vmovdqa64 0x40(%rsp),%zmm5
 193cfb2:	62 71 fd 48 6f 54 24 02 	vmovdqa64 0x80(%rsp),%zmm10
 193cfba:	62 71 fd 48 6f 5c 24 03 	vmovdqa64 0xc0(%rsp),%zmm11
 193cfc2:	62 71 fd 48 6f 64 24 04 	vmovdqa64 0x100(%rsp),%zmm12
 193cfca:	62 e2 7d 48 5a 0d cc f9 c6 fe 	vbroadcasti32x4 -0x1390634(%rip),%zmm17        # 5ac9a0 <x86_effects_unknown+0x9d0>
 193cfd4:	62 a3 4d 40 25 f6 ff 	vpternlogd $0xff,%zmm22,%zmm22,%zmm22
 193cfdb:	62 e2 7d 48 58 25 27 9c c7 fe 	vpbroadcastd -0x13863d9(%rip),%zmm20        # 5b6c0c <tier0_emit_x87.operations+0x1bc>
 193cfe5:	62 62 7d 48 58 1d 29 9c c7 fe 	vpbroadcastd -0x13863d7(%rip),%zmm27        # 5b6c18 <tier0_emit_x87.operations+0x1c8>
 193cfef:	62 62 7d 48 58 0d 23 9c c7 fe 	vpbroadcastd -0x13863dd(%rip),%zmm25        # 5b6c1c <tier0_emit_x87.operations+0x1cc>
 193cff9:	c5 f9 c5 c9 06       	vpextrw $0x6,%xmm1,%ecx
 193cffe:	c5 f9 c5 d2 06       	vpextrw $0x6,%xmm2,%edx
 193d003:	c5 f9 c5 fc 06       	vpextrw $0x6,%xmm4,%edi
 193d008:	c5 f9 c5 f3 06       	vpextrw $0x6,%xmm3,%esi
 193d00d:	c5 f9 6f a4 24 90 00 00 00 	vmovdqa 0x90(%rsp),%xmm4
 193d016:	62 51 55 48 62 ea    	vpunpckldq %zmm10,%zmm5,%zmm13
 193d01c:	62 51 25 48 62 f4    	vpunpckldq %zmm12,%zmm11,%zmm14
 193d022:	62 d1 55 48 6a ea    	vpunpckhdq %zmm10,%zmm5,%zmm5
 193d028:	62 51 25 48 6a d4    	vpunpckhdq %zmm12,%zmm11,%zmm10
 193d02e:	c1 e1 06             	shl    $0x6,%ecx
 193d031:	c1 e2 06             	shl    $0x6,%edx
 193d034:	c1 e6 06             	shl    $0x6,%esi
 193d037:	c1 e7 06             	shl    $0x6,%edi
 193d03a:	62 51 95 48 6d de    	vpunpckhqdq %zmm14,%zmm13,%zmm11
 193d040:	62 d1 95 48 6c c6    	vpunpcklqdq %zmm14,%zmm13,%zmm0
 193d046:	62 51 d5 48 6c ea    	vpunpcklqdq %zmm10,%zmm5,%zmm13
 193d04c:	62 d1 d5 48 6d ea    	vpunpckhqdq %zmm10,%zmm5,%zmm5
 193d052:	c5 fd 6f 4c 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm1
 193d058:	c5 fd 6f 54 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm2
 193d05e:	b1 cc                	mov    $0xcc,%cl
 193d060:	62 d1 0d 48 72 d5 1a 	vpsrld $0x1a,%zmm13,%zmm14
 193d067:	62 e2 0d 48 36 1d 8f b4 c0 fe 	vpermd -0x13f4b71(%rip),%zmm14,%zmm19        # 548500 <branch_sizing_patterns+0x2870>
 193d071:	62 d2 25 48 27 c3    	vptestmd %zmm11,%zmm11,%k0
 193d077:	62 d1 6d 40 72 e3 1f 	vpsrad $0x1f,%zmm11,%zmm18
 193d07e:	62 21 25 48 fe c6    	vpaddd %zmm22,%zmm11,%zmm24
 193d084:	62 43 5d 40 25 cd 6c 	vpternlogd $0x6c,%zmm13,%zmm20,%zmm25
 193d08b:	62 f3 f5 48 3a 4c 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm1,%zmm1
 193d094:	62 f3 ed 48 3a 5c 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm2,%zmm3
 193d09d:	c5 fb 92 c9          	kmovd  %ecx,%k1
 193d0a1:	c5 f9 c5 ce 06       	vpextrw $0x6,%xmm6,%ecx
 193d0a6:	c5 f9 6f b4 24 a0 00 00 00 	vmovdqa 0xa0(%rsp),%xmm6
 193d0af:	c1 e1 06             	shl    $0x6,%ecx
 193d0b2:	c5 f9 c5 d4 06       	vpextrw $0x6,%xmm4,%edx
 193d0b7:	c5 f9 6f a4 24 b0 00 00 00 	vmovdqa 0xb0(%rsp),%xmm4
 193d0c0:	c1 e2 06             	shl    $0x6,%edx
 193d0c3:	62 f2 f5 49 64 d3    	vpblendmq %zmm3,%zmm1,%zmm2{%k1}
 193d0c9:	62 f2 85 48 7e cb    	vpermt2q %zmm3,%zmm15,%zmm1
 193d0cf:	c5 fd 6f 5c 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm3
 193d0d5:	c5 f9 c5 cf 06       	vpextrw $0x6,%xmm7,%ecx
 193d0da:	c5 f9 6f bc 24 d0 00 00 00 	vmovdqa 0xd0(%rsp),%xmm7
 193d0e3:	c5 f9 c5 f6 06       	vpextrw $0x6,%xmm6,%esi
 193d0e8:	c1 e6 06             	shl    $0x6,%esi
 193d0eb:	c1 e1 06             	shl    $0x6,%ecx
 193d0ee:	62 f3 e5 48 3a 5c 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm3,%zmm3
 193d0f7:	c4 c1 79 c5 f0 06    	vpextrw $0x6,%xmm8,%esi
 193d0fd:	c1 e6 06             	shl    $0x6,%esi
 193d100:	c5 f9 c5 fc 06       	vpextrw $0x6,%xmm4,%edi
 193d105:	c5 fd 6f 64 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm4
 193d10b:	c1 e7 06             	shl    $0x6,%edi
 193d10e:	62 f3 dd 48 3a 74 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm4,%zmm6
 193d117:	c5 f9 c5 d7 06       	vpextrw $0x6,%xmm7,%edx
 193d11c:	c5 f9 6f bc 24 f0 00 00 00 	vmovdqa 0xf0(%rsp),%xmm7
 193d125:	c1 e2 06             	shl    $0x6,%edx
 193d128:	62 f2 e5 49 64 e6    	vpblendmq %zmm6,%zmm3,%zmm4{%k1}
 193d12e:	62 f2 85 48 7e de    	vpermt2q %zmm6,%zmm15,%zmm3
 193d134:	c5 fd 6f 74 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm6
 193d13a:	0f b7 8c 24 0c 01 00 00 	movzwl 0x10c(%rsp),%ecx
 193d142:	c5 f9 c5 ff 06       	vpextrw $0x6,%xmm7,%edi
 193d147:	c5 fd 6f 7c 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm7
 193d14d:	62 f3 cd 48 3a 74 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm6,%zmm6
 193d156:	0f b7 94 24 1c 01 00 00 	movzwl 0x11c(%rsp),%edx
 193d15e:	0f b7 b4 24 2c 01 00 00 	movzwl 0x12c(%rsp),%esi
 193d166:	62 71 6d 48 6a d4    	vpunpckhdq %zmm4,%zmm2,%zmm10
 193d16c:	c1 e7 06             	shl    $0x6,%edi
 193d16f:	62 73 c5 48 3a 44 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm7,%zmm8
 193d178:	0f b7 bc 24 3c 01 00 00 	movzwl 0x13c(%rsp),%edi
 193d180:	c1 e1 06             	shl    $0x6,%ecx
 193d183:	c1 e2 06             	shl    $0x6,%edx
 193d186:	c1 e6 06             	shl    $0x6,%esi
 193d189:	c5 7d 6f 4c 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm9
 193d18f:	c1 e7 06             	shl    $0x6,%edi
 193d192:	62 e3 b5 48 3a 44 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm9,%zmm16
 193d19b:	62 d2 cd 49 64 f8    	vpblendmq %zmm8,%zmm6,%zmm7{%k1}
 193d1a1:	62 d2 85 48 7e f0    	vpermt2q %zmm8,%zmm15,%zmm6
 193d1a7:	c5 7d 6f 44 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm8
 193d1ad:	62 73 bd 48 3a 44 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm8,%zmm8
 193d1b6:	62 32 bd 49 64 c8    	vpblendmq %zmm16,%zmm8,%zmm9{%k1}
 193d1bc:	62 32 85 48 7e c0    	vpermt2q %zmm16,%zmm15,%zmm8
 193d1c2:	62 e2 7d 48 5a 05 c4 f7 c6 fe 	vbroadcasti32x4 -0x139083c(%rip),%zmm16        # 5ac990 <x86_effects_unknown+0x9c0>
 193d1cc:	62 72 0d 48 36 3d ea b2 c0 fe 	vpermd -0x13f4d16(%rip),%zmm14,%zmm15        # 5484c0 <branch_sizing_patterns+0x2830>
 193d1d6:	62 72 0d 48 36 35 60 b3 c0 fe 	vpermd -0x13f4ca0(%rip),%zmm14,%zmm14        # 548540 <branch_sizing_patterns+0x28b0>
 193d1e0:	62 51 45 48 6a e1    	vpunpckhdq %zmm9,%zmm7,%zmm12
 193d1e6:	62 51 ad 48 6d d4    	vpunpckhqdq %zmm12,%zmm10,%zmm10
 193d1ec:	62 d1 45 40 72 d2 1d 	vpsrld $0x1d,%zmm10,%zmm23
 193d1f3:	62 52 fd 40 83 e5    	vpmultishiftqb %zmm13,%zmm16,%zmm12
 193d1f9:	62 e2 7d 48 5a 05 ad f7 c6 fe 	vbroadcasti32x4 -0x1390853(%rip),%zmm16        # 5ac9b0 <x86_effects_unknown+0x9e0>
 193d203:	62 c2 fd 40 83 c5    	vpmultishiftqb %zmm13,%zmm16,%zmm16
 193d209:	62 e3 1d 58 25 05 f0 99 c7 fe d8 	vpternlogd $0xd8,-0x1386610(%rip){1to16},%zmm12,%zmm16        # 5b6c04 <tier0_emit_x87.operations+0x1b4>
 193d214:	62 52 f5 40 83 e5    	vpmultishiftqb %zmm13,%zmm17,%zmm12
 193d21a:	62 e2 7d 48 5a 0d 9c f7 c6 fe 	vbroadcasti32x4 -0x1390864(%rip),%zmm17        # 5ac9c0 <x86_effects_unknown+0x9f0>
 193d224:	62 73 7d 50 25 25 d9 99 c7 fe e4 	vpternlogd $0xe4,-0x1386627(%rip){1to16},%zmm16,%zmm12        # 5b6c08 <tier0_emit_x87.operations+0x1b8>
 193d22f:	62 c2 75 40 00 ed    	vpshufb %zmm13,%zmm17,%zmm21
 193d235:	62 d1 7d 40 72 f5 04 	vpslld $0x4,%zmm13,%zmm16
 193d23c:	62 b1 7d 40 72 e0 1f 	vpsrad $0x1f,%zmm16,%zmm16
 193d243:	62 c3 1d 48 25 df f8 	vpternlogd $0xf8,%zmm15,%zmm12,%zmm19
 193d24a:	62 b1 05 48 72 f5 10 	vpslld $0x10,%zmm21,%zmm15
 193d251:	62 d1 75 40 72 e7 1f 	vpsrad $0x1f,%zmm15,%zmm17
 193d258:	62 72 7e 48 38 f8    	vpmovm2d %k0,%zmm15
 193d25e:	62 23 7d 40 25 db ea 	vpternlogd $0xea,%zmm19,%zmm16,%zmm27
 193d265:	62 b1 2d 40 72 d3 10 	vpsrld $0x10,%zmm19,%zmm26
 193d26c:	62 33 7d 40 25 f9 c8 	vpternlogd $0xc8,%zmm17,%zmm16,%zmm15
 193d273:	62 c1 6d 40 ef cb    	vpxord %zmm11,%zmm18,%zmm17
 193d279:	62 e2 7d 48 58 15 8d 99 c7 fe 	vpbroadcastd -0x1386673(%rip),%zmm18        # 5b6c10 <tier0_emit_x87.operations+0x1c0>
 193d283:	62 a2 7d 48 44 c9    	vplzcntd %zmm17,%zmm17
 193d289:	62 a2 6d 40 45 c9    	vpsrlvd %zmm17,%zmm18,%zmm17
 193d28f:	62 23 25 48 25 c1 14 	vpternlogd $0x14,%zmm17,%zmm11,%zmm24
 193d296:	62 a2 3d 40 14 cf    	vprorvd %zmm23,%zmm24,%zmm17
 193d29c:	62 62 7d 48 58 05 6e 99 c7 fe 	vpbroadcastd -0x1386692(%rip),%zmm24        # 5b6c14 <tier0_emit_x87.operations+0x1c4>
 193d2a6:	62 b1 75 40 72 e1 1f 	vpsrad $0x1f,%zmm17,%zmm17
 193d2ad:	62 23 05 48 25 c3 ea 	vpternlogd $0xea,%zmm19,%zmm15,%zmm24
 193d2b4:	62 b1 65 40 72 d3 03 	vpsrld $0x3,%zmm19,%zmm19
 193d2bb:	62 e3 2d 50 25 1d 72 99 c7 fe ec 	vpternlogd $0xec,-0x138668e(%rip){1to16},%zmm26,%zmm19        # 5b6c38 <tier0_emit_x87.operations+0x1e8>
 193d2c6:	62 03 75 40 25 d8 b8 	vpternlogd $0xb8,%zmm24,%zmm17,%zmm27
 193d2cd:	62 21 35 40 fe c6    	vpaddd %zmm22,%zmm25,%zmm24
 193d2d3:	62 d1 35 40 72 d5 08 	vpsrld $0x8,%zmm13,%zmm25
 193d2da:	62 63 5d 50 25 0d 3b 99 c7 fe 6c 	vpternlogd $0x6c,-0x13866c5(%rip){1to16},%zmm20,%zmm25        # 5b6c20 <tier0_emit_x87.operations+0x1d0>
 193d2e5:	62 51 55 48 eb ed    	vpord  %zmm13,%zmm5,%zmm13
 193d2eb:	62 d1 2d 40 72 f5 07 	vpslld $0x7,%zmm13,%zmm26
 193d2f2:	62 31 7d 40 db ed    	vpandd %zmm21,%zmm16,%zmm13
 193d2f8:	62 73 0d 58 25 2d 41 99 c7 fe ec 	vpternlogd $0xec,-0x13866bf(%rip){1to16},%zmm14,%zmm13        # 5b6c44 <tier0_emit_x87.operations+0x1f4>
 193d303:	62 71 05 58 db 35 3f 99 c7 fe 	vpandd -0x13866c1(%rip){1to16},%zmm15,%zmm14        # 5b6c4c <tier0_emit_x87.operations+0x1fc>
 193d30d:	62 e1 7d 50 db 05 39 99 c7 fe 	vpandd -0x13866c7(%rip){1to16},%zmm16,%zmm16        # 5b6c50 <tier0_emit_x87.operations+0x200>
 193d317:	62 73 2d 58 25 2d 26 99 c7 fe f8 	vpternlogd $0xf8,-0x13866da(%rip){1to16},%zmm10,%zmm13        # 5b6c48 <tier0_emit_x87.operations+0x1f8>
 193d322:	62 a1 35 40 fe e6    	vpaddd %zmm22,%zmm25,%zmm20
 193d328:	62 62 7d 48 58 0d f2 98 c7 fe 	vpbroadcastd -0x138670e(%rip),%zmm25        # 5b6c24 <tier0_emit_x87.operations+0x1d4>
 193d332:	62 63 3d 50 25 0d eb 98 c7 fe ea 	vpternlogd $0xea,-0x1386715(%rip){1to16},%zmm24,%zmm25        # 5b6c28 <tier0_emit_x87.operations+0x1d8>
 193d33d:	62 b1 3d 40 72 f3 08 	vpslld $0x8,%zmm19,%zmm24
 193d344:	62 c3 75 40 25 c6 b8 	vpternlogd $0xb8,%zmm14,%zmm17,%zmm16
 193d34b:	62 d1 0d 48 72 cb 01 	vprold $0x1,%zmm11,%zmm14
 193d352:	62 63 5d 50 25 0d cf 98 c7 fe f8 	vpternlogd $0xf8,-0x1386731(%rip){1to16},%zmm20,%zmm25        # 5b6c2c <tier0_emit_x87.operations+0x1dc>
 193d35d:	62 e1 1d 58 db 25 c9 98 c7 fe 	vpandd -0x1386737(%rip){1to16},%zmm12,%zmm20        # 5b6c30 <tier0_emit_x87.operations+0x1e0>
 193d367:	62 32 0d 48 14 f7    	vprorvd %zmm23,%zmm14,%zmm14
 193d36d:	62 53 05 48 25 f3 e2 	vpternlogd $0xe2,%zmm11,%zmm15,%zmm14
 193d374:	62 53 75 40 25 f3 e2 	vpternlogd $0xe2,%zmm11,%zmm17,%zmm14
 193d37b:	62 e2 7d 48 5a 0d cb f5 c6 fe 	vbroadcasti32x4 -0x1390a35(%rip),%zmm17        # 5ac950 <x86_effects_unknown+0x980>
 193d385:	62 51 7d 48 62 de    	vpunpckldq %zmm14,%zmm0,%zmm11
 193d38b:	62 d1 7d 48 6a c6    	vpunpckhdq %zmm14,%zmm0,%zmm0
 193d391:	62 83 2d 48 25 e1 f8 	vpternlogd $0xf8,%zmm25,%zmm10,%zmm20
 193d398:	62 d1 35 40 72 d4 03 	vpsrld $0x3,%zmm12,%zmm25
 193d39f:	62 63 2d 58 25 0d 92 98 c7 fe a2 	vpternlogd $0xa2,-0x138676e(%rip){1to16},%zmm10,%zmm25        # 5b6c3c <tier0_emit_x87.operations+0x1ec>
 193d3aa:	62 e2 5d 50 3b 25 80 98 c7 fe 	vpminud -0x1386780(%rip){1to16},%zmm20,%zmm20        # 5b6c34 <tier0_emit_x87.operations+0x1e4>
 193d3b4:	62 31 35 40 fe e6    	vpaddd %zmm22,%zmm25,%zmm12
 193d3ba:	62 e2 35 50 3b 35 7c 98 c7 fe 	vpminud -0x1386784(%rip){1to16},%zmm25,%zmm22        # 5b6c40 <tier0_emit_x87.operations+0x1f0>
 193d3c4:	62 62 7d 48 5a 0d 02 f6 c6 fe 	vbroadcasti32x4 -0x13909fe(%rip),%zmm25        # 5ac9d0 <x86_effects_unknown+0xa00>
 193d3ce:	62 d1 1d 48 72 e4 1f 	vpsrad $0x1f,%zmm12,%zmm12
 193d3d5:	62 63 1d 58 25 05 74 98 c7 fe 08 	vpternlogd $0x8,-0x138678c(%rip){1to16},%zmm12,%zmm24        # 5b6c54 <tier0_emit_x87.operations+0x204>
 193d3e0:	62 63 2d 50 25 05 6d 98 c7 fe d8 	vpternlogd $0xd8,-0x1386793(%rip){1to16},%zmm26,%zmm24        # 5b6c58 <tier0_emit_x87.operations+0x208>
 193d3eb:	62 62 b5 40 83 cd    	vpmultishiftqb %zmm5,%zmm25,%zmm25
 193d3f1:	62 63 65 50 25 0d 60 98 c7 fe d8 	vpternlogd $0xd8,-0x13867a0(%rip){1to16},%zmm19,%zmm25        # 5b6c5c <tier0_emit_x87.operations+0x20c>
 193d3fc:	62 33 4d 40 25 ec fe 	vpternlogd $0xfe,%zmm20,%zmm22,%zmm13
 193d403:	62 51 7d 40 eb ed    	vpord  %zmm13,%zmm16,%zmm13
 193d409:	62 c1 7d 48 70 d5 00 	vpshufd $0x0,%zmm13,%zmm18
 193d410:	62 63 3d 50 25 0d 45 98 c7 fe d8 	vpternlogd $0xd8,-0x13867bb(%rip){1to16},%zmm24,%zmm25        # 5b6c60 <tier0_emit_x87.operations+0x210>
 193d41b:	62 f2 6d 40 8f c9    	vpshufbitqmb %zmm1,%zmm18,%k1
 193d421:	c4 e1 fb 93 c1       	kmovq  %k1,%rax
 193d426:	f3 48 0f b8 c0       	popcnt %rax,%rax
 193d42b:	49 8d 0c 06          	lea    (%r14,%rax,1),%rcx
 193d42f:	62 11 25 40 62 f1    	vpunpckldq %zmm25,%zmm27,%zmm14
 193d435:	62 11 25 40 6a f9    	vpunpckhdq %zmm25,%zmm27,%zmm15
 193d43b:	62 c1 a5 48 6c c6    	vpunpcklqdq %zmm14,%zmm11,%zmm16
 193d441:	62 c1 fd 48 6c df    	vpunpcklqdq %zmm15,%zmm0,%zmm19
 193d447:	62 d1 fd 48 6d c7    	vpunpckhqdq %zmm15,%zmm0,%zmm0
 193d44d:	62 51 a5 48 6d de    	vpunpckhqdq %zmm14,%zmm11,%zmm11
 193d453:	62 51 7d 48 70 fd 55 	vpshufd $0x55,%zmm13,%zmm15
 193d45a:	62 e2 7d 40 00 c1    	vpshufb %zmm1,%zmm16,%zmm16
 193d460:	62 d2 7d 48 00 c0    	vpshufb %zmm8,%zmm0,%zmm0
 193d466:	62 a3 ed 48 25 c1 78 	vpternlogq $0x78,%zmm17,%zmm2,%zmm16
 193d46d:	62 f2 25 48 00 d3    	vpshufb %zmm3,%zmm11,%zmm2
 193d473:	62 b3 b5 48 25 c1 78 	vpternlogq $0x78,%zmm17,%zmm9,%zmm0
 193d47a:	62 e2 7d c9 63 c1    	vpcompressb %zmm16,%zmm1{%k1}{z}
 193d480:	62 f2 05 48 8f cb    	vpshufbitqmb %zmm3,%zmm15,%k1
 193d486:	62 d1 7d 48 70 dd aa 	vpshufd $0xaa,%zmm13,%zmm3
 193d48d:	62 b3 dd 48 25 d1 78 	vpternlogq $0x78,%zmm17,%zmm4,%zmm2
 193d494:	62 d1 7d 48 70 e5 ff 	vpshufd $0xff,%zmm13,%zmm4
 193d49b:	62 73 2d 58 25 2d be 97 c7 fe 20 	vpternlogd $0x20,-0x1386842(%rip){1to16},%zmm10,%zmm13        # 5b6c64 <tier0_emit_x87.operations+0x214>
 193d4a6:	c4 e1 fb 93 d1       	kmovq  %k1,%rdx
 193d4ab:	f3 48 0f b8 d2       	popcnt %rdx,%rdx
 193d4b0:	62 d1 fe 48 7f 0e    	vmovdqu64 %zmm1,(%r14)
 193d4b6:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
 193d4ba:	62 f2 7d c9 63 d1    	vpcompressb %zmm2,%zmm1{%k1}{z}
 193d4c0:	62 f2 65 40 00 d6    	vpshufb %zmm6,%zmm19,%zmm2
 193d4c6:	62 f2 65 48 8f ce    	vpshufbitqmb %zmm6,%zmm3,%k1
 193d4cc:	62 f1 2d 58 db 1d 92 97 c7 fe 	vpandd -0x138686e(%rip){1to16},%zmm10,%zmm3        # 5b6c68 <tier0_emit_x87.operations+0x218>
 193d4d6:	48 8d 34 11          	lea    (%rcx,%rdx,1),%rsi
 193d4da:	62 b3 c5 48 25 d1 78 	vpternlogq $0x78,%zmm17,%zmm7,%zmm2
 193d4e1:	62 d1 fe 48 7f 0c 06 	vmovdqu64 %zmm1,(%r14,%rax,1)
 193d4e8:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
 193d4ec:	62 f2 7d c9 63 d1    	vpcompressb %zmm2,%zmm1{%k1}{z}
 193d4f2:	c4 e1 fb 93 c1       	kmovq  %k1,%rax
 193d4f7:	62 d2 5d 48 8f c8    	vpshufbitqmb %zmm8,%zmm4,%k1
 193d4fd:	41 29 de             	sub    %ebx,%r14d
 193d500:	f3 48 0f b8 f8       	popcnt %rax,%rdi
 193d505:	62 f2 7d c9 63 c0    	vpcompressb %zmm0,%zmm0{%k1}{z}
 193d50b:	c4 e1 fb 93 c1       	kmovq  %k1,%rax
 193d510:	f3 48 0f b8 c0       	popcnt %rax,%rax
 193d515:	62 f1 fe 48 7f 0c 0a 	vmovdqu64 %zmm1,(%rdx,%rcx,1)
 193d51c:	62 f1 1d 48 fe cb    	vpaddd %zmm3,%zmm12,%zmm1
 193d522:	48 01 f8             	add    %rdi,%rax
 193d525:	48 01 f0             	add    %rsi,%rax
 193d528:	62 f1 fe 48 7f 04 37 	vmovdqu64 %zmm0,(%rdi,%rsi,1)
 193d52f:	62 d2 7d 48 55 c5    	vpopcntd %zmm13,%zmm0
 193d535:	44 89 74 24 3c       	mov    %r14d,0x3c(%rsp)
 193d53a:	49 89 c6             	mov    %rax,%r14
 193d53d:	62 f1 75 48 fe c0    	vpaddd %zmm0,%zmm1,%zmm0
 193d543:	c5 f9 6f 0d 15 f4 c6 fe 	vmovdqa -0x1390beb(%rip),%xmm1        # 5ac960 <x86_effects_unknown+0x990>
 193d54b:	62 f2 75 48 8d c0    	vpermb %zmm0,%zmm1,%zmm0
 193d551:	62 f2 fd 18 40 05 ed 94 c7 fe 	vpmullq -0x1386b13(%rip){1to2},%xmm0,%xmm0        # 5b6a48 <x86_semantics_benchmark_code.registers+0x450>
 193d55b:	c5 f9 6f 0d 0d f4 c6 fe 	vmovdqa -0x1390bf3(%rip),%xmm1        # 5ac970 <x86_effects_unknown+0x9a0>
 193d563:	c4 e2 79 00 15 14 f4 c6 fe 	vpshufb -0x1390bec(%rip),%xmm0,%xmm2        # 5ac980 <x86_effects_unknown+0x9b0>
 193d56c:	62 f2 75 48 8d cd    	vpermb %zmm5,%zmm1,%zmm1
 193d572:	c5 e9 fc c0          	vpaddb %xmm0,%xmm2,%xmm0
 193d576:	62 f2 7d 48 31 c0    	vpmovzxbd %xmm0,%zmm0
 193d57c:	62 f1 7d 58 fe 44 24 0f 	vpaddd 0x3c(%rsp){1to16},%zmm0,%zmm0
 193d584:	62 f2 7e 48 29 c9    	vpmovb2m %zmm1,%k1
 193d58a:	62 f2 7d c9 8b c0    	vpcompressd %zmm0,%zmm0{%k1}{z}
 193d590:	62 d1 fe 48 7f 07    	vmovdqu64 %zmm0,(%r15)
 193d596:	e9 3d 11 00 00       	jmp    193e6d8 <x86_encode_16+0x2498>
 193d59b:	62 f2 7d 48 5a 1d ab f3 c6 fe 	vbroadcasti32x4 -0x1390c55(%rip),%zmm3        # 5ac950 <x86_effects_unknown+0x980>
 193d5a5:	62 72 7d 48 58 0d 79 96 c7 fe 	vpbroadcastd -0x1386987(%rip),%zmm9        # 5b6c28 <tier0_emit_x87.operations+0x1d8>
 193d5af:	48 8d 4a f0          	lea    -0x10(%rdx),%rcx
 193d5b3:	41 b1 cc             	mov    $0xcc,%r9b
 193d5b6:	48 8d be fc 00 00 00 	lea    0xfc(%rsi),%rdi
 193d5bd:	4c 8d 05 7c ee 31 0d 	lea    0xd31ee7c(%rip),%r8        # ec5c440 <x86_template_storage>
 193d5c4:	62 53 1d 48 25 e4 ff 	vpternlogd $0xff,%zmm12,%zmm12,%zmm12
 193d5cb:	31 c0                	xor    %eax,%eax
 193d5cd:	49 89 de             	mov    %rbx,%r14
 193d5d0:	48 c1 e9 04          	shr    $0x4,%rcx
 193d5d4:	c4 c1 7b 92 c9       	kmovd  %r9d,%k1
 193d5d9:	48 ff c1             	inc    %rcx
 193d5dc:	0f 1f 40 00          	nopl   0x0(%rax)
 193d5e0:	44 0f b7 8f 10 ff ff ff 	movzwl -0xf0(%rdi),%r9d
 193d5e8:	44 0f b7 97 20 ff ff ff 	movzwl -0xe0(%rdi),%r10d
 193d5f0:	44 0f b7 9f 30 ff ff ff 	movzwl -0xd0(%rdi),%r11d
 193d5f8:	44 0f b7 bf 40 ff ff ff 	movzwl -0xc0(%rdi),%r15d
 193d600:	62 e1 fe 48 6f 9f 04 ff ff ff 	vmovdqu64 -0xfc(%rdi),%zmm19
 193d60a:	62 e1 fe 48 6f af 44 ff ff ff 	vmovdqu64 -0xbc(%rdi),%zmm21
 193d614:	62 e1 fe 48 6f b7 84 ff ff ff 	vmovdqu64 -0x7c(%rdi),%zmm22
 193d61e:	62 e1 fe 48 6f bf c4 ff ff ff 	vmovdqu64 -0x3c(%rdi),%zmm23
 193d628:	62 f2 7d 48 5a 0d 5e f3 c6 fe 	vbroadcasti32x4 -0x1390ca2(%rip),%zmm1        # 5ac990 <x86_effects_unknown+0x9c0>
 193d632:	48 83 c0 10          	add    $0x10,%rax
 193d636:	41 c1 e1 06          	shl    $0x6,%r9d
 193d63a:	41 c1 e2 06          	shl    $0x6,%r10d
 193d63e:	41 c1 e3 06          	shl    $0x6,%r11d
 193d642:	41 c1 e7 06          	shl    $0x6,%r15d
 193d646:	c4 81 7d 6f 64 01 40 	vmovdqa 0x40(%r9,%r8,1),%ymm4
 193d64d:	44 0f b7 8f 50 ff ff ff 	movzwl -0xb0(%rdi),%r9d
 193d655:	c4 81 7d 6f 6c 02 60 	vmovdqa 0x60(%r10,%r8,1),%ymm5
 193d65c:	44 0f b7 97 60 ff ff ff 	movzwl -0xa0(%rdi),%r10d
 193d664:	62 93 dd 48 3a 64 03 02 01 	vinserti64x4 $0x1,0x40(%r11,%r8,1),%zmm4,%zmm4
 193d66d:	62 13 d5 48 3a 7c 07 03 01 	vinserti64x4 $0x1,0x60(%r15,%r8,1),%zmm5,%zmm15
 193d676:	44 0f b7 9f 70 ff ff ff 	movzwl -0x90(%rdi),%r11d
 193d67e:	44 0f b7 7f 80       	movzwl -0x80(%rdi),%r15d
 193d683:	62 b1 65 40 62 f5    	vpunpckldq %zmm21,%zmm19,%zmm6
 193d689:	62 b1 4d 40 62 ff    	vpunpckldq %zmm23,%zmm22,%zmm7
 193d68f:	62 a1 4d 40 6a f7    	vpunpckhdq %zmm23,%zmm22,%zmm22
 193d695:	62 a1 65 40 6a ed    	vpunpckhdq %zmm21,%zmm19,%zmm21
 193d69b:	62 b1 d5 40 6c d6    	vpunpcklqdq %zmm22,%zmm21,%zmm2
 193d6a1:	62 e1 cd 48 6d ff    	vpunpckhqdq %zmm7,%zmm6,%zmm23
 193d6a7:	62 62 f5 48 83 da    	vpmultishiftqb %zmm2,%zmm1,%zmm27
 193d6ad:	62 f2 7d 48 5a 0d f9 f2 c6 fe 	vbroadcasti32x4 -0x1390d07(%rip),%zmm1        # 5ac9b0 <x86_effects_unknown+0x9e0>
 193d6b7:	62 f1 15 40 72 d2 1a 	vpsrld $0x1a,%zmm2,%zmm29
 193d6be:	62 b2 45 40 27 c7    	vptestmd %zmm23,%zmm23,%k0
 193d6c4:	62 e1 fd 48 6f da    	vmovdqa64 %zmm2,%zmm19
 193d6ca:	41 c1 e1 06          	shl    $0x6,%r9d
 193d6ce:	41 c1 e2 06          	shl    $0x6,%r10d
 193d6d2:	c4 01 7d 6f 44 01 40 	vmovdqa 0x40(%r9,%r8,1),%ymm8
 193d6d9:	44 0f b7 4f 90       	movzwl -0x70(%rdi),%r9d
 193d6de:	41 c1 e3 06          	shl    $0x6,%r11d
 193d6e2:	c4 01 7d 6f 54 02 60 	vmovdqa 0x60(%r10,%r8,1),%ymm10
 193d6e9:	44 0f b7 57 a0       	movzwl -0x60(%rdi),%r10d
 193d6ee:	41 c1 e7 06          	shl    $0x6,%r15d
 193d6f2:	62 13 bd 48 3a 44 03 02 01 	vinserti64x4 $0x1,0x40(%r11,%r8,1),%zmm8,%zmm8
 193d6fb:	62 83 ad 48 3a 4c 07 03 01 	vinserti64x4 $0x1,0x60(%r15,%r8,1),%zmm10,%zmm17
 193d704:	44 0f b7 5f b0       	movzwl -0x50(%rdi),%r11d
 193d709:	44 0f b7 7f c0       	movzwl -0x40(%rdi),%r15d
 193d70e:	62 d2 dd 49 64 ef    	vpblendmq %zmm15,%zmm4,%zmm5{%k1}
 193d714:	41 c1 e1 06          	shl    $0x6,%r9d
 193d718:	41 c1 e2 06          	shl    $0x6,%r10d
 193d71c:	c4 01 7d 6f 5c 01 40 	vmovdqa 0x40(%r9,%r8,1),%ymm11
 193d723:	44 0f b7 4f d0       	movzwl -0x30(%rdi),%r9d
 193d728:	41 c1 e3 06          	shl    $0x6,%r11d
 193d72c:	c4 01 7d 6f 6c 02 60 	vmovdqa 0x60(%r10,%r8,1),%ymm13
 193d733:	44 0f b7 57 e0       	movzwl -0x20(%rdi),%r10d
 193d738:	41 c1 e7 06          	shl    $0x6,%r15d
 193d73c:	62 62 f5 48 83 f2    	vpmultishiftqb %zmm2,%zmm1,%zmm30
 193d742:	62 f2 7d 48 5a 0d 54 f2 c6 fe 	vbroadcasti32x4 -0x1390dac(%rip),%zmm1        # 5ac9a0 <x86_effects_unknown+0x9d0>
 193d74c:	62 63 25 50 25 35 ad 94 c7 fe d8 	vpternlogd $0xd8,-0x1386b53(%rip){1to16},%zmm27,%zmm30        # 5b6c04 <tier0_emit_x87.operations+0x1b4>
 193d757:	62 13 a5 48 3a 5c 03 02 01 	vinserti64x4 $0x1,0x40(%r11,%r8,1),%zmm11,%zmm11
 193d760:	62 83 95 48 3a 54 07 03 01 	vinserti64x4 $0x1,0x60(%r15,%r8,1),%zmm13,%zmm18
 193d769:	44 0f b7 5f f0       	movzwl -0x10(%rdi),%r11d
 193d76e:	44 0f b7 3f          	movzwl (%rdi),%r15d
 193d772:	48 81 c7 00 01 00 00 	add    $0x100,%rdi
 193d779:	62 32 bd 49 64 d1    	vpblendmq %zmm17,%zmm8,%zmm10{%k1}
 193d77f:	62 41 55 48 6a c2    	vpunpckhdq %zmm10,%zmm5,%zmm24
 193d785:	41 c1 e1 06          	shl    $0x6,%r9d
 193d789:	41 c1 e2 06          	shl    $0x6,%r10d
 193d78d:	41 c1 e3 06          	shl    $0x6,%r11d
 193d791:	c4 01 7d 6f 74 01 40 	vmovdqa 0x40(%r9,%r8,1),%ymm14
 193d798:	41 c1 e7 06          	shl    $0x6,%r15d
 193d79c:	62 81 fd 28 6f 44 02 03 	vmovdqa64 0x60(%r10,%r8,1),%ymm16
 193d7a4:	62 13 8d 48 3a 74 03 02 01 	vinserti64x4 $0x1,0x40(%r11,%r8,1),%zmm14,%zmm14
 193d7ad:	62 83 fd 40 3a 64 07 03 01 	vinserti64x4 $0x1,0x60(%r15,%r8,1),%zmm16,%zmm20
 193d7b6:	62 62 f5 48 83 e2    	vpmultishiftqb %zmm2,%zmm1,%zmm28
 193d7bc:	62 f1 75 48 72 f2 04 	vpslld $0x4,%zmm2,%zmm1
 193d7c3:	62 63 0d 50 25 25 3a 94 c7 fe e4 	vpternlogd $0xe4,-0x1386bc6(%rip){1to16},%zmm30,%zmm28        # 5b6c08 <tier0_emit_x87.operations+0x1b8>
 193d7ce:	62 f1 25 40 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm27
 193d7d5:	62 f2 7d 48 5a 0d e1 f1 c6 fe 	vbroadcasti32x4 -0x1390e1f(%rip),%zmm1        # 5ac9c0 <x86_effects_unknown+0x9f0>
 193d7df:	62 32 a5 49 64 ea    	vpblendmq %zmm18,%zmm11,%zmm13{%k1}
 193d7e5:	62 a2 8d 49 64 c4    	vpblendmq %zmm20,%zmm14,%zmm16{%k1}
 193d7eb:	62 21 15 48 6a c8    	vpunpckhdq %zmm16,%zmm13,%zmm25
 193d7f1:	62 01 bd 40 6d d1    	vpunpckhqdq %zmm25,%zmm24,%zmm26
 193d7f7:	62 62 15 40 36 0d bf ac c0 fe 	vpermd -0x13f5341(%rip),%zmm29,%zmm25        # 5484c0 <branch_sizing_patterns+0x2830>
 193d801:	62 62 15 40 36 05 f5 ac c0 fe 	vpermd -0x13f530b(%rip),%zmm29,%zmm24        # 548500 <branch_sizing_patterns+0x2870>
 193d80b:	62 62 75 48 00 f2    	vpshufb %zmm2,%zmm1,%zmm30
 193d811:	62 f2 7d 48 58 0d f5 93 c7 fe 	vpbroadcastd -0x1386c0b(%rip),%zmm1        # 5b6c10 <tier0_emit_x87.operations+0x1c0>
 193d81b:	62 62 15 40 36 2d 1b ad c0 fe 	vpermd -0x13f52e5(%rip),%zmm29,%zmm29        # 548540 <branch_sizing_patterns+0x28b0>
 193d825:	62 91 7d 48 72 f6 10 	vpslld $0x10,%zmm30,%zmm0
 193d82c:	62 01 25 40 db f6    	vpandd %zmm30,%zmm27,%zmm30
 193d832:	62 f1 05 40 72 e0 1f 	vpsrad $0x1f,%zmm0,%zmm31
 193d839:	62 b1 7d 48 72 e7 1f 	vpsrad $0x1f,%zmm23,%zmm0
 193d840:	62 03 1d 40 25 c1 f8 	vpternlogd $0xf8,%zmm25,%zmm28,%zmm24
 193d847:	62 62 7e 48 38 c8    	vpmovm2d %k0,%zmm25
 193d84d:	62 03 25 40 25 cf c8 	vpternlogd $0xc8,%zmm31,%zmm27,%zmm25
 193d854:	62 21 7d 48 ef ff    	vpxord %zmm23,%zmm0,%zmm31
 193d85a:	62 f2 7d 48 58 05 a8 93 c7 fe 	vpbroadcastd -0x1386c58(%rip),%zmm0        # 5b6c0c <tier0_emit_x87.operations+0x1bc>
 193d864:	62 63 15 50 25 35 d5 93 c7 fe ec 	vpternlogd $0xec,-0x1386c2b(%rip){1to16},%zmm29,%zmm30        # 5b6c44 <tier0_emit_x87.operations+0x1f4>
 193d86f:	62 91 15 40 72 d2 1d 	vpsrld $0x1d,%zmm26,%zmm29
 193d876:	62 02 7d 48 44 ff    	vplzcntd %zmm31,%zmm31
 193d87c:	62 63 2d 50 25 35 c1 93 c7 fe f8 	vpternlogd $0xf8,-0x1386c3f(%rip){1to16},%zmm26,%zmm30        # 5b6c48 <tier0_emit_x87.operations+0x1f8>
 193d887:	62 02 75 48 45 ff    	vpsrlvd %zmm31,%zmm1,%zmm31
 193d88d:	62 d1 45 40 fe cc    	vpaddd %zmm12,%zmm23,%zmm1
 193d893:	62 93 45 40 25 cf 14 	vpternlogd $0x14,%zmm31,%zmm23,%zmm1
 193d89a:	62 f1 05 40 72 d2 08 	vpsrld $0x8,%zmm2,%zmm31
 193d8a1:	62 92 75 48 14 cd    	vprorvd %zmm29,%zmm1,%zmm1
 193d8a7:	62 f1 75 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm1
 193d8ae:	62 e3 7d 58 25 1d 63 93 c7 fe 6c 	vpternlogd $0x6c,-0x1386c9d(%rip){1to16},%zmm0,%zmm19        # 5b6c1c <tier0_emit_x87.operations+0x1cc>
 193d8b9:	62 63 7d 58 25 3d 5c 93 c7 fe 6c 	vpternlogd $0x6c,-0x1386ca4(%rip){1to16},%zmm0,%zmm31        # 5b6c20 <tier0_emit_x87.operations+0x1d0>
 193d8c4:	62 f1 1d 50 db 05 62 93 c7 fe 	vpandd -0x1386c9e(%rip){1to16},%zmm28,%zmm0        # 5b6c30 <tier0_emit_x87.operations+0x1e0>
 193d8ce:	62 91 1d 40 72 d4 03 	vpsrld $0x3,%zmm28,%zmm28
 193d8d5:	62 63 2d 50 25 25 5c 93 c7 fe a2 	vpternlogd $0xa2,-0x1386ca4(%rip){1to16},%zmm26,%zmm28        # 5b6c3c <tier0_emit_x87.operations+0x1ec>
 193d8e0:	62 c1 65 40 fe dc    	vpaddd %zmm12,%zmm19,%zmm19
 193d8e6:	62 e3 35 58 25 1d 33 93 c7 fe ec 	vpternlogd $0xec,-0x1386ccd(%rip){1to16},%zmm9,%zmm19        # 5b6c24 <tier0_emit_x87.operations+0x1d4>
 193d8f1:	62 41 05 40 fe fc    	vpaddd %zmm12,%zmm31,%zmm31
 193d8f7:	62 63 65 50 25 3d 2a 93 c7 fe ec 	vpternlogd $0xec,-0x1386cd6(%rip){1to16},%zmm19,%zmm31        # 5b6c2c <tier0_emit_x87.operations+0x1dc>
 193d902:	62 93 2d 40 25 c7 f8 	vpternlogd $0xf8,%zmm31,%zmm26,%zmm0
 193d909:	62 e2 7d 58 3b 1d 21 93 c7 fe 	vpminud -0x1386cdf(%rip){1to16},%zmm0,%zmm19        # 5b6c34 <tier0_emit_x87.operations+0x1e4>
 193d913:	62 f2 1d 50 3b 05 23 93 c7 fe 	vpminud -0x1386cdd(%rip){1to16},%zmm28,%zmm0        # 5b6c40 <tier0_emit_x87.operations+0x1f0>
 193d91d:	62 01 fd 48 6f d0    	vmovdqa64 %zmm24,%zmm26
 193d923:	62 63 35 50 25 15 e6 92 c7 fe f8 	vpternlogd $0xf8,-0x1386d1a(%rip){1to16},%zmm25,%zmm26        # 5b6c14 <tier0_emit_x87.operations+0x1c4>
 193d92e:	62 61 35 50 db 3d 14 93 c7 fe 	vpandd -0x1386cec(%rip){1to16},%zmm25,%zmm31        # 5b6c4c <tier0_emit_x87.operations+0x1fc>
 193d938:	62 23 7d 48 25 f3 fe 	vpternlogd $0xfe,%zmm19,%zmm0,%zmm30
 193d93f:	62 81 fd 48 6f d8    	vmovdqa64 %zmm24,%zmm19
 193d945:	62 e3 25 50 25 1d c8 92 c7 fe f8 	vpternlogd $0xf8,-0x1386d38(%rip){1to16},%zmm27,%zmm19        # 5b6c18 <tier0_emit_x87.operations+0x1c8>
 193d950:	62 b1 7d 48 72 cf 01 	vprold $0x1,%zmm23,%zmm0
 193d957:	62 61 25 50 db 1d ef 92 c7 fe 	vpandd -0x1386d11(%rip){1to16},%zmm27,%zmm27        # 5b6c50 <tier0_emit_x87.operations+0x200>
 193d961:	62 83 75 48 25 da b8 	vpternlogd $0xb8,%zmm26,%zmm1,%zmm19
 193d968:	62 02 7d 48 14 d5    	vprorvd %zmm29,%zmm0,%zmm26
 193d96e:	62 f1 fd 48 6f 05 08 ab c0 fe 	vmovdqa64 -0x13f54f8(%rip),%zmm0        # 548480 <branch_sizing_patterns+0x27f0>
 193d978:	62 03 75 48 25 df b8 	vpternlogd $0xb8,%zmm31,%zmm1,%zmm27
 193d97f:	62 23 35 40 25 d7 e2 	vpternlogd $0xe2,%zmm23,%zmm25,%zmm26
 193d986:	62 23 75 48 25 d7 e2 	vpternlogd $0xe2,%zmm23,%zmm1,%zmm26
 193d98d:	62 f1 cd 48 6c cf    	vpunpcklqdq %zmm7,%zmm6,%zmm1
 193d993:	62 d1 1d 40 fe fc    	vpaddd %zmm12,%zmm28,%zmm7
 193d999:	62 b1 d5 40 6d f6    	vpunpckhqdq %zmm22,%zmm21,%zmm6
 193d99f:	62 f1 45 48 72 e7 1f 	vpsrad $0x1f,%zmm7,%zmm7
 193d9a6:	62 f1 4d 48 eb d2    	vpord  %zmm2,%zmm6,%zmm2
 193d9ac:	62 f1 6d 48 72 f2 07 	vpslld $0x7,%zmm2,%zmm2
 193d9b3:	62 d2 fd 48 7e e7    	vpermt2q %zmm15,%zmm0,%zmm4
 193d9b9:	62 32 fd 48 7e c1    	vpermt2q %zmm17,%zmm0,%zmm8
 193d9bf:	62 32 fd 48 7e da    	vpermt2q %zmm18,%zmm0,%zmm11
 193d9c5:	62 32 fd 48 7e f4    	vpermt2q %zmm20,%zmm0,%zmm14
 193d9cb:	62 91 7d 48 72 d0 10 	vpsrld $0x10,%zmm24,%zmm0
 193d9d2:	62 91 05 48 72 d0 03 	vpsrld $0x3,%zmm24,%zmm15
 193d9d9:	62 73 7d 58 25 3d 54 92 c7 fe ec 	vpternlogd $0xec,-0x1386dac(%rip){1to16},%zmm0,%zmm15        # 5b6c38 <tier0_emit_x87.operations+0x1e8>
 193d9e4:	62 f2 7d 48 5a 05 e2 ef c6 fe 	vbroadcasti32x4 -0x139101e(%rip),%zmm0        # 5ac9d0 <x86_effects_unknown+0xa00>
 193d9ee:	62 d1 75 40 72 f7 08 	vpslld $0x8,%zmm15,%zmm17
 193d9f5:	62 e3 45 58 25 0d 54 92 c7 fe 08 	vpternlogd $0x8,-0x1386dac(%rip){1to16},%zmm7,%zmm17        # 5b6c54 <tier0_emit_x87.operations+0x204>
 193da00:	62 f2 fd 48 83 f6    	vpmultishiftqb %zmm6,%zmm0,%zmm6
 193da06:	62 f3 05 58 25 35 4b 92 c7 fe d8 	vpternlogd $0xd8,-0x1386db5(%rip){1to16},%zmm15,%zmm6        # 5b6c5c <tier0_emit_x87.operations+0x20c>
 193da11:	62 91 25 40 eb fe    	vpord  %zmm30,%zmm27,%zmm7
 193da17:	62 f1 7d 48 70 c7 00 	vpshufd $0x0,%zmm7,%zmm0
 193da1e:	62 f2 7d 48 8f dc    	vpshufbitqmb %zmm4,%zmm0,%k3
 193da24:	62 f1 7d 48 70 c7 55 	vpshufd $0x55,%zmm7,%zmm0
 193da2b:	62 d2 7d 48 8f d0    	vpshufbitqmb %zmm8,%zmm0,%k2
 193da31:	62 f1 7d 48 70 c7 aa 	vpshufd $0xaa,%zmm7,%zmm0
 193da38:	c4 61 fb 93 cb       	kmovq  %k3,%r9
 193da3d:	f3 4d 0f b8 c9       	popcnt %r9,%r9
 193da42:	c4 61 fb 93 d2       	kmovq  %k2,%r10
 193da47:	f3 4d 0f b8 d2       	popcnt %r10,%r10
 193da4c:	62 f3 75 50 25 15 01 92 c7 fe e4 	vpternlogd $0xe4,-0x1386dff(%rip){1to16},%zmm17,%zmm2        # 5b6c58 <tier0_emit_x87.operations+0x208>
 193da57:	62 f3 6d 58 25 35 fe 91 c7 fe d8 	vpternlogd $0xd8,-0x1386e02(%rip){1to16},%zmm2,%zmm6        # 5b6c60 <tier0_emit_x87.operations+0x210>
 193da62:	62 91 75 48 62 d2    	vpunpckldq %zmm26,%zmm1,%zmm2
 193da68:	62 91 75 48 6a ca    	vpunpckhdq %zmm26,%zmm1,%zmm1
 193da6e:	62 71 65 40 62 fe    	vpunpckldq %zmm6,%zmm19,%zmm15
 193da74:	62 f1 65 40 6a f6    	vpunpckhdq %zmm6,%zmm19,%zmm6
 193da7a:	62 c1 ed 48 6c cf    	vpunpcklqdq %zmm15,%zmm2,%zmm17
 193da80:	62 d1 ed 48 6d d7    	vpunpckhqdq %zmm15,%zmm2,%zmm2
 193da86:	62 e1 f5 48 6c d6    	vpunpcklqdq %zmm6,%zmm1,%zmm18
 193da8c:	62 f1 f5 48 6d ce    	vpunpckhqdq %zmm6,%zmm1,%zmm1
 193da92:	62 f2 75 40 00 e4    	vpshufb %zmm4,%zmm17,%zmm4
 193da98:	62 d2 6d 48 00 d0    	vpshufb %zmm8,%zmm2,%zmm2
 193da9e:	62 d2 75 48 00 ce    	vpshufb %zmm14,%zmm1,%zmm1
 193daa4:	62 f3 d5 48 25 e3 78 	vpternlogq $0x78,%zmm3,%zmm5,%zmm4
 193daab:	62 f3 ad 48 25 d3 78 	vpternlogq $0x78,%zmm3,%zmm10,%zmm2
 193dab2:	62 f3 fd 40 25 cb 78 	vpternlogq $0x78,%zmm3,%zmm16,%zmm1
 193dab9:	62 f2 7d cb 63 e4    	vpcompressb %zmm4,%zmm4{%k3}{z}
 193dabf:	62 f2 7d ca 63 d2    	vpcompressb %zmm2,%zmm2{%k2}{z}
 193dac5:	62 d2 7d 48 8f db    	vpshufbitqmb %zmm11,%zmm0,%k3
 193dacb:	62 f1 7d 48 70 c7 ff 	vpshufd $0xff,%zmm7,%zmm0
 193dad2:	62 d2 7d 48 8f d6    	vpshufbitqmb %zmm14,%zmm0,%k2
 193dad8:	c4 61 fb 93 db       	kmovq  %k3,%r11
 193dadd:	62 f2 7d ca 63 c9    	vpcompressb %zmm1,%zmm1{%k2}{z}
 193dae3:	62 d1 fe 48 7f 26    	vmovdqu64 %zmm4,(%r14)
 193dae9:	62 d2 6d 40 00 e3    	vpshufb %zmm11,%zmm18,%zmm4
 193daef:	62 91 fe 48 7f 14 0e 	vmovdqu64 %zmm2,(%r14,%r9,1)
 193daf6:	4d 01 f1             	add    %r14,%r9
 193daf9:	62 f3 95 48 25 e3 78 	vpternlogq $0x78,%zmm3,%zmm13,%zmm4
 193db00:	c5 e9 ef d2          	vpxor  %xmm2,%xmm2,%xmm2
 193db04:	62 f2 7d cb 63 e2    	vpcompressb %zmm4,%zmm2{%k3}{z}
 193db0a:	62 91 fe 48 7f 14 0a 	vmovdqu64 %zmm2,(%r10,%r9,1)
 193db11:	4d 01 d1             	add    %r10,%r9
 193db14:	f3 4d 0f b8 d3       	popcnt %r11,%r10
 193db19:	c4 61 fb 93 da       	kmovq  %k2,%r11
 193db1e:	f3 4d 0f b8 f3       	popcnt %r11,%r14
 193db23:	62 91 fe 48 7f 0c 0a 	vmovdqu64 %zmm1,(%r10,%r9,1)
 193db2a:	4d 01 d6             	add    %r10,%r14
 193db2d:	4d 01 ce             	add    %r9,%r14
 193db30:	48 ff c9             	dec    %rcx
 193db33:	0f 85 a7 fa ff ff    	jne    193d5e0 <x86_encode_16+0x13a0>
 193db39:	48 8d 48 10          	lea    0x10(%rax),%rcx
 193db3d:	48 39 d1             	cmp    %rdx,%rcx
 193db40:	0f 87 a3 05 00 00    	ja     193e0e9 <x86_encode_16+0x1ea9>
 193db46:	62 f2 7d 48 5a 1d 00 ee c6 fe 	vbroadcasti32x4 -0x1391200(%rip),%zmm3        # 5ac950 <x86_effects_unknown+0x980>
 193db50:	62 72 7d 48 58 0d ce 90 c7 fe 	vpbroadcastd -0x1386f32(%rip),%zmm9        # 5b6c28 <tier0_emit_x87.operations+0x1d8>
 193db5a:	48 89 d1             	mov    %rdx,%rcx
 193db5d:	48 29 c1             	sub    %rax,%rcx
 193db60:	48 89 c7             	mov    %rax,%rdi
 193db63:	48 c1 e7 04          	shl    $0x4,%rdi
 193db67:	41 b1 cc             	mov    $0xcc,%r9b
 193db6a:	4c 8d 05 cf e8 31 0d 	lea    0xd31e8cf(%rip),%r8        # ec5c440 <x86_template_storage>
 193db71:	62 53 1d 48 25 e4 ff 	vpternlogd $0xff,%zmm12,%zmm12,%zmm12
 193db78:	48 83 c1 f0          	add    $0xfffffffffffffff0,%rcx
 193db7c:	48 8d bc 37 fc 00 00 00 	lea    0xfc(%rdi,%rsi,1),%rdi
 193db84:	c4 c1 7b 92 c9       	kmovd  %r9d,%k1
 193db89:	48 c1 e9 04          	shr    $0x4,%rcx
 193db8d:	48 ff c1             	inc    %rcx
 193db90:	44 0f b7 8f 10 ff ff ff 	movzwl -0xf0(%rdi),%r9d
 193db98:	44 0f b7 97 20 ff ff ff 	movzwl -0xe0(%rdi),%r10d
 193dba0:	44 0f b7 9f 30 ff ff ff 	movzwl -0xd0(%rdi),%r11d
 193dba8:	44 0f b7 bf 40 ff ff ff 	movzwl -0xc0(%rdi),%r15d
 193dbb0:	62 e1 fe 48 6f 9f 04 ff ff ff 	vmovdqu64 -0xfc(%rdi),%zmm19
 193dbba:	62 e1 fe 48 6f af 44 ff ff ff 	vmovdqu64 -0xbc(%rdi),%zmm21
 193dbc4:	62 e1 fe 48 6f b7 84 ff ff ff 	vmovdqu64 -0x7c(%rdi),%zmm22
 193dbce:	62 e1 fe 48 6f bf c4 ff ff ff 	vmovdqu64 -0x3c(%rdi),%zmm23
 193dbd8:	62 f2 7d 48 5a 0d ae ed c6 fe 	vbroadcasti32x4 -0x1391252(%rip),%zmm1        # 5ac990 <x86_effects_unknown+0x9c0>
 193dbe2:	48 83 c0 10          	add    $0x10,%rax
 193dbe6:	41 c1 e1 06          	shl    $0x6,%r9d
 193dbea:	41 c1 e2 06          	shl    $0x6,%r10d
 193dbee:	41 c1 e3 06          	shl    $0x6,%r11d
 193dbf2:	41 c1 e7 06          	shl    $0x6,%r15d
 193dbf6:	c4 81 7d 6f 64 01 40 	vmovdqa 0x40(%r9,%r8,1),%ymm4
 193dbfd:	44 0f b7 8f 50 ff ff ff 	movzwl -0xb0(%rdi),%r9d
 193dc05:	c4 81 7d 6f 6c 02 60 	vmovdqa 0x60(%r10,%r8,1),%ymm5
 193dc0c:	44 0f b7 97 60 ff ff ff 	movzwl -0xa0(%rdi),%r10d
 193dc14:	62 93 dd 48 3a 64 03 02 01 	vinserti64x4 $0x1,0x40(%r11,%r8,1),%zmm4,%zmm4
 193dc1d:	62 13 d5 48 3a 7c 07 03 01 	vinserti64x4 $0x1,0x60(%r15,%r8,1),%zmm5,%zmm15
 193dc26:	44 0f b7 9f 70 ff ff ff 	movzwl -0x90(%rdi),%r11d
 193dc2e:	44 0f b7 7f 80       	movzwl -0x80(%rdi),%r15d
 193dc33:	62 b1 65 40 62 f5    	vpunpckldq %zmm21,%zmm19,%zmm6
 193dc39:	62 b1 4d 40 62 ff    	vpunpckldq %zmm23,%zmm22,%zmm7
 193dc3f:	62 a1 4d 40 6a f7    	vpunpckhdq %zmm23,%zmm22,%zmm22
 193dc45:	62 a1 65 40 6a ed    	vpunpckhdq %zmm21,%zmm19,%zmm21
 193dc4b:	62 b1 d5 40 6c d6    	vpunpcklqdq %zmm22,%zmm21,%zmm2
 193dc51:	62 e1 cd 48 6d ff    	vpunpckhqdq %zmm7,%zmm6,%zmm23
 193dc57:	62 62 f5 48 83 da    	vpmultishiftqb %zmm2,%zmm1,%zmm27
 193dc5d:	62 f2 7d 48 5a 0d 49 ed c6 fe 	vbroadcasti32x4 -0x13912b7(%rip),%zmm1        # 5ac9b0 <x86_effects_unknown+0x9e0>
 193dc67:	62 f1 15 40 72 d2 1a 	vpsrld $0x1a,%zmm2,%zmm29
 193dc6e:	62 b2 45 40 27 c7    	vptestmd %zmm23,%zmm23,%k0
 193dc74:	62 e1 fd 48 6f da    	vmovdqa64 %zmm2,%zmm19
 193dc7a:	41 c1 e1 06          	shl    $0x6,%r9d
 193dc7e:	41 c1 e2 06          	shl    $0x6,%r10d
 193dc82:	c4 01 7d 6f 44 01 40 	vmovdqa 0x40(%r9,%r8,1),%ymm8
 193dc89:	44 0f b7 4f 90       	movzwl -0x70(%rdi),%r9d
 193dc8e:	41 c1 e3 06          	shl    $0x6,%r11d
 193dc92:	c4 01 7d 6f 54 02 60 	vmovdqa 0x60(%r10,%r8,1),%ymm10
 193dc99:	44 0f b7 57 a0       	movzwl -0x60(%rdi),%r10d
 193dc9e:	41 c1 e7 06          	shl    $0x6,%r15d
 193dca2:	62 13 bd 48 3a 44 03 02 01 	vinserti64x4 $0x1,0x40(%r11,%r8,1),%zmm8,%zmm8
 193dcab:	62 83 ad 48 3a 4c 07 03 01 	vinserti64x4 $0x1,0x60(%r15,%r8,1),%zmm10,%zmm17
 193dcb4:	44 0f b7 5f b0       	movzwl -0x50(%rdi),%r11d
 193dcb9:	44 0f b7 7f c0       	movzwl -0x40(%rdi),%r15d
 193dcbe:	62 d2 dd 49 64 ef    	vpblendmq %zmm15,%zmm4,%zmm5{%k1}
 193dcc4:	41 c1 e1 06          	shl    $0x6,%r9d
 193dcc8:	41 c1 e2 06          	shl    $0x6,%r10d
 193dccc:	c4 01 7d 6f 5c 01 40 	vmovdqa 0x40(%r9,%r8,1),%ymm11
 193dcd3:	44 0f b7 4f d0       	movzwl -0x30(%rdi),%r9d
 193dcd8:	41 c1 e3 06          	shl    $0x6,%r11d
 193dcdc:	c4 01 7d 6f 6c 02 60 	vmovdqa 0x60(%r10,%r8,1),%ymm13
 193dce3:	44 0f b7 57 e0       	movzwl -0x20(%rdi),%r10d
 193dce8:	41 c1 e7 06          	shl    $0x6,%r15d
 193dcec:	62 62 f5 48 83 f2    	vpmultishiftqb %zmm2,%zmm1,%zmm30
 193dcf2:	62 f2 7d 48 5a 0d a4 ec c6 fe 	vbroadcasti32x4 -0x139135c(%rip),%zmm1        # 5ac9a0 <x86_effects_unknown+0x9d0>
 193dcfc:	62 63 25 50 25 35 fd 8e c7 fe d8 	vpternlogd $0xd8,-0x1387103(%rip){1to16},%zmm27,%zmm30        # 5b6c04 <tier0_emit_x87.operations+0x1b4>
 193dd07:	62 13 a5 48 3a 5c 03 02 01 	vinserti64x4 $0x1,0x40(%r11,%r8,1),%zmm11,%zmm11
 193dd10:	62 83 95 48 3a 54 07 03 01 	vinserti64x4 $0x1,0x60(%r15,%r8,1),%zmm13,%zmm18
 193dd19:	44 0f b7 5f f0       	movzwl -0x10(%rdi),%r11d
 193dd1e:	44 0f b7 3f          	movzwl (%rdi),%r15d
 193dd22:	48 81 c7 00 01 00 00 	add    $0x100,%rdi
 193dd29:	62 32 bd 49 64 d1    	vpblendmq %zmm17,%zmm8,%zmm10{%k1}
 193dd2f:	62 41 55 48 6a c2    	vpunpckhdq %zmm10,%zmm5,%zmm24
 193dd35:	41 c1 e1 06          	shl    $0x6,%r9d
 193dd39:	41 c1 e2 06          	shl    $0x6,%r10d
 193dd3d:	41 c1 e3 06          	shl    $0x6,%r11d
 193dd41:	c4 01 7d 6f 74 01 40 	vmovdqa 0x40(%r9,%r8,1),%ymm14
 193dd48:	41 c1 e7 06          	shl    $0x6,%r15d
 193dd4c:	62 81 fd 28 6f 44 02 03 	vmovdqa64 0x60(%r10,%r8,1),%ymm16
 193dd54:	62 13 8d 48 3a 74 03 02 01 	vinserti64x4 $0x1,0x40(%r11,%r8,1),%zmm14,%zmm14
 193dd5d:	62 83 fd 40 3a 64 07 03 01 	vinserti64x4 $0x1,0x60(%r15,%r8,1),%zmm16,%zmm20
 193dd66:	62 62 f5 48 83 e2    	vpmultishiftqb %zmm2,%zmm1,%zmm28
 193dd6c:	62 f1 75 48 72 f2 04 	vpslld $0x4,%zmm2,%zmm1
 193dd73:	62 63 0d 50 25 25 8a 8e c7 fe e4 	vpternlogd $0xe4,-0x1387176(%rip){1to16},%zmm30,%zmm28        # 5b6c08 <tier0_emit_x87.operations+0x1b8>
 193dd7e:	62 f1 25 40 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm27
 193dd85:	62 f2 7d 48 5a 0d 31 ec c6 fe 	vbroadcasti32x4 -0x13913cf(%rip),%zmm1        # 5ac9c0 <x86_effects_unknown+0x9f0>
 193dd8f:	62 32 a5 49 64 ea    	vpblendmq %zmm18,%zmm11,%zmm13{%k1}
 193dd95:	62 a2 8d 49 64 c4    	vpblendmq %zmm20,%zmm14,%zmm16{%k1}
 193dd9b:	62 21 15 48 6a c8    	vpunpckhdq %zmm16,%zmm13,%zmm25
 193dda1:	62 01 bd 40 6d d1    	vpunpckhqdq %zmm25,%zmm24,%zmm26
 193dda7:	62 62 15 40 36 0d 0f a7 c0 fe 	vpermd -0x13f58f1(%rip),%zmm29,%zmm25        # 5484c0 <branch_sizing_patterns+0x2830>
 193ddb1:	62 62 15 40 36 05 45 a7 c0 fe 	vpermd -0x13f58bb(%rip),%zmm29,%zmm24        # 548500 <branch_sizing_patterns+0x2870>
 193ddbb:	62 62 75 48 00 f2    	vpshufb %zmm2,%zmm1,%zmm30
 193ddc1:	62 f2 7d 48 58 0d 45 8e c7 fe 	vpbroadcastd -0x13871bb(%rip),%zmm1        # 5b6c10 <tier0_emit_x87.operations+0x1c0>
 193ddcb:	62 62 15 40 36 2d 6b a7 c0 fe 	vpermd -0x13f5895(%rip),%zmm29,%zmm29        # 548540 <branch_sizing_patterns+0x28b0>
 193ddd5:	62 91 7d 48 72 f6 10 	vpslld $0x10,%zmm30,%zmm0
 193dddc:	62 01 25 40 db f6    	vpandd %zmm30,%zmm27,%zmm30
 193dde2:	62 f1 05 40 72 e0 1f 	vpsrad $0x1f,%zmm0,%zmm31
 193dde9:	62 b1 7d 48 72 e7 1f 	vpsrad $0x1f,%zmm23,%zmm0
 193ddf0:	62 03 1d 40 25 c1 f8 	vpternlogd $0xf8,%zmm25,%zmm28,%zmm24
 193ddf7:	62 62 7e 48 38 c8    	vpmovm2d %k0,%zmm25
 193ddfd:	62 03 25 40 25 cf c8 	vpternlogd $0xc8,%zmm31,%zmm27,%zmm25
 193de04:	62 21 7d 48 ef ff    	vpxord %zmm23,%zmm0,%zmm31
 193de0a:	62 f2 7d 48 58 05 f8 8d c7 fe 	vpbroadcastd -0x1387208(%rip),%zmm0        # 5b6c0c <tier0_emit_x87.operations+0x1bc>
 193de14:	62 63 15 50 25 35 25 8e c7 fe ec 	vpternlogd $0xec,-0x13871db(%rip){1to16},%zmm29,%zmm30        # 5b6c44 <tier0_emit_x87.operations+0x1f4>
 193de1f:	62 91 15 40 72 d2 1d 	vpsrld $0x1d,%zmm26,%zmm29
 193de26:	62 02 7d 48 44 ff    	vplzcntd %zmm31,%zmm31
 193de2c:	62 63 2d 50 25 35 11 8e c7 fe f8 	vpternlogd $0xf8,-0x13871ef(%rip){1to16},%zmm26,%zmm30        # 5b6c48 <tier0_emit_x87.operations+0x1f8>
 193de37:	62 02 75 48 45 ff    	vpsrlvd %zmm31,%zmm1,%zmm31
 193de3d:	62 d1 45 40 fe cc    	vpaddd %zmm12,%zmm23,%zmm1
 193de43:	62 93 45 40 25 cf 14 	vpternlogd $0x14,%zmm31,%zmm23,%zmm1
 193de4a:	62 f1 05 40 72 d2 08 	vpsrld $0x8,%zmm2,%zmm31
 193de51:	62 92 75 48 14 cd    	vprorvd %zmm29,%zmm1,%zmm1
 193de57:	62 f1 75 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm1
 193de5e:	62 e3 7d 58 25 1d b3 8d c7 fe 6c 	vpternlogd $0x6c,-0x138724d(%rip){1to16},%zmm0,%zmm19        # 5b6c1c <tier0_emit_x87.operations+0x1cc>
 193de69:	62 63 7d 58 25 3d ac 8d c7 fe 6c 	vpternlogd $0x6c,-0x1387254(%rip){1to16},%zmm0,%zmm31        # 5b6c20 <tier0_emit_x87.operations+0x1d0>
 193de74:	62 f1 1d 50 db 05 b2 8d c7 fe 	vpandd -0x138724e(%rip){1to16},%zmm28,%zmm0        # 5b6c30 <tier0_emit_x87.operations+0x1e0>
 193de7e:	62 91 1d 40 72 d4 03 	vpsrld $0x3,%zmm28,%zmm28
 193de85:	62 63 2d 50 25 25 ac 8d c7 fe a2 	vpternlogd $0xa2,-0x1387254(%rip){1to16},%zmm26,%zmm28        # 5b6c3c <tier0_emit_x87.operations+0x1ec>
 193de90:	62 c1 65 40 fe dc    	vpaddd %zmm12,%zmm19,%zmm19
 193de96:	62 e3 35 58 25 1d 83 8d c7 fe ec 	vpternlogd $0xec,-0x138727d(%rip){1to16},%zmm9,%zmm19        # 5b6c24 <tier0_emit_x87.operations+0x1d4>
 193dea1:	62 41 05 40 fe fc    	vpaddd %zmm12,%zmm31,%zmm31
 193dea7:	62 63 65 50 25 3d 7a 8d c7 fe ec 	vpternlogd $0xec,-0x1387286(%rip){1to16},%zmm19,%zmm31        # 5b6c2c <tier0_emit_x87.operations+0x1dc>
 193deb2:	62 93 2d 40 25 c7 f8 	vpternlogd $0xf8,%zmm31,%zmm26,%zmm0
 193deb9:	62 e2 7d 58 3b 1d 71 8d c7 fe 	vpminud -0x138728f(%rip){1to16},%zmm0,%zmm19        # 5b6c34 <tier0_emit_x87.operations+0x1e4>
 193dec3:	62 f2 1d 50 3b 05 73 8d c7 fe 	vpminud -0x138728d(%rip){1to16},%zmm28,%zmm0        # 5b6c40 <tier0_emit_x87.operations+0x1f0>
 193decd:	62 01 fd 48 6f d0    	vmovdqa64 %zmm24,%zmm26
 193ded3:	62 63 35 50 25 15 36 8d c7 fe f8 	vpternlogd $0xf8,-0x13872ca(%rip){1to16},%zmm25,%zmm26        # 5b6c14 <tier0_emit_x87.operations+0x1c4>
 193dede:	62 61 35 50 db 3d 64 8d c7 fe 	vpandd -0x138729c(%rip){1to16},%zmm25,%zmm31        # 5b6c4c <tier0_emit_x87.operations+0x1fc>
 193dee8:	62 23 7d 48 25 f3 fe 	vpternlogd $0xfe,%zmm19,%zmm0,%zmm30
 193deef:	62 81 fd 48 6f d8    	vmovdqa64 %zmm24,%zmm19
 193def5:	62 e3 25 50 25 1d 18 8d c7 fe f8 	vpternlogd $0xf8,-0x13872e8(%rip){1to16},%zmm27,%zmm19        # 5b6c18 <tier0_emit_x87.operations+0x1c8>
 193df00:	62 b1 7d 48 72 cf 01 	vprold $0x1,%zmm23,%zmm0
 193df07:	62 61 25 50 db 1d 3f 8d c7 fe 	vpandd -0x13872c1(%rip){1to16},%zmm27,%zmm27        # 5b6c50 <tier0_emit_x87.operations+0x200>
 193df11:	62 83 75 48 25 da b8 	vpternlogd $0xb8,%zmm26,%zmm1,%zmm19
 193df18:	62 02 7d 48 14 d5    	vprorvd %zmm29,%zmm0,%zmm26
 193df1e:	62 f1 fd 48 6f 05 58 a5 c0 fe 	vmovdqa64 -0x13f5aa8(%rip),%zmm0        # 548480 <branch_sizing_patterns+0x27f0>
 193df28:	62 03 75 48 25 df b8 	vpternlogd $0xb8,%zmm31,%zmm1,%zmm27
 193df2f:	62 23 35 40 25 d7 e2 	vpternlogd $0xe2,%zmm23,%zmm25,%zmm26
 193df36:	62 23 75 48 25 d7 e2 	vpternlogd $0xe2,%zmm23,%zmm1,%zmm26
 193df3d:	62 f1 cd 48 6c cf    	vpunpcklqdq %zmm7,%zmm6,%zmm1
 193df43:	62 d1 1d 40 fe fc    	vpaddd %zmm12,%zmm28,%zmm7
 193df49:	62 b1 d5 40 6d f6    	vpunpckhqdq %zmm22,%zmm21,%zmm6
 193df4f:	62 f1 45 48 72 e7 1f 	vpsrad $0x1f,%zmm7,%zmm7
 193df56:	62 f1 4d 48 eb d2    	vpord  %zmm2,%zmm6,%zmm2
 193df5c:	62 f1 6d 48 72 f2 07 	vpslld $0x7,%zmm2,%zmm2
 193df63:	62 d2 fd 48 7e e7    	vpermt2q %zmm15,%zmm0,%zmm4
 193df69:	62 32 fd 48 7e c1    	vpermt2q %zmm17,%zmm0,%zmm8
 193df6f:	62 32 fd 48 7e da    	vpermt2q %zmm18,%zmm0,%zmm11
 193df75:	62 32 fd 48 7e f4    	vpermt2q %zmm20,%zmm0,%zmm14
 193df7b:	62 91 7d 48 72 d0 10 	vpsrld $0x10,%zmm24,%zmm0
 193df82:	62 91 05 48 72 d0 03 	vpsrld $0x3,%zmm24,%zmm15
 193df89:	62 73 7d 58 25 3d a4 8c c7 fe ec 	vpternlogd $0xec,-0x138735c(%rip){1to16},%zmm0,%zmm15        # 5b6c38 <tier0_emit_x87.operations+0x1e8>
 193df94:	62 f2 7d 48 5a 05 32 ea c6 fe 	vbroadcasti32x4 -0x13915ce(%rip),%zmm0        # 5ac9d0 <x86_effects_unknown+0xa00>
 193df9e:	62 d1 75 40 72 f7 08 	vpslld $0x8,%zmm15,%zmm17
 193dfa5:	62 e3 45 58 25 0d a4 8c c7 fe 08 	vpternlogd $0x8,-0x138735c(%rip){1to16},%zmm7,%zmm17        # 5b6c54 <tier0_emit_x87.operations+0x204>
 193dfb0:	62 f2 fd 48 83 f6    	vpmultishiftqb %zmm6,%zmm0,%zmm6
 193dfb6:	62 f3 05 58 25 35 9b 8c c7 fe d8 	vpternlogd $0xd8,-0x1387365(%rip){1to16},%zmm15,%zmm6        # 5b6c5c <tier0_emit_x87.operations+0x20c>
 193dfc1:	62 91 25 40 eb fe    	vpord  %zmm30,%zmm27,%zmm7
 193dfc7:	62 f1 7d 48 70 c7 00 	vpshufd $0x0,%zmm7,%zmm0
 193dfce:	62 f2 7d 48 8f dc    	vpshufbitqmb %zmm4,%zmm0,%k3
 193dfd4:	62 f1 7d 48 70 c7 55 	vpshufd $0x55,%zmm7,%zmm0
 193dfdb:	62 d2 7d 48 8f d0    	vpshufbitqmb %zmm8,%zmm0,%k2
 193dfe1:	62 f1 7d 48 70 c7 aa 	vpshufd $0xaa,%zmm7,%zmm0
 193dfe8:	c4 61 fb 93 cb       	kmovq  %k3,%r9
 193dfed:	f3 4d 0f b8 c9       	popcnt %r9,%r9
 193dff2:	c4 61 fb 93 d2       	kmovq  %k2,%r10
 193dff7:	f3 4d 0f b8 d2       	popcnt %r10,%r10
 193dffc:	62 f3 75 50 25 15 51 8c c7 fe e4 	vpternlogd $0xe4,-0x13873af(%rip){1to16},%zmm17,%zmm2        # 5b6c58 <tier0_emit_x87.operations+0x208>
 193e007:	62 f3 6d 58 25 35 4e 8c c7 fe d8 	vpternlogd $0xd8,-0x13873b2(%rip){1to16},%zmm2,%zmm6        # 5b6c60 <tier0_emit_x87.operations+0x210>
 193e012:	62 91 75 48 62 d2    	vpunpckldq %zmm26,%zmm1,%zmm2
 193e018:	62 91 75 48 6a ca    	vpunpckhdq %zmm26,%zmm1,%zmm1
 193e01e:	62 71 65 40 62 fe    	vpunpckldq %zmm6,%zmm19,%zmm15
 193e024:	62 f1 65 40 6a f6    	vpunpckhdq %zmm6,%zmm19,%zmm6
 193e02a:	62 c1 ed 48 6c cf    	vpunpcklqdq %zmm15,%zmm2,%zmm17
 193e030:	62 d1 ed 48 6d d7    	vpunpckhqdq %zmm15,%zmm2,%zmm2
 193e036:	62 e1 f5 48 6c d6    	vpunpcklqdq %zmm6,%zmm1,%zmm18
 193e03c:	62 f1 f5 48 6d ce    	vpunpckhqdq %zmm6,%zmm1,%zmm1
 193e042:	62 f2 75 40 00 e4    	vpshufb %zmm4,%zmm17,%zmm4
 193e048:	62 d2 6d 48 00 d0    	vpshufb %zmm8,%zmm2,%zmm2
 193e04e:	62 d2 75 48 00 ce    	vpshufb %zmm14,%zmm1,%zmm1
 193e054:	62 f3 d5 48 25 e3 78 	vpternlogq $0x78,%zmm3,%zmm5,%zmm4
 193e05b:	62 f3 ad 48 25 d3 78 	vpternlogq $0x78,%zmm3,%zmm10,%zmm2
 193e062:	62 f3 fd 40 25 cb 78 	vpternlogq $0x78,%zmm3,%zmm16,%zmm1
 193e069:	62 f2 7d cb 63 e4    	vpcompressb %zmm4,%zmm4{%k3}{z}
 193e06f:	62 f2 7d ca 63 d2    	vpcompressb %zmm2,%zmm2{%k2}{z}
 193e075:	62 d2 7d 48 8f db    	vpshufbitqmb %zmm11,%zmm0,%k3
 193e07b:	62 f1 7d 48 70 c7 ff 	vpshufd $0xff,%zmm7,%zmm0
 193e082:	62 d2 7d 48 8f d6    	vpshufbitqmb %zmm14,%zmm0,%k2
 193e088:	c4 61 fb 93 db       	kmovq  %k3,%r11
 193e08d:	62 f2 7d ca 63 c9    	vpcompressb %zmm1,%zmm1{%k2}{z}
 193e093:	62 d1 fe 48 7f 26    	vmovdqu64 %zmm4,(%r14)
 193e099:	62 d2 6d 40 00 e3    	vpshufb %zmm11,%zmm18,%zmm4
 193e09f:	62 91 fe 48 7f 14 0e 	vmovdqu64 %zmm2,(%r14,%r9,1)
 193e0a6:	4d 01 f1             	add    %r14,%r9
 193e0a9:	62 f3 95 48 25 e3 78 	vpternlogq $0x78,%zmm3,%zmm13,%zmm4
 193e0b0:	c5 e9 ef d2          	vpxor  %xmm2,%xmm2,%xmm2
 193e0b4:	62 f2 7d cb 63 e2    	vpcompressb %zmm4,%zmm2{%k3}{z}
 193e0ba:	62 91 fe 48 7f 14 0a 	vmovdqu64 %zmm2,(%r10,%r9,1)
 193e0c1:	4d 01 d1             	add    %r10,%r9
 193e0c4:	f3 4d 0f b8 d3       	popcnt %r11,%r10
 193e0c9:	c4 61 fb 93 da       	kmovq  %k2,%r11
 193e0ce:	f3 4d 0f b8 f3       	popcnt %r11,%r14
 193e0d3:	62 91 fe 48 7f 0c 0a 	vmovdqu64 %zmm1,(%r10,%r9,1)
 193e0da:	4d 01 d6             	add    %r10,%r14
 193e0dd:	4d 01 ce             	add    %r9,%r14
 193e0e0:	48 ff c9             	dec    %rcx
 193e0e3:	0f 85 a7 fa ff ff    	jne    193db90 <x86_encode_16+0x1950>
 193e0e9:	48 29 c2             	sub    %rax,%rdx
 193e0ec:	0f 86 e6 05 00 00    	jbe    193e6d8 <x86_encode_16+0x2498>
 193e0f2:	48 c1 e0 04          	shl    $0x4,%rax
 193e0f6:	48 c1 e2 04          	shl    $0x4,%rdx
 193e0fa:	48 8d 7c 24 40       	lea    0x40(%rsp),%rdi
 193e0ff:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 193e103:	62 f1 fd 48 7f 44 24 04 	vmovdqa64 %zmm0,0x100(%rsp)
 193e10b:	62 f1 fd 48 7f 44 24 03 	vmovdqa64 %zmm0,0xc0(%rsp)
 193e113:	62 f1 fd 48 7f 44 24 02 	vmovdqa64 %zmm0,0x80(%rsp)
 193e11b:	62 f1 fd 48 7f 44 24 01 	vmovdqa64 %zmm0,0x40(%rsp)
 193e123:	48 01 c6             	add    %rax,%rsi
 193e126:	c5 f8 77             	vzeroupper
 193e129:	e8 72 be e5 fe       	call   799fa0 <memcpy@plt>
 193e12e:	c5 f9 6f 64 24 70    	vmovdqa 0x70(%rsp),%xmm4
 193e134:	c5 f9 6f 4c 24 40    	vmovdqa 0x40(%rsp),%xmm1
 193e13a:	c5 f9 6f 54 24 50    	vmovdqa 0x50(%rsp),%xmm2
 193e140:	c5 f9 6f 5c 24 60    	vmovdqa 0x60(%rsp),%xmm3
 193e146:	c5 f9 6f ac 24 80 00 00 00 	vmovdqa 0x80(%rsp),%xmm5
 193e14f:	48 8d 05 ea e2 31 0d 	lea    0xd31e2ea(%rip),%rax        # ec5c440 <x86_template_storage>
 193e156:	62 71 fd 48 6f 3d 20 a3 c0 fe 	vmovdqa64 -0x13f5ce0(%rip),%zmm15        # 548480 <branch_sizing_patterns+0x27f0>
 193e160:	c5 f9 6f bc 24 c0 00 00 00 	vmovdqa 0xc0(%rsp),%xmm7
 193e169:	c5 f9 6f b4 24 d0 00 00 00 	vmovdqa 0xd0(%rsp),%xmm6
 193e172:	62 71 fd 48 6f 4c 24 01 	vmovdqa64 0x40(%rsp),%zmm9
 193e17a:	62 71 fd 48 6f 54 24 02 	vmovdqa64 0x80(%rsp),%zmm10
 193e182:	62 71 fd 48 6f 5c 24 03 	vmovdqa64 0xc0(%rsp),%zmm11
 193e18a:	62 71 fd 48 6f 64 24 04 	vmovdqa64 0x100(%rsp),%zmm12
 193e192:	62 e2 7d 48 5a 0d 04 e8 c6 fe 	vbroadcasti32x4 -0x13917fc(%rip),%zmm17        # 5ac9a0 <x86_effects_unknown+0x9d0>
 193e19c:	62 a3 4d 40 25 f6 ff 	vpternlogd $0xff,%zmm22,%zmm22,%zmm22
 193e1a3:	62 e2 7d 48 58 25 5f 8a c7 fe 	vpbroadcastd -0x13875a1(%rip),%zmm20        # 5b6c0c <tier0_emit_x87.operations+0x1bc>
 193e1ad:	62 62 7d 48 58 15 61 8a c7 fe 	vpbroadcastd -0x138759f(%rip),%zmm26        # 5b6c18 <tier0_emit_x87.operations+0x1c8>
 193e1b7:	62 62 7d 48 58 0d 5b 8a c7 fe 	vpbroadcastd -0x13875a5(%rip),%zmm25        # 5b6c1c <tier0_emit_x87.operations+0x1cc>
 193e1c1:	c5 f9 c5 fc 06       	vpextrw $0x6,%xmm4,%edi
 193e1c6:	c5 f9 6f a4 24 90 00 00 00 	vmovdqa 0x90(%rsp),%xmm4
 193e1cf:	c5 f9 c5 c9 06       	vpextrw $0x6,%xmm1,%ecx
 193e1d4:	c5 f9 c5 d2 06       	vpextrw $0x6,%xmm2,%edx
 193e1d9:	c5 f9 c5 f3 06       	vpextrw $0x6,%xmm3,%esi
 193e1de:	62 51 35 48 62 ea    	vpunpckldq %zmm10,%zmm9,%zmm13
 193e1e4:	62 51 25 48 62 f4    	vpunpckldq %zmm12,%zmm11,%zmm14
 193e1ea:	62 51 35 48 6a d2    	vpunpckhdq %zmm10,%zmm9,%zmm10
 193e1f0:	62 51 25 48 6a e4    	vpunpckhdq %zmm12,%zmm11,%zmm12
 193e1f6:	c1 e1 06             	shl    $0x6,%ecx
 193e1f9:	c1 e2 06             	shl    $0x6,%edx
 193e1fc:	c1 e6 06             	shl    $0x6,%esi
 193e1ff:	c1 e7 06             	shl    $0x6,%edi
 193e202:	62 51 ad 48 6c dc    	vpunpcklqdq %zmm12,%zmm10,%zmm11
 193e208:	62 d1 95 48 6c c6    	vpunpcklqdq %zmm14,%zmm13,%zmm0
 193e20e:	62 51 95 48 6d ce    	vpunpckhqdq %zmm14,%zmm13,%zmm9
 193e214:	62 51 ad 48 6d e4    	vpunpckhqdq %zmm12,%zmm10,%zmm12
 193e21a:	c5 fd 6f 4c 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm1
 193e220:	b1 cc                	mov    $0xcc,%cl
 193e222:	c5 fd 6f 54 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm2
 193e228:	62 c2 f5 40 83 db    	vpmultishiftqb %zmm11,%zmm17,%zmm19
 193e22e:	62 d2 35 48 27 c1    	vptestmd %zmm9,%zmm9,%k0
 193e234:	62 d1 75 40 72 e1 1f 	vpsrad $0x1f,%zmm9,%zmm17
 193e23b:	62 21 35 48 fe c6    	vpaddd %zmm22,%zmm9,%zmm24
 193e241:	62 43 5d 40 25 cb 6c 	vpternlogd $0x6c,%zmm11,%zmm20,%zmm25
 193e248:	c5 fb 92 c9          	kmovd  %ecx,%k1
 193e24c:	c5 f9 c5 cd 06       	vpextrw $0x6,%xmm5,%ecx
 193e251:	c5 f9 6f ac 24 a0 00 00 00 	vmovdqa 0xa0(%rsp),%xmm5
 193e25a:	62 f3 f5 48 3a 4c 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm1,%zmm1
 193e263:	62 f3 ed 48 3a 5c 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm2,%zmm3
 193e26c:	c1 e1 06             	shl    $0x6,%ecx
 193e26f:	c5 f9 c5 d4 06       	vpextrw $0x6,%xmm4,%edx
 193e274:	c5 f9 6f a4 24 b0 00 00 00 	vmovdqa 0xb0(%rsp),%xmm4
 193e27d:	c1 e2 06             	shl    $0x6,%edx
 193e280:	c5 f9 c5 f5 06       	vpextrw $0x6,%xmm5,%esi
 193e285:	62 f2 f5 49 64 d3    	vpblendmq %zmm3,%zmm1,%zmm2{%k1}
 193e28b:	62 f2 85 48 7e cb    	vpermt2q %zmm3,%zmm15,%zmm1
 193e291:	c5 fd 6f 5c 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm3
 193e297:	c5 f9 c5 cf 06       	vpextrw $0x6,%xmm7,%ecx
 193e29c:	c5 f9 6f bc 24 e0 00 00 00 	vmovdqa 0xe0(%rsp),%xmm7
 193e2a5:	c1 e6 06             	shl    $0x6,%esi
 193e2a8:	c1 e1 06             	shl    $0x6,%ecx
 193e2ab:	62 f3 e5 48 3a 5c 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm3,%zmm3
 193e2b4:	c5 f9 c5 fc 06       	vpextrw $0x6,%xmm4,%edi
 193e2b9:	c5 fd 6f 64 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm4
 193e2bf:	c5 f9 c5 d6 06       	vpextrw $0x6,%xmm6,%edx
 193e2c4:	c5 f9 6f b4 24 f0 00 00 00 	vmovdqa 0xf0(%rsp),%xmm6
 193e2cd:	c1 e7 06             	shl    $0x6,%edi
 193e2d0:	c1 e2 06             	shl    $0x6,%edx
 193e2d3:	62 f3 dd 48 3a 6c 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm4,%zmm5
 193e2dc:	c5 f9 c5 f7 06       	vpextrw $0x6,%xmm7,%esi
 193e2e1:	c1 e6 06             	shl    $0x6,%esi
 193e2e4:	c5 f9 c5 fe 06       	vpextrw $0x6,%xmm6,%edi
 193e2e9:	c5 fd 6f 74 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm6
 193e2ef:	0f b7 94 24 1c 01 00 00 	movzwl 0x11c(%rsp),%edx
 193e2f7:	c1 e7 06             	shl    $0x6,%edi
 193e2fa:	62 f2 e5 49 64 e5    	vpblendmq %zmm5,%zmm3,%zmm4{%k1}
 193e300:	62 f2 85 48 7e dd    	vpermt2q %zmm5,%zmm15,%zmm3
 193e306:	c5 fd 6f 6c 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm5
 193e30c:	62 f3 cd 48 3a 7c 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm6,%zmm7
 193e315:	0f b7 8c 24 0c 01 00 00 	movzwl 0x10c(%rsp),%ecx
 193e31d:	0f b7 bc 24 3c 01 00 00 	movzwl 0x13c(%rsp),%edi
 193e325:	62 f3 d5 48 3a 6c 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm5,%zmm5
 193e32e:	0f b7 b4 24 2c 01 00 00 	movzwl 0x12c(%rsp),%esi
 193e336:	62 71 6d 48 6a d4    	vpunpckhdq %zmm4,%zmm2,%zmm10
 193e33c:	c1 e2 06             	shl    $0x6,%edx
 193e33f:	c5 7d 6f 44 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm8
 193e345:	c1 e1 06             	shl    $0x6,%ecx
 193e348:	c1 e7 06             	shl    $0x6,%edi
 193e34b:	c1 e6 06             	shl    $0x6,%esi
 193e34e:	62 e3 bd 48 3a 44 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm8,%zmm16
 193e357:	62 f2 d5 49 64 f7    	vpblendmq %zmm7,%zmm5,%zmm6{%k1}
 193e35d:	62 f2 85 48 7e ef    	vpermt2q %zmm7,%zmm15,%zmm5
 193e363:	c5 fd 6f 7c 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm7
 193e369:	62 f3 c5 48 3a 7c 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm7,%zmm7
 193e372:	62 32 c5 49 64 c0    	vpblendmq %zmm16,%zmm7,%zmm8{%k1}
 193e378:	62 b2 85 48 7e f8    	vpermt2q %zmm16,%zmm15,%zmm7
 193e37e:	62 e2 7d 48 5a 05 08 e6 c6 fe 	vbroadcasti32x4 -0x13919f8(%rip),%zmm16        # 5ac990 <x86_effects_unknown+0x9c0>
 193e388:	62 51 4d 48 6a e8    	vpunpckhdq %zmm8,%zmm6,%zmm13
 193e38e:	62 51 ad 48 6d d5    	vpunpckhqdq %zmm13,%zmm10,%zmm10
 193e394:	62 d1 15 48 72 d3 1a 	vpsrld $0x1a,%zmm11,%zmm13
 193e39b:	62 72 15 48 36 35 1b a1 c0 fe 	vpermd -0x13f5ee5(%rip),%zmm13,%zmm14        # 5484c0 <branch_sizing_patterns+0x2830>
 193e3a5:	62 e2 15 48 36 15 51 a1 c0 fe 	vpermd -0x13f5eaf(%rip),%zmm13,%zmm18        # 548500 <branch_sizing_patterns+0x2870>
 193e3af:	62 72 15 48 36 2d 87 a1 c0 fe 	vpermd -0x13f5e79(%rip),%zmm13,%zmm13        # 548540 <branch_sizing_patterns+0x28b0>
 193e3b9:	62 d1 45 40 72 d2 1d 	vpsrld $0x1d,%zmm10,%zmm23
 193e3c0:	62 52 fd 40 83 fb    	vpmultishiftqb %zmm11,%zmm16,%zmm15
 193e3c6:	62 e2 7d 48 5a 05 e0 e5 c6 fe 	vbroadcasti32x4 -0x1391a20(%rip),%zmm16        # 5ac9b0 <x86_effects_unknown+0x9e0>
 193e3d0:	62 c2 fd 40 83 c3    	vpmultishiftqb %zmm11,%zmm16,%zmm16
 193e3d6:	62 e3 05 58 25 05 23 88 c7 fe d8 	vpternlogd $0xd8,-0x13877dd(%rip){1to16},%zmm15,%zmm16        # 5b6c04 <tier0_emit_x87.operations+0x1b4>
 193e3e1:	62 d1 05 48 72 f3 04 	vpslld $0x4,%zmm11,%zmm15
 193e3e8:	62 d1 05 48 72 e7 1f 	vpsrad $0x1f,%zmm15,%zmm15
 193e3ef:	62 e3 7d 50 25 1d 0e 88 c7 fe e4 	vpternlogd $0xe4,-0x13877f2(%rip){1to16},%zmm16,%zmm19        # 5b6c08 <tier0_emit_x87.operations+0x1b8>
 193e3fa:	62 e2 7d 48 5a 05 bc e5 c6 fe 	vbroadcasti32x4 -0x1391a44(%rip),%zmm16        # 5ac9c0 <x86_effects_unknown+0x9f0>
 193e404:	62 c2 7d 40 00 eb    	vpshufb %zmm11,%zmm16,%zmm21
 193e40a:	62 c3 65 40 25 d6 f8 	vpternlogd $0xf8,%zmm14,%zmm19,%zmm18
 193e411:	62 23 05 48 25 d2 ea 	vpternlogd $0xea,%zmm18,%zmm15,%zmm26
 193e418:	62 b1 0d 48 72 f5 10 	vpslld $0x10,%zmm21,%zmm14
 193e41f:	62 d1 7d 40 72 e6 1f 	vpsrad $0x1f,%zmm14,%zmm16
 193e426:	62 72 7e 48 38 f0    	vpmovm2d %k0,%zmm14
 193e42c:	62 33 05 48 25 f0 c8 	vpternlogd $0xc8,%zmm16,%zmm15,%zmm14
 193e433:	62 c1 75 40 ef c1    	vpxord %zmm9,%zmm17,%zmm16
 193e439:	62 e2 7d 48 58 0d cd 87 c7 fe 	vpbroadcastd -0x1387833(%rip),%zmm17        # 5b6c10 <tier0_emit_x87.operations+0x1c0>
 193e443:	62 a2 7d 48 44 c0    	vplzcntd %zmm16,%zmm16
 193e449:	62 a2 75 40 45 c0    	vpsrlvd %zmm16,%zmm17,%zmm16
 193e44f:	62 23 35 48 25 c0 14 	vpternlogd $0x14,%zmm16,%zmm9,%zmm24
 193e456:	62 a2 3d 40 14 c7    	vprorvd %zmm23,%zmm24,%zmm16
 193e45c:	62 62 7d 48 58 05 ae 87 c7 fe 	vpbroadcastd -0x1387852(%rip),%zmm24        # 5b6c14 <tier0_emit_x87.operations+0x1c4>
 193e466:	62 b1 7d 40 72 e0 1f 	vpsrad $0x1f,%zmm16,%zmm16
 193e46d:	62 23 0d 48 25 c2 ea 	vpternlogd $0xea,%zmm18,%zmm14,%zmm24
 193e474:	62 03 7d 40 25 d0 b8 	vpternlogd $0xb8,%zmm24,%zmm16,%zmm26
 193e47b:	62 21 35 40 fe c6    	vpaddd %zmm22,%zmm25,%zmm24
 193e481:	62 d1 35 40 72 d3 08 	vpsrld $0x8,%zmm11,%zmm25
 193e488:	62 63 5d 50 25 0d 8d 87 c7 fe 6c 	vpternlogd $0x6c,-0x1387873(%rip){1to16},%zmm20,%zmm25        # 5b6c20 <tier0_emit_x87.operations+0x1d0>
 193e493:	62 51 1d 48 eb db    	vpord  %zmm11,%zmm12,%zmm11
 193e499:	62 d1 25 48 72 f3 07 	vpslld $0x7,%zmm11,%zmm11
 193e4a0:	62 a1 35 40 fe e6    	vpaddd %zmm22,%zmm25,%zmm20
 193e4a6:	62 62 7d 48 58 0d 74 87 c7 fe 	vpbroadcastd -0x138788c(%rip),%zmm25        # 5b6c24 <tier0_emit_x87.operations+0x1d4>
 193e4b0:	62 63 3d 50 25 0d 6d 87 c7 fe ea 	vpternlogd $0xea,-0x1387893(%rip){1to16},%zmm24,%zmm25        # 5b6c28 <tier0_emit_x87.operations+0x1d8>
 193e4bb:	62 61 65 50 db 05 6b 87 c7 fe 	vpandd -0x1387895(%rip){1to16},%zmm19,%zmm24        # 5b6c30 <tier0_emit_x87.operations+0x1e0>
 193e4c5:	62 b1 65 40 72 d3 03 	vpsrld $0x3,%zmm19,%zmm19
 193e4cc:	62 e3 2d 58 25 1d 65 87 c7 fe a2 	vpternlogd $0xa2,-0x138789b(%rip){1to16},%zmm10,%zmm19        # 5b6c3c <tier0_emit_x87.operations+0x1ec>
 193e4d7:	62 63 5d 50 25 0d 4a 87 c7 fe f8 	vpternlogd $0xf8,-0x13878b6(%rip){1to16},%zmm20,%zmm25        # 5b6c2c <tier0_emit_x87.operations+0x1dc>
 193e4e2:	62 a1 65 40 fe f6    	vpaddd %zmm22,%zmm19,%zmm22
 193e4e8:	62 e2 65 50 3b 1d 4e 87 c7 fe 	vpminud -0x13878b2(%rip){1to16},%zmm19,%zmm19        # 5b6c40 <tier0_emit_x87.operations+0x1f0>
 193e4f2:	62 03 2d 48 25 c1 f8 	vpternlogd $0xf8,%zmm25,%zmm10,%zmm24
 193e4f9:	62 e2 3d 50 3b 25 31 87 c7 fe 	vpminud -0x13878cf(%rip){1to16},%zmm24,%zmm20        # 5b6c34 <tier0_emit_x87.operations+0x1e4>
 193e503:	62 b1 3d 40 72 d2 10 	vpsrld $0x10,%zmm18,%zmm24
 193e50a:	62 b1 6d 40 72 d2 03 	vpsrld $0x3,%zmm18,%zmm18
 193e511:	62 b1 4d 40 72 e6 1f 	vpsrad $0x1f,%zmm22,%zmm22
 193e518:	62 e3 3d 50 25 15 15 87 c7 fe ec 	vpternlogd $0xec,-0x13878eb(%rip){1to16},%zmm24,%zmm18        # 5b6c38 <tier0_emit_x87.operations+0x1e8>
 193e523:	62 b1 3d 40 72 f2 08 	vpslld $0x8,%zmm18,%zmm24
 193e52a:	62 63 4d 50 25 05 1f 87 c7 fe 08 	vpternlogd $0x8,-0x13878e1(%rip){1to16},%zmm22,%zmm24        # 5b6c54 <tier0_emit_x87.operations+0x204>
 193e535:	62 e2 7d 48 5a 35 91 e4 c6 fe 	vbroadcasti32x4 -0x1391b6f(%rip),%zmm22        # 5ac9d0 <x86_effects_unknown+0xa00>
 193e53f:	62 73 3d 50 25 1d 0e 87 c7 fe e4 	vpternlogd $0xe4,-0x13878f2(%rip){1to16},%zmm24,%zmm11        # 5b6c58 <tier0_emit_x87.operations+0x208>
 193e54a:	62 c2 cd 40 83 f4    	vpmultishiftqb %zmm12,%zmm22,%zmm22
 193e550:	62 31 05 48 db e5    	vpandd %zmm21,%zmm15,%zmm12
 193e556:	62 73 15 58 25 25 e3 86 c7 fe ec 	vpternlogd $0xec,-0x138791d(%rip){1to16},%zmm13,%zmm12        # 5b6c44 <tier0_emit_x87.operations+0x1f4>
 193e561:	62 e3 6d 50 25 35 f0 86 c7 fe d8 	vpternlogd $0xd8,-0x1387910(%rip){1to16},%zmm18,%zmm22        # 5b6c5c <tier0_emit_x87.operations+0x20c>
 193e56c:	62 71 05 58 db 2d da 86 c7 fe 	vpandd -0x1387926(%rip){1to16},%zmm15,%zmm13        # 5b6c50 <tier0_emit_x87.operations+0x200>
 193e576:	62 73 2d 58 25 25 c7 86 c7 fe f8 	vpternlogd $0xf8,-0x1387939(%rip){1to16},%zmm10,%zmm12        # 5b6c48 <tier0_emit_x87.operations+0x1f8>
 193e581:	62 71 0d 58 db 15 c1 86 c7 fe 	vpandd -0x138793f(%rip){1to16},%zmm14,%zmm10        # 5b6c4c <tier0_emit_x87.operations+0x1fc>
 193e58b:	62 e3 25 58 25 35 ca 86 c7 fe d8 	vpternlogd $0xd8,-0x1387936(%rip){1to16},%zmm11,%zmm22        # 5b6c60 <tier0_emit_x87.operations+0x210>
 193e596:	62 d1 25 48 72 c9 01 	vprold $0x1,%zmm9,%zmm11
 193e59d:	62 33 65 40 25 e4 fe 	vpternlogd $0xfe,%zmm20,%zmm19,%zmm12
 193e5a4:	62 53 7d 40 25 ea b8 	vpternlogd $0xb8,%zmm10,%zmm16,%zmm13
 193e5ab:	62 32 25 48 14 df    	vprorvd %zmm23,%zmm11,%zmm11
 193e5b1:	62 51 15 48 eb d4    	vpord  %zmm12,%zmm13,%zmm10
 193e5b7:	62 51 7d 48 70 fa 00 	vpshufd $0x0,%zmm10,%zmm15
 193e5be:	62 53 0d 48 25 d9 e2 	vpternlogd $0xe2,%zmm9,%zmm14,%zmm11
 193e5c5:	62 72 7d 48 5a 35 81 e3 c6 fe 	vbroadcasti32x4 -0x1391c7f(%rip),%zmm14        # 5ac950 <x86_effects_unknown+0x980>
 193e5cf:	62 f2 05 48 8f c9    	vpshufbitqmb %zmm1,%zmm15,%k1
 193e5d5:	62 53 7d 40 25 d9 e2 	vpternlogd $0xe2,%zmm9,%zmm16,%zmm11
 193e5dc:	62 51 7d 48 62 cb    	vpunpckldq %zmm11,%zmm0,%zmm9
 193e5e2:	62 d1 7d 48 6a c3    	vpunpckhdq %zmm11,%zmm0,%zmm0
 193e5e8:	c4 e1 fb 93 c1       	kmovq  %k1,%rax
 193e5ed:	62 31 2d 40 62 de    	vpunpckldq %zmm22,%zmm26,%zmm11
 193e5f3:	62 31 2d 40 6a e6    	vpunpckhdq %zmm22,%zmm26,%zmm12
 193e5f9:	f3 48 0f b8 c0       	popcnt %rax,%rax
 193e5fe:	62 51 b5 48 6c eb    	vpunpcklqdq %zmm11,%zmm9,%zmm13
 193e604:	62 c1 fd 48 6c c4    	vpunpcklqdq %zmm12,%zmm0,%zmm16
 193e60a:	62 d1 fd 48 6d c4    	vpunpckhqdq %zmm12,%zmm0,%zmm0
 193e610:	62 51 b5 48 6d cb    	vpunpckhqdq %zmm11,%zmm9,%zmm9
 193e616:	62 51 7d 48 70 e2 55 	vpshufd $0x55,%zmm10,%zmm12
 193e61d:	49 8d 0c 06          	lea    (%r14,%rax,1),%rcx
 193e621:	62 72 15 48 00 e9    	vpshufb %zmm1,%zmm13,%zmm13
 193e627:	62 f2 7d 48 00 c7    	vpshufb %zmm7,%zmm0,%zmm0
 193e62d:	62 53 ed 48 25 ee 78 	vpternlogq $0x78,%zmm14,%zmm2,%zmm13
 193e634:	62 f2 35 48 00 d3    	vpshufb %zmm3,%zmm9,%zmm2
 193e63a:	62 d3 bd 48 25 c6 78 	vpternlogq $0x78,%zmm14,%zmm8,%zmm0
 193e641:	62 72 7d c9 63 e9    	vpcompressb %zmm13,%zmm1{%k1}{z}
 193e647:	62 f2 1d 48 8f cb    	vpshufbitqmb %zmm3,%zmm12,%k1
 193e64d:	62 d1 7d 48 70 da aa 	vpshufd $0xaa,%zmm10,%zmm3
 193e654:	62 d3 dd 48 25 d6 78 	vpternlogq $0x78,%zmm14,%zmm4,%zmm2
 193e65b:	c4 e1 fb 93 d1       	kmovq  %k1,%rdx
 193e660:	f3 48 0f b8 d2       	popcnt %rdx,%rdx
 193e665:	62 d1 fe 48 7f 0e    	vmovdqu64 %zmm1,(%r14)
 193e66b:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
 193e66f:	62 f2 7d c9 63 d1    	vpcompressb %zmm2,%zmm1{%k1}{z}
 193e675:	62 f2 7d 40 00 d5    	vpshufb %zmm5,%zmm16,%zmm2
 193e67b:	62 f2 65 48 8f cd    	vpshufbitqmb %zmm5,%zmm3,%k1
 193e681:	62 d3 cd 48 25 d6 78 	vpternlogq $0x78,%zmm14,%zmm6,%zmm2
 193e688:	c4 e1 fb 93 f1       	kmovq  %k1,%rsi
 193e68d:	f3 48 0f b8 f6       	popcnt %rsi,%rsi
 193e692:	62 d1 fe 48 7f 0c 06 	vmovdqu64 %zmm1,(%r14,%rax,1)
 193e699:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
 193e69d:	62 f2 7d c9 63 d1    	vpcompressb %zmm2,%zmm1{%k1}{z}
 193e6a3:	62 d1 7d 48 70 d2 ff 	vpshufd $0xff,%zmm10,%zmm2
 193e6aa:	48 8d 04 11          	lea    (%rcx,%rdx,1),%rax
 193e6ae:	62 f2 6d 48 8f cf    	vpshufbitqmb %zmm7,%zmm2,%k1
 193e6b4:	62 f2 7d c9 63 c0    	vpcompressb %zmm0,%zmm0{%k1}{z}
 193e6ba:	62 f1 fe 48 7f 0c 0a 	vmovdqu64 %zmm1,(%rdx,%rcx,1)
 193e6c1:	c4 e1 fb 93 c9       	kmovq  %k1,%rcx
 193e6c6:	f3 4c 0f b8 f1       	popcnt %rcx,%r14
 193e6cb:	49 01 f6             	add    %rsi,%r14
 193e6ce:	49 01 c6             	add    %rax,%r14
 193e6d1:	62 f1 fe 48 7f 04 06 	vmovdqu64 %zmm0,(%rsi,%rax,1)
 193e6d8:	49 29 de             	sub    %rbx,%r14
 193e6db:	64 48 8b 04 25 28 00 00 00 	mov    %fs:0x28,%rax
 193e6e4:	48 3b 84 24 48 01 00 00 	cmp    0x148(%rsp),%rax
 193e6ec:	75 13                	jne    193e701 <x86_encode_16+0x24c1>
 193e6ee:	4c 89 f0             	mov    %r14,%rax
 193e6f1:	48 8d 65 e0          	lea    -0x20(%rbp),%rsp
 193e6f5:	5b                   	pop    %rbx
 193e6f6:	41 5c                	pop    %r12
 193e6f8:	41 5e                	pop    %r14
 193e6fa:	41 5f                	pop    %r15
 193e6fc:	5d                   	pop    %rbp
 193e6fd:	c5 f8 77             	vzeroupper
 193e700:	c3                   	ret
 193e701:	c5 f8 77             	vzeroupper
 193e704:	e8 27 af e5 fe       	call   799630 <__stack_chk_fail@plt>
