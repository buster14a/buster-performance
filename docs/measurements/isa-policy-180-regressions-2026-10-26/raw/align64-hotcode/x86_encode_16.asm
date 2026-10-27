
/home/david/buster-fast-bench/codex-180-fix-20261027-align64/build/compiler:     file format elf64-x86-64


Disassembly of section .text:

0000000001560840 <x86_encode_16>:
 1560840:	55                   	push   %rbp
 1560841:	48 89 e5             	mov    %rsp,%rbp
 1560844:	41 57                	push   %r15
 1560846:	41 56                	push   %r14
 1560848:	41 54                	push   %r12
 156084a:	53                   	push   %rbx
 156084b:	48 83 e4 c0          	and    $0xffffffffffffffc0,%rsp
 156084f:	48 81 ec 80 01 00 00 	sub    $0x180,%rsp
 1560856:	64 48 8b 04 25 28 00 00 00 	mov    %fs:0x28,%rax
 156085f:	48 89 d3             	mov    %rdx,%rbx
 1560862:	48 89 f2             	mov    %rsi,%rdx
 1560865:	48 89 fe             	mov    %rdi,%rsi
 1560868:	48 89 84 24 48 01 00 00 	mov    %rax,0x148(%rsp)
 1560870:	48 85 c9             	test   %rcx,%rcx
 1560873:	74 10                	je     1560885 <x86_encode_16+0x45>
 1560875:	48 83 fa 10          	cmp    $0x10,%rdx
 1560879:	73 1e                	jae    1560899 <x86_encode_16+0x59>
 156087b:	31 c0                	xor    %eax,%eax
 156087d:	48 89 df             	mov    %rbx,%rdi
 1560880:	e9 49 06 00 00       	jmp    1560ece <x86_encode_16+0x68e>
 1560885:	48 83 fa 10          	cmp    $0x10,%rdx
 1560889:	0f 83 0c 13 00 00    	jae    1561b9b <x86_encode_16+0x135b>
 156088f:	31 c0                	xor    %eax,%eax
 1560891:	49 89 de             	mov    %rbx,%r14
 1560894:	e9 a0 18 00 00       	jmp    1562139 <x86_encode_16+0x18f9>
 1560899:	62 f2 7d 48 5a 1d 3d 5b 01 ff 	vbroadcasti32x4 -0xfea4c3(%rip),%zmm3        # 5763e0 <x86_effects_unknown+0x980>
 15608a3:	62 72 7d 48 58 0d 73 fd 01 ff 	vpbroadcastd -0xfe028d(%rip),%zmm9        # 580620 <tier0_emit_x87.operations+0x1d8>
 15608ad:	4c 8d 42 f0          	lea    -0x10(%rdx),%r8
 15608b1:	40 b7 cc             	mov    $0xcc,%dil
 15608b4:	4c 8d 8e fc 00 00 00 	lea    0xfc(%rsi),%r9
 15608bb:	4c 8d 15 be 5f 10 0d 	lea    0xd105fbe(%rip),%r10        # e666880 <x86_template_storage>
 15608c2:	62 53 1d 48 25 e4 ff 	vpternlogd $0xff,%zmm12,%zmm12,%zmm12
 15608c9:	31 c0                	xor    %eax,%eax
 15608cb:	49 89 db             	mov    %rbx,%r11
 15608ce:	49 c1 e8 04          	shr    $0x4,%r8
 15608d2:	c5 fb 92 cf          	kmovd  %edi,%k1
 15608d6:	49 ff c0             	inc    %r8
 15608d9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
 15608e0:	41 0f b7 b9 10 ff ff ff 	movzwl -0xf0(%r9),%edi
 15608e8:	45 0f b7 b1 20 ff ff ff 	movzwl -0xe0(%r9),%r14d
 15608f0:	45 0f b7 b9 30 ff ff ff 	movzwl -0xd0(%r9),%r15d
 15608f8:	45 0f b7 a1 40 ff ff ff 	movzwl -0xc0(%r9),%r12d
 1560900:	62 c1 fe 48 6f a1 04 ff ff ff 	vmovdqu64 -0xfc(%r9),%zmm20
 156090a:	62 41 fe 48 6f 99 44 ff ff ff 	vmovdqu64 -0xbc(%r9),%zmm27
 1560914:	62 41 fe 48 6f a9 84 ff ff ff 	vmovdqu64 -0x7c(%r9),%zmm29
 156091e:	62 41 fe 48 6f b1 c4 ff ff ff 	vmovdqu64 -0x3c(%r9),%zmm30
 1560928:	62 f2 7d 48 5a 2d ee 5a 01 ff 	vbroadcasti32x4 -0xfea512(%rip),%zmm5        # 576420 <x86_effects_unknown+0x9c0>
 1560932:	62 f2 7d 48 5a 05 f4 5a 01 ff 	vbroadcasti32x4 -0xfea50c(%rip),%zmm0        # 576430 <x86_effects_unknown+0x9d0>
 156093c:	62 72 7d 48 58 05 c2 fc 01 ff 	vpbroadcastd -0xfe033e(%rip),%zmm8        # 580608 <tier0_emit_x87.operations+0x1c0>
 1560946:	48 83 c0 10          	add    $0x10,%rax
 156094a:	c1 e7 06             	shl    $0x6,%edi
 156094d:	41 c1 e6 06          	shl    $0x6,%r14d
 1560951:	41 c1 e7 06          	shl    $0x6,%r15d
 1560955:	41 c1 e4 06          	shl    $0x6,%r12d
 1560959:	c4 a1 7d 6f 4c 17 40 	vmovdqa 0x40(%rdi,%r10,1),%ymm1
 1560960:	41 0f b7 b9 50 ff ff ff 	movzwl -0xb0(%r9),%edi
 1560968:	62 13 f5 48 3a 5c 17 02 01 	vinserti64x4 $0x1,0x40(%r15,%r10,1),%zmm1,%zmm11
 1560971:	45 0f b7 b9 70 ff ff ff 	movzwl -0x90(%r9),%r15d
 1560979:	c4 81 7d 6f 4c 16 60 	vmovdqa 0x60(%r14,%r10,1),%ymm1
 1560980:	45 0f b7 b1 60 ff ff ff 	movzwl -0xa0(%r9),%r14d
 1560988:	62 83 f5 48 3a 74 14 03 01 	vinserti64x4 $0x1,0x60(%r12,%r10,1),%zmm1,%zmm22
 1560991:	45 0f b7 61 80       	movzwl -0x80(%r9),%r12d
 1560996:	62 11 15 40 62 fe    	vpunpckldq %zmm30,%zmm29,%zmm15
 156099c:	62 01 5d 40 6a e3    	vpunpckhdq %zmm27,%zmm20,%zmm28
 15609a2:	62 01 15 40 6a ee    	vpunpckhdq %zmm30,%zmm29,%zmm29
 15609a8:	62 11 5d 40 62 f3    	vpunpckldq %zmm27,%zmm20,%zmm14
 15609ae:	62 11 9d 40 6c d5    	vpunpcklqdq %zmm29,%zmm28,%zmm10
 15609b4:	62 41 8d 48 6d f7    	vpunpckhqdq %zmm15,%zmm14,%zmm30
 15609ba:	62 d2 fd 48 83 f2    	vpmultishiftqb %zmm10,%zmm0,%zmm6
 15609c0:	62 92 0d 40 27 c6    	vptestmd %zmm30,%zmm30,%k0
 15609c6:	62 91 7d 48 72 e6 1f 	vpsrad $0x1f,%zmm30,%zmm0
 15609cd:	62 41 fd 48 6f da    	vmovdqa64 %zmm10,%zmm27
 15609d3:	c1 e7 06             	shl    $0x6,%edi
 15609d6:	c4 a1 7d 6f 4c 17 40 	vmovdqa 0x40(%rdi,%r10,1),%ymm1
 15609dd:	41 0f b7 79 90       	movzwl -0x70(%r9),%edi
 15609e2:	41 c1 e7 06          	shl    $0x6,%r15d
 15609e6:	41 c1 e6 06          	shl    $0x6,%r14d
 15609ea:	62 83 f5 48 3a 44 17 02 01 	vinserti64x4 $0x1,0x40(%r15,%r10,1),%zmm1,%zmm16
 15609f3:	45 0f b7 79 b0       	movzwl -0x50(%r9),%r15d
 15609f8:	c4 81 7d 6f 4c 16 60 	vmovdqa 0x60(%r14,%r10,1),%ymm1
 15609ff:	45 0f b7 71 a0       	movzwl -0x60(%r9),%r14d
 1560a04:	41 c1 e4 06          	shl    $0x6,%r12d
 1560a08:	62 03 f5 48 3a 44 14 03 01 	vinserti64x4 $0x1,0x60(%r12,%r10,1),%zmm1,%zmm24
 1560a11:	45 0f b7 61 c0       	movzwl -0x40(%r9),%r12d
 1560a16:	62 32 a5 49 64 ee    	vpblendmq %zmm22,%zmm11,%zmm13{%k1}
 1560a1c:	c1 e7 06             	shl    $0x6,%edi
 1560a1f:	c4 a1 7d 6f 4c 17 40 	vmovdqa 0x40(%rdi,%r10,1),%ymm1
 1560a26:	41 0f b7 79 d0       	movzwl -0x30(%r9),%edi
 1560a2b:	41 c1 e7 06          	shl    $0x6,%r15d
 1560a2f:	41 c1 e6 06          	shl    $0x6,%r14d
 1560a33:	62 83 f5 48 3a 54 17 02 01 	vinserti64x4 $0x1,0x40(%r15,%r10,1),%zmm1,%zmm18
 1560a3c:	45 0f b7 79 f0       	movzwl -0x10(%r9),%r15d
 1560a41:	c4 81 7d 6f 4c 16 60 	vmovdqa 0x60(%r14,%r10,1),%ymm1
 1560a48:	45 0f b7 71 e0       	movzwl -0x20(%r9),%r14d
 1560a4d:	41 c1 e4 06          	shl    $0x6,%r12d
 1560a51:	62 03 f5 48 3a 4c 14 03 01 	vinserti64x4 $0x1,0x60(%r12,%r10,1),%zmm1,%zmm25
 1560a5a:	45 0f b7 21          	movzwl (%r9),%r12d
 1560a5e:	49 81 c1 00 01 00 00 	add    $0x100,%r9
 1560a65:	62 82 fd 41 64 c8    	vpblendmq %zmm24,%zmm16,%zmm17{%k1}
 1560a6b:	c1 e7 06             	shl    $0x6,%edi
 1560a6e:	41 c1 e6 06          	shl    $0x6,%r14d
 1560a72:	41 c1 e7 06          	shl    $0x6,%r15d
 1560a76:	c4 a1 7d 6f 4c 17 40 	vmovdqa 0x40(%rdi,%r10,1),%ymm1
 1560a7d:	62 83 f5 48 3a 6c 17 02 01 	vinserti64x4 $0x1,0x40(%r15,%r10,1),%zmm1,%zmm21
 1560a86:	41 c1 e4 06          	shl    $0x6,%r12d
 1560a8a:	c4 81 7d 6f 4c 16 60 	vmovdqa 0x60(%r14,%r10,1),%ymm1
 1560a91:	62 03 f5 48 3a 54 14 03 01 	vinserti64x4 $0x1,0x60(%r12,%r10,1),%zmm1,%zmm26
 1560a9a:	62 b1 15 48 6a c9    	vpunpckhdq %zmm17,%zmm13,%zmm1
 1560aa0:	62 82 ed 41 64 d9    	vpblendmq %zmm25,%zmm18,%zmm19{%k1}
 1560aa6:	62 82 d5 41 64 fa    	vpblendmq %zmm26,%zmm21,%zmm23{%k1}
 1560aac:	62 b1 65 40 6a d7    	vpunpckhdq %zmm23,%zmm19,%zmm2
 1560ab2:	62 e1 f5 48 6d e2    	vpunpckhqdq %zmm2,%zmm1,%zmm20
 1560ab8:	62 d1 75 48 72 d2 1a 	vpsrld $0x1a,%zmm10,%zmm1
 1560abf:	62 f2 75 48 36 3d f7 1a fc fe 	vpermd -0x103e509(%rip),%zmm1,%zmm7        # 5225c0 <branch_sizing_patterns+0x2830>
 1560ac9:	62 62 75 48 36 3d 2d 1b fc fe 	vpermd -0x103e4d3(%rip),%zmm1,%zmm31        # 522600 <branch_sizing_patterns+0x2870>
 1560ad3:	62 f2 75 48 36 25 63 1b fc fe 	vpermd -0x103e49d(%rip),%zmm1,%zmm4        # 522640 <branch_sizing_patterns+0x28b0>
 1560add:	62 d2 d5 48 83 ca    	vpmultishiftqb %zmm10,%zmm5,%zmm1
 1560ae3:	62 f2 7d 48 5a 2d 53 59 01 ff 	vbroadcasti32x4 -0xfea6ad(%rip),%zmm5        # 576440 <x86_effects_unknown+0x9e0>
 1560aed:	62 d2 d5 48 83 ea    	vpmultishiftqb %zmm10,%zmm5,%zmm5
 1560af3:	62 f3 75 58 25 2d fe fa 01 ff d8 	vpternlogd $0xd8,-0xfe0502(%rip){1to16},%zmm1,%zmm5        # 5805fc <tier0_emit_x87.operations+0x1b4>
 1560afe:	62 d1 75 48 72 f2 04 	vpslld $0x4,%zmm10,%zmm1
 1560b05:	62 f1 6d 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm2
 1560b0c:	62 f3 55 58 25 35 e9 fa 01 ff e4 	vpternlogd $0xe4,-0xfe0517(%rip){1to16},%zmm5,%zmm6        # 580600 <tier0_emit_x87.operations+0x1b8>
 1560b17:	62 f2 7d 48 5a 2d 2f 59 01 ff 	vbroadcasti32x4 -0xfea6d1(%rip),%zmm5        # 576450 <x86_effects_unknown+0x9f0>
 1560b21:	62 d2 55 48 00 ea    	vpshufb %zmm10,%zmm5,%zmm5
 1560b27:	62 63 4d 48 25 ff f8 	vpternlogd $0xf8,%zmm7,%zmm6,%zmm31
 1560b2e:	62 f1 75 48 72 f5 10 	vpslld $0x10,%zmm5,%zmm1
 1560b35:	62 f1 6d 48 db ed    	vpandd %zmm5,%zmm2,%zmm5
 1560b3b:	62 f3 5d 58 25 2d f6 fa 01 ff ec 	vpternlogd $0xec,-0xfe050a(%rip){1to16},%zmm4,%zmm5        # 58063c <tier0_emit_x87.operations+0x1f4>
 1560b46:	62 f1 45 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm7
 1560b4d:	62 f2 7e 48 38 c8    	vpmovm2d %k0,%zmm1
 1560b53:	62 f3 5d 50 25 2d e2 fa 01 ff f8 	vpternlogd $0xf8,-0xfe051e(%rip){1to16},%zmm20,%zmm5        # 580640 <tier0_emit_x87.operations+0x1f8>
 1560b5e:	62 f3 6d 48 25 cf c8 	vpternlogd $0xc8,%zmm7,%zmm2,%zmm1
 1560b65:	62 91 7d 48 ef fe    	vpxord %zmm30,%zmm0,%zmm7
 1560b6b:	62 f2 7d 48 58 05 8f fa 01 ff 	vpbroadcastd -0xfe0571(%rip),%zmm0        # 580604 <tier0_emit_x87.operations+0x1bc>
 1560b75:	62 f2 7d 48 44 ff    	vplzcntd %zmm7,%zmm7
 1560b7b:	62 f2 3d 48 45 ff    	vpsrlvd %zmm7,%zmm8,%zmm7
 1560b81:	62 51 0d 40 fe c4    	vpaddd %zmm12,%zmm30,%zmm8
 1560b87:	62 73 0d 40 25 c7 14 	vpternlogd $0x14,%zmm7,%zmm30,%zmm8
 1560b8e:	62 d1 45 48 72 d2 08 	vpsrld $0x8,%zmm10,%zmm7
 1560b95:	62 63 7d 58 25 1d 74 fa 01 ff 6c 	vpternlogd $0x6c,-0xfe058c(%rip){1to16},%zmm0,%zmm27        # 580614 <tier0_emit_x87.operations+0x1cc>
 1560ba0:	62 f3 7d 58 25 3d 6d fa 01 ff 6c 	vpternlogd $0x6c,-0xfe0593(%rip){1to16},%zmm0,%zmm7        # 580618 <tier0_emit_x87.operations+0x1d0>
 1560bab:	62 91 7d 48 72 ce 01 	vprold $0x1,%zmm30,%zmm0
 1560bb2:	62 41 25 40 fe dc    	vpaddd %zmm12,%zmm27,%zmm27
 1560bb8:	62 63 35 58 25 1d 59 fa 01 ff ec 	vpternlogd $0xec,-0xfe05a7(%rip){1to16},%zmm9,%zmm27        # 58061c <tier0_emit_x87.operations+0x1d4>
 1560bc3:	62 d1 45 48 fe fc    	vpaddd %zmm12,%zmm7,%zmm7
 1560bc9:	62 f3 25 50 25 3d 50 fa 01 ff ec 	vpternlogd $0xec,-0xfe05b0(%rip){1to16},%zmm27,%zmm7        # 580624 <tier0_emit_x87.operations+0x1dc>
 1560bd4:	62 61 4d 58 db 1d 4a fa 01 ff 	vpandd -0xfe05b6(%rip){1to16},%zmm6,%zmm27        # 580628 <tier0_emit_x87.operations+0x1e0>
 1560bde:	62 f1 4d 48 72 d6 03 	vpsrld $0x3,%zmm6,%zmm6
 1560be5:	62 f3 5d 50 25 35 44 fa 01 ff a2 	vpternlogd $0xa2,-0xfe05bc(%rip){1to16},%zmm20,%zmm6        # 580634 <tier0_emit_x87.operations+0x1ec>
 1560bf0:	62 f2 4d 58 3b 25 3e fa 01 ff 	vpminud -0xfe05c2(%rip){1to16},%zmm6,%zmm4        # 580638 <tier0_emit_x87.operations+0x1f0>
 1560bfa:	62 63 5d 40 25 df f8 	vpternlogd $0xf8,%zmm7,%zmm20,%zmm27
 1560c01:	62 62 25 50 3b 1d 21 fa 01 ff 	vpminud -0xfe05df(%rip){1to16},%zmm27,%zmm27        # 58062c <tier0_emit_x87.operations+0x1e4>
 1560c0b:	62 b1 45 48 72 d4 1d 	vpsrld $0x1d,%zmm20,%zmm7
 1560c12:	62 72 3d 48 14 c7    	vprorvd %zmm7,%zmm8,%zmm8
 1560c18:	62 f2 7d 48 14 ff    	vprorvd %zmm7,%zmm0,%zmm7
 1560c1e:	62 f1 fd 48 6f 05 58 19 fc fe 	vmovdqa64 -0x103e6a8(%rip),%zmm0        # 522580 <branch_sizing_patterns+0x27f0>
 1560c28:	62 d1 3d 48 72 e0 1f 	vpsrad $0x1f,%zmm8,%zmm8
 1560c2f:	62 93 75 48 25 fe e2 	vpternlogd $0xe2,%zmm30,%zmm1,%zmm7
 1560c36:	62 93 3d 48 25 fe e2 	vpternlogd $0xe2,%zmm30,%zmm8,%zmm7
 1560c3d:	62 93 5d 48 25 eb fe 	vpternlogd $0xfe,%zmm27,%zmm4,%zmm5
 1560c44:	62 91 fd 48 6f e7    	vmovdqa64 %zmm31,%zmm4
 1560c4a:	62 01 fd 48 6f df    	vmovdqa64 %zmm31,%zmm27
 1560c50:	62 f3 6d 58 25 25 b5 f9 01 ff f8 	vpternlogd $0xf8,-0xfe064b(%rip){1to16},%zmm2,%zmm4        # 580610 <tier0_emit_x87.operations+0x1c8>
 1560c5b:	62 63 75 58 25 1d a6 f9 01 ff f8 	vpternlogd $0xf8,-0xfe065a(%rip){1to16},%zmm1,%zmm27        # 58060c <tier0_emit_x87.operations+0x1c4>
 1560c66:	62 f1 6d 58 db 15 d8 f9 01 ff 	vpandd -0xfe0628(%rip){1to16},%zmm2,%zmm2        # 580648 <tier0_emit_x87.operations+0x200>
 1560c70:	62 32 fd 48 7e de    	vpermt2q %zmm22,%zmm0,%zmm11
 1560c76:	62 82 fd 48 7e c0    	vpermt2q %zmm24,%zmm0,%zmm16
 1560c7c:	62 82 fd 48 7e d1    	vpermt2q %zmm25,%zmm0,%zmm18
 1560c82:	62 82 fd 48 7e ea    	vpermt2q %zmm26,%zmm0,%zmm21
 1560c88:	62 91 7d 48 72 d7 10 	vpsrld $0x10,%zmm31,%zmm0
 1560c8f:	62 91 4d 40 72 d7 03 	vpsrld $0x3,%zmm31,%zmm22
 1560c96:	62 e3 7d 58 25 35 8f f9 01 ff ec 	vpternlogd $0xec,-0xfe0671(%rip){1to16},%zmm0,%zmm22        # 580630 <tier0_emit_x87.operations+0x1e8>
 1560ca1:	62 f2 7d 48 5a 05 b5 57 01 ff 	vbroadcasti32x4 -0xfea84b(%rip),%zmm0        # 576460 <x86_effects_unknown+0xa00>
 1560cab:	62 93 3d 48 25 e3 b8 	vpternlogd $0xb8,%zmm27,%zmm8,%zmm4
 1560cb2:	62 61 75 58 db 1d 88 f9 01 ff 	vpandd -0xfe0678(%rip){1to16},%zmm1,%zmm27        # 580644 <tier0_emit_x87.operations+0x1fc>
 1560cbc:	62 d1 4d 48 fe cc    	vpaddd %zmm12,%zmm6,%zmm1
 1560cc2:	62 f1 75 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm1
 1560cc9:	62 93 3d 48 25 d3 b8 	vpternlogd $0xb8,%zmm27,%zmm8,%zmm2
 1560cd0:	62 51 8d 48 6c c7    	vpunpcklqdq %zmm15,%zmm14,%zmm8
 1560cd6:	62 11 9d 40 6d f5    	vpunpckhqdq %zmm29,%zmm28,%zmm14
 1560cdc:	62 f1 3d 48 6a f7    	vpunpckhdq %zmm7,%zmm8,%zmm6
 1560ce2:	62 51 0d 48 eb d2    	vpord  %zmm10,%zmm14,%zmm10
 1560ce8:	62 71 6d 48 eb fd    	vpord  %zmm5,%zmm2,%zmm15
 1560cee:	62 b1 6d 48 72 f6 08 	vpslld $0x8,%zmm22,%zmm2
 1560cf5:	62 f3 75 58 25 15 4c f9 01 ff 08 	vpternlogd $0x8,-0xfe06b4(%rip){1to16},%zmm1,%zmm2        # 58064c <tier0_emit_x87.operations+0x204>
 1560d00:	62 d1 55 48 72 f2 07 	vpslld $0x7,%zmm10,%zmm5
 1560d07:	62 f3 55 58 25 15 3e f9 01 ff d8 	vpternlogd $0xd8,-0xfe06c2(%rip){1to16},%zmm5,%zmm2        # 580650 <tier0_emit_x87.operations+0x208>
 1560d12:	62 d2 fd 48 83 ee    	vpmultishiftqb %zmm14,%zmm0,%zmm5
 1560d18:	62 f3 4d 50 25 2d 31 f9 01 ff d8 	vpternlogd $0xd8,-0xfe06cf(%rip){1to16},%zmm22,%zmm5        # 580654 <tier0_emit_x87.operations+0x20c>
 1560d23:	62 d1 7d 48 70 c7 55 	vpshufd $0x55,%zmm15,%zmm0
 1560d2a:	62 b2 7d 48 8f d0    	vpshufbitqmb %zmm16,%zmm0,%k2
 1560d30:	c4 61 fb 93 f2       	kmovq  %k2,%r14
 1560d35:	f3 4d 0f b8 f6       	popcnt %r14,%r14
 1560d3a:	62 f3 6d 58 25 2d 13 f9 01 ff d8 	vpternlogd $0xd8,-0xfe06ed(%rip){1to16},%zmm2,%zmm5        # 580658 <tier0_emit_x87.operations+0x210>
 1560d45:	62 f1 3d 48 62 d7    	vpunpckldq %zmm7,%zmm8,%zmm2
 1560d4b:	62 f1 5d 48 62 fd    	vpunpckldq %zmm5,%zmm4,%zmm7
 1560d51:	62 f1 5d 48 6a e5    	vpunpckhdq %zmm5,%zmm4,%zmm4
 1560d57:	62 f1 ed 48 6c ef    	vpunpcklqdq %zmm7,%zmm2,%zmm5
 1560d5d:	62 f1 ed 48 6d d7    	vpunpckhqdq %zmm7,%zmm2,%zmm2
 1560d63:	62 f1 cd 48 6c fc    	vpunpcklqdq %zmm4,%zmm6,%zmm7
 1560d69:	62 f1 cd 48 6d e4    	vpunpckhqdq %zmm4,%zmm6,%zmm4
 1560d6f:	62 d1 7d 48 70 f7 00 	vpshufd $0x0,%zmm15,%zmm6
 1560d76:	62 d2 55 48 00 eb    	vpshufb %zmm11,%zmm5,%zmm5
 1560d7c:	62 d2 4d 48 8f db    	vpshufbitqmb %zmm11,%zmm6,%k3
 1560d82:	62 b2 6d 48 00 d0    	vpshufb %zmm16,%zmm2,%zmm2
 1560d88:	62 b2 45 48 00 c2    	vpshufb %zmm18,%zmm7,%zmm0
 1560d8e:	62 f3 95 48 25 eb 78 	vpternlogq $0x78,%zmm3,%zmm13,%zmm5
 1560d95:	62 f3 f5 40 25 d3 78 	vpternlogq $0x78,%zmm3,%zmm17,%zmm2
 1560d9c:	62 f3 e5 40 25 c3 78 	vpternlogq $0x78,%zmm3,%zmm19,%zmm0
 1560da3:	62 f2 7d cb 63 ed    	vpcompressb %zmm5,%zmm5{%k3}{z}
 1560da9:	62 f2 7d ca 63 d2    	vpcompressb %zmm2,%zmm2{%k2}{z}
 1560daf:	c4 e1 fb 93 fb       	kmovq  %k3,%rdi
 1560db4:	f3 48 0f b8 ff       	popcnt %rdi,%rdi
 1560db9:	62 d1 fe 48 7f 2b    	vmovdqu64 %zmm5,(%r11)
 1560dbf:	62 d1 7d 48 70 ef aa 	vpshufd $0xaa,%zmm15,%zmm5
 1560dc6:	62 d1 fe 48 7f 14 3b 	vmovdqu64 %zmm2,(%r11,%rdi,1)
 1560dcd:	4c 01 df             	add    %r11,%rdi
 1560dd0:	41 29 db             	sub    %ebx,%r11d
 1560dd3:	62 b2 55 48 8f da    	vpshufbitqmb %zmm18,%zmm5,%k3
 1560dd9:	62 d1 7d 48 70 ef ff 	vpshufd $0xff,%zmm15,%zmm5
 1560de0:	62 73 5d 50 25 3d 71 f8 01 ff 20 	vpternlogd $0x20,-0xfe078f(%rip){1to16},%zmm20,%zmm15        # 58065c <tier0_emit_x87.operations+0x214>
 1560deb:	62 b2 55 48 8f d5    	vpshufbitqmb %zmm21,%zmm5,%k2
 1560df1:	c5 e9 ef d2          	vpxor  %xmm2,%xmm2,%xmm2
 1560df5:	62 f2 7d cb 63 c2    	vpcompressb %zmm0,%zmm2{%k3}{z}
 1560dfb:	62 b2 5d 48 00 c5    	vpshufb %zmm21,%zmm4,%zmm0
 1560e01:	62 f1 5d 50 db 25 55 f8 01 ff 	vpandd -0xfe07ab(%rip){1to16},%zmm20,%zmm4        # 580660 <tier0_emit_x87.operations+0x218>
 1560e0b:	62 f3 c5 40 25 c3 78 	vpternlogq $0x78,%zmm3,%zmm23,%zmm0
 1560e12:	62 d1 fe 48 7f 14 3e 	vmovdqu64 %zmm2,(%r14,%rdi,1)
 1560e19:	c5 e9 ef d2          	vpxor  %xmm2,%xmm2,%xmm2
 1560e1d:	62 f2 7d ca 63 c2    	vpcompressb %zmm0,%zmm2{%k2}{z}
 1560e23:	62 d2 7d 48 55 c7    	vpopcntd %zmm15,%zmm0
 1560e29:	49 01 fe             	add    %rdi,%r14
 1560e2c:	c4 e1 fb 93 fb       	kmovq  %k3,%rdi
 1560e31:	f3 4c 0f b8 ff       	popcnt %rdi,%r15
 1560e36:	c4 e1 fb 93 fa       	kmovq  %k2,%rdi
 1560e3b:	f3 48 0f b8 ff       	popcnt %rdi,%rdi
 1560e40:	62 f1 75 48 fe cc    	vpaddd %zmm4,%zmm1,%zmm1
 1560e46:	4c 01 ff             	add    %r15,%rdi
 1560e49:	62 f1 75 48 fe c8    	vpaddd %zmm0,%zmm1,%zmm1
 1560e4f:	c5 f9 6f 05 99 55 01 ff 	vmovdqa -0xfeaa67(%rip),%xmm0        # 5763f0 <x86_effects_unknown+0x990>
 1560e57:	4c 01 f7             	add    %r14,%rdi
 1560e5a:	62 91 fe 48 7f 14 37 	vmovdqu64 %zmm2,(%r15,%r14,1)
 1560e61:	44 89 5c 24 40       	mov    %r11d,0x40(%rsp)
 1560e66:	62 f2 7d 48 8d c9    	vpermb %zmm1,%zmm0,%zmm1
 1560e6c:	c5 f9 6f 05 8c 55 01 ff 	vmovdqa -0xfeaa74(%rip),%xmm0        # 576400 <x86_effects_unknown+0x9a0>
 1560e74:	62 f2 f5 18 40 0d c2 f5 01 ff 	vpmullq -0xfe0a3e(%rip){1to2},%xmm1,%xmm1        # 580440 <x86_semantics_benchmark_code.registers+0x450>
 1560e7e:	62 d2 7d 48 8d d6    	vpermb %zmm14,%zmm0,%zmm2
 1560e84:	c4 e2 71 00 05 83 55 01 ff 	vpshufb -0xfeaa7d(%rip),%xmm1,%xmm0        # 576410 <x86_effects_unknown+0x9b0>
 1560e8d:	62 f2 7e 48 29 da    	vpmovb2m %zmm2,%k3
 1560e93:	c5 7b 93 db          	kmovd  %k3,%r11d
 1560e97:	45 0f b7 db          	movzwl %r11w,%r11d
 1560e9b:	c5 f9 fc c9          	vpaddb %xmm1,%xmm0,%xmm1
 1560e9f:	f3 45 0f b8 db       	popcnt %r11d,%r11d
 1560ea4:	49 ff c8             	dec    %r8
 1560ea7:	62 f2 7d 48 31 c9    	vpmovzxbd %xmm1,%zmm1
 1560ead:	62 f1 75 58 fe 4c 24 10 	vpaddd 0x40(%rsp){1to16},%zmm1,%zmm1
 1560eb5:	62 f2 7d cb 8b c9    	vpcompressd %zmm1,%zmm1{%k3}{z}
 1560ebb:	62 f1 fe 48 7f 09    	vmovdqu64 %zmm1,(%rcx)
 1560ec1:	4a 8d 0c 99          	lea    (%rcx,%r11,4),%rcx
 1560ec5:	49 89 fb             	mov    %rdi,%r11
 1560ec8:	0f 85 12 fa ff ff    	jne    15608e0 <x86_encode_16+0xa0>
 1560ece:	4c 8d 40 10          	lea    0x10(%rax),%r8
 1560ed2:	49 39 d0             	cmp    %rdx,%r8
 1560ed5:	76 08                	jbe    1560edf <x86_encode_16+0x69f>
 1560ed7:	49 89 fe             	mov    %rdi,%r14
 1560eda:	e9 3f 06 00 00       	jmp    156151e <x86_encode_16+0xcde>
 1560edf:	62 f2 7d 48 5a 1d f7 54 01 ff 	vbroadcasti32x4 -0xfeab09(%rip),%zmm3        # 5763e0 <x86_effects_unknown+0x980>
 1560ee9:	62 72 7d 48 58 0d 2d f7 01 ff 	vpbroadcastd -0xfe08d3(%rip),%zmm9        # 580620 <tier0_emit_x87.operations+0x1d8>
 1560ef3:	49 89 d0             	mov    %rdx,%r8
 1560ef6:	49 29 c0             	sub    %rax,%r8
 1560ef9:	49 89 c1             	mov    %rax,%r9
 1560efc:	49 c1 e1 04          	shl    $0x4,%r9
 1560f00:	41 b3 cc             	mov    $0xcc,%r11b
 1560f03:	4c 8d 15 76 59 10 0d 	lea    0xd105976(%rip),%r10        # e666880 <x86_template_storage>
 1560f0a:	62 53 1d 48 25 e4 ff 	vpternlogd $0xff,%zmm12,%zmm12,%zmm12
 1560f11:	49 83 c0 f0          	add    $0xfffffffffffffff0,%r8
 1560f15:	4d 8d 8c 31 fc 00 00 00 	lea    0xfc(%r9,%rsi,1),%r9
 1560f1d:	c4 c1 7b 92 cb       	kmovd  %r11d,%k1
 1560f22:	49 c1 e8 04          	shr    $0x4,%r8
 1560f26:	49 ff c0             	inc    %r8
 1560f29:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
 1560f30:	45 0f b7 99 10 ff ff ff 	movzwl -0xf0(%r9),%r11d
 1560f38:	45 0f b7 b1 20 ff ff ff 	movzwl -0xe0(%r9),%r14d
 1560f40:	45 0f b7 b9 30 ff ff ff 	movzwl -0xd0(%r9),%r15d
 1560f48:	45 0f b7 a1 40 ff ff ff 	movzwl -0xc0(%r9),%r12d
 1560f50:	62 c1 fe 48 6f a1 04 ff ff ff 	vmovdqu64 -0xfc(%r9),%zmm20
 1560f5a:	62 41 fe 48 6f 99 44 ff ff ff 	vmovdqu64 -0xbc(%r9),%zmm27
 1560f64:	62 41 fe 48 6f a9 84 ff ff ff 	vmovdqu64 -0x7c(%r9),%zmm29
 1560f6e:	62 41 fe 48 6f b1 c4 ff ff ff 	vmovdqu64 -0x3c(%r9),%zmm30
 1560f78:	62 f2 7d 48 5a 2d 9e 54 01 ff 	vbroadcasti32x4 -0xfeab62(%rip),%zmm5        # 576420 <x86_effects_unknown+0x9c0>
 1560f82:	62 f2 7d 48 5a 05 a4 54 01 ff 	vbroadcasti32x4 -0xfeab5c(%rip),%zmm0        # 576430 <x86_effects_unknown+0x9d0>
 1560f8c:	62 72 7d 48 58 05 72 f6 01 ff 	vpbroadcastd -0xfe098e(%rip),%zmm8        # 580608 <tier0_emit_x87.operations+0x1c0>
 1560f96:	48 83 c0 10          	add    $0x10,%rax
 1560f9a:	41 c1 e3 06          	shl    $0x6,%r11d
 1560f9e:	41 c1 e6 06          	shl    $0x6,%r14d
 1560fa2:	41 c1 e7 06          	shl    $0x6,%r15d
 1560fa6:	41 c1 e4 06          	shl    $0x6,%r12d
 1560faa:	c4 81 7d 6f 4c 13 40 	vmovdqa 0x40(%r11,%r10,1),%ymm1
 1560fb1:	45 0f b7 99 50 ff ff ff 	movzwl -0xb0(%r9),%r11d
 1560fb9:	62 13 f5 48 3a 5c 17 02 01 	vinserti64x4 $0x1,0x40(%r15,%r10,1),%zmm1,%zmm11
 1560fc2:	45 0f b7 b9 70 ff ff ff 	movzwl -0x90(%r9),%r15d
 1560fca:	c4 81 7d 6f 4c 16 60 	vmovdqa 0x60(%r14,%r10,1),%ymm1
 1560fd1:	45 0f b7 b1 60 ff ff ff 	movzwl -0xa0(%r9),%r14d
 1560fd9:	62 83 f5 48 3a 74 14 03 01 	vinserti64x4 $0x1,0x60(%r12,%r10,1),%zmm1,%zmm22
 1560fe2:	45 0f b7 61 80       	movzwl -0x80(%r9),%r12d
 1560fe7:	62 11 15 40 62 fe    	vpunpckldq %zmm30,%zmm29,%zmm15
 1560fed:	62 01 5d 40 6a e3    	vpunpckhdq %zmm27,%zmm20,%zmm28
 1560ff3:	62 01 15 40 6a ee    	vpunpckhdq %zmm30,%zmm29,%zmm29
 1560ff9:	62 11 5d 40 62 f3    	vpunpckldq %zmm27,%zmm20,%zmm14
 1560fff:	62 11 9d 40 6c d5    	vpunpcklqdq %zmm29,%zmm28,%zmm10
 1561005:	62 41 8d 48 6d f7    	vpunpckhqdq %zmm15,%zmm14,%zmm30
 156100b:	62 d2 fd 48 83 f2    	vpmultishiftqb %zmm10,%zmm0,%zmm6
 1561011:	62 92 0d 40 27 c6    	vptestmd %zmm30,%zmm30,%k0
 1561017:	62 91 7d 48 72 e6 1f 	vpsrad $0x1f,%zmm30,%zmm0
 156101e:	62 41 fd 48 6f da    	vmovdqa64 %zmm10,%zmm27
 1561024:	41 c1 e3 06          	shl    $0x6,%r11d
 1561028:	c4 81 7d 6f 4c 13 40 	vmovdqa 0x40(%r11,%r10,1),%ymm1
 156102f:	45 0f b7 59 90       	movzwl -0x70(%r9),%r11d
 1561034:	41 c1 e7 06          	shl    $0x6,%r15d
 1561038:	41 c1 e6 06          	shl    $0x6,%r14d
 156103c:	62 83 f5 48 3a 44 17 02 01 	vinserti64x4 $0x1,0x40(%r15,%r10,1),%zmm1,%zmm16
 1561045:	45 0f b7 79 b0       	movzwl -0x50(%r9),%r15d
 156104a:	c4 81 7d 6f 4c 16 60 	vmovdqa 0x60(%r14,%r10,1),%ymm1
 1561051:	45 0f b7 71 a0       	movzwl -0x60(%r9),%r14d
 1561056:	41 c1 e4 06          	shl    $0x6,%r12d
 156105a:	62 03 f5 48 3a 44 14 03 01 	vinserti64x4 $0x1,0x60(%r12,%r10,1),%zmm1,%zmm24
 1561063:	45 0f b7 61 c0       	movzwl -0x40(%r9),%r12d
 1561068:	62 32 a5 49 64 ee    	vpblendmq %zmm22,%zmm11,%zmm13{%k1}
 156106e:	41 c1 e3 06          	shl    $0x6,%r11d
 1561072:	c4 81 7d 6f 4c 13 40 	vmovdqa 0x40(%r11,%r10,1),%ymm1
 1561079:	45 0f b7 59 d0       	movzwl -0x30(%r9),%r11d
 156107e:	41 c1 e7 06          	shl    $0x6,%r15d
 1561082:	41 c1 e6 06          	shl    $0x6,%r14d
 1561086:	62 83 f5 48 3a 54 17 02 01 	vinserti64x4 $0x1,0x40(%r15,%r10,1),%zmm1,%zmm18
 156108f:	45 0f b7 79 f0       	movzwl -0x10(%r9),%r15d
 1561094:	c4 81 7d 6f 4c 16 60 	vmovdqa 0x60(%r14,%r10,1),%ymm1
 156109b:	45 0f b7 71 e0       	movzwl -0x20(%r9),%r14d
 15610a0:	41 c1 e4 06          	shl    $0x6,%r12d
 15610a4:	62 03 f5 48 3a 4c 14 03 01 	vinserti64x4 $0x1,0x60(%r12,%r10,1),%zmm1,%zmm25
 15610ad:	45 0f b7 21          	movzwl (%r9),%r12d
 15610b1:	49 81 c1 00 01 00 00 	add    $0x100,%r9
 15610b8:	62 82 fd 41 64 c8    	vpblendmq %zmm24,%zmm16,%zmm17{%k1}
 15610be:	41 c1 e3 06          	shl    $0x6,%r11d
 15610c2:	41 c1 e6 06          	shl    $0x6,%r14d
 15610c6:	41 c1 e7 06          	shl    $0x6,%r15d
 15610ca:	c4 81 7d 6f 4c 13 40 	vmovdqa 0x40(%r11,%r10,1),%ymm1
 15610d1:	62 83 f5 48 3a 6c 17 02 01 	vinserti64x4 $0x1,0x40(%r15,%r10,1),%zmm1,%zmm21
 15610da:	41 c1 e4 06          	shl    $0x6,%r12d
 15610de:	c4 81 7d 6f 4c 16 60 	vmovdqa 0x60(%r14,%r10,1),%ymm1
 15610e5:	62 03 f5 48 3a 54 14 03 01 	vinserti64x4 $0x1,0x60(%r12,%r10,1),%zmm1,%zmm26
 15610ee:	62 b1 15 48 6a c9    	vpunpckhdq %zmm17,%zmm13,%zmm1
 15610f4:	62 82 ed 41 64 d9    	vpblendmq %zmm25,%zmm18,%zmm19{%k1}
 15610fa:	62 82 d5 41 64 fa    	vpblendmq %zmm26,%zmm21,%zmm23{%k1}
 1561100:	62 b1 65 40 6a d7    	vpunpckhdq %zmm23,%zmm19,%zmm2
 1561106:	62 e1 f5 48 6d e2    	vpunpckhqdq %zmm2,%zmm1,%zmm20
 156110c:	62 d1 75 48 72 d2 1a 	vpsrld $0x1a,%zmm10,%zmm1
 1561113:	62 f2 75 48 36 3d a3 14 fc fe 	vpermd -0x103eb5d(%rip),%zmm1,%zmm7        # 5225c0 <branch_sizing_patterns+0x2830>
 156111d:	62 62 75 48 36 3d d9 14 fc fe 	vpermd -0x103eb27(%rip),%zmm1,%zmm31        # 522600 <branch_sizing_patterns+0x2870>
 1561127:	62 f2 75 48 36 25 0f 15 fc fe 	vpermd -0x103eaf1(%rip),%zmm1,%zmm4        # 522640 <branch_sizing_patterns+0x28b0>
 1561131:	62 d2 d5 48 83 ca    	vpmultishiftqb %zmm10,%zmm5,%zmm1
 1561137:	62 f2 7d 48 5a 2d ff 52 01 ff 	vbroadcasti32x4 -0xfead01(%rip),%zmm5        # 576440 <x86_effects_unknown+0x9e0>
 1561141:	62 d2 d5 48 83 ea    	vpmultishiftqb %zmm10,%zmm5,%zmm5
 1561147:	62 f3 75 58 25 2d aa f4 01 ff d8 	vpternlogd $0xd8,-0xfe0b56(%rip){1to16},%zmm1,%zmm5        # 5805fc <tier0_emit_x87.operations+0x1b4>
 1561152:	62 d1 75 48 72 f2 04 	vpslld $0x4,%zmm10,%zmm1
 1561159:	62 f1 6d 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm2
 1561160:	62 f3 55 58 25 35 95 f4 01 ff e4 	vpternlogd $0xe4,-0xfe0b6b(%rip){1to16},%zmm5,%zmm6        # 580600 <tier0_emit_x87.operations+0x1b8>
 156116b:	62 f2 7d 48 5a 2d db 52 01 ff 	vbroadcasti32x4 -0xfead25(%rip),%zmm5        # 576450 <x86_effects_unknown+0x9f0>
 1561175:	62 d2 55 48 00 ea    	vpshufb %zmm10,%zmm5,%zmm5
 156117b:	62 63 4d 48 25 ff f8 	vpternlogd $0xf8,%zmm7,%zmm6,%zmm31
 1561182:	62 f1 75 48 72 f5 10 	vpslld $0x10,%zmm5,%zmm1
 1561189:	62 f1 6d 48 db ed    	vpandd %zmm5,%zmm2,%zmm5
 156118f:	62 f3 5d 58 25 2d a2 f4 01 ff ec 	vpternlogd $0xec,-0xfe0b5e(%rip){1to16},%zmm4,%zmm5        # 58063c <tier0_emit_x87.operations+0x1f4>
 156119a:	62 f1 45 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm7
 15611a1:	62 f2 7e 48 38 c8    	vpmovm2d %k0,%zmm1
 15611a7:	62 f3 5d 50 25 2d 8e f4 01 ff f8 	vpternlogd $0xf8,-0xfe0b72(%rip){1to16},%zmm20,%zmm5        # 580640 <tier0_emit_x87.operations+0x1f8>
 15611b2:	62 f3 6d 48 25 cf c8 	vpternlogd $0xc8,%zmm7,%zmm2,%zmm1
 15611b9:	62 91 7d 48 ef fe    	vpxord %zmm30,%zmm0,%zmm7
 15611bf:	62 f2 7d 48 58 05 3b f4 01 ff 	vpbroadcastd -0xfe0bc5(%rip),%zmm0        # 580604 <tier0_emit_x87.operations+0x1bc>
 15611c9:	62 f2 7d 48 44 ff    	vplzcntd %zmm7,%zmm7
 15611cf:	62 f2 3d 48 45 ff    	vpsrlvd %zmm7,%zmm8,%zmm7
 15611d5:	62 51 0d 40 fe c4    	vpaddd %zmm12,%zmm30,%zmm8
 15611db:	62 73 0d 40 25 c7 14 	vpternlogd $0x14,%zmm7,%zmm30,%zmm8
 15611e2:	62 d1 45 48 72 d2 08 	vpsrld $0x8,%zmm10,%zmm7
 15611e9:	62 63 7d 58 25 1d 20 f4 01 ff 6c 	vpternlogd $0x6c,-0xfe0be0(%rip){1to16},%zmm0,%zmm27        # 580614 <tier0_emit_x87.operations+0x1cc>
 15611f4:	62 f3 7d 58 25 3d 19 f4 01 ff 6c 	vpternlogd $0x6c,-0xfe0be7(%rip){1to16},%zmm0,%zmm7        # 580618 <tier0_emit_x87.operations+0x1d0>
 15611ff:	62 91 7d 48 72 ce 01 	vprold $0x1,%zmm30,%zmm0
 1561206:	62 41 25 40 fe dc    	vpaddd %zmm12,%zmm27,%zmm27
 156120c:	62 63 35 58 25 1d 05 f4 01 ff ec 	vpternlogd $0xec,-0xfe0bfb(%rip){1to16},%zmm9,%zmm27        # 58061c <tier0_emit_x87.operations+0x1d4>
 1561217:	62 d1 45 48 fe fc    	vpaddd %zmm12,%zmm7,%zmm7
 156121d:	62 f3 25 50 25 3d fc f3 01 ff ec 	vpternlogd $0xec,-0xfe0c04(%rip){1to16},%zmm27,%zmm7        # 580624 <tier0_emit_x87.operations+0x1dc>
 1561228:	62 61 4d 58 db 1d f6 f3 01 ff 	vpandd -0xfe0c0a(%rip){1to16},%zmm6,%zmm27        # 580628 <tier0_emit_x87.operations+0x1e0>
 1561232:	62 f1 4d 48 72 d6 03 	vpsrld $0x3,%zmm6,%zmm6
 1561239:	62 f3 5d 50 25 35 f0 f3 01 ff a2 	vpternlogd $0xa2,-0xfe0c10(%rip){1to16},%zmm20,%zmm6        # 580634 <tier0_emit_x87.operations+0x1ec>
 1561244:	62 f2 4d 58 3b 25 ea f3 01 ff 	vpminud -0xfe0c16(%rip){1to16},%zmm6,%zmm4        # 580638 <tier0_emit_x87.operations+0x1f0>
 156124e:	62 63 5d 40 25 df f8 	vpternlogd $0xf8,%zmm7,%zmm20,%zmm27
 1561255:	62 62 25 50 3b 1d cd f3 01 ff 	vpminud -0xfe0c33(%rip){1to16},%zmm27,%zmm27        # 58062c <tier0_emit_x87.operations+0x1e4>
 156125f:	62 b1 45 48 72 d4 1d 	vpsrld $0x1d,%zmm20,%zmm7
 1561266:	62 72 3d 48 14 c7    	vprorvd %zmm7,%zmm8,%zmm8
 156126c:	62 f2 7d 48 14 ff    	vprorvd %zmm7,%zmm0,%zmm7
 1561272:	62 f1 fd 48 6f 05 04 13 fc fe 	vmovdqa64 -0x103ecfc(%rip),%zmm0        # 522580 <branch_sizing_patterns+0x27f0>
 156127c:	62 d1 3d 48 72 e0 1f 	vpsrad $0x1f,%zmm8,%zmm8
 1561283:	62 93 75 48 25 fe e2 	vpternlogd $0xe2,%zmm30,%zmm1,%zmm7
 156128a:	62 93 3d 48 25 fe e2 	vpternlogd $0xe2,%zmm30,%zmm8,%zmm7
 1561291:	62 93 5d 48 25 eb fe 	vpternlogd $0xfe,%zmm27,%zmm4,%zmm5
 1561298:	62 91 fd 48 6f e7    	vmovdqa64 %zmm31,%zmm4
 156129e:	62 01 fd 48 6f df    	vmovdqa64 %zmm31,%zmm27
 15612a4:	62 f3 6d 58 25 25 61 f3 01 ff f8 	vpternlogd $0xf8,-0xfe0c9f(%rip){1to16},%zmm2,%zmm4        # 580610 <tier0_emit_x87.operations+0x1c8>
 15612af:	62 63 75 58 25 1d 52 f3 01 ff f8 	vpternlogd $0xf8,-0xfe0cae(%rip){1to16},%zmm1,%zmm27        # 58060c <tier0_emit_x87.operations+0x1c4>
 15612ba:	62 f1 6d 58 db 15 84 f3 01 ff 	vpandd -0xfe0c7c(%rip){1to16},%zmm2,%zmm2        # 580648 <tier0_emit_x87.operations+0x200>
 15612c4:	62 32 fd 48 7e de    	vpermt2q %zmm22,%zmm0,%zmm11
 15612ca:	62 82 fd 48 7e c0    	vpermt2q %zmm24,%zmm0,%zmm16
 15612d0:	62 82 fd 48 7e d1    	vpermt2q %zmm25,%zmm0,%zmm18
 15612d6:	62 82 fd 48 7e ea    	vpermt2q %zmm26,%zmm0,%zmm21
 15612dc:	62 91 7d 48 72 d7 10 	vpsrld $0x10,%zmm31,%zmm0
 15612e3:	62 91 4d 40 72 d7 03 	vpsrld $0x3,%zmm31,%zmm22
 15612ea:	62 e3 7d 58 25 35 3b f3 01 ff ec 	vpternlogd $0xec,-0xfe0cc5(%rip){1to16},%zmm0,%zmm22        # 580630 <tier0_emit_x87.operations+0x1e8>
 15612f5:	62 f2 7d 48 5a 05 61 51 01 ff 	vbroadcasti32x4 -0xfeae9f(%rip),%zmm0        # 576460 <x86_effects_unknown+0xa00>
 15612ff:	62 93 3d 48 25 e3 b8 	vpternlogd $0xb8,%zmm27,%zmm8,%zmm4
 1561306:	62 61 75 58 db 1d 34 f3 01 ff 	vpandd -0xfe0ccc(%rip){1to16},%zmm1,%zmm27        # 580644 <tier0_emit_x87.operations+0x1fc>
 1561310:	62 d1 4d 48 fe cc    	vpaddd %zmm12,%zmm6,%zmm1
 1561316:	62 f1 75 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm1
 156131d:	62 93 3d 48 25 d3 b8 	vpternlogd $0xb8,%zmm27,%zmm8,%zmm2
 1561324:	62 51 8d 48 6c c7    	vpunpcklqdq %zmm15,%zmm14,%zmm8
 156132a:	62 11 9d 40 6d f5    	vpunpckhqdq %zmm29,%zmm28,%zmm14
 1561330:	62 f1 3d 48 6a f7    	vpunpckhdq %zmm7,%zmm8,%zmm6
 1561336:	62 51 0d 48 eb d2    	vpord  %zmm10,%zmm14,%zmm10
 156133c:	62 71 6d 48 eb fd    	vpord  %zmm5,%zmm2,%zmm15
 1561342:	62 b1 6d 48 72 f6 08 	vpslld $0x8,%zmm22,%zmm2
 1561349:	62 f3 75 58 25 15 f8 f2 01 ff 08 	vpternlogd $0x8,-0xfe0d08(%rip){1to16},%zmm1,%zmm2        # 58064c <tier0_emit_x87.operations+0x204>
 1561354:	62 d1 55 48 72 f2 07 	vpslld $0x7,%zmm10,%zmm5
 156135b:	62 f3 55 58 25 15 ea f2 01 ff d8 	vpternlogd $0xd8,-0xfe0d16(%rip){1to16},%zmm5,%zmm2        # 580650 <tier0_emit_x87.operations+0x208>
 1561366:	62 d2 fd 48 83 ee    	vpmultishiftqb %zmm14,%zmm0,%zmm5
 156136c:	62 f3 4d 50 25 2d dd f2 01 ff d8 	vpternlogd $0xd8,-0xfe0d23(%rip){1to16},%zmm22,%zmm5        # 580654 <tier0_emit_x87.operations+0x20c>
 1561377:	62 d1 7d 48 70 c7 55 	vpshufd $0x55,%zmm15,%zmm0
 156137e:	62 b2 7d 48 8f d0    	vpshufbitqmb %zmm16,%zmm0,%k2
 1561384:	c4 61 fb 93 f2       	kmovq  %k2,%r14
 1561389:	f3 4d 0f b8 f6       	popcnt %r14,%r14
 156138e:	62 f3 6d 58 25 2d bf f2 01 ff d8 	vpternlogd $0xd8,-0xfe0d41(%rip){1to16},%zmm2,%zmm5        # 580658 <tier0_emit_x87.operations+0x210>
 1561399:	62 f1 3d 48 62 d7    	vpunpckldq %zmm7,%zmm8,%zmm2
 156139f:	62 f1 5d 48 62 fd    	vpunpckldq %zmm5,%zmm4,%zmm7
 15613a5:	62 f1 5d 48 6a e5    	vpunpckhdq %zmm5,%zmm4,%zmm4
 15613ab:	62 f1 ed 48 6c ef    	vpunpcklqdq %zmm7,%zmm2,%zmm5
 15613b1:	62 f1 ed 48 6d d7    	vpunpckhqdq %zmm7,%zmm2,%zmm2
 15613b7:	62 f1 cd 48 6c fc    	vpunpcklqdq %zmm4,%zmm6,%zmm7
 15613bd:	62 f1 cd 48 6d e4    	vpunpckhqdq %zmm4,%zmm6,%zmm4
 15613c3:	62 d1 7d 48 70 f7 00 	vpshufd $0x0,%zmm15,%zmm6
 15613ca:	62 d2 55 48 00 eb    	vpshufb %zmm11,%zmm5,%zmm5
 15613d0:	62 d2 4d 48 8f db    	vpshufbitqmb %zmm11,%zmm6,%k3
 15613d6:	62 b2 6d 48 00 d0    	vpshufb %zmm16,%zmm2,%zmm2
 15613dc:	62 b2 45 48 00 c2    	vpshufb %zmm18,%zmm7,%zmm0
 15613e2:	62 f3 95 48 25 eb 78 	vpternlogq $0x78,%zmm3,%zmm13,%zmm5
 15613e9:	62 f3 f5 40 25 d3 78 	vpternlogq $0x78,%zmm3,%zmm17,%zmm2
 15613f0:	62 f3 e5 40 25 c3 78 	vpternlogq $0x78,%zmm3,%zmm19,%zmm0
 15613f7:	62 f2 7d cb 63 ed    	vpcompressb %zmm5,%zmm5{%k3}{z}
 15613fd:	62 f2 7d ca 63 d2    	vpcompressb %zmm2,%zmm2{%k2}{z}
 1561403:	c4 61 fb 93 db       	kmovq  %k3,%r11
 1561408:	f3 4d 0f b8 db       	popcnt %r11,%r11
 156140d:	62 f1 fe 48 7f 2f    	vmovdqu64 %zmm5,(%rdi)
 1561413:	62 d1 7d 48 70 ef aa 	vpshufd $0xaa,%zmm15,%zmm5
 156141a:	62 b1 fe 48 7f 14 1f 	vmovdqu64 %zmm2,(%rdi,%r11,1)
 1561421:	49 01 fb             	add    %rdi,%r11
 1561424:	29 df                	sub    %ebx,%edi
 1561426:	62 b2 55 48 8f da    	vpshufbitqmb %zmm18,%zmm5,%k3
 156142c:	62 d1 7d 48 70 ef ff 	vpshufd $0xff,%zmm15,%zmm5
 1561433:	62 73 5d 50 25 3d 1e f2 01 ff 20 	vpternlogd $0x20,-0xfe0de2(%rip){1to16},%zmm20,%zmm15        # 58065c <tier0_emit_x87.operations+0x214>
 156143e:	62 b2 55 48 8f d5    	vpshufbitqmb %zmm21,%zmm5,%k2
 1561444:	c5 e9 ef d2          	vpxor  %xmm2,%xmm2,%xmm2
 1561448:	62 f2 7d cb 63 c2    	vpcompressb %zmm0,%zmm2{%k3}{z}
 156144e:	62 b2 5d 48 00 c5    	vpshufb %zmm21,%zmm4,%zmm0
 1561454:	62 f1 5d 50 db 25 02 f2 01 ff 	vpandd -0xfe0dfe(%rip){1to16},%zmm20,%zmm4        # 580660 <tier0_emit_x87.operations+0x218>
 156145e:	62 f3 c5 40 25 c3 78 	vpternlogq $0x78,%zmm3,%zmm23,%zmm0
 1561465:	62 91 fe 48 7f 14 1e 	vmovdqu64 %zmm2,(%r14,%r11,1)
 156146c:	c5 e9 ef d2          	vpxor  %xmm2,%xmm2,%xmm2
 1561470:	62 f2 7d ca 63 c2    	vpcompressb %zmm0,%zmm2{%k2}{z}
 1561476:	62 d2 7d 48 55 c7    	vpopcntd %zmm15,%zmm0
 156147c:	4d 01 f3             	add    %r14,%r11
 156147f:	c4 61 fb 93 f3       	kmovq  %k3,%r14
 1561484:	f3 4d 0f b8 fe       	popcnt %r14,%r15
 1561489:	62 f1 75 48 fe cc    	vpaddd %zmm4,%zmm1,%zmm1
 156148f:	62 f1 75 48 fe c8    	vpaddd %zmm0,%zmm1,%zmm1
 1561495:	c5 f9 6f 05 53 4f 01 ff 	vmovdqa -0xfeb0ad(%rip),%xmm0        # 5763f0 <x86_effects_unknown+0x990>
 156149d:	62 91 fe 48 7f 14 1f 	vmovdqu64 %zmm2,(%r15,%r11,1)
 15614a4:	89 7c 24 40          	mov    %edi,0x40(%rsp)
 15614a8:	c4 e1 fb 93 fa       	kmovq  %k2,%rdi
 15614ad:	f3 4c 0f b8 f7       	popcnt %rdi,%r14
 15614b2:	4d 01 fe             	add    %r15,%r14
 15614b5:	4d 01 de             	add    %r11,%r14
 15614b8:	62 f2 7d 48 8d c9    	vpermb %zmm1,%zmm0,%zmm1
 15614be:	c5 f9 6f 05 3a 4f 01 ff 	vmovdqa -0xfeb0c6(%rip),%xmm0        # 576400 <x86_effects_unknown+0x9a0>
 15614c6:	62 f2 f5 18 40 0d 70 ef 01 ff 	vpmullq -0xfe1090(%rip){1to2},%xmm1,%xmm1        # 580440 <x86_semantics_benchmark_code.registers+0x450>
 15614d0:	62 d2 7d 48 8d d6    	vpermb %zmm14,%zmm0,%zmm2
 15614d6:	c4 e2 71 00 05 31 4f 01 ff 	vpshufb -0xfeb0cf(%rip),%xmm1,%xmm0        # 576410 <x86_effects_unknown+0x9b0>
 15614df:	62 f2 7e 48 29 da    	vpmovb2m %zmm2,%k3
 15614e5:	c5 fb 93 fb          	kmovd  %k3,%edi
 15614e9:	0f b7 ff             	movzwl %di,%edi
 15614ec:	c5 f9 fc c9          	vpaddb %xmm1,%xmm0,%xmm1
 15614f0:	f3 0f b8 ff          	popcnt %edi,%edi
 15614f4:	49 ff c8             	dec    %r8
 15614f7:	62 f2 7d 48 31 c9    	vpmovzxbd %xmm1,%zmm1
 15614fd:	62 f1 75 58 fe 4c 24 10 	vpaddd 0x40(%rsp){1to16},%zmm1,%zmm1
 1561505:	62 f2 7d cb 8b c9    	vpcompressd %zmm1,%zmm1{%k3}{z}
 156150b:	62 f1 fe 48 7f 09    	vmovdqu64 %zmm1,(%rcx)
 1561511:	48 8d 0c b9          	lea    (%rcx,%rdi,4),%rcx
 1561515:	4c 89 f7             	mov    %r14,%rdi
 1561518:	0f 85 12 fa ff ff    	jne    1560f30 <x86_encode_16+0x6f0>
 156151e:	48 29 c2             	sub    %rax,%rdx
 1561521:	0f 86 b1 17 00 00    	jbe    1562cd8 <x86_encode_16+0x2498>
 1561527:	48 c1 e0 04          	shl    $0x4,%rax
 156152b:	48 c1 e2 04          	shl    $0x4,%rdx
 156152f:	48 8d 7c 24 40       	lea    0x40(%rsp),%rdi
 1561534:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 1561538:	62 f1 fd 48 7f 44 24 04 	vmovdqa64 %zmm0,0x100(%rsp)
 1561540:	62 f1 fd 48 7f 44 24 03 	vmovdqa64 %zmm0,0xc0(%rsp)
 1561548:	62 f1 fd 48 7f 44 24 02 	vmovdqa64 %zmm0,0x80(%rsp)
 1561550:	62 f1 fd 48 7f 44 24 01 	vmovdqa64 %zmm0,0x40(%rsp)
 1561558:	49 89 cf             	mov    %rcx,%r15
 156155b:	48 01 c6             	add    %rax,%rsi
 156155e:	c5 f8 77             	vzeroupper
 1561561:	e8 ea 2e 20 ff       	call   764450 <memcpy@plt>
 1561566:	c5 f9 6f 4c 24 40    	vmovdqa 0x40(%rsp),%xmm1
 156156c:	c5 f9 6f 54 24 50    	vmovdqa 0x50(%rsp),%xmm2
 1561572:	c5 f9 6f 5c 24 60    	vmovdqa 0x60(%rsp),%xmm3
 1561578:	c5 f9 6f 64 24 70    	vmovdqa 0x70(%rsp),%xmm4
 156157e:	48 8d 05 fb 52 10 0d 	lea    0xd1052fb(%rip),%rax        # e666880 <x86_template_storage>
 1561585:	c5 f9 6f b4 24 80 00 00 00 	vmovdqa 0x80(%rsp),%xmm6
 156158e:	62 71 fd 48 6f 3d e8 0f fc fe 	vmovdqa64 -0x103f018(%rip),%zmm15        # 522580 <branch_sizing_patterns+0x27f0>
 1561598:	c5 f9 6f bc 24 c0 00 00 00 	vmovdqa 0xc0(%rsp),%xmm7
 15615a1:	c5 79 6f 84 24 e0 00 00 00 	vmovdqa 0xe0(%rsp),%xmm8
 15615aa:	62 f1 fd 48 6f 6c 24 01 	vmovdqa64 0x40(%rsp),%zmm5
 15615b2:	62 71 fd 48 6f 54 24 02 	vmovdqa64 0x80(%rsp),%zmm10
 15615ba:	62 71 fd 48 6f 5c 24 03 	vmovdqa64 0xc0(%rsp),%zmm11
 15615c2:	62 71 fd 48 6f 64 24 04 	vmovdqa64 0x100(%rsp),%zmm12
 15615ca:	62 e2 7d 48 5a 0d 5c 4e 01 ff 	vbroadcasti32x4 -0xfeb1a4(%rip),%zmm17        # 576430 <x86_effects_unknown+0x9d0>
 15615d4:	62 a3 4d 40 25 f6 ff 	vpternlogd $0xff,%zmm22,%zmm22,%zmm22
 15615db:	62 e2 7d 48 58 25 1f f0 01 ff 	vpbroadcastd -0xfe0fe1(%rip),%zmm20        # 580604 <tier0_emit_x87.operations+0x1bc>
 15615e5:	62 62 7d 48 58 1d 21 f0 01 ff 	vpbroadcastd -0xfe0fdf(%rip),%zmm27        # 580610 <tier0_emit_x87.operations+0x1c8>
 15615ef:	62 62 7d 48 58 0d 1b f0 01 ff 	vpbroadcastd -0xfe0fe5(%rip),%zmm25        # 580614 <tier0_emit_x87.operations+0x1cc>
 15615f9:	c5 f9 c5 c9 06       	vpextrw $0x6,%xmm1,%ecx
 15615fe:	c5 f9 c5 d2 06       	vpextrw $0x6,%xmm2,%edx
 1561603:	c5 f9 c5 fc 06       	vpextrw $0x6,%xmm4,%edi
 1561608:	c5 f9 c5 f3 06       	vpextrw $0x6,%xmm3,%esi
 156160d:	c5 f9 6f a4 24 90 00 00 00 	vmovdqa 0x90(%rsp),%xmm4
 1561616:	62 51 55 48 62 ea    	vpunpckldq %zmm10,%zmm5,%zmm13
 156161c:	62 51 25 48 62 f4    	vpunpckldq %zmm12,%zmm11,%zmm14
 1561622:	62 d1 55 48 6a ea    	vpunpckhdq %zmm10,%zmm5,%zmm5
 1561628:	62 51 25 48 6a d4    	vpunpckhdq %zmm12,%zmm11,%zmm10
 156162e:	c1 e1 06             	shl    $0x6,%ecx
 1561631:	c1 e2 06             	shl    $0x6,%edx
 1561634:	c1 e6 06             	shl    $0x6,%esi
 1561637:	c1 e7 06             	shl    $0x6,%edi
 156163a:	62 51 95 48 6d de    	vpunpckhqdq %zmm14,%zmm13,%zmm11
 1561640:	62 d1 95 48 6c c6    	vpunpcklqdq %zmm14,%zmm13,%zmm0
 1561646:	62 51 d5 48 6c ea    	vpunpcklqdq %zmm10,%zmm5,%zmm13
 156164c:	62 d1 d5 48 6d ea    	vpunpckhqdq %zmm10,%zmm5,%zmm5
 1561652:	c5 fd 6f 4c 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm1
 1561658:	c5 fd 6f 54 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm2
 156165e:	b1 cc                	mov    $0xcc,%cl
 1561660:	62 d1 0d 48 72 d5 1a 	vpsrld $0x1a,%zmm13,%zmm14
 1561667:	62 e2 0d 48 36 1d 8f 0f fc fe 	vpermd -0x103f071(%rip),%zmm14,%zmm19        # 522600 <branch_sizing_patterns+0x2870>
 1561671:	62 d2 25 48 27 c3    	vptestmd %zmm11,%zmm11,%k0
 1561677:	62 d1 6d 40 72 e3 1f 	vpsrad $0x1f,%zmm11,%zmm18
 156167e:	62 21 25 48 fe c6    	vpaddd %zmm22,%zmm11,%zmm24
 1561684:	62 43 5d 40 25 cd 6c 	vpternlogd $0x6c,%zmm13,%zmm20,%zmm25
 156168b:	62 f3 f5 48 3a 4c 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm1,%zmm1
 1561694:	62 f3 ed 48 3a 5c 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm2,%zmm3
 156169d:	c5 fb 92 c9          	kmovd  %ecx,%k1
 15616a1:	c5 f9 c5 ce 06       	vpextrw $0x6,%xmm6,%ecx
 15616a6:	c5 f9 6f b4 24 a0 00 00 00 	vmovdqa 0xa0(%rsp),%xmm6
 15616af:	c1 e1 06             	shl    $0x6,%ecx
 15616b2:	c5 f9 c5 d4 06       	vpextrw $0x6,%xmm4,%edx
 15616b7:	c5 f9 6f a4 24 b0 00 00 00 	vmovdqa 0xb0(%rsp),%xmm4
 15616c0:	c1 e2 06             	shl    $0x6,%edx
 15616c3:	62 f2 f5 49 64 d3    	vpblendmq %zmm3,%zmm1,%zmm2{%k1}
 15616c9:	62 f2 85 48 7e cb    	vpermt2q %zmm3,%zmm15,%zmm1
 15616cf:	c5 fd 6f 5c 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm3
 15616d5:	c5 f9 c5 cf 06       	vpextrw $0x6,%xmm7,%ecx
 15616da:	c5 f9 6f bc 24 d0 00 00 00 	vmovdqa 0xd0(%rsp),%xmm7
 15616e3:	c5 f9 c5 f6 06       	vpextrw $0x6,%xmm6,%esi
 15616e8:	c1 e6 06             	shl    $0x6,%esi
 15616eb:	c1 e1 06             	shl    $0x6,%ecx
 15616ee:	62 f3 e5 48 3a 5c 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm3,%zmm3
 15616f7:	c4 c1 79 c5 f0 06    	vpextrw $0x6,%xmm8,%esi
 15616fd:	c1 e6 06             	shl    $0x6,%esi
 1561700:	c5 f9 c5 fc 06       	vpextrw $0x6,%xmm4,%edi
 1561705:	c5 fd 6f 64 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm4
 156170b:	c1 e7 06             	shl    $0x6,%edi
 156170e:	62 f3 dd 48 3a 74 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm4,%zmm6
 1561717:	c5 f9 c5 d7 06       	vpextrw $0x6,%xmm7,%edx
 156171c:	c5 f9 6f bc 24 f0 00 00 00 	vmovdqa 0xf0(%rsp),%xmm7
 1561725:	c1 e2 06             	shl    $0x6,%edx
 1561728:	62 f2 e5 49 64 e6    	vpblendmq %zmm6,%zmm3,%zmm4{%k1}
 156172e:	62 f2 85 48 7e de    	vpermt2q %zmm6,%zmm15,%zmm3
 1561734:	c5 fd 6f 74 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm6
 156173a:	0f b7 8c 24 0c 01 00 00 	movzwl 0x10c(%rsp),%ecx
 1561742:	c5 f9 c5 ff 06       	vpextrw $0x6,%xmm7,%edi
 1561747:	c5 fd 6f 7c 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm7
 156174d:	62 f3 cd 48 3a 74 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm6,%zmm6
 1561756:	0f b7 94 24 1c 01 00 00 	movzwl 0x11c(%rsp),%edx
 156175e:	0f b7 b4 24 2c 01 00 00 	movzwl 0x12c(%rsp),%esi
 1561766:	62 71 6d 48 6a d4    	vpunpckhdq %zmm4,%zmm2,%zmm10
 156176c:	c1 e7 06             	shl    $0x6,%edi
 156176f:	62 73 c5 48 3a 44 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm7,%zmm8
 1561778:	0f b7 bc 24 3c 01 00 00 	movzwl 0x13c(%rsp),%edi
 1561780:	c1 e1 06             	shl    $0x6,%ecx
 1561783:	c1 e2 06             	shl    $0x6,%edx
 1561786:	c1 e6 06             	shl    $0x6,%esi
 1561789:	c5 7d 6f 4c 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm9
 156178f:	c1 e7 06             	shl    $0x6,%edi
 1561792:	62 e3 b5 48 3a 44 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm9,%zmm16
 156179b:	62 d2 cd 49 64 f8    	vpblendmq %zmm8,%zmm6,%zmm7{%k1}
 15617a1:	62 d2 85 48 7e f0    	vpermt2q %zmm8,%zmm15,%zmm6
 15617a7:	c5 7d 6f 44 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm8
 15617ad:	62 73 bd 48 3a 44 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm8,%zmm8
 15617b6:	62 32 bd 49 64 c8    	vpblendmq %zmm16,%zmm8,%zmm9{%k1}
 15617bc:	62 32 85 48 7e c0    	vpermt2q %zmm16,%zmm15,%zmm8
 15617c2:	62 e2 7d 48 5a 05 54 4c 01 ff 	vbroadcasti32x4 -0xfeb3ac(%rip),%zmm16        # 576420 <x86_effects_unknown+0x9c0>
 15617cc:	62 72 0d 48 36 3d ea 0d fc fe 	vpermd -0x103f216(%rip),%zmm14,%zmm15        # 5225c0 <branch_sizing_patterns+0x2830>
 15617d6:	62 72 0d 48 36 35 60 0e fc fe 	vpermd -0x103f1a0(%rip),%zmm14,%zmm14        # 522640 <branch_sizing_patterns+0x28b0>
 15617e0:	62 51 45 48 6a e1    	vpunpckhdq %zmm9,%zmm7,%zmm12
 15617e6:	62 51 ad 48 6d d4    	vpunpckhqdq %zmm12,%zmm10,%zmm10
 15617ec:	62 d1 45 40 72 d2 1d 	vpsrld $0x1d,%zmm10,%zmm23
 15617f3:	62 52 fd 40 83 e5    	vpmultishiftqb %zmm13,%zmm16,%zmm12
 15617f9:	62 e2 7d 48 5a 05 3d 4c 01 ff 	vbroadcasti32x4 -0xfeb3c3(%rip),%zmm16        # 576440 <x86_effects_unknown+0x9e0>
 1561803:	62 c2 fd 40 83 c5    	vpmultishiftqb %zmm13,%zmm16,%zmm16
 1561809:	62 e3 1d 58 25 05 e8 ed 01 ff d8 	vpternlogd $0xd8,-0xfe1218(%rip){1to16},%zmm12,%zmm16        # 5805fc <tier0_emit_x87.operations+0x1b4>
 1561814:	62 52 f5 40 83 e5    	vpmultishiftqb %zmm13,%zmm17,%zmm12
 156181a:	62 e2 7d 48 5a 0d 2c 4c 01 ff 	vbroadcasti32x4 -0xfeb3d4(%rip),%zmm17        # 576450 <x86_effects_unknown+0x9f0>
 1561824:	62 73 7d 50 25 25 d1 ed 01 ff e4 	vpternlogd $0xe4,-0xfe122f(%rip){1to16},%zmm16,%zmm12        # 580600 <tier0_emit_x87.operations+0x1b8>
 156182f:	62 c2 75 40 00 ed    	vpshufb %zmm13,%zmm17,%zmm21
 1561835:	62 d1 7d 40 72 f5 04 	vpslld $0x4,%zmm13,%zmm16
 156183c:	62 b1 7d 40 72 e0 1f 	vpsrad $0x1f,%zmm16,%zmm16
 1561843:	62 c3 1d 48 25 df f8 	vpternlogd $0xf8,%zmm15,%zmm12,%zmm19
 156184a:	62 b1 05 48 72 f5 10 	vpslld $0x10,%zmm21,%zmm15
 1561851:	62 d1 75 40 72 e7 1f 	vpsrad $0x1f,%zmm15,%zmm17
 1561858:	62 72 7e 48 38 f8    	vpmovm2d %k0,%zmm15
 156185e:	62 23 7d 40 25 db ea 	vpternlogd $0xea,%zmm19,%zmm16,%zmm27
 1561865:	62 b1 2d 40 72 d3 10 	vpsrld $0x10,%zmm19,%zmm26
 156186c:	62 33 7d 40 25 f9 c8 	vpternlogd $0xc8,%zmm17,%zmm16,%zmm15
 1561873:	62 c1 6d 40 ef cb    	vpxord %zmm11,%zmm18,%zmm17
 1561879:	62 e2 7d 48 58 15 85 ed 01 ff 	vpbroadcastd -0xfe127b(%rip),%zmm18        # 580608 <tier0_emit_x87.operations+0x1c0>
 1561883:	62 a2 7d 48 44 c9    	vplzcntd %zmm17,%zmm17
 1561889:	62 a2 6d 40 45 c9    	vpsrlvd %zmm17,%zmm18,%zmm17
 156188f:	62 23 25 48 25 c1 14 	vpternlogd $0x14,%zmm17,%zmm11,%zmm24
 1561896:	62 a2 3d 40 14 cf    	vprorvd %zmm23,%zmm24,%zmm17
 156189c:	62 62 7d 48 58 05 66 ed 01 ff 	vpbroadcastd -0xfe129a(%rip),%zmm24        # 58060c <tier0_emit_x87.operations+0x1c4>
 15618a6:	62 b1 75 40 72 e1 1f 	vpsrad $0x1f,%zmm17,%zmm17
 15618ad:	62 23 05 48 25 c3 ea 	vpternlogd $0xea,%zmm19,%zmm15,%zmm24
 15618b4:	62 b1 65 40 72 d3 03 	vpsrld $0x3,%zmm19,%zmm19
 15618bb:	62 e3 2d 50 25 1d 6a ed 01 ff ec 	vpternlogd $0xec,-0xfe1296(%rip){1to16},%zmm26,%zmm19        # 580630 <tier0_emit_x87.operations+0x1e8>
 15618c6:	62 03 75 40 25 d8 b8 	vpternlogd $0xb8,%zmm24,%zmm17,%zmm27
 15618cd:	62 21 35 40 fe c6    	vpaddd %zmm22,%zmm25,%zmm24
 15618d3:	62 d1 35 40 72 d5 08 	vpsrld $0x8,%zmm13,%zmm25
 15618da:	62 63 5d 50 25 0d 33 ed 01 ff 6c 	vpternlogd $0x6c,-0xfe12cd(%rip){1to16},%zmm20,%zmm25        # 580618 <tier0_emit_x87.operations+0x1d0>
 15618e5:	62 51 55 48 eb ed    	vpord  %zmm13,%zmm5,%zmm13
 15618eb:	62 d1 2d 40 72 f5 07 	vpslld $0x7,%zmm13,%zmm26
 15618f2:	62 31 7d 40 db ed    	vpandd %zmm21,%zmm16,%zmm13
 15618f8:	62 73 0d 58 25 2d 39 ed 01 ff ec 	vpternlogd $0xec,-0xfe12c7(%rip){1to16},%zmm14,%zmm13        # 58063c <tier0_emit_x87.operations+0x1f4>
 1561903:	62 71 05 58 db 35 37 ed 01 ff 	vpandd -0xfe12c9(%rip){1to16},%zmm15,%zmm14        # 580644 <tier0_emit_x87.operations+0x1fc>
 156190d:	62 e1 7d 50 db 05 31 ed 01 ff 	vpandd -0xfe12cf(%rip){1to16},%zmm16,%zmm16        # 580648 <tier0_emit_x87.operations+0x200>
 1561917:	62 73 2d 58 25 2d 1e ed 01 ff f8 	vpternlogd $0xf8,-0xfe12e2(%rip){1to16},%zmm10,%zmm13        # 580640 <tier0_emit_x87.operations+0x1f8>
 1561922:	62 a1 35 40 fe e6    	vpaddd %zmm22,%zmm25,%zmm20
 1561928:	62 62 7d 48 58 0d ea ec 01 ff 	vpbroadcastd -0xfe1316(%rip),%zmm25        # 58061c <tier0_emit_x87.operations+0x1d4>
 1561932:	62 63 3d 50 25 0d e3 ec 01 ff ea 	vpternlogd $0xea,-0xfe131d(%rip){1to16},%zmm24,%zmm25        # 580620 <tier0_emit_x87.operations+0x1d8>
 156193d:	62 b1 3d 40 72 f3 08 	vpslld $0x8,%zmm19,%zmm24
 1561944:	62 c3 75 40 25 c6 b8 	vpternlogd $0xb8,%zmm14,%zmm17,%zmm16
 156194b:	62 d1 0d 48 72 cb 01 	vprold $0x1,%zmm11,%zmm14
 1561952:	62 63 5d 50 25 0d c7 ec 01 ff f8 	vpternlogd $0xf8,-0xfe1339(%rip){1to16},%zmm20,%zmm25        # 580624 <tier0_emit_x87.operations+0x1dc>
 156195d:	62 e1 1d 58 db 25 c1 ec 01 ff 	vpandd -0xfe133f(%rip){1to16},%zmm12,%zmm20        # 580628 <tier0_emit_x87.operations+0x1e0>
 1561967:	62 32 0d 48 14 f7    	vprorvd %zmm23,%zmm14,%zmm14
 156196d:	62 53 05 48 25 f3 e2 	vpternlogd $0xe2,%zmm11,%zmm15,%zmm14
 1561974:	62 53 75 40 25 f3 e2 	vpternlogd $0xe2,%zmm11,%zmm17,%zmm14
 156197b:	62 e2 7d 48 5a 0d 5b 4a 01 ff 	vbroadcasti32x4 -0xfeb5a5(%rip),%zmm17        # 5763e0 <x86_effects_unknown+0x980>
 1561985:	62 51 7d 48 62 de    	vpunpckldq %zmm14,%zmm0,%zmm11
 156198b:	62 d1 7d 48 6a c6    	vpunpckhdq %zmm14,%zmm0,%zmm0
 1561991:	62 83 2d 48 25 e1 f8 	vpternlogd $0xf8,%zmm25,%zmm10,%zmm20
 1561998:	62 d1 35 40 72 d4 03 	vpsrld $0x3,%zmm12,%zmm25
 156199f:	62 63 2d 58 25 0d 8a ec 01 ff a2 	vpternlogd $0xa2,-0xfe1376(%rip){1to16},%zmm10,%zmm25        # 580634 <tier0_emit_x87.operations+0x1ec>
 15619aa:	62 e2 5d 50 3b 25 78 ec 01 ff 	vpminud -0xfe1388(%rip){1to16},%zmm20,%zmm20        # 58062c <tier0_emit_x87.operations+0x1e4>
 15619b4:	62 31 35 40 fe e6    	vpaddd %zmm22,%zmm25,%zmm12
 15619ba:	62 e2 35 50 3b 35 74 ec 01 ff 	vpminud -0xfe138c(%rip){1to16},%zmm25,%zmm22        # 580638 <tier0_emit_x87.operations+0x1f0>
 15619c4:	62 62 7d 48 5a 0d 92 4a 01 ff 	vbroadcasti32x4 -0xfeb56e(%rip),%zmm25        # 576460 <x86_effects_unknown+0xa00>
 15619ce:	62 d1 1d 48 72 e4 1f 	vpsrad $0x1f,%zmm12,%zmm12
 15619d5:	62 63 1d 58 25 05 6c ec 01 ff 08 	vpternlogd $0x8,-0xfe1394(%rip){1to16},%zmm12,%zmm24        # 58064c <tier0_emit_x87.operations+0x204>
 15619e0:	62 63 2d 50 25 05 65 ec 01 ff d8 	vpternlogd $0xd8,-0xfe139b(%rip){1to16},%zmm26,%zmm24        # 580650 <tier0_emit_x87.operations+0x208>
 15619eb:	62 62 b5 40 83 cd    	vpmultishiftqb %zmm5,%zmm25,%zmm25
 15619f1:	62 63 65 50 25 0d 58 ec 01 ff d8 	vpternlogd $0xd8,-0xfe13a8(%rip){1to16},%zmm19,%zmm25        # 580654 <tier0_emit_x87.operations+0x20c>
 15619fc:	62 33 4d 40 25 ec fe 	vpternlogd $0xfe,%zmm20,%zmm22,%zmm13
 1561a03:	62 51 7d 40 eb ed    	vpord  %zmm13,%zmm16,%zmm13
 1561a09:	62 c1 7d 48 70 d5 00 	vpshufd $0x0,%zmm13,%zmm18
 1561a10:	62 63 3d 50 25 0d 3d ec 01 ff d8 	vpternlogd $0xd8,-0xfe13c3(%rip){1to16},%zmm24,%zmm25        # 580658 <tier0_emit_x87.operations+0x210>
 1561a1b:	62 f2 6d 40 8f c9    	vpshufbitqmb %zmm1,%zmm18,%k1
 1561a21:	c4 e1 fb 93 c1       	kmovq  %k1,%rax
 1561a26:	f3 48 0f b8 c0       	popcnt %rax,%rax
 1561a2b:	49 8d 0c 06          	lea    (%r14,%rax,1),%rcx
 1561a2f:	62 11 25 40 62 f1    	vpunpckldq %zmm25,%zmm27,%zmm14
 1561a35:	62 11 25 40 6a f9    	vpunpckhdq %zmm25,%zmm27,%zmm15
 1561a3b:	62 c1 a5 48 6c c6    	vpunpcklqdq %zmm14,%zmm11,%zmm16
 1561a41:	62 c1 fd 48 6c df    	vpunpcklqdq %zmm15,%zmm0,%zmm19
 1561a47:	62 d1 fd 48 6d c7    	vpunpckhqdq %zmm15,%zmm0,%zmm0
 1561a4d:	62 51 a5 48 6d de    	vpunpckhqdq %zmm14,%zmm11,%zmm11
 1561a53:	62 51 7d 48 70 fd 55 	vpshufd $0x55,%zmm13,%zmm15
 1561a5a:	62 e2 7d 40 00 c1    	vpshufb %zmm1,%zmm16,%zmm16
 1561a60:	62 d2 7d 48 00 c0    	vpshufb %zmm8,%zmm0,%zmm0
 1561a66:	62 a3 ed 48 25 c1 78 	vpternlogq $0x78,%zmm17,%zmm2,%zmm16
 1561a6d:	62 f2 25 48 00 d3    	vpshufb %zmm3,%zmm11,%zmm2
 1561a73:	62 b3 b5 48 25 c1 78 	vpternlogq $0x78,%zmm17,%zmm9,%zmm0
 1561a7a:	62 e2 7d c9 63 c1    	vpcompressb %zmm16,%zmm1{%k1}{z}
 1561a80:	62 f2 05 48 8f cb    	vpshufbitqmb %zmm3,%zmm15,%k1
 1561a86:	62 d1 7d 48 70 dd aa 	vpshufd $0xaa,%zmm13,%zmm3
 1561a8d:	62 b3 dd 48 25 d1 78 	vpternlogq $0x78,%zmm17,%zmm4,%zmm2
 1561a94:	62 d1 7d 48 70 e5 ff 	vpshufd $0xff,%zmm13,%zmm4
 1561a9b:	62 73 2d 58 25 2d b6 eb 01 ff 20 	vpternlogd $0x20,-0xfe144a(%rip){1to16},%zmm10,%zmm13        # 58065c <tier0_emit_x87.operations+0x214>
 1561aa6:	c4 e1 fb 93 d1       	kmovq  %k1,%rdx
 1561aab:	f3 48 0f b8 d2       	popcnt %rdx,%rdx
 1561ab0:	62 d1 fe 48 7f 0e    	vmovdqu64 %zmm1,(%r14)
 1561ab6:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
 1561aba:	62 f2 7d c9 63 d1    	vpcompressb %zmm2,%zmm1{%k1}{z}
 1561ac0:	62 f2 65 40 00 d6    	vpshufb %zmm6,%zmm19,%zmm2
 1561ac6:	62 f2 65 48 8f ce    	vpshufbitqmb %zmm6,%zmm3,%k1
 1561acc:	62 f1 2d 58 db 1d 8a eb 01 ff 	vpandd -0xfe1476(%rip){1to16},%zmm10,%zmm3        # 580660 <tier0_emit_x87.operations+0x218>
 1561ad6:	48 8d 34 11          	lea    (%rcx,%rdx,1),%rsi
 1561ada:	62 b3 c5 48 25 d1 78 	vpternlogq $0x78,%zmm17,%zmm7,%zmm2
 1561ae1:	62 d1 fe 48 7f 0c 06 	vmovdqu64 %zmm1,(%r14,%rax,1)
 1561ae8:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
 1561aec:	62 f2 7d c9 63 d1    	vpcompressb %zmm2,%zmm1{%k1}{z}
 1561af2:	c4 e1 fb 93 c1       	kmovq  %k1,%rax
 1561af7:	62 d2 5d 48 8f c8    	vpshufbitqmb %zmm8,%zmm4,%k1
 1561afd:	41 29 de             	sub    %ebx,%r14d
 1561b00:	f3 48 0f b8 f8       	popcnt %rax,%rdi
 1561b05:	62 f2 7d c9 63 c0    	vpcompressb %zmm0,%zmm0{%k1}{z}
 1561b0b:	c4 e1 fb 93 c1       	kmovq  %k1,%rax
 1561b10:	f3 48 0f b8 c0       	popcnt %rax,%rax
 1561b15:	62 f1 fe 48 7f 0c 0a 	vmovdqu64 %zmm1,(%rdx,%rcx,1)
 1561b1c:	62 f1 1d 48 fe cb    	vpaddd %zmm3,%zmm12,%zmm1
 1561b22:	48 01 f8             	add    %rdi,%rax
 1561b25:	48 01 f0             	add    %rsi,%rax
 1561b28:	62 f1 fe 48 7f 04 37 	vmovdqu64 %zmm0,(%rdi,%rsi,1)
 1561b2f:	62 d2 7d 48 55 c5    	vpopcntd %zmm13,%zmm0
 1561b35:	44 89 74 24 3c       	mov    %r14d,0x3c(%rsp)
 1561b3a:	49 89 c6             	mov    %rax,%r14
 1561b3d:	62 f1 75 48 fe c0    	vpaddd %zmm0,%zmm1,%zmm0
 1561b43:	c5 f9 6f 0d a5 48 01 ff 	vmovdqa -0xfeb75b(%rip),%xmm1        # 5763f0 <x86_effects_unknown+0x990>
 1561b4b:	62 f2 75 48 8d c0    	vpermb %zmm0,%zmm1,%zmm0
 1561b51:	62 f2 fd 18 40 05 e5 e8 01 ff 	vpmullq -0xfe171b(%rip){1to2},%xmm0,%xmm0        # 580440 <x86_semantics_benchmark_code.registers+0x450>
 1561b5b:	c5 f9 6f 0d 9d 48 01 ff 	vmovdqa -0xfeb763(%rip),%xmm1        # 576400 <x86_effects_unknown+0x9a0>
 1561b63:	c4 e2 79 00 15 a4 48 01 ff 	vpshufb -0xfeb75c(%rip),%xmm0,%xmm2        # 576410 <x86_effects_unknown+0x9b0>
 1561b6c:	62 f2 75 48 8d cd    	vpermb %zmm5,%zmm1,%zmm1
 1561b72:	c5 e9 fc c0          	vpaddb %xmm0,%xmm2,%xmm0
 1561b76:	62 f2 7d 48 31 c0    	vpmovzxbd %xmm0,%zmm0
 1561b7c:	62 f1 7d 58 fe 44 24 0f 	vpaddd 0x3c(%rsp){1to16},%zmm0,%zmm0
 1561b84:	62 f2 7e 48 29 c9    	vpmovb2m %zmm1,%k1
 1561b8a:	62 f2 7d c9 8b c0    	vpcompressd %zmm0,%zmm0{%k1}{z}
 1561b90:	62 d1 fe 48 7f 07    	vmovdqu64 %zmm0,(%r15)
 1561b96:	e9 3d 11 00 00       	jmp    1562cd8 <x86_encode_16+0x2498>
 1561b9b:	62 f2 7d 48 5a 1d 3b 48 01 ff 	vbroadcasti32x4 -0xfeb7c5(%rip),%zmm3        # 5763e0 <x86_effects_unknown+0x980>
 1561ba5:	62 72 7d 48 58 0d 71 ea 01 ff 	vpbroadcastd -0xfe158f(%rip),%zmm9        # 580620 <tier0_emit_x87.operations+0x1d8>
 1561baf:	48 8d 4a f0          	lea    -0x10(%rdx),%rcx
 1561bb3:	41 b1 cc             	mov    $0xcc,%r9b
 1561bb6:	48 8d be fc 00 00 00 	lea    0xfc(%rsi),%rdi
 1561bbd:	4c 8d 05 bc 4c 10 0d 	lea    0xd104cbc(%rip),%r8        # e666880 <x86_template_storage>
 1561bc4:	62 53 1d 48 25 e4 ff 	vpternlogd $0xff,%zmm12,%zmm12,%zmm12
 1561bcb:	31 c0                	xor    %eax,%eax
 1561bcd:	49 89 de             	mov    %rbx,%r14
 1561bd0:	48 c1 e9 04          	shr    $0x4,%rcx
 1561bd4:	c4 c1 7b 92 c9       	kmovd  %r9d,%k1
 1561bd9:	48 ff c1             	inc    %rcx
 1561bdc:	0f 1f 40 00          	nopl   0x0(%rax)
 1561be0:	44 0f b7 8f 10 ff ff ff 	movzwl -0xf0(%rdi),%r9d
 1561be8:	44 0f b7 97 20 ff ff ff 	movzwl -0xe0(%rdi),%r10d
 1561bf0:	44 0f b7 9f 30 ff ff ff 	movzwl -0xd0(%rdi),%r11d
 1561bf8:	44 0f b7 bf 40 ff ff ff 	movzwl -0xc0(%rdi),%r15d
 1561c00:	62 e1 fe 48 6f 9f 04 ff ff ff 	vmovdqu64 -0xfc(%rdi),%zmm19
 1561c0a:	62 e1 fe 48 6f af 44 ff ff ff 	vmovdqu64 -0xbc(%rdi),%zmm21
 1561c14:	62 e1 fe 48 6f b7 84 ff ff ff 	vmovdqu64 -0x7c(%rdi),%zmm22
 1561c1e:	62 e1 fe 48 6f bf c4 ff ff ff 	vmovdqu64 -0x3c(%rdi),%zmm23
 1561c28:	62 f2 7d 48 5a 0d ee 47 01 ff 	vbroadcasti32x4 -0xfeb812(%rip),%zmm1        # 576420 <x86_effects_unknown+0x9c0>
 1561c32:	48 83 c0 10          	add    $0x10,%rax
 1561c36:	41 c1 e1 06          	shl    $0x6,%r9d
 1561c3a:	41 c1 e2 06          	shl    $0x6,%r10d
 1561c3e:	41 c1 e3 06          	shl    $0x6,%r11d
 1561c42:	41 c1 e7 06          	shl    $0x6,%r15d
 1561c46:	c4 81 7d 6f 64 01 40 	vmovdqa 0x40(%r9,%r8,1),%ymm4
 1561c4d:	44 0f b7 8f 50 ff ff ff 	movzwl -0xb0(%rdi),%r9d
 1561c55:	c4 81 7d 6f 6c 02 60 	vmovdqa 0x60(%r10,%r8,1),%ymm5
 1561c5c:	44 0f b7 97 60 ff ff ff 	movzwl -0xa0(%rdi),%r10d
 1561c64:	62 93 dd 48 3a 64 03 02 01 	vinserti64x4 $0x1,0x40(%r11,%r8,1),%zmm4,%zmm4
 1561c6d:	62 13 d5 48 3a 7c 07 03 01 	vinserti64x4 $0x1,0x60(%r15,%r8,1),%zmm5,%zmm15
 1561c76:	44 0f b7 9f 70 ff ff ff 	movzwl -0x90(%rdi),%r11d
 1561c7e:	44 0f b7 7f 80       	movzwl -0x80(%rdi),%r15d
 1561c83:	62 b1 65 40 62 f5    	vpunpckldq %zmm21,%zmm19,%zmm6
 1561c89:	62 b1 4d 40 62 ff    	vpunpckldq %zmm23,%zmm22,%zmm7
 1561c8f:	62 a1 4d 40 6a f7    	vpunpckhdq %zmm23,%zmm22,%zmm22
 1561c95:	62 a1 65 40 6a ed    	vpunpckhdq %zmm21,%zmm19,%zmm21
 1561c9b:	62 b1 d5 40 6c d6    	vpunpcklqdq %zmm22,%zmm21,%zmm2
 1561ca1:	62 e1 cd 48 6d ff    	vpunpckhqdq %zmm7,%zmm6,%zmm23
 1561ca7:	62 62 f5 48 83 da    	vpmultishiftqb %zmm2,%zmm1,%zmm27
 1561cad:	62 f2 7d 48 5a 0d 89 47 01 ff 	vbroadcasti32x4 -0xfeb877(%rip),%zmm1        # 576440 <x86_effects_unknown+0x9e0>
 1561cb7:	62 f1 15 40 72 d2 1a 	vpsrld $0x1a,%zmm2,%zmm29
 1561cbe:	62 b2 45 40 27 c7    	vptestmd %zmm23,%zmm23,%k0
 1561cc4:	62 e1 fd 48 6f da    	vmovdqa64 %zmm2,%zmm19
 1561cca:	41 c1 e1 06          	shl    $0x6,%r9d
 1561cce:	41 c1 e2 06          	shl    $0x6,%r10d
 1561cd2:	c4 01 7d 6f 44 01 40 	vmovdqa 0x40(%r9,%r8,1),%ymm8
 1561cd9:	44 0f b7 4f 90       	movzwl -0x70(%rdi),%r9d
 1561cde:	41 c1 e3 06          	shl    $0x6,%r11d
 1561ce2:	c4 01 7d 6f 54 02 60 	vmovdqa 0x60(%r10,%r8,1),%ymm10
 1561ce9:	44 0f b7 57 a0       	movzwl -0x60(%rdi),%r10d
 1561cee:	41 c1 e7 06          	shl    $0x6,%r15d
 1561cf2:	62 13 bd 48 3a 44 03 02 01 	vinserti64x4 $0x1,0x40(%r11,%r8,1),%zmm8,%zmm8
 1561cfb:	62 83 ad 48 3a 4c 07 03 01 	vinserti64x4 $0x1,0x60(%r15,%r8,1),%zmm10,%zmm17
 1561d04:	44 0f b7 5f b0       	movzwl -0x50(%rdi),%r11d
 1561d09:	44 0f b7 7f c0       	movzwl -0x40(%rdi),%r15d
 1561d0e:	62 d2 dd 49 64 ef    	vpblendmq %zmm15,%zmm4,%zmm5{%k1}
 1561d14:	41 c1 e1 06          	shl    $0x6,%r9d
 1561d18:	41 c1 e2 06          	shl    $0x6,%r10d
 1561d1c:	c4 01 7d 6f 5c 01 40 	vmovdqa 0x40(%r9,%r8,1),%ymm11
 1561d23:	44 0f b7 4f d0       	movzwl -0x30(%rdi),%r9d
 1561d28:	41 c1 e3 06          	shl    $0x6,%r11d
 1561d2c:	c4 01 7d 6f 6c 02 60 	vmovdqa 0x60(%r10,%r8,1),%ymm13
 1561d33:	44 0f b7 57 e0       	movzwl -0x20(%rdi),%r10d
 1561d38:	41 c1 e7 06          	shl    $0x6,%r15d
 1561d3c:	62 62 f5 48 83 f2    	vpmultishiftqb %zmm2,%zmm1,%zmm30
 1561d42:	62 f2 7d 48 5a 0d e4 46 01 ff 	vbroadcasti32x4 -0xfeb91c(%rip),%zmm1        # 576430 <x86_effects_unknown+0x9d0>
 1561d4c:	62 63 25 50 25 35 a5 e8 01 ff d8 	vpternlogd $0xd8,-0xfe175b(%rip){1to16},%zmm27,%zmm30        # 5805fc <tier0_emit_x87.operations+0x1b4>
 1561d57:	62 13 a5 48 3a 5c 03 02 01 	vinserti64x4 $0x1,0x40(%r11,%r8,1),%zmm11,%zmm11
 1561d60:	62 83 95 48 3a 54 07 03 01 	vinserti64x4 $0x1,0x60(%r15,%r8,1),%zmm13,%zmm18
 1561d69:	44 0f b7 5f f0       	movzwl -0x10(%rdi),%r11d
 1561d6e:	44 0f b7 3f          	movzwl (%rdi),%r15d
 1561d72:	48 81 c7 00 01 00 00 	add    $0x100,%rdi
 1561d79:	62 32 bd 49 64 d1    	vpblendmq %zmm17,%zmm8,%zmm10{%k1}
 1561d7f:	62 41 55 48 6a c2    	vpunpckhdq %zmm10,%zmm5,%zmm24
 1561d85:	41 c1 e1 06          	shl    $0x6,%r9d
 1561d89:	41 c1 e2 06          	shl    $0x6,%r10d
 1561d8d:	41 c1 e3 06          	shl    $0x6,%r11d
 1561d91:	c4 01 7d 6f 74 01 40 	vmovdqa 0x40(%r9,%r8,1),%ymm14
 1561d98:	41 c1 e7 06          	shl    $0x6,%r15d
 1561d9c:	62 81 fd 28 6f 44 02 03 	vmovdqa64 0x60(%r10,%r8,1),%ymm16
 1561da4:	62 13 8d 48 3a 74 03 02 01 	vinserti64x4 $0x1,0x40(%r11,%r8,1),%zmm14,%zmm14
 1561dad:	62 83 fd 40 3a 64 07 03 01 	vinserti64x4 $0x1,0x60(%r15,%r8,1),%zmm16,%zmm20
 1561db6:	62 62 f5 48 83 e2    	vpmultishiftqb %zmm2,%zmm1,%zmm28
 1561dbc:	62 f1 75 48 72 f2 04 	vpslld $0x4,%zmm2,%zmm1
 1561dc3:	62 63 0d 50 25 25 32 e8 01 ff e4 	vpternlogd $0xe4,-0xfe17ce(%rip){1to16},%zmm30,%zmm28        # 580600 <tier0_emit_x87.operations+0x1b8>
 1561dce:	62 f1 25 40 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm27
 1561dd5:	62 f2 7d 48 5a 0d 71 46 01 ff 	vbroadcasti32x4 -0xfeb98f(%rip),%zmm1        # 576450 <x86_effects_unknown+0x9f0>
 1561ddf:	62 32 a5 49 64 ea    	vpblendmq %zmm18,%zmm11,%zmm13{%k1}
 1561de5:	62 a2 8d 49 64 c4    	vpblendmq %zmm20,%zmm14,%zmm16{%k1}
 1561deb:	62 21 15 48 6a c8    	vpunpckhdq %zmm16,%zmm13,%zmm25
 1561df1:	62 01 bd 40 6d d1    	vpunpckhqdq %zmm25,%zmm24,%zmm26
 1561df7:	62 62 15 40 36 0d bf 07 fc fe 	vpermd -0x103f841(%rip),%zmm29,%zmm25        # 5225c0 <branch_sizing_patterns+0x2830>
 1561e01:	62 62 15 40 36 05 f5 07 fc fe 	vpermd -0x103f80b(%rip),%zmm29,%zmm24        # 522600 <branch_sizing_patterns+0x2870>
 1561e0b:	62 62 75 48 00 f2    	vpshufb %zmm2,%zmm1,%zmm30
 1561e11:	62 f2 7d 48 58 0d ed e7 01 ff 	vpbroadcastd -0xfe1813(%rip),%zmm1        # 580608 <tier0_emit_x87.operations+0x1c0>
 1561e1b:	62 62 15 40 36 2d 1b 08 fc fe 	vpermd -0x103f7e5(%rip),%zmm29,%zmm29        # 522640 <branch_sizing_patterns+0x28b0>
 1561e25:	62 91 7d 48 72 f6 10 	vpslld $0x10,%zmm30,%zmm0
 1561e2c:	62 01 25 40 db f6    	vpandd %zmm30,%zmm27,%zmm30
 1561e32:	62 f1 05 40 72 e0 1f 	vpsrad $0x1f,%zmm0,%zmm31
 1561e39:	62 b1 7d 48 72 e7 1f 	vpsrad $0x1f,%zmm23,%zmm0
 1561e40:	62 03 1d 40 25 c1 f8 	vpternlogd $0xf8,%zmm25,%zmm28,%zmm24
 1561e47:	62 62 7e 48 38 c8    	vpmovm2d %k0,%zmm25
 1561e4d:	62 03 25 40 25 cf c8 	vpternlogd $0xc8,%zmm31,%zmm27,%zmm25
 1561e54:	62 21 7d 48 ef ff    	vpxord %zmm23,%zmm0,%zmm31
 1561e5a:	62 f2 7d 48 58 05 a0 e7 01 ff 	vpbroadcastd -0xfe1860(%rip),%zmm0        # 580604 <tier0_emit_x87.operations+0x1bc>
 1561e64:	62 63 15 50 25 35 cd e7 01 ff ec 	vpternlogd $0xec,-0xfe1833(%rip){1to16},%zmm29,%zmm30        # 58063c <tier0_emit_x87.operations+0x1f4>
 1561e6f:	62 91 15 40 72 d2 1d 	vpsrld $0x1d,%zmm26,%zmm29
 1561e76:	62 02 7d 48 44 ff    	vplzcntd %zmm31,%zmm31
 1561e7c:	62 63 2d 50 25 35 b9 e7 01 ff f8 	vpternlogd $0xf8,-0xfe1847(%rip){1to16},%zmm26,%zmm30        # 580640 <tier0_emit_x87.operations+0x1f8>
 1561e87:	62 02 75 48 45 ff    	vpsrlvd %zmm31,%zmm1,%zmm31
 1561e8d:	62 d1 45 40 fe cc    	vpaddd %zmm12,%zmm23,%zmm1
 1561e93:	62 93 45 40 25 cf 14 	vpternlogd $0x14,%zmm31,%zmm23,%zmm1
 1561e9a:	62 f1 05 40 72 d2 08 	vpsrld $0x8,%zmm2,%zmm31
 1561ea1:	62 92 75 48 14 cd    	vprorvd %zmm29,%zmm1,%zmm1
 1561ea7:	62 f1 75 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm1
 1561eae:	62 e3 7d 58 25 1d 5b e7 01 ff 6c 	vpternlogd $0x6c,-0xfe18a5(%rip){1to16},%zmm0,%zmm19        # 580614 <tier0_emit_x87.operations+0x1cc>
 1561eb9:	62 63 7d 58 25 3d 54 e7 01 ff 6c 	vpternlogd $0x6c,-0xfe18ac(%rip){1to16},%zmm0,%zmm31        # 580618 <tier0_emit_x87.operations+0x1d0>
 1561ec4:	62 f1 1d 50 db 05 5a e7 01 ff 	vpandd -0xfe18a6(%rip){1to16},%zmm28,%zmm0        # 580628 <tier0_emit_x87.operations+0x1e0>
 1561ece:	62 91 1d 40 72 d4 03 	vpsrld $0x3,%zmm28,%zmm28
 1561ed5:	62 63 2d 50 25 25 54 e7 01 ff a2 	vpternlogd $0xa2,-0xfe18ac(%rip){1to16},%zmm26,%zmm28        # 580634 <tier0_emit_x87.operations+0x1ec>
 1561ee0:	62 c1 65 40 fe dc    	vpaddd %zmm12,%zmm19,%zmm19
 1561ee6:	62 e3 35 58 25 1d 2b e7 01 ff ec 	vpternlogd $0xec,-0xfe18d5(%rip){1to16},%zmm9,%zmm19        # 58061c <tier0_emit_x87.operations+0x1d4>
 1561ef1:	62 41 05 40 fe fc    	vpaddd %zmm12,%zmm31,%zmm31
 1561ef7:	62 63 65 50 25 3d 22 e7 01 ff ec 	vpternlogd $0xec,-0xfe18de(%rip){1to16},%zmm19,%zmm31        # 580624 <tier0_emit_x87.operations+0x1dc>
 1561f02:	62 93 2d 40 25 c7 f8 	vpternlogd $0xf8,%zmm31,%zmm26,%zmm0
 1561f09:	62 e2 7d 58 3b 1d 19 e7 01 ff 	vpminud -0xfe18e7(%rip){1to16},%zmm0,%zmm19        # 58062c <tier0_emit_x87.operations+0x1e4>
 1561f13:	62 f2 1d 50 3b 05 1b e7 01 ff 	vpminud -0xfe18e5(%rip){1to16},%zmm28,%zmm0        # 580638 <tier0_emit_x87.operations+0x1f0>
 1561f1d:	62 01 fd 48 6f d0    	vmovdqa64 %zmm24,%zmm26
 1561f23:	62 63 35 50 25 15 de e6 01 ff f8 	vpternlogd $0xf8,-0xfe1922(%rip){1to16},%zmm25,%zmm26        # 58060c <tier0_emit_x87.operations+0x1c4>
 1561f2e:	62 61 35 50 db 3d 0c e7 01 ff 	vpandd -0xfe18f4(%rip){1to16},%zmm25,%zmm31        # 580644 <tier0_emit_x87.operations+0x1fc>
 1561f38:	62 23 7d 48 25 f3 fe 	vpternlogd $0xfe,%zmm19,%zmm0,%zmm30
 1561f3f:	62 81 fd 48 6f d8    	vmovdqa64 %zmm24,%zmm19
 1561f45:	62 e3 25 50 25 1d c0 e6 01 ff f8 	vpternlogd $0xf8,-0xfe1940(%rip){1to16},%zmm27,%zmm19        # 580610 <tier0_emit_x87.operations+0x1c8>
 1561f50:	62 b1 7d 48 72 cf 01 	vprold $0x1,%zmm23,%zmm0
 1561f57:	62 61 25 50 db 1d e7 e6 01 ff 	vpandd -0xfe1919(%rip){1to16},%zmm27,%zmm27        # 580648 <tier0_emit_x87.operations+0x200>
 1561f61:	62 83 75 48 25 da b8 	vpternlogd $0xb8,%zmm26,%zmm1,%zmm19
 1561f68:	62 02 7d 48 14 d5    	vprorvd %zmm29,%zmm0,%zmm26
 1561f6e:	62 f1 fd 48 6f 05 08 06 fc fe 	vmovdqa64 -0x103f9f8(%rip),%zmm0        # 522580 <branch_sizing_patterns+0x27f0>
 1561f78:	62 03 75 48 25 df b8 	vpternlogd $0xb8,%zmm31,%zmm1,%zmm27
 1561f7f:	62 23 35 40 25 d7 e2 	vpternlogd $0xe2,%zmm23,%zmm25,%zmm26
 1561f86:	62 23 75 48 25 d7 e2 	vpternlogd $0xe2,%zmm23,%zmm1,%zmm26
 1561f8d:	62 f1 cd 48 6c cf    	vpunpcklqdq %zmm7,%zmm6,%zmm1
 1561f93:	62 d1 1d 40 fe fc    	vpaddd %zmm12,%zmm28,%zmm7
 1561f99:	62 b1 d5 40 6d f6    	vpunpckhqdq %zmm22,%zmm21,%zmm6
 1561f9f:	62 f1 45 48 72 e7 1f 	vpsrad $0x1f,%zmm7,%zmm7
 1561fa6:	62 f1 4d 48 eb d2    	vpord  %zmm2,%zmm6,%zmm2
 1561fac:	62 f1 6d 48 72 f2 07 	vpslld $0x7,%zmm2,%zmm2
 1561fb3:	62 d2 fd 48 7e e7    	vpermt2q %zmm15,%zmm0,%zmm4
 1561fb9:	62 32 fd 48 7e c1    	vpermt2q %zmm17,%zmm0,%zmm8
 1561fbf:	62 32 fd 48 7e da    	vpermt2q %zmm18,%zmm0,%zmm11
 1561fc5:	62 32 fd 48 7e f4    	vpermt2q %zmm20,%zmm0,%zmm14
 1561fcb:	62 91 7d 48 72 d0 10 	vpsrld $0x10,%zmm24,%zmm0
 1561fd2:	62 91 05 48 72 d0 03 	vpsrld $0x3,%zmm24,%zmm15
 1561fd9:	62 73 7d 58 25 3d 4c e6 01 ff ec 	vpternlogd $0xec,-0xfe19b4(%rip){1to16},%zmm0,%zmm15        # 580630 <tier0_emit_x87.operations+0x1e8>
 1561fe4:	62 f2 7d 48 5a 05 72 44 01 ff 	vbroadcasti32x4 -0xfebb8e(%rip),%zmm0        # 576460 <x86_effects_unknown+0xa00>
 1561fee:	62 d1 75 40 72 f7 08 	vpslld $0x8,%zmm15,%zmm17
 1561ff5:	62 e3 45 58 25 0d 4c e6 01 ff 08 	vpternlogd $0x8,-0xfe19b4(%rip){1to16},%zmm7,%zmm17        # 58064c <tier0_emit_x87.operations+0x204>
 1562000:	62 f2 fd 48 83 f6    	vpmultishiftqb %zmm6,%zmm0,%zmm6
 1562006:	62 f3 05 58 25 35 43 e6 01 ff d8 	vpternlogd $0xd8,-0xfe19bd(%rip){1to16},%zmm15,%zmm6        # 580654 <tier0_emit_x87.operations+0x20c>
 1562011:	62 91 25 40 eb fe    	vpord  %zmm30,%zmm27,%zmm7
 1562017:	62 f1 7d 48 70 c7 00 	vpshufd $0x0,%zmm7,%zmm0
 156201e:	62 f2 7d 48 8f dc    	vpshufbitqmb %zmm4,%zmm0,%k3
 1562024:	62 f1 7d 48 70 c7 55 	vpshufd $0x55,%zmm7,%zmm0
 156202b:	62 d2 7d 48 8f d0    	vpshufbitqmb %zmm8,%zmm0,%k2
 1562031:	62 f1 7d 48 70 c7 aa 	vpshufd $0xaa,%zmm7,%zmm0
 1562038:	c4 61 fb 93 cb       	kmovq  %k3,%r9
 156203d:	f3 4d 0f b8 c9       	popcnt %r9,%r9
 1562042:	c4 61 fb 93 d2       	kmovq  %k2,%r10
 1562047:	f3 4d 0f b8 d2       	popcnt %r10,%r10
 156204c:	62 f3 75 50 25 15 f9 e5 01 ff e4 	vpternlogd $0xe4,-0xfe1a07(%rip){1to16},%zmm17,%zmm2        # 580650 <tier0_emit_x87.operations+0x208>
 1562057:	62 f3 6d 58 25 35 f6 e5 01 ff d8 	vpternlogd $0xd8,-0xfe1a0a(%rip){1to16},%zmm2,%zmm6        # 580658 <tier0_emit_x87.operations+0x210>
 1562062:	62 91 75 48 62 d2    	vpunpckldq %zmm26,%zmm1,%zmm2
 1562068:	62 91 75 48 6a ca    	vpunpckhdq %zmm26,%zmm1,%zmm1
 156206e:	62 71 65 40 62 fe    	vpunpckldq %zmm6,%zmm19,%zmm15
 1562074:	62 f1 65 40 6a f6    	vpunpckhdq %zmm6,%zmm19,%zmm6
 156207a:	62 c1 ed 48 6c cf    	vpunpcklqdq %zmm15,%zmm2,%zmm17
 1562080:	62 d1 ed 48 6d d7    	vpunpckhqdq %zmm15,%zmm2,%zmm2
 1562086:	62 e1 f5 48 6c d6    	vpunpcklqdq %zmm6,%zmm1,%zmm18
 156208c:	62 f1 f5 48 6d ce    	vpunpckhqdq %zmm6,%zmm1,%zmm1
 1562092:	62 f2 75 40 00 e4    	vpshufb %zmm4,%zmm17,%zmm4
 1562098:	62 d2 6d 48 00 d0    	vpshufb %zmm8,%zmm2,%zmm2
 156209e:	62 d2 75 48 00 ce    	vpshufb %zmm14,%zmm1,%zmm1
 15620a4:	62 f3 d5 48 25 e3 78 	vpternlogq $0x78,%zmm3,%zmm5,%zmm4
 15620ab:	62 f3 ad 48 25 d3 78 	vpternlogq $0x78,%zmm3,%zmm10,%zmm2
 15620b2:	62 f3 fd 40 25 cb 78 	vpternlogq $0x78,%zmm3,%zmm16,%zmm1
 15620b9:	62 f2 7d cb 63 e4    	vpcompressb %zmm4,%zmm4{%k3}{z}
 15620bf:	62 f2 7d ca 63 d2    	vpcompressb %zmm2,%zmm2{%k2}{z}
 15620c5:	62 d2 7d 48 8f db    	vpshufbitqmb %zmm11,%zmm0,%k3
 15620cb:	62 f1 7d 48 70 c7 ff 	vpshufd $0xff,%zmm7,%zmm0
 15620d2:	62 d2 7d 48 8f d6    	vpshufbitqmb %zmm14,%zmm0,%k2
 15620d8:	c4 61 fb 93 db       	kmovq  %k3,%r11
 15620dd:	62 f2 7d ca 63 c9    	vpcompressb %zmm1,%zmm1{%k2}{z}
 15620e3:	62 d1 fe 48 7f 26    	vmovdqu64 %zmm4,(%r14)
 15620e9:	62 d2 6d 40 00 e3    	vpshufb %zmm11,%zmm18,%zmm4
 15620ef:	62 91 fe 48 7f 14 0e 	vmovdqu64 %zmm2,(%r14,%r9,1)
 15620f6:	4d 01 f1             	add    %r14,%r9
 15620f9:	62 f3 95 48 25 e3 78 	vpternlogq $0x78,%zmm3,%zmm13,%zmm4
 1562100:	c5 e9 ef d2          	vpxor  %xmm2,%xmm2,%xmm2
 1562104:	62 f2 7d cb 63 e2    	vpcompressb %zmm4,%zmm2{%k3}{z}
 156210a:	62 91 fe 48 7f 14 0a 	vmovdqu64 %zmm2,(%r10,%r9,1)
 1562111:	4d 01 d1             	add    %r10,%r9
 1562114:	f3 4d 0f b8 d3       	popcnt %r11,%r10
 1562119:	c4 61 fb 93 da       	kmovq  %k2,%r11
 156211e:	f3 4d 0f b8 f3       	popcnt %r11,%r14
 1562123:	62 91 fe 48 7f 0c 0a 	vmovdqu64 %zmm1,(%r10,%r9,1)
 156212a:	4d 01 d6             	add    %r10,%r14
 156212d:	4d 01 ce             	add    %r9,%r14
 1562130:	48 ff c9             	dec    %rcx
 1562133:	0f 85 a7 fa ff ff    	jne    1561be0 <x86_encode_16+0x13a0>
 1562139:	48 8d 48 10          	lea    0x10(%rax),%rcx
 156213d:	48 39 d1             	cmp    %rdx,%rcx
 1562140:	0f 87 a3 05 00 00    	ja     15626e9 <x86_encode_16+0x1ea9>
 1562146:	62 f2 7d 48 5a 1d 90 42 01 ff 	vbroadcasti32x4 -0xfebd70(%rip),%zmm3        # 5763e0 <x86_effects_unknown+0x980>
 1562150:	62 72 7d 48 58 0d c6 e4 01 ff 	vpbroadcastd -0xfe1b3a(%rip),%zmm9        # 580620 <tier0_emit_x87.operations+0x1d8>
 156215a:	48 89 d1             	mov    %rdx,%rcx
 156215d:	48 29 c1             	sub    %rax,%rcx
 1562160:	48 89 c7             	mov    %rax,%rdi
 1562163:	48 c1 e7 04          	shl    $0x4,%rdi
 1562167:	41 b1 cc             	mov    $0xcc,%r9b
 156216a:	4c 8d 05 0f 47 10 0d 	lea    0xd10470f(%rip),%r8        # e666880 <x86_template_storage>
 1562171:	62 53 1d 48 25 e4 ff 	vpternlogd $0xff,%zmm12,%zmm12,%zmm12
 1562178:	48 83 c1 f0          	add    $0xfffffffffffffff0,%rcx
 156217c:	48 8d bc 37 fc 00 00 00 	lea    0xfc(%rdi,%rsi,1),%rdi
 1562184:	c4 c1 7b 92 c9       	kmovd  %r9d,%k1
 1562189:	48 c1 e9 04          	shr    $0x4,%rcx
 156218d:	48 ff c1             	inc    %rcx
 1562190:	44 0f b7 8f 10 ff ff ff 	movzwl -0xf0(%rdi),%r9d
 1562198:	44 0f b7 97 20 ff ff ff 	movzwl -0xe0(%rdi),%r10d
 15621a0:	44 0f b7 9f 30 ff ff ff 	movzwl -0xd0(%rdi),%r11d
 15621a8:	44 0f b7 bf 40 ff ff ff 	movzwl -0xc0(%rdi),%r15d
 15621b0:	62 e1 fe 48 6f 9f 04 ff ff ff 	vmovdqu64 -0xfc(%rdi),%zmm19
 15621ba:	62 e1 fe 48 6f af 44 ff ff ff 	vmovdqu64 -0xbc(%rdi),%zmm21
 15621c4:	62 e1 fe 48 6f b7 84 ff ff ff 	vmovdqu64 -0x7c(%rdi),%zmm22
 15621ce:	62 e1 fe 48 6f bf c4 ff ff ff 	vmovdqu64 -0x3c(%rdi),%zmm23
 15621d8:	62 f2 7d 48 5a 0d 3e 42 01 ff 	vbroadcasti32x4 -0xfebdc2(%rip),%zmm1        # 576420 <x86_effects_unknown+0x9c0>
 15621e2:	48 83 c0 10          	add    $0x10,%rax
 15621e6:	41 c1 e1 06          	shl    $0x6,%r9d
 15621ea:	41 c1 e2 06          	shl    $0x6,%r10d
 15621ee:	41 c1 e3 06          	shl    $0x6,%r11d
 15621f2:	41 c1 e7 06          	shl    $0x6,%r15d
 15621f6:	c4 81 7d 6f 64 01 40 	vmovdqa 0x40(%r9,%r8,1),%ymm4
 15621fd:	44 0f b7 8f 50 ff ff ff 	movzwl -0xb0(%rdi),%r9d
 1562205:	c4 81 7d 6f 6c 02 60 	vmovdqa 0x60(%r10,%r8,1),%ymm5
 156220c:	44 0f b7 97 60 ff ff ff 	movzwl -0xa0(%rdi),%r10d
 1562214:	62 93 dd 48 3a 64 03 02 01 	vinserti64x4 $0x1,0x40(%r11,%r8,1),%zmm4,%zmm4
 156221d:	62 13 d5 48 3a 7c 07 03 01 	vinserti64x4 $0x1,0x60(%r15,%r8,1),%zmm5,%zmm15
 1562226:	44 0f b7 9f 70 ff ff ff 	movzwl -0x90(%rdi),%r11d
 156222e:	44 0f b7 7f 80       	movzwl -0x80(%rdi),%r15d
 1562233:	62 b1 65 40 62 f5    	vpunpckldq %zmm21,%zmm19,%zmm6
 1562239:	62 b1 4d 40 62 ff    	vpunpckldq %zmm23,%zmm22,%zmm7
 156223f:	62 a1 4d 40 6a f7    	vpunpckhdq %zmm23,%zmm22,%zmm22
 1562245:	62 a1 65 40 6a ed    	vpunpckhdq %zmm21,%zmm19,%zmm21
 156224b:	62 b1 d5 40 6c d6    	vpunpcklqdq %zmm22,%zmm21,%zmm2
 1562251:	62 e1 cd 48 6d ff    	vpunpckhqdq %zmm7,%zmm6,%zmm23
 1562257:	62 62 f5 48 83 da    	vpmultishiftqb %zmm2,%zmm1,%zmm27
 156225d:	62 f2 7d 48 5a 0d d9 41 01 ff 	vbroadcasti32x4 -0xfebe27(%rip),%zmm1        # 576440 <x86_effects_unknown+0x9e0>
 1562267:	62 f1 15 40 72 d2 1a 	vpsrld $0x1a,%zmm2,%zmm29
 156226e:	62 b2 45 40 27 c7    	vptestmd %zmm23,%zmm23,%k0
 1562274:	62 e1 fd 48 6f da    	vmovdqa64 %zmm2,%zmm19
 156227a:	41 c1 e1 06          	shl    $0x6,%r9d
 156227e:	41 c1 e2 06          	shl    $0x6,%r10d
 1562282:	c4 01 7d 6f 44 01 40 	vmovdqa 0x40(%r9,%r8,1),%ymm8
 1562289:	44 0f b7 4f 90       	movzwl -0x70(%rdi),%r9d
 156228e:	41 c1 e3 06          	shl    $0x6,%r11d
 1562292:	c4 01 7d 6f 54 02 60 	vmovdqa 0x60(%r10,%r8,1),%ymm10
 1562299:	44 0f b7 57 a0       	movzwl -0x60(%rdi),%r10d
 156229e:	41 c1 e7 06          	shl    $0x6,%r15d
 15622a2:	62 13 bd 48 3a 44 03 02 01 	vinserti64x4 $0x1,0x40(%r11,%r8,1),%zmm8,%zmm8
 15622ab:	62 83 ad 48 3a 4c 07 03 01 	vinserti64x4 $0x1,0x60(%r15,%r8,1),%zmm10,%zmm17
 15622b4:	44 0f b7 5f b0       	movzwl -0x50(%rdi),%r11d
 15622b9:	44 0f b7 7f c0       	movzwl -0x40(%rdi),%r15d
 15622be:	62 d2 dd 49 64 ef    	vpblendmq %zmm15,%zmm4,%zmm5{%k1}
 15622c4:	41 c1 e1 06          	shl    $0x6,%r9d
 15622c8:	41 c1 e2 06          	shl    $0x6,%r10d
 15622cc:	c4 01 7d 6f 5c 01 40 	vmovdqa 0x40(%r9,%r8,1),%ymm11
 15622d3:	44 0f b7 4f d0       	movzwl -0x30(%rdi),%r9d
 15622d8:	41 c1 e3 06          	shl    $0x6,%r11d
 15622dc:	c4 01 7d 6f 6c 02 60 	vmovdqa 0x60(%r10,%r8,1),%ymm13
 15622e3:	44 0f b7 57 e0       	movzwl -0x20(%rdi),%r10d
 15622e8:	41 c1 e7 06          	shl    $0x6,%r15d
 15622ec:	62 62 f5 48 83 f2    	vpmultishiftqb %zmm2,%zmm1,%zmm30
 15622f2:	62 f2 7d 48 5a 0d 34 41 01 ff 	vbroadcasti32x4 -0xfebecc(%rip),%zmm1        # 576430 <x86_effects_unknown+0x9d0>
 15622fc:	62 63 25 50 25 35 f5 e2 01 ff d8 	vpternlogd $0xd8,-0xfe1d0b(%rip){1to16},%zmm27,%zmm30        # 5805fc <tier0_emit_x87.operations+0x1b4>
 1562307:	62 13 a5 48 3a 5c 03 02 01 	vinserti64x4 $0x1,0x40(%r11,%r8,1),%zmm11,%zmm11
 1562310:	62 83 95 48 3a 54 07 03 01 	vinserti64x4 $0x1,0x60(%r15,%r8,1),%zmm13,%zmm18
 1562319:	44 0f b7 5f f0       	movzwl -0x10(%rdi),%r11d
 156231e:	44 0f b7 3f          	movzwl (%rdi),%r15d
 1562322:	48 81 c7 00 01 00 00 	add    $0x100,%rdi
 1562329:	62 32 bd 49 64 d1    	vpblendmq %zmm17,%zmm8,%zmm10{%k1}
 156232f:	62 41 55 48 6a c2    	vpunpckhdq %zmm10,%zmm5,%zmm24
 1562335:	41 c1 e1 06          	shl    $0x6,%r9d
 1562339:	41 c1 e2 06          	shl    $0x6,%r10d
 156233d:	41 c1 e3 06          	shl    $0x6,%r11d
 1562341:	c4 01 7d 6f 74 01 40 	vmovdqa 0x40(%r9,%r8,1),%ymm14
 1562348:	41 c1 e7 06          	shl    $0x6,%r15d
 156234c:	62 81 fd 28 6f 44 02 03 	vmovdqa64 0x60(%r10,%r8,1),%ymm16
 1562354:	62 13 8d 48 3a 74 03 02 01 	vinserti64x4 $0x1,0x40(%r11,%r8,1),%zmm14,%zmm14
 156235d:	62 83 fd 40 3a 64 07 03 01 	vinserti64x4 $0x1,0x60(%r15,%r8,1),%zmm16,%zmm20
 1562366:	62 62 f5 48 83 e2    	vpmultishiftqb %zmm2,%zmm1,%zmm28
 156236c:	62 f1 75 48 72 f2 04 	vpslld $0x4,%zmm2,%zmm1
 1562373:	62 63 0d 50 25 25 82 e2 01 ff e4 	vpternlogd $0xe4,-0xfe1d7e(%rip){1to16},%zmm30,%zmm28        # 580600 <tier0_emit_x87.operations+0x1b8>
 156237e:	62 f1 25 40 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm27
 1562385:	62 f2 7d 48 5a 0d c1 40 01 ff 	vbroadcasti32x4 -0xfebf3f(%rip),%zmm1        # 576450 <x86_effects_unknown+0x9f0>
 156238f:	62 32 a5 49 64 ea    	vpblendmq %zmm18,%zmm11,%zmm13{%k1}
 1562395:	62 a2 8d 49 64 c4    	vpblendmq %zmm20,%zmm14,%zmm16{%k1}
 156239b:	62 21 15 48 6a c8    	vpunpckhdq %zmm16,%zmm13,%zmm25
 15623a1:	62 01 bd 40 6d d1    	vpunpckhqdq %zmm25,%zmm24,%zmm26
 15623a7:	62 62 15 40 36 0d 0f 02 fc fe 	vpermd -0x103fdf1(%rip),%zmm29,%zmm25        # 5225c0 <branch_sizing_patterns+0x2830>
 15623b1:	62 62 15 40 36 05 45 02 fc fe 	vpermd -0x103fdbb(%rip),%zmm29,%zmm24        # 522600 <branch_sizing_patterns+0x2870>
 15623bb:	62 62 75 48 00 f2    	vpshufb %zmm2,%zmm1,%zmm30
 15623c1:	62 f2 7d 48 58 0d 3d e2 01 ff 	vpbroadcastd -0xfe1dc3(%rip),%zmm1        # 580608 <tier0_emit_x87.operations+0x1c0>
 15623cb:	62 62 15 40 36 2d 6b 02 fc fe 	vpermd -0x103fd95(%rip),%zmm29,%zmm29        # 522640 <branch_sizing_patterns+0x28b0>
 15623d5:	62 91 7d 48 72 f6 10 	vpslld $0x10,%zmm30,%zmm0
 15623dc:	62 01 25 40 db f6    	vpandd %zmm30,%zmm27,%zmm30
 15623e2:	62 f1 05 40 72 e0 1f 	vpsrad $0x1f,%zmm0,%zmm31
 15623e9:	62 b1 7d 48 72 e7 1f 	vpsrad $0x1f,%zmm23,%zmm0
 15623f0:	62 03 1d 40 25 c1 f8 	vpternlogd $0xf8,%zmm25,%zmm28,%zmm24
 15623f7:	62 62 7e 48 38 c8    	vpmovm2d %k0,%zmm25
 15623fd:	62 03 25 40 25 cf c8 	vpternlogd $0xc8,%zmm31,%zmm27,%zmm25
 1562404:	62 21 7d 48 ef ff    	vpxord %zmm23,%zmm0,%zmm31
 156240a:	62 f2 7d 48 58 05 f0 e1 01 ff 	vpbroadcastd -0xfe1e10(%rip),%zmm0        # 580604 <tier0_emit_x87.operations+0x1bc>
 1562414:	62 63 15 50 25 35 1d e2 01 ff ec 	vpternlogd $0xec,-0xfe1de3(%rip){1to16},%zmm29,%zmm30        # 58063c <tier0_emit_x87.operations+0x1f4>
 156241f:	62 91 15 40 72 d2 1d 	vpsrld $0x1d,%zmm26,%zmm29
 1562426:	62 02 7d 48 44 ff    	vplzcntd %zmm31,%zmm31
 156242c:	62 63 2d 50 25 35 09 e2 01 ff f8 	vpternlogd $0xf8,-0xfe1df7(%rip){1to16},%zmm26,%zmm30        # 580640 <tier0_emit_x87.operations+0x1f8>
 1562437:	62 02 75 48 45 ff    	vpsrlvd %zmm31,%zmm1,%zmm31
 156243d:	62 d1 45 40 fe cc    	vpaddd %zmm12,%zmm23,%zmm1
 1562443:	62 93 45 40 25 cf 14 	vpternlogd $0x14,%zmm31,%zmm23,%zmm1
 156244a:	62 f1 05 40 72 d2 08 	vpsrld $0x8,%zmm2,%zmm31
 1562451:	62 92 75 48 14 cd    	vprorvd %zmm29,%zmm1,%zmm1
 1562457:	62 f1 75 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm1
 156245e:	62 e3 7d 58 25 1d ab e1 01 ff 6c 	vpternlogd $0x6c,-0xfe1e55(%rip){1to16},%zmm0,%zmm19        # 580614 <tier0_emit_x87.operations+0x1cc>
 1562469:	62 63 7d 58 25 3d a4 e1 01 ff 6c 	vpternlogd $0x6c,-0xfe1e5c(%rip){1to16},%zmm0,%zmm31        # 580618 <tier0_emit_x87.operations+0x1d0>
 1562474:	62 f1 1d 50 db 05 aa e1 01 ff 	vpandd -0xfe1e56(%rip){1to16},%zmm28,%zmm0        # 580628 <tier0_emit_x87.operations+0x1e0>
 156247e:	62 91 1d 40 72 d4 03 	vpsrld $0x3,%zmm28,%zmm28
 1562485:	62 63 2d 50 25 25 a4 e1 01 ff a2 	vpternlogd $0xa2,-0xfe1e5c(%rip){1to16},%zmm26,%zmm28        # 580634 <tier0_emit_x87.operations+0x1ec>
 1562490:	62 c1 65 40 fe dc    	vpaddd %zmm12,%zmm19,%zmm19
 1562496:	62 e3 35 58 25 1d 7b e1 01 ff ec 	vpternlogd $0xec,-0xfe1e85(%rip){1to16},%zmm9,%zmm19        # 58061c <tier0_emit_x87.operations+0x1d4>
 15624a1:	62 41 05 40 fe fc    	vpaddd %zmm12,%zmm31,%zmm31
 15624a7:	62 63 65 50 25 3d 72 e1 01 ff ec 	vpternlogd $0xec,-0xfe1e8e(%rip){1to16},%zmm19,%zmm31        # 580624 <tier0_emit_x87.operations+0x1dc>
 15624b2:	62 93 2d 40 25 c7 f8 	vpternlogd $0xf8,%zmm31,%zmm26,%zmm0
 15624b9:	62 e2 7d 58 3b 1d 69 e1 01 ff 	vpminud -0xfe1e97(%rip){1to16},%zmm0,%zmm19        # 58062c <tier0_emit_x87.operations+0x1e4>
 15624c3:	62 f2 1d 50 3b 05 6b e1 01 ff 	vpminud -0xfe1e95(%rip){1to16},%zmm28,%zmm0        # 580638 <tier0_emit_x87.operations+0x1f0>
 15624cd:	62 01 fd 48 6f d0    	vmovdqa64 %zmm24,%zmm26
 15624d3:	62 63 35 50 25 15 2e e1 01 ff f8 	vpternlogd $0xf8,-0xfe1ed2(%rip){1to16},%zmm25,%zmm26        # 58060c <tier0_emit_x87.operations+0x1c4>
 15624de:	62 61 35 50 db 3d 5c e1 01 ff 	vpandd -0xfe1ea4(%rip){1to16},%zmm25,%zmm31        # 580644 <tier0_emit_x87.operations+0x1fc>
 15624e8:	62 23 7d 48 25 f3 fe 	vpternlogd $0xfe,%zmm19,%zmm0,%zmm30
 15624ef:	62 81 fd 48 6f d8    	vmovdqa64 %zmm24,%zmm19
 15624f5:	62 e3 25 50 25 1d 10 e1 01 ff f8 	vpternlogd $0xf8,-0xfe1ef0(%rip){1to16},%zmm27,%zmm19        # 580610 <tier0_emit_x87.operations+0x1c8>
 1562500:	62 b1 7d 48 72 cf 01 	vprold $0x1,%zmm23,%zmm0
 1562507:	62 61 25 50 db 1d 37 e1 01 ff 	vpandd -0xfe1ec9(%rip){1to16},%zmm27,%zmm27        # 580648 <tier0_emit_x87.operations+0x200>
 1562511:	62 83 75 48 25 da b8 	vpternlogd $0xb8,%zmm26,%zmm1,%zmm19
 1562518:	62 02 7d 48 14 d5    	vprorvd %zmm29,%zmm0,%zmm26
 156251e:	62 f1 fd 48 6f 05 58 00 fc fe 	vmovdqa64 -0x103ffa8(%rip),%zmm0        # 522580 <branch_sizing_patterns+0x27f0>
 1562528:	62 03 75 48 25 df b8 	vpternlogd $0xb8,%zmm31,%zmm1,%zmm27
 156252f:	62 23 35 40 25 d7 e2 	vpternlogd $0xe2,%zmm23,%zmm25,%zmm26
 1562536:	62 23 75 48 25 d7 e2 	vpternlogd $0xe2,%zmm23,%zmm1,%zmm26
 156253d:	62 f1 cd 48 6c cf    	vpunpcklqdq %zmm7,%zmm6,%zmm1
 1562543:	62 d1 1d 40 fe fc    	vpaddd %zmm12,%zmm28,%zmm7
 1562549:	62 b1 d5 40 6d f6    	vpunpckhqdq %zmm22,%zmm21,%zmm6
 156254f:	62 f1 45 48 72 e7 1f 	vpsrad $0x1f,%zmm7,%zmm7
 1562556:	62 f1 4d 48 eb d2    	vpord  %zmm2,%zmm6,%zmm2
 156255c:	62 f1 6d 48 72 f2 07 	vpslld $0x7,%zmm2,%zmm2
 1562563:	62 d2 fd 48 7e e7    	vpermt2q %zmm15,%zmm0,%zmm4
 1562569:	62 32 fd 48 7e c1    	vpermt2q %zmm17,%zmm0,%zmm8
 156256f:	62 32 fd 48 7e da    	vpermt2q %zmm18,%zmm0,%zmm11
 1562575:	62 32 fd 48 7e f4    	vpermt2q %zmm20,%zmm0,%zmm14
 156257b:	62 91 7d 48 72 d0 10 	vpsrld $0x10,%zmm24,%zmm0
 1562582:	62 91 05 48 72 d0 03 	vpsrld $0x3,%zmm24,%zmm15
 1562589:	62 73 7d 58 25 3d 9c e0 01 ff ec 	vpternlogd $0xec,-0xfe1f64(%rip){1to16},%zmm0,%zmm15        # 580630 <tier0_emit_x87.operations+0x1e8>
 1562594:	62 f2 7d 48 5a 05 c2 3e 01 ff 	vbroadcasti32x4 -0xfec13e(%rip),%zmm0        # 576460 <x86_effects_unknown+0xa00>
 156259e:	62 d1 75 40 72 f7 08 	vpslld $0x8,%zmm15,%zmm17
 15625a5:	62 e3 45 58 25 0d 9c e0 01 ff 08 	vpternlogd $0x8,-0xfe1f64(%rip){1to16},%zmm7,%zmm17        # 58064c <tier0_emit_x87.operations+0x204>
 15625b0:	62 f2 fd 48 83 f6    	vpmultishiftqb %zmm6,%zmm0,%zmm6
 15625b6:	62 f3 05 58 25 35 93 e0 01 ff d8 	vpternlogd $0xd8,-0xfe1f6d(%rip){1to16},%zmm15,%zmm6        # 580654 <tier0_emit_x87.operations+0x20c>
 15625c1:	62 91 25 40 eb fe    	vpord  %zmm30,%zmm27,%zmm7
 15625c7:	62 f1 7d 48 70 c7 00 	vpshufd $0x0,%zmm7,%zmm0
 15625ce:	62 f2 7d 48 8f dc    	vpshufbitqmb %zmm4,%zmm0,%k3
 15625d4:	62 f1 7d 48 70 c7 55 	vpshufd $0x55,%zmm7,%zmm0
 15625db:	62 d2 7d 48 8f d0    	vpshufbitqmb %zmm8,%zmm0,%k2
 15625e1:	62 f1 7d 48 70 c7 aa 	vpshufd $0xaa,%zmm7,%zmm0
 15625e8:	c4 61 fb 93 cb       	kmovq  %k3,%r9
 15625ed:	f3 4d 0f b8 c9       	popcnt %r9,%r9
 15625f2:	c4 61 fb 93 d2       	kmovq  %k2,%r10
 15625f7:	f3 4d 0f b8 d2       	popcnt %r10,%r10
 15625fc:	62 f3 75 50 25 15 49 e0 01 ff e4 	vpternlogd $0xe4,-0xfe1fb7(%rip){1to16},%zmm17,%zmm2        # 580650 <tier0_emit_x87.operations+0x208>
 1562607:	62 f3 6d 58 25 35 46 e0 01 ff d8 	vpternlogd $0xd8,-0xfe1fba(%rip){1to16},%zmm2,%zmm6        # 580658 <tier0_emit_x87.operations+0x210>
 1562612:	62 91 75 48 62 d2    	vpunpckldq %zmm26,%zmm1,%zmm2
 1562618:	62 91 75 48 6a ca    	vpunpckhdq %zmm26,%zmm1,%zmm1
 156261e:	62 71 65 40 62 fe    	vpunpckldq %zmm6,%zmm19,%zmm15
 1562624:	62 f1 65 40 6a f6    	vpunpckhdq %zmm6,%zmm19,%zmm6
 156262a:	62 c1 ed 48 6c cf    	vpunpcklqdq %zmm15,%zmm2,%zmm17
 1562630:	62 d1 ed 48 6d d7    	vpunpckhqdq %zmm15,%zmm2,%zmm2
 1562636:	62 e1 f5 48 6c d6    	vpunpcklqdq %zmm6,%zmm1,%zmm18
 156263c:	62 f1 f5 48 6d ce    	vpunpckhqdq %zmm6,%zmm1,%zmm1
 1562642:	62 f2 75 40 00 e4    	vpshufb %zmm4,%zmm17,%zmm4
 1562648:	62 d2 6d 48 00 d0    	vpshufb %zmm8,%zmm2,%zmm2
 156264e:	62 d2 75 48 00 ce    	vpshufb %zmm14,%zmm1,%zmm1
 1562654:	62 f3 d5 48 25 e3 78 	vpternlogq $0x78,%zmm3,%zmm5,%zmm4
 156265b:	62 f3 ad 48 25 d3 78 	vpternlogq $0x78,%zmm3,%zmm10,%zmm2
 1562662:	62 f3 fd 40 25 cb 78 	vpternlogq $0x78,%zmm3,%zmm16,%zmm1
 1562669:	62 f2 7d cb 63 e4    	vpcompressb %zmm4,%zmm4{%k3}{z}
 156266f:	62 f2 7d ca 63 d2    	vpcompressb %zmm2,%zmm2{%k2}{z}
 1562675:	62 d2 7d 48 8f db    	vpshufbitqmb %zmm11,%zmm0,%k3
 156267b:	62 f1 7d 48 70 c7 ff 	vpshufd $0xff,%zmm7,%zmm0
 1562682:	62 d2 7d 48 8f d6    	vpshufbitqmb %zmm14,%zmm0,%k2
 1562688:	c4 61 fb 93 db       	kmovq  %k3,%r11
 156268d:	62 f2 7d ca 63 c9    	vpcompressb %zmm1,%zmm1{%k2}{z}
 1562693:	62 d1 fe 48 7f 26    	vmovdqu64 %zmm4,(%r14)
 1562699:	62 d2 6d 40 00 e3    	vpshufb %zmm11,%zmm18,%zmm4
 156269f:	62 91 fe 48 7f 14 0e 	vmovdqu64 %zmm2,(%r14,%r9,1)
 15626a6:	4d 01 f1             	add    %r14,%r9
 15626a9:	62 f3 95 48 25 e3 78 	vpternlogq $0x78,%zmm3,%zmm13,%zmm4
 15626b0:	c5 e9 ef d2          	vpxor  %xmm2,%xmm2,%xmm2
 15626b4:	62 f2 7d cb 63 e2    	vpcompressb %zmm4,%zmm2{%k3}{z}
 15626ba:	62 91 fe 48 7f 14 0a 	vmovdqu64 %zmm2,(%r10,%r9,1)
 15626c1:	4d 01 d1             	add    %r10,%r9
 15626c4:	f3 4d 0f b8 d3       	popcnt %r11,%r10
 15626c9:	c4 61 fb 93 da       	kmovq  %k2,%r11
 15626ce:	f3 4d 0f b8 f3       	popcnt %r11,%r14
 15626d3:	62 91 fe 48 7f 0c 0a 	vmovdqu64 %zmm1,(%r10,%r9,1)
 15626da:	4d 01 d6             	add    %r10,%r14
 15626dd:	4d 01 ce             	add    %r9,%r14
 15626e0:	48 ff c9             	dec    %rcx
 15626e3:	0f 85 a7 fa ff ff    	jne    1562190 <x86_encode_16+0x1950>
 15626e9:	48 29 c2             	sub    %rax,%rdx
 15626ec:	0f 86 e6 05 00 00    	jbe    1562cd8 <x86_encode_16+0x2498>
 15626f2:	48 c1 e0 04          	shl    $0x4,%rax
 15626f6:	48 c1 e2 04          	shl    $0x4,%rdx
 15626fa:	48 8d 7c 24 40       	lea    0x40(%rsp),%rdi
 15626ff:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 1562703:	62 f1 fd 48 7f 44 24 04 	vmovdqa64 %zmm0,0x100(%rsp)
 156270b:	62 f1 fd 48 7f 44 24 03 	vmovdqa64 %zmm0,0xc0(%rsp)
 1562713:	62 f1 fd 48 7f 44 24 02 	vmovdqa64 %zmm0,0x80(%rsp)
 156271b:	62 f1 fd 48 7f 44 24 01 	vmovdqa64 %zmm0,0x40(%rsp)
 1562723:	48 01 c6             	add    %rax,%rsi
 1562726:	c5 f8 77             	vzeroupper
 1562729:	e8 22 1d 20 ff       	call   764450 <memcpy@plt>
 156272e:	c5 f9 6f 64 24 70    	vmovdqa 0x70(%rsp),%xmm4
 1562734:	c5 f9 6f 4c 24 40    	vmovdqa 0x40(%rsp),%xmm1
 156273a:	c5 f9 6f 54 24 50    	vmovdqa 0x50(%rsp),%xmm2
 1562740:	c5 f9 6f 5c 24 60    	vmovdqa 0x60(%rsp),%xmm3
 1562746:	c5 f9 6f ac 24 80 00 00 00 	vmovdqa 0x80(%rsp),%xmm5
 156274f:	48 8d 05 2a 41 10 0d 	lea    0xd10412a(%rip),%rax        # e666880 <x86_template_storage>
 1562756:	62 71 fd 48 6f 3d 20 fe fb fe 	vmovdqa64 -0x10401e0(%rip),%zmm15        # 522580 <branch_sizing_patterns+0x27f0>
 1562760:	c5 f9 6f bc 24 c0 00 00 00 	vmovdqa 0xc0(%rsp),%xmm7
 1562769:	c5 f9 6f b4 24 d0 00 00 00 	vmovdqa 0xd0(%rsp),%xmm6
 1562772:	62 71 fd 48 6f 4c 24 01 	vmovdqa64 0x40(%rsp),%zmm9
 156277a:	62 71 fd 48 6f 54 24 02 	vmovdqa64 0x80(%rsp),%zmm10
 1562782:	62 71 fd 48 6f 5c 24 03 	vmovdqa64 0xc0(%rsp),%zmm11
 156278a:	62 71 fd 48 6f 64 24 04 	vmovdqa64 0x100(%rsp),%zmm12
 1562792:	62 e2 7d 48 5a 0d 94 3c 01 ff 	vbroadcasti32x4 -0xfec36c(%rip),%zmm17        # 576430 <x86_effects_unknown+0x9d0>
 156279c:	62 a3 4d 40 25 f6 ff 	vpternlogd $0xff,%zmm22,%zmm22,%zmm22
 15627a3:	62 e2 7d 48 58 25 57 de 01 ff 	vpbroadcastd -0xfe21a9(%rip),%zmm20        # 580604 <tier0_emit_x87.operations+0x1bc>
 15627ad:	62 62 7d 48 58 15 59 de 01 ff 	vpbroadcastd -0xfe21a7(%rip),%zmm26        # 580610 <tier0_emit_x87.operations+0x1c8>
 15627b7:	62 62 7d 48 58 0d 53 de 01 ff 	vpbroadcastd -0xfe21ad(%rip),%zmm25        # 580614 <tier0_emit_x87.operations+0x1cc>
 15627c1:	c5 f9 c5 fc 06       	vpextrw $0x6,%xmm4,%edi
 15627c6:	c5 f9 6f a4 24 90 00 00 00 	vmovdqa 0x90(%rsp),%xmm4
 15627cf:	c5 f9 c5 c9 06       	vpextrw $0x6,%xmm1,%ecx
 15627d4:	c5 f9 c5 d2 06       	vpextrw $0x6,%xmm2,%edx
 15627d9:	c5 f9 c5 f3 06       	vpextrw $0x6,%xmm3,%esi
 15627de:	62 51 35 48 62 ea    	vpunpckldq %zmm10,%zmm9,%zmm13
 15627e4:	62 51 25 48 62 f4    	vpunpckldq %zmm12,%zmm11,%zmm14
 15627ea:	62 51 35 48 6a d2    	vpunpckhdq %zmm10,%zmm9,%zmm10
 15627f0:	62 51 25 48 6a e4    	vpunpckhdq %zmm12,%zmm11,%zmm12
 15627f6:	c1 e1 06             	shl    $0x6,%ecx
 15627f9:	c1 e2 06             	shl    $0x6,%edx
 15627fc:	c1 e6 06             	shl    $0x6,%esi
 15627ff:	c1 e7 06             	shl    $0x6,%edi
 1562802:	62 51 ad 48 6c dc    	vpunpcklqdq %zmm12,%zmm10,%zmm11
 1562808:	62 d1 95 48 6c c6    	vpunpcklqdq %zmm14,%zmm13,%zmm0
 156280e:	62 51 95 48 6d ce    	vpunpckhqdq %zmm14,%zmm13,%zmm9
 1562814:	62 51 ad 48 6d e4    	vpunpckhqdq %zmm12,%zmm10,%zmm12
 156281a:	c5 fd 6f 4c 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm1
 1562820:	b1 cc                	mov    $0xcc,%cl
 1562822:	c5 fd 6f 54 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm2
 1562828:	62 c2 f5 40 83 db    	vpmultishiftqb %zmm11,%zmm17,%zmm19
 156282e:	62 d2 35 48 27 c1    	vptestmd %zmm9,%zmm9,%k0
 1562834:	62 d1 75 40 72 e1 1f 	vpsrad $0x1f,%zmm9,%zmm17
 156283b:	62 21 35 48 fe c6    	vpaddd %zmm22,%zmm9,%zmm24
 1562841:	62 43 5d 40 25 cb 6c 	vpternlogd $0x6c,%zmm11,%zmm20,%zmm25
 1562848:	c5 fb 92 c9          	kmovd  %ecx,%k1
 156284c:	c5 f9 c5 cd 06       	vpextrw $0x6,%xmm5,%ecx
 1562851:	c5 f9 6f ac 24 a0 00 00 00 	vmovdqa 0xa0(%rsp),%xmm5
 156285a:	62 f3 f5 48 3a 4c 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm1,%zmm1
 1562863:	62 f3 ed 48 3a 5c 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm2,%zmm3
 156286c:	c1 e1 06             	shl    $0x6,%ecx
 156286f:	c5 f9 c5 d4 06       	vpextrw $0x6,%xmm4,%edx
 1562874:	c5 f9 6f a4 24 b0 00 00 00 	vmovdqa 0xb0(%rsp),%xmm4
 156287d:	c1 e2 06             	shl    $0x6,%edx
 1562880:	c5 f9 c5 f5 06       	vpextrw $0x6,%xmm5,%esi
 1562885:	62 f2 f5 49 64 d3    	vpblendmq %zmm3,%zmm1,%zmm2{%k1}
 156288b:	62 f2 85 48 7e cb    	vpermt2q %zmm3,%zmm15,%zmm1
 1562891:	c5 fd 6f 5c 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm3
 1562897:	c5 f9 c5 cf 06       	vpextrw $0x6,%xmm7,%ecx
 156289c:	c5 f9 6f bc 24 e0 00 00 00 	vmovdqa 0xe0(%rsp),%xmm7
 15628a5:	c1 e6 06             	shl    $0x6,%esi
 15628a8:	c1 e1 06             	shl    $0x6,%ecx
 15628ab:	62 f3 e5 48 3a 5c 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm3,%zmm3
 15628b4:	c5 f9 c5 fc 06       	vpextrw $0x6,%xmm4,%edi
 15628b9:	c5 fd 6f 64 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm4
 15628bf:	c5 f9 c5 d6 06       	vpextrw $0x6,%xmm6,%edx
 15628c4:	c5 f9 6f b4 24 f0 00 00 00 	vmovdqa 0xf0(%rsp),%xmm6
 15628cd:	c1 e7 06             	shl    $0x6,%edi
 15628d0:	c1 e2 06             	shl    $0x6,%edx
 15628d3:	62 f3 dd 48 3a 6c 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm4,%zmm5
 15628dc:	c5 f9 c5 f7 06       	vpextrw $0x6,%xmm7,%esi
 15628e1:	c1 e6 06             	shl    $0x6,%esi
 15628e4:	c5 f9 c5 fe 06       	vpextrw $0x6,%xmm6,%edi
 15628e9:	c5 fd 6f 74 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm6
 15628ef:	0f b7 94 24 1c 01 00 00 	movzwl 0x11c(%rsp),%edx
 15628f7:	c1 e7 06             	shl    $0x6,%edi
 15628fa:	62 f2 e5 49 64 e5    	vpblendmq %zmm5,%zmm3,%zmm4{%k1}
 1562900:	62 f2 85 48 7e dd    	vpermt2q %zmm5,%zmm15,%zmm3
 1562906:	c5 fd 6f 6c 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm5
 156290c:	62 f3 cd 48 3a 7c 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm6,%zmm7
 1562915:	0f b7 8c 24 0c 01 00 00 	movzwl 0x10c(%rsp),%ecx
 156291d:	0f b7 bc 24 3c 01 00 00 	movzwl 0x13c(%rsp),%edi
 1562925:	62 f3 d5 48 3a 6c 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm5,%zmm5
 156292e:	0f b7 b4 24 2c 01 00 00 	movzwl 0x12c(%rsp),%esi
 1562936:	62 71 6d 48 6a d4    	vpunpckhdq %zmm4,%zmm2,%zmm10
 156293c:	c1 e2 06             	shl    $0x6,%edx
 156293f:	c5 7d 6f 44 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm8
 1562945:	c1 e1 06             	shl    $0x6,%ecx
 1562948:	c1 e7 06             	shl    $0x6,%edi
 156294b:	c1 e6 06             	shl    $0x6,%esi
 156294e:	62 e3 bd 48 3a 44 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm8,%zmm16
 1562957:	62 f2 d5 49 64 f7    	vpblendmq %zmm7,%zmm5,%zmm6{%k1}
 156295d:	62 f2 85 48 7e ef    	vpermt2q %zmm7,%zmm15,%zmm5
 1562963:	c5 fd 6f 7c 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm7
 1562969:	62 f3 c5 48 3a 7c 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm7,%zmm7
 1562972:	62 32 c5 49 64 c0    	vpblendmq %zmm16,%zmm7,%zmm8{%k1}
 1562978:	62 b2 85 48 7e f8    	vpermt2q %zmm16,%zmm15,%zmm7
 156297e:	62 e2 7d 48 5a 05 98 3a 01 ff 	vbroadcasti32x4 -0xfec568(%rip),%zmm16        # 576420 <x86_effects_unknown+0x9c0>
 1562988:	62 51 4d 48 6a e8    	vpunpckhdq %zmm8,%zmm6,%zmm13
 156298e:	62 51 ad 48 6d d5    	vpunpckhqdq %zmm13,%zmm10,%zmm10
 1562994:	62 d1 15 48 72 d3 1a 	vpsrld $0x1a,%zmm11,%zmm13
 156299b:	62 72 15 48 36 35 1b fc fb fe 	vpermd -0x10403e5(%rip),%zmm13,%zmm14        # 5225c0 <branch_sizing_patterns+0x2830>
 15629a5:	62 e2 15 48 36 15 51 fc fb fe 	vpermd -0x10403af(%rip),%zmm13,%zmm18        # 522600 <branch_sizing_patterns+0x2870>
 15629af:	62 72 15 48 36 2d 87 fc fb fe 	vpermd -0x1040379(%rip),%zmm13,%zmm13        # 522640 <branch_sizing_patterns+0x28b0>
 15629b9:	62 d1 45 40 72 d2 1d 	vpsrld $0x1d,%zmm10,%zmm23
 15629c0:	62 52 fd 40 83 fb    	vpmultishiftqb %zmm11,%zmm16,%zmm15
 15629c6:	62 e2 7d 48 5a 05 70 3a 01 ff 	vbroadcasti32x4 -0xfec590(%rip),%zmm16        # 576440 <x86_effects_unknown+0x9e0>
 15629d0:	62 c2 fd 40 83 c3    	vpmultishiftqb %zmm11,%zmm16,%zmm16
 15629d6:	62 e3 05 58 25 05 1b dc 01 ff d8 	vpternlogd $0xd8,-0xfe23e5(%rip){1to16},%zmm15,%zmm16        # 5805fc <tier0_emit_x87.operations+0x1b4>
 15629e1:	62 d1 05 48 72 f3 04 	vpslld $0x4,%zmm11,%zmm15
 15629e8:	62 d1 05 48 72 e7 1f 	vpsrad $0x1f,%zmm15,%zmm15
 15629ef:	62 e3 7d 50 25 1d 06 dc 01 ff e4 	vpternlogd $0xe4,-0xfe23fa(%rip){1to16},%zmm16,%zmm19        # 580600 <tier0_emit_x87.operations+0x1b8>
 15629fa:	62 e2 7d 48 5a 05 4c 3a 01 ff 	vbroadcasti32x4 -0xfec5b4(%rip),%zmm16        # 576450 <x86_effects_unknown+0x9f0>
 1562a04:	62 c2 7d 40 00 eb    	vpshufb %zmm11,%zmm16,%zmm21
 1562a0a:	62 c3 65 40 25 d6 f8 	vpternlogd $0xf8,%zmm14,%zmm19,%zmm18
 1562a11:	62 23 05 48 25 d2 ea 	vpternlogd $0xea,%zmm18,%zmm15,%zmm26
 1562a18:	62 b1 0d 48 72 f5 10 	vpslld $0x10,%zmm21,%zmm14
 1562a1f:	62 d1 7d 40 72 e6 1f 	vpsrad $0x1f,%zmm14,%zmm16
 1562a26:	62 72 7e 48 38 f0    	vpmovm2d %k0,%zmm14
 1562a2c:	62 33 05 48 25 f0 c8 	vpternlogd $0xc8,%zmm16,%zmm15,%zmm14
 1562a33:	62 c1 75 40 ef c1    	vpxord %zmm9,%zmm17,%zmm16
 1562a39:	62 e2 7d 48 58 0d c5 db 01 ff 	vpbroadcastd -0xfe243b(%rip),%zmm17        # 580608 <tier0_emit_x87.operations+0x1c0>
 1562a43:	62 a2 7d 48 44 c0    	vplzcntd %zmm16,%zmm16
 1562a49:	62 a2 75 40 45 c0    	vpsrlvd %zmm16,%zmm17,%zmm16
 1562a4f:	62 23 35 48 25 c0 14 	vpternlogd $0x14,%zmm16,%zmm9,%zmm24
 1562a56:	62 a2 3d 40 14 c7    	vprorvd %zmm23,%zmm24,%zmm16
 1562a5c:	62 62 7d 48 58 05 a6 db 01 ff 	vpbroadcastd -0xfe245a(%rip),%zmm24        # 58060c <tier0_emit_x87.operations+0x1c4>
 1562a66:	62 b1 7d 40 72 e0 1f 	vpsrad $0x1f,%zmm16,%zmm16
 1562a6d:	62 23 0d 48 25 c2 ea 	vpternlogd $0xea,%zmm18,%zmm14,%zmm24
 1562a74:	62 03 7d 40 25 d0 b8 	vpternlogd $0xb8,%zmm24,%zmm16,%zmm26
 1562a7b:	62 21 35 40 fe c6    	vpaddd %zmm22,%zmm25,%zmm24
 1562a81:	62 d1 35 40 72 d3 08 	vpsrld $0x8,%zmm11,%zmm25
 1562a88:	62 63 5d 50 25 0d 85 db 01 ff 6c 	vpternlogd $0x6c,-0xfe247b(%rip){1to16},%zmm20,%zmm25        # 580618 <tier0_emit_x87.operations+0x1d0>
 1562a93:	62 51 1d 48 eb db    	vpord  %zmm11,%zmm12,%zmm11
 1562a99:	62 d1 25 48 72 f3 07 	vpslld $0x7,%zmm11,%zmm11
 1562aa0:	62 a1 35 40 fe e6    	vpaddd %zmm22,%zmm25,%zmm20
 1562aa6:	62 62 7d 48 58 0d 6c db 01 ff 	vpbroadcastd -0xfe2494(%rip),%zmm25        # 58061c <tier0_emit_x87.operations+0x1d4>
 1562ab0:	62 63 3d 50 25 0d 65 db 01 ff ea 	vpternlogd $0xea,-0xfe249b(%rip){1to16},%zmm24,%zmm25        # 580620 <tier0_emit_x87.operations+0x1d8>
 1562abb:	62 61 65 50 db 05 63 db 01 ff 	vpandd -0xfe249d(%rip){1to16},%zmm19,%zmm24        # 580628 <tier0_emit_x87.operations+0x1e0>
 1562ac5:	62 b1 65 40 72 d3 03 	vpsrld $0x3,%zmm19,%zmm19
 1562acc:	62 e3 2d 58 25 1d 5d db 01 ff a2 	vpternlogd $0xa2,-0xfe24a3(%rip){1to16},%zmm10,%zmm19        # 580634 <tier0_emit_x87.operations+0x1ec>
 1562ad7:	62 63 5d 50 25 0d 42 db 01 ff f8 	vpternlogd $0xf8,-0xfe24be(%rip){1to16},%zmm20,%zmm25        # 580624 <tier0_emit_x87.operations+0x1dc>
 1562ae2:	62 a1 65 40 fe f6    	vpaddd %zmm22,%zmm19,%zmm22
 1562ae8:	62 e2 65 50 3b 1d 46 db 01 ff 	vpminud -0xfe24ba(%rip){1to16},%zmm19,%zmm19        # 580638 <tier0_emit_x87.operations+0x1f0>
 1562af2:	62 03 2d 48 25 c1 f8 	vpternlogd $0xf8,%zmm25,%zmm10,%zmm24
 1562af9:	62 e2 3d 50 3b 25 29 db 01 ff 	vpminud -0xfe24d7(%rip){1to16},%zmm24,%zmm20        # 58062c <tier0_emit_x87.operations+0x1e4>
 1562b03:	62 b1 3d 40 72 d2 10 	vpsrld $0x10,%zmm18,%zmm24
 1562b0a:	62 b1 6d 40 72 d2 03 	vpsrld $0x3,%zmm18,%zmm18
 1562b11:	62 b1 4d 40 72 e6 1f 	vpsrad $0x1f,%zmm22,%zmm22
 1562b18:	62 e3 3d 50 25 15 0d db 01 ff ec 	vpternlogd $0xec,-0xfe24f3(%rip){1to16},%zmm24,%zmm18        # 580630 <tier0_emit_x87.operations+0x1e8>
 1562b23:	62 b1 3d 40 72 f2 08 	vpslld $0x8,%zmm18,%zmm24
 1562b2a:	62 63 4d 50 25 05 17 db 01 ff 08 	vpternlogd $0x8,-0xfe24e9(%rip){1to16},%zmm22,%zmm24        # 58064c <tier0_emit_x87.operations+0x204>
 1562b35:	62 e2 7d 48 5a 35 21 39 01 ff 	vbroadcasti32x4 -0xfec6df(%rip),%zmm22        # 576460 <x86_effects_unknown+0xa00>
 1562b3f:	62 73 3d 50 25 1d 06 db 01 ff e4 	vpternlogd $0xe4,-0xfe24fa(%rip){1to16},%zmm24,%zmm11        # 580650 <tier0_emit_x87.operations+0x208>
 1562b4a:	62 c2 cd 40 83 f4    	vpmultishiftqb %zmm12,%zmm22,%zmm22
 1562b50:	62 31 05 48 db e5    	vpandd %zmm21,%zmm15,%zmm12
 1562b56:	62 73 15 58 25 25 db da 01 ff ec 	vpternlogd $0xec,-0xfe2525(%rip){1to16},%zmm13,%zmm12        # 58063c <tier0_emit_x87.operations+0x1f4>
 1562b61:	62 e3 6d 50 25 35 e8 da 01 ff d8 	vpternlogd $0xd8,-0xfe2518(%rip){1to16},%zmm18,%zmm22        # 580654 <tier0_emit_x87.operations+0x20c>
 1562b6c:	62 71 05 58 db 2d d2 da 01 ff 	vpandd -0xfe252e(%rip){1to16},%zmm15,%zmm13        # 580648 <tier0_emit_x87.operations+0x200>
 1562b76:	62 73 2d 58 25 25 bf da 01 ff f8 	vpternlogd $0xf8,-0xfe2541(%rip){1to16},%zmm10,%zmm12        # 580640 <tier0_emit_x87.operations+0x1f8>
 1562b81:	62 71 0d 58 db 15 b9 da 01 ff 	vpandd -0xfe2547(%rip){1to16},%zmm14,%zmm10        # 580644 <tier0_emit_x87.operations+0x1fc>
 1562b8b:	62 e3 25 58 25 35 c2 da 01 ff d8 	vpternlogd $0xd8,-0xfe253e(%rip){1to16},%zmm11,%zmm22        # 580658 <tier0_emit_x87.operations+0x210>
 1562b96:	62 d1 25 48 72 c9 01 	vprold $0x1,%zmm9,%zmm11
 1562b9d:	62 33 65 40 25 e4 fe 	vpternlogd $0xfe,%zmm20,%zmm19,%zmm12
 1562ba4:	62 53 7d 40 25 ea b8 	vpternlogd $0xb8,%zmm10,%zmm16,%zmm13
 1562bab:	62 32 25 48 14 df    	vprorvd %zmm23,%zmm11,%zmm11
 1562bb1:	62 51 15 48 eb d4    	vpord  %zmm12,%zmm13,%zmm10
 1562bb7:	62 51 7d 48 70 fa 00 	vpshufd $0x0,%zmm10,%zmm15
 1562bbe:	62 53 0d 48 25 d9 e2 	vpternlogd $0xe2,%zmm9,%zmm14,%zmm11
 1562bc5:	62 72 7d 48 5a 35 11 38 01 ff 	vbroadcasti32x4 -0xfec7ef(%rip),%zmm14        # 5763e0 <x86_effects_unknown+0x980>
 1562bcf:	62 f2 05 48 8f c9    	vpshufbitqmb %zmm1,%zmm15,%k1
 1562bd5:	62 53 7d 40 25 d9 e2 	vpternlogd $0xe2,%zmm9,%zmm16,%zmm11
 1562bdc:	62 51 7d 48 62 cb    	vpunpckldq %zmm11,%zmm0,%zmm9
 1562be2:	62 d1 7d 48 6a c3    	vpunpckhdq %zmm11,%zmm0,%zmm0
 1562be8:	c4 e1 fb 93 c1       	kmovq  %k1,%rax
 1562bed:	62 31 2d 40 62 de    	vpunpckldq %zmm22,%zmm26,%zmm11
 1562bf3:	62 31 2d 40 6a e6    	vpunpckhdq %zmm22,%zmm26,%zmm12
 1562bf9:	f3 48 0f b8 c0       	popcnt %rax,%rax
 1562bfe:	62 51 b5 48 6c eb    	vpunpcklqdq %zmm11,%zmm9,%zmm13
 1562c04:	62 c1 fd 48 6c c4    	vpunpcklqdq %zmm12,%zmm0,%zmm16
 1562c0a:	62 d1 fd 48 6d c4    	vpunpckhqdq %zmm12,%zmm0,%zmm0
 1562c10:	62 51 b5 48 6d cb    	vpunpckhqdq %zmm11,%zmm9,%zmm9
 1562c16:	62 51 7d 48 70 e2 55 	vpshufd $0x55,%zmm10,%zmm12
 1562c1d:	49 8d 0c 06          	lea    (%r14,%rax,1),%rcx
 1562c21:	62 72 15 48 00 e9    	vpshufb %zmm1,%zmm13,%zmm13
 1562c27:	62 f2 7d 48 00 c7    	vpshufb %zmm7,%zmm0,%zmm0
 1562c2d:	62 53 ed 48 25 ee 78 	vpternlogq $0x78,%zmm14,%zmm2,%zmm13
 1562c34:	62 f2 35 48 00 d3    	vpshufb %zmm3,%zmm9,%zmm2
 1562c3a:	62 d3 bd 48 25 c6 78 	vpternlogq $0x78,%zmm14,%zmm8,%zmm0
 1562c41:	62 72 7d c9 63 e9    	vpcompressb %zmm13,%zmm1{%k1}{z}
 1562c47:	62 f2 1d 48 8f cb    	vpshufbitqmb %zmm3,%zmm12,%k1
 1562c4d:	62 d1 7d 48 70 da aa 	vpshufd $0xaa,%zmm10,%zmm3
 1562c54:	62 d3 dd 48 25 d6 78 	vpternlogq $0x78,%zmm14,%zmm4,%zmm2
 1562c5b:	c4 e1 fb 93 d1       	kmovq  %k1,%rdx
 1562c60:	f3 48 0f b8 d2       	popcnt %rdx,%rdx
 1562c65:	62 d1 fe 48 7f 0e    	vmovdqu64 %zmm1,(%r14)
 1562c6b:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
 1562c6f:	62 f2 7d c9 63 d1    	vpcompressb %zmm2,%zmm1{%k1}{z}
 1562c75:	62 f2 7d 40 00 d5    	vpshufb %zmm5,%zmm16,%zmm2
 1562c7b:	62 f2 65 48 8f cd    	vpshufbitqmb %zmm5,%zmm3,%k1
 1562c81:	62 d3 cd 48 25 d6 78 	vpternlogq $0x78,%zmm14,%zmm6,%zmm2
 1562c88:	c4 e1 fb 93 f1       	kmovq  %k1,%rsi
 1562c8d:	f3 48 0f b8 f6       	popcnt %rsi,%rsi
 1562c92:	62 d1 fe 48 7f 0c 06 	vmovdqu64 %zmm1,(%r14,%rax,1)
 1562c99:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
 1562c9d:	62 f2 7d c9 63 d1    	vpcompressb %zmm2,%zmm1{%k1}{z}
 1562ca3:	62 d1 7d 48 70 d2 ff 	vpshufd $0xff,%zmm10,%zmm2
 1562caa:	48 8d 04 11          	lea    (%rcx,%rdx,1),%rax
 1562cae:	62 f2 6d 48 8f cf    	vpshufbitqmb %zmm7,%zmm2,%k1
 1562cb4:	62 f2 7d c9 63 c0    	vpcompressb %zmm0,%zmm0{%k1}{z}
 1562cba:	62 f1 fe 48 7f 0c 0a 	vmovdqu64 %zmm1,(%rdx,%rcx,1)
 1562cc1:	c4 e1 fb 93 c9       	kmovq  %k1,%rcx
 1562cc6:	f3 4c 0f b8 f1       	popcnt %rcx,%r14
 1562ccb:	49 01 f6             	add    %rsi,%r14
 1562cce:	49 01 c6             	add    %rax,%r14
 1562cd1:	62 f1 fe 48 7f 04 06 	vmovdqu64 %zmm0,(%rsi,%rax,1)
 1562cd8:	49 29 de             	sub    %rbx,%r14
 1562cdb:	64 48 8b 04 25 28 00 00 00 	mov    %fs:0x28,%rax
 1562ce4:	48 3b 84 24 48 01 00 00 	cmp    0x148(%rsp),%rax
 1562cec:	75 13                	jne    1562d01 <x86_encode_16+0x24c1>
 1562cee:	4c 89 f0             	mov    %r14,%rax
 1562cf1:	48 8d 65 e0          	lea    -0x20(%rbp),%rsp
 1562cf5:	5b                   	pop    %rbx
 1562cf6:	41 5c                	pop    %r12
 1562cf8:	41 5e                	pop    %r14
 1562cfa:	41 5f                	pop    %r15
 1562cfc:	5d                   	pop    %rbp
 1562cfd:	c5 f8 77             	vzeroupper
 1562d00:	c3                   	ret
 1562d01:	c5 f8 77             	vzeroupper
 1562d04:	e8 d7 0d 20 ff       	call   763ae0 <__stack_chk_fail@plt>
