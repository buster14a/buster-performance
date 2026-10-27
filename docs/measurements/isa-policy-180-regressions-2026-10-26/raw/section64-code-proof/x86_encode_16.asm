
/home/david/buster-fast-bench/codex-180-fix-20261027-section64/build/compiler:     file format elf64-x86-64


Disassembly of section .text:

0000000000c1f940 <x86_encode_16>:
  c1f940:	55                   	push   %rbp
  c1f941:	48 89 e5             	mov    %rsp,%rbp
  c1f944:	41 57                	push   %r15
  c1f946:	41 56                	push   %r14
  c1f948:	41 54                	push   %r12
  c1f94a:	53                   	push   %rbx
  c1f94b:	48 83 e4 c0          	and    $0xffffffffffffffc0,%rsp
  c1f94f:	48 81 ec 80 01 00 00 	sub    $0x180,%rsp
  c1f956:	64 48 8b 04 25 28 00 00 00 	mov    %fs:0x28,%rax
  c1f95f:	48 89 d3             	mov    %rdx,%rbx
  c1f962:	48 89 f2             	mov    %rsi,%rdx
  c1f965:	48 89 fe             	mov    %rdi,%rsi
  c1f968:	48 89 84 24 48 01 00 00 	mov    %rax,0x148(%rsp)
  c1f970:	48 85 c9             	test   %rcx,%rcx
  c1f973:	74 10                	je     c1f985 <x86_encode_16+0x45>
  c1f975:	48 83 fa 10          	cmp    $0x10,%rdx
  c1f979:	73 1e                	jae    c1f999 <x86_encode_16+0x59>
  c1f97b:	31 c0                	xor    %eax,%eax
  c1f97d:	48 89 df             	mov    %rbx,%rdi
  c1f980:	e9 49 06 00 00       	jmp    c1ffce <x86_encode_16+0x68e>
  c1f985:	48 83 fa 10          	cmp    $0x10,%rdx
  c1f989:	0f 83 0c 13 00 00    	jae    c20c9b <x86_encode_16+0x135b>
  c1f98f:	31 c0                	xor    %eax,%eax
  c1f991:	49 89 de             	mov    %rbx,%r14
  c1f994:	e9 a0 18 00 00       	jmp    c21239 <x86_encode_16+0x18f9>
  c1f999:	62 f2 7d 48 5a 1d 3d 6a 95 ff 	vbroadcasti32x4 -0x6a95c3(%rip),%zmm3        # 5763e0 <x86_effects_unknown+0x980>
  c1f9a3:	62 72 7d 48 58 0d 73 0c 96 ff 	vpbroadcastd -0x69f38d(%rip),%zmm9        # 580620 <tier0_emit_x87.operations+0x1d8>
  c1f9ad:	4c 8d 42 f0          	lea    -0x10(%rdx),%r8
  c1f9b1:	40 b7 cc             	mov    $0xcc,%dil
  c1f9b4:	4c 8d 8e fc 00 00 00 	lea    0xfc(%rsi),%r9
  c1f9bb:	4c 8d 15 3e 6b a4 0d 	lea    0xda46b3e(%rip),%r10        # e666500 <x86_template_storage>
  c1f9c2:	62 53 1d 48 25 e4 ff 	vpternlogd $0xff,%zmm12,%zmm12,%zmm12
  c1f9c9:	31 c0                	xor    %eax,%eax
  c1f9cb:	49 89 db             	mov    %rbx,%r11
  c1f9ce:	49 c1 e8 04          	shr    $0x4,%r8
  c1f9d2:	c5 fb 92 cf          	kmovd  %edi,%k1
  c1f9d6:	49 ff c0             	inc    %r8
  c1f9d9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  c1f9e0:	41 0f b7 b9 10 ff ff ff 	movzwl -0xf0(%r9),%edi
  c1f9e8:	45 0f b7 b1 20 ff ff ff 	movzwl -0xe0(%r9),%r14d
  c1f9f0:	45 0f b7 b9 30 ff ff ff 	movzwl -0xd0(%r9),%r15d
  c1f9f8:	45 0f b7 a1 40 ff ff ff 	movzwl -0xc0(%r9),%r12d
  c1fa00:	62 c1 fe 48 6f a1 04 ff ff ff 	vmovdqu64 -0xfc(%r9),%zmm20
  c1fa0a:	62 41 fe 48 6f 99 44 ff ff ff 	vmovdqu64 -0xbc(%r9),%zmm27
  c1fa14:	62 41 fe 48 6f a9 84 ff ff ff 	vmovdqu64 -0x7c(%r9),%zmm29
  c1fa1e:	62 41 fe 48 6f b1 c4 ff ff ff 	vmovdqu64 -0x3c(%r9),%zmm30
  c1fa28:	62 f2 7d 48 5a 2d ee 69 95 ff 	vbroadcasti32x4 -0x6a9612(%rip),%zmm5        # 576420 <x86_effects_unknown+0x9c0>
  c1fa32:	62 f2 7d 48 5a 05 f4 69 95 ff 	vbroadcasti32x4 -0x6a960c(%rip),%zmm0        # 576430 <x86_effects_unknown+0x9d0>
  c1fa3c:	62 72 7d 48 58 05 c2 0b 96 ff 	vpbroadcastd -0x69f43e(%rip),%zmm8        # 580608 <tier0_emit_x87.operations+0x1c0>
  c1fa46:	48 83 c0 10          	add    $0x10,%rax
  c1fa4a:	c1 e7 06             	shl    $0x6,%edi
  c1fa4d:	41 c1 e6 06          	shl    $0x6,%r14d
  c1fa51:	41 c1 e7 06          	shl    $0x6,%r15d
  c1fa55:	41 c1 e4 06          	shl    $0x6,%r12d
  c1fa59:	c4 a1 7d 6f 4c 17 40 	vmovdqa 0x40(%rdi,%r10,1),%ymm1
  c1fa60:	41 0f b7 b9 50 ff ff ff 	movzwl -0xb0(%r9),%edi
  c1fa68:	62 13 f5 48 3a 5c 17 02 01 	vinserti64x4 $0x1,0x40(%r15,%r10,1),%zmm1,%zmm11
  c1fa71:	45 0f b7 b9 70 ff ff ff 	movzwl -0x90(%r9),%r15d
  c1fa79:	c4 81 7d 6f 4c 16 60 	vmovdqa 0x60(%r14,%r10,1),%ymm1
  c1fa80:	45 0f b7 b1 60 ff ff ff 	movzwl -0xa0(%r9),%r14d
  c1fa88:	62 83 f5 48 3a 74 14 03 01 	vinserti64x4 $0x1,0x60(%r12,%r10,1),%zmm1,%zmm22
  c1fa91:	45 0f b7 61 80       	movzwl -0x80(%r9),%r12d
  c1fa96:	62 11 15 40 62 fe    	vpunpckldq %zmm30,%zmm29,%zmm15
  c1fa9c:	62 01 5d 40 6a e3    	vpunpckhdq %zmm27,%zmm20,%zmm28
  c1faa2:	62 01 15 40 6a ee    	vpunpckhdq %zmm30,%zmm29,%zmm29
  c1faa8:	62 11 5d 40 62 f3    	vpunpckldq %zmm27,%zmm20,%zmm14
  c1faae:	62 11 9d 40 6c d5    	vpunpcklqdq %zmm29,%zmm28,%zmm10
  c1fab4:	62 41 8d 48 6d f7    	vpunpckhqdq %zmm15,%zmm14,%zmm30
  c1faba:	62 d2 fd 48 83 f2    	vpmultishiftqb %zmm10,%zmm0,%zmm6
  c1fac0:	62 92 0d 40 27 c6    	vptestmd %zmm30,%zmm30,%k0
  c1fac6:	62 91 7d 48 72 e6 1f 	vpsrad $0x1f,%zmm30,%zmm0
  c1facd:	62 41 fd 48 6f da    	vmovdqa64 %zmm10,%zmm27
  c1fad3:	c1 e7 06             	shl    $0x6,%edi
  c1fad6:	c4 a1 7d 6f 4c 17 40 	vmovdqa 0x40(%rdi,%r10,1),%ymm1
  c1fadd:	41 0f b7 79 90       	movzwl -0x70(%r9),%edi
  c1fae2:	41 c1 e7 06          	shl    $0x6,%r15d
  c1fae6:	41 c1 e6 06          	shl    $0x6,%r14d
  c1faea:	62 83 f5 48 3a 44 17 02 01 	vinserti64x4 $0x1,0x40(%r15,%r10,1),%zmm1,%zmm16
  c1faf3:	45 0f b7 79 b0       	movzwl -0x50(%r9),%r15d
  c1faf8:	c4 81 7d 6f 4c 16 60 	vmovdqa 0x60(%r14,%r10,1),%ymm1
  c1faff:	45 0f b7 71 a0       	movzwl -0x60(%r9),%r14d
  c1fb04:	41 c1 e4 06          	shl    $0x6,%r12d
  c1fb08:	62 03 f5 48 3a 44 14 03 01 	vinserti64x4 $0x1,0x60(%r12,%r10,1),%zmm1,%zmm24
  c1fb11:	45 0f b7 61 c0       	movzwl -0x40(%r9),%r12d
  c1fb16:	62 32 a5 49 64 ee    	vpblendmq %zmm22,%zmm11,%zmm13{%k1}
  c1fb1c:	c1 e7 06             	shl    $0x6,%edi
  c1fb1f:	c4 a1 7d 6f 4c 17 40 	vmovdqa 0x40(%rdi,%r10,1),%ymm1
  c1fb26:	41 0f b7 79 d0       	movzwl -0x30(%r9),%edi
  c1fb2b:	41 c1 e7 06          	shl    $0x6,%r15d
  c1fb2f:	41 c1 e6 06          	shl    $0x6,%r14d
  c1fb33:	62 83 f5 48 3a 54 17 02 01 	vinserti64x4 $0x1,0x40(%r15,%r10,1),%zmm1,%zmm18
  c1fb3c:	45 0f b7 79 f0       	movzwl -0x10(%r9),%r15d
  c1fb41:	c4 81 7d 6f 4c 16 60 	vmovdqa 0x60(%r14,%r10,1),%ymm1
  c1fb48:	45 0f b7 71 e0       	movzwl -0x20(%r9),%r14d
  c1fb4d:	41 c1 e4 06          	shl    $0x6,%r12d
  c1fb51:	62 03 f5 48 3a 4c 14 03 01 	vinserti64x4 $0x1,0x60(%r12,%r10,1),%zmm1,%zmm25
  c1fb5a:	45 0f b7 21          	movzwl (%r9),%r12d
  c1fb5e:	49 81 c1 00 01 00 00 	add    $0x100,%r9
  c1fb65:	62 82 fd 41 64 c8    	vpblendmq %zmm24,%zmm16,%zmm17{%k1}
  c1fb6b:	c1 e7 06             	shl    $0x6,%edi
  c1fb6e:	41 c1 e6 06          	shl    $0x6,%r14d
  c1fb72:	41 c1 e7 06          	shl    $0x6,%r15d
  c1fb76:	c4 a1 7d 6f 4c 17 40 	vmovdqa 0x40(%rdi,%r10,1),%ymm1
  c1fb7d:	62 83 f5 48 3a 6c 17 02 01 	vinserti64x4 $0x1,0x40(%r15,%r10,1),%zmm1,%zmm21
  c1fb86:	41 c1 e4 06          	shl    $0x6,%r12d
  c1fb8a:	c4 81 7d 6f 4c 16 60 	vmovdqa 0x60(%r14,%r10,1),%ymm1
  c1fb91:	62 03 f5 48 3a 54 14 03 01 	vinserti64x4 $0x1,0x60(%r12,%r10,1),%zmm1,%zmm26
  c1fb9a:	62 b1 15 48 6a c9    	vpunpckhdq %zmm17,%zmm13,%zmm1
  c1fba0:	62 82 ed 41 64 d9    	vpblendmq %zmm25,%zmm18,%zmm19{%k1}
  c1fba6:	62 82 d5 41 64 fa    	vpblendmq %zmm26,%zmm21,%zmm23{%k1}
  c1fbac:	62 b1 65 40 6a d7    	vpunpckhdq %zmm23,%zmm19,%zmm2
  c1fbb2:	62 e1 f5 48 6d e2    	vpunpckhqdq %zmm2,%zmm1,%zmm20
  c1fbb8:	62 d1 75 48 72 d2 1a 	vpsrld $0x1a,%zmm10,%zmm1
  c1fbbf:	62 f2 75 48 36 3d f7 29 90 ff 	vpermd -0x6fd609(%rip),%zmm1,%zmm7        # 5225c0 <branch_sizing_patterns+0x2830>
  c1fbc9:	62 62 75 48 36 3d 2d 2a 90 ff 	vpermd -0x6fd5d3(%rip),%zmm1,%zmm31        # 522600 <branch_sizing_patterns+0x2870>
  c1fbd3:	62 f2 75 48 36 25 63 2a 90 ff 	vpermd -0x6fd59d(%rip),%zmm1,%zmm4        # 522640 <branch_sizing_patterns+0x28b0>
  c1fbdd:	62 d2 d5 48 83 ca    	vpmultishiftqb %zmm10,%zmm5,%zmm1
  c1fbe3:	62 f2 7d 48 5a 2d 53 68 95 ff 	vbroadcasti32x4 -0x6a97ad(%rip),%zmm5        # 576440 <x86_effects_unknown+0x9e0>
  c1fbed:	62 d2 d5 48 83 ea    	vpmultishiftqb %zmm10,%zmm5,%zmm5
  c1fbf3:	62 f3 75 58 25 2d fe 09 96 ff d8 	vpternlogd $0xd8,-0x69f602(%rip){1to16},%zmm1,%zmm5        # 5805fc <tier0_emit_x87.operations+0x1b4>
  c1fbfe:	62 d1 75 48 72 f2 04 	vpslld $0x4,%zmm10,%zmm1
  c1fc05:	62 f1 6d 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm2
  c1fc0c:	62 f3 55 58 25 35 e9 09 96 ff e4 	vpternlogd $0xe4,-0x69f617(%rip){1to16},%zmm5,%zmm6        # 580600 <tier0_emit_x87.operations+0x1b8>
  c1fc17:	62 f2 7d 48 5a 2d 2f 68 95 ff 	vbroadcasti32x4 -0x6a97d1(%rip),%zmm5        # 576450 <x86_effects_unknown+0x9f0>
  c1fc21:	62 d2 55 48 00 ea    	vpshufb %zmm10,%zmm5,%zmm5
  c1fc27:	62 63 4d 48 25 ff f8 	vpternlogd $0xf8,%zmm7,%zmm6,%zmm31
  c1fc2e:	62 f1 75 48 72 f5 10 	vpslld $0x10,%zmm5,%zmm1
  c1fc35:	62 f1 6d 48 db ed    	vpandd %zmm5,%zmm2,%zmm5
  c1fc3b:	62 f3 5d 58 25 2d f6 09 96 ff ec 	vpternlogd $0xec,-0x69f60a(%rip){1to16},%zmm4,%zmm5        # 58063c <tier0_emit_x87.operations+0x1f4>
  c1fc46:	62 f1 45 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm7
  c1fc4d:	62 f2 7e 48 38 c8    	vpmovm2d %k0,%zmm1
  c1fc53:	62 f3 5d 50 25 2d e2 09 96 ff f8 	vpternlogd $0xf8,-0x69f61e(%rip){1to16},%zmm20,%zmm5        # 580640 <tier0_emit_x87.operations+0x1f8>
  c1fc5e:	62 f3 6d 48 25 cf c8 	vpternlogd $0xc8,%zmm7,%zmm2,%zmm1
  c1fc65:	62 91 7d 48 ef fe    	vpxord %zmm30,%zmm0,%zmm7
  c1fc6b:	62 f2 7d 48 58 05 8f 09 96 ff 	vpbroadcastd -0x69f671(%rip),%zmm0        # 580604 <tier0_emit_x87.operations+0x1bc>
  c1fc75:	62 f2 7d 48 44 ff    	vplzcntd %zmm7,%zmm7
  c1fc7b:	62 f2 3d 48 45 ff    	vpsrlvd %zmm7,%zmm8,%zmm7
  c1fc81:	62 51 0d 40 fe c4    	vpaddd %zmm12,%zmm30,%zmm8
  c1fc87:	62 73 0d 40 25 c7 14 	vpternlogd $0x14,%zmm7,%zmm30,%zmm8
  c1fc8e:	62 d1 45 48 72 d2 08 	vpsrld $0x8,%zmm10,%zmm7
  c1fc95:	62 63 7d 58 25 1d 74 09 96 ff 6c 	vpternlogd $0x6c,-0x69f68c(%rip){1to16},%zmm0,%zmm27        # 580614 <tier0_emit_x87.operations+0x1cc>
  c1fca0:	62 f3 7d 58 25 3d 6d 09 96 ff 6c 	vpternlogd $0x6c,-0x69f693(%rip){1to16},%zmm0,%zmm7        # 580618 <tier0_emit_x87.operations+0x1d0>
  c1fcab:	62 91 7d 48 72 ce 01 	vprold $0x1,%zmm30,%zmm0
  c1fcb2:	62 41 25 40 fe dc    	vpaddd %zmm12,%zmm27,%zmm27
  c1fcb8:	62 63 35 58 25 1d 59 09 96 ff ec 	vpternlogd $0xec,-0x69f6a7(%rip){1to16},%zmm9,%zmm27        # 58061c <tier0_emit_x87.operations+0x1d4>
  c1fcc3:	62 d1 45 48 fe fc    	vpaddd %zmm12,%zmm7,%zmm7
  c1fcc9:	62 f3 25 50 25 3d 50 09 96 ff ec 	vpternlogd $0xec,-0x69f6b0(%rip){1to16},%zmm27,%zmm7        # 580624 <tier0_emit_x87.operations+0x1dc>
  c1fcd4:	62 61 4d 58 db 1d 4a 09 96 ff 	vpandd -0x69f6b6(%rip){1to16},%zmm6,%zmm27        # 580628 <tier0_emit_x87.operations+0x1e0>
  c1fcde:	62 f1 4d 48 72 d6 03 	vpsrld $0x3,%zmm6,%zmm6
  c1fce5:	62 f3 5d 50 25 35 44 09 96 ff a2 	vpternlogd $0xa2,-0x69f6bc(%rip){1to16},%zmm20,%zmm6        # 580634 <tier0_emit_x87.operations+0x1ec>
  c1fcf0:	62 f2 4d 58 3b 25 3e 09 96 ff 	vpminud -0x69f6c2(%rip){1to16},%zmm6,%zmm4        # 580638 <tier0_emit_x87.operations+0x1f0>
  c1fcfa:	62 63 5d 40 25 df f8 	vpternlogd $0xf8,%zmm7,%zmm20,%zmm27
  c1fd01:	62 62 25 50 3b 1d 21 09 96 ff 	vpminud -0x69f6df(%rip){1to16},%zmm27,%zmm27        # 58062c <tier0_emit_x87.operations+0x1e4>
  c1fd0b:	62 b1 45 48 72 d4 1d 	vpsrld $0x1d,%zmm20,%zmm7
  c1fd12:	62 72 3d 48 14 c7    	vprorvd %zmm7,%zmm8,%zmm8
  c1fd18:	62 f2 7d 48 14 ff    	vprorvd %zmm7,%zmm0,%zmm7
  c1fd1e:	62 f1 fd 48 6f 05 58 28 90 ff 	vmovdqa64 -0x6fd7a8(%rip),%zmm0        # 522580 <branch_sizing_patterns+0x27f0>
  c1fd28:	62 d1 3d 48 72 e0 1f 	vpsrad $0x1f,%zmm8,%zmm8
  c1fd2f:	62 93 75 48 25 fe e2 	vpternlogd $0xe2,%zmm30,%zmm1,%zmm7
  c1fd36:	62 93 3d 48 25 fe e2 	vpternlogd $0xe2,%zmm30,%zmm8,%zmm7
  c1fd3d:	62 93 5d 48 25 eb fe 	vpternlogd $0xfe,%zmm27,%zmm4,%zmm5
  c1fd44:	62 91 fd 48 6f e7    	vmovdqa64 %zmm31,%zmm4
  c1fd4a:	62 01 fd 48 6f df    	vmovdqa64 %zmm31,%zmm27
  c1fd50:	62 f3 6d 58 25 25 b5 08 96 ff f8 	vpternlogd $0xf8,-0x69f74b(%rip){1to16},%zmm2,%zmm4        # 580610 <tier0_emit_x87.operations+0x1c8>
  c1fd5b:	62 63 75 58 25 1d a6 08 96 ff f8 	vpternlogd $0xf8,-0x69f75a(%rip){1to16},%zmm1,%zmm27        # 58060c <tier0_emit_x87.operations+0x1c4>
  c1fd66:	62 f1 6d 58 db 15 d8 08 96 ff 	vpandd -0x69f728(%rip){1to16},%zmm2,%zmm2        # 580648 <tier0_emit_x87.operations+0x200>
  c1fd70:	62 32 fd 48 7e de    	vpermt2q %zmm22,%zmm0,%zmm11
  c1fd76:	62 82 fd 48 7e c0    	vpermt2q %zmm24,%zmm0,%zmm16
  c1fd7c:	62 82 fd 48 7e d1    	vpermt2q %zmm25,%zmm0,%zmm18
  c1fd82:	62 82 fd 48 7e ea    	vpermt2q %zmm26,%zmm0,%zmm21
  c1fd88:	62 91 7d 48 72 d7 10 	vpsrld $0x10,%zmm31,%zmm0
  c1fd8f:	62 91 4d 40 72 d7 03 	vpsrld $0x3,%zmm31,%zmm22
  c1fd96:	62 e3 7d 58 25 35 8f 08 96 ff ec 	vpternlogd $0xec,-0x69f771(%rip){1to16},%zmm0,%zmm22        # 580630 <tier0_emit_x87.operations+0x1e8>
  c1fda1:	62 f2 7d 48 5a 05 b5 66 95 ff 	vbroadcasti32x4 -0x6a994b(%rip),%zmm0        # 576460 <x86_effects_unknown+0xa00>
  c1fdab:	62 93 3d 48 25 e3 b8 	vpternlogd $0xb8,%zmm27,%zmm8,%zmm4
  c1fdb2:	62 61 75 58 db 1d 88 08 96 ff 	vpandd -0x69f778(%rip){1to16},%zmm1,%zmm27        # 580644 <tier0_emit_x87.operations+0x1fc>
  c1fdbc:	62 d1 4d 48 fe cc    	vpaddd %zmm12,%zmm6,%zmm1
  c1fdc2:	62 f1 75 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm1
  c1fdc9:	62 93 3d 48 25 d3 b8 	vpternlogd $0xb8,%zmm27,%zmm8,%zmm2
  c1fdd0:	62 51 8d 48 6c c7    	vpunpcklqdq %zmm15,%zmm14,%zmm8
  c1fdd6:	62 11 9d 40 6d f5    	vpunpckhqdq %zmm29,%zmm28,%zmm14
  c1fddc:	62 f1 3d 48 6a f7    	vpunpckhdq %zmm7,%zmm8,%zmm6
  c1fde2:	62 51 0d 48 eb d2    	vpord  %zmm10,%zmm14,%zmm10
  c1fde8:	62 71 6d 48 eb fd    	vpord  %zmm5,%zmm2,%zmm15
  c1fdee:	62 b1 6d 48 72 f6 08 	vpslld $0x8,%zmm22,%zmm2
  c1fdf5:	62 f3 75 58 25 15 4c 08 96 ff 08 	vpternlogd $0x8,-0x69f7b4(%rip){1to16},%zmm1,%zmm2        # 58064c <tier0_emit_x87.operations+0x204>
  c1fe00:	62 d1 55 48 72 f2 07 	vpslld $0x7,%zmm10,%zmm5
  c1fe07:	62 f3 55 58 25 15 3e 08 96 ff d8 	vpternlogd $0xd8,-0x69f7c2(%rip){1to16},%zmm5,%zmm2        # 580650 <tier0_emit_x87.operations+0x208>
  c1fe12:	62 d2 fd 48 83 ee    	vpmultishiftqb %zmm14,%zmm0,%zmm5
  c1fe18:	62 f3 4d 50 25 2d 31 08 96 ff d8 	vpternlogd $0xd8,-0x69f7cf(%rip){1to16},%zmm22,%zmm5        # 580654 <tier0_emit_x87.operations+0x20c>
  c1fe23:	62 d1 7d 48 70 c7 55 	vpshufd $0x55,%zmm15,%zmm0
  c1fe2a:	62 b2 7d 48 8f d0    	vpshufbitqmb %zmm16,%zmm0,%k2
  c1fe30:	c4 61 fb 93 f2       	kmovq  %k2,%r14
  c1fe35:	f3 4d 0f b8 f6       	popcnt %r14,%r14
  c1fe3a:	62 f3 6d 58 25 2d 13 08 96 ff d8 	vpternlogd $0xd8,-0x69f7ed(%rip){1to16},%zmm2,%zmm5        # 580658 <tier0_emit_x87.operations+0x210>
  c1fe45:	62 f1 3d 48 62 d7    	vpunpckldq %zmm7,%zmm8,%zmm2
  c1fe4b:	62 f1 5d 48 62 fd    	vpunpckldq %zmm5,%zmm4,%zmm7
  c1fe51:	62 f1 5d 48 6a e5    	vpunpckhdq %zmm5,%zmm4,%zmm4
  c1fe57:	62 f1 ed 48 6c ef    	vpunpcklqdq %zmm7,%zmm2,%zmm5
  c1fe5d:	62 f1 ed 48 6d d7    	vpunpckhqdq %zmm7,%zmm2,%zmm2
  c1fe63:	62 f1 cd 48 6c fc    	vpunpcklqdq %zmm4,%zmm6,%zmm7
  c1fe69:	62 f1 cd 48 6d e4    	vpunpckhqdq %zmm4,%zmm6,%zmm4
  c1fe6f:	62 d1 7d 48 70 f7 00 	vpshufd $0x0,%zmm15,%zmm6
  c1fe76:	62 d2 55 48 00 eb    	vpshufb %zmm11,%zmm5,%zmm5
  c1fe7c:	62 d2 4d 48 8f db    	vpshufbitqmb %zmm11,%zmm6,%k3
  c1fe82:	62 b2 6d 48 00 d0    	vpshufb %zmm16,%zmm2,%zmm2
  c1fe88:	62 b2 45 48 00 c2    	vpshufb %zmm18,%zmm7,%zmm0
  c1fe8e:	62 f3 95 48 25 eb 78 	vpternlogq $0x78,%zmm3,%zmm13,%zmm5
  c1fe95:	62 f3 f5 40 25 d3 78 	vpternlogq $0x78,%zmm3,%zmm17,%zmm2
  c1fe9c:	62 f3 e5 40 25 c3 78 	vpternlogq $0x78,%zmm3,%zmm19,%zmm0
  c1fea3:	62 f2 7d cb 63 ed    	vpcompressb %zmm5,%zmm5{%k3}{z}
  c1fea9:	62 f2 7d ca 63 d2    	vpcompressb %zmm2,%zmm2{%k2}{z}
  c1feaf:	c4 e1 fb 93 fb       	kmovq  %k3,%rdi
  c1feb4:	f3 48 0f b8 ff       	popcnt %rdi,%rdi
  c1feb9:	62 d1 fe 48 7f 2b    	vmovdqu64 %zmm5,(%r11)
  c1febf:	62 d1 7d 48 70 ef aa 	vpshufd $0xaa,%zmm15,%zmm5
  c1fec6:	62 d1 fe 48 7f 14 3b 	vmovdqu64 %zmm2,(%r11,%rdi,1)
  c1fecd:	4c 01 df             	add    %r11,%rdi
  c1fed0:	41 29 db             	sub    %ebx,%r11d
  c1fed3:	62 b2 55 48 8f da    	vpshufbitqmb %zmm18,%zmm5,%k3
  c1fed9:	62 d1 7d 48 70 ef ff 	vpshufd $0xff,%zmm15,%zmm5
  c1fee0:	62 73 5d 50 25 3d 71 07 96 ff 20 	vpternlogd $0x20,-0x69f88f(%rip){1to16},%zmm20,%zmm15        # 58065c <tier0_emit_x87.operations+0x214>
  c1feeb:	62 b2 55 48 8f d5    	vpshufbitqmb %zmm21,%zmm5,%k2
  c1fef1:	c5 e9 ef d2          	vpxor  %xmm2,%xmm2,%xmm2
  c1fef5:	62 f2 7d cb 63 c2    	vpcompressb %zmm0,%zmm2{%k3}{z}
  c1fefb:	62 b2 5d 48 00 c5    	vpshufb %zmm21,%zmm4,%zmm0
  c1ff01:	62 f1 5d 50 db 25 55 07 96 ff 	vpandd -0x69f8ab(%rip){1to16},%zmm20,%zmm4        # 580660 <tier0_emit_x87.operations+0x218>
  c1ff0b:	62 f3 c5 40 25 c3 78 	vpternlogq $0x78,%zmm3,%zmm23,%zmm0
  c1ff12:	62 d1 fe 48 7f 14 3e 	vmovdqu64 %zmm2,(%r14,%rdi,1)
  c1ff19:	c5 e9 ef d2          	vpxor  %xmm2,%xmm2,%xmm2
  c1ff1d:	62 f2 7d ca 63 c2    	vpcompressb %zmm0,%zmm2{%k2}{z}
  c1ff23:	62 d2 7d 48 55 c7    	vpopcntd %zmm15,%zmm0
  c1ff29:	49 01 fe             	add    %rdi,%r14
  c1ff2c:	c4 e1 fb 93 fb       	kmovq  %k3,%rdi
  c1ff31:	f3 4c 0f b8 ff       	popcnt %rdi,%r15
  c1ff36:	c4 e1 fb 93 fa       	kmovq  %k2,%rdi
  c1ff3b:	f3 48 0f b8 ff       	popcnt %rdi,%rdi
  c1ff40:	62 f1 75 48 fe cc    	vpaddd %zmm4,%zmm1,%zmm1
  c1ff46:	4c 01 ff             	add    %r15,%rdi
  c1ff49:	62 f1 75 48 fe c8    	vpaddd %zmm0,%zmm1,%zmm1
  c1ff4f:	c5 f9 6f 05 99 64 95 ff 	vmovdqa -0x6a9b67(%rip),%xmm0        # 5763f0 <x86_effects_unknown+0x990>
  c1ff57:	4c 01 f7             	add    %r14,%rdi
  c1ff5a:	62 91 fe 48 7f 14 37 	vmovdqu64 %zmm2,(%r15,%r14,1)
  c1ff61:	44 89 5c 24 40       	mov    %r11d,0x40(%rsp)
  c1ff66:	62 f2 7d 48 8d c9    	vpermb %zmm1,%zmm0,%zmm1
  c1ff6c:	c5 f9 6f 05 8c 64 95 ff 	vmovdqa -0x6a9b74(%rip),%xmm0        # 576400 <x86_effects_unknown+0x9a0>
  c1ff74:	62 f2 f5 18 40 0d c2 04 96 ff 	vpmullq -0x69fb3e(%rip){1to2},%xmm1,%xmm1        # 580440 <x86_semantics_benchmark_code.registers+0x450>
  c1ff7e:	62 d2 7d 48 8d d6    	vpermb %zmm14,%zmm0,%zmm2
  c1ff84:	c4 e2 71 00 05 83 64 95 ff 	vpshufb -0x6a9b7d(%rip),%xmm1,%xmm0        # 576410 <x86_effects_unknown+0x9b0>
  c1ff8d:	62 f2 7e 48 29 da    	vpmovb2m %zmm2,%k3
  c1ff93:	c5 7b 93 db          	kmovd  %k3,%r11d
  c1ff97:	45 0f b7 db          	movzwl %r11w,%r11d
  c1ff9b:	c5 f9 fc c9          	vpaddb %xmm1,%xmm0,%xmm1
  c1ff9f:	f3 45 0f b8 db       	popcnt %r11d,%r11d
  c1ffa4:	49 ff c8             	dec    %r8
  c1ffa7:	62 f2 7d 48 31 c9    	vpmovzxbd %xmm1,%zmm1
  c1ffad:	62 f1 75 58 fe 4c 24 10 	vpaddd 0x40(%rsp){1to16},%zmm1,%zmm1
  c1ffb5:	62 f2 7d cb 8b c9    	vpcompressd %zmm1,%zmm1{%k3}{z}
  c1ffbb:	62 f1 fe 48 7f 09    	vmovdqu64 %zmm1,(%rcx)
  c1ffc1:	4a 8d 0c 99          	lea    (%rcx,%r11,4),%rcx
  c1ffc5:	49 89 fb             	mov    %rdi,%r11
  c1ffc8:	0f 85 12 fa ff ff    	jne    c1f9e0 <x86_encode_16+0xa0>
  c1ffce:	4c 8d 40 10          	lea    0x10(%rax),%r8
  c1ffd2:	49 39 d0             	cmp    %rdx,%r8
  c1ffd5:	76 08                	jbe    c1ffdf <x86_encode_16+0x69f>
  c1ffd7:	49 89 fe             	mov    %rdi,%r14
  c1ffda:	e9 3f 06 00 00       	jmp    c2061e <x86_encode_16+0xcde>
  c1ffdf:	62 f2 7d 48 5a 1d f7 63 95 ff 	vbroadcasti32x4 -0x6a9c09(%rip),%zmm3        # 5763e0 <x86_effects_unknown+0x980>
  c1ffe9:	62 72 7d 48 58 0d 2d 06 96 ff 	vpbroadcastd -0x69f9d3(%rip),%zmm9        # 580620 <tier0_emit_x87.operations+0x1d8>
  c1fff3:	49 89 d0             	mov    %rdx,%r8
  c1fff6:	49 29 c0             	sub    %rax,%r8
  c1fff9:	49 89 c1             	mov    %rax,%r9
  c1fffc:	49 c1 e1 04          	shl    $0x4,%r9
  c20000:	41 b3 cc             	mov    $0xcc,%r11b
  c20003:	4c 8d 15 f6 64 a4 0d 	lea    0xda464f6(%rip),%r10        # e666500 <x86_template_storage>
  c2000a:	62 53 1d 48 25 e4 ff 	vpternlogd $0xff,%zmm12,%zmm12,%zmm12
  c20011:	49 83 c0 f0          	add    $0xfffffffffffffff0,%r8
  c20015:	4d 8d 8c 31 fc 00 00 00 	lea    0xfc(%r9,%rsi,1),%r9
  c2001d:	c4 c1 7b 92 cb       	kmovd  %r11d,%k1
  c20022:	49 c1 e8 04          	shr    $0x4,%r8
  c20026:	49 ff c0             	inc    %r8
  c20029:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  c20030:	45 0f b7 99 10 ff ff ff 	movzwl -0xf0(%r9),%r11d
  c20038:	45 0f b7 b1 20 ff ff ff 	movzwl -0xe0(%r9),%r14d
  c20040:	45 0f b7 b9 30 ff ff ff 	movzwl -0xd0(%r9),%r15d
  c20048:	45 0f b7 a1 40 ff ff ff 	movzwl -0xc0(%r9),%r12d
  c20050:	62 c1 fe 48 6f a1 04 ff ff ff 	vmovdqu64 -0xfc(%r9),%zmm20
  c2005a:	62 41 fe 48 6f 99 44 ff ff ff 	vmovdqu64 -0xbc(%r9),%zmm27
  c20064:	62 41 fe 48 6f a9 84 ff ff ff 	vmovdqu64 -0x7c(%r9),%zmm29
  c2006e:	62 41 fe 48 6f b1 c4 ff ff ff 	vmovdqu64 -0x3c(%r9),%zmm30
  c20078:	62 f2 7d 48 5a 2d 9e 63 95 ff 	vbroadcasti32x4 -0x6a9c62(%rip),%zmm5        # 576420 <x86_effects_unknown+0x9c0>
  c20082:	62 f2 7d 48 5a 05 a4 63 95 ff 	vbroadcasti32x4 -0x6a9c5c(%rip),%zmm0        # 576430 <x86_effects_unknown+0x9d0>
  c2008c:	62 72 7d 48 58 05 72 05 96 ff 	vpbroadcastd -0x69fa8e(%rip),%zmm8        # 580608 <tier0_emit_x87.operations+0x1c0>
  c20096:	48 83 c0 10          	add    $0x10,%rax
  c2009a:	41 c1 e3 06          	shl    $0x6,%r11d
  c2009e:	41 c1 e6 06          	shl    $0x6,%r14d
  c200a2:	41 c1 e7 06          	shl    $0x6,%r15d
  c200a6:	41 c1 e4 06          	shl    $0x6,%r12d
  c200aa:	c4 81 7d 6f 4c 13 40 	vmovdqa 0x40(%r11,%r10,1),%ymm1
  c200b1:	45 0f b7 99 50 ff ff ff 	movzwl -0xb0(%r9),%r11d
  c200b9:	62 13 f5 48 3a 5c 17 02 01 	vinserti64x4 $0x1,0x40(%r15,%r10,1),%zmm1,%zmm11
  c200c2:	45 0f b7 b9 70 ff ff ff 	movzwl -0x90(%r9),%r15d
  c200ca:	c4 81 7d 6f 4c 16 60 	vmovdqa 0x60(%r14,%r10,1),%ymm1
  c200d1:	45 0f b7 b1 60 ff ff ff 	movzwl -0xa0(%r9),%r14d
  c200d9:	62 83 f5 48 3a 74 14 03 01 	vinserti64x4 $0x1,0x60(%r12,%r10,1),%zmm1,%zmm22
  c200e2:	45 0f b7 61 80       	movzwl -0x80(%r9),%r12d
  c200e7:	62 11 15 40 62 fe    	vpunpckldq %zmm30,%zmm29,%zmm15
  c200ed:	62 01 5d 40 6a e3    	vpunpckhdq %zmm27,%zmm20,%zmm28
  c200f3:	62 01 15 40 6a ee    	vpunpckhdq %zmm30,%zmm29,%zmm29
  c200f9:	62 11 5d 40 62 f3    	vpunpckldq %zmm27,%zmm20,%zmm14
  c200ff:	62 11 9d 40 6c d5    	vpunpcklqdq %zmm29,%zmm28,%zmm10
  c20105:	62 41 8d 48 6d f7    	vpunpckhqdq %zmm15,%zmm14,%zmm30
  c2010b:	62 d2 fd 48 83 f2    	vpmultishiftqb %zmm10,%zmm0,%zmm6
  c20111:	62 92 0d 40 27 c6    	vptestmd %zmm30,%zmm30,%k0
  c20117:	62 91 7d 48 72 e6 1f 	vpsrad $0x1f,%zmm30,%zmm0
  c2011e:	62 41 fd 48 6f da    	vmovdqa64 %zmm10,%zmm27
  c20124:	41 c1 e3 06          	shl    $0x6,%r11d
  c20128:	c4 81 7d 6f 4c 13 40 	vmovdqa 0x40(%r11,%r10,1),%ymm1
  c2012f:	45 0f b7 59 90       	movzwl -0x70(%r9),%r11d
  c20134:	41 c1 e7 06          	shl    $0x6,%r15d
  c20138:	41 c1 e6 06          	shl    $0x6,%r14d
  c2013c:	62 83 f5 48 3a 44 17 02 01 	vinserti64x4 $0x1,0x40(%r15,%r10,1),%zmm1,%zmm16
  c20145:	45 0f b7 79 b0       	movzwl -0x50(%r9),%r15d
  c2014a:	c4 81 7d 6f 4c 16 60 	vmovdqa 0x60(%r14,%r10,1),%ymm1
  c20151:	45 0f b7 71 a0       	movzwl -0x60(%r9),%r14d
  c20156:	41 c1 e4 06          	shl    $0x6,%r12d
  c2015a:	62 03 f5 48 3a 44 14 03 01 	vinserti64x4 $0x1,0x60(%r12,%r10,1),%zmm1,%zmm24
  c20163:	45 0f b7 61 c0       	movzwl -0x40(%r9),%r12d
  c20168:	62 32 a5 49 64 ee    	vpblendmq %zmm22,%zmm11,%zmm13{%k1}
  c2016e:	41 c1 e3 06          	shl    $0x6,%r11d
  c20172:	c4 81 7d 6f 4c 13 40 	vmovdqa 0x40(%r11,%r10,1),%ymm1
  c20179:	45 0f b7 59 d0       	movzwl -0x30(%r9),%r11d
  c2017e:	41 c1 e7 06          	shl    $0x6,%r15d
  c20182:	41 c1 e6 06          	shl    $0x6,%r14d
  c20186:	62 83 f5 48 3a 54 17 02 01 	vinserti64x4 $0x1,0x40(%r15,%r10,1),%zmm1,%zmm18
  c2018f:	45 0f b7 79 f0       	movzwl -0x10(%r9),%r15d
  c20194:	c4 81 7d 6f 4c 16 60 	vmovdqa 0x60(%r14,%r10,1),%ymm1
  c2019b:	45 0f b7 71 e0       	movzwl -0x20(%r9),%r14d
  c201a0:	41 c1 e4 06          	shl    $0x6,%r12d
  c201a4:	62 03 f5 48 3a 4c 14 03 01 	vinserti64x4 $0x1,0x60(%r12,%r10,1),%zmm1,%zmm25
  c201ad:	45 0f b7 21          	movzwl (%r9),%r12d
  c201b1:	49 81 c1 00 01 00 00 	add    $0x100,%r9
  c201b8:	62 82 fd 41 64 c8    	vpblendmq %zmm24,%zmm16,%zmm17{%k1}
  c201be:	41 c1 e3 06          	shl    $0x6,%r11d
  c201c2:	41 c1 e6 06          	shl    $0x6,%r14d
  c201c6:	41 c1 e7 06          	shl    $0x6,%r15d
  c201ca:	c4 81 7d 6f 4c 13 40 	vmovdqa 0x40(%r11,%r10,1),%ymm1
  c201d1:	62 83 f5 48 3a 6c 17 02 01 	vinserti64x4 $0x1,0x40(%r15,%r10,1),%zmm1,%zmm21
  c201da:	41 c1 e4 06          	shl    $0x6,%r12d
  c201de:	c4 81 7d 6f 4c 16 60 	vmovdqa 0x60(%r14,%r10,1),%ymm1
  c201e5:	62 03 f5 48 3a 54 14 03 01 	vinserti64x4 $0x1,0x60(%r12,%r10,1),%zmm1,%zmm26
  c201ee:	62 b1 15 48 6a c9    	vpunpckhdq %zmm17,%zmm13,%zmm1
  c201f4:	62 82 ed 41 64 d9    	vpblendmq %zmm25,%zmm18,%zmm19{%k1}
  c201fa:	62 82 d5 41 64 fa    	vpblendmq %zmm26,%zmm21,%zmm23{%k1}
  c20200:	62 b1 65 40 6a d7    	vpunpckhdq %zmm23,%zmm19,%zmm2
  c20206:	62 e1 f5 48 6d e2    	vpunpckhqdq %zmm2,%zmm1,%zmm20
  c2020c:	62 d1 75 48 72 d2 1a 	vpsrld $0x1a,%zmm10,%zmm1
  c20213:	62 f2 75 48 36 3d a3 23 90 ff 	vpermd -0x6fdc5d(%rip),%zmm1,%zmm7        # 5225c0 <branch_sizing_patterns+0x2830>
  c2021d:	62 62 75 48 36 3d d9 23 90 ff 	vpermd -0x6fdc27(%rip),%zmm1,%zmm31        # 522600 <branch_sizing_patterns+0x2870>
  c20227:	62 f2 75 48 36 25 0f 24 90 ff 	vpermd -0x6fdbf1(%rip),%zmm1,%zmm4        # 522640 <branch_sizing_patterns+0x28b0>
  c20231:	62 d2 d5 48 83 ca    	vpmultishiftqb %zmm10,%zmm5,%zmm1
  c20237:	62 f2 7d 48 5a 2d ff 61 95 ff 	vbroadcasti32x4 -0x6a9e01(%rip),%zmm5        # 576440 <x86_effects_unknown+0x9e0>
  c20241:	62 d2 d5 48 83 ea    	vpmultishiftqb %zmm10,%zmm5,%zmm5
  c20247:	62 f3 75 58 25 2d aa 03 96 ff d8 	vpternlogd $0xd8,-0x69fc56(%rip){1to16},%zmm1,%zmm5        # 5805fc <tier0_emit_x87.operations+0x1b4>
  c20252:	62 d1 75 48 72 f2 04 	vpslld $0x4,%zmm10,%zmm1
  c20259:	62 f1 6d 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm2
  c20260:	62 f3 55 58 25 35 95 03 96 ff e4 	vpternlogd $0xe4,-0x69fc6b(%rip){1to16},%zmm5,%zmm6        # 580600 <tier0_emit_x87.operations+0x1b8>
  c2026b:	62 f2 7d 48 5a 2d db 61 95 ff 	vbroadcasti32x4 -0x6a9e25(%rip),%zmm5        # 576450 <x86_effects_unknown+0x9f0>
  c20275:	62 d2 55 48 00 ea    	vpshufb %zmm10,%zmm5,%zmm5
  c2027b:	62 63 4d 48 25 ff f8 	vpternlogd $0xf8,%zmm7,%zmm6,%zmm31
  c20282:	62 f1 75 48 72 f5 10 	vpslld $0x10,%zmm5,%zmm1
  c20289:	62 f1 6d 48 db ed    	vpandd %zmm5,%zmm2,%zmm5
  c2028f:	62 f3 5d 58 25 2d a2 03 96 ff ec 	vpternlogd $0xec,-0x69fc5e(%rip){1to16},%zmm4,%zmm5        # 58063c <tier0_emit_x87.operations+0x1f4>
  c2029a:	62 f1 45 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm7
  c202a1:	62 f2 7e 48 38 c8    	vpmovm2d %k0,%zmm1
  c202a7:	62 f3 5d 50 25 2d 8e 03 96 ff f8 	vpternlogd $0xf8,-0x69fc72(%rip){1to16},%zmm20,%zmm5        # 580640 <tier0_emit_x87.operations+0x1f8>
  c202b2:	62 f3 6d 48 25 cf c8 	vpternlogd $0xc8,%zmm7,%zmm2,%zmm1
  c202b9:	62 91 7d 48 ef fe    	vpxord %zmm30,%zmm0,%zmm7
  c202bf:	62 f2 7d 48 58 05 3b 03 96 ff 	vpbroadcastd -0x69fcc5(%rip),%zmm0        # 580604 <tier0_emit_x87.operations+0x1bc>
  c202c9:	62 f2 7d 48 44 ff    	vplzcntd %zmm7,%zmm7
  c202cf:	62 f2 3d 48 45 ff    	vpsrlvd %zmm7,%zmm8,%zmm7
  c202d5:	62 51 0d 40 fe c4    	vpaddd %zmm12,%zmm30,%zmm8
  c202db:	62 73 0d 40 25 c7 14 	vpternlogd $0x14,%zmm7,%zmm30,%zmm8
  c202e2:	62 d1 45 48 72 d2 08 	vpsrld $0x8,%zmm10,%zmm7
  c202e9:	62 63 7d 58 25 1d 20 03 96 ff 6c 	vpternlogd $0x6c,-0x69fce0(%rip){1to16},%zmm0,%zmm27        # 580614 <tier0_emit_x87.operations+0x1cc>
  c202f4:	62 f3 7d 58 25 3d 19 03 96 ff 6c 	vpternlogd $0x6c,-0x69fce7(%rip){1to16},%zmm0,%zmm7        # 580618 <tier0_emit_x87.operations+0x1d0>
  c202ff:	62 91 7d 48 72 ce 01 	vprold $0x1,%zmm30,%zmm0
  c20306:	62 41 25 40 fe dc    	vpaddd %zmm12,%zmm27,%zmm27
  c2030c:	62 63 35 58 25 1d 05 03 96 ff ec 	vpternlogd $0xec,-0x69fcfb(%rip){1to16},%zmm9,%zmm27        # 58061c <tier0_emit_x87.operations+0x1d4>
  c20317:	62 d1 45 48 fe fc    	vpaddd %zmm12,%zmm7,%zmm7
  c2031d:	62 f3 25 50 25 3d fc 02 96 ff ec 	vpternlogd $0xec,-0x69fd04(%rip){1to16},%zmm27,%zmm7        # 580624 <tier0_emit_x87.operations+0x1dc>
  c20328:	62 61 4d 58 db 1d f6 02 96 ff 	vpandd -0x69fd0a(%rip){1to16},%zmm6,%zmm27        # 580628 <tier0_emit_x87.operations+0x1e0>
  c20332:	62 f1 4d 48 72 d6 03 	vpsrld $0x3,%zmm6,%zmm6
  c20339:	62 f3 5d 50 25 35 f0 02 96 ff a2 	vpternlogd $0xa2,-0x69fd10(%rip){1to16},%zmm20,%zmm6        # 580634 <tier0_emit_x87.operations+0x1ec>
  c20344:	62 f2 4d 58 3b 25 ea 02 96 ff 	vpminud -0x69fd16(%rip){1to16},%zmm6,%zmm4        # 580638 <tier0_emit_x87.operations+0x1f0>
  c2034e:	62 63 5d 40 25 df f8 	vpternlogd $0xf8,%zmm7,%zmm20,%zmm27
  c20355:	62 62 25 50 3b 1d cd 02 96 ff 	vpminud -0x69fd33(%rip){1to16},%zmm27,%zmm27        # 58062c <tier0_emit_x87.operations+0x1e4>
  c2035f:	62 b1 45 48 72 d4 1d 	vpsrld $0x1d,%zmm20,%zmm7
  c20366:	62 72 3d 48 14 c7    	vprorvd %zmm7,%zmm8,%zmm8
  c2036c:	62 f2 7d 48 14 ff    	vprorvd %zmm7,%zmm0,%zmm7
  c20372:	62 f1 fd 48 6f 05 04 22 90 ff 	vmovdqa64 -0x6fddfc(%rip),%zmm0        # 522580 <branch_sizing_patterns+0x27f0>
  c2037c:	62 d1 3d 48 72 e0 1f 	vpsrad $0x1f,%zmm8,%zmm8
  c20383:	62 93 75 48 25 fe e2 	vpternlogd $0xe2,%zmm30,%zmm1,%zmm7
  c2038a:	62 93 3d 48 25 fe e2 	vpternlogd $0xe2,%zmm30,%zmm8,%zmm7
  c20391:	62 93 5d 48 25 eb fe 	vpternlogd $0xfe,%zmm27,%zmm4,%zmm5
  c20398:	62 91 fd 48 6f e7    	vmovdqa64 %zmm31,%zmm4
  c2039e:	62 01 fd 48 6f df    	vmovdqa64 %zmm31,%zmm27
  c203a4:	62 f3 6d 58 25 25 61 02 96 ff f8 	vpternlogd $0xf8,-0x69fd9f(%rip){1to16},%zmm2,%zmm4        # 580610 <tier0_emit_x87.operations+0x1c8>
  c203af:	62 63 75 58 25 1d 52 02 96 ff f8 	vpternlogd $0xf8,-0x69fdae(%rip){1to16},%zmm1,%zmm27        # 58060c <tier0_emit_x87.operations+0x1c4>
  c203ba:	62 f1 6d 58 db 15 84 02 96 ff 	vpandd -0x69fd7c(%rip){1to16},%zmm2,%zmm2        # 580648 <tier0_emit_x87.operations+0x200>
  c203c4:	62 32 fd 48 7e de    	vpermt2q %zmm22,%zmm0,%zmm11
  c203ca:	62 82 fd 48 7e c0    	vpermt2q %zmm24,%zmm0,%zmm16
  c203d0:	62 82 fd 48 7e d1    	vpermt2q %zmm25,%zmm0,%zmm18
  c203d6:	62 82 fd 48 7e ea    	vpermt2q %zmm26,%zmm0,%zmm21
  c203dc:	62 91 7d 48 72 d7 10 	vpsrld $0x10,%zmm31,%zmm0
  c203e3:	62 91 4d 40 72 d7 03 	vpsrld $0x3,%zmm31,%zmm22
  c203ea:	62 e3 7d 58 25 35 3b 02 96 ff ec 	vpternlogd $0xec,-0x69fdc5(%rip){1to16},%zmm0,%zmm22        # 580630 <tier0_emit_x87.operations+0x1e8>
  c203f5:	62 f2 7d 48 5a 05 61 60 95 ff 	vbroadcasti32x4 -0x6a9f9f(%rip),%zmm0        # 576460 <x86_effects_unknown+0xa00>
  c203ff:	62 93 3d 48 25 e3 b8 	vpternlogd $0xb8,%zmm27,%zmm8,%zmm4
  c20406:	62 61 75 58 db 1d 34 02 96 ff 	vpandd -0x69fdcc(%rip){1to16},%zmm1,%zmm27        # 580644 <tier0_emit_x87.operations+0x1fc>
  c20410:	62 d1 4d 48 fe cc    	vpaddd %zmm12,%zmm6,%zmm1
  c20416:	62 f1 75 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm1
  c2041d:	62 93 3d 48 25 d3 b8 	vpternlogd $0xb8,%zmm27,%zmm8,%zmm2
  c20424:	62 51 8d 48 6c c7    	vpunpcklqdq %zmm15,%zmm14,%zmm8
  c2042a:	62 11 9d 40 6d f5    	vpunpckhqdq %zmm29,%zmm28,%zmm14
  c20430:	62 f1 3d 48 6a f7    	vpunpckhdq %zmm7,%zmm8,%zmm6
  c20436:	62 51 0d 48 eb d2    	vpord  %zmm10,%zmm14,%zmm10
  c2043c:	62 71 6d 48 eb fd    	vpord  %zmm5,%zmm2,%zmm15
  c20442:	62 b1 6d 48 72 f6 08 	vpslld $0x8,%zmm22,%zmm2
  c20449:	62 f3 75 58 25 15 f8 01 96 ff 08 	vpternlogd $0x8,-0x69fe08(%rip){1to16},%zmm1,%zmm2        # 58064c <tier0_emit_x87.operations+0x204>
  c20454:	62 d1 55 48 72 f2 07 	vpslld $0x7,%zmm10,%zmm5
  c2045b:	62 f3 55 58 25 15 ea 01 96 ff d8 	vpternlogd $0xd8,-0x69fe16(%rip){1to16},%zmm5,%zmm2        # 580650 <tier0_emit_x87.operations+0x208>
  c20466:	62 d2 fd 48 83 ee    	vpmultishiftqb %zmm14,%zmm0,%zmm5
  c2046c:	62 f3 4d 50 25 2d dd 01 96 ff d8 	vpternlogd $0xd8,-0x69fe23(%rip){1to16},%zmm22,%zmm5        # 580654 <tier0_emit_x87.operations+0x20c>
  c20477:	62 d1 7d 48 70 c7 55 	vpshufd $0x55,%zmm15,%zmm0
  c2047e:	62 b2 7d 48 8f d0    	vpshufbitqmb %zmm16,%zmm0,%k2
  c20484:	c4 61 fb 93 f2       	kmovq  %k2,%r14
  c20489:	f3 4d 0f b8 f6       	popcnt %r14,%r14
  c2048e:	62 f3 6d 58 25 2d bf 01 96 ff d8 	vpternlogd $0xd8,-0x69fe41(%rip){1to16},%zmm2,%zmm5        # 580658 <tier0_emit_x87.operations+0x210>
  c20499:	62 f1 3d 48 62 d7    	vpunpckldq %zmm7,%zmm8,%zmm2
  c2049f:	62 f1 5d 48 62 fd    	vpunpckldq %zmm5,%zmm4,%zmm7
  c204a5:	62 f1 5d 48 6a e5    	vpunpckhdq %zmm5,%zmm4,%zmm4
  c204ab:	62 f1 ed 48 6c ef    	vpunpcklqdq %zmm7,%zmm2,%zmm5
  c204b1:	62 f1 ed 48 6d d7    	vpunpckhqdq %zmm7,%zmm2,%zmm2
  c204b7:	62 f1 cd 48 6c fc    	vpunpcklqdq %zmm4,%zmm6,%zmm7
  c204bd:	62 f1 cd 48 6d e4    	vpunpckhqdq %zmm4,%zmm6,%zmm4
  c204c3:	62 d1 7d 48 70 f7 00 	vpshufd $0x0,%zmm15,%zmm6
  c204ca:	62 d2 55 48 00 eb    	vpshufb %zmm11,%zmm5,%zmm5
  c204d0:	62 d2 4d 48 8f db    	vpshufbitqmb %zmm11,%zmm6,%k3
  c204d6:	62 b2 6d 48 00 d0    	vpshufb %zmm16,%zmm2,%zmm2
  c204dc:	62 b2 45 48 00 c2    	vpshufb %zmm18,%zmm7,%zmm0
  c204e2:	62 f3 95 48 25 eb 78 	vpternlogq $0x78,%zmm3,%zmm13,%zmm5
  c204e9:	62 f3 f5 40 25 d3 78 	vpternlogq $0x78,%zmm3,%zmm17,%zmm2
  c204f0:	62 f3 e5 40 25 c3 78 	vpternlogq $0x78,%zmm3,%zmm19,%zmm0
  c204f7:	62 f2 7d cb 63 ed    	vpcompressb %zmm5,%zmm5{%k3}{z}
  c204fd:	62 f2 7d ca 63 d2    	vpcompressb %zmm2,%zmm2{%k2}{z}
  c20503:	c4 61 fb 93 db       	kmovq  %k3,%r11
  c20508:	f3 4d 0f b8 db       	popcnt %r11,%r11
  c2050d:	62 f1 fe 48 7f 2f    	vmovdqu64 %zmm5,(%rdi)
  c20513:	62 d1 7d 48 70 ef aa 	vpshufd $0xaa,%zmm15,%zmm5
  c2051a:	62 b1 fe 48 7f 14 1f 	vmovdqu64 %zmm2,(%rdi,%r11,1)
  c20521:	49 01 fb             	add    %rdi,%r11
  c20524:	29 df                	sub    %ebx,%edi
  c20526:	62 b2 55 48 8f da    	vpshufbitqmb %zmm18,%zmm5,%k3
  c2052c:	62 d1 7d 48 70 ef ff 	vpshufd $0xff,%zmm15,%zmm5
  c20533:	62 73 5d 50 25 3d 1e 01 96 ff 20 	vpternlogd $0x20,-0x69fee2(%rip){1to16},%zmm20,%zmm15        # 58065c <tier0_emit_x87.operations+0x214>
  c2053e:	62 b2 55 48 8f d5    	vpshufbitqmb %zmm21,%zmm5,%k2
  c20544:	c5 e9 ef d2          	vpxor  %xmm2,%xmm2,%xmm2
  c20548:	62 f2 7d cb 63 c2    	vpcompressb %zmm0,%zmm2{%k3}{z}
  c2054e:	62 b2 5d 48 00 c5    	vpshufb %zmm21,%zmm4,%zmm0
  c20554:	62 f1 5d 50 db 25 02 01 96 ff 	vpandd -0x69fefe(%rip){1to16},%zmm20,%zmm4        # 580660 <tier0_emit_x87.operations+0x218>
  c2055e:	62 f3 c5 40 25 c3 78 	vpternlogq $0x78,%zmm3,%zmm23,%zmm0
  c20565:	62 91 fe 48 7f 14 1e 	vmovdqu64 %zmm2,(%r14,%r11,1)
  c2056c:	c5 e9 ef d2          	vpxor  %xmm2,%xmm2,%xmm2
  c20570:	62 f2 7d ca 63 c2    	vpcompressb %zmm0,%zmm2{%k2}{z}
  c20576:	62 d2 7d 48 55 c7    	vpopcntd %zmm15,%zmm0
  c2057c:	4d 01 f3             	add    %r14,%r11
  c2057f:	c4 61 fb 93 f3       	kmovq  %k3,%r14
  c20584:	f3 4d 0f b8 fe       	popcnt %r14,%r15
  c20589:	62 f1 75 48 fe cc    	vpaddd %zmm4,%zmm1,%zmm1
  c2058f:	62 f1 75 48 fe c8    	vpaddd %zmm0,%zmm1,%zmm1
  c20595:	c5 f9 6f 05 53 5e 95 ff 	vmovdqa -0x6aa1ad(%rip),%xmm0        # 5763f0 <x86_effects_unknown+0x990>
  c2059d:	62 91 fe 48 7f 14 1f 	vmovdqu64 %zmm2,(%r15,%r11,1)
  c205a4:	89 7c 24 40          	mov    %edi,0x40(%rsp)
  c205a8:	c4 e1 fb 93 fa       	kmovq  %k2,%rdi
  c205ad:	f3 4c 0f b8 f7       	popcnt %rdi,%r14
  c205b2:	4d 01 fe             	add    %r15,%r14
  c205b5:	4d 01 de             	add    %r11,%r14
  c205b8:	62 f2 7d 48 8d c9    	vpermb %zmm1,%zmm0,%zmm1
  c205be:	c5 f9 6f 05 3a 5e 95 ff 	vmovdqa -0x6aa1c6(%rip),%xmm0        # 576400 <x86_effects_unknown+0x9a0>
  c205c6:	62 f2 f5 18 40 0d 70 fe 95 ff 	vpmullq -0x6a0190(%rip){1to2},%xmm1,%xmm1        # 580440 <x86_semantics_benchmark_code.registers+0x450>
  c205d0:	62 d2 7d 48 8d d6    	vpermb %zmm14,%zmm0,%zmm2
  c205d6:	c4 e2 71 00 05 31 5e 95 ff 	vpshufb -0x6aa1cf(%rip),%xmm1,%xmm0        # 576410 <x86_effects_unknown+0x9b0>
  c205df:	62 f2 7e 48 29 da    	vpmovb2m %zmm2,%k3
  c205e5:	c5 fb 93 fb          	kmovd  %k3,%edi
  c205e9:	0f b7 ff             	movzwl %di,%edi
  c205ec:	c5 f9 fc c9          	vpaddb %xmm1,%xmm0,%xmm1
  c205f0:	f3 0f b8 ff          	popcnt %edi,%edi
  c205f4:	49 ff c8             	dec    %r8
  c205f7:	62 f2 7d 48 31 c9    	vpmovzxbd %xmm1,%zmm1
  c205fd:	62 f1 75 58 fe 4c 24 10 	vpaddd 0x40(%rsp){1to16},%zmm1,%zmm1
  c20605:	62 f2 7d cb 8b c9    	vpcompressd %zmm1,%zmm1{%k3}{z}
  c2060b:	62 f1 fe 48 7f 09    	vmovdqu64 %zmm1,(%rcx)
  c20611:	48 8d 0c b9          	lea    (%rcx,%rdi,4),%rcx
  c20615:	4c 89 f7             	mov    %r14,%rdi
  c20618:	0f 85 12 fa ff ff    	jne    c20030 <x86_encode_16+0x6f0>
  c2061e:	48 29 c2             	sub    %rax,%rdx
  c20621:	0f 86 b1 17 00 00    	jbe    c21dd8 <x86_encode_16+0x2498>
  c20627:	48 c1 e0 04          	shl    $0x4,%rax
  c2062b:	48 c1 e2 04          	shl    $0x4,%rdx
  c2062f:	48 8d 7c 24 40       	lea    0x40(%rsp),%rdi
  c20634:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
  c20638:	62 f1 fd 48 7f 44 24 04 	vmovdqa64 %zmm0,0x100(%rsp)
  c20640:	62 f1 fd 48 7f 44 24 03 	vmovdqa64 %zmm0,0xc0(%rsp)
  c20648:	62 f1 fd 48 7f 44 24 02 	vmovdqa64 %zmm0,0x80(%rsp)
  c20650:	62 f1 fd 48 7f 44 24 01 	vmovdqa64 %zmm0,0x40(%rsp)
  c20658:	49 89 cf             	mov    %rcx,%r15
  c2065b:	48 01 c6             	add    %rax,%rsi
  c2065e:	c5 f8 77             	vzeroupper
  c20661:	e8 ea 3d b4 ff       	call   764450 <memcpy@plt>
  c20666:	c5 f9 6f 4c 24 40    	vmovdqa 0x40(%rsp),%xmm1
  c2066c:	c5 f9 6f 54 24 50    	vmovdqa 0x50(%rsp),%xmm2
  c20672:	c5 f9 6f 5c 24 60    	vmovdqa 0x60(%rsp),%xmm3
  c20678:	c5 f9 6f 64 24 70    	vmovdqa 0x70(%rsp),%xmm4
  c2067e:	48 8d 05 7b 5e a4 0d 	lea    0xda45e7b(%rip),%rax        # e666500 <x86_template_storage>
  c20685:	c5 f9 6f b4 24 80 00 00 00 	vmovdqa 0x80(%rsp),%xmm6
  c2068e:	62 71 fd 48 6f 3d e8 1e 90 ff 	vmovdqa64 -0x6fe118(%rip),%zmm15        # 522580 <branch_sizing_patterns+0x27f0>
  c20698:	c5 f9 6f bc 24 c0 00 00 00 	vmovdqa 0xc0(%rsp),%xmm7
  c206a1:	c5 79 6f 84 24 e0 00 00 00 	vmovdqa 0xe0(%rsp),%xmm8
  c206aa:	62 f1 fd 48 6f 6c 24 01 	vmovdqa64 0x40(%rsp),%zmm5
  c206b2:	62 71 fd 48 6f 54 24 02 	vmovdqa64 0x80(%rsp),%zmm10
  c206ba:	62 71 fd 48 6f 5c 24 03 	vmovdqa64 0xc0(%rsp),%zmm11
  c206c2:	62 71 fd 48 6f 64 24 04 	vmovdqa64 0x100(%rsp),%zmm12
  c206ca:	62 e2 7d 48 5a 0d 5c 5d 95 ff 	vbroadcasti32x4 -0x6aa2a4(%rip),%zmm17        # 576430 <x86_effects_unknown+0x9d0>
  c206d4:	62 a3 4d 40 25 f6 ff 	vpternlogd $0xff,%zmm22,%zmm22,%zmm22
  c206db:	62 e2 7d 48 58 25 1f ff 95 ff 	vpbroadcastd -0x6a00e1(%rip),%zmm20        # 580604 <tier0_emit_x87.operations+0x1bc>
  c206e5:	62 62 7d 48 58 1d 21 ff 95 ff 	vpbroadcastd -0x6a00df(%rip),%zmm27        # 580610 <tier0_emit_x87.operations+0x1c8>
  c206ef:	62 62 7d 48 58 0d 1b ff 95 ff 	vpbroadcastd -0x6a00e5(%rip),%zmm25        # 580614 <tier0_emit_x87.operations+0x1cc>
  c206f9:	c5 f9 c5 c9 06       	vpextrw $0x6,%xmm1,%ecx
  c206fe:	c5 f9 c5 d2 06       	vpextrw $0x6,%xmm2,%edx
  c20703:	c5 f9 c5 fc 06       	vpextrw $0x6,%xmm4,%edi
  c20708:	c5 f9 c5 f3 06       	vpextrw $0x6,%xmm3,%esi
  c2070d:	c5 f9 6f a4 24 90 00 00 00 	vmovdqa 0x90(%rsp),%xmm4
  c20716:	62 51 55 48 62 ea    	vpunpckldq %zmm10,%zmm5,%zmm13
  c2071c:	62 51 25 48 62 f4    	vpunpckldq %zmm12,%zmm11,%zmm14
  c20722:	62 d1 55 48 6a ea    	vpunpckhdq %zmm10,%zmm5,%zmm5
  c20728:	62 51 25 48 6a d4    	vpunpckhdq %zmm12,%zmm11,%zmm10
  c2072e:	c1 e1 06             	shl    $0x6,%ecx
  c20731:	c1 e2 06             	shl    $0x6,%edx
  c20734:	c1 e6 06             	shl    $0x6,%esi
  c20737:	c1 e7 06             	shl    $0x6,%edi
  c2073a:	62 51 95 48 6d de    	vpunpckhqdq %zmm14,%zmm13,%zmm11
  c20740:	62 d1 95 48 6c c6    	vpunpcklqdq %zmm14,%zmm13,%zmm0
  c20746:	62 51 d5 48 6c ea    	vpunpcklqdq %zmm10,%zmm5,%zmm13
  c2074c:	62 d1 d5 48 6d ea    	vpunpckhqdq %zmm10,%zmm5,%zmm5
  c20752:	c5 fd 6f 4c 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm1
  c20758:	c5 fd 6f 54 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm2
  c2075e:	b1 cc                	mov    $0xcc,%cl
  c20760:	62 d1 0d 48 72 d5 1a 	vpsrld $0x1a,%zmm13,%zmm14
  c20767:	62 e2 0d 48 36 1d 8f 1e 90 ff 	vpermd -0x6fe171(%rip),%zmm14,%zmm19        # 522600 <branch_sizing_patterns+0x2870>
  c20771:	62 d2 25 48 27 c3    	vptestmd %zmm11,%zmm11,%k0
  c20777:	62 d1 6d 40 72 e3 1f 	vpsrad $0x1f,%zmm11,%zmm18
  c2077e:	62 21 25 48 fe c6    	vpaddd %zmm22,%zmm11,%zmm24
  c20784:	62 43 5d 40 25 cd 6c 	vpternlogd $0x6c,%zmm13,%zmm20,%zmm25
  c2078b:	62 f3 f5 48 3a 4c 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm1,%zmm1
  c20794:	62 f3 ed 48 3a 5c 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm2,%zmm3
  c2079d:	c5 fb 92 c9          	kmovd  %ecx,%k1
  c207a1:	c5 f9 c5 ce 06       	vpextrw $0x6,%xmm6,%ecx
  c207a6:	c5 f9 6f b4 24 a0 00 00 00 	vmovdqa 0xa0(%rsp),%xmm6
  c207af:	c1 e1 06             	shl    $0x6,%ecx
  c207b2:	c5 f9 c5 d4 06       	vpextrw $0x6,%xmm4,%edx
  c207b7:	c5 f9 6f a4 24 b0 00 00 00 	vmovdqa 0xb0(%rsp),%xmm4
  c207c0:	c1 e2 06             	shl    $0x6,%edx
  c207c3:	62 f2 f5 49 64 d3    	vpblendmq %zmm3,%zmm1,%zmm2{%k1}
  c207c9:	62 f2 85 48 7e cb    	vpermt2q %zmm3,%zmm15,%zmm1
  c207cf:	c5 fd 6f 5c 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm3
  c207d5:	c5 f9 c5 cf 06       	vpextrw $0x6,%xmm7,%ecx
  c207da:	c5 f9 6f bc 24 d0 00 00 00 	vmovdqa 0xd0(%rsp),%xmm7
  c207e3:	c5 f9 c5 f6 06       	vpextrw $0x6,%xmm6,%esi
  c207e8:	c1 e6 06             	shl    $0x6,%esi
  c207eb:	c1 e1 06             	shl    $0x6,%ecx
  c207ee:	62 f3 e5 48 3a 5c 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm3,%zmm3
  c207f7:	c4 c1 79 c5 f0 06    	vpextrw $0x6,%xmm8,%esi
  c207fd:	c1 e6 06             	shl    $0x6,%esi
  c20800:	c5 f9 c5 fc 06       	vpextrw $0x6,%xmm4,%edi
  c20805:	c5 fd 6f 64 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm4
  c2080b:	c1 e7 06             	shl    $0x6,%edi
  c2080e:	62 f3 dd 48 3a 74 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm4,%zmm6
  c20817:	c5 f9 c5 d7 06       	vpextrw $0x6,%xmm7,%edx
  c2081c:	c5 f9 6f bc 24 f0 00 00 00 	vmovdqa 0xf0(%rsp),%xmm7
  c20825:	c1 e2 06             	shl    $0x6,%edx
  c20828:	62 f2 e5 49 64 e6    	vpblendmq %zmm6,%zmm3,%zmm4{%k1}
  c2082e:	62 f2 85 48 7e de    	vpermt2q %zmm6,%zmm15,%zmm3
  c20834:	c5 fd 6f 74 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm6
  c2083a:	0f b7 8c 24 0c 01 00 00 	movzwl 0x10c(%rsp),%ecx
  c20842:	c5 f9 c5 ff 06       	vpextrw $0x6,%xmm7,%edi
  c20847:	c5 fd 6f 7c 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm7
  c2084d:	62 f3 cd 48 3a 74 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm6,%zmm6
  c20856:	0f b7 94 24 1c 01 00 00 	movzwl 0x11c(%rsp),%edx
  c2085e:	0f b7 b4 24 2c 01 00 00 	movzwl 0x12c(%rsp),%esi
  c20866:	62 71 6d 48 6a d4    	vpunpckhdq %zmm4,%zmm2,%zmm10
  c2086c:	c1 e7 06             	shl    $0x6,%edi
  c2086f:	62 73 c5 48 3a 44 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm7,%zmm8
  c20878:	0f b7 bc 24 3c 01 00 00 	movzwl 0x13c(%rsp),%edi
  c20880:	c1 e1 06             	shl    $0x6,%ecx
  c20883:	c1 e2 06             	shl    $0x6,%edx
  c20886:	c1 e6 06             	shl    $0x6,%esi
  c20889:	c5 7d 6f 4c 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm9
  c2088f:	c1 e7 06             	shl    $0x6,%edi
  c20892:	62 e3 b5 48 3a 44 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm9,%zmm16
  c2089b:	62 d2 cd 49 64 f8    	vpblendmq %zmm8,%zmm6,%zmm7{%k1}
  c208a1:	62 d2 85 48 7e f0    	vpermt2q %zmm8,%zmm15,%zmm6
  c208a7:	c5 7d 6f 44 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm8
  c208ad:	62 73 bd 48 3a 44 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm8,%zmm8
  c208b6:	62 32 bd 49 64 c8    	vpblendmq %zmm16,%zmm8,%zmm9{%k1}
  c208bc:	62 32 85 48 7e c0    	vpermt2q %zmm16,%zmm15,%zmm8
  c208c2:	62 e2 7d 48 5a 05 54 5b 95 ff 	vbroadcasti32x4 -0x6aa4ac(%rip),%zmm16        # 576420 <x86_effects_unknown+0x9c0>
  c208cc:	62 72 0d 48 36 3d ea 1c 90 ff 	vpermd -0x6fe316(%rip),%zmm14,%zmm15        # 5225c0 <branch_sizing_patterns+0x2830>
  c208d6:	62 72 0d 48 36 35 60 1d 90 ff 	vpermd -0x6fe2a0(%rip),%zmm14,%zmm14        # 522640 <branch_sizing_patterns+0x28b0>
  c208e0:	62 51 45 48 6a e1    	vpunpckhdq %zmm9,%zmm7,%zmm12
  c208e6:	62 51 ad 48 6d d4    	vpunpckhqdq %zmm12,%zmm10,%zmm10
  c208ec:	62 d1 45 40 72 d2 1d 	vpsrld $0x1d,%zmm10,%zmm23
  c208f3:	62 52 fd 40 83 e5    	vpmultishiftqb %zmm13,%zmm16,%zmm12
  c208f9:	62 e2 7d 48 5a 05 3d 5b 95 ff 	vbroadcasti32x4 -0x6aa4c3(%rip),%zmm16        # 576440 <x86_effects_unknown+0x9e0>
  c20903:	62 c2 fd 40 83 c5    	vpmultishiftqb %zmm13,%zmm16,%zmm16
  c20909:	62 e3 1d 58 25 05 e8 fc 95 ff d8 	vpternlogd $0xd8,-0x6a0318(%rip){1to16},%zmm12,%zmm16        # 5805fc <tier0_emit_x87.operations+0x1b4>
  c20914:	62 52 f5 40 83 e5    	vpmultishiftqb %zmm13,%zmm17,%zmm12
  c2091a:	62 e2 7d 48 5a 0d 2c 5b 95 ff 	vbroadcasti32x4 -0x6aa4d4(%rip),%zmm17        # 576450 <x86_effects_unknown+0x9f0>
  c20924:	62 73 7d 50 25 25 d1 fc 95 ff e4 	vpternlogd $0xe4,-0x6a032f(%rip){1to16},%zmm16,%zmm12        # 580600 <tier0_emit_x87.operations+0x1b8>
  c2092f:	62 c2 75 40 00 ed    	vpshufb %zmm13,%zmm17,%zmm21
  c20935:	62 d1 7d 40 72 f5 04 	vpslld $0x4,%zmm13,%zmm16
  c2093c:	62 b1 7d 40 72 e0 1f 	vpsrad $0x1f,%zmm16,%zmm16
  c20943:	62 c3 1d 48 25 df f8 	vpternlogd $0xf8,%zmm15,%zmm12,%zmm19
  c2094a:	62 b1 05 48 72 f5 10 	vpslld $0x10,%zmm21,%zmm15
  c20951:	62 d1 75 40 72 e7 1f 	vpsrad $0x1f,%zmm15,%zmm17
  c20958:	62 72 7e 48 38 f8    	vpmovm2d %k0,%zmm15
  c2095e:	62 23 7d 40 25 db ea 	vpternlogd $0xea,%zmm19,%zmm16,%zmm27
  c20965:	62 b1 2d 40 72 d3 10 	vpsrld $0x10,%zmm19,%zmm26
  c2096c:	62 33 7d 40 25 f9 c8 	vpternlogd $0xc8,%zmm17,%zmm16,%zmm15
  c20973:	62 c1 6d 40 ef cb    	vpxord %zmm11,%zmm18,%zmm17
  c20979:	62 e2 7d 48 58 15 85 fc 95 ff 	vpbroadcastd -0x6a037b(%rip),%zmm18        # 580608 <tier0_emit_x87.operations+0x1c0>
  c20983:	62 a2 7d 48 44 c9    	vplzcntd %zmm17,%zmm17
  c20989:	62 a2 6d 40 45 c9    	vpsrlvd %zmm17,%zmm18,%zmm17
  c2098f:	62 23 25 48 25 c1 14 	vpternlogd $0x14,%zmm17,%zmm11,%zmm24
  c20996:	62 a2 3d 40 14 cf    	vprorvd %zmm23,%zmm24,%zmm17
  c2099c:	62 62 7d 48 58 05 66 fc 95 ff 	vpbroadcastd -0x6a039a(%rip),%zmm24        # 58060c <tier0_emit_x87.operations+0x1c4>
  c209a6:	62 b1 75 40 72 e1 1f 	vpsrad $0x1f,%zmm17,%zmm17
  c209ad:	62 23 05 48 25 c3 ea 	vpternlogd $0xea,%zmm19,%zmm15,%zmm24
  c209b4:	62 b1 65 40 72 d3 03 	vpsrld $0x3,%zmm19,%zmm19
  c209bb:	62 e3 2d 50 25 1d 6a fc 95 ff ec 	vpternlogd $0xec,-0x6a0396(%rip){1to16},%zmm26,%zmm19        # 580630 <tier0_emit_x87.operations+0x1e8>
  c209c6:	62 03 75 40 25 d8 b8 	vpternlogd $0xb8,%zmm24,%zmm17,%zmm27
  c209cd:	62 21 35 40 fe c6    	vpaddd %zmm22,%zmm25,%zmm24
  c209d3:	62 d1 35 40 72 d5 08 	vpsrld $0x8,%zmm13,%zmm25
  c209da:	62 63 5d 50 25 0d 33 fc 95 ff 6c 	vpternlogd $0x6c,-0x6a03cd(%rip){1to16},%zmm20,%zmm25        # 580618 <tier0_emit_x87.operations+0x1d0>
  c209e5:	62 51 55 48 eb ed    	vpord  %zmm13,%zmm5,%zmm13
  c209eb:	62 d1 2d 40 72 f5 07 	vpslld $0x7,%zmm13,%zmm26
  c209f2:	62 31 7d 40 db ed    	vpandd %zmm21,%zmm16,%zmm13
  c209f8:	62 73 0d 58 25 2d 39 fc 95 ff ec 	vpternlogd $0xec,-0x6a03c7(%rip){1to16},%zmm14,%zmm13        # 58063c <tier0_emit_x87.operations+0x1f4>
  c20a03:	62 71 05 58 db 35 37 fc 95 ff 	vpandd -0x6a03c9(%rip){1to16},%zmm15,%zmm14        # 580644 <tier0_emit_x87.operations+0x1fc>
  c20a0d:	62 e1 7d 50 db 05 31 fc 95 ff 	vpandd -0x6a03cf(%rip){1to16},%zmm16,%zmm16        # 580648 <tier0_emit_x87.operations+0x200>
  c20a17:	62 73 2d 58 25 2d 1e fc 95 ff f8 	vpternlogd $0xf8,-0x6a03e2(%rip){1to16},%zmm10,%zmm13        # 580640 <tier0_emit_x87.operations+0x1f8>
  c20a22:	62 a1 35 40 fe e6    	vpaddd %zmm22,%zmm25,%zmm20
  c20a28:	62 62 7d 48 58 0d ea fb 95 ff 	vpbroadcastd -0x6a0416(%rip),%zmm25        # 58061c <tier0_emit_x87.operations+0x1d4>
  c20a32:	62 63 3d 50 25 0d e3 fb 95 ff ea 	vpternlogd $0xea,-0x6a041d(%rip){1to16},%zmm24,%zmm25        # 580620 <tier0_emit_x87.operations+0x1d8>
  c20a3d:	62 b1 3d 40 72 f3 08 	vpslld $0x8,%zmm19,%zmm24
  c20a44:	62 c3 75 40 25 c6 b8 	vpternlogd $0xb8,%zmm14,%zmm17,%zmm16
  c20a4b:	62 d1 0d 48 72 cb 01 	vprold $0x1,%zmm11,%zmm14
  c20a52:	62 63 5d 50 25 0d c7 fb 95 ff f8 	vpternlogd $0xf8,-0x6a0439(%rip){1to16},%zmm20,%zmm25        # 580624 <tier0_emit_x87.operations+0x1dc>
  c20a5d:	62 e1 1d 58 db 25 c1 fb 95 ff 	vpandd -0x6a043f(%rip){1to16},%zmm12,%zmm20        # 580628 <tier0_emit_x87.operations+0x1e0>
  c20a67:	62 32 0d 48 14 f7    	vprorvd %zmm23,%zmm14,%zmm14
  c20a6d:	62 53 05 48 25 f3 e2 	vpternlogd $0xe2,%zmm11,%zmm15,%zmm14
  c20a74:	62 53 75 40 25 f3 e2 	vpternlogd $0xe2,%zmm11,%zmm17,%zmm14
  c20a7b:	62 e2 7d 48 5a 0d 5b 59 95 ff 	vbroadcasti32x4 -0x6aa6a5(%rip),%zmm17        # 5763e0 <x86_effects_unknown+0x980>
  c20a85:	62 51 7d 48 62 de    	vpunpckldq %zmm14,%zmm0,%zmm11
  c20a8b:	62 d1 7d 48 6a c6    	vpunpckhdq %zmm14,%zmm0,%zmm0
  c20a91:	62 83 2d 48 25 e1 f8 	vpternlogd $0xf8,%zmm25,%zmm10,%zmm20
  c20a98:	62 d1 35 40 72 d4 03 	vpsrld $0x3,%zmm12,%zmm25
  c20a9f:	62 63 2d 58 25 0d 8a fb 95 ff a2 	vpternlogd $0xa2,-0x6a0476(%rip){1to16},%zmm10,%zmm25        # 580634 <tier0_emit_x87.operations+0x1ec>
  c20aaa:	62 e2 5d 50 3b 25 78 fb 95 ff 	vpminud -0x6a0488(%rip){1to16},%zmm20,%zmm20        # 58062c <tier0_emit_x87.operations+0x1e4>
  c20ab4:	62 31 35 40 fe e6    	vpaddd %zmm22,%zmm25,%zmm12
  c20aba:	62 e2 35 50 3b 35 74 fb 95 ff 	vpminud -0x6a048c(%rip){1to16},%zmm25,%zmm22        # 580638 <tier0_emit_x87.operations+0x1f0>
  c20ac4:	62 62 7d 48 5a 0d 92 59 95 ff 	vbroadcasti32x4 -0x6aa66e(%rip),%zmm25        # 576460 <x86_effects_unknown+0xa00>
  c20ace:	62 d1 1d 48 72 e4 1f 	vpsrad $0x1f,%zmm12,%zmm12
  c20ad5:	62 63 1d 58 25 05 6c fb 95 ff 08 	vpternlogd $0x8,-0x6a0494(%rip){1to16},%zmm12,%zmm24        # 58064c <tier0_emit_x87.operations+0x204>
  c20ae0:	62 63 2d 50 25 05 65 fb 95 ff d8 	vpternlogd $0xd8,-0x6a049b(%rip){1to16},%zmm26,%zmm24        # 580650 <tier0_emit_x87.operations+0x208>
  c20aeb:	62 62 b5 40 83 cd    	vpmultishiftqb %zmm5,%zmm25,%zmm25
  c20af1:	62 63 65 50 25 0d 58 fb 95 ff d8 	vpternlogd $0xd8,-0x6a04a8(%rip){1to16},%zmm19,%zmm25        # 580654 <tier0_emit_x87.operations+0x20c>
  c20afc:	62 33 4d 40 25 ec fe 	vpternlogd $0xfe,%zmm20,%zmm22,%zmm13
  c20b03:	62 51 7d 40 eb ed    	vpord  %zmm13,%zmm16,%zmm13
  c20b09:	62 c1 7d 48 70 d5 00 	vpshufd $0x0,%zmm13,%zmm18
  c20b10:	62 63 3d 50 25 0d 3d fb 95 ff d8 	vpternlogd $0xd8,-0x6a04c3(%rip){1to16},%zmm24,%zmm25        # 580658 <tier0_emit_x87.operations+0x210>
  c20b1b:	62 f2 6d 40 8f c9    	vpshufbitqmb %zmm1,%zmm18,%k1
  c20b21:	c4 e1 fb 93 c1       	kmovq  %k1,%rax
  c20b26:	f3 48 0f b8 c0       	popcnt %rax,%rax
  c20b2b:	49 8d 0c 06          	lea    (%r14,%rax,1),%rcx
  c20b2f:	62 11 25 40 62 f1    	vpunpckldq %zmm25,%zmm27,%zmm14
  c20b35:	62 11 25 40 6a f9    	vpunpckhdq %zmm25,%zmm27,%zmm15
  c20b3b:	62 c1 a5 48 6c c6    	vpunpcklqdq %zmm14,%zmm11,%zmm16
  c20b41:	62 c1 fd 48 6c df    	vpunpcklqdq %zmm15,%zmm0,%zmm19
  c20b47:	62 d1 fd 48 6d c7    	vpunpckhqdq %zmm15,%zmm0,%zmm0
  c20b4d:	62 51 a5 48 6d de    	vpunpckhqdq %zmm14,%zmm11,%zmm11
  c20b53:	62 51 7d 48 70 fd 55 	vpshufd $0x55,%zmm13,%zmm15
  c20b5a:	62 e2 7d 40 00 c1    	vpshufb %zmm1,%zmm16,%zmm16
  c20b60:	62 d2 7d 48 00 c0    	vpshufb %zmm8,%zmm0,%zmm0
  c20b66:	62 a3 ed 48 25 c1 78 	vpternlogq $0x78,%zmm17,%zmm2,%zmm16
  c20b6d:	62 f2 25 48 00 d3    	vpshufb %zmm3,%zmm11,%zmm2
  c20b73:	62 b3 b5 48 25 c1 78 	vpternlogq $0x78,%zmm17,%zmm9,%zmm0
  c20b7a:	62 e2 7d c9 63 c1    	vpcompressb %zmm16,%zmm1{%k1}{z}
  c20b80:	62 f2 05 48 8f cb    	vpshufbitqmb %zmm3,%zmm15,%k1
  c20b86:	62 d1 7d 48 70 dd aa 	vpshufd $0xaa,%zmm13,%zmm3
  c20b8d:	62 b3 dd 48 25 d1 78 	vpternlogq $0x78,%zmm17,%zmm4,%zmm2
  c20b94:	62 d1 7d 48 70 e5 ff 	vpshufd $0xff,%zmm13,%zmm4
  c20b9b:	62 73 2d 58 25 2d b6 fa 95 ff 20 	vpternlogd $0x20,-0x6a054a(%rip){1to16},%zmm10,%zmm13        # 58065c <tier0_emit_x87.operations+0x214>
  c20ba6:	c4 e1 fb 93 d1       	kmovq  %k1,%rdx
  c20bab:	f3 48 0f b8 d2       	popcnt %rdx,%rdx
  c20bb0:	62 d1 fe 48 7f 0e    	vmovdqu64 %zmm1,(%r14)
  c20bb6:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
  c20bba:	62 f2 7d c9 63 d1    	vpcompressb %zmm2,%zmm1{%k1}{z}
  c20bc0:	62 f2 65 40 00 d6    	vpshufb %zmm6,%zmm19,%zmm2
  c20bc6:	62 f2 65 48 8f ce    	vpshufbitqmb %zmm6,%zmm3,%k1
  c20bcc:	62 f1 2d 58 db 1d 8a fa 95 ff 	vpandd -0x6a0576(%rip){1to16},%zmm10,%zmm3        # 580660 <tier0_emit_x87.operations+0x218>
  c20bd6:	48 8d 34 11          	lea    (%rcx,%rdx,1),%rsi
  c20bda:	62 b3 c5 48 25 d1 78 	vpternlogq $0x78,%zmm17,%zmm7,%zmm2
  c20be1:	62 d1 fe 48 7f 0c 06 	vmovdqu64 %zmm1,(%r14,%rax,1)
  c20be8:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
  c20bec:	62 f2 7d c9 63 d1    	vpcompressb %zmm2,%zmm1{%k1}{z}
  c20bf2:	c4 e1 fb 93 c1       	kmovq  %k1,%rax
  c20bf7:	62 d2 5d 48 8f c8    	vpshufbitqmb %zmm8,%zmm4,%k1
  c20bfd:	41 29 de             	sub    %ebx,%r14d
  c20c00:	f3 48 0f b8 f8       	popcnt %rax,%rdi
  c20c05:	62 f2 7d c9 63 c0    	vpcompressb %zmm0,%zmm0{%k1}{z}
  c20c0b:	c4 e1 fb 93 c1       	kmovq  %k1,%rax
  c20c10:	f3 48 0f b8 c0       	popcnt %rax,%rax
  c20c15:	62 f1 fe 48 7f 0c 0a 	vmovdqu64 %zmm1,(%rdx,%rcx,1)
  c20c1c:	62 f1 1d 48 fe cb    	vpaddd %zmm3,%zmm12,%zmm1
  c20c22:	48 01 f8             	add    %rdi,%rax
  c20c25:	48 01 f0             	add    %rsi,%rax
  c20c28:	62 f1 fe 48 7f 04 37 	vmovdqu64 %zmm0,(%rdi,%rsi,1)
  c20c2f:	62 d2 7d 48 55 c5    	vpopcntd %zmm13,%zmm0
  c20c35:	44 89 74 24 3c       	mov    %r14d,0x3c(%rsp)
  c20c3a:	49 89 c6             	mov    %rax,%r14
  c20c3d:	62 f1 75 48 fe c0    	vpaddd %zmm0,%zmm1,%zmm0
  c20c43:	c5 f9 6f 0d a5 57 95 ff 	vmovdqa -0x6aa85b(%rip),%xmm1        # 5763f0 <x86_effects_unknown+0x990>
  c20c4b:	62 f2 75 48 8d c0    	vpermb %zmm0,%zmm1,%zmm0
  c20c51:	62 f2 fd 18 40 05 e5 f7 95 ff 	vpmullq -0x6a081b(%rip){1to2},%xmm0,%xmm0        # 580440 <x86_semantics_benchmark_code.registers+0x450>
  c20c5b:	c5 f9 6f 0d 9d 57 95 ff 	vmovdqa -0x6aa863(%rip),%xmm1        # 576400 <x86_effects_unknown+0x9a0>
  c20c63:	c4 e2 79 00 15 a4 57 95 ff 	vpshufb -0x6aa85c(%rip),%xmm0,%xmm2        # 576410 <x86_effects_unknown+0x9b0>
  c20c6c:	62 f2 75 48 8d cd    	vpermb %zmm5,%zmm1,%zmm1
  c20c72:	c5 e9 fc c0          	vpaddb %xmm0,%xmm2,%xmm0
  c20c76:	62 f2 7d 48 31 c0    	vpmovzxbd %xmm0,%zmm0
  c20c7c:	62 f1 7d 58 fe 44 24 0f 	vpaddd 0x3c(%rsp){1to16},%zmm0,%zmm0
  c20c84:	62 f2 7e 48 29 c9    	vpmovb2m %zmm1,%k1
  c20c8a:	62 f2 7d c9 8b c0    	vpcompressd %zmm0,%zmm0{%k1}{z}
  c20c90:	62 d1 fe 48 7f 07    	vmovdqu64 %zmm0,(%r15)
  c20c96:	e9 3d 11 00 00       	jmp    c21dd8 <x86_encode_16+0x2498>
  c20c9b:	62 f2 7d 48 5a 1d 3b 57 95 ff 	vbroadcasti32x4 -0x6aa8c5(%rip),%zmm3        # 5763e0 <x86_effects_unknown+0x980>
  c20ca5:	62 72 7d 48 58 0d 71 f9 95 ff 	vpbroadcastd -0x6a068f(%rip),%zmm9        # 580620 <tier0_emit_x87.operations+0x1d8>
  c20caf:	48 8d 4a f0          	lea    -0x10(%rdx),%rcx
  c20cb3:	41 b1 cc             	mov    $0xcc,%r9b
  c20cb6:	48 8d be fc 00 00 00 	lea    0xfc(%rsi),%rdi
  c20cbd:	4c 8d 05 3c 58 a4 0d 	lea    0xda4583c(%rip),%r8        # e666500 <x86_template_storage>
  c20cc4:	62 53 1d 48 25 e4 ff 	vpternlogd $0xff,%zmm12,%zmm12,%zmm12
  c20ccb:	31 c0                	xor    %eax,%eax
  c20ccd:	49 89 de             	mov    %rbx,%r14
  c20cd0:	48 c1 e9 04          	shr    $0x4,%rcx
  c20cd4:	c4 c1 7b 92 c9       	kmovd  %r9d,%k1
  c20cd9:	48 ff c1             	inc    %rcx
  c20cdc:	0f 1f 40 00          	nopl   0x0(%rax)
  c20ce0:	44 0f b7 8f 10 ff ff ff 	movzwl -0xf0(%rdi),%r9d
  c20ce8:	44 0f b7 97 20 ff ff ff 	movzwl -0xe0(%rdi),%r10d
  c20cf0:	44 0f b7 9f 30 ff ff ff 	movzwl -0xd0(%rdi),%r11d
  c20cf8:	44 0f b7 bf 40 ff ff ff 	movzwl -0xc0(%rdi),%r15d
  c20d00:	62 e1 fe 48 6f 9f 04 ff ff ff 	vmovdqu64 -0xfc(%rdi),%zmm19
  c20d0a:	62 e1 fe 48 6f af 44 ff ff ff 	vmovdqu64 -0xbc(%rdi),%zmm21
  c20d14:	62 e1 fe 48 6f b7 84 ff ff ff 	vmovdqu64 -0x7c(%rdi),%zmm22
  c20d1e:	62 e1 fe 48 6f bf c4 ff ff ff 	vmovdqu64 -0x3c(%rdi),%zmm23
  c20d28:	62 f2 7d 48 5a 0d ee 56 95 ff 	vbroadcasti32x4 -0x6aa912(%rip),%zmm1        # 576420 <x86_effects_unknown+0x9c0>
  c20d32:	48 83 c0 10          	add    $0x10,%rax
  c20d36:	41 c1 e1 06          	shl    $0x6,%r9d
  c20d3a:	41 c1 e2 06          	shl    $0x6,%r10d
  c20d3e:	41 c1 e3 06          	shl    $0x6,%r11d
  c20d42:	41 c1 e7 06          	shl    $0x6,%r15d
  c20d46:	c4 81 7d 6f 64 01 40 	vmovdqa 0x40(%r9,%r8,1),%ymm4
  c20d4d:	44 0f b7 8f 50 ff ff ff 	movzwl -0xb0(%rdi),%r9d
  c20d55:	c4 81 7d 6f 6c 02 60 	vmovdqa 0x60(%r10,%r8,1),%ymm5
  c20d5c:	44 0f b7 97 60 ff ff ff 	movzwl -0xa0(%rdi),%r10d
  c20d64:	62 93 dd 48 3a 64 03 02 01 	vinserti64x4 $0x1,0x40(%r11,%r8,1),%zmm4,%zmm4
  c20d6d:	62 13 d5 48 3a 7c 07 03 01 	vinserti64x4 $0x1,0x60(%r15,%r8,1),%zmm5,%zmm15
  c20d76:	44 0f b7 9f 70 ff ff ff 	movzwl -0x90(%rdi),%r11d
  c20d7e:	44 0f b7 7f 80       	movzwl -0x80(%rdi),%r15d
  c20d83:	62 b1 65 40 62 f5    	vpunpckldq %zmm21,%zmm19,%zmm6
  c20d89:	62 b1 4d 40 62 ff    	vpunpckldq %zmm23,%zmm22,%zmm7
  c20d8f:	62 a1 4d 40 6a f7    	vpunpckhdq %zmm23,%zmm22,%zmm22
  c20d95:	62 a1 65 40 6a ed    	vpunpckhdq %zmm21,%zmm19,%zmm21
  c20d9b:	62 b1 d5 40 6c d6    	vpunpcklqdq %zmm22,%zmm21,%zmm2
  c20da1:	62 e1 cd 48 6d ff    	vpunpckhqdq %zmm7,%zmm6,%zmm23
  c20da7:	62 62 f5 48 83 da    	vpmultishiftqb %zmm2,%zmm1,%zmm27
  c20dad:	62 f2 7d 48 5a 0d 89 56 95 ff 	vbroadcasti32x4 -0x6aa977(%rip),%zmm1        # 576440 <x86_effects_unknown+0x9e0>
  c20db7:	62 f1 15 40 72 d2 1a 	vpsrld $0x1a,%zmm2,%zmm29
  c20dbe:	62 b2 45 40 27 c7    	vptestmd %zmm23,%zmm23,%k0
  c20dc4:	62 e1 fd 48 6f da    	vmovdqa64 %zmm2,%zmm19
  c20dca:	41 c1 e1 06          	shl    $0x6,%r9d
  c20dce:	41 c1 e2 06          	shl    $0x6,%r10d
  c20dd2:	c4 01 7d 6f 44 01 40 	vmovdqa 0x40(%r9,%r8,1),%ymm8
  c20dd9:	44 0f b7 4f 90       	movzwl -0x70(%rdi),%r9d
  c20dde:	41 c1 e3 06          	shl    $0x6,%r11d
  c20de2:	c4 01 7d 6f 54 02 60 	vmovdqa 0x60(%r10,%r8,1),%ymm10
  c20de9:	44 0f b7 57 a0       	movzwl -0x60(%rdi),%r10d
  c20dee:	41 c1 e7 06          	shl    $0x6,%r15d
  c20df2:	62 13 bd 48 3a 44 03 02 01 	vinserti64x4 $0x1,0x40(%r11,%r8,1),%zmm8,%zmm8
  c20dfb:	62 83 ad 48 3a 4c 07 03 01 	vinserti64x4 $0x1,0x60(%r15,%r8,1),%zmm10,%zmm17
  c20e04:	44 0f b7 5f b0       	movzwl -0x50(%rdi),%r11d
  c20e09:	44 0f b7 7f c0       	movzwl -0x40(%rdi),%r15d
  c20e0e:	62 d2 dd 49 64 ef    	vpblendmq %zmm15,%zmm4,%zmm5{%k1}
  c20e14:	41 c1 e1 06          	shl    $0x6,%r9d
  c20e18:	41 c1 e2 06          	shl    $0x6,%r10d
  c20e1c:	c4 01 7d 6f 5c 01 40 	vmovdqa 0x40(%r9,%r8,1),%ymm11
  c20e23:	44 0f b7 4f d0       	movzwl -0x30(%rdi),%r9d
  c20e28:	41 c1 e3 06          	shl    $0x6,%r11d
  c20e2c:	c4 01 7d 6f 6c 02 60 	vmovdqa 0x60(%r10,%r8,1),%ymm13
  c20e33:	44 0f b7 57 e0       	movzwl -0x20(%rdi),%r10d
  c20e38:	41 c1 e7 06          	shl    $0x6,%r15d
  c20e3c:	62 62 f5 48 83 f2    	vpmultishiftqb %zmm2,%zmm1,%zmm30
  c20e42:	62 f2 7d 48 5a 0d e4 55 95 ff 	vbroadcasti32x4 -0x6aaa1c(%rip),%zmm1        # 576430 <x86_effects_unknown+0x9d0>
  c20e4c:	62 63 25 50 25 35 a5 f7 95 ff d8 	vpternlogd $0xd8,-0x6a085b(%rip){1to16},%zmm27,%zmm30        # 5805fc <tier0_emit_x87.operations+0x1b4>
  c20e57:	62 13 a5 48 3a 5c 03 02 01 	vinserti64x4 $0x1,0x40(%r11,%r8,1),%zmm11,%zmm11
  c20e60:	62 83 95 48 3a 54 07 03 01 	vinserti64x4 $0x1,0x60(%r15,%r8,1),%zmm13,%zmm18
  c20e69:	44 0f b7 5f f0       	movzwl -0x10(%rdi),%r11d
  c20e6e:	44 0f b7 3f          	movzwl (%rdi),%r15d
  c20e72:	48 81 c7 00 01 00 00 	add    $0x100,%rdi
  c20e79:	62 32 bd 49 64 d1    	vpblendmq %zmm17,%zmm8,%zmm10{%k1}
  c20e7f:	62 41 55 48 6a c2    	vpunpckhdq %zmm10,%zmm5,%zmm24
  c20e85:	41 c1 e1 06          	shl    $0x6,%r9d
  c20e89:	41 c1 e2 06          	shl    $0x6,%r10d
  c20e8d:	41 c1 e3 06          	shl    $0x6,%r11d
  c20e91:	c4 01 7d 6f 74 01 40 	vmovdqa 0x40(%r9,%r8,1),%ymm14
  c20e98:	41 c1 e7 06          	shl    $0x6,%r15d
  c20e9c:	62 81 fd 28 6f 44 02 03 	vmovdqa64 0x60(%r10,%r8,1),%ymm16
  c20ea4:	62 13 8d 48 3a 74 03 02 01 	vinserti64x4 $0x1,0x40(%r11,%r8,1),%zmm14,%zmm14
  c20ead:	62 83 fd 40 3a 64 07 03 01 	vinserti64x4 $0x1,0x60(%r15,%r8,1),%zmm16,%zmm20
  c20eb6:	62 62 f5 48 83 e2    	vpmultishiftqb %zmm2,%zmm1,%zmm28
  c20ebc:	62 f1 75 48 72 f2 04 	vpslld $0x4,%zmm2,%zmm1
  c20ec3:	62 63 0d 50 25 25 32 f7 95 ff e4 	vpternlogd $0xe4,-0x6a08ce(%rip){1to16},%zmm30,%zmm28        # 580600 <tier0_emit_x87.operations+0x1b8>
  c20ece:	62 f1 25 40 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm27
  c20ed5:	62 f2 7d 48 5a 0d 71 55 95 ff 	vbroadcasti32x4 -0x6aaa8f(%rip),%zmm1        # 576450 <x86_effects_unknown+0x9f0>
  c20edf:	62 32 a5 49 64 ea    	vpblendmq %zmm18,%zmm11,%zmm13{%k1}
  c20ee5:	62 a2 8d 49 64 c4    	vpblendmq %zmm20,%zmm14,%zmm16{%k1}
  c20eeb:	62 21 15 48 6a c8    	vpunpckhdq %zmm16,%zmm13,%zmm25
  c20ef1:	62 01 bd 40 6d d1    	vpunpckhqdq %zmm25,%zmm24,%zmm26
  c20ef7:	62 62 15 40 36 0d bf 16 90 ff 	vpermd -0x6fe941(%rip),%zmm29,%zmm25        # 5225c0 <branch_sizing_patterns+0x2830>
  c20f01:	62 62 15 40 36 05 f5 16 90 ff 	vpermd -0x6fe90b(%rip),%zmm29,%zmm24        # 522600 <branch_sizing_patterns+0x2870>
  c20f0b:	62 62 75 48 00 f2    	vpshufb %zmm2,%zmm1,%zmm30
  c20f11:	62 f2 7d 48 58 0d ed f6 95 ff 	vpbroadcastd -0x6a0913(%rip),%zmm1        # 580608 <tier0_emit_x87.operations+0x1c0>
  c20f1b:	62 62 15 40 36 2d 1b 17 90 ff 	vpermd -0x6fe8e5(%rip),%zmm29,%zmm29        # 522640 <branch_sizing_patterns+0x28b0>
  c20f25:	62 91 7d 48 72 f6 10 	vpslld $0x10,%zmm30,%zmm0
  c20f2c:	62 01 25 40 db f6    	vpandd %zmm30,%zmm27,%zmm30
  c20f32:	62 f1 05 40 72 e0 1f 	vpsrad $0x1f,%zmm0,%zmm31
  c20f39:	62 b1 7d 48 72 e7 1f 	vpsrad $0x1f,%zmm23,%zmm0
  c20f40:	62 03 1d 40 25 c1 f8 	vpternlogd $0xf8,%zmm25,%zmm28,%zmm24
  c20f47:	62 62 7e 48 38 c8    	vpmovm2d %k0,%zmm25
  c20f4d:	62 03 25 40 25 cf c8 	vpternlogd $0xc8,%zmm31,%zmm27,%zmm25
  c20f54:	62 21 7d 48 ef ff    	vpxord %zmm23,%zmm0,%zmm31
  c20f5a:	62 f2 7d 48 58 05 a0 f6 95 ff 	vpbroadcastd -0x6a0960(%rip),%zmm0        # 580604 <tier0_emit_x87.operations+0x1bc>
  c20f64:	62 63 15 50 25 35 cd f6 95 ff ec 	vpternlogd $0xec,-0x6a0933(%rip){1to16},%zmm29,%zmm30        # 58063c <tier0_emit_x87.operations+0x1f4>
  c20f6f:	62 91 15 40 72 d2 1d 	vpsrld $0x1d,%zmm26,%zmm29
  c20f76:	62 02 7d 48 44 ff    	vplzcntd %zmm31,%zmm31
  c20f7c:	62 63 2d 50 25 35 b9 f6 95 ff f8 	vpternlogd $0xf8,-0x6a0947(%rip){1to16},%zmm26,%zmm30        # 580640 <tier0_emit_x87.operations+0x1f8>
  c20f87:	62 02 75 48 45 ff    	vpsrlvd %zmm31,%zmm1,%zmm31
  c20f8d:	62 d1 45 40 fe cc    	vpaddd %zmm12,%zmm23,%zmm1
  c20f93:	62 93 45 40 25 cf 14 	vpternlogd $0x14,%zmm31,%zmm23,%zmm1
  c20f9a:	62 f1 05 40 72 d2 08 	vpsrld $0x8,%zmm2,%zmm31
  c20fa1:	62 92 75 48 14 cd    	vprorvd %zmm29,%zmm1,%zmm1
  c20fa7:	62 f1 75 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm1
  c20fae:	62 e3 7d 58 25 1d 5b f6 95 ff 6c 	vpternlogd $0x6c,-0x6a09a5(%rip){1to16},%zmm0,%zmm19        # 580614 <tier0_emit_x87.operations+0x1cc>
  c20fb9:	62 63 7d 58 25 3d 54 f6 95 ff 6c 	vpternlogd $0x6c,-0x6a09ac(%rip){1to16},%zmm0,%zmm31        # 580618 <tier0_emit_x87.operations+0x1d0>
  c20fc4:	62 f1 1d 50 db 05 5a f6 95 ff 	vpandd -0x6a09a6(%rip){1to16},%zmm28,%zmm0        # 580628 <tier0_emit_x87.operations+0x1e0>
  c20fce:	62 91 1d 40 72 d4 03 	vpsrld $0x3,%zmm28,%zmm28
  c20fd5:	62 63 2d 50 25 25 54 f6 95 ff a2 	vpternlogd $0xa2,-0x6a09ac(%rip){1to16},%zmm26,%zmm28        # 580634 <tier0_emit_x87.operations+0x1ec>
  c20fe0:	62 c1 65 40 fe dc    	vpaddd %zmm12,%zmm19,%zmm19
  c20fe6:	62 e3 35 58 25 1d 2b f6 95 ff ec 	vpternlogd $0xec,-0x6a09d5(%rip){1to16},%zmm9,%zmm19        # 58061c <tier0_emit_x87.operations+0x1d4>
  c20ff1:	62 41 05 40 fe fc    	vpaddd %zmm12,%zmm31,%zmm31
  c20ff7:	62 63 65 50 25 3d 22 f6 95 ff ec 	vpternlogd $0xec,-0x6a09de(%rip){1to16},%zmm19,%zmm31        # 580624 <tier0_emit_x87.operations+0x1dc>
  c21002:	62 93 2d 40 25 c7 f8 	vpternlogd $0xf8,%zmm31,%zmm26,%zmm0
  c21009:	62 e2 7d 58 3b 1d 19 f6 95 ff 	vpminud -0x6a09e7(%rip){1to16},%zmm0,%zmm19        # 58062c <tier0_emit_x87.operations+0x1e4>
  c21013:	62 f2 1d 50 3b 05 1b f6 95 ff 	vpminud -0x6a09e5(%rip){1to16},%zmm28,%zmm0        # 580638 <tier0_emit_x87.operations+0x1f0>
  c2101d:	62 01 fd 48 6f d0    	vmovdqa64 %zmm24,%zmm26
  c21023:	62 63 35 50 25 15 de f5 95 ff f8 	vpternlogd $0xf8,-0x6a0a22(%rip){1to16},%zmm25,%zmm26        # 58060c <tier0_emit_x87.operations+0x1c4>
  c2102e:	62 61 35 50 db 3d 0c f6 95 ff 	vpandd -0x6a09f4(%rip){1to16},%zmm25,%zmm31        # 580644 <tier0_emit_x87.operations+0x1fc>
  c21038:	62 23 7d 48 25 f3 fe 	vpternlogd $0xfe,%zmm19,%zmm0,%zmm30
  c2103f:	62 81 fd 48 6f d8    	vmovdqa64 %zmm24,%zmm19
  c21045:	62 e3 25 50 25 1d c0 f5 95 ff f8 	vpternlogd $0xf8,-0x6a0a40(%rip){1to16},%zmm27,%zmm19        # 580610 <tier0_emit_x87.operations+0x1c8>
  c21050:	62 b1 7d 48 72 cf 01 	vprold $0x1,%zmm23,%zmm0
  c21057:	62 61 25 50 db 1d e7 f5 95 ff 	vpandd -0x6a0a19(%rip){1to16},%zmm27,%zmm27        # 580648 <tier0_emit_x87.operations+0x200>
  c21061:	62 83 75 48 25 da b8 	vpternlogd $0xb8,%zmm26,%zmm1,%zmm19
  c21068:	62 02 7d 48 14 d5    	vprorvd %zmm29,%zmm0,%zmm26
  c2106e:	62 f1 fd 48 6f 05 08 15 90 ff 	vmovdqa64 -0x6feaf8(%rip),%zmm0        # 522580 <branch_sizing_patterns+0x27f0>
  c21078:	62 03 75 48 25 df b8 	vpternlogd $0xb8,%zmm31,%zmm1,%zmm27
  c2107f:	62 23 35 40 25 d7 e2 	vpternlogd $0xe2,%zmm23,%zmm25,%zmm26
  c21086:	62 23 75 48 25 d7 e2 	vpternlogd $0xe2,%zmm23,%zmm1,%zmm26
  c2108d:	62 f1 cd 48 6c cf    	vpunpcklqdq %zmm7,%zmm6,%zmm1
  c21093:	62 d1 1d 40 fe fc    	vpaddd %zmm12,%zmm28,%zmm7
  c21099:	62 b1 d5 40 6d f6    	vpunpckhqdq %zmm22,%zmm21,%zmm6
  c2109f:	62 f1 45 48 72 e7 1f 	vpsrad $0x1f,%zmm7,%zmm7
  c210a6:	62 f1 4d 48 eb d2    	vpord  %zmm2,%zmm6,%zmm2
  c210ac:	62 f1 6d 48 72 f2 07 	vpslld $0x7,%zmm2,%zmm2
  c210b3:	62 d2 fd 48 7e e7    	vpermt2q %zmm15,%zmm0,%zmm4
  c210b9:	62 32 fd 48 7e c1    	vpermt2q %zmm17,%zmm0,%zmm8
  c210bf:	62 32 fd 48 7e da    	vpermt2q %zmm18,%zmm0,%zmm11
  c210c5:	62 32 fd 48 7e f4    	vpermt2q %zmm20,%zmm0,%zmm14
  c210cb:	62 91 7d 48 72 d0 10 	vpsrld $0x10,%zmm24,%zmm0
  c210d2:	62 91 05 48 72 d0 03 	vpsrld $0x3,%zmm24,%zmm15
  c210d9:	62 73 7d 58 25 3d 4c f5 95 ff ec 	vpternlogd $0xec,-0x6a0ab4(%rip){1to16},%zmm0,%zmm15        # 580630 <tier0_emit_x87.operations+0x1e8>
  c210e4:	62 f2 7d 48 5a 05 72 53 95 ff 	vbroadcasti32x4 -0x6aac8e(%rip),%zmm0        # 576460 <x86_effects_unknown+0xa00>
  c210ee:	62 d1 75 40 72 f7 08 	vpslld $0x8,%zmm15,%zmm17
  c210f5:	62 e3 45 58 25 0d 4c f5 95 ff 08 	vpternlogd $0x8,-0x6a0ab4(%rip){1to16},%zmm7,%zmm17        # 58064c <tier0_emit_x87.operations+0x204>
  c21100:	62 f2 fd 48 83 f6    	vpmultishiftqb %zmm6,%zmm0,%zmm6
  c21106:	62 f3 05 58 25 35 43 f5 95 ff d8 	vpternlogd $0xd8,-0x6a0abd(%rip){1to16},%zmm15,%zmm6        # 580654 <tier0_emit_x87.operations+0x20c>
  c21111:	62 91 25 40 eb fe    	vpord  %zmm30,%zmm27,%zmm7
  c21117:	62 f1 7d 48 70 c7 00 	vpshufd $0x0,%zmm7,%zmm0
  c2111e:	62 f2 7d 48 8f dc    	vpshufbitqmb %zmm4,%zmm0,%k3
  c21124:	62 f1 7d 48 70 c7 55 	vpshufd $0x55,%zmm7,%zmm0
  c2112b:	62 d2 7d 48 8f d0    	vpshufbitqmb %zmm8,%zmm0,%k2
  c21131:	62 f1 7d 48 70 c7 aa 	vpshufd $0xaa,%zmm7,%zmm0
  c21138:	c4 61 fb 93 cb       	kmovq  %k3,%r9
  c2113d:	f3 4d 0f b8 c9       	popcnt %r9,%r9
  c21142:	c4 61 fb 93 d2       	kmovq  %k2,%r10
  c21147:	f3 4d 0f b8 d2       	popcnt %r10,%r10
  c2114c:	62 f3 75 50 25 15 f9 f4 95 ff e4 	vpternlogd $0xe4,-0x6a0b07(%rip){1to16},%zmm17,%zmm2        # 580650 <tier0_emit_x87.operations+0x208>
  c21157:	62 f3 6d 58 25 35 f6 f4 95 ff d8 	vpternlogd $0xd8,-0x6a0b0a(%rip){1to16},%zmm2,%zmm6        # 580658 <tier0_emit_x87.operations+0x210>
  c21162:	62 91 75 48 62 d2    	vpunpckldq %zmm26,%zmm1,%zmm2
  c21168:	62 91 75 48 6a ca    	vpunpckhdq %zmm26,%zmm1,%zmm1
  c2116e:	62 71 65 40 62 fe    	vpunpckldq %zmm6,%zmm19,%zmm15
  c21174:	62 f1 65 40 6a f6    	vpunpckhdq %zmm6,%zmm19,%zmm6
  c2117a:	62 c1 ed 48 6c cf    	vpunpcklqdq %zmm15,%zmm2,%zmm17
  c21180:	62 d1 ed 48 6d d7    	vpunpckhqdq %zmm15,%zmm2,%zmm2
  c21186:	62 e1 f5 48 6c d6    	vpunpcklqdq %zmm6,%zmm1,%zmm18
  c2118c:	62 f1 f5 48 6d ce    	vpunpckhqdq %zmm6,%zmm1,%zmm1
  c21192:	62 f2 75 40 00 e4    	vpshufb %zmm4,%zmm17,%zmm4
  c21198:	62 d2 6d 48 00 d0    	vpshufb %zmm8,%zmm2,%zmm2
  c2119e:	62 d2 75 48 00 ce    	vpshufb %zmm14,%zmm1,%zmm1
  c211a4:	62 f3 d5 48 25 e3 78 	vpternlogq $0x78,%zmm3,%zmm5,%zmm4
  c211ab:	62 f3 ad 48 25 d3 78 	vpternlogq $0x78,%zmm3,%zmm10,%zmm2
  c211b2:	62 f3 fd 40 25 cb 78 	vpternlogq $0x78,%zmm3,%zmm16,%zmm1
  c211b9:	62 f2 7d cb 63 e4    	vpcompressb %zmm4,%zmm4{%k3}{z}
  c211bf:	62 f2 7d ca 63 d2    	vpcompressb %zmm2,%zmm2{%k2}{z}
  c211c5:	62 d2 7d 48 8f db    	vpshufbitqmb %zmm11,%zmm0,%k3
  c211cb:	62 f1 7d 48 70 c7 ff 	vpshufd $0xff,%zmm7,%zmm0
  c211d2:	62 d2 7d 48 8f d6    	vpshufbitqmb %zmm14,%zmm0,%k2
  c211d8:	c4 61 fb 93 db       	kmovq  %k3,%r11
  c211dd:	62 f2 7d ca 63 c9    	vpcompressb %zmm1,%zmm1{%k2}{z}
  c211e3:	62 d1 fe 48 7f 26    	vmovdqu64 %zmm4,(%r14)
  c211e9:	62 d2 6d 40 00 e3    	vpshufb %zmm11,%zmm18,%zmm4
  c211ef:	62 91 fe 48 7f 14 0e 	vmovdqu64 %zmm2,(%r14,%r9,1)
  c211f6:	4d 01 f1             	add    %r14,%r9
  c211f9:	62 f3 95 48 25 e3 78 	vpternlogq $0x78,%zmm3,%zmm13,%zmm4
  c21200:	c5 e9 ef d2          	vpxor  %xmm2,%xmm2,%xmm2
  c21204:	62 f2 7d cb 63 e2    	vpcompressb %zmm4,%zmm2{%k3}{z}
  c2120a:	62 91 fe 48 7f 14 0a 	vmovdqu64 %zmm2,(%r10,%r9,1)
  c21211:	4d 01 d1             	add    %r10,%r9
  c21214:	f3 4d 0f b8 d3       	popcnt %r11,%r10
  c21219:	c4 61 fb 93 da       	kmovq  %k2,%r11
  c2121e:	f3 4d 0f b8 f3       	popcnt %r11,%r14
  c21223:	62 91 fe 48 7f 0c 0a 	vmovdqu64 %zmm1,(%r10,%r9,1)
  c2122a:	4d 01 d6             	add    %r10,%r14
  c2122d:	4d 01 ce             	add    %r9,%r14
  c21230:	48 ff c9             	dec    %rcx
  c21233:	0f 85 a7 fa ff ff    	jne    c20ce0 <x86_encode_16+0x13a0>
  c21239:	48 8d 48 10          	lea    0x10(%rax),%rcx
  c2123d:	48 39 d1             	cmp    %rdx,%rcx
  c21240:	0f 87 a3 05 00 00    	ja     c217e9 <x86_encode_16+0x1ea9>
  c21246:	62 f2 7d 48 5a 1d 90 51 95 ff 	vbroadcasti32x4 -0x6aae70(%rip),%zmm3        # 5763e0 <x86_effects_unknown+0x980>
  c21250:	62 72 7d 48 58 0d c6 f3 95 ff 	vpbroadcastd -0x6a0c3a(%rip),%zmm9        # 580620 <tier0_emit_x87.operations+0x1d8>
  c2125a:	48 89 d1             	mov    %rdx,%rcx
  c2125d:	48 29 c1             	sub    %rax,%rcx
  c21260:	48 89 c7             	mov    %rax,%rdi
  c21263:	48 c1 e7 04          	shl    $0x4,%rdi
  c21267:	41 b1 cc             	mov    $0xcc,%r9b
  c2126a:	4c 8d 05 8f 52 a4 0d 	lea    0xda4528f(%rip),%r8        # e666500 <x86_template_storage>
  c21271:	62 53 1d 48 25 e4 ff 	vpternlogd $0xff,%zmm12,%zmm12,%zmm12
  c21278:	48 83 c1 f0          	add    $0xfffffffffffffff0,%rcx
  c2127c:	48 8d bc 37 fc 00 00 00 	lea    0xfc(%rdi,%rsi,1),%rdi
  c21284:	c4 c1 7b 92 c9       	kmovd  %r9d,%k1
  c21289:	48 c1 e9 04          	shr    $0x4,%rcx
  c2128d:	48 ff c1             	inc    %rcx
  c21290:	44 0f b7 8f 10 ff ff ff 	movzwl -0xf0(%rdi),%r9d
  c21298:	44 0f b7 97 20 ff ff ff 	movzwl -0xe0(%rdi),%r10d
  c212a0:	44 0f b7 9f 30 ff ff ff 	movzwl -0xd0(%rdi),%r11d
  c212a8:	44 0f b7 bf 40 ff ff ff 	movzwl -0xc0(%rdi),%r15d
  c212b0:	62 e1 fe 48 6f 9f 04 ff ff ff 	vmovdqu64 -0xfc(%rdi),%zmm19
  c212ba:	62 e1 fe 48 6f af 44 ff ff ff 	vmovdqu64 -0xbc(%rdi),%zmm21
  c212c4:	62 e1 fe 48 6f b7 84 ff ff ff 	vmovdqu64 -0x7c(%rdi),%zmm22
  c212ce:	62 e1 fe 48 6f bf c4 ff ff ff 	vmovdqu64 -0x3c(%rdi),%zmm23
  c212d8:	62 f2 7d 48 5a 0d 3e 51 95 ff 	vbroadcasti32x4 -0x6aaec2(%rip),%zmm1        # 576420 <x86_effects_unknown+0x9c0>
  c212e2:	48 83 c0 10          	add    $0x10,%rax
  c212e6:	41 c1 e1 06          	shl    $0x6,%r9d
  c212ea:	41 c1 e2 06          	shl    $0x6,%r10d
  c212ee:	41 c1 e3 06          	shl    $0x6,%r11d
  c212f2:	41 c1 e7 06          	shl    $0x6,%r15d
  c212f6:	c4 81 7d 6f 64 01 40 	vmovdqa 0x40(%r9,%r8,1),%ymm4
  c212fd:	44 0f b7 8f 50 ff ff ff 	movzwl -0xb0(%rdi),%r9d
  c21305:	c4 81 7d 6f 6c 02 60 	vmovdqa 0x60(%r10,%r8,1),%ymm5
  c2130c:	44 0f b7 97 60 ff ff ff 	movzwl -0xa0(%rdi),%r10d
  c21314:	62 93 dd 48 3a 64 03 02 01 	vinserti64x4 $0x1,0x40(%r11,%r8,1),%zmm4,%zmm4
  c2131d:	62 13 d5 48 3a 7c 07 03 01 	vinserti64x4 $0x1,0x60(%r15,%r8,1),%zmm5,%zmm15
  c21326:	44 0f b7 9f 70 ff ff ff 	movzwl -0x90(%rdi),%r11d
  c2132e:	44 0f b7 7f 80       	movzwl -0x80(%rdi),%r15d
  c21333:	62 b1 65 40 62 f5    	vpunpckldq %zmm21,%zmm19,%zmm6
  c21339:	62 b1 4d 40 62 ff    	vpunpckldq %zmm23,%zmm22,%zmm7
  c2133f:	62 a1 4d 40 6a f7    	vpunpckhdq %zmm23,%zmm22,%zmm22
  c21345:	62 a1 65 40 6a ed    	vpunpckhdq %zmm21,%zmm19,%zmm21
  c2134b:	62 b1 d5 40 6c d6    	vpunpcklqdq %zmm22,%zmm21,%zmm2
  c21351:	62 e1 cd 48 6d ff    	vpunpckhqdq %zmm7,%zmm6,%zmm23
  c21357:	62 62 f5 48 83 da    	vpmultishiftqb %zmm2,%zmm1,%zmm27
  c2135d:	62 f2 7d 48 5a 0d d9 50 95 ff 	vbroadcasti32x4 -0x6aaf27(%rip),%zmm1        # 576440 <x86_effects_unknown+0x9e0>
  c21367:	62 f1 15 40 72 d2 1a 	vpsrld $0x1a,%zmm2,%zmm29
  c2136e:	62 b2 45 40 27 c7    	vptestmd %zmm23,%zmm23,%k0
  c21374:	62 e1 fd 48 6f da    	vmovdqa64 %zmm2,%zmm19
  c2137a:	41 c1 e1 06          	shl    $0x6,%r9d
  c2137e:	41 c1 e2 06          	shl    $0x6,%r10d
  c21382:	c4 01 7d 6f 44 01 40 	vmovdqa 0x40(%r9,%r8,1),%ymm8
  c21389:	44 0f b7 4f 90       	movzwl -0x70(%rdi),%r9d
  c2138e:	41 c1 e3 06          	shl    $0x6,%r11d
  c21392:	c4 01 7d 6f 54 02 60 	vmovdqa 0x60(%r10,%r8,1),%ymm10
  c21399:	44 0f b7 57 a0       	movzwl -0x60(%rdi),%r10d
  c2139e:	41 c1 e7 06          	shl    $0x6,%r15d
  c213a2:	62 13 bd 48 3a 44 03 02 01 	vinserti64x4 $0x1,0x40(%r11,%r8,1),%zmm8,%zmm8
  c213ab:	62 83 ad 48 3a 4c 07 03 01 	vinserti64x4 $0x1,0x60(%r15,%r8,1),%zmm10,%zmm17
  c213b4:	44 0f b7 5f b0       	movzwl -0x50(%rdi),%r11d
  c213b9:	44 0f b7 7f c0       	movzwl -0x40(%rdi),%r15d
  c213be:	62 d2 dd 49 64 ef    	vpblendmq %zmm15,%zmm4,%zmm5{%k1}
  c213c4:	41 c1 e1 06          	shl    $0x6,%r9d
  c213c8:	41 c1 e2 06          	shl    $0x6,%r10d
  c213cc:	c4 01 7d 6f 5c 01 40 	vmovdqa 0x40(%r9,%r8,1),%ymm11
  c213d3:	44 0f b7 4f d0       	movzwl -0x30(%rdi),%r9d
  c213d8:	41 c1 e3 06          	shl    $0x6,%r11d
  c213dc:	c4 01 7d 6f 6c 02 60 	vmovdqa 0x60(%r10,%r8,1),%ymm13
  c213e3:	44 0f b7 57 e0       	movzwl -0x20(%rdi),%r10d
  c213e8:	41 c1 e7 06          	shl    $0x6,%r15d
  c213ec:	62 62 f5 48 83 f2    	vpmultishiftqb %zmm2,%zmm1,%zmm30
  c213f2:	62 f2 7d 48 5a 0d 34 50 95 ff 	vbroadcasti32x4 -0x6aafcc(%rip),%zmm1        # 576430 <x86_effects_unknown+0x9d0>
  c213fc:	62 63 25 50 25 35 f5 f1 95 ff d8 	vpternlogd $0xd8,-0x6a0e0b(%rip){1to16},%zmm27,%zmm30        # 5805fc <tier0_emit_x87.operations+0x1b4>
  c21407:	62 13 a5 48 3a 5c 03 02 01 	vinserti64x4 $0x1,0x40(%r11,%r8,1),%zmm11,%zmm11
  c21410:	62 83 95 48 3a 54 07 03 01 	vinserti64x4 $0x1,0x60(%r15,%r8,1),%zmm13,%zmm18
  c21419:	44 0f b7 5f f0       	movzwl -0x10(%rdi),%r11d
  c2141e:	44 0f b7 3f          	movzwl (%rdi),%r15d
  c21422:	48 81 c7 00 01 00 00 	add    $0x100,%rdi
  c21429:	62 32 bd 49 64 d1    	vpblendmq %zmm17,%zmm8,%zmm10{%k1}
  c2142f:	62 41 55 48 6a c2    	vpunpckhdq %zmm10,%zmm5,%zmm24
  c21435:	41 c1 e1 06          	shl    $0x6,%r9d
  c21439:	41 c1 e2 06          	shl    $0x6,%r10d
  c2143d:	41 c1 e3 06          	shl    $0x6,%r11d
  c21441:	c4 01 7d 6f 74 01 40 	vmovdqa 0x40(%r9,%r8,1),%ymm14
  c21448:	41 c1 e7 06          	shl    $0x6,%r15d
  c2144c:	62 81 fd 28 6f 44 02 03 	vmovdqa64 0x60(%r10,%r8,1),%ymm16
  c21454:	62 13 8d 48 3a 74 03 02 01 	vinserti64x4 $0x1,0x40(%r11,%r8,1),%zmm14,%zmm14
  c2145d:	62 83 fd 40 3a 64 07 03 01 	vinserti64x4 $0x1,0x60(%r15,%r8,1),%zmm16,%zmm20
  c21466:	62 62 f5 48 83 e2    	vpmultishiftqb %zmm2,%zmm1,%zmm28
  c2146c:	62 f1 75 48 72 f2 04 	vpslld $0x4,%zmm2,%zmm1
  c21473:	62 63 0d 50 25 25 82 f1 95 ff e4 	vpternlogd $0xe4,-0x6a0e7e(%rip){1to16},%zmm30,%zmm28        # 580600 <tier0_emit_x87.operations+0x1b8>
  c2147e:	62 f1 25 40 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm27
  c21485:	62 f2 7d 48 5a 0d c1 4f 95 ff 	vbroadcasti32x4 -0x6ab03f(%rip),%zmm1        # 576450 <x86_effects_unknown+0x9f0>
  c2148f:	62 32 a5 49 64 ea    	vpblendmq %zmm18,%zmm11,%zmm13{%k1}
  c21495:	62 a2 8d 49 64 c4    	vpblendmq %zmm20,%zmm14,%zmm16{%k1}
  c2149b:	62 21 15 48 6a c8    	vpunpckhdq %zmm16,%zmm13,%zmm25
  c214a1:	62 01 bd 40 6d d1    	vpunpckhqdq %zmm25,%zmm24,%zmm26
  c214a7:	62 62 15 40 36 0d 0f 11 90 ff 	vpermd -0x6feef1(%rip),%zmm29,%zmm25        # 5225c0 <branch_sizing_patterns+0x2830>
  c214b1:	62 62 15 40 36 05 45 11 90 ff 	vpermd -0x6feebb(%rip),%zmm29,%zmm24        # 522600 <branch_sizing_patterns+0x2870>
  c214bb:	62 62 75 48 00 f2    	vpshufb %zmm2,%zmm1,%zmm30
  c214c1:	62 f2 7d 48 58 0d 3d f1 95 ff 	vpbroadcastd -0x6a0ec3(%rip),%zmm1        # 580608 <tier0_emit_x87.operations+0x1c0>
  c214cb:	62 62 15 40 36 2d 6b 11 90 ff 	vpermd -0x6fee95(%rip),%zmm29,%zmm29        # 522640 <branch_sizing_patterns+0x28b0>
  c214d5:	62 91 7d 48 72 f6 10 	vpslld $0x10,%zmm30,%zmm0
  c214dc:	62 01 25 40 db f6    	vpandd %zmm30,%zmm27,%zmm30
  c214e2:	62 f1 05 40 72 e0 1f 	vpsrad $0x1f,%zmm0,%zmm31
  c214e9:	62 b1 7d 48 72 e7 1f 	vpsrad $0x1f,%zmm23,%zmm0
  c214f0:	62 03 1d 40 25 c1 f8 	vpternlogd $0xf8,%zmm25,%zmm28,%zmm24
  c214f7:	62 62 7e 48 38 c8    	vpmovm2d %k0,%zmm25
  c214fd:	62 03 25 40 25 cf c8 	vpternlogd $0xc8,%zmm31,%zmm27,%zmm25
  c21504:	62 21 7d 48 ef ff    	vpxord %zmm23,%zmm0,%zmm31
  c2150a:	62 f2 7d 48 58 05 f0 f0 95 ff 	vpbroadcastd -0x6a0f10(%rip),%zmm0        # 580604 <tier0_emit_x87.operations+0x1bc>
  c21514:	62 63 15 50 25 35 1d f1 95 ff ec 	vpternlogd $0xec,-0x6a0ee3(%rip){1to16},%zmm29,%zmm30        # 58063c <tier0_emit_x87.operations+0x1f4>
  c2151f:	62 91 15 40 72 d2 1d 	vpsrld $0x1d,%zmm26,%zmm29
  c21526:	62 02 7d 48 44 ff    	vplzcntd %zmm31,%zmm31
  c2152c:	62 63 2d 50 25 35 09 f1 95 ff f8 	vpternlogd $0xf8,-0x6a0ef7(%rip){1to16},%zmm26,%zmm30        # 580640 <tier0_emit_x87.operations+0x1f8>
  c21537:	62 02 75 48 45 ff    	vpsrlvd %zmm31,%zmm1,%zmm31
  c2153d:	62 d1 45 40 fe cc    	vpaddd %zmm12,%zmm23,%zmm1
  c21543:	62 93 45 40 25 cf 14 	vpternlogd $0x14,%zmm31,%zmm23,%zmm1
  c2154a:	62 f1 05 40 72 d2 08 	vpsrld $0x8,%zmm2,%zmm31
  c21551:	62 92 75 48 14 cd    	vprorvd %zmm29,%zmm1,%zmm1
  c21557:	62 f1 75 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm1
  c2155e:	62 e3 7d 58 25 1d ab f0 95 ff 6c 	vpternlogd $0x6c,-0x6a0f55(%rip){1to16},%zmm0,%zmm19        # 580614 <tier0_emit_x87.operations+0x1cc>
  c21569:	62 63 7d 58 25 3d a4 f0 95 ff 6c 	vpternlogd $0x6c,-0x6a0f5c(%rip){1to16},%zmm0,%zmm31        # 580618 <tier0_emit_x87.operations+0x1d0>
  c21574:	62 f1 1d 50 db 05 aa f0 95 ff 	vpandd -0x6a0f56(%rip){1to16},%zmm28,%zmm0        # 580628 <tier0_emit_x87.operations+0x1e0>
  c2157e:	62 91 1d 40 72 d4 03 	vpsrld $0x3,%zmm28,%zmm28
  c21585:	62 63 2d 50 25 25 a4 f0 95 ff a2 	vpternlogd $0xa2,-0x6a0f5c(%rip){1to16},%zmm26,%zmm28        # 580634 <tier0_emit_x87.operations+0x1ec>
  c21590:	62 c1 65 40 fe dc    	vpaddd %zmm12,%zmm19,%zmm19
  c21596:	62 e3 35 58 25 1d 7b f0 95 ff ec 	vpternlogd $0xec,-0x6a0f85(%rip){1to16},%zmm9,%zmm19        # 58061c <tier0_emit_x87.operations+0x1d4>
  c215a1:	62 41 05 40 fe fc    	vpaddd %zmm12,%zmm31,%zmm31
  c215a7:	62 63 65 50 25 3d 72 f0 95 ff ec 	vpternlogd $0xec,-0x6a0f8e(%rip){1to16},%zmm19,%zmm31        # 580624 <tier0_emit_x87.operations+0x1dc>
  c215b2:	62 93 2d 40 25 c7 f8 	vpternlogd $0xf8,%zmm31,%zmm26,%zmm0
  c215b9:	62 e2 7d 58 3b 1d 69 f0 95 ff 	vpminud -0x6a0f97(%rip){1to16},%zmm0,%zmm19        # 58062c <tier0_emit_x87.operations+0x1e4>
  c215c3:	62 f2 1d 50 3b 05 6b f0 95 ff 	vpminud -0x6a0f95(%rip){1to16},%zmm28,%zmm0        # 580638 <tier0_emit_x87.operations+0x1f0>
  c215cd:	62 01 fd 48 6f d0    	vmovdqa64 %zmm24,%zmm26
  c215d3:	62 63 35 50 25 15 2e f0 95 ff f8 	vpternlogd $0xf8,-0x6a0fd2(%rip){1to16},%zmm25,%zmm26        # 58060c <tier0_emit_x87.operations+0x1c4>
  c215de:	62 61 35 50 db 3d 5c f0 95 ff 	vpandd -0x6a0fa4(%rip){1to16},%zmm25,%zmm31        # 580644 <tier0_emit_x87.operations+0x1fc>
  c215e8:	62 23 7d 48 25 f3 fe 	vpternlogd $0xfe,%zmm19,%zmm0,%zmm30
  c215ef:	62 81 fd 48 6f d8    	vmovdqa64 %zmm24,%zmm19
  c215f5:	62 e3 25 50 25 1d 10 f0 95 ff f8 	vpternlogd $0xf8,-0x6a0ff0(%rip){1to16},%zmm27,%zmm19        # 580610 <tier0_emit_x87.operations+0x1c8>
  c21600:	62 b1 7d 48 72 cf 01 	vprold $0x1,%zmm23,%zmm0
  c21607:	62 61 25 50 db 1d 37 f0 95 ff 	vpandd -0x6a0fc9(%rip){1to16},%zmm27,%zmm27        # 580648 <tier0_emit_x87.operations+0x200>
  c21611:	62 83 75 48 25 da b8 	vpternlogd $0xb8,%zmm26,%zmm1,%zmm19
  c21618:	62 02 7d 48 14 d5    	vprorvd %zmm29,%zmm0,%zmm26
  c2161e:	62 f1 fd 48 6f 05 58 0f 90 ff 	vmovdqa64 -0x6ff0a8(%rip),%zmm0        # 522580 <branch_sizing_patterns+0x27f0>
  c21628:	62 03 75 48 25 df b8 	vpternlogd $0xb8,%zmm31,%zmm1,%zmm27
  c2162f:	62 23 35 40 25 d7 e2 	vpternlogd $0xe2,%zmm23,%zmm25,%zmm26
  c21636:	62 23 75 48 25 d7 e2 	vpternlogd $0xe2,%zmm23,%zmm1,%zmm26
  c2163d:	62 f1 cd 48 6c cf    	vpunpcklqdq %zmm7,%zmm6,%zmm1
  c21643:	62 d1 1d 40 fe fc    	vpaddd %zmm12,%zmm28,%zmm7
  c21649:	62 b1 d5 40 6d f6    	vpunpckhqdq %zmm22,%zmm21,%zmm6
  c2164f:	62 f1 45 48 72 e7 1f 	vpsrad $0x1f,%zmm7,%zmm7
  c21656:	62 f1 4d 48 eb d2    	vpord  %zmm2,%zmm6,%zmm2
  c2165c:	62 f1 6d 48 72 f2 07 	vpslld $0x7,%zmm2,%zmm2
  c21663:	62 d2 fd 48 7e e7    	vpermt2q %zmm15,%zmm0,%zmm4
  c21669:	62 32 fd 48 7e c1    	vpermt2q %zmm17,%zmm0,%zmm8
  c2166f:	62 32 fd 48 7e da    	vpermt2q %zmm18,%zmm0,%zmm11
  c21675:	62 32 fd 48 7e f4    	vpermt2q %zmm20,%zmm0,%zmm14
  c2167b:	62 91 7d 48 72 d0 10 	vpsrld $0x10,%zmm24,%zmm0
  c21682:	62 91 05 48 72 d0 03 	vpsrld $0x3,%zmm24,%zmm15
  c21689:	62 73 7d 58 25 3d 9c ef 95 ff ec 	vpternlogd $0xec,-0x6a1064(%rip){1to16},%zmm0,%zmm15        # 580630 <tier0_emit_x87.operations+0x1e8>
  c21694:	62 f2 7d 48 5a 05 c2 4d 95 ff 	vbroadcasti32x4 -0x6ab23e(%rip),%zmm0        # 576460 <x86_effects_unknown+0xa00>
  c2169e:	62 d1 75 40 72 f7 08 	vpslld $0x8,%zmm15,%zmm17
  c216a5:	62 e3 45 58 25 0d 9c ef 95 ff 08 	vpternlogd $0x8,-0x6a1064(%rip){1to16},%zmm7,%zmm17        # 58064c <tier0_emit_x87.operations+0x204>
  c216b0:	62 f2 fd 48 83 f6    	vpmultishiftqb %zmm6,%zmm0,%zmm6
  c216b6:	62 f3 05 58 25 35 93 ef 95 ff d8 	vpternlogd $0xd8,-0x6a106d(%rip){1to16},%zmm15,%zmm6        # 580654 <tier0_emit_x87.operations+0x20c>
  c216c1:	62 91 25 40 eb fe    	vpord  %zmm30,%zmm27,%zmm7
  c216c7:	62 f1 7d 48 70 c7 00 	vpshufd $0x0,%zmm7,%zmm0
  c216ce:	62 f2 7d 48 8f dc    	vpshufbitqmb %zmm4,%zmm0,%k3
  c216d4:	62 f1 7d 48 70 c7 55 	vpshufd $0x55,%zmm7,%zmm0
  c216db:	62 d2 7d 48 8f d0    	vpshufbitqmb %zmm8,%zmm0,%k2
  c216e1:	62 f1 7d 48 70 c7 aa 	vpshufd $0xaa,%zmm7,%zmm0
  c216e8:	c4 61 fb 93 cb       	kmovq  %k3,%r9
  c216ed:	f3 4d 0f b8 c9       	popcnt %r9,%r9
  c216f2:	c4 61 fb 93 d2       	kmovq  %k2,%r10
  c216f7:	f3 4d 0f b8 d2       	popcnt %r10,%r10
  c216fc:	62 f3 75 50 25 15 49 ef 95 ff e4 	vpternlogd $0xe4,-0x6a10b7(%rip){1to16},%zmm17,%zmm2        # 580650 <tier0_emit_x87.operations+0x208>
  c21707:	62 f3 6d 58 25 35 46 ef 95 ff d8 	vpternlogd $0xd8,-0x6a10ba(%rip){1to16},%zmm2,%zmm6        # 580658 <tier0_emit_x87.operations+0x210>
  c21712:	62 91 75 48 62 d2    	vpunpckldq %zmm26,%zmm1,%zmm2
  c21718:	62 91 75 48 6a ca    	vpunpckhdq %zmm26,%zmm1,%zmm1
  c2171e:	62 71 65 40 62 fe    	vpunpckldq %zmm6,%zmm19,%zmm15
  c21724:	62 f1 65 40 6a f6    	vpunpckhdq %zmm6,%zmm19,%zmm6
  c2172a:	62 c1 ed 48 6c cf    	vpunpcklqdq %zmm15,%zmm2,%zmm17
  c21730:	62 d1 ed 48 6d d7    	vpunpckhqdq %zmm15,%zmm2,%zmm2
  c21736:	62 e1 f5 48 6c d6    	vpunpcklqdq %zmm6,%zmm1,%zmm18
  c2173c:	62 f1 f5 48 6d ce    	vpunpckhqdq %zmm6,%zmm1,%zmm1
  c21742:	62 f2 75 40 00 e4    	vpshufb %zmm4,%zmm17,%zmm4
  c21748:	62 d2 6d 48 00 d0    	vpshufb %zmm8,%zmm2,%zmm2
  c2174e:	62 d2 75 48 00 ce    	vpshufb %zmm14,%zmm1,%zmm1
  c21754:	62 f3 d5 48 25 e3 78 	vpternlogq $0x78,%zmm3,%zmm5,%zmm4
  c2175b:	62 f3 ad 48 25 d3 78 	vpternlogq $0x78,%zmm3,%zmm10,%zmm2
  c21762:	62 f3 fd 40 25 cb 78 	vpternlogq $0x78,%zmm3,%zmm16,%zmm1
  c21769:	62 f2 7d cb 63 e4    	vpcompressb %zmm4,%zmm4{%k3}{z}
  c2176f:	62 f2 7d ca 63 d2    	vpcompressb %zmm2,%zmm2{%k2}{z}
  c21775:	62 d2 7d 48 8f db    	vpshufbitqmb %zmm11,%zmm0,%k3
  c2177b:	62 f1 7d 48 70 c7 ff 	vpshufd $0xff,%zmm7,%zmm0
  c21782:	62 d2 7d 48 8f d6    	vpshufbitqmb %zmm14,%zmm0,%k2
  c21788:	c4 61 fb 93 db       	kmovq  %k3,%r11
  c2178d:	62 f2 7d ca 63 c9    	vpcompressb %zmm1,%zmm1{%k2}{z}
  c21793:	62 d1 fe 48 7f 26    	vmovdqu64 %zmm4,(%r14)
  c21799:	62 d2 6d 40 00 e3    	vpshufb %zmm11,%zmm18,%zmm4
  c2179f:	62 91 fe 48 7f 14 0e 	vmovdqu64 %zmm2,(%r14,%r9,1)
  c217a6:	4d 01 f1             	add    %r14,%r9
  c217a9:	62 f3 95 48 25 e3 78 	vpternlogq $0x78,%zmm3,%zmm13,%zmm4
  c217b0:	c5 e9 ef d2          	vpxor  %xmm2,%xmm2,%xmm2
  c217b4:	62 f2 7d cb 63 e2    	vpcompressb %zmm4,%zmm2{%k3}{z}
  c217ba:	62 91 fe 48 7f 14 0a 	vmovdqu64 %zmm2,(%r10,%r9,1)
  c217c1:	4d 01 d1             	add    %r10,%r9
  c217c4:	f3 4d 0f b8 d3       	popcnt %r11,%r10
  c217c9:	c4 61 fb 93 da       	kmovq  %k2,%r11
  c217ce:	f3 4d 0f b8 f3       	popcnt %r11,%r14
  c217d3:	62 91 fe 48 7f 0c 0a 	vmovdqu64 %zmm1,(%r10,%r9,1)
  c217da:	4d 01 d6             	add    %r10,%r14
  c217dd:	4d 01 ce             	add    %r9,%r14
  c217e0:	48 ff c9             	dec    %rcx
  c217e3:	0f 85 a7 fa ff ff    	jne    c21290 <x86_encode_16+0x1950>
  c217e9:	48 29 c2             	sub    %rax,%rdx
  c217ec:	0f 86 e6 05 00 00    	jbe    c21dd8 <x86_encode_16+0x2498>
  c217f2:	48 c1 e0 04          	shl    $0x4,%rax
  c217f6:	48 c1 e2 04          	shl    $0x4,%rdx
  c217fa:	48 8d 7c 24 40       	lea    0x40(%rsp),%rdi
  c217ff:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
  c21803:	62 f1 fd 48 7f 44 24 04 	vmovdqa64 %zmm0,0x100(%rsp)
  c2180b:	62 f1 fd 48 7f 44 24 03 	vmovdqa64 %zmm0,0xc0(%rsp)
  c21813:	62 f1 fd 48 7f 44 24 02 	vmovdqa64 %zmm0,0x80(%rsp)
  c2181b:	62 f1 fd 48 7f 44 24 01 	vmovdqa64 %zmm0,0x40(%rsp)
  c21823:	48 01 c6             	add    %rax,%rsi
  c21826:	c5 f8 77             	vzeroupper
  c21829:	e8 22 2c b4 ff       	call   764450 <memcpy@plt>
  c2182e:	c5 f9 6f 64 24 70    	vmovdqa 0x70(%rsp),%xmm4
  c21834:	c5 f9 6f 4c 24 40    	vmovdqa 0x40(%rsp),%xmm1
  c2183a:	c5 f9 6f 54 24 50    	vmovdqa 0x50(%rsp),%xmm2
  c21840:	c5 f9 6f 5c 24 60    	vmovdqa 0x60(%rsp),%xmm3
  c21846:	c5 f9 6f ac 24 80 00 00 00 	vmovdqa 0x80(%rsp),%xmm5
  c2184f:	48 8d 05 aa 4c a4 0d 	lea    0xda44caa(%rip),%rax        # e666500 <x86_template_storage>
  c21856:	62 71 fd 48 6f 3d 20 0d 90 ff 	vmovdqa64 -0x6ff2e0(%rip),%zmm15        # 522580 <branch_sizing_patterns+0x27f0>
  c21860:	c5 f9 6f bc 24 c0 00 00 00 	vmovdqa 0xc0(%rsp),%xmm7
  c21869:	c5 f9 6f b4 24 d0 00 00 00 	vmovdqa 0xd0(%rsp),%xmm6
  c21872:	62 71 fd 48 6f 4c 24 01 	vmovdqa64 0x40(%rsp),%zmm9
  c2187a:	62 71 fd 48 6f 54 24 02 	vmovdqa64 0x80(%rsp),%zmm10
  c21882:	62 71 fd 48 6f 5c 24 03 	vmovdqa64 0xc0(%rsp),%zmm11
  c2188a:	62 71 fd 48 6f 64 24 04 	vmovdqa64 0x100(%rsp),%zmm12
  c21892:	62 e2 7d 48 5a 0d 94 4b 95 ff 	vbroadcasti32x4 -0x6ab46c(%rip),%zmm17        # 576430 <x86_effects_unknown+0x9d0>
  c2189c:	62 a3 4d 40 25 f6 ff 	vpternlogd $0xff,%zmm22,%zmm22,%zmm22
  c218a3:	62 e2 7d 48 58 25 57 ed 95 ff 	vpbroadcastd -0x6a12a9(%rip),%zmm20        # 580604 <tier0_emit_x87.operations+0x1bc>
  c218ad:	62 62 7d 48 58 15 59 ed 95 ff 	vpbroadcastd -0x6a12a7(%rip),%zmm26        # 580610 <tier0_emit_x87.operations+0x1c8>
  c218b7:	62 62 7d 48 58 0d 53 ed 95 ff 	vpbroadcastd -0x6a12ad(%rip),%zmm25        # 580614 <tier0_emit_x87.operations+0x1cc>
  c218c1:	c5 f9 c5 fc 06       	vpextrw $0x6,%xmm4,%edi
  c218c6:	c5 f9 6f a4 24 90 00 00 00 	vmovdqa 0x90(%rsp),%xmm4
  c218cf:	c5 f9 c5 c9 06       	vpextrw $0x6,%xmm1,%ecx
  c218d4:	c5 f9 c5 d2 06       	vpextrw $0x6,%xmm2,%edx
  c218d9:	c5 f9 c5 f3 06       	vpextrw $0x6,%xmm3,%esi
  c218de:	62 51 35 48 62 ea    	vpunpckldq %zmm10,%zmm9,%zmm13
  c218e4:	62 51 25 48 62 f4    	vpunpckldq %zmm12,%zmm11,%zmm14
  c218ea:	62 51 35 48 6a d2    	vpunpckhdq %zmm10,%zmm9,%zmm10
  c218f0:	62 51 25 48 6a e4    	vpunpckhdq %zmm12,%zmm11,%zmm12
  c218f6:	c1 e1 06             	shl    $0x6,%ecx
  c218f9:	c1 e2 06             	shl    $0x6,%edx
  c218fc:	c1 e6 06             	shl    $0x6,%esi
  c218ff:	c1 e7 06             	shl    $0x6,%edi
  c21902:	62 51 ad 48 6c dc    	vpunpcklqdq %zmm12,%zmm10,%zmm11
  c21908:	62 d1 95 48 6c c6    	vpunpcklqdq %zmm14,%zmm13,%zmm0
  c2190e:	62 51 95 48 6d ce    	vpunpckhqdq %zmm14,%zmm13,%zmm9
  c21914:	62 51 ad 48 6d e4    	vpunpckhqdq %zmm12,%zmm10,%zmm12
  c2191a:	c5 fd 6f 4c 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm1
  c21920:	b1 cc                	mov    $0xcc,%cl
  c21922:	c5 fd 6f 54 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm2
  c21928:	62 c2 f5 40 83 db    	vpmultishiftqb %zmm11,%zmm17,%zmm19
  c2192e:	62 d2 35 48 27 c1    	vptestmd %zmm9,%zmm9,%k0
  c21934:	62 d1 75 40 72 e1 1f 	vpsrad $0x1f,%zmm9,%zmm17
  c2193b:	62 21 35 48 fe c6    	vpaddd %zmm22,%zmm9,%zmm24
  c21941:	62 43 5d 40 25 cb 6c 	vpternlogd $0x6c,%zmm11,%zmm20,%zmm25
  c21948:	c5 fb 92 c9          	kmovd  %ecx,%k1
  c2194c:	c5 f9 c5 cd 06       	vpextrw $0x6,%xmm5,%ecx
  c21951:	c5 f9 6f ac 24 a0 00 00 00 	vmovdqa 0xa0(%rsp),%xmm5
  c2195a:	62 f3 f5 48 3a 4c 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm1,%zmm1
  c21963:	62 f3 ed 48 3a 5c 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm2,%zmm3
  c2196c:	c1 e1 06             	shl    $0x6,%ecx
  c2196f:	c5 f9 c5 d4 06       	vpextrw $0x6,%xmm4,%edx
  c21974:	c5 f9 6f a4 24 b0 00 00 00 	vmovdqa 0xb0(%rsp),%xmm4
  c2197d:	c1 e2 06             	shl    $0x6,%edx
  c21980:	c5 f9 c5 f5 06       	vpextrw $0x6,%xmm5,%esi
  c21985:	62 f2 f5 49 64 d3    	vpblendmq %zmm3,%zmm1,%zmm2{%k1}
  c2198b:	62 f2 85 48 7e cb    	vpermt2q %zmm3,%zmm15,%zmm1
  c21991:	c5 fd 6f 5c 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm3
  c21997:	c5 f9 c5 cf 06       	vpextrw $0x6,%xmm7,%ecx
  c2199c:	c5 f9 6f bc 24 e0 00 00 00 	vmovdqa 0xe0(%rsp),%xmm7
  c219a5:	c1 e6 06             	shl    $0x6,%esi
  c219a8:	c1 e1 06             	shl    $0x6,%ecx
  c219ab:	62 f3 e5 48 3a 5c 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm3,%zmm3
  c219b4:	c5 f9 c5 fc 06       	vpextrw $0x6,%xmm4,%edi
  c219b9:	c5 fd 6f 64 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm4
  c219bf:	c5 f9 c5 d6 06       	vpextrw $0x6,%xmm6,%edx
  c219c4:	c5 f9 6f b4 24 f0 00 00 00 	vmovdqa 0xf0(%rsp),%xmm6
  c219cd:	c1 e7 06             	shl    $0x6,%edi
  c219d0:	c1 e2 06             	shl    $0x6,%edx
  c219d3:	62 f3 dd 48 3a 6c 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm4,%zmm5
  c219dc:	c5 f9 c5 f7 06       	vpextrw $0x6,%xmm7,%esi
  c219e1:	c1 e6 06             	shl    $0x6,%esi
  c219e4:	c5 f9 c5 fe 06       	vpextrw $0x6,%xmm6,%edi
  c219e9:	c5 fd 6f 74 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm6
  c219ef:	0f b7 94 24 1c 01 00 00 	movzwl 0x11c(%rsp),%edx
  c219f7:	c1 e7 06             	shl    $0x6,%edi
  c219fa:	62 f2 e5 49 64 e5    	vpblendmq %zmm5,%zmm3,%zmm4{%k1}
  c21a00:	62 f2 85 48 7e dd    	vpermt2q %zmm5,%zmm15,%zmm3
  c21a06:	c5 fd 6f 6c 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm5
  c21a0c:	62 f3 cd 48 3a 7c 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm6,%zmm7
  c21a15:	0f b7 8c 24 0c 01 00 00 	movzwl 0x10c(%rsp),%ecx
  c21a1d:	0f b7 bc 24 3c 01 00 00 	movzwl 0x13c(%rsp),%edi
  c21a25:	62 f3 d5 48 3a 6c 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm5,%zmm5
  c21a2e:	0f b7 b4 24 2c 01 00 00 	movzwl 0x12c(%rsp),%esi
  c21a36:	62 71 6d 48 6a d4    	vpunpckhdq %zmm4,%zmm2,%zmm10
  c21a3c:	c1 e2 06             	shl    $0x6,%edx
  c21a3f:	c5 7d 6f 44 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm8
  c21a45:	c1 e1 06             	shl    $0x6,%ecx
  c21a48:	c1 e7 06             	shl    $0x6,%edi
  c21a4b:	c1 e6 06             	shl    $0x6,%esi
  c21a4e:	62 e3 bd 48 3a 44 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm8,%zmm16
  c21a57:	62 f2 d5 49 64 f7    	vpblendmq %zmm7,%zmm5,%zmm6{%k1}
  c21a5d:	62 f2 85 48 7e ef    	vpermt2q %zmm7,%zmm15,%zmm5
  c21a63:	c5 fd 6f 7c 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm7
  c21a69:	62 f3 c5 48 3a 7c 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm7,%zmm7
  c21a72:	62 32 c5 49 64 c0    	vpblendmq %zmm16,%zmm7,%zmm8{%k1}
  c21a78:	62 b2 85 48 7e f8    	vpermt2q %zmm16,%zmm15,%zmm7
  c21a7e:	62 e2 7d 48 5a 05 98 49 95 ff 	vbroadcasti32x4 -0x6ab668(%rip),%zmm16        # 576420 <x86_effects_unknown+0x9c0>
  c21a88:	62 51 4d 48 6a e8    	vpunpckhdq %zmm8,%zmm6,%zmm13
  c21a8e:	62 51 ad 48 6d d5    	vpunpckhqdq %zmm13,%zmm10,%zmm10
  c21a94:	62 d1 15 48 72 d3 1a 	vpsrld $0x1a,%zmm11,%zmm13
  c21a9b:	62 72 15 48 36 35 1b 0b 90 ff 	vpermd -0x6ff4e5(%rip),%zmm13,%zmm14        # 5225c0 <branch_sizing_patterns+0x2830>
  c21aa5:	62 e2 15 48 36 15 51 0b 90 ff 	vpermd -0x6ff4af(%rip),%zmm13,%zmm18        # 522600 <branch_sizing_patterns+0x2870>
  c21aaf:	62 72 15 48 36 2d 87 0b 90 ff 	vpermd -0x6ff479(%rip),%zmm13,%zmm13        # 522640 <branch_sizing_patterns+0x28b0>
  c21ab9:	62 d1 45 40 72 d2 1d 	vpsrld $0x1d,%zmm10,%zmm23
  c21ac0:	62 52 fd 40 83 fb    	vpmultishiftqb %zmm11,%zmm16,%zmm15
  c21ac6:	62 e2 7d 48 5a 05 70 49 95 ff 	vbroadcasti32x4 -0x6ab690(%rip),%zmm16        # 576440 <x86_effects_unknown+0x9e0>
  c21ad0:	62 c2 fd 40 83 c3    	vpmultishiftqb %zmm11,%zmm16,%zmm16
  c21ad6:	62 e3 05 58 25 05 1b eb 95 ff d8 	vpternlogd $0xd8,-0x6a14e5(%rip){1to16},%zmm15,%zmm16        # 5805fc <tier0_emit_x87.operations+0x1b4>
  c21ae1:	62 d1 05 48 72 f3 04 	vpslld $0x4,%zmm11,%zmm15
  c21ae8:	62 d1 05 48 72 e7 1f 	vpsrad $0x1f,%zmm15,%zmm15
  c21aef:	62 e3 7d 50 25 1d 06 eb 95 ff e4 	vpternlogd $0xe4,-0x6a14fa(%rip){1to16},%zmm16,%zmm19        # 580600 <tier0_emit_x87.operations+0x1b8>
  c21afa:	62 e2 7d 48 5a 05 4c 49 95 ff 	vbroadcasti32x4 -0x6ab6b4(%rip),%zmm16        # 576450 <x86_effects_unknown+0x9f0>
  c21b04:	62 c2 7d 40 00 eb    	vpshufb %zmm11,%zmm16,%zmm21
  c21b0a:	62 c3 65 40 25 d6 f8 	vpternlogd $0xf8,%zmm14,%zmm19,%zmm18
  c21b11:	62 23 05 48 25 d2 ea 	vpternlogd $0xea,%zmm18,%zmm15,%zmm26
  c21b18:	62 b1 0d 48 72 f5 10 	vpslld $0x10,%zmm21,%zmm14
  c21b1f:	62 d1 7d 40 72 e6 1f 	vpsrad $0x1f,%zmm14,%zmm16
  c21b26:	62 72 7e 48 38 f0    	vpmovm2d %k0,%zmm14
  c21b2c:	62 33 05 48 25 f0 c8 	vpternlogd $0xc8,%zmm16,%zmm15,%zmm14
  c21b33:	62 c1 75 40 ef c1    	vpxord %zmm9,%zmm17,%zmm16
  c21b39:	62 e2 7d 48 58 0d c5 ea 95 ff 	vpbroadcastd -0x6a153b(%rip),%zmm17        # 580608 <tier0_emit_x87.operations+0x1c0>
  c21b43:	62 a2 7d 48 44 c0    	vplzcntd %zmm16,%zmm16
  c21b49:	62 a2 75 40 45 c0    	vpsrlvd %zmm16,%zmm17,%zmm16
  c21b4f:	62 23 35 48 25 c0 14 	vpternlogd $0x14,%zmm16,%zmm9,%zmm24
  c21b56:	62 a2 3d 40 14 c7    	vprorvd %zmm23,%zmm24,%zmm16
  c21b5c:	62 62 7d 48 58 05 a6 ea 95 ff 	vpbroadcastd -0x6a155a(%rip),%zmm24        # 58060c <tier0_emit_x87.operations+0x1c4>
  c21b66:	62 b1 7d 40 72 e0 1f 	vpsrad $0x1f,%zmm16,%zmm16
  c21b6d:	62 23 0d 48 25 c2 ea 	vpternlogd $0xea,%zmm18,%zmm14,%zmm24
  c21b74:	62 03 7d 40 25 d0 b8 	vpternlogd $0xb8,%zmm24,%zmm16,%zmm26
  c21b7b:	62 21 35 40 fe c6    	vpaddd %zmm22,%zmm25,%zmm24
  c21b81:	62 d1 35 40 72 d3 08 	vpsrld $0x8,%zmm11,%zmm25
  c21b88:	62 63 5d 50 25 0d 85 ea 95 ff 6c 	vpternlogd $0x6c,-0x6a157b(%rip){1to16},%zmm20,%zmm25        # 580618 <tier0_emit_x87.operations+0x1d0>
  c21b93:	62 51 1d 48 eb db    	vpord  %zmm11,%zmm12,%zmm11
  c21b99:	62 d1 25 48 72 f3 07 	vpslld $0x7,%zmm11,%zmm11
  c21ba0:	62 a1 35 40 fe e6    	vpaddd %zmm22,%zmm25,%zmm20
  c21ba6:	62 62 7d 48 58 0d 6c ea 95 ff 	vpbroadcastd -0x6a1594(%rip),%zmm25        # 58061c <tier0_emit_x87.operations+0x1d4>
  c21bb0:	62 63 3d 50 25 0d 65 ea 95 ff ea 	vpternlogd $0xea,-0x6a159b(%rip){1to16},%zmm24,%zmm25        # 580620 <tier0_emit_x87.operations+0x1d8>
  c21bbb:	62 61 65 50 db 05 63 ea 95 ff 	vpandd -0x6a159d(%rip){1to16},%zmm19,%zmm24        # 580628 <tier0_emit_x87.operations+0x1e0>
  c21bc5:	62 b1 65 40 72 d3 03 	vpsrld $0x3,%zmm19,%zmm19
  c21bcc:	62 e3 2d 58 25 1d 5d ea 95 ff a2 	vpternlogd $0xa2,-0x6a15a3(%rip){1to16},%zmm10,%zmm19        # 580634 <tier0_emit_x87.operations+0x1ec>
  c21bd7:	62 63 5d 50 25 0d 42 ea 95 ff f8 	vpternlogd $0xf8,-0x6a15be(%rip){1to16},%zmm20,%zmm25        # 580624 <tier0_emit_x87.operations+0x1dc>
  c21be2:	62 a1 65 40 fe f6    	vpaddd %zmm22,%zmm19,%zmm22
  c21be8:	62 e2 65 50 3b 1d 46 ea 95 ff 	vpminud -0x6a15ba(%rip){1to16},%zmm19,%zmm19        # 580638 <tier0_emit_x87.operations+0x1f0>
  c21bf2:	62 03 2d 48 25 c1 f8 	vpternlogd $0xf8,%zmm25,%zmm10,%zmm24
  c21bf9:	62 e2 3d 50 3b 25 29 ea 95 ff 	vpminud -0x6a15d7(%rip){1to16},%zmm24,%zmm20        # 58062c <tier0_emit_x87.operations+0x1e4>
  c21c03:	62 b1 3d 40 72 d2 10 	vpsrld $0x10,%zmm18,%zmm24
  c21c0a:	62 b1 6d 40 72 d2 03 	vpsrld $0x3,%zmm18,%zmm18
  c21c11:	62 b1 4d 40 72 e6 1f 	vpsrad $0x1f,%zmm22,%zmm22
  c21c18:	62 e3 3d 50 25 15 0d ea 95 ff ec 	vpternlogd $0xec,-0x6a15f3(%rip){1to16},%zmm24,%zmm18        # 580630 <tier0_emit_x87.operations+0x1e8>
  c21c23:	62 b1 3d 40 72 f2 08 	vpslld $0x8,%zmm18,%zmm24
  c21c2a:	62 63 4d 50 25 05 17 ea 95 ff 08 	vpternlogd $0x8,-0x6a15e9(%rip){1to16},%zmm22,%zmm24        # 58064c <tier0_emit_x87.operations+0x204>
  c21c35:	62 e2 7d 48 5a 35 21 48 95 ff 	vbroadcasti32x4 -0x6ab7df(%rip),%zmm22        # 576460 <x86_effects_unknown+0xa00>
  c21c3f:	62 73 3d 50 25 1d 06 ea 95 ff e4 	vpternlogd $0xe4,-0x6a15fa(%rip){1to16},%zmm24,%zmm11        # 580650 <tier0_emit_x87.operations+0x208>
  c21c4a:	62 c2 cd 40 83 f4    	vpmultishiftqb %zmm12,%zmm22,%zmm22
  c21c50:	62 31 05 48 db e5    	vpandd %zmm21,%zmm15,%zmm12
  c21c56:	62 73 15 58 25 25 db e9 95 ff ec 	vpternlogd $0xec,-0x6a1625(%rip){1to16},%zmm13,%zmm12        # 58063c <tier0_emit_x87.operations+0x1f4>
  c21c61:	62 e3 6d 50 25 35 e8 e9 95 ff d8 	vpternlogd $0xd8,-0x6a1618(%rip){1to16},%zmm18,%zmm22        # 580654 <tier0_emit_x87.operations+0x20c>
  c21c6c:	62 71 05 58 db 2d d2 e9 95 ff 	vpandd -0x6a162e(%rip){1to16},%zmm15,%zmm13        # 580648 <tier0_emit_x87.operations+0x200>
  c21c76:	62 73 2d 58 25 25 bf e9 95 ff f8 	vpternlogd $0xf8,-0x6a1641(%rip){1to16},%zmm10,%zmm12        # 580640 <tier0_emit_x87.operations+0x1f8>
  c21c81:	62 71 0d 58 db 15 b9 e9 95 ff 	vpandd -0x6a1647(%rip){1to16},%zmm14,%zmm10        # 580644 <tier0_emit_x87.operations+0x1fc>
  c21c8b:	62 e3 25 58 25 35 c2 e9 95 ff d8 	vpternlogd $0xd8,-0x6a163e(%rip){1to16},%zmm11,%zmm22        # 580658 <tier0_emit_x87.operations+0x210>
  c21c96:	62 d1 25 48 72 c9 01 	vprold $0x1,%zmm9,%zmm11
  c21c9d:	62 33 65 40 25 e4 fe 	vpternlogd $0xfe,%zmm20,%zmm19,%zmm12
  c21ca4:	62 53 7d 40 25 ea b8 	vpternlogd $0xb8,%zmm10,%zmm16,%zmm13
  c21cab:	62 32 25 48 14 df    	vprorvd %zmm23,%zmm11,%zmm11
  c21cb1:	62 51 15 48 eb d4    	vpord  %zmm12,%zmm13,%zmm10
  c21cb7:	62 51 7d 48 70 fa 00 	vpshufd $0x0,%zmm10,%zmm15
  c21cbe:	62 53 0d 48 25 d9 e2 	vpternlogd $0xe2,%zmm9,%zmm14,%zmm11
  c21cc5:	62 72 7d 48 5a 35 11 47 95 ff 	vbroadcasti32x4 -0x6ab8ef(%rip),%zmm14        # 5763e0 <x86_effects_unknown+0x980>
  c21ccf:	62 f2 05 48 8f c9    	vpshufbitqmb %zmm1,%zmm15,%k1
  c21cd5:	62 53 7d 40 25 d9 e2 	vpternlogd $0xe2,%zmm9,%zmm16,%zmm11
  c21cdc:	62 51 7d 48 62 cb    	vpunpckldq %zmm11,%zmm0,%zmm9
  c21ce2:	62 d1 7d 48 6a c3    	vpunpckhdq %zmm11,%zmm0,%zmm0
  c21ce8:	c4 e1 fb 93 c1       	kmovq  %k1,%rax
  c21ced:	62 31 2d 40 62 de    	vpunpckldq %zmm22,%zmm26,%zmm11
  c21cf3:	62 31 2d 40 6a e6    	vpunpckhdq %zmm22,%zmm26,%zmm12
  c21cf9:	f3 48 0f b8 c0       	popcnt %rax,%rax
  c21cfe:	62 51 b5 48 6c eb    	vpunpcklqdq %zmm11,%zmm9,%zmm13
  c21d04:	62 c1 fd 48 6c c4    	vpunpcklqdq %zmm12,%zmm0,%zmm16
  c21d0a:	62 d1 fd 48 6d c4    	vpunpckhqdq %zmm12,%zmm0,%zmm0
  c21d10:	62 51 b5 48 6d cb    	vpunpckhqdq %zmm11,%zmm9,%zmm9
  c21d16:	62 51 7d 48 70 e2 55 	vpshufd $0x55,%zmm10,%zmm12
  c21d1d:	49 8d 0c 06          	lea    (%r14,%rax,1),%rcx
  c21d21:	62 72 15 48 00 e9    	vpshufb %zmm1,%zmm13,%zmm13
  c21d27:	62 f2 7d 48 00 c7    	vpshufb %zmm7,%zmm0,%zmm0
  c21d2d:	62 53 ed 48 25 ee 78 	vpternlogq $0x78,%zmm14,%zmm2,%zmm13
  c21d34:	62 f2 35 48 00 d3    	vpshufb %zmm3,%zmm9,%zmm2
  c21d3a:	62 d3 bd 48 25 c6 78 	vpternlogq $0x78,%zmm14,%zmm8,%zmm0
  c21d41:	62 72 7d c9 63 e9    	vpcompressb %zmm13,%zmm1{%k1}{z}
  c21d47:	62 f2 1d 48 8f cb    	vpshufbitqmb %zmm3,%zmm12,%k1
  c21d4d:	62 d1 7d 48 70 da aa 	vpshufd $0xaa,%zmm10,%zmm3
  c21d54:	62 d3 dd 48 25 d6 78 	vpternlogq $0x78,%zmm14,%zmm4,%zmm2
  c21d5b:	c4 e1 fb 93 d1       	kmovq  %k1,%rdx
  c21d60:	f3 48 0f b8 d2       	popcnt %rdx,%rdx
  c21d65:	62 d1 fe 48 7f 0e    	vmovdqu64 %zmm1,(%r14)
  c21d6b:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
  c21d6f:	62 f2 7d c9 63 d1    	vpcompressb %zmm2,%zmm1{%k1}{z}
  c21d75:	62 f2 7d 40 00 d5    	vpshufb %zmm5,%zmm16,%zmm2
  c21d7b:	62 f2 65 48 8f cd    	vpshufbitqmb %zmm5,%zmm3,%k1
  c21d81:	62 d3 cd 48 25 d6 78 	vpternlogq $0x78,%zmm14,%zmm6,%zmm2
  c21d88:	c4 e1 fb 93 f1       	kmovq  %k1,%rsi
  c21d8d:	f3 48 0f b8 f6       	popcnt %rsi,%rsi
  c21d92:	62 d1 fe 48 7f 0c 06 	vmovdqu64 %zmm1,(%r14,%rax,1)
  c21d99:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
  c21d9d:	62 f2 7d c9 63 d1    	vpcompressb %zmm2,%zmm1{%k1}{z}
  c21da3:	62 d1 7d 48 70 d2 ff 	vpshufd $0xff,%zmm10,%zmm2
  c21daa:	48 8d 04 11          	lea    (%rcx,%rdx,1),%rax
  c21dae:	62 f2 6d 48 8f cf    	vpshufbitqmb %zmm7,%zmm2,%k1
  c21db4:	62 f2 7d c9 63 c0    	vpcompressb %zmm0,%zmm0{%k1}{z}
  c21dba:	62 f1 fe 48 7f 0c 0a 	vmovdqu64 %zmm1,(%rdx,%rcx,1)
  c21dc1:	c4 e1 fb 93 c9       	kmovq  %k1,%rcx
  c21dc6:	f3 4c 0f b8 f1       	popcnt %rcx,%r14
  c21dcb:	49 01 f6             	add    %rsi,%r14
  c21dce:	49 01 c6             	add    %rax,%r14
  c21dd1:	62 f1 fe 48 7f 04 06 	vmovdqu64 %zmm0,(%rsi,%rax,1)
  c21dd8:	49 29 de             	sub    %rbx,%r14
  c21ddb:	64 48 8b 04 25 28 00 00 00 	mov    %fs:0x28,%rax
  c21de4:	48 3b 84 24 48 01 00 00 	cmp    0x148(%rsp),%rax
  c21dec:	75 13                	jne    c21e01 <x86_encode_16+0x24c1>
  c21dee:	4c 89 f0             	mov    %r14,%rax
  c21df1:	48 8d 65 e0          	lea    -0x20(%rbp),%rsp
  c21df5:	5b                   	pop    %rbx
  c21df6:	41 5c                	pop    %r12
  c21df8:	41 5e                	pop    %r14
  c21dfa:	41 5f                	pop    %r15
  c21dfc:	5d                   	pop    %rbp
  c21dfd:	c5 f8 77             	vzeroupper
  c21e00:	c3                   	ret
  c21e01:	c5 f8 77             	vzeroupper
  c21e04:	e8 d7 1c b4 ff       	call   763ae0 <__stack_chk_fail@plt>
