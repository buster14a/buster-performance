
values/build/compiler:     file format elf64-x86-64


Disassembly of section .plt.got:

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .text:

00000000008c3aa0 <check_lower_drain>:
  8c3aa0:	55                   	push   %rbp
  8c3aa1:	41 57                	push   %r15
  8c3aa3:	41 56                	push   %r14
  8c3aa5:	41 55                	push   %r13
  8c3aa7:	41 54                	push   %r12
  8c3aa9:	53                   	push   %rbx
  8c3aaa:	48 81 ec 38 02 00 00 	sub    $0x238,%rsp
  8c3ab1:	64 48 8b 04 25 28 00 	mov    %fs:0x28,%rax
  8c3ab8:	00 00 
  8c3aba:	48 89 84 24 30 02 00 	mov    %rax,0x230(%rsp)
  8c3ac1:	00 
  8c3ac2:	8b 8f 3c 01 00 00    	mov    0x13c(%rdi),%ecx
  8c3ac8:	85 c9                	test   %ecx,%ecx
  8c3aca:	0f 84 cc 54 00 00    	je     8c8f9c <check_lower_drain+0x54fc>
  8c3ad0:	4c 8d 6f 08          	lea    0x8(%rdi),%r13
  8c3ad4:	48 89 fb             	mov    %rdi,%rbx
  8c3ad7:	e9 ea 00 00 00       	jmp    8c3bc6 <check_lower_drain+0x126>
  8c3adc:	c5 f8 10 43 20       	vmovups 0x20(%rbx),%xmm0
  8c3ae1:	b9 00 00 00 01       	mov    $0x1000000,%ecx
  8c3ae6:	4c 8d b4 24 c0 00 00 	lea    0xc0(%rsp),%r14
  8c3aed:	00 
  8c3aee:	48 8d bc 24 10 02 00 	lea    0x210(%rsp),%rdi
  8c3af5:	00 
  8c3af6:	4c 89 f6             	mov    %r14,%rsi
  8c3af9:	c5 f8 29 84 24 c0 00 	vmovaps %xmm0,0xc0(%rsp)
  8c3b00:	00 00 
  8c3b02:	48 8b 43 30          	mov    0x30(%rbx),%rax
  8c3b06:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  8c3b0d:	00 
  8c3b0e:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c3b14:	89 84 24 d8 00 00 00 	mov    %eax,0xd8(%rsp)
  8c3b1b:	8b 83 40 01 00 00    	mov    0x140(%rbx),%eax
  8c3b21:	3d 00 00 00 01       	cmp    $0x1000000,%eax
  8c3b26:	0f 43 c1             	cmovae %ecx,%eax
  8c3b29:	b9 00 00 01 00       	mov    $0x10000,%ecx
  8c3b2e:	89 84 24 dc 00 00 00 	mov    %eax,0xdc(%rsp)
  8c3b35:	c5 f8 10 83 c0 00 00 	vmovups 0xc0(%rbx),%xmm0
  8c3b3c:	00 
  8c3b3d:	c5 f8 29 84 24 e0 00 	vmovaps %xmm0,0xe0(%rsp)
  8c3b44:	00 00 
  8c3b46:	8b 83 48 01 00 00    	mov    0x148(%rbx),%eax
  8c3b4c:	89 84 24 f0 00 00 00 	mov    %eax,0xf0(%rsp)
  8c3b53:	8b 83 4c 01 00 00    	mov    0x14c(%rbx),%eax
  8c3b59:	3d 00 00 01 00       	cmp    $0x10000,%eax
  8c3b5e:	0f 43 c1             	cmovae %ecx,%eax
  8c3b61:	89 84 24 f4 00 00 00 	mov    %eax,0xf4(%rsp)
  8c3b68:	44 89 e0             	mov    %r12d,%eax
  8c3b6b:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8c3b6f:	0f b6 8b f8 01 00 00 	movzbl 0x1f8(%rbx),%ecx
  8c3b76:	48 8d 14 52          	lea    (%rdx,%rdx,2),%rdx
  8c3b7a:	48 01 c2             	add    %rax,%rdx
  8c3b7d:	48 03 93 20 01 00 00 	add    0x120(%rbx),%rdx
  8c3b84:	83 f1 01             	xor    $0x1,%ecx
  8c3b87:	c5 f8 77             	vzeroupper
  8c3b8a:	e8 a1 89 97 00       	call   123c530 <cbuiltin_lower_append>
  8c3b8f:	48 8b 84 24 20 02 00 	mov    0x220(%rsp),%rax
  8c3b96:	00 
  8c3b97:	48 89 df             	mov    %rbx,%rdi
  8c3b9a:	4c 89 f6             	mov    %r14,%rsi
  8c3b9d:	44 89 fa             	mov    %r15d,%edx
  8c3ba0:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  8c3ba5:	c5 fa 6f 84 24 10 02 	vmovdqu 0x210(%rsp),%xmm0
  8c3bac:	00 00 
  8c3bae:	c5 fa 7f 04 24       	vmovdqu %xmm0,(%rsp)
  8c3bb3:	e8 68 1a 01 00       	call   8d5620 <check_lower_builtin_finish>
  8c3bb8:	8b 8b 3c 01 00 00    	mov    0x13c(%rbx),%ecx
  8c3bbe:	85 c9                	test   %ecx,%ecx
  8c3bc0:	0f 84 d6 53 00 00    	je     8c8f9c <check_lower_drain+0x54fc>
  8c3bc6:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c3bca:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c3bd1:	0f 85 c5 53 00 00    	jne    8c8f9c <check_lower_drain+0x54fc>
  8c3bd7:	48 8b 53 18          	mov    0x18(%rbx),%rdx
  8c3bdb:	ff c9                	dec    %ecx
  8c3bdd:	89 8b 3c 01 00 00    	mov    %ecx,0x13c(%rbx)
  8c3be3:	48 c1 e1 04          	shl    $0x4,%rcx
  8c3be7:	4c 8b 24 0a          	mov    (%rdx,%rcx,1),%r12
  8c3beb:	4c 8b 7c 0a 08       	mov    0x8(%rdx,%rcx,1),%r15
  8c3bf0:	4c 89 e2             	mov    %r12,%rdx
  8c3bf3:	48 c1 ea 20          	shr    $0x20,%rdx
  8c3bf7:	0f b6 ca             	movzbl %dl,%ecx
  8c3bfa:	8d 71 ff             	lea    -0x1(%rcx),%esi
  8c3bfd:	83 fe 05             	cmp    $0x5,%esi
  8c3c00:	0f 87 15 02 00 00    	ja     8c3e1b <check_lower_drain+0x37b>
  8c3c06:	48 8d 15 83 37 be ff 	lea    -0x41c87d(%rip),%rdx        # 4a7390 <cbuiltin_test_generated.edges+0xad00>
  8c3c0d:	48 63 0c b2          	movslq (%rdx,%rsi,4),%rcx
  8c3c11:	48 01 d1             	add    %rdx,%rcx
  8c3c14:	ff e1                	jmp    *%rcx
  8c3c16:	4c 89 e1             	mov    %r12,%rcx
  8c3c19:	48 c1 e9 30          	shr    $0x30,%rcx
  8c3c1d:	80 f9 0f             	cmp    $0xf,%cl
  8c3c20:	0f 82 40 02 00 00    	jb     8c3e66 <check_lower_drain+0x3c6>
  8c3c26:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c3c2d:	75 89                	jne    8c3bb8 <check_lower_drain+0x118>
  8c3c2f:	48 8d 0d 05 59 dc ff 	lea    -0x23a6fb(%rip),%rcx        # 68953b <fuzz_comment_end+0x26c80>
  8c3c36:	48 89 88 00 01 00 00 	mov    %rcx,0x100(%rax)
  8c3c3d:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c3c41:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c3c48:	0f 85 6a ff ff ff    	jne    8c3bb8 <check_lower_drain+0x118>
  8c3c4e:	e9 55 14 00 00       	jmp    8c50a8 <check_lower_drain+0x1608>
  8c3c53:	8b 8b 38 01 00 00    	mov    0x138(%rbx),%ecx
  8c3c59:	48 8b 53 48          	mov    0x48(%rbx),%rdx
  8c3c5d:	44 89 e0             	mov    %r12d,%eax
  8c3c60:	89 0c 82             	mov    %ecx,(%rdx,%rax,4)
  8c3c63:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c3c6a:	0f 85 48 ff ff ff    	jne    8c3bb8 <check_lower_drain+0x118>
  8c3c70:	48 8b 4b 50          	mov    0x50(%rbx),%rcx
  8c3c74:	80 bb 7c 01 00 00 00 	cmpb   $0x0,0x17c(%rbx)
  8c3c7b:	75 14                	jne    8c3c91 <check_lower_drain+0x1f1>
  8c3c7d:	8b 14 81             	mov    (%rcx,%rax,4),%edx
  8c3c80:	be 00 00 00 00       	mov    $0x0,%esi
  8c3c85:	83 fa ff             	cmp    $0xffffffff,%edx
  8c3c88:	0f 44 d6             	cmove  %esi,%edx
  8c3c8b:	89 93 74 01 00 00    	mov    %edx,0x174(%rbx)
  8c3c91:	83 3c 81 ff          	cmpl   $0xffffffff,(%rcx,%rax,4)
  8c3c95:	75 09                	jne    8c3ca0 <check_lower_drain+0x200>
  8c3c97:	8b 93 74 01 00 00    	mov    0x174(%rbx),%edx
  8c3c9d:	89 14 81             	mov    %edx,(%rcx,%rax,4)
  8c3ca0:	c6 83 7c 01 00 00 01 	movb   $0x1,0x17c(%rbx)
  8c3ca7:	e9 0c ff ff ff       	jmp    8c3bb8 <check_lower_drain+0x118>
  8c3cac:	48 89 df             	mov    %rbx,%rdi
  8c3caf:	44 89 e6             	mov    %r12d,%esi
  8c3cb2:	c5 f8 77             	vzeroupper
  8c3cb5:	e8 76 ac ff ff       	call   8be930 <check_lower_control>
  8c3cba:	e9 f9 fe ff ff       	jmp    8c3bb8 <check_lower_drain+0x118>
  8c3cbf:	8b 8b b0 01 00 00    	mov    0x1b0(%rbx),%ecx
  8c3cc5:	44 89 e2             	mov    %r12d,%edx
  8c3cc8:	c1 ea 03             	shr    $0x3,%edx
  8c3ccb:	39 ca                	cmp    %ecx,%edx
  8c3ccd:	73 11                	jae    8c3ce0 <check_lower_drain+0x240>
  8c3ccf:	48 8b bb a0 01 00 00 	mov    0x1a0(%rbx),%rdi
  8c3cd6:	f6 04 17 02          	testb  $0x2,(%rdi,%rdx,1)
  8c3cda:	0f 85 4c 04 00 00    	jne    8c412c <check_lower_drain+0x68c>
  8c3ce0:	44 89 fe             	mov    %r15d,%esi
  8c3ce3:	c1 ee 03             	shr    $0x3,%esi
  8c3ce6:	39 ce                	cmp    %ecx,%esi
  8c3ce8:	73 11                	jae    8c3cfb <check_lower_drain+0x25b>
  8c3cea:	48 8b bb a0 01 00 00 	mov    0x1a0(%rbx),%rdi
  8c3cf1:	f6 04 37 02          	testb  $0x2,(%rdi,%rsi,1)
  8c3cf5:	0f 85 37 04 00 00    	jne    8c4132 <check_lower_drain+0x692>
  8c3cfb:	41 b6 ff             	mov    $0xff,%r14b
  8c3cfe:	40 b5 ff             	mov    $0xff,%bpl
  8c3d01:	39 ca                	cmp    %ecx,%edx
  8c3d03:	73 1b                	jae    8c3d20 <check_lower_drain+0x280>
  8c3d05:	48 8b b3 a0 01 00 00 	mov    0x1a0(%rbx),%rsi
  8c3d0c:	40 b5 08             	mov    $0x8,%bpl
  8c3d0f:	f6 04 16 01          	testb  $0x1,(%rsi,%rdx,1)
  8c3d13:	75 0b                	jne    8c3d20 <check_lower_drain+0x280>
  8c3d15:	48 8b b3 98 01 00 00 	mov    0x198(%rbx),%rsi
  8c3d1c:	0f b6 2c 16          	movzbl (%rsi,%rdx,1),%ebp
  8c3d20:	44 89 fe             	mov    %r15d,%esi
  8c3d23:	c1 ee 03             	shr    $0x3,%esi
  8c3d26:	39 ce                	cmp    %ecx,%esi
  8c3d28:	73 1c                	jae    8c3d46 <check_lower_drain+0x2a6>
  8c3d2a:	48 8b bb a0 01 00 00 	mov    0x1a0(%rbx),%rdi
  8c3d31:	41 b6 08             	mov    $0x8,%r14b
  8c3d34:	f6 04 37 01          	testb  $0x1,(%rdi,%rsi,1)
  8c3d38:	75 0c                	jne    8c3d46 <check_lower_drain+0x2a6>
  8c3d3a:	48 8b bb 98 01 00 00 	mov    0x198(%rbx),%rdi
  8c3d41:	44 0f b6 34 37       	movzbl (%rdi,%rsi,1),%r14d
  8c3d46:	39 ca                	cmp    %ecx,%edx
  8c3d48:	0f 83 3a 02 00 00    	jae    8c3f88 <check_lower_drain+0x4e8>
  8c3d4e:	48 8b bb a0 01 00 00 	mov    0x1a0(%rbx),%rdi
  8c3d55:	0f b6 3c 17          	movzbl (%rdi,%rdx,1),%edi
  8c3d59:	39 ce                	cmp    %ecx,%esi
  8c3d5b:	0f 82 2d 02 00 00    	jb     8c3f8e <check_lower_drain+0x4ee>
  8c3d61:	e9 33 02 00 00       	jmp    8c3f99 <check_lower_drain+0x4f9>
  8c3d66:	c5 f8 10 43 20       	vmovups 0x20(%rbx),%xmm0
  8c3d6b:	b9 00 00 00 01       	mov    $0x1000000,%ecx
  8c3d70:	4c 8d b4 24 c0 00 00 	lea    0xc0(%rsp),%r14
  8c3d77:	00 
  8c3d78:	48 8d bc 24 10 02 00 	lea    0x210(%rsp),%rdi
  8c3d7f:	00 
  8c3d80:	4c 89 f6             	mov    %r14,%rsi
  8c3d83:	c5 f8 29 84 24 c0 00 	vmovaps %xmm0,0xc0(%rsp)
  8c3d8a:	00 00 
  8c3d8c:	48 8b 43 30          	mov    0x30(%rbx),%rax
  8c3d90:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  8c3d97:	00 
  8c3d98:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c3d9e:	89 84 24 d8 00 00 00 	mov    %eax,0xd8(%rsp)
  8c3da5:	8b 83 40 01 00 00    	mov    0x140(%rbx),%eax
  8c3dab:	3d 00 00 00 01       	cmp    $0x1000000,%eax
  8c3db0:	0f 43 c1             	cmovae %ecx,%eax
  8c3db3:	b9 00 00 01 00       	mov    $0x10000,%ecx
  8c3db8:	89 84 24 dc 00 00 00 	mov    %eax,0xdc(%rsp)
  8c3dbf:	c5 f8 10 83 c0 00 00 	vmovups 0xc0(%rbx),%xmm0
  8c3dc6:	00 
  8c3dc7:	c5 f8 29 84 24 e0 00 	vmovaps %xmm0,0xe0(%rsp)
  8c3dce:	00 00 
  8c3dd0:	8b 83 48 01 00 00    	mov    0x148(%rbx),%eax
  8c3dd6:	89 84 24 f0 00 00 00 	mov    %eax,0xf0(%rsp)
  8c3ddd:	8b 83 4c 01 00 00    	mov    0x14c(%rbx),%eax
  8c3de3:	3d 00 00 01 00       	cmp    $0x10000,%eax
  8c3de8:	0f 43 c1             	cmovae %ecx,%eax
  8c3deb:	89 84 24 f4 00 00 00 	mov    %eax,0xf4(%rsp)
  8c3df2:	44 89 e0             	mov    %r12d,%eax
  8c3df5:	48 8d 14 80          	lea    (%rax,%rax,4),%rdx
  8c3df9:	0f b6 8b f8 01 00 00 	movzbl 0x1f8(%rbx),%ecx
  8c3e00:	48 c1 e2 02          	shl    $0x2,%rdx
  8c3e04:	48 03 93 28 01 00 00 	add    0x128(%rbx),%rdx
  8c3e0b:	83 f1 01             	xor    $0x1,%ecx
  8c3e0e:	c5 f8 77             	vzeroupper
  8c3e11:	e8 7a 05 98 00       	call   1244390 <cbuiltin_misc_append>
  8c3e16:	e9 74 fd ff ff       	jmp    8c3b8f <check_lower_drain+0xef>
  8c3e1b:	8d 71 f9             	lea    -0x7(%rcx),%esi
  8c3e1e:	83 fe 01             	cmp    $0x1,%esi
  8c3e21:	0f 87 84 00 00 00    	ja     8c3eab <check_lower_drain+0x40b>
  8c3e27:	44 89 e2             	mov    %r12d,%edx
  8c3e2a:	48 c1 e2 05          	shl    $0x5,%rdx
  8c3e2e:	48 03 93 30 01 00 00 	add    0x130(%rbx),%rdx
  8c3e35:	83 f9 08             	cmp    $0x8,%ecx
  8c3e38:	0f 85 a7 00 00 00    	jne    8c3ee5 <check_lower_drain+0x445>
  8c3e3e:	8b 02                	mov    (%rdx),%eax
  8c3e40:	b9 b3 fe ff ff       	mov    $0xfffffeb3,%ecx
  8c3e45:	01 c8                	add    %ecx,%eax
  8c3e47:	83 f8 01             	cmp    $0x1,%eax
  8c3e4a:	0f 87 95 00 00 00    	ja     8c3ee5 <check_lower_drain+0x445>
  8c3e50:	48 89 df             	mov    %rbx,%rdi
  8c3e53:	44 89 e6             	mov    %r12d,%esi
  8c3e56:	44 89 fa             	mov    %r15d,%edx
  8c3e59:	c5 f8 77             	vzeroupper
  8c3e5c:	e8 6f 20 01 00       	call   8d5ed0 <check_lower_floating_strict>
  8c3e61:	e9 52 fd ff ff       	jmp    8c3bb8 <check_lower_drain+0x118>
  8c3e66:	8b 93 38 01 00 00    	mov    0x138(%rbx),%edx
  8c3e6c:	81 fa ff ff ff 00    	cmp    $0xffffff,%edx
  8c3e72:	0f 87 e8 14 00 00    	ja     8c5360 <check_lower_drain+0x18c0>
  8c3e78:	3b 93 40 01 00 00    	cmp    0x140(%rbx),%edx
  8c3e7e:	0f 83 dc 14 00 00    	jae    8c5360 <check_lower_drain+0x18c0>
  8c3e84:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c3e8b:	0f 85 d4 02 00 00    	jne    8c4165 <check_lower_drain+0x6c5>
  8c3e91:	41 0f b6 f4          	movzbl %r12b,%esi
  8c3e95:	0f b6 d1             	movzbl %cl,%edx
  8c3e98:	48 89 df             	mov    %rbx,%rdi
  8c3e9b:	4c 89 f9             	mov    %r15,%rcx
  8c3e9e:	c5 f8 77             	vzeroupper
  8c3ea1:	e8 ba d4 01 00       	call   8e1360 <check_lower_emit_tracked>
  8c3ea6:	e9 0d fd ff ff       	jmp    8c3bb8 <check_lower_drain+0x118>
  8c3eab:	0f b6 d2             	movzbl %dl,%edx
  8c3eae:	83 c2 f7             	add    $0xfffffff7,%edx
  8c3eb1:	83 fa 0a             	cmp    $0xa,%edx
  8c3eb4:	0f 87 45 09 00 00    	ja     8c47ff <check_lower_drain+0xd5f>
  8c3eba:	48 8d 35 e7 34 be ff 	lea    -0x41cb19(%rip),%rsi        # 4a73a8 <cbuiltin_test_generated.edges+0xad18>
  8c3ec1:	48 63 0c 96          	movslq (%rsi,%rdx,4),%rcx
  8c3ec5:	48 01 f1             	add    %rsi,%rcx
  8c3ec8:	ff e1                	jmp    *%rcx
  8c3eca:	48 8b 03             	mov    (%rbx),%rax
  8c3ecd:	44 89 e1             	mov    %r12d,%ecx
  8c3ed0:	48 8d 34 49          	lea    (%rcx,%rcx,2),%rsi
  8c3ed4:	48 c1 e6 05          	shl    $0x5,%rsi
  8c3ed8:	48 8b 40 08          	mov    0x8(%rax),%rax
  8c3edc:	48 03 70 08          	add    0x8(%rax),%rsi
  8c3ee0:	e9 74 05 00 00       	jmp    8c4459 <check_lower_drain+0x9b9>
  8c3ee5:	c5 f8 10 43 20       	vmovups 0x20(%rbx),%xmm0
  8c3eea:	b9 00 00 00 01       	mov    $0x1000000,%ecx
  8c3eef:	4c 8d b4 24 c0 00 00 	lea    0xc0(%rsp),%r14
  8c3ef6:	00 
  8c3ef7:	48 8d bc 24 10 02 00 	lea    0x210(%rsp),%rdi
  8c3efe:	00 
  8c3eff:	4c 89 f6             	mov    %r14,%rsi
  8c3f02:	c5 f8 29 84 24 c0 00 	vmovaps %xmm0,0xc0(%rsp)
  8c3f09:	00 00 
  8c3f0b:	48 8b 43 30          	mov    0x30(%rbx),%rax
  8c3f0f:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  8c3f16:	00 
  8c3f17:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c3f1d:	89 84 24 d8 00 00 00 	mov    %eax,0xd8(%rsp)
  8c3f24:	8b 83 40 01 00 00    	mov    0x140(%rbx),%eax
  8c3f2a:	3d 00 00 00 01       	cmp    $0x1000000,%eax
  8c3f2f:	0f 43 c1             	cmovae %ecx,%eax
  8c3f32:	b9 00 00 01 00       	mov    $0x10000,%ecx
  8c3f37:	89 84 24 dc 00 00 00 	mov    %eax,0xdc(%rsp)
  8c3f3e:	c5 f8 10 83 c0 00 00 	vmovups 0xc0(%rbx),%xmm0
  8c3f45:	00 
  8c3f46:	c5 f8 29 84 24 e0 00 	vmovaps %xmm0,0xe0(%rsp)
  8c3f4d:	00 00 
  8c3f4f:	8b 83 48 01 00 00    	mov    0x148(%rbx),%eax
  8c3f55:	89 84 24 f0 00 00 00 	mov    %eax,0xf0(%rsp)
  8c3f5c:	8b 83 4c 01 00 00    	mov    0x14c(%rbx),%eax
  8c3f62:	3d 00 00 01 00       	cmp    $0x10000,%eax
  8c3f67:	0f 43 c1             	cmovae %ecx,%eax
  8c3f6a:	89 84 24 f4 00 00 00 	mov    %eax,0xf4(%rsp)
  8c3f71:	0f b6 8b f8 01 00 00 	movzbl 0x1f8(%rbx),%ecx
  8c3f78:	83 f1 01             	xor    $0x1,%ecx
  8c3f7b:	c5 f8 77             	vzeroupper
  8c3f7e:	e8 5d 19 98 00       	call   12458e0 <cbuiltin_float_lower_append>
  8c3f83:	e9 07 fc ff ff       	jmp    8c3b8f <check_lower_drain+0xef>
  8c3f88:	31 ff                	xor    %edi,%edi
  8c3f8a:	39 ce                	cmp    %ecx,%esi
  8c3f8c:	73 0b                	jae    8c3f99 <check_lower_drain+0x4f9>
  8c3f8e:	48 8b 93 a0 01 00 00 	mov    0x1a0(%rbx),%rdx
  8c3f95:	40 32 3c 32          	xor    (%rdx,%rsi,1),%dil
  8c3f99:	48 8b 13             	mov    (%rbx),%rdx
  8c3f9c:	45 84 f6             	test   %r14b,%r14b
  8c3f9f:	41 0f 95 c1          	setne  %r9b
  8c3fa3:	41 20 f9             	and    %dil,%r9b
  8c3fa6:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8c3faa:	40 80 fd 0e          	cmp    $0xe,%bpl
  8c3fae:	0f 87 a6 00 00 00    	ja     8c405a <check_lower_drain+0x5ba>
  8c3fb4:	41 80 fe 0e          	cmp    $0xe,%r14b
  8c3fb8:	0f 87 9c 00 00 00    	ja     8c405a <check_lower_drain+0x5ba>
  8c3fbe:	45 84 c9             	test   %r9b,%r9b
  8c3fc1:	0f 85 93 00 00 00    	jne    8c405a <check_lower_drain+0x5ba>
  8c3fc7:	45 84 f6             	test   %r14b,%r14b
  8c3fca:	0f 84 c7 01 00 00    	je     8c4197 <check_lower_drain+0x6f7>
  8c3fd0:	39 ce                	cmp    %ecx,%esi
  8c3fd2:	73 11                	jae    8c3fe5 <check_lower_drain+0x545>
  8c3fd4:	48 8b 8b a0 01 00 00 	mov    0x1a0(%rbx),%rcx
  8c3fdb:	f6 04 31 10          	testb  $0x10,(%rcx,%rsi,1)
  8c3fdf:	0f 85 75 02 00 00    	jne    8c425a <check_lower_drain+0x7ba>
  8c3fe5:	89 e9                	mov    %ebp,%ecx
  8c3fe7:	80 e1 0e             	and    $0xe,%cl
  8c3fea:	80 f9 0c             	cmp    $0xc,%cl
  8c3fed:	0f 85 ea 01 00 00    	jne    8c41dd <check_lower_drain+0x73d>
  8c3ff3:	41 8d 4e f7          	lea    -0x9(%r14),%ecx
  8c3ff7:	80 f9 02             	cmp    $0x2,%cl
  8c3ffa:	0f 87 dd 01 00 00    	ja     8c41dd <check_lower_drain+0x73d>
  8c4000:	31 c0                	xor    %eax,%eax
  8c4002:	40 80 fd 0c          	cmp    $0xc,%bpl
  8c4006:	44 0f b6 ed          	movzbl %bpl,%r13d
  8c400a:	48 89 df             	mov    %rbx,%rdi
  8c400d:	0f 95 c0             	setne  %al
  8c4010:	44 89 ee             	mov    %r13d,%esi
  8c4013:	8d 04 c5 70 00 00 00 	lea    0x70(,%rax,8),%eax
  8c401a:	89 84 24 c0 00 00 00 	mov    %eax,0xc0(%rsp)
  8c4021:	c5 f8 77             	vzeroupper
  8c4024:	e8 c7 a5 ff ff       	call   8be5f0 <check_lower_temporary>
  8c4029:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c402d:	41 89 c7             	mov    %eax,%r15d
  8c4030:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c4037:	0f 84 3b 08 00 00    	je     8c4878 <check_lower_drain+0xdd8>
  8c403d:	45 31 e4             	xor    %r12d,%r12d
  8c4040:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c4046:	45 89 ff             	mov    %r15d,%r15d
  8c4049:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c404f:	0f 86 8a 08 00 00    	jbe    8c48df <check_lower_drain+0xe3f>
  8c4055:	e9 b6 08 00 00       	jmp    8c4910 <check_lower_drain+0xe70>
  8c405a:	4c 8d 05 16 7b d2 ff 	lea    -0x2d84ea(%rip),%r8        # 5ebb77 <parse_test_openers+0x1f9e2>
  8c4061:	45 84 c9             	test   %r9b,%r9b
  8c4064:	0f 85 19 10 00 00    	jne    8c5083 <check_lower_drain+0x15e3>
  8c406a:	48 8b 0a             	mov    (%rdx),%rcx
  8c406d:	40 80 fd 0f          	cmp    $0xf,%bpl
  8c4071:	45 0f 43 fc          	cmovae %r12d,%r15d
  8c4075:	44 89 ff             	mov    %r15d,%edi
  8c4078:	c1 ef 03             	shr    $0x3,%edi
  8c407b:	0f b6 34 39          	movzbl (%rcx,%rdi,1),%esi
  8c407f:	40 80 fe 0f          	cmp    $0xf,%sil
  8c4083:	75 12                	jne    8c4097 <check_lower_drain+0x5f7>
  8c4085:	48 8b 72 20          	mov    0x20(%rdx),%rsi
  8c4089:	44 8b 3c be          	mov    (%rsi,%rdi,4),%r15d
  8c408d:	44 89 ff             	mov    %r15d,%edi
  8c4090:	c1 ef 03             	shr    $0x3,%edi
  8c4093:	0f b6 34 39          	movzbl (%rcx,%rdi,1),%esi
  8c4097:	4c 8d 05 b2 09 d4 ff 	lea    -0x2bf64e(%rip),%r8        # 604a50 <parse_test_openers+0x388bb>
  8c409e:	40 80 fe 03          	cmp    $0x3,%sil
  8c40a2:	0f 84 db 0f 00 00    	je     8c5083 <check_lower_drain+0x15e3>
  8c40a8:	41 83 e7 f8          	and    $0xfffffff8,%r15d
  8c40ac:	4c 8d 05 9d 09 d4 ff 	lea    -0x2bf663(%rip),%r8        # 604a50 <parse_test_openers+0x388bb>
  8c40b3:	41 81 ff 88 00 00 00 	cmp    $0x88,%r15d
  8c40ba:	0f 84 c3 0f 00 00    	je     8c5083 <check_lower_drain+0x15e3>
  8c40c0:	4c 8d 05 89 09 d4 ff 	lea    -0x2bf677(%rip),%r8        # 604a50 <parse_test_openers+0x388bb>
  8c40c7:	41 81 ff b0 00 00 00 	cmp    $0xb0,%r15d
  8c40ce:	0f 84 af 0f 00 00    	je     8c5083 <check_lower_drain+0x15e3>
  8c40d4:	4c 8d 05 64 15 e9 ff 	lea    -0x16ea9c(%rip),%r8        # 75563f <pp_decode_file_name.meaning+0x1e6d5>
  8c40db:	40 80 fe 05          	cmp    $0x5,%sil
  8c40df:	0f 84 9e 0f 00 00    	je     8c5083 <check_lower_drain+0x15e3>
  8c40e5:	44 0f b6 c6          	movzbl %sil,%r8d
  8c40e9:	41 83 f8 06          	cmp    $0x6,%r8d
  8c40ed:	0f 85 62 0f 00 00    	jne    8c5055 <check_lower_drain+0x15b5>
  8c40f3:	48 8b 52 20          	mov    0x20(%rdx),%rdx
  8c40f7:	8b 34 ba             	mov    (%rdx,%rdi,4),%esi
  8c40fa:	c1 ee 03             	shr    $0x3,%esi
  8c40fd:	0f b6 3c 31          	movzbl (%rcx,%rsi,1),%edi
  8c4101:	40 80 ff 0f          	cmp    $0xf,%dil
  8c4105:	75 0a                	jne    8c4111 <check_lower_drain+0x671>
  8c4107:	8b 14 b2             	mov    (%rdx,%rsi,4),%edx
  8c410a:	c1 ea 03             	shr    $0x3,%edx
  8c410d:	0f b6 3c 11          	movzbl (%rcx,%rdx,1),%edi
  8c4111:	40 80 ff 02          	cmp    $0x2,%dil
  8c4115:	4c 8d 05 ec 79 d2 ff 	lea    -0x2d8614(%rip),%r8        # 5ebb08 <parse_test_openers+0x1f973>
  8c411c:	48 8d 0d 1f ec d0 ff 	lea    -0x2f13e1(%rip),%rcx        # 5d2d42 <parse_test_openers+0x6bad>
  8c4123:	4c 0f 44 c1          	cmove  %rcx,%r8
  8c4127:	e9 57 0f 00 00       	jmp    8c5083 <check_lower_drain+0x15e3>
  8c412c:	44 89 fe             	mov    %r15d,%esi
  8c412f:	c1 ee 03             	shr    $0x3,%esi
  8c4132:	39 ce                	cmp    %ecx,%esi
  8c4134:	73 19                	jae    8c414f <check_lower_drain+0x6af>
  8c4136:	89 f6                	mov    %esi,%esi
  8c4138:	f6 04 37 01          	testb  $0x1,(%rdi,%rsi,1)
  8c413c:	75 11                	jne    8c414f <check_lower_drain+0x6af>
  8c413e:	48 8b bb 98 01 00 00 	mov    0x198(%rbx),%rdi
  8c4145:	80 3c 37 00          	cmpb   $0x0,(%rdi,%rsi,1)
  8c4149:	0f 84 ac fb ff ff    	je     8c3cfb <check_lower_drain+0x25b>
  8c414f:	48 89 df             	mov    %rbx,%rdi
  8c4152:	44 89 e6             	mov    %r12d,%esi
  8c4155:	44 89 fa             	mov    %r15d,%edx
  8c4158:	c5 f8 77             	vzeroupper
  8c415b:	e8 60 e4 00 00       	call   8d25c0 <check_lower_complex_conversion>
  8c4160:	e9 53 fa ff ff       	jmp    8c3bb8 <check_lower_drain+0x118>
  8c4165:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c416c:	0f 85 46 fa ff ff    	jne    8c3bb8 <check_lower_drain+0x118>
  8c4172:	48 8b 43 20          	mov    0x20(%rbx),%rax
  8c4176:	44 88 24 10          	mov    %r12b,(%rax,%rdx,1)
  8c417a:	48 8b 43 28          	mov    0x28(%rbx),%rax
  8c417e:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  8c4181:	8d 4a 01             	lea    0x1(%rdx),%ecx
  8c4184:	48 8b 43 30          	mov    0x30(%rbx),%rax
  8c4188:	4c 89 3c d0          	mov    %r15,(%rax,%rdx,8)
  8c418c:	89 8b 38 01 00 00    	mov    %ecx,0x138(%rbx)
  8c4192:	e9 21 fa ff ff       	jmp    8c3bb8 <check_lower_drain+0x118>
  8c4197:	40 84 ed             	test   %bpl,%bpl
  8c419a:	0f 84 18 fa ff ff    	je     8c3bb8 <check_lower_drain+0x118>
  8c41a0:	8b 8b 38 01 00 00    	mov    0x138(%rbx),%ecx
  8c41a6:	48 81 f9 ff ff ff 00 	cmp    $0xffffff,%rcx
  8c41ad:	0f 87 ad 11 00 00    	ja     8c5360 <check_lower_drain+0x18c0>
  8c41b3:	3b 8b 40 01 00 00    	cmp    0x140(%rbx),%ecx
  8c41b9:	0f 83 a1 11 00 00    	jae    8c5360 <check_lower_drain+0x18c0>
  8c41bf:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c41c6:	0f 85 90 09 00 00    	jne    8c4b5c <check_lower_drain+0x10bc>
  8c41cc:	40 0f b6 d5          	movzbl %bpl,%edx
  8c41d0:	be 23 00 00 00       	mov    $0x23,%esi
  8c41d5:	48 89 df             	mov    %rbx,%rdi
  8c41d8:	e9 70 11 00 00       	jmp    8c534d <check_lower_drain+0x18ad>
  8c41dd:	44 89 f1             	mov    %r14d,%ecx
  8c41e0:	80 e1 0e             	and    $0xe,%cl
  8c41e3:	80 f9 0c             	cmp    $0xc,%cl
  8c41e6:	0f 85 46 06 00 00    	jne    8c4832 <check_lower_drain+0xd92>
  8c41ec:	8d 4d f7             	lea    -0x9(%rbp),%ecx
  8c41ef:	80 f9 02             	cmp    $0x2,%cl
  8c41f2:	0f 87 3a 06 00 00    	ja     8c4832 <check_lower_drain+0xd92>
  8c41f8:	31 c0                	xor    %eax,%eax
  8c41fa:	40 80 fd 0a          	cmp    $0xa,%bpl
  8c41fe:	b9 98 00 00 00       	mov    $0x98,%ecx
  8c4203:	45 0f b6 e6          	movzbl %r14b,%r12d
  8c4207:	48 89 df             	mov    %rbx,%rdi
  8c420a:	0f 95 c0             	setne  %al
  8c420d:	40 80 fd 09          	cmp    $0x9,%bpl
  8c4211:	44 89 e6             	mov    %r12d,%esi
  8c4214:	8d 04 c5 a0 00 00 00 	lea    0xa0(,%rax,8),%eax
  8c421b:	0f 44 c1             	cmove  %ecx,%eax
  8c421e:	89 84 24 c0 00 00 00 	mov    %eax,0xc0(%rsp)
  8c4225:	c5 f8 77             	vzeroupper
  8c4228:	e8 c3 a3 ff ff       	call   8be5f0 <check_lower_temporary>
  8c422d:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c4231:	41 89 c7             	mov    %eax,%r15d
  8c4234:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c423b:	0f 84 c5 0a 00 00    	je     8c4d06 <check_lower_drain+0x1266>
  8c4241:	31 c9                	xor    %ecx,%ecx
  8c4243:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c4249:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c424f:	0f 86 08 0b 00 00    	jbe    8c4d5d <check_lower_drain+0x12bd>
  8c4255:	e9 2c 0b 00 00       	jmp    8c4d86 <check_lower_drain+0x12e6>
  8c425a:	8d 4d ff             	lea    -0x1(%rbp),%ecx
  8c425d:	80 f9 03             	cmp    $0x3,%cl
  8c4260:	0f 87 98 0f 00 00    	ja     8c51fe <check_lower_drain+0x175e>
  8c4266:	8b 8b 38 01 00 00    	mov    0x138(%rbx),%ecx
  8c426c:	48 81 f9 ff ff ff 00 	cmp    $0xffffff,%rcx
  8c4273:	0f 87 78 0b 00 00    	ja     8c4df1 <check_lower_drain+0x1351>
  8c4279:	3b 8b 40 01 00 00    	cmp    0x140(%rbx),%ecx
  8c427f:	0f 83 6c 0b 00 00    	jae    8c4df1 <check_lower_drain+0x1351>
  8c4285:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c428c:	0f 85 3c 0f 00 00    	jne    8c51ce <check_lower_drain+0x172e>
  8c4292:	be 09 00 00 00       	mov    $0x9,%esi
  8c4297:	ba 05 00 00 00       	mov    $0x5,%edx
  8c429c:	48 89 df             	mov    %rbx,%rdi
  8c429f:	31 c9                	xor    %ecx,%ecx
  8c42a1:	c5 f8 77             	vzeroupper
  8c42a4:	e8 b7 d0 01 00       	call   8e1360 <check_lower_emit_tracked>
  8c42a9:	40 b5 05             	mov    $0x5,%bpl
  8c42ac:	e9 4d 0f 00 00       	jmp    8c51fe <check_lower_drain+0x175e>
  8c42b1:	4d 85 ff             	test   %r15,%r15
  8c42b4:	0f 84 04 0a 00 00    	je     8c4cbe <check_lower_drain+0x121e>
  8c42ba:	48 b9 00 00 00 00 00 	movabs $0x10000000000,%rcx
  8c42c1:	01 00 00 
  8c42c4:	49 85 cc             	test   %rcx,%r12
  8c42c7:	0f 95 c1             	setne  %cl
  8c42ca:	49 81 ff 01 01 00 00 	cmp    $0x101,%r15
  8c42d1:	0f 93 c2             	setae  %dl
  8c42d4:	08 ca                	or     %cl,%dl
  8c42d6:	0f 84 da 0a 00 00    	je     8c4db6 <check_lower_drain+0x1316>
  8c42dc:	44 8b b3 48 01 00 00 	mov    0x148(%rbx),%r14d
  8c42e3:	49 81 fe ff ff 00 00 	cmp    $0xffff,%r14
  8c42ea:	0f 87 26 0e 00 00    	ja     8c5116 <check_lower_drain+0x1676>
  8c42f0:	44 3b b3 4c 01 00 00 	cmp    0x14c(%rbx),%r14d
  8c42f7:	0f 83 19 0e 00 00    	jae    8c5116 <check_lower_drain+0x1676>
  8c42fd:	48 8b 83 c0 00 00 00 	mov    0xc0(%rbx),%rax
  8c4304:	42 c6 04 30 08       	movb   $0x8,(%rax,%r14,1)
  8c4309:	48 8b 83 c8 00 00 00 	mov    0xc8(%rbx),%rax
  8c4310:	42 c6 04 30 00       	movb   $0x0,(%rax,%r14,1)
  8c4315:	48 8b 83 d8 00 00 00 	mov    0xd8(%rbx),%rax
  8c431c:	42 c7 04 b0 00 00 00 	movl   $0x0,(%rax,%r14,4)
  8c4323:	00 
  8c4324:	48 8b 83 e0 00 00 00 	mov    0xe0(%rbx),%rax
  8c432b:	42 c6 04 30 00       	movb   $0x0,(%rax,%r14,1)
  8c4330:	48 8b 83 b0 00 00 00 	mov    0xb0(%rbx),%rax
  8c4337:	42 c6 04 30 00       	movb   $0x0,(%rax,%r14,1)
  8c433c:	ff 83 48 01 00 00    	incl   0x148(%rbx)
  8c4342:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c4346:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c434d:	0f 85 e1 0d 00 00    	jne    8c5134 <check_lower_drain+0x1694>
  8c4353:	48 8b 83 d0 00 00 00 	mov    0xd0(%rbx),%rax
  8c435a:	42 c6 04 30 08       	movb   $0x8,(%rax,%r14,1)
  8c435f:	bd ff ff ff ff       	mov    $0xffffffff,%ebp
  8c4364:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8c436b:	01 00 00 
  8c436e:	49 85 c4             	test   %rax,%r12
  8c4371:	0f 85 d5 0d 00 00    	jne    8c514c <check_lower_drain+0x16ac>
  8c4377:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c437d:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c4383:	0f 86 e3 0d 00 00    	jbe    8c516c <check_lower_drain+0x16cc>
  8c4389:	e9 10 0e 00 00       	jmp    8c519e <check_lower_drain+0x16fe>
  8c438e:	c5 f8 10 43 20       	vmovups 0x20(%rbx),%xmm0
  8c4393:	b9 00 00 00 01       	mov    $0x1000000,%ecx
  8c4398:	4c 8d b4 24 c0 00 00 	lea    0xc0(%rsp),%r14
  8c439f:	00 
  8c43a0:	48 8d bc 24 10 02 00 	lea    0x210(%rsp),%rdi
  8c43a7:	00 
  8c43a8:	4c 89 f6             	mov    %r14,%rsi
  8c43ab:	c5 f8 29 84 24 c0 00 	vmovaps %xmm0,0xc0(%rsp)
  8c43b2:	00 00 
  8c43b4:	48 8b 43 30          	mov    0x30(%rbx),%rax
  8c43b8:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  8c43bf:	00 
  8c43c0:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c43c6:	89 84 24 d8 00 00 00 	mov    %eax,0xd8(%rsp)
  8c43cd:	8b 83 40 01 00 00    	mov    0x140(%rbx),%eax
  8c43d3:	3d 00 00 00 01       	cmp    $0x1000000,%eax
  8c43d8:	0f 43 c1             	cmovae %ecx,%eax
  8c43db:	b9 00 00 01 00       	mov    $0x10000,%ecx
  8c43e0:	89 84 24 dc 00 00 00 	mov    %eax,0xdc(%rsp)
  8c43e7:	c5 f8 10 83 c0 00 00 	vmovups 0xc0(%rbx),%xmm0
  8c43ee:	00 
  8c43ef:	c5 f8 29 84 24 e0 00 	vmovaps %xmm0,0xe0(%rsp)
  8c43f6:	00 00 
  8c43f8:	8b 83 48 01 00 00    	mov    0x148(%rbx),%eax
  8c43fe:	89 84 24 f0 00 00 00 	mov    %eax,0xf0(%rsp)
  8c4405:	8b 83 4c 01 00 00    	mov    0x14c(%rbx),%eax
  8c440b:	3d 00 00 01 00       	cmp    $0x10000,%eax
  8c4410:	0f 43 c1             	cmovae %ecx,%eax
  8c4413:	89 84 24 f4 00 00 00 	mov    %eax,0xf4(%rsp)
  8c441a:	44 89 e0             	mov    %r12d,%eax
  8c441d:	48 6b d0 34          	imul   $0x34,%rax,%rdx
  8c4421:	0f b6 8b f8 01 00 00 	movzbl 0x1f8(%rbx),%ecx
  8c4428:	48 03 93 d0 01 00 00 	add    0x1d0(%rbx),%rdx
  8c442f:	83 f1 01             	xor    $0x1,%ecx
  8c4432:	c5 f8 77             	vzeroupper
  8c4435:	e8 f6 4a 98 00       	call   1248f30 <cbuiltin_varargs_append>
  8c443a:	e9 50 f7 ff ff       	jmp    8c3b8f <check_lower_drain+0xef>
  8c443f:	48 8b 03             	mov    (%rbx),%rax
  8c4442:	44 89 e1             	mov    %r12d,%ecx
  8c4445:	48 69 c9 b0 00 00 00 	imul   $0xb0,%rcx,%rcx
  8c444c:	48 8b 40 08          	mov    0x8(%rax),%rax
  8c4450:	48 8b 40 68          	mov    0x68(%rax),%rax
  8c4454:	48 8d 74 08 10       	lea    0x10(%rax,%rcx,1),%rsi
  8c4459:	48 89 df             	mov    %rbx,%rdi
  8c445c:	c5 f8 77             	vzeroupper
  8c445f:	e8 fc 9b 00 00       	call   8ce060 <check_lower_constant>
  8c4464:	e9 4f f7 ff ff       	jmp    8c3bb8 <check_lower_drain+0x118>
  8c4469:	8b ab 74 01 00 00    	mov    0x174(%rbx),%ebp
  8c446f:	89 e8                	mov    %ebp,%eax
  8c4471:	85 ed                	test   %ebp,%ebp
  8c4473:	75 64                	jne    8c44d9 <check_lower_drain+0xa39>
  8c4475:	8b 8b 44 01 00 00    	mov    0x144(%rbx),%ecx
  8c447b:	3b 8b 40 01 00 00    	cmp    0x140(%rbx),%ecx
  8c4481:	0f 83 bd 04 00 00    	jae    8c4944 <check_lower_drain+0xea4>
  8c4487:	48 8b 43 48          	mov    0x48(%rbx),%rax
  8c448b:	c7 04 88 ff ff ff ff 	movl   $0xffffffff,(%rax,%rcx,4)
  8c4492:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c4499:	75 0b                	jne    8c44a6 <check_lower_drain+0xa06>
  8c449b:	48 8b 43 50          	mov    0x50(%rbx),%rax
  8c449f:	c7 04 88 ff ff ff ff 	movl   $0xffffffff,(%rax,%rcx,4)
  8c44a6:	ff 83 44 01 00 00    	incl   0x144(%rbx)
  8c44ac:	e9 ba 04 00 00       	jmp    8c496b <check_lower_drain+0xecb>
  8c44b1:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  8c44b8:	0f 1f 84 00 00 00 00 
  8c44bf:	00 
  8c44c0:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c44c4:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c44cb:	74 6c                	je     8c4539 <check_lower_drain+0xa99>
  8c44cd:	48 8b 43 58          	mov    0x58(%rbx),%rax
  8c44d1:	42 8b 04 b0          	mov    (%rax,%r14,4),%eax
  8c44d5:	85 c0                	test   %eax,%eax
  8c44d7:	74 9c                	je     8c4475 <check_lower_drain+0x9d5>
  8c44d9:	48 8b 4b 60          	mov    0x60(%rbx),%rcx
  8c44dd:	41 89 c6             	mov    %eax,%r14d
  8c44e0:	42 0f b6 04 31       	movzbl (%rcx,%r14,1),%eax
  8c44e5:	3c 0f                	cmp    $0xf,%al
  8c44e7:	73 d7                	jae    8c44c0 <check_lower_drain+0xa20>
  8c44e9:	8b 8b 38 01 00 00    	mov    0x138(%rbx),%ecx
  8c44ef:	81 f9 ff ff ff 00    	cmp    $0xffffff,%ecx
  8c44f5:	77 29                	ja     8c4520 <check_lower_drain+0xa80>
  8c44f7:	3b 8b 40 01 00 00    	cmp    0x140(%rbx),%ecx
  8c44fd:	73 21                	jae    8c4520 <check_lower_drain+0xa80>
  8c44ff:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c4506:	75 6f                	jne    8c4577 <check_lower_drain+0xad7>
  8c4508:	0f b6 d0             	movzbl %al,%edx
  8c450b:	be 23 00 00 00       	mov    $0x23,%esi
  8c4510:	48 89 df             	mov    %rbx,%rdi
  8c4513:	31 c9                	xor    %ecx,%ecx
  8c4515:	c5 f8 77             	vzeroupper
  8c4518:	e8 43 ce 01 00       	call   8e1360 <check_lower_emit_tracked>
  8c451d:	eb ae                	jmp    8c44cd <check_lower_drain+0xa2d>
  8c451f:	90                   	nop
  8c4520:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c4524:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c452b:	75 a0                	jne    8c44cd <check_lower_drain+0xa2d>
  8c452d:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c4534:	00 00 00 
  8c4537:	eb 29                	jmp    8c4562 <check_lower_drain+0xac2>
  8c4539:	48 8d 0d fb 4f dc ff 	lea    -0x23b005(%rip),%rcx        # 68953b <fuzz_comment_end+0x26c80>
  8c4540:	48 89 88 00 01 00 00 	mov    %rcx,0x100(%rax)
  8c4547:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c454b:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c4552:	0f 85 75 ff ff ff    	jne    8c44cd <check_lower_drain+0xa2d>
  8c4558:	c7 80 f0 00 00 00 02 	movl   $0x2,0xf0(%rax)
  8c455f:	00 00 00 
  8c4562:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c4568:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c456c:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c4572:	e9 56 ff ff ff       	jmp    8c44cd <check_lower_drain+0xa2d>
  8c4577:	49 8b 55 00          	mov    0x0(%r13),%rdx
  8c457b:	83 ba f0 00 00 00 00 	cmpl   $0x0,0xf0(%rdx)
  8c4582:	0f 85 45 ff ff ff    	jne    8c44cd <check_lower_drain+0xa2d>
  8c4588:	48 8b 53 20          	mov    0x20(%rbx),%rdx
  8c458c:	c6 04 0a 23          	movb   $0x23,(%rdx,%rcx,1)
  8c4590:	48 8b 53 28          	mov    0x28(%rbx),%rdx
  8c4594:	88 04 0a             	mov    %al,(%rdx,%rcx,1)
  8c4597:	48 8b 43 30          	mov    0x30(%rbx),%rax
  8c459b:	48 c7 04 c8 00 00 00 	movq   $0x0,(%rax,%rcx,8)
  8c45a2:	00 
  8c45a3:	ff c1                	inc    %ecx
  8c45a5:	89 8b 38 01 00 00    	mov    %ecx,0x138(%rbx)
  8c45ab:	e9 1d ff ff ff       	jmp    8c44cd <check_lower_drain+0xa2d>
  8c45b0:	b8 03 06 00 00       	mov    $0x603,%eax
  8c45b5:	45 89 fe             	mov    %r15d,%r14d
  8c45b8:	41 83 e6 07          	and    $0x7,%r14d
  8c45bc:	48 c7 84 24 c0 00 00 	movq   $0x0,0xc0(%rsp)
  8c45c3:	00 00 00 00 00 
  8c45c8:	48 8d 94 24 d2 00 00 	lea    0xd2(%rsp),%rdx
  8c45cf:	00 
  8c45d0:	48 89 df             	mov    %rbx,%rdi
  8c45d3:	c4 c2 78 f7 c7       	bextr  %eax,%r15d,%eax
  8c45d8:	44 89 b4 24 c8 00 00 	mov    %r14d,0xc8(%rsp)
  8c45df:	00 
  8c45e0:	41 8d 74 06 08       	lea    0x8(%r14,%rax,1),%esi
  8c45e5:	8d 48 01             	lea    0x1(%rax),%ecx
  8c45e8:	89 8c 24 cc 00 00 00 	mov    %ecx,0xcc(%rsp)
  8c45ef:	44 89 f9             	mov    %r15d,%ecx
  8c45f2:	c1 e9 09             	shr    $0x9,%ecx
  8c45f5:	41 c1 ef 0d          	shr    $0xd,%r15d
  8c45f9:	80 e1 0f             	and    $0xf,%cl
  8c45fc:	c1 ee 03             	shr    $0x3,%esi
  8c45ff:	41 80 e7 01          	and    $0x1,%r15b
  8c4603:	88 8c 24 d0 00 00 00 	mov    %cl,0xd0(%rsp)
  8c460a:	44 88 bc 24 d1 00 00 	mov    %r15b,0xd1(%rsp)
  8c4611:	00 
  8c4612:	66 c7 42 04 00 00    	movw   $0x0,0x4(%rdx)
  8c4618:	c7 02 00 00 00 00    	movl   $0x0,(%rdx)
  8c461e:	c5 f8 77             	vzeroupper
  8c4621:	e8 5a 37 01 00       	call   8d7d80 <check_lower_bit_unit>
  8c4626:	48 8d b4 24 c0 00 00 	lea    0xc0(%rsp),%rsi
  8c462d:	00 
  8c462e:	48 89 df             	mov    %rbx,%rdi
  8c4631:	44 89 f2             	mov    %r14d,%edx
  8c4634:	e8 27 3e 01 00       	call   8d8460 <check_lower_bit_extract>
  8c4639:	e9 7a f5 ff ff       	jmp    8c3bb8 <check_lower_drain+0x118>
  8c463e:	48 89 df             	mov    %rbx,%rdi
  8c4641:	44 89 e6             	mov    %r12d,%esi
  8c4644:	4c 89 fa             	mov    %r15,%rdx
  8c4647:	c5 f8 77             	vzeroupper
  8c464a:	e8 61 a7 00 00       	call   8cedb0 <check_lower_address>
  8c464f:	e9 64 f5 ff ff       	jmp    8c3bb8 <check_lower_drain+0x118>
  8c4654:	48 8b 03             	mov    (%rbx),%rax
  8c4657:	44 89 e1             	mov    %r12d,%ecx
  8c465a:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
  8c465e:	44 89 fa             	mov    %r15d,%edx
  8c4661:	48 69 f2 b0 00 00 00 	imul   $0xb0,%rdx,%rsi
  8c4668:	49 c1 ef 20          	shr    $0x20,%r15
  8c466c:	48 89 df             	mov    %rbx,%rdi
  8c466f:	48 c1 e1 04          	shl    $0x4,%rcx
  8c4673:	48 8b 40 28          	mov    0x28(%rax),%rax
  8c4677:	48 8b 00             	mov    (%rax),%rax
  8c467a:	48 03 74 08 10       	add    0x10(%rax,%rcx,1),%rsi
  8c467f:	eb 44                	jmp    8c46c5 <check_lower_drain+0xc25>
  8c4681:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
  8c4685:	62 f1 fe 48 7f 44 24 	vmovdqu64 %zmm0,0xc0(%rsp)
  8c468c:	03 
  8c468d:	62 f1 fe 48 7f 84 24 	vmovdqu64 %zmm0,0x130(%rsp)
  8c4694:	30 01 00 00 
  8c4698:	44 89 f8             	mov    %r15d,%eax
  8c469b:	62 f1 fe 48 7f 44 24 	vmovdqu64 %zmm0,0x100(%rsp)
  8c46a2:	04 
  8c46a3:	c7 84 24 c0 00 00 00 	movl   $0x2,0xc0(%rsp)
  8c46aa:	02 00 00 00 
  8c46ae:	48 89 84 24 f0 00 00 	mov    %rax,0xf0(%rsp)
  8c46b5:	00 
  8c46b6:	49 c1 ef 20          	shr    $0x20,%r15
  8c46ba:	48 89 df             	mov    %rbx,%rdi
  8c46bd:	48 8d b4 24 c0 00 00 	lea    0xc0(%rsp),%rsi
  8c46c4:	00 
  8c46c5:	44 89 fa             	mov    %r15d,%edx
  8c46c8:	c5 f8 77             	vzeroupper
  8c46cb:	e8 10 b0 00 00       	call   8cf6e0 <check_lower_fill>
  8c46d0:	e9 e3 f4 ff ff       	jmp    8c3bb8 <check_lower_drain+0x118>
  8c46d5:	ba 07 00 00 00       	mov    $0x7,%edx
  8c46da:	48 89 df             	mov    %rbx,%rdi
  8c46dd:	44 89 fe             	mov    %r15d,%esi
  8c46e0:	c5 f8 77             	vzeroupper
  8c46e3:	e8 b8 90 00 00       	call   8cd7a0 <check_lower_vla_size>
  8c46e8:	e9 cb f4 ff ff       	jmp    8c3bb8 <check_lower_drain+0x118>
  8c46ed:	b9 03 06 00 00       	mov    $0x603,%ecx
  8c46f2:	49 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%r8
  8c46f9:	44 89 fa             	mov    %r15d,%edx
  8c46fc:	c1 ea 0d             	shr    $0xd,%edx
  8c46ff:	45 89 fd             	mov    %r15d,%r13d
  8c4702:	41 83 e5 07          	and    $0x7,%r13d
  8c4706:	48 8d b4 24 d2 00 00 	lea    0xd2(%rsp),%rsi
  8c470d:	00 
  8c470e:	48 c7 84 24 c0 00 00 	movq   $0x0,0xc0(%rsp)
  8c4715:	00 00 00 00 00 
  8c471a:	c4 c2 70 f7 ff       	bextr  %ecx,%r15d,%edi
  8c471f:	44 89 f9             	mov    %r15d,%ecx
  8c4722:	c1 e9 09             	shr    $0x9,%ecx
  8c4725:	80 e2 01             	and    $0x1,%dl
  8c4728:	44 89 ac 24 c8 00 00 	mov    %r13d,0xc8(%rsp)
  8c472f:	00 
  8c4730:	8d 6f 01             	lea    0x1(%rdi),%ebp
  8c4733:	80 e1 0f             	and    $0xf,%cl
  8c4736:	c4 42 d1 f7 f0       	shlx   %rbp,%r8,%r14
  8c473b:	83 fd 40             	cmp    $0x40,%ebp
  8c473e:	89 ac 24 cc 00 00 00 	mov    %ebp,0xcc(%rsp)
  8c4745:	88 8c 24 d0 00 00 00 	mov    %cl,0xd0(%rsp)
  8c474c:	88 94 24 d1 00 00 00 	mov    %dl,0xd1(%rsp)
  8c4753:	66 c7 46 04 00 00    	movw   $0x0,0x4(%rsi)
  8c4759:	c7 06 00 00 00 00    	movl   $0x0,(%rsi)
  8c475f:	49 f7 d6             	not    %r14
  8c4762:	4c 89 f6             	mov    %r14,%rsi
  8c4765:	49 0f 44 f0          	cmove  %r8,%rsi
  8c4769:	48 89 74 24 38       	mov    %rsi,0x38(%rsp)
  8c476e:	8b b3 48 01 00 00    	mov    0x148(%rbx),%esi
  8c4774:	48 81 fe ff ff 00 00 	cmp    $0xffff,%rsi
  8c477b:	0f 87 a0 02 00 00    	ja     8c4a21 <check_lower_drain+0xf81>
  8c4781:	3b b3 4c 01 00 00    	cmp    0x14c(%rbx),%esi
  8c4787:	0f 83 94 02 00 00    	jae    8c4a21 <check_lower_drain+0xf81>
  8c478d:	48 8b 83 c0 00 00 00 	mov    0xc0(%rbx),%rax
  8c4794:	c6 04 30 08          	movb   $0x8,(%rax,%rsi,1)
  8c4798:	48 8b 83 c8 00 00 00 	mov    0xc8(%rbx),%rax
  8c479f:	c6 04 30 00          	movb   $0x0,(%rax,%rsi,1)
  8c47a3:	48 8b 83 d8 00 00 00 	mov    0xd8(%rbx),%rax
  8c47aa:	c7 04 b0 00 00 00 00 	movl   $0x0,(%rax,%rsi,4)
  8c47b1:	48 8b 83 e0 00 00 00 	mov    0xe0(%rbx),%rax
  8c47b8:	c6 04 30 00          	movb   $0x0,(%rax,%rsi,1)
  8c47bc:	48 8b 83 b0 00 00 00 	mov    0xb0(%rbx),%rax
  8c47c3:	c6 04 30 00          	movb   $0x0,(%rax,%rsi,1)
  8c47c7:	ff 83 48 01 00 00    	incl   0x148(%rbx)
  8c47cd:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c47d1:	48 8b 00             	mov    (%rax),%rax
  8c47d4:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c47db:	0f 85 61 02 00 00    	jne    8c4a42 <check_lower_drain+0xfa2>
  8c47e1:	48 8b 83 d0 00 00 00 	mov    0xd0(%rbx),%rax
  8c47e8:	c6 04 30 08          	movb   $0x8,(%rax,%rsi,1)
  8c47ec:	48 89 74 24 30       	mov    %rsi,0x30(%rsp)
  8c47f1:	80 f9 08             	cmp    $0x8,%cl
  8c47f4:	0f 84 00 0c 00 00    	je     8c53fa <check_lower_drain+0x195a>
  8c47fa:	e9 51 02 00 00       	jmp    8c4a50 <check_lower_drain+0xfb0>
  8c47ff:	83 f9 14             	cmp    $0x14,%ecx
  8c4802:	0f 82 9e 02 00 00    	jb     8c4aa6 <check_lower_drain+0x1006>
  8c4808:	0f 85 01 07 00 00    	jne    8c4f0f <check_lower_drain+0x146f>
  8c480e:	c7 84 24 a0 00 00 00 	movl   $0x14,0xa0(%rsp)
  8c4815:	14 00 00 00 
  8c4819:	44 89 a4 24 a4 00 00 	mov    %r12d,0xa4(%rsp)
  8c4820:	00 
  8c4821:	48 c7 84 24 a8 00 00 	movq   $0x0,0xa8(%rsp)
  8c4828:	00 00 00 00 00 
  8c482d:	e9 03 07 00 00       	jmp    8c4f35 <check_lower_drain+0x1495>
  8c4832:	44 38 f5             	cmp    %r14b,%bpl
  8c4835:	0f 84 7d f3 ff ff    	je     8c3bb8 <check_lower_drain+0x118>
  8c483b:	8b 8b 38 01 00 00    	mov    0x138(%rbx),%ecx
  8c4841:	48 81 f9 ff ff ff 00 	cmp    $0xffffff,%rcx
  8c4848:	0f 87 12 0b 00 00    	ja     8c5360 <check_lower_drain+0x18c0>
  8c484e:	3b 8b 40 01 00 00    	cmp    0x140(%rbx),%ecx
  8c4854:	0f 83 06 0b 00 00    	jae    8c5360 <check_lower_drain+0x18c0>
  8c485a:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c4861:	0f 85 1d 1d 00 00    	jne    8c6584 <check_lower_drain+0x2ae4>
  8c4867:	41 0f b6 d6          	movzbl %r14b,%edx
  8c486b:	48 89 df             	mov    %rbx,%rdi
  8c486e:	be 09 00 00 00       	mov    $0x9,%esi
  8c4873:	e9 d5 0a 00 00       	jmp    8c534d <check_lower_drain+0x18ad>
  8c4878:	31 c0                	xor    %eax,%eax
  8c487a:	40 80 fd 0c          	cmp    $0xc,%bpl
  8c487e:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  8c4884:	41 b9 ff ff ff ff    	mov    $0xffffffff,%r9d
  8c488a:	48 89 df             	mov    %rbx,%rdi
  8c488d:	0f 95 c0             	setne  %al
  8c4890:	31 c9                	xor    %ecx,%ecx
  8c4892:	41 80 fe 0a          	cmp    $0xa,%r14b
  8c4896:	0f 95 c1             	setne  %cl
  8c4899:	41 80 fe 09          	cmp    $0x9,%r14b
  8c489d:	8d 04 40             	lea    (%rax,%rax,2),%eax
  8c48a0:	8d 14 cd a0 00 00 00 	lea    0xa0(,%rcx,8),%edx
  8c48a7:	8d 71 01             	lea    0x1(%rcx),%esi
  8c48aa:	b9 98 00 00 00       	mov    $0x98,%ecx
  8c48af:	0f 44 d1             	cmove  %ecx,%edx
  8c48b2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8c48b7:	0f 44 f1             	cmove  %ecx,%esi
  8c48ba:	48 8d 8c 24 c0 00 00 	lea    0xc0(%rsp),%rcx
  8c48c1:	00 
  8c48c2:	8d 74 06 05          	lea    0x5(%rsi,%rax,1),%esi
  8c48c6:	e8 b5 08 01 00       	call   8d5180 <check_lower_runtime_call>
  8c48cb:	41 89 c4             	mov    %eax,%r12d
  8c48ce:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c48d4:	45 89 ff             	mov    %r15d,%r15d
  8c48d7:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c48dd:	77 31                	ja     8c4910 <check_lower_drain+0xe70>
  8c48df:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c48e5:	73 29                	jae    8c4910 <check_lower_drain+0xe70>
  8c48e7:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c48ee:	0f 85 9f 02 00 00    	jne    8c4b93 <check_lower_drain+0x10f3>
  8c48f4:	be 1f 00 00 00       	mov    $0x1f,%esi
  8c48f9:	48 89 df             	mov    %rbx,%rdi
  8c48fc:	44 89 ea             	mov    %r13d,%edx
  8c48ff:	4c 89 f9             	mov    %r15,%rcx
  8c4902:	e8 59 ca 01 00       	call   8e1360 <check_lower_emit_tracked>
  8c4907:	4c 8d 6b 08          	lea    0x8(%rbx),%r13
  8c490b:	e9 b4 02 00 00       	jmp    8c4bc4 <check_lower_drain+0x1124>
  8c4910:	4c 8d 6b 08          	lea    0x8(%rbx),%r13
  8c4914:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c4918:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c491f:	0f 85 9f 02 00 00    	jne    8c4bc4 <check_lower_drain+0x1124>
  8c4925:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c492c:	00 00 00 
  8c492f:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c4935:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c4939:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c493f:	e9 80 02 00 00       	jmp    8c4bc4 <check_lower_drain+0x1124>
  8c4944:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c4948:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c494f:	75 1a                	jne    8c496b <check_lower_drain+0xecb>
  8c4951:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c4958:	00 00 00 
  8c495b:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c4961:	48 8b 53 08          	mov    0x8(%rbx),%rdx
  8c4965:	89 82 f4 00 00 00    	mov    %eax,0xf4(%rdx)
  8c496b:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c4971:	48 8b 53 48          	mov    0x48(%rbx),%rdx
  8c4975:	89 04 8a             	mov    %eax,(%rdx,%rcx,4)
  8c4978:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c497f:	75 3d                	jne    8c49be <check_lower_drain+0xf1e>
  8c4981:	48 8b 53 50          	mov    0x50(%rbx),%rdx
  8c4985:	80 bb 7c 01 00 00 00 	cmpb   $0x0,0x17c(%rbx)
  8c498c:	75 14                	jne    8c49a2 <check_lower_drain+0xf02>
  8c498e:	8b 34 8a             	mov    (%rdx,%rcx,4),%esi
  8c4991:	bf 00 00 00 00       	mov    $0x0,%edi
  8c4996:	83 fe ff             	cmp    $0xffffffff,%esi
  8c4999:	0f 44 f7             	cmove  %edi,%esi
  8c499c:	89 b3 74 01 00 00    	mov    %esi,0x174(%rbx)
  8c49a2:	83 3c 8a ff          	cmpl   $0xffffffff,(%rdx,%rcx,4)
  8c49a6:	75 0f                	jne    8c49b7 <check_lower_drain+0xf17>
  8c49a8:	8b 83 74 01 00 00    	mov    0x174(%rbx),%eax
  8c49ae:	89 04 8a             	mov    %eax,(%rdx,%rcx,4)
  8c49b1:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c49b7:	c6 83 7c 01 00 00 01 	movb   $0x1,0x17c(%rbx)
  8c49be:	3d ff ff ff 00       	cmp    $0xffffff,%eax
  8c49c3:	77 2c                	ja     8c49f1 <check_lower_drain+0xf51>
  8c49c5:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c49cb:	73 24                	jae    8c49f1 <check_lower_drain+0xf51>
  8c49cd:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c49d4:	0f 85 46 04 00 00    	jne    8c4e20 <check_lower_drain+0x1380>
  8c49da:	be 26 00 00 00       	mov    $0x26,%esi
  8c49df:	48 89 df             	mov    %rbx,%rdi
  8c49e2:	31 d2                	xor    %edx,%edx
  8c49e4:	c5 f8 77             	vzeroupper
  8c49e7:	e8 74 c9 01 00       	call   8e1360 <check_lower_emit_tracked>
  8c49ec:	e9 aa 04 00 00       	jmp    8c4e9b <check_lower_drain+0x13fb>
  8c49f1:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c49f5:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c49fc:	0f 85 99 04 00 00    	jne    8c4e9b <check_lower_drain+0x13fb>
  8c4a02:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c4a09:	00 00 00 
  8c4a0c:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c4a12:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c4a16:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c4a1c:	e9 7a 04 00 00       	jmp    8c4e9b <check_lower_drain+0x13fb>
  8c4a21:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c4a28:	0f 84 b5 06 00 00    	je     8c50e3 <check_lower_drain+0x1643>
  8c4a2e:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c4a32:	48 8b 00             	mov    (%rax),%rax
  8c4a35:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c4a3c:	0f 84 9f fd ff ff    	je     8c47e1 <check_lower_drain+0xd41>
  8c4a42:	48 89 74 24 30       	mov    %rsi,0x30(%rsp)
  8c4a47:	80 f9 08             	cmp    $0x8,%cl
  8c4a4a:	0f 84 aa 09 00 00    	je     8c53fa <check_lower_drain+0x195a>
  8c4a50:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c4a56:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c4a5c:	0f 87 7a 04 00 00    	ja     8c4edc <check_lower_drain+0x143c>
  8c4a62:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c4a68:	0f 83 6e 04 00 00    	jae    8c4edc <check_lower_drain+0x143c>
  8c4a6e:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c4a75:	0f 85 4b 09 00 00    	jne    8c53c6 <check_lower_drain+0x1926>
  8c4a7b:	be 09 00 00 00       	mov    $0x9,%esi
  8c4a80:	ba 08 00 00 00       	mov    $0x8,%edx
  8c4a85:	48 89 7c 24 20       	mov    %rdi,0x20(%rsp)
  8c4a8a:	48 89 df             	mov    %rbx,%rdi
  8c4a8d:	31 c9                	xor    %ecx,%ecx
  8c4a8f:	c5 f8 77             	vzeroupper
  8c4a92:	e8 c9 c8 01 00       	call   8e1360 <check_lower_emit_tracked>
  8c4a97:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c4a9c:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  8c4aa1:	e9 54 09 00 00       	jmp    8c53fa <check_lower_drain+0x195a>
  8c4aa6:	80 bb f8 01 00 00 00 	cmpb   $0x0,0x1f8(%rbx)
  8c4aad:	75 44                	jne    8c4af3 <check_lower_drain+0x1053>
  8c4aaf:	4c 8b 8b a8 01 00 00 	mov    0x1a8(%rbx),%r9
  8c4ab6:	48 b9 00 00 00 00 00 	movabs $0x40000000000,%rcx
  8c4abd:	04 00 00 
  8c4ac0:	4d 85 c9             	test   %r9,%r9
  8c4ac3:	0f 94 c0             	sete   %al
  8c4ac6:	49 85 cc             	test   %rcx,%r12
  8c4ac9:	0f 95 c1             	setne  %cl
  8c4acc:	08 c1                	or     %al,%cl
  8c4ace:	75 16                	jne    8c4ae6 <check_lower_drain+0x1046>
  8c4ad0:	48 8b 3b             	mov    (%rbx),%rdi
  8c4ad3:	44 89 e0             	mov    %r12d,%eax
  8c4ad6:	48 8b 17             	mov    (%rdi),%rdx
  8c4ad9:	48 8b 0a             	mov    (%rdx),%rcx
  8c4adc:	83 3c 81 00          	cmpl   $0x0,(%rcx,%rax,4)
  8c4ae0:	0f 84 aa 20 00 00    	je     8c6b90 <check_lower_drain+0x30f0>
  8c4ae6:	80 bb f9 01 00 00 00 	cmpb   $0x0,0x1f9(%rbx)
  8c4aed:	0f 84 89 16 00 00    	je     8c617c <check_lower_drain+0x26dc>
  8c4af3:	48 ff 83 40 05 00 00 	incq   0x540(%rbx)
  8c4afa:	44 89 e5             	mov    %r12d,%ebp
  8c4afd:	48 8d 44 6d 00       	lea    0x0(%rbp,%rbp,2),%rax
  8c4b02:	48 8b 33             	mov    (%rbx),%rsi
  8c4b05:	8b 93 b0 01 00 00    	mov    0x1b0(%rbx),%edx
  8c4b0b:	48 c1 e0 05          	shl    $0x5,%rax
  8c4b0f:	48 8b 7e 08          	mov    0x8(%rsi),%rdi
  8c4b13:	89 54 24 44          	mov    %edx,0x44(%rsp)
  8c4b17:	4c 8b 77 08          	mov    0x8(%rdi),%r14
  8c4b1b:	41 8b 0c 06          	mov    (%r14,%rax,1),%ecx
  8c4b1f:	c1 e9 03             	shr    $0x3,%ecx
  8c4b22:	39 d1                	cmp    %edx,%ecx
  8c4b24:	0f 83 73 04 00 00    	jae    8c4f9d <check_lower_drain+0x14fd>
  8c4b2a:	48 8b 93 a0 01 00 00 	mov    0x1a0(%rbx),%rdx
  8c4b31:	0f b6 14 0a          	movzbl (%rdx,%rcx,1),%edx
  8c4b35:	41 89 d0             	mov    %edx,%r8d
  8c4b38:	41 80 e0 04          	and    $0x4,%r8b
  8c4b3c:	41 c0 e8 02          	shr    $0x2,%r8b
  8c4b40:	44 89 44 24 54       	mov    %r8d,0x54(%rsp)
  8c4b45:	f6 c2 01             	test   $0x1,%dl
  8c4b48:	0f 84 a5 15 00 00    	je     8c60f3 <check_lower_drain+0x2653>
  8c4b4e:	b1 01                	mov    $0x1,%cl
  8c4b50:	41 b3 08             	mov    $0x8,%r11b
  8c4b53:	89 4c 24 70          	mov    %ecx,0x70(%rsp)
  8c4b57:	e9 ab 15 00 00       	jmp    8c6107 <check_lower_drain+0x2667>
  8c4b5c:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c4b63:	0f 85 4f f0 ff ff    	jne    8c3bb8 <check_lower_drain+0x118>
  8c4b69:	48 8b 43 20          	mov    0x20(%rbx),%rax
  8c4b6d:	c6 04 08 23          	movb   $0x23,(%rax,%rcx,1)
  8c4b71:	48 8b 43 28          	mov    0x28(%rbx),%rax
  8c4b75:	40 88 2c 08          	mov    %bpl,(%rax,%rcx,1)
  8c4b79:	48 8b 43 30          	mov    0x30(%rbx),%rax
  8c4b7d:	48 c7 04 c8 00 00 00 	movq   $0x0,(%rax,%rcx,8)
  8c4b84:	00 
  8c4b85:	8d 41 01             	lea    0x1(%rcx),%eax
  8c4b88:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c4b8e:	e9 25 f0 ff ff       	jmp    8c3bb8 <check_lower_drain+0x118>
  8c4b93:	4c 8d 6b 08          	lea    0x8(%rbx),%r13
  8c4b97:	49 8b 4d 00          	mov    0x0(%r13),%rcx
  8c4b9b:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c4ba2:	75 20                	jne    8c4bc4 <check_lower_drain+0x1124>
  8c4ba4:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c4ba8:	c6 04 01 1f          	movb   $0x1f,(%rcx,%rax,1)
  8c4bac:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c4bb0:	40 88 2c 01          	mov    %bpl,(%rcx,%rax,1)
  8c4bb4:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c4bb8:	4c 89 3c c1          	mov    %r15,(%rcx,%rax,8)
  8c4bbc:	ff c0                	inc    %eax
  8c4bbe:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c4bc4:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c4bca:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c4bd0:	77 28                	ja     8c4bfa <check_lower_drain+0x115a>
  8c4bd2:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c4bd8:	73 20                	jae    8c4bfa <check_lower_drain+0x115a>
  8c4bda:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c4be1:	75 40                	jne    8c4c23 <check_lower_drain+0x1183>
  8c4be3:	be 03 00 00 00       	mov    $0x3,%esi
  8c4be8:	ba 08 00 00 00       	mov    $0x8,%edx
  8c4bed:	48 89 df             	mov    %rbx,%rdi
  8c4bf0:	4c 89 f9             	mov    %r15,%rcx
  8c4bf3:	e8 68 c7 01 00       	call   8e1360 <check_lower_emit_tracked>
  8c4bf8:	eb 56                	jmp    8c4c50 <check_lower_drain+0x11b0>
  8c4bfa:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c4bfe:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c4c05:	75 49                	jne    8c4c50 <check_lower_drain+0x11b0>
  8c4c07:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c4c0e:	00 00 00 
  8c4c11:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c4c17:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c4c1b:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c4c21:	eb 2d                	jmp    8c4c50 <check_lower_drain+0x11b0>
  8c4c23:	49 8b 4d 00          	mov    0x0(%r13),%rcx
  8c4c27:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c4c2e:	75 20                	jne    8c4c50 <check_lower_drain+0x11b0>
  8c4c30:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c4c34:	c6 04 01 03          	movb   $0x3,(%rcx,%rax,1)
  8c4c38:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c4c3c:	c6 04 01 08          	movb   $0x8,(%rcx,%rax,1)
  8c4c40:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c4c44:	4c 89 3c c1          	mov    %r15,(%rcx,%rax,8)
  8c4c48:	ff c0                	inc    %eax
  8c4c4a:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c4c50:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c4c56:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c4c5c:	0f 87 af 03 00 00    	ja     8c5011 <check_lower_drain+0x1571>
  8c4c62:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c4c68:	0f 83 a3 03 00 00    	jae    8c5011 <check_lower_drain+0x1571>
  8c4c6e:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c4c75:	75 19                	jne    8c4c90 <check_lower_drain+0x11f0>
  8c4c77:	41 0f b6 d6          	movzbl %r14b,%edx
  8c4c7b:	be 22 00 00 00       	mov    $0x22,%esi
  8c4c80:	48 89 df             	mov    %rbx,%rdi
  8c4c83:	4c 89 e1             	mov    %r12,%rcx
  8c4c86:	e8 d5 c6 01 00       	call   8e1360 <check_lower_emit_tracked>
  8c4c8b:	e9 28 ef ff ff       	jmp    8c3bb8 <check_lower_drain+0x118>
  8c4c90:	49 8b 4d 00          	mov    0x0(%r13),%rcx
  8c4c94:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c4c9b:	0f 85 17 ef ff ff    	jne    8c3bb8 <check_lower_drain+0x118>
  8c4ca1:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c4ca5:	c6 04 01 22          	movb   $0x22,(%rcx,%rax,1)
  8c4ca9:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c4cad:	44 88 34 01          	mov    %r14b,(%rcx,%rax,1)
  8c4cb1:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c4cb5:	4c 89 24 c1          	mov    %r12,(%rcx,%rax,8)
  8c4cb9:	e9 fb 06 00 00       	jmp    8c53b9 <check_lower_drain+0x1919>
  8c4cbe:	8b 8b 38 01 00 00    	mov    0x138(%rbx),%ecx
  8c4cc4:	48 81 f9 ff ff ff 00 	cmp    $0xffffff,%rcx
  8c4ccb:	0f 87 e6 03 00 00    	ja     8c50b7 <check_lower_drain+0x1617>
  8c4cd1:	3b 8b 40 01 00 00    	cmp    0x140(%rbx),%ecx
  8c4cd7:	0f 83 da 03 00 00    	jae    8c50b7 <check_lower_drain+0x1617>
  8c4cdd:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c4ce4:	0f 85 bc 18 00 00    	jne    8c65a6 <check_lower_drain+0x2b06>
  8c4cea:	be 23 00 00 00       	mov    $0x23,%esi
  8c4cef:	ba 08 00 00 00       	mov    $0x8,%edx
  8c4cf4:	48 89 df             	mov    %rbx,%rdi
  8c4cf7:	31 c9                	xor    %ecx,%ecx
  8c4cf9:	c5 f8 77             	vzeroupper
  8c4cfc:	e8 5f c6 01 00       	call   8e1360 <check_lower_emit_tracked>
  8c4d01:	e9 cd 18 00 00       	jmp    8c65d3 <check_lower_drain+0x2b33>
  8c4d06:	31 c0                	xor    %eax,%eax
  8c4d08:	41 80 fe 0c          	cmp    $0xc,%r14b
  8c4d0c:	be 00 00 00 00       	mov    $0x0,%esi
  8c4d11:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  8c4d17:	48 89 df             	mov    %rbx,%rdi
  8c4d1a:	45 89 f9             	mov    %r15d,%r9d
  8c4d1d:	0f 95 c0             	setne  %al
  8c4d20:	31 c9                	xor    %ecx,%ecx
  8c4d22:	40 80 fd 0a          	cmp    $0xa,%bpl
  8c4d26:	0f 95 c1             	setne  %cl
  8c4d29:	8d 14 c5 70 00 00 00 	lea    0x70(,%rax,8),%edx
  8c4d30:	8d 04 40             	lea    (%rax,%rax,2),%eax
  8c4d33:	ff c1                	inc    %ecx
  8c4d35:	40 80 fd 09          	cmp    $0x9,%bpl
  8c4d39:	0f 44 ce             	cmove  %esi,%ecx
  8c4d3c:	8d 74 01 0b          	lea    0xb(%rcx,%rax,1),%esi
  8c4d40:	48 8d 8c 24 c0 00 00 	lea    0xc0(%rsp),%rcx
  8c4d47:	00 
  8c4d48:	e8 33 04 01 00       	call   8d5180 <check_lower_runtime_call>
  8c4d4d:	89 c1                	mov    %eax,%ecx
  8c4d4f:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c4d55:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c4d5b:	77 29                	ja     8c4d86 <check_lower_drain+0x12e6>
  8c4d5d:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c4d63:	73 21                	jae    8c4d86 <check_lower_drain+0x12e6>
  8c4d65:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c4d6c:	0f 85 3b 02 00 00    	jne    8c4fad <check_lower_drain+0x150d>
  8c4d72:	be 22 00 00 00       	mov    $0x22,%esi
  8c4d77:	48 89 df             	mov    %rbx,%rdi
  8c4d7a:	31 d2                	xor    %edx,%edx
  8c4d7c:	e8 df c5 01 00       	call   8e1360 <check_lower_emit_tracked>
  8c4d81:	e9 54 02 00 00       	jmp    8c4fda <check_lower_drain+0x153a>
  8c4d86:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c4d8a:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c4d91:	0f 85 43 02 00 00    	jne    8c4fda <check_lower_drain+0x153a>
  8c4d97:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c4d9e:	00 00 00 
  8c4da1:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c4da7:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c4dab:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c4db1:	e9 24 02 00 00       	jmp    8c4fda <check_lower_drain+0x153a>
  8c4db6:	8b 8b 38 01 00 00    	mov    0x138(%rbx),%ecx
  8c4dbc:	48 81 f9 ff ff ff 00 	cmp    $0xffffff,%rcx
  8c4dc3:	0f 87 97 05 00 00    	ja     8c5360 <check_lower_drain+0x18c0>
  8c4dc9:	3b 8b 40 01 00 00    	cmp    0x140(%rbx),%ecx
  8c4dcf:	0f 83 8b 05 00 00    	jae    8c5360 <check_lower_drain+0x18c0>
  8c4dd5:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c4ddc:	0f 85 92 1a 00 00    	jne    8c6874 <check_lower_drain+0x2dd4>
  8c4de2:	48 89 df             	mov    %rbx,%rdi
  8c4de5:	be 29 00 00 00       	mov    $0x29,%esi
  8c4dea:	31 d2                	xor    %edx,%edx
  8c4dec:	e9 aa f0 ff ff       	jmp    8c3e9b <check_lower_drain+0x3fb>
  8c4df1:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c4df8:	40 b5 05             	mov    $0x5,%bpl
  8c4dfb:	0f 85 fd 03 00 00    	jne    8c51fe <check_lower_drain+0x175e>
  8c4e01:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c4e08:	00 00 00 
  8c4e0b:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c4e11:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c4e15:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c4e1b:	e9 de 03 00 00       	jmp    8c51fe <check_lower_drain+0x175e>
  8c4e20:	49 8b 55 00          	mov    0x0(%r13),%rdx
  8c4e24:	83 ba f0 00 00 00 00 	cmpl   $0x0,0xf0(%rdx)
  8c4e2b:	75 6e                	jne    8c4e9b <check_lower_drain+0x13fb>
  8c4e2d:	48 8b 53 20          	mov    0x20(%rbx),%rdx
  8c4e31:	89 c6                	mov    %eax,%esi
  8c4e33:	ff c0                	inc    %eax
  8c4e35:	c6 04 32 26          	movb   $0x26,(%rdx,%rsi,1)
  8c4e39:	48 8b 53 28          	mov    0x28(%rbx),%rdx
  8c4e3d:	c6 04 32 00          	movb   $0x0,(%rdx,%rsi,1)
  8c4e41:	48 8b 53 30          	mov    0x30(%rbx),%rdx
  8c4e45:	48 89 0c f2          	mov    %rcx,(%rdx,%rsi,8)
  8c4e49:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c4e4f:	eb 4a                	jmp    8c4e9b <check_lower_drain+0x13fb>
  8c4e51:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  8c4e58:	0f 1f 84 00 00 00 00 
  8c4e5f:	00 
  8c4e60:	48 8b 73 60          	mov    0x60(%rbx),%rsi
  8c4e64:	48 8b 53 18          	mov    0x18(%rbx),%rdx
  8c4e68:	8d 79 01             	lea    0x1(%rcx),%edi
  8c4e6b:	48 c1 e1 04          	shl    $0x4,%rcx
  8c4e6f:	0f b6 34 06          	movzbl (%rsi,%rax,1),%esi
  8c4e73:	89 bb 3c 01 00 00    	mov    %edi,0x13c(%rbx)
  8c4e79:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  8c4e7e:	48 c1 e6 30          	shl    $0x30,%rsi
  8c4e82:	48 8d 74 37 02       	lea    0x2(%rdi,%rsi,1),%rsi
  8c4e87:	48 89 34 0a          	mov    %rsi,(%rdx,%rcx,1)
  8c4e8b:	48 c7 44 0a 08 00 00 	movq   $0x0,0x8(%rdx,%rcx,1)
  8c4e92:	00 00 
  8c4e94:	48 8b 4b 58          	mov    0x58(%rbx),%rcx
  8c4e98:	8b 2c 81             	mov    (%rcx,%rax,4),%ebp
  8c4e9b:	85 ed                	test   %ebp,%ebp
  8c4e9d:	0f 84 15 ed ff ff    	je     8c3bb8 <check_lower_drain+0x118>
  8c4ea3:	8b 8b 3c 01 00 00    	mov    0x13c(%rbx),%ecx
  8c4ea9:	89 e8                	mov    %ebp,%eax
  8c4eab:	3b 8b 40 01 00 00    	cmp    0x140(%rbx),%ecx
  8c4eb1:	72 ad                	jb     8c4e60 <check_lower_drain+0x13c0>
  8c4eb3:	49 8b 4d 00          	mov    0x0(%r13),%rcx
  8c4eb7:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c4ebe:	75 d4                	jne    8c4e94 <check_lower_drain+0x13f4>
  8c4ec0:	c7 81 f0 00 00 00 03 	movl   $0x3,0xf0(%rcx)
  8c4ec7:	00 00 00 
  8c4eca:	8b 8b 64 01 00 00    	mov    0x164(%rbx),%ecx
  8c4ed0:	48 8b 53 08          	mov    0x8(%rbx),%rdx
  8c4ed4:	89 8a f4 00 00 00    	mov    %ecx,0xf4(%rdx)
  8c4eda:	eb b8                	jmp    8c4e94 <check_lower_drain+0x13f4>
  8c4edc:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c4ee0:	48 8b 00             	mov    (%rax),%rax
  8c4ee3:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c4eea:	0f 85 0a 05 00 00    	jne    8c53fa <check_lower_drain+0x195a>
  8c4ef0:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c4ef7:	00 00 00 
  8c4efa:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c4f00:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c4f04:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c4f0a:	e9 eb 04 00 00       	jmp    8c53fa <check_lower_drain+0x195a>
  8c4f0f:	89 8c 24 a0 00 00 00 	mov    %ecx,0xa0(%rsp)
  8c4f16:	44 89 a4 24 a4 00 00 	mov    %r12d,0xa4(%rsp)
  8c4f1d:	00 
  8c4f1e:	44 89 bc 24 a8 00 00 	mov    %r15d,0xa8(%rsp)
  8c4f25:	00 
  8c4f26:	c7 84 24 ac 00 00 00 	movl   $0x0,0xac(%rsp)
  8c4f2d:	00 00 00 00 
  8c4f31:	49 c1 ef 20          	shr    $0x20,%r15
  8c4f35:	4c 89 e0             	mov    %r12,%rax
  8c4f38:	48 c1 e8 28          	shr    $0x28,%rax
  8c4f3c:	4c 89 bc 24 b0 00 00 	mov    %r15,0xb0(%rsp)
  8c4f43:	00 
  8c4f44:	48 8d 8c 24 bb 00 00 	lea    0xbb(%rsp),%rcx
  8c4f4b:	00 
  8c4f4c:	48 89 df             	mov    %rbx,%rdi
  8c4f4f:	24 01                	and    $0x1,%al
  8c4f51:	88 84 24 b8 00 00 00 	mov    %al,0xb8(%rsp)
  8c4f58:	4c 89 e0             	mov    %r12,%rax
  8c4f5b:	48 c1 e8 29          	shr    $0x29,%rax
  8c4f5f:	49 c1 ec 2a          	shr    $0x2a,%r12
  8c4f63:	24 01                	and    $0x1,%al
  8c4f65:	41 80 e4 01          	and    $0x1,%r12b
  8c4f69:	88 84 24 b9 00 00 00 	mov    %al,0xb9(%rsp)
  8c4f70:	44 88 a4 24 ba 00 00 	mov    %r12b,0xba(%rsp)
  8c4f77:	00 
  8c4f78:	c6 41 04 00          	movb   $0x0,0x4(%rcx)
  8c4f7c:	c7 01 00 00 00 00    	movl   $0x0,(%rcx)
  8c4f82:	c5 fe 6f 84 24 a0 00 	vmovdqu 0xa0(%rsp),%ymm0
  8c4f89:	00 00 
  8c4f8b:	c5 fe 7f 04 24       	vmovdqu %ymm0,(%rsp)
  8c4f90:	c5 f8 77             	vzeroupper
  8c4f93:	e8 78 b6 00 00       	call   8d0610 <check_lower_complex_task>
  8c4f98:	e9 1b ec ff ff       	jmp    8c3bb8 <check_lower_drain+0x118>
  8c4f9d:	41 b3 ff             	mov    $0xff,%r11b
  8c4fa0:	c7 44 24 54 00 00 00 	movl   $0x0,0x54(%rsp)
  8c4fa7:	00 
  8c4fa8:	e9 52 11 00 00       	jmp    8c60ff <check_lower_drain+0x265f>
  8c4fad:	49 8b 55 00          	mov    0x0(%r13),%rdx
  8c4fb1:	83 ba f0 00 00 00 00 	cmpl   $0x0,0xf0(%rdx)
  8c4fb8:	75 20                	jne    8c4fda <check_lower_drain+0x153a>
  8c4fba:	48 8b 53 20          	mov    0x20(%rbx),%rdx
  8c4fbe:	c6 04 02 22          	movb   $0x22,(%rdx,%rax,1)
  8c4fc2:	48 8b 53 28          	mov    0x28(%rbx),%rdx
  8c4fc6:	c6 04 02 00          	movb   $0x0,(%rdx,%rax,1)
  8c4fca:	48 8b 53 30          	mov    0x30(%rbx),%rdx
  8c4fce:	48 89 0c c2          	mov    %rcx,(%rdx,%rax,8)
  8c4fd2:	ff c0                	inc    %eax
  8c4fd4:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c4fda:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c4fe0:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c4fe6:	77 29                	ja     8c5011 <check_lower_drain+0x1571>
  8c4fe8:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c4fee:	73 21                	jae    8c5011 <check_lower_drain+0x1571>
  8c4ff0:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c4ff7:	44 89 f9             	mov    %r15d,%ecx
  8c4ffa:	75 2b                	jne    8c5027 <check_lower_drain+0x1587>
  8c4ffc:	be 02 00 00 00       	mov    $0x2,%esi
  8c5001:	48 89 df             	mov    %rbx,%rdi
  8c5004:	44 89 e2             	mov    %r12d,%edx
  8c5007:	e8 54 c3 01 00       	call   8e1360 <check_lower_emit_tracked>
  8c500c:	e9 a7 eb ff ff       	jmp    8c3bb8 <check_lower_drain+0x118>
  8c5011:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c5015:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c501c:	0f 85 96 eb ff ff    	jne    8c3bb8 <check_lower_drain+0x118>
  8c5022:	e9 46 03 00 00       	jmp    8c536d <check_lower_drain+0x18cd>
  8c5027:	49 8b 55 00          	mov    0x0(%r13),%rdx
  8c502b:	83 ba f0 00 00 00 00 	cmpl   $0x0,0xf0(%rdx)
  8c5032:	0f 85 80 eb ff ff    	jne    8c3bb8 <check_lower_drain+0x118>
  8c5038:	48 8b 53 20          	mov    0x20(%rbx),%rdx
  8c503c:	c6 04 02 02          	movb   $0x2,(%rdx,%rax,1)
  8c5040:	48 8b 53 28          	mov    0x28(%rbx),%rdx
  8c5044:	44 88 34 02          	mov    %r14b,(%rdx,%rax,1)
  8c5048:	48 8b 53 30          	mov    0x30(%rbx),%rdx
  8c504c:	48 89 0c c2          	mov    %rcx,(%rdx,%rax,8)
  8c5050:	e9 64 03 00 00       	jmp    8c53b9 <check_lower_drain+0x1919>
  8c5055:	89 f1                	mov    %esi,%ecx
  8c5057:	4c 8d 05 53 d7 e2 ff 	lea    -0x1d28ad(%rip),%r8        # 6f27b1 <pp_string_value.meaning+0x3ef74>
  8c505e:	80 e1 fe             	and    $0xfe,%cl
  8c5061:	80 f9 0c             	cmp    $0xc,%cl
  8c5064:	74 1d                	je     8c5083 <check_lower_drain+0x15e3>
  8c5066:	4c 8d 05 c9 24 e2 ff 	lea    -0x1ddb37(%rip),%r8        # 6e7536 <pp_string_value.meaning+0x33cf9>
  8c506d:	40 80 fe 0e          	cmp    $0xe,%sil
  8c5071:	74 10                	je     8c5083 <check_lower_drain+0x15e3>
  8c5073:	4c 8d 05 ce 6a d2 ff 	lea    -0x2d9532(%rip),%r8        # 5ebb48 <parse_test_openers+0x1f9b3>
  8c507a:	80 f9 10             	cmp    $0x10,%cl
  8c507d:	0f 85 ce 1b 00 00    	jne    8c6c51 <check_lower_drain+0x31b1>
  8c5083:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c508a:	0f 85 28 eb ff ff    	jne    8c3bb8 <check_lower_drain+0x118>
  8c5090:	4c 89 80 00 01 00 00 	mov    %r8,0x100(%rax)
  8c5097:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c509b:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c50a2:	0f 85 10 eb ff ff    	jne    8c3bb8 <check_lower_drain+0x118>
  8c50a8:	c7 80 f0 00 00 00 02 	movl   $0x2,0xf0(%rax)
  8c50af:	00 00 00 
  8c50b2:	e9 c0 02 00 00       	jmp    8c5377 <check_lower_drain+0x18d7>
  8c50b7:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c50be:	0f 85 0f 15 00 00    	jne    8c65d3 <check_lower_drain+0x2b33>
  8c50c4:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c50cb:	00 00 00 
  8c50ce:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c50d4:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c50d8:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c50de:	e9 f0 14 00 00       	jmp    8c65d3 <check_lower_drain+0x2b33>
  8c50e3:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c50ea:	00 00 00 
  8c50ed:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c50f3:	48 8b 53 08          	mov    0x8(%rbx),%rdx
  8c50f7:	89 82 f4 00 00 00    	mov    %eax,0xf4(%rdx)
  8c50fd:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c5101:	48 8b 00             	mov    (%rax),%rax
  8c5104:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c510b:	0f 85 31 f9 ff ff    	jne    8c4a42 <check_lower_drain+0xfa2>
  8c5111:	e9 cb f6 ff ff       	jmp    8c47e1 <check_lower_drain+0xd41>
  8c5116:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c511d:	0f 84 3d 1a 00 00    	je     8c6b60 <check_lower_drain+0x30c0>
  8c5123:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c5127:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c512e:	0f 84 1f f2 ff ff    	je     8c4353 <check_lower_drain+0x8b3>
  8c5134:	bd ff ff ff ff       	mov    $0xffffffff,%ebp
  8c5139:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8c5140:	01 00 00 
  8c5143:	49 85 c4             	test   %rax,%r12
  8c5146:	0f 84 2b f2 ff ff    	je     8c4377 <check_lower_drain+0x8d7>
  8c514c:	be 08 00 00 00       	mov    $0x8,%esi
  8c5151:	48 89 df             	mov    %rbx,%rdi
  8c5154:	c5 f8 77             	vzeroupper
  8c5157:	e8 94 94 ff ff       	call   8be5f0 <check_lower_temporary>
  8c515c:	89 c5                	mov    %eax,%ebp
  8c515e:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c5164:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c516a:	77 32                	ja     8c519e <check_lower_drain+0x16fe>
  8c516c:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c5172:	73 2a                	jae    8c519e <check_lower_drain+0x16fe>
  8c5174:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c517b:	0f 85 1d 17 00 00    	jne    8c689e <check_lower_drain+0x2dfe>
  8c5181:	be 1f 00 00 00       	mov    $0x1f,%esi
  8c5186:	ba 08 00 00 00       	mov    $0x8,%edx
  8c518b:	48 89 df             	mov    %rbx,%rdi
  8c518e:	4c 89 f1             	mov    %r14,%rcx
  8c5191:	c5 f8 77             	vzeroupper
  8c5194:	e8 c7 c1 01 00       	call   8e1360 <check_lower_emit_tracked>
  8c5199:	e9 2d 17 00 00       	jmp    8c68cb <check_lower_drain+0x2e2b>
  8c519e:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c51a2:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c51a9:	0f 85 1c 17 00 00    	jne    8c68cb <check_lower_drain+0x2e2b>
  8c51af:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c51b6:	00 00 00 
  8c51b9:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c51bf:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c51c3:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c51c9:	e9 fd 16 00 00       	jmp    8c68cb <check_lower_drain+0x2e2b>
  8c51ce:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c51d5:	40 b5 05             	mov    $0x5,%bpl
  8c51d8:	75 24                	jne    8c51fe <check_lower_drain+0x175e>
  8c51da:	48 8b 43 20          	mov    0x20(%rbx),%rax
  8c51de:	c6 04 08 09          	movb   $0x9,(%rax,%rcx,1)
  8c51e2:	48 8b 43 28          	mov    0x28(%rbx),%rax
  8c51e6:	c6 04 08 05          	movb   $0x5,(%rax,%rcx,1)
  8c51ea:	48 8b 43 30          	mov    0x30(%rbx),%rax
  8c51ee:	48 c7 04 c8 00 00 00 	movq   $0x0,(%rax,%rcx,8)
  8c51f5:	00 
  8c51f6:	ff c1                	inc    %ecx
  8c51f8:	89 8b 38 01 00 00    	mov    %ecx,0x138(%rbx)
  8c51fe:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c5204:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c520a:	77 29                	ja     8c5235 <check_lower_drain+0x1795>
  8c520c:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c5212:	73 21                	jae    8c5235 <check_lower_drain+0x1795>
  8c5214:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c521b:	75 41                	jne    8c525e <check_lower_drain+0x17be>
  8c521d:	40 0f b6 d5          	movzbl %bpl,%edx
  8c5221:	be 01 00 00 00       	mov    $0x1,%esi
  8c5226:	48 89 df             	mov    %rbx,%rdi
  8c5229:	31 c9                	xor    %ecx,%ecx
  8c522b:	c5 f8 77             	vzeroupper
  8c522e:	e8 2d c1 01 00       	call   8e1360 <check_lower_emit_tracked>
  8c5233:	eb 5a                	jmp    8c528f <check_lower_drain+0x17ef>
  8c5235:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c5239:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5240:	75 4d                	jne    8c528f <check_lower_drain+0x17ef>
  8c5242:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c5249:	00 00 00 
  8c524c:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c5252:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c5256:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c525c:	eb 31                	jmp    8c528f <check_lower_drain+0x17ef>
  8c525e:	49 8b 4d 00          	mov    0x0(%r13),%rcx
  8c5262:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c5269:	75 24                	jne    8c528f <check_lower_drain+0x17ef>
  8c526b:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c526f:	c6 04 01 01          	movb   $0x1,(%rcx,%rax,1)
  8c5273:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c5277:	40 88 2c 01          	mov    %bpl,(%rcx,%rax,1)
  8c527b:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c527f:	48 c7 04 c1 00 00 00 	movq   $0x0,(%rcx,%rax,8)
  8c5286:	00 
  8c5287:	ff c0                	inc    %eax
  8c5289:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c528f:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c5295:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c529b:	77 2a                	ja     8c52c7 <check_lower_drain+0x1827>
  8c529d:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c52a3:	73 22                	jae    8c52c7 <check_lower_drain+0x1827>
  8c52a5:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c52ac:	75 42                	jne    8c52f0 <check_lower_drain+0x1850>
  8c52ae:	be 17 00 00 00       	mov    $0x17,%esi
  8c52b3:	ba 05 00 00 00       	mov    $0x5,%edx
  8c52b8:	48 89 df             	mov    %rbx,%rdi
  8c52bb:	31 c9                	xor    %ecx,%ecx
  8c52bd:	c5 f8 77             	vzeroupper
  8c52c0:	e8 9b c0 01 00       	call   8e1360 <check_lower_emit_tracked>
  8c52c5:	eb 5a                	jmp    8c5321 <check_lower_drain+0x1881>
  8c52c7:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c52cb:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c52d2:	75 4d                	jne    8c5321 <check_lower_drain+0x1881>
  8c52d4:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c52db:	00 00 00 
  8c52de:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c52e4:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c52e8:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c52ee:	eb 31                	jmp    8c5321 <check_lower_drain+0x1881>
  8c52f0:	49 8b 4d 00          	mov    0x0(%r13),%rcx
  8c52f4:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c52fb:	75 24                	jne    8c5321 <check_lower_drain+0x1881>
  8c52fd:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c5301:	c6 04 01 17          	movb   $0x17,(%rcx,%rax,1)
  8c5305:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c5309:	c6 04 01 05          	movb   $0x5,(%rcx,%rax,1)
  8c530d:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c5311:	48 c7 04 c1 00 00 00 	movq   $0x0,(%rcx,%rax,8)
  8c5318:	00 
  8c5319:	ff c0                	inc    %eax
  8c531b:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c5321:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c5327:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c532d:	77 2d                	ja     8c535c <check_lower_drain+0x18bc>
  8c532f:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c5335:	73 25                	jae    8c535c <check_lower_drain+0x18bc>
  8c5337:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c533e:	75 4c                	jne    8c538c <check_lower_drain+0x18ec>
  8c5340:	48 89 df             	mov    %rbx,%rdi
  8c5343:	be 09 00 00 00       	mov    $0x9,%esi
  8c5348:	ba 02 00 00 00       	mov    $0x2,%edx
  8c534d:	31 c9                	xor    %ecx,%ecx
  8c534f:	c5 f8 77             	vzeroupper
  8c5352:	e8 09 c0 01 00       	call   8e1360 <check_lower_emit_tracked>
  8c5357:	e9 5c e8 ff ff       	jmp    8c3bb8 <check_lower_drain+0x118>
  8c535c:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c5360:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5367:	0f 85 4b e8 ff ff    	jne    8c3bb8 <check_lower_drain+0x118>
  8c536d:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c5374:	00 00 00 
  8c5377:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c537d:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c5381:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c5387:	e9 2c e8 ff ff       	jmp    8c3bb8 <check_lower_drain+0x118>
  8c538c:	49 8b 4d 00          	mov    0x0(%r13),%rcx
  8c5390:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c5397:	0f 85 1b e8 ff ff    	jne    8c3bb8 <check_lower_drain+0x118>
  8c539d:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c53a1:	c6 04 01 09          	movb   $0x9,(%rcx,%rax,1)
  8c53a5:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c53a9:	c6 04 01 02          	movb   $0x2,(%rcx,%rax,1)
  8c53ad:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c53b1:	48 c7 04 c1 00 00 00 	movq   $0x0,(%rcx,%rax,8)
  8c53b8:	00 
  8c53b9:	ff c0                	inc    %eax
  8c53bb:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c53c1:	e9 f2 e7 ff ff       	jmp    8c3bb8 <check_lower_drain+0x118>
  8c53c6:	48 8d 4b 08          	lea    0x8(%rbx),%rcx
  8c53ca:	48 8b 09             	mov    (%rcx),%rcx
  8c53cd:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c53d4:	75 24                	jne    8c53fa <check_lower_drain+0x195a>
  8c53d6:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c53da:	c6 04 01 09          	movb   $0x9,(%rcx,%rax,1)
  8c53de:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c53e2:	c6 04 01 08          	movb   $0x8,(%rcx,%rax,1)
  8c53e6:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c53ea:	48 c7 04 c1 00 00 00 	movq   $0x0,(%rcx,%rax,8)
  8c53f1:	00 
  8c53f2:	ff c0                	inc    %eax
  8c53f4:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c53fa:	83 fd 40             	cmp    $0x40,%ebp
  8c53fd:	0f 84 43 01 00 00    	je     8c5546 <check_lower_drain+0x1aa6>
  8c5403:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c5409:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c540f:	77 36                	ja     8c5447 <check_lower_drain+0x19a7>
  8c5411:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c5417:	73 2e                	jae    8c5447 <check_lower_drain+0x19a7>
  8c5419:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c5420:	75 51                	jne    8c5473 <check_lower_drain+0x19d3>
  8c5422:	be 01 00 00 00       	mov    $0x1,%esi
  8c5427:	ba 08 00 00 00       	mov    $0x8,%edx
  8c542c:	48 89 fd             	mov    %rdi,%rbp
  8c542f:	48 89 df             	mov    %rbx,%rdi
  8c5432:	4c 89 f1             	mov    %r14,%rcx
  8c5435:	c5 f8 77             	vzeroupper
  8c5438:	e8 23 bf 01 00       	call   8e1360 <check_lower_emit_tracked>
  8c543d:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  8c5442:	48 89 ef             	mov    %rbp,%rdi
  8c5445:	eb 5c                	jmp    8c54a3 <check_lower_drain+0x1a03>
  8c5447:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c544b:	48 8b 00             	mov    (%rax),%rax
  8c544e:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5455:	75 4c                	jne    8c54a3 <check_lower_drain+0x1a03>
  8c5457:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c545e:	00 00 00 
  8c5461:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c5467:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c546b:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c5471:	eb 30                	jmp    8c54a3 <check_lower_drain+0x1a03>
  8c5473:	48 8d 4b 08          	lea    0x8(%rbx),%rcx
  8c5477:	48 8b 09             	mov    (%rcx),%rcx
  8c547a:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c5481:	75 20                	jne    8c54a3 <check_lower_drain+0x1a03>
  8c5483:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c5487:	c6 04 01 01          	movb   $0x1,(%rcx,%rax,1)
  8c548b:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c548f:	c6 04 01 08          	movb   $0x8,(%rcx,%rax,1)
  8c5493:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c5497:	4c 89 34 c1          	mov    %r14,(%rcx,%rax,8)
  8c549b:	ff c0                	inc    %eax
  8c549d:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c54a3:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c54a9:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c54af:	77 35                	ja     8c54e6 <check_lower_drain+0x1a46>
  8c54b1:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c54b7:	73 2d                	jae    8c54e6 <check_lower_drain+0x1a46>
  8c54b9:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c54c0:	75 50                	jne    8c5512 <check_lower_drain+0x1a72>
  8c54c2:	be 10 00 00 00       	mov    $0x10,%esi
  8c54c7:	ba 08 00 00 00       	mov    $0x8,%edx
  8c54cc:	49 89 fe             	mov    %rdi,%r14
  8c54cf:	48 89 df             	mov    %rbx,%rdi
  8c54d2:	31 c9                	xor    %ecx,%ecx
  8c54d4:	c5 f8 77             	vzeroupper
  8c54d7:	e8 84 be 01 00       	call   8e1360 <check_lower_emit_tracked>
  8c54dc:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  8c54e1:	4c 89 f7             	mov    %r14,%rdi
  8c54e4:	eb 60                	jmp    8c5546 <check_lower_drain+0x1aa6>
  8c54e6:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c54ea:	48 8b 00             	mov    (%rax),%rax
  8c54ed:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c54f4:	75 50                	jne    8c5546 <check_lower_drain+0x1aa6>
  8c54f6:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c54fd:	00 00 00 
  8c5500:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c5506:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c550a:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c5510:	eb 34                	jmp    8c5546 <check_lower_drain+0x1aa6>
  8c5512:	48 8d 4b 08          	lea    0x8(%rbx),%rcx
  8c5516:	48 8b 09             	mov    (%rcx),%rcx
  8c5519:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c5520:	75 24                	jne    8c5546 <check_lower_drain+0x1aa6>
  8c5522:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c5526:	c6 04 01 10          	movb   $0x10,(%rcx,%rax,1)
  8c552a:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c552e:	c6 04 01 08          	movb   $0x8,(%rcx,%rax,1)
  8c5532:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c5536:	48 c7 04 c1 00 00 00 	movq   $0x0,(%rcx,%rax,8)
  8c553d:	00 
  8c553e:	ff c0                	inc    %eax
  8c5540:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c5546:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c554c:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c5552:	77 33                	ja     8c5587 <check_lower_drain+0x1ae7>
  8c5554:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c555a:	73 2b                	jae    8c5587 <check_lower_drain+0x1ae7>
  8c555c:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c5563:	75 4e                	jne    8c55b3 <check_lower_drain+0x1b13>
  8c5565:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
  8c556a:	be 1f 00 00 00       	mov    $0x1f,%esi
  8c556f:	ba 08 00 00 00       	mov    $0x8,%edx
  8c5574:	49 89 fe             	mov    %rdi,%r14
  8c5577:	48 89 df             	mov    %rbx,%rdi
  8c557a:	c5 f8 77             	vzeroupper
  8c557d:	e8 de bd 01 00       	call   8e1360 <check_lower_emit_tracked>
  8c5582:	4c 89 f7             	mov    %r14,%rdi
  8c5585:	eb 5c                	jmp    8c55e3 <check_lower_drain+0x1b43>
  8c5587:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c558b:	48 8b 00             	mov    (%rax),%rax
  8c558e:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5595:	75 4c                	jne    8c55e3 <check_lower_drain+0x1b43>
  8c5597:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c559e:	00 00 00 
  8c55a1:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c55a7:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c55ab:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c55b1:	eb 30                	jmp    8c55e3 <check_lower_drain+0x1b43>
  8c55b3:	48 8d 4b 08          	lea    0x8(%rbx),%rcx
  8c55b7:	48 8b 09             	mov    (%rcx),%rcx
  8c55ba:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c55c1:	75 20                	jne    8c55e3 <check_lower_drain+0x1b43>
  8c55c3:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c55c7:	c6 04 01 1f          	movb   $0x1f,(%rcx,%rax,1)
  8c55cb:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c55cf:	c6 04 01 08          	movb   $0x8,(%rcx,%rax,1)
  8c55d3:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c55d7:	48 89 34 c1          	mov    %rsi,(%rcx,%rax,8)
  8c55db:	ff c0                	inc    %eax
  8c55dd:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c55e3:	45 8d 74 3d 08       	lea    0x8(%r13,%rdi,1),%r14d
  8c55e8:	4c 89 f8             	mov    %r15,%rax
  8c55eb:	48 c1 e8 20          	shr    $0x20,%rax
  8c55ef:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  8c55f4:	41 c1 ee 03          	shr    $0x3,%r14d
  8c55f8:	f3 41 0f b8 ee       	popcnt %r14d,%ebp
  8c55fd:	83 fd 01             	cmp    $0x1,%ebp
  8c5600:	0f 87 9c 00 00 00    	ja     8c56a2 <check_lower_drain+0x1c02>
  8c5606:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c560c:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c5612:	77 2d                	ja     8c5641 <check_lower_drain+0x1ba1>
  8c5614:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c561a:	73 25                	jae    8c5641 <check_lower_drain+0x1ba1>
  8c561c:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c5623:	75 48                	jne    8c566d <check_lower_drain+0x1bcd>
  8c5625:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  8c562a:	be 02 00 00 00       	mov    $0x2,%esi
  8c562f:	ba 08 00 00 00       	mov    $0x8,%edx
  8c5634:	48 89 df             	mov    %rbx,%rdi
  8c5637:	c5 f8 77             	vzeroupper
  8c563a:	e8 21 bd 01 00       	call   8e1360 <check_lower_emit_tracked>
  8c563f:	eb 61                	jmp    8c56a2 <check_lower_drain+0x1c02>
  8c5641:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c5645:	48 8b 00             	mov    (%rax),%rax
  8c5648:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c564f:	75 51                	jne    8c56a2 <check_lower_drain+0x1c02>
  8c5651:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c5658:	00 00 00 
  8c565b:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c5661:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c5665:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c566b:	eb 35                	jmp    8c56a2 <check_lower_drain+0x1c02>
  8c566d:	48 8d 4b 08          	lea    0x8(%rbx),%rcx
  8c5671:	48 8b 09             	mov    (%rcx),%rcx
  8c5674:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c567b:	75 25                	jne    8c56a2 <check_lower_drain+0x1c02>
  8c567d:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c5681:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
  8c5686:	c6 04 01 02          	movb   $0x2,(%rcx,%rax,1)
  8c568a:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c568e:	c6 04 01 08          	movb   $0x8,(%rcx,%rax,1)
  8c5692:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c5696:	48 89 14 c1          	mov    %rdx,(%rcx,%rax,8)
  8c569a:	ff c0                	inc    %eax
  8c569c:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c56a2:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c56a8:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c56ae:	77 2d                	ja     8c56dd <check_lower_drain+0x1c3d>
  8c56b0:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c56b6:	73 25                	jae    8c56dd <check_lower_drain+0x1c3d>
  8c56b8:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c56bf:	75 48                	jne    8c5709 <check_lower_drain+0x1c69>
  8c56c1:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  8c56c6:	be 02 00 00 00       	mov    $0x2,%esi
  8c56cb:	ba 08 00 00 00       	mov    $0x8,%edx
  8c56d0:	48 89 df             	mov    %rbx,%rdi
  8c56d3:	c5 f8 77             	vzeroupper
  8c56d6:	e8 85 bc 01 00       	call   8e1360 <check_lower_emit_tracked>
  8c56db:	eb 61                	jmp    8c573e <check_lower_drain+0x1c9e>
  8c56dd:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c56e1:	48 8b 00             	mov    (%rax),%rax
  8c56e4:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c56eb:	75 51                	jne    8c573e <check_lower_drain+0x1c9e>
  8c56ed:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c56f4:	00 00 00 
  8c56f7:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c56fd:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c5701:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c5707:	eb 35                	jmp    8c573e <check_lower_drain+0x1c9e>
  8c5709:	48 8d 4b 08          	lea    0x8(%rbx),%rcx
  8c570d:	48 8b 09             	mov    (%rcx),%rcx
  8c5710:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c5717:	75 25                	jne    8c573e <check_lower_drain+0x1c9e>
  8c5719:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c571d:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
  8c5722:	c6 04 01 02          	movb   $0x2,(%rcx,%rax,1)
  8c5726:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c572a:	c6 04 01 08          	movb   $0x8,(%rcx,%rax,1)
  8c572e:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c5732:	48 89 14 c1          	mov    %rdx,(%rcx,%rax,8)
  8c5736:	ff c0                	inc    %eax
  8c5738:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c573e:	48 89 df             	mov    %rbx,%rdi
  8c5741:	44 89 f6             	mov    %r14d,%esi
  8c5744:	c5 f8 77             	vzeroupper
  8c5747:	e8 34 26 01 00       	call   8d7d80 <check_lower_bit_unit>
  8c574c:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c5752:	41 83 e7 07          	and    $0x7,%r15d
  8c5756:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c575c:	77 2f                	ja     8c578d <check_lower_drain+0x1ced>
  8c575e:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c5764:	73 27                	jae    8c578d <check_lower_drain+0x1ced>
  8c5766:	c4 e2 81 f7 4c 24 38 	shlx   %r15,0x38(%rsp),%rcx
  8c576d:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c5774:	48 f7 d1             	not    %rcx
  8c5777:	75 40                	jne    8c57b9 <check_lower_drain+0x1d19>
  8c5779:	be 01 00 00 00       	mov    $0x1,%esi
  8c577e:	ba 08 00 00 00       	mov    $0x8,%edx
  8c5783:	48 89 df             	mov    %rbx,%rdi
  8c5786:	e8 d5 bb 01 00       	call   8e1360 <check_lower_emit_tracked>
  8c578b:	eb 5c                	jmp    8c57e9 <check_lower_drain+0x1d49>
  8c578d:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c5791:	48 8b 00             	mov    (%rax),%rax
  8c5794:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c579b:	75 4c                	jne    8c57e9 <check_lower_drain+0x1d49>
  8c579d:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c57a4:	00 00 00 
  8c57a7:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c57ad:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c57b1:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c57b7:	eb 30                	jmp    8c57e9 <check_lower_drain+0x1d49>
  8c57b9:	48 8d 53 08          	lea    0x8(%rbx),%rdx
  8c57bd:	48 8b 12             	mov    (%rdx),%rdx
  8c57c0:	83 ba f0 00 00 00 00 	cmpl   $0x0,0xf0(%rdx)
  8c57c7:	75 20                	jne    8c57e9 <check_lower_drain+0x1d49>
  8c57c9:	48 8b 53 20          	mov    0x20(%rbx),%rdx
  8c57cd:	c6 04 02 01          	movb   $0x1,(%rdx,%rax,1)
  8c57d1:	48 8b 53 28          	mov    0x28(%rbx),%rdx
  8c57d5:	c6 04 02 08          	movb   $0x8,(%rdx,%rax,1)
  8c57d9:	48 8b 53 30          	mov    0x30(%rbx),%rdx
  8c57dd:	48 89 0c c2          	mov    %rcx,(%rdx,%rax,8)
  8c57e1:	ff c0                	inc    %eax
  8c57e3:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c57e9:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c57ef:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c57f5:	77 27                	ja     8c581e <check_lower_drain+0x1d7e>
  8c57f7:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c57fd:	73 1f                	jae    8c581e <check_lower_drain+0x1d7e>
  8c57ff:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c5806:	75 42                	jne    8c584a <check_lower_drain+0x1daa>
  8c5808:	be 10 00 00 00       	mov    $0x10,%esi
  8c580d:	ba 08 00 00 00       	mov    $0x8,%edx
  8c5812:	48 89 df             	mov    %rbx,%rdi
  8c5815:	31 c9                	xor    %ecx,%ecx
  8c5817:	e8 44 bb 01 00       	call   8e1360 <check_lower_emit_tracked>
  8c581c:	eb 60                	jmp    8c587e <check_lower_drain+0x1dde>
  8c581e:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c5822:	48 8b 00             	mov    (%rax),%rax
  8c5825:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c582c:	75 50                	jne    8c587e <check_lower_drain+0x1dde>
  8c582e:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c5835:	00 00 00 
  8c5838:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c583e:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c5842:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c5848:	eb 34                	jmp    8c587e <check_lower_drain+0x1dde>
  8c584a:	48 8d 4b 08          	lea    0x8(%rbx),%rcx
  8c584e:	48 8b 09             	mov    (%rcx),%rcx
  8c5851:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c5858:	75 24                	jne    8c587e <check_lower_drain+0x1dde>
  8c585a:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c585e:	c6 04 01 10          	movb   $0x10,(%rcx,%rax,1)
  8c5862:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c5866:	c6 04 01 08          	movb   $0x8,(%rcx,%rax,1)
  8c586a:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c586e:	48 c7 04 c1 00 00 00 	movq   $0x0,(%rcx,%rax,8)
  8c5875:	00 
  8c5876:	ff c0                	inc    %eax
  8c5878:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c587e:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c5884:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c588a:	77 2a                	ja     8c58b6 <check_lower_drain+0x1e16>
  8c588c:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c5892:	73 22                	jae    8c58b6 <check_lower_drain+0x1e16>
  8c5894:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c589b:	75 45                	jne    8c58e2 <check_lower_drain+0x1e42>
  8c589d:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
  8c58a2:	be 02 00 00 00       	mov    $0x2,%esi
  8c58a7:	ba 08 00 00 00       	mov    $0x8,%edx
  8c58ac:	48 89 df             	mov    %rbx,%rdi
  8c58af:	e8 ac ba 01 00       	call   8e1360 <check_lower_emit_tracked>
  8c58b4:	eb 61                	jmp    8c5917 <check_lower_drain+0x1e77>
  8c58b6:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c58ba:	48 8b 00             	mov    (%rax),%rax
  8c58bd:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c58c4:	75 51                	jne    8c5917 <check_lower_drain+0x1e77>
  8c58c6:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c58cd:	00 00 00 
  8c58d0:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c58d6:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c58da:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c58e0:	eb 35                	jmp    8c5917 <check_lower_drain+0x1e77>
  8c58e2:	48 8d 4b 08          	lea    0x8(%rbx),%rcx
  8c58e6:	48 8b 09             	mov    (%rcx),%rcx
  8c58e9:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c58f0:	75 25                	jne    8c5917 <check_lower_drain+0x1e77>
  8c58f2:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c58f6:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
  8c58fb:	c6 04 01 02          	movb   $0x2,(%rcx,%rax,1)
  8c58ff:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c5903:	c6 04 01 08          	movb   $0x8,(%rcx,%rax,1)
  8c5907:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c590b:	48 89 14 c1          	mov    %rdx,(%rcx,%rax,8)
  8c590f:	ff c0                	inc    %eax
  8c5911:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c5917:	45 85 ed             	test   %r13d,%r13d
  8c591a:	4c 8d 6b 08          	lea    0x8(%rbx),%r13
  8c591e:	0f 84 1b 01 00 00    	je     8c5a3f <check_lower_drain+0x1f9f>
  8c5924:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c592a:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c5930:	77 28                	ja     8c595a <check_lower_drain+0x1eba>
  8c5932:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c5938:	73 20                	jae    8c595a <check_lower_drain+0x1eba>
  8c593a:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c5941:	75 40                	jne    8c5983 <check_lower_drain+0x1ee3>
  8c5943:	be 01 00 00 00       	mov    $0x1,%esi
  8c5948:	ba 08 00 00 00       	mov    $0x8,%edx
  8c594d:	48 89 df             	mov    %rbx,%rdi
  8c5950:	4c 89 f9             	mov    %r15,%rcx
  8c5953:	e8 08 ba 01 00       	call   8e1360 <check_lower_emit_tracked>
  8c5958:	eb 56                	jmp    8c59b0 <check_lower_drain+0x1f10>
  8c595a:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c595e:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5965:	75 49                	jne    8c59b0 <check_lower_drain+0x1f10>
  8c5967:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c596e:	00 00 00 
  8c5971:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c5977:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c597b:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c5981:	eb 2d                	jmp    8c59b0 <check_lower_drain+0x1f10>
  8c5983:	49 8b 4d 00          	mov    0x0(%r13),%rcx
  8c5987:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c598e:	75 20                	jne    8c59b0 <check_lower_drain+0x1f10>
  8c5990:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c5994:	c6 04 01 01          	movb   $0x1,(%rcx,%rax,1)
  8c5998:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c599c:	c6 04 01 08          	movb   $0x8,(%rcx,%rax,1)
  8c59a0:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c59a4:	4c 89 3c c1          	mov    %r15,(%rcx,%rax,8)
  8c59a8:	ff c0                	inc    %eax
  8c59aa:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c59b0:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c59b6:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c59bc:	77 27                	ja     8c59e5 <check_lower_drain+0x1f45>
  8c59be:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c59c4:	73 1f                	jae    8c59e5 <check_lower_drain+0x1f45>
  8c59c6:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c59cd:	75 3f                	jne    8c5a0e <check_lower_drain+0x1f6e>
  8c59cf:	be 13 00 00 00       	mov    $0x13,%esi
  8c59d4:	ba 08 00 00 00       	mov    $0x8,%edx
  8c59d9:	48 89 df             	mov    %rbx,%rdi
  8c59dc:	31 c9                	xor    %ecx,%ecx
  8c59de:	e8 7d b9 01 00       	call   8e1360 <check_lower_emit_tracked>
  8c59e3:	eb 5a                	jmp    8c5a3f <check_lower_drain+0x1f9f>
  8c59e5:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c59e9:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c59f0:	75 4d                	jne    8c5a3f <check_lower_drain+0x1f9f>
  8c59f2:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c59f9:	00 00 00 
  8c59fc:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c5a02:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c5a06:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c5a0c:	eb 31                	jmp    8c5a3f <check_lower_drain+0x1f9f>
  8c5a0e:	49 8b 4d 00          	mov    0x0(%r13),%rcx
  8c5a12:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c5a19:	75 24                	jne    8c5a3f <check_lower_drain+0x1f9f>
  8c5a1b:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c5a1f:	c6 04 01 13          	movb   $0x13,(%rcx,%rax,1)
  8c5a23:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c5a27:	c6 04 01 08          	movb   $0x8,(%rcx,%rax,1)
  8c5a2b:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c5a2f:	48 c7 04 c1 00 00 00 	movq   $0x0,(%rcx,%rax,8)
  8c5a36:	00 
  8c5a37:	ff c0                	inc    %eax
  8c5a39:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c5a3f:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c5a45:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c5a4b:	77 27                	ja     8c5a74 <check_lower_drain+0x1fd4>
  8c5a4d:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c5a53:	73 1f                	jae    8c5a74 <check_lower_drain+0x1fd4>
  8c5a55:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c5a5c:	75 3f                	jne    8c5a9d <check_lower_drain+0x1ffd>
  8c5a5e:	be 11 00 00 00       	mov    $0x11,%esi
  8c5a63:	ba 08 00 00 00       	mov    $0x8,%edx
  8c5a68:	48 89 df             	mov    %rbx,%rdi
  8c5a6b:	31 c9                	xor    %ecx,%ecx
  8c5a6d:	e8 ee b8 01 00       	call   8e1360 <check_lower_emit_tracked>
  8c5a72:	eb 5a                	jmp    8c5ace <check_lower_drain+0x202e>
  8c5a74:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c5a78:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5a7f:	75 4d                	jne    8c5ace <check_lower_drain+0x202e>
  8c5a81:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c5a88:	00 00 00 
  8c5a8b:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c5a91:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c5a95:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c5a9b:	eb 31                	jmp    8c5ace <check_lower_drain+0x202e>
  8c5a9d:	49 8b 4d 00          	mov    0x0(%r13),%rcx
  8c5aa1:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c5aa8:	75 24                	jne    8c5ace <check_lower_drain+0x202e>
  8c5aaa:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c5aae:	c6 04 01 11          	movb   $0x11,(%rcx,%rax,1)
  8c5ab2:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c5ab6:	c6 04 01 08          	movb   $0x8,(%rcx,%rax,1)
  8c5aba:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c5abe:	48 c7 04 c1 00 00 00 	movq   $0x0,(%rcx,%rax,8)
  8c5ac5:	00 
  8c5ac6:	ff c0                	inc    %eax
  8c5ac8:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c5ace:	83 fd 01             	cmp    $0x1,%ebp
  8c5ad1:	77 29                	ja     8c5afc <check_lower_drain+0x205c>
  8c5ad3:	41 83 fe 02          	cmp    $0x2,%r14d
  8c5ad7:	0f 84 36 01 00 00    	je     8c5c13 <check_lower_drain+0x2173>
  8c5add:	41 83 fe 04          	cmp    $0x4,%r14d
  8c5ae1:	0f 84 27 01 00 00    	je     8c5c0e <check_lower_drain+0x216e>
  8c5ae7:	40 b5 08             	mov    $0x8,%bpl
  8c5aea:	41 83 fe 08          	cmp    $0x8,%r14d
  8c5aee:	0f 84 6f 0b 00 00    	je     8c6663 <check_lower_drain+0x2bc3>
  8c5af4:	40 b5 02             	mov    $0x2,%bpl
  8c5af7:	e9 1a 01 00 00       	jmp    8c5c16 <check_lower_drain+0x2176>
  8c5afc:	44 8b bb 48 01 00 00 	mov    0x148(%rbx),%r15d
  8c5b03:	49 81 ff ff ff 00 00 	cmp    $0xffff,%r15
  8c5b0a:	77 77                	ja     8c5b83 <check_lower_drain+0x20e3>
  8c5b0c:	44 3b bb 4c 01 00 00 	cmp    0x14c(%rbx),%r15d
  8c5b13:	73 6e                	jae    8c5b83 <check_lower_drain+0x20e3>
  8c5b15:	48 8b 83 c0 00 00 00 	mov    0xc0(%rbx),%rax
  8c5b1c:	42 c6 04 38 08       	movb   $0x8,(%rax,%r15,1)
  8c5b21:	48 8b 83 c8 00 00 00 	mov    0xc8(%rbx),%rax
  8c5b28:	42 c6 04 38 00       	movb   $0x0,(%rax,%r15,1)
  8c5b2d:	48 8b 83 d8 00 00 00 	mov    0xd8(%rbx),%rax
  8c5b34:	42 c7 04 b8 00 00 00 	movl   $0x0,(%rax,%r15,4)
  8c5b3b:	00 
  8c5b3c:	48 8b 83 e0 00 00 00 	mov    0xe0(%rbx),%rax
  8c5b43:	42 c6 04 38 00       	movb   $0x0,(%rax,%r15,1)
  8c5b48:	48 8b 83 b0 00 00 00 	mov    0xb0(%rbx),%rax
  8c5b4f:	42 c6 04 38 00       	movb   $0x0,(%rax,%r15,1)
  8c5b54:	ff 83 48 01 00 00    	incl   0x148(%rbx)
  8c5b5a:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c5b5e:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5b65:	75 3a                	jne    8c5ba1 <check_lower_drain+0x2101>
  8c5b67:	48 8b 83 d0 00 00 00 	mov    0xd0(%rbx),%rax
  8c5b6e:	42 c6 04 38 08       	movb   $0x8,(%rax,%r15,1)
  8c5b73:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c5b79:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c5b7f:	76 2e                	jbe    8c5baf <check_lower_drain+0x210f>
  8c5b81:	eb 5b                	jmp    8c5bde <check_lower_drain+0x213e>
  8c5b83:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c5b87:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5b8e:	0f 84 6e 0a 00 00    	je     8c6602 <check_lower_drain+0x2b62>
  8c5b94:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c5b98:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5b9f:	74 c6                	je     8c5b67 <check_lower_drain+0x20c7>
  8c5ba1:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c5ba7:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c5bad:	77 2f                	ja     8c5bde <check_lower_drain+0x213e>
  8c5baf:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c5bb5:	73 27                	jae    8c5bde <check_lower_drain+0x213e>
  8c5bb7:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c5bbe:	0f 85 bd 00 00 00    	jne    8c5c81 <check_lower_drain+0x21e1>
  8c5bc4:	be 1f 00 00 00       	mov    $0x1f,%esi
  8c5bc9:	ba 08 00 00 00       	mov    $0x8,%edx
  8c5bce:	48 89 df             	mov    %rbx,%rdi
  8c5bd1:	4c 89 f9             	mov    %r15,%rcx
  8c5bd4:	e8 87 b7 01 00       	call   8e1360 <check_lower_emit_tracked>
  8c5bd9:	e9 d0 00 00 00       	jmp    8c5cae <check_lower_drain+0x220e>
  8c5bde:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c5be2:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5be9:	0f 85 bf 00 00 00    	jne    8c5cae <check_lower_drain+0x220e>
  8c5bef:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c5bf6:	00 00 00 
  8c5bf9:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c5bff:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c5c03:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c5c09:	e9 a0 00 00 00       	jmp    8c5cae <check_lower_drain+0x220e>
  8c5c0e:	40 b5 06             	mov    $0x6,%bpl
  8c5c11:	eb 03                	jmp    8c5c16 <check_lower_drain+0x2176>
  8c5c13:	40 b5 04             	mov    $0x4,%bpl
  8c5c16:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c5c1c:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c5c22:	77 2d                	ja     8c5c51 <check_lower_drain+0x21b1>
  8c5c24:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c5c2a:	73 25                	jae    8c5c51 <check_lower_drain+0x21b1>
  8c5c2c:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c5c33:	0f 85 f9 09 00 00    	jne    8c6632 <check_lower_drain+0x2b92>
  8c5c39:	40 0f b6 d5          	movzbl %bpl,%edx
  8c5c3d:	be 09 00 00 00       	mov    $0x9,%esi
  8c5c42:	48 89 df             	mov    %rbx,%rdi
  8c5c45:	31 c9                	xor    %ecx,%ecx
  8c5c47:	e8 14 b7 01 00       	call   8e1360 <check_lower_emit_tracked>
  8c5c4c:	e9 12 0a 00 00       	jmp    8c6663 <check_lower_drain+0x2bc3>
  8c5c51:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c5c55:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5c5c:	0f 85 01 0a 00 00    	jne    8c6663 <check_lower_drain+0x2bc3>
  8c5c62:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c5c69:	00 00 00 
  8c5c6c:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c5c72:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c5c76:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c5c7c:	e9 e2 09 00 00       	jmp    8c6663 <check_lower_drain+0x2bc3>
  8c5c81:	49 8b 4d 00          	mov    0x0(%r13),%rcx
  8c5c85:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c5c8c:	75 20                	jne    8c5cae <check_lower_drain+0x220e>
  8c5c8e:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c5c92:	c6 04 01 1f          	movb   $0x1f,(%rcx,%rax,1)
  8c5c96:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c5c9a:	c6 04 01 08          	movb   $0x8,(%rcx,%rax,1)
  8c5c9e:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c5ca2:	4c 89 3c c1          	mov    %r15,(%rcx,%rax,8)
  8c5ca6:	ff c0                	inc    %eax
  8c5ca8:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c5cae:	4c 89 7c 24 38       	mov    %r15,0x38(%rsp)
  8c5cb3:	45 31 ff             	xor    %r15d,%r15d
  8c5cb6:	eb 23                	jmp    8c5cdb <check_lower_drain+0x223b>
  8c5cb8:	41 0f b6 d5          	movzbl %r13b,%edx
  8c5cbc:	be 1d 00 00 00       	mov    $0x1d,%esi
  8c5cc1:	48 89 df             	mov    %rbx,%rdi
  8c5cc4:	31 c9                	xor    %ecx,%ecx
  8c5cc6:	e8 95 b6 01 00       	call   8e1360 <check_lower_emit_tracked>
  8c5ccb:	41 01 ef             	add    %ebp,%r15d
  8c5cce:	4c 8d 6b 08          	lea    0x8(%rbx),%r13
  8c5cd2:	45 39 f7             	cmp    %r14d,%r15d
  8c5cd5:	0f 83 16 0a 00 00    	jae    8c66f1 <check_lower_drain+0x2c51>
  8c5cdb:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c5cdf:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5ce6:	0f 85 05 0a 00 00    	jne    8c66f1 <check_lower_drain+0x2c51>
  8c5cec:	44 89 f1             	mov    %r14d,%ecx
  8c5cef:	44 29 f9             	sub    %r15d,%ecx
  8c5cf2:	83 f9 07             	cmp    $0x7,%ecx
  8c5cf5:	76 19                	jbe    8c5d10 <check_lower_drain+0x2270>
  8c5cf7:	41 b5 08             	mov    $0x8,%r13b
  8c5cfa:	bd 08 00 00 00       	mov    $0x8,%ebp
  8c5cff:	8b 8b 38 01 00 00    	mov    0x138(%rbx),%ecx
  8c5d05:	48 81 f9 ff ff ff 00 	cmp    $0xffffff,%rcx
  8c5d0c:	76 44                	jbe    8c5d52 <check_lower_drain+0x22b2>
  8c5d0e:	eb 70                	jmp    8c5d80 <check_lower_drain+0x22e0>
  8c5d10:	83 f9 03             	cmp    $0x3,%ecx
  8c5d13:	76 19                	jbe    8c5d2e <check_lower_drain+0x228e>
  8c5d15:	41 b5 06             	mov    $0x6,%r13b
  8c5d18:	bd 04 00 00 00       	mov    $0x4,%ebp
  8c5d1d:	8b 8b 38 01 00 00    	mov    0x138(%rbx),%ecx
  8c5d23:	48 81 f9 ff ff ff 00 	cmp    $0xffffff,%rcx
  8c5d2a:	76 26                	jbe    8c5d52 <check_lower_drain+0x22b2>
  8c5d2c:	eb 52                	jmp    8c5d80 <check_lower_drain+0x22e0>
  8c5d2e:	45 31 ed             	xor    %r13d,%r13d
  8c5d31:	83 f9 02             	cmp    $0x2,%ecx
  8c5d34:	41 0f 93 c5          	setae  %r13b
  8c5d38:	41 8d 6d 01          	lea    0x1(%r13),%ebp
  8c5d3c:	45 00 ed             	add    %r13b,%r13b
  8c5d3f:	41 80 c5 02          	add    $0x2,%r13b
  8c5d43:	8b 8b 38 01 00 00    	mov    0x138(%rbx),%ecx
  8c5d49:	48 81 f9 ff ff ff 00 	cmp    $0xffffff,%rcx
  8c5d50:	77 2e                	ja     8c5d80 <check_lower_drain+0x22e0>
  8c5d52:	3b 8b 40 01 00 00    	cmp    0x140(%rbx),%ecx
  8c5d58:	73 26                	jae    8c5d80 <check_lower_drain+0x22e0>
  8c5d5a:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c5d61:	75 39                	jne    8c5d9c <check_lower_drain+0x22fc>
  8c5d63:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  8c5d68:	be 02 00 00 00       	mov    $0x2,%esi
  8c5d6d:	ba 08 00 00 00       	mov    $0x8,%edx
  8c5d72:	48 89 df             	mov    %rbx,%rdi
  8c5d75:	e8 e6 b5 01 00       	call   8e1360 <check_lower_emit_tracked>
  8c5d7a:	eb 45                	jmp    8c5dc1 <check_lower_drain+0x2321>
  8c5d7c:	0f 1f 40 00          	nopl   0x0(%rax)
  8c5d80:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c5d87:	00 00 00 
  8c5d8a:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c5d90:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c5d94:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c5d9a:	eb 25                	jmp    8c5dc1 <check_lower_drain+0x2321>
  8c5d9c:	48 8b 43 20          	mov    0x20(%rbx),%rax
  8c5da0:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
  8c5da5:	c6 04 08 02          	movb   $0x2,(%rax,%rcx,1)
  8c5da9:	48 8b 43 28          	mov    0x28(%rbx),%rax
  8c5dad:	c6 04 08 08          	movb   $0x8,(%rax,%rcx,1)
  8c5db1:	48 8b 43 30          	mov    0x30(%rbx),%rax
  8c5db5:	48 89 14 c8          	mov    %rdx,(%rax,%rcx,8)
  8c5db9:	ff c1                	inc    %ecx
  8c5dbb:	89 8b 38 01 00 00    	mov    %ecx,0x138(%rbx)
  8c5dc1:	44 89 fe             	mov    %r15d,%esi
  8c5dc4:	48 89 df             	mov    %rbx,%rdi
  8c5dc7:	e8 64 93 00 00       	call   8cf130 <check_lower_offset>
  8c5dcc:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c5dd2:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c5dd8:	77 36                	ja     8c5e10 <check_lower_drain+0x2370>
  8c5dda:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c5de0:	73 2e                	jae    8c5e10 <check_lower_drain+0x2370>
  8c5de2:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c5de9:	75 51                	jne    8c5e3c <check_lower_drain+0x239c>
  8c5deb:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  8c5df0:	be 02 00 00 00       	mov    $0x2,%esi
  8c5df5:	ba 08 00 00 00       	mov    $0x8,%edx
  8c5dfa:	48 89 df             	mov    %rbx,%rdi
  8c5dfd:	e8 5e b5 01 00       	call   8e1360 <check_lower_emit_tracked>
  8c5e02:	eb 7c                	jmp    8c5e80 <check_lower_drain+0x23e0>
  8c5e04:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  8c5e0b:	00 00 00 00 00 
  8c5e10:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c5e14:	48 8b 00             	mov    (%rax),%rax
  8c5e17:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5e1e:	75 60                	jne    8c5e80 <check_lower_drain+0x23e0>
  8c5e20:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c5e27:	00 00 00 
  8c5e2a:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c5e30:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c5e34:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c5e3a:	eb 44                	jmp    8c5e80 <check_lower_drain+0x23e0>
  8c5e3c:	48 8d 4b 08          	lea    0x8(%rbx),%rcx
  8c5e40:	48 8b 09             	mov    (%rcx),%rcx
  8c5e43:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c5e4a:	75 34                	jne    8c5e80 <check_lower_drain+0x23e0>
  8c5e4c:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c5e50:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  8c5e55:	c6 04 01 02          	movb   $0x2,(%rcx,%rax,1)
  8c5e59:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c5e5d:	c6 04 01 08          	movb   $0x8,(%rcx,%rax,1)
  8c5e61:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c5e65:	48 89 14 c1          	mov    %rdx,(%rcx,%rax,8)
  8c5e69:	ff c0                	inc    %eax
  8c5e6b:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c5e71:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  8c5e78:	0f 1f 84 00 00 00 00 
  8c5e7f:	00 
  8c5e80:	45 85 ff             	test   %r15d,%r15d
  8c5e83:	0f 84 37 01 00 00    	je     8c5fc0 <check_lower_drain+0x2520>
  8c5e89:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c5e8f:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c5e95:	77 2d                	ja     8c5ec4 <check_lower_drain+0x2424>
  8c5e97:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c5e9d:	73 25                	jae    8c5ec4 <check_lower_drain+0x2424>
  8c5e9f:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c5ea6:	42 8d 0c fd 00 00 00 	lea    0x0(,%r15,8),%ecx
  8c5ead:	00 
  8c5eae:	75 40                	jne    8c5ef0 <check_lower_drain+0x2450>
  8c5eb0:	be 01 00 00 00       	mov    $0x1,%esi
  8c5eb5:	ba 08 00 00 00       	mov    $0x8,%edx
  8c5eba:	48 89 df             	mov    %rbx,%rdi
  8c5ebd:	e8 9e b4 01 00       	call   8e1360 <check_lower_emit_tracked>
  8c5ec2:	eb 5c                	jmp    8c5f20 <check_lower_drain+0x2480>
  8c5ec4:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c5ec8:	48 8b 00             	mov    (%rax),%rax
  8c5ecb:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5ed2:	75 4c                	jne    8c5f20 <check_lower_drain+0x2480>
  8c5ed4:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c5edb:	00 00 00 
  8c5ede:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c5ee4:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c5ee8:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c5eee:	eb 30                	jmp    8c5f20 <check_lower_drain+0x2480>
  8c5ef0:	48 8d 53 08          	lea    0x8(%rbx),%rdx
  8c5ef4:	48 8b 12             	mov    (%rdx),%rdx
  8c5ef7:	83 ba f0 00 00 00 00 	cmpl   $0x0,0xf0(%rdx)
  8c5efe:	75 20                	jne    8c5f20 <check_lower_drain+0x2480>
  8c5f00:	48 8b 53 20          	mov    0x20(%rbx),%rdx
  8c5f04:	c6 04 02 01          	movb   $0x1,(%rdx,%rax,1)
  8c5f08:	48 8b 53 28          	mov    0x28(%rbx),%rdx
  8c5f0c:	c6 04 02 08          	movb   $0x8,(%rdx,%rax,1)
  8c5f10:	48 8b 53 30          	mov    0x30(%rbx),%rdx
  8c5f14:	48 89 0c c2          	mov    %rcx,(%rdx,%rax,8)
  8c5f18:	ff c0                	inc    %eax
  8c5f1a:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c5f20:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c5f26:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c5f2c:	77 27                	ja     8c5f55 <check_lower_drain+0x24b5>
  8c5f2e:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c5f34:	73 1f                	jae    8c5f55 <check_lower_drain+0x24b5>
  8c5f36:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c5f3d:	75 42                	jne    8c5f81 <check_lower_drain+0x24e1>
  8c5f3f:	be 14 00 00 00       	mov    $0x14,%esi
  8c5f44:	ba 08 00 00 00       	mov    $0x8,%edx
  8c5f49:	48 89 df             	mov    %rbx,%rdi
  8c5f4c:	31 c9                	xor    %ecx,%ecx
  8c5f4e:	e8 0d b4 01 00       	call   8e1360 <check_lower_emit_tracked>
  8c5f53:	eb 6b                	jmp    8c5fc0 <check_lower_drain+0x2520>
  8c5f55:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c5f59:	48 8b 00             	mov    (%rax),%rax
  8c5f5c:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c5f63:	75 5b                	jne    8c5fc0 <check_lower_drain+0x2520>
  8c5f65:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c5f6c:	00 00 00 
  8c5f6f:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c5f75:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c5f79:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c5f7f:	eb 3f                	jmp    8c5fc0 <check_lower_drain+0x2520>
  8c5f81:	48 8d 4b 08          	lea    0x8(%rbx),%rcx
  8c5f85:	48 8b 09             	mov    (%rcx),%rcx
  8c5f88:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c5f8f:	75 2f                	jne    8c5fc0 <check_lower_drain+0x2520>
  8c5f91:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c5f95:	c6 04 01 14          	movb   $0x14,(%rcx,%rax,1)
  8c5f99:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c5f9d:	c6 04 01 08          	movb   $0x8,(%rcx,%rax,1)
  8c5fa1:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c5fa5:	48 c7 04 c1 00 00 00 	movq   $0x0,(%rcx,%rax,8)
  8c5fac:	00 
  8c5fad:	ff c0                	inc    %eax
  8c5faf:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c5fb5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  8c5fbc:	00 00 00 00 
  8c5fc0:	41 80 fd 08          	cmp    $0x8,%r13b
  8c5fc4:	0f 84 96 00 00 00    	je     8c6060 <check_lower_drain+0x25c0>
  8c5fca:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c5fd0:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c5fd6:	77 26                	ja     8c5ffe <check_lower_drain+0x255e>
  8c5fd8:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c5fde:	73 1e                	jae    8c5ffe <check_lower_drain+0x255e>
  8c5fe0:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c5fe7:	75 41                	jne    8c602a <check_lower_drain+0x258a>
  8c5fe9:	41 0f b6 d5          	movzbl %r13b,%edx
  8c5fed:	be 09 00 00 00       	mov    $0x9,%esi
  8c5ff2:	48 89 df             	mov    %rbx,%rdi
  8c5ff5:	31 c9                	xor    %ecx,%ecx
  8c5ff7:	e8 64 b3 01 00       	call   8e1360 <check_lower_emit_tracked>
  8c5ffc:	eb 62                	jmp    8c6060 <check_lower_drain+0x25c0>
  8c5ffe:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c6002:	48 8b 00             	mov    (%rax),%rax
  8c6005:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c600c:	75 52                	jne    8c6060 <check_lower_drain+0x25c0>
  8c600e:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c6015:	00 00 00 
  8c6018:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c601e:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c6022:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c6028:	eb 36                	jmp    8c6060 <check_lower_drain+0x25c0>
  8c602a:	48 8d 4b 08          	lea    0x8(%rbx),%rcx
  8c602e:	48 8b 09             	mov    (%rcx),%rcx
  8c6031:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c6038:	75 26                	jne    8c6060 <check_lower_drain+0x25c0>
  8c603a:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c603e:	c6 04 01 09          	movb   $0x9,(%rcx,%rax,1)
  8c6042:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c6046:	44 88 2c 01          	mov    %r13b,(%rcx,%rax,1)
  8c604a:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c604e:	48 c7 04 c1 00 00 00 	movq   $0x0,(%rcx,%rax,8)
  8c6055:	00 
  8c6056:	ff c0                	inc    %eax
  8c6058:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c605e:	66 90                	xchg   %ax,%ax
  8c6060:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c6066:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c606c:	77 52                	ja     8c60c0 <check_lower_drain+0x2620>
  8c606e:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c6074:	73 4a                	jae    8c60c0 <check_lower_drain+0x2620>
  8c6076:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c607d:	0f 84 35 fc ff ff    	je     8c5cb8 <check_lower_drain+0x2218>
  8c6083:	48 8d 4b 08          	lea    0x8(%rbx),%rcx
  8c6087:	48 8b 09             	mov    (%rcx),%rcx
  8c608a:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c6091:	0f 85 34 fc ff ff    	jne    8c5ccb <check_lower_drain+0x222b>
  8c6097:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c609b:	c6 04 01 1d          	movb   $0x1d,(%rcx,%rax,1)
  8c609f:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c60a3:	44 88 2c 01          	mov    %r13b,(%rcx,%rax,1)
  8c60a7:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c60ab:	48 c7 04 c1 00 00 00 	movq   $0x0,(%rcx,%rax,8)
  8c60b2:	00 
  8c60b3:	ff c0                	inc    %eax
  8c60b5:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c60bb:	e9 0b fc ff ff       	jmp    8c5ccb <check_lower_drain+0x222b>
  8c60c0:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c60c4:	48 8b 00             	mov    (%rax),%rax
  8c60c7:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c60ce:	0f 85 f7 fb ff ff    	jne    8c5ccb <check_lower_drain+0x222b>
  8c60d4:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c60db:	00 00 00 
  8c60de:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c60e4:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c60e8:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c60ee:	e9 d8 fb ff ff       	jmp    8c5ccb <check_lower_drain+0x222b>
  8c60f3:	48 8b 93 98 01 00 00 	mov    0x198(%rbx),%rdx
  8c60fa:	44 0f b6 1c 0a       	movzbl (%rdx,%rcx,1),%r11d
  8c60ff:	c7 44 24 70 00 00 00 	movl   $0x0,0x70(%rsp)
  8c6106:	00 
  8c6107:	4c 8b 3e             	mov    (%rsi),%r15
  8c610a:	49 01 c6             	add    %rax,%r14
  8c610d:	48 8b 4e 10          	mov    0x10(%rsi),%rcx
  8c6111:	48 89 74 24 20       	mov    %rsi,0x20(%rsp)
  8c6116:	48 89 7c 24 30       	mov    %rdi,0x30(%rsp)
  8c611b:	49 8b 47 18          	mov    0x18(%r15),%rax
  8c611f:	49 8b 17             	mov    (%r15),%rdx
  8c6122:	49 8b 77 10          	mov    0x10(%r15),%rsi
  8c6126:	48 89 4c 24 58       	mov    %rcx,0x58(%rsp)
  8c612b:	8b 04 a8             	mov    (%rax,%rbp,4),%eax
  8c612e:	44 8b 14 aa          	mov    (%rdx,%rbp,4),%r10d
  8c6132:	48 8b 57 10          	mov    0x10(%rdi),%rdx
  8c6136:	44 8b 2c ae          	mov    (%rsi,%rbp,4),%r13d
  8c613a:	48 89 84 24 80 00 00 	mov    %rax,0x80(%rsp)
  8c6141:	00 
  8c6142:	48 89 e8             	mov    %rbp,%rax
  8c6145:	48 c1 e0 05          	shl    $0x5,%rax
  8c6149:	8b 34 02             	mov    (%rdx,%rax,1),%esi
  8c614c:	8b 4c 02 08          	mov    0x8(%rdx,%rax,1),%ecx
  8c6150:	49 8b 47 08          	mov    0x8(%r15),%rax
  8c6154:	8b 04 a8             	mov    (%rax,%rbp,4),%eax
  8c6157:	48 89 74 24 48       	mov    %rsi,0x48(%rsp)
  8c615c:	89 83 64 01 00 00    	mov    %eax,0x164(%rbx)
  8c6162:	41 8b 56 0c          	mov    0xc(%r14),%edx
  8c6166:	85 d2                	test   %edx,%edx
  8c6168:	74 0b                	je     8c6175 <check_lower_drain+0x26d5>
  8c616a:	41 83 7e 54 00       	cmpl   $0x0,0x54(%r14)
  8c616f:	0f 84 56 01 00 00    	je     8c62cb <check_lower_drain+0x282b>
  8c6175:	31 ff                	xor    %edi,%edi
  8c6177:	e9 5b 01 00 00       	jmp    8c62d7 <check_lower_drain+0x2837>
  8c617c:	48 b8 00 00 00 00 00 	movabs $0x50000000000,%rax
  8c6183:	05 00 00 
  8c6186:	49 85 c4             	test   %rax,%r12
  8c6189:	0f 85 64 e9 ff ff    	jne    8c4af3 <check_lower_drain+0x1053>
  8c618f:	48 83 bb a8 01 00 00 	cmpq   $0x0,0x1a8(%rbx)
  8c6196:	00 
  8c6197:	0f 84 56 e9 ff ff    	je     8c4af3 <check_lower_drain+0x1053>
  8c619d:	4c 8b 2b             	mov    (%rbx),%r13
  8c61a0:	45 89 e7             	mov    %r12d,%r15d
  8c61a3:	4d 8b 55 00          	mov    0x0(%r13),%r10
  8c61a7:	49 8b 02             	mov    (%r10),%rax
  8c61aa:	46 8b 34 b8          	mov    (%rax,%r15,4),%r14d
  8c61ae:	49 83 fe 3f          	cmp    $0x3f,%r14
  8c61b2:	0f 87 3b e9 ff ff    	ja     8c4af3 <check_lower_drain+0x1053>
  8c61b8:	48 8d 05 81 95 bf ff 	lea    -0x406a7f(%rip),%rax        # 4bf740 <check_lower_batch_ops>
  8c61bf:	41 0f b6 04 06       	movzbl (%r14,%rax,1),%eax
  8c61c4:	85 c0                	test   %eax,%eax
  8c61c6:	0f 84 27 e9 ff ff    	je     8c4af3 <check_lower_drain+0x1053>
  8c61cc:	3d fe 00 00 00       	cmp    $0xfe,%eax
  8c61d1:	0f 84 1c e9 ff ff    	je     8c4af3 <check_lower_drain+0x1053>
  8c61d7:	49 8b 45 08          	mov    0x8(%r13),%rax
  8c61db:	4b 8d 2c 7f          	lea    (%r15,%r15,2),%rbp
  8c61df:	48 c1 e5 05          	shl    $0x5,%rbp
  8c61e3:	48 03 68 08          	add    0x8(%rax),%rbp
  8c61e7:	83 7d 44 00          	cmpl   $0x0,0x44(%rbp)
  8c61eb:	0f 85 02 e9 ff ff    	jne    8c4af3 <check_lower_drain+0x1053>
  8c61f1:	83 7d 0c 00          	cmpl   $0x0,0xc(%rbp)
  8c61f5:	74 35                	je     8c622c <check_lower_drain+0x278c>
  8c61f7:	83 7d 54 00          	cmpl   $0x0,0x54(%rbp)
  8c61fb:	75 2f                	jne    8c622c <check_lower_drain+0x278c>
  8c61fd:	0f b7 45 08          	movzwl 0x8(%rbp),%eax
  8c6201:	a9 10 08 00 00       	test   $0x810,%eax
  8c6206:	75 24                	jne    8c622c <check_lower_drain+0x278c>
  8c6208:	83 7d 04 00          	cmpl   $0x0,0x4(%rbp)
  8c620c:	75 1e                	jne    8c622c <check_lower_drain+0x278c>
  8c620e:	41 83 fe 3e          	cmp    $0x3e,%r14d
  8c6212:	0f 87 db e8 ff ff    	ja     8c4af3 <check_lower_drain+0x1053>
  8c6218:	48 b8 00 00 00 00 08 	movabs $0x4080000800000000,%rax
  8c621f:	00 80 40 
  8c6222:	4c 0f a3 f0          	bt     %r14,%rax
  8c6226:	0f 83 c7 e8 ff ff    	jae    8c4af3 <check_lower_drain+0x1053>
  8c622c:	b8 04 02 00 00       	mov    $0x204,%eax
  8c6231:	48 8d 93 00 02 00 00 	lea    0x200(%rbx),%rdx
  8c6238:	4c 89 54 24 38       	mov    %r10,0x38(%rsp)
  8c623d:	c4 c2 78 f7 c4       	bextr  %eax,%r12d,%eax
  8c6242:	48 69 c8 d0 00 00 00 	imul   $0xd0,%rax,%rcx
  8c6249:	44 89 e0             	mov    %r12d,%eax
  8c624c:	2b 84 0a c8 00 00 00 	sub    0xc8(%rdx,%rcx,1),%eax
  8c6253:	48 8d 34 0a          	lea    (%rdx,%rcx,1),%rsi
  8c6257:	48 89 74 24 58       	mov    %rsi,0x58(%rsp)
  8c625c:	0f 92 c1             	setb   %cl
  8c625f:	83 f8 10             	cmp    $0x10,%eax
  8c6262:	f6 d1                	not    %cl
  8c6264:	0f 92 c2             	setb   %dl
  8c6267:	84 d1                	test   %dl,%cl
  8c6269:	75 21                	jne    8c628c <check_lower_drain+0x27ec>
  8c626b:	48 89 df             	mov    %rbx,%rdi
  8c626e:	44 89 e2             	mov    %r12d,%edx
  8c6271:	c5 f8 77             	vzeroupper
  8c6274:	e8 b7 31 01 00       	call   8d9430 <check_lower_batch_prepare>
  8c6279:	48 8b 74 24 58       	mov    0x58(%rsp),%rsi
  8c627e:	44 89 e0             	mov    %r12d,%eax
  8c6281:	4c 8b 54 24 38       	mov    0x38(%rsp),%r10
  8c6286:	2b 86 c8 00 00 00    	sub    0xc8(%rsi),%eax
  8c628c:	89 c0                	mov    %eax,%eax
  8c628e:	44 0f b7 1c 46       	movzwl (%rsi,%rax,2),%r11d
  8c6293:	0f b7 54 46 20       	movzwl 0x20(%rsi,%rax,2),%edx
  8c6298:	41 8d 4e fb          	lea    -0x5(%r14),%ecx
  8c629c:	c7 44 24 30 00 00 00 	movl   $0x0,0x30(%rsp)
  8c62a3:	00 
  8c62a4:	89 4c 24 20          	mov    %ecx,0x20(%rsp)
  8c62a8:	41 83 fe 23          	cmp    $0x23,%r14d
  8c62ac:	0f 8f 09 0e 00 00    	jg     8c70bb <check_lower_drain+0x361b>
  8c62b2:	41 83 fe 01          	cmp    $0x1,%r14d
  8c62b6:	0f 84 d5 0e 00 00    	je     8c7191 <check_lower_drain+0x36f1>
  8c62bc:	41 83 fe 18          	cmp    $0x18,%r14d
  8c62c0:	0f 84 cb 0e 00 00    	je     8c7191 <check_lower_drain+0x36f1>
  8c62c6:	e9 b7 0e 00 00       	jmp    8c7182 <check_lower_drain+0x36e2>
  8c62cb:	41 f7 46 08 10 08 00 	testl  $0x810,0x8(%r14)
  8c62d2:	00 
  8c62d3:	40 0f 94 c7          	sete   %dil
  8c62d7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8c62de:	01 00 00 
  8c62e1:	48 be 00 00 00 00 00 	movabs $0x40000000000,%rsi
  8c62e8:	04 00 00 
  8c62eb:	4d 89 e0             	mov    %r12,%r8
  8c62ee:	49 21 c0             	and    %rax,%r8
  8c62f1:	4c 89 e0             	mov    %r12,%rax
  8c62f4:	48 21 f0             	and    %rsi,%rax
  8c62f7:	4c 89 c6             	mov    %r8,%rsi
  8c62fa:	48 89 44 24 78       	mov    %rax,0x78(%rsp)
  8c62ff:	48 c1 ee 28          	shr    $0x28,%rsi
  8c6303:	48 b8 00 00 00 00 00 	movabs $0x20000000000,%rax
  8c630a:	02 00 00 
  8c630d:	4c 89 44 24 38       	mov    %r8,0x38(%rsp)
  8c6312:	49 85 c4             	test   %rax,%r12
  8c6315:	0f 85 1d 01 00 00    	jne    8c6438 <check_lower_drain+0x2998>
  8c631b:	45 85 d2             	test   %r10d,%r10d
  8c631e:	0f 85 14 01 00 00    	jne    8c6438 <check_lower_drain+0x2998>
  8c6324:	45 8b 46 40          	mov    0x40(%r14),%r8d
  8c6328:	45 85 c0             	test   %r8d,%r8d
  8c632b:	0f 84 24 01 00 00    	je     8c6455 <check_lower_drain+0x29b5>
  8c6331:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  8c6336:	44 3b 80 c0 00 00 00 	cmp    0xc0(%rax),%r8d
  8c633d:	0f 83 12 01 00 00    	jae    8c6455 <check_lower_drain+0x29b5>
  8c6343:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  8c6348:	41 ff c8             	dec    %r8d
  8c634b:	4c 8b 08             	mov    (%rax),%r9
  8c634e:	4c 89 e8             	mov    %r13,%rax
  8c6351:	4d 89 f5             	mov    %r14,%r13
  8c6354:	4d 89 de             	mov    %r11,%r14
  8c6357:	49 89 cb             	mov    %rcx,%r11
  8c635a:	4c 89 d1             	mov    %r10,%rcx
  8c635d:	4d 8b 91 90 02 00 00 	mov    0x290(%r9),%r10
  8c6364:	43 80 3c 02 00       	cmpb   $0x0,(%r10,%r8,1)
  8c6369:	49 89 ca             	mov    %rcx,%r10
  8c636c:	4c 89 d9             	mov    %r11,%rcx
  8c636f:	4d 89 f3             	mov    %r14,%r11
  8c6372:	4d 89 ee             	mov    %r13,%r14
  8c6375:	49 89 c5             	mov    %rax,%r13
  8c6378:	0f 84 d7 00 00 00    	je     8c6455 <check_lower_drain+0x29b5>
  8c637e:	4d 8b 89 78 02 00 00 	mov    0x278(%r9),%r9
  8c6385:	43 80 3c 01 00       	cmpb   $0x0,(%r9,%r8,1)
  8c638a:	0f 85 c5 00 00 00    	jne    8c6455 <check_lower_drain+0x29b5>
  8c6390:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  8c6395:	48 8b 48 28          	mov    0x28(%rax),%rcx
  8c6399:	48 85 c9             	test   %rcx,%rcx
  8c639c:	0f 84 7a 28 00 00    	je     8c8c1c <check_lower_drain+0x517c>
  8c63a2:	48 8b 49 10          	mov    0x10(%rcx),%rcx
  8c63a6:	46 8b 3c 81          	mov    (%rcx,%r8,4),%r15d
  8c63aa:	45 85 ff             	test   %r15d,%r15d
  8c63ad:	0f 84 69 28 00 00    	je     8c8c1c <check_lower_drain+0x517c>
  8c63b3:	48 8b 44 24 78       	mov    0x78(%rsp),%rax
  8c63b8:	48 8d 8c 24 d2 00 00 	lea    0xd2(%rsp),%rcx
  8c63bf:	00 
  8c63c0:	c7 84 24 c0 00 00 00 	movl   $0x0,0xc0(%rsp)
  8c63c7:	00 00 00 00 
  8c63cb:	44 89 a4 24 c4 00 00 	mov    %r12d,0xc4(%rsp)
  8c63d2:	00 
  8c63d3:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
  8c63d7:	48 89 df             	mov    %rbx,%rdi
  8c63da:	c5 f8 11 41 f6       	vmovups %xmm0,-0xa(%rcx)
  8c63df:	40 88 b4 24 d8 00 00 	mov    %sil,0xd8(%rsp)
  8c63e6:	00 
  8c63e7:	c6 84 24 d9 00 00 00 	movb   $0x1,0xd9(%rsp)
  8c63ee:	01 
  8c63ef:	48 c1 e8 2a          	shr    $0x2a,%rax
  8c63f3:	88 84 24 da 00 00 00 	mov    %al,0xda(%rsp)
  8c63fa:	c6 41 0d 00          	movb   $0x0,0xd(%rcx)
  8c63fe:	c7 41 09 00 00 00 00 	movl   $0x0,0x9(%rcx)
  8c6405:	c5 fe 6f 84 24 c0 00 	vmovdqu 0xc0(%rsp),%ymm0
  8c640c:	00 00 
  8c640e:	c5 fe 7f 04 24       	vmovdqu %ymm0,(%rsp)
  8c6413:	c5 f8 77             	vzeroupper
  8c6416:	e8 b5 6e 00 00       	call   8cd2d0 <check_lower_push>
  8c641b:	41 8b 76 40          	mov    0x40(%r14),%esi
  8c641f:	41 ff cf             	dec    %r15d
  8c6422:	48 89 df             	mov    %rbx,%rdi
  8c6425:	4c 89 fa             	mov    %r15,%rdx
  8c6428:	ff ce                	dec    %esi
  8c642a:	48 c1 e6 20          	shl    $0x20,%rsi
  8c642e:	e8 ed 32 00 00       	call   8c9720 <check_lower_initializer>
  8c6433:	e9 0e 28 00 00       	jmp    8c8c46 <check_lower_drain+0x51a6>
  8c6438:	41 83 fa 37          	cmp    $0x37,%r10d
  8c643c:	75 17                	jne    8c6455 <check_lower_drain+0x29b5>
  8c643e:	40 0f b6 d6          	movzbl %sil,%edx
  8c6442:	48 89 df             	mov    %rbx,%rdi
  8c6445:	44 89 e6             	mov    %r12d,%esi
  8c6448:	c5 f8 77             	vzeroupper
  8c644b:	e8 50 33 01 00       	call   8d97a0 <check_lower_region>
  8c6450:	e9 f1 27 00 00       	jmp    8c8c46 <check_lower_drain+0x51a6>
  8c6455:	40 84 ff             	test   %dil,%dil
  8c6458:	74 60                	je     8c64ba <check_lower_drain+0x2a1a>
  8c645a:	41 83 fa 23          	cmp    $0x23,%r10d
  8c645e:	0f 84 9f 00 00 00    	je     8c6503 <check_lower_drain+0x2a63>
  8c6464:	41 83 fa 3e          	cmp    $0x3e,%r10d
  8c6468:	0f 84 95 00 00 00    	je     8c6503 <check_lower_drain+0x2a63>
  8c646e:	48 83 7c 24 38 00    	cmpq   $0x0,0x38(%rsp)
  8c6474:	75 07                	jne    8c647d <check_lower_drain+0x29dd>
  8c6476:	41 83 7e 04 00       	cmpl   $0x0,0x4(%r14)
  8c647b:	74 1e                	je     8c649b <check_lower_drain+0x29fb>
  8c647d:	8b 44 24 54          	mov    0x54(%rsp),%eax
  8c6481:	48 83 7c 24 38 00    	cmpq   $0x0,0x38(%rsp)
  8c6487:	89 c7                	mov    %eax,%edi
  8c6489:	40 0f 94 c6          	sete   %sil
  8c648d:	40 80 f7 01          	xor    $0x1,%dil
  8c6491:	40 84 fe             	test   %dil,%sil
  8c6494:	75 24                	jne    8c64ba <check_lower_drain+0x2a1a>
  8c6496:	83 fa 03             	cmp    $0x3,%edx
  8c6499:	75 1f                	jne    8c64ba <check_lower_drain+0x2a1a>
  8c649b:	48 83 7c 24 78 00    	cmpq   $0x0,0x78(%rsp)
  8c64a1:	0f 85 9f 27 00 00    	jne    8c8c46 <check_lower_drain+0x51a6>
  8c64a7:	48 89 df             	mov    %rbx,%rdi
  8c64aa:	4c 89 f6             	mov    %r14,%rsi
  8c64ad:	c5 f8 77             	vzeroupper
  8c64b0:	e8 ab 7b 00 00       	call   8ce060 <check_lower_constant>
  8c64b5:	e9 8c 27 00 00       	jmp    8c8c46 <check_lower_drain+0x51a6>
  8c64ba:	41 83 fa 34          	cmp    $0x34,%r10d
  8c64be:	0f 84 9d 00 00 00    	je     8c6561 <check_lower_drain+0x2ac1>
  8c64c4:	45 85 d2             	test   %r10d,%r10d
  8c64c7:	75 3a                	jne    8c6503 <check_lower_drain+0x2a63>
  8c64c9:	41 83 3e 08          	cmpl   $0x8,(%r14)
  8c64cd:	0f 84 73 27 00 00    	je     8c8c46 <check_lower_drain+0x51a6>
  8c64d3:	48 83 7c 24 38 00    	cmpq   $0x0,0x38(%rsp)
  8c64d9:	8b 4c 24 54          	mov    0x54(%rsp),%ecx
  8c64dd:	41 8b 76 40          	mov    0x40(%r14),%esi
  8c64e1:	0f 94 c0             	sete   %al
  8c64e4:	80 f1 01             	xor    $0x1,%cl
  8c64e7:	84 c8                	test   %cl,%al
  8c64e9:	0f 85 bd 08 00 00    	jne    8c6dac <check_lower_drain+0x330c>
  8c64ef:	49 8b 56 48          	mov    0x48(%r14),%rdx
  8c64f3:	48 89 df             	mov    %rbx,%rdi
  8c64f6:	c5 f8 77             	vzeroupper
  8c64f9:	e8 b2 88 00 00       	call   8cedb0 <check_lower_address>
  8c64fe:	e9 43 27 00 00       	jmp    8c8c46 <check_lower_drain+0x51a6>
  8c6503:	44 89 d2             	mov    %r10d,%edx
  8c6506:	83 e2 fe             	and    $0xfffffffe,%edx
  8c6509:	83 fa 40             	cmp    $0x40,%edx
  8c650c:	0f 85 9c 02 00 00    	jne    8c67ae <check_lower_drain+0x2d0e>
  8c6512:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  8c6517:	48 8b 6c 24 58       	mov    0x58(%rsp),%rbp
  8c651c:	4f 8d 74 6d 00       	lea    0x0(%r13,%r13,2),%r14
  8c6521:	49 c1 e6 05          	shl    $0x5,%r14
  8c6525:	48 8b 40 08          	mov    0x8(%rax),%rax
  8c6529:	48 8b 4d 00          	mov    0x0(%rbp),%rcx
  8c652d:	46 8b 3c 30          	mov    (%rax,%r14,1),%r15d
  8c6531:	41 c1 ef 03          	shr    $0x3,%r15d
  8c6535:	42 80 3c 39 0f       	cmpb   $0xf,(%rcx,%r15,1)
  8c653a:	4c 89 fa             	mov    %r15,%rdx
  8c653d:	75 0b                	jne    8c654a <check_lower_drain+0x2aaa>
  8c653f:	48 8b 55 20          	mov    0x20(%rbp),%rdx
  8c6543:	42 8b 14 ba          	mov    (%rdx,%r15,4),%edx
  8c6547:	c1 ea 03             	shr    $0x3,%edx
  8c654a:	0f b6 0c 11          	movzbl (%rcx,%rdx,1),%ecx
  8c654e:	80 f9 06             	cmp    $0x6,%cl
  8c6551:	0f 84 b0 06 00 00    	je     8c6c07 <check_lower_drain+0x3167>
  8c6557:	41 83 fa 40          	cmp    $0x40,%r10d
  8c655b:	0f 85 a6 06 00 00    	jne    8c6c07 <check_lower_drain+0x3167>
  8c6561:	31 c9                	xor    %ecx,%ecx
  8c6563:	48 83 7c 24 38 00    	cmpq   $0x0,0x38(%rsp)
  8c6569:	0f 95 c1             	setne  %cl
  8c656c:	48 89 df             	mov    %rbx,%rdi
  8c656f:	44 89 e6             	mov    %r12d,%esi
  8c6572:	31 d2                	xor    %edx,%edx
  8c6574:	45 31 c0             	xor    %r8d,%r8d
  8c6577:	c5 f8 77             	vzeroupper
  8c657a:	e8 d1 2f 01 00       	call   8d9550 <check_lower_operand>
  8c657f:	e9 c2 26 00 00       	jmp    8c8c46 <check_lower_drain+0x51a6>
  8c6584:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c658b:	0f 85 27 d6 ff ff    	jne    8c3bb8 <check_lower_drain+0x118>
  8c6591:	48 8b 43 20          	mov    0x20(%rbx),%rax
  8c6595:	c6 04 08 09          	movb   $0x9,(%rax,%rcx,1)
  8c6599:	48 8b 43 28          	mov    0x28(%rbx),%rax
  8c659d:	44 88 34 08          	mov    %r14b,(%rax,%rcx,1)
  8c65a1:	e9 d3 e5 ff ff       	jmp    8c4b79 <check_lower_drain+0x10d9>
  8c65a6:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c65ad:	75 24                	jne    8c65d3 <check_lower_drain+0x2b33>
  8c65af:	48 8b 43 20          	mov    0x20(%rbx),%rax
  8c65b3:	c6 04 08 23          	movb   $0x23,(%rax,%rcx,1)
  8c65b7:	48 8b 43 28          	mov    0x28(%rbx),%rax
  8c65bb:	c6 04 08 08          	movb   $0x8,(%rax,%rcx,1)
  8c65bf:	48 8b 43 30          	mov    0x30(%rbx),%rax
  8c65c3:	48 c7 04 c8 00 00 00 	movq   $0x0,(%rax,%rcx,8)
  8c65ca:	00 
  8c65cb:	ff c1                	inc    %ecx
  8c65cd:	89 8b 38 01 00 00    	mov    %ecx,0x138(%rbx)
  8c65d3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8c65da:	01 00 00 
  8c65dd:	49 85 c4             	test   %rax,%r12
  8c65e0:	0f 85 d2 d5 ff ff    	jne    8c3bb8 <check_lower_drain+0x118>
  8c65e6:	be 23 00 00 00       	mov    $0x23,%esi
  8c65eb:	ba 08 00 00 00       	mov    $0x8,%edx
  8c65f0:	48 89 df             	mov    %rbx,%rdi
  8c65f3:	31 c9                	xor    %ecx,%ecx
  8c65f5:	c5 f8 77             	vzeroupper
  8c65f8:	e8 d3 29 00 00       	call   8c8fd0 <check_lower_emit>
  8c65fd:	e9 b6 d5 ff ff       	jmp    8c3bb8 <check_lower_drain+0x118>
  8c6602:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c6609:	00 00 00 
  8c660c:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c6612:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c6616:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c661c:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c6620:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c6627:	0f 85 74 f5 ff ff    	jne    8c5ba1 <check_lower_drain+0x2101>
  8c662d:	e9 35 f5 ff ff       	jmp    8c5b67 <check_lower_drain+0x20c7>
  8c6632:	49 8b 4d 00          	mov    0x0(%r13),%rcx
  8c6636:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c663d:	75 24                	jne    8c6663 <check_lower_drain+0x2bc3>
  8c663f:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c6643:	c6 04 01 09          	movb   $0x9,(%rcx,%rax,1)
  8c6647:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c664b:	40 88 2c 01          	mov    %bpl,(%rcx,%rax,1)
  8c664f:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c6653:	48 c7 04 c1 00 00 00 	movq   $0x0,(%rcx,%rax,8)
  8c665a:	00 
  8c665b:	ff c0                	inc    %eax
  8c665d:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c6663:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c6669:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c666f:	77 26                	ja     8c6697 <check_lower_drain+0x2bf7>
  8c6671:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c6677:	73 1e                	jae    8c6697 <check_lower_drain+0x2bf7>
  8c6679:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c6680:	75 3e                	jne    8c66c0 <check_lower_drain+0x2c20>
  8c6682:	40 0f b6 d5          	movzbl %bpl,%edx
  8c6686:	be 1d 00 00 00       	mov    $0x1d,%esi
  8c668b:	48 89 df             	mov    %rbx,%rdi
  8c668e:	31 c9                	xor    %ecx,%ecx
  8c6690:	e8 cb ac 01 00       	call   8e1360 <check_lower_emit_tracked>
  8c6695:	eb 5a                	jmp    8c66f1 <check_lower_drain+0x2c51>
  8c6697:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c669b:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c66a2:	75 4d                	jne    8c66f1 <check_lower_drain+0x2c51>
  8c66a4:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c66ab:	00 00 00 
  8c66ae:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c66b4:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c66b8:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c66be:	eb 31                	jmp    8c66f1 <check_lower_drain+0x2c51>
  8c66c0:	49 8b 4d 00          	mov    0x0(%r13),%rcx
  8c66c4:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c66cb:	75 24                	jne    8c66f1 <check_lower_drain+0x2c51>
  8c66cd:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c66d1:	c6 04 01 1d          	movb   $0x1d,(%rcx,%rax,1)
  8c66d5:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c66d9:	40 88 2c 01          	mov    %bpl,(%rcx,%rax,1)
  8c66dd:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c66e1:	48 c7 04 c1 00 00 00 	movq   $0x0,(%rcx,%rax,8)
  8c66e8:	00 
  8c66e9:	ff c0                	inc    %eax
  8c66eb:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c66f1:	48 b8 00 00 00 00 00 	movabs $0x40000000000,%rax
  8c66f8:	04 00 00 
  8c66fb:	49 85 c4             	test   %rax,%r12
  8c66fe:	0f 85 b4 d4 ff ff    	jne    8c3bb8 <check_lower_drain+0x118>
  8c6704:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c670a:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c6710:	77 2a                	ja     8c673c <check_lower_drain+0x2c9c>
  8c6712:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c6718:	73 22                	jae    8c673c <check_lower_drain+0x2c9c>
  8c671a:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c6721:	75 42                	jne    8c6765 <check_lower_drain+0x2cc5>
  8c6723:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
  8c6728:	be 02 00 00 00       	mov    $0x2,%esi
  8c672d:	ba 08 00 00 00       	mov    $0x8,%edx
  8c6732:	48 89 df             	mov    %rbx,%rdi
  8c6735:	e8 26 ac 01 00       	call   8e1360 <check_lower_emit_tracked>
  8c673a:	eb 5b                	jmp    8c6797 <check_lower_drain+0x2cf7>
  8c673c:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c6740:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c6747:	75 4e                	jne    8c6797 <check_lower_drain+0x2cf7>
  8c6749:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c6750:	00 00 00 
  8c6753:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c6759:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c675d:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c6763:	eb 32                	jmp    8c6797 <check_lower_drain+0x2cf7>
  8c6765:	49 8b 4d 00          	mov    0x0(%r13),%rcx
  8c6769:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c6770:	75 25                	jne    8c6797 <check_lower_drain+0x2cf7>
  8c6772:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c6776:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
  8c677b:	c6 04 01 02          	movb   $0x2,(%rcx,%rax,1)
  8c677f:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c6783:	c6 04 01 08          	movb   $0x8,(%rcx,%rax,1)
  8c6787:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c678b:	48 89 14 c1          	mov    %rdx,(%rcx,%rax,8)
  8c678f:	ff c0                	inc    %eax
  8c6791:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c6797:	48 8d b4 24 c0 00 00 	lea    0xc0(%rsp),%rsi
  8c679e:	00 
  8c679f:	48 89 df             	mov    %rbx,%rdi
  8c67a2:	31 d2                	xor    %edx,%edx
  8c67a4:	e8 b7 1c 01 00       	call   8d8460 <check_lower_bit_extract>
  8c67a9:	e9 0a d4 ff ff       	jmp    8c3bb8 <check_lower_drain+0x118>
  8c67ae:	41 8d 72 c7          	lea    -0x39(%r10),%esi
  8c67b2:	83 fe 01             	cmp    $0x1,%esi
  8c67b5:	0f 87 6f 04 00 00    	ja     8c6c2a <check_lower_drain+0x318a>
  8c67bb:	49 8b 47 38          	mov    0x38(%r15),%rax
  8c67bf:	44 8b 34 a8          	mov    (%rax,%rbp,4),%r14d
  8c67c3:	45 85 f6             	test   %r14d,%r14d
  8c67c6:	0f 84 50 24 00 00    	je     8c8c1c <check_lower_drain+0x517c>
  8c67cc:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  8c67d1:	48 8b 00             	mov    (%rax),%rax
  8c67d4:	44 3b b0 58 03 00 00 	cmp    0x358(%rax),%r14d
  8c67db:	0f 87 3b 24 00 00    	ja     8c8c1c <check_lower_drain+0x517c>
  8c67e1:	48 8b 80 50 03 00 00 	mov    0x350(%rax),%rax
  8c67e8:	48 8b 93 80 01 00 00 	mov    0x180(%rbx),%rdx
  8c67ef:	41 ff ce             	dec    %r14d
  8c67f2:	4b 8d 0c f6          	lea    (%r14,%r14,8),%rcx
  8c67f6:	8b 44 88 14          	mov    0x14(%rax,%rcx,4),%eax
  8c67fa:	3b 42 04             	cmp    0x4(%rdx),%eax
  8c67fd:	0f 85 19 24 00 00    	jne    8c8c1c <check_lower_drain+0x517c>
  8c6803:	48 8b 83 98 00 00 00 	mov    0x98(%rbx),%rax
  8c680a:	42 8b 04 b0          	mov    (%rax,%r14,4),%eax
  8c680e:	83 f8 ff             	cmp    $0xffffffff,%eax
  8c6811:	75 2c                	jne    8c683f <check_lower_drain+0x2d9f>
  8c6813:	be 08 00 00 00       	mov    $0x8,%esi
  8c6818:	48 89 df             	mov    %rbx,%rdi
  8c681b:	4d 89 d7             	mov    %r10,%r15
  8c681e:	c5 f8 77             	vzeroupper
  8c6821:	e8 ca 7d ff ff       	call   8be5f0 <check_lower_temporary>
  8c6826:	48 8b 8b 98 00 00 00 	mov    0x98(%rbx),%rcx
  8c682d:	4d 89 fa             	mov    %r15,%r10
  8c6830:	42 89 04 b1          	mov    %eax,(%rcx,%r14,4)
  8c6834:	48 8b 83 98 00 00 00 	mov    0x98(%rbx),%rax
  8c683b:	42 8b 04 b0          	mov    (%rax,%r14,4),%eax
  8c683f:	41 83 fa 39          	cmp    $0x39,%r10d
  8c6843:	be 02 00 00 00       	mov    $0x2,%esi
  8c6848:	ba 1e 00 00 00       	mov    $0x1e,%edx
  8c684d:	89 c1                	mov    %eax,%ecx
  8c684f:	48 89 df             	mov    %rbx,%rdi
  8c6852:	4d 89 d6             	mov    %r10,%r14
  8c6855:	0f 44 f2             	cmove  %edx,%esi
  8c6858:	ba 08 00 00 00       	mov    $0x8,%edx
  8c685d:	c5 f8 77             	vzeroupper
  8c6860:	e8 bb 2c 00 00       	call   8c9520 <check_lower_instruction>
  8c6865:	41 83 fe 39          	cmp    $0x39,%r14d
  8c6869:	0f 84 c5 03 00 00    	je     8c6c34 <check_lower_drain+0x3194>
  8c686f:	e9 d2 23 00 00       	jmp    8c8c46 <check_lower_drain+0x51a6>
  8c6874:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c687b:	0f 85 37 d3 ff ff    	jne    8c3bb8 <check_lower_drain+0x118>
  8c6881:	48 8b 43 20          	mov    0x20(%rbx),%rax
  8c6885:	c6 04 08 29          	movb   $0x29,(%rax,%rcx,1)
  8c6889:	48 8b 43 28          	mov    0x28(%rbx),%rax
  8c688d:	c6 04 08 00          	movb   $0x0,(%rax,%rcx,1)
  8c6891:	48 8b 43 30          	mov    0x30(%rbx),%rax
  8c6895:	4c 89 3c c8          	mov    %r15,(%rax,%rcx,8)
  8c6899:	e9 e7 e2 ff ff       	jmp    8c4b85 <check_lower_drain+0x10e5>
  8c689e:	49 8b 4d 00          	mov    0x0(%r13),%rcx
  8c68a2:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c68a9:	75 20                	jne    8c68cb <check_lower_drain+0x2e2b>
  8c68ab:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c68af:	c6 04 01 1f          	movb   $0x1f,(%rcx,%rax,1)
  8c68b3:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c68b7:	c6 04 01 08          	movb   $0x8,(%rcx,%rax,1)
  8c68bb:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c68bf:	4c 89 34 c1          	mov    %r14,(%rcx,%rax,8)
  8c68c3:	ff c0                	inc    %eax
  8c68c5:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c68cb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8c68d2:	01 00 00 
  8c68d5:	4c 89 74 24 20       	mov    %r14,0x20(%rsp)
  8c68da:	49 85 c4             	test   %rax,%r12
  8c68dd:	74 18                	je     8c68f7 <check_lower_drain+0x2e57>
  8c68df:	be 1e 00 00 00       	mov    $0x1e,%esi
  8c68e4:	ba 08 00 00 00       	mov    $0x8,%edx
  8c68e9:	48 89 df             	mov    %rbx,%rdi
  8c68ec:	48 89 e9             	mov    %rbp,%rcx
  8c68ef:	c5 f8 77             	vzeroupper
  8c68f2:	e8 d9 26 00 00       	call   8c8fd0 <check_lower_emit>
  8c68f7:	48 89 6c 24 38       	mov    %rbp,0x38(%rsp)
  8c68fc:	4d 89 fd             	mov    %r15,%r13
  8c68ff:	31 ed                	xor    %ebp,%ebp
  8c6901:	eb 29                	jmp    8c692c <check_lower_drain+0x2e8c>
  8c6903:	be 29 00 00 00       	mov    $0x29,%esi
  8c6908:	48 89 df             	mov    %rbx,%rdi
  8c690b:	31 d2                	xor    %edx,%edx
  8c690d:	4c 89 f1             	mov    %r14,%rcx
  8c6910:	e8 4b aa 01 00       	call   8e1360 <check_lower_emit_tracked>
  8c6915:	48 81 c5 00 01 00 00 	add    $0x100,%rbp
  8c691c:	49 81 c5 00 ff ff ff 	add    $0xffffffffffffff00,%r13
  8c6923:	4c 39 fd             	cmp    %r15,%rbp
  8c6926:	0f 83 fe 01 00 00    	jae    8c6b2a <check_lower_drain+0x308a>
  8c692c:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c6930:	49 81 fd 00 01 00 00 	cmp    $0x100,%r13
  8c6937:	b9 00 01 00 00       	mov    $0x100,%ecx
  8c693c:	48 8b 00             	mov    (%rax),%rax
  8c693f:	49 0f 42 cd          	cmovb  %r13,%rcx
  8c6943:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c694a:	0f 85 da 01 00 00    	jne    8c6b2a <check_lower_drain+0x308a>
  8c6950:	49 81 fd 00 01 00 00 	cmp    $0x100,%r13
  8c6957:	41 be 00 01 00 00    	mov    $0x100,%r14d
  8c695d:	4d 0f 42 f5          	cmovb  %r13,%r14
  8c6961:	4c 39 e9             	cmp    %r13,%rcx
  8c6964:	74 7a                	je     8c69e0 <check_lower_drain+0x2f40>
  8c6966:	8b 8b 38 01 00 00    	mov    0x138(%rbx),%ecx
  8c696c:	48 81 f9 ff ff ff 00 	cmp    $0xffffff,%rcx
  8c6973:	77 2a                	ja     8c699f <check_lower_drain+0x2eff>
  8c6975:	3b 8b 40 01 00 00    	cmp    0x140(%rbx),%ecx
  8c697b:	73 22                	jae    8c699f <check_lower_drain+0x2eff>
  8c697d:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c6984:	75 35                	jne    8c69bb <check_lower_drain+0x2f1b>
  8c6986:	be 06 00 00 00       	mov    $0x6,%esi
  8c698b:	ba 08 00 00 00       	mov    $0x8,%edx
  8c6990:	48 89 df             	mov    %rbx,%rdi
  8c6993:	31 c9                	xor    %ecx,%ecx
  8c6995:	c5 f8 77             	vzeroupper
  8c6998:	e8 c3 a9 01 00       	call   8e1360 <check_lower_emit_tracked>
  8c699d:	eb 41                	jmp    8c69e0 <check_lower_drain+0x2f40>
  8c699f:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c69a6:	00 00 00 
  8c69a9:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c69af:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c69b3:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c69b9:	eb 25                	jmp    8c69e0 <check_lower_drain+0x2f40>
  8c69bb:	48 8b 43 20          	mov    0x20(%rbx),%rax
  8c69bf:	c6 04 08 06          	movb   $0x6,(%rax,%rcx,1)
  8c69c3:	48 8b 43 28          	mov    0x28(%rbx),%rax
  8c69c7:	c6 04 08 08          	movb   $0x8,(%rax,%rcx,1)
  8c69cb:	48 8b 43 30          	mov    0x30(%rbx),%rax
  8c69cf:	48 c7 04 c8 00 00 00 	movq   $0x0,(%rax,%rcx,8)
  8c69d6:	00 
  8c69d7:	ff c1                	inc    %ecx
  8c69d9:	89 8b 38 01 00 00    	mov    %ecx,0x138(%rbx)
  8c69df:	90                   	nop
  8c69e0:	48 89 df             	mov    %rbx,%rdi
  8c69e3:	48 89 ee             	mov    %rbp,%rsi
  8c69e6:	c5 f8 77             	vzeroupper
  8c69e9:	e8 42 87 00 00       	call   8cf130 <check_lower_offset>
  8c69ee:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c69f4:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c69fa:	77 2a                	ja     8c6a26 <check_lower_drain+0x2f86>
  8c69fc:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c6a02:	73 22                	jae    8c6a26 <check_lower_drain+0x2f86>
  8c6a04:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c6a0b:	75 45                	jne    8c6a52 <check_lower_drain+0x2fb2>
  8c6a0d:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  8c6a12:	be 02 00 00 00       	mov    $0x2,%esi
  8c6a17:	ba 08 00 00 00       	mov    $0x8,%edx
  8c6a1c:	48 89 df             	mov    %rbx,%rdi
  8c6a1f:	e8 3c a9 01 00       	call   8e1360 <check_lower_emit_tracked>
  8c6a24:	eb 6a                	jmp    8c6a90 <check_lower_drain+0x2ff0>
  8c6a26:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c6a2a:	48 8b 00             	mov    (%rax),%rax
  8c6a2d:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c6a34:	75 5a                	jne    8c6a90 <check_lower_drain+0x2ff0>
  8c6a36:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c6a3d:	00 00 00 
  8c6a40:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c6a46:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c6a4a:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c6a50:	eb 3e                	jmp    8c6a90 <check_lower_drain+0x2ff0>
  8c6a52:	48 8d 4b 08          	lea    0x8(%rbx),%rcx
  8c6a56:	48 8b 09             	mov    (%rcx),%rcx
  8c6a59:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c6a60:	75 2e                	jne    8c6a90 <check_lower_drain+0x2ff0>
  8c6a62:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c6a66:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
  8c6a6b:	c6 04 01 02          	movb   $0x2,(%rcx,%rax,1)
  8c6a6f:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c6a73:	c6 04 01 08          	movb   $0x8,(%rcx,%rax,1)
  8c6a77:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c6a7b:	48 89 14 c1          	mov    %rdx,(%rcx,%rax,8)
  8c6a7f:	ff c0                	inc    %eax
  8c6a81:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c6a87:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  8c6a8e:	00 00 
  8c6a90:	48 89 df             	mov    %rbx,%rdi
  8c6a93:	48 89 ee             	mov    %rbp,%rsi
  8c6a96:	e8 95 86 00 00       	call   8cf130 <check_lower_offset>
  8c6a9b:	8b 83 38 01 00 00    	mov    0x138(%rbx),%eax
  8c6aa1:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8c6aa7:	77 4e                	ja     8c6af7 <check_lower_drain+0x3057>
  8c6aa9:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c6aaf:	73 46                	jae    8c6af7 <check_lower_drain+0x3057>
  8c6ab1:	80 bb f9 01 00 00 01 	cmpb   $0x1,0x1f9(%rbx)
  8c6ab8:	0f 84 45 fe ff ff    	je     8c6903 <check_lower_drain+0x2e63>
  8c6abe:	48 8d 4b 08          	lea    0x8(%rbx),%rcx
  8c6ac2:	48 8b 09             	mov    (%rcx),%rcx
  8c6ac5:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c6acc:	0f 85 43 fe ff ff    	jne    8c6915 <check_lower_drain+0x2e75>
  8c6ad2:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8c6ad6:	c6 04 01 29          	movb   $0x29,(%rcx,%rax,1)
  8c6ada:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8c6ade:	c6 04 01 00          	movb   $0x0,(%rcx,%rax,1)
  8c6ae2:	48 8b 4b 30          	mov    0x30(%rbx),%rcx
  8c6ae6:	4c 89 34 c1          	mov    %r14,(%rcx,%rax,8)
  8c6aea:	ff c0                	inc    %eax
  8c6aec:	89 83 38 01 00 00    	mov    %eax,0x138(%rbx)
  8c6af2:	e9 1e fe ff ff       	jmp    8c6915 <check_lower_drain+0x2e75>
  8c6af7:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c6afb:	48 8b 00             	mov    (%rax),%rax
  8c6afe:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c6b05:	0f 85 0a fe ff ff    	jne    8c6915 <check_lower_drain+0x2e75>
  8c6b0b:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c6b12:	00 00 00 
  8c6b15:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c6b1b:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c6b1f:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c6b25:	e9 eb fd ff ff       	jmp    8c6915 <check_lower_drain+0x2e75>
  8c6b2a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8c6b31:	01 00 00 
  8c6b34:	4c 8d 6b 08          	lea    0x8(%rbx),%r13
  8c6b38:	49 85 c4             	test   %rax,%r12
  8c6b3b:	0f 84 77 d0 ff ff    	je     8c3bb8 <check_lower_drain+0x118>
  8c6b41:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  8c6b46:	be 02 00 00 00       	mov    $0x2,%esi
  8c6b4b:	ba 08 00 00 00       	mov    $0x8,%edx
  8c6b50:	48 89 df             	mov    %rbx,%rdi
  8c6b53:	c5 f8 77             	vzeroupper
  8c6b56:	e8 75 24 00 00       	call   8c8fd0 <check_lower_emit>
  8c6b5b:	e9 58 d0 ff ff       	jmp    8c3bb8 <check_lower_drain+0x118>
  8c6b60:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c6b67:	00 00 00 
  8c6b6a:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c6b70:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c6b74:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c6b7a:	49 8b 45 00          	mov    0x0(%r13),%rax
  8c6b7e:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c6b85:	0f 85 a9 e5 ff ff    	jne    8c5134 <check_lower_drain+0x1694>
  8c6b8b:	e9 c3 d7 ff ff       	jmp    8c4353 <check_lower_drain+0x8b3>
  8c6b90:	48 8b 77 08          	mov    0x8(%rdi),%rsi
  8c6b94:	48 8d 0c 40          	lea    (%rax,%rax,2),%rcx
  8c6b98:	48 c1 e1 05          	shl    $0x5,%rcx
  8c6b9c:	48 03 4e 08          	add    0x8(%rsi),%rcx
  8c6ba0:	8b 71 40             	mov    0x40(%rcx),%esi
  8c6ba3:	48 85 f6             	test   %rsi,%rsi
  8c6ba6:	0f 84 63 01 00 00    	je     8c6d0f <check_lower_drain+0x326f>
  8c6bac:	44 8b 9f c0 00 00 00 	mov    0xc0(%rdi),%r11d
  8c6bb3:	49 be 00 00 00 00 00 	movabs $0x20000000000,%r14
  8c6bba:	02 00 00 
  8c6bbd:	44 39 de             	cmp    %r11d,%esi
  8c6bc0:	41 0f 92 c0          	setb   %r8b
  8c6bc4:	45 31 d2             	xor    %r10d,%r10d
  8c6bc7:	4d 85 f4             	test   %r14,%r12
  8c6bca:	0f 85 45 01 00 00    	jne    8c6d15 <check_lower_drain+0x3275>
  8c6bd0:	44 39 de             	cmp    %r11d,%esi
  8c6bd3:	0f 83 3c 01 00 00    	jae    8c6d15 <check_lower_drain+0x3275>
  8c6bd9:	4c 8b 9a 90 02 00 00 	mov    0x290(%rdx),%r11
  8c6be0:	44 8d 56 ff          	lea    -0x1(%rsi),%r10d
  8c6be4:	41 b0 01             	mov    $0x1,%r8b
  8c6be7:	43 80 3c 13 00       	cmpb   $0x0,(%r11,%r10,1)
  8c6bec:	0f 84 20 01 00 00    	je     8c6d12 <check_lower_drain+0x3272>
  8c6bf2:	4c 8b 9a 78 02 00 00 	mov    0x278(%rdx),%r11
  8c6bf9:	43 80 3c 13 00       	cmpb   $0x0,(%r11,%r10,1)
  8c6bfe:	41 0f 94 c2          	sete   %r10b
  8c6c02:	e9 0e 01 00 00       	jmp    8c6d15 <check_lower_drain+0x3275>
  8c6c07:	80 f9 06             	cmp    $0x6,%cl
  8c6c0a:	74 5c                	je     8c6c68 <check_lower_drain+0x31c8>
  8c6c0c:	41 0f b6 d3          	movzbl %r11b,%edx
  8c6c10:	be 01 00 00 00       	mov    $0x1,%esi
  8c6c15:	48 89 df             	mov    %rbx,%rdi
  8c6c18:	31 c9                	xor    %ecx,%ecx
  8c6c1a:	c5 f8 77             	vzeroupper
  8c6c1d:	e8 fe 28 00 00       	call   8c9520 <check_lower_instruction>
  8c6c22:	41 b8 08 00 00 00    	mov    $0x8,%r8d
  8c6c28:	eb 10                	jmp    8c6c3a <check_lower_drain+0x319a>
  8c6c2a:	41 83 fa 3b          	cmp    $0x3b,%r10d
  8c6c2e:	0f 85 bb 00 00 00    	jne    8c6cef <check_lower_drain+0x324f>
  8c6c34:	41 b8 58 00 00 00    	mov    $0x58,%r8d
  8c6c3a:	48 89 df             	mov    %rbx,%rdi
  8c6c3d:	44 89 e6             	mov    %r12d,%esi
  8c6c40:	31 d2                	xor    %edx,%edx
  8c6c42:	31 c9                	xor    %ecx,%ecx
  8c6c44:	c5 f8 77             	vzeroupper
  8c6c47:	e8 04 29 01 00       	call   8d9550 <check_lower_operand>
  8c6c4c:	e9 f5 1f 00 00       	jmp    8c8c46 <check_lower_drain+0x51a6>
  8c6c51:	40 80 fe 0a          	cmp    $0xa,%sil
  8c6c55:	4c 8d 05 df 28 dc ff 	lea    -0x23d721(%rip),%r8        # 68953b <fuzz_comment_end+0x26c80>
  8c6c5c:	48 8d 0d f5 c0 d0 ff 	lea    -0x2f3f0b(%rip),%rcx        # 5d2d58 <parse_test_openers+0x6bc3>
  8c6c63:	e9 bb d4 ff ff       	jmp    8c4123 <check_lower_drain+0x683>
  8c6c68:	4c 01 f0             	add    %r14,%rax
  8c6c6b:	83 78 04 01          	cmpl   $0x1,0x4(%rax)
  8c6c6f:	0f 85 af 01 00 00    	jne    8c6e24 <check_lower_drain+0x3384>
  8c6c75:	48 83 7c 24 38 00    	cmpq   $0x0,0x38(%rsp)
  8c6c7b:	75 1c                	jne    8c6c99 <check_lower_drain+0x31f9>
  8c6c7d:	41 0f b6 d3          	movzbl %r11b,%edx
  8c6c81:	be 0a 00 00 00       	mov    $0xa,%esi
  8c6c86:	48 89 df             	mov    %rbx,%rdi
  8c6c89:	31 c9                	xor    %ecx,%ecx
  8c6c8b:	4d 89 d5             	mov    %r10,%r13
  8c6c8e:	c5 f8 77             	vzeroupper
  8c6c91:	e8 8a 28 00 00       	call   8c9520 <check_lower_instruction>
  8c6c96:	4d 89 ea             	mov    %r13,%r10
  8c6c99:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
  8c6c9e:	41 83 fa 41          	cmp    $0x41,%r10d
  8c6ca2:	0f 85 ff 03 00 00    	jne    8c70a7 <check_lower_drain+0x3607>
  8c6ca8:	8b 83 3c 01 00 00    	mov    0x13c(%rbx),%eax
  8c6cae:	48 8d 7b 08          	lea    0x8(%rbx),%rdi
  8c6cb2:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c6cb8:	0f 83 46 03 00 00    	jae    8c7004 <check_lower_drain+0x3564>
  8c6cbe:	48 8b 4b 18          	mov    0x18(%rbx),%rcx
  8c6cc2:	8d 50 01             	lea    0x1(%rax),%edx
  8c6cc5:	48 c1 e0 04          	shl    $0x4,%rax
  8c6cc9:	89 93 3c 01 00 00    	mov    %edx,0x13c(%rbx)
  8c6ccf:	48 ba 01 00 00 00 01 	movabs $0x8000100000001,%rdx
  8c6cd6:	00 08 00 
  8c6cd9:	48 83 c2 14          	add    $0x14,%rdx
  8c6cdd:	48 89 14 01          	mov    %rdx,(%rcx,%rax,1)
  8c6ce1:	48 c7 44 01 08 01 00 	movq   $0x1,0x8(%rcx,%rax,1)
  8c6ce8:	00 00 
  8c6cea:	e9 3b 03 00 00       	jmp    8c702a <check_lower_drain+0x358a>
  8c6cef:	41 8d 72 cb          	lea    -0x35(%r10),%esi
  8c6cf3:	83 fe 01             	cmp    $0x1,%esi
  8c6cf6:	0f 87 5e 01 00 00    	ja     8c6e5a <check_lower_drain+0x33ba>
  8c6cfc:	48 89 df             	mov    %rbx,%rdi
  8c6cff:	44 89 e6             	mov    %r12d,%esi
  8c6d02:	c5 f8 77             	vzeroupper
  8c6d05:	e8 36 34 01 00       	call   8da140 <check_lower_builtin_prepare>
  8c6d0a:	e9 37 1f 00 00       	jmp    8c8c46 <check_lower_drain+0x51a6>
  8c6d0f:	45 31 c0             	xor    %r8d,%r8d
  8c6d12:	45 31 d2             	xor    %r10d,%r10d
  8c6d15:	49 bb 00 00 00 00 00 	movabs $0x10000000000,%r11
  8c6d1c:	01 00 00 
  8c6d1f:	4d 85 dc             	test   %r11,%r12
  8c6d22:	75 32                	jne    8c6d56 <check_lower_drain+0x32b6>
  8c6d24:	44 8b 11             	mov    (%rcx),%r10d
  8c6d27:	41 b8 ff 00 00 00    	mov    $0xff,%r8d
  8c6d2d:	41 c1 ea 03          	shr    $0x3,%r10d
  8c6d31:	44 3b 93 b0 01 00 00 	cmp    0x1b0(%rbx),%r10d
  8c6d38:	73 04                	jae    8c6d3e <check_lower_drain+0x329e>
  8c6d3a:	47 8b 04 91          	mov    (%r9,%r10,4),%r8d
  8c6d3e:	48 85 f6             	test   %rsi,%rsi
  8c6d41:	0f 84 8e 01 00 00    	je     8c6ed5 <check_lower_drain+0x3435>
  8c6d47:	3b b7 c0 00 00 00    	cmp    0xc0(%rdi),%esi
  8c6d4d:	41 0f 92 c1          	setb   %r9b
  8c6d51:	e9 82 01 00 00       	jmp    8c6ed8 <check_lower_drain+0x3438>
  8c6d56:	83 79 04 01          	cmpl   $0x1,0x4(%rcx)
  8c6d5a:	0f 85 86 dd ff ff    	jne    8c4ae6 <check_lower_drain+0x1046>
  8c6d60:	83 39 08             	cmpl   $0x8,(%rcx)
  8c6d63:	0f 84 7d dd ff ff    	je     8c4ae6 <check_lower_drain+0x1046>
  8c6d69:	83 79 44 00          	cmpl   $0x0,0x44(%rcx)
  8c6d6d:	41 f6 d0             	not    %r8b
  8c6d70:	40 0f 95 c7          	setne  %dil
  8c6d74:	45 08 d0             	or     %r10b,%r8b
  8c6d77:	41 08 f8             	or     %dil,%r8b
  8c6d7a:	41 f6 c0 01          	test   $0x1,%r8b
  8c6d7e:	0f 85 62 dd ff ff    	jne    8c4ae6 <check_lower_drain+0x1046>
  8c6d84:	48 8b 52 08          	mov    0x8(%rdx),%rdx
  8c6d88:	48 89 df             	mov    %rbx,%rdi
  8c6d8b:	8b 04 82             	mov    (%rdx,%rax,4),%eax
  8c6d8e:	89 83 64 01 00 00    	mov    %eax,0x164(%rbx)
  8c6d94:	48 8b 51 48          	mov    0x48(%rcx),%rdx
  8c6d98:	c5 f8 77             	vzeroupper
  8c6d9b:	e8 10 80 00 00       	call   8cedb0 <check_lower_address>
  8c6da0:	48 ff 83 40 05 00 00 	incq   0x540(%rbx)
  8c6da7:	e9 9a 1e 00 00       	jmp    8c8c46 <check_lower_drain+0x51a6>
  8c6dac:	41 83 7e 04 01       	cmpl   $0x1,0x4(%r14)
  8c6db1:	48 8d 53 08          	lea    0x8(%rbx),%rdx
  8c6db5:	0f 94 c0             	sete   %al
  8c6db8:	85 f6                	test   %esi,%esi
  8c6dba:	0f 95 c1             	setne  %cl
  8c6dbd:	20 c1                	and    %al,%cl
  8c6dbf:	80 f9 01             	cmp    $0x1,%cl
  8c6dc2:	0f 85 cc 00 00 00    	jne    8c6e94 <check_lower_drain+0x33f4>
  8c6dc8:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  8c6dcd:	8b 80 c0 00 00 00    	mov    0xc0(%rax),%eax
  8c6dd3:	39 c6                	cmp    %eax,%esi
  8c6dd5:	73 17                	jae    8c6dee <check_lower_drain+0x334e>
  8c6dd7:	41 8d 4b f5          	lea    -0xb(%r11),%ecx
  8c6ddb:	80 f9 02             	cmp    $0x2,%cl
  8c6dde:	77 0e                	ja     8c6dee <check_lower_drain+0x334e>
  8c6de0:	48 8b 4b 68          	mov    0x68(%rbx),%rcx
  8c6de4:	83 3c b1 ff          	cmpl   $0xffffffff,(%rcx,%rsi,4)
  8c6de8:	0f 84 39 03 00 00    	je     8c7127 <check_lower_drain+0x3687>
  8c6dee:	39 c6                	cmp    %eax,%esi
  8c6df0:	0f 83 9e 00 00 00    	jae    8c6e94 <check_lower_drain+0x33f4>
  8c6df6:	48 8b 43 68          	mov    0x68(%rbx),%rax
  8c6dfa:	8b 0c b0             	mov    (%rax,%rsi,4),%ecx
  8c6dfd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8c6e02:	48 39 c1             	cmp    %rax,%rcx
  8c6e05:	0f 84 46 03 00 00    	je     8c7151 <check_lower_drain+0x36b1>
  8c6e0b:	41 0f b6 d3          	movzbl %r11b,%edx
  8c6e0f:	be 02 00 00 00       	mov    $0x2,%esi
  8c6e14:	48 89 df             	mov    %rbx,%rdi
  8c6e17:	c5 f8 77             	vzeroupper
  8c6e1a:	e8 b1 21 00 00       	call   8c8fd0 <check_lower_emit>
  8c6e1f:	e9 22 1e 00 00       	jmp    8c8c46 <check_lower_drain+0x51a6>
  8c6e24:	44 3b 7c 24 44       	cmp    0x44(%rsp),%r15d
  8c6e29:	73 12                	jae    8c6e3d <check_lower_drain+0x339d>
  8c6e2b:	48 8b 83 a0 01 00 00 	mov    0x1a0(%rbx),%rax
  8c6e32:	42 f6 04 38 02       	testb  $0x2,(%rax,%r15,1)
  8c6e37:	0f 85 38 fe ff ff    	jne    8c6c75 <check_lower_drain+0x31d5>
  8c6e3d:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c6e41:	48 8b 00             	mov    (%rax),%rax
  8c6e44:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c6e4b:	0f 85 f5 1d 00 00    	jne    8c8c46 <check_lower_drain+0x51a6>
  8c6e51:	48 8d 0d 66 b9 e2 ff 	lea    -0x1d469a(%rip),%rcx        # 6f27be <pp_string_value.meaning+0x3ef81>
  8c6e58:	eb 51                	jmp    8c6eab <check_lower_drain+0x340b>
  8c6e5a:	41 83 fa 3f          	cmp    $0x3f,%r10d
  8c6e5e:	74 21                	je     8c6e81 <check_lower_drain+0x33e1>
  8c6e60:	41 83 fa 3c          	cmp    $0x3c,%r10d
  8c6e64:	0f 85 6d 01 00 00    	jne    8c6fd7 <check_lower_drain+0x3537>
  8c6e6a:	49 8b 47 38          	mov    0x38(%r15),%rax
  8c6e6e:	b9 df fe ff ff       	mov    $0xfffffedf,%ecx
  8c6e73:	8b 04 a8             	mov    (%rax,%rbp,4),%eax
  8c6e76:	01 c8                	add    %ecx,%eax
  8c6e78:	83 f8 01             	cmp    $0x1,%eax
  8c6e7b:	0f 87 55 02 00 00    	ja     8c70d6 <check_lower_drain+0x3636>
  8c6e81:	48 89 df             	mov    %rbx,%rdi
  8c6e84:	44 89 e6             	mov    %r12d,%esi
  8c6e87:	c5 f8 77             	vzeroupper
  8c6e8a:	e8 11 3b 01 00       	call   8da9a0 <check_lower_helper>
  8c6e8f:	e9 b2 1d 00 00       	jmp    8c8c46 <check_lower_drain+0x51a6>
  8c6e94:	48 8b 02             	mov    (%rdx),%rax
  8c6e97:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c6e9e:	0f 85 a2 1d 00 00    	jne    8c8c46 <check_lower_drain+0x51a6>
  8c6ea4:	48 8d 0d fc d1 e7 ff 	lea    -0x182e04(%rip),%rcx        # 7440a7 <pp_decode_file_name.meaning+0xd13d>
  8c6eab:	48 89 88 00 01 00 00 	mov    %rcx,0x100(%rax)
  8c6eb2:	48 8d 4b 08          	lea    0x8(%rbx),%rcx
  8c6eb6:	48 8b 01             	mov    (%rcx),%rax
  8c6eb9:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c6ec0:	0f 85 80 1d 00 00    	jne    8c8c46 <check_lower_drain+0x51a6>
  8c6ec6:	c7 80 f0 00 00 00 02 	movl   $0x2,0xf0(%rax)
  8c6ecd:	00 00 00 
  8c6ed0:	e9 61 1d 00 00       	jmp    8c8c36 <check_lower_drain+0x5196>
  8c6ed5:	45 31 c9             	xor    %r9d,%r9d
  8c6ed8:	45 0f b6 d8          	movzbl %r8b,%r11d
  8c6edc:	45 8d 53 ff          	lea    -0x1(%r11),%r10d
  8c6ee0:	41 83 fa 0a          	cmp    $0xa,%r10d
  8c6ee4:	40 0f 93 c5          	setae  %bpl
  8c6ee8:	41 f7 c0 00 05 00 00 	test   $0x500,%r8d
  8c6eef:	41 0f 95 c6          	setne  %r14b
  8c6ef3:	41 08 ee             	or     %bpl,%r14b
  8c6ef6:	0f 85 ea db ff ff    	jne    8c4ae6 <check_lower_drain+0x1046>
  8c6efc:	83 79 44 00          	cmpl   $0x0,0x44(%rcx)
  8c6f00:	0f 85 e0 db ff ff    	jne    8c4ae6 <check_lower_drain+0x1046>
  8c6f06:	49 be 00 00 00 00 00 	movabs $0x20000000000,%r14
  8c6f0d:	02 00 00 
  8c6f10:	4d 85 f4             	test   %r14,%r12
  8c6f13:	40 0f 94 c5          	sete   %bpl
  8c6f17:	44 20 cd             	and    %r9b,%bpl
  8c6f1a:	40 80 fd 01          	cmp    $0x1,%bpl
  8c6f1e:	75 24                	jne    8c6f44 <check_lower_drain+0x34a4>
  8c6f20:	4c 8b ba 90 02 00 00 	mov    0x290(%rdx),%r15
  8c6f27:	44 8d 76 ff          	lea    -0x1(%rsi),%r14d
  8c6f2b:	43 80 3c 37 00       	cmpb   $0x0,(%r15,%r14,1)
  8c6f30:	74 12                	je     8c6f44 <check_lower_drain+0x34a4>
  8c6f32:	4c 8b ba 78 02 00 00 	mov    0x278(%rdx),%r15
  8c6f39:	43 80 3c 37 00       	cmpb   $0x0,(%r15,%r14,1)
  8c6f3e:	0f 84 a2 db ff ff    	je     8c4ae6 <check_lower_drain+0x1046>
  8c6f44:	8b 69 0c             	mov    0xc(%rcx),%ebp
  8c6f47:	85 ed                	test   %ebp,%ebp
  8c6f49:	74 1e                	je     8c6f69 <check_lower_drain+0x34c9>
  8c6f4b:	83 79 54 00          	cmpl   $0x0,0x54(%rcx)
  8c6f4f:	75 18                	jne    8c6f69 <check_lower_drain+0x34c9>
  8c6f51:	44 0f b7 71 08       	movzwl 0x8(%rcx),%r14d
  8c6f56:	41 f7 c6 10 08 00 00 	test   $0x810,%r14d
  8c6f5d:	75 0a                	jne    8c6f69 <check_lower_drain+0x34c9>
  8c6f5f:	83 79 04 00          	cmpl   $0x0,0x4(%rcx)
  8c6f63:	0f 84 08 07 00 00    	je     8c7671 <check_lower_drain+0x3bd1>
  8c6f69:	83 79 04 01          	cmpl   $0x1,0x4(%rcx)
  8c6f6d:	0f 94 c1             	sete   %cl
  8c6f70:	44 20 c9             	and    %r9b,%cl
  8c6f73:	80 f9 01             	cmp    $0x1,%cl
  8c6f76:	0f 85 6a db ff ff    	jne    8c4ae6 <check_lower_drain+0x1046>
  8c6f7c:	48 8b 4b 68          	mov    0x68(%rbx),%rcx
  8c6f80:	48 8b bf 80 00 00 00 	mov    0x80(%rdi),%rdi
  8c6f87:	8b 0c b1             	mov    (%rcx,%rsi,4),%ecx
  8c6f8a:	8b 34 b7             	mov    (%rdi,%rsi,4),%esi
  8c6f8d:	83 f9 ff             	cmp    $0xffffffff,%ecx
  8c6f90:	41 0f 94 c1          	sete   %r9b
  8c6f94:	45 00 c9             	add    %r9b,%r9b
  8c6f97:	41 80 c1 02          	add    $0x2,%r9b
  8c6f9b:	83 f9 ff             	cmp    $0xffffffff,%ecx
  8c6f9e:	0f 44 ce             	cmove  %esi,%ecx
  8c6fa1:	75 08                	jne    8c6fab <check_lower_drain+0x350b>
  8c6fa3:	85 f6                	test   %esi,%esi
  8c6fa5:	0f 84 3b db ff ff    	je     8c4ae6 <check_lower_drain+0x1046>
  8c6fab:	48 8b 52 08          	mov    0x8(%rdx),%rdx
  8c6faf:	41 0f b6 f1          	movzbl %r9b,%esi
  8c6fb3:	48 89 df             	mov    %rbx,%rdi
  8c6fb6:	8b 04 82             	mov    (%rdx,%rax,4),%eax
  8c6fb9:	41 0f b6 d0          	movzbl %r8b,%edx
  8c6fbd:	89 83 64 01 00 00    	mov    %eax,0x164(%rbx)
  8c6fc3:	c5 f8 77             	vzeroupper
  8c6fc6:	e8 05 20 00 00       	call   8c8fd0 <check_lower_emit>
  8c6fcb:	48 ff 83 40 05 00 00 	incq   0x540(%rbx)
  8c6fd2:	e9 6f 1c 00 00       	jmp    8c8c46 <check_lower_drain+0x51a6>
  8c6fd7:	41 8d 72 be          	lea    -0x42(%r10),%esi
  8c6fdb:	83 fe 02             	cmp    $0x2,%esi
  8c6fde:	0f 87 05 01 00 00    	ja     8c70e9 <check_lower_drain+0x3649>
  8c6fe4:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c6fe8:	48 8b 00             	mov    (%rax),%rax
  8c6feb:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c6ff2:	0f 85 4e 1c 00 00    	jne    8c8c46 <check_lower_drain+0x51a6>
  8c6ff8:	48 8d 0d 8f 6f da ff 	lea    -0x259071(%rip),%rcx        # 66df8e <fuzz_comment_end+0xb6d3>
  8c6fff:	e9 a7 fe ff ff       	jmp    8c6eab <check_lower_drain+0x340b>
  8c7004:	48 8b 07             	mov    (%rdi),%rax
  8c7007:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c700e:	75 1a                	jne    8c702a <check_lower_drain+0x358a>
  8c7010:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c7017:	00 00 00 
  8c701a:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c7020:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c7024:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c702a:	48 8b 55 20          	mov    0x20(%rbp),%rdx
  8c702e:	48 8b 75 00          	mov    0x0(%rbp),%rsi
  8c7032:	48 8b 4d 38          	mov    0x38(%rbp),%rcx
  8c7036:	42 8b 04 ba          	mov    (%rdx,%r15,4),%eax
  8c703a:	c1 e8 03             	shr    $0x3,%eax
  8c703d:	80 3c 06 0f          	cmpb   $0xf,(%rsi,%rax,1)
  8c7041:	75 06                	jne    8c7049 <check_lower_drain+0x35a9>
  8c7043:	8b 04 82             	mov    (%rdx,%rax,4),%eax
  8c7046:	c1 e8 03             	shr    $0x3,%eax
  8c7049:	8b 93 3c 01 00 00    	mov    0x13c(%rbx),%edx
  8c704f:	3b 93 40 01 00 00    	cmp    0x140(%rbx),%edx
  8c7055:	73 2a                	jae    8c7081 <check_lower_drain+0x35e1>
  8c7057:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  8c705b:	48 8b 7b 18          	mov    0x18(%rbx),%rdi
  8c705f:	8d 72 01             	lea    0x1(%rdx),%esi
  8c7062:	48 c1 e2 04          	shl    $0x4,%rdx
  8c7066:	89 b3 3c 01 00 00    	mov    %esi,0x13c(%rbx)
  8c706c:	48 be 01 00 00 00 01 	movabs $0x8000100000001,%rsi
  8c7073:	00 08 00 
  8c7076:	48 89 34 17          	mov    %rsi,(%rdi,%rdx,1)
  8c707a:	48 89 44 17 08       	mov    %rax,0x8(%rdi,%rdx,1)
  8c707f:	eb 26                	jmp    8c70a7 <check_lower_drain+0x3607>
  8c7081:	48 8b 07             	mov    (%rdi),%rax
  8c7084:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c708b:	75 1a                	jne    8c70a7 <check_lower_drain+0x3607>
  8c708d:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c7094:	00 00 00 
  8c7097:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c709d:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c70a1:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c70a7:	49 8b 40 08          	mov    0x8(%r8),%rax
  8c70ab:	31 c9                	xor    %ecx,%ecx
  8c70ad:	42 83 7c 30 04 01    	cmpl   $0x1,0x4(%rax,%r14,1)
  8c70b3:	0f 94 c1             	sete   %cl
  8c70b6:	e9 b1 f4 ff ff       	jmp    8c656c <check_lower_drain+0x2acc>
  8c70bb:	41 83 fe 24          	cmp    $0x24,%r14d
  8c70bf:	0f 84 cc 00 00 00    	je     8c7191 <check_lower_drain+0x36f1>
  8c70c5:	41 83 fe 34          	cmp    $0x34,%r14d
  8c70c9:	0f 85 b3 00 00 00    	jne    8c7182 <check_lower_drain+0x36e2>
  8c70cf:	31 ed                	xor    %ebp,%ebp
  8c70d1:	e9 dc 00 00 00       	jmp    8c71b2 <check_lower_drain+0x3712>
  8c70d6:	48 89 df             	mov    %rbx,%rdi
  8c70d9:	44 89 e6             	mov    %r12d,%esi
  8c70dc:	c5 f8 77             	vzeroupper
  8c70df:	e8 2c 42 01 00       	call   8db310 <check_lower_miscellaneous_prepare>
  8c70e4:	e9 5d 1b 00 00       	jmp    8c8c46 <check_lower_drain+0x51a6>
  8c70e9:	41 8d 72 e7          	lea    -0x19(%r10),%esi
  8c70ed:	4c 89 5c 24 68       	mov    %r11,0x68(%rsp)
  8c70f2:	48 89 4c 24 60       	mov    %rcx,0x60(%rsp)
  8c70f7:	4c 89 54 24 28       	mov    %r10,0x28(%rsp)
  8c70fc:	83 fe 25             	cmp    $0x25,%esi
  8c70ff:	0f 87 86 04 00 00    	ja     8c758b <check_lower_drain+0x3aeb>
  8c7105:	48 8d 3d c8 02 be ff 	lea    -0x41fd38(%rip),%rdi        # 4a73d4 <cbuiltin_test_generated.edges+0xad44>
  8c710c:	48 63 34 b7          	movslq (%rdi,%rsi,4),%rsi
  8c7110:	48 01 fe             	add    %rdi,%rsi
  8c7113:	ff e6                	jmp    *%rsi
  8c7115:	48 89 df             	mov    %rbx,%rdi
  8c7118:	44 89 e6             	mov    %r12d,%esi
  8c711b:	31 d2                	xor    %edx,%edx
  8c711d:	b9 01 00 00 00       	mov    $0x1,%ecx
  8c7122:	e9 4d f4 ff ff       	jmp    8c6574 <check_lower_drain+0x2ad4>
  8c7127:	49 8b 56 48          	mov    0x48(%r14),%rdx
  8c712b:	48 89 df             	mov    %rbx,%rdi
  8c712e:	4d 89 de             	mov    %r11,%r14
  8c7131:	c5 f8 77             	vzeroupper
  8c7134:	e8 77 7c 00 00       	call   8cedb0 <check_lower_address>
  8c7139:	41 0f b6 d6          	movzbl %r14b,%edx
  8c713d:	be 0a 00 00 00       	mov    $0xa,%esi
  8c7142:	48 89 df             	mov    %rbx,%rdi
  8c7145:	31 c9                	xor    %ecx,%ecx
  8c7147:	e8 84 1e 00 00       	call   8c8fd0 <check_lower_emit>
  8c714c:	e9 f5 1a 00 00       	jmp    8c8c46 <check_lower_drain+0x51a6>
  8c7151:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  8c7156:	48 8b 80 80 00 00 00 	mov    0x80(%rax),%rax
  8c715d:	8b 0c b0             	mov    (%rax,%rsi,4),%ecx
  8c7160:	48 85 c9             	test   %rcx,%rcx
  8c7163:	0f 84 b3 1a 00 00    	je     8c8c1c <check_lower_drain+0x517c>
  8c7169:	41 0f b6 d3          	movzbl %r11b,%edx
  8c716d:	be 04 00 00 00       	mov    $0x4,%esi
  8c7172:	48 89 df             	mov    %rbx,%rdi
  8c7175:	c5 f8 77             	vzeroupper
  8c7178:	e8 53 1e 00 00       	call   8c8fd0 <check_lower_emit>
  8c717d:	e9 c4 1a 00 00       	jmp    8c8c46 <check_lower_drain+0x51a6>
  8c7182:	49 8b 4d 08          	mov    0x8(%r13),%rcx
  8c7186:	4c 89 fd             	mov    %r15,%rbp
  8c7189:	48 c1 e5 05          	shl    $0x5,%rbp
  8c718d:	48 03 69 10          	add    0x10(%rcx),%rbp
  8c7191:	8b 6d 00             	mov    0x0(%rbp),%ebp
  8c7194:	83 7c 24 20 0f       	cmpl   $0xf,0x20(%rsp)
  8c7199:	77 17                	ja     8c71b2 <check_lower_drain+0x3712>
  8c719b:	49 8b 4d 08          	mov    0x8(%r13),%rcx
  8c719f:	4c 89 ff             	mov    %r15,%rdi
  8c71a2:	48 c1 e7 05          	shl    $0x5,%rdi
  8c71a6:	48 8b 49 10          	mov    0x10(%rcx),%rcx
  8c71aa:	8b 4c 39 08          	mov    0x8(%rcx,%rdi,1),%ecx
  8c71ae:	89 4c 24 30          	mov    %ecx,0x30(%rsp)
  8c71b2:	48 8b 8e c0 00 00 00 	mov    0xc0(%rsi),%rcx
  8c71b9:	48 0f a3 c1          	bt     %rax,%rcx
  8c71bd:	0f 83 30 d9 ff ff    	jae    8c4af3 <check_lower_drain+0x1053>
  8c71c3:	8b 8b b0 01 00 00    	mov    0x1b0(%rbx),%ecx
  8c71c9:	41 89 e8             	mov    %ebp,%r8d
  8c71cc:	41 c1 e8 03          	shr    $0x3,%r8d
  8c71d0:	bf ff 00 00 00       	mov    $0xff,%edi
  8c71d5:	41 39 c8             	cmp    %ecx,%r8d
  8c71d8:	73 0e                	jae    8c71e8 <check_lower_drain+0x3748>
  8c71da:	48 8b bb a8 01 00 00 	mov    0x1a8(%rbx),%rdi
  8c71e1:	45 89 c0             	mov    %r8d,%r8d
  8c71e4:	42 8b 3c 87          	mov    (%rdi,%r8,4),%edi
  8c71e8:	85 ed                	test   %ebp,%ebp
  8c71ea:	74 52                	je     8c723e <check_lower_drain+0x379e>
  8c71ec:	8b 74 24 20          	mov    0x20(%rsp),%esi
  8c71f0:	45 31 c0             	xor    %r8d,%r8d
  8c71f3:	44 0f b6 cf          	movzbl %dil,%r9d
  8c71f7:	83 fe 02             	cmp    $0x2,%esi
  8c71fa:	41 0f 92 c0          	setb   %r8b
  8c71fe:	83 fe 10             	cmp    $0x10,%esi
  8c7201:	40 0f 93 c6          	setae  %sil
  8c7205:	41 c1 e0 0b          	shl    $0xb,%r8d
  8c7209:	41 81 c8 00 07 00 00 	or     $0x700,%r8d
  8c7210:	41 83 f9 0b          	cmp    $0xb,%r9d
  8c7214:	89 74 24 78          	mov    %esi,0x78(%rsp)
  8c7218:	41 0f 92 c1          	setb   %r9b
  8c721c:	44 85 c7             	test   %r8d,%edi
  8c721f:	40 0f 94 c7          	sete   %dil
  8c7223:	44 20 cf             	and    %r9b,%dil
  8c7226:	40 80 ff 01          	cmp    $0x1,%dil
  8c722a:	75 07                	jne    8c7233 <check_lower_drain+0x3793>
  8c722c:	83 7c 24 20 10       	cmpl   $0x10,0x20(%rsp)
  8c7231:	72 21                	jb     8c7254 <check_lower_drain+0x37b4>
  8c7233:	40 84 ff             	test   %dil,%dil
  8c7236:	0f 84 b7 d8 ff ff    	je     8c4af3 <check_lower_drain+0x1053>
  8c723c:	eb 7d                	jmp    8c72bb <check_lower_drain+0x381b>
  8c723e:	83 7c 24 20 0f       	cmpl   $0xf,0x20(%rsp)
  8c7243:	40 b6 01             	mov    $0x1,%sil
  8c7246:	89 74 24 78          	mov    %esi,0x78(%rsp)
  8c724a:	77 6f                	ja     8c72bb <check_lower_drain+0x381b>
  8c724c:	c7 44 24 78 00 00 00 	movl   $0x0,0x78(%rsp)
  8c7253:	00 
  8c7254:	44 8b 44 24 30       	mov    0x30(%rsp),%r8d
  8c7259:	bf ff 00 00 00       	mov    $0xff,%edi
  8c725e:	41 c1 e8 03          	shr    $0x3,%r8d
  8c7262:	41 39 c8             	cmp    %ecx,%r8d
  8c7265:	73 0d                	jae    8c7274 <check_lower_drain+0x37d4>
  8c7267:	48 8b 8b a8 01 00 00 	mov    0x1a8(%rbx),%rcx
  8c726e:	44 89 c7             	mov    %r8d,%edi
  8c7271:	8b 3c b9             	mov    (%rcx,%rdi,4),%edi
  8c7274:	83 7c 24 30 00       	cmpl   $0x0,0x30(%rsp)
  8c7279:	4c 8b 54 24 38       	mov    0x38(%rsp),%r10
  8c727e:	74 2d                	je     8c72ad <check_lower_drain+0x380d>
  8c7280:	31 c9                	xor    %ecx,%ecx
  8c7282:	83 7c 24 20 02       	cmpl   $0x2,0x20(%rsp)
  8c7287:	44 0f b6 cf          	movzbl %dil,%r9d
  8c728b:	41 0f 92 c0          	setb   %r8b
  8c728f:	41 83 f9 0a          	cmp    $0xa,%r9d
  8c7293:	0f 87 5a d8 ff ff    	ja     8c4af3 <check_lower_drain+0x1053>
  8c7299:	44 88 c1             	mov    %r8b,%cl
  8c729c:	c1 e1 0b             	shl    $0xb,%ecx
  8c729f:	81 c9 00 07 00 00    	or     $0x700,%ecx
  8c72a5:	21 cf                	and    %ecx,%edi
  8c72a7:	0f 85 46 d8 ff ff    	jne    8c4af3 <check_lower_drain+0x1053>
  8c72ad:	49 8b 4a 10          	mov    0x10(%r10),%rcx
  8c72b1:	89 6c 24 54          	mov    %ebp,0x54(%rsp)
  8c72b5:	46 8b 04 b9          	mov    (%rcx,%r15,4),%r8d
  8c72b9:	eb 13                	jmp    8c72ce <check_lower_drain+0x382e>
  8c72bb:	49 8b 4a 10          	mov    0x10(%r10),%rcx
  8c72bf:	83 7c 24 20 0f       	cmpl   $0xf,0x20(%rsp)
  8c72c4:	89 6c 24 54          	mov    %ebp,0x54(%rsp)
  8c72c8:	46 8b 04 b9          	mov    (%rcx,%r15,4),%r8d
  8c72cc:	77 19                	ja     8c72e7 <check_lower_drain+0x3847>
  8c72ce:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  8c72d3:	48 8b 49 18          	mov    0x18(%rcx),%rcx
  8c72d7:	42 8b 0c b9          	mov    (%rcx,%r15,4),%ecx
  8c72db:	48 89 4c 24 48       	mov    %rcx,0x48(%rsp)
  8c72e0:	b9 02 00 00 00       	mov    $0x2,%ecx
  8c72e5:	eb 0e                	jmp    8c72f5 <check_lower_drain+0x3855>
  8c72e7:	48 c7 44 24 48 00 00 	movq   $0x0,0x48(%rsp)
  8c72ee:	00 00 
  8c72f0:	b9 01 00 00 00       	mov    $0x1,%ecx
  8c72f5:	0f b6 d2             	movzbl %dl,%edx
  8c72f8:	44 8b 8b 40 01 00 00 	mov    0x140(%rbx),%r9d
  8c72ff:	41 0f b6 f3          	movzbl %r11b,%esi
  8c7303:	41 bd 00 00 00 01    	mov    $0x1000000,%r13d
  8c7309:	89 54 24 44          	mov    %edx,0x44(%rsp)
  8c730d:	31 d2                	xor    %edx,%edx
  8c730f:	83 7c 24 20 10       	cmpl   $0x10,0x20(%rsp)
  8c7314:	40 0f 92 c7          	setb   %dil
  8c7318:	31 ed                	xor    %ebp,%ebp
  8c731a:	66 81 fe ff 00       	cmp    $0xff,%si
  8c731f:	41 0f 95 c6          	setne  %r14b
  8c7323:	41 81 f9 00 00 00 01 	cmp    $0x1000000,%r9d
  8c732a:	45 0f 42 e9          	cmovb  %r9d,%r13d
  8c732e:	39 c8                	cmp    %ecx,%eax
  8c7330:	0f 82 73 15 00 00    	jb     8c88a9 <check_lower_drain+0x4e09>
  8c7336:	83 7c 24 20 10       	cmpl   $0x10,0x20(%rsp)
  8c733b:	45 89 c2             	mov    %r8d,%r10d
  8c733e:	41 83 d2 01          	adc    $0x1,%r10d
  8c7342:	45 39 e2             	cmp    %r12d,%r10d
  8c7345:	0f 85 5e 15 00 00    	jne    8c88a9 <check_lower_drain+0x4e09>
  8c734b:	83 7c 24 20 0f       	cmpl   $0xf,0x20(%rsp)
  8c7350:	77 11                	ja     8c7363 <check_lower_drain+0x38c3>
  8c7352:	4c 8b 54 24 48       	mov    0x48(%rsp),%r10
  8c7357:	41 ff c2             	inc    %r10d
  8c735a:	45 39 e2             	cmp    %r12d,%r10d
  8c735d:	0f 85 46 15 00 00    	jne    8c88a9 <check_lower_drain+0x4e09>
  8c7363:	83 7c 24 54 00       	cmpl   $0x0,0x54(%rsp)
  8c7368:	40 88 fa             	mov    %dil,%dl
  8c736b:	74 1b                	je     8c7388 <check_lower_drain+0x38e8>
  8c736d:	4c 8b 54 24 58       	mov    0x58(%rsp),%r10
  8c7372:	89 d7                	mov    %edx,%edi
  8c7374:	f7 d7                	not    %edi
  8c7376:	44 8b 5c 24 54       	mov    0x54(%rsp),%r11d
  8c737b:	01 c7                	add    %eax,%edi
  8c737d:	45 3b 5c ba 40       	cmp    0x40(%r10,%rdi,4),%r11d
  8c7382:	0f 85 21 15 00 00    	jne    8c88a9 <check_lower_drain+0x4e09>
  8c7388:	83 7c 24 20 0f       	cmpl   $0xf,0x20(%rsp)
  8c738d:	77 1f                	ja     8c73ae <check_lower_drain+0x390e>
  8c738f:	83 7c 24 30 00       	cmpl   $0x0,0x30(%rsp)
  8c7394:	74 18                	je     8c73ae <check_lower_drain+0x390e>
  8c7396:	4c 8b 54 24 58       	mov    0x58(%rsp),%r10
  8c739b:	8d 78 ff             	lea    -0x1(%rax),%edi
  8c739e:	44 8b 5c 24 30       	mov    0x30(%rsp),%r11d
  8c73a3:	45 3b 5c ba 40       	cmp    0x40(%r10,%rdi,4),%r11d
  8c73a8:	0f 85 fb 14 00 00    	jne    8c88a9 <check_lower_drain+0x4e09>
  8c73ae:	8b bb 38 01 00 00    	mov    0x138(%rbx),%edi
  8c73b4:	41 29 fd             	sub    %edi,%r13d
  8c73b7:	0f 82 ec 14 00 00    	jb     8c88a9 <check_lower_drain+0x4e09>
  8c73bd:	44 88 f5             	mov    %r14b,%bpl
  8c73c0:	01 cd                	add    %ecx,%ebp
  8c73c2:	44 39 ed             	cmp    %r13d,%ebp
  8c73c5:	0f 87 de 14 00 00    	ja     8c88a9 <check_lower_drain+0x4e09>
  8c73cb:	44 2b 8b 3c 01 00 00 	sub    0x13c(%rbx),%r9d
  8c73d2:	49 89 fb             	mov    %rdi,%r11
  8c73d5:	40 0f 93 c7          	setae  %dil
  8c73d9:	41 83 f9 05          	cmp    $0x5,%r9d
  8c73dd:	41 0f 93 c1          	setae  %r9b
  8c73e1:	41 20 f9             	and    %dil,%r9b
  8c73e4:	41 80 f9 01          	cmp    $0x1,%r9b
  8c73e8:	0f 85 bb 14 00 00    	jne    8c88a9 <check_lower_drain+0x4e09>
  8c73ee:	48 8b 3b             	mov    (%rbx),%rdi
  8c73f1:	48 89 bc 24 80 00 00 	mov    %rdi,0x80(%rsp)
  8c73f8:	00 
  8c73f9:	48 8b 7f 08          	mov    0x8(%rdi),%rdi
  8c73fd:	4c 8b 4f 08          	mov    0x8(%rdi),%r9
  8c7401:	44 89 c7             	mov    %r8d,%edi
  8c7404:	4c 8d 14 7f          	lea    (%rdi,%rdi,2),%r10
  8c7408:	48 89 7c 24 68       	mov    %rdi,0x68(%rsp)
  8c740d:	49 c1 e2 05          	shl    $0x5,%r10
  8c7411:	4c 89 4c 24 70       	mov    %r9,0x70(%rsp)
  8c7416:	47 8b 4c 11 40       	mov    0x40(%r9,%r10,1),%r9d
  8c741b:	4d 85 c9             	test   %r9,%r9
  8c741e:	0f 84 21 09 00 00    	je     8c7d45 <check_lower_drain+0x42a5>
  8c7424:	48 8b bc 24 80 00 00 	mov    0x80(%rsp),%rdi
  8c742b:	00 
  8c742c:	44 3b 8f c0 00 00 00 	cmp    0xc0(%rdi),%r9d
  8c7433:	40 0f 92 c7          	setb   %dil
  8c7437:	89 7c 24 28          	mov    %edi,0x28(%rsp)
  8c743b:	e9 0d 09 00 00       	jmp    8c7d4d <check_lower_drain+0x42ad>
  8c7440:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  8c7445:	ba 00 01 00 00       	mov    $0x100,%edx
  8c744a:	44 89 e1             	mov    %r12d,%ecx
  8c744d:	4c 8b 70 60          	mov    0x60(%rax),%r14
  8c7451:	8b b0 b4 00 00 00    	mov    0xb4(%rax),%esi
  8c7457:	4c 89 f7             	mov    %r14,%rdi
  8c745a:	c5 f8 77             	vzeroupper
  8c745d:	e8 6e 55 fc ff       	call   88c9d0 <check_program_builtin_index>
  8c7462:	83 f8 ff             	cmp    $0xffffffff,%eax
  8c7465:	0f 84 61 01 00 00    	je     8c75cc <check_lower_drain+0x3b2c>
  8c746b:	4d 85 f6             	test   %r14,%r14
  8c746e:	0f 84 58 01 00 00    	je     8c75cc <check_lower_drain+0x3b2c>
  8c7474:	89 c0                	mov    %eax,%eax
  8c7476:	48 c1 e0 08          	shl    $0x8,%rax
  8c747a:	49 01 c6             	add    %rax,%r14
  8c747d:	41 83 be d0 00 00 00 	cmpl   $0x0,0xd0(%r14)
  8c7484:	00 
  8c7485:	0f 84 41 01 00 00    	je     8c75cc <check_lower_drain+0x3b2c>
  8c748b:	41 83 be f0 00 00 00 	cmpl   $0x0,0xf0(%r14)
  8c7492:	00 
  8c7493:	0f 84 33 01 00 00    	je     8c75cc <check_lower_drain+0x3b2c>
  8c7499:	48 89 df             	mov    %rbx,%rdi
  8c749c:	44 89 e6             	mov    %r12d,%esi
  8c749f:	4c 89 f2             	mov    %r14,%rdx
  8c74a2:	e8 f9 41 01 00       	call   8db6a0 <check_lower_math>
  8c74a7:	e9 9a 17 00 00       	jmp    8c8c46 <check_lower_drain+0x51a6>
  8c74ac:	48 83 7c 24 38 00    	cmpq   $0x0,0x38(%rsp)
  8c74b2:	0f 95 c0             	setne  %al
  8c74b5:	0a 44 24 54          	or     0x54(%rsp),%al
  8c74b9:	75 17                	jne    8c74d2 <check_lower_drain+0x3a32>
  8c74bb:	0f b6 54 24 68       	movzbl 0x68(%rsp),%edx
  8c74c0:	be 0a 00 00 00       	mov    $0xa,%esi
  8c74c5:	48 89 df             	mov    %rbx,%rdi
  8c74c8:	31 c9                	xor    %ecx,%ecx
  8c74ca:	c5 f8 77             	vzeroupper
  8c74cd:	e8 4e 20 00 00       	call   8c9520 <check_lower_instruction>
  8c74d2:	4c 8b 44 24 48       	mov    0x48(%rsp),%r8
  8c74d7:	48 89 df             	mov    %rbx,%rdi
  8c74da:	44 89 e6             	mov    %r12d,%esi
  8c74dd:	31 d2                	xor    %edx,%edx
  8c74df:	31 c9                	xor    %ecx,%ecx
  8c74e1:	c5 f8 77             	vzeroupper
  8c74e4:	e8 67 20 01 00       	call   8d9550 <check_lower_operand>
  8c74e9:	e9 58 17 00 00       	jmp    8c8c46 <check_lower_drain+0x51a6>
  8c74ee:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  8c74f3:	ba b0 00 00 00       	mov    $0xb0,%edx
  8c74f8:	44 89 e1             	mov    %r12d,%ecx
  8c74fb:	4c 8b 70 68          	mov    0x68(%rax),%r14
  8c74ff:	8b b0 b8 00 00 00    	mov    0xb8(%rax),%esi
  8c7505:	4c 89 f7             	mov    %r14,%rdi
  8c7508:	c5 f8 77             	vzeroupper
  8c750b:	e8 c0 54 fc ff       	call   88c9d0 <check_program_builtin_index>
  8c7510:	83 f8 ff             	cmp    $0xffffffff,%eax
  8c7513:	0f 84 03 17 00 00    	je     8c8c1c <check_lower_drain+0x517c>
  8c7519:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
  8c751e:	89 c1                	mov    %eax,%ecx
  8c7520:	48 69 c9 b0 00 00 00 	imul   $0xb0,%rcx,%rcx
  8c7527:	49 01 ce             	add    %rcx,%r14
  8c752a:	48 8b 0a             	mov    (%rdx),%rcx
  8c752d:	48 8b 51 38          	mov    0x38(%rcx),%rdx
  8c7531:	b1 01                	mov    $0x1,%cl
  8c7533:	81 3c aa 30 01 00 00 	cmpl   $0x130,(%rdx,%rbp,4)
  8c753a:	75 0f                	jne    8c754b <check_lower_drain+0x3aab>
  8c753c:	41 8b 8e 8c 00 00 00 	mov    0x8c(%r14),%ecx
  8c7543:	ff c9                	dec    %ecx
  8c7545:	83 f9 02             	cmp    $0x2,%ecx
  8c7548:	0f 92 c1             	setb   %cl
  8c754b:	84 c9                	test   %cl,%cl
  8c754d:	74 1c                	je     8c756b <check_lower_drain+0x3acb>
  8c754f:	41 83 be a0 00 00 00 	cmpl   $0x0,0xa0(%r14)
  8c7556:	00 
  8c7557:	75 12                	jne    8c756b <check_lower_drain+0x3acb>
  8c7559:	41 83 7e 1c 00       	cmpl   $0x0,0x1c(%r14)
  8c755e:	74 0b                	je     8c756b <check_lower_drain+0x3acb>
  8c7560:	41 83 7e 64 00       	cmpl   $0x0,0x64(%r14)
  8c7565:	0f 84 ea 03 00 00    	je     8c7955 <check_lower_drain+0x3eb5>
  8c756b:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c756f:	48 8b 00             	mov    (%rax),%rax
  8c7572:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c7579:	0f 85 c7 16 00 00    	jne    8c8c46 <check_lower_drain+0x51a6>
  8c757f:	48 8d 0d ee b1 e2 ff 	lea    -0x1d4e12(%rip),%rcx        # 6f2774 <pp_string_value.meaning+0x3ef37>
  8c7586:	e9 20 f9 ff ff       	jmp    8c6eab <check_lower_drain+0x340b>
  8c758b:	83 fa 20             	cmp    $0x20,%edx
  8c758e:	75 5d                	jne    8c75ed <check_lower_drain+0x3b4d>
  8c7590:	83 7c 24 28 21       	cmpl   $0x21,0x28(%rsp)
  8c7595:	0f 85 32 01 00 00    	jne    8c76cd <check_lower_drain+0x3c2d>
  8c759b:	48 8b 4c 24 58       	mov    0x58(%rsp),%rcx
  8c75a0:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  8c75a5:	48 8b 01             	mov    (%rcx),%rax
  8c75a8:	89 f2                	mov    %esi,%edx
  8c75aa:	c1 ea 03             	shr    $0x3,%edx
  8c75ad:	48 8b 49 20          	mov    0x20(%rcx),%rcx
  8c75b1:	83 e6 07             	and    $0x7,%esi
  8c75b4:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  8c75b8:	04 f8                	add    $0xf8,%al
  8c75ba:	3c 03                	cmp    $0x3,%al
  8c75bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8c75c1:	0f 43 f0             	cmovae %eax,%esi
  8c75c4:	0b 34 91             	or     (%rcx,%rdx,4),%esi
  8c75c7:	e9 16 01 00 00       	jmp    8c76e2 <check_lower_drain+0x3c42>
  8c75cc:	49 8b 47 38          	mov    0x38(%r15),%rax
  8c75d0:	81 3c a8 52 01 00 00 	cmpl   $0x152,(%rax,%rbp,4)
  8c75d7:	0f 84 a4 f8 ff ff    	je     8c6e81 <check_lower_drain+0x33e1>
  8c75dd:	48 89 df             	mov    %rbx,%rdi
  8c75e0:	44 89 e6             	mov    %r12d,%esi
  8c75e3:	e8 d8 46 01 00       	call   8dbcc0 <check_lower_floating_prepare>
  8c75e8:	e9 59 16 00 00       	jmp    8c8c46 <check_lower_drain+0x51a6>
  8c75ed:	45 8b 06             	mov    (%r14),%r8d
  8c75f0:	83 7c 24 28 24       	cmpl   $0x24,0x28(%rsp)
  8c75f5:	0f 87 79 01 00 00    	ja     8c7774 <check_lower_drain+0x3cd4>
  8c75fb:	8b 74 24 28          	mov    0x28(%rsp),%esi
  8c75ff:	bf f4 01 00 00       	mov    $0x1f4,%edi
  8c7604:	48 0f a3 f7          	bt     %rsi,%rdi
  8c7608:	0f 83 52 01 00 00    	jae    8c7760 <check_lower_drain+0x3cc0>
  8c760e:	44 89 c2             	mov    %r8d,%edx
  8c7611:	c1 ea 03             	shr    $0x3,%edx
  8c7614:	3b 54 24 44          	cmp    0x44(%rsp),%edx
  8c7618:	73 1b                	jae    8c7635 <check_lower_drain+0x3b95>
  8c761a:	48 8b 83 a0 01 00 00 	mov    0x1a0(%rbx),%rax
  8c7621:	89 d2                	mov    %edx,%edx
  8c7623:	f6 04 10 02          	testb  $0x2,(%rax,%rdx,1)
  8c7627:	48 89 84 24 88 00 00 	mov    %rax,0x88(%rsp)
  8c762e:	00 
  8c762f:	0f 85 28 02 00 00    	jne    8c785d <check_lower_drain+0x3dbd>
  8c7635:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  8c763a:	8d 51 fe             	lea    -0x2(%rcx),%edx
  8c763d:	83 fa 23             	cmp    $0x23,%edx
  8c7640:	0f 87 1d 04 00 00    	ja     8c7a63 <check_lower_drain+0x3fc3>
  8c7646:	48 8d 35 1f fe bd ff 	lea    -0x4201e1(%rip),%rsi        # 4a746c <cbuiltin_test_generated.edges+0xaddc>
  8c764d:	48 63 14 96          	movslq (%rsi,%rdx,4),%rdx
  8c7651:	48 01 f2             	add    %rsi,%rdx
  8c7654:	ff e2                	jmp    *%rdx
  8c7656:	31 f6                	xor    %esi,%esi
  8c7658:	83 7c 24 28 02       	cmpl   $0x2,0x28(%rsp)
  8c765d:	0f b6 54 24 68       	movzbl 0x68(%rsp),%edx
  8c7662:	48 89 df             	mov    %rbx,%rdi
  8c7665:	40 0f 95 c6          	setne  %sil
  8c7669:	83 c6 07             	add    $0x7,%esi
  8c766c:	e9 57 fe ff ff       	jmp    8c74c8 <check_lower_drain+0x3a28>
  8c7671:	83 fd 01             	cmp    $0x1,%ebp
  8c7674:	0f 85 6c d4 ff ff    	jne    8c4ae6 <check_lower_drain+0x1046>
  8c767a:	48 8b 49 10          	mov    0x10(%rcx),%rcx
  8c767e:	41 b1 01             	mov    $0x1,%r9b
  8c7681:	41 83 fb 06          	cmp    $0x6,%r11d
  8c7685:	0f 87 20 f9 ff ff    	ja     8c6fab <check_lower_drain+0x350b>
  8c768b:	41 d1 ea             	shr    $1,%r10d
  8c768e:	be 08 00 00 00       	mov    $0x8,%esi
  8c7693:	48 c7 c7 ff ff ff ff 	mov    $0xffffffffffffffff,%rdi
  8c769a:	c4 e2 29 f7 f6       	shlx   %r10d,%esi,%esi
  8c769f:	c4 62 c8 f5 d1       	bzhi   %rsi,%rcx,%r10
  8c76a4:	8d 4e ff             	lea    -0x1(%rsi),%ecx
  8c76a7:	c4 e2 c9 f7 ff       	shlx   %rsi,%rdi,%rdi
  8c76ac:	c4 c2 f3 f7 ca       	shrx   %rcx,%r10,%rcx
  8c76b1:	48 85 c9             	test   %rcx,%rcx
  8c76b4:	48 0f 44 f9          	cmove  %rcx,%rdi
  8c76b8:	41 f6 c0 01          	test   $0x1,%r8b
  8c76bc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8c76c1:	48 0f 45 cf          	cmovne %rdi,%rcx
  8c76c5:	4c 09 d1             	or     %r10,%rcx
  8c76c8:	e9 de f8 ff ff       	jmp    8c6fab <check_lower_drain+0x350b>
  8c76cd:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
  8c76d2:	4b 8d 44 6d 00       	lea    0x0(%r13,%r13,2),%rax
  8c76d7:	48 c1 e0 05          	shl    $0x5,%rax
  8c76db:	48 8b 49 08          	mov    0x8(%rcx),%rcx
  8c76df:	8b 34 01             	mov    (%rcx,%rax,1),%esi
  8c76e2:	48 c7 84 24 08 02 00 	movq   $0x0,0x208(%rsp)
  8c76e9:	00 00 00 00 00 
  8c76ee:	48 8b 7c 24 58       	mov    0x58(%rsp),%rdi
  8c76f3:	48 8d 8c 24 08 02 00 	lea    0x208(%rsp),%rcx
  8c76fa:	00 
  8c76fb:	49 8b 47 38          	mov    0x38(%r15),%rax
  8c76ff:	8b 14 a8             	mov    (%rax,%rbp,4),%edx
  8c7702:	c5 f8 77             	vzeroupper
  8c7705:	e8 a6 e6 91 00       	call   11e5db0 <type_find_member>
  8c770a:	41 8b 4e 08          	mov    0x8(%r14),%ecx
  8c770e:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
  8c7712:	c5 f9 7f 84 24 f0 01 	vmovdqa %xmm0,0x1f0(%rsp)
  8c7719:	00 00 
  8c771b:	48 c7 84 24 00 02 00 	movq   $0x0,0x200(%rsp)
  8c7722:	00 00 00 00 00 
  8c7727:	85 c0                	test   %eax,%eax
  8c7729:	74 15                	je     8c7740 <check_lower_drain+0x3ca0>
  8c772b:	f6 c1 04             	test   $0x4,%cl
  8c772e:	75 64                	jne    8c7794 <check_lower_drain+0x3cf4>
  8c7730:	48 8b 84 24 08 02 00 	mov    0x208(%rsp),%rax
  8c7737:	00 
  8c7738:	a8 07                	test   $0x7,%al
  8c773a:	0f 84 79 02 00 00    	je     8c79b9 <check_lower_drain+0x3f19>
  8c7740:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c7744:	48 8b 00             	mov    (%rax),%rax
  8c7747:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c774e:	0f 85 f2 14 00 00    	jne    8c8c46 <check_lower_drain+0x51a6>
  8c7754:	48 8d 0d 9c 93 d5 ff 	lea    -0x2a6c64(%rip),%rcx        # 620af7 <foreign_touch.flags+0x49a2>
  8c775b:	e9 4b f7 ff ff       	jmp    8c6eab <check_lower_drain+0x340b>
  8c7760:	48 bf 02 00 00 01 10 	movabs $0x1001000002,%rdi
  8c7767:	00 00 00 
  8c776a:	48 0f a3 f7          	bt     %rsi,%rdi
  8c776e:	0f 82 63 fd ff ff    	jb     8c74d7 <check_lower_drain+0x3a37>
  8c7774:	83 fa 10             	cmp    $0x10,%edx
  8c7777:	0f 85 b8 fe ff ff    	jne    8c7635 <check_lower_drain+0x3b95>
  8c777d:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
  8c7782:	c1 ea 03             	shr    $0x3,%edx
  8c7785:	3b 54 24 44          	cmp    0x44(%rsp),%edx
  8c7789:	0f 82 8b fe ff ff    	jb     8c761a <check_lower_drain+0x3b7a>
  8c778f:	e9 a1 fe ff ff       	jmp    8c7635 <check_lower_drain+0x3b95>
  8c7794:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c7799:	48 8d 94 24 f0 01 00 	lea    0x1f0(%rsp),%rdx
  8c77a0:	00 
  8c77a1:	44 89 e6             	mov    %r12d,%esi
  8c77a4:	e8 17 56 01 00       	call   8dcdc0 <check_lower_bit_member>
  8c77a9:	84 c0                	test   %al,%al
  8c77ab:	0f 84 84 01 00 00    	je     8c7935 <check_lower_drain+0x3e95>
  8c77b1:	48 83 7c 24 38 00    	cmpq   $0x0,0x38(%rsp)
  8c77b7:	0f 85 1f 02 00 00    	jne    8c79dc <check_lower_drain+0x3f3c>
  8c77bd:	8b 84 24 fc 01 00 00 	mov    0x1fc(%rsp),%eax
  8c77c4:	0f b6 8c 24 00 02 00 	movzbl 0x200(%rsp),%ecx
  8c77cb:	00 
  8c77cc:	0f b6 94 24 01 02 00 	movzbl 0x201(%rsp),%edx
  8c77d3:	00 
  8c77d4:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
  8c77d8:	c5 fe 7f 84 24 d0 01 	vmovdqu %ymm0,0x1d0(%rsp)
  8c77df:	00 00 
  8c77e1:	c7 84 24 d0 01 00 00 	movl   $0x10,0x1d0(%rsp)
  8c77e8:	10 00 00 00 
  8c77ec:	48 89 df             	mov    %rbx,%rdi
  8c77ef:	8d 04 c5 f8 ff ff ff 	lea    -0x8(,%rax,8),%eax
  8c77f6:	0b 84 24 f8 01 00 00 	or     0x1f8(%rsp),%eax
  8c77fd:	c1 e1 09             	shl    $0x9,%ecx
  8c7800:	c1 e2 0d             	shl    $0xd,%edx
  8c7803:	09 ca                	or     %ecx,%edx
  8c7805:	09 c2                	or     %eax,%edx
  8c7807:	89 94 24 d8 01 00 00 	mov    %edx,0x1d8(%rsp)
  8c780e:	c5 fe 6f 84 24 d0 01 	vmovdqu 0x1d0(%rsp),%ymm0
  8c7815:	00 00 
  8c7817:	c5 fe 7f 04 24       	vmovdqu %ymm0,(%rsp)
  8c781c:	c5 f8 77             	vzeroupper
  8c781f:	e8 ac 5a 00 00       	call   8cd2d0 <check_lower_push>
  8c7824:	e9 b3 01 00 00       	jmp    8c79dc <check_lower_drain+0x3f3c>
  8c7829:	31 d2                	xor    %edx,%edx
  8c782b:	83 7c 24 28 03       	cmpl   $0x3,0x28(%rsp)
  8c7830:	4c 8b 74 24 48       	mov    0x48(%rsp),%r14
  8c7835:	48 89 df             	mov    %rbx,%rdi
  8c7838:	0f 94 c2             	sete   %dl
  8c783b:	44 89 f6             	mov    %r14d,%esi
  8c783e:	c5 f8 77             	vzeroupper
  8c7841:	e8 2a 57 01 00       	call   8dcf70 <check_lower_truth>
  8c7846:	48 89 df             	mov    %rbx,%rdi
  8c7849:	44 89 e6             	mov    %r12d,%esi
  8c784c:	31 d2                	xor    %edx,%edx
  8c784e:	31 c9                	xor    %ecx,%ecx
  8c7850:	45 89 f0             	mov    %r14d,%r8d
  8c7853:	e8 f8 1c 01 00       	call   8d9550 <check_lower_operand>
  8c7858:	e9 e9 13 00 00       	jmp    8c8c46 <check_lower_drain+0x51a6>
  8c785d:	48 8b 7c 24 58       	mov    0x58(%rsp),%rdi
  8c7862:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  8c7867:	c5 f8 77             	vzeroupper
  8c786a:	e8 81 70 fe ff       	call   8ae8f0 <check_lower_complex_element>
  8c786f:	c1 e8 03             	shr    $0x3,%eax
  8c7872:	b1 ff                	mov    $0xff,%cl
  8c7874:	3b 44 24 44          	cmp    0x44(%rsp),%eax
  8c7878:	73 0b                	jae    8c7885 <check_lower_drain+0x3de5>
  8c787a:	48 8b 8b 98 01 00 00 	mov    0x198(%rbx),%rcx
  8c7881:	0f b6 0c 01          	movzbl (%rcx,%rax,1),%ecx
  8c7885:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
  8c788a:	4b 8d 44 6d 00       	lea    0x0(%r13,%r13,2),%rax
  8c788f:	48 c1 e0 05          	shl    $0x5,%rax
  8c7893:	48 8b 52 08          	mov    0x8(%rdx),%rdx
  8c7897:	8b 34 02             	mov    (%rdx,%rax,1),%esi
  8c789a:	89 c8                	mov    %ecx,%eax
  8c789c:	c1 ee 03             	shr    $0x3,%esi
  8c789f:	3b 74 24 44          	cmp    0x44(%rsp),%esi
  8c78a3:	73 17                	jae    8c78bc <check_lower_drain+0x3e1c>
  8c78a5:	48 8b 84 24 88 00 00 	mov    0x88(%rsp),%rax
  8c78ac:	00 
  8c78ad:	f6 04 30 02          	testb  $0x2,(%rax,%rsi,1)
  8c78b1:	0f b6 c1             	movzbl %cl,%eax
  8c78b4:	be 08 00 00 00       	mov    $0x8,%esi
  8c78b9:	0f 45 c6             	cmovne %esi,%eax
  8c78bc:	83 7c 24 28 02       	cmpl   $0x2,0x28(%rsp)
  8c78c1:	74 34                	je     8c78f7 <check_lower_drain+0x3e57>
  8c78c3:	83 7c 24 28 04       	cmpl   $0x4,0x28(%rsp)
  8c78c8:	74 2d                	je     8c78f7 <check_lower_drain+0x3e57>
  8c78ca:	48 8b b4 24 80 00 00 	mov    0x80(%rsp),%rsi
  8c78d1:	00 
  8c78d2:	48 8d 34 76          	lea    (%rsi,%rsi,2),%rsi
  8c78d6:	48 c1 e6 05          	shl    $0x5,%rsi
  8c78da:	8b 14 32             	mov    (%rdx,%rsi,1),%edx
  8c78dd:	c1 ea 03             	shr    $0x3,%edx
  8c78e0:	3b 54 24 44          	cmp    0x44(%rsp),%edx
  8c78e4:	73 11                	jae    8c78f7 <check_lower_drain+0x3e57>
  8c78e6:	48 8b b4 24 88 00 00 	mov    0x88(%rsp),%rsi
  8c78ed:	00 
  8c78ee:	40 b5 08             	mov    $0x8,%bpl
  8c78f1:	f6 04 16 02          	testb  $0x2,(%rsi,%rdx,1)
  8c78f5:	75 02                	jne    8c78f9 <check_lower_drain+0x3e59>
  8c78f7:	89 cd                	mov    %ecx,%ebp
  8c78f9:	0f b6 f0             	movzbl %al,%esi
  8c78fc:	48 89 df             	mov    %rbx,%rdi
  8c78ff:	89 74 24 20          	mov    %esi,0x20(%rsp)
  8c7903:	e8 e8 6c ff ff       	call   8be5f0 <check_lower_temporary>
  8c7908:	83 7c 24 28 02       	cmpl   $0x2,0x28(%rsp)
  8c790d:	41 89 c6             	mov    %eax,%r14d
  8c7910:	0f 84 79 02 00 00    	je     8c7b8f <check_lower_drain+0x40ef>
  8c7916:	83 7c 24 28 04       	cmpl   $0x4,0x28(%rsp)
  8c791b:	44 89 f0             	mov    %r14d,%eax
  8c791e:	0f 84 6e 02 00 00    	je     8c7b92 <check_lower_drain+0x40f2>
  8c7924:	40 0f b6 f5          	movzbl %bpl,%esi
  8c7928:	48 89 df             	mov    %rbx,%rdi
  8c792b:	e8 c0 6c ff ff       	call   8be5f0 <check_lower_temporary>
  8c7930:	e9 5d 02 00 00       	jmp    8c7b92 <check_lower_drain+0x40f2>
  8c7935:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c7939:	48 8b 00             	mov    (%rax),%rax
  8c793c:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c7943:	0f 85 fd 12 00 00    	jne    8c8c46 <check_lower_drain+0x51a6>
  8c7949:	48 8d 0d ac 5b e4 ff 	lea    -0x1ba454(%rip),%rcx        # 70d4fc <pp_string_value.meaning+0x59cbf>
  8c7950:	e9 56 f5 ff ff       	jmp    8c6eab <check_lower_drain+0x340b>
  8c7955:	49 8b 8f a0 00 00 00 	mov    0xa0(%r15),%rcx
  8c795c:	41 8b 76 70          	mov    0x70(%r14),%esi
  8c7960:	ba 00 00 00 00       	mov    $0x0,%edx
  8c7965:	44 8b 2c a9          	mov    (%rcx,%rbp,4),%r13d
  8c7969:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  8c796e:	89 74 24 20          	mov    %esi,0x20(%rsp)
  8c7972:	41 83 fd 20          	cmp    $0x20,%r13d
  8c7976:	c4 e2 11 f7 c9       	shlx   %r13d,%ecx,%ecx
  8c797b:	0f 43 ca             	cmovae %edx,%ecx
  8c797e:	85 f1                	test   %esi,%ecx
  8c7980:	0f 84 15 03 00 00    	je     8c7c9b <check_lower_drain+0x41fb>
  8c7986:	48 8d 4b 08          	lea    0x8(%rbx),%rcx
  8c798a:	48 8b 09             	mov    (%rcx),%rcx
  8c798d:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c7994:	0f 85 31 03 00 00    	jne    8c7ccb <check_lower_drain+0x422b>
  8c799a:	c7 81 f0 00 00 00 01 	movl   $0x1,0xf0(%rcx)
  8c79a1:	00 00 00 
  8c79a4:	8b 8b 64 01 00 00    	mov    0x164(%rbx),%ecx
  8c79aa:	48 8b 53 08          	mov    0x8(%rbx),%rdx
  8c79ae:	89 8a f4 00 00 00    	mov    %ecx,0xf4(%rdx)
  8c79b4:	e9 12 03 00 00       	jmp    8c7ccb <check_lower_drain+0x422b>
  8c79b9:	48 83 7c 24 38 00    	cmpq   $0x0,0x38(%rsp)
  8c79bf:	0f 95 c1             	setne  %cl
  8c79c2:	0a 4c 24 54          	or     0x54(%rsp),%cl
  8c79c6:	75 1c                	jne    8c79e4 <check_lower_drain+0x3f44>
  8c79c8:	0f b6 54 24 68       	movzbl 0x68(%rsp),%edx
  8c79cd:	be 0a 00 00 00       	mov    $0xa,%esi
  8c79d2:	48 89 df             	mov    %rbx,%rdi
  8c79d5:	31 c9                	xor    %ecx,%ecx
  8c79d7:	e8 44 1b 00 00       	call   8c9520 <check_lower_instruction>
  8c79dc:	48 8b 84 24 08 02 00 	mov    0x208(%rsp),%rax
  8c79e3:	00 
  8c79e4:	48 83 f8 08          	cmp    $0x8,%rax
  8c79e8:	0f 82 80 01 00 00    	jb     8c7b6e <check_lower_drain+0x40ce>
  8c79ee:	8b 8b 3c 01 00 00    	mov    0x13c(%rbx),%ecx
  8c79f4:	3b 8b 40 01 00 00    	cmp    0x140(%rbx),%ecx
  8c79fa:	0f 83 e2 00 00 00    	jae    8c7ae2 <check_lower_drain+0x4042>
  8c7a00:	48 8b 53 18          	mov    0x18(%rbx),%rdx
  8c7a04:	8d 71 01             	lea    0x1(%rcx),%esi
  8c7a07:	48 c1 e1 04          	shl    $0x4,%rcx
  8c7a0b:	89 b3 3c 01 00 00    	mov    %esi,0x13c(%rbx)
  8c7a11:	48 be 01 00 00 00 01 	movabs $0x8000100000001,%rsi
  8c7a18:	00 08 00 
  8c7a1b:	48 83 c6 14          	add    $0x14,%rsi
  8c7a1f:	48 89 34 0a          	mov    %rsi,(%rdx,%rcx,1)
  8c7a23:	48 c7 44 0a 08 01 00 	movq   $0x1,0x8(%rdx,%rcx,1)
  8c7a2a:	00 00 
  8c7a2c:	e9 db 00 00 00       	jmp    8c7b0c <check_lower_drain+0x406c>
  8c7a31:	31 c9                	xor    %ecx,%ecx
  8c7a33:	48 83 7c 24 38 00    	cmpq   $0x0,0x38(%rsp)
  8c7a39:	b8 08 00 00 00       	mov    $0x8,%eax
  8c7a3e:	ba 01 00 00 00       	mov    $0x1,%edx
  8c7a43:	48 89 df             	mov    %rbx,%rdi
  8c7a46:	44 89 e6             	mov    %r12d,%esi
  8c7a49:	0f 95 c1             	setne  %cl
  8c7a4c:	48 83 7c 24 78 00    	cmpq   $0x0,0x78(%rsp)
  8c7a52:	44 0f 45 c0          	cmovne %eax,%r8d
  8c7a56:	c5 f8 77             	vzeroupper
  8c7a59:	e8 f2 1a 01 00       	call   8d9550 <check_lower_operand>
  8c7a5e:	e9 bf f1 ff ff       	jmp    8c6c22 <check_lower_drain+0x3182>
  8c7a63:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  8c7a68:	8d 51 eb             	lea    -0x15(%rcx),%edx
  8c7a6b:	83 fa 02             	cmp    $0x2,%edx
  8c7a6e:	0f 87 37 05 00 00    	ja     8c7fab <check_lower_drain+0x450b>
  8c7a74:	4c 89 ea             	mov    %r13,%rdx
  8c7a77:	89 d1                	mov    %edx,%ecx
  8c7a79:	33 8c 24 80 00 00 00 	xor    0x80(%rsp),%ecx
  8c7a80:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  8c7a85:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  8c7a8a:	83 f0 17             	xor    $0x17,%eax
  8c7a8d:	c6 84 24 d0 01 00 00 	movb   $0x0,0x1d0(%rsp)
  8c7a94:	00 
  8c7a95:	44 89 e6             	mov    %r12d,%esi
  8c7a98:	09 c1                	or     %eax,%ecx
  8c7a9a:	48 8d 8c 24 d0 01 00 	lea    0x1d0(%rsp),%rcx
  8c7aa1:	00 
  8c7aa2:	40 0f 94 c5          	sete   %bpl
  8c7aa6:	c5 f8 77             	vzeroupper
  8c7aa9:	e8 c2 4a fc ff       	call   88c570 <check_program_runtime_truth>
  8c7aae:	84 c0                	test   %al,%al
  8c7ab0:	0f 84 1a 05 00 00    	je     8c7fd0 <check_lower_drain+0x4530>
  8c7ab6:	83 7c 24 28 17       	cmpl   $0x17,0x28(%rsp)
  8c7abb:	0f 85 c7 05 00 00    	jne    8c8088 <check_lower_drain+0x45e8>
  8c7ac1:	44 0f b6 bc 24 d0 01 	movzbl 0x1d0(%rsp),%r15d
  8c7ac8:	00 00 
  8c7aca:	45 8b 06             	mov    (%r14),%r8d
  8c7acd:	ba 02 00 00 00       	mov    $0x2,%edx
  8c7ad2:	48 89 df             	mov    %rbx,%rdi
  8c7ad5:	44 89 e6             	mov    %r12d,%esi
  8c7ad8:	31 c9                	xor    %ecx,%ecx
  8c7ada:	44 29 fa             	sub    %r15d,%edx
  8c7add:	e9 b5 08 00 00       	jmp    8c8397 <check_lower_drain+0x48f7>
  8c7ae2:	48 8d 4b 08          	lea    0x8(%rbx),%rcx
  8c7ae6:	48 8b 09             	mov    (%rcx),%rcx
  8c7ae9:	83 b9 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rcx)
  8c7af0:	75 1a                	jne    8c7b0c <check_lower_drain+0x406c>
  8c7af2:	c7 81 f0 00 00 00 03 	movl   $0x3,0xf0(%rcx)
  8c7af9:	00 00 00 
  8c7afc:	8b 8b 64 01 00 00    	mov    0x164(%rbx),%ecx
  8c7b02:	48 8b 53 08          	mov    0x8(%rbx),%rdx
  8c7b06:	89 8a f4 00 00 00    	mov    %ecx,0xf4(%rdx)
  8c7b0c:	8b 8b 3c 01 00 00    	mov    0x13c(%rbx),%ecx
  8c7b12:	3b 8b 40 01 00 00    	cmp    0x140(%rbx),%ecx
  8c7b18:	73 2a                	jae    8c7b44 <check_lower_drain+0x40a4>
  8c7b1a:	48 8b 53 18          	mov    0x18(%rbx),%rdx
  8c7b1e:	8d 71 01             	lea    0x1(%rcx),%esi
  8c7b21:	48 c1 e8 03          	shr    $0x3,%rax
  8c7b25:	48 c1 e1 04          	shl    $0x4,%rcx
  8c7b29:	89 b3 3c 01 00 00    	mov    %esi,0x13c(%rbx)
  8c7b2f:	48 be 01 00 00 00 01 	movabs $0x8000100000001,%rsi
  8c7b36:	00 08 00 
  8c7b39:	48 89 34 0a          	mov    %rsi,(%rdx,%rcx,1)
  8c7b3d:	48 89 44 0a 08       	mov    %rax,0x8(%rdx,%rcx,1)
  8c7b42:	eb 2a                	jmp    8c7b6e <check_lower_drain+0x40ce>
  8c7b44:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c7b48:	48 8b 00             	mov    (%rax),%rax
  8c7b4b:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c7b52:	75 1a                	jne    8c7b6e <check_lower_drain+0x40ce>
  8c7b54:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c7b5b:	00 00 00 
  8c7b5e:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c7b64:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c7b68:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c7b6e:	31 c9                	xor    %ecx,%ecx
  8c7b70:	83 7c 24 28 20       	cmpl   $0x20,0x28(%rsp)
  8c7b75:	48 89 df             	mov    %rbx,%rdi
  8c7b78:	44 89 e6             	mov    %r12d,%esi
  8c7b7b:	0f 94 c1             	sete   %cl
  8c7b7e:	31 d2                	xor    %edx,%edx
  8c7b80:	4c 8b 44 24 48       	mov    0x48(%rsp),%r8
  8c7b85:	e8 c6 19 01 00       	call   8d9550 <check_lower_operand>
  8c7b8a:	e9 b7 10 00 00       	jmp    8c8c46 <check_lower_drain+0x51a6>
  8c7b8f:	44 89 f0             	mov    %r14d,%eax
  8c7b92:	41 89 c7             	mov    %eax,%r15d
  8c7b95:	4c 89 f8             	mov    %r15,%rax
  8c7b98:	48 c1 e0 20          	shl    $0x20,%rax
  8c7b9c:	45 89 f6             	mov    %r14d,%r14d
  8c7b9f:	c7 84 24 d0 01 00 00 	movl   $0x14,0x1d0(%rsp)
  8c7ba6:	14 00 00 00 
  8c7baa:	44 89 a4 24 d4 01 00 	mov    %r12d,0x1d4(%rsp)
  8c7bb1:	00 
  8c7bb2:	48 c7 84 24 d8 01 00 	movq   $0x0,0x1d8(%rsp)
  8c7bb9:	00 00 00 00 00 
  8c7bbe:	48 89 df             	mov    %rbx,%rdi
  8c7bc1:	4c 09 f0             	or     %r14,%rax
  8c7bc4:	48 89 84 24 e0 01 00 	mov    %rax,0x1e0(%rsp)
  8c7bcb:	00 
  8c7bcc:	48 c7 84 24 e8 01 00 	movq   $0x0,0x1e8(%rsp)
  8c7bd3:	00 00 00 00 00 
  8c7bd8:	c5 fe 6f 84 24 d0 01 	vmovdqu 0x1d0(%rsp),%ymm0
  8c7bdf:	00 00 
  8c7be1:	c5 fe 7f 04 24       	vmovdqu %ymm0,(%rsp)
  8c7be6:	c5 f8 77             	vzeroupper
  8c7be9:	e8 e2 56 00 00       	call   8cd2d0 <check_lower_push>
  8c7bee:	83 7c 24 28 02       	cmpl   $0x2,0x28(%rsp)
  8c7bf3:	74 59                	je     8c7c4e <check_lower_drain+0x41ae>
  8c7bf5:	83 7c 24 28 04       	cmpl   $0x4,0x28(%rsp)
  8c7bfa:	74 52                	je     8c7c4e <check_lower_drain+0x41ae>
  8c7bfc:	40 0f b6 d5          	movzbl %bpl,%edx
  8c7c00:	be 1f 00 00 00       	mov    $0x1f,%esi
  8c7c05:	48 89 df             	mov    %rbx,%rdi
  8c7c08:	4c 89 f9             	mov    %r15,%rcx
  8c7c0b:	e8 10 19 00 00       	call   8c9520 <check_lower_instruction>
  8c7c10:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  8c7c15:	48 8b 8c 24 80 00 00 	mov    0x80(%rsp),%rcx
  8c7c1c:	00 
  8c7c1d:	48 8b 54 24 60       	mov    0x60(%rsp),%rdx
  8c7c22:	48 89 df             	mov    %rbx,%rdi
  8c7c25:	48 8b 40 08          	mov    0x8(%rax),%rax
  8c7c29:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
  8c7c2d:	48 c1 e1 05          	shl    $0x5,%rcx
  8c7c31:	8b 34 08             	mov    (%rax,%rcx,1),%esi
  8c7c34:	e8 97 52 01 00       	call   8dced0 <check_lower_complex_target>
  8c7c39:	ba 01 00 00 00       	mov    $0x1,%edx
  8c7c3e:	48 89 df             	mov    %rbx,%rdi
  8c7c41:	44 89 e6             	mov    %r12d,%esi
  8c7c44:	31 c9                	xor    %ecx,%ecx
  8c7c46:	41 89 c0             	mov    %eax,%r8d
  8c7c49:	e8 02 19 01 00       	call   8d9550 <check_lower_operand>
  8c7c4e:	8b 54 24 20          	mov    0x20(%rsp),%edx
  8c7c52:	be 1f 00 00 00       	mov    $0x1f,%esi
  8c7c57:	48 89 df             	mov    %rbx,%rdi
  8c7c5a:	4c 89 f1             	mov    %r14,%rcx
  8c7c5d:	e8 be 18 00 00       	call   8c9520 <check_lower_instruction>
  8c7c62:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  8c7c67:	4b 8d 4c 6d 00       	lea    0x0(%r13,%r13,2),%rcx
  8c7c6c:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
  8c7c71:	48 89 df             	mov    %rbx,%rdi
  8c7c74:	48 c1 e1 05          	shl    $0x5,%rcx
  8c7c78:	48 8b 40 08          	mov    0x8(%rax),%rax
  8c7c7c:	8b 34 08             	mov    (%rax,%rcx,1),%esi
  8c7c7f:	e8 4c 52 01 00       	call   8dced0 <check_lower_complex_target>
  8c7c84:	48 89 df             	mov    %rbx,%rdi
  8c7c87:	44 89 e6             	mov    %r12d,%esi
  8c7c8a:	31 d2                	xor    %edx,%edx
  8c7c8c:	31 c9                	xor    %ecx,%ecx
  8c7c8e:	41 89 c0             	mov    %eax,%r8d
  8c7c91:	e8 ba 18 01 00       	call   8d9550 <check_lower_operand>
  8c7c96:	e9 ab 0f 00 00       	jmp    8c8c46 <check_lower_drain+0x51a6>
  8c7c9b:	49 8b 4f 38          	mov    0x38(%r15),%rcx
  8c7c9f:	81 3c a9 30 01 00 00 	cmpl   $0x130,(%rcx,%rbp,4)
  8c7ca6:	75 23                	jne    8c7ccb <check_lower_drain+0x422b>
  8c7ca8:	31 c9                	xor    %ecx,%ecx
  8c7caa:	41 83 be 8c 00 00 00 	cmpl   $0x2,0x8c(%r14)
  8c7cb1:	02 
  8c7cb2:	0f 94 c2             	sete   %dl
  8c7cb5:	41 83 fd 01          	cmp    $0x1,%r13d
  8c7cb9:	0f 85 c7 fc ff ff    	jne    8c7986 <check_lower_drain+0x3ee6>
  8c7cbf:	88 d1                	mov    %dl,%cl
  8c7cc1:	39 4c 24 20          	cmp    %ecx,0x20(%rsp)
  8c7cc5:	0f 85 bb fc ff ff    	jne    8c7986 <check_lower_drain+0x3ee6>
  8c7ccb:	48 8d 8c 24 18 02 00 	lea    0x218(%rsp),%rcx
  8c7cd2:	00 
  8c7cd3:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
  8c7cd7:	48 89 df             	mov    %rbx,%rdi
  8c7cda:	c5 f8 11 01          	vmovups %xmm0,(%rcx)
  8c7cde:	48 c7 41 10 00 00 00 	movq   $0x0,0x10(%rcx)
  8c7ce5:	00 
  8c7ce6:	c7 84 24 10 02 00 00 	movl   $0xb,0x210(%rsp)
  8c7ced:	0b 00 00 00 
  8c7cf1:	89 84 24 14 02 00 00 	mov    %eax,0x214(%rsp)
  8c7cf8:	c5 fe 6f 84 24 10 02 	vmovdqu 0x210(%rsp),%ymm0
  8c7cff:	00 00 
  8c7d01:	c5 fe 7f 04 24       	vmovdqu %ymm0,(%rsp)
  8c7d06:	c5 f8 77             	vzeroupper
  8c7d09:	e8 c2 55 00 00       	call   8cd2d0 <check_lower_push>
  8c7d0e:	45 85 ed             	test   %r13d,%r13d
  8c7d11:	0f 84 2f 0f 00 00    	je     8c8c46 <check_lower_drain+0x51a6>
  8c7d17:	44 89 ea             	mov    %r13d,%edx
  8c7d1a:	44 8d 6a ff          	lea    -0x1(%rdx),%r13d
  8c7d1e:	83 fa 20             	cmp    $0x20,%edx
  8c7d21:	77 eb                	ja     8c7d0e <check_lower_drain+0x426e>
  8c7d23:	8b 44 24 20          	mov    0x20(%rsp),%eax
  8c7d27:	44 0f a3 e8          	bt     %r13d,%eax
  8c7d2b:	73 e1                	jae    8c7d0e <check_lower_drain+0x426e>
  8c7d2d:	41 b8 08 00 00 00    	mov    $0x8,%r8d
  8c7d33:	83 c2 02             	add    $0x2,%edx
  8c7d36:	48 89 df             	mov    %rbx,%rdi
  8c7d39:	44 89 e6             	mov    %r12d,%esi
  8c7d3c:	31 c9                	xor    %ecx,%ecx
  8c7d3e:	e8 0d 18 01 00       	call   8d9550 <check_lower_operand>
  8c7d43:	eb c9                	jmp    8c7d0e <check_lower_drain+0x426e>
  8c7d45:	c7 44 24 28 00 00 00 	movl   $0x0,0x28(%rsp)
  8c7d4c:	00 
  8c7d4d:	4c 8b 44 24 58       	mov    0x58(%rsp),%r8
  8c7d52:	89 d7                	mov    %edx,%edi
  8c7d54:	f7 d7                	not    %edi
  8c7d56:	01 c7                	add    %eax,%edi
  8c7d58:	45 8b ac b8 80 00 00 	mov    0x80(%r8,%rdi,4),%r13d
  8c7d5f:	00 
  8c7d60:	41 0f b6 ed          	movzbl %r13b,%ebp
  8c7d64:	44 8d 75 ff          	lea    -0x1(%rbp),%r14d
  8c7d68:	41 83 fe 0a          	cmp    $0xa,%r14d
  8c7d6c:	40 0f 93 c7          	setae  %dil
  8c7d70:	41 f7 c5 00 05 00 00 	test   $0x500,%r13d
  8c7d77:	41 0f 95 c0          	setne  %r8b
  8c7d7b:	41 08 f8             	or     %dil,%r8b
  8c7d7e:	0f 85 25 0b 00 00    	jne    8c88a9 <check_lower_drain+0x4e09>
  8c7d84:	4c 03 54 24 70       	add    0x70(%rsp),%r10
  8c7d89:	41 83 7a 44 00       	cmpl   $0x0,0x44(%r10)
  8c7d8e:	0f 85 15 0b 00 00    	jne    8c88a9 <check_lower_drain+0x4e09>
  8c7d94:	48 8b bc 24 80 00 00 	mov    0x80(%rsp),%rdi
  8c7d9b:	00 
  8c7d9c:	48 8b 3f             	mov    (%rdi),%rdi
  8c7d9f:	4c 8b 07             	mov    (%rdi),%r8
  8c7da2:	48 89 bc 24 88 00 00 	mov    %rdi,0x88(%rsp)
  8c7da9:	00 
  8c7daa:	48 8b 7c 24 68       	mov    0x68(%rsp),%rdi
  8c7daf:	41 8b 3c b8          	mov    (%r8,%rdi,4),%edi
  8c7db3:	4c 89 84 24 98 00 00 	mov    %r8,0x98(%rsp)
  8c7dba:	00 
  8c7dbb:	85 ff                	test   %edi,%edi
  8c7dbd:	89 7c 24 60          	mov    %edi,0x60(%rsp)
  8c7dc1:	40 0f 94 c7          	sete   %dil
  8c7dc5:	40 22 7c 24 28       	and    0x28(%rsp),%dil
  8c7dca:	40 80 ff 01          	cmp    $0x1,%dil
  8c7dce:	75 34                	jne    8c7e04 <check_lower_drain+0x4364>
  8c7dd0:	48 8b bc 24 88 00 00 	mov    0x88(%rsp),%rdi
  8c7dd7:	00 
  8c7dd8:	4c 8b 87 90 02 00 00 	mov    0x290(%rdi),%r8
  8c7ddf:	41 8d 79 ff          	lea    -0x1(%r9),%edi
  8c7de3:	41 80 3c 38 00       	cmpb   $0x0,(%r8,%rdi,1)
  8c7de8:	74 1a                	je     8c7e04 <check_lower_drain+0x4364>
  8c7dea:	4c 8b 84 24 88 00 00 	mov    0x88(%rsp),%r8
  8c7df1:	00 
  8c7df2:	4d 8b 80 78 02 00 00 	mov    0x278(%r8),%r8
  8c7df9:	41 80 3c 38 00       	cmpb   $0x0,(%r8,%rdi,1)
  8c7dfe:	0f 84 a5 0a 00 00    	je     8c88a9 <check_lower_drain+0x4e09>
  8c7e04:	41 8b 7a 0c          	mov    0xc(%r10),%edi
  8c7e08:	85 ff                	test   %edi,%edi
  8c7e0a:	74 20                	je     8c7e2c <check_lower_drain+0x438c>
  8c7e0c:	41 83 7a 54 00       	cmpl   $0x0,0x54(%r10)
  8c7e11:	75 19                	jne    8c7e2c <check_lower_drain+0x438c>
  8c7e13:	45 0f b7 42 08       	movzwl 0x8(%r10),%r8d
  8c7e18:	41 f7 c0 10 08 00 00 	test   $0x810,%r8d
  8c7e1f:	75 0b                	jne    8c7e2c <check_lower_drain+0x438c>
  8c7e21:	41 83 7a 04 00       	cmpl   $0x0,0x4(%r10)
  8c7e26:	0f 84 59 0a 00 00    	je     8c8885 <check_lower_drain+0x4de5>
  8c7e2c:	83 7c 24 60 00       	cmpl   $0x0,0x60(%rsp)
  8c7e31:	0f 85 72 0a 00 00    	jne    8c88a9 <check_lower_drain+0x4e09>
  8c7e37:	41 83 7a 04 01       	cmpl   $0x1,0x4(%r10)
  8c7e3c:	40 0f 94 c7          	sete   %dil
  8c7e40:	40 22 7c 24 28       	and    0x28(%rsp),%dil
  8c7e45:	40 80 ff 01          	cmp    $0x1,%dil
  8c7e49:	0f 85 5a 0a 00 00    	jne    8c88a9 <check_lower_drain+0x4e09>
  8c7e4f:	48 8b 7b 68          	mov    0x68(%rbx),%rdi
  8c7e53:	4c 8b b4 24 80 00 00 	mov    0x80(%rsp),%r14
  8c7e5a:	00 
  8c7e5b:	46 8b 14 8f          	mov    (%rdi,%r9,4),%r10d
  8c7e5f:	49 8b be 80 00 00 00 	mov    0x80(%r14),%rdi
  8c7e66:	42 8b 3c 8f          	mov    (%rdi,%r9,4),%edi
  8c7e6a:	85 ff                	test   %edi,%edi
  8c7e6c:	41 0f 94 c1          	sete   %r9b
  8c7e70:	45 31 c0             	xor    %r8d,%r8d
  8c7e73:	41 83 fa ff          	cmp    $0xffffffff,%r10d
  8c7e77:	41 0f 94 c0          	sete   %r8b
  8c7e7b:	44 0f 44 d7          	cmove  %edi,%r10d
  8c7e7f:	43 8d 7c 00 02       	lea    0x2(%r8,%r8,1),%edi
  8c7e84:	45 20 c1             	and    %r8b,%r9b
  8c7e87:	4c 89 54 24 28       	mov    %r10,0x28(%rsp)
  8c7e8c:	89 7c 24 60          	mov    %edi,0x60(%rsp)
  8c7e90:	8b 7c 24 78          	mov    0x78(%rsp),%edi
  8c7e94:	44 08 cf             	or     %r9b,%dil
  8c7e97:	0f 84 e5 06 00 00    	je     8c8582 <check_lower_drain+0x4ae2>
  8c7e9d:	48 8b 7c 24 38       	mov    0x38(%rsp),%rdi
  8c7ea2:	48 8b 7f 08          	mov    0x8(%rdi),%rdi
  8c7ea6:	42 8b 3c bf          	mov    (%rdi,%r15,4),%edi
  8c7eaa:	89 bb 64 01 00 00    	mov    %edi,0x164(%rbx)
  8c7eb0:	45 84 c9             	test   %r9b,%r9b
  8c7eb3:	0f 85 03 0a 00 00    	jne    8c88bc <check_lower_drain+0x4e1c>
  8c7eb9:	4c 8b 54 24 38       	mov    0x38(%rsp),%r10
  8c7ebe:	ff c8                	dec    %eax
  8c7ec0:	45 31 c9             	xor    %r9d,%r9d
  8c7ec3:	45 31 ed             	xor    %r13d,%r13d
  8c7ec6:	49 83 c2 08          	add    $0x8,%r10
  8c7eca:	44 8b 44 24 60       	mov    0x60(%rsp),%r8d
  8c7ecf:	4c 8b 74 24 58       	mov    0x58(%rsp),%r14
  8c7ed4:	bf 00 00 00 00       	mov    $0x0,%edi
  8c7ed9:	45 09 c8             	or     %r9d,%r8d
  8c7edc:	66 81 fe ff 00       	cmp    $0xff,%si
  8c7ee1:	41 89 f1             	mov    %esi,%r9d
  8c7ee4:	44 0f 44 cf          	cmove  %edi,%r9d
  8c7ee8:	89 c7                	mov    %eax,%edi
  8c7eea:	29 d7                	sub    %edx,%edi
  8c7eec:	41 c1 e1 10          	shl    $0x10,%r9d
  8c7ef0:	45 09 c1             	or     %r8d,%r9d
  8c7ef3:	45 0f b7 44 7e 20    	movzwl 0x20(%r14,%rdi,2),%r8d
  8c7ef9:	83 7c 24 20 0f       	cmpl   $0xf,0x20(%rsp)
  8c7efe:	40 b7 01             	mov    $0x1,%dil
  8c7f01:	77 1e                	ja     8c7f21 <check_lower_drain+0x4481>
  8c7f03:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8c7f08:	89 c0                	mov    %eax,%eax
  8c7f0a:	40 b7 03             	mov    $0x3,%dil
  8c7f0d:	0f b7 44 42 20       	movzwl 0x20(%rdx,%rax,2),%eax
  8c7f12:	c1 e0 08             	shl    $0x8,%eax
  8c7f15:	41 09 c0             	or     %eax,%r8d
  8c7f18:	8b 44 24 48          	mov    0x48(%rsp),%eax
  8c7f1c:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
  8c7f21:	66 81 fe ff 00       	cmp    $0xff,%si
  8c7f26:	48 8b 53 20          	mov    0x20(%rbx),%rdx
  8c7f2a:	8b 6c 24 44          	mov    0x44(%rsp),%ebp
  8c7f2e:	c4 c1 79 6e c1       	vmovd  %r9d,%xmm0
  8c7f33:	c5 fa 7e 4c 24 28    	vmovq  0x28(%rsp),%xmm1
  8c7f39:	0f 95 c0             	setne  %al
  8c7f3c:	ff c1                	inc    %ecx
  8c7f3e:	c0 e0 02             	shl    $0x2,%al
  8c7f41:	40 08 f8             	or     %dil,%al
  8c7f44:	c5 fb 92 c8          	kmovd  %eax,%k1
  8c7f48:	0f b6 f0             	movzbl %al,%esi
  8c7f4b:	c5 f9 90 d1          	kmovb  %k1,%k2
  8c7f4f:	c1 e5 10             	shl    $0x10,%ebp
  8c7f52:	62 b2 7d 0a 63 04 1a 	vpcompressb %xmm0,(%rdx,%r11,1){%k2}
  8c7f59:	44 09 c5             	or     %r8d,%ebp
  8c7f5c:	48 8b 43 28          	mov    0x28(%rbx),%rax
  8c7f60:	8b 93 38 01 00 00    	mov    0x138(%rbx),%edx
  8c7f66:	c5 f9 6e c5          	vmovd  %ebp,%xmm0
  8c7f6a:	62 f2 7d 0a 63 04 10 	vpcompressb %xmm0,(%rax,%rdx,1){%k2}
  8c7f71:	c4 c1 f9 6e c5       	vmovq  %r13,%xmm0
  8c7f76:	48 8b 43 30          	mov    0x30(%rbx),%rax
  8c7f7a:	8b 93 38 01 00 00    	mov    0x138(%rbx),%edx
  8c7f80:	c5 f1 6c c0          	vpunpcklqdq %xmm0,%xmm1,%xmm0
  8c7f84:	62 f2 fd 49 8b 04 d0 	vpcompressq %zmm0,(%rax,%rdx,8){%k1}
  8c7f8b:	f3 0f b8 d6          	popcnt %esi,%edx
  8c7f8f:	01 93 38 01 00 00    	add    %edx,0x138(%rbx)
  8c7f95:	48 8b 54 24 68       	mov    0x68(%rsp),%rdx
  8c7f9a:	49 8b 02             	mov    (%r10),%rax
  8c7f9d:	8b 04 90             	mov    (%rax,%rdx,4),%eax
  8c7fa0:	89 83 64 01 00 00    	mov    %eax,0x164(%rbx)
  8c7fa6:	e9 66 09 00 00       	jmp    8c8911 <check_lower_drain+0x4e71>
  8c7fab:	83 7c 24 28 38       	cmpl   $0x38,0x28(%rsp)
  8c7fb0:	74 7d                	je     8c802f <check_lower_drain+0x458f>
  8c7fb2:	83 7c 24 28 22       	cmpl   $0x22,0x28(%rsp)
  8c7fb7:	0f 85 85 00 00 00    	jne    8c8042 <check_lower_drain+0x45a2>
  8c7fbd:	48 89 df             	mov    %rbx,%rdi
  8c7fc0:	44 89 e6             	mov    %r12d,%esi
  8c7fc3:	c5 f8 77             	vzeroupper
  8c7fc6:	e8 05 53 01 00       	call   8dd2d0 <check_lower_call>
  8c7fcb:	e9 76 0c 00 00       	jmp    8c8c46 <check_lower_drain+0x51a6>
  8c7fd0:	48 89 df             	mov    %rbx,%rdi
  8c7fd3:	e8 28 60 00 00       	call   8ce000 <check_lower_label>
  8c7fd8:	48 89 df             	mov    %rbx,%rdi
  8c7fdb:	89 44 24 20          	mov    %eax,0x20(%rsp)
  8c7fdf:	e8 1c 60 00 00       	call   8ce000 <check_lower_label>
  8c7fe4:	41 89 c7             	mov    %eax,%r15d
  8c7fe7:	40 84 ed             	test   %bpl,%bpl
  8c7fea:	0f 84 03 01 00 00    	je     8c80f3 <check_lower_drain+0x4653>
  8c7ff0:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  8c7ff5:	c1 e8 03             	shr    $0x3,%eax
  8c7ff8:	b1 ff                	mov    $0xff,%cl
  8c7ffa:	3b 83 b0 01 00 00    	cmp    0x1b0(%rbx),%eax
  8c8000:	73 0b                	jae    8c800d <check_lower_drain+0x456d>
  8c8002:	48 8b 8b 98 01 00 00 	mov    0x198(%rbx),%rcx
  8c8009:	0f b6 0c 01          	movzbl (%rcx,%rax,1),%ecx
  8c800d:	0f b6 f1             	movzbl %cl,%esi
  8c8010:	48 89 df             	mov    %rbx,%rdi
  8c8013:	e8 d8 65 ff ff       	call   8be5f0 <check_lower_temporary>
  8c8018:	89 c0                	mov    %eax,%eax
  8c801a:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
  8c801f:	48 89 df             	mov    %rbx,%rdi
  8c8022:	44 89 fe             	mov    %r15d,%esi
  8c8025:	e8 36 52 01 00       	call   8dd260 <check_lower_mark>
  8c802a:	e9 e4 00 00 00       	jmp    8c8113 <check_lower_drain+0x4673>
  8c802f:	48 89 df             	mov    %rbx,%rdi
  8c8032:	44 89 e6             	mov    %r12d,%esi
  8c8035:	c5 f8 77             	vzeroupper
  8c8038:	e8 03 60 01 00       	call   8de040 <check_lower_varargs_prepare>
  8c803d:	e9 04 0c 00 00       	jmp    8c8c46 <check_lower_drain+0x51a6>
  8c8042:	83 7c 24 28 1b       	cmpl   $0x1b,0x28(%rsp)
  8c8047:	0f 85 8b 01 00 00    	jne    8c81d8 <check_lower_drain+0x4738>
  8c804d:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  8c8052:	4b 8d 74 6d 00       	lea    0x0(%r13,%r13,2),%rsi
  8c8057:	48 c1 e6 05          	shl    $0x5,%rsi
  8c805b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8c805f:	f6 44 32 08 04       	testb  $0x4,0x8(%rdx,%rsi,1)
  8c8064:	0f 84 b4 01 00 00    	je     8c821e <check_lower_drain+0x477e>
  8c806a:	31 d2                	xor    %edx,%edx
  8c806c:	48 83 7c 24 78 00    	cmpq   $0x0,0x78(%rsp)
  8c8072:	48 89 df             	mov    %rbx,%rdi
  8c8075:	44 89 e6             	mov    %r12d,%esi
  8c8078:	0f 95 c2             	setne  %dl
  8c807b:	c5 f8 77             	vzeroupper
  8c807e:	e8 cd 6d 01 00       	call   8dee50 <check_lower_bit_assign>
  8c8083:	e9 be 0b 00 00       	jmp    8c8c46 <check_lower_drain+0x51a6>
  8c8088:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  8c808d:	44 0f b6 bc 24 d0 01 	movzbl 0x1d0(%rsp),%r15d
  8c8094:	00 00 
  8c8096:	83 f9 16             	cmp    $0x16,%ecx
  8c8099:	44 89 fa             	mov    %r15d,%edx
  8c809c:	0f 94 c0             	sete   %al
  8c809f:	83 f9 15             	cmp    $0x15,%ecx
  8c80a2:	0f 94 c1             	sete   %cl
  8c80a5:	80 f2 01             	xor    $0x1,%dl
  8c80a8:	44 20 f8             	and    %r15b,%al
  8c80ab:	20 ca                	and    %cl,%dl
  8c80ad:	08 c2                	or     %al,%dl
  8c80af:	80 fa 01             	cmp    $0x1,%dl
  8c80b2:	0f 85 bd 02 00 00    	jne    8c8375 <check_lower_drain+0x48d5>
  8c80b8:	8b 83 3c 01 00 00    	mov    0x13c(%rbx),%eax
  8c80be:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c80c4:	0f 83 52 04 00 00    	jae    8c851c <check_lower_drain+0x4a7c>
  8c80ca:	48 8b 4b 18          	mov    0x18(%rbx),%rcx
  8c80ce:	8d 50 01             	lea    0x1(%rax),%edx
  8c80d1:	48 c1 e0 04          	shl    $0x4,%rax
  8c80d5:	89 93 3c 01 00 00    	mov    %edx,0x13c(%rbx)
  8c80db:	48 ba 01 00 00 00 01 	movabs $0x5000100000001,%rdx
  8c80e2:	00 05 00 
  8c80e5:	48 89 14 01          	mov    %rdx,(%rcx,%rax,1)
  8c80e9:	4c 89 7c 01 08       	mov    %r15,0x8(%rcx,%rax,1)
  8c80ee:	e9 a9 02 00 00       	jmp    8c839c <check_lower_drain+0x48fc>
  8c80f3:	48 89 df             	mov    %rbx,%rdi
  8c80f6:	44 89 fe             	mov    %r15d,%esi
  8c80f9:	e8 62 51 01 00       	call   8dd260 <check_lower_mark>
  8c80fe:	83 7c 24 28 17       	cmpl   $0x17,0x28(%rsp)
  8c8103:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8c8108:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
  8c810d:	0f 85 c0 02 00 00    	jne    8c83d3 <check_lower_drain+0x4933>
  8c8113:	45 8b 06             	mov    (%r14),%r8d
  8c8116:	ba 02 00 00 00       	mov    $0x2,%edx
  8c811b:	48 89 df             	mov    %rbx,%rdi
  8c811e:	44 89 e6             	mov    %r12d,%esi
  8c8121:	31 c9                	xor    %ecx,%ecx
  8c8123:	e8 28 14 01 00       	call   8d9550 <check_lower_operand>
  8c8128:	8b 74 24 20          	mov    0x20(%rsp),%esi
  8c812c:	48 89 df             	mov    %rbx,%rdi
  8c812f:	e8 2c 51 01 00       	call   8dd260 <check_lower_mark>
  8c8134:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  8c8139:	be 27 00 00 00       	mov    $0x27,%esi
  8c813e:	44 89 f9             	mov    %r15d,%ecx
  8c8141:	48 89 df             	mov    %rbx,%rdi
  8c8144:	3c 01                	cmp    $0x1,%al
  8c8146:	0f b6 d0             	movzbl %al,%edx
  8c8149:	83 de 00             	sbb    $0x0,%esi
  8c814c:	e8 cf 13 00 00       	call   8c9520 <check_lower_instruction>
  8c8151:	83 7c 24 28 17       	cmpl   $0x17,0x28(%rsp)
  8c8156:	75 59                	jne    8c81b1 <check_lower_drain+0x4711>
  8c8158:	45 8b 06             	mov    (%r14),%r8d
  8c815b:	44 3b ac 24 80 00 00 	cmp    0x80(%rsp),%r13d
  8c8162:	00 
  8c8163:	0f 85 af 02 00 00    	jne    8c8418 <check_lower_drain+0x4978>
  8c8169:	4c 8b 74 24 48       	mov    0x48(%rsp),%r14
  8c816e:	48 89 df             	mov    %rbx,%rdi
  8c8171:	44 89 c2             	mov    %r8d,%edx
  8c8174:	44 89 f6             	mov    %r14d,%esi
  8c8177:	e8 14 52 00 00       	call   8cd390 <check_lower_convert>
  8c817c:	41 c1 ee 03          	shr    $0x3,%r14d
  8c8180:	b1 ff                	mov    $0xff,%cl
  8c8182:	44 3b b3 b0 01 00 00 	cmp    0x1b0(%rbx),%r14d
  8c8189:	73 0c                	jae    8c8197 <check_lower_drain+0x46f7>
  8c818b:	48 8b 8b 98 01 00 00 	mov    0x198(%rbx),%rcx
  8c8192:	42 0f b6 0c 31       	movzbl (%rcx,%r14,1),%ecx
  8c8197:	0f b6 d1             	movzbl %cl,%edx
  8c819a:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  8c819f:	be 02 00 00 00       	mov    $0x2,%esi
  8c81a4:	48 89 df             	mov    %rbx,%rdi
  8c81a7:	e8 74 13 00 00       	call   8c9520 <check_lower_instruction>
  8c81ac:	e9 79 02 00 00       	jmp    8c842a <check_lower_drain+0x498a>
  8c81b1:	4c 8b 74 24 60       	mov    0x60(%rsp),%r14
  8c81b6:	48 89 df             	mov    %rbx,%rdi
  8c81b9:	31 d2                	xor    %edx,%edx
  8c81bb:	44 89 f6             	mov    %r14d,%esi
  8c81be:	e8 ad 4d 01 00       	call   8dcf70 <check_lower_truth>
  8c81c3:	ba 01 00 00 00       	mov    $0x1,%edx
  8c81c8:	48 89 df             	mov    %rbx,%rdi
  8c81cb:	44 89 e6             	mov    %r12d,%esi
  8c81ce:	31 c9                	xor    %ecx,%ecx
  8c81d0:	45 89 f0             	mov    %r14d,%r8d
  8c81d3:	e9 4d 02 00 00       	jmp    8c8425 <check_lower_drain+0x4985>
  8c81d8:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  8c81dd:	8d 51 da             	lea    -0x26(%rcx),%edx
  8c81e0:	83 fa 0d             	cmp    $0xd,%edx
  8c81e3:	77 39                	ja     8c821e <check_lower_drain+0x477e>
  8c81e5:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  8c81ea:	4b 8d 7c 6d 00       	lea    0x0(%r13,%r13,2),%rdi
  8c81ef:	b2 01                	mov    $0x1,%dl
  8c81f1:	48 c1 e7 05          	shl    $0x5,%rdi
  8c81f5:	48 8b 70 08          	mov    0x8(%rax),%rsi
  8c81f9:	f6 44 3e 08 04       	testb  $0x4,0x8(%rsi,%rdi,1)
  8c81fe:	74 20                	je     8c8220 <check_lower_drain+0x4780>
  8c8200:	31 d2                	xor    %edx,%edx
  8c8202:	48 83 7c 24 78 00    	cmpq   $0x0,0x78(%rsp)
  8c8208:	48 89 df             	mov    %rbx,%rdi
  8c820b:	44 89 e6             	mov    %r12d,%esi
  8c820e:	0f 95 c2             	setne  %dl
  8c8211:	c5 f8 77             	vzeroupper
  8c8214:	e8 97 6f 01 00       	call   8df1b0 <check_lower_bit_update>
  8c8219:	e9 28 0a 00 00       	jmp    8c8c46 <check_lower_drain+0x51a6>
  8c821e:	31 d2                	xor    %edx,%edx
  8c8220:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  8c8225:	8d 71 e5             	lea    -0x1b(%rcx),%esi
  8c8228:	f7 c6 f7 ff ff ff    	test   $0xfffffff7,%esi
  8c822e:	40 0f 94 c6          	sete   %sil
  8c8232:	40 22 74 24 70       	and    0x70(%rsp),%sil
  8c8237:	40 80 fe 01          	cmp    $0x1,%sil
  8c823b:	0f 85 8e 02 00 00    	jne    8c84cf <check_lower_drain+0x4a2f>
  8c8241:	83 7c 24 28 23       	cmpl   $0x23,0x28(%rsp)
  8c8246:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  8c824c:	75 0b                	jne    8c8259 <check_lower_drain+0x47b9>
  8c824e:	48 8b 8b b8 00 00 00 	mov    0xb8(%rbx),%rcx
  8c8255:	44 8b 2c a9          	mov    (%rcx,%rbp,4),%r13d
  8c8259:	c4 e2 79 22 05 2a f1 	vpmovsxbq -0x420ed6(%rip),%xmm0        # 4a738c <cbuiltin_test_generated.edges+0xacfc>
  8c8260:	bd ff 
  8c8262:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  8c8267:	41 c1 e8 03          	shr    $0x3,%r8d
  8c826b:	c5 f8 29 84 24 b0 01 	vmovaps %xmm0,0x1b0(%rsp)
  8c8272:	00 00 
  8c8274:	48 8b 08             	mov    (%rax),%rcx
  8c8277:	42 80 3c 01 0f       	cmpb   $0xf,(%rcx,%r8,1)
  8c827c:	75 11                	jne    8c828f <check_lower_drain+0x47ef>
  8c827e:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  8c8283:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8c8287:	46 8b 04 81          	mov    (%rcx,%r8,4),%r8d
  8c828b:	41 c1 e8 03          	shr    $0x3,%r8d
  8c828f:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  8c8294:	48 8b 6c 24 28       	mov    0x28(%rsp),%rbp
  8c8299:	45 31 ff             	xor    %r15d,%r15d
  8c829c:	48 89 df             	mov    %rbx,%rdi
  8c829f:	48 8b 48 38          	mov    0x38(%rax),%rcx
  8c82a3:	83 fd 23             	cmp    $0x23,%ebp
  8c82a6:	41 0f 95 c7          	setne  %r15b
  8c82aa:	48 83 7c 24 78 00    	cmpq   $0x0,0x78(%rsp)
  8c82b0:	4a 8b 04 c1          	mov    (%rcx,%r8,8),%rax
  8c82b4:	48 8d 8c 24 c9 01 00 	lea    0x1c9(%rsp),%rcx
  8c82bb:	00 
  8c82bc:	48 89 84 24 c0 01 00 	mov    %rax,0x1c0(%rsp)
  8c82c3:	00 
  8c82c4:	0f 94 84 24 c8 01 00 	sete   0x1c8(%rsp)
  8c82cb:	00 
  8c82cc:	c7 41 03 00 00 00 00 	movl   $0x0,0x3(%rcx)
  8c82d3:	c7 01 00 00 00 00    	movl   $0x0,(%rcx)
  8c82d9:	c5 fe 6f 84 24 b0 01 	vmovdqu 0x1b0(%rsp),%ymm0
  8c82e0:	00 00 
  8c82e2:	c5 fe 7f 04 24       	vmovdqu %ymm0,(%rsp)
  8c82e7:	c5 f8 77             	vzeroupper
  8c82ea:	e8 e1 4f 00 00       	call   8cd2d0 <check_lower_push>
  8c82ef:	45 8b 06             	mov    (%r14),%r8d
  8c82f2:	48 89 df             	mov    %rbx,%rdi
  8c82f5:	44 89 e6             	mov    %r12d,%esi
  8c82f8:	44 89 fa             	mov    %r15d,%edx
  8c82fb:	31 c9                	xor    %ecx,%ecx
  8c82fd:	e8 4e 12 01 00       	call   8d9550 <check_lower_operand>
  8c8302:	83 fd 1b             	cmp    $0x1b,%ebp
  8c8305:	0f 84 0a ee ff ff    	je     8c7115 <check_lower_drain+0x3675>
  8c830b:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  8c8310:	48 8b 00             	mov    (%rax),%rax
  8c8313:	44 3b a8 84 03 00 00 	cmp    0x384(%rax),%r13d
  8c831a:	0f 83 fc 08 00 00    	jae    8c8c1c <check_lower_drain+0x517c>
  8c8320:	48 8d 8c 24 98 01 00 	lea    0x198(%rsp),%rcx
  8c8327:	00 
  8c8328:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
  8c832c:	c5 fa 7f 01          	vmovdqu %xmm0,(%rcx)
  8c8330:	48 c7 41 10 00 00 00 	movq   $0x0,0x10(%rcx)
  8c8337:	00 
  8c8338:	c7 84 24 90 01 00 00 	movl   $0xa,0x190(%rsp)
  8c833f:	0a 00 00 00 
  8c8343:	44 89 e9             	mov    %r13d,%ecx
  8c8346:	48 8b 80 70 02 00 00 	mov    0x270(%rax),%rax
  8c834d:	8b 04 88             	mov    (%rax,%rcx,4),%eax
  8c8350:	89 84 24 94 01 00 00 	mov    %eax,0x194(%rsp)
  8c8357:	c5 fe 6f 84 24 90 01 	vmovdqu 0x190(%rsp),%ymm0
  8c835e:	00 00 
  8c8360:	48 89 df             	mov    %rbx,%rdi
  8c8363:	c5 fe 7f 04 24       	vmovdqu %ymm0,(%rsp)
  8c8368:	c5 f8 77             	vzeroupper
  8c836b:	e8 60 4f 00 00       	call   8cd2d0 <check_lower_push>
  8c8370:	e9 d1 08 00 00       	jmp    8c8c46 <check_lower_drain+0x51a6>
  8c8375:	4c 8b 74 24 60       	mov    0x60(%rsp),%r14
  8c837a:	48 89 df             	mov    %rbx,%rdi
  8c837d:	31 d2                	xor    %edx,%edx
  8c837f:	44 89 f6             	mov    %r14d,%esi
  8c8382:	e8 e9 4b 01 00       	call   8dcf70 <check_lower_truth>
  8c8387:	ba 01 00 00 00       	mov    $0x1,%edx
  8c838c:	48 89 df             	mov    %rbx,%rdi
  8c838f:	44 89 e6             	mov    %r12d,%esi
  8c8392:	31 c9                	xor    %ecx,%ecx
  8c8394:	45 89 f0             	mov    %r14d,%r8d
  8c8397:	e8 b4 11 01 00       	call   8d9550 <check_lower_operand>
  8c839c:	44 84 fd             	test   %r15b,%bpl
  8c839f:	0f 85 a1 08 00 00    	jne    8c8c46 <check_lower_drain+0x51a6>
  8c83a5:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  8c83aa:	44 89 ea             	mov    %r13d,%edx
  8c83ad:	48 8b 01             	mov    (%rcx),%rax
  8c83b0:	48 8b 71 08          	mov    0x8(%rcx),%rsi
  8c83b4:	48 8b 38             	mov    (%rax),%rdi
  8c83b7:	e8 e4 4d 01 00       	call   8dd1a0 <check_program_runtime_effects>
  8c83bc:	b9 08 00 00 00       	mov    $0x8,%ecx
  8c83c1:	48 89 4c 24 48       	mov    %rcx,0x48(%rsp)
  8c83c6:	84 c0                	test   %al,%al
  8c83c8:	0f 85 f2 00 00 00    	jne    8c84c0 <check_lower_drain+0x4a20>
  8c83ce:	e9 73 08 00 00       	jmp    8c8c46 <check_lower_drain+0x51a6>
  8c83d3:	8b 83 3c 01 00 00    	mov    0x13c(%rbx),%eax
  8c83d9:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c83df:	0f 83 6a 01 00 00    	jae    8c854f <check_lower_drain+0x4aaf>
  8c83e5:	31 c9                	xor    %ecx,%ecx
  8c83e7:	83 7c 24 28 16       	cmpl   $0x16,0x28(%rsp)
  8c83ec:	48 8b 53 18          	mov    0x18(%rbx),%rdx
  8c83f0:	8d 70 01             	lea    0x1(%rax),%esi
  8c83f3:	89 b3 3c 01 00 00    	mov    %esi,0x13c(%rbx)
  8c83f9:	48 be 01 00 00 00 01 	movabs $0x5000100000001,%rsi
  8c8400:	00 05 00 
  8c8403:	0f 94 c1             	sete   %cl
  8c8406:	48 c1 e0 04          	shl    $0x4,%rax
  8c840a:	48 89 34 02          	mov    %rsi,(%rdx,%rax,1)
  8c840e:	48 89 4c 02 08       	mov    %rcx,0x8(%rdx,%rax,1)
  8c8413:	e9 10 fd ff ff       	jmp    8c8128 <check_lower_drain+0x4688>
  8c8418:	48 89 df             	mov    %rbx,%rdi
  8c841b:	44 89 e6             	mov    %r12d,%esi
  8c841e:	ba 01 00 00 00       	mov    $0x1,%edx
  8c8423:	31 c9                	xor    %ecx,%ecx
  8c8425:	e8 26 11 01 00       	call   8d9550 <check_lower_operand>
  8c842a:	31 f6                	xor    %esi,%esi
  8c842c:	83 7c 24 28 16       	cmpl   $0x16,0x28(%rsp)
  8c8431:	8b 4c 24 20          	mov    0x20(%rsp),%ecx
  8c8435:	ba 05 00 00 00       	mov    $0x5,%edx
  8c843a:	48 89 df             	mov    %rbx,%rdi
  8c843d:	40 0f 94 c6          	sete   %sil
  8c8441:	83 ce 24             	or     $0x24,%esi
  8c8444:	e8 d7 10 00 00       	call   8c9520 <check_lower_instruction>
  8c8449:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  8c844e:	48 89 df             	mov    %rbx,%rdi
  8c8451:	31 d2                	xor    %edx,%edx
  8c8453:	e8 18 4b 01 00       	call   8dcf70 <check_lower_truth>
  8c8458:	40 84 ed             	test   %bpl,%bpl
  8c845b:	74 63                	je     8c84c0 <check_lower_drain+0x4a20>
  8c845d:	4c 8b 74 24 48       	mov    0x48(%rsp),%r14
  8c8462:	41 c1 ee 03          	shr    $0x3,%r14d
  8c8466:	40 b5 ff             	mov    $0xff,%bpl
  8c8469:	b0 ff                	mov    $0xff,%al
  8c846b:	44 3b b3 b0 01 00 00 	cmp    0x1b0(%rbx),%r14d
  8c8472:	73 0c                	jae    8c8480 <check_lower_drain+0x49e0>
  8c8474:	48 8b 83 98 01 00 00 	mov    0x198(%rbx),%rax
  8c847b:	42 0f b6 04 30       	movzbl (%rax,%r14,1),%eax
  8c8480:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  8c8485:	0f b6 d0             	movzbl %al,%edx
  8c8488:	be 02 00 00 00       	mov    $0x2,%esi
  8c848d:	48 89 df             	mov    %rbx,%rdi
  8c8490:	e8 8b 10 00 00       	call   8c9520 <check_lower_instruction>
  8c8495:	44 3b b3 b0 01 00 00 	cmp    0x1b0(%rbx),%r14d
  8c849c:	73 0c                	jae    8c84aa <check_lower_drain+0x4a0a>
  8c849e:	48 8b 83 98 01 00 00 	mov    0x198(%rbx),%rax
  8c84a5:	42 0f b6 2c 30       	movzbl (%rax,%r14,1),%ebp
  8c84aa:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  8c84af:	40 0f b6 d5          	movzbl %bpl,%edx
  8c84b3:	be 1f 00 00 00       	mov    $0x1f,%esi
  8c84b8:	48 89 df             	mov    %rbx,%rdi
  8c84bb:	e8 60 10 00 00       	call   8c9520 <check_lower_instruction>
  8c84c0:	48 89 df             	mov    %rbx,%rdi
  8c84c3:	44 89 e6             	mov    %r12d,%esi
  8c84c6:	31 d2                	xor    %edx,%edx
  8c84c8:	31 c9                	xor    %ecx,%ecx
  8c84ca:	e9 b1 f6 ff ff       	jmp    8c7b80 <check_lower_drain+0x40e0>
  8c84cf:	83 7c 24 28 23       	cmpl   $0x23,0x28(%rsp)
  8c84d4:	74 0b                	je     8c84e1 <check_lower_drain+0x4a41>
  8c84d6:	83 7c 24 28 1b       	cmpl   $0x1b,0x28(%rsp)
  8c84db:	0f 85 cb 01 00 00    	jne    8c86ac <check_lower_drain+0x4c0c>
  8c84e1:	83 7c 24 28 23       	cmpl   $0x23,0x28(%rsp)
  8c84e6:	0f 85 d2 00 00 00    	jne    8c85be <check_lower_drain+0x4b1e>
  8c84ec:	48 8b 83 b8 00 00 00 	mov    0xb8(%rbx),%rax
  8c84f3:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  8c84f8:	8b 04 a8             	mov    (%rax,%rbp,4),%eax
  8c84fb:	48 39 c8             	cmp    %rcx,%rax
  8c84fe:	0f 84 ba 00 00 00    	je     8c85be <check_lower_drain+0x4b1e>
  8c8504:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  8c8509:	48 c1 e0 02          	shl    $0x2,%rax
  8c850d:	48 8b 09             	mov    (%rcx),%rcx
  8c8510:	48 03 81 70 02 00 00 	add    0x270(%rcx),%rax
  8c8517:	e9 c7 00 00 00       	jmp    8c85e3 <check_lower_drain+0x4b43>
  8c851c:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c8520:	48 8b 00             	mov    (%rax),%rax
  8c8523:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c852a:	0f 85 6c fe ff ff    	jne    8c839c <check_lower_drain+0x48fc>
  8c8530:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c8537:	00 00 00 
  8c853a:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c8540:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c8544:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c854a:	e9 4d fe ff ff       	jmp    8c839c <check_lower_drain+0x48fc>
  8c854f:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c8553:	48 8b 00             	mov    (%rax),%rax
  8c8556:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c855d:	0f 85 c5 fb ff ff    	jne    8c8128 <check_lower_drain+0x4688>
  8c8563:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c856a:	00 00 00 
  8c856d:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c8573:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c8577:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c857d:	e9 a6 fb ff ff       	jmp    8c8128 <check_lower_drain+0x4688>
  8c8582:	8b 6c 24 48          	mov    0x48(%rsp),%ebp
  8c8586:	48 8b 7c 24 70       	mov    0x70(%rsp),%rdi
  8c858b:	4c 8d 54 6d 00       	lea    0x0(%rbp,%rbp,2),%r10
  8c8590:	49 c1 e2 05          	shl    $0x5,%r10
  8c8594:	46 8b 6c 17 40       	mov    0x40(%rdi,%r10,1),%r13d
  8c8599:	4d 85 ed             	test   %r13,%r13
  8c859c:	0f 84 76 01 00 00    	je     8c8718 <check_lower_drain+0x4c78>
  8c85a2:	48 8b bc 24 80 00 00 	mov    0x80(%rsp),%rdi
  8c85a9:	00 
  8c85aa:	44 3b af c0 00 00 00 	cmp    0xc0(%rdi),%r13d
  8c85b1:	40 0f 92 c7          	setb   %dil
  8c85b5:	89 7c 24 78          	mov    %edi,0x78(%rsp)
  8c85b9:	e9 62 01 00 00       	jmp    8c8720 <check_lower_drain+0x4c80>
  8c85be:	49 8b 07             	mov    (%r15),%rax
  8c85c1:	42 83 3c a8 00       	cmpl   $0x0,(%rax,%r13,4)
  8c85c6:	0f 85 a4 00 00 00    	jne    8c8670 <check_lower_drain+0x4bd0>
  8c85cc:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  8c85d1:	4b 8d 4c 6d 00       	lea    0x0(%r13,%r13,2),%rcx
  8c85d6:	48 c1 e1 05          	shl    $0x5,%rcx
  8c85da:	48 8b 40 08          	mov    0x8(%rax),%rax
  8c85de:	48 8d 44 08 40       	lea    0x40(%rax,%rcx,1),%rax
  8c85e3:	44 8b 38             	mov    (%rax),%r15d
  8c85e6:	4d 85 ff             	test   %r15,%r15
  8c85e9:	0f 84 81 00 00 00    	je     8c8670 <check_lower_drain+0x4bd0>
  8c85ef:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  8c85f4:	44 3b b8 c0 00 00 00 	cmp    0xc0(%rax),%r15d
  8c85fb:	73 73                	jae    8c8670 <check_lower_drain+0x4bd0>
  8c85fd:	48 8b 43 68          	mov    0x68(%rbx),%rax
  8c8601:	b2 1e                	mov    $0x1e,%dl
  8c8603:	42 8b 04 b8          	mov    (%rax,%r15,4),%eax
  8c8607:	83 f8 ff             	cmp    $0xffffffff,%eax
  8c860a:	75 2b                	jne    8c8637 <check_lower_drain+0x4b97>
  8c860c:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  8c8611:	48 8b 4c 24 68       	mov    0x68(%rsp),%rcx
  8c8616:	48 8b 80 80 00 00 00 	mov    0x80(%rax),%rax
  8c861d:	83 c1 f5             	add    $0xfffffff5,%ecx
  8c8620:	42 8b 04 b8          	mov    (%rax,%r15,4),%eax
  8c8624:	80 f9 03             	cmp    $0x3,%cl
  8c8627:	0f 82 7e 05 00 00    	jb     8c8bab <check_lower_drain+0x510b>
  8c862d:	b2 20                	mov    $0x20,%dl
  8c862f:	85 c0                	test   %eax,%eax
  8c8631:	0f 84 74 05 00 00    	je     8c8bab <check_lower_drain+0x510b>
  8c8637:	45 31 ed             	xor    %r13d,%r13d
  8c863a:	83 7c 24 28 23       	cmpl   $0x23,0x28(%rsp)
  8c863f:	0f b6 f2             	movzbl %dl,%esi
  8c8642:	0f b6 54 24 68       	movzbl 0x68(%rsp),%edx
  8c8647:	89 c1                	mov    %eax,%ecx
  8c8649:	48 89 df             	mov    %rbx,%rdi
  8c864c:	41 0f 95 c5          	setne  %r13b
  8c8650:	c5 f8 77             	vzeroupper
  8c8653:	e8 c8 0e 00 00       	call   8c9520 <check_lower_instruction>
  8c8658:	45 8b 06             	mov    (%r14),%r8d
  8c865b:	48 89 df             	mov    %rbx,%rdi
  8c865e:	44 89 e6             	mov    %r12d,%esi
  8c8661:	44 89 ea             	mov    %r13d,%edx
  8c8664:	31 c9                	xor    %ecx,%ecx
  8c8666:	e8 e5 0e 01 00       	call   8d9550 <check_lower_operand>
  8c866b:	e9 d6 05 00 00       	jmp    8c8c46 <check_lower_drain+0x51a6>
  8c8670:	83 7c 24 28 1b       	cmpl   $0x1b,0x28(%rsp)
  8c8675:	0f 85 a1 05 00 00    	jne    8c8c1c <check_lower_drain+0x517c>
  8c867b:	0f b6 54 24 68       	movzbl 0x68(%rsp),%edx
  8c8680:	be 1c 00 00 00       	mov    $0x1c,%esi
  8c8685:	48 89 df             	mov    %rbx,%rdi
  8c8688:	31 c9                	xor    %ecx,%ecx
  8c868a:	c5 f8 77             	vzeroupper
  8c868d:	e8 8e 0e 00 00       	call   8c9520 <check_lower_instruction>
  8c8692:	45 8b 06             	mov    (%r14),%r8d
  8c8695:	ba 01 00 00 00       	mov    $0x1,%edx
  8c869a:	48 89 df             	mov    %rbx,%rdi
  8c869d:	44 89 e6             	mov    %r12d,%esi
  8c86a0:	31 c9                	xor    %ecx,%ecx
  8c86a2:	e8 a9 0e 01 00       	call   8d9550 <check_lower_operand>
  8c86a7:	e9 69 ea ff ff       	jmp    8c7115 <check_lower_drain+0x3675>
  8c86ac:	84 d2                	test   %dl,%dl
  8c86ae:	0f 84 78 02 00 00    	je     8c892c <check_lower_drain+0x4e8c>
  8c86b4:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  8c86b9:	4b 8d 4c 6d 00       	lea    0x0(%r13,%r13,2),%rcx
  8c86be:	48 c1 e1 05          	shl    $0x5,%rcx
  8c86c2:	48 8b 40 08          	mov    0x8(%rax),%rax
  8c86c6:	8b 04 08             	mov    (%rax,%rcx,1),%eax
  8c86c9:	c1 e8 03             	shr    $0x3,%eax
  8c86cc:	3b 44 24 44          	cmp    0x44(%rsp),%eax
  8c86d0:	73 11                	jae    8c86e3 <check_lower_drain+0x4c43>
  8c86d2:	48 8b 8b a0 01 00 00 	mov    0x1a0(%rbx),%rcx
  8c86d9:	f6 04 01 02          	testb  $0x2,(%rcx,%rax,1)
  8c86dd:	0f 85 87 02 00 00    	jne    8c896a <check_lower_drain+0x4eca>
  8c86e3:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  8c86e8:	c1 e8 03             	shr    $0x3,%eax
  8c86eb:	3b 44 24 44          	cmp    0x44(%rsp),%eax
  8c86ef:	73 14                	jae    8c8705 <check_lower_drain+0x4c65>
  8c86f1:	48 8b 93 a0 01 00 00 	mov    0x1a0(%rbx),%rdx
  8c86f8:	48 89 c1             	mov    %rax,%rcx
  8c86fb:	f6 04 0a 02          	testb  $0x2,(%rdx,%rcx,1)
  8c86ff:	0f 85 65 02 00 00    	jne    8c896a <check_lower_drain+0x4eca>
  8c8705:	48 89 df             	mov    %rbx,%rdi
  8c8708:	44 89 e6             	mov    %r12d,%esi
  8c870b:	c5 f8 77             	vzeroupper
  8c870e:	e8 fd 75 01 00       	call   8dfd10 <check_lower_update>
  8c8713:	e9 2e 05 00 00       	jmp    8c8c46 <check_lower_drain+0x51a6>
  8c8718:	c7 44 24 78 00 00 00 	movl   $0x0,0x78(%rsp)
  8c871f:	00 
  8c8720:	48 8b 7c 24 58       	mov    0x58(%rsp),%rdi
  8c8725:	ff c8                	dec    %eax
  8c8727:	44 8b 8c 87 80 00 00 	mov    0x80(%rdi,%rax,4),%r9d
  8c872e:	00 
  8c872f:	45 0f b6 f1          	movzbl %r9b,%r14d
  8c8733:	41 8d 7e ff          	lea    -0x1(%r14),%edi
  8c8737:	83 ff 0a             	cmp    $0xa,%edi
  8c873a:	89 bc 24 94 00 00 00 	mov    %edi,0x94(%rsp)
  8c8741:	40 0f 93 c7          	setae  %dil
  8c8745:	41 f7 c1 00 05 00 00 	test   $0x500,%r9d
  8c874c:	41 0f 95 c0          	setne  %r8b
  8c8750:	41 08 f8             	or     %dil,%r8b
  8c8753:	0f 85 50 01 00 00    	jne    8c88a9 <check_lower_drain+0x4e09>
  8c8759:	48 8b 7c 24 70       	mov    0x70(%rsp),%rdi
  8c875e:	4c 01 d7             	add    %r10,%rdi
  8c8761:	83 7f 44 00          	cmpl   $0x0,0x44(%rdi)
  8c8765:	48 89 7c 24 70       	mov    %rdi,0x70(%rsp)
  8c876a:	0f 85 39 01 00 00    	jne    8c88a9 <check_lower_drain+0x4e09>
  8c8770:	48 8b bc 24 98 00 00 	mov    0x98(%rsp),%rdi
  8c8777:	00 
  8c8778:	44 8b 14 af          	mov    (%rdi,%rbp,4),%r10d
  8c877c:	45 85 d2             	test   %r10d,%r10d
  8c877f:	40 0f 94 c7          	sete   %dil
  8c8783:	40 22 7c 24 78       	and    0x78(%rsp),%dil
  8c8788:	40 80 ff 01          	cmp    $0x1,%dil
  8c878c:	75 34                	jne    8c87c2 <check_lower_drain+0x4d22>
  8c878e:	48 8b bc 24 88 00 00 	mov    0x88(%rsp),%rdi
  8c8795:	00 
  8c8796:	4c 8b 87 90 02 00 00 	mov    0x290(%rdi),%r8
  8c879d:	41 8d 7d ff          	lea    -0x1(%r13),%edi
  8c87a1:	41 80 3c 38 00       	cmpb   $0x0,(%r8,%rdi,1)
  8c87a6:	74 1a                	je     8c87c2 <check_lower_drain+0x4d22>
  8c87a8:	4c 8b 84 24 88 00 00 	mov    0x88(%rsp),%r8
  8c87af:	00 
  8c87b0:	4d 8b 80 78 02 00 00 	mov    0x278(%r8),%r8
  8c87b7:	41 80 3c 38 00       	cmpb   $0x0,(%r8,%rdi,1)
  8c87bc:	0f 84 e7 00 00 00    	je     8c88a9 <check_lower_drain+0x4e09>
  8c87c2:	48 8b 7c 24 70       	mov    0x70(%rsp),%rdi
  8c87c7:	8b 7f 0c             	mov    0xc(%rdi),%edi
  8c87ca:	85 ff                	test   %edi,%edi
  8c87cc:	74 2f                	je     8c87fd <check_lower_drain+0x4d5d>
  8c87ce:	4c 8b 44 24 70       	mov    0x70(%rsp),%r8
  8c87d3:	41 83 78 54 00       	cmpl   $0x0,0x54(%r8)
  8c87d8:	75 23                	jne    8c87fd <check_lower_drain+0x4d5d>
  8c87da:	4c 8b 44 24 70       	mov    0x70(%rsp),%r8
  8c87df:	45 0f b7 40 08       	movzwl 0x8(%r8),%r8d
  8c87e4:	41 f7 c0 10 08 00 00 	test   $0x810,%r8d
  8c87eb:	75 10                	jne    8c87fd <check_lower_drain+0x4d5d>
  8c87ed:	4c 8b 44 24 70       	mov    0x70(%rsp),%r8
  8c87f2:	41 83 78 04 00       	cmpl   $0x0,0x4(%r8)
  8c87f7:	0f 84 03 07 00 00    	je     8c8f00 <check_lower_drain+0x5460>
  8c87fd:	45 85 d2             	test   %r10d,%r10d
  8c8800:	0f 85 a3 00 00 00    	jne    8c88a9 <check_lower_drain+0x4e09>
  8c8806:	48 8b 7c 24 70       	mov    0x70(%rsp),%rdi
  8c880b:	83 7f 04 01          	cmpl   $0x1,0x4(%rdi)
  8c880f:	40 0f 94 c7          	sete   %dil
  8c8813:	40 22 7c 24 78       	and    0x78(%rsp),%dil
  8c8818:	40 80 ff 01          	cmp    $0x1,%dil
  8c881c:	0f 85 87 00 00 00    	jne    8c88a9 <check_lower_drain+0x4e09>
  8c8822:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  8c8827:	48 8b 7b 68          	mov    0x68(%rbx),%rdi
  8c882b:	48 8b ac 24 80 00 00 	mov    0x80(%rsp),%rbp
  8c8832:	00 
  8c8833:	45 31 c9             	xor    %r9d,%r9d
  8c8836:	4d 8d 50 08          	lea    0x8(%r8),%r10
  8c883a:	4d 8b 40 08          	mov    0x8(%r8),%r8
  8c883e:	46 8b 34 af          	mov    (%rdi,%r13,4),%r14d
  8c8842:	48 8b bd 80 00 00 00 	mov    0x80(%rbp),%rdi
  8c8849:	47 8b 04 b8          	mov    (%r8,%r15,4),%r8d
  8c884d:	42 8b 3c af          	mov    (%rdi,%r13,4),%edi
  8c8851:	41 83 fe ff          	cmp    $0xffffffff,%r14d
  8c8855:	41 0f 94 c1          	sete   %r9b
  8c8859:	41 c1 e1 09          	shl    $0x9,%r9d
  8c885d:	41 81 c1 00 02 00 00 	add    $0x200,%r9d
  8c8864:	44 89 83 64 01 00 00 	mov    %r8d,0x164(%rbx)
  8c886b:	41 83 fe ff          	cmp    $0xffffffff,%r14d
  8c886f:	44 0f 44 f7          	cmove  %edi,%r14d
  8c8873:	4d 89 f5             	mov    %r14,%r13
  8c8876:	0f 85 4e f6 ff ff    	jne    8c7eca <check_lower_drain+0x442a>
  8c887c:	85 ff                	test   %edi,%edi
  8c887e:	74 3c                	je     8c88bc <check_lower_drain+0x4e1c>
  8c8880:	e9 45 f6 ff ff       	jmp    8c7eca <check_lower_drain+0x442a>
  8c8885:	83 7c 24 60 3e       	cmpl   $0x3e,0x60(%rsp)
  8c888a:	0f 87 de 01 00 00    	ja     8c8a6e <check_lower_drain+0x4fce>
  8c8890:	44 8b 44 24 60       	mov    0x60(%rsp),%r8d
  8c8895:	49 b9 00 00 00 00 08 	movabs $0x4080000800000000,%r9
  8c889c:	00 80 40 
  8c889f:	4d 0f a3 c1          	bt     %r8,%r9
  8c88a3:	0f 83 c5 01 00 00    	jae    8c8a6e <check_lower_drain+0x4fce>
  8c88a9:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  8c88ae:	48 8b 40 08          	mov    0x8(%rax),%rax
  8c88b2:	42 8b 04 b8          	mov    (%rax,%r15,4),%eax
  8c88b6:	89 83 64 01 00 00    	mov    %eax,0x164(%rbx)
  8c88bc:	66 81 fe ff 00       	cmp    $0xff,%si
  8c88c1:	74 11                	je     8c88d4 <check_lower_drain+0x4e34>
  8c88c3:	8b 54 24 44          	mov    0x44(%rsp),%edx
  8c88c7:	48 89 df             	mov    %rbx,%rdi
  8c88ca:	31 c9                	xor    %ecx,%ecx
  8c88cc:	c5 f8 77             	vzeroupper
  8c88cf:	e8 4c 0c 00 00       	call   8c9520 <check_lower_instruction>
  8c88d4:	83 7c 24 20 0f       	cmpl   $0xf,0x20(%rsp)
  8c88d9:	77 1a                	ja     8c88f5 <check_lower_drain+0x4e55>
  8c88db:	44 8b 44 24 30       	mov    0x30(%rsp),%r8d
  8c88e0:	ba 01 00 00 00       	mov    $0x1,%edx
  8c88e5:	48 89 df             	mov    %rbx,%rdi
  8c88e8:	44 89 e6             	mov    %r12d,%esi
  8c88eb:	31 c9                	xor    %ecx,%ecx
  8c88ed:	c5 f8 77             	vzeroupper
  8c88f0:	e8 5b 0c 01 00       	call   8d9550 <check_lower_operand>
  8c88f5:	44 8b 44 24 54       	mov    0x54(%rsp),%r8d
  8c88fa:	48 89 df             	mov    %rbx,%rdi
  8c88fd:	44 89 e6             	mov    %r12d,%esi
  8c8900:	31 d2                	xor    %edx,%edx
  8c8902:	31 c9                	xor    %ecx,%ecx
  8c8904:	c5 f8 77             	vzeroupper
  8c8907:	e8 44 0c 01 00       	call   8d9550 <check_lower_operand>
  8c890c:	b9 01 00 00 00       	mov    $0x1,%ecx
  8c8911:	62 f2 fd 08 7c c1    	vpbroadcastq %rcx,%xmm0
  8c8917:	c5 f9 d4 83 40 05 00 	vpaddq 0x540(%rbx),%xmm0,%xmm0
  8c891e:	00 
  8c891f:	c5 fa 7f 83 40 05 00 	vmovdqu %xmm0,0x540(%rbx)
  8c8926:	00 
  8c8927:	e9 1a 03 00 00       	jmp    8c8c46 <check_lower_drain+0x51a6>
  8c892c:	83 7c 24 28 1d       	cmpl   $0x1d,0x28(%rsp)
  8c8931:	0f 87 a5 01 00 00    	ja     8c8adc <check_lower_drain+0x503c>
  8c8937:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  8c893c:	b8 60 00 00 20       	mov    $0x20000060,%eax
  8c8941:	0f a3 c8             	bt     %ecx,%eax
  8c8944:	0f 83 92 01 00 00    	jae    8c8adc <check_lower_drain+0x503c>
  8c894a:	48 8b 6c 24 48       	mov    0x48(%rsp),%rbp
  8c894f:	c1 ed 03             	shr    $0x3,%ebp
  8c8952:	3b 6c 24 44          	cmp    0x44(%rsp),%ebp
  8c8956:	73 25                	jae    8c897d <check_lower_drain+0x4edd>
  8c8958:	48 8b 83 a0 01 00 00 	mov    0x1a0(%rbx),%rax
  8c895f:	44 0f b6 2c 28       	movzbl (%rax,%rbp,1),%r13d
  8c8964:	41 80 e5 08          	and    $0x8,%r13b
  8c8968:	eb 16                	jmp    8c8980 <check_lower_drain+0x4ee0>
  8c896a:	48 89 df             	mov    %rbx,%rdi
  8c896d:	44 89 e6             	mov    %r12d,%esi
  8c8970:	c5 f8 77             	vzeroupper
  8c8973:	e8 38 6f 01 00       	call   8df8b0 <check_lower_complex_update>
  8c8978:	e9 c9 02 00 00       	jmp    8c8c46 <check_lower_drain+0x51a6>
  8c897d:	45 31 ed             	xor    %r13d,%r13d
  8c8980:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  8c8985:	c1 e8 03             	shr    $0x3,%eax
  8c8988:	3b 44 24 44          	cmp    0x44(%rsp),%eax
  8c898c:	73 16                	jae    8c89a4 <check_lower_drain+0x4f04>
  8c898e:	48 8b 8b a0 01 00 00 	mov    0x1a0(%rbx),%rcx
  8c8995:	44 0f b6 34 01       	movzbl (%rcx,%rax,1),%r14d
  8c899a:	41 80 e6 08          	and    $0x8,%r14b
  8c899e:	41 c0 ee 03          	shr    $0x3,%r14b
  8c89a2:	eb 03                	jmp    8c89a7 <check_lower_drain+0x4f07>
  8c89a4:	45 31 f6             	xor    %r14d,%r14d
  8c89a7:	45 84 ed             	test   %r13b,%r13b
  8c89aa:	75 40                	jne    8c89ec <check_lower_drain+0x4f4c>
  8c89ac:	45 84 f6             	test   %r14b,%r14b
  8c89af:	75 3b                	jne    8c89ec <check_lower_drain+0x4f4c>
  8c89b1:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c89b6:	c5 f8 77             	vzeroupper
  8c89b9:	e8 52 0a 01 00       	call   8d9410 <check_lower_binary>
  8c89be:	0f b6 54 24 68       	movzbl 0x68(%rsp),%edx
  8c89c3:	0f b6 f0             	movzbl %al,%esi
  8c89c6:	48 89 df             	mov    %rbx,%rdi
  8c89c9:	31 c9                	xor    %ecx,%ecx
  8c89cb:	e8 50 0b 00 00       	call   8c9520 <check_lower_instruction>
  8c89d0:	ba 01 00 00 00       	mov    $0x1,%edx
  8c89d5:	4c 8b 44 24 60       	mov    0x60(%rsp),%r8
  8c89da:	48 89 df             	mov    %rbx,%rdi
  8c89dd:	44 89 e6             	mov    %r12d,%esi
  8c89e0:	31 c9                	xor    %ecx,%ecx
  8c89e2:	e8 69 0b 01 00       	call   8d9550 <check_lower_operand>
  8c89e7:	e9 e6 ea ff ff       	jmp    8c74d2 <check_lower_drain+0x3a32>
  8c89ec:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  8c89f1:	45 84 ed             	test   %r13b,%r13b
  8c89f4:	48 89 df             	mov    %rbx,%rdi
  8c89f7:	41 0f 95 c7          	setne  %r15b
  8c89fb:	89 c6                	mov    %eax,%esi
  8c89fd:	0f 45 74 24 48       	cmovne 0x48(%rsp),%esi
  8c8a02:	89 74 24 20          	mov    %esi,0x20(%rsp)
  8c8a06:	c5 f8 77             	vzeroupper
  8c8a09:	e8 42 80 01 00       	call   8e0a50 <check_lower_stride>
  8c8a0e:	45 20 f7             	and    %r14b,%r15b
  8c8a11:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  8c8a16:	41 80 ff 01          	cmp    $0x1,%r15b
  8c8a1a:	0f 85 0f 01 00 00    	jne    8c8b2f <check_lower_drain+0x508f>
  8c8a20:	83 7c 24 28 06       	cmpl   $0x6,0x28(%rsp)
  8c8a25:	0f 85 04 01 00 00    	jne    8c8b2f <check_lower_drain+0x508f>
  8c8a2b:	8b 83 3c 01 00 00    	mov    0x13c(%rbx),%eax
  8c8a31:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c8a37:	0f 83 12 02 00 00    	jae    8c8c4f <check_lower_drain+0x51af>
  8c8a3d:	48 8b 4b 18          	mov    0x18(%rbx),%rcx
  8c8a41:	8d 50 01             	lea    0x1(%rax),%edx
  8c8a44:	48 c1 e0 04          	shl    $0x4,%rax
  8c8a48:	89 93 3c 01 00 00    	mov    %edx,0x13c(%rbx)
  8c8a4e:	48 ba 01 00 00 00 01 	movabs $0x7000100000001,%rdx
  8c8a55:	00 07 00 
  8c8a58:	48 83 c2 0d          	add    $0xd,%rdx
  8c8a5c:	48 89 14 01          	mov    %rdx,(%rcx,%rax,1)
  8c8a60:	48 c7 44 01 08 00 00 	movq   $0x0,0x8(%rcx,%rax,1)
  8c8a67:	00 00 
  8c8a69:	e9 0b 02 00 00       	jmp    8c8c79 <check_lower_drain+0x51d9>
  8c8a6e:	83 ff 01             	cmp    $0x1,%edi
  8c8a71:	0f 85 32 fe ff ff    	jne    8c88a9 <check_lower_drain+0x4e09>
  8c8a77:	49 8b 7a 10          	mov    0x10(%r10),%rdi
  8c8a7b:	c7 44 24 60 01 00 00 	movl   $0x1,0x60(%rsp)
  8c8a82:	00 
  8c8a83:	48 89 7c 24 28       	mov    %rdi,0x28(%rsp)
  8c8a88:	83 fd 06             	cmp    $0x6,%ebp
  8c8a8b:	0f 87 32 03 00 00    	ja     8c8dc3 <check_lower_drain+0x5323>
  8c8a91:	41 d1 ee             	shr    $1,%r14d
  8c8a94:	bf 08 00 00 00       	mov    $0x8,%edi
  8c8a99:	49 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%r8
  8c8aa0:	c4 e2 09 f7 ff       	shlx   %r14d,%edi,%edi
  8c8aa5:	c4 62 c0 f5 54 24 28 	bzhi   %rdi,0x28(%rsp),%r10
  8c8aac:	c4 42 c1 f7 c0       	shlx   %rdi,%r8,%r8
  8c8ab1:	ff cf                	dec    %edi
  8c8ab3:	c4 c2 c3 f7 fa       	shrx   %rdi,%r10,%rdi
  8c8ab8:	48 85 ff             	test   %rdi,%rdi
  8c8abb:	4c 0f 44 c7          	cmove  %rdi,%r8
  8c8abf:	45 31 c9             	xor    %r9d,%r9d
  8c8ac2:	41 f6 c5 01          	test   $0x1,%r13b
  8c8ac6:	bf 00 00 00 00       	mov    $0x0,%edi
  8c8acb:	49 0f 45 f8          	cmovne %r8,%rdi
  8c8acf:	4c 09 d7             	or     %r10,%rdi
  8c8ad2:	48 89 7c 24 28       	mov    %rdi,0x28(%rsp)
  8c8ad7:	e9 b4 f3 ff ff       	jmp    8c7e90 <check_lower_drain+0x43f0>
  8c8adc:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8c8ae1:	c5 f8 77             	vzeroupper
  8c8ae4:	e8 27 09 01 00       	call   8d9410 <check_lower_binary>
  8c8ae9:	84 c0                	test   %al,%al
  8c8aeb:	0f 84 d4 01 00 00    	je     8c8cc5 <check_lower_drain+0x5225>
  8c8af1:	0f b6 54 24 68       	movzbl 0x68(%rsp),%edx
  8c8af6:	0f b6 e8             	movzbl %al,%ebp
  8c8af9:	48 89 df             	mov    %rbx,%rdi
  8c8afc:	89 ee                	mov    %ebp,%esi
  8c8afe:	e8 ed 81 01 00       	call   8e0cf0 <check_lower_operation>
  8c8b03:	4c 8b 74 24 60       	mov    0x60(%rsp),%r14
  8c8b08:	48 89 df             	mov    %rbx,%rdi
  8c8b0b:	89 ee                	mov    %ebp,%esi
  8c8b0d:	44 89 f2             	mov    %r14d,%edx
  8c8b10:	e8 eb 85 01 00       	call   8e1100 <check_lower_count>
  8c8b15:	ba 01 00 00 00       	mov    $0x1,%edx
  8c8b1a:	48 89 df             	mov    %rbx,%rdi
  8c8b1d:	44 89 e6             	mov    %r12d,%esi
  8c8b20:	31 c9                	xor    %ecx,%ecx
  8c8b22:	45 89 f0             	mov    %r14d,%r8d
  8c8b25:	e8 26 0a 01 00       	call   8d9550 <check_lower_operand>
  8c8b2a:	e9 a3 e9 ff ff       	jmp    8c74d2 <check_lower_drain+0x3a32>
  8c8b2f:	48 83 7c 24 38 00    	cmpq   $0x0,0x38(%rsp)
  8c8b35:	0f 95 c0             	setne  %al
  8c8b38:	83 7c 24 28 1d       	cmpl   $0x1d,0x28(%rsp)
  8c8b3d:	0f 95 c1             	setne  %cl
  8c8b40:	0a 44 24 54          	or     0x54(%rsp),%al
  8c8b44:	08 c8                	or     %cl,%al
  8c8b46:	0f 84 99 01 00 00    	je     8c8ce5 <check_lower_drain+0x5245>
  8c8b4c:	8b 74 24 20          	mov    0x20(%rsp),%esi
  8c8b50:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
  8c8b55:	48 89 df             	mov    %rbx,%rdi
  8c8b58:	e8 13 80 01 00       	call   8e0b70 <check_lower_scale>
  8c8b5d:	83 7c 24 28 06       	cmpl   $0x6,0x28(%rsp)
  8c8b62:	0f 85 a2 01 00 00    	jne    8c8d0a <check_lower_drain+0x526a>
  8c8b68:	8b 83 3c 01 00 00    	mov    0x13c(%rbx),%eax
  8c8b6e:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c8b74:	0f 83 53 03 00 00    	jae    8c8ecd <check_lower_drain+0x542d>
  8c8b7a:	48 8b 4b 18          	mov    0x18(%rbx),%rcx
  8c8b7e:	8d 50 01             	lea    0x1(%rax),%edx
  8c8b81:	48 c1 e0 04          	shl    $0x4,%rax
  8c8b85:	89 93 3c 01 00 00    	mov    %edx,0x13c(%rbx)
  8c8b8b:	48 ba 01 00 00 00 01 	movabs $0x7000100000001,%rdx
  8c8b92:	00 07 00 
  8c8b95:	48 83 c2 06          	add    $0x6,%rdx
  8c8b99:	48 89 14 01          	mov    %rdx,(%rcx,%rax,1)
  8c8b9d:	48 c7 44 01 08 00 00 	movq   $0x0,0x8(%rcx,%rax,1)
  8c8ba4:	00 00 
  8c8ba6:	e9 5f 01 00 00       	jmp    8c8d0a <check_lower_drain+0x526a>
  8c8bab:	83 7c 24 28 1b       	cmpl   $0x1b,0x28(%rsp)
  8c8bb0:	0f 84 c5 fa ff ff    	je     8c867b <check_lower_drain+0x4bdb>
  8c8bb6:	85 c0                	test   %eax,%eax
  8c8bb8:	74 62                	je     8c8c1c <check_lower_drain+0x517c>
  8c8bba:	0f b6 54 24 68       	movzbl 0x68(%rsp),%edx
  8c8bbf:	be 1c 00 00 00       	mov    $0x1c,%esi
  8c8bc4:	48 89 df             	mov    %rbx,%rdi
  8c8bc7:	31 c9                	xor    %ecx,%ecx
  8c8bc9:	c5 f8 77             	vzeroupper
  8c8bcc:	e8 4f 09 00 00       	call   8c9520 <check_lower_instruction>
  8c8bd1:	45 8b 06             	mov    (%r14),%r8d
  8c8bd4:	48 89 df             	mov    %rbx,%rdi
  8c8bd7:	44 89 e6             	mov    %r12d,%esi
  8c8bda:	31 d2                	xor    %edx,%edx
  8c8bdc:	31 c9                	xor    %ecx,%ecx
  8c8bde:	e8 6d 09 01 00       	call   8d9550 <check_lower_operand>
  8c8be3:	48 8d 84 24 78 01 00 	lea    0x178(%rsp),%rax
  8c8bea:	00 
  8c8beb:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
  8c8bef:	c5 f8 11 00          	vmovups %xmm0,(%rax)
  8c8bf3:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  8c8bfa:	00 
  8c8bfb:	c7 84 24 70 01 00 00 	movl   $0xa,0x170(%rsp)
  8c8c02:	0a 00 00 00 
  8c8c06:	44 89 bc 24 74 01 00 	mov    %r15d,0x174(%rsp)
  8c8c0d:	00 
  8c8c0e:	c5 fe 6f 84 24 70 01 	vmovdqu 0x170(%rsp),%ymm0
  8c8c15:	00 00 
  8c8c17:	e9 44 f7 ff ff       	jmp    8c8360 <check_lower_drain+0x48c0>
  8c8c1c:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c8c20:	48 8b 00             	mov    (%rax),%rax
  8c8c23:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c8c2a:	75 1a                	jne    8c8c46 <check_lower_drain+0x51a6>
  8c8c2c:	c7 80 f0 00 00 00 01 	movl   $0x1,0xf0(%rax)
  8c8c33:	00 00 00 
  8c8c36:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c8c3c:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c8c40:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c8c46:	4c 8d 6b 08          	lea    0x8(%rbx),%r13
  8c8c4a:	e9 69 af ff ff       	jmp    8c3bb8 <check_lower_drain+0x118>
  8c8c4f:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c8c53:	48 8b 00             	mov    (%rax),%rax
  8c8c56:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c8c5d:	75 1a                	jne    8c8c79 <check_lower_drain+0x51d9>
  8c8c5f:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c8c66:	00 00 00 
  8c8c69:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c8c6f:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c8c73:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c8c79:	48 83 7c 24 30 00    	cmpq   $0x0,0x30(%rsp)
  8c8c7f:	0f 84 c2 00 00 00    	je     8c8d47 <check_lower_drain+0x52a7>
  8c8c85:	8b 83 3c 01 00 00    	mov    0x13c(%rbx),%eax
  8c8c8b:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c8c91:	0f 83 34 01 00 00    	jae    8c8dcb <check_lower_drain+0x532b>
  8c8c97:	48 8b 4b 18          	mov    0x18(%rbx),%rcx
  8c8c9b:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  8c8ca0:	8d 50 01             	lea    0x1(%rax),%edx
  8c8ca3:	48 c1 e0 04          	shl    $0x4,%rax
  8c8ca7:	89 93 3c 01 00 00    	mov    %edx,0x13c(%rbx)
  8c8cad:	48 ba 01 00 00 00 01 	movabs $0x7000100000001,%rdx
  8c8cb4:	00 07 00 
  8c8cb7:	48 89 14 01          	mov    %rdx,(%rcx,%rax,1)
  8c8cbb:	48 89 74 01 08       	mov    %rsi,0x8(%rcx,%rax,1)
  8c8cc0:	e9 30 01 00 00       	jmp    8c8df5 <check_lower_drain+0x5355>
  8c8cc5:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c8cc9:	48 8b 00             	mov    (%rax),%rax
  8c8ccc:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c8cd3:	0f 85 6d ff ff ff    	jne    8c8c46 <check_lower_drain+0x51a6>
  8c8cd9:	48 8d 0d c1 d5 e0 ff 	lea    -0x1f2a3f(%rip),%rcx        # 6d62a1 <pp_string_value.meaning+0x22a64>
  8c8ce0:	e9 c6 e1 ff ff       	jmp    8c6eab <check_lower_drain+0x340b>
  8c8ce5:	0f b6 54 24 68       	movzbl 0x68(%rsp),%edx
  8c8cea:	be 0a 00 00 00       	mov    $0xa,%esi
  8c8cef:	48 89 df             	mov    %rbx,%rdi
  8c8cf2:	31 c9                	xor    %ecx,%ecx
  8c8cf4:	e8 27 08 00 00       	call   8c9520 <check_lower_instruction>
  8c8cf9:	8b 74 24 20          	mov    0x20(%rsp),%esi
  8c8cfd:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
  8c8d02:	48 89 df             	mov    %rbx,%rdi
  8c8d05:	e8 66 7e 01 00       	call   8e0b70 <check_lower_scale>
  8c8d0a:	31 ed                	xor    %ebp,%ebp
  8c8d0c:	45 84 ed             	test   %r13b,%r13b
  8c8d0f:	41 b8 50 00 00 00    	mov    $0x50,%r8d
  8c8d15:	48 89 df             	mov    %rbx,%rdi
  8c8d18:	44 89 e6             	mov    %r12d,%esi
  8c8d1b:	40 0f 94 c5          	sete   %bpl
  8c8d1f:	41 c0 ed 03          	shr    $0x3,%r13b
  8c8d23:	31 c9                	xor    %ecx,%ecx
  8c8d25:	41 0f b6 d5          	movzbl %r13b,%edx
  8c8d29:	e8 22 08 01 00       	call   8d9550 <check_lower_operand>
  8c8d2e:	44 8b 44 24 20       	mov    0x20(%rsp),%r8d
  8c8d33:	48 89 df             	mov    %rbx,%rdi
  8c8d36:	44 89 e6             	mov    %r12d,%esi
  8c8d39:	89 ea                	mov    %ebp,%edx
  8c8d3b:	31 c9                	xor    %ecx,%ecx
  8c8d3d:	e8 0e 08 01 00       	call   8d9550 <check_lower_operand>
  8c8d42:	e9 ff fe ff ff       	jmp    8c8c46 <check_lower_drain+0x51a6>
  8c8d47:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  8c8d4c:	48 8b 08             	mov    (%rax),%rcx
  8c8d4f:	48 8b 40 20          	mov    0x20(%rax),%rax
  8c8d53:	80 3c 29 0f          	cmpb   $0xf,(%rcx,%rbp,1)
  8c8d57:	75 0f                	jne    8c8d68 <check_lower_drain+0x52c8>
  8c8d59:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
  8c8d5e:	83 e2 07             	and    $0x7,%edx
  8c8d61:	0b 14 a8             	or     (%rax,%rbp,4),%edx
  8c8d64:	89 54 24 20          	mov    %edx,0x20(%rsp)
  8c8d68:	8b 74 24 20          	mov    0x20(%rsp),%esi
  8c8d6c:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
  8c8d70:	48 89 df             	mov    %rbx,%rdi
  8c8d73:	89 f2                	mov    %esi,%edx
  8c8d75:	c1 ea 03             	shr    $0x3,%edx
  8c8d78:	83 e6 07             	and    $0x7,%esi
  8c8d7b:	0f b6 0c 11          	movzbl (%rcx,%rdx,1),%ecx
  8c8d7f:	80 c1 f8             	add    $0xf8,%cl
  8c8d82:	80 f9 03             	cmp    $0x3,%cl
  8c8d85:	b9 00 00 00 00       	mov    $0x0,%ecx
  8c8d8a:	0f 43 f1             	cmovae %ecx,%esi
  8c8d8d:	0b 34 90             	or     (%rax,%rdx,4),%esi
  8c8d90:	c5 fc 11 84 24 d0 01 	vmovups %ymm0,0x1d0(%rsp)
  8c8d97:	00 00 
  8c8d99:	c7 84 24 d0 01 00 00 	movl   $0x13,0x1d0(%rsp)
  8c8da0:	13 00 00 00 
  8c8da4:	89 b4 24 d8 01 00 00 	mov    %esi,0x1d8(%rsp)
  8c8dab:	c5 fe 6f 84 24 d0 01 	vmovdqu 0x1d0(%rsp),%ymm0
  8c8db2:	00 00 
  8c8db4:	c5 fe 7f 04 24       	vmovdqu %ymm0,(%rsp)
  8c8db9:	c5 f8 77             	vzeroupper
  8c8dbc:	e8 0f 45 00 00       	call   8cd2d0 <check_lower_push>
  8c8dc1:	eb 32                	jmp    8c8df5 <check_lower_drain+0x5355>
  8c8dc3:	45 31 c9             	xor    %r9d,%r9d
  8c8dc6:	e9 c5 f0 ff ff       	jmp    8c7e90 <check_lower_drain+0x43f0>
  8c8dcb:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c8dcf:	48 8b 00             	mov    (%rax),%rax
  8c8dd2:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c8dd9:	75 1a                	jne    8c8df5 <check_lower_drain+0x5355>
  8c8ddb:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c8de2:	00 00 00 
  8c8de5:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c8deb:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c8def:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c8df5:	8b 83 3c 01 00 00    	mov    0x13c(%rbx),%eax
  8c8dfb:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c8e01:	73 2e                	jae    8c8e31 <check_lower_drain+0x5391>
  8c8e03:	48 8b 4b 18          	mov    0x18(%rbx),%rcx
  8c8e07:	8d 50 01             	lea    0x1(%rax),%edx
  8c8e0a:	48 c1 e0 04          	shl    $0x4,%rax
  8c8e0e:	89 93 3c 01 00 00    	mov    %edx,0x13c(%rbx)
  8c8e14:	48 ba 01 00 00 00 01 	movabs $0x7000100000001,%rdx
  8c8e1b:	00 07 00 
  8c8e1e:	48 83 c2 08          	add    $0x8,%rdx
  8c8e22:	48 89 14 01          	mov    %rdx,(%rcx,%rax,1)
  8c8e26:	48 c7 44 01 08 00 00 	movq   $0x0,0x8(%rcx,%rax,1)
  8c8e2d:	00 00 
  8c8e2f:	eb 2a                	jmp    8c8e5b <check_lower_drain+0x53bb>
  8c8e31:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c8e35:	48 8b 00             	mov    (%rax),%rax
  8c8e38:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c8e3f:	75 1a                	jne    8c8e5b <check_lower_drain+0x53bb>
  8c8e41:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c8e48:	00 00 00 
  8c8e4b:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c8e51:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c8e55:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c8e5b:	8b 83 3c 01 00 00    	mov    0x13c(%rbx),%eax
  8c8e61:	3b 83 40 01 00 00    	cmp    0x140(%rbx),%eax
  8c8e67:	73 31                	jae    8c8e9a <check_lower_drain+0x53fa>
  8c8e69:	48 8b 4b 18          	mov    0x18(%rbx),%rcx
  8c8e6d:	8d 50 01             	lea    0x1(%rax),%edx
  8c8e70:	48 c1 e0 04          	shl    $0x4,%rax
  8c8e74:	89 93 3c 01 00 00    	mov    %edx,0x13c(%rbx)
  8c8e7a:	48 ba 01 00 00 00 01 	movabs $0x8000100000001,%rdx
  8c8e81:	00 08 00 
  8c8e84:	48 83 c2 0b          	add    $0xb,%rdx
  8c8e88:	48 89 14 01          	mov    %rdx,(%rcx,%rax,1)
  8c8e8c:	48 c7 44 01 08 00 00 	movq   $0x0,0x8(%rcx,%rax,1)
  8c8e93:	00 00 
  8c8e95:	e9 36 fb ff ff       	jmp    8c89d0 <check_lower_drain+0x4f30>
  8c8e9a:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c8e9e:	48 8b 00             	mov    (%rax),%rax
  8c8ea1:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c8ea8:	0f 85 22 fb ff ff    	jne    8c89d0 <check_lower_drain+0x4f30>
  8c8eae:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c8eb5:	00 00 00 
  8c8eb8:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c8ebe:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c8ec2:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c8ec8:	e9 03 fb ff ff       	jmp    8c89d0 <check_lower_drain+0x4f30>
  8c8ecd:	48 8d 43 08          	lea    0x8(%rbx),%rax
  8c8ed1:	48 8b 00             	mov    (%rax),%rax
  8c8ed4:	83 b8 f0 00 00 00 00 	cmpl   $0x0,0xf0(%rax)
  8c8edb:	0f 85 29 fe ff ff    	jne    8c8d0a <check_lower_drain+0x526a>
  8c8ee1:	c7 80 f0 00 00 00 03 	movl   $0x3,0xf0(%rax)
  8c8ee8:	00 00 00 
  8c8eeb:	8b 83 64 01 00 00    	mov    0x164(%rbx),%eax
  8c8ef1:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8c8ef5:	89 81 f4 00 00 00    	mov    %eax,0xf4(%rcx)
  8c8efb:	e9 0a fe ff ff       	jmp    8c8d0a <check_lower_drain+0x526a>
  8c8f00:	41 83 fa 3e          	cmp    $0x3e,%r10d
  8c8f04:	77 17                	ja     8c8f1d <check_lower_drain+0x547d>
  8c8f06:	49 bd 00 00 00 00 08 	movabs $0x4080000800000000,%r13
  8c8f0d:	00 80 40 
  8c8f10:	45 89 d0             	mov    %r10d,%r8d
  8c8f13:	4d 0f a3 c5          	bt     %r8,%r13
  8c8f17:	0f 82 8c f9 ff ff    	jb     8c88a9 <check_lower_drain+0x4e09>
  8c8f1d:	83 ff 01             	cmp    $0x1,%edi
  8c8f20:	0f 85 83 f9 ff ff    	jne    8c88a9 <check_lower_drain+0x4e09>
  8c8f26:	48 8b 7c 24 70       	mov    0x70(%rsp),%rdi
  8c8f2b:	4c 8b 6f 10          	mov    0x10(%rdi),%r13
  8c8f2f:	41 83 fe 06          	cmp    $0x6,%r14d
  8c8f33:	77 45                	ja     8c8f7a <check_lower_drain+0x54da>
  8c8f35:	44 8b 84 24 94 00 00 	mov    0x94(%rsp),%r8d
  8c8f3c:	00 
  8c8f3d:	bf 08 00 00 00       	mov    $0x8,%edi
  8c8f42:	49 c7 c2 ff ff ff ff 	mov    $0xffffffffffffffff,%r10
  8c8f49:	41 d1 e8             	shr    $1,%r8d
  8c8f4c:	c4 e2 39 f7 ff       	shlx   %r8d,%edi,%edi
  8c8f51:	c4 42 c1 f7 c2       	shlx   %rdi,%r10,%r8
  8c8f56:	c4 42 c0 f5 d5       	bzhi   %rdi,%r13,%r10
  8c8f5b:	ff cf                	dec    %edi
  8c8f5d:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  8c8f63:	c4 c2 c3 f7 fa       	shrx   %rdi,%r10,%rdi
  8c8f68:	48 85 ff             	test   %rdi,%rdi
  8c8f6b:	4c 0f 44 c7          	cmove  %rdi,%r8
  8c8f6f:	41 f6 c1 01          	test   $0x1,%r9b
  8c8f73:	4d 0f 45 e8          	cmovne %r8,%r13
  8c8f77:	4d 09 d5             	or     %r10,%r13
  8c8f7a:	4c 8b 54 24 38       	mov    0x38(%rsp),%r10
  8c8f7f:	41 b9 00 01 00 00    	mov    $0x100,%r9d
  8c8f85:	49 8b 7a 08          	mov    0x8(%r10),%rdi
  8c8f89:	49 83 c2 08          	add    $0x8,%r10
  8c8f8d:	42 8b 3c bf          	mov    (%rdi,%r15,4),%edi
  8c8f91:	89 bb 64 01 00 00    	mov    %edi,0x164(%rbx)
  8c8f97:	e9 2e ef ff ff       	jmp    8c7eca <check_lower_drain+0x442a>
  8c8f9c:	64 48 8b 04 25 28 00 	mov    %fs:0x28,%rax
  8c8fa3:	00 00 
  8c8fa5:	48 3b 84 24 30 02 00 	cmp    0x230(%rsp),%rax
  8c8fac:	00 
  8c8fad:	75 15                	jne    8c8fc4 <check_lower_drain+0x5524>
  8c8faf:	48 81 c4 38 02 00 00 	add    $0x238,%rsp
  8c8fb6:	5b                   	pop    %rbx
  8c8fb7:	41 5c                	pop    %r12
  8c8fb9:	41 5d                	pop    %r13
  8c8fbb:	41 5e                	pop    %r14
  8c8fbd:	41 5f                	pop    %r15
  8c8fbf:	5d                   	pop    %rbp
  8c8fc0:	c5 f8 77             	vzeroupper
  8c8fc3:	c3                   	ret
  8c8fc4:	c5 f8 77             	vzeroupper
  8c8fc7:	e8 94 47 f0 ff       	call   7cd760 <__stack_chk_fail@plt>
