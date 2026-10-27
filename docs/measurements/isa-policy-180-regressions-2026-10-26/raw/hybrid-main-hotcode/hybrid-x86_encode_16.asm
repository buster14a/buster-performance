
/home/david/buster-fast-bench/codex-180-fix-20261027-hybrid/build/compiler:     file format elf64-x86-64


Disassembly of section .text:

00000000019066d0 <x86_encode_16>:
 19066d0:	55                   	push   %rbp
 19066d1:	48 89 e5             	mov    %rsp,%rbp
 19066d4:	41 57                	push   %r15
 19066d6:	41 56                	push   %r14
 19066d8:	41 54                	push   %r12
 19066da:	53                   	push   %rbx
 19066db:	48 83 e4 c0          	and    $0xffffffffffffffc0,%rsp
 19066df:	48 81 ec 80 01 00 00 	sub    $0x180,%rsp
 19066e6:	64 48 8b 04 25 28 00 00 00 	mov    %fs:0x28,%rax
 19066ef:	48 89 d3             	mov    %rdx,%rbx
 19066f2:	48 89 f2             	mov    %rsi,%rdx
 19066f5:	48 89 fe             	mov    %rdi,%rsi
 19066f8:	48 89 84 24 48 01 00 00 	mov    %rax,0x148(%rsp)
 1906700:	48 85 c9             	test   %rcx,%rcx
 1906703:	74 10                	je     1906715 <x86_encode_16+0x45>
 1906705:	48 83 fa 10          	cmp    $0x10,%rdx
 1906709:	73 1e                	jae    1906729 <x86_encode_16+0x59>
 190670b:	31 c0                	xor    %eax,%eax
 190670d:	48 89 df             	mov    %rbx,%rdi
 1906710:	e9 49 06 00 00       	jmp    1906d5e <x86_encode_16+0x68e>
 1906715:	48 83 fa 10          	cmp    $0x10,%rdx
 1906719:	0f 83 0c 13 00 00    	jae    1907a2b <x86_encode_16+0x135b>
 190671f:	31 c0                	xor    %eax,%eax
 1906721:	49 89 de             	mov    %rbx,%r14
 1906724:	e9 a0 18 00 00       	jmp    1907fc9 <x86_encode_16+0x18f9>
 1906729:	62 f2 7d 48 5a 1d ad fc c6 fe 	vbroadcasti32x4 -0x1390353(%rip),%zmm3        # 5763e0 <x86_effects_unknown+0x980>
 1906733:	62 72 7d 48 58 0d e3 9e c7 fe 	vpbroadcastd -0x138611d(%rip),%zmm9        # 580620 <tier0_emit_x87.operations+0x1d8>
 190673d:	4c 8d 42 f0          	lea    -0x10(%rdx),%r8
 1906741:	40 b7 cc             	mov    $0xcc,%dil
 1906744:	4c 8d 8e fc 00 00 00 	lea    0xfc(%rsi),%r9
 190674b:	4c 8d 15 2e fc d5 0c 	lea    0xcd5fc2e(%rip),%r10        # e666380 <x86_template_storage>
 1906752:	62 53 1d 48 25 e4 ff 	vpternlogd $0xff,%zmm12,%zmm12,%zmm12
 1906759:	31 c0                	xor    %eax,%eax
 190675b:	49 89 db             	mov    %rbx,%r11
 190675e:	49 c1 e8 04          	shr    $0x4,%r8
 1906762:	c5 fb 92 cf          	kmovd  %edi,%k1
 1906766:	49 ff c0             	inc    %r8
 1906769:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
 1906770:	41 0f b7 b9 10 ff ff ff 	movzwl -0xf0(%r9),%edi
 1906778:	45 0f b7 b1 20 ff ff ff 	movzwl -0xe0(%r9),%r14d
 1906780:	45 0f b7 b9 30 ff ff ff 	movzwl -0xd0(%r9),%r15d
 1906788:	45 0f b7 a1 40 ff ff ff 	movzwl -0xc0(%r9),%r12d
 1906790:	62 c1 fe 48 6f a1 04 ff ff ff 	vmovdqu64 -0xfc(%r9),%zmm20
 190679a:	62 41 fe 48 6f 99 44 ff ff ff 	vmovdqu64 -0xbc(%r9),%zmm27
 19067a4:	62 41 fe 48 6f a9 84 ff ff ff 	vmovdqu64 -0x7c(%r9),%zmm29
 19067ae:	62 41 fe 48 6f b1 c4 ff ff ff 	vmovdqu64 -0x3c(%r9),%zmm30
 19067b8:	62 f2 7d 48 5a 2d 5e fc c6 fe 	vbroadcasti32x4 -0x13903a2(%rip),%zmm5        # 576420 <x86_effects_unknown+0x9c0>
 19067c2:	62 f2 7d 48 5a 05 64 fc c6 fe 	vbroadcasti32x4 -0x139039c(%rip),%zmm0        # 576430 <x86_effects_unknown+0x9d0>
 19067cc:	62 72 7d 48 58 05 32 9e c7 fe 	vpbroadcastd -0x13861ce(%rip),%zmm8        # 580608 <tier0_emit_x87.operations+0x1c0>
 19067d6:	48 83 c0 10          	add    $0x10,%rax
 19067da:	c1 e7 06             	shl    $0x6,%edi
 19067dd:	41 c1 e6 06          	shl    $0x6,%r14d
 19067e1:	41 c1 e7 06          	shl    $0x6,%r15d
 19067e5:	41 c1 e4 06          	shl    $0x6,%r12d
 19067e9:	c4 a1 7d 6f 4c 17 40 	vmovdqa 0x40(%rdi,%r10,1),%ymm1
 19067f0:	41 0f b7 b9 50 ff ff ff 	movzwl -0xb0(%r9),%edi
 19067f8:	62 13 f5 48 3a 5c 17 02 01 	vinserti64x4 $0x1,0x40(%r15,%r10,1),%zmm1,%zmm11
 1906801:	45 0f b7 b9 70 ff ff ff 	movzwl -0x90(%r9),%r15d
 1906809:	c4 81 7d 6f 4c 16 60 	vmovdqa 0x60(%r14,%r10,1),%ymm1
 1906810:	45 0f b7 b1 60 ff ff ff 	movzwl -0xa0(%r9),%r14d
 1906818:	62 83 f5 48 3a 74 14 03 01 	vinserti64x4 $0x1,0x60(%r12,%r10,1),%zmm1,%zmm22
 1906821:	45 0f b7 61 80       	movzwl -0x80(%r9),%r12d
 1906826:	62 11 15 40 62 fe    	vpunpckldq %zmm30,%zmm29,%zmm15
 190682c:	62 01 5d 40 6a e3    	vpunpckhdq %zmm27,%zmm20,%zmm28
 1906832:	62 01 15 40 6a ee    	vpunpckhdq %zmm30,%zmm29,%zmm29
 1906838:	62 11 5d 40 62 f3    	vpunpckldq %zmm27,%zmm20,%zmm14
 190683e:	62 11 9d 40 6c d5    	vpunpcklqdq %zmm29,%zmm28,%zmm10
 1906844:	62 41 8d 48 6d f7    	vpunpckhqdq %zmm15,%zmm14,%zmm30
 190684a:	62 d2 fd 48 83 f2    	vpmultishiftqb %zmm10,%zmm0,%zmm6
 1906850:	62 92 0d 40 27 c6    	vptestmd %zmm30,%zmm30,%k0
 1906856:	62 91 7d 48 72 e6 1f 	vpsrad $0x1f,%zmm30,%zmm0
 190685d:	62 41 fd 48 6f da    	vmovdqa64 %zmm10,%zmm27
 1906863:	c1 e7 06             	shl    $0x6,%edi
 1906866:	c4 a1 7d 6f 4c 17 40 	vmovdqa 0x40(%rdi,%r10,1),%ymm1
 190686d:	41 0f b7 79 90       	movzwl -0x70(%r9),%edi
 1906872:	41 c1 e7 06          	shl    $0x6,%r15d
 1906876:	41 c1 e6 06          	shl    $0x6,%r14d
 190687a:	62 83 f5 48 3a 44 17 02 01 	vinserti64x4 $0x1,0x40(%r15,%r10,1),%zmm1,%zmm16
 1906883:	45 0f b7 79 b0       	movzwl -0x50(%r9),%r15d
 1906888:	c4 81 7d 6f 4c 16 60 	vmovdqa 0x60(%r14,%r10,1),%ymm1
 190688f:	45 0f b7 71 a0       	movzwl -0x60(%r9),%r14d
 1906894:	41 c1 e4 06          	shl    $0x6,%r12d
 1906898:	62 03 f5 48 3a 44 14 03 01 	vinserti64x4 $0x1,0x60(%r12,%r10,1),%zmm1,%zmm24
 19068a1:	45 0f b7 61 c0       	movzwl -0x40(%r9),%r12d
 19068a6:	62 32 a5 49 64 ee    	vpblendmq %zmm22,%zmm11,%zmm13{%k1}
 19068ac:	c1 e7 06             	shl    $0x6,%edi
 19068af:	c4 a1 7d 6f 4c 17 40 	vmovdqa 0x40(%rdi,%r10,1),%ymm1
 19068b6:	41 0f b7 79 d0       	movzwl -0x30(%r9),%edi
 19068bb:	41 c1 e7 06          	shl    $0x6,%r15d
 19068bf:	41 c1 e6 06          	shl    $0x6,%r14d
 19068c3:	62 83 f5 48 3a 54 17 02 01 	vinserti64x4 $0x1,0x40(%r15,%r10,1),%zmm1,%zmm18
 19068cc:	45 0f b7 79 f0       	movzwl -0x10(%r9),%r15d
 19068d1:	c4 81 7d 6f 4c 16 60 	vmovdqa 0x60(%r14,%r10,1),%ymm1
 19068d8:	45 0f b7 71 e0       	movzwl -0x20(%r9),%r14d
 19068dd:	41 c1 e4 06          	shl    $0x6,%r12d
 19068e1:	62 03 f5 48 3a 4c 14 03 01 	vinserti64x4 $0x1,0x60(%r12,%r10,1),%zmm1,%zmm25
 19068ea:	45 0f b7 21          	movzwl (%r9),%r12d
 19068ee:	49 81 c1 00 01 00 00 	add    $0x100,%r9
 19068f5:	62 82 fd 41 64 c8    	vpblendmq %zmm24,%zmm16,%zmm17{%k1}
 19068fb:	c1 e7 06             	shl    $0x6,%edi
 19068fe:	41 c1 e6 06          	shl    $0x6,%r14d
 1906902:	41 c1 e7 06          	shl    $0x6,%r15d
 1906906:	c4 a1 7d 6f 4c 17 40 	vmovdqa 0x40(%rdi,%r10,1),%ymm1
 190690d:	62 83 f5 48 3a 6c 17 02 01 	vinserti64x4 $0x1,0x40(%r15,%r10,1),%zmm1,%zmm21
 1906916:	41 c1 e4 06          	shl    $0x6,%r12d
 190691a:	c4 81 7d 6f 4c 16 60 	vmovdqa 0x60(%r14,%r10,1),%ymm1
 1906921:	62 03 f5 48 3a 54 14 03 01 	vinserti64x4 $0x1,0x60(%r12,%r10,1),%zmm1,%zmm26
 190692a:	62 b1 15 48 6a c9    	vpunpckhdq %zmm17,%zmm13,%zmm1
 1906930:	62 82 ed 41 64 d9    	vpblendmq %zmm25,%zmm18,%zmm19{%k1}
 1906936:	62 82 d5 41 64 fa    	vpblendmq %zmm26,%zmm21,%zmm23{%k1}
 190693c:	62 b1 65 40 6a d7    	vpunpckhdq %zmm23,%zmm19,%zmm2
 1906942:	62 e1 f5 48 6d e2    	vpunpckhqdq %zmm2,%zmm1,%zmm20
 1906948:	62 d1 75 48 72 d2 1a 	vpsrld $0x1a,%zmm10,%zmm1
 190694f:	62 f2 75 48 36 3d 67 bc c1 fe 	vpermd -0x13e4399(%rip),%zmm1,%zmm7        # 5225c0 <branch_sizing_patterns+0x2830>
 1906959:	62 62 75 48 36 3d 9d bc c1 fe 	vpermd -0x13e4363(%rip),%zmm1,%zmm31        # 522600 <branch_sizing_patterns+0x2870>
 1906963:	62 f2 75 48 36 25 d3 bc c1 fe 	vpermd -0x13e432d(%rip),%zmm1,%zmm4        # 522640 <branch_sizing_patterns+0x28b0>
 190696d:	62 d2 d5 48 83 ca    	vpmultishiftqb %zmm10,%zmm5,%zmm1
 1906973:	62 f2 7d 48 5a 2d c3 fa c6 fe 	vbroadcasti32x4 -0x139053d(%rip),%zmm5        # 576440 <x86_effects_unknown+0x9e0>
 190697d:	62 d2 d5 48 83 ea    	vpmultishiftqb %zmm10,%zmm5,%zmm5
 1906983:	62 f3 75 58 25 2d 6e 9c c7 fe d8 	vpternlogd $0xd8,-0x1386392(%rip){1to16},%zmm1,%zmm5        # 5805fc <tier0_emit_x87.operations+0x1b4>
 190698e:	62 d1 75 48 72 f2 04 	vpslld $0x4,%zmm10,%zmm1
 1906995:	62 f1 6d 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm2
 190699c:	62 f3 55 58 25 35 59 9c c7 fe e4 	vpternlogd $0xe4,-0x13863a7(%rip){1to16},%zmm5,%zmm6        # 580600 <tier0_emit_x87.operations+0x1b8>
 19069a7:	62 f2 7d 48 5a 2d 9f fa c6 fe 	vbroadcasti32x4 -0x1390561(%rip),%zmm5        # 576450 <x86_effects_unknown+0x9f0>
 19069b1:	62 d2 55 48 00 ea    	vpshufb %zmm10,%zmm5,%zmm5
 19069b7:	62 63 4d 48 25 ff f8 	vpternlogd $0xf8,%zmm7,%zmm6,%zmm31
 19069be:	62 f1 75 48 72 f5 10 	vpslld $0x10,%zmm5,%zmm1
 19069c5:	62 f1 6d 48 db ed    	vpandd %zmm5,%zmm2,%zmm5
 19069cb:	62 f3 5d 58 25 2d 66 9c c7 fe ec 	vpternlogd $0xec,-0x138639a(%rip){1to16},%zmm4,%zmm5        # 58063c <tier0_emit_x87.operations+0x1f4>
 19069d6:	62 f1 45 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm7
 19069dd:	62 f2 7e 48 38 c8    	vpmovm2d %k0,%zmm1
 19069e3:	62 f3 5d 50 25 2d 52 9c c7 fe f8 	vpternlogd $0xf8,-0x13863ae(%rip){1to16},%zmm20,%zmm5        # 580640 <tier0_emit_x87.operations+0x1f8>
 19069ee:	62 f3 6d 48 25 cf c8 	vpternlogd $0xc8,%zmm7,%zmm2,%zmm1
 19069f5:	62 91 7d 48 ef fe    	vpxord %zmm30,%zmm0,%zmm7
 19069fb:	62 f2 7d 48 58 05 ff 9b c7 fe 	vpbroadcastd -0x1386401(%rip),%zmm0        # 580604 <tier0_emit_x87.operations+0x1bc>
 1906a05:	62 f2 7d 48 44 ff    	vplzcntd %zmm7,%zmm7
 1906a0b:	62 f2 3d 48 45 ff    	vpsrlvd %zmm7,%zmm8,%zmm7
 1906a11:	62 51 0d 40 fe c4    	vpaddd %zmm12,%zmm30,%zmm8
 1906a17:	62 73 0d 40 25 c7 14 	vpternlogd $0x14,%zmm7,%zmm30,%zmm8
 1906a1e:	62 d1 45 48 72 d2 08 	vpsrld $0x8,%zmm10,%zmm7
 1906a25:	62 63 7d 58 25 1d e4 9b c7 fe 6c 	vpternlogd $0x6c,-0x138641c(%rip){1to16},%zmm0,%zmm27        # 580614 <tier0_emit_x87.operations+0x1cc>
 1906a30:	62 f3 7d 58 25 3d dd 9b c7 fe 6c 	vpternlogd $0x6c,-0x1386423(%rip){1to16},%zmm0,%zmm7        # 580618 <tier0_emit_x87.operations+0x1d0>
 1906a3b:	62 91 7d 48 72 ce 01 	vprold $0x1,%zmm30,%zmm0
 1906a42:	62 41 25 40 fe dc    	vpaddd %zmm12,%zmm27,%zmm27
 1906a48:	62 63 35 58 25 1d c9 9b c7 fe ec 	vpternlogd $0xec,-0x1386437(%rip){1to16},%zmm9,%zmm27        # 58061c <tier0_emit_x87.operations+0x1d4>
 1906a53:	62 d1 45 48 fe fc    	vpaddd %zmm12,%zmm7,%zmm7
 1906a59:	62 f3 25 50 25 3d c0 9b c7 fe ec 	vpternlogd $0xec,-0x1386440(%rip){1to16},%zmm27,%zmm7        # 580624 <tier0_emit_x87.operations+0x1dc>
 1906a64:	62 61 4d 58 db 1d ba 9b c7 fe 	vpandd -0x1386446(%rip){1to16},%zmm6,%zmm27        # 580628 <tier0_emit_x87.operations+0x1e0>
 1906a6e:	62 f1 4d 48 72 d6 03 	vpsrld $0x3,%zmm6,%zmm6
 1906a75:	62 f3 5d 50 25 35 b4 9b c7 fe a2 	vpternlogd $0xa2,-0x138644c(%rip){1to16},%zmm20,%zmm6        # 580634 <tier0_emit_x87.operations+0x1ec>
 1906a80:	62 f2 4d 58 3b 25 ae 9b c7 fe 	vpminud -0x1386452(%rip){1to16},%zmm6,%zmm4        # 580638 <tier0_emit_x87.operations+0x1f0>
 1906a8a:	62 63 5d 40 25 df f8 	vpternlogd $0xf8,%zmm7,%zmm20,%zmm27
 1906a91:	62 62 25 50 3b 1d 91 9b c7 fe 	vpminud -0x138646f(%rip){1to16},%zmm27,%zmm27        # 58062c <tier0_emit_x87.operations+0x1e4>
 1906a9b:	62 b1 45 48 72 d4 1d 	vpsrld $0x1d,%zmm20,%zmm7
 1906aa2:	62 72 3d 48 14 c7    	vprorvd %zmm7,%zmm8,%zmm8
 1906aa8:	62 f2 7d 48 14 ff    	vprorvd %zmm7,%zmm0,%zmm7
 1906aae:	62 f1 fd 48 6f 05 c8 ba c1 fe 	vmovdqa64 -0x13e4538(%rip),%zmm0        # 522580 <branch_sizing_patterns+0x27f0>
 1906ab8:	62 d1 3d 48 72 e0 1f 	vpsrad $0x1f,%zmm8,%zmm8
 1906abf:	62 93 75 48 25 fe e2 	vpternlogd $0xe2,%zmm30,%zmm1,%zmm7
 1906ac6:	62 93 3d 48 25 fe e2 	vpternlogd $0xe2,%zmm30,%zmm8,%zmm7
 1906acd:	62 93 5d 48 25 eb fe 	vpternlogd $0xfe,%zmm27,%zmm4,%zmm5
 1906ad4:	62 91 fd 48 6f e7    	vmovdqa64 %zmm31,%zmm4
 1906ada:	62 01 fd 48 6f df    	vmovdqa64 %zmm31,%zmm27
 1906ae0:	62 f3 6d 58 25 25 25 9b c7 fe f8 	vpternlogd $0xf8,-0x13864db(%rip){1to16},%zmm2,%zmm4        # 580610 <tier0_emit_x87.operations+0x1c8>
 1906aeb:	62 63 75 58 25 1d 16 9b c7 fe f8 	vpternlogd $0xf8,-0x13864ea(%rip){1to16},%zmm1,%zmm27        # 58060c <tier0_emit_x87.operations+0x1c4>
 1906af6:	62 f1 6d 58 db 15 48 9b c7 fe 	vpandd -0x13864b8(%rip){1to16},%zmm2,%zmm2        # 580648 <tier0_emit_x87.operations+0x200>
 1906b00:	62 32 fd 48 7e de    	vpermt2q %zmm22,%zmm0,%zmm11
 1906b06:	62 82 fd 48 7e c0    	vpermt2q %zmm24,%zmm0,%zmm16
 1906b0c:	62 82 fd 48 7e d1    	vpermt2q %zmm25,%zmm0,%zmm18
 1906b12:	62 82 fd 48 7e ea    	vpermt2q %zmm26,%zmm0,%zmm21
 1906b18:	62 91 7d 48 72 d7 10 	vpsrld $0x10,%zmm31,%zmm0
 1906b1f:	62 91 4d 40 72 d7 03 	vpsrld $0x3,%zmm31,%zmm22
 1906b26:	62 e3 7d 58 25 35 ff 9a c7 fe ec 	vpternlogd $0xec,-0x1386501(%rip){1to16},%zmm0,%zmm22        # 580630 <tier0_emit_x87.operations+0x1e8>
 1906b31:	62 f2 7d 48 5a 05 25 f9 c6 fe 	vbroadcasti32x4 -0x13906db(%rip),%zmm0        # 576460 <x86_effects_unknown+0xa00>
 1906b3b:	62 93 3d 48 25 e3 b8 	vpternlogd $0xb8,%zmm27,%zmm8,%zmm4
 1906b42:	62 61 75 58 db 1d f8 9a c7 fe 	vpandd -0x1386508(%rip){1to16},%zmm1,%zmm27        # 580644 <tier0_emit_x87.operations+0x1fc>
 1906b4c:	62 d1 4d 48 fe cc    	vpaddd %zmm12,%zmm6,%zmm1
 1906b52:	62 f1 75 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm1
 1906b59:	62 93 3d 48 25 d3 b8 	vpternlogd $0xb8,%zmm27,%zmm8,%zmm2
 1906b60:	62 51 8d 48 6c c7    	vpunpcklqdq %zmm15,%zmm14,%zmm8
 1906b66:	62 11 9d 40 6d f5    	vpunpckhqdq %zmm29,%zmm28,%zmm14
 1906b6c:	62 f1 3d 48 6a f7    	vpunpckhdq %zmm7,%zmm8,%zmm6
 1906b72:	62 51 0d 48 eb d2    	vpord  %zmm10,%zmm14,%zmm10
 1906b78:	62 71 6d 48 eb fd    	vpord  %zmm5,%zmm2,%zmm15
 1906b7e:	62 b1 6d 48 72 f6 08 	vpslld $0x8,%zmm22,%zmm2
 1906b85:	62 f3 75 58 25 15 bc 9a c7 fe 08 	vpternlogd $0x8,-0x1386544(%rip){1to16},%zmm1,%zmm2        # 58064c <tier0_emit_x87.operations+0x204>
 1906b90:	62 d1 55 48 72 f2 07 	vpslld $0x7,%zmm10,%zmm5
 1906b97:	62 f3 55 58 25 15 ae 9a c7 fe d8 	vpternlogd $0xd8,-0x1386552(%rip){1to16},%zmm5,%zmm2        # 580650 <tier0_emit_x87.operations+0x208>
 1906ba2:	62 d2 fd 48 83 ee    	vpmultishiftqb %zmm14,%zmm0,%zmm5
 1906ba8:	62 f3 4d 50 25 2d a1 9a c7 fe d8 	vpternlogd $0xd8,-0x138655f(%rip){1to16},%zmm22,%zmm5        # 580654 <tier0_emit_x87.operations+0x20c>
 1906bb3:	62 d1 7d 48 70 c7 55 	vpshufd $0x55,%zmm15,%zmm0
 1906bba:	62 b2 7d 48 8f d0    	vpshufbitqmb %zmm16,%zmm0,%k2
 1906bc0:	c4 61 fb 93 f2       	kmovq  %k2,%r14
 1906bc5:	f3 4d 0f b8 f6       	popcnt %r14,%r14
 1906bca:	62 f3 6d 58 25 2d 83 9a c7 fe d8 	vpternlogd $0xd8,-0x138657d(%rip){1to16},%zmm2,%zmm5        # 580658 <tier0_emit_x87.operations+0x210>
 1906bd5:	62 f1 3d 48 62 d7    	vpunpckldq %zmm7,%zmm8,%zmm2
 1906bdb:	62 f1 5d 48 62 fd    	vpunpckldq %zmm5,%zmm4,%zmm7
 1906be1:	62 f1 5d 48 6a e5    	vpunpckhdq %zmm5,%zmm4,%zmm4
 1906be7:	62 f1 ed 48 6c ef    	vpunpcklqdq %zmm7,%zmm2,%zmm5
 1906bed:	62 f1 ed 48 6d d7    	vpunpckhqdq %zmm7,%zmm2,%zmm2
 1906bf3:	62 f1 cd 48 6c fc    	vpunpcklqdq %zmm4,%zmm6,%zmm7
 1906bf9:	62 f1 cd 48 6d e4    	vpunpckhqdq %zmm4,%zmm6,%zmm4
 1906bff:	62 d1 7d 48 70 f7 00 	vpshufd $0x0,%zmm15,%zmm6
 1906c06:	62 d2 55 48 00 eb    	vpshufb %zmm11,%zmm5,%zmm5
 1906c0c:	62 d2 4d 48 8f db    	vpshufbitqmb %zmm11,%zmm6,%k3
 1906c12:	62 b2 6d 48 00 d0    	vpshufb %zmm16,%zmm2,%zmm2
 1906c18:	62 b2 45 48 00 c2    	vpshufb %zmm18,%zmm7,%zmm0
 1906c1e:	62 f3 95 48 25 eb 78 	vpternlogq $0x78,%zmm3,%zmm13,%zmm5
 1906c25:	62 f3 f5 40 25 d3 78 	vpternlogq $0x78,%zmm3,%zmm17,%zmm2
 1906c2c:	62 f3 e5 40 25 c3 78 	vpternlogq $0x78,%zmm3,%zmm19,%zmm0
 1906c33:	62 f2 7d cb 63 ed    	vpcompressb %zmm5,%zmm5{%k3}{z}
 1906c39:	62 f2 7d ca 63 d2    	vpcompressb %zmm2,%zmm2{%k2}{z}
 1906c3f:	c4 e1 fb 93 fb       	kmovq  %k3,%rdi
 1906c44:	f3 48 0f b8 ff       	popcnt %rdi,%rdi
 1906c49:	62 d1 fe 48 7f 2b    	vmovdqu64 %zmm5,(%r11)
 1906c4f:	62 d1 7d 48 70 ef aa 	vpshufd $0xaa,%zmm15,%zmm5
 1906c56:	62 d1 fe 48 7f 14 3b 	vmovdqu64 %zmm2,(%r11,%rdi,1)
 1906c5d:	4c 01 df             	add    %r11,%rdi
 1906c60:	41 29 db             	sub    %ebx,%r11d
 1906c63:	62 b2 55 48 8f da    	vpshufbitqmb %zmm18,%zmm5,%k3
 1906c69:	62 d1 7d 48 70 ef ff 	vpshufd $0xff,%zmm15,%zmm5
 1906c70:	62 73 5d 50 25 3d e1 99 c7 fe 20 	vpternlogd $0x20,-0x138661f(%rip){1to16},%zmm20,%zmm15        # 58065c <tier0_emit_x87.operations+0x214>
 1906c7b:	62 b2 55 48 8f d5    	vpshufbitqmb %zmm21,%zmm5,%k2
 1906c81:	c5 e9 ef d2          	vpxor  %xmm2,%xmm2,%xmm2
 1906c85:	62 f2 7d cb 63 c2    	vpcompressb %zmm0,%zmm2{%k3}{z}
 1906c8b:	62 b2 5d 48 00 c5    	vpshufb %zmm21,%zmm4,%zmm0
 1906c91:	62 f1 5d 50 db 25 c5 99 c7 fe 	vpandd -0x138663b(%rip){1to16},%zmm20,%zmm4        # 580660 <tier0_emit_x87.operations+0x218>
 1906c9b:	62 f3 c5 40 25 c3 78 	vpternlogq $0x78,%zmm3,%zmm23,%zmm0
 1906ca2:	62 d1 fe 48 7f 14 3e 	vmovdqu64 %zmm2,(%r14,%rdi,1)
 1906ca9:	c5 e9 ef d2          	vpxor  %xmm2,%xmm2,%xmm2
 1906cad:	62 f2 7d ca 63 c2    	vpcompressb %zmm0,%zmm2{%k2}{z}
 1906cb3:	62 d2 7d 48 55 c7    	vpopcntd %zmm15,%zmm0
 1906cb9:	49 01 fe             	add    %rdi,%r14
 1906cbc:	c4 e1 fb 93 fb       	kmovq  %k3,%rdi
 1906cc1:	f3 4c 0f b8 ff       	popcnt %rdi,%r15
 1906cc6:	c4 e1 fb 93 fa       	kmovq  %k2,%rdi
 1906ccb:	f3 48 0f b8 ff       	popcnt %rdi,%rdi
 1906cd0:	62 f1 75 48 fe cc    	vpaddd %zmm4,%zmm1,%zmm1
 1906cd6:	4c 01 ff             	add    %r15,%rdi
 1906cd9:	62 f1 75 48 fe c8    	vpaddd %zmm0,%zmm1,%zmm1
 1906cdf:	c5 f9 6f 05 09 f7 c6 fe 	vmovdqa -0x13908f7(%rip),%xmm0        # 5763f0 <x86_effects_unknown+0x990>
 1906ce7:	4c 01 f7             	add    %r14,%rdi
 1906cea:	62 91 fe 48 7f 14 37 	vmovdqu64 %zmm2,(%r15,%r14,1)
 1906cf1:	44 89 5c 24 40       	mov    %r11d,0x40(%rsp)
 1906cf6:	62 f2 7d 48 8d c9    	vpermb %zmm1,%zmm0,%zmm1
 1906cfc:	c5 f9 6f 05 fc f6 c6 fe 	vmovdqa -0x1390904(%rip),%xmm0        # 576400 <x86_effects_unknown+0x9a0>
 1906d04:	62 f2 f5 18 40 0d 32 97 c7 fe 	vpmullq -0x13868ce(%rip){1to2},%xmm1,%xmm1        # 580440 <x86_semantics_benchmark_code.registers+0x450>
 1906d0e:	62 d2 7d 48 8d d6    	vpermb %zmm14,%zmm0,%zmm2
 1906d14:	c4 e2 71 00 05 f3 f6 c6 fe 	vpshufb -0x139090d(%rip),%xmm1,%xmm0        # 576410 <x86_effects_unknown+0x9b0>
 1906d1d:	62 f2 7e 48 29 da    	vpmovb2m %zmm2,%k3
 1906d23:	c5 7b 93 db          	kmovd  %k3,%r11d
 1906d27:	45 0f b7 db          	movzwl %r11w,%r11d
 1906d2b:	c5 f9 fc c9          	vpaddb %xmm1,%xmm0,%xmm1
 1906d2f:	f3 45 0f b8 db       	popcnt %r11d,%r11d
 1906d34:	49 ff c8             	dec    %r8
 1906d37:	62 f2 7d 48 31 c9    	vpmovzxbd %xmm1,%zmm1
 1906d3d:	62 f1 75 58 fe 4c 24 10 	vpaddd 0x40(%rsp){1to16},%zmm1,%zmm1
 1906d45:	62 f2 7d cb 8b c9    	vpcompressd %zmm1,%zmm1{%k3}{z}
 1906d4b:	62 f1 fe 48 7f 09    	vmovdqu64 %zmm1,(%rcx)
 1906d51:	4a 8d 0c 99          	lea    (%rcx,%r11,4),%rcx
 1906d55:	49 89 fb             	mov    %rdi,%r11
 1906d58:	0f 85 12 fa ff ff    	jne    1906770 <x86_encode_16+0xa0>
 1906d5e:	4c 8d 40 10          	lea    0x10(%rax),%r8
 1906d62:	49 39 d0             	cmp    %rdx,%r8
 1906d65:	76 08                	jbe    1906d6f <x86_encode_16+0x69f>
 1906d67:	49 89 fe             	mov    %rdi,%r14
 1906d6a:	e9 3f 06 00 00       	jmp    19073ae <x86_encode_16+0xcde>
 1906d6f:	62 f2 7d 48 5a 1d 67 f6 c6 fe 	vbroadcasti32x4 -0x1390999(%rip),%zmm3        # 5763e0 <x86_effects_unknown+0x980>
 1906d79:	62 72 7d 48 58 0d 9d 98 c7 fe 	vpbroadcastd -0x1386763(%rip),%zmm9        # 580620 <tier0_emit_x87.operations+0x1d8>
 1906d83:	49 89 d0             	mov    %rdx,%r8
 1906d86:	49 29 c0             	sub    %rax,%r8
 1906d89:	49 89 c1             	mov    %rax,%r9
 1906d8c:	49 c1 e1 04          	shl    $0x4,%r9
 1906d90:	41 b3 cc             	mov    $0xcc,%r11b
 1906d93:	4c 8d 15 e6 f5 d5 0c 	lea    0xcd5f5e6(%rip),%r10        # e666380 <x86_template_storage>
 1906d9a:	62 53 1d 48 25 e4 ff 	vpternlogd $0xff,%zmm12,%zmm12,%zmm12
 1906da1:	49 83 c0 f0          	add    $0xfffffffffffffff0,%r8
 1906da5:	4d 8d 8c 31 fc 00 00 00 	lea    0xfc(%r9,%rsi,1),%r9
 1906dad:	c4 c1 7b 92 cb       	kmovd  %r11d,%k1
 1906db2:	49 c1 e8 04          	shr    $0x4,%r8
 1906db6:	49 ff c0             	inc    %r8
 1906db9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
 1906dc0:	45 0f b7 99 10 ff ff ff 	movzwl -0xf0(%r9),%r11d
 1906dc8:	45 0f b7 b1 20 ff ff ff 	movzwl -0xe0(%r9),%r14d
 1906dd0:	45 0f b7 b9 30 ff ff ff 	movzwl -0xd0(%r9),%r15d
 1906dd8:	45 0f b7 a1 40 ff ff ff 	movzwl -0xc0(%r9),%r12d
 1906de0:	62 c1 fe 48 6f a1 04 ff ff ff 	vmovdqu64 -0xfc(%r9),%zmm20
 1906dea:	62 41 fe 48 6f 99 44 ff ff ff 	vmovdqu64 -0xbc(%r9),%zmm27
 1906df4:	62 41 fe 48 6f a9 84 ff ff ff 	vmovdqu64 -0x7c(%r9),%zmm29
 1906dfe:	62 41 fe 48 6f b1 c4 ff ff ff 	vmovdqu64 -0x3c(%r9),%zmm30
 1906e08:	62 f2 7d 48 5a 2d 0e f6 c6 fe 	vbroadcasti32x4 -0x13909f2(%rip),%zmm5        # 576420 <x86_effects_unknown+0x9c0>
 1906e12:	62 f2 7d 48 5a 05 14 f6 c6 fe 	vbroadcasti32x4 -0x13909ec(%rip),%zmm0        # 576430 <x86_effects_unknown+0x9d0>
 1906e1c:	62 72 7d 48 58 05 e2 97 c7 fe 	vpbroadcastd -0x138681e(%rip),%zmm8        # 580608 <tier0_emit_x87.operations+0x1c0>
 1906e26:	48 83 c0 10          	add    $0x10,%rax
 1906e2a:	41 c1 e3 06          	shl    $0x6,%r11d
 1906e2e:	41 c1 e6 06          	shl    $0x6,%r14d
 1906e32:	41 c1 e7 06          	shl    $0x6,%r15d
 1906e36:	41 c1 e4 06          	shl    $0x6,%r12d
 1906e3a:	c4 81 7d 6f 4c 13 40 	vmovdqa 0x40(%r11,%r10,1),%ymm1
 1906e41:	45 0f b7 99 50 ff ff ff 	movzwl -0xb0(%r9),%r11d
 1906e49:	62 13 f5 48 3a 5c 17 02 01 	vinserti64x4 $0x1,0x40(%r15,%r10,1),%zmm1,%zmm11
 1906e52:	45 0f b7 b9 70 ff ff ff 	movzwl -0x90(%r9),%r15d
 1906e5a:	c4 81 7d 6f 4c 16 60 	vmovdqa 0x60(%r14,%r10,1),%ymm1
 1906e61:	45 0f b7 b1 60 ff ff ff 	movzwl -0xa0(%r9),%r14d
 1906e69:	62 83 f5 48 3a 74 14 03 01 	vinserti64x4 $0x1,0x60(%r12,%r10,1),%zmm1,%zmm22
 1906e72:	45 0f b7 61 80       	movzwl -0x80(%r9),%r12d
 1906e77:	62 11 15 40 62 fe    	vpunpckldq %zmm30,%zmm29,%zmm15
 1906e7d:	62 01 5d 40 6a e3    	vpunpckhdq %zmm27,%zmm20,%zmm28
 1906e83:	62 01 15 40 6a ee    	vpunpckhdq %zmm30,%zmm29,%zmm29
 1906e89:	62 11 5d 40 62 f3    	vpunpckldq %zmm27,%zmm20,%zmm14
 1906e8f:	62 11 9d 40 6c d5    	vpunpcklqdq %zmm29,%zmm28,%zmm10
 1906e95:	62 41 8d 48 6d f7    	vpunpckhqdq %zmm15,%zmm14,%zmm30
 1906e9b:	62 d2 fd 48 83 f2    	vpmultishiftqb %zmm10,%zmm0,%zmm6
 1906ea1:	62 92 0d 40 27 c6    	vptestmd %zmm30,%zmm30,%k0
 1906ea7:	62 91 7d 48 72 e6 1f 	vpsrad $0x1f,%zmm30,%zmm0
 1906eae:	62 41 fd 48 6f da    	vmovdqa64 %zmm10,%zmm27
 1906eb4:	41 c1 e3 06          	shl    $0x6,%r11d
 1906eb8:	c4 81 7d 6f 4c 13 40 	vmovdqa 0x40(%r11,%r10,1),%ymm1
 1906ebf:	45 0f b7 59 90       	movzwl -0x70(%r9),%r11d
 1906ec4:	41 c1 e7 06          	shl    $0x6,%r15d
 1906ec8:	41 c1 e6 06          	shl    $0x6,%r14d
 1906ecc:	62 83 f5 48 3a 44 17 02 01 	vinserti64x4 $0x1,0x40(%r15,%r10,1),%zmm1,%zmm16
 1906ed5:	45 0f b7 79 b0       	movzwl -0x50(%r9),%r15d
 1906eda:	c4 81 7d 6f 4c 16 60 	vmovdqa 0x60(%r14,%r10,1),%ymm1
 1906ee1:	45 0f b7 71 a0       	movzwl -0x60(%r9),%r14d
 1906ee6:	41 c1 e4 06          	shl    $0x6,%r12d
 1906eea:	62 03 f5 48 3a 44 14 03 01 	vinserti64x4 $0x1,0x60(%r12,%r10,1),%zmm1,%zmm24
 1906ef3:	45 0f b7 61 c0       	movzwl -0x40(%r9),%r12d
 1906ef8:	62 32 a5 49 64 ee    	vpblendmq %zmm22,%zmm11,%zmm13{%k1}
 1906efe:	41 c1 e3 06          	shl    $0x6,%r11d
 1906f02:	c4 81 7d 6f 4c 13 40 	vmovdqa 0x40(%r11,%r10,1),%ymm1
 1906f09:	45 0f b7 59 d0       	movzwl -0x30(%r9),%r11d
 1906f0e:	41 c1 e7 06          	shl    $0x6,%r15d
 1906f12:	41 c1 e6 06          	shl    $0x6,%r14d
 1906f16:	62 83 f5 48 3a 54 17 02 01 	vinserti64x4 $0x1,0x40(%r15,%r10,1),%zmm1,%zmm18
 1906f1f:	45 0f b7 79 f0       	movzwl -0x10(%r9),%r15d
 1906f24:	c4 81 7d 6f 4c 16 60 	vmovdqa 0x60(%r14,%r10,1),%ymm1
 1906f2b:	45 0f b7 71 e0       	movzwl -0x20(%r9),%r14d
 1906f30:	41 c1 e4 06          	shl    $0x6,%r12d
 1906f34:	62 03 f5 48 3a 4c 14 03 01 	vinserti64x4 $0x1,0x60(%r12,%r10,1),%zmm1,%zmm25
 1906f3d:	45 0f b7 21          	movzwl (%r9),%r12d
 1906f41:	49 81 c1 00 01 00 00 	add    $0x100,%r9
 1906f48:	62 82 fd 41 64 c8    	vpblendmq %zmm24,%zmm16,%zmm17{%k1}
 1906f4e:	41 c1 e3 06          	shl    $0x6,%r11d
 1906f52:	41 c1 e6 06          	shl    $0x6,%r14d
 1906f56:	41 c1 e7 06          	shl    $0x6,%r15d
 1906f5a:	c4 81 7d 6f 4c 13 40 	vmovdqa 0x40(%r11,%r10,1),%ymm1
 1906f61:	62 83 f5 48 3a 6c 17 02 01 	vinserti64x4 $0x1,0x40(%r15,%r10,1),%zmm1,%zmm21
 1906f6a:	41 c1 e4 06          	shl    $0x6,%r12d
 1906f6e:	c4 81 7d 6f 4c 16 60 	vmovdqa 0x60(%r14,%r10,1),%ymm1
 1906f75:	62 03 f5 48 3a 54 14 03 01 	vinserti64x4 $0x1,0x60(%r12,%r10,1),%zmm1,%zmm26
 1906f7e:	62 b1 15 48 6a c9    	vpunpckhdq %zmm17,%zmm13,%zmm1
 1906f84:	62 82 ed 41 64 d9    	vpblendmq %zmm25,%zmm18,%zmm19{%k1}
 1906f8a:	62 82 d5 41 64 fa    	vpblendmq %zmm26,%zmm21,%zmm23{%k1}
 1906f90:	62 b1 65 40 6a d7    	vpunpckhdq %zmm23,%zmm19,%zmm2
 1906f96:	62 e1 f5 48 6d e2    	vpunpckhqdq %zmm2,%zmm1,%zmm20
 1906f9c:	62 d1 75 48 72 d2 1a 	vpsrld $0x1a,%zmm10,%zmm1
 1906fa3:	62 f2 75 48 36 3d 13 b6 c1 fe 	vpermd -0x13e49ed(%rip),%zmm1,%zmm7        # 5225c0 <branch_sizing_patterns+0x2830>
 1906fad:	62 62 75 48 36 3d 49 b6 c1 fe 	vpermd -0x13e49b7(%rip),%zmm1,%zmm31        # 522600 <branch_sizing_patterns+0x2870>
 1906fb7:	62 f2 75 48 36 25 7f b6 c1 fe 	vpermd -0x13e4981(%rip),%zmm1,%zmm4        # 522640 <branch_sizing_patterns+0x28b0>
 1906fc1:	62 d2 d5 48 83 ca    	vpmultishiftqb %zmm10,%zmm5,%zmm1
 1906fc7:	62 f2 7d 48 5a 2d 6f f4 c6 fe 	vbroadcasti32x4 -0x1390b91(%rip),%zmm5        # 576440 <x86_effects_unknown+0x9e0>
 1906fd1:	62 d2 d5 48 83 ea    	vpmultishiftqb %zmm10,%zmm5,%zmm5
 1906fd7:	62 f3 75 58 25 2d 1a 96 c7 fe d8 	vpternlogd $0xd8,-0x13869e6(%rip){1to16},%zmm1,%zmm5        # 5805fc <tier0_emit_x87.operations+0x1b4>
 1906fe2:	62 d1 75 48 72 f2 04 	vpslld $0x4,%zmm10,%zmm1
 1906fe9:	62 f1 6d 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm2
 1906ff0:	62 f3 55 58 25 35 05 96 c7 fe e4 	vpternlogd $0xe4,-0x13869fb(%rip){1to16},%zmm5,%zmm6        # 580600 <tier0_emit_x87.operations+0x1b8>
 1906ffb:	62 f2 7d 48 5a 2d 4b f4 c6 fe 	vbroadcasti32x4 -0x1390bb5(%rip),%zmm5        # 576450 <x86_effects_unknown+0x9f0>
 1907005:	62 d2 55 48 00 ea    	vpshufb %zmm10,%zmm5,%zmm5
 190700b:	62 63 4d 48 25 ff f8 	vpternlogd $0xf8,%zmm7,%zmm6,%zmm31
 1907012:	62 f1 75 48 72 f5 10 	vpslld $0x10,%zmm5,%zmm1
 1907019:	62 f1 6d 48 db ed    	vpandd %zmm5,%zmm2,%zmm5
 190701f:	62 f3 5d 58 25 2d 12 96 c7 fe ec 	vpternlogd $0xec,-0x13869ee(%rip){1to16},%zmm4,%zmm5        # 58063c <tier0_emit_x87.operations+0x1f4>
 190702a:	62 f1 45 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm7
 1907031:	62 f2 7e 48 38 c8    	vpmovm2d %k0,%zmm1
 1907037:	62 f3 5d 50 25 2d fe 95 c7 fe f8 	vpternlogd $0xf8,-0x1386a02(%rip){1to16},%zmm20,%zmm5        # 580640 <tier0_emit_x87.operations+0x1f8>
 1907042:	62 f3 6d 48 25 cf c8 	vpternlogd $0xc8,%zmm7,%zmm2,%zmm1
 1907049:	62 91 7d 48 ef fe    	vpxord %zmm30,%zmm0,%zmm7
 190704f:	62 f2 7d 48 58 05 ab 95 c7 fe 	vpbroadcastd -0x1386a55(%rip),%zmm0        # 580604 <tier0_emit_x87.operations+0x1bc>
 1907059:	62 f2 7d 48 44 ff    	vplzcntd %zmm7,%zmm7
 190705f:	62 f2 3d 48 45 ff    	vpsrlvd %zmm7,%zmm8,%zmm7
 1907065:	62 51 0d 40 fe c4    	vpaddd %zmm12,%zmm30,%zmm8
 190706b:	62 73 0d 40 25 c7 14 	vpternlogd $0x14,%zmm7,%zmm30,%zmm8
 1907072:	62 d1 45 48 72 d2 08 	vpsrld $0x8,%zmm10,%zmm7
 1907079:	62 63 7d 58 25 1d 90 95 c7 fe 6c 	vpternlogd $0x6c,-0x1386a70(%rip){1to16},%zmm0,%zmm27        # 580614 <tier0_emit_x87.operations+0x1cc>
 1907084:	62 f3 7d 58 25 3d 89 95 c7 fe 6c 	vpternlogd $0x6c,-0x1386a77(%rip){1to16},%zmm0,%zmm7        # 580618 <tier0_emit_x87.operations+0x1d0>
 190708f:	62 91 7d 48 72 ce 01 	vprold $0x1,%zmm30,%zmm0
 1907096:	62 41 25 40 fe dc    	vpaddd %zmm12,%zmm27,%zmm27
 190709c:	62 63 35 58 25 1d 75 95 c7 fe ec 	vpternlogd $0xec,-0x1386a8b(%rip){1to16},%zmm9,%zmm27        # 58061c <tier0_emit_x87.operations+0x1d4>
 19070a7:	62 d1 45 48 fe fc    	vpaddd %zmm12,%zmm7,%zmm7
 19070ad:	62 f3 25 50 25 3d 6c 95 c7 fe ec 	vpternlogd $0xec,-0x1386a94(%rip){1to16},%zmm27,%zmm7        # 580624 <tier0_emit_x87.operations+0x1dc>
 19070b8:	62 61 4d 58 db 1d 66 95 c7 fe 	vpandd -0x1386a9a(%rip){1to16},%zmm6,%zmm27        # 580628 <tier0_emit_x87.operations+0x1e0>
 19070c2:	62 f1 4d 48 72 d6 03 	vpsrld $0x3,%zmm6,%zmm6
 19070c9:	62 f3 5d 50 25 35 60 95 c7 fe a2 	vpternlogd $0xa2,-0x1386aa0(%rip){1to16},%zmm20,%zmm6        # 580634 <tier0_emit_x87.operations+0x1ec>
 19070d4:	62 f2 4d 58 3b 25 5a 95 c7 fe 	vpminud -0x1386aa6(%rip){1to16},%zmm6,%zmm4        # 580638 <tier0_emit_x87.operations+0x1f0>
 19070de:	62 63 5d 40 25 df f8 	vpternlogd $0xf8,%zmm7,%zmm20,%zmm27
 19070e5:	62 62 25 50 3b 1d 3d 95 c7 fe 	vpminud -0x1386ac3(%rip){1to16},%zmm27,%zmm27        # 58062c <tier0_emit_x87.operations+0x1e4>
 19070ef:	62 b1 45 48 72 d4 1d 	vpsrld $0x1d,%zmm20,%zmm7
 19070f6:	62 72 3d 48 14 c7    	vprorvd %zmm7,%zmm8,%zmm8
 19070fc:	62 f2 7d 48 14 ff    	vprorvd %zmm7,%zmm0,%zmm7
 1907102:	62 f1 fd 48 6f 05 74 b4 c1 fe 	vmovdqa64 -0x13e4b8c(%rip),%zmm0        # 522580 <branch_sizing_patterns+0x27f0>
 190710c:	62 d1 3d 48 72 e0 1f 	vpsrad $0x1f,%zmm8,%zmm8
 1907113:	62 93 75 48 25 fe e2 	vpternlogd $0xe2,%zmm30,%zmm1,%zmm7
 190711a:	62 93 3d 48 25 fe e2 	vpternlogd $0xe2,%zmm30,%zmm8,%zmm7
 1907121:	62 93 5d 48 25 eb fe 	vpternlogd $0xfe,%zmm27,%zmm4,%zmm5
 1907128:	62 91 fd 48 6f e7    	vmovdqa64 %zmm31,%zmm4
 190712e:	62 01 fd 48 6f df    	vmovdqa64 %zmm31,%zmm27
 1907134:	62 f3 6d 58 25 25 d1 94 c7 fe f8 	vpternlogd $0xf8,-0x1386b2f(%rip){1to16},%zmm2,%zmm4        # 580610 <tier0_emit_x87.operations+0x1c8>
 190713f:	62 63 75 58 25 1d c2 94 c7 fe f8 	vpternlogd $0xf8,-0x1386b3e(%rip){1to16},%zmm1,%zmm27        # 58060c <tier0_emit_x87.operations+0x1c4>
 190714a:	62 f1 6d 58 db 15 f4 94 c7 fe 	vpandd -0x1386b0c(%rip){1to16},%zmm2,%zmm2        # 580648 <tier0_emit_x87.operations+0x200>
 1907154:	62 32 fd 48 7e de    	vpermt2q %zmm22,%zmm0,%zmm11
 190715a:	62 82 fd 48 7e c0    	vpermt2q %zmm24,%zmm0,%zmm16
 1907160:	62 82 fd 48 7e d1    	vpermt2q %zmm25,%zmm0,%zmm18
 1907166:	62 82 fd 48 7e ea    	vpermt2q %zmm26,%zmm0,%zmm21
 190716c:	62 91 7d 48 72 d7 10 	vpsrld $0x10,%zmm31,%zmm0
 1907173:	62 91 4d 40 72 d7 03 	vpsrld $0x3,%zmm31,%zmm22
 190717a:	62 e3 7d 58 25 35 ab 94 c7 fe ec 	vpternlogd $0xec,-0x1386b55(%rip){1to16},%zmm0,%zmm22        # 580630 <tier0_emit_x87.operations+0x1e8>
 1907185:	62 f2 7d 48 5a 05 d1 f2 c6 fe 	vbroadcasti32x4 -0x1390d2f(%rip),%zmm0        # 576460 <x86_effects_unknown+0xa00>
 190718f:	62 93 3d 48 25 e3 b8 	vpternlogd $0xb8,%zmm27,%zmm8,%zmm4
 1907196:	62 61 75 58 db 1d a4 94 c7 fe 	vpandd -0x1386b5c(%rip){1to16},%zmm1,%zmm27        # 580644 <tier0_emit_x87.operations+0x1fc>
 19071a0:	62 d1 4d 48 fe cc    	vpaddd %zmm12,%zmm6,%zmm1
 19071a6:	62 f1 75 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm1
 19071ad:	62 93 3d 48 25 d3 b8 	vpternlogd $0xb8,%zmm27,%zmm8,%zmm2
 19071b4:	62 51 8d 48 6c c7    	vpunpcklqdq %zmm15,%zmm14,%zmm8
 19071ba:	62 11 9d 40 6d f5    	vpunpckhqdq %zmm29,%zmm28,%zmm14
 19071c0:	62 f1 3d 48 6a f7    	vpunpckhdq %zmm7,%zmm8,%zmm6
 19071c6:	62 51 0d 48 eb d2    	vpord  %zmm10,%zmm14,%zmm10
 19071cc:	62 71 6d 48 eb fd    	vpord  %zmm5,%zmm2,%zmm15
 19071d2:	62 b1 6d 48 72 f6 08 	vpslld $0x8,%zmm22,%zmm2
 19071d9:	62 f3 75 58 25 15 68 94 c7 fe 08 	vpternlogd $0x8,-0x1386b98(%rip){1to16},%zmm1,%zmm2        # 58064c <tier0_emit_x87.operations+0x204>
 19071e4:	62 d1 55 48 72 f2 07 	vpslld $0x7,%zmm10,%zmm5
 19071eb:	62 f3 55 58 25 15 5a 94 c7 fe d8 	vpternlogd $0xd8,-0x1386ba6(%rip){1to16},%zmm5,%zmm2        # 580650 <tier0_emit_x87.operations+0x208>
 19071f6:	62 d2 fd 48 83 ee    	vpmultishiftqb %zmm14,%zmm0,%zmm5
 19071fc:	62 f3 4d 50 25 2d 4d 94 c7 fe d8 	vpternlogd $0xd8,-0x1386bb3(%rip){1to16},%zmm22,%zmm5        # 580654 <tier0_emit_x87.operations+0x20c>
 1907207:	62 d1 7d 48 70 c7 55 	vpshufd $0x55,%zmm15,%zmm0
 190720e:	62 b2 7d 48 8f d0    	vpshufbitqmb %zmm16,%zmm0,%k2
 1907214:	c4 61 fb 93 f2       	kmovq  %k2,%r14
 1907219:	f3 4d 0f b8 f6       	popcnt %r14,%r14
 190721e:	62 f3 6d 58 25 2d 2f 94 c7 fe d8 	vpternlogd $0xd8,-0x1386bd1(%rip){1to16},%zmm2,%zmm5        # 580658 <tier0_emit_x87.operations+0x210>
 1907229:	62 f1 3d 48 62 d7    	vpunpckldq %zmm7,%zmm8,%zmm2
 190722f:	62 f1 5d 48 62 fd    	vpunpckldq %zmm5,%zmm4,%zmm7
 1907235:	62 f1 5d 48 6a e5    	vpunpckhdq %zmm5,%zmm4,%zmm4
 190723b:	62 f1 ed 48 6c ef    	vpunpcklqdq %zmm7,%zmm2,%zmm5
 1907241:	62 f1 ed 48 6d d7    	vpunpckhqdq %zmm7,%zmm2,%zmm2
 1907247:	62 f1 cd 48 6c fc    	vpunpcklqdq %zmm4,%zmm6,%zmm7
 190724d:	62 f1 cd 48 6d e4    	vpunpckhqdq %zmm4,%zmm6,%zmm4
 1907253:	62 d1 7d 48 70 f7 00 	vpshufd $0x0,%zmm15,%zmm6
 190725a:	62 d2 55 48 00 eb    	vpshufb %zmm11,%zmm5,%zmm5
 1907260:	62 d2 4d 48 8f db    	vpshufbitqmb %zmm11,%zmm6,%k3
 1907266:	62 b2 6d 48 00 d0    	vpshufb %zmm16,%zmm2,%zmm2
 190726c:	62 b2 45 48 00 c2    	vpshufb %zmm18,%zmm7,%zmm0
 1907272:	62 f3 95 48 25 eb 78 	vpternlogq $0x78,%zmm3,%zmm13,%zmm5
 1907279:	62 f3 f5 40 25 d3 78 	vpternlogq $0x78,%zmm3,%zmm17,%zmm2
 1907280:	62 f3 e5 40 25 c3 78 	vpternlogq $0x78,%zmm3,%zmm19,%zmm0
 1907287:	62 f2 7d cb 63 ed    	vpcompressb %zmm5,%zmm5{%k3}{z}
 190728d:	62 f2 7d ca 63 d2    	vpcompressb %zmm2,%zmm2{%k2}{z}
 1907293:	c4 61 fb 93 db       	kmovq  %k3,%r11
 1907298:	f3 4d 0f b8 db       	popcnt %r11,%r11
 190729d:	62 f1 fe 48 7f 2f    	vmovdqu64 %zmm5,(%rdi)
 19072a3:	62 d1 7d 48 70 ef aa 	vpshufd $0xaa,%zmm15,%zmm5
 19072aa:	62 b1 fe 48 7f 14 1f 	vmovdqu64 %zmm2,(%rdi,%r11,1)
 19072b1:	49 01 fb             	add    %rdi,%r11
 19072b4:	29 df                	sub    %ebx,%edi
 19072b6:	62 b2 55 48 8f da    	vpshufbitqmb %zmm18,%zmm5,%k3
 19072bc:	62 d1 7d 48 70 ef ff 	vpshufd $0xff,%zmm15,%zmm5
 19072c3:	62 73 5d 50 25 3d 8e 93 c7 fe 20 	vpternlogd $0x20,-0x1386c72(%rip){1to16},%zmm20,%zmm15        # 58065c <tier0_emit_x87.operations+0x214>
 19072ce:	62 b2 55 48 8f d5    	vpshufbitqmb %zmm21,%zmm5,%k2
 19072d4:	c5 e9 ef d2          	vpxor  %xmm2,%xmm2,%xmm2
 19072d8:	62 f2 7d cb 63 c2    	vpcompressb %zmm0,%zmm2{%k3}{z}
 19072de:	62 b2 5d 48 00 c5    	vpshufb %zmm21,%zmm4,%zmm0
 19072e4:	62 f1 5d 50 db 25 72 93 c7 fe 	vpandd -0x1386c8e(%rip){1to16},%zmm20,%zmm4        # 580660 <tier0_emit_x87.operations+0x218>
 19072ee:	62 f3 c5 40 25 c3 78 	vpternlogq $0x78,%zmm3,%zmm23,%zmm0
 19072f5:	62 91 fe 48 7f 14 1e 	vmovdqu64 %zmm2,(%r14,%r11,1)
 19072fc:	c5 e9 ef d2          	vpxor  %xmm2,%xmm2,%xmm2
 1907300:	62 f2 7d ca 63 c2    	vpcompressb %zmm0,%zmm2{%k2}{z}
 1907306:	62 d2 7d 48 55 c7    	vpopcntd %zmm15,%zmm0
 190730c:	4d 01 f3             	add    %r14,%r11
 190730f:	c4 61 fb 93 f3       	kmovq  %k3,%r14
 1907314:	f3 4d 0f b8 fe       	popcnt %r14,%r15
 1907319:	62 f1 75 48 fe cc    	vpaddd %zmm4,%zmm1,%zmm1
 190731f:	62 f1 75 48 fe c8    	vpaddd %zmm0,%zmm1,%zmm1
 1907325:	c5 f9 6f 05 c3 f0 c6 fe 	vmovdqa -0x1390f3d(%rip),%xmm0        # 5763f0 <x86_effects_unknown+0x990>
 190732d:	62 91 fe 48 7f 14 1f 	vmovdqu64 %zmm2,(%r15,%r11,1)
 1907334:	89 7c 24 40          	mov    %edi,0x40(%rsp)
 1907338:	c4 e1 fb 93 fa       	kmovq  %k2,%rdi
 190733d:	f3 4c 0f b8 f7       	popcnt %rdi,%r14
 1907342:	4d 01 fe             	add    %r15,%r14
 1907345:	4d 01 de             	add    %r11,%r14
 1907348:	62 f2 7d 48 8d c9    	vpermb %zmm1,%zmm0,%zmm1
 190734e:	c5 f9 6f 05 aa f0 c6 fe 	vmovdqa -0x1390f56(%rip),%xmm0        # 576400 <x86_effects_unknown+0x9a0>
 1907356:	62 f2 f5 18 40 0d e0 90 c7 fe 	vpmullq -0x1386f20(%rip){1to2},%xmm1,%xmm1        # 580440 <x86_semantics_benchmark_code.registers+0x450>
 1907360:	62 d2 7d 48 8d d6    	vpermb %zmm14,%zmm0,%zmm2
 1907366:	c4 e2 71 00 05 a1 f0 c6 fe 	vpshufb -0x1390f5f(%rip),%xmm1,%xmm0        # 576410 <x86_effects_unknown+0x9b0>
 190736f:	62 f2 7e 48 29 da    	vpmovb2m %zmm2,%k3
 1907375:	c5 fb 93 fb          	kmovd  %k3,%edi
 1907379:	0f b7 ff             	movzwl %di,%edi
 190737c:	c5 f9 fc c9          	vpaddb %xmm1,%xmm0,%xmm1
 1907380:	f3 0f b8 ff          	popcnt %edi,%edi
 1907384:	49 ff c8             	dec    %r8
 1907387:	62 f2 7d 48 31 c9    	vpmovzxbd %xmm1,%zmm1
 190738d:	62 f1 75 58 fe 4c 24 10 	vpaddd 0x40(%rsp){1to16},%zmm1,%zmm1
 1907395:	62 f2 7d cb 8b c9    	vpcompressd %zmm1,%zmm1{%k3}{z}
 190739b:	62 f1 fe 48 7f 09    	vmovdqu64 %zmm1,(%rcx)
 19073a1:	48 8d 0c b9          	lea    (%rcx,%rdi,4),%rcx
 19073a5:	4c 89 f7             	mov    %r14,%rdi
 19073a8:	0f 85 12 fa ff ff    	jne    1906dc0 <x86_encode_16+0x6f0>
 19073ae:	48 29 c2             	sub    %rax,%rdx
 19073b1:	0f 86 b1 17 00 00    	jbe    1908b68 <x86_encode_16+0x2498>
 19073b7:	48 c1 e0 04          	shl    $0x4,%rax
 19073bb:	48 c1 e2 04          	shl    $0x4,%rdx
 19073bf:	48 8d 7c 24 40       	lea    0x40(%rsp),%rdi
 19073c4:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 19073c8:	62 f1 fd 48 7f 44 24 04 	vmovdqa64 %zmm0,0x100(%rsp)
 19073d0:	62 f1 fd 48 7f 44 24 03 	vmovdqa64 %zmm0,0xc0(%rsp)
 19073d8:	62 f1 fd 48 7f 44 24 02 	vmovdqa64 %zmm0,0x80(%rsp)
 19073e0:	62 f1 fd 48 7f 44 24 01 	vmovdqa64 %zmm0,0x40(%rsp)
 19073e8:	49 89 cf             	mov    %rcx,%r15
 19073eb:	48 01 c6             	add    %rax,%rsi
 19073ee:	c5 f8 77             	vzeroupper
 19073f1:	e8 5a d0 e5 fe       	call   764450 <memcpy@plt>
 19073f6:	c5 f9 6f 4c 24 40    	vmovdqa 0x40(%rsp),%xmm1
 19073fc:	c5 f9 6f 54 24 50    	vmovdqa 0x50(%rsp),%xmm2
 1907402:	c5 f9 6f 5c 24 60    	vmovdqa 0x60(%rsp),%xmm3
 1907408:	c5 f9 6f 64 24 70    	vmovdqa 0x70(%rsp),%xmm4
 190740e:	48 8d 05 6b ef d5 0c 	lea    0xcd5ef6b(%rip),%rax        # e666380 <x86_template_storage>
 1907415:	c5 f9 6f b4 24 80 00 00 00 	vmovdqa 0x80(%rsp),%xmm6
 190741e:	62 71 fd 48 6f 3d 58 b1 c1 fe 	vmovdqa64 -0x13e4ea8(%rip),%zmm15        # 522580 <branch_sizing_patterns+0x27f0>
 1907428:	c5 f9 6f bc 24 c0 00 00 00 	vmovdqa 0xc0(%rsp),%xmm7
 1907431:	c5 79 6f 84 24 e0 00 00 00 	vmovdqa 0xe0(%rsp),%xmm8
 190743a:	62 f1 fd 48 6f 6c 24 01 	vmovdqa64 0x40(%rsp),%zmm5
 1907442:	62 71 fd 48 6f 54 24 02 	vmovdqa64 0x80(%rsp),%zmm10
 190744a:	62 71 fd 48 6f 5c 24 03 	vmovdqa64 0xc0(%rsp),%zmm11
 1907452:	62 71 fd 48 6f 64 24 04 	vmovdqa64 0x100(%rsp),%zmm12
 190745a:	62 e2 7d 48 5a 0d cc ef c6 fe 	vbroadcasti32x4 -0x1391034(%rip),%zmm17        # 576430 <x86_effects_unknown+0x9d0>
 1907464:	62 a3 4d 40 25 f6 ff 	vpternlogd $0xff,%zmm22,%zmm22,%zmm22
 190746b:	62 e2 7d 48 58 25 8f 91 c7 fe 	vpbroadcastd -0x1386e71(%rip),%zmm20        # 580604 <tier0_emit_x87.operations+0x1bc>
 1907475:	62 62 7d 48 58 1d 91 91 c7 fe 	vpbroadcastd -0x1386e6f(%rip),%zmm27        # 580610 <tier0_emit_x87.operations+0x1c8>
 190747f:	62 62 7d 48 58 0d 8b 91 c7 fe 	vpbroadcastd -0x1386e75(%rip),%zmm25        # 580614 <tier0_emit_x87.operations+0x1cc>
 1907489:	c5 f9 c5 c9 06       	vpextrw $0x6,%xmm1,%ecx
 190748e:	c5 f9 c5 d2 06       	vpextrw $0x6,%xmm2,%edx
 1907493:	c5 f9 c5 fc 06       	vpextrw $0x6,%xmm4,%edi
 1907498:	c5 f9 c5 f3 06       	vpextrw $0x6,%xmm3,%esi
 190749d:	c5 f9 6f a4 24 90 00 00 00 	vmovdqa 0x90(%rsp),%xmm4
 19074a6:	62 51 55 48 62 ea    	vpunpckldq %zmm10,%zmm5,%zmm13
 19074ac:	62 51 25 48 62 f4    	vpunpckldq %zmm12,%zmm11,%zmm14
 19074b2:	62 d1 55 48 6a ea    	vpunpckhdq %zmm10,%zmm5,%zmm5
 19074b8:	62 51 25 48 6a d4    	vpunpckhdq %zmm12,%zmm11,%zmm10
 19074be:	c1 e1 06             	shl    $0x6,%ecx
 19074c1:	c1 e2 06             	shl    $0x6,%edx
 19074c4:	c1 e6 06             	shl    $0x6,%esi
 19074c7:	c1 e7 06             	shl    $0x6,%edi
 19074ca:	62 51 95 48 6d de    	vpunpckhqdq %zmm14,%zmm13,%zmm11
 19074d0:	62 d1 95 48 6c c6    	vpunpcklqdq %zmm14,%zmm13,%zmm0
 19074d6:	62 51 d5 48 6c ea    	vpunpcklqdq %zmm10,%zmm5,%zmm13
 19074dc:	62 d1 d5 48 6d ea    	vpunpckhqdq %zmm10,%zmm5,%zmm5
 19074e2:	c5 fd 6f 4c 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm1
 19074e8:	c5 fd 6f 54 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm2
 19074ee:	b1 cc                	mov    $0xcc,%cl
 19074f0:	62 d1 0d 48 72 d5 1a 	vpsrld $0x1a,%zmm13,%zmm14
 19074f7:	62 e2 0d 48 36 1d ff b0 c1 fe 	vpermd -0x13e4f01(%rip),%zmm14,%zmm19        # 522600 <branch_sizing_patterns+0x2870>
 1907501:	62 d2 25 48 27 c3    	vptestmd %zmm11,%zmm11,%k0
 1907507:	62 d1 6d 40 72 e3 1f 	vpsrad $0x1f,%zmm11,%zmm18
 190750e:	62 21 25 48 fe c6    	vpaddd %zmm22,%zmm11,%zmm24
 1907514:	62 43 5d 40 25 cd 6c 	vpternlogd $0x6c,%zmm13,%zmm20,%zmm25
 190751b:	62 f3 f5 48 3a 4c 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm1,%zmm1
 1907524:	62 f3 ed 48 3a 5c 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm2,%zmm3
 190752d:	c5 fb 92 c9          	kmovd  %ecx,%k1
 1907531:	c5 f9 c5 ce 06       	vpextrw $0x6,%xmm6,%ecx
 1907536:	c5 f9 6f b4 24 a0 00 00 00 	vmovdqa 0xa0(%rsp),%xmm6
 190753f:	c1 e1 06             	shl    $0x6,%ecx
 1907542:	c5 f9 c5 d4 06       	vpextrw $0x6,%xmm4,%edx
 1907547:	c5 f9 6f a4 24 b0 00 00 00 	vmovdqa 0xb0(%rsp),%xmm4
 1907550:	c1 e2 06             	shl    $0x6,%edx
 1907553:	62 f2 f5 49 64 d3    	vpblendmq %zmm3,%zmm1,%zmm2{%k1}
 1907559:	62 f2 85 48 7e cb    	vpermt2q %zmm3,%zmm15,%zmm1
 190755f:	c5 fd 6f 5c 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm3
 1907565:	c5 f9 c5 cf 06       	vpextrw $0x6,%xmm7,%ecx
 190756a:	c5 f9 6f bc 24 d0 00 00 00 	vmovdqa 0xd0(%rsp),%xmm7
 1907573:	c5 f9 c5 f6 06       	vpextrw $0x6,%xmm6,%esi
 1907578:	c1 e6 06             	shl    $0x6,%esi
 190757b:	c1 e1 06             	shl    $0x6,%ecx
 190757e:	62 f3 e5 48 3a 5c 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm3,%zmm3
 1907587:	c4 c1 79 c5 f0 06    	vpextrw $0x6,%xmm8,%esi
 190758d:	c1 e6 06             	shl    $0x6,%esi
 1907590:	c5 f9 c5 fc 06       	vpextrw $0x6,%xmm4,%edi
 1907595:	c5 fd 6f 64 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm4
 190759b:	c1 e7 06             	shl    $0x6,%edi
 190759e:	62 f3 dd 48 3a 74 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm4,%zmm6
 19075a7:	c5 f9 c5 d7 06       	vpextrw $0x6,%xmm7,%edx
 19075ac:	c5 f9 6f bc 24 f0 00 00 00 	vmovdqa 0xf0(%rsp),%xmm7
 19075b5:	c1 e2 06             	shl    $0x6,%edx
 19075b8:	62 f2 e5 49 64 e6    	vpblendmq %zmm6,%zmm3,%zmm4{%k1}
 19075be:	62 f2 85 48 7e de    	vpermt2q %zmm6,%zmm15,%zmm3
 19075c4:	c5 fd 6f 74 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm6
 19075ca:	0f b7 8c 24 0c 01 00 00 	movzwl 0x10c(%rsp),%ecx
 19075d2:	c5 f9 c5 ff 06       	vpextrw $0x6,%xmm7,%edi
 19075d7:	c5 fd 6f 7c 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm7
 19075dd:	62 f3 cd 48 3a 74 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm6,%zmm6
 19075e6:	0f b7 94 24 1c 01 00 00 	movzwl 0x11c(%rsp),%edx
 19075ee:	0f b7 b4 24 2c 01 00 00 	movzwl 0x12c(%rsp),%esi
 19075f6:	62 71 6d 48 6a d4    	vpunpckhdq %zmm4,%zmm2,%zmm10
 19075fc:	c1 e7 06             	shl    $0x6,%edi
 19075ff:	62 73 c5 48 3a 44 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm7,%zmm8
 1907608:	0f b7 bc 24 3c 01 00 00 	movzwl 0x13c(%rsp),%edi
 1907610:	c1 e1 06             	shl    $0x6,%ecx
 1907613:	c1 e2 06             	shl    $0x6,%edx
 1907616:	c1 e6 06             	shl    $0x6,%esi
 1907619:	c5 7d 6f 4c 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm9
 190761f:	c1 e7 06             	shl    $0x6,%edi
 1907622:	62 e3 b5 48 3a 44 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm9,%zmm16
 190762b:	62 d2 cd 49 64 f8    	vpblendmq %zmm8,%zmm6,%zmm7{%k1}
 1907631:	62 d2 85 48 7e f0    	vpermt2q %zmm8,%zmm15,%zmm6
 1907637:	c5 7d 6f 44 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm8
 190763d:	62 73 bd 48 3a 44 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm8,%zmm8
 1907646:	62 32 bd 49 64 c8    	vpblendmq %zmm16,%zmm8,%zmm9{%k1}
 190764c:	62 32 85 48 7e c0    	vpermt2q %zmm16,%zmm15,%zmm8
 1907652:	62 e2 7d 48 5a 05 c4 ed c6 fe 	vbroadcasti32x4 -0x139123c(%rip),%zmm16        # 576420 <x86_effects_unknown+0x9c0>
 190765c:	62 72 0d 48 36 3d 5a af c1 fe 	vpermd -0x13e50a6(%rip),%zmm14,%zmm15        # 5225c0 <branch_sizing_patterns+0x2830>
 1907666:	62 72 0d 48 36 35 d0 af c1 fe 	vpermd -0x13e5030(%rip),%zmm14,%zmm14        # 522640 <branch_sizing_patterns+0x28b0>
 1907670:	62 51 45 48 6a e1    	vpunpckhdq %zmm9,%zmm7,%zmm12
 1907676:	62 51 ad 48 6d d4    	vpunpckhqdq %zmm12,%zmm10,%zmm10
 190767c:	62 d1 45 40 72 d2 1d 	vpsrld $0x1d,%zmm10,%zmm23
 1907683:	62 52 fd 40 83 e5    	vpmultishiftqb %zmm13,%zmm16,%zmm12
 1907689:	62 e2 7d 48 5a 05 ad ed c6 fe 	vbroadcasti32x4 -0x1391253(%rip),%zmm16        # 576440 <x86_effects_unknown+0x9e0>
 1907693:	62 c2 fd 40 83 c5    	vpmultishiftqb %zmm13,%zmm16,%zmm16
 1907699:	62 e3 1d 58 25 05 58 8f c7 fe d8 	vpternlogd $0xd8,-0x13870a8(%rip){1to16},%zmm12,%zmm16        # 5805fc <tier0_emit_x87.operations+0x1b4>
 19076a4:	62 52 f5 40 83 e5    	vpmultishiftqb %zmm13,%zmm17,%zmm12
 19076aa:	62 e2 7d 48 5a 0d 9c ed c6 fe 	vbroadcasti32x4 -0x1391264(%rip),%zmm17        # 576450 <x86_effects_unknown+0x9f0>
 19076b4:	62 73 7d 50 25 25 41 8f c7 fe e4 	vpternlogd $0xe4,-0x13870bf(%rip){1to16},%zmm16,%zmm12        # 580600 <tier0_emit_x87.operations+0x1b8>
 19076bf:	62 c2 75 40 00 ed    	vpshufb %zmm13,%zmm17,%zmm21
 19076c5:	62 d1 7d 40 72 f5 04 	vpslld $0x4,%zmm13,%zmm16
 19076cc:	62 b1 7d 40 72 e0 1f 	vpsrad $0x1f,%zmm16,%zmm16
 19076d3:	62 c3 1d 48 25 df f8 	vpternlogd $0xf8,%zmm15,%zmm12,%zmm19
 19076da:	62 b1 05 48 72 f5 10 	vpslld $0x10,%zmm21,%zmm15
 19076e1:	62 d1 75 40 72 e7 1f 	vpsrad $0x1f,%zmm15,%zmm17
 19076e8:	62 72 7e 48 38 f8    	vpmovm2d %k0,%zmm15
 19076ee:	62 23 7d 40 25 db ea 	vpternlogd $0xea,%zmm19,%zmm16,%zmm27
 19076f5:	62 b1 2d 40 72 d3 10 	vpsrld $0x10,%zmm19,%zmm26
 19076fc:	62 33 7d 40 25 f9 c8 	vpternlogd $0xc8,%zmm17,%zmm16,%zmm15
 1907703:	62 c1 6d 40 ef cb    	vpxord %zmm11,%zmm18,%zmm17
 1907709:	62 e2 7d 48 58 15 f5 8e c7 fe 	vpbroadcastd -0x138710b(%rip),%zmm18        # 580608 <tier0_emit_x87.operations+0x1c0>
 1907713:	62 a2 7d 48 44 c9    	vplzcntd %zmm17,%zmm17
 1907719:	62 a2 6d 40 45 c9    	vpsrlvd %zmm17,%zmm18,%zmm17
 190771f:	62 23 25 48 25 c1 14 	vpternlogd $0x14,%zmm17,%zmm11,%zmm24
 1907726:	62 a2 3d 40 14 cf    	vprorvd %zmm23,%zmm24,%zmm17
 190772c:	62 62 7d 48 58 05 d6 8e c7 fe 	vpbroadcastd -0x138712a(%rip),%zmm24        # 58060c <tier0_emit_x87.operations+0x1c4>
 1907736:	62 b1 75 40 72 e1 1f 	vpsrad $0x1f,%zmm17,%zmm17
 190773d:	62 23 05 48 25 c3 ea 	vpternlogd $0xea,%zmm19,%zmm15,%zmm24
 1907744:	62 b1 65 40 72 d3 03 	vpsrld $0x3,%zmm19,%zmm19
 190774b:	62 e3 2d 50 25 1d da 8e c7 fe ec 	vpternlogd $0xec,-0x1387126(%rip){1to16},%zmm26,%zmm19        # 580630 <tier0_emit_x87.operations+0x1e8>
 1907756:	62 03 75 40 25 d8 b8 	vpternlogd $0xb8,%zmm24,%zmm17,%zmm27
 190775d:	62 21 35 40 fe c6    	vpaddd %zmm22,%zmm25,%zmm24
 1907763:	62 d1 35 40 72 d5 08 	vpsrld $0x8,%zmm13,%zmm25
 190776a:	62 63 5d 50 25 0d a3 8e c7 fe 6c 	vpternlogd $0x6c,-0x138715d(%rip){1to16},%zmm20,%zmm25        # 580618 <tier0_emit_x87.operations+0x1d0>
 1907775:	62 51 55 48 eb ed    	vpord  %zmm13,%zmm5,%zmm13
 190777b:	62 d1 2d 40 72 f5 07 	vpslld $0x7,%zmm13,%zmm26
 1907782:	62 31 7d 40 db ed    	vpandd %zmm21,%zmm16,%zmm13
 1907788:	62 73 0d 58 25 2d a9 8e c7 fe ec 	vpternlogd $0xec,-0x1387157(%rip){1to16},%zmm14,%zmm13        # 58063c <tier0_emit_x87.operations+0x1f4>
 1907793:	62 71 05 58 db 35 a7 8e c7 fe 	vpandd -0x1387159(%rip){1to16},%zmm15,%zmm14        # 580644 <tier0_emit_x87.operations+0x1fc>
 190779d:	62 e1 7d 50 db 05 a1 8e c7 fe 	vpandd -0x138715f(%rip){1to16},%zmm16,%zmm16        # 580648 <tier0_emit_x87.operations+0x200>
 19077a7:	62 73 2d 58 25 2d 8e 8e c7 fe f8 	vpternlogd $0xf8,-0x1387172(%rip){1to16},%zmm10,%zmm13        # 580640 <tier0_emit_x87.operations+0x1f8>
 19077b2:	62 a1 35 40 fe e6    	vpaddd %zmm22,%zmm25,%zmm20
 19077b8:	62 62 7d 48 58 0d 5a 8e c7 fe 	vpbroadcastd -0x13871a6(%rip),%zmm25        # 58061c <tier0_emit_x87.operations+0x1d4>
 19077c2:	62 63 3d 50 25 0d 53 8e c7 fe ea 	vpternlogd $0xea,-0x13871ad(%rip){1to16},%zmm24,%zmm25        # 580620 <tier0_emit_x87.operations+0x1d8>
 19077cd:	62 b1 3d 40 72 f3 08 	vpslld $0x8,%zmm19,%zmm24
 19077d4:	62 c3 75 40 25 c6 b8 	vpternlogd $0xb8,%zmm14,%zmm17,%zmm16
 19077db:	62 d1 0d 48 72 cb 01 	vprold $0x1,%zmm11,%zmm14
 19077e2:	62 63 5d 50 25 0d 37 8e c7 fe f8 	vpternlogd $0xf8,-0x13871c9(%rip){1to16},%zmm20,%zmm25        # 580624 <tier0_emit_x87.operations+0x1dc>
 19077ed:	62 e1 1d 58 db 25 31 8e c7 fe 	vpandd -0x13871cf(%rip){1to16},%zmm12,%zmm20        # 580628 <tier0_emit_x87.operations+0x1e0>
 19077f7:	62 32 0d 48 14 f7    	vprorvd %zmm23,%zmm14,%zmm14
 19077fd:	62 53 05 48 25 f3 e2 	vpternlogd $0xe2,%zmm11,%zmm15,%zmm14
 1907804:	62 53 75 40 25 f3 e2 	vpternlogd $0xe2,%zmm11,%zmm17,%zmm14
 190780b:	62 e2 7d 48 5a 0d cb eb c6 fe 	vbroadcasti32x4 -0x1391435(%rip),%zmm17        # 5763e0 <x86_effects_unknown+0x980>
 1907815:	62 51 7d 48 62 de    	vpunpckldq %zmm14,%zmm0,%zmm11
 190781b:	62 d1 7d 48 6a c6    	vpunpckhdq %zmm14,%zmm0,%zmm0
 1907821:	62 83 2d 48 25 e1 f8 	vpternlogd $0xf8,%zmm25,%zmm10,%zmm20
 1907828:	62 d1 35 40 72 d4 03 	vpsrld $0x3,%zmm12,%zmm25
 190782f:	62 63 2d 58 25 0d fa 8d c7 fe a2 	vpternlogd $0xa2,-0x1387206(%rip){1to16},%zmm10,%zmm25        # 580634 <tier0_emit_x87.operations+0x1ec>
 190783a:	62 e2 5d 50 3b 25 e8 8d c7 fe 	vpminud -0x1387218(%rip){1to16},%zmm20,%zmm20        # 58062c <tier0_emit_x87.operations+0x1e4>
 1907844:	62 31 35 40 fe e6    	vpaddd %zmm22,%zmm25,%zmm12
 190784a:	62 e2 35 50 3b 35 e4 8d c7 fe 	vpminud -0x138721c(%rip){1to16},%zmm25,%zmm22        # 580638 <tier0_emit_x87.operations+0x1f0>
 1907854:	62 62 7d 48 5a 0d 02 ec c6 fe 	vbroadcasti32x4 -0x13913fe(%rip),%zmm25        # 576460 <x86_effects_unknown+0xa00>
 190785e:	62 d1 1d 48 72 e4 1f 	vpsrad $0x1f,%zmm12,%zmm12
 1907865:	62 63 1d 58 25 05 dc 8d c7 fe 08 	vpternlogd $0x8,-0x1387224(%rip){1to16},%zmm12,%zmm24        # 58064c <tier0_emit_x87.operations+0x204>
 1907870:	62 63 2d 50 25 05 d5 8d c7 fe d8 	vpternlogd $0xd8,-0x138722b(%rip){1to16},%zmm26,%zmm24        # 580650 <tier0_emit_x87.operations+0x208>
 190787b:	62 62 b5 40 83 cd    	vpmultishiftqb %zmm5,%zmm25,%zmm25
 1907881:	62 63 65 50 25 0d c8 8d c7 fe d8 	vpternlogd $0xd8,-0x1387238(%rip){1to16},%zmm19,%zmm25        # 580654 <tier0_emit_x87.operations+0x20c>
 190788c:	62 33 4d 40 25 ec fe 	vpternlogd $0xfe,%zmm20,%zmm22,%zmm13
 1907893:	62 51 7d 40 eb ed    	vpord  %zmm13,%zmm16,%zmm13
 1907899:	62 c1 7d 48 70 d5 00 	vpshufd $0x0,%zmm13,%zmm18
 19078a0:	62 63 3d 50 25 0d ad 8d c7 fe d8 	vpternlogd $0xd8,-0x1387253(%rip){1to16},%zmm24,%zmm25        # 580658 <tier0_emit_x87.operations+0x210>
 19078ab:	62 f2 6d 40 8f c9    	vpshufbitqmb %zmm1,%zmm18,%k1
 19078b1:	c4 e1 fb 93 c1       	kmovq  %k1,%rax
 19078b6:	f3 48 0f b8 c0       	popcnt %rax,%rax
 19078bb:	49 8d 0c 06          	lea    (%r14,%rax,1),%rcx
 19078bf:	62 11 25 40 62 f1    	vpunpckldq %zmm25,%zmm27,%zmm14
 19078c5:	62 11 25 40 6a f9    	vpunpckhdq %zmm25,%zmm27,%zmm15
 19078cb:	62 c1 a5 48 6c c6    	vpunpcklqdq %zmm14,%zmm11,%zmm16
 19078d1:	62 c1 fd 48 6c df    	vpunpcklqdq %zmm15,%zmm0,%zmm19
 19078d7:	62 d1 fd 48 6d c7    	vpunpckhqdq %zmm15,%zmm0,%zmm0
 19078dd:	62 51 a5 48 6d de    	vpunpckhqdq %zmm14,%zmm11,%zmm11
 19078e3:	62 51 7d 48 70 fd 55 	vpshufd $0x55,%zmm13,%zmm15
 19078ea:	62 e2 7d 40 00 c1    	vpshufb %zmm1,%zmm16,%zmm16
 19078f0:	62 d2 7d 48 00 c0    	vpshufb %zmm8,%zmm0,%zmm0
 19078f6:	62 a3 ed 48 25 c1 78 	vpternlogq $0x78,%zmm17,%zmm2,%zmm16
 19078fd:	62 f2 25 48 00 d3    	vpshufb %zmm3,%zmm11,%zmm2
 1907903:	62 b3 b5 48 25 c1 78 	vpternlogq $0x78,%zmm17,%zmm9,%zmm0
 190790a:	62 e2 7d c9 63 c1    	vpcompressb %zmm16,%zmm1{%k1}{z}
 1907910:	62 f2 05 48 8f cb    	vpshufbitqmb %zmm3,%zmm15,%k1
 1907916:	62 d1 7d 48 70 dd aa 	vpshufd $0xaa,%zmm13,%zmm3
 190791d:	62 b3 dd 48 25 d1 78 	vpternlogq $0x78,%zmm17,%zmm4,%zmm2
 1907924:	62 d1 7d 48 70 e5 ff 	vpshufd $0xff,%zmm13,%zmm4
 190792b:	62 73 2d 58 25 2d 26 8d c7 fe 20 	vpternlogd $0x20,-0x13872da(%rip){1to16},%zmm10,%zmm13        # 58065c <tier0_emit_x87.operations+0x214>
 1907936:	c4 e1 fb 93 d1       	kmovq  %k1,%rdx
 190793b:	f3 48 0f b8 d2       	popcnt %rdx,%rdx
 1907940:	62 d1 fe 48 7f 0e    	vmovdqu64 %zmm1,(%r14)
 1907946:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
 190794a:	62 f2 7d c9 63 d1    	vpcompressb %zmm2,%zmm1{%k1}{z}
 1907950:	62 f2 65 40 00 d6    	vpshufb %zmm6,%zmm19,%zmm2
 1907956:	62 f2 65 48 8f ce    	vpshufbitqmb %zmm6,%zmm3,%k1
 190795c:	62 f1 2d 58 db 1d fa 8c c7 fe 	vpandd -0x1387306(%rip){1to16},%zmm10,%zmm3        # 580660 <tier0_emit_x87.operations+0x218>
 1907966:	48 8d 34 11          	lea    (%rcx,%rdx,1),%rsi
 190796a:	62 b3 c5 48 25 d1 78 	vpternlogq $0x78,%zmm17,%zmm7,%zmm2
 1907971:	62 d1 fe 48 7f 0c 06 	vmovdqu64 %zmm1,(%r14,%rax,1)
 1907978:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
 190797c:	62 f2 7d c9 63 d1    	vpcompressb %zmm2,%zmm1{%k1}{z}
 1907982:	c4 e1 fb 93 c1       	kmovq  %k1,%rax
 1907987:	62 d2 5d 48 8f c8    	vpshufbitqmb %zmm8,%zmm4,%k1
 190798d:	41 29 de             	sub    %ebx,%r14d
 1907990:	f3 48 0f b8 f8       	popcnt %rax,%rdi
 1907995:	62 f2 7d c9 63 c0    	vpcompressb %zmm0,%zmm0{%k1}{z}
 190799b:	c4 e1 fb 93 c1       	kmovq  %k1,%rax
 19079a0:	f3 48 0f b8 c0       	popcnt %rax,%rax
 19079a5:	62 f1 fe 48 7f 0c 0a 	vmovdqu64 %zmm1,(%rdx,%rcx,1)
 19079ac:	62 f1 1d 48 fe cb    	vpaddd %zmm3,%zmm12,%zmm1
 19079b2:	48 01 f8             	add    %rdi,%rax
 19079b5:	48 01 f0             	add    %rsi,%rax
 19079b8:	62 f1 fe 48 7f 04 37 	vmovdqu64 %zmm0,(%rdi,%rsi,1)
 19079bf:	62 d2 7d 48 55 c5    	vpopcntd %zmm13,%zmm0
 19079c5:	44 89 74 24 3c       	mov    %r14d,0x3c(%rsp)
 19079ca:	49 89 c6             	mov    %rax,%r14
 19079cd:	62 f1 75 48 fe c0    	vpaddd %zmm0,%zmm1,%zmm0
 19079d3:	c5 f9 6f 0d 15 ea c6 fe 	vmovdqa -0x13915eb(%rip),%xmm1        # 5763f0 <x86_effects_unknown+0x990>
 19079db:	62 f2 75 48 8d c0    	vpermb %zmm0,%zmm1,%zmm0
 19079e1:	62 f2 fd 18 40 05 55 8a c7 fe 	vpmullq -0x13875ab(%rip){1to2},%xmm0,%xmm0        # 580440 <x86_semantics_benchmark_code.registers+0x450>
 19079eb:	c5 f9 6f 0d 0d ea c6 fe 	vmovdqa -0x13915f3(%rip),%xmm1        # 576400 <x86_effects_unknown+0x9a0>
 19079f3:	c4 e2 79 00 15 14 ea c6 fe 	vpshufb -0x13915ec(%rip),%xmm0,%xmm2        # 576410 <x86_effects_unknown+0x9b0>
 19079fc:	62 f2 75 48 8d cd    	vpermb %zmm5,%zmm1,%zmm1
 1907a02:	c5 e9 fc c0          	vpaddb %xmm0,%xmm2,%xmm0
 1907a06:	62 f2 7d 48 31 c0    	vpmovzxbd %xmm0,%zmm0
 1907a0c:	62 f1 7d 58 fe 44 24 0f 	vpaddd 0x3c(%rsp){1to16},%zmm0,%zmm0
 1907a14:	62 f2 7e 48 29 c9    	vpmovb2m %zmm1,%k1
 1907a1a:	62 f2 7d c9 8b c0    	vpcompressd %zmm0,%zmm0{%k1}{z}
 1907a20:	62 d1 fe 48 7f 07    	vmovdqu64 %zmm0,(%r15)
 1907a26:	e9 3d 11 00 00       	jmp    1908b68 <x86_encode_16+0x2498>
 1907a2b:	62 f2 7d 48 5a 1d ab e9 c6 fe 	vbroadcasti32x4 -0x1391655(%rip),%zmm3        # 5763e0 <x86_effects_unknown+0x980>
 1907a35:	62 72 7d 48 58 0d e1 8b c7 fe 	vpbroadcastd -0x138741f(%rip),%zmm9        # 580620 <tier0_emit_x87.operations+0x1d8>
 1907a3f:	48 8d 4a f0          	lea    -0x10(%rdx),%rcx
 1907a43:	41 b1 cc             	mov    $0xcc,%r9b
 1907a46:	48 8d be fc 00 00 00 	lea    0xfc(%rsi),%rdi
 1907a4d:	4c 8d 05 2c e9 d5 0c 	lea    0xcd5e92c(%rip),%r8        # e666380 <x86_template_storage>
 1907a54:	62 53 1d 48 25 e4 ff 	vpternlogd $0xff,%zmm12,%zmm12,%zmm12
 1907a5b:	31 c0                	xor    %eax,%eax
 1907a5d:	49 89 de             	mov    %rbx,%r14
 1907a60:	48 c1 e9 04          	shr    $0x4,%rcx
 1907a64:	c4 c1 7b 92 c9       	kmovd  %r9d,%k1
 1907a69:	48 ff c1             	inc    %rcx
 1907a6c:	0f 1f 40 00          	nopl   0x0(%rax)
 1907a70:	44 0f b7 8f 10 ff ff ff 	movzwl -0xf0(%rdi),%r9d
 1907a78:	44 0f b7 97 20 ff ff ff 	movzwl -0xe0(%rdi),%r10d
 1907a80:	44 0f b7 9f 30 ff ff ff 	movzwl -0xd0(%rdi),%r11d
 1907a88:	44 0f b7 bf 40 ff ff ff 	movzwl -0xc0(%rdi),%r15d
 1907a90:	62 e1 fe 48 6f 9f 04 ff ff ff 	vmovdqu64 -0xfc(%rdi),%zmm19
 1907a9a:	62 e1 fe 48 6f af 44 ff ff ff 	vmovdqu64 -0xbc(%rdi),%zmm21
 1907aa4:	62 e1 fe 48 6f b7 84 ff ff ff 	vmovdqu64 -0x7c(%rdi),%zmm22
 1907aae:	62 e1 fe 48 6f bf c4 ff ff ff 	vmovdqu64 -0x3c(%rdi),%zmm23
 1907ab8:	62 f2 7d 48 5a 0d 5e e9 c6 fe 	vbroadcasti32x4 -0x13916a2(%rip),%zmm1        # 576420 <x86_effects_unknown+0x9c0>
 1907ac2:	48 83 c0 10          	add    $0x10,%rax
 1907ac6:	41 c1 e1 06          	shl    $0x6,%r9d
 1907aca:	41 c1 e2 06          	shl    $0x6,%r10d
 1907ace:	41 c1 e3 06          	shl    $0x6,%r11d
 1907ad2:	41 c1 e7 06          	shl    $0x6,%r15d
 1907ad6:	c4 81 7d 6f 64 01 40 	vmovdqa 0x40(%r9,%r8,1),%ymm4
 1907add:	44 0f b7 8f 50 ff ff ff 	movzwl -0xb0(%rdi),%r9d
 1907ae5:	c4 81 7d 6f 6c 02 60 	vmovdqa 0x60(%r10,%r8,1),%ymm5
 1907aec:	44 0f b7 97 60 ff ff ff 	movzwl -0xa0(%rdi),%r10d
 1907af4:	62 93 dd 48 3a 64 03 02 01 	vinserti64x4 $0x1,0x40(%r11,%r8,1),%zmm4,%zmm4
 1907afd:	62 13 d5 48 3a 7c 07 03 01 	vinserti64x4 $0x1,0x60(%r15,%r8,1),%zmm5,%zmm15
 1907b06:	44 0f b7 9f 70 ff ff ff 	movzwl -0x90(%rdi),%r11d
 1907b0e:	44 0f b7 7f 80       	movzwl -0x80(%rdi),%r15d
 1907b13:	62 b1 65 40 62 f5    	vpunpckldq %zmm21,%zmm19,%zmm6
 1907b19:	62 b1 4d 40 62 ff    	vpunpckldq %zmm23,%zmm22,%zmm7
 1907b1f:	62 a1 4d 40 6a f7    	vpunpckhdq %zmm23,%zmm22,%zmm22
 1907b25:	62 a1 65 40 6a ed    	vpunpckhdq %zmm21,%zmm19,%zmm21
 1907b2b:	62 b1 d5 40 6c d6    	vpunpcklqdq %zmm22,%zmm21,%zmm2
 1907b31:	62 e1 cd 48 6d ff    	vpunpckhqdq %zmm7,%zmm6,%zmm23
 1907b37:	62 62 f5 48 83 da    	vpmultishiftqb %zmm2,%zmm1,%zmm27
 1907b3d:	62 f2 7d 48 5a 0d f9 e8 c6 fe 	vbroadcasti32x4 -0x1391707(%rip),%zmm1        # 576440 <x86_effects_unknown+0x9e0>
 1907b47:	62 f1 15 40 72 d2 1a 	vpsrld $0x1a,%zmm2,%zmm29
 1907b4e:	62 b2 45 40 27 c7    	vptestmd %zmm23,%zmm23,%k0
 1907b54:	62 e1 fd 48 6f da    	vmovdqa64 %zmm2,%zmm19
 1907b5a:	41 c1 e1 06          	shl    $0x6,%r9d
 1907b5e:	41 c1 e2 06          	shl    $0x6,%r10d
 1907b62:	c4 01 7d 6f 44 01 40 	vmovdqa 0x40(%r9,%r8,1),%ymm8
 1907b69:	44 0f b7 4f 90       	movzwl -0x70(%rdi),%r9d
 1907b6e:	41 c1 e3 06          	shl    $0x6,%r11d
 1907b72:	c4 01 7d 6f 54 02 60 	vmovdqa 0x60(%r10,%r8,1),%ymm10
 1907b79:	44 0f b7 57 a0       	movzwl -0x60(%rdi),%r10d
 1907b7e:	41 c1 e7 06          	shl    $0x6,%r15d
 1907b82:	62 13 bd 48 3a 44 03 02 01 	vinserti64x4 $0x1,0x40(%r11,%r8,1),%zmm8,%zmm8
 1907b8b:	62 83 ad 48 3a 4c 07 03 01 	vinserti64x4 $0x1,0x60(%r15,%r8,1),%zmm10,%zmm17
 1907b94:	44 0f b7 5f b0       	movzwl -0x50(%rdi),%r11d
 1907b99:	44 0f b7 7f c0       	movzwl -0x40(%rdi),%r15d
 1907b9e:	62 d2 dd 49 64 ef    	vpblendmq %zmm15,%zmm4,%zmm5{%k1}
 1907ba4:	41 c1 e1 06          	shl    $0x6,%r9d
 1907ba8:	41 c1 e2 06          	shl    $0x6,%r10d
 1907bac:	c4 01 7d 6f 5c 01 40 	vmovdqa 0x40(%r9,%r8,1),%ymm11
 1907bb3:	44 0f b7 4f d0       	movzwl -0x30(%rdi),%r9d
 1907bb8:	41 c1 e3 06          	shl    $0x6,%r11d
 1907bbc:	c4 01 7d 6f 6c 02 60 	vmovdqa 0x60(%r10,%r8,1),%ymm13
 1907bc3:	44 0f b7 57 e0       	movzwl -0x20(%rdi),%r10d
 1907bc8:	41 c1 e7 06          	shl    $0x6,%r15d
 1907bcc:	62 62 f5 48 83 f2    	vpmultishiftqb %zmm2,%zmm1,%zmm30
 1907bd2:	62 f2 7d 48 5a 0d 54 e8 c6 fe 	vbroadcasti32x4 -0x13917ac(%rip),%zmm1        # 576430 <x86_effects_unknown+0x9d0>
 1907bdc:	62 63 25 50 25 35 15 8a c7 fe d8 	vpternlogd $0xd8,-0x13875eb(%rip){1to16},%zmm27,%zmm30        # 5805fc <tier0_emit_x87.operations+0x1b4>
 1907be7:	62 13 a5 48 3a 5c 03 02 01 	vinserti64x4 $0x1,0x40(%r11,%r8,1),%zmm11,%zmm11
 1907bf0:	62 83 95 48 3a 54 07 03 01 	vinserti64x4 $0x1,0x60(%r15,%r8,1),%zmm13,%zmm18
 1907bf9:	44 0f b7 5f f0       	movzwl -0x10(%rdi),%r11d
 1907bfe:	44 0f b7 3f          	movzwl (%rdi),%r15d
 1907c02:	48 81 c7 00 01 00 00 	add    $0x100,%rdi
 1907c09:	62 32 bd 49 64 d1    	vpblendmq %zmm17,%zmm8,%zmm10{%k1}
 1907c0f:	62 41 55 48 6a c2    	vpunpckhdq %zmm10,%zmm5,%zmm24
 1907c15:	41 c1 e1 06          	shl    $0x6,%r9d
 1907c19:	41 c1 e2 06          	shl    $0x6,%r10d
 1907c1d:	41 c1 e3 06          	shl    $0x6,%r11d
 1907c21:	c4 01 7d 6f 74 01 40 	vmovdqa 0x40(%r9,%r8,1),%ymm14
 1907c28:	41 c1 e7 06          	shl    $0x6,%r15d
 1907c2c:	62 81 fd 28 6f 44 02 03 	vmovdqa64 0x60(%r10,%r8,1),%ymm16
 1907c34:	62 13 8d 48 3a 74 03 02 01 	vinserti64x4 $0x1,0x40(%r11,%r8,1),%zmm14,%zmm14
 1907c3d:	62 83 fd 40 3a 64 07 03 01 	vinserti64x4 $0x1,0x60(%r15,%r8,1),%zmm16,%zmm20
 1907c46:	62 62 f5 48 83 e2    	vpmultishiftqb %zmm2,%zmm1,%zmm28
 1907c4c:	62 f1 75 48 72 f2 04 	vpslld $0x4,%zmm2,%zmm1
 1907c53:	62 63 0d 50 25 25 a2 89 c7 fe e4 	vpternlogd $0xe4,-0x138765e(%rip){1to16},%zmm30,%zmm28        # 580600 <tier0_emit_x87.operations+0x1b8>
 1907c5e:	62 f1 25 40 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm27
 1907c65:	62 f2 7d 48 5a 0d e1 e7 c6 fe 	vbroadcasti32x4 -0x139181f(%rip),%zmm1        # 576450 <x86_effects_unknown+0x9f0>
 1907c6f:	62 32 a5 49 64 ea    	vpblendmq %zmm18,%zmm11,%zmm13{%k1}
 1907c75:	62 a2 8d 49 64 c4    	vpblendmq %zmm20,%zmm14,%zmm16{%k1}
 1907c7b:	62 21 15 48 6a c8    	vpunpckhdq %zmm16,%zmm13,%zmm25
 1907c81:	62 01 bd 40 6d d1    	vpunpckhqdq %zmm25,%zmm24,%zmm26
 1907c87:	62 62 15 40 36 0d 2f a9 c1 fe 	vpermd -0x13e56d1(%rip),%zmm29,%zmm25        # 5225c0 <branch_sizing_patterns+0x2830>
 1907c91:	62 62 15 40 36 05 65 a9 c1 fe 	vpermd -0x13e569b(%rip),%zmm29,%zmm24        # 522600 <branch_sizing_patterns+0x2870>
 1907c9b:	62 62 75 48 00 f2    	vpshufb %zmm2,%zmm1,%zmm30
 1907ca1:	62 f2 7d 48 58 0d 5d 89 c7 fe 	vpbroadcastd -0x13876a3(%rip),%zmm1        # 580608 <tier0_emit_x87.operations+0x1c0>
 1907cab:	62 62 15 40 36 2d 8b a9 c1 fe 	vpermd -0x13e5675(%rip),%zmm29,%zmm29        # 522640 <branch_sizing_patterns+0x28b0>
 1907cb5:	62 91 7d 48 72 f6 10 	vpslld $0x10,%zmm30,%zmm0
 1907cbc:	62 01 25 40 db f6    	vpandd %zmm30,%zmm27,%zmm30
 1907cc2:	62 f1 05 40 72 e0 1f 	vpsrad $0x1f,%zmm0,%zmm31
 1907cc9:	62 b1 7d 48 72 e7 1f 	vpsrad $0x1f,%zmm23,%zmm0
 1907cd0:	62 03 1d 40 25 c1 f8 	vpternlogd $0xf8,%zmm25,%zmm28,%zmm24
 1907cd7:	62 62 7e 48 38 c8    	vpmovm2d %k0,%zmm25
 1907cdd:	62 03 25 40 25 cf c8 	vpternlogd $0xc8,%zmm31,%zmm27,%zmm25
 1907ce4:	62 21 7d 48 ef ff    	vpxord %zmm23,%zmm0,%zmm31
 1907cea:	62 f2 7d 48 58 05 10 89 c7 fe 	vpbroadcastd -0x13876f0(%rip),%zmm0        # 580604 <tier0_emit_x87.operations+0x1bc>
 1907cf4:	62 63 15 50 25 35 3d 89 c7 fe ec 	vpternlogd $0xec,-0x13876c3(%rip){1to16},%zmm29,%zmm30        # 58063c <tier0_emit_x87.operations+0x1f4>
 1907cff:	62 91 15 40 72 d2 1d 	vpsrld $0x1d,%zmm26,%zmm29
 1907d06:	62 02 7d 48 44 ff    	vplzcntd %zmm31,%zmm31
 1907d0c:	62 63 2d 50 25 35 29 89 c7 fe f8 	vpternlogd $0xf8,-0x13876d7(%rip){1to16},%zmm26,%zmm30        # 580640 <tier0_emit_x87.operations+0x1f8>
 1907d17:	62 02 75 48 45 ff    	vpsrlvd %zmm31,%zmm1,%zmm31
 1907d1d:	62 d1 45 40 fe cc    	vpaddd %zmm12,%zmm23,%zmm1
 1907d23:	62 93 45 40 25 cf 14 	vpternlogd $0x14,%zmm31,%zmm23,%zmm1
 1907d2a:	62 f1 05 40 72 d2 08 	vpsrld $0x8,%zmm2,%zmm31
 1907d31:	62 92 75 48 14 cd    	vprorvd %zmm29,%zmm1,%zmm1
 1907d37:	62 f1 75 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm1
 1907d3e:	62 e3 7d 58 25 1d cb 88 c7 fe 6c 	vpternlogd $0x6c,-0x1387735(%rip){1to16},%zmm0,%zmm19        # 580614 <tier0_emit_x87.operations+0x1cc>
 1907d49:	62 63 7d 58 25 3d c4 88 c7 fe 6c 	vpternlogd $0x6c,-0x138773c(%rip){1to16},%zmm0,%zmm31        # 580618 <tier0_emit_x87.operations+0x1d0>
 1907d54:	62 f1 1d 50 db 05 ca 88 c7 fe 	vpandd -0x1387736(%rip){1to16},%zmm28,%zmm0        # 580628 <tier0_emit_x87.operations+0x1e0>
 1907d5e:	62 91 1d 40 72 d4 03 	vpsrld $0x3,%zmm28,%zmm28
 1907d65:	62 63 2d 50 25 25 c4 88 c7 fe a2 	vpternlogd $0xa2,-0x138773c(%rip){1to16},%zmm26,%zmm28        # 580634 <tier0_emit_x87.operations+0x1ec>
 1907d70:	62 c1 65 40 fe dc    	vpaddd %zmm12,%zmm19,%zmm19
 1907d76:	62 e3 35 58 25 1d 9b 88 c7 fe ec 	vpternlogd $0xec,-0x1387765(%rip){1to16},%zmm9,%zmm19        # 58061c <tier0_emit_x87.operations+0x1d4>
 1907d81:	62 41 05 40 fe fc    	vpaddd %zmm12,%zmm31,%zmm31
 1907d87:	62 63 65 50 25 3d 92 88 c7 fe ec 	vpternlogd $0xec,-0x138776e(%rip){1to16},%zmm19,%zmm31        # 580624 <tier0_emit_x87.operations+0x1dc>
 1907d92:	62 93 2d 40 25 c7 f8 	vpternlogd $0xf8,%zmm31,%zmm26,%zmm0
 1907d99:	62 e2 7d 58 3b 1d 89 88 c7 fe 	vpminud -0x1387777(%rip){1to16},%zmm0,%zmm19        # 58062c <tier0_emit_x87.operations+0x1e4>
 1907da3:	62 f2 1d 50 3b 05 8b 88 c7 fe 	vpminud -0x1387775(%rip){1to16},%zmm28,%zmm0        # 580638 <tier0_emit_x87.operations+0x1f0>
 1907dad:	62 01 fd 48 6f d0    	vmovdqa64 %zmm24,%zmm26
 1907db3:	62 63 35 50 25 15 4e 88 c7 fe f8 	vpternlogd $0xf8,-0x13877b2(%rip){1to16},%zmm25,%zmm26        # 58060c <tier0_emit_x87.operations+0x1c4>
 1907dbe:	62 61 35 50 db 3d 7c 88 c7 fe 	vpandd -0x1387784(%rip){1to16},%zmm25,%zmm31        # 580644 <tier0_emit_x87.operations+0x1fc>
 1907dc8:	62 23 7d 48 25 f3 fe 	vpternlogd $0xfe,%zmm19,%zmm0,%zmm30
 1907dcf:	62 81 fd 48 6f d8    	vmovdqa64 %zmm24,%zmm19
 1907dd5:	62 e3 25 50 25 1d 30 88 c7 fe f8 	vpternlogd $0xf8,-0x13877d0(%rip){1to16},%zmm27,%zmm19        # 580610 <tier0_emit_x87.operations+0x1c8>
 1907de0:	62 b1 7d 48 72 cf 01 	vprold $0x1,%zmm23,%zmm0
 1907de7:	62 61 25 50 db 1d 57 88 c7 fe 	vpandd -0x13877a9(%rip){1to16},%zmm27,%zmm27        # 580648 <tier0_emit_x87.operations+0x200>
 1907df1:	62 83 75 48 25 da b8 	vpternlogd $0xb8,%zmm26,%zmm1,%zmm19
 1907df8:	62 02 7d 48 14 d5    	vprorvd %zmm29,%zmm0,%zmm26
 1907dfe:	62 f1 fd 48 6f 05 78 a7 c1 fe 	vmovdqa64 -0x13e5888(%rip),%zmm0        # 522580 <branch_sizing_patterns+0x27f0>
 1907e08:	62 03 75 48 25 df b8 	vpternlogd $0xb8,%zmm31,%zmm1,%zmm27
 1907e0f:	62 23 35 40 25 d7 e2 	vpternlogd $0xe2,%zmm23,%zmm25,%zmm26
 1907e16:	62 23 75 48 25 d7 e2 	vpternlogd $0xe2,%zmm23,%zmm1,%zmm26
 1907e1d:	62 f1 cd 48 6c cf    	vpunpcklqdq %zmm7,%zmm6,%zmm1
 1907e23:	62 d1 1d 40 fe fc    	vpaddd %zmm12,%zmm28,%zmm7
 1907e29:	62 b1 d5 40 6d f6    	vpunpckhqdq %zmm22,%zmm21,%zmm6
 1907e2f:	62 f1 45 48 72 e7 1f 	vpsrad $0x1f,%zmm7,%zmm7
 1907e36:	62 f1 4d 48 eb d2    	vpord  %zmm2,%zmm6,%zmm2
 1907e3c:	62 f1 6d 48 72 f2 07 	vpslld $0x7,%zmm2,%zmm2
 1907e43:	62 d2 fd 48 7e e7    	vpermt2q %zmm15,%zmm0,%zmm4
 1907e49:	62 32 fd 48 7e c1    	vpermt2q %zmm17,%zmm0,%zmm8
 1907e4f:	62 32 fd 48 7e da    	vpermt2q %zmm18,%zmm0,%zmm11
 1907e55:	62 32 fd 48 7e f4    	vpermt2q %zmm20,%zmm0,%zmm14
 1907e5b:	62 91 7d 48 72 d0 10 	vpsrld $0x10,%zmm24,%zmm0
 1907e62:	62 91 05 48 72 d0 03 	vpsrld $0x3,%zmm24,%zmm15
 1907e69:	62 73 7d 58 25 3d bc 87 c7 fe ec 	vpternlogd $0xec,-0x1387844(%rip){1to16},%zmm0,%zmm15        # 580630 <tier0_emit_x87.operations+0x1e8>
 1907e74:	62 f2 7d 48 5a 05 e2 e5 c6 fe 	vbroadcasti32x4 -0x1391a1e(%rip),%zmm0        # 576460 <x86_effects_unknown+0xa00>
 1907e7e:	62 d1 75 40 72 f7 08 	vpslld $0x8,%zmm15,%zmm17
 1907e85:	62 e3 45 58 25 0d bc 87 c7 fe 08 	vpternlogd $0x8,-0x1387844(%rip){1to16},%zmm7,%zmm17        # 58064c <tier0_emit_x87.operations+0x204>
 1907e90:	62 f2 fd 48 83 f6    	vpmultishiftqb %zmm6,%zmm0,%zmm6
 1907e96:	62 f3 05 58 25 35 b3 87 c7 fe d8 	vpternlogd $0xd8,-0x138784d(%rip){1to16},%zmm15,%zmm6        # 580654 <tier0_emit_x87.operations+0x20c>
 1907ea1:	62 91 25 40 eb fe    	vpord  %zmm30,%zmm27,%zmm7
 1907ea7:	62 f1 7d 48 70 c7 00 	vpshufd $0x0,%zmm7,%zmm0
 1907eae:	62 f2 7d 48 8f dc    	vpshufbitqmb %zmm4,%zmm0,%k3
 1907eb4:	62 f1 7d 48 70 c7 55 	vpshufd $0x55,%zmm7,%zmm0
 1907ebb:	62 d2 7d 48 8f d0    	vpshufbitqmb %zmm8,%zmm0,%k2
 1907ec1:	62 f1 7d 48 70 c7 aa 	vpshufd $0xaa,%zmm7,%zmm0
 1907ec8:	c4 61 fb 93 cb       	kmovq  %k3,%r9
 1907ecd:	f3 4d 0f b8 c9       	popcnt %r9,%r9
 1907ed2:	c4 61 fb 93 d2       	kmovq  %k2,%r10
 1907ed7:	f3 4d 0f b8 d2       	popcnt %r10,%r10
 1907edc:	62 f3 75 50 25 15 69 87 c7 fe e4 	vpternlogd $0xe4,-0x1387897(%rip){1to16},%zmm17,%zmm2        # 580650 <tier0_emit_x87.operations+0x208>
 1907ee7:	62 f3 6d 58 25 35 66 87 c7 fe d8 	vpternlogd $0xd8,-0x138789a(%rip){1to16},%zmm2,%zmm6        # 580658 <tier0_emit_x87.operations+0x210>
 1907ef2:	62 91 75 48 62 d2    	vpunpckldq %zmm26,%zmm1,%zmm2
 1907ef8:	62 91 75 48 6a ca    	vpunpckhdq %zmm26,%zmm1,%zmm1
 1907efe:	62 71 65 40 62 fe    	vpunpckldq %zmm6,%zmm19,%zmm15
 1907f04:	62 f1 65 40 6a f6    	vpunpckhdq %zmm6,%zmm19,%zmm6
 1907f0a:	62 c1 ed 48 6c cf    	vpunpcklqdq %zmm15,%zmm2,%zmm17
 1907f10:	62 d1 ed 48 6d d7    	vpunpckhqdq %zmm15,%zmm2,%zmm2
 1907f16:	62 e1 f5 48 6c d6    	vpunpcklqdq %zmm6,%zmm1,%zmm18
 1907f1c:	62 f1 f5 48 6d ce    	vpunpckhqdq %zmm6,%zmm1,%zmm1
 1907f22:	62 f2 75 40 00 e4    	vpshufb %zmm4,%zmm17,%zmm4
 1907f28:	62 d2 6d 48 00 d0    	vpshufb %zmm8,%zmm2,%zmm2
 1907f2e:	62 d2 75 48 00 ce    	vpshufb %zmm14,%zmm1,%zmm1
 1907f34:	62 f3 d5 48 25 e3 78 	vpternlogq $0x78,%zmm3,%zmm5,%zmm4
 1907f3b:	62 f3 ad 48 25 d3 78 	vpternlogq $0x78,%zmm3,%zmm10,%zmm2
 1907f42:	62 f3 fd 40 25 cb 78 	vpternlogq $0x78,%zmm3,%zmm16,%zmm1
 1907f49:	62 f2 7d cb 63 e4    	vpcompressb %zmm4,%zmm4{%k3}{z}
 1907f4f:	62 f2 7d ca 63 d2    	vpcompressb %zmm2,%zmm2{%k2}{z}
 1907f55:	62 d2 7d 48 8f db    	vpshufbitqmb %zmm11,%zmm0,%k3
 1907f5b:	62 f1 7d 48 70 c7 ff 	vpshufd $0xff,%zmm7,%zmm0
 1907f62:	62 d2 7d 48 8f d6    	vpshufbitqmb %zmm14,%zmm0,%k2
 1907f68:	c4 61 fb 93 db       	kmovq  %k3,%r11
 1907f6d:	62 f2 7d ca 63 c9    	vpcompressb %zmm1,%zmm1{%k2}{z}
 1907f73:	62 d1 fe 48 7f 26    	vmovdqu64 %zmm4,(%r14)
 1907f79:	62 d2 6d 40 00 e3    	vpshufb %zmm11,%zmm18,%zmm4
 1907f7f:	62 91 fe 48 7f 14 0e 	vmovdqu64 %zmm2,(%r14,%r9,1)
 1907f86:	4d 01 f1             	add    %r14,%r9
 1907f89:	62 f3 95 48 25 e3 78 	vpternlogq $0x78,%zmm3,%zmm13,%zmm4
 1907f90:	c5 e9 ef d2          	vpxor  %xmm2,%xmm2,%xmm2
 1907f94:	62 f2 7d cb 63 e2    	vpcompressb %zmm4,%zmm2{%k3}{z}
 1907f9a:	62 91 fe 48 7f 14 0a 	vmovdqu64 %zmm2,(%r10,%r9,1)
 1907fa1:	4d 01 d1             	add    %r10,%r9
 1907fa4:	f3 4d 0f b8 d3       	popcnt %r11,%r10
 1907fa9:	c4 61 fb 93 da       	kmovq  %k2,%r11
 1907fae:	f3 4d 0f b8 f3       	popcnt %r11,%r14
 1907fb3:	62 91 fe 48 7f 0c 0a 	vmovdqu64 %zmm1,(%r10,%r9,1)
 1907fba:	4d 01 d6             	add    %r10,%r14
 1907fbd:	4d 01 ce             	add    %r9,%r14
 1907fc0:	48 ff c9             	dec    %rcx
 1907fc3:	0f 85 a7 fa ff ff    	jne    1907a70 <x86_encode_16+0x13a0>
 1907fc9:	48 8d 48 10          	lea    0x10(%rax),%rcx
 1907fcd:	48 39 d1             	cmp    %rdx,%rcx
 1907fd0:	0f 87 a3 05 00 00    	ja     1908579 <x86_encode_16+0x1ea9>
 1907fd6:	62 f2 7d 48 5a 1d 00 e4 c6 fe 	vbroadcasti32x4 -0x1391c00(%rip),%zmm3        # 5763e0 <x86_effects_unknown+0x980>
 1907fe0:	62 72 7d 48 58 0d 36 86 c7 fe 	vpbroadcastd -0x13879ca(%rip),%zmm9        # 580620 <tier0_emit_x87.operations+0x1d8>
 1907fea:	48 89 d1             	mov    %rdx,%rcx
 1907fed:	48 29 c1             	sub    %rax,%rcx
 1907ff0:	48 89 c7             	mov    %rax,%rdi
 1907ff3:	48 c1 e7 04          	shl    $0x4,%rdi
 1907ff7:	41 b1 cc             	mov    $0xcc,%r9b
 1907ffa:	4c 8d 05 7f e3 d5 0c 	lea    0xcd5e37f(%rip),%r8        # e666380 <x86_template_storage>
 1908001:	62 53 1d 48 25 e4 ff 	vpternlogd $0xff,%zmm12,%zmm12,%zmm12
 1908008:	48 83 c1 f0          	add    $0xfffffffffffffff0,%rcx
 190800c:	48 8d bc 37 fc 00 00 00 	lea    0xfc(%rdi,%rsi,1),%rdi
 1908014:	c4 c1 7b 92 c9       	kmovd  %r9d,%k1
 1908019:	48 c1 e9 04          	shr    $0x4,%rcx
 190801d:	48 ff c1             	inc    %rcx
 1908020:	44 0f b7 8f 10 ff ff ff 	movzwl -0xf0(%rdi),%r9d
 1908028:	44 0f b7 97 20 ff ff ff 	movzwl -0xe0(%rdi),%r10d
 1908030:	44 0f b7 9f 30 ff ff ff 	movzwl -0xd0(%rdi),%r11d
 1908038:	44 0f b7 bf 40 ff ff ff 	movzwl -0xc0(%rdi),%r15d
 1908040:	62 e1 fe 48 6f 9f 04 ff ff ff 	vmovdqu64 -0xfc(%rdi),%zmm19
 190804a:	62 e1 fe 48 6f af 44 ff ff ff 	vmovdqu64 -0xbc(%rdi),%zmm21
 1908054:	62 e1 fe 48 6f b7 84 ff ff ff 	vmovdqu64 -0x7c(%rdi),%zmm22
 190805e:	62 e1 fe 48 6f bf c4 ff ff ff 	vmovdqu64 -0x3c(%rdi),%zmm23
 1908068:	62 f2 7d 48 5a 0d ae e3 c6 fe 	vbroadcasti32x4 -0x1391c52(%rip),%zmm1        # 576420 <x86_effects_unknown+0x9c0>
 1908072:	48 83 c0 10          	add    $0x10,%rax
 1908076:	41 c1 e1 06          	shl    $0x6,%r9d
 190807a:	41 c1 e2 06          	shl    $0x6,%r10d
 190807e:	41 c1 e3 06          	shl    $0x6,%r11d
 1908082:	41 c1 e7 06          	shl    $0x6,%r15d
 1908086:	c4 81 7d 6f 64 01 40 	vmovdqa 0x40(%r9,%r8,1),%ymm4
 190808d:	44 0f b7 8f 50 ff ff ff 	movzwl -0xb0(%rdi),%r9d
 1908095:	c4 81 7d 6f 6c 02 60 	vmovdqa 0x60(%r10,%r8,1),%ymm5
 190809c:	44 0f b7 97 60 ff ff ff 	movzwl -0xa0(%rdi),%r10d
 19080a4:	62 93 dd 48 3a 64 03 02 01 	vinserti64x4 $0x1,0x40(%r11,%r8,1),%zmm4,%zmm4
 19080ad:	62 13 d5 48 3a 7c 07 03 01 	vinserti64x4 $0x1,0x60(%r15,%r8,1),%zmm5,%zmm15
 19080b6:	44 0f b7 9f 70 ff ff ff 	movzwl -0x90(%rdi),%r11d
 19080be:	44 0f b7 7f 80       	movzwl -0x80(%rdi),%r15d
 19080c3:	62 b1 65 40 62 f5    	vpunpckldq %zmm21,%zmm19,%zmm6
 19080c9:	62 b1 4d 40 62 ff    	vpunpckldq %zmm23,%zmm22,%zmm7
 19080cf:	62 a1 4d 40 6a f7    	vpunpckhdq %zmm23,%zmm22,%zmm22
 19080d5:	62 a1 65 40 6a ed    	vpunpckhdq %zmm21,%zmm19,%zmm21
 19080db:	62 b1 d5 40 6c d6    	vpunpcklqdq %zmm22,%zmm21,%zmm2
 19080e1:	62 e1 cd 48 6d ff    	vpunpckhqdq %zmm7,%zmm6,%zmm23
 19080e7:	62 62 f5 48 83 da    	vpmultishiftqb %zmm2,%zmm1,%zmm27
 19080ed:	62 f2 7d 48 5a 0d 49 e3 c6 fe 	vbroadcasti32x4 -0x1391cb7(%rip),%zmm1        # 576440 <x86_effects_unknown+0x9e0>
 19080f7:	62 f1 15 40 72 d2 1a 	vpsrld $0x1a,%zmm2,%zmm29
 19080fe:	62 b2 45 40 27 c7    	vptestmd %zmm23,%zmm23,%k0
 1908104:	62 e1 fd 48 6f da    	vmovdqa64 %zmm2,%zmm19
 190810a:	41 c1 e1 06          	shl    $0x6,%r9d
 190810e:	41 c1 e2 06          	shl    $0x6,%r10d
 1908112:	c4 01 7d 6f 44 01 40 	vmovdqa 0x40(%r9,%r8,1),%ymm8
 1908119:	44 0f b7 4f 90       	movzwl -0x70(%rdi),%r9d
 190811e:	41 c1 e3 06          	shl    $0x6,%r11d
 1908122:	c4 01 7d 6f 54 02 60 	vmovdqa 0x60(%r10,%r8,1),%ymm10
 1908129:	44 0f b7 57 a0       	movzwl -0x60(%rdi),%r10d
 190812e:	41 c1 e7 06          	shl    $0x6,%r15d
 1908132:	62 13 bd 48 3a 44 03 02 01 	vinserti64x4 $0x1,0x40(%r11,%r8,1),%zmm8,%zmm8
 190813b:	62 83 ad 48 3a 4c 07 03 01 	vinserti64x4 $0x1,0x60(%r15,%r8,1),%zmm10,%zmm17
 1908144:	44 0f b7 5f b0       	movzwl -0x50(%rdi),%r11d
 1908149:	44 0f b7 7f c0       	movzwl -0x40(%rdi),%r15d
 190814e:	62 d2 dd 49 64 ef    	vpblendmq %zmm15,%zmm4,%zmm5{%k1}
 1908154:	41 c1 e1 06          	shl    $0x6,%r9d
 1908158:	41 c1 e2 06          	shl    $0x6,%r10d
 190815c:	c4 01 7d 6f 5c 01 40 	vmovdqa 0x40(%r9,%r8,1),%ymm11
 1908163:	44 0f b7 4f d0       	movzwl -0x30(%rdi),%r9d
 1908168:	41 c1 e3 06          	shl    $0x6,%r11d
 190816c:	c4 01 7d 6f 6c 02 60 	vmovdqa 0x60(%r10,%r8,1),%ymm13
 1908173:	44 0f b7 57 e0       	movzwl -0x20(%rdi),%r10d
 1908178:	41 c1 e7 06          	shl    $0x6,%r15d
 190817c:	62 62 f5 48 83 f2    	vpmultishiftqb %zmm2,%zmm1,%zmm30
 1908182:	62 f2 7d 48 5a 0d a4 e2 c6 fe 	vbroadcasti32x4 -0x1391d5c(%rip),%zmm1        # 576430 <x86_effects_unknown+0x9d0>
 190818c:	62 63 25 50 25 35 65 84 c7 fe d8 	vpternlogd $0xd8,-0x1387b9b(%rip){1to16},%zmm27,%zmm30        # 5805fc <tier0_emit_x87.operations+0x1b4>
 1908197:	62 13 a5 48 3a 5c 03 02 01 	vinserti64x4 $0x1,0x40(%r11,%r8,1),%zmm11,%zmm11
 19081a0:	62 83 95 48 3a 54 07 03 01 	vinserti64x4 $0x1,0x60(%r15,%r8,1),%zmm13,%zmm18
 19081a9:	44 0f b7 5f f0       	movzwl -0x10(%rdi),%r11d
 19081ae:	44 0f b7 3f          	movzwl (%rdi),%r15d
 19081b2:	48 81 c7 00 01 00 00 	add    $0x100,%rdi
 19081b9:	62 32 bd 49 64 d1    	vpblendmq %zmm17,%zmm8,%zmm10{%k1}
 19081bf:	62 41 55 48 6a c2    	vpunpckhdq %zmm10,%zmm5,%zmm24
 19081c5:	41 c1 e1 06          	shl    $0x6,%r9d
 19081c9:	41 c1 e2 06          	shl    $0x6,%r10d
 19081cd:	41 c1 e3 06          	shl    $0x6,%r11d
 19081d1:	c4 01 7d 6f 74 01 40 	vmovdqa 0x40(%r9,%r8,1),%ymm14
 19081d8:	41 c1 e7 06          	shl    $0x6,%r15d
 19081dc:	62 81 fd 28 6f 44 02 03 	vmovdqa64 0x60(%r10,%r8,1),%ymm16
 19081e4:	62 13 8d 48 3a 74 03 02 01 	vinserti64x4 $0x1,0x40(%r11,%r8,1),%zmm14,%zmm14
 19081ed:	62 83 fd 40 3a 64 07 03 01 	vinserti64x4 $0x1,0x60(%r15,%r8,1),%zmm16,%zmm20
 19081f6:	62 62 f5 48 83 e2    	vpmultishiftqb %zmm2,%zmm1,%zmm28
 19081fc:	62 f1 75 48 72 f2 04 	vpslld $0x4,%zmm2,%zmm1
 1908203:	62 63 0d 50 25 25 f2 83 c7 fe e4 	vpternlogd $0xe4,-0x1387c0e(%rip){1to16},%zmm30,%zmm28        # 580600 <tier0_emit_x87.operations+0x1b8>
 190820e:	62 f1 25 40 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm27
 1908215:	62 f2 7d 48 5a 0d 31 e2 c6 fe 	vbroadcasti32x4 -0x1391dcf(%rip),%zmm1        # 576450 <x86_effects_unknown+0x9f0>
 190821f:	62 32 a5 49 64 ea    	vpblendmq %zmm18,%zmm11,%zmm13{%k1}
 1908225:	62 a2 8d 49 64 c4    	vpblendmq %zmm20,%zmm14,%zmm16{%k1}
 190822b:	62 21 15 48 6a c8    	vpunpckhdq %zmm16,%zmm13,%zmm25
 1908231:	62 01 bd 40 6d d1    	vpunpckhqdq %zmm25,%zmm24,%zmm26
 1908237:	62 62 15 40 36 0d 7f a3 c1 fe 	vpermd -0x13e5c81(%rip),%zmm29,%zmm25        # 5225c0 <branch_sizing_patterns+0x2830>
 1908241:	62 62 15 40 36 05 b5 a3 c1 fe 	vpermd -0x13e5c4b(%rip),%zmm29,%zmm24        # 522600 <branch_sizing_patterns+0x2870>
 190824b:	62 62 75 48 00 f2    	vpshufb %zmm2,%zmm1,%zmm30
 1908251:	62 f2 7d 48 58 0d ad 83 c7 fe 	vpbroadcastd -0x1387c53(%rip),%zmm1        # 580608 <tier0_emit_x87.operations+0x1c0>
 190825b:	62 62 15 40 36 2d db a3 c1 fe 	vpermd -0x13e5c25(%rip),%zmm29,%zmm29        # 522640 <branch_sizing_patterns+0x28b0>
 1908265:	62 91 7d 48 72 f6 10 	vpslld $0x10,%zmm30,%zmm0
 190826c:	62 01 25 40 db f6    	vpandd %zmm30,%zmm27,%zmm30
 1908272:	62 f1 05 40 72 e0 1f 	vpsrad $0x1f,%zmm0,%zmm31
 1908279:	62 b1 7d 48 72 e7 1f 	vpsrad $0x1f,%zmm23,%zmm0
 1908280:	62 03 1d 40 25 c1 f8 	vpternlogd $0xf8,%zmm25,%zmm28,%zmm24
 1908287:	62 62 7e 48 38 c8    	vpmovm2d %k0,%zmm25
 190828d:	62 03 25 40 25 cf c8 	vpternlogd $0xc8,%zmm31,%zmm27,%zmm25
 1908294:	62 21 7d 48 ef ff    	vpxord %zmm23,%zmm0,%zmm31
 190829a:	62 f2 7d 48 58 05 60 83 c7 fe 	vpbroadcastd -0x1387ca0(%rip),%zmm0        # 580604 <tier0_emit_x87.operations+0x1bc>
 19082a4:	62 63 15 50 25 35 8d 83 c7 fe ec 	vpternlogd $0xec,-0x1387c73(%rip){1to16},%zmm29,%zmm30        # 58063c <tier0_emit_x87.operations+0x1f4>
 19082af:	62 91 15 40 72 d2 1d 	vpsrld $0x1d,%zmm26,%zmm29
 19082b6:	62 02 7d 48 44 ff    	vplzcntd %zmm31,%zmm31
 19082bc:	62 63 2d 50 25 35 79 83 c7 fe f8 	vpternlogd $0xf8,-0x1387c87(%rip){1to16},%zmm26,%zmm30        # 580640 <tier0_emit_x87.operations+0x1f8>
 19082c7:	62 02 75 48 45 ff    	vpsrlvd %zmm31,%zmm1,%zmm31
 19082cd:	62 d1 45 40 fe cc    	vpaddd %zmm12,%zmm23,%zmm1
 19082d3:	62 93 45 40 25 cf 14 	vpternlogd $0x14,%zmm31,%zmm23,%zmm1
 19082da:	62 f1 05 40 72 d2 08 	vpsrld $0x8,%zmm2,%zmm31
 19082e1:	62 92 75 48 14 cd    	vprorvd %zmm29,%zmm1,%zmm1
 19082e7:	62 f1 75 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm1
 19082ee:	62 e3 7d 58 25 1d 1b 83 c7 fe 6c 	vpternlogd $0x6c,-0x1387ce5(%rip){1to16},%zmm0,%zmm19        # 580614 <tier0_emit_x87.operations+0x1cc>
 19082f9:	62 63 7d 58 25 3d 14 83 c7 fe 6c 	vpternlogd $0x6c,-0x1387cec(%rip){1to16},%zmm0,%zmm31        # 580618 <tier0_emit_x87.operations+0x1d0>
 1908304:	62 f1 1d 50 db 05 1a 83 c7 fe 	vpandd -0x1387ce6(%rip){1to16},%zmm28,%zmm0        # 580628 <tier0_emit_x87.operations+0x1e0>
 190830e:	62 91 1d 40 72 d4 03 	vpsrld $0x3,%zmm28,%zmm28
 1908315:	62 63 2d 50 25 25 14 83 c7 fe a2 	vpternlogd $0xa2,-0x1387cec(%rip){1to16},%zmm26,%zmm28        # 580634 <tier0_emit_x87.operations+0x1ec>
 1908320:	62 c1 65 40 fe dc    	vpaddd %zmm12,%zmm19,%zmm19
 1908326:	62 e3 35 58 25 1d eb 82 c7 fe ec 	vpternlogd $0xec,-0x1387d15(%rip){1to16},%zmm9,%zmm19        # 58061c <tier0_emit_x87.operations+0x1d4>
 1908331:	62 41 05 40 fe fc    	vpaddd %zmm12,%zmm31,%zmm31
 1908337:	62 63 65 50 25 3d e2 82 c7 fe ec 	vpternlogd $0xec,-0x1387d1e(%rip){1to16},%zmm19,%zmm31        # 580624 <tier0_emit_x87.operations+0x1dc>
 1908342:	62 93 2d 40 25 c7 f8 	vpternlogd $0xf8,%zmm31,%zmm26,%zmm0
 1908349:	62 e2 7d 58 3b 1d d9 82 c7 fe 	vpminud -0x1387d27(%rip){1to16},%zmm0,%zmm19        # 58062c <tier0_emit_x87.operations+0x1e4>
 1908353:	62 f2 1d 50 3b 05 db 82 c7 fe 	vpminud -0x1387d25(%rip){1to16},%zmm28,%zmm0        # 580638 <tier0_emit_x87.operations+0x1f0>
 190835d:	62 01 fd 48 6f d0    	vmovdqa64 %zmm24,%zmm26
 1908363:	62 63 35 50 25 15 9e 82 c7 fe f8 	vpternlogd $0xf8,-0x1387d62(%rip){1to16},%zmm25,%zmm26        # 58060c <tier0_emit_x87.operations+0x1c4>
 190836e:	62 61 35 50 db 3d cc 82 c7 fe 	vpandd -0x1387d34(%rip){1to16},%zmm25,%zmm31        # 580644 <tier0_emit_x87.operations+0x1fc>
 1908378:	62 23 7d 48 25 f3 fe 	vpternlogd $0xfe,%zmm19,%zmm0,%zmm30
 190837f:	62 81 fd 48 6f d8    	vmovdqa64 %zmm24,%zmm19
 1908385:	62 e3 25 50 25 1d 80 82 c7 fe f8 	vpternlogd $0xf8,-0x1387d80(%rip){1to16},%zmm27,%zmm19        # 580610 <tier0_emit_x87.operations+0x1c8>
 1908390:	62 b1 7d 48 72 cf 01 	vprold $0x1,%zmm23,%zmm0
 1908397:	62 61 25 50 db 1d a7 82 c7 fe 	vpandd -0x1387d59(%rip){1to16},%zmm27,%zmm27        # 580648 <tier0_emit_x87.operations+0x200>
 19083a1:	62 83 75 48 25 da b8 	vpternlogd $0xb8,%zmm26,%zmm1,%zmm19
 19083a8:	62 02 7d 48 14 d5    	vprorvd %zmm29,%zmm0,%zmm26
 19083ae:	62 f1 fd 48 6f 05 c8 a1 c1 fe 	vmovdqa64 -0x13e5e38(%rip),%zmm0        # 522580 <branch_sizing_patterns+0x27f0>
 19083b8:	62 03 75 48 25 df b8 	vpternlogd $0xb8,%zmm31,%zmm1,%zmm27
 19083bf:	62 23 35 40 25 d7 e2 	vpternlogd $0xe2,%zmm23,%zmm25,%zmm26
 19083c6:	62 23 75 48 25 d7 e2 	vpternlogd $0xe2,%zmm23,%zmm1,%zmm26
 19083cd:	62 f1 cd 48 6c cf    	vpunpcklqdq %zmm7,%zmm6,%zmm1
 19083d3:	62 d1 1d 40 fe fc    	vpaddd %zmm12,%zmm28,%zmm7
 19083d9:	62 b1 d5 40 6d f6    	vpunpckhqdq %zmm22,%zmm21,%zmm6
 19083df:	62 f1 45 48 72 e7 1f 	vpsrad $0x1f,%zmm7,%zmm7
 19083e6:	62 f1 4d 48 eb d2    	vpord  %zmm2,%zmm6,%zmm2
 19083ec:	62 f1 6d 48 72 f2 07 	vpslld $0x7,%zmm2,%zmm2
 19083f3:	62 d2 fd 48 7e e7    	vpermt2q %zmm15,%zmm0,%zmm4
 19083f9:	62 32 fd 48 7e c1    	vpermt2q %zmm17,%zmm0,%zmm8
 19083ff:	62 32 fd 48 7e da    	vpermt2q %zmm18,%zmm0,%zmm11
 1908405:	62 32 fd 48 7e f4    	vpermt2q %zmm20,%zmm0,%zmm14
 190840b:	62 91 7d 48 72 d0 10 	vpsrld $0x10,%zmm24,%zmm0
 1908412:	62 91 05 48 72 d0 03 	vpsrld $0x3,%zmm24,%zmm15
 1908419:	62 73 7d 58 25 3d 0c 82 c7 fe ec 	vpternlogd $0xec,-0x1387df4(%rip){1to16},%zmm0,%zmm15        # 580630 <tier0_emit_x87.operations+0x1e8>
 1908424:	62 f2 7d 48 5a 05 32 e0 c6 fe 	vbroadcasti32x4 -0x1391fce(%rip),%zmm0        # 576460 <x86_effects_unknown+0xa00>
 190842e:	62 d1 75 40 72 f7 08 	vpslld $0x8,%zmm15,%zmm17
 1908435:	62 e3 45 58 25 0d 0c 82 c7 fe 08 	vpternlogd $0x8,-0x1387df4(%rip){1to16},%zmm7,%zmm17        # 58064c <tier0_emit_x87.operations+0x204>
 1908440:	62 f2 fd 48 83 f6    	vpmultishiftqb %zmm6,%zmm0,%zmm6
 1908446:	62 f3 05 58 25 35 03 82 c7 fe d8 	vpternlogd $0xd8,-0x1387dfd(%rip){1to16},%zmm15,%zmm6        # 580654 <tier0_emit_x87.operations+0x20c>
 1908451:	62 91 25 40 eb fe    	vpord  %zmm30,%zmm27,%zmm7
 1908457:	62 f1 7d 48 70 c7 00 	vpshufd $0x0,%zmm7,%zmm0
 190845e:	62 f2 7d 48 8f dc    	vpshufbitqmb %zmm4,%zmm0,%k3
 1908464:	62 f1 7d 48 70 c7 55 	vpshufd $0x55,%zmm7,%zmm0
 190846b:	62 d2 7d 48 8f d0    	vpshufbitqmb %zmm8,%zmm0,%k2
 1908471:	62 f1 7d 48 70 c7 aa 	vpshufd $0xaa,%zmm7,%zmm0
 1908478:	c4 61 fb 93 cb       	kmovq  %k3,%r9
 190847d:	f3 4d 0f b8 c9       	popcnt %r9,%r9
 1908482:	c4 61 fb 93 d2       	kmovq  %k2,%r10
 1908487:	f3 4d 0f b8 d2       	popcnt %r10,%r10
 190848c:	62 f3 75 50 25 15 b9 81 c7 fe e4 	vpternlogd $0xe4,-0x1387e47(%rip){1to16},%zmm17,%zmm2        # 580650 <tier0_emit_x87.operations+0x208>
 1908497:	62 f3 6d 58 25 35 b6 81 c7 fe d8 	vpternlogd $0xd8,-0x1387e4a(%rip){1to16},%zmm2,%zmm6        # 580658 <tier0_emit_x87.operations+0x210>
 19084a2:	62 91 75 48 62 d2    	vpunpckldq %zmm26,%zmm1,%zmm2
 19084a8:	62 91 75 48 6a ca    	vpunpckhdq %zmm26,%zmm1,%zmm1
 19084ae:	62 71 65 40 62 fe    	vpunpckldq %zmm6,%zmm19,%zmm15
 19084b4:	62 f1 65 40 6a f6    	vpunpckhdq %zmm6,%zmm19,%zmm6
 19084ba:	62 c1 ed 48 6c cf    	vpunpcklqdq %zmm15,%zmm2,%zmm17
 19084c0:	62 d1 ed 48 6d d7    	vpunpckhqdq %zmm15,%zmm2,%zmm2
 19084c6:	62 e1 f5 48 6c d6    	vpunpcklqdq %zmm6,%zmm1,%zmm18
 19084cc:	62 f1 f5 48 6d ce    	vpunpckhqdq %zmm6,%zmm1,%zmm1
 19084d2:	62 f2 75 40 00 e4    	vpshufb %zmm4,%zmm17,%zmm4
 19084d8:	62 d2 6d 48 00 d0    	vpshufb %zmm8,%zmm2,%zmm2
 19084de:	62 d2 75 48 00 ce    	vpshufb %zmm14,%zmm1,%zmm1
 19084e4:	62 f3 d5 48 25 e3 78 	vpternlogq $0x78,%zmm3,%zmm5,%zmm4
 19084eb:	62 f3 ad 48 25 d3 78 	vpternlogq $0x78,%zmm3,%zmm10,%zmm2
 19084f2:	62 f3 fd 40 25 cb 78 	vpternlogq $0x78,%zmm3,%zmm16,%zmm1
 19084f9:	62 f2 7d cb 63 e4    	vpcompressb %zmm4,%zmm4{%k3}{z}
 19084ff:	62 f2 7d ca 63 d2    	vpcompressb %zmm2,%zmm2{%k2}{z}
 1908505:	62 d2 7d 48 8f db    	vpshufbitqmb %zmm11,%zmm0,%k3
 190850b:	62 f1 7d 48 70 c7 ff 	vpshufd $0xff,%zmm7,%zmm0
 1908512:	62 d2 7d 48 8f d6    	vpshufbitqmb %zmm14,%zmm0,%k2
 1908518:	c4 61 fb 93 db       	kmovq  %k3,%r11
 190851d:	62 f2 7d ca 63 c9    	vpcompressb %zmm1,%zmm1{%k2}{z}
 1908523:	62 d1 fe 48 7f 26    	vmovdqu64 %zmm4,(%r14)
 1908529:	62 d2 6d 40 00 e3    	vpshufb %zmm11,%zmm18,%zmm4
 190852f:	62 91 fe 48 7f 14 0e 	vmovdqu64 %zmm2,(%r14,%r9,1)
 1908536:	4d 01 f1             	add    %r14,%r9
 1908539:	62 f3 95 48 25 e3 78 	vpternlogq $0x78,%zmm3,%zmm13,%zmm4
 1908540:	c5 e9 ef d2          	vpxor  %xmm2,%xmm2,%xmm2
 1908544:	62 f2 7d cb 63 e2    	vpcompressb %zmm4,%zmm2{%k3}{z}
 190854a:	62 91 fe 48 7f 14 0a 	vmovdqu64 %zmm2,(%r10,%r9,1)
 1908551:	4d 01 d1             	add    %r10,%r9
 1908554:	f3 4d 0f b8 d3       	popcnt %r11,%r10
 1908559:	c4 61 fb 93 da       	kmovq  %k2,%r11
 190855e:	f3 4d 0f b8 f3       	popcnt %r11,%r14
 1908563:	62 91 fe 48 7f 0c 0a 	vmovdqu64 %zmm1,(%r10,%r9,1)
 190856a:	4d 01 d6             	add    %r10,%r14
 190856d:	4d 01 ce             	add    %r9,%r14
 1908570:	48 ff c9             	dec    %rcx
 1908573:	0f 85 a7 fa ff ff    	jne    1908020 <x86_encode_16+0x1950>
 1908579:	48 29 c2             	sub    %rax,%rdx
 190857c:	0f 86 e6 05 00 00    	jbe    1908b68 <x86_encode_16+0x2498>
 1908582:	48 c1 e0 04          	shl    $0x4,%rax
 1908586:	48 c1 e2 04          	shl    $0x4,%rdx
 190858a:	48 8d 7c 24 40       	lea    0x40(%rsp),%rdi
 190858f:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 1908593:	62 f1 fd 48 7f 44 24 04 	vmovdqa64 %zmm0,0x100(%rsp)
 190859b:	62 f1 fd 48 7f 44 24 03 	vmovdqa64 %zmm0,0xc0(%rsp)
 19085a3:	62 f1 fd 48 7f 44 24 02 	vmovdqa64 %zmm0,0x80(%rsp)
 19085ab:	62 f1 fd 48 7f 44 24 01 	vmovdqa64 %zmm0,0x40(%rsp)
 19085b3:	48 01 c6             	add    %rax,%rsi
 19085b6:	c5 f8 77             	vzeroupper
 19085b9:	e8 92 be e5 fe       	call   764450 <memcpy@plt>
 19085be:	c5 f9 6f 64 24 70    	vmovdqa 0x70(%rsp),%xmm4
 19085c4:	c5 f9 6f 4c 24 40    	vmovdqa 0x40(%rsp),%xmm1
 19085ca:	c5 f9 6f 54 24 50    	vmovdqa 0x50(%rsp),%xmm2
 19085d0:	c5 f9 6f 5c 24 60    	vmovdqa 0x60(%rsp),%xmm3
 19085d6:	c5 f9 6f ac 24 80 00 00 00 	vmovdqa 0x80(%rsp),%xmm5
 19085df:	48 8d 05 9a dd d5 0c 	lea    0xcd5dd9a(%rip),%rax        # e666380 <x86_template_storage>
 19085e6:	62 71 fd 48 6f 3d 90 9f c1 fe 	vmovdqa64 -0x13e6070(%rip),%zmm15        # 522580 <branch_sizing_patterns+0x27f0>
 19085f0:	c5 f9 6f bc 24 c0 00 00 00 	vmovdqa 0xc0(%rsp),%xmm7
 19085f9:	c5 f9 6f b4 24 d0 00 00 00 	vmovdqa 0xd0(%rsp),%xmm6
 1908602:	62 71 fd 48 6f 4c 24 01 	vmovdqa64 0x40(%rsp),%zmm9
 190860a:	62 71 fd 48 6f 54 24 02 	vmovdqa64 0x80(%rsp),%zmm10
 1908612:	62 71 fd 48 6f 5c 24 03 	vmovdqa64 0xc0(%rsp),%zmm11
 190861a:	62 71 fd 48 6f 64 24 04 	vmovdqa64 0x100(%rsp),%zmm12
 1908622:	62 e2 7d 48 5a 0d 04 de c6 fe 	vbroadcasti32x4 -0x13921fc(%rip),%zmm17        # 576430 <x86_effects_unknown+0x9d0>
 190862c:	62 a3 4d 40 25 f6 ff 	vpternlogd $0xff,%zmm22,%zmm22,%zmm22
 1908633:	62 e2 7d 48 58 25 c7 7f c7 fe 	vpbroadcastd -0x1388039(%rip),%zmm20        # 580604 <tier0_emit_x87.operations+0x1bc>
 190863d:	62 62 7d 48 58 15 c9 7f c7 fe 	vpbroadcastd -0x1388037(%rip),%zmm26        # 580610 <tier0_emit_x87.operations+0x1c8>
 1908647:	62 62 7d 48 58 0d c3 7f c7 fe 	vpbroadcastd -0x138803d(%rip),%zmm25        # 580614 <tier0_emit_x87.operations+0x1cc>
 1908651:	c5 f9 c5 fc 06       	vpextrw $0x6,%xmm4,%edi
 1908656:	c5 f9 6f a4 24 90 00 00 00 	vmovdqa 0x90(%rsp),%xmm4
 190865f:	c5 f9 c5 c9 06       	vpextrw $0x6,%xmm1,%ecx
 1908664:	c5 f9 c5 d2 06       	vpextrw $0x6,%xmm2,%edx
 1908669:	c5 f9 c5 f3 06       	vpextrw $0x6,%xmm3,%esi
 190866e:	62 51 35 48 62 ea    	vpunpckldq %zmm10,%zmm9,%zmm13
 1908674:	62 51 25 48 62 f4    	vpunpckldq %zmm12,%zmm11,%zmm14
 190867a:	62 51 35 48 6a d2    	vpunpckhdq %zmm10,%zmm9,%zmm10
 1908680:	62 51 25 48 6a e4    	vpunpckhdq %zmm12,%zmm11,%zmm12
 1908686:	c1 e1 06             	shl    $0x6,%ecx
 1908689:	c1 e2 06             	shl    $0x6,%edx
 190868c:	c1 e6 06             	shl    $0x6,%esi
 190868f:	c1 e7 06             	shl    $0x6,%edi
 1908692:	62 51 ad 48 6c dc    	vpunpcklqdq %zmm12,%zmm10,%zmm11
 1908698:	62 d1 95 48 6c c6    	vpunpcklqdq %zmm14,%zmm13,%zmm0
 190869e:	62 51 95 48 6d ce    	vpunpckhqdq %zmm14,%zmm13,%zmm9
 19086a4:	62 51 ad 48 6d e4    	vpunpckhqdq %zmm12,%zmm10,%zmm12
 19086aa:	c5 fd 6f 4c 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm1
 19086b0:	b1 cc                	mov    $0xcc,%cl
 19086b2:	c5 fd 6f 54 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm2
 19086b8:	62 c2 f5 40 83 db    	vpmultishiftqb %zmm11,%zmm17,%zmm19
 19086be:	62 d2 35 48 27 c1    	vptestmd %zmm9,%zmm9,%k0
 19086c4:	62 d1 75 40 72 e1 1f 	vpsrad $0x1f,%zmm9,%zmm17
 19086cb:	62 21 35 48 fe c6    	vpaddd %zmm22,%zmm9,%zmm24
 19086d1:	62 43 5d 40 25 cb 6c 	vpternlogd $0x6c,%zmm11,%zmm20,%zmm25
 19086d8:	c5 fb 92 c9          	kmovd  %ecx,%k1
 19086dc:	c5 f9 c5 cd 06       	vpextrw $0x6,%xmm5,%ecx
 19086e1:	c5 f9 6f ac 24 a0 00 00 00 	vmovdqa 0xa0(%rsp),%xmm5
 19086ea:	62 f3 f5 48 3a 4c 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm1,%zmm1
 19086f3:	62 f3 ed 48 3a 5c 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm2,%zmm3
 19086fc:	c1 e1 06             	shl    $0x6,%ecx
 19086ff:	c5 f9 c5 d4 06       	vpextrw $0x6,%xmm4,%edx
 1908704:	c5 f9 6f a4 24 b0 00 00 00 	vmovdqa 0xb0(%rsp),%xmm4
 190870d:	c1 e2 06             	shl    $0x6,%edx
 1908710:	c5 f9 c5 f5 06       	vpextrw $0x6,%xmm5,%esi
 1908715:	62 f2 f5 49 64 d3    	vpblendmq %zmm3,%zmm1,%zmm2{%k1}
 190871b:	62 f2 85 48 7e cb    	vpermt2q %zmm3,%zmm15,%zmm1
 1908721:	c5 fd 6f 5c 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm3
 1908727:	c5 f9 c5 cf 06       	vpextrw $0x6,%xmm7,%ecx
 190872c:	c5 f9 6f bc 24 e0 00 00 00 	vmovdqa 0xe0(%rsp),%xmm7
 1908735:	c1 e6 06             	shl    $0x6,%esi
 1908738:	c1 e1 06             	shl    $0x6,%ecx
 190873b:	62 f3 e5 48 3a 5c 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm3,%zmm3
 1908744:	c5 f9 c5 fc 06       	vpextrw $0x6,%xmm4,%edi
 1908749:	c5 fd 6f 64 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm4
 190874f:	c5 f9 c5 d6 06       	vpextrw $0x6,%xmm6,%edx
 1908754:	c5 f9 6f b4 24 f0 00 00 00 	vmovdqa 0xf0(%rsp),%xmm6
 190875d:	c1 e7 06             	shl    $0x6,%edi
 1908760:	c1 e2 06             	shl    $0x6,%edx
 1908763:	62 f3 dd 48 3a 6c 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm4,%zmm5
 190876c:	c5 f9 c5 f7 06       	vpextrw $0x6,%xmm7,%esi
 1908771:	c1 e6 06             	shl    $0x6,%esi
 1908774:	c5 f9 c5 fe 06       	vpextrw $0x6,%xmm6,%edi
 1908779:	c5 fd 6f 74 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm6
 190877f:	0f b7 94 24 1c 01 00 00 	movzwl 0x11c(%rsp),%edx
 1908787:	c1 e7 06             	shl    $0x6,%edi
 190878a:	62 f2 e5 49 64 e5    	vpblendmq %zmm5,%zmm3,%zmm4{%k1}
 1908790:	62 f2 85 48 7e dd    	vpermt2q %zmm5,%zmm15,%zmm3
 1908796:	c5 fd 6f 6c 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm5
 190879c:	62 f3 cd 48 3a 7c 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm6,%zmm7
 19087a5:	0f b7 8c 24 0c 01 00 00 	movzwl 0x10c(%rsp),%ecx
 19087ad:	0f b7 bc 24 3c 01 00 00 	movzwl 0x13c(%rsp),%edi
 19087b5:	62 f3 d5 48 3a 6c 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm5,%zmm5
 19087be:	0f b7 b4 24 2c 01 00 00 	movzwl 0x12c(%rsp),%esi
 19087c6:	62 71 6d 48 6a d4    	vpunpckhdq %zmm4,%zmm2,%zmm10
 19087cc:	c1 e2 06             	shl    $0x6,%edx
 19087cf:	c5 7d 6f 44 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm8
 19087d5:	c1 e1 06             	shl    $0x6,%ecx
 19087d8:	c1 e7 06             	shl    $0x6,%edi
 19087db:	c1 e6 06             	shl    $0x6,%esi
 19087de:	62 e3 bd 48 3a 44 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm8,%zmm16
 19087e7:	62 f2 d5 49 64 f7    	vpblendmq %zmm7,%zmm5,%zmm6{%k1}
 19087ed:	62 f2 85 48 7e ef    	vpermt2q %zmm7,%zmm15,%zmm5
 19087f3:	c5 fd 6f 7c 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm7
 19087f9:	62 f3 c5 48 3a 7c 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm7,%zmm7
 1908802:	62 32 c5 49 64 c0    	vpblendmq %zmm16,%zmm7,%zmm8{%k1}
 1908808:	62 b2 85 48 7e f8    	vpermt2q %zmm16,%zmm15,%zmm7
 190880e:	62 e2 7d 48 5a 05 08 dc c6 fe 	vbroadcasti32x4 -0x13923f8(%rip),%zmm16        # 576420 <x86_effects_unknown+0x9c0>
 1908818:	62 51 4d 48 6a e8    	vpunpckhdq %zmm8,%zmm6,%zmm13
 190881e:	62 51 ad 48 6d d5    	vpunpckhqdq %zmm13,%zmm10,%zmm10
 1908824:	62 d1 15 48 72 d3 1a 	vpsrld $0x1a,%zmm11,%zmm13
 190882b:	62 72 15 48 36 35 8b 9d c1 fe 	vpermd -0x13e6275(%rip),%zmm13,%zmm14        # 5225c0 <branch_sizing_patterns+0x2830>
 1908835:	62 e2 15 48 36 15 c1 9d c1 fe 	vpermd -0x13e623f(%rip),%zmm13,%zmm18        # 522600 <branch_sizing_patterns+0x2870>
 190883f:	62 72 15 48 36 2d f7 9d c1 fe 	vpermd -0x13e6209(%rip),%zmm13,%zmm13        # 522640 <branch_sizing_patterns+0x28b0>
 1908849:	62 d1 45 40 72 d2 1d 	vpsrld $0x1d,%zmm10,%zmm23
 1908850:	62 52 fd 40 83 fb    	vpmultishiftqb %zmm11,%zmm16,%zmm15
 1908856:	62 e2 7d 48 5a 05 e0 db c6 fe 	vbroadcasti32x4 -0x1392420(%rip),%zmm16        # 576440 <x86_effects_unknown+0x9e0>
 1908860:	62 c2 fd 40 83 c3    	vpmultishiftqb %zmm11,%zmm16,%zmm16
 1908866:	62 e3 05 58 25 05 8b 7d c7 fe d8 	vpternlogd $0xd8,-0x1388275(%rip){1to16},%zmm15,%zmm16        # 5805fc <tier0_emit_x87.operations+0x1b4>
 1908871:	62 d1 05 48 72 f3 04 	vpslld $0x4,%zmm11,%zmm15
 1908878:	62 d1 05 48 72 e7 1f 	vpsrad $0x1f,%zmm15,%zmm15
 190887f:	62 e3 7d 50 25 1d 76 7d c7 fe e4 	vpternlogd $0xe4,-0x138828a(%rip){1to16},%zmm16,%zmm19        # 580600 <tier0_emit_x87.operations+0x1b8>
 190888a:	62 e2 7d 48 5a 05 bc db c6 fe 	vbroadcasti32x4 -0x1392444(%rip),%zmm16        # 576450 <x86_effects_unknown+0x9f0>
 1908894:	62 c2 7d 40 00 eb    	vpshufb %zmm11,%zmm16,%zmm21
 190889a:	62 c3 65 40 25 d6 f8 	vpternlogd $0xf8,%zmm14,%zmm19,%zmm18
 19088a1:	62 23 05 48 25 d2 ea 	vpternlogd $0xea,%zmm18,%zmm15,%zmm26
 19088a8:	62 b1 0d 48 72 f5 10 	vpslld $0x10,%zmm21,%zmm14
 19088af:	62 d1 7d 40 72 e6 1f 	vpsrad $0x1f,%zmm14,%zmm16
 19088b6:	62 72 7e 48 38 f0    	vpmovm2d %k0,%zmm14
 19088bc:	62 33 05 48 25 f0 c8 	vpternlogd $0xc8,%zmm16,%zmm15,%zmm14
 19088c3:	62 c1 75 40 ef c1    	vpxord %zmm9,%zmm17,%zmm16
 19088c9:	62 e2 7d 48 58 0d 35 7d c7 fe 	vpbroadcastd -0x13882cb(%rip),%zmm17        # 580608 <tier0_emit_x87.operations+0x1c0>
 19088d3:	62 a2 7d 48 44 c0    	vplzcntd %zmm16,%zmm16
 19088d9:	62 a2 75 40 45 c0    	vpsrlvd %zmm16,%zmm17,%zmm16
 19088df:	62 23 35 48 25 c0 14 	vpternlogd $0x14,%zmm16,%zmm9,%zmm24
 19088e6:	62 a2 3d 40 14 c7    	vprorvd %zmm23,%zmm24,%zmm16
 19088ec:	62 62 7d 48 58 05 16 7d c7 fe 	vpbroadcastd -0x13882ea(%rip),%zmm24        # 58060c <tier0_emit_x87.operations+0x1c4>
 19088f6:	62 b1 7d 40 72 e0 1f 	vpsrad $0x1f,%zmm16,%zmm16
 19088fd:	62 23 0d 48 25 c2 ea 	vpternlogd $0xea,%zmm18,%zmm14,%zmm24
 1908904:	62 03 7d 40 25 d0 b8 	vpternlogd $0xb8,%zmm24,%zmm16,%zmm26
 190890b:	62 21 35 40 fe c6    	vpaddd %zmm22,%zmm25,%zmm24
 1908911:	62 d1 35 40 72 d3 08 	vpsrld $0x8,%zmm11,%zmm25
 1908918:	62 63 5d 50 25 0d f5 7c c7 fe 6c 	vpternlogd $0x6c,-0x138830b(%rip){1to16},%zmm20,%zmm25        # 580618 <tier0_emit_x87.operations+0x1d0>
 1908923:	62 51 1d 48 eb db    	vpord  %zmm11,%zmm12,%zmm11
 1908929:	62 d1 25 48 72 f3 07 	vpslld $0x7,%zmm11,%zmm11
 1908930:	62 a1 35 40 fe e6    	vpaddd %zmm22,%zmm25,%zmm20
 1908936:	62 62 7d 48 58 0d dc 7c c7 fe 	vpbroadcastd -0x1388324(%rip),%zmm25        # 58061c <tier0_emit_x87.operations+0x1d4>
 1908940:	62 63 3d 50 25 0d d5 7c c7 fe ea 	vpternlogd $0xea,-0x138832b(%rip){1to16},%zmm24,%zmm25        # 580620 <tier0_emit_x87.operations+0x1d8>
 190894b:	62 61 65 50 db 05 d3 7c c7 fe 	vpandd -0x138832d(%rip){1to16},%zmm19,%zmm24        # 580628 <tier0_emit_x87.operations+0x1e0>
 1908955:	62 b1 65 40 72 d3 03 	vpsrld $0x3,%zmm19,%zmm19
 190895c:	62 e3 2d 58 25 1d cd 7c c7 fe a2 	vpternlogd $0xa2,-0x1388333(%rip){1to16},%zmm10,%zmm19        # 580634 <tier0_emit_x87.operations+0x1ec>
 1908967:	62 63 5d 50 25 0d b2 7c c7 fe f8 	vpternlogd $0xf8,-0x138834e(%rip){1to16},%zmm20,%zmm25        # 580624 <tier0_emit_x87.operations+0x1dc>
 1908972:	62 a1 65 40 fe f6    	vpaddd %zmm22,%zmm19,%zmm22
 1908978:	62 e2 65 50 3b 1d b6 7c c7 fe 	vpminud -0x138834a(%rip){1to16},%zmm19,%zmm19        # 580638 <tier0_emit_x87.operations+0x1f0>
 1908982:	62 03 2d 48 25 c1 f8 	vpternlogd $0xf8,%zmm25,%zmm10,%zmm24
 1908989:	62 e2 3d 50 3b 25 99 7c c7 fe 	vpminud -0x1388367(%rip){1to16},%zmm24,%zmm20        # 58062c <tier0_emit_x87.operations+0x1e4>
 1908993:	62 b1 3d 40 72 d2 10 	vpsrld $0x10,%zmm18,%zmm24
 190899a:	62 b1 6d 40 72 d2 03 	vpsrld $0x3,%zmm18,%zmm18
 19089a1:	62 b1 4d 40 72 e6 1f 	vpsrad $0x1f,%zmm22,%zmm22
 19089a8:	62 e3 3d 50 25 15 7d 7c c7 fe ec 	vpternlogd $0xec,-0x1388383(%rip){1to16},%zmm24,%zmm18        # 580630 <tier0_emit_x87.operations+0x1e8>
 19089b3:	62 b1 3d 40 72 f2 08 	vpslld $0x8,%zmm18,%zmm24
 19089ba:	62 63 4d 50 25 05 87 7c c7 fe 08 	vpternlogd $0x8,-0x1388379(%rip){1to16},%zmm22,%zmm24        # 58064c <tier0_emit_x87.operations+0x204>
 19089c5:	62 e2 7d 48 5a 35 91 da c6 fe 	vbroadcasti32x4 -0x139256f(%rip),%zmm22        # 576460 <x86_effects_unknown+0xa00>
 19089cf:	62 73 3d 50 25 1d 76 7c c7 fe e4 	vpternlogd $0xe4,-0x138838a(%rip){1to16},%zmm24,%zmm11        # 580650 <tier0_emit_x87.operations+0x208>
 19089da:	62 c2 cd 40 83 f4    	vpmultishiftqb %zmm12,%zmm22,%zmm22
 19089e0:	62 31 05 48 db e5    	vpandd %zmm21,%zmm15,%zmm12
 19089e6:	62 73 15 58 25 25 4b 7c c7 fe ec 	vpternlogd $0xec,-0x13883b5(%rip){1to16},%zmm13,%zmm12        # 58063c <tier0_emit_x87.operations+0x1f4>
 19089f1:	62 e3 6d 50 25 35 58 7c c7 fe d8 	vpternlogd $0xd8,-0x13883a8(%rip){1to16},%zmm18,%zmm22        # 580654 <tier0_emit_x87.operations+0x20c>
 19089fc:	62 71 05 58 db 2d 42 7c c7 fe 	vpandd -0x13883be(%rip){1to16},%zmm15,%zmm13        # 580648 <tier0_emit_x87.operations+0x200>
 1908a06:	62 73 2d 58 25 25 2f 7c c7 fe f8 	vpternlogd $0xf8,-0x13883d1(%rip){1to16},%zmm10,%zmm12        # 580640 <tier0_emit_x87.operations+0x1f8>
 1908a11:	62 71 0d 58 db 15 29 7c c7 fe 	vpandd -0x13883d7(%rip){1to16},%zmm14,%zmm10        # 580644 <tier0_emit_x87.operations+0x1fc>
 1908a1b:	62 e3 25 58 25 35 32 7c c7 fe d8 	vpternlogd $0xd8,-0x13883ce(%rip){1to16},%zmm11,%zmm22        # 580658 <tier0_emit_x87.operations+0x210>
 1908a26:	62 d1 25 48 72 c9 01 	vprold $0x1,%zmm9,%zmm11
 1908a2d:	62 33 65 40 25 e4 fe 	vpternlogd $0xfe,%zmm20,%zmm19,%zmm12
 1908a34:	62 53 7d 40 25 ea b8 	vpternlogd $0xb8,%zmm10,%zmm16,%zmm13
 1908a3b:	62 32 25 48 14 df    	vprorvd %zmm23,%zmm11,%zmm11
 1908a41:	62 51 15 48 eb d4    	vpord  %zmm12,%zmm13,%zmm10
 1908a47:	62 51 7d 48 70 fa 00 	vpshufd $0x0,%zmm10,%zmm15
 1908a4e:	62 53 0d 48 25 d9 e2 	vpternlogd $0xe2,%zmm9,%zmm14,%zmm11
 1908a55:	62 72 7d 48 5a 35 81 d9 c6 fe 	vbroadcasti32x4 -0x139267f(%rip),%zmm14        # 5763e0 <x86_effects_unknown+0x980>
 1908a5f:	62 f2 05 48 8f c9    	vpshufbitqmb %zmm1,%zmm15,%k1
 1908a65:	62 53 7d 40 25 d9 e2 	vpternlogd $0xe2,%zmm9,%zmm16,%zmm11
 1908a6c:	62 51 7d 48 62 cb    	vpunpckldq %zmm11,%zmm0,%zmm9
 1908a72:	62 d1 7d 48 6a c3    	vpunpckhdq %zmm11,%zmm0,%zmm0
 1908a78:	c4 e1 fb 93 c1       	kmovq  %k1,%rax
 1908a7d:	62 31 2d 40 62 de    	vpunpckldq %zmm22,%zmm26,%zmm11
 1908a83:	62 31 2d 40 6a e6    	vpunpckhdq %zmm22,%zmm26,%zmm12
 1908a89:	f3 48 0f b8 c0       	popcnt %rax,%rax
 1908a8e:	62 51 b5 48 6c eb    	vpunpcklqdq %zmm11,%zmm9,%zmm13
 1908a94:	62 c1 fd 48 6c c4    	vpunpcklqdq %zmm12,%zmm0,%zmm16
 1908a9a:	62 d1 fd 48 6d c4    	vpunpckhqdq %zmm12,%zmm0,%zmm0
 1908aa0:	62 51 b5 48 6d cb    	vpunpckhqdq %zmm11,%zmm9,%zmm9
 1908aa6:	62 51 7d 48 70 e2 55 	vpshufd $0x55,%zmm10,%zmm12
 1908aad:	49 8d 0c 06          	lea    (%r14,%rax,1),%rcx
 1908ab1:	62 72 15 48 00 e9    	vpshufb %zmm1,%zmm13,%zmm13
 1908ab7:	62 f2 7d 48 00 c7    	vpshufb %zmm7,%zmm0,%zmm0
 1908abd:	62 53 ed 48 25 ee 78 	vpternlogq $0x78,%zmm14,%zmm2,%zmm13
 1908ac4:	62 f2 35 48 00 d3    	vpshufb %zmm3,%zmm9,%zmm2
 1908aca:	62 d3 bd 48 25 c6 78 	vpternlogq $0x78,%zmm14,%zmm8,%zmm0
 1908ad1:	62 72 7d c9 63 e9    	vpcompressb %zmm13,%zmm1{%k1}{z}
 1908ad7:	62 f2 1d 48 8f cb    	vpshufbitqmb %zmm3,%zmm12,%k1
 1908add:	62 d1 7d 48 70 da aa 	vpshufd $0xaa,%zmm10,%zmm3
 1908ae4:	62 d3 dd 48 25 d6 78 	vpternlogq $0x78,%zmm14,%zmm4,%zmm2
 1908aeb:	c4 e1 fb 93 d1       	kmovq  %k1,%rdx
 1908af0:	f3 48 0f b8 d2       	popcnt %rdx,%rdx
 1908af5:	62 d1 fe 48 7f 0e    	vmovdqu64 %zmm1,(%r14)
 1908afb:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
 1908aff:	62 f2 7d c9 63 d1    	vpcompressb %zmm2,%zmm1{%k1}{z}
 1908b05:	62 f2 7d 40 00 d5    	vpshufb %zmm5,%zmm16,%zmm2
 1908b0b:	62 f2 65 48 8f cd    	vpshufbitqmb %zmm5,%zmm3,%k1
 1908b11:	62 d3 cd 48 25 d6 78 	vpternlogq $0x78,%zmm14,%zmm6,%zmm2
 1908b18:	c4 e1 fb 93 f1       	kmovq  %k1,%rsi
 1908b1d:	f3 48 0f b8 f6       	popcnt %rsi,%rsi
 1908b22:	62 d1 fe 48 7f 0c 06 	vmovdqu64 %zmm1,(%r14,%rax,1)
 1908b29:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
 1908b2d:	62 f2 7d c9 63 d1    	vpcompressb %zmm2,%zmm1{%k1}{z}
 1908b33:	62 d1 7d 48 70 d2 ff 	vpshufd $0xff,%zmm10,%zmm2
 1908b3a:	48 8d 04 11          	lea    (%rcx,%rdx,1),%rax
 1908b3e:	62 f2 6d 48 8f cf    	vpshufbitqmb %zmm7,%zmm2,%k1
 1908b44:	62 f2 7d c9 63 c0    	vpcompressb %zmm0,%zmm0{%k1}{z}
 1908b4a:	62 f1 fe 48 7f 0c 0a 	vmovdqu64 %zmm1,(%rdx,%rcx,1)
 1908b51:	c4 e1 fb 93 c9       	kmovq  %k1,%rcx
 1908b56:	f3 4c 0f b8 f1       	popcnt %rcx,%r14
 1908b5b:	49 01 f6             	add    %rsi,%r14
 1908b5e:	49 01 c6             	add    %rax,%r14
 1908b61:	62 f1 fe 48 7f 04 06 	vmovdqu64 %zmm0,(%rsi,%rax,1)
 1908b68:	49 29 de             	sub    %rbx,%r14
 1908b6b:	64 48 8b 04 25 28 00 00 00 	mov    %fs:0x28,%rax
 1908b74:	48 3b 84 24 48 01 00 00 	cmp    0x148(%rsp),%rax
 1908b7c:	75 13                	jne    1908b91 <x86_encode_16+0x24c1>
 1908b7e:	4c 89 f0             	mov    %r14,%rax
 1908b81:	48 8d 65 e0          	lea    -0x20(%rbp),%rsp
 1908b85:	5b                   	pop    %rbx
 1908b86:	41 5c                	pop    %r12
 1908b88:	41 5e                	pop    %r14
 1908b8a:	41 5f                	pop    %r15
 1908b8c:	5d                   	pop    %rbp
 1908b8d:	c5 f8 77             	vzeroupper
 1908b90:	c3                   	ret
 1908b91:	c5 f8 77             	vzeroupper
 1908b94:	e8 47 af e5 fe       	call   763ae0 <__stack_chk_fail@plt>
