
/home/david/buster-fast-bench/codex-180-fix-20261027-group-guard/build/compiler:     file format elf64-x86-64


Disassembly of section .text:

00000000018d1b40 <x86_encode_16>:
 18d1b40:	55                   	push   %rbp
 18d1b41:	48 89 e5             	mov    %rsp,%rbp
 18d1b44:	41 57                	push   %r15
 18d1b46:	41 56                	push   %r14
 18d1b48:	41 54                	push   %r12
 18d1b4a:	53                   	push   %rbx
 18d1b4b:	48 83 e4 c0          	and    $0xffffffffffffffc0,%rsp
 18d1b4f:	48 81 ec 80 01 00 00 	sub    $0x180,%rsp
 18d1b56:	64 48 8b 04 25 28 00 00 00 	mov    %fs:0x28,%rax
 18d1b5f:	48 89 d3             	mov    %rdx,%rbx
 18d1b62:	48 89 f2             	mov    %rsi,%rdx
 18d1b65:	48 89 fe             	mov    %rdi,%rsi
 18d1b68:	48 89 84 24 48 01 00 00 	mov    %rax,0x148(%rsp)
 18d1b70:	48 85 c9             	test   %rcx,%rcx
 18d1b73:	74 10                	je     18d1b85 <x86_encode_16+0x45>
 18d1b75:	48 83 fa 10          	cmp    $0x10,%rdx
 18d1b79:	73 1e                	jae    18d1b99 <x86_encode_16+0x59>
 18d1b7b:	31 c0                	xor    %eax,%eax
 18d1b7d:	49 89 de             	mov    %rbx,%r14
 18d1b80:	e9 4d 06 00 00       	jmp    18d21d2 <x86_encode_16+0x692>
 18d1b85:	48 83 fa 10          	cmp    $0x10,%rdx
 18d1b89:	0f 83 c0 0c 00 00    	jae    18d284f <x86_encode_16+0xd0f>
 18d1b8f:	31 c0                	xor    %eax,%eax
 18d1b91:	49 89 de             	mov    %rbx,%r14
 18d1b94:	e9 50 12 00 00       	jmp    18d2de9 <x86_encode_16+0x12a9>
 18d1b99:	62 f2 7d 48 5a 1d 3d 48 ca fe 	vbroadcasti32x4 -0x135b7c3(%rip),%zmm3        # 5763e0 <x86_effects_unknown+0x980>
 18d1ba3:	62 72 7d 48 58 0d 73 ea ca fe 	vpbroadcastd -0x135158d(%rip),%zmm9        # 580620 <tier0_emit_x87.operations+0x1d8>
 18d1bad:	48 8d 7a f0          	lea    -0x10(%rdx),%rdi
 18d1bb1:	41 b2 cc             	mov    $0xcc,%r10b
 18d1bb4:	4c 8d 86 fc 00 00 00 	lea    0xfc(%rsi),%r8
 18d1bbb:	4c 8d 0d be de d5 0c 	lea    0xcd5debe(%rip),%r9        # e62fa80 <x86_template_storage>
 18d1bc2:	62 53 1d 48 25 e4 ff 	vpternlogd $0xff,%zmm12,%zmm12,%zmm12
 18d1bc9:	31 c0                	xor    %eax,%eax
 18d1bcb:	48 c1 ef 04          	shr    $0x4,%rdi
 18d1bcf:	c4 c1 7b 92 ca       	kmovd  %r10d,%k1
 18d1bd4:	49 89 da             	mov    %rbx,%r10
 18d1bd7:	48 ff c7             	inc    %rdi
 18d1bda:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
 18d1be0:	45 0f b7 98 10 ff ff ff 	movzwl -0xf0(%r8),%r11d
 18d1be8:	45 0f b7 b0 20 ff ff ff 	movzwl -0xe0(%r8),%r14d
 18d1bf0:	45 0f b7 b8 30 ff ff ff 	movzwl -0xd0(%r8),%r15d
 18d1bf8:	45 0f b7 a0 40 ff ff ff 	movzwl -0xc0(%r8),%r12d
 18d1c00:	62 c1 fe 48 6f a0 04 ff ff ff 	vmovdqu64 -0xfc(%r8),%zmm20
 18d1c0a:	62 41 fe 48 6f 98 44 ff ff ff 	vmovdqu64 -0xbc(%r8),%zmm27
 18d1c14:	62 41 fe 48 6f a8 84 ff ff ff 	vmovdqu64 -0x7c(%r8),%zmm29
 18d1c1e:	62 41 fe 48 6f b0 c4 ff ff ff 	vmovdqu64 -0x3c(%r8),%zmm30
 18d1c28:	62 f2 7d 48 5a 2d ee 47 ca fe 	vbroadcasti32x4 -0x135b812(%rip),%zmm5        # 576420 <x86_effects_unknown+0x9c0>
 18d1c32:	62 f2 7d 48 5a 05 f4 47 ca fe 	vbroadcasti32x4 -0x135b80c(%rip),%zmm0        # 576430 <x86_effects_unknown+0x9d0>
 18d1c3c:	62 72 7d 48 58 05 c2 e9 ca fe 	vpbroadcastd -0x135163e(%rip),%zmm8        # 580608 <tier0_emit_x87.operations+0x1c0>
 18d1c46:	48 83 c0 10          	add    $0x10,%rax
 18d1c4a:	41 c1 e3 06          	shl    $0x6,%r11d
 18d1c4e:	41 c1 e6 06          	shl    $0x6,%r14d
 18d1c52:	41 c1 e7 06          	shl    $0x6,%r15d
 18d1c56:	41 c1 e4 06          	shl    $0x6,%r12d
 18d1c5a:	c4 81 7d 6f 4c 0b 40 	vmovdqa 0x40(%r11,%r9,1),%ymm1
 18d1c61:	45 0f b7 98 50 ff ff ff 	movzwl -0xb0(%r8),%r11d
 18d1c69:	62 13 f5 48 3a 5c 0f 02 01 	vinserti64x4 $0x1,0x40(%r15,%r9,1),%zmm1,%zmm11
 18d1c72:	45 0f b7 b8 70 ff ff ff 	movzwl -0x90(%r8),%r15d
 18d1c7a:	c4 81 7d 6f 4c 0e 60 	vmovdqa 0x60(%r14,%r9,1),%ymm1
 18d1c81:	45 0f b7 b0 60 ff ff ff 	movzwl -0xa0(%r8),%r14d
 18d1c89:	62 83 f5 48 3a 74 0c 03 01 	vinserti64x4 $0x1,0x60(%r12,%r9,1),%zmm1,%zmm22
 18d1c92:	45 0f b7 60 80       	movzwl -0x80(%r8),%r12d
 18d1c97:	62 11 15 40 62 fe    	vpunpckldq %zmm30,%zmm29,%zmm15
 18d1c9d:	62 01 5d 40 6a e3    	vpunpckhdq %zmm27,%zmm20,%zmm28
 18d1ca3:	62 01 15 40 6a ee    	vpunpckhdq %zmm30,%zmm29,%zmm29
 18d1ca9:	62 11 5d 40 62 f3    	vpunpckldq %zmm27,%zmm20,%zmm14
 18d1caf:	62 11 9d 40 6c d5    	vpunpcklqdq %zmm29,%zmm28,%zmm10
 18d1cb5:	62 41 8d 48 6d f7    	vpunpckhqdq %zmm15,%zmm14,%zmm30
 18d1cbb:	62 d2 fd 48 83 f2    	vpmultishiftqb %zmm10,%zmm0,%zmm6
 18d1cc1:	62 92 0d 40 27 c6    	vptestmd %zmm30,%zmm30,%k0
 18d1cc7:	62 91 7d 48 72 e6 1f 	vpsrad $0x1f,%zmm30,%zmm0
 18d1cce:	62 41 fd 48 6f da    	vmovdqa64 %zmm10,%zmm27
 18d1cd4:	41 c1 e3 06          	shl    $0x6,%r11d
 18d1cd8:	c4 81 7d 6f 4c 0b 40 	vmovdqa 0x40(%r11,%r9,1),%ymm1
 18d1cdf:	45 0f b7 58 90       	movzwl -0x70(%r8),%r11d
 18d1ce4:	41 c1 e7 06          	shl    $0x6,%r15d
 18d1ce8:	41 c1 e6 06          	shl    $0x6,%r14d
 18d1cec:	62 83 f5 48 3a 44 0f 02 01 	vinserti64x4 $0x1,0x40(%r15,%r9,1),%zmm1,%zmm16
 18d1cf5:	45 0f b7 78 b0       	movzwl -0x50(%r8),%r15d
 18d1cfa:	c4 81 7d 6f 4c 0e 60 	vmovdqa 0x60(%r14,%r9,1),%ymm1
 18d1d01:	45 0f b7 70 a0       	movzwl -0x60(%r8),%r14d
 18d1d06:	41 c1 e4 06          	shl    $0x6,%r12d
 18d1d0a:	62 03 f5 48 3a 44 0c 03 01 	vinserti64x4 $0x1,0x60(%r12,%r9,1),%zmm1,%zmm24
 18d1d13:	45 0f b7 60 c0       	movzwl -0x40(%r8),%r12d
 18d1d18:	62 32 a5 49 64 ee    	vpblendmq %zmm22,%zmm11,%zmm13{%k1}
 18d1d1e:	41 c1 e3 06          	shl    $0x6,%r11d
 18d1d22:	c4 81 7d 6f 4c 0b 40 	vmovdqa 0x40(%r11,%r9,1),%ymm1
 18d1d29:	45 0f b7 58 d0       	movzwl -0x30(%r8),%r11d
 18d1d2e:	41 c1 e7 06          	shl    $0x6,%r15d
 18d1d32:	41 c1 e6 06          	shl    $0x6,%r14d
 18d1d36:	62 83 f5 48 3a 54 0f 02 01 	vinserti64x4 $0x1,0x40(%r15,%r9,1),%zmm1,%zmm18
 18d1d3f:	45 0f b7 78 f0       	movzwl -0x10(%r8),%r15d
 18d1d44:	c4 81 7d 6f 4c 0e 60 	vmovdqa 0x60(%r14,%r9,1),%ymm1
 18d1d4b:	45 0f b7 70 e0       	movzwl -0x20(%r8),%r14d
 18d1d50:	41 c1 e4 06          	shl    $0x6,%r12d
 18d1d54:	62 03 f5 48 3a 4c 0c 03 01 	vinserti64x4 $0x1,0x60(%r12,%r9,1),%zmm1,%zmm25
 18d1d5d:	45 0f b7 20          	movzwl (%r8),%r12d
 18d1d61:	49 81 c0 00 01 00 00 	add    $0x100,%r8
 18d1d68:	62 82 fd 41 64 c8    	vpblendmq %zmm24,%zmm16,%zmm17{%k1}
 18d1d6e:	41 c1 e3 06          	shl    $0x6,%r11d
 18d1d72:	41 c1 e6 06          	shl    $0x6,%r14d
 18d1d76:	41 c1 e7 06          	shl    $0x6,%r15d
 18d1d7a:	c4 81 7d 6f 4c 0b 40 	vmovdqa 0x40(%r11,%r9,1),%ymm1
 18d1d81:	62 83 f5 48 3a 6c 0f 02 01 	vinserti64x4 $0x1,0x40(%r15,%r9,1),%zmm1,%zmm21
 18d1d8a:	41 c1 e4 06          	shl    $0x6,%r12d
 18d1d8e:	c4 81 7d 6f 4c 0e 60 	vmovdqa 0x60(%r14,%r9,1),%ymm1
 18d1d95:	62 03 f5 48 3a 54 0c 03 01 	vinserti64x4 $0x1,0x60(%r12,%r9,1),%zmm1,%zmm26
 18d1d9e:	62 b1 15 48 6a c9    	vpunpckhdq %zmm17,%zmm13,%zmm1
 18d1da4:	62 82 ed 41 64 d9    	vpblendmq %zmm25,%zmm18,%zmm19{%k1}
 18d1daa:	62 82 d5 41 64 fa    	vpblendmq %zmm26,%zmm21,%zmm23{%k1}
 18d1db0:	62 b1 65 40 6a d7    	vpunpckhdq %zmm23,%zmm19,%zmm2
 18d1db6:	62 e1 f5 48 6d e2    	vpunpckhqdq %zmm2,%zmm1,%zmm20
 18d1dbc:	62 d1 75 48 72 d2 1a 	vpsrld $0x1a,%zmm10,%zmm1
 18d1dc3:	62 f2 75 48 36 3d f3 07 c5 fe 	vpermd -0x13af80d(%rip),%zmm1,%zmm7        # 5225c0 <branch_sizing_patterns+0x2830>
 18d1dcd:	62 62 75 48 36 3d 29 08 c5 fe 	vpermd -0x13af7d7(%rip),%zmm1,%zmm31        # 522600 <branch_sizing_patterns+0x2870>
 18d1dd7:	62 f2 75 48 36 25 5f 08 c5 fe 	vpermd -0x13af7a1(%rip),%zmm1,%zmm4        # 522640 <branch_sizing_patterns+0x28b0>
 18d1de1:	62 d2 d5 48 83 ca    	vpmultishiftqb %zmm10,%zmm5,%zmm1
 18d1de7:	62 f2 7d 48 5a 2d 4f 46 ca fe 	vbroadcasti32x4 -0x135b9b1(%rip),%zmm5        # 576440 <x86_effects_unknown+0x9e0>
 18d1df1:	62 d2 d5 48 83 ea    	vpmultishiftqb %zmm10,%zmm5,%zmm5
 18d1df7:	62 f3 75 58 25 2d fa e7 ca fe d8 	vpternlogd $0xd8,-0x1351806(%rip){1to16},%zmm1,%zmm5        # 5805fc <tier0_emit_x87.operations+0x1b4>
 18d1e02:	62 d1 75 48 72 f2 04 	vpslld $0x4,%zmm10,%zmm1
 18d1e09:	62 f1 6d 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm2
 18d1e10:	62 f3 55 58 25 35 e5 e7 ca fe e4 	vpternlogd $0xe4,-0x135181b(%rip){1to16},%zmm5,%zmm6        # 580600 <tier0_emit_x87.operations+0x1b8>
 18d1e1b:	62 f2 7d 48 5a 2d 2b 46 ca fe 	vbroadcasti32x4 -0x135b9d5(%rip),%zmm5        # 576450 <x86_effects_unknown+0x9f0>
 18d1e25:	62 d2 55 48 00 ea    	vpshufb %zmm10,%zmm5,%zmm5
 18d1e2b:	62 63 4d 48 25 ff f8 	vpternlogd $0xf8,%zmm7,%zmm6,%zmm31
 18d1e32:	62 f1 75 48 72 f5 10 	vpslld $0x10,%zmm5,%zmm1
 18d1e39:	62 f1 6d 48 db ed    	vpandd %zmm5,%zmm2,%zmm5
 18d1e3f:	62 f3 5d 58 25 2d f2 e7 ca fe ec 	vpternlogd $0xec,-0x135180e(%rip){1to16},%zmm4,%zmm5        # 58063c <tier0_emit_x87.operations+0x1f4>
 18d1e4a:	62 f1 45 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm7
 18d1e51:	62 f2 7e 48 38 c8    	vpmovm2d %k0,%zmm1
 18d1e57:	62 f3 5d 50 25 2d de e7 ca fe f8 	vpternlogd $0xf8,-0x1351822(%rip){1to16},%zmm20,%zmm5        # 580640 <tier0_emit_x87.operations+0x1f8>
 18d1e62:	62 f3 6d 48 25 cf c8 	vpternlogd $0xc8,%zmm7,%zmm2,%zmm1
 18d1e69:	62 91 7d 48 ef fe    	vpxord %zmm30,%zmm0,%zmm7
 18d1e6f:	62 f2 7d 48 58 05 8b e7 ca fe 	vpbroadcastd -0x1351875(%rip),%zmm0        # 580604 <tier0_emit_x87.operations+0x1bc>
 18d1e79:	62 f2 7d 48 44 ff    	vplzcntd %zmm7,%zmm7
 18d1e7f:	62 f2 3d 48 45 ff    	vpsrlvd %zmm7,%zmm8,%zmm7
 18d1e85:	62 51 0d 40 fe c4    	vpaddd %zmm12,%zmm30,%zmm8
 18d1e8b:	62 73 0d 40 25 c7 14 	vpternlogd $0x14,%zmm7,%zmm30,%zmm8
 18d1e92:	62 d1 45 48 72 d2 08 	vpsrld $0x8,%zmm10,%zmm7
 18d1e99:	62 63 7d 58 25 1d 70 e7 ca fe 6c 	vpternlogd $0x6c,-0x1351890(%rip){1to16},%zmm0,%zmm27        # 580614 <tier0_emit_x87.operations+0x1cc>
 18d1ea4:	62 f3 7d 58 25 3d 69 e7 ca fe 6c 	vpternlogd $0x6c,-0x1351897(%rip){1to16},%zmm0,%zmm7        # 580618 <tier0_emit_x87.operations+0x1d0>
 18d1eaf:	62 91 7d 48 72 ce 01 	vprold $0x1,%zmm30,%zmm0
 18d1eb6:	62 41 25 40 fe dc    	vpaddd %zmm12,%zmm27,%zmm27
 18d1ebc:	62 63 35 58 25 1d 55 e7 ca fe ec 	vpternlogd $0xec,-0x13518ab(%rip){1to16},%zmm9,%zmm27        # 58061c <tier0_emit_x87.operations+0x1d4>
 18d1ec7:	62 d1 45 48 fe fc    	vpaddd %zmm12,%zmm7,%zmm7
 18d1ecd:	62 f3 25 50 25 3d 4c e7 ca fe ec 	vpternlogd $0xec,-0x13518b4(%rip){1to16},%zmm27,%zmm7        # 580624 <tier0_emit_x87.operations+0x1dc>
 18d1ed8:	62 61 4d 58 db 1d 46 e7 ca fe 	vpandd -0x13518ba(%rip){1to16},%zmm6,%zmm27        # 580628 <tier0_emit_x87.operations+0x1e0>
 18d1ee2:	62 f1 4d 48 72 d6 03 	vpsrld $0x3,%zmm6,%zmm6
 18d1ee9:	62 f3 5d 50 25 35 40 e7 ca fe a2 	vpternlogd $0xa2,-0x13518c0(%rip){1to16},%zmm20,%zmm6        # 580634 <tier0_emit_x87.operations+0x1ec>
 18d1ef4:	62 f2 4d 58 3b 25 3a e7 ca fe 	vpminud -0x13518c6(%rip){1to16},%zmm6,%zmm4        # 580638 <tier0_emit_x87.operations+0x1f0>
 18d1efe:	62 63 5d 40 25 df f8 	vpternlogd $0xf8,%zmm7,%zmm20,%zmm27
 18d1f05:	62 62 25 50 3b 1d 1d e7 ca fe 	vpminud -0x13518e3(%rip){1to16},%zmm27,%zmm27        # 58062c <tier0_emit_x87.operations+0x1e4>
 18d1f0f:	62 b1 45 48 72 d4 1d 	vpsrld $0x1d,%zmm20,%zmm7
 18d1f16:	62 72 3d 48 14 c7    	vprorvd %zmm7,%zmm8,%zmm8
 18d1f1c:	62 f2 7d 48 14 ff    	vprorvd %zmm7,%zmm0,%zmm7
 18d1f22:	62 f1 fd 48 6f 05 54 06 c5 fe 	vmovdqa64 -0x13af9ac(%rip),%zmm0        # 522580 <branch_sizing_patterns+0x27f0>
 18d1f2c:	62 d1 3d 48 72 e0 1f 	vpsrad $0x1f,%zmm8,%zmm8
 18d1f33:	62 93 75 48 25 fe e2 	vpternlogd $0xe2,%zmm30,%zmm1,%zmm7
 18d1f3a:	62 93 3d 48 25 fe e2 	vpternlogd $0xe2,%zmm30,%zmm8,%zmm7
 18d1f41:	62 93 5d 48 25 eb fe 	vpternlogd $0xfe,%zmm27,%zmm4,%zmm5
 18d1f48:	62 91 fd 48 6f e7    	vmovdqa64 %zmm31,%zmm4
 18d1f4e:	62 01 fd 48 6f df    	vmovdqa64 %zmm31,%zmm27
 18d1f54:	62 f3 6d 58 25 25 b1 e6 ca fe f8 	vpternlogd $0xf8,-0x135194f(%rip){1to16},%zmm2,%zmm4        # 580610 <tier0_emit_x87.operations+0x1c8>
 18d1f5f:	62 63 75 58 25 1d a2 e6 ca fe f8 	vpternlogd $0xf8,-0x135195e(%rip){1to16},%zmm1,%zmm27        # 58060c <tier0_emit_x87.operations+0x1c4>
 18d1f6a:	62 f1 6d 58 db 15 d4 e6 ca fe 	vpandd -0x135192c(%rip){1to16},%zmm2,%zmm2        # 580648 <tier0_emit_x87.operations+0x200>
 18d1f74:	62 32 fd 48 7e de    	vpermt2q %zmm22,%zmm0,%zmm11
 18d1f7a:	62 82 fd 48 7e c0    	vpermt2q %zmm24,%zmm0,%zmm16
 18d1f80:	62 82 fd 48 7e d1    	vpermt2q %zmm25,%zmm0,%zmm18
 18d1f86:	62 82 fd 48 7e ea    	vpermt2q %zmm26,%zmm0,%zmm21
 18d1f8c:	62 91 7d 48 72 d7 10 	vpsrld $0x10,%zmm31,%zmm0
 18d1f93:	62 91 4d 40 72 d7 03 	vpsrld $0x3,%zmm31,%zmm22
 18d1f9a:	62 e3 7d 58 25 35 8b e6 ca fe ec 	vpternlogd $0xec,-0x1351975(%rip){1to16},%zmm0,%zmm22        # 580630 <tier0_emit_x87.operations+0x1e8>
 18d1fa5:	62 f2 7d 48 5a 05 b1 44 ca fe 	vbroadcasti32x4 -0x135bb4f(%rip),%zmm0        # 576460 <x86_effects_unknown+0xa00>
 18d1faf:	62 93 3d 48 25 e3 b8 	vpternlogd $0xb8,%zmm27,%zmm8,%zmm4
 18d1fb6:	62 61 75 58 db 1d 84 e6 ca fe 	vpandd -0x135197c(%rip){1to16},%zmm1,%zmm27        # 580644 <tier0_emit_x87.operations+0x1fc>
 18d1fc0:	62 d1 4d 48 fe cc    	vpaddd %zmm12,%zmm6,%zmm1
 18d1fc6:	62 f1 75 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm1
 18d1fcd:	62 93 3d 48 25 d3 b8 	vpternlogd $0xb8,%zmm27,%zmm8,%zmm2
 18d1fd4:	62 51 8d 48 6c c7    	vpunpcklqdq %zmm15,%zmm14,%zmm8
 18d1fda:	62 11 9d 40 6d f5    	vpunpckhqdq %zmm29,%zmm28,%zmm14
 18d1fe0:	62 f1 3d 48 6a f7    	vpunpckhdq %zmm7,%zmm8,%zmm6
 18d1fe6:	62 51 0d 48 eb d2    	vpord  %zmm10,%zmm14,%zmm10
 18d1fec:	62 71 6d 48 eb fd    	vpord  %zmm5,%zmm2,%zmm15
 18d1ff2:	62 b1 6d 48 72 f6 08 	vpslld $0x8,%zmm22,%zmm2
 18d1ff9:	62 f3 75 58 25 15 48 e6 ca fe 08 	vpternlogd $0x8,-0x13519b8(%rip){1to16},%zmm1,%zmm2        # 58064c <tier0_emit_x87.operations+0x204>
 18d2004:	62 d1 55 48 72 f2 07 	vpslld $0x7,%zmm10,%zmm5
 18d200b:	62 f3 55 58 25 15 3a e6 ca fe d8 	vpternlogd $0xd8,-0x13519c6(%rip){1to16},%zmm5,%zmm2        # 580650 <tier0_emit_x87.operations+0x208>
 18d2016:	62 d2 fd 48 83 ee    	vpmultishiftqb %zmm14,%zmm0,%zmm5
 18d201c:	62 f3 4d 50 25 2d 2d e6 ca fe d8 	vpternlogd $0xd8,-0x13519d3(%rip){1to16},%zmm22,%zmm5        # 580654 <tier0_emit_x87.operations+0x20c>
 18d2027:	62 d1 7d 48 70 c7 55 	vpshufd $0x55,%zmm15,%zmm0
 18d202e:	62 b2 7d 48 8f d0    	vpshufbitqmb %zmm16,%zmm0,%k2
 18d2034:	c4 61 fb 93 f2       	kmovq  %k2,%r14
 18d2039:	f3 4d 0f b8 f6       	popcnt %r14,%r14
 18d203e:	62 f3 6d 58 25 2d 0f e6 ca fe d8 	vpternlogd $0xd8,-0x13519f1(%rip){1to16},%zmm2,%zmm5        # 580658 <tier0_emit_x87.operations+0x210>
 18d2049:	62 f1 3d 48 62 d7    	vpunpckldq %zmm7,%zmm8,%zmm2
 18d204f:	62 f1 5d 48 62 fd    	vpunpckldq %zmm5,%zmm4,%zmm7
 18d2055:	62 f1 5d 48 6a e5    	vpunpckhdq %zmm5,%zmm4,%zmm4
 18d205b:	62 f1 ed 48 6c ef    	vpunpcklqdq %zmm7,%zmm2,%zmm5
 18d2061:	62 f1 ed 48 6d d7    	vpunpckhqdq %zmm7,%zmm2,%zmm2
 18d2067:	62 f1 cd 48 6c fc    	vpunpcklqdq %zmm4,%zmm6,%zmm7
 18d206d:	62 f1 cd 48 6d e4    	vpunpckhqdq %zmm4,%zmm6,%zmm4
 18d2073:	62 d1 7d 48 70 f7 00 	vpshufd $0x0,%zmm15,%zmm6
 18d207a:	62 d2 55 48 00 eb    	vpshufb %zmm11,%zmm5,%zmm5
 18d2080:	62 d2 4d 48 8f db    	vpshufbitqmb %zmm11,%zmm6,%k3
 18d2086:	62 b2 6d 48 00 d0    	vpshufb %zmm16,%zmm2,%zmm2
 18d208c:	62 b2 45 48 00 c2    	vpshufb %zmm18,%zmm7,%zmm0
 18d2092:	62 f3 95 48 25 eb 78 	vpternlogq $0x78,%zmm3,%zmm13,%zmm5
 18d2099:	62 f3 f5 40 25 d3 78 	vpternlogq $0x78,%zmm3,%zmm17,%zmm2
 18d20a0:	62 f3 e5 40 25 c3 78 	vpternlogq $0x78,%zmm3,%zmm19,%zmm0
 18d20a7:	62 f2 7d cb 63 ed    	vpcompressb %zmm5,%zmm5{%k3}{z}
 18d20ad:	62 f2 7d ca 63 d2    	vpcompressb %zmm2,%zmm2{%k2}{z}
 18d20b3:	c4 61 fb 93 db       	kmovq  %k3,%r11
 18d20b8:	f3 4d 0f b8 db       	popcnt %r11,%r11
 18d20bd:	62 d1 fe 48 7f 2a    	vmovdqu64 %zmm5,(%r10)
 18d20c3:	62 d1 7d 48 70 ef aa 	vpshufd $0xaa,%zmm15,%zmm5
 18d20ca:	62 91 fe 48 7f 14 1a 	vmovdqu64 %zmm2,(%r10,%r11,1)
 18d20d1:	4d 01 d3             	add    %r10,%r11
 18d20d4:	41 29 da             	sub    %ebx,%r10d
 18d20d7:	62 b2 55 48 8f da    	vpshufbitqmb %zmm18,%zmm5,%k3
 18d20dd:	62 d1 7d 48 70 ef ff 	vpshufd $0xff,%zmm15,%zmm5
 18d20e4:	62 73 5d 50 25 3d 6d e5 ca fe 20 	vpternlogd $0x20,-0x1351a93(%rip){1to16},%zmm20,%zmm15        # 58065c <tier0_emit_x87.operations+0x214>
 18d20ef:	62 b2 55 48 8f d5    	vpshufbitqmb %zmm21,%zmm5,%k2
 18d20f5:	c5 e9 ef d2          	vpxor  %xmm2,%xmm2,%xmm2
 18d20f9:	62 f2 7d cb 63 c2    	vpcompressb %zmm0,%zmm2{%k3}{z}
 18d20ff:	62 b2 5d 48 00 c5    	vpshufb %zmm21,%zmm4,%zmm0
 18d2105:	62 f1 5d 50 db 25 51 e5 ca fe 	vpandd -0x1351aaf(%rip){1to16},%zmm20,%zmm4        # 580660 <tier0_emit_x87.operations+0x218>
 18d210f:	62 f3 c5 40 25 c3 78 	vpternlogq $0x78,%zmm3,%zmm23,%zmm0
 18d2116:	62 91 fe 48 7f 14 1e 	vmovdqu64 %zmm2,(%r14,%r11,1)
 18d211d:	c5 e9 ef d2          	vpxor  %xmm2,%xmm2,%xmm2
 18d2121:	62 f2 7d ca 63 c2    	vpcompressb %zmm0,%zmm2{%k2}{z}
 18d2127:	62 d2 7d 48 55 c7    	vpopcntd %zmm15,%zmm0
 18d212d:	4d 01 f3             	add    %r14,%r11
 18d2130:	c4 61 fb 93 f3       	kmovq  %k3,%r14
 18d2135:	f3 4d 0f b8 fe       	popcnt %r14,%r15
 18d213a:	62 f1 75 48 fe cc    	vpaddd %zmm4,%zmm1,%zmm1
 18d2140:	62 f1 75 48 fe c8    	vpaddd %zmm0,%zmm1,%zmm1
 18d2146:	c5 f9 6f 05 a2 42 ca fe 	vmovdqa -0x135bd5e(%rip),%xmm0        # 5763f0 <x86_effects_unknown+0x990>
 18d214e:	62 91 fe 48 7f 14 1f 	vmovdqu64 %zmm2,(%r15,%r11,1)
 18d2155:	44 89 54 24 40       	mov    %r10d,0x40(%rsp)
 18d215a:	c4 61 fb 93 d2       	kmovq  %k2,%r10
 18d215f:	f3 4d 0f b8 f2       	popcnt %r10,%r14
 18d2164:	4d 01 fe             	add    %r15,%r14
 18d2167:	4d 01 de             	add    %r11,%r14
 18d216a:	62 f2 7d 48 8d c9    	vpermb %zmm1,%zmm0,%zmm1
 18d2170:	c5 f9 6f 05 88 42 ca fe 	vmovdqa -0x135bd78(%rip),%xmm0        # 576400 <x86_effects_unknown+0x9a0>
 18d2178:	62 f2 f5 18 40 0d be e2 ca fe 	vpmullq -0x1351d42(%rip){1to2},%xmm1,%xmm1        # 580440 <x86_semantics_benchmark_code.registers+0x450>
 18d2182:	62 d2 7d 48 8d d6    	vpermb %zmm14,%zmm0,%zmm2
 18d2188:	c4 e2 71 00 05 7f 42 ca fe 	vpshufb -0x135bd81(%rip),%xmm1,%xmm0        # 576410 <x86_effects_unknown+0x9b0>
 18d2191:	62 f2 7e 48 29 da    	vpmovb2m %zmm2,%k3
 18d2197:	c5 7b 93 d3          	kmovd  %k3,%r10d
 18d219b:	45 0f b7 d2          	movzwl %r10w,%r10d
 18d219f:	c5 f9 fc c9          	vpaddb %xmm1,%xmm0,%xmm1
 18d21a3:	f3 45 0f b8 d2       	popcnt %r10d,%r10d
 18d21a8:	48 ff cf             	dec    %rdi
 18d21ab:	62 f2 7d 48 31 c9    	vpmovzxbd %xmm1,%zmm1
 18d21b1:	62 f1 75 58 fe 4c 24 10 	vpaddd 0x40(%rsp){1to16},%zmm1,%zmm1
 18d21b9:	62 f2 7d cb 8b c9    	vpcompressd %zmm1,%zmm1{%k3}{z}
 18d21bf:	62 f1 fe 48 7f 09    	vmovdqu64 %zmm1,(%rcx)
 18d21c5:	4a 8d 0c 91          	lea    (%rcx,%r10,4),%rcx
 18d21c9:	4d 89 f2             	mov    %r14,%r10
 18d21cc:	0f 85 0e fa ff ff    	jne    18d1be0 <x86_encode_16+0xa0>
 18d21d2:	48 29 c2             	sub    %rax,%rdx
 18d21d5:	0f 86 fd 11 00 00    	jbe    18d33d8 <x86_encode_16+0x1898>
 18d21db:	48 c1 e0 04          	shl    $0x4,%rax
 18d21df:	48 c1 e2 04          	shl    $0x4,%rdx
 18d21e3:	48 8d 7c 24 40       	lea    0x40(%rsp),%rdi
 18d21e8:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 18d21ec:	62 f1 fd 48 7f 44 24 04 	vmovdqa64 %zmm0,0x100(%rsp)
 18d21f4:	62 f1 fd 48 7f 44 24 03 	vmovdqa64 %zmm0,0xc0(%rsp)
 18d21fc:	62 f1 fd 48 7f 44 24 02 	vmovdqa64 %zmm0,0x80(%rsp)
 18d2204:	62 f1 fd 48 7f 44 24 01 	vmovdqa64 %zmm0,0x40(%rsp)
 18d220c:	49 89 cf             	mov    %rcx,%r15
 18d220f:	48 01 c6             	add    %rax,%rsi
 18d2212:	c5 f8 77             	vzeroupper
 18d2215:	e8 36 22 e9 fe       	call   764450 <memcpy@plt>
 18d221a:	c5 f9 6f 4c 24 40    	vmovdqa 0x40(%rsp),%xmm1
 18d2220:	c5 f9 6f 54 24 50    	vmovdqa 0x50(%rsp),%xmm2
 18d2226:	c5 f9 6f 5c 24 60    	vmovdqa 0x60(%rsp),%xmm3
 18d222c:	c5 f9 6f 64 24 70    	vmovdqa 0x70(%rsp),%xmm4
 18d2232:	48 8d 05 47 d8 d5 0c 	lea    0xcd5d847(%rip),%rax        # e62fa80 <x86_template_storage>
 18d2239:	c5 f9 6f b4 24 80 00 00 00 	vmovdqa 0x80(%rsp),%xmm6
 18d2242:	62 71 fd 48 6f 3d 34 03 c5 fe 	vmovdqa64 -0x13afccc(%rip),%zmm15        # 522580 <branch_sizing_patterns+0x27f0>
 18d224c:	c5 f9 6f bc 24 c0 00 00 00 	vmovdqa 0xc0(%rsp),%xmm7
 18d2255:	c5 79 6f 84 24 e0 00 00 00 	vmovdqa 0xe0(%rsp),%xmm8
 18d225e:	62 f1 fd 48 6f 6c 24 01 	vmovdqa64 0x40(%rsp),%zmm5
 18d2266:	62 71 fd 48 6f 54 24 02 	vmovdqa64 0x80(%rsp),%zmm10
 18d226e:	62 71 fd 48 6f 5c 24 03 	vmovdqa64 0xc0(%rsp),%zmm11
 18d2276:	62 71 fd 48 6f 64 24 04 	vmovdqa64 0x100(%rsp),%zmm12
 18d227e:	62 e2 7d 48 5a 0d a8 41 ca fe 	vbroadcasti32x4 -0x135be58(%rip),%zmm17        # 576430 <x86_effects_unknown+0x9d0>
 18d2288:	62 a3 4d 40 25 f6 ff 	vpternlogd $0xff,%zmm22,%zmm22,%zmm22
 18d228f:	62 e2 7d 48 58 25 6b e3 ca fe 	vpbroadcastd -0x1351c95(%rip),%zmm20        # 580604 <tier0_emit_x87.operations+0x1bc>
 18d2299:	62 62 7d 48 58 1d 6d e3 ca fe 	vpbroadcastd -0x1351c93(%rip),%zmm27        # 580610 <tier0_emit_x87.operations+0x1c8>
 18d22a3:	62 62 7d 48 58 0d 67 e3 ca fe 	vpbroadcastd -0x1351c99(%rip),%zmm25        # 580614 <tier0_emit_x87.operations+0x1cc>
 18d22ad:	c5 f9 c5 c9 06       	vpextrw $0x6,%xmm1,%ecx
 18d22b2:	c5 f9 c5 d2 06       	vpextrw $0x6,%xmm2,%edx
 18d22b7:	c5 f9 c5 fc 06       	vpextrw $0x6,%xmm4,%edi
 18d22bc:	c5 f9 c5 f3 06       	vpextrw $0x6,%xmm3,%esi
 18d22c1:	c5 f9 6f a4 24 90 00 00 00 	vmovdqa 0x90(%rsp),%xmm4
 18d22ca:	62 51 55 48 62 ea    	vpunpckldq %zmm10,%zmm5,%zmm13
 18d22d0:	62 51 25 48 62 f4    	vpunpckldq %zmm12,%zmm11,%zmm14
 18d22d6:	62 d1 55 48 6a ea    	vpunpckhdq %zmm10,%zmm5,%zmm5
 18d22dc:	62 51 25 48 6a d4    	vpunpckhdq %zmm12,%zmm11,%zmm10
 18d22e2:	c1 e1 06             	shl    $0x6,%ecx
 18d22e5:	c1 e2 06             	shl    $0x6,%edx
 18d22e8:	c1 e6 06             	shl    $0x6,%esi
 18d22eb:	c1 e7 06             	shl    $0x6,%edi
 18d22ee:	62 51 95 48 6d de    	vpunpckhqdq %zmm14,%zmm13,%zmm11
 18d22f4:	62 d1 95 48 6c c6    	vpunpcklqdq %zmm14,%zmm13,%zmm0
 18d22fa:	62 51 d5 48 6c ea    	vpunpcklqdq %zmm10,%zmm5,%zmm13
 18d2300:	62 d1 d5 48 6d ea    	vpunpckhqdq %zmm10,%zmm5,%zmm5
 18d2306:	c5 fd 6f 4c 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm1
 18d230c:	c5 fd 6f 54 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm2
 18d2312:	b1 cc                	mov    $0xcc,%cl
 18d2314:	62 d1 0d 48 72 d5 1a 	vpsrld $0x1a,%zmm13,%zmm14
 18d231b:	62 e2 0d 48 36 1d db 02 c5 fe 	vpermd -0x13afd25(%rip),%zmm14,%zmm19        # 522600 <branch_sizing_patterns+0x2870>
 18d2325:	62 d2 25 48 27 c3    	vptestmd %zmm11,%zmm11,%k0
 18d232b:	62 d1 6d 40 72 e3 1f 	vpsrad $0x1f,%zmm11,%zmm18
 18d2332:	62 21 25 48 fe c6    	vpaddd %zmm22,%zmm11,%zmm24
 18d2338:	62 43 5d 40 25 cd 6c 	vpternlogd $0x6c,%zmm13,%zmm20,%zmm25
 18d233f:	62 f3 f5 48 3a 4c 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm1,%zmm1
 18d2348:	62 f3 ed 48 3a 5c 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm2,%zmm3
 18d2351:	c5 fb 92 c9          	kmovd  %ecx,%k1
 18d2355:	c5 f9 c5 ce 06       	vpextrw $0x6,%xmm6,%ecx
 18d235a:	c5 f9 6f b4 24 a0 00 00 00 	vmovdqa 0xa0(%rsp),%xmm6
 18d2363:	c1 e1 06             	shl    $0x6,%ecx
 18d2366:	c5 f9 c5 d4 06       	vpextrw $0x6,%xmm4,%edx
 18d236b:	c5 f9 6f a4 24 b0 00 00 00 	vmovdqa 0xb0(%rsp),%xmm4
 18d2374:	c1 e2 06             	shl    $0x6,%edx
 18d2377:	62 f2 f5 49 64 d3    	vpblendmq %zmm3,%zmm1,%zmm2{%k1}
 18d237d:	62 f2 85 48 7e cb    	vpermt2q %zmm3,%zmm15,%zmm1
 18d2383:	c5 fd 6f 5c 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm3
 18d2389:	c5 f9 c5 cf 06       	vpextrw $0x6,%xmm7,%ecx
 18d238e:	c5 f9 6f bc 24 d0 00 00 00 	vmovdqa 0xd0(%rsp),%xmm7
 18d2397:	c5 f9 c5 f6 06       	vpextrw $0x6,%xmm6,%esi
 18d239c:	c1 e6 06             	shl    $0x6,%esi
 18d239f:	c1 e1 06             	shl    $0x6,%ecx
 18d23a2:	62 f3 e5 48 3a 5c 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm3,%zmm3
 18d23ab:	c4 c1 79 c5 f0 06    	vpextrw $0x6,%xmm8,%esi
 18d23b1:	c1 e6 06             	shl    $0x6,%esi
 18d23b4:	c5 f9 c5 fc 06       	vpextrw $0x6,%xmm4,%edi
 18d23b9:	c5 fd 6f 64 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm4
 18d23bf:	c1 e7 06             	shl    $0x6,%edi
 18d23c2:	62 f3 dd 48 3a 74 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm4,%zmm6
 18d23cb:	c5 f9 c5 d7 06       	vpextrw $0x6,%xmm7,%edx
 18d23d0:	c5 f9 6f bc 24 f0 00 00 00 	vmovdqa 0xf0(%rsp),%xmm7
 18d23d9:	c1 e2 06             	shl    $0x6,%edx
 18d23dc:	62 f2 e5 49 64 e6    	vpblendmq %zmm6,%zmm3,%zmm4{%k1}
 18d23e2:	62 f2 85 48 7e de    	vpermt2q %zmm6,%zmm15,%zmm3
 18d23e8:	c5 fd 6f 74 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm6
 18d23ee:	0f b7 8c 24 0c 01 00 00 	movzwl 0x10c(%rsp),%ecx
 18d23f6:	c5 f9 c5 ff 06       	vpextrw $0x6,%xmm7,%edi
 18d23fb:	c5 fd 6f 7c 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm7
 18d2401:	62 f3 cd 48 3a 74 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm6,%zmm6
 18d240a:	0f b7 94 24 1c 01 00 00 	movzwl 0x11c(%rsp),%edx
 18d2412:	0f b7 b4 24 2c 01 00 00 	movzwl 0x12c(%rsp),%esi
 18d241a:	62 71 6d 48 6a d4    	vpunpckhdq %zmm4,%zmm2,%zmm10
 18d2420:	c1 e7 06             	shl    $0x6,%edi
 18d2423:	62 73 c5 48 3a 44 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm7,%zmm8
 18d242c:	0f b7 bc 24 3c 01 00 00 	movzwl 0x13c(%rsp),%edi
 18d2434:	c1 e1 06             	shl    $0x6,%ecx
 18d2437:	c1 e2 06             	shl    $0x6,%edx
 18d243a:	c1 e6 06             	shl    $0x6,%esi
 18d243d:	c5 7d 6f 4c 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm9
 18d2443:	c1 e7 06             	shl    $0x6,%edi
 18d2446:	62 e3 b5 48 3a 44 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm9,%zmm16
 18d244f:	62 d2 cd 49 64 f8    	vpblendmq %zmm8,%zmm6,%zmm7{%k1}
 18d2455:	62 d2 85 48 7e f0    	vpermt2q %zmm8,%zmm15,%zmm6
 18d245b:	c5 7d 6f 44 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm8
 18d2461:	62 73 bd 48 3a 44 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm8,%zmm8
 18d246a:	62 32 bd 49 64 c8    	vpblendmq %zmm16,%zmm8,%zmm9{%k1}
 18d2470:	62 32 85 48 7e c0    	vpermt2q %zmm16,%zmm15,%zmm8
 18d2476:	62 e2 7d 48 5a 05 a0 3f ca fe 	vbroadcasti32x4 -0x135c060(%rip),%zmm16        # 576420 <x86_effects_unknown+0x9c0>
 18d2480:	62 72 0d 48 36 3d 36 01 c5 fe 	vpermd -0x13afeca(%rip),%zmm14,%zmm15        # 5225c0 <branch_sizing_patterns+0x2830>
 18d248a:	62 72 0d 48 36 35 ac 01 c5 fe 	vpermd -0x13afe54(%rip),%zmm14,%zmm14        # 522640 <branch_sizing_patterns+0x28b0>
 18d2494:	62 51 45 48 6a e1    	vpunpckhdq %zmm9,%zmm7,%zmm12
 18d249a:	62 51 ad 48 6d d4    	vpunpckhqdq %zmm12,%zmm10,%zmm10
 18d24a0:	62 d1 45 40 72 d2 1d 	vpsrld $0x1d,%zmm10,%zmm23
 18d24a7:	62 52 fd 40 83 e5    	vpmultishiftqb %zmm13,%zmm16,%zmm12
 18d24ad:	62 e2 7d 48 5a 05 89 3f ca fe 	vbroadcasti32x4 -0x135c077(%rip),%zmm16        # 576440 <x86_effects_unknown+0x9e0>
 18d24b7:	62 c2 fd 40 83 c5    	vpmultishiftqb %zmm13,%zmm16,%zmm16
 18d24bd:	62 e3 1d 58 25 05 34 e1 ca fe d8 	vpternlogd $0xd8,-0x1351ecc(%rip){1to16},%zmm12,%zmm16        # 5805fc <tier0_emit_x87.operations+0x1b4>
 18d24c8:	62 52 f5 40 83 e5    	vpmultishiftqb %zmm13,%zmm17,%zmm12
 18d24ce:	62 e2 7d 48 5a 0d 78 3f ca fe 	vbroadcasti32x4 -0x135c088(%rip),%zmm17        # 576450 <x86_effects_unknown+0x9f0>
 18d24d8:	62 73 7d 50 25 25 1d e1 ca fe e4 	vpternlogd $0xe4,-0x1351ee3(%rip){1to16},%zmm16,%zmm12        # 580600 <tier0_emit_x87.operations+0x1b8>
 18d24e3:	62 c2 75 40 00 ed    	vpshufb %zmm13,%zmm17,%zmm21
 18d24e9:	62 d1 7d 40 72 f5 04 	vpslld $0x4,%zmm13,%zmm16
 18d24f0:	62 b1 7d 40 72 e0 1f 	vpsrad $0x1f,%zmm16,%zmm16
 18d24f7:	62 c3 1d 48 25 df f8 	vpternlogd $0xf8,%zmm15,%zmm12,%zmm19
 18d24fe:	62 b1 05 48 72 f5 10 	vpslld $0x10,%zmm21,%zmm15
 18d2505:	62 d1 75 40 72 e7 1f 	vpsrad $0x1f,%zmm15,%zmm17
 18d250c:	62 72 7e 48 38 f8    	vpmovm2d %k0,%zmm15
 18d2512:	62 23 7d 40 25 db ea 	vpternlogd $0xea,%zmm19,%zmm16,%zmm27
 18d2519:	62 b1 2d 40 72 d3 10 	vpsrld $0x10,%zmm19,%zmm26
 18d2520:	62 33 7d 40 25 f9 c8 	vpternlogd $0xc8,%zmm17,%zmm16,%zmm15
 18d2527:	62 c1 6d 40 ef cb    	vpxord %zmm11,%zmm18,%zmm17
 18d252d:	62 e2 7d 48 58 15 d1 e0 ca fe 	vpbroadcastd -0x1351f2f(%rip),%zmm18        # 580608 <tier0_emit_x87.operations+0x1c0>
 18d2537:	62 a2 7d 48 44 c9    	vplzcntd %zmm17,%zmm17
 18d253d:	62 a2 6d 40 45 c9    	vpsrlvd %zmm17,%zmm18,%zmm17
 18d2543:	62 23 25 48 25 c1 14 	vpternlogd $0x14,%zmm17,%zmm11,%zmm24
 18d254a:	62 a2 3d 40 14 cf    	vprorvd %zmm23,%zmm24,%zmm17
 18d2550:	62 62 7d 48 58 05 b2 e0 ca fe 	vpbroadcastd -0x1351f4e(%rip),%zmm24        # 58060c <tier0_emit_x87.operations+0x1c4>
 18d255a:	62 b1 75 40 72 e1 1f 	vpsrad $0x1f,%zmm17,%zmm17
 18d2561:	62 23 05 48 25 c3 ea 	vpternlogd $0xea,%zmm19,%zmm15,%zmm24
 18d2568:	62 b1 65 40 72 d3 03 	vpsrld $0x3,%zmm19,%zmm19
 18d256f:	62 e3 2d 50 25 1d b6 e0 ca fe ec 	vpternlogd $0xec,-0x1351f4a(%rip){1to16},%zmm26,%zmm19        # 580630 <tier0_emit_x87.operations+0x1e8>
 18d257a:	62 03 75 40 25 d8 b8 	vpternlogd $0xb8,%zmm24,%zmm17,%zmm27
 18d2581:	62 21 35 40 fe c6    	vpaddd %zmm22,%zmm25,%zmm24
 18d2587:	62 d1 35 40 72 d5 08 	vpsrld $0x8,%zmm13,%zmm25
 18d258e:	62 63 5d 50 25 0d 7f e0 ca fe 6c 	vpternlogd $0x6c,-0x1351f81(%rip){1to16},%zmm20,%zmm25        # 580618 <tier0_emit_x87.operations+0x1d0>
 18d2599:	62 51 55 48 eb ed    	vpord  %zmm13,%zmm5,%zmm13
 18d259f:	62 d1 2d 40 72 f5 07 	vpslld $0x7,%zmm13,%zmm26
 18d25a6:	62 31 7d 40 db ed    	vpandd %zmm21,%zmm16,%zmm13
 18d25ac:	62 73 0d 58 25 2d 85 e0 ca fe ec 	vpternlogd $0xec,-0x1351f7b(%rip){1to16},%zmm14,%zmm13        # 58063c <tier0_emit_x87.operations+0x1f4>
 18d25b7:	62 71 05 58 db 35 83 e0 ca fe 	vpandd -0x1351f7d(%rip){1to16},%zmm15,%zmm14        # 580644 <tier0_emit_x87.operations+0x1fc>
 18d25c1:	62 e1 7d 50 db 05 7d e0 ca fe 	vpandd -0x1351f83(%rip){1to16},%zmm16,%zmm16        # 580648 <tier0_emit_x87.operations+0x200>
 18d25cb:	62 73 2d 58 25 2d 6a e0 ca fe f8 	vpternlogd $0xf8,-0x1351f96(%rip){1to16},%zmm10,%zmm13        # 580640 <tier0_emit_x87.operations+0x1f8>
 18d25d6:	62 a1 35 40 fe e6    	vpaddd %zmm22,%zmm25,%zmm20
 18d25dc:	62 62 7d 48 58 0d 36 e0 ca fe 	vpbroadcastd -0x1351fca(%rip),%zmm25        # 58061c <tier0_emit_x87.operations+0x1d4>
 18d25e6:	62 63 3d 50 25 0d 2f e0 ca fe ea 	vpternlogd $0xea,-0x1351fd1(%rip){1to16},%zmm24,%zmm25        # 580620 <tier0_emit_x87.operations+0x1d8>
 18d25f1:	62 b1 3d 40 72 f3 08 	vpslld $0x8,%zmm19,%zmm24
 18d25f8:	62 c3 75 40 25 c6 b8 	vpternlogd $0xb8,%zmm14,%zmm17,%zmm16
 18d25ff:	62 d1 0d 48 72 cb 01 	vprold $0x1,%zmm11,%zmm14
 18d2606:	62 63 5d 50 25 0d 13 e0 ca fe f8 	vpternlogd $0xf8,-0x1351fed(%rip){1to16},%zmm20,%zmm25        # 580624 <tier0_emit_x87.operations+0x1dc>
 18d2611:	62 e1 1d 58 db 25 0d e0 ca fe 	vpandd -0x1351ff3(%rip){1to16},%zmm12,%zmm20        # 580628 <tier0_emit_x87.operations+0x1e0>
 18d261b:	62 32 0d 48 14 f7    	vprorvd %zmm23,%zmm14,%zmm14
 18d2621:	62 53 05 48 25 f3 e2 	vpternlogd $0xe2,%zmm11,%zmm15,%zmm14
 18d2628:	62 53 75 40 25 f3 e2 	vpternlogd $0xe2,%zmm11,%zmm17,%zmm14
 18d262f:	62 e2 7d 48 5a 0d a7 3d ca fe 	vbroadcasti32x4 -0x135c259(%rip),%zmm17        # 5763e0 <x86_effects_unknown+0x980>
 18d2639:	62 51 7d 48 62 de    	vpunpckldq %zmm14,%zmm0,%zmm11
 18d263f:	62 d1 7d 48 6a c6    	vpunpckhdq %zmm14,%zmm0,%zmm0
 18d2645:	62 83 2d 48 25 e1 f8 	vpternlogd $0xf8,%zmm25,%zmm10,%zmm20
 18d264c:	62 d1 35 40 72 d4 03 	vpsrld $0x3,%zmm12,%zmm25
 18d2653:	62 63 2d 58 25 0d d6 df ca fe a2 	vpternlogd $0xa2,-0x135202a(%rip){1to16},%zmm10,%zmm25        # 580634 <tier0_emit_x87.operations+0x1ec>
 18d265e:	62 e2 5d 50 3b 25 c4 df ca fe 	vpminud -0x135203c(%rip){1to16},%zmm20,%zmm20        # 58062c <tier0_emit_x87.operations+0x1e4>
 18d2668:	62 31 35 40 fe e6    	vpaddd %zmm22,%zmm25,%zmm12
 18d266e:	62 e2 35 50 3b 35 c0 df ca fe 	vpminud -0x1352040(%rip){1to16},%zmm25,%zmm22        # 580638 <tier0_emit_x87.operations+0x1f0>
 18d2678:	62 62 7d 48 5a 0d de 3d ca fe 	vbroadcasti32x4 -0x135c222(%rip),%zmm25        # 576460 <x86_effects_unknown+0xa00>
 18d2682:	62 d1 1d 48 72 e4 1f 	vpsrad $0x1f,%zmm12,%zmm12
 18d2689:	62 63 1d 58 25 05 b8 df ca fe 08 	vpternlogd $0x8,-0x1352048(%rip){1to16},%zmm12,%zmm24        # 58064c <tier0_emit_x87.operations+0x204>
 18d2694:	62 63 2d 50 25 05 b1 df ca fe d8 	vpternlogd $0xd8,-0x135204f(%rip){1to16},%zmm26,%zmm24        # 580650 <tier0_emit_x87.operations+0x208>
 18d269f:	62 62 b5 40 83 cd    	vpmultishiftqb %zmm5,%zmm25,%zmm25
 18d26a5:	62 63 65 50 25 0d a4 df ca fe d8 	vpternlogd $0xd8,-0x135205c(%rip){1to16},%zmm19,%zmm25        # 580654 <tier0_emit_x87.operations+0x20c>
 18d26b0:	62 33 4d 40 25 ec fe 	vpternlogd $0xfe,%zmm20,%zmm22,%zmm13
 18d26b7:	62 51 7d 40 eb ed    	vpord  %zmm13,%zmm16,%zmm13
 18d26bd:	62 c1 7d 48 70 d5 00 	vpshufd $0x0,%zmm13,%zmm18
 18d26c4:	62 63 3d 50 25 0d 89 df ca fe d8 	vpternlogd $0xd8,-0x1352077(%rip){1to16},%zmm24,%zmm25        # 580658 <tier0_emit_x87.operations+0x210>
 18d26cf:	62 f2 6d 40 8f c9    	vpshufbitqmb %zmm1,%zmm18,%k1
 18d26d5:	c4 e1 fb 93 c1       	kmovq  %k1,%rax
 18d26da:	f3 48 0f b8 c0       	popcnt %rax,%rax
 18d26df:	49 8d 0c 06          	lea    (%r14,%rax,1),%rcx
 18d26e3:	62 11 25 40 62 f1    	vpunpckldq %zmm25,%zmm27,%zmm14
 18d26e9:	62 11 25 40 6a f9    	vpunpckhdq %zmm25,%zmm27,%zmm15
 18d26ef:	62 c1 a5 48 6c c6    	vpunpcklqdq %zmm14,%zmm11,%zmm16
 18d26f5:	62 c1 fd 48 6c df    	vpunpcklqdq %zmm15,%zmm0,%zmm19
 18d26fb:	62 d1 fd 48 6d c7    	vpunpckhqdq %zmm15,%zmm0,%zmm0
 18d2701:	62 51 a5 48 6d de    	vpunpckhqdq %zmm14,%zmm11,%zmm11
 18d2707:	62 51 7d 48 70 fd 55 	vpshufd $0x55,%zmm13,%zmm15
 18d270e:	62 e2 7d 40 00 c1    	vpshufb %zmm1,%zmm16,%zmm16
 18d2714:	62 d2 7d 48 00 c0    	vpshufb %zmm8,%zmm0,%zmm0
 18d271a:	62 a3 ed 48 25 c1 78 	vpternlogq $0x78,%zmm17,%zmm2,%zmm16
 18d2721:	62 f2 25 48 00 d3    	vpshufb %zmm3,%zmm11,%zmm2
 18d2727:	62 b3 b5 48 25 c1 78 	vpternlogq $0x78,%zmm17,%zmm9,%zmm0
 18d272e:	62 e2 7d c9 63 c1    	vpcompressb %zmm16,%zmm1{%k1}{z}
 18d2734:	62 f2 05 48 8f cb    	vpshufbitqmb %zmm3,%zmm15,%k1
 18d273a:	62 d1 7d 48 70 dd aa 	vpshufd $0xaa,%zmm13,%zmm3
 18d2741:	62 b3 dd 48 25 d1 78 	vpternlogq $0x78,%zmm17,%zmm4,%zmm2
 18d2748:	62 d1 7d 48 70 e5 ff 	vpshufd $0xff,%zmm13,%zmm4
 18d274f:	62 73 2d 58 25 2d 02 df ca fe 20 	vpternlogd $0x20,-0x13520fe(%rip){1to16},%zmm10,%zmm13        # 58065c <tier0_emit_x87.operations+0x214>
 18d275a:	c4 e1 fb 93 d1       	kmovq  %k1,%rdx
 18d275f:	f3 48 0f b8 d2       	popcnt %rdx,%rdx
 18d2764:	62 d1 fe 48 7f 0e    	vmovdqu64 %zmm1,(%r14)
 18d276a:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
 18d276e:	62 f2 7d c9 63 d1    	vpcompressb %zmm2,%zmm1{%k1}{z}
 18d2774:	62 f2 65 40 00 d6    	vpshufb %zmm6,%zmm19,%zmm2
 18d277a:	62 f2 65 48 8f ce    	vpshufbitqmb %zmm6,%zmm3,%k1
 18d2780:	62 f1 2d 58 db 1d d6 de ca fe 	vpandd -0x135212a(%rip){1to16},%zmm10,%zmm3        # 580660 <tier0_emit_x87.operations+0x218>
 18d278a:	48 8d 34 11          	lea    (%rcx,%rdx,1),%rsi
 18d278e:	62 b3 c5 48 25 d1 78 	vpternlogq $0x78,%zmm17,%zmm7,%zmm2
 18d2795:	62 d1 fe 48 7f 0c 06 	vmovdqu64 %zmm1,(%r14,%rax,1)
 18d279c:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
 18d27a0:	62 f2 7d c9 63 d1    	vpcompressb %zmm2,%zmm1{%k1}{z}
 18d27a6:	c4 e1 fb 93 c1       	kmovq  %k1,%rax
 18d27ab:	62 d2 5d 48 8f c8    	vpshufbitqmb %zmm8,%zmm4,%k1
 18d27b1:	41 29 de             	sub    %ebx,%r14d
 18d27b4:	f3 48 0f b8 f8       	popcnt %rax,%rdi
 18d27b9:	62 f2 7d c9 63 c0    	vpcompressb %zmm0,%zmm0{%k1}{z}
 18d27bf:	c4 e1 fb 93 c1       	kmovq  %k1,%rax
 18d27c4:	f3 48 0f b8 c0       	popcnt %rax,%rax
 18d27c9:	62 f1 fe 48 7f 0c 0a 	vmovdqu64 %zmm1,(%rdx,%rcx,1)
 18d27d0:	62 f1 1d 48 fe cb    	vpaddd %zmm3,%zmm12,%zmm1
 18d27d6:	48 01 f8             	add    %rdi,%rax
 18d27d9:	48 01 f0             	add    %rsi,%rax
 18d27dc:	62 f1 fe 48 7f 04 37 	vmovdqu64 %zmm0,(%rdi,%rsi,1)
 18d27e3:	62 d2 7d 48 55 c5    	vpopcntd %zmm13,%zmm0
 18d27e9:	44 89 74 24 3c       	mov    %r14d,0x3c(%rsp)
 18d27ee:	49 89 c6             	mov    %rax,%r14
 18d27f1:	62 f1 75 48 fe c0    	vpaddd %zmm0,%zmm1,%zmm0
 18d27f7:	c5 f9 6f 0d f1 3b ca fe 	vmovdqa -0x135c40f(%rip),%xmm1        # 5763f0 <x86_effects_unknown+0x990>
 18d27ff:	62 f2 75 48 8d c0    	vpermb %zmm0,%zmm1,%zmm0
 18d2805:	62 f2 fd 18 40 05 31 dc ca fe 	vpmullq -0x13523cf(%rip){1to2},%xmm0,%xmm0        # 580440 <x86_semantics_benchmark_code.registers+0x450>
 18d280f:	c5 f9 6f 0d e9 3b ca fe 	vmovdqa -0x135c417(%rip),%xmm1        # 576400 <x86_effects_unknown+0x9a0>
 18d2817:	c4 e2 79 00 15 f0 3b ca fe 	vpshufb -0x135c410(%rip),%xmm0,%xmm2        # 576410 <x86_effects_unknown+0x9b0>
 18d2820:	62 f2 75 48 8d cd    	vpermb %zmm5,%zmm1,%zmm1
 18d2826:	c5 e9 fc c0          	vpaddb %xmm0,%xmm2,%xmm0
 18d282a:	62 f2 7d 48 31 c0    	vpmovzxbd %xmm0,%zmm0
 18d2830:	62 f1 7d 58 fe 44 24 0f 	vpaddd 0x3c(%rsp){1to16},%zmm0,%zmm0
 18d2838:	62 f2 7e 48 29 c9    	vpmovb2m %zmm1,%k1
 18d283e:	62 f2 7d c9 8b c0    	vpcompressd %zmm0,%zmm0{%k1}{z}
 18d2844:	62 d1 fe 48 7f 07    	vmovdqu64 %zmm0,(%r15)
 18d284a:	e9 89 0b 00 00       	jmp    18d33d8 <x86_encode_16+0x1898>
 18d284f:	62 f2 7d 48 5a 1d 87 3b ca fe 	vbroadcasti32x4 -0x135c479(%rip),%zmm3        # 5763e0 <x86_effects_unknown+0x980>
 18d2859:	62 72 7d 48 58 0d bd dd ca fe 	vpbroadcastd -0x1352243(%rip),%zmm9        # 580620 <tier0_emit_x87.operations+0x1d8>
 18d2863:	48 8d 4a f0          	lea    -0x10(%rdx),%rcx
 18d2867:	41 b1 cc             	mov    $0xcc,%r9b
 18d286a:	48 8d be fc 00 00 00 	lea    0xfc(%rsi),%rdi
 18d2871:	4c 8d 05 08 d2 d5 0c 	lea    0xcd5d208(%rip),%r8        # e62fa80 <x86_template_storage>
 18d2878:	62 53 1d 48 25 e4 ff 	vpternlogd $0xff,%zmm12,%zmm12,%zmm12
 18d287f:	31 c0                	xor    %eax,%eax
 18d2881:	49 89 de             	mov    %rbx,%r14
 18d2884:	48 c1 e9 04          	shr    $0x4,%rcx
 18d2888:	c4 c1 7b 92 c9       	kmovd  %r9d,%k1
 18d288d:	48 ff c1             	inc    %rcx
 18d2890:	44 0f b7 8f 10 ff ff ff 	movzwl -0xf0(%rdi),%r9d
 18d2898:	44 0f b7 97 20 ff ff ff 	movzwl -0xe0(%rdi),%r10d
 18d28a0:	44 0f b7 9f 30 ff ff ff 	movzwl -0xd0(%rdi),%r11d
 18d28a8:	44 0f b7 bf 40 ff ff ff 	movzwl -0xc0(%rdi),%r15d
 18d28b0:	62 e1 fe 48 6f 9f 04 ff ff ff 	vmovdqu64 -0xfc(%rdi),%zmm19
 18d28ba:	62 e1 fe 48 6f af 44 ff ff ff 	vmovdqu64 -0xbc(%rdi),%zmm21
 18d28c4:	62 e1 fe 48 6f b7 84 ff ff ff 	vmovdqu64 -0x7c(%rdi),%zmm22
 18d28ce:	62 e1 fe 48 6f bf c4 ff ff ff 	vmovdqu64 -0x3c(%rdi),%zmm23
 18d28d8:	62 f2 7d 48 5a 0d 3e 3b ca fe 	vbroadcasti32x4 -0x135c4c2(%rip),%zmm1        # 576420 <x86_effects_unknown+0x9c0>
 18d28e2:	48 83 c0 10          	add    $0x10,%rax
 18d28e6:	41 c1 e1 06          	shl    $0x6,%r9d
 18d28ea:	41 c1 e2 06          	shl    $0x6,%r10d
 18d28ee:	41 c1 e3 06          	shl    $0x6,%r11d
 18d28f2:	41 c1 e7 06          	shl    $0x6,%r15d
 18d28f6:	c4 81 7d 6f 64 01 40 	vmovdqa 0x40(%r9,%r8,1),%ymm4
 18d28fd:	44 0f b7 8f 50 ff ff ff 	movzwl -0xb0(%rdi),%r9d
 18d2905:	c4 81 7d 6f 6c 02 60 	vmovdqa 0x60(%r10,%r8,1),%ymm5
 18d290c:	44 0f b7 97 60 ff ff ff 	movzwl -0xa0(%rdi),%r10d
 18d2914:	62 93 dd 48 3a 64 03 02 01 	vinserti64x4 $0x1,0x40(%r11,%r8,1),%zmm4,%zmm4
 18d291d:	62 13 d5 48 3a 7c 07 03 01 	vinserti64x4 $0x1,0x60(%r15,%r8,1),%zmm5,%zmm15
 18d2926:	44 0f b7 9f 70 ff ff ff 	movzwl -0x90(%rdi),%r11d
 18d292e:	44 0f b7 7f 80       	movzwl -0x80(%rdi),%r15d
 18d2933:	62 b1 65 40 62 f5    	vpunpckldq %zmm21,%zmm19,%zmm6
 18d2939:	62 b1 4d 40 62 ff    	vpunpckldq %zmm23,%zmm22,%zmm7
 18d293f:	62 a1 4d 40 6a f7    	vpunpckhdq %zmm23,%zmm22,%zmm22
 18d2945:	62 a1 65 40 6a ed    	vpunpckhdq %zmm21,%zmm19,%zmm21
 18d294b:	62 b1 d5 40 6c d6    	vpunpcklqdq %zmm22,%zmm21,%zmm2
 18d2951:	62 e1 cd 48 6d ff    	vpunpckhqdq %zmm7,%zmm6,%zmm23
 18d2957:	62 62 f5 48 83 da    	vpmultishiftqb %zmm2,%zmm1,%zmm27
 18d295d:	62 f2 7d 48 5a 0d d9 3a ca fe 	vbroadcasti32x4 -0x135c527(%rip),%zmm1        # 576440 <x86_effects_unknown+0x9e0>
 18d2967:	62 f1 15 40 72 d2 1a 	vpsrld $0x1a,%zmm2,%zmm29
 18d296e:	62 b2 45 40 27 c7    	vptestmd %zmm23,%zmm23,%k0
 18d2974:	62 e1 fd 48 6f da    	vmovdqa64 %zmm2,%zmm19
 18d297a:	41 c1 e1 06          	shl    $0x6,%r9d
 18d297e:	41 c1 e2 06          	shl    $0x6,%r10d
 18d2982:	c4 01 7d 6f 44 01 40 	vmovdqa 0x40(%r9,%r8,1),%ymm8
 18d2989:	44 0f b7 4f 90       	movzwl -0x70(%rdi),%r9d
 18d298e:	41 c1 e3 06          	shl    $0x6,%r11d
 18d2992:	c4 01 7d 6f 54 02 60 	vmovdqa 0x60(%r10,%r8,1),%ymm10
 18d2999:	44 0f b7 57 a0       	movzwl -0x60(%rdi),%r10d
 18d299e:	41 c1 e7 06          	shl    $0x6,%r15d
 18d29a2:	62 13 bd 48 3a 44 03 02 01 	vinserti64x4 $0x1,0x40(%r11,%r8,1),%zmm8,%zmm8
 18d29ab:	62 83 ad 48 3a 4c 07 03 01 	vinserti64x4 $0x1,0x60(%r15,%r8,1),%zmm10,%zmm17
 18d29b4:	44 0f b7 5f b0       	movzwl -0x50(%rdi),%r11d
 18d29b9:	44 0f b7 7f c0       	movzwl -0x40(%rdi),%r15d
 18d29be:	62 d2 dd 49 64 ef    	vpblendmq %zmm15,%zmm4,%zmm5{%k1}
 18d29c4:	41 c1 e1 06          	shl    $0x6,%r9d
 18d29c8:	41 c1 e2 06          	shl    $0x6,%r10d
 18d29cc:	c4 01 7d 6f 5c 01 40 	vmovdqa 0x40(%r9,%r8,1),%ymm11
 18d29d3:	44 0f b7 4f d0       	movzwl -0x30(%rdi),%r9d
 18d29d8:	41 c1 e3 06          	shl    $0x6,%r11d
 18d29dc:	c4 01 7d 6f 6c 02 60 	vmovdqa 0x60(%r10,%r8,1),%ymm13
 18d29e3:	44 0f b7 57 e0       	movzwl -0x20(%rdi),%r10d
 18d29e8:	41 c1 e7 06          	shl    $0x6,%r15d
 18d29ec:	62 62 f5 48 83 f2    	vpmultishiftqb %zmm2,%zmm1,%zmm30
 18d29f2:	62 f2 7d 48 5a 0d 34 3a ca fe 	vbroadcasti32x4 -0x135c5cc(%rip),%zmm1        # 576430 <x86_effects_unknown+0x9d0>
 18d29fc:	62 63 25 50 25 35 f5 db ca fe d8 	vpternlogd $0xd8,-0x135240b(%rip){1to16},%zmm27,%zmm30        # 5805fc <tier0_emit_x87.operations+0x1b4>
 18d2a07:	62 13 a5 48 3a 5c 03 02 01 	vinserti64x4 $0x1,0x40(%r11,%r8,1),%zmm11,%zmm11
 18d2a10:	62 83 95 48 3a 54 07 03 01 	vinserti64x4 $0x1,0x60(%r15,%r8,1),%zmm13,%zmm18
 18d2a19:	44 0f b7 5f f0       	movzwl -0x10(%rdi),%r11d
 18d2a1e:	44 0f b7 3f          	movzwl (%rdi),%r15d
 18d2a22:	48 81 c7 00 01 00 00 	add    $0x100,%rdi
 18d2a29:	62 32 bd 49 64 d1    	vpblendmq %zmm17,%zmm8,%zmm10{%k1}
 18d2a2f:	62 41 55 48 6a c2    	vpunpckhdq %zmm10,%zmm5,%zmm24
 18d2a35:	41 c1 e1 06          	shl    $0x6,%r9d
 18d2a39:	41 c1 e2 06          	shl    $0x6,%r10d
 18d2a3d:	41 c1 e3 06          	shl    $0x6,%r11d
 18d2a41:	c4 01 7d 6f 74 01 40 	vmovdqa 0x40(%r9,%r8,1),%ymm14
 18d2a48:	41 c1 e7 06          	shl    $0x6,%r15d
 18d2a4c:	62 81 fd 28 6f 44 02 03 	vmovdqa64 0x60(%r10,%r8,1),%ymm16
 18d2a54:	62 13 8d 48 3a 74 03 02 01 	vinserti64x4 $0x1,0x40(%r11,%r8,1),%zmm14,%zmm14
 18d2a5d:	62 83 fd 40 3a 64 07 03 01 	vinserti64x4 $0x1,0x60(%r15,%r8,1),%zmm16,%zmm20
 18d2a66:	62 62 f5 48 83 e2    	vpmultishiftqb %zmm2,%zmm1,%zmm28
 18d2a6c:	62 f1 75 48 72 f2 04 	vpslld $0x4,%zmm2,%zmm1
 18d2a73:	62 63 0d 50 25 25 82 db ca fe e4 	vpternlogd $0xe4,-0x135247e(%rip){1to16},%zmm30,%zmm28        # 580600 <tier0_emit_x87.operations+0x1b8>
 18d2a7e:	62 f1 25 40 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm27
 18d2a85:	62 f2 7d 48 5a 0d c1 39 ca fe 	vbroadcasti32x4 -0x135c63f(%rip),%zmm1        # 576450 <x86_effects_unknown+0x9f0>
 18d2a8f:	62 32 a5 49 64 ea    	vpblendmq %zmm18,%zmm11,%zmm13{%k1}
 18d2a95:	62 a2 8d 49 64 c4    	vpblendmq %zmm20,%zmm14,%zmm16{%k1}
 18d2a9b:	62 21 15 48 6a c8    	vpunpckhdq %zmm16,%zmm13,%zmm25
 18d2aa1:	62 01 bd 40 6d d1    	vpunpckhqdq %zmm25,%zmm24,%zmm26
 18d2aa7:	62 62 15 40 36 0d 0f fb c4 fe 	vpermd -0x13b04f1(%rip),%zmm29,%zmm25        # 5225c0 <branch_sizing_patterns+0x2830>
 18d2ab1:	62 62 15 40 36 05 45 fb c4 fe 	vpermd -0x13b04bb(%rip),%zmm29,%zmm24        # 522600 <branch_sizing_patterns+0x2870>
 18d2abb:	62 62 75 48 00 f2    	vpshufb %zmm2,%zmm1,%zmm30
 18d2ac1:	62 f2 7d 48 58 0d 3d db ca fe 	vpbroadcastd -0x13524c3(%rip),%zmm1        # 580608 <tier0_emit_x87.operations+0x1c0>
 18d2acb:	62 62 15 40 36 2d 6b fb c4 fe 	vpermd -0x13b0495(%rip),%zmm29,%zmm29        # 522640 <branch_sizing_patterns+0x28b0>
 18d2ad5:	62 91 7d 48 72 f6 10 	vpslld $0x10,%zmm30,%zmm0
 18d2adc:	62 01 25 40 db f6    	vpandd %zmm30,%zmm27,%zmm30
 18d2ae2:	62 f1 05 40 72 e0 1f 	vpsrad $0x1f,%zmm0,%zmm31
 18d2ae9:	62 b1 7d 48 72 e7 1f 	vpsrad $0x1f,%zmm23,%zmm0
 18d2af0:	62 03 1d 40 25 c1 f8 	vpternlogd $0xf8,%zmm25,%zmm28,%zmm24
 18d2af7:	62 62 7e 48 38 c8    	vpmovm2d %k0,%zmm25
 18d2afd:	62 03 25 40 25 cf c8 	vpternlogd $0xc8,%zmm31,%zmm27,%zmm25
 18d2b04:	62 21 7d 48 ef ff    	vpxord %zmm23,%zmm0,%zmm31
 18d2b0a:	62 f2 7d 48 58 05 f0 da ca fe 	vpbroadcastd -0x1352510(%rip),%zmm0        # 580604 <tier0_emit_x87.operations+0x1bc>
 18d2b14:	62 63 15 50 25 35 1d db ca fe ec 	vpternlogd $0xec,-0x13524e3(%rip){1to16},%zmm29,%zmm30        # 58063c <tier0_emit_x87.operations+0x1f4>
 18d2b1f:	62 91 15 40 72 d2 1d 	vpsrld $0x1d,%zmm26,%zmm29
 18d2b26:	62 02 7d 48 44 ff    	vplzcntd %zmm31,%zmm31
 18d2b2c:	62 63 2d 50 25 35 09 db ca fe f8 	vpternlogd $0xf8,-0x13524f7(%rip){1to16},%zmm26,%zmm30        # 580640 <tier0_emit_x87.operations+0x1f8>
 18d2b37:	62 02 75 48 45 ff    	vpsrlvd %zmm31,%zmm1,%zmm31
 18d2b3d:	62 d1 45 40 fe cc    	vpaddd %zmm12,%zmm23,%zmm1
 18d2b43:	62 93 45 40 25 cf 14 	vpternlogd $0x14,%zmm31,%zmm23,%zmm1
 18d2b4a:	62 f1 05 40 72 d2 08 	vpsrld $0x8,%zmm2,%zmm31
 18d2b51:	62 92 75 48 14 cd    	vprorvd %zmm29,%zmm1,%zmm1
 18d2b57:	62 f1 75 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm1
 18d2b5e:	62 e3 7d 58 25 1d ab da ca fe 6c 	vpternlogd $0x6c,-0x1352555(%rip){1to16},%zmm0,%zmm19        # 580614 <tier0_emit_x87.operations+0x1cc>
 18d2b69:	62 63 7d 58 25 3d a4 da ca fe 6c 	vpternlogd $0x6c,-0x135255c(%rip){1to16},%zmm0,%zmm31        # 580618 <tier0_emit_x87.operations+0x1d0>
 18d2b74:	62 f1 1d 50 db 05 aa da ca fe 	vpandd -0x1352556(%rip){1to16},%zmm28,%zmm0        # 580628 <tier0_emit_x87.operations+0x1e0>
 18d2b7e:	62 91 1d 40 72 d4 03 	vpsrld $0x3,%zmm28,%zmm28
 18d2b85:	62 63 2d 50 25 25 a4 da ca fe a2 	vpternlogd $0xa2,-0x135255c(%rip){1to16},%zmm26,%zmm28        # 580634 <tier0_emit_x87.operations+0x1ec>
 18d2b90:	62 c1 65 40 fe dc    	vpaddd %zmm12,%zmm19,%zmm19
 18d2b96:	62 e3 35 58 25 1d 7b da ca fe ec 	vpternlogd $0xec,-0x1352585(%rip){1to16},%zmm9,%zmm19        # 58061c <tier0_emit_x87.operations+0x1d4>
 18d2ba1:	62 41 05 40 fe fc    	vpaddd %zmm12,%zmm31,%zmm31
 18d2ba7:	62 63 65 50 25 3d 72 da ca fe ec 	vpternlogd $0xec,-0x135258e(%rip){1to16},%zmm19,%zmm31        # 580624 <tier0_emit_x87.operations+0x1dc>
 18d2bb2:	62 93 2d 40 25 c7 f8 	vpternlogd $0xf8,%zmm31,%zmm26,%zmm0
 18d2bb9:	62 e2 7d 58 3b 1d 69 da ca fe 	vpminud -0x1352597(%rip){1to16},%zmm0,%zmm19        # 58062c <tier0_emit_x87.operations+0x1e4>
 18d2bc3:	62 f2 1d 50 3b 05 6b da ca fe 	vpminud -0x1352595(%rip){1to16},%zmm28,%zmm0        # 580638 <tier0_emit_x87.operations+0x1f0>
 18d2bcd:	62 01 fd 48 6f d0    	vmovdqa64 %zmm24,%zmm26
 18d2bd3:	62 63 35 50 25 15 2e da ca fe f8 	vpternlogd $0xf8,-0x13525d2(%rip){1to16},%zmm25,%zmm26        # 58060c <tier0_emit_x87.operations+0x1c4>
 18d2bde:	62 61 35 50 db 3d 5c da ca fe 	vpandd -0x13525a4(%rip){1to16},%zmm25,%zmm31        # 580644 <tier0_emit_x87.operations+0x1fc>
 18d2be8:	62 23 7d 48 25 f3 fe 	vpternlogd $0xfe,%zmm19,%zmm0,%zmm30
 18d2bef:	62 81 fd 48 6f d8    	vmovdqa64 %zmm24,%zmm19
 18d2bf5:	62 e3 25 50 25 1d 10 da ca fe f8 	vpternlogd $0xf8,-0x13525f0(%rip){1to16},%zmm27,%zmm19        # 580610 <tier0_emit_x87.operations+0x1c8>
 18d2c00:	62 b1 7d 48 72 cf 01 	vprold $0x1,%zmm23,%zmm0
 18d2c07:	62 61 25 50 db 1d 37 da ca fe 	vpandd -0x13525c9(%rip){1to16},%zmm27,%zmm27        # 580648 <tier0_emit_x87.operations+0x200>
 18d2c11:	62 83 75 48 25 da b8 	vpternlogd $0xb8,%zmm26,%zmm1,%zmm19
 18d2c18:	62 02 7d 48 14 d5    	vprorvd %zmm29,%zmm0,%zmm26
 18d2c1e:	62 f1 fd 48 6f 05 58 f9 c4 fe 	vmovdqa64 -0x13b06a8(%rip),%zmm0        # 522580 <branch_sizing_patterns+0x27f0>
 18d2c28:	62 03 75 48 25 df b8 	vpternlogd $0xb8,%zmm31,%zmm1,%zmm27
 18d2c2f:	62 23 35 40 25 d7 e2 	vpternlogd $0xe2,%zmm23,%zmm25,%zmm26
 18d2c36:	62 23 75 48 25 d7 e2 	vpternlogd $0xe2,%zmm23,%zmm1,%zmm26
 18d2c3d:	62 f1 cd 48 6c cf    	vpunpcklqdq %zmm7,%zmm6,%zmm1
 18d2c43:	62 d1 1d 40 fe fc    	vpaddd %zmm12,%zmm28,%zmm7
 18d2c49:	62 b1 d5 40 6d f6    	vpunpckhqdq %zmm22,%zmm21,%zmm6
 18d2c4f:	62 f1 45 48 72 e7 1f 	vpsrad $0x1f,%zmm7,%zmm7
 18d2c56:	62 f1 4d 48 eb d2    	vpord  %zmm2,%zmm6,%zmm2
 18d2c5c:	62 f1 6d 48 72 f2 07 	vpslld $0x7,%zmm2,%zmm2
 18d2c63:	62 d2 fd 48 7e e7    	vpermt2q %zmm15,%zmm0,%zmm4
 18d2c69:	62 32 fd 48 7e c1    	vpermt2q %zmm17,%zmm0,%zmm8
 18d2c6f:	62 32 fd 48 7e da    	vpermt2q %zmm18,%zmm0,%zmm11
 18d2c75:	62 32 fd 48 7e f4    	vpermt2q %zmm20,%zmm0,%zmm14
 18d2c7b:	62 91 7d 48 72 d0 10 	vpsrld $0x10,%zmm24,%zmm0
 18d2c82:	62 91 05 48 72 d0 03 	vpsrld $0x3,%zmm24,%zmm15
 18d2c89:	62 73 7d 58 25 3d 9c d9 ca fe ec 	vpternlogd $0xec,-0x1352664(%rip){1to16},%zmm0,%zmm15        # 580630 <tier0_emit_x87.operations+0x1e8>
 18d2c94:	62 f2 7d 48 5a 05 c2 37 ca fe 	vbroadcasti32x4 -0x135c83e(%rip),%zmm0        # 576460 <x86_effects_unknown+0xa00>
 18d2c9e:	62 d1 75 40 72 f7 08 	vpslld $0x8,%zmm15,%zmm17
 18d2ca5:	62 e3 45 58 25 0d 9c d9 ca fe 08 	vpternlogd $0x8,-0x1352664(%rip){1to16},%zmm7,%zmm17        # 58064c <tier0_emit_x87.operations+0x204>
 18d2cb0:	62 f2 fd 48 83 f6    	vpmultishiftqb %zmm6,%zmm0,%zmm6
 18d2cb6:	62 f3 05 58 25 35 93 d9 ca fe d8 	vpternlogd $0xd8,-0x135266d(%rip){1to16},%zmm15,%zmm6        # 580654 <tier0_emit_x87.operations+0x20c>
 18d2cc1:	62 91 25 40 eb fe    	vpord  %zmm30,%zmm27,%zmm7
 18d2cc7:	62 f1 7d 48 70 c7 00 	vpshufd $0x0,%zmm7,%zmm0
 18d2cce:	62 f2 7d 48 8f dc    	vpshufbitqmb %zmm4,%zmm0,%k3
 18d2cd4:	62 f1 7d 48 70 c7 55 	vpshufd $0x55,%zmm7,%zmm0
 18d2cdb:	62 d2 7d 48 8f d0    	vpshufbitqmb %zmm8,%zmm0,%k2
 18d2ce1:	62 f1 7d 48 70 c7 aa 	vpshufd $0xaa,%zmm7,%zmm0
 18d2ce8:	c4 61 fb 93 cb       	kmovq  %k3,%r9
 18d2ced:	f3 4d 0f b8 c9       	popcnt %r9,%r9
 18d2cf2:	c4 61 fb 93 d2       	kmovq  %k2,%r10
 18d2cf7:	f3 4d 0f b8 d2       	popcnt %r10,%r10
 18d2cfc:	62 f3 75 50 25 15 49 d9 ca fe e4 	vpternlogd $0xe4,-0x13526b7(%rip){1to16},%zmm17,%zmm2        # 580650 <tier0_emit_x87.operations+0x208>
 18d2d07:	62 f3 6d 58 25 35 46 d9 ca fe d8 	vpternlogd $0xd8,-0x13526ba(%rip){1to16},%zmm2,%zmm6        # 580658 <tier0_emit_x87.operations+0x210>
 18d2d12:	62 91 75 48 62 d2    	vpunpckldq %zmm26,%zmm1,%zmm2
 18d2d18:	62 91 75 48 6a ca    	vpunpckhdq %zmm26,%zmm1,%zmm1
 18d2d1e:	62 71 65 40 62 fe    	vpunpckldq %zmm6,%zmm19,%zmm15
 18d2d24:	62 f1 65 40 6a f6    	vpunpckhdq %zmm6,%zmm19,%zmm6
 18d2d2a:	62 c1 ed 48 6c cf    	vpunpcklqdq %zmm15,%zmm2,%zmm17
 18d2d30:	62 d1 ed 48 6d d7    	vpunpckhqdq %zmm15,%zmm2,%zmm2
 18d2d36:	62 e1 f5 48 6c d6    	vpunpcklqdq %zmm6,%zmm1,%zmm18
 18d2d3c:	62 f1 f5 48 6d ce    	vpunpckhqdq %zmm6,%zmm1,%zmm1
 18d2d42:	62 f2 75 40 00 e4    	vpshufb %zmm4,%zmm17,%zmm4
 18d2d48:	62 d2 6d 48 00 d0    	vpshufb %zmm8,%zmm2,%zmm2
 18d2d4e:	62 d2 75 48 00 ce    	vpshufb %zmm14,%zmm1,%zmm1
 18d2d54:	62 f3 d5 48 25 e3 78 	vpternlogq $0x78,%zmm3,%zmm5,%zmm4
 18d2d5b:	62 f3 ad 48 25 d3 78 	vpternlogq $0x78,%zmm3,%zmm10,%zmm2
 18d2d62:	62 f3 fd 40 25 cb 78 	vpternlogq $0x78,%zmm3,%zmm16,%zmm1
 18d2d69:	62 f2 7d cb 63 e4    	vpcompressb %zmm4,%zmm4{%k3}{z}
 18d2d6f:	62 f2 7d ca 63 d2    	vpcompressb %zmm2,%zmm2{%k2}{z}
 18d2d75:	62 d2 7d 48 8f db    	vpshufbitqmb %zmm11,%zmm0,%k3
 18d2d7b:	62 f1 7d 48 70 c7 ff 	vpshufd $0xff,%zmm7,%zmm0
 18d2d82:	62 d2 7d 48 8f d6    	vpshufbitqmb %zmm14,%zmm0,%k2
 18d2d88:	c4 61 fb 93 db       	kmovq  %k3,%r11
 18d2d8d:	62 f2 7d ca 63 c9    	vpcompressb %zmm1,%zmm1{%k2}{z}
 18d2d93:	62 d1 fe 48 7f 26    	vmovdqu64 %zmm4,(%r14)
 18d2d99:	62 d2 6d 40 00 e3    	vpshufb %zmm11,%zmm18,%zmm4
 18d2d9f:	62 91 fe 48 7f 14 0e 	vmovdqu64 %zmm2,(%r14,%r9,1)
 18d2da6:	4d 01 f1             	add    %r14,%r9
 18d2da9:	62 f3 95 48 25 e3 78 	vpternlogq $0x78,%zmm3,%zmm13,%zmm4
 18d2db0:	c5 e9 ef d2          	vpxor  %xmm2,%xmm2,%xmm2
 18d2db4:	62 f2 7d cb 63 e2    	vpcompressb %zmm4,%zmm2{%k3}{z}
 18d2dba:	62 91 fe 48 7f 14 0a 	vmovdqu64 %zmm2,(%r10,%r9,1)
 18d2dc1:	4d 01 d1             	add    %r10,%r9
 18d2dc4:	f3 4d 0f b8 d3       	popcnt %r11,%r10
 18d2dc9:	c4 61 fb 93 da       	kmovq  %k2,%r11
 18d2dce:	f3 4d 0f b8 f3       	popcnt %r11,%r14
 18d2dd3:	62 91 fe 48 7f 0c 0a 	vmovdqu64 %zmm1,(%r10,%r9,1)
 18d2dda:	4d 01 d6             	add    %r10,%r14
 18d2ddd:	4d 01 ce             	add    %r9,%r14
 18d2de0:	48 ff c9             	dec    %rcx
 18d2de3:	0f 85 a7 fa ff ff    	jne    18d2890 <x86_encode_16+0xd50>
 18d2de9:	48 29 c2             	sub    %rax,%rdx
 18d2dec:	0f 86 e6 05 00 00    	jbe    18d33d8 <x86_encode_16+0x1898>
 18d2df2:	48 c1 e0 04          	shl    $0x4,%rax
 18d2df6:	48 c1 e2 04          	shl    $0x4,%rdx
 18d2dfa:	48 8d 7c 24 40       	lea    0x40(%rsp),%rdi
 18d2dff:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 18d2e03:	62 f1 fd 48 7f 44 24 04 	vmovdqa64 %zmm0,0x100(%rsp)
 18d2e0b:	62 f1 fd 48 7f 44 24 03 	vmovdqa64 %zmm0,0xc0(%rsp)
 18d2e13:	62 f1 fd 48 7f 44 24 02 	vmovdqa64 %zmm0,0x80(%rsp)
 18d2e1b:	62 f1 fd 48 7f 44 24 01 	vmovdqa64 %zmm0,0x40(%rsp)
 18d2e23:	48 01 c6             	add    %rax,%rsi
 18d2e26:	c5 f8 77             	vzeroupper
 18d2e29:	e8 22 16 e9 fe       	call   764450 <memcpy@plt>
 18d2e2e:	c5 f9 6f 64 24 70    	vmovdqa 0x70(%rsp),%xmm4
 18d2e34:	c5 f9 6f 4c 24 40    	vmovdqa 0x40(%rsp),%xmm1
 18d2e3a:	c5 f9 6f 54 24 50    	vmovdqa 0x50(%rsp),%xmm2
 18d2e40:	c5 f9 6f 5c 24 60    	vmovdqa 0x60(%rsp),%xmm3
 18d2e46:	c5 f9 6f ac 24 80 00 00 00 	vmovdqa 0x80(%rsp),%xmm5
 18d2e4f:	48 8d 05 2a cc d5 0c 	lea    0xcd5cc2a(%rip),%rax        # e62fa80 <x86_template_storage>
 18d2e56:	62 71 fd 48 6f 3d 20 f7 c4 fe 	vmovdqa64 -0x13b08e0(%rip),%zmm15        # 522580 <branch_sizing_patterns+0x27f0>
 18d2e60:	c5 f9 6f bc 24 c0 00 00 00 	vmovdqa 0xc0(%rsp),%xmm7
 18d2e69:	c5 f9 6f b4 24 d0 00 00 00 	vmovdqa 0xd0(%rsp),%xmm6
 18d2e72:	62 71 fd 48 6f 4c 24 01 	vmovdqa64 0x40(%rsp),%zmm9
 18d2e7a:	62 71 fd 48 6f 54 24 02 	vmovdqa64 0x80(%rsp),%zmm10
 18d2e82:	62 71 fd 48 6f 5c 24 03 	vmovdqa64 0xc0(%rsp),%zmm11
 18d2e8a:	62 71 fd 48 6f 64 24 04 	vmovdqa64 0x100(%rsp),%zmm12
 18d2e92:	62 e2 7d 48 5a 0d 94 35 ca fe 	vbroadcasti32x4 -0x135ca6c(%rip),%zmm17        # 576430 <x86_effects_unknown+0x9d0>
 18d2e9c:	62 a3 4d 40 25 f6 ff 	vpternlogd $0xff,%zmm22,%zmm22,%zmm22
 18d2ea3:	62 e2 7d 48 58 25 57 d7 ca fe 	vpbroadcastd -0x13528a9(%rip),%zmm20        # 580604 <tier0_emit_x87.operations+0x1bc>
 18d2ead:	62 62 7d 48 58 15 59 d7 ca fe 	vpbroadcastd -0x13528a7(%rip),%zmm26        # 580610 <tier0_emit_x87.operations+0x1c8>
 18d2eb7:	62 62 7d 48 58 0d 53 d7 ca fe 	vpbroadcastd -0x13528ad(%rip),%zmm25        # 580614 <tier0_emit_x87.operations+0x1cc>
 18d2ec1:	c5 f9 c5 fc 06       	vpextrw $0x6,%xmm4,%edi
 18d2ec6:	c5 f9 6f a4 24 90 00 00 00 	vmovdqa 0x90(%rsp),%xmm4
 18d2ecf:	c5 f9 c5 c9 06       	vpextrw $0x6,%xmm1,%ecx
 18d2ed4:	c5 f9 c5 d2 06       	vpextrw $0x6,%xmm2,%edx
 18d2ed9:	c5 f9 c5 f3 06       	vpextrw $0x6,%xmm3,%esi
 18d2ede:	62 51 35 48 62 ea    	vpunpckldq %zmm10,%zmm9,%zmm13
 18d2ee4:	62 51 25 48 62 f4    	vpunpckldq %zmm12,%zmm11,%zmm14
 18d2eea:	62 51 35 48 6a d2    	vpunpckhdq %zmm10,%zmm9,%zmm10
 18d2ef0:	62 51 25 48 6a e4    	vpunpckhdq %zmm12,%zmm11,%zmm12
 18d2ef6:	c1 e1 06             	shl    $0x6,%ecx
 18d2ef9:	c1 e2 06             	shl    $0x6,%edx
 18d2efc:	c1 e6 06             	shl    $0x6,%esi
 18d2eff:	c1 e7 06             	shl    $0x6,%edi
 18d2f02:	62 51 ad 48 6c dc    	vpunpcklqdq %zmm12,%zmm10,%zmm11
 18d2f08:	62 d1 95 48 6c c6    	vpunpcklqdq %zmm14,%zmm13,%zmm0
 18d2f0e:	62 51 95 48 6d ce    	vpunpckhqdq %zmm14,%zmm13,%zmm9
 18d2f14:	62 51 ad 48 6d e4    	vpunpckhqdq %zmm12,%zmm10,%zmm12
 18d2f1a:	c5 fd 6f 4c 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm1
 18d2f20:	b1 cc                	mov    $0xcc,%cl
 18d2f22:	c5 fd 6f 54 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm2
 18d2f28:	62 c2 f5 40 83 db    	vpmultishiftqb %zmm11,%zmm17,%zmm19
 18d2f2e:	62 d2 35 48 27 c1    	vptestmd %zmm9,%zmm9,%k0
 18d2f34:	62 d1 75 40 72 e1 1f 	vpsrad $0x1f,%zmm9,%zmm17
 18d2f3b:	62 21 35 48 fe c6    	vpaddd %zmm22,%zmm9,%zmm24
 18d2f41:	62 43 5d 40 25 cb 6c 	vpternlogd $0x6c,%zmm11,%zmm20,%zmm25
 18d2f48:	c5 fb 92 c9          	kmovd  %ecx,%k1
 18d2f4c:	c5 f9 c5 cd 06       	vpextrw $0x6,%xmm5,%ecx
 18d2f51:	c5 f9 6f ac 24 a0 00 00 00 	vmovdqa 0xa0(%rsp),%xmm5
 18d2f5a:	62 f3 f5 48 3a 4c 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm1,%zmm1
 18d2f63:	62 f3 ed 48 3a 5c 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm2,%zmm3
 18d2f6c:	c1 e1 06             	shl    $0x6,%ecx
 18d2f6f:	c5 f9 c5 d4 06       	vpextrw $0x6,%xmm4,%edx
 18d2f74:	c5 f9 6f a4 24 b0 00 00 00 	vmovdqa 0xb0(%rsp),%xmm4
 18d2f7d:	c1 e2 06             	shl    $0x6,%edx
 18d2f80:	c5 f9 c5 f5 06       	vpextrw $0x6,%xmm5,%esi
 18d2f85:	62 f2 f5 49 64 d3    	vpblendmq %zmm3,%zmm1,%zmm2{%k1}
 18d2f8b:	62 f2 85 48 7e cb    	vpermt2q %zmm3,%zmm15,%zmm1
 18d2f91:	c5 fd 6f 5c 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm3
 18d2f97:	c5 f9 c5 cf 06       	vpextrw $0x6,%xmm7,%ecx
 18d2f9c:	c5 f9 6f bc 24 e0 00 00 00 	vmovdqa 0xe0(%rsp),%xmm7
 18d2fa5:	c1 e6 06             	shl    $0x6,%esi
 18d2fa8:	c1 e1 06             	shl    $0x6,%ecx
 18d2fab:	62 f3 e5 48 3a 5c 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm3,%zmm3
 18d2fb4:	c5 f9 c5 fc 06       	vpextrw $0x6,%xmm4,%edi
 18d2fb9:	c5 fd 6f 64 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm4
 18d2fbf:	c5 f9 c5 d6 06       	vpextrw $0x6,%xmm6,%edx
 18d2fc4:	c5 f9 6f b4 24 f0 00 00 00 	vmovdqa 0xf0(%rsp),%xmm6
 18d2fcd:	c1 e7 06             	shl    $0x6,%edi
 18d2fd0:	c1 e2 06             	shl    $0x6,%edx
 18d2fd3:	62 f3 dd 48 3a 6c 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm4,%zmm5
 18d2fdc:	c5 f9 c5 f7 06       	vpextrw $0x6,%xmm7,%esi
 18d2fe1:	c1 e6 06             	shl    $0x6,%esi
 18d2fe4:	c5 f9 c5 fe 06       	vpextrw $0x6,%xmm6,%edi
 18d2fe9:	c5 fd 6f 74 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm6
 18d2fef:	0f b7 94 24 1c 01 00 00 	movzwl 0x11c(%rsp),%edx
 18d2ff7:	c1 e7 06             	shl    $0x6,%edi
 18d2ffa:	62 f2 e5 49 64 e5    	vpblendmq %zmm5,%zmm3,%zmm4{%k1}
 18d3000:	62 f2 85 48 7e dd    	vpermt2q %zmm5,%zmm15,%zmm3
 18d3006:	c5 fd 6f 6c 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm5
 18d300c:	62 f3 cd 48 3a 7c 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm6,%zmm7
 18d3015:	0f b7 8c 24 0c 01 00 00 	movzwl 0x10c(%rsp),%ecx
 18d301d:	0f b7 bc 24 3c 01 00 00 	movzwl 0x13c(%rsp),%edi
 18d3025:	62 f3 d5 48 3a 6c 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm5,%zmm5
 18d302e:	0f b7 b4 24 2c 01 00 00 	movzwl 0x12c(%rsp),%esi
 18d3036:	62 71 6d 48 6a d4    	vpunpckhdq %zmm4,%zmm2,%zmm10
 18d303c:	c1 e2 06             	shl    $0x6,%edx
 18d303f:	c5 7d 6f 44 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm8
 18d3045:	c1 e1 06             	shl    $0x6,%ecx
 18d3048:	c1 e7 06             	shl    $0x6,%edi
 18d304b:	c1 e6 06             	shl    $0x6,%esi
 18d304e:	62 e3 bd 48 3a 44 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm8,%zmm16
 18d3057:	62 f2 d5 49 64 f7    	vpblendmq %zmm7,%zmm5,%zmm6{%k1}
 18d305d:	62 f2 85 48 7e ef    	vpermt2q %zmm7,%zmm15,%zmm5
 18d3063:	c5 fd 6f 7c 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm7
 18d3069:	62 f3 c5 48 3a 7c 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm7,%zmm7
 18d3072:	62 32 c5 49 64 c0    	vpblendmq %zmm16,%zmm7,%zmm8{%k1}
 18d3078:	62 b2 85 48 7e f8    	vpermt2q %zmm16,%zmm15,%zmm7
 18d307e:	62 e2 7d 48 5a 05 98 33 ca fe 	vbroadcasti32x4 -0x135cc68(%rip),%zmm16        # 576420 <x86_effects_unknown+0x9c0>
 18d3088:	62 51 4d 48 6a e8    	vpunpckhdq %zmm8,%zmm6,%zmm13
 18d308e:	62 51 ad 48 6d d5    	vpunpckhqdq %zmm13,%zmm10,%zmm10
 18d3094:	62 d1 15 48 72 d3 1a 	vpsrld $0x1a,%zmm11,%zmm13
 18d309b:	62 72 15 48 36 35 1b f5 c4 fe 	vpermd -0x13b0ae5(%rip),%zmm13,%zmm14        # 5225c0 <branch_sizing_patterns+0x2830>
 18d30a5:	62 e2 15 48 36 15 51 f5 c4 fe 	vpermd -0x13b0aaf(%rip),%zmm13,%zmm18        # 522600 <branch_sizing_patterns+0x2870>
 18d30af:	62 72 15 48 36 2d 87 f5 c4 fe 	vpermd -0x13b0a79(%rip),%zmm13,%zmm13        # 522640 <branch_sizing_patterns+0x28b0>
 18d30b9:	62 d1 45 40 72 d2 1d 	vpsrld $0x1d,%zmm10,%zmm23
 18d30c0:	62 52 fd 40 83 fb    	vpmultishiftqb %zmm11,%zmm16,%zmm15
 18d30c6:	62 e2 7d 48 5a 05 70 33 ca fe 	vbroadcasti32x4 -0x135cc90(%rip),%zmm16        # 576440 <x86_effects_unknown+0x9e0>
 18d30d0:	62 c2 fd 40 83 c3    	vpmultishiftqb %zmm11,%zmm16,%zmm16
 18d30d6:	62 e3 05 58 25 05 1b d5 ca fe d8 	vpternlogd $0xd8,-0x1352ae5(%rip){1to16},%zmm15,%zmm16        # 5805fc <tier0_emit_x87.operations+0x1b4>
 18d30e1:	62 d1 05 48 72 f3 04 	vpslld $0x4,%zmm11,%zmm15
 18d30e8:	62 d1 05 48 72 e7 1f 	vpsrad $0x1f,%zmm15,%zmm15
 18d30ef:	62 e3 7d 50 25 1d 06 d5 ca fe e4 	vpternlogd $0xe4,-0x1352afa(%rip){1to16},%zmm16,%zmm19        # 580600 <tier0_emit_x87.operations+0x1b8>
 18d30fa:	62 e2 7d 48 5a 05 4c 33 ca fe 	vbroadcasti32x4 -0x135ccb4(%rip),%zmm16        # 576450 <x86_effects_unknown+0x9f0>
 18d3104:	62 c2 7d 40 00 eb    	vpshufb %zmm11,%zmm16,%zmm21
 18d310a:	62 c3 65 40 25 d6 f8 	vpternlogd $0xf8,%zmm14,%zmm19,%zmm18
 18d3111:	62 23 05 48 25 d2 ea 	vpternlogd $0xea,%zmm18,%zmm15,%zmm26
 18d3118:	62 b1 0d 48 72 f5 10 	vpslld $0x10,%zmm21,%zmm14
 18d311f:	62 d1 7d 40 72 e6 1f 	vpsrad $0x1f,%zmm14,%zmm16
 18d3126:	62 72 7e 48 38 f0    	vpmovm2d %k0,%zmm14
 18d312c:	62 33 05 48 25 f0 c8 	vpternlogd $0xc8,%zmm16,%zmm15,%zmm14
 18d3133:	62 c1 75 40 ef c1    	vpxord %zmm9,%zmm17,%zmm16
 18d3139:	62 e2 7d 48 58 0d c5 d4 ca fe 	vpbroadcastd -0x1352b3b(%rip),%zmm17        # 580608 <tier0_emit_x87.operations+0x1c0>
 18d3143:	62 a2 7d 48 44 c0    	vplzcntd %zmm16,%zmm16
 18d3149:	62 a2 75 40 45 c0    	vpsrlvd %zmm16,%zmm17,%zmm16
 18d314f:	62 23 35 48 25 c0 14 	vpternlogd $0x14,%zmm16,%zmm9,%zmm24
 18d3156:	62 a2 3d 40 14 c7    	vprorvd %zmm23,%zmm24,%zmm16
 18d315c:	62 62 7d 48 58 05 a6 d4 ca fe 	vpbroadcastd -0x1352b5a(%rip),%zmm24        # 58060c <tier0_emit_x87.operations+0x1c4>
 18d3166:	62 b1 7d 40 72 e0 1f 	vpsrad $0x1f,%zmm16,%zmm16
 18d316d:	62 23 0d 48 25 c2 ea 	vpternlogd $0xea,%zmm18,%zmm14,%zmm24
 18d3174:	62 03 7d 40 25 d0 b8 	vpternlogd $0xb8,%zmm24,%zmm16,%zmm26
 18d317b:	62 21 35 40 fe c6    	vpaddd %zmm22,%zmm25,%zmm24
 18d3181:	62 d1 35 40 72 d3 08 	vpsrld $0x8,%zmm11,%zmm25
 18d3188:	62 63 5d 50 25 0d 85 d4 ca fe 6c 	vpternlogd $0x6c,-0x1352b7b(%rip){1to16},%zmm20,%zmm25        # 580618 <tier0_emit_x87.operations+0x1d0>
 18d3193:	62 51 1d 48 eb db    	vpord  %zmm11,%zmm12,%zmm11
 18d3199:	62 d1 25 48 72 f3 07 	vpslld $0x7,%zmm11,%zmm11
 18d31a0:	62 a1 35 40 fe e6    	vpaddd %zmm22,%zmm25,%zmm20
 18d31a6:	62 62 7d 48 58 0d 6c d4 ca fe 	vpbroadcastd -0x1352b94(%rip),%zmm25        # 58061c <tier0_emit_x87.operations+0x1d4>
 18d31b0:	62 63 3d 50 25 0d 65 d4 ca fe ea 	vpternlogd $0xea,-0x1352b9b(%rip){1to16},%zmm24,%zmm25        # 580620 <tier0_emit_x87.operations+0x1d8>
 18d31bb:	62 61 65 50 db 05 63 d4 ca fe 	vpandd -0x1352b9d(%rip){1to16},%zmm19,%zmm24        # 580628 <tier0_emit_x87.operations+0x1e0>
 18d31c5:	62 b1 65 40 72 d3 03 	vpsrld $0x3,%zmm19,%zmm19
 18d31cc:	62 e3 2d 58 25 1d 5d d4 ca fe a2 	vpternlogd $0xa2,-0x1352ba3(%rip){1to16},%zmm10,%zmm19        # 580634 <tier0_emit_x87.operations+0x1ec>
 18d31d7:	62 63 5d 50 25 0d 42 d4 ca fe f8 	vpternlogd $0xf8,-0x1352bbe(%rip){1to16},%zmm20,%zmm25        # 580624 <tier0_emit_x87.operations+0x1dc>
 18d31e2:	62 a1 65 40 fe f6    	vpaddd %zmm22,%zmm19,%zmm22
 18d31e8:	62 e2 65 50 3b 1d 46 d4 ca fe 	vpminud -0x1352bba(%rip){1to16},%zmm19,%zmm19        # 580638 <tier0_emit_x87.operations+0x1f0>
 18d31f2:	62 03 2d 48 25 c1 f8 	vpternlogd $0xf8,%zmm25,%zmm10,%zmm24
 18d31f9:	62 e2 3d 50 3b 25 29 d4 ca fe 	vpminud -0x1352bd7(%rip){1to16},%zmm24,%zmm20        # 58062c <tier0_emit_x87.operations+0x1e4>
 18d3203:	62 b1 3d 40 72 d2 10 	vpsrld $0x10,%zmm18,%zmm24
 18d320a:	62 b1 6d 40 72 d2 03 	vpsrld $0x3,%zmm18,%zmm18
 18d3211:	62 b1 4d 40 72 e6 1f 	vpsrad $0x1f,%zmm22,%zmm22
 18d3218:	62 e3 3d 50 25 15 0d d4 ca fe ec 	vpternlogd $0xec,-0x1352bf3(%rip){1to16},%zmm24,%zmm18        # 580630 <tier0_emit_x87.operations+0x1e8>
 18d3223:	62 b1 3d 40 72 f2 08 	vpslld $0x8,%zmm18,%zmm24
 18d322a:	62 63 4d 50 25 05 17 d4 ca fe 08 	vpternlogd $0x8,-0x1352be9(%rip){1to16},%zmm22,%zmm24        # 58064c <tier0_emit_x87.operations+0x204>
 18d3235:	62 e2 7d 48 5a 35 21 32 ca fe 	vbroadcasti32x4 -0x135cddf(%rip),%zmm22        # 576460 <x86_effects_unknown+0xa00>
 18d323f:	62 73 3d 50 25 1d 06 d4 ca fe e4 	vpternlogd $0xe4,-0x1352bfa(%rip){1to16},%zmm24,%zmm11        # 580650 <tier0_emit_x87.operations+0x208>
 18d324a:	62 c2 cd 40 83 f4    	vpmultishiftqb %zmm12,%zmm22,%zmm22
 18d3250:	62 31 05 48 db e5    	vpandd %zmm21,%zmm15,%zmm12
 18d3256:	62 73 15 58 25 25 db d3 ca fe ec 	vpternlogd $0xec,-0x1352c25(%rip){1to16},%zmm13,%zmm12        # 58063c <tier0_emit_x87.operations+0x1f4>
 18d3261:	62 e3 6d 50 25 35 e8 d3 ca fe d8 	vpternlogd $0xd8,-0x1352c18(%rip){1to16},%zmm18,%zmm22        # 580654 <tier0_emit_x87.operations+0x20c>
 18d326c:	62 71 05 58 db 2d d2 d3 ca fe 	vpandd -0x1352c2e(%rip){1to16},%zmm15,%zmm13        # 580648 <tier0_emit_x87.operations+0x200>
 18d3276:	62 73 2d 58 25 25 bf d3 ca fe f8 	vpternlogd $0xf8,-0x1352c41(%rip){1to16},%zmm10,%zmm12        # 580640 <tier0_emit_x87.operations+0x1f8>
 18d3281:	62 71 0d 58 db 15 b9 d3 ca fe 	vpandd -0x1352c47(%rip){1to16},%zmm14,%zmm10        # 580644 <tier0_emit_x87.operations+0x1fc>
 18d328b:	62 e3 25 58 25 35 c2 d3 ca fe d8 	vpternlogd $0xd8,-0x1352c3e(%rip){1to16},%zmm11,%zmm22        # 580658 <tier0_emit_x87.operations+0x210>
 18d3296:	62 d1 25 48 72 c9 01 	vprold $0x1,%zmm9,%zmm11
 18d329d:	62 33 65 40 25 e4 fe 	vpternlogd $0xfe,%zmm20,%zmm19,%zmm12
 18d32a4:	62 53 7d 40 25 ea b8 	vpternlogd $0xb8,%zmm10,%zmm16,%zmm13
 18d32ab:	62 32 25 48 14 df    	vprorvd %zmm23,%zmm11,%zmm11
 18d32b1:	62 51 15 48 eb d4    	vpord  %zmm12,%zmm13,%zmm10
 18d32b7:	62 51 7d 48 70 fa 00 	vpshufd $0x0,%zmm10,%zmm15
 18d32be:	62 53 0d 48 25 d9 e2 	vpternlogd $0xe2,%zmm9,%zmm14,%zmm11
 18d32c5:	62 72 7d 48 5a 35 11 31 ca fe 	vbroadcasti32x4 -0x135ceef(%rip),%zmm14        # 5763e0 <x86_effects_unknown+0x980>
 18d32cf:	62 f2 05 48 8f c9    	vpshufbitqmb %zmm1,%zmm15,%k1
 18d32d5:	62 53 7d 40 25 d9 e2 	vpternlogd $0xe2,%zmm9,%zmm16,%zmm11
 18d32dc:	62 51 7d 48 62 cb    	vpunpckldq %zmm11,%zmm0,%zmm9
 18d32e2:	62 d1 7d 48 6a c3    	vpunpckhdq %zmm11,%zmm0,%zmm0
 18d32e8:	c4 e1 fb 93 c1       	kmovq  %k1,%rax
 18d32ed:	62 31 2d 40 62 de    	vpunpckldq %zmm22,%zmm26,%zmm11
 18d32f3:	62 31 2d 40 6a e6    	vpunpckhdq %zmm22,%zmm26,%zmm12
 18d32f9:	f3 48 0f b8 c0       	popcnt %rax,%rax
 18d32fe:	62 51 b5 48 6c eb    	vpunpcklqdq %zmm11,%zmm9,%zmm13
 18d3304:	62 c1 fd 48 6c c4    	vpunpcklqdq %zmm12,%zmm0,%zmm16
 18d330a:	62 d1 fd 48 6d c4    	vpunpckhqdq %zmm12,%zmm0,%zmm0
 18d3310:	62 51 b5 48 6d cb    	vpunpckhqdq %zmm11,%zmm9,%zmm9
 18d3316:	62 51 7d 48 70 e2 55 	vpshufd $0x55,%zmm10,%zmm12
 18d331d:	49 8d 0c 06          	lea    (%r14,%rax,1),%rcx
 18d3321:	62 72 15 48 00 e9    	vpshufb %zmm1,%zmm13,%zmm13
 18d3327:	62 f2 7d 48 00 c7    	vpshufb %zmm7,%zmm0,%zmm0
 18d332d:	62 53 ed 48 25 ee 78 	vpternlogq $0x78,%zmm14,%zmm2,%zmm13
 18d3334:	62 f2 35 48 00 d3    	vpshufb %zmm3,%zmm9,%zmm2
 18d333a:	62 d3 bd 48 25 c6 78 	vpternlogq $0x78,%zmm14,%zmm8,%zmm0
 18d3341:	62 72 7d c9 63 e9    	vpcompressb %zmm13,%zmm1{%k1}{z}
 18d3347:	62 f2 1d 48 8f cb    	vpshufbitqmb %zmm3,%zmm12,%k1
 18d334d:	62 d1 7d 48 70 da aa 	vpshufd $0xaa,%zmm10,%zmm3
 18d3354:	62 d3 dd 48 25 d6 78 	vpternlogq $0x78,%zmm14,%zmm4,%zmm2
 18d335b:	c4 e1 fb 93 d1       	kmovq  %k1,%rdx
 18d3360:	f3 48 0f b8 d2       	popcnt %rdx,%rdx
 18d3365:	62 d1 fe 48 7f 0e    	vmovdqu64 %zmm1,(%r14)
 18d336b:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
 18d336f:	62 f2 7d c9 63 d1    	vpcompressb %zmm2,%zmm1{%k1}{z}
 18d3375:	62 f2 7d 40 00 d5    	vpshufb %zmm5,%zmm16,%zmm2
 18d337b:	62 f2 65 48 8f cd    	vpshufbitqmb %zmm5,%zmm3,%k1
 18d3381:	62 d3 cd 48 25 d6 78 	vpternlogq $0x78,%zmm14,%zmm6,%zmm2
 18d3388:	c4 e1 fb 93 f1       	kmovq  %k1,%rsi
 18d338d:	f3 48 0f b8 f6       	popcnt %rsi,%rsi
 18d3392:	62 d1 fe 48 7f 0c 06 	vmovdqu64 %zmm1,(%r14,%rax,1)
 18d3399:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
 18d339d:	62 f2 7d c9 63 d1    	vpcompressb %zmm2,%zmm1{%k1}{z}
 18d33a3:	62 d1 7d 48 70 d2 ff 	vpshufd $0xff,%zmm10,%zmm2
 18d33aa:	48 8d 04 11          	lea    (%rcx,%rdx,1),%rax
 18d33ae:	62 f2 6d 48 8f cf    	vpshufbitqmb %zmm7,%zmm2,%k1
 18d33b4:	62 f2 7d c9 63 c0    	vpcompressb %zmm0,%zmm0{%k1}{z}
 18d33ba:	62 f1 fe 48 7f 0c 0a 	vmovdqu64 %zmm1,(%rdx,%rcx,1)
 18d33c1:	c4 e1 fb 93 c9       	kmovq  %k1,%rcx
 18d33c6:	f3 4c 0f b8 f1       	popcnt %rcx,%r14
 18d33cb:	49 01 f6             	add    %rsi,%r14
 18d33ce:	49 01 c6             	add    %rax,%r14
 18d33d1:	62 f1 fe 48 7f 04 06 	vmovdqu64 %zmm0,(%rsi,%rax,1)
 18d33d8:	49 29 de             	sub    %rbx,%r14
 18d33db:	64 48 8b 04 25 28 00 00 00 	mov    %fs:0x28,%rax
 18d33e4:	48 3b 84 24 48 01 00 00 	cmp    0x148(%rsp),%rax
 18d33ec:	75 13                	jne    18d3401 <x86_encode_16+0x18c1>
 18d33ee:	4c 89 f0             	mov    %r14,%rax
 18d33f1:	48 8d 65 e0          	lea    -0x20(%rbp),%rsp
 18d33f5:	5b                   	pop    %rbx
 18d33f6:	41 5c                	pop    %r12
 18d33f8:	41 5e                	pop    %r14
 18d33fa:	41 5f                	pop    %r15
 18d33fc:	5d                   	pop    %rbp
 18d33fd:	c5 f8 77             	vzeroupper
 18d3400:	c3                   	ret
 18d3401:	c5 f8 77             	vzeroupper
 18d3404:	e8 d7 06 e9 fe       	call   763ae0 <__stack_chk_fail@plt>
