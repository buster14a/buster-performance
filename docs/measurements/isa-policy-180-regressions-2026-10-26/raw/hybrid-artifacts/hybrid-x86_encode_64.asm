
/home/david/buster-fast-bench/codex-180-fix-20261027-hybrid/build/compiler:     file format elf64-x86-64


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

0000000000c6e6a0 <x86_encode_64>:
  c6e6a0:	55                   	push   %rbp
  c6e6a1:	48 89 e5             	mov    %rsp,%rbp
  c6e6a4:	41 57                	push   %r15
  c6e6a6:	41 56                	push   %r14
  c6e6a8:	41 55                	push   %r13
  c6e6aa:	41 54                	push   %r12
  c6e6ac:	53                   	push   %rbx
  c6e6ad:	48 83 e4 c0          	and    $0xffffffffffffffc0,%rsp
  c6e6b1:	48 81 ec 40 02 00 00 	sub    $0x240,%rsp
  c6e6b8:	64 48 8b 04 25 28 00 00 00 	mov    %fs:0x28,%rax
  c6e6c1:	48 89 d3             	mov    %rdx,%rbx
  c6e6c4:	48 89 84 24 00 02 00 00 	mov    %rax,0x200(%rsp)
  c6e6cc:	4d 85 c0             	test   %r8,%r8
  c6e6cf:	0f 84 8a 06 00 00    	je     c6ed5f <x86_encode_64+0x6bf>
  c6e6d5:	48 85 c9             	test   %rcx,%rcx
  c6e6d8:	0f 84 d2 0c 00 00    	je     c6f3b0 <x86_encode_64+0xd10>
  c6e6de:	48 83 fe 40          	cmp    $0x40,%rsi
  c6e6e2:	0f 83 2a 13 00 00    	jae    c6fa12 <x86_encode_64+0x1372>
  c6e6e8:	31 c0                	xor    %eax,%eax
  c6e6ea:	48 89 da             	mov    %rbx,%rdx
  c6e6ed:	4c 8d 48 10          	lea    0x10(%rax),%r9
  c6e6f1:	49 39 f1             	cmp    %rsi,%r9
  c6e6f4:	0f 87 72 1a 00 00    	ja     c7016c <x86_encode_64+0x1acc>
  c6e6fa:	62 f2 7d 48 5a 1d 2c 41 8e ff 	vbroadcasti32x4 -0x71bed4(%rip),%zmm3        # 552830 <x86_disassembly_listing.hex+0xd40>
  c6e704:	62 72 7d 48 58 0d ba a4 90 ff 	vpbroadcastd -0x6f5b46(%rip),%zmm9        # 578bc8 <x86_break_instruction.legacy_forms+0x650>
  c6e70e:	49 89 c1             	mov    %rax,%r9
  c6e711:	49 c1 e1 04          	shl    $0x4,%r9
  c6e715:	41 b3 cc             	mov    $0xcc,%r11b
  c6e718:	4c 8d 15 61 3c 13 02 	lea    0x2133c61(%rip),%r10        # 2da2380 <x86_template_storage>
  c6e71f:	62 53 1d 48 25 e4 ff 	vpternlogd $0xff,%zmm12,%zmm12,%zmm12
  c6e726:	4d 8d 8c 39 fc 00 00 00 	lea    0xfc(%r9,%rdi,1),%r9
  c6e72e:	c4 c1 7b 92 cb       	kmovd  %r11d,%k1
  c6e733:	66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  c6e740:	45 0f b7 99 10 ff ff ff 	movzwl -0xf0(%r9),%r11d
  c6e748:	45 0f b7 b1 20 ff ff ff 	movzwl -0xe0(%r9),%r14d
  c6e750:	45 0f b7 b9 30 ff ff ff 	movzwl -0xd0(%r9),%r15d
  c6e758:	45 0f b7 a1 40 ff ff ff 	movzwl -0xc0(%r9),%r12d
  c6e760:	62 c1 fe 48 6f a1 04 ff ff ff 	vmovdqu64 -0xfc(%r9),%zmm20
  c6e76a:	62 41 fe 48 6f 99 44 ff ff ff 	vmovdqu64 -0xbc(%r9),%zmm27
  c6e774:	62 41 fe 48 6f a1 84 ff ff ff 	vmovdqu64 -0x7c(%r9),%zmm28
  c6e77e:	62 41 fe 48 6f a9 c4 ff ff ff 	vmovdqu64 -0x3c(%r9),%zmm29
  c6e788:	62 f2 7d 48 5a 05 de 40 8e ff 	vbroadcasti32x4 -0x71bf22(%rip),%zmm0        # 552870 <x86_disassembly_listing.hex+0xd80>
  c6e792:	62 f2 7d 48 5a 2d e4 40 8e ff 	vbroadcasti32x4 -0x71bf1c(%rip),%zmm5        # 552880 <x86_disassembly_listing.hex+0xd90>
  c6e79c:	62 f2 7d 48 5a 35 ea 40 8e ff 	vbroadcasti32x4 -0x71bf16(%rip),%zmm6        # 552890 <x86_disassembly_listing.hex+0xda0>
  c6e7a6:	62 72 7d 48 58 05 00 a4 90 ff 	vpbroadcastd -0x6f5c00(%rip),%zmm8        # 578bb0 <x86_break_instruction.legacy_forms+0x638>
  c6e7b0:	41 c1 e3 06          	shl    $0x6,%r11d
  c6e7b4:	41 c1 e6 06          	shl    $0x6,%r14d
  c6e7b8:	41 c1 e7 06          	shl    $0x6,%r15d
  c6e7bc:	41 c1 e4 06          	shl    $0x6,%r12d
  c6e7c0:	c4 81 7d 6f 4c 13 40 	vmovdqa 0x40(%r11,%r10,1),%ymm1
  c6e7c7:	45 0f b7 99 50 ff ff ff 	movzwl -0xb0(%r9),%r11d
  c6e7cf:	62 13 f5 48 3a 5c 17 02 01 	vinserti64x4 $0x1,0x40(%r15,%r10,1),%zmm1,%zmm11
  c6e7d8:	45 0f b7 b9 70 ff ff ff 	movzwl -0x90(%r9),%r15d
  c6e7e0:	c4 81 7d 6f 4c 16 60 	vmovdqa 0x60(%r14,%r10,1),%ymm1
  c6e7e7:	45 0f b7 b1 60 ff ff ff 	movzwl -0xa0(%r9),%r14d
  c6e7ef:	62 83 f5 48 3a 74 14 03 01 	vinserti64x4 $0x1,0x60(%r12,%r10,1),%zmm1,%zmm22
  c6e7f8:	45 0f b7 61 80       	movzwl -0x80(%r9),%r12d
  c6e7fd:	62 11 5d 40 62 f3    	vpunpckldq %zmm27,%zmm20,%zmm14
  c6e803:	62 11 1d 40 62 fd    	vpunpckldq %zmm29,%zmm28,%zmm15
  c6e809:	62 01 5d 40 6a db    	vpunpckhdq %zmm27,%zmm20,%zmm27
  c6e80f:	62 01 1d 40 6a ed    	vpunpckhdq %zmm29,%zmm28,%zmm29
  c6e815:	62 11 a5 40 6c d5    	vpunpcklqdq %zmm29,%zmm27,%zmm10
  c6e81b:	62 41 8d 48 6d f7    	vpunpckhqdq %zmm15,%zmm14,%zmm30
  c6e821:	62 d2 d5 48 83 ea    	vpmultishiftqb %zmm10,%zmm5,%zmm5
  c6e827:	62 d2 cd 48 83 f2    	vpmultishiftqb %zmm10,%zmm6,%zmm6
  c6e82d:	62 92 0d 40 27 c6    	vptestmd %zmm30,%zmm30,%k0
  c6e833:	62 41 fd 48 6f e2    	vmovdqa64 %zmm10,%zmm28
  c6e839:	41 c1 e3 06          	shl    $0x6,%r11d
  c6e83d:	c4 81 7d 6f 4c 13 40 	vmovdqa 0x40(%r11,%r10,1),%ymm1
  c6e844:	45 0f b7 59 90       	movzwl -0x70(%r9),%r11d
  c6e849:	41 c1 e7 06          	shl    $0x6,%r15d
  c6e84d:	41 c1 e6 06          	shl    $0x6,%r14d
  c6e851:	62 83 f5 48 3a 44 17 02 01 	vinserti64x4 $0x1,0x40(%r15,%r10,1),%zmm1,%zmm16
  c6e85a:	45 0f b7 79 b0       	movzwl -0x50(%r9),%r15d
  c6e85f:	c4 81 7d 6f 4c 16 60 	vmovdqa 0x60(%r14,%r10,1),%ymm1
  c6e866:	45 0f b7 71 a0       	movzwl -0x60(%r9),%r14d
  c6e86b:	41 c1 e4 06          	shl    $0x6,%r12d
  c6e86f:	62 03 f5 48 3a 44 14 03 01 	vinserti64x4 $0x1,0x60(%r12,%r10,1),%zmm1,%zmm24
  c6e878:	45 0f b7 61 c0       	movzwl -0x40(%r9),%r12d
  c6e87d:	62 32 a5 49 64 ee    	vpblendmq %zmm22,%zmm11,%zmm13{%k1}
  c6e883:	41 c1 e3 06          	shl    $0x6,%r11d
  c6e887:	c4 81 7d 6f 4c 13 40 	vmovdqa 0x40(%r11,%r10,1),%ymm1
  c6e88e:	45 0f b7 59 d0       	movzwl -0x30(%r9),%r11d
  c6e893:	41 c1 e7 06          	shl    $0x6,%r15d
  c6e897:	41 c1 e6 06          	shl    $0x6,%r14d
  c6e89b:	62 83 f5 48 3a 54 17 02 01 	vinserti64x4 $0x1,0x40(%r15,%r10,1),%zmm1,%zmm18
  c6e8a4:	45 0f b7 79 f0       	movzwl -0x10(%r9),%r15d
  c6e8a9:	c4 81 7d 6f 4c 16 60 	vmovdqa 0x60(%r14,%r10,1),%ymm1
  c6e8b0:	45 0f b7 71 e0       	movzwl -0x20(%r9),%r14d
  c6e8b5:	41 c1 e4 06          	shl    $0x6,%r12d
  c6e8b9:	62 03 f5 48 3a 4c 14 03 01 	vinserti64x4 $0x1,0x60(%r12,%r10,1),%zmm1,%zmm25
  c6e8c2:	45 0f b7 21          	movzwl (%r9),%r12d
  c6e8c6:	49 81 c1 00 01 00 00 	add    $0x100,%r9
  c6e8cd:	62 82 fd 41 64 c8    	vpblendmq %zmm24,%zmm16,%zmm17{%k1}
  c6e8d3:	41 c1 e3 06          	shl    $0x6,%r11d
  c6e8d7:	41 c1 e6 06          	shl    $0x6,%r14d
  c6e8db:	41 c1 e7 06          	shl    $0x6,%r15d
  c6e8df:	c4 81 7d 6f 4c 13 40 	vmovdqa 0x40(%r11,%r10,1),%ymm1
  c6e8e6:	62 83 f5 48 3a 6c 17 02 01 	vinserti64x4 $0x1,0x40(%r15,%r10,1),%zmm1,%zmm21
  c6e8ef:	41 c1 e4 06          	shl    $0x6,%r12d
  c6e8f3:	c4 81 7d 6f 4c 16 60 	vmovdqa 0x60(%r14,%r10,1),%ymm1
  c6e8fa:	62 03 f5 48 3a 54 14 03 01 	vinserti64x4 $0x1,0x60(%r12,%r10,1),%zmm1,%zmm26
  c6e903:	62 b1 15 48 6a c9    	vpunpckhdq %zmm17,%zmm13,%zmm1
  c6e909:	62 82 ed 41 64 d9    	vpblendmq %zmm25,%zmm18,%zmm19{%k1}
  c6e90f:	62 82 d5 41 64 fa    	vpblendmq %zmm26,%zmm21,%zmm23{%k1}
  c6e915:	62 b1 65 40 6a d7    	vpunpckhdq %zmm23,%zmm19,%zmm2
  c6e91b:	62 e1 f5 48 6d e2    	vpunpckhqdq %zmm2,%zmm1,%zmm20
  c6e921:	62 d1 75 48 72 d2 1a 	vpsrld $0x1a,%zmm10,%zmm1
  c6e928:	62 f2 75 48 36 3d 0e c3 7a ff 	vpermd -0x853cf2(%rip),%zmm1,%zmm7        # 41ac40 <parallel_test_signals_kept.signals+0x3d40>
  c6e932:	62 62 75 48 36 3d 44 c3 7a ff 	vpermd -0x853cbc(%rip),%zmm1,%zmm31        # 41ac80 <parallel_test_signals_kept.signals+0x3d80>
  c6e93c:	62 f2 75 48 36 25 7a c3 7a ff 	vpermd -0x853c86(%rip),%zmm1,%zmm4        # 41acc0 <parallel_test_signals_kept.signals+0x3dc0>
  c6e946:	62 d2 fd 48 83 ca    	vpmultishiftqb %zmm10,%zmm0,%zmm1
  c6e94c:	62 f2 7d 48 5a 05 4a 3f 8e ff 	vbroadcasti32x4 -0x71c0b6(%rip),%zmm0        # 5528a0 <x86_disassembly_listing.hex+0xdb0>
  c6e956:	62 f3 75 58 25 2d 43 a2 90 ff d8 	vpternlogd $0xd8,-0x6f5dbd(%rip){1to16},%zmm1,%zmm5        # 578ba4 <x86_break_instruction.legacy_forms+0x62c>
  c6e961:	62 d1 75 48 72 f2 04 	vpslld $0x4,%zmm10,%zmm1
  c6e968:	62 f1 6d 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm2
  c6e96f:	62 f3 55 58 25 35 2e a2 90 ff e4 	vpternlogd $0xe4,-0x6f5dd2(%rip){1to16},%zmm5,%zmm6        # 578ba8 <x86_break_instruction.legacy_forms+0x630>
  c6e97a:	62 d2 7d 48 00 ea    	vpshufb %zmm10,%zmm0,%zmm5
  c6e980:	62 91 7d 48 72 e6 1f 	vpsrad $0x1f,%zmm30,%zmm0
  c6e987:	62 f1 75 48 72 f5 10 	vpslld $0x10,%zmm5,%zmm1
  c6e98e:	62 f1 6d 48 db ed    	vpandd %zmm5,%zmm2,%zmm5
  c6e994:	62 f3 5d 58 25 2d 55 a2 90 ff ec 	vpternlogd $0xec,-0x6f5dab(%rip){1to16},%zmm4,%zmm5        # 578bf4 <x86_break_instruction.legacy_forms+0x67c>
  c6e99f:	62 f3 5d 50 25 2d 4e a2 90 ff f8 	vpternlogd $0xf8,-0x6f5db2(%rip){1to16},%zmm20,%zmm5        # 578bf8 <x86_break_instruction.legacy_forms+0x680>
  c6e9aa:	62 63 4d 48 25 ff f8 	vpternlogd $0xf8,%zmm7,%zmm6,%zmm31
  c6e9b1:	62 f1 45 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm7
  c6e9b8:	62 f2 7e 48 38 c8    	vpmovm2d %k0,%zmm1
  c6e9be:	62 f3 6d 48 25 cf c8 	vpternlogd $0xc8,%zmm7,%zmm2,%zmm1
  c6e9c5:	62 91 7d 48 ef fe    	vpxord %zmm30,%zmm0,%zmm7
  c6e9cb:	62 f2 7d 48 58 05 d7 a1 90 ff 	vpbroadcastd -0x6f5e29(%rip),%zmm0        # 578bac <x86_break_instruction.legacy_forms+0x634>
  c6e9d5:	62 f2 7d 48 44 ff    	vplzcntd %zmm7,%zmm7
  c6e9db:	62 f2 3d 48 45 ff    	vpsrlvd %zmm7,%zmm8,%zmm7
  c6e9e1:	62 51 0d 40 fe c4    	vpaddd %zmm12,%zmm30,%zmm8
  c6e9e7:	62 73 0d 40 25 c7 14 	vpternlogd $0x14,%zmm7,%zmm30,%zmm8
  c6e9ee:	62 d1 45 48 72 d2 08 	vpsrld $0x8,%zmm10,%zmm7
  c6e9f5:	62 63 7d 58 25 25 bc a1 90 ff 6c 	vpternlogd $0x6c,-0x6f5e44(%rip){1to16},%zmm0,%zmm28        # 578bbc <x86_break_instruction.legacy_forms+0x644>
  c6ea00:	62 f3 7d 58 25 3d b5 a1 90 ff 6c 	vpternlogd $0x6c,-0x6f5e4b(%rip){1to16},%zmm0,%zmm7        # 578bc0 <x86_break_instruction.legacy_forms+0x648>
  c6ea0b:	62 91 7d 48 72 ce 01 	vprold $0x1,%zmm30,%zmm0
  c6ea12:	62 41 1d 40 fe e4    	vpaddd %zmm12,%zmm28,%zmm28
  c6ea18:	62 63 35 58 25 25 a1 a1 90 ff ec 	vpternlogd $0xec,-0x6f5e5f(%rip){1to16},%zmm9,%zmm28        # 578bc4 <x86_break_instruction.legacy_forms+0x64c>
  c6ea23:	62 d1 45 48 fe fc    	vpaddd %zmm12,%zmm7,%zmm7
  c6ea29:	62 f3 1d 50 25 3d 98 a1 90 ff ec 	vpternlogd $0xec,-0x6f5e68(%rip){1to16},%zmm28,%zmm7        # 578bcc <x86_break_instruction.legacy_forms+0x654>
  c6ea34:	62 61 4d 58 db 25 92 a1 90 ff 	vpandd -0x6f5e6e(%rip){1to16},%zmm6,%zmm28        # 578bd0 <x86_break_instruction.legacy_forms+0x658>
  c6ea3e:	62 f1 4d 48 72 d6 03 	vpsrld $0x3,%zmm6,%zmm6
  c6ea45:	62 f3 5d 50 25 35 8c a1 90 ff a2 	vpternlogd $0xa2,-0x6f5e74(%rip){1to16},%zmm20,%zmm6        # 578bdc <x86_break_instruction.legacy_forms+0x664>
  c6ea50:	62 f2 4d 58 3b 25 86 a1 90 ff 	vpminud -0x6f5e7a(%rip){1to16},%zmm6,%zmm4        # 578be0 <x86_break_instruction.legacy_forms+0x668>
  c6ea5a:	62 63 5d 40 25 e7 f8 	vpternlogd $0xf8,%zmm7,%zmm20,%zmm28
  c6ea61:	62 62 1d 50 3b 25 69 a1 90 ff 	vpminud -0x6f5e97(%rip){1to16},%zmm28,%zmm28        # 578bd4 <x86_break_instruction.legacy_forms+0x65c>
  c6ea6b:	62 b1 45 48 72 d4 1d 	vpsrld $0x1d,%zmm20,%zmm7
  c6ea72:	62 72 3d 48 14 c7    	vprorvd %zmm7,%zmm8,%zmm8
  c6ea78:	62 f2 7d 48 14 ff    	vprorvd %zmm7,%zmm0,%zmm7
  c6ea7e:	62 f1 fd 48 6f 05 78 c1 7a ff 	vmovdqa64 -0x853e88(%rip),%zmm0        # 41ac00 <parallel_test_signals_kept.signals+0x3d00>
  c6ea88:	62 d1 3d 48 72 e0 1f 	vpsrad $0x1f,%zmm8,%zmm8
  c6ea8f:	62 93 75 48 25 fe e2 	vpternlogd $0xe2,%zmm30,%zmm1,%zmm7
  c6ea96:	62 93 3d 48 25 fe e2 	vpternlogd $0xe2,%zmm30,%zmm8,%zmm7
  c6ea9d:	62 93 5d 48 25 ec fe 	vpternlogd $0xfe,%zmm28,%zmm4,%zmm5
  c6eaa4:	62 91 fd 48 6f e7    	vmovdqa64 %zmm31,%zmm4
  c6eaaa:	62 01 fd 48 6f e7    	vmovdqa64 %zmm31,%zmm28
  c6eab0:	62 f3 6d 58 25 25 fd a0 90 ff f8 	vpternlogd $0xf8,-0x6f5f03(%rip){1to16},%zmm2,%zmm4        # 578bb8 <x86_break_instruction.legacy_forms+0x640>
  c6eabb:	62 63 75 58 25 25 ee a0 90 ff f8 	vpternlogd $0xf8,-0x6f5f12(%rip){1to16},%zmm1,%zmm28        # 578bb4 <x86_break_instruction.legacy_forms+0x63c>
  c6eac6:	62 f1 6d 58 db 15 30 a1 90 ff 	vpandd -0x6f5ed0(%rip){1to16},%zmm2,%zmm2        # 578c00 <x86_break_instruction.legacy_forms+0x688>
  c6ead0:	62 32 fd 48 7e de    	vpermt2q %zmm22,%zmm0,%zmm11
  c6ead6:	62 91 4d 40 72 d7 03 	vpsrld $0x3,%zmm31,%zmm22
  c6eadd:	62 82 fd 48 7e c0    	vpermt2q %zmm24,%zmm0,%zmm16
  c6eae3:	62 82 fd 48 7e d1    	vpermt2q %zmm25,%zmm0,%zmm18
  c6eae9:	62 82 fd 48 7e ea    	vpermt2q %zmm26,%zmm0,%zmm21
  c6eaef:	62 f2 7d 48 5a 05 b7 3d 8e ff 	vbroadcasti32x4 -0x71c249(%rip),%zmm0        # 5528b0 <x86_disassembly_listing.hex+0xdc0>
  c6eaf9:	62 93 3d 48 25 e4 b8 	vpternlogd $0xb8,%zmm28,%zmm8,%zmm4
  c6eb00:	62 61 75 58 db 25 f2 a0 90 ff 	vpandd -0x6f5f0e(%rip){1to16},%zmm1,%zmm28        # 578bfc <x86_break_instruction.legacy_forms+0x684>
  c6eb0a:	62 91 75 48 72 d7 10 	vpsrld $0x10,%zmm31,%zmm1
  c6eb11:	62 e3 75 58 25 35 bc a0 90 ff ec 	vpternlogd $0xec,-0x6f5f44(%rip){1to16},%zmm1,%zmm22        # 578bd8 <x86_break_instruction.legacy_forms+0x660>
  c6eb1c:	62 d1 4d 48 fe cc    	vpaddd %zmm12,%zmm6,%zmm1
  c6eb22:	62 f1 75 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm1
  c6eb29:	62 93 3d 48 25 d4 b8 	vpternlogd $0xb8,%zmm28,%zmm8,%zmm2
  c6eb30:	62 51 8d 48 6c c7    	vpunpcklqdq %zmm15,%zmm14,%zmm8
  c6eb36:	62 11 a5 40 6d f5    	vpunpckhqdq %zmm29,%zmm27,%zmm14
  c6eb3c:	62 b1 4d 48 72 f6 08 	vpslld $0x8,%zmm22,%zmm6
  c6eb43:	62 f3 75 58 25 35 96 a0 90 ff 08 	vpternlogd $0x8,-0x6f5f6a(%rip){1to16},%zmm1,%zmm6        # 578be4 <x86_break_instruction.legacy_forms+0x66c>
  c6eb4e:	62 51 0d 48 eb d2    	vpord  %zmm10,%zmm14,%zmm10
  c6eb54:	62 f1 6d 48 eb d5    	vpord  %zmm5,%zmm2,%zmm2
  c6eb5a:	62 f1 3d 48 62 ef    	vpunpckldq %zmm7,%zmm8,%zmm5
  c6eb60:	62 f1 3d 48 6a ff    	vpunpckhdq %zmm7,%zmm8,%zmm7
  c6eb66:	62 d1 2d 48 72 f2 07 	vpslld $0x7,%zmm10,%zmm10
  c6eb6d:	62 73 4d 58 25 15 70 a0 90 ff e4 	vpternlogd $0xe4,-0x6f5f90(%rip){1to16},%zmm6,%zmm10        # 578be8 <x86_break_instruction.legacy_forms+0x670>
  c6eb78:	62 d2 fd 48 83 f6    	vpmultishiftqb %zmm14,%zmm0,%zmm6
  c6eb7e:	62 f3 4d 50 25 35 63 a0 90 ff d8 	vpternlogd $0xd8,-0x6f5f9d(%rip){1to16},%zmm22,%zmm6        # 578bec <x86_break_instruction.legacy_forms+0x674>
  c6eb89:	62 f1 7d 48 70 c2 55 	vpshufd $0x55,%zmm2,%zmm0
  c6eb90:	62 b2 7d 48 8f d0    	vpshufbitqmb %zmm16,%zmm0,%k2
  c6eb96:	62 f1 7d 48 70 c2 aa 	vpshufd $0xaa,%zmm2,%zmm0
  c6eb9d:	c4 61 fb 93 f2       	kmovq  %k2,%r14
  c6eba2:	f3 4d 0f b8 f6       	popcnt %r14,%r14
  c6eba7:	62 f3 2d 58 25 35 3e a0 90 ff d8 	vpternlogd $0xd8,-0x6f5fc2(%rip){1to16},%zmm10,%zmm6        # 578bf0 <x86_break_instruction.legacy_forms+0x678>
  c6ebb2:	62 71 5d 48 62 c6    	vpunpckldq %zmm6,%zmm4,%zmm8
  c6ebb8:	62 f1 5d 48 6a e6    	vpunpckhdq %zmm6,%zmm4,%zmm4
  c6ebbe:	62 d1 d5 48 6c f0    	vpunpcklqdq %zmm8,%zmm5,%zmm6
  c6ebc4:	62 d1 d5 48 6d e8    	vpunpckhqdq %zmm8,%zmm5,%zmm5
  c6ebca:	62 71 c5 48 6c c4    	vpunpcklqdq %zmm4,%zmm7,%zmm8
  c6ebd0:	62 f1 c5 48 6d e4    	vpunpckhqdq %zmm4,%zmm7,%zmm4
  c6ebd6:	62 f1 7d 48 70 fa 00 	vpshufd $0x0,%zmm2,%zmm7
  c6ebdd:	62 d2 4d 48 00 f3    	vpshufb %zmm11,%zmm6,%zmm6
  c6ebe3:	62 d2 45 48 8f db    	vpshufbitqmb %zmm11,%zmm7,%k3
  c6ebe9:	62 b2 55 48 00 e8    	vpshufb %zmm16,%zmm5,%zmm5
  c6ebef:	62 b2 5d 48 00 e5    	vpshufb %zmm21,%zmm4,%zmm4
  c6ebf5:	62 f3 95 48 25 f3 78 	vpternlogq $0x78,%zmm3,%zmm13,%zmm6
  c6ebfc:	62 f3 f5 40 25 eb 78 	vpternlogq $0x78,%zmm3,%zmm17,%zmm5
  c6ec03:	62 f3 c5 40 25 e3 78 	vpternlogq $0x78,%zmm3,%zmm23,%zmm4
  c6ec0a:	62 f2 7d cb 63 f6    	vpcompressb %zmm6,%zmm6{%k3}{z}
  c6ec10:	62 f2 7d ca 63 ed    	vpcompressb %zmm5,%zmm5{%k2}{z}
  c6ec16:	c4 61 fb 93 db       	kmovq  %k3,%r11
  c6ec1b:	62 b2 7d 48 8f da    	vpshufbitqmb %zmm18,%zmm0,%k3
  c6ec21:	62 f1 7d 48 70 c2 ff 	vpshufd $0xff,%zmm2,%zmm0
  c6ec28:	62 f3 5d 50 25 15 d1 9f 90 ff 20 	vpternlogd $0x20,-0x6f602f(%rip){1to16},%zmm20,%zmm2        # 578c04 <x86_break_instruction.legacy_forms+0x68c>
  c6ec33:	62 b2 7d 48 8f d5    	vpshufbitqmb %zmm21,%zmm0,%k2
  c6ec39:	f3 4d 0f b8 db       	popcnt %r11,%r11
  c6ec3e:	c5 f9 6f 05 fa 3b 8e ff 	vmovdqa -0x71c406(%rip),%xmm0        # 552840 <x86_disassembly_listing.hex+0xd50>
  c6ec46:	62 f2 7d ca 63 e4    	vpcompressb %zmm4,%zmm4{%k2}{z}
  c6ec4c:	62 f1 fe 48 7f 32    	vmovdqu64 %zmm6,(%rdx)
  c6ec52:	62 b2 3d 48 00 f2    	vpshufb %zmm18,%zmm8,%zmm6
  c6ec58:	62 b1 fe 48 7f 2c 1a 	vmovdqu64 %zmm5,(%rdx,%r11,1)
  c6ec5f:	49 01 d3             	add    %rdx,%r11
  c6ec62:	29 da                	sub    %ebx,%edx
  c6ec64:	62 f3 e5 40 25 f3 78 	vpternlogq $0x78,%zmm3,%zmm19,%zmm6
  c6ec6b:	c5 d1 ef ed          	vpxor  %xmm5,%xmm5,%xmm5
  c6ec6f:	62 f2 7d cb 63 f5    	vpcompressb %zmm6,%zmm5{%k3}{z}
  c6ec75:	62 f2 7d 48 55 d2    	vpopcntd %zmm2,%zmm2
  c6ec7b:	62 91 fe 48 7f 2c 1e 	vmovdqu64 %zmm5,(%r14,%r11,1)
  c6ec82:	4d 01 f3             	add    %r14,%r11
  c6ec85:	c4 61 fb 93 f3       	kmovq  %k3,%r14
  c6ec8a:	f3 4d 0f b8 fe       	popcnt %r14,%r15
  c6ec8f:	62 91 fe 48 7f 24 1f 	vmovdqu64 %zmm4,(%r15,%r11,1)
  c6ec96:	62 f1 5d 50 db 25 68 9f 90 ff 	vpandd -0x6f6098(%rip){1to16},%zmm20,%zmm4        # 578c08 <x86_break_instruction.legacy_forms+0x690>
  c6eca0:	89 94 24 00 01 00 00 	mov    %edx,0x100(%rsp)
  c6eca7:	c4 e1 fb 93 d2       	kmovq  %k2,%rdx
  c6ecac:	f3 4c 0f b8 f2       	popcnt %rdx,%r14
  c6ecb1:	62 f2 7d 48 58 74 24 40 	vpbroadcastd 0x100(%rsp),%zmm6
  c6ecb9:	4d 01 fe             	add    %r15,%r14
  c6ecbc:	4c 8d 78 10          	lea    0x10(%rax),%r15
  c6ecc0:	4d 01 de             	add    %r11,%r14
  c6ecc3:	62 f1 75 48 fe cc    	vpaddd %zmm4,%zmm1,%zmm1
  c6ecc9:	62 f1 75 48 fe ca    	vpaddd %zmm2,%zmm1,%zmm1
  c6eccf:	62 f2 7d 48 8d c9    	vpermb %zmm1,%zmm0,%zmm1
  c6ecd5:	62 f2 f5 18 40 15 b1 97 90 ff 	vpmullq -0x6f684f(%rip){1to2},%xmm1,%xmm2        # 578490 <x86_effects_unknown+0x1a90>
  c6ecdf:	c5 f9 6f 05 79 3b 8e ff 	vmovdqa -0x71c487(%rip),%xmm0        # 552860 <x86_disassembly_listing.hex+0xd70>
  c6ece7:	c4 e2 69 00 25 60 3b 8e ff 	vpshufb -0x71c4a0(%rip),%xmm2,%xmm4        # 552850 <x86_disassembly_listing.hex+0xd60>
  c6ecf0:	62 d2 7d 48 8d ee    	vpermb %zmm14,%zmm0,%zmm5
  c6ecf6:	c5 d9 fc d2          	vpaddb %xmm2,%xmm4,%xmm2
  c6ecfa:	c5 e9 f8 c9          	vpsubb %xmm1,%xmm2,%xmm1
  c6ecfe:	62 f2 7d 48 31 c2    	vpmovzxbd %xmm2,%zmm0
  c6ed04:	62 f2 7d 48 31 c9    	vpmovzxbd %xmm1,%zmm1
  c6ed0a:	62 f2 7e 48 29 dd    	vpmovb2m %zmm5,%k3
  c6ed10:	c5 fb 93 d3          	kmovd  %k3,%edx
  c6ed14:	0f b7 d2             	movzwl %dx,%edx
  c6ed17:	f3 0f b8 d2          	popcnt %edx,%edx
  c6ed1b:	62 f1 4d 48 fe c9    	vpaddd %zmm1,%zmm6,%zmm1
  c6ed21:	62 f1 fe 48 7f 0c 81 	vmovdqu64 %zmm1,(%rcx,%rax,4)
  c6ed28:	62 f1 4d 48 fe c8    	vpaddd %zmm0,%zmm6,%zmm1
  c6ed2e:	48 83 c0 20          	add    $0x20,%rax
  c6ed32:	62 f2 7d cb 8b c9    	vpcompressd %zmm1,%zmm1{%k3}{z}
  c6ed38:	62 d1 fe 48 7f 08    	vmovdqu64 %zmm1,(%r8)
  c6ed3e:	4d 8d 04 90          	lea    (%r8,%rdx,4),%r8
  c6ed42:	4c 89 f2             	mov    %r14,%rdx
  c6ed45:	48 39 f0             	cmp    %rsi,%rax
  c6ed48:	4c 89 f8             	mov    %r15,%rax
  c6ed4b:	0f 86 ef f9 ff ff    	jbe    c6e740 <x86_encode_64+0xa0>
  c6ed51:	4c 29 fe             	sub    %r15,%rsi
  c6ed54:	0f 87 21 14 00 00    	ja     c7017b <x86_encode_64+0x1adb>
  c6ed5a:	e9 b9 48 00 00       	jmp    c73618 <x86_encode_64+0x4f78>
  c6ed5f:	48 85 c9             	test   %rcx,%rcx
  c6ed62:	0f 84 e1 1a 00 00    	je     c70849 <x86_encode_64+0x21a9>
  c6ed68:	48 83 fe 40          	cmp    $0x40,%rsi
  c6ed6c:	0f 83 a0 20 00 00    	jae    c70e12 <x86_encode_64+0x2772>
  c6ed72:	31 c0                	xor    %eax,%eax
  c6ed74:	48 89 da             	mov    %rbx,%rdx
  c6ed77:	4c 8d 40 10          	lea    0x10(%rax),%r8
  c6ed7b:	49 39 f0             	cmp    %rsi,%r8
  c6ed7e:	0f 87 87 27 00 00    	ja     c7150b <x86_encode_64+0x2e6b>
  c6ed84:	62 f2 7d 48 5a 1d a2 3a 8e ff 	vbroadcasti32x4 -0x71c55e(%rip),%zmm3        # 552830 <x86_disassembly_listing.hex+0xd40>
  c6ed8e:	49 89 c0             	mov    %rax,%r8
  c6ed91:	49 c1 e0 04          	shl    $0x4,%r8
  c6ed95:	41 b2 cc             	mov    $0xcc,%r10b
  c6ed98:	4c 8d 0d e1 35 13 02 	lea    0x21335e1(%rip),%r9        # 2da2380 <x86_template_storage>
  c6ed9f:	62 53 1d 48 25 e4 ff 	vpternlogd $0xff,%zmm12,%zmm12,%zmm12
  c6eda6:	4d 8d 84 38 fc 00 00 00 	lea    0xfc(%r8,%rdi,1),%r8
  c6edae:	c4 c1 7b 92 ca       	kmovd  %r10d,%k1
  c6edb3:	66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  c6edc0:	45 0f b7 90 10 ff ff ff 	movzwl -0xf0(%r8),%r10d
  c6edc8:	45 0f b7 98 20 ff ff ff 	movzwl -0xe0(%r8),%r11d
  c6edd0:	45 0f b7 b0 30 ff ff ff 	movzwl -0xd0(%r8),%r14d
  c6edd8:	45 0f b7 b8 40 ff ff ff 	movzwl -0xc0(%r8),%r15d
  c6ede0:	62 c1 fe 48 6f 98 04 ff ff ff 	vmovdqu64 -0xfc(%r8),%zmm19
  c6edea:	62 41 fe 48 6f 90 44 ff ff ff 	vmovdqu64 -0xbc(%r8),%zmm26
  c6edf4:	62 41 fe 48 6f 98 84 ff ff ff 	vmovdqu64 -0x7c(%r8),%zmm27
  c6edfe:	62 41 fe 48 6f a0 c4 ff ff ff 	vmovdqu64 -0x3c(%r8),%zmm28
  c6ee08:	62 f2 7d 48 5a 2d 5e 3a 8e ff 	vbroadcasti32x4 -0x71c5a2(%rip),%zmm5        # 552870 <x86_disassembly_listing.hex+0xd80>
  c6ee12:	62 f2 7d 48 5a 35 84 3a 8e ff 	vbroadcasti32x4 -0x71c57c(%rip),%zmm6        # 5528a0 <x86_disassembly_listing.hex+0xdb0>
  c6ee1c:	62 72 7d 48 58 0d 86 9d 90 ff 	vpbroadcastd -0x6f627a(%rip),%zmm9        # 578bac <x86_break_instruction.legacy_forms+0x634>
  c6ee26:	41 c1 e2 06          	shl    $0x6,%r10d
  c6ee2a:	41 c1 e3 06          	shl    $0x6,%r11d
  c6ee2e:	41 c1 e6 06          	shl    $0x6,%r14d
  c6ee32:	41 c1 e7 06          	shl    $0x6,%r15d
  c6ee36:	c4 81 7d 6f 4c 0a 40 	vmovdqa 0x40(%r10,%r9,1),%ymm1
  c6ee3d:	45 0f b7 90 50 ff ff ff 	movzwl -0xb0(%r8),%r10d
  c6ee45:	62 13 f5 48 3a 54 0e 02 01 	vinserti64x4 $0x1,0x40(%r14,%r9,1),%zmm1,%zmm10
  c6ee4e:	45 0f b7 b0 70 ff ff ff 	movzwl -0x90(%r8),%r14d
  c6ee56:	c4 81 7d 6f 4c 0b 60 	vmovdqa 0x60(%r11,%r9,1),%ymm1
  c6ee5d:	45 0f b7 98 60 ff ff ff 	movzwl -0xa0(%r8),%r11d
  c6ee65:	62 83 f5 48 3a 6c 0f 03 01 	vinserti64x4 $0x1,0x60(%r15,%r9,1),%zmm1,%zmm21
  c6ee6e:	45 0f b7 78 80       	movzwl -0x80(%r8),%r15d
  c6ee73:	62 11 65 40 62 ea    	vpunpckldq %zmm26,%zmm19,%zmm13
  c6ee79:	62 11 25 40 62 f4    	vpunpckldq %zmm28,%zmm27,%zmm14
  c6ee7f:	62 01 65 40 6a d2    	vpunpckhdq %zmm26,%zmm19,%zmm26
  c6ee85:	62 01 25 40 6a e4    	vpunpckhdq %zmm28,%zmm27,%zmm28
  c6ee8b:	62 11 ad 40 6c c4    	vpunpcklqdq %zmm28,%zmm26,%zmm8
  c6ee91:	62 41 95 48 6d ee    	vpunpckhqdq %zmm14,%zmm13,%zmm29
  c6ee97:	62 d1 7d 48 72 d0 1a 	vpsrld $0x1a,%zmm8,%zmm0
  c6ee9e:	62 f2 7d 48 36 25 98 bd 7a ff 	vpermd -0x854268(%rip),%zmm0,%zmm4        # 41ac40 <parallel_test_signals_kept.signals+0x3d40>
  c6eea8:	62 62 7d 48 36 35 ce bd 7a ff 	vpermd -0x854232(%rip),%zmm0,%zmm30        # 41ac80 <parallel_test_signals_kept.signals+0x3d80>
  c6eeb2:	62 92 15 40 27 c5    	vptestmd %zmm29,%zmm29,%k0
  c6eeb8:	62 91 45 48 72 e5 1f 	vpsrad $0x1f,%zmm29,%zmm7
  c6eebf:	62 41 fd 48 6f d8    	vmovdqa64 %zmm8,%zmm27
  c6eec5:	62 63 35 58 25 1d ec 9c 90 ff 6c 	vpternlogd $0x6c,-0x6f6314(%rip){1to16},%zmm9,%zmm27        # 578bbc <x86_break_instruction.legacy_forms+0x644>
  c6eed0:	41 c1 e2 06          	shl    $0x6,%r10d
  c6eed4:	c4 81 7d 6f 4c 0a 40 	vmovdqa 0x40(%r10,%r9,1),%ymm1
  c6eedb:	45 0f b7 50 90       	movzwl -0x70(%r8),%r10d
  c6eee0:	41 c1 e6 06          	shl    $0x6,%r14d
  c6eee4:	41 c1 e3 06          	shl    $0x6,%r11d
  c6eee8:	62 13 f5 48 3a 7c 0e 02 01 	vinserti64x4 $0x1,0x40(%r14,%r9,1),%zmm1,%zmm15
  c6eef1:	45 0f b7 70 b0       	movzwl -0x50(%r8),%r14d
  c6eef6:	c4 81 7d 6f 4c 0b 60 	vmovdqa 0x60(%r11,%r9,1),%ymm1
  c6eefd:	45 0f b7 58 a0       	movzwl -0x60(%r8),%r11d
  c6ef02:	41 c1 e7 06          	shl    $0x6,%r15d
  c6ef06:	62 83 f5 48 3a 7c 0f 03 01 	vinserti64x4 $0x1,0x60(%r15,%r9,1),%zmm1,%zmm23
  c6ef0f:	45 0f b7 78 c0       	movzwl -0x40(%r8),%r15d
  c6ef14:	62 32 ad 49 64 dd    	vpblendmq %zmm21,%zmm10,%zmm11{%k1}
  c6ef1a:	41 c1 e2 06          	shl    $0x6,%r10d
  c6ef1e:	c4 81 7d 6f 4c 0a 40 	vmovdqa 0x40(%r10,%r9,1),%ymm1
  c6ef25:	45 0f b7 50 d0       	movzwl -0x30(%r8),%r10d
  c6ef2a:	41 c1 e6 06          	shl    $0x6,%r14d
  c6ef2e:	41 c1 e3 06          	shl    $0x6,%r11d
  c6ef32:	62 41 25 40 fe dc    	vpaddd %zmm12,%zmm27,%zmm27
  c6ef38:	62 83 f5 48 3a 4c 0e 02 01 	vinserti64x4 $0x1,0x40(%r14,%r9,1),%zmm1,%zmm17
  c6ef41:	45 0f b7 70 f0       	movzwl -0x10(%r8),%r14d
  c6ef46:	c4 81 7d 6f 4c 0b 60 	vmovdqa 0x60(%r11,%r9,1),%ymm1
  c6ef4d:	45 0f b7 58 e0       	movzwl -0x20(%r8),%r11d
  c6ef52:	41 c1 e7 06          	shl    $0x6,%r15d
  c6ef56:	62 03 f5 48 3a 44 0f 03 01 	vinserti64x4 $0x1,0x60(%r15,%r9,1),%zmm1,%zmm24
  c6ef5f:	45 0f b7 38          	movzwl (%r8),%r15d
  c6ef63:	49 81 c0 00 01 00 00 	add    $0x100,%r8
  c6ef6a:	62 a2 85 49 64 c7    	vpblendmq %zmm23,%zmm15,%zmm16{%k1}
  c6ef70:	41 c1 e2 06          	shl    $0x6,%r10d
  c6ef74:	41 c1 e3 06          	shl    $0x6,%r11d
  c6ef78:	41 c1 e6 06          	shl    $0x6,%r14d
  c6ef7c:	c4 81 7d 6f 4c 0a 40 	vmovdqa 0x40(%r10,%r9,1),%ymm1
  c6ef83:	62 83 f5 48 3a 64 0e 02 01 	vinserti64x4 $0x1,0x40(%r14,%r9,1),%zmm1,%zmm20
  c6ef8c:	41 c1 e7 06          	shl    $0x6,%r15d
  c6ef90:	c4 81 7d 6f 4c 0b 60 	vmovdqa 0x60(%r11,%r9,1),%ymm1
  c6ef97:	62 03 f5 48 3a 4c 0f 03 01 	vinserti64x4 $0x1,0x60(%r15,%r9,1),%zmm1,%zmm25
  c6efa0:	62 b1 25 48 6a c8    	vpunpckhdq %zmm16,%zmm11,%zmm1
  c6efa6:	4c 8d 78 10          	lea    0x10(%rax),%r15
  c6efaa:	62 82 f5 41 64 d0    	vpblendmq %zmm24,%zmm17,%zmm18{%k1}
  c6efb0:	62 82 dd 41 64 f1    	vpblendmq %zmm25,%zmm20,%zmm22{%k1}
  c6efb6:	62 b1 6d 40 6a d6    	vpunpckhdq %zmm22,%zmm18,%zmm2
  c6efbc:	62 e1 f5 48 6d da    	vpunpckhqdq %zmm2,%zmm1,%zmm19
  c6efc2:	62 d2 d5 48 83 c8    	vpmultishiftqb %zmm8,%zmm5,%zmm1
  c6efc8:	62 f2 7d 48 5a 2d ae 38 8e ff 	vbroadcasti32x4 -0x71c752(%rip),%zmm5        # 552880 <x86_disassembly_listing.hex+0xd90>
  c6efd2:	62 f2 7d 48 36 15 e4 bc 7a ff 	vpermd -0x85431c(%rip),%zmm0,%zmm2        # 41acc0 <parallel_test_signals_kept.signals+0x3dc0>
  c6efdc:	62 f2 7d 48 5a 05 aa 38 8e ff 	vbroadcasti32x4 -0x71c756(%rip),%zmm0        # 552890 <x86_disassembly_listing.hex+0xda0>
  c6efe6:	62 42 d5 48 83 f8    	vpmultishiftqb %zmm8,%zmm5,%zmm31
  c6efec:	62 63 75 58 25 3d ad 9b 90 ff d8 	vpternlogd $0xd8,-0x6f6453(%rip){1to16},%zmm1,%zmm31        # 578ba4 <x86_break_instruction.legacy_forms+0x62c>
  c6eff7:	62 d2 fd 48 83 e8    	vpmultishiftqb %zmm8,%zmm0,%zmm5
  c6effd:	62 d1 75 48 72 f0 04 	vpslld $0x4,%zmm8,%zmm1
  c6f004:	62 f2 7d 48 58 05 ba 9b 90 ff 	vpbroadcastd -0x6f6446(%rip),%zmm0        # 578bc8 <x86_break_instruction.legacy_forms+0x650>
  c6f00e:	62 f1 75 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm1
  c6f015:	62 f3 05 50 25 2d 88 9b 90 ff e4 	vpternlogd $0xe4,-0x6f6478(%rip){1to16},%zmm31,%zmm5        # 578ba8 <x86_break_instruction.legacy_forms+0x630>
  c6f020:	62 63 7d 58 25 1d 99 9b 90 ff ec 	vpternlogd $0xec,-0x6f6467(%rip){1to16},%zmm0,%zmm27        # 578bc4 <x86_break_instruction.legacy_forms+0x64c>
  c6f02b:	62 f1 55 58 db 05 9b 9b 90 ff 	vpandd -0x6f6465(%rip){1to16},%zmm5,%zmm0        # 578bd0 <x86_break_instruction.legacy_forms+0x658>
  c6f035:	62 63 55 48 25 f4 f8 	vpternlogd $0xf8,%zmm4,%zmm5,%zmm30
  c6f03c:	62 d2 4d 48 00 e0    	vpshufb %zmm8,%zmm6,%zmm4
  c6f042:	62 f1 55 48 72 d5 03 	vpsrld $0x3,%zmm5,%zmm5
  c6f049:	62 f3 65 50 25 2d 88 9b 90 ff a2 	vpternlogd $0xa2,-0x6f6478(%rip){1to16},%zmm19,%zmm5        # 578bdc <x86_break_instruction.legacy_forms+0x664>
  c6f054:	62 f1 05 40 72 f4 10 	vpslld $0x10,%zmm4,%zmm31
  c6f05b:	62 f1 75 48 db e4    	vpandd %zmm4,%zmm1,%zmm4
  c6f061:	62 f3 6d 58 25 25 88 9b 90 ff ec 	vpternlogd $0xec,-0x6f6478(%rip){1to16},%zmm2,%zmm4        # 578bf4 <x86_break_instruction.legacy_forms+0x67c>
  c6f06c:	62 f2 55 58 3b 15 6a 9b 90 ff 	vpminud -0x6f6496(%rip){1to16},%zmm5,%zmm2        # 578be0 <x86_break_instruction.legacy_forms+0x668>
  c6f076:	62 91 4d 48 72 e7 1f 	vpsrad $0x1f,%zmm31,%zmm6
  c6f07d:	62 62 7e 48 38 f8    	vpmovm2d %k0,%zmm31
  c6f083:	62 f3 65 50 25 25 6a 9b 90 ff f8 	vpternlogd $0xf8,-0x6f6496(%rip){1to16},%zmm19,%zmm4        # 578bf8 <x86_break_instruction.legacy_forms+0x680>
  c6f08e:	62 63 75 48 25 fe c8 	vpternlogd $0xc8,%zmm6,%zmm1,%zmm31
  c6f095:	62 91 45 48 ef f5    	vpxord %zmm29,%zmm7,%zmm6
  c6f09b:	62 f2 7d 48 58 3d 0b 9b 90 ff 	vpbroadcastd -0x6f64f5(%rip),%zmm7        # 578bb0 <x86_break_instruction.legacy_forms+0x638>
  c6f0a5:	62 f2 7d 48 44 f6    	vplzcntd %zmm6,%zmm6
  c6f0ab:	62 f2 45 48 45 f6    	vpsrlvd %zmm6,%zmm7,%zmm6
  c6f0b1:	62 d1 15 40 fe fc    	vpaddd %zmm12,%zmm29,%zmm7
  c6f0b7:	62 f3 15 40 25 fe 14 	vpternlogd $0x14,%zmm6,%zmm29,%zmm7
  c6f0be:	62 d1 4d 48 72 d0 08 	vpsrld $0x8,%zmm8,%zmm6
  c6f0c5:	62 f3 35 58 25 35 f0 9a 90 ff 6c 	vpternlogd $0x6c,-0x6f6510(%rip){1to16},%zmm9,%zmm6        # 578bc0 <x86_break_instruction.legacy_forms+0x648>
  c6f0d0:	62 71 75 58 db 0d 26 9b 90 ff 	vpandd -0x6f64da(%rip){1to16},%zmm1,%zmm9        # 578c00 <x86_break_instruction.legacy_forms+0x688>
  c6f0da:	62 d1 4d 48 fe f4    	vpaddd %zmm12,%zmm6,%zmm6
  c6f0e0:	62 f3 25 50 25 35 e1 9a 90 ff ec 	vpternlogd $0xec,-0x6f651f(%rip){1to16},%zmm27,%zmm6        # 578bcc <x86_break_instruction.legacy_forms+0x654>
  c6f0eb:	62 f3 65 40 25 c6 f8 	vpternlogd $0xf8,%zmm6,%zmm19,%zmm0
  c6f0f2:	62 62 7d 58 3b 1d d8 9a 90 ff 	vpminud -0x6f6528(%rip){1to16},%zmm0,%zmm27        # 578bd4 <x86_break_instruction.legacy_forms+0x65c>
  c6f0fc:	62 f1 05 50 db 05 f6 9a 90 ff 	vpandd -0x6f650a(%rip){1to16},%zmm31,%zmm0        # 578bfc <x86_break_instruction.legacy_forms+0x684>
  c6f106:	62 b1 4d 48 72 d3 1d 	vpsrld $0x1d,%zmm19,%zmm6
  c6f10d:	62 f2 45 48 14 fe    	vprorvd %zmm6,%zmm7,%zmm7
  c6f113:	62 f1 45 48 72 e7 1f 	vpsrad $0x1f,%zmm7,%zmm7
  c6f11a:	62 93 6d 48 25 e3 fe 	vpternlogd $0xfe,%zmm27,%zmm2,%zmm4
  c6f121:	62 01 fd 48 6f de    	vmovdqa64 %zmm30,%zmm27
  c6f127:	62 91 fd 48 6f d6    	vmovdqa64 %zmm30,%zmm2
  c6f12d:	62 63 75 58 25 1d 80 9a 90 ff f8 	vpternlogd $0xf8,-0x6f6580(%rip){1to16},%zmm1,%zmm27        # 578bb8 <x86_break_instruction.legacy_forms+0x640>
  c6f138:	62 f3 05 50 25 15 71 9a 90 ff f8 	vpternlogd $0xf8,-0x6f658f(%rip){1to16},%zmm31,%zmm2        # 578bb4 <x86_break_instruction.legacy_forms+0x63c>
  c6f143:	62 91 75 48 72 cd 01 	vprold $0x1,%zmm29,%zmm1
  c6f14a:	62 73 45 48 25 c8 b8 	vpternlogd $0xb8,%zmm0,%zmm7,%zmm9
  c6f151:	62 f1 fd 48 6f 05 a5 ba 7a ff 	vmovdqa64 -0x85455b(%rip),%zmm0        # 41ac00 <parallel_test_signals_kept.signals+0x3d00>
  c6f15b:	62 f2 75 48 14 f6    	vprorvd %zmm6,%zmm1,%zmm6
  c6f161:	62 91 75 48 72 d6 10 	vpsrld $0x10,%zmm30,%zmm1
  c6f168:	62 93 05 40 25 f5 e2 	vpternlogd $0xe2,%zmm29,%zmm31,%zmm6
  c6f16f:	62 93 45 48 25 f5 e2 	vpternlogd $0xe2,%zmm29,%zmm7,%zmm6
  c6f176:	62 63 45 48 25 da b8 	vpternlogd $0xb8,%zmm2,%zmm7,%zmm27
  c6f17d:	62 d1 95 48 6c fe    	vpunpcklqdq %zmm14,%zmm13,%zmm7
  c6f183:	62 91 0d 48 72 d6 03 	vpsrld $0x3,%zmm30,%zmm14
  c6f18a:	62 73 75 58 25 35 43 9a 90 ff ec 	vpternlogd $0xec,-0x6f65bd(%rip){1to16},%zmm1,%zmm14        # 578bd8 <x86_break_instruction.legacy_forms+0x660>
  c6f195:	62 d1 55 48 fe cc    	vpaddd %zmm12,%zmm5,%zmm1
  c6f19b:	62 91 ad 40 6d d4    	vpunpckhqdq %zmm28,%zmm26,%zmm2
  c6f1a1:	62 32 fd 48 7e d5    	vpermt2q %zmm21,%zmm0,%zmm10
  c6f1a7:	62 32 fd 48 7e ff    	vpermt2q %zmm23,%zmm0,%zmm15
  c6f1ad:	62 82 fd 48 7e c8    	vpermt2q %zmm24,%zmm0,%zmm17
  c6f1b3:	62 82 fd 48 7e e1    	vpermt2q %zmm25,%zmm0,%zmm20
  c6f1b9:	62 f2 7d 48 5a 05 ed 36 8e ff 	vbroadcasti32x4 -0x71c913(%rip),%zmm0        # 5528b0 <x86_disassembly_listing.hex+0xdc0>
  c6f1c3:	62 f1 75 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm1
  c6f1ca:	62 51 6d 48 eb c0    	vpord  %zmm8,%zmm2,%zmm8
  c6f1d0:	62 d1 3d 48 72 f0 07 	vpslld $0x7,%zmm8,%zmm8
  c6f1d7:	62 d1 55 48 72 f6 08 	vpslld $0x8,%zmm14,%zmm5
  c6f1de:	62 f3 75 58 25 2d fb 99 90 ff 08 	vpternlogd $0x8,-0x6f6605(%rip){1to16},%zmm1,%zmm5        # 578be4 <x86_break_instruction.legacy_forms+0x66c>
  c6f1e9:	62 73 55 58 25 05 f4 99 90 ff e4 	vpternlogd $0xe4,-0x6f660c(%rip){1to16},%zmm5,%zmm8        # 578be8 <x86_break_instruction.legacy_forms+0x670>
  c6f1f4:	62 f2 fd 48 83 ea    	vpmultishiftqb %zmm2,%zmm0,%zmm5
  c6f1fa:	62 f3 0d 58 25 2d e7 99 90 ff d8 	vpternlogd $0xd8,-0x6f6619(%rip){1to16},%zmm14,%zmm5        # 578bec <x86_break_instruction.legacy_forms+0x674>
  c6f205:	62 f1 35 48 eb d4    	vpord  %zmm4,%zmm9,%zmm2
  c6f20b:	62 f1 45 48 62 e6    	vpunpckldq %zmm6,%zmm7,%zmm4
  c6f211:	62 f1 45 48 6a f6    	vpunpckhdq %zmm6,%zmm7,%zmm6
  c6f217:	62 f1 7d 48 70 c2 00 	vpshufd $0x0,%zmm2,%zmm0
  c6f21e:	62 d2 7d 48 8f da    	vpshufbitqmb %zmm10,%zmm0,%k3
  c6f224:	62 f1 7d 48 70 c2 55 	vpshufd $0x55,%zmm2,%zmm0
  c6f22b:	62 d2 7d 48 8f d7    	vpshufbitqmb %zmm15,%zmm0,%k2
  c6f231:	62 f1 7d 48 70 c2 aa 	vpshufd $0xaa,%zmm2,%zmm0
  c6f238:	c4 61 fb 93 d3       	kmovq  %k3,%r10
  c6f23d:	c4 61 fb 93 da       	kmovq  %k2,%r11
  c6f242:	f3 4d 0f b8 d2       	popcnt %r10,%r10
  c6f247:	f3 4d 0f b8 db       	popcnt %r11,%r11
  c6f24c:	62 f3 3d 58 25 2d 99 99 90 ff d8 	vpternlogd $0xd8,-0x6f6667(%rip){1to16},%zmm8,%zmm5        # 578bf0 <x86_break_instruction.legacy_forms+0x678>
  c6f257:	62 f1 25 40 62 fd    	vpunpckldq %zmm5,%zmm27,%zmm7
  c6f25d:	62 f1 25 40 6a ed    	vpunpckhdq %zmm5,%zmm27,%zmm5
  c6f263:	62 71 dd 48 6c c7    	vpunpcklqdq %zmm7,%zmm4,%zmm8
  c6f269:	62 f1 dd 48 6d e7    	vpunpckhqdq %zmm7,%zmm4,%zmm4
  c6f26f:	62 71 cd 48 6c cd    	vpunpcklqdq %zmm5,%zmm6,%zmm9
  c6f275:	62 f1 cd 48 6d ed    	vpunpckhqdq %zmm5,%zmm6,%zmm5
  c6f27b:	62 52 3d 48 00 c2    	vpshufb %zmm10,%zmm8,%zmm8
  c6f281:	62 d2 5d 48 00 e7    	vpshufb %zmm15,%zmm4,%zmm4
  c6f287:	62 b2 55 48 00 ec    	vpshufb %zmm20,%zmm5,%zmm5
  c6f28d:	62 73 a5 48 25 c3 78 	vpternlogq $0x78,%zmm3,%zmm11,%zmm8
  c6f294:	62 f3 fd 40 25 e3 78 	vpternlogq $0x78,%zmm3,%zmm16,%zmm4
  c6f29b:	62 f3 cd 40 25 eb 78 	vpternlogq $0x78,%zmm3,%zmm22,%zmm5
  c6f2a2:	c5 c9 ef f6          	vpxor  %xmm6,%xmm6,%xmm6
  c6f2a6:	62 72 7d cb 63 c6    	vpcompressb %zmm8,%zmm6{%k3}{z}
  c6f2ac:	62 b2 7d 48 8f d9    	vpshufbitqmb %zmm17,%zmm0,%k3
  c6f2b2:	62 f1 7d 48 70 c2 ff 	vpshufd $0xff,%zmm2,%zmm0
  c6f2b9:	62 f2 7d ca 63 e4    	vpcompressb %zmm4,%zmm4{%k2}{z}
  c6f2bf:	62 f3 65 50 25 15 3a 99 90 ff 20 	vpternlogd $0x20,-0x6f66c6(%rip){1to16},%zmm19,%zmm2        # 578c04 <x86_break_instruction.legacy_forms+0x68c>
  c6f2ca:	62 b2 7d 48 8f d4    	vpshufbitqmb %zmm20,%zmm0,%k2
  c6f2d0:	62 f1 65 50 db 05 2e 99 90 ff 	vpandd -0x6f66d2(%rip){1to16},%zmm19,%zmm0        # 578c08 <x86_break_instruction.legacy_forms+0x690>
  c6f2da:	c4 61 fb 93 f3       	kmovq  %k3,%r14
  c6f2df:	62 f1 fe 48 7f 32    	vmovdqu64 %zmm6,(%rdx)
  c6f2e5:	62 b2 35 48 00 f1    	vpshufb %zmm17,%zmm9,%zmm6
  c6f2eb:	62 b1 fe 48 7f 24 12 	vmovdqu64 %zmm4,(%rdx,%r10,1)
  c6f2f2:	49 01 d2             	add    %rdx,%r10
  c6f2f5:	29 da                	sub    %ebx,%edx
  c6f2f7:	62 f3 ed 40 25 f3 78 	vpternlogq $0x78,%zmm3,%zmm18,%zmm6
  c6f2fe:	62 f2 7d 48 55 d2    	vpopcntd %zmm2,%zmm2
  c6f304:	c5 d9 ef e4          	vpxor  %xmm4,%xmm4,%xmm4
  c6f308:	62 f2 7d cb 63 f4    	vpcompressb %zmm6,%zmm4{%k3}{z}
  c6f30e:	62 f1 75 48 fe c8    	vpaddd %zmm0,%zmm1,%zmm1
  c6f314:	c5 f9 6f 05 24 35 8e ff 	vmovdqa -0x71cadc(%rip),%xmm0        # 552840 <x86_disassembly_listing.hex+0xd50>
  c6f31c:	62 f1 75 48 fe ca    	vpaddd %zmm2,%zmm1,%zmm1
  c6f322:	62 91 fe 48 7f 24 13 	vmovdqu64 %zmm4,(%r11,%r10,1)
  c6f329:	c5 d9 ef e4          	vpxor  %xmm4,%xmm4,%xmm4
  c6f32d:	62 f2 7d ca 63 ec    	vpcompressb %zmm5,%zmm4{%k2}{z}
  c6f333:	4d 01 da             	add    %r11,%r10
  c6f336:	f3 4d 0f b8 de       	popcnt %r14,%r11
  c6f33b:	62 f2 7d 48 8d c9    	vpermb %zmm1,%zmm0,%zmm1
  c6f341:	62 f2 f5 18 40 15 45 91 90 ff 	vpmullq -0x6f6ebb(%rip){1to2},%xmm1,%xmm2        # 578490 <x86_effects_unknown+0x1a90>
  c6f34b:	62 91 fe 48 7f 24 13 	vmovdqu64 %zmm4,(%r11,%r10,1)
  c6f352:	89 94 24 00 01 00 00 	mov    %edx,0x100(%rsp)
  c6f359:	c4 e1 fb 93 d2       	kmovq  %k2,%rdx
  c6f35e:	f3 4c 0f b8 f2       	popcnt %rdx,%r14
  c6f363:	4d 01 de             	add    %r11,%r14
  c6f366:	4d 01 d6             	add    %r10,%r14
  c6f369:	4c 89 f2             	mov    %r14,%rdx
  c6f36c:	c5 e9 f8 c9          	vpsubb %xmm1,%xmm2,%xmm1
  c6f370:	c4 e2 69 00 15 d7 34 8e ff 	vpshufb -0x71cb29(%rip),%xmm2,%xmm2        # 552850 <x86_disassembly_listing.hex+0xd60>
  c6f379:	c5 f1 fc ca          	vpaddb %xmm2,%xmm1,%xmm1
  c6f37d:	62 f2 7d 48 31 c9    	vpmovzxbd %xmm1,%zmm1
  c6f383:	62 f1 75 58 fe 4c 24 40 	vpaddd 0x100(%rsp){1to16},%zmm1,%zmm1
  c6f38b:	62 f1 fe 48 7f 0c 81 	vmovdqu64 %zmm1,(%rcx,%rax,4)
  c6f392:	48 83 c0 20          	add    $0x20,%rax
  c6f396:	48 39 f0             	cmp    %rsi,%rax
  c6f399:	4c 89 f8             	mov    %r15,%rax
  c6f39c:	0f 86 1e fa ff ff    	jbe    c6edc0 <x86_encode_64+0x720>
  c6f3a2:	4c 29 fe             	sub    %r15,%rsi
  c6f3a5:	0f 87 6f 21 00 00    	ja     c7151a <x86_encode_64+0x2e7a>
  c6f3ab:	e9 68 42 00 00       	jmp    c73618 <x86_encode_64+0x4f78>
  c6f3b0:	48 83 fe 40          	cmp    $0x40,%rsi
  c6f3b4:	0f 83 f9 27 00 00    	jae    c71bb3 <x86_encode_64+0x3513>
  c6f3ba:	31 c0                	xor    %eax,%eax
  c6f3bc:	48 89 d9             	mov    %rbx,%rcx
  c6f3bf:	48 8d 50 10          	lea    0x10(%rax),%rdx
  c6f3c3:	48 39 f2             	cmp    %rsi,%rdx
  c6f3c6:	0f 87 25 2f 00 00    	ja     c722f1 <x86_encode_64+0x3c51>
  c6f3cc:	62 f2 7d 48 5a 1d 5a 34 8e ff 	vbroadcasti32x4 -0x71cba6(%rip),%zmm3        # 552830 <x86_disassembly_listing.hex+0xd40>
  c6f3d6:	62 72 7d 48 58 0d e8 97 90 ff 	vpbroadcastd -0x6f6818(%rip),%zmm9        # 578bc8 <x86_break_instruction.legacy_forms+0x650>
  c6f3e0:	48 89 c2             	mov    %rax,%rdx
  c6f3e3:	48 c1 e2 04          	shl    $0x4,%rdx
  c6f3e7:	41 b2 cc             	mov    $0xcc,%r10b
  c6f3ea:	4c 8d 0d 8f 2f 13 02 	lea    0x2132f8f(%rip),%r9        # 2da2380 <x86_template_storage>
  c6f3f1:	62 53 1d 48 25 e4 ff 	vpternlogd $0xff,%zmm12,%zmm12,%zmm12
  c6f3f8:	48 8d 94 3a fc 00 00 00 	lea    0xfc(%rdx,%rdi,1),%rdx
  c6f400:	c4 c1 7b 92 ca       	kmovd  %r10d,%k1
  c6f405:	66 66 2e 0f 1f 84 00 00 00 00 00 	data16 cs nopw 0x0(%rax,%rax,1)
  c6f410:	44 0f b7 92 10 ff ff ff 	movzwl -0xf0(%rdx),%r10d
  c6f418:	44 0f b7 9a 20 ff ff ff 	movzwl -0xe0(%rdx),%r11d
  c6f420:	44 0f b7 b2 30 ff ff ff 	movzwl -0xd0(%rdx),%r14d
  c6f428:	44 0f b7 ba 40 ff ff ff 	movzwl -0xc0(%rdx),%r15d
  c6f430:	62 e1 fe 48 6f a2 04 ff ff ff 	vmovdqu64 -0xfc(%rdx),%zmm20
  c6f43a:	62 61 fe 48 6f 9a 44 ff ff ff 	vmovdqu64 -0xbc(%rdx),%zmm27
  c6f444:	62 61 fe 48 6f a2 84 ff ff ff 	vmovdqu64 -0x7c(%rdx),%zmm28
  c6f44e:	62 61 fe 48 6f aa c4 ff ff ff 	vmovdqu64 -0x3c(%rdx),%zmm29
  c6f458:	62 f2 7d 48 5a 05 0e 34 8e ff 	vbroadcasti32x4 -0x71cbf2(%rip),%zmm0        # 552870 <x86_disassembly_listing.hex+0xd80>
  c6f462:	62 f2 7d 48 5a 2d 14 34 8e ff 	vbroadcasti32x4 -0x71cbec(%rip),%zmm5        # 552880 <x86_disassembly_listing.hex+0xd90>
  c6f46c:	62 f2 7d 48 5a 35 1a 34 8e ff 	vbroadcasti32x4 -0x71cbe6(%rip),%zmm6        # 552890 <x86_disassembly_listing.hex+0xda0>
  c6f476:	62 72 7d 48 58 05 30 97 90 ff 	vpbroadcastd -0x6f68d0(%rip),%zmm8        # 578bb0 <x86_break_instruction.legacy_forms+0x638>
  c6f480:	41 c1 e2 06          	shl    $0x6,%r10d
  c6f484:	41 c1 e3 06          	shl    $0x6,%r11d
  c6f488:	41 c1 e6 06          	shl    $0x6,%r14d
  c6f48c:	41 c1 e7 06          	shl    $0x6,%r15d
  c6f490:	c4 81 7d 6f 4c 0a 40 	vmovdqa 0x40(%r10,%r9,1),%ymm1
  c6f497:	44 0f b7 92 50 ff ff ff 	movzwl -0xb0(%rdx),%r10d
  c6f49f:	62 13 f5 48 3a 5c 0e 02 01 	vinserti64x4 $0x1,0x40(%r14,%r9,1),%zmm1,%zmm11
  c6f4a8:	44 0f b7 b2 70 ff ff ff 	movzwl -0x90(%rdx),%r14d
  c6f4b0:	c4 81 7d 6f 4c 0b 60 	vmovdqa 0x60(%r11,%r9,1),%ymm1
  c6f4b7:	44 0f b7 9a 60 ff ff ff 	movzwl -0xa0(%rdx),%r11d
  c6f4bf:	62 83 f5 48 3a 74 0f 03 01 	vinserti64x4 $0x1,0x60(%r15,%r9,1),%zmm1,%zmm22
  c6f4c8:	44 0f b7 7a 80       	movzwl -0x80(%rdx),%r15d
  c6f4cd:	62 11 5d 40 62 f3    	vpunpckldq %zmm27,%zmm20,%zmm14
  c6f4d3:	62 11 1d 40 62 fd    	vpunpckldq %zmm29,%zmm28,%zmm15
  c6f4d9:	62 01 5d 40 6a db    	vpunpckhdq %zmm27,%zmm20,%zmm27
  c6f4df:	62 01 1d 40 6a ed    	vpunpckhdq %zmm29,%zmm28,%zmm29
  c6f4e5:	62 11 a5 40 6c d5    	vpunpcklqdq %zmm29,%zmm27,%zmm10
  c6f4eb:	62 41 8d 48 6d f7    	vpunpckhqdq %zmm15,%zmm14,%zmm30
  c6f4f1:	62 d2 d5 48 83 ea    	vpmultishiftqb %zmm10,%zmm5,%zmm5
  c6f4f7:	62 d2 cd 48 83 f2    	vpmultishiftqb %zmm10,%zmm6,%zmm6
  c6f4fd:	62 92 0d 40 27 c6    	vptestmd %zmm30,%zmm30,%k0
  c6f503:	62 41 fd 48 6f e2    	vmovdqa64 %zmm10,%zmm28
  c6f509:	41 c1 e2 06          	shl    $0x6,%r10d
  c6f50d:	c4 81 7d 6f 4c 0a 40 	vmovdqa 0x40(%r10,%r9,1),%ymm1
  c6f514:	44 0f b7 52 90       	movzwl -0x70(%rdx),%r10d
  c6f519:	41 c1 e6 06          	shl    $0x6,%r14d
  c6f51d:	41 c1 e3 06          	shl    $0x6,%r11d
  c6f521:	62 83 f5 48 3a 44 0e 02 01 	vinserti64x4 $0x1,0x40(%r14,%r9,1),%zmm1,%zmm16
  c6f52a:	44 0f b7 72 b0       	movzwl -0x50(%rdx),%r14d
  c6f52f:	c4 81 7d 6f 4c 0b 60 	vmovdqa 0x60(%r11,%r9,1),%ymm1
  c6f536:	44 0f b7 5a a0       	movzwl -0x60(%rdx),%r11d
  c6f53b:	41 c1 e7 06          	shl    $0x6,%r15d
  c6f53f:	62 03 f5 48 3a 44 0f 03 01 	vinserti64x4 $0x1,0x60(%r15,%r9,1),%zmm1,%zmm24
  c6f548:	44 0f b7 7a c0       	movzwl -0x40(%rdx),%r15d
  c6f54d:	62 32 a5 49 64 ee    	vpblendmq %zmm22,%zmm11,%zmm13{%k1}
  c6f553:	41 c1 e2 06          	shl    $0x6,%r10d
  c6f557:	c4 81 7d 6f 4c 0a 40 	vmovdqa 0x40(%r10,%r9,1),%ymm1
  c6f55e:	44 0f b7 52 d0       	movzwl -0x30(%rdx),%r10d
  c6f563:	41 c1 e6 06          	shl    $0x6,%r14d
  c6f567:	41 c1 e3 06          	shl    $0x6,%r11d
  c6f56b:	62 83 f5 48 3a 54 0e 02 01 	vinserti64x4 $0x1,0x40(%r14,%r9,1),%zmm1,%zmm18
  c6f574:	44 0f b7 72 f0       	movzwl -0x10(%rdx),%r14d
  c6f579:	c4 81 7d 6f 4c 0b 60 	vmovdqa 0x60(%r11,%r9,1),%ymm1
  c6f580:	44 0f b7 5a e0       	movzwl -0x20(%rdx),%r11d
  c6f585:	41 c1 e7 06          	shl    $0x6,%r15d
  c6f589:	62 03 f5 48 3a 4c 0f 03 01 	vinserti64x4 $0x1,0x60(%r15,%r9,1),%zmm1,%zmm25
  c6f592:	44 0f b7 3a          	movzwl (%rdx),%r15d
  c6f596:	48 81 c2 00 01 00 00 	add    $0x100,%rdx
  c6f59d:	62 82 fd 41 64 c8    	vpblendmq %zmm24,%zmm16,%zmm17{%k1}
  c6f5a3:	41 c1 e2 06          	shl    $0x6,%r10d
  c6f5a7:	41 c1 e3 06          	shl    $0x6,%r11d
  c6f5ab:	41 c1 e6 06          	shl    $0x6,%r14d
  c6f5af:	c4 81 7d 6f 4c 0a 40 	vmovdqa 0x40(%r10,%r9,1),%ymm1
  c6f5b6:	62 83 f5 48 3a 6c 0e 02 01 	vinserti64x4 $0x1,0x40(%r14,%r9,1),%zmm1,%zmm21
  c6f5bf:	41 c1 e7 06          	shl    $0x6,%r15d
  c6f5c3:	c4 81 7d 6f 4c 0b 60 	vmovdqa 0x60(%r11,%r9,1),%ymm1
  c6f5ca:	62 03 f5 48 3a 54 0f 03 01 	vinserti64x4 $0x1,0x60(%r15,%r9,1),%zmm1,%zmm26
  c6f5d3:	62 b1 15 48 6a c9    	vpunpckhdq %zmm17,%zmm13,%zmm1
  c6f5d9:	62 82 ed 41 64 d9    	vpblendmq %zmm25,%zmm18,%zmm19{%k1}
  c6f5df:	62 82 d5 41 64 fa    	vpblendmq %zmm26,%zmm21,%zmm23{%k1}
  c6f5e5:	62 b1 65 40 6a d7    	vpunpckhdq %zmm23,%zmm19,%zmm2
  c6f5eb:	62 e1 f5 48 6d e2    	vpunpckhqdq %zmm2,%zmm1,%zmm20
  c6f5f1:	62 d1 75 48 72 d2 1a 	vpsrld $0x1a,%zmm10,%zmm1
  c6f5f8:	62 f2 75 48 36 3d 3e b6 7a ff 	vpermd -0x8549c2(%rip),%zmm1,%zmm7        # 41ac40 <parallel_test_signals_kept.signals+0x3d40>
  c6f602:	62 62 75 48 36 3d 74 b6 7a ff 	vpermd -0x85498c(%rip),%zmm1,%zmm31        # 41ac80 <parallel_test_signals_kept.signals+0x3d80>
  c6f60c:	62 f2 75 48 36 25 aa b6 7a ff 	vpermd -0x854956(%rip),%zmm1,%zmm4        # 41acc0 <parallel_test_signals_kept.signals+0x3dc0>
  c6f616:	62 d2 fd 48 83 ca    	vpmultishiftqb %zmm10,%zmm0,%zmm1
  c6f61c:	62 f2 7d 48 5a 05 7a 32 8e ff 	vbroadcasti32x4 -0x71cd86(%rip),%zmm0        # 5528a0 <x86_disassembly_listing.hex+0xdb0>
  c6f626:	62 f3 75 58 25 2d 73 95 90 ff d8 	vpternlogd $0xd8,-0x6f6a8d(%rip){1to16},%zmm1,%zmm5        # 578ba4 <x86_break_instruction.legacy_forms+0x62c>
  c6f631:	62 d1 75 48 72 f2 04 	vpslld $0x4,%zmm10,%zmm1
  c6f638:	62 f1 6d 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm2
  c6f63f:	62 f3 55 58 25 35 5e 95 90 ff e4 	vpternlogd $0xe4,-0x6f6aa2(%rip){1to16},%zmm5,%zmm6        # 578ba8 <x86_break_instruction.legacy_forms+0x630>
  c6f64a:	62 d2 7d 48 00 ea    	vpshufb %zmm10,%zmm0,%zmm5
  c6f650:	62 91 7d 48 72 e6 1f 	vpsrad $0x1f,%zmm30,%zmm0
  c6f657:	62 f1 75 48 72 f5 10 	vpslld $0x10,%zmm5,%zmm1
  c6f65e:	62 f1 6d 48 db ed    	vpandd %zmm5,%zmm2,%zmm5
  c6f664:	62 f3 5d 58 25 2d 85 95 90 ff ec 	vpternlogd $0xec,-0x6f6a7b(%rip){1to16},%zmm4,%zmm5        # 578bf4 <x86_break_instruction.legacy_forms+0x67c>
  c6f66f:	62 f3 5d 50 25 2d 7e 95 90 ff f8 	vpternlogd $0xf8,-0x6f6a82(%rip){1to16},%zmm20,%zmm5        # 578bf8 <x86_break_instruction.legacy_forms+0x680>
  c6f67a:	62 63 4d 48 25 ff f8 	vpternlogd $0xf8,%zmm7,%zmm6,%zmm31
  c6f681:	62 f1 45 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm7
  c6f688:	62 f2 7e 48 38 c8    	vpmovm2d %k0,%zmm1
  c6f68e:	62 f3 6d 48 25 cf c8 	vpternlogd $0xc8,%zmm7,%zmm2,%zmm1
  c6f695:	62 91 7d 48 ef fe    	vpxord %zmm30,%zmm0,%zmm7
  c6f69b:	62 f2 7d 48 58 05 07 95 90 ff 	vpbroadcastd -0x6f6af9(%rip),%zmm0        # 578bac <x86_break_instruction.legacy_forms+0x634>
  c6f6a5:	62 f2 7d 48 44 ff    	vplzcntd %zmm7,%zmm7
  c6f6ab:	62 f2 3d 48 45 ff    	vpsrlvd %zmm7,%zmm8,%zmm7
  c6f6b1:	62 51 0d 40 fe c4    	vpaddd %zmm12,%zmm30,%zmm8
  c6f6b7:	62 73 0d 40 25 c7 14 	vpternlogd $0x14,%zmm7,%zmm30,%zmm8
  c6f6be:	62 d1 45 48 72 d2 08 	vpsrld $0x8,%zmm10,%zmm7
  c6f6c5:	62 63 7d 58 25 25 ec 94 90 ff 6c 	vpternlogd $0x6c,-0x6f6b14(%rip){1to16},%zmm0,%zmm28        # 578bbc <x86_break_instruction.legacy_forms+0x644>
  c6f6d0:	62 f3 7d 58 25 3d e5 94 90 ff 6c 	vpternlogd $0x6c,-0x6f6b1b(%rip){1to16},%zmm0,%zmm7        # 578bc0 <x86_break_instruction.legacy_forms+0x648>
  c6f6db:	62 91 7d 48 72 ce 01 	vprold $0x1,%zmm30,%zmm0
  c6f6e2:	62 41 1d 40 fe e4    	vpaddd %zmm12,%zmm28,%zmm28
  c6f6e8:	62 63 35 58 25 25 d1 94 90 ff ec 	vpternlogd $0xec,-0x6f6b2f(%rip){1to16},%zmm9,%zmm28        # 578bc4 <x86_break_instruction.legacy_forms+0x64c>
  c6f6f3:	62 d1 45 48 fe fc    	vpaddd %zmm12,%zmm7,%zmm7
  c6f6f9:	62 f3 1d 50 25 3d c8 94 90 ff ec 	vpternlogd $0xec,-0x6f6b38(%rip){1to16},%zmm28,%zmm7        # 578bcc <x86_break_instruction.legacy_forms+0x654>
  c6f704:	62 61 4d 58 db 25 c2 94 90 ff 	vpandd -0x6f6b3e(%rip){1to16},%zmm6,%zmm28        # 578bd0 <x86_break_instruction.legacy_forms+0x658>
  c6f70e:	62 f1 4d 48 72 d6 03 	vpsrld $0x3,%zmm6,%zmm6
  c6f715:	62 f3 5d 50 25 35 bc 94 90 ff a2 	vpternlogd $0xa2,-0x6f6b44(%rip){1to16},%zmm20,%zmm6        # 578bdc <x86_break_instruction.legacy_forms+0x664>
  c6f720:	62 f2 4d 58 3b 25 b6 94 90 ff 	vpminud -0x6f6b4a(%rip){1to16},%zmm6,%zmm4        # 578be0 <x86_break_instruction.legacy_forms+0x668>
  c6f72a:	62 63 5d 40 25 e7 f8 	vpternlogd $0xf8,%zmm7,%zmm20,%zmm28
  c6f731:	62 62 1d 50 3b 25 99 94 90 ff 	vpminud -0x6f6b67(%rip){1to16},%zmm28,%zmm28        # 578bd4 <x86_break_instruction.legacy_forms+0x65c>
  c6f73b:	62 b1 45 48 72 d4 1d 	vpsrld $0x1d,%zmm20,%zmm7
  c6f742:	62 72 3d 48 14 c7    	vprorvd %zmm7,%zmm8,%zmm8
  c6f748:	62 f2 7d 48 14 ff    	vprorvd %zmm7,%zmm0,%zmm7
  c6f74e:	62 f1 fd 48 6f 05 a8 b4 7a ff 	vmovdqa64 -0x854b58(%rip),%zmm0        # 41ac00 <parallel_test_signals_kept.signals+0x3d00>
  c6f758:	62 d1 3d 48 72 e0 1f 	vpsrad $0x1f,%zmm8,%zmm8
  c6f75f:	62 93 75 48 25 fe e2 	vpternlogd $0xe2,%zmm30,%zmm1,%zmm7
  c6f766:	62 93 3d 48 25 fe e2 	vpternlogd $0xe2,%zmm30,%zmm8,%zmm7
  c6f76d:	62 93 5d 48 25 ec fe 	vpternlogd $0xfe,%zmm28,%zmm4,%zmm5
  c6f774:	62 91 fd 48 6f e7    	vmovdqa64 %zmm31,%zmm4
  c6f77a:	62 01 fd 48 6f e7    	vmovdqa64 %zmm31,%zmm28
  c6f780:	62 f3 6d 58 25 25 2d 94 90 ff f8 	vpternlogd $0xf8,-0x6f6bd3(%rip){1to16},%zmm2,%zmm4        # 578bb8 <x86_break_instruction.legacy_forms+0x640>
  c6f78b:	62 63 75 58 25 25 1e 94 90 ff f8 	vpternlogd $0xf8,-0x6f6be2(%rip){1to16},%zmm1,%zmm28        # 578bb4 <x86_break_instruction.legacy_forms+0x63c>
  c6f796:	62 f1 6d 58 db 15 60 94 90 ff 	vpandd -0x6f6ba0(%rip){1to16},%zmm2,%zmm2        # 578c00 <x86_break_instruction.legacy_forms+0x688>
  c6f7a0:	62 32 fd 48 7e de    	vpermt2q %zmm22,%zmm0,%zmm11
  c6f7a6:	62 91 4d 40 72 d7 03 	vpsrld $0x3,%zmm31,%zmm22
  c6f7ad:	62 82 fd 48 7e c0    	vpermt2q %zmm24,%zmm0,%zmm16
  c6f7b3:	62 82 fd 48 7e d1    	vpermt2q %zmm25,%zmm0,%zmm18
  c6f7b9:	62 82 fd 48 7e ea    	vpermt2q %zmm26,%zmm0,%zmm21
  c6f7bf:	62 f2 7d 48 5a 05 e7 30 8e ff 	vbroadcasti32x4 -0x71cf19(%rip),%zmm0        # 5528b0 <x86_disassembly_listing.hex+0xdc0>
  c6f7c9:	62 93 3d 48 25 e4 b8 	vpternlogd $0xb8,%zmm28,%zmm8,%zmm4
  c6f7d0:	62 61 75 58 db 25 22 94 90 ff 	vpandd -0x6f6bde(%rip){1to16},%zmm1,%zmm28        # 578bfc <x86_break_instruction.legacy_forms+0x684>
  c6f7da:	62 91 75 48 72 d7 10 	vpsrld $0x10,%zmm31,%zmm1
  c6f7e1:	62 e3 75 58 25 35 ec 93 90 ff ec 	vpternlogd $0xec,-0x6f6c14(%rip){1to16},%zmm1,%zmm22        # 578bd8 <x86_break_instruction.legacy_forms+0x660>
  c6f7ec:	62 d1 4d 48 fe cc    	vpaddd %zmm12,%zmm6,%zmm1
  c6f7f2:	62 f1 75 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm1
  c6f7f9:	62 93 3d 48 25 d4 b8 	vpternlogd $0xb8,%zmm28,%zmm8,%zmm2
  c6f800:	62 51 8d 48 6c c7    	vpunpcklqdq %zmm15,%zmm14,%zmm8
  c6f806:	62 11 a5 40 6d f5    	vpunpckhqdq %zmm29,%zmm27,%zmm14
  c6f80c:	62 b1 4d 48 72 f6 08 	vpslld $0x8,%zmm22,%zmm6
  c6f813:	62 f3 75 58 25 35 c6 93 90 ff 08 	vpternlogd $0x8,-0x6f6c3a(%rip){1to16},%zmm1,%zmm6        # 578be4 <x86_break_instruction.legacy_forms+0x66c>
  c6f81e:	62 51 0d 48 eb d2    	vpord  %zmm10,%zmm14,%zmm10
  c6f824:	62 f1 6d 48 eb d5    	vpord  %zmm5,%zmm2,%zmm2
  c6f82a:	62 f1 3d 48 62 ef    	vpunpckldq %zmm7,%zmm8,%zmm5
  c6f830:	62 f1 3d 48 6a ff    	vpunpckhdq %zmm7,%zmm8,%zmm7
  c6f836:	62 d1 2d 48 72 f2 07 	vpslld $0x7,%zmm10,%zmm10
  c6f83d:	62 73 4d 58 25 15 a0 93 90 ff e4 	vpternlogd $0xe4,-0x6f6c60(%rip){1to16},%zmm6,%zmm10        # 578be8 <x86_break_instruction.legacy_forms+0x670>
  c6f848:	62 d2 fd 48 83 f6    	vpmultishiftqb %zmm14,%zmm0,%zmm6
  c6f84e:	62 f3 4d 50 25 35 93 93 90 ff d8 	vpternlogd $0xd8,-0x6f6c6d(%rip){1to16},%zmm22,%zmm6        # 578bec <x86_break_instruction.legacy_forms+0x674>
  c6f859:	62 f1 7d 48 70 c2 55 	vpshufd $0x55,%zmm2,%zmm0
  c6f860:	62 b2 7d 48 8f d0    	vpshufbitqmb %zmm16,%zmm0,%k2
  c6f866:	62 f1 7d 48 70 c2 aa 	vpshufd $0xaa,%zmm2,%zmm0
  c6f86d:	c4 61 fb 93 da       	kmovq  %k2,%r11
  c6f872:	f3 4d 0f b8 db       	popcnt %r11,%r11
  c6f877:	62 f3 2d 58 25 35 6e 93 90 ff d8 	vpternlogd $0xd8,-0x6f6c92(%rip){1to16},%zmm10,%zmm6        # 578bf0 <x86_break_instruction.legacy_forms+0x678>
  c6f882:	62 71 5d 48 62 c6    	vpunpckldq %zmm6,%zmm4,%zmm8
  c6f888:	62 f1 5d 48 6a e6    	vpunpckhdq %zmm6,%zmm4,%zmm4
  c6f88e:	62 d1 d5 48 6c f0    	vpunpcklqdq %zmm8,%zmm5,%zmm6
  c6f894:	62 d1 d5 48 6d e8    	vpunpckhqdq %zmm8,%zmm5,%zmm5
  c6f89a:	62 71 c5 48 6c c4    	vpunpcklqdq %zmm4,%zmm7,%zmm8
  c6f8a0:	62 f1 c5 48 6d e4    	vpunpckhqdq %zmm4,%zmm7,%zmm4
  c6f8a6:	62 f1 7d 48 70 fa 00 	vpshufd $0x0,%zmm2,%zmm7
  c6f8ad:	62 d2 4d 48 00 f3    	vpshufb %zmm11,%zmm6,%zmm6
  c6f8b3:	62 d2 45 48 8f db    	vpshufbitqmb %zmm11,%zmm7,%k3
  c6f8b9:	62 b2 55 48 00 e8    	vpshufb %zmm16,%zmm5,%zmm5
  c6f8bf:	62 b2 5d 48 00 e5    	vpshufb %zmm21,%zmm4,%zmm4
  c6f8c5:	62 f3 95 48 25 f3 78 	vpternlogq $0x78,%zmm3,%zmm13,%zmm6
  c6f8cc:	62 f3 f5 40 25 eb 78 	vpternlogq $0x78,%zmm3,%zmm17,%zmm5
  c6f8d3:	62 f3 c5 40 25 e3 78 	vpternlogq $0x78,%zmm3,%zmm23,%zmm4
  c6f8da:	c4 61 fb 93 d3       	kmovq  %k3,%r10
  c6f8df:	62 f2 7d cb 63 f6    	vpcompressb %zmm6,%zmm6{%k3}{z}
  c6f8e5:	62 b2 7d 48 8f da    	vpshufbitqmb %zmm18,%zmm0,%k3
  c6f8eb:	62 f1 7d 48 70 c2 ff 	vpshufd $0xff,%zmm2,%zmm0
  c6f8f2:	62 f2 7d ca 63 ed    	vpcompressb %zmm5,%zmm5{%k2}{z}
  c6f8f8:	62 f3 5d 50 25 15 01 93 90 ff 20 	vpternlogd $0x20,-0x6f6cff(%rip){1to16},%zmm20,%zmm2        # 578c04 <x86_break_instruction.legacy_forms+0x68c>
  c6f903:	62 b2 7d 48 8f d5    	vpshufbitqmb %zmm21,%zmm0,%k2
  c6f909:	62 f1 5d 50 db 05 f5 92 90 ff 	vpandd -0x6f6d0b(%rip){1to16},%zmm20,%zmm0        # 578c08 <x86_break_instruction.legacy_forms+0x690>
  c6f913:	f3 4d 0f b8 d2       	popcnt %r10,%r10
  c6f918:	62 f2 7d ca 63 e4    	vpcompressb %zmm4,%zmm4{%k2}{z}
  c6f91e:	62 f1 fe 48 7f 31    	vmovdqu64 %zmm6,(%rcx)
  c6f924:	62 b2 3d 48 00 f2    	vpshufb %zmm18,%zmm8,%zmm6
  c6f92a:	62 b1 fe 48 7f 2c 11 	vmovdqu64 %zmm5,(%rcx,%r10,1)
  c6f931:	49 01 ca             	add    %rcx,%r10
  c6f934:	29 d9                	sub    %ebx,%ecx
  c6f936:	62 f3 e5 40 25 f3 78 	vpternlogq $0x78,%zmm3,%zmm19,%zmm6
  c6f93d:	62 f2 7d 48 55 d2    	vpopcntd %zmm2,%zmm2
  c6f943:	c5 d1 ef ed          	vpxor  %xmm5,%xmm5,%xmm5
  c6f947:	62 f2 7d cb 63 f5    	vpcompressb %zmm6,%zmm5{%k3}{z}
  c6f94d:	62 f1 75 48 fe c8    	vpaddd %zmm0,%zmm1,%zmm1
  c6f953:	c5 f9 6f 05 e5 2e 8e ff 	vmovdqa -0x71d11b(%rip),%xmm0        # 552840 <x86_disassembly_listing.hex+0xd50>
  c6f95b:	62 f1 75 48 fe ca    	vpaddd %zmm2,%zmm1,%zmm1
  c6f961:	62 91 fe 48 7f 2c 13 	vmovdqu64 %zmm5,(%r11,%r10,1)
  c6f968:	4d 01 da             	add    %r11,%r10
  c6f96b:	c4 61 fb 93 db       	kmovq  %k3,%r11
  c6f970:	f3 4d 0f b8 db       	popcnt %r11,%r11
  c6f975:	62 91 fe 48 7f 24 13 	vmovdqu64 %zmm4,(%r11,%r10,1)
  c6f97c:	89 8c 24 00 01 00 00 	mov    %ecx,0x100(%rsp)
  c6f983:	c4 e1 fb 93 ca       	kmovq  %k2,%rcx
  c6f988:	f3 4c 0f b8 f1       	popcnt %rcx,%r14
  c6f98d:	62 f2 7d 48 8d c9    	vpermb %zmm1,%zmm0,%zmm1
  c6f993:	c5 f9 6f 05 c5 2e 8e ff 	vmovdqa -0x71d13b(%rip),%xmm0        # 552860 <x86_disassembly_listing.hex+0xd70>
  c6f99b:	62 f2 f5 18 40 0d eb 8a 90 ff 	vpmullq -0x6f7515(%rip){1to2},%xmm1,%xmm1        # 578490 <x86_effects_unknown+0x1a90>
  c6f9a5:	4d 01 de             	add    %r11,%r14
  c6f9a8:	4d 01 d6             	add    %r10,%r14
  c6f9ab:	4c 8d 50 10          	lea    0x10(%rax),%r10
  c6f9af:	48 83 c0 20          	add    $0x20,%rax
  c6f9b3:	62 d2 7d 48 8d d6    	vpermb %zmm14,%zmm0,%zmm2
  c6f9b9:	c4 e2 71 00 05 8e 2e 8e ff 	vpshufb -0x71d172(%rip),%xmm1,%xmm0        # 552850 <x86_disassembly_listing.hex+0xd60>
  c6f9c2:	62 f2 7e 48 29 da    	vpmovb2m %zmm2,%k3
  c6f9c8:	c5 fb 93 cb          	kmovd  %k3,%ecx
  c6f9cc:	0f b7 c9             	movzwl %cx,%ecx
  c6f9cf:	c5 f9 fc c9          	vpaddb %xmm1,%xmm0,%xmm1
  c6f9d3:	f3 0f b8 c9          	popcnt %ecx,%ecx
  c6f9d7:	62 f2 7d 48 31 c9    	vpmovzxbd %xmm1,%zmm1
  c6f9dd:	62 f1 75 58 fe 4c 24 40 	vpaddd 0x100(%rsp){1to16},%zmm1,%zmm1
  c6f9e5:	62 f2 7d cb 8b c9    	vpcompressd %zmm1,%zmm1{%k3}{z}
  c6f9eb:	62 d1 fe 48 7f 08    	vmovdqu64 %zmm1,(%r8)
  c6f9f1:	4d 8d 04 88          	lea    (%r8,%rcx,4),%r8
  c6f9f5:	4c 89 f1             	mov    %r14,%rcx
  c6f9f8:	48 39 f0             	cmp    %rsi,%rax
  c6f9fb:	4c 89 d0             	mov    %r10,%rax
  c6f9fe:	0f 86 0c fa ff ff    	jbe    c6f410 <x86_encode_64+0xd70>
  c6fa04:	4c 29 d6             	sub    %r10,%rsi
  c6fa07:	0f 87 f3 28 00 00    	ja     c72300 <x86_encode_64+0x3c60>
  c6fa0d:	e9 06 3c 00 00       	jmp    c73618 <x86_encode_64+0x4f78>
  c6fa12:	62 72 7d 48 5a 1d 14 2e 8e ff 	vbroadcasti32x4 -0x71d1ec(%rip),%zmm11        # 552830 <x86_disassembly_listing.hex+0xd40>
  c6fa1c:	62 e1 fd 48 6f 35 da b1 7a ff 	vmovdqa64 -0x854e26(%rip),%zmm22        # 41ac00 <parallel_test_signals_kept.signals+0x3d00>
  c6fa26:	62 f1 fd 48 6f 1d 10 b2 7a ff 	vmovdqa64 -0x854df0(%rip),%zmm3        # 41ac40 <parallel_test_signals_kept.signals+0x3d40>
  c6fa30:	62 f1 fd 48 6f 2d 46 b2 7a ff 	vmovdqa64 -0x854dba(%rip),%zmm5        # 41ac80 <parallel_test_signals_kept.signals+0x3d80>
  c6fa3a:	62 71 fd 48 6f 3d 7c b2 7a ff 	vmovdqa64 -0x854d84(%rip),%zmm15        # 41acc0 <parallel_test_signals_kept.signals+0x3dc0>
  c6fa44:	62 f2 7d 48 5a 35 22 2e 8e ff 	vbroadcasti32x4 -0x71d1de(%rip),%zmm6        # 552870 <x86_disassembly_listing.hex+0xd80>
  c6fa4e:	62 f2 7d 48 5a 3d 28 2e 8e ff 	vbroadcasti32x4 -0x71d1d8(%rip),%zmm7        # 552880 <x86_disassembly_listing.hex+0xd90>
  c6fa58:	62 72 7d 48 5a 05 2e 2e 8e ff 	vbroadcasti32x4 -0x71d1d2(%rip),%zmm8        # 552890 <x86_disassembly_listing.hex+0xda0>
  c6fa62:	62 72 7d 48 58 0d 38 91 90 ff 	vpbroadcastd -0x6f6ec8(%rip),%zmm9        # 578ba4 <x86_break_instruction.legacy_forms+0x62c>
  c6fa6c:	62 72 7d 48 58 2d 3e 91 90 ff 	vpbroadcastd -0x6f6ec2(%rip),%zmm13        # 578bb4 <x86_break_instruction.legacy_forms+0x63c>
  c6fa76:	62 72 7d 48 58 15 70 91 90 ff 	vpbroadcastd -0x6f6e90(%rip),%zmm10        # 578bf0 <x86_break_instruction.legacy_forms+0x678>
  c6fa80:	b0 cc                	mov    $0xcc,%al
  c6fa82:	45 31 db             	xor    %r11d,%r11d
  c6fa85:	4c 8d 0d f4 28 13 02 	lea    0x21328f4(%rip),%r9        # 2da2380 <x86_template_storage>
  c6fa8c:	48 89 da             	mov    %rbx,%rdx
  c6fa8f:	c5 fb 92 c8          	kmovd  %eax,%k1
  c6fa93:	62 71 fd 48 7f 5c 24 02 	vmovdqa64 %zmm11,0x80(%rsp)
  c6fa9b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  c6faa0:	4c 89 d8             	mov    %r11,%rax
  c6faa3:	4e 8d 1c 9d 00 00 00 00 	lea    0x0(,%r11,4),%r11
  c6faab:	45 31 d2             	xor    %r10d,%r10d
  c6faae:	66 90                	xchg   %ax,%ax
  c6fab0:	46 0f b7 74 9f 0c    	movzwl 0xc(%rdi,%r11,4),%r14d
  c6fab6:	46 0f b7 7c 9f 1c    	movzwl 0x1c(%rdi,%r11,4),%r15d
  c6fabc:	46 0f b7 64 9f 2c    	movzwl 0x2c(%rdi,%r11,4),%r12d
  c6fac2:	46 0f b7 6c 9f 3c    	movzwl 0x3c(%rdi,%r11,4),%r13d
  c6fac8:	62 a1 fe 48 6f 24 9f 	vmovdqu64 (%rdi,%r11,4),%zmm20
  c6facf:	62 21 fe 48 6f 5c 9f 01 	vmovdqu64 0x40(%rdi,%r11,4),%zmm27
  c6fad7:	62 21 fe 48 6f 64 9f 02 	vmovdqu64 0x80(%rdi,%r11,4),%zmm28
  c6fadf:	62 21 fe 48 6f 6c 9f 03 	vmovdqu64 0xc0(%rdi,%r11,4),%zmm29
  c6fae7:	62 d1 fd 48 6f c2    	vmovdqa64 %zmm10,%zmm0
  c6faed:	49 83 c2 f0          	add    $0xfffffffffffffff0,%r10
  c6faf1:	41 c1 e6 06          	shl    $0x6,%r14d
  c6faf5:	41 c1 e7 06          	shl    $0x6,%r15d
  c6faf9:	41 c1 e4 06          	shl    $0x6,%r12d
  c6fafd:	41 c1 e5 06          	shl    $0x6,%r13d
  c6fb01:	c4 81 7d 6f 4c 0e 40 	vmovdqa 0x40(%r14,%r9,1),%ymm1
  c6fb08:	46 0f b7 74 9f 4c    	movzwl 0x4c(%rdi,%r11,4),%r14d
  c6fb0e:	62 13 f5 48 3a 5c 0c 02 01 	vinserti64x4 $0x1,0x40(%r12,%r9,1),%zmm1,%zmm11
  c6fb17:	46 0f b7 64 9f 6c    	movzwl 0x6c(%rdi,%r11,4),%r12d
  c6fb1d:	c4 81 7d 6f 4c 0f 60 	vmovdqa 0x60(%r15,%r9,1),%ymm1
  c6fb24:	46 0f b7 7c 9f 5c    	movzwl 0x5c(%rdi,%r11,4),%r15d
  c6fb2a:	62 83 f5 48 3a 4c 0d 03 01 	vinserti64x4 $0x1,0x60(%r13,%r9,1),%zmm1,%zmm17
  c6fb33:	46 0f b7 6c 9f 7c    	movzwl 0x7c(%rdi,%r11,4),%r13d
  c6fb39:	62 11 5d 40 62 e3    	vpunpckldq %zmm27,%zmm20,%zmm12
  c6fb3f:	62 11 1d 40 62 f5    	vpunpckldq %zmm29,%zmm28,%zmm14
  c6fb45:	62 01 5d 40 6a db    	vpunpckhdq %zmm27,%zmm20,%zmm27
  c6fb4b:	62 01 1d 40 6a ed    	vpunpckhdq %zmm29,%zmm28,%zmm29
  c6fb51:	62 11 a5 40 6c d5    	vpunpcklqdq %zmm29,%zmm27,%zmm10
  c6fb57:	62 41 9d 48 6d f6    	vpunpckhqdq %zmm14,%zmm12,%zmm30
  c6fb5d:	62 92 0d 40 27 c6    	vptestmd %zmm30,%zmm30,%k0
  c6fb63:	62 41 fd 48 6f e2    	vmovdqa64 %zmm10,%zmm28
  c6fb69:	41 c1 e6 06          	shl    $0x6,%r14d
  c6fb6d:	c4 81 7d 6f 4c 0e 40 	vmovdqa 0x40(%r14,%r9,1),%ymm1
  c6fb74:	46 0f b7 b4 9f 8c 00 00 00 	movzwl 0x8c(%rdi,%r11,4),%r14d
  c6fb7d:	41 c1 e4 06          	shl    $0x6,%r12d
  c6fb81:	41 c1 e7 06          	shl    $0x6,%r15d
  c6fb85:	62 83 f5 48 3a 44 0c 02 01 	vinserti64x4 $0x1,0x40(%r12,%r9,1),%zmm1,%zmm16
  c6fb8e:	46 0f b7 a4 9f ac 00 00 00 	movzwl 0xac(%rdi,%r11,4),%r12d
  c6fb97:	c4 81 7d 6f 4c 0f 60 	vmovdqa 0x60(%r15,%r9,1),%ymm1
  c6fb9e:	46 0f b7 bc 9f 9c 00 00 00 	movzwl 0x9c(%rdi,%r11,4),%r15d
  c6fba7:	41 c1 e5 06          	shl    $0x6,%r13d
  c6fbab:	62 03 f5 48 3a 44 0d 03 01 	vinserti64x4 $0x1,0x60(%r13,%r9,1),%zmm1,%zmm24
  c6fbb4:	46 0f b7 ac 9f bc 00 00 00 	movzwl 0xbc(%rdi,%r11,4),%r13d
  c6fbbd:	62 b2 a5 49 64 d1    	vpblendmq %zmm17,%zmm11,%zmm2{%k1}
  c6fbc3:	62 32 cd 40 7e d9    	vpermt2q %zmm17,%zmm22,%zmm11
  c6fbc9:	62 e2 7d 48 5a 0d dd 2c 8e ff 	vbroadcasti32x4 -0x71d323(%rip),%zmm17        # 5528b0 <x86_disassembly_listing.hex+0xdc0>
  c6fbd3:	41 c1 e6 06          	shl    $0x6,%r14d
  c6fbd7:	62 f1 fd 48 7f 54 24 01 	vmovdqa64 %zmm2,0x40(%rsp)
  c6fbdf:	c4 81 7d 6f 4c 0e 40 	vmovdqa 0x40(%r14,%r9,1),%ymm1
  c6fbe6:	46 0f b7 b4 9f cc 00 00 00 	movzwl 0xcc(%rdi,%r11,4),%r14d
  c6fbef:	41 c1 e4 06          	shl    $0x6,%r12d
  c6fbf3:	41 c1 e7 06          	shl    $0x6,%r15d
  c6fbf7:	62 83 f5 48 3a 54 0c 02 01 	vinserti64x4 $0x1,0x40(%r12,%r9,1),%zmm1,%zmm18
  c6fc00:	46 0f b7 a4 9f ec 00 00 00 	movzwl 0xec(%rdi,%r11,4),%r12d
  c6fc09:	c4 81 7d 6f 4c 0f 60 	vmovdqa 0x60(%r15,%r9,1),%ymm1
  c6fc10:	46 0f b7 bc 9f dc 00 00 00 	movzwl 0xdc(%rdi,%r11,4),%r15d
  c6fc19:	41 c1 e5 06          	shl    $0x6,%r13d
  c6fc1d:	62 03 f5 48 3a 4c 0d 03 01 	vinserti64x4 $0x1,0x60(%r13,%r9,1),%zmm1,%zmm25
  c6fc26:	46 0f b7 ac 9f fc 00 00 00 	movzwl 0xfc(%rdi,%r11,4),%r13d
  c6fc2f:	62 92 fd 41 64 e0    	vpblendmq %zmm24,%zmm16,%zmm4{%k1}
  c6fc35:	62 82 cd 40 7e c0    	vpermt2q %zmm24,%zmm22,%zmm16
  c6fc3b:	62 62 7d 48 58 05 93 8f 90 ff 	vpbroadcastd -0x6f706d(%rip),%zmm24        # 578bd8 <x86_break_instruction.legacy_forms+0x660>
  c6fc45:	41 c1 e6 06          	shl    $0x6,%r14d
  c6fc49:	62 f1 fd 48 7f 24 24 	vmovdqa64 %zmm4,(%rsp)
  c6fc50:	41 c1 e7 06          	shl    $0x6,%r15d
  c6fc54:	41 c1 e4 06          	shl    $0x6,%r12d
  c6fc58:	c4 81 7d 6f 4c 0e 40 	vmovdqa 0x40(%r14,%r9,1),%ymm1
  c6fc5f:	62 83 f5 48 3a 6c 0c 02 01 	vinserti64x4 $0x1,0x40(%r12,%r9,1),%zmm1,%zmm21
  c6fc68:	41 c1 e5 06          	shl    $0x6,%r13d
  c6fc6c:	c4 81 7d 6f 4c 0f 60 	vmovdqa 0x60(%r15,%r9,1),%ymm1
  c6fc73:	62 03 f5 48 3a 54 0d 03 01 	vinserti64x4 $0x1,0x60(%r13,%r9,1),%zmm1,%zmm26
  c6fc7c:	62 f1 6d 48 6a cc    	vpunpckhdq %zmm4,%zmm2,%zmm1
  c6fc82:	62 d1 5d 48 72 d2 1a 	vpsrld $0x1a,%zmm10,%zmm4
  c6fc89:	62 62 5d 48 36 fd    	vpermd %zmm5,%zmm4,%zmm31
  c6fc8f:	62 f2 7d 48 5a 2d 07 2c 8e ff 	vbroadcasti32x4 -0x71d3f9(%rip),%zmm5        # 5528a0 <x86_disassembly_listing.hex+0xdb0>
  c6fc99:	62 82 ed 41 64 d9    	vpblendmq %zmm25,%zmm18,%zmm19{%k1}
  c6fc9f:	62 82 cd 40 7e d1    	vpermt2q %zmm25,%zmm22,%zmm18
  c6fca5:	62 82 d5 41 64 fa    	vpblendmq %zmm26,%zmm21,%zmm23{%k1}
  c6fcab:	62 82 cd 40 7e ea    	vpermt2q %zmm26,%zmm22,%zmm21
  c6fcb1:	62 b1 65 40 6a d7    	vpunpckhdq %zmm23,%zmm19,%zmm2
  c6fcb7:	62 d2 55 48 00 ea    	vpshufb %zmm10,%zmm5,%zmm5
  c6fcbd:	62 e1 f5 48 6d e2    	vpunpckhqdq %zmm2,%zmm1,%zmm20
  c6fcc3:	62 f2 5d 48 36 d3    	vpermd %zmm3,%zmm4,%zmm2
  c6fcc9:	62 d2 cd 48 83 ca    	vpmultishiftqb %zmm10,%zmm6,%zmm1
  c6fccf:	62 d2 c5 48 83 da    	vpmultishiftqb %zmm10,%zmm7,%zmm3
  c6fcd5:	62 d2 bd 48 83 f2    	vpmultishiftqb %zmm10,%zmm8,%zmm6
  c6fcdb:	62 d2 5d 48 36 e7    	vpermd %zmm15,%zmm4,%zmm4
  c6fce1:	62 72 7d 48 58 3d c1 8e 90 ff 	vpbroadcastd -0x6f713f(%rip),%zmm15        # 578bac <x86_break_instruction.legacy_forms+0x634>
  c6fceb:	62 91 3d 48 72 e6 1f 	vpsrad $0x1f,%zmm30,%zmm8
  c6fcf2:	62 d3 75 48 25 d9 d8 	vpternlogd $0xd8,%zmm9,%zmm1,%zmm3
  c6fcf9:	62 72 7d 48 58 0d c5 8e 90 ff 	vpbroadcastd -0x6f713b(%rip),%zmm9        # 578bc8 <x86_break_instruction.legacy_forms+0x650>
  c6fd03:	62 d1 75 48 72 f2 04 	vpslld $0x4,%zmm10,%zmm1
  c6fd0a:	62 f3 65 58 25 35 93 8e 90 ff e4 	vpternlogd $0xe4,-0x6f716d(%rip){1to16},%zmm3,%zmm6        # 578ba8 <x86_break_instruction.legacy_forms+0x630>
  c6fd15:	62 f1 fd 48 6f df    	vmovdqa64 %zmm7,%zmm3
  c6fd1b:	62 63 05 58 25 25 96 8e 90 ff 6c 	vpternlogd $0x6c,-0x6f716a(%rip){1to16},%zmm15,%zmm28        # 578bbc <x86_break_instruction.legacy_forms+0x644>
  c6fd26:	62 61 1d 50 fe 25 dc 8e 90 ff 	vpaddd -0x6f7124(%rip){1to16},%zmm28,%zmm28        # 578c0c <x86_break_instruction.legacy_forms+0x694>
  c6fd30:	62 63 4d 48 25 fa f8 	vpternlogd $0xf8,%zmm2,%zmm6,%zmm31
  c6fd37:	62 f1 6d 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm2
  c6fd3e:	62 f1 75 48 72 f5 10 	vpslld $0x10,%zmm5,%zmm1
  c6fd45:	62 63 35 58 25 25 74 8e 90 ff ec 	vpternlogd $0xec,-0x6f718c(%rip){1to16},%zmm9,%zmm28        # 578bc4 <x86_break_instruction.legacy_forms+0x64c>
  c6fd50:	62 71 4d 58 db 0d 76 8e 90 ff 	vpandd -0x6f718a(%rip){1to16},%zmm6,%zmm9        # 578bd0 <x86_break_instruction.legacy_forms+0x658>
  c6fd5a:	62 f1 4d 48 72 d6 03 	vpsrld $0x3,%zmm6,%zmm6
  c6fd61:	62 f3 5d 50 25 35 70 8e 90 ff a2 	vpternlogd $0xa2,-0x6f7190(%rip){1to16},%zmm20,%zmm6        # 578bdc <x86_break_instruction.legacy_forms+0x664>
  c6fd6c:	62 f1 45 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm7
  c6fd73:	62 f2 7e 48 38 c8    	vpmovm2d %k0,%zmm1
  c6fd79:	62 f1 6d 48 db ed    	vpandd %zmm5,%zmm2,%zmm5
  c6fd7f:	62 f3 5d 58 25 2d 6a 8e 90 ff ec 	vpternlogd $0xec,-0x6f7196(%rip){1to16},%zmm4,%zmm5        # 578bf4 <x86_break_instruction.legacy_forms+0x67c>
  c6fd8a:	62 f2 4d 58 3b 25 4c 8e 90 ff 	vpminud -0x6f71b4(%rip){1to16},%zmm6,%zmm4        # 578be0 <x86_break_instruction.legacy_forms+0x668>
  c6fd94:	62 f3 6d 48 25 cf c8 	vpternlogd $0xc8,%zmm7,%zmm2,%zmm1
  c6fd9b:	62 91 3d 48 ef fe    	vpxord %zmm30,%zmm8,%zmm7
  c6fda1:	62 72 7d 48 58 05 05 8e 90 ff 	vpbroadcastd -0x6f71fb(%rip),%zmm8        # 578bb0 <x86_break_instruction.legacy_forms+0x638>
  c6fdab:	62 f3 5d 50 25 2d 42 8e 90 ff f8 	vpternlogd $0xf8,-0x6f71be(%rip){1to16},%zmm20,%zmm5        # 578bf8 <x86_break_instruction.legacy_forms+0x680>
  c6fdb6:	62 f2 7d 48 44 ff    	vplzcntd %zmm7,%zmm7
  c6fdbc:	62 f2 3d 48 45 ff    	vpsrlvd %zmm7,%zmm8,%zmm7
  c6fdc2:	62 53 3d 48 25 c0 ff 	vpternlogd $0xff,%zmm8,%zmm8,%zmm8
  c6fdc9:	62 51 0d 40 fe c0    	vpaddd %zmm8,%zmm30,%zmm8
  c6fdcf:	62 73 0d 40 25 c7 14 	vpternlogd $0x14,%zmm7,%zmm30,%zmm8
  c6fdd6:	62 d1 45 48 72 d2 08 	vpsrld $0x8,%zmm10,%zmm7
  c6fddd:	62 f3 05 58 25 3d d8 8d 90 ff 6c 	vpternlogd $0x6c,-0x6f7228(%rip){1to16},%zmm15,%zmm7        # 578bc0 <x86_break_instruction.legacy_forms+0x648>
  c6fde8:	62 71 75 58 db 3d 0a 8e 90 ff 	vpandd -0x6f71f6(%rip){1to16},%zmm1,%zmm15        # 578bfc <x86_break_instruction.legacy_forms+0x684>
  c6fdf2:	62 f1 45 58 fe 3d 10 8e 90 ff 	vpaddd -0x6f71f0(%rip){1to16},%zmm7,%zmm7        # 578c0c <x86_break_instruction.legacy_forms+0x694>
  c6fdfc:	62 f3 1d 50 25 3d c5 8d 90 ff ec 	vpternlogd $0xec,-0x6f723b(%rip){1to16},%zmm28,%zmm7        # 578bcc <x86_break_instruction.legacy_forms+0x654>
  c6fe07:	62 73 5d 40 25 cf f8 	vpternlogd $0xf8,%zmm7,%zmm20,%zmm9
  c6fe0e:	62 62 35 58 3b 25 bc 8d 90 ff 	vpminud -0x6f7244(%rip){1to16},%zmm9,%zmm28        # 578bd4 <x86_break_instruction.legacy_forms+0x65c>
  c6fe18:	62 91 35 48 72 ce 01 	vprold $0x1,%zmm30,%zmm9
  c6fe1f:	62 b1 45 48 72 d4 1d 	vpsrld $0x1d,%zmm20,%zmm7
  c6fe26:	62 72 3d 48 14 c7    	vprorvd %zmm7,%zmm8,%zmm8
  c6fe2c:	62 f2 35 48 14 ff    	vprorvd %zmm7,%zmm9,%zmm7
  c6fe32:	62 72 7d 48 58 0d a8 8d 90 ff 	vpbroadcastd -0x6f7258(%rip),%zmm9        # 578be4 <x86_break_instruction.legacy_forms+0x66c>
  c6fe3c:	62 d1 3d 48 72 e0 1f 	vpsrad $0x1f,%zmm8,%zmm8
  c6fe43:	62 93 75 48 25 fe e2 	vpternlogd $0xe2,%zmm30,%zmm1,%zmm7
  c6fe4a:	62 93 3d 48 25 fe e2 	vpternlogd $0xe2,%zmm30,%zmm8,%zmm7
  c6fe51:	62 93 5d 48 25 ec fe 	vpternlogd $0xfe,%zmm28,%zmm4,%zmm5
  c6fe58:	62 91 fd 48 6f e7    	vmovdqa64 %zmm31,%zmm4
  c6fe5e:	62 f3 6d 58 25 25 4f 8d 90 ff f8 	vpternlogd $0xf8,-0x6f72b1(%rip){1to16},%zmm2,%zmm4        # 578bb8 <x86_break_instruction.legacy_forms+0x640>
  c6fe69:	62 f1 6d 58 db 15 8d 8d 90 ff 	vpandd -0x6f7273(%rip){1to16},%zmm2,%zmm2        # 578c00 <x86_break_instruction.legacy_forms+0x688>
  c6fe73:	62 01 fd 48 6f e7    	vmovdqa64 %zmm31,%zmm28
  c6fe79:	62 43 75 48 25 e5 f8 	vpternlogd $0xf8,%zmm13,%zmm1,%zmm28
  c6fe80:	62 91 75 48 72 d7 10 	vpsrld $0x10,%zmm31,%zmm1
  c6fe87:	62 d3 3d 48 25 d7 b8 	vpternlogd $0xb8,%zmm15,%zmm8,%zmm2
  c6fe8e:	62 91 05 48 72 d7 03 	vpsrld $0x3,%zmm31,%zmm15
  c6fe95:	62 93 3d 48 25 e4 b8 	vpternlogd $0xb8,%zmm28,%zmm8,%zmm4
  c6fe9c:	62 51 9d 48 6c c6    	vpunpcklqdq %zmm14,%zmm12,%zmm8
  c6fea2:	62 53 1d 48 25 e4 ff 	vpternlogd $0xff,%zmm12,%zmm12,%zmm12
  c6fea9:	62 11 a5 40 6d f5    	vpunpckhqdq %zmm29,%zmm27,%zmm14
  c6feaf:	62 13 75 48 25 f8 ec 	vpternlogd $0xec,%zmm24,%zmm1,%zmm15
  c6feb6:	62 62 7d 48 58 05 28 8d 90 ff 	vpbroadcastd -0x6f72d8(%rip),%zmm24        # 578be8 <x86_break_instruction.legacy_forms+0x670>
  c6fec0:	62 d1 4d 48 fe cc    	vpaddd %zmm12,%zmm6,%zmm1
  c6fec6:	62 51 0d 48 eb d2    	vpord  %zmm10,%zmm14,%zmm10
  c6fecc:	62 f1 6d 48 eb d5    	vpord  %zmm5,%zmm2,%zmm2
  c6fed2:	62 f1 3d 48 62 ef    	vpunpckldq %zmm7,%zmm8,%zmm5
  c6fed8:	62 f1 3d 48 6a ff    	vpunpckhdq %zmm7,%zmm8,%zmm7
  c6fede:	62 72 7d 48 58 25 1c 8d 90 ff 	vpbroadcastd -0x6f72e4(%rip),%zmm12        # 578c04 <x86_break_instruction.legacy_forms+0x68c>
  c6fee8:	62 f1 75 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm1
  c6feef:	62 d1 4d 48 72 f7 08 	vpslld $0x8,%zmm15,%zmm6
  c6fef6:	62 d1 2d 48 72 f2 07 	vpslld $0x7,%zmm10,%zmm10
  c6fefd:	62 d3 75 48 25 f1 08 	vpternlogd $0x8,%zmm9,%zmm1,%zmm6
  c6ff04:	62 72 7d 48 58 0d de 8c 90 ff 	vpbroadcastd -0x6f7322(%rip),%zmm9        # 578bec <x86_break_instruction.legacy_forms+0x674>
  c6ff0e:	62 13 4d 48 25 d0 e4 	vpternlogd $0xe4,%zmm24,%zmm6,%zmm10
  c6ff15:	62 d2 f5 40 83 f6    	vpmultishiftqb %zmm14,%zmm17,%zmm6
  c6ff1b:	62 e1 fd 48 6f 4c 24 02 	vmovdqa64 0x80(%rsp),%zmm17
  c6ff23:	62 d3 05 48 25 f1 d8 	vpternlogd $0xd8,%zmm9,%zmm15,%zmm6
  c6ff2a:	62 72 7d 48 58 0d 70 8c 90 ff 	vpbroadcastd -0x6f7390(%rip),%zmm9        # 578ba4 <x86_break_instruction.legacy_forms+0x62c>
  c6ff34:	62 f3 2d 48 25 f0 d8 	vpternlogd $0xd8,%zmm0,%zmm10,%zmm6
  c6ff3b:	62 71 fd 48 6f d0    	vmovdqa64 %zmm0,%zmm10
  c6ff41:	62 f1 7d 48 70 c2 00 	vpshufd $0x0,%zmm2,%zmm0
  c6ff48:	62 71 5d 48 62 c6    	vpunpckldq %zmm6,%zmm4,%zmm8
  c6ff4e:	62 f1 5d 48 6a e6    	vpunpckhdq %zmm6,%zmm4,%zmm4
  c6ff54:	62 d2 7d 48 8f db    	vpshufbitqmb %zmm11,%zmm0,%k3
  c6ff5a:	62 f1 7d 48 70 c2 55 	vpshufd $0x55,%zmm2,%zmm0
  c6ff61:	62 d1 d5 48 6c f0    	vpunpcklqdq %zmm8,%zmm5,%zmm6
  c6ff67:	62 d1 d5 48 6d e8    	vpunpckhqdq %zmm8,%zmm5,%zmm5
  c6ff6d:	62 b2 7d 48 8f d0    	vpshufbitqmb %zmm16,%zmm0,%k2
  c6ff73:	62 f1 7d 48 70 c2 aa 	vpshufd $0xaa,%zmm2,%zmm0
  c6ff7a:	62 71 c5 48 6c fc    	vpunpcklqdq %zmm4,%zmm7,%zmm15
  c6ff80:	62 f1 c5 48 6d e4    	vpunpckhqdq %zmm4,%zmm7,%zmm4
  c6ff86:	62 f1 fd 48 6f fb    	vmovdqa64 %zmm3,%zmm7
  c6ff8c:	62 72 7d 48 5a 05 fa 28 8e ff 	vbroadcasti32x4 -0x71d706(%rip),%zmm8        # 552890 <x86_disassembly_listing.hex+0xda0>
  c6ff96:	62 d2 4d 48 00 f3    	vpshufb %zmm11,%zmm6,%zmm6
  c6ff9c:	62 b2 55 48 00 e8    	vpshufb %zmm16,%zmm5,%zmm5
  c6ffa2:	62 b2 05 48 00 da    	vpshufb %zmm18,%zmm15,%zmm3
  c6ffa8:	62 b2 5d 48 00 e5    	vpshufb %zmm21,%zmm4,%zmm4
  c6ffae:	62 71 fd 48 6f 3d 08 ad 7a ff 	vmovdqa64 -0x8552f8(%rip),%zmm15        # 41acc0 <parallel_test_signals_kept.signals+0x3dc0>
  c6ffb8:	c4 61 fb 93 f3       	kmovq  %k3,%r14
  c6ffbd:	62 f3 f5 40 25 74 24 01 78 	vpternlogq $0x78,0x40(%rsp),%zmm17,%zmm6
  c6ffc6:	62 f3 f5 40 25 2c 24 78 	vpternlogq $0x78,(%rsp),%zmm17,%zmm5
  c6ffce:	c4 61 fb 93 fa       	kmovq  %k2,%r15
  c6ffd3:	f3 4d 0f b8 f6       	popcnt %r14,%r14
  c6ffd8:	62 b3 e5 40 25 d9 78 	vpternlogq $0x78,%zmm17,%zmm19,%zmm3
  c6ffdf:	62 b3 c5 40 25 e1 78 	vpternlogq $0x78,%zmm17,%zmm23,%zmm4
  c6ffe6:	f3 4d 0f b8 ff       	popcnt %r15,%r15
  c6ffeb:	62 f2 7d cb 63 f6    	vpcompressb %zmm6,%zmm6{%k3}{z}
  c6fff1:	62 b2 7d 48 8f da    	vpshufbitqmb %zmm18,%zmm0,%k3
  c6fff7:	62 f1 7d 48 70 c2 ff 	vpshufd $0xff,%zmm2,%zmm0
  c6fffe:	62 f2 7d ca 63 ed    	vpcompressb %zmm5,%zmm5{%k2}{z}
  c70004:	62 d3 5d 40 25 d4 20 	vpternlogd $0x20,%zmm12,%zmm20,%zmm2
  c7000b:	c4 62 79 59 25 7c 84 90 ff 	vpbroadcastq -0x6f7b84(%rip),%xmm12        # 578490 <x86_effects_unknown+0x1a90>
  c70014:	62 b2 7d 48 8f d5    	vpshufbitqmb %zmm21,%zmm0,%k2
  c7001a:	c5 f9 6f 05 1e 28 8e ff 	vmovdqa -0x71d7e2(%rip),%xmm0        # 552840 <x86_disassembly_listing.hex+0xd50>
  c70022:	62 f2 7d 48 55 d2    	vpopcntd %zmm2,%zmm2
  c70028:	62 f2 7d ca 63 e4    	vpcompressb %zmm4,%zmm4{%k2}{z}
  c7002e:	62 f1 fe 48 7f 32    	vmovdqu64 %zmm6,(%rdx)
  c70034:	62 b1 fe 48 7f 2c 32 	vmovdqu64 %zmm5,(%rdx,%r14,1)
  c7003b:	c5 d1 ef ed          	vpxor  %xmm5,%xmm5,%xmm5
  c7003f:	62 f2 7d cb 63 dd    	vpcompressb %zmm3,%zmm5{%k3}{z}
  c70045:	49 01 d6             	add    %rdx,%r14
  c70048:	29 da                	sub    %ebx,%edx
  c7004a:	62 f2 7d 48 5a 35 1c 28 8e ff 	vbroadcasti32x4 -0x71d7e4(%rip),%zmm6        # 552870 <x86_disassembly_listing.hex+0xd80>
  c70054:	62 f1 fd 48 6f d8    	vmovdqa64 %zmm0,%zmm3
  c7005a:	62 f2 7d 48 58 05 a4 8b 90 ff 	vpbroadcastd -0x6f745c(%rip),%zmm0        # 578c08 <x86_break_instruction.legacy_forms+0x690>
  c70064:	62 91 fe 48 7f 2c 37 	vmovdqu64 %zmm5,(%r15,%r14,1)
  c7006b:	4d 01 fe             	add    %r15,%r14
  c7006e:	c4 61 fb 93 fb       	kmovq  %k3,%r15
  c70073:	62 f1 fd 48 6f 2d 03 ac 7a ff 	vmovdqa64 -0x8553fd(%rip),%zmm5        # 41ac80 <parallel_test_signals_kept.signals+0x3d80>
  c7007d:	f3 4d 0f b8 ff       	popcnt %r15,%r15
  c70082:	62 91 fe 48 7f 24 37 	vmovdqu64 %zmm4,(%r15,%r14,1)
  c70089:	89 94 24 00 01 00 00 	mov    %edx,0x100(%rsp)
  c70090:	c4 e1 fb 93 d2       	kmovq  %k2,%rdx
  c70095:	f3 48 0f b8 d2       	popcnt %rdx,%rdx
  c7009a:	62 72 7d 48 58 5c 24 40 	vpbroadcastd 0x100(%rsp),%zmm11
  c700a2:	4c 01 fa             	add    %r15,%rdx
  c700a5:	4c 01 f2             	add    %r14,%rdx
  c700a8:	62 f1 5d 40 db e0    	vpandd %zmm0,%zmm20,%zmm4
  c700ae:	c5 f9 6f 05 aa 27 8e ff 	vmovdqa -0x71d856(%rip),%xmm0        # 552860 <x86_disassembly_listing.hex+0xd70>
  c700b6:	62 f1 75 48 fe cc    	vpaddd %zmm4,%zmm1,%zmm1
  c700bc:	c5 f9 6f 25 8c 27 8e ff 	vmovdqa -0x71d874(%rip),%xmm4        # 552850 <x86_disassembly_listing.hex+0xd60>
  c700c4:	62 f1 75 48 fe ca    	vpaddd %zmm2,%zmm1,%zmm1
  c700ca:	62 f2 65 48 8d c9    	vpermb %zmm1,%zmm3,%zmm1
  c700d0:	62 d2 f5 08 40 d4    	vpmullq %xmm12,%xmm1,%xmm2
  c700d6:	62 f1 fd 48 6f d8    	vmovdqa64 %zmm0,%zmm3
  c700dc:	62 d2 65 48 8d de    	vpermb %zmm14,%zmm3,%zmm3
  c700e2:	c4 e2 69 00 e4       	vpshufb %xmm4,%xmm2,%xmm4
  c700e7:	c5 d9 fc d2          	vpaddb %xmm2,%xmm4,%xmm2
  c700eb:	62 f2 7e 48 29 db    	vpmovb2m %zmm3,%k3
  c700f1:	62 f1 fd 48 6f 1d 45 ab 7a ff 	vmovdqa64 -0x8554bb(%rip),%zmm3        # 41ac40 <parallel_test_signals_kept.signals+0x3d40>
  c700fb:	c5 e9 f8 c9          	vpsubb %xmm1,%xmm2,%xmm1
  c700ff:	62 f2 7d 48 31 c2    	vpmovzxbd %xmm2,%zmm0
  c70105:	c5 7b 93 f3          	kmovd  %k3,%r14d
  c70109:	62 f2 7d 48 31 c9    	vpmovzxbd %xmm1,%zmm1
  c7010f:	45 0f b7 f6          	movzwl %r14w,%r14d
  c70113:	f3 45 0f b8 f6       	popcnt %r14d,%r14d
  c70118:	62 f1 25 48 fe c9    	vpaddd %zmm1,%zmm11,%zmm1
  c7011e:	62 b1 fe 48 7f 0c 19 	vmovdqu64 %zmm1,(%rcx,%r11,1)
  c70125:	62 f1 25 48 fe c8    	vpaddd %zmm0,%zmm11,%zmm1
  c7012b:	49 83 c3 40          	add    $0x40,%r11
  c7012f:	62 f2 7d cb 8b c9    	vpcompressd %zmm1,%zmm1{%k3}{z}
  c70135:	62 d1 fe 48 7f 08    	vmovdqu64 %zmm1,(%r8)
  c7013b:	4f 8d 04 b0          	lea    (%r8,%r14,4),%r8
  c7013f:	49 83 fa c0          	cmp    $0xffffffffffffffc0,%r10
  c70143:	0f 85 67 f9 ff ff    	jne    c6fab0 <x86_encode_64+0x1410>
  c70149:	49 89 c3             	mov    %rax,%r11
  c7014c:	4d 29 d3             	sub    %r10,%r11
  c7014f:	4d 8d 73 40          	lea    0x40(%r11),%r14
  c70153:	49 39 f6             	cmp    %rsi,%r14
  c70156:	0f 86 44 f9 ff ff    	jbe    c6faa0 <x86_encode_64+0x1400>
  c7015c:	4c 29 d0             	sub    %r10,%rax
  c7015f:	4c 8d 48 10          	lea    0x10(%rax),%r9
  c70163:	49 39 f1             	cmp    %rsi,%r9
  c70166:	0f 86 8e e5 ff ff    	jbe    c6e6fa <x86_encode_64+0x5a>
  c7016c:	49 89 d6             	mov    %rdx,%r14
  c7016f:	49 89 c7             	mov    %rax,%r15
  c70172:	4c 29 fe             	sub    %r15,%rsi
  c70175:	0f 86 9d 34 00 00    	jbe    c73618 <x86_encode_64+0x4f78>
  c7017b:	4c 89 f8             	mov    %r15,%rax
  c7017e:	48 c1 e0 04          	shl    $0x4,%rax
  c70182:	48 89 f2             	mov    %rsi,%rdx
  c70185:	48 c1 e2 04          	shl    $0x4,%rdx
  c70189:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
  c7018d:	62 f1 fd 48 7f 44 24 07 	vmovdqa64 %zmm0,0x1c0(%rsp)
  c70195:	62 f1 fd 48 7f 44 24 06 	vmovdqa64 %zmm0,0x180(%rsp)
  c7019d:	62 f1 fd 48 7f 44 24 05 	vmovdqa64 %zmm0,0x140(%rsp)
  c701a5:	62 f1 fd 48 7f 44 24 04 	vmovdqa64 %zmm0,0x100(%rsp)
  c701ad:	49 89 f4             	mov    %rsi,%r12
  c701b0:	4c 89 04 24          	mov    %r8,(%rsp)
  c701b4:	49 89 cd             	mov    %rcx,%r13
  c701b7:	48 01 c7             	add    %rax,%rdi
  c701ba:	48 8d 84 24 00 01 00 00 	lea    0x100(%rsp),%rax
  c701c2:	49 89 f9             	mov    %rdi,%r9
  c701c5:	48 89 c7             	mov    %rax,%rdi
  c701c8:	4c 89 ce             	mov    %r9,%rsi
  c701cb:	c5 f8 77             	vzeroupper
  c701ce:	e8 7d 42 af ff       	call   764450 <memcpy@plt>
  c701d3:	c5 f9 6f 8c 24 00 01 00 00 	vmovdqa 0x100(%rsp),%xmm1
  c701dc:	c5 f9 6f 94 24 10 01 00 00 	vmovdqa 0x110(%rsp),%xmm2
  c701e5:	c5 f9 6f a4 24 20 01 00 00 	vmovdqa 0x120(%rsp),%xmm4
  c701ee:	c5 f9 6f ac 24 30 01 00 00 	vmovdqa 0x130(%rsp),%xmm5
  c701f7:	48 8d 05 82 21 13 02 	lea    0x2132182(%rip),%rax        # 2da2380 <x86_template_storage>
  c701fe:	62 71 fd 48 6f 3d f8 a9 7a ff 	vmovdqa64 -0x855608(%rip),%zmm15        # 41ac00 <parallel_test_signals_kept.signals+0x3d00>
  c70208:	c5 79 6f 8c 24 80 01 00 00 	vmovdqa 0x180(%rsp),%xmm9
  c70211:	c5 f9 6f bc 24 90 01 00 00 	vmovdqa 0x190(%rsp),%xmm7
  c7021a:	62 f1 fd 48 6f 5c 24 04 	vmovdqa64 0x100(%rsp),%zmm3
  c70222:	62 71 fd 48 6f 44 24 05 	vmovdqa64 0x140(%rsp),%zmm8
  c7022a:	62 71 fd 48 6f 5c 24 06 	vmovdqa64 0x180(%rsp),%zmm11
  c70232:	62 71 fd 48 6f 64 24 07 	vmovdqa64 0x1c0(%rsp),%zmm12
  c7023a:	62 e2 7d 48 5a 0d 4c 26 8e ff 	vbroadcasti32x4 -0x71d9b4(%rip),%zmm17        # 552890 <x86_disassembly_listing.hex+0xda0>
  c70244:	62 a3 4d 40 25 f6 ff 	vpternlogd $0xff,%zmm22,%zmm22,%zmm22
  c7024b:	62 e2 7d 48 58 2d 57 89 90 ff 	vpbroadcastd -0x6f76a9(%rip),%zmm21        # 578bac <x86_break_instruction.legacy_forms+0x634>
  c70255:	62 62 7d 48 58 1d 59 89 90 ff 	vpbroadcastd -0x6f76a7(%rip),%zmm27        # 578bb8 <x86_break_instruction.legacy_forms+0x640>
  c7025f:	62 62 7d 48 58 0d 53 89 90 ff 	vpbroadcastd -0x6f76ad(%rip),%zmm25        # 578bbc <x86_break_instruction.legacy_forms+0x644>
  c70269:	c5 f9 c5 c9 06       	vpextrw $0x6,%xmm1,%ecx
  c7026e:	c5 f9 c5 d2 06       	vpextrw $0x6,%xmm2,%edx
  c70273:	c5 f9 c5 f4 06       	vpextrw $0x6,%xmm4,%esi
  c70278:	c5 f9 c5 fd 06       	vpextrw $0x6,%xmm5,%edi
  c7027d:	62 51 65 48 62 e8    	vpunpckldq %zmm8,%zmm3,%zmm13
  c70283:	62 51 25 48 62 f4    	vpunpckldq %zmm12,%zmm11,%zmm14
  c70289:	62 d1 65 48 6a d8    	vpunpckhdq %zmm8,%zmm3,%zmm3
  c7028f:	62 51 25 48 6a c4    	vpunpckhdq %zmm12,%zmm11,%zmm8
  c70295:	c1 e1 06             	shl    $0x6,%ecx
  c70298:	c1 e2 06             	shl    $0x6,%edx
  c7029b:	c1 e6 06             	shl    $0x6,%esi
  c7029e:	c1 e7 06             	shl    $0x6,%edi
  c702a1:	62 51 95 48 6d de    	vpunpckhqdq %zmm14,%zmm13,%zmm11
  c702a7:	62 d1 95 48 6c c6    	vpunpcklqdq %zmm14,%zmm13,%zmm0
  c702ad:	62 51 e5 48 6c f0    	vpunpcklqdq %zmm8,%zmm3,%zmm14
  c702b3:	62 d1 e5 48 6d d8    	vpunpckhqdq %zmm8,%zmm3,%zmm3
  c702b9:	c5 fd 6f 4c 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm1
  c702bf:	c5 fd 6f 54 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm2
  c702c5:	b1 cc                	mov    $0xcc,%cl
  c702c7:	62 d1 15 48 72 d6 1a 	vpsrld $0x1a,%zmm14,%zmm13
  c702ce:	62 e2 15 48 36 25 a8 a9 7a ff 	vpermd -0x855658(%rip),%zmm13,%zmm20        # 41ac80 <parallel_test_signals_kept.signals+0x3d80>
  c702d8:	62 d2 25 48 27 c3    	vptestmd %zmm11,%zmm11,%k0
  c702de:	62 d1 65 40 72 e3 1f 	vpsrad $0x1f,%zmm11,%zmm19
  c702e5:	62 21 25 48 fe c6    	vpaddd %zmm22,%zmm11,%zmm24
  c702eb:	62 43 55 40 25 ce 6c 	vpternlogd $0x6c,%zmm14,%zmm21,%zmm25
  c702f2:	62 f3 f5 48 3a 4c 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm1,%zmm1
  c702fb:	62 f3 ed 48 3a 64 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm2,%zmm4
  c70304:	c5 fb 92 c9          	kmovd  %ecx,%k1
  c70308:	62 f2 f5 49 64 d4    	vpblendmq %zmm4,%zmm1,%zmm2{%k1}
  c7030e:	62 f2 85 48 7e cc    	vpermt2q %zmm4,%zmm15,%zmm1
  c70314:	c5 f9 6f a4 24 40 01 00 00 	vmovdqa 0x140(%rsp),%xmm4
  c7031d:	c5 f9 c5 cc 06       	vpextrw $0x6,%xmm4,%ecx
  c70322:	c5 f9 6f a4 24 50 01 00 00 	vmovdqa 0x150(%rsp),%xmm4
  c7032b:	c1 e1 06             	shl    $0x6,%ecx
  c7032e:	c5 f9 c5 d4 06       	vpextrw $0x6,%xmm4,%edx
  c70333:	c5 f9 6f a4 24 60 01 00 00 	vmovdqa 0x160(%rsp),%xmm4
  c7033c:	c1 e2 06             	shl    $0x6,%edx
  c7033f:	c5 fd 6f 6c 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm5
  c70345:	c5 f9 c5 d7 06       	vpextrw $0x6,%xmm7,%edx
  c7034a:	c5 f9 6f bc 24 b0 01 00 00 	vmovdqa 0x1b0(%rsp),%xmm7
  c70353:	c1 e2 06             	shl    $0x6,%edx
  c70356:	c5 f9 c5 f4 06       	vpextrw $0x6,%xmm4,%esi
  c7035b:	c5 f9 6f a4 24 70 01 00 00 	vmovdqa 0x170(%rsp),%xmm4
  c70364:	c1 e6 06             	shl    $0x6,%esi
  c70367:	c5 f9 c5 fc 06       	vpextrw $0x6,%xmm4,%edi
  c7036c:	c5 fd 6f 64 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm4
  c70372:	c4 c1 79 c5 c9 06    	vpextrw $0x6,%xmm9,%ecx
  c70378:	c5 79 6f 8c 24 a0 01 00 00 	vmovdqa 0x1a0(%rsp),%xmm9
  c70381:	c1 e7 06             	shl    $0x6,%edi
  c70384:	62 f3 dd 48 3a 64 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm4,%zmm4
  c7038d:	c1 e1 06             	shl    $0x6,%ecx
  c70390:	62 f3 d5 48 3a 74 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm5,%zmm6
  c70399:	c5 f9 c5 ff 06       	vpextrw $0x6,%xmm7,%edi
  c7039e:	c5 fd 6f 7c 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm7
  c703a4:	0f b7 94 24 dc 01 00 00 	movzwl 0x1dc(%rsp),%edx
  c703ac:	c1 e7 06             	shl    $0x6,%edi
  c703af:	c1 e2 06             	shl    $0x6,%edx
  c703b2:	c4 c1 79 c5 f1 06    	vpextrw $0x6,%xmm9,%esi
  c703b8:	62 73 c5 48 3a 4c 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm7,%zmm9
  c703c1:	0f b7 bc 24 fc 01 00 00 	movzwl 0x1fc(%rsp),%edi
  c703c9:	c5 7d 6f 54 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm10
  c703cf:	c1 e6 06             	shl    $0x6,%esi
  c703d2:	62 f2 dd 49 64 ee    	vpblendmq %zmm6,%zmm4,%zmm5{%k1}
  c703d8:	62 f2 85 48 7e e6    	vpermt2q %zmm6,%zmm15,%zmm4
  c703de:	c5 fd 6f 74 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm6
  c703e4:	0f b7 8c 24 cc 01 00 00 	movzwl 0x1cc(%rsp),%ecx
  c703ec:	62 f3 cd 48 3a 74 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm6,%zmm6
  c703f5:	0f b7 b4 24 ec 01 00 00 	movzwl 0x1ec(%rsp),%esi
  c703fd:	62 71 6d 48 6a c5    	vpunpckhdq %zmm5,%zmm2,%zmm8
  c70403:	c1 e7 06             	shl    $0x6,%edi
  c70406:	62 e3 ad 48 3a 44 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm10,%zmm16
  c7040f:	c1 e1 06             	shl    $0x6,%ecx
  c70412:	c1 e6 06             	shl    $0x6,%esi
  c70415:	62 d2 cd 49 64 f9    	vpblendmq %zmm9,%zmm6,%zmm7{%k1}
  c7041b:	62 d2 85 48 7e f1    	vpermt2q %zmm9,%zmm15,%zmm6
  c70421:	c5 7d 6f 4c 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm9
  c70427:	62 73 b5 48 3a 4c 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm9,%zmm9
  c70430:	62 32 b5 49 64 d0    	vpblendmq %zmm16,%zmm9,%zmm10{%k1}
  c70436:	62 32 85 48 7e c8    	vpermt2q %zmm16,%zmm15,%zmm9
  c7043c:	62 e2 7d 48 5a 05 2a 24 8e ff 	vbroadcasti32x4 -0x71dbd6(%rip),%zmm16        # 552870 <x86_disassembly_listing.hex+0xd80>
  c70446:	62 72 15 48 36 3d f0 a7 7a ff 	vpermd -0x855810(%rip),%zmm13,%zmm15        # 41ac40 <parallel_test_signals_kept.signals+0x3d40>
  c70450:	62 72 15 48 36 2d 66 a8 7a ff 	vpermd -0x85579a(%rip),%zmm13,%zmm13        # 41acc0 <parallel_test_signals_kept.signals+0x3dc0>
  c7045a:	62 51 45 48 6a e2    	vpunpckhdq %zmm10,%zmm7,%zmm12
  c70460:	62 51 bd 48 6d c4    	vpunpckhqdq %zmm12,%zmm8,%zmm8
  c70466:	62 d1 45 40 72 d0 1d 	vpsrld $0x1d,%zmm8,%zmm23
  c7046d:	62 52 fd 40 83 e6    	vpmultishiftqb %zmm14,%zmm16,%zmm12
  c70473:	62 e2 7d 48 5a 05 03 24 8e ff 	vbroadcasti32x4 -0x71dbfd(%rip),%zmm16        # 552880 <x86_disassembly_listing.hex+0xd90>
  c7047d:	62 c2 fd 40 83 c6    	vpmultishiftqb %zmm14,%zmm16,%zmm16
  c70483:	62 e3 1d 58 25 05 16 87 90 ff d8 	vpternlogd $0xd8,-0x6f78ea(%rip){1to16},%zmm12,%zmm16        # 578ba4 <x86_break_instruction.legacy_forms+0x62c>
  c7048e:	62 52 f5 40 83 e6    	vpmultishiftqb %zmm14,%zmm17,%zmm12
  c70494:	62 e2 7d 48 5a 0d 02 24 8e ff 	vbroadcasti32x4 -0x71dbfe(%rip),%zmm17        # 5528a0 <x86_disassembly_listing.hex+0xdb0>
  c7049e:	62 73 7d 50 25 25 ff 86 90 ff e4 	vpternlogd $0xe4,-0x6f7901(%rip){1to16},%zmm16,%zmm12        # 578ba8 <x86_break_instruction.legacy_forms+0x630>
  c704a9:	62 c2 75 40 00 ce    	vpshufb %zmm14,%zmm17,%zmm17
  c704af:	62 d1 7d 40 72 f6 04 	vpslld $0x4,%zmm14,%zmm16
  c704b6:	62 b1 7d 40 72 e0 1f 	vpsrad $0x1f,%zmm16,%zmm16
  c704bd:	62 c3 1d 48 25 e7 f8 	vpternlogd $0xf8,%zmm15,%zmm12,%zmm20
  c704c4:	62 b1 05 48 72 f1 10 	vpslld $0x10,%zmm17,%zmm15
  c704cb:	62 a1 7d 40 db c9    	vpandd %zmm17,%zmm16,%zmm17
  c704d1:	62 e3 15 58 25 0d 18 87 90 ff ec 	vpternlogd $0xec,-0x6f78e8(%rip){1to16},%zmm13,%zmm17        # 578bf4 <x86_break_instruction.legacy_forms+0x67c>
  c704dc:	62 d1 6d 40 72 e7 1f 	vpsrad $0x1f,%zmm15,%zmm18
  c704e3:	62 72 7e 48 38 f8    	vpmovm2d %k0,%zmm15
  c704e9:	62 23 7d 40 25 dc ea 	vpternlogd $0xea,%zmm20,%zmm16,%zmm27
  c704f0:	62 b1 2d 40 72 d4 10 	vpsrld $0x10,%zmm20,%zmm26
  c704f7:	62 e3 3d 58 25 0d f6 86 90 ff f8 	vpternlogd $0xf8,-0x6f790a(%rip){1to16},%zmm8,%zmm17        # 578bf8 <x86_break_instruction.legacy_forms+0x680>
  c70502:	62 33 7d 40 25 fa c8 	vpternlogd $0xc8,%zmm18,%zmm16,%zmm15
  c70509:	62 c1 65 40 ef d3    	vpxord %zmm11,%zmm19,%zmm18
  c7050f:	62 e2 7d 48 58 1d 97 86 90 ff 	vpbroadcastd -0x6f7969(%rip),%zmm19        # 578bb0 <x86_break_instruction.legacy_forms+0x638>
  c70519:	62 71 05 58 db 2d d9 86 90 ff 	vpandd -0x6f7927(%rip){1to16},%zmm15,%zmm13        # 578bfc <x86_break_instruction.legacy_forms+0x684>
  c70523:	62 e1 7d 50 db 05 d3 86 90 ff 	vpandd -0x6f792d(%rip){1to16},%zmm16,%zmm16        # 578c00 <x86_break_instruction.legacy_forms+0x688>
  c7052d:	62 a2 7d 48 44 d2    	vplzcntd %zmm18,%zmm18
  c70533:	62 a2 65 40 45 d2    	vpsrlvd %zmm18,%zmm19,%zmm18
  c70539:	62 23 25 48 25 c2 14 	vpternlogd $0x14,%zmm18,%zmm11,%zmm24
  c70540:	62 a2 3d 40 14 d7    	vprorvd %zmm23,%zmm24,%zmm18
  c70546:	62 62 7d 48 58 05 64 86 90 ff 	vpbroadcastd -0x6f799c(%rip),%zmm24        # 578bb4 <x86_break_instruction.legacy_forms+0x63c>
  c70550:	62 b1 6d 40 72 e2 1f 	vpsrad $0x1f,%zmm18,%zmm18
  c70557:	62 c3 6d 40 25 c5 b8 	vpternlogd $0xb8,%zmm13,%zmm18,%zmm16
  c7055e:	62 23 05 48 25 c4 ea 	vpternlogd $0xea,%zmm20,%zmm15,%zmm24
  c70565:	62 b1 5d 40 72 d4 03 	vpsrld $0x3,%zmm20,%zmm20
  c7056c:	62 e3 2d 50 25 25 61 86 90 ff ec 	vpternlogd $0xec,-0x6f799f(%rip){1to16},%zmm26,%zmm20        # 578bd8 <x86_break_instruction.legacy_forms+0x660>
  c70577:	62 03 6d 40 25 d8 b8 	vpternlogd $0xb8,%zmm24,%zmm18,%zmm27
  c7057e:	62 21 35 40 fe c6    	vpaddd %zmm22,%zmm25,%zmm24
  c70584:	62 d1 35 40 72 d6 08 	vpsrld $0x8,%zmm14,%zmm25
  c7058b:	62 63 55 50 25 0d 2a 86 90 ff 6c 	vpternlogd $0x6c,-0x6f79d6(%rip){1to16},%zmm21,%zmm25        # 578bc0 <x86_break_instruction.legacy_forms+0x648>
  c70596:	62 51 65 48 eb f6    	vpord  %zmm14,%zmm3,%zmm14
  c7059c:	62 d1 0d 48 72 f6 07 	vpslld $0x7,%zmm14,%zmm14
  c705a3:	62 a1 35 40 fe ee    	vpaddd %zmm22,%zmm25,%zmm21
  c705a9:	62 62 7d 48 58 0d 11 86 90 ff 	vpbroadcastd -0x6f79ef(%rip),%zmm25        # 578bc4 <x86_break_instruction.legacy_forms+0x64c>
  c705b3:	62 63 3d 50 25 0d 0a 86 90 ff ea 	vpternlogd $0xea,-0x6f79f6(%rip){1to16},%zmm24,%zmm25        # 578bc8 <x86_break_instruction.legacy_forms+0x650>
  c705be:	62 b1 3d 40 72 f4 08 	vpslld $0x8,%zmm20,%zmm24
  c705c5:	62 63 55 50 25 0d fc 85 90 ff f8 	vpternlogd $0xf8,-0x6f7a04(%rip){1to16},%zmm21,%zmm25        # 578bcc <x86_break_instruction.legacy_forms+0x654>
  c705d0:	62 e1 1d 58 db 2d f6 85 90 ff 	vpandd -0x6f7a0a(%rip){1to16},%zmm12,%zmm21        # 578bd0 <x86_break_instruction.legacy_forms+0x658>
  c705da:	62 83 3d 48 25 e9 f8 	vpternlogd $0xf8,%zmm25,%zmm8,%zmm21
  c705e1:	62 d1 35 40 72 d4 03 	vpsrld $0x3,%zmm12,%zmm25
  c705e8:	62 63 3d 58 25 0d e9 85 90 ff a2 	vpternlogd $0xa2,-0x6f7a17(%rip){1to16},%zmm8,%zmm25        # 578bdc <x86_break_instruction.legacy_forms+0x664>
  c705f3:	62 e2 55 50 3b 2d d7 85 90 ff 	vpminud -0x6f7a29(%rip){1to16},%zmm21,%zmm21        # 578bd4 <x86_break_instruction.legacy_forms+0x65c>
  c705fd:	62 31 35 40 fe e6    	vpaddd %zmm22,%zmm25,%zmm12
  c70603:	62 e2 35 50 3b 35 d3 85 90 ff 	vpminud -0x6f7a2d(%rip){1to16},%zmm25,%zmm22        # 578be0 <x86_break_instruction.legacy_forms+0x668>
  c7060d:	62 62 7d 48 5a 0d 99 22 8e ff 	vbroadcasti32x4 -0x71dd67(%rip),%zmm25        # 5528b0 <x86_disassembly_listing.hex+0xdc0>
  c70617:	62 d1 1d 48 72 e4 1f 	vpsrad $0x1f,%zmm12,%zmm12
  c7061e:	62 63 1d 58 25 05 bb 85 90 ff 08 	vpternlogd $0x8,-0x6f7a45(%rip){1to16},%zmm12,%zmm24        # 578be4 <x86_break_instruction.legacy_forms+0x66c>
  c70629:	62 62 b5 40 83 cb    	vpmultishiftqb %zmm3,%zmm25,%zmm25
  c7062f:	62 63 5d 50 25 0d b2 85 90 ff d8 	vpternlogd $0xd8,-0x6f7a4e(%rip){1to16},%zmm20,%zmm25        # 578bec <x86_break_instruction.legacy_forms+0x674>
  c7063a:	62 a3 4d 40 25 cd fe 	vpternlogd $0xfe,%zmm21,%zmm22,%zmm17
  c70641:	62 31 7d 40 eb e9    	vpord  %zmm17,%zmm16,%zmm13
  c70647:	62 d1 7d 40 72 cb 01 	vprold $0x1,%zmm11,%zmm16
  c7064e:	62 73 3d 50 25 35 8f 85 90 ff e4 	vpternlogd $0xe4,-0x6f7a71(%rip){1to16},%zmm24,%zmm14        # 578be8 <x86_break_instruction.legacy_forms+0x670>
  c70659:	62 63 0d 58 25 0d 8c 85 90 ff d8 	vpternlogd $0xd8,-0x6f7a74(%rip){1to16},%zmm14,%zmm25        # 578bf0 <x86_break_instruction.legacy_forms+0x678>
  c70664:	62 32 7d 40 14 f7    	vprorvd %zmm23,%zmm16,%zmm14
  c7066a:	62 53 05 48 25 f3 e2 	vpternlogd $0xe2,%zmm11,%zmm15,%zmm14
  c70671:	62 53 6d 40 25 f3 e2 	vpternlogd $0xe2,%zmm11,%zmm18,%zmm14
  c70678:	62 c1 7d 48 70 d5 00 	vpshufd $0x0,%zmm13,%zmm18
  c7067f:	62 51 7d 48 62 de    	vpunpckldq %zmm14,%zmm0,%zmm11
  c70685:	62 f2 6d 40 8f c9    	vpshufbitqmb %zmm1,%zmm18,%k1
  c7068b:	62 d1 7d 48 6a c6    	vpunpckhdq %zmm14,%zmm0,%zmm0
  c70691:	c4 e1 fb 93 c1       	kmovq  %k1,%rax
  c70696:	62 81 25 40 62 c9    	vpunpckldq %zmm25,%zmm27,%zmm17
  c7069c:	62 11 25 40 6a f9    	vpunpckhdq %zmm25,%zmm27,%zmm15
  c706a2:	f3 48 0f b8 c0       	popcnt %rax,%rax
  c706a7:	62 a1 a5 48 6c c1    	vpunpcklqdq %zmm17,%zmm11,%zmm16
  c706ad:	62 31 a5 48 6d d9    	vpunpckhqdq %zmm17,%zmm11,%zmm11
  c706b3:	62 e2 7d 48 5a 0d 73 21 8e ff 	vbroadcasti32x4 -0x71de8d(%rip),%zmm17        # 552830 <x86_disassembly_listing.hex+0xd40>
  c706bd:	62 c1 fd 48 6c df    	vpunpcklqdq %zmm15,%zmm0,%zmm19
  c706c3:	62 d1 fd 48 6d c7    	vpunpckhqdq %zmm15,%zmm0,%zmm0
  c706c9:	62 51 7d 48 70 fd 55 	vpshufd $0x55,%zmm13,%zmm15
  c706d0:	49 8d 0c 06          	lea    (%r14,%rax,1),%rcx
  c706d4:	62 e2 7d 40 00 c1    	vpshufb %zmm1,%zmm16,%zmm16
  c706da:	62 d2 7d 48 00 c1    	vpshufb %zmm9,%zmm0,%zmm0
  c706e0:	62 a3 ed 48 25 c1 78 	vpternlogq $0x78,%zmm17,%zmm2,%zmm16
  c706e7:	62 f2 25 48 00 d4    	vpshufb %zmm4,%zmm11,%zmm2
  c706ed:	62 b3 ad 48 25 c1 78 	vpternlogq $0x78,%zmm17,%zmm10,%zmm0
  c706f4:	62 e2 7d c9 63 c1    	vpcompressb %zmm16,%zmm1{%k1}{z}
  c706fa:	62 f2 05 48 8f cc    	vpshufbitqmb %zmm4,%zmm15,%k1
  c70700:	62 b3 d5 48 25 d1 78 	vpternlogq $0x78,%zmm17,%zmm5,%zmm2
  c70707:	62 d1 7d 48 70 ed aa 	vpshufd $0xaa,%zmm13,%zmm5
  c7070e:	c4 e1 fb 93 d1       	kmovq  %k1,%rdx
  c70713:	f3 48 0f b8 d2       	popcnt %rdx,%rdx
  c70718:	62 d1 fe 48 7f 0e    	vmovdqu64 %zmm1,(%r14)
  c7071e:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
  c70722:	62 f2 7d c9 63 d1    	vpcompressb %zmm2,%zmm1{%k1}{z}
  c70728:	62 f2 65 40 00 d6    	vpshufb %zmm6,%zmm19,%zmm2
  c7072e:	62 f2 55 48 8f ce    	vpshufbitqmb %zmm6,%zmm5,%k1
  c70734:	62 d1 7d 48 70 f5 ff 	vpshufd $0xff,%zmm13,%zmm6
  c7073b:	62 73 3d 58 25 2d be 84 90 ff 20 	vpternlogd $0x20,-0x6f7b42(%rip){1to16},%zmm8,%zmm13        # 578c04 <x86_break_instruction.legacy_forms+0x68c>
  c70746:	62 f1 3d 58 db 2d b8 84 90 ff 	vpandd -0x6f7b48(%rip){1to16},%zmm8,%zmm5        # 578c08 <x86_break_instruction.legacy_forms+0x690>
  c70750:	48 8d 34 11          	lea    (%rcx,%rdx,1),%rsi
  c70754:	62 b3 c5 48 25 d1 78 	vpternlogq $0x78,%zmm17,%zmm7,%zmm2
  c7075b:	62 d1 fe 48 7f 0c 06 	vmovdqu64 %zmm1,(%r14,%rax,1)
  c70762:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
  c70766:	62 f2 7d c9 63 d1    	vpcompressb %zmm2,%zmm1{%k1}{z}
  c7076c:	c4 e1 fb 93 c1       	kmovq  %k1,%rax
  c70771:	62 d2 4d 48 8f c9    	vpshufbitqmb %zmm9,%zmm6,%k1
  c70777:	41 29 de             	sub    %ebx,%r14d
  c7077a:	f3 48 0f b8 f8       	popcnt %rax,%rdi
  c7077f:	62 f2 7d c9 63 c0    	vpcompressb %zmm0,%zmm0{%k1}{z}
  c70785:	c4 e1 fb 93 c1       	kmovq  %k1,%rax
  c7078a:	f3 48 0f b8 c0       	popcnt %rax,%rax
  c7078f:	62 f1 fe 48 7f 0c 0a 	vmovdqu64 %zmm1,(%rdx,%rcx,1)
  c70796:	62 f1 1d 48 fe cd    	vpaddd %zmm5,%zmm12,%zmm1
  c7079c:	48 c7 c1 ff ff ff ff 	mov    $0xffffffffffffffff,%rcx
  c707a3:	48 01 f8             	add    %rdi,%rax
  c707a6:	c4 e2 99 f7 c9       	shlx   %r12,%rcx,%rcx
  c707ab:	48 01 f0             	add    %rsi,%rax
  c707ae:	f7 d1                	not    %ecx
  c707b0:	62 f1 fe 48 7f 04 37 	vmovdqu64 %zmm0,(%rdi,%rsi,1)
  c707b7:	62 d2 7d 48 55 c5    	vpopcntd %zmm13,%zmm0
  c707bd:	44 89 b4 24 fc 00 00 00 	mov    %r14d,0xfc(%rsp)
  c707c5:	c5 fb 92 c9          	kmovd  %ecx,%k1
  c707c9:	62 f1 75 48 fe c0    	vpaddd %zmm0,%zmm1,%zmm0
  c707cf:	c5 f9 6f 0d 69 20 8e ff 	vmovdqa -0x71df97(%rip),%xmm1        # 552840 <x86_disassembly_listing.hex+0xd50>
  c707d7:	48 8b 0c 24          	mov    (%rsp),%rcx
  c707db:	62 f2 75 48 8d c0    	vpermb %zmm0,%zmm1,%zmm0
  c707e1:	62 f2 fd 18 40 15 a5 7c 90 ff 	vpmullq -0x6f835b(%rip){1to2},%xmm0,%xmm2        # 578490 <x86_effects_unknown+0x1a90>
  c707eb:	62 f2 7d 48 58 4c 24 3f 	vpbroadcastd 0xfc(%rsp),%zmm1
  c707f3:	c4 e2 69 00 25 54 20 8e ff 	vpshufb -0x71dfac(%rip),%xmm2,%xmm4        # 552850 <x86_disassembly_listing.hex+0xd60>
  c707fc:	c5 d9 fc d2          	vpaddb %xmm2,%xmm4,%xmm2
  c70800:	c5 e9 f8 c0          	vpsubb %xmm0,%xmm2,%xmm0
  c70804:	62 f2 7d 48 31 d2    	vpmovzxbd %xmm2,%zmm2
  c7080a:	62 f2 7d 48 31 c0    	vpmovzxbd %xmm0,%zmm0
  c70810:	62 f1 75 48 fe c0    	vpaddd %zmm0,%zmm1,%zmm0
  c70816:	62 91 7e 49 7f 44 bd 00 	vmovdqu32 %zmm0,0x0(%r13,%r15,4){%k1}
  c7081e:	c5 f9 6f 05 3a 20 8e ff 	vmovdqa -0x71dfc6(%rip),%xmm0        # 552860 <x86_disassembly_listing.hex+0xd70>
  c70826:	62 f2 7d 48 8d c3    	vpermb %zmm3,%zmm0,%zmm0
  c7082c:	62 f2 7e 48 29 c8    	vpmovb2m %zmm0,%k1
  c70832:	62 f1 75 48 fe c2    	vpaddd %zmm2,%zmm1,%zmm0
  c70838:	62 f2 7d c9 8b c0    	vpcompressd %zmm0,%zmm0{%k1}{z}
  c7083e:	62 f1 fe 48 7f 01    	vmovdqu64 %zmm0,(%rcx)
  c70844:	e9 5f 13 00 00       	jmp    c71ba8 <x86_encode_64+0x3508>
  c70849:	48 83 fe 40          	cmp    $0x40,%rsi
  c7084d:	0f 83 3f 21 00 00    	jae    c72992 <x86_encode_64+0x42f2>
  c70853:	31 c0                	xor    %eax,%eax
  c70855:	49 89 de             	mov    %rbx,%r14
  c70858:	48 8d 48 10          	lea    0x10(%rax),%rcx
  c7085c:	48 39 f1             	cmp    %rsi,%rcx
  c7085f:	0f 87 a6 27 00 00    	ja     c7300b <x86_encode_64+0x496b>
  c70865:	62 f2 7d 48 5a 1d c1 1f 8e ff 	vbroadcasti32x4 -0x71e03f(%rip),%zmm3        # 552830 <x86_disassembly_listing.hex+0xd40>
  c7086f:	62 72 7d 48 58 0d 4f 83 90 ff 	vpbroadcastd -0x6f7cb1(%rip),%zmm9        # 578bc8 <x86_break_instruction.legacy_forms+0x650>
  c70879:	48 89 c1             	mov    %rax,%rcx
  c7087c:	48 c1 e1 04          	shl    $0x4,%rcx
  c70880:	41 b0 cc             	mov    $0xcc,%r8b
  c70883:	48 8d 15 f6 1a 13 02 	lea    0x2131af6(%rip),%rdx        # 2da2380 <x86_template_storage>
  c7088a:	62 53 1d 48 25 e4 ff 	vpternlogd $0xff,%zmm12,%zmm12,%zmm12
  c70891:	48 8d 8c 39 fc 00 00 00 	lea    0xfc(%rcx,%rdi,1),%rcx
  c70899:	c4 c1 7b 92 c8       	kmovd  %r8d,%k1
  c7089e:	66 90                	xchg   %ax,%ax
  c708a0:	44 0f b7 81 10 ff ff ff 	movzwl -0xf0(%rcx),%r8d
  c708a8:	44 0f b7 89 20 ff ff ff 	movzwl -0xe0(%rcx),%r9d
  c708b0:	44 0f b7 91 30 ff ff ff 	movzwl -0xd0(%rcx),%r10d
  c708b8:	44 0f b7 99 40 ff ff ff 	movzwl -0xc0(%rcx),%r11d
  c708c0:	62 e1 fe 48 6f 99 04 ff ff ff 	vmovdqu64 -0xfc(%rcx),%zmm19
  c708ca:	62 e1 fe 48 6f a9 44 ff ff ff 	vmovdqu64 -0xbc(%rcx),%zmm21
  c708d4:	62 e1 fe 48 6f b1 84 ff ff ff 	vmovdqu64 -0x7c(%rcx),%zmm22
  c708de:	62 e1 fe 48 6f b9 c4 ff ff ff 	vmovdqu64 -0x3c(%rcx),%zmm23
  c708e8:	62 f2 7d 48 5a 0d 7e 1f 8e ff 	vbroadcasti32x4 -0x71e082(%rip),%zmm1        # 552870 <x86_disassembly_listing.hex+0xd80>
  c708f2:	41 c1 e0 06          	shl    $0x6,%r8d
  c708f6:	41 c1 e1 06          	shl    $0x6,%r9d
  c708fa:	41 c1 e2 06          	shl    $0x6,%r10d
  c708fe:	41 c1 e3 06          	shl    $0x6,%r11d
  c70902:	c4 c1 7d 6f 64 10 40 	vmovdqa 0x40(%r8,%rdx,1),%ymm4
  c70909:	44 0f b7 81 50 ff ff ff 	movzwl -0xb0(%rcx),%r8d
  c70911:	c4 c1 7d 6f 6c 11 60 	vmovdqa 0x60(%r9,%rdx,1),%ymm5
  c70918:	44 0f b7 89 60 ff ff ff 	movzwl -0xa0(%rcx),%r9d
  c70920:	62 d3 dd 48 3a 64 12 02 01 	vinserti64x4 $0x1,0x40(%r10,%rdx,1),%zmm4,%zmm4
  c70929:	62 53 d5 48 3a 7c 13 03 01 	vinserti64x4 $0x1,0x60(%r11,%rdx,1),%zmm5,%zmm15
  c70932:	44 0f b7 91 70 ff ff ff 	movzwl -0x90(%rcx),%r10d
  c7093a:	44 0f b7 59 80       	movzwl -0x80(%rcx),%r11d
  c7093f:	62 b1 65 40 62 f5    	vpunpckldq %zmm21,%zmm19,%zmm6
  c70945:	62 b1 4d 40 62 ff    	vpunpckldq %zmm23,%zmm22,%zmm7
  c7094b:	62 a1 4d 40 6a f7    	vpunpckhdq %zmm23,%zmm22,%zmm22
  c70951:	62 a1 65 40 6a ed    	vpunpckhdq %zmm21,%zmm19,%zmm21
  c70957:	62 b1 d5 40 6c d6    	vpunpcklqdq %zmm22,%zmm21,%zmm2
  c7095d:	62 e1 cd 48 6d ff    	vpunpckhqdq %zmm7,%zmm6,%zmm23
  c70963:	62 62 f5 48 83 da    	vpmultishiftqb %zmm2,%zmm1,%zmm27
  c70969:	62 f2 7d 48 5a 0d 0d 1f 8e ff 	vbroadcasti32x4 -0x71e0f3(%rip),%zmm1        # 552880 <x86_disassembly_listing.hex+0xd90>
  c70973:	62 f1 0d 40 72 d2 1a 	vpsrld $0x1a,%zmm2,%zmm30
  c7097a:	62 62 0d 40 36 15 bc a2 7a ff 	vpermd -0x855d44(%rip),%zmm30,%zmm26        # 41ac40 <parallel_test_signals_kept.signals+0x3d40>
  c70984:	62 b2 45 40 27 c7    	vptestmd %zmm23,%zmm23,%k0
  c7098a:	62 e1 fd 48 6f da    	vmovdqa64 %zmm2,%zmm19
  c70990:	41 c1 e0 06          	shl    $0x6,%r8d
  c70994:	41 c1 e1 06          	shl    $0x6,%r9d
  c70998:	c4 41 7d 6f 44 10 40 	vmovdqa 0x40(%r8,%rdx,1),%ymm8
  c7099f:	44 0f b7 41 90       	movzwl -0x70(%rcx),%r8d
  c709a4:	41 c1 e2 06          	shl    $0x6,%r10d
  c709a8:	c4 41 7d 6f 54 11 60 	vmovdqa 0x60(%r9,%rdx,1),%ymm10
  c709af:	44 0f b7 49 a0       	movzwl -0x60(%rcx),%r9d
  c709b4:	41 c1 e3 06          	shl    $0x6,%r11d
  c709b8:	62 53 bd 48 3a 44 12 02 01 	vinserti64x4 $0x1,0x40(%r10,%rdx,1),%zmm8,%zmm8
  c709c1:	62 c3 ad 48 3a 4c 13 03 01 	vinserti64x4 $0x1,0x60(%r11,%rdx,1),%zmm10,%zmm17
  c709ca:	44 0f b7 51 b0       	movzwl -0x50(%rcx),%r10d
  c709cf:	44 0f b7 59 c0       	movzwl -0x40(%rcx),%r11d
  c709d4:	62 d2 dd 49 64 ef    	vpblendmq %zmm15,%zmm4,%zmm5{%k1}
  c709da:	41 c1 e0 06          	shl    $0x6,%r8d
  c709de:	41 c1 e1 06          	shl    $0x6,%r9d
  c709e2:	c4 41 7d 6f 5c 10 40 	vmovdqa 0x40(%r8,%rdx,1),%ymm11
  c709e9:	44 0f b7 41 d0       	movzwl -0x30(%rcx),%r8d
  c709ee:	41 c1 e2 06          	shl    $0x6,%r10d
  c709f2:	c4 41 7d 6f 6c 11 60 	vmovdqa 0x60(%r9,%rdx,1),%ymm13
  c709f9:	44 0f b7 49 e0       	movzwl -0x20(%rcx),%r9d
  c709fe:	41 c1 e3 06          	shl    $0x6,%r11d
  c70a02:	62 62 f5 48 83 ea    	vpmultishiftqb %zmm2,%zmm1,%zmm29
  c70a08:	62 f2 7d 48 5a 0d 7e 1e 8e ff 	vbroadcasti32x4 -0x71e182(%rip),%zmm1        # 552890 <x86_disassembly_listing.hex+0xda0>
  c70a12:	62 63 25 50 25 2d 87 81 90 ff d8 	vpternlogd $0xd8,-0x6f7e79(%rip){1to16},%zmm27,%zmm29        # 578ba4 <x86_break_instruction.legacy_forms+0x62c>
  c70a1d:	62 53 a5 48 3a 5c 12 02 01 	vinserti64x4 $0x1,0x40(%r10,%rdx,1),%zmm11,%zmm11
  c70a26:	62 c3 95 48 3a 54 13 03 01 	vinserti64x4 $0x1,0x60(%r11,%rdx,1),%zmm13,%zmm18
  c70a2f:	44 0f b7 51 f0       	movzwl -0x10(%rcx),%r10d
  c70a34:	44 0f b7 19          	movzwl (%rcx),%r11d
  c70a38:	48 81 c1 00 01 00 00 	add    $0x100,%rcx
  c70a3f:	62 32 bd 49 64 d1    	vpblendmq %zmm17,%zmm8,%zmm10{%k1}
  c70a45:	62 41 55 48 6a c2    	vpunpckhdq %zmm10,%zmm5,%zmm24
  c70a4b:	41 c1 e0 06          	shl    $0x6,%r8d
  c70a4f:	41 c1 e1 06          	shl    $0x6,%r9d
  c70a53:	41 c1 e2 06          	shl    $0x6,%r10d
  c70a57:	c4 41 7d 6f 74 10 40 	vmovdqa 0x40(%r8,%rdx,1),%ymm14
  c70a5e:	41 c1 e3 06          	shl    $0x6,%r11d
  c70a62:	62 c1 fd 28 6f 44 11 03 	vmovdqa64 0x60(%r9,%rdx,1),%ymm16
  c70a6a:	62 53 8d 48 3a 74 12 02 01 	vinserti64x4 $0x1,0x40(%r10,%rdx,1),%zmm14,%zmm14
  c70a73:	62 c3 fd 40 3a 64 13 03 01 	vinserti64x4 $0x1,0x60(%r11,%rdx,1),%zmm16,%zmm20
  c70a7c:	62 62 f5 48 83 e2    	vpmultishiftqb %zmm2,%zmm1,%zmm28
  c70a82:	62 f1 75 48 72 f2 04 	vpslld $0x4,%zmm2,%zmm1
  c70a89:	62 63 15 50 25 25 14 81 90 ff e4 	vpternlogd $0xe4,-0x6f7eec(%rip){1to16},%zmm29,%zmm28        # 578ba8 <x86_break_instruction.legacy_forms+0x630>
  c70a94:	62 f1 25 40 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm27
  c70a9b:	62 f2 7d 48 5a 0d fb 1d 8e ff 	vbroadcasti32x4 -0x71e205(%rip),%zmm1        # 5528a0 <x86_disassembly_listing.hex+0xdb0>
  c70aa5:	62 32 a5 49 64 ea    	vpblendmq %zmm18,%zmm11,%zmm13{%k1}
  c70aab:	62 a2 8d 49 64 c4    	vpblendmq %zmm20,%zmm14,%zmm16{%k1}
  c70ab1:	62 21 15 48 6a c8    	vpunpckhdq %zmm16,%zmm13,%zmm25
  c70ab7:	62 01 bd 40 6d c9    	vpunpckhqdq %zmm25,%zmm24,%zmm25
  c70abd:	62 62 0d 40 36 05 b9 a1 7a ff 	vpermd -0x855e47(%rip),%zmm30,%zmm24        # 41ac80 <parallel_test_signals_kept.signals+0x3d80>
  c70ac7:	62 62 75 48 00 ea    	vpshufb %zmm2,%zmm1,%zmm29
  c70acd:	62 f2 7d 48 58 0d d9 80 90 ff 	vpbroadcastd -0x6f7f27(%rip),%zmm1        # 578bb0 <x86_break_instruction.legacy_forms+0x638>
  c70ad7:	62 62 0d 40 36 35 df a1 7a ff 	vpermd -0x855e21(%rip),%zmm30,%zmm30        # 41acc0 <parallel_test_signals_kept.signals+0x3dc0>
  c70ae1:	62 91 7d 48 72 f5 10 	vpslld $0x10,%zmm29,%zmm0
  c70ae8:	62 01 25 40 db ed    	vpandd %zmm29,%zmm27,%zmm29
  c70aee:	62 f1 05 40 72 e0 1f 	vpsrad $0x1f,%zmm0,%zmm31
  c70af5:	62 b1 7d 48 72 e7 1f 	vpsrad $0x1f,%zmm23,%zmm0
  c70afc:	62 03 1d 40 25 c2 f8 	vpternlogd $0xf8,%zmm26,%zmm28,%zmm24
  c70b03:	62 62 7e 48 38 d0    	vpmovm2d %k0,%zmm26
  c70b09:	62 03 25 40 25 d7 c8 	vpternlogd $0xc8,%zmm31,%zmm27,%zmm26
  c70b10:	62 21 7d 48 ef ff    	vpxord %zmm23,%zmm0,%zmm31
  c70b16:	62 f2 7d 48 58 05 8c 80 90 ff 	vpbroadcastd -0x6f7f74(%rip),%zmm0        # 578bac <x86_break_instruction.legacy_forms+0x634>
  c70b20:	62 63 0d 50 25 2d c9 80 90 ff ec 	vpternlogd $0xec,-0x6f7f37(%rip){1to16},%zmm30,%zmm29        # 578bf4 <x86_break_instruction.legacy_forms+0x67c>
  c70b2b:	62 91 0d 40 72 d1 1d 	vpsrld $0x1d,%zmm25,%zmm30
  c70b32:	62 02 7d 48 44 ff    	vplzcntd %zmm31,%zmm31
  c70b38:	62 63 35 50 25 2d b5 80 90 ff f8 	vpternlogd $0xf8,-0x6f7f4b(%rip){1to16},%zmm25,%zmm29        # 578bf8 <x86_break_instruction.legacy_forms+0x680>
  c70b43:	62 02 75 48 45 ff    	vpsrlvd %zmm31,%zmm1,%zmm31
  c70b49:	62 d1 45 40 fe cc    	vpaddd %zmm12,%zmm23,%zmm1
  c70b4f:	62 93 45 40 25 cf 14 	vpternlogd $0x14,%zmm31,%zmm23,%zmm1
  c70b56:	62 f1 05 40 72 d2 08 	vpsrld $0x8,%zmm2,%zmm31
  c70b5d:	62 92 75 48 14 ce    	vprorvd %zmm30,%zmm1,%zmm1
  c70b63:	62 f1 75 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm1
  c70b6a:	62 e3 7d 58 25 1d 47 80 90 ff 6c 	vpternlogd $0x6c,-0x6f7fb9(%rip){1to16},%zmm0,%zmm19        # 578bbc <x86_break_instruction.legacy_forms+0x644>
  c70b75:	62 63 7d 58 25 3d 40 80 90 ff 6c 	vpternlogd $0x6c,-0x6f7fc0(%rip){1to16},%zmm0,%zmm31        # 578bc0 <x86_break_instruction.legacy_forms+0x648>
  c70b80:	62 f1 1d 50 db 05 46 80 90 ff 	vpandd -0x6f7fba(%rip){1to16},%zmm28,%zmm0        # 578bd0 <x86_break_instruction.legacy_forms+0x658>
  c70b8a:	62 91 1d 40 72 d4 03 	vpsrld $0x3,%zmm28,%zmm28
  c70b91:	62 63 35 50 25 25 40 80 90 ff a2 	vpternlogd $0xa2,-0x6f7fc0(%rip){1to16},%zmm25,%zmm28        # 578bdc <x86_break_instruction.legacy_forms+0x664>
  c70b9c:	62 c1 65 40 fe dc    	vpaddd %zmm12,%zmm19,%zmm19
  c70ba2:	62 e3 35 58 25 1d 17 80 90 ff ec 	vpternlogd $0xec,-0x6f7fe9(%rip){1to16},%zmm9,%zmm19        # 578bc4 <x86_break_instruction.legacy_forms+0x64c>
  c70bad:	62 41 05 40 fe fc    	vpaddd %zmm12,%zmm31,%zmm31
  c70bb3:	62 63 65 50 25 3d 0e 80 90 ff ec 	vpternlogd $0xec,-0x6f7ff2(%rip){1to16},%zmm19,%zmm31        # 578bcc <x86_break_instruction.legacy_forms+0x654>
  c70bbe:	62 93 35 40 25 c7 f8 	vpternlogd $0xf8,%zmm31,%zmm25,%zmm0
  c70bc5:	62 e2 7d 58 3b 1d 05 80 90 ff 	vpminud -0x6f7ffb(%rip){1to16},%zmm0,%zmm19        # 578bd4 <x86_break_instruction.legacy_forms+0x65c>
  c70bcf:	62 f2 1d 50 3b 05 07 80 90 ff 	vpminud -0x6f7ff9(%rip){1to16},%zmm28,%zmm0        # 578be0 <x86_break_instruction.legacy_forms+0x668>
  c70bd9:	62 01 fd 48 6f c8    	vmovdqa64 %zmm24,%zmm25
  c70bdf:	62 63 2d 50 25 0d ca 7f 90 ff f8 	vpternlogd $0xf8,-0x6f8036(%rip){1to16},%zmm26,%zmm25        # 578bb4 <x86_break_instruction.legacy_forms+0x63c>
  c70bea:	62 61 2d 50 db 3d 08 80 90 ff 	vpandd -0x6f7ff8(%rip){1to16},%zmm26,%zmm31        # 578bfc <x86_break_instruction.legacy_forms+0x684>
  c70bf4:	62 23 7d 48 25 eb fe 	vpternlogd $0xfe,%zmm19,%zmm0,%zmm29
  c70bfb:	62 81 fd 48 6f d8    	vmovdqa64 %zmm24,%zmm19
  c70c01:	62 e3 25 50 25 1d ac 7f 90 ff f8 	vpternlogd $0xf8,-0x6f8054(%rip){1to16},%zmm27,%zmm19        # 578bb8 <x86_break_instruction.legacy_forms+0x640>
  c70c0c:	62 b1 7d 48 72 cf 01 	vprold $0x1,%zmm23,%zmm0
  c70c13:	62 61 25 50 db 1d e3 7f 90 ff 	vpandd -0x6f801d(%rip){1to16},%zmm27,%zmm27        # 578c00 <x86_break_instruction.legacy_forms+0x688>
  c70c1d:	62 83 75 48 25 d9 b8 	vpternlogd $0xb8,%zmm25,%zmm1,%zmm19
  c70c24:	62 02 7d 48 14 ce    	vprorvd %zmm30,%zmm0,%zmm25
  c70c2a:	62 f1 fd 48 6f 05 cc 9f 7a ff 	vmovdqa64 -0x856034(%rip),%zmm0        # 41ac00 <parallel_test_signals_kept.signals+0x3d00>
  c70c34:	62 03 75 48 25 df b8 	vpternlogd $0xb8,%zmm31,%zmm1,%zmm27
  c70c3b:	62 23 2d 40 25 cf e2 	vpternlogd $0xe2,%zmm23,%zmm26,%zmm25
  c70c42:	62 23 75 48 25 cf e2 	vpternlogd $0xe2,%zmm23,%zmm1,%zmm25
  c70c49:	62 f1 cd 48 6c cf    	vpunpcklqdq %zmm7,%zmm6,%zmm1
  c70c4f:	62 d1 1d 40 fe fc    	vpaddd %zmm12,%zmm28,%zmm7
  c70c55:	62 b1 d5 40 6d f6    	vpunpckhqdq %zmm22,%zmm21,%zmm6
  c70c5b:	62 f1 45 48 72 e7 1f 	vpsrad $0x1f,%zmm7,%zmm7
  c70c62:	62 f1 4d 48 eb d2    	vpord  %zmm2,%zmm6,%zmm2
  c70c68:	62 f1 6d 48 72 f2 07 	vpslld $0x7,%zmm2,%zmm2
  c70c6f:	62 d2 fd 48 7e e7    	vpermt2q %zmm15,%zmm0,%zmm4
  c70c75:	62 32 fd 48 7e c1    	vpermt2q %zmm17,%zmm0,%zmm8
  c70c7b:	62 32 fd 48 7e da    	vpermt2q %zmm18,%zmm0,%zmm11
  c70c81:	62 32 fd 48 7e f4    	vpermt2q %zmm20,%zmm0,%zmm14
  c70c87:	62 91 7d 48 72 d0 10 	vpsrld $0x10,%zmm24,%zmm0
  c70c8e:	62 91 05 48 72 d0 03 	vpsrld $0x3,%zmm24,%zmm15
  c70c95:	62 73 7d 58 25 3d 38 7f 90 ff ec 	vpternlogd $0xec,-0x6f80c8(%rip){1to16},%zmm0,%zmm15        # 578bd8 <x86_break_instruction.legacy_forms+0x660>
  c70ca0:	62 f2 7d 48 5a 05 06 1c 8e ff 	vbroadcasti32x4 -0x71e3fa(%rip),%zmm0        # 5528b0 <x86_disassembly_listing.hex+0xdc0>
  c70caa:	62 d1 75 40 72 f7 08 	vpslld $0x8,%zmm15,%zmm17
  c70cb1:	62 e3 45 58 25 0d 28 7f 90 ff 08 	vpternlogd $0x8,-0x6f80d8(%rip){1to16},%zmm7,%zmm17        # 578be4 <x86_break_instruction.legacy_forms+0x66c>
  c70cbc:	62 f2 fd 48 83 f6    	vpmultishiftqb %zmm6,%zmm0,%zmm6
  c70cc2:	62 f3 05 58 25 35 1f 7f 90 ff d8 	vpternlogd $0xd8,-0x6f80e1(%rip){1to16},%zmm15,%zmm6        # 578bec <x86_break_instruction.legacy_forms+0x674>
  c70ccd:	62 91 75 48 62 f9    	vpunpckldq %zmm25,%zmm1,%zmm7
  c70cd3:	62 91 75 48 6a c9    	vpunpckhdq %zmm25,%zmm1,%zmm1
  c70cd9:	62 f3 75 50 25 15 04 7f 90 ff e4 	vpternlogd $0xe4,-0x6f80fc(%rip){1to16},%zmm17,%zmm2        # 578be8 <x86_break_instruction.legacy_forms+0x670>
  c70ce4:	62 f3 6d 58 25 35 01 7f 90 ff d8 	vpternlogd $0xd8,-0x6f80ff(%rip){1to16},%zmm2,%zmm6        # 578bf0 <x86_break_instruction.legacy_forms+0x678>
  c70cef:	62 91 25 40 eb d5    	vpord  %zmm29,%zmm27,%zmm2
  c70cf5:	62 f1 7d 48 70 c2 00 	vpshufd $0x0,%zmm2,%zmm0
  c70cfc:	62 f2 7d 48 8f dc    	vpshufbitqmb %zmm4,%zmm0,%k3
  c70d02:	c4 61 fb 93 c3       	kmovq  %k3,%r8
  c70d07:	f3 4d 0f b8 c0       	popcnt %r8,%r8
  c70d0c:	62 71 65 40 62 fe    	vpunpckldq %zmm6,%zmm19,%zmm15
  c70d12:	62 f1 65 40 6a f6    	vpunpckhdq %zmm6,%zmm19,%zmm6
  c70d18:	62 c1 c5 48 6c cf    	vpunpcklqdq %zmm15,%zmm7,%zmm17
  c70d1e:	62 d1 c5 48 6d ff    	vpunpckhqdq %zmm15,%zmm7,%zmm7
  c70d24:	62 e1 f5 48 6c d6    	vpunpcklqdq %zmm6,%zmm1,%zmm18
  c70d2a:	62 f1 f5 48 6d ce    	vpunpckhqdq %zmm6,%zmm1,%zmm1
  c70d30:	62 f2 75 40 00 e4    	vpshufb %zmm4,%zmm17,%zmm4
  c70d36:	62 d2 45 48 00 c0    	vpshufb %zmm8,%zmm7,%zmm0
  c70d3c:	62 d2 75 48 00 ce    	vpshufb %zmm14,%zmm1,%zmm1
  c70d42:	62 f3 d5 48 25 e3 78 	vpternlogq $0x78,%zmm3,%zmm5,%zmm4
  c70d49:	62 f1 7d 48 70 ea 55 	vpshufd $0x55,%zmm2,%zmm5
  c70d50:	62 f3 ad 48 25 c3 78 	vpternlogq $0x78,%zmm3,%zmm10,%zmm0
  c70d57:	62 f3 fd 40 25 cb 78 	vpternlogq $0x78,%zmm3,%zmm16,%zmm1
  c70d5e:	62 f2 7d cb 63 e4    	vpcompressb %zmm4,%zmm4{%k3}{z}
  c70d64:	62 d2 55 48 8f d0    	vpshufbitqmb %zmm8,%zmm5,%k2
  c70d6a:	62 f1 7d 48 70 ea aa 	vpshufd $0xaa,%zmm2,%zmm5
  c70d71:	62 f1 7d 48 70 d2 ff 	vpshufd $0xff,%zmm2,%zmm2
  c70d78:	62 d2 55 48 8f db    	vpshufbitqmb %zmm11,%zmm5,%k3
  c70d7e:	c4 61 fb 93 ca       	kmovq  %k2,%r9
  c70d83:	c4 61 fb 93 d3       	kmovq  %k3,%r10
  c70d88:	f3 4d 0f b8 c9       	popcnt %r9,%r9
  c70d8d:	62 d1 fe 48 7f 26    	vmovdqu64 %zmm4,(%r14)
  c70d93:	c5 d9 ef e4          	vpxor  %xmm4,%xmm4,%xmm4
  c70d97:	62 f2 7d ca 63 c4    	vpcompressb %zmm0,%zmm4{%k2}{z}
  c70d9d:	62 d2 6d 40 00 c3    	vpshufb %zmm11,%zmm18,%zmm0
  c70da3:	62 d2 6d 48 8f d6    	vpshufbitqmb %zmm14,%zmm2,%k2
  c70da9:	f3 4d 0f b8 fa       	popcnt %r10,%r15
  c70dae:	62 f3 95 48 25 c3 78 	vpternlogq $0x78,%zmm3,%zmm13,%zmm0
  c70db5:	62 f2 7d ca 63 c9    	vpcompressb %zmm1,%zmm1{%k2}{z}
  c70dbb:	c4 61 fb 93 da       	kmovq  %k2,%r11
  c70dc0:	62 91 fe 48 7f 24 06 	vmovdqu64 %zmm4,(%r14,%r8,1)
  c70dc7:	c5 d9 ef e4          	vpxor  %xmm4,%xmm4,%xmm4
  c70dcb:	62 f2 7d cb 63 c4    	vpcompressb %zmm0,%zmm4{%k3}{z}
  c70dd1:	4d 01 f0             	add    %r14,%r8
  c70dd4:	f3 4d 0f b8 f3       	popcnt %r11,%r14
  c70dd9:	4d 01 fe             	add    %r15,%r14
  c70ddc:	62 91 fe 48 7f 24 01 	vmovdqu64 %zmm4,(%r9,%r8,1)
  c70de3:	4d 01 c8             	add    %r9,%r8
  c70de6:	62 91 fe 48 7f 0c 07 	vmovdqu64 %zmm1,(%r15,%r8,1)
  c70ded:	4d 01 c6             	add    %r8,%r14
  c70df0:	4c 8d 40 10          	lea    0x10(%rax),%r8
  c70df4:	48 83 c0 20          	add    $0x20,%rax
  c70df8:	48 39 f0             	cmp    %rsi,%rax
  c70dfb:	4c 89 c0             	mov    %r8,%rax
  c70dfe:	0f 86 9c fa ff ff    	jbe    c708a0 <x86_encode_64+0x2200>
  c70e04:	4c 29 c6             	sub    %r8,%rsi
  c70e07:	0f 87 0a 22 00 00    	ja     c73017 <x86_encode_64+0x4977>
  c70e0d:	e9 06 28 00 00       	jmp    c73618 <x86_encode_64+0x4f78>
  c70e12:	62 72 7d 48 5a 05 14 1a 8e ff 	vbroadcasti32x4 -0x71e5ec(%rip),%zmm8        # 552830 <x86_disassembly_listing.hex+0xd40>
  c70e1c:	62 71 fd 48 6f 1d 1a 9e 7a ff 	vmovdqa64 -0x8561e6(%rip),%zmm11        # 41ac40 <parallel_test_signals_kept.signals+0x3d40>
  c70e26:	62 f1 fd 48 6f 2d 50 9e 7a ff 	vmovdqa64 -0x8561b0(%rip),%zmm5        # 41ac80 <parallel_test_signals_kept.signals+0x3d80>
  c70e30:	62 f1 fd 48 6f 1d 86 9e 7a ff 	vmovdqa64 -0x85617a(%rip),%zmm3        # 41acc0 <parallel_test_signals_kept.signals+0x3dc0>
  c70e3a:	62 f2 7d 48 5a 35 2c 1a 8e ff 	vbroadcasti32x4 -0x71e5d4(%rip),%zmm6        # 552870 <x86_disassembly_listing.hex+0xd80>
  c70e44:	62 f2 7d 48 5a 05 32 1a 8e ff 	vbroadcasti32x4 -0x71e5ce(%rip),%zmm0        # 552880 <x86_disassembly_listing.hex+0xd90>
  c70e4e:	62 72 7d 48 5a 0d 38 1a 8e ff 	vbroadcasti32x4 -0x71e5c8(%rip),%zmm9        # 552890 <x86_disassembly_listing.hex+0xda0>
  c70e58:	62 f2 7d 48 58 3d 42 7d 90 ff 	vpbroadcastd -0x6f82be(%rip),%zmm7        # 578ba4 <x86_break_instruction.legacy_forms+0x62c>
  c70e62:	b0 cc                	mov    $0xcc,%al
  c70e64:	45 31 d2             	xor    %r10d,%r10d
  c70e67:	4c 8d 05 12 15 13 02 	lea    0x2131512(%rip),%r8        # 2da2380 <x86_template_storage>
  c70e6e:	48 89 da             	mov    %rbx,%rdx
  c70e71:	c5 fb 92 c8          	kmovd  %eax,%k1
  c70e75:	62 71 fd 48 7f 44 24 01 	vmovdqa64 %zmm8,0x40(%rsp)
  c70e7d:	0f 1f 00             	nopl   (%rax)
  c70e80:	4c 89 d0             	mov    %r10,%rax
  c70e83:	4e 8d 14 95 00 00 00 00 	lea    0x0(,%r10,4),%r10
  c70e8b:	45 31 c9             	xor    %r9d,%r9d
  c70e8e:	66 90                	xchg   %ax,%ax
  c70e90:	46 0f b7 5c 97 0c    	movzwl 0xc(%rdi,%r10,4),%r11d
  c70e96:	46 0f b7 74 97 1c    	movzwl 0x1c(%rdi,%r10,4),%r14d
  c70e9c:	46 0f b7 7c 97 2c    	movzwl 0x2c(%rdi,%r10,4),%r15d
  c70ea2:	46 0f b7 64 97 3c    	movzwl 0x3c(%rdi,%r10,4),%r12d
  c70ea8:	62 a1 fe 48 6f 1c 97 	vmovdqu64 (%rdi,%r10,4),%zmm19
  c70eaf:	62 21 fe 48 6f 54 97 01 	vmovdqu64 0x40(%rdi,%r10,4),%zmm26
  c70eb7:	62 21 fe 48 6f 5c 97 02 	vmovdqu64 0x80(%rdi,%r10,4),%zmm27
  c70ebf:	62 21 fe 48 6f 64 97 03 	vmovdqu64 0xc0(%rdi,%r10,4),%zmm28
  c70ec7:	62 53 1d 48 25 e4 ff 	vpternlogd $0xff,%zmm12,%zmm12,%zmm12
  c70ece:	49 83 c1 f0          	add    $0xfffffffffffffff0,%r9
  c70ed2:	41 c1 e3 06          	shl    $0x6,%r11d
  c70ed6:	41 c1 e6 06          	shl    $0x6,%r14d
  c70eda:	41 c1 e7 06          	shl    $0x6,%r15d
  c70ede:	41 c1 e4 06          	shl    $0x6,%r12d
  c70ee2:	c4 81 7d 6f 4c 03 40 	vmovdqa 0x40(%r11,%r8,1),%ymm1
  c70ee9:	46 0f b7 5c 97 4c    	movzwl 0x4c(%rdi,%r10,4),%r11d
  c70eef:	62 13 f5 48 3a 54 07 02 01 	vinserti64x4 $0x1,0x40(%r15,%r8,1),%zmm1,%zmm10
  c70ef8:	46 0f b7 7c 97 6c    	movzwl 0x6c(%rdi,%r10,4),%r15d
  c70efe:	c4 81 7d 6f 4c 06 60 	vmovdqa 0x60(%r14,%r8,1),%ymm1
  c70f05:	46 0f b7 74 97 5c    	movzwl 0x5c(%rdi,%r10,4),%r14d
  c70f0b:	62 83 f5 48 3a 6c 04 03 01 	vinserti64x4 $0x1,0x60(%r12,%r8,1),%zmm1,%zmm21
  c70f14:	46 0f b7 64 97 7c    	movzwl 0x7c(%rdi,%r10,4),%r12d
  c70f1a:	62 11 65 40 62 ea    	vpunpckldq %zmm26,%zmm19,%zmm13
  c70f20:	62 11 25 40 62 f4    	vpunpckldq %zmm28,%zmm27,%zmm14
  c70f26:	62 01 65 40 6a d2    	vpunpckhdq %zmm26,%zmm19,%zmm26
  c70f2c:	62 01 25 40 6a e4    	vpunpckhdq %zmm28,%zmm27,%zmm28
  c70f32:	62 11 ad 40 6c c4    	vpunpcklqdq %zmm28,%zmm26,%zmm8
  c70f38:	62 41 95 48 6d ee    	vpunpckhqdq %zmm14,%zmm13,%zmm29
  c70f3e:	62 42 fd 48 83 f8    	vpmultishiftqb %zmm8,%zmm0,%zmm31
  c70f44:	62 f2 7d 48 5a 05 52 19 8e ff 	vbroadcasti32x4 -0x71e6ae(%rip),%zmm0        # 5528a0 <x86_disassembly_listing.hex+0xdb0>
  c70f4e:	62 41 fd 48 6f d8    	vmovdqa64 %zmm8,%zmm27
  c70f54:	62 92 15 40 27 c5    	vptestmd %zmm29,%zmm29,%k0
  c70f5a:	41 c1 e3 06          	shl    $0x6,%r11d
  c70f5e:	c4 81 7d 6f 4c 03 40 	vmovdqa 0x40(%r11,%r8,1),%ymm1
  c70f65:	46 0f b7 9c 97 8c 00 00 00 	movzwl 0x8c(%rdi,%r10,4),%r11d
  c70f6e:	41 c1 e7 06          	shl    $0x6,%r15d
  c70f72:	41 c1 e6 06          	shl    $0x6,%r14d
  c70f76:	62 13 f5 48 3a 7c 07 02 01 	vinserti64x4 $0x1,0x40(%r15,%r8,1),%zmm1,%zmm15
  c70f7f:	46 0f b7 bc 97 ac 00 00 00 	movzwl 0xac(%rdi,%r10,4),%r15d
  c70f88:	c4 81 7d 6f 4c 06 60 	vmovdqa 0x60(%r14,%r8,1),%ymm1
  c70f8f:	46 0f b7 b4 97 9c 00 00 00 	movzwl 0x9c(%rdi,%r10,4),%r14d
  c70f98:	41 c1 e4 06          	shl    $0x6,%r12d
  c70f9c:	62 83 f5 48 3a 7c 04 03 01 	vinserti64x4 $0x1,0x60(%r12,%r8,1),%zmm1,%zmm23
  c70fa5:	46 0f b7 a4 97 bc 00 00 00 	movzwl 0xbc(%rdi,%r10,4),%r12d
  c70fae:	62 b2 ad 49 64 d5    	vpblendmq %zmm21,%zmm10,%zmm2{%k1}
  c70fb4:	41 c1 e3 06          	shl    $0x6,%r11d
  c70fb8:	62 f1 fd 48 7f 14 24 	vmovdqa64 %zmm2,(%rsp)
  c70fbf:	c4 81 7d 6f 4c 03 40 	vmovdqa 0x40(%r11,%r8,1),%ymm1
  c70fc6:	46 0f b7 9c 97 cc 00 00 00 	movzwl 0xcc(%rdi,%r10,4),%r11d
  c70fcf:	41 c1 e7 06          	shl    $0x6,%r15d
  c70fd3:	41 c1 e6 06          	shl    $0x6,%r14d
  c70fd7:	62 83 f5 48 3a 4c 07 02 01 	vinserti64x4 $0x1,0x40(%r15,%r8,1),%zmm1,%zmm17
  c70fe0:	46 0f b7 bc 97 ec 00 00 00 	movzwl 0xec(%rdi,%r10,4),%r15d
  c70fe9:	c4 81 7d 6f 4c 06 60 	vmovdqa 0x60(%r14,%r8,1),%ymm1
  c70ff0:	46 0f b7 b4 97 dc 00 00 00 	movzwl 0xdc(%rdi,%r10,4),%r14d
  c70ff9:	41 c1 e4 06          	shl    $0x6,%r12d
  c70ffd:	62 03 f5 48 3a 44 04 03 01 	vinserti64x4 $0x1,0x60(%r12,%r8,1),%zmm1,%zmm24
  c71006:	46 0f b7 a4 97 fc 00 00 00 	movzwl 0xfc(%rdi,%r10,4),%r12d
  c7100f:	62 a2 85 49 64 c7    	vpblendmq %zmm23,%zmm15,%zmm16{%k1}
  c71015:	41 c1 e3 06          	shl    $0x6,%r11d
  c71019:	41 c1 e6 06          	shl    $0x6,%r14d
  c7101d:	41 c1 e7 06          	shl    $0x6,%r15d
  c71021:	c4 81 7d 6f 4c 03 40 	vmovdqa 0x40(%r11,%r8,1),%ymm1
  c71028:	62 83 f5 48 3a 64 07 02 01 	vinserti64x4 $0x1,0x40(%r15,%r8,1),%zmm1,%zmm20
  c71031:	41 c1 e4 06          	shl    $0x6,%r12d
  c71035:	c4 81 7d 6f 4c 06 60 	vmovdqa 0x60(%r14,%r8,1),%ymm1
  c7103c:	62 03 f5 48 3a 4c 04 03 01 	vinserti64x4 $0x1,0x60(%r12,%r8,1),%zmm1,%zmm25
  c71045:	62 b1 6d 48 6a c8    	vpunpckhdq %zmm16,%zmm2,%zmm1
  c7104b:	62 82 f5 41 64 d0    	vpblendmq %zmm24,%zmm17,%zmm18{%k1}
  c71051:	62 82 dd 41 64 f1    	vpblendmq %zmm25,%zmm20,%zmm22{%k1}
  c71057:	62 b1 6d 40 6a d6    	vpunpckhdq %zmm22,%zmm18,%zmm2
  c7105d:	62 e1 f5 48 6d da    	vpunpckhqdq %zmm2,%zmm1,%zmm19
  c71063:	62 d1 6d 48 72 d0 1a 	vpsrld $0x1a,%zmm8,%zmm2
  c7106a:	62 d1 75 48 72 f0 04 	vpslld $0x4,%zmm8,%zmm1
  c71071:	62 62 6d 48 36 f5    	vpermd %zmm5,%zmm2,%zmm30
  c71077:	62 d2 6d 48 36 e3    	vpermd %zmm11,%zmm2,%zmm4
  c7107d:	62 f2 6d 48 36 d3    	vpermd %zmm3,%zmm2,%zmm2
  c71083:	62 d2 cd 48 83 d8    	vpmultishiftqb %zmm8,%zmm6,%zmm3
  c71089:	62 d2 b5 48 83 e8    	vpmultishiftqb %zmm8,%zmm9,%zmm5
  c7108f:	62 f1 75 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm1
  c71096:	62 63 65 48 25 ff d8 	vpternlogd $0xd8,%zmm7,%zmm3,%zmm31
  c7109d:	62 f2 7d 48 58 3d 09 7b 90 ff 	vpbroadcastd -0x6f84f7(%rip),%zmm7        # 578bb0 <x86_break_instruction.legacy_forms+0x638>
  c710a7:	62 f1 fd 48 6f de    	vmovdqa64 %zmm6,%zmm3
  c710ad:	62 f3 05 50 25 2d f0 7a 90 ff e4 	vpternlogd $0xe4,-0x6f8510(%rip){1to16},%zmm31,%zmm5        # 578ba8 <x86_break_instruction.legacy_forms+0x630>
  c710b8:	62 63 55 48 25 f4 f8 	vpternlogd $0xf8,%zmm4,%zmm5,%zmm30
  c710bf:	62 d2 7d 48 00 e0    	vpshufb %zmm8,%zmm0,%zmm4
  c710c5:	62 f2 7d 48 58 05 dd 7a 90 ff 	vpbroadcastd -0x6f8523(%rip),%zmm0        # 578bac <x86_break_instruction.legacy_forms+0x634>
  c710cf:	62 f1 05 40 72 f4 10 	vpslld $0x10,%zmm4,%zmm31
  c710d6:	62 f1 75 48 db e4    	vpandd %zmm4,%zmm1,%zmm4
  c710dc:	62 f3 6d 58 25 25 0d 7b 90 ff ec 	vpternlogd $0xec,-0x6f84f3(%rip){1to16},%zmm2,%zmm4        # 578bf4 <x86_break_instruction.legacy_forms+0x67c>
  c710e7:	62 91 4d 48 72 e7 1f 	vpsrad $0x1f,%zmm31,%zmm6
  c710ee:	62 62 7e 48 38 f8    	vpmovm2d %k0,%zmm31
  c710f4:	62 f3 65 50 25 25 f9 7a 90 ff f8 	vpternlogd $0xf8,-0x6f8507(%rip){1to16},%zmm19,%zmm4        # 578bf8 <x86_break_instruction.legacy_forms+0x680>
  c710ff:	62 63 75 48 25 fe c8 	vpternlogd $0xc8,%zmm6,%zmm1,%zmm31
  c71106:	62 91 4d 48 72 e5 1f 	vpsrad $0x1f,%zmm29,%zmm6
  c7110d:	62 91 4d 48 ef f5    	vpxord %zmm29,%zmm6,%zmm6
  c71113:	62 f2 7d 48 44 f6    	vplzcntd %zmm6,%zmm6
  c71119:	62 63 7d 58 25 1d 98 7a 90 ff 6c 	vpternlogd $0x6c,-0x6f8568(%rip){1to16},%zmm0,%zmm27        # 578bbc <x86_break_instruction.legacy_forms+0x644>
  c71124:	62 f2 45 48 45 f6    	vpsrlvd %zmm6,%zmm7,%zmm6
  c7112a:	62 f3 45 48 25 ff ff 	vpternlogd $0xff,%zmm7,%zmm7,%zmm7
  c71131:	62 f1 15 40 fe ff    	vpaddd %zmm7,%zmm29,%zmm7
  c71137:	62 f3 15 40 25 fe 14 	vpternlogd $0x14,%zmm6,%zmm29,%zmm7
  c7113e:	62 d1 4d 48 72 d0 08 	vpsrld $0x8,%zmm8,%zmm6
  c71145:	62 f3 7d 58 25 35 70 7a 90 ff 6c 	vpternlogd $0x6c,-0x6f8590(%rip){1to16},%zmm0,%zmm6        # 578bc0 <x86_break_instruction.legacy_forms+0x648>
  c71150:	62 f3 7d 48 25 c0 ff 	vpternlogd $0xff,%zmm0,%zmm0,%zmm0
  c71157:	62 41 25 40 fe dc    	vpaddd %zmm12,%zmm27,%zmm27
  c7115d:	62 72 7d 48 58 25 61 7a 90 ff 	vpbroadcastd -0x6f859f(%rip),%zmm12        # 578bc8 <x86_break_instruction.legacy_forms+0x650>
  c71167:	62 f1 4d 48 fe f0    	vpaddd %zmm0,%zmm6,%zmm6
  c7116d:	62 f1 55 58 db 05 59 7a 90 ff 	vpandd -0x6f85a7(%rip){1to16},%zmm5,%zmm0        # 578bd0 <x86_break_instruction.legacy_forms+0x658>
  c71177:	62 f1 55 48 72 d5 03 	vpsrld $0x3,%zmm5,%zmm5
  c7117e:	62 f3 65 50 25 2d 53 7a 90 ff a2 	vpternlogd $0xa2,-0x6f85ad(%rip){1to16},%zmm19,%zmm5        # 578bdc <x86_break_instruction.legacy_forms+0x664>
  c71189:	62 f2 55 58 3b 15 4d 7a 90 ff 	vpminud -0x6f85b3(%rip){1to16},%zmm5,%zmm2        # 578be0 <x86_break_instruction.legacy_forms+0x668>
  c71193:	62 63 1d 58 25 1d 26 7a 90 ff ec 	vpternlogd $0xec,-0x6f85da(%rip){1to16},%zmm12,%zmm27        # 578bc4 <x86_break_instruction.legacy_forms+0x64c>
  c7119e:	62 53 1d 48 25 e4 ff 	vpternlogd $0xff,%zmm12,%zmm12,%zmm12
  c711a5:	62 d1 55 48 fe ec    	vpaddd %zmm12,%zmm5,%zmm5
  c711ab:	62 72 7d 48 58 25 3b 7a 90 ff 	vpbroadcastd -0x6f85c5(%rip),%zmm12        # 578bf0 <x86_break_instruction.legacy_forms+0x678>
  c711b5:	62 f3 25 50 25 35 0c 7a 90 ff ec 	vpternlogd $0xec,-0x6f85f4(%rip){1to16},%zmm27,%zmm6        # 578bcc <x86_break_instruction.legacy_forms+0x654>
  c711c0:	62 f3 65 40 25 c6 f8 	vpternlogd $0xf8,%zmm6,%zmm19,%zmm0
  c711c7:	62 62 7d 58 3b 1d 03 7a 90 ff 	vpminud -0x6f85fd(%rip){1to16},%zmm0,%zmm27        # 578bd4 <x86_break_instruction.legacy_forms+0x65c>
  c711d1:	62 b1 4d 48 72 d3 1d 	vpsrld $0x1d,%zmm19,%zmm6
  c711d8:	62 d1 fd 48 6f c1    	vmovdqa64 %zmm9,%zmm0
  c711de:	62 71 75 58 db 0d 18 7a 90 ff 	vpandd -0x6f85e8(%rip){1to16},%zmm1,%zmm9        # 578c00 <x86_break_instruction.legacy_forms+0x688>
  c711e8:	62 f2 45 48 14 fe    	vprorvd %zmm6,%zmm7,%zmm7
  c711ee:	62 f1 45 48 72 e7 1f 	vpsrad $0x1f,%zmm7,%zmm7
  c711f5:	62 93 6d 48 25 e3 fe 	vpternlogd $0xfe,%zmm27,%zmm2,%zmm4
  c711fc:	62 01 fd 48 6f de    	vmovdqa64 %zmm30,%zmm27
  c71202:	62 91 fd 48 6f d6    	vmovdqa64 %zmm30,%zmm2
  c71208:	62 63 75 58 25 1d a5 79 90 ff f8 	vpternlogd $0xf8,-0x6f865b(%rip){1to16},%zmm1,%zmm27        # 578bb8 <x86_break_instruction.legacy_forms+0x640>
  c71213:	62 f3 05 50 25 15 96 79 90 ff f8 	vpternlogd $0xf8,-0x6f866a(%rip){1to16},%zmm31,%zmm2        # 578bb4 <x86_break_instruction.legacy_forms+0x63c>
  c7121e:	62 91 75 48 72 cd 01 	vprold $0x1,%zmm29,%zmm1
  c71225:	62 f2 75 48 14 f6    	vprorvd %zmm6,%zmm1,%zmm6
  c7122b:	62 f1 fd 48 6f 0d cb 99 7a ff 	vmovdqa64 -0x856635(%rip),%zmm1        # 41ac00 <parallel_test_signals_kept.signals+0x3d00>
  c71235:	62 93 05 40 25 f5 e2 	vpternlogd $0xe2,%zmm29,%zmm31,%zmm6
  c7123c:	62 93 45 48 25 f5 e2 	vpternlogd $0xe2,%zmm29,%zmm7,%zmm6
  c71243:	62 62 7d 48 58 2d 8b 79 90 ff 	vpbroadcastd -0x6f8675(%rip),%zmm29        # 578bd8 <x86_break_instruction.legacy_forms+0x660>
  c7124d:	62 63 45 48 25 da b8 	vpternlogd $0xb8,%zmm2,%zmm7,%zmm27
  c71254:	62 f1 05 50 db 15 9e 79 90 ff 	vpandd -0x6f8662(%rip){1to16},%zmm31,%zmm2        # 578bfc <x86_break_instruction.legacy_forms+0x684>
  c7125e:	62 32 f5 48 7e ff    	vpermt2q %zmm23,%zmm1,%zmm15
  c71264:	62 e2 7d 48 58 3d 76 79 90 ff 	vpbroadcastd -0x6f868a(%rip),%zmm23        # 578be4 <x86_break_instruction.legacy_forms+0x66c>
  c7126e:	62 32 f5 48 7e d5    	vpermt2q %zmm21,%zmm1,%zmm10
  c71274:	62 82 f5 48 7e c8    	vpermt2q %zmm24,%zmm1,%zmm17
  c7127a:	62 82 f5 48 7e e1    	vpermt2q %zmm25,%zmm1,%zmm20
  c71280:	62 91 75 48 72 d6 10 	vpsrld $0x10,%zmm30,%zmm1
  c71287:	62 e2 7d 48 5a 2d 1f 16 8e ff 	vbroadcasti32x4 -0x71e9e1(%rip),%zmm21        # 5528b0 <x86_disassembly_listing.hex+0xdc0>
  c71291:	62 73 45 48 25 ca b8 	vpternlogd $0xb8,%zmm2,%zmm7,%zmm9
  c71298:	62 d1 95 48 6c fe    	vpunpcklqdq %zmm14,%zmm13,%zmm7
  c7129e:	62 72 7d 48 58 35 40 79 90 ff 	vpbroadcastd -0x6f86c0(%rip),%zmm14        # 578be8 <x86_break_instruction.legacy_forms+0x670>
  c712a8:	62 91 15 48 72 d6 03 	vpsrld $0x3,%zmm30,%zmm13
  c712af:	62 91 ad 40 6d d4    	vpunpckhqdq %zmm28,%zmm26,%zmm2
  c712b5:	62 13 75 48 25 ed ec 	vpternlogd $0xec,%zmm29,%zmm1,%zmm13
  c712bc:	62 51 6d 48 eb c0    	vpord  %zmm8,%zmm2,%zmm8
  c712c2:	62 f1 75 48 72 e5 1f 	vpsrad $0x1f,%zmm5,%zmm1
  c712c9:	62 d1 55 48 72 f5 08 	vpslld $0x8,%zmm13,%zmm5
  c712d0:	62 d1 3d 48 72 f0 07 	vpslld $0x7,%zmm8,%zmm8
  c712d7:	62 b3 75 48 25 ef 08 	vpternlogd $0x8,%zmm23,%zmm1,%zmm5
  c712de:	62 53 55 48 25 c6 e4 	vpternlogd $0xe4,%zmm14,%zmm5,%zmm8
  c712e5:	62 72 7d 48 58 35 fd 78 90 ff 	vpbroadcastd -0x6f8703(%rip),%zmm14        # 578bec <x86_break_instruction.legacy_forms+0x674>
  c712ef:	62 f2 d5 40 83 ea    	vpmultishiftqb %zmm2,%zmm21,%zmm5
  c712f5:	62 f1 35 48 eb d4    	vpord  %zmm4,%zmm9,%zmm2
  c712fb:	62 f1 45 48 62 e6    	vpunpckldq %zmm6,%zmm7,%zmm4
  c71301:	62 f1 45 48 6a f6    	vpunpckhdq %zmm6,%zmm7,%zmm6
  c71307:	62 71 fd 48 6f c8    	vmovdqa64 %zmm0,%zmm9
  c7130d:	62 f1 7d 48 70 c2 00 	vpshufd $0x0,%zmm2,%zmm0
  c71314:	62 d2 7d 48 8f da    	vpshufbitqmb %zmm10,%zmm0,%k3
  c7131a:	62 f1 7d 48 70 c2 55 	vpshufd $0x55,%zmm2,%zmm0
  c71321:	62 d2 7d 48 8f d7    	vpshufbitqmb %zmm15,%zmm0,%k2
  c71327:	62 f1 7d 48 70 c2 aa 	vpshufd $0xaa,%zmm2,%zmm0
  c7132e:	c4 61 fb 93 db       	kmovq  %k3,%r11
  c71333:	f3 4d 0f b8 db       	popcnt %r11,%r11
  c71338:	c4 61 fb 93 f2       	kmovq  %k2,%r14
  c7133d:	f3 4d 0f b8 f6       	popcnt %r14,%r14
  c71342:	62 d3 15 48 25 ee d8 	vpternlogd $0xd8,%zmm14,%zmm13,%zmm5
  c71349:	62 71 fd 48 6f 6c 24 01 	vmovdqa64 0x40(%rsp),%zmm13
  c71351:	62 d3 3d 48 25 ec d8 	vpternlogd $0xd8,%zmm12,%zmm8,%zmm5
  c71358:	62 f1 25 40 62 fd    	vpunpckldq %zmm5,%zmm27,%zmm7
  c7135e:	62 f1 25 40 6a ed    	vpunpckhdq %zmm5,%zmm27,%zmm5
  c71364:	62 71 dd 48 6c c7    	vpunpcklqdq %zmm7,%zmm4,%zmm8
  c7136a:	62 f1 dd 48 6d e7    	vpunpckhqdq %zmm7,%zmm4,%zmm4
  c71370:	62 71 cd 48 6c e5    	vpunpcklqdq %zmm5,%zmm6,%zmm12
  c71376:	62 f1 cd 48 6d ed    	vpunpckhqdq %zmm5,%zmm6,%zmm5
  c7137c:	62 f2 7d 48 58 3d 1e 78 90 ff 	vpbroadcastd -0x6f87e2(%rip),%zmm7        # 578ba4 <x86_break_instruction.legacy_forms+0x62c>
  c71386:	62 52 3d 48 00 c2    	vpshufb %zmm10,%zmm8,%zmm8
  c7138c:	62 d2 5d 48 00 e7    	vpshufb %zmm15,%zmm4,%zmm4
  c71392:	62 32 1d 48 00 e1    	vpshufb %zmm17,%zmm12,%zmm12
  c71398:	62 72 7d 48 58 15 62 78 90 ff 	vpbroadcastd -0x6f879e(%rip),%zmm10        # 578c04 <x86_break_instruction.legacy_forms+0x68c>
  c713a2:	62 73 95 48 25 04 24 78 	vpternlogq $0x78,(%rsp),%zmm13,%zmm8
  c713aa:	62 d3 fd 40 25 e5 78 	vpternlogq $0x78,%zmm13,%zmm16,%zmm4
  c713b1:	62 53 ed 40 25 e5 78 	vpternlogq $0x78,%zmm13,%zmm18,%zmm12
  c713b8:	62 f2 7d ca 63 e4    	vpcompressb %zmm4,%zmm4{%k2}{z}
  c713be:	c5 c9 ef f6          	vpxor  %xmm6,%xmm6,%xmm6
  c713c2:	62 72 7d cb 63 c6    	vpcompressb %zmm8,%zmm6{%k3}{z}
  c713c8:	62 b2 7d 48 8f d9    	vpshufbitqmb %zmm17,%zmm0,%k3
  c713ce:	62 72 7d 48 58 05 30 78 90 ff 	vpbroadcastd -0x6f87d0(%rip),%zmm8        # 578c08 <x86_break_instruction.legacy_forms+0x690>
  c713d8:	62 f2 7d 48 5a 05 9e 14 8e ff 	vbroadcasti32x4 -0x71eb62(%rip),%zmm0        # 552880 <x86_disassembly_listing.hex+0xd90>
  c713e2:	c4 61 fb 93 fb       	kmovq  %k3,%r15
  c713e7:	62 f1 fe 48 7f 32    	vmovdqu64 %zmm6,(%rdx)
  c713ed:	62 b1 fe 48 7f 24 1a 	vmovdqu64 %zmm4,(%rdx,%r11,1)
  c713f4:	c5 d9 ef e4          	vpxor  %xmm4,%xmm4,%xmm4
  c713f8:	62 72 7d cb 63 e4    	vpcompressb %zmm12,%zmm4{%k3}{z}
  c713fe:	62 f1 fd 48 6f f3    	vmovdqa64 %zmm3,%zmm6
  c71404:	62 f1 7d 48 70 da ff 	vpshufd $0xff,%zmm2,%zmm3
  c7140b:	62 32 55 48 00 e4    	vpshufb %zmm20,%zmm5,%zmm12
  c71411:	49 01 d3             	add    %rdx,%r11
  c71414:	62 d3 65 40 25 d2 20 	vpternlogd $0x20,%zmm10,%zmm19,%zmm2
  c7141b:	29 da                	sub    %ebx,%edx
  c7141d:	62 f1 fd 48 6f 2d 59 98 7a ff 	vmovdqa64 -0x8567a7(%rip),%zmm5        # 41ac80 <parallel_test_signals_kept.signals+0x3d80>
  c71427:	62 b2 65 48 8f d4    	vpshufbitqmb %zmm20,%zmm3,%k2
  c7142d:	62 f2 7d 48 55 d2    	vpopcntd %zmm2,%zmm2
  c71433:	62 f1 fd 48 6f 1d 83 98 7a ff 	vmovdqa64 -0x85677d(%rip),%zmm3        # 41acc0 <parallel_test_signals_kept.signals+0x3dc0>
  c7143d:	62 53 cd 40 25 e5 78 	vpternlogq $0x78,%zmm13,%zmm22,%zmm12
  c71444:	62 91 fe 48 7f 24 1e 	vmovdqu64 %zmm4,(%r14,%r11,1)
  c7144b:	c5 d9 ef e4          	vpxor  %xmm4,%xmm4,%xmm4
  c7144f:	62 72 7d ca 63 e4    	vpcompressb %zmm12,%zmm4{%k2}{z}
  c71455:	4d 01 f3             	add    %r14,%r11
  c71458:	f3 4d 0f b8 f7       	popcnt %r15,%r14
  c7145d:	62 91 fe 48 7f 24 1e 	vmovdqu64 %zmm4,(%r14,%r11,1)
  c71464:	c5 f9 6f 25 d4 13 8e ff 	vmovdqa -0x71ec2c(%rip),%xmm4        # 552840 <x86_disassembly_listing.hex+0xd50>
  c7146c:	89 94 24 00 01 00 00 	mov    %edx,0x100(%rsp)
  c71473:	c4 e1 fb 93 d2       	kmovq  %k2,%rdx
  c71478:	f3 48 0f b8 d2       	popcnt %rdx,%rdx
  c7147d:	4c 01 f2             	add    %r14,%rdx
  c71480:	4c 01 da             	add    %r11,%rdx
  c71483:	62 71 fd 48 6f d4    	vmovdqa64 %zmm4,%zmm10
  c71489:	62 d1 65 40 db e0    	vpandd %zmm8,%zmm19,%zmm4
  c7148f:	62 f1 75 48 fe cc    	vpaddd %zmm4,%zmm1,%zmm1
  c71495:	62 f1 75 48 fe ca    	vpaddd %zmm2,%zmm1,%zmm1
  c7149b:	c4 e2 79 59 15 ec 6f 90 ff 	vpbroadcastq -0x6f9014(%rip),%xmm2        # 578490 <x86_effects_unknown+0x1a90>
  c714a4:	62 f2 2d 48 8d c9    	vpermb %zmm1,%zmm10,%zmm1
  c714aa:	c5 79 6f 15 9e 13 8e ff 	vmovdqa -0x71ec62(%rip),%xmm10        # 552850 <x86_disassembly_listing.hex+0xd60>
  c714b2:	62 f2 f5 08 40 d2    	vpmullq %xmm2,%xmm1,%xmm2
  c714b8:	c5 e9 f8 c9          	vpsubb %xmm1,%xmm2,%xmm1
  c714bc:	c4 c2 69 00 d2       	vpshufb %xmm10,%xmm2,%xmm2
  c714c1:	c5 f1 fc ca          	vpaddb %xmm2,%xmm1,%xmm1
  c714c5:	62 f2 7d 48 31 c9    	vpmovzxbd %xmm1,%zmm1
  c714cb:	62 f1 75 58 fe 4c 24 40 	vpaddd 0x100(%rsp){1to16},%zmm1,%zmm1
  c714d3:	62 b1 fe 48 7f 0c 11 	vmovdqu64 %zmm1,(%rcx,%r10,1)
  c714da:	49 83 c2 40          	add    $0x40,%r10
  c714de:	49 83 f9 c0          	cmp    $0xffffffffffffffc0,%r9
  c714e2:	0f 85 a8 f9 ff ff    	jne    c70e90 <x86_encode_64+0x27f0>
  c714e8:	49 89 c2             	mov    %rax,%r10
  c714eb:	4d 29 ca             	sub    %r9,%r10
  c714ee:	4d 8d 5a 40          	lea    0x40(%r10),%r11
  c714f2:	49 39 f3             	cmp    %rsi,%r11
  c714f5:	0f 86 85 f9 ff ff    	jbe    c70e80 <x86_encode_64+0x27e0>
  c714fb:	4c 29 c8             	sub    %r9,%rax
  c714fe:	4c 8d 40 10          	lea    0x10(%rax),%r8
  c71502:	49 39 f0             	cmp    %rsi,%r8
  c71505:	0f 86 79 d8 ff ff    	jbe    c6ed84 <x86_encode_64+0x6e4>
  c7150b:	49 89 d6             	mov    %rdx,%r14
  c7150e:	49 89 c7             	mov    %rax,%r15
  c71511:	4c 29 fe             	sub    %r15,%rsi
  c71514:	0f 86 fe 20 00 00    	jbe    c73618 <x86_encode_64+0x4f78>
  c7151a:	4c 89 f8             	mov    %r15,%rax
  c7151d:	48 c1 e0 04          	shl    $0x4,%rax
  c71521:	48 89 f2             	mov    %rsi,%rdx
  c71524:	48 c1 e2 04          	shl    $0x4,%rdx
  c71528:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
  c7152c:	62 f1 fd 48 7f 44 24 07 	vmovdqa64 %zmm0,0x1c0(%rsp)
  c71534:	62 f1 fd 48 7f 44 24 06 	vmovdqa64 %zmm0,0x180(%rsp)
  c7153c:	62 f1 fd 48 7f 44 24 05 	vmovdqa64 %zmm0,0x140(%rsp)
  c71544:	62 f1 fd 48 7f 44 24 04 	vmovdqa64 %zmm0,0x100(%rsp)
  c7154c:	49 89 f5             	mov    %rsi,%r13
  c7154f:	49 89 cc             	mov    %rcx,%r12
  c71552:	48 01 c7             	add    %rax,%rdi
  c71555:	48 8d 84 24 00 01 00 00 	lea    0x100(%rsp),%rax
  c7155d:	49 89 f8             	mov    %rdi,%r8
  c71560:	48 89 c7             	mov    %rax,%rdi
  c71563:	4c 89 c6             	mov    %r8,%rsi
  c71566:	c5 f8 77             	vzeroupper
  c71569:	e8 e2 2e af ff       	call   764450 <memcpy@plt>
  c7156e:	c5 f9 6f a4 24 30 01 00 00 	vmovdqa 0x130(%rsp),%xmm4
  c71577:	c5 f9 6f 8c 24 00 01 00 00 	vmovdqa 0x100(%rsp),%xmm1
  c71580:	c5 f9 6f 94 24 10 01 00 00 	vmovdqa 0x110(%rsp),%xmm2
  c71589:	48 8d 05 f0 0d 13 02 	lea    0x2130df0(%rip),%rax        # 2da2380 <x86_template_storage>
  c71590:	c5 f9 6f 9c 24 20 01 00 00 	vmovdqa 0x120(%rsp),%xmm3
  c71599:	c5 f9 6f ac 24 60 01 00 00 	vmovdqa 0x160(%rsp),%xmm5
  c715a2:	62 71 fd 48 6f 3d 54 96 7a ff 	vmovdqa64 -0x8569ac(%rip),%zmm15        # 41ac00 <parallel_test_signals_kept.signals+0x3d00>
  c715ac:	c5 79 6f 84 24 80 01 00 00 	vmovdqa 0x180(%rsp),%xmm8
  c715b5:	c5 f9 6f b4 24 90 01 00 00 	vmovdqa 0x190(%rsp),%xmm6
  c715be:	62 f1 fd 48 6f 7c 24 04 	vmovdqa64 0x100(%rsp),%zmm7
  c715c6:	62 71 fd 48 6f 54 24 05 	vmovdqa64 0x140(%rsp),%zmm10
  c715ce:	62 71 fd 48 6f 5c 24 06 	vmovdqa64 0x180(%rsp),%zmm11
  c715d6:	62 71 fd 48 6f 64 24 07 	vmovdqa64 0x1c0(%rsp),%zmm12
  c715de:	62 e2 7d 48 5a 0d 88 12 8e ff 	vbroadcasti32x4 -0x71ed78(%rip),%zmm17        # 552870 <x86_disassembly_listing.hex+0xd80>
  c715e8:	62 e2 7d 48 5a 15 9e 12 8e ff 	vbroadcasti32x4 -0x71ed62(%rip),%zmm18        # 552890 <x86_disassembly_listing.hex+0xda0>
  c715f2:	62 a3 4d 40 25 f6 ff 	vpternlogd $0xff,%zmm22,%zmm22,%zmm22
  c715f9:	62 e2 7d 48 58 2d a9 75 90 ff 	vpbroadcastd -0x6f8a57(%rip),%zmm21        # 578bac <x86_break_instruction.legacy_forms+0x634>
  c71603:	62 62 7d 48 58 1d ab 75 90 ff 	vpbroadcastd -0x6f8a55(%rip),%zmm27        # 578bb8 <x86_break_instruction.legacy_forms+0x640>
  c7160d:	62 62 7d 48 58 0d a5 75 90 ff 	vpbroadcastd -0x6f8a5b(%rip),%zmm25        # 578bbc <x86_break_instruction.legacy_forms+0x644>
  c71617:	c5 f9 c5 fc 06       	vpextrw $0x6,%xmm4,%edi
  c7161c:	c5 f9 6f a4 24 40 01 00 00 	vmovdqa 0x140(%rsp),%xmm4
  c71625:	c5 f9 c5 c9 06       	vpextrw $0x6,%xmm1,%ecx
  c7162a:	c5 f9 c5 d2 06       	vpextrw $0x6,%xmm2,%edx
  c7162f:	c5 f9 c5 f3 06       	vpextrw $0x6,%xmm3,%esi
  c71634:	62 51 45 48 62 ea    	vpunpckldq %zmm10,%zmm7,%zmm13
  c7163a:	62 51 25 48 62 f4    	vpunpckldq %zmm12,%zmm11,%zmm14
  c71640:	62 d1 45 48 6a fa    	vpunpckhdq %zmm10,%zmm7,%zmm7
  c71646:	62 51 25 48 6a dc    	vpunpckhdq %zmm12,%zmm11,%zmm11
  c7164c:	c1 e1 06             	shl    $0x6,%ecx
  c7164f:	c1 e2 06             	shl    $0x6,%edx
  c71652:	c1 e6 06             	shl    $0x6,%esi
  c71655:	c1 e7 06             	shl    $0x6,%edi
  c71658:	62 51 95 48 6d d6    	vpunpckhqdq %zmm14,%zmm13,%zmm10
  c7165e:	62 d1 95 48 6c c6    	vpunpcklqdq %zmm14,%zmm13,%zmm0
  c71664:	62 51 c5 48 6c eb    	vpunpcklqdq %zmm11,%zmm7,%zmm13
  c7166a:	62 51 c5 48 6d f3    	vpunpckhqdq %zmm11,%zmm7,%zmm14
  c71670:	c5 fd 6f 4c 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm1
  c71676:	b1 cc                	mov    $0xcc,%cl
  c71678:	c5 fd 6f 54 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm2
  c7167e:	62 c2 ed 40 83 e5    	vpmultishiftqb %zmm13,%zmm18,%zmm20
  c71684:	62 d1 1d 48 72 d5 1a 	vpsrld $0x1a,%zmm13,%zmm12
  c7168b:	62 d2 2d 48 27 c2    	vptestmd %zmm10,%zmm10,%k0
  c71691:	62 d1 65 40 72 e2 1f 	vpsrad $0x1f,%zmm10,%zmm19
  c71698:	62 21 2d 48 fe c6    	vpaddd %zmm22,%zmm10,%zmm24
  c7169e:	62 43 55 40 25 cd 6c 	vpternlogd $0x6c,%zmm13,%zmm21,%zmm25
  c716a5:	c5 fb 92 c9          	kmovd  %ecx,%k1
  c716a9:	62 f3 f5 48 3a 4c 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm1,%zmm1
  c716b2:	62 f3 ed 48 3a 5c 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm2,%zmm3
  c716bb:	c5 f9 c5 f5 06       	vpextrw $0x6,%xmm5,%esi
  c716c0:	c1 e6 06             	shl    $0x6,%esi
  c716c3:	c5 f9 c5 cc 06       	vpextrw $0x6,%xmm4,%ecx
  c716c8:	c5 f9 6f a4 24 50 01 00 00 	vmovdqa 0x150(%rsp),%xmm4
  c716d1:	c1 e1 06             	shl    $0x6,%ecx
  c716d4:	62 f2 f5 49 64 d3    	vpblendmq %zmm3,%zmm1,%zmm2{%k1}
  c716da:	62 f2 85 48 7e cb    	vpermt2q %zmm3,%zmm15,%zmm1
  c716e0:	c5 fd 6f 5c 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm3
  c716e6:	c4 c1 79 c5 c8 06    	vpextrw $0x6,%xmm8,%ecx
  c716ec:	c5 79 6f 84 24 a0 01 00 00 	vmovdqa 0x1a0(%rsp),%xmm8
  c716f5:	62 f3 e5 48 3a 5c 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm3,%zmm3
  c716fe:	c1 e1 06             	shl    $0x6,%ecx
  c71701:	c5 f9 c5 d4 06       	vpextrw $0x6,%xmm4,%edx
  c71706:	c5 f9 6f a4 24 70 01 00 00 	vmovdqa 0x170(%rsp),%xmm4
  c7170f:	c1 e2 06             	shl    $0x6,%edx
  c71712:	c4 c1 79 c5 f0 06    	vpextrw $0x6,%xmm8,%esi
  c71718:	c1 e6 06             	shl    $0x6,%esi
  c7171b:	c5 f9 c5 fc 06       	vpextrw $0x6,%xmm4,%edi
  c71720:	c5 fd 6f 64 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm4
  c71726:	c5 f9 c5 d6 06       	vpextrw $0x6,%xmm6,%edx
  c7172b:	c5 f9 6f b4 24 b0 01 00 00 	vmovdqa 0x1b0(%rsp),%xmm6
  c71734:	c1 e7 06             	shl    $0x6,%edi
  c71737:	c1 e2 06             	shl    $0x6,%edx
  c7173a:	62 f3 dd 48 3a 6c 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm4,%zmm5
  c71743:	c5 f9 c5 fe 06       	vpextrw $0x6,%xmm6,%edi
  c71748:	c5 fd 6f 74 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm6
  c7174e:	0f b7 94 24 dc 01 00 00 	movzwl 0x1dc(%rsp),%edx
  c71756:	c1 e7 06             	shl    $0x6,%edi
  c71759:	62 f2 e5 49 64 e5    	vpblendmq %zmm5,%zmm3,%zmm4{%k1}
  c7175f:	62 f2 85 48 7e dd    	vpermt2q %zmm5,%zmm15,%zmm3
  c71765:	c5 fd 6f 6c 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm5
  c7176b:	62 73 cd 48 3a 44 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm6,%zmm8
  c71774:	0f b7 8c 24 cc 01 00 00 	movzwl 0x1cc(%rsp),%ecx
  c7177c:	0f b7 bc 24 fc 01 00 00 	movzwl 0x1fc(%rsp),%edi
  c71784:	62 f3 d5 48 3a 6c 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm5,%zmm5
  c7178d:	0f b7 b4 24 ec 01 00 00 	movzwl 0x1ec(%rsp),%esi
  c71795:	62 f1 6d 48 6a fc    	vpunpckhdq %zmm4,%zmm2,%zmm7
  c7179b:	c1 e2 06             	shl    $0x6,%edx
  c7179e:	c5 7d 6f 4c 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm9
  c717a4:	c1 e1 06             	shl    $0x6,%ecx
  c717a7:	c1 e7 06             	shl    $0x6,%edi
  c717aa:	c1 e6 06             	shl    $0x6,%esi
  c717ad:	62 e3 b5 48 3a 44 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm9,%zmm16
  c717b6:	62 d2 d5 49 64 f0    	vpblendmq %zmm8,%zmm5,%zmm6{%k1}
  c717bc:	62 d2 85 48 7e e8    	vpermt2q %zmm8,%zmm15,%zmm5
  c717c2:	c5 7d 6f 44 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm8
  c717c8:	62 73 bd 48 3a 44 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm8,%zmm8
  c717d1:	62 32 bd 49 64 c8    	vpblendmq %zmm16,%zmm8,%zmm9{%k1}
  c717d7:	62 32 85 48 7e c0    	vpermt2q %zmm16,%zmm15,%zmm8
  c717dd:	62 c2 f5 40 83 c5    	vpmultishiftqb %zmm13,%zmm17,%zmm16
  c717e3:	62 e2 7d 48 5a 0d 93 10 8e ff 	vbroadcasti32x4 -0x71ef6d(%rip),%zmm17        # 552880 <x86_disassembly_listing.hex+0xd90>
  c717ed:	62 72 1d 48 36 3d 49 94 7a ff 	vpermd -0x856bb7(%rip),%zmm12,%zmm15        # 41ac40 <parallel_test_signals_kept.signals+0x3d40>
  c717f7:	62 51 4d 48 6a d9    	vpunpckhdq %zmm9,%zmm6,%zmm11
  c717fd:	62 d1 c5 48 6d fb    	vpunpckhqdq %zmm11,%zmm7,%zmm7
  c71803:	62 72 1d 48 36 1d 73 94 7a ff 	vpermd -0x856b8d(%rip),%zmm12,%zmm11        # 41ac80 <parallel_test_signals_kept.signals+0x3d80>
  c7180d:	62 72 1d 48 36 25 a9 94 7a ff 	vpermd -0x856b57(%rip),%zmm12,%zmm12        # 41acc0 <parallel_test_signals_kept.signals+0x3dc0>
  c71817:	62 f1 45 40 72 d7 1d 	vpsrld $0x1d,%zmm7,%zmm23
  c7181e:	62 c2 f5 40 83 cd    	vpmultishiftqb %zmm13,%zmm17,%zmm17
  c71824:	62 e3 7d 50 25 0d 75 73 90 ff d8 	vpternlogd $0xd8,-0x6f8c8b(%rip){1to16},%zmm16,%zmm17        # 578ba4 <x86_break_instruction.legacy_forms+0x62c>
  c7182f:	62 d1 7d 40 72 f5 04 	vpslld $0x4,%zmm13,%zmm16
  c71836:	62 b1 7d 40 72 e0 1f 	vpsrad $0x1f,%zmm16,%zmm16
  c7183d:	62 e3 75 50 25 25 60 73 90 ff e4 	vpternlogd $0xe4,-0x6f8ca0(%rip){1to16},%zmm17,%zmm20        # 578ba8 <x86_break_instruction.legacy_forms+0x630>
  c71848:	62 e2 7d 48 5a 0d 4e 10 8e ff 	vbroadcasti32x4 -0x71efb2(%rip),%zmm17        # 5528a0 <x86_disassembly_listing.hex+0xdb0>
  c71852:	62 c2 75 40 00 cd    	vpshufb %zmm13,%zmm17,%zmm17
  c71858:	62 53 5d 40 25 df f8 	vpternlogd $0xf8,%zmm15,%zmm20,%zmm11
  c7185f:	62 43 7d 40 25 db ea 	vpternlogd $0xea,%zmm11,%zmm16,%zmm27
  c71866:	62 d1 2d 40 72 d3 03 	vpsrld $0x3,%zmm11,%zmm26
  c7186d:	62 b1 05 48 72 f1 10 	vpslld $0x10,%zmm17,%zmm15
  c71874:	62 a1 7d 40 db c9    	vpandd %zmm17,%zmm16,%zmm17
  c7187a:	62 e3 1d 58 25 0d 6f 73 90 ff ec 	vpternlogd $0xec,-0x6f8c91(%rip){1to16},%zmm12,%zmm17        # 578bf4 <x86_break_instruction.legacy_forms+0x67c>
  c71885:	62 d1 6d 40 72 e7 1f 	vpsrad $0x1f,%zmm15,%zmm18
  c7188c:	62 72 7e 48 38 f8    	vpmovm2d %k0,%zmm15
  c71892:	62 e3 45 58 25 0d 5b 73 90 ff f8 	vpternlogd $0xf8,-0x6f8ca5(%rip){1to16},%zmm7,%zmm17        # 578bf8 <x86_break_instruction.legacy_forms+0x680>
  c7189d:	62 33 7d 40 25 fa c8 	vpternlogd $0xc8,%zmm18,%zmm16,%zmm15
  c718a4:	62 c1 65 40 ef d2    	vpxord %zmm10,%zmm19,%zmm18
  c718aa:	62 e2 7d 48 58 1d fc 72 90 ff 	vpbroadcastd -0x6f8d04(%rip),%zmm19        # 578bb0 <x86_break_instruction.legacy_forms+0x638>
  c718b4:	62 71 05 58 db 25 3e 73 90 ff 	vpandd -0x6f8cc2(%rip){1to16},%zmm15,%zmm12        # 578bfc <x86_break_instruction.legacy_forms+0x684>
  c718be:	62 a2 7d 48 44 d2    	vplzcntd %zmm18,%zmm18
  c718c4:	62 a2 65 40 45 d2    	vpsrlvd %zmm18,%zmm19,%zmm18
  c718ca:	62 23 2d 48 25 c2 14 	vpternlogd $0x14,%zmm18,%zmm10,%zmm24
  c718d1:	62 a2 3d 40 14 d7    	vprorvd %zmm23,%zmm24,%zmm18
  c718d7:	62 62 7d 48 58 05 d3 72 90 ff 	vpbroadcastd -0x6f8d2d(%rip),%zmm24        # 578bb4 <x86_break_instruction.legacy_forms+0x63c>
  c718e1:	62 b1 6d 40 72 e2 1f 	vpsrad $0x1f,%zmm18,%zmm18
  c718e8:	62 43 05 48 25 c3 ea 	vpternlogd $0xea,%zmm11,%zmm15,%zmm24
  c718ef:	62 03 6d 40 25 d8 b8 	vpternlogd $0xb8,%zmm24,%zmm18,%zmm27
  c718f6:	62 21 35 40 fe c6    	vpaddd %zmm22,%zmm25,%zmm24
  c718fc:	62 d1 35 40 72 d5 08 	vpsrld $0x8,%zmm13,%zmm25
  c71903:	62 63 55 50 25 0d b2 72 90 ff 6c 	vpternlogd $0x6c,-0x6f8d4e(%rip){1to16},%zmm21,%zmm25        # 578bc0 <x86_break_instruction.legacy_forms+0x648>
  c7190e:	62 51 0d 48 eb ed    	vpord  %zmm13,%zmm14,%zmm13
  c71914:	62 d1 15 48 72 f5 07 	vpslld $0x7,%zmm13,%zmm13
  c7191b:	62 a1 35 40 fe ee    	vpaddd %zmm22,%zmm25,%zmm21
  c71921:	62 62 7d 48 58 0d 99 72 90 ff 	vpbroadcastd -0x6f8d67(%rip),%zmm25        # 578bc4 <x86_break_instruction.legacy_forms+0x64c>
  c7192b:	62 63 3d 50 25 0d 92 72 90 ff ea 	vpternlogd $0xea,-0x6f8d6e(%rip){1to16},%zmm24,%zmm25        # 578bc8 <x86_break_instruction.legacy_forms+0x650>
  c71936:	62 61 5d 50 db 05 90 72 90 ff 	vpandd -0x6f8d70(%rip){1to16},%zmm20,%zmm24        # 578bd0 <x86_break_instruction.legacy_forms+0x658>
  c71940:	62 b1 5d 40 72 d4 03 	vpsrld $0x3,%zmm20,%zmm20
  c71947:	62 e3 45 58 25 25 8a 72 90 ff a2 	vpternlogd $0xa2,-0x6f8d76(%rip){1to16},%zmm7,%zmm20        # 578bdc <x86_break_instruction.legacy_forms+0x664>
  c71952:	62 63 55 50 25 0d 6f 72 90 ff f8 	vpternlogd $0xf8,-0x6f8d91(%rip){1to16},%zmm21,%zmm25        # 578bcc <x86_break_instruction.legacy_forms+0x654>
  c7195d:	62 03 45 48 25 c1 f8 	vpternlogd $0xf8,%zmm25,%zmm7,%zmm24
  c71964:	62 e2 3d 50 3b 2d 66 72 90 ff 	vpminud -0x6f8d9a(%rip){1to16},%zmm24,%zmm21        # 578bd4 <x86_break_instruction.legacy_forms+0x65c>
  c7196e:	62 d1 3d 40 72 d3 10 	vpsrld $0x10,%zmm11,%zmm24
  c71975:	62 31 5d 40 fe de    	vpaddd %zmm22,%zmm20,%zmm11
  c7197b:	62 e2 5d 50 3b 25 5b 72 90 ff 	vpminud -0x6f8da5(%rip){1to16},%zmm20,%zmm20        # 578be0 <x86_break_instruction.legacy_forms+0x668>
  c71985:	62 63 3d 50 25 15 48 72 90 ff ec 	vpternlogd $0xec,-0x6f8db8(%rip){1to16},%zmm24,%zmm26        # 578bd8 <x86_break_instruction.legacy_forms+0x660>
  c71990:	62 d1 25 48 72 e3 1f 	vpsrad $0x1f,%zmm11,%zmm11
  c71997:	62 62 7d 48 5a 05 0f 0f 8e ff 	vbroadcasti32x4 -0x71f0f1(%rip),%zmm24        # 5528b0 <x86_disassembly_listing.hex+0xdc0>
  c719a1:	62 a3 5d 40 25 cd fe 	vpternlogd $0xfe,%zmm21,%zmm20,%zmm17
  c719a8:	62 91 4d 40 72 f2 08 	vpslld $0x8,%zmm26,%zmm22
  c719af:	62 e3 25 58 25 35 2a 72 90 ff 08 	vpternlogd $0x8,-0x6f8dd6(%rip){1to16},%zmm11,%zmm22        # 578be4 <x86_break_instruction.legacy_forms+0x66c>
  c719ba:	62 42 bd 40 83 c6    	vpmultishiftqb %zmm14,%zmm24,%zmm24
  c719c0:	62 71 7d 50 db 35 36 72 90 ff 	vpandd -0x6f8dca(%rip){1to16},%zmm16,%zmm14        # 578c00 <x86_break_instruction.legacy_forms+0x688>
  c719ca:	62 63 2d 50 25 05 17 72 90 ff d8 	vpternlogd $0xd8,-0x6f8de9(%rip){1to16},%zmm26,%zmm24        # 578bec <x86_break_instruction.legacy_forms+0x674>
  c719d5:	62 73 4d 50 25 2d 08 72 90 ff e4 	vpternlogd $0xe4,-0x6f8df8(%rip){1to16},%zmm22,%zmm13        # 578be8 <x86_break_instruction.legacy_forms+0x670>
  c719e0:	62 53 6d 40 25 f4 b8 	vpternlogd $0xb8,%zmm12,%zmm18,%zmm14
  c719e7:	62 31 0d 48 eb e1    	vpord  %zmm17,%zmm14,%zmm12
  c719ed:	62 d1 0d 48 72 ca 01 	vprold $0x1,%zmm10,%zmm14
  c719f4:	62 c1 7d 48 70 cc 00 	vpshufd $0x0,%zmm12,%zmm17
  c719fb:	62 f2 75 40 8f c9    	vpshufbitqmb %zmm1,%zmm17,%k1
  c71a01:	c4 e1 fb 93 c1       	kmovq  %k1,%rax
  c71a06:	f3 48 0f b8 c0       	popcnt %rax,%rax
  c71a0b:	62 63 15 58 25 05 da 71 90 ff d8 	vpternlogd $0xd8,-0x6f8e26(%rip){1to16},%zmm13,%zmm24        # 578bf0 <x86_break_instruction.legacy_forms+0x678>
  c71a16:	62 32 0d 48 14 ef    	vprorvd %zmm23,%zmm14,%zmm13
  c71a1c:	49 8d 0c 06          	lea    (%r14,%rax,1),%rcx
  c71a20:	62 53 05 48 25 ea e2 	vpternlogd $0xe2,%zmm10,%zmm15,%zmm13
  c71a27:	62 53 6d 40 25 ea e2 	vpternlogd $0xe2,%zmm10,%zmm18,%zmm13
  c71a2e:	62 51 7d 48 62 d5    	vpunpckldq %zmm13,%zmm0,%zmm10
  c71a34:	62 d1 7d 48 6a c5    	vpunpckhdq %zmm13,%zmm0,%zmm0
  c71a3a:	62 81 25 40 62 c0    	vpunpckldq %zmm24,%zmm27,%zmm16
  c71a40:	62 11 25 40 6a f0    	vpunpckhdq %zmm24,%zmm27,%zmm14
  c71a46:	62 31 ad 48 6c f8    	vpunpcklqdq %zmm16,%zmm10,%zmm15
  c71a4c:	62 31 ad 48 6d d0    	vpunpckhqdq %zmm16,%zmm10,%zmm10
  c71a52:	62 e2 7d 48 5a 05 d4 0d 8e ff 	vbroadcasti32x4 -0x71f22c(%rip),%zmm16        # 552830 <x86_disassembly_listing.hex+0xd40>
  c71a5c:	62 c1 fd 48 6c d6    	vpunpcklqdq %zmm14,%zmm0,%zmm18
  c71a62:	62 d1 fd 48 6d c6    	vpunpckhqdq %zmm14,%zmm0,%zmm0
  c71a68:	62 51 7d 48 70 f4 55 	vpshufd $0x55,%zmm12,%zmm14
  c71a6f:	62 72 05 48 00 f9    	vpshufb %zmm1,%zmm15,%zmm15
  c71a75:	62 d2 7d 48 00 c0    	vpshufb %zmm8,%zmm0,%zmm0
  c71a7b:	62 33 ed 48 25 f8 78 	vpternlogq $0x78,%zmm16,%zmm2,%zmm15
  c71a82:	62 f2 2d 48 00 d3    	vpshufb %zmm3,%zmm10,%zmm2
  c71a88:	62 b3 b5 48 25 c0 78 	vpternlogq $0x78,%zmm16,%zmm9,%zmm0
  c71a8f:	62 72 7d c9 63 f9    	vpcompressb %zmm15,%zmm1{%k1}{z}
  c71a95:	62 f2 0d 48 8f cb    	vpshufbitqmb %zmm3,%zmm14,%k1
  c71a9b:	62 d1 7d 48 70 dc ff 	vpshufd $0xff,%zmm12,%zmm3
  c71aa2:	62 b3 dd 48 25 d0 78 	vpternlogq $0x78,%zmm16,%zmm4,%zmm2
  c71aa9:	62 d1 7d 48 70 e4 aa 	vpshufd $0xaa,%zmm12,%zmm4
  c71ab0:	62 73 45 58 25 25 49 71 90 ff 20 	vpternlogd $0x20,-0x6f8eb7(%rip){1to16},%zmm7,%zmm12        # 578c04 <x86_break_instruction.legacy_forms+0x68c>
  c71abb:	c4 e1 fb 93 d1       	kmovq  %k1,%rdx
  c71ac0:	f3 48 0f b8 d2       	popcnt %rdx,%rdx
  c71ac5:	62 d1 fe 48 7f 0e    	vmovdqu64 %zmm1,(%r14)
  c71acb:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
  c71acf:	62 f2 7d c9 63 d1    	vpcompressb %zmm2,%zmm1{%k1}{z}
  c71ad5:	62 f2 6d 40 00 d5    	vpshufb %zmm5,%zmm18,%zmm2
  c71adb:	62 f2 5d 48 8f cd    	vpshufbitqmb %zmm5,%zmm4,%k1
  c71ae1:	48 8d 34 11          	lea    (%rcx,%rdx,1),%rsi
  c71ae5:	62 b3 cd 48 25 d0 78 	vpternlogq $0x78,%zmm16,%zmm6,%zmm2
  c71aec:	62 d1 fe 48 7f 0c 06 	vmovdqu64 %zmm1,(%r14,%rax,1)
  c71af3:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
  c71af7:	62 f2 7d c9 63 d1    	vpcompressb %zmm2,%zmm1{%k1}{z}
  c71afd:	c4 e1 fb 93 c1       	kmovq  %k1,%rax
  c71b02:	62 d2 65 48 8f c8    	vpshufbitqmb %zmm8,%zmm3,%k1
  c71b08:	62 f1 45 58 db 15 f6 70 90 ff 	vpandd -0x6f8f0a(%rip){1to16},%zmm7,%zmm2        # 578c08 <x86_break_instruction.legacy_forms+0x690>
  c71b12:	41 29 de             	sub    %ebx,%r14d
  c71b15:	f3 48 0f b8 f8       	popcnt %rax,%rdi
  c71b1a:	62 f2 7d c9 63 c0    	vpcompressb %zmm0,%zmm0{%k1}{z}
  c71b20:	c4 e1 fb 93 c1       	kmovq  %k1,%rax
  c71b25:	f3 48 0f b8 c0       	popcnt %rax,%rax
  c71b2a:	62 f1 fe 48 7f 0c 0a 	vmovdqu64 %zmm1,(%rdx,%rcx,1)
  c71b31:	48 c7 c1 ff ff ff ff 	mov    $0xffffffffffffffff,%rcx
  c71b38:	48 01 f8             	add    %rdi,%rax
  c71b3b:	c4 e2 91 f7 c9       	shlx   %r13,%rcx,%rcx
  c71b40:	48 01 f0             	add    %rsi,%rax
  c71b43:	f7 d1                	not    %ecx
  c71b45:	62 f1 fe 48 7f 04 37 	vmovdqu64 %zmm0,(%rdi,%rsi,1)
  c71b4c:	62 d2 7d 48 55 c4    	vpopcntd %zmm12,%zmm0
  c71b52:	62 f1 25 48 fe ca    	vpaddd %zmm2,%zmm11,%zmm1
  c71b58:	44 89 b4 24 fc 00 00 00 	mov    %r14d,0xfc(%rsp)
  c71b60:	c5 fb 92 c9          	kmovd  %ecx,%k1
  c71b64:	62 f1 75 48 fe c0    	vpaddd %zmm0,%zmm1,%zmm0
  c71b6a:	c5 f9 6f 0d ce 0c 8e ff 	vmovdqa -0x71f332(%rip),%xmm1        # 552840 <x86_disassembly_listing.hex+0xd50>
  c71b72:	62 f2 75 48 8d c0    	vpermb %zmm0,%zmm1,%zmm0
  c71b78:	62 f2 fd 18 40 0d 0e 69 90 ff 	vpmullq -0x6f96f2(%rip){1to2},%xmm0,%xmm1        # 578490 <x86_effects_unknown+0x1a90>
  c71b82:	c5 f1 f8 c0          	vpsubb %xmm0,%xmm1,%xmm0
  c71b86:	c4 e2 71 00 0d c1 0c 8e ff 	vpshufb -0x71f33f(%rip),%xmm1,%xmm1        # 552850 <x86_disassembly_listing.hex+0xd60>
  c71b8f:	c5 f9 fc c1          	vpaddb %xmm1,%xmm0,%xmm0
  c71b93:	62 f2 7d 48 31 c0    	vpmovzxbd %xmm0,%zmm0
  c71b99:	62 f1 7d 58 fe 44 24 3f 	vpaddd 0xfc(%rsp){1to16},%zmm0,%zmm0
  c71ba1:	62 91 7e 49 7f 04 bc 	vmovdqu32 %zmm0,(%r12,%r15,4){%k1}
  c71ba8:	48 29 d8             	sub    %rbx,%rax
  c71bab:	49 89 c6             	mov    %rax,%r14
  c71bae:	e9 68 1a 00 00       	jmp    c7361b <x86_encode_64+0x4f7b>
  c71bb3:	62 72 7d 48 5a 1d 73 0c 8e ff 	vbroadcasti32x4 -0x71f38d(%rip),%zmm11        # 552830 <x86_disassembly_listing.hex+0xd40>
  c71bbd:	62 e1 fd 48 6f 35 39 90 7a ff 	vmovdqa64 -0x856fc7(%rip),%zmm22        # 41ac00 <parallel_test_signals_kept.signals+0x3d00>
  c71bc7:	62 f1 fd 48 6f 1d 6f 90 7a ff 	vmovdqa64 -0x856f91(%rip),%zmm3        # 41ac40 <parallel_test_signals_kept.signals+0x3d40>
  c71bd1:	62 f1 fd 48 6f 2d a5 90 7a ff 	vmovdqa64 -0x856f5b(%rip),%zmm5        # 41ac80 <parallel_test_signals_kept.signals+0x3d80>
  c71bdb:	62 71 fd 48 6f 3d db 90 7a ff 	vmovdqa64 -0x856f25(%rip),%zmm15        # 41acc0 <parallel_test_signals_kept.signals+0x3dc0>
  c71be5:	62 f2 7d 48 5a 35 81 0c 8e ff 	vbroadcasti32x4 -0x71f37f(%rip),%zmm6        # 552870 <x86_disassembly_listing.hex+0xd80>
  c71bef:	62 f2 7d 48 5a 3d 87 0c 8e ff 	vbroadcasti32x4 -0x71f379(%rip),%zmm7        # 552880 <x86_disassembly_listing.hex+0xd90>
  c71bf9:	62 72 7d 48 5a 05 8d 0c 8e ff 	vbroadcasti32x4 -0x71f373(%rip),%zmm8        # 552890 <x86_disassembly_listing.hex+0xda0>
  c71c03:	62 72 7d 48 58 0d 97 6f 90 ff 	vpbroadcastd -0x6f9069(%rip),%zmm9        # 578ba4 <x86_break_instruction.legacy_forms+0x62c>
  c71c0d:	62 72 7d 48 58 2d 9d 6f 90 ff 	vpbroadcastd -0x6f9063(%rip),%zmm13        # 578bb4 <x86_break_instruction.legacy_forms+0x63c>
  c71c17:	62 72 7d 48 58 15 cf 6f 90 ff 	vpbroadcastd -0x6f9031(%rip),%zmm10        # 578bf0 <x86_break_instruction.legacy_forms+0x678>
  c71c21:	b0 cc                	mov    $0xcc,%al
  c71c23:	48 8d 97 fc 00 00 00 	lea    0xfc(%rdi),%rdx
  c71c2a:	45 31 db             	xor    %r11d,%r11d
  c71c2d:	4c 8d 0d 4c 07 13 02 	lea    0x213074c(%rip),%r9        # 2da2380 <x86_template_storage>
  c71c34:	48 89 d9             	mov    %rbx,%rcx
  c71c37:	c5 fb 92 c8          	kmovd  %eax,%k1
  c71c3b:	62 71 fd 48 7f 5c 24 02 	vmovdqa64 %zmm11,0x80(%rsp)
  c71c43:	66 66 66 66 2e 0f 1f 84 00 00 00 00 00 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  c71c50:	4c 89 d8             	mov    %r11,%rax
  c71c53:	49 c1 e3 04          	shl    $0x4,%r11
  c71c57:	45 31 d2             	xor    %r10d,%r10d
  c71c5a:	49 01 d3             	add    %rdx,%r11
  c71c5d:	0f 1f 00             	nopl   (%rax)
  c71c60:	45 0f b7 b3 10 ff ff ff 	movzwl -0xf0(%r11),%r14d
  c71c68:	45 0f b7 bb 20 ff ff ff 	movzwl -0xe0(%r11),%r15d
  c71c70:	45 0f b7 a3 30 ff ff ff 	movzwl -0xd0(%r11),%r12d
  c71c78:	45 0f b7 ab 40 ff ff ff 	movzwl -0xc0(%r11),%r13d
  c71c80:	62 c1 fe 48 6f a3 04 ff ff ff 	vmovdqu64 -0xfc(%r11),%zmm20
  c71c8a:	62 41 fe 48 6f 9b 44 ff ff ff 	vmovdqu64 -0xbc(%r11),%zmm27
  c71c94:	62 41 fe 48 6f a3 84 ff ff ff 	vmovdqu64 -0x7c(%r11),%zmm28
  c71c9e:	62 41 fe 48 6f ab c4 ff ff ff 	vmovdqu64 -0x3c(%r11),%zmm29
  c71ca8:	62 d1 fd 48 6f c2    	vmovdqa64 %zmm10,%zmm0
  c71cae:	49 83 c2 f0          	add    $0xfffffffffffffff0,%r10
  c71cb2:	41 c1 e6 06          	shl    $0x6,%r14d
  c71cb6:	41 c1 e7 06          	shl    $0x6,%r15d
  c71cba:	41 c1 e4 06          	shl    $0x6,%r12d
  c71cbe:	41 c1 e5 06          	shl    $0x6,%r13d
  c71cc2:	c4 81 7d 6f 4c 0e 40 	vmovdqa 0x40(%r14,%r9,1),%ymm1
  c71cc9:	45 0f b7 b3 50 ff ff ff 	movzwl -0xb0(%r11),%r14d
  c71cd1:	62 13 f5 48 3a 5c 0c 02 01 	vinserti64x4 $0x1,0x40(%r12,%r9,1),%zmm1,%zmm11
  c71cda:	45 0f b7 a3 70 ff ff ff 	movzwl -0x90(%r11),%r12d
  c71ce2:	c4 81 7d 6f 4c 0f 60 	vmovdqa 0x60(%r15,%r9,1),%ymm1
  c71ce9:	45 0f b7 bb 60 ff ff ff 	movzwl -0xa0(%r11),%r15d
  c71cf1:	62 83 f5 48 3a 4c 0d 03 01 	vinserti64x4 $0x1,0x60(%r13,%r9,1),%zmm1,%zmm17
  c71cfa:	45 0f b7 6b 80       	movzwl -0x80(%r11),%r13d
  c71cff:	62 11 5d 40 62 e3    	vpunpckldq %zmm27,%zmm20,%zmm12
  c71d05:	62 11 1d 40 62 f5    	vpunpckldq %zmm29,%zmm28,%zmm14
  c71d0b:	62 01 5d 40 6a db    	vpunpckhdq %zmm27,%zmm20,%zmm27
  c71d11:	62 01 1d 40 6a ed    	vpunpckhdq %zmm29,%zmm28,%zmm29
  c71d17:	62 11 a5 40 6c d5    	vpunpcklqdq %zmm29,%zmm27,%zmm10
  c71d1d:	62 41 9d 48 6d f6    	vpunpckhqdq %zmm14,%zmm12,%zmm30
  c71d23:	62 92 0d 40 27 c6    	vptestmd %zmm30,%zmm30,%k0
  c71d29:	62 41 fd 48 6f e2    	vmovdqa64 %zmm10,%zmm28
  c71d2f:	41 c1 e6 06          	shl    $0x6,%r14d
  c71d33:	c4 81 7d 6f 4c 0e 40 	vmovdqa 0x40(%r14,%r9,1),%ymm1
  c71d3a:	45 0f b7 73 90       	movzwl -0x70(%r11),%r14d
  c71d3f:	41 c1 e4 06          	shl    $0x6,%r12d
  c71d43:	41 c1 e7 06          	shl    $0x6,%r15d
  c71d47:	62 83 f5 48 3a 44 0c 02 01 	vinserti64x4 $0x1,0x40(%r12,%r9,1),%zmm1,%zmm16
  c71d50:	45 0f b7 63 b0       	movzwl -0x50(%r11),%r12d
  c71d55:	c4 81 7d 6f 4c 0f 60 	vmovdqa 0x60(%r15,%r9,1),%ymm1
  c71d5c:	45 0f b7 7b a0       	movzwl -0x60(%r11),%r15d
  c71d61:	41 c1 e5 06          	shl    $0x6,%r13d
  c71d65:	62 03 f5 48 3a 44 0d 03 01 	vinserti64x4 $0x1,0x60(%r13,%r9,1),%zmm1,%zmm24
  c71d6e:	45 0f b7 6b c0       	movzwl -0x40(%r11),%r13d
  c71d73:	62 b2 a5 49 64 d1    	vpblendmq %zmm17,%zmm11,%zmm2{%k1}
  c71d79:	62 32 cd 40 7e d9    	vpermt2q %zmm17,%zmm22,%zmm11
  c71d7f:	62 e2 7d 48 5a 0d 27 0b 8e ff 	vbroadcasti32x4 -0x71f4d9(%rip),%zmm17        # 5528b0 <x86_disassembly_listing.hex+0xdc0>
  c71d89:	41 c1 e6 06          	shl    $0x6,%r14d
  c71d8d:	62 f1 fd 48 7f 54 24 01 	vmovdqa64 %zmm2,0x40(%rsp)
  c71d95:	c4 81 7d 6f 4c 0e 40 	vmovdqa 0x40(%r14,%r9,1),%ymm1
  c71d9c:	45 0f b7 73 d0       	movzwl -0x30(%r11),%r14d
  c71da1:	41 c1 e4 06          	shl    $0x6,%r12d
  c71da5:	41 c1 e7 06          	shl    $0x6,%r15d
  c71da9:	62 83 f5 48 3a 54 0c 02 01 	vinserti64x4 $0x1,0x40(%r12,%r9,1),%zmm1,%zmm18
  c71db2:	45 0f b7 63 f0       	movzwl -0x10(%r11),%r12d
  c71db7:	c4 81 7d 6f 4c 0f 60 	vmovdqa 0x60(%r15,%r9,1),%ymm1
  c71dbe:	45 0f b7 7b e0       	movzwl -0x20(%r11),%r15d
  c71dc3:	41 c1 e5 06          	shl    $0x6,%r13d
  c71dc7:	62 03 f5 48 3a 4c 0d 03 01 	vinserti64x4 $0x1,0x60(%r13,%r9,1),%zmm1,%zmm25
  c71dd0:	45 0f b7 2b          	movzwl (%r11),%r13d
  c71dd4:	49 81 c3 00 01 00 00 	add    $0x100,%r11
  c71ddb:	62 92 fd 41 64 e0    	vpblendmq %zmm24,%zmm16,%zmm4{%k1}
  c71de1:	62 82 cd 40 7e c0    	vpermt2q %zmm24,%zmm22,%zmm16
  c71de7:	62 62 7d 48 58 05 e7 6d 90 ff 	vpbroadcastd -0x6f9219(%rip),%zmm24        # 578bd8 <x86_break_instruction.legacy_forms+0x660>
  c71df1:	41 c1 e6 06          	shl    $0x6,%r14d
  c71df5:	62 f1 fd 48 7f 24 24 	vmovdqa64 %zmm4,(%rsp)
  c71dfc:	41 c1 e7 06          	shl    $0x6,%r15d
  c71e00:	41 c1 e4 06          	shl    $0x6,%r12d
  c71e04:	c4 81 7d 6f 4c 0e 40 	vmovdqa 0x40(%r14,%r9,1),%ymm1
  c71e0b:	62 83 f5 48 3a 6c 0c 02 01 	vinserti64x4 $0x1,0x40(%r12,%r9,1),%zmm1,%zmm21
  c71e14:	41 c1 e5 06          	shl    $0x6,%r13d
  c71e18:	c4 81 7d 6f 4c 0f 60 	vmovdqa 0x60(%r15,%r9,1),%ymm1
  c71e1f:	62 03 f5 48 3a 54 0d 03 01 	vinserti64x4 $0x1,0x60(%r13,%r9,1),%zmm1,%zmm26
  c71e28:	62 f1 6d 48 6a cc    	vpunpckhdq %zmm4,%zmm2,%zmm1
  c71e2e:	62 d1 5d 48 72 d2 1a 	vpsrld $0x1a,%zmm10,%zmm4
  c71e35:	62 62 5d 48 36 fd    	vpermd %zmm5,%zmm4,%zmm31
  c71e3b:	62 82 ed 41 64 d9    	vpblendmq %zmm25,%zmm18,%zmm19{%k1}
  c71e41:	62 82 cd 40 7e d1    	vpermt2q %zmm25,%zmm22,%zmm18
  c71e47:	62 82 d5 41 64 fa    	vpblendmq %zmm26,%zmm21,%zmm23{%k1}
  c71e4d:	62 82 cd 40 7e ea    	vpermt2q %zmm26,%zmm22,%zmm21
  c71e53:	62 b1 65 40 6a d7    	vpunpckhdq %zmm23,%zmm19,%zmm2
  c71e59:	62 e1 f5 48 6d e2    	vpunpckhqdq %zmm2,%zmm1,%zmm20
  c71e5f:	62 f2 5d 48 36 d3    	vpermd %zmm3,%zmm4,%zmm2
  c71e65:	62 d2 cd 48 83 ca    	vpmultishiftqb %zmm10,%zmm6,%zmm1
  c71e6b:	62 d2 c5 48 83 da    	vpmultishiftqb %zmm10,%zmm7,%zmm3
  c71e71:	62 d2 bd 48 83 f2    	vpmultishiftqb %zmm10,%zmm8,%zmm6
  c71e77:	62 d2 5d 48 36 e7    	vpermd %zmm15,%zmm4,%zmm4
  c71e7d:	62 72 7d 48 58 3d 25 6d 90 ff 	vpbroadcastd -0x6f92db(%rip),%zmm15        # 578bac <x86_break_instruction.legacy_forms+0x634>
  c71e87:	62 91 3d 48 72 e6 1f 	vpsrad $0x1f,%zmm30,%zmm8
  c71e8e:	62 d3 75 48 25 d9 d8 	vpternlogd $0xd8,%zmm9,%zmm1,%zmm3
  c71e95:	62 72 7d 48 58 0d 29 6d 90 ff 	vpbroadcastd -0x6f92d7(%rip),%zmm9        # 578bc8 <x86_break_instruction.legacy_forms+0x650>
  c71e9f:	62 d1 75 48 72 f2 04 	vpslld $0x4,%zmm10,%zmm1
  c71ea6:	62 f3 65 58 25 35 f7 6c 90 ff e4 	vpternlogd $0xe4,-0x6f9309(%rip){1to16},%zmm3,%zmm6        # 578ba8 <x86_break_instruction.legacy_forms+0x630>
  c71eb1:	62 f2 7d 48 5a 1d e5 09 8e ff 	vbroadcasti32x4 -0x71f61b(%rip),%zmm3        # 5528a0 <x86_disassembly_listing.hex+0xdb0>
  c71ebb:	62 63 05 58 25 25 f6 6c 90 ff 6c 	vpternlogd $0x6c,-0x6f930a(%rip){1to16},%zmm15,%zmm28        # 578bbc <x86_break_instruction.legacy_forms+0x644>
  c71ec6:	62 61 1d 50 fe 25 3c 6d 90 ff 	vpaddd -0x6f92c4(%rip){1to16},%zmm28,%zmm28        # 578c0c <x86_break_instruction.legacy_forms+0x694>
  c71ed0:	62 d2 65 48 00 ea    	vpshufb %zmm10,%zmm3,%zmm5
  c71ed6:	62 63 4d 48 25 fa f8 	vpternlogd $0xf8,%zmm2,%zmm6,%zmm31
  c71edd:	62 f1 6d 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm2
  c71ee4:	62 f1 fd 48 6f df    	vmovdqa64 %zmm7,%zmm3
  c71eea:	62 63 35 58 25 25 cf 6c 90 ff ec 	vpternlogd $0xec,-0x6f9331(%rip){1to16},%zmm9,%zmm28        # 578bc4 <x86_break_instruction.legacy_forms+0x64c>
  c71ef5:	62 71 4d 58 db 0d d1 6c 90 ff 	vpandd -0x6f932f(%rip){1to16},%zmm6,%zmm9        # 578bd0 <x86_break_instruction.legacy_forms+0x658>
  c71eff:	62 f1 4d 48 72 d6 03 	vpsrld $0x3,%zmm6,%zmm6
  c71f06:	62 f3 5d 50 25 35 cb 6c 90 ff a2 	vpternlogd $0xa2,-0x6f9335(%rip){1to16},%zmm20,%zmm6        # 578bdc <x86_break_instruction.legacy_forms+0x664>
  c71f11:	62 f1 75 48 72 f5 10 	vpslld $0x10,%zmm5,%zmm1
  c71f18:	62 f1 6d 48 db ed    	vpandd %zmm5,%zmm2,%zmm5
  c71f1e:	62 f3 5d 58 25 2d cb 6c 90 ff ec 	vpternlogd $0xec,-0x6f9335(%rip){1to16},%zmm4,%zmm5        # 578bf4 <x86_break_instruction.legacy_forms+0x67c>
  c71f29:	62 f2 4d 58 3b 25 ad 6c 90 ff 	vpminud -0x6f9353(%rip){1to16},%zmm6,%zmm4        # 578be0 <x86_break_instruction.legacy_forms+0x668>
  c71f33:	62 f1 45 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm7
  c71f3a:	62 f2 7e 48 38 c8    	vpmovm2d %k0,%zmm1
  c71f40:	62 f3 5d 50 25 2d ad 6c 90 ff f8 	vpternlogd $0xf8,-0x6f9353(%rip){1to16},%zmm20,%zmm5        # 578bf8 <x86_break_instruction.legacy_forms+0x680>
  c71f4b:	62 f3 6d 48 25 cf c8 	vpternlogd $0xc8,%zmm7,%zmm2,%zmm1
  c71f52:	62 91 3d 48 ef fe    	vpxord %zmm30,%zmm8,%zmm7
  c71f58:	62 72 7d 48 58 05 4e 6c 90 ff 	vpbroadcastd -0x6f93b2(%rip),%zmm8        # 578bb0 <x86_break_instruction.legacy_forms+0x638>
  c71f62:	62 f2 7d 48 44 ff    	vplzcntd %zmm7,%zmm7
  c71f68:	62 f2 3d 48 45 ff    	vpsrlvd %zmm7,%zmm8,%zmm7
  c71f6e:	62 53 3d 48 25 c0 ff 	vpternlogd $0xff,%zmm8,%zmm8,%zmm8
  c71f75:	62 51 0d 40 fe c0    	vpaddd %zmm8,%zmm30,%zmm8
  c71f7b:	62 73 0d 40 25 c7 14 	vpternlogd $0x14,%zmm7,%zmm30,%zmm8
  c71f82:	62 d1 45 48 72 d2 08 	vpsrld $0x8,%zmm10,%zmm7
  c71f89:	62 f3 05 58 25 3d 2c 6c 90 ff 6c 	vpternlogd $0x6c,-0x6f93d4(%rip){1to16},%zmm15,%zmm7        # 578bc0 <x86_break_instruction.legacy_forms+0x648>
  c71f94:	62 71 75 58 db 3d 5e 6c 90 ff 	vpandd -0x6f93a2(%rip){1to16},%zmm1,%zmm15        # 578bfc <x86_break_instruction.legacy_forms+0x684>
  c71f9e:	62 f1 45 58 fe 3d 64 6c 90 ff 	vpaddd -0x6f939c(%rip){1to16},%zmm7,%zmm7        # 578c0c <x86_break_instruction.legacy_forms+0x694>
  c71fa8:	62 f3 1d 50 25 3d 19 6c 90 ff ec 	vpternlogd $0xec,-0x6f93e7(%rip){1to16},%zmm28,%zmm7        # 578bcc <x86_break_instruction.legacy_forms+0x654>
  c71fb3:	62 73 5d 40 25 cf f8 	vpternlogd $0xf8,%zmm7,%zmm20,%zmm9
  c71fba:	62 62 35 58 3b 25 10 6c 90 ff 	vpminud -0x6f93f0(%rip){1to16},%zmm9,%zmm28        # 578bd4 <x86_break_instruction.legacy_forms+0x65c>
  c71fc4:	62 91 35 48 72 ce 01 	vprold $0x1,%zmm30,%zmm9
  c71fcb:	62 b1 45 48 72 d4 1d 	vpsrld $0x1d,%zmm20,%zmm7
  c71fd2:	62 72 3d 48 14 c7    	vprorvd %zmm7,%zmm8,%zmm8
  c71fd8:	62 f2 35 48 14 ff    	vprorvd %zmm7,%zmm9,%zmm7
  c71fde:	62 72 7d 48 58 0d fc 6b 90 ff 	vpbroadcastd -0x6f9404(%rip),%zmm9        # 578be4 <x86_break_instruction.legacy_forms+0x66c>
  c71fe8:	62 d1 3d 48 72 e0 1f 	vpsrad $0x1f,%zmm8,%zmm8
  c71fef:	62 93 75 48 25 fe e2 	vpternlogd $0xe2,%zmm30,%zmm1,%zmm7
  c71ff6:	62 93 3d 48 25 fe e2 	vpternlogd $0xe2,%zmm30,%zmm8,%zmm7
  c71ffd:	62 93 5d 48 25 ec fe 	vpternlogd $0xfe,%zmm28,%zmm4,%zmm5
  c72004:	62 91 fd 48 6f e7    	vmovdqa64 %zmm31,%zmm4
  c7200a:	62 f3 6d 58 25 25 a3 6b 90 ff f8 	vpternlogd $0xf8,-0x6f945d(%rip){1to16},%zmm2,%zmm4        # 578bb8 <x86_break_instruction.legacy_forms+0x640>
  c72015:	62 f1 6d 58 db 15 e1 6b 90 ff 	vpandd -0x6f941f(%rip){1to16},%zmm2,%zmm2        # 578c00 <x86_break_instruction.legacy_forms+0x688>
  c7201f:	62 01 fd 48 6f e7    	vmovdqa64 %zmm31,%zmm28
  c72025:	62 43 75 48 25 e5 f8 	vpternlogd $0xf8,%zmm13,%zmm1,%zmm28
  c7202c:	62 91 75 48 72 d7 10 	vpsrld $0x10,%zmm31,%zmm1
  c72033:	62 d3 3d 48 25 d7 b8 	vpternlogd $0xb8,%zmm15,%zmm8,%zmm2
  c7203a:	62 91 05 48 72 d7 03 	vpsrld $0x3,%zmm31,%zmm15
  c72041:	62 93 3d 48 25 e4 b8 	vpternlogd $0xb8,%zmm28,%zmm8,%zmm4
  c72048:	62 51 9d 48 6c c6    	vpunpcklqdq %zmm14,%zmm12,%zmm8
  c7204e:	62 53 1d 48 25 e4 ff 	vpternlogd $0xff,%zmm12,%zmm12,%zmm12
  c72055:	62 11 a5 40 6d f5    	vpunpckhqdq %zmm29,%zmm27,%zmm14
  c7205b:	62 13 75 48 25 f8 ec 	vpternlogd $0xec,%zmm24,%zmm1,%zmm15
  c72062:	62 d1 4d 48 fe cc    	vpaddd %zmm12,%zmm6,%zmm1
  c72068:	62 62 7d 48 58 05 76 6b 90 ff 	vpbroadcastd -0x6f948a(%rip),%zmm24        # 578be8 <x86_break_instruction.legacy_forms+0x670>
  c72072:	62 51 0d 48 eb d2    	vpord  %zmm10,%zmm14,%zmm10
  c72078:	62 f1 6d 48 eb d5    	vpord  %zmm5,%zmm2,%zmm2
  c7207e:	62 f1 3d 48 62 ef    	vpunpckldq %zmm7,%zmm8,%zmm5
  c72084:	62 f1 3d 48 6a ff    	vpunpckhdq %zmm7,%zmm8,%zmm7
  c7208a:	62 72 7d 48 58 25 70 6b 90 ff 	vpbroadcastd -0x6f9490(%rip),%zmm12        # 578c04 <x86_break_instruction.legacy_forms+0x68c>
  c72094:	62 f1 75 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm1
  c7209b:	62 d1 4d 48 72 f7 08 	vpslld $0x8,%zmm15,%zmm6
  c720a2:	62 d1 2d 48 72 f2 07 	vpslld $0x7,%zmm10,%zmm10
  c720a9:	62 d3 75 48 25 f1 08 	vpternlogd $0x8,%zmm9,%zmm1,%zmm6
  c720b0:	62 72 7d 48 58 0d 32 6b 90 ff 	vpbroadcastd -0x6f94ce(%rip),%zmm9        # 578bec <x86_break_instruction.legacy_forms+0x674>
  c720ba:	62 13 4d 48 25 d0 e4 	vpternlogd $0xe4,%zmm24,%zmm6,%zmm10
  c720c1:	62 d2 f5 40 83 f6    	vpmultishiftqb %zmm14,%zmm17,%zmm6
  c720c7:	62 d3 05 48 25 f1 d8 	vpternlogd $0xd8,%zmm9,%zmm15,%zmm6
  c720ce:	62 72 7d 48 58 0d cc 6a 90 ff 	vpbroadcastd -0x6f9534(%rip),%zmm9        # 578ba4 <x86_break_instruction.legacy_forms+0x62c>
  c720d8:	62 f3 2d 48 25 f0 d8 	vpternlogd $0xd8,%zmm0,%zmm10,%zmm6
  c720df:	62 71 fd 48 6f d0    	vmovdqa64 %zmm0,%zmm10
  c720e5:	62 f1 7d 48 70 c2 00 	vpshufd $0x0,%zmm2,%zmm0
  c720ec:	62 71 5d 48 62 c6    	vpunpckldq %zmm6,%zmm4,%zmm8
  c720f2:	62 f1 5d 48 6a e6    	vpunpckhdq %zmm6,%zmm4,%zmm4
  c720f8:	62 d2 7d 48 8f db    	vpshufbitqmb %zmm11,%zmm0,%k3
  c720fe:	62 f1 7d 48 70 c2 55 	vpshufd $0x55,%zmm2,%zmm0
  c72105:	62 d1 d5 48 6c f0    	vpunpcklqdq %zmm8,%zmm5,%zmm6
  c7210b:	62 d1 d5 48 6d e8    	vpunpckhqdq %zmm8,%zmm5,%zmm5
  c72111:	62 b2 7d 48 8f d0    	vpshufbitqmb %zmm16,%zmm0,%k2
  c72117:	62 f1 7d 48 70 c2 aa 	vpshufd $0xaa,%zmm2,%zmm0
  c7211e:	62 71 c5 48 6c fc    	vpunpcklqdq %zmm4,%zmm7,%zmm15
  c72124:	62 f1 c5 48 6d e4    	vpunpckhqdq %zmm4,%zmm7,%zmm4
  c7212a:	62 f1 fd 48 6f fb    	vmovdqa64 %zmm3,%zmm7
  c72130:	62 72 7d 48 5a 05 56 07 8e ff 	vbroadcasti32x4 -0x71f8aa(%rip),%zmm8        # 552890 <x86_disassembly_listing.hex+0xda0>
  c7213a:	62 d2 4d 48 00 f3    	vpshufb %zmm11,%zmm6,%zmm6
  c72140:	62 71 fd 48 6f 5c 24 02 	vmovdqa64 0x80(%rsp),%zmm11
  c72148:	62 b2 55 48 00 e8    	vpshufb %zmm16,%zmm5,%zmm5
  c7214e:	62 b2 05 48 00 da    	vpshufb %zmm18,%zmm15,%zmm3
  c72154:	62 b2 5d 48 00 e5    	vpshufb %zmm21,%zmm4,%zmm4
  c7215a:	62 71 fd 48 6f 3d 5c 8b 7a ff 	vmovdqa64 -0x8574a4(%rip),%zmm15        # 41acc0 <parallel_test_signals_kept.signals+0x3dc0>
  c72164:	c4 61 fb 93 f3       	kmovq  %k3,%r14
  c72169:	c4 61 fb 93 fa       	kmovq  %k2,%r15
  c7216e:	f3 4d 0f b8 f6       	popcnt %r14,%r14
  c72173:	f3 4d 0f b8 ff       	popcnt %r15,%r15
  c72178:	62 f3 a5 48 25 74 24 01 78 	vpternlogq $0x78,0x40(%rsp),%zmm11,%zmm6
  c72181:	62 f3 a5 48 25 2c 24 78 	vpternlogq $0x78,(%rsp),%zmm11,%zmm5
  c72189:	62 d3 e5 40 25 db 78 	vpternlogq $0x78,%zmm11,%zmm19,%zmm3
  c72190:	62 d3 c5 40 25 e3 78 	vpternlogq $0x78,%zmm11,%zmm23,%zmm4
  c72197:	c4 62 79 59 1d f0 62 90 ff 	vpbroadcastq -0x6f9d10(%rip),%xmm11        # 578490 <x86_effects_unknown+0x1a90>
  c721a0:	62 f2 7d cb 63 f6    	vpcompressb %zmm6,%zmm6{%k3}{z}
  c721a6:	62 b2 7d 48 8f da    	vpshufbitqmb %zmm18,%zmm0,%k3
  c721ac:	62 f1 7d 48 70 c2 ff 	vpshufd $0xff,%zmm2,%zmm0
  c721b3:	62 f2 7d ca 63 ed    	vpcompressb %zmm5,%zmm5{%k2}{z}
  c721b9:	62 d3 5d 40 25 d4 20 	vpternlogd $0x20,%zmm12,%zmm20,%zmm2
  c721c0:	62 b2 7d 48 8f d5    	vpshufbitqmb %zmm21,%zmm0,%k2
  c721c6:	62 f2 7d 48 58 05 38 6a 90 ff 	vpbroadcastd -0x6f95c8(%rip),%zmm0        # 578c08 <x86_break_instruction.legacy_forms+0x690>
  c721d0:	62 f2 7d 48 55 d2    	vpopcntd %zmm2,%zmm2
  c721d6:	62 f2 7d ca 63 e4    	vpcompressb %zmm4,%zmm4{%k2}{z}
  c721dc:	62 f1 fe 48 7f 31    	vmovdqu64 %zmm6,(%rcx)
  c721e2:	62 b1 fe 48 7f 2c 31 	vmovdqu64 %zmm5,(%rcx,%r14,1)
  c721e9:	c5 d1 ef ed          	vpxor  %xmm5,%xmm5,%xmm5
  c721ed:	62 f2 7d cb 63 dd    	vpcompressb %zmm3,%zmm5{%k3}{z}
  c721f3:	49 01 ce             	add    %rcx,%r14
  c721f6:	29 d9                	sub    %ebx,%ecx
  c721f8:	62 f2 7d 48 5a 35 6e 06 8e ff 	vbroadcasti32x4 -0x71f992(%rip),%zmm6        # 552870 <x86_disassembly_listing.hex+0xd80>
  c72202:	62 f1 fd 48 6f 1d 34 8a 7a ff 	vmovdqa64 -0x8575cc(%rip),%zmm3        # 41ac40 <parallel_test_signals_kept.signals+0x3d40>
  c7220c:	62 f1 5d 40 db c0    	vpandd %zmm0,%zmm20,%zmm0
  c72212:	62 f1 75 48 fe c8    	vpaddd %zmm0,%zmm1,%zmm1
  c72218:	c5 f9 6f 05 40 06 8e ff 	vmovdqa -0x71f9c0(%rip),%xmm0        # 552860 <x86_disassembly_listing.hex+0xd70>
  c72220:	62 91 fe 48 7f 2c 37 	vmovdqu64 %zmm5,(%r15,%r14,1)
  c72227:	4d 01 fe             	add    %r15,%r14
  c7222a:	c4 61 fb 93 fb       	kmovq  %k3,%r15
  c7222f:	62 f1 fd 48 6f 2d 47 8a 7a ff 	vmovdqa64 -0x8575b9(%rip),%zmm5        # 41ac80 <parallel_test_signals_kept.signals+0x3d80>
  c72239:	f3 4d 0f b8 ff       	popcnt %r15,%r15
  c7223e:	62 f1 75 48 fe ca    	vpaddd %zmm2,%zmm1,%zmm1
  c72244:	62 91 fe 48 7f 24 37 	vmovdqu64 %zmm4,(%r15,%r14,1)
  c7224b:	89 8c 24 00 01 00 00 	mov    %ecx,0x100(%rsp)
  c72252:	c4 e1 fb 93 ca       	kmovq  %k2,%rcx
  c72257:	f3 48 0f b8 c9       	popcnt %rcx,%rcx
  c7225c:	4c 01 f9             	add    %r15,%rcx
  c7225f:	4c 01 f1             	add    %r14,%rcx
  c72262:	62 f1 fd 48 6f e0    	vmovdqa64 %zmm0,%zmm4
  c72268:	c5 f9 6f 05 d0 05 8e ff 	vmovdqa -0x71fa30(%rip),%xmm0        # 552840 <x86_disassembly_listing.hex+0xd50>
  c72270:	62 d2 5d 48 8d d6    	vpermb %zmm14,%zmm4,%zmm2
  c72276:	c5 f9 6f 25 d2 05 8e ff 	vmovdqa -0x71fa2e(%rip),%xmm4        # 552850 <x86_disassembly_listing.hex+0xd60>
  c7227e:	62 f2 7e 48 29 da    	vpmovb2m %zmm2,%k3
  c72284:	c5 7b 93 f3          	kmovd  %k3,%r14d
  c72288:	45 0f b7 f6          	movzwl %r14w,%r14d
  c7228c:	62 f2 7d 48 8d c9    	vpermb %zmm1,%zmm0,%zmm1
  c72292:	f3 45 0f b8 f6       	popcnt %r14d,%r14d
  c72297:	62 d2 f5 08 40 cb    	vpmullq %xmm11,%xmm1,%xmm1
  c7229d:	c4 e2 71 00 d4       	vpshufb %xmm4,%xmm1,%xmm2
  c722a2:	c5 e9 fc c9          	vpaddb %xmm1,%xmm2,%xmm1
  c722a6:	62 f2 7d 48 31 c9    	vpmovzxbd %xmm1,%zmm1
  c722ac:	62 f1 75 58 fe 4c 24 40 	vpaddd 0x100(%rsp){1to16},%zmm1,%zmm1
  c722b4:	62 f2 7d cb 8b c9    	vpcompressd %zmm1,%zmm1{%k3}{z}
  c722ba:	62 d1 fe 48 7f 08    	vmovdqu64 %zmm1,(%r8)
  c722c0:	4f 8d 04 b0          	lea    (%r8,%r14,4),%r8
  c722c4:	49 83 fa c0          	cmp    $0xffffffffffffffc0,%r10
  c722c8:	0f 85 92 f9 ff ff    	jne    c71c60 <x86_encode_64+0x35c0>
  c722ce:	49 89 c3             	mov    %rax,%r11
  c722d1:	4d 29 d3             	sub    %r10,%r11
  c722d4:	4d 8d 73 40          	lea    0x40(%r11),%r14
  c722d8:	49 39 f6             	cmp    %rsi,%r14
  c722db:	0f 86 6f f9 ff ff    	jbe    c71c50 <x86_encode_64+0x35b0>
  c722e1:	4c 29 d0             	sub    %r10,%rax
  c722e4:	48 8d 50 10          	lea    0x10(%rax),%rdx
  c722e8:	48 39 f2             	cmp    %rsi,%rdx
  c722eb:	0f 86 db d0 ff ff    	jbe    c6f3cc <x86_encode_64+0xd2c>
  c722f1:	49 89 ce             	mov    %rcx,%r14
  c722f4:	49 89 c2             	mov    %rax,%r10
  c722f7:	4c 29 d6             	sub    %r10,%rsi
  c722fa:	0f 86 18 13 00 00    	jbe    c73618 <x86_encode_64+0x4f78>
  c72300:	49 c1 e2 04          	shl    $0x4,%r10
  c72304:	48 c1 e6 04          	shl    $0x4,%rsi
  c72308:	48 8d 84 24 00 01 00 00 	lea    0x100(%rsp),%rax
  c72310:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
  c72314:	62 f1 fd 48 7f 44 24 07 	vmovdqa64 %zmm0,0x1c0(%rsp)
  c7231c:	62 f1 fd 48 7f 44 24 06 	vmovdqa64 %zmm0,0x180(%rsp)
  c72324:	62 f1 fd 48 7f 44 24 05 	vmovdqa64 %zmm0,0x140(%rsp)
  c7232c:	62 f1 fd 48 7f 44 24 04 	vmovdqa64 %zmm0,0x100(%rsp)
  c72334:	4d 89 c7             	mov    %r8,%r15
  c72337:	4c 01 d7             	add    %r10,%rdi
  c7233a:	48 89 f2             	mov    %rsi,%rdx
  c7233d:	48 89 f9             	mov    %rdi,%rcx
  c72340:	48 89 c7             	mov    %rax,%rdi
  c72343:	48 89 ce             	mov    %rcx,%rsi
  c72346:	c5 f8 77             	vzeroupper
  c72349:	e8 02 21 af ff       	call   764450 <memcpy@plt>
  c7234e:	c5 f9 6f 8c 24 00 01 00 00 	vmovdqa 0x100(%rsp),%xmm1
  c72357:	c5 f9 6f 94 24 10 01 00 00 	vmovdqa 0x110(%rsp),%xmm2
  c72360:	c5 f9 6f 9c 24 20 01 00 00 	vmovdqa 0x120(%rsp),%xmm3
  c72369:	c5 f9 6f a4 24 30 01 00 00 	vmovdqa 0x130(%rsp),%xmm4
  c72372:	48 8d 05 07 00 13 02 	lea    0x2130007(%rip),%rax        # 2da2380 <x86_template_storage>
  c72379:	c5 f9 6f b4 24 40 01 00 00 	vmovdqa 0x140(%rsp),%xmm6
  c72382:	62 71 fd 48 6f 3d 74 88 7a ff 	vmovdqa64 -0x85778c(%rip),%zmm15        # 41ac00 <parallel_test_signals_kept.signals+0x3d00>
  c7238c:	c5 f9 6f bc 24 80 01 00 00 	vmovdqa 0x180(%rsp),%xmm7
  c72395:	c5 79 6f 84 24 a0 01 00 00 	vmovdqa 0x1a0(%rsp),%xmm8
  c7239e:	62 f1 fd 48 6f 6c 24 04 	vmovdqa64 0x100(%rsp),%zmm5
  c723a6:	62 71 fd 48 6f 54 24 05 	vmovdqa64 0x140(%rsp),%zmm10
  c723ae:	62 71 fd 48 6f 5c 24 06 	vmovdqa64 0x180(%rsp),%zmm11
  c723b6:	62 71 fd 48 6f 64 24 07 	vmovdqa64 0x1c0(%rsp),%zmm12
  c723be:	62 e2 7d 48 5a 0d c8 04 8e ff 	vbroadcasti32x4 -0x71fb38(%rip),%zmm17        # 552890 <x86_disassembly_listing.hex+0xda0>
  c723c8:	62 a3 4d 40 25 f6 ff 	vpternlogd $0xff,%zmm22,%zmm22,%zmm22
  c723cf:	62 e2 7d 48 58 2d d3 67 90 ff 	vpbroadcastd -0x6f982d(%rip),%zmm21        # 578bac <x86_break_instruction.legacy_forms+0x634>
  c723d9:	62 62 7d 48 58 1d d5 67 90 ff 	vpbroadcastd -0x6f982b(%rip),%zmm27        # 578bb8 <x86_break_instruction.legacy_forms+0x640>
  c723e3:	62 62 7d 48 58 0d cf 67 90 ff 	vpbroadcastd -0x6f9831(%rip),%zmm25        # 578bbc <x86_break_instruction.legacy_forms+0x644>
  c723ed:	c5 f9 c5 c9 06       	vpextrw $0x6,%xmm1,%ecx
  c723f2:	c5 f9 c5 d2 06       	vpextrw $0x6,%xmm2,%edx
  c723f7:	c5 f9 c5 fc 06       	vpextrw $0x6,%xmm4,%edi
  c723fc:	c5 f9 c5 f3 06       	vpextrw $0x6,%xmm3,%esi
  c72401:	c5 f9 6f a4 24 50 01 00 00 	vmovdqa 0x150(%rsp),%xmm4
  c7240a:	62 51 55 48 62 ea    	vpunpckldq %zmm10,%zmm5,%zmm13
  c72410:	62 51 25 48 62 f4    	vpunpckldq %zmm12,%zmm11,%zmm14
  c72416:	62 d1 55 48 6a ea    	vpunpckhdq %zmm10,%zmm5,%zmm5
  c7241c:	62 51 25 48 6a d4    	vpunpckhdq %zmm12,%zmm11,%zmm10
  c72422:	c1 e1 06             	shl    $0x6,%ecx
  c72425:	c1 e2 06             	shl    $0x6,%edx
  c72428:	c1 e6 06             	shl    $0x6,%esi
  c7242b:	c1 e7 06             	shl    $0x6,%edi
  c7242e:	62 51 95 48 6d de    	vpunpckhqdq %zmm14,%zmm13,%zmm11
  c72434:	62 d1 95 48 6c c6    	vpunpcklqdq %zmm14,%zmm13,%zmm0
  c7243a:	62 51 d5 48 6c f2    	vpunpcklqdq %zmm10,%zmm5,%zmm14
  c72440:	62 d1 d5 48 6d ea    	vpunpckhqdq %zmm10,%zmm5,%zmm5
  c72446:	c5 fd 6f 4c 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm1
  c7244c:	c5 fd 6f 54 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm2
  c72452:	b1 cc                	mov    $0xcc,%cl
  c72454:	62 d1 15 48 72 d6 1a 	vpsrld $0x1a,%zmm14,%zmm13
  c7245b:	62 e2 15 48 36 25 1b 88 7a ff 	vpermd -0x8577e5(%rip),%zmm13,%zmm20        # 41ac80 <parallel_test_signals_kept.signals+0x3d80>
  c72465:	62 d2 25 48 27 c3    	vptestmd %zmm11,%zmm11,%k0
  c7246b:	62 d1 65 40 72 e3 1f 	vpsrad $0x1f,%zmm11,%zmm19
  c72472:	62 21 25 48 fe c6    	vpaddd %zmm22,%zmm11,%zmm24
  c72478:	62 43 55 40 25 ce 6c 	vpternlogd $0x6c,%zmm14,%zmm21,%zmm25
  c7247f:	62 f3 f5 48 3a 4c 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm1,%zmm1
  c72488:	62 f3 ed 48 3a 5c 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm2,%zmm3
  c72491:	c5 fb 92 c9          	kmovd  %ecx,%k1
  c72495:	c5 f9 c5 ce 06       	vpextrw $0x6,%xmm6,%ecx
  c7249a:	c5 f9 6f b4 24 60 01 00 00 	vmovdqa 0x160(%rsp),%xmm6
  c724a3:	c1 e1 06             	shl    $0x6,%ecx
  c724a6:	c5 f9 c5 d4 06       	vpextrw $0x6,%xmm4,%edx
  c724ab:	c5 f9 6f a4 24 70 01 00 00 	vmovdqa 0x170(%rsp),%xmm4
  c724b4:	c1 e2 06             	shl    $0x6,%edx
  c724b7:	62 f2 f5 49 64 d3    	vpblendmq %zmm3,%zmm1,%zmm2{%k1}
  c724bd:	62 f2 85 48 7e cb    	vpermt2q %zmm3,%zmm15,%zmm1
  c724c3:	c5 fd 6f 5c 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm3
  c724c9:	c5 f9 c5 cf 06       	vpextrw $0x6,%xmm7,%ecx
  c724ce:	c5 f9 6f bc 24 90 01 00 00 	vmovdqa 0x190(%rsp),%xmm7
  c724d7:	c5 f9 c5 f6 06       	vpextrw $0x6,%xmm6,%esi
  c724dc:	c1 e6 06             	shl    $0x6,%esi
  c724df:	c1 e1 06             	shl    $0x6,%ecx
  c724e2:	62 f3 e5 48 3a 5c 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm3,%zmm3
  c724eb:	c4 c1 79 c5 f0 06    	vpextrw $0x6,%xmm8,%esi
  c724f1:	c1 e6 06             	shl    $0x6,%esi
  c724f4:	c5 f9 c5 fc 06       	vpextrw $0x6,%xmm4,%edi
  c724f9:	c5 fd 6f 64 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm4
  c724ff:	c1 e7 06             	shl    $0x6,%edi
  c72502:	62 f3 dd 48 3a 74 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm4,%zmm6
  c7250b:	c5 f9 c5 d7 06       	vpextrw $0x6,%xmm7,%edx
  c72510:	c5 f9 6f bc 24 b0 01 00 00 	vmovdqa 0x1b0(%rsp),%xmm7
  c72519:	c1 e2 06             	shl    $0x6,%edx
  c7251c:	62 f2 e5 49 64 e6    	vpblendmq %zmm6,%zmm3,%zmm4{%k1}
  c72522:	62 f2 85 48 7e de    	vpermt2q %zmm6,%zmm15,%zmm3
  c72528:	c5 fd 6f 74 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm6
  c7252e:	0f b7 8c 24 cc 01 00 00 	movzwl 0x1cc(%rsp),%ecx
  c72536:	c5 f9 c5 ff 06       	vpextrw $0x6,%xmm7,%edi
  c7253b:	c5 fd 6f 7c 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm7
  c72541:	62 f3 cd 48 3a 74 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm6,%zmm6
  c7254a:	0f b7 94 24 dc 01 00 00 	movzwl 0x1dc(%rsp),%edx
  c72552:	0f b7 b4 24 ec 01 00 00 	movzwl 0x1ec(%rsp),%esi
  c7255a:	62 71 6d 48 6a d4    	vpunpckhdq %zmm4,%zmm2,%zmm10
  c72560:	c1 e7 06             	shl    $0x6,%edi
  c72563:	62 73 c5 48 3a 44 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm7,%zmm8
  c7256c:	0f b7 bc 24 fc 01 00 00 	movzwl 0x1fc(%rsp),%edi
  c72574:	c1 e1 06             	shl    $0x6,%ecx
  c72577:	c1 e2 06             	shl    $0x6,%edx
  c7257a:	c1 e6 06             	shl    $0x6,%esi
  c7257d:	c5 7d 6f 4c 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm9
  c72583:	c1 e7 06             	shl    $0x6,%edi
  c72586:	62 e3 b5 48 3a 44 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm9,%zmm16
  c7258f:	62 d2 cd 49 64 f8    	vpblendmq %zmm8,%zmm6,%zmm7{%k1}
  c72595:	62 d2 85 48 7e f0    	vpermt2q %zmm8,%zmm15,%zmm6
  c7259b:	c5 7d 6f 44 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm8
  c725a1:	62 73 bd 48 3a 44 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm8,%zmm8
  c725aa:	62 32 bd 49 64 c8    	vpblendmq %zmm16,%zmm8,%zmm9{%k1}
  c725b0:	62 32 85 48 7e c0    	vpermt2q %zmm16,%zmm15,%zmm8
  c725b6:	62 e2 7d 48 5a 05 b0 02 8e ff 	vbroadcasti32x4 -0x71fd50(%rip),%zmm16        # 552870 <x86_disassembly_listing.hex+0xd80>
  c725c0:	62 72 15 48 36 3d 76 86 7a ff 	vpermd -0x85798a(%rip),%zmm13,%zmm15        # 41ac40 <parallel_test_signals_kept.signals+0x3d40>
  c725ca:	62 72 15 48 36 2d ec 86 7a ff 	vpermd -0x857914(%rip),%zmm13,%zmm13        # 41acc0 <parallel_test_signals_kept.signals+0x3dc0>
  c725d4:	62 51 45 48 6a e1    	vpunpckhdq %zmm9,%zmm7,%zmm12
  c725da:	62 51 ad 48 6d d4    	vpunpckhqdq %zmm12,%zmm10,%zmm10
  c725e0:	62 d1 45 40 72 d2 1d 	vpsrld $0x1d,%zmm10,%zmm23
  c725e7:	62 52 fd 40 83 e6    	vpmultishiftqb %zmm14,%zmm16,%zmm12
  c725ed:	62 e2 7d 48 5a 05 89 02 8e ff 	vbroadcasti32x4 -0x71fd77(%rip),%zmm16        # 552880 <x86_disassembly_listing.hex+0xd90>
  c725f7:	62 c2 fd 40 83 c6    	vpmultishiftqb %zmm14,%zmm16,%zmm16
  c725fd:	62 e3 1d 58 25 05 9c 65 90 ff d8 	vpternlogd $0xd8,-0x6f9a64(%rip){1to16},%zmm12,%zmm16        # 578ba4 <x86_break_instruction.legacy_forms+0x62c>
  c72608:	62 52 f5 40 83 e6    	vpmultishiftqb %zmm14,%zmm17,%zmm12
  c7260e:	62 e2 7d 48 5a 0d 88 02 8e ff 	vbroadcasti32x4 -0x71fd78(%rip),%zmm17        # 5528a0 <x86_disassembly_listing.hex+0xdb0>
  c72618:	62 73 7d 50 25 25 85 65 90 ff e4 	vpternlogd $0xe4,-0x6f9a7b(%rip){1to16},%zmm16,%zmm12        # 578ba8 <x86_break_instruction.legacy_forms+0x630>
  c72623:	62 c2 75 40 00 ce    	vpshufb %zmm14,%zmm17,%zmm17
  c72629:	62 d1 7d 40 72 f6 04 	vpslld $0x4,%zmm14,%zmm16
  c72630:	62 b1 7d 40 72 e0 1f 	vpsrad $0x1f,%zmm16,%zmm16
  c72637:	62 c3 1d 48 25 e7 f8 	vpternlogd $0xf8,%zmm15,%zmm12,%zmm20
  c7263e:	62 b1 05 48 72 f1 10 	vpslld $0x10,%zmm17,%zmm15
  c72645:	62 a1 7d 40 db c9    	vpandd %zmm17,%zmm16,%zmm17
  c7264b:	62 e3 15 58 25 0d 9e 65 90 ff ec 	vpternlogd $0xec,-0x6f9a62(%rip){1to16},%zmm13,%zmm17        # 578bf4 <x86_break_instruction.legacy_forms+0x67c>
  c72656:	62 d1 6d 40 72 e7 1f 	vpsrad $0x1f,%zmm15,%zmm18
  c7265d:	62 72 7e 48 38 f8    	vpmovm2d %k0,%zmm15
  c72663:	62 23 7d 40 25 dc ea 	vpternlogd $0xea,%zmm20,%zmm16,%zmm27
  c7266a:	62 b1 2d 40 72 d4 10 	vpsrld $0x10,%zmm20,%zmm26
  c72671:	62 e3 2d 58 25 0d 7c 65 90 ff f8 	vpternlogd $0xf8,-0x6f9a84(%rip){1to16},%zmm10,%zmm17        # 578bf8 <x86_break_instruction.legacy_forms+0x680>
  c7267c:	62 33 7d 40 25 fa c8 	vpternlogd $0xc8,%zmm18,%zmm16,%zmm15
  c72683:	62 c1 65 40 ef d3    	vpxord %zmm11,%zmm19,%zmm18
  c72689:	62 e2 7d 48 58 1d 1d 65 90 ff 	vpbroadcastd -0x6f9ae3(%rip),%zmm19        # 578bb0 <x86_break_instruction.legacy_forms+0x638>
  c72693:	62 71 05 58 db 2d 5f 65 90 ff 	vpandd -0x6f9aa1(%rip){1to16},%zmm15,%zmm13        # 578bfc <x86_break_instruction.legacy_forms+0x684>
  c7269d:	62 e1 7d 50 db 05 59 65 90 ff 	vpandd -0x6f9aa7(%rip){1to16},%zmm16,%zmm16        # 578c00 <x86_break_instruction.legacy_forms+0x688>
  c726a7:	62 a2 7d 48 44 d2    	vplzcntd %zmm18,%zmm18
  c726ad:	62 a2 65 40 45 d2    	vpsrlvd %zmm18,%zmm19,%zmm18
  c726b3:	62 23 25 48 25 c2 14 	vpternlogd $0x14,%zmm18,%zmm11,%zmm24
  c726ba:	62 a2 3d 40 14 d7    	vprorvd %zmm23,%zmm24,%zmm18
  c726c0:	62 62 7d 48 58 05 ea 64 90 ff 	vpbroadcastd -0x6f9b16(%rip),%zmm24        # 578bb4 <x86_break_instruction.legacy_forms+0x63c>
  c726ca:	62 b1 6d 40 72 e2 1f 	vpsrad $0x1f,%zmm18,%zmm18
  c726d1:	62 c3 6d 40 25 c5 b8 	vpternlogd $0xb8,%zmm13,%zmm18,%zmm16
  c726d8:	62 23 05 48 25 c4 ea 	vpternlogd $0xea,%zmm20,%zmm15,%zmm24
  c726df:	62 b1 5d 40 72 d4 03 	vpsrld $0x3,%zmm20,%zmm20
  c726e6:	62 e3 2d 50 25 25 e7 64 90 ff ec 	vpternlogd $0xec,-0x6f9b19(%rip){1to16},%zmm26,%zmm20        # 578bd8 <x86_break_instruction.legacy_forms+0x660>
  c726f1:	62 03 6d 40 25 d8 b8 	vpternlogd $0xb8,%zmm24,%zmm18,%zmm27
  c726f8:	62 21 35 40 fe c6    	vpaddd %zmm22,%zmm25,%zmm24
  c726fe:	62 d1 35 40 72 d6 08 	vpsrld $0x8,%zmm14,%zmm25
  c72705:	62 63 55 50 25 0d b0 64 90 ff 6c 	vpternlogd $0x6c,-0x6f9b50(%rip){1to16},%zmm21,%zmm25        # 578bc0 <x86_break_instruction.legacy_forms+0x648>
  c72710:	62 51 55 48 eb f6    	vpord  %zmm14,%zmm5,%zmm14
  c72716:	62 d1 0d 48 72 f6 07 	vpslld $0x7,%zmm14,%zmm14
  c7271d:	62 a1 35 40 fe ee    	vpaddd %zmm22,%zmm25,%zmm21
  c72723:	62 62 7d 48 58 0d 97 64 90 ff 	vpbroadcastd -0x6f9b69(%rip),%zmm25        # 578bc4 <x86_break_instruction.legacy_forms+0x64c>
  c7272d:	62 63 3d 50 25 0d 90 64 90 ff ea 	vpternlogd $0xea,-0x6f9b70(%rip){1to16},%zmm24,%zmm25        # 578bc8 <x86_break_instruction.legacy_forms+0x650>
  c72738:	62 b1 3d 40 72 f4 08 	vpslld $0x8,%zmm20,%zmm24
  c7273f:	62 63 55 50 25 0d 82 64 90 ff f8 	vpternlogd $0xf8,-0x6f9b7e(%rip){1to16},%zmm21,%zmm25        # 578bcc <x86_break_instruction.legacy_forms+0x654>
  c7274a:	62 e1 1d 58 db 2d 7c 64 90 ff 	vpandd -0x6f9b84(%rip){1to16},%zmm12,%zmm21        # 578bd0 <x86_break_instruction.legacy_forms+0x658>
  c72754:	62 83 2d 48 25 e9 f8 	vpternlogd $0xf8,%zmm25,%zmm10,%zmm21
  c7275b:	62 d1 35 40 72 d4 03 	vpsrld $0x3,%zmm12,%zmm25
  c72762:	62 63 2d 58 25 0d 6f 64 90 ff a2 	vpternlogd $0xa2,-0x6f9b91(%rip){1to16},%zmm10,%zmm25        # 578bdc <x86_break_instruction.legacy_forms+0x664>
  c7276d:	62 e2 55 50 3b 2d 5d 64 90 ff 	vpminud -0x6f9ba3(%rip){1to16},%zmm21,%zmm21        # 578bd4 <x86_break_instruction.legacy_forms+0x65c>
  c72777:	62 31 35 40 fe e6    	vpaddd %zmm22,%zmm25,%zmm12
  c7277d:	62 e2 35 50 3b 35 59 64 90 ff 	vpminud -0x6f9ba7(%rip){1to16},%zmm25,%zmm22        # 578be0 <x86_break_instruction.legacy_forms+0x668>
  c72787:	62 62 7d 48 5a 0d 1f 01 8e ff 	vbroadcasti32x4 -0x71fee1(%rip),%zmm25        # 5528b0 <x86_disassembly_listing.hex+0xdc0>
  c72791:	62 d1 1d 48 72 e4 1f 	vpsrad $0x1f,%zmm12,%zmm12
  c72798:	62 63 1d 58 25 05 41 64 90 ff 08 	vpternlogd $0x8,-0x6f9bbf(%rip){1to16},%zmm12,%zmm24        # 578be4 <x86_break_instruction.legacy_forms+0x66c>
  c727a3:	62 62 b5 40 83 cd    	vpmultishiftqb %zmm5,%zmm25,%zmm25
  c727a9:	62 63 5d 50 25 0d 38 64 90 ff d8 	vpternlogd $0xd8,-0x6f9bc8(%rip){1to16},%zmm20,%zmm25        # 578bec <x86_break_instruction.legacy_forms+0x674>
  c727b4:	62 a3 4d 40 25 cd fe 	vpternlogd $0xfe,%zmm21,%zmm22,%zmm17
  c727bb:	62 31 7d 40 eb e9    	vpord  %zmm17,%zmm16,%zmm13
  c727c1:	62 d1 7d 40 72 cb 01 	vprold $0x1,%zmm11,%zmm16
  c727c8:	62 73 3d 50 25 35 15 64 90 ff e4 	vpternlogd $0xe4,-0x6f9beb(%rip){1to16},%zmm24,%zmm14        # 578be8 <x86_break_instruction.legacy_forms+0x670>
  c727d3:	62 63 0d 58 25 0d 12 64 90 ff d8 	vpternlogd $0xd8,-0x6f9bee(%rip){1to16},%zmm14,%zmm25        # 578bf0 <x86_break_instruction.legacy_forms+0x678>
  c727de:	62 32 7d 40 14 f7    	vprorvd %zmm23,%zmm16,%zmm14
  c727e4:	62 53 05 48 25 f3 e2 	vpternlogd $0xe2,%zmm11,%zmm15,%zmm14
  c727eb:	62 53 6d 40 25 f3 e2 	vpternlogd $0xe2,%zmm11,%zmm18,%zmm14
  c727f2:	62 c1 7d 48 70 d5 00 	vpshufd $0x0,%zmm13,%zmm18
  c727f9:	62 51 7d 48 62 de    	vpunpckldq %zmm14,%zmm0,%zmm11
  c727ff:	62 f2 6d 40 8f c9    	vpshufbitqmb %zmm1,%zmm18,%k1
  c72805:	62 d1 7d 48 6a c6    	vpunpckhdq %zmm14,%zmm0,%zmm0
  c7280b:	c4 e1 fb 93 c1       	kmovq  %k1,%rax
  c72810:	62 81 25 40 62 c9    	vpunpckldq %zmm25,%zmm27,%zmm17
  c72816:	62 11 25 40 6a f9    	vpunpckhdq %zmm25,%zmm27,%zmm15
  c7281c:	f3 48 0f b8 c0       	popcnt %rax,%rax
  c72821:	62 a1 a5 48 6c c1    	vpunpcklqdq %zmm17,%zmm11,%zmm16
  c72827:	62 31 a5 48 6d d9    	vpunpckhqdq %zmm17,%zmm11,%zmm11
  c7282d:	62 e2 7d 48 5a 0d f9 ff 8d ff 	vbroadcasti32x4 -0x720007(%rip),%zmm17        # 552830 <x86_disassembly_listing.hex+0xd40>
  c72837:	62 c1 fd 48 6c df    	vpunpcklqdq %zmm15,%zmm0,%zmm19
  c7283d:	62 d1 fd 48 6d c7    	vpunpckhqdq %zmm15,%zmm0,%zmm0
  c72843:	62 51 7d 48 70 fd 55 	vpshufd $0x55,%zmm13,%zmm15
  c7284a:	49 8d 0c 06          	lea    (%r14,%rax,1),%rcx
  c7284e:	62 e2 7d 40 00 c1    	vpshufb %zmm1,%zmm16,%zmm16
  c72854:	62 d2 7d 48 00 c0    	vpshufb %zmm8,%zmm0,%zmm0
  c7285a:	62 a3 ed 48 25 c1 78 	vpternlogq $0x78,%zmm17,%zmm2,%zmm16
  c72861:	62 f2 25 48 00 d3    	vpshufb %zmm3,%zmm11,%zmm2
  c72867:	62 b3 b5 48 25 c1 78 	vpternlogq $0x78,%zmm17,%zmm9,%zmm0
  c7286e:	62 e2 7d c9 63 c1    	vpcompressb %zmm16,%zmm1{%k1}{z}
  c72874:	62 f2 05 48 8f cb    	vpshufbitqmb %zmm3,%zmm15,%k1
  c7287a:	62 d1 7d 48 70 dd aa 	vpshufd $0xaa,%zmm13,%zmm3
  c72881:	62 b3 dd 48 25 d1 78 	vpternlogq $0x78,%zmm17,%zmm4,%zmm2
  c72888:	62 d1 7d 48 70 e5 ff 	vpshufd $0xff,%zmm13,%zmm4
  c7288f:	62 73 2d 58 25 2d 6a 63 90 ff 20 	vpternlogd $0x20,-0x6f9c96(%rip){1to16},%zmm10,%zmm13        # 578c04 <x86_break_instruction.legacy_forms+0x68c>
  c7289a:	c4 e1 fb 93 d1       	kmovq  %k1,%rdx
  c7289f:	f3 48 0f b8 d2       	popcnt %rdx,%rdx
  c728a4:	62 d1 fe 48 7f 0e    	vmovdqu64 %zmm1,(%r14)
  c728aa:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
  c728ae:	62 f2 7d c9 63 d1    	vpcompressb %zmm2,%zmm1{%k1}{z}
  c728b4:	62 f2 65 40 00 d6    	vpshufb %zmm6,%zmm19,%zmm2
  c728ba:	62 f2 65 48 8f ce    	vpshufbitqmb %zmm6,%zmm3,%k1
  c728c0:	62 f1 2d 58 db 1d 3e 63 90 ff 	vpandd -0x6f9cc2(%rip){1to16},%zmm10,%zmm3        # 578c08 <x86_break_instruction.legacy_forms+0x690>
  c728ca:	48 8d 34 11          	lea    (%rcx,%rdx,1),%rsi
  c728ce:	62 b3 c5 48 25 d1 78 	vpternlogq $0x78,%zmm17,%zmm7,%zmm2
  c728d5:	62 d1 fe 48 7f 0c 06 	vmovdqu64 %zmm1,(%r14,%rax,1)
  c728dc:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
  c728e0:	62 f2 7d c9 63 d1    	vpcompressb %zmm2,%zmm1{%k1}{z}
  c728e6:	c4 e1 fb 93 c1       	kmovq  %k1,%rax
  c728eb:	62 d2 5d 48 8f c8    	vpshufbitqmb %zmm8,%zmm4,%k1
  c728f1:	41 29 de             	sub    %ebx,%r14d
  c728f4:	f3 48 0f b8 f8       	popcnt %rax,%rdi
  c728f9:	62 f2 7d c9 63 c0    	vpcompressb %zmm0,%zmm0{%k1}{z}
  c728ff:	c4 e1 fb 93 c1       	kmovq  %k1,%rax
  c72904:	f3 48 0f b8 c0       	popcnt %rax,%rax
  c72909:	62 f1 fe 48 7f 0c 0a 	vmovdqu64 %zmm1,(%rdx,%rcx,1)
  c72910:	62 f1 1d 48 fe cb    	vpaddd %zmm3,%zmm12,%zmm1
  c72916:	48 01 f8             	add    %rdi,%rax
  c72919:	48 01 f0             	add    %rsi,%rax
  c7291c:	62 f1 fe 48 7f 04 37 	vmovdqu64 %zmm0,(%rdi,%rsi,1)
  c72923:	62 d2 7d 48 55 c5    	vpopcntd %zmm13,%zmm0
  c72929:	44 89 b4 24 fc 00 00 00 	mov    %r14d,0xfc(%rsp)
  c72931:	49 89 c6             	mov    %rax,%r14
  c72934:	62 f1 75 48 fe c0    	vpaddd %zmm0,%zmm1,%zmm0
  c7293a:	c5 f9 6f 0d fe fe 8d ff 	vmovdqa -0x720102(%rip),%xmm1        # 552840 <x86_disassembly_listing.hex+0xd50>
  c72942:	62 f2 75 48 8d c0    	vpermb %zmm0,%zmm1,%zmm0
  c72948:	62 f2 fd 18 40 05 3e 5b 90 ff 	vpmullq -0x6fa4c2(%rip){1to2},%xmm0,%xmm0        # 578490 <x86_effects_unknown+0x1a90>
  c72952:	c5 f9 6f 0d 06 ff 8d ff 	vmovdqa -0x7200fa(%rip),%xmm1        # 552860 <x86_disassembly_listing.hex+0xd70>
  c7295a:	c4 e2 79 00 15 ed fe 8d ff 	vpshufb -0x720113(%rip),%xmm0,%xmm2        # 552850 <x86_disassembly_listing.hex+0xd60>
  c72963:	62 f2 75 48 8d cd    	vpermb %zmm5,%zmm1,%zmm1
  c72969:	c5 e9 fc c0          	vpaddb %xmm0,%xmm2,%xmm0
  c7296d:	62 f2 7d 48 31 c0    	vpmovzxbd %xmm0,%zmm0
  c72973:	62 f1 7d 58 fe 44 24 3f 	vpaddd 0xfc(%rsp){1to16},%zmm0,%zmm0
  c7297b:	62 f2 7e 48 29 c9    	vpmovb2m %zmm1,%k1
  c72981:	62 f2 7d c9 8b c0    	vpcompressd %zmm0,%zmm0{%k1}{z}
  c72987:	62 d1 fe 48 7f 07    	vmovdqu64 %zmm0,(%r15)
  c7298d:	e9 86 0c 00 00       	jmp    c73618 <x86_encode_64+0x4f78>
  c72992:	62 f2 7d 48 5a 35 94 fe 8d ff 	vbroadcasti32x4 -0x72016c(%rip),%zmm6        # 552830 <x86_disassembly_listing.hex+0xd40>
  c7299c:	62 f1 fd 48 6f 0d 9a 82 7a ff 	vmovdqa64 -0x857d66(%rip),%zmm1        # 41ac40 <parallel_test_signals_kept.signals+0x3d40>
  c729a6:	62 f1 fd 48 6f 05 d0 82 7a ff 	vmovdqa64 -0x857d30(%rip),%zmm0        # 41ac80 <parallel_test_signals_kept.signals+0x3d80>
  c729b0:	62 72 7d 48 5a 0d b6 fe 8d ff 	vbroadcasti32x4 -0x72014a(%rip),%zmm9        # 552870 <x86_disassembly_listing.hex+0xd80>
  c729ba:	62 62 7d 48 5a 25 bc fe 8d ff 	vbroadcasti32x4 -0x720144(%rip),%zmm28        # 552880 <x86_disassembly_listing.hex+0xd90>
  c729c4:	62 62 7d 48 58 3d d6 61 90 ff 	vpbroadcastd -0x6f9e2a(%rip),%zmm31        # 578ba4 <x86_break_instruction.legacy_forms+0x62c>
  c729ce:	62 f2 7d 48 58 1d dc 61 90 ff 	vpbroadcastd -0x6f9e24(%rip),%zmm3        # 578bb4 <x86_break_instruction.legacy_forms+0x63c>
  c729d8:	b0 cc                	mov    $0xcc,%al
  c729da:	48 8d 8f fc 00 00 00 	lea    0xfc(%rdi),%rcx
  c729e1:	45 31 c9             	xor    %r9d,%r9d
  c729e4:	48 8d 15 95 f9 12 02 	lea    0x212f995(%rip),%rdx        # 2da2380 <x86_template_storage>
  c729eb:	49 89 de             	mov    %rbx,%r14
  c729ee:	c5 fb 92 c8          	kmovd  %eax,%k1
  c729f2:	62 f1 fd 48 7f 74 24 02 	vmovdqa64 %zmm6,0x80(%rsp)
  c729fa:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  c72a00:	4c 89 c8             	mov    %r9,%rax
  c72a03:	49 c1 e1 04          	shl    $0x4,%r9
  c72a07:	45 31 c0             	xor    %r8d,%r8d
  c72a0a:	49 01 c9             	add    %rcx,%r9
  c72a0d:	0f 1f 00             	nopl   (%rax)
  c72a10:	45 0f b7 91 10 ff ff ff 	movzwl -0xf0(%r9),%r10d
  c72a18:	45 0f b7 99 20 ff ff ff 	movzwl -0xe0(%r9),%r11d
  c72a20:	45 0f b7 b9 30 ff ff ff 	movzwl -0xd0(%r9),%r15d
  c72a28:	45 0f b7 a1 40 ff ff ff 	movzwl -0xc0(%r9),%r12d
  c72a30:	62 c1 fe 48 6f 99 04 ff ff ff 	vmovdqu64 -0xfc(%r9),%zmm19
  c72a3a:	62 c1 fe 48 6f a9 44 ff ff ff 	vmovdqu64 -0xbc(%r9),%zmm21
  c72a44:	62 c1 fe 48 6f b1 84 ff ff ff 	vmovdqu64 -0x7c(%r9),%zmm22
  c72a4e:	62 c1 fe 48 6f b9 c4 ff ff ff 	vmovdqu64 -0x3c(%r9),%zmm23
  c72a58:	49 83 c0 f0          	add    $0xfffffffffffffff0,%r8
  c72a5c:	41 c1 e2 06          	shl    $0x6,%r10d
  c72a60:	41 c1 e3 06          	shl    $0x6,%r11d
  c72a64:	41 c1 e7 06          	shl    $0x6,%r15d
  c72a68:	41 c1 e4 06          	shl    $0x6,%r12d
  c72a6c:	c4 c1 7d 6f 64 12 40 	vmovdqa 0x40(%r10,%rdx,1),%ymm4
  c72a73:	45 0f b7 91 50 ff ff ff 	movzwl -0xb0(%r9),%r10d
  c72a7b:	c4 c1 7d 6f 6c 13 60 	vmovdqa 0x60(%r11,%rdx,1),%ymm5
  c72a82:	45 0f b7 99 60 ff ff ff 	movzwl -0xa0(%r9),%r11d
  c72a8a:	62 53 d5 48 3a 7c 14 03 01 	vinserti64x4 $0x1,0x60(%r12,%rdx,1),%zmm5,%zmm15
  c72a93:	45 0f b7 61 80       	movzwl -0x80(%r9),%r12d
  c72a98:	62 d3 dd 48 3a 64 17 02 01 	vinserti64x4 $0x1,0x40(%r15,%rdx,1),%zmm4,%zmm4
  c72aa1:	45 0f b7 b9 70 ff ff ff 	movzwl -0x90(%r9),%r15d
  c72aa9:	62 f1 fd 48 6f eb    	vmovdqa64 %zmm3,%zmm5
  c72aaf:	62 f3 65 48 25 db ff 	vpternlogd $0xff,%zmm3,%zmm3,%zmm3
  c72ab6:	62 b1 65 40 62 f5    	vpunpckldq %zmm21,%zmm19,%zmm6
  c72abc:	62 31 4d 40 62 e7    	vpunpckldq %zmm23,%zmm22,%zmm12
  c72ac2:	62 a1 4d 40 6a f7    	vpunpckhdq %zmm23,%zmm22,%zmm22
  c72ac8:	62 a1 65 40 6a ed    	vpunpckhdq %zmm21,%zmm19,%zmm21
  c72ace:	62 b1 d5 40 6c d6    	vpunpcklqdq %zmm22,%zmm21,%zmm2
  c72ad4:	62 c1 cd 48 6d fc    	vpunpckhqdq %zmm12,%zmm6,%zmm23
  c72ada:	62 f1 0d 40 72 d2 1a 	vpsrld $0x1a,%zmm2,%zmm30
  c72ae1:	62 62 b5 48 83 da    	vpmultishiftqb %zmm2,%zmm9,%zmm27
  c72ae7:	62 62 9d 40 83 ea    	vpmultishiftqb %zmm2,%zmm28,%zmm29
  c72aed:	62 11 fd 48 6f cc    	vmovdqa64 %zmm28,%zmm9
  c72af3:	62 e1 fd 48 6f da    	vmovdqa64 %zmm2,%zmm19
  c72af9:	62 b2 45 40 27 c7    	vptestmd %zmm23,%zmm23,%k0
  c72aff:	41 c1 e2 06          	shl    $0x6,%r10d
  c72b03:	41 c1 e3 06          	shl    $0x6,%r11d
  c72b07:	62 62 0d 40 36 d1    	vpermd %zmm1,%zmm30,%zmm26
  c72b0d:	62 f2 7d 48 5a 0d 79 fd 8d ff 	vbroadcasti32x4 -0x720287(%rip),%zmm1        # 552890 <x86_disassembly_listing.hex+0xda0>
  c72b17:	62 03 25 40 25 ef d8 	vpternlogd $0xd8,%zmm31,%zmm27,%zmm29
  c72b1e:	c4 41 7d 6f 44 12 40 	vmovdqa 0x40(%r10,%rdx,1),%ymm8
  c72b25:	45 0f b7 51 90       	movzwl -0x70(%r9),%r10d
  c72b2a:	41 c1 e7 06          	shl    $0x6,%r15d
  c72b2e:	c4 41 7d 6f 54 13 60 	vmovdqa 0x60(%r11,%rdx,1),%ymm10
  c72b35:	45 0f b7 59 a0       	movzwl -0x60(%r9),%r11d
  c72b3a:	41 c1 e4 06          	shl    $0x6,%r12d
  c72b3e:	62 53 bd 48 3a 44 17 02 01 	vinserti64x4 $0x1,0x40(%r15,%rdx,1),%zmm8,%zmm8
  c72b47:	62 c3 ad 48 3a 4c 14 03 01 	vinserti64x4 $0x1,0x60(%r12,%rdx,1),%zmm10,%zmm17
  c72b50:	45 0f b7 79 b0       	movzwl -0x50(%r9),%r15d
  c72b55:	45 0f b7 61 c0       	movzwl -0x40(%r9),%r12d
  c72b5a:	62 d2 dd 49 64 ff    	vpblendmq %zmm15,%zmm4,%zmm7{%k1}
  c72b60:	62 f1 fd 48 7f 7c 24 01 	vmovdqa64 %zmm7,0x40(%rsp)
  c72b68:	41 c1 e2 06          	shl    $0x6,%r10d
  c72b6c:	41 c1 e3 06          	shl    $0x6,%r11d
  c72b70:	c4 41 7d 6f 5c 12 40 	vmovdqa 0x40(%r10,%rdx,1),%ymm11
  c72b77:	45 0f b7 51 d0       	movzwl -0x30(%r9),%r10d
  c72b7c:	41 c1 e7 06          	shl    $0x6,%r15d
  c72b80:	c4 41 7d 6f 6c 13 60 	vmovdqa 0x60(%r11,%rdx,1),%ymm13
  c72b87:	45 0f b7 59 e0       	movzwl -0x20(%r9),%r11d
  c72b8c:	41 c1 e4 06          	shl    $0x6,%r12d
  c72b90:	62 53 a5 48 3a 5c 17 02 01 	vinserti64x4 $0x1,0x40(%r15,%rdx,1),%zmm11,%zmm11
  c72b99:	62 c3 95 48 3a 54 14 03 01 	vinserti64x4 $0x1,0x60(%r12,%rdx,1),%zmm13,%zmm18
  c72ba2:	45 0f b7 79 f0       	movzwl -0x10(%r9),%r15d
  c72ba7:	45 0f b7 21          	movzwl (%r9),%r12d
  c72bab:	62 62 f5 48 83 e2    	vpmultishiftqb %zmm2,%zmm1,%zmm28
  c72bb1:	62 63 15 50 25 25 ec 5f 90 ff e4 	vpternlogd $0xe4,-0x6fa014(%rip){1to16},%zmm29,%zmm28        # 578ba8 <x86_break_instruction.legacy_forms+0x630>
  c72bbc:	62 f2 7d 48 58 0d ea 5f 90 ff 	vpbroadcastd -0x6fa016(%rip),%zmm1        # 578bb0 <x86_break_instruction.legacy_forms+0x638>
  c72bc6:	49 81 c1 00 01 00 00 	add    $0x100,%r9
  c72bcd:	62 32 bd 49 64 d1    	vpblendmq %zmm17,%zmm8,%zmm10{%k1}
  c72bd3:	62 41 45 48 6a c2    	vpunpckhdq %zmm10,%zmm7,%zmm24
  c72bd9:	62 f2 7d 48 5a 3d bd fc 8d ff 	vbroadcasti32x4 -0x720343(%rip),%zmm7        # 5528a0 <x86_disassembly_listing.hex+0xdb0>
  c72be3:	62 71 fd 48 7f 14 24 	vmovdqa64 %zmm10,(%rsp)
  c72bea:	62 11 fd 48 6f d7    	vmovdqa64 %zmm31,%zmm10
  c72bf0:	41 c1 e2 06          	shl    $0x6,%r10d
  c72bf4:	41 c1 e3 06          	shl    $0x6,%r11d
  c72bf8:	41 c1 e7 06          	shl    $0x6,%r15d
  c72bfc:	c4 41 7d 6f 74 12 40 	vmovdqa 0x40(%r10,%rdx,1),%ymm14
  c72c03:	41 c1 e4 06          	shl    $0x6,%r12d
  c72c07:	62 c1 fd 28 6f 44 13 03 	vmovdqa64 0x60(%r11,%rdx,1),%ymm16
  c72c0f:	62 53 8d 48 3a 74 17 02 01 	vinserti64x4 $0x1,0x40(%r15,%rdx,1),%zmm14,%zmm14
  c72c18:	62 c3 fd 40 3a 64 14 03 01 	vinserti64x4 $0x1,0x60(%r12,%rdx,1),%zmm16,%zmm20
  c72c21:	62 32 a5 49 64 ea    	vpblendmq %zmm18,%zmm11,%zmm13{%k1}
  c72c27:	62 62 45 48 00 ea    	vpshufb %zmm2,%zmm7,%zmm29
  c72c2d:	62 f2 7d 48 58 3d 91 5f 90 ff 	vpbroadcastd -0x6fa06f(%rip),%zmm7        # 578bc8 <x86_break_instruction.legacy_forms+0x650>
  c72c37:	62 a2 8d 49 64 c4    	vpblendmq %zmm20,%zmm14,%zmm16{%k1}
  c72c3d:	62 21 15 48 6a c8    	vpunpckhdq %zmm16,%zmm13,%zmm25
  c72c43:	62 01 bd 40 6d c9    	vpunpckhqdq %zmm25,%zmm24,%zmm25
  c72c49:	62 62 0d 40 36 c0    	vpermd %zmm0,%zmm30,%zmm24
  c72c4f:	62 f2 7d 48 58 05 53 5f 90 ff 	vpbroadcastd -0x6fa0ad(%rip),%zmm0        # 578bac <x86_break_instruction.legacy_forms+0x634>
  c72c59:	62 03 1d 40 25 c2 f8 	vpternlogd $0xf8,%zmm26,%zmm28,%zmm24
  c72c60:	62 f1 2d 40 72 f2 04 	vpslld $0x4,%zmm2,%zmm26
  c72c67:	62 91 25 40 72 e2 1f 	vpsrad $0x1f,%zmm26,%zmm27
  c72c6e:	62 91 2d 40 72 f5 10 	vpslld $0x10,%zmm29,%zmm26
  c72c75:	62 91 05 40 72 e2 1f 	vpsrad $0x1f,%zmm26,%zmm31
  c72c7c:	62 62 7e 48 38 d0    	vpmovm2d %k0,%zmm26
  c72c82:	62 01 25 40 db ed    	vpandd %zmm29,%zmm27,%zmm29
  c72c88:	62 e3 7d 58 25 1d 29 5f 90 ff 6c 	vpternlogd $0x6c,-0x6fa0d7(%rip){1to16},%zmm0,%zmm19        # 578bbc <x86_break_instruction.legacy_forms+0x644>
  c72c93:	62 03 25 40 25 d7 c8 	vpternlogd $0xc8,%zmm31,%zmm27,%zmm26
  c72c9a:	62 b1 05 40 72 e7 1f 	vpsrad $0x1f,%zmm23,%zmm31
  c72ca1:	62 21 05 40 ef ff    	vpxord %zmm23,%zmm31,%zmm31
  c72ca7:	62 02 7d 48 44 ff    	vplzcntd %zmm31,%zmm31
  c72cad:	62 02 75 48 45 ff    	vpsrlvd %zmm31,%zmm1,%zmm31
  c72cb3:	62 f1 45 40 fe cb    	vpaddd %zmm3,%zmm23,%zmm1
  c72cb9:	62 93 45 40 25 cf 14 	vpternlogd $0x14,%zmm31,%zmm23,%zmm1
  c72cc0:	62 f1 05 40 72 d2 08 	vpsrld $0x8,%zmm2,%zmm31
  c72cc7:	62 63 7d 58 25 3d ee 5e 90 ff 6c 	vpternlogd $0x6c,-0x6fa112(%rip){1to16},%zmm0,%zmm31        # 578bc0 <x86_break_instruction.legacy_forms+0x648>
  c72cd2:	62 f1 fd 48 6f 05 e4 7f 7a ff 	vmovdqa64 -0x85801c(%rip),%zmm0        # 41acc0 <parallel_test_signals_kept.signals+0x3dc0>
  c72cdc:	62 e1 65 40 fe db    	vpaddd %zmm3,%zmm19,%zmm19
  c72ce2:	62 e3 45 58 25 1d d7 5e 90 ff ec 	vpternlogd $0xec,-0x6fa129(%rip){1to16},%zmm7,%zmm19        # 578bc4 <x86_break_instruction.legacy_forms+0x64c>
  c72ced:	62 f1 1d 50 db 3d d9 5e 90 ff 	vpandd -0x6fa127(%rip){1to16},%zmm28,%zmm7        # 578bd0 <x86_break_instruction.legacy_forms+0x658>
  c72cf7:	62 91 1d 40 72 d4 03 	vpsrld $0x3,%zmm28,%zmm28
  c72cfe:	62 63 35 50 25 25 d3 5e 90 ff a2 	vpternlogd $0xa2,-0x6fa12d(%rip){1to16},%zmm25,%zmm28        # 578bdc <x86_break_instruction.legacy_forms+0x664>
  c72d09:	62 61 05 40 fe fb    	vpaddd %zmm3,%zmm31,%zmm31
  c72d0f:	62 62 0d 40 36 f0    	vpermd %zmm0,%zmm30,%zmm30
  c72d15:	62 f1 fd 48 6f dd    	vmovdqa64 %zmm5,%zmm3
  c72d1b:	62 f2 7d 48 58 2d 93 5e 90 ff 	vpbroadcastd -0x6fa16d(%rip),%zmm5        # 578bb8 <x86_break_instruction.legacy_forms+0x640>
  c72d25:	62 f3 7d 48 25 c0 ff 	vpternlogd $0xff,%zmm0,%zmm0,%zmm0
  c72d2c:	62 63 65 50 25 3d 95 5e 90 ff ec 	vpternlogd $0xec,-0x6fa16b(%rip){1to16},%zmm19,%zmm31        # 578bcc <x86_break_instruction.legacy_forms+0x654>
  c72d37:	62 63 0d 50 25 2d b2 5e 90 ff ec 	vpternlogd $0xec,-0x6fa14e(%rip){1to16},%zmm30,%zmm29        # 578bf4 <x86_break_instruction.legacy_forms+0x67c>
  c72d42:	62 91 0d 40 72 d1 1d 	vpsrld $0x1d,%zmm25,%zmm30
  c72d49:	62 63 35 50 25 2d a4 5e 90 ff f8 	vpternlogd $0xf8,-0x6fa15c(%rip){1to16},%zmm25,%zmm29        # 578bf8 <x86_break_instruction.legacy_forms+0x680>
  c72d54:	62 92 75 48 14 ce    	vprorvd %zmm30,%zmm1,%zmm1
  c72d5a:	62 f1 75 48 72 e1 1f 	vpsrad $0x1f,%zmm1,%zmm1
  c72d61:	62 93 35 40 25 ff f8 	vpternlogd $0xf8,%zmm31,%zmm25,%zmm7
  c72d68:	62 e2 45 58 3b 1d 62 5e 90 ff 	vpminud -0x6fa19e(%rip){1to16},%zmm7,%zmm19        # 578bd4 <x86_break_instruction.legacy_forms+0x65c>
  c72d72:	62 62 1d 50 3b 3d 64 5e 90 ff 	vpminud -0x6fa19c(%rip){1to16},%zmm28,%zmm31        # 578be0 <x86_break_instruction.legacy_forms+0x668>
  c72d7c:	62 f1 2d 50 db 3d 76 5e 90 ff 	vpandd -0x6fa18a(%rip){1to16},%zmm26,%zmm7        # 578bfc <x86_break_instruction.legacy_forms+0x684>
  c72d86:	62 01 fd 48 6f c8    	vmovdqa64 %zmm24,%zmm25
  c72d8c:	62 63 2d 40 25 cb f8 	vpternlogd $0xf8,%zmm3,%zmm26,%zmm25
  c72d93:	62 23 05 40 25 eb fe 	vpternlogd $0xfe,%zmm19,%zmm31,%zmm29
  c72d9a:	62 81 fd 48 6f d8    	vmovdqa64 %zmm24,%zmm19
  c72da0:	62 e3 25 40 25 dd f8 	vpternlogd $0xf8,%zmm5,%zmm27,%zmm19
  c72da7:	62 61 25 50 db 1d 4f 5e 90 ff 	vpandd -0x6fa1b1(%rip){1to16},%zmm27,%zmm27        # 578c00 <x86_break_instruction.legacy_forms+0x688>
  c72db1:	62 b1 55 48 72 cf 01 	vprold $0x1,%zmm23,%zmm5
  c72db8:	62 41 fd 48 6f fa    	vmovdqa64 %zmm10,%zmm31
  c72dbe:	62 72 7d 48 58 15 20 5e 90 ff 	vpbroadcastd -0x6fa1e0(%rip),%zmm10        # 578be8 <x86_break_instruction.legacy_forms+0x670>
  c72dc8:	62 83 75 48 25 d9 b8 	vpternlogd $0xb8,%zmm25,%zmm1,%zmm19
  c72dcf:	62 02 55 48 14 ce    	vprorvd %zmm30,%zmm5,%zmm25
  c72dd5:	62 b1 d5 40 6d ee    	vpunpckhqdq %zmm22,%zmm21,%zmm5
  c72ddb:	62 f1 55 48 eb d2    	vpord  %zmm2,%zmm5,%zmm2
  c72de1:	62 23 2d 40 25 cf e2 	vpternlogd $0xe2,%zmm23,%zmm26,%zmm25
  c72de8:	62 f1 6d 48 72 f2 07 	vpslld $0x7,%zmm2,%zmm2
  c72def:	62 23 75 48 25 cf e2 	vpternlogd $0xe2,%zmm23,%zmm1,%zmm25
  c72df6:	62 63 75 48 25 df b8 	vpternlogd $0xb8,%zmm7,%zmm1,%zmm27
  c72dfd:	62 f1 fd 48 6f 3d f9 7d 7a ff 	vmovdqa64 -0x858207(%rip),%zmm7        # 41ac00 <parallel_test_signals_kept.signals+0x3d00>
  c72e07:	62 d1 cd 48 6c cc    	vpunpcklqdq %zmm12,%zmm6,%zmm1
  c72e0d:	62 32 c5 48 7e c1    	vpermt2q %zmm17,%zmm7,%zmm8
  c72e13:	62 e2 7d 48 58 0d bb 5d 90 ff 	vpbroadcastd -0x6fa245(%rip),%zmm17        # 578bd8 <x86_break_instruction.legacy_forms+0x660>
  c72e1d:	62 d2 c5 48 7e e7    	vpermt2q %zmm15,%zmm7,%zmm4
  c72e23:	62 32 c5 48 7e da    	vpermt2q %zmm18,%zmm7,%zmm11
  c72e29:	62 32 c5 48 7e f4    	vpermt2q %zmm20,%zmm7,%zmm14
  c72e2f:	62 91 45 48 72 d0 10 	vpsrld $0x10,%zmm24,%zmm7
  c72e36:	62 91 05 48 72 d0 03 	vpsrld $0x3,%zmm24,%zmm15
  c72e3d:	62 33 45 48 25 f9 ec 	vpternlogd $0xec,%zmm17,%zmm7,%zmm15
  c72e44:	62 f1 1d 40 fe f8    	vpaddd %zmm0,%zmm28,%zmm7
  c72e4a:	62 f2 7d 48 58 05 90 5d 90 ff 	vpbroadcastd -0x6fa270(%rip),%zmm0        # 578be4 <x86_break_instruction.legacy_forms+0x66c>
  c72e54:	62 41 fd 48 6f e1    	vmovdqa64 %zmm9,%zmm28
  c72e5a:	62 72 7d 48 5a 0d 4c fa 8d ff 	vbroadcasti32x4 -0x7205b4(%rip),%zmm9        # 5528b0 <x86_disassembly_listing.hex+0xdc0>
  c72e64:	62 f1 45 48 72 e7 1f 	vpsrad $0x1f,%zmm7,%zmm7
  c72e6b:	62 d1 75 40 72 f7 08 	vpslld $0x8,%zmm15,%zmm17
  c72e72:	62 e3 45 48 25 c8 08 	vpternlogd $0x8,%zmm0,%zmm7,%zmm17
  c72e79:	62 f2 7d 48 58 05 69 5d 90 ff 	vpbroadcastd -0x6fa297(%rip),%zmm0        # 578bec <x86_break_instruction.legacy_forms+0x674>
  c72e83:	62 f2 7d 48 58 3d 63 5d 90 ff 	vpbroadcastd -0x6fa29d(%rip),%zmm7        # 578bf0 <x86_break_instruction.legacy_forms+0x678>
  c72e8d:	62 f2 b5 48 83 f5    	vpmultishiftqb %zmm5,%zmm9,%zmm6
  c72e93:	62 71 fd 48 6f 4c 24 02 	vmovdqa64 0x80(%rsp),%zmm9
  c72e9b:	62 d3 75 40 25 d2 e4 	vpternlogd $0xe4,%zmm10,%zmm17,%zmm2
  c72ea2:	62 f3 05 48 25 f0 d8 	vpternlogd $0xd8,%zmm0,%zmm15,%zmm6
  c72ea9:	62 f3 6d 48 25 f7 d8 	vpternlogd $0xd8,%zmm7,%zmm2,%zmm6
  c72eb0:	62 91 25 40 eb d5    	vpord  %zmm29,%zmm27,%zmm2
  c72eb6:	62 91 75 48 62 f9    	vpunpckldq %zmm25,%zmm1,%zmm7
  c72ebc:	62 91 75 48 6a c9    	vpunpckhdq %zmm25,%zmm1,%zmm1
  c72ec2:	62 71 65 40 62 fe    	vpunpckldq %zmm6,%zmm19,%zmm15
  c72ec8:	62 f1 7d 48 70 c2 00 	vpshufd $0x0,%zmm2,%zmm0
  c72ecf:	62 f1 7d 48 70 ea 55 	vpshufd $0x55,%zmm2,%zmm5
  c72ed6:	62 f1 65 40 6a f6    	vpunpckhdq %zmm6,%zmm19,%zmm6
  c72edc:	62 c1 c5 48 6c cf    	vpunpcklqdq %zmm15,%zmm7,%zmm17
  c72ee2:	62 f2 7d 48 8f dc    	vpshufbitqmb %zmm4,%zmm0,%k3
  c72ee8:	62 d1 c5 48 6d ff    	vpunpckhqdq %zmm15,%zmm7,%zmm7
  c72eee:	62 d2 55 48 8f d0    	vpshufbitqmb %zmm8,%zmm5,%k2
  c72ef4:	62 71 f5 48 6c d6    	vpunpcklqdq %zmm6,%zmm1,%zmm10
  c72efa:	62 f1 7d 48 70 ea aa 	vpshufd $0xaa,%zmm2,%zmm5
  c72f01:	62 f1 f5 48 6d ce    	vpunpckhqdq %zmm6,%zmm1,%zmm1
  c72f07:	62 f1 7d 48 70 d2 ff 	vpshufd $0xff,%zmm2,%zmm2
  c72f0e:	62 f2 75 40 00 e4    	vpshufb %zmm4,%zmm17,%zmm4
  c72f14:	62 f3 b5 48 25 64 24 01 78 	vpternlogq $0x78,0x40(%rsp),%zmm9,%zmm4
  c72f1d:	62 d2 45 48 00 c0    	vpshufb %zmm8,%zmm7,%zmm0
  c72f23:	62 f3 b5 48 25 04 24 78 	vpternlogq $0x78,(%rsp),%zmm9,%zmm0
  c72f2b:	62 d2 75 48 00 ce    	vpshufb %zmm14,%zmm1,%zmm1
  c72f31:	c4 61 fb 93 d3       	kmovq  %k3,%r10
  c72f36:	c4 61 fb 93 da       	kmovq  %k2,%r11
  c72f3b:	62 d3 fd 40 25 c9 78 	vpternlogq $0x78,%zmm9,%zmm16,%zmm1
  c72f42:	f3 4d 0f b8 d2       	popcnt %r10,%r10
  c72f47:	f3 4d 0f b8 db       	popcnt %r11,%r11
  c72f4c:	62 f2 7d cb 63 e4    	vpcompressb %zmm4,%zmm4{%k3}{z}
  c72f52:	62 d2 55 48 8f db    	vpshufbitqmb %zmm11,%zmm5,%k3
  c72f58:	62 d1 fe 48 7f 26    	vmovdqu64 %zmm4,(%r14)
  c72f5e:	c5 d9 ef e4          	vpxor  %xmm4,%xmm4,%xmm4
  c72f62:	62 f2 7d ca 63 c4    	vpcompressb %zmm0,%zmm4{%k2}{z}
  c72f68:	62 d2 2d 48 00 c3    	vpshufb %zmm11,%zmm10,%zmm0
  c72f6e:	62 d2 6d 48 8f d6    	vpshufbitqmb %zmm14,%zmm2,%k2
  c72f74:	62 d3 95 48 25 c1 78 	vpternlogq $0x78,%zmm9,%zmm13,%zmm0
  c72f7b:	62 72 7d 48 5a 0d eb f8 8d ff 	vbroadcasti32x4 -0x720715(%rip),%zmm9        # 552870 <x86_disassembly_listing.hex+0xd80>
  c72f85:	62 f2 7d ca 63 c9    	vpcompressb %zmm1,%zmm1{%k2}{z}
  c72f8b:	62 91 fe 48 7f 24 16 	vmovdqu64 %zmm4,(%r14,%r10,1)
  c72f92:	c5 d9 ef e4          	vpxor  %xmm4,%xmm4,%xmm4
  c72f96:	62 f2 7d cb 63 c4    	vpcompressb %zmm0,%zmm4{%k3}{z}
  c72f9c:	4d 01 f2             	add    %r14,%r10
  c72f9f:	c4 61 fb 93 f3       	kmovq  %k3,%r14
  c72fa4:	62 f1 fd 48 6f 05 d2 7c 7a ff 	vmovdqa64 -0x85832e(%rip),%zmm0        # 41ac80 <parallel_test_signals_kept.signals+0x3d80>
  c72fae:	f3 4d 0f b8 fe       	popcnt %r14,%r15
  c72fb3:	c4 61 fb 93 f2       	kmovq  %k2,%r14
  c72fb8:	f3 4d 0f b8 f6       	popcnt %r14,%r14
  c72fbd:	4d 01 fe             	add    %r15,%r14
  c72fc0:	62 91 fe 48 7f 24 13 	vmovdqu64 %zmm4,(%r11,%r10,1)
  c72fc7:	4d 01 da             	add    %r11,%r10
  c72fca:	62 91 fe 48 7f 0c 17 	vmovdqu64 %zmm1,(%r15,%r10,1)
  c72fd1:	62 f1 fd 48 6f 0d 65 7c 7a ff 	vmovdqa64 -0x85839b(%rip),%zmm1        # 41ac40 <parallel_test_signals_kept.signals+0x3d40>
  c72fdb:	4d 01 d6             	add    %r10,%r14
  c72fde:	49 83 f8 c0          	cmp    $0xffffffffffffffc0,%r8
  c72fe2:	0f 85 28 fa ff ff    	jne    c72a10 <x86_encode_64+0x4370>
  c72fe8:	49 89 c1             	mov    %rax,%r9
  c72feb:	4d 29 c1             	sub    %r8,%r9
  c72fee:	4d 8d 51 40          	lea    0x40(%r9),%r10
  c72ff2:	49 39 f2             	cmp    %rsi,%r10
  c72ff5:	0f 86 05 fa ff ff    	jbe    c72a00 <x86_encode_64+0x4360>
  c72ffb:	4c 29 c0             	sub    %r8,%rax
  c72ffe:	48 8d 48 10          	lea    0x10(%rax),%rcx
  c73002:	48 39 f1             	cmp    %rsi,%rcx
  c73005:	0f 86 5a d8 ff ff    	jbe    c70865 <x86_encode_64+0x21c5>
  c7300b:	49 89 c0             	mov    %rax,%r8
  c7300e:	4c 29 c6             	sub    %r8,%rsi
  c73011:	0f 86 01 06 00 00    	jbe    c73618 <x86_encode_64+0x4f78>
  c73017:	49 c1 e0 04          	shl    $0x4,%r8
  c7301b:	48 c1 e6 04          	shl    $0x4,%rsi
  c7301f:	48 8d 84 24 00 01 00 00 	lea    0x100(%rsp),%rax
  c73027:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
  c7302b:	62 f1 fd 48 7f 44 24 07 	vmovdqa64 %zmm0,0x1c0(%rsp)
  c73033:	62 f1 fd 48 7f 44 24 06 	vmovdqa64 %zmm0,0x180(%rsp)
  c7303b:	62 f1 fd 48 7f 44 24 05 	vmovdqa64 %zmm0,0x140(%rsp)
  c73043:	62 f1 fd 48 7f 44 24 04 	vmovdqa64 %zmm0,0x100(%rsp)
  c7304b:	4c 01 c7             	add    %r8,%rdi
  c7304e:	48 89 f2             	mov    %rsi,%rdx
  c73051:	48 89 f9             	mov    %rdi,%rcx
  c73054:	48 89 c7             	mov    %rax,%rdi
  c73057:	48 89 ce             	mov    %rcx,%rsi
  c7305a:	c5 f8 77             	vzeroupper
  c7305d:	e8 ee 13 af ff       	call   764450 <memcpy@plt>
  c73062:	c5 f9 6f a4 24 30 01 00 00 	vmovdqa 0x130(%rsp),%xmm4
  c7306b:	c5 f9 6f 8c 24 00 01 00 00 	vmovdqa 0x100(%rsp),%xmm1
  c73074:	c5 f9 6f 94 24 10 01 00 00 	vmovdqa 0x110(%rsp),%xmm2
  c7307d:	c5 f9 6f 9c 24 20 01 00 00 	vmovdqa 0x120(%rsp),%xmm3
  c73086:	c5 f9 6f ac 24 40 01 00 00 	vmovdqa 0x140(%rsp),%xmm5
  c7308f:	48 8d 05 ea f2 12 02 	lea    0x212f2ea(%rip),%rax        # 2da2380 <x86_template_storage>
  c73096:	62 71 fd 48 6f 3d 60 7b 7a ff 	vmovdqa64 -0x8584a0(%rip),%zmm15        # 41ac00 <parallel_test_signals_kept.signals+0x3d00>
  c730a0:	c5 f9 6f bc 24 80 01 00 00 	vmovdqa 0x180(%rsp),%xmm7
  c730a9:	c5 f9 6f b4 24 90 01 00 00 	vmovdqa 0x190(%rsp),%xmm6
  c730b2:	62 71 fd 48 6f 4c 24 04 	vmovdqa64 0x100(%rsp),%zmm9
  c730ba:	62 71 fd 48 6f 54 24 05 	vmovdqa64 0x140(%rsp),%zmm10
  c730c2:	62 71 fd 48 6f 5c 24 06 	vmovdqa64 0x180(%rsp),%zmm11
  c730ca:	62 71 fd 48 6f 64 24 07 	vmovdqa64 0x1c0(%rsp),%zmm12
  c730d2:	62 e2 7d 48 5a 0d b4 f7 8d ff 	vbroadcasti32x4 -0x72084c(%rip),%zmm17        # 552890 <x86_disassembly_listing.hex+0xda0>
  c730dc:	62 a3 4d 40 25 f6 ff 	vpternlogd $0xff,%zmm22,%zmm22,%zmm22
  c730e3:	62 e2 7d 48 58 2d bf 5a 90 ff 	vpbroadcastd -0x6fa541(%rip),%zmm21        # 578bac <x86_break_instruction.legacy_forms+0x634>
  c730ed:	62 62 7d 48 58 15 c1 5a 90 ff 	vpbroadcastd -0x6fa53f(%rip),%zmm26        # 578bb8 <x86_break_instruction.legacy_forms+0x640>
  c730f7:	62 62 7d 48 58 0d bb 5a 90 ff 	vpbroadcastd -0x6fa545(%rip),%zmm25        # 578bbc <x86_break_instruction.legacy_forms+0x644>
  c73101:	c5 f9 c5 fc 06       	vpextrw $0x6,%xmm4,%edi
  c73106:	c5 f9 6f a4 24 50 01 00 00 	vmovdqa 0x150(%rsp),%xmm4
  c7310f:	c5 f9 c5 c9 06       	vpextrw $0x6,%xmm1,%ecx
  c73114:	c5 f9 c5 d2 06       	vpextrw $0x6,%xmm2,%edx
  c73119:	c5 f9 c5 f3 06       	vpextrw $0x6,%xmm3,%esi
  c7311e:	62 51 35 48 62 ea    	vpunpckldq %zmm10,%zmm9,%zmm13
  c73124:	62 51 25 48 62 f4    	vpunpckldq %zmm12,%zmm11,%zmm14
  c7312a:	62 51 35 48 6a d2    	vpunpckhdq %zmm10,%zmm9,%zmm10
  c73130:	62 51 25 48 6a dc    	vpunpckhdq %zmm12,%zmm11,%zmm11
  c73136:	c1 e1 06             	shl    $0x6,%ecx
  c73139:	c1 e2 06             	shl    $0x6,%edx
  c7313c:	c1 e6 06             	shl    $0x6,%esi
  c7313f:	c1 e7 06             	shl    $0x6,%edi
  c73142:	62 51 ad 48 6c e3    	vpunpcklqdq %zmm11,%zmm10,%zmm12
  c73148:	62 51 95 48 6d ce    	vpunpckhqdq %zmm14,%zmm13,%zmm9
  c7314e:	62 d1 95 48 6c c6    	vpunpcklqdq %zmm14,%zmm13,%zmm0
  c73154:	62 51 ad 48 6d eb    	vpunpckhqdq %zmm11,%zmm10,%zmm13
  c7315a:	c5 fd 6f 4c 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm1
  c73160:	b1 cc                	mov    $0xcc,%cl
  c73162:	c5 fd 6f 54 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm2
  c73168:	62 c2 f5 40 83 e4    	vpmultishiftqb %zmm12,%zmm17,%zmm20
  c7316e:	62 d2 35 48 27 c1    	vptestmd %zmm9,%zmm9,%k0
  c73174:	62 d1 6d 40 72 e1 1f 	vpsrad $0x1f,%zmm9,%zmm18
  c7317b:	62 21 35 48 fe c6    	vpaddd %zmm22,%zmm9,%zmm24
  c73181:	62 43 55 40 25 cc 6c 	vpternlogd $0x6c,%zmm12,%zmm21,%zmm25
  c73188:	c5 fb 92 c9          	kmovd  %ecx,%k1
  c7318c:	c5 f9 c5 cd 06       	vpextrw $0x6,%xmm5,%ecx
  c73191:	c5 f9 6f ac 24 60 01 00 00 	vmovdqa 0x160(%rsp),%xmm5
  c7319a:	62 f3 f5 48 3a 4c 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm1,%zmm1
  c731a3:	62 f3 ed 48 3a 5c 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm2,%zmm3
  c731ac:	c1 e1 06             	shl    $0x6,%ecx
  c731af:	c5 f9 c5 d4 06       	vpextrw $0x6,%xmm4,%edx
  c731b4:	c5 f9 6f a4 24 70 01 00 00 	vmovdqa 0x170(%rsp),%xmm4
  c731bd:	c1 e2 06             	shl    $0x6,%edx
  c731c0:	c5 f9 c5 f5 06       	vpextrw $0x6,%xmm5,%esi
  c731c5:	62 f2 f5 49 64 d3    	vpblendmq %zmm3,%zmm1,%zmm2{%k1}
  c731cb:	62 f2 85 48 7e cb    	vpermt2q %zmm3,%zmm15,%zmm1
  c731d1:	c5 fd 6f 5c 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm3
  c731d7:	c5 f9 c5 cf 06       	vpextrw $0x6,%xmm7,%ecx
  c731dc:	c5 f9 6f bc 24 a0 01 00 00 	vmovdqa 0x1a0(%rsp),%xmm7
  c731e5:	c1 e6 06             	shl    $0x6,%esi
  c731e8:	c1 e1 06             	shl    $0x6,%ecx
  c731eb:	62 f3 e5 48 3a 5c 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm3,%zmm3
  c731f4:	c5 f9 c5 fc 06       	vpextrw $0x6,%xmm4,%edi
  c731f9:	c5 fd 6f 64 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm4
  c731ff:	c5 f9 c5 d6 06       	vpextrw $0x6,%xmm6,%edx
  c73204:	c5 f9 6f b4 24 b0 01 00 00 	vmovdqa 0x1b0(%rsp),%xmm6
  c7320d:	c1 e7 06             	shl    $0x6,%edi
  c73210:	c1 e2 06             	shl    $0x6,%edx
  c73213:	62 f3 dd 48 3a 6c 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm4,%zmm5
  c7321c:	c5 f9 c5 f7 06       	vpextrw $0x6,%xmm7,%esi
  c73221:	c1 e6 06             	shl    $0x6,%esi
  c73224:	c5 f9 c5 fe 06       	vpextrw $0x6,%xmm6,%edi
  c73229:	c5 fd 6f 74 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm6
  c7322f:	0f b7 94 24 dc 01 00 00 	movzwl 0x1dc(%rsp),%edx
  c73237:	c1 e7 06             	shl    $0x6,%edi
  c7323a:	62 f2 e5 49 64 e5    	vpblendmq %zmm5,%zmm3,%zmm4{%k1}
  c73240:	62 f2 85 48 7e dd    	vpermt2q %zmm5,%zmm15,%zmm3
  c73246:	c5 fd 6f 6c 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm5
  c7324c:	62 f3 cd 48 3a 7c 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm6,%zmm7
  c73255:	0f b7 8c 24 cc 01 00 00 	movzwl 0x1cc(%rsp),%ecx
  c7325d:	0f b7 bc 24 fc 01 00 00 	movzwl 0x1fc(%rsp),%edi
  c73265:	62 f3 d5 48 3a 6c 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm5,%zmm5
  c7326e:	0f b7 b4 24 ec 01 00 00 	movzwl 0x1ec(%rsp),%esi
  c73276:	62 71 6d 48 6a d4    	vpunpckhdq %zmm4,%zmm2,%zmm10
  c7327c:	c1 e2 06             	shl    $0x6,%edx
  c7327f:	c5 7d 6f 44 02 60    	vmovdqa 0x60(%rdx,%rax,1),%ymm8
  c73285:	c1 e1 06             	shl    $0x6,%ecx
  c73288:	c1 e7 06             	shl    $0x6,%edi
  c7328b:	c1 e6 06             	shl    $0x6,%esi
  c7328e:	62 e3 bd 48 3a 44 07 03 01 	vinserti64x4 $0x1,0x60(%rdi,%rax,1),%zmm8,%zmm16
  c73297:	62 f2 d5 49 64 f7    	vpblendmq %zmm7,%zmm5,%zmm6{%k1}
  c7329d:	62 f2 85 48 7e ef    	vpermt2q %zmm7,%zmm15,%zmm5
  c732a3:	c5 fd 6f 7c 01 40    	vmovdqa 0x40(%rcx,%rax,1),%ymm7
  c732a9:	62 f3 c5 48 3a 7c 06 02 01 	vinserti64x4 $0x1,0x40(%rsi,%rax,1),%zmm7,%zmm7
  c732b2:	62 32 c5 49 64 c0    	vpblendmq %zmm16,%zmm7,%zmm8{%k1}
  c732b8:	62 b2 85 48 7e f8    	vpermt2q %zmm16,%zmm15,%zmm7
  c732be:	62 e2 7d 48 5a 05 a8 f5 8d ff 	vbroadcasti32x4 -0x720a58(%rip),%zmm16        # 552870 <x86_disassembly_listing.hex+0xd80>
  c732c8:	62 51 4d 48 6a d8    	vpunpckhdq %zmm8,%zmm6,%zmm11
  c732ce:	62 51 ad 48 6d d3    	vpunpckhqdq %zmm11,%zmm10,%zmm10
  c732d4:	62 d1 25 48 72 d4 1a 	vpsrld $0x1a,%zmm12,%zmm11
  c732db:	62 72 25 48 36 35 5b 79 7a ff 	vpermd -0x8586a5(%rip),%zmm11,%zmm14        # 41ac40 <parallel_test_signals_kept.signals+0x3d40>
  c732e5:	62 e2 25 48 36 1d 91 79 7a ff 	vpermd -0x85866f(%rip),%zmm11,%zmm19        # 41ac80 <parallel_test_signals_kept.signals+0x3d80>
  c732ef:	62 72 25 48 36 1d c7 79 7a ff 	vpermd -0x858639(%rip),%zmm11,%zmm11        # 41acc0 <parallel_test_signals_kept.signals+0x3dc0>
  c732f9:	62 d1 45 40 72 d2 1d 	vpsrld $0x1d,%zmm10,%zmm23
  c73300:	62 52 fd 40 83 fc    	vpmultishiftqb %zmm12,%zmm16,%zmm15
  c73306:	62 e2 7d 48 5a 05 70 f5 8d ff 	vbroadcasti32x4 -0x720a90(%rip),%zmm16        # 552880 <x86_disassembly_listing.hex+0xd90>
  c73310:	62 c2 fd 40 83 c4    	vpmultishiftqb %zmm12,%zmm16,%zmm16
  c73316:	62 e3 05 58 25 05 83 58 90 ff d8 	vpternlogd $0xd8,-0x6fa77d(%rip){1to16},%zmm15,%zmm16        # 578ba4 <x86_break_instruction.legacy_forms+0x62c>
  c73321:	62 d1 05 48 72 f4 04 	vpslld $0x4,%zmm12,%zmm15
  c73328:	62 d1 05 48 72 e7 1f 	vpsrad $0x1f,%zmm15,%zmm15
  c7332f:	62 e3 7d 50 25 25 6e 58 90 ff e4 	vpternlogd $0xe4,-0x6fa792(%rip){1to16},%zmm16,%zmm20        # 578ba8 <x86_break_instruction.legacy_forms+0x630>
  c7333a:	62 e2 7d 48 5a 05 5c f5 8d ff 	vbroadcasti32x4 -0x720aa4(%rip),%zmm16        # 5528a0 <x86_disassembly_listing.hex+0xdb0>
  c73344:	62 c2 7d 40 00 c4    	vpshufb %zmm12,%zmm16,%zmm16
  c7334a:	62 c3 5d 40 25 de f8 	vpternlogd $0xf8,%zmm14,%zmm20,%zmm19
  c73351:	62 23 05 48 25 d3 ea 	vpternlogd $0xea,%zmm19,%zmm15,%zmm26
  c73358:	62 b1 0d 48 72 f0 10 	vpslld $0x10,%zmm16,%zmm14
  c7335f:	62 a1 05 48 db c0    	vpandd %zmm16,%zmm15,%zmm16
  c73365:	62 e3 25 58 25 05 84 58 90 ff ec 	vpternlogd $0xec,-0x6fa77c(%rip){1to16},%zmm11,%zmm16        # 578bf4 <x86_break_instruction.legacy_forms+0x67c>
  c73370:	62 71 05 58 db 1d 86 58 90 ff 	vpandd -0x6fa77a(%rip){1to16},%zmm15,%zmm11        # 578c00 <x86_break_instruction.legacy_forms+0x688>
  c7337a:	62 d1 75 40 72 e6 1f 	vpsrad $0x1f,%zmm14,%zmm17
  c73381:	62 72 7e 48 38 f0    	vpmovm2d %k0,%zmm14
  c73387:	62 e3 2d 58 25 05 66 58 90 ff f8 	vpternlogd $0xf8,-0x6fa79a(%rip){1to16},%zmm10,%zmm16        # 578bf8 <x86_break_instruction.legacy_forms+0x680>
  c73392:	62 33 05 48 25 f1 c8 	vpternlogd $0xc8,%zmm17,%zmm15,%zmm14
  c73399:	62 c1 6d 40 ef c9    	vpxord %zmm9,%zmm18,%zmm17
  c7339f:	62 e2 7d 48 58 15 07 58 90 ff 	vpbroadcastd -0x6fa7f9(%rip),%zmm18        # 578bb0 <x86_break_instruction.legacy_forms+0x638>
  c733a9:	62 72 7d 48 5a 3d 7d f4 8d ff 	vbroadcasti32x4 -0x720b83(%rip),%zmm15        # 552830 <x86_disassembly_listing.hex+0xd40>
  c733b3:	62 a2 7d 48 44 c9    	vplzcntd %zmm17,%zmm17
  c733b9:	62 a2 6d 40 45 c9    	vpsrlvd %zmm17,%zmm18,%zmm17
  c733bf:	62 23 35 48 25 c1 14 	vpternlogd $0x14,%zmm17,%zmm9,%zmm24
  c733c6:	62 a2 3d 40 14 cf    	vprorvd %zmm23,%zmm24,%zmm17
  c733cc:	62 62 7d 48 58 05 de 57 90 ff 	vpbroadcastd -0x6fa822(%rip),%zmm24        # 578bb4 <x86_break_instruction.legacy_forms+0x63c>
  c733d6:	62 b1 75 40 72 e1 1f 	vpsrad $0x1f,%zmm17,%zmm17
  c733dd:	62 23 0d 48 25 c3 ea 	vpternlogd $0xea,%zmm19,%zmm14,%zmm24
  c733e4:	62 03 75 40 25 d0 b8 	vpternlogd $0xb8,%zmm24,%zmm17,%zmm26
  c733eb:	62 21 35 40 fe c6    	vpaddd %zmm22,%zmm25,%zmm24
  c733f1:	62 d1 35 40 72 d4 08 	vpsrld $0x8,%zmm12,%zmm25
  c733f8:	62 63 55 50 25 0d bd 57 90 ff 6c 	vpternlogd $0x6c,-0x6fa843(%rip){1to16},%zmm21,%zmm25        # 578bc0 <x86_break_instruction.legacy_forms+0x648>
  c73403:	62 51 15 48 eb e4    	vpord  %zmm12,%zmm13,%zmm12
  c73409:	62 d1 1d 48 72 f4 07 	vpslld $0x7,%zmm12,%zmm12
  c73410:	62 a1 35 40 fe ee    	vpaddd %zmm22,%zmm25,%zmm21
  c73416:	62 62 7d 48 58 0d a4 57 90 ff 	vpbroadcastd -0x6fa85c(%rip),%zmm25        # 578bc4 <x86_break_instruction.legacy_forms+0x64c>
  c73420:	62 63 3d 50 25 0d 9d 57 90 ff ea 	vpternlogd $0xea,-0x6fa863(%rip){1to16},%zmm24,%zmm25        # 578bc8 <x86_break_instruction.legacy_forms+0x650>
  c7342b:	62 61 5d 50 db 05 9b 57 90 ff 	vpandd -0x6fa865(%rip){1to16},%zmm20,%zmm24        # 578bd0 <x86_break_instruction.legacy_forms+0x658>
  c73435:	62 b1 5d 40 72 d4 03 	vpsrld $0x3,%zmm20,%zmm20
  c7343c:	62 e3 2d 58 25 25 95 57 90 ff a2 	vpternlogd $0xa2,-0x6fa86b(%rip){1to16},%zmm10,%zmm20        # 578bdc <x86_break_instruction.legacy_forms+0x664>
  c73447:	62 63 55 50 25 0d 7a 57 90 ff f8 	vpternlogd $0xf8,-0x6fa886(%rip){1to16},%zmm21,%zmm25        # 578bcc <x86_break_instruction.legacy_forms+0x654>
  c73452:	62 a1 5d 40 fe f6    	vpaddd %zmm22,%zmm20,%zmm22
  c73458:	62 e2 5d 50 3b 25 7e 57 90 ff 	vpminud -0x6fa882(%rip){1to16},%zmm20,%zmm20        # 578be0 <x86_break_instruction.legacy_forms+0x668>
  c73462:	62 03 2d 48 25 c1 f8 	vpternlogd $0xf8,%zmm25,%zmm10,%zmm24
  c73469:	62 e2 3d 50 3b 2d 61 57 90 ff 	vpminud -0x6fa89f(%rip){1to16},%zmm24,%zmm21        # 578bd4 <x86_break_instruction.legacy_forms+0x65c>
  c73473:	62 b1 3d 40 72 d3 10 	vpsrld $0x10,%zmm19,%zmm24
  c7347a:	62 b1 65 40 72 d3 03 	vpsrld $0x3,%zmm19,%zmm19
  c73481:	62 b1 4d 40 72 e6 1f 	vpsrad $0x1f,%zmm22,%zmm22
  c73488:	62 e3 3d 50 25 1d 45 57 90 ff ec 	vpternlogd $0xec,-0x6fa8bb(%rip){1to16},%zmm24,%zmm19        # 578bd8 <x86_break_instruction.legacy_forms+0x660>
  c73493:	62 a3 5d 40 25 c5 fe 	vpternlogd $0xfe,%zmm21,%zmm20,%zmm16
  c7349a:	62 b1 3d 40 72 f3 08 	vpslld $0x8,%zmm19,%zmm24
  c734a1:	62 63 4d 50 25 05 38 57 90 ff 08 	vpternlogd $0x8,-0x6fa8c8(%rip){1to16},%zmm22,%zmm24        # 578be4 <x86_break_instruction.legacy_forms+0x66c>
  c734ac:	62 e2 7d 48 5a 35 fa f3 8d ff 	vbroadcasti32x4 -0x720c06(%rip),%zmm22        # 5528b0 <x86_disassembly_listing.hex+0xdc0>
  c734b6:	62 73 3d 50 25 25 27 57 90 ff e4 	vpternlogd $0xe4,-0x6fa8d9(%rip){1to16},%zmm24,%zmm12        # 578be8 <x86_break_instruction.legacy_forms+0x670>
  c734c1:	62 c2 cd 40 83 f5    	vpmultishiftqb %zmm13,%zmm22,%zmm22
  c734c7:	62 71 0d 58 db 2d 2b 57 90 ff 	vpandd -0x6fa8d5(%rip){1to16},%zmm14,%zmm13        # 578bfc <x86_break_instruction.legacy_forms+0x684>
  c734d1:	62 e3 65 50 25 35 10 57 90 ff d8 	vpternlogd $0xd8,-0x6fa8f0(%rip){1to16},%zmm19,%zmm22        # 578bec <x86_break_instruction.legacy_forms+0x674>
  c734dc:	62 e3 1d 58 25 35 09 57 90 ff d8 	vpternlogd $0xd8,-0x6fa8f7(%rip){1to16},%zmm12,%zmm22        # 578bf0 <x86_break_instruction.legacy_forms+0x678>
  c734e7:	62 d1 1d 48 72 c9 01 	vprold $0x1,%zmm9,%zmm12
  c734ee:	62 53 75 40 25 dd b8 	vpternlogd $0xb8,%zmm13,%zmm17,%zmm11
  c734f5:	62 31 25 48 eb d0    	vpord  %zmm16,%zmm11,%zmm10
  c734fb:	62 32 1d 48 14 df    	vprorvd %zmm23,%zmm12,%zmm11
  c73501:	62 53 0d 48 25 d9 e2 	vpternlogd $0xe2,%zmm9,%zmm14,%zmm11
  c73508:	62 53 75 40 25 d9 e2 	vpternlogd $0xe2,%zmm9,%zmm17,%zmm11
  c7350f:	62 51 7d 48 62 cb    	vpunpckldq %zmm11,%zmm0,%zmm9
  c73515:	62 d1 7d 48 6a c3    	vpunpckhdq %zmm11,%zmm0,%zmm0
  c7351b:	62 31 2d 40 62 de    	vpunpckldq %zmm22,%zmm26,%zmm11
  c73521:	62 31 2d 40 6a e6    	vpunpckhdq %zmm22,%zmm26,%zmm12
  c73527:	62 51 b5 48 6c eb    	vpunpcklqdq %zmm11,%zmm9,%zmm13
  c7352d:	62 51 b5 48 6d cb    	vpunpckhqdq %zmm11,%zmm9,%zmm9
  c73533:	62 51 fd 48 6c dc    	vpunpcklqdq %zmm12,%zmm0,%zmm11
  c73539:	62 d1 fd 48 6d c4    	vpunpckhqdq %zmm12,%zmm0,%zmm0
  c7353f:	62 51 7d 48 70 e2 00 	vpshufd $0x0,%zmm10,%zmm12
  c73546:	62 72 15 48 00 e9    	vpshufb %zmm1,%zmm13,%zmm13
  c7354c:	62 f2 1d 48 8f c9    	vpshufbitqmb %zmm1,%zmm12,%k1
  c73552:	62 51 7d 48 70 e2 55 	vpshufd $0x55,%zmm10,%zmm12
  c73559:	62 f2 7d 48 00 c7    	vpshufb %zmm7,%zmm0,%zmm0
  c7355f:	62 53 ed 48 25 ef 78 	vpternlogq $0x78,%zmm15,%zmm2,%zmm13
  c73566:	62 f2 35 48 00 d3    	vpshufb %zmm3,%zmm9,%zmm2
  c7356c:	62 d3 bd 48 25 c7 78 	vpternlogq $0x78,%zmm15,%zmm8,%zmm0
  c73573:	62 72 7d c9 63 e9    	vpcompressb %zmm13,%zmm1{%k1}{z}
  c73579:	c4 e1 fb 93 c1       	kmovq  %k1,%rax
  c7357e:	62 f2 1d 48 8f cb    	vpshufbitqmb %zmm3,%zmm12,%k1
  c73584:	62 d1 7d 48 70 da aa 	vpshufd $0xaa,%zmm10,%zmm3
  c7358b:	62 d3 dd 48 25 d7 78 	vpternlogq $0x78,%zmm15,%zmm4,%zmm2
  c73592:	f3 48 0f b8 c0       	popcnt %rax,%rax
  c73597:	49 8d 0c 06          	lea    (%r14,%rax,1),%rcx
  c7359b:	c4 e1 fb 93 d1       	kmovq  %k1,%rdx
  c735a0:	f3 48 0f b8 d2       	popcnt %rdx,%rdx
  c735a5:	62 d1 fe 48 7f 0e    	vmovdqu64 %zmm1,(%r14)
  c735ab:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
  c735af:	62 f2 7d c9 63 d1    	vpcompressb %zmm2,%zmm1{%k1}{z}
  c735b5:	62 f2 25 48 00 d5    	vpshufb %zmm5,%zmm11,%zmm2
  c735bb:	62 f2 65 48 8f cd    	vpshufbitqmb %zmm5,%zmm3,%k1
  c735c1:	62 d3 cd 48 25 d7 78 	vpternlogq $0x78,%zmm15,%zmm6,%zmm2
  c735c8:	c4 e1 fb 93 f1       	kmovq  %k1,%rsi
  c735cd:	f3 48 0f b8 f6       	popcnt %rsi,%rsi
  c735d2:	62 d1 fe 48 7f 0c 06 	vmovdqu64 %zmm1,(%r14,%rax,1)
  c735d9:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
  c735dd:	62 f2 7d c9 63 d1    	vpcompressb %zmm2,%zmm1{%k1}{z}
  c735e3:	62 d1 7d 48 70 d2 ff 	vpshufd $0xff,%zmm10,%zmm2
  c735ea:	48 8d 04 11          	lea    (%rcx,%rdx,1),%rax
  c735ee:	62 f2 6d 48 8f cf    	vpshufbitqmb %zmm7,%zmm2,%k1
  c735f4:	62 f2 7d c9 63 c0    	vpcompressb %zmm0,%zmm0{%k1}{z}
  c735fa:	62 f1 fe 48 7f 0c 0a 	vmovdqu64 %zmm1,(%rdx,%rcx,1)
  c73601:	c4 e1 fb 93 c9       	kmovq  %k1,%rcx
  c73606:	f3 4c 0f b8 f1       	popcnt %rcx,%r14
  c7360b:	49 01 f6             	add    %rsi,%r14
  c7360e:	49 01 c6             	add    %rax,%r14
  c73611:	62 f1 fe 48 7f 04 06 	vmovdqu64 %zmm0,(%rsi,%rax,1)
  c73618:	49 29 de             	sub    %rbx,%r14
  c7361b:	64 48 8b 04 25 28 00 00 00 	mov    %fs:0x28,%rax
  c73624:	48 3b 84 24 00 02 00 00 	cmp    0x200(%rsp),%rax
  c7362c:	75 15                	jne    c73643 <x86_encode_64+0x4fa3>
  c7362e:	4c 89 f0             	mov    %r14,%rax
  c73631:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  c73635:	5b                   	pop    %rbx
  c73636:	41 5c                	pop    %r12
  c73638:	41 5d                	pop    %r13
  c7363a:	41 5e                	pop    %r14
  c7363c:	41 5f                	pop    %r15
  c7363e:	5d                   	pop    %rbp
  c7363f:	c5 f8 77             	vzeroupper
  c73642:	c3                   	ret
  c73643:	c5 f8 77             	vzeroupper
  c73646:	e8 95 04 af ff       	call   763ae0 <__stack_chk_fail@plt>
