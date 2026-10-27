
head/build/compiler:     file format elf64-x86-64


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

00000000016bdc70 <pp_define>:
 16bdc70:	55                   	push   %rbp
 16bdc71:	41 57                	push   %r15
 16bdc73:	41 56                	push   %r14
 16bdc75:	41 55                	push   %r13
 16bdc77:	41 54                	push   %r12
 16bdc79:	53                   	push   %rbx
 16bdc7a:	48 81 ec 58 01 00 00 	sub    $0x158,%rsp
 16bdc81:	64 48 8b 04 25 28 00 	mov    %fs:0x28,%rax
 16bdc88:	00 00 
 16bdc8a:	48 89 fb             	mov    %rdi,%rbx
 16bdc8d:	41 89 cc             	mov    %ecx,%r12d
 16bdc90:	48 89 84 24 50 01 00 	mov    %rax,0x150(%rsp)
 16bdc97:	00 
 16bdc98:	48 8b 87 80 0b 00 00 	mov    0xb80(%rdi),%rax
 16bdc9f:	89 f7                	mov    %esi,%edi
 16bdca1:	48 69 ff e8 00 00 00 	imul   $0xe8,%rdi,%rdi
 16bdca8:	4c 8d 3c 38          	lea    (%rax,%rdi,1),%r15
 16bdcac:	3b 4c 38 3c          	cmp    0x3c(%rax,%rdi,1),%ecx
 16bdcb0:	73 48                	jae    16bdcfa <pp_define+0x8a>
 16bdcb2:	4a 8d 04 a5 00 00 00 	lea    0x0(,%r12,4),%rax
 16bdcb9:	00 
 16bdcba:	49 03 47 58          	add    0x58(%r15),%rax
 16bdcbe:	44 39 c1             	cmp    %r8d,%ecx
 16bdcc1:	72 40                	jb     16bdd03 <pp_define+0x93>
 16bdcc3:	ff c9                	dec    %ecx
 16bdcc5:	48 89 df             	mov    %rbx,%rdi
 16bdcc8:	4c 89 fe             	mov    %r15,%rsi
 16bdccb:	e8 60 22 00 00       	call   16bff30 <pp_line_end_location>
 16bdcd0:	64 48 8b 0c 25 28 00 	mov    %fs:0x28,%rcx
 16bdcd7:	00 00 
 16bdcd9:	48 3b 8c 24 50 01 00 	cmp    0x150(%rsp),%rcx
 16bdce0:	00 
 16bdce1:	0f 85 11 0a 00 00    	jne    16be6f8 <pp_define+0xa88>
 16bdce7:	48 8d 0d d7 44 04 ff 	lea    -0xfbbb29(%rip),%rcx        # 7021c5 <pp_string_value.meaning+0x4e77c>
 16bdcee:	48 89 df             	mov    %rbx,%rdi
 16bdcf1:	be 01 00 00 00       	mov    $0x1,%esi
 16bdcf6:	89 c2                	mov    %eax,%edx
 16bdcf8:	eb 7a                	jmp    16bdd74 <pp_define+0x104>
 16bdcfa:	49 8d 47 30          	lea    0x30(%r15),%rax
 16bdcfe:	44 39 c1             	cmp    %r8d,%ecx
 16bdd01:	73 c0                	jae    16bdcc3 <pp_define+0x53>
 16bdd03:	44 8b 30             	mov    (%rax),%r14d
 16bdd06:	49 8b 47 50          	mov    0x50(%r15),%rax
 16bdd0a:	42 0f b6 0c 20       	movzbl (%rax,%r12,1),%ecx
 16bdd0f:	41 01 d6             	add    %edx,%r14d
 16bdd12:	80 e1 7f             	and    $0x7f,%cl
 16bdd15:	80 f9 01             	cmp    $0x1,%cl
 16bdd18:	75 31                	jne    16bdd4b <pp_define+0xdb>
 16bdd1a:	49 8b 4f 60          	mov    0x60(%r15),%rcx
 16bdd1e:	42 8b 2c a1          	mov    (%rcx,%r12,4),%ebp
 16bdd22:	48 81 fd a9 00 00 00 	cmp    $0xa9,%rbp
 16bdd29:	75 61                	jne    16bdd8c <pp_define+0x11c>
 16bdd2b:	64 48 8b 04 25 28 00 	mov    %fs:0x28,%rax
 16bdd32:	00 00 
 16bdd34:	48 3b 84 24 50 01 00 	cmp    0x150(%rsp),%rax
 16bdd3b:	00 
 16bdd3c:	0f 85 b6 09 00 00    	jne    16be6f8 <pp_define+0xa88>
 16bdd42:	48 8d 0d 53 44 04 ff 	lea    -0xfbbbad(%rip),%rcx        # 70219c <pp_string_value.meaning+0x4e753>
 16bdd49:	eb 1e                	jmp    16bdd69 <pp_define+0xf9>
 16bdd4b:	64 48 8b 04 25 28 00 	mov    %fs:0x28,%rax
 16bdd52:	00 00 
 16bdd54:	48 3b 84 24 50 01 00 	cmp    0x150(%rsp),%rax
 16bdd5b:	00 
 16bdd5c:	0f 85 96 09 00 00    	jne    16be6f8 <pp_define+0xa88>
 16bdd62:	48 8d 0d 4f d3 f8 fe 	lea    -0x1072cb1(%rip),%rcx        # 64b0b8 <tier0_test_vector_type_class.classes+0x1fc99>
 16bdd69:	be 01 00 00 00       	mov    $0x1,%esi
 16bdd6e:	48 89 df             	mov    %rbx,%rdi
 16bdd71:	44 89 f2             	mov    %r14d,%edx
 16bdd74:	31 c0                	xor    %eax,%eax
 16bdd76:	48 81 c4 58 01 00 00 	add    $0x158,%rsp
 16bdd7d:	5b                   	pop    %rbx
 16bdd7e:	41 5c                	pop    %r12
 16bdd80:	41 5d                	pop    %r13
 16bdd82:	41 5e                	pop    %r14
 16bdd84:	41 5f                	pop    %r15
 16bdd86:	5d                   	pop    %rbp
 16bdd87:	e9 24 94 fb ff       	jmp    16771b0 <pp_diagnose>
 16bdd8c:	49 ff c4             	inc    %r12
 16bdd8f:	89 6c 24 68          	mov    %ebp,0x68(%rsp)
 16bdd93:	48 c7 44 24 6c 00 00 	movq   $0x0,0x6c(%rsp)
 16bdd9a:	00 00 
 16bdd9c:	c7 44 24 74 00 00 00 	movl   $0x0,0x74(%rsp)
 16bdda3:	00 
 16bdda4:	89 74 24 78          	mov    %esi,0x78(%rsp)
 16bdda8:	89 54 24 7c          	mov    %edx,0x7c(%rsp)
 16bddac:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 16bddb0:	89 54 24 0c          	mov    %edx,0xc(%rsp)
 16bddb4:	4c 89 44 24 10       	mov    %r8,0x10(%rsp)
 16bddb9:	44 89 74 24 24       	mov    %r14d,0x24(%rsp)
 16bddbe:	44 89 a4 24 80 00 00 	mov    %r12d,0x80(%rsp)
 16bddc5:	00 
 16bddc6:	44 89 84 24 84 00 00 	mov    %r8d,0x84(%rsp)
 16bddcd:	00 
 16bddce:	44 89 a4 24 88 00 00 	mov    %r12d,0x88(%rsp)
 16bddd5:	00 
 16bddd6:	44 89 b4 24 8c 00 00 	mov    %r14d,0x8c(%rsp)
 16bdddd:	00 
 16bddde:	c5 fa 7f 84 24 90 00 	vmovdqu %xmm0,0x90(%rsp)
 16bdde5:	00 00 
 16bdde7:	48 c7 84 24 a0 00 00 	movq   $0x0,0xa0(%rsp)
 16bddee:	00 00 00 00 00 
 16bddf3:	0f b6 8b 78 02 00 00 	movzbl 0x278(%rbx),%ecx
 16bddfa:	c5 fa 7f 84 24 28 01 	vmovdqu %xmm0,0x128(%rsp)
 16bde01:	00 00 
 16bde03:	88 8c 24 38 01 00 00 	mov    %cl,0x138(%rsp)
 16bde0a:	48 c7 84 24 40 01 00 	movq   $0x0,0x140(%rsp)
 16bde11:	00 00 00 00 00 
 16bde16:	45 39 c4             	cmp    %r8d,%r12d
 16bde19:	73 2f                	jae    16bde4a <pp_define+0x1da>
 16bde1b:	42 0f b6 04 20       	movzbl (%rax,%r12,1),%eax
 16bde20:	49 8b 77 68          	mov    0x68(%r15),%rsi
 16bde24:	44 89 e1             	mov    %r12d,%ecx
 16bde27:	c1 e9 06             	shr    $0x6,%ecx
 16bde2a:	24 7f                	and    $0x7f,%al
 16bde2c:	3c 0f                	cmp    $0xf,%al
 16bde2e:	75 0a                	jne    16bde3a <pp_define+0x1ca>
 16bde30:	48 8b 3c ce          	mov    (%rsi,%rcx,8),%rdi
 16bde34:	4c 0f a3 e7          	bt     %r12,%rdi
 16bde38:	73 7b                	jae    16bdeb5 <pp_define+0x245>
 16bde3a:	48 8b 0c ce          	mov    (%rsi,%rcx,8),%rcx
 16bde3e:	44 89 e7             	mov    %r12d,%edi
 16bde41:	83 e7 3f             	and    $0x3f,%edi
 16bde44:	48 0f a3 f9          	bt     %rdi,%rcx
 16bde48:	73 08                	jae    16bde52 <pp_define+0x1e2>
 16bde4a:	44 89 c0             	mov    %r8d,%eax
 16bde4d:	e9 9e 00 00 00       	jmp    16bdef0 <pp_define+0x280>
 16bde52:	84 c0                	test   %al,%al
 16bde54:	48 8d 05 1c a7 f0 fe 	lea    -0x10f58e4(%rip),%rax        # 5c8577 <foreign_rank_visibilities+0x45d3>
 16bde5b:	48 8d 0d 9d b5 fd fe 	lea    -0x1024a63(%rip),%rcx        # 6993ff <fuzz_comment_end+0x36aa8>
 16bde62:	8b 54 24 0c          	mov    0xc(%rsp),%edx
 16bde66:	4c 8d 35 d9 a6 f0 fe 	lea    -0x10f5927(%rip),%r14        # 5c8546 <foreign_rank_visibilities+0x45a2>
 16bde6d:	4c 8b 44 24 10       	mov    0x10(%rsp),%r8
 16bde72:	48 89 df             	mov    %rbx,%rdi
 16bde75:	4c 89 fe             	mov    %r15,%rsi
 16bde78:	48 0f 44 c8          	cmove  %rax,%rcx
 16bde7c:	81 7b 08 cf 07 00 00 	cmpl   $0x7cf,0x8(%rbx)
 16bde83:	4c 0f 42 f1          	cmovb  %rcx,%r14
 16bde87:	44 89 e1             	mov    %r12d,%ecx
 16bde8a:	e8 c1 27 00 00       	call   16c0650 <pp_define_location>
 16bde8f:	48 8d 0d 99 32 f2 fe 	lea    -0x10dcd67(%rip),%rcx        # 5e112f <parse_test_openers+0x14e33>
 16bde96:	89 c2                	mov    %eax,%edx
 16bde98:	48 89 df             	mov    %rbx,%rdi
 16bde9b:	31 f6                	xor    %esi,%esi
 16bde9d:	4d 89 f0             	mov    %r14,%r8
 16bdea0:	31 c0                	xor    %eax,%eax
 16bdea2:	e8 09 93 fb ff       	call   16771b0 <pp_diagnose>
 16bdea7:	4c 8b 44 24 10       	mov    0x10(%rsp),%r8
 16bdeac:	8b 54 24 0c          	mov    0xc(%rsp),%edx
 16bdeb0:	44 89 c0             	mov    %r8d,%eax
 16bdeb3:	eb 3b                	jmp    16bdef0 <pp_define+0x280>
 16bdeb5:	48 8d 54 24 68       	lea    0x68(%rsp),%rdx
 16bdeba:	4c 8d 8c 24 a8 00 00 	lea    0xa8(%rsp),%r9
 16bdec1:	00 
 16bdec2:	48 89 df             	mov    %rbx,%rdi
 16bdec5:	4c 89 fe             	mov    %r15,%rsi
 16bdec8:	44 89 e1             	mov    %r12d,%ecx
 16bdecb:	e8 70 22 00 00       	call   16c0140 <pp_define_parameters>
 16bded0:	84 c0                	test   %al,%al
 16bded2:	0f 84 d9 07 00 00    	je     16be6b1 <pp_define+0xa41>
 16bded8:	44 8b a4 24 80 00 00 	mov    0x80(%rsp),%r12d
 16bdedf:	00 
 16bdee0:	8b 84 24 84 00 00 00 	mov    0x84(%rsp),%eax
 16bdee7:	8b 54 24 0c          	mov    0xc(%rsp),%edx
 16bdeeb:	4c 8b 44 24 10       	mov    0x10(%rsp),%r8
 16bdef0:	41 89 c6             	mov    %eax,%r14d
 16bdef3:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
 16bdef8:	0f b6 83 78 02 00 00 	movzbl 0x278(%rbx),%eax
 16bdeff:	45 29 e6             	sub    %r12d,%r14d
 16bdf02:	0f 86 e3 05 00 00    	jbe    16be4eb <pp_define+0x87b>
 16bdf08:	4d 8b 6f 50          	mov    0x50(%r15),%r13
 16bdf0c:	49 8b 77 60          	mov    0x60(%r15),%rsi
 16bdf10:	44 89 e1             	mov    %r12d,%ecx
 16bdf13:	48 89 4c 24 18       	mov    %rcx,0x18(%rsp)
 16bdf18:	48 89 6c 24 50       	mov    %rbp,0x50(%rsp)
 16bdf1d:	84 c0                	test   %al,%al
 16bdf1f:	74 3c                	je     16bdf5d <pp_define+0x2ed>
 16bdf21:	48 8d 44 24 65       	lea    0x65(%rsp),%rax
 16bdf26:	4c 8d 44 24 67       	lea    0x67(%rsp),%r8
 16bdf2b:	4c 8d 4c 24 66       	lea    0x66(%rsp),%r9
 16bdf30:	4c 89 ef             	mov    %r13,%rdi
 16bdf33:	44 89 e2             	mov    %r12d,%edx
 16bdf36:	48 89 04 24          	mov    %rax,(%rsp)
 16bdf3a:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
 16bdf3f:	e8 4c 27 00 00       	call   16c0690 <pp_scan_body_vector>
 16bdf44:	4c 8b 44 24 10       	mov    0x10(%rsp),%r8
 16bdf49:	8b 54 24 0c          	mov    0xc(%rsp),%edx
 16bdf4d:	44 0f b6 5c 24 67    	movzbl 0x67(%rsp),%r11d
 16bdf53:	0f b6 4c 24 65       	movzbl 0x65(%rsp),%ecx
 16bdf58:	e9 c6 03 00 00       	jmp    16be323 <pp_define+0x6b3>
 16bdf5d:	8b 7c 24 40          	mov    0x40(%rsp),%edi
 16bdf61:	48 89 7c 24 48       	mov    %rdi,0x48(%rsp)
 16bdf66:	48 29 cf             	sub    %rcx,%rdi
 16bdf69:	48 89 74 24 30       	mov    %rsi,0x30(%rsp)
 16bdf6e:	48 83 ff 08          	cmp    $0x8,%rdi
 16bdf72:	73 0d                	jae    16bdf81 <pp_define+0x311>
 16bdf74:	31 c0                	xor    %eax,%eax
 16bdf76:	45 31 d2             	xor    %r10d,%r10d
 16bdf79:	45 31 db             	xor    %r11d,%r11d
 16bdf7c:	e9 0e 05 00 00       	jmp    16be48f <pp_define+0x81f>
 16bdf81:	4c 89 6c 24 28       	mov    %r13,0x28(%rsp)
 16bdf86:	48 83 ff 40          	cmp    $0x40,%rdi
 16bdf8a:	73 10                	jae    16bdf9c <pp_define+0x32c>
 16bdf8c:	45 31 c9             	xor    %r9d,%r9d
 16bdf8f:	31 c0                	xor    %eax,%eax
 16bdf91:	45 31 d2             	xor    %r10d,%r10d
 16bdf94:	45 31 db             	xor    %r11d,%r11d
 16bdf97:	e9 4d 02 00 00       	jmp    16be1e9 <pp_define+0x579>
 16bdf9c:	48 89 7c 24 38       	mov    %rdi,0x38(%rsp)
 16bdfa1:	62 e2 7d 08 78 0d 17 	vpbroadcastb -0x119cfe9(%rip),%xmm17        # 520fc2 <c_first_char_channels+0x8402>
 16bdfa8:	30 e6 fe 
 16bdfab:	62 e2 7d 08 78 3d 0e 	vpbroadcastb -0x119cff2(%rip),%xmm23        # 520fc3 <c_first_char_channels+0x8403>
 16bdfb2:	30 e6 fe 
 16bdfb5:	c4 62 79 78 1d 06 30 	vpbroadcastb -0x119cffa(%rip),%xmm11        # 520fc4 <c_first_char_channels+0x8404>
 16bdfbc:	e6 fe 
 16bdfbe:	62 62 7d 08 78 05 fd 	vpbroadcastb -0x119d003(%rip),%xmm24        # 520fc5 <c_first_char_channels+0x8405>
 16bdfc5:	2f e6 fe 
 16bdfc8:	62 e2 7d 48 58 15 26 	vpbroadcastd -0x10fa8da(%rip),%zmm18        # 5c36f8 <executable_lay_out.first_sections+0x408>
 16bdfcf:	57 f0 fe 
 16bdfd2:	49 89 f9             	mov    %rdi,%r9
 16bdfd5:	49 83 e1 c0          	and    $0xffffffffffffffc0,%r9
 16bdfd9:	c5 d9 ef e4          	vpxor  %xmm4,%xmm4,%xmm4
 16bdfdd:	c4 41 09 ef f6       	vpxor  %xmm14,%xmm14,%xmm14
 16bdfe2:	62 a1 7d 00 ef c0    	vpxord %xmm16,%xmm16,%xmm16
 16bdfe8:	c4 41 01 ef ff       	vpxor  %xmm15,%xmm15,%xmm15
 16bdfed:	c5 c9 ef f6          	vpxor  %xmm6,%xmm6,%xmm6
 16bdff1:	c4 41 39 ef c0       	vpxor  %xmm8,%xmm8,%xmm8
 16bdff6:	c5 c1 ef ff          	vpxor  %xmm7,%xmm7,%xmm7
 16bdffa:	c5 d1 ef ed          	vpxor  %xmm5,%xmm5,%xmm5
 16bdffe:	62 a1 65 00 ef db    	vpxord %xmm19,%xmm19,%xmm19
 16be004:	62 a1 55 00 ef ed    	vpxord %xmm21,%xmm21,%xmm21
 16be00a:	62 a1 5d 00 ef e4    	vpxord %xmm20,%xmm20,%xmm20
 16be010:	62 a1 4d 00 ef f6    	vpxord %xmm22,%xmm22,%xmm22
 16be016:	48 8b 7c 24 18       	mov    0x18(%rsp),%rdi
 16be01b:	4e 8d 5c 2f 30       	lea    0x30(%rdi,%r13,1),%r11
 16be020:	4c 8d 94 be c0 00 00 	lea    0xc0(%rsi,%rdi,4),%r10
 16be027:	00 
 16be028:	49 8d 0c 39          	lea    (%r9,%rdi,1),%rcx
 16be02c:	45 31 ed             	xor    %r13d,%r13d
 16be02f:	90                   	nop
 16be030:	62 11 f5 00 db 4c 2b 	vpandq -0x30(%r11,%r13,1),%xmm17,%xmm9
 16be037:	fd 
 16be038:	62 11 f5 00 db 54 2b 	vpandq -0x20(%r11,%r13,1),%xmm17,%xmm10
 16be03f:	fe 
 16be040:	62 11 f5 00 db 64 2b 	vpandq -0x10(%r11,%r13,1),%xmm17,%xmm12
 16be047:	ff 
 16be048:	62 11 f5 00 db 2c 2b 	vpandq (%r11,%r13,1),%xmm17,%xmm13
 16be04f:	62 b1 fd 08 6f c7    	vmovdqa64 %xmm23,%xmm0
 16be055:	62 d1 35 08 74 cb    	vpcmpeqb %xmm11,%xmm9,%k1
 16be05b:	62 91 6d 41 76 4c aa 	vpcmpeqd -0xc0(%r10,%r13,4),%zmm18,%k1{%k1}
 16be062:	fd 
 16be063:	c5 b1 74 c8          	vpcmpeqb %xmm0,%xmm9,%xmm1
 16be067:	c5 a9 74 d0          	vpcmpeqb %xmm0,%xmm10,%xmm2
 16be06b:	c5 99 74 d8          	vpcmpeqb %xmm0,%xmm12,%xmm3
 16be06f:	c5 91 74 c0          	vpcmpeqb %xmm0,%xmm13,%xmm0
 16be073:	62 d1 2d 08 74 d3    	vpcmpeqb %xmm11,%xmm10,%k2
 16be079:	62 d1 1d 08 74 db    	vpcmpeqb %xmm11,%xmm12,%k3
 16be07f:	62 d1 15 08 74 e3    	vpcmpeqb %xmm11,%xmm13,%k4
 16be085:	62 c3 e5 08 25 e3 f8 	vpternlogq $0xf8,%xmm11,%xmm3,%xmm20
 16be08c:	62 c3 fd 08 25 f3 f8 	vpternlogq $0xf8,%xmm11,%xmm0,%xmm22
 16be093:	62 91 fd 08 6f d8    	vmovdqa64 %xmm24,%xmm3
 16be099:	c5 b1 74 c3          	vpcmpeqb %xmm3,%xmm9,%xmm0
 16be09d:	62 c3 f5 08 25 db f8 	vpternlogq $0xf8,%xmm11,%xmm1,%xmm19
 16be0a4:	62 c3 ed 08 25 eb f8 	vpternlogq $0xf8,%xmm11,%xmm2,%xmm21
 16be0ab:	c5 a9 74 cb          	vpcmpeqb %xmm3,%xmm10,%xmm1
 16be0af:	c5 99 74 d3          	vpcmpeqb %xmm3,%xmm12,%xmm2
 16be0b3:	c5 91 74 db          	vpcmpeqb %xmm3,%xmm13,%xmm3
 16be0b7:	62 d3 fd 08 25 f3 f8 	vpternlogq $0xf8,%xmm11,%xmm0,%xmm6
 16be0be:	c4 c1 09 eb c3       	vpor   %xmm11,%xmm14,%xmm0
 16be0c3:	62 53 f5 08 25 c3 f8 	vpternlogq $0xf8,%xmm11,%xmm1,%xmm8
 16be0ca:	62 d3 ed 08 25 fb f8 	vpternlogq $0xf8,%xmm11,%xmm2,%xmm7
 16be0d1:	62 d3 e5 08 25 eb f8 	vpternlogq $0xf8,%xmm11,%xmm3,%xmm5
 16be0d8:	62 71 7f 09 6f f0    	vmovdqu8 %xmm0,%xmm14{%k1}
 16be0de:	62 91 6d 42 76 4c aa 	vpcmpeqd -0x80(%r10,%r13,4),%zmm18,%k1{%k2}
 16be0e5:	fe 
 16be0e6:	62 d1 fd 00 eb c3    	vporq  %xmm11,%xmm16,%xmm0
 16be0ec:	62 e1 7f 09 6f c0    	vmovdqu8 %xmm0,%xmm16{%k1}
 16be0f2:	62 91 6d 43 76 4c aa 	vpcmpeqd -0x40(%r10,%r13,4),%zmm18,%k1{%k3}
 16be0f9:	ff 
 16be0fa:	c4 c1 01 eb c3       	vpor   %xmm11,%xmm15,%xmm0
 16be0ff:	62 71 7f 09 6f f8    	vmovdqu8 %xmm0,%xmm15{%k1}
 16be105:	62 91 6d 44 76 0c aa 	vpcmpeqd (%r10,%r13,4),%zmm18,%k1{%k4}
 16be10c:	c5 a1 eb c4          	vpor   %xmm4,%xmm11,%xmm0
 16be110:	49 83 c5 40          	add    $0x40,%r13
 16be114:	62 f1 7f 09 6f e0    	vmovdqu8 %xmm0,%xmm4{%k1}
 16be11a:	4d 39 e9             	cmp    %r13,%r9
 16be11d:	0f 85 0d ff ff ff    	jne    16be030 <pp_define+0x3c0>
 16be123:	62 d1 fd 00 eb c6    	vporq  %xmm14,%xmm16,%xmm0
 16be129:	48 8b 7c 24 38       	mov    0x38(%rsp),%rdi
 16be12e:	62 f3 85 08 25 e0 fe 	vpternlogq $0xfe,%xmm0,%xmm15,%xmm4
 16be135:	c5 f9 70 c4 ee       	vpshufd $0xee,%xmm4,%xmm0
 16be13a:	c5 d9 eb c0          	vpor   %xmm0,%xmm4,%xmm0
 16be13e:	c5 f9 70 c8 55       	vpshufd $0x55,%xmm0,%xmm1
 16be143:	c5 f9 eb c1          	vpor   %xmm1,%xmm0,%xmm0
 16be147:	c5 f1 72 d0 10       	vpsrld $0x10,%xmm0,%xmm1
 16be14c:	c5 f9 eb c1          	vpor   %xmm1,%xmm0,%xmm0
 16be150:	c5 f1 71 d0 08       	vpsrlw $0x8,%xmm0,%xmm1
 16be155:	c5 f9 eb c1          	vpor   %xmm1,%xmm0,%xmm0
 16be159:	c5 f9 7e c0          	vmovd  %xmm0,%eax
 16be15d:	c5 b9 eb c6          	vpor   %xmm6,%xmm8,%xmm0
 16be161:	62 f3 c5 08 25 e8 fe 	vpternlogq $0xfe,%xmm0,%xmm7,%xmm5
 16be168:	c5 f9 70 c5 ee       	vpshufd $0xee,%xmm5,%xmm0
 16be16d:	c5 d1 eb c0          	vpor   %xmm0,%xmm5,%xmm0
 16be171:	c5 f9 70 c8 55       	vpshufd $0x55,%xmm0,%xmm1
 16be176:	c5 f9 eb c1          	vpor   %xmm1,%xmm0,%xmm0
 16be17a:	c5 f1 72 d0 10       	vpsrld $0x10,%xmm0,%xmm1
 16be17f:	c5 f9 eb c1          	vpor   %xmm1,%xmm0,%xmm0
 16be183:	c5 f1 71 d0 08       	vpsrlw $0x8,%xmm0,%xmm1
 16be188:	c5 f9 eb c1          	vpor   %xmm1,%xmm0,%xmm0
 16be18c:	c4 c1 79 7e c2       	vmovd  %xmm0,%r10d
 16be191:	62 b1 d5 00 eb c3    	vporq  %xmm19,%xmm21,%xmm0
 16be197:	62 e3 dd 00 25 f0 fe 	vpternlogq $0xfe,%xmm0,%xmm20,%xmm22
 16be19e:	62 b1 7d 08 70 c6 ee 	vpshufd $0xee,%xmm22,%xmm0
 16be1a5:	62 f1 cd 00 eb c0    	vporq  %xmm0,%xmm22,%xmm0
 16be1ab:	c5 f9 70 c8 55       	vpshufd $0x55,%xmm0,%xmm1
 16be1b0:	c5 f9 eb c1          	vpor   %xmm1,%xmm0,%xmm0
 16be1b4:	c5 f1 72 d0 10       	vpsrld $0x10,%xmm0,%xmm1
 16be1b9:	c5 f9 eb c1          	vpor   %xmm1,%xmm0,%xmm0
 16be1bd:	c5 f1 71 d0 08       	vpsrlw $0x8,%xmm0,%xmm1
 16be1c2:	c5 f9 eb c1          	vpor   %xmm1,%xmm0,%xmm0
 16be1c6:	c4 c1 79 7e c3       	vmovd  %xmm0,%r11d
 16be1cb:	4c 39 cf             	cmp    %r9,%rdi
 16be1ce:	75 0a                	jne    16be1da <pp_define+0x56a>
 16be1d0:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
 16be1d5:	e9 34 01 00 00       	jmp    16be30e <pp_define+0x69e>
 16be1da:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
 16be1df:	40 f6 c7 38          	test   $0x38,%dil
 16be1e3:	0f 84 a6 02 00 00    	je     16be48f <pp_define+0x81f>
 16be1e9:	0f b6 e8             	movzbl %al,%ebp
 16be1ec:	41 0f b6 c3          	movzbl %r11b,%eax
 16be1f0:	4c 8b 6c 24 18       	mov    0x18(%rsp),%r13
 16be1f5:	45 0f b6 d2          	movzbl %r10b,%r10d
 16be1f9:	c4 e2 79 78 1d c0 2d 	vpbroadcastb -0x119d240(%rip),%xmm3        # 520fc2 <c_first_char_channels+0x8402>
 16be200:	e6 fe 
 16be202:	c4 e2 79 78 25 b8 2d 	vpbroadcastb -0x119d248(%rip),%xmm4        # 520fc3 <c_first_char_channels+0x8403>
 16be209:	e6 fe 
 16be20b:	c4 e2 79 78 2d b0 2d 	vpbroadcastb -0x119d250(%rip),%xmm5        # 520fc4 <c_first_char_channels+0x8404>
 16be212:	e6 fe 
 16be214:	c4 e2 79 78 35 a8 2d 	vpbroadcastb -0x119d258(%rip),%xmm6        # 520fc5 <c_first_char_channels+0x8405>
 16be21b:	e6 fe 
 16be21d:	c4 e2 7d 58 3d d2 54 	vpbroadcastd -0x10fab2e(%rip),%ymm7        # 5c36f8 <executable_lay_out.first_sections+0x408>
 16be224:	f0 fe 
 16be226:	c4 62 79 78 05 95 2d 	vpbroadcastb -0x119d26b(%rip),%xmm8        # 520fc4 <c_first_char_channels+0x8404>
 16be22d:	e6 fe 
 16be22f:	48 89 fe             	mov    %rdi,%rsi
 16be232:	48 83 e7 f8          	and    $0xfffffffffffffff8,%rdi
 16be236:	c5 f9 6e c0          	vmovd  %eax,%xmm0
 16be23a:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
 16be23f:	c4 c1 79 6e ca       	vmovd  %r10d,%xmm1
 16be244:	c5 f9 6e d5          	vmovd  %ebp,%xmm2
 16be248:	4a 8d 0c 2f          	lea    (%rdi,%r13,1),%rcx
 16be24c:	4e 8d 14 a8          	lea    (%rax,%r13,4),%r10
 16be250:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
 16be255:	4e 8d 1c 28          	lea    (%rax,%r13,1),%r11
 16be259:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
 16be25e:	66 90                	xchg   %ax,%ax
 16be260:	c4 01 7a 7e 0c 0b    	vmovq  (%r11,%r9,1),%xmm9
 16be266:	c5 31 db cb          	vpand  %xmm3,%xmm9,%xmm9
 16be26a:	c5 31 74 d4          	vpcmpeqb %xmm4,%xmm9,%xmm10
 16be26e:	62 f1 35 08 74 cd    	vpcmpeqb %xmm5,%xmm9,%k1
 16be274:	62 f3 ad 08 25 c5 f8 	vpternlogq $0xf8,%xmm5,%xmm10,%xmm0
 16be27b:	c5 31 74 d6          	vpcmpeqb %xmm6,%xmm9,%xmm10
 16be27f:	62 11 7e a9 6f 0c 8a 	vmovdqu32 (%r10,%r9,4),%ymm9{%k1}{z}
 16be286:	49 83 c1 08          	add    $0x8,%r9
 16be28a:	62 f3 ad 08 25 cd f8 	vpternlogq $0xf8,%xmm5,%xmm10,%xmm1
 16be291:	62 f1 35 29 76 cf    	vpcmpeqd %ymm7,%ymm9,%k1{%k1}
 16be297:	c5 39 eb ca          	vpor   %xmm2,%xmm8,%xmm9
 16be29b:	62 d1 7f 09 6f d1    	vmovdqu8 %xmm9,%xmm2{%k1}
 16be2a1:	4c 39 cf             	cmp    %r9,%rdi
 16be2a4:	75 ba                	jne    16be260 <pp_define+0x5f0>
 16be2a6:	c5 f9 70 da 55       	vpshufd $0x55,%xmm2,%xmm3
 16be2ab:	c5 e9 eb d3          	vpor   %xmm3,%xmm2,%xmm2
 16be2af:	c5 e1 72 d2 10       	vpsrld $0x10,%xmm2,%xmm3
 16be2b4:	c5 e9 eb d3          	vpor   %xmm3,%xmm2,%xmm2
 16be2b8:	c5 e1 71 d2 08       	vpsrlw $0x8,%xmm2,%xmm3
 16be2bd:	c5 e9 eb d3          	vpor   %xmm3,%xmm2,%xmm2
 16be2c1:	c5 f9 7e d0          	vmovd  %xmm2,%eax
 16be2c5:	c5 f9 70 d1 55       	vpshufd $0x55,%xmm1,%xmm2
 16be2ca:	c5 f1 eb ca          	vpor   %xmm2,%xmm1,%xmm1
 16be2ce:	c5 e9 72 d1 10       	vpsrld $0x10,%xmm1,%xmm2
 16be2d3:	c5 f1 eb ca          	vpor   %xmm2,%xmm1,%xmm1
 16be2d7:	c5 e9 71 d1 08       	vpsrlw $0x8,%xmm1,%xmm2
 16be2dc:	c5 f1 eb ca          	vpor   %xmm2,%xmm1,%xmm1
 16be2e0:	c4 c1 79 7e ca       	vmovd  %xmm1,%r10d
 16be2e5:	c5 f9 70 c8 55       	vpshufd $0x55,%xmm0,%xmm1
 16be2ea:	c5 f9 eb c1          	vpor   %xmm1,%xmm0,%xmm0
 16be2ee:	c5 f1 72 d0 10       	vpsrld $0x10,%xmm0,%xmm1
 16be2f3:	c5 f9 eb c1          	vpor   %xmm1,%xmm0,%xmm0
 16be2f7:	c5 f1 71 d0 08       	vpsrlw $0x8,%xmm0,%xmm1
 16be2fc:	c5 f9 eb c1          	vpor   %xmm1,%xmm0,%xmm0
 16be300:	c4 c1 79 7e c3       	vmovd  %xmm0,%r11d
 16be305:	48 39 fe             	cmp    %rdi,%rsi
 16be308:	0f 85 81 01 00 00    	jne    16be48f <pp_define+0x81f>
 16be30e:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
 16be313:	89 c1                	mov    %eax,%ecx
 16be315:	44 88 5c 24 67       	mov    %r11b,0x67(%rsp)
 16be31a:	44 88 54 24 66       	mov    %r10b,0x66(%rsp)
 16be31f:	88 4c 24 65          	mov    %cl,0x65(%rsp)
 16be323:	0f b6 44 24 6c       	movzbl 0x6c(%rsp),%eax
 16be328:	41 c0 e3 04          	shl    $0x4,%r11b
 16be32c:	41 08 c3             	or     %al,%r11b
 16be32f:	a8 02                	test   $0x2,%al
 16be331:	88 44 24 38          	mov    %al,0x38(%rsp)
 16be335:	89 4c 24 30          	mov    %ecx,0x30(%rsp)
 16be339:	0f 94 c0             	sete   %al
 16be33c:	44 88 5c 24 6c       	mov    %r11b,0x6c(%rsp)
 16be341:	84 c1                	test   %al,%cl
 16be343:	0f 84 ad 00 00 00    	je     16be3f6 <pp_define+0x786>
 16be349:	41 8d 40 ff          	lea    -0x1(%r8),%eax
 16be34d:	45 89 c5             	mov    %r8d,%r13d
 16be350:	89 44 24 48          	mov    %eax,0x48(%rsp)
 16be354:	48 8b 6c 24 18       	mov    0x18(%rsp),%rbp
 16be359:	4c 89 64 24 58       	mov    %r12,0x58(%rsp)
 16be35e:	eb 38                	jmp    16be398 <pp_define+0x728>
 16be360:	8b 4c 24 48          	mov    0x48(%rsp),%ecx
 16be364:	48 89 df             	mov    %rbx,%rdi
 16be367:	4c 89 fe             	mov    %r15,%rsi
 16be36a:	c5 f8 77             	vzeroupper
 16be36d:	e8 be 1b 00 00       	call   16bff30 <pp_line_end_location>
 16be372:	48 8d 0d 7c 82 02 ff 	lea    -0xfd7d84(%rip),%rcx        # 6e65f5 <pp_string_value.meaning+0x32bac>
 16be379:	89 c2                	mov    %eax,%edx
 16be37b:	48 89 df             	mov    %rbx,%rdi
 16be37e:	31 f6                	xor    %esi,%esi
 16be380:	31 c0                	xor    %eax,%eax
 16be382:	e8 29 8e fb ff       	call   16771b0 <pp_diagnose>
 16be387:	8b 54 24 0c          	mov    0xc(%rsp),%edx
 16be38b:	4c 8b 44 24 10       	mov    0x10(%rsp),%r8
 16be390:	48 ff c5             	inc    %rbp
 16be393:	41 ff ce             	dec    %r14d
 16be396:	74 55                	je     16be3ed <pp_define+0x77d>
 16be398:	49 8b 47 50          	mov    0x50(%r15),%rax
 16be39c:	0f b6 04 28          	movzbl (%rax,%rbp,1),%eax
 16be3a0:	24 7f                	and    $0x7f,%al
 16be3a2:	3c 01                	cmp    $0x1,%al
 16be3a4:	75 ea                	jne    16be390 <pp_define+0x720>
 16be3a6:	49 8b 47 60          	mov    0x60(%r15),%rax
 16be3aa:	81 3c a8 ab 00 00 00 	cmpl   $0xab,(%rax,%rbp,4)
 16be3b1:	75 dd                	jne    16be390 <pp_define+0x720>
 16be3b3:	4c 39 ed             	cmp    %r13,%rbp
 16be3b6:	73 a8                	jae    16be360 <pp_define+0x6f0>
 16be3b8:	49 8b 47 58          	mov    0x58(%r15),%rax
 16be3bc:	49 8b 7f 20          	mov    0x20(%r15),%rdi
 16be3c0:	49 89 dc             	mov    %rbx,%r12
 16be3c3:	8b 34 a8             	mov    (%rax,%rbp,4),%esi
 16be3c6:	0f b6 83 53 02 00 00 	movzbl 0x253(%rbx),%eax
 16be3cd:	4c 89 eb             	mov    %r13,%rbx
 16be3d0:	41 89 d5             	mov    %edx,%r13d
 16be3d3:	89 c2                	mov    %eax,%edx
 16be3d5:	c5 f8 77             	vzeroupper
 16be3d8:	e8 43 35 00 00       	call   16c1920 <pp_start_with_splices>
 16be3dd:	44 01 e8             	add    %r13d,%eax
 16be3e0:	49 89 dd             	mov    %rbx,%r13
 16be3e3:	4c 89 e3             	mov    %r12,%rbx
 16be3e6:	4c 8b 64 24 58       	mov    0x58(%rsp),%r12
 16be3eb:	eb 85                	jmp    16be372 <pp_define+0x702>
 16be3ed:	4d 8b 6f 50          	mov    0x50(%r15),%r13
 16be3f1:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
 16be3f6:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
 16be3fb:	41 0f b6 44 05 00    	movzbl 0x0(%r13,%rax,1),%eax
 16be401:	24 7f                	and    $0x7f,%al
 16be403:	3c 3d                	cmp    $0x3d,%al
 16be405:	8b 44 24 30          	mov    0x30(%rsp),%eax
 16be409:	75 09                	jne    16be414 <pp_define+0x7a4>
 16be40b:	4c 8d 35 de f9 05 ff 	lea    -0xfa0622(%rip),%r14        # 71ddf0 <pp_string_value.meaning+0x6a3a7>
 16be412:	eb 58                	jmp    16be46c <pp_define+0x7fc>
 16be414:	0a 44 24 66          	or     0x66(%rsp),%al
 16be418:	74 37                	je     16be451 <pp_define+0x7e1>
 16be41a:	80 64 24 38 01       	andb   $0x1,0x38(%rsp)
 16be41f:	74 30                	je     16be451 <pp_define+0x7e1>
 16be421:	48 8d 54 24 68       	lea    0x68(%rsp),%rdx
 16be426:	48 8d 8c 24 a8 00 00 	lea    0xa8(%rsp),%rcx
 16be42d:	00 
 16be42e:	48 89 df             	mov    %rbx,%rdi
 16be431:	4c 89 fe             	mov    %r15,%rsi
 16be434:	c5 f8 77             	vzeroupper
 16be437:	e8 d4 23 00 00       	call   16c0810 <pp_check_replacement_list>
 16be43c:	84 c0                	test   %al,%al
 16be43e:	0f 84 6d 02 00 00    	je     16be6b1 <pp_define+0xa41>
 16be444:	4d 8b 6f 50          	mov    0x50(%r15),%r13
 16be448:	8b 54 24 0c          	mov    0xc(%rsp),%edx
 16be44c:	4c 8b 44 24 10       	mov    0x10(%rsp),%r8
 16be451:	4c 8b 64 24 40       	mov    0x40(%rsp),%r12
 16be456:	41 ff cc             	dec    %r12d
 16be459:	43 0f b6 44 25 00    	movzbl 0x0(%r13,%r12,1),%eax
 16be45f:	24 7f                	and    $0x7f,%al
 16be461:	3c 3d                	cmp    $0x3d,%al
 16be463:	75 7f                	jne    16be4e4 <pp_define+0x874>
 16be465:	4c 8d 35 8a 54 ff fe 	lea    -0x100ab76(%rip),%r14        # 6b38f6 <fuzz_comment_end+0x50f9f>
 16be46c:	48 89 df             	mov    %rbx,%rdi
 16be46f:	4c 89 fe             	mov    %r15,%rsi
 16be472:	44 89 e1             	mov    %r12d,%ecx
 16be475:	c5 f8 77             	vzeroupper
 16be478:	e8 d3 21 00 00       	call   16c0650 <pp_define_location>
 16be47d:	48 89 df             	mov    %rbx,%rdi
 16be480:	be 01 00 00 00       	mov    $0x1,%esi
 16be485:	89 c2                	mov    %eax,%edx
 16be487:	4c 89 f1             	mov    %r14,%rcx
 16be48a:	e9 18 02 00 00       	jmp    16be6a7 <pp_define+0xa37>
 16be48f:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
 16be494:	eb 1e                	jmp    16be4b4 <pp_define+0x844>
 16be496:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
 16be49d:	00 00 00 
 16be4a0:	41 08 fb             	or     %dil,%r11b
 16be4a3:	45 08 ca             	or     %r9b,%r10b
 16be4a6:	48 ff c1             	inc    %rcx
 16be4a9:	48 39 4c 24 48       	cmp    %rcx,0x48(%rsp)
 16be4ae:	0f 84 5a fe ff ff    	je     16be30e <pp_define+0x69e>
 16be4b4:	41 0f b6 6c 0d 00    	movzbl 0x0(%r13,%rcx,1),%ebp
 16be4ba:	40 80 e5 7f          	and    $0x7f,%bpl
 16be4be:	40 80 fd 3d          	cmp    $0x3d,%bpl
 16be4c2:	40 0f 94 c7          	sete   %dil
 16be4c6:	40 80 fd 3c          	cmp    $0x3c,%bpl
 16be4ca:	41 0f 94 c1          	sete   %r9b
 16be4ce:	40 80 fd 01          	cmp    $0x1,%bpl
 16be4d2:	75 cc                	jne    16be4a0 <pp_define+0x830>
 16be4d4:	81 3c 8e ab 00 00 00 	cmpl   $0xab,(%rsi,%rcx,4)
 16be4db:	40 0f 94 c5          	sete   %bpl
 16be4df:	40 08 e8             	or     %bpl,%al
 16be4e2:	eb bc                	jmp    16be4a0 <pp_define+0x830>
 16be4e4:	0f b6 83 78 02 00 00 	movzbl 0x278(%rbx),%eax
 16be4eb:	84 c0                	test   %al,%al
 16be4ed:	74 26                	je     16be515 <pp_define+0x8a5>
 16be4ef:	48 8b 83 e0 0d 00 00 	mov    0xde0(%rbx),%rax
 16be4f6:	89 e9                	mov    %ebp,%ecx
 16be4f8:	c1 e9 06             	shr    $0x6,%ecx
 16be4fb:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
 16be4ff:	48 0f a3 e8          	bt     %rbp,%rax
 16be503:	0f 83 2a 01 00 00    	jae    16be633 <pp_define+0x9c3>
 16be509:	48 8b 83 d8 0d 00 00 	mov    0xdd8(%rbx),%rax
 16be510:	8b 04 a8             	mov    (%rax,%rbp,4),%eax
 16be513:	eb 12                	jmp    16be527 <pp_define+0x8b7>
 16be515:	48 8b 83 d8 0d 00 00 	mov    0xdd8(%rbx),%rax
 16be51c:	8b 04 a8             	mov    (%rax,%rbp,4),%eax
 16be51f:	85 c0                	test   %eax,%eax
 16be521:	0f 84 0c 01 00 00    	je     16be633 <pp_define+0x9c3>
 16be527:	4c 8b b3 e8 0d 00 00 	mov    0xde8(%rbx),%r14
 16be52e:	89 c0                	mov    %eax,%eax
 16be530:	49 89 c7             	mov    %rax,%r15
 16be533:	49 c1 e7 06          	shl    $0x6,%r15
 16be537:	43 0f b6 4c 3e 05    	movzbl 0x5(%r14,%r15,1),%ecx
 16be53d:	83 f9 0c             	cmp    $0xc,%ecx
 16be540:	0f 84 ed 00 00 00    	je     16be633 <pp_define+0x9c3>
 16be546:	83 f9 21             	cmp    $0x21,%ecx
 16be549:	0f 84 e4 00 00 00    	je     16be633 <pp_define+0x9c3>
 16be54f:	48 85 c0             	test   %rax,%rax
 16be552:	0f 84 db 00 00 00    	je     16be633 <pp_define+0x9c3>
 16be558:	4d 01 fe             	add    %r15,%r14
 16be55b:	48 89 df             	mov    %rbx,%rdi
 16be55e:	4c 89 f6             	mov    %r14,%rsi
 16be561:	c5 f8 77             	vzeroupper
 16be564:	e8 17 29 00 00       	call   16c0e80 <pp_language_defined>
 16be569:	84 c0                	test   %al,%al
 16be56b:	74 1c                	je     16be589 <pp_define+0x919>
 16be56d:	8b 54 24 24          	mov    0x24(%rsp),%edx
 16be571:	48 8d 0d ab 53 ff fe 	lea    -0x100ac55(%rip),%rcx        # 6b3923 <fuzz_comment_end+0x50fcc>
 16be578:	48 89 df             	mov    %rbx,%rdi
 16be57b:	31 f6                	xor    %esi,%esi
 16be57d:	31 c0                	xor    %eax,%eax
 16be57f:	e8 2c 8c fb ff       	call   16771b0 <pp_diagnose>
 16be584:	e9 aa 00 00 00       	jmp    16be633 <pp_define+0x9c3>
 16be589:	41 f6 46 04 40       	testb  $0x40,0x4(%r14)
 16be58e:	0f 85 9f 00 00 00    	jne    16be633 <pp_define+0x9c3>
 16be594:	48 8d 54 24 68       	lea    0x68(%rsp),%rdx
 16be599:	48 89 df             	mov    %rbx,%rdi
 16be59c:	4c 89 f6             	mov    %r14,%rsi
 16be59f:	e8 ec 29 00 00       	call   16c0f90 <pp_same_definition>
 16be5a4:	84 c0                	test   %al,%al
 16be5a6:	0f 85 87 00 00 00    	jne    16be633 <pp_define+0x9c3>
 16be5ac:	48 8b 83 70 02 00 00 	mov    0x270(%rbx),%rax
 16be5b3:	8b 54 24 24          	mov    0x24(%rsp),%edx
 16be5b7:	48 89 df             	mov    %rbx,%rdi
 16be5ba:	31 f6                	xor    %esi,%esi
 16be5bc:	48 8b 48 10          	mov    0x10(%rax),%rcx
 16be5c0:	44 8b 0c e9          	mov    (%rcx,%rbp,8),%r9d
 16be5c4:	44 8b 44 e9 04       	mov    0x4(%rcx,%rbp,8),%r8d
 16be5c9:	48 8d 0d 4f f8 05 ff 	lea    -0xfa07b1(%rip),%rcx        # 71de1f <pp_string_value.meaning+0x6a3d6>
 16be5d0:	4c 03 48 40          	add    0x40(%rax),%r9
 16be5d4:	31 c0                	xor    %eax,%eax
 16be5d6:	e8 d5 8b fb ff       	call   16771b0 <pp_diagnose>
 16be5db:	80 bb 48 10 00 00 00 	cmpb   $0x0,0x1048(%rbx)
 16be5e2:	75 4f                	jne    16be633 <pp_define+0x9c3>
 16be5e4:	80 bb 55 02 00 00 00 	cmpb   $0x0,0x255(%rbx)
 16be5eb:	75 46                	jne    16be633 <pp_define+0x9c3>
 16be5ed:	4c 8b b3 68 02 00 00 	mov    0x268(%rbx),%r14
 16be5f4:	4d 85 f6             	test   %r14,%r14
 16be5f7:	75 0a                	jne    16be603 <pp_define+0x993>
 16be5f9:	48 8b 05 68 4d d9 00 	mov    0xd94d68(%rip),%rax        # 2453368 <stderr@GLIBC_2.2.5>
 16be600:	4c 8b 30             	mov    (%rax),%r14
 16be603:	48 8b 83 e8 0d 00 00 	mov    0xde8(%rbx),%rax
 16be60a:	48 89 df             	mov    %rbx,%rdi
 16be60d:	4c 89 f6             	mov    %r14,%rsi
 16be610:	42 8b 54 38 24       	mov    0x24(%rax,%r15,1),%edx
 16be615:	e8 c6 94 fb ff       	call   1677ae0 <pp_diagnostic_place>
 16be61a:	48 8d 3d 1b 53 ff fe 	lea    -0x100ace5(%rip),%rdi        # 6b393c <fuzz_comment_end+0x50fe5>
 16be621:	be 22 00 00 00       	mov    $0x22,%esi
 16be626:	ba 01 00 00 00       	mov    $0x1,%edx
 16be62b:	4c 89 f1             	mov    %r14,%rcx
 16be62e:	e8 8d fc 10 ff       	call   7ce2c0 <fwrite@plt>
 16be633:	8b 93 f0 0d 00 00    	mov    0xdf0(%rbx),%edx
 16be639:	48 81 fa 00 00 00 01 	cmp    $0x1000000,%rdx
 16be640:	73 54                	jae    16be696 <pp_define+0xa26>
 16be642:	48 8b 8b e8 0d 00 00 	mov    0xde8(%rbx),%rcx
 16be649:	48 89 d0             	mov    %rdx,%rax
 16be64c:	48 c1 e0 06          	shl    $0x6,%rax
 16be650:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 16be654:	89 2c 01             	mov    %ebp,(%rcx,%rax,1)
 16be657:	c5 fe 7f 44 01 04    	vmovdqu %ymm0,0x4(%rcx,%rax,1)
 16be65d:	c5 fe 7f 44 01 20    	vmovdqu %ymm0,0x20(%rcx,%rax,1)
 16be663:	ff 83 f0 0d 00 00    	incl   0xdf0(%rbx)
 16be669:	48 85 d2             	test   %rdx,%rdx
 16be66c:	74 43                	je     16be6b1 <pp_define+0xa41>
 16be66e:	62 f1 fe 48 6f 84 24 	vmovdqu64 0x68(%rsp),%zmm0
 16be675:	68 00 00 00 
 16be679:	48 8b 8b e8 0d 00 00 	mov    0xde8(%rbx),%rcx
 16be680:	48 89 df             	mov    %rbx,%rdi
 16be683:	89 ee                	mov    %ebp,%esi
 16be685:	62 f1 fe 48 7f 04 01 	vmovdqu64 %zmm0,(%rcx,%rax,1)
 16be68c:	c5 f8 77             	vzeroupper
 16be68f:	e8 5c 9f fb ff       	call   16785f0 <pp_set_macro>
 16be694:	eb 1b                	jmp    16be6b1 <pp_define+0xa41>
 16be696:	48 8d 0d 6d f5 05 ff 	lea    -0xfa0a93(%rip),%rcx        # 71dc0a <pp_string_value.meaning+0x6a1c1>
 16be69d:	be 02 00 00 00       	mov    $0x2,%esi
 16be6a2:	48 89 df             	mov    %rbx,%rdi
 16be6a5:	31 d2                	xor    %edx,%edx
 16be6a7:	31 c0                	xor    %eax,%eax
 16be6a9:	c5 f8 77             	vzeroupper
 16be6ac:	e8 ff 8a fb ff       	call   16771b0 <pp_diagnose>
 16be6b1:	48 8b 84 24 40 01 00 	mov    0x140(%rsp),%rax
 16be6b8:	00 
 16be6b9:	48 85 c0             	test   %rax,%rax
 16be6bc:	74 12                	je     16be6d0 <pp_define+0xa60>
 16be6be:	48 8b 8c 24 48 01 00 	mov    0x148(%rsp),%rcx
 16be6c5:	00 
 16be6c6:	48 3b 48 08          	cmp    0x8(%rax),%rcx
 16be6ca:	77 34                	ja     16be700 <pp_define+0xa90>
 16be6cc:	48 89 48 08          	mov    %rcx,0x8(%rax)
 16be6d0:	64 48 8b 04 25 28 00 	mov    %fs:0x28,%rax
 16be6d7:	00 00 
 16be6d9:	48 3b 84 24 50 01 00 	cmp    0x150(%rsp),%rax
 16be6e0:	00 
 16be6e1:	75 15                	jne    16be6f8 <pp_define+0xa88>
 16be6e3:	48 81 c4 58 01 00 00 	add    $0x158,%rsp
 16be6ea:	5b                   	pop    %rbx
 16be6eb:	41 5c                	pop    %r12
 16be6ed:	41 5d                	pop    %r13
 16be6ef:	41 5e                	pop    %r14
 16be6f1:	41 5f                	pop    %r15
 16be6f3:	5d                   	pop    %rbp
 16be6f4:	c5 f8 77             	vzeroupper
 16be6f7:	c3                   	ret
 16be6f8:	c5 f8 77             	vzeroupper
 16be6fb:	e8 20 f2 10 ff       	call   7cd920 <__stack_chk_fail@plt>
 16be700:	48 8d 3d a2 49 07 ff 	lea    -0xf8b65e(%rip),%rdi        # 7330a9 <pp_string_value.meaning+0x7f660>
 16be707:	48 8d 35 80 41 02 ff 	lea    -0xfdbe80(%rip),%rsi        # 6e288e <pp_string_value.meaning+0x2ee45>
 16be70e:	48 8d 0d 94 41 02 ff 	lea    -0xfdbe6c(%rip),%rcx        # 6e28a9 <pp_string_value.meaning+0x2ee60>
 16be715:	ba ce 00 00 00       	mov    $0xce,%edx
 16be71a:	c5 f8 77             	vzeroupper
 16be71d:	e8 6e f2 10 ff       	call   7cd990 <__assert_fail@plt>
